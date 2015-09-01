
package chat;

import java.io.UnsupportedEncodingException;
import java.nio.ByteBuffer;
import java.util.Base64;

import core.net.server.interfaces.IPacket;
import core.util.SHA1;

/**
 * 协议包装器 包装后的数据为 协议头 + 协议数据
 * 
 * @author Jing
 */
public class H5Packet implements IPacket
{

	/**
	 * 协议头长度,为6
	 * <ul>
	 * <li>内容：</li>
	 * <li>int16 协议包的长度</li>
	 * <li>int16 协议号</li>
	 * </ul>
	 */
	static public final int HEAD_SIZE = 4;

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

	public H5Packet()
	{

	}

	/**
	 * 将协议封包
	 * 
	 * @param protoId 协议号
	 * @param protoData 协议数据
	 * @param clientId 客户端ID，没有则填0
	 * @return
	 */
	public byte[] pack(short protoId, byte[] protoData)
	{
		if(protoId == (short)Protocol.PROTOCOL_S2C.WS_SHAKE.ordinal())
		{
			return protoData;
		}

		_length = (short)(HEAD_SIZE + protoData.length);
		_protoId = protoId;
		_protoData = protoData;
		
		byte[] pb = null;
		byte[] bytes = this.toBytes();
		if(bytes.length < 126)
		{
			pb = new byte[bytes.length + 2];
			ByteBuffer bb = ByteBuffer.wrap(pb);
			bb.position(0);
			bb.put((byte)0x82);
			bb.put((byte)bytes.length);
			bb.put(bytes);			
		}
		else if(bytes.length < 0xFFFF)
		{
			pb = new byte[bytes.length + 4];
			ByteBuffer bb = ByteBuffer.wrap(pb);
			bb.position(0);
			bb.put((byte)0x82);
			bb.put((byte)126);
			bb.putShort((short)bytes.length);
			bb.put(bytes);					
		}
		return pb;
	}

	/**
	 * 协议解包
	 * 
	 * @param buffer
	 * @param offset
	 * @return <ul>
	 *         <li>< 0:出错</li>
	 *         <li>>=0:使用字节数</li>
	 *         </ul>
	 */
	public int unpack(byte[] buffer, int offset)
	{
		ByteBuffer buff = ByteBuffer.wrap(buffer);

		buff.position(offset);

		if(buff.remaining() < 2)
		{
			return 0;
		}
		
		byte fin = buff.get();
		if(fin == 71)
		{
			return websocketConnect(buffer);
		}

		if((fin & 0x80) != 0x80)
		{
			return 0;
		}
		
		byte rsv1 = buff.get();

		if((rsv1 & 0x80) != 0x80)
		{
			return 0;
		}

		int payload_len = rsv1 & 0x7F;
		byte[] masks = new byte[4];
		byte[] payload_data = null;
		if(payload_len == 126)
		{
			payload_len = buff.getShort();				
		}
		else if(payload_len == 127)
		{
			//这种情况，数据的长度是long类型的，我们用不上
		}
		else
		{
			
		}
		
		payload_data = new byte[payload_len];		
		buff.get(masks);						
		buff.get(payload_data);

		for(int i = 0; i < payload_len; i++)
		{
			payload_data[i] = (byte)(payload_data[i] ^ masks[i % 4]);
		}
		
		fromBytes(payload_data);
		int size = buff.position() - offset;
		return size;
	}

	private int websocketConnect(byte[] buffer)
	{
		_length = (short)buffer.length;
		String content = null;
		try
		{
			content = new String(buffer, "UTF-8");
		}
		catch(UnsupportedEncodingException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		String field = "Sec-WebSocket-Key: ";
		int start = content.indexOf(field) + field.length();
		int end = content.indexOf("\r\n", start);
		String key = content.substring(start, end);
		key += "258EAFA5-E914-47DA-95CA-C5AB0DC85B11";
		byte[] sha1 = new SHA1().getDigestOfBytes(key.getBytes());
		String str = Base64.getEncoder().encodeToString(sha1);

		StringBuffer sb = new StringBuffer();
		sb.append("HTTP/1.1 101 Switching Protocols\r\n");
		sb.append("Upgrade: websocket\r\n");
		sb.append("Connection: Upgrade\r\n");
		sb.append("Sec-WebSocket-Accept: " + str + "\r\n\r\n");
		// sb.append("Sec-WebSocket-Protocol: chat\r\n");
		str = sb.toString();
		_protoData = str.getBytes();
		_protoId = Protocol.toShort(Protocol.PROTOCOL_C2S.WS_SHAKE);
		return _length;
	}

	/**
	 * 解析协议
	 * 
	 * @param packet
	 * @return 错误码
	 */
	public int fromBytes(byte[] bytes)
	{
		ByteBuffer packet = ByteBuffer.wrap(bytes);
		_length = packet.getShort();
		_protoId = packet.getShort();
		int dataLength = _length - HEAD_SIZE;
		_protoData = new byte[dataLength];
		packet.get(_protoData);
		return _length;
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
		bb.put(_protoData);
		return bb.array();
	}
}
