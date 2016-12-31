unit uswslge;

{$mode objfpc}{$H+}

interface

uses
  Windows, Classes, SysUtils, IniFiles, math;

const
  SWSGenPtr = $0074b6b0; // General Start Addr Ptr...
  SWSStructurePtr = $2c9b1c; // SWSGenPtr + SWSStructurePtr = Start Address (Albania) GetPtr to MajorLgeCupStructure
  SWSNewAddr = $7a4fe0;
  SWSYear1996 = $247EAC; //1996
  SWSYear97 = $247EB5; //97
  SWSYear94 = $22F5FA;
  SWSYear96 = $234DCE;

  SWSEuroCup : array[0..2]of Cardinal = ($2c808a, $2c9f8c, $2c81d2);

  {
  Albania: Cardinal;
  Austria: Cardinal;
  Belgum: Cardinal;
  Belarus: Cardinal;
  Bulgaria: Cardinal;
  Croatia: Cardinal;
  Cyprus: Cardinal;
  Czech: Cardinal;
  Denmark: Cardinal;
  England: Cardinal;
  Unk1: Cardinal;
  Estonia: Cardinal;
  Faroes: Cardinal;
  Finland: Cardinal;
  France: Cardinal;
  Germany: Cardinal;
  Greece: Cardinal;
  Hungary: Cardinal;
  Iceland: Cardinal;
  Ireland: Cardinal;
  Israel: Cardinal;
  Italy: Cardinal;
  Latvia: Cardinal;
  Lithuania: Cardinal;
  Luxemburg: Cardinal;
  Malta: Cardinal;
  N_Ireland: Cardinal;
  Netherlands: Cardinal;
  Norway: Cardinal;
  Poland: Cardinal;
  Portugal: Cardinal;
  Romania: Cardinal;
  Russia: Cardinal;
  SanMarino: Cardinal;
  Scotland: Cardinal;
  Slovakia: Cardinal;
  Slovenia: Cardinal;
  Spain: Cardinal;
  Sweden: Cardinal;
  Switzerland: Cardinal;
  Turkey: Cardinal;
  Ukraine: Cardinal;
  Yugoslavia: Cardinal;
  }

  SW_PENALTY = 4;
  SW_PENS_IF_R = 8;
  SW_EXTRATIME = 16;
  SW_ET_IF_R = 32;
  SW_SEC_LEG = 128;
  SW_ONE_LEG = 64;

