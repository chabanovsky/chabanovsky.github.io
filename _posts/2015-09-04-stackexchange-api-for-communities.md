---
layout: post
title: Stack Exchange API для сообществ
excerpt: Пример использования Stack Exchange API для создания страницы активности участников сообщества
big_image: /assets/images/stackexchange_api_big.png
small_image: /assets/images/stackexchange_api_small.png
location: Нью Йорк
tags:
- stackexchange-api
- stackoverflow
categories:
- community
- it
---

<link rel="stylesheet" href="/assets/google-code-prettify/prettify.css">
<link rel="stylesheet" href="/css/stackoverflow_widget.css"/>
<link rel="stylesheet" href="/css/extra.css"/>
<script src="/assets/google-code-prettify/prettify.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script type="text/javascript" charset="utf-8" src="/js/stackoverflow_widget.js"></script>
<script type="text/javascript" charset="utf-8" src="/js/stackoverflow_widget_client.js"></script>

### Свободный обмен знаниями

Знания накапливаются и передаются от поколения к поколению. С появлением информационных технологий процесс накопления знаний стал намного эффективней, а Интернет стал каналом доступа к ним для масс. Так, если ещё 200 лет назад книги были роскошью элиты, то сегодня все, кто имеют доступ к Сети, могут найти практически любую литературу. Теперь каждый имеет возможность самостоятельно выбирать своё будущее. В последние годы широкое распространение получила модель обмена знаниями и опытом между людьми на бескорыстной основе. Как результат, сегодня каждый может воспользоваться такими уникальными проектами, как, например, Википедия или Stack Overflow.

Меняется и модель обмена знаниями в реальной жизни - появляется большое количество самоорганизующихся тематических сообществ и конференций.

### Самоорганизующиеся технические сообщества

Некоммерческие сообщества, посвящённые какой-либо технологии, которые обязаны своим существованием благодетельности основателей и тем, кто благородно посвящает своё время тому, чтобы другие люди имели возможность получать знания.

Для организации встречи сообщества необходимо: подобрать удобное место проведения, найти интересных докладчиков, подготовить материалы встречи, а затем опубликовать их  в свободный доступ и, конечно же, организовать слушателей. Организация слушателей и поддержка их интереса к встречам может вызывать значительные осложнения. В классическом понимании это ни что иное как «удержание аудитории». Коммерческие организации закладывают бюджет на ведение корпоративных блогов, учётных записей в социальных сетях и т. д., что позволяет им наращивать аудиторию, не увеличивая затрат на рекламу. Для некоммерческих сообществ работа с уже имеющейся аудиторией на порядок важнее, так как денег на рекламу у них просто нет вообще.

> __В__: Каким же образом организаторам некоммерческих сообществ поддерживать интерес слушателей, не неся издержек?
>
> __О__: Предоставить возможность самим участникам делиться своими профессиональными достижениями!

###  Трансляция информации об активности участников сообщества

Сообщество - группа людей, имеющих общие интересы<sup>[1][1]</sup>. Один из лучших способов поддержания интереса к сообществу - непрерывно отображать активность его участников.

На мой взгляд, прекрасным источником такой информации является сайт вопросов и ответов для программистов Stack Overflow. Для русскоязычных сообществ наибольший интерес может представлять его русскоязычная часть.

_Что даст вашему сообществу добавление трансляции активности участников на Stack Overflow на русском?_

  - Поддержать уровень вовлечения в сообщество участников без затрат на создание содержимого (а-ля «контента»).
  - Показать, что сообщество живое.
  - Отобразить квалификацию докладчиков и участников.
  - Сблизить сообщество.


_Что может быть интересно участникам вашего сообщества?_

  - Профессиональная активность сообщества.
  - Квалификация докладчиков: репутация, лучшие ответы.
  - Общий уровень знаний участников: задаваемые вопросы, публикуемые ответы.


_Что необходимо для работы со Stack Exchange API?_

  - Получить ключ доступа к Stack Exchange API.
  - Id учётных записей на Stack Overflow на русском участников, чью информацию вы бы хотели транслировать.

### Ближе к делу! Пример реализации

