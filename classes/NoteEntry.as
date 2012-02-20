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
		private var _author:String;
		private var _specialty:String;
		private var _explanation:String;
		private var _colour:uint;
		
		public var noteGraphic:MovieClip;
		
		private var explanationObject:Sprite;	
		private var expandButton:ExpandButton;
		
		private var default_TFheight:Number = 93;
		public var default_TFwidth:Number = 183;
		public var default_height:Number = 120;
		public var default_width:Number = 200;
		
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
		public function setupExplanation():void
		{
			noteGraphic = new ExplanationGraphic() as MovieClip;
			addChild( noteGraphic );
			
			hit = noteGraphic.hit;
			hit.addEventListener(MouseEvent.MOUSE_DOWN, handleClick);
			hit.addEventListener(MouseEvent.MOUSE_UP, handleRelease);
			
			noteGraphic.explanation_txt.multiline = true;			
			noteGraphic.explanation_txt.text = explanation;
			noteGraphic.author_txt.text = author;
			
			//trace("explanation.length: "+explanation.length);
			if ( explanation.length > 200 ){
				setupExpandButton();
			} else {
				resizeExplanation();
			}
			formatColour( colour );
		}
		public function resizeExplanation():void
		{
			//trace( "resizeExplanation" );
			noteGraphic.explanation_txt.autoSize = TextFieldAutoSize.LEFT;
			noteGraphic.explanation_txt.text = explanation;
			noteGraphic.explanation_txt.height = noteGraphic.explanation_txt.textHeight + 8;	
			noteGraphic.author_txt.width = noteGraphic.author_txt.textWidth + 4;
			noteGraphic.explanation_txt.width = noteGraphic.explanation_txt.textWidth + 8;
			//trace("explanationGraphic.author_txt.textWidth: "+ explanationGraphic.author_txt.textWidth);
			//trace("explanationGraphic.explanation_txt.textWidth: "+explanationGraphic.explanation_txt.textWidth);
			
			//find out whether organism TF or author TF is wider
			var longTFwidth:Number;
			if ( noteGraphic.explanation_txt.textWidth > noteGraphic.author_txt.textWidth ){
				longTFwidth = noteGraphic.explanation_txt.width   	
			} else {
				longTFwidth = noteGraphic.author_txt.width
			}
			
			//trace("longTFwidth: "+longTFwidth);
			noteGraphic.bkgd.width = longTFwidth + 20;
			noteGraphic.glow.width = longTFwidth + 20;
			noteGraphic.hit.width = longTFwidth + 20;
			noteGraphic.author_txt.y = noteGraphic.explanation_txt.y + noteGraphic.explanation_txt.height;
			noteGraphic.bkgd.height = noteGraphic.author_txt.height + noteGraphic.explanation_txt.height + 16;
			noteGraphic.glow.height = noteGraphic.author_txt.height + noteGraphic.explanation_txt.height + 16;
			noteGraphic.hit.height = noteGraphic.author_txt.height + noteGraphic.explanation_txt.height + 16;
			positionExpandButton();
		}
		public function resetExplanation():void
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
			noteGraphic.author_txt.y = noteGraphic.explanation_txt.y + noteGraphic.explanation_txt.height;
			positionExpandButton();
		}
		public function setupExpandButton():void
		{
			//trace( "setupExpandButton" );
			positionExpandButton();
			expandButton.addEventListener( CustomEvent.EXPAND, handleExpandButton );
			addChild( expandButton );
			//setChildIndex( expandButton, numChildren-1 );
			//trace( "this.numChildren: "+this.numChildren );
		}
		public function positionExpandButton():void
		{
			expandButton.x = noteGraphic.width - expandButton.width + 4;
			expandButton.y = noteGraphic.height - expandButton.height + 1;
		}
		public function formatColour( new_color:uint=0xFF0000 ):void
		{
			var myColor:ColorTransform = noteGraphic.bkgd.transform.colorTransform;
			myColor.color = new_color;
			noteGraphic.bkgd.transform.colorTransform = myColor;
		}
		//GETTERS & SETTERS
		public function setBoundaries( x_value:Number, y_value:Number, width_value:Number, height_value:Number):void
		{
			var adjusted_width:Number = width_value - noteGraphic.width;
			var adjusted_height:Number = height_value - noteGraphic.height;
			
			boundsRectangle = new Rectangle( x_value, y_value, adjusted_width, adjusted_height);
		}
		public function setPosition( lowX:Number, lowY:Number, highX:Number, highY:Number ):void
		{
			var adjusted_highX:Number = highX - noteGraphic.width;
			var adjusted_highY:Number = highY - noteGraphic.height;
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
		public function get author():String {
			return _author;
		}
		public function set author( value:String ):void {
			_author = value;
		}
		public function get specialty():String {
			return _specialty;
		}
		public function set specialty( value:String ):void {
			_specialty = value;
		}
		public function get explanation():String {
			return _explanation;
		}
		public function set explanation( value:String ):void {
			_explanation = value;
		}
		public function get colour():uint {
			return _colour;
		}
		public function set colour( value:uint ):void {
			_colour = value;
		}
		
		//EVENT HANDLERS
		private function handleExpandButton( e:CustomEvent ):void
		{
			//trace("handleExpandButton");
			//trace("expanded: "+expanded);
			var expanded = e.customObject as Boolean;
			if( expanded ){
				//expand
				resizeExplanation();
			} else {
				//shrink
				resetExplanation();
			}
		}
		public function handleClick( e:MouseEvent ):void
		{
			//this.startDrag( false, boundsRectangle );
			this.startDrag( false );
		}
		public function handleRelease( e:MouseEvent ):void
		{
			this.stopDrag();
		}
	}
}