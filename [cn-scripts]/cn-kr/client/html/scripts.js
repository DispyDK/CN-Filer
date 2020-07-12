$(document).ready(function () {
  window.addEventListener('message', function (event) {
    var item = event.data;
    if (item.show == true) {
      openHome();
    }
    if (item.show == false) {
      close();
    }

    if(item.efterlys == true) {

      var element = $("Loaded");
      var obj = JSON.parse(item.efterlysning);
      var efterlyst = "";
      for (var i = 0; i < obj.length; i++) {
        efterlyst = efterlyst + "<b>" + obj[i].reason + "</b> - " + obj[i].by + " - " + obj[i].time + "<hr>";
      }
      document.getElementById("efterlysninger").innerHTML = efterlyst

    }

    if(item.bode == true) {

      var element = $("Loaded");
      var obj = item.boder;
      var res = obj.replace("<br />", "<br>");
      // var res2 = res.replace("[Bøde]", "<b>[Bøde]</b>");
      var res2 = res.split("[Bøde]").join("<b>[Bøde]</b>")
      document.getElementById("boder").innerHTML = res2

    }

    if(item.register == true) {

      var element = $("Loaded");
      var arr = item.personregister;
      if (arr.driverlicense == "Nej" || arr.driverlicense == "Frakendt") {
        arr.driverhtml = '<button type="button" class="btnTildel" name="button">Tildel kørekort</button>';
      }
      else {
        arr.driverhtml = '<button type="button" class="btnFrakend" name="button">Frakend kørekort</button>';
      }
      var name = '<b>Navn:</b> ' + arr.firstname + " " + arr.name;
      var cpr = '<b>CPR:</b> ' + arr.cpr;
      var age = '<b>Alder:</b> ' + arr.age;
      var phone = '<b>Telefonnr.:</b> ' + arr.phone;
      var driverlicense = '<b>Kørekort:</b> ' + arr.driverlicense;
      var home = '<b>Adresse.:</b> ' + arr.home + " nr. " + arr.number;
      var bname = '<b>Firmanavn.:</b> ' + arr.bname + " - Kapital: " + arr.bcapital + " kr.";
      var plate = '<b>Nummerplade:</b> ' + arr.registration;
      var clips = '<b>Antal klip:</b> ' + arr.driver_clips;
      var user_id = '<b>CPR ID:</b> ' + arr.user_id;

      // var job = '<b>Job: ' + arr.job;

      var register = name + "<br>" + cpr + "<br>" + age + "<br>" + phone + "<br>" + driverlicense + "<br>" + home + "<br>" + bname + "<br>" + plate + "<br>" + clips + "<br>" + user_id;

      document.getElementById("personregister").innerHTML = register;
      // document.getElementById("btnFrakend").style.display = "block";
      document.getElementById("btnBode").style.display = "block";
      document.getElementById("btnKlip").style.display = "block";
      document.getElementById("user_id").innerHTML = arr.user_id;
      $("#user_id").val(arr.cpr);

    }

    if(item.koretoj == true) {

      var element = $("Loaded");
      var obj = item.koretojer;
      var koretoj = "";
      for (var i = 0; i < obj.length; i++) {
        if (obj[i].veh_type === "default") {
          obj[i].veh_type = "Job køretøj (Kan være båd)";
        }
        if (obj[i].veh_type === "car") {
          obj[i].veh_type = "Bil";
        }
        if (obj[i].veh_type === "bike") {
          obj[i].veh_type = "Motorcykel/cykel";
        }
        koretoj = koretoj + "<b>" + obj[i].vehicle_name + "</b> ("+obj[i].vehicle+") - " + obj[i].veh_type + "<br>";
      }
      document.getElementById("koretojer").innerHTML = koretoj

    }
  });
  document.onkeyup = function (data) {
    if (data.which == 27) {
      $.post('http://cn-kr/close', JSON.stringify({}));
      reset();
    }
  };
  $(".btnClose").click(function () {
    $.post('http://cn-kr/close', JSON.stringify({}));
    reset();
  });


  $(".btnFrakend").click(function () {
    var id = $("#user_id").val();
    $.post('http://cn-kr/frakend', JSON.stringify({id}));
  });


  $(".btnBode").click(function () {
    document.getElementById("kr_sagsbehandler").innerHTML = "<input type='text' id='kr_sagsbehandler1' placeholder='Sagsbehandler'>";
    document.getElementById("kr_medvirkende").innerHTML = "<input type='text' id='kr_medvirkende1' placeholder='Medvirkende'>";
    document.getElementById("kr_rapport").innerHTML = "<textarea type='text' id='reason'>Sigtelser:\n\nMagtmidler brugt:\n\nBøde:\n\nFængsel:\n\nResume:\n\nBeslaglagte ting:</textarea>";
    document.getElementById("kr_sagsbehandler").style.display = "block";
    document.getElementById("kr_medvirkende").style.display = "block";
    document.getElementById("kr_rapport").style.display = "block";
    document.getElementById("btnOpretBode").style.display = "block";
  });

  $(".btnKlip").click(function () {
    document.getElementById("kr_klip").innerHTML = "Klip tilføjet til personen.";
    document.getElementById("kr_klip").style.display = "block";
    var id = $("#inputEfterlysning").val();
    $.post('http://cn-kr/givklip', JSON.stringify({id}));
  });

function reset() {
  document.getElementById("kr_sagsbehandler").style.display = "none";
  document.getElementById("kr_medvirkende").style.display = "none";
  document.getElementById("kr_rapport").style.display = "none";
  document.getElementById("btnOpretBode").style.display = "none";
  document.getElementById("kr_klip").style.display = "none";
}

    $(".btnOpretBode").click(function () {
      var id = $("#user_id").val();
      var taker = $("#kr_sagsbehandler1").val();
      var taker2 = $("#kr_medvirkende1").val();
      var reason = $("#reason").val();

      var check = $("#reason").val();
      console.log(check)
      if (check !== "Sigtelser:\n\nMagtmidler brugt:\n\nBøde:\n\nFængsel:\n\nResume:\n\nBeslaglagte ting:") {

        $.post('http://cn-kr/bode', JSON.stringify({id,reason,taker,taker2}));
        $("#reason").val("Sigtelser:\n\nMagtmidler brugt:\n\nBøde:\n\nFængsel:\n\nResume:\n\nBeslaglagte ting:");

      }
    });

  //Hent efterlysninger ud fra id (beta)

  $(".bntEfterlysning").click(function () {
    var value = $("#inputEfterlysning").val();
    $.post('http://cn-kr/efterlysning', JSON.stringify({value}));
    //Reset alt

    reset();
    document.getElementById("efterlysninger").innerHTML = "Ingen efterlysninger fundet";
    document.getElementById("personregister").innerHTML = "";
    document.getElementById("koretojer").innerHTML = "Ingen køretøjer fundet";
    document.getElementById("boder").innerHTML = "";

    // document.getElementById("efterlysninger").innerHTML = "Test";

  });


});

function openHome() {
  $("body").css("display", "block");
}

function close() {
  $("body").css("display", "none");
}
