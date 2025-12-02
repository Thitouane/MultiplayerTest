extends SpringArm3D

var MouseSensitivity = 0.1
@onready var camera := $Camera3D

func _ready() -> void:
	set_as_top_level(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if !is_multiplayer_authority(): return
	if event is InputEventMouseMotion:
		rotation_degrees.x -= event.relative.y * MouseSensitivity
		rotation_degrees.x = clamp(rotation_degrees.x, -90.0, -10.0)
		
		rotation_degrees.y -= event.relative.x * MouseSensitivity
		rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)
