
class CameraControl
	constructor: () ->
		@translate_speed = 10
		@zoom_speed = 1.05
		@center = new Vec2()

	update: ->
		should_transform = false

		zoom = 1
		zoom *= @zoom_speed if Input.get_key('Q')
		zoom /= @zoom_speed if Input.get_key('E')

		if zoom isnt 1
			Renderer.transforms[0].translate(-@center.x, -@center.y)
			Renderer.transforms[0].scale(zoom, zoom)
			@center.scale(zoom, zoom)
			Renderer.transforms[0].translate(@center.x, @center.y)

		movement = new Vec2(0,0)
		movement.x -= 1 if Input.get_key('D')
		movement.x += 1 if Input.get_key('A')
		movement.y += 1 if Input.get_key('W')
		movement.y -= 1 if Input.get_key('S')

		if movement.mag() > 0.1
			movement.normalize()
			movement.scale(@translate_speed, @translate_speed)
			Renderer.transforms[0].translate(movement.x, movement.y)
			@center = Vec2.add(@center, movement)

