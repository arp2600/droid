
class CameraControl
	constructor: (@canvas) ->
		@translate_speed = 10
	update: ->
		movement = new Vec2(0,0)
		movement.x += 1 if Input.get_key('D')
		movement.x -= 1 if Input.get_key('A')
		movement.y -= 1 if Input.get_key('W')
		movement.y += 1 if Input.get_key('S')
		@canvas.context.translate(movement.x*@translate_speed, movement.y*@translate_speed) if movement.x isnt 0 or movement.y isnt 0

