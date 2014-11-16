
class Droid
	constructor: (@pos) ->
		Renderer.add_obj_to_layer(@, 5)
		@physics_timer = new Timer()
		@vel = new Vec2(0,0)
		@force = new Vec2(0,0)

		@drive_force = 10
		@drag_force = 0.5

		@iface = new DroidInterface()
		@turret_rotation = 0

	update: ->
		@update_physics()
		@update_iface()

		@turret_rotation -= @iface.turret_velocity * MathEx.deg2rad * Time.delta_time

	update_iface: ->
		@iface.update()
		# Clamp values
		@iface.turret_velocity = MathEx.clamp(@iface.turret_velocity, -180, 180)
		if @iface.heading.mag() > 0
			@iface.heading.normalize()
		# Update interface value
		@iface.velocity.set(@vel.x, @vel.y)
		#@iface.rotation = (-@turret_rotation) * MathEx.rad2deg

	update_physics: ->
		if @physics_timer.elapsed_time() >= 10
			dt = @physics_timer.elapsed_time()*0.001
			dt = new Vec2(dt, dt)
			@physics_timer.start()

			@force = Vec2.add(@force, Vec2.mul(@iface.heading, new Vec2(@drive_force, @drive_force))) # Drive force
			@force = Vec2.add(@force, Vec2.mul(@vel, new Vec2(-@drag_force, -@drag_force))) # Drag force

			@vel = Vec2.add(@vel, Vec2.mul(@force, dt))
			@pos = Vec2.add(@pos, Vec2.mul(@vel, dt))
			@force = new Vec2(0,0)

	draw: (context) ->
		context.lineWidth = 0.2
		context.lineCap = "round"
		context.strokeStyle = "rgb(132,162,132)"
		context.beginPath()
		context.arc 0, 0, 1, 0, 2*MathEx.pi
		context.stroke()

		context.rotate(@turret_rotation)

		context.beginPath()
		context.moveTo(0,0)
		context.lineTo(0, 0.9)
		context.stroke()
