/** 
 *  This is an example of how to create a mutator that can be triggered with the mutate command.
 *  This gives the player a sniper rifle when they type "Mutate Sniper" into the commandline.
 * */
class AGN_Mut_CrateSystem extends RX_Mutator;

var() array<bool> oldCratesVehSpawning;
var() array<bool> oldCratesNukeSpawning;

function InitMutator(string options, out string errorMessage)
{
	local Rx_CratePickup CratePickup;
	
	if (Rx_Game(WorldInfo.Game) != None)
	{
		Rx_Game(WorldInfo.Game).PlayerControllerClass = class'AGN_Rx_Controller';
		Rx_Game(WorldInfo.Game).HudClass = class'AGN_HUD';
	}
	
	LogInternal(" ---------- ");
	LogInternal(" ---------- Loading all current Rx_CratePickup actors on the map");
	foreach Rx_Game(`WorldInfoObject.Game).AllActors(class'Rx_CratePickup', CratePickup)
	{
		LogInternal(" ---------- Found Rx_CratePickup at " $ CratePickup.Location $ "  SpawnVeh: " $ string(CratePickup.bNoVehicleSpawn) $ " SpawnNuke: " $ string(CratePickup.bNoNukeDeath));
		oldCratesVehSpawning.AddItem(CratePickup.bNoVehicleSpawn);
		oldCratesNukeSpawning.AddItem(CratePickup.bNoNukeDeath);
	}
	
	Super.InitMutator(options, errorMessage);
	
	setTimer(5, false, 'ReplaceCrates');
}

function ReplaceCrates()
{
	local int count;
	local AGN_CratePickup CratePickup;
	local Rx_CratePickup RxCratePickup;
	local Controller c;
	
	
	count = 0;
	foreach Rx_Game(`WorldInfoObject.Game).AllActors(class'AGN_CratePickup', CratePickup)
	{
		LogInternal(" ---------- Found AGN_CratePickup at " $ CratePickup.Location $ "  SpawnVeh: " $ string(oldCratesVehSpawning[count]) $ " SpawnNuke: " $ string(oldCratesNukeSpawning[count]));
		CratePickup.bNoVehicleSpawn = oldCratesVehSpawning[count];
		CratePickup.bNoNukeDeath = oldCratesNukeSpawning[count];
		
		count++;
	}
	
	foreach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'Controller', c)
	{
		if (Rx_PRI(c.PlayerReplicationInfo) != None)
		{
			if (PlayerController(c) != None)
			{
				//Recipient.CTextMessage(GetPickupMessage(),'LightGreen',90);
				Rx_Controller(c).CTextMessage("[AGN] Crate system booted - Loaded " $ count $ " crates",'LightGreen',90);
			}
		}
	}

	LogInternal ( "[AGN] REMOVED OLD CRATES ARRAY" );
	//Rx_Game(class'WorldInfo'.static.GetWorldInfo()).AllCrates.Length = 0;
	Rx_Game(`WorldInfoObject.Game).AllCrates.Length = 0;
	
	foreach Rx_Game(`WorldInfoObject.Game).AllActors(class'Rx_CratePickup', RxCratePickup)
	{
		if ( RxCratePickup.MessageClass == class'Rx_Message_Crates' )
		{
			RxCratePickup.DeactivateCrate();
		}
	}
}

function Mutate(string MutateString, PlayerController Sender)
{
	MutateHandler(MutateString, Sender);
	Super.Mutate(MutateString, Sender);
}

reliable server function MutateHandler(string MutateString, PlayerController Sender)
{
	local array<string> MutateStringSplit;
	
	MutateStringSplit = SplitString ( MutateString, " ", true );
	if ( MutateStringSplit.Length == 0) return;
	
	if ( MutateStringSplit.Length == 1 && MutateStringSplit[0] ~= "agn_admin" )
	{
		if (!Sender.PlayerReplicationInfo.bAdmin)
		{
			Sender.ClientMessage("[AGN-Crates-Admin] Unable to comply, Kane says no!");
			return;
		}
		
		Sender.ClientMessage("[AGN-Admin] - use agn_admin help for help");
		return;
	}
	
	if ( MutateStringSplit.Length > 1 && MutateStringSplit[0] ~= "agn_admin" )
	{
		/*
		 * [0] = agn_admin
		 * [1] = cmd
		 * (2) = params (optional, depends on cmd)
		 */
		 
		if (!Sender.PlayerReplicationInfo.bAdmin)
		{
			Sender.ClientMessage("[AGN-Crates-Admin] Unable to comply, Kane says no!");
			return;
		}
		 
		Sender.ClientMessage("1 = |" $ MutateStringSplit[1] $ "|");
		if ( MutateStringSplit[1] ~= "help" )
		{
			Sender.ClientMessage("[AGN-Admin] Commands: respawn_crates, despawn_crates (case sensitive)");
		}else if ( MutateStringSplit[1] ~= "respawn_crates" )
		{
			AGNAdmin_RespawnCrates(Sender);
		}else if ( MutateStringSplit[1] ~= "despawn_crates" )
		{
			AGNAdmin_DespawnCrates(Sender);
		} else {
			Sender.ClientMessage("[AGN-Crates-Admin] Unknown command");
		}
	}
}

function AGNAdmin_RespawnCrates(PlayerController Sender)
{
	local AGN_CratePickup CratePickup;
	local int count;
	
	foreach Rx_Game(`WorldInfoObject.Game).AllActors(class'AGN_CratePickup', CratePickup)
	{
		if(!CratePickup.getIsActive())
		{
			count++;
			CratePickup.ActivateCrate();
			Sender.ClientMessage("Crate Coords:"@CratePickup.Location);
		}
	}
	
	Sender.ClientMessage("[AGN-Crates-Admin] Re-spawned " $ count $ " crates");
}

function AGNAdmin_DespawnCrates(PlayerController Sender)
{
	local AGN_CratePickup CratePickup;
	local int count;
	
	foreach Rx_Game(`WorldInfoObject.Game).AllActors(class'AGN_CratePickup', CratePickup)
	{
		if(CratePickup.getIsActive())
		{
			count++;
			CratePickup.DeactivateCrate();
			Sender.ClientMessage("Crate Coords:"@CratePickup.Location);
		}
	}
	
	Sender.ClientMessage("[AGN-Crates-Admin] Despawned " $ count $ " crates");
}

function bool CheckReplacement(Actor Other)
{
	if(Other.IsA('Rx_Pickup') && !Other.IsA('AGN_Pickup'))
	{
		LogInternal("[AGN] Attempting to write over Rx_CratePickup (AllCrates)...");
		ReplaceWith(Other, "AGN_Mut_CrateSystem.AGN_Pickup");
	}
	
	if (Other.IsA('Rx_Message_Crates') && !Other.IsA('AGN_Message_Crates'))
	{
		LogInternal("[AGN] Attempting to write over Rx_Message_Crates...");
		ReplaceWith(Other, "AGN_Message_Crates");
	}
	
	if (other.isA('Rx_CratePickup') && !other.isA('AGN_CratePickup'))
	{	
		ReplaceWith(Other,"AGN_Mut_CrateSystem.AGN_CratePickup");
	}
		
	if(Other.IsA('Rx_TeamInfo'))
	{
		Rx_Game(WorldInfo.Game).GameReplicationInfoClass = class'AGN_GRI';
		Rx_Game(WorldInfo.Game).PlayerControllerClass = class'AGN_Rx_Controller';
	}
	
	return true;
}

DefaultProperties
{
}