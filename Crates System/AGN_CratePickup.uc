/*
 *
 * ---  CratePickup Overrides ---
 *
 *
 * Thanks to uKill for all of his help on this - he's amazing!
 *	-- AlienX
 */

class AGN_CratePickup extends AGN_Pickup
   config(RenegadeX);

var()   bool                bNoVehicleSpawn; // vehicles will not spawn at this crate (use for tunnels!)
var()   bool                bNoNukeDeath; // no nuke explosion (big death crate)
var     bool                bRespawn;
var 	bool                bWillBeActive;

var array<class<AGN_CrateType> >   DefaultCrateTypes;
var array <AGN_CrateType> InstancedCrateTypes;

simulated function string GetHumanReadableName()
{
	return "[AGN] Mystery Crate";
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	InstantiateDefaultCrateTypes();
	InitCrateSystem();
}

function SpawnCopyFor(Pawn Recipient)
{
	DeactivateCrate();
	ExecutePickup(Recipient);
	ActivateRandomCrate();
}

function InitCrateSystem()
{
	local int i;
	local AGN_CratePickup tmpCrate;

	// Deactivate all crates in preperation for activing random ones.
	foreach Rx_Game(`WorldInfoObject.Game).AllActors(class'AGN_CratePickup', tmpCrate)
	{
		tmpCrate.DeactivateCrate();
	}

	// Activate random crates
	for ( i = 0; i<Rx_MapInfo(WorldInfo.GetMapInfo()).NumCratesToBeActive ; i++ )
	{
		GetInactiveCrate().ActivateCrate();
	}
}

function AGN_CratePickup GetInactiveCrate()
{
	local AGN_CratePickup tmpCrate;
	local array<AGN_CratePickup> CratesNotActive;

	foreach Rx_Game(`WorldInfoObject.Game).AllActors(class'AGN_CratePickup', tmpCrate)
	{
		if(!tmpCrate.getIsActive())
		{
			CratesNotActive.AddItem(tmpCrate);
		}
	}

	if ( CratesNotActive.Length == 0 )
		return None;
	else
		return CratesNotActive[Rand(CratesNotActive.Length)];
}

