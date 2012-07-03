package pxBitmapFont 
{
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author Zaphod
	 */
	public class PxFontSymbol 
	{
		/**
		 * charCode of the symbol
		 */
		public var charID:int;
		
		/**
		 * x coodninate of symbol on source font-sheet
		 */
		public var x:int;
		
		/**
		 * y coodninate of symbol on source font-sheet
		 */
		public var y:int;
		
		/**
		 * width of symbol on source font-sheet
		 */
		public var width:int;
		
		/**
		 * height of symbol on source font-sheet
		 */
		public var height:int;
		
		/**
		 * x offset to draw symbol with
		 */
		public var xoffset:int;
		
		/**
		 * y offset to draw symbol with
		 */
		public var yoffset:int;
		
		/**
		 * real width of symbol
		 */
		public var xadvance:int;
		
		/**
		 * image of symbol
		 */
		public var bitmapData:BitmapData;
		
		public function PxFontSymbol() 
		{
			
		}
		
		public function dispose():void
		{
			if (bitmapData != null)
			{
				bitmapData.dispose();
			}
		}
		
	}

}