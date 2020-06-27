if not bcot then
	dofile "expansions/util-bcot.lua"
end
--Noble Kanohi Rau
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
  --Destroy if replaced
  local e1=bcot.kanohi_selfdestruct(c)
  c:RegisterEffect(e1)
  --Translate 
	local e2a=Effect.CreateEffect(c)
	e2a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2a:SetCode(EVENT_CHAINING)
	e2a:SetRange(LOCATION_SZONE)
	e2a:SetCountLimit(1)
	e2a:SetCondition(s.condition2a)
	e2a:SetOperation(s.operation2a)
	c:RegisterEffect(e2a)
	local e2b=Effect.CreateEffect(c)
	e2b:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2b:SetCode(EVENT_CHAIN_SOLVING)
	e2b:SetRange(LOCATION_SZONE)
	e2b:SetCountLimit(1)
  e2b:SetCondition(s.condition2b)
	e2b:SetOperation(s.operation2b)
	c:RegisterEffect(e2b)
  --Recycle
  local e3=bcot.kanohi_revive(c,10100018)
  e3:SetDescription(aux.Stringid(id,0))
  e3:SetCountLimit(1,id)
  c:RegisterEffect(e3)
end
function s.condition2a(e,tp,eg,ep,ev,re,r,rp)
  local ec=e:GetHandler():GetEquipTarget()
	return re:IsActivated() and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):IsContains(ec)
end
function s.operation2a(e,tp,eg,ep,ev,re,r,rp)
	re:GetHandler():RegisterFlagEffect(id,RESET_CHAIN,0,1)
end
function s.condition2b(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():GetFlagEffect(id)>0
end
function s.operation2b(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,s.operation2b_1)
end
function s.filter2b_1(c)
  return c:GetSequence()<5
end
function s.operation2b_1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
  local function selectMove(mp)
    if not Duel.IsExistingMatchingCard(s.filter2b_1,mp,LOCATION_MZONE,0,1,nil) or Duel.GetLocationCount(mp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
    local g=Duel.SelectMatchingCard(mp,s.filter2b_1,mp,LOCATION_MZONE,0,1,1,nil)
    if g:GetCount()>0 then
      Duel.Hint(HINT_SELECTMSG,mp,HINTMSG_TOZONE)
      local s=Duel.SelectDisableField(mp,1,LOCATION_MZONE,0,0)
      local nseq=math.log(s,2)
      return g:GetFirst(), nseq 
    end
  end
  
  local tc1,seq1=selectMove(tp)
  local tc2,seq2=selectMove(1-tp)
  if tc1 and seq1 then
    Duel.MoveSequence(tc1,seq1)
  end
  if tc2 and seq2 then
    Duel.MoveSequence(tc2,seq2)
  end
end