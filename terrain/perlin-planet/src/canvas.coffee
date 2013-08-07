namespace "perl.canvas", (ns) ->
	class ns.Canvas
		constructor: (id) ->
			@el = $ "#{id}"
			@context = @el[0].getContext "2d"

		drawRect: ({x: x, y: y, width: width, height: height, color: color}) ->
			@context.beginPath()
			@context.rect x, y, width, height
			@context.fillStyle = color
			@context.fill()

		clear: ->
			@context.clearRect 0, 0, @width, @height

		@define "clearColor",
			set: (color) ->
				@el.css "background-color", color

		@define "width",
			get: -> @el.width()
			set: (w) ->
				@el.width(w)
				@context.canvas.width = w

		@define "height",
			get: -> @el.height()
			set: (h) ->
				@el.height(h)
				@context.canvas.height = h
