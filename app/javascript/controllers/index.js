import { Application } from "@hotwired/stimulus";
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";

// Stimulus の初期化
const application = Application.start();

// コントローラーを自動登録
eagerLoadControllersFrom("controllers", application);