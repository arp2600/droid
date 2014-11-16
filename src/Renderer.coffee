
# Singleton renderer class. Yes, i know, it is a singleton
class Renderer
	@add_obj_to_layer: (obj, layer) ->
		@layers[layer].push obj

	@create_model_view: (obj, view) ->
		model = new Mat3X3()
		modified = false
		if obj?.scale
			model.scale(obj.scale.x, obj.scale.y)
			modified = true
		if obj?.rotation
			model.rotate(obj.rotation)
			modified = true
		if obj?.pos
			model.translate(obj.pos.x, obj.pos.y)
			modified = true
		if modified
			return Mat3X3.mul(view, model)
		else
			return view

	# Static methods
	@init: (width, height, clear_color) ->
		@clear_color = clear_color
		# Create the canvas and size it
		@canvas = document.createElement 'canvas'
		document.body.appendChild @canvas
		@canvas.height = height
		@canvas.width = width
		@height = @canvas.height
		@width = @canvas.width
		# Get the drawing context from the canvas
		@context = @canvas.getContext '2d'
		# Create an array of 10 layers
		@layers = []
		@layers.push []  for i in [0...10]
		# Each layer needs a transform
		view = new Mat3X3()
		view.scale(1, -1)
		view.translate(@width*0.5, @height*0.5)
		view.scale(@height*0.5, @height*0.5)
		@transforms = []
		@transforms.push view for i in [0...8]
		# Layers 8 and 9 are the UI layers
		view = new Mat3X3()
		view.scale(1, -1)
		view.translate(0, @height)
		@transforms.push view for i in [8...10]

	@remove_obj: (obj) ->
		for layer in @layers
			for item, i in layer
				if obj is item
					layer.splice(i, 1)
					return 1
		return 0

	@render: () ->
		# clear the canvas
		@context.setTransform(1,0,0,1,0,0)
		@context.fillStyle = @clear_color
		@context.fillRect 0, 0, @canvas.width, @canvas.height
		# cycle through the render layers and draw all the objects
		for layer, i in @layers
			view = @transforms[i]
			for obj in layer
				@render_object(obj, view)
		0
	
	@render_object: (obj, transform) ->
		model_view = @create_model_view(obj, transform)
		mat = model_view.mat
		@context.setTransform(mat[0], mat[3], mat[1], mat[4], mat[2], mat[5])
		obj.draw(@context)
		if obj?.children
			@render_object(child, model_view) for child in obj.children

class RenderObj
	remove_self: ->
		Renderer.remove_obj(@)
	add_to_renderer: (obj, layer) ->
		Renderer.add_obj_to_layer obj, layer
	is_visible: ->
		if @visible? then @visible else true
	attach: (renderer) ->
		@children = [] if not @children
		@children.push(renderer)
		renderer.parent = @

# A circle render object
class CircleRenderObj extends RenderObj
	constructor: (@pos, @radius, @color) ->
		@filled = true
		@line_width = 1
	@create: (pos=new Vec2(), radius=10, color="#F0F", layer=0) ->
		obj = new CircleRenderObj pos, radius, color
		obj.add_to_renderer obj, layer
		obj
	draw: (context) ->
		if @filled
			context.fillStyle = @color
		else
			context.strokeStyle = @color
			context.lineWidth = @line_width

		context.beginPath()
		context.arc 0, 0, @radius, 0, 2*MathEx.pi
		if @filled then context.fill()
		else context.stroke()
	remove_self: ->
		Renderer.remove_obj(@)

# A rectangle render object
class RectRenderObj extends RenderObj
	constructor: (@pos, @width, @height, @color) ->
		@filled = true
		@line_width = 1
		@rotation = 0
	@create: (pos, width, height, color, layer=0) ->
		obj = new RectRenderObj pos, width, height, color
		obj.add_to_renderer obj, layer
		obj
	draw: (context) ->
		if @filled
			context.fillStyle = @color
			context.fillRect -@width*0.5, -@height*0.5, @width, @height
		else
			context.strokeStyle = @color
			context.lineWidth = @line_width
			context.strokeRect -@width*0.5, -@height*0.5, @width, @height


class TextRenderObj extends RenderObj
	constructor: (@pos, @text, @color, @font)->
		@font = TextRenderObj.default_font unless @font
		@color = TextRenderObj.default_color unless @color
		@scale = new Vec2(1, -1)
	@create: (pos, text, color, font, layer=0) ->
		obj = new TextRenderObj(pos, text, color, font)
		obj.add_to_renderer obj, layer
		obj
	draw: (context) ->
		context.font = @font
		context.fillStyle = @color
		context.fillText(@text, 0, 0)
	@default_font: "20px monaco"
	@default_color: "#0F0"

class PathRenderObj extends RenderObj
	constructor: (@color) ->
		@color = TextRenderObj.default_color unless @color
		@line_width = 1
		@points = []
		@filled = true
	@default_color: "#0F0"
	@create: (color, layer=0) ->
		obj = new PathRenderObj(color)
		obj.add_to_renderer(obj, layer)
		obj
	add_point: (command, x, y) ->
		@points.push([command, x, y])
	draw: (context) ->
		context.beginPath()

		for point in @points
			switch
				when point[0] == 0
					context.moveTo(point[1], point[2])
				when point[0] == 1
					context.lineTo(point[1], point[2])

		context.closePath()

		if @filled
			context.fillStyle = @color
			context.fill()
		else
			context.strokeStyle = @color
			context.lineWidth = @line_width
			context.stroke()

