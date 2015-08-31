module Jekyll
  class Page
    attr_accessor :dir
  end


  class TagIndex < Page
    def initialize(site, base, dir, tag)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'
      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'tag_index.html')
      self.data['tag'] = tag
      tag_title_prefix = site.config['tag_title_prefix'] || 'Публикации отмеченные «'
      tag_title_suffix = site.config['tag_title_suffix'] || '»'
      self.data['title'] = "#{tag_title_prefix}#{tag}#{tag_title_suffix}"
    end
  end

  module Generators
    class Pagination < Generator
      # This generator is safe from arbitrary code execution.
      safe true

      # Generate paginated pages if necessary.
      #
      # site - The Site.
      #
      # Returns nothing.
      def generate(site)

        if site.layouts.key? 'tag_index'
          dir = site.config['tag_dir'] || 'tagged'
          site.tags.keys.each do |tag|
            write_tag_index(site, File.join(dir, tag), tag)
          end
        end


        paginate(site, '/latest/index.html', '', '/latest')
        paginate(site, '/community/index.html', 'community', '/community')
        paginate(site, '/it/index.html', 'it', '/it')

        paginate_categories(site, 'tagged', '/_layouts/tag_index.html', '/tagged')

      end

      def write_tag_index(site, dir, tag)
        index = TagIndex.new(site, site.source, dir, tag)
        site.pages << index
      end

      def paginate(site, page_path, category, prefix)
        all_posts = site.posts.sort_by {|post| -post.date.to_f}
        if category != ''
          all_posts = site.site_payload['site']['categories'][category].sort_by {|post| -post.date.to_f}
        end

        # Jekyll.logger.info "Paginate: all posts #{all_posts}"
        page = site.pages.select do |page|
          path = page.dir + "/" + page.name
          path == page_path
        end.first

        pages = Pager.calculate_pages(all_posts, site.config['posts_per_page'].to_i)
        (1..pages).each do |num_page|
          pager = Pager.new(site, num_page, all_posts, pages, page, prefix)
          if num_page > 1
            newpage = Page.new(site, site.source, page.dir, page.name)
            newpage.pager = pager
            newpage.dir = File.join(page.dir, "page#{num_page}")
            site.pages << newpage
          else
            page.pager = pager
          end
        end
      end

      def paginate_categories(site, category_path, category_layout, prefix)
        categories = []

        site.tags.keys.each do |tag|
          categories.push(tag)
        end

        categories.sort!.uniq!

        for category in categories
          all_posts = site.site_payload['site']['tags'][category].sort_by {|post| -post.date.to_f}

          page = site.pages.select do |page|
            path = page.dir + "/" + page.name
            path == category_path + "/" + category + "/index.html"
          end.first
          full_prefix = prefix + "/" + category
          pages = Pager.calculate_pages(all_posts, site.config['posts_per_page'].to_i)
          (1..pages).each do |num_page|
            pager = Pager.new(site, num_page, all_posts, pages, page, full_prefix)
            if num_page > 1
              newpage = TagIndex.new(site, site.source, page.dir, category)
              newpage.pager = pager
              newpage.dir = File.join(page.dir, "page#{num_page}")
              #newpage.render(site.layouts, site.site_payload)
              #newpage.write(site.dest)
              site.pages << newpage
            else
              page.pager = pager
              #page.render(site.layouts, site.site_payload)
              #page.write(site.dest)
            end
          end
        end
      end
    end
  end

  class Pager
    attr_reader :page, :per_page, :posts, :total_posts, :total_pages,
      :previous_page, :previous_page_path, :next_page, :next_page_path

    # Calculate the number of pages.
    #
    # all_posts - The Array of all Posts.
    # per_page  - The Integer of entries per page.
    #
    # Returns the Integer number of pages.
    def self.calculate_pages(all_posts, per_page)
      (all_posts.size.to_f / per_page.to_i).ceil
    end

    # Determine if the subdirectories of the two paths are the same relative to source
    #
    # source        - the site source
    # page_dir      - the directory of the Jekyll::Page
    # paginate_path - the absolute paginate path (from root of FS)
    #
    # Returns whether the subdirectories are the same relative to source
    def self.in_hierarchy(source, page_dir, paginate_path)
      return false if paginate_path == File.dirname(paginate_path)
      return false if paginate_path == Pathname.new(source).parent
      page_dir == paginate_path ||
        in_hierarchy(source, page_dir, File.dirname(paginate_path))
    end

    # Static: Return the pagination path of the page
    #
    # site     - the Jekyll::Site object
    # num_page - the pagination page number
    # target_page - the page where pagination is occurring
    #
    # Returns the pagination path as a string
    def self.paginate_path(site, num_page, target_page)
      return nil if num_page.nil?
      return target_page.url if num_page <= 1
      format = site.config['paginate_path']
      format = format.sub(':num', num_page.to_s)
      ensure_leading_slash(format)
    end

    # Static: Return a String version of the input which has a leading slash.
    #         If the input already has a forward slash in position zero, it will be
    #         returned unchanged.
    #
    # path - a String path
    #
    # Returns the path with a leading slash
    def self.ensure_leading_slash(path)
      path[0..0] == "/" ? path : "/#{path}"
    end

    # Static: Return a String version of the input without a leading slash.
    #
    # path - a String path
    #
    # Returns the input without the leading slash
    def self.remove_leading_slash(path)
      ensure_leading_slash(path)[1..-1]
    end

    # Initialize a new Pager.
    #
    # config    - The Hash configuration of the site.
    # page      - The Integer page number.
    # all_posts - The Array of all the site's Posts.
    # num_pages - The Integer number of pages or nil if you'd like the number
    #             of pages calculated.
    def initialize(site, page, all_posts, num_pages = nil, target_page, prefix)
      @page = page
      @per_page = site.config['posts_per_page'].to_i
      @total_pages = num_pages || Pager.calculate_pages(all_posts, @per_page)

      if @page > @total_pages
        raise RuntimeError, "page number can't be greater than total pages: #{@page} > #{@total_pages}"
      end

      init = (@page - 1) * @per_page
      offset = (init + @per_page - 1) >= all_posts.size ? all_posts.size : (init + @per_page - 1)

      @total_posts = all_posts.size
      @posts = all_posts[init..offset]
      @previous_page = @page != 1 ? @page - 1 : nil

      ppp = Pager.paginate_path(site, @previous_page, target_page)
      if ppp
        if @previous_page <= 1
          @previous_page_path = ppp
        else
          @previous_page_path = prefix + ppp
        end
      else
        @previous_page_path = nil
      end

      @next_page = @page != @total_pages ? @page + 1 : nil

      npp = Pager.paginate_path(site, @next_page, target_page)
      if npp
        if @next_page <= 1
          @next_page_path = npp
        else
          @next_page_path = prefix + npp
        end
      else
        @next_page_path = nil
      end
    end

    # Convert this Pager's data to a Hash suitable for use by Liquid.
    #
    # Returns the Hash representation of this Pager.
    def to_liquid
      {
        'page' => page,
        'per_page' => per_page,
        'posts' => posts,
        'total_posts' => total_posts,
        'total_pages' => total_pages,
        'previous_page' => previous_page,
        'previous_page_path' => previous_page_path,
        'next_page' => next_page,
        'next_page_path' => next_page_path
      }
    end
  end
end