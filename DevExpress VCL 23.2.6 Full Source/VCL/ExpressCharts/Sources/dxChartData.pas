{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressCharts                                            }
{                                                                    }
{           Copyright (c) 2020-2024 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSCHARTS AND ALL ACCOMPANYING    }
{   VCL CONTROLS AS PART OF AN EXECUTABLE PROGRAM ONLY.              }
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

unit dxChartData;

{$I cxVer.inc}
{$SCOPEDENUMS ON}

interface

uses
  Classes, SysUtils, Variants, dxCore, cxDataStorage, dxChartCore, dxCustomData;

type
  { TdxChartSeriesUnboundPoints }

  TdxChartSeriesUnboundPoints = class(TdxChartSeriesPoints)
  protected
    procedure SetRecordData(ARecord: PdxDataRecord; const AArgs: array of const); override;
  end;

  { TdxChartSeriesUnboundField }

  TdxChartSeriesUnboundField = class(TdxChartSeriesCustomDataField)
  public
    property ValueTypeClass;
  published
    property ValueType;
  end;

  { TdxChartSeriesUnboundDataBinding }

  TdxChartSeriesUnboundDataBinding = class(TdxChartSeriesCustomDataBinding)
  private
    function GetArgumentField: TdxChartSeriesUnboundField;
    function GetValueField: TdxChartSeriesUnboundField;
    procedure SetArgumentField(const AValue: TdxChartSeriesUnboundField);
    procedure SetValueField(const AValue: TdxChartSeriesUnboundField);
    procedure ReadData(AStream: TStream);
    procedure WriteData(AStream: TStream);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    function GetFieldClass: TdxChartSeriesDataFieldClass; override;
    class function GetPointsClass: TdxChartSeriesPointsClass; override;
    function CanStored: Boolean; override;

    property ArgumentField: TdxChartSeriesUnboundField read GetArgumentField write SetArgumentField;
    property ValueField: TdxChartSeriesUnboundField read GetValueField write SetValueField;
  public
    class function IsCompatibleWidth(ASeriesClass: TdxChartSeriesClass): Boolean; override;
  end;

  { TdxChartSimpleSeriesUnboundDataBinding }

  TdxChartSimpleSeriesUnboundDataBinding = class(TdxChartSeriesUnboundDataBinding)
  public
    class function IsCompatibleWidth(ASeriesClass: TdxChartSeriesClass): Boolean; override;
  published
    property ArgumentField;
    property ValueField;
  end;

  { TdxChartXYSeriesUnboundDataBinding }

  TdxChartXYSeriesUnboundDataBinding = class(TdxChartSeriesUnboundDataBinding)
  public
    class function IsCompatibleWidth(ASeriesClass: TdxChartSeriesClass): Boolean; override;
  published
    property ArgumentField;
    property ValueField;
  end;

implementation

uses
  dxChartSimpleDiagram, dxChartXYDiagram;

const
  dxThisUnitName = 'dxChartData';

{ TdxChartSeriesUnboundPoints }

procedure TdxChartSeriesUnboundPoints.SetRecordData(ARecord: PdxDataRecord; const AArgs: array of const);
var
  I: Integer;
  AValue: TVarRec;
  AValueAsText: string;
  AValueAsVariant: Variant;
