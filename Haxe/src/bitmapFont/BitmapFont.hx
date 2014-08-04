package bitmapFont;

import haxe.xml.Fast;
import openfl.display.Tilesheet;
import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;

#if RENDER_TILE
import openfl.display.Tilesheet;
#end

// TODO: rename destroy() methods to dispose()

/**
 * Holds information and bitmap glpyhs for a bitmap font.
 * @author Johan Peitz
 */
class BitmapFont
{
	private static var fonts:Map<String, BitmapFont> = new Map<String, BitmapFont>();
	
	/**
	 * Stores a font for global use using an identifier.
	 * @param	pHandle	String identifer for the font.
	 * @param	pFont	Font to store.
	 */
	public static function store(fontKey:String, font:BitmapFont):Void 
	{
		fonts.set(fontKey, font);
	}
	
	/**
	 * Retrieves a font previously stored.
	 * @param	pHandle	Identifier of font to fetch.
	 * @return	Stored font, or null if no font was found.
	 */
	public static function get(fontKey:String):BitmapFont 
	{
		return fonts.get(fontKey);
	}
	
	/**
	 * 
	 * @param	fontKey
	 */
	public static function remove(fontKey):Void
	{
		var font:BitmapFont = fonts.get(fontKey);
		
		if (font != null)
		{
			font.destroy();
		}
	}
	
	public static function clearFonts():Void
	{
		for (font in fonts)
		{
			font.destroy();
		}
		
		fonts = new Map<String, BitmapFont>();
	}
	
	public static inline var DEFAULT_GLYPHS:String = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
	
	private static var POINT:Point = new Point();
	
	private static var MATRIX:Matrix = new Matrix();
	
	private static var COLOR_TRANSFORM:ColorTransform = new ColorTransform();
	
	public var size(default, null):Int = 0;
	
	public var lineHeight(default, null):Int = 0;
	
	public var bold:Bool = false;
	
	public var italic:Bool = false;
	
	public var fontName:String;
	
	public var numLetters(default, null):Int = 0;
	
	public var minOffsetX:Int = 0;
	
	public var spaceWidth:Int = 0;
	
	public var bitmap:BitmapData;
	
	public var glyphs:Map<String, BitmapGlyphFrame>;
	
	#if RENDER_TILE
	public var tilesheet:Tilesheet;
	#end
	
	/**
	 * Creates a new bitmap font using specified bitmap data and letter input.
	 */
	public function new(bitmap:BitmapData)
	{
		this.bitmap = bitmap;
		#if RENDER_TILE
		tilesheet = new Tilesheet(bitmap);
		#end
		glyphs = new Map<String, BitmapGlyphFrame>();
	}
	
	public function destroy():Void 
	{
		if (bitmap != null)
		{
			bitmap.dispose();
		}
		
		bitmap = null;
		#if RENDER_TILE
		tilesheet = null;
		#end
		glyphs = null;
		fontName = null;
	}
	
	/**
	 * Retrieves default BitmapFont.
	 */
	public static function getDefault():BitmapFont
	{
		return DefaultBitmapFont.getDefaultFont();
	}
	
