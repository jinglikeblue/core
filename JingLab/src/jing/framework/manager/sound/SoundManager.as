package jing.framework.manager.sound
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import jing.framework.manager.loader.DisplayLoader;
	import jing.framework.manager.loader.LoaderManager;
	import jing.framework.manager.loader.LoaderType;
	import jing.framework.manager.module.ModuleManager;
	import jing.utils.cache.CacheLevel;
	
	import org.osmf.elements.SoundLoader;

	/**
	 * 游戏声音控制管理
	 * @author Jing
	 *
	 */
	public class SoundManager
	{
		static public function init():void
		{
		}
		
		static private var _nc:NetConnection = null;
		static private var _ns:NetStream = null;
		static private var _isStreamLoop:Boolean = false;
		
		
		

		//声音字典 		
		static private var _classDic:Object=new Object();

		//声音通道字典
		static private var _soundChanelDic:Object=new Object();

		static private var _hasEffect:Boolean=true;

		/**
		 * 是否允许音效
		 */
		static public function get hasEffect():Boolean
		{
			return _hasEffect;
		}

		/**
		 * @private
		 */
		static public function set hasEffect(value:Boolean):void
		{
			_hasEffect=value;
		}

		static private var _hasSound:Boolean=true;

		/**
		 * 是否开启声音
		 */
		static public function get hasSound():Boolean
		{
			return _hasSound;
		}

		/**
		 * @private
		 */
		static public function set hasSound(value:Boolean):void
		{
			_hasSound=value;
			if (false == _hasSound)
			{
				stopAllSound();
			}
		}


		static private var _hasMusic:Boolean=true;

		/**
		 * 是否允许背景音乐
		 */
		static public function get hasMusic():Boolean
		{
			return _hasMusic;
		}

		/**
		 * @private
		 */
		static public function set hasMusic(value:Boolean):void
		{
			_hasMusic=value;
			if (true == _hasMusic)
			{
				playMusic(_playingMusic, true);
			}
			else
			{
				stop(_playingMusic);
			}
		}


		static private var _hasControlEffect:Boolean=true;

		/**
		 * 是否允许按键音
		 */
		static public function get hasControlEffect():Boolean
		{
			return _hasControlEffect;
		}

		/**
		 * @private
		 */
		static public function set hasControlEffect(value:Boolean):void
		{
			_hasControlEffect=value;
		}

		/**
		 * 注册声音素材
		 * @param id 素材名字
		 * @param cls 素材的类
		 *
		 */
		static public function registAsset(id:String, cls:Class):void
		{
			_classDic[id]=cls;
		}

		/**
		 * 通过声音对象的类名得到一个声音对象
		 * @param soundClass
		 * @return
		 *
		 */
		static private function getSound(soundClassStr:String):Object
		{
			return ModuleManager.getClass(soundClassStr);
		}

		/**
		 * 正在播放的背景音乐
		 */
		static private var _playingMusic:String=null;

		/**
		 * 播放背景音乐
		 * @param id
		 * @isReplace 是否覆盖之前正在播放的音乐
		 */
		static public function playMusic(id:String, isReplace:Boolean=true):void
		{
			if (false == hasMusic)
			{
				return;
			}

			if (true == isReplace)
			{
				stop(_playingMusic);
				_playingMusic=id;
				play(_playingMusic, 999, _musicVolume);
			}
			else
			{
				if (null == _playingMusic)
				{
					_playingMusic=id;
					play(id, 999, _musicVolume);
				}
			}
		}
		
		/**
		 * 播放流 
		 * @param name 流名称
		 * @param loop 是否循环播放
		 * 
		 */		
		static public function playStream(name:String, loop:Boolean = false):void
		{
			if(null == _nc)
			{
				_nc = new NetConnection();
				_nc.connect(null);
			}
			
			if(null == _ns)
			{
				_ns = new NetStream(_nc);
				_ns.client = new CustomClient();
				_ns.addEventListener(NetStatusEvent.NET_STATUS, _ns_netStatusHandler);
			}
			else
			{
				stopStream();
			}			
			
			_playingMusic = name;
			_isStreamLoop = loop;
			_ns.play(name);
			_ns.soundTransform = new SoundTransform(_musicVolume);
		}
		
		static private function _ns_netStatusHandler(e:NetStatusEvent):void
		{
//			trace(e.info.code);
			switch(e.info.code)
			{
				case "NetStream.Play.Start":
					
					break;
				case "NetStream.Play.Stop":
					if(true == _isStreamLoop)
					{
						playStream(_playingMusic,true);
					}
					else
					{
						stopStream();
					}
					break;
			}
		}
		
		static public function stopStream():void
		{
			if(null != _ns)
			{
				_ns.close();
			}
		}

		/**
		 * 播放音效
		 * @param id
		 *
		 */
		static public function playEffect(id:String):void
		{
			if (false == _hasEffect)
			{
				return;
			}

			play(id, 0, _effectVolume, false);
		}

		/**
		 * 播放声音
		 * @param id 声音的ID
		 * @param loop 声音循环的次数
		 * @param volume 声音的音量
		 * @param isReplace 如果有同样的音效在播放,是否强制取消之前的
		 */
		static public function play(id:String, loop:Number=0, volume:Number=1, isReplace:Boolean=true):void
		{
			if (null != _classDic[id])
			{
				if (true == isPlaying(id) && true == isReplace)
				{
					stop(id);
				}

//				if (false == isPlaying(id))
//				{
					var sound:Sound=new _classDic[id]() as Sound;
					var sc:SoundChannel=sound.play(0, loop);
					sc.soundTransform = new SoundTransform(volume);
					sc.addEventListener(Event.SOUND_COMPLETE, sc_soundCompleteHandler);
					_soundChanelDic[id]=sc;
//				}
			}
		}

		/**
		 * 是否正在播放对应的声音
		 * @param id
		 * @return
		 *
		 */
		static public function isPlaying(id:String):Boolean
		{
			return null == _soundChanelDic[id] ? false : true;
		}

		/**
		 * 当声音通道里的声音播放完毕时执行
		 * @param e
		 *
		 */
		static private function sc_soundCompleteHandler(e:Event):void
		{
			var sc:SoundChannel=e.currentTarget as SoundChannel;
			sc.removeEventListener(Event.SOUND_COMPLETE, sc_soundCompleteHandler);
			sc.stop();
			for (var key:String in _soundChanelDic)
			{
				if (sc == _soundChanelDic[key])
				{
					_soundChanelDic[key]=null;
					return;
				}
			}
		}

		/**
		 * 停止播放声音
		 * @param id
		 *
		 */
		static public function stop(id:String):void
		{
			if (null != _soundChanelDic[id])
			{
				_soundChanelDic[id].removeEventListener(Event.SOUND_COMPLETE, sc_soundCompleteHandler);
				_soundChanelDic[id].stop();
				_soundChanelDic[id]=null;
			}
		}

		/**
		 * 停止播放所有声音
		 *
		 */
		static public function stopAllSound():void
		{
			for (var key:String in _soundChanelDic)
			{
				stop(key);
			}
			_soundChanelDic=new Object();
		}

		static private var _effectVolume:Number=0.7;

		/**
		 * 音效音量
		 */
		static public function get effectVolume():Number
		{
			return _effectVolume;
		}

		/**
		 * @private
		 */
		static public function set effectVolume(value:Number):void
		{
			_effectVolume=value;
		}



		static private var _musicVolume:Number=0.7;

		/**
		 * 背景声音音量
		 */
		static public function get musicVolume():Number
		{
			return _musicVolume;
		}

		/**
		 * @private
		 */
		static public function set musicVolume(value:Number):void
		{
			_musicVolume=value;
			changeVolume(value);
		}


		static private function changeVolume(value:Number):void
		{
			if (null != _playingMusic && null != _soundChanelDic[_playingMusic])
			{
				_soundChanelDic[_playingMusic].soundTransform=new SoundTransform(value);
			}
		}

		static private function loader_contentLoaderInfo_completeHandler(e:Event):void
		{
			trace(e);
		}

		static public function loadReturn(data:Object):void
		{
//			data;
		}
	}
}

class CustomClient 
{
	public function onMetaData(info:Object):void 
	{
		
	}
	
	public function onPlayStatus(info:Object):void
	{
		
	}
}
