extends Area2D
signal hit
export var speed = 400 # A quina velocitat es mourà el jugador (píxels/seg).
var screen_size # Mida de la finestra de joc.



# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(delta):
	var velocity = Vector2.ZERO # Vector de moviment del jugador.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0

func _on_Player_body_entered(_body):
	hide() # El jugador desapareix després de ser impactat.
	emit_signal("hit")
	# S'ha d'ajornar, ja que no podem canviar les propietats físiques en una crida de retorn de física.
	$CollisionShape2D.set_deferred("disabled", true)
