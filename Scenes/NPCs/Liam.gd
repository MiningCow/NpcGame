extends Npc

onready var visibility_notifier = $VisibilityNotifier2D

var conditions = {
	"admitted": [
		{
			"type": "var",
			"id": "admitted_Liam",
			"value": "true"
		}
	]
}

func _ready():
	visibility_notifier.connect("screen_exited", self, "_on_VisibilityNotifier2D_screen_exited")

func _on_VisibilityNotifier2D_screen_exited():
	if ConditionManager.check_condition("admitted", conditions):
		hide()
		visibility_notifier.disconnect("screen_exited", self, "_on_VisibilityNotifier2D_screen_exited")
		$CollisionShape2D.disabled = true
