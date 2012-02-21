package classes
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	
	public class Cladogram extends Sprite
	{	
		private var background:CladogramGraphic;
		private var organisms_200mya:Array;
		private var organisms_150mya:Array;
		private var organisms_100mya:Array;
		private var organisms_50mya:Array;
		private var organisms_25mya:Array;
		private var organisms_10mya:Array;
		private var organisms_5mya:Array;
		private var organisms_2mya:Array;
		private var organisms_present:Array;
		private var organisms_toc:Array;		
		
		//private var y_positions:Array = [0, 172, 344, 516, 688, 860, 1032, 1204, 1376, 1548];
		private var x_pos:uint = 80;
		//private var row_height = 172;
		private var row_height = 340;
		
		//green, blue, orange, aqua
		//private var colour_set:Array = [ 0x00FF99, 0x00CCFF, 0xFFCC66, 0x66FFFF ];		
		/*private var team_set1:Array = ["Darwin", "Linneaus"];
		private var team_set2:Array = ["Lamarck", "Wallace"];
		private var team_set3:Array = ["Mendel", "Lyell", "Fischer"];
		private var team_set4:Array = ["Buffon", "Malthus", "Huxley"];*/
		private var team_toc:Array;
		private var current_set:Array;
		
		private var movingTag:OrganismTag;
		private var connections_toc:Array;
		
		private var legend:LegendBox;
		private var scrollUpButton:MovieClip;
		private var scrollDownButton:MovieClip;
		
		private var tagHolder:Sprite;
		
		public function Cladogram()
		{
			trace("Cladogram instantiated");
			setupArrays();
			
			tagHolder = new Sprite();
			addChild( tagHolder );
			
			background = new CladogramGraphic();
			tagHolder.addChild( background );
			
			scrollUpButton = new SquareBox() as MovieClip;			
			addChild( scrollUpButton );
			scrollUpButton.x = EvoBoard3.stage_width - scrollUpButton.width - 10;
			scrollUpButton.y = 10;
			scrollUpButton.alpha = 0.2;
			scrollUpButton.addEventListener( MouseEvent.CLICK, handleScrollUpButton );
			//formatColour( scrollUpButton, 0x000000 );
			
			scrollDownButton = new SquareBox() as MovieClip;
			addChild( scrollDownButton );
			scrollDownButton.x = EvoBoard3.stage_width - scrollDownButton.width - 10;
			scrollDownButton.y = 10 + scrollUpButton.height + 10;
			scrollDownButton.alpha = 0.2;
			scrollDownButton.addEventListener( MouseEvent.CLICK, handleScrollDownButton );
			//formatColour( scrollDownButton, 0x000000 );
		}
		public function addPresentEntry( team_name:String, organisms:Array, rainforest:String ):void
		{
			for( var i:uint = 0; i < organisms.length; i++ ){
				if( organisms[i].is_present == "yes"){					
					addEntry( organisms[i].organism, organisms[i].organism, team_name, "present", rainforest );
				}
			}
		}
		public function addEntry( organism_name:String, assigned_organism:String, team_name:String, time_location:String, rain_forest:String="none"):void
		{
			trace( "current_set: "+current_set );
			if ( !current_set ){
				getCurrentSet( team_name );
				legend = new LegendBox( current_set, true );
				addChild( legend );
				legend.x = EvoBoard3.stage_width - legend.width;
				setChildIndex(legend, 0);
			}
			var organism_list:Array = getOrgArray( time_location );
			var tag_present:Boolean = false;
			
			for ( var i:uint = 0; i < organism_list.length; i++ ){
				if ( organism_name == organism_list[i].organismName ){
					//tag present already, find out team combo, change colour
					//if team name is the same then don't change, if team name is different then change
					//trace( organism_list[i].authorName.indexOf(team_name) );
					if ( organism_list[i].authorName.indexOf(team_name) == -1){  
						organism_list[i].addAuthor( team_name, getColor( team_name, organism_list[i]));
					}
					if ( organism_list[i].rainforest != rain_forest ){
						organism_list[i].addRainforest( rain_forest );
					}
					organism_list[i].addAssignedOrg( assigned_organism );
					setupConnection( organism_list[i], assigned_organism, team_name, time_location );
					tag_present = true;
				}
			}
			if ( !tag_present && organism_name != "none"){
				addTag( organism_name, assigned_organism, team_name, time_location, rain_forest );
			}
		}
		private function addTag(organism_name:String, assigned_organism:String, team_name:String, time_location:String, rain_forest:String):void
		{
			trace("addTag");
			var orgTag:OrganismTag = new OrganismTag( organism_name, assigned_organism, team_name, time_location, rain_forest );
			tagHolder.addChild( orgTag );
			
			orgTag.addEventListener(MouseEvent.MOUSE_DOWN, handleClick);
			orgTag.addEventListener(MouseEvent.MOUSE_UP, handleRelease);
			
			for ( var i:uint=0; i< organisms_toc.length; i++){
				if ( time_location == organisms_toc[i].time ){
					organisms_toc[i].list.push( orgTag );
					//( x_value:Number, y_value:Number, width_value:Number, height_value:Number)
					orgTag.setBoundaries( 0, row_height*i, EvoBoard3.stage_width, row_height);
					//( lowX:Number, lowY:Number, highX:Number, highY:Number )
					orgTag.setPosition( x_pos, row_height*i, EvoBoard3.stage_width, row_height*(i+1));
				}
			}
			orgTag.formatColour( getColor(team_name) );
			setupConnection( orgTag, assigned_organism, team_name, time_location );
		}
		//finds out if there's a organism tag thats is related across time periods and draws a line between them
		private function setupConnection( new_ot:OrganismTag, assigned_organism:String, team_name:String, time_location:String ):void
		{
			for ( var i:uint=0; i< organisms_toc.length; i++){				
				if ( time_location == organisms_toc[i].time ){
					//trace("i: "+i);
					//check if any of the older time has an assigned org the same as newOT
					//if we're at 200mya, then there is no older time period
					if ( (i + 1) < organisms_toc.length ){
						//trace("older time: "+organisms_toc[i+1].time);
						var older_organism_list:Array = organisms_toc[i+1].list;
						drawConnections( older_organism_list, new_ot, assigned_organism, team_name );
					}
					//check if any of the tags in the new time has an assigned org the same as newOT
					if ( (i - 1) >= 0 ){
						//trace("newer time: "+organisms_toc[i-1].time);
						var newer_organism_list:Array = organisms_toc[i-1].list;
						drawConnections( newer_organism_list, new_ot, assigned_organism, team_name );
					}
				}				
			}
		}
		private function drawConnections( existing_orgList:Array, new_ot:OrganismTag, assigned_organism:String, team_name:String ):void
		{
			for ( var j:uint = 0; j < existing_orgList.length; j++ ){
				var old_ot:OrganismTag = existing_orgList[j];
				for ( var k:uint = 0; k < old_ot.assignedOrganisms.length; k++){
					if( assigned_organism == old_ot.assignedOrganisms[k] ){
						//check if it's the same team author
						if ( old_ot.authorName.indexOf(team_name) != -1){  
							//find out if there's already a line between old_ot and new_ot
							trace( "existing connection?: " + checkExistingConnection( old_ot, new_ot ) );
							if ( !checkExistingConnection( old_ot, new_ot ) ){
								//set up line between the 2 items
								trace("set up line")							
								var connection = new Connection( old_ot, new_ot );
								tagHolder.addChild( connection );
								tagHolder.setChildIndex( connection, 0 );
								old_ot.addConnection( connection );
								new_ot.addConnection( connection );
								connections_toc.push( connection );
							}
						}
					}
				}
			}
		}
		private function checkExistingConnection( ot1:OrganismTag, ot2:OrganismTag ):Boolean
		{
			var flag:Boolean = false;
			for ( var i:uint = 0; i < connections_toc.length; i++ ){
				if ( connections_toc[i].checkConnection( ot1, ot2 ) ){
					//there is a match
					flag = true
				}
			}
			return flag;
		}
		private function setupArrays():void
		{
			organisms_200mya = new Array();
			organisms_150mya = new Array();
			organisms_100mya = new Array();
			organisms_50mya = new Array();
			organisms_25mya = new Array();
			organisms_10mya = new Array();
			organisms_5mya = new Array();
			organisms_2mya = new Array();
			organisms_present = new Array();
			organisms_toc = new Array();
			organisms_toc.push({time:"present", list:organisms_present});
			organisms_toc.push({time:"2 mya", list:organisms_2mya});
			organisms_toc.push({time:"5 mya", list:organisms_5mya});
			organisms_toc.push({time:"10 mya", list:organisms_10mya});
			organisms_toc.push({time:"25 mya", list:organisms_25mya});
			organisms_toc.push({time:"50 mya", list:organisms_50mya});
			organisms_toc.push({time:"100 mya", list:organisms_100mya});
			organisms_toc.push({time:"150 mya", list:organisms_150mya});
			organisms_toc.push({time:"200 mya", list:organisms_200mya});
			team_toc = new Array();
			team_toc.push(EvoBoard3.team_set1);
			team_toc.push(EvoBoard3.team_set2);
			team_toc.push(EvoBoard3.team_set3);
			team_toc.push(EvoBoard3.team_set4);
			connections_toc = new Array();
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
		//returns the organisms array based on time (e.g. 200mya)
		private function getOrgArray( time_location:String ):Array
		{
			var org_list:Array;
			for ( var i:uint=0; i< organisms_toc.length; i++){
				if ( time_location == organisms_toc[i].time ){
					org_list = organisms_toc[i].list;
				}
			}
			return org_list;
		}
		//returns the colour the tag should be based on the teams contributing to the tag
		private function getColor( team:String, organism_tag=null ):uint
		{			
			var colour:uint = 0xFFFFFF;
			for( var i:uint = 0; i < current_set.length; i++ ){
				if ( current_set[i] == team ){
					if ( !organism_tag ){
						//new colour
						colour = EvoBoard3.colour_set[i];
					} else {
						//combo colour
						colour = EvoBoard3.colour_set[current_set.length];
					}
				}
			}
			return colour;
		}
		//EVENT HANDLERS
		private function handleClick( e:MouseEvent ):void
		{
			//trace("e.target.parent.parent: "+e.target.parent.parent);
			var node = e.target.parent.parent as OrganismTag; 
			movingTag = node;
			node.startDrag( false, node.boundsRectangle );
			//find connections linked to node and update connection
			var links:Array = node.connections;
			if( links.length > 0 ){
				for ( var i:uint=0; i< links.length; i++){
					//trace( "links["+i+"]"+links[i] );
					links[i].moveNode( node );
				}
				stage.addEventListener( MouseEvent.MOUSE_MOVE, handleMove );
			}
		}
		private function handleRelease( e:MouseEvent ):void
		{
			var node = e.target.parent.parent as OrganismTag;
			node.stopDrag();
			//find connections linked to node and update connection
			var links:Array = node.connections;
			if( links.length > 0 ){
				for ( var i:uint=0; i< links.length; i++){
					//trace( "links["+i+"]"+links[i] );
					//links[i].drawLine();
					links[i].stopNode( node );
				}
				stage.removeEventListener( MouseEvent.MOUSE_MOVE, handleMove );
			}
			movingTag = null;
		}
		private function handleMove( e:MouseEvent ):void
		{
			var links:Array = movingTag.connections;
			if( links.length > 0 ){
				for ( var i:uint=0; i< links.length; i++){
					//trace( "links["+i+"]"+links[i] );
					links[i].drawLine();
				}
			}
			e.updateAfterEvent();
		}private function handleScrollUpButton( e:MouseEvent ):void
		{
			trace("move up");
			var y_constant:Number = 300;
			var myTween:Tween = new Tween(tagHolder, "y", Strong.easeOut, tagHolder.y, tagHolder.y + y_constant, 1, true );
			//tagHolder.y += 50;
		}
		private function handleScrollDownButton( e:MouseEvent ):void
		{
			trace("move down");
			//tagHolder.y -= 50;
			var y_constant:Number = 300;
			var myTween:Tween = new Tween(tagHolder, "y", Strong.easeOut, tagHolder.y, tagHolder.y - y_constant, 1, true );
		}
		public function formatColour( mc:MovieClip, new_color:uint=0xFFFFFF ):void
		{
			var myColor:ColorTransform = mc.transform.colorTransform;
			myColor.color = new_color;
			mc.transform.colorTransform = myColor;
		}
	}
}