-------------------------------------------
-- Assassination Rogue Module --
-------------------------------------------
local module = {};
local moduleName = "RogueAssassination";
FinBtn[moduleName] = module;

local main = FinBtn.Main;

local ENVENOM = "Envenom";
local FAN_OF_KNIVES = "Fan of Knives";
local GARROTE = "Garrote";
local MARKED_FOR_DEATH = "Marked for Death";
local MUTILATE = "Mutilate";
local POISONED_KNIFE = "Poisoned Knife";
local RUPTURE = "Rupture";
local VANISH = "Vanish";
local VENDETTA = "Vendetta";
local KICK = "Kick";
local STEALTH = "Stealth";
local HEMORRHAGE = "Hemorrhage";
local EXSANGUINATE = "Exsanguinate";
local DEATH_FROM_ABOVE = "Death from Above";

local EV = "Ev";
local FOK = "FoK";
local GA = "Ga";
local MFD = "MfD";
local MUT = "Mut";
local PK = "PK";
local RUP = "Rup";
local VAN = "Van";
local VEN = "Ven";
local KICK = "Kick";
local HEM = "Hem";
local EXS = "Exs";
local DFA = "DfA";

module.SKILLS = {
	[EV] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = ENVENOM
	},
	[FOK] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = FAN_OF_KNIVES
	},
	[GA] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = GARROTE
	},
	[MFD] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = MARKED_FOR_DEATH
	},
	[MUT] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = MUTILATE
	},
	[PK] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = POISONED_KNIFE
	},
	[RUP] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = RUPTURE
	},
	[VAN] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = VANISH
	},
	[VEN] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = VENDETTA
	},
	[KICK] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = KICK
	},
	[HEM] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = HEMORRHAGE
	},
	[EXS] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = EXSANGUINATE
	},
	[DFA] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = DEATH_FROM_ABOVE
	}
};

module.SKILL_ORDER = {
	GA,
	MUT,
	PK,
	EV,
	RUP,
	KICK,
	MFD,
	VAN,
	VEN,
	FOK
};

local function EvaluateButtons(buttons)
	local _,_,_,_,_,_,expiresStealth,_,_,_,_,_,_,_,_,_ = UnitAura(main.PLAYER,STEALTH,nil,main.PLAYER_HELPFUL);
	
	local cp = UnitPower("player", 4);
	local maxCP = UnitPowerMax("player", 4);

	buttons[RUP]:SetAlpha(main.OFF)
	buttons[EV]:SetAlpha(main.OFF)
	local _,_,_,_,_,_,expiresRup,_,_,_,_,_,_,_,_,_ = UnitAura(main.TARGET,RUPTURE,nil,main.PLAYER_HARMFUL);
	local _,_,_,_,_,_,expiresEv,_,_,_,_,_,_,_,_,_ = UnitAura(main.PLAYER,ENVENOM,nil,main.PLAYER_HELPFUL);
	if (expiresRup == nil or (expiresRup - GetTime()) < 7) then
		buttons[RUP]:SetAlpha(main.ON)	
	elseif (expiresEv == nil or (expiresEv - GetTime()) < 2) then
		buttons[EV]:SetAlpha(main.ON)
	else
		buttons[EV]:SetAlpha(main.HALF)		
	end
	
	local _,_,_,_,_,_,_,_,interrupt = UnitCastingInfo(main.TARGET);
	if (interrupt == null or interrupt) then
		buttons[KICK]:SetAlpha(main.OFF)
	else
		buttons[KICK]:SetAlpha(main.ON)
	end
end

module.EvaluateButtons = EvaluateButtons;