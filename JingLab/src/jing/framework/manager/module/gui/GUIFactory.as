package jing.framework.manager.module.gui
{
    import flash.utils.Dictionary;
    
    import jing.framework.manager.module.ModuleManager;

    /**
     * 视图工厂
     * @author jing
     *
     */
    public class GUIFactory
    {		
		/**
		 * 模块版本字典 
		 * 字典内对象[ModuleVerVO],索引KEY[ModuleVerVO.name]
		 */		
		static public var swfVerDic:Dictionary = null;
		
        static public function createGUI(guiName:String, swfPaths:Array, createComplete:Function):GUILoader
        {
            var guiLoader:GUILoader = null;

            if (true == ModuleManager.hasClass(guiName))
            {
                createComplete(guiName);
            }
            else
            {
                guiLoader = new GUILoader();
                guiLoader.load(guiName, swfPaths, createComplete);
            }
            return guiLoader;
        }
    }
}