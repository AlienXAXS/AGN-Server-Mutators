/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_CrateType_TSVehicle extends Rx_CrateType 
    transient
    config(AGN_Crates);

var transient Rx_Vehicle GivenVehicle;
var config float ProbabilityIncreaseWhenVehicleProductionDestroyed;
var array< class<Rx_Vehicle> > Vehicles;

function string GetPickupMessage()
{
    return Repl(PickupMessage, "`vehname`", GivenVehicle.GetHumanReadableName(), false);
}

function string GetGameLogMessage(Rx_PRI RecipientPRI, Rx_CratePickup CratePickup)
{
    return ((((((((("GAME" $ Chr(2)) $ "Crate;") $ Chr(2)) $ "tsvehicle") $ Chr(2)) $ string(GivenVehicle.Class.Name)) $ Chr(2)) $ "by") $ Chr(2)) $ class'Rx_Game'.static.GetPRILogName(RecipientPRI);
}

function float GetProbabilityWeight(Rx_Pawn Recipient, Rx_CratePickup CratePickup)
{
    local Rx_Building Building;
    local float probability;

    if(CratePickup.bNoVehicleSpawn || Vehicles.Length == 0)
    {
        return 0.0;
    }
    else
    {
        probability = super.GetProbabilityWeight(Recipient, CratePickup);
        foreach CratePickup.AllActors(class'Rx_Building', Building)
        {
            if((((Recipient.GetTeamNum() == 0) && Rx_Building_GDI_VehicleFactory(Building) != none) && Rx_Building_GDI_VehicleFactory(Building).IsDestroyed()) || ((Recipient.GetTeamNum() == 1) && Rx_Building_Nod_VehicleFactory(Building) != none) && Rx_Building_Nod_VehicleFactory(Building).IsDestroyed())
            {
                probability += ProbabilityIncreaseWhenVehicleProductionDestroyed;
            }
        }
        return probability;
    }
}

function ExecuteCrateBehaviour(Rx_Pawn Recipient, Rx_PRI RecipientPRI, Rx_CratePickup CratePickup)
{
    local Vector tmpSpawnPoint;

    tmpSpawnPoint = CratePickup.Location + (vector(CratePickup.Rotation) * float(450));
    tmpSpawnPoint.Z += float(200);
    GivenVehicle = CratePickup.Spawn(Vehicles[Rand(Vehicles.Length)],,, tmpSpawnPoint, CratePickup.Rotation,, true);
    GivenVehicle.DropToGround();
    if(GivenVehicle.Mesh != none)
    {
        GivenVehicle.Mesh.WakeRigidBody();
    }
}

defaultproperties
{
    Vehicles(0)=class'AGN_Vehicle_Titan'
    Vehicles(1)=class'AGN_Vehicle_Wolverine'
    Vehicles(2)=class'AGN_Vehicle_HoverMRLS'
    Vehicles(3)=class'AGN_Vehicle_TickTank'
    Vehicles(4)=class'AGN_Vehicle_ReconBike'
    Vehicles(5)=class'AGN_TS_Vehicle_Buggy'
    Vehicles(6)=class'AGN_Vehicle_TeslaTank'
    BroadcastMessageIndex=14
    PickupSound=SoundCue'Rx_Pickups.Sounds.SC_Crate_VehicleDrop'
}

