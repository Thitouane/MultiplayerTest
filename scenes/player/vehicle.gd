class_name Vehicle extends VehicleBody3D

@onready var cam_arm : CamArm = $CamArm
@onready var cam : Camera3D = $CamArm/Camera3D

@onready var front_left_wheel: VehicleWheel3D = $FLVehicleWheel3D
@onready var front_right_wheel: VehicleWheel3D = $FRVehicleWheel3D
@onready var back_left_wheel: VehicleWheel3D = $BLVehicleWheel3D
@onready var back_right_wheel: VehicleWheel3D = $BRVehicleWheel3D

@export var front_left_wheel_pos: Vector3 
@export var front_right_wheel_pos: Vector3 
@export var back_left_wheel_pos: Vector3 
@export var back_right_wheel_pos: Vector3

@onready var pause_menu:= $PauseMenu
@onready var hud:= $HUD

@export var steam_id: int = 0 ## The Steam ID of the player
@export var steam_username: String = "" ## The Steam username of the player

var max_RPM = 450
var max_torque = 300
var turn_speed = 5
var turn_amout = 0.3

var can_control = true

func _ready() -> void:
	if can_control:
		setup()

func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority(): return
	cam_arm.position = position
	
	if can_control:
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

func setup():
	cam_arm.ready()
		
	if front_left_wheel.get_child_count() > 0 :
		clear_wheels()
	set_wheels(PlayerManager.selected_wheels)
	
	pause_menu.usable = true
	hud.visible = true

func die():
	print("Tu es mort !")
	get_tree().reload_current_scene()

func clear_wheels():
	for i in front_left_wheel.get_children():
		i.queue_free()
	for i in front_right_wheel.get_children():
		i.queue_free()
	for i in back_left_wheel.get_children():
		i.queue_free()
	for i in back_right_wheel.get_children():
		i.queue_free()

func set_wheels(name: String):
	var wheels1 = load("res://scenes/Vehicle/Wheels/" + name + ".tscn").instantiate()
	turn_speed = wheels1.speed

	front_left_wheel.add_child(wheels1)
	wheels1.position = front_left_wheel_pos

	var wheels2 = load("res://scenes/Vehicle/Wheels/" + name + ".tscn").instantiate()
	front_right_wheel.add_child(wheels2)
	wheels2.position = front_right_wheel_pos
	wheels2.rotation_degrees = Vector3(0,180,0)
	
	var wheels3 = load("res://scenes/Vehicle/Wheels/" + name + ".tscn").instantiate()
	back_left_wheel.add_child(wheels3)
	wheels3.position = back_left_wheel_pos
	
	var wheels4 = load("res://scenes/Vehicle/Wheels/" + name + ".tscn").instantiate()
	back_right_wheel.add_child(wheels4)
	wheels4.position = back_right_wheel_pos
	wheels4.rotation_degrees = Vector3(0,180,0)

@rpc("any_peer", "call_local")
func set_authority(id : int) -> void:
	set_multiplayer_authority(id)

@rpc("any_peer", "call_local")
func teleport(new_position : Vector3) -> void:
	self.position = new_position
