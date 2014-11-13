class Ball
	constructor: (@pos, @vel, @color) ->
		@renderer = CircleRenderObj.create @pos, 1, @color, 5
		@rigidbody = new Rigidbody(@pos, @vel)
		@rigidbody.drag = 0.25
	update: ->
		@rigidbody.update()

class Droid
	constructor: (@pos, @color) ->
		@renderer = CircleRenderObj.create(@pos, 1, @color, 5)
		@rigidbody = new Rigidbody(@pos, new Vec2(0, 0))
		@rigidbody.drag = 0.25
	update: ->
		movement = new Vec2(0,0)
		movement.x += 1 if Input.get_key('L')
		movement.x -= 1 if Input.get_key('J')
		movement.y -= 1 if Input.get_key('K')
		movement.y += 1 if Input.get_key('I')
		if movement.mag() > 0.1
			movement.normalize()
			movement.scale(2, 2)
			@rigidbody.add_force(movement)
		@rigidbody.update()
