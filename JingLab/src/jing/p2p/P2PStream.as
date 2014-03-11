package jing.p2p
{
	import flash.events.EventDispatcher;
	import flash.net.NetConnection;
	import flash.net.NetStream;


	/**
	 * P2P流的基类 
	 * @author jing
	 * 
	 */	
	public class P2PStream extends EventDispatcher
	{
		protected var _netConnection:NetConnection;
		
		protected var _stream:NetStream;
		
		public function get stream():NetStream
		{
			return _stream;
		}
		
		public function P2PStream(netConnection:NetConnection)
		{
			_netConnection = netConnection;
		}
		
		/**
		 * 出于此表中列出的原因之外的某一原因（例如订阅者没有读取权限），播放发生了错误
		 */		
		protected const STREAM_PLAY_FAILED:String = "NetStream.Play.Failed";
		
		/**
		 * 播放已开始
		 */	
		protected const STREAM_PLAY_START:String = "NetStream.Play.Start";
		
		/**
		 * 从流取消的发布被发送到所有的订阅者 
		 */		
		protected const STREAM_UNPUBLISH_NOTIFY:String = "NetStream.Play.UnpublishNotify";
		
		/**
		 * 发布流启动 
		 */		
		protected const STREAM_PUBLISH_START:String = "NetStream.Publish.Start";
	}
}