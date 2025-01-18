// Import and register all your controllers from the importmap via controllers/**/*_controller
import { Application } from "@hotwired/stimulus"
// Stimulus の初期化
const application = Application.start();

// コントローラーを自動登録
const context = require.context("./controllers", true, /\.js$/);
context.keys().forEach((key) => {
  const controllerName = key.replace("./", "").replace("_controller.js", "").replace(/\//g, "--");
  application.register(controllerName, context(key).default);
});