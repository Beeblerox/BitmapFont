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

/**
 * Holds information and bitmap glyphs for a bitmap font.
 */
class BitmapFont
{
	private static var fonts:Map<String, BitmapFont> = new Map<String, BitmapFont>();
	
	/**
	 * Stores a font for global use using an identifier.
	 * @param	fontKey		String identifer for the font.
	 * @param	font		Font to store.
	 */
	public static function store(fontKey:String, font:BitmapFont):Void 
	{
		if (!fonts.exists(fontKey))
		{
			fonts.set(fontKey, font);
		}
	}
	
	/**
	 * Retrieves a font previously stored.
	 * @param	fontKey		Identifier of font to fetch.
	 * @return	Stored font, or null if no font was found.
	 */
	public static function get(fontKey:String):BitmapFont 
	{
		return fonts.get(fontKey);
	}
	
	/**
	 * Removes font with provided fontKey and disposes it.
	 * @param	fontKey		The name of font to remove.
	 */
	public static function remove(fontKey):Void
	{
		var font:BitmapFont = fonts.get(fontKey);
		fonts.remove(fontKey);
		
		if (font != null)
		{
			font.dispose();
		}
	}
	
	/**
	 * Clears fonts storage and disposes all fonts.
	 */
	public static function clearFonts():Void
	{
		for (font in fonts)
		{
			font.dispose();
		}
		
		fonts = new Map<String, BitmapFont>();
	}
	
	/**
	 * Retrieves default BitmapFont.
	 */
	public static function getDefault():BitmapFont
	{
		return DefaultBitmapFont.getDefaultFont();
	}
	
	/**
	 * Default letters for XNA font.
	 */
	public static inline var DEFAULT_GLYPHS:String = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
	
	private static var POINT:Point = new Point();
	
	private static var MATRIX:Matrix = new Matrix();
	
	private static var COLOR_TRANSFORM:ColorTransform = new ColorTransform();
	
	/**
	 * The size of the font. Can be useful for AngelCode fonts.
	 */
	public var size(default, null):Int = 0;
	
	public var lineHeight(default, null):Int = 0;
	
	public var bold:Bool = false;
	
	public var italic:Bool = false;
	
	public var fontName:String;
	
	/**
	 * Minimum x offset in this font. 
	 * This is a helper varible for rendering purposes.
	 */
	public var minOffsetX:Int = 0;
	
	/**
	 * The width of space character.
	 */
	public var spaceWidth:Int = 0;
	
	/**
	 * Source image for this font.
	 */
	public var bitmap:BitmapData;
	
	public var glyphs:Map<Int, BitmapGlyphFrame>;
	
	#if RENDER_TILE
	public var tilesheet:Tilesheet;
	#end
	
	/**
	 * Creates and stores new bitmap font using specified source image.
	 */
	public function new(name:String, bitmap:BitmapData)
	{
		this.bitmap = bitmap;
		this.fontName = name;
		#if RENDER_TILE
		tilesheet = new Tilesheet(bitmap);
		#end
		glyphs = new Map<Int, BitmapGlyphFrame>();
		BitmapFont.store(name, this);
	}
	
	/**
	 * Destroys this font object.
	 * WARNING: it disposes source image also.
	 */
	public function dispose():Void 
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
		
		font = new BitmapFont(fontName, Source);
		font.lineHeight = Std.parseInt(fast.node.common.att.lineHeight);
		font.size = Std.parseInt(fast.node.info.att.size);
		font.fontName = Std.string(fast.node.info.att.face);
		font.bold = (Std.parseInt(fast.node.info.att.bold) != 0);
		font.italic = (Std.parseInt(fast.node.info.att.italic) != 0);
		
		var frame:Rectangle;
		var glyph:String;
		var charCode:Int;
		var spaceCharCode:Int = " ".charCodeAt(0);
		var xOffset:Int, yOffset:Int, xAdvance:Int;
		var frameHeight:Int;
		
		var chars = fast.node.chars;
		
