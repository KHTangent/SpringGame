package;

import flixel.FlxState;
import flixel.util.FlxColor;
import objects.Player;

class PlayState extends FlxState {
	private var terrainGen:TerrainGen;

	override public function create() {
		super.create();
		terrainGen = new TerrainGen(64);
		var segment = terrainGen.getTerrain(FlxColor.GREEN);
		segment.y += 256;
		add(segment);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
}
