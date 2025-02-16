document.addEventListener("DOMContentLoaded", setupMenu);
document.addEventListener("turbo:load", setupMenu);

function setupMenu() {
  console.log("✅ メニューセットアップ");

  const menuButton = document.getElementById("menu-button");
  const menu = document.getElementById("menu");

  if (!menuButton || !menu) {
    console.warn("⚠️ menuButton または menu が見つかりません");
    return;
  }

  // 既存のリスナーを削除（重複防止）
  menuButton.removeEventListener("click", toggleMenu);
  menuButton.addEventListener("click", toggleMenu);

  function toggleMenu() {
    console.log("📌 メニュー開閉");
    menu.classList.toggle("hidden");
  }
}
