package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxAngle;
import flixel.util.FlxColor;
import objects.Player;

class PlayState extends FlxState {
	private inline static var GRAVITY:Float = 200;

	private var terrainGen:TerrainGen;
	private var player:Player;
	private var segments:FlxSpriteGroup;

	override public function create() {
		super.create();
		terrainGen = new TerrainGen(64);
		segments = new FlxSpriteGroup();
		var segment = terrainGen.getTerrain(0, 256, FlxColor.GREEN);
		segment.immovable = true;
		segments.add(segment);
		add(segments);

		player = new Player(0, 64);
		player.acceleration.y = GRAVITY;
		add(player);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		if (FlxG.keys.pressed.CONTROL && FlxG.keys.justReleased.R) {
			FlxG.resetGame();
		}
		if (FlxG.keys.pressed.F) {
			player.velocity.x = 5000 * elapsed;
		}
		else {
			player.velocity.x = 0;
		}
		if (FlxG.pixelPerfectOverlap(player, segments.getFirstAlive())) {
			player.acceleration.y = 0;
			player.velocity.y = 0;
			rotatePlayer();
		}
		else {
			player.acceleration.y = GRAVITY;
		}
	}

	private function rotatePlayer() {
		var playerPositions = [
			Std.int(player.x),
			Std.int(player.x + player.width / 2),
			Std.int(player.x + player.width)
		];
		var pointsBelow = [-1.0, -1.0, -1.0];
		segments.forEachAlive(segment -> {
			if (segment.x > playerPositions[1] || segment.x + segment.width < playerPositions[1]) {
				return;
			}
			var bitmap = segment.framePixels;
			for (x in 0...playerPositions.length) {
				for (y in Std.int(playerPositions[x])...Std.int(segment.y + segment.height)) {
					if (bitmap.getPixel(playerPositions[x] - Std.int(segment.x), Std.int(y - segment.y)) > 0) {
						pointsBelow[x] = y;
						break;
					}
				}
			}
		});
		if (pointsBelow[1] != -1.0 && pointsBelow[2] != -1.0) {
			var w = playerPositions[2] - playerPositions[1];
			var h = pointsBelow[2] - pointsBelow[1];
			player.angle = Math.atan2(h, w) * FlxAngle.TO_DEG;
		}
		else if (pointsBelow[0] != -1.0 && pointsBelow[1] != -1.0) {
			var w = playerPositions[1] - playerPositions[0];
			var h = pointsBelow[1] - pointsBelow[0];
			player.angle = Math.atan2(h, w) * FlxAngle.TO_DEG;
		}
		else {
			player.angle = 0;
		}
	}
}
