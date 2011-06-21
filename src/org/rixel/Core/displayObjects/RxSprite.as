package org.rixel.Core.displayObjects
{
	import org.rixel.Core.displayObjects.bitmap.RxComponent_BitmapAnimation;
	import org.rixel.Core.displayObjects.bitmap.RxComponent_BitmapSprite;
	
	public class RxSprite extends Abstract_RxDisplayObject
	{
		private var _class:Class;
		private var _params:Object;
		
		public function RxSprite(spriteClass:Class,params:Object = null)
		{
			_class = spriteClass;
			_params = params;
			init();
			
			super();
		}
		
		private function init():void
		{
			
		}
		
		override protected function setupDisplayable():void
		{
			_component_displayable = new RxComponent_BitmapSprite(_class,_params);
		}
		
		///////////////CALLBACKS///////////////
		///////////PUBLIC FUNCTIONS////////////
		
		
		////////////GETTERS SETTERS////////////
	
	}
} 