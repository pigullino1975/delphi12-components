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

unit cxDBFilter;

{$I cxVer.inc}

interface

uses
  DB, cxFilter, cxDB;

type
  { TcxFilterSQLNullOperator }

  TcxFilterSQLNullOperator = class(TcxFilterNullOperator)
  public
    function FilterText: string; override;
  end;

  { TcxFilterSQLNotNullOperator }

  TcxFilterSQLNotNullOperator = class(TcxFilterNotNullOperator)
  public
    function FilterText: string; override;
  end;

  { TcxFilterSQLIgnoreTimeEqualOperator }

  TcxFilterSQLIgnoreTimeEqualOperator = class(TcxFilterEqualOperator) //for internal use only
  protected
    function GetFilterExpressionText(const AValue: Variant): string; override;
  public
    function IsExpression: Boolean; override;
  end;

  { TcxFilterSQLIgnoreTimeNotEqualOperator }

  TcxFilterSQLIgnoreTimeNotEqualOperator = class(TcxFilterNotEqualOperator) //for internal use only
  protected
    function GetFilterExpressionText(const AValue: Variant): string; override;
  public
    function IsExpression: Boolean; override;
  end;

  { TcxFilterSQLIgnoreTimeLessOperator }

  TcxFilterSQLIgnoreTimeLessOperator = class(TcxFilterLessOperator) //for internal use only
  protected
    function GetFilterExpressionValue(const AValue: Variant): string; override;
  end;

  { TcxFilterSQLIgnoreTimeLessEqualOperator }

  TcxFilterSQLIgnoreTimeLessEqualOperator = class(TcxFilterLessEqualOperator) //for internal use only
  protected
    function GetFilterExpressionValue(const AValue: Variant): string; override;
  end;

  { TcxFilterSQLIgnoreTimeGreaterOperator }

  TcxFilterSQLIgnoreTimeGreaterOperator = class(TcxFilterGreaterOperator) //for internal use only
  protected
    function GetFilterExpressionValue(const AValue: Variant): string; override;
  end;

  { TcxFilterSQLIgnoreTimeGreaterEqualOperator }

  TcxFilterSQLIgnoreTimeGreaterEqualOperator = class(TcxFilterGreaterEqualOperator) //for internal use only
  protected
    function GetFilterExpressionValue(const AValue: Variant): string; override;
  end;

  { TcxDBFilterOperatorAdapter }

  TcxDBFilterOperatorAdapter = class(TcxDBAdapterItem)
  public
    procedure PrepareOperatorClass(ASender: TObject; ADataSet: TDataSet;
      var AOperatorClass: TcxFilterOperatorClass); virtual;
  end;

function cxGetFilterOperatorAdapter(ADataSet: TDataSet): TcxDBFilterOperatorAdapter;
function cxGetFilterSQLIgnoreTimeOperatorClass(AOperatorKind: TcxFilterOperatorKind): TcxFilterOperatorClass; //for internal use only

var
  cxFilterOperatorAdapters: TcxDBAdapterList;

implementation

uses
  SysUtils, DateUtils, Variants, dxCore;

const
  dxThisUnitName = 'cxDBFilter';

type
  TcxFilterCriteriaItemAccess = class(TcxFilterCriteriaItem);
  TcxFilterCriteriaAccess = class(TcxFilterCriteria);

function cxGetFilterOperatorAdapter(ADataSet: TDataSet): TcxDBFilterOperatorAdapter;
var
  AIndex: Integer;
begin
  if Assigned(ADataSet) and cxFilterOperatorAdapters.FindAdapter(TDataSetClass(ADataSet.ClassType), AIndex) then
    Result := cxFilterOperatorAdapters[AIndex] as TcxDBFilterOperatorAdapter
  else
    Result := nil;
end;

function cxGetFilterSQLIgnoreTimeOperatorClass(AOperatorKind: TcxFilterOperatorKind): TcxFilterOperatorClass;
begin
  case AOperatorKind of
    foEqual:
      Result := TcxFilterSQLIgnoreTimeEqualOperator;
    foNotEqual:
      Result := TcxFilterSQLIgnoreTimeNotEqualOperator;
    foLess:
      Result := TcxFilterSQLIgnoreTimeLessOperator;
    foLessEqual:
      Result := TcxFilterSQLIgnoreTimeLessEqualOperator;
    foGreater:
      Result := TcxFilterSQLIgnoreTimeGreaterOperator;
    foGreaterEqual:
      Result := TcxFilterSQLIgnoreTimeGreaterEqualOperator;
    else
      Result := nil;
  end;
end;

{ TcxFilterSQLNullOperator }

function TcxFilterSQLNullOperator.FilterText: string;
begin
  Result := 'IS';
end;

{ TcxFilterSQLNotNullOperator }

