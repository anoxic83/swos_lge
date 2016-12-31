program swslge_patcher;

{$mode objfpc}{$H+}

uses
  Windows, Classes, sysutils, jwatlhelp32, uswslge
  { you can add units after this };

function LoadProcess(): HANDLE;
var
  PID: handle;
  HWNDWin: handle;
  snap: handle;
  procname: string;
  PrcEnt: TprocessEntry32;
  ii: LongWord;
begin
  PrcEnt.dwSize:=sizeof(TprocessEntry32);
  HWNDWin:=0;
  snap:= CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0);
  if snap<>-1 then BEGIN
  if Process32First(snap, prcent) then
   while Process32Next(snap, prcent) do begin
     if lowercase(prcent.szExeFile)='dosbox.exe' then BEGIN
        HWNDWin:=OpenProcess(PROCESS_ALL_ACCESS,false,prcent.th32ProcessID);
        ReadProcessMemory(HWNDWin,Pointer(SWSGenPtr),@SWSGenAddr,4,ii);
     end;
   end;
  END;
  CloseHandle(snap);
  if HWNDWin <> 0 then
     Result:=HWNDWin
  else begin
    Writeln('Run Sensible World of Soccer on DosBOX First');
    exit(0);
  end;
end;

procedure Help();

begin
  Writeln('SWOS Competitions Patcher v.0.1.1');
  WriteLn('Programming: AnoXic');
  //Writeln(Round(log2(32)));
end;

var
   SWSHandle: HANDLE;

{$R *.res}

begin
  Help();
  SWSHandle:=0;
  SWSHandle:=LoadProcess();
  if SWSHandle<>0 then BEGIN
     //
     Writeln(Format('SWOS General Pointer: %x',[SWSGenAddr]));
     InitializeStruct(SWSHandle);
     Writeln('Definition Successful Writed to Memory...');
  end;
  Writeln('<<< PRESS ENTER TO EXIT >>>');
  Readln;
end.

