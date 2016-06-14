
extends Camera2D
var resolution

func _ready():
	resolution  = get_viewport().get_rect().size
	set_process(true)

func _process(delta):
	resolution  = get_viewport().get_rect().size
	self.set_zoom(Vector2(480/resolution.x,1*(480/resolution.x)))
	print("xD")