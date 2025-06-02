extends Node2D

@onready var enemy = $Enemy
@onready var player = $Player
@onready var GameState = $"/root/GameState"
@onready var hud = $HUD
@onready var hand_ui = $Hand_ui/HBoxContainer
@export var card_scenes : Array[PackedScene]
var draw_pile = []
var hand = []
var discard_pile = []
# Called when the node enters the scene tree for the first time.
func _ready():
	for card_scene in card_scenes:
		var card_instance = card_scene.instantiate()
		card_instance.connect("card_played", _on_card_card_played)
		draw_pile.append(card_instance)
	draw_cards(2)
	
func draw_cards(amount):
	for i in range(amount):
		if draw_pile.is_empty():
			reshuffle()
			print("reshuffling...")
		if draw_pile.is_empty():
			return
		var card = draw_pile.pop_back()
		hand.append(card)
		add_card_to_hand_ui(card)
		print(card, "drawn")
	hud.update_piles(len(draw_pile), len(discard_pile))
	
func discard_card(card):
	hand.erase(card)
	discard_pile.append(card)
	print(card, "discarded")
	hand_ui.remove_child(card)
	hud.update_piles(len(draw_pile), len(discard_pile))
	
	
func reshuffle():
	for card in discard_pile:
		draw_pile.append(card)
	print(draw_pile)
	discard_pile.clear()
	shuffle_draw_pile()
	hud.update_piles(len(draw_pile), len(discard_pile))
	
func shuffle_draw_pile():
	draw_pile.shuffle()
	
func discard_hand():
	var cards_to_discard = hand.duplicate()
	for card in cards_to_discard:
		discard_card(card)

func add_card_to_hand_ui(card):
	hand_ui.add_child(card)

func _on_card_card_played(damage, block, cost, card):
	if cost - 1 <= GameState.get_current_energy():
		if enemy:
			if damage:
				print("Card played for ", damage, " damage")
				enemy.take_damage(damage)
			if block:
				print("Card played for ", block, " block")
				player.apply_block(block)
			if cost:
				print("Cost: ", cost)
			discard_card(card)
				
	


func _on_enemy_defeated():
	enemy = null

func turn_start():
	GameState.reset_energy()
	player.reset_block()
	draw_cards(2)
	print(draw_pile)
	print(hand)
	print(discard_pile)


func _on_turn_ended():
	print("Turn ended")
	if enemy:
		enemy.attack()
	discard_hand()
	turn_start()
		
func _on_enemy_attacked(damage):
	player.take_damage(damage)


func _on_player_died():
	pass
