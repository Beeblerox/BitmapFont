package pxBitmapFont
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 * Holds information and bitmap glpyhs for a bitmap font.
	 * @author Johan Peitz
	 */
	public class PxBitmapFont 
	{
		private static var _storedFonts:Dictionary = new Dictionary();
		
		private static var ZERO_POINT:Point = new Point();
		
		private var _glyphs:Array;
		private var _glyphString:String;
		private var _maxHeight:int;
		
		private var _matrix:Matrix;
		private var _colorTransform:ColorTransform;
		
		private var _point:Point;
		
		/**
		 * Creates a new bitmap font using specified bitmap data and letter input.
		 * @param	pBitmapData	The bitmap data to copy letters from.
		 * @param	pLetters	String of letters available in the bitmap data.
		 */
		public function PxBitmapFont() 
		{
			_maxHeight = 0;
			_point = new Point();
			_matrix = new Matrix();
			_colorTransform = new ColorTransform();
			_glyphs = [];
		}
		
		/**
		 * Loads font data in Pixelizer's format
		 * @param	pBitmapData	font source image
		 * @param	pLetters	all letters contained in this font
		 * @return				this font
		 */
		public function loadPixelizer(pBitmapData:BitmapData, pLetters:String):PxBitmapFont
		{
			reset();
			_glyphString = pLetters;
			
			// fill array with nulls
			for (var i:int = 0; i < 256; i++) 
			{
				_glyphs.push(null);
			}
			
			if (pBitmapData != null) 
			{
				var tileRects:Array = [];
				grabFontData(pBitmapData, tileRects);
				var currRect:Rectangle;
				
				for (var letterID:int = 0; letterID < tileRects.length; letterID++)
				{
					currRect = tileRects[letterID];
					
					// create glyph
					var bd:BitmapData = new BitmapData(Math.floor(currRect.width), Math.floor(currRect.height), true, 0x0);
					bd.copyPixels(pBitmapData, currRect, ZERO_POINT, null, null, true);
					
					// store glyph
					setGlyph(_glyphString.charCodeAt(letterID), bd);
				}
			}
			
			return this;
		}
		
		/**
		 * Loads font data in AngelCode's format
		 * @param	pBitmapData	font image source
		 * @param	pXMLData	font data in XML format
		 * @return				this font
		 */
		public function loadAngelCode(pBitmapData:BitmapData, pXMLData:XML):PxBitmapFont
		{
			reset();
			
			if (pBitmapData != null) 
			{
				_glyphString = "";
				
				var chars:XMLList = pXMLData.chars[0].char;
				var numLetters:int = chars.length();
				var rect:Rectangle = new Rectangle();
				var point:Point = new Point();
				var char:XML;
				var bd:BitmapData;
				var charString:String;
				
				for (var i:int = 0; i < numLetters; i++)
				{
					char = chars[i];
					charString = String.fromCharCode(char.@id);
					_glyphString += charString;
					
					// create glyph
					if (charString != " " && charString != "")
					{
						bd = new BitmapData(int(char.@xadvance), int(char.@height) + int(char.@yoffset), true, 0x0);
					}
					else
					{
						bd = new BitmapData(int(char.@xadvance), 1, true, 0x0);
					}
					
					rect.x = int(char.@x);
					rect.y = int(char.@y);
					rect.width = int(char.@width);
					rect.height = int(char.@height);
					
					point.x = int(char.@xoffset);
					point.y = int(char.@yoffset);
					bd.copyPixels(pBitmapData, rect, point, null, null, true);
					
					// store glyph
					setGlyph(char.@id, bd);
				}
			}
			
			return this;
		}
		
		/**
		 * internal function. Resets current font
		 */
		private function reset():void
		{
			dispose();
			_maxHeight = 0;
			_glyphs = [];
			_glyphString = "";
		}
		
		public function grabFontData(pBitmapData:BitmapData, pRects:Array):void
		{
			var bgColor:int = pBitmapData.getPixel(0, 0);
			var cy:int = 0;
			var cx:int;
			
			while (cy < pBitmapData.height)
			{
				var rowHeight:int = 0;
				cx = 0;
				
				while (cx < pBitmapData.width)
				{
					if (pBitmapData.getPixel(cx, cy) != bgColor) 
					{
						// found non bg pixel
						var gx:int = cx;
						var gy:int = cy;
						// find width and height of glyph
						while (pBitmapData.getPixel(gx, cy) != bgColor)
						{
							gx++;
						}
						while (pBitmapData.getPixel(cx, gy) != bgColor)
						{
							gy++;
						}
						var gw:int = gx - cx;
						var gh:int = gy - cy;
						
						pRects.push(new Rectangle(cx, cy, gw, gh));
						
						// store max size
						if (gh > rowHeight) 
						{
							rowHeight = gh;
						}
						if (gh > _maxHeight) 
						{
							_maxHeight = gh;
						}
						
						// go to next glyph
						cx += gw;
					}
					
					cx++;
				}
				// next row
				cy += (rowHeight + 1);
			}
		}
		
		public function getPreparedGlyphs(pScale:Number, pColor:int, pUseColorTranform:Boolean = true):Array
		{
			var result:Array = [];
			
			_matrix.identity();
			_matrix.scale(pScale, pScale);
			
			var colorMultiplier:Number = 0.00392;
			_colorTransform.redOffset = 0;
			_colorTransform.greenOffset = 0;
			_colorTransform.blueOffset = 0;
			_colorTransform.redMultiplier = (pColor >> 16) * colorMultiplier;
			_colorTransform.greenMultiplier = (pColor >> 8 & 0xff) * colorMultiplier;
			_colorTransform.blueMultiplier = (pColor & 0xff) * colorMultiplier;
			
			var glyph:BitmapData;
			var preparedGlyph:BitmapData;
			for (var i:int = 0; i < _glyphs.length; i++)
			{
				glyph = _glyphs[i];
				if (glyph != null)
				{
					preparedGlyph = new BitmapData(Math.floor(glyph.width * pScale), Math.floor(glyph.height * pScale), true, 0x00000000);
					if (pUseColorTranform)
					{
						preparedGlyph.draw(glyph,  _matrix, _colorTransform);
					}
					else
					{
						preparedGlyph.draw(glyph,  _matrix);
					}
					result[i] = preparedGlyph;
				}
			}
			
			return result;
		}
		
		/**
		 * Clears all resources used by the font.
		 */
		public function dispose():void 
		{
			var glyph:BitmapData;
			for (var i:int = 0; i < _glyphs.length; i++) 
			{
				glyph = _glyphs[i];
				if (glyph != null) 
				{
					glyph.dispose();
				}
			}
			_glyphs = null;
		}
		
		/**
		 * Serializes font data to cryptic bit string.
		 * @return	Cryptic string with font as bits.
		 */
		public function getFontData():String 
		{
			var output:String = "";
			
			for (var i:int = 0; i < _glyphString.length; i++) 
			{
				var charCode:int = _glyphString.charCodeAt(i);
				var glyph:BitmapData = _glyphs[charCode];
				output += _glyphString.substr(i, 1);
				output += glyph.width;
				output += glyph.height;
				for (var py:int = 0; py < glyph.height; py++) 
				{
					for (var px:int = 0; px < glyph.width; px++) 
					{
						output += (glyph.getPixel32(px, py) != 0 ? "1":"0");
					}
				}
			}
			
			return output;
		}
		
		private function setGlyph(pCharID:int, pBitmapData:BitmapData):void 
		{
			if (_glyphs[pCharID] != null)
			{
				_glyphs[pCharID].dispose();
			}
			
			_glyphs[pCharID] = pBitmapData;
			
			if (pBitmapData.height > _maxHeight) 
			{
				_maxHeight = pBitmapData.height;
			}
		}
		
		/**
		 * Renders a string of text onto bitmap data using the font.
		 * @param	pBitmapData	Where to render the text.
		 * @param	pText	Test to render.
		 * @param	pColor	Color of text to render.
		 * @param	pOffsetX	X position of thext output.
		 * @param	pOffsetY	Y position of thext output.
		 */
		public function render(pBitmapData:BitmapData, pFontData:Array, pText:String, pColor:uint, pOffsetX:int, pOffsetY:int, pLetterSpacing:int, pAngle:Number = 0):void 
		{
			_point.x = pOffsetX;
			_point.y = pOffsetY;
			var glyph:BitmapData;
			
			for (var i:int = 0; i < pText.length; i++) 
			{
				var charCode:int = pText.charCodeAt(i);
				glyph = pFontData[charCode];
				
				if (glyph != null) 
				{
					pBitmapData.copyPixels(glyph, glyph.rect, _point, null, null, true);
					_point.x += glyph.width + pLetterSpacing;
				}
			}
		}
		
		/**
		 * Returns the width of a certain test string.
		 * @param	pText	String to measure.
		 * @param	pLetterSpacing	distance between letters
		 * @param	pFontScale	"size" of the font
		 * @return	Width in pixels.
		 */
		public function getTextWidth(pText:String, pLetterSpacing:int = 0, pFontScale:Number = 1.0):int 
		{
			var w:int = 0;
			
			var textLength:int = pText.length;
			for (var i:int = 0; i < textLength; i++) 
			{
				var charCode:int = pText.charCodeAt(i);
				
				var glyph:BitmapData = _glyphs[charCode];
				if (glyph != null) 
				{
					
					w += glyph.width;
				}
			}
			
			w = Math.round(w * pFontScale);
			
			if (textLength > 1)
			{
				w += (textLength - 1) * pLetterSpacing;
			}
			
			return w;
		}
		
		/**
		 * Returns height of font in pixels.
		 * @return Height of font in pixels.
		 */
		public function getFontHeight():int 
		{
			return _maxHeight;
		}
		
		/**
		 * Returns number of letters available in this font.
		 * @return Number of letters available in this font.
		 */
		public function get numLetters():int 
		{
			return _glyphs.length;
		}
		
		/**
		 * Stores a font for global use using an identifier.
		 * @param	pHandle	String identifer for the font.
		 * @param	pFont	Font to store.
		 */
		public static function store(pHandle:String, pFont:PxBitmapFont):void 
		{
			_storedFonts[pHandle] = pFont;
		}
		
		/**
		 * Retrieves a font previously stored.
		 * @param	pHandle	Identifier of font to fetch.
		 * @return	Stored font, or null if no font was found.
		 */
		public static function fetch(pHandle:String):PxBitmapFont 
		{
			var f:PxBitmapFont = _storedFonts[pHandle];
			return f;
		}

	}
}