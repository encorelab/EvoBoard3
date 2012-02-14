package
{
	//This is the evoboard application for step 1 of the evolution run in Feb 2012
	import classes.Cladogram;
	import classes.ConceptsDisplay;
	import classes.FeaturesDisplay;
	import classes.MeetupDisplay;
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	
	public class EvoBoard3 extends Sprite
	{
		private var screen_height:Number = 768;
		private var screen_width:Number = 1024;
		private var event_debug:TextField;
		private var version_num:TextField;
		
		private var cladogram:Cladogram;
		private var meetup:MeetupDisplay;		
		private var features:FeaturesDisplay;
		private var conceptsDisplay:ConceptsDisplay;
		
		private var _currentTeamSet:Array;
		
		public static var stage_width = 1024;
		public static var stage_height = 768;
		public static var colour_set:Array = [ 0x00FF99, 0x00CCFF, 0xFFCC66, 0x14A99D, 0x8EC447, 0x66FFFF ]; //green, blue, orange, teal, lime, aqua
		public static var team_set1:Array = ["Darwin", "Linneaus"];
		public static var team_set2:Array = ["Lamarck", "Wallace"];
		public static var team_set3:Array = ["Mendel", "Lyell"]; //"Fischer"
		public static var team_set4:Array = ["Malthus", "Huxley"]; //"Buffon", 
		
		public function EvoBoard3()
		{
			event_debug = event_debug_txt;
			event_debug.text = "Waiting for event...";		
			version_num = versionNum_txt;
			version_num.text = "Feb 14, 2012 v.1";
			ExternalInterface.addCallback("sevToFlash", handleSev);
						
			//for Day 1 - STEP1
			cladogram = new Cladogram();
			addChild( cladogram )
						
			//for Day 1 - STEP2
			meetup = new MeetupDisplay();
			addChild( meetup );
			
			//for Day 2 - STEP1
			features = new FeaturesDisplay();
			addChild( features );
			
			//for Day 2 - STEP2
			conceptsDisplay = new ConceptsDisplay();
			addChild( conceptsDisplay );
			
			cladogram.visible = false;
			meetup.visible = false;
			features.visible = false;
			conceptsDisplay.visible = false;
			
			stage.addEventListener( KeyboardEvent.KEY_DOWN, reportKeyDown );
		}		
		private function reportKeyDown( e:KeyboardEvent ):void
		{
			trace( "e.keyCode: "+e.keyCode );
			if (e.keyCode == 65){ //a
				//Day 1 - STEP1
				setChildIndex( cladogram, numChildren - 1 );
				cladogram.visible = true;
				meetup.visible = false;
				features.visible = false;
				conceptsDisplay.visible = false;
			} else if (e.keyCode == 83){ //s
				//Day 1 - STEP2
				setChildIndex( meetup, numChildren - 1 );
				cladogram.visible = false;
				meetup.visible = true;
				features.visible = false;
				conceptsDisplay.visible = false;				
			} else if (e.keyCode == 68){ //d
				//for Day 2 - STEP1 
				setChildIndex( conceptsDisplay, numChildren - 1 );
				cladogram.visible = false;
				meetup.visible = false;
				features.visible = true;
				conceptsDisplay.visible = false;
			} else if ( e.keyCode == 70){//f
				//for Day 2 - STEP2
				setChildIndex( conceptsDisplay, numChildren - 1 );
				cladogram.visible = false;
				meetup.visible = false;
				features.visible = false;
				conceptsDisplay.visible = true;
			} else if ( e.keyCode == 81 ){ //q
				//e.keyCode: 81
				//e.keyCode: 87
				//e.keyCode: 69
				//e.keyCode: 82
				//features.addEntry("Luis", "Darwin", "Luis", "foo");
				cladogram.addEntry("pug_the_funny_dog", "dog", "Darwin", "25 mya");
				//cladogram.addPresentEntry("Darwin", ["proboscis_monkey", "civet", "ant" ], "Borneo");
				//cladogram.addPresentEntry2("Darwin", [{"organism":"proboscis_monkey","is_present":"yes"},{"organism":"muellers_gibbon","is_present":"yes"},{"organism":"white_fronted_langur","is_present":"no"}], "Borneo");
				//meetup.addEntry( "Luis", "primates", "Linneaus", 1, "foo" );
			} else if ( e.keyCode == 87 ){
				cladogram.addEntry("pug_the_hilarious_dog", "dog", "Linneaus", "10 mya");
				//meetup.addEntry( "Amy", "plants_and_insects", "Darwin", 2, "poo" );
			}
		}
		//{"eventType":"organism_observation","payload":{"time":"200mya","assigned_organism":"proboscis_monkey", "observed_organism":"monkey","team_name":"Darwin"}}	
		private function organism_observation( eventData ):void 
		{
			event_debug.appendText("\n" + eventData.team_name + " identified " + eventData.observed_organism + "'s prescence as present");
			cladogram.addEntry(eventData.observed_organism, eventData.assigned_organism, eventData.team_name, eventData.time);
		}
		//{"eventType":"note", "payload":{"author":"Luis", "specialty":"primates", "team_name":"Darwin", "note":"foo"}}
		private function note( eventData ):void
		{
			//meetup":1
			event_debug.text = eventData.author + " of team " + eventData.team_name + " submitted a note entry for " + eventData.specialty + " during meetup # "+eventData.meetup;  
			meetup.addEntry( eventData.author, eventData.specialty, eventData.team_name, eventData.meetup, eventData.note );
		}
		//{"eventType":"observation_tabulation", "payload":{"team_name":"Luis", "location":"Borneo", "organism_presence":["fig", "civet", "ant" ]}}//
		private function observation_tabulation( eventData ):void
		{
			event_debug.appendText("\n" + eventData.team_name + " identified the presence of " + eventData.organism_presence + " in "+eventData.location +" as present");
			//{"eventType":"observation_tabulation","payload":{"team_name":"Darwin","location":"station_a","organism_presence":[{"organism":"proboscis_monkey","is_present":"yes"},{"organism":"muellers_gibbon","is_present":"yes"},{"organism":"white_fronted_langur","is_present":"no"}]}}
			cladogram.addPresentEntry( eventData.team_name, eventData.organism_presence, eventData.location );
		}
		//{"eventType":"note", "payload":{"author":"Luis", "organism":"civet", "team_name":"Darwin", "note":"foo"}}
		private function organism_features( eventData ):void
		{
			event_debug.text = eventData.author + " of team " + eventData.team_name + " submitted a note entry for " + eventData.organism + ": "+eventData.explanation;
			features.addEntry( eventData.author, eventData.team_name, eventData.organism, eventData.explanation );
		}
		private function concept_discussion( eventData ):void
		{
			event_debug.text = eventData.author + " submitted a concept entry for " + eventData.concept + " at " + eventData.time + " about " + eventData.organism;
			//author_name:String, evo_concept:String, tag_list:Array, explanation_text:String
			conceptsDisplay.addEntry( eventData.author, eventData.concept, eventData.time, eventData.organism, eventData.explanation );
		}
		private function handleSev(eventType, eventData):void 
		{
			trace(eventType);
			trace(eventData);
			event_debug.appendText("\n" +"eventType: "+ eventType);
			event_debug.appendText("\n" +"eventData: "+ eventData);
			
			switch(eventType) {
				// add handlers for events here (one for each type of event)
				case "organism_observation":
					organism_observation(eventData); 
					break;
				case "note":
					note(eventData); 
					break;
				case "observation_tabulation":
					observation_tabulation(eventData); 
					break;
				case "organism_features":
					organism_features(eventData); 
					break;
				case "concept_discussion":
					concept_discussion(eventData); 
					break;
				default:
					trace("Unrecognized event received: "+eventType);
			}
		}
		//EXAMPLE 1: CAN BE ERASED
		private function student_submitted_data(eventData) {
			// eventData is an object with arbitrary properties (Armin/Colin will define these)
			//event_debug.text = "Got 'student_submited_data'; foo is " + eventData.foo;
		}
		//EXAMPLE 2: CAN BE ERASED
		private function some_other_event(eventData) {
			// eventData is an object with arbitrary properties (Armin/Colin will define these)
			//event_debug.text = "Got 'some_other_event'; blah_blah is " + eventData.blah_blah + " and poop is " + eventData.poop;
		}
		//GETTER & SETTERS
		public function get currentTeamSet():Array {
			return _currentTeamSet;
		}
		public function set currentTeamSet( value:Array ):void {
			_currentTeamSet = value;
		}
		//STATIC FUNCTIONS
		public static function stripUnderscore( originalstring:String ):String
		{
			var original:Array = originalstring.split("_");
			return(original.join(" "));
		}
	}
}