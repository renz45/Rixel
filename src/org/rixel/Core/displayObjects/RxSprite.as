package org.rixel.Core.displayObjects
{
	import org.rixel.Core.displayObjects.bitmap.RxComponent_BitmapSprite;
	/**
	 * Creates a RxSprite
	 *  
	 * @author adamrensel
	 * 
	 */	
	public class RxSprite extends Abstract_RxDisplayObject
	{
		private var _class:Class;
		private var _params:Object;
		
		/**
		 * constructor for creating a RxSprite. 
		 * @param spriteClass : Class This is not an instance of the sprite, it is the classname of the sprite. The RxSprite class will decide if it can reuse
		 * data previously converted, or if it needs to create and convert a new instance of the sprite Class passed in.
		 * @param params : Object settings object for the RxSprite class. The current settings are {fillColor:0x00000000, transparent:true}
		 * 
		 */	
		public function RxSprite(spriteClass:Class,params:Object = null)
		{
			_class = spriteClass;
			_params = params;
			
			super();
		}
		
		/**
		 * setup the renderer for this class 
		 * 
		 */		
		override protected function setupDisplayable():void
		{
			_component_displayable = new RxComponent_BitmapSprite(_class,_params);
		}
		
		///////////////CALLBACKS///////////////
		///////////PUBLIC FUNCTIONS////////////
		
		
		////////////GETTERS SETTERS////////////
	
	}
} 