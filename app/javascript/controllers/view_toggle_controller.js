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

    this.forceInitialState();

    const savedView = this.getSavedViewPreference();
    console.log("📋 Saved view preference:", savedView);

    setTimeout(() => {
      this.toggleView(savedView);
    }, 100);

    this.updateSortSelect();
  }

  forceInitialState() {
    console.log("🔄 Forcing initial state");

    if (this.hasListViewTarget) {
      this.listViewTarget.classList.remove("view-hidden");
      this.listViewTarget.classList.add("view-visible");
      this.listViewTarget.classList.remove("hidden");
      this.listViewTarget.style.display = "block";
    }

    if (this.hasMapViewTarget) {
      this.mapViewTarget.classList.add("view-hidden");
      this.mapViewTarget.classList.remove("view-visible");
      this.mapViewTarget.classList.add("hidden");
      this.mapViewTarget.style.display = "none";
    }

    if (this.hasListButtonTarget) {
      this.listButtonTarget.classList.add("active");
    }

    if (this.hasMapButtonTarget) {
      this.mapButtonTarget.classList.remove("active");
    }

    // ページネーション初期表示（リストビュー用）
    if (this.hasListPaginationTarget) {
      this.listPaginationTarget.classList.remove("hidden");
      this.listPaginationTarget.style.display = "block";
    }

    console.log("✅ Initial state forced");
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

  toggleView(viewType = null) {
    const view = viewType || this.currentViewValue || "list";
    console.log("🔄 Toggling to view:", view);

    if (view === "map") {
      this.showMapView();
    } else {
      this.showListView();
    }

    this.currentViewValue = view;
    this.saveViewPreference(view);
  }

  showListView() {
    console.log("📋 Showing list view");

    if (this.hasListViewTarget) {
      this.listViewTarget.classList.remove("view-hidden", "hidden");
      this.listViewTarget.classList.add("view-visible", "view-transition");
      this.listViewTarget.style.display = "block";
      console.log("✅ List view shown");
    }

    if (this.hasMapViewTarget) {
      this.mapViewTarget.classList.add("view-hidden", "hidden");
      this.mapViewTarget.classList.remove("view-visible");
      this.mapViewTarget.style.display = "none";
      console.log("✅ Map view hidden");
    }

    if (this.hasListButtonTarget) {
      this.listButtonTarget.classList.add("active");
    }

    if (this.hasMapButtonTarget) {
      this.mapButtonTarget.classList.remove("active");
    }

    // ページネーション表示（リストビューのみ）
    if (this.hasListPaginationTarget) {
      this.listPaginationTarget.classList.remove("hidden");
      this.listPaginationTarget.style.display = "block";
      console.log("✅ Pagination shown for list view");
    }
  }

  showMapView() {
    console.log("🗺️ Showing map view");

    if (this.hasMapViewTarget) {
      this.mapViewTarget.classList.remove("view-hidden", "hidden");
      this.mapViewTarget.classList.add("view-visible", "view-transition");
      this.mapViewTarget.style.display = "block";
      console.log("✅ Map view shown");
    }

    if (this.hasListViewTarget) {
      this.listViewTarget.classList.add("view-hidden", "hidden");
      this.listViewTarget.classList.remove("view-visible");
      this.listViewTarget.style.display = "none";
      console.log("✅ List view hidden");
    }

    if (this.hasMapButtonTarget) {
      this.mapButtonTarget.classList.add("active");
    }

    if (this.hasListButtonTarget) {
      this.listButtonTarget.classList.remove("active");
    }

    // ページネーション非表示（マップビューでは不要）
    if (this.hasListPaginationTarget) {
      this.listPaginationTarget.classList.add("hidden");
      this.listPaginationTarget.style.display = "none";
      console.log("✅ Pagination hidden for map view");
    }

    this.resizeMap();
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
    this.toggleView("list");
  }

  showMap() {
    console.log("🖱️ Map button clicked");
    this.toggleView("map");
  }

  handleSort(event) {
    const sortValue = event.target.value;
    console.log("🔄 Sort changed to:", sortValue);
    const url = new URL(window.location);
    url.searchParams.set("sort", sortValue);
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

  currentViewValueChanged() {
    console.log("🔄 Current view changed to:", this.currentViewValue);
  }

  disconnect() {
    console.log("❌ View toggle controller disconnected");
  }
}
