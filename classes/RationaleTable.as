package classes
{
	import flash.display.Sprite;

	public class RationaleTable extends Sprite
	{
		private var background:RationaleTableGraphic;
		
		private var group1_entries:Array;
		private var group2_entries:Array;
		private var group3_entries:Array;
		private var group4_entries:Array;
		
		public function RationaleTable()
		{
			background = new RationaleTableGraphic();
			addChild( background );
			
			group1_entries = new Array();
			group2_entries = new Array();
			group3_entries = new Array();
			group4_entries = new Array();
		}
		public function addEntry( group_code:String, author_name:String, question_text:String, answer_text:String ):void
		{			
			//group_code = "A1" - group_code.substr(1) should return "1"
			var group_num:String = group_code.substr(1);
			
			//eventData.group_code, eventData.author, eventData.question, eventData.answer 
			var entry:RationaleEntry = new RationaleEntry( group_num, author_name, question_text, answer_text );
			addChild( entry );	
			
			switch( group_num ) {
				case "1":
					group1_entries.push( entry );
					break;
				case "2":
					group2_entries.push( entry );
					break;
				case "3":
					group3_entries.push( entry );
					break;
				case "4":
					group4_entries.push( entry );
					break;
				default:
					trace("Unrecognized group code received: "+ group_code);
			}	
		}
	}
}