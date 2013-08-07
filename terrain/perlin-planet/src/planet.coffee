namespace "perl.planet", (ns) ->
	CELL_WIDTH = 2

	class ns.Cell
		constructor: (@gridX, @gridY, @type) ->
			@x = @gridX * CELL_WIDTH
			@y = @gridY * CELL_WIDTH

		draw: (canvas) ->
			if @type is "ground"
				canvas.drawRect
					x: @x
					y: @y
					width: CELL_WIDTH
					height: CELL_WIDTH
					color: "#AD6D37"
			else
				canvas.drawRect
					x: @x
					y: @y
					width: CELL_WIDTH
					height: CELL_WIDTH
					color: "rgba(255, 255, 255, 0.1)"


	class ns.Planet
		constructor: (@x, @y, pixelRadius) ->
			@cells = []
			
			noise = new SimplexNoise

			gridWidth = gridHeight = Math.round(pixelRadius / CELL_WIDTH)
			for gridX in [-gridWidth...gridWidth]
				for gridY in [-gridHeight...gridHeight]
					x = gridX * CELL_WIDTH
					y = gridY * CELL_WIDTH
					distance = Math.sqrt(x*x + y*y)
					angle = Math.atan2 y, x

					heightThreshold = pixelRadius / 2
					heightThreshold += noise.noise(angle*4, 0) * 10

					type = if distance <= heightThreshold
							"ground"
						else
							"air"

					@cells.push new ns.Cell gridX, gridY, type

		draw: (canvas) ->
			ctx = canvas.context
			ctx.save()
			ctx.translate @x, @y
			cell.draw(canvas) for cell in @cells
			ctx.restore()
