class AGN_RepairPad extends Rx_Building;

var AGN_RepairPad_Emitter ourEmitter;

event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	if (UDKVehicle(Other) != None)
	{
		SendMessageToAllPlayers("I was touched, ooo! " $ TeamID);
		
		if ( ourEmitter == None )
		{
			ourEmitter = Spawn(class'AGN_Mut_AlienXSystem.AGN_RepairPad_Emitter',,, Location, Rotation);
		}
	}
	
	if ( Pawn(Other) != None )
	{
		SendMessageToAllPlayers("Pawn inside!");
	}
}

event UnTouch( Actor Other )
{
	if (UDKVehicle(Other) != None)
	{
		SendMessageToAllPlayers("I was left, awww! " $ TeamID);
	
		if ( ourEmitter != None )
			ourEmitter.Destroy();
	}
	
	if ( Pawn(Other) != None )
	{
		SendMessageToAllPlayers("Pawn Untouch!");
	}
}

function SendMessageToAllPlayers(string message)
{
	local Controller c;
	foreach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'Controller', c)
	{
		if ( c != None && Rx_Controller(c) != None )
			Rx_Controller(c).CTextMessage("[AGN] " $ message,'LightGreen',50);
	}
}

DefaultProperties
{
	Begin Object Class=CylinderComponent Name=RepairPad_CollisionCylinder
		CollisionRadius     = 350.0f
		CollisionHeight     = 80.0f
		CollisionType		= COLLIDE_TouchAllButWeapons
		CanBlockCamera 		= False
		bDisableAllRigidBody = True
		CollideActors       = True
		BlockNonZeroExtent  = True
		BlockZeroExtent     = False
		bDrawNonColliding   = True
		bDrawBoundingBox    = False
		BlockActors         = false
	End Object
	
	bCollideActors = true
	
	Components.Add(RepairPad_CollisionCylinder)
}