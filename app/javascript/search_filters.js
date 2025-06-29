console.log("🔍 search_filters.js loading...");

window.addEventListener("DOMContentLoaded", () => {
  console.log("🔍 search_filters.js DOM ready");
  console.log("🔍 setFilterValue available:", typeof window.setFilterValue);
});

class SearchFilters {
  constructor() {
    this.form = document.getElementById("unified-search-form");
    this.debug = document.body.dataset.railsEnv === "development";
    this.initializeEventListeners();
  }

  initializeEventListeners() {
    if (!this.form) {
      if (this.debug) {
      }
      return;
    }

    const keywordInput = this.form.querySelector(
      'input[name="q[name_or_address_or_phone_or_smoking_status_or_description_or_specialties_category_cont]"]'
    );

    if (keywordInput) {
      let isComposing = false;

      keywordInput.addEventListener("compositionstart", () => {
        isComposing = true;
        if (this.debug) {
          console.log("🇯🇵 IME composition started");
        }
      });

      keywordInput.addEventListener("compositionend", () => {
        isComposing = false;
        if (this.debug) {
          console.log("🇯🇵 IME composition ended");
        }
      });

      keywordInput.addEventListener("keydown", (e) => {
        if (e.key === "Enter" && !isComposing) {
          e.preventDefault();
          if (this.debug) {
            console.log(
              "⌨️ Keyword search triggered by Enter:",
              e.target.value
            );
          }
          this.submitForm();
        }
      });

      keywordInput.addEventListener("blur", (e) => {
        if (e.target.value !== keywordInput.dataset.lastValue) {
          if (this.debug) {
            console.log("👁️ Keyword search triggered by blur:", e.target.value);
          }
          this.submitForm();
        }
      });

      keywordInput.addEventListener("focus", (e) => {
        e.target.dataset.lastValue = e.target.value;
      });

      if (this.debug) {
        console.log("✅ Keyword input Enter listener attached");
      }
    } else {
      if (this.debug) {
        console.warn("Keyword input field not found!");
      }
    }

    const areaInput = this.form.querySelector('input[name="q[address_cont]"]');
    if (areaInput) {
      let isAreaComposing = false;

      areaInput.addEventListener("compositionstart", () => {
        isAreaComposing = true;
      });

      areaInput.addEventListener("compositionend", () => {
        isAreaComposing = false;
      });

      areaInput.addEventListener("keydown", (e) => {
        if (e.key === "Enter" && !isAreaComposing) {
          e.preventDefault();
          if (this.debug) {
            console.log("⌨️ Area search triggered by Enter:", e.target.value);
          }
          this.submitForm();
        }
      });

      areaInput.addEventListener("blur", (e) => {
        if (e.target.value !== areaInput.dataset.lastValue) {
          if (this.debug) {
            console.log("👁️ Area search triggered by blur:", e.target.value);
          }
          this.submitForm();
        }
      });

      areaInput.addEventListener("focus", (e) => {
        e.target.dataset.lastValue = e.target.value;
      });

      if (this.debug) {
        console.log("✅ Area input Enter listener attached");
      }
    }

    this.form.addEventListener("submit", (e) => {
      if (this.debug) {
        console.log("📝 Form submitted via submit event");
      }
    });

    if (this.debug) {
      console.log("✅ All search event listeners attached (Enter-only mode)");
    }
  }

  setFilterValue(fieldName, value) {
    const hiddenField = this.form.querySelector(
      `input[name="q[${fieldName}]"]`
    );
    if (!hiddenField) {
      if (this.debug) {
        console.warn(`Hidden field q[${fieldName}] not found`);
      }
      return;
    }

    const currentValue = hiddenField.value;
    const newValue = currentValue === value ? "" : value;
    hiddenField.value = newValue;

    if (this.debug) {
      console.log(`🎯 Filter ${fieldName} set to:`, newValue);
    }

    this.submitForm();
  }

  clearFilterValue(fieldName) {
    const hiddenField = this.form.querySelector(
      `input[name="q[${fieldName}]"]`
    );
    if (!hiddenField) {
      if (this.debug) {
        console.warn(`Hidden field q[${fieldName}] not found`);
      }
      return;
    }

    hiddenField.value = "";
    if (this.debug) {
      console.log(`🗑️ Filter ${fieldName} cleared`);
    }
    this.submitForm();
  }

