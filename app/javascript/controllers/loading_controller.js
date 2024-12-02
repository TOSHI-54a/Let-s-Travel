import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="loading"
export default class extends Controller {
  static targets = ["overlay"];

  show() {
    if (this.hasOverlayTarget) {
      this.overlayTarget.style.display = "flex";
    }
  }
}
