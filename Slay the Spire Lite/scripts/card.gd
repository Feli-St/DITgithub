extends Control

@export var card_name = "Strike"
@export var cost = 1
@export var damage = 6
@export var description = "Deal 6 damage"

# Called when the node enters the scene tree for the first time.
func _ready():
	$CardName.text = card_name
	$Description.text = description
	$Cost.text = str(cost)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_card_clicked(event):
	if event is InputEventMouseButton and event.buton_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Card clicked:", card_name)
