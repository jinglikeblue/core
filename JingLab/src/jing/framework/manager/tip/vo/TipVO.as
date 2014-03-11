package jing.framework.manager.tip.vo
{
	import flash.geom.Point;

	/**
	 * Tip数据的VO对象
	 * @author Jing
	 *
	 */
	public class TipVO
	{
		/**
		 * 必要参数
		 * 描述这个TIP的Type对应的显示种类
		 */
		public var tipType:String=null;

		/**
		 * 对应Tip对象需要显示的数据
		 */
		public var tipData:Object=null;
		
		/**
		 * 可选参数
		 * 指定显示tip的X、Y坐标，系统将不计算显示。
		 * ！这里的X，Y坐标是相对于舞台左上角的坐标
		 */		
		public var tipPos:Point = null;
		
		/**
		 * 可选参数
		 * 指定显示的tip与tipUser之间的间隔距离
		 */		
		public var tipMargin:Point = null;
		
		/**
		 * 当前TipVO附加显示的Tip 
		 */		
		public var appendTipVO:Vector.<TipVO> = null;
		
		/**
		 * 描述这个TIP的Type对应的显示种类
		 * @param tipType
		 * 
		 */		
		public function TipVO(tipType:String):void
		{
			this.tipType = tipType;
		}
	}
}