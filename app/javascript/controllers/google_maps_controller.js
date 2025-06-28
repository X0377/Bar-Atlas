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
          content: this.createInfoWindowContent(bar),
          maxWidth: 320,
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

  createInfoWindowContent(bar) {
    try {
      const container = document.createElement("div");
      container.className = "p-4 max-w-sm bg-white rounded-lg";
      container.style.fontFamily = "Inter, sans-serif";

      const header = document.createElement("div");
      header.className = "flex justify-between items-start mb-3";

      const titleSection = document.createElement("div");
      const title = document.createElement("h3");
      title.className = "text-lg font-bold text-gray-900 leading-tight";
      title.textContent = bar.name;
      titleSection.appendChild(title);

      const priceTag = document.createElement("span");
      priceTag.className = "px-3 py-1 text-xs font-bold rounded-full";
      priceTag.style.backgroundColor = "#dac19c";
      priceTag.style.color = "#1a2b3c";
      priceTag.textContent = bar.price_range;

      header.appendChild(titleSection);
      header.appendChild(priceTag);

      const detailsSection = document.createElement("div");
      detailsSection.className = "space-y-2 text-sm text-gray-600 mb-4";

      const addressDiv = this.createInfoRow(
        "M5.05 4.05a7 7 0 119.9 9.9L10 18.9l-4.95-4.95a7 7 0 010-9.9zM10 11a2 2 0 100-4 2 2 0 000 4z",
        bar.address
      );
      detailsSection.appendChild(addressDiv);

      if (bar.business_hours) {
        const hoursDiv = this.createInfoRow(
          "M10 18a8 8 0 100-16 8 8 0 000 16zm1-12a1 1 0 10-2 0v4a1 1 0 00.293.707l2.828 2.829a1 1 0 101.415-1.415L11 9.586V6z",
          bar.business_hours
        );
        detailsSection.appendChild(hoursDiv);
      }

      const smokingDiv = this.createInfoRow(
        "M4 4a2 2 0 00-2 2v8a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2H4zm2 6a2 2 0 104 0 2 2 0 00-4 0zm6 0a2 2 0 104 0 2 2 0 00-4 0z",
        bar.smoking_status
      );
      detailsSection.appendChild(smokingDiv);

      // アクションボタン
      const actionsDiv = document.createElement("div");
      actionsDiv.className = "flex gap-2";

      const detailButton = document.createElement("a");
      detailButton.href = "/bars/" + bar.id;
      detailButton.className =
        "flex-1 px-4 py-2 text-white text-sm font-bold rounded-lg text-center transition-all";
      detailButton.style.background =
        "linear-gradient(135deg, #1a2b3c 0%, #722f37 100%)";
      detailButton.textContent = "詳細を見る";

      // ホバー効果
      detailButton.addEventListener("mouseover", () => {
        detailButton.style.transform = "translateY(-1px)";
      });
      detailButton.addEventListener("mouseout", () => {
        detailButton.style.transform = "translateY(0)";
      });

      const favoriteButton = document.createElement("button");
      favoriteButton.className =
        "px-3 py-2 text-gray-500 hover:text-red-500 transition-colors";
      favoriteButton.title = "お気に入りに追加";

      const svg = document.createElement("svg");
      svg.className = "w-5 h-5";
      svg.setAttribute("fill", "currentColor");
      svg.setAttribute("viewBox", "0 0 20 20");

      const path = document.createElement("path");
      path.setAttribute("fill-rule", "evenodd");
      path.setAttribute(
        "d",
        "M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z"
      );
      path.setAttribute("clip-rule", "evenodd");

      svg.appendChild(path);
      favoriteButton.appendChild(svg);

      actionsDiv.appendChild(detailButton);
      actionsDiv.appendChild(favoriteButton);

      container.appendChild(header);
      container.appendChild(detailsSection);
      container.appendChild(actionsDiv);

      return container;
    } catch (error) {
      console.error(`❌ 情報ウィンドウ作成エラー (${bar.name}):`, error);
      return document.createTextNode(
        `エラー: ${bar.name}の情報を表示できません`
      );
    }
  }

  createInfoRow(iconPath, text) {
    const row = document.createElement("div");
    row.className = "flex items-center";

    const iconContainer = document.createElement("svg");
    iconContainer.className = "w-4 h-4 mr-2 text-gray-400";
    iconContainer.setAttribute("fill", "currentColor");
    iconContainer.setAttribute("viewBox", "0 0 20 20");

    const path = document.createElement("path");
    path.setAttribute("fill-rule", "evenodd");
    path.setAttribute("d", iconPath);
    path.setAttribute("clip-rule", "evenodd");

    iconContainer.appendChild(path);

    const textSpan = document.createElement("span");
    textSpan.className = "flex-1";
    textSpan.textContent = text;

    row.appendChild(iconContainer);
    row.appendChild(textSpan);

    return row;
  }

  getCustomMarkerIcon(priceRange) {
    let color = "#1a2b3c";

    /* 色分けは後日対応予定
    if (
      priceRange &&
      (priceRange.includes("#") || priceRange.includes("#"))
    ) {
      color = "#10B981"; // リーズナブル
    } else if (
      priceRange &&
      (priceRange.includes("#") || priceRange.includes("#"))
    ) {
      color = "#3B82F6"; // 標準
    } else if (
      priceRange &&
      (priceRange.includes("#") || priceRange.includes("#"))
    ) {
      color = "#8B5CF6"; // 高級
    }
    */

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

    // ズームレベル調整（近すぎる場合）
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
