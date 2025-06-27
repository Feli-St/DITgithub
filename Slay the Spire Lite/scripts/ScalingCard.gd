extends "res://scripts/card.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	update_description()
	super._ready()

func update_description():
	description = "Deal " + str(GameState.scaling_damage) + " damage, increase by 2 each time"
	description_label.text = description
func _on_card_clicked():
	if not is_reward_card and cost <= GameState.current_energy:
		damage = GameState.scaling_damage
		update_description()
		GameState.scaling_damage += 2
	super._on_card_clicked()
	
	
