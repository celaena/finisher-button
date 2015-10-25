-------------------------------------------
-- Combat Rogue Module --
-------------------------------------------
local module = {}
local moduleName = "RogueSubtlety";
FinBtn[moduleName] = module;

local main = FinBtn.Main

local STEALTH = "Stealth"
local SUBTERFUGE = "Subterfuge"
local BACKSTAB = "Backstab"
local AMBUSH = "Ambush"
local HEMORRHAGE = "Hemorrhage"
local SLICE_AND_DICE = "Slice and Dice"
local RUPTURE = "Rupture"
local EVISCERATE = "Eviscerate"
local KICK = "Kick"
local VANISH = "Vanish"
local SHADOW_DANCE = "Shadow Dance"
local SHADOW_REFLECTION = "Shadow Reflection"
local PREMEDITATION = "Premeditation"
local MARKED_FOR_DEATH = "Marked for Death"

local BS = "BS";
local AM = "Am";
local HM = "Hm";
local SND = "SnD";
local RUP = "Rup";
local EV = "Ev";
local KICK = "Kick";
local VAN = "Van";
local SD = "SD";
local SR = "SR";
local PRE = "Pre";
local MFD = "MfD";

module.SKILLS = {
	[BS] = {
		[main.SPELL] = BACKSTAB
	},
	[AM] = {
		[main.SPELL] = AMBUSH
	},
	[HM] = {
		[main.SPELL] = HEMORRHAGE
	},
	[SND] = {
		[main.SPELL] = SLICE_AND_DICE
	},
	[RUP] = {
		[main.SPELL] = RUPTURE
	},
	[EV] = {
		[main.SPELL] = EVISCERATE
	},
	[KICK] = {
		[main.SPELL] = KICK
	},
	[VAN] = {
		[main.SPELL] = VANISH
	},
	[SD] = {
		[main.SPELL] = SHADOW_DANCE
	},
	[SR] = {
		[main.SPELL] = SHADOW_REFLECTION
	},	
	[PRE] = {
		[main.SPELL] = PREMEDITATION
	},
	[MFD] = {
		[main.SPELL] = MARKED_FOR_DEATH
	}
}

module.SKILL_ORDER = {
	BS,
	AM,
	HM,
	SND,
	RUP,
	EV,
	KICK,
	PRE,
	VAN,
	SD,
	SR,
	MFD
}

local function EvaluateButtons(buttons)
	local _,_,_,_,_,_,expiresStealth,_,_,_,_,_,_,_,_,_ = UnitAura(main.PLAYER,STEALTH,nil,main.PLAYER_HELPFUL)
	local _,_,_,_,_,_,expiresSubterfuge,_,_,_,_,_,_,_,_,_ = UnitAura(main.PLAYER,SUBTERFUGE,nil,main.PLAYER_HELPFUL)
	local _,_,_,_,_,_,expiresShadowDance,_,_,_,_,_,_,_,_,_ = UnitAura(main.PLAYER,SHADOW_DANCE,nil,main.PLAYER_HELPFUL)
	
	local cp = UnitPower("player", 4);
	-- local ant = select(4, UnitAura("player", "Anticipation", nil, "PLAYER|HELPFUL")) or 0;
	
	local cbBuildOnState;
	-- if (cp + ant < 9) then
	if (cp < 4) then
		cbBuildOnState = main.ON;
	else
		cbBuildOnState = main.HALF;
	end
	
	if (expiresStealth == nil and expiresSubterfuge == nil and expiresShadowDance == nil) then
		buttons[AM]:SetAlpha(main.OFF)
	else
		buttons[AM]:SetAlpha(main.ON)
	end
	
	local _,_,_,_,_,_,expiresHM,_,_,_,_,_,_,_,_,_ = UnitAura(main.TARGET,HEMORRHAGE,nil,main.PLAYER_HARMFUL)
	local usableBs,lackEnBs = IsUsableSpell(module.SKILLS[BS][main.SPELL]);
	-- if (expiresHM == nil or (expiresHM - GetTime()) < 7 or (not usableBs and not lackEnBs)) then
	if (not usableBs and not lackEnBs) then
		buttons[HM]:SetAlpha(cbBuildOnState)
		buttons[BS]:SetAlpha(main.OFF)
	else
		buttons[HM]:SetAlpha(main.OFF)
		buttons[BS]:SetAlpha(cbBuildOnState)		
	end

	buttons[SND]:SetAlpha(main.OFF)
	buttons[RUP]:SetAlpha(main.OFF)
	buttons[EV]:SetAlpha(main.OFF)
	local _,_,_,_,_,_,expiresSD,_,_,_,_,_,_,_,_,_ = UnitAura(main.PLAYER,SLICE_AND_DICE,nil,main.PLAYER_HELPFUL)
	local _,_,_,_,_,_,expiresRup,_,_,_,_,_,_,_,_,_ = UnitAura(main.TARGET,RUPTURE,nil,main.PLAYER_HARMFUL)
	if (expiresRup == nil or (expiresRup - GetTime()) < 7) then
		buttons[RUP]:SetAlpha(main.ON)	
	elseif (expiresSD == nil or (expiresSD - GetTime()) < 8) then
		buttons[SND]:SetAlpha(main.ON)
	else
		buttons[EV]:SetAlpha(main.ON)		
	end
	
	if (cp < 4) then
		buttons[PRE]:SetAlpha(main.ON);
	else
		buttons[PRE]:SetAlpha(main.OFF);
	end
	
	local _,_,_,_,_,_,_,_,interrupt = UnitCastingInfo(main.TARGET)
	if (interrupt == null or interrupt) then
		buttons[KICK]:SetAlpha(main.OFF)
	else
		buttons[KICK]:SetAlpha(main.ON)
	end
end

module.EvaluateButtons = EvaluateButtons