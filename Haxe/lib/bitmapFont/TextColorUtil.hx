package bitmapFont;

/**
 * ...
 * @author Matse
 */
class TextColorUtil 
{
	/**
	 * DISCLAIMER : These functions are copied from stablexui ColorUtils, I don't know the name of the author at the time being but thanks man !
	 */

	/**
     * Given a native color value (in the format 0xAARRGGBB) this will return the Alpha component as a value between 0 and 1
     *
     * @param   Color   In the format 0xAARRGGBB
     * @return  The Alpha component of the color, will be between 0 and 1 (0 being no Alpha (opaque), 1 full Alpha (transparent))
     */
    inline static public function getAlphaFloat(Color:Int):Float
    {
        var f:Int = (Color >> 24) & 0xFF;
        return f / 255;
    }
	
	/**
     * Turn a color with alpha and rgb values into a color without the alpha comoponent.
     * Example: 0x55ff0000 becomes 0xff0000
     *
     * @param   Color   The Color to convert
     * @return  The color without its alpha component
     */
    inline static public function RGBAtoRGB(Color:Int):Int
    {
        return getColor24(getRed(Color), getGreen(Color), getBlue(Color));
    }
	
	/**
     * Given 3 color values this will return an integer representation of it
     *
     * @param   Red     The Red channel value (between 0 and 255)
     * @param   Green   The Green channel value (between 0 and 255)
     * @param   Blue    The Blue channel value (between 0 and 255)
     * @return  A native color value integer (format: 0xRRGGBB)
     */
    inline static public function getColor24(Red:Int, Green:Int, Blue:Int):Int
    {
        return Red << 16 | Green << 8 | Blue;
    }
	
	/**
     * Given an alpha and 3 color values this will return an integer representation of it
     *
     * @param   Alpha   The Alpha value (between 0 and 255)
     * @param   Red     The Red channel value (between 0 and 255)
     * @param   Green   The Green channel value (between 0 and 255)
     * @param   Blue    The Blue channel value (between 0 and 255)
     * @return  A native color value integer (format: 0xAARRGGBB)
     */
    inline static public function getColor32(Alpha:Int, Red:Int, Green:Int, Blue:Int):Int
    {
        return Alpha << 24 | Red << 16 | Green << 8 | Blue;
    }
	
	 /**
     * Given a native color value (in the format 0xAARRGGBB) this will return the Red component, as a value between 0 and 255
     *
     * @param   Color   In the format 0xAARRGGBB
     * @return  The Red component of the color, will be between 0 and 255 (0 being no color, 255 full Red)
     */
    inline static public function getRed(Color:Int):Int
    {
        return Color >> 16 & 0xFF;
    }

    /**
     * Given a native color value (in the format 0xAARRGGBB) this will return the Green component, as a value between 0 and 255
     *
     * @param   Color   In the format 0xAARRGGBB
     * @return  The Green component of the color, will be between 0 and 255 (0 being no color, 255 full Green)
     */
    inline static public function getGreen(Color:Int):Int
    {
        return Color >> 8 & 0xFF;
    }

    /**
     * Given a native color value (in the format 0xAARRGGBB) this will return the Blue component, as a value between 0 and 255
     *
     * @param   Color   In the format 0xAARRGGBB
     * @return  The Blue component of the color, will be between 0 and 255 (0 being no color, 255 full Blue)
     */
    inline static public function getBlue(Color:Int):Int
    {
        return Color & 0xFF;
    }
	
}