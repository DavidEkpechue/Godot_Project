extends StaticBody2D

@export var can_shoot: bool = true
@export var shoot_direction: Vector2
@export var damage_multiplier: float
@export var base_damage: float
@export var shooting_cooldown: float


var fire_component
var effect_array
var effect_to_apply: String = "fire"
var effect_intensity: float = 1
var effect_duration: int = 5
var effect_seconds_between_tics: float = 1
var player: CharacterBody2D = null
var direction = Vector2.RIGHT

func set_effect():
	effect_array = []  # Clear the array or reinitialize it
	effect_array.append(effect_to_apply)
	effect_array.append(effect_intensity)
	effect_array.append(effect_duration)
	effect_array.append(effect_seconds_between_tics)


# Called when the node enters the scene tree for the first time.
func _ready():
	fire_component = $FiringComponent	 # Make sure this is the correct path to the FiringComponent
	set_effect()

func _process(delta: float):
	if player:
		look_at(player.global_position)
		direction = (player.global_position - global_position).normalized()
		if can_shoot:
			shoot()

func shoot():
	# Ensure this logic is only executed when it's appropriate to shoot
	var shoot_direction = direction
	fire_component.fire_projectile(shoot_direction, base_damage * damage_multiplier, effect_array)
	
	can_shoot = false
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


func _on_area_2d_body_entered(body):
	player = body



func _on_area_2d_body_exited(body):
	player = null 
