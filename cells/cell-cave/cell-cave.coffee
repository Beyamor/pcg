WIDTH	= 800
HEIGHT	= 600

CELL_WIDTH = 8

TYPE_COLORS =
	"wall": "white"
	"empty": "black"

class Cell
	constructor: (@grid, @x, @y) ->
		@fixed = false
		@type =
			if Math.random() <= 0.45
				"wall"
			else
				"empty"

	fixAsWall: ->
		@fixed = true
		@type = "wall"

	computeStep: ->
		return if @fixed
		@nextType =
			if @type is "wall" and @grid.neighboursOfType(this, "wall").length >= 4
				"wall"
			else if @type is "empty" and @grid.neighboursOfType(this, "wall").length >= 5
				"wall"
			else
				"empty"

	finishStep: ->
		return if @fixed
		@type = @nextType

	draw: (context) ->
		context.fillStyle = TYPE_COLORS[@type]
		context.fillRect @x * CELL_WIDTH, @y * CELL_WIDTH, CELL_WIDTH, CELL_WIDTH

class Grid
	constructor: ->
		@width	= Math.floor(WIDTH/CELL_WIDTH)
		@height	= Math.floor(HEIGHT/CELL_WIDTH)

		@cells = []
		for x in [0...@width]
			@cells[x] = []
			for y in [0...@height]
				@cells[x][y] = new Cell this, x, y

		@addBorderWalls()

	addBorderWalls: ->
		for x in [0, @width-1]
			for y in [0..@height-1]
				@cells[x][y].fixAsWall()
		for y in [0, @height-1]
			for x in [0..@width-1]
				@cells[x][y].fixAsWall()


	neighbours: (cell) ->
		neighbours = []
		for x in [Math.max(0, cell.x-1)..Math.min(@width-1, cell.x+1)]
			for y in [Math.max(0, cell.y-1)..Math.min(@height-1, cell.y+1)] \
				when x isnt cell.x or y isnt cell.y
					neighbours.push @cells[x][y]
		return neighbours

	neighboursOfType: (cell, type) ->
		(neighbour for neighbour in @neighbours cell when neighbour.type is type)

	step: ->
		@cells[x][y].computeStep() for x in [0...@width] for y in [0...@height]
		@cells[x][y].finishStep() for x in [0...@width] for y in [0...@height]

	draw: (context) ->
		@cells[x][y].draw context for y in [0...@height] for x in [0...@width]

$ ->
	$canvas = $("<canvas width=\"#{WIDTH}\" height=\"#{HEIGHT}\"></canvas>")
	$("body").append($canvas)
	context = $canvas[0].getContext "2d"

	context.fillStyle = "black"
	context.fillRect 0, 0, WIDTH, HEIGHT

	grid = new Grid
	grid.step() for i in [1..5]
	grid.draw context
