package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.nape.FlxNapeSpace;
import flixel.util.FlxColor;
import objects.Player;

class PlayState extends FlxState {
	private var terrainGen:TerrainGen;
	private var player:Player;

	override public function create() {
		super.create();
		FlxNapeSpace.init();
		FlxNapeSpace.space.gravity.setxy(0, 500);
		terrainGen = new TerrainGen(64);
		var segment = terrainGen.getTerrain(FlxColor.GREEN);
		segment.y += 256;
		add(segment);

		player = new Player(64, 64);
		add(player);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		if (FlxG.keys.pressed.CONTROL && FlxG.keys.justReleased.R) {
			FlxG.resetGame();
		}
	}
}
