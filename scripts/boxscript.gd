
extends Node2D


var map = []
var map_down = []
var map_down2 = []
var points = []

var init_time

var texture_exploder
var texture_init
var texture_points
var texture_exploder_on

var texture_left
var texture_right
var texture_up
var texture_down

var font_points
var font_init

var score = 0

var init_vector
var explodes_array = []
var waves_array = []
var explode_time = []
var lines_alpha

var wave = 0


var wave_object = preload("res://objects/wave.xml")
var explosion_object = preload("res://objects/explosion.xml")

func set_block(position,actual_block):
	print(position.y*7+position.x)
	if position.x != 20 && position.y != 20:
		if map[position.y*7+position.x] == null:
			map[position.y*7+position.x] = actual_block
			update()
			return true
	return false

func _ready():
	lines_alpha = 1
	map.resize(63)
	map_down.resize(63)
	map_down2.resize(63)
	points.resize(63)
	explode_time.resize(63)
	
	init_vector = Vector2(0,0)

	texture_exploder = load("res://exploder.png")
	texture_init = load("res://initiator.png")
	texture_points = load("res://points.png")
	texture_exploder_on = load("res://exploder-on.png")
	
	texture_left = load("res://left.png")
	texture_right = load("res://right.png")
	texture_up = load("res://up.png")
	texture_down = load("res://down.png")
	
	font_points = load("res://fonts/font2.fnt")
	font_init = load("res://fonts/font3.fnt")
	init_time = 9
	
	for x in range(0,7):
		for y in range(0,9):
			explode_time[y*7+x] = -10
	set_process(true)
	generate()
	
func explode(pos):
	var x = pos.x
	var y = pos.y
	
	if x > 0:
		if map[y*7+x-1] == "red-points":
			map[y*7+x-1] = null
			score += points[y*7+x-1]
			points[y*7+x-1] = 0
		if y > 0:
			if map[(y-1)*7+x-1] == "red-points":
				map[(y-1)*7+x-1] = null
				score += points[(y-1)*7+x-1]
				points[(y-1)*7+x-1] = 0
		if y < 8:
			if map[(y+1)*7+x-1] == "red-points":
				map[(y+1)*7+x-1] = null
				score += points[(y+1)*7+x-1]
				points[(y+1)*7+x-1] = 0
	if x < 6:
		if map[y*7+x+1] == "red-points":
			map[y*7+x+1] = null
			score += points[y*7+x+1]
			points[y*7+x+1] = 0	
		if y > 0:
			if map[(y-1)*7+x+1] == "red-points":
				map[(y-1)*7+x+1] = null
				score += points[(y-1)*7+x+1]
				points[(y-1)*7+x+1] = 0
		if y < 8:
			if map[(y+1)*7+x+1] == "red-points":
				map[(y+1)*7+x+1] = null
				score += points[(y+1)*7+x+1]
				points[(y+1)*7+x+1] = 0
	if y > 0:
		if map[(y-1)*7+x] == "red-points":
			map[(y-1)*7+x] = null
			score += points[(y-1)*7+x]
			points[(y-1)*7+x] = 0	
	if y < 8:
		if map[(y+1)*7+x] == "red-points":
			map[(y+1)*7+x] = null
			score += points[(y+1)*7+x]
			points[(y+1)*7+x] = 0	
	
func _draw():
	for x in range(0,7):
		for y in range(0,9):
			if explode_time[y*7+x] > 0:
				explode_time[y*7+x] -= 3.5
			if explode_time[y*7+x] <= 0 && explode_time[y*7+x] >= -9:
				explode_time[y*7+x] = -10
				map[y*7+x] = null
				spawn_waves(Vector2(x,y))
				spawn_explosion(Vector2(x,y))
				
				explode(Vector2(x,y))
				
			if map_down[y*7+x] == "red-right":
				self.draw_texture(texture_right,Vector2(x*64,60+y*64),Color(0.6,0,0,lines_alpha))
			elif map_down[y*7+x] == "red-down":
				self.draw_texture(texture_down,Vector2(x*64,60+y*64),Color(0.6,0,0,lines_alpha))
			
			if map_down2[y*7+x] == "red-right":
				self.draw_texture(texture_right,Vector2(x*64,60+y*64),Color(0.6,0,0,lines_alpha))
			elif map_down2[y*7+x] == "red-down":
				self.draw_texture(texture_down,Vector2(x*64,60+y*64),Color(0.6,0,0,lines_alpha))
			

			if map[y*7+x] == "red-exp":
				self.draw_texture(texture_exploder,Vector2(x*64,60+y*64),Color(1,0,0,1))    
			elif map[y*7+x] == "red-exp-on":
				self.draw_texture(texture_exploder_on,Vector2(x*64,60+y*64),Color(1,0,0,1))                      
			elif map[y*7+x] == "yellow-exp":
				self.draw_texture(texture_exploder,Vector2(x*64,60+y*64),Color(1,1,0,1))             
			elif map[y*7+x] == "red-init":
				init_vector = Vector2(x,y)
				if init_time == 0:
					map[y*7+x] = null
				else:
					self.draw_texture(texture_init,Vector2(x*64,60+y*64),Color(1,1,1,1))         
					self.draw_string(font_init,Vector2(x*64+32-str(init_time).length()*5,99+y*64),str(init_time),Color(1,1,1,1))    
			elif map[y*7+x] == "red-points":
				self.draw_texture(texture_points,Vector2(x*64,60+y*64),Color(1,0,0,1))  
				self.draw_string(font_points,Vector2(x*64+32-str(points[y*7+x]).length()*4,98+y*64),str(points[y*7+x]),Color(1,0,0,1))    
			elif map[y*7+x] == "yellow-points":
				self.draw_texture(texture_points,Vector2(x*64,60+y*64),Color(1,1,0,1))   
				          
			
			
	
	check()
	
