define [], ->

  class Grid

    defaultOptions: ->
      cell:
        width: 20
        height: 20
        radius: 0
      border: 0.5
      colors:
        cell:
          dead: '#f0f0f0'
          alive: d3.scale.category20c()


    constructor: (options) ->
      @options = $.extend @defaultOptions(), options
      @renderWorkspace()
      @determineRowsAndColumns()
      @renderCells()


    renderWorkspace: ->
      @svg = d3.select("body")
        .append("svg:svg")
        .attr("width", '100%')
        .attr("height", '100%')


    determineRowsAndColumns: ->
      @rows = Math.ceil(($ 'svg').height() / @options.cell.height)
      @columns = Math.ceil(($ 'svg').width() / @options.cell.width)


    renderCells: ->
      @g = @svg.selectAll('g')
        .data(d3.range(@rows))
        .enter()
        .append('svg:g')
        .attr('row', (d,i) ->
          i
        )

      self = @

      @g.selectAll('rect')
        .data(d3.range(@columns))
        .enter()
        .append('svg:rect')
        .attr('width', @options.cell.width)
        .attr('height', @options.cell.height)
        .attr('x', (d, i, row) =>
          @options.cell.width * i + @options.border * i
        )
        .attr('y', (d, i, row) =>
          @options.cell.height * row + @options.border * row
        )
        .attr('rx', @options.cell.radius)
        .attr('ry', @options.cell.radius)
        .attr('fill-dead', @options.colors.cell.dead)
        .attr('fill-alive', @options.colors.cell.alive)
        .on('click', (d, i, row) ->
          self.toggleCell @
        )
        .style('fill', @options.colors.cell.dead)
        .attr('row', (d,i,row) ->
          row
        )
        .attr('cell', (d,i,row) ->
          i
        )


    toggleCell: (cell) ->
      cell = d3.select cell

      if cell.style('fill') == cell.attr('fill-dead')
        cell.style 'fill', cell.attr('fill-alive')
        cell.attr 'alive', true
      else
        cell.style 'fill', cell.attr('fill-dead')
        cell.attr 'alive', false


    cellMatrix: ->
      matrix = {}
      for row, row_num in @svg.selectAll('g').selectAll('rect')
        for cell, cell_num in row
          matrix[row_num] = matrix[row_num] or {}
          matrix[row_num][cell_num] = d3.select(cell).attr('alive') is 'true'
      matrix


    renderGeneration: (future, current) ->
      current = current or cellMatrix

      console.log current
      console.log future

      for ri, row of future
        for ci of row
          unless future[ri][ci] is current[ri][ci]
            console.log 'toggle'
