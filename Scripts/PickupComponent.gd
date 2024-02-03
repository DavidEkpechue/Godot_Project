extends Node2D
class_name PickupComponent

@export var pickup_area: Area2D
@export var pickup_efect: GPUParticles2D
@export var sprite: Sprite2D
@export var stat_change: String
@export var stat_amt: float

func _ready():
	if pickup_area:
		pickup_area.connect("body_entered", Callable(self, "_on_body_entered"))


func play_disappear_particle():
	pickup_efect.emitting = true
	sprite.visible = false
		
	await(get_tree().create_timer(pickup_efect.lifetime).timeout)
	get_parent().queue_free() 


func _on_body_entered(body):
	print(stat_change)
	if body.name == "Player":
		var stats = body.get_node("StatsComponent")
		stats.change_stat(stat_change, stat_amt)  # Add coins to the player stats
		play_disappear_particle()  # Call the function to play the particle effect
		
	else:
		# If the body is not the player, just queue the node for deletion
		queue_free()
