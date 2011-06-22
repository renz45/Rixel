package org.rixel.Core.quadtree
{	
	/*
	Based on the quadtree used in the open source Motor physics engine by Michael Baczynski:
	http://code.google.com/p/polygonal/downloads/list?can=4&q=&colspec=Filename+Summary+Uploaded+Size+DownloadCount
	
	Modified by Adam Rensel
	*/
	
	import flash.system.System;
	
	import org.rixel.Core.Geometry.RxRectangle;
	import org.rixel.Core.quadtree.RxQuadTreeNode;
	import org.rixel.Core.quadtree.RxQuadTreeProxy;
	import org.rixel.Core.quadtree.RxQuadTreeProxyBase;
	
	public class RxQuadTree
	{
		private var _nodes:Vector.<RxQuadTreeNode>;
		private var _offsets:Vector.<int>;
		
		private var _depth:int;
		
		private var _xScale:Number;
		private var _yScale:Number;
		
		private var _xmin:Number, _xmax:Number;
		private var _ymin:Number, _ymax:Number;
		
		private var _xOffset:Number;
		private var _yOffset:Number;
		
		private var _proxyList:RxQuadTreeProxy;
		private var _proxyPool:Vector.<RxQuadTreeProxy>;
		private var _freeProxy:int;
		
		private var _proxyCount:int;
		
		private var _objectMax:int;
		
		/////////////function optimizations
		private var _proxy:RxQuadTreeProxy;
		private var _s:IRxProxy;
		
		private var _x1:int;
		private var _y1:int;
		
		private var _xl:int;
		private var _yt:int;
		
		private var _xr:int;
		private var _yr:int;
		
		private var _shift:int;
		private var _node:RxQuadTreeNode;
		
		private var _level:int;
		
		private var _x0:int;
		private var _y0:int;
		
		private var _xmin2:Number, _xmax2:Number;
		private var _ymin2:Number, _ymax2:Number;
		
		private var _p:RxQuadTreeProxy;
		
		private var _i:int;
		
		private var _proxyId:int;
		
		
		public static const MAX_512_OBJECTS:int = 512;
		public static const MAX_1024_OBJECTS:int = 1024;
		public static const MAX_1536_OBJECTS:int = 1536;
		public static const MAX_2048_OBJECTS:int = 2048;
		
		public function RxQuadTree(depth:int, maxObjects:int = RxQuadTree.MAX_512_OBJECTS)
		{
			_depth = depth;
			_objectMax = maxObjects;
		}
		
		public function deconstruct():void
		{
			var p0:RxQuadTreeProxy; 
			var p1:RxQuadTreeProxy;
			
			var k:int = _nodes.length;
			for (var i:int = 0; i < k; i++)
			{
				var node:RxQuadTreeNode = _nodes[i];
				node.parent = null;
				p1 = node.proxyList;
				while (p1 != null)
				{
					p0 = p1;
					p1 = p1.nextInNode;
					p0.prevInNode = null;
					p0.nextInNode = null;
				}
			}
			
			p1 = _proxyList;
			while (p1 != null)
			{
				p0 = p1;
				p1 = p1.nextInTree;
				p0.nextInTree = null;
				p0.prevInTree = null;
				p0.proxyObject;
			}
			
			_proxyList = null;
			_proxyPool = null;
		}
		
		public function setWorldBounds(rect:RxRectangle):void
		{
			_xmin = rect.xmin; _ymin = rect.ymin;
			_xmax = rect.xmax; _ymax = rect.ymax;
			
			var w:int = _xmax - _xmin;
			var h:int = _ymax - _ymin;
			
			_xOffset = _xmin < 0 ? -_xmin : 0;
			_yOffset = _ymin < 0 ? -_ymin : 0;
			
			initialize(w, h);
		}
		
		/*public function queryRectangle(rect:RxRectangle, out:Vector.<IRxProxy>, maxCount:int = int.MAX_VALUE):int
		{
			if (out.fixed)
			{
				maxCount = out.length;
			}
			
			_xmin2 = rect.xmin;
			_xmax2 = rect.xmax;
			_ymin2 = rect.ymin;
			_ymax2 = rect.ymax;
			
			_p = _proxyList;
			
			_i = 0;
			while (_p != null)
			{
				_s = _p.proxyObject;
				if (_s.xmin > _xmax2 || _s.xmax < _xmin2 || _s.ymin > _ymax2 || _s.ymax < _ymin2)
				{
					_p = _p.nextInTree;
					continue;
				}
				
				out[_i++] = _s;
				
				if (_i == maxCount)
				{
					break;
				}
				
				_p = _p.nextInTree;
			}
			
			return _i;
		}*/
		
		public function createProxy(proxyObject:IRxProxy):int
		{
			_proxyId = _freeProxy;
			_proxy = _proxyPool[_proxyId];
			_freeProxy = _proxy.getNext(); 
			
			_proxy.proxyObject = proxyObject;
			proxyObject.proxy = _proxy;
			
			_proxy.nextInTree = _proxyList;
			if (_proxyList)
			{
				_proxyList.prevInTree = _proxy;
			}
			_proxyList = _proxy;
			
			_proxy.xl1 = int.MIN_VALUE;
			_proxy.yl1 = int.MIN_VALUE;
			_proxy.xl2 = int.MIN_VALUE;
			_proxy.yl2 = int.MIN_VALUE;
			
			_proxy.proxyObject = proxyObject;
			
			getNodeContaining(_proxy.id).insert(_proxy);
			
			_proxyCount++;
			
			return _proxyId;
		}
		
		public function destroyProxy(proxyId:int):void
		{
			if(proxyId == RxQuadTreeProxyBase.NULL_PROXY)
			{
				return;
			}
			
			var p1:RxQuadTreeProxy = _proxyPool[proxyId];
			var p2:RxQuadTreeProxy;
			
			var s1:IRxProxy = p1.proxyObject;
			var s2:IRxProxy;
			
			var xmin:Number = s1.xmin, xmax:Number = s1.xmax;
			var ymin:Number = s1.ymin, ymax:Number = s1.ymax;
			
			p2 = _proxyList;
			while (p2 != null)
			{
				if (p1 == p2)
				{
					p2 = p2.nextInTree;
					continue;
				}
				
				s2 = p2.proxyObject;
				if (xmin > s2.xmax || xmax < s2.xmin || ymin > s2.ymax || ymax < s2.ymin)
				{
					p2 = p2.nextInTree;
					continue;
				}
				
				p2 = p2.nextInTree;
			}
			
			//unlink from node
			p1.remove();
			
			//unlink from list
			if(p1.prevInTree) 
			{
				p1.prevInTree.nextInTree = p1.nextInTree;
			}
			
			if(p1.nextInTree)
			{
				p1.nextInTree.prevInTree = p1.prevInTree;
			}
			
			if(p1 == _proxyList)
			{
				_proxyList = p1.nextInTree;
			}
			
			//recycle & reset
			p1.setNext(_freeProxy);
			_freeProxy = proxyId;
			p1.reset();
			
			_proxyCount--;
		}
		
		public function moveProxy(proxyId:int):void
		{
			_proxy = _proxyPool[proxyId];
			_s = _proxy.proxyObject;
			
			//early out by comparing integer positions
			_x1 = _s.xmin;
			_y1 = _s.ymin;
			
			if (_proxy.xl1 == _x1 && _proxy.yl1 == _y1)
			{
				return;
			}
			
			_proxy.xl1 = _x1;
			_proxy.yl1 = _y1;
			
			_xl = (_s.xmin + _xOffset) * _xScale;
			_yt = (_s.ymin + _yOffset) * _yScale;
			
			//compute new quad tree position
			_xr = _xl ^ int((_s.xmax + _xOffset) * _xScale);
			_yr = _yt ^ int((_s.ymax + _yOffset) * _yScale);
			
			_level = _depth;
			while (_xr + _yr != 0)
			{
				_xr >>= 1;
				_yr >>= 1;
				_level--;
			}
			
			_shift = _depth - _level;
			_xl >>= _shift;
			_yt >>= _shift;
			
			//early out by comparing node position
			if (_xl == _proxy.xl2 && _yt == _proxy.yl2)
			{
				return;
			}
			
			_proxy.xl2 = _xl;
			_proxy.yl2 = _yt;
			
			_proxy.remove();
			
			_node = _proxy.node = _nodes[int(_offsets[_level] + (_yt << (_level - 1)) + _xl)];
			_node.insert(_proxy);
		}
		
		public function getNodeLevel(proxy:RxQuadTreeProxy):int
		{
			_s = proxy.proxyObject;
			
			//XOR together the start and end positions on each axis
			_xr = int(_s.xmin * _xScale + _xOffset) ^ int(_s.xmax * _xScale + _xOffset);
			_yr = int(_s.ymin * _yScale + _yOffset) ^ int(_s.ymax * _yScale + _yOffset);
			
			//Each bit in the result indicates that the range volume crosses
			//a point at the corresponding power of 2. The bit position of the
			//highest 1 bit indicates how many levels above the bottom of the
			//quadtree the range can first be properly placed.
			_level = _depth;
			
			//count highest bit position
			//to get number of tree levels - bit position */
			while (_xr + _yr != 0)
			{
				_xr >>= 1;
				_yr >>= 1;
				_level--;
			}
			
			return _level;
		}
		
		public function getNodeContaining(proxyId:int):RxQuadTreeNode
		{
			_proxy = _proxyPool[proxyId];
			_s = _proxy.proxyObject;
			
			_x0 = (_s.xmin + _xOffset) * _xScale;
			_y0 = (_s.ymin + _yOffset) * _yScale;
			_x1 = (_s.xmax + _xOffset) * _xScale;
			_y1 = (_s.ymax + _yOffset) * _yScale;
			
			_xr = _x0 ^ _x1;
			_yr = _y0 ^ _y1;
			
			_level = _depth;
			while (_xr + _yr != 0)
			{
				_xr >>= 1;
				_yr >>= 1;
				_level--;
			}
			
			//lookup node pointer in a 2D vector stored linearly,
			//scale coordinates for quadtree level
			_shift = _depth - _level;
			_x0 >>= _shift;
			_y0 >>= _shift;
			return _nodes[int(_offsets[_level] + (_y0 << (_level - 1)) + _x0)];
		}
		
		public function getProxy(proxyId:int):RxQuadTreeProxyBase
		{
			return _proxyPool[proxyId];
		}
		
		public function getProxyList():Vector.<RxQuadTreeProxyBase>
		{
			var list:Vector.<RxQuadTreeProxyBase> = new Vector.<RxQuadTreeProxyBase>(_proxyCount, true);
			var i:int;
			var p:RxQuadTreeProxy = _proxyList;
			while (p != null)
			{
				list[i++] = p;
				p = p.nextInTree;
			}
			
			return list;
		}
		
		
		private function initialize(width:int, height:int):void
		{
			var memory:uint = System.totalMemory;
			
			var i:int, x:int, y:int;
			var xsize:int, ysize:int, treeSize:int, levelEdgeSize:int;
			var offset:int;
			var parentOffset:int;
			var node:RxQuadTreeNode;
			
			treeSize = 1 << (_depth - 1);
			_xScale = treeSize / width;
			_yScale = treeSize / height;
			
			for (i = 0, offset = -1; i < _depth; i++)
			{
				offset += (1 << (i << 1));
			}
			
			i = offset + 1;
			
			_nodes = new Vector.<RxQuadTreeNode>(i, true);
			_offsets = new Vector.<int>(_depth + 1, true);
			_offsets[0] = -1;
			
			//create nodes, lowest -> highest resolution
			offset = -1;
			for (i = 0; i < _depth; i++)
			{
				levelEdgeSize = 1 << i;
				_offsets[int(i + 1)] = offset + 1;
				
				xsize = ysize = treeSize >> i;
				xsize *= width  / treeSize;
				ysize *= height / treeSize;
				
				for (y = 0; y < levelEdgeSize; y++)
				{
					for (x = 0; x < levelEdgeSize; x++)
					{
						node = new RxQuadTreeNode();
						node.xmin = x * xsize + _xmin; 
						node.ymin = y * ysize + _ymin;
						node.xmax = node.xmin + xsize;
						node.ymax = node.ymin + ysize;
						
						_nodes[int((offset + 1) + (y * levelEdgeSize + x))] = node;
					}
				}
				
				offset += (1 << (i << 1));
			}
			
			//setup parent pointer, go from highest -> lowest resolution
			for (i = _depth; i > 1; i--)
			{
				levelEdgeSize = 1 << (i - 1);
				offset        = _offsets[i];
				parentOffset  = _offsets[int(i - 1)];
				
				for (y = 0; y < levelEdgeSize; y++)
				{
					for (x = 0; x < levelEdgeSize; x++)
					{
						_nodes[int(offset + y * levelEdgeSize + x)].parent =
							_nodes[int(parentOffset + (y >> 1) * (levelEdgeSize >> 1) + (x >> 1))];
					}
				}
			}
			
			//initialize proxy pool
			var proxy:RxQuadTreeProxy;
			_proxyPool = new Vector.<RxQuadTreeProxy>(_objectMax, true);
			for (i = 0; i < _objectMax - 1; i++)
			{
				proxy = new RxQuadTreeProxy();
				proxy.id = i;
				proxy.setNext(i + 1);
				_proxyPool[i] = proxy;
			}
			
			proxy = new RxQuadTreeProxy();
			proxy.setNext(RxQuadTreeProxyBase.NULL_PROXY);
			proxy.id = _objectMax - i;
			_proxyPool[_objectMax - 1] = proxy;
			
			_freeProxy = 0;
			
			trace("/*////////////////////////////////////////////////////////*");
			trace(" * QUADTREE STATISTICS");
			trace(" * depth = " + (_depth + 1));
			trace(" * unscaled tree size = " + treeSize + "px");
			trace(" * quad node x-scale  = " + _xScale.toFixed(3));
			trace(" * quad node y-scale  = " + _yScale.toFixed(3));
			trace(" * root node size = " + width + "x" + height + "px");
			trace(" * leaf node size = " + (1 / _xScale).toFixed(3) + "x" + (1 / _yScale).toFixed(3) + "px");
			trace(" * max proxies = " + _objectMax);
			trace(" * memory = " + ((System.totalMemory - memory) >> 10) + " KiB");
			trace(" ////////////////////////////////////////////////////////*/");
			trace("");
		}
	}
}