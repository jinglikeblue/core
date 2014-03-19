package jing.audio.audioPlayers
{
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundTransform;
    import flash.net.URLRequest;
    import flash.utils.getDefinitionByName;
    
    import jing.audio.AudioInfoVO;
    import jing.audio.AudioSetting;
    import jing.audio.IAudioPlayer;

    /**
     * MP3播放器
     * @author Jing
     *
     */
    public class AudioMP3Player implements IAudioPlayer
    {
		public function AudioMP3Player():void
		{
			
		}
		
		/**
		 * 声音信息  
		 */		
        private var _audioInfo:AudioInfoVO;

		/**
		 * 声音配置 
		 */		
        private var _audioSetting:AudioSetting;

		/**
		 * 声音对象 
		 */		
        private var _sound:Sound;

		/**
		 * 声音通道 
		 */		
        private var _soundChannel:SoundChannel;
		
		/**
		 * 是否正在播放中 
		 */		
		private var _isPlaying:Boolean = false;
		
		/**
		 * 设备音量 
		 */		
		private var _deviceVolume:Number = 1;

        public function init(audioInfo:AudioInfoVO, audioSetting:AudioSetting):void
        {
            dispose();
            _audioInfo = audioInfo as AudioInfoVO;
            _audioSetting = audioSetting;
        }

		/**
		 * 设置设备音量 
		 * @param deviceVolume
		 * 
		 */		
		public function setDeviceVolume(deviceVolume:Number):void
		{
			_deviceVolume = deviceVolume;
			if(_soundChannel != null)
			{
				_soundChannel.soundTransform = new SoundTransform(getSoundVolume());
			}
		}
		
		/**
		 * 获取音量 
		 * @return 
		 * 
		 */
		[inline]
		private function getSoundVolume():Number
		{
			var volume:Number = _audioSetting.volume * _audioSetting.deep * _deviceVolume;
			return volume
		}

        public function play():void
        {
			stop();
			switch(_audioInfo.sourceType)
			{
				case 0:
					_sound = new Sound(new URLRequest(_audioInfo.source));
					break;
				case 1:
					var soundCls:Class = getDefinitionByName(_audioInfo.source) as Class;
					_sound = new soundCls() as Sound;
					break;
			}
			
			if(null == _sound)
			{
				throw new Error("wrong sound:", _audioInfo.source);
			}
            
            _sound.addEventListener(IOErrorEvent.IO_ERROR, _soundIOErrorHandler);
            _soundChannel = _sound.play(0, 0, new SoundTransform(getSoundVolume()));
			if(null == _soundChannel)
			{
				return;
			}
            _soundChannel.addEventListener(Event.SOUND_COMPLETE, _soundChannel_soundCompleteHandler);
			_isPlaying = true
        }

        private function _soundChannel_soundCompleteHandler(e:Event):void
        {
			_isPlaying = false;
			if(_audioSetting.isLoop)
			{
				play();
			}
			else
			{
				stop();
			}
        }

        private function _soundIOErrorHandler(e:IOErrorEvent):void
        {
			_isPlaying = false;
			stop();
        }


        public function pause():void
        {
			stop();
        }

        public function stop():void
        {
			if(null != _sound)
			{
				_sound.removeEventListener(IOErrorEvent.IO_ERROR, _soundIOErrorHandler);
				if(_isPlaying)
				{
					try
					{
						_sound.close();
					}
					catch(e:Error)
					{
//						trace("声音:" + _sound.url + "不用关闭");
					}
				}
			}
			
			if(null != _soundChannel)
			{
				_soundChannel.removeEventListener(Event.SOUND_COMPLETE, _soundChannel_soundCompleteHandler);
				_soundChannel.stop()
			}
			_sound = null;
			_soundChannel = null;
        }

        public function dispose():void
        {
           	stop();
			_audioInfo = null;
			_audioSetting = null;
        }


    }
}
