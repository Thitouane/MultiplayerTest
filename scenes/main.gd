extends Node2D

var lobby_id = 0
var peer = SteamMultiplayerPeer.new()

@onready var ms = $MultiplayerSpawner
@onready var lobbies = $Buttons/LobbyContainer/Lobbies

func _ready() -> void:
	ms.spawn_function = spawn_level
	Steam.lobby_created.connect(_on_lobby_created)
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	_on_refresh_button_pressed()

func spawn_level(data):
	return (load(data) as PackedScene).instantiate()

func join_lobby(id):
	Steam.joinLobby(id)
	multiplayer.multiplayer_peer = peer
	lobby_id = id
	$Buttons.hide()

func _on_lobby_created(connect, id):
	if connect:
		lobby_id = id
		Steam.setLobbyData(lobby_id, "name", str(Steam.getPersonaName()) + "'s Lobby")
		Steam.setLobbyJoinable(lobby_id, true)
		print(lobby_id)

func _on_lobby_match_list(lobbies):
	for lobby in lobbies:
		var lobby_name = Steam.getLobbyData(lobby, "name")
		var memb_count = Steam.getNumLobbyMembers(lobby)
		
		var button = Button.new()
		button.set_text(str(lobby_name, "| Player Count: ", memb_count))
		button.set_size(Vector2(300, 5))
		button.connect("pressed", Callable(self, "join_lobby").bind(lobby))
		
		self.lobbies.add_child(button)

func _on_lobby_joined(this_lobby_id: int, _permissions: int, _locked: bool, response: int) -> void:
	pass

func _on_host_button_pressed() -> void:
	Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC)
	multiplayer.multiplayer_peer = peer
	ms.spawn("res://scenes/level/level.tscn")
	$Buttons.hide()

func _on_refresh_button_pressed() -> void:
	if lobbies.get_child_count() > 0:
		for n in lobbies.get_children():
			n.queue_free()
	
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	Steam.requestLobbyList()
