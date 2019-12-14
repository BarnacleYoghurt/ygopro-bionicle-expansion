--Bohrok Nest
function c10100224.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Protect face-down
	local e1a=Effect.CreateEffect(c)
	e1a:SetType(EFFECT_TYPE_FIELD)
	e1a:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1a:SetRange(LOCATION_FZONE)
	e1a:SetTargetRange(LOCATION_MZONE,0)
	e1a:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1a:SetTarget(aux.TargetBoolFunction(Card.IsFacedown))
	e1a:SetValue(aux.tgoval)
	c:RegisterEffect(e1a)
	local e1b=e1a:Clone()
	e1b:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1b:SetValue(c10100224.value1b)
	c:RegisterEffect(e1b)
	--Draw
	local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_DRAW)
  e2:SetDescription(aux.Stringid(10100224,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
  e2:SetCode(EVENT_TO_DECK)
	e2:SetCost(c10100224.condition2)
	e2:SetTarget(c10100224.target2)
	e2:SetOperation(c10100224.operation2)
	e2:SetCountLimit(1,10100224)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_DESTROY)
  e3:SetDescription(aux.Stringid(10100224,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c10100224.condition3)
	e3:SetTarget(c10100224.target3)
	e3:SetOperation(c10100224.operation3)
  e3:SetCountLimit(1,10100224)
	c:RegisterEffect(e3)
end
function c10100224.value1b(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c10100224.filter2(c,tp)
  return c:IsSetCard(0x15c) and c:GetOwner() == tp and c:IsPreviousPosition(POS_FACEUP) and c:IsPosition(POS_FACEDOWN)
end
function c10100224.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10100224.filter2,1,nil,tp)
end
function c10100224.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10100224.operation2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c10100224.condition3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
  return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_SZONE) and c:GetPreviousSequence()==5
end
function c10100224.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c10100224.operation3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then 
		Duel.Destroy(tc,REASON_EFFECT)
	end
end