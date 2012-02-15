package classes
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class FeaturesDisplay extends MovieClip
	{
		private var background:FeaturesGraphic;
		private var notes:Array;
		private var current_set:Array;
		private var team_toc:Array;
		private var resetButton:MovieClip;
		
		private var xpos:uint = 0;
		private var ypos:uint = 50;
		
		public function FeaturesDisplay()
		{
			background = new FeaturesGraphic();
			addChild( background );
			setupArrays();
			
			resetButton = new SquareBox() as MovieClip;			
			addChild( resetButton );
			resetButton.x = EvoBoard3.stage_width - resetButton.width - 10;
			resetButton.y = 10;
			resetButton.alpha = 0.2;
			resetButton.addEventListener( MouseEvent.CLICK, handleResetButton );
			//EvoBoard3.formatColour( resetButton, 0x000000 );
		}
		public function addEntry( author:String, team_name:String, organism:String, explanation:String ):void
		{				
			if ( !current_set ){
				getCurrentSet( team_name );
			}
			trace( "current_set: "+current_set );
			var noteEntry:FeaturesEntry = new FeaturesEntry ( author, organism, getColor( team_name ), explanation );
			noteEntry.setPosition( xpos, ypos, EvoBoard3.stage_width, EvoBoard3.stage_height );
			noteEntry.addEventListener( CustomEvent.CLICK, handleOrganismClick );
			addChild( noteEntry );
			notes.push( noteEntry );
		}
		//same as in Cladogram class - refactor?
		private function setupArrays():void
		{
			team_toc = new Array();
			team_toc.push(EvoBoard3.team_set1);
			team_toc.push(EvoBoard3.team_set2);
			team_toc.push(EvoBoard3.team_set3);
			team_toc.push(EvoBoard3.team_set4);
			notes = new Array();
		}
		private function getCurrentSet( team:String ):void
		{
			for( var i:uint = 0; i < team_toc.length; i++ ){
				var team_set:Array = team_toc[i];
				for ( var j:uint = 0; j < team_set.length; j++ ){
					if ( team == team_set[j] ){
						current_set = team_set;
					}
				}
			}
		}
		//returns the colour the tag should be based on the teams contributing to the tag
		private function getColor( team:String ):uint
		{			
			var colour:uint;
			for( var i:uint = 0; i < current_set.length; i++ ){
				if ( current_set[i] == team ){
					colour = EvoBoard3.colour_set[i];
				}
			}
			return colour;
		}
		private function handleOrganismClick( e:CustomEvent ):void
		{
			trace( "organism click: "+ e.customObject );
			var targetOrg:String = e.customObject.toString();
			for ( var i:uint=0; i < notes.length; i++ ){
				if ( notes[i].organism == targetOrg ){
					notes[i].alpha = 1;
				} else {
					notes[i].alpha = 0.5;
				}
			}
		}
		private function handleResetButton( e:MouseEvent ):void 
		{
			for ( var i:uint=0; i < notes.length; i++ ){
				notes[i].alpha = 1;
			}
		}
	}
}