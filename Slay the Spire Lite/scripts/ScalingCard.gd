extends "res://scripts/card.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	update_description()
	super._ready()

func update_description():
	description = "Deal " + str(damage) + " damage, increase by 2 each time"
	description_label.text = description
func _on_card_clicked():
	super._on_card_clicked()
	damage += 2
	update_description()
	
