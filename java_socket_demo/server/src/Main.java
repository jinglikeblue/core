import java.io.IOException;

import chat.H5Packet;
import chat.Protocol;
import chat.cachers.Chat;
import chat.cachers.Login;
import chat.cachers.WS;
import core.net.server.Server;

public class Main
{

	/**
	 * HelloWorld
	 * 
	 * @param args
	 */
	public static void main(String[] args)
	{
		Server server = Server.instance();
		Server.packetClass = H5Packet.class;
		server.registProtocolCacher((short)Protocol.PROTOCOL_C2S.WS_SHAKE.ordinal(), new WS());
		server.registProtocolCacher((short)Protocol.PROTOCOL_C2S.LOGIN.ordinal(), new Login());
		server.registProtocolCacher((short)Protocol.PROTOCOL_C2S.CHAT.ordinal(), new Chat());

		try
		{
			server.run(9527, 4096, 30);
		}
		catch(IOException e)
		{
			e.printStackTrace();
		}
	}
}
