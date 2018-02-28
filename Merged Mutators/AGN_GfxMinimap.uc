class AGN_GfxMinimap extends Rx_GfxMinimap;

function UpdateActorBlips()
{
	local Pawn P;
	local Rx_Pawn RxP;
	local Rx_Vehicle RxV;
	local byte TeamVisibility; 
	local Rx_Weapon_DeployedBeacon B;//(nBab)

	local array<Actor> GDI;
	local array<Actor> GDIVehicle;
	local array<Actor> Nod;
	local array<Actor> NodVehicle;
	local array<Actor> Neutral;
	local array<Actor> NeutralVehicle;
	
	if(Update_Cycler == 1) return; //1 of every 3 cycles, don't bother update
	foreach ThisWorld.AllPawns(class'Pawn', P)
	{	
		//if(P.Controller != none && Rx_Controller(P.Controller) !=none ) TeamVisibility = Rx_Controller(P.Controller).RadarVisibility; 
		
		if(Rx_Pawn(P) != none ) TeamVisibility = Rx_Pawn(P).RadarVisibility; 
		else
		if(Rx_Vehicle(P) != none )  TeamVisibility = Rx_Vehicle(P).RadarVisibility; 
		
		if (P.bHidden  
			|| (P.Health <= 0) 
			|| (P.DrivenVehicle != none)
			//|| P.PlayerReplicationInfo == none    (NOTE: enabling this cause the vehicle to exit early.)
			|| P == Pawn(RxPC.ViewTarget)
			|| (TeamVisibility == 0)) 
		{
			//`log("Skipped Pawn --- ---" @ P @ "for: Visibility" @ TeamVisibility @ "Health:" @ P.Health @ "Driving Vehicle:" @ P.DrivenVehicle @ "Was view target : " @  P == Pawn(RxPC.ViewTarget)); 
			continue;
		}
		RxP = Rx_Pawn(P);
		RxV = Rx_Vehicle(P);
		
		if ((RxP == none) && (RxV == none)) continue;

		if (Rx_Defence(P) != none || AGN_Rebuildable_Defence_DestroyedTowerHandler(P) != None) continue;

		switch (P.GetTeamNum())
		{
			case TEAM_GDI:
				if (RxP != none)
				{
					GDI.AddItem(P);
				}
				else if (RxV != none)
				{
					GDIVehicle.AddItem(P);
				}
				break;
			case TEAM_NOD:
				if (RxP != none)
				{
					Nod.AddItem(P);
				}
				else if (RxV != none)
				{
					NodVehicle.AddItem(P);
				}
				break;
			default:
				if (RxP != none)
				{
					Neutral.AddItem(P);
				}
				else if (RxV != none)
				{
					NeutralVehicle.AddItem(P);
				}
				break;
		}	
		IconRotationOffset = 0;//180;
	}

	//Add deployed beacons to the vehicle array (nBab)
	foreach ThisWorld.DynamicActors(class'Rx_Weapon_DeployedBeacon', B)
	{
		switch (B.GetTeamNum())
		{
			case TEAM_GDI:
				GDIVehicle.AddItem(B);
				break;
			case TEAM_NOD:
				NodVehicle.AddItem(B);
				break;
			default:
				NeutralVehicle.AddItem(B);
				break;
		}
	}
	
	if(UseUpdateCycle)
	{
		if(Update_Cycler == 0)
		{
		UpdateIcons(GDI, GDITeamIcons, TEAM_GDI, false);
		UpdateIcons(GDIVehicle, GDIVehicleIcons, TEAM_GDI, true);	
		}
		else
		if(Update_Cycler == 2)
		{
		UpdateIcons(Nod, NodTeamIcons, TEAM_NOD, false);
		UpdateIcons(NodVehicle, NodVehicleIcons, TEAM_NOD, true);	
		}
		else
		{
		UpdateIcons(Neutral, NeutralIcons, TEAM_UNOWNED, false);
		UpdateIcons(NeutralVehicle, NeutralVehicleIcons, TEAM_UNOWNED, true);	
		}
	}
	else
	{
		UpdateIcons(GDI, GDITeamIcons, TEAM_GDI, false);
		UpdateIcons(GDIVehicle, GDIVehicleIcons, TEAM_GDI, true);		
		UpdateIcons(Nod, NodTeamIcons, TEAM_NOD, false);
		UpdateIcons(NodVehicle, NodVehicleIcons, TEAM_NOD, true);	
		UpdateIcons(Neutral, NeutralIcons, TEAM_UNOWNED, false);
		UpdateIcons(NeutralVehicle, NeutralVehicleIcons, TEAM_UNOWNED, true);	
	}
}