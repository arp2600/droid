
class window.Game
	@start: ->
		Renderer.init(document.body.clientWidth - 50, window.innerHeight - 50, Colors.background)

		@objects = []
		@objects.push(new FPSWidget(new Vec2(0, Renderer.height - 20)))
		@objects.push(new CameraControl())
		@objects.push(new Droid(new Vec2(0, 0)))

		Renderer.transforms[0].scale(0.05, 0.05)

		@loop() # Enter the game loop

	# The main game loop
	@loop: =>
		Time.update()
		object.update() for object in @objects
		Renderer.render()
		setTimeout Game.loop, 0