type

  TSWSStructPtr = packed record
     StrPtrs : array[0..79]of Cardinal;
  end;


  { TSWSDivision }

  TSWSDivision = class(TPersistent)
  private
    FTeams: byte;
    FProm: byte;
    FPromPO: byte;
    FRel: byte;
    FRelPO: byte;
  public
    constructor Create;
    destructor Destroy; override;
    property Teams: byte read FTeams write FTeams;
    property Promotion: byte read FProm write FProm;
    property Promotion_PO: byte read FPromPO write FPromPO;
    property Relegation: byte read FRel write FRel;
    property Relegation_PO: byte read FrelPO write FRelPO;
  end;


  {//nr//type//teamnr//startmonth//endmonth//}

  { TSWSTourRound }

  TSWSTourRound = class(TPersistent)
    private
      Fteams: byte;
      Fgroups: byte;
      Fteambygroup: byte;
    public
      constructor Create();
      property Teams: Byte read Fteams write Fteams;
      property Groups: Byte read Fgroups write Fgroups;
      property TeamsbyGroup: Byte read Fteambygroup write Fteambygroup;
  end;


  { TSWSTournament }

  TSWSTournament = class(TPersistent)
    private
      FAddr: longword;
      FAddr2: LongWord;
      FHandle: HANDLE;
      FCompetition: byte;
      FSkip: Boolean;
      FStartRnd: byte;
      FTeams: byte;
      FType: byte;
      FTeamNr: byte;
      FBMonth: byte;
      FEMonth: byte;
      FUnkn0: DWord;  // Read and Copy
      FNameAddr1: byte;
      FnameAddr2: byte;
      FUnkx: byte;
      FTeamAddr: byte;
      FUnkn1: byte;   // SetTo 1
      FAwayGoal: byte;
      FMatEach: byte;
      Fpts: byte;
      FPosSubs: byte;
      FRoundNum: byte;
      FTRounds: Array of TSWSTourRound;
      FUnkn2: Dword;
      FUnkn3: Byte;
      FCRounds: array of Byte;
      FUnkn4: Byte;
      FNamePtr: Cardinal; // ChairmanScenes if 0;
      FPtr1: Cardinal;
      FTeamsPtr: Pbyte;
      FCRnd: Byte;
      function GetCupRound(idx: integer): byte;
      function GetTourRnd(idx: integer): TSWSTourRound;
      procedure SetCupRound(idx: integer; AValue: byte);
      procedure SetTourRnd(idx: integer; AValue: TSWSTourRound);
    public
      constructor Create(hPrc: HANDLE);
      destructor Destroy; override;
      procedure ReadData();
      procedure WriteData();
      procedure SetTourRounds(I: Integer);
      procedure SetCupRounds(I: INteger);
      procedure SetTeamsDta(Teams: Byte);
      property Teams: byte read FTeams write FTeams;
      property Competition: byte read FCompetition write FCompetition;
      property CmpType: byte read FType;
      property BeginMonth: byte read FBMonth write FBMonth;
      property EndMonth: byte read FEMonth write FEMonth;
      property PossibleSubs: byte read FPosSubs write FPosSubs;
      property MatchEachTime: byte read FMatEach write FMatEach;
      property CupRound[idx: integer]: byte read GetCupRound write SetCupRound;
      property TourRound[idx: integer]: TSWSTourRound read GetTourRnd write SetTourRnd;
      property AwayGoals: byte read FAwayGoal write FAwayGoal;
      property StartRound: byte read FStartRnd write FStartRnd;
      property RoundNum: byte read FRoundNum write FRoundNum;
      property PtsForWin: byte read Fpts write Fpts;
      property Address: longword read FAddr write FAddr;
      property TeamNr: byte read FTeamNr write FTeamNr;
      property EndAddress: LongWord read FAddr2;
      property Skip: Boolean read FSkip write FSkip;
      property Unkn0: Cardinal read FUnkn0 write FUnkn0;
      property NamePtr: Cardinal read FNamePtr write FNamePtr;
      property TeamsPtr: Pbyte read FTeamsPtr write FTeamsPtr;
      property CRnd: Byte read FCRnd write FCRnd;
  end;


  { TSWSLeague }

  TSWSLeague = class(TPersistent)
  private
    FAddr: longword;
    FAddr2: LongWord;
    FCompetition: byte;
    FHandle: HANDLE;
    FLeagues: byte;
    FType: byte;
    FTeamNr: byte;
    FBMonth: byte;
    FEMonth: byte;
    FMatEach: byte;
    Fpts: byte;
    FPosSubs: byte;
    FDivs: array of TSWSDivision;
    FSkip: Boolean;
    function GetDiv(idx: integer): TSWSDivision;
    procedure SetDiv(idx: integer; AValue: TSWSDivision);
    procedure ReadDta;
  public
    constructor Create(hPrc: HANDLE);
    destructor Destroy; override;
    procedure ReadData;
    procedure WriteData(FN: string = '');
    procedure SetDivisionsNr(I: Integer);
    property Leagues: byte read FLeagues write FLeagues;
    property Competition: byte read FCompetition write FCompetition;
    property CmpType: byte read FType;
    property SWSTeamNr: byte read FTeamNr;
    property BeginMonth: byte read FBMonth write FBMonth;
    property EndMonth: byte read FEMonth write FEMonth;
    property MatchEachTime: byte read FMatEach write FMatEach;
    property PtsForWin: byte read Fpts write Fpts;
    property PossibleSubs: byte read FPosSubs write FPosSubs;
    property Division[idx: integer]: TSWSDivision read GetDiv write SetDiv;
    property Address: longword read FAddr write FAddr;
    property TeamNr: byte read FTeamNr write FTeamNr;
    property EndAddress: LongWord read FAddr2;
    property Skip: Boolean read FSkip write FSkip;
  end;

  { TSWSCup }

  TSWSCup = class(TPersistent)
    private
      FAddr: longword;
      FAddr2: Longword;
      FHandle: HANDLE;
      FCompetition: byte;
      FType: byte;
      FTeamNr: byte;
      FBMonth: byte;
      FEMonth: byte;
      FUnk: DWORD;
      FUnk2: byte;
      FTeams: byte;
      FAwayGoals: byte;
      FPosSubs: byte;
      FStartRnd: byte;
      FRounds: array of byte;
      FSkip: Boolean;
      function GetRound(idx: integer): byte;
      procedure SetRound(idx: integer; AValue: byte);
    public
      constructor Create(hPrc: HANDLE);
      destructor Destroy; override;
      procedure ReadData;
      procedure WriteData(FN: string = '');
      procedure SetRoundsNr(I: Integer);
      property Teams: byte read FTeams write FTeams;
      property Competition: byte read FCompetition write FCompetition;
      property CmpType: byte read FType;
      property BeginMonth: byte read FBMonth write FBMonth;
      property EndMonth: byte read FEMonth write FEMonth;
      property PossibleSubs: byte read FPosSubs write FPosSubs;
      property Round[idx: integer]: byte read GetRound write SetRound;
      property AwayGoals: byte read FAwayGoals write FAwayGoals;
      property StartRound: byte read FStartRnd write FStartRnd;
      property Address: longword read FAddr write FAddr;
      property TeamNr: byte read FTeamNr write FTeamNr;
      property EndAddress: LongWord read FAddr2;
      property Skip: Boolean read FSkip write FSkip;
  end;

  { TSWSComp }

  TSWSComp = class(TPersistent)
    private
      FAddr: Cardinal;
      FSaveAddr: Cardinal;
      FPrc: HANDLE;
      FLgeAddr: Cardinal;
      FCupAddr: Cardinal;
      FLeague: TSWSLeague;
      FCup: TSWSCup;
    public
      constructor Create(addr: Cardinal; hPrc: HANDLE);
      destructor Destroy; override;
      procedure ReadComp();
      procedure WriteComp();
      property League: TSWSLeague read FLeague write FLeague;
      property Cup: TSWSCup read FCup write FCup;
      property SaveAddr: Cardinal read FSaveAddr write FSaveAddr;
  end;


function ReadStructAddr(hPrc: HANDLE): Cardinal;
function InitializeStruct(hPrc: HANDLE): Boolean;

var
  //Global Vars
  SWSGenAddr: Cardinal;
  SWSStructAddr: Cardinal;
  SWSStructPtr: TSWSStructPtr;
  CompFile: TIniFile;
  //Leagues...
  ILeagues: Integer;
  ILeagueNames: array of String;
  ICompetitions: array of TSWSComp;
  ICL: TSWSTournament;
implementation

function ReadStructAddr(hPrc: HANDLE): Cardinal;
begin
  //ReadProcessMemory(hPrc,Pointer(SWSGenAddr+SWSStructurePtr),@Result,4,nil);
  Result:=SWSGenAddr+SWSStructurePtr;
end;

function InitializeStruct(hPrc: HANDLE): Boolean;
var
  a,x, tmpnr: integer;
  tmpstr, divstr: String;
  PS,fS, CR: byte;
  SWSNA: Cardinal;
  Rnds: Integer;
  SYW: Word;
  SYB: Byte;
  SWW: word;
  Ftmp: Cardinal;
  IFS: TFileStream;
begin
  Writeln('Read Structures Pointers...');
  SWSStructAddr:=ReadStructAddr(hPrc);
  Writeln(Format('Begin of Competitions Pointers: 0x%x',[SWSStructAddr]));
  ReadProcessMemory(hPrc,Pointer(SWSStructAddr),@SWSStructPtr, Sizeof(TSWSStructPtr),nil);
  CompFile:=TIniFile.Create('comp.ini');
  SWSNA:=SWSNewAddr + SWSGenAddr;
  //CL
  if CompFile.SectionExists('CL') then BEGIN
  Writeln('=========== Start European ChampionShip Cup ===========');
  ICL:=TSWSTournament.Create(hPrc);
  ReadProcessMemory(hPrc,Pointer(SWSEuroCup[0]+SWSGenAddr),@FTmp,4,nil);
  Writeln(Format('Actual European Championship Cup Ptr Addr: 0x%x, readed from: 0x%x',[FTmp, SWSGenAddr+SWSEuroCup[0]]));
  ReadProcessMemory(hPrc,Pointer(FTmp+SWSGenAddr+5),@ICL.Unkn0,4,nil);
  ReadProcessMemory(hprc,Pointer(Ftmp+SWSGenAddr+$27),@ICL.NamePtr,4,nil);
  ICL.BeginMonth:=(CompFile.ReadInteger('CL','StartMonth',8)-1)*8;
  ICL.EndMonth:=(CompFile.ReadInteger('CL','EndMonth',6)-1)*8;
  ICL.PtsForWin:=CompFile.ReadInteger('CL','PointForWin',3);
  ICL.MatchEachTime:=CompFile.ReadInteger('CL','EachTeam',2);
  ICL.AwayGoals:=CompFile.ReadInteger('CL','AwayGoals',1);
  pS:=CompFile.ReadInteger('CL','SubsPos',3);
  FS:=CompFile.ReadInteger('CL','SubsFrom',5);
  ICL.PossibleSubs:=PS*16+FS;
  ICL.RoundNum:=CompFile.ReadInteger('CL','Rounds',4);
  ICL.SetTourRounds(ICL.RoundNum);
  ICL.CRnd:=CompFile.ReadInteger('CL','CupRnds',3);
  ICL.SetCupRounds(ICL.CRnd);
  ICL.Address:=SWSNA;
  for a:=0 to ICL.RoundNum-1 do begin
    ICL.TourRound[a].Teams:=CompFile.ReadInteger('CL','TRndA'+IntToStr(a),2);
    ICL.TourRound[a].Groups:=CompFile.ReadInteger('CL','TRndB'+IntToStr(a),2);
    ICL.TourRound[a].TeamsbyGroup:=CompFile.ReadInteger('CL','TRndC'+IntToStr(a),2);
  end;
  for x:=0 to ICL.CRnd-1 do
      ICL.CupRound[x]:=CompFile.ReadInteger('CL','CRnd'+IntToStr(x),0);
  //
  ICL.Teams:=CompFile.ReadInteger('CL','TeamsCnt',16);
  tmpstr:=CompFile.ReadString('CL','TeamsBin','');
  ICL.SetTeamsDta(ICL.Teams);
  if tmpstr<>'' then BEGIN
     IFS:=TFileStream.Create(tmpstr,fmOpenRead);
     a:=IFS.Read(ICL.TeamsPtr^,(ICL.Teams*2));
     Writeln(Format('Readed Team bin File: %s ,bytes read %d',[tmpstr,a]));
     IFS.Free;
  end;
  ICL.WriteData();
  SWSNA:=ICL.EndAddress;
  For x:=0 to 2 do begin
      Ftmp:=ICL.Address-SWSGenAddr;
      WriteProcessMemory(hPrc,Pointer(SWSGenAddr+SWSEuroCup[x]),@Ftmp,4,nil);
      Writeln(Format('Write new European Championship Cup Ptr Addr: 0x%x, readed from: 0x%x (Relative: %x)',[ICL.Address, SWSGenAddr+SWSEuroCup[x],Ftmp]));
  end;
  Writeln(Format('End of ECC Exit Address: 0x%x',[SWSNA]));
  Writeln('=========== End European ChampionShip Cup ===========');
  end else begin
      Writeln('Skip European ChampionShip Cup');
  end;  // END CL

  //COMP
  ILeagues:=CompFile.ReadInteger('General','Leagues',0);
  Writeln('Read Defines File...');
  Writeln(Format('Defined Leagues: %d',[ILeagues]));
  SetLength(ILeagueNames,ILeagues);
  SetLength(ICompetitions,ILeagues);

  For a:=0 to ILeagues-1 do BEGIN
    //Read Leagues from INI...
    ILeagueNames[a]:=CompFile.ReadString('General','Lge'+IntToStr(a),'');
    SYW:=CompFile.ReadInteger('General','StartYear',1996);
    SWw:=(SYW div 100)*100;
    SYB:=SYW-SWW;
    WriteProcessMemory(hPrc,Pointer(SWSGenAddr+SWSYear1996),@SYW,2,nil);
    WriteProcessMemory(hPrc,Pointer(SWSGenAddr+SWSYear96),@SYB,1,nil);
    SYB+=1;
    WriteProcessMemory(hPrc,Pointer(SWSGenAddr+SWSYear97),@SYB,1,nil);
    Writeln(Format('Change SWOS Start Year to : %d/%d',[SYW,SYB]));
    tmpnr:=CompFile.ReadInteger(ILeagueNames[a],'Num',-1);
    if SWSStructPtr.StrPtrs[tmpnr]=0 then begin
       Writeln('SWS Struct Adress Unknown');
       exit;
    end;
    ICompetitions[a]:=TSWSComp.Create(SWSStructPtr.StrPtrs[tmpnr]+SWSGenAddr, hPrc);
    Writeln(Format('========== Begin %s ==========',[ILeagueNames[a]]));
    Writeln(Format('Read Competition for %s as number %d and address(rel): 0x%x',[ILeagueNames[a],tmpnr,SWSStructPtr.StrPtrs[tmpnr]]));
    ICompetitions[a].ReadComp(); // Read Comp Nr...
    ICompetitions[a].SaveAddr:=SWSNA;
    tmpstr:=CompFile.ReadString(ILeagueNames[a],'Lge','');
    //ICompetitions[a].League.Address:=SWSNA;
    if tmpstr<>'' then begin // READ LEAGUE
      ICompetitions[a].League.Skip:=false;
      ICompetitions[a].League.BeginMonth:=(CompFile.ReadInteger(tmpstr,'StartMonth',8)-1)*8;
      ICompetitions[a].League.EndMonth:=(CompFile.ReadInteger(tmpstr,'EndMonth',6)-1)*8;
      ICompetitions[a].League.PtsForWin:=CompFile.ReadInteger(tmpstr,'PointForWin',3);
      ICompetitions[a].League.MatchEachTime:=CompFile.ReadInteger(tmpstr,'EachTeam',2);
      pS:=CompFile.ReadInteger(tmpstr,'SubsPos',3);
      FS:=CompFile.ReadInteger(tmpstr,'SubsFrom',5);
      ICompetitions[a].League.PossibleSubs:=PS*16+FS;
      ICompetitions[a].League.Leagues:=CompFile.ReadInteger(tmpstr,'DivNr',1);
      divstr:=CompFile.ReadString(tmpstr,'DivName','');
      Writeln(Format('Read Data from Division name: %s',[divstr]));
      ICompetitions[a].League.SetDivisionsNr(ICompetitions[a].League.Leagues);
         For x:=0 to ICompetitions[a].League.Leagues-1 do BEGIN
           with ICompetitions[a].League do begin
             Division[x].Teams:=CompFile.ReadInteger(divstr+inttostr(x),'Teams',10);
             Division[x].Promotion:=CompFile.ReadInteger(divstr+inttostr(x),'Promoted',0);
             Division[x].Promotion_PO:=CompFile.ReadInteger(divstr+inttostr(x),'PromPO',0);
             Division[x].Relegation:=CompFile.ReadInteger(divstr+inttostr(x),'Relegated',0);
             Division[x].Relegation_PO:=CompFile.ReadInteger(divstr+inttostr(x),'RelPO',0);
           end;
      end;
    end else begin
        Writeln(Format('Skip League for %s',[ILeagueNames[a]]));
        ICompetitions[a].League.Skip:=true;
    end;     // END READ LEAGUE

    tmpstr:=CompFile.ReadString(ILeagueNames[a],'Cup','');
    ICompetitions[a].Cup.Address:=SWSNA;
    if tmpstr<>'' then BEGIN
      ICompetitions[a].Cup.Skip:=false;
      ICompetitions[a].Cup.BeginMonth:=(CompFile.ReadInteger(tmpstr,'StartMonth',8)-1)*8;
      ICompetitions[a].Cup.EndMonth:=(CompFile.ReadInteger(tmpstr,'EndMonth',6)-1)*8;
      ICompetitions[a].Cup.Teams:=CompFile.ReadInteger(tmpstr,'Teams',16);
      ICompetitions[a].Cup.AwayGoals:=CompFile.ReadInteger(tmpstr,'AwayGoals',1);
      pS:=CompFile.ReadInteger(tmpstr,'SubsPos',3);
      FS:=CompFile.ReadInteger(tmpstr,'SubsFrom',5);
      ICompetitions[a].Cup.PossibleSubs:=PS*16+FS;
      ICompetitions[a].Cup.StartRound:=CompFile.ReadInteger(tmpstr,'StartRnd',1);
      Rnds:=Round(log2(ICompetitions[a].Cup.Teams));
      Writeln(Format('Read Data for %d Cup Rounds, Teams Count: %d',[Rnds, ICompetitions[a].Cup.Teams]));
      ICompetitions[a].Cup.SetRoundsNr(Rnds);
      for x:=0 to  Rnds-1 do
          ICompetitions[a].Cup.Round[x]:=CompFile.ReadInteger(tmpstr,'Rnd'+IntToStr(x),0);
    end else begin
        Writeln(Format('Skip Cup for %s',[ILeagueNames[a]]));
        ICompetitions[a].Cup.Skip:=true;
    end;    // END READ CUP

    Writeln(Format('Write League Data for %s',[ILeagueNames[a]]));
    ICompetitions[a].WriteComp();
    SWSNA:=ICompetitions[a].SaveAddr;
    Writeln(Format('End of League Exit Address: 0x%x',[SWSNA]));


    Writeln(Format('=========== End %s ===========',[ILeagueNames[a]]));
  end;  // end of for a:=0
end;

{ TSWSTourRound }

constructor TSWSTourRound.Create;
begin

end;

{ TSWSTournament }

function TSWSTournament.GetCupRound(idx: integer): byte;
begin
  Result:=FCRounds[idx];
end;

function TSWSTournament.GetTourRnd(idx: integer): TSWSTourRound;
begin
  Result:=FTRounds[idx];
end;

procedure TSWSTournament.SetCupRound(idx: integer; AValue: byte);
begin
  FCRounds[idx]:=AValue;
end;

procedure TSWSTournament.SetTourRnd(idx: integer; AValue: TSWSTourRound);
begin
  FTRounds[idx]:=AValue;
end;

constructor TSWSTournament.Create(hPrc: HANDLE);
begin
  FHandle:=hPrc;
  Ftype:=2;
end;

destructor TSWSTournament.Destroy;
begin
  FreeMem(FTeamsPtr);
  inherited Destroy;
end;

procedure TSWSTournament.ReadData;
begin

end;

procedure TSWSTournament.WriteData;
var
   Dta0: byte;
   Dta1: Longword;
   x: integer;
   Rnd: Integer;
begin
   Writeln(Format('Write to Addr: 0x%x',[FAddr]));
   FAddr2:=FAddr;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@FCompetition,1,nil);
   FAddr2+=1;
   Dta0:=1;
   Dta1:=0;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@FType,1,nil);
   FAddr2+=1;
   FTeamNr:=$ff;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@TeamNr,1,nil);
   Writeln(Format('Write TeamNr: 0x%x',[TeamNr]));
   FAddr2+=1;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@BeginMonth,1,nil);
   Writeln(Format('Write Begin Month: 0x%x',[BeginMonth]));
   FAddr2+=1;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@EndMonth,1,nil);
   Writeln(Format('Write End Month: 0x%x',[EndMonth]));
   FAddr2+=1;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@Unkn0,3,nil);
   Writeln(Format('Write Unknown Data: 0x%x',[Unkn0]));
   FAddr2+=3;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@Dta0,1,nil);
   FAddr2+=1;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@Dta0,1,nil);
   FAddr2+=1;
   Dta0:=0;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@FAwayGoal,1,nil);
   FAddr2+=1;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@FMatEach,1,nil);
   FAddr2+=1;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@Fpts,1,nil);
   FAddr2+=1;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@FPosSubs,1,nil);
   Writeln(Format('Write Substitutes: 0x%x',[FPosSubs]));
   FAddr2+=1;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@FRoundNum,1,nil);
   Writeln(Format('Write Rounds : 0x%x',[FRoundNum]));
   FAddr2+=1;
   For x:=0 to FRoundNum-1 do begin
     WriteProcessMemory(FHandle,Pointer(FAddr2),@FTRounds[x].Fteams,1,nil);
     FAddr2+=1;
     WriteProcessMemory(FHandle,Pointer(FAddr2),@FTRounds[x].Fgroups,1,nil);
     FAddr2+=1;
     WriteProcessMemory(FHandle,Pointer(FAddr2),@FTRounds[x].Fteambygroup,1,nil);
     FAddr2+=1;
   end;
   Dta1:=1;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@Dta1,1,nil);
   FAddr2+=4;
   Dta1:=0;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@Dta1,4,nil);
   FAddr2+=4;
   For x:=0 to FCRnd-1 do begin
     WriteProcessMemory(FHandle,Pointer(FAddr2),@FCRounds[x],1,nil);
     FAddr2+=1;
   end;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@Dta0,1,nil);
   FAddr2+=1;
   FUnkn1:=FAddr2-(FAddr+5);
   WriteProcessMemory(FHandle,Pointer(FAddr+5),@FUnkn1,1,nil);
   WriteProcessMemory(FHandle,Pointer(FAddr2),@FNamePtr,4,nil);
   FAddr2+=4;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@Dta1,4,nil);
   FAddr2+=4;
   FUnkn1:=FAddr2-(FAddr+7);                                                                                             B
   WriteProcessMemory(FHandle,Pointer(FAddr+7),@FUnkn1,1,nil);
   WriteProcessMemory(FHandle,Pointer(FAddr2),@FTeamsPtr^,(Teams*2),nil);
   FAddr2:=FAddr2+(Teams*2);
