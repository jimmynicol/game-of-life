includes = [
  'grid',
  'generation'
]

define includes, (Grid, Generation) ->

  grid = new Grid()
  console.log grid

  generation = new Generation(grid)

  "App initialized!"