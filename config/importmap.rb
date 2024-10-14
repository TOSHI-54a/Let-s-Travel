# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "jquery", to: "jquery.min.js"
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "bootstrap", to: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js", preload: true