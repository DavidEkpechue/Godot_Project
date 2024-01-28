extends Node2D
class_name PickupComponent

@export var pickup_area: Area2D
@export var pickup_efect: GPUParticles2D
@export var sprite: Sprite2D

func _ready():
	if pickup_area:
		pickup_area.connect("body_entered", Callable(self, "_on_body_entered"))
		

func play_particle():
	pickup_efect.emitting = true
	sprite.visible = false
		
	await(get_tree().create_timer(pickup_efect.lifetime).timeout)
	get_parent().queue_free() 


func _on_body_entered(body):
	if body.has_node("PlayerStatsComponent"):
		var stats = body.get_node("PlayerStatsComponent")
		stats.add_coins(2)  # Add coins to the player stats
		play_particle()  # Call the function to play the particle effect
		
	else:
		# If the body is not the player, just queue the node for deletion
		queue_free()
