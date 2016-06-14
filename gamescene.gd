
extends Control

var actual_object = null
var actual_block = "null"
var clickPos = Vector2(0,0)
var block_clicked
var allBlocks = 0.0
var actual = 0.0
var gameover = false
var next_blocks = []

func _ready():
	set_process_input(true)
	set_process(true)
	actual_block = "red-exp"
	next_blocks = ["red-exp",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null]

func _input(event):
	if (event.type == InputEvent.SCREEN_TOUCH):
		if event.is_pressed() && actual_block != null:
			clickPos = event.pos- Vector2(0,get_node("GameMechanics").get_pos().y)

			var x = int(clickPos.x-20)/64
			var y = int(clickPos.y-64)/64
			if x < 0 || x > 6:
				x = 20
			if y < 0 || y > 8:
				y = 20
			block_clicked = Vector2(x,y)
			if get_node("GameMechanics/Boxes").set_block(block_clicked,actual_block) == true:
				actual_block = next_blocks[0]
				for i in range(0,11):
					next_blocks[i] = next_blocks[i+1]
		
func _process(delta):
	if actual_block == "red-exp":
		get_node("HudDown/ShowBlocks/Block1").set_modulate(Color(1,0,0,1))
	else:
		get_node("HudDown/ShowBlocks/Block1").set_modulate(Color(0,0,0,0))
		
	if next_blocks[0] == "red-exp":
		get_node("HudDown/ShowBlocks/Block2").set_modulate(Color(1,0,0,1))
	else:
		get_node("HudDown/ShowBlocks/Block2").set_modulate(Color(0,0,0,0))
	
	if next_blocks[1] == "red-exp":
		get_node("HudDown/ShowBlocks/Block3").set_modulate(Color(1,0,0,1))
	else:
		get_node("HudDown/ShowBlocks/Block3").set_modulate(Color(0,0,0,0))
		
	if next_blocks[2] == "red-exp":
		get_node("HudDown/ShowBlocks/Block4").set_modulate(Color(1,0,0,1))
	else:
		get_node("HudDown/ShowBlocks/Block4").set_modulate(Color(0,0,0,0))
	
	if next_blocks[3] == "red-exp":
		get_node("HudDown/ShowBlocks/Block5").set_modulate(Color(1,0,0,1))
	else:
		get_node("HudDown/ShowBlocks/Block5").set_modulate(Color(0,0,0,0))
	
	if next_blocks[4] == "red-exp":
		get_node("HudDown/ShowBlocks/Block6").set_modulate(Color(1,0,0,1))
	else:
		get_node("HudDown/ShowBlocks/Block6").set_modulate(Color(0,0,0,0))
	
	#count how many blocks is on map
	actual = 0.0
	for x in range(0,7):
		for y in range(0,9):
			if get_node("GameMechanics/Boxes").map[y*7+x] != null:
				actual += 1.0
	if allBlocks < actual:
		allBlocks  = (allBlocks + actual)/2
	if allBlocks > actual:
		allBlocks  = (allBlocks + actual)/2
		
	get_node("Points/BlocksCountBar").set_scale(Vector2(allBlocks*8,1))
	get_node("Points").set_text(str(get_node("GameMechanics/Boxes").score))
	
	if gameover == true && get_node("GameOver/ScreenEffects").get_opacity() < 1:
		get_node("GameOver/ScreenEffects").set_opacity(get_node("GameOver/ScreenEffects").get_opacity()+0.02)
	elif get_node("GameOver/ScreenEffects").get_opacity() > 0:
		get_node("GameOver/ScreenEffects").set_opacity(get_node("GameOver/ScreenEffects").get_opacity()-0.02)
		
	if allBlocks >= 10:
		gameover = true
		get_node("GameMechanics/Boxes/Timer").stop()
		get_node("GameMechanics/Boxes/Init_Timer").stop()
		get_node("GameOver/ScreenEffects/TotalPoints").set_text("Score: " +str(get_node("GameMechanics/Boxes").score))
		

