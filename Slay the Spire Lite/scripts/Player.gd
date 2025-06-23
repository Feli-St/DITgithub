extends Node2D

@export var max_health = 50
@onready var health = $Health
@onready var StatusManager = $"/root/StatusManager"
var current_health
var block = 0
var damage_taken
signal died
# Called when the node enters the scene tree for the first time.
func _ready():
	current_health = max_health
	update_health()
	
func update_tooltip():
	health.tooltip_text = "You have " + str(current_health) + " health and " + str(block) + " block"
	
func update_health():
	health.text = str(current_health) + "/" + str(max_health) + "(" + str(block) + ")"
	update_tooltip()
	
	
func take_damage(damage):
	if block < damage:
		damage_taken = damage - block
		block = 0
	elif block == damage:
		damage_taken = 0
		block = 0
	else:
		damage_taken = 0
		block = block - damage
	current_health -= damage_taken
	print("Player took ", damage_taken, " damage")
	print("Health: ", current_health)
	if current_health <= 0:
		die()
	update_health()
	
func gain_health(amount):
	current_health = min(current_health + amount, max_health)
	
	
func apply_block(block_added):
	block += block_added
	print(block_added, "added to block")
	print("New block: ", block)
	update_health()
	
func reset_block():
	block = 0
	update_health()
	
func die():
	print("You lost!")
	emit_signal("died")
	queue_free()