function TcxFilterSQLNotNullOperator.FilterText: string;
begin
  Result := 'IS NOT';
end;

{ TcxFilterSQLIgnoreTimeEqualOperator }

function TcxFilterSQLIgnoreTimeEqualOperator.IsExpression: Boolean;
begin
  Result := VarType(CriteriaItem.Value) = varDate;
end;

function TcxFilterSQLIgnoreTimeEqualOperator.GetFilterExpressionText(const AValue: Variant): string;
var
  AStart, AFinish, AFieldName: string;
begin
  if VarType(AValue) = varDate then
  begin
    AStart := GetFilterExpressionValue(StartOfTheDay(AValue));
    AFinish := GetFilterExpressionValue(EndOfTheDay(AValue));
    AFieldName := TcxFilterCriteriaItemAccess(CriteriaItem).GetFieldName;
    Result := '(' + AFieldName + ' >= ' + AStart + ') AND (' + AFieldName + ' <= ' + AFinish + ')';
  end
  else
    Result := TcxFilterCriteriaAccess(CriteriaItem.Criteria).GetItemExpression(CriteriaItem, False);
end;

{ TcxFilterSQLIgnoreTimeNotEqualOperator }

function TcxFilterSQLIgnoreTimeNotEqualOperator.IsExpression: Boolean;
begin
  Result := VarType(CriteriaItem.Value) = varDate;
end;

function TcxFilterSQLIgnoreTimeNotEqualOperator.GetFilterExpressionText(const AValue: Variant): string;
var
  AStart, AFinish, AFieldName: string;
begin
  if VarType(AValue) = varDate then
  begin
    AStart := GetFilterExpressionValue(StartOfTheDay(AValue));
    AFinish := GetFilterExpressionValue(EndOfTheDay(AValue));
    AFieldName := TcxFilterCriteriaItemAccess(CriteriaItem).GetFieldName;
    Result := '(' + AFieldName + ' < ' + AStart + ') OR (' + AFieldName + ' > ' + AFinish + ')';
  end
  else
    Result := TcxFilterCriteriaAccess(CriteriaItem.Criteria).GetItemExpression(CriteriaItem, False);
end;

{ TcxFilterSQLIgnoreTimeLessOperator }

function TcxFilterSQLIgnoreTimeLessOperator.GetFilterExpressionValue(const AValue: Variant): string;
var
  V: Variant;
begin
  V := AValue;
  if VarType(AValue) = varDate then
    V := StartOfTheDay(V);
  Result := inherited GetFilterExpressionValue(V);
end;

{ TcxFilterSQLIgnoreTimeLessEqualOperator }

function TcxFilterSQLIgnoreTimeLessEqualOperator.GetFilterExpressionValue(const AValue: Variant): string;
var
  V: Variant;
begin
  V := AValue;
  if VarType(AValue) = varDate then
    V := EndOfTheDay(V);
  Result := inherited GetFilterExpressionValue(V);
end;

{ TcxFilterSQLIgnoreTimeGreaterOperator }

function TcxFilterSQLIgnoreTimeGreaterOperator.GetFilterExpressionValue(const AValue: Variant): string;
var
  V: Variant;
begin
  V := AValue;
  if VarType(AValue) = varDate then
    V := EndOfTheDay(V);
  Result := inherited GetFilterExpressionValue(V);
end;

{ TcxFilterSQLIgnoreTimeGreaterEqualOperator }

function TcxFilterSQLIgnoreTimeGreaterEqualOperator.GetFilterExpressionValue(const AValue: Variant): string;
var
  V: Variant;
begin
  V := AValue;
  if VarType(AValue) = varDate then
    V := StartOfTheDay(V);
  Result := inherited GetFilterExpressionValue(V);
end;

{ TcxDBFilterOperatorAdapter }

procedure TcxDBFilterOperatorAdapter.PrepareOperatorClass(ASender: TObject;
  ADataSet: TDataSet; var AOperatorClass: TcxFilterOperatorClass);
begin
  if AOperatorClass.InheritsFrom(TcxFilterNullOperator) or
    AOperatorClass.InheritsFrom(TcxFilterNotNullOperator) then
  begin
    if Pos(AnsiUpperCase('Query'), AnsiUpperCase(ADataSet.ClassName)) <> 0 then
      if AOperatorClass.InheritsFrom(TcxFilterNotNullOperator) then
        AOperatorClass := TcxFilterSQLNotNullOperator
      else
        AOperatorClass := TcxFilterSQLNullOperator;
  end;
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  cxFilterOperatorAdapters := TcxDBAdapterList.Create;
  cxFilterOperatorAdapters.RegisterAdapter(TDataSet, TcxDBFilterOperatorAdapter);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  FreeAndNil(cxFilterOperatorAdapters);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
