package org.rixel.Core.quadtree 
{
	import flash.display.BitmapData;

	/*
	Based on the quadtree used in the open source Motor physics engine by Michael Baczynski:
	http://code.google.com/p/polygonal/downloads/list?can=4&q=&colspec=Filename+Summary+Uploaded+Size+DownloadCount
	
	Modified by Adam Rensel
	*/
	
	public class RxQuadTreeProxy extends RxQuadTreeProxyBase
	{
		public var nextInNode:RxQuadTreeProxy;
		public var prevInNode:RxQuadTreeProxy;
		
		public var nextInTree:RxQuadTreeProxy;
		public var prevInTree:RxQuadTreeProxy;
		
		public var node:RxQuadTreeNode;
		
		public var xl1:int, xl2:int;
		public var yl1:int, yl2:int;
		
		public function RxQuadTreeProxy()
		{
			var b:BitmapData = new BitmapData(1,1);
		}
		
		public function remove():void
		{
			if (prevInNode) prevInNode.nextInNode = nextInNode;
			if (nextInNode) nextInNode.prevInNode = prevInNode;
			if (this == node.proxyList) node.proxyList = nextInNode;
			
			prevInNode = null;
			nextInNode = null;
			node = null;
		}
		
		override public function reset():void
		{
			nextInNode = null;
			prevInNode = null;
			nextInTree = null;
			prevInTree = null;
			node = null;
			xl1 = int.MIN_VALUE;
			yl1 = int.MIN_VALUE;	
			xl2 = int.MIN_VALUE;
			yl2 = int.MIN_VALUE;
			super.reset();
		}
	}
}