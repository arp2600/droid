class Ball
	constructor: (@pos, @vel, @color) ->
		@renderer = CircleRenderObj.create @pos, 1, @color, 5
		@rigidbody = new Rigidbody(@pos, @vel)
		@rigidbody.drag = 0.25
	update: ->
		t = 0.1
		@rigidbody.update()
