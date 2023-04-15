package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

enum abstract TileTypes(Int) to Int {
	var EMPTY = 0;
	var SOLID = 1;
}

class TerrainGen {
	public var terrainPoints:Array<FlxPoint> = [];

	private var tileSize:Int;
	private var terrains = [
		[
			[1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			[1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			[1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			[1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0],
			[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0],
			[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		],
		[
			[1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			[1, 1, 0, 0, 0, 0, 0, 0, 0, 0],
			[1, 1, 0, 0, 0, 0, 0, 0, 0, 0],
			[1, 1, 0, 0, 0, 0, 0, 0, 0, 0],
			[1, 1, 1, 0, 0, 0, 0, 0, 0, 0],
			[1, 1, 1, 1, 1, 1, 0, 0, 0, 0],
			[1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
			[1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		],
		[[1, 0, 0], [1, 1, 0], [1, 1, 1]]
	];

	public function new(tileSize:Int) {
		this.tileSize = tileSize;
	}

	public function getTerrain(x:Float, y:Float, color:FlxColor):FlxSprite {
		if (terrainPoints.length == 0) {
			terrainPoints.push(FlxPoint.get(x, y));
		}
		var segment = terrains[FlxG.random.int(0, terrains.length - 1)];
		var terrain = new FlxSprite(x, y);
		terrain.makeGraphic(segment[0].length * tileSize, segment.length * tileSize, FlxColor.TRANSPARENT);
		terrain.drawPolygon(interpolatePoints(x, y, segment), color);
		return terrain;
	}

	private function interpolatePoints(x:Float, y:Float, segment:Array<Array<Int>>):Array<FlxPoint> {
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
