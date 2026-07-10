// Esbuild entry point (LIBAPPO1-108). Served from app/assets/builds/application.js.
import "@hotwired/turbo-rails"
import "chart.js/auto"
import "chartkick/chart.js"
import * as ActiveStorage from "@rails/activestorage"

import "./bootstrap_setup"
import "./controllers"

ActiveStorage.start()
