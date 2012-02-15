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
			tagHolder.x = EvoBoard3.stage_width - 170 + 10;
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

			if ( timeTags.length < 1 ){
				for ( var i:uint = 0; i < time_list.length; i++ ){
					//add Tag
					var timebutton:TagButton = new TagButton( time_list[i] );
					timeHolder.addChild( timebutton );
					timebutton.addEventListener( CustomEvent.CLICK, handleTagBtnClick );
					timeTags.push( timebutton );
					timebutton.y = timeTags.length * 20; 
				}		
			} else {
				checkTags( time_list, timeTags, timeHolder );
			}
			
			if ( organismTags.length < 1 ){
				for ( var j:uint = 0; j < org_list.length; j++ ){
					//add Tag
					var tagbutton:TagButton = new TagButton( org_list[j] );
					tagHolder.addChild( tagbutton );
					tagbutton.addEventListener( CustomEvent.CLICK, handleTagBtnClick );
					organismTags.push( tagbutton );
					tagbutton.y = organismTags.length * 20;
				}		
			} else {
				checkTags( org_list, organismTags, tagHolder );
			}
			//tagHolder.y = timeHolder.height + 10;
		}
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
						var tagbutton:TagButton = new TagButton( newTagName );
						holder.addChild( tagbutton );
						tagbutton.addEventListener( CustomEvent.CLICK, handleTagBtnClick );
						old_list.push( tagbutton );	
						tagbutton.y = old_list.length * 20;
				}
			}
			//tagHolder.y = timeHolder.height + 10;
		}
		private function addTag():void{
			///think about refactoring above code to this function, not worrying about it now
		}
		private function setupSideNav():void
		{
			sideBkgd = new Sprite();
			addChild( sideBkgd );
			sideBkgd.graphics.beginFill( 0x000000 );
			sideBkgd.graphics.drawRect( 0, 0, nav_width, EvoBoard3.stage_height );
			sideBkgd.graphics.endFill();
			sideBkgd.alpha = 0.5;
			sideBkgd.x = EvoBoard3.stage_width - sideBkgd.width;
		}
		
		private function handleConceptClick( e:CustomEvent ):void
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
			trace("click: "+ e.customObject);
			trace( "tag btn click: "+ e.customObject );
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