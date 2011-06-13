package org.rixel.Core.quadTree
{	
	/*
	Based on the quadtree used in the open source Motor physics engine by Michael Baczynski:
	http://code.google.com/p/polygonal/downloads/list?can=4&q=&colspec=Filename+Summary+Uploaded+Size+DownloadCount
	*/
	import org.rixel.Core.displayObjects.RxSprite;

	public class RxProxyBase
	{
		public static const NULL_PROXY:int = 0xffff;
		
		public var id:int;
		public var sprite:RxSprite;
		
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
			sprite = null;
		}
	}
}