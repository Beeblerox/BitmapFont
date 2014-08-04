package ;

import bitmapFont.TextBorderStyle;
import flash.display.BitmapData;
import openfl.Assets;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import openfl.events.Event;
import openfl.Lib;
import bitmapFont.BitmapFont;
import bitmapFont.BitmapTextField;
import openfl.text.TextFormatAlign;

import bitmapFont.DefaultBitmapFont;

/**
 * ...
 * @author Zaphod
 */

class Main extends Sprite
{
//	private var tf:BitmapTextField;
//	private var tf2:BitmapTextField;
	
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
		
		var field:BitmapTextField = new BitmapTextField();
		addChild(field);
		
		field.text = "hello!!!";
		field.textColor = 0xFF0000FF;
		field.useTextColor = true;
		
		field.background = true;
		field.backgroundColor = 0xffff0000;
		
		field.borderStyle = TextBorderStyle.SHADOW;
		field.borderColor = 0xff00ff00;
		
		field.size = 5;
		
		field.letterSpacing = 25;
		
		field.padding = 10;
		
		/*
		var font:PxBitmapFont = new PxBitmapFont().loadPixelizer(Assets.getBitmapData("assets/fontData10pt.png"), " !\"#$%&'()*+,-./" + "0123456789:;<=>?" + "@ABCDEFGHIJKLMNO" + "PQRSTUVWXYZ[]^_" + "abcdefghijklmno" + "pqrstuvwxyz{|}~\\");
		
		var textBytes = Assets.getText("assets/NavTitle.fnt");
		var XMLData = Xml.parse(textBytes);
		var font2:PxBitmapFont = new PxBitmapFont().loadAngelCode(Assets.getBitmapData("assets/NavTitle.png"), XMLData);
		
		tf = new PxTextField(font2);
	//	addChild(tf); // I don't add this component to display list as you can see
		tf.text = "Hello World!\nand this is\nmultiline!!!";
		tf.color = 0x0000ff;
		tf.background = true;
		tf.fixedWidth = false;
		tf.multiLine = true;
		tf.backgroundColor = 0x00ff00;
		tf.shadow = true;
		tf.setWidth(250);
		tf.alignment = PxTextAlign.CENTER;
		tf.lineSpacing = 5;
		tf.fontScale = 2.5;
		tf.padding = 5;
		tf.scaleX = tf.scaleY = 2.5;
	//	tf.setAlpha(0.5);
		
		tf.drawText(this.graphics, 100, 200);
		*/
	/*	
		
		tf2 = new PxTextField(font2);
	//	tf2.y = 100;
		addChild(tf2);
		tf2.color = 0x0000ff;
		tf2.useColor = false;
	//	tf2.background = true;
		tf2.backgroundColor = 0x00ff00;
		tf2.text = "Hello World!\nand this is\nmultiline!!!";
		tf2.shadow = true;
	//	tf2.shadowColor = 0xff0000;
		tf2.outlineColor = 0xff0000;
		tf2.setWidth(610);
		tf2.alignment = PxTextAlign.RIGHT;
	//	tf2.lineSpacing = 5;
		tf2.fontScale = 2.5;
		tf2.padding = 20;
		tf2.letterSpacing = 25;
		tf2.autoUpperCase = true;
		tf2.multiLine = true;
		tf2.wordWrap = false;
		tf2.fixedWidth = false;
	//	tf2.scaleX = tf2.scaleY = 2.5;
	//	tf2.setAlpha(0.2);*/
		
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		
		this.addEventListener(Event.RENDER, onRender);
	}
	
	private function onRender(e:Event):Void 
	{
		trace("onRender");
	}
	
	private function onMouseMove(e:MouseEvent):Void 
	{
	//	tf.text = "mouseX = " + Math.floor(e.localX);
	//	tf2.text = "mouseY = " + Math.floor(e.localY) + "; mouseX = " + Math.floor(e.localX) + ";\n" + "mouseY = " + Math.floor(e.localY) + "\n\n" + "mouseY = " + Math.floor(e.localY);
	}
	
}