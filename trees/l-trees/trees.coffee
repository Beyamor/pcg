$ ->
	class Turtle
		constructor: (@canvas, @params) ->
			@state = {
				x: 0
				y: 0
				direction: -90
				previous: null
			}

		nextPos: ->
			directionInRadians = @state.direction * Math.PI / 180
			nextX = @state.x + Math.cos(directionInRadians) * @params.lineLength
			nextY = @state.y + Math.sin(directionInRadians) * @params.lineLength
			return [nextX, nextY]

		draw: (camera, instructions) ->
			@canvas.clear()

			while instructions.length > 0
				instruction = instructions.shift()

				switch instruction
					when 'F'
						[nextX, nextY] = @nextPos()
						canvas.drawLine(
							start: [@state.x - camera.x, @state.y - camera.y]
							end: [nextX - camera.x, nextY - camera.y]
							width: 2
						)
						@state.x = nextX
						@state.y = nextY

					when 'f'
						[nextX, nextY] = @nextPos()
						@state.x = nextX
						@state.y = nextY

					when '+'
						@state.direction -= @params.angleIncrement

					when '-'
						@state.direction += @params.angleIncrement

	parseAxiom = (axiomText) ->
		(symbol for symbol in axiomText)

	parseProductions = (productionsText) ->
		productions = {}
		for line in productionsText.split '\n'
			continue if line.indexOf('->') < 0

			[pred, succ] = line.split("->")
			pred = pred.trim()
			succ = (symbol for symbol in succ when symbol isnt " ")

			productions[pred] = succ
		return productions

	applyProductions = (axiom, productions, numberOfIterations) ->
		result = axiom
		for i in [0...numberOfIterations]
			previousResult = result
			result = []
			for symbol in previousResult
				if productions[symbol]?
					result = result.concat productions[symbol]
				else
					result = result.concat [symbol]

		return result


	canvas = new Canvas 'canvas'
	canvas.clearColor = 'white'

	camera = null
	resetCamera = ->
		camera = {x: -canvas.width/2, y: -canvas.height/2}
	resetCamera()

	instructions = null
	parseInstructions = ->
		axiom			= parseAxiom($('#axiom').val())
		productions		= parseProductions($('#productions').val())
		numberOfTransforms	= parseInt($('#number-of-transformations').val())
		instructions		= applyProductions(axiom, productions, numberOfTransforms)

	$('#go').click ->
		resetCamera()
		parseInstructions()

		params = {
			lineLength: Math.pow(10, $('#line-length').val())
			angleIncrement: parseInt($('#angle-increment').val())
		}

		turtle = new Turtle canvas, params
		turtle.draw(camera, instructions)
