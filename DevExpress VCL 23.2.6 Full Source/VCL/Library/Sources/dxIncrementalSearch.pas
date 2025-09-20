{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressEditors                                           }
{                                                                    }
{           Copyright (c) 1998-2024 Developer Express Inc.           }
{           ALL RIGHTS RESERVED                                      }
{                                                                    }
{   The entire contents of this file is protected by U.S. and        }
{   International Copyright Laws. Unauthorized reproduction,         }
{   reverse-engineering, and distribution of all or any portion of   }
{   the code contained in this file is strictly prohibited and may   }
{   result in severe civil and criminal penalties and will be        }
{   prosecuted to the maximum extent possible under the law.         }
{                                                                    }
{   RESTRICTIONS                                                     }
{                                                                    }
{   THIS SOURCE CODE AND ALL RESULTING INTERMEDIATE FILES            }
{   (DCU, OBJ, DLL, ETC.) ARE CONFIDENTIAL AND PROPRIETARY TRADE     }
{   SECRETS OF DEVELOPER EXPRESS INC. THE REGISTERED DEVELOPER IS    }
{   LICENSED TO DISTRIBUTE THE EXPRESSEDITORS AND ALL                }
{   ACCOMPANYING VCL CONTROLS AS PART OF AN EXECUTABLE PROGRAM ONLY. }
{                                                                    }
{   THE SOURCE CODE CONTAINED WITHIN THIS FILE AND ALL RELATED       }
{   FILES OR ANY PORTION OF ITS CONTENTS SHALL AT NO TIME BE         }
{   COPIED, TRANSFERRED, SOLD, DISTRIBUTED, OR OTHERWISE MADE        }
{   AVAILABLE TO OTHER INDIVIDUALS WITHOUT EXPRESS WRITTEN CONSENT   }
{   AND PERMISSION FROM DEVELOPER EXPRESS INC.                       }
{                                                                    }
{   CONSULT THE END USER LICENSE AGREEMENT FOR INFORMATION ON        }
{   ADDITIONAL RESTRICTIONS.                                         }
{                                                                    }
{********************************************************************}

unit dxIncrementalSearch; // for internal use

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Windows, Messages, dxCore, Math, Types,
  Classes, Controls, Forms, Menus, StdCtrls, SysUtils, Graphics, ImgList, RTLConsts,
  cxClasses, dxTypeHelpers,
  dxCoreClasses;

type
  TdxIncrementalSearchController = class
  strict private
    FAutoCompleteDelay: Cardinal;
    FIsRepeat: Boolean;
    FSearchText: string;
  protected
    FStartIncrementalSearch: Cardinal;
    function CanProcessIncSearch(Key: Char): Boolean; virtual;
    function DoIncrementalSearch(var Key: Char): Boolean; virtual;
    function FocusNextItemWithText(const AText: string): Boolean; virtual; abstract;
    function IsIncSearchChar(AChar: Char): Boolean; virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState);
    procedure KeyPress(var Key: Char);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    function ProcessKeyPress(var Key: Char): Boolean; virtual;
  public
    constructor Create;
    procedure ClearIncrementalSearch; virtual;
    property AutoCompleteDelay: Cardinal read FAutoCompleteDelay write FAutoCompleteDelay;
    property IsRepeat: Boolean read FIsRepeat;
    property SearchText: string read FSearchText write FSearchText;
  end;

implementation

const
  dxThisUnitName = 'dxIncrementalSearch';

{ TdxIncrementalSearchController }

constructor TdxIncrementalSearchController.Create;
begin
  inherited Create;
  FSearchText := '';
  FAutoCompleteDelay := 1000;
end;

function TdxIncrementalSearchController.CanProcessIncSearch(Key: Char): Boolean;
begin
  Result := IsIncSearchChar(Key);
end;

procedure TdxIncrementalSearchController.ClearIncrementalSearch;
begin
  FSearchText := '';
  FIsRepeat := False;
end;

function TdxIncrementalSearchController.DoIncrementalSearch(var Key: Char): Boolean;
var
  ALength: Integer;
begin
  if GetTickCount - FStartIncrementalSearch > AutoCompleteDelay then
    ClearIncrementalSearch;
  FStartIncrementalSearch := GetTickCount;
  SearchText := SearchText + Key;
  ALength := Length(SearchText);
  if ALength > 1 then
  begin
    if (ALength = 2) and (SearchText[1] = SearchText[2]) then
      FIsRepeat := True
    else
      if FIsRepeat and (SearchText[1] <> Key) then
        FIsRepeat := False;
  end;
  Result := FocusNextItemWithText(SearchText);
end;

function TdxIncrementalSearchController.IsIncSearchChar(AChar: Char): Boolean;
begin
  Result := AChar >= ' ';
end;

procedure TdxIncrementalSearchController.KeyDown(var Key: Word; Shift: TShiftState);
begin
  ClearIncrementalSearch;
  Key := 0;
end;

procedure TdxIncrementalSearchController.KeyPress(var Key: Char);
begin
   if ProcessKeyPress(Key) then
     Key := #0;
end;

procedure TdxIncrementalSearchController.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ClearIncrementalSearch;
end;

function TdxIncrementalSearchController.ProcessKeyPress(var Key: Char): Boolean;
begin
  Result := CanProcessIncSearch(Key) and DoIncrementalSearch(Key);
end;

end.
