// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_dokbmsg.sqf"
#include "..\..\x_setup.sqf"

__TRACE_1("","_this")

switch (param [0]) do {
	case 0: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"TellAirSUAttack",d_kbtel_chan]};
	case 1: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"TellAirAttackChopperAttack",d_kbtel_chan]};
	case 2: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"TellAirLightAttackChopperAttack",d_kbtel_chan]};
	case 3: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"AllObserversDown",d_kbtel_chan]};
	case 6: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"TellNrObservers",["1","",str(param [1]),[]],d_kbtel_chan]};
	case 9: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"MTRadioTower",d_kbtel_chan]};
	case 12: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,'MTSightedByEnemy',d_kbtel_chan]};
	case 15: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"CampAnnounce",["1","",str(param [1]),[]],d_kbtel_chan]};
	case 17: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"Dummy",["1","",param [1],[]],d_kbtel_chan]};
	case 18: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"TellSecondaryMTM",["1","",param [1],[]],d_kbtel_chan]};
	case 20: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"CounterattackStarts",d_kbtel_chan]};
	case 22: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"Captured3",["1","",param [1],[param [2]]],d_kbtel_chan]};
	case 23: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"TimeLimitSM",["1","","10",[]],d_kbtel_chan]};
	case 25: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"TimeLimitSM",["1","","5",[]],d_kbtel_chan]};
	case 27: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"TimeLimitSMTwoM",d_kbtel_chan]};
	case 29: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"TimeLimitSM",["1","","10",[]],d_kbtel_chan]};
	case 31: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"TimeLimitSM",["1","","5",[]],d_kbtel_chan]};
	case 33: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"TimeLimitSMTwoM",d_kbtel_chan]};
	case 35: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"MissionFailure",d_kbtel_chan]};
	case 37: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"MTRadioTowerDown",d_kbtel_chan]};
	case 42: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"Dummy",["1","",param [1],[]],d_kbtel_chan]};
	case 43: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"TellAirDropAttack",d_kbtel_chan]};
	case 44: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,param [1],d_kbtel_chan]};
	case 46: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"Lost",["1","",param [1],[param [2]]],d_kbtel_chan]};
	case 47: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"MHQDestroyed",["1","",param [1],[]],d_kbtel_chan]};
};