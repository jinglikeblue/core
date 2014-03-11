package jing.audio
{
	import flash.utils.Dictionary;
	
	import jing.audio.audioPlayers.AudioMP3Player;

	/**
	 * 声音驱动器 
	 * @author Jing
	 * 
	 */	
	public class AudioDevice
	{
		/**
		 * 播放MP3声音文件的播放器 
		 */		
		static public const PLAYER_MP3:String = "playerMP3";
		
		/**
		 * 播放SWF中声音元件的播放器 
		 */		
		static public const PLAYER_SYMBOL:String = "playerSymbol";
		
		/**
		 * 播放器类字典 
		 */		
		private var _playerClassDic:Dictionary;
		
		/**
		 * 声音信息字典 
		 */		
		private var _audioInfoDic:Dictionary;
		
		/**
		 * 正在播放的音轨字典 
		 */		
		private var _audioTrackDic:Dictionary;
		
		public function AudioDevice()
		{
			init();
		}
		
		private function init():void
		{
			_playerClassDic = new Dictionary();
			_audioInfoDic = new Dictionary();
			_audioTrackDic = new Dictionary();
			
			//记录两个默认的播放器
			registPlayer(PLAYER_MP3,AudioMP3Player);		
		}
		
		/**
		 * 注册一个播放器 
		 * @param playerName 播放器的名称，和BaseAudioInfo的playerName匹配
		 * @param playerCls
		 * 
		 */		
		public function registPlayer(playerName:String, playerCls:Class):void
		{
			_playerClassDic[playerName] = playerCls;
		}
		
		/**
		 * 注册一个声音信息 
		 * @param baseAudioInfo 声音信息
		 * 
		 */		
		public function registAudioInfo(baseAudioInfo:AudioInfoVO):void
		{
			_audioInfoDic[baseAudioInfo.id] = baseAudioInfo;
		}
		
		/**
		 * 播放声音 
		 * @param audioId
		 * 
		 */		
		public function play(audioId:String, audioSetting:AudioSetting = null):void
		{
			var audioInfo:AudioInfoVO = _audioInfoDic[audioId];
			if(null == audioInfo)
			{
				return;
			}
			
			var playerCls:Class = _playerClassDic[audioInfo.playerName];
			if(null == playerCls)
			{
				return;
			}
			
			if(null == audioSetting)
			{
				audioSetting = new AudioSetting();
			}
			
			var playerOnTrack:IAudioPlayer = _audioTrackDic[audioSetting.track];
			if(null != playerOnTrack)
			{
				playerOnTrack.dispose();
			}
			
			var player:IAudioPlayer = new playerCls() as IAudioPlayer;
			player.init(audioInfo,audioSetting);
			player.play();
			
			_audioTrackDic[audioSetting.track] = player;
		}
	}
}