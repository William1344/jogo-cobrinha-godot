extends RefCounted

class_name SnakeGameConfig

const CELL_SIZE: int = 16
const GRID_WIDTH: int = 60
const GRID_HEIGHT: int = 30

const SAVE_PATH := "user://snake_save.cfg"

enum GameState {
	MENU,
	PLAYING,
	GAME_OVER
}

const SNAKE_COLORS := [
	{"name": "Verde", "head": Color(0.0, 0.9, 0.0), "body": Color(0.0, 0.65, 0.0)},
	{"name": "Azul", "head": Color(0.2, 0.7, 1.0), "body": Color(0.1, 0.45, 0.9)},
	{"name": "Amarelo", "head": Color(1.0, 0.9, 0.2), "body": Color(0.9, 0.75, 0.1)},
	{"name": "Roxo", "head": Color(0.75, 0.4, 1.0), "body": Color(0.55, 0.2, 0.85)},
	{"name": "Branco", "head": Color(0.95, 0.95, 0.95), "body": Color(0.8, 0.8, 0.8)},
	{"name": "Laranja", "head": Color(1.0, 0.55, 0.1), "body": Color(0.9, 0.4, 0.0)},
	{"name": "Rosa", "head": Color(1.0, 0.45, 0.75), "body": Color(0.9, 0.25, 0.6)}
]

const SPEED_MAP := {
	1: 0.22,
	2: 0.18,
	3: 0.15,
	4: 0.12,
	5: 0.10,
	6: 0.08,
	7: 0.06,
	8: 0.05,
	9: 0.02,
	10: 0.01
}