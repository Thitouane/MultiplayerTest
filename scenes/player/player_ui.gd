extends CanvasLayer

func _ready() -> void:
	visible = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("echap") and is_multiplayer_authority():
		visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_return_button_pressed() -> void:
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