	/**
	 * Loads font data in AngelCode's format.
	 * 
	 * @param	Source		Font image source.
	 * @param	Data		XML font data.
	 * @return	Generated bitmap font object.
	 */
	public static function fromAngelCode(Source:BitmapData, Data:Xml):BitmapFont
	{
		var fast:Fast = new Fast(Data.firstElement());
		var fontName:String = Std.string(fast.node.info.att.face);
		
		var font:BitmapFont = BitmapFont.get(fontName);
		
		if (font != null)
		{
			return font;
		}
		
		font = new BitmapFont(Source);
		
		font.lineHeight = Std.parseInt(fast.node.common.att.lineHeight);
		font.size = Std.parseInt(fast.node.info.att.size);
		font.fontName = Std.string(fast.node.info.att.face);
		font.bold = (Std.parseInt(fast.node.info.att.bold) != 0);
		font.italic = (Std.parseInt(fast.node.info.att.italic) != 0);
		
		var glyphFrame:BitmapGlyphFrame;
		var frame:Rectangle;
		var glyph:String;
		var xOffset:Int, yOffset:Int, xAdvance:Int;
		
		var chars = fast.node.chars;
		
		for (char in chars.nodes.char)
		{
			frame = new Rectangle();
			frame.x = Std.parseInt(char.att.x);
			frame.y = Std.parseInt(char.att.y);
			frame.width = Std.parseInt(char.att.width);
			frame.height = Std.parseInt(char.att.height);
			
			xOffset = char.has.xoffset ? Std.parseInt(char.att.xoffset) : 0;
			yOffset = char.has.yoffset ? Std.parseInt(char.att.yoffset) : 0;
			xAdvance = char.has.xadvance ? Std.parseInt(char.att.xadvance) : 0;
			
			font.minOffsetX = (font.minOffsetX > xOffset) ? xOffset : font.minOffsetX;
			
			glyph = null;
			
			if (char.has.letter)
			{
				glyph = char.att.letter;
			}
			else if (char.has.id)
			{
				glyph = String.fromCharCode(Std.parseInt(char.att.id));
			}
			
			if (glyph == null) 
			{
				throw 'Invalid font xml data!';
			}
			
			glyph = switch(glyph) 
			{
				case "space": ' ';
				case "&quot;": '"';
				case "&amp;": '&';
				case "&gt;": '>';
				case "&lt;": '<';
				default: glyph;
			}
			
			font.addGlyphFrame(glyph, frame, xOffset, yOffset, xAdvance);
			
			if (glyph == ' ')
			{
				font.spaceWidth = xAdvance;
			}
		}
		
		return font;
	}
	
	/**
	 * Load bitmap font in XNA/Pixelizer format.
	 * 
	 * @param	key				
	 * @param	source			Source image for this font.
	 * @param	letters			String of glyphs contained in the source image, in order (ex. " abcdefghijklmnopqrstuvwxyz"). Defaults to DEFAULT_GLYPHS.
	 * @param	glyphBGColor	An additional background color to remove. Defaults to 0xFF202020, often used for glyphs background.
	 * @return	
	 */
	public static function fromXNA(key:String, source:BitmapData, letters:String = null, glyphBGColor:Int = 0x00000000):BitmapFont
	{
		var font:BitmapFont = BitmapFont.get(key);
		
		if (font != null)
		{
			return font;
		}
		
		font = new BitmapFont(source);
		font.fontName = key;
		
		letters = (letters == null) ? DEFAULT_GLYPHS : letters;
		
		var bmd:BitmapData = source;
		var globalBGColor:Int = bmd.getPixel(0, 0);
		var cy:Int = 0;
		var cx:Int;
		var letterIdx:Int = 0;
		var glyph:String;
		var numLetters:Int = letters.length;
		var rect:Rectangle;
		var xAdvance:Int;
		
		while (cy < bmd.height && letterIdx < numLetters)
		{
			var rowHeight:Int = 0;
			cx = 0;
			
			while (cx < bmd.width && letterIdx < numLetters)
			{
				if (Std.int(bmd.getPixel(cx, cy)) != globalBGColor) 
				{
					// found non bg pixel
					var gx:Int = cx;
					var gy:Int = cy;
					
					// find width and height of glyph
					while (Std.int(bmd.getPixel(gx, cy)) != globalBGColor) gx++;
					while (Std.int(bmd.getPixel(cx, gy)) != globalBGColor) gy++;
					
					var gw:Int = gx - cx;
					var gh:Int = gy - cy;
					
					glyph = letters.charAt(letterIdx);
					
					rect = new Rectangle(cx, cy, gw, gh);
					
					xAdvance = gw;
					
					font.addGlyphFrame(glyph, rect, 0, 0, xAdvance);
					
					if (glyph == ' ')
					{
						font.spaceWidth = xAdvance;
					}
					
					// store max size
					if (gh > rowHeight) rowHeight = gh;
					if (gh > font.size) font.size = gh;
					
					// go to next glyph
					cx += gw;
					letterIdx++;
				}
				
				cx++;
			}
			
			// next row
			cy += (rowHeight + 1);
		}
		
		font.lineHeight = font.size;
		
		// remove background color
		POINT.x = POINT.y = 0;
		var bgColor32:Int = bmd.getPixel32(0, 0);
		bmd.threshold(bmd, bmd.rect, POINT, "==", bgColor32, 0x00000000, 0xFFFFFFFF, true);
		
		if (glyphBGColor != 0x00000000)
		{
			bmd.threshold(bmd, bmd.rect, POINT, "==", glyphBGColor, 0x00000000, 0xFFFFFFFF, true);
		}
		
		return font;
	}
	