func _process(delta):
	update()
	if init_time < 2:
		lines_alpha -= delta*2
	else:
		lines_alpha += delta*2
	if lines_alpha >= 1:
		lines_alpha = 1
	if lines_alpha <= 0:
		lines_alpha = 0
	
func check():
	for x in range(0,7):
		for y in range(0,9):
			if map[y*7+x] == "red-exp":
				
				var left = false
				var right = false
				var up = false
				var down = false
				
				if x < 6 && right == false:
					if map[y*7+x+1] == "red-init" || map[y*7+x+1] == "red-exp-on" :					
						map[y*7+x] = "red-exp-on"
						right = true
				if x > 0 && left == false:
					if map[y*7+x-1] == "red-init" || map[y*7+x-1] == "red-exp-on" :
						map[y*7+x] = "red-exp-on"
						left = true
				if y < 8 && down == false:		
					if map[(y+1)*7+x] == "red-init" || map[(y+1)*7+x] == "red-exp-on" :
						map[y*7+x] = "red-exp-on"
						down = true		
				if y > 0 && up == false:		
					if map[(y-1)*7+x] == "red-init" || map[(y-1)*7+x] == "red-exp-on" :
						map[y*7+x] = "red-exp-on"
						up = true
						
				
				if x < 5 && right == false:
					if map[y*7+x+2] == "red-init" || map[y*7+x+2] == "red-exp-on" :
						map[y*7+x] = "red-exp-on"
						if map_down[y*7+x+1] != null:
							map_down2[y*7+x+1] = "red-right"
						else: map_down[y*7+x+1] = "red-right"
						right = true
				if x > 1 && left == false:
					if map[y*7+x-2] == "red-init" || map[y*7+x-2] == "red-exp-on" :
						map[y*7+x] = "red-exp-on"
						if map_down[y*7+x-1] != null:
							map_down2[y*7+x-1] = "red-right"
						else: map_down[y*7+x-1] = "red-right"
						right = true
				if y < 7 && down == false:		
					if map[(y+2)*7+x] == "red-init" || map[(y+2)*7+x] == "red-exp-on" :
						map[y*7+x] = "red-exp-on"
						if map[y*7+x] != null:
							map_down2[(y+1)*7+x] = "red-down"
						else: map_down[(y+1)*7+x] = "red-down"
						down = true
				if y > 1 && up == false:		
					if map[(y-2)*7+x] == "red-init" || map[(y-2)*7+x] == "red-exp-on" :
						map[y*7+x] = "red-exp-on"
						if map[y*7+x] != null:
							map_down2[(y-1)*7+x] = "red-down"
						else: map_down[(y-1)*7+x] = "red-down"
						up = true
						
						
				if x < 4 && right == false:
					if map[y*7+x+3] == "red-init" || map[y*7+x+3] == "red-exp-on" :
						map[y*7+x] = "red-exp-on"
						if map_down[y*7+x+1] != null:
							map_down2[y*7+x+1] = "red-right"
						else: map_down[y*7+x+1] = "red-right"
						if map_down[y*7+x+2] != null:
							map_down2[y*7+x+2] = "red-right"
						else: map_down[y*7+x+2] = "red-right"
						right = true
				if x > 2 && left == false:
					if map[y*7+x-3] == "red-init" || map[y*7+x-3] == "red-exp-on" :
						map[y*7+x] = "red-exp-on"
						if map_down[y*7+x-1] != null:
							map_down2[y*7+x-1] = "red-right"
						else: map_down[y*7+x-1] = "red-right"
						if map_down[y*7+x-2] != null:
							map_down2[y*7+x-2] = "red-right"
						else: map_down[y*7+x-2] = "red-right"
						left = true
				if y < 6 && down == false:		
					if map[(y+3)*7+x] == "red-init" || map[(y+3)*7+x] == "red-exp-on" :
						map[y*7+x] = "red-exp-on"
						if map[y*7+x] != null:
							map_down2[(y+1)*7+x] = "red-down"
						else: map_down[(y+1)*7+x] = "red-down"
						if map[y*7+x] != null:
							map_down2[(y+2)*7+x] = "red-down"
						else: map_down[(y+2)*7+x] = "red-down"
						down = true
				if y > 2 && up == false:		
					if map[(y-3)*7+x] == "red-init" || map[(y-3)*7+x] == "red-exp-on" :
						map[y*7+x] = "red-exp-on"
						if map[y*7+x] != null:
							map_down2[(y-1)*7+x] = "red-down"
						else: map_down[(y-1)*7+x] = "red-down"
						if map[y*7+x] != null:
							map_down2[(y-2)*7+x] = "red-down"
						else: map_down[(y-2)*7+x] = "red-down"
						up = true
	update()
	
