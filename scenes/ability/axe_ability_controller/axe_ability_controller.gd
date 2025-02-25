class_name AxeAbilityController extends Node

@export var axe_ability_scene: PackedScene

var damage = 10


func _ready() -> void:
	$Timer.timeout.connect(on_timer_timeout)


func on_timer_timeout():
	var player: Player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
		
	var foreground: Node2D = get_tree().get_first_node_in_group("foreground_layer")
	if foreground == null:
		return
	
	var axe_instance: AxeAbility = axe_ability_scene.instantiate()
	foreground.add_child(axe_instance)
	axe_instance.global_position = player.global_position
	axe_instance.hitbox_component.damage = damage
