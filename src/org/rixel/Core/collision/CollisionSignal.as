package org.rixel.Core.collision
{
	import mx.states.OverrideBase;
	
	import org.osflash.signals.ISignalBinding;
	import org.osflash.signals.Signal;
	
	public class CollisionSignal extends Signal
	{
		public var numberOfListeners:int = 0;
		
		public function CollisionSignal(...valueClasses)
		{
			super(valueClasses);
		}
		
		override public function add(listener:Function):ISignalBinding
		{
			numberOfListeners ++;
			return super.add(listener);
		}
		
		override public function remove(listener:Function):ISignalBinding
		{
			numberOfListeners --;
			return super.remove(listener);
		}
		
		override public function removeAll():void
		{
			numberOfListeners = 0;
			
			super.removeAll();
		}

		//not to be used, will throw off the count, better to use the remove method in the callback function. This is done for the sake of speed.
		override public function addOnce(listener:Function):ISignalBinding
		{
			throw new Error("This method can't be used with the collision class, use the remove method in the callback if running the callback once is required");
		}
		
		//use the property numberOfListeners instead, it is much faster
		override public function get numListeners():uint
		{
			throw new Error("user the property numberOfListeners instead, this method is depreciated and slow");
			return 0;
		}
	}
}