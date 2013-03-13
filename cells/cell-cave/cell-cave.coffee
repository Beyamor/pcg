WIDTH	= 800
HEIGHT	= 600

CELL_WIDTH = 8

TYPE_COLORS =
	"wall": "white"
	"empty": "black"

class Cell
	constructor: (@grid, @x, @y) ->
		@currentStep = 1
		@fixed = false
		@type =
			if Math.random() <= 0.4
				"wall"
			else
				"empty"

	fixAsWall: ->
		@fixed = true
		@type = "wall"

	computeStep: ->
		return if @fixed

		numberOfWalls = @grid.neighboursOfType(this, "wall").length
		numberOfWalls += 1 if @type is "wall"

		if 1 <= @currentStep <= 4
			@nextType =
				if numberOfWalls >= 5 or numberOfWalls == 0
					"wall"
				else
					"empty"

		else if 5 <= @currentStep <= 7
			@nextType =
				if numberOfWalls >= 5
					"wall"
				else
					"empty"

		else
			@isFinished = true

		++@currentStep

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
		for x in [0...@width]
			for y in [0...@height]
				@cells[x][y].computeStep()
				if @cells[x][y].isFinished
					@isFinished = true

		return if @isFinished

		@cells[x][y].finishStep() for x in [0...@width] for y in [0...@height]

	stepUntilComplete: ->
		until @isFinished
			@step()

	draw: (context) ->
		@cells[x][y].draw context for y in [0...@height] for x in [0...@width]

$ ->
	$canvas = $("<canvas width=\"#{WIDTH}\" height=\"#{HEIGHT}\"></canvas>")
	$("body").append($canvas)
	context = $canvas[0].getContext "2d"

	context.fillStyle = "black"
	context.fillRect 0, 0, WIDTH, HEIGHT

	grid = new Grid
	grid.stepUntilComplete()
	grid.draw context
