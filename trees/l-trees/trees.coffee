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

	canvas = new Canvas 'canvas'
	canvas.clearColor = 'white'

	turtle = new Turtle canvas
	turtle.draw (instruction for instruction in "FFF-FF-F-F+F+FF-F-FFF")