func spawn_explosion(pos):
	var x = pos.x
	var y = pos.y
	
	var explode = explosion_object.instance()
	explode.set_pos(Vector2(x*64+32,60+y*64+32))
	explode.timeleft = 0.2
	explode.color = "red"
	add_child(explode)
	explodes_array.push_back(explode)
	
func spawn_waves(pos):
	var x = pos.x
	var y = pos.y
	
	get_node("Timer").start()
	if x < 6:
		if map[y*7+x+1] == "red-exp-on" :
			print("wybucha",x+1,y)
			explode_time[y*7+x+1] = 64
			get_node("Timer").stop()
	if x > 0:
		if map[y*7+x-1] == "red-exp-on" :
			print("wybucha",x-1,y)
			explode_time[y*7+x-1] = 64
			get_node("Timer").stop()
	if y < 8:		
		if map[(y+1)*7+x] == "red-exp-on" :
			print("wybucha",x,y+1)
			explode_time[(y+1)*7+x] = 64
			get_node("Timer").stop()
	if y > 0:		
		if map[(y-1)*7+x] == "red-exp-on" :
			print("wybucha",x,y-1)
			explode_time[(y-1)*7+x] = 64
			get_node("Timer").stop()
	if x < 5:
		if map[y*7+x+2] == "red-exp-on" :
			print("wybucha",x+2,y)
			explode_time[y*7+x+2] = 128
			
			var wave = wave_object.instance()
			wave.set_pos(Vector2(x*64+32,60+y*64+32))
			wave.distance_left = 128
			wave.direction = "right"
			wave.color = "red"
			add_child(wave)
			waves_array.push_back(wave)
			get_node("Timer").stop()
	if x > 1:
		if map[y*7+x-2] == "red-exp-on" :
			print("wybucha",x-2,y)
			explode_time[y*7+x-2] = 128
			
			var wave = wave_object.instance()
			wave.set_pos(Vector2(x*64+32,60+y*64+32))
			wave.distance_left = 128
			wave.direction = "left"
			wave.color = "red"
			add_child(wave)
			waves_array.push_back(wave)
			get_node("Timer").stop()
	if y < 7:		
		if map[(y+2)*7+x] == "red-exp-on" :
			print("wybucha",x,y+1)
			explode_time[(y+2)*7+x] = 128

			var wave = wave_object.instance()
			wave.set_pos(Vector2(x*64+32,60+y*64+32))
			wave.distance_left = 128
			wave.direction = "down"
			wave.color = "red"
			add_child(wave)
			waves_array.push_back(wave)
			get_node("Timer").stop()
	if y > 1:		
		if map[(y-2)*7+x] == "red-exp-on" :
			print("wybucha",x,y-2)
			explode_time[(y-2)*7+x] = 128

			var wave = wave_object.instance()
			wave.set_pos(Vector2(x*64+32,60+y*64+32))
			wave.distance_left = 128
			wave.direction = "up"
			wave.color = "red"
			add_child(wave)
			waves_array.push_back(wave)	
			get_node("Timer").stop()
			
			
			
	if x < 4:
		if map[y*7+x+3] == "red-exp-on" :
			print("wybucha",x+3,y)
			explode_time[y*7+x+3] = 192
			
			var wave = wave_object.instance()
			wave.set_pos(Vector2(x*64+32,60+y*64+32))
			wave.distance_left = 192
			wave.direction = "right"
			wave.color = "red"
			add_child(wave)
			waves_array.push_back(wave)
			get_node("Timer").stop()
	if x > 2:
		if map[y*7+x-3] == "red-exp-on" :
			print("wybucha",x-3,y)
			explode_time[y*7+x-3] = 192
			
			var wave = wave_object.instance()
			wave.set_pos(Vector2(x*64+32,60+y*64+32))
			wave.distance_left = 192
			wave.direction = "left"
			wave.color = "red"
			add_child(wave)
			waves_array.push_back(wave)
			get_node("Timer").stop()
	if y < 6:		
		if map[(y+3)*7+x] == "red-exp-on" :
			print("wybucha",x,y+3)
			explode_time[(y+3)*7+x] = 192

			var wave = wave_object.instance()
			wave.set_pos(Vector2(x*64+32,60+y*64+32))
			wave.distance_left = 192
			wave.direction = "down"
			wave.color = "red"
			add_child(wave)
			waves_array.push_back(wave)
			get_node("Timer").stop()
	if y > 2:		
		if map[(y-3)*7+x] == "red-exp-on" :
			print("wybucha",x,y-3)
			explode_time[(y-3)*7+x] = 192

			var wave = wave_object.instance()
			wave.set_pos(Vector2(x*64+32,60+y*64+32))
			wave.distance_left = 192
			wave.direction = "up"
			wave.color = "red"
			add_child(wave)
			waves_array.push_back(wave)	
			get_node("Timer").stop()

