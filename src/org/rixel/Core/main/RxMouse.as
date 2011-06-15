package org.rixel.Core.main
{
	import org.rixel.Core.quadTree.IRxProxy;
	import org.rixel.Core.quadTree.RxQuadTreeProxy;

	public class RxMouse implements IRxProxy
	{
		private var _x:int;
		private var _y:int;
		
		public function RxMouse()
		{
			
		}
		
		
		
		////////////////GETTERS/SETTERS////////////////
		public function get xmin():int
		{
			return _x;
		}
		
		public function get xmax():int
		{
			return _x + 1;
		}
		
		public function get ymin():int
		{
			return _y;
		}
		
		public function get ymax():int
		{
			return _y + 1;
		}
		
		public function get proxy():RxQuadTreeProxy
		{
			return null;
		}
	}
}