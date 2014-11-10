# Return the time
class Time
	@get_time: ->
		new Date().getTime()
	@start = new Date().getTime()

class Input
	@keys = []
	@keys.push(false) for i in [0...127]
	@keydown: (event) =>
		@keys[event.keyCode] = true
	@keyup: (event) =>
		@keys[event.keyCode] = false
	@get_key: (key) ->
		return @keys[key.charCodeAt(0)] if key?.charCodeAt
		@keys[key]
document.addEventListener('keydown',Input.keydown)
document.addEventListener('keyup',Input.keyup)

class window.Game
	constructor: ->
		@canvas = new Canvas(650, 400, "#000")

		Renderer.init()
		@fps_widget = new FPSWidget(new Vec2(10, 30))
		@camera_control = new CameraControl(@canvas)

		@balls = [
			new Ball 5, new Vec2(10, 10), new Vec2(20, 20), "#F00"
			new Ball 5, new Vec2(50, 30), new Vec2(30, 10), "#0F0"
			new Ball 5, new Vec2(30, 50), new Vec2(10, 30), "#00F"
			new Ball 5, new Vec2(40, 10), new Vec2(25, 25), "#F00"
			new Ball 5, new Vec2(50, 20), new Vec2(35, 15), "#0F0"
			new Ball 5, new Vec2(30, 80), new Vec2(15, 35), "#00F"
		]

		@loop() # Enter the game loop

	# The main game loop
	loop: =>
		@fps_widget.update()
		ball.update() for ball in @balls
		@camera_control.update()
		Renderer.fetch().render(@canvas)
		setTimeout @loop, 20

