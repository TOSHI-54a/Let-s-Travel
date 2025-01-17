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



export { application };
