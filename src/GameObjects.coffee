class FPSWidget
	constructor: (@pos) ->
		@text = TextRenderObj.create(@pos.x, @pos.y, "FPS: ", null, null, 9)
		@frames = 0
		@update_display()
	update: ->
		@frames++
		@update_display() if Time.get_time() - @start > 1000
	update_display: ->
		@text.text = "FPS: " + @frames
		@frames = 0
		@start = Time.get_time()

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
class Ball
	constructor: (@life_span, @pos, @vel, @color) ->
		@renderer = CircleRenderObj.create @pos.x, @pos.y, 20, @color, 5
		@age = Time.get_time()
	update: ->
		if Time.get_time() - @age > @life_span*1000
			if @renderer?
				@renderer.remove_self()
				@renderer = null
			return

		t = 0.1
		@pos = Vec2.add @pos, Vec2.mul @vel, new Vec2 t,t
		@renderer.x = @pos.x
		@renderer.y = @pos.y
