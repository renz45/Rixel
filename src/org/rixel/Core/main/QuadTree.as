package org.rixel.Core.main
{
	import de.polygonal.ds.Collection;
	import de.polygonal.ds.LinkedStack;
	
	import flash.geom.Rectangle;
	
	import org.osflash.signals.Signal;
	import org.rixel.Core.Geometry.RxPoint;
	import org.rixel.Core.Geometry.RxRectangle;
	import org.rixel.Core.displayObjects.RxDisplayObject;
	import org.rixel.Core.main.VO.QuadTreeNodeVO;
	import org.rixel.Core.nameSpaces.rixel;
	
	/**
	 * Quadtree for the rixel game engine. Insertion is done through a generated key used for direct object access of a leafList Object 
	 * intead of using a recursive function.
	 * 
	 * This quadtree is a pre rendered tree as opposed to a procedurally generated as needed tree, I decided to do it this way
	 * because I feel the trade off of memory is the lesser evil, since creating new nodes is going to get expensive.
	 * 
	 * 
	 * 
	 * @author adamrensel
	 * 
	 */	
	public class QuadTree
	{
		private var _depth:int;
		private var _startRect:RxRectangle;
		private var _totalDivisions:int;
		private var _leafRect:RxRectangle;
		
		
		private var _rootNode:QuadTreeNode;
		
		private var _branchList:Vector.<QuadTreeNode>;
		private var _leafList:Object;
		
		//////insert
		private var _insertNode:QuadTreeNode;
		private var _insertRect:RxRectangle;
		
		public var treeComplete_Event:Signal;
		
		public function QuadTree(startRect:RxRectangle, depth:int = 5)
		{
			_depth = depth;
			_startRect = startRect;
			
			
			
			init();
		}
		
		private function init():void
		{
			_insertRect = new RxRectangle();
			
			_totalDivisions = 1;
			for(var i:int = 0; i < depth-1; i++)
			{
				_totalDivisions *= 2;
			}
			
			_leafRect = new RxRectangle();
			_leafRect.width = _startRect.width / _totalDivisions;
			_leafRect.height = _startRect.height / _totalDivisions;
				
			
			treeComplete_Event = new Signal(QuadTree);
			
			_branchList = new Vector.<QuadTreeNode>;
			_leafList = {};
			
			_rootNode = new QuadTreeNode(_startRect,1, this);
		}
		
		private function findParentNode(rxRect:RxRectangle, node:QuadTreeNode):QuadTreeNode
		{
			if( node.bounds.containsRect(rxRect) )
			{
				return node;
			}else{
				return (this.findParentNode(rxRect,node.parent) );
			}
		}
		
		/////////////////////CALLBACKS////////////////////
		
		
		////////////////////PUBLIC METHODS/////////////////
		
		/**
		 * returns the leaf node at the point represented by x and y 
		 * @param x int x coord
		 * @param y int y coord
		 * 
		 * @return QuadTreeNode 
		 * 
		 */		
		public function getLeafAt(x:int,y:int):QuadTreeNode
		{
			return _leafList[this.rixel::getLeafSpacialId(x,y)] as QuadTreeNode
		}
		
		public function insertDisplayObject(rxDisplayObject:RxDisplayObject):void
		{	
			_insertRect.x = rxDisplayObject.x;
			_insertRect.y = rxDisplayObject.y;
			_insertRect.width = rxDisplayObject.width;
			_insertRect.height = rxDisplayObject.height;
			
			_insertNode = findParentNode(_insertRect,_leafList[this.rixel::getLeafSpacialId(rxDisplayObject.x,rxDisplayObject.y)] as QuadTreeNode);
			
			rxDisplayObject.rixel::parentNode = _insertNode;
			_insertNode.addDataItem(rxDisplayObject);
		}

	
		////////////////////GETTERS SETTERS////////////////
		public function get depth():int
		{
			return _depth;
		}
		
		public function set depth(value:int):void
		{
			_depth = depth;
		}
		
		public function get nodeList():Vector.<QuadTreeNode>
		{
			return _branchList;
		}
		
		public function get leafList():Object
		{
			return _leafList;
		}
		
		
		///////////////////////RIXEL INTERNAL////////////////
		
		rixel function treeComplete():void
		{
			treeComplete_Event.dispatch(this);
		}
		
		rixel function addToMasterList(node:QuadTreeNode):void
		{		
			_branchList.push(node);
			if(_branchList.length == 341)
			{
				this.treeComplete_Event.dispatch(this);
			}
		
		}
		
		rixel function addToLeafList(node:QuadTreeNode):void
		{
			_leafList[this.rixel::getLeafSpacialId(node.bounds.x,node.bounds.y)] = node;
		}
		
		//create a unique object key based on the top left corner of the leaf cell
		rixel function getLeafSpacialId(x:int,y:int):String
		{		
			return (int(x/_leafRect.width)).toString() + " "  + (int(y/_leafRect.height)).toString();   
		}
	}
}