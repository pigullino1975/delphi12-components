{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressSpreadSheet                                       }
{                                                                    }
{           Copyright (c) 2001-2024 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSSPREADSHEET CONTROL AND ALL    }
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

unit dxSpreadSheetFormatXLSXUtils;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Types, Windows, SysUtils, Classes, Graphics, Generics.Collections, Generics.Defaults,
  dxSpreadSheetCore, dxSpreadSheetTypes, dxSpreadSheetClasses, dxCore, cxClasses, dxCoreClasses;

type

  { TdxXLSXStringToObjectMap }

  TdxXLSXStringToObjectMap = class(TDictionary<string, TObject>);

  { TdxXLSXRelationship }

  TdxXLSXRelationship = class
  strict private
    FID: string;
  protected
    FMode: string;
    FTarget: string;
    FTargetType: string;
  public
    constructor Create(const ID: string);
    //
    property ID: string read FID;
    property Mode: string read FMode;
    property Target: string read FTarget;
    property TargetType: string read FTargetType;
  end;

  { TdxXLSXRelationships }

  TdxXLSXRelationships = class
  strict private
    FList: TcxObjectList;

    function GetCount: Integer;
    function GetItem(Index: Integer): TdxXLSXRelationship;
  public
    constructor Create;
    destructor Destroy; override;
    function AddNew(const ATarget, AType: string): string; overload;
    function AddNew(const ATarget, AType, AMode: string): string; overload;
    procedure AddOrUpdate(const ID, ATarget, AType, AMode: string);
    procedure Clear;
    procedure ConvertToRelativePaths(const ARootPath: string);
    function Find(const ID: string; out AItem: TdxXLSXRelationship): Boolean;
    function FindByTarget(const ATarget: string; out AItem: TdxXLSXRelationship): Boolean;
    function FindByType(const AType: string; out AItem: TdxXLSXRelationship): Boolean;
    function GetIdByTarget(const ATarget: string): string;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TdxXLSXRelationship read GetItem; default;
  end;

  { TdxXLSXUtils }

  TdxXLSXUtils = class
  private
    const PercentsResolution = 1000;
    const PositiveFixedAngleResolution = 60000;
  private
    class function DecodeValue(AValue: Integer): Integer; inline;
    class function EncodeValue(AValue: Integer): Integer; inline;
  public
    // Color Alpha
    class function DecodeColor(const AHexCode: string): TColor;
    class function DecodeColorAlpha(const AValue: Integer): Byte; inline;
    class function EncodeColorAlpha(const AValue: Byte): Integer; inline;
    // Percents
    class function DecodePercents(const AValue: Integer): Double;
    class function EncodePercents(const AValue: Double): Integer;
    // PositiveFixedAngle
    class function DecodePositiveFixedAngle(const AValue: Integer): Integer;
    class function EncodePositiveFixedAngle(const AValue: Integer): Integer;
    // Source Rect
    class function DecodeSourceRect(const R: TRect): TRect;
    class function EncodeSourceRect(const R: TRect): TRect;

    class function GetRelsFileNameForFile(const AFileName: AnsiString): AnsiString; overload;
    class function GetRelsFileNameForFile(const AFileName: string): string; overload;
  end;

implementation

uses
  AnsiStrings, cxGraphics, cxGeometry, dxZIPUtils, dxCoreGraphics,
  dxSpreadSheetUtils, dxSpreadSheetFormatUtils, dxDPIAwareUtils, dxSpreadSheetFormatXLSXTags;

const
  dxThisUnitName = 'dxSpreadSheetFormatXLSXUtils';

{ TdxXLSXRelationship }

constructor TdxXLSXRelationship.Create(const ID: string);
begin
  FID := ID;
end;

{ TdxXLSXRelationships }

constructor TdxXLSXRelationships.Create;
begin
  inherited Create;
  FList := TcxObjectList.Create;
end;

destructor TdxXLSXRelationships.Destroy;
begin
  FreeAndNil(FList);
  inherited Destroy;
end;

function TdxXLSXRelationships.AddNew(const ATarget, AType: string): string;
begin
  Result := AddNew(ATarget, AType, EmptyStr)
end;

function TdxXLSXRelationships.AddNew(const ATarget, AType, AMode: string): string;
begin
  Result := 'rId' + IntToStr(Count + 1);
  AddOrUpdate(Result, ATarget, AType, AMode);
end;

procedure TdxXLSXRelationships.AddOrUpdate(const ID, ATarget, AType, AMode: string);
var
  AItem: TdxXLSXRelationship;
begin
  if not Find(ID, AItem) then
  begin
    AItem := TdxXLSXRelationship.Create(ID);
    FList.Add(AItem);
  end;
  AItem.FTarget := ATarget;
  AItem.FTargetType := AType;
  AItem.FMode := AMode;
