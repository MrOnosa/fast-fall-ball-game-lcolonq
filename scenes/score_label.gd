extends Label

func _on_update_label(score):
	text = "Score: %02d / %02d" % [score, 10]

func _on_buckets_update_score(buckets_with_a_ball) -> void:
	_on_update_label(buckets_with_a_ball)
