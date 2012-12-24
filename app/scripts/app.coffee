includes = [
  'grid',
  'generation'
]

define includes, (Grid, Generation) ->

  grid = new Grid()

  console.log "Rows: #{grid.rows} - Columns: #{grid.columns}"

  window.generation = new Generation(grid)

  "App initialized!"