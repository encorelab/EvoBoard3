package classes
{
	import classes.ExpandButton;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	
	public class NoteEntry extends Sprite
	{
		private var author:String;
		private var specialty:String;
		private var explanation:String;
		private var colour:uint;
		
		private var explanationGraphic:ExplanationGraphic;
		private var explanationObject:Sprite;	
		private var expandButton:ExpandButton;
		
		private var default_TFheight:Number = 93;
		private var default_TFwidth:Number = 183;
		private var default_height:Number = 120;
		private var default_width:Number = 200;
		
		private var _boundsRectangle:Rectangle;
		private var _hit:MovieClip;
		
		public function NoteEntry( author_name:String, specialty_group:String, team_colour:uint, explanation_text:String="blank" )
		{
			author = author_name;
			specialty = specialty_group;
			colour = team_colour;
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
			formatColour( colour );
		}
		private function resizeExplanation():void
		{
			trace( "resizeExplanation" );
			explanationGraphic.explanation_txt.autoSize = TextFieldAutoSize.LEFT;
			explanationGraphic.explanation_txt.text = explanation;
			explanationGraphic.explanation_txt.height = explanationGraphic.explanation_txt.textHeight + 8;	
			explanationGraphic.author_txt.width = explanationGraphic.author_txt.textWidth + 4;
			explanationGraphic.explanation_txt.width = explanationGraphic.explanation_txt.textWidth + 8;
			//trace("explanationGraphic.author_txt.textWidth: "+ explanationGraphic.author_txt.textWidth);
			//trace("explanationGraphic.explanation_txt.textWidth: "+explanationGraphic.explanation_txt.textWidth);
			
			//find out whether organism TF or author TF is wider
			var longTFwidth:Number;
			if ( explanationGraphic.explanation_txt.textWidth > explanationGraphic.author_txt.textWidth ){
				longTFwidth = explanationGraphic.explanation_txt.width   	
			} else {
				longTFwidth = explanationGraphic.author_txt.width
			}
			
			//trace("longTFwidth: "+longTFwidth);
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
			//setChildIndex( expandButton, numChildren-1 );
			//trace( "this.numChildren: "+this.numChildren );
		}
		private function positionExpandButton():void
		{
			expandButton.x = explanationGraphic.width - expandButton.width + 4;
			expandButton.y = explanationGraphic.height - expandButton.height + 1;
		}
		private function formatColour( new_color:uint=0xFF0000 ):void
		{
			var myColor:ColorTransform = explanationGraphic.bkgd.transform.colorTransform;
			myColor.color = new_color;
			explanationGraphic.bkgd.transform.colorTransform = myColor;
		}
		//GETTERS & SETTERS
		public function setBoundaries( x_value:Number, y_value:Number, width_value:Number, height_value:Number):void
		{
			var adjusted_width:Number = width_value - explanationGraphic.width;
			var adjusted_height:Number = height_value - explanationGraphic.height;
			
			boundsRectangle = new Rectangle( x_value, y_value, adjusted_width, adjusted_height);
		}
		public function setPosition( lowX:Number, lowY:Number, highX:Number, highY:Number ):void
		{
			var adjusted_highX:Number = highX - explanationGraphic.width;
			var adjusted_highY:Number = highY - explanationGraphic.height;
			this.x = Math.floor(Math.random()*( 1 + adjusted_highX - lowX)) + lowX; 
			this.y = Math.floor(Math.random()*( 1 + adjusted_highY - lowY)) + lowY;
		}
		public function get boundsRectangle():Rectangle {
			return _boundsRectangle;
		}
		public function set boundsRectangle( value:Rectangle ):void {
			_boundsRectangle = value;
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
			trace("handleExpandButton");
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
			//this.startDrag( false, boundsRectangle );
			this.startDrag( false );
		}
		private function handleRelease( e:MouseEvent ):void
		{
			this.stopDrag();
		}
	}
}