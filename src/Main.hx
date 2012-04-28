package ;

import flash.display.BitmapData;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.events.MouseEvent;
import nme.geom.Rectangle;
import nme.Lib;
import pxBitmapFont.PxBitmapFont;
import pxBitmapFont.PxTextAlign;

import pxBitmapFont.PxTextFieldComponent;

/**
 * ...
 * @author Zaphod
 */

class Main extends Sprite
{
	private var tf:PxTextFieldComponent;
	private var tf2:PxTextFieldComponent;
	
	static public function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		// entry point
		
		Lib.current.addChild(new Main());
	}
	
	public function new()
	{
		super();
		
		var font:PxBitmapFont = new PxBitmapFont(Assets.getBitmapData("assets/fontData10pt.png"), " !\"#$%&'()*+,-./" + "0123456789:;<=>?" + "@ABCDEFGHIJKLMNO" + "PQRSTUVWXYZ[]^_" + "abcdefghijklmno" + "pqrstuvwxyz{|}~\\");
		
		tf = new PxTextFieldComponent();
		addChild(tf);
		tf.color = 0x0000ff;
		tf.background = true;
		tf.backgroundColor = 0x00ff00;
		tf.text = "Hello World!\nand this is\nmultiline!!!";
		tf.shadow = true;
	//	tf.outlineColor = 0x0000ff;
		tf.setWidth(250);
		tf.alignment = PxTextAlign.CENTER;
		tf.multiLine = true;
		tf.lineSpacing = 5;
		tf.fontScale = 2.5;
		tf.padding = 5;
		tf.scaleX = tf.scaleY = 2.5;
	//	tf.setAlpha(0.5);
		
		tf2 = new PxTextFieldComponent(font);
		tf2.y = 100;
		addChild(tf2);
		tf2.color = 0x0000ff;
		tf2.background = true;
		tf2.backgroundColor = 0x00ff00;
		tf2.text = "Hello World!\nand this is\nmultiline!!!";
		tf2.outline = true;
		tf2.shadowColor = 0xff0000;
		tf2.outlineColor = 0xff0000;
		tf2.setWidth(600);
		tf2.alignment = PxTextAlign.CENTER;
		tf2.multiLine = true;
		tf2.lineSpacing = 5;
		tf2.fontScale = 2.5;
		tf2.padding = 5;
		tf2.letterSpacing = 20;
		tf2.autoUpperCase = true;
	//	tf2.scaleX = tf2.scaleY = 2.5;
	//	tf2.setAlpha(0.5);
		
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
	}
	
	private function onMouseMove(e:MouseEvent):Void 
	{
		tf.text = "mouseX = " + Math.floor(e.localX);
		tf2.text = "mouseY = " + Math.floor(e.localY);
	}
	
}