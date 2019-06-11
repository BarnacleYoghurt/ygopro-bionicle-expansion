BBTS={}
bbts=BBTS
--Bohrok Flip
function BBTS.bohrok_flip(baseC)
  local function filter(c,e,tp)
    return c:IsSetCard(0x15c) and c:GetLevel()==4 and not c:IsCode(baseC:GetCode()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
  end
  local function target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
      return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(filter,tp,LOCATION_DECK,0,1,nil,e,tp) 
    end
    local g=Duel.GetMatchingGroup(filter,tp,LOCATION_DECK,0,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
  end
  function operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.SelectMatchingCard(tp,filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount() > 0 then
      Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
      Duel.ConfirmCards(1-tp,g)
    end
  end
  local e=Effect.CreateEffect(baseC)
	e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e:SetProperty(EFFECT_FLAG_DELAY)
	e:SetTarget(target)
	e:SetOperation(operation)
	return e
end
--Krana
function BBTS.krana_equip(baseC)
	local function filter(c)
		return c:IsFaceup() and c:IsSetCard(0x15c) and c:IsLevelAbove(4)
	end
	local function target(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.IsExistingTarget(filter,tp,LOCATION_MZONE,0,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		Duel.SelectTarget(tp,filter,tp,LOCATION_MZONE,0,1,1,nil)
	end
	local function operation(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) then return end
		local tc=Duel.GetFirstTarget()
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or not filter(tc) or not tc:IsRelateToEffect(e) then
			Duel.SendtoGrave(c,REASON_EFFECT)
			return
		end
		Duel.Equip(tp,c,tc,true)
		
		local function value_1(e,c)
			return c==e:GetLabelObject()
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetValue(value_1)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
	
	local e=Effect.CreateEffect(baseC)
	e:SetType(EFFECT_TYPE_QUICK_O)
	e:SetRange(LOCATION_HAND)
	e:SetCode(EVENT_FREE_CHAIN)
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e:SetCategory(CATEGORY_EQUIP)
	e:SetTarget(target)
	e:SetOperation(operation)
	e:SetCountLimit(1)
	return e
end
function BBTS.krana_revive(baseC)
	local function condition(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local rc=eg:GetFirst()
		return rc:IsRelateToBattle() and rc:IsSetCard(0x15c) and rc:IsFaceup() and rc:IsControler(tp)
	end
	local function cost(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if chk==0 then return c:IsAbleToRemoveAsCost() end
		Duel.Remove(c,POS_FACEUP,REASON_COST)
	end
	local function target(e,tp,eg,ep,ev,re,r,rp,chk)
		local bc=eg:GetFirst():GetBattleTarget()
		if chk==0 then return bc and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and bc:IsCanBeSpecialSummoned(e,0,tp,false,false) end
		Duel.SetTargetCard(bc)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,rc,1,0,0)
	end
	local function operation(e,tp,eg,ep,ev,re,r,rp)
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		end
	end
	
	local e=Effect.CreateEffect(baseC)
	e:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e:SetRange(LOCATION_GRAVE)
	e:SetCode(EVENT_BATTLE_DESTROYING)
	e:SetProperty(EFFECT_FLAG_DELAY)
	e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e:SetCondition(condition)
	e:SetCost(cost)
	e:SetTarget(target)
	e:SetOperation(operation)
	return e
end
function BBTS.krana_summon(baseC)
	local function filter(c,e,tp)
		return c:IsSetCard(0x15c) and c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	local function condition(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetCurrentPhase()==PHASE_MAIN1
	end
	local function cost(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
		Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
	end
	local function target(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
		local g=Duel.GetMatchingGroup(filter,tp,LOCATION_DECK,0,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end
	local function operation(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.SelectMatchingCard(tp,filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount() > 0 then
			if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK) then
				Duel.BreakEffect()
				Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetTargetRange(1,0)
				e1:SetCode(EFFECT_CANNOT_BP)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
	
	local e=Effect.CreateEffect(baseC)
	e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e:SetType(EFFECT_TYPE_IGNITION)
	e:SetRange(LOCATION_MZONE)
	e:SetCondition(condition)
	e:SetCost(cost)
	e:SetTarget(target)
	e:SetOperation(operation)
	return e
end
function BBTS.krana_condition_equipped(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	return tc and tc:IsSetCard(0x15c)
end
--Bohrok Va
function BBTS.bohrokva_selfss(baseC,reqCode)
	local function filter(c)
		return c:IsFaceup() and c:IsCode(reqCode)
	end
	local function condition(e,c)
		if c==nil then return true end
		return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
	end
	
	local e=Effect.CreateEffect(baseC)
	e:SetType(EFFECT_TYPE_FIELD)
	e:SetCode(EFFECT_SPSUMMON_PROC)
	e:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e:SetRange(LOCATION_HAND)
	e:SetCondition(condition)
	e:SetValue(1)
	e:SetCountLimit(1,baseC:GetCode())
	return e
end

function BBTS.bohrokva_krana(baseC)
	local function filter_1(c)
		return c:IsSetCard(0x15d) and c:IsFaceup() and c:IsAbleToHand()
	end
	local function target_1(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(filter_1,tp,LOCATION_REMOVED,0,1,nil) end
		local g=Duel.GetMatchingGroup(filter_1,tp,LOCATION_REMOVED,0,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	end
	local function operation_1(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.SelectMatchingCard(tp,filter_1,tp,LOCATION_REMOVED,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	local function operation(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if c:IsPreviousLocation(LOCATION_ONFIELD) then
			local e1=Effect.CreateEffect(c)
			e1:SetCategory(CATEGORY_TOHAND)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetRange(LOCATION_GRAVE)
			e1:SetTarget(target_1)
			e1:SetOperation(operation_1)
			e1:SetCountLimit(1)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
		end
	end
	
	local e=Effect.CreateEffect(baseC)
	e:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e:SetCode(EVENT_TO_GRAVE)
	e:SetOperation(operation)
	return e
end
--Bohrok Kaita
function BBTS.bohrokkaita_krana(baseC)
	local function filter(c)
		return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x15d) and c:IsAbleToGrave()
	end
	local function condition(e,tp,eg,ep,ev,re,r,rp)
		return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
	end
	local function target(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then 
			return Duel.IsExistingMatchingCard(filter,tp,LOCATION_DECK,0,1,nil) 
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		end
	end
	local function operation(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,filter,tp,LOCATION_DECK,0,1,3,nil)
		if g:GetCount()>0 then
			Duel.ConfirmCards(1-tp,g)
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_EQUIP)
			local eg=g:Select(1-tp,1,1,nil)
			if eg:GetCount()>0 then
				local ec=eg:GetFirst()
				if Duel.Equip(tp,ec,c,true) then
					local function value_1(e,c)
						return c==e:GetLabelObject()
					end
					local e1=Effect.CreateEffect(ec)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_EQUIP_LIMIT)
					e1:SetValue(value_1)
					e1:SetLabelObject(c)
					e1:SetReset(RESET_EVENT+0x1fe0000)
					ec:RegisterEffect(e1)
					g:RemoveCard(ec)
				end
			end
			if g:GetCount()>0 then
				Duel.SendtoGrave(g,REASON_EFFECT)
			end
		end
	end
	
	local e=Effect.CreateEffect(baseC)
	e:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e:SetCode(EVENT_SPSUMMON_SUCCESS)
	e:SetCondition(condition)
	e:SetTarget(target)
	e:SetOperation(operation)
	return e
end
function BBTS.bohrokkaita_ss(baseC)
	local function filter(c,e,tp)
		return c:IsSetCard(0x15c) and c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	local function target(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then 
			return Duel.IsExistingMatchingCard(filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		end
		local g=Duel.GetMatchingGroup(filter,tp,LOCATION_GRAVE,0,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end
	local function operation(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.SelectMatchingCard(tp,filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount() > 0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	
	local e=Effect.CreateEffect(baseC)
	e:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e:SetCode(EVENT_LEAVE_FIELD)
	e:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e:SetTarget(target)
	e:SetOperation(operation)
	return e
end
--Bohrok Va Kaita
function BBTS.bohrokvakaita_synchrolimit(baseC)	
	function filter(c,syncard,tuner,f)
		return c:IsFaceup() and c:IsNotTuner() and c:IsCanBeSynchroMaterial(syncard,tuner) and c:IsSetCard(0x15c) and (f==nil or f(c))
	end
	function target(e,syncard,f,minc,maxc)
		local c=e:GetHandler()
		local lv=syncard:GetLevel()-c:GetLevel()
		if lv<=0 then return false end
		local g=Duel.GetMatchingGroup(filter,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
		return g:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc,maxc,syncard)
	end
	function operation(e,tp,eg,ep,ev,re,r,rp,syncard,f,minc,maxc)
		local c=e:GetHandler()
		local lv=syncard:GetLevel()-c:GetLevel()
		local g=Duel.GetMatchingGroup(filter,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local sg=g:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,minc,maxc,syncard)
		Duel.SetSynchroMaterial(sg)
	end
	local e=Effect.CreateEffect(baseC)
	e:SetType(EFFECT_TYPE_SINGLE)
	e:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e:SetTarget(target)
	e:SetValue(1)
	e:SetOperation(operation)
	return e
end
function BBTS.bohrokvakaita_switch(baseC)	
	local function filter(c,e,tp)
		return c:IsSetCard(0x15c) and c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	local function condition(e,tp,eg,ep,ev,re,r,rp)
		return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
	end
	local function cost(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():IsReleasable() end
		Duel.Release(e:GetHandler(),REASON_COST)
	end
	local function target(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
		local g=Duel.GetMatchingGroup(filter,tp,LOCATION_EXTRA,0,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end
	local function operation(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local g=Duel.SelectMatchingCard(tp,filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g:GetCount() > 0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e=Effect.CreateEffect(baseC)
	e:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e:SetRange(LOCATION_MZONE)
	e:SetCondition(condition)
	e:SetCost(cost)
	e:SetTarget(target)
	e:SetOperation(operation)
	return e
end
function bbts.bahrag_pendset(baseC)
	function condition(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():IsFaceup() and tp==Duel.GetTurnPlayer()
	end
	function target(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7) end
	end
	function operation(e,tp,eg,ep,ev,re,r,rp)
		if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) then
			Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
	local e=Effect.CreateEffect(baseC)
	e:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e:SetRange(LOCATION_EXTRA)
	e:SetCondition(condition)
	e:SetTarget(target)
	e:SetOperation(operation)
	return e
end