class AGN_Rx_PRI extends Rx_PRI;

function SetChar(class<Rx_FamilyInfo> newFamily, Pawn pawn, optional bool isFreeClass)
{
   local Rx_Pawn rxPawn;

   bIsSpy = false;

	if (newFamily != none )
	{
		CharClassInfo = newFamily;
	} 
	else
	{
		return;
	}
	
	if((WorldInfo.NetMode == NM_ListenServer && RemoteRole == ROLE_SimulatedProxy) || WorldInfo.NetMode == NM_Standalone )
	{
		UpdateCharClassInfo();
	} else if(newFamily != None) {
		`log("setting pawn " @ pawn @ "Character info to" @ newFamily); 
		Rx_Pawn(pawn).SetCharacterClassFromInfo(newFamily);
	}

	if(WorldInfo.GetGameClass() == Class'Rx_Game')
	{
		if( self.CharClassInfo == class'AGN_FamilyInfo_Nod_StealthBlackHand' )
		{
			if(Rx_Controller(Owner) != none)
				Rx_Controller(Owner).ChangeToSBH(true);
			else if(Rx_Bot(Owner) != none)
				Rx_Bot(Owner).ChangeToSBH(true);
		}
		else
		{
			if(Rx_Controller(Owner) != none)
				Rx_Controller(Owner).ChangeToSBH(false);
			else if(Rx_Bot(Owner) != none)
				Rx_Bot(Owner).ChangeToSBH(false);
		}
	}

   rxPawn = Rx_Pawn(pawn);

   if (rxPawn == none || Team == none) {
      return;
   }
   
   equipStartWeapons(isFreeClass);
}