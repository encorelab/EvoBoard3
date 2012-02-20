package classes
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class ConceptsEntry extends FeaturesEntry
	{
		private var _concept:String;
		private var _hit:MovieClip;
		
		private var organismTags:Array;
		private var timeTags:Array;
		private var orgTF:TextField;
		private var orgBtn:MovieClip;
		
		private var default_TFheight:Number = 75;
		
		public function ConceptsEntry( author_name:String, evo_concept:String, colour:uint, time_list:Array, org_list:Array, explanation_text:String )
		{
			concept = evo_concept;
			organismTags = org_list;
			timeTags = time_list;
			super(author_name, evo_concept, colour, explanation_text);
		}
		public override function setupExplanation():void
		{
			noteGraphic = new FeaturesNoteGraphic() as MovieClip;
			addChild( noteGraphic );
			
			hit = noteGraphic.hit;
			hit.addEventListener(MouseEvent.MOUSE_DOWN, handleClick);
			hit.addEventListener(MouseEvent.MOUSE_UP, handleRelease);
			hit.buttonMode = true;
			
			noteGraphic.organism_txt.text = concept;
			noteGraphic.explanation_txt.text = explanation;
			noteGraphic.author_txt.text = organismTags.toString() + "," + timeTags.toString();
			var BoldText:TextFormat = new TextFormat();   
			BoldText.bold=true;
			noteGraphic.organism_txt.setTextFormat(BoldText);
			
			if ( explanation.length > 200 ){
				setupExpandButton();
				resetExplanation();
			} else {
				resizeExplanation();
			}
			
			formatColour( colour );
		}
		public override function resizeExplanation():void
		{
			noteGraphic.explanation_txt.autoSize = TextFieldAutoSize.LEFT;
			noteGraphic.explanation_txt.multiline = true;			
			noteGraphic.explanation_txt.text = explanation;
			
			noteGraphic.author_txt.autoSize = TextFieldAutoSize.LEFT;
			noteGraphic.author_txt.multiline = true;
			noteGraphic.author_txt.wordWrap = true;
			noteGraphic.author_txt.text = organismTags.toString() + "," + timeTags.toString();
			
			noteGraphic.organism_txt.autoSize = TextFieldAutoSize.LEFT;
			noteGraphic.organism_txt.text = concept;
			var BoldText:TextFormat = new TextFormat();   
			BoldText.bold=true;
			noteGraphic.organism_txt.setTextFormat(BoldText);
			
			//find out whether organism TF or explanation TF is wider, then make that the TF width
			var longTFwidth:Number;
			if ( noteGraphic.explanation_txt.length > noteGraphic.organism_txt.length || noteGraphic.explanation_txt.length > noteGraphic.author_txt.length ){				
				longTFwidth = noteGraphic.explanation_txt.width;
				trace( "longTFwidth = explanation_txt.width = " + longTFwidth );
			} else if ( noteGraphic.organism_txt.length > noteGraphic.author_txt.length || noteGraphic.organism_txt.length > noteGraphic.explanation_txt.length ){
				longTFwidth = noteGraphic.organism_txt.width;
				trace( "longTFwidth = concept_txt.width = " + longTFwidth );
			} else {
				longTFwidth = default_TFwidth;
				trace( "longTFwidth = default_TFwidth" );
			}
			
			noteGraphic.explanation_txt.width = longTFwidth + 4;
			noteGraphic.organism_txt.width = longTFwidth + 4;
			noteGraphic.author_txt.width = longTFwidth + 4;
			
			//adjust width to longTFwidth
			noteGraphic.bkgd.width = longTFwidth + 20;
			noteGraphic.glow.width = longTFwidth + 20;
			noteGraphic.hit.width = longTFwidth + 20;
			
			//adjust heights as necessary
			noteGraphic.author_txt.y = noteGraphic.explanation_txt.y + noteGraphic.explanation_txt.height;
			noteGraphic.bkgd.height = noteGraphic.author_txt.height + noteGraphic.author_txt.y + 10;
			noteGraphic.glow.height = noteGraphic.author_txt.height + noteGraphic.author_txt.y + 10;
			noteGraphic.hit.height = noteGraphic.author_txt.height + noteGraphic.author_txt.y + 10;
			positionExpandButton();
		}
		public override function resetExplanation():void
		{
			noteGraphic.explanation_txt.autoSize = TextFieldAutoSize.NONE;
			noteGraphic.explanation_txt.height = default_TFheight;
			noteGraphic.explanation_txt.width = default_TFwidth;
			
			noteGraphic.author_txt.autoSize = TextFieldAutoSize.NONE;
			noteGraphic.author_txt.multiline = false;
			noteGraphic.author_txt.height = 20;
			noteGraphic.author_txt.y = noteGraphic.explanation_txt.y + noteGraphic.explanation_txt.height - 4;
			
			noteGraphic.bkgd.width = default_width;
			noteGraphic.glow.width = default_width;
			noteGraphic.hit.width = default_width;
			noteGraphic.bkgd.height = default_height;
			noteGraphic.glow.height = default_height;
			noteGraphic.hit.height = default_height;
			positionExpandButton();
		}
		public function tagMatch( item:String ):Boolean
		{
			var match:Boolean = false;
			var allTags:Array = timeTags.concat( organismTags );
			for ( var i:uint = 0; i < allTags.length; i++ ){
				if ( item == allTags[i] ){
					match = true;
				}
			}
			return match;
		}
		public function get concept():String {
			return _concept;
		}
		public function set concept( value:String ):void {
			_concept = value;
		}
	}
}