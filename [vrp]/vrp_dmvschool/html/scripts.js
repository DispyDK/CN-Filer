$(document).ready(function(){
    // Mouse Controls
    var documentWidth = document.documentElement.clientWidth;
    var documentHeight = document.documentElement.clientHeight;
    var cursor = $('#cursor');
    var cursorX = documentWidth / 2;
    var cursorY = documentHeight / 2;

    //question variables
    var questionNumber = 1;
    var userAnswer = [];
    var goodAnswer = [];
    var questionUsed = [];
    var questions = shuffle(tableauQuestion);
    var nbQuestionToAnswer = 10; // don't forget to change the progress bar max value in html
    var nbAnswerNeeded = 7; // out of nbQuestionToAnswer

    function UpdateCursorPos() {
        $('#cursor').css('left', cursorX);
        $('#cursor').css('top', cursorY);
    }

    function triggerClick(x, y) {
        var element = $(document.elementFromPoint(x, y));
        element.focus().click();
        return true;
    }

    // Partial Functions
    function closeMain() {
        $(".home").css("display", "none");
    }
    function openMain() {
        $(".home").css("display", "block");
    }
    function closeAll() {
        $(".body").css("display", "none");
    }
    function openQuestionnaire() {
        $(".questionnaire-container").css("display", "block");
        $("#questionNumero").html("Spørgsmål");
        $("#question").html(questions[questionNumber].question);
        $(".answerA").html(questions[questionNumber].propositionA);
        $(".answerB").html(questions[questionNumber].propositionB);
        $(".answerC").html(questions[questionNumber].propositionC);
        $(".answerD").html(questions[questionNumber].propositionD);
        $('input[name=question]').attr('checked',false);
        goodAnswer.push(questions[questionNumber].reponse);
        $(".questionnaire-container .progression").val(questionNumber-1);
    }
    function openResultGood() {
        $(".resultGood").css("display", "block");
    }
    function openResultBad() {
        $(".resultBad").css("display", "block");
    }
    function openContainer() {
        $(".question-container").css("display", "block");
        $("#cursor").css("display", "block");
    }
    function closeContainer() {
        $(".question-container").css("display", "none");
        $("#cursor").css("display", "none");
    }
    // Listen for NUI Events
    window.addEventListener('message', function(event){
        var item = event.data;
        // Open & Close main gang window
        if(item.openQuestion == true) {
            openContainer();
            openMain();
        }
        if(item.openQuestion == false) {
            closeContainer();
            closeMain();
        }
        // Open sub-windows / partials
        if(item.openSection == "question") {
            questionNumber = 1;
            userAnswer = [];
            goodAnswer = [];
            questions = shuffle(tableauQuestion);
            closeAll();
            openQuestionnaire();
        }
        if (item.type == "click") {
            triggerClick(cursorX - 1, cursorY - 1);
        }
    });

    $(document).mousemove(function(event) {
        cursorX = event.pageX;
        cursorY = event.pageY;
        UpdateCursorPos();
    });

    // Handle Button Presses
    $(".btnQuestion").click(function(){
        $.post('http://vrp_dmvschool/question', JSON.stringify({}));
    });
    $(".btnClose").click(function(){
        $.post('http://vrp_dmvschool/close', JSON.stringify({}));
    });
    $(".btnKick").click(function(){
        $.post('http://vrp_dmvschool/kick', JSON.stringify({}));
    });


    // Handle Form Submits
    var delayLort = false;
    $("#question-form").submit(function(e) {
        e.preventDefault();
        e.stopImmediatePropagation();
        if($('#question-form input[type=radio]:checked').size() > 0) {
            if(questionNumber!=nbQuestionToAnswer){
                //question 1 to 9 : pushing answer in array
                if(!delayLort) {
                    closeAll();
                    userAnswer.push($('input[name="question"]:checked').val());
                    questionNumber++;
                    delayLort = true;
                    $("#question-error").text("");
                    openQuestionnaire();
                    setTimeout(function () {delayLort = false},100)
                }
            }
            else {
                // question 10 : comparing arrays and sending number of good answers
                userAnswer.push($('input[name="question"]:checked').val());
                var nbGoodAnswer = 0;
                for (i = 0; i < nbQuestionToAnswer; i++) {
                    if (userAnswer[i] == goodAnswer[i]) {
                        nbGoodAnswer++;
                    }
                }
                closeAll();
                if(nbGoodAnswer >= nbAnswerNeeded) {
                    openResultGood();
                }
                else{
                    openResultBad();
                }
            }
        }else{
            if(!delayLort) {
                $("#question-error").text("Fejl: Du skal vælge en!");
            }
        }
    });

    function shuffle(a) {
        for (let i = a.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [a[i], a[j]] = [a[j], a[i]];
        }
        return a;
    }
});
