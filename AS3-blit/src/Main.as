package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import pxBitmapFont.PxBitmapFont;
	import pxBitmapFont.PxTextAlign;
	import pxBitmapFont.PxTextField;
	
	/**
	 * ...
	 * @author Zaphod
	 */
	public class Main extends Sprite 
	{
		
		[Embed(source = "../assets/fontData10pt.png")]
		private var PixelizerFontImage:Class;
		
		[Embed(source = "../assets/1.fnt", mimeType = "application/octet-stream")]
		private var angelCodeFontData:Class;
		[Embed(source = "../assets/1_0.png")]
		private var angelCodeFontImage:Class;
		
		private var fontString:String;
		
		private var tf:PxTextField;
		private var tf2:PxTextField;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			fontString = " !\"#$%&'()*+,-./" + "0123456789:;<=>?" + "@ABCDEFGHIJKLMNO" + "PQRSTUVWXYZ[]^_" + "abcdefghijklmno" + "pqrstuvwxyz{|}~\\";
			var font:PxBitmapFont = new PxBitmapFont().loadPixelizer((new PixelizerFontImage()).bitmapData, fontString);
			
			var font2:PxBitmapFont = new PxBitmapFont().loadAngelCode((new angelCodeFontImage()).bitmapData, XML(new angelCodeFontData()));
			
			tf = new PxTextField();
			addChild(tf);
			tf.color = 0x0000ff;
			tf.background = true;
			tf.backgroundColor = 0x00ff00;
			tf.text = "Hello World!\nand this is\nmultiline!!!";
			tf.shadow = true;
		//	tf.outlineColor = 0x0000ff;
			tf.width = 400;
			tf.alignment = PxTextAlign.CENTER;
			tf.multiLine = true;
			tf.lineSpacing = 5;
			tf.fontScale = 2.5;
			tf.padding = 5;
			tf.scaleX = tf.scaleY = 2.5;
		//	tf.alpha(0.5);
			
			tf2 = new PxTextField(font2);
			tf2.y = 100;
			addChild(tf2);
			tf2.color = 0x0000ff;
		//	tf2.background = true;
			tf2.backgroundColor = 0x00ff00;
			tf2.shadow = true;
		//	tf2.shadowColor = 0xff0000;
			tf2.outlineColor = 0xff0000;
			tf2.width = 20;
			tf2.alignment = PxTextAlign.RIGHT;
			tf2.lineSpacing = 5;
			tf2.fontScale = 2.5;
			tf2.padding = 20;
			tf2.letterSpacing = 25;
			tf2.autoUpperCase = true;
			tf2.multiLine = true;
			tf2.wordWrap = true;
			tf2.fixedWidth = false;
			tf2.text = "Hello!" + "\n\n" + "world!";
			tf2.visible = true;
		//	tf2.scaleX = tf2.scaleY = 2.5;
		//	tf2.alpha(0.5);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private function onMouseMove(e:MouseEvent):void 
		{
		//	tf.text = "mouseX = " + Math.floor(e.localX);
		//	tf2.text = "mouseY = " + Math.floor(e.localY) + "; mouseX = " + Math.floor(e.localX) + ";\n" + "mouseY = " + Math.floor(e.localY) + "\n" + "mouseY = " + Math.floor(e.localY);
		}
		
	}
	
}