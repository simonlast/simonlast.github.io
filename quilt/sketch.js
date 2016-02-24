
var sketch = function(p) {
	var width        = 600
	var height       = 600
	var TAU          = Math.PI * 2

	var numRows      = 20
	var numCols      = 20
	var cornerRadius = 3
	var rows         = []
	var rotateRadius = 4.0
	var currentStep  = 0
	var stepAmount   = 0.002

	p.setup = function() {
		p.createCanvas(width, height)
		p.smooth()

		_.each(_.range(numCols), function(iY) {
			const row = []
			_.each(_.range(numRows), function(iX) {
				const x = width * (iX / numRows) + (width / numRows / 2)
				const y = height * (iY / numRows) + (width / numRows / 2)
				row.push(new Point(x, y))
			})
			rows.push(row)
		})
	}

	p.draw = function() {
		p.background(255, 255, 255)

		p.strokeWeight(2)
		p.stroke(60,60,60)
		_.each(rows, function(row, iY) {
			_.each(row, function(point, iX) {
				var pos        = point.currentPosition(currentStep)
				var rightPoint = row[iX + 1]
				var belowRow   = rows[iY + 1]
				if (rightPoint && belowRow) {
					var rightPointPos      = rightPoint.currentPosition(currentStep)
					var belowPoint         = belowRow[iX]
					var belowPointPos      = belowPoint.currentPosition(currentStep)
					var belowRightPoint    = belowRow[iX + 1]
					var belowRightPointPos = belowRightPoint.currentPosition(currentStep)
					var averageDist        = (pos.dist(rightPointPos) + pos.dist(belowRightPointPos) + pos.dist(belowPointPos)) / 3
					var opacity            = (averageDist - 25.0) / (40.0 - 25.0)

					p.fill(p.color(96 * opacity, 201 * opacity, 191 * opacity, 210))
					p.quad(
						pos.x, pos.y,
						rightPointPos.x, rightPointPos.y,
						belowRightPointPos.x, belowRightPointPos.y,
						belowPointPos.x, belowPointPos.y
					)
				}
			})
		})

		currentStep += stepAmount
	}

	var Point = function(x, y) {
		this.p            = p.createVector(x, y)
		this.rotateOffset = _.random(0, Math.PI * 2, true)
		this.flip         = Math.random() < 0.5
		this.multiplier   = _.random(-3,3,true)
	}

	Point.prototype.currentPosition = function(step) {
		if (this.flip) {
			step *= -1
		}
		var dx = Math.cos((step * this.multiplier) + this.rotateOffset) * rotateRadius
		var dy = Math.sin((step * this.multiplier) + this.rotateOffset) * rotateRadius
		return p5.Vector.sub(this.p, p.createVector(dx, dy))
	}

}

var instance = new p5(sketch, document.querySelector("#canvas"))
