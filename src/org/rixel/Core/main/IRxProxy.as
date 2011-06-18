package org.rixel.Core.main
{

	public interface IRxProxy
	{
		function set x(value:int):void;
		function set y(value:int):void;
		function get xmin():int;
		function get xmax():int;
		function get ymin():int;
		function get ymax():int;
		function get proxy():RxQuadTreeProxy;
		function set proxy(value:RxQuadTreeProxy):void;
		function get proxyId():int;
		function set proxyId(value:int):void;
		function get node():RxQuadTreeNode;
		function get displayObject():Abstract_internalDisplayObject;
		function set displayObject(value:Abstract_internalDisplayObject):void;
		function get displayable():IDisplayable;
		function set displayable(value:IDisplayable):void;
	} 
}