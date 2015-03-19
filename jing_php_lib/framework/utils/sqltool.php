<?php
class SqlHelper
{
	public $conn = null;
	
	//连接数据库
	public function conn()
	{
		$this->conn = mysql_connect(DB_URL,'root',DB_PWD);
		mysql_select_db(DB_NAME, $this->conn);
	}
	
	//查询数据库
	public function query($sql)
	{
		mysql_ping($this->conn);
		$result = mysql_query($sql, $this->conn);
		return $this->transformSqlResult2Array($result);
	}
	
	//关闭数据库
	public function close()
	{
		mysql_close($this->conn);
	}
	
	/**
	 * 将SQL查询结果转换为数据进行返回
	 * @param $result
	 */
	private function transformSqlResult2Array($result)
	{
		$arr = array();
		while($row = mysql_fetch_assoc($result))
		{
			array_push($arr,$row);
		}
		return $arr;
	}
}