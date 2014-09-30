package models
{
	import flash.geom.Point;
	
	import jing.utils.data.ArrayUtil;
	
	import vos.PieceVO;

	/**
	 * 拼图工具的数据模型 
	 * @author Jing
	 * 
	 */	
	public class PuzzleModel
	{
		/**
		 * 拼图面板 
		 */		
		private var _map:Vector.<PieceVO>;
		
		/**
		 * 拼图字典 
		 */		
		private var _pieces:Vector.<PieceVO>;
		
		/**
		 * 格子的尺寸，矩阵为 _size * _size 
		 */		
		private var _size:int;
		
		public function PuzzleModel(size:int)
		{
			_size = size;			
			_pieces = new Vector.<PieceVO>(size * size, true);
			for(var i:int = 0; i < _pieces.length; i++)
			{
				_pieces[i] = new PieceVO();
				_pieces[i].no = i;
			}
			upset(1);
		}
		
		/**
		 * 将数据打乱 
		 * @param step 打乱的步数，值越大越难还原
		 */		
		private function upset(step:int):void
		{
			_map = new Vector.<PieceVO>(_pieces.length, true);

			var i:int;			
			for(i = 1; i < _map.length; i++)
			{
				_map[i] = _pieces[i];
			}
			
			var emptyIndex:int = 0;
			while(--step > -1)
			{
				var nos:Array = getAroundNo(emptyIndex);
				var randomNO:int = ArrayUtil.getRandomObject(nos);
				emptyIndex = getPieceIndex(randomNO);
				move(randomNO);				
			}
			trace("upseted it");
		}
		
		/**
		 * 得到指定位置周围的图片号 
		 * @param mapIndex
		 * @return 
		 * 
		 */		
		private function getAroundNo(mapIndex:int):Array
		{
			var nos:Array = [];
			
			//第几行
			var row:int = int(mapIndex / _size);
			//第几列
			var col:int = mapIndex % _size;
			
			var tempIndex:int;
			//有上
			if(row > 0)
			{
				tempIndex = mapIndex - _size;
				if(_map[tempIndex] != null)
				{
					nos.push(_map[tempIndex].no);
				}
			}
			//有下
			if(row + 1 < _size)
			{
				tempIndex = mapIndex + _size;
				if(_map[tempIndex] != null)
				{
					nos.push(_map[tempIndex].no);
				}
			}
			//有左
			if(col > 0)
			{
				tempIndex = mapIndex - 1;
				if(_map[tempIndex] != null)
				{
					nos.push(_map[tempIndex].no);
				}
			}
			//有右
			if(col + 1 < _size)
			{
				tempIndex = mapIndex + 1;
				if(_map[tempIndex] != null)
				{
					nos.push(_map[tempIndex].no);
				}
			}				
			
			return nos;
		}
		

		
		public function getPiecePos(no:int):Point
		{
			var index:int = getPieceIndex(no);
			if(index > -1)
			{
				return new Point(index % _size, int(index / _size));
			}
			
			return null;
		}
		
		/**
		 * 得到碎片的索引位置 
		 * @param no
		 * @return 
		 * 
		 */		
		private function getPieceIndex(no:int):int
		{
			for(var i:int = 0; i < _map.length; i++)
			{
				if(_map[i] && _map[i].no == no)
				{
					return i;
				}
			}			
			return -1;
		}
		
		/**
		 * 移动碎片 
		 * @param index
		 * 
		 */		
		public function move(no:int):Boolean
		{
			var index:int = getPieceIndex(no);
			if(-1 == index)
			{
				return false;
			}
			
			//检查随便是否存在
			var pieceVO:PieceVO = _map[index];
			
			if(null == pieceVO)
			{
				return false;
			}
			
			//检查是否往上移动
			if(true == moveTo(index, index - _size))
			{
				return true;
			}
			
			//检查是否往左移动
			if(true == moveTo(index, index - 1))
			{
				return true;
			}
			
			//检查是否往右移动
			if(true == moveTo(index, index + 1))
			{
				return true;
			}
			
			//检查是否网下移动
			if(true == moveTo(index, index + _size))
			{
				return true;
			}
			
			return false;
		}
		
		/**
		 * 将指定索引位置的拼图块移动到目标位置 
		 * @param nowIndex
		 * @param targetIndex
		 * @return 
		 * 
		 */		
		private function moveTo(nowIndex:int, targetIndex:int):Boolean
		{
			if(targetIndex < 0 || targetIndex >= _map.length)
			{
				return false;
			}
			
			if(null != _map[targetIndex])
			{
				return false;
			}
			
			if(nowIndex % _size != targetIndex % _size && int(nowIndex / _size) != int(targetIndex / _size))
			{
				return false;
			}
			
			var pieceVO:PieceVO = _map[nowIndex];
			_map[nowIndex] = null;
			_map[targetIndex] = pieceVO;
			
			return true;
		}
		
		/**
		 * 通关检查 
		 * 
		 */		
		public function checkPass():Boolean
		{
			if(_map[0] != null)
			{
				return false;	
			}
			
			for(var i:int = 1; i < _map.length; i++)
			{
				if(_map[i].no != i)
				{
					return false;
				}
			}
			
			return true;
		}
	}
}