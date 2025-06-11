extends Node2D

@export var max_health = 50
var current_health 
@onready var health = $Health
@onready var intention_text = $Intention
var intention

signal enemy_defeated
signal attacked(damage)

# Called when the node enters the scene tree for the first time.
func _ready():
	current_health = max_health
	update_health()
	change_intention()

func change_intention():
	intention = randi_range(5, 20)
	intention_text.text = "Intention: " + str(intention) + " damage"
	intention_text.tooltip_text = "The enemy intends to attack for " + str(intention) + " damage"

func take_damage(damage):
	current_health -= damage
	if current_health <= 0:
		die()
	update_health()
	
func die():
	print("Enemy defeated!")
	emit_signal("enemy_defeated")
	queue_free()
	
func update_health():
	health.text = str(current_health) + "/" + str(max_health)
	health.tooltip_text = "The enemy has " + str(current_health) + " health"
	
func attack():
	print("Enemy attacked")
	emit_signal("attacked", intention)
