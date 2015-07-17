
package core.net;

import java.nio.ByteBuffer;

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
	static public final int HEAD_SIZE = 6;

	private short _length = 0;

	/**
	 * 协议包的长度
	 * 
	 * @return
	 */
	public short getLength()
	{
		return _length;
	}

	private short _protoId = 0;

	/**
	 * 协议包的ID
	 * 
	 * @return
	 */
	public short getProtoId()
	{
		return _protoId;
	}

	private short _sign = 0;

	/**
	 * 协议包的校验码
	 * 
	 * @return
	 */
	public short getSign()
	{
		return _sign;
	}

	private byte[] _protoData = null;

	/**
	 * 协议包的数据内容
	 * 
	 * @return
	 */
	public byte[] getProtoData()
	{
		return _protoData;
	}

	public Packet(short protoId, byte[] protoData)
	{
		init(protoId, protoData);
	}

	private void init(short protoId, byte[] protoData)
	{
		_length = (short)(HEAD_SIZE + protoData.length);
		_sign = createSign(protoId, _length);
		_protoId = protoId;
		_protoData = protoData;
	}

	public Packet(byte[] packet)
	{
		ByteBuffer bb = ByteBuffer.wrap(packet);
		_length = bb.getShort();
		_protoId = bb.getShort();
		_sign = bb.getShort();

		if(_sign != createSign(_protoId, _length) || packet.length < _length)
		{
			// 协议有错误，应该断线
			System.out.println("A packet have a wrong! protoId: " + _protoId);
		}
		int dataLength = _length - HEAD_SIZE;
		_protoData = new byte[dataLength];
		bb.get(_protoData);
	}

	/**
	 * 将协议包的数据转换为字节数组
	 * 
	 * @return
	 */
	public byte[] toBytes()
	{
		byte[] ba = new byte[_length];
		ByteBuffer bb = ByteBuffer.wrap(ba);
		bb.position(0);
		bb.putShort(_length);
		bb.putShort(_protoId);
		bb.putShort(_sign);
		bb.put(_protoData);
		return bb.array();
	}

	/**
	 * 将协议封包
	 * 
	 * @param protoId 协议号
	 * @param protoData 协议数据
	 * @param clientId 客户端ID，没有则填0
	 * @return
	 */
	static public byte[] pack(short protoId, byte[] protoData)
	{
		Packet packet = new Packet(protoId, protoData);

		return packet.toBytes();
	}

	/**
	 * 尝试从buffer中获取协议包
	 * 
	 * @param packet
	 * @return
	 */
	static public Packet unpack(byte[] buffer)
	{
		// 检查协议头是否满足
		if(buffer.length < HEAD_SIZE)
		{
			return null;
		}

		// 检查协议长度是否满足
		ByteBuffer bb = ByteBuffer.wrap(buffer);
		short length = bb.getShort();

		if(buffer.length < length)
		{
			return null;
		}

		// 抽取协议返回
		byte[] packetData = new byte[length];
		System.arraycopy(buffer, 0, packetData, 0, length);
		Packet p = new Packet(packetData);
		return p;
	}

	/**
	 * 创建协议校验码
	 * 
	 * @param protoId 协议ID
	 * @param clientId 客户端ID
	 * @return
	 */
	static private short createSign(short protoId, short protoLength)
	{
		short sign = (short)(protoId << 8 | protoLength);
		return sign;
	}
}
