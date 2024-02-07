extends CharacterBody2D

var speed = 100
var player_chase = false
var player: CharacterBody2D
var stop_distance = 300
var buffer_distance = 20	# Additional distance to prevent oscillation
var shooting_range = 350	# Distance within which the enemy can shoot
var can_shoot = true		# Controls the ability to shoot
var shooting_cooldown = 1.0	# Cooldown in seconds between shots
var damage = 10
var effect_array: Array
var effect_to_apply: String = "poison"	# S
var effect_intensity: float = 1.0
var effect_duration: int = 5
var effect_seconds_between_tics: float = 1.0

@onready var firing_component: FiringComponent = $FiringComponent

func set_effect():
	# Initialize the effect_array with poison effect details
	effect_array = [effect_to_apply, effect_intensity, effect_duration, effect_seconds_between_tics]

func _physics_process(_delta: float) -> void:
	if player_chase and player:
		var to_player = player.global_position - global_position
		var distance = to_player.length()
		
		if distance > stop_distance + buffer_distance:
			# Chase the player
			look_at(player.global_position)
			move_towards_player(to_player)
		elif distance < stop_distance - buffer_distance:
			retreat_from_player(to_player)
		else:
			stop_and_face_player(distance, to_player)

func move_towards_player(to_player: Vector2):
	var direction = to_player.normalized()
	velocity = direction * speed
	move_and_slide()

func retreat_from_player(to_player: Vector2):
	var direction = -to_player.normalized()
	velocity = direction * speed
	move_and_slide()

func stop_and_face_player(distance: float, to_player: Vector2):
	velocity = Vector2.ZERO
	move_and_slide()
	look_at(player.global_position)
	if distance <= shooting_range and can_shoot:
		shoot_at_player()

func shoot_at_player():
	can_shoot = false
	set_effect()
	var shoot_direction = (player.global_position - global_position).normalized()
	firing_component.fire_projectile(shoot_direction, damage, effect_array)
	start_shooting_cooldown()

func start_shooting_cooldown():
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = shooting_cooldown
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_shooting_cooldown_timeout"))
	timer.start()

func _on_shooting_cooldown_timeout():
	can_shoot = true
	for timer in get_children():
		if timer is Timer:
			timer.queue_free()
			
func _on_detection_area_body_entered(body):
	player = body
	player_chase = true
	


func _on_detection_area_body_exited(_body):
	player = null
	player_chase = false
