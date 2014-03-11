package jing.utils.img
{
	import flash.filters.ColorMatrixFilter;

	public class ColorMatrixFilterUtil
	{
		/**
		 * 黑白色滤镜数组
		 */
		static public const BLACK_WHITE_MATRIX:Array=[1 / 3, 1 / 3, 1 / 3, 0, 0, 1 / 3, 1 / 3, 1 / 3, 0, 0, 1 / 3, 1 / 3, 1 / 3, 0, 0, 0, 0, 0, 1, 0];

		/**
		 * 黑蓝色滤镜数组
		 */
		static public const BLACK_BLUE_MATRIX:Array=[0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0];

		/**
		 * 黑黄色滤镜数组
		 */
		static public const BLACK_YELLOW_MATRIX:Array=[1 / 2, 1 / 2, 1 / 2, 0, 0, 1 / 3, 1 / 3, 1 / 3, 0, 0, 1 / 4, 1 / 4, 1 / 4, 0, 0, 0, 0, 0, 1, 0];

		/**
		 * 高亮滤镜数组
		 */
		static public const HIGHLIGHT_MATRIX:Array=[1, 0, 0, 0, 50, 0, 1, 0, 0, 50, 0, 0, 1, 0, 50, 0, 0, 0, 1, 0];

		/**
		 * 得到一个黑白色的颜色滤镜
		 * @return
		 *
		 */
		static public function getBlackWhiteFilter():ColorMatrixFilter
		{
			return new ColorMatrixFilter(BLACK_WHITE_MATRIX);
		}

		/**
		 * 得到一个黑蓝色的颜色滤镜
		 * @return
		 *
		 */
		static public function getBlackBlueFilter():ColorMatrixFilter
		{
			return new ColorMatrixFilter(BLACK_BLUE_MATRIX);
		}

		/**
		 * 得到一个黑黄色的颜色滤镜
		 * @return
		 *
		 */
		static public function getBlackYellowFilter():ColorMatrixFilter
		{
			return new ColorMatrixFilter(BLACK_YELLOW_MATRIX);
		}

		/**
		 * 得到一个高亮的颜色滤镜
		 * @return
		 *
		 */
		static public function getHighlightFilter():ColorMatrixFilter
		{
			return new ColorMatrixFilter(HIGHLIGHT_MATRIX);
		}
	}
}
