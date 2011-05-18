package org.rixel.Core.main
{
	import flash.geom.Rectangle;
	
	import org.rixel.Core.Geometry.Rectangle2D;
	import org.rixel.Core.displayObjects.Sprite2D;
	import org.rixel.Core.nameSpaces.rixel;

	use namespace rixel;
	
	public class DirtyRectangles
	{
		
		
		rixel function getRedrawAreas(displayList:Vector.<Sprite2D>):Vector.<Rectangle2D>
		{
			var rectList:Vector.<Rectangle2D> =  createRectangles(displayList);
			
			rectList = mergeIntersects(rectList);
			
			
			return rectList;
		}
		
		private function createRectangles(displayList:Vector.<Sprite2D>):Vector.<Rectangle2D>
		{
			var rectList:Vector.<Rectangle2D> = new Vector.<Rectangle2D>;
			
			for each(var sp:Sprite2D in displayList)
			{
				if(sp.dirty)
				{
					var rect:Rectangle2D = new Rectangle2D(sp.rixel::renderX,sp.rixel::renderY,sp.width,sp.height);
					rectList.push(rect);
				}
			}
			
			return rectList;
		}
		
		//this function takes a list of rectangles and recursively merges them if they are overlapping. The function will continue to call itself 
		//until there are no overlapping rectangles left.
		private function mergeIntersects(rectangleList:Vector.<Rectangle2D>):Vector.<Rectangle2D>
		{
			var mergedRectList:Vector.<Rectangle2D> = new Vector.<Rectangle2D>;
			var numIntersects:int = 0;
			var length:int = rectangleList.length;
			
			for(var i:int = 0; i < length; i++)
			{
				var rect1:Rectangle2D = rectangleList[i] as Rectangle2D;
				var hasIntersected:Boolean = false;
				
				for(var k:int = i + 1; k < length; k++)
				{
					var rect2:Rectangle2D = rectangleList[k] as Rectangle2D;
					
					if( (rect1).intersects(rect2) ) 
					{
						mergedRectList.push( rect1.merge(rect2) );
			
						numIntersects++;
						hasIntersected = true
						
						rectangleList.splice(k,1); 
						length --;
					}
				}
				
				if(!hasIntersected)
				{
					mergedRectList.push(rect1);
				}
			}
			
			if(numIntersects > 0)
			{
				mergedRectList = mergeIntersects(mergedRectList);
			}
			
			return mergedRectList;
		}
		
	}
}