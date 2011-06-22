package org.rixel.Core.displayObjects
{
	import flash.display.BitmapData;

	public interface IDisplayable
	{
		function get x():int;
		function set x(value:int):void;
		function get y():int;
		function set y(value:int):void;
		function get boundsX():int;
		function get boundsY():int;
		function get xOffset():int;
		function get yOffset():int;
		function get width():int;
		//function set width(value:int):void;
		function get height():int;
		//function set height(value:int):void;
		function get staticFrame():BitmapData;
	}
}