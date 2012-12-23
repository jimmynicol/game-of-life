define [], ->

  class Generation

    constructor: (@grid) ->


    # Determine the makeup of the next generation
    run: ->
      # get a matrix of the current generation, and initialize the future one
      @current = @grid.cellMatrix()
      @future  = {}

      # determine fate of every show cell
      for ri, row of @current
        for ci of row
          @cellFate ri, ci

      # take the new matrix and render the next generation
      @grid.renderGeneration @future, @current


    # Determine if the cell lives or dies
    cellFate: (row, cell) ->
      n = @neighbours row, cell

      # test for fate if cell is currently live
      if @current[row][cell] is true
        # rule 1. any live cell with fewer than two live neighbours dies, as
        # if caused by under-population.
        if n.live < 2
          fate = false

        # rule 2. any live cell with two or three live neighbours lives on to
        # the next generation.
        else if n.live in [2,3]
          fate = true

        # rule 3. any live cell with more than three live neighbours dies, as
        # if by overcrowding.
        else
          fate = false

      # try rule 4 on dead cells
      else
        # rule 4. any dead cell with exactly three live neighbours becomes a
        # live cell, as if by reproduction.
        fate = n.live is 3

      @future[row] = @future[row] or {}
      @future[row][cell] = fate


    # Get list of alive and dead the neighbours of this cell
    neighbours: (row, cell) ->
      n =
        live: 0
        dead: 0

      # get available rows
      rows = []
      rows.push(@current[row-1]) if @current[row-1]?
      rows.push @current[row]
      rows.push(@current[row+1]) if @current[row+1]?

      for r, ri in rows

        # get available cells
        cells = []
        cells.push r[cell-1] if r[cell-1]?
        cells.push r[cell]
        cells.push(r[cell+1]) if r[cell+1]?

        # build the hash excluding the cell being fated
        for c, ci in cells
          if c
            n.live++ unless ri is row and ci is cell
          else
            n.dead++ unless ri is row and ci is cell
      n


    # Any dead cell with exactly three live neighbours becomes a live cell,
    # as if by reproduction.
    ruleFour: (n) -> n.live
