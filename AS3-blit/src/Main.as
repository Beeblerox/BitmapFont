package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
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
		private var FontImage:Class;
		
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
			var font:PxBitmapFont = new PxBitmapFont((new FontImage()).bitmapData, fontString);
		
			tf = new PxTextField();
			addChild(tf);
			tf.color = 0x0000ff;
			tf.background = true;
			tf.backgroundColor = 0x00ff00;
			tf.text = "Hello World!\nand this is\nmultiline!!!";
			tf.shadow = true;
		//	tf.outlineColor = 0x0000ff;
			tf.width = 250;
			tf.alignment = PxTextAlign.CENTER;
			tf.multiLine = true;
			tf.lineSpacing = 5;
			tf.fontScale = 2.5;
			tf.padding = 5;
			tf.scaleX = tf.scaleY = 2.5;
		//	tf.alpha(0.5);
			
			tf2 = new PxTextField(font);
			tf2.y = 100;
			addChild(tf2);
			tf2.color = 0x0000ff;
			tf2.background = true;
			tf2.backgroundColor = 0x00ff00;
			tf2.text = "Hello World!\nand this is\nmultiline!!!";
			tf2.shadow = true;
		//	tf2.shadowColor = 0xff0000;
			tf2.outlineColor = 0xff0000;
			tf2.width = 610;
			tf2.alignment = PxTextAlign.RIGHT;
			tf2.lineSpacing = 5;
			tf2.fontScale = 2.5;
			tf2.padding = 20;
			tf2.letterSpacing = 25;
			tf2.autoUpperCase = true;
			tf2.multiLine = true;
			tf2.wordWrap = true;
			tf2.fixedWidth = true;
		//	tf2.scaleX = tf2.scaleY = 2.5;
		//	tf2.alpha(0.5);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private function onMouseMove(e:MouseEvent):void 
		{
			tf.text = "mouseX = " + Math.floor(e.localX);
			tf2.text = "mouseY = " + Math.floor(e.localY) + "; mouseX = " + Math.floor(e.localX) + ";\n" + "mouseY = " + Math.floor(e.localY) + "\n" + "mouseY = " + Math.floor(e.localY);
		}
		
	}
	
}