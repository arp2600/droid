
# A class for performing operations with 2 dimensional vectors
class Vec2
	## Methods
	constructor: (@x=0, @y=0) ->
	mag: -> Math.sqrt(@x**2 + @y **2)
	scale: (x, y) ->
		if y? then @x *= x; @y *= y
		else @x *= x.x; @y *= x.y
	normalize: ->
		mag = @mag()
		if mag > 0.0001
			@x = @x/mag
			@y = @y/mag
		mag
	rotate: (radians) ->
		sin = MathEx.sin(radians)
		cos = MathEx.cos(radians)
		x = @x; y = @y
		@x = cos * x - sin * y
		@y = sin * x + cos * y
		@
	rotation: -> Math.atan2(@y, @x)
	set: (x, y) ->
		if y? then @x = x; @y = y
		else @x = x.x; @y = x.y
		@
	to_string: -> @x + ", " + @y

	## Static Methods
	@add: (lhs, rhs) -> new Vec2(lhs.x + rhs.x, lhs.y + rhs.y)
	@div: (lhs, rhs) -> new Vec2(lhs.x / rhs.x, lhs.y / rhs.y)
	@mul: (lhs, rhs) -> new Vec2(lhs.x * rhs.x, lhs.y * rhs.y)
	@sub: (lhs, rhs) -> new Vec2(lhs.x - rhs.x, lhs.y - rhs.y)
	@dot: (lhs, rhs) -> lhs.x * rhs.x + lhs.y + rhs.y
	@angle_between: (lhs, rhs) -> lhs.rotation() - rhs.rotation()

