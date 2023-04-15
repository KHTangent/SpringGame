package;

import flixel.addons.display.FlxBackdrop;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import objects.Bomb;
import objects.Player;
import objects.Springroll;

class PlayState extends FlxState {
	private inline static var GRAVITY:Float = 800;
	private inline static var DRAG_CO:Float = 0.0000005;
	private inline static var GENERATION_TRESHOLD = 1280 * 3;
	private inline static var GENERATION_BATCH = 4;

	private var FRICTION:Array<Float> = [0.15, 0.35];

	private var pVelocity:FlxPoint;
	private var groundedBuffer:Int = 0;
	private var score:Int = 0;
	private var braking = false;
	private var terrainX = 0.0;
	private var terrainY = 256.0;

	private var terrainGen:TerrainGen;
	private var player:Player;
	private var segments:FlxSpriteGroup;
	private var segmentPaddings:FlxSpriteGroup;
	private var debugDot:FlxSprite;
	private var springrolls:FlxSpriteGroup;
	private var bombs:FlxSpriteGroup;
	private var hud:HUD;
	private var splashHUD:SplashHUD;
	private var gameStarted = false;

	override public function create() {
		super.create();

		for (i in 0...5) {
			var bg = new FlxBackdrop('assets/images/background/layer$i.png', X);
			bg.scrollFactor.set(0.1 * i, 0);
			add(bg);
		}

		pVelocity = new FlxPoint(10, 0);
		terrainGen = new TerrainGen(64);
		segments = new FlxSpriteGroup();
		segmentPaddings = new FlxSpriteGroup();
		springrolls = new FlxSpriteGroup();
		bombs = new FlxSpriteGroup();

		for (_ in 0...GENERATION_BATCH) {
			addSegment();
		}
		add(segments);
		add(segmentPaddings);
		add(springrolls);
		add(bombs);
		// for (p in terrainGen.terrainPoints) {
		// 	var dot = new FlxSprite(p.x - 2, p.y - 2);
		// 	dot.makeGraphic(4, 4, FlxColor.BLUE);
		// 	add(dot);
		// }

		player = new Player(32, 0);
		add(player);
		debugDot = new FlxSprite(0);
		debugDot.makeGraphic(4, 4, FlxColor.RED);
		add(debugDot);

		hud = new HUD();
		add(hud);

		FlxG.camera.follow(player, LOCKON);
		FlxG.camera.setScrollBounds(0, null, null, null);
		FlxG.camera.targetOffset.set(300, 50);
		FlxG.worldBounds.set(0, 0, segments.width, segments.height);

		splashHUD = new SplashHUD();
		add(splashHUD);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		if (!gameStarted) {
			if (FlxG.keys.justPressed.SPACE) {
				gameStarted = true;
				splashHUD.kill();
			}
			return;
		}
		handleMovement(elapsed);
		braking = FlxG.keys.pressed.SHIFT;
		player.grounded = groundedBuffer > 0;

		FlxG.overlap(player, springrolls, (player:Player, springroll:Springroll) -> {
			score += springroll.value;
			springroll.kill();
			hud.setScore(score);
		});
		FlxG.overlap(player, bombs, (player:Player, bomb:Bomb) -> {
			player.kill();
			FlxG.camera.target = null;
			FlxG.camera.fade(FlxColor.BLACK, 1.5, FlxG.resetGame, true);
			bomb.kill();
		});

		while (terrainX - player.x < GENERATION_TRESHOLD) {
			for (i in 0...GENERATION_BATCH) {
				addSegment();
			}
			FlxG.worldBounds.set(0, 0, terrainX, terrainY);
			segments.forEachAlive((segment:FlxSprite) -> {
				if (segment.x < player.x - FlxG.width * 2) {
					segment.destroy();
				}
			});
			segmentPaddings.forEachAlive((padding:FlxSprite) -> {
				if (padding.x < player.x - FlxG.width * 2) {
					padding.destroy();
				}
			});
		}
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
			var frictionVector = pVelocity.clone().scale(-FRICTION[braking ? 1 : 0]);
			pVelocity.add(frictionVector.x, frictionVector.y);

			break;
		}
		if (hasTouched) {
			groundedBuffer = 10;
		}
		else {
			groundedBuffer--;
		}
		if (player.jumpAddVector != null) {
			pVelocity.add(player.jumpAddVector.x, player.jumpAddVector.y);
			player.jumpAddVector = null;
		}

		var pSpeed = Math.sqrt(pVelocity.x * pVelocity.x + pVelocity.y + pVelocity.y);
		var dragX = -(pVelocity.x / pSpeed) * pVelocity.x * pVelocity.x * DRAG_CO;
		var dragY = -(pVelocity.y / pSpeed) * pVelocity.y * pVelocity.y * DRAG_CO;

		pVelocity.add(dragX, dragY);

		player.falling = (pVelocity.y > 0);

		var nextPos = FlxPoint.get(playerPos.x + pVelocity.x * elapsed, playerPos.y + pVelocity.y * elapsed);
		player.setPosition(nextPos.x - player.width / 2, nextPos.y - player.height - 1);
		debugDot.setPosition(playerPos.x, playerPos.y);
		predicted.put();
	}

	private function addSegment() {
		var segment = terrainGen.getTerrain(terrainX, terrainY);
		segment.immovable = true;
		segments.add(segment);
		springrolls.add(segment.springrolls);
		bombs.add(segment.bombs);
		var padding = new FlxSprite(terrainX, terrainY + segment.height);
		padding.makeGraphic(Std.int(segment.width), FlxG.height * 2, FlxColor.GREEN);
		segmentPaddings.add(padding);
		terrainX += segment.width;
		terrainY += segment.height;
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
