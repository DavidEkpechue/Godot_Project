extends ProgressBar

@export var health_component: HealthComponent

@onready var timer = $Timer
@onready var dmg_bar = $DamageBar

@onready var health = health_component.health

func _ready():
	if health_component:
		health_component.connect("health_changed", Callable(self, "_set_healthbar"))
		
func _set_healthbar(new_health):
	# Update the ProgressBar to reflect the new health
	value = new_health
	
	# Update the DamageBar if health decreased
	if new_health < dmg_bar.value:
		timer.start()
	else:
		dmg_bar.value = new_health
	
	# Check if health component is fully depleted
	if new_health <= 0:
		queue_free()

	var prev_health = health
	health = min(max_value, new_health)
	value = health
	
	if health <= 0:
		queue_free()
	
	if health < prev_health:
		timer.start()
	else:
		dmg_bar.value = health
	

func _on_timer_timeout():
	var tween = get_tree().create_tween()
	tween.tween_property($DamageBar, "value", health, .5).set_ease(Tween.EASE_OUT)
