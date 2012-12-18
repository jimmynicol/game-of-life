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


    track: {}


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

      window.track = @track

      @cells = @g.selectAll('rect')
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
          cell = d3.select(this)
          if cell.style('fill') == cell.attr('fill-dead')
            cell.style 'fill', cell.attr('fill-alive')
            cell.attr 'alive', true
            track["#{row}##{i}"] = cell
          else
            cell.style 'fill', cell.attr('fill-dead')
            cell.attr 'alive', false
            delete track["#{row}##{i}"]
        )
        .style('fill', @options.colors.cell.dead)
        .attr('row', (d,i,row) ->
          row
        )
        .attr('cell', (d,i,row) ->
          i
        )