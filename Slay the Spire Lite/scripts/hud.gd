extends Control

@onready var GameState = $"/root/GameState"
@onready var discard_pile = $Discard_pile
@onready var draw_pile = $Draw_pile
signal turn_ended()
# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.energy_changed.connect(update_energy)
	update_energy()
	$Button.tooltip_text = "End your turn and start enemy turn"
	draw_pile.tooltip_text = "Amount of cards in your draw pile"
	discard_pile.tooltip_text = "Amount of cards in your discard pile"
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_energy():
	$Energy.text = "Energy: " + str(GameState.get_current_energy())
	$Energy.tooltip_text = "You have " + str(GameState.current_energy) + " energy"

func _on_button_pressed():
	emit_signal("turn_ended")
	
func update_piles(draw_length, discard_length):
	draw_pile.text = str(draw_length)
	discard_pile.text = str(discard_length)
	
	
