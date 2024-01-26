extends Node2D
class_name EffectsComponent

@export var health_component: HealthComponent

@export var is_on_fire: bool = false
@export var is_slowed: bool = false
@export var is_poisoned: bool = false
@export var is_blinded: bool = false
@export var is_immobile: bool = false

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func apply_effect(effect: String, intensity, duration):
	match effect:
		"fire":
			on_fire(intensity, duration, 5)
		"poison":
			poisoned(intensity, duration, 5)
		"blank":
			return



func on_fire(intensity:float, duration:int, seconds):
	is_on_fire = true
	for i in range(int(duration)):
		# Assuming 'health_component' is a variable that holds the reference to the HealthComponent
		health_component.damage(intensity)
		print("Fire damage with intensity ", intensity, "at second ", i + 1, "/", duration)
		# Yield execution for 1 second before continuing the loop
		await get_tree().create_timer(seconds).timeout
	is_on_fire = false
	
func poisoned (intensity:float, duration:int, seconds):
	for i in range(int(duration)):
		# Assuming 'health_component' is a variable that holds the reference to the HealthComponent
		health_component.damage(intensity)
		print("Poision damage with intensity ", intensity, "at second ", i + 1, "/", duration)
		# Yield execution for 1 second before continuing the loop
		await get_tree().create_timer(seconds).timeout

