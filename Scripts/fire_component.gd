extends Node2D
class_name FiringComponent

var projectile_scene: PackedScene = load("res://Projectiles/base_projectile.tscn")
@export var spawnpoint: Marker2D
@export var damage: float

func _ready():
	pass

func fire_projectile(direction, damage, effect):
	var projectile = projectile_scene.instantiate() as Area2D
	projectile.position = spawnpoint.global_position
	projectile.rotation = direction.angle()
	projectile.direction = direction	# Set the direction for the projectile script
	projectile.damage = damage
	projectile.effect = effect	
	get_tree().current_scene.add_child(projectile)
