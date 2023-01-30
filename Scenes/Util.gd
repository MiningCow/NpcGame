extends Node

func get_json(path):
	var f = File.new()
	assert(f.file_exists(path), "json file at path '%s' does not exist" % path)

	f.open(path, File.READ)

	var json = parse_json(f.get_as_text())

	f.close()

	assert(typeof(json) == TYPE_DICTIONARY)

	return json