function ActivateRandomCrate()
{
   local AGN_CratePickup tmpCrate;
   local array<AGN_CratePickup> CratesNotActive;
   local float CrateRespawnAfterPickup;

   // get non active crates
   foreach Rx_Game(`WorldInfoObject.Game).AllActors(class'AGN_CratePickup', tmpCrate)
	{
      if(!tmpCrate.getIsActive())
      {
         CratesNotActive.AddItem(tmpCrate);
      }
   }
   // activate a rnd one

   CrateRespawnAfterPickup = 60.0f - Worldinfo.GRI.ElapsedTime % 60.0f;
   if(CrateRespawnAfterPickup == 0.0)
   		CrateRespawnAfterPickup = 1.0;

   CratesNotActive[Rand(CratesNotActive.Length)].setActiveIn(CrateRespawnAfterPickup);
}

function SendMessageToAllPlayers(string message)
{
	local Controller c;
	foreach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'Controller', c)
	{
		Rx_Controller(c).CTextMessage("[AGN] " $ message,'LightGreen',50);
	}
}

function bool isScheduledToBeActive()
{
   return bWillBeActive;
}

function setActiveIn(float inSeconds)
{
   bWillBeActive = true;
   setTimer(inSeconds, false, 'ActivateCrate');
}

function bool getIsActive()
{
   return !IsInState('Disabled') || bWillBeActive;
}

simulated function ActivateCrate()
{
   SetPickupVisible();
   SetCollision(true,false);
   bRespawn = true;
   bWillBeActive = false;
   GotoState('Sleeping');
}

simulated function DeactivateCrate()
{
   SetPickupHidden();
   SetCollision(false,false);
   bRespawn = false;
   GotoState('Disabled');
}

function InstantiateDefaultCrateTypes()
{
	local int i;

	if (Role == ROLE_Authority)
	{
		for (i = 0; i < DefaultCrateTypes.Length; i++)
		{
			InstancedCrateTypes.AddItem(new DefaultCrateTypes[i]);
		}
	}
}

function AGN_CrateType DetermineCrateType(Rx_Pawn Recipient)
{
	local int i;
	local float probabilitySum, random;
	local array<float> probabilities;

	// Get sum of probabilities, and cache values
	for (i = 0; i < InstancedCrateTypes.Length; i++)
	{
		if (WorldInfo.GRI.ElapsedTime >= InstancedCrateTypes[i].StartSpawnTime)
		{
			probabilities.AddItem(InstancedCrateTypes[i].GetProbabilityWeight(Recipient,self));
			LogInternal(InstancedCrateTypes[i] @ "probability:" @ probabilities[i]);
			probabilitySum += probabilities[i];
		}
		else
			probabilities.AddItem(0.0f);
	}
	LogInternal("Probability Sum:" @ probabilitySum);

	random = FRand() * probabilitySum;

	for (i = 0; i < InstancedCrateTypes.Length; i++)
	{
		LogInternal("Is " @ random @ " less than " @ probabilities[i]);
		if (random < probabilities[i])
			return InstancedCrateTypes[i];
		else
			random -= probabilities[i];
	}

	LogInternal("FAIL - Spawning last crate in the list");
	return InstancedCrateTypes[InstancedCrateTypes.Length - 1]; // Should never happen
}

function ExecutePickup(Pawn Recipient)
{
	local Rx_PRI pri;
	local AGN_CrateType CrateType;
	local Rx_Controller RxController;

	if (Rx_Pawn(Recipient) == none) // Only allow Rx_Pawns to pickup crates
		return;

	RxController = Rx_Controller(Recipient.Controller);

	pri = Rx_PRI(Recipient.PlayerReplicationInfo);
	CrateType = DetermineCrateType(Rx_Pawn(Recipient));
	CrateType.ExecuteCrateBehaviour(Rx_Pawn(Recipient),pri, self);
	if (CrateType.PickupSound != none)
		Recipient.PlaySound(CrateType.PickupSound);

	CrateType.BroadcastMessage(pri,self);
	CrateType.SendLocalMessage(RxController);
	//LogRxPub(CrateType.GetGameLogMessage(pri,self));
}

simulated function SetPickupMesh()
{
   AttachComponent(PickupMesh);

   if (bPickupHidden)
      SetPickupHidden();
   else
      SetPickupVisible();
}

/** @return whether the respawning process for this pickup is currently halted */
function bool DelayRespawn()
{
   return !bRespawn;
}

DefaultProperties
{
	RespawnTime=2.0000f
	PickupSound=none // From base class, don't use it.
	MessageClass = class'AGN_Message_Crates'

	Begin Object Class=StaticMeshComponent Name=CrateMesh
		StaticMesh=StaticMesh'AGN_Crate.SM_Crate'
		Scale=0.75f
		CollideActors=false
		BlockActors = false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
		BlockRigidBody=false
		LightEnvironment = PickupLightEnvironment
	End Object
	PickupMesh=CrateMesh
	Components.Add(CrateMesh)

	Begin Object NAME=CollisionCylinder
	CollisionRadius=+00030.000000
	CollisionHeight=+00020.000000
	CollideActors=true
	End Object

	bHasLocationSpeech=true
	LocationSpeech(0)=SoundNodeWave'A_Character_IGMale.BotStatus.A_BotStatus_IGMale_HeadingForTheSuperHealth'

	DefaultCrateTypes[0] = class'AGN_CrateType_Money'
	DefaultCrateTypes[1] = class'AGN_CrateType_Spy'
	DefaultCrateTypes[2] = class'AGN_CrateType_Refill'
	DefaultCrateTypes[3] = class'AGN_CrateType_Vehicle'
	DefaultCrateTypes[4] = class'AGN_CrateType_Suicide'
	DefaultCrateTypes[5] = class'AGN_CrateType_Character'
	DefaultCrateTypes[6] = class'AGN_CrateType_TimeBomb'
	DefaultCrateTypes[7] = class'AGN_CrateType_Nuke'
	DefaultCrateTypes[8] = class'AGN_CrateType_Speed'
	DefaultCrateTypes[9] = class'AGN_CrateType_Abduction'
	DefaultCrateTypes[10] = class'AGN_CrateType_TSVehicle'
	DefaultCrateTypes[11] = class'AGN_CrateType_SuperMoney'
	DefaultCrateTypes[12] = class'AGN_CrateType_RandomWeapon'
	//DefaultCrateTypes[13] = class'AGN_CrateType_Beacon'

	DefaultCrateTypes[13] = class'AGN_CrateType_Veterancy'
}
