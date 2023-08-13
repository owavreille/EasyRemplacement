pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "trix"
pin "@rails/actiontext", to: "actiontext.js"
pin "jquery", to: "jquery.min.js"
pin "jquery_ujs", to: "jquery_ujs.js"
pin "popper", to: "popper.js"
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "chartkick", to: "chartkick.js"
pin "Chart.bundle", to: "Chart.bundle.js"
pin "chart"
pin "text"
pin_all_from "app/javascript/custom", under: "custom"
