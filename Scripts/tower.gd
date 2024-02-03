extends StaticBody2D

@export var can_shoot: bool = true
@export var shoot_direction: Vector2 = Vector2.RIGHT
@export var damage_multiplier: float
@export var base_damage: float

var fire_component
var effect_array
var effect_to_apply: String = "fire"
var effect_intensity: float = 1
var effect_duration: int = 5
var effect_seconds_between_tics: float = 1


func set_effect():
	effect_array = []  # Clear the array or reinitialize it
	effect_array.append(effect_to_apply)
	effect_array.append(effect_intensity)
	effect_array.append(effect_duration)
	effect_array.append(effect_seconds_between_tics)


# Called when the node enters the scene tree for the first time.
func _ready():
	fire_component = $FiringComponent	 # Make sure this is the correct path to the FiringComponent

func change_direction(direction: Vector2):
	var directions = [Vector2.RIGHT, Vector2.LEFT]
	shoot_direction = direction

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_shoot:
		set_effect()
		fire_component.fire_projectile(shoot_direction, base_damage, effect_array)
		$CoolDownComponent.start()
		can_shoot = false

func _on_cool_down_component_timeout():
	can_shoot = true

