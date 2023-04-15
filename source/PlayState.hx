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
	private inline static var GRAVITY:Float = 800;
	private inline static var FRICTION:Float = 0.15;

	private var terrainGen:TerrainGen;
	private var player:Player;
	private var segments:FlxSpriteGroup;
	private var pVelocity:FlxPoint;
	private var debugDot:FlxSprite;
	private var groundedBuffer:Int = 0;

	override public function create() {
		super.create();
		pVelocity = new FlxPoint(0, 10);
		terrainGen = new TerrainGen(64);
		segments = new FlxSpriteGroup();
		var terrainX = 0.0;
		var terrainY = 256.0;
		for (_ in 0...20) {
			var segment = terrainGen.getTerrain(terrainX, terrainY);
			terrainX += segment.width;
			terrainY += segment.height;
			segment.immovable = true;
			segments.add(segment);
		}
		add(segments);

		player = new Player(200, 0);
		add(player);
		debugDot = new FlxSprite(0);
		debugDot.makeGraphic(4, 4, FlxColor.RED);
		add(debugDot);

		FlxG.camera.follow(player, LOCKON);
		FlxG.worldBounds.set(0, 0, segments.width, segments.height);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		if (FlxG.keys.pressed.CONTROL && FlxG.keys.justReleased.R) {
			FlxG.resetGame();
		}
		handleMovement(elapsed);
		player.grounded = groundedBuffer > 0;
	}

	private function handleMovement(elapsed:Float) {
		pVelocity.y += GRAVITY * elapsed;
		var playerPos = new FlxPoint(player.x + player.width / 2, player.y + player.height);
		var predicted = FlxPoint.get(playerPos.x + pVelocity.x * elapsed, playerPos.y + pVelocity.y * elapsed);
		var hasTouched = false;
		for (i in 1...terrainGen.terrainPoints.length) {
			var lineStart = terrainGen.terrainPoints[i - 1];
			var lineEnd = terrainGen.terrainPoints[i];
			var intersection = intersectsBounded(playerPos, predicted, lineStart, lineEnd);
			if (intersection == null) {
				continue;
			}
			hasTouched = true;
			predicted = intersection;
			var normalVector = (new FlxPoint(lineEnd.y - lineStart.y, lineStart.x - lineEnd.x)).normalize();
			player.origin.x = player.width / 2;
			player.origin.y = player.height;
			player.angle = Math.atan2(normalVector.y, normalVector.x) * FlxAngle.TO_DEG + 90;
			debugDot.setPosition(intersection.x, intersection.y);
			var normalForce = pVelocity.dotProduct(normalVector);
			pVelocity.x -= normalVector.x * normalForce;
			pVelocity.y -= normalVector.y * normalForce;
			var frictionVector = pVelocity.clone().scale(-FRICTION);
			pVelocity.add(frictionVector.x, frictionVector.y);
			break;
		}
		if (hasTouched) {
			groundedBuffer = 5;
		}
		else {
			groundedBuffer--;
		}
		if (player.jumpAddVector != null) {
			pVelocity.add(player.jumpAddVector.x, player.jumpAddVector.y);
			player.jumpAddVector = null;
		}
		var nextPos = FlxPoint.get(playerPos.x + pVelocity.x * elapsed, playerPos.y + pVelocity.y * elapsed);
		player.setPosition(nextPos.x - player.width / 2, nextPos.y - player.height - 1);
		debugDot.setPosition(playerPos.x, playerPos.y);
		predicted.put();
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
