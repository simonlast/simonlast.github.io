
var sketch = function(p) {
	// Constants.
	var width        = 600
	var height       = 600
	var lineLength   = 40
	var k            = 0.0001
	var c            = 8000.00000
	var friction     = 0.5
	var rotateRadius = 4.0
	var stepDiff     = 0.003

	// Variables.
	var lines
	var step = 0

	p.setup = function() {
		p.createCanvas(width, height)
		lines = _.map(_.range(150), function(index) {
			var p1 = p.createVector(_.random(0, width, true), _.random(0, height, true))
			var p2 = p5.Vector.random2D().mult(lineLength + _.random(-8,8)).add(p1)
			return new Line(p1, p2)
		})
		_.each(_.range(15), function() {
			_.each(lines, function(line) {
				line.force()
			})
		})
		p.stroke(222, 66, 66)
		p.strokeWeight(14)
		p.strokeCap(p.ROUND)
	}


	p.draw = function() {
		p.background(255, 225, 101)
		_.each(lines, function(line) {
			line.draw()
		})
		step += stepDiff
	}

	var spring = function(p1, p2) {
		return p5.Vector.sub(p2, p1).mult(k)
	}

	var coloumb = function(p1, p2) {
		var diff = p5.Vector.sub(p1, p2)
		var mag  = diff.mag()
		if (mag < 1) {
			mag = 1
		}
		return diff.normalize().mult((c / Math.pow(mag, 2)))
	}

	var Line = function(p1, p2) {
		this.p1           = p1
		this.p2           = p2
		this.v            = p.createVector(0, 0)
		this.rotateOffset = _.random(0, Math.PI * 2, true)
		this.flip         = Math.random() < 0.5
	}

	Line.prototype.force = function() {
		var _this = this
		var a     = p.createVector(0, 0)
		var pAv   = p5.Vector.add(_this.p1, _this.p2).div(2)

		_.each(lines, function(line) {
			if (line !== _this) {
				a.add(spring(pAv, line.p1))
				a.add(coloumb(pAv, line.p1))
				a.add(spring(pAv, line.p2))
				a.add(coloumb(pAv, line.p2))
			}
		})

		_this.v.add(a)
		_this.v.mult(friction)

		_this.p1.add(_this.v)
		_this.p2.add(_this.v)
	}

	Line.prototype.draw = function() {
		var thisStep = this.flip ? step : step * -1
		var dx       = Math.cos(thisStep + this.rotateOffset) * rotateRadius
		var dy       = Math.sin(thisStep + this.rotateOffset) * rotateRadius
		p.line(this.p1.x + dx, this.p1.y + dy, this.p2.x + dx, this.p2.y + dy)
	}

}

var instance = new p5(sketch, document.querySelector("#canvas"))
