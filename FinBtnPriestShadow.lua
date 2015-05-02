-------------------------------------------
-- Shadow Priest Module --
-------------------------------------------
local module = {}
local moduleName = "PriestShadow";
FinBtn[moduleName] = module;

local main = FinBtn.Main

local MIND_FLAY = "Mind Flay"
local SHADOW_WORD_PAIN = "Shadow Word: Pain"
local VAMPIRIC_TOUCH = "Vampiric Touch"
local DEVOURING_PLAGUE = "Devouring Plague"
local MIND_BLAST = "Mind Blast"
local SHADOW_WORD_DEATH = "Shadow Word: Death"
local SILENCE = "Silence"
local HALO = "Halo"
local POWER_INFUSION = "Power Infusion"
local MINDBENDER = "Mindbender"
local SHADOWFIEND = "Shadowfiend"
local MIND_SPIKE = "Mind Spike"
local SURGE_OF_DARKNESS = "Surge of Darkness"
local SHADOW_WORD_INSANITY = "Insanity"

local MF = "MF";
local SWP = "SWP";
local VT  = "VT";
local DP = "DP";
local MB = "MB";
local SWD = "SWD";
local SIL = "Sil";
local PI = "PI";
local MI_BE = "MiBe";
local MI_SP = "MiSp";

local halo_min = 20;
local halo_max = 25;

module.SKILLS = {
	[MF] = {
		[main.SPELL] = MIND_FLAY,
		[main.ID] = 15407
	},
	[SWP] = {
		[main.SPELL] = SHADOW_WORD_PAIN
	},
	[VT] = {
		[main.SPELL] = VAMPIRIC_TOUCH
	},
	[DP] = {
		[main.SPELL] = DEVOURING_PLAGUE
	},
	[MB] = {
		[main.SPELL] = MIND_BLAST
	},
	[SWD] = {
		[main.SPELL] = SHADOW_WORD_DEATH
	},
	[SIL] = {
		[main.SPELL] = SILENCE
	},
	[HALO] = {
		[main.SPELL] = HALO,
		[main.ID] = 120644
	},
	[PI] = {
		[main.SPELL] = POWER_INFUSION
	},
	[MI_BE] = {
		[main.SPELL] = MINDBENDER,
		[main.ID] = 132603
		-- [main.ID] = 123040
	},
	[MI_SP] = {
		[main.SPELL] = MIND_SPIKE
	}
}

module.SKILL_ORDER = {
	MF,
	SWP,
	VT,
	DP,
	MB,
	SWD,
	SIL,
	HALO,
	PI,
	MI_BE
}

-- module.SKILL_ORDER = {
	-- MF,
	-- MI_SP,
	-- DP,
	-- MB,
	-- SWD,
	-- SIL,
	-- HALO,
	-- PI,
	-- MI_BE
-- }

local function evaluateDots(buttons, shadowOrbCount)
	local refreshDot = false

	local _,_,_,_,_,_,expiresSWP,_,_,_,_,_,_,_,_,_ = UnitAura(main.TARGET,SHADOW_WORD_PAIN,nil,main.PLAYER_HARMFUL)
	if (expiresSWP == nil or (expiresSWP - GetTime()) <= 5) then
		buttons[SWP]:SetAlpha(main.ON)
		refreshDot = true
	else
		buttons[SWP]:SetAlpha(main.OFF)		
	end
	
	local _,_,_,_,_,_,expiresVT,_,_,_,_,_,_,_,_,_ = UnitAura(main.TARGET,VAMPIRIC_TOUCH,nil,main.PLAYER_HARMFUL)
	if (expiresVT == nil or (expiresVT - GetTime()) <= 4) then
		buttons[VT]:SetAlpha(main.ON)
		refreshDot = true
	else
		buttons[VT]:SetAlpha(main.OFF)	
	end
	
	local _,_,_,_,_,_,expiresDP,_,_,_,_,_,_,_,_,_ = UnitAura(main.TARGET,DEVOURING_PLAGUE,nil,main.PLAYER_HARMFUL)
	if (expiresDP == nil and 3 <= shadowOrbCount) then
		buttons[DP]:SetAlpha(main.ON)
		refreshDot = true
	else
		buttons[DP]:SetAlpha(main.OFF)	
	end
	
	return refreshDot;
end

local function EvaluateButtons(buttons)
	local shadowOrbCount = UnitPower(main.PLAYER, SPELL_POWER_SHADOW_ORBS)
	
	local _,gcdLeft,_ = GetSpellCooldown(module.SKILLS[MF][main.SPELL]);
	local _,cdMB,_ = GetSpellCooldown(module.SKILLS[MB][main.SPELL]);
	local _,cdSWD,_ = GetSpellCooldown(module.SKILLS[SWD][main.SPELL]);
	local _,cdH,_ = GetSpellCooldown(module.SKILLS[HALO][main.SPELL]);
	
	local usableSWD,_ = IsUsableSpell(module.SKILLS[SWD][main.SPELL]);
	
	local refreshDot = evaluateDots(buttons, shadowOrbCount);
	
	if (shadowOrbCount < 5) then
		buttons[MB]:SetAlpha(main.ON)
		if (usableSWD) then
			buttons[SWD]:SetAlpha(main.ON)
		end
	else
		buttons[MB]:SetAlpha(main.OFF)
		buttons[SWD]:SetAlpha(main.OFF)
	end
	
	local haloSetting;
	if (gcdLeft >= cdH) then
		haloSetting = main.HALF;
	else	
		haloSetting = main.OFF;
	end
	local minRange, maxRange = main.rc:GetRange(TARGET)
	if (minRange and maxRange) then
		if (halo_min <= minRange and halo_max >= maxRange) then
			haloSetting = main.ON;
		end
	end
	buttons[HALO]:SetAlpha(haloSetting);
	
	if (refreshDot or gcdLeft >= cdMB or gcdLeft >= cdH or (gcdLeft >= cdSWD and usableSWD)) then
		buttons[MF]:SetAlpha(main.OFF)
	else
		buttons[MF]:SetAlpha(main.ON)
	end
	
	-- local _,_,_,_,_,_,expiresSWI,_,_,_,_,_,_,_,_,_ = UnitAura(main.PLAYER,SHADOW_WORD_INSANITY,nil,main.PLAYER_HELPFUL)
	-- local sdStacks = select(4, UnitAura(main.PLAYER, SURGE_OF_DARKNESS, nil, main.PLAYER_HELPFUL));
	
	-- if (refreshDot or gcdLeft >= cdMB or gcdLeft >= cdH or (gcdLeft >= cdSWD and usableSWD)) then
		-- buttons[MF]:SetAlpha(main.OFF)
		-- buttons[MI_SP]:SetAlpha(main.OFF)
	-- elseif ((sdStacks ~= nil and sdStacks >= 3) or expiresSWI == nil or expiresSWI <= 0) then	
		-- buttons[MF]:SetAlpha(main.OFF)
		-- buttons[MI_SP]:SetAlpha(main.ON)
	-- else
		-- buttons[MF]:SetAlpha(main.ON)
		-- buttons[MI_SP]:SetAlpha(main.OFF)
	-- end
	
	local _,_,_,_,_,_,_,_,interrupt = UnitCastingInfo(main.TARGET)
	if (interrupt == null or interrupt) then
		buttons[SIL]:SetAlpha(main.OFF)
	else
		buttons[SIL]:SetAlpha(main.ON)
	end
end

module.EvaluateButtons = EvaluateButtons