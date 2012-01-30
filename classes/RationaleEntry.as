package classes
{
	import flash.display.Sprite;

	public class RationaleEntry extends Sprite
	{
		private var group:String;
		private var authorName:String;
		private var questionType:String;
		private var answer:String;
		
		private var pos1:Number = 176;
		private var pos2:Number = 390;
		private var pos3:Number = 608;
		private var pos4:Number = 822;
		private var strategy_pos:Number = 104;
		private var evidence_pos:Number = 328;
		private var additionalinfo_pos:Number = 554;
		
		private var rationaleEntryGraphic:RationaleEntryGraphic;
		
		//eventData.group_code, eventData.author, eventData.question, eventData.answer 
		public function RationaleEntry( group_num:String , author_name:String, question_text:String, answer_text:String )
		{
			group = group_num;
			authorName = author_name;
			questionType = question_text;
			answer = answer_text;
			
			rationaleEntryGraphic = new RationaleEntryGraphic();
			addChild( rationaleEntryGraphic );
			
			rationaleEntryGraphic.rationale_txt.text = answer;
			setPosition();
		}
		private function setPosition():void
		{
			switch( questionType ) {
				case "strategy":
					this.y = strategy_pos;
					break;
				case "evidence":
					this.y = evidence_pos;
					break;
				case "additional_info":
					this.y = additionalinfo_pos;
					break;
				default:
					trace("Unrecognized question type: "+ questionType);
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
	}
}