extends TextureButton

export(int) var id

func set_text(text: String):
	$Label.bbcode_text = "[center]" + text + "[/center]"
