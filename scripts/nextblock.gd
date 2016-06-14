
extends RigidBody2D

var mode

func ran():
	var rand = randf()
	if rand < 0.5:
		mode = "red"
	else:
		mode = "yellow"


func _ready():
	ran()
	set_process(true)
	
func _process(delta):
		
	if get_parent().get_parent().actual_block == "null":
		self.set_axis_velocity(Vector2(0,-240))
	else: self.set_linear_velocity(Vector2(0,0))
	
	if mode == "red":
		get_node("Polygon2D").set_color(Color(1,0,0,1))
		get_node("Polygon2D 2").set_color(Color(1,0,0,1))
		get_node("Polygon2D3").set_color(Color(1,0,0,1))
		get_node("Polygon2D4").set_color(Color(1,0,0,1))
		get_node("Polygon2D5").set_color(Color(1,0,0,1))
	if mode == "yellow":
		get_node("Polygon2D").set_color(Color(1,1,0,1))
		get_node("Polygon2D 2").set_color(Color(1,1,0,1))
		get_node("Polygon2D3").set_color(Color(1,1,0,1))
		get_node("Polygon2D4").set_color(Color(1,1,0,1))
		get_node("Polygon2D5").set_color(Color(1,1,0,1))

