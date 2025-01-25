import { application } from "./application";

// Vite または esbuild 用に glob を使用してすべてのコントローラーを登録
const controllers = import.meta.glob("./**/*_controller.js");

for (const path in controllers) {
  controllers[path]().then((module) => {
    const controllerName = path
      .replace("./", "")
      .replace("_controller.js", "")
      .replace(/\//g, "--");
    application.register(controllerName, module.default);
  });
}