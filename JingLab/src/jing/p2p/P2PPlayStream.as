package jing.p2p
{	
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import jing.p2p.events.StreamEvent;

	/**
	 * P2P订阅流 
	 * @author jing
	 * 
	 */	
	[Event(name="PlayStart", type="com.jing.p2p.events.StreamEvent")]
	[Event(name="PlayFailed", type="com.jing.p2p.events.StreamEvent")]
	[Event(name="PlayUnpublishNotify", type="com.jing.p2p.events.StreamEvent")]
	public class P2PPlayStream extends P2PStream
	{		
		private var _funObject:Object;
		
		/**
		 * 创建一个P2P订阅流 
		 * @param netConnection
		 * 
		 */		
		public function P2PPlayStream(netConnection:NetConnection)
		{
			super(netConnection);
		}
		
		public function registFun(funName:String, fun:Function):void
		{
			_funObject[funName] = fun;
		}
		
		/**
		 * 订阅一个P2P流 
		 * @param peerId 订阅P2P流的ID
		 * @param name 订阅该ID发布的流的名字
		 * @return 
		 * 
		 */		
		public function playStream(peerId:String, name:String = null):int
		{
			if(null != _stream)
			{
				return 0;
			}
		
			if(null == name)
			{
				name = peerId;
			}
			
			_stream = new NetStream(_netConnection, peerId);
			_stream.addEventListener(NetStatusEvent.NET_STATUS, _stream_netStatusHandler);
			_stream.play(name);
			
			if(null == _funObject)
			{
				_funObject = new Object();
			}
			_stream.client = _funObject;
			
			return 1;
		}
		
		private function _stream_netStatusHandler(e:NetStatusEvent):void
		{
			trace("播放流状态：", e.info.code);
			switch(e.info.code)
			{
				case STREAM_PLAY_FAILED:
					this.dispatchEvent(new StreamEvent(StreamEvent.PLAY_FAILED));
					break;
				case STREAM_PLAY_START:
					this.dispatchEvent(new StreamEvent(StreamEvent.PLAY_START));
					break;
				case STREAM_UNPUBLISH_NOTIFY:
					this.dispatchEvent(new StreamEvent(StreamEvent.PLAY_UNPUBLISH_NOTIFY));
					break;
			}	
			
		}
		
		public function close():void
		{
			_stream.removeEventListener(NetStatusEvent.NET_STATUS, _stream_netStatusHandler);
			_stream.close();
			_funObject = null;
			_stream = null;
		}
		
		/**
		 * 接收视频
		 * @param b
		 * 
		 */		
		public function receiveVideo(b:Boolean = true):void
		{
			if(null == _stream)
			{
				return;
			}
			
			_stream.receiveVideo(b);
		}
		
		/**
		 * 接收音频 
		 * @param b
		 * 
		 */		
		public function receiveAudio(b:Boolean = true):void
		{
			if(null == _stream)
			{
				return;
			}
			_stream.receiveAudio(b);
		}
		

	}
}