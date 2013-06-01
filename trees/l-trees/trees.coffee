$ ->
	class Turtle
		constructor: (@canvas) ->
			@state = {
				x: 400
				y: 300
				direction: -90
				previous: null
			}

		nextPos: ->
			directionInRadians = @state.direction * Math.PI / 180
			nextX = @state.x + Math.cos(directionInRadians) * 10
			nextY = @state.y + Math.sin(directionInRadians) * 10
			return [nextX, nextY]

		draw: (instructions) ->
			@canvas.clear()

			while instructions.length > 0
				instruction = instructions.shift()

				switch instruction
					when 'F'
						[nextX, nextY] = @nextPos()
						canvas.drawLine(
							start: [@state.x, @state.y]
							end: [nextX, nextY]
							width: 2
						)
						@state.x = nextX
						@state.y = nextY

					when '+'
						@state.direction -= 90

					when '-'
						@state.direction += 90

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

	$('#go').click ->
		axiom		= parseAxiom($('#axiom').val())
		productions	= parseProductions($('#productions').val())
		result		= applyProductions(axiom, productions, 2)

		turtle = new Turtle canvas
		turtle.draw (instruction for instruction in result)