  clearAllFilters() {
    const allInputs = this.form.querySelectorAll(
      'input[type="text"], input[type="hidden"]'
    );
    allInputs.forEach((input) => {
      if (input.name !== "utf8" && input.name !== "authenticity_token") {
        input.value = "";
      }
    });

    if (this.debug) {
      console.log("🗑️ All filters cleared");
    }
    this.submitForm();
  }

  submitForm() {
    if (this.form) {
      if (this.debug) {
        console.log("🚀 === Form Submission ===");
        console.log("Current conditions:", this.getCurrentConditions());
      }

      this.preserveToggleState();
      this.form.requestSubmit();
    }
  }

  preserveToggleState() {
    const currentView =
      localStorage.getItem("bar-atlas-preferred-view") || "list";
    const url = new URL(this.form.action);
    url.searchParams.set("view", currentView);
    this.form.action = url.toString();

    if (this.debug) {
      console.log("🔄 Toggle state preserved:", currentView);
    }
  }

  getCurrentConditions() {
    const formData = new FormData(this.form);
    const conditions = {};
    for (let [key, value] of formData.entries()) {
      if (key.startsWith("q[") && value.trim() !== "") {
        conditions[key] = value;
      }
    }
    return conditions;
  }

  resetSearchAndFocus() {
    this.clearAllFilters();
    const keywordInput = this.form.querySelector(
      'input[name="q[name_or_address_or_phone_or_smoking_status_or_description_or_specialties_category_cont]"]'
    );
    if (keywordInput) {
      setTimeout(() => {
        keywordInput.focus();
      }, 100);
    }
  }
}

function initializeSearchFilters() {
  if (window.searchFilters) {
    if (window.searchFilters.debug) {
      console.log("🔄 Reinitializing search filters...");
    }
  }

  window.searchFilters = new SearchFilters();
  if (window.searchFilters.debug) {
    console.log("✅ Search filters initialized (Enter-only mode)");
  }

  if (window.searchFilters.form) {
    if (window.searchFilters.debug) {
      console.log(
        "📝 Form found, current conditions:",
        window.searchFilters.getCurrentConditions()
      );
    }
  } else {
    if (window.searchFilters.debug) {
      console.warn("⚠️ Form not found! Check if unified-search-form exists");
    }
  }
}

window.setFilterValue = (fieldName, value) => {
  if (window.searchFilters) {
    window.searchFilters.setFilterValue(fieldName, value);
  } else {
    console.warn("⚠️ searchFilters not initialized");
  }
};

window.clearFilterValue = (fieldName) => {
  if (window.searchFilters) {
    window.searchFilters.clearFilterValue(fieldName);
  }
};

window.clearAllFiltersUnified = () => {
  if (window.searchFilters) {
    window.searchFilters.clearAllFilters();
  }
};

window.filterByPrice = (price) =>
  window.setFilterValue("price_category_eq", price);
window.filterBySmoking = (smoking) =>
  window.setFilterValue("smoking_status_eq", smoking);
window.filterByArea = (area) => window.setFilterValue("address_cont", area);
window.filterBySpecialty = (specialty) =>
  window.setFilterValue("specialties_category_eq", specialty);
window.clearFilter = (filterKey) => window.clearFilterValue(filterKey);
window.clearAllFilters = () => window.clearAllFiltersUnified();

window.resetSearchAndFocus = () => {
  if (window.searchFilters) {
    window.searchFilters.resetSearchAndFocus();
  }
};

document.addEventListener("DOMContentLoaded", initializeSearchFilters);
document.addEventListener("turbo:load", initializeSearchFilters);
document.addEventListener("turbo:frame-load", initializeSearchFilters);

window.addEventListener("beforeunload", () => {
  if (window.searchFilters && window.searchFilters.debug) {
    console.log("📤 Page unloading - search filters ready for cleanup");
  }
});

if (document.body.dataset.railsEnv === "development") {
  console.log("✅ Search filters script loaded (Enter-only mode)");
}
