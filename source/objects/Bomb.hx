package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter.FlxTypedEmitter;
import flixel.system.FlxSound;
import flixel.util.FlxColor;

class Bomb extends FlxSprite {
	private var explosionSound:FlxSound;

	public function new(x:Float, y:Float) {
		super(x, y);
		loadGraphic("assets/images/misc/bomb.png", false, 48, 48);
		explosionSound = FlxG.sound.load("assets/sounds/bomb.wav");
	}

	public function explode() {
		explosionSound.play();
		var explosion = new FlxTypedEmitter(x + width / 2, y + height / 2, 120);
		explosion.loadParticles("assets/images/misc/particle.png", 256);
		explosion.alpha.set(0.3, 1);
		explosion.color.set(FlxColor.RED, FlxColor.RED, FlxColor.YELLOW, FlxColor.YELLOW);
		explosion.lifespan.set(0.2, 1);
		explosion.speed.set(100, 200);
		explosion.launchMode = CIRCLE;
		explosion.launchAngle.set(0, 360);
		explosion.start(false, 0.001);
		super.kill();
		return explosion;
	}
}
