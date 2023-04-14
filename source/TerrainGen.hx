package;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class TerrainGen {
	private var tileSize:Int;
	private var sampleTerrain = [
		[0, 0, 0, 0, 0, 0, 0, 0],
		[1, 1, 0, 0, 0, 0, 0, 0],
		[1, 1, 1, 1, 0, 0, 0, 0],
		[1, 1, 1, 1, 1, 1, 0, 0],
		[1, 1, 1, 1, 1, 1, 1, 1],
	];

	public function new(tileSize:Int) {
		this.tileSize = tileSize;
	}

	public function getTerrain(color:FlxColor):FlxSprite {
		var segment = sampleTerrain;
		var terrain = new FlxSprite(0, 0);
		terrain.makeGraphic(segment[0].length * tileSize, segment.length * tileSize, FlxColor.TRANSPARENT);
		terrain.drawPolygon([
			FlxPoint.weak(0, 0),
			FlxPoint.weak(0, terrain.height),
			FlxPoint.weak(terrain.width, terrain.height),
		], color);
		return terrain;
	}
}