end;

procedure TSWSTournament.SetTourRounds(I: Integer);
var
  k: integer;
begin
  SetLength(FTRounds,I);
  for k:=0 to i-1 do
      FTRounds[k]:=TSWSTourRound.Create;
end;

procedure TSWSTournament.SetCupRounds(I: INteger);
begin
  SetLength(FCRounds,I);
end;

procedure TSWSTournament.SetTeamsDta(Teams: Byte);
begin
  Getmem(FTeamsPtr,Teams*2);
end;



{ TSWSCup }

function TSWSCup.GetRound(idx: integer): byte;
begin
     Result:=FRounds[idx];
end;

procedure TSWSCup.SetRound(idx: integer; AValue: byte);
begin
     FRounds[idx]:=AValue;
end;

constructor TSWSCup.Create(hPrc: HANDLE);
begin
   FHandle:=hPrc;
   FType:=1;
   FTeamNr:=$ff;
end;

destructor TSWSCup.Destroy;
begin
  inherited Destroy;
end;

procedure TSWSCup.ReadData;
begin

end;

procedure TSWSCup.WriteData(FN: string);
var
   Dta0: byte;
   Dta1: Longword;
   x: integer;
   Rnd: Integer;
begin
   Writeln(Format('Write to Addr: 0x%x',[FAddr]));
   FAddr2:=FAddr;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@FCompetition,1,nil);
   FAddr2+=1;
   Dta0:=0;
   Dta1:=0;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@FType,1,nil);
   FAddr2+=1;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@TeamNr,1,nil);
   Writeln(Format('Write TeamNr: 0x%x',[TeamNr]));
   FAddr2+=1;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@BeginMonth,1,nil);
   Writeln(Format('Write Begin Month: 0x%x',[BeginMonth]));
   FAddr2+=1;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@EndMonth,1,nil);
   Writeln(Format('Write End Month: 0x%x',[EndMonth]));
   FAddr2+=1;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@Dta1,4,nil);
   FAddr2+=4;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@Dta0,1,nil);
   FAddr2+=1;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@FTeams,1,nil);
   Writeln(Format('Write League Nr.: 0x%x',[FTeams]));
   FAddr2+=1;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@FAwayGoals,1,nil);
   FAddr2+=1;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@FPosSubs,1,nil);
   Writeln(Format('Write Substitutes: 0x%x',[FPosSubs]));
   FAddr2+=1;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@FStartRnd,1,nil);
   FAddr2+=1;
   Rnd:=trunc(log2(FTeams));
   For x:=0 to Rnd-1 do begin
     WriteProcessMemory(FHandle,Pointer(FAddr2),@FRounds[x],1,nil);
     FAddr2+=1;
   end;
