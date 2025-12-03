extends Node

const IP_ADDRESS: String = "localhost"
const PORT: int = 42069
const MAX_CLIENTS: int = 32

const LEVEL = "res://scenes/levels/level_01.tscn"

var peer: ENetMultiplayerPeer

func _ready() -> void:
	$"../LevelSpawner".spawn_function = spawn_level

func start_server() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_CLIENTS)
	multiplayer.multiplayer_peer = peer
	
	multiplayer.peer_connected.connect(
		func(pid): 
			print("Peer " + str(pid) + " has joined the game !")
			#$"../MultiplayerSpawner".spawn(multiplayer.get_unique_id())
	)
	
	$"../LevelSpawner/Hub".queue_free()
	
	$"../LevelSpawner".spawn(LEVEL)
	$"../HUD/ENetHUD".hide()
	print("Hosting Game...")

func start_client() -> void:
	$"../LevelSpawner/Hub".queue_free()
	
	peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer
	
	$"../HUD/ENetHUD".hide()
	print("Joinning Game...")

func spawn_level(data):
	return (load(data) as PackedScene).instantiate()
