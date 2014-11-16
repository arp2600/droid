
class DroidInterface
	constructor: ->
		@turret_rotation=0 # Read the value of the turret rotation in degrees
		@turret_velocity=180 # Read/Set the velocity of the turret, max/min value is +/- 360 degrees per second
		# The current heading of the droid. The velocity is controlled by the magnitude. Maximum velocity is reached at a magnitude of 1
		@heading=new Vec2(1,0)
		@velocity=new Vec2() # Read the current velocity of the droid

		@timer = new Timer()

	update: ->
		if @turret_velocity > 0
			@turret_velocity -= (180/4)/6 * Time.delta_time

		if @velocity.mag() > 10
			@heading.rotate(1)


