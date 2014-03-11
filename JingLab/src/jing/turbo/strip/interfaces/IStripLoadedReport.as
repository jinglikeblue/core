package jing.turbo.strip.interfaces
{
	import jing.turbo.strip.vo.StripVO;

	public interface IStripLoadedReport
	{
		function imageLoadedReport(vo:StripVO):void;
	}
}