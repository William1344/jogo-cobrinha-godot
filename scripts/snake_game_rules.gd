extends RefCounted

class_name SnakeGameRules

static func create_initial_snake() -> Array[Vector2i]:
	return [
		Vector2i(10, 7),
		Vector2i(9, 7),
		Vector2i(8, 7)
	]


static func generate_food(snake: Array[Vector2i]) -> Vector2i:
	while true:
		var new_position := Vector2i(
			randi() % SnakeGameConfig.GRID_WIDTH,
			randi() % SnakeGameConfig.GRID_HEIGHT
		)

		if new_position not in snake:
			return new_position

	return Vector2i.ZERO


static func move_snake(
	snake: Array[Vector2i],
	_direction: Vector2i,
	next_direction: Vector2i,
	food_position: Vector2i
) -> Dictionary:
	var result := {
		"snake": snake.duplicate(),
		"direction": next_direction,
		"ate_food": false,
		"game_over": false
	}

	if snake.is_empty():
		result["game_over"] = true
		return result

	var new_snake: Array[Vector2i] = snake.duplicate()
	var new_direction := next_direction
	var new_head: Vector2i = new_snake[0] + new_direction

	if new_head.x >= SnakeGameConfig.GRID_WIDTH:
		new_head.x = 0
	elif new_head.x < 0:
		new_head.x = SnakeGameConfig.GRID_WIDTH - 1

	if new_head.y >= SnakeGameConfig.GRID_HEIGHT:
		new_head.y = 0
	elif new_head.y < 0:
		new_head.y = SnakeGameConfig.GRID_HEIGHT - 1

	var ate_food := new_head == food_position
	var body_for_collision: Array[Vector2i] = new_snake.duplicate()

	if not ate_food and body_for_collision.size() > 0:
		body_for_collision.pop_back()

	if new_head in body_for_collision:
		result["game_over"] = true
		return result

	new_snake.insert(0, new_head)

	if not ate_food:
		new_snake.pop_back()

	result["snake"] = new_snake
	result["direction"] = new_direction
	result["ate_food"] = ate_food
	return result