import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["map"];
  static values = {
    apiKey: String,
    bars: Array,
    center: Object,
  };

  connect() {
    if (this.debug) console.log("🗺️ Google Maps controller connected");
    this.loadGoogleMapsAPI();
  }

  get debug() {
    return document.body.dataset.railsEnv === "development";
  }

  loadGoogleMapsAPI() {
    if (typeof google !== "undefined" && typeof google.maps !== "undefined") {
      this.initializeMap();
      return;
    }

    const script = document.createElement("script");
    script.src = `https://maps.googleapis.com/maps/api/js?key=${this.apiKeyValue}&callback=initGoogleMap&libraries=places&loading=async`;
    script.async = true;
    script.defer = true;
    window.initGoogleMap = this.initializeMap.bind(this);
    script.onerror = () =>
      this.showError("Google Maps APIの読み込みに失敗しました");
    document.head.appendChild(script);
  }

  initializeMap() {
    if (!this.apiKeyValue)
      return this.showError("Google Maps API Keyが設定されていません");
    if (!this.barsValue || this.barsValue.length === 0)
      return this.showError("表示するバーデータがありません");

    try {
      const defaultCenter = this.centerValue.lat
        ? this.centerValue
        : { lat: 35.6812, lng: 139.7671 };
      this.map = new google.maps.Map(this.mapTarget, {
        zoom: 12,
        center: defaultCenter,
        styles: this.getMapStyles(),
        mapTypeControl: false,
        streetViewControl: false,
        fullscreenControl: true,
        zoomControl: true,
      });

      this.addMarkers();
      this.fitMapToBounds();
      if (this.debug) console.log("✅ マップ初期化完了");
      setTimeout(() => {
        const infoWindowContent = this.element.querySelector(".gm-style-iw-ch");
        if (infoWindowContent) {
          infoWindowContent.style.padding = "0";
          if (this.debug)
            console.log("🎨 Force overriding InfoWindow padding!");
        }
      }, 500);
    } catch (error) {
      console.error("❌ マップ初期化エラー:", error);
      this.showError("マップの初期化に失敗しました");
    }
  }

  addMarkers() {
    this.markers = [];
    this.infoWindows = [];
    this.barsValue.forEach((bar) => {
      if (!bar.latitude || !bar.longitude) return;

      const marker = new google.maps.Marker({
        position: {
          lat: parseFloat(bar.latitude),
          lng: parseFloat(bar.longitude),
        },
        map: this.map,
        title: bar.name,
        icon: this.getCustomMarkerIcon(),
        animation: google.maps.Animation.DROP,
      });

      const infoWindow = new google.maps.InfoWindow({
        content: this.createInfoWindowHtml(bar),
        maxWidth: 250,
      });

      marker.addListener("click", () => {
        this.infoWindows.forEach((iw) => iw.close());
        infoWindow.open({ anchor: marker, map: this.map });
        setTimeout(() => {
          const iwContent = document.querySelector(".gm-style-iw-ch");
          if (iwContent) {
            iwContent.style.setProperty("padding", "0", "important");
            iwContent.style.setProperty("padding-top", "0", "important");
            iwContent.style.setProperty("height", "0", "important");
          }

          const closeButton = document.querySelector(
            ".gm-style-iw button.gm-ui-hover-effect"
          );
          if (closeButton) {
            closeButton.style.setProperty("width", "30px", "important");
            closeButton.style.setProperty("height", "30px", "important");

            const closeIcon = closeButton.querySelector("span");
            if (closeIcon) {
              closeIcon.style.setProperty("width", "18px", "important");
              closeIcon.style.setProperty("height", "18px", "important");
              closeIcon.style.setProperty("margin", "7px", "important");
            }

            if (this.debug) console.log("🎨 Close button resized!");
          }
        }, 100);

        marker.setAnimation(google.maps.Animation.BOUNCE);
        setTimeout(() => marker.setAnimation(null), 1500);
      });

      this.markers.push(marker);
      this.infoWindows.push(infoWindow);
    });
  }

  // 確実に動作することを優先して、暫定的にHTMLを直接生成する方法を利用
  createInfoWindowHtml(bar) {
    const createInfoRow = (icon, text) => {
      if (!text) return "";
      return `
        <div style="display: flex; align-items: flex-start; gap: 8px; font-size: 13px; color: #4b5563;">
          <div style="width: 16px; height: 16px; flex-shrink: 0;">${icon}</div>
          <span style="flex: 1;">${text}</span>
        </div>`;
    };

    const priceIcon = "💰";
    const addressIcon = `<svg fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M5.05 4.05a7 7 0 119.9 9.9L10 18.9l-4.95-4.95a7 7 0 010-9.9zM10 11a2 2 0 100-4 2 2 0 000 4z" clip-rule="evenodd"></path></svg>`;
    const timeIcon = `<svg fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-12a1 1 0 10-2 0v4a1 1 0 00.293.707l2.828 2.829a1 1 0 101.415-1.415L11 9.586V6z" clip-rule="evenodd"></path></svg>`;
    const smokingIcon = `<svg fill="currentColor" viewBox="0 0 20 20"><path d="M10 2a1 1 0 00-1 1v1a1 1 0 002 0V3a1 1 0 00-1-1zM3.293 4.707a1 1 0 00-1.414 1.414L3.586 7.83a1 1 0 001.414-1.414L3.293 4.707zM15.293 4.707a1 1 0 00-1.414-1.414L12.17 7.83a1 1 0 101.414 1.414l1.707-1.707zM10 16a6 6 0 100-12 6 6 0 000 12z" /><path d="M11.415 11.414a1 1 0 01.172.036l3.396 1.132A1 1 0 0114 13.5v1a1 1 0 01-1 1H7a1 1 0 01-1-1v-1a1 1 0 01.98-.996l3.396-1.132a1 1 0 01.039-.004h.001z" /></svg>`;

    return `
      <div style="font-family: 'Inter', sans-serif; background: white; border-radius: 8px; overflow: hidden;">
        <div style="display: flex; background: #1a2b3c; color: white; padding: 10px 10px 8px 10px; border-radius: 6px; ">
          <h3 style="flex: 1; min-width: 0; font-size: 16px; font-weight: 700; margin: 0; line-height: 1.3; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
            ${bar.name}
          </h3>
        </div>
        <div style="padding: 12px 4px; display: flex; flex-direction: column; gap: 8px;">
          ${createInfoRow(priceIcon, bar.price_range)}
          ${createInfoRow(addressIcon, bar.address)}
          ${createInfoRow(timeIcon, bar.business_hours)}
          ${createInfoRow(smokingIcon, bar.smoking_status)}
        </div>
        <div style="padding: 0; display: flex; gap: 8px; align-items: center;">
          <a href="/bars/${
            bar.id
          }" style="flex: 1; background: linear-gradient(135deg, #1a2b3c 0%, #722f37 100%); color: white; text-decoration: none; padding: 8px 12px; border-radius: 6px; font-size: 13px; font-weight: 600; text-align: center;">詳細を見る</a>
          <button style="flex-shrink: 0; padding: 8px; background: white; border: 1px solid #e5e7eb; border-radius: 6px; color: #6b7280; cursor: pointer; width: 36px; height: 36px; display: flex; align-items: center; justify-content: center;">
            <svg style="width: 16px; height: 16px;" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z" clip-rule="evenodd"></path></svg>
          </button>
        </div>
      </div>
    `;
  }

  getCustomMarkerIcon() {
    return {
      path: google.maps.SymbolPath.CIRCLE,
      fillColor: "#1a2b3c",
      fillOpacity: 0.9,
      strokeColor: "#FFFFFF",
      strokeWeight: 2,
      scale: 8,
    };
  }

  fitMapToBounds() {
    if (this.markers.length === 0) return;
    const bounds = new google.maps.LatLngBounds();
    this.markers.forEach((marker) => bounds.extend(marker.getPosition()));
    this.map.fitBounds(bounds);

    if (this.markers.length === 1) {
      google.maps.event.addListenerOnce(this.map, "bounds_changed", () => {
        this.map.setZoom(15);
      });
    }
  }

  getMapStyles() {
    return [];
  }

  showError(message) {
    this.element.innerHTML = `<div style="text-align: center; padding: 20px;">${message}</div>`;
  }

  resizeMap() {
    if (this.map) {
      google.maps.event.trigger(this.map, "resize");
      this.fitMapToBounds();
    }
  }

  disconnect() {
    if (this.debug) console.log("❌ Google Maps controller disconnected");
    if (window.initGoogleMap) delete window.initGoogleMap;
  }
}
