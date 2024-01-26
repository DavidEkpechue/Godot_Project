extends CharacterBody2D

@export var health_component: HealthComponent
@export var shoot_point: Marker2D
@export var fire_component: FiringComponent	 # Reference to the FiringComponent

@export var health: float
@export var speed: float = 400
@export var damage_multiplier: float = 1
@export var base_damage: float = 5
@export var exp: float
@export var projectiles_per_shot: int
@export var power_ups: Array
var can_fire: bool = true
var player_direction: Vector2
var effect_to_apply: String = "fire"

func _ready():
	$Triangle.modulate = Color.SKY_BLUE
	fire_component = $FireComponent	 # Make sure this is the correct path to the FiringComponent

func handle_direction():
	look_at(get_global_mouse_position())
	player_direction = (get_global_mouse_position() - position).normalized()

func handle_main_action():
	if Input.is_action_just_pressed("MainAction") and can_fire:
		print('shoot')
		fire_component.fire_projectile(player_direction, base_damage, effect_to_apply)
		$CooldownComponent.start()
		can_fire = false

func _process(delta):
	handle_direction()
	handle_main_action()

func _physics_process(delta):
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = direction * speed
	move_and_slide()


func _on_cooldown_component_timeout():
	can_fire = true
