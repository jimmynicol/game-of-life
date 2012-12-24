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
          self.toggleCell d3.select(@)
        )
        .style('fill', @options.colors.cell.dead)
        .attr('row', (d,i,row) ->
          row
        )
        .attr('cell', (d,i,row) ->
          i
        )


    toggleCell: (cell) ->
      if cell.style('fill') == cell.attr('fill-dead')
        cell.style 'fill', cell.attr('fill-alive')
        cell.attr 'alive', true
      else
        cell.style 'fill', cell.attr('fill-dead')
        cell.attr 'alive', false


    cellMatrix: ->
      matrix = []
      for row in @svg.selectAll('g').selectAll('rect')
        row_arr = []
        for cell in row
          row_arr.push(d3.select(cell).attr('alive') is 'true')
        matrix.push row_arr
      matrix


    renderGeneration: (future, current) ->
      current = current or cellMatrix

      for row, ri in future
        for fate, ci in row
          unless future[ri][ci] is current[ri][ci]
            @toggleCell d3.select("rect[row=#{ri}]:eq(#{ci})")