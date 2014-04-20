Base         = require './base'
LineGeometry = require('../geometry').LineGeometry

class Line extends Base
  constructor: (gl, shaders, options) ->
    super gl, shaders

    uniforms = options.uniforms ? {}
    position = options.position
    clip     = options.clip

    @geometry = new LineGeometry
      samples: options.samples
      strips:  options.strips
      ribbons: options.ribbons
      anchor:  options.anchor

    factory = shaders.material()

    v = factory.vertex
    v.import position if position
    v.split()
    v  .call 'line.position', uniforms
    v.pass()
    v.call 'line.clip', uniforms, '_clip_' if clip
    v.call 'project.position', uniforms

    f = factory.fragment
    f.call 'style.clip', {}, '_clip_' if clip
    f.call 'style.color', uniforms

    @material = new THREE.ShaderMaterial factory.build
      side: THREE.DoubleSide
      defaultAttributeValues: null

    window.material = @material

    @object = new THREE.Mesh @geometry, @material
    @object.frustumCulled = false;
    @object.matrixAutoUpdate = false;

  dispose: () ->
    @geometry.dispose()
    @material.dispose()
    @object = @geometry = @material = null
    super

module.exports = Line