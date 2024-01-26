extends Area2D

@export var speed: int = 1000
var direction: Vector2 = Vector2.UP
var damage: float
var effect: String
func _ready():
	$SelfDestructTimer.start()

func _process(delta):
	position += direction * speed * delta


func _on_body_entered(body):
	var health_component = body.get_node_or_null("HealthComponent")  # Adjust the node path as necessary
	var effects_component = body.get_node_or_null("EffectsComponent")
	
	if effects_component and effects_component.has_method("apply_effect"):
			effects_component.apply_effect(effect, 1, 4)  
			
	if health_component and health_component.has_method("damage"):
		health_component.damage(damage)  
	
	queue_free()



func _on_self_destruct_timer_timeout():
	queue_free()
