width = 800
height = 500
padding = 40
r = 4
number = 100
curPoint = new ReactiveVar(null)

xScale = d3.scale.linear()
  .domain([0, width])
  .range([padding, width-padding*2])

yScale = d3.scale.linear()
  .domain([0, height])
  .range([height-padding, padding])

randomData = (num=number) ->
  [0...num].map -> [Math.floor(Math.random()*width), Math.floor(Math.random()*height)]

Template.scatterplot.rendered = ->
  xAxis = d3.svg.axis()
    .scale(xScale)
    .orient('bottom')

  yAxis = d3.svg.axis()
    .scale(yScale)
    .orient('left')

  svg = d3.select('article')
    .append('svg')
    .attr('width', width)
    .attr('height', height)

  svg.append('g')
    .attr('class', 'axis')
    .attr('transform', "translate(0, #{height-padding})")
    .call(xAxis)

  svg.append('g')
    .attr('class', 'axis')
    .attr('transform', "translate(#{padding}, 0)")
    .call(yAxis)

  svg.selectAll('circle')
    .data(randomData)
    .enter()
    .append('circle')
    .attr('class', 'plot')
    .attr('cx', (d) -> xScale(d[0]) )
    .attr('cy', (d) -> yScale(d[1]) )
    .attr('r', r)
    .attr('fill', 'green')
    .on('mouseover', (d) ->
      curPoint.set(d)
      pos = $('svg').position()
      left = pos.left + parseFloat(d3.select(@).attr('cx')) + r
      top = pos.top + parseFloat(d3.select(@).attr('cy')) + r
      d3.select('#tooltip')
        .classed('hidden', false)
        .style('left', left + 'px')
        .style('top', top + 'px')
      d3.select(@)
        .attr('r', r*2) )
    .on('mouseout', (d) ->
      curPoint.set(null)
      d3.select('#tooltip').classed('hidden', true)
      d3.select(@)
        .attr('r', r) )


Template.scatterplot.events =
  'click button': ->
    d3.select('svg').selectAll('circle')
      .data(randomData)
      .transition()
      .duration(1000)
      .attr('cx', (d) -> xScale(d[0]) )
      .attr('cy', (d) -> yScale(d[1]) )

Template.scatterplot.helpers(
  curX: ->
    curPoint.get()[0] if curPoint.get()
  curY: ->
    curPoint.get()[1] if curPoint.get()
)

