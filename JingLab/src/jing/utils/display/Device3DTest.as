package jing.utils.display
{
    import flash.display.Stage;
    import flash.display.Stage3D;
    import flash.display3D.Context3DProfile;
    import flash.display3D.Context3DTextureFormat;
    import flash.display3D.textures.Texture;
    import flash.events.ErrorEvent;
    import flash.events.Event;
    
    import jing.turbo.handle.Handle;
    import jing.turbo.handle.HandleDispatcher;

    /**
     * 3D设备显存测试工具
     * @author Jing
     *
     */
    public class Device3DTest extends HandleDispatcher
    {
		public function Device3DTest():void
		{
			
		}
		
        private var _report:ReportData;

        /**
         * 测试报告
         * @return
         *
         */
        public function get report():ReportData
        {
            return _report;
        }

        private var _stage3D:Stage3D;

        public function runTest(stage:Stage):void
        {
            _report = new ReportData();
            _stage3D = stage.stage3Ds[0];
            _stage3D.addEventListener(Event.CONTEXT3D_CREATE, _stage3D_context3dCreatedHandler);
            _stage3D.addEventListener(ErrorEvent.ERROR, _stage3D_errorHandler);
            _stage3D.requestContext3D("auto",Context3DProfile.BASELINE_CONSTRAINED);
        }

        private function _stage3D_context3dCreatedHandler(e:Event):void
        {
			_report.driverInfo = _stage3D.context3D.driverInfo;
            var texture:Texture;
            var count:int;

            try
            {
                while (true)
                {
                    texture = _stage3D.context3D.createTexture(512, 512, Context3DTextureFormat.BGRA, false);
                    count++;
                }

            }
            catch (e:Error)
            {

            }

            _report.maxMemoryCapacity = count << 20;
            _report.support3d = true;
            end();
        }

        private function _stage3D_errorHandler(e:ErrorEvent):void
        {
            end();
        }

        private function end():void
        {
            _stage3D.removeEventListener(Event.CONTEXT3D_CREATE, _stage3D_context3dCreatedHandler);
            _stage3D.removeEventListener(ErrorEvent.ERROR, _stage3D_errorHandler);
            _stage3D.context3D.dispose();
            _stage3D = null;
            this.sendHandle(new Handle(Handle.COMPLETE));
            trace("是否支持3D：", _report.support3d, " 显存容量: ", _report.maxMemoryCapacity >> 20, "MB");
			trace("驱动信息：", _report.driverInfo);
        }

    }
}

class ReportData
{
	public function ReportData():void
	{
		
	}
	
    /**
     * 是否支持3D
     */
    public var support3d:Boolean = false;

    /**
     * 最大显示内存容量
     */
    public var maxMemoryCapacity:uint = 0;
	
	/**
	 * 驱动信息 
	 */	
	public var driverInfo:String;
}
