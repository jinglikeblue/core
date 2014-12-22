import java.io.File;
import java.io.IOException;

import chat.Chat;
import chat.Protocol;
import chat.cachers.Login;
import core.server.Server;
import core.server.utils.Log;

public class Main
{	
	/**
	 * HelloWorld
	 * 
	 * @param args
	 */
	public static void main(String[] args)
	{				
		File file = new File("log/a/a/a/a/log.txt");
		Log log = null;
		try
		{
			log = new Log(file.getAbsolutePath());
		}
		catch(IOException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		log.log("start server...");

		
		//Server.instance().log("start server...");
//		Server server = Server.instance();
//		server.registProtocolCacher((short)Protocol.PROTOCOL_C2S.LOGIN.ordinal(), new Login());
//		server.registProtocolCacher((short)Protocol.PROTOCOL_C2S.CHAT.ordinal(), new Chat());
//		
//		try
//		{
//			server.run(9527, 100000, 40);
//		}
//		catch(IOException e)
//		{
//			e.printStackTrace();
//		}
		log.log("end server...");
	}
}
