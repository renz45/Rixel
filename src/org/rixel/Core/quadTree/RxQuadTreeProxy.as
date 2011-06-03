package org.rixel.Core.quadTree 
{
	public class RxQuadTreeProxy extends RxProxyBase
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