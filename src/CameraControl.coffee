
class CameraControl
	constructor: () ->
		@translate_speed = 10
		@zoom_speed = 1.05

	update: ->
		should_transform = false

		movement = new Vec2(0,0)
		movement.x += 1 if Input.get_key('D')
		movement.x -= 1 if Input.get_key('A')
		movement.y -= 1 if Input.get_key('W')
		movement.y += 1 if Input.get_key('S')
		zoom = 1
		zoom *= @zoom_speed if Input.get_key('Q')
		zoom /= @zoom_speed if Input.get_key('E')

		if movement.mag() > 0.1
			movement.normalize()
			movement.scale(@translate_speed, @translate_speed)
			should_transform = true
		if zoom isnt 0
			should_transform = true

		if should_transform
			Renderer.transforms[0].translate(movement.x, movement.y)
			Renderer.transforms[0].scale(zoom, zoom)

