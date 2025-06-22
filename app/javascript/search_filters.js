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

    const textInputs = this.form.querySelectorAll('input[type="text"]');
    textInputs.forEach((input) => {
      let timeout;
      input.addEventListener("input", (e) => {
        clearTimeout(timeout);
        timeout = setTimeout(() => {
          this.submitForm();
        }, 500);
      });
    });
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

    this.submitForm();
  }

  submitForm() {
    if (this.form) {
      console.log(
        "Submitting form with conditions:",
        this.getCurrentConditions()
      );
      this.form.submit();
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

let searchFilters;

window.setFilterValue = (fieldName, value) => {
  if (searchFilters) {
    searchFilters.setFilterValue(fieldName, value);
  }
};

window.clearFilterValue = (fieldName) => {
  if (searchFilters) {
    searchFilters.clearFilterValue(fieldName);
  }
};

window.clearAllFiltersUnified = () => {
  if (searchFilters) {
    searchFilters.clearAllFilters();
  }
};

window.filterByPrice = (price) => {
  if (searchFilters) {
    searchFilters.setFilterValue("price_range_eq", price);
  }
};

window.filterBySmoking = (smoking) => {
  if (searchFilters) {
    searchFilters.setFilterValue("smoking_status_eq", smoking);
  }
};

window.filterByArea = (area) => {
  if (searchFilters) {
    searchFilters.setFilterValue("address_cont", area);
  }
};

window.clearFilter = (filterKey) => {
  if (searchFilters) {
    searchFilters.clearFilterValue(filterKey);
  }
};

window.clearAllFilters = () => {
  if (searchFilters) {
    searchFilters.clearAllFilters();
  }
};

document.addEventListener("DOMContentLoaded", () => {
  searchFilters = new SearchFilters(); // ← 正しいクラス名
  console.log("Search filters initialized");

  // デバッグ：現在の検索条件を確認
  if (searchFilters.form) {
    console.log(
      "Form found, current conditions:",
      searchFilters.getCurrentConditions()
    );
  } else {
    console.warn(
      "Form not found! Check if the form has id 'unified-search-form'"
    );
  }
});
