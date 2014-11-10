### *******************************************************************
	Math library classes 
	MathEx - An interface and extension of Math
	Vec2 - A two dimensional vector
******************************************************************* ###

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
	scale: (x, y) ->
		if y? then @x *= x; @y *= y
		else @x *= x.x; @y *= x.y
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

# Return the time
class Time
	@get_time: ->
		new Date().getTime()
	@start = new Date().getTime()

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

class Input
	@keys = []
	@keys.push(false) for i in [0...127]
	@keydown: (event) =>
		@keys[event.keyCode] = true
	@keyup: (event) =>
		@keys[event.keyCode] = false
	@get_key: (key) ->
		return @keys[key.charCodeAt(0)] if key?.charCodeAt
		@keys[key]
document.addEventListener('keydown',Input.keydown)
document.addEventListener('keyup',Input.keyup)

class window.Game
	constructor: ->
		@canvas = new Canvas(650, 400, "#000")

		Renderer.init()
		@fps_widget = new FPSWidget(new Vec2(10, 30))
		@camera_control = new CameraControl(@canvas)

		@balls = [
			new Ball 5, new Vec2(10, 10), new Vec2(20, 20), "#F00"
			new Ball 5, new Vec2(50, 30), new Vec2(30, 10), "#0F0"
			new Ball 5, new Vec2(30, 50), new Vec2(10, 30), "#00F"
			new Ball 5, new Vec2(40, 10), new Vec2(25, 25), "#F00"
			new Ball 5, new Vec2(50, 20), new Vec2(35, 15), "#0F0"
			new Ball 5, new Vec2(30, 80), new Vec2(15, 35), "#00F"
		]

		@loop() # Enter the game loop

	# The main game loop
	loop: =>
		@fps_widget.update()
		ball.update() for ball in @balls
		@camera_control.update()
		Renderer.fetch().render(@canvas)
		setTimeout @loop, 20

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

### *******************************************************************
	Renderer stuff. 
	Call Renderer.init()
	Create render objs with the classes create method (i.e CircleRenderObj.create 10, 10, 5, "red", 5)
	Call Renderer.fetch().render(canvas) (note, canvas refers to the canvas interface class declared ( Canvas ))
******************************************************************* ###

class Canvas
	constructor: (width=650, height=400, bg_color="#000000") ->
		# Create the canvas and size it
		@canvas = document.createElement 'canvas'
		document.body.appendChild @canvas
		@canvas.height = height
		@canvas.width = width
		@height = @canvas.height
		@width = @canvas.width
		# Get the drawing context from the canvas
		@ctx = @canvas.getContext '2d'
		@context = @ctx
		@fill_rect(0, 0, width, height, bg_color)

	fill_rect: (x, y, width, height, color="#000") ->
		@ctx.fillStyle = color
		@ctx.fillRect(x, y, width, height)

	fill_circle: (x, y, r, color="#000") ->
		@ctx.fillStyle = color
		@ctx.beginPath()
		@ctx.arc(x, y, r, 0, 2*MathEx.pi)
		@ctx.fill()

	fill_style: (color) ->
		@context.fillStyle = color

# Singleton renderer class. Yes, i know, it is a singleton
class Renderer
	constructor: (@clear_color) ->
		# Create an array of 10 layers
		@layers = []
		@layers.push []  for i in [0...10]

	add_obj_to_layer: (obj, layer) ->
		@layers[layer].push obj

	remove_obj: (obj) ->
		for layer in @layers
			for item, i in layer
				if obj is item
					layer.splice(i, 1)
					return 1
		return 0

	render: (canvas) ->
		# clear the canvas
		canvas.fill_rect 0, 0, canvas.width, canvas.height, @clear_color
		# cycle through the render layers and draw all the objects
		for layer in @layers
			for obj in layer
				obj.draw(canvas.context) if obj.is_visible()
		0

	# Static methods
	@fetch: -> @instance
	@init: (clear_color="#000") -> @instance = new Renderer(clear_color)

class RenderObj
	remove_self: ->
		Renderer.fetch().remove_obj(@)
	add_to_renderer: (obj, layer) ->
		Renderer.fetch().add_obj_to_layer obj, layer
	is_visible: ->
		if @visible? then @visible else true

# A circle render object
class CircleRenderObj extends RenderObj
	constructor: (@x, @y, @radius, @color) ->
	@create: (x=0, y=0, radius=10, color="#F0F", layer=0) ->
		obj = new CircleRenderObj x, y, radius, color
		obj.add_to_renderer obj, layer
		obj
	draw: (context) ->
		context.fillStyle = @color
		context.beginPath()
		context.arc @x, @y, @radius, 0, 2*MathEx.pi
		context.fill()
	remove_self: ->
		Renderer.fetch().remove_obj(@)

# A rectangle render object
class RectRenderObj extends RenderObj
	constructor: (@x, @y, @width, @height, @color) ->
	@create: (x, y, width, height, color, layer=0) ->
		obj = new RectRenderObj x, y, width, height, color
		obj.add_to_renderer obj, layer
		obj
	draw: (context) ->
		context.fillStyle = @color
		context.fillRect @x, @y, @width, @height

class TextRenderObj extends RenderObj
	constructor: (@x, @y, @text, @color, @font)->
		@font = TextRenderObj.default_font unless @font
		@color = TextRenderObj.default_color unless @color
	@create: (x, y, text, color, font, layer=0) ->
		obj = new TextRenderObj(x, y, text, color, font)
		obj.add_to_renderer obj, layer
		obj
	draw: (context) ->
		context.font = @font
		context.fillStyle = @color
		context.fillText(@text, @x, @y)
	@default_font: "20px monaco"
	@default_color: "#0F0"
