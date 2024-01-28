extends Node2D
class_name EffectsComponent
signal on_fire_signal
@export var health_component: HealthComponent
@export var fire_particle: GPUParticles2D
@export var poisoned_particle: GPUParticles2D

@export var is_on_fire: bool = false
@export var is_slowed: bool = false
@export var is_poisoned: bool = false
@export var is_blinded: bool = false
@export var is_immobile: bool = false
var fire_particles: GPUParticles2D

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

# Called when the node enters the scene tree for the first time.
func _ready():
	fire_particles = get_node_or_null("FireParticles")



func apply_effect(effect):
	match effect[0]:
		"fire":
			on_fire(effect[1], effect[2], effect[3])
		"poison":
			poisoned(effect[1], effect[2], effect[3])
		"blank":
			return



func on_fire(intensity:float, duration:int, seconds_between_tics):
	is_on_fire = true
	on_fire_signal.emit()
	fire_particle.emitting = true
# Loop over each child node of fire_particle
	for i in range(fire_particle.get_child_count()):
		var child = fire_particle.get_child(i)
		if child is GPUParticles2D or child is CPUParticles2D:  # Check if the child is a particle system
			child.emitting = true  # Start emitting for the child particle system
		
	for i in range(int(duration)):
		# Assuming 'health_component' is a variable that holds the reference to the HealthComponent
		health_component.damage(intensity)
		print("Fire damage with intensity ", intensity, " at second ", i + 1, "/", duration)
		# Yield execution for 1 second before continuing the loop
		await get_tree().create_timer(seconds_between_tics).timeout
	
	fire_particle.emitting = false
	for i in range(fire_particle.get_child_count()):
		var child = fire_particle.get_child(i)
		if child is GPUParticles2D or child is CPUParticles2D:  # Check if the child is a particle system
			child.emitting = false  # Start emitting for the child particle system
	
	is_on_fire = false
	
func poisoned (intensity:float, duration:int, seconds_between_tics):
	for i in range(int(duration)):
		# Assuming 'health_component' is a variable that holds the reference to the HealthComponent
		health_component.damage(intensity)
		print("Poision damage with intensity ", intensity, "at second ", i + 1, "/", duration)
		# Yield execution for 1 second before continuing the loop
		await get_tree().create_timer(seconds_between_tics).timeout

