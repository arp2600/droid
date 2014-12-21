
class Projectile
	@radius = 0.1
	constructor: (@game, @renderer, pos, vel) ->
		@pos = new Vec2(pos.x, pos.y)
		@vel = new Vec2(vel.x, vel.y)
		renderer.add_obj_to_layer(@, RenderLayers.projectile)
		@physics_timer = new Timer()
		@drag_force = 0.5
		@lifetime_timer = new Timer()

	update: ->
		if @lifetime_timer.elapsed_time() > 3000
			@remove_projectile()
			return 0
		@update_physics()

	update_physics: ->
		force = new Vec2()
		if @physics_timer.elapsed_time() >= 10
			dt = @physics_timer.elapsed_time()*0.001
			dt = new Vec2(dt, dt)
			@physics_timer.start()
			@pos = Vec2.add(@pos, Vec2.mul(@vel, dt))

			@check_droid_collision(droid) for droid in Droid.droids

	check_droid_collision: (droid) ->
		temp = Vec2.sub(@pos, droid.pos)
		if temp.mag() <= Droid.radius + Projectile.radius
			@remove_projectile()

	remove_projectile: ->
		@game.remove_object(@)
		@renderer.remove_obj_from_layer(@, RenderLayers.projectile)

	draw: (context) ->
		context.lineWidth = @radius*2
		context.lineCap = "round"
		context.strokeStyle = Colors.projectile
		context.beginPath()
		direction = new Vec2(@vel.x, @vel.y)
		direction.normalize()
		context.moveTo(0,0)
		context.lineTo(-direction.x, -direction.y)
		context.stroke()

