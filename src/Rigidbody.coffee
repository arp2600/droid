
class Rigidbody
	@time_step = 0.1

	constructor: (@pos, @vel) ->
		@drag = 1
		@mass = 1
		@mass_vector = new Vec2(1,1)

	update: () ->
		new_pos = Vec2.add(@pos, Vec2.mul(@vel, new Vec2(Rigidbody.time_step, Rigidbody.time_step)))
		@pos.set(new_pos.x, new_pos.y)
		drag_magnitude = @vel.mag() * @drag
		drag_force = Vec2.mul(@vel, new Vec2(-drag_magnitude, -drag_magnitude))
		force = drag_force
		@vel = Vec2.add(@vel, Vec2.mul(Vec2.div(force, @mass_vector), new Vec2(Rigidbody.time_step, Rigidbody.time_step)))

	set_mass: (@mass) ->
		@mass_vector = new Vec2(new_mass, new_mass)
