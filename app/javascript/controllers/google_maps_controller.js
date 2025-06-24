// app/javascript/controllers/google_maps_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["map"];
  static values = {
    apiKey: String,
    bars: Array,
    center: Object,
  };

  connect() {
    if (this.debug) console.log("Google Maps controller connected");

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
    script.src = `https://maps.googleapis.com/maps/api/js?key=${this.apiKeyValue}&callback=initGoogleMap&libraries=places`;
    script.async = true;
    script.defer = true;

    // グローバルコールバック設定
    window.initGoogleMap = () => {
      this.initializeMap();
    };

    document.head.appendChild(script);
  }

  initializeMap() {
    if (this.debug) console.log("Initializing map with bars:", this.barsValue);

    // デフォルト中心点（東京駅）
    const defaultCenter = this.centerValue || { lat: 35.6812, lng: 139.7671 };

    // マップ初期化
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

    // マーカー配置
    this.addMarkers();

    // マップサイズ調整
    this.fitMapToBounds();
  }

  addMarkers() {
    this.markers = [];
    this.infoWindows = [];

    this.barsValue.forEach((bar, index) => {
      if (!bar.latitude || !bar.longitude) return;

      if (this.debug) console.log(`Adding marker for: ${bar.name}`);

      // マーカー作成
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

      // 情報ウィンドウ作成
      const infoWindow = new google.maps.InfoWindow({
        content: this.createInfoWindowContent(bar),
        maxWidth: 320,
      });

      // マーカークリックイベント
      marker.addListener("click", () => {
        // 他の情報ウィンドウを閉じる
        this.infoWindows.forEach((iw) => iw.close());

        // 現在の情報ウィンドウを開く
        infoWindow.open(this.map, marker);

        // マーカーにバウンスアニメーション
        marker.setAnimation(google.maps.Animation.BOUNCE);
        setTimeout(() => marker.setAnimation(null), 1500);
      });

      this.markers.push(marker);
      this.infoWindows.push(infoWindow);
    });
  }

  createInfoWindowContent(bar) {
    return `
      <div class="p-4 max-w-sm bg-white rounded-lg" style="font-family: Inter, sans-serif;">
        <!-- ヘッダー -->
        <div class="flex justify-between items-start mb-3">
          <h3 class="text-lg font-bold text-gray-900 leading-tight">${
            bar.name
          }</h3>
          <span class="px-3 py-1 text-xs font-bold rounded-full" 
                style="background-color: #dac19c; color: #1a2b3c;">
            ${bar.price_range}
          </span>
        </div>
        
        <!-- 詳細情報 -->
        <div class="space-y-2 text-sm text-gray-600 mb-4">
          <div class="flex items-center">
            <svg class="w-4 h-4 mr-2 text-gray-400" fill="currentColor" viewBox="0 0 20 20">
              <path fill-rule="evenodd" d="M5.05 4.05a7 7 0 119.9 9.9L10 18.9l-4.95-4.95a7 7 0 010-9.9zM10 11a2 2 0 100-4 2 2 0 000 4z" clip-rule="evenodd"/>
            </svg>
            <span class="flex-1">${bar.address}</span>
          </div>
          
          ${
            bar.business_hours
              ? `
            <div class="flex items-center">
              <svg class="w-4 h-4 mr-2 text-gray-400" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-12a1 1 0 10-2 0v4a1 1 0 00.293.707l2.828 2.829a1 1 0 101.415-1.415L11 9.586V6z" clip-rule="evenodd"/>
              </svg>
              <span>${bar.business_hours}</span>
            </div>
          `
              : ""
          }
          
          <div class="flex items-center">
            <svg class="w-4 h-4 mr-2 text-gray-400" fill="currentColor" viewBox="0 0 20 20">
              <path fill-rule="evenodd" d="M4 4a2 2 0 00-2 2v8a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2H4zm2 6a2 2 0 104 0 2 2 0 00-4 0zm6 0a2 2 0 104 0 2 2 0 00-4 0z" clip-rule="evenodd"/>
            </svg>
            <span>${bar.smoking_status}</span>
          </div>
        </div>
        
        <!-- アクションボタン -->
        <div class="flex gap-2">
          <a href="/bars/${bar.id}" 
             class="flex-1 px-4 py-2 text-white text-sm font-bold rounded-lg text-center transition-all"
             style="background: linear-gradient(135deg, #1a2b3c 0%, #722f37 100%);"
             onmouseover="this.style.transform='translateY(-1px)'"
             onmouseout="this.style.transform='translateY(0)'">
            詳細を見る
          </a>
          <button class="px-3 py-2 text-gray-500 hover:text-red-500 transition-colors" 
                  title="お気に入りに追加">
            <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
              <path fill-rule="evenodd" d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z" clip-rule="evenodd"/>
            </svg>
          </button>
        </div>
      </div>
    `;
  }

  getCustomMarkerIcon(priceRange) {
    // 価格帯に応じた色分け
    let color = "#6B7280"; // デフォルト（グレー）

    if (priceRange.includes("2,000") || priceRange.includes("2,500")) {
      color = "#10B981"; // リーズナブル（グリーン）
    } else if (priceRange.includes("3,000") || priceRange.includes("4,000")) {
      color = "#3B82F6"; // 標準（ブルー）
    } else if (priceRange.includes("5,000") || priceRange.includes("6,000")) {
      color = "#8B5CF6"; // 高級（パープル）
    }

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
    if (this.markers.length === 0) return;

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
    // あなたのデザインシステムに合わせたカスタムスタイル
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

  // 外部から呼び出し可能なメソッド
  showBar(barName) {
    const marker = this.markers.find((m) => m.title === barName);
    if (marker) {
      google.maps.event.trigger(marker, "click");
      this.map.setCenter(marker.getPosition());
      this.map.setZoom(16);
    }
  }

  // マップのリサイズ
  resizeMap() {
    if (this.map) {
      google.maps.event.trigger(this.map, "resize");
      this.fitMapToBounds();
    }
  }

  disconnect() {
    if (this.debug) console.log("Google Maps controller disconnected");
    if (this.markers) {
      this.markers.forEach((marker) => marker.setMap(null));
    }
  }
}
