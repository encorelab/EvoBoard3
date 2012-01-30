package classes
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;

	public class TableEntry extends Sprite
	{
		private var group:String;
		private var rainforest:String;
		private var is_your_rainforest:String;
		private var explanation:String;
		
		private var pos1:Number = 290;
		private var pos2:Number = 472;
		private var pos3:Number = 656;
		private var pos4:Number = 836;
		private var posA:Number = 168;
		private var posB:Number = 328;
		private var posC:Number = 488;
		private var posD:Number = 648;
		
		private var tableEntryGraphic:TableEntryGraphic;
		private var explanationGraphic:ExplanationGraphic;
		private var explanationObject:Sprite;
		private var closeButton:CloseButton;
		
		public function TableEntry( group_num:String , rainforest_location:String, your_rainforest:String, explanation_text:String="blank" )
		{
			group = group_num;
			rainforest = rainforest_location;
			is_your_rainforest = your_rainforest;
			explanation = explanation_text;
			
			tableEntryGraphic = new TableEntryGraphic();
			addChild( tableEntryGraphic );
			
			tableEntryGraphic.guess_txt.text = is_your_rainforest;
			setPosition();
			
			if(explanation != "blank"){ 
				setupExplanation();
				tableEntryGraphic.addEventListener(MouseEvent.MOUSE_DOWN, onGuessClick )
			}
		}
		private function setupExplanation():void
		{
			explanationObject = new Sprite();
			addChild( explanationObject );
			hideExplanation();
			
			explanationGraphic = new ExplanationGraphic();
			explanationGraphic.explanation_txt.multiline = true;
			explanationGraphic.explanation_txt.autoSize = TextFieldAutoSize.LEFT;
			explanationGraphic.explanation_txt.text = explanation;
			
			explanationGraphic.explanation_txt.height = explanationGraphic.explanation_txt.textHeight + 8;
			explanationGraphic.bkgd.height = explanationGraphic.explanation_txt.height + 16;
			
			explanationGraphic.explanation_txt.width = explanationGraphic.explanation_txt.textWidth + 8;
			explanationGraphic.bkgd.width = explanationGraphic.explanation_txt.width + 16;
						
			explanationObject.addChild( explanationGraphic );
			
			closeButton = new CloseButton( explanationGraphic.width, 0 );
			explanationObject.addChild( closeButton );
			closeButton.addEventListener(CustomEvent.CLOSE, closeBtnHandler);
			
			explanationObject.addEventListener(MouseEvent.MOUSE_DOWN, clickHandler);
			explanationObject.addEventListener(MouseEvent.MOUSE_UP, mouseupHandler);
			
		}
		private function closeBtnHandler(e:CustomEvent):void
		{
			//hide explanation object
			hideExplanation();
		}
		private function onGuessClick( e:MouseEvent ):void
		{
			showExplanation();
		}
		private function hideExplanation():void
		{
			explanationObject.visible = false;
		}
		private function showExplanation():void
		{
			explanationObject.visible = true;
		}
		private function setPosition():void
		{
			switch( rainforest ) {
				case "rainforest_a":
					this.y = posA;
					break;
				case "rainforest_b":
					this.y = posB;
					break;
				case "rainforest_c":
					this.y = posC;
					break;
				case "rainforest_d":
					this.y = posD;
					break;
				default:
					trace("Unrecognized rainforest location received: "+rainforest);
			}		
			switch( group ) {
				case "1":
					this.x = pos1;
					break;
				case "2":
					this.x = pos2;
					break;
				case "3":
					this.x = pos3;
					break;
				case "4":
					this.x = pos4;
					break;
				default:
					trace("Unrecognized group received: "+ group);
			}		
		}
		private function clickHandler( e:MouseEvent ):void
		{
			explanationObject.startDrag();
		}
		private function mouseupHandler( e:MouseEvent ):void
		{
			explanationObject.stopDrag();
		}
	}
}