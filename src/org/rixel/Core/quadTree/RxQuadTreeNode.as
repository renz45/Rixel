package org.rixel.Core.quadTree
{
	public class RxQuadTreeNode
	{
		public var parent:RxQuadTreeNode;
		
		public var proxyList:RxQuadTreeProxy;
		
		public var xmin:int, xmax:int;
		public var ymin:int, ymax:int;
		
		public function RxQuadTreeNode()
		{
			
		}
		
		public function insert(proxy:RxQuadTreeProxy):void
		{
			proxy.prevInNode = null;
			proxy.nextInNode = proxyList;
			if (proxyList) proxyList.prevInNode = proxy;
			proxyList = proxy;
			proxy.node = this;
		}
	}
}