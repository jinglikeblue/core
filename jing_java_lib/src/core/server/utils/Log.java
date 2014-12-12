
package core.server.utils;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import core.io.FileUtil;

/**
 * 日志工具
 * 
 * @author Jing
 */
public class Log
{

	private String _path;

	/**
	 * @param path 日志存放路径
	 * @throws IOException 
	 */
	public Log(String path) throws IOException
	{
		_path = path;
		File file = new File(_path);
		File dir = file.getParentFile();
		if(false == dir.exists())
		{
			//所在目录不存在则创建
			dir.mkdirs();
		}
		file.createNewFile();
		System.out.print(_path);
	}

	/**
	 * 记录日志内容
	 * 
	 * @param content
	 * @throws IOException
	 */
	public void log(String content)
	{
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String time = dateFormat.format(new Date());
		content = String.format("%s    %s\r\n", time, content);
		
		//打印到调试控制台
		System.out.print(content);
		try
		{
			//写到本地文件
			FileUtil.appendFile(content, _path);
		}
		catch(IOException e)
		{
			e.printStackTrace();
		}
	}
}
