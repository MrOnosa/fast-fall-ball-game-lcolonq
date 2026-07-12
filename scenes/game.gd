extends Node3D

@export var BallPackedScene : PackedScene
@export var BallSpawnVariance := 0.0 # Decided this was too much
@export var ball_drop_debouncing_period = 0.1

@onready var ball_spawn_marker_3d: Marker3D = %BallSpawnMarker3D
@onready var game_over_let_the_dust_settle_timer: Timer = $GameOverLetTheDustSettleTimer
@onready var reset_game_button: Button = $ResetGameButton



signal on_ball_released

var time_left_until_another_ball_can_drop = 0.0
var ball_triggered := false
var balls_left := 25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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

## Count the number of balls, and display win or lose and a reset button for now
func conclude_game():
	reset_game_button.disabled = false
	reset_game_button.show()

func _on_reset_game_button_pressed() -> void:
	get_tree().reload_current_scene()
