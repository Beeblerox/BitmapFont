package bitmapFont;

import flash.display.BitmapData;
import flash.geom.Rectangle;
import openfl.geom.Point;

// TODO: document it...
/**
 * 
 */
class BitmapGlyphFrame 
{
	/**
	 * 
	 */
	public var parent:BitmapFont;
	
	public var glyph:String;
	
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
	 * 
	 */
	public var rect:Rectangle;
	
	public var bitmap(get, null):BitmapData;
	
	private var _bitmap:BitmapData;
	
	/**
	 * tile id in tileSheet
	 */
	public var tileID:Int;
	
	public function new(parent:BitmapFont)
	{ 
		this.parent = parent;
	}
	
	public function destroy():Void
	{
		rect = null;
		glyph = null;
		
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