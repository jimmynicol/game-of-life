require.config
  shim:
    d3:
      exports: 'd3'

  paths:
    hm: 'vendor/hm'
    esprima: 'vendor/esprima'
    jquery: 'vendor/jquery.min'

require ['app'], (app) ->
  console.log app
