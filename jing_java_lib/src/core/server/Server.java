
package core.server;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.nio.channels.ServerSocketChannel;
import java.nio.channels.SocketChannel;
import java.util.HashMap;
import java.util.Iterator;

import core.events.EventDispatcher;
import core.server.interfaces.IProtocolCacher;

/**
 * 服务类 单例模式
 * 
 * @author Jing
 */
public class Server extends EventDispatcher
{

	private Server()
	{

	}

	static private Server _instance = null;

	/**
	 * 获取单例
	 * 
	 * @return
	 */
	static public Server instance()
	{
		if(null == _instance)
		{
			_instance = new Server();
		}
		return _instance;
	}

	/**
	 * 服务器事件
	 * 
	 * @author Jing
	 */
	static public enum EVENT
	{
		/**
		 * 客户端已连接
		 */
		CLIENT_CONNECTED,

		/**
		 * 客户端断开连接
		 */
		CLIENT_DISCONNECT
	}

	// 协议捕获器字典
	private HashMap<Short, IProtocolCacher> _protocolCacherMap = new HashMap<Short, IProtocolCacher>();

	// 连接上的客户端
	private HashMap<SocketChannel, Client> _onlineMap = new HashMap<SocketChannel, Client>();

	private int _port;

	/**
	 * 监听的端口号
	 * 
	 * @return
	 */
	public int port()
	{
		return _port;
	}

	private int _buffSize;

	/**
	 * 缓冲区大小
	 * 
	 * @return
	 */
	public int buffSize()
	{
		return _buffSize;
	}

	private int _fps;

	/**
	 * 服务器帧率
	 * 
	 * @return
	 */
	public int fps()
	{
		return _fps;
	}

	/**
	 * 服务器停止标记
	 */
	private int _stopMark = 0;

	/**
	 * 停止服务器
	 */
	public void stop()
	{
		_stopMark = 1;
	}

	/**
	 * 启动服务器
	 * 
	 * @param port 监听的端口
	 * @param buffSize 缓冲区大小
	 * @param fps 服务器刷新的帧率
	 * @throws IOException
	 */
	public void run(int port, int buffSize, int fps) throws IOException
	{
		_port = port;
		_buffSize = buffSize;
		_fps = fps;

		long timeout = 1000 / fps;

		Selector selector = Selector.open();

		ServerSocketChannel listenerChannel = ServerSocketChannel.open();

		listenerChannel.socket().bind(new InetSocketAddress(port));

		listenerChannel.configureBlocking(false);

		listenerChannel.register(selector, SelectionKey.OP_ACCEPT);

		System.out.println("\nserver start. listening port " + port);

		while(true)
		{
			if(selector.select(timeout) > 0)
			{
				Iterator<SelectionKey> keyIter = selector.selectedKeys().iterator();

				while(keyIter.hasNext())
				{
					SelectionKey key = keyIter.next();

					try
					{
						if(key.isAcceptable())
						{
							// 接收到连接
							handleAccept(key);
						}

						if(key.isReadable())
						{
							// 接收到数据
							handleRead(key);
						}

						if(key.isValid() && key.isWritable())
						{
							handleWrite(key);
						}
					}
					catch(IOException ex)
					{
						keyIter.remove();
						continue;
					}

					keyIter.remove();
				}
			}

			enterFrame();

			if(1 == _stopMark)
			{
				System.out.println("server stopped");
				break;
			}
		}
	}

	protected void enterFrame()
	{
		//need override
	}

	/**
	 * 获取协议捕捉器
	 * 
	 * @param protocolCode
	 * @return
	 */
	public IProtocolCacher getProtocolCacher(short protocolCode)
	{
		return _protocolCacherMap.get(protocolCode);
	}

	/**
	 * 注册协议的捕获器
	 * 
	 * @param protocolCode
	 * @param cacher
	 */
	public void registProtocolCacher(short protocolCode, IProtocolCacher cacher)
	{
		_protocolCacherMap.put(protocolCode, cacher);
	}

	// ---------------------协议处理相关代码--------------------------------

	private void handleAccept(SelectionKey key) throws IOException
	{
		// 获取客户端的SocketChannel
		SocketChannel clientChannel = ((ServerSocketChannel)key.channel()).accept();
		// 设置为非阻塞模式
		clientChannel.configureBlocking(false);
		// 向给定的选择器注册此通道，返回一个选择键
		clientChannel.register(key.selector(), SelectionKey.OP_READ, ByteBuffer.allocate(_buffSize));

		Client client = new Client(clientChannel);
		if(_onlineMap.get(clientChannel) != null)
		{
			throw new IOException("can't accept same key twice");
		}
		_onlineMap.put(clientChannel, client);

		this.dispatchEvent(EVENT.CLIENT_CONNECTED.name(), client);
	}

	private void handleRead(SelectionKey key) throws IOException
	{
		SocketChannel clientChannel = (SocketChannel)key.channel();

		Client client = _onlineMap.get(clientChannel);

		ByteBuffer buff = (ByteBuffer)key.attachment();

		int bytesRead = clientChannel.read(buff);

		if(bytesRead == -1)
		{
			// 广播一个客户端断开连接的消息
			this.dispatchEvent(EVENT.CLIENT_DISCONNECT.name(), client);
			client.dispose();
			if(null == _onlineMap.remove(clientChannel))
			{
				throw new IOException("wrong client disconnect");
			}
		}
		else
		{
			buff.flip();
			int limit = buff.limit();
			// 进行协议的拆包处理
			int used = parse(buff, client);
			int remain = limit - used;
			if(0 == remain)
			{
				buff.clear();
			}
			else
			{
				buff.position(used);
				byte tempb[] = new byte[remain];
				buff.get(tempb);
				buff.clear();
				buff.put(tempb);
			}
		}
	}

	public void handleWrite(SelectionKey key) throws IOException
	{
		//这个用不上
	}

	/**
	 * 协议拆包
	 * 
	 * @param buff
	 * @param client
	 * @return 返回时用到的长度
	 */
	private int parse(ByteBuffer buff, Client client) throws IOException
	{
		int used = 0;
		int limit = buff.limit();
		while(true)
		{
			// 判断是否能够读取协议的长度
			if(buff.limit() - used < 2)
			{
				break;
			}

			buff.position(used);
			// 读取协议长度
			short protocolLength = buff.getShort();
			// 数据内容不够一个协议的长度
			if(buff.limit() - used < protocolLength)
			{
				break;
			}

			buff.position(used);
			buff.limit(used + protocolLength);
			ByteBuffer protocolBuf = buff.slice();
			buff.limit(limit);
			// 调用客户端的协议处理方法
			client.onAcceptProtocol(protocolBuf);
			used += protocolLength;
		}

		return used;
	}
}
