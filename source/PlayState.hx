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

		player = new Player(0, 64);
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
			if (FlxG.pixelPerfectOverlap(player, segment)) {
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
			if (segment.x > playerPositions[1] || segment.x + segment.width < playerPositions[1]) {
				return;
			}
			segment.drawFrame();
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
		var w = 0.0, h = 0.0;
		if (pointsBelow[0] != -1.0 && pointsBelow[1] != -1.0) {
			w = playerPositions[1] - playerPositions[0];
			h = pointsBelow[1] - pointsBelow[0];
		}
		else if (pointsBelow[1] != -1.0 && pointsBelow[2] != -1.0) {
			w = playerPositions[2] - playerPositions[1];
			h = pointsBelow[2] - pointsBelow[1];
		}
		player.angle = Math.atan2(h, w) * FlxAngle.TO_DEG;
		// Compensate for player slightly sinking into the ground
		if (pointsBelow[1] < player.y + player.height) {
			player.y--;
		}
	}

	// Thanks, Copilot
	private function lineIntersection(l1s:FlxPoint, l1e:FlxPoint, l2s:FlxPoint, l2e:FlxPoint):FlxPoint {
		var a1 = l1e.y - l1s.y;
		var b1 = l1s.x - l1e.x;
		var c1 = a1 * l1s.x + b1 * l1s.y;
		var a2 = l2e.y - l2s.y;
		var b2 = l2s.x - l2e.x;
		var c2 = a2 * l2s.x + b2 * l2s.y;
		var det = a1 * b2 - a2 * b1;
		if (det == 0) {
			return null;
		}
		return new FlxPoint((b2 * c1 - b1 * c2) / det, (a1 * c2 - a2 * c1) / det);
	}

	// Thanks, Copilot
	private function intersectsBounded(l1s:FlxPoint, l1e:FlxPoint, l2s:FlxPoint, l2e:FlxPoint):Bool {
		var intersection = lineIntersection(l1s, l1e, l2s, l2e);
		if (intersection == null) {
			return false;
		}
		return (intersection.x >= l1s.x && intersection.x <= l1e.x || intersection.x >= l1e.x && intersection.x <= l1s.x)
			&& (intersection.y >= l1s.y && intersection.y <= l1e.y || intersection.y >= l1e.y && intersection.y <= l1s.y)
			&& (intersection.x >= l2s.x && intersection.x <= l2e.x || intersection.x >= l2e.x && intersection.x <= l2s.x)
			&& (intersection.y >= l2s.y && intersection.y <= l2e.y || intersection.y >= l2e.y && intersection.y <= l2s.y);
	}
}
