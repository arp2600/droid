
class Droid
	@droids = [] # A list of all the droids in the scene
	@radius = 1
	constructor: (@pos) ->
		Droid.droids.push(@)
		Renderer.add_obj_to_layer(@, RenderLayers.droid)
		@vel = new Vec2(0,0)
		@force = new Vec2(0,0)

		@drive_force = 10
		@drag_force = 0.5

		@iface = new DroidInterface()
		@turret_rotation = 0

		@turret_timer = new Timer()
		@physics_timer = new Timer()
		@iface_timer = new Timer()

	fire_turret: ->
		direction = new Vec2(0,Droid.radius + Projectile.radius) # Droid.radius + Projectile.radius draws the projectile outside the droid
		direction.rotate(@turret_rotation)
		pos = Vec2.add(@pos, direction)
		vel = Vec2.mul(direction, new Vec2(10,10))
		@force = Vec2.add(@force, Vec2.mul(direction, new Vec2(-100,-100)))
		shell = new Projectile(pos, vel)
		Game.add_object(shell)
		@iface.fire_turret = false

	update: ->
		@update_physics()
		@update_iface()

		@turret_rotation -= @iface.turret_velocity * MathEx.deg2rad * Time.delta_time

		if @turret_timer.elapsed_time() > 500 and @iface.fire_turret
			@turret_timer.start()
			@fire_turret()

	update_iface: ->
		if @iface_timer.elapsed_time() >= 100
			@iface_timer.start()

			# Update interface value
			@iface.velocity = new Vec2(@vel.x, @vel.y)
			@iface.turret_rotation = @turret_rotation

			@iface.update(100)
			# Clamp values
			@iface.turret_velocity = MathEx.clamp(@iface.turret_velocity, -180, 180)
			if @iface.heading.mag() > 1
				@iface.heading.normalize()

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
		context.strokeStyle = Colors.droid
		context.fillStyle = Colors.background
		context.beginPath()
		context.arc 0, 0, Droid.radius, 0, 2*MathEx.pi
		context.fill()
		context.stroke()

		context.rotate(@turret_rotation)

		context.beginPath()
		context.moveTo(0,0)
		context.lineTo(0, 0.9)
		context.stroke()
