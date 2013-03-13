// Generated by CoffeeScript 1.3.3
(function() {
  var CELL_WIDTH, Cell, Grid, HEIGHT, TYPE_COLORS, WIDTH;

  WIDTH = 800;

  HEIGHT = 600;

  CELL_WIDTH = 8;

  TYPE_COLORS = {
    "wall": "white",
    "empty": "black"
  };

  Cell = (function() {

    function Cell(grid, x, y) {
      this.grid = grid;
      this.x = x;
      this.y = y;
      this.currentStep = 1;
      this.fixed = false;
      this.type = Math.random() <= 0.4 ? "wall" : "empty";
    }

    Cell.prototype.fixAsWall = function() {
      this.fixed = true;
      return this.type = "wall";
    };

    Cell.prototype.computeStep = function() {
      var numberOfWalls, _ref, _ref1;
      if (this.fixed) {
        return;
      }
      numberOfWalls = this.grid.neighboursOfType(this, "wall").length;
      if (this.type === "wall") {
        numberOfWalls += 1;
      }
      if ((1 <= (_ref = this.currentStep) && _ref <= 4)) {
        this.nextType = numberOfWalls >= 5 || numberOfWalls === 0 ? "wall" : "empty";
      } else if ((5 <= (_ref1 = this.currentStep) && _ref1 <= 7)) {
        this.nextType = numberOfWalls >= 5 ? "wall" : "empty";
      } else {
        this.isFinished = true;
      }
      return ++this.currentStep;
    };

    Cell.prototype.finishStep = function() {
      if (this.fixed) {
        return;
      }
      return this.type = this.nextType;
    };

    Cell.prototype.draw = function(context) {
      context.fillStyle = TYPE_COLORS[this.type];
      return context.fillRect(this.x * CELL_WIDTH, this.y * CELL_WIDTH, CELL_WIDTH, CELL_WIDTH);
    };

    return Cell;

  })();

  Grid = (function() {

    function Grid() {
      var x, y, _i, _j, _ref, _ref1;
      this.width = Math.floor(WIDTH / CELL_WIDTH);
      this.height = Math.floor(HEIGHT / CELL_WIDTH);
      this.cells = [];
      for (x = _i = 0, _ref = this.width; 0 <= _ref ? _i < _ref : _i > _ref; x = 0 <= _ref ? ++_i : --_i) {
        this.cells[x] = [];
        for (y = _j = 0, _ref1 = this.height; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; y = 0 <= _ref1 ? ++_j : --_j) {
          this.cells[x][y] = new Cell(this, x, y);
        }
      }
      this.addBorderWalls();
    }

    Grid.prototype.addBorderWalls = function() {
      var x, y, _i, _j, _k, _len, _len1, _ref, _ref1, _ref2, _results;
      _ref = [0, this.width - 1];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        x = _ref[_i];
        for (y = _j = 0, _ref1 = this.height - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; y = 0 <= _ref1 ? ++_j : --_j) {
          this.cells[x][y].fixAsWall();
        }
      }
      _ref2 = [0, this.height - 1];
      _results = [];
      for (_k = 0, _len1 = _ref2.length; _k < _len1; _k++) {
        y = _ref2[_k];
        _results.push((function() {
          var _l, _ref3, _results1;
          _results1 = [];
          for (x = _l = 0, _ref3 = this.width - 1; 0 <= _ref3 ? _l <= _ref3 : _l >= _ref3; x = 0 <= _ref3 ? ++_l : --_l) {
            _results1.push(this.cells[x][y].fixAsWall());
          }
          return _results1;
        }).call(this));
      }
      return _results;
    };

    Grid.prototype.neighbours = function(cell) {
      var neighbours, x, y, _i, _j, _ref, _ref1, _ref2, _ref3;
      neighbours = [];
      for (x = _i = _ref = Math.max(0, cell.x - 1), _ref1 = Math.min(this.width - 1, cell.x + 1); _ref <= _ref1 ? _i <= _ref1 : _i >= _ref1; x = _ref <= _ref1 ? ++_i : --_i) {
        for (y = _j = _ref2 = Math.max(0, cell.y - 1), _ref3 = Math.min(this.height - 1, cell.y + 1); _ref2 <= _ref3 ? _j <= _ref3 : _j >= _ref3; y = _ref2 <= _ref3 ? ++_j : --_j) {
          if (x !== cell.x || y !== cell.y) {
            neighbours.push(this.cells[x][y]);
          }
        }
      }
      return neighbours;
    };

    Grid.prototype.neighboursOfType = function(cell, type) {
      var neighbour, _i, _len, _ref, _results;
      _ref = this.neighbours(cell);
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        neighbour = _ref[_i];
        if (neighbour.type === type) {
          _results.push(neighbour);
        }
      }
      return _results;
    };

    Grid.prototype.step = function() {
      var x, y, _i, _j, _k, _ref, _ref1, _ref2, _results;
      for (x = _i = 0, _ref = this.width; 0 <= _ref ? _i < _ref : _i > _ref; x = 0 <= _ref ? ++_i : --_i) {
        for (y = _j = 0, _ref1 = this.height; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; y = 0 <= _ref1 ? ++_j : --_j) {
          this.cells[x][y].computeStep();
          if (this.cells[x][y].isFinished) {
            this.isFinished = true;
          }
        }
      }
      if (this.isFinished) {
        return;
      }
      _results = [];
      for (y = _k = 0, _ref2 = this.height; 0 <= _ref2 ? _k < _ref2 : _k > _ref2; y = 0 <= _ref2 ? ++_k : --_k) {
        _results.push((function() {
          var _l, _ref3, _results1;
          _results1 = [];
          for (x = _l = 0, _ref3 = this.width; 0 <= _ref3 ? _l < _ref3 : _l > _ref3; x = 0 <= _ref3 ? ++_l : --_l) {
            _results1.push(this.cells[x][y].finishStep());
          }
          return _results1;
        }).call(this));
      }
      return _results;
    };

    Grid.prototype.stepUntilComplete = function() {
      var _results;
      _results = [];
      while (!this.isFinished) {
        _results.push(this.step());
      }
      return _results;
    };

    Grid.prototype.draw = function(context) {
      var x, y, _i, _ref, _results;
      _results = [];
      for (x = _i = 0, _ref = this.width; 0 <= _ref ? _i < _ref : _i > _ref; x = 0 <= _ref ? ++_i : --_i) {
        _results.push((function() {
          var _j, _ref1, _results1;
          _results1 = [];
          for (y = _j = 0, _ref1 = this.height; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; y = 0 <= _ref1 ? ++_j : --_j) {
            _results1.push(this.cells[x][y].draw(context));
          }
          return _results1;
        }).call(this));
      }
      return _results;
    };

    return Grid;

  })();

  $(function() {
    var $canvas, context, grid;
    $canvas = $("<canvas width=\"" + WIDTH + "\" height=\"" + HEIGHT + "\"></canvas>");
    $("body").append($canvas);
    context = $canvas[0].getContext("2d");
    context.fillStyle = "black";
    context.fillRect(0, 0, WIDTH, HEIGHT);
    grid = new Grid;
    grid.stepUntilComplete();
    return grid.draw(context);
  });

}).call(this);