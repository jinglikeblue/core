package jing.ui.yrtlib.compment.model
{
	import jing.ui.yrtlib.compment.events.ModelEvent;
	
	import flash.events.EventDispatcher;

	/**
	 * 范围数据模型
	 * @author jing
	 *
	 */
	[Event(name="StateChanged", type="jing.ui.yrtlib.compment.events.ModelEvent")]
	public class RangeModel extends EventDispatcher
	{
		private var _value:int = 0;

		/**
		 * 当前值
		 */
		public function get value():int
		{
			return _value;
		}

		/**
		 * @private
		 */
		public function set value(value:int):void
		{
			var newValue:int = Math.min(value,_max - _extent);
			newValue = Math.max(newValue,_min);
			
			if(_value == newValue)
			{
				return;
			}
			_value = newValue;
			updateModel();
		}


		private var _extent:int = 0;

		/**
		 * 忽略的值
		 */
		public function get extent():int
		{
			return _extent;
		}

		/**
		 * @private
		 */
		public function set extent(value:int):void
		{
			var newExtent:int = Math.max(0, value);
			if(_value + newExtent > max)
			{
				newExtent = max - _value;
			}			
			_extent = newExtent;
			updateModel();
		}


		private var _min:int = 0;

		/**
		 * 最小值
		 */
		public function get min():int
		{
			return _min;
		}

		/**
		 * @private
		 */
		public function set min(value:int):void
		{
			_min = value;
			updateModel();
		}


		private var _max:int = 0;

		/**
		 * 最大值
		 */
		public function get max():int
		{
			return _max;
		}

		/**
		 * @private
		 */
		public function set max(value:int):void
		{
			_max = value;
			updateModel();
		}


		/**
		 * 范围数据模型
		 * @param value 当前值
		 * @param extent 忽略的值
		 * @param min 最小值
		 * @param max 最大值
		 *
		 */
		public function RangeModel(value:int = 0, extent:int = 0, min:int = 0, max:int = 100):void
		{
			if (value + extent <= max && max >= min && value + extent >= value && value >= min)
			{
				_value = value;
				_extent = extent;
				_min = min;
				_max = max;
			}
			else
			{
				throw new Error("数值不合理:  min <= value <= value+extent <= max");
			}
		}
		
		public function updateModel():void
		{
			this.dispatchEvent(new ModelEvent(ModelEvent.STATE_CHANGED));
		}
	}
}