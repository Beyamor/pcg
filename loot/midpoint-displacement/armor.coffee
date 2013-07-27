window.onload = ->
	canvas = document.getElementById "canvas"
	context = canvas.getContext "2d"
	
	random = {
		inRange: (min, max) -> min + Math.random() * (max - min)
	}

	randomArmorColor = ->
		baseR = 75
		baseG = 74
		baseB = 77

		baseScale = 0.5
		randomScale = 0.5

		randomR = random.inRange(0, 255)
		randomG = random.inRange(0, 255)
		randomB = random.inRange(0, 255)

		r = Math.floor(baseR * baseScale + randomR * randomScale)
		g = Math.floor(baseG * baseScale + randomG * randomScale)
		b = Math.floor(baseB * baseScale + randomB * randomScale)

		return "rgb(#{r}, #{g}, #{b})"

	displaceMidpoints = (h, vertices) ->
		vertexPairs = []
		for i in [0...vertices.length]
			vertexPairs.push [vertices[i], vertices[(i+1) % vertices.length]]

		newVertices = []
		for [v1, v2] in vertexPairs
			newVertices.push v1

			[x1, y1] = v1
			[x2, y2] = v2

			x = (x1 + x2) / 2 + random.inRange(-h, h)
			y = (y1 + y2) / 2 + random.inRange(-h, h)

			newVertices.push [x, y]

		return newVertices

	transformArmor = (armor) ->
		armor.vertices = displaceMidpoints 5, armor.vertices

		return armor

	drawArmor = (centerX, centerY, armor) ->
		context.fillStyle = armor.color
		context.styokeStyle = "black"

		context.beginPath()

		[lastX, lastY] = armor.vertices[armor.vertices.length - 1]
		context.moveTo centerX + lastX, centerY + lastY

		for [x, y] in armor.vertices
			context.lineTo centerX + x, centerY + y

		context.fill()
		context.stroke()

	armor = {
		color: randomArmorColor()
		vertices: [
			# top
			[-25, -50],
			[25, -50],

			# chest
			[40, -30],
			[40, 0],
			[30, 45],
			[35, 100],

			# bottom
			[0, 75],
			[-40, 85],

			# back
			[-30, 30],
			[-35, -10],
			[-35, -25]
		]
	}

	transformArmor armor

	drawArmor 300, 200, armor
