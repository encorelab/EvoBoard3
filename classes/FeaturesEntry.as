package classes
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class FeaturesEntry extends NoteEntry
	{
		private var orgTF:TextField;
		private var orgBtn:MovieClip;
		private var default_TFheight:Number = 75;
		
		private var _organism:String;
		
		public function FeaturesEntry(author_name:String, organism_name:String, team_colour:uint, explanation_text:String="blank")
		{
			super(author_name, organism_name, team_colour, explanation_text);
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
			noteGraphic.author_txt.text = author;
			noteGraphic.organism_txt.text = specialty;
			organism = specialty;
			var BoldText:TextFormat = new TextFormat();   
			BoldText.bold=true;
			noteGraphic.organism_txt.setTextFormat(BoldText);
			
			//trace("explanation.length: "+explanation.length);
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
		private function addOrganismTF():void
		{
			orgTF = new TextField();
			
		}
		public override function resizeExplanation():void
		{
			//super.resizeExplanation();
			//trace( "resizeExplanation" );
			noteGraphic.explanation_txt.autoSize = TextFieldAutoSize.LEFT;
			noteGraphic.explanation_txt.text = explanation;
			noteGraphic.explanation_txt.height = noteGraphic.explanation_txt.textHeight + 8;	
			noteGraphic.explanation_txt.width = noteGraphic.explanation_txt.textWidth + 8;
			
			noteGraphic.author_txt.autoSize = TextFieldAutoSize.LEFT;
			noteGraphic.author_txt.width = noteGraphic.author_txt.textWidth + 4;
			
			noteGraphic.organism_txt.autoSize = TextFieldAutoSize.LEFT;
			noteGraphic.organism_txt.width = noteGraphic.author_txt.textWidth + 4;
			
			//trace( "explation text width: "+ noteGraphic.explanation_txt.textWidth );
			//trace( "organism text width: "+ noteGraphic.organism_txt.textWidth );
			//trace( "author text width: "+ noteGraphic.author_txt.textWidth );
						
			//find out whether organism TF or author TF is wider
			var longTFwidth:Number;
			if ( noteGraphic.explanation_txt.textWidth > noteGraphic.author_txt.textWidth && noteGraphic.explanation_txt.textWidth > noteGraphic.organism_txt.textWidth  ){
				longTFwidth = noteGraphic.explanation_txt.width   	
			} else if ( noteGraphic.author_txt.textWidth > noteGraphic.explanation_txt.textWidth && noteGraphic.author_txt.textWidth > noteGraphic.organism_txt.textWidth ) {
				longTFwidth = noteGraphic.author_txt.width;
			} else {	
				longTFwidth = noteGraphic.organism_txt.width;
			}
			//trace("longTFwidth: "+longTFwidth);
			noteGraphic.bkgd.width 	= longTFwidth + 20;
			noteGraphic.glow.width 	= longTFwidth + 20;
			noteGraphic.hit.width 	= longTFwidth + 20;
			
			//noteGraphic.organism_txt.y 	= noteGraphic.explanation_txt.y + noteGraphic.explanation_txt.height;
			//noteGraphic.organism_txt.x 	= noteGraphic.bkgd.width - noteGraphic.organism_txt.width - 10;
			noteGraphic.author_txt.y = noteGraphic.explanation_txt.y + noteGraphic.explanation_txt.height - 4;
			
			noteGraphic.bkgd.height = noteGraphic.organism_txt.height + noteGraphic.author_txt.height + noteGraphic.explanation_txt.height + 8;
			noteGraphic.glow.height = noteGraphic.organism_txt.height + noteGraphic.author_txt.height + noteGraphic.explanation_txt.height + 8;
			noteGraphic.hit.height  = noteGraphic.organism_txt.height + noteGraphic.author_txt.height + noteGraphic.explanation_txt.height + 8;
			positionExpandButton();
		}
		public override function resetExplanation():void
		{
			noteGraphic.explanation_txt.autoSize = TextFieldAutoSize.NONE;
			noteGraphic.explanation_txt.height = default_TFheight;
			noteGraphic.explanation_txt.width = default_TFwidth;
			noteGraphic.bkgd.width = default_width;
			noteGraphic.glow.width = default_width;
			noteGraphic.hit.width = default_width;
			noteGraphic.bkgd.height = default_height;
			noteGraphic.glow.height = default_height;
			noteGraphic.hit.height = default_height;
			//noteGraphic.organism_txt.x = default_width - noteGraphic.organism_txt.width - 10;
			noteGraphic.author_txt.y = noteGraphic.explanation_txt.y + noteGraphic.explanation_txt.height - 4;
			positionExpandButton();
		}
		public function handleOrgBtnClick( e:MouseEvent ):void
		{
			//trace("click");
			dispatchEvent( new CustomEvent( noteGraphic.organism_txt.text, CustomEvent.CLICK ));
		}
		public function get organism():String {
			return _organism;
		}
		public function set organism( value:String ):void {
			_organism = value;
		}
	}
}