package pxBitmapFont;

import flash.display.BitmapData;
/**
 * ...
 * @author Zaphod
 */
class PxFontSymbol 
{
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
	 * tile id in tileSheet
	 */
	public var tileID:Int;
	
	/**
	 * image of symbol
	 */
	public var bitmapData:BitmapData;
	
	public function new() 
	{
		
	}
	
	public function dispose():PxFontSymbol
	{
		if (bitmapData != null)
		{
			bitmapData.dispose();
		}
		bitmapData = null;
		return this;
	}
	
}