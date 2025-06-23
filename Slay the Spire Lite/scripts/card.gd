extends Control

@export var card_name = "Strike"
@export var cost = 1
@export var damage = 6
@export var block = 0
@export var energy = 0
@export var cards_to_draw = 0
@export var status_effect:String
@export var status_duration:int
@export var description = "Deal 6 damage"
signal card_played(damage, block, cost)
signal chosen_as_reward_card(card)
@onready var cardName = $CardName
@onready var description_label = $Description
@onready var cost_label = $Cost
@onready var StatusManager = $"/root/StatusManager"
var game = null
var enemy = null
var player = null
var is_reward_card = false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("pressed", _on_card_clicked)
	cardName.text = card_name
	description_label.text = description
	cost_label.text = str(cost)
	cost_label.tooltip_text = "This card costs " + str(cost) + " energy to play"

func _on_card_clicked():
	if is_reward_card:
		emit_signal("chosen_as_reward_card", self)
		print(self, " selected as reward")
	else:	
		if GameState.get_current_energy() >= cost:		#fix this next time please its so confusing and makes no sense like this
			print("Card clicked:", card_name)
			emit_signal("card_played", damage, block, energy, cost, cards_to_draw, status_effect, status_duration, self)
	

