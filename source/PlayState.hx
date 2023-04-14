package;

import flixel.FlxState;
import flixel.util.FlxColor;
import objects.Player;

class PlayState extends FlxState {
	private var terrainGen:TerrainGen;

	override public function create() {
		super.create();
		terrainGen = new TerrainGen(32);
		var segment = terrainGen.getTerrain(FlxColor.GREEN);
		add(segment);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
}
