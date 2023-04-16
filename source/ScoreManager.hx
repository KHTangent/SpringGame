package;

import flixel.FlxG;

class ScoreManager {
	private static var initialized = false;

	public static function initialize():Void {
		if (!initialized) {
			initialized = true;
			if (FlxG.save.data.score == null) {
				FlxG.save.data.score = 0;
			}
		}
	}

	public static function getHighScore():Int {
		return FlxG.save.data.score;
	}

	public static function saveHighScore(score:Int, force = false):Void {
		if (score >= getHighScore() || force) {
			FlxG.save.data.score = score;
			FlxG.save.flush();
		}
	}
}
