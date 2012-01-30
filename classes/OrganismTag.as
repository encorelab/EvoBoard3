package classes
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	public class OrganismTag extends MovieClip
	{
		//private var organismTF:TextField;
		private var organismName:String;
		private var authorName:String;
		private var rainforest:String;
		private var tagGraphic:OrganismTagGraphic;
		private var isStatic:Boolean;
		private var boundsRectangle:Rectangle;
		
		/*private var _minX:Number;
		private var _minY:Number;
		private var _maxX:Number;
		private var _maxY:Number;*/

		public function OrganismTag( organism_name:String, author_name:String, location:String )
		{
			isStatic = true;
			organismName = organism_name;
			authorName = author_name;
			rainforest = location;
			drawTag();
		}
		private function drawTag():void
		{
			tagGraphic = new OrganismTagGraphic();
			tagGraphic.organism_txt.text = organismName;
			tagGraphic.author_txt.text = authorName;
			tagGraphic.organism_txt.width = tagGraphic.organism_txt.textWidth + 4;
			tagGraphic.author_txt.width = tagGraphic.author_txt.textWidth + 4;
			
			//find out whether organism TF or author TF is wider
			var longTFwidth:Number;
			if ( tagGraphic.organism_txt.textWidth > tagGraphic.author_txt.textWidth ){
				longTFwidth = tagGraphic.organism_txt.width   	
			} else {
				longTFwidth = tagGraphic.author_txt.width
			}
			
			tagGraphic.bkgd.width = longTFwidth + 20;
			tagGraphic.bkgd.alpha = 0.8;
			addChild( tagGraphic );
		}
		public function setBoundaries( x_value:Number, y_value:Number, width_value:Number, height_value:Number):void
		{
			var adjusted_width:Number = width_value - tagGraphic.width;
			var adjusted_height:Number = height_value - tagGraphic.height;
			
			boundsRectangle = new Rectangle( x_value, y_value, adjusted_width, adjusted_height);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onClick);
			this.addEventListener(MouseEvent.MOUSE_UP, onRelease);
		}
		public function setPosition( lowX:Number, lowY:Number, highX:Number, highY:Number ):void
		{
			var adjusted_highX:Number = highX - tagGraphic.width;
			var adjusted_highY:Number = highY - tagGraphic.height;
			this.x = Math.floor(Math.random()*( 1 + adjusted_highX - lowX)) + lowX; 
			this.y = Math.floor(Math.random()*( 1 + adjusted_highY - lowY)) + lowY;
		}
		
		private function onClick( e:MouseEvent ):void
		{
			startDrag( false, boundsRectangle );
		}
		private function onRelease( e:MouseEvent ):void
		{
			stopDrag();
		}
	}
}	