class AGN_CrateType extends Object within AGN_CratePickup
    abstract
    transient
    config(AGN_Crates);

var config float BaseProbability; // 1 = Average probability, 2 = twice average, 0.5 = half average, 0 = never
var config int StartSpawnTime; // Time at which crate becomes possible in seconds

var localized string PickupMessage;
var int BroadcastMessageIndex;

var Actor actorMapper;

var SoundCue PickupSound;

function PostBeginPlay()
{
    SetTimer(1, true, 'TimerTick');
}

function TimerTick()
{
    `log("[AGN] I ticked, boom!");
}

function string GetGameLogMessage(Rx_PRI RecipientPRI, AGN_CratePickup CratePickup)
{
    return "GAME" `s "Crate;" `s "by" `s `PlayerLog(RecipientPRI);
}

function BroadcastMessage(Rx_PRI RecipientPRI, AGN_CratePickup CratePickup)
{
    CratePickup.BroadcastLocalizedMessage(CratePickup.MessageClass,BroadcastMessageIndex,RecipientPRI);
}

function SendLocalMessage(Rx_Controller Recipient)
{
    //Recipient.clientmessage(GetPickupMessage());
    Recipient.CTextMessage(GetPickupMessage(),'LightGreen',90);
}

function string GetPickupMessage()
{
    return PickupMessage;
}

function float GetProbabilityWeight(Rx_Pawn Recipient, AGN_CratePickup CratePickup)
{
    return BaseProbability;
}

function ExecuteCrateBehaviour(Rx_Pawn Recipient, Rx_PRI RecipientPRI, AGN_CratePickup CratePickup);

DefaultProperties
{
}
