package objects;

import TerrainGen.TileTypes;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class Segment extends FlxSprite {
	public var terrainPoints:Array<FlxPoint> = [];
	public var deathTriggers:FlxSpriteGroup;
	public var springrolls:FlxSpriteGroup;
	public var bombs:FlxSpriteGroup;

	public function new(x:Float, y:Float, data:Array<Array<Int>>, tileSize = 64) {
		super(x, y);
		var interpolatedPoints = interpolatePoints(x, y, data, tileSize);
		makeGraphic(data[0].length * tileSize, data.length * tileSize, FlxColor.TRANSPARENT, true);
		antialiasing = true;
		this.drawPolygon(interpolatedPoints, FlxColor.GREEN);
		for (i in 1...interpolatedPoints.length - 1) {
			this.drawLine(interpolatedPoints[i - 1].x, interpolatedPoints[i - 1].y, interpolatedPoints[i].x, interpolatedPoints[i].y, {
				color: FlxColor.fromRGB(0, 100, 0),
				thickness: 3
			});
		}
		deathTriggers = new FlxSpriteGroup();
		springrolls = new FlxSpriteGroup();
		bombs = new FlxSpriteGroup();

		for (tileY in 0...data.length) {
			for (tileX in 0...data[tileY].length) {
				switch (data[tileY][tileX]) {
					case DEATH:
						bombs.add(new Bomb(x + tileX * tileSize, y + tileY * tileSize));
					case SPRINGROLL:
						springrolls.add(new Springroll(x + tileX * tileSize, y + tileY * tileSize, 10));
					case SUPERROLL:
						springrolls.add(new Springroll(x + tileX * tileSize, y + tileY * tileSize, 40));
					default:
						continue;
				}
			}
		}
	}

	override function kill() {
		springrolls.kill();
		deathTriggers.kill();
		super.kill();
	}

	override function destroy() {
		springrolls.destroy();
		deathTriggers.destroy();
		super.destroy();
	}

	private function interpolatePoints(x:Float, y:Float, segment:Array<Array<Int>>, tileSize:Int):Array<FlxPoint> {
		var points = [FlxPoint.weak(0, 0)];
		var maxX = segment[0].length;
		var maxY = segment.length;
		// Start in the top left corner
		var currentX = 0;
		var currentY = 0;
		while (currentX < maxX && currentY < maxY) {
			// Move down until we hit a solid tile
			while (segment[currentY][currentX] != TileTypes.SOLID) {
				currentY++;
			}
			// Move forward until we hit a non-solid tile
			while (segment[currentY][currentX] == TileTypes.SOLID) {
				currentX++;
			}
			// Draw from the previous point to the newly found corner
			points.push(FlxPoint.weak(currentX * tileSize, (currentY + 1) * tileSize));
			terrainPoints.push(new FlxPoint(currentX * tileSize + x, (currentY + 1) * tileSize + y));
		}
		points.push(FlxPoint.weak(maxX * tileSize, maxY * tileSize));
		terrainPoints.push(new FlxPoint(maxX * tileSize + x, maxY * tileSize + y));
		points.push(FlxPoint.weak(0, maxY * tileSize));
		return points;
	}
}
