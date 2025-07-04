extends Control

var master_bus : int
var sfx_bus : int
var music_bus : int 

var menu_is_open = false

func _ready() -> void:
	sfx_bus = AudioServer.get_bus_index("SFX")
	music_bus = AudioServer.get_bus_index("Music")

func _on_sound_effects_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx_bus,linear_to_db(value))
	
func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus,linear_to_db(value))
	



func _on_close_button_pressed() -> void:
	open_menu(false)
	
func _on_settings_button_pressed() -> void:
	if menu_is_open == true:
		open_menu(false)
	else:
		open_menu(true)
	
func open_menu(open : bool):
	$SettingsPanel.visible = open
	$DarkPanel.visible = open
	menu_is_open = open


func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
