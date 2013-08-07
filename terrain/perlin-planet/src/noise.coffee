# yanking the perlin noise stuff from here: http://freespace.virgin.net/hugo.elias/models/m_perlin.htm
namespace "perl.noise", (ns) ->
	class ns.Noise
		constructor: (@seed) ->
			@seed or= Math.random() * 1000
			@values = {}

		valueAt: (x, y) ->
			# ugh todo less crap noise
			@values[x] = {} unless @values[x]
			@values[x][y] = Math.random() unless @values[x][y]
			return @values[x][y]

	class ns.Perlin2D
		constructor: (@persistence, @numberOfOctaves) ->
			@noise = new ns.Noise

		smoothedValueAt: (x, y) ->
			corners = @noise.valueAt(x-1, y-1) + @noise.valueAt(x+1, y-1) +
				@noise.valueAt(x-1, y+1) + @noise.valueAt(x+1, y+1)

			sides   = @noise.valueAt(x-1, y) + @noise.valueAt(x+1, y) +
				@noise.valueAt(x, y-1) + @noise.valueAt(x, y+1)

			center  =  @noise.valueAt(x, y) / 4

			return corners / 16 + sides / 8 + center

		interpolate: (a, b, x) ->
			ft = x * Math.PI
			f = (1 - Math.cos(ft)) * 0.5
			return a*(1-f) + b*f

		interpolatedNoise: (x, y) ->
			intX = Math.floor x
			fractionalX = x - intX
			intY = Math.floor y
			fractionalY = y - intY

			v1 = @smoothedValueAt intX, intY
			v2 = @smoothedValueAt intX + 1, intY
			v3 = @smoothedValueAt intX, intY + 1
			v4 = @smoothedValueAt intX + 1, intY + 1

			i1 = @interpolate v1, v2, fractionalX
			i2 = @interpolate v3, v4, fractionalX

			return @interpolate i1, i2, fractionalY

		valueAt: (x, y) ->
			total = 0
			max = 0

			for i in [0...@numberOfOctaves]
				frequency = Math.pow 2, i
				amplitude = Math.pow @persistence, i
				max += amplitude
				total += @interpolatedNoise(x*frequency, y*frequency) * amplitude

			return total / max
