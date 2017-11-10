document.addEventListener("DOMContentLoaded", function() {
  var App = {
    helpers: {
      flatten: function(arrays) {
        return arrays.reduce(function(a, b) {
          return a.concat(b);
        }, []);
      },
      unique: function(array) {
        return array.reduce(function(result, item) {
          if (result.indexOf(item) === -1) {
            result.push(item);
          }
          return result;
        }, []);
      },
      makeArray: function(arrayLike) {
        return Array.prototype.slice.call(arrayLike);
      },
    },
    toggleStrikeThrough: function(event) {
      var target = event.target;
      if (target.tagName === "LI") {
        target.classList.toggle("strike-through");
      }
    },
    showCards: function(cards) {
      cards.forEach(function(card) {
        card.classList.remove("hidden");
      });
    },
    hideCards: function(cards) {
      cards.forEach(function(card) {
        card.classList.add("hidden");
      });
    },
    getRecipeCardCategories: function(card) {
      var categoriesUl = card.querySelector(".categories");
      var lis = this.helpers.makeArray(categoriesUl.children);
      return lis.map(function(li) {
        return li.textContent;
      });
    },
    filterByCategory: function(event) {
      var select = document.getElementById("filterCategorySelect");
      var category = select.value;
      var cardsArray = this.helpers.makeArray(this.cards);

      var toKeep = [];
      var toRemove = [];
      cardsArray.forEach(function(card) {
        var currentCats = this.getRecipeCardCategories(card);
        var selectUncategorized = category === "Uncategorized";
        var hasNoCats = currentCats.length === 0;
        var hasCat = currentCats.indexOf(category) !== -1;
        if (selectUncategorized && hasNoCats || hasCat) {
          toKeep.push(card);
        } else {
          toRemove.push(card);
        }
      }, this);

      this.hideCards(toRemove);
      this.showCards(toKeep);
    },
    resetCategoryFilter: function(event) {
      var cardsArray = this.helpers.makeArray(this.cards);
      cardsArray.forEach(function(card) {
        card.classList.remove("hidden")
      });
    },
    populateFilterByCategory: function() {
      var cardsArray = this.helpers.makeArray(this.cards);

      // array of arrays of categories for each card
      var allCardsCategories = cardsArray.map(this.getRecipeCardCategories.bind(this));
      // flatten to 1 level
      allCardsCategories = this.helpers.flatten(allCardsCategories);
      // collect unique categories
      var uniqueCategories = this.helpers.unique(allCardsCategories);
      // add "Uncategorized" to list to enable filtering by recipes that
      // do not have a category
      uniqueCategories.push("Uncategorized");
      // sort alphabetically
      uniqueCategories.sort();

      // construct options and add the select element
      var select = document.getElementById("filterCategorySelect");
      this.addOptions(select, uniqueCategories);
    },
    addOptions: function(select, options) {
      var optionsHTML = options.map(function(option) {
        return '<option value="' + option + '">' + option + '</option>';
      });

      select.innerHTML = optionsHTML.join("\n");
    },
    toggleFilterDrawer: function(e) {
      e.preventDefault();
      e.stopPropagation();
      var toggleBtn = e.currentTarget;
      var filtersDrawer = document.querySelector(".filters");
      filtersDrawer.classList.toggle("reveal");
    },
    bindEvents: function() {
      var filtersDrawerBtn = document.querySelector(".drawer_toggle");
      filtersDrawerBtn.addEventListener("click", this.toggleFilterDrawer.bind(this));
    },
    init: function() {
      this.steps = document.querySelector(".steps");
      this.ingredients = document.querySelector(".ingredients");
      this.cardList = document.querySelector(".card-list");
      if (this.cardList) { this.cards = this.cardList.children; }
      this.sortCardList = document.getElementById("sortCardList");
      this.filterByCategoryBtn = document.getElementById("filterByCategoryBtn");
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
      if (this.filterByCategoryBtn && this.cardList) {
        filterByCategoryBtn.addEventListener("click", this.filterByCategory.bind(this))
        this.populateFilterByCategory();
      }

      // Feature: reset recipe cards by category filter
      if (this.filterByCategoryResetBtn && this.cardList) {
        this.filterByCategoryResetBtn.addEventListener("click", this.resetCategoryFilter.bind(this));
      }

      this.bindEvents();
    }
  }

  App.init();
})
