extends Area2D

func _draw() -> void:
	var tile := 18
	var cols := 2
	var rows := 8
	var total_h := rows * tile

	for row in rows:
		for col in cols:
			var color := Color.WHITE if (row + col) % 2 == 0 else Color.BLACK
			draw_rect(
				Rect2(col * tile - tile, row * tile - total_h / 2, tile, tile),
				color
			)

	draw_rect(
		Rect2(-tile, -total_h / 2, cols * tile, total_h),
		Color.BLUE, false, 3.0
	)