		for (char in chars.nodes.char)
		{
			frame = new Rectangle();
			frame.x = Std.parseInt(char.att.x);
			frame.y = Std.parseInt(char.att.y);
			frame.width = Std.parseInt(char.att.width);
			frameHeight = Std.parseInt(char.att.height);
			frame.height = frameHeight;
			
			xOffset = char.has.xoffset ? Std.parseInt(char.att.xoffset) : 0;
			yOffset = char.has.yoffset ? Std.parseInt(char.att.yoffset) : 0;
			xAdvance = char.has.xadvance ? Std.parseInt(char.att.xadvance) : 0;
			
			font.minOffsetX = (font.minOffsetX > xOffset) ? xOffset : font.minOffsetX;
			
			glyph = null;
			charCode = -1;
			
			if (char.has.letter)
			{
				glyph = char.att.letter;
			}
			else if (char.has.id)
			{
				charCode = Std.parseInt(char.att.id);
			}
			
			if (charCode == -1 && glyph == null) 
			{
				throw 'Invalid font xml data!';
			}
			
			if (glyph != null)
			{
				glyph = switch(glyph) 
				{
					case "space": ' ';
					case "&quot;": '"';
					case "&amp;": '&';
					case "&gt;": '>';
					case "&lt;": '<';
					default: glyph;
				}
				
				charCode = glyph.charCodeAt(0);
			}
			
			font.addGlyphFrame(charCode, frame, xOffset, yOffset, xAdvance);
			
			if (charCode == spaceCharCode)
			{
				font.spaceWidth = xAdvance;
			}
			else
			{
				font.lineHeight = (font.lineHeight > frameHeight + yOffset) ? font.lineHeight : frameHeight + yOffset;
			}
		}
		
