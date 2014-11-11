
class window.Game
	constructor: ->
		Renderer.init(650, 400, "#000000")

		@fps_widget = new FPSWidget(new Vec2(0, 20))
		#@camera_control = new CameraControl(@canvas)

		@balls = [
			new Ball 5, new Vec2(0, 0), new Vec2(0, 0), "#F00"
			new Ball 5, new Vec2(3, 0), new Vec2(0, 0), "#0F0"
			new Ball 5, new Vec2(0, -3), new Vec2(0, 0), "#00F"
		]

		Renderer.transforms[0].scale(0.1, 0.1)

		@loop() # Enter the game loop

	# The main game loop
	loop: =>
		@fps_widget.update()
		ball.update() for ball in @balls
		#@camera_control.update()
		Renderer.render()
		setTimeout @loop, 20

