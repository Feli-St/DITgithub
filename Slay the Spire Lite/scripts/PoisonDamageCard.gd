extends "res://scripts/card.gd"

func _on_card_clicked():
	if not is_reward_card and cost <= GameState.current_energy:
		if enemy.status_effects.has("poison"):
			damage = StatusManager.return_duration("poison", enemy)
	super._on_card_clicked()
	
func _ready():
	super._ready()
