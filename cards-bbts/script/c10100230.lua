if not bbts then
	dofile "expansions/util-bbts.lua"
end
--Bohrok Va Kaita Ja
function c10100230.initial_effect(c)
	--Fusion Material
	aux.AddFusionProcCode3(c,10100217,10100220,10100221,true,true)
	c:EnableReviveLimit()
	--Synchro Limit
	local e1=bbts.bohrokvakaita_synchrolimit(c)
	c:RegisterEffect(e1)
	--Switch
	local e2=bbts.bohrokvakaita_switch(c)
	c:RegisterEffect(e2)
	--Search
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(c10100230.operation3)
	c:RegisterEffect(e3)
end
function c10100230.operation3(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsPreviousLocation(LOCATION_ONFIELD) then
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetDescription(aux.Stringid(10100230,1))
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetCondition(c10100230.condition3_1)
    e1:SetTarget(c10100230.target3_1)
    e1:SetOperation(c10100230.operation3_1)
    e1:SetCountLimit(1,10100230)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
  end
end
function c10100230.filter3_1(c)
	return (c:IsSetCard(0x15c) or c:IsSetCard(0x15d)) and c:IsAbleToHand()
end
function c10100230.condition3_1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c10100230.target3_1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100230.filter3_1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10100230.operation3_1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10100230.filter3_1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
