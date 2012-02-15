package classes
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
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
			tagTF.autoSize = TextFieldAutoSize.LEFT;
			tagTF.multiline = false;
			tagTF.wordWrap = false;
			tagTF.text = label;
			tagBtn.alpha = 0.5;
			trace("tagTF.textWidth: "+tagTF.textWidth);
			trace("tagTF.width: "+tagTF.width);
			
				
			//tagTF.width = tagTF.textWidth + 10;
			tagBtn.width = tagTF.width;
			
			tagBtn.buttonMode = true;
			tagBtn.addEventListener( MouseEvent.CLICK, handleClick );
		}
		private function handleClick( e:MouseEvent ):void
		{
			dispatchEvent( new CustomEvent( tagLabel, CustomEvent.CLICK ));
		}
		public function formatTF():void
		{
			tagTF.width = 200;
			tagBtn.width = 200;
		}
		public function get tagLabel():String {
			return _tagLabel;
		}
		public function set tagLabel( value:String ):void {
			_tagLabel = value;
		}
	}
}