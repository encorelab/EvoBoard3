package classes
{
	public class EvoBoardStep2 extends EvoBoard
	{
		public function EvoBoardStep2()
		{
			super();
		}
		override public function setupEvoBoard():void{
			/*
			//for STEP1
			organism_vis = new OrganismVis();
			addChild( organism_vis );
			*/
			//for STEP2
			guess_table = new MeetupDisplay();
			addChild( guess_table );
			/*
			//for STEP4 ranking
			rank_table = new RankTable();
			//addChild( rank_table );
			
			//for STEP4 rationales
			rationale_table = new RationaleTable();
			//addChild( rationale_table );
			*/
		}
	}
}