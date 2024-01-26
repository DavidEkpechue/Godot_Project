extends Node2D

var fire_component
# Called when the node enters the scene tree for the first time.
func _ready():
	fire_component = $FireComponent # Make sure this is the correct path to the FiringComponent

var direction = Vector2.RIGHT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Marker2D.position = get_global_mouse_position()
	var pos = $Marker2D.position
	
	if Input.is_action_just_pressed("MainAction"):
		print('shoot')
		$FireComponent.fire_projectile(direction, pos)
