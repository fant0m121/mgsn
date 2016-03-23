$window = $(window)
$root = $('.b-page')
$header = $('.js-header')
$menuItems = $('a[href^="#"].js-scroll-animate')

scrollItems = $menuItems.map ->
	item = $($(this).attr("href"))
	if (item.length)
		return item

$menuItems.click ->
	href = $.attr(this, 'href')
	$('html, body').animate { scrollTop: $(href).position().top + $('html, body').scrollTop() - 104 }, 500, ->
		window.location.hash = href
		return
	false


$window.scroll ->
	fromTop = $(this).scrollTop() + 104


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
	scrollTop = $root.scrollTop()

	if scrollTop > 0
		$header.addClass('b-page__line--fixed')
		$root.addClass('b-page--fixed')
	else
		$header.removeClass('b-page__line--fixed')
		$root.removeClass('b-page--fixed')

setClass();

$window.on 'scroll', throttle(setClass, 100)

$('#js-countdown').countdown({
	timestamp: new Date('2016', '03', '24'),
	callback: (days, hours, minutes, seconds)->
		
});


$('.b-input--blue, .b-input--checkbox, .b-input--green').styler();

$('.js-carousel').owlCarousel({
    loop:true,
    nav:true,
    dots:false,
    margin: 40,
    responsiveClass:true,
    responsive:{
        0:{
            items:1,
            nav:true
        },
        600:{
            items:2,
            nav:false
        },
        1000:{
            items:3,
            nav:true,
            loop:false
        }
    }
})
