class_name Buckets
extends Node3D

@onready var bucket: Node3D = $bucket
@onready var top_right_inside_the_buckets_area_3d: Area3D = %TopRightInsideTheBucketsArea3D
@onready var top_left_inside_the_buckets_area_3d: Area3D = %TopLeftInsideTheBucketsArea3D
@onready var bottom_left_inside_the_buckets_area_3d: Area3D = %BottomLeftInsideTheBucketsArea3D
@onready var top_center_inside_the_buckets_area_3d: Area3D = %TopCenterInsideTheBucketsArea3D
@onready var special_inside_the_buckets_area_3d: Area3D = %SpecialInsideTheBucketsArea3D

# Default Meshes
@onready var bottom_left_cylinder_004: MeshInstance3D = $BucketRigidBody3D/cool_bucket/BucketMeshes/BottomLeftCylinder_004
@onready var cylinder_bonus: MeshInstance3D = $BucketRigidBody3D/cool_bucket/BucketMeshes/CylinderBonus
@onready var top_center_cylinder_001: MeshInstance3D = $BucketRigidBody3D/cool_bucket/BucketMeshes/TopCenterCylinder_001
@onready var top_left_cylinder_003: MeshInstance3D = $BucketRigidBody3D/cool_bucket/BucketMeshes/TopLeftCylinder_003
@onready var top_right_cylinder_002: MeshInstance3D = $BucketRigidBody3D/cool_bucket/BucketMeshes/TopRightCylinder_002

# Enhanced Meshes
@onready var bottom_left_cylinder_001: MeshInstance3D = $BucketRigidBody3D/cool_bucket/BucketMeshes_001/BottomLeftCylinder_001
@onready var cylinder_bonus_001: MeshInstance3D = $BucketRigidBody3D/cool_bucket/BucketMeshes_001/CylinderBonus_001
@onready var top_center_cylinder_002: MeshInstance3D = $BucketRigidBody3D/cool_bucket/BucketMeshes_001/TopCenterCylinder_002
@onready var top_left_cylinder_001: MeshInstance3D = $BucketRigidBody3D/cool_bucket/BucketMeshes_001/TopLeftCylinder_001
@onready var top_right_cylinder_001: MeshInstance3D = $BucketRigidBody3D/cool_bucket/BucketMeshes_001/TopRightCylinder_001

signal update_score

func _ready() -> void:
	bottom_left_cylinder_004.show()
	cylinder_bonus.show()
	top_center_cylinder_001.show()
	top_left_cylinder_003.show()
	top_right_cylinder_002.show()
	
	bottom_left_cylinder_001.hide()
	cylinder_bonus_001.hide()
	top_center_cylinder_002.hide()
	top_left_cylinder_001.hide()
	top_right_cylinder_001.hide()

func _process(delta: float) -> void:
	pass

## Count how many buckets have any balls in them. 
## Thanks for playtesting, jane.
func _on_count_balls_in_buckets_timer_timeout() -> void:	
	var buckets_with_a_ball = [0,0,0,0,0]
	if _got_balls(top_center_inside_the_buckets_area_3d):
		buckets_with_a_ball[0] = 1
		top_center_cylinder_001.hide()
		top_center_cylinder_002.show()
	else:
		buckets_with_a_ball[0] = 0
		top_center_cylinder_001.show()
		top_center_cylinder_002.hide()
		
	if _got_balls(top_right_inside_the_buckets_area_3d):
		buckets_with_a_ball[1] = 1
		top_right_cylinder_002.hide()
		top_right_cylinder_001.show()
	else:
		buckets_with_a_ball[1] = 0
		top_right_cylinder_002.show()
		top_right_cylinder_001.hide()
		
	if _got_balls(special_inside_the_buckets_area_3d):
		buckets_with_a_ball[2] = 1
		cylinder_bonus.hide()
		cylinder_bonus_001.show()
	else:
		buckets_with_a_ball[2] = 0
		cylinder_bonus.show()
		cylinder_bonus_001.hide()
		
	if _got_balls(bottom_left_inside_the_buckets_area_3d):
		buckets_with_a_ball[3] = 1
		bottom_left_cylinder_004.hide()
		bottom_left_cylinder_001.show()
	else:
		buckets_with_a_ball[3] = 0
		bottom_left_cylinder_004.show()
		bottom_left_cylinder_001.hide()
		
	if _got_balls(top_left_inside_the_buckets_area_3d):
		buckets_with_a_ball[4] = 1
		top_left_cylinder_003.hide()
		top_left_cylinder_001.show()
	else:
		buckets_with_a_ball[4] = 0
		top_left_cylinder_003.show()
		top_left_cylinder_001.hide()
	
	update_score.emit(buckets_with_a_ball)

func _got_balls(area: Area3D) -> bool:
	var bodies_in_buckets = area.get_overlapping_bodies()
	for b in bodies_in_buckets:
		if b is Ball:
			return true
	
	return false
