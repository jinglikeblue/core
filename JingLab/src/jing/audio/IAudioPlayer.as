package jing.audio
{

	/**
	 * 声音播放器接口 
	 * @author Jing
	 * 
	 */	
	public interface IAudioPlayer
	{
		/**
		 * 初始化播放器 
		 * @param audioInfo 声音的信息文件
		 * @param audioSetting 声音的配置 
		 */		
		function init(audioInfo:AudioInfoVO, audioSetting:AudioSetting):void;
		
		/**
		 * 开始播放 
		 * 
		 */		
		function play():void;
		
		/**
		 * 暂停播放 
		 * 
		 */		
		function pause():void;
		
		/**
		 * 停止播放 
		 * 
		 */		
		function stop():void;
		
		/**
		 * 销毁播放器 
		 * 
		 */		
		function dispose():void;
		
		/**
		 * 设置设备音量 
		 * @param deviceVolume
		 * 
		 */		
		function setDeviceVolume(deviceVolume:Number):void;
	}
}