
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

func get_menu_manager():
	return MenuManager
	
func initialize_menu():
	MenuManager = load("menu_manager.gd").new()
	MenuManager.add_submenu_autokeys(self,"ui_carswitch",["_on_van_1_pressed","_on_van_2_pressed","_on_van_3_pressed"])
	
func _physics_process(delta):
	#it would be more ideal to have this in _init(), 
	#but it seems that the node path doesn't exist
	#until after _init() and I don't of a standard 
	#function that runs immediately after _init()
	if MenuInitialized != true:
		initialize_menu()
		MenuInitialized = true
			
	MenuManager.menuing_poll()
