package;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;

using StringTools;

class SplashHUD extends FlxSpriteGroup {
	private var splashText:FlxText;
	private var blinkTimer:Float = 0;

	public function new() {
		super(0, 0);
		scrollFactor.set(0, 0);

		splashText = new FlxText(0, FlxG.height - 192, 0, "Press SPACE to start!", 48);
		splashText.screenCenter(X);
		add(splashText);

		var titleText = new FlxText(0, 128, 0, "Springroll", 96);
		titleText.screenCenter(X);
		add(titleText);

		var instructionsText = new FlxText(0, 0, 0, "Hold SPACE to charge jump, release to jump\nHold SHIFT to brake", 16);
		instructionsText.screenCenter();
		add(instructionsText);

		var copyrightText = new FlxText(16, FlxG.height - 32, 0, FlxG.random.bool() ? "(c) 2023 deddpewl and KHTangent" : "(c) 2023 KHTangent and deddpewl",
			16);
		add(copyrightText);

		var score = ScoreManager.getHighScore();
		if (score > 0) {
			var highScoreText = new FlxText(0, FlxG.height - 32, 0, "High score: " + ("" + score).lpad("0", 5), 16);
			highScoreText.x = FlxG.width - highScoreText.width - 16;
			add(highScoreText);
		}
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
