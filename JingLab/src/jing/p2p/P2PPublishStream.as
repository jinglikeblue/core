package jing.p2p
{
	import flash.events.NetStatusEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import jing.p2p.events.StreamEvent;

	/**
	 * P2P发布流 
	 * @author jing
	 * 
	 */	
	[Event(name="PublishStart", type="com.jing.p2p.events.StreamEvent")]
	[Event(name="OnPeerConnect", type="com.jing.p2p.events.StreamEvent")]
	public class P2PPublishStream extends P2PStream
	{		
		private var _allowPeerIds:Array;	
		
		/**
		 * 得到允许接收该流的P2P连接ID数组
		 * @return 
		 * 
		 */		
		public function getAllowPeerIds():Array
		{
			return _allowPeerIds;
		}
		
		/**
		 * 设置允许接收该流的P2P连接ID数组
		 * @param ids
		 * 
		 */		
		public function setAllowPeerIds(ids:Array = null):void
		{
			_allowPeerIds = ids;
		}
		
		/**
		 * 创建一个P2P发布流 
		 * @param netConnection 已创建的P2P连接
		 * 
		 */		
		public function P2PPublishStream(netConnection:NetConnection)
		{
			super(netConnection);
		}
		
		/**
		 * 发送一条消息到订阅者
		 * @param funName 消息名字
		 * @param paramaters 消息内容
		 * 
		 */		
		public function sendHandle(handleName:String, ...paramaters):void
		{
			_stream.send(handleName,paramaters);
		}
		
		/**
		 * 发布一个流 
		 * @param name 流的名字
		 * @return 
		 * 
		 */		
		public function publicStream(name:String = null):int
		{
			if(null != _stream)
			{
				return 0;
			}
			
			if(null == name)
			{
				name = _netConnection.nearID;
			}
			
			_stream = new NetStream(_netConnection, NetStream.DIRECT_CONNECTIONS);
			_stream.addEventListener(NetStatusEvent.NET_STATUS, _stream_netStatusHandler);
			_stream.publish(name);	
			
			var funObject:Object = new Object();
			funObject.onPeerConnect = onPeerConnect;			
			_stream.client = funObject;			

			return 1;
		}
		
		public function close():void
		{
			_stream.removeEventListener(NetStatusEvent.NET_STATUS, _stream_netStatusHandler);
			_stream.close();
			_stream = null;
		}
		
		private function _stream_netStatusHandler(e:NetStatusEvent):void
		{
			switch(e.info.code)
			{
				case STREAM_PUBLISH_START:
					this.dispatchEvent(new StreamEvent(StreamEvent.PUBLISH_START));
					break;
			}
			trace("发布流状态：", e.info.code);
		}
		
		private function onPeerConnect(playerStream:NetStream):Boolean
		{
			if(null != _allowPeerIds && -1 == _allowPeerIds.indexOf(playerStream.farID))
			{
				return false;
			}
			this.dispatchEvent(new StreamEvent(StreamEvent.ON_PEER_CONNECT,playerStream.farID));
			return true;
		}
		
		/**
		 * 捕获摄像头 
		 * @param camera
		 * 
		 */		
		public function attachCamera(camera:Camera = null):void
		{
			if(null == _stream)
			{
				return;
			}
			
			if(null == camera)
			{
				camera = Camera.getCamera();
			}
			
			_stream.attachCamera(camera);			
		}
		
		/**
		 * 捕获麦克风 
		 * @param mic
		 * 
		 */		
		public function attachAudio(mic:Microphone = null):void
		{
			if(null == _stream)
			{
				return;
			}
			
			if(null == mic)
			{
				mic = Microphone.getMicrophone();
			}
			
			_stream.attachAudio(mic);
		}
	}
}