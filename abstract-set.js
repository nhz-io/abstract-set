(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var AbstractElement,
  extend = require("extends__"),
  hasProp = {}.hasOwnProperty;

module.exports = AbstractElement = (function(superClass) {
  extend(AbstractElement, superClass);

  function AbstractElement(data) {
    var key, value;
    if (data == null) {
      data = [];
    }
    data = (typeof data.valueOf === "function" ? data.valueOf() : void 0) || data;
    for (key in data) {
      value = data[key];
      this[key] = value;
    }
    if (data.length != null) {
      this.length = data.length;
    }
  }

  AbstractElement.prototype.clone = function() {
    return new this.constructor(this);
  };

  AbstractElement.prototype.toArray = function() {
    var key, result, value;
    result = [];
    for (key in this) {
      value = this[key];
      if (this.hasOwnProperty(key)) {
        result[key] = value;
      }
    }
    return result;
  };

  AbstractElement.prototype.toObject = function() {
    var key, result, value;
    result = {};
    for (key in this) {
      value = this[key];
      if (this.hasOwnProperty(key)) {
        result[key] = value;
      }
    }
    return result;
  };

  AbstractElement.prototype.toString = function() {
    try {
      return JSON.stringify(this);
    } catch (_error) {}
  };

  AbstractElement.prototype.toJSON = function() {
    var key, result, value;
    result = {};
    for (key in this) {
      value = this[key];
      if (this.hasOwnProperty(key)) {
        if (typeof (value != null ? value.toJSON : void 0) === 'function') {
          value = value.toJSON();
        }
        result[key] = value;
      }
    }
    return result;
  };

  AbstractElement.prototype.valueOf = function() {
    var key, result, value;
    result = [];
    for (key in this) {
      value = this[key];
      if (this.hasOwnProperty(key)) {
        if (typeof (value != null ? value.valueOf : void 0) === 'function') {
          value = value.valueOf();
        }
        result[key] = value;
      }
    }
    return result;
  };

  return AbstractElement;

})(Array);

},{"extends__":4}],2:[function(require,module,exports){
(function() {
  return this.AbstractSet = {
    Set: require('./set'),
    Element: require('./element')
  };
})();

},{"./element":1,"./set":3}],3:[function(require,module,exports){
var AbstractElement, AbstractSet,
  extend = require("extends__"),
  hasProp = {}.hasOwnProperty,
  slice = [].slice;

AbstractElement = require('./element');

module.exports = AbstractSet = (function(superClass) {
  extend(AbstractSet, superClass);

  function AbstractSet(elements) {
    var element, j, len;
    if (elements == null) {
      elements = [];
    }
    for (j = 0, len = elements.length; j < len; j++) {
      element = elements[j];
      if (!element) {
        continue;
      }
      switch (false) {
        case !(element instanceof AbstractElement):
          this.add(element);
          break;
        case !(element instanceof Object):
          this.add(new AbstractElement(element));
      }
    }
  }

  AbstractSet.prototype.add = function(element) {
    if (element instanceof AbstractElement && -1 === this.indexOf(element)) {
      this.push(element);
    }
    return this;
  };

  AbstractSet.prototype.has = function(element) {
    if (-1 !== this.indexOf(element)) {
      return true;
    } else {
      return false;
    }
  };

  AbstractSet.prototype.remove = function(element) {
    var i;
    if (-1 !== (i = this.indexOf(element))) {
      this.splice(i, 1);
    }
    return this;
  };

  AbstractSet.prototype.union = function() {
    var element, j, k, len, len1, result, set, sets;
    sets = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    result = this.clone();
    for (j = 0, len = sets.length; j < len; j++) {
      set = sets[j];
      for (k = 0, len1 = set.length; k < len1; k++) {
        element = set[k];
        result.add(element);
      }
    }
    return result;
  };

  AbstractSet.prototype.difference = function() {
    var element, j, k, len, len1, result, set, sets, union;
    sets = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    result = this.clone();
    for (j = 0, len = sets.length; j < len; j++) {
      set = sets[j];
      union = result.union(set);
      for (k = 0, len1 = union.length; k < len1; k++) {
        element = union[k];
        if ((result.has(element)) && (set.has(element))) {
          union.remove(element);
        }
      }
      result = union;
    }
    return result;
  };

  AbstractSet.prototype.intersect = function() {
    var _count, count, element, j, k, len, len1, result, set, sets, union;
    sets = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    union = this.union.apply(this, sets);
    result = union.clone();
    count = sets.length + 1;
    for (j = 0, len = union.length; j < len; j++) {
      element = union[j];
      _count = this.has(element) ? 1 : 0;
      for (k = 0, len1 = sets.length; k < len1; k++) {
        set = sets[k];
        if (set.has(element)) {
          _count++;
        }
      }
      if (_count !== count) {
        result.remove(element);
      }
    }
    return result;
  };

  return AbstractSet;

})(AbstractElement);

},{"./element":1,"extends__":4}],4:[function(require,module,exports){
var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

module.exports = function(ChildClass, ParentClass) {
  return extend(ChildClass, ParentClass);
};

},{}]},{},[2])