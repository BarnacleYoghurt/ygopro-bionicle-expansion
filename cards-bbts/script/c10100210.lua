if not bbts then
	dofile "expansions/util-bbts.lua"
end
--Krana Su, Worker
function c10100210.initial_effect(c)
	--Equip
	local e1=bbts.krana_equip(c)
	c:RegisterEffect(e1)
	--Gain ATK/DEF
	local e2a=Effect.CreateEffect(c)
	e2a:SetType(EFFECT_TYPE_EQUIP)
	e2a:SetRange(LOCATION_SZONE)
	e2a:SetCode(EFFECT_UPDATE_ATTACK)
	e2a:SetCondition(bbts.krana_condition_equipped)
	e2a:SetValue(600)
	c:RegisterEffect(e2a)
	local e2b=e2a:Clone()
	e2b:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2b)
	--Revive
	local e3=bbts.krana_revive(c)
	c:RegisterEffect(e3)
	--Summon
	local e4=bbts.krana_summon(c)
	c:RegisterEffect(e4)
end