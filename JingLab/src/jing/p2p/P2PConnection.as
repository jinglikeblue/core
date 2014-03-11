package jing.p2p
{
    import flash.events.EventDispatcher;
    import flash.events.NetStatusEvent;
    import flash.net.NetConnection;
    
    import jing.p2p.events.ConnectionEvent;

	[Event(name="StatusConnectSuccess", type="com.jing.p2p.events.ConnectionEvent")]
	[Event(name="StatusConnectFailed", type="com.jing.p2p.events.ConnectionEvent")]
	[Event(name="StatusConnectClosed", type="com.jing.p2p.events.ConnectionEvent")]
    public class P2PConnection extends EventDispatcher
    {
        //链接Adobe stratus 服务器
        static public const ADOBE_STRATUS_ADDRESS:String = "rtmfp://stratus.adobe.com";

        private var _connection:NetConnection;

        public function get connection():NetConnection
        {
            return _connection;
        }

        private var _peerId:String;

        public function get peerId():String
        {
            return _peerId;
        }

        public function P2PConnection()
        {

        }

        /**
         * 连接P2P服务器，
         * @param developerKey
         * @return 0连接已存在  1开始连接
         *
         */
        public function connect(developerKey:String):int
        {
            if (null != _connection)
            {
                return 0;
            }

            _connection = new NetConnection();
            _connection.addEventListener(NetStatusEvent.NET_STATUS, _netConnection_netStatusHandler);
            _connection.connect(ADOBE_STRATUS_ADDRESS + "/" + developerKey);
            return 1;
        }

        private function _netConnection_netStatusHandler(e:NetStatusEvent):void
        {
            switch (e.info.code)
            {
                case NET_CONNECT_SUCCESS:
                    _peerId = _connection.nearID;
                    //					trace("P2P服务器链接成功", _peerId);
                    this.dispatchEvent(new ConnectionEvent(ConnectionEvent.STATUS_CONNECT_SUCCESS));
                    break;
                case NET_CONNECT_FAILED:
                    //					trace("P2P服务器链接失败");
                    this.dispatchEvent(new ConnectionEvent(ConnectionEvent.STATUS_CONNECT_FAILED));
                    break;
                case NET_CONNECT_CLOSED:
                    //					trace("P2P服务器链接关闭");
                    this.dispatchEvent(new ConnectionEvent(ConnectionEvent.STATUS_CONNECT_CLOSED));
                    break;
            }
        }

        public function close():void
        {
            _connection.removeEventListener(NetStatusEvent.NET_STATUS, _netConnection_netStatusHandler);
            _connection.close();
            _connection = null;
            this.dispatchEvent(new ConnectionEvent(ConnectionEvent.STATUS_CONNECT_CLOSED));
        }

        private const NET_CONNECT_SUCCESS:String = "NetConnection.Connect.Success";

        private const NET_CONNECT_CLOSED:String = "NetConnection.Connect.Closed";

        private const NET_CONNECT_FAILED:String = "NetConnection.Connect.Failed";

    }
}