end;


procedure TSWSCup.SetRoundsNr(I: Integer);
begin
     SetLength(FRounds,I);
end;

{ TSWSComp }

constructor TSWSComp.Create(addr: Cardinal; hPrc: HANDLE);
begin
     FAddr:=addr;
     FPrc:=hPrc;
     FLeague:=TSWSLeague.Create(hPrc);
     FCup:=TSWSCup.Create(hPrc);
end;

destructor TSWSComp.Destroy;
begin
  FLeague.Free;
  FCup.Free;
  inherited Destroy;
end;

procedure TSWSComp.ReadComp;
var
   FTmp: Cardinal;
   TmpCmp: Byte;

begin
  ReadProcessMemory(FPrc,Pointer(FAddr),@FLgeAddr,4,nil);
  Writeln(Format('Actual League Ptr Addr: 0x%x, readed from: 0x%x',[FLgeAddr, FAddr]));
  ReadProcessMemory(FPrc,Pointer(FAddr+8),@FCupAddr,4,nil);
  ReadProcessMemory(FPrc,Pointer(FAddr+12),@FTmp,4,nil);
  if FTmp<$fffffffe then begin
    // Is LeagueCup...
  end;
  ReadProcessMemory(FPrc,Pointer(FLgeAddr+SWSGenAddr),@TmpCmp,1,nil);
  FLeague.Competition:=TmpCmp;
  Writeln(Format('Actual League Competition Nr: %d',[TmpCmp]));
  ReadProcessMemory(FPrc,Pointer(FLgeAddr+SWSGenAddr+2),@TmpCmp,1,nil);
  FLeague.TeamNr:=TmpCmp;
  Writeln(Format('Actual League Team Nr: %d',[TmpCmp]));
  ReadProcessMemory(FPrc,Pointer(FCupAddr+SWSGenAddr),@TmpCmp,1,nil);
  FCup.Competition:=TmpCmp;
  Writeln(Format('Actual Cup Competition Nr: %d',[TmpCmp]));
  ReadProcessMemory(FPrc,Pointer(FCupAddr+SWSGenAddr+2),@TmpCmp,1,nil);
  FCup.TeamNr:=TmpCmp;
  Writeln(Format('Actual Cup Team Nr: %d',[TmpCmp]));
