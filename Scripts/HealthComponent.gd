extends Node2D
class_name HealthComponent

@export var MAX_HEALTH: float = 100
@export var sprite: Sprite2D
@export var hitbox_polygon: CollisionPolygon2D
@export var hitbox_shape: CollisionShape2D
@export var attack_component: AttackComponent
@export var firing_component: FiringComponent
@export var death_drop_scene: PackedScene  
@export var damage_numbers_origin: DamageNumbersOrigin
@export var death_particles: GPUParticles2D
@export var health: float

var dmg_pos = self.position + Vector2(0, 10)
var is_active: bool = true
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
	

func death_effect():
	death_particles.emitting = true
	sprite.visible = false
	if attack_component:
		attack_component.queue_free()
	if firing_component:
		firing_component.queue_free()
	if hitbox_polygon:
		hitbox_polygon.queue_free()
	else:
		hitbox_shape.queue_free()

	if death_drop_scene:
		var drop_instance = death_drop_scene.instantiate()
		drop_instance.global_position = self.global_position
		var drops_node = get_node("/root/Level/Drops")  # Adjust the path as necessary
		drops_node.add_child(drop_instance)


	# Wait for the particles to finish before removing the parent node
	await(get_tree().create_timer(death_particles.lifetime).timeout)
	if get_parent():
		get_parent().queue_free()  # Ensure safe removal if the parent exists


func die():
	health_empty.emit()
	is_active = false

	if get_parent():  # Check if the HealthComponent has a parent before trying to delete it
		print('dead: ', get_parent().name)
		death_effect()

	else:
		queue_free()  # If there is no parent, just free the HealthComponent itself
