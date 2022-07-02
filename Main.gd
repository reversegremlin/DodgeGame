extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(PackedScene) var mob_scene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
#	new_game()

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")

func _on_MobTimer_timeout():
	#Create a new Mob instance
	var mob = mob_scene.instance()
	
	#choose a random location on Path2d
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()
	
	#set mobs direction perpendicular to path direction
	var direction = mob_spawn_location.rotation + PI / 2

	#set mobs postion to random loc
	mob.position = mob_spawn_location.position
	
	#add some randomness to direction
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	#choose velocity for mob
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	#spawn mob
	add_child(mob)
	
func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_StartTimer_timeout():
	$ScoreTimer.start()
	$MobTimer.start()
