
var user_ids = [];
var site_url = "ru.stackoverflow";
var se_api_url = "api.stackexchange.com/2.2/";
var request_protocol = "http://"
var api_key = ""

var page_size = 7;
var sort = "creation"

function init(ids, key) {
	user_ids = ids;
	api_key = key;
}

function CreateQuestionsFeed(root_element) {
    for (var i = 0; i < user_ids.length; i++ ){
        id = user_ids[i];
        getUserQuestions(id,
        	function(response){
        	    if (response == null || !response.has_more)
        	        return;

                for (var j = 0; j < response.items.length; j++) {
                    item = response.items[j];
                    question = createQuestionFromResponse(item);
                    $(root_element).append(question);
                }

        	}, function (){
                $(root_element).append("Error");
        });
    }
}

function getUserQuestions(id, successLoadHandler, errorLoadHandler) {
	final_url = request_protocol + se_api_url + "users/" + id + "/questions?order=desc&sort=" + sort + "&site=" + site_url + "&pagesize=" + page_size + "&key=" + api_key;
    $.ajax({
        type: 'GET',
        url: final_url,
        success: successLoadHandler,
    	error: errorLoadHandler
    });
}

function createQuestionFromResponse(item) {
    var main_div = document.createElement("div");
    $(main_div).addClass("question");

    left_side = createQuestionStatus(item);
    $(main_div).append(left_side);

    right_side = createQuestionDescription(item);
    $(main_div).append(right_side);

    return main_div;
}

function createQuestionStatus(item) {
    var stats_container = document.createElement("div");
    $(stats_container).addClass("stats_container");
    $(stats_container).attr("onclick", "window.location.href='" + item.link + "'");

    var votes = document.createElement("div");
    $(votes).addClass("votes");

    var votes_count = document.createElement("div");
    $(votes_count).addClass("count");
    $(votes_count).append(item.score);
    var votes_count_word = document.createElement("div");
    $(votes_count_word).append(plural(parseInt(item.score), ["голос", "голоса", "голосов"]));

    $(votes).append(votes_count);
    $(votes).append(votes_count_word);

    var status = document.createElement("div");
    $(status).addClass("status");
    if (item.is_answered)
        $(status).addClass(" answered");

    var answer_count = document.createElement("div");
    $(answer_count).append(item.answer_count);
    $(answer_count).addClass("count");
    var answer_count_word = document.createElement("div");
    $(answer_count_word).append(plural(parseInt(item.answer_count), ["ответ", "ответа", "ответов"]));

    $(status).append(answer_count);
    $(status).append(answer_count_word);

    var views = document.createElement("div");
    $(views).addClass("views");

    var views_count = document.createElement("div");
    $(views_count).append(item.view_count);
    $(views_count).addClass("count");
    var views_count_word = document.createElement("div");
    $(views_count_word).append(plural(parseInt(item.view_count), ["показ", "показа", "показов"]));

    $(views).append(views_count);
    $(views).append(views_count_word);

    $(stats_container).append(votes);
    $(stats_container).append(status);
    $(stats_container).append(views);

    return stats_container;
}

function createQuestionDescription(item) {
    var desc = document.createElement("div");
    $(desc).addClass("desc");

    var h3_title = document.createElement("h3");
    var a_title = document.createElement("a");
    $(a_title).attr("href", item.link);
    $(a_title).text(item.title);

    $(h3_title).append(a_title);

    var tags = document.createElement("div");
    $(tags).addClass("tags");

    for (var i = 0; i < item.tags.length; i++) {
        var tag = document.createElement("span");
        $(tag).addClass("post-tag");
        $(tag).text(item.tags[i]);

        $(tags).append(tag);
    }

    var owner = document.createElement("div");
    $(owner).addClass("owner");

    var last_active = document.createElement("span");
    var active = new Date(parseInt(1000 * item.creation_date));
    $(last_active).text("задан " + getDate(active) + " ");
    var author = document.createElement("a");
    $(author).attr("href", item.owner.link);
    $(author).text(item.owner.display_name);

    $(owner).append(last_active);
    $(owner).append(author);

    $(desc).append(h3_title);
    $(desc).append(tags);
    $(desc).append(owner);

    return desc;
}

function plural(n, forms) {
	return forms[n%10==1 && n%100!=11 ? 0 : n%10>=2 && n%10<=4 && (n%100<10 || n%100>=20) ? 1 : 2];
}

function getDate(date) {
   var yyyy = date.getFullYear().toString();
   var mm = (date.getMonth()+1).toString();
   var dd = date.getDate().toString();

   return yyyy + " " + (mm[1]?mm:"0"+mm[0]) + " " + (dd[1]?dd:"0"+dd[0]);
}