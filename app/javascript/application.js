// Entry point for esbuild (LIBAPPO1-101). Sprockets still serves legacy JS until #12.
import "@hotwired/turbo-rails"
import Rails from "@rails/ujs"
import "bootstrap/dist/js/bootstrap.bundle"
import "chart.js/auto"

Rails.start()
