package classes
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class MeetupDisplay extends Sprite
	{
		private var background:MeetupGraphic;
		private var notes:Array;
		private var current_set:Array;
		private var team_toc:Array;

		private var specialtyList:Array = ["birds", "other_mammals", "plants_and_insects", "primates"];
		private var x_pos:uint = 80;
		private var row_height = Math.floor( EvoBoard3.stage_height/4 );
		
		
		public function MeetupDisplay()
		{
			background = new MeetupGraphic();
			addChild( background );
			setupArrays();
		}
		public function addEntry( author:String, specialty:String, team_name:String, explanation:String ):void
		{				
			trace( "current_set: "+current_set );
			if ( !current_set ){
				getCurrentSet( team_name );
			}
			var noteEntry:NoteEntry = new NoteEntry( author, specialty, getColor( team_name ), explanation );
			for ( var i:uint=0; i< specialtyList.length; i++){
				if ( specialty == specialtyList[i] ){
					//( x_value:Number, y_value:Number, width_value:Number, height_value:Number)
					noteEntry.setBoundaries( 0, (row_height*i), EvoBoard3.stage_width, row_height);
					//( lowX:Number, lowY:Number, highX:Number, highY:Number )
					noteEntry.setPosition( x_pos, (row_height*i), EvoBoard3.stage_width, (row_height*(i+1)));
				}
			}
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
	}
}