func _on_Timer_timeout():
	generate()
	init_time = 9+wave/4
	
	
	
func generate():
	
	get_node("Timer").stop()
	wave += 1
	
	var init_spawned = false
	var trys = 63
	var spawns_left = 3 + wave%4
	
	for e in explodes_array:
		self.remove_child(e)
	explodes_array.clear()
	for w in waves_array:
		self.remove_child(w)
	waves_array.clear()
			
	map_down.clear()
	map_down.resize(63)
	map_down2.clear()
	map_down2.resize(63)
	
	get_parent().get_parent().next_blocks.resize(12)
	var klocki = 2+wave/6
	if klocki > 12:
		klocki = 12
	
	for i in range(0,klocki):
		randomize()
		var r = randi()%2
		if r == 1:
			get_parent().get_parent().next_blocks[i] = "red-exp"
		else:
			get_parent().get_parent().next_blocks[i] = "red-exp"
			
	get_parent().get_parent().actual_block = "red-exp"
	randomize()
	
	while init_spawned == false:
		var randomx = randi()%7
		var randomy = randi()%9
		if map[randomy*7+randomx] == null:
			map[randomy*7+randomx] = "red-init"
			init_spawned = true
	while(spawns_left > 0 && trys > 0):	
		for i in range(0,4):
			randomize()
			trys -= 1
			var randomx = randi()%7
			var randomy = randi()%9
			if map[randomy*7+randomx] == null:
				map[randomy*7+randomx] = "red-points"
				
				var r = randi()%2
			
				points[randomy*7+randomx] = 100
				if wave > 3:
					if r == 1:
						points[randomy*7+randomx] = 100
					else:
						points[randomy*7+randomx] = 200
				if wave > 6:
					if r == 1:
						points[randomy*7+randomx] = 200
					else:
						points[randomy*7+randomx] = 500
				if wave > 9:
					if r == 1:
						points[randomy*7+randomx] = 500
					else:
						points[randomy*7+randomx] = 750
				if wave > 12:
					if r == 1:
						points[randomy*7+randomx] = 750
					else:
						points[randomy*7+randomx] = 1000
				if wave > 15:
					if r == 1:
						points[randomy*7+randomx] = 1000
					else:
						points[randomy*7+randomx] = 1500
				if wave > 20:
					if r == 1:
						points[randomy*7+randomx] = 1500
					else:
						points[randomy*7+randomx] = 2000
				if wave > 30:
					if r == 1:
						points[randomy*7+randomx] = 2000
					else:
						points[randomy*7+randomx] = 3000
				spawns_left -= 1
				
				
	check()

				

func _on_Init_Timer_timeout():
	init_time -= 1
	
	if init_time == 0:
		spawn_waves(init_vector)
	if init_time == 32:
		var wave = wave_object.instance()
		wave.set_pos(Vector2(init_vector.x*64+32,60+init_vector.y*64+32))
		wave.distance_left = 64
		wave.direction = "up"
		var wave1 = wave_object.instance()
		wave1.set_pos(Vector2(init_vector.x*64+32,60+init_vector.y*64+32))
		wave1.distance_left = 128
		wave1.direction = "down"
		var wave2 = wave_object.instance()
		wave2.set_pos(Vector2(init_vector.x*64+32,60+init_vector.y*64+32))
		wave2.distance_left = 256
		wave2.direction = "right"
		var wave3 = wave_object.instance()
		wave3.set_pos(Vector2(init_vector.x*64+32,60+init_vector.y*64+32))
		wave3.distance_left = 64
		wave3.direction = "left"	
		
		add_child(wave)
		add_child(wave1)
		add_child(wave2)
		add_child(wave3)
		
		waves_array.push_back(wave)
		waves_array.push_back(wave1)
		waves_array.push_back(wave2)
		waves_array.push_back(wave3)