extends Node2D

var min_rate = 0.8
var max_rate = 1.4

const INITIAL_ZONES = 2
const MAX_ZONES = 5

const COIN_CHANCE = 0.25

var zones = INITIAL_ZONES
var zone_width = 1280 / INITIAL_ZONES

var platform_scene
var platform_speed = 100

var coin_scene

var rate = [0.2, 0.4]
var timer = [0.0, 0.0]

func _ready():
	platform_scene = preload("res://Scenes/Platform/Platform.tscn")
	coin_scene = preload("res://Scenes/Coin/Coin.tscn")

func _process(delta):
	for i in range(zones):
		timer[i] += delta
		if timer[i] > rate[i]:
			create(i)

func create(zone):
	randomize()
	
	if randf() <= COIN_CHANCE:
		var coin = coin_scene.instance()
		var min_x = (zone * zone_width) + 8
		var rand_x = (randi() % (zone_width - 16)) + min_x
		coin.create(Vector2(rand_x, 0))
		coin.set_speed(platform_speed)
		coin.connect("touched", get_parent(), "on_coin_collected")
		add_child(coin)
		return
	
	var game_speed = Globals.get("game_speed")
	timer[zone] -= rate[zone]
	rate[zone] = (randf() * (max_rate / game_speed)) + (min_rate / game_speed)

	var platform = platform_scene.instance()
	platform.set_block_count(randi()%4 + 2)
	var platform_width = platform.get_width()

	var min_x = (zone * zone_width) + (platform_width / 2)
	var rand_x = (randi() % (zone_width - platform_width)) + min_x
	var position = Vector2(rand_x, 0)
	
	platform.create(position)
	platform.set_speed(platform_speed)
	add_child(platform)

func get_speed():
	return platform_speed

func set_speed(speed):
	platform_speed = speed
	for platform in get_children():
		platform.set_speed(speed)


func reset():
	timer = [0.0, 0.0]
	rate = [0.2, 0.4]

	for platform in get_children():
		remove_child(platform)
		platform.free()