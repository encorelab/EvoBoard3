package classes
{
	import flash.display.Sprite;
	import flash.text.TextField;

	public class OrganismVis extends Sprite
	{
		private var background:OrganismVisBackground;
		private var rainforestA_organisms:Array;
		private var rainforestB_organisms:Array;
		private var rainforestC_organisms:Array;
		private var rainforestD_organisms:Array;
		
		private var stage_width = 1024;
		private var stage_height = 768;
	
		public function OrganismVis()
		{
			background = new OrganismVisBackground();
			addChild( background );
			
			rainforestA_organisms = new Array();
			rainforestB_organisms = new Array();
			rainforestC_organisms = new Array();
			rainforestD_organisms = new Array();
		}
		public function addTag(organism_name:String, author_name:String, rainforest_location:String):void
		{
			var orgTag:OrganismTag = new OrganismTag( organism_name, author_name, rainforest_location );
			addChild( orgTag );
			
			switch( rainforest_location ) {
				case "rainforest_a":
					rainforestA_organisms.push( orgTag );
					orgTag.setBoundaries( 0, 0, stage_width/2, stage_height/2);
					orgTag.setPosition( 0, 0, stage_width/2, stage_height/2);
					break;
				case "rainforest_b":
					rainforestB_organisms.push( orgTag );
					orgTag.setBoundaries( stage_width/2, 0, stage_width/2, stage_height/2);
					orgTag.setPosition( stage_width/2, 0, stage_width, stage_height/2);
					break;
				case "rainforest_c":
					rainforestC_organisms.push( orgTag );
					orgTag.setBoundaries( 0, stage_height/2, stage_width/2, stage_height/2);
					orgTag.setPosition( 0, stage_height/2, stage_width/2, stage_height);
					break;
				case "rainforest_d":
					rainforestD_organisms.push( orgTag );
					orgTag.setBoundaries( stage_width/2, stage_height/2, stage_width/2, stage_height/2);
					orgTag.setPosition( stage_width/2, stage_height/2, stage_width, stage_height);
					break;
				default:
					trace("Unrecognized rainforest location received: "+rainforest_location);
			}	
		}
		
		
	}
}