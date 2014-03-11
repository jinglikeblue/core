package jing.audio
{
	/**
	 * 每一个声音的设置数据 
	 * @author Jing
	 * 
	 */	
	public class AudioSetting
	{
		public function AudioSetting():void
		{
			
		}
		
		private var _type:uint = 0;

		/**
		 * 声音的类型(用来区分背景、效果、人声等的标识) 
		 */
		public function get type():uint
		{
			return _type;
		}

		/**
		 * @private
		 */
		public function set type(value:uint):void
		{
			_type = value;
		}

		
		private var _track:int = 0;

		/**
		 * 声音的轨道(不同轨道的声音可以并存播放，一个轨道同一时间只能播放一种声音),一次最多可以使用32个音轨
		 */
		public function get track():int
		{
			return _track;
		}

		/**
		 * @private
		 */
		public function set track(value:int):void
		{
			if(value < 0 || value > 32)
			{
				throw new Error("track value must between 0 and 32");
			}
			_track = value;
		}

		
		private var _isLoop:Boolean = false;

		/**
		 * 声音是否循环播放 
		 */
		public function get isLoop():Boolean
		{
			return _isLoop;
		}

		/**
		 * @private
		 */
		public function set isLoop(value:Boolean):void
		{
			_isLoop = value;
		}
		
		private var _volume:Number = 1;

		/**
		 * 音量大小，为0和1之间的值
		 * 默认为1 
		 */
		public function get volume():Number
		{
			return _volume;
		}

		/**
		 * @private
		 */
		public function set volume(value:Number):void
		{
			_volume = value;
		}

		
		private var _deep:Number = 1;

		/**
		 * 声音的深度，声音的值乘以深度为最后播出的声音大小，默认为1 
		 */
		public function get deep():Number
		{
			return _deep;
		}

		/**
		 * @private
		 */
		public function set deep(value:Number):void
		{
			_deep = value;
		}

		/**
		 * 得到对象的复制品 
		 * @return 
		 * 
		 */		
		public function clone():AudioSetting
		{
			var cloneObj:AudioSetting = new AudioSetting();
			cloneObj.deep = this.deep;
			cloneObj.isLoop = this.isLoop;
			cloneObj.track = this.track;
			cloneObj.type = this.type;
			cloneObj.volume = this.volume;
			return cloneObj;
		}
	}
}