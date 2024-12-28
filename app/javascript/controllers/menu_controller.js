import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"];

  connect() {
    console.log("MenuController connected!");
  }

  toggle() {
    console.log("Toggle triggered");
    this.menuTarget.classList.toggle("active");
  }
}
