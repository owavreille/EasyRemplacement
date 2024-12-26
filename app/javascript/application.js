import 'jquery'
import 'jquery_ujs'
import 'popper'
import 'bootstrap'
import '@hotwired/turbo-rails'
import 'controllers'
import "custom/trix"

document.addEventListener('turbo:load', function() {
  // Initialisation des dropdowns Bootstrap
  var dropdownElementList = [].slice.call(document.querySelectorAll('[data-bs-toggle="dropdown"]'))
  var dropdownList = dropdownElementList.map(function (dropdownToggleEl) {
    return new bootstrap.Dropdown(dropdownToggleEl)
  })

  // Initialisation des tooltips Bootstrap
  var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
  var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl)
  })
})