end;

procedure TdxXLSXRelationships.Clear;
begin
  FList.Clear;
end;

procedure TdxXLSXRelationships.ConvertToRelativePaths(const ARootPath: string);
var
  AItem: TdxXLSXRelationship;
  I: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    AItem := Items[I];
    if AItem.Mode <> sdxXLSXValueTargetModeExternal then
      AItem.FTarget := TdxZIPPathHelper.RelativePath(ARootPath, TdxZIPPathHelper.ExcludeRootPathDelimiter(AItem.FTarget));
  end;
end;

function TdxXLSXRelationships.Find(const ID: string; out AItem: TdxXLSXRelationship): Boolean;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    AItem := Items[I];
    if dxSameText(ID, AItem.ID) then
      Exit(True);
  end;
  Result := False;
end;

function TdxXLSXRelationships.FindByTarget(const ATarget: string; out AItem: TdxXLSXRelationship): Boolean;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    AItem := Items[I];
    if dxSameText(ATarget, AItem.Target) then
      Exit(True);
  end;
  Result := False;
end;

function TdxXLSXRelationships.FindByType(const AType: string; out AItem: TdxXLSXRelationship): Boolean;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    AItem := Items[I];
    if dxSameText(AType, AItem.TargetType) then
      Exit(True);
  end;
  Result := False;
end;

function TdxXLSXRelationships.GetIdByTarget(const ATarget: string): string;
var
  AItem: TdxXLSXRelationship;
begin
  if FindByTarget(ATarget, AItem) then
    Result := AItem.ID
  else
    raise EdxSpreadSheetError.CreateFmt('The %s is not registered', [ATarget]);
end;

function TdxXLSXRelationships.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TdxXLSXRelationships.GetItem(Index: Integer): TdxXLSXRelationship;
begin
  Result := TdxXLSXRelationship(FList.List[Index]);
end;

{ TdxXLSXUtils }

class function TdxXLSXUtils.DecodeColor(const AHexCode: string): TColor;
begin
  Result := dxAlphaColorToColor(TdxAlphaColors.FromHexCode(AHexCode));
end;

class function TdxXLSXUtils.DecodeColorAlpha(const AValue: Integer): Byte;
begin
  Result := MulDiv(AValue, MaxByte, 100 * PercentsResolution)
end;

class function TdxXLSXUtils.EncodeColorAlpha(const AValue: Byte): Integer;
begin
  Result := MulDiv(AValue, 100 * PercentsResolution, MaxByte);
end;

class function TdxXLSXUtils.DecodePercents(const AValue: Integer): Double;
begin
  Result := AValue / PercentsResolution;
end;

class function TdxXLSXUtils.EncodePercents(const AValue: Double): Integer;
begin
  Result := Trunc(AValue * PercentsResolution);
end;

class function TdxXLSXUtils.DecodePositiveFixedAngle(const AValue: Integer): Integer;
begin
  Result := (AValue div PositiveFixedAngleResolution) mod 360;
end;

class function TdxXLSXUtils.EncodePositiveFixedAngle(const AValue: Integer): Integer;
begin
  Result := AValue mod 360;
  if Result < 0 then
    Inc(Result, 360);
  Result := Result * PositiveFixedAngleResolution;
end;

class function TdxXLSXUtils.DecodeSourceRect(const R: TRect): TRect;
begin
  Result := cxRect(DecodeValue(R.Left), DecodeValue(R.Top), DecodeValue(R.Right), DecodeValue(R.Bottom));
end;

class function TdxXLSXUtils.DecodeValue(AValue: Integer): Integer;
begin
  Result := MulDiv(AValue, dxDefaultDPI, 21333);
end;

class function TdxXLSXUtils.EncodeSourceRect(const R: TRect): TRect;
begin
  Result := cxRect(EncodeValue(R.Left), EncodeValue(R.Top), EncodeValue(R.Right), EncodeValue(R.Bottom));
end;

class function TdxXLSXUtils.EncodeValue(AValue: Integer): Integer;
begin
  Result := MulDiv(AValue, 21333, dxDefaultDPI);
end;

class function TdxXLSXUtils.GetRelsFileNameForFile(const AFileName: string): string;
begin
  Result := dxAnsiStringToString(GetRelsFileNameForFile(dxStringToAnsiString(AFileName)));
end;

class function TdxXLSXUtils.GetRelsFileNameForFile(const AFileName: AnsiString): AnsiString;
begin
  Result := TdxZIPPathHelper.DecodePath(AFileName);
  Result := ExtractFilePath(Result) + '_rels' + PathDelim + ExtractFileName(Result) + '.rels';
  Result := TdxZIPPathHelper.EncodePath(Result);
end;

end.
