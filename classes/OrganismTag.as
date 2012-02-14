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
	import flash.text.TextFormat;
	
	public class OrganismTag extends MovieClip
	{
		private var _anchorPoint:Point
		//private var _relativeObject:OrganismTag;	//temporary variable setup for creating a connection object
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
			tagGraphic.organism_txt.text = EvoBoard3.stripUnderscore( organismName );
			//change to display assinged organism
			tagGraphic.author_txt.text = getAssignedOrganisms();
			
			var BoldText:TextFormat = new TextFormat();   
			BoldText.bold=true;
			tagGraphic.organism_txt.setTextFormat(BoldText);
			
			tagGraphic.organism_txt.width = tagGraphic.organism_txt.textWidth + 8;
			tagGraphic.author_txt.width = tagGraphic.author_txt.textWidth + 8;
			
			tagGraphic.organism_txt.mouseEnabled = false;
			tagGraphic.author_txt.mouseEnabled = false;
			
			//find out whether organism TF or author TF is wider
			var longTFwidth:Number;
			if ( tagGraphic.organism_txt.textWidth > tagGraphic.author_txt.textWidth ){
				longTFwidth = tagGraphic.organism_txt.width   	
			} else {
				longTFwidth = tagGraphic.author_txt.width
			}
			if ( rainforest == "Borneo" ){
				label = new BorneoTag as MovieClip;
			} else if ( rainforest == "Sumatra" ){
				label = new SumatraTag as MovieClip;
			} else {
				label = new MovieClip();
			}
			
			tagGraphic.bkgd.width = longTFwidth + 10;
			tagGraphic.glow.width = longTFwidth + 10;
			tagGraphic.bkgd.alpha = 0.8;
			formatPoint();
			addChild( tagGraphic );
			addChild( label  );
			label.x = 4;
			label.y = 4;
		}
		
		private function resizeTag():void
		{
			tagGraphic.organism_txt.width = tagGraphic.organism_txt.textWidth + 8;
			tagGraphic.author_txt.width = tagGraphic.author_txt.textWidth + 8;
			
			//find out whether organism TF or author TF is wider
			var longTFwidth:Number;
			if ( tagGraphic.organism_txt.textWidth > tagGraphic.author_txt.textWidth ){
				longTFwidth = tagGraphic.organism_txt.width   	
			} else {
				longTFwidth = tagGraphic.author_txt.width
			}
			
			tagGraphic.bkgd.width = longTFwidth + 10;
			tagGraphic.glow.width = longTFwidth + 10;
			formatPoint();
		}
		public function addAuthor( new_author:String, colour:uint ):void
		{
			authorName += (", " + new_author );
			formatColour( colour );
			tagGraphic.author_txt.text = authorName;
			resizeTag();
		}
		public function addAssignedOrg( assigned_org:String ):void
		{
			var assigned_org_present:Boolean = false;
			for( var i:uint=0; i < assignedOrganisms.length; i++ ){
				if ( assignedOrganisms[i] == assigned_org ){  
					assigned_org_present = true;
				}
			}
			if ( !assigned_org_present ){
				assignedOrganisms.push( assigned_org );
			}
			//tagGraphic.author_txt.text = getAssignedOrganisms();
			//resizeTag();
			//trace("assignedOrganisms: "+assignedOrganisms);
		}
		public function addConnection( c:Connection ):void
		{
			connections.push( c );
		}
		public function setOutline( colour:uint=0xFF0000 ):void
		{
			var thickness = 6;
			var outline:GlowFilter = new GlowFilter();
			outline.blurX = outline.blurY = thickness;
			outline.alpha = 0.8;
			outline.color = colour;
			outline.quality = BitmapFilterQuality.HIGH;
			outline.strength = 20;
			var filterArray:Array = new Array();
			filterArray.push(outline);
			tagGraphic.filters = filterArray;
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
		private function getAssignedOrganisms():String
		{
			var assignedOrgs:String = assignedOrganisms[0];
			for ( var i:uint=0; i < assignedOrganisms.length-1; i++) {
				assignedOrgs += ", " + assignedOrganisms[i+1];
			}
			return assignedOrgs;
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