
class window.Game
	constructor: ->
		@canvas = new Canvas(650, 400, "#000")

		Renderer.init()
		@fps_widget = new FPSWidget(new Vec2(10, 30))
		@camera_control = new CameraControl(@canvas)

		@balls = [
			new Ball 5, new Vec2(0, 0), new Vec2(0, 0), "#F00"
		]

		# This view tranformation: 
		# places the origin in the center of the canvas, 
		# makes positive y up and negative down
		# makes the canvas 1 unit high and canvas height / canvas width units wide
		view = new Mat3X3()
		view.scale(1, -1)
		view.translate(@canvas.width*0.5, @canvas.height*0.5)
		view.scale(@canvas.height*0.5, @canvas.height*0.5)
		view.scale(1, 1)

		# This transform moves objects about the scene
		model = new Mat3X3()
		#model.translate(100, 0)
		#model.rotate(3.14)
		#model.scale(-1, 1)

		# This merges the transform
		model_view = Mat3X3.mul(view, model)

		@canvas.context.setTransform(model_view.mat[0], model_view.mat[3], model_view.mat[1], model_view.mat[4], model_view.mat[2], model_view.mat[5])

		@loop() # Enter the game loop

	# The main game loop
	loop: =>
		@fps_widget.update()
		ball.update() for ball in @balls
		@camera_control.update()
		Renderer.fetch().render(@canvas)
		setTimeout @loop, 20

