
# Singleton renderer class. Yes, i know, it is a singleton
class Renderer
	add_obj_to_layer: (obj, layer) ->
		@layers[layer].push obj
	
	remove_obj_from_layer: (obj, layer) ->
		for item, i in @layers[layer]
			if obj is item
				@layers[layer].splice(i, 1)
				break

	create_model_view: (obj, view) ->
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
	init: (width, height, clear_color) ->
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

	remove_obj: (obj) ->
		for layer in @layers
			for item, i in layer
				if obj is item
					layer.splice(i, 1)
					return 1
		return 0

	render: () ->
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
	
	render_object: (obj, transform) ->
		model_view = @create_model_view(obj, transform)
		mat = model_view.mat
		@context.setTransform(mat[0], mat[3], mat[1], mat[4], mat[2], mat[5])
		obj.draw(@context)
		if obj?.children
			@render_object(child, model_view) for child in obj.children