		return font;
	}
	
	/**
	 * Load bitmap font in XNA/Pixelizer format. 
	 * I took this method from HaxePunk engine.
	 * 
	 * @param	key				Name for this font.
	 * @param	source			Source image for this font.
	 * @param	letters			String of glyphs contained in the source image, in order (ex. " abcdefghijklmnopqrstuvwxyz"). Defaults to DEFAULT_GLYPHS.
	 * @param	glyphBGColor	An additional background color to remove. Defaults to 0xFF202020, often used for glyphs background.
	 * @return	Generated bitmap font object.
	 */
	public static function fromXNA(key:String, source:BitmapData, letters:String = null, glyphBGColor:Int = 0x00000000):BitmapFont
	{
		var font:BitmapFont = BitmapFont.get(key);
		
		if (font != null)
		{
			return font;
		}
		
		font = new BitmapFont(key, source);
		font.fontName = key;
		
		letters = (letters == null) ? DEFAULT_GLYPHS : letters;
		
		var bmd:BitmapData = source;
		var globalBGColor:Int = bmd.getPixel(0, 0);
		var cy:Int = 0;
		var cx:Int;
		var letterIdx:Int = 0;
		var charCode:Int;
		var spaceCharCode:Int = " ".charCodeAt(0);
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
					
					charCode = letters.charCodeAt(letterIdx);
					
					rect = new Rectangle(cx, cy, gw, gh);
					
					xAdvance = gw;
					
					font.addGlyphFrame(charCode, rect, 0, 0, xAdvance);
					
					if (charCode == spaceCharCode)
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
		#if !js
		bmd.threshold(bmd, bmd.rect, POINT, "==", bgColor32, 0x00000000, 0xFFFFFFFF, true);
		#else
		replaceColor(bmd, bgColor32, 0x00000000);
		#end
		if (glyphBGColor != 0x00000000)
		{
			#if !js
			bmd.threshold(bmd, bmd.rect, POINT, "==", glyphBGColor, 0x00000000, 0xFFFFFFFF, true);
			#else
			replaceColor(bmd, glyphBGColor, 0x00000000);
			#end
		}
		
		return font;
	}
	
	public static function replaceColor(bitmapData:BitmapData, color:Int, newColor:Int):BitmapData
	{
		var row:Int = 0;
		var column:Int = 0;
		var rows:Int = bitmapData.height;
		var columns:Int = bitmapData.width;
		bitmapData.lock();
		while (row < rows)
		{
			column = 0;
			while (column < columns)
			{
				if (bitmapData.getPixel32(column, row) == cast color)
				{
					bitmapData.setPixel32(column, row, newColor);
				}
				column++;
			}
			row++;
		}
		bitmapData.unlock();
		
		return bitmapData;
	}
	
	/**
	 * Loads monospace bitmap font.
	 * 
	 * @param	key			Name for this font.
	 * @param	source		Source image for this font.
	 * @param	letters		The characters used in the font set, in display order. You can use the TEXT_SET consts for common font set arrangements.
	 * @param	charSize	The size of each character in the font set.
	 * @param	region		The region of image to use for the font. Default is null which means that the whole image will be used.
	 * @param	spacing		Spaces between characters in the font set. Default is null which means no spaces.
	 * @return	Generated bitmap font object.
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
		
		font = new BitmapFont(key, source);
		font.fontName = key;
		font.lineHeight = font.size = charHeight;
		
		var charRect:Rectangle;
		var xAdvance:Int = charWidth;
		font.spaceWidth = xAdvance;
		var letterIndex:Int = 0;
		var numLetters:Int = letters.length;
		
		for (j in 0...(numRows))
		{
			for (i in 0...(numCols))
			{
				charRect = new Rectangle(startX + i * spacedWidth, startY + j * spacedHeight, charWidth, charHeight);
				font.addGlyphFrame(letters.charCodeAt(letterIndex), charRect, 0, 0, xAdvance);
				
				letterIndex++;
				
				if (letterIndex >= numLetters)
				{
					return font;
				}
			}
		}
		
		return font;
	}
	
	/**
	 * Internal method which creates and add glyph frames into this font.
	 * 
	 * @param	charCode		Char code for glyph frame.
	 * @param	frame			Glyph area from source image.
	 * @param	offsetX			X offset before rendering this glyph.
	 * @param	offsetX			Y offset before rendering this glyph.
	 * @param	xAdvance		How much cursor will jump after this glyph.
	 */
	private function addGlyphFrame(charCode:Int, frame:Rectangle, offsetX:Int = 0, offsetY:Int = 0, xAdvance:Int = 0):Void
	{
		if (frame.width == 0 || frame.height == 0 || glyphs.get(charCode) != null)	return;
		
		var glyphFrame:BitmapGlyphFrame = new BitmapGlyphFrame(this);
		glyphFrame.charCode = charCode;
		glyphFrame.xoffset = offsetX;
		glyphFrame.yoffset = offsetY;
		glyphFrame.xadvance = xAdvance;
		glyphFrame.rect = frame;
		
		#if RENDER_TILE
		glyphFrame.tileID = tilesheet.addTileRect(frame, new Point(0, 0));
		#end
		
		glyphs.set(charCode, glyphFrame);
	}
	
	#if RENDER_BLIT
	/**
	 * Generates special collection of BitmapGlyph objects, which are used in RENDER_BLIT mode.
	 * These BitmapGlyph objects contain prepared (scales and color transformed) glyph images, which saves some CPU cycles for you.
	 * 
	 * @param	scale		How much scale apply to glyphs.
	 * @param	color		color in AARRGGBB format for glyph preparations.
	 * @param	useColor	Whether to use color transformation for glyphs.
	 * @return	Generated collection of BitmapGlyph objects. They are used for rendering text and borders in RENDER_BLIT mode.
	 */
	public function prepareGlyphs(scale:Float, color:UInt, useColor:Bool = true, smoothing:Bool = true):BitmapGlyphCollection
	{
		return new BitmapGlyphCollection(this, scale, color, useColor, smoothing);
	}
	#end
}

/**
 * Helper object. Stores info about single glyph (without transformations).
 */
class BitmapGlyphFrame 
{
	/**
	 * Bitmap font which this glyph frame belongs to.
	 */
	public var parent:BitmapFont;
	
	public var charCode:Int;
	
	/**
	 * x offset to draw symbol with
	 */
	public var xoffset:Int;
	
	/**
	 * y offset to draw symbol with
	 */
	public var yoffset:Int;
	
	/**
	 * real width of symbol
	 */
	public var xadvance:Int;
	
	/**
	 * Source image area which contains image of this glyph
	 */
	public var rect:Rectangle;
	
