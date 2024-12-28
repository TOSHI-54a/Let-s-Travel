import { Application } from "@hotwired/stimulus";
import "@hotwired/turbo";
import MenuController from "./controllers/menu_controller";
import "bootstrap";

const application = Application.start();
application.register("menu", MenuController);

// Configure Stimulus development experience
application.debug = true;
window.Stimulus   = application;
console.log("Stimulus initialized!");

document.addEventListener("DOMContentLoaded", () => {
    const body = document.querySelector("body");
    if (body) {
        body.style.backgroundColor = "lightblue";
        console.log("application.js has changed the background color!");
    }
});

export { application };
