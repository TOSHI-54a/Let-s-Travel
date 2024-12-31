import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu"];

  connect() {
    console.log("MenuController connected!");
    console.log(this.menuTarget.classList); // 初期状態を確認
  }

  toggle() {
    console.log("Toggle triggered");
    console.log(this.menuTarget.classList);
    this.menuTarget.classList.toggle("active");
  }
}
