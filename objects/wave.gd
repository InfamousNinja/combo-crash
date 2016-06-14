
extends Node2D

var direction = ""
var color = ""
var distance_left = 0
func _ready():
	set_process(true)
	self.set_z(-10)
	
func _process(delta):
	if distance_left > 0:
		if direction == "up":
			self.set_pos(self.get_pos()+Vector2(0,-8))
			distance_left -= 8
		if direction == "down":
			self.set_pos(self.get_pos()+Vector2(0,8))
			self.set_rot(deg2rad(180))
			distance_left -= 8
		if direction == "left":
			self.set_pos(self.get_pos()+Vector2(-8,0))
			distance_left -= 8
			self.set_rot(deg2rad(90))
		if direction == "right":
			self.set_pos(self.get_pos()+Vector2(8,0))
			distance_left -= 8
			self.set_rot(deg2rad(270))
	if distance_left <= 0 && direction != "":
		self.set_hidden(true)
		
	if color == "red":
		get_node("Sprite").set_modulate(Color(1,0,0,1))
		


