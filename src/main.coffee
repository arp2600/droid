## Currently a wrapper for javascripts default math library
class MathEx
	@acos: Math.acos
	@asin: Math.asin
	@atan: Math.atan
	@atan2: Math.atan2
	@cos: Math.cos
	@deg2rad: Math.PI / 180
	@pi: Math.PI
	@rad2deg: 180 / Math.PI
	@sin: Math.sin
	@tan: Math.tan

## A class for performing operations with 2 dimensional vectors
class Vec2
	## Methods
	constructor: (@x=0, @y=0) ->
	mag: -> Math.sqrt(@x**2 + @y **2)
	normalize: ->
		mag = @mag()
		@x = @x/mag; @y = @y/mag
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

class Canvas
	constructor: (width=650, height=400, bg_color="#000000") ->
		# Create the canvas and size it
		@canvas = document.createElement 'canvas'
		document.body.appendChild @canvas
		@canvas.height = height
		@canvas.width = width
		# Get the drawing context from the canvas
		@ctx = @canvas.getContext '2d'
		@fill_rect(0, 0, width, height, bg_color)

	fill_rect: (x, y, width, height, color="#000") ->
		@ctx.fillStyle = color
		@ctx.fillRect(x, y, width, height)

	fill_circle: (x, y, r, color="#000") ->
		@ctx.fillStyle = color
		@ctx.beginPath()
		@ctx.arc(x, y, r, 0, 2*MathEx.pi)
		@ctx.fill()
	block_circle: (x, y, r, block_size) ->
		dim = r / block_size
		cx = x - x % block_size
		cy = y - y % block_size
		origin = new Vec2(x, y)

		for ix in [-dim..dim]
			for iy in [-dim..dim]
				coor = new Vec2(cx + ix*block_size, cy + iy*block_size)
				to_origin = Vec2.sub(coor, origin)
				mag = to_origin.mag()
				mag = r if mag > r
				intensity = Math.round((((r - mag) / r) * 255))
				intensity = intensity.toString(10)
				@fill_rect(cx + ix*block_size, cy + iy*block_size, block_size, block_size, "rgb(" + intensity + ", 0, 0)")


class Ball
	constructor: (@pos, @vel) ->
	update: (t, canvas) ->
		canvas.fill_rect(@pos.x - 15, @pos.y - 15, 30, 30, "#000")
		if (@pos.x > canvas.canvas.width - 15 and @vel.x > 0) or (@pos.x < 15 and @vel.x < 0)
			@vel.x *= -1
		if (@pos.y > canvas.canvas.height - 15 and @vel.y > 0) or (@pos.y < 15 and @vel.y < 0)
			@vel.y *= -1

		@vel.y += 100 * t

		vel = Vec2.mul(@vel, new Vec2(t, t))
		@pos = Vec2.add(@pos, vel)
		canvas.block_circle(@pos.x, @pos.y, 80, 80)

class window.Game
	constructor: ->
		@canvas = new Canvas(650, 400, "#000")

		#@canvas.block_circle(333,231, 30, 10, 0, "#0000FF")

		@ball = new Ball(new Vec2(333, 231), new Vec2(110,-140))

		@loop() # Enter the game loop

	# The main game loop
	loop: =>
		@ball.update(0.02, @canvas)
		setTimeout @loop, 20

