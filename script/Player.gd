extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var dirChar = 1
export(int) var speed =  200

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1.0
		dirChar = 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1.0
		dirChar = -1
	
	if velocity.x == 0:
		$AnimationTree.set("parameters/Idle/blend_position",Vector2(dirChar,0))
		$AnimationTree.get("parameters/playback").travel("Idle")
	else:
		$AnimationTree.set("parameters/Run/blend_position",Vector2(dirChar,0))
		$AnimationTree.get("parameters/playback").travel("Run")
#	velocity = velocity.normalized()
	move_and_slide(velocity * speed)
	pass
