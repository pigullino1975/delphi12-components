{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressDataController                                    }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSDATACONTROLLER AND ALL         }
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

unit dxCustomFunction;

{$I cxVer.inc}

interface

// this unit for internal use only

uses
  Classes, Types, TypInfo;

type

  { IdxCustomFunctionContainer }

  IdxCustomFunctionContainer = interface
  ['{96B14169-B9A6-465F-B10F-89288993F8FB}']
    function GetCustomFunctions(ACustomFunctions: TStrings): string;
  end;

  { TdxFunctionCategory }

  TdxFunctionCategory = (
    DateTime,
    Logical,
    Math,
    Text);

  { TdxCustomFunctionOperator }

  TdxCustomFunctionOperatorClass = class of TdxCustomFunctionOperator;
  TdxCustomFunctionOperator = class
  protected
    function GetName: string; virtual;
    function ResultType: PTypeInfo; virtual; abstract;
  public
    class function GetFunctionName: string; virtual;
    function Evaluate(const AOperands: array of Variant): Variant; virtual; abstract;
    property Name: string read GetName;
  end;

  { TdxCustomFunctionOperatorBrowsable }

  TdxCustomFunctionOperatorBrowsable = class(TdxCustomFunctionOperator)
  protected
    function GetDescription: string; virtual; abstract;
    function GetFunctionCategory: TdxFunctionCategory; virtual; abstract;
    function IsValidOperandCount(ACount: Integer): Boolean; virtual;
    function IsValidOperandType(AOperandIndex, AOperandCount: Integer; AType: PTypeInfo): Boolean; virtual;
  public
    function MinOperandCount: Integer; virtual; abstract;
    function MaxOperandCount: Integer; virtual; abstract;
    property Description: string read GetDescription;
    property FunctionCategory: TdxFunctionCategory read GetFunctionCategory;
  end;

  { TdxCustomFunctionDisplayAttributes }

  TdxCustomFunctionDisplayAttributes = class(TdxCustomFunctionOperatorBrowsable)
  protected
    function GetDisplayName: string; virtual; abstract;
  public
    property DisplayName: string read GetDisplayName;
  end;

  { TdxCustomFunctionOperatorFactory }

  TdxCustomFunctionOperatorFactory = class sealed //(TcxRegisteredClassList)
  public
    class function GetCustomFunctionOperatorName(ACustomFunctionOperator: TdxCustomFunctionOperator): string; static;
    class function GetCustomFunctionOperator(const ACustomFunctionName: string): TdxCustomFunctionOperator;
    class procedure Register(ACustomFunctionOperatorClass: TdxCustomFunctionOperatorClass); overload;
    class procedure Register(const ACustomFunctionOperatorClasses: array of TdxCustomFunctionOperatorClass); overload;
    class procedure UnRegister(ACustomFunctionOperatorClass: TdxCustomFunctionOperatorClass);
  end;

implementation

uses
  SysUtils, Generics.Collections, dxCore;

const
  dxThisUnitName = 'dxCustomFunction';

var
  CustomFunctionOperatorClasses: TList;
  CustomFunctionInstances: TObjectDictionary<string, TdxCustomFunctionOperator>;

{ TdxCustomFunctionOperator }

class function TdxCustomFunctionOperator.GetFunctionName: string;
begin
  Result := '';
end;

function TdxCustomFunctionOperator.GetName: string;
begin
  Result := GetFunctionName;
end;

{ TdxCustomFunctionFactory }

class function TdxCustomFunctionOperatorFactory.GetCustomFunctionOperatorName(ACustomFunctionOperator: TdxCustomFunctionOperator): string;
begin
  if ACustomFunctionOperator = nil then
    Result := ''
  else
    if ACustomFunctionOperator is TdxCustomFunctionDisplayAttributes then
      Result := TdxCustomFunctionDisplayAttributes(ACustomFunctionOperator).DisplayName
    else
      if ACustomFunctionOperator is TdxCustomFunctionOperatorBrowsable  then
        Result := TdxCustomFunctionOperatorBrowsable(ACustomFunctionOperator).Description
      else
        Result := ACustomFunctionOperator.Name
end;

class function TdxCustomFunctionOperatorFactory.GetCustomFunctionOperator(
  const ACustomFunctionName: string): TdxCustomFunctionOperator;
var
  I: Integer;
  ACustomFunctionOperatorClass: TdxCustomFunctionOperatorClass;
begin
  if not CustomFunctionInstances.TryGetValue(ACustomFunctionName, Result) then
  begin
    for I := 0 to CustomFunctionOperatorClasses.Count - 1 do
    begin
      ACustomFunctionOperatorClass := CustomFunctionOperatorClasses.List[I];
      if AnsiCompareText(ACustomFunctionOperatorClass.GetFunctionName, ACustomFunctionName) = 0 then
      begin
        Result := ACustomFunctionOperatorClass.Create;
        CustomFunctionInstances.Add(ACustomFunctionName, Result);
        Exit;
      end;
    end;
    Result := nil;
  end;
end;

class procedure TdxCustomFunctionOperatorFactory.Register(
  const ACustomFunctionOperatorClasses: array of TdxCustomFunctionOperatorClass);
var
  ACustomFunctionOperatorClass: TdxCustomFunctionOperatorClass;
begin
  for ACustomFunctionOperatorClass in ACustomFunctionOperatorClasses do
    Register(ACustomFunctionOperatorClass);
end;

class procedure TdxCustomFunctionOperatorFactory.Register(ACustomFunctionOperatorClass: TdxCustomFunctionOperatorClass);
begin
  if CustomFunctionOperatorClasses = nil then
    CustomFunctionOperatorClasses := TList.Create;
  if CustomFunctionOperatorClasses.IndexOf(ACustomFunctionOperatorClass) = -1 then
    CustomFunctionOperatorClasses.Add(ACustomFunctionOperatorClass);
  if CustomFunctionInstances = nil then
    CustomFunctionInstances := TObjectDictionary<string, TdxCustomFunctionOperator>.Create([doOwnsValues]);
end;

class procedure TdxCustomFunctionOperatorFactory.UnRegister(ACustomFunctionOperatorClass: TdxCustomFunctionOperatorClass);
var
  ACustomFunctionName: string;
begin
  if CustomFunctionOperatorClasses.IndexOf(ACustomFunctionOperatorClass) <> -1  then
  begin
    CustomFunctionOperatorClasses.Remove(ACustomFunctionOperatorClass);
    CustomFunctionInstances.Remove(ACustomFunctionName);
  end;
end;

{ TdxCustomFunctionOperatorBrowsable }

function TdxCustomFunctionOperatorBrowsable.IsValidOperandCount(ACount: Integer): Boolean;
begin
  Result := (MinOperandCount >= ACount) and (ACount <= MaxOperandCount);
end;

function TdxCustomFunctionOperatorBrowsable.IsValidOperandType(AOperandIndex, AOperandCount: Integer;
  AType: PTypeInfo): Boolean;
begin
  Result := True;
end;


initialization

finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  FreeAndNil(CustomFunctionOperatorClasses);
  FreeAndNil(CustomFunctionInstances);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
