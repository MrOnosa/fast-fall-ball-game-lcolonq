extends Label


func _on_update_label(balls):
	text = "Balls: %s" % [balls]


func _on_game_on_ball_released(balls: int) -> void:
	_on_update_label(balls)
