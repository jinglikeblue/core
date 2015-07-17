package jing.net
{
	import jing.net.server.ByteBuffer;

    /**
     * 协议包装器 包装后的数据为 协议头 + 协议数据
     *
     * @author Jing
     */
    public class Packet
    {

        /**
         * 协议头长度,为6
         * <ul>
         * <li>内容：</li>
         * <li>int16 协议包的长度</li>
         * <li>int16 协议号</li>
         * <li>int16 校验码(简单的安全验证)</li>
         * </ul>
         */
        static public const HEAD_SIZE:int = 6;

        private var _length:int = 0;

        /**
         * 协议包的长度
         *
         * @return
         */
        public function get length():int
        {
            return _length;
        }

        private var _protoId:int = 0;

        /**
         * 协议包的ID
         *
         * @return
         */
        public function get protoId():int
        {
            return _protoId;
        }

        private var _sign:int = 0;

        /**
         * 协议包的校验码
         *
         * @return
         */
        public function get sign():int
        {
            return _sign;
        }

        private var _protoData:ByteBuffer = null;

        /**
         * 协议包的数据内容
         *
         * @return
         */
        public function get protoData():ByteBuffer
        {
            return _protoData;
        }

        public function Packet()
        {
        }	
		
		/**
		 * 通过协议号和协议数据初始化 
		 * @param protoId
		 * @param protoData
		 * 
		 */		
		public function init(protoId:int, protoData:ByteBuffer):void
		{
			_length = HEAD_SIZE + protoData.length;
			_sign = createSign(protoId, _length);
			_protoId = protoId;
			_protoData = protoData;
		}

		/**
		 * 通过数据包初始化 
		 * @param packet
		 * 
		 */		
        public function initWithBytes(packet:ByteBuffer):void
		{
			packet.position = 0;
			_length = packet.readShort();
			_protoId = packet.readShort();
			_sign = packet.readShort();
			
			if (_sign != createSign(_protoId, _length) || packet.length < _length)
			{
				// 协议有错误，应该断线
				throw new Error("A packet have a wrong! protoId: " + _protoId);
			}
			var dataLength:int = _length - HEAD_SIZE;
			_protoData = new ByteBuffer();
			packet.readBytes(_protoData);
		}



        /**
         * 将协议包的数据转换为字节数组
         *
         * @return
         */
        public function toBytes():ByteBuffer
        {
            var ba:ByteBuffer = new ByteBuffer();
            ba.writeShort(_length);
            ba.writeShort(_protoId);
            ba.writeShort(_sign);
            ba.writeBytes(_protoData);
            return ba;
        }

        /**
         * 将协议封包
         *
         * @param protoId 协议号
         * @param protoData 协议数据
         * @param clientId 客户端ID，没有则填0
         * @return
         */
        static public function pack(protoId:int, protoData:ByteBuffer):ByteBuffer
        {
            var packet:Packet = new Packet();
			packet.init(protoId, protoData);
            return packet.toBytes();
        }

        /**
         * 尝试从buffer中获取协议包
         *
         * @param packet
         * @return
         */
        static public function unpack(buffer:ByteBuffer):Packet
        {
			buffer.position = 0;
            // 检查协议头是否满足
            if (buffer.length < HEAD_SIZE)
            {
                return null;
            }

            // 检查协议长度是否满足
            var length:int = buffer.readShort();

            if (buffer.length < length)
            {
                return null;
            }

            // 抽取协议返回
            var packetData:ByteBuffer = new ByteBuffer();
            packetData.writeBytes(buffer, 0, length);
            var p:Packet = new Packet();
			p.initWithBytes(packetData);
            return p;
        }

        /**
         * 创建协议校验码
         *
         * @param protoId 协议ID
         * @param clientId 客户端ID
         * @return
         */
        static private function createSign(protoId:int, protoLength:int):int
        {
            var sign:int = (protoId << 8 | protoLength);
            return sign;
        }
    }
}