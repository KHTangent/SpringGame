package objects;

import TerrainGen.TileTypes;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class Segment extends FlxSprite {
	public var terrainPoints:Array<FlxPoint> = [];

	public function new(x:Float, y:Float, data:Array<Array<Int>>, tileSize = 64) {
		super(x, y);
		var interpolatedPoints = interpolatePoints(x, y, data, tileSize);
		makeGraphic(data[0].length * tileSize, data.length * tileSize, FlxColor.TRANSPARENT);
		this.drawPolygon(interpolatedPoints, FlxColor.GREEN);
	}

	private function interpolatePoints(x:Float, y:Float, segment:Array<Array<Int>>, tileSize:Int):Array<FlxPoint> {
		var points = [FlxPoint.weak(0, 0)];
		var maxX = segment[0].length;
		var maxY = segment.length;
		var currentX = 0;
		var currentY = 0;
		while (currentX < maxX && currentY < maxY) {
			while (segment[currentY][currentX] != TileTypes.SOLID) {
				currentY++;
			}
			while (segment[currentY][currentX] == TileTypes.SOLID) {
				currentX++;
			}
			points.push(FlxPoint.weak(currentX * tileSize, (currentY + 1) * tileSize));
			terrainPoints.push(FlxPoint.get(currentX * tileSize + x, (currentY + 1) * tileSize + y));
		}
		points.push(FlxPoint.weak(maxX * tileSize, maxY * tileSize));
		terrainPoints.push(FlxPoint.get(maxX * tileSize + x, maxY * tileSize + y));
		points.push(FlxPoint.weak(0, maxY * tileSize));
		return points;
	}
}
