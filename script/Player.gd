extends KinematicBody2D

var gravity = 20
var gravityMax = 500
var jumpPower =  -500
var dirChar = 1
var dirCharHorizontal = 0
var velocity = Vector2()
var state

var attackSquanceMax = 3 
var attackSquanceNow = 0

var inAttackAnimationState = 0
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
		$Sprite.set_scale(Vector2(-1, 1))
	else:
		state = "Idle"
		velocity.x = 0

	
	if Input.is_action_pressed("ui_down"):
		if is_on_floor():
			state = "Duck"
			velocity.x = 0
	
	if Input.is_action_pressed("ui_up"):
		if is_on_floor():
			state = "Jump"
			velocity.y = jumpPower
			
	if (Input.is_action_just_pressed("attack") \
	and attackSquanceNow < attackSquanceMax ):
		attackSquanceNow = attackSquanceNow + 1
		
		if is_on_floor() == true: 	state = "Attack"
		if is_on_floor() == false: 	state = "AttackAir"
		
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
	
	if $AnimationTree.get("parameters/trans_onAttack/current") == 1 and is_on_floor():
		velocity.x = 0
	
	velocity = move_and_slide(velocity , Vector2(0,-1))

func updateAnimation():
	
	if dirChar == 1: 	$Sprite.set_scale(Vector2(1, 1))
		
	if dirChar == -1:	$Sprite.set_scale(Vector2(-1, 1))
	
	if is_on_floor() == false:
		if inAttackAnimationState == 0 :
			if state == "AttackAir":
				$AnimationTree.set("parameters/trans_onAttack/current",1)
				$AnimationTree.set("parameters/trans_attackMode/current",3)
			else:	
				$AnimationTree.set("parameters/trans_onAir/current",1)
				if velocity.y >0:
					$AnimationTree.set("parameters/trans_airPost/current",1)
				else:
					$AnimationTree.set("parameters/trans_airPost/current",0)
		
		elif inAttackAnimationState == 1:
			pass
		
		
		
	
	elif is_on_floor() == true:
		$AnimationTree.set("parameters/trans_onAir/current",0)
		if state == "Attack":
			$AnimationTree.set("parameters/trans_onAttack/current",1)
			$AnimationTree.set("parameters/trans_attackMode/current",0)
		elif velocity.x == 0:
			
			$AnimationTree.set("parameters/trans_moveState/current",0)
		else:
			
			$AnimationTree.set("parameters/trans_moveState/current",1)

func normalizeVariable():
	inAttackAnimationState = $AnimationTree.get("parameters/trans_onAttack/current")
	if inAttackAnimationState == 0: resetAttackState()
		
func _physics_process(delta):
	inputKeyPressRespond()
	updateMovementChar()
	updateAnimation()
	normalizeVariable()
	
func resetAttackState():
	$AnimationTree.set("parameters/trans_onAttack/current",0)
	attackSquanceNow = 0
	attackWaitingList.clear()

func onAttackFinished():
	var tmpNoAttackNow = $AnimationTree.get("parameters/trans_attackMode/current")
	print(tmpNoAttackNow)
	
	attackWaitingList.pop_front()
	state = "Idle"
	if len(attackWaitingList) == 0: 
		resetAttackState()
	else:
		
		
		if tmpNoAttackNow < 2:
			$AnimationTree.set("parameters/trans_attackMode/current",tmpNoAttackNow + 1)
		else:
			resetAttackState()