	/**
	 * Trimmed image of this glyph
	 */
	public var bitmap(get, null):BitmapData;
	
	private var _bitmap:BitmapData;
	
	/**
	 * tile id in parent's tileSheet
	 */
	public var tileID:Int;
	
	public function new(parent:BitmapFont)
	{ 
		this.parent = parent;
	}
	
	public function dispose():Void
	{
		rect = null;
		
		if (_bitmap != null)
		{
			_bitmap.dispose();
		}
		
		_bitmap = null;
	}
	
	public function get_bitmap():BitmapData
	{
		if (_bitmap != null)
		{
			return _bitmap;
		}
		
		_bitmap = new BitmapData(Math.ceil(rect.width), Math.ceil(rect.height), true, 0x00000000);
		_bitmap.copyPixels(parent.bitmap, rect, new Point());
		return _bitmap;
	}
}

/**
 * Helper class for blit render mode to reduce BitmapData draw() method calls.
 * It stores info about transformed (scale and color transformed) bitmap font glyphs. 
 */
class BitmapGlyphCollection
{
	public var minOffsetX:Float = 0;
	
	public var glyphMap:Map<Int, BitmapGlyph>;
	
	public var glyphs:Array<BitmapGlyph>;
	
	public var color:UInt;
	
	public var scale:Float;
	
	public var spaceWidth:Float = 0;
	
	public var font:BitmapFont;
	
	public function new(font:BitmapFont, scale:Float, color:UInt, useColor:Bool = true, smoothing:Bool = true)
	{
		glyphMap = new Map<Int, BitmapGlyph>();
		glyphs = new Array<BitmapGlyph>();
		this.font = font;
		this.scale = scale;
		this.color = (useColor) ? color : 0xFFFFFFFF;
		this.minOffsetX = font.minOffsetX * scale;
		prepareGlyphs(smoothing);
	}
	
	private function prepareGlyphs(smoothing:Bool = true):Void
	{
		var matrix:Matrix = new Matrix();
		matrix.scale(scale, scale);
		
		var colorTransform:ColorTransform = new ColorTransform();
		colorTransform.redMultiplier = ((color >> 16) & 0xFF) / 255;
		colorTransform.greenMultiplier = ((color >> 8) & 0xFF) / 255;
		colorTransform.blueMultiplier = (color & 0xFF) / 255;
		colorTransform.alphaMultiplier = ((color >> 24) & 0xFF) / 255;
		
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
			
			#if !js
			preparedBD.draw(glyphBD, matrix, colorTransform, null, null, smoothing);
			#else
			preparedBD.draw(glyphBD, matrix, null, null, null, smoothing);
			preparedBD.colorTransform(preparedBD.rect, colorTransform);
			#end
			
			offsetX = Math.ceil(glyph.xoffset * scale);
			offsetY = Math.ceil(glyph.yoffset * scale);
			xAdvance = Math.ceil(glyph.xadvance * scale);
			
			preparedGlyph = new BitmapGlyph(glyph.charCode, preparedBD, offsetX, offsetY, xAdvance);
			
			glyphs.push(preparedGlyph);
			glyphMap.set(preparedGlyph.charCode, preparedGlyph);
		}
	}
	
	public function dispose():Void
	{
		if (glyphs != null)
		{
			for (glyph in glyphs)
			{
				glyph.dispose();
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
	public var charCode:Int;
	
	public var bitmap:BitmapData;
	
	public var offsetX:Int = 0;
	
	public var offsetY:Int = 0;
	
	public var xAdvance:Int = 0;
	
	public var rect:Rectangle;
	
	public function new(charCode:Int, bmd:BitmapData, offsetX:Int = 0, offsetY:Int = 0, xAdvance:Int = 0)
	{
		this.charCode = charCode;
		this.bitmap = bmd;
		this.offsetX = offsetX;
		this.offsetY = offsetY;
		this.xAdvance = xAdvance;
		this.rect = bmd.rect;
	}
	
	public function dispose():Void
	{
		if (bitmap != null)
		{
			bitmap.dispose();
		}
		
		bitmap = null;
	}
}