namespace "perl.planet", (ns) ->
	CELL_WIDTH = 2

	class ns.Cell
		constructor: (@gridX, @gridY, @type, @distance) ->
			@x = @gridX * CELL_WIDTH
			@y = @gridY * CELL_WIDTH

		draw: (canvas) ->
			color = switch @type
				when "ground" then "#AD6D37"
				when "water" then "#59AFDE"
				else null

			if color?
				canvas.drawRect
					x: @x
					y: @y
					width: CELL_WIDTH
					height: CELL_WIDTH
					color: color


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
					heightThreshold += noise.noise(angle*1, 0) * 5
					heightThreshold += noise.noise(angle*2, 0) * 15
					heightThreshold += noise.noise(angle*5, 0) * 5

					type = if distance <= heightThreshold
							"ground"
						else
							"air"

					@cells.push new ns.Cell gridX, gridY, type, distance

			for cell in @cells when cell.distance < pixelRadius / 2 - 3 and cell.type is "air"
				cell.type = "water"

		draw: (canvas) ->
			ctx = canvas.context
			ctx.save()
			ctx.translate @x, @y
			cell.draw(canvas) for cell in @cells
			ctx.restore()
