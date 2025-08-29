extends Node

const SPAWN_RADIUS_FIX = 20

@export var basic_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene
@export var arena_time_manager: AreanTimeManager

@onready var timer = $Timer

var base_spawn_time = 0
var spawn_radius = 0

var enemy_table = WeightedTable.new();


func _ready() -> void:
	enemy_table.add_item(basic_enemy_scene, 10);
	
	base_spawn_time = timer.wait_time;
	timer.timeout.connect(on_timer_timeout);
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased);
	spawn_radius = get_viewport().get_visible_rect().size.x / 2;
	print("spawn_radius: %f" % [spawn_radius])


func get_spawn_position():
	var found_spawn_place = false;
	var player = get_tree().get_first_node_in_group("player") as Node2D;
	if player == null:
		return Vector2.ZERO;
		
	var spawn_position = Vector2.ZERO;
	
	while not found_spawn_place:
		var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU));
		for i in 4:
			spawn_position = player.global_position + (random_direction * (spawn_radius + SPAWN_RADIUS_FIX));
			
			var query_paramaters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1<<0);
			var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_paramaters);
#		
			if result.is_empty():
				found_spawn_place = true;
				break;
			else:
				random_direction = random_direction.rotated(deg_to_rad(90));
	
	return spawn_position;


func on_timer_timeout():
	timer.start()
	
	var player = get_tree().get_first_node_in_group("player") as Node2D;
	if player == null:
		return;

	var enemy_scene = enemy_table.pick_item();
	var enemy = enemy_scene.instantiate() as Node2D;
	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer");
	if entities_layer == null:
		return;
		
	entities_layer.add_child(enemy)
	enemy.global_position = get_spawn_position()


func on_arena_difficulty_increased(arena_difficulty: int):
	print("Arena Difficulty %s" % arena_difficulty)
	var time_off = (.1 / 12) * arena_difficulty;
	time_off = min(time_off, .7);
	print(time_off);
	timer.wait_time = base_spawn_time - time_off;
	
	if arena_difficulty == 1:
		enemy_table.add_item(wizard_enemy_scene, 20);
