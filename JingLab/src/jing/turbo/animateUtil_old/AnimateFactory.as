package jing.turbo.animateUtil_old
{
	import jing.turbo.animateUtil_old.interfaces.ILoaderReport;
	import jing.turbo.animateUtil_old.loader.AnimateLoader;
	import jing.turbo.animateUtil_old.vos.AnimateLoaderVO;
	import jing.turbo.animateUtil_old.vos.AnimateVO;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 动画引擎库
	 * @author jing
	 * 
	 */	
	public class AnimateFactory
	{		
		static private var animatePool:Object = null;
		
		/**
		 * 将加载好的对象放到内存池中 
		 * @param vo
		 * 
		 */		
		static public function putAnimateVOInPool(vo:AnimateVO):void
		{
			if(null == animatePool)
			{
				animatePool = new Object();
			}
			
			animatePool[vo.fileDirPath] = vo;
		}
		
		/**
		 * 加载素材文件 
		 * @param vo 素材加载的依据参数
		 * @return 
		 * 
		 */		
		static public function loadAsset(vo:AnimateLoaderVO):Boolean
		{
			var wrongStr:String = "AnimateLoaderVO Wrong: ";
			with(vo)
			{
				if(null == path)
				{
					throw new Error(wrongStr + "没有路径！");
				}
				else if(null == actionName)
				{
					throw new Error(wrongStr + "没有动作名称！");
				}
				else if(int.MAX_VALUE == frameCount)
				{
					throw new Error(wrongStr + "没有动作的帧数！");
				}
				else if(int.MAX_VALUE == frameStartIndexFormat)
				{
					throw new Error(wrongStr + "没有动画帧的起始索引！");
				}
				else if(int.MAX_VALUE == direction)
				{
					throw new Error(wrongStr + "没有方向数量！");
				}
				else if(int.MAX_VALUE == directionStartIndexFormat)
				{
					throw new Error(wrongStr + "没有方向的起始索引");
				}
				else if(null == iReport)
				{
					throw new Error(wrongStr + "没有接收回调的对象");
				}
				else if(int.MAX_VALUE == imgUnitWidth)
				{
					throw new Error(wrongStr + "没有单位的宽度");
				}
				else if(int.MAX_VALUE == imgUnitHeight)
				{
					throw new Error(wrongStr + "没有单位的高度");
				}
				else if(null == originPoint)
				{
					throw new Error(wrongStr + "没有注册点");
				}	
				else if(int.MAX_VALUE == oneFrameTime)
				{
					throw new Error(wrongStr + "没有动画速度");
				}
			}
			
			if(null != animatePool && null != animatePool[vo.path])
			{
				//如果是数据池中已有的数据，则直接返回
				vo.iReport.report(animatePool[vo.path] as AnimateVO);
			}
			else
			{			
				trace("加载新数据!");
				var aLoader:AnimateLoader =  new AnimateLoader(vo);
				aLoader.load();
			}
			return true;
		}	
	}
}