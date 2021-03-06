package jing.net.server
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.net.Socket;
    import flash.utils.Dictionary;

    import jing.net.Packet;

    /**
     * 服务器
     * 连接服务器的工具
     * @author Jing
     *
     */
    [Event(name = "connect_success", type = "net.server.ServerEvent")]
    [Event(name = "connect_fail", type = "net.server.ServerEvent")]
    [Event(name = "closed", type = "net.server.ServerEvent")]
    [Event(name = "accpet_protocol", type = "net.server.ServerEvent")]
    public class Server extends EventDispatcher
    {
        private var _buff:ByteBuffer;

        private var _socket:Socket;

        private var _ip:String;

        private var _port:int;

        private var _protoHandles:Dictionary = new Dictionary();

        public function Server()
        {
        }

        /**
         * 注册协议处理器
         * @param protocolId 协议ID
         * @param handler 处理器
         *
         */
        public function registProtocolHandle(protocolId:int, handler:IProtocolHandles):void
        {
            _protoHandles[protocolId] = handler;
        }

        /**
         * 是否连接着服务器
         */
        public function get isConnected():Boolean
        {
            if (_socket)
            {
                return _socket.connected;
            }
            return false;
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
            _socket.connect(ip, port);
        }

        /**
         * 关闭连接
         *
         */
        public function close():void
        {
            if (_socket)
            {
                if (true == _socket.connected)
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
        public function sendProtocol(protocolCode:int, buff:ByteBuffer):void
        {
            if (false == isConnected)
            {
                return;
            }

            var packet:Packet = new Packet();
            packet.init(protocolCode, buff);
            trace("发送包大小：", packet.length);
            _socket.writeBytes(packet.toBytes());
            var length:int = buff.length + 4;
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
            if (null == _buff)
            {
                _buff = new ByteBuffer();
            }
            _socket.readBytes(_buff, 0, _socket.bytesAvailable);
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
            //进行解包
            while (true)
            {
                _buff.position = 0;
                var packet:Packet = Packet.unpack(_buff);

                if (null == packet)
                {
                    break;
                }

                //处理这个协议
                onAcceptProtocol(packet);
                this.dispatchEvent(new ServerEvent(ServerEvent.ACCEPT_PROTOCOL, {packet: packet}));

                //处理黏包
                var buff:ByteBuffer = new ByteBuffer();
                buff.writeBytes(_buff, packet.length, _buff.length - packet.length);
                _buff = buff;
            }
        }

        /**
         * 接收到协议的处理，改方法需要重写实现
         */
        protected function onAcceptProtocol(packet:Packet):void
        {
            var handle:IProtocolHandles = _protoHandles[packet.protoId];

            if (null != handle)
            {
                handle.handle(packet);
            }
            else
            {
                trace("协议:[" + packet.protoId + "]没有对应的处理!");
            }
        }

    }
}
