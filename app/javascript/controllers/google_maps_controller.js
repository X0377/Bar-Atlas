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

    if (!this.apiKeyValue) {
      this.showError("Google Maps API Keyが設定されていません");
      return;
    }

    if (!this.barsValue || this.barsValue.length === 0) {
      this.showError("表示するバーデータがありません");
      return;
    }

    if (typeof google === "undefined") {
      this.loadGoogleMapsAPI();
    } else {
      this.initializeMap();
    }
  }

  get debug() {
    return document.body.dataset.railsEnv === "development";
  }

  loadGoogleMapsAPI() {
    const script = document.createElement("script");
    script.src = `https://maps.googleapis.com/maps/api/js?key=${this.apiKeyValue}&callback=initGoogleMap&libraries=places&loading=async`;
    script.async = true;
    script.defer = true;

    window.initGoogleMap = () => {
      this.initializeMap();
    };

    script.onerror = () => {
      this.showError("Google Maps APIの読み込みに失敗しました");
    };

    document.head.appendChild(script);
  }

  initializeMap() {
    try {
      const defaultCenter = this.centerValue || { lat: 35.6812, lng: 139.7671 };

      this.map = new google.maps.Map(this.mapTarget, {
        zoom: 12,
        center: defaultCenter,
        styles: this.getMapStyles(),
        mapTypeControl: false,
        streetViewControl: false,
        fullscreenControl: true,
        zoomControl: true,
        mapTypeId: "roadmap",
      });

      this.addMarkers();
      this.fitMapToBounds();

      if (this.debug) console.log("✅ マップ初期化完了");
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

      try {
        const marker = new google.maps.Marker({
          position: {
            lat: parseFloat(bar.latitude),
            lng: parseFloat(bar.longitude),
          },
          map: this.map,
          title: bar.name,
          icon: this.getCustomMarkerIcon(bar.price_range),
          animation: google.maps.Animation.DROP,
        });

        const infoWindow = new google.maps.InfoWindow({
          content: this.createInfoWindowContentFallback(bar),
          maxWidth: 300,
        });

        marker.addListener("click", () => {
          this.infoWindows.forEach((iw) => iw.close());

          infoWindow.open(this.map, marker);

          marker.setAnimation(google.maps.Animation.BOUNCE);
          setTimeout(() => marker.setAnimation(null), 1500);
        });

        this.markers.push(marker);
        this.infoWindows.push(infoWindow);
      } catch (error) {
        if (this.debug)
          console.error(`❌ ${bar.name} マーカー作成エラー:`, error);
      }
    });
  }

  createInfoWindowContentFallback(bar) {
    console.log("🔧 Creating FINAL InfoWindow for:", bar.name);

    const container = document.createElement("div");
    container.style.cssText = `
      font-family: 'Inter', sans-serif;
      width: 250px;
      overflow: hidden;
      background: white;
      line-height: 1.5;
    `;

    const header = document.createElement("div");
    header.style.cssText = `
      background: #1a2b3c;
      color: white;
      padding: 12px 16px;
      padding-right: 30px;
      border-radius: 8px;
    `;
    header.innerHTML = `
      <h3 style="font-size: 16px; font-weight: 700; margin: 0; line-height: 1.3;">
        ${bar.name}
      </h3>
    `;

    const body = document.createElement("div");
    body.style.cssText = `
      padding: 12px 16px;
      display: flex;
      flex-direction: column;
      gap: 8px;
    `;

    const createInfoRow = (icon, text) => {
      if (!text) return "";
      return `
        <div style="display: flex; align-items: flex-start; gap: 8px; font-size: 13px; color: #4b5563;">
          <div style="width: 16px; height: 16px; flex-shrink: 0; margin-top: 2px;">${icon}</div>
          <span style="flex: 1;">${text}</span>
        </div>
      `;
    };

    // アイコン定義
    const priceIcon = "💰";
    const addressIcon = `<svg fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M5.05 4.05a7 7 0 119.9 9.9L10 18.9l-4.95-4.95a7 7 0 010-9.9zM10 11a2 2 0 100-4 2 2 0 000 4z" clip-rule="evenodd"></path></svg>`;
    const timeIcon = `<svg fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-12a1 1 0 10-2 0v4a1 1 0 00.293.707l2.828 2.829a1 1 0 101.415-1.415L11 9.586V6z" clip-rule="evenodd"></path></svg>`;
    const smokingIcon = `<svg fill="currentColor" viewBox="0 0 20 20"><path d="M10 2a1 1 0 00-1 1v1a1 1 0 002 0V3a1 1 0 00-1-1zM3.293 4.707a1 1 0 00-1.414 1.414L3.586 7.83a1 1 0 001.414-1.414L3.293 4.707zM15.293 4.707a1 1 0 00-1.414-1.414L12.17 7.83a1 1 0 101.414 1.414l1.707-1.707zM10 16a6 6 0 100-12 6 6 0 000 12z" /><path d="M11.415 11.414a1 1 0 01.172.036l3.396 1.132A1 1 0 0114 13.5v1a1 1 0 01-1 1H7a1 1 0 01-1-1v-1a1 1 0 01.98-.996l3.396-1.132a1 1 0 01.039-.004h.001z" /></svg>`;

    body.innerHTML = `
      ${createInfoRow(priceIcon, bar.price_range)}
      ${createInfoRow(addressIcon, bar.address)}
      ${createInfoRow(timeIcon, bar.business_hours)}
      ${createInfoRow(smokingIcon, bar.smoking_status)}
    `;

    // ボタン
    const footer = document.createElement("div");
    footer.style.cssText = `
      padding: 0 16px 12px 16px;
      display: flex;
      gap: 8px;
      align-items: center;
    `;
    footer.innerHTML = `
      <a href="/bars/${bar.id}"
         style="flex: 1; background: linear-gradient(135deg, #1a2b3c 0%, #722f37 100%); color: white; text-decoration: none; padding: 8px 12px; border-radius: 6px; font-size: 13px; font-weight: 600; text-align: center; display: block; transition: transform 0.2s ease;"
         onmouseover="this.style.transform='translateY(-1px)'"
         onmouseout="this.style.transform='translateY(0)'">
        詳細を見る
      </a>
      <button style="flex-shrink: 0; padding: 8px; background: white; border: 1px solid #e5e7eb; border-radius: 6px; color: #6b7280; cursor: pointer; width: 36px; height: 36px; display: flex; align-items: center; justify-content: center; transition: all 0.2s ease;"
              onmouseover="this.style.color='#ef4444'; this.style.borderColor='#ef4444';"
              onmouseout="this.style.color='#6b7280'; this.style.borderColor='#e5e7eb';"
              title="お気に入りに追加">
        <svg style="width: 16px; height: 16px;" fill="currentColor" viewBox="0 0 20 20">
          <path fill-rule="evenodd" d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z" clip-rule="evenodd"></path>
        </svg>
      </button>
    `;

    container.appendChild(header);
    container.appendChild(body);
    container.appendChild(footer);

    return container;
  }

  createInfoRow(iconPath, text) {
    const row = document.createElement("div");
    row.style.cssText =
      "display: flex; align-items: center; margin-bottom: 6px;";

    const iconContainer = document.createElement("svg");
    iconContainer.style.cssText =
      "width: 14px; height: 14px; margin-right: 8px; color: #9ca3af; flex-shrink: 0;";
    iconContainer.setAttribute("fill", "currentColor");
    iconContainer.setAttribute("viewBox", "0 0 20 20");

    const path = document.createElement("path");
    path.setAttribute("fill-rule", "evenodd");
    path.setAttribute("d", iconPath);
    path.setAttribute("clip-rule", "evenodd");

    iconContainer.appendChild(path);

    const textSpan = document.createElement("span");
    textSpan.style.cssText =
      "flex: 1; font-size: 13px; color: #6b7280; line-height: 1.4;";
    textSpan.textContent = text;

    row.appendChild(iconContainer);
    row.appendChild(textSpan);

    return row;
  }

  getCustomMarkerIcon(priceRange) {
    let color = "#1a2b3c";
    return {
      path: google.maps.SymbolPath.CIRCLE,
      fillColor: color,
      fillOpacity: 0.9,
      strokeColor: "#FFFFFF",
      strokeWeight: 3,
      scale: 10,
    };
  }

  fitMapToBounds() {
    if (!this.markers || this.markers.length === 0) return;

    const bounds = new google.maps.LatLngBounds();
    this.markers.forEach((marker) => {
      bounds.extend(marker.getPosition());
    });

    this.map.fitBounds(bounds);

    google.maps.event.addListenerOnce(this.map, "bounds_changed", () => {
      if (this.map.getZoom() > 15) {
        this.map.setZoom(15);
      }
    });
  }

  getMapStyles() {
    return [
      {
        featureType: "all",
        elementType: "geometry",
        stylers: [{ color: "#f8fafc" }],
      },
      {
        featureType: "water",
        elementType: "geometry",
        stylers: [{ color: "#cbd5e1" }],
      },
      {
        featureType: "road",
        elementType: "geometry",
        stylers: [{ color: "#ffffff" }],
      },
      {
        featureType: "poi",
        elementType: "labels",
        stylers: [{ visibility: "off" }],
      },
    ];
  }

  showError(message) {
    if (this.mapTarget) {
      this.mapTarget.innerHTML = `
        <div class="flex flex-col items-center justify-center h-96 bg-red-50 text-red-800 p-6">
          <svg class="w-12 h-12 mb-4" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd"/>
          </svg>
          <h3 class="text-lg font-bold mb-2">地図の読み込みエラー</h3>
          <p class="text-sm text-center">${message}</p>
          <button onclick="location.reload()" class="mt-4 px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700">
            ページを再読み込み
          </button>
        </div>
      `;
    }
  }

  showBar(barName) {
    const marker =
      this.markers && this.markers.find((m) => m.title === barName);
    if (marker) {
      google.maps.event.trigger(marker, "click");
      this.map.setCenter(marker.getPosition());
      this.map.setZoom(16);
    }
  }

  resizeMap() {
    if (this.map) {
      google.maps.event.trigger(this.map, "resize");
      this.fitMapToBounds();
    }
  }

  disconnect() {
    if (this.debug) console.log("❌ Google Maps controller disconnected");

    if (this.markers) {
      this.markers.forEach((marker) => marker.setMap(null));
    }

    if (window.initGoogleMap) {
      delete window.initGoogleMap;
    }
  }
}
