extends "res://scripts/card.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()

func _on_card_clicked():
	if not is_reward_card and cost <= GameState.current_energy:
		StatusManager.apply_effect("energized", player, 1)
		player.update_status()
	super._on_card_clicked()
