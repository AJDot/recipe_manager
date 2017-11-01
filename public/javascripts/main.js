document.addEventListener("DOMContentLoaded", function() {
  function toggleClassEvent(eventType, parent, childTagName, className) {
    parent.addEventListener(eventType, function(e) {
      if (e.target.tagName === childTagName.toUpperCase()) {
        e.target.classList.toggle(className);
      }
    });
  }
  var steps = document.querySelector(".steps");
  var ingredients = document.querySelector(".ingredients");

  [steps, ingredients].forEach(function(parent) {
    toggleClassEvent("click", parent, "li", "strike-through");
  });
});
