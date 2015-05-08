(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
(function() {
  return this.AbstractSet = require('./set');
})();

},{"./set":2}],2:[function(require,module,exports){
var Set,
  slice = [].slice;

module.exports = Set = (function() {
  function Set() {
    var items, set;
    items = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    if (this instanceof Set) {
      this.items = items.slice();
      this._handler = void 0;
      this.handler = function(handler) {
        if (arguments.length > 0) {
          this._handler = handler;
          return this;
        }
        return this._handler;
      };
    } else {
      set = new Set;
      set.items = items.slice();
      return set;
    }
  }

  Set.prototype.clone = function() {
    var set;
    set = (new Set).handler(this._handler);
    set.items = this.items.slice();
    return set;
  };

  Set.prototype.empty = function() {
    return this.items.length === 0;
  };

  Set.prototype.subset = function(set) {
    var i, item, items, j, len, len1, ref, ref1;
    items = (set instanceof Set ? set.items : set) || [];
    if (typeof this._handler === 'function') {
      ref = this.items;
      for (i = 0, len = ref.length; i < len; i++) {
        item = ref[i];
        if (!this._handler(items).has(item)) {
          return false;
        }
      }
    } else {
      ref1 = this.items;
      for (j = 0, len1 = ref1.length; j < len1; j++) {
        item = ref1[j];
        if (-1 === items.indexOf(item)) {
          return false;
        }
      }
    }
    return true;
  };

  Set.prototype.superset = function(set) {
    var i, item, items, j, len, len1;
    items = (set instanceof Set ? set.items : set) || [];
    if (typeof this._handler === 'function') {
      for (i = 0, len = items.length; i < len; i++) {
        item = items[i];
        if (!this._handler(this.items).has(item)) {
          return false;
        }
      }
    } else {
      for (j = 0, len1 = items.length; j < len1; j++) {
        item = items[j];
        if (-1 === this.items.indexOf(item)) {
          return false;
        }
      }
    }
    return true;
  };

  Set.prototype.has = function(item) {
    if (typeof this._handler === 'function') {
      return this._handler(this.items).has(item);
    } else {
      return -1 !== this.items.indexOf(item);
    }
  };

  Set.prototype.add = function() {
    var i, item, items, j, len, len1, set;
    items = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    set = this.clone();
    if (typeof this._handler === 'function') {
      for (i = 0, len = items.length; i < len; i++) {
        item = items[i];
        if (!this._handler(set.items).has(item)) {
          set.items.push(item);
        }
      }
    } else {
      for (j = 0, len1 = items.length; j < len1; j++) {
        item = items[j];
        if (-1 === set.items.indexOf(item)) {
          set.items.push(item);
        }
      }
    }
    return (set.items.length === this.items.length ? this : set);
  };

  Set.prototype.remove = function() {
    var i, idx, item, items, j, len, len1, set;
    items = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    set = this.clone();
    if (typeof this._handler === 'function') {
      for (i = 0, len = items.length; i < len; i++) {
        item = items[i];
        if (this._handler(set.items).has(item)) {
          this._handler(set.items).remove(item);
        }
      }
    } else {
      for (j = 0, len1 = items.length; j < len1; j++) {
        item = items[j];
        if (-1 !== (idx = set.items.indexOf(item))) {
          set.items.splice(idx, 1);
        }
      }
    }
    return (set.items.length === this.items.length ? this : set);
  };

  Set.prototype.union = function() {
    var i, item, items, j, k, l, len, len1, len2, len3, set, sets;
    sets = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    set = this.clone();
    if (typeof this._handler === 'function') {
      for (i = 0, len = sets.length; i < len; i++) {
        items = sets[i];
        items = (items instanceof Set ? items.items : items) || [];
        for (j = 0, len1 = items.length; j < len1; j++) {
          item = items[j];
          if (!this._handler(set.items).has(item)) {
            set.items.push(item);
          }
        }
      }
    } else {
      for (k = 0, len2 = sets.length; k < len2; k++) {
        items = sets[k];
        items = (items instanceof Set ? items.items : items) || [];
        for (l = 0, len3 = items.length; l < len3; l++) {
          item = items[l];
          if (-1 === set.items.indexOf(item)) {
            set.items.push(item);
          }
        }
      }
    }
    return set;
  };

  Set.prototype.complement = function() {
    var i, item, items, j, k, l, len, len1, len2, len3, set, sets;
    sets = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    set = (new Set).handler(this._handler);
    if (typeof this._handler === 'function') {
      for (i = 0, len = sets.length; i < len; i++) {
        items = sets[i];
        items = (items instanceof Set ? items.items : items) || [];
        for (j = 0, len1 = items.length; j < len1; j++) {
          item = items[j];
          if (!((this._handler(this.items).has(item)) || this._handler(set.items).has(item))) {
            set.items.push(item);
          }
        }
      }
    } else {
      for (k = 0, len2 = sets.length; k < len2; k++) {
        items = sets[k];
        items = (items instanceof Set ? items.items : items) || [];
        for (l = 0, len3 = items.length; l < len3; l++) {
          item = items[l];
          if ((-1 === this.items.indexOf(item)) && -1 === set.items.indexOf(item)) {
            set.items.push(item);
          }
        }
      }
    }
    return set;
  };

  Set.prototype.difference = function() {
    var i, idx, item, items, j, k, l, len, len1, len2, len3, set, sets;
    sets = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    set = this.clone();
    if (typeof this._handler === 'function') {
      for (i = 0, len = sets.length; i < len; i++) {
        items = sets[i];
        items = (items instanceof Set ? items.items : items) || [];
        for (j = 0, len1 = items.length; j < len1; j++) {
          item = items[j];
          if (this._handler(set.items).has(item)) {
            this._handler(set.items).remove(item);
          } else {
            this._handler(set.items).add(item);
          }
        }
      }
    } else {
      for (k = 0, len2 = sets.length; k < len2; k++) {
        items = sets[k];
        items = (items instanceof Set ? items.items : items) || [];
        for (l = 0, len3 = items.length; l < len3; l++) {
          item = items[l];
          if (-1 !== (idx = set.items.indexOf(item))) {
            set.items.splice(idx, 1);
          } else {
            set.items.push(item);
          }
        }
      }
    }
    return set;
  };

  Set.prototype.intersect = function() {
    var i, intersect, item, items, j, k, l, len, len1, len2, len3, ref, ref1, set, sets, union;
    sets = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    union = this.union.apply(this, sets);
    sets.push(this.items);
    set = (new Set).handler(this._handler);
    if (typeof this._handler === 'function') {
      ref = union.items;
      for (i = 0, len = ref.length; i < len; i++) {
        item = ref[i];
        intersect = true;
        for (j = 0, len1 = sets.length; j < len1; j++) {
          items = sets[j];
          if (!this._handler(items).has(item)) {
            intersect = false;
            break;
          }
        }
        if (intersect) {
          this._handler(set.items).add(item);
        }
      }
    } else {
      ref1 = union.items;
      for (k = 0, len2 = ref1.length; k < len2; k++) {
        item = ref1[k];
        intersect = true;
        for (l = 0, len3 = sets.length; l < len3; l++) {
          items = sets[l];
          if (-1 === items.indexOf(item)) {
            intersect = false;
            break;
          }
        }
        if (intersect) {
          set.items.push(item);
        }
      }
    }
    return set;
  };

  return Set;

})();

},{}]},{},[1])