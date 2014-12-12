package core.server.utils;

import java.io.IOException;

import core.io.FileUtil;


/**
 * 日志工具
 * @author Jing
 *
 */
public class Log
{

	private String _path;
	
	/**
	 * 
	 * @param path 日志存放路径
	 */
	public Log(String path)
	{
		_path = path;
	}
	
	/**
	 * 记录日志内容
	 * @param content
	 * @throws IOException 
	 */
	public void log(String content)
	{
		System.out.print(content);
		try
		{
			FileUtil.appendFile(content, _path);
		}
		catch(IOException e)
		{			
			e.printStackTrace();
		}
	}
}
