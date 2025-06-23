extends "res://scripts/card.gd"

func _on_card_clicked():
	if not is_reward_card:
		game.discard_hand()
	super._on_card_clicked()
	
func _ready():
	super._ready()
