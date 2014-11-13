
class window.Game
	constructor: ->
		Renderer.init(650, 400, "#000000")

		@objects = []
		@fps_widget = new FPSWidget(new Vec2(0, Renderer.height - 20))
		@objects.push(@fps_widget)
		@objects.push(new CameraControl())

		@objects.push(new Droid(new Vec2(0, 0), "#0F0"))

		Renderer.transforms[0].scale(0.1, 0.1)

		@loop() # Enter the game loop

	# The main game loop
	loop: =>
		Time.update()
		object.update() for object in @objects
		Renderer.render()
		setTimeout @loop, 0

