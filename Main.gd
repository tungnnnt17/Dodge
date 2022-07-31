extends Node

export(PackedScene) var mob_scene
var score

func _ready():
	randomize()
	
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	
func new_game():
	get_tree().call_group("mobs", "queue_free")
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get ready")



func _on_Player_hit():
	game_over()


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_MobTimer_timeout():
	var mob = mob_scene.instance()
	
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.offset = randi()
	
	var direction = mob_spawn_location.rotation + PI/2
	direction += rand_range(-PI/4, PI/4)
	
	mob.position = mob_spawn_location.position
	mob.rotation = direction
	mob.linear_velocity = Vector2(rand_range(150.0, 250.0), 0).rotated(direction)

	add_child(mob)


func _on_HUD_start_game():
	new_game()
