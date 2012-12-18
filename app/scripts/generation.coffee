define [], ->

  class Generation

    constructor: (@grid) ->


    run: ->
      for cell in @grid.track



    neighbours: (cell) ->


    # Any live cell with fewer than two live neighbours dies, as if caused by
    # under-population.
    ruleOne: ->


    # Any live cell with two or three live neighbours lives on to the next
    # generation.
    ruleTwo: ->


    # Any live cell with more than three live neighbours dies, as if by
    # overcrowding.
    ruleThree: ->


    # Any dead cell with exactly three live neighbours becomes a live cell,
    # as if by reproduction.
    ruleFour: ->
