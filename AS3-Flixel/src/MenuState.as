package  
{
	import flash.ui.Mouse;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import pxBitmapFont.PxBitmapFont;
	import pxBitmapFont.FlxBitmapTextField;
	import pxBitmapFont.PxTextAlign;
	
	/**
	 * ...
	 * @author Zaphod
	 */
	public class MenuState extends FlxState
	{
		
		[Embed(source = "../assets/fontData10pt.png")]
		private var FontImage:Class;
		
		[Embed(source = "../assets/1.fnt", mimeType = "application/octet-stream")]
		private var angelCodeFontData:Class;
		[Embed(source = "../assets/1_0.png")]
		private var angelCodeFontImage:Class;
		
		private var tf:FlxBitmapTextField;
		
		override public function create():void 
		{
			FlxG.framerate = 30;
			FlxG.flashFramerate = 30;
			
			var fontString:String = " !\"#$%&'()*+,-./" + "0123456789:;<=>?" + "@ABCDEFGHIJKLMNO" + "PQRSTUVWXYZ[]^_" + "abcdefghijklmno" + "pqrstuvwxyz{|}~\\";
			var font:PxBitmapFont = new PxBitmapFont().loadPixelizer((new FontImage()).bitmapData, fontString);
			
			var font2:PxBitmapFont = new PxBitmapFont().loadAngelCode((new angelCodeFontImage()).bitmapData, XML(new angelCodeFontData()));
			
			tf = new FlxBitmapTextField(font2);
			//tf.background = true;
			tf.backgroundColor = 0x00ffff;
			tf.textColor = 0xff0000;
			tf.text = "Hello!\nand this is multiline";
			tf.shadow = true;
			tf.shadowColor = 0xffffff;
			
			tf.y = 100;
			tf.wordWrap = false;
			tf.setWidth(FlxG.width);
			tf.alignment = PxTextAlign.CENTER;
			tf.multiLine = true;
			tf.lineSpacing = 5;
			tf.fontScale = 2.5;
			tf.padding = 5;
			tf.alpha = 0.5;
			//tf.angle = 45;
			add(tf);
			
			FlxG.mouse.show();
			Mouse.hide();
		}
		
		override public function update():void 
		{
			super.update();
			
			tf.text = "mouseX = " + FlxG.mouse.x + "\n" + "mouseY = " + FlxG.mouse.y;
		}
		
	}

}