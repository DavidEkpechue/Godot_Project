extends Node2D
class_name HealthComponent

@export var MAX_HEALTH: float = 100
@export var damage_numbers_origin: DamageNumbersOrigin
@export var health: float

var dmg_pos = self.position + Vector2(0, 10)

signal health_empty
signal health_changed

# Called when the node enters the scene tree for the first time.
func _ready():
	health = MAX_HEALTH


func damage(damage_amt):
	var is_critical = false
	health -= damage_amt
	health_changed.emit(health)
	DamageNumbers.display_number(damage_amt, damage_numbers_origin.global_position, is_critical)
	
	if health <= 0:
		die()
		
func heal(heal_amt):
	if health + heal_amt > MAX_HEALTH:
		health = MAX_HEALTH
	else:
		health += heal_amt
	health_changed.emit(health)

func die():
	health_empty.emit()
	if get_parent():  # Check if the HealthComponent has a parent before trying to delete it
		print('dead: ', get_parent().name)
		get_parent().queue_free()  # This will free the parent node, which includes this HealthComponent
	else:
		queue_free()  # If there is no parent, just free the HealthComponent itself
