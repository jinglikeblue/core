
package core.net.server;

import java.io.IOException;
import java.net.InetAddress;
import java.nio.ByteBuffer;
import java.nio.channels.SocketChannel;

import core.net.Packet;
import core.net.server.interfaces.IProtocolCacher;


/**
 * 连接到服务器的客户端
 * 
 * @author Jing
 */
public class Client
{
	/**
	 * 客户端的连接通道
	 */
	private SocketChannel _channel = null;

	/**
	 * 连接客户端的通道
	 */
	public SocketChannel channel()
	{
		return _channel;
	}

	public Client(SocketChannel channel)
	{
		_channel = channel;
	}

	/**
	 * 接收到数据
	 * 
	 * @param buff 数据内容
	 * @return 使用了的数据长度
	 */
	public void onAcceptProtocol(Packet packet) throws IOException
	{
		// 获取协议号码
		short code = packet.getProtoId();

		IProtocolCacher cacher = Server.instance().getProtocolCacher(code);
		if(null == cacher)
		{
			System.out.println(String.format("protocol code [%d] no cacher", code));
			return;
		}
		cacher.onCacheProtocol(this, packet);
	}

	/**
	 * 向对应的客户端发送数据
	 * 
	 * @param id 协议编号
	 * @param data 协议的数据
	 */
	public void sendProtocol(short id, byte[] data)
	{
		byte[] packet = Packet.pack(id, data);
		ByteBuffer bb = ByteBuffer.wrap(packet);
		try
		{			
			_channel.write(bb);
		}
		catch(IOException e)
		{
			e.printStackTrace();
		}
	}
	
	/**
	 * 向对应的客户端发送数据
	 * 
	 * @param id 协议编号
	 * @param data 协议的数据
	 */
	public void sendProtocol(short id, ByteBuffer data)
	{
		byte[] ba = new byte[data.limit()];
		data.position(0);
		data.get(ba);
		sendProtocol(id, ba);
	}

	/**
	 * 销毁客户端
	 */
	public void dispose()
	{
		InetAddress address = _channel.socket().getLocalAddress();

		try
		{
			_channel.close();
		}
		catch(IOException e)
		{
			e.printStackTrace();
		}
		System.out.println("client " + address.toString() + " disposed");
	}

}
