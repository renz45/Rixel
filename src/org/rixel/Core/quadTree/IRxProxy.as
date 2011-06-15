package org.rixel.Core.quadTree
{
	public interface IRxProxy
	{
		function get xmin():int;
		function get xmax():int;
		function get ymin():int;
		function get ymax():int;
		function get proxy():RxQuadTreeProxy;
	}
}