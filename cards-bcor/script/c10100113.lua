--Tarakava-Nui, Lizard King Rahi
function c10100113.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x15a),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--OPT Special Summon
	c:SetSPSummonOnce(10100113)
	--PUNCH THINGS SO HARD THEY GO BACK TO THE DECK
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100113,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c10100113.target1)
	e1:SetOperation(c10100113.operation1)
	c:RegisterEffect(e1)
end
function c10100113.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_MZONE,1,nil) and e:GetHandler():IsAttackAbove(1000) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c10100113.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsFaceup() and e:GetHandler():GetAttack()>=1000 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e:GetHandler():RegisterEffect(e1)
		if tc:IsRelateToEffect(e) and not e:GetHandler():IsHasEffect(EFFECT_REVERSE_UPDATE) then
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		end
	end
end
