--Sand Tarakava, Lizard Rahi
Debug.SetAIName("Unit Test")
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN,5)
Debug.SetPlayerInfo(0,8000,0,0)
Debug.SetPlayerInfo(1,8000,0,0)
Debug.AddCard(10100108,0,0,LOCATION_MZONE,2,POS_FACEUP_ATTACK)
Debug.AddCard(10100108,0,0,LOCATION_PZONE,0,POS_FACEUP_ATTACK)
Debug.AddCard(10100108,0,0,LOCATION_PZONE,1,POS_FACEUP_ATTACK)
Debug.AddCard(5318639,0,0,LOCATION_HAND,2,POS_FACEUP_ATTACK)
Debug.AddCard(5318639,1,1,LOCATION_SZONE,2,POS_FACEDOWN_ATTACK)
Debug.AddCard(23635815,1,1,LOCATION_MZONE,0,POS_FACEUP_ATTACK)
Debug.ReloadFieldEnd()
