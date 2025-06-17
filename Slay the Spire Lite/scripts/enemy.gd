extends Node2D

@export var max_health = 100
var current_health 
@onready var health = $Health
@onready var intention_text = $Intention
@onready var status_manager = $"/root/StatusManager"
@onready var status_label = $Status
var intention
var damage
var status_effects = {}

signal enemy_defeated
signal attacked(damage)

# Called when the node enters the scene tree for the first time.
func _ready():
	current_health = max_health
	update_health()
	change_intention()

func change_intention():
	intention = randi_range(10, 25)
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
	if status_effects.has("weak"):
		intention = status_manager.apply_weak_to_damage(intention)
		print("Weak applied")
	emit_signal("attacked", intention)

func update_status():
	var status_label_text = ""
	if not status_effects.is_empty():
		for status in status_effects:
			status_label_text += (str(status) + " " + str(status_effects[status].duration)) + "\n"
		status_label.text = status_label_text
	else:
		status_label.text = ""
	
