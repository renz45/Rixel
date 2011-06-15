package org.rixel.Core.main
{
	import flash.display.BitmapData;

	public interface IRender
	{
		function get boundsX():int
		function get boundsY():int;
		function get width():int;
		function get height():int;
		function get proxyId():int;
	}
}