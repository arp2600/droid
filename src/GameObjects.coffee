class Ball
	constructor: (@pos, @vel, @color) ->
		@renderer = CircleRenderObj.create @pos, 1, @color, 5
		@rigidbody = new Rigidbody(@pos, @vel)
		@rigidbody.drag = 0.25
	update: ->
		@rigidbody.update()

class Droid
	constructor: (@pos, @color) ->
		@renderer = CircleRenderObj.create(@pos, 1, "#090", 5)
		@renderer.filled = true
		@renderer.line_width = 0.2

		@turret = new PathRenderObj("#090")
		@turret.rotation = 0
		@turret.add_point(0, 0.5, -0.6)
		@turret.add_point(1, -0.5, -0.6)
		@turret.add_point(1, -0.7, 0.5)
		@turret.add_point(1, -0.3, 0.65)
		@turret.add_point(1, -0.5, 1.3)
		@turret.add_point(1, 0.5, 1.3)
		@turret.add_point(1, 0.3, 0.65)
		@turret.add_point(1, 0.7, 0.5)
		@renderer.attach(@turret)

		@turret_outline = new PathRenderObj("#000")
		@turret_outline.filled = false
		@turret_outline.line_width = 0.1
		@turret_outline.add_point(0, 0.5, -0.6)
		@turret_outline.add_point(1, -0.5, -0.6)
		@turret_outline.add_point(1, -0.7, 0.5)
		@turret_outline.add_point(1, -0.3, 0.65)
		@turret_outline.add_point(1, -0.5, 1.3)
		@turret_outline.add_point(1, 0.5, 1.3)
		@turret_outline.add_point(1, 0.3, 0.65)
		@turret_outline.add_point(1, 0.7, 0.5)
		@turret.attach(@turret_outline)

		@rigidbody = new Rigidbody(@pos, new Vec2(0, 0))
		@rigidbody.drag = 0.25
		@timer = new Timer()
		@movement = new Vec2(0,0)
	update: ->
		rotation = 0
		if @timer.elapsed_time() > -1
			@movement = new Vec2(0,0)
			@movement.x += 1 if Input.get_key('L')
			@movement.x -= 1 if Input.get_key('J')
			@movement.y -= 1 if Input.get_key('K')
			@movement.y += 1 if Input.get_key('I')
			rotation += 2 if Input.get_key('O')
			rotation -= 2 if Input.get_key('U')
			if @movement.mag() > 0.1
				@movement.normalize()
				@movement.scale(20, 20)
			@timer.start()
		@rigidbody.add_force(@movement)
		@rigidbody.update()
		@turret.rotation += rotation * Time.delta_time
