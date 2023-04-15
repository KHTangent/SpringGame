package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import objects.Player;

class PlayState extends FlxState {
	private inline static var GRAVITY:Float = 200;

	private var terrainGen:TerrainGen;
	private var player:Player;
	private var segments:FlxSpriteGroup;
	private var pVelocity:FlxPoint;
	private var debugDot:FlxSprite;

	override public function create() {
		super.create();
		pVelocity = new FlxPoint(0, 10);
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
		for (point in terrainGen.terrainPoints) {
			var t = new FlxSprite(point.x - 3, point.y - 3);
			t.makeGraphic(6, 6, FlxColor.BLUE);
			add(t);
		}

		player = new Player(200, 0);
		add(player);
		debugDot = new FlxSprite(0);
		debugDot.makeGraphic(4, 4, FlxColor.RED);
		add(debugDot);

		FlxG.camera.follow(player, LOCKON);
		FlxG.worldBounds.set(0, 0, segments.width, segments.height);
	}

	private var skipGravity = false;

	override public function update(elapsed:Float) {
		super.update(elapsed);
		if (FlxG.keys.pressed.CONTROL && FlxG.keys.justReleased.R) {
			FlxG.resetGame();
		}
		if (!skipGravity) {
			pVelocity.y += GRAVITY * elapsed;
		}
		var playerPos = new FlxPoint(player.x + player.width / 2, player.y + player.height);
		var nextPos = FlxPoint.get(playerPos.x + pVelocity.x * elapsed, playerPos.y + pVelocity.y * elapsed);
		for (i in 1...terrainGen.terrainPoints.length) {
			var lineStart = terrainGen.terrainPoints[i - 1];
			var lineEnd = terrainGen.terrainPoints[i];
			var intersection = intersectsBounded(playerPos, nextPos, lineStart, lineEnd);
			if (intersection == null) {
				continue;
			}
			nextPos = intersection;
			skipGravity = true;
			pVelocity.set(0, 0);
			debugDot.setPosition(intersection.x, intersection.y);
			for (i in 0...10) {
				var s = new FlxSprite(lineStart.x + (lineEnd.x - lineStart.x) / 10 * i, lineStart.y + (lineEnd.y - lineStart.y) / 10 * i);
				s.makeGraphic(4, 4, FlxColor.YELLOW);
				add(s);
			}
			break;
		}
		player.setPosition(nextPos.x - player.width / 2, nextPos.y - player.height);
		debugDot.setPosition(playerPos.x, playerPos.y);
		nextPos.put();
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
	private function intersectsBounded(l1s:FlxPoint, l1e:FlxPoint, l2s:FlxPoint, l2e:FlxPoint):FlxPoint {
		// trace("l1s:", l1s.x, l1s.y);
		// trace("l1e:", l1e.x, l1e.y);
		// trace("l2s:", l2s.x, l2s.y);
		// trace("l2e:", l2e.x, l2e.y);
		var intersection = lineIntersection(l1s, l1e, l2s, l2e);
		if (intersection == null) {
			return null;
		}
		if ((intersection.x >= l1s.x && intersection.x <= l1e.x || intersection.x >= l1e.x && intersection.x <= l1s.x)
			&& (intersection.y >= l1s.y && intersection.y <= l1e.y || intersection.y >= l1e.y && intersection.y <= l1s.y)
			&& (intersection.x >= l2s.x && intersection.x <= l2e.x || intersection.x >= l2e.x && intersection.x <= l2s.x)
			&& (intersection.y >= l2s.y && intersection.y <= l2e.y || intersection.y >= l2e.y && intersection.y <= l2s.y)) {
			return intersection;
		}
		else {
			return null;
		}
	}
}
