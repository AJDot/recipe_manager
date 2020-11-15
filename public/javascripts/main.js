document.addEventListener("DOMContentLoaded", function () {
  const App = {
    helpers: {
      flatten: function (arrays) {
        return arrays.reduce(function (a, b) {
          return a.concat(b);
        }, []);
      },
      unique: function (array) {
        return array.reduce(function (result, item) {
          if (result.indexOf(item) === -1) {
            result.push(item);
          }
          return result;
        }, []);
      },
      makeArray: function (arrayLike) {
        return Array.prototype.slice.call(arrayLike);
      },
    },
    toggleStrikeThrough: function (event) {
      const target = event.target;
      if (target.tagName === "LI") {
        target.classList.toggle("strike-through");
      }
    },
    showCards: function (cards) {
      cards.forEach(function (card) {
        card.classList.remove("hidden");
      });
    },
    hideCards: function (cards) {
      cards.forEach(function (card) {
        card.classList.add("hidden");
      });
    },
    getRecipeCardCategories: function (card) {
      const categoriesUl = card.querySelector(".categories");
      const lis = this.helpers.makeArray(categoriesUl.children);
      return lis.map(function (li) {
        return li.textContent;
      });
    },
    filterByCategory: function (event) {
      const select = document.getElementById("filterCategorySelect");
      const category = select.value;
      const cardsArray = this.helpers.makeArray(this.cards);

      const toKeep = [];
      const toRemove = [];
      cardsArray.forEach(function (card) {
        const currentCats = this.getRecipeCardCategories(card);
        const selectUncategorized = category === "Uncategorized";
        const hasNoCats = currentCats.length === 0;
        const hasCat = currentCats.indexOf(category) !== -1;
        const noFilter = category === "---";
        if (noFilter || selectUncategorized && hasNoCats || hasCat) {
          toKeep.push(card);
        } else {
          toRemove.push(card);
        }
      }, this);

      this.hideCards(toRemove);
      this.showCards(toKeep);
    },
    resetCategoryFilter: function (event) {
      const cardsArray = this.helpers.makeArray(this.cards);
      cardsArray.forEach(function (card) {
        card.classList.remove("hidden")
      });
    },
    populateFilterByCategory: function () {
      const cardsArray = this.helpers.makeArray(this.cards);

      // array of arrays of categories for each card
      let allCardsCategories = cardsArray.map(this.getRecipeCardCategories.bind(this));
      // flatten to 1 level
      allCardsCategories = this.helpers.flatten(allCardsCategories);
      // collect unique categories
      const uniqueCategories = this.helpers.unique(allCardsCategories);
      // sort alphabetically
      uniqueCategories.sort();
      // add "Uncategorized" to list to enable filtering by recipes that
      // do not have a category
      uniqueCategories.push("Uncategorized");
      // add "---" to beginning of list to represent "Do Not Filter"
      uniqueCategories.unshift("---");

      // construct options and add the select element
      const select = document.getElementById("filterCategorySelect");
      this.addOptions(select, uniqueCategories);
    },
    addOptions: function (select, options) {
      const optionsHTML = options.map(function (option) {
        return '<option value="' + option + '">' + option + '</option>';
      });

      select.innerHTML = optionsHTML.join("\n");
    },
    toggleFilterDrawer: function (e) {
      e.preventDefault();
      e.stopPropagation();
      const toggleBtn = e.currentTarget;
      const filtersDrawer = document.querySelector(".filters");
      filtersDrawer.classList.toggle("reveal");
    },
    showConfirmModal: function (e) {
      e.preventDefault();
      const $modalDivs = $(e.currentTarget).siblings('.modal, .modal-overlay');
      $modalDivs.fadeIn(400);
    },
    hideConfirmModal: function (e) {
      e.preventDefault();
      const $modalDivs = $(e.currentTarget).closest('.modal').add('.modal-overlay');
      $modalDivs.fadeOut(400);
    },
    readURL: function (e) {
      const input = e.target
      if (input.files && input.files[0]) {
        const reader = new FileReader();

        reader.onload = function (event) {
          $(input.dataset.for)
            .attr('src', event.target.result);
        };

        reader.readAsDataURL(input.files[0]);
      }
    },
    bindEvents: function () {
      const filtersDrawerBtn = document.querySelector(".drawer_toggle");
      if (filtersDrawerBtn) {
        filtersDrawerBtn.addEventListener("click", this.toggleFilterDrawer.bind(this));
      }

      $('.modal').siblings('a.destroy').on('click', this.showConfirmModal.bind(this));
      $('.modal a.cancel').on('click', this.hideConfirmModal.bind(this));
      $('input[type="file"]').on('change', this.readURL)
    },
    init: function () {
      this.steps = document.querySelector(".steps");
      this.ingredients = document.querySelector(".ingredients");
      this.cardList = document.querySelector(".card-list");
      if (this.cardList) {
        this.cards = this.cardList.children;
      }
      this.sortCardList = document.getElementById("sortCardList");
      this.filterByCategoryResetBtn = document.getElementById("filterByCategoryResetBtn");

      // Feature: click to toggle strike-through on ingredients and directions
      if (this.steps) {
        this.steps.addEventListener("click", this.toggleStrikeThrough);
      }
      if (this.ingredients) {
        this.ingredients.addEventListener("click", this.toggleStrikeThrough);
      }

      // Feature: sort recipe cards by title
      // if (sortCardList && cardList) {
      //   sortCardList.addEventListener("click", this.sortCards);
      // }

      // Feature: filter recipe cards by category
      const select = document.getElementById("filterCategorySelect");
      if (select && this.cardList) {
        select.addEventListener("change", this.filterByCategory.bind(this))
        this.populateFilterByCategory();
      }

      // Feature: reset recipe cards by category filter
      this.filterByCategoryBtn = document.getElementById("filterByCategoryBtn");
      if (this.filterByCategoryResetBtn && this.cardList) {
        this.filterByCategoryResetBtn.addEventListener("click", this.resetCategoryFilter.bind(this));
      }

      this.bindEvents();

      $('input[type="file"]').change(this.readURL).trigger('change')
    },
  }

  App.init();
});
