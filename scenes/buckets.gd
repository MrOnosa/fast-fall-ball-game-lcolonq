class_name Buckets
extends Node3D

@onready var bucket: Node3D = $bucket
@onready var inside_the_buckets_area_3d: Area3D = %InsideTheBucketsArea3D
@onready var inside_the_buckets_area_2x_3d: Area3D = %InsideTheBucketsArea2X3D

@export var rotation_speed := 1.0

@export var total_balls_in_buckets := 0

signal update_score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_count_balls_in_buckets_timer_timeout() -> void:	
	total_balls_in_buckets = 0
	
	total_balls_in_buckets += _count_points(inside_the_buckets_area_3d, 1)
	total_balls_in_buckets += _count_points(inside_the_buckets_area_2x_3d, 2)
	
	update_score.emit(total_balls_in_buckets)

func _count_points(area: Area3D, value: int) -> int:
	var points = 0
	var bodies_in_buckets = area.get_overlapping_bodies()
	for b in bodies_in_buckets:
		if b is Ball:
			points += value
	
	return points
