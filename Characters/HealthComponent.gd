extends Node2D
class_name HealthComponent

@export var MAX_HEALTH: float = 100

@export var health: float


signal health_empty
signal health_changed

# Called when the node enters the scene tree for the first time.
func _ready():
	health = MAX_HEALTH


func damage(damage_amt):
	health_changed.emit()
	health -= damage_amt
	
	if health <= 0:
		die()
		
func heal(heal_amt):
	health_changed.emit()
	if health + heal_amt > MAX_HEALTH:
		health = MAX_HEALTH
	else:
		health += heal_amt


func die():
	health_empty.emit()
	if get_parent():  # Check if the HealthComponent has a parent before trying to delete it
		print('dead: ', get_parent().name)
		get_parent().queue_free()  # This will free the parent node, which includes this HealthComponent
	else:
		queue_free()  # If there is no parent, just free the HealthComponent itself
