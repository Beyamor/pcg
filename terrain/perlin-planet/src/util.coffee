# So we can define getters and setters
# yoink: https://gist.github.com/alexaivars/1599437
Function::define = (prop, desc) ->
	Object.defineProperty this.prototype, prop, desc

window.namespace = (ns, block) ->
	target = window
	target = (target[item] or= {}) for item in ns.split '.'
	block target

namespace 'perl.util', (ns) ->
	ns.random =
		inRange: (min, max) -> min + Math.random() * (max - min)

	class ns.Timer
		constructor: (periodInSeconds, @callback) ->
			@elapsed = 0
			@period = periodInSeconds * 1000
			@loops = false
			@isRunning = true

		stop: ->
			@isRunning = false
			return this

		restart: ->
			@elapsed = 0
			@isRunning = true
			return this

		update: ->
			@elapsed += jaws.game_loop.tick_duration if @isRunning
			if @elapsed >= @period
				@callback()
				if @loops
					@elapsed -= @period

	class ns.Oscillator
		constructor: (periodInSeconds, @oscillation) ->
			@oscillation or= (t) -> Math.sin(t * Math.PI * 0.5)
			@increasing = true
			@period = periodInSeconds * 1000
			@elapsed = 0
			@value = @oscillation(0)

		update: ->
			if @increasing
				@elapsed += jaws.game_loop.tick_duration
				if @elapsed >= @period
					@elapsed = @period
					@increasing = false
			else
				@elapsed -= jaws.game_loop.tick_duration
				if @elapsed <= 0
					@elapsed = 0
					@increasing = true

			t = @elapsed / @period
			@value = @oscillation(t)
