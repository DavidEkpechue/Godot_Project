extends Node
class_name DashComponent

# Exports for customizing the dash behavior
@export var dash_speed: float = 2000.0  # Dash speed
@export var dash_duration: float = 1  # Dash time in seconds
@export var dash_cooldown: float = 1.0  # Cooldown time in seconds
@export var dash_effect: GPUParticles2D
var is_dashing: bool = false
var dash_velocity: Vector2 = Vector2.ZERO  # Separate variable for dash velocity

# Reference to the parent CharacterBody2D
@onready var character_body: CharacterBody2D = get_parent() as CharacterBody2D

# Timer for managing dash duration
@onready var dash_timer: Timer = Timer.new()

# Timer for managing dash cooldown
@onready var cooldown_timer: Timer = Timer.new()

signal dash_cooldown_complete


func _ready():
	add_child(dash_timer)
	add_child(cooldown_timer)
	dash_timer.connect("timeout", Callable(self, "_on_dash_timer_timeout"))
	cooldown_timer.connect("timeout", Callable(self, "_on_cooldown_timer_timeout"))
	dash_timer.set_one_shot(true)
	cooldown_timer.set_one_shot(true)

# Function to start the dash
func dash(direction: Vector2):
	if not is_dashing and cooldown_timer.is_stopped():  # Check that we're not already dashing and cooldown is done
		print('test')
		dash_effect.emitting = true
		dash_velocity = direction.normalized() * dash_speed
		is_dashing = true
		dash_timer.start(dash_duration)

# Function called when dash duration is over
func _on_dash_timer_timeout():
	is_dashing = false
	dash_effect.emitting = false
	character_body.velocity = Vector2.ZERO  # Reset the character's velocity
	cooldown_timer.start(dash_cooldown)

# Function called when dash cooldown is over
func _on_cooldown_timer_timeout():
	dash_cooldown_complete.emit()
