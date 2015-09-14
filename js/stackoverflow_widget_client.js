
$(function() {
    init(['10105', '181472', '1984', '16095'], "CYU2EOKOmtp434pvPMA2ww((");

    var activity_root = $("#activity_root");
    CreateActivitiesFeed(activity_root);

    var achievement_root = $("#achievement_root");
    CreateUserAchievementsFeed(achievement_root);

    questions_root = $("#questions_root");
    CreateQuestionsFeed(questions_root);

    [].forEach.call(document.getElementsByTagName("pre"), function(el) {
        el.classList.add("prettyprint");
    });
    prettyPrint();
});