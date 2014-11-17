
class DroidInterface
	constructor: ->
		@turret_rotation=0 # Read the value of the turret rotation in degrees
		@turret_velocity=50 # Read/Set the velocity of the turret, max/min value is +/- 360 degrees per second
		# The current heading of the droid. The velocity is controlled by the magnitude. Maximum velocity is reached at a magnitude of 1
		@heading=new Vec2(0,0)
		@velocity=new Vec2() # Read the current velocity of the droid
		@fire_turret=false

		@i = 0


	update: (dt) ->
		if @i < 50
			@fire_turret = true
		else
			@fire_turret = false
		@i++

		@brake()

	brake: ->
		@heading = Vec2.mul(@velocity, @velocity)
		if @velocity.x > 0
			@heading.x *= -1
		if @velocity.y > 0
			@heading.y *= -1

