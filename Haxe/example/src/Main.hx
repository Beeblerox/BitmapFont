package;
import bitmapFont.BitmapFont;
import bitmapFont.BitmapTextAlign;
import bitmapFont.BitmapTextField;
import bitmapFont.TextBorderStyle;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.Lib;

/**
 * ...
 * @author Zaphod
 */

class Main extends Sprite
{
	var defaultField:BitmapTextField;
	var monoSpaceField:BitmapTextField;
	var angelCodeField:BitmapTextField;
	
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
		
		// here is example of bitmap text field with default font (which is in XNA format)
		defaultField = new BitmapTextField();
		// as you can see it have 2 lines of text
		defaultField.text = "hello!!!\nWORLD";
		// centered alignment
		defaultField.alignment = BitmapTextAlign.CENTER;
		// blue color (tinting)
		defaultField.useTextColor = true;
		defaultField.textColor = 0xFF0000FF;
		// and semitransparent red background
		defaultField.background = true;
		defaultField.backgroundColor = 0x55ff0000;
		// plus it have green shadow with customized offset (default offset is 1, 1)
		defaultField.borderStyle = TextBorderStyle.SHADOW;
		defaultField.shadowOffset.setTo(2, 5);
		defaultField.borderColor = 0xCC00FF00;
		// we scale the font since it is pretty small 
		defaultField.size = 5;
		// plus we customize distance between symbols
		defaultField.letterSpacing = 25;
		// and we want background to be bigger than the text area
		defaultField.padding = 10;
		addChild(defaultField);
		
		// now let's text monospace fonts:
		// to create font we need:
		// 1. image with font glyphs
		var monoSpaceImage:BitmapData = Assets.getBitmapData("assets/gold_font.png");
		// 2. string containing chars of this font
		var monoSpaceChars:String = "!     :() ,?.ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		// 3. the size of each glyph
		var charSize:Point = new Point(16, 16);
		var monoSpaceFont:BitmapFont = BitmapFont.fromMonospace("goldenFont", monoSpaceImage, monoSpaceChars, charSize);
		
		monoSpaceField = new BitmapTextField(monoSpaceFont);
		// since our font contains only upper case glyphs we need to make our text field to render all chars in upper case
		monoSpaceField.autoUpperCase = true;
		monoSpaceField.text = "some uppercased text";
		// lets set fixed field width to demonstrate ability to wrap text
		monoSpaceField.autoSize = false;
		monoSpaceField.width = 200;
		// lets wrap by word not by character
		monoSpaceField.wrapByWord = true;
		monoSpaceField.y = defaultField.y + defaultField.height;
		monoSpaceField.background = true;
		monoSpaceField.backgroundColor = 0xFF000000;
		// add some space between text and background borders
		monoSpaceField.padding = 3;
		// and add some spaces between the lines
		monoSpaceField.lineSpacing = 3;
		// center the text
		monoSpaceField.alignment = BitmapTextAlign.CENTER;
		addChild(monoSpaceField);
		
		// And finally lets test AngelCode font
		var fontXML:Xml = Xml.parse(Assets.getText("assets/NavTitle.fnt"));
		var fontImage:BitmapData = Assets.getBitmapData("assets/NavTitle.png");
		var angelCodeFont:BitmapFont = BitmapFont.fromAngelCode(fontImage, fontXML);
		
		angelCodeField = new BitmapTextField(angelCodeFont);
		angelCodeField.text = "mouseX = " + 0 + "\nmouseY = " + 0;
		angelCodeField.y = monoSpaceField.y + monoSpaceField.height;
		addChild(angelCodeField);
		
		// Let this text field be "dynamic"
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
	}
	
	private function onMouseMove(e:MouseEvent):Void 
	{
		angelCodeField.text = "mouseX = " + Math.floor(e.localX) + "\nmouseY = " + Math.floor(e.localY);
	}
}