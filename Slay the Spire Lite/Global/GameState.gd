extends Node

@export var max_energy = 3
var current_energy = max_energy
signal energy_changed

func reset_energy():
	current_energy = max_energy
	emit_signal("energy_changed")
	
func use_energy(amount):
	if current_energy >= amount:
		current_energy -= amount
		print("Energy left: ", current_energy)
		emit_signal("energy_changed")
		return true
	else:
		print("Not enough energy")
		
func gain_energy(amount):
	current_energy = current_energy + amount
	print("Energy gained. Current energy: ", current_energy)
	emit_signal("energy_changed")
	
func get_current_energy():
		return current_energy
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
