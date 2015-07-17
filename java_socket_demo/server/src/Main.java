import java.io.IOException;

import chat.Protocol;
import chat.cachers.Chat;
import chat.cachers.Login;
import core.net.server.Console;
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
//		File file = new File("log");
//		Log log = null;
//		try
//		{
//			log = new Log(file.getAbsolutePath());
//		}
//		catch(IOException e)
//		{
//
//			e.printStackTrace();
//		}
//		log.log("start server...");
//		log.error("error info fuck me");
//		log.warning("error info fuck me");
		
		Console.log.log("start server...");
		
		Server server = Server.instance();
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
		Console.log.log("end server...");
	}
}
