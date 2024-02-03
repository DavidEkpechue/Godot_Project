extends Node2D
class_name StatsComponent

@export var health_component: HealthComponent

var coins: int = 0
var health
var experience

func _ready():
	if health_component:
		health_component.connect("health_changed", Callable(self, "update_health"))
	


func add_coins(amount):
	coins += amount
	print(coins)

func update_health(health_amt):
	health = health_amt
	print(health)

func change_stat(stat_change, stat_amt):
	print("changing stat", stat_change)
	match stat_change:
		"coins":
			add_coins(stat_amt)
		"health":
			health_component.heal(stat_amt)