Давайте рассмотрим, как добавить трансляцию информации об активности пользователей сообщества. В качестве примера возьмём четыре учётные записи.

   - VladD ([`http://ru.stackoverflow.com/users/10105/vladd`](http://ru.stackoverflow.com/users/10105/vladd));
   - Nick Volynkin ([`http://ru.stackoverflow.com/users/181472/nick-volynkin`](http://ru.stackoverflow.com/users/181472/nick-volynkin));
   - Nofate ([`http://ru.stackoverflow.com/users/1984/nofate`](http://ru.stackoverflow.com/users/1984/nofate));
   - Etki ([`http://ru.stackoverflow.com/users/16095/etki`](http://ru.stackoverflow.com/users/16095/etki)).

<sub>Это участники сообщества Stack Overflow на русском, которым я крайне симпатизирую (и не только им). День за днем удивляюсь их знаниям и эрудированности. В сложные для проекта времена именно такие ребята были и остаются для меня источником вдохновения.</sub>


__Получение ключа__

Первым шагом является регистрация на [http://stackapps.com/](http://stackapps.com/). В боковой панели раздела «приложения» («apps») вы можете найти ссылку на [документацию](https://api.stackexchange.com/docs), [регистрацию нового приложения](http://stackapps.com/apps/oauth/register) или управления существующими.

__Идентификаторы учётных записей участников__

При регистрации в вашем сообществе, попроситье участников добавить ссылку на их учётную запись на Stack Overflow на русском. Для меня идентификаторами будут `['10105', '181472', '1984', '16095']`.

__Активность участников на Stack Overflow на русском__

Вопросы и ответы - это основные типы сообщений на сайте. Для формирования активности участников необходимо [запросить все сообщения, опубликованные ими](http://api.stackexchange.com/docs/posts-on-users).

    http://api.stackexchange.com/2.2/users/{ids}/posts?order=desc&sort=activity&site=ru.stackoverflow

<sub>Обратите внимание: *при запросе к серверу идентификаторы перечисляются через __;__*.</sub>

В ответ сервер отдает словарь:

    {
      "items": [
        {
          "owner": {
            "reputation": integer,
            "user_id": integer,
            "user_type": string,
            "accept_rate": integer,
            "profile_image": string,
            "display_name": string,
            "link": string
          },
          "score": integer,
          "last_activity_date": integer,
          "creation_date": integer,
          "post_type": string,
          "post_id": integer,
          "link": string
        },
        ...
      ],
      ...
    }

В системе есть три типа сообщений:

   - вопросы, "post_type" - "question";
   - ответы, "post_type" - "answer";
   - комментарии, "post_type" - "comment".

Обрабатывая данные запроса, следует дополнительно запрашивать информацию о сообщении в зависимости от его типа (поле `post_type`). В случае вопроса, мы будем выводить заголовок вопроса, метки, дату публикации. Запрос к серверу на получение ответов выглядит следующим образом.

    http://api.stackexchange.com/2.2/questions/{ids}?order=desc&sort=activity&site=ru.stackoverflow

В ответ сервер вернет словарь запрошенных вопросов (в нашем случае, один вопрос с id равный 1).

    {
      "items": [
        {
          "tags": dictionary,
          "owner": {
            "reputation": integer,
            "user_id": integer,
            "user_type": string,
            "profile_image": string,
            "display_name": string,
            "link": string
          },
          "is_answered": bool,
          "view_count": integer,
          "accepted_answer_id": integer,
          "answer_count": integer,
          "community_owned_date": integer,
          "score": integer,
          "last_activity_date": integer,
          "creation_date": integer,
          "last_edit_date": integer,
          "question_id": integer,
          "link": string,
          "title": string
        },
        ...
      ],
      ...
    }

В случае ответа, нам необходимо запросить и вопрос, и ответ, так как у ответа нет заголовка. Вопрос получаем также, как и в предыдущем случае, а ответ следующим запросом.

    http://api.stackexchange.com/2.2/answers/{ids}?order=desc&sort=activity&site=ru.stackoverflow

Ответ сервера:

    {
      "items": [
        {
          "owner": {
            "reputation": integer,
            "user_id": integer,
            "user_type": string,
            "accept_rate": integer,
            "profile_image": string,
            "display_name": string,
            "link": string
          },
          "is_accepted": bool,
          "score": integer,
          "last_activity_date": integer,
          "last_edit_date": integer,
          "creation_date": integer,
          "answer_id": integer,
          "question_id": integer
        },
        ...
      ],
      ...
    }

С помощью этих запросов за несколько минут можно сформировать html-блок активности участников. Возможно, вы захотите подчеркнуть даты, добавить точное время или любую другую информацию.

<div class="example" id="activity_root"></div>

__Квалификация участников__

Для отображения квалификации участника, мы можем воспользоваться шаблоном страницы учётной записи на Stack Overflow на русском (например, [моя страница](http://ru.stackoverflow.com/users/6/nicolas-chabanovsky?tab=profile)).

Первый шаг - запрос учетных записей.

    http://api.stackexchange.com/2.2/users/{ids}?order=desc&sort=reputation&site=ru.stackoverflow

В моем примере наибольший интерес для нас представляет имя пользователя и репутация.

    {
      "items": [
        {
          "badge_counts": {
            "bronze": integer,
            "silver": integer,
            "gold": integer
          },
          "account_id": integer,
          "is_employee": bool,
          "last_modified_date": integer,
          "last_access_date": integer,
          "age": integer,
          "reputation_change_year": integer,
          "reputation_change_quarter": integer,
          "reputation_change_month": integer,
          "reputation_change_week": integer,
          "reputation_change_day": integer,
          "reputation": integer,
          "creation_date": integer,
          "user_type": string,
          "user_id": integer,
          "accept_rate": integer,
          "location": string,
          "website_url": string,
          "link": string,
          "profile_image": string,
          "display_name": string
        },
        ...
      ],
      ...
    }

Далее нам надо запросить вопросы и ответы участника, отсортированные по количеству голосов, а затем метки, в которых он (она) отличился наиболее значимо. Вопросы и ответы запрашиваются аналогичным образом, как и в предыдущем примере, кроме одного нюанса. Если запросить ответ через `http://api.stackexchange.com/2.2/answers/{ids}`, то почему-то сервер не добавляет ссылку на ответ. Чтобы это исправить, нам необходимо дополнительно запросить информацию о нем через `http://api.stackexchange.com/2.2/posts/{ids}`. Моя функция формирования списка ответов выглядит следующим образом.

    function createUserAnswerActivities(item) {
        var answers = document.createElement("div");
        getUsersAnswers(item.user_id, sort_score,
            function(response){
                if (response == null)
                    return;

                for (var index = 0; index < response.items.length; index++) {
                    var item = response.items[index];

                    getPosts(item.answer_id, sort_score, item, function (context, sub_response) {
                        if (sub_response == null || sub_response.items.length != 1)
                            return;

                        getQuestionItemHelper(context.question_id, sub_response.items[0], function(content){
                            $(answers).append(content);
                        },
                        function (initial_item, response_item) {
                            return createUserActivityItem(response_item.title, initial_item.link, initial_item.score);
                        });

                    }, errorHandler);
                }

            }, errorHandler, best_posts_page_size);

        return answers;
    }

Лучшие метки можно получить отправив запрос по адресу:

    http://api.stackexchange.com/2.2/users/{ids}/top-tags?site=ru.stackoverflow

Обратите внимание, что в запросе мы не указываем сортировку. Ответ сервера:

    {
      "items": [
        {
          "user_id": integer,
          "answer_count": integer,
          "answer_score": integer,
          "question_count": integer,
          "question_score": integer,
          "tag_name": string
        },
       ...
      ],
      ...
    }

Результат.

<div class="example" id="achievement_root"></div>

__Общий уровень знаний участников: задаваемые вопросы, публикуемые ответы__

Одной из самых простых задач является формирование списка вопросов и ответов участников сообщества. Для простоты создадим трансляцию вопросов участников. Получить список вопросов можно отправив запрос по адресу

    http://api.stackexchange.com/2.2/users/{ids}/questions?order=desc&sort=activity&site=ru.stackoverflow

Единственное «но», на сколько я понимаю, получить текст вопросов нельзя. Результат.

<div class="example" id="questions_root"></div>

__Вопросы и ответы по метке__

В завершении, мы можем сформировать ленту лучших вопросов и ответов участников по метке. Все тоже самое, как и раньше, только другой url.

    http://api.stackexchange.com/2.2/users/{ids}/tags/{tags}/top-questions?order=desc&sort=activity&site=ru.stackoverflow

---

<sub>Полный код примеров вы можете найти на [GitHub](https://github.com/chabanovsky/stackoverflow_community_widget) или в ресурсах данной страницы.</sub>

### Постскриптум

Все то, что делают ребята, которые организуют тематические встречи, локальные группы пользователей, конференции, не может не вдохновлять. Они тратят огромное количество времени для того, чтобы мы с вами получали знания.

С аналогичным оптимизмом подходят к вопросу «обучения сообществом» и свободным знаниям участники Stack Overflow на русском. Пожалуйста, обратите внимание на публикацию на Мете «[Поддержка «местных сообществ» знаниями](http://meta.ru.stackoverflow.com/questions/883/)», и не стесняйтесь обращаться, если вам необходимы докладчики.

Давайте делиться знаниями вместе!

  [1]: https://ru.wikipedia.org/wiki/%D0%A1%D0%BE%D0%BE%D0%B1%D1%89%D0%B5%D1%81%D1%82%D0%B2%D0%BE