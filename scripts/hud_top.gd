
extends Label



func _ready():
	set_process(true)
	
func _process(delta):
	var resolution = get_parent().get_parent().get_node("Camera2D").get_viewport().get_rect().size
	self.set_pos(Vector2(0,(720-resolution.y)/get_parent().get_parent().get_node("Camera2D").get_zoom().y))
