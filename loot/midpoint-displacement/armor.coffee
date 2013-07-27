window.onload = ->
	canvas = document.getElementById "canvas"
	context = canvas.getContext "2d"
	
	random = {
		inRange: (min, max) -> min + Math.random() * (max - min)
		intInRange: (min, max) -> Math.floor(random.inRange(min, max))
		any: (xs) -> xs[random.intInRange(0, xs.length)]
		choose: (choices...) -> random.any choices
	}

	randomArmorColor = ->
		[baseR, baseG, baseB] = random.choose(
			[75, 74, 77],
			[21, 21, 23]
		)

		baseScale = 0.9
		randomScale = 1 - baseScale

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
		armor.torso = displaceMidpoints 5, armor.torso
		armor.shoulder = displaceMidpoints 5, armor.shoulder

		return armor

	drawVertices = (centerX, centerY, vertices) ->
		context.beginPath()

		[lastX, lastY] = vertices[vertices.length - 1]
		context.moveTo centerX + lastX, centerY + lastY

		for [x, y] in vertices
			context.lineTo centerX + x, centerY + y

		context.fill()
		context.stroke()

	drawArmor = (centerX, centerY, armor) ->
		context.fillStyle = armor.color
		context.styokeStyle = "black"
		context.lineWidth = 3

		drawVertices centerX, centerY, armor.torso
		drawVertices centerX, centerY, armor.shoulder
		
	
	torsoTemplate = -> [
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

	# smaller, probably too small
	#shoulderTemplate = -> [
	#	[-15, -40],
	#	[15, -40],
	#	[25, -20],
	#	[15, 10],
	#	[-15, 10],
	#	[-25, -20]
	#]
	
	shoulderTemplate = -> [
		[-5 + -20, -55],
		[-5 + 20, -55],
		[-5 + 30, -35],
		[-5 + 35, -20],
		[-5 + 20, 5],
		[-5 + -20, 5],
		[-5 + -35, -20]
		[-5 + -30, -35]
	]
	armor = {
		color: randomArmorColor()
		torso: torsoTemplate()
		shoulder: shoulderTemplate()
	}

	transformArmor armor
	drawArmor 300, 200, armor
