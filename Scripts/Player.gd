extends CharacterBody2D

@export var health_component: HealthComponent
@export var shoot_point: Marker2D
@export var fire_component: FiringComponent  # Reference to the FiringComponent
@export var dash_component: DashComponent  # Add this line

@export var health: float
@export var speed: float = 400
@export var damage_multiplier: float = 1
@export var base_damage: float = 5
@export var exp: float
@export var projectiles_per_shot: int = 3
@export var power_ups: Array

var can_fire: bool = true
var can_dash: bool = true  # Make sure to control this variable based on dash cooldown
var player_direction: Vector2
var effect_array: Array
var effect_to_apply: String 
var effect_intensity: float = 1.0
var effect_duration: int = 5
var effect_seconds_between_tics: float = 1.0


func set_effect():
	# Initialize the effect_array with poison effect details
	effect_array = [effect_to_apply, effect_intensity, effect_duration, effect_seconds_between_tics]

func _ready():
	# Set the initial color of the triangle and get the components
	$Triangle.modulate = Color.SKY_BLUE
	fire_component = $FireComponent
	# dash_component.connect("dash_cooldown_complete", Callable(self, "_on_dash_cooldown_complete"))
	health_component.damage(0)

func handle_direction():
	# Rotate the player to face the mouse position
	look_at(get_global_mouse_position())
	player_direction = (get_global_mouse_position() - position).normalized()

func handle_main_action():
	# Handle the main action (shooting)
	if Input.is_action_just_pressed("MainAction") and can_fire:
		for i in range(projectiles_per_shot):
			set_effect()
			fire_component.fire_projectile(player_direction, base_damage, effect_array)
			await get_tree().create_timer(.0355).timeout 
			$CooldownComponent.start()
		can_fire = false

func handle_dash():
	if Input.is_action_just_pressed("Dash") and can_dash:
		dash_component.dash(player_direction)  # Use the current player direction for dashing
		can_dash = false  # Disable dashing until cooldown finishes

func _process(delta):
	# Process input for direction, main action, and dash
	handle_direction()
	handle_main_action()
	handle_dash()

func _physics_process(delta):
	if dash_component.is_dashing:
		# When dashing, use the dash velocity from the DashComponent
		velocity = dash_component.dash_velocity
	else:
		# Regular movement logic
		var direction = Input.get_vector("Left", "Right", "Up", "Down")
		velocity = direction * speed
	
	# Apply the calculated velocity
	move_and_slide()

func _on_cooldown_component_timeout():
	# Reset the ability to fire and dash after the cooldown
	can_fire = true

func _on_dash_cooldown_complete():
	can_dash = true  # Re-enable dashing after cooldown
