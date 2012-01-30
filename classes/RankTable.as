package classes
{
	import flash.display.Sprite;

	public class RankTable extends Sprite
	{
		private var background:RankTableGraphic;
		private var rainforestA_entries:Array;
		private var rainforestB_entries:Array;
		private var rainforestC_entries:Array;
		private var rainforestD_entries:Array;
		
		private var rainforestA_rank:Number;
		private var rainforestB_rank:Number;
		private var rainforestC_rank:Number;
		private var rainforestD_rank:Number;
		
		private var authorName:String;
		private var groupCode:String; 
		
		public function RankTable()
		{
			background = new RankTableGraphic();
			addChild( background );
			
			rainforestA_entries = new Array();
			rainforestB_entries = new Array();
			rainforestC_entries = new Array();
			rainforestD_entries = new Array();
		}
		//eventData.group_code, eventData.author, eventData.ranks.rainforest_a, eventData.ranks.rainforest_b, eventData.ranks.rainforest_c, eventData.ranks.rainforest_d
		public function addEntry( group_code:String, author_name:String, rankA:String, rankB:String, rankC:String, rankD:String):void
		{			
			//group_code = "A1" - group_code.substr(1) should return "1"
			var group_num:String = group_code.substr(1);	
				
			var entryA:TableEntry;
			entryA = new TableEntry( group_num, "rainforest_a", rankA );
			addChild( entryA );
			rainforestA_entries.push( entryA );	
			
			var entryB:TableEntry;
			entryB = new TableEntry( group_num, "rainforest_b", rankB );
			addChild( entryB );
			rainforestB_entries.push( entryB );
					
			var entryC:TableEntry;
			entryC = new TableEntry( group_num, "rainforest_c", rankC );
			addChild( entryC );
			rainforestC_entries.push( entryC );
						
			var entryD:TableEntry;
			entryD = new TableEntry( group_num, "rainforest_d", rankD );
			addChild( entryD );
			rainforestD_entries.push( entryD );
		}
	}
}