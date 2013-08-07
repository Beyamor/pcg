$ ->
	canvas = new perl.canvas.Canvas "canvas"
	canvas.clearColor = "#08051A"
	canvas.clear()

	planet = new perl.planet.Planet canvas.width/2, canvas.height/2, 300
	planet.draw canvas
