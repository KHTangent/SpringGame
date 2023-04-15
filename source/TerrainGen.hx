package;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

enum abstract TileTypes(Int) to Int {
	var EMPTY = 0;
	var SOLID = 1;
}

class TerrainGen {
	private var tileSize:Int;
	private var sampleTerrain = [
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
	];

	public function new(tileSize:Int) {
		this.tileSize = tileSize;
	}

	public function getTerrain(x:Float, y:Float, color:FlxColor):FlxSprite {
		var segment = sampleTerrain;
		var terrain = new FlxSprite(x, y);
		terrain.makeGraphic(segment[0].length * tileSize, segment.length * tileSize, FlxColor.TRANSPARENT);
		terrain.drawPolygon(interpolatePoints(segment), color);
		return terrain;
	}

	private function interpolatePoints(segment:Array<Array<Int>>):Array<FlxPoint> {
		var points = [];
		var maxX = segment[0].length;
		var maxY = segment.length;
		var currentX = 0;
		var currentY = 0;
		while (currentX < maxX && currentY < maxY) {
			while (segment[currentY][currentX] != TileTypes.SOLID) {
				currentY++;
			}
			points.push(FlxPoint.weak(currentX * tileSize, currentY * tileSize));
			while (segment[currentY][currentX] == TileTypes.SOLID) {
				currentX++;
			}
			points.push(FlxPoint.weak(currentX * tileSize, (currentY + 1) * tileSize));
		}
		points.push(FlxPoint.weak(maxX * tileSize, maxY * tileSize));
		points.push(FlxPoint.weak(0, maxY * tileSize));
		return points;
	}
}
