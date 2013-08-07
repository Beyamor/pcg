namespace "perl.planet", (ns) ->
	CELL_WIDTH = 8

	class ns.Cell
		constructor: (@gridX, @gridY) ->
			@x = @gridX * CELL_WIDTH
			@y = @gridY * CELL_WIDTH

		draw: (canvas) ->
			canvas.drawRect
				x: @x
				y: @y
				width: CELL_WIDTH
				height: CELL_WIDTH
				color: "#AD6D37"

	class ns.Planet
		constructor: (@x, @y, radiusInPixels) ->
			radius = Math.round(radiusInPixels / CELL_WIDTH)
			@cells = []
			for gridX in [-radius...radius]
				for gridY in [-radius...radius]
					@cells.push new ns.Cell gridX, gridY

		draw: (canvas) ->
			ctx = canvas.context
			ctx.save()
			ctx.translate @x, @y
			cell.draw(canvas) for cell in @cells
			ctx.restore()