	/**
	 * Loads monospace bitmap font.
	 * 
	 * @param	key			
	 * @param	source		Source image for this font.
	 * @param	letters		The characters used in the font set, in display order. You can use the TEXT_SET consts for common font set arrangements.
	 * @param	charSize	The size of each character in the font set.
	 * @param	region		The region of image to use for the font. Default is null which means that the whole image will be used.
	 * @param	spacing		Spaces between characters in the font set. Default is null which means no spaces.
	 * @return
	 */
	public static function fromMonospace(key:String, source:BitmapData, letters:String = null, charSize:Point, region:Rectangle = null, spacing:Point = null):BitmapFont
	{
		var font:BitmapFont = BitmapFont.get(key);
		if (font != null)
			return font;
		
		letters = (letters == null) ? DEFAULT_GLYPHS : letters;
		
		region = (region == null) ? source.rect : region;
		
		if (region.width == 0 || region.right > source.width)
		{
			region.width = source.width - region.x;
		}
		
		if (region.height == 0 || region.bottom > source.height)
		{
			region.height = source.height - region.y;
		}
		
		spacing = (spacing == null) ? new Point(0, 0) : spacing;
		
		var bitmapWidth:Int = Std.int(region.width);
		var bitmapHeight:Int = Std.int(region.height);
		
		var startX:Int = Std.int(region.x);
		var startY:Int = Std.int(region.y);
		
		var xSpacing:Int = Std.int(spacing.x);
		var ySpacing:Int = Std.int(spacing.y);
		
		var charWidth:Int = Std.int(charSize.x);
		var charHeight:Int = Std.int(charSize.y);
		
		var spacedWidth:Int = charWidth + xSpacing;
		var spacedHeight:Int = charHeight + ySpacing;
		
		var numRows:Int = (charHeight == 0) ? 1 : Std.int((bitmapHeight + ySpacing) / spacedHeight);
		var numCols:Int = (charWidth == 0) ? 1 : Std.int((bitmapWidth + xSpacing) / spacedWidth);
		
		font = new BitmapFont(source);
		font.fontName = key;
		font.lineHeight = font.size = charHeight;
		
		var charRect:Rectangle;
		var xAdvance:Int = charWidth;
		var letterIndex:Int = 0;
		var numLetters:Int = letters.length;
		
		for (j in 0...(numRows))
		{
			for (i in 0...(numCols))
			{
				charRect = new Rectangle(startX + i * spacedWidth, startY + j * spacedHeight, charWidth, charHeight);
				font.addGlyphFrame(letters.charAt(letterIndex), charRect, 0, 0, xAdvance);
				
				letterIndex++;
				
				if (letterIndex >= numLetters)
				{
					return font;
				}
			}
		}
		
		font.spaceWidth = xAdvance;
		return font;
	}
	
	// TODO: document it...
	/**
	 * 
	 * 
	 * @param	glyph
	 * @param	frame
	 * @param	sourceSize
	 * @param	offset
	 * @param	xAdvance
	 */
	private function addGlyphFrame(glyph:String, frame:Rectangle, offsetX:Int = 0, offsetY:Int = 0, xAdvance:Int = 0):Void
	{
		var glyphFrame:BitmapGlyphFrame = new BitmapGlyphFrame(this);
		glyphFrame.glyph = glyph;
		glyphFrame.xoffset = offsetX;
		glyphFrame.yoffset = offsetY;
		glyphFrame.xadvance = xAdvance;
		glyphFrame.rect = frame;
		
		#if RENDER_TILE
		glyphFrame.tileID = tilesheet.addTileRect(frame, new Point(0, 0));
		#end
		
		glyphs.set(glyph, glyphFrame);
	}
	
