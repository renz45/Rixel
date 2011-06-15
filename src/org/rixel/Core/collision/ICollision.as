package org.rixel.Core.collision
{
	import flash.display.BitmapData;
	
	import org.rixel.Core.main.IRender;
	import org.rixel.Core.quadTree.RxProxyBase;
	import org.rixel.Core.quadTree.RxQuadTreeProxy;

	public interface ICollision extends IRender
	{
		function get collisionFrame():BitmapData;
		function get proxy():RxQuadTreeProxy;
	}
}