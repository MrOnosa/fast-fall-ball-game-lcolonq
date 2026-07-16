extends Label

func update_label(balls):
	text = "Balls: %s" % [balls]

func _on_game_on_ball_released(balls: int) -> void:
	update_label(balls)
