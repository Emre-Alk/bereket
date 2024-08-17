# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "chart.js", to: "https://ga.jspm.io/npm:chart.js@4.4.3/dist/chart.js" # @4.4.3
pin "@kurkle/color", to: "https://ga.jspm.io/npm:@kurkle/color@0.3.2/dist/color.esm.js" # "@kurkle--color.js" @0.3.2
# pin "html5-qrcode", to: "https://unpkg.com/html5-qrcode@2.3.7/html5-qrcode.min.js" # @2.3.7
pin "signature_pad", to: "https://cdn.jsdelivr.net/npm/signature_pad@5.0.2/+esm"