end;

procedure TSWSComp.WriteComp;
var
   TmpD: LongWord;
begin
  if not FLeague.Skip then BEGIN
  FLeague.Address:=FSaveAddr;
  FLeague.WriteData();
  TmpD:=FLeague.Address-SWSGenAddr;
  WriteProcessMemory(FPrc,Pointer(FAddr),@(TmpD),4,nil);
  Writeln(Format('Save new pointer to League at: 0x%x (rel: 0x%x) in struct addr: 0x%x',[FLeague.Address,FLeague.Address-SWSGenAddr, FAddr]));
  FSaveAddr:=FLeague.EndAddress+4;
  end;
  if not FCup.Skip then BEGIN
  FCup.Address:=FSaveAddr;
  FCup.WriteData();
  TmpD:=FCup.Address-SWSGenAddr;
  WriteProcessMemory(FPrc,Pointer(FAddr+8),@(TmpD),4,nil);
  Writeln(Format('Save new pointer to cup at: 0x%x (rel: 0x%x) in struct addr: 0x%x',[FCup.Address,FCup.Address-SWSGenAddr, FAddr]));
  FSaveAddr:=FCup.EndAddress+4;
  end;
end;



{ TSWSDivision }

constructor TSWSDivision.Create;
begin

end;

destructor TSWSDivision.Destroy;
begin
  inherited Destroy;