begin
  I := Low(AArgs);
  while I <= High(AArgs) do
  begin
    AValue := AArgs[I];
    case AValue.VType of
      vtInteger:
        AValueAsVariant := AValue.VInteger;
      vtBoolean:
        AValueAsVariant := AValue.VBoolean;
      vtExtended:
        AValueAsVariant := AValue.VExtended^;
      vtCurrency:
        AValueAsVariant := AValue.VCurrency^;
      vtInt64:
        AValueAsVariant := AValue.VInt64^;
    else
      AValueAsVariant := Null;
    end;
    Fields[I].Value[ARecord] := AValueAsVariant;
    if Fields[I].TextStored then
    begin
      AValueAsText := '';
      AValue := AArgs[I + 1];
      case AValue.VType of
        vtChar:
          AValueAsText := dxAnsiStringToString(AValue.VChar);
        vtWideChar:
          AValueAsText := AValue.VWideChar;
        vtString:
          AValueAsText := string(AValue.VString^);
        vtPChar:
          AValueAsText := string(AValue.VPChar);
        vtPWideChar:
          AValueAsText := string(AValue.VPWideChar);
        vtAnsiString:
          AValueAsText := dxAnsiStringToString(AnsiString(AValue.VAnsiString));
        vtVariant:
          AValueAsText := VarToStr(AValue.VVariant^);
        vtWideString:
          AValueAsText := WideString(AValue.VWideString);
        vtUnicodeString:
          AValueAsText := string(AValue.VUnicodeString);
      end;
      Fields[I].DisplayText[ARecord] := AValueAsText;
      Inc(I);
    end;
    Inc(I);
  end;
  Changed;
end;

{ TdxChartSeriesUnboundDataBinding }

procedure TdxChartSeriesUnboundDataBinding.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineBinaryProperty('Data', ReadData, WriteData, Storage.RecordCount > 0);
end;

function TdxChartSeriesUnboundDataBinding.GetFieldClass: TdxChartSeriesDataFieldClass;
begin
  Result := TdxChartSeriesUnboundField;
end;

class function TdxChartSeriesUnboundDataBinding.GetPointsClass: TdxChartSeriesPointsClass;
begin
  Result := TdxChartSeriesUnboundPoints;
end;

class function TdxChartSeriesUnboundDataBinding.IsCompatibleWidth(ASeriesClass: TdxChartSeriesClass): Boolean;
begin
  Result := False;
end;

function TdxChartSeriesUnboundDataBinding.CanStored: Boolean;
begin
  Result := True;
end;

function TdxChartSeriesUnboundDataBinding.GetArgumentField: TdxChartSeriesUnboundField;
begin
  Result := TdxChartSeriesUnboundField(inherited ArgumentField);
end;

function TdxChartSeriesUnboundDataBinding.GetValueField: TdxChartSeriesUnboundField;
begin
  Result := TdxChartSeriesUnboundField(inherited ValueField);
end;

procedure TdxChartSeriesUnboundDataBinding.SetArgumentField(const AValue: TdxChartSeriesUnboundField);
begin
  ArgumentField.Assign(AValue);
end;

procedure TdxChartSeriesUnboundDataBinding.SetValueField(const AValue: TdxChartSeriesUnboundField);
begin
  ValueField.Assign(AValue);
end;

procedure TdxChartSeriesUnboundDataBinding.ReadData(AStream: TStream);
begin
  Storage.LoadFromStream(AStream);
end;

procedure TdxChartSeriesUnboundDataBinding.WriteData(AStream: TStream);
begin
  Storage.SaveToStream(AStream);
end;

{ TdxChartSimpleSeriesUnboundDataBinding }

class function TdxChartSimpleSeriesUnboundDataBinding.IsCompatibleWidth(ASeriesClass: TdxChartSeriesClass): Boolean;
begin
  Result := ASeriesClass.InheritsFrom(TdxChartSimpleSeries);
end;

{ TdxChartXYSeriesUnboundDataBinding }

class function TdxChartXYSeriesUnboundDataBinding.IsCompatibleWidth(ASeriesClass: TdxChartSeriesClass): Boolean;
begin
  Result := ASeriesClass.InheritsFrom(TdxChartXYSeries);
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  RegisterClass(TdxChartSeriesUnboundField);
  TdxChartSimpleSeriesUnboundDataBinding.Register;
  TdxChartXYSeriesUnboundDataBinding.Register;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxChartSimpleSeriesUnboundDataBinding.UnRegister;
  TdxChartXYSeriesUnboundDataBinding.UnRegister;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.


