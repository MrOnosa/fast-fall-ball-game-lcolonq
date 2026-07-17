extends Node3D

@export var BallPackedScene : PackedScene
@export var BallSpawnVariance := 0.0 # Decided this was too much
@export var ball_drop_debouncing_period = 0.1

@onready var ball_spawn_marker_3d: Marker3D = %BallSpawnMarker3D
@onready var game_over_let_the_dust_settle_timer: Timer = $GameOverLetTheDustSettleTimer
@onready var reset_game_button: Button = $ResetGameButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var balls_remaining_label: Label = %BallsRemainingLabel
@onready var score_label: Label = %ScoreLabel
@onready var victory_label: Label = %VictoryLabel
@onready var defeat_label: Label = %DefeatLabel
@onready var progress_button: ProgressButton = $ProgressButton

signal on_ball_released

var time_left_until_another_ball_can_drop = 0.0
var ball_triggered := false
var balls_left := 20
var buckets_with_a_ball : Array = [0,0,0,0,0]

var started = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	JavaScriptBridge.eval("window.parent.postMessage({op: \"ready\"});")
	started = false # If we're in a debug build, just play the game. Otherwise wait for the signal.
	animation_player.speed_scale = 1 # Difficulty is used to change this value
	victory_label.hide()
	defeat_label.hide()
	reset_game_button.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var difficulty = JavaScriptBridge.eval("window.lcolonqJamStart || -1.0") # from l:q harness
	
	if !started && ((difficulty != null && difficulty > 0.0) || OS.is_debug_build()):
		if OS.is_debug_build() && (difficulty == null || difficulty <= 0.0):
			difficulty = 6
		# We got the signal that the game has started.
		started = true
		change_difficulty(difficulty)
		JavaScriptBridge.eval("window.parent.postMessage({op: \"started\", verb: \"drop!\"});")
		progress_button.is_running = true
	
	if started:
		if time_left_until_another_ball_can_drop > 0:
			time_left_until_another_ball_can_drop -= delta
			
		if Input.is_action_just_pressed("mouse_click"):
			ball_triggered = true
		
		if ball_triggered && time_left_until_another_ball_can_drop <= 0 && balls_left > 0:
			# Reset click debouncing
			ball_triggered = false
			time_left_until_another_ball_can_drop = ball_drop_debouncing_period		
			
			var new_ball = BallPackedScene.instantiate() as Ball
			new_ball.global_position = ball_spawn_marker_3d.global_position + Vector3(randf_range(-1.0 * BallSpawnVariance, BallSpawnVariance),randf_range(-1.0 * BallSpawnVariance, BallSpawnVariance),randf_range(-1.0 * BallSpawnVariance, BallSpawnVariance))
			add_child(new_ball)
			
			balls_left -= 1
			on_ball_released.emit(balls_left)
			if balls_left <= 0:
				# Let the balls settle for a moment
				game_over_let_the_dust_settle_timer.start() # calls conclude_game

## Pressing number steps up difficulty during debug builds
func _input(event):
	if OS.is_debug_build() && event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_1:
				change_difficulty(1)
			KEY_2:
				change_difficulty(3)
			KEY_3:
				change_difficulty(6)
			KEY_4:
				change_difficulty(11)
			KEY_5:
				change_difficulty(19)
			KEY_6:
				change_difficulty(89)
			KEY_7:
				change_difficulty(99)


func change_difficulty(difficulty) -> void:
	if difficulty > 0:
		if difficulty < 2:
			animation_player.speed_scale = 1
			balls_left = 20
		elif difficulty < 4:
			animation_player.speed_scale = 2
			balls_left = 15
		elif difficulty < 7:
			# Fun
			animation_player.speed_scale = 3
			balls_left = 10
		elif difficulty < 12:
			# spicy
			animation_player.speed_scale = 4
			balls_left = 7
		elif difficulty < 20:
			# almost too hard
			animation_player.speed_scale = 4.5
			balls_left = 7
		elif difficulty < 90:
			# just possible
			animation_player.speed_scale = 5
			balls_left = 7
		else:
			# I've done it
			animation_player.speed_scale = 5.5
			balls_left = 5
		
		balls_remaining_label.update_label(balls_left)

## Count the number of balls, and display win or lose and a reset button for now
func conclude_game():
	progress_button.is_running = false
	if OS.is_debug_build():
		reset_game_button.disabled = false
		reset_game_button.show()
	
	if buckets_with_a_ball.all(func(b): return b > 0):
		JavaScriptBridge.eval("window.parent.postMessage({op: \"done\", win: true});")
		victory_label.show()
	else:
		JavaScriptBridge.eval("window.parent.postMessage({op: \"done\", win: false});")
		var empty_buckets = _count_empty_buckets()
		if empty_buckets > 1:
			defeat_label.text = "Failed - %s Empty Buckets" % empty_buckets
		else:
			defeat_label.text = "Failed - 1 Empty Bucket"
		defeat_label.show()

func _on_reset_game_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_buckets_update_score(_buckets_with_a_ball) -> void:
	buckets_with_a_ball = _buckets_with_a_ball
	var filled_buckets = _count_filled_buckets()
	score_label.text = "Score: %s / %s" % [filled_buckets, buckets_with_a_ball.size()]
	if filled_buckets == buckets_with_a_ball.size():
		score_label.modulate = Color.html("00ff2e")
	else:
		score_label.modulate = Color.WHITE
	
func _count_filled_buckets() -> int:
	return buckets_with_a_ball.reduce(func(count, b): return count + 1 if b > 0 else count, 0)

func _count_empty_buckets() -> int:
	return buckets_with_a_ball.reduce(func(count, b): return count + 1 if b <= 0 else count, 0)


func _on_progress_button_out_of_time() -> void:
	conclude_game()
