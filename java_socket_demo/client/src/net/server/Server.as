package net.server
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;

	/**
	 * 服务器
	 * 连接服务器的工具 
	 * @author Jing
	 * 
	 */	
	[Event(name="connect_success", type="net.server.ServerEvent")]
	[Event(name="connect_fail", type="net.server.ServerEvent")]
	[Event(name="closed", type="net.server.ServerEvent")]
	[Event(name="accpet_protocol", type="net.server.ServerEvent")]
	public class Server extends EventDispatcher
	{
		private var _buff:ByteArray;
		private var _socket:Socket;
		private var _ip:String;
		private var _port:int;
		
		public function Server()
		{
		}
		
		/**
		 * 连接服务器 
		 * @param ip
		 * @param port
		 * 
		 */		
		public function connect(ip:String, port:int):void
		{
			close();
			_ip = ip;
			_port = port;
			_socket = new Socket();
			addListeners();
			_socket.connect(ip,port);
		}
		
		/**
		 * 关闭连接 
		 * 
		 */		
		public function close():void
		{
			if(_socket)
			{
				if(true == _socket.connected)
				{
					_socket.close();
				}
				removeListeners();
				_socket = null;
			}
		}
		
		/**
		 * 发送协议 
		 * @param protocolCode 协议号
		 * @param ba 协议数据
		 * 
		 */		
		public function sendProtocol(protocolCode:int, ba:ByteArray):void
		{
			var length:int = ba.length + 4;
			trace("发送包长度：", length);
			_socket.writeShort(length);
			_socket.writeShort(protocolCode);
			_socket.writeBytes(ba);
			_socket.flush();
		}
		
		protected function addListeners():void
		{
			_socket.addEventListener(IOErrorEvent.IO_ERROR, _socket_ioErrorHandler);
			_socket.addEventListener(Event.CLOSE, _socket_closeHandler);
			_socket.addEventListener(Event.CONNECT, _socket_connectHandler);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, _socket_socketDataHandler);
		}
		
		protected function removeListeners():void
		{
			_socket.removeEventListener(IOErrorEvent.IO_ERROR, _socket_ioErrorHandler);
			_socket.removeEventListener(Event.CLOSE, _socket_closeHandler);
			_socket.removeEventListener(Event.CONNECT, _socket_connectHandler);
			_socket.removeEventListener(ProgressEvent.SOCKET_DATA, _socket_socketDataHandler);			
		}
		
		protected function _socket_connectHandler(event:Event):void
		{						
			this.dispatchEvent(new ServerEvent(ServerEvent.CONNECT_SUCCESS));
			//trace(event.type);
		}
		
		protected function _socket_socketDataHandler(event:ProgressEvent):void
		{
			if(null == _buff)
			{
				_buff = new ByteArray();
			}
			_socket.readBytes(_buff,_buff.length,_socket.bytesAvailable);
			parse();
		}
		
		protected function _socket_closeHandler(event:Event):void
		{
			//trace(event.type);
			this.dispatchEvent(new ServerEvent(ServerEvent.CLOSED));
		}
		
		protected function _socket_ioErrorHandler(event:IOErrorEvent):void
		{
			//trace(event.type);
			this.dispatchEvent(new ServerEvent(ServerEvent.CONNECT_FAIL));
		}
		
		/**
		 * 包解析 
		 * 
		 */		
		private function parse():void
		{
			_buff.position = 0;
			var used:int = 0;
			
			//进行解包
			while(true)
			{
				// 判断是否能够读取协议的长度
				if(_buff.length - used < 2)
				{
					break;
				}
				
				// 读取协议长度
				var protocolLength:int = _buff.readUnsignedShort();
				// 数据内容不够一个协议的长度
				if(_buff.length- used < protocolLength)
				{
					break;
				}
				
				var pkg:ByteArray = new ByteArray();
				_buff.position = used;
				_buff.readBytes(pkg,0,protocolLength);
				pkg.position = 2;
				this.dispatchEvent(new ServerEvent(ServerEvent.ACCEPT_PROTOCOL, pkg));
				
				used += protocolLength;
			}
			
			//保留未处理的包
			if(used == _buff.length)
			{
				_buff.clear();
			}
			else
			{
				_buff.position = used;
				var newBuff:ByteArray = new ByteArray();
				_buff.readBytes(newBuff,0, _buff.bytesAvailable);
				_buff.clear();
				_buff = newBuff;
			}
		}
		
	}
}