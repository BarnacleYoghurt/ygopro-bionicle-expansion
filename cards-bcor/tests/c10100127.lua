--Shore Turtle, Rahi
Debug.SetAIName("Unit Test")
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN)
Debug.SetPlayerInfo(0,8000,0,0)
Debug.SetPlayerInfo(1,8000,0,0)
Debug.AddCard(10100127,0,0,LOCATION_HAND,2,POS_FACEUP_ATTACK)
Debug.AddCard(10100127,0,0,LOCATION_MZONE,0,POS_FACEUP_ATTACK)
Debug.AddCard(4035199,0,0,LOCATION_MZONE,1,POS_FACEUP_DEFENSE)
Debug.AddCard(4035199,0,0,LOCATION_MZONE,2,POS_FACEDOWN_DEFENSE)
Debug.AddCard(10100127,0,0,LOCATION_GRAVE,2,POS_FACEUP_ATTACK)
Debug.AddCard(10100127,0,0,LOCATION_GRAVE,2,POS_FACEUP_ATTACK)
Debug.AddCard(4035199,1,1,LOCATION_MZONE,0,POS_FACEUP_ATTACK)
Debug.AddCard(4035199,1,1,LOCATION_MZONE,1,POS_FACEUP_DEFENSE)
Debug.AddCard(4035199,1,1,LOCATION_MZONE,2,POS_FACEDOWN_DEFENSE)
Debug.ReloadFieldEnd()
