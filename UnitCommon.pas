unit UnitCommon;

interface

uses
  Messages, Windows, SysUtils, MMSystem;

const
  POKEWIDTH = 71;
  POKEHEIGHT = 96;
  POKETOTALCARDS = 52;
  POKETOTALKIND = 4;
  POKETOTALNUM = 13;
  MAINLENX = 80;
  MAINLENY = 10;
  MAINSTARTX = 10;
  MAINSTARTY = 5;
  MAXPOKE = 255;
  TEMPSTARTX = 680;
  TEMPSTARTY = 450;
  TEMPLENX = 10;
  TEMPLENY = 0;
  RECYCLESTARTX = 20;
  RECYCLESTARTY = 450;
  RECYCLELENX = 10;
  RECYCLELENY = 0;
  MAXMAIN = 10;
  MAXTEMP = 6;
  MAXRECYCLE = 8;
  MAXHINT = 20;
  TIMES = 5;
  STRCAPTION = '÷©÷Î';

  WM_BEGINMOVE = WM_USER + 1;
  WM_MOVING = WM_USER + 2;
  WM_ENDMOVE = WM_USER + 3;
  WM_CANMOVE = WM_USER + 4;
  WM_SENDCARDS = WM_USER + 5;

type
  TDifficulty = (EASY, MEDIUM, HARD);
  TType = (MAIN, TEMP, RECYCLE);
  THint = record
    SourcePileNumber, SourceNumber, SourceMaxIndexNumber, TargetPileNumber: integer;
  end;

var
  GDifficulty: TDifficulty = EASY;
  GMainStartX, GMainStartY, GMainLenX, GMainLenY: integer;
  GTempStartX, GTempStartY, GTempLenX, GTempLenY: integer;
  GRecycleStartX, GRecycleStartY, GRecycleLenX, GRecycleLenY: integer;
  GSoundEffect, GAnimateEffect, GAutoSaveWhenExit, GNewDifficulty,
  GAutoOpenLastGame, GShowMessageBeforeSave, GShowMessageOpenLastGame, GGameRestart: boolean;

function CanMove(Up_i, Up_j, Down_i, Down_j: integer): boolean;
procedure SoundEffect(tmpSound: string);

implementation

function CanMove(Up_i, Up_j, Down_i, Down_j: integer): boolean;
begin
  result := true;
  if Up_j <> Down_j then
  begin
    result := false;
    exit;
  end;
  if Up_i <> Down_i + 1 then
  begin
    result := false;
    exit;
  end;
end;

procedure SoundEffect(tmpSound: string);
begin
  if GSoundEffect then
    PlaySound(PChar(tmpSound), hInstance, SND_ASYNC or SND_RESOURCE);
end;

end.
