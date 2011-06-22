package org.rixel.Core.main
{
	import org.rixel.Core.displayObjects.bitmap.RxComponent_BitmapAnimation;
	import org.rixel.Core.displayObjects.bitmap.RxComponent_BitmapSprite;

	public class Rixel
	{
		public function Rixel()
		{
		}
		
		///////////////CALLBACKS///////////////
		///////////PUBLIC FUNCTIONS////////////
		////////////GETTERS SETTERS////////////
		
		public static function init():void
		{
			RxComponent_BitmapSprite.init();
			RxComponent_BitmapAnimation.init();
			RxStage.init();
		}
	}
}