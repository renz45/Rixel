package org.rixel.Core.displayObjects
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import org.osflash.signals.Signal;
	import org.rixel.Core.collision.ICollision;
	import org.rixel.Core.collision.RxCollision;
	import org.rixel.Core.displayObjects.VO.Sprite_VO;
	import org.rixel.Core.main.IBitmapRender;
	import org.rixel.Core.nameSpaces.rixel;
	import org.rixel.Core.quadTree.IRxProxy;
	import org.rixel.Core.quadTree.RxQuadTreeProxy;
	
	use namespace rixel;

	public class RxSprite extends RxDisplayObject implements IBitmapRender, ICollision, IRxProxy
	{	
		
		protected var _className:String;
		protected var _displayObjectClass:Class;
		protected var _collisionManager:RxCollision;
		
		private var _frameData:BitmapData;
		
		
		protected static var _displayObjectList:Object;
		protected static var _placeHolderData:BitmapData;
		
		///////quadtree
		private var _proxy:RxQuadTreeProxy;
		private var _proxyId:int;
		
		//////Events
		public var Event_MouseOver:Signal;
		
		public function RxSprite(sprite:Class, params:Object = null)
		{
			super(params);
			
			_displayObjectClass = sprite;
			_className = (sprite as Class).toString();
			
			init(); 
			initEvents();
		}
		
		protected function init():void
		{	
			
			_collisionManager = new RxCollision(this);
			
			_dirty = false;
			
			var objectExists:Boolean = _displayObjectList.hasOwnProperty(_className);

			if( !objectExists )
			{	
				
				var newClass:Sprite = new _displayObjectClass();
				
				if( !(newClass is Sprite) )
				{
					throw new Error("The class argument must be of type Sprite");
				}
				
				var vo:Sprite_VO = new Sprite_VO();
				vo.name = _className;
				
				_displayObjectList[_className] = vo;
				
				convertSprite(newClass); 
			}
			
			
		}
		
		private function initEvents():void
		{
			Event_MouseOver = new Signal()
		}
		
		private function convertSprite(sprite:Sprite):void
		{
			_frameData = new BitmapData(sprite.width,sprite.height,_transparent,_fillColor);
			
			_frameData.draw(sprite);
			
			Event_MovieclipLoaded.dispatch(this);
		}

		/////////////////////CALLBACKS////////////////////
		
		
		////////////////////PUBLIC METHODS/////////////////
		public function get collision():RxCollision
		{
			return _collisionManager;
		} 
		
		
		////////////////////GETTERS SETTERS////////////////
		public function get name():String
		{
			return _className;
		}
		
		public function set name(value:String):void
		{
			_className = value;
		}
		
		public function get proxy():RxQuadTreeProxy
		{
			return _proxy;
		}
		
		public function set proxy(node:RxQuadTreeProxy):void
		{
			_proxy = node;
		}
		
		public function get proxyId():int
		{
			return _proxyId;
		}
		
		public function set proxyId(value:int):void
		{
			_proxyId = value;
		}
		
		//////////////////engine specific/////////////
		
		//these render values will account for the offset of the movieclip. So if a registration point was in the center the position will be the same
		//the function is a engine specific function since users don't need to see these values.
		public function get boundsX():int
		{
			return _x;
		}
		
		public function get boundsY():int
		{
			return _y;
		}
		
	
		
		//engine specific function used by the Stage2D to render the image.
		override public function get frame():BitmapData 
		{
			_collisionManager.update();
			
			if(_frameData)
			{
				return _frameData; 
			}else{
				return _placeHolderData;
			}
		}
		
		//used for bitmap data collision so the frame doesn't get advanced to the next frame
		public function get collisionFrame():BitmapData
		{
			if(_frameData)
			{
				return _frameData; 
			}else{
				return _placeHolderData;
			}
		}

		/*rixel function get dirty():Boolean
		{
			return _dirty;
		}
		
		rixel function set dirty(value:Boolean):void
		{
			_dirty = value; 
			if(value == true)
			{
				Event_IsDirty.dispatch(this);
			}
		}*/
		
		rixel function triggerMouseOver():void
		{
			
		}
		
		///////////////////STATICS////////////////////////
		rixel static function init():void
		{
			_displayObjectList = {};
			_placeHolderData = new BitmapData(1,1,false);
		}

		
	}
}