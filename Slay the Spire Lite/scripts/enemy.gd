extends Node2D

@export var max_health = 50
var current_health 
@onready var health = $Health

signal enemy_defeated
signal attacked(damage)

# Called when the node enters the scene tree for the first time.
func _ready():
	current_health = max_health
	health.text = str(current_health) + "/" + str(max_health)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

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
	
func attack():
	print("Enemy attacked")
	emit_signal("attacked", 5)
