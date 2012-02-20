package classes
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class ConceptsDisplay extends Sprite
	{
		private var background:ConceptsGraphic;
		private var notes:Array;
		private var xpos:uint = 0;
		private var ypos:uint = 50;
		
		private var sideNav:Sprite;
		private var sideBkgd:Sprite;
		private var tagHolder:Sprite;
		private var timeHolder:Sprite;
		private var tagsTF:TextField;		
		private var nav_width:uint = 230;
		private var top_margin:uint = 50;
		
		private var organismTags:Array;
		private var timeTags:Array;
		
		private var resetButton:MovieClip;
		
		public function ConceptsDisplay()
		{
			trace("Instantiate ConceptsDisplay");
			background = new ConceptsGraphic();
			addChild( background );
			
			notes = new Array();
			organismTags = new Array();
			timeTags = new Array();
			
			setupSideNav();
			
			timeHolder = new Sprite();
			timeHolder.x = EvoBoard3.stage_width - nav_width + 10;
			timeHolder.y = top_margin;
			addChild( timeHolder );
			
			tagHolder = new Sprite();
			tagHolder.x = EvoBoard3.stage_width - 160 + 10;
			tagHolder.y = top_margin;
			addChild( tagHolder );
			
			resetButton = new SquareBox() as MovieClip;			
			addChild( resetButton );
			resetButton.x = EvoBoard3.stage_width - resetButton.width - 10;
			resetButton.y = 10;
			resetButton.alpha = 0.2;
			resetButton.addEventListener( MouseEvent.CLICK, handleResetButton );
		}
		public function addEntry( author:String, evo_concept:String, time_list:Array, org_list:Array, explanation:String ):void
		{	
			var entry:ConceptsEntry = new ConceptsEntry( author, evo_concept, getConceptColour( evo_concept ), time_list, org_list, explanation );
			entry.setPosition( xpos, ypos, EvoBoard3.stage_width, EvoBoard3.stage_height );
			addChild( entry );
			notes.push( entry );
			
			//if there are no timeTags, add all of the tags in this entry 
			if ( timeTags.length < 1 ){
				for ( var i:uint = 0; i < time_list.length; i++ ){
					//add Tag
					addTag( timeHolder, timeTags, time_list[i]); 
				}		
			} else {
				checkTags( time_list, timeTags, timeHolder );
			}
			
			//if there are no organismTags, add all of the tags in this entry 
			if ( organismTags.length < 1 ){
				for ( var j:uint = 0; j < org_list.length; j++ ){
					//add Tag
					addTag( tagHolder, organismTags, org_list[j]);
				}		
			} else {
				checkTags( org_list, organismTags, tagHolder );
			}
		}
		//check to see if the new tags are already in the list, if not, adds it
		private function checkTags( new_list:Array, old_list:Array, holder:Sprite ):void{
			for ( var i:uint = 0; i < new_list.length; i++ ){
				var newTagName:String = new_list[i];
				
				var flag:Boolean = false;
				
				for ( var j:uint = 0; j < old_list.length; j++ ){
					//trace("new_list["+i+"]: "+new_list[i] + "; old_list["+j+"]: "+old_list[j].tagLabel);
					if ( newTagName == old_list[j].tagLabel ){
						//tag present already
						trace("tag present");
						flag = true;
					} 
				}
				if ( !flag ){
						//add tag
						trace("add tag");
						addTag( holder, old_list, newTagName );
				}
			}
		}
		private function addTag( holder:Sprite, old_list:Array, newTagName:String ):void{
			var tagbutton:TagButton = new TagButton( newTagName );
			holder.addChild( tagbutton );
			tagbutton.addEventListener( CustomEvent.CLICK, handleTagBtnClick );
			old_list.push( tagbutton );	
			tagbutton.y = old_list.length * 20;
			if ( old_list == organismTags ){
				sortTagsAlphabetically( holder, old_list );
			} else if ( old_list == timeTags ) {
				sortTagsNumerically( holder, old_list );
			}
			updateSideNav();
		}
		private function sortTagsAlphabetically( buttonHolder:Sprite, oldArray:Array ):void
		{
			var buttonNames:Array = new Array();
			var newArray:Array = new Array();
			var	numButtons:uint = buttonHolder.numChildren;
			for ( var i:uint = 0; i < numButtons; i++ ){
				buttonHolder.removeChildAt( buttonHolder.numChildren-1 );	
			}
			trace( "buttonHolder.numChildren: "+buttonHolder.numChildren );
			
			for ( var j:uint = 0; j < oldArray.length; j++ ){
				buttonNames.push( oldArray[j].tagLabel );
			}
			buttonNames.sort();
			for ( var k:uint = 0; k < buttonNames.length; k++ ){
				for ( var l:uint = 0; l < oldArray.length; l++ ){
					if ( buttonNames[k] == oldArray[l].tagLabel ){
						trace( "buttonNames["+k+"]: "+buttonNames[k] );
						newArray.push( oldArray[l] );
						buttonHolder.addChild( oldArray[l] );
						oldArray[l].y = k * 20;
					}
				}
			}
			oldArray = newArray;
		}
		private function sortTagsNumerically( buttonHolder:Sprite, oldArray:Array ):void
		{
			var buttonNames:Array = new Array();
			var newArray:Array = new Array();
			var	numButtons:uint = buttonHolder.numChildren;
			for ( var i:uint = 0; i < numButtons; i++ ){
				buttonHolder.removeChildAt( buttonHolder.numChildren-1 );	
			}
			trace( "buttonHolder.numChildren: "+buttonHolder.numChildren );
			
			for ( var j:uint = 0; j < EvoBoard3.time_set.length; j++ ){
				for ( var k:uint = 0; k < oldArray.length; k++ ){
					if( EvoBoard3.time_set[j] == oldArray[k].tagLabel ){
						buttonNames.push( oldArray[k].tagLabel );	
					}
				}	
			}
			for ( var l:uint = 0; l < buttonNames.length; l++ ){
				for ( var m:uint = 0; m < oldArray.length; m++ ){
					if ( buttonNames[l] == oldArray[m].tagLabel ){
						trace( "buttonNames["+l+"]: "+buttonNames[l] );
						newArray.push( oldArray[m] );
						buttonHolder.addChild( oldArray[m] );
						oldArray[m].y = l * 20;
					}
				}
			}
			oldArray = newArray;
		}
		private function setupSideNav():void
		{
			sideBkgd = new Sprite();
			addChild( sideBkgd );
			sideBkgd.graphics.beginFill( 0x000000 );
			sideBkgd.graphics.drawRect( 0, 0, 40, EvoBoard3.stage_height );
			sideBkgd.graphics.endFill();
			sideBkgd.alpha = 0.5;
			sideBkgd.x = EvoBoard3.stage_width - sideBkgd.width;
		}
		private function updateSideNav():void
		{
			tagHolder.x = EvoBoard3.stage_width - tagHolder.width - 10;
			timeHolder.x = EvoBoard3.stage_width - tagHolder.width - timeHolder.width - 10 - 10;
			sideBkgd.width = EvoBoard3.stage_width - timeHolder.x + 10;
			sideBkgd.x = EvoBoard3.stage_width - sideBkgd.width;
		}
		private function handleConceptClick( e:CustomEvent ):void
		{
			//trace( "organism click: "+ e.customObject );
			var targetOrg:String = e.customObject.toString();
			for ( var i:uint=0; i < notes.length; i++ ){
				if ( notes[i].organism == targetOrg ){
					notes[i].alpha = 1;
				} else {
					notes[i].alpha = 0.5;
				}
			}
		}
		private function getConceptColour( concept:String ):uint
		{
			var concept_colour:uint = 0xFFFFFF;
			for ( var i:uint=0; i < EvoBoard3.concept_list.length; i++ )
			{
				if ( concept == EvoBoard3.concept_list[i] ){
					concept_colour = EvoBoard3.concept_colours[i];		
				}
			}
			return concept_colour;
		}
		private function handleTagBtnClick( e:CustomEvent ):void
		{
			//trace("click: "+ e.customObject);
			//trace( "tag btn click: "+ e.customObject );
			var targetOrg:String = e.customObject.toString();
			for ( var i:uint=0; i < notes.length; i++ ){
				if ( notes[i].tagMatch( targetOrg ) ){
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