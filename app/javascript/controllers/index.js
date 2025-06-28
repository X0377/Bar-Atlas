// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application";
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";
eagerLoadControllersFrom("controllers", application);

import ViewToggleController from "./view_toggle_controller";
import GoogleMapsController from "./google_maps_controller";

application.register("view-toggle", ViewToggleController);
application.register("google-maps", GoogleMapsController);

console.log(
  "🎮 Stimulus controllers loaded:",
  application.router.modulesByIdentifier.keys
);
