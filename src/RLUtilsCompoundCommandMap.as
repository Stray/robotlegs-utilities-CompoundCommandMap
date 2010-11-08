package {
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import skins.RLUtilsCompoundCommandMapSkin;
	
	public class RLUtilsCompoundCommandMap extends Sprite {

		public function RLUtilsCompoundCommandMap() {
			addChild(new RLUtilsCompoundCommandMapSkin.ProjectSprouts() as DisplayObject);
			trace("RLUtilsCompoundCommandMap instantiated!");
		}
	}
}
