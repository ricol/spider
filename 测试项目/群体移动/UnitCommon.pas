unit UnitCommon;

interface

uses
  Messages, Windows;

const
  WM_BEGINMOVE = WM_USER + 1;
  WM_MOVING = WM_USER + 2;
  WM_ENDMOVE = WM_USER + 3;

var
  GMoveAsGroup: boolean = false;

implementation

end.
