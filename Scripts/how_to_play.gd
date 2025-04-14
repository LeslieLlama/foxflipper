extends Control

@export var pages = [] 

var current_page = 0
func _ready() -> void:
	for p in $Pages.get_child_count():
		pages.append($Pages.get_child(p))
	_flip_page(current_page)

func _on_next_menu_button_button_up() -> void:
	if current_page >= pages.size()-1:
		return;
	current_page += 1
	_flip_page(current_page)
	
func _on_prev_menu_button_button_up() -> void:
	if current_page <= 0:
		return
	current_page -= 1
	_flip_page(current_page)

func _flip_page(current_page):
	for p in pages:
		p.visible = false;
	pages[current_page].visible = true
	$MenuUI/PageCountLabel.text = str("Page\n",current_page+1,"/5")
	if current_page <= 0:
		$MenuUI/PrevMenuButton.disabled = true
	else: 
		$MenuUI/PrevMenuButton.disabled = false
	if current_page >= pages.size()-1:
		$MenuUI/NextMenuButton.disabled = true
	else: 
		$MenuUI/NextMenuButton.disabled = false
