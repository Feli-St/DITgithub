extends "res://scripts/card.gd"

func _on_card_clicked():
	if not is_reward_card and cost <= GameState.current_energy:
		game.discard_hand()
		game.draw_cards(4)
	super._on_card_clicked()
	
func _ready():
	super._ready()
