extends Control

@onready var GameState = $"/root/GameState"
@onready var discard_pile = $Discard_pile
@onready var draw_pile = $Draw_pile
signal turn_ended()
# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.energy_changed.connect(update_energy)
	update_energy()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_energy():
	$Energy.text = str(GameState.get_current_energy())

func _on_button_pressed():
	emit_signal("turn_ended")
	
func update_piles(draw_length, discard_length):
	draw_pile.text = str(draw_length)
	discard_pile.text = str(discard_length)
	
	
