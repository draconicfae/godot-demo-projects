extends VehicleBody

# Member variables
const STEER_SPEED = 1
const STEER_LIMIT = 0.4

var steer_angle = 0
var steer_target = 0
var menu_initialized = false
var menu_manager = null

export var engine_force_value = 40

func printee_one():
	print("submenu tester 1")
	
func printee_two():
	print("submenu tester 2")
	
func printee_three():
	print("submenu tester 3")
	
func initialize_menu():
	var basenode = get_node('/root/base')
	menu_manager = basenode.call("get_menu_manager")
	menu_manager.add_submenu_autokeys("testermenu",self, "ui_testermenu", ["printee_one","printee_two","printee_three"])
	
func _physics_process(delta):
	if Input.is_action_pressed("ui_left"):
		steer_target = STEER_LIMIT
	elif Input.is_action_pressed("ui_right"):
		steer_target = -STEER_LIMIT
	else:
		steer_target = 0
	
	if Input.is_action_pressed("ui_up"):
		engine_force = engine_force_value
	else:
		engine_force = 0
		
	if steer_target < steer_angle:
		steer_angle -= STEER_SPEED * delta
		if steer_target > steer_angle:
			steer_angle = steer_target
	elif steer_target > steer_angle:
		steer_angle += STEER_SPEED * delta
		if steer_target < steer_angle:
			steer_angle = steer_target
	
	steering = steer_angle
	
	##vv additions added to the draconicfae fork vv##
	if menu_initialized != true:
		initialize_menu()
		menu_initialized = true
	
	#ability to toggle the visibility of the vehicle
	if Input.is_action_just_pressed("ui_visibility"):
		visible = !visible

	#use ui_select for breaking instead of ui_down
	if Input.is_action_pressed("ui_select"):
		brake = 1
	else:
		brake = 0.0

	#ability to propel vehicle in reverse
	if Input.is_action_pressed("ui_down"):
		engine_force = -engine_force_value

	#antigravity functionality
	if Input.is_action_pressed("ui_jump"):
		gravity_scale = -1
	else:
		gravity_scale = 1

	#functionality to freeze the vehicle including in midair.
	#note that when you resume all momentum is gone so 
	#you'll fall straight down
	if Input.is_action_just_pressed("ui_freeze"):
		if mode == RigidBody.MODE_RIGID:
			mode = RigidBody.MODE_KINEMATIC
		else:
			mode = RigidBody.MODE_RIGID
		
	#increase the force in moving vehicle	
	if Input.is_action_just_pressed("ui_accelerate"):
		engine_force_value += 5
	
	#decrease the force in moving vehicle
	if Input.is_action_just_pressed("ui_decelerate"):
		engine_force_value -= 5
		
	menu_manager.menuing_poll()

    
	##^^ additions added to the draconicfae fork ^^##
