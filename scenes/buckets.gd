class_name Buckets
extends Node3D

@onready var bucket: Node3D = $bucket
@onready var top_right_inside_the_buckets_area_3d: Area3D = %TopRightInsideTheBucketsArea3D
@onready var top_left_inside_the_buckets_area_3d: Area3D = %TopLeftInsideTheBucketsArea3D
@onready var bottom_left_inside_the_buckets_area_3d: Area3D = %BottomLeftInsideTheBucketsArea3D
@onready var top_center_inside_the_buckets_area_3d: Area3D = %TopCenterInsideTheBucketsArea3D
@onready var special_inside_the_buckets_area_3d: Area3D = %SpecialInsideTheBucketsArea3D

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
	var buckets_with_a_ball = [
		_count_points(top_center_inside_the_buckets_area_3d, 1),
		_count_points(top_right_inside_the_buckets_area_3d, 1),
		_count_points(special_inside_the_buckets_area_3d, 1),
		_count_points(bottom_left_inside_the_buckets_area_3d, 1),
		_count_points(top_left_inside_the_buckets_area_3d, 1)
	]
	
	update_score.emit(buckets_with_a_ball)

func _count_points(area: Area3D, value: int) -> int:
	var points = 0
	var bodies_in_buckets = area.get_overlapping_bodies()
	for b in bodies_in_buckets:
		if b is Ball:
			points += value
	
	return points
