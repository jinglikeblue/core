package jing.turbo.strip
{
    import jing.turbo.strip.vo.MultiStripConfigUnitVO;
    import jing.turbo.strip.vo.MultiStripConfigVO;
    import jing.turbo.strip.vo.StripConfigVO;
    import jing.turbo.strip.vo.StripVO;
    
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.getTimer;

    /**
     * 图像处理工厂
     * @author jing
     *
     */
    public class StripFactory
    {
        static public function loadStrip(configVO:StripConfigVO):void
        {
            var sl:StripLoader = new StripLoader();
            sl.load(configVO);
        }

        static public function loadMultiStrip(configVO:MultiStripConfigVO):void
        {
            var msl:MultiStripLoader = new MultiStripLoader();
            msl.load(configVO);
        }

        /**
         * 切割一张序列图为单元图片集合
         * @param bmd 源图
         * @param unitW 单张图片宽
         * @param unitY 单张图片高
         * @param frameCount 包含的图片帧数
         * @return
         *
         */
        static public function createStripDatas(source:BitmapData, unitW:int, unitH:int, frameCount:int, transparent:Boolean):Vector.<BitmapData>
        {
            var bmds:Vector.<BitmapData> = new Vector.<BitmapData>();

            var column:int = source.width / unitW;
            var row:int = source.height / unitH;

            trace("切割图片的为 " + row + "行" + column + "列");

            var cutedBmd:BitmapData = null;
            var cutRect:Rectangle = new Rectangle();
            cutRect.width = unitW;
            cutRect.height = unitH;

            var destPoint:Point = new Point(0, 0);

            //按照从左到右，从上到下的顺序来截取图片			
            for (var i:int = 0; i < row; i++)
            {
                for (var j:int = 0; j < column; j++)
                {
                    cutedBmd = new BitmapData(unitW, unitH, transparent, 0);
                    cutRect.x = j * unitW;
                    cutRect.y = i * unitH;
                    cutedBmd.copyPixels(source, cutRect, destPoint);
                    bmds.push(cutedBmd);

                    frameCount--;

                    if (0 == frameCount)
                    {
                        //当预定帧数的图片截取完毕了，退出截取
                        break;
                    }

                }
            }

            return bmds;
        }

        /**
         * 将图片序列图按照配置切割为分段式的连环画
         * @param bmds
         * @param configVO
         * @return
         *
         */
        //		static public function cretaeMultiStrip(bmds:Vector.<BitmapData>, configVO:MultiStripConfigVO):Object
        //		{
        //			var stripVODic:Object=new Object();
        //
        //			var allCount:int=bmds.length;
        //			var nowUseUnitIndex:int=0;
        //			var nowUnit:MultiStripConfigUnitVO=configVO.units[nowUseUnitIndex];
        //
        //			var tempBMDs:Vector.<BitmapData>=new Vector.<BitmapData>();
        //
        //			for (var i:int=0; i < allCount; i++)
        //			{
        //
        //
        //				tempBMDs.push(bmds[i]);
        //
        //				if ((i + 1) == (nowUnit.startFrame + nowUnit.frameCount))
        //				{
        //
        //					var sc:StripConfigVO=new StripConfigVO();
        //					sc.name=nowUnit.name;
        //					sc.originX=configVO.originX;
        //					sc.originY=configVO.originY;
        //					sc.transparent=configVO.transparent;
        //					sc.unitH=configVO.unitH;
        //					sc.unitW=configVO.unitW;
        //
        //					stripVODic[nowUnit.name]=createStripVO(tempBMDs, sc);
        //					tempBMDs.length=0;
        //
        //
        //
        //					nowUseUnitIndex++;
        //
        //					if (nowUseUnitIndex == configVO.units.length)
        //					{
        //						break;
        //					}
        //
        //					nowUnit=configVO.units[nowUseUnitIndex];
        //				}
        //			}
        //
        //			return stripVODic;
        //		}

		/**
		 * 将图片序列图按照配置切割为分段式的连环画
		 * @param bmds
		 * @param configVO
		 * @return
		 *
		 */
        static public function cretaeMultiStrip(bmds:Vector.<BitmapData>, configVO:MultiStripConfigVO):Object
        {
            var stripVODic:Object = new Object();

//			var time:Number = getTimer();
			
            var units:Vector.<MultiStripConfigUnitVO> = configVO.units;

            for (var i:int = 0; i < units.length; i++)
            {
                var unitTempBmds:Vector.<BitmapData> = new Vector.<BitmapData>();

                var startFrame:int = units[i].startFrame;
                var endFrame:int = units[i].startFrame + units[i].frameCount;

                for (var j:int = startFrame; j < endFrame; j++)
                {
                    unitTempBmds.push(bmds[j]);
                }

                var sc:StripConfigVO = new StripConfigVO();
                sc.name = units[i].name;
                sc.originX = configVO.originX;
                sc.originY = configVO.originY;
                sc.transparent = configVO.transparent;
                sc.unitH = configVO.unitH;
                sc.unitW = configVO.unitW;
				
				stripVODic[units[i].name]=createStripVO(unitTempBmds, sc);
            }

//			time = getTimer() - time;
			
//			trace("消耗时间： ", time + "MS");
			
            return stripVODic;
        }

        /**
         * 通过裁切好的连环画图像数据和配置VO对象，生成连环画数据
         * @param bmds
         * @param configVO
         * @return
         *
         */
        static public function createStripVO(bmds:Vector.<BitmapData>, configVO:StripConfigVO):StripVO
        {
            trace(bmds.length);
            var vo:StripVO = new StripVO();
            vo.name = configVO.name;
            vo.length = bmds.length;

            var length:int = bmds.length;

            //遍历每一张图片并求出占用面积最小的公共矩形范围
            var maxRect:Rectangle = null;

            //有颜色的范围
            var colorRect:Rectangle = null;

            var bmd:BitmapData = null;

            while (--length > -1)
            {
                bmd = bmds[length];
                colorRect = bmd.getColorBoundsRect(0xFF000000, 0xFF000000); //(0xFF000000, 0x00000000, false); //(0xFF000000,0xFF000000)

                if (null == maxRect)
                {
                    maxRect = new Rectangle();
                    maxRect.x = colorRect.x;
                    maxRect.y = colorRect.y;
                    maxRect.right = colorRect.right;
                    maxRect.bottom = colorRect.bottom;
                }
                else
                {
                    maxRect.left = maxRect.left < colorRect.left ? maxRect.left : colorRect.left;
                    maxRect.top = maxRect.top < colorRect.top ? maxRect.top : colorRect.top;
                    maxRect.right = maxRect.right > colorRect.right ? maxRect.right : colorRect.right;
                    maxRect.bottom = maxRect.bottom > colorRect.bottom ? maxRect.bottom : colorRect.bottom;
                }
            }

            //得到最大矩形范围后开始截取图片
            length = bmds.length;
            var optimizeBMD:BitmapData = null;
            var destPoint:Point = new Point();
            var optimizeBMDS:Vector.<BitmapData> = new Vector.<BitmapData>();

            for (var i:int = 0; i < length; i++)
            {
                bmd = bmds[i];
                optimizeBMD = new BitmapData(maxRect.width, maxRect.height, configVO.transparent, 0);
                optimizeBMD.copyPixels(bmd, maxRect, destPoint);
                optimizeBMDS.push(optimizeBMD);
                bmd.dispose(); //销毁老的数据
            }
            vo.pictures = optimizeBMDS;

            vo.originX = configVO.originX - maxRect.left;
            vo.originY = configVO.originY - maxRect.top;


            return vo;
        }
    }
}