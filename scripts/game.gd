extends Node2D

var snake: Array[Vector2i] = []
var direction: Vector2i = Vector2i.RIGHT
var next_direction: Vector2i = Vector2i.RIGHT
var food_position: Vector2i = Vector2i.ZERO

var game_state: int = SnakeGameConfig.GameState.MENU

var current_score: int = 0
var high_score: int = 0

var selected_speed_level: int = 3
var selected_snake_color_index: int = 0

@onready var move_timer: Timer = $MoveTimer

var game_ui: SnakeGameUI


func _ready() -> void:
	randomize()
	high_score = SnakeSaveManager.load_high_score(SnakeGameConfig.SAVE_PATH)
	game_ui = SnakeGameUI.new()
	game_ui.build(
		self ,
		high_score,
		selected_speed_level,
		selected_snake_color_index,
		Callable(self , "iniciar_jogo"),
		Callable(self , "_on_speed_button_pressed"),
		Callable(self , "_on_color_button_pressed")
	)
	abrir_menu()


func abrir_menu() -> void:
	game_state = SnakeGameConfig.GameState.MENU
	move_timer.stop()
	game_ui.show_menu()
	queue_redraw()


func iniciar_jogo() -> void:
	snake = SnakeGameRules.create_initial_snake()

	direction = Vector2i.RIGHT
	next_direction = Vector2i.RIGHT
	current_score = 0

	game_state = SnakeGameConfig.GameState.PLAYING
	game_ui.show_playing()

	atualizar_hud()
	gerar_comida()
	configurar_velocidade()
	move_timer.start()
	queue_redraw()


func configurar_velocidade() -> void:
	move_timer.wait_time = SnakeGameConfig.SPEED_MAP.get(selected_speed_level, 0.15)


func atualizar_hud() -> void:
	game_ui.update_hud(current_score, high_score)


func _draw() -> void:
	if game_state == SnakeGameConfig.GameState.PLAYING or game_state == SnakeGameConfig.GameState.GAME_OVER:
		SnakeGameRenderer.draw_scene(self , snake, food_position, selected_snake_color_index)


func gerar_comida() -> void:
	food_position = SnakeGameRules.generate_food(snake)


func _on_move_timer_timeout() -> void:
	if game_state == SnakeGameConfig.GameState.PLAYING:
		mover_cobrinha()


func mover_cobrinha() -> void:
	var step_result := SnakeGameRules.move_snake(snake, direction, next_direction, food_position)

	if step_result["game_over"]:
		finalizar_jogo()
		return

	snake = step_result["snake"]
	direction = step_result["direction"]

	if step_result["ate_food"]:
		current_score += 1
		if current_score > high_score:
			high_score = current_score
			SnakeSaveManager.save_high_score(SnakeGameConfig.SAVE_PATH, high_score)
		gerar_comida()

	atualizar_hud()
	queue_redraw()


func finalizar_jogo() -> void:
	game_state = SnakeGameConfig.GameState.GAME_OVER
	move_timer.stop()

	if current_score > high_score:
		high_score = current_score
		SnakeSaveManager.save_high_score(SnakeGameConfig.SAVE_PATH, high_score)

	atualizar_hud()
	game_ui.show_game_over(current_score, high_score)
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if game_state == SnakeGameConfig.GameState.MENU:
		if event.is_action_pressed("ui_accept"):
			iniciar_jogo()
		return

	if game_state == SnakeGameConfig.GameState.GAME_OVER:
		if event.is_action_pressed("ui_text_submit") or event.is_action_pressed("ui_accept"):
			iniciar_jogo()
		elif event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_R:
			iniciar_jogo()
		return

	if game_state != SnakeGameConfig.GameState.PLAYING:
		return

	if event.is_action_pressed("ui_up") and direction != Vector2i.DOWN:
		next_direction = Vector2i.UP
	elif event.is_action_pressed("ui_down") and direction != Vector2i.UP:
		next_direction = Vector2i.DOWN
	elif event.is_action_pressed("ui_left") and direction != Vector2i.RIGHT:
		next_direction = Vector2i.LEFT
	elif event.is_action_pressed("ui_right") and direction != Vector2i.LEFT:
		next_direction = Vector2i.RIGHT


func _on_speed_button_pressed(level: int) -> void:
	selected_speed_level = level
	game_ui.update_speed_level(selected_speed_level)


func _on_color_button_pressed(index: int) -> void:
	selected_snake_color_index = index
	game_ui.update_color_selection(selected_snake_color_index)
	queue_redraw()
