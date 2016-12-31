**********************************
*                                *
* SWOS Competition Patcher 0.1.1 *
*                                *
*        Author: Anoxic          *
*                                *
**********************************

Desc:
This application change SWOS Competition Structure after run SWOS on DosBox (swos pc-totalpack example).
Define structure of leagues in comp.ini file. Run SWOS (DosBox) and then run sws_cp.exe (run once).
If change comp.ini restart SWOS. 

IMPORTANT!!!  
RUN SWS_CP.EXE WITH ADMIN PRIVILEGES.

WARNING: Play-offs is not supported yet.

Competition Definition are in comp.ini file.

Structure of comp.ini file
[General]
Leagues=1	; Number of Competition Changes...
StartYear = 1998	; Start year in SWOS Career mode
Lge0 = Poland		; Competition Name for comp.ini (Any name) + Order Number
//Lge1 = Germany	; if Leagues=2 and more 

[Poland]			; Defined in Lge1
Num=28				; Number in SWOS (Probably)
Lge=PolLge			; League of Country (Any name) if Empty then Skip
Cup=PolCup			; Cup of Country (Any name) if Empty then Skip

[PolLge]			; Defined in Lge (Competition Country)
StartMonth = 7		
EndMonth =6
PointForWin =3
EachTeam=2
SubsPos=3
SubsFrom=5
DivName=PolDiv		; Name of Division (Any name)
DivNr=2

[PolDiv0]			; Defined in DivName + Order Number
Teams=18
Promoted=0
PromPO=0
Relegated=4
RelPO=0
[PolDiv1]
Teams=8
Promoted=4
PromPO=0
Relegated=0
RelPO=0

[PolCup]			; Defined in Cup (Competition Country)
StartMonth=10
EndMonth=5
Teams=16
AwayGoals=1			; NoAwayGoals = 0 or AwayGoals_90min = 1 or AwayGoals_ExtraTime = 2;
SubsPos=3
SubsFrom=5
StartRnd=5			; First Round Name (example FiFTH ROUND for Poland First Cup Round)
Rnd0=84				; First Round 
Rnd1=148			; Rounds Are Defined by Summary: PENALTY(nopenalty=0 or penalty=4 or penalty_if_replay=8)+EXTRATIME(no_extra_time=0 or extra_time=4 or extra_time_if_replay=8)+LEGS(final=0 or one_leg=64 or two_legs=128);
Rnd2=148
Rnd3=20


 