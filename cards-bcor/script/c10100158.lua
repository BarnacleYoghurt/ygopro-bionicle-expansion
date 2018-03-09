--Vuata Maca Tree
function c10100158.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)	
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Excavate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100158,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(c10100158.target1)
	e1:SetOperation(c10100158.operation1)
	e1:SetCountLimit(1,10100158)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100158,1))
	e2:SetCategory(CATEGROY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCondition(c10100158.condition2)
	e2:SetTarget(c10100158.target2)
	e2:SetOperation(c10100158.operation2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
end
function c10100158.filter1a(c)
	return c:IsType(TYPE_FIELD) and c:IsFaceup()
end
function c10100158.filter1b(c,e,tp,lv,exc)
	return (c:IsSetCard(0x155) or c:IsSetCard(0x156) or c:IsSetCard(0x157)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(lv) and (not exc or not exc:IsContains(c))
end
function c10100158.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,1,nil,TYPE_MONSTER) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c10100158.operation1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_MONSTER)
		local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
		local seq=-1
		local tc=g:GetFirst()
		local spcard=nil
		while tc do
			if tc:GetSequence()>seq then 
				seq=tc:GetSequence()
				spcard=tc
			end
			tc=g:GetNext()
		end
		if seq==-1 then
			Duel.ConfirmDecktop(tp,dcount)
			Duel.ShuffleDeck(tp)
			return
		end
		Duel.ConfirmDecktop(tp,dcount-seq)
		local op=-1
		if Duel.IsExistingMatchingCard(c10100158.filter1b,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,spcard:GetLevel(),nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			if spcard:IsAbleToHand() and (spcard:IsSetCard(0x155) or spcard:IsSetCard(0x156) or spcard:IsSetCard(0x157)) then
				op=Duel.SelectOption(tp,aux.Stringid(10100158,2),aux.Stringid(10100158,3))
			else
				op=0
			end 
		else
			if spcard:IsAbleToHand() and (spcard:IsSetCard(0x155) or spcard:IsSetCard(0x156) or spcard:IsSetCard(0x157)) then
				op=1
			end
		end
		if op >= 0 then
			if op == 0 then
				local lv=spcard:GetLevel()	
				local ssg=Group.CreateGroup()
				local cont=true
				while ssg:GetCount()<Duel.GetLocationCount(tp,LOCATION_MZONE) and Duel.IsExistingMatchingCard(c10100158.filter1b,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,lv,ssg) and cont do		
					local g=Duel.SelectMatchingCard(tp,c10100158.filter1b,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,lv,ssg)
					if g:GetCount()>0 then
						ssg:AddCard(g:GetFirst())
						lv=lv-g:GetFirst():GetLevel()
					end
					if ssg:GetCount()<Duel.GetLocationCount(tp,LOCATION_MZONE) and Duel.IsExistingMatchingCard(c10100158.filter1b,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,lv,ssg) then
						cont=Duel.SelectYesNo(tp,aux.Stringid(10100158,4))
					end
				end
				Duel.SpecialSummon(ssg,0,tp,tp,false,false,POS_FACEUP)
			else
				Duel.SendtoHand(spcard,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,spcard)
			end
		end
		Duel.ShuffleDeck(tp)
	end
end
function c10100158.condition2(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and not Duel.IsExistingMatchingCard(c10100158.filter1a,tp,LOCATION_SZONE,0,1,nil)
end
function c10100158.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c10100158.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
