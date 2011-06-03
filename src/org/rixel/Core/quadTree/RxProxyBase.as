package org.rixel.Core.quadTree
{	
	import org.rixel.Core.displayObjects.RxDisplayObject;

	public class RxProxyBase
	{
		public static const NULL_PROXY:int = 0xffff;
		
		public var id:int;
		//public var shape:ShapeSkeleton;
		public var displayObject:RxDisplayObject;
		public var overlapCount:int;
		
		private var _next:int;
		
		public function RxProxyBase()
		{
			
		}
		
		public function setNext(i:int):void
		{
			_next = i;
		}
		
		public function getNext():int
		{
			return _next;	
		}
		
		public function reset():void
		{
			overlapCount = 0;
			displayObject = null;
			//shape = null;
		}
	}
}