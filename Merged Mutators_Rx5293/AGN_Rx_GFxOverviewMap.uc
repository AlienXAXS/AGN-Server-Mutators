class AGN_Rx_GFxOverviewMap extends Rx_GFxOverviewMap;


function AddInfrantryCount2(Rx_Pawn RxP, class<Rx_FamilyInfo> TargetClass, class<Rx_FamilyInfo> TargetClass2, out int Count)
{
    if(RxP == none)
    {
        return;
    }
    if(RxP.GetRxFamilyInfo() != TargetClass && RxP.GetRxFamilyInfo() != TargetClass2)
    {
        return;
    }
    ++ Count;    
}

function AddVehicleCount2(Rx_Vehicle RxV, class<Rx_Vehicle> TargetClass, class<Rx_Vehicle> TargetClass2, out int Count)
{
    if(RxV == none)
    {
        return;
    }
    if(RxV.Class != TargetClass && RxV.Class != TargetClass2)
    {
        return;
    }
    ++ Count;
}

function UpdateActorBlips()
{
	local Pawn P;
	local Rx_Pawn RxP;
	local Rx_Vehicle RxV;
	local byte TeamVisibility; 
	local Rx_Weapon_DeployedBeacon B;
	local Rx_Weapon_DeployedProxyC4 DeployedProxyC4;

	local array<Actor> GDI;
	local array<Actor> GDIVehicle;
	local array<Actor> Nod;
	local array<Actor> NodVehicle;
	local array<Actor> Neutral;
	local array<Actor> NeutralVehicle;

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

		if (Rx_Defence(P) != none) continue;

		switch (P.GetTeamNum())
		{
			case TEAM_GDI:
				if (RxP != none )
				{
					if(!RxP.isSpy()) GDI.AddItem(P);
					else
					Nod.AddItem(P);
				}
				else if (RxV != none)
				{
					GDIVehicle.AddItem(P);
				}
				break;
			case TEAM_NOD:
				if (RxP != none)
				{
					if(!RxP.isSpy()) Nod.AddItem(P);
					else
					GDI.AddItem(P); 
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
	
	foreach ThisWorld.DynamicActors(class'Rx_Weapon_DeployedProxyC4', DeployedProxyC4)
	{
		switch (DeployedProxyC4.GetTeamNum())
		{
			case TEAM_GDI:
				GDIVehicle.AddItem(DeployedProxyC4);
				break;
			case TEAM_NOD:
				NodVehicle.AddItem(DeployedProxyC4);
				break;
			default:
				NeutralVehicle.AddItem(DeployedProxyC4);
				break;
		}
	}
	

 	UpdateIcons(GDI, GDITeamIcons, TEAM_GDI, false);
 	UpdateIcons(GDIVehicle, GDIVehicleIcons, TEAM_GDI, true);
  	UpdateIcons(Nod, NodTeamIcons, TEAM_NOD, false);
  	UpdateIcons(NodVehicle, NodVehicleIcons, TEAM_NOD, true);
  	UpdateIcons(Neutral, NeutralIcons, TEAM_UNOWNED, false);
  	UpdateIcons(NeutralVehicle, NeutralVehicleIcons, TEAM_UNOWNED, true);
}

function UpdatePawnInfoCount(  )
{
	local Pawn P;
	local Rx_Pawn RxP;
	local Rx_Vehicle RxV;

	local int gdi_soldierCount;
	local int gdi_shotgunnerCount;
	local int gdi_grenadierCount;
	local int gdi_marksmanCount;
	local int gdi_engineerCount;
	local int gdi_officerCount;
	local int gdi_rocket_soldierCount;
	local int gdi_mcfarlandCount;
	local int gdi_gunnerCount;
	local int gdi_patchCount;
	local int gdi_deadeyeCount;
	local int gdi_havocCount;
	local int gdi_sydneyCount;
	local int gdi_mobiusCount;
	local int gdi_hotwireCount;
	local int gdi_spiesCount;
    local int gdi_humveeCount;
    local int gdi_apcCount;
    local int gdi_mrlsCount;
    local int gdi_medium_tankCount;
    local int gdi_mammoth_tankCount;
    local int gdi_chinookCount;
    local int gdi_orcaCount;
    local int gdi_otherCount;

	local int nod_soldierCount;
	local int nod_shotgunnerCount;
	local int nod_flame_trooperCount;
	local int nod_marksmanCount;
	local int nod_engineerCount;
	local int nod_officerCount;
	local int nod_rocket_soldierCount;
	local int nod_chemical_trooperCount;
	local int nod_blackhand_sniperCount;
	local int nod_stealth_blackhandCount;
	local int nod_laser_chaingunnerCount;
	local int nod_sakuraCount;
	local int nod_ravenshawCount;
	local int nod_mendozaCount;
	local int nod_technicianCount;
	local int nod_spiesCount;

    local int nod_buggyCount;
    local int nod_nod_apcCount;
    local int nod_artilleryCount;
    local int nod_flame_tankCount;
    local int nod_light_tankCount;
    local int nod_stealth_tankCount;
    local int nod_nod_chinookCount;
    local int nod_apacheCount;
    local int nod_otherCount;

	local byte team_num;

	//TODO: Iterate once and get all info from there


	foreach ThisWorld.AllPawns (class'Pawn',P)
	{
		if (P.bHidden || (P.Health <= 0) || (P.DrivenVehicle != none)) {
			continue;
		}
		
		RxP = Rx_Pawn(P);
		RxV = Rx_Vehicle(P);

		if (Rx_Defence(P) != none) {
			continue;
		}
		
		if ((RxP == none) && (RxV == none)) {
			continue;
		}

		if (RxV != None && RxV.GetTeamNum() == 255)
			team_num = RxV.LastTeamToUse;
		else
			team_num = P.GetTeamNum();

		switch (team_num)
		{
			case TEAM_GDI:
				if (RxP != none ) {
					if (RxP.isSpy ()) {
						gdi_spiesCount++;
						break;
					}
					AddInfrantryCount2(RxP, class 'AGN_FamilyInfo_GDI_Soldier', class 'Rx_FamilyInfo_GDI_Soldier', gdi_soldierCount );
					AddInfrantryCount2(RxP, class 'AGN_FamilyInfo_GDI_Shotgunner', class 'Rx_FamilyInfo_GDI_Shotgunner', gdi_shotgunnerCount );
					AddInfrantryCount2(RxP, class 'AGN_FamilyInfo_GDI_Grenadier', class 'Rx_FamilyInfo_GDI_Grenadier', gdi_grenadierCount );
					AddInfrantryCount2(RxP, class 'AGN_FamilyInfo_GDI_Marksman', class 'Rx_FamilyInfo_GDI_Marksman', gdi_marksmanCount );
					AddInfrantryCount2(RxP, class 'AGN_FamilyInfo_GDI_Engineer', class 'Rx_FamilyInfo_GDI_Engineer', gdi_engineerCount );
					AddInfrantryCount2(RxP, class 'AGN_FamilyInfo_GDI_Officer', class 'Rx_FamilyInfo_GDI_Officer', gdi_officerCount );
					AddInfrantryCount2(RxP, class 'AGN_FamilyInfo_GDI_RocketSoldier', class 'Rx_FamilyInfo_GDI_RocketSoldier', gdi_rocket_soldierCount );
					AddInfrantryCount2(RxP, class 'AGN_FamilyInfo_GDI_McFarland', class 'Rx_FamilyInfo_GDI_McFarland', gdi_mcfarlandCount );
					AddInfrantryCount2(RxP, class 'AGN_FamilyInfo_GDI_Gunner', class 'Rx_FamilyInfo_GDI_Gunner', gdi_gunnerCount );
					AddInfrantryCount2(RxP, class 'AGN_FamilyInfo_GDI_Patch', class 'Rx_FamilyInfo_GDI_Patch', gdi_patchCount );
					AddInfrantryCount2(RxP, class 'AGN_FamilyInfo_GDI_Deadeye', class 'Rx_FamilyInfo_GDI_Deadeye', gdi_deadeyeCount );
					AddInfrantryCount2(RxP, class 'AGN_FamilyInfo_GDI_Havoc', class 'Rx_FamilyInfo_GDI_Havoc', gdi_havocCount );
					AddInfrantryCount2(RxP, class 'AGN_FamilyInfo_GDI_Sydney', class 'Rx_FamilyInfo_GDI_Sydney', gdi_sydneyCount );
					AddInfrantryCount2(RxP, class 'AGN_FamilyInfo_GDI_Mobius', class 'Rx_FamilyInfo_GDI_Mobius', gdi_mobiusCount );
					AddInfrantryCount2(RxP, class 'AGN_FamilyInfo_GDI_Hotwire', class 'Rx_FamilyInfo_GDI_Hotwire', gdi_hotwireCount );
				}

				if (RxV != none) {
					AddVehicleCount2(RxV, class 'AGN_Vehicle_Humvee', class 'Rx_Vehicle_Humvee', gdi_humveeCount );
					AddVehicleCount2(RxV, class 'AGN_Vehicle_APC_GDI', class 'Rx_Vehicle_APC_GDI', gdi_apcCount );
					AddVehicleCount2(RxV, class 'AGN_Vehicle_MRLS', class 'Rx_Vehicle_MRLS', gdi_mrlsCount );
					AddVehicleCount2(RxV, class 'AGN_Vehicle_MediumTank', class 'Rx_Vehicle_MediumTank', gdi_medium_tankCount );
					AddVehicleCount2(RxV, class 'AGN_Vehicle_MammothTank', class 'Rx_Vehicle_MammothTank', gdi_mammoth_tankCount );
					AddVehicleCount(RxV, class 'Rx_Vehicle_Chinook_GDI', gdi_chinookCount );
					AddVehicleCount(RxV, class 'Rx_Vehicle_Orca', gdi_orcaCount );

					// To be rewritten later:
					if (RxV.Class != class'AGN_Vehicle_Humvee'
						&& RxV.Class != class'AGN_Vehicle_APC_GDI'
						&& RxV.Class != class'AGN_Vehicle_MRLS'
						&& RxV.Class != class'AGN_Vehicle_MediumTank'
						&& RxV.Class != class'AGN_Vehicle_MammothTank'
						&& Rx_Vehicle_Harvester(RxV) == None
						&& RxV.Class != class'Rx_Vehicle_Humvee'
						&& RxV.Class != class'Rx_Vehicle_APC_GDI'
						&& RxV.Class != class'Rx_Vehicle_MRLS'
						&& RxV.Class != class'Rx_Vehicle_MediumTank'
						&& RxV.Class != class'Rx_Vehicle_MammothTank'
						&& RxV.Class != class'Rx_Vehicle_Chinook_GDI'
						&& RxV.Class != class'Rx_Vehicle_Orca')
						++gdi_otherCount;
				}
				break;
			case TEAM_NOD:
				if (RxP != none ) {
					if (RxP.isSpy ()) {
						nod_spiesCount++;
						break;
					}
					AddInfrantryCount2(RxP, class 'AGN_FamilyInfo_Nod_Soldier', class 'Rx_FamilyInfo_Nod_Soldier', nod_soldierCount );
					AddInfrantryCount2(RxP, class 'AGN_FamilyInfo_Nod_Shotgunner', class 'Rx_FamilyInfo_Nod_Shotgunner', nod_shotgunnerCount );
					AddInfrantryCount2(RxP, class 'AGN_FamilyInfo_Nod_FlameTrooper', class 'Rx_FamilyInfo_Nod_FlameTrooper', nod_flame_trooperCount );
					AddInfrantryCount2(RxP, class 'AGN_FamilyInfo_Nod_Marksman', class 'Rx_FamilyInfo_Nod_Marksman', nod_marksmanCount );
					AddInfrantryCount2(RxP, class 'AGN_FamilyInfo_Nod_Engineer', class 'Rx_FamilyInfo_Nod_Engineer', nod_engineerCount );
					AddInfrantryCount2(RxP, class 'AGN_FamilyInfo_Nod_Officer', class 'Rx_FamilyInfo_Nod_Officer', nod_officerCount );
					AddInfrantryCount2(RxP, class 'AGN_FamilyInfo_Nod_RocketSoldier', class 'Rx_FamilyInfo_Nod_RocketSoldier', nod_rocket_soldierCount );
					AddInfrantryCount2(RxP, class 'AGN_FamilyInfo_Nod_ChemicalTrooper', class 'Rx_FamilyInfo_Nod_ChemicalTrooper', nod_chemical_trooperCount );
					AddInfrantryCount2(RxP, class 'AGN_FamilyInfo_Nod_BlackHandSniper', class 'Rx_FamilyInfo_Nod_BlackHandSniper', nod_blackhand_sniperCount );
					AddInfrantryCount2(RxP, class 'AGN_FamilyInfo_Nod_StealthBlackHand', class 'Rx_FamilyInfo_Nod_StealthBlackHand', nod_stealth_blackhandCount );
					AddInfrantryCount2(RxP, class 'AGN_FamilyInfo_Nod_LaserChainGunner', class 'Rx_FamilyInfo_Nod_LaserChainGunner', nod_laser_chaingunnerCount );
					AddInfrantryCount2(RxP, class 'AGN_FamilyInfo_Nod_Sakura', class 'Rx_FamilyInfo_Nod_Sakura', nod_sakuraCount );
					AddInfrantryCount2(RxP, class 'AGN_FamilyInfo_Nod_Raveshaw', class 'Rx_FamilyInfo_Nod_Raveshaw', nod_ravenshawCount );
					AddInfrantryCount2(RxP, class 'AGN_FamilyInfo_Nod_Mendoza', class 'Rx_FamilyInfo_Nod_Mendoza', nod_mendozaCount );
					AddInfrantryCount2(RxP, class 'AGN_FamilyInfo_Nod_Technician', class 'Rx_FamilyInfo_Nod_Technician', nod_technicianCount );
				}
				if (RxV != none) {
					AddVehicleCount2(RxV, class 'AGN_Vehicle_Buggy', class 'Rx_Vehicle_Buggy', nod_buggyCount );
					AddVehicleCount2(RxV, class 'AGN_Vehicle_APC_Nod', class 'Rx_Vehicle_APC_Nod', nod_nod_apcCount );
					AddVehicleCount2(RxV, class 'AGN_Vehicle_Artillery', class 'Rx_Vehicle_Artillery', nod_artilleryCount );
					AddVehicleCount2(RxV, class 'AGN_Vehicle_FlameTank', class 'Rx_Vehicle_FlameTank', nod_flame_tankCount );
					AddVehicleCount2(RxV, class 'AGN_Vehicle_LightTank', class 'Rx_Vehicle_LightTank', nod_light_tankCount );
					AddVehicleCount2(RxV, class 'AGN_Vehicle_StealthTank', class 'Rx_Vehicle_StealthTank', nod_stealth_tankCount );
					AddVehicleCount(RxV, class 'Rx_Vehicle_Chinook_Nod', nod_nod_chinookCount );
					AddVehicleCount(RxV, class 'Rx_Vehicle_Apache', nod_apacheCount );
					
					// To be rewritten later:
					if (RxV.Class != class'AGN_Vehicle_Buggy'
						&& RxV.Class != class'AGN_Vehicle_APC_Nod'
						&& RxV.Class != class'AGN_Vehicle_Artillery'
						&& RxV.Class != class'AGN_Vehicle_FlameTank'
						&& RxV.Class != class'AGN_Vehicle_LightTank'
						&& RxV.Class != class'AGN_Vehicle_StealthTank'
						&& RxV.Class != class'Rx_Vehicle_Buggy'
						&& RxV.Class != class'Rx_Vehicle_APC_Nod'
						&& RxV.Class != class'Rx_Vehicle_Artillery'
						&& RxV.Class != class'Rx_Vehicle_FlameTank'
						&& RxV.Class != class'Rx_Vehicle_LightTank'
						&& RxV.Class != class'Rx_Vehicle_StealthTank'
						&& RxV.Class != class'Rx_Vehicle_Chinook_Nod'
						&& RxV.Class != class'Rx_Vehicle_Apache'
						&& Rx_Vehicle_Harvester(RxV) == None)
						++nod_otherCount;
				}
				break;
		}
	}

	switch (GetPC().GetTeamNum())
	{
		case TEAM_GDI:
				SetInfoLabelCount (gdi_soldier, gdi_soldierCount);
				SetInfoLabelCount (gdi_shotgunner, gdi_shotgunnerCount);
				SetInfoLabelCount (gdi_grenadier, gdi_grenadierCount);
				SetInfoLabelCount (gdi_marksman, gdi_marksmanCount);
				SetInfoLabelCount (gdi_engineer, gdi_engineerCount);
				SetInfoLabelCount (gdi_officer, gdi_officerCount);
				SetInfoLabelCount (gdi_rocket_soldier, gdi_rocket_soldierCount);
				SetInfoLabelCount (gdi_mcfarland, gdi_mcfarlandCount);
				SetInfoLabelCount (gdi_gunner, gdi_gunnerCount);
				SetInfoLabelCount (gdi_patch, gdi_patchCount);
				SetInfoLabelCount (gdi_deadeye, gdi_deadeyeCount);
				SetInfoLabelCount (gdi_havoc, gdi_havocCount);
				SetInfoLabelCount (gdi_sydney, gdi_sydneyCount);
				SetInfoLabelCount (gdi_mobius, gdi_mobiusCount);
				SetInfoLabelCount (gdi_hotwire, gdi_hotwireCount);
				SetInfoLabelCount (gdi_spies, gdi_spiesCount);
				SetInfoLabelCount (humvee, gdi_humveeCount);
				SetInfoLabelCount (gdi_apc, gdi_apcCount);
				SetInfoLabelCount (mrls, gdi_mrlsCount);
				SetInfoLabelCount (medium_tank, gdi_medium_tankCount);
				SetInfoLabelCount (mammoth_tank, gdi_mammoth_tankCount);
				SetInfoLabelCount (gdi_chinook, gdi_chinookCount);
				SetInfoLabelCount (orca, gdi_orcaCount);
				SetInfoLabelCount (gdi_other, gdi_otherCount);
			break;
		case TEAM_NOD:
				SetInfoLabelCount (nod_soldier, nod_soldierCount);
				SetInfoLabelCount (nod_shotgunner, nod_shotgunnerCount);
				SetInfoLabelCount (nod_flame_trooper, nod_flame_trooperCount);
				SetInfoLabelCount (nod_marksman, nod_marksmanCount);
				SetInfoLabelCount (nod_engineer, nod_engineerCount);
				SetInfoLabelCount (nod_officer, nod_officerCount);
				SetInfoLabelCount (nod_rocket_soldier, nod_rocket_soldierCount);
				SetInfoLabelCount (nod_chemical_trooper, nod_chemical_trooperCount);
				SetInfoLabelCount (nod_blackhand_sniper, nod_blackhand_sniperCount);
				SetInfoLabelCount (nod_stealth_blackhand, nod_stealth_blackhandCount);
				SetInfoLabelCount (nod_laser_chaingunner, nod_laser_chaingunnerCount);
				SetInfoLabelCount (nod_sakura, nod_sakuraCount);
				SetInfoLabelCount (nod_ravenshaw, nod_ravenshawCount);
				SetInfoLabelCount (nod_mendoza, nod_mendozaCount);
				SetInfoLabelCount (nod_technician, nod_technicianCount);
				SetInfoLabelCount (nod_spies, nod_spiesCount);
				SetInfoLabelCount (buggy, nod_buggyCount);
				SetInfoLabelCount (nod_apc, nod_nod_apcCount);
				SetInfoLabelCount (artillery, nod_artilleryCount);
				SetInfoLabelCount (flame_tank, nod_flame_tankCount);
				SetInfoLabelCount (light_tank, nod_light_tankCount);
				SetInfoLabelCount (stealth_tank, nod_stealth_tankCount);
				SetInfoLabelCount (nod_chinook, nod_nod_chinookCount);
				SetInfoLabelCount (apache, nod_apacheCount);
				SetInfoLabelCount (nod_other, nod_otherCount);
			break;
	}
}

function UpdateIcons(out array<Actor> Actors, out array<GFxObject> ActorIcons, TEAM TeamInfo, bool bVehicle)
{
	// HARDCODED: Radius = 124

	local ASDisplayInfo displayInfo;
	local array<GFxObject> Icons;
	local byte i;
	local vector V;
	local GFxObject Val;
	local Rx_GRI rxGRI;


	if(RxMapInfo == None)
		return;
		
	// If no pawn, they are dead - dont draw anything
	if ( GetPC().Pawn == None )
		return;

	rxGRI = Rx_GRI(ThisWorld.GRI);

	displayInfo.hasVisible = true;
	displayInfo.hasX = true; 
	displayInfo.hasY = true;
	displayInfo.hasRotation = true;

	// Generate new icons if the actor icons is not equal to total specified actor count. 
	// Else, hide them all and show them until it reach the specified actor count.
	if (ActorIcons.Length < Actors.Length) {
		switch (TeamInfo) 
		{
			case TEAM_GDI:
				Icons = bVehicle ? GenGDIVehicleIcons(Actors.Length - ActorIcons.Length) : GenGDIIcons(Actors.Length - ActorIcons.Length);
				break;
			case TEAM_NOD:
				Icons = bVehicle ? GenNodVehicleIcons(Actors.Length - ActorIcons.Length) : GenNodIcons(Actors.Length - ActorIcons.Length);
				break;
			default:
				Icons = bVehicle ? GenNeutralVehicleIcons(Actors.Length - ActorIcons.Length) : GenNeutralIcons(Actors.Length - ActorIcons.Length);
				break;
		}
		
		foreach Icons(Val) {
			ActorIcons.AddItem(Val);
		}
	} else {
		displayInfo.Visible = false;
		for (i = Actors.Length; i < ActorIcons.Length; i++) {
			ActorIcons[i].SetDisplayInfo(displayInfo);
		}
	}

	//sets the Blips Visibility condition here
	for (i = 0; i < Actors.Length; i++) {
		//IMPLEMENTATION #2
		V = TransformVector(IconMatrix, Actors[i].Location);
		
		// Display only within the range of the minimap radius
		//displayInfo.Visible = (VSize2d(V) < RxMapInfo.MinimapRadius);
		displayInfo.Visible = true; //By default it will be displayed
		
		// Sets up the blips coordinates
		displayInfo.X =V.X;
		displayInfo.Y = V.Y;

		//Change the vehicle blips to the actor's corresponding vehicles
		if (Rx_Vehicle(Actors[i]) != none) {
			//ActorIcons[i].GetObject("vehicleG").GotoAndStop(GetVehicleIconName(Actors[i]));
			if (Rx_Vehicle(Actors[i]).MinimapIconTexture != none) {
				LoadTexture("img://" $ PathName(Rx_Vehicle(Actors[i]).MinimapIconTexture), ActorIcons[i].GetObject("vehicleG"));
			} else {
				LoadTexture("img://" $ PathName(Texture2D'RenxHud.T_Radar_Blip_Vehicle_Neutral'), ActorIcons[i].GetObject("vehicleG"));
			}
		}

		displayInfo.Rotation = (Actors[i].Rotation.Yaw * UnrRotToDeg) + /*f*/0 + IconRotationOffset ;
		
		//Condition for other blips that is not the same team as the player owner
		if (rxGRI != none && !ThisWorld.GRI.OnSameTeam(Pawn(GetPC().viewtarget), Actors[i]) ) {
			if ( (Actors[i].GetTeamNum() == TEAM_GDI || Actors[i].GetTeamNum() == TEAM_NOD)) {
				if (Actors[i].IsInState('Stealthed'))
				{
					displayInfo.Visible = false;
					ActorIcons[i].SetDisplayInfo(displayInfo);
					continue;
				}
	
				displayInfo.Visible = false; // init false, as most instances will be false.
				
				if(Rx_Pawn(Actors[i]) != none && ((Rx_Pawn(Actors[i]).GetRadarVisibility() == 2 && !Rx_Pawn(Actors[i]).PawnInFriendlyBase("",Pawn(Actors[i]))) || (Rx_PRI(Rx_Pawn(Actors[i]).PlayerReplicationInfo).isSpotted()))) 
				{
						displayInfo.Visible = true;		
				}
				else
				if(Rx_Vehicle(Actors[i]) != none && ((Rx_Vehicle(Actors[i]).GetRadarVisibility() == 2 && !Rx_Vehicle(Actors[i]).PawnInFriendlyBase("",Pawn(Actors[i]))) || (Rx_PRI(Rx_Vehicle(Actors[i]).PlayerReplicationInfo) != none && Rx_PRI(Rx_Vehicle(Actors[i]).PlayerReplicationInfo).isSpotted()))) 
				{ 
					displayInfo.Visible = true;
				}
								
				if (RxHUD.RenxHud.TargetingBox.TargetedActor == Actors[i]) 
				{
					displayInfo.Visible = true;
				}
			} else {
				//`log("Display Info set for FALSE at end") ; 
				displayInfo.Visible = true;
			}
		}

		//Change blip to beacon star (nBab)
		if (Rx_Weapon_DeployedBeacon(Actors[i]) != None)
		{
			if(Rx_HUD(GetPC().myHUD).SystemSettingsHandler.GetBeaconIcon() == 0)
			{
				if (Actors[i].isA('Rx_Weapon_DeployedIonCannonBeacon'))
					LoadTexture("img://" $ PathName(Texture2D'RenxHud.T_Beacon_Ion'), ActorIcons[i].GetObject("vehicleG"));
				else
					LoadTexture("img://" $ PathName(Texture2D'RenxHud.T_Beacon_Nuke'), ActorIcons[i].GetObject("vehicleG"));
			}else
				LoadTexture("img://" $ PathName(Texture2D'RenxHud.T_Beacon_Star'), ActorIcons[i].GetObject("vehicleG"));
			//Only show the blip if on the same team (nBab)
			if (GetPC().Pawn != None && GetPC().Pawn.getTeamNum() == Actors[i].getTeamNum())
				displayInfo.Visible = true;
			displayInfo.Rotation = 0;
		}
		
		if (Rx_Weapon_DeployedProxyC4(Actors[i]) != None)
		{
			if (Actors[i].isA('Rx_Weapon_DeployedProxyC4'))
				LoadTexture("img://" $ PathName(Texture2D'RenxHud.T_Beacon_Star'), ActorIcons[i].GetObject("vehicleG"));

			//Only show the blip if on the same team (nBab)
			if (GetPC().Pawn != None && GetPC().Pawn.getTeamNum() == Actors[i].getTeamNum())
				displayInfo.Visible = true;
				
			displayInfo.Rotation = 0;
		}

		ActorIcons[i].SetDisplayInfo(displayInfo);
	}
}