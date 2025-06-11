extends Node2D

@onready var enemy = $Enemy
@onready var player = $Player
@onready var GameState = $"/root/GameState"
@onready var hud = $HUD
@onready var hand_ui = $Hand_ui/HBoxContainer
@onready var GameOverScreen = $GameOverScreen
@onready var VictoryScreen = $VictoryScreen
@onready var instructions = $Instructions
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
	draw_cards(4)
	shuffle_draw_pile()
	if not GameState.instructions_seen:
		instructions.visible = true
	
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

func _on_card_card_played(damage, block, energy, cost, cards_to_draw, card):
	if cost <= GameState.get_current_energy():
		if enemy:
			if damage:
				print("Card played for ", damage, " damage")
				enemy.take_damage(damage)
			if block:
				print("Card played for ", block, " block")
				player.apply_block(block)
			if energy:
				print("Card played for ", energy, "energy")
				GameState.gain_energy(energy)
			if cost:
				print("Cost: ", cost)
				GameState.use_energy(cost)
			if cards_to_draw:
				print("Card played for ", cards_to_draw, "cards")
				draw_cards(cards_to_draw)
			discard_card(card)
				
	


func _on_enemy_defeated():
	enemy = null
	VictoryScreen.visible = true
	get_tree().paused = true

func turn_start():
	GameState.reset_energy()
	player.reset_block()
	draw_cards(4)
	enemy.change_intention()
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
	GameOverScreen.visible = true
	get_tree().paused = true


func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_continue_pressed():
	instructions.visible = false
	GameState.instructions_seen = true
