package classes
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class TagButton extends MovieClip
	{
		private var tagTF:TextField;
		private var tagBtn:MovieClip;
		private var _tagLabel:String
		
		public function TagButton( label:String )
		{
			trace( "tag button instantiated" );
			tagTF = this.tag_txt;
			tagBtn = this.tag_btn;
			tagLabel = label;
			tagTF.text = label;
			tagBtn.buttonMode = true;
			tagBtn.addEventListener( MouseEvent.CLICK, handleClick );
		}
		private function handleClick( e:MouseEvent ):void
		{
			dispatchEvent( new CustomEvent( tagLabel, CustomEvent.CLICK ));
		}
		public function get tagLabel():String {
			return _tagLabel;
		}
		public function set tagLabel( value:String ):void {
			_tagLabel = value;
		}
	}
}