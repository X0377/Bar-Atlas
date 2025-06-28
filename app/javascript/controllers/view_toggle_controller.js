import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "listView",
    "mapView",
    "listButton",
    "mapButton",
    "sortSelect",
    "listPagination",
  ];
  static values = {
    currentView: String,
  };

  connect() {
    console.log("🎯 View toggle controller connected");

    const urlView = this.getViewFromURL();
    const savedView = this.getSavedViewPreference();
    const initialView = urlView || savedView || "list";

    console.log("📋 URL view:", urlView);
    console.log("💾 Saved view preference:", savedView);
    console.log("🎯 Initial view:", initialView);

    this.setInitialState(initialView);
    this.currentViewValue = initialView;

    this.updateSortSelect();
    this.element.viewToggleController = this;
  }

  getViewFromURL() {
    const urlParams = new URLSearchParams(window.location.search);
    const viewParam = urlParams.get("view");
    return viewParam === "map" || viewParam === "list" ? viewParam : null;
  }

  setInitialState(targetView) {
    console.log("🔄 Setting initial state to:", targetView);

    this.hideAllViews();

    if (targetView === "map") {
      this.showMapViewInternal();
    } else {
      this.showListViewInternal();
    }

    console.log("✅ Initial state set to:", targetView);
  }

  hideAllViews() {
    if (this.hasListViewTarget) {
      this.listViewTarget.classList.add("view-hidden", "hidden");
      this.listViewTarget.classList.remove("view-visible");
      this.listViewTarget.style.display = "none";
    }

    if (this.hasMapViewTarget) {
      this.mapViewTarget.classList.add("view-hidden", "hidden");
      this.mapViewTarget.classList.remove("view-visible");
      this.mapViewTarget.style.display = "none";
    }

    if (this.hasListPaginationTarget) {
      this.listPaginationTarget.classList.add("hidden");
      this.listPaginationTarget.style.display = "none";
    }
  }

  get debug() {
    return document.body.dataset.railsEnv === "development";
  }

  getSavedViewPreference() {
    return localStorage.getItem("bar-atlas-preferred-view") || "list";
  }

  saveViewPreference(view) {
    localStorage.setItem("bar-atlas-preferred-view", view);
    console.log("💾 Saved preference:", view);
  }

  updateURL(view) {
    const url = new URL(window.location);
    url.searchParams.set("view", view);
    window.history.replaceState({}, "", url.toString());
    console.log("🔗 URL updated with view:", view);
  }

  toggleView(viewType = null) {
    const view = viewType || this.currentViewValue || "list";
    console.log("🔄 Toggling to view:", view);

    if (view === "map") {
      this.showMapViewInternal();
    } else {
      this.showListViewInternal();
    }

    this.currentViewValue = view;
    this.saveViewPreference(view);
    this.updateURL(view);
  }

  showListViewInternal() {
    console.log("📋 Showing list view (internal)");

    if (this.hasListViewTarget) {
      this.listViewTarget.classList.remove("view-hidden", "hidden");
      this.listViewTarget.classList.add("view-visible");
      this.listViewTarget.style.display = "block";
    }

    if (this.hasMapViewTarget) {
      this.mapViewTarget.classList.add("view-hidden", "hidden");
      this.mapViewTarget.classList.remove("view-visible");
      this.mapViewTarget.style.display = "none";
    }

    if (this.hasListButtonTarget) {
      this.listButtonTarget.classList.add("active");
    }

    if (this.hasMapButtonTarget) {
      this.mapButtonTarget.classList.remove("active");
    }

    if (this.hasListPaginationTarget) {
      this.listPaginationTarget.classList.remove("hidden");
      this.listPaginationTarget.style.display = "block";
    }

    // 🚀 ソートを表示
    this.showSortSelect();
  }

  showMapViewInternal() {
    console.log("🗺️ Showing map view (internal)");

    if (this.hasMapViewTarget) {
      this.mapViewTarget.classList.remove("view-hidden", "hidden");
      this.mapViewTarget.classList.add("view-visible");
      this.mapViewTarget.style.display = "block";
    }

    if (this.hasListViewTarget) {
      this.listViewTarget.classList.add("view-hidden", "hidden");
      this.listViewTarget.classList.remove("view-visible");
      this.listViewTarget.style.display = "none";
    }

    if (this.hasMapButtonTarget) {
      this.mapButtonTarget.classList.add("active");
    }

    if (this.hasListButtonTarget) {
      this.listButtonTarget.classList.remove("active");
    }

    if (this.hasListPaginationTarget) {
      this.listPaginationTarget.classList.add("hidden");
      this.listPaginationTarget.style.display = "none";
    }

    // 🚀 ソートを非表示
    this.hideSortSelect();

    this.resizeMap();
  }

  // 🚀 ソート表示制御メソッド修正（レイアウト保持のためvisibility使用）
  showSortSelect() {
    if (this.hasSortSelectTarget) {
      this.sortSelectTarget.style.visibility = "visible";
      this.sortSelectTarget.classList.remove("map-view-hidden");
      console.log("👁️ Sort select shown");
    }
  }

  hideSortSelect() {
    if (this.hasSortSelectTarget) {
      this.sortSelectTarget.style.visibility = "hidden";
      this.sortSelectTarget.classList.add("map-view-hidden");
      console.log("🙈 Sort select hidden");
    }
  }

  showListView() {
    console.log("📋 List view requested (external)");
    this.toggleView("list");
  }

  showMapView() {
    console.log("🗺️ Map view requested (external)");
    this.toggleView("map");
  }

  resizeMap() {
    setTimeout(() => {
      const mapController = document.querySelector(
        '[data-controller~="google-maps"]'
      );
      if (mapController && mapController.googleMapsController) {
        console.log("📐 Resizing map");
        mapController.googleMapsController.resizeMap();
      }
    }, 300);
  }

  showList() {
    console.log("🖱️ List button clicked");
    this.showListView();
  }

  showMap() {
    console.log("🖱️ Map button clicked");
    this.showMapView();
  }

  handleSort(event) {
    const sortValue = event.target.value;
    console.log("🔄 Sort changed to:", sortValue);

    const url = new URL(window.location);
    url.searchParams.set("sort", sortValue);
    url.searchParams.set("view", this.currentViewValue);

    window.location.href = url.toString();
  }

  showBarOnMap(event) {
    const barName = event.params.barName;
    console.log("🎯 Showing bar on map:", barName);

    this.toggleView("map");

    setTimeout(() => {
      const mapController = document.querySelector(
        '[data-controller~="google-maps"]'
      );
      if (mapController && mapController.googleMapsController) {
        mapController.googleMapsController.showBar(barName);
      }
    }, 500);
  }

  updateSortSelect() {
    if (!this.hasSortSelectTarget) return;

    const urlParams = new URLSearchParams(window.location.search);
    const currentSort = urlParams.get("sort");

    if (currentSort) {
      this.sortSelectTarget.value = currentSort;
    }
  }

  beforePageLeave() {
    this.saveViewPreference(this.currentViewValue);
    console.log("📤 Saved state before page leave:", this.currentViewValue);
  }

  getCurrentViewState() {
    return this.currentViewValue;
  }

  preserveViewOnFilter() {
    const currentView = this.currentViewValue;
    const url = new URL(window.location);
    url.searchParams.set("view", currentView);

    const form = document.getElementById("unified-search-form");
    if (form) {
      form.action = url.toString();
    }

    console.log("🔄 View state preserved for filtering:", currentView);
  }

  currentViewValueChanged() {
    console.log("🔄 Current view changed to:", this.currentViewValue);
  }

  disconnect() {
    console.log("❌ View toggle controller disconnected");
    this.beforePageLeave();
  }
}

window.addEventListener("beforeunload", () => {
  const viewToggleController = document.querySelector(
    '[data-controller*="view-toggle"]'
  );
  if (viewToggleController && viewToggleController.viewToggleController) {
    viewToggleController.viewToggleController.beforePageLeave();
  }
});

document.addEventListener("turbo:before-visit", () => {
  const viewToggleController = document.querySelector(
    '[data-controller*="view-toggle"]'
  );
  if (viewToggleController && viewToggleController.viewToggleController) {
    viewToggleController.viewToggleController.beforePageLeave();
  }
});
