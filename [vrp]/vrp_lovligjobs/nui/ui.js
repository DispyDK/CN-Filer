$(document).ready(function() {
	window.addEventListener('message', function(event) {
		var item = event.data;
		if (item.showPlayerMenu == true) {
			$('body').css('background-color', 'transparent');
			$('.container-fluid').css('display', 'block');
		} else if (item.showPlayerMenu == false) {
			$('.container-fluid').css('display', 'none');
			$('body').css('background-color', 'transparent important!');
			$("body").css("background-image", "none");
		}
	});
	$("#taxi").click(function() {
		$.post('http://vrp_lovligjobs/taxi', JSON.stringify({}));
		2
	});
	$("#miner").click(function() {
		$.post('http://vrp_lovligjobs/miner', JSON.stringify({}));
		2
	});
	$("#skovhugger").click(function() {
		$.post('http://vrp_lovligjobs/skovhugger', JSON.stringify({}));
		2
	});
	$("#skraldemand").click(function() {
		$.post('http://vrp_lovligjobs/skraldemand', JSON.stringify({}));
		2
	});
	$("#farmer").click(function() {
		$.post('http://vrp_lovligjobs/farmer', JSON.stringify({}));
		2
	});
	$("#lastbilchauffor").click(function() {
		$.post('http://vrp_lovligjobs/lastbilchauffor', JSON.stringify({}));
		2
	});
	$("#arbejdslos").click(function() {
		$.post('http://vrp_lovligjobs/arbejdslos', JSON.stringify({}));
		2
	});
	$("#pizzabud").click(function() {
		$.post('http://vrp_lovligjobs/pizzabud', JSON.stringify({}));
		2
	});
	$("#closebtn").click(function() {
		$.post('http://vrp_lovligjobs/closeButton', JSON.stringify({}));
		2
	});
})
