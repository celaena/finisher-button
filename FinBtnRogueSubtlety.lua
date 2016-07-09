-------------------------------------------
-- Subtlety Rogue Module --
-------------------------------------------
local module = {};
local moduleName = "RogueSubtlety";
FinBtn[moduleName] = module;

local main = FinBtn.Main;

local BACKSTAB = "Backstab";
local EVISCERATE = "Eviscerate";
local KICK = "Kick";
local NIGHTBLADE = "Nightblade";
local SHADOW_BLADES = "Shadow Blades";
local SHADOW_DANCE = "Shadow Dance";
local SHADOWSTRIKE = "Shadowstrike";
local SHURIKEN_STORM = "Shuriken Storm";
local SHURIKEN_TOSS = "Shuriken Toss";
local STEALTH = "Stealth";
local SYMBOLS_OF_DEATH = "Symbols of Death";
local VANISH = "Vanish";
local SUBTERFUGE = "Subterfuge";
local GLOOMBLADE = "Gloomblade";
local ENVELOPING_SHADOWS = "Enveloping Shadows";
local MARKED_FOR_DEATH = "Marked for Death";
local DEATH_FROM_ABOVE = "Death from Above";

local BS = "BS";
local EV = "Ev";
local KICK = "Kick";
local NB = "Nb";
local SB = "SB";
local SD = "SD";
local SS = "Ss";
local STR = "Str";
local ST = "ST";
local SOD = "SoD";
local VAN = "Van";
local GB = "Gb";
local ES = "ES";
local MFD = "MfD";
local DFA = "DfA";

module.SKILLS = {
	[BS] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = BACKSTAB
	},
	[EV] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = EVISCERATE
	},
	[KICK] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = KICK
	},
	[NB] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = NIGHTBLADE
	},
	[SB] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = SHADOW_BLADES
	},
	[SD] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = SHADOW_DANCE
	},
	[SS] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = SHADOWSTRIKE
	},
	[STR] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = SHURIKEN_STORM
	},
	[ST] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = SHURIKEN_TOSS
	},
	[SOD] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = SYMBOLS_OF_DEATH
	},
	[VAN] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = VANISH
	},
	[GB] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = GLOOMBLADE
	},
	[ES] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = ENVELOPING_SHADOWS
	},
	[MFD] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = MARKED_FOR_DEATH
	},
	[DFA] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = DEATH_FROM_ABOVE
	}
};

module.SKILL_ORDER = {
	SS,
	BS,
	NB,
	EV,
	KICK,
	SOD,
	VAN,
	SD,
	SB,
	STR
};

local function EvaluateButtons(buttons)
	local _,_,_,_,_,_,expiresStealth,_,_,_,_,_,_,_,_,_ = UnitAura(main.PLAYER,STEALTH,nil,main.PLAYER_HELPFUL);
	local _,_,_,_,_,_,expiresSubterfuge,_,_,_,_,_,_,_,_,_ = UnitAura(main.PLAYER,SUBTERFUGE,nil,main.PLAYER_HELPFUL);
	local _,_,_,_,_,_,expiresShadowDance,_,_,_,_,_,_,_,_,_ = UnitAura(main.PLAYER,SHADOW_DANCE,nil,main.PLAYER_HELPFUL);
	local _,_,_,_,_,_,expiresSoD,_,_,_,_,_,_,_,_,_ = UnitAura(main.PLAYER,SYMBOLS_OF_DEATH,nil,main.PLAYER_HELPFUL);
	
	local cp = UnitPower("player", 4);
	local maxCP = UnitPowerMax("player", 4);
	
	if (expiresStealth == nil and expiresSubterfuge == nil and expiresShadowDance == nil) then
		buttons[SS]:SetAlpha(main.OFF);
		buttons[BS]:SetAlpha(main.ON);
	else
		buttons[SS]:SetAlpha(main.ON);
		buttons[BS]:SetAlpha(main.HALF);
	end
	
	if (expiresSoD == nil or (expiresSoD - GetTime()) < 10) then
		buttons[SOD]:SetAlpha(main.ON)	
	else
		buttons[SOD]:SetAlpha(main.OFF)		
	end

	buttons[NB]:SetAlpha(main.OFF)
	buttons[EV]:SetAlpha(main.OFF)
	local _,_,_,_,_,_,expiresNb,_,_,_,_,_,_,_,_,_ = UnitAura(main.TARGET,NIGHTBLADE,nil,main.PLAYER_HARMFUL);
	if (expiresNb == nil or (expiresNb - GetTime()) < 4) then
		buttons[NB]:SetAlpha(main.ON)	
	else
		buttons[EV]:SetAlpha(main.ON)		
	end
	
	local _,_,_,_,_,_,_,_,interrupt = UnitCastingInfo(main.TARGET);
	if (interrupt == null or interrupt) then
		buttons[KICK]:SetAlpha(main.OFF)
	else
		buttons[KICK]:SetAlpha(main.ON)
	end
end

module.EvaluateButtons = EvaluateButtons