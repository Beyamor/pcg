class Canvas
	constructor: (id) ->
		@el		= $('#' + id)
		@context	= @el[0].getContext("2d")
		@clearColor	= "#202638"

		@el.resize ->
			@resetWidth()
			@resetHeight()
		@resetWidth()
		@resetHeight()

	resetWidth: ->
		@context.canvas.width = @width = @el.width()
	
	resetHeight: ->
		@context.canvas.height = @height = @el.height()

	drawRect: ({x: x, y: y, width: width, height: height, rotation: rotation, color: color, centered: centered}) ->
		@context.save()
		@context.translate(x, y)
		@context.rotate(rotation) if rotation
		@context.translate(-width/2, -height/2) if centered
		@context.fillStyle = color
		@context.fillRect(0, 0, width, height)
		@context.restore()

	clear: ->
		@drawRect({x: 0, y: 0, width: @width, height: @height, color: @clearColor})

window.Canvas = Canvas
