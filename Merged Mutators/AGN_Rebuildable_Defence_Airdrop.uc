class AGN_Rebuildable_Defence_Airdrop extends Rx_Chinook_Airdrop;

var AGN_Rebuildable_Defence_Handler Handler;
var vector OriginalLocation;
var rotator OriginalRotation;
var int HandlerID, TurretType, Team;
var private repnotify float CurrentTimex;
var bool bGotCurrentTimex;

replication
{
	if (bNetDirty)
		CurrentTimex,Team,TurretType;
}

simulated function class<Rx_Vehicle> GetVehicleClass()
{
	if ( Team == TEAM_GDI )
	{
		return class'AGN_Rebuildable_Defence_Tower';
	} else {
		if ( TurretType == 0 ) // Guard Tower
		{
			return class'AGN_Rebuildable_Defence_TowerNod';
		} else {			   // Pew pew turret
			return class'AGN_Rebuildable_Defence_Turret';
		}
	}
}

simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	if (Role == ROLE_Authority)
	{
		CurrentTimex = 0.f;
		SetTimer(1.0,false,'InitialSetup');
		bForceNetUpdate = true;
	}
	SetHidden(true);
	SetCollision(false,false);
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == 'CurrentTimex')
	{
		if (!bGotCurrentTimex)
		{
			bGotCurrentTimex = true;
			SetTimer(1.0,false,'InitialSetup');
		}
	}
	else super.ReplicatedEvent(VarName);
}

simulated function InitialSetup()
{	
	local Vector SocketLocation;
	local Rotator SocketRotation;	
	
	//NOD_TURRET = 1
	//NOD_GUARDTOWER = 0
	//GDI_GUARDTOWER = 0
	
	Mesh.AttachComponentToSocket(VehicleMesh, 'AirDrop_Vehicle');
	
	if ( Team == TEAM_GDI )
	{
		VehicleMesh.SetSkeletalMesh(SkeletalMesh'RX_DEF_GuardTower.Mesh.SK_DEF_GuardTower');
	} else {
		if ( TurretType == 0 ) // Guard Tower
		{
			VehicleMesh.SetSkeletalMesh(SkeletalMesh'RX_DEF_GuardTower.Mesh.SK_DEF_GuardTower');
		} else {			   // Pew pew turret
			VehicleMesh.SetSkeletalMesh(SkeletalMesh'RX_DEF_Turret.Mesh.SK_DEF_Turret');
		}
	}
	
	if (WorldInfo.NetMode != NM_DedicatedServer)
		setHidden(false);
	//SetTimer(2.0,false,'InitEngineSound');
	AttachSoundComponent(); 	
	EngineSound.Play(); 
	VehicleMesh.SetShadowParent(Mesh);		
	Mesh.GetSocketWorldLocationAndRotation('AirDrop_Vehicle', SocketLocation, SocketRotation);	
	Mesh.PlayAnim('AirDrop',,false,false,CurrentTimex);	
	SetTimer(14.5,false,'DropVehicle');
}

simulated function DropVehicle()
{
	local Vector SocketLocation;
	local Rotator SocketRotation;	
	
	Mesh.DetachComponent(VehicleMesh);
	Mesh.GetSocketWorldLocationAndRotation('AirDrop_Vehicle', SocketLocation, SocketRotation);
	
	if (WorldInfo.NetMode != NM_Client)
	{
		CarriedVehicle = Spawn(GetVehicleClass(),,, OriginalLocation, OriginalRotation,,true);	
		CarriedVehicle.DropToGround();	
		CarriedVehicle.Mesh.WakeRigidBody();
		
		if ( AGN_Rebuildable_Defence_Tower(CarriedVehicle) != None )
		{
			AGN_Rebuildable_Defence_Tower(CarriedVehicle).InitializeDefence(Handler, HandlerID);
		} else if ( AGN_Rebuildable_Defence_TowerNod(CarriedVehicle) != None )
		{
			AGN_Rebuildable_Defence_TowerNod(CarriedVehicle).InitializeDefence(Handler, HandlerID);
		} else if ( AGN_Rebuildable_Defence_Turret(CarriedVehicle) != None )
		{
			AGN_Rebuildable_Defence_Turret(CarriedVehicle).InitializeDefence(Handler, HandlerID);
		}
	}
}

simulated function Init(byte TeamID, AGN_Rebuildable_Defence_Handler OurHandler, vector thisLocation, rotator thisRotation, int OurHandlerID, int OurTurretType)
{
	Team = TeamID;
	Handler = OurHandler;
	OriginalLocation = thisLocation;
	OriginalRotation = thisRotation;
	HandlerID = OurHandlerID;
	TurretType = OurTurretType;
}

defaultproperties
{
	CurrentTimex = -1.0f
}