extends Node

var submenus = {}
var autokeys = ['ui_one','ui_two','ui_three']
var current_submenu = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func menuing_poll():	
	#if there is on current active submenu, check to see if we should start one
	if current_submenu == null:
		for submenu in submenus:
			var currmenu = submenus[submenu]
			if Input.is_action_just_pressed(currmenu[0]):
				current_submenu = submenu
				return
	
	if current_submenu != null:
		#check to see if one of the submenu items has been activated and act on it if so
		var currmenu = submenus[current_submenu]
		for trigger in currmenu[1]:
			if Input.is_action_just_pressed(trigger[0]):
				current_submenu.call(trigger[1])
				current_submenu = null
				

func add_submenu_autokeys(source_script, ui_trigger, callbacks):
	var keyed_entries = []
	
	for i in range(0,len(callbacks)):
		keyed_entries.append([autokeys[i],callbacks[i]])
	submenus[source_script] = [ui_trigger, keyed_entries]