$window = $(window)
$root = $('.b-page')
$header = $('.js-header')
$menu = $('.js-menu')
$menuItems = $('a[href^="#"].js-scroll-animate')

scrollItems = $menuItems.map ->
	item = $($(this).attr("href"))
	if (item.length)
		return item

$menuItems.click ->
	href = $.attr(this, 'href')
	$('html, body').animate { scrollTop: $(href).position().top + $('html, body').scrollTop() - 77 }, 500, ->
		window.location.hash = href
		return false


$window.scroll ->
	fromTop = $(this).scrollTop() + 77


	cur = scrollItems.map ->
		if ($(this).offset().top <= fromTop)
			return this;

	cur = cur[cur.length-1]
	
	
	if(cur && cur.length)
		id = cur[0].id
	else
		id = ""

	if (lastId != id)
		lastId = id
		$menuItems.removeClass("b-menu__item--active").parent().end().filter("[href='#"+id+"']").addClass("b-menu__item--active")


	

throttle = (callback, limit) ->
	wait = false
	->
		return if wait

		wait = true
		callback.call()

		setTimeout (->
			wait = false

			setTimeout (->
				callback.call() unless wait
			), limit
		), limit

setClass = () ->
	scrollTop = $window.scrollTop()

	if scrollTop > 104
		$header.addClass('b-page__line--fixed')
		$root.addClass('b-page--fixed')
	else
		$header.removeClass('b-page__line--fixed')
		$root.removeClass('b-page--fixed')

setClass();

$window.on 'scroll', throttle(setClass, 100)

$('.js-menu-toggle').click ->
	$menu.toggle()

$('.js-show-modal').click (event) ->
		event.preventDefault();

		$.magnificPopup.open({
			items: {
				src: $(this).attr('href')
			},
			type: 'inline'
		});


$('#js-countdown').countdown({
	timestamp: new Date('2016', '03', '08'),
	callback: (days, hours, minutes, seconds)->
		
});

$('input[name="phone"]').mask('+7 (999) 999-99-99');

$('.b-input--blue, .b-input--checkbox, .b-input--green').styler();

$('.js-carousel').owlCarousel({
    loop: true,
    autoPlay: true,
    nav:true,
    dots:false,
    margin: 10,
    responsiveClass:true,
    responsive:{
        0:{
            items:1,
            nav:true
        },
        600:{
            items:2,
            nav:true
        },
        1000:{
            items:3,
            nav:true
        }
    }
})

$('.js-form-main').on('submit', (e) ->

	formData = $(this).serializeObject();
	sendData =
		potential_customer: formData,
	

	$.ajax({
		type: 'POST'
		url: '/ajax/form-main/'
		data: JSON.stringify(sendData)
		contentType: "application/json"
		dataType: 'json'
		success: () ->
			$('.js-form-main').find('.b-form__fieldset').hide()
			$('.js-success-main').show()

		error: (e) ->
			console.log(e)
			$('.js-form-main').find('.b-form__fieldset').hide()
			$('.js-success-main').show()
			
	});

	e.preventDefault();
)

$('.js-send-email').on('submit', (e) ->

	formData = $(this).serializeObject();
	sendData =
		potential_customer: formData,
	

	$.ajax({
		type: 'POST'
		url: '/ajax/form-phone/'
		data: JSON.stringify(sendData)
		contentType: "application/json"
		dataType: 'json'
		success: () ->
			$(this).find('.b-form__fieldset').hide()
			$(this).find('.js-success-phone').show()

		error: (e) ->
			console.log(e)
			$('.js-form-phone').find('.b-form__fieldset').hide()
			$('.js-success-phone').show()
			
	});

	e.preventDefault();
)

$('.js-form-order').on('submit', (e) ->

	formData = $(this).serializeObject();
	calcData = $('.js-form-calc').serializeObject();
	sendData =
		potential_customer: formData,
		calc_data: calcData
	

	$.ajax({
		type: 'POST'
		url: '/ajax/form-calc/'
		data: JSON.stringify(sendData)
		contentType: "application/json"
		dataType: 'json'
		success: () ->
			$('.js-form-calc').find('.b-form__fieldset--colum').hide()
			$('.js-success-calc').show()

			$('.js-form-order').find('.b-form__fieldset').hide()
			$('.js-success-order').show()

		error: (e) ->
			console.log(e)
			$('.js-form-calc').find('.b-form__fieldset').hide()
			$('.js-success-calc').show()
			
	});

	e.preventDefault();
)

$('.js-form-callback').on('submit', (e) ->

	formData = $(this).serializeObject();
	sendData =
		potential_customer: formData,
	

	$.ajax({
		type: 'POST'
		url: '/ajax/form-callback/'
		data: JSON.stringify(sendData)
		contentType: "application/json"
		dataType: 'json'
		success: () ->
			$('.js-form-callback').find('.b-form__fieldset').hide()
			$('.js-success-callback').show()

		error: (e) ->
			console.log(e)
			$('.js-form-callback').find('.b-form__fieldset').hide()
			$('.js-success-callback').show()
			
	});

	e.preventDefault();
)

$('.js-form-review').on('submit', (e) ->

	formData = $(this).serializeObject();
	sendData =
		potential_customer: formData,
	

	$.ajax({
		type: 'POST'
		url: '/ajax/form-review/'
		data: JSON.stringify(sendData)
		contentType: "application/json"
		dataType: 'json'
		success: () ->
			$('.js-form-review').find('.b-form__fieldset').hide()
			$('.js-success-review').show()

		error: (e) ->
			console.log(e)
			$('.js-form-review').find('.b-form__fieldset').hide()
			$('.js-success-review').show()
			
	});

	e.preventDefault();
)

$('.js-form-sms').on('submit', (e) ->

	formData = $(this).serializeObject();
	sendData =
		potential_customer: formData,
	

	$.ajax({
		type: 'POST'
		url: '/ajax/form-sms/'
		data: JSON.stringify(sendData)
		contentType: "application/json"
		dataType: 'json'
		success: () ->
			$('.js-form-sms').find('.b-form__fieldset--colum').hide()
			$('.js-success-sms').show()

		error: (e) ->
			console.log(e)
			$('.js-form-sms').find('.b-form__fieldset--colum').hide()
			$('.js-success-sms').show()
			
	});

	e.preventDefault();
)