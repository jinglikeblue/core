package models
{
	import jing.utils.data.ArrayUtil;
	
	import vos.PieceVO;

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
		
		public function PuzzleModel(pieces:Vector.<PieceVO>)
		{
			_size = Math.sqrt(pieces.length);			
			_pieces = pieces;
			upset();
		}
		
		/**
		 * 将数据打乱 
		 * 
		 */		
		private function upset():void
		{
			_map = new Vector.<PieceVO>(_pieces.length, true);
			
			var arr:Array = [];
			
			var count:int = _map.length;
			var i:int;
			for(i = 1; i < count; i++)
			{
				arr.push(i);
			}
			
			arr = ArrayUtil.randomPermutationArray(arr);
			
			for(i = 1; i < _map.length; i++)
			{
				var pieceNO:int = arr.pop();
				_map[i] = _pieces[pieceNO];
			}
			
			trace("upseted it");
		}
		
		/**
		 * 移动碎片 
		 * @param index
		 * 
		 */		
		public function move(index:int):void
		{
			//检查随便是否存在
			var pieceVO:PieceVO = _map[index];
			
			if(null == pieceVO)
			{
				return;
			}
			
			//检查是否往上移动
			if(true == moveTo(index, index - _size))
			{
				return;
			}
			
			//检查是否往左移动
			if(true == moveTo(index, index - 1))
			{
				return;
			}
			
			//检查是否往右移动
			if(true == moveTo(index, index + 1))
			{
				return;
			}
			
			//检查是否网下移动
			if(true == moveTo(index, index + _size))
			{
				return;
			}
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
			
			var pieceVO:PieceVO = _map[nowIndex];
			_map[nowIndex] = null;
			_map[targetIndex] = pieceVO;
			
			return true;
		}
		
		/**
		 * 通关检查 
		 * 
		 */		
		private function checkPass():Boolean
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