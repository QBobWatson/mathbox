Group = require('./group')
Range = require('../../util').Range

class View extends Group
  @traits: ['object', 'view']

  axis: (dimension) ->
    range = @_get('view.range')[dimension - 1]

  to: (vector) ->

module.exports = View