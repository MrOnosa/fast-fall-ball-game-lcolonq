class_name ProgressButton
extends TextureButton

@export var total_time_required : float = 20.0

signal out_of_time

var is_running : bool = false
var time_so_far : float = 0.0

func _process(delta: float) -> void:	
	if is_running:
		time_so_far += delta		
		%TextureProgressBar.value = (time_so_far / total_time_required) * 100.0
		if %TextureProgressBar.value >= 100.0:
			%TextureProgressBar.value = 100.0
			is_running = false
			out_of_time.emit()
