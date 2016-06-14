
extends Node2D

var color = ""
var timeleft
var speed

func _ready():
	timeleft = 0.2
	speed = 70
	set_process(true)
	
func _process(delta):
	timeleft -= delta
	if timeleft <= 0:
		timeleft = -10
		self.set_opacity(self.get_opacity()-delta*5)
	else:
		self.set_scale(self.get_scale() + Vector2(delta*speed,delta*speed))
		speed /= 2
	if speed <= 0:
		speed = 0


