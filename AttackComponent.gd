extends Node2D
class_name AttackComponent
@export var attack_area: Area2D
@export var damage: float
@export var cooldown: float
var is_in_area: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	if attack_area:
		attack_area.body_entered.connect(attack)
		attack_area.body_exited.connect(stop_attack)

func attack(body):
	is_in_area = true
	while is_in_area:
		var health_component = body.get_node_or_null("HealthComponent")  # Adjust the node path as necessary
		if health_component and health_component.has_method("damage"):
			await(get_tree().create_timer(cooldown).timeout)
			health_component.damage(damage)  
			

func stop_attack(_body):
	is_in_area = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
