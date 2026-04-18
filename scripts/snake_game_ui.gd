extends RefCounted

class_name SnakeGameUI

var ui_layer: CanvasLayer
var menu_panel: PanelContainer
var score_label: Label
var high_score_label: Label
var speed_value_label: Label
var color_value_label: Label
var game_over_label: Label

var _on_start_pressed: Callable
var _on_speed_selected: Callable
var _on_color_selected: Callable


func build(owner: Node2D, high_score: int, selected_speed_level: int, selected_snake_color_index: int, on_start_pressed: Callable, on_speed_selected: Callable, on_color_selected: Callable) -> void:
	_on_start_pressed = on_start_pressed
	_on_speed_selected = on_speed_selected
	_on_color_selected = on_color_selected

	ui_layer = CanvasLayer.new()
	owner.add_child(ui_layer)

	menu_panel = PanelContainer.new()
	menu_panel.visible = true
	menu_panel.size = Vector2(420, 330)
	menu_panel.position = Vector2(
		((SnakeGameConfig.GRID_WIDTH * SnakeGameConfig.CELL_SIZE) - menu_panel.size.x) / 2.0,
		((SnakeGameConfig.GRID_HEIGHT * SnakeGameConfig.CELL_SIZE) - menu_panel.size.y) / 2.0
	)
	ui_layer.add_child(menu_panel)

	var vbox := VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.offset_left = 20
	vbox.offset_top = 20
	vbox.offset_right = -20
	vbox.offset_bottom = -20
	vbox.add_theme_constant_override("separation", 12)
	menu_panel.add_child(vbox)

	var title := Label.new()
	title.text = "JOGO DA COBRINHA"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 28)
	vbox.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Escolha as opções e inicie"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 16)
	vbox.add_child(subtitle)

	vbox.add_child(HSeparator.new())

	var speed_title := Label.new()
	speed_title.text = "Velocidade"
	speed_title.add_theme_font_size_override("font_size", 18)
	vbox.add_child(speed_title)

	var speed_hbox := HBoxContainer.new()
	speed_hbox.add_theme_constant_override("separation", 8)
	vbox.add_child(speed_hbox)

	for i in range(1, 11):
		var btn := Button.new()
		btn.text = str(i)
		btn.custom_minimum_size = Vector2(40, 36)
		btn.pressed.connect(_on_speed_button_pressed.bind(i))
		speed_hbox.add_child(btn)

	speed_value_label = Label.new()
	speed_value_label.text = "Selecionada: %d" % selected_speed_level
	vbox.add_child(speed_value_label)

	vbox.add_child(HSeparator.new())

	var color_title := Label.new()
	color_title.text = "Cor da cobrinha"
	color_title.add_theme_font_size_override("font_size", 18)
	vbox.add_child(color_title)

	var color_hbox := HBoxContainer.new()
	color_hbox.add_theme_constant_override("separation", 8)
	vbox.add_child(color_hbox)

	for i in range(SnakeGameConfig.SNAKE_COLORS.size()):
		var color_btn := Button.new()
		color_btn.text = SnakeGameConfig.SNAKE_COLORS[i]["name"]
		color_btn.custom_minimum_size = Vector2(90, 36)
		color_btn.modulate = SnakeGameConfig.SNAKE_COLORS[i]["head"]
		color_btn.pressed.connect(_on_color_button_pressed.bind(i))
		color_hbox.add_child(color_btn)

	color_value_label = Label.new()
	color_value_label.text = "Selecionada: %s" % SnakeGameConfig.SNAKE_COLORS[selected_snake_color_index]["name"]
	vbox.add_child(color_value_label)

	vbox.add_child(HSeparator.new())

	var start_button := Button.new()
	start_button.text = "Iniciar Jogo"
	start_button.custom_minimum_size = Vector2(0, 48)
	start_button.pressed.connect(_on_start_button_pressed)
	vbox.add_child(start_button)

	var instructions := Label.new()
	instructions.text = "Setas: mover | Enter: iniciar | R: reiniciar após game over"
	instructions.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	instructions.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(instructions)

	score_label = Label.new()
	score_label.text = "Score: 0"
	score_label.position = Vector2(10, 10)
	score_label.visible = false
	score_label.add_theme_font_size_override("font_size", 20)
	ui_layer.add_child(score_label)

	high_score_label = Label.new()
	high_score_label.text = "Recorde: %d" % high_score
	high_score_label.position = Vector2(10, 36)
	high_score_label.visible = false
	high_score_label.add_theme_font_size_override("font_size", 18)
	ui_layer.add_child(high_score_label)

	game_over_label = Label.new()
	game_over_label.text = ""
	game_over_label.visible = false
	game_over_label.position = Vector2(
		((SnakeGameConfig.GRID_WIDTH * SnakeGameConfig.CELL_SIZE) / 2.0) - 170,
		((SnakeGameConfig.GRID_HEIGHT * SnakeGameConfig.CELL_SIZE) / 2.0) - 30
	)
	game_over_label.add_theme_font_size_override("font_size", 24)
	ui_layer.add_child(game_over_label)


func show_menu() -> void:
	menu_panel.visible = true
	score_label.visible = false
	high_score_label.visible = false
	game_over_label.visible = false


func show_playing() -> void:
	menu_panel.visible = false
	score_label.visible = true
	high_score_label.visible = true
	game_over_label.visible = false


func show_game_over(score: int, high_score: int) -> void:
	menu_panel.visible = false
	score_label.visible = true
	high_score_label.visible = true
	game_over_label.text = "GAME OVER\nScore: %d | Recorde: %d\nPressione R para reiniciar" % [score, high_score]
	game_over_label.visible = true


func update_hud(score: int, high_score: int) -> void:
	score_label.text = "Score: %d" % score
	high_score_label.text = "Recorde: %d" % high_score


func update_speed_level(level: int) -> void:
	speed_value_label.text = "Selecionada: %d" % level


func update_color_selection(index: int) -> void:
	color_value_label.text = "Selecionada: %s" % SnakeGameConfig.SNAKE_COLORS[index]["name"]


func _on_start_button_pressed() -> void:
	_on_start_pressed.call()


func _on_speed_button_pressed(level: int) -> void:
	_on_speed_selected.call(level)


func _on_color_button_pressed(index: int) -> void:
	_on_color_selected.call(index)