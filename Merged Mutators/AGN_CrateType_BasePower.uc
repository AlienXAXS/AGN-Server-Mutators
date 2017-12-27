class AGN_CrateType_BasePower extends Object within AGN_CrateType
	config(AGN_Crates);

function string GetGameLogMessage(Rx_PRI RecipientPRI, AGN_CratePickup CratePickup)
{
	return "GAME" `s "Crate;" `s "base-power" `s "by" `s `PlayerLog(RecipientPRI);
}

function float GetProbabilityWeight(Rx_Pawn Recipient, AGN_CratePickup CratePickup)
{
	//return super.GetProbabilityWeight(Recipient,CratePickup);
}

function ExecuteCrateBehaviour(Rx_Pawn Recipient, Rx_PRI RecipientPRI, AGN_CratePickup CratePickup)
{
	/*
	if ( Recipient.GetTeamNum() == TEAM_GDI )
	{
		foreach AllActors(class'Rx_Building_Team_Internals', building) {
            if(building.TeamID == TEAM_NOD)
                building.PowerLost();
        }
	} else {
		foreach AllActors(class'Rx_Building_Team_Internals', building) {
            if(building.TeamID == TEAM_GDI)
                building.PowerLost();
        }
	}
	SetTimer(10, false, 'RestorePower');
	*/
}


function RestorePower()
{
	
}

DefaultProperties
{
	PickupSound = SoundCue'RX_EVA_VoiceClips.Nod_EVA.S_EVA_Nod_Beacon_NuclearStrikeImminent_Cue'
	BroadcastMessageIndex = 3
}