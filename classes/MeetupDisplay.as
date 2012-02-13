package classes
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class MeetupDisplay extends Sprite
	{
		private var _meetupNum:Number = 1;
		private var background:MeetupGraphic;
		private var meetup1_notes:Array;
		private var meetup2_notes:Array;
		private var meetup1_display:Sprite;
		private var meetup2_display:Sprite;
		private var meetup1_btn:MovieClip
		private var meetup2_btn:MovieClip
		private var current_set:Array;
		private var team_toc:Array;
		private var sideNav:MovieClip;

		private var specialtyList:Array = ["birds", "other_mammals", "plants_and_insects", "primates"];
		private var x_pos:uint = 80;
		private var row_height = Math.floor( EvoBoard3.stage_height/4 );
		private var displayArea_width:Number = EvoBoard3.stage_width - 40;
		
		public function MeetupDisplay()
		{
			background = new MeetupGraphic();
			addChild( background );
			setupSideNav();
			setupArrays();
			meetup1_display = new Sprite();
			addChild( meetup1_display  );
			meetup2_display = new Sprite();
			addChild( meetup2_display  );
			gotoMeetup1();
		}
		public function addEntry( author:String, specialty:String, team_name:String, meetup:Number, explanation:String ):void
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
			if( meetup == 1 ){
				meetup1_display.addChild( noteEntry );
				meetup1_notes.push( noteEntry );
			} else if ( meetup == 2 ){
				meetup2_display.addChild( noteEntry );
				meetup2_notes.push( noteEntry );
			}
		}
		private function setupSideNav():void
		{
			sideNav = background.sideTab;
			sideNav.stop();
			meetup1_btn = sideNav.button1;
			meetup2_btn = sideNav.button2;
			meetup1_btn.addEventListener( MouseEvent.CLICK, gotoMeetup1 );
			meetup2_btn.addEventListener( MouseEvent.CLICK, gotoMeetup2 );
		}
		//same as in Cladogram class - refactor?
		private function setupArrays():void
		{
			team_toc = new Array();
			team_toc.push(EvoBoard3.team_set1);
			team_toc.push(EvoBoard3.team_set2);
			team_toc.push(EvoBoard3.team_set3);
			team_toc.push(EvoBoard3.team_set4);
			meetup1_notes = new Array();
			meetup2_notes = new Array();
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
		public function get meetupNum():uint {
			return _meetupNum;
		}
		public function set meetupNum( value:uint ):void {
			_meetupNum = value;
		}
		//HANDLERS
		private function gotoMeetup1( e:MouseEvent=null ):void {
			trace("gotoMeetup1");
			sideNav.gotoAndStop("meetup1");
			meetup1_btn.alpha = 0;
			meetup2_btn.alpha = 0;
			meetup1_display.visible = true;
			meetup2_display.visible = false;
			meetupNum = 1;
		}
		private function gotoMeetup2( e:MouseEvent=null ):void {
			trace("gotoMeetup2");
			sideNav.gotoAndStop("meetup2");
			meetup1_btn.alpha = 0;
			meetup2_btn.alpha = 0;
			meetup1_display.visible = false;
			meetup2_display.visible = true;
			meetupNum = 2;
		}
	}
}