
extends Node2D

var speed
var distance_left

func _ready():
	set_process(true)

func _process(delta):
		self.set_pos(self.get_pos()+Vector2(0,speed))
		distance_left -= speed
	
