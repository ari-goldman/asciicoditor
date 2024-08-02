extends Node

@onready var editor: Node2D= $"../SubViewportContainer/SubViewport/Editor"

@onready var shaders := {
	"scanlines" = $Scanlines,
	"bloom" = $Bloom,
	"curve" = $Curve,
}

func _ready() -> void:
	Global.save_flash.connect(save)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("scanlines"):
		shaders["scanlines"].visible = not shaders["scanlines"].visible
	elif event.is_action_pressed("bloom"):
		shaders["bloom"].visible = not shaders["bloom"].visible
	elif event.is_action_pressed("curve"):
		shaders["curve"].visible = not shaders["curve"].visible


@onready var screenshot: ColorRect = $Screenshot/Screenshot
var camera_tween: Tween
func save() -> void:
	if camera_tween:
		camera_tween.kill()
	camera_tween = create_tween()
	
	camera_tween.tween_property(screenshot, "material:shader_parameter/whiteness",0.0 , 1) \
				.from(1.0) \
				.set_ease(Tween.EASE_OUT) \
				.set_trans(Tween.TRANS_QUINT)
