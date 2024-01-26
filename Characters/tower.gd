extends StaticBody2D

@export var can_shoot: bool = true
@export var shoot_direction: Vector2 = Vector2.RIGHT
@export var damage_multiplier: float
@export var base_damage: float = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func change_direction(direction: Vector2):
	var directions = [Vector2.RIGHT, Vector2.LEFT]
	shoot_direction = direction

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_shoot:
		$FiringComponent.fire_projectile(shoot_direction, base_damage, "blank")
		$CoolDownComponent.start()
		can_shoot = false

func _on_cool_down_component_timeout():
	can_shoot = true

