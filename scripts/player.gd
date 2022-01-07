extends Area2D
const MOVE_SPEED = 150.0
const SCREEN_WIDTH = 320
const SCREEN_HEIGHT = 180


# Declare member variables here. Examples:
var shot_scene = preload("res://scenes/shot.tscn")
var explosion_scene = preload("res://scenes/explosion.tscn")

var can_shoot = true
var dead = false

signal destroyed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input_dir = Vector2()
	if Input.is_key_pressed(KEY_UP):
		input_dir.y -= 1.0
	if Input.is_key_pressed(KEY_DOWN):
		input_dir.y += 1.0
	if Input.is_key_pressed(KEY_LEFT):
		input_dir.x -= 1.0
	if Input.is_key_pressed(KEY_RIGHT):
		input_dir.x += 1.0

	position += (delta * MOVE_SPEED) * input_dir
	
	if position.x < 0.0:
		position.x = 0.0
	elif position.x > SCREEN_WIDTH:
		position.x = SCREEN_WIDTH
	if position.y < 0.0:
		position.y = 0.0
	elif position.y > SCREEN_HEIGHT:
		position.y = SCREEN_HEIGHT

	if Input.is_key_pressed(KEY_SPACE) and can_shoot:
		var stage_node = get_parent()

		var shot_instance1 = shot_scene.instance()
		shot_instance1.position = position + Vector2(9,-5)
		stage_node.add_child(shot_instance1)
		
		var shot_instance2 = shot_scene.instance()
		shot_instance2.position = position + Vector2(9,5)
		stage_node.add_child(shot_instance2)
		
		can_shoot = false
		get_node("reload_timer").start()


func _on_reload_timer_timeout():
	can_shoot = true


func _on_player_area_entered(area):
	if area.is_in_group("asteroid"):
		queue_free()

		var stage_node = get_parent()
		var explosion_instance = explosion_scene.instance()
		explosion_instance.position = position
		stage_node.add_child(explosion_instance)

		dead = true
		emit_signal("destroyed")
