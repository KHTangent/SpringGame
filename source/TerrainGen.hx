package;

import flixel.FlxG;
import flixel.math.FlxPoint;
import objects.Segment;

using flixel.util.FlxSpriteUtil;

enum abstract TileTypes(Int) to Int {
	var EMPTY = 0;
	var SOLID = 1;
	var DEATH = 2;
	var SPRINGROLL = 3;
	var SUPERROLL = 4;
}

class TerrainGen {
	public var terrainPoints:Array<FlxPoint> = [];

	private var tileSize:Int;
	private var terrains:Array<Array<Array<Int>>> = [
		[
			[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
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
			[1, 1, 4, 0, 0, 0, 0, 0, 0, 0],
			[1, 1, 1, 0, 0, 0, 0, 0, 0, 0],
			[1, 1, 1, 1, 1, 1, 0, 0, 0, 0],
			[1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
			[1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		],
		[[1, 0, 0], [1, 1, 0], [1, 1, 1]],
		[
			[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			[1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0],
			[1, 1, 1, 1, 1, 0, 2, 2, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			[1, 1, 1, 1, 1, 1, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0],
			[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0],
			[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		],
		[
			[1, 0, 0, 0, 0, 0],
			[1, 0, 0, 0, 0, 0],
			[1, 0, 0, 0, 2, 0],
			[1, 0, 0, 0, 0, 0],
			[1, 0, 0, 0, 0, 0],
			[1, 0, 0, 0, 0, 0],
			[1, 0, 0, 0, 0, 0],
			[1, 1, 3, 0, 0, 0],
			[1, 1, 1, 1, 1, 1],
		]
	];

	public function new(tileSize:Int) {
		this.tileSize = tileSize;
	}

	public function getTerrain(x:Float, y:Float):Segment {
		if (terrainPoints.length == 0) {
			terrainPoints.push(FlxPoint.get(x, y));
		}
		var segment = terrains[FlxG.random.int(0, terrains.length - 1)];
		var terrain = new Segment(x, y, segment);
		for (p in terrain.terrainPoints) {
			this.terrainPoints.push(p.clone());
		}
		return terrain;
	}
}
