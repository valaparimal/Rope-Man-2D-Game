extends Control

const TOTAL_POINTS := 9
const TOTAL_TRIANGLES := 3
var selected := []
var triangles := []
var lines := []

@onready var point_container = $PointContainer
@onready var line_layer = $LineLayer
@onready var status_label = $StatusLabel
@onready var unlock_image = $UnlockImage

func _ready():
	# Enable input on TextureRect
	unlock_image.mouse_filter = Control.MOUSE_FILTER_STOP
	unlock_image.gui_input.connect(_on_unlock_image_clicked)
	
	var radius = 200
	var center = Vector2(300, 300)
	for i in range(TOTAL_POINTS):
		var angle = (2 * PI * i) / TOTAL_POINTS
		var pos = center + Vector2(cos(angle), sin(angle)) * radius
		var btn = Button.new()
		btn.text = str(i + 1)
		btn.position = pos
		btn.size = Vector2(40, 40)
		btn.name = "Point%d" % (i + 1)
		btn.pressed.connect(func(): _on_point_selected(btn))
		point_container.add_child(btn)

	status_label.text = " Connect 9 points into 3 triangles without crossing lines."

func _on_point_selected(point):
	if selected.has(point):
		return

	selected.append(point)

	if selected.size() == 3:
		var a = selected[0].global_position + selected[0].size / 2
		var b = selected[1].global_position + selected[1].size / 2
		var c = selected[2].global_position + selected[2].size / 2

		var new_lines = [[a, b], [b, c], [c, a]]

		for l in new_lines:
			for existing in lines:
				if _lines_cross(l[0], l[1], existing[0], existing[1]):
					status_label.text = "Lines would cross. Try another triangle."
					selected.clear()
					return

		for l in new_lines:
			_draw_line(l[0], l[1])
			lines.append(l)

		triangles.append(selected.duplicate())
		selected.clear()

		if triangles.size() == TOTAL_TRIANGLES:
			status_label.text = " Puzzle Complete! 3 Triangles Formed."
			GameState.unlock_level("level_2")
			unlock_image.visible=true
			unlock_image.scale = Vector2.ZERO
			var tween = create_tween()
			tween.tween_property(unlock_image, "scale", Vector2(1, 1), 2.0).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _draw_line(start_pos: Vector2, end_pos: Vector2):
	var line = Line2D.new()
	line.width = 3
	line.default_color = Color(1, 0.5, 0)
	line.add_point(start_pos)
	line.add_point(end_pos)
	line_layer.add_child(line)

func ccw(p1: Vector2, p2: Vector2, p3: Vector2) -> bool:
	return (p3.y - p1.y) * (p2.x - p1.x) > (p2.y - p1.y) * (p3.x - p1.x)

func _lines_cross(a1: Vector2, a2: Vector2, b1: Vector2, b2: Vector2) -> bool:
	return ccw(a1, b1, b2) != ccw(a2, b1, b2) and ccw(a1, a2, b1) != ccw(a1, a2, b2)

func _on_unlock_image_clicked(event):
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene_to_file("res://scenes/play/Lavel_Container.tscn")
