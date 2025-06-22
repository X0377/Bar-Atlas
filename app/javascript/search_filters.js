class SearchFilters {
  constructor() {
    this.form = document.getElementById("unified-search-form");
    this.initializeEventListeners();
  }

  initializeEventListeners() {
    if (!this.form) {
      console.warn("Form with id 'unified-search-form' not found");
      return;
    }

    const keywordInput = this.form.querySelector(
      'input[name="q[name_or_address_or_phone_or_smoking_status_or_description_or_specialties_category_cont]"]'
    );

    if (keywordInput) {
      let timeout;
      keywordInput.addEventListener("input", (e) => {
        clearTimeout(timeout);
        timeout = setTimeout(() => {
          console.log("Keyword search triggered:", e.target.value);
          this.submitForm();
        }, 500);
      });
      console.log("Keyword input listener attached");
    } else {
      console.warn("Keyword input field not found!");
    }

    const areaInput = this.form.querySelector('input[name="q[address_cont]"]');
    if (areaInput) {
      let timeout;
      areaInput.addEventListener("input", (e) => {
        clearTimeout(timeout);
        timeout = setTimeout(() => {
          console.log("Area search triggered:", e.target.value);
          this.submitForm();
        }, 500);
      });
    }
  }

  setFilterValue(fieldName, value) {
    const hiddenField = this.form.querySelector(
      `input[name="q[${fieldName}]"]`
    );
    if (!hiddenField) {
      console.warn(`Hidden field q[${fieldName}] not found`);
      return;
    }

    const currentValue = hiddenField.value;
    const newValue = currentValue === value ? "" : value;
    hiddenField.value = newValue;

    console.log(`Filter ${fieldName} set to:`, newValue);
    this.submitForm();
  }

  clearFilterValue(fieldName) {
    const hiddenField = this.form.querySelector(
      `input[name="q[${fieldName}]"]`
    );
    if (!hiddenField) {
      console.warn(`Hidden field q[${fieldName}] not found`);
      return;
    }

    hiddenField.value = "";
    console.log(`Filter ${fieldName} cleared`);
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

    console.log("All filters cleared");
    this.submitForm();
  }

  submitForm() {
    if (this.form) {
      console.log("=== Form Submission ===");
      console.log("Current conditions:", this.getCurrentConditions());

      this.form.requestSubmit();
    }
  }

  // デバッグ用
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
}

function initializeSearchFilters() {
  if (window.searchFilters) {
    console.log("Reinitializing search filters...");
  }

  window.searchFilters = new SearchFilters();
  console.log("Search filters initialized");

  if (window.searchFilters.form) {
    console.log(
      "Form found, current conditions:",
      window.searchFilters.getCurrentConditions()
    );
  } else {
    console.warn("Form not found! Check if unified-search-form exists");
  }
}

window.setFilterValue = (fieldName, value) => {
  if (window.searchFilters) {
    window.searchFilters.setFilterValue(fieldName, value);
  } else {
    console.warn("searchFilters not initialized");
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

// エイリアス関数（既存のHTMLから呼ばれる可能性があるため）
window.filterByPrice = (price) =>
  window.setFilterValue("price_range_eq", price);
window.filterBySmoking = (smoking) =>
  window.setFilterValue("smoking_status_eq", smoking);
window.filterByArea = (area) => window.setFilterValue("address_cont", area);
window.clearFilter = (filterKey) => window.clearFilterValue(filterKey);
window.clearAllFilters = () => window.clearAllFiltersUnified();

// イベントリスナー
document.addEventListener("DOMContentLoaded", initializeSearchFilters);
document.addEventListener("turbo:load", initializeSearchFilters);
document.addEventListener("turbo:frame-load", initializeSearchFilters);

console.log("Search filters script loaded");
