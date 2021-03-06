--Matoran Assistant Hahli
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.condition1)
	c:RegisterEffect(e1)
	--Protect
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.target2)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--Search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.condition3)
	e3:SetTarget(s.target3)
	e3:SetOperation(s.operation3)
	e3:SetCountLimit(1)
	c:RegisterEffect(e3)
end
function s.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xb01) and c:GetCode()~=id
end
function s.condition1(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.filter1,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function s.target2(e,c)
	return c~=e:GetHandler() and c:IsSetCard(0xb01)
end
function s.filter3a(c)
	return c:IsSetCard(0xb01) and c:IsFaceup()
end
function s.filter3b(c)
	return c:IsSetCard(0xb01) and not c:IsCode(id) and c:IsAbleToHand()
end
function s.condition3(e,tp,eg,ep,ev,re,r,rp)		
	return Duel.IsExistingMatchingCard(s.filter3a,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter3b,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.GetMatchingGroup(s.filter3b,tp,LOCATION_DECK,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_DECK)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)		
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter3b,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
