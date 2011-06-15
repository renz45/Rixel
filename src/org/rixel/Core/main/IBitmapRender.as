package org.rixel.Core.main
{
	import flash.display.BitmapData;

	public interface IBitmapRender extends IRender
	{
		function get frame():BitmapData;
	}
}