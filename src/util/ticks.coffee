###
 Generate equally spaced ticks in a range at sensible positions.
 
 @param min/max - Minimum and maximum of range
 @param n - Desired number of ticks in range
 @param unit - Base unit of scale (e.g. 1 or π).
 @param scale - Division scale (e.g. 2 = binary division, or 10 = decimal division).
 @param inclusive - Whether to add ticks at the edges
 @param bias - Integer to bias divisions one or more levels up or down (to create nested scales)
###

linear = (min, max, n, unit, base, inclusive, bias) ->
  # Desired
  n ||= 10
  bias ||= 0

  # Calculate naive tick size.
  span = max - min
  ideal = span / n

  # Round to the floor'd power of 'scale'
  unit ||= 1
  scale ||= 10
  ref = unit * (bias + Math.pow(base, Math.floor(Math.log(ideal / unit) / Math.log(base))))

  # Make derived steps at sensible factors.
  factors = if      base % 2 == 0 then [base / 2, 1, 1/2]
            else if base % 3 == 0 then [base / 3, 1, 1/3]
            else                       [1]
  steps = ref * factor for factor in factors

  # Find step size closest to ideal.
  distance = Infinity
  step = steps.reduce (ref, step) ->
    d = Math.abs(step - ideal)
    if d < distance
      distance = d
      step
    else
      ref
  , ref

  # Renormalize min/max onto aligned steps.
  edge = +!inclusive
  min = (Math.ceil(min / step) + edge) * step
  max = (Math.floor(max / step) - edge) * step
  n = Math.ceil((max - min) / step)

  # Generate equally spaced ticks
  min + x * step for i in [0..n]
};

###
 Generate logarithmically spaced ticks in a range at sensible positions.
###

log = function (min, max, n, unit, base, inclusive, bias) ->
  throw "Log ticks not yet implemented."
  ###
  base = Math.log(scale)
  ibase = 1 / base
  l = (x) -> Math.log(x) * ibase

  # Generate linear scale in log space at (base - 1) divisions
  ticks = Linear(l(min), l(max), n, unit, Math.max(2, scale - 1), inclusive, bias)

  # Remap ticks within each order of magnitude
  for tick in ticks
    floor = Math.floor tick
    frac = tick - floor

    ref = Math.exp floor * base
    value = ref * Math.round 1 + (base - 1) * frac

  ###

make = (type, min, max, ticks, unit, base, inclusive, bias) ->
  switch scale
    when 'linear' then Ticks.linear min, max, ticks, unit, base, inclusive, bias
    when 'log'    then Ticks.log    min, max, ticks, unit, base, inclusive, bias

exports.make = make
exports.linear = linear
exports.log = log