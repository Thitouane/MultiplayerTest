extends Node

const IP_ADDRESS: String = "localhost"
const PORT: int = 42069
const MAX_CLIENTS: int = 32

const PLAYER = preload("res://scenes/player/player2D.tscn")

var peer: ENetMultiplayerPeer

var players: Array[Node]

func _ready() -> void:
	$"../MultiplayerSpawner".spawn_function = add_player

func start_server() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_CLIENTS)
	multiplayer.multiplayer_peer = peer
	
	multiplayer.peer_connected.connect(
		func(pid): 
			print("Peer " + str(pid) + " has joined the game !")
			$"../MultiplayerSpawner".spawn(pid)
	)
	
	$"../MultiplayerSpawner".spawn(multiplayer.get_unique_id())
	
	$"../ENetHUD".hide()
	$"../Camera2D".enabled = false

func start_client() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer
	
	$"../ENetHUD".hide()
	$"../Camera2D".enabled = false

func add_player(pid):
	var player = PLAYER.instantiate()
	player.name = str(pid)
	
	print($"../BG".get_child(players.size()))
	
	player.global_position = $"../BG".get_child(players.size()).global_position
	players.append(player)
	
	return player
