extends KinematicBody2D

var gravity = 20
var gravityMax = 500
var jumpPower =  -500
var dirChar = 1
var velocity = Vector2()
var state

var attackWaitingList = []
export(int) var speed =  200 


func _ready():
	pass # Replace with function body.


func inputKeyPressRespond():
	if Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_left"):
		velocity.x = 0
	elif Input.is_action_pressed("ui_right"):
		velocity.x = speed
		dirChar = 1
		state = "Move"
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -speed
		dirChar = -1
		state = "Move"
	else:
		velocity.x = 0
		

	if Input.is_action_pressed("ui_down"):
		if is_on_floor():
			state = "Duck"
			velocity.x = 0
	
	if Input.is_action_pressed("ui_up"):
		if is_on_floor():
			print("Jump")
			state = "Jump"
			velocity.y = jumpPower
			
	if Input.is_action_just_pressed("attack"):
		if Input.is_action_pressed("ui_right"):
			attackWaitingList.push_back( "-> Attack")
			pass
		elif Input.is_action_pressed("ui_left"):
			attackWaitingList.push_back( "<- Attack")
			pass
		else:
			attackWaitingList.push_back("Attack")
			pass
		
		get_parent().get_node("RichTextLabel").text = ""
		for attackName in attackWaitingList:
			get_parent().get_node("RichTextLabel").text += "\n" + attackName
	
	
func updateMovementChar():
	velocity.y += gravity
	if velocity.y > gravityMax: velocity.y = gravityMax
	velocity = move_and_slide(velocity , Vector2(0,-1))

func updateAnimation():
	if !is_on_floor():
		$AnimationTree.set("parameters/Jump/blend_position",Vector2(dirChar,-velocity.y))
		$AnimationTree.get("parameters/playback").travel("Jump")
	
	else:
		if velocity.x == 0:
			$AnimationTree.set("parameters/Idle/blend_position",Vector2(dirChar,0))
			$AnimationTree.get("parameters/playback").travel("Idle")
		else:
			$AnimationTree.set("parameters/Run/blend_position",Vector2(dirChar,0))
			$AnimationTree.get("parameters/playback").travel("Run")


func _physics_process(delta):
	inputKeyPressRespond()
	updateMovementChar()
	updateAnimation()
	
