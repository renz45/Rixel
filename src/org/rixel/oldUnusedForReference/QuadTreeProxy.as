package org.rixel.oldUnusedForReference
{
	import org.rixel.Core.displayObjects.RxDisplayObject;
	import org.rixel.Core.nameSpaces.rixel;

	public class QuadTreeProxy
	{
		public var data:RxDisplayObject;
		public var nextItem:QuadTreeProxy;
		public var prevItem:QuadTreeProxy;
		public var node:QuadTreeNode;
		
		public function QuadTreeProxy(dataToAdd:RxDisplayObject,quadTreeNode:QuadTreeNode)
		{
			prevItem = quadTreeNode.rixel::proxy;
			data = dataToAdd;
			node = quadTreeNode;
		}
		
		public function remove():void
		{
			if(prevItem)
			{
				if(nextItem)
				{
					prevItem.nextItem = nextItem;
					nextItem.prevItem = prevItem;
				}else{
					node.rixel::proxy = prevItem;
				}
			}
		}
		
		public function addToNode(quadTreeNode:QuadTreeNode):void
		{
			node = quadTreeNode;
			prevItem = quadTreeNode.rixel::proxy;
		}
	}
}