// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
// app/javascript/application.js
import * as bootstrap from "bootstrap"
window.bootstrap = bootstrap // グローバルオブジェクト（window）に登録してどこからでも呼べるようにする