end;

{ TSWSLeague }

function TSWSLeague.GetDiv(idx: integer): TSWSDivision;
begin
  if FDivs[idx]<>nil then
  Result:=FDivs[idx];
end;

procedure TSWSLeague.SetDiv(idx: integer; AValue: TSWSDivision);
begin
  if FDivs[idx]<>nil then
  FDivs[idx]:=AValue;
end;

procedure TSWSLeague.ReadDta;
begin

end;

constructor TSWSLeague.Create(hPrc: HANDLE);
begin
     FHandle:=hPRC;
     FType:=0;
end;

destructor TSWSLeague.Destroy;
begin
  inherited Destroy;
end;

procedure TSWSLeague.ReadData;
begin
end;

procedure TSWSLeague.WriteData(FN: string);
var
   Dta0: byte;
   Dta1: Longword;
   x: integer;
begin
   Writeln(Format('Write to Addr: 0x%x',[FAddr]));
   FAddr2:=FAddr;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@FCompetition,1,nil);
   FAddr2+=1;
   Dta0:=0;
   Dta1:=0;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@FType,1,nil);
   FAddr2+=1;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@TeamNr,1,nil);
   Writeln(Format('Write TeamNr: 0x%x',[TeamNr]));
   FAddr2+=1;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@BeginMonth,1,nil);
   Writeln(Format('Write Begin Month: 0x%x',[BeginMonth]));
   FAddr2+=1;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@EndMonth,1,nil);
   Writeln(Format('Write End Month: 0x%x',[EndMonth]));
   FAddr2+=1;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@Dta1,4,nil);
   FAddr2+=4;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@FLeagues,1,nil);
   Writeln(Format('Write League Nr.: 0x%x',[FLeagues]));
   FAddr2+=1;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@FMatEach,1,nil);
   FAddr2+=1;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@Fpts,1,nil);
   FAddr2+=1;
   WriteProcessMemory(FHandle,Pointer(FAddr2),@FPosSubs,1,nil);
   Writeln(Format('Write Substitutes: 0x%x',[FPosSubs]));
   FAddr2+=1;
   For x:=0 to FLeagues-1 do begin
        WriteProcessMemory(FHandle,Pointer(FAddr2),@FDivs[x].Teams,1,nil);
           Writeln(Format('Write Teams %d Division: %d',[x,FDivs[x].Teams]));
        FAddr2+=1;
        WriteProcessMemory(FHandle,Pointer(FAddr2),@FDivs[x].Promotion,1,nil);
        FAddr2+=1;
        WriteProcessMemory(FHandle,Pointer(FAddr2),@FDivs[x].Promotion_PO,1,nil);
        FAddr2+=1;
        WriteProcessMemory(FHandle,Pointer(FAddr2),@FDivs[x].Relegation,1,nil);
        FAddr2+=1;
        WriteProcessMemory(FHandle,Pointer(FAddr2),@FDivs[x].Relegation_PO,1,nil);
        FAddr2+=1;
        WriteProcessMemory(FHandle,Pointer(FAddr2),@Dta0,1,nil);
        FAddr2+=1;
   end;
end;

procedure TSWSLeague.SetDivisionsNr(I: Integer);
var
   a: integer;
begin
  SetLength(FDivs,I);
  For a:=0 to I-1 do
      FDivs[a]:=TSWSDivision.Create;
end;

end.

