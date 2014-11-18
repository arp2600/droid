
class window.Game
	@start: ->
		Renderer.init(document.body.clientWidth - 50, window.innerHeight - 50, Colors.background)

		@delete_list = []
		@objects = []
		@objects.push(new FPSWidget(new Vec2(0, Renderer.height - 20)))
		@objects.push(new CameraControl())
		@objects.push(new Droid(new Vec2(0, 0)))
		@objects.push(new Droid(new Vec2(0, 10)))
		@objects.push(new Droid(new Vec2(-5, 5)))

		Renderer.transforms[0].scale(0.05, 0.05)

		@loop() # Enter the game loop

	# The main game loop
	@loop: =>
		Time.update()
		object.update() for object in @objects

		Game.purge_objects()

		Renderer.render()
		setTimeout Game.loop, 0

	@add_object: (obj) ->
		@objects.push(obj)
	
	@remove_object: (obj) ->
		@delete_list.push(obj)

	@purge_objects: ->
		for obj in @delete_list
			for item, i in @objects
				if obj is item
					@objects.splice(i, 1)
					break


