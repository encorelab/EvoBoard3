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
			
			noteGraphic.explanation_txt.multiline = true;			
			noteGraphic.explanation_txt.text = explanation;
			noteGraphic.author_txt.text = organismTags.toString() + "," + timeTags.toString();
			noteGraphic.organism_txt.text = concept;
			var BoldText:TextFormat = new TextFormat();   
			BoldText.bold=true;
			noteGraphic.organism_txt.setTextFormat(BoldText);
			
			//find out whether organism TF or author TF is wider
			var longTFwidth:Number;			
			var tags_text:String = organismTags.toString() + "," + timeTags.toString();
			var concept_text:String = concept;
			var explain_text:String = explanation;
			noteGraphic.organism_txt.width = longTFwidth + 4;
			noteGraphic.author_txt.width = longTFwidth + 4;
			
			if ( (concept_text.length + 6) > tags_text.length || (explain_text.length + 6) > tags_text.length  ){
				resizeTagHeight();
			} 
			
			trace("explanation.length: "+explanation.length);
			if ( explanation.length > 200 ){
				setupExpandButton();
			} else {
				resizeExplanation();
			}
			formatColour( colour );
			
			orgBtn = new SquareBox() as MovieClip;
			addChild( orgBtn );
			orgBtn.x = noteGraphic.organism_txt.x;
			orgBtn.y = noteGraphic.organism_txt.y;
			orgBtn.width = noteGraphic.organism_txt.width;
			orgBtn.height = noteGraphic.organism_txt.height;
			orgBtn.alpha = 0;
			orgBtn.addEventListener( MouseEvent.CLICK, handleOrgBtnClick );
		}
		private function resizeTagHeight():void
		{
			trace("resizeTagHeight");
			var maxLines = 3;
			while( noteGraphic.author_txt.numLines > maxLines){
				noteGraphic.author_txt.width +=1;
			}
			
			noteGraphic.author_txt.height = noteGraphic.author_txt.textHeight;
			noteGraphic.bkgd.height = noteGraphic.organism_txt.height + noteGraphic.author_txt.height + 10;
			noteGraphic.glow.height = noteGraphic.organism_txt.height + noteGraphic.author_txt.height + 10;
			
			trace("tagGraphic.author_txt.textHeight: "+ noteGraphic.author_txt.textHeight);
			trace("tagGraphic.bkgd.height : "+ noteGraphic.bkgd.height );
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