package jing.map.util
{	
	import jing.map.vo.IODataVO;
	import jing.map.vo.ImageVO;
	import jing.map.vo.LibaryVO;
	import jing.map.vo.MapInfoVO;
	import jing.map.vo.MarkVO;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.ByteArray;

	public class MapUtil
	{		
		/**
		 * 根据加载的数据得到地图数据对象VO 
		 * @param mapInfoXML
		 * @param mapLogicPNG
		 * @return 
		 * 
		 */		
		static public function getMapInfoVO(mapInfoXML:XML,mapLogicPNG:BitmapData):MapInfoVO
		{
			var mapInfoVO:MapInfoVO = new MapInfoVO();
			mapInfoVO.name = mapInfoXML.mapInfo.@name;
			mapInfoVO.decription = mapInfoXML.mapInfo.@decription;
			mapInfoVO.unitSize = mapInfoXML.mapInfo.@unitSize;
			mapInfoVO.hasMapIMG = mapInfoXML.mapInfo.@hasMapIMG;
			mapInfoVO.column = mapLogicPNG.width;
			mapInfoVO.row = mapLogicPNG.height;
			mapInfoVO.mapBlockDic = {};
			
			var width:int = mapInfoVO.column;
			var height:int = mapInfoVO.row;
			
			for(var i:int = 0; i < width; i++)
			{
				for(var j:int = 0; j < height; j++)
				{
					var color:uint = mapLogicPNG.getPixel(i,j);
					if(0x000000 != color)
					{
						mapInfoVO.mapBlockDic[i + "_" + j] = MapLogicUtil.colorToValue(color);
					}
					else
					{
						mapInfoVO.mapBlockDic[i + "_" + j] = MapLogicUtil.colorToValue(MapLogicUtil.CAN_NOT_PASS);
					}
				}
			}
			
			var marks:XMLList = mapInfoXML.marks.mark;
			var markVO:MarkVO = null;
			for each(var markNode:XML in marks)
			{
				markVO = new MarkVO();
				markVO.id = markNode.@id;
				markVO.type = markNode.@type;
				markVO.unitX = int(markNode.@unitX);
				markVO.unitY = int(markNode.@unitY);
				mapInfoVO.mapMarkDic[MapUtil.getFlagByPosition(markVO.unitX,markVO.unitY)] = markVO;
			}
			
			var libarys:XMLList = mapInfoXML.libarys.libary;
			var libaryVO:LibaryVO = null;
			mapInfoVO.libaryDic = new Object();
			for each(var libaryNode:XML in libarys)
			{
				libaryVO = new LibaryVO();
				libaryVO.offX = int(libaryNode.@offX);
				libaryVO.offY = int(libaryNode.@offY);
				libaryVO.path = libaryNode.@path;
				mapInfoVO.libaryDic[libaryVO.path] = libaryVO;
			}
			
			var layers:XMLList = mapInfoXML.layers.layer;
			mapInfoVO.layerArray = [];
			for each(var layerNode:XML in layers)
			{
				mapInfoVO.layerArray[int(layerNode.@index)] = layerNode.@id.toString();
			}
			
			var images:XMLList = mapInfoXML.images.image;
			var imageVO:ImageVO = null;
			var imageVOs:Array = [];
			for each(var imageNode:XML in images)
			{
				imageVO = new ImageVO();
				imageVO.libaryVO = mapInfoVO.libaryDic[imageNode.@path];				
				imageVO.layerId = imageNode.@layerId;
				imageVO.unitX = int(imageNode.@unitX);
				imageVO.unitY = int(imageNode.@unitY);
				imageVO.id = imageNode.@id;
				imageVOs.push(imageVO);
			}
			mapInfoVO.imageVOs = imageVOs;
			
			
			
			return mapInfoVO;
		}
		
		/**
		 * 得到和系统交互通信的VO 
		 * @param mapInfoVO
		 * @return 
		 * 
		 */		
		static public function getIODataVO(mapInfoVO:MapInfoVO):IODataVO
		{
			var ioDataVO:IODataVO = new IODataVO();
			
			//根据地图信息重新构建一个mapInfo
			var mapInfo:XML = <mapInfo></mapInfo>;	
			mapInfo.@name = mapInfoVO.name;
			mapInfo.@decription =  mapInfoVO.decription;
			mapInfo.@unitSize = mapInfoVO.unitSize;
			mapInfo.@hasMapIMG = mapInfoVO.hasMapIMG;
			mapInfo = <map>{mapInfo}</map>;
			
			var marks:XML = <marks></marks>;
			var markDic:Object = mapInfoVO.mapMarkDic;
			var markVO:MarkVO = null;
			var mark:XML = null;
			for(var k:String in markDic)
			{
				if(null == markDic[k])
				{
					continue;
				}
				markVO = markDic[k] as MarkVO;
				
				mark = <mark />;
				mark.@id = markVO.id;
				mark.@type = markVO.type;
				mark.@unitX = markVO.unitX;
				mark.@unitY = markVO.unitY;
				marks.appendChild(mark);				
			}
			
			mapInfo.appendChild(marks);
			
			//--------生成库内容描述
			var libaryXML:XML = <libarys></libarys>;
			var libaryDic:Object = mapInfoVO.libaryDic;
			var libaryVO:LibaryVO = null;
			var libaryNode:XML = null;
			for(k in libaryDic)
			{
				if(null == libaryDic[k])
				{
					continue;
				}
				libaryVO = libaryDic[k];
				
				libaryNode = <libary />;
				libaryNode.@offX = libaryVO.offX;
				libaryNode.@offY = libaryVO.offY;
				libaryNode.@path = libaryVO.path;
				libaryXML.appendChild(libaryNode);				
			}
			
			mapInfo.appendChild(libaryXML);
				
			//生成图层描述
			var layerXML:XML = <layers></layers>;
			var layerArray:Array = mapInfoVO.layerArray;
			var layerNode:XML = null;
			var layerCount:int = layerArray.length;
			for(var i:int = 0; i < layerCount; i++)
			{
				layerNode = <layer />;
				layerNode.@index = i;
				layerNode.@id = layerArray[i];
				layerXML.appendChild(layerNode);				
			}
			
			mapInfo.appendChild(layerXML);
			
			//生成图像描述
			var imageXML:XML = <images></images>;
			var images:Array = mapInfoVO.imageVOs;
			var imageVO:ImageVO = null;
			var imageNode:XML = null;
			var imageCount:int = images.length;
			for(var imageIndex:int = 0; imageIndex < imageCount; imageIndex++)
			{
				imageVO = images[imageIndex];
				imageNode = <image />;
				imageNode.@layerId = imageVO.layerId;
				imageNode.@path = imageVO.libaryVO.path;
				imageNode.@unitX = imageVO.unitX;
				imageNode.@unitY = imageVO.unitY;
				imageNode.@id = imageVO.id;
				imageXML.appendChild(imageNode);
			}
			
			mapInfo.appendChild(imageXML);
			
			
			ioDataVO.mapInfo = mapInfo;
			ioDataVO.mapLogic = getMapLogic(mapInfoVO.column,mapInfoVO.row,mapInfoVO.mapBlockDic);
			
			return ioDataVO;
		}
		
		/**
		 * 根据地图逻辑块字典生成位图数据 
		 * @param mapBlockDic
		 * @return 
		 * 
		 */		
		static public function getMapLogic(width:int,height:int,mapBlockDic:Object):BitmapData
		{
			var mapLogic:BitmapData = new BitmapData(width,height,false,0);
			var units:Array = null;
			var color:uint = 0;
			for( var k:String in mapBlockDic)
			{
				if(null == mapBlockDic[k])
				{
					continue;
				}
				units = k.split("_");
				color = MapLogicUtil.valueToColor(mapBlockDic[k]);
				mapLogic.setPixel(int(units[0]),int(units[1]),color);
			}
			return mapLogic;
		}
		
		/**
		 * 通过格子位置返回标识字符串 
		 * @param unitX
		 * @param unitY
		 * @return 
		 * 
		 */		
		static public function getFlagByPosition(unitX:int,unitY:int):String
		{
			return unitX + "_" + unitY;
		}
		
		/**
		 * 通过标识字符串返回格子位置 
		 * @param flag
		 * @return 
		 * 
		 */		
		static public function getPositionByFlag(flag:String):Point
		{
			var units:Array = flag.split("_");
			return new Point(int(units[0]),int(units[1]));
		}
	}
}