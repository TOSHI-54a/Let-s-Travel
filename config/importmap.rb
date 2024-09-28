# Pin npm packages by running ./bin/importmap

pin "application"
pin "jquery", to: "jquery.min.js"
pin "bootstrap", to: "bootstrap.min.js", preload: true