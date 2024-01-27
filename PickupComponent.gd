extends Node2D
class_name PickupComponent

@export var pickup_area: Area2D

func _ready():
	if pickup_area:
		pickup_area.connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if get_parent():  # Check if the PickupComponent has a parent before trying to delete it
		print('picked up: ', get_parent().name)
		get_parent().queue_free()  # This will free the parent node, which includes this PickupComponent
	else:
		queue_free()  # If there is no parent, just free the PickupComponent itself
