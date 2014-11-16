
class window.Game
	constructor: ->
		Renderer.init(document.body.clientWidth - 50, window.innerHeight - 50, "rgba(59,59,59,1)")

		@objects = []
		@objects.push(new FPSWidget(new Vec2(0, Renderer.height - 20)))
		@objects.push(new CameraControl())
		@objects.push(new Droid(new Vec2(0, 0)))

		Renderer.transforms[0].scale(0.1, 0.1)

		@loop() # Enter the game loop

	# The main game loop
	loop: =>
		Time.update()
		object.update() for object in @objects
		Renderer.render()
		setTimeout @loop, 0

