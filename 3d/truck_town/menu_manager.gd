extends Node

var submenus = {}
var autokeys = ['ui_one','ui_two','ui_three','ui_four']
var current_submenu = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func menuing_poll():	
	#if there is on current active submenu, check to see if we should start one
	if current_submenu == null:
		for submenu in submenus:
			var currmenu = submenus[submenu]
			if Input.is_action_just_pressed(currmenu[1]):
				current_submenu = submenu
				return
	
	if current_submenu != null:
		#check to see if one of the submenu items has been activated and act on it if so
		var currmenu = submenus[current_submenu]
		for trigger in currmenu[2]:
			if Input.is_action_just_pressed(trigger[0]):
				currmenu[0].call(trigger[1])
				current_submenu = null
				

func add_submenu_autokeys(source_key, source_class, ui_trigger, callbacks):
	var keyed_entries = []
	
	#this is a quick hack that breaks the generic modularity of menu_manager
	#I'll fix it later...
	if source_key == 'testermenu' and submenus.has('testermenu'):
		submenus[source_key][0].call('disable_controls_unless_synchronous')
		
	for i in range(0,len(callbacks)):
		keyed_entries.append([autokeys[i],callbacks[i]])
	submenus[source_key] = [source_class,ui_trigger, keyed_entries]