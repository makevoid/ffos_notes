var body, current_time, doc, dom, editor, log, main, page, resize_app, size_textarea, store;

store = localStorage;

dom = {};

page = {};

editor = {
  notes: [],
  textarea: null
};

doc = {
  width: function() {
    return document.width || window.innerWidth;
  },
  height: function() {
    return document.height || window.innerHeight;
  }
};

body = null;

main = function() {
  var mq, note;

  log("initializing..");
  editor.textarea = dom.element("textarea");
  if (store.note_1) {
    note = JSON.parse(store.note_1);
    editor.textarea.value = note.text;
  }
  body = dom.element("body");
  window.addEventListener("resize", function() {
    return resize_app();
  });
  mq = window.matchMedia("(orientation: portrait)");
  mq.addListener(function(m) {
    return resize_app();
  });
  resize_app();
  return log("done");
};

resize_app = function() {
  var max_size, min_size, size;

  body = dom.element("body");
  size = doc.width() / 700;
  max_size = 1.7;
  min_size = 0.9;
  size = Math.min(size, max_size);
  size = Math.max(size, min_size);
  body.style.fontSize = "" + size + "em";
  return size_textarea();
};

size_textarea = function() {
  var height;

  height = doc.height() / 3 + 100;
  return editor.textarea.style.height = "" + height + "px";
};

current_time = function() {
  return new Date().getTime();
};

log = function(string) {
  var logs;

  logs = dom.element(".logs");
  return logs.innerHTML = "<p>" + logs.innerHTML + string + "</p>";
};

dom.element = function(tag_name) {
  return document.querySelector(tag_name);
};

page.refresh = function() {
  return document.location = "/index.html";
};

editor.save = function() {
  var note;

  store.notes = 1;
  note = {
    text: this.textarea.value,
    time: current_time()
  };
  store.note_1 = JSON.stringify(note);
  return log("saved");
};

editor.load = function() {
  var _this = this;

  $.getJSON("/load", function(data) {
    if (data.note) {
      _this.textarea.value = data.note;
    }
    return log("loaded");
  });
  return log("loading");
};

editor.sync = function() {
  var note;

  note = {
    text: store.note_1,
    time: store.timestamp_1
  };
  $.post("/store", note, function(data) {
    console.log("stored:", data);
    return log("sync done");
  });
  return log("sync started");
};

document.addEventListener("DOMContentLoaded", main, false);
