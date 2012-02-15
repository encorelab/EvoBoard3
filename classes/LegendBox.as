package classes
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.text.TextFormat;
	
	public class LegendBox extends Sprite
	{
		private var bkgd:Sprite;
		private var legendItems:Array;
		
		
		private var bkgd_width:Number 	= 40;
		private var x_pos:Number 		= 10;
		private var y_pos:Array 		= [518, 600, 690];
		
		public function LegendBox( list_names:Array, add_both:Boolean=false ):void
		{
			drawBkgd();
			addLegendItems( list_names, add_both );
		}
		private function addLegendItems( item_names:Array, add_both:Boolean ):void
		{
			legendItems = new Array();
			
			for ( var i:uint = 0; i < item_names.length; i++ ){
				addItem( item_names[i], EvoBoard3.colour_set[i], y_pos[i] );
			}
			//Add both
			if ( add_both ){
				addItem( "Both", EvoBoard3.colour_set[2], y_pos[2] );
			}
		}
		
		private function addItem( item_name:String, item_colour:uint, ypos:Number ):void
		{
			var item:MovieClip = new LegendMC as MovieClip;
			formatColour( item.square, item_colour );
			item.label_txt.text = item_name;
			var BoldText:TextFormat = new TextFormat();   
			BoldText.bold=true;
			item.label_txt.setTextFormat(BoldText);
			item.x = x_pos;
			item.y = ypos;
			legendItems.push( item );
			addChild( item );	
		}
		private function drawBkgd():void
		{
			bkgd = new Sprite();			
			bkgd.graphics.beginFill(0x000000);
			bkgd.graphics.drawRect( 0, 0, bkgd_width, EvoBoard3.stage_height );
			bkgd.graphics.endFill();
			bkgd.alpha = 0.5;
			addChild(bkgd);
		}
		private function formatColour( mc:MovieClip, new_color:uint=0xFFFFFF )
		{
			var myColor:ColorTransform = mc.transform.colorTransform;
			myColor.color = new_color;
			mc.transform.colorTransform = myColor;
		}
		public function setMeetupStyle():void
		{
			bkgd.visible = false;
		}
	}
}