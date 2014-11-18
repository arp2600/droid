
class DroidInterface
	constructor: ->
		@turret_rotation=0 # Read the value of the turret rotation in degrees
		@turret_velocity=0 # Read/Set the velocity of the turret, max/min value is +/- 360 degrees per second
		# The current heading of the droid. The velocity is controlled by the magnitude. Maximum velocity is reached at a magnitude of 1
		@heading=new Vec2(0,0)
		@velocity=new Vec2() # Read the current velocity of the droid
		@fire_turret=false
		@position=new Vec2(0,0)
		@blips = [] # Items picked up in the radar are blips

		@maintain_pos=null

	update: (dt) ->
		@maintain_pos = new Vec2(@position.x, @position.y) unless @maintain_pos?

		a = 360
		a = @aim_at(@blips[0].angle) if @blips[0]?
		@fire_turret = true if MathEx.abs(a) < 5

		@heading = new Vec2()
		@heading = Vec2.add(@heading, @brake())
		@heading = Vec2.add(@heading, @hold_position(@maintain_pos))

	# Stop the droid moving
	brake: ->
		temp = new Vec2()
		temp = Vec2.mul(@velocity, @velocity)
		if @velocity.x > 0
			temp.x *= -1
		if @velocity.y > 0
			temp.y *= -1
		temp

	# Aim the turret at the angle and return the degrees currently off that angle
	aim_at: (angle) ->
		a = ((@turret_rotation - angle + 180)% 360) - 180
		@turret_velocity = a * 10
		a

	hold_position: (pos) ->
		dir = Vec2.sub(pos, @position)
		dir.x * 3
		dir.y * 3
		dir

	draw: (context) ->
		if @maintain_pos?
			context.strokeStyle = "#0F0"
			context.lineWidth = 0.1
			context.beginPath()
			context.moveTo(@position.x,@position.y)
			context.lineTo(@maintain_pos.x, @maintain_pos.y)
			context.stroke()

		context.lineWidth = 0.1
		context.lineCap = "round"
		context.strokeStyle = "#0F0"
		context.beginPath()
		context.arc -20, 5, 0.1, 0, 2*MathEx.pi
		context.stroke()


