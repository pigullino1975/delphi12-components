{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressCore Library                                      }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSCORE LIBRARY AND ALL           }
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

unit dxTypeInfo; // for internal use

{$I cxVer.inc}

interface

uses
  SysUtils, TypInfo;

type
  { TdxTypeInfo }

  TdxTypeInfo = class
  strict private
    class function SamePropertyName(APropInfo: PPropInfo; const AValue: string): Boolean; static;
  public type
    TEnumProc = reference to procedure(APropInfo: PPropInfo; var ABreak: Boolean);
  public
    class function TryGetPropList(ATypeInfo: PTypeInfo; out AList: PPropList; out ACount: Integer): Boolean; overload; static;
    class function TryGetPropList(ATypeInfo: PTypeInfo; ATypeKinds: TTypeKinds; out AList: PPropList;
      out ACount: Integer): Boolean; overload; static;
    class function TryGetPropList(ATypeInfo: PTypeInfo; ATypeKinds: TTypeKinds; ASorted: Boolean; out AList: PPropList;
      out ACount: Integer): Boolean; overload; static;
    //
    class function GetPropertyName(APropInfo: PPropInfo): string; static;
    class function HasProperty(AClass: TClass; const APropertyName: string): Boolean; overload; static;
    class function HasProperty(AClass: TClass; const APropertyName: string; ATypeKinds: TTypeKinds): Boolean; overload; static;
    class function HasProperty(ATypeInfo: PTypeInfo; const APropertyName: string; ATypeKinds: TTypeKinds): Boolean; overload; static;
    class procedure ProcessProperty(AClass: TClass; const APropertyName: string; AProc: TProc<PPropInfo>); static;
    //
    class procedure EnumProperties(ATypeInfo: PTypeInfo; AProc: TEnumProc); overload; static;
    class procedure EnumProperties(ATypeInfo: PTypeInfo; ATypeKinds: TTypeKinds; AProc: TEnumProc); overload; static;
    class procedure EnumProperties(ATypeInfo: PTypeInfo; ATypeKinds: TTypeKinds; ASorted: Boolean; AProc: TEnumProc); overload; static;
  end;

implementation

uses
  dxCore;

const
  dxThisUnitName = 'dxTypeInfo';

{ TdxTypeInfo }

class function TdxTypeInfo.TryGetPropList(ATypeInfo: PTypeInfo; out AList: PPropList; out ACount: Integer): Boolean;
begin
  Result := TryGetPropList(ATypeInfo, tkAny, False, AList, ACount);
end;

class function TdxTypeInfo.TryGetPropList(ATypeInfo: PTypeInfo; ATypeKinds: TTypeKinds; out AList: PPropList;
  out ACount: Integer): Boolean;
begin
  Result := TryGetPropList(ATypeInfo, ATypeKinds, False, AList, ACount);
end;

class function TdxTypeInfo.TryGetPropList(ATypeInfo: PTypeInfo; ATypeKinds: TTypeKinds; ASorted: Boolean;
  out AList: PPropList; out ACount: Integer): Boolean;
begin
  if ATypeInfo = nil then
    Exit(False);
  ACount := GetPropList(ATypeInfo, ATypeKinds, nil);
  Result := ACount > 0;
  if Result then
  begin
    AList := AllocMem(ACount * SizeOf(PPropInfo));
    GetPropList(ATypeInfo, ATypeKinds, AList);
    if ASorted then
      SortPropList(AList, ACount);
  end;
end;

class function TdxTypeInfo.GetPropertyName(APropInfo: PPropInfo): string;
begin
  Result := GetPropName(APropInfo);
end;

class function TdxTypeInfo.HasProperty(AClass: TClass; const APropertyName: string): Boolean;
begin
  Result := HasProperty(AClass, APropertyName, tkProperties);
end;

class function TdxTypeInfo.HasProperty(AClass: TClass; const APropertyName: string; ATypeKinds: TTypeKinds): Boolean;
begin
  Result := (AClass <> nil) and HasProperty(AClass.ClassInfo, APropertyName, ATypeKinds);
end;

class function TdxTypeInfo.HasProperty(ATypeInfo: PTypeInfo; const APropertyName: string;
  ATypeKinds: TTypeKinds): Boolean;
var
  AHasProperty: Boolean;
begin
  AHasProperty := False;
  EnumProperties(ATypeInfo, ATypeKinds,
    procedure(APropInfo: PPropInfo; var ABreak: Boolean)
    begin
      AHasProperty := SamePropertyName(APropInfo, APropertyName);
      ABreak := AHasProperty;
    end);
  Result := AHasProperty;
end;

class procedure TdxTypeInfo.ProcessProperty(AClass: TClass; const APropertyName: string;
  AProc: TProc<PPropInfo>);
begin
  if (AClass = nil) or not Assigned(AProc) then
    Exit;
  EnumProperties(AClass.ClassInfo,
    procedure(APropInfo: PPropInfo; var ABreak: Boolean)
    begin
      ABreak := SamePropertyName(APropInfo, APropertyName);
      if ABreak then
        AProc(APropInfo);
    end);
end;

class procedure TdxTypeInfo.EnumProperties(ATypeInfo: PTypeInfo; AProc: TEnumProc);
begin
  EnumProperties(ATypeInfo, tkAny, AProc);
end;

class procedure TdxTypeInfo.EnumProperties(ATypeInfo: PTypeInfo; ATypeKinds: TTypeKinds; AProc: TEnumProc);
begin
  EnumProperties(ATypeInfo, ATypeKinds, False, AProc);
end;

class procedure TdxTypeInfo.EnumProperties(ATypeInfo: PTypeInfo; ATypeKinds: TTypeKinds; ASorted: Boolean;
  AProc: TEnumProc);
var
  ABreak: Boolean;
  ACount: Integer;
  AList: PPropList;
  I: Integer;
begin
  if TryGetPropList(ATypeInfo, ATypeKinds, ASorted, AList, ACount) then
  try
    ABreak := False;
    for I := 0 to ACount - 1 do
    begin
      AProc(AList[I], ABreak);
      if ABreak then
        Break;
    end;
  finally
    FreeMem(AList);
  end;
end;

class function TdxTypeInfo.SamePropertyName(APropInfo: PPropInfo; const AValue: string): Boolean;
begin
  Result := CompareText(GetPropertyName(APropInfo), AValue) = 0;
end;

end.
