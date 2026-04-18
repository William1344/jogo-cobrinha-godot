extends RefCounted

class_name SnakeSaveManager

static func save_high_score(path: String, high_score: int) -> void:
	var config := ConfigFile.new()
	config.set_value("score", "high_score", high_score)
	config.save(path)


static func load_high_score(path: String) -> int:
	var config := ConfigFile.new()
	var err := config.load(path)

	if err == OK:
		return int(config.get_value("score", "high_score", 0))

	return 0