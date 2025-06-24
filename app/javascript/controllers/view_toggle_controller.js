// app/javascript/controllers/view_toggle_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "listView",
    "mapView",
    "listButton",
    "mapButton",
    "sortSelect",
  ];
  static values = {
    currentView: String,
    preferredView: String,
  };

  connect() {
    console.log("🎯 View toggle controller connected");

    // 強制的に初期状態をリセット
    this.forceInitialState();

    // Load preferred view from localStorage
    const savedView = localStorage.getItem("preferred-view") || "list";
    console.log("📋 Saved view preference:", savedView);

    this.preferredViewValue = savedView;

    // 少し遅延させて確実に適用
    setTimeout(() => {
      this.toggleView(savedView);
    }, 100);

    // Set sort select value if exists
    this.updateSortSelect();
  }

  forceInitialState() {
    console.log("🔄 Forcing initial state");

    // リスト表示を強制表示
    if (this.hasListViewTarget) {
      this.listViewTarget.classList.remove("hidden", "view-hidden");
      this.listViewTarget.classList.add("view-visible");
      this.listViewTarget.style.display = "block";
    }

    // 地図表示を強制非表示
    if (this.hasMapViewTarget) {
      this.mapViewTarget.classList.add("hidden", "view-hidden");
      this.mapViewTarget.classList.remove("view-visible");
      this.mapViewTarget.style.display = "none";
    }

    // ボタン状態をリセット
    if (this.hasListButtonTarget) {
      this.listButtonTarget.classList.add("active");
    }

    if (this.hasMapButtonTarget) {
      this.mapButtonTarget.classList.remove("active");
    }

    console.log("✅ Initial state forced");
  }

  get debug() {
    return document.body.dataset.railsEnv === "development";
  }

  // Toggle between list and map view
  toggleView(viewType = null) {
    const view = viewType || this.currentViewValue || "list";
    console.log("🔄 Toggling to view:", view);

    if (view === "map") {
      this.showMapView();
    } else {
      this.showListView();
    }

    this.currentViewValue = view;
    this.savePreference(view);
  }

  showListView() {
    console.log("📋 Showing list view");

    // 強制的にクラスを設定
    if (this.hasListViewTarget) {
      this.listViewTarget.classList.remove("hidden", "view-hidden");
      this.listViewTarget.classList.add("view-visible");
      this.listViewTarget.style.display = "block";
      console.log("✅ List view shown");
    }

    if (this.hasMapViewTarget) {
      this.mapViewTarget.classList.add("hidden", "view-hidden");
      this.mapViewTarget.classList.remove("view-visible");
      this.mapViewTarget.style.display = "none";
      console.log("✅ Map view hidden");
    }

    // Update button states
    if (this.hasListButtonTarget) {
      this.listButtonTarget.classList.add("active");
    }

    if (this.hasMapButtonTarget) {
      this.mapButtonTarget.classList.remove("active");
    }
  }

  showMapView() {
    console.log("🗺️ Showing map view");

    // 強制的にクラスを設定
    if (this.hasMapViewTarget) {
      this.mapViewTarget.classList.remove("hidden", "view-hidden");
      this.mapViewTarget.classList.add("view-visible");
      this.mapViewTarget.style.display = "block";
      console.log("✅ Map view shown");
    }

    if (this.hasListViewTarget) {
      this.listViewTarget.classList.add("hidden", "view-hidden");
      this.listViewTarget.classList.remove("view-visible");
      this.listViewTarget.style.display = "none";
      console.log("✅ List view hidden");
    }

    // Update button states
    if (this.hasMapButtonTarget) {
      this.mapButtonTarget.classList.add("active");
    }

    if (this.hasListButtonTarget) {
      this.listButtonTarget.classList.remove("active");
    }

    // Trigger map resize after transition
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
    }, 100);
  }

  // Action methods for button clicks
  showList() {
    console.log("🖱️ List button clicked");
    this.toggleView("list");
  }

  showMap() {
    console.log("🖱️ Map button clicked");
    this.toggleView("map");
  }

  // Handle sort change
  handleSort(event) {
    const sortValue = event.target.value;
    console.log("🔄 Sort changed to:", sortValue);
    const url = new URL(window.location);
    url.searchParams.set("sort", sortValue);
    window.location.href = url.toString();
  }

  // Show specific bar on map
  showBarOnMap(event) {
    const barName = event.params.barName;
    console.log("🎯 Showing bar on map:", barName);

    // Switch to map view first
    this.toggleView("map");

    // Wait for map to load, then show the bar
    setTimeout(() => {
      const mapController = document.querySelector(
        '[data-controller~="google-maps"]'
      );
      if (mapController && mapController.googleMapsController) {
        mapController.googleMapsController.showBar(barName);
      }
    }, 500);
  }

  // Save preference to localStorage
  savePreference(view) {
    localStorage.setItem("preferred-view", view);
    console.log("💾 Saved preference:", view);
  }

  // Update sort select value based on URL params
  updateSortSelect() {
    if (!this.hasSortSelectTarget) return;

    const urlParams = new URLSearchParams(window.location.search);
    const currentSort = urlParams.get("sort");

    if (currentSort) {
      this.sortSelectTarget.value = currentSort;
    }
  }

  // Handle Turbo navigation
  currentViewValueChanged() {
    console.log("🔄 Current view changed to:", this.currentViewValue);
  }

  disconnect() {
    console.log("❌ View toggle controller disconnected");
  }
}
