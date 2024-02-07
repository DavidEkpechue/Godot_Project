extends Node2D
class_name HitflashComponent
@export var health_component: HealthComponent
@export var hitflash_animation: AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	if health_component:
		health_component.connect("health_changed", Callable(self, "play_hitflash"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func play_hitflash(_damage):
	hitflash_animation.play("HitFlash")
	print('hitflash')
