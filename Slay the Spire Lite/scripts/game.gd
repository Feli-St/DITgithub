extends Node2D

@onready var enemy = $Enemy
@onready var player = $Player
@onready var GameState = $"/root/GameState"
@onready var StatusManager = $"/root/StatusManager"
@onready var hud = $HUD
@onready var hand_ui = $Hand_ui/HBoxContainer
@onready var GameOverScreen = $GameOverScreen
@onready var VictoryScreen = $VictoryScreen
@onready var instructions = $Instructions
@export var card_scenes : Array[PackedScene]
@export var deck : Array[PackedScene]
var cards_played_this_turn = 0
var draw_pile = []
var hand = []
var discard_pile = []
var encounter_level = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	for card_scene in deck:
		draw_pile.append(card_scene)
	shuffle_draw_pile()
	draw_cards(4)
	if not GameState.instructions_seen:
		instructions.visible = true
	enemy.position = $EnemySpawnPoint.global_position
	update_level()
	update_highscore()
	
func instantiate_card(card):
	if card:
		var card_instance = card.instantiate()
		card_instance.add_to_group("cards")
		card_instance.connect("card_played", _on_card_card_played)
		card_instance.game = self
		card_instance.enemy = enemy
		card_instance.player = player
		return card_instance
	
func convert_to_packed_scene(card_instance):
	var file_path = card_instance.scene_file_path
	var packed_scene = load(file_path) as PackedScene
	return packed_scene
	
func draw_cards(amount):
	for i in range(amount):
		if draw_pile.is_empty():
			reshuffle()
			print("reshuffling...")
		if draw_pile.is_empty():
			return
		var card = draw_pile.pop_back()
		var card_instance = instantiate_card(card)
		hand.append(card_instance)
		add_card_to_hand_ui(card_instance)
		print(card, "drawn")
	hud.update_piles(len(draw_pile), len(discard_pile))
	
func discard_card(card_instance):
	if card_instance in hand:
		hand.erase(card_instance)
		var card = convert_to_packed_scene(card_instance)
		discard_pile.append(card)
		print(card, "discarded")
		hand_ui.remove_child(card_instance)
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
	
func add_card_to_deck(card):
	deck.append(card)
	draw_pile.append(card)
	
func remove_card_from_deck(card):
	deck.erase(card)

func _on_card_card_played(damage, block, energy, cost, cards_to_draw, status_effect, status_duration, card):
	if cost <= GameState.get_current_energy():
		if enemy:
			if damage:
				print("Card played for ", damage, " damage")
				if enemy.status_effects.has("vulnerable"):
					damage = StatusManager.apply_vulnerable_to_damage(damage)
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
			if status_effect:
				StatusManager.apply_effect(status_effect, enemy, status_duration)
				if enemy:
					enemy.update_status()
			discard_card(card)
			cards_played_this_turn += 1


func _on_enemy_defeated():
	if $GameOverScreen.visible == false:
		enemy = null
		VictoryScreen.visible = true
		get_tree().paused = true
		var reward_cards = []
		for i in range(3):
			var card_scene
			while true:
				card_scene = card_scenes.pick_random()
				if card_scene not in reward_cards:
					reward_cards.append(card_scene)
					break
			var card = card_scene.instantiate()
			card.is_reward_card = true
			card.connect("chosen_as_reward_card", _on_reward_card_chosen)
			$VictoryScreen/RewardCards.add_child(card)
	
func _on_reward_card_chosen(card):
	var scene_path = card.scene_file_path
	var packed_scene = load(scene_path) as PackedScene
	add_card_to_deck(packed_scene)
	card.is_reward_card = false
	print("Reward card added to deck")
	start_next_encounter()

func start_next_encounter():
	VictoryScreen.visible = false
	for child in $VictoryScreen/RewardCards.get_children():
		$VictoryScreen/RewardCards.remove_child(child)
	get_tree().paused = false
	discard_hand()
	reshuffle()
	shuffle_draw_pile()
	player.status_effects.clear()
	encounter_level += 1
	update_level()
	
	enemy = preload("res://scenes/enemy.tscn").instantiate()
	enemy.max_health += encounter_level * 2
	enemy.intention_min += encounter_level 
	enemy.intention_max += encounter_level 
	enemy.position = $EnemySpawnPoint.global_position
	add_child(enemy)
	enemy.connect("attacked", _on_enemy_attacked)
	enemy.connect("enemy_defeated", _on_enemy_defeated)
	
	if encounter_level > GameState.highscore:
		GameState.highscore = encounter_level
		update_highscore()
		
	turn_start()

func turn_start():
	if enemy:
		GameState.reset_energy()
		if player:
			player.reset_block()
			if player.status_effects.has("energized"):
				GameState.gain_energy(1)
		if enemy.status_effects.has("poison"):
			enemy.take_damage(enemy.status_effects["poison"].duration)
		StatusManager.lower_duration(enemy)
		StatusManager.lower_duration(player)
		if player:
			player.update_status()
		if enemy:
			enemy.update_status()
			enemy.change_intention()
			print(enemy.status_effects)
		draw_cards(4)
		#print(draw_pile)
		#print(hand)
		#print(discard_pile)
		


func _on_turn_ended():
	print("Cards played this turn: ", cards_played_this_turn)
	cards_played_this_turn = 0
	print("Turn ended")
	if enemy:
		enemy.attack()
	discard_hand()
	turn_start()
		
func _on_enemy_attacked(damage):
	player.take_damage(damage)


func _on_player_died():
	GameOverScreen.visible = true
	player = null
	$GameOverScreen/Label2.text = "You got to level " + str(encounter_level)
	get_tree().paused = true
	
func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_skip_button_pressed():
	player.gain_health(10)
	start_next_encounter()


func _on_continue_pressed():
	instructions.visible = false
	GameState.instructions_seen = true

func update_level():
	$Level.text = "Current level: " + str(encounter_level)
	
func update_highscore():
	$Highscore.text = "HIGHSCORE: " + str(GameState.highscore)
