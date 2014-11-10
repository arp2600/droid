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
