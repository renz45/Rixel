package org.rixel.oldUnusedForReference
{
	import org.rixel.Core.Geometry.RxRectangle;
	import org.rixel.Core.displayObjects.RxDisplayObject;
	import org.rixel.Core.main.VO.QuadTreeNodeVO;
	import org.rixel.Core.nameSpaces.rixel;

	public class QuadTreeNode
	{
		private var _childrenVO:QuadTreeNodeVO;
		private var _parent:QuadTreeNode;
		private var _boundRect:RxRectangle;
		private var _depth:int;
		
		private var _row:int;
		private var _col:int;
		
		private var _rectWidth:Number;
		private var _rectHeight:Number;
		private var _tree:QuadTree;
		
		private var _proxy:QuadTreeProxy;
		private var _dataCount:int;
		
		public function QuadTreeNode(bounds:RxRectangle,depth:int,tree:QuadTree,parent:QuadTreeNode = null)
		{
			_parent = parent;
			_boundRect = bounds;
			_depth = depth;
			_tree = tree;
			
			
			init();
		}
		
		private function init():void
		{
			_dataCount = 0;
			
			
			_tree.rixel::addToMasterList(this);
			
			if(_depth < _tree.depth)
			{
				splitNode();
			}else{
				_tree.rixel::addToLeafList(this);
			}
		}
		
		private function createChildren(rect:RxRectangle):QuadTreeNodeVO
		{	
			_rectWidth = rect.width/2;
			_rectHeight = rect.height/2;
			
			var nodeVO:QuadTreeNodeVO = new QuadTreeNodeVO();
			
			nodeVO.topLeft = new QuadTreeNode(new RxRectangle(rect.x,rect.y,_rectWidth, _rectHeight), _depth + 1, _tree, this);
			nodeVO.topRight = new QuadTreeNode(new RxRectangle(rect.x + _rectWidth, rect.y, _rectWidth, _rectHeight),_depth + 1, _tree, this);
			nodeVO.bottomLeft = new QuadTreeNode(new RxRectangle(rect.x, rect.y + _rectHeight, _rectWidth, _rectHeight),_depth + 1, _tree, this);
			nodeVO.bottomRight = new QuadTreeNode(new RxRectangle(rect.x + _rectWidth, rect.y + _rectHeight, _rectWidth, _rectHeight),_depth + 1, _tree, this);
			
			return nodeVO;
		}
		/////////////////////CALLBACKS////////////////////
		
		
		////////////////////PUBLIC METHODS/////////////////
		
		public function splitNode():void
		{
			if(_depth == _tree.depth)
			{
				throw new Error("The target depth of this quadTree is " + _depth + " it can go no further.");
			}
			
			_childrenVO = createChildren(_boundRect);
		}
		
		
		public function addDataItem(data:RxDisplayObject):void
		{
			var proxy:QuadTreeProxy = new QuadTreeProxy(data,this);
			
			_proxy = proxy;
		}
		
		
		////////////////////GETTERS SETTERS////////////////
		public function get children():QuadTreeNodeVO
		{
			return _childrenVO;
		}
		
		public function set children(quadList:QuadTreeNodeVO):void
		{
			_childrenVO = quadList;
		}
		
		public function get topLeft():RxRectangle
		{
			return _childrenVO.topLeft.bounds;
		}
		
		public function get topRight():RxRectangle
		{
			return _childrenVO.topRight.bounds;
		}
		
		public function get bottomLeft():RxRectangle
		{
			return _childrenVO.bottomLeft.bounds;
		}
		
		public function get bottomRight():RxRectangle
		{
			return _childrenVO.bottomRight.bounds;
		}
		
		public function get parent():QuadTreeNode
		{
			return _parent;
		}
		
		public function set parent(value:QuadTreeNode):void
		{
			_parent = value;
		}
		
		public function get bounds():RxRectangle
		{
			return _boundRect;
		}
		
		public function set bounds(value:RxRectangle):void
		{
			_boundRect = value;
		}
		
		public function get depth():int
		{
			return _depth;
		}


		///////////////////////////STATICS///////////////////////////
		
		
		/////////////////////RIXEL INTERNAL/////////////////////////
		rixel function get proxy():QuadTreeProxy
		{
			return _proxy;
		}
		
		rixel function set proxy(proxy:QuadTreeProxy):void
		{
			_proxy = proxy;
		}

	}
}