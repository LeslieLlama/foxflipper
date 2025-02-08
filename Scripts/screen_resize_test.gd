extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().get_root().size_changed.connect(resize)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		
func resize():
	var size = get_viewport_rect().size
	if size.x > size.y:
		$LayoutBox.vertical = false
	else: 
		$LayoutBox.vertical = true