	#if RENDER_BLIT
	public function prepareGlyphs(scale:Float, color:UInt, useColor:Bool = true):BitmapGlyphCollection
	{
		return new BitmapGlyphCollection(this, scale, color, useColor);
	}
	#end
}

/**
 * Helper class for blit render mode to reduce BitmapData draw() method calls.
 * It stores info about transformed bitmap font glyphs. 
 */
class BitmapGlyphCollection
{
	public var minOffsetX:Float = 0;
	
	public var glyphMap:Map<String, BitmapGlyph>;
	
	public var glyphs:Array<BitmapGlyph>;
	
	public var color:UInt;
	
	public var scale:Float;
	
	public var spaceWidth:Float = 0;
	
	public var font:BitmapFont;
	
	public function new(font:BitmapFont, scale:Float, color:UInt, useColor:Bool = true)
	{
		glyphMap = new Map<String, BitmapGlyph>();
		glyphs = new Array<BitmapGlyph>();
		this.font = font;
		this.scale = scale;
		this.color = (useColor) ? color : 0xFFFFFFFF;
		this.minOffsetX = font.minOffsetX * scale;
		prepareGlyphs();
	}
	
	private function prepareGlyphs():Void
	{
		var matrix:Matrix = new Matrix();
		matrix.scale(scale, scale);
		
		var colorTransform:ColorTransform = new ColorTransform();
		colorTransform.color = color;
		
		var glyphBD:BitmapData;
		var preparedBD:BitmapData;
		var glyph:BitmapGlyphFrame;
		var preparedGlyph:BitmapGlyph;
		var bdWidth:Int, bdHeight:Int;
		var offsetX:Int, offsetY:Int, xAdvance:Int;
		
		spaceWidth = font.spaceWidth * scale;
		
		for (glyph in font.glyphs)
		{
			glyphBD = glyph.bitmap;
			
			bdWidth = Math.ceil(glyphBD.width * scale);
			bdHeight = Math.ceil(glyphBD.height * scale);
			
			bdWidth = (bdWidth > 0) ? bdWidth : 1;
			bdHeight = (bdHeight > 0) ? bdHeight : 1;
			
			preparedBD = new BitmapData(bdWidth, bdHeight, true, 0x00000000);
			preparedBD.draw(glyphBD, matrix, colorTransform);
			
			offsetX = Math.ceil(glyph.xoffset * scale);
			offsetY = Math.ceil(glyph.yoffset * scale);
			xAdvance = Math.ceil(glyph.xadvance * scale);
			
			preparedGlyph = new BitmapGlyph(glyph.glyph, preparedBD, offsetX, offsetY, xAdvance);
			
			glyphs.push(preparedGlyph);
			glyphMap.set(preparedGlyph.glyph, preparedGlyph);
		}
	}
	
	public function destroy():Void
	{
		if (glyphs != null)
		{
			for (glyph in glyphs)
			{
				glyph.destroy();
			}
		}
		
		glyphs = null;
		glyphMap = null;
		font = null;
	}
}

/**
 * Helper class for blit render mode. 
 * Stores info about single transformed bitmap glyph.
 */
class BitmapGlyph
{
	public var glyph:String;
	
	public var bitmap:BitmapData;
	
	public var offsetX:Int = 0;
	
	public var offsetY:Int = 0;
	
	public var xAdvance:Int = 0;
	
	public var rect:Rectangle;
	
	public function new(glyph:String, bmd:BitmapData, offsetX:Int = 0, offsetY:Int = 0, xAdvance:Int = 0)
	{
		this.glyph = glyph;
		this.bitmap = bmd;
		this.offsetX = offsetX;
		this.offsetY = offsetY;
		this.xAdvance = xAdvance;
		this.rect = bmd.rect;
	}
	
	public function destroy():Void
	{
		if (bitmap != null)
		{
			bitmap.dispose();
		}
		
		bitmap = null;
		glyph = null;
	}
}