extends "res://scripts/card.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	
func _on_card_clicked():
	if not is_reward_card and cost <= GameState.current_energy:
		damage = 5 * game.cards_played_this_turn
	super._on_card_clicked()
