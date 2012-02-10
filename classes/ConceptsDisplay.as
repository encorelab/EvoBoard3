package classes
{
	import flash.display.Sprite;
	
	public class ConceptsDisplay extends Sprite
	{
		private var background:ConceptsGraphic;
		private var notes:Array;
		
		public function ConceptsDisplay()
		{
			trace("Instantiate ConceptsDisplay");
			background = new ConceptsGraphic();
			addChild( background );
			
			notes = new Array();
		}
		public function addEntry( author:String, evo_concept:String, time_list:Array, org_list:Array, explanation:String ):void
		{				
			var entry:ConceptsEntry = new ConceptsEntry( author, evo_concept, time_list, org_list, explanation );
			addChild( entry );
			notes.push( entry );
		}
	}
}