extends Control

@export var card_name = "Strike"
@export var cost = 1
@export var damage = 6
@export var block = 0
@export var energy = 0
@export var cards_to_draw = 0
@export var description = "Deal 6 damage"
signal card_played(damage, block, cost)

# Called when the node enters the scene tree for the first time.
func _ready():
	$CardName.text = card_name
	$Description.text = description
	$Cost.text = str(cost)
	$Cost.tooltip_text = "This card costs " + str(cost) + " energy to play"
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_card_clicked():
	if GameState.get_current_energy() >= cost:		#fix this next time please its so confusing and makes no sense like this
		print("Card clicked:", card_name)
		emit_signal("card_played", damage, block, energy, cost, cards_to_draw, self)
	

