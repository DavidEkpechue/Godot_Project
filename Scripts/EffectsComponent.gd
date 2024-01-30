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


var active_fire_effects_count = 0
var active_poison_effects_count = 0

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout





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
	active_fire_effects_count += 1 # Increment the counter when the effect is applied
	if active_fire_effects_count == 1: # Only start particles if this is the first effect
		start_particle_emission(fire_particle)

	for i in range(duration):
		health_component.damage(intensity)
		print("fire damage with intensity ", intensity, "at second ", i + 1, "/", duration)
		# Yield execution before continuing the loop
		await get_tree().create_timer(seconds_between_tics).timeout

	active_fire_effects_count -= 1 # Decrement the counter when the effect ends
	if active_fire_effects_count == 0: # Only stop particles if this was the last effect
		stop_particle_emission(fire_particle)
	is_on_fire = active_fire_effects_count > 0 # Update the is_poisoned flag based on active effects

	

func poisoned(intensity: float, duration: int, seconds_between_tics: float):
	is_poisoned = true
	active_poison_effects_count += 1 # Increment the counter when the effect is applied
	if active_poison_effects_count == 1: # Only start particles if this is the first effect
		start_particle_emission(poisoned_particle)

	for i in range(duration):
		health_component.damage(intensity)
		print("Poison damage with intensity ", intensity, "at second ", i + 1, "/", duration)
		# Yield execution before continuing the loop
		await get_tree().create_timer(seconds_between_tics).timeout

	active_poison_effects_count -= 1 # Decrement the counter when the effect ends
	if active_poison_effects_count == 0: # Only stop particles if this was the last effect
		stop_particle_emission(poisoned_particle)
	is_poisoned = active_poison_effects_count > 0 # Update the is_poisoned flag based on active effects

func start_particle_emission(particle_node: GPUParticles2D):
	particle_node.emitting = true
	for child in particle_node.get_children():
		if child is GPUParticles2D or child is CPUParticles2D:
			child.emitting = true

func stop_particle_emission(particle_node: GPUParticles2D):
	particle_node.emitting = false
	for child in particle_node.get_children():
		if child is GPUParticles2D or child is CPUParticles2D:
			child.emitting = false
