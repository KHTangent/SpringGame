package;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;

class SplashHUD extends FlxSpriteGroup {
	private var splashText:FlxText;
	private var blinkTimer:Float = 0;

	public function new() {
		super(0, 0);
		scrollFactor.set(0, 0);
		
		splashText = new FlxText(0, FlxG.height - 192, 0, "Press SPACE to start", 48);
		splashText.screenCenter(X);
		add(splashText);

		var titleText = new FlxText(0, 128, 0, "Springroll", 96);
		titleText.screenCenter(X);
		add(titleText);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		blinkTimer -= elapsed;
		if (blinkTimer < 0) {
			blinkTimer = 0.5;
			splashText.visible = !splashText.visible;
		}
	}
}
