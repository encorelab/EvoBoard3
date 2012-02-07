package
{
	//This is the evoboard application for step 1 of the evolution run in Feb 2012
	import classes.Cladogram;
	import classes.MeetupDisplay;
	import classes.ConceptsDisplay;
	//import classes.OrganismTag;
	//import classes.RankTable;
	//import classes.RationaleTable;
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	
	//import flare.data.DataSource;
	
	public class EvoBoard3 extends Sprite
	{
		private var screen_height:Number = 768;
		private var screen_width:Number = 1024;
		private var event_debug:TextField;
		private var version_num:TextField;
		
		private var cladogram:Cladogram;
		private var meetup:MeetupDisplay;		
		private var conceptsDisplay:ConceptsDisplay;
		
		private var _currentTeamSet:Array;
		
		public static  var stage_width = 1024;
		public static var stage_height = 768;
		public static var colour_set:Array = [ 0x00FF99, 0x00CCFF, 0xFFCC66, 0x66FFFF ]; //green, blue, orange, aqua
		public static var team_set1:Array = ["Darwin", "Linneaus"];
		public static var team_set2:Array = ["Lamarck", "Wallace"];
		public static var team_set3:Array = ["Mendel", "Lyell", "Fischer"];
		public static var team_set4:Array = ["Buffon", "Malthus", "Huxley"];
		
		public function EvoBoard3()
		{
			event_debug = event_debug_txt;
			event_debug.text = "Waiting for event...";		
			version_num = versionNum_txt;
			version_num.text = "test 04";
			ExternalInterface.addCallback("sevToFlash", handleSev);
						
			//for Day 1 - STEP1
			cladogram = new Cladogram();
			addChild( cladogram )
						
			//for Day 1 - STEP2
			meetup = new MeetupDisplay();
			addChild( meetup );
			
			//for Day 2 - STEP2
			conceptsDisplay = new ConceptsDisplay();
			addChild( conceptsDisplay );
			
			cladogram.visible = false;
			meetup.visible = false;
			conceptsDisplay.visible = false;
			
			stage.addEventListener( KeyboardEvent.KEY_DOWN, reportKeyDown );
		}		
		private function reportKeyDown( e:KeyboardEvent ):void
		{
			if (e.keyCode == 65){ //a
				//{"eventType":"organism_observation","payload":{"location":"200mya","organism":"monkey","team":"darwin"}}
				//cladogram.addEntry("old monkey", "proboscis monkey", "Darwin", "200mya");
				//cladogram.addEntry("old monkey", "proboscis monkey", "Darwin", "50mya");
				//meetup.addEntry( "Luis", "primates", "Darwin", "foo" );
				
				//Day 1 - STEP1
				setChildIndex( cladogram, numChildren - 1 );
				cladogram.visible = true;
				meetup.visible = false;
				conceptsDisplay.visible = false;
			} else if (e.keyCode == 83){ //s
				//{"eventType":"organism_observation","payload":{"location":"200mya","organism":"monkey","team":"Linneaus"}}
				//cladogram.addEntry("monkey", "proboscis monkey", "Linneaus", "200mya");
				//cladogram.addEntry("monkey", "proboscis monkey", "Linneaus", "25mya");
				//meetup.addEntry( "Amy", "plants_and_insects", "Linneaus", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vel aliquam ligula. Maecenas vestibulum laoreet semper. Fusce imperdiet dapibus eros non vulputate. Mauris suscipit, lectus eu imperdiet facilisis, eros eros vehicula ipsum, a tincidunt augue massa a lacus. Aliquam egestas, massa vitae pretium gravida, mauris ligula interdum elit, et aliquet nunc urna vel orci. Aliquam vel libero orci, eu scelerisque augue. Phasellus vel arcu non sapien fringilla consectetur sit amet non est. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. In molestie tincidunt urna sit amet venenatis. Quisque mollis justo sed nisi bibendum ornare. Fusce diam enim, tincidunt nec dignissim ac, venenatis sed dolor. Morbi lacus ligula, laoreet et commodo eget, tempus id lectus. Nam vestibulum viverra odio, semper aliquet urna venenatis sit amet." );
				
				//Day 1 - STEP2
				setChildIndex( meetup, numChildren - 1 );
				cladogram.visible = false;
				meetup.visible = true;
				conceptsDisplay.visible = false;				
			} else if (e.keyCode == 68){ //d
				//cladogram.addEntry("monkey", "proboscis monkey", "Darwin", "150mya");
				//cladogram.addEntry("monkey", "proboscis monkey", "Darwin", "5mya");
				
				//for Day 2 - STEP2
				setChildIndex( conceptsDisplay, numChildren - 1 );
				cladogram.visible = false;
				meetup.visible = false;
				conceptsDisplay.visible = true;
			} else if ( e.keyCode == 70){//f
				//cladogram.addEntry("monkey", "proboscis monkey", "Darwin", "100mya");
				//cladogram.addEntry("monkey", "proboscis monkey", "Darwin", "2mya");
				conceptsDisplay.addEntry( "Jay", "Founder's effect", ["200mya"], "foo" );
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
			event_debug.text = eventData.author + " of team " + eventData.team_name + " submitted a note entry for " + eventData.specialty;  
			meetup.addEntry( eventData.author, eventData.specialty, eventData.team_name, eventData.explanation );
		}
		//{"eventType":"organism_observation","payload":{"assigned_organism":"proboscis_monkey","team_name":"Darwin","rainforest":"borneo"}}
		private function observation_tabulation( eventData ):void
		{
			event_debug.appendText("\n" + eventData.team_name + " identified " + eventData.observed_organism + "'s prescence "+"in "+eventData.rainforest +" as present");
			cladogram.addEntry( eventData.assigned_organism, eventData.assigned_organism, eventData.team_name, "present", eventData.rainforest );
		}
		
		private function concept_discussion( eventData ):void
		{
			event_debug.text = eventData.author + " submitted a concept entry for " + eventData.concept;
			//author_name:String, evo_concept:String, tag_list:Array, explanation_text:String
			conceptsDisplay.addEntry( eventData.author, eventData.concept, eventData.tag_list, eventData.explanation );
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
	}
}