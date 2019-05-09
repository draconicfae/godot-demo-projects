
extends Control

# Member variables
var town = null
var MenuManager = null
var MenuInitialized = false

func _back():
	town.queue_free()
	show()

func _load_scene(car):
	var tt = load(car).instance()
	tt.set_name("car")
	town = load("res://town_scene.tscn").instance()
	town.get_node("instance_pos").add_child(tt)
	town.get_node("back").connect("pressed", self, "_back")
	get_parent().add_child(town)
	hide()


func _on_van_1_pressed():
	_load_scene("res://car_base.tscn")


func _on_van_2_pressed():
	_load_scene("res://trailer_truck.tscn")


func _on_van_3_pressed():
	_load_scene("res://crane.tscn")

func set_firstcement():
	var res = load("res://Images/cement-one.png")
	var mat = load("res://Materials/cement.material")
	mat.albedo_texture = res

func set_secondcement():
	var res = load("res://Images/cement-two.png")
	var mat = load("res://Materials/cement.material")
	mat.albedo_texture = res

func set_firstgrass():
	var res = load("res://Images/grass-one.png")
	var mat = load("res://Materials/grass.material")
	mat.albedo_texture = res
	
func set_secondgrass():
	var res = load("res://Images/grass-two.png")
	var mat = load("res://Materials/grass.material")
	mat.albedo_texture = res

func get_menu_manager():
	return MenuManager
	
func initialize_menu():
	MenuManager = load("menu_manager.gd").new()
	MenuManager.add_submenu_autokeys("carswitching",self,"ui_carswitch",["_on_van_1_pressed","_on_van_2_pressed","_on_van_3_pressed"])
	
	#ideally it would be nice to have the cement SpatialMaterial
	#have its own management script but I tried that and it 
	#doesn't seem to have get_node() access, and therefore I'm 
	#not sure how I can provide the MenuManager to it.
	MenuManager.add_submenu_autokeys("cementswithing",self,"ui_cementswitch",["set_firstcement","set_secondcement"])
	
	#as with cement, would be nice to have grass SpatialMaterial
	#handle this
	MenuManager.add_submenu_autokeys("grasswitching",self,"ui_grasswitch",["set_firstgrass","set_secondgrass"])
	
func _physics_process(delta):
	#it would be more ideal to have this in _init(), 
	#but it seems that the node path doesn't exist
	#until after _init() and I don't of a standard 
	#function that runs immediately after _init()
	if MenuInitialized != true:
		initialize_menu()
		MenuInitialized = true
			
	MenuManager.menuing_poll()
