package classes
{
	import flash.display.MovieClip;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class OrganismTag extends MovieClip
	{
		private var _anchorPoint:Point
		private var _organismName:String;
		private var _authorName:String;
		private var _timeLocation:String;
		private var _assignedOrganisms:Array;
		private var _connections:Array;
		private var _boundsRectangle:Rectangle;
		private var _rainforest:String;
		private var tagGraphic:OrganismTagGraphic;
		private var label:MovieClip;
		private var isStatic:Boolean;
		
		private var max_width = 100;

		public function OrganismTag( organism_name:String, assigned_organism:String, author_name:String, location:String, rainforest_loc:String="none" )
		{
			isStatic = true;
			organismName = organism_name;
			authorName = author_name;
			timeLocation = location;
			rainforest = rainforest_loc;
			assignedOrganisms = [assigned_organism];
			anchorPoint = new Point();
			connections = new Array();
			drawTag();			
		}
		private function drawTag():void
		{
			tagGraphic = new OrganismTagGraphic();
			tagGraphic.organism_txt.autoSize = TextFieldAutoSize.LEFT;
			tagGraphic.organism_txt.text = EvoBoard3.stripUnderscores( organismName );
			tagGraphic.author_txt.autoSize = TextFieldAutoSize.LEFT;
			tagGraphic.author_txt.text = EvoBoard3.stripUnderscores( assignedOrganisms.toString() ); //EvoBoard3.stripUnderscores( authorName );			
			tagGraphic.organism_txt.mouseEnabled = false;
			tagGraphic.author_txt.mouseEnabled = false;
					
			//resizeTagWidth();
			
			//find out whether organism TF or author TF is wider
			var longTFwidth:Number;			
			var org_text:String = EvoBoard3.stripUnderscores( organismName );
			var assigned_org_text:String = EvoBoard3.stripUnderscores( assignedOrganisms.toString() );
			
			if ( (org_text.length + 6) > assigned_org_text.length ){
				tagGraphic.organism_txt.width = tagGraphic.organism_txt.textWidth + 4;
				longTFwidth = tagGraphic.organism_txt.width
			} else {
				tagGraphic.author_txt.width	= tagGraphic.author_txt.textWidth + 4;
				longTFwidth = tagGraphic.author_txt.width
			}
			tagGraphic.organism_txt.width = longTFwidth + 4;
			tagGraphic.author_txt.width = longTFwidth + 4;
			
			tagGraphic.bkgd.width = longTFwidth + 20;
			tagGraphic.glow.width = longTFwidth + 20;
			tagGraphic.bkgd.alpha = 0.8;
			formatPoint();
					
			if ( rainforest == "Borneo" ){
				label = new BorneoTag as MovieClip;
			} else if ( rainforest == "Sumatra" ){
				label = new SumatraTag as MovieClip;
			} else {
				label = new MovieClip();
			}
			
			tagGraphic.bkgd.alpha = 0.8;
			addChild( tagGraphic );
			addChild( label );
			label.x = 4;
			label.y = 4;
		}
		public function addAuthor( new_author:String, colour:uint ):void
		{
			authorName += (", " + new_author );
			formatColour( colour );
			//tagGraphic.author_txt.text = authorName;
			//resizeTagWidth();
		}
		public function addAssignedOrg( assigned_org:String ):void
		{
			var assigned_org_present:Boolean = false;
			var new_assigned_org:String;
			
			for( var i:uint=0; i < assignedOrganisms.length; i++ ){
				if ( assignedOrganisms[i] == assigned_org ){  
					assigned_org_present = true;
				}
			}
			if ( !assigned_org_present ){
				assignedOrganisms.push( EvoBoard3.stripUnderscores( assigned_org ) );
				new_assigned_org = tagGraphic.author_txt.text + ", " + EvoBoard3.stripUnderscores( assigned_org );
			} else {
				new_assigned_org = tagGraphic.author_txt.text;
			}
			tagGraphic.author_txt.text = new_assigned_org;
//			tagGraphic.author_txt.text = assignedOrganisms.toString();
			resizeTagWidth();

			trace("assignedOrganisms: "+assignedOrganisms);
		}
		public function addConnection( c:Connection ):void
		{
			connections.push( c );
		}
		private function resizeTagWidth():void
		{
			tagGraphic.organism_txt.width = tagGraphic.organism_txt.textWidth + 4;
			//tagGraphic.author_txt.width = tagGraphic.author_txt.textWidth + 4;
			
			if ( tagGraphic.author_txt.numLines > 1 ){
				resizeTagHeight();
			}
				
			//find out whether organism TF or author TF is wider
			var longTFwidth:Number;
			if ( tagGraphic.organism_txt.textWidth > tagGraphic.author_txt.textWidth ){
				longTFwidth = tagGraphic.organism_txt.width   	
			} else if ( tagGraphic.organism_txt.textWidth < tagGraphic.author_txt.textWidth  ) {
				longTFwidth = tagGraphic.author_txt.width;
			}
			
			tagGraphic.bkgd.width = longTFwidth + 20;
			tagGraphic.glow.width = longTFwidth + 20;
			
			formatPoint();
		}
		private function resizeTagHeight():void
		{
			trace("resizeTagHeight");
			var maxLines = 3;
			while( tagGraphic.author_txt.numLines > maxLines){
				tagGraphic.author_txt.width +=1;
			}

			tagGraphic.author_txt.height = tagGraphic.author_txt.textHeight;
			
			tagGraphic.bkgd.height = tagGraphic.organism_txt.height + tagGraphic.author_txt.height + 10;
			tagGraphic.glow.height = tagGraphic.organism_txt.height + tagGraphic.author_txt.height + 10;
			formatPoint();
			
			trace("tagGraphic.author_txt.textHeight: "+tagGraphic.author_txt.textHeight);
			trace("tagGraphic.bkgd.height : "+tagGraphic.bkgd.height );
		}
		public function formatColour( new_color:uint=0xFFFFFF ):void
		{
			var myColor:ColorTransform = tagGraphic.bkgd.transform.colorTransform;
			myColor.color = new_color;
			tagGraphic.bkgd.transform.colorTransform = myColor;
		}
		private function formatPoint():void
		{
			anchorPoint.x = tagGraphic.width/2;
			anchorPoint.y = tagGraphic.height/2;
		}
		public function setBoundaries( x_value:Number, y_value:Number, width_value:Number, height_value:Number):void
		{
			var adjusted_width:Number = width_value - tagGraphic.width;
			var adjusted_height:Number = height_value - tagGraphic.height;
			
			boundsRectangle = new Rectangle( x_value, y_value, adjusted_width, adjusted_height);
		}
		public function setPosition( lowX:Number, lowY:Number, highX:Number, highY:Number ):void
		{
			var adjusted_highX:Number = highX - tagGraphic.width;
			var adjusted_highY:Number = highY - tagGraphic.height;
			this.x = Math.floor(Math.random()*( 1 + adjusted_highX - lowX)) + lowX; 
			this.y = Math.floor(Math.random()*( 1 + adjusted_highY - lowY)) + lowY;
			formatPoint();
		}
		//GETTERS, SETTERS
		public function get organismName():String {
			return _organismName;
		}
		public function set organismName( value:String ):void {
			_organismName = value;
		}
		public function get authorName():String {
			return _authorName;
		}
		public function set authorName( value:String ):void {
			_authorName = value;
		}
		public function get timeLocation():String {
			return _timeLocation;
		}
		public function set timeLocation( value:String ):void {
			_timeLocation = value;
		}
		public function get rainforest():String {
			return _rainforest;
		}
		public function set rainforest( value:String ):void {
			_rainforest = value;
		}
		public function get assignedOrganisms():Array {
			return _assignedOrganisms;
		}
		public function set assignedOrganisms( value:Array ):void {
			_assignedOrganisms = value;
		}
		public function get boundsRectangle():Rectangle {
			return _boundsRectangle;
		}
		public function set boundsRectangle( value:Rectangle ):void {
			_boundsRectangle = value;
		}
		public function get connections():Array {
			return _connections;
		}
		public function set connections( value:Array ):void {
			_connections = value;
		}
		public function set anchorPoint ( p:Point ):void
		{
			_anchorPoint = p;
		}
		public function get anchorPoint():Point
		{
			return _anchorPoint;
		}
	}
}	