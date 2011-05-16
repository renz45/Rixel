package org.rixel.Core.main
{
	import flash.geom.Rectangle;
	
	import org.rixel.Core.displayObjects.Sprite2D;
	import org.rixel.Core.nameSpaces.rixel;

	public class DirtyRectangles
	{
		
		rixel function getRedrawAreas(displayList:Vector.<Sprite2D>):Vector.<Rectangle>
		{
			var rectList:Vector.<Rectangle> = new Vector.<Rectangle>;
			
			rectList = createRectangles(displayList);
			
			
			
			return rectList;
		}
		
		private function createRectangles(displayList:Vector.<Sprite2D>):Vector.<Rectangle>
		{
			var rectList:Vector.<Rectangle> = new Vector.<Rectangle>;
			
			for each(var sp:Sprite2D in displayList)
			{
				var rect:Rectangle = new Rectangle(sp.rixel::renderX,sp.rixel::renderY,sp.width,sp.height);
				rectList.push(rect);
			}
			
			return rectList;
		}
		
		private function mergeIntersects(rectangleList:Vector.<Rectangle>):Vector.<Rectangle>
		{
			var rectList:Vector.<Rectangle> = new Vector.<Rectangle>;
			var numIntersects:int = 0;
			var length:int = rectangleList.length;
			
			for(var i:int = 0; i < length; i++)
			{
				for(var k:int = i + 1; k < length; i++)
				{
					if((rectangleList[i] as Rectangle).intersects(rectangleList[k]))
					{
						
					}
				}
			}
			
			
			
			return rectList;
		}
		
	}
}