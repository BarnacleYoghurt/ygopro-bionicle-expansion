--Fikou, Spider Rahi
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_LVCHANGE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(s.cost1)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
end
function s.filter1a(c)
	return c:IsFaceup() and c:IsSetCard(0xb06) and c:IsLevelAbove(3)
end
function s.filter1b(c,e,tp)
	return c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  Debug.Message(Duel.IsExistingTarget(s.filter1a,tp,LOCATION_MZONE,0,1,nil))
	if chk==0 then return Duel.IsExistingTarget(s.filter1a,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(s.filter1b,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.filter1a,tp,LOCATION_MZONE,0,1,1,nil)	
	Duel.SetOperationInfo(0,CATEGORY_LVCHANGE,g,1,0,0)	
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local lvc=Duel.GetFirstTarget()
	if lvc and lvc:IsRelateToEffect(e) and s.filter1a(lvc) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.filter1b,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		if lvc:RegisterEffect(e1) and g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
