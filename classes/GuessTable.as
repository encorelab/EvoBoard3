package classes
{
	import flash.display.Sprite;
	import flash.text.TextField;

	public class GuessTable extends Sprite
	{
		private var background:GuessTableGraphic;
		private var rainforestA_entries:Array;
		private var rainforestB_entries:Array;
		private var rainforestC_entries:Array;
		private var rainforestD_entries:Array;
		
		public function GuessTable()
		{
			background = new GuessTableGraphic();
			addChild( background );
			
			rainforestA_entries = new Array();
			rainforestB_entries = new Array();
			rainforestC_entries = new Array();
			rainforestD_entries = new Array();
		}
		public function addEntry( group_code:String, rainforest_location:String, your_rainforest:String, explanation:String ):void
		{			
			//group_code = "A1" - group_code.substr(1) should return "1"
			var group_num:String = group_code.substr(1);
						
			var is_your_rainforest:String 
			//is_your_rainforest = your_rainforest; 
			
			if( your_rainforest == "true" ){
				is_your_rainforest = "Yes";
			} else {
				is_your_rainforest = "No";
			}
			
			
			var guessEntry:TableEntry = new TableEntry( group_num, rainforest_location, is_your_rainforest, explanation );
			addChild( guessEntry );
			
			switch( rainforest_location ) {
				case "rainforest_a":
					rainforestA_entries.push( guessEntry );
					break;
				case "rainforest_b":
					rainforestB_entries.push( guessEntry );
					break;
				case "rainforest_c":
					rainforestC_entries.push( guessEntry );
					break;
				case "rainforest_d":
					rainforestD_entries.push( guessEntry );
					break;
				default:
					trace("Unrecognized rainforest location received: "+rainforest_location);
			}		
		}
	}
}