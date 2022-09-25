extends Node2D

func set_text(text):
	$RichTextLabel.bbcode_text = "[center]%s[/center]" % text
