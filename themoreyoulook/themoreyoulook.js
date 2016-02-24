
var sketch = function(p) {
	// Constants.
	var shapeLength, k, c, friction, rotateRadius, stepDiff, background

	var width  = 600
	var height = 600
	var TAU    = Math.PI * 2

	// Variables.
	var shapes
	var step = 0

	p.setup = function() {
		p.createCanvas(width, height)

		shapeLength  = 50
		k            = 0.0001
		c            = 9000.00000
		friction     = 0.5
		rotateRadius = 4.0
		stepDiff     = 0.003

		shapes = _.map(_.range(150), function(index) {
			var p1  = p.createVector(_.random(0, width, true), _.random(0, height, true))
			var p2  = p5.Vector.random2D().mult(shapeLength + _.random(-8,8)).add(p1)
			var pAv = p5.Vector.add(p1, p2).div(2)
			var shape       = new Shape([p1, p2, pAv])
			shape.drawShape = function(dx, dy) {
				p.line(this.points[0].x + dx, this.points[0].y + dy, this.points[1].x + dx, this.points[1].y + dy)
			}
			return shape
		})
		_.each(_.range(20), function() {
			_.each(shapes, function(shape) {
				shape.force()
			})
		})
		p.stroke(222, 66, 66)
		p.strokeWeight(14)
		p.strokeCap(p.ROUND)
		background = function() {
			p.background(255, 225, 101)
		}
	}


	p.draw = function() {
		background()
		_.each(shapes, function(shape) {
			shape.draw()
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

	var Shape = function(points) {
		this.points       = points
		this.v            = p.createVector(0, 0)
		this.rotateOffset = _.random(0, Math.PI * 2, true)
		this.flip         = Math.random() < 0.5
	}

	Shape.prototype.force = function() {
		var _this = this
		var a     = p.createVector(0, 0)

		var pAv = p.createVector(0, 0)
		_.each(_this.points, function(point) {
			pAv.add(point)
		})
		pAv.div(_this.points.length)

		_.each(shapes, function(other) {
			if (other !== _this) {
				_.each(other.points, function(otherPoint) {
					a.add(spring(pAv, otherPoint))
					a.add(coloumb(pAv, otherPoint))
				})
			}
		})

		_this.v.add(a)
		_this.v.mult(friction)

		_.each(_this.points, function(point) {
			point.add(_this.v)
		})
	}

	Shape.prototype.draw = function() {
		var thisStep = this.flip ? step : step * -1
		var dx       = Math.cos(thisStep + this.rotateOffset) * rotateRadius
		var dy       = Math.sin(thisStep + this.rotateOffset) * rotateRadius
		this.drawShape(dx, dy)
	}

}

var instance = new p5(sketch, document.querySelector("#canvas"))
