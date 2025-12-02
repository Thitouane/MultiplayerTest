extends CanvasLayer

func _on_server_button_pressed() -> void:
	$"../ENetManager".start_server()

func _on_client_button_pressed() -> void:
	$"../ENetManager".start_client()
