store = localStorage
dom = {}
page = {}
editor =
  notes: []
  textarea: null

doc =
  width:  -> document.width || window.innerWidth
  height: -> document.height || window.innerHeight

body = null

main = ->
  log "initializing.."
  editor.textarea = dom.element "textarea"
  if store.note_1
    note = JSON.parse store.note_1
    editor.textarea.value = note.text  
  body = dom.element("body")
  window.addEventListener "resize", ->
    resize_app()

  mq = window.matchMedia("(orientation: portrait)")
  mq.addListener (m) ->
    resize_app()

  resize_app()
  log "done"

resize_app = ->
  body = dom.element "body"
  size = doc.width() / 700
  max_size = 1.7
  min_size = 0.9
  size = Math.min size, max_size
  size = Math.max size, min_size
  body.style.fontSize = "#{size}em"
  size_textarea()

size_textarea = ->
  height = doc.height()/3 + 100 # header
  editor.textarea.style.height = "#{height}px"

current_time = ->
  new Date().getTime()

log = (string) ->
  logs = dom.element(".logs")
  logs.innerHTML = "<p>" + logs.innerHTML + string + "</p>"

dom.element = (tag_name) ->
  document.querySelector tag_name

page.refresh = ->
  document.location = "/index.html"

editor.save = ->
  store.notes = 1
  note = { text: @textarea.value, time: current_time() }
  store.note_1 = JSON.stringify note
  log "saved"

editor.load = ->
  $.getJSON "/load", (data) =>
    # data.time
    @textarea.value = data.note if data.note
    log "loaded"
  log "loading"

editor.sync = ->
  note = { text: store.note_1, time: store.timestamp_1 }
  $.post "/store", note, (data) ->
    console.log "stored:", data
    log "sync done"
  log "sync started"

document.addEventListener "DOMContentLoaded", main, false