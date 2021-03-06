--Utility Functions; preliminary, either move to dedicated file or replace with preexisting functions
function ExcludeIndex(t,excl)
  remainder = {}
  j = 1
  for i=1,#t do
    if i~=excl then
      remainder[j] = t[i]
      j = j+1
    end
  end
  return remainder
end
function ExcludeId(t,excl)
  remainder = {}
  for i=1,#t do
    if t[i].id~=excl then
      remainder[i] = t[i]
    else
      remainder[i] = {id=-1} --Avoid shifting positions so CurrentIndex keeps working
    end
  end
  return remainder
end
function DescOf(id,nr)
  return id*16+nr
end

C_Tahnok = 10100201
C_Gahlok= 10100202
C_Nuhvok = 10100203
C_Pahrak = 10100204
C_Kohrak = 10100205
C_Lehvak = 10100206
C_Xa = 10100207
C_Vu = 10100208
C_Yo = 10100209
C_Su = 10100210
C_Za = 10100211
C_Ca = 10100212
C_Ja = 10100213
C_Bo = 10100214
C_Beware = 10100215
C_TahnokVa = 10100216
C_GahlokVa = 10100217
C_NuhvokVa = 10100218
C_PahrakVa = 10100219
C_KohrakVa = 10100220
C_LehvakVa = 10100221
C_Confrontation = 10100222
C_Invasion = 10100223
C_Nest = 10100224
C_WakeOne = 10100225
C_WakeAll = 10100226
C_SwarmFusion = 10100227
C_KaitaZa = 10100228
C_KaitaJa = 10100229
C_VaKaitaZa = 10100230
C_VaKaitaJa = 10100231
C_Gahdok = 10100232
C_Cahdok = 10100233
C_BeforeTime = 10100234

Cs_Bohrok = {C_Tahnok, C_Gahlok, C_Nuhvok, C_Pahrak, C_Kohrak, C_Lehvak}
Cs_Krana = {C_Xa, C_Vu, C_Yo, C_Su, C_Za, C_Ca, C_Ja, C_Bo}
Cs_BohrokVa = {C_TahnokVa, C_GahlokVa, C_NuhvokVa, C_PahrakVa, C_KohrakVa, C_LehvakVa}
Cs_Kaita = {C_KaitaJa, C_KaitaZa}
Cs_VaKaita = {C_VaKaitaJa, C_VaKaitaZa}
Cs_Bahrag = {C_Gahdok, C_Cahdok}

Cs_Fusions = Merge({Cs_Kaita,Cs_VaKaita})
Cs_Monsters = Merge({Cs_Bohrok, Cs_Krana, Cs_BohrokVa, Cs_Fusions, Cs_Bahrag})
Cs_Spells = {C_Beware, C_Confrontation, C_Nest, C_SwarmFusion, C_BeforeTime}
Cs_Traps = {C_Invasion, C_WakeOne, C_WakeAll}


VaOffset = C_TahnokVa - C_Tahnok

function BohrokStartup(deck)
  deck.Init                 = BohrokInit
  deck.Card                 = BohrokCard
  deck.Chain                = BohrokChain
  deck.EffectYesNo          = BohrokEffectYesNo
  deck.YesNo                = BohrokYesNo
  --[[deck.BattleCommand        = ShaddollBattleCommand
  deck.AttackTarget         = ShaddollAttackTarget
  deck.AttackBoost          = ShaddollAttackBoost
  deck.Tribute				      = ShaddollTribute
  deck.Option               = ShaddollOption
  deck.ChainOrder           = ShaddollChainOrder
  deck.Sum                  = ShaddollSum]]
  --[[
  deck.DeclareCard
  deck.Number
  deck.Attribute
  deck.MonsterType
  ]]
  deck.ActivateBlacklist    = BohrokActivateBlacklist
  deck.SummonBlacklist      = BohrokSummonBlacklist
  deck.RepositionBlacklist  = BohrokRepoBlacklist
  deck.SetBlacklist		      = BohrokSetBlacklist
  deck.Unchainable          = BohrokUnchainable
  --[[
  
  ]]
  deck.PriorityList         = BohrokPriorityList
  
