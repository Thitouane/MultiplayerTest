extends VehicleBody3D

@onready var cam_arm : SpringArm3D = $SpringArm3D

@onready var front_left_wheel: VehicleWheel3D = $FLVehicleWheel3D
@onready var front_right_wheel: VehicleWheel3D = $FRVehicleWheel3D
@onready var back_left_wheel: VehicleWheel3D = $BLVehicleWheel3D
@onready var back_right_wheel: VehicleWheel3D = $BRVehicleWheel3D

@export var front_left_wheel_pos: Vector3 
@export var front_right_wheel_pos: Vector3 
@export var back_left_wheel_pos: Vector3 
@export var back_right_wheel_pos: Vector3

var max_RPM = 450
var max_torque = 300
var turn_speed = 5
var turn_amout = 0.3

func _enter_tree() -> void:
	pass #set_multiplayer_authority(name.to_int())

func _ready() -> void:
	$SpringArm3D/Camera3D.current = is_multiplayer_authority()

func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority(): return
	cam_arm.position = position
	
	var dir = Input.get_action_strength("Gas") - Input.get_action_strength("Brake")
	var steering_dir = Input.get_action_strength("Left") - Input.get_action_strength("Right")

	var RPM_left = abs(back_left_wheel.get_rpm())
	var RPM_right = abs(back_right_wheel.get_rpm())
	var RPM = (RPM_left + RPM_right) / 2.0
	
	var torque = dir * max_torque * (1.0 - RPM / max_RPM)

	engine_force = torque
	steering = lerp(steering, steering_dir * turn_amout, turn_speed * delta)

	if dir == 0:
		brake = 2

	if global_position.y < -10:
		die()

func die():
	print("Tu es mort !")
	get_tree().reload_current_scene()
