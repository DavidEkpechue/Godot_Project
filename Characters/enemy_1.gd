extends CharacterBody2D

var speed = 100
var player_chase = false
var player:CharacterBody2D
var direction

func _physics_process(_delta):
	if player_chase and player:
		look_at(player.global_position)  
		direction = (player.global_position - global_position).normalized()  
		velocity = direction * speed
		move_and_slide()



func _on_detection_area_body_entered(body):
	player = body
	player_chase = true
	


func _on_detection_area_body_exited(_body):
	player = null
	player_chase = false
