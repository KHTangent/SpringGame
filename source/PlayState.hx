package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import objects.Player;

class PlayState extends FlxState {
	private inline static var GRAVITY:Float = 800;

	private var terrainGen:TerrainGen;
	private var player:Player;
	private var segments:FlxSpriteGroup;

	override public function create() {
		super.create();
		terrainGen = new TerrainGen(64);
		segments = new FlxSpriteGroup();
		var terrainX = 0.0;
		var terrainY = 256.0;
		for (_ in 0...5) {
			var segment = terrainGen.getTerrain(terrainX, terrainY, FlxColor.GREEN);
			terrainX += segment.width;
			terrainY += segment.height;
			segment.immovable = true;
			segments.add(segment);
		}
		add(segments);

		player = new Player(0, 0);
		player.origin.set(player.width / 2, player.height);
		player.acceleration.y = GRAVITY;
		add(player);

		FlxG.camera.follow(player, LOCKON);
		FlxG.worldBounds.set(0, 0, segments.width, segments.height);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		if (FlxG.keys.pressed.CONTROL && FlxG.keys.justReleased.R) {
			FlxG.resetGame();
		}
		var isTouchingSomething = false;
		segments.forEachAlive(segment -> {
			segment.drawFrame();
			if (playerIsTouching(segment)) {
				rotatePlayer();
				player.acceleration.set(0, 0);
				player.velocity.set(GRAVITY * FlxMath.fastSin(player.angle * FlxAngle.TO_RAD));
				player.velocity.rotateByDegrees(player.angle);
				isTouchingSomething = true;
			}
		});
		if (!isTouchingSomething) {
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
			if (segment.x > playerPositions[2] || segment.x + segment.width < playerPositions[0]) {
				return;
			}
			var bitmap = segment.framePixels;
			for (x in 0...playerPositions.length) {
				for (y in Std.int(segment.y)...Std.int(segment.y + segment.height)) {
					if (bitmap.getPixel(playerPositions[x] - Std.int(segment.x), Std.int(y - segment.y)) > 0) {
						pointsBelow[x] = y;
						break;
					}
				}
			}
		});
		if (pointsBelow[1] == -1.0) {
			player.angle = 0;
			return;
		}
		var w = playerPositions[2] - playerPositions[0];
		var h = pointsBelow[2] - pointsBelow[0];
		player.angle = Math.atan2(h, w) * FlxAngle.TO_DEG;
	}

	private function playerIsTouching(segment:FlxSprite):Bool {
		if (player.y < segment.y) {
			return false;
		}
		var playerMiddle = player.x + player.width / 2;
		var bitmap = segment.framePixels;
		if (bitmap.getPixel(Std.int(playerMiddle - segment.x), Std.int(player.y + player.height - segment.y)) > 0) {
			return true;
		}
		return false;
	}
}
