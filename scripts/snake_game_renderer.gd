extends RefCounted

class_name SnakeGameRenderer

static func draw_scene(owner: Node2D, snake: Array[Vector2i], food_position: Vector2i, selected_snake_color_index: int) -> void:
	draw_grid(owner)
	draw_food(owner, food_position)
	draw_snake(owner, snake, selected_snake_color_index)


static func draw_grid(owner: Node2D) -> void:
	for x in range(SnakeGameConfig.GRID_WIDTH):
		for y in range(SnakeGameConfig.GRID_HEIGHT):
			owner.draw_rect(
				Rect2(
					x * SnakeGameConfig.CELL_SIZE,
					y * SnakeGameConfig.CELL_SIZE,
					SnakeGameConfig.CELL_SIZE,
					SnakeGameConfig.CELL_SIZE
				),
				Color(0.15, 0.15, 0.15),
				false,
				1.0
			)


static func draw_snake(owner: Node2D, snake: Array[Vector2i], selected_snake_color_index: int) -> void:
	var head_color: Color = SnakeGameConfig.SNAKE_COLORS[selected_snake_color_index]["head"]
	var body_color: Color = SnakeGameConfig.SNAKE_COLORS[selected_snake_color_index]["body"]

	for i in range(snake.size()):
		var cor: Color = head_color if i == 0 else body_color

		owner.draw_rect(
			Rect2(
				snake[i].x * SnakeGameConfig.CELL_SIZE,
				snake[i].y * SnakeGameConfig.CELL_SIZE,
				SnakeGameConfig.CELL_SIZE,
				SnakeGameConfig.CELL_SIZE
			),
			cor
		)


static func draw_food(owner: Node2D, food_position: Vector2i) -> void:
	owner.draw_rect(
		Rect2(
			food_position.x * SnakeGameConfig.CELL_SIZE,
			food_position.y * SnakeGameConfig.CELL_SIZE,
			SnakeGameConfig.CELL_SIZE,
			SnakeGameConfig.CELL_SIZE
		),
		Color.RED
	)