// Generated by CoffeeScript 1.10.0
(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  Dashing.List2 = (function(superClass) {
    extend(List2, superClass);

    function List2() {
      return List2.__super__.constructor.apply(this, arguments);
    }

    List2.prototype.ready = function() {
      if (this.get('unordered')) {
        return $(this.node).find('ol').remove();
      } else {
        return $(this.node).find('ul').remove();
      }
    };

    return List2;

  })(Dashing.Widget);

}).call(this);
