extends RigidBody2D

@export var puzzle: Container
@onready var panel_gui: Control = %PanelGUI
@onready var label: Label = %Player/Label
@onready var player: CharacterBody2D = %Player
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collisider: CollisionShape2D = $CollisionShape2D
@onready var detection_zone: Area2D = $DetectionZone

var playerInDetectionZone = false
var failed = false

func _on_detection_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group('Player') and not failed:
		label.visible = true
		playerInDetectionZone = true

func _on_detection_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group('Player') and not failed:
		label.visible = false
		if is_instance_valid(puzzle):
			puzzle.visible = false
		playerInDetectionZone = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("OpenPanel") and playerInDetectionZone and not failed:
		if panel_gui.isOpen:
			panel_gui.close()
		else:
			panel_gui.open()
			puzzle.visible = true

func _on_game_manager_success() -> void:
	label.visible = false
	panel_gui.close()
	puzzle.queue_free()
	animated_sprite.play('fall')
	
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = 0.2
	add_child(timer)
	timer.start()
	await timer.timeout
	
	collisider.queue_free()
	detection_zone.queue_free()

func _on_game_manager_fail() -> void:
	label.visible = false
	panel_gui.close()
	puzzle.queue_free()
	detection_zone.queue_free()
	failed = true
