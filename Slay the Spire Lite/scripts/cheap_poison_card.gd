extends "res://scripts/card.gd"

func _on_card_clicked():
	if not is_reward_card and cost <= GameState.current_energy:
		StatusManager.apply_effect("poison", enemy, StatusManager.return_duration("poison", enemy))
		enemy.update_status()
	super._on_card_clicked()
	
func _ready():
	super._ready()

