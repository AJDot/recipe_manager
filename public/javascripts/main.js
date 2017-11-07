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
    }
  },
  toggleStrikeThrough: function(event) {
    var target = event.target;
    if (target.tagName === "LI") {
      target.classList.toggle("strike-through");
    }
  },
  sortCards: function(event) {
    var cardsArray = Array.prototype.slice.call(self.cards);
    cardsArray.sort(function(a, b) {
      var aTitle = a.querySelector("h1").textContent.trim().toUpperCase();
      var bTitle = b.querySelector("h1").textContent.trim().toUpperCase();

      if (aTitle < bTitle) {
        return -1;
      } else if (aTitle > bTitle) {
        return 1;
      }
      return 0;
    });

    cardList.innerHTML = "";
    cardsArray.forEach(function(card) {
      // this makes the spacing right, each li is on a new line
      cardList.appendChild(document.createTextNode("  \n"));
      cardList.appendChild(card);
    });
  },
  getRecipeCardCategories: function(card) {
    var categoriesUl = card.querySelector(".categories");
    var lis = Array.prototype.slice.call(categoriesUl.children);
    return lis.map(function(li) {
      return li.textContent;
    });
  },
  filterByCategory: function(event) {
    var self = this;
    var select = document.getElementById("filterCategorySelect");
    var category = select.selectedOptions[0].value;
    var cardsArray = Array.prototype.slice.call(self.cards);
    var toRemove = cardsArray.filter(function(card) {
      var names = self.getRecipeCardCategories(card);
      return names.indexOf(category) === -1;
    });
    cardsArray.forEach(function(card) {
      card.style.display = toRemove.indexOf(card) !== -1 ? "none" : "inline-block";
    });
  },
  resetCategoryFilter: function(event) {
    var cardsArray = Array.prototype.slice.call(this.cards);
    cardsArray.forEach(function(card) {
      card.style.display = "inline-block";
    });
  },
  populateFilterByCategory: function() {
    var self = this;
    var cardsArray = Array.prototype.slice.call(self.cards);

    // array of arrays of categories for each card
    var allCardsCategories = cardsArray.map(self.getRecipeCardCategories);
    // flatten to 1 level
    allCardsCategories = self.helpers.flatten(allCardsCategories);
    // collect unique categories
    var uniqueCategories = self.helpers.unique(allCardsCategories);
    // sort alphabetically
    uniqueCategories.sort();

    // construct options and add the select element
    var select = document.getElementById("filterCategorySelect");
    var options = uniqueCategories.map(function(category) {
      return '<option value="' + category + '">' + category + '</option>';
    });

    select.innerHTML = options.join("\n");
  },
  init: function() {
    var self = this;
    document.addEventListener("DOMContentLoaded", function() {
      self.steps = document.querySelector(".steps");
      self.ingredients = document.querySelector(".ingredients");
      self.cardList = document.querySelector(".card-list");
      if (self.cardList) { self.cards = self.cardList.children; }
      self.sortCardList = document.getElementById("sortCardList");
      self.filterByCategoryBtn = document.getElementById("filterByCategoryBtn");
      self.filterByCategoryResetBtn = document.getElementById("filterByCategoryResetBtn");

      // Feature: click to toggle strike-through on ingredients and directions
      if (self.steps) {
        self.steps.addEventListener("click", self.toggleStrikeThrough);
      }
      if (self.ingredients) {
        self.ingredients.addEventListener("click", self.toggleStrikeThrough);
      }

      // Feature: sort recipe cards by title
      // if (sortCardList && cardList) {
      //   sortCardList.addEventListener("click", self.sortCards);
      // }

      // Feature: filter recipe cards by category
      if (self.filterByCategoryBtn && self.cardList) {
        filterByCategoryBtn.addEventListener("click", self.filterByCategory.bind(self))
        self.populateFilterByCategory();
      }

      // Feature: reset recipe cards by category filter
      if (self.filterByCategoryResetBtn && self.cardList) {
        self.filterByCategoryResetBtn.addEventListener("click", self.resetCategoryFilter.bind(self));
      }
    });
  }
}

App.init();
