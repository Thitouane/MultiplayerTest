extends Node

const steamID = 480

func _ready() -> void:
	OS.set_environment("SteamAppID", str(steamID))
	OS.set_environment("SteamGameD", str(steamID))
	Steam.steamInitEx()

func _process(delta: float) -> void:
	Steam.run_callbacks()
