if window.DeviceOrientationEvent
  window.addEventListener "deviceorientation", (evt) ->
    log "#{evt.alpha} - #{evt.beta} - #{evt.gamma}"
