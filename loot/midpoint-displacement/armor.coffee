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

	drawArmor = (centerX, centerY, armor) ->
		context.fillStyle = armor.color
		context.beginPath()

		[lastX, lastY] = armor.vertices[armor.vertices.length - 1]
		context.moveTo centerX + lastX, centerY + lastY

		for [x, y] in armor.vertices
			context.lineTo centerX + x, centerY + y

		context.fill()

	armor = {
		color: randomArmorColor()
		vertices: [
			# top
			[-25, -50],
			[25, -50],

			# chest
			[40, -15],
			[30, 25],
			[35, 100],

			# bottom
			[0, 75],
			[-40, 85],

			# back
			[-30, 40],
			[-40, -25]
		]
	}
	drawArmor 300, 200, armor
