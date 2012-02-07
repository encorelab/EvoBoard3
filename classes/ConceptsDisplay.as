package classes
{
	import flash.display.Sprite;
	
	public class ConceptsDisplay extends Sprite
	{
		private var notes:Array;
		
		public function ConceptsDisplay()
		{
			trace("Instantiate ConceptsDisplay");
			notes = new Array();
		}
		public function addEntry( author:String, evo_concept:String, tag_list:Array, explanation:String ):void
		{				
			var entry:ConceptsEntry = new ConceptsEntry( author, evo_concept, tag_list, explanation );
			addChild( entry );
			notes.push( entry );
		}
	}
}