end

DECK_BOHROK = NewDeck("Bohrok",C_Beware,BohrokStartup) 

BohrokActivateBlacklist = {C_Tahnok} --Merge({Cs_Krana,{C_Beware,C_Nest,C_WakeOne,C_WakeAll,C_Invasion}}) --Merge({Cs_Monsters,Cs_Spells,Cs_Traps})
BohrokSummonBlacklist = {C_Tahnok} --Merge({Cs_Bohrok}) -- Merge({Cs_Monsters})
BohrokSetBlacklist=   {C_Tahnok} --Merge({Cs_Bohrok,Cs_BohrokVa}) -- Merge({Cs_Monsters,Cs_Spells,Cs_Traps})
BohrokRepoBlacklist= Merge({}) -- Merge({Cs_Monsters})
BohrokUnchainable= {C_WakeOne,C_WakeAll,C_Invasion} -- Merge({Cs_Traps,{C_Confrontation,C_BeforeTime}})

function IsFacedownBohrokSummonEffect(code)
  return (code >= 10100201 and code <= 10100206) -- Bohrok
    or code = 10100223 -- Bohrok Invasion
    or code = 10100231 -- Va Kaita Za
end
--Tahnok
function IsTahnokTarget(c)
  return c:IsFaceup() and c:IsDestructable()
end
function TahnokCond(loc,c)
  if loc==PRIO_TOFIELD or loc==PRIO_TOHAND then
    local e=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT)
    local rc=nil
    if e then
      rc=e:GetHandler()
      print("Checking potential Tahnok summon triggered by "..rc:GetCode())
    end
    return Duel.IsExistingMatchingCard(IsTahnokTarget,player_ai,0,LOCATION_MZONE,1,nil) -- Opponent has target for destruction effect
      and (loc==PRIO_TOFIELD or NormalSummonCheck(player_ai)) -- Can get Tahnok on the field this turn
      and not (rc and IsFacedownBohrokSummonEffect(rc:GetCode())) -- Not being summoned face-down (more general check would be nice)
  end
  return true
end

--For adding to: hand, hand+, field, field+, grave, grave+, misc, misc+, banish, banish+ (+ applies if condition false)
BohrokPriorityList={                      
--[12345678] = {1,1,1,1,1,1,1,1,1,1,XXXCond},  -- Format

-- Bohrok
[C_Tahnok]        = {5,2,5,3,1,1,1,1,1,1,TahnokCond},
[C_Gahlok]        = {1,1,1,1,1,1,1,1,1,1},
[C_Nuhvok]        = {1,1,1,1,1,1,1,1,1,1},
[C_Pahrak]        = {1,1,1,1,1,1,1,1,1,1},
[C_Kohrak]        = {1,1,1,1,1,1,1,1,1,1},
[C_Lehvak]        = {1,1,1,1,1,1,1,1,1,1},
[C_Xa]            = {1,1,1,1,1,1,1,1,1,1},
[C_Vu]            = {1,1,1,1,1,1,1,1,1,1},
[C_Yo]            = {1,1,1,1,1,1,1,1,1,1},
[C_Za]            = {1,1,1,1,1,1,1,1,1,1},
[C_Ca]            = {1,1,1,1,1,1,1,1,1,1},
[C_Ja]            = {1,1,1,1,1,1,1,1,1,1},
[C_Bo]            = {1,1,1,1,1,1,1,1,1,1},
[C_Beware]        = {1,1,1,1,1,1,1,1,1,1},
[C_TahnokVa]      = {1,1,1,1,1,1,1,1,1,1},
[C_GahlokVa]      = {1,1,1,1,1,1,1,1,1,1},
[C_NuhvokVa]      = {1,1,1,1,1,1,1,1,1,1},
[C_PahrakVa]      = {1,1,1,1,1,1,1,1,1,1},
[C_KohrakVa]      = {1,1,1,1,1,1,1,1,1,1},
[C_LehvakVa]      = {1,1,1,1,1,1,1,1,1,1},
[C_Confrontation] = {1,1,1,1,1,1,1,1,1,1},
[C_Invasion]      = {1,1,1,1,1,1,1,1,1,1},
[C_Nest]          = {1,1,1,1,1,1,1,1,1,1},
[C_WakeOne]       = {1,1,1,1,1,1,1,1,1,1},
[C_WakeAll]       = {1,1,1,1,1,1,1,1,1,1},
[C_SwarmFusion]   = {1,1,1,1,1,1,1,1,1,1},
[C_KaitaZa]       = {1,1,1,1,1,1,1,1,1,1},
[C_KaitaJa]       = {1,1,1,1,1,1,1,1,1,1},
[C_VaKaitaZa]     = {1,1,1,1,1,1,1,1,1,1},
[C_VaKaitaJa]     = {1,1,1,1,1,1,1,1,1,1},
[C_Gahdok]        = {1,1,1,1,1,1,1,1,1,1},
[C_Cahdok]        = {1,1,1,1,1,1,1,1,1,1},
[C_BeforeTime]    = {1,1,1,1,1,1,1,1,1,1}
}

function BohrokInit(cards)
  local Act = cards.activatable_cards
  local Sum = cards.summonable_cards
  local SpSum = cards.spsummonable_cards
  local Rep = cards.repositionable_cards
  local SetMon = cards.monster_setable_cards
  
  -- Set Bohrok; prioritize by DEF (Careful: Don't crowd field too much)
  if CanSetBohrok(SetMon) then
    print("Settin' Bohrok.")
    return {COMMAND_SET_MONSTER,CurrentIndex}
  end
  
  --[[if HasID(Act,C_Beware) then --Always useful, therefore first priority (Possible exception: Planned plays will leave monster in GY that can be recovered)
    print("Beware the Swarm!")
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,C_Nest,false,nil,LOCATION_ONFIELD) then --Draw
    print("Recycling via Bohrok Nest.")
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,C_Nest,false,nil,LOCATION_HAND) then --Set up early for protection
    print("Activating Bohrok Nest.")
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if CanFlipBohrok(Rep) then
    if HasID(Act,C_WakeOne,FilterPosition,POS_FACEDOWN) then
      print("Before flipping Bohrok, You Wake One...")
      return {COMMAND_ACTIVATE, CurrentIndex}
    end
    print("Flippin' Bohrok.")
    return Repo()
  end
  --Activate set Bohrok Invasion before destroying anything
  if HasID(Act,C_Invasion,FilterPosition,POS_FACEDOWN) and Duel.GetCurrentPhase()<=PHASE_BATTLE then
    print("Activating Bohrok Invasion")
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  --Remove priority targets (Boxor etc)
  UrgentRemoval = UrgentRemovalNeeded()
  if UrgentRemoval then
    for i=1,#UrgentRemoval do
      if HasID(Act,UrgentRemoval[i]) then
        return {COMMAND_ACTIVATE,CurrentIndex}
      end
      if HasID(Sum,UrgentRemoval[i]) then
        return {COMMAND_SUMMON,CurrentIndex}
      end
    end
  end
  -- Crystal Wing via Bohrok Va, if possible
  SynchroCWComm = CanSynchroCW(Sum,SpSum)
  if SynchroCWComm then
    print("Taking a step as part of the Crystal Wing Combo.")
    return {SynchroCWComm,CurrentIndex}
  end
  --Equip Krana
  for i=1,#Cs_Krana do
    if HasID(Act,Cs_Krana[i],false,nil,LOCATION_HAND,ShouldEquipKrana) then
    print("Equippin' Krana.")
      return {COMMAND_ACTIVATE,CurrentIndex}
    end
  end
  -- If opponent has negation, Summon Lehvak Va (If Lehvak in hand, should be summoned first)
  -- Flip other Bohrok
  -- Set Bohrok; prioritize by DEF (Careful: Don't crowd field too much)
  if CanSetBohrok(SetMon) then
    print("Settin' Bohrok.")
    return {COMMAND_SET_MONSTER,CurrentIndex}
  end
  -- BP: If face-down Bohrok about to be attacked, activate set If You Wake One... (also do this before manual Flip)
  if HasID(Act,C_WakeOne,FilterPosition,POS_FACEDOWN) then
    local tc=Duel.GetAttackTarget()
    if tc and tc:IsSetCard(0x15c) and tc:IsFacedown() then
      print("Before Bohrok is attacked, You Wake One...")
      return {COMMAND_ACTIVATE, CurrentIndex}
    end
  end
  --BP: Use Invasion DEF boost if it can keep attack target alive
  if HasID(Act,C_Invasion,FilterPosition,POS_FACEUP) and InvasionCanBlockAttack() then
    print("Defend with Bohrok Invasion")
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  -- EP: Search effect of If You Wake One...
  if HasID(Act,C_WakeOne,WakeOneSearchCond) then
    print("Search with If You Wake One...")
    return {COMMAND_ACTIVATE, CurrentIndex}
  end
  -- If no other way to Summon Bohrok available, do it via Krana
  for i=1,#Cs_Krana do
    if HasID(Sum,Cs_Krana[i]) then
      print("Preparing surprise Bohrok.")
      return {COMMAND_SUMMON,CurrentIndex}
    end
    if HasID(Act,Cs_Krana[i],FilterLocation,LOCATION_MZONE) then
      print("Surprise Bohrok.")
      return {COMMAND_ACTIVATE,CurrentIndex}
    end
  end
  -- Only activate ...You Wake Them All if you have at least 1 face-down Bohrok
  if HasID(Act,C_WakeAll) and Archetype_Card_Count(AIMon(),0x15c,POS_FACEDOWN) > 0 then
    print("...You Wake Them All")
    return {COMMAND_ACTIVATE,CurrentIndex}
  end--]]
  print("Default to standard behavior")
end
function BohrokCard(cards,min,max,id,c) 
  --[[if id == C_Beware then
    return Add(cards)
  end
  if id >= C_Tahnok and id <= C_Lehvak then
    if HasID(cards,10100249) then -- Take out Boxor first
      return {CurrentIndex}
    end
    local targetType=TARGET_DESTROY
    if id == C_Kohrak then
      targetType=TARGET_BANISH
    end
    return BestTargets(cards,1,targetType)
  end
  if id==C_Nest and FilterLocation(c,LOCATION_GRAVE) then
    return BestTargets(cards,1,TARGET_DESTROY)
  end-]]
end
function BohrokChain(cards, only_chains_by_player, forced)
  --[[if HasID(cards,C_WakeOne,WakeOneSearchCond) then --Search trap
    print("Search with If You Wake One...")
    return 1,CurrentIndex
  end
  if HasIDNotNegated(cards,C_Vu,false,nil,LOCATION_SZONE,ChainNegation) then --Negate targeting effect with Vu
    print("Literally Vu")
    return 1,CurrentIndex
  end--]]
end
function BohrokEffectYesNo(id, triggeringCard)
  --[[if id==C_WakeOne then --Summon extra Bohrok
    print("Summon Bohrok with If You Wake One...")
    return 1
  end
  if id>=Cs_Krana[1] and id<=Cs_Krana[#Cs_Krana] and FilterLocation(triggeringCard,LOCATION_GRAVE) then --Steal with Krana
    print("Yoinking that monster")
    return 1
  end
  if id==C_Nest and FilterLocation(triggeringCard,LOCATION_GRAVE) then --Destroy using Bohrok Nest
    print("The nest has burst.")
    return {COMMAND_ACTIVATE,CurrentIndex}
  end--]]
end
function BohrokYesNo(description_id)
  --[[print(description_id)
  if description_id==DescOf(C_Invasion,0) then
    print("Bohrok Invasion begins.")
    return 1
  end--]]
end

function CanSynchroCW(Sum,SpSum)
  if not (HasID(AIExtra(), 50954680) and Duel.IsExistingMatchingCard(IsLevel6Synchro,player_ai,LOCATION_EXTRA+LOCATION_MZONE,0,1,nil)) then --Necessary materials not present
    return false
  end
  
  if HasID(SpSum,50954680) then --Summon CW directly
    print("I can summon Crystal Wing right now!")
    return COMMAND_SPECIAL_SUMMON
  end
  if HasID(SpSum,76547525) and FieldCheck(2,FilterType,TYPE_TUNER)>=1 and HasVa(SpSum) then --Summon second tuner before summoning RW
    print("I'm summoning my second tuner to prepare for Red Wyvern -> Crystal Wing.")
    return COMMAND_SPECIAL_SUMMON
  end
  if HasID(SpSum,76547525) and FieldCheck(2,FilterType,TYPE_TUNER)>=2 then -- Summon RW with second tuner on field already
    print("I'm going to summon the material Synchro for Crystal Wing, the second tuner is on the field already.")
    return COMMAND_SPECIAL_SUMMON
  end
  if HasID(AIMon(),76547525) and HasVa(SpSum) then -- Summon second tuner with RW already on field
    print("I'm summoning my second tuner to prepare for Crystal Wing.")
    return COMMAND_SPECIAL_SUMMON
  end
  --Check if summoning two Va is possible; checking in priority order of Synchro Material Bohrok since they're assumed to be in the field so Va can be SS
  VaPrio = {C_LehvakVa,C_KohrakVa,C_TahnokVa,C_NuhvokVa,C_GahlokVa,C_PahrakVa}
  for i=1,#VaPrio do
    if HasID(SpSum,VaPrio[i]) and HasVa(ExcludeId(Sum,VaPrio[i])) then
      print("I can Summon another Va after this, so I'm Normal Summoning the first one.")
      return COMMAND_SUMMON
    end
  end
  return false
end
function IsLevel6Synchro(c)
  return c:IsType(TYPE_SYNCHRO) and c:GetLevel()==6
end
function HasVa(Cards)
  return HasID(Cards,C_LehvakVa) -- Best because negation just in case
    or HasID(Cards,C_NuhvokVa) -- Drawing also never hurts
    or HasID(Cards,C_GahlokVa) -- Same as above
    or HasID(Cards,C_PahrakVa) -- Recycle from GY
    or HasID(Cards,C_TahnokVa) -- Too luck-based, don't really need to boost level
    or HasID(Cards,C_KohrakVa) -- Won't live until BP, therefore pointless
end
function CanSetBohrok(SetMon)
  return Duel.GetLocationCount(player_ai,LOCATION_MZONE)>3 and --Make sure some space is left for subsequent swarming
    (HasID(SetMon,C_Lehvak)
    or HasID(SetMon,C_Nuhvok)
    or HasID(SetMon,C_Tahnok)
    or HasID(SetMon,C_Gahlok)
    or HasID(SetMon,C_Kohrak)
    or HasID(SetMon,C_Pahrak))
end
function CanFlipBohrok(Rep)
  return Duel.GetLocationCount(player_ai,LOCATION_MZONE)>0 and
    (HasID(Rep,C_Pahrak,FilterPosition,POS_FACEDOWN_DEFENSE)
    or HasID(Rep,C_Kohrak,FilterPosition,POS_FACEDOWN_DEFENSE)
    or HasID(Rep,C_Gahlok,FilterPosition,POS_FACEDOWN_DEFENSE)
    or HasID(Rep,C_Tahnok,FilterPosition,POS_FACEDOWN_DEFENSE)
    or HasID(Rep,C_Nuhvok,FilterPosition,POS_FACEDOWN_DEFENSE)
    or HasID(Rep,C_Lehvak,FilterPosition,POS_FACEDOWN_DEFENSE))
end
function UrgentRemovalNeeded()
  DangerIDs = {
    10100249, -- Boxor
    56832966 -- Utopia za Lightning
  }
  
  PriorityVals = {
    [C_Tahnok] = 2,
    [C_Gahlok] = 3,
    [C_Nuhvok] = 3,
    [C_Pahrak] = 5,
    [C_Kohrak] = 4,
    [C_Lehvak] = 4
  }
  
  if #OppGrave()==0 or bit32.band(OppGrave()[1].type,TYPE_MONSTER)==0 then -- No destruction effect for Gahlok
    PriorityVals[C_Gahlok] = 0
  end
  
  for i=1,#DangerIDs do
    if HasID(OppST(),DangerIDs[i],true,FilterPosition,POS_FACEUP) then
      PriorityVals[C_Tahnok] = 0
      PriorityVals[C_Nuhvok] = 6
      if #OppMon()>0 and CardsMatchingFilter(OppMon(),FilterAttackMax,1900)==0 then -- Pahrak will be able to use effect
        PriorityVals[C_Pahrak] = 0
      end
      return InPriorityOrder(Cs_Bohrok,PriorityVals)
    end
    if HasID(OppMon(),DangerIDs[i],true,FilterPosition,POS_FACEUP) then
      PriorityVals[C_Nuhvok] = 0
      if #OppMon()>0 and CardsMatchingFilter(OppMon(),FilterAttackMax,1900)==0 then -- Pahrak will be able to use effect
        PriorityVals[C_Pahrak] = 0
      end
      return InPriorityOrder(Cs_Bohrok,PriorityVals)
    end
  end
  return false
end
function InPriorityOrder(t,prio)
  ordered = {}
  for i=1,#t do
    if prio[t[i]] > 0 then
      p=1
      while ordered[p] ~= nil do
        if prio[ordered[p]] < prio[t[i]] then
          table.insert(ordered, p, nil)
        else
          p = p + 1
        end
      end
      ordered[p] = t[i]
    end
  end
  return ordered
end
function WakeOneSearchCond(c)
  return FilterPosition(c,POS_FACEUP) and (Duel.GetCurrentPhase()==PHASE_END or RemovalCheckCard(c))
end
function ShouldEquipKrana(c)
  return Duel.GetLocationCount(player_ai,LOCATION_SZONE) > 1 --Leave space in S/T Zone
    and not HasID(AIST(),c.id,true) --Don't equip same Krana twice
    and (c.id~=C_Yo or OppHasMonster()) --Don't use Yo when opp field is empty anyway
    and (c.id~=C_Za or Archetype_Card_Count(AIMon(),0x15c,POS_FACEUP)>1) --Don't use Za if you have only 1 Bohrok
    and (c.id~=C_Bo or CardsMatchingFilter(Merge({OppMon(),OppST()}),FilterPosition,POS_FACEDOWN)>0) --Don't use BO if opp has nothing face-down
end
function InvasionCanBlockAttack()
  local a=Duel.GetAttacker()
  local t=Duel.GetAttackTarget()
  return a and t --Attacker and Target both exist
    and t:IsSetCard(0x15c) and t:IsPosition(POS_FACEUP_DEFENSE) --Target is face-up Defense Position Bohrok 
    and a:GetAttack()<=t:GetDefense()+800 --DEF boost is sufficient
    and not HasID(AIST(),C_Ca,true) --Not already protected by Krana Ca (TODO: Check if protection already used up)
end
    