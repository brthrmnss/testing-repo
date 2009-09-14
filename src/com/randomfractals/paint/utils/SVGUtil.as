/*
Copyright (c) 2009 Random Fractals, Inc. (www.randomfractals.com)

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/
package com.randomfractals.paint.utils
{
	import com.degrafa.GeometryGroup;
	import com.degrafa.IGeometry;
	import com.degrafa.core.IGraphicsStroke;
	import com.degrafa.core.utils.ColorUtil;
	import com.degrafa.geometry.Path;
	import com.degrafa.paint.SolidStroke;
	
	public class SVGUtil
	{
		public static function getSVGHeader(width:Number, height:Number):String
		{			
			var header:String = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?> \r' +
				'<!-- \r' + 
				'Created with Degrafa SVG Painter v.0.1 \r' + 
				'(http://www.randomfractals.com/lab/DegrafaSVGPainter/01/DegrafaSVGPainter.html) \r' + 
				'--> \r' +
				'<svg width="' + width + '\" height="' + height +
				'" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"> \r';
			return header;
		}
		
		public static function getGeometryString(geometry:IGeometry, 
			fillColor:uint, indent:uint = 2):String
		{
			var indentStr:String = getIndentString(indent);
			var svgText:String = '';
			if (geometry is GeometryGroup)
			{
				var group:GeometryGroup = geometry as GeometryGroup;
				
				svgText += indentStr + '<g id="' + group.id +
					'" style="fill: ' + ColorUtil.decColorToHex(fillColor, "#") +  '"> \r';
					
				if (group.geometryCollection.items.length > 0)
				{
					for each (var node:IGeometry in group.geometryCollection.items)
					{
						svgText += getGeometryString(node, fillColor, indent+2);
					}
				}
				svgText += indentStr + '</g> \r';
			}
			else if (geometry is Path)
			{
				var path:Path = geometry as Path;												
				svgText += indentStr + '<path id="' + path.id + '" \r' +
					indentStr + getStyleString(path.stroke) + 
					indentStr + '  d="' + path.data + '\" /> \r';
			}
			return svgText;
		}
	
		public static function getStyleString(stroke:IGraphicsStroke):String
		{
			var strokeStr:String = '';
			if (stroke is SolidStroke)
			{
				var solidStroke:SolidStroke = stroke as SolidStroke;
				strokeStr += '  style="' +
					'stroke: ' + ColorUtil.decColorToHex(uint(solidStroke.color), "#") +
					'; stroke-width: ' + solidStroke.weight +
					'; stroke-opacity: ' + solidStroke.alpha.toString().substr(0, 4) +						 
					'; stroke-linecap: ' + solidStroke.caps +
					'; stroke-linejoin: ' + solidStroke.joints + 
					'" \r';	
			}
			return strokeStr;
		}
		
		private static function getIndentString(indent:uint):String
		{
			var indentString:String = '';
			for (var i:uint = 0; i<indent; i++)
			{
				indentString += ' ';
			}
			return indentString;
		}
	}
}