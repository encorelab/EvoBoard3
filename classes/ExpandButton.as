package classes
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class ExpandButton extends MovieClip
	{
		private var _expanded:Boolean = false;
		
		public function ExpandButton()
		{
			trace("Instantiate ExpandButton");
			this.stop();
			this.buttonMode = true;
			addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		private function onMouseClick(e:MouseEvent):void
		{
			trace("click")
			if( expanded ){
				gotoAndStop("plus");
				expanded = false;
			} else {
				gotoAndStop("minus");
				expanded = true;
			}
			dispatchEvent(new CustomEvent( expanded, CustomEvent.EXPAND ));
		}
		public function get expanded():Boolean {
			return _expanded;
		}
		public function set expanded( value:Boolean ):void {
			_expanded = value;
		}
	}
}