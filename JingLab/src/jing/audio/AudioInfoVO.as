package jing.audio
{
	public class AudioInfoVO
	{
		public function AudioInfoVO():void
		{
			
		}
		
		/**
		 * 声音的ID 
		 */		
		public var id:String;
		
		/**
		 * 使用的播放器的名称 
		 */		
		public var playerName:String;
		
		/**
		 * 播放源的类型,默认为0
		 * <ui>
		 * 	<li>0:外部资源</li>
		 *  <li>1:内部资源</li>
		 * </ui> 
		 */		
		public var sourceType:int = 0;
		
		/**
		 * 播放资源的源
		 * <ui>
		 * 	<li>sourceType为0:表示URL地址</li>
		 *  <li>sourceType为1:表示类对象</li>
		 * </ui> 
		 */		
		public var source:String;
	}
}