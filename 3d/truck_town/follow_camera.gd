
extends Camera

# Member variables
var collision_exception = []
export var min_distance = 0.5
export var max_distance = 4.0
export var angle_v_adjust = 0.0
export var autoturn_ray_aperture = 25
export var autoturn_speed = 50
var max_height = 2.0
var min_height = 0
var following_camera = true
var up = Vector3(0, 1, 0)
var target
var pos

func do_camera_follow():
	target = get_parent().get_global_transform().origin
	pos = get_global_transform().origin
	
	var delta = pos - target
	
	# Regular delta follow
	
	# Check ranges
	if (delta.length() < min_distance):
		delta = delta.normalized()*min_distance
	elif (delta.length() > max_distance):
		delta = delta.normalized()*max_distance
	
	# Check upper and lower height
	if ( delta.y > max_height):
		delta.y = max_height
	if ( delta.y < min_height):
		delta.y = min_height
	
	pos = target + delta
	
	look_at_from_position(pos, target, up)
	
	# Turn a little up or down
	var t = get_transform()
	t.basis = Basis(t.basis[0], deg2rad(angle_v_adjust))*t.basis
	set_transform(t)
	
func do_freecamera():
	if Input.is_action_just_pressed("ui_up"):
		pos.y = pos.y + 1
	if Input.is_action_just_pressed("ui_down"):
		pos.y = pos.y -1
	if Input.is_action_just_pressed("ui_left"):
		target.x = target.x -1
	if Input.is_action_just_pressed("ui_right"):
		target.x = target.x + 1
		
	look_at_from_position(pos, target, up)
	
func _physics_process(dt):
	if Input.is_action_just_pressed("ui_camerafollow"):
		following_camera = !following_camera
		
	if following_camera:
		do_camera_follow()
	else:
		do_freecamera()


func _ready():
	# Find collision exceptions for ray
	var node = self
	while(node):
		if (node is RigidBody):
			collision_exception.append(node.get_rid())
			break
		else:
			node = node.get_parent()
	
	# This detaches the camera transform from the parent spatial node
	set_as_toplevel(true)
