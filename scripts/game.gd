extends Node2D

const CELL_SIZE: int = 16
const GRID_WIDTH: int = 70
const GRID_HEIGHT: int = 30

var snake: Array[Vector2i] = []
var direction: Vector2i = Vector2i.RIGHT
var next_direction: Vector2i = Vector2i.RIGHT
var food_position: Vector2i = Vector2i.ZERO

func _ready() -> void:
	randomize()
	iniciar_jogo()

func iniciar_jogo() -> void:
	snake.clear()

	# Começa com 3 partes
	snake.append(Vector2i(10, 7))
	snake.append(Vector2i(9, 7))
	snake.append(Vector2i(8, 7))

	direction = Vector2i.RIGHT
	next_direction = Vector2i.RIGHT

	gerar_comida()
	queue_redraw()

func _draw() -> void:
	desenhar_grade()
	desenhar_comida()
	desenhar_cobrinha()

func desenhar_grade() -> void:
	for x in range(GRID_WIDTH):
		for y in range(GRID_HEIGHT):
			draw_rect(
				Rect2(
					x * CELL_SIZE,
					y * CELL_SIZE,
					CELL_SIZE,
					CELL_SIZE
				),
				Color(0.15, 0.15, 0.15),
				false,
				1.0
			)

func desenhar_cobrinha() -> void:
	for i in range(snake.size()):
		var cor: Color = Color(0.0, 0.8, 0.0) if i == 0 else Color.GREEN

		draw_rect(
			Rect2(
				snake[i].x * CELL_SIZE,
				snake[i].y * CELL_SIZE,
				CELL_SIZE,
				CELL_SIZE
			),
			cor
		)

func desenhar_comida() -> void:
	draw_rect(
		Rect2(
			food_position.x * CELL_SIZE,
			food_position.y * CELL_SIZE,
			CELL_SIZE,
			CELL_SIZE
		),
		Color.RED
	)

func gerar_comida() -> void:
	var posicao_valida: bool = false

	while not posicao_valida:
		var nova_posicao := Vector2i(
			randi() % GRID_WIDTH,
			randi() % GRID_HEIGHT
		)

		if nova_posicao not in snake:
			food_position = nova_posicao
			posicao_valida = true

func _on_move_timer_timeout() -> void:
	mover_cobrinha()

func mover_cobrinha() -> void:
	direction = next_direction

	var nova_cabeca: Vector2i = snake[0] + direction

	# Wrap horizontal
	if nova_cabeca.x >= GRID_WIDTH:
		nova_cabeca.x = 0
	elif nova_cabeca.x < 0:
		nova_cabeca.x = GRID_WIDTH - 1

	# Wrap vertical
	if nova_cabeca.y >= GRID_HEIGHT:
		nova_cabeca.y = 0
	elif nova_cabeca.y < 0:
		nova_cabeca.y = GRID_HEIGHT - 1

	var comeu_comida: bool = nova_cabeca == food_position

	snake.insert(0, nova_cabeca)

	if comeu_comida:
		gerar_comida()
	else:
		snake.pop_back()

	queue_redraw()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up") and direction != Vector2i.DOWN:
		next_direction = Vector2i.UP
	elif event.is_action_pressed("ui_down") and direction != Vector2i.UP:
		next_direction = Vector2i.DOWN
	elif event.is_action_pressed("ui_left") and direction != Vector2i.RIGHT:
		next_direction = Vector2i.LEFT
	elif event.is_action_pressed("ui_right") and direction != Vector2i.LEFT:
		next_direction = Vector2i.RIGHT
