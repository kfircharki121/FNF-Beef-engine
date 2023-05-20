package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class FlashingState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warningText:FlxText;
	var background:FlxSprite;
	var velocityBG:FlxBackdrop;

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		super.create();

		background = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        background.scrollFactor.set();
		background.updateHitbox();
		background.screenCenter();
		background.antialiasing = ClientPrefs.globalAntialiasing;
		background.color = 0xFF353535;
		add(background);

		velocityBG = new FlxBackdrop(Paths.image('velocity_background'));
		velocityBG.velocity.set(50, 50);
		add(velocityBG);

		#if android
		warningText = new FlxText(0, 0, FlxG.width,
			"WARNING:\nFNF': SB Engine may potentially trigger seizures for people with photosensitive epilepsy. Viewer discretion is advised.\n\n"
			+ "FNF': SB Engine is a modified Psych Engine with some changes and addition and wasn't meant to be an attack on ShadowMario"
			+ " and/or any other modmakers out there. I was not aiming for replacing what Friday Night Funkin': Psych Engine was, is and will."
			+ " It was made for fun and from the love for the game itself. All of the comparisons between this and other mods are purely coincidental, unless stated otherwise.\n\n"
			+ "Now with that out of the way, I hope you'll enjoy this FNF mod.\nFunk all the way.\nPress A to proceed.\nPress B to ignore this message.\nCurrent SB Engine version: " + MainMenuState.sbEngineVersion + "",
			32);
		#else
		warningText = new FlxText(0, 0, FlxG.width,
			"WARNING:\nFNF': SB Engine may potentially trigger seizures for people with photosensitive epilepsy. Viewer discretion is advised.\n\n"
			+ "FNF': SB Engine is a modified Psych Engine with some changes and addition and wasn't meant to be an attack on ShadowMario"
			+ " and/or any other modmakers out there. I was not aiming for replacing what Friday Night Funkin'; Psych Engine was, is and will."
			+ " It was made for fun and from the love for the game itself. All of the comparisons between this and other mods are purely coincidental, unless stated otherwise.\n\n"
			+ "Now with that out of the way, I hope you'll enjoy this FNF mod.\nFunk all the way.\nPress ENTER to proceed.\nPress ESCAPE to ignore this message.\nCurrent SB Engine version: " + MainMenuState.sbEngineVersion + "",
			32);
		#end
		warningText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		warningText.borderSize = 2.4;
		warningText.screenCenter(Y);
		add(warningText);

        #if android
        addVirtualPad(NONE, A_B);
        #end
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			var back:Bool = controls.BACK;
			if (controls.ACCEPT || back) {
				leftState = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				if(!back) {
					ClientPrefs.flashing = false;
					ClientPrefs.saveSettings();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					FlxFlicker.flicker(warningText, 1, 0.1, false, true, function(flk:FlxFlicker) {
						#if android
						virtualPad.alpha = 0.1;
						#end
						new FlxTimer().start(0.5, function (tmr:FlxTimer) {
							MusicBeatState.switchState(new TitleState());
						});
					});
				} else {
					FlxG.sound.play(Paths.sound('cancelMenu'));
					#if android
					FlxTween.tween(virtualPad, {alpha: 0}, 1);
					#end
					FlxTween.tween(warningText, {alpha: 0}, 1, {
						onComplete: function (twn:FlxTween) {
							MusicBeatState.switchState(new TitleState());
						}
					});
				}
			}
		}
		super.update(elapsed);
	}
}
