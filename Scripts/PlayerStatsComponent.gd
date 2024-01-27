extends Node2D
class_name StatsComponent

var coins: int = 0
@export var health_component: HealthComponent
var health
func _ready():
	if health_component:
		health_component.connect("health_changed", Callable(self, "update_health"))

func add_coins(amount):
	coins += amount
	print(coins)

func update_health(health_amt):
	health = health_amt
	print(health)
