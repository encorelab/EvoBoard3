package classes
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextFieldAutoSize;
	
	public class ConceptsEntry extends Sprite
	{
		private var author:String;
		private var tags:Array;
		private var explanation:String;
		private var concept:String;
		private var colour:uint;
		
		private var explanationGraphic:ExplanationGraphic;
		private var explanationObject:Sprite;	
		private var expandButton:ExpandButton;
		
		private var default_TFheight:Number = 93;
		private var default_TFwidth:Number = 183;
		private var default_height:Number = 120;
		private var default_width:Number = 200;
	
		private var _hit:MovieClip;
		
		public function ConceptsEntry( author_name:String, evo_concept:String, time_list:Array, org_list:Array, explanation_text:String )
		{
			trace("ConceptsEntry");
			author = author_name;
			concept = evo_concept;
			//
			explanation = explanation_text;
			expandButton = new ExpandButton();
			setupExplanation();
		}
		private function setupExplanation():void
		{
			explanationGraphic = new ExplanationGraphic();
			addChild( explanationGraphic );
			
			hit = explanationGraphic.hit;
			hit.addEventListener(MouseEvent.MOUSE_DOWN, handleClick);
			hit.addEventListener(MouseEvent.MOUSE_UP, handleRelease);
			
			explanationGraphic.explanation_txt.multiline = true;			
			explanationGraphic.explanation_txt.text = explanation;
			explanationGraphic.author_txt.text = author;
			
			trace("explanation.length: "+explanation.length);
			if ( explanation.length > 200 ){
				setupExpandButton();
			} else {
				resizeExplanation();
			}
			formatColour();
			setPosition();
		}
		private function resizeExplanation():void
		{
			trace( "resizeExplanation" );
			explanationGraphic.explanation_txt.autoSize = TextFieldAutoSize.LEFT;
			explanationGraphic.explanation_txt.text = explanation;
			explanationGraphic.explanation_txt.height = explanationGraphic.explanation_txt.textHeight + 8;	
			explanationGraphic.author_txt.width = explanationGraphic.author_txt.textWidth + 4;
			explanationGraphic.explanation_txt.width = explanationGraphic.explanation_txt.textWidth + 8;
			var longTFwidth:Number;
			if ( explanationGraphic.explanation_txt.textWidth > explanationGraphic.author_txt.textWidth ){
				longTFwidth = explanationGraphic.explanation_txt.width   	
			} else {
				longTFwidth = explanationGraphic.author_txt.width
			}
			explanationGraphic.bkgd.width = longTFwidth + 20;
			explanationGraphic.glow.width = longTFwidth + 20;
			explanationGraphic.author_txt.y = explanationGraphic.explanation_txt.y + explanationGraphic.explanation_txt.height;
			explanationGraphic.bkgd.height = explanationGraphic.author_txt.height + explanationGraphic.explanation_txt.height + 16;
			explanationGraphic.glow.height = explanationGraphic.author_txt.height + explanationGraphic.explanation_txt.height + 16;
			positionExpandButton();
		}
		private function resetExplanation():void
		{
			explanationGraphic.explanation_txt.autoSize = TextFieldAutoSize.NONE;
			explanationGraphic.explanation_txt.height = default_TFheight;
			explanationGraphic.explanation_txt.width = default_TFwidth;
			explanationGraphic.bkgd.width = default_width;
			explanationGraphic.glow.width = default_width;
			explanationGraphic.bkgd.height = default_height;
			explanationGraphic.glow.height = default_height;
			explanationGraphic.author_txt.y = explanationGraphic.explanation_txt.y + explanationGraphic.explanation_txt.height;
			positionExpandButton();
		}
		private function setupExpandButton():void
		{
			trace( "setupExpandButton" );
			positionExpandButton();
			expandButton.addEventListener( CustomEvent.EXPAND, handleExpandButton );
			addChild( expandButton );
		}
		private function positionExpandButton():void
		{
			expandButton.x = explanationGraphic.width - expandButton.width + 4;
			expandButton.y = explanationGraphic.height - expandButton.height + 1;
		}
		private function formatColour( new_color:uint=0xFFFFFF ):void
		{
			var myColor:ColorTransform = explanationGraphic.bkgd.transform.colorTransform;
			myColor.color = new_color;
			explanationGraphic.bkgd.transform.colorTransform = myColor;
		}
		//GETTERS & SETTERS
		//randomize
		public function setPosition():void
		{
			var lowX:Number = 0
			var lowY:Number = 0
			var highX:Number = EvoBoard3.stage_width;
			var highY:Number = EvoBoard3.stage_height;
			var adjusted_highX:Number = highX - explanationGraphic.width;
			var adjusted_highY:Number = highY - explanationGraphic.height;
			this.x = Math.floor(Math.random()*( 1 + adjusted_highX - lowX)) + lowX; 
			this.y = Math.floor(Math.random()*( 1 + adjusted_highY - lowY)) + lowY;
		}
		public function get hit():MovieClip {
			return _hit;
		}
		public function set hit( value:MovieClip ):void {
			_hit = value;
		}
		
		//EVENT HANDLERS
		private function handleExpandButton( e:CustomEvent ):void
		{
			trace("expanded: "+expanded);
			var expanded = e.customObject as Boolean;
			if( expanded ){
				//expand
				resizeExplanation();
			} else {
				//shrink
				resetExplanation();
			}
		}
		private function handleClick( e:MouseEvent ):void
		{
			this.startDrag( false );
		}
		private function handleRelease( e:MouseEvent ):void
		{
			this.stopDrag();
		}
	}
}