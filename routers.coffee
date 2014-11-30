Router.configure
  layoutTemplate: 'layout'

Router.route '/', ->
  @render 'index'

Router.route '/scatterplot', ->
  @render 'scatterplot'
