/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */

class AGN_Veh_VehicleManager extends Rx_VehicleManager;

struct VQueueElement_AGN
{
   var Rx_PRI Buyer;
   var class<Rx_Vehicle> VehClass;
   var int VehicleID;
};

var private array<VQueueElement_AGN> 	GDI_Queue_AGN, NOD_Queue_AGN;
var private float                   ProductionDelay_AGN;
var private UTVehicle               lastSpawnedVehicle_AGN;

function Initialize(GameInfo Game, UTTeamInfo GdiTeamInfo, UTTeamInfo NodTeamInfo)
{
	local Vector loc;
	local Rotator rot;
	
	Super.Initialize(Game, GdiTeamInfo, NodTeamInfo);

	// Reset the vehicle spawning locations for both buildings, otherwise stuff spawns god knows where!
	if(WorldInfo.Netmode != NM_Client) {
		AirStrip.BuildingInternals.BuildingSkeleton.GetSocketWorldLocationAndRotation('Veh_DropOff', loc, rot);
		loc.z+=1000;
		Set_NOD_ProductionPlace(loc, rot);
		WeaponsFactory.BuildingInternals.BuildingSkeleton.GetSocketWorldLocationAndRotation('Veh_Spawn', loc, rot);
		Set_GDI_ProductionPlace(loc, rot);
	}
	
	// Spawn the harvs on single player.
	if(`WorldInfoObject.NetMode != NM_DedicatedServer)
		SpawnInitialHarvesters();
}

function QueueHarvester(byte team, bool bWithIncreasedDelay)
{
	local VQueueElement_AGN NewQueueElement;
	NewQueueElement.Buyer = None;
	
    if(team == TEAM_NOD) 
    {
    	if(bNodRefDestroyed)
    		return;
    	NewQueueElement.VehClass  = NodHarvesterClass;
		NewQueueElement.VehicleID = 11;
	    NOD_Queue_AGN.AddItem(NewQueueElement);
	    if (!IsTimerActive('queueWork_NOD'))
	    {
	       if(bWithIncreasedDelay)
	       {
	       	 SetTimer(ProductionDelay_AGN + 10.0, false, 'queueWork_NOD');
	       	 if(!AirStrip.IsDestroyed())
	       	 	SetTimer(10.0,false,'SpawnC130');
       	   }
	       else
	       {
	       	 if(AirStrip.IsDestroyed())
	       	 	SpawnC130();
	       	 SetTimer(ProductionDelay_AGN, false, 'queueWork_NOD'); 
	       }
	    }
	} 
	else if(team == TEAM_GDI) 
	{
    	if(bGDIRefDestroyed)
    		return;
	    NewQueueElement.VehClass  = GDIHarvesterClass;
		NewQueueElement.VehicleID = 10;
	    GDI_Queue_AGN.AddItem(NewQueueElement);
	    if (!IsTimerActive('queueWork_GDI'))
	    {	       
	       if(bWithIncreasedDelay)
	       {
	       	 SetTimer(ProductionDelay_AGN + 10.0 + GDIAdditionalAirdropProductionDelay, false, 'queueWork_GDI');
       	   }
	       else
	       {
	       	 SetTimer(ProductionDelay_AGN + GDIAdditionalAirdropProductionDelay, false, 'queueWork_GDI'); 
	       }	       
	    }		
	}		
}

function bool QueueVehicle(class<Rx_Vehicle> inVehicleClass, Rx_PRI Buyer, int VehicleID)
{
	local VQueueElement_AGN NewQueueElement;
	
	if(!IsAllowedToQueueUpAnotherVehicle(Buyer)) 
	{
		return false;
	}
	
	NewQueueElement.Buyer = Buyer;
	NewQueueElement.VehClass = inVehicleClass;
	NewQueueElement.VehicleID = VehicleID;
	
	if(Buyer.GetTeamNum() == TEAM_NOD) 
	{
		NOD_Queue_AGN.AddItem(NewQueueElement);
		if (!IsTimerActive('queueWork_NOD'))
		{
		   if(bJustSpawnedNodHarv) {
		   	   SetTimer(ProductionDelay_AGN+8.0+NodAdditionalAirdropProductionDelay, false, 'queueWork_NOD');
		   	   bJustSpawnedNodHarv = false;
		   	   SetTimer(8.0,false,'SpawnC130');
		   } else {			  
		   	   SetTimer(ProductionDelay_AGN+NodAdditionalAirdropProductionDelay, false, 'queueWork_NOD');
		   	   SpawnC130();
		   }
		}
		if( !ClassIsChildOf(inVehicleClass, class'Rx_Vehicle_Harvester') )
		{
			Rx_TeamInfo(Teams[Buyer.GetTeamNum()]).IncreaseVehicleCount();
		}
		ConstructionWarn(0);
		
	} 
	else if(Buyer.GetTeamNum() == TEAM_GDI)
	{
		GDI_Queue_AGN.AddItem(NewQueueElement);
		if (!IsTimerActive('queueWork_GDI'))
		{
		   if(bJustSpawnedNodHarv) {
		   	   SetTimer(ProductionDelay_AGN+8.0+GDIAdditionalAirdropProductionDelay, false, 'queueWork_GDI');
		   	   bJustSpawnedGDIHarv = false;
		   } else {			  
		   	   SetTimer(ProductionDelay_AGN+GDIAdditionalAirdropProductionDelay, false, 'queueWork_GDI');
		   }		   
		}
		if( !ClassIsChildOf(inVehicleClass, class'Rx_Vehicle_Harvester') )
		{
			Rx_TeamInfo(Teams[Buyer.GetTeamNum()]).IncreaseVehicleCount();
		}		
		ConstructionWarn(1);		
	}
	
	
	return true;
}

function bool IsAllowedToQueueUpAnotherVehicle(Rx_PRI Buyer)
{
	local int Count, I;
	
	if(Buyer.GetTeamNum() == TEAM_NOD) {
		for (I = 0; I < NOD_Queue_AGN.Length; I++)
		{
			if (NOD_Queue_AGN[I].Buyer == Buyer) {Count++;}
		}
	} else if(Buyer.GetTeamNum() == TEAM_GDI) {
		for (I = 0; I < GDI_Queue_AGN.Length; I++)
		{
			if (GDI_Queue_AGN[I].Buyer == Buyer) {Count++;}
		}
	}
   
	return Count < Buyer.MyVehicleLimitInQueue && CheckVehicleLimit(Buyer.GetTeamNum());
}

function Actor SpawnVehicle_AGN(VQueueElement_AGN VehToSpawn, optional byte TeamNum = -1)
{

	local Rx_Vehicle Veh;
	local Vector SpawnLocation;
	local Rx_Chinook_Airdrop AirdropingChinook;
	local vector TempLoc;
   
	if (TeamNum < 0)
		TeamNum = VehToSpawn.Buyer.GetTeamNum();
	  
	  
	switch(TeamNum)
	{
		case TEAM_NOD: // buy for NOD
			if(bNodIsUsingAirdrops)
			{
				TempLoc = NOD_ProductionPlace.L;
				if (AirStrip != None)
					TempLoc.Z -= 500;
					
				AirdropingChinook = Spawn(class'Rx_Chinook_Airdrop', , , TempLoc, NOD_ProductionPlace.R, , false);
				AirdropingChinook.initialize(VehToSpawn.Buyer,VehToSpawn.VehicleID, TeamNum);			
			}
			else
			{
				Veh = Spawn(VehToSpawn.VehClass,,, NOD_ProductionPlace.L,NOD_ProductionPlace.R,,true);			
				SpawnLocation = NOD_ProductionPlace.L;
			}
		break;
		case TEAM_GDI: // buy for GDI
			if(bGDIIsUsingAirdrops)
			{
				if (WeaponsFactory != None) {
					TempLoc = GDI_ProductionPlace.L + vector(GDI_ProductionPlace.R) * 950;
					TempLoc.Z -= 500;
					AirdropingChinook = Spawn(class'Rx_Chinook_Airdrop', , , TempLoc, GDI_ProductionPlace.R, , false);
				}
				else
					AirdropingChinook = Spawn(class'Rx_Chinook_Airdrop', , , GDI_ProductionPlace.L, GDI_ProductionPlace.R, , false);
				AirdropingChinook.initialize(VehToSpawn.Buyer,VehToSpawn.VehicleID, TeamNum);			
			}
			else
			{
				Veh = Spawn(VehToSpawn.VehClass,,,GDI_ProductionPlace.L,GDI_ProductionPlace.R,,true);
				SpawnLocation = GDI_ProductionPlace.L;
			}
		break;
	}
  
  	if (AirdropingChinook != none  )
  	{
  		if(VehToSpawn.Buyer != None) 
		{
			`LogRxPub("GAME" `s "Purchase;" `s "vehicle" `s VehToSpawn.VehClass.name `s "by" `s `PlayerLog(VehToSpawn.Buyer));
			if (Rx_Controller(VehToSpawn.Buyer.Owner) != None)
				Rx_Controller(VehToSpawn.Buyer.Owner).clientmessage("Your vehicle is being delivered!", 'Vehicle');
		}
		else
			`LogRxPub("GAME" `s "Spawn;" `s "vehicle" `s class'Rx_Game'.static.GetTeamName(TeamNum) $ "," $ VehToSpawn.VehClass.name);
			
		return AirdropingChinook;	
  	}
  
	if (Veh != none  )
	{
		lastSpawnedVehicle_AGN = Veh;
		//Veh.PlaySpawnEffect();
     
		if(VehToSpawn.Buyer != None) 
		{
			`LogRxPub("GAME" `s "Purchase;" `s "vehicle" `s VehToSpawn.VehClass.name `s "by" `s `PlayerLog(VehToSpawn.Buyer));
			if (Rx_Controller(VehToSpawn.Buyer.Owner) != None)
				Rx_Controller(VehToSpawn.Buyer.Owner).clientmessage("Your vehicle '"$veh.GetHumanReadableName()$"' is ready!", 'Vehicle');
		}
		else
			`LogRxPub("GAME" `s "Spawn;" `s "vehicle" `s class'Rx_Game'.static.GetTeamName(TeamNum) $ "," $ VehToSpawn.VehClass.name);
     
		InitVehicle(Veh,TeamNum,VehToSpawn.Buyer,VehToSpawn.VehicleID,SpawnLocation);
		return Veh;
	}
	else if (Veh != none && Rx_Vehicle_Harvester(Veh) != None) 
	{
		Veh.DropToGround(); 
	}

	return None;
}

function queueWork_GDI()
{
	local Actor Veh;
	
	if(GDI_Queue_AGN.Length > 0)
	{
		Veh = SpawnVehicle_AGN(GDI_Queue_AGN[0], TEAM_GDI);
		if(Veh != None) 
		{
			GDI_Queue_AGN.Remove(0, 1);
			ClearTimer('queueWork_GDI');
			if (GDI_Queue_AGN.Length > 0)
			{
				if(Rx_Vehicle_Harvester(Veh) != None) 
					SetTimer(ProductionDelay_AGN+9.0f+GDIAdditionalAirdropProductionDelay, false, 'queueWork_GDI');	
				else
					SetTimer(ProductionDelay_AGN+4.5f+GDIAdditionalAirdropProductionDelay, false, 'queueWork_GDI');	
				SetTimer(4.5f,false,'DelayedGDIConstructionWarn');
			}
		}
	}
	else
		ClearTimer('queueWork_GDI');
}

function queueWork_NOD()
{
	local Actor Veh;
	
	if(NOD_Queue_AGN.Length > 0) 
	{
		Veh = SpawnVehicle_AGN(NOD_Queue_AGN[0], TEAM_NOD);
		if(Veh != None) 
		{
			NOD_Queue_AGN.Remove(0, 1);
			ClearTimer('queueWork_NOD');
			if (NOD_Queue_AGN.Length > 0)
			{
				if(Rx_Vehicle_Harvester(Veh) != None) 
					SetTimer(ProductionDelay_AGN+9.0f+NodAdditionalAirdropProductionDelay, false, 'queueWork_NOD');	
				else
					SetTimer(ProductionDelay_AGN+4.5f+NodAdditionalAirdropProductionDelay, false, 'queueWork_NOD');	
				SetTimer(4.5f,false,'DelayedNodConstructionWarn');
			}
		}
	}
	else
		ClearTimer('queueWork_NOD');
}

DefaultProperties
{
	MessageClass = class'AGN_Veh_Message_VehicleProduced'
	ProductionDelay_AGN = 5.5f
}