import { application } from "./application";

// 各コントローラーを手動でインポート
import HelloController from "./hello_controller";

// Stimulusにコントローラーを登録
application.register("hello", HelloController);

console.log("Stimulus controllers have been registered.");