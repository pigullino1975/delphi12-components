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

unit dxChartDBData;

{$I cxVer.inc}
{$SCOPEDENUMS ON}

interface

uses
  Classes, SysUtils, Variants, DB, cxClasses,
  dxCore, cxDataStorage, dxChartCore, dxCustomData, dxDBData;

type
  { TdxChartSeriesDBField }

  TdxChartSeriesDBField = class(TdxChartSeriesCustomDataField)
  published
    property FieldName;
  end;

  { TdxChartSeriesDBDataBinding }

  TdxChartSeriesDBDataBinding = class(TdxChartSeriesCustomDataBinding)
  private
    function GetArgumentField: TdxChartSeriesDBField; inline;
    function GetDataSource: TDataSource;
    function GetStorage: TdxDBDataStorage; inline;
    function GetValueField: TdxChartSeriesDBField; inline;
    procedure SetArgumentField(const AValue: TdxChartSeriesDBField);
    procedure SetDataSource(AValue: TDataSource);
    procedure SetValueField(const AValue: TdxChartSeriesDBField);
  protected
    procedure ChangeStorage(ANewStorage: TdxDataStorage); override;
    procedure DoAssign(Source: TPersistent); override;
    function GetDataStorageClass: TdxDataStorageClass; override;
    function GetDefaultSeriesCaption: string; override;
    function GetFieldClass: TdxChartSeriesDataFieldClass; override;
    function GetSharedStorageKey: TComponent; override;
    class function IsSharedStorage: Boolean; override;

    property Storage: TdxDBDataStorage read GetStorage;
  public
    class function IsCompatibleWidth(ASeriesClass: TdxChartSeriesClass): Boolean; override;
  published
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property ArgumentField: TdxChartSeriesDBField read GetArgumentField write SetArgumentField;
    property ValueField: TdxChartSeriesDBField read GetValueField write SetValueField;
  end;

  { TdxChartSimpleSeriesDBDataBinding }

  TdxChartSimpleSeriesDBDataBinding = class(TdxChartSeriesDBDataBinding)
  public
    class function IsCompatibleWidth(ASeriesClass: TdxChartSeriesClass): Boolean; override;
  end;

  { TdxChartXYSeriesDBDataBinding }

  TdxChartXYSeriesDBDataBinding = class(TdxChartSeriesDBDataBinding)
  public
    class function IsCompatibleWidth(ASeriesClass: TdxChartSeriesClass): Boolean; override;
  end;

implementation

uses
  dxChartSimpleDiagram, dxChartXYDiagram;

const
  dxThisUnitName = 'dxChartDBData';

{ TdxChartSeriesDBDataBinding }

procedure TdxChartSeriesDBDataBinding.ChangeStorage(ANewStorage: TdxDataStorage);
var
  I: Integer;
begin
  ANewStorage.BeginUpdate;
  try
    TdxDBDataStorage(ANewStorage).DataSource := DataSource;
    for I := 0 to FieldCount - 1 do
      TdxChartSeriesDBField(Fields[I]).RecreateItem(ANewStorage);
    inherited ChangeStorage(ANewStorage);
  finally
    ANewStorage.EndUpdate;
  end
end;

procedure TdxChartSeriesDBDataBinding.DoAssign(Source: TPersistent);
begin
  if Source is TdxChartSeriesDBDataBinding then
    DataSource := TdxChartSeriesDBDataBinding(Source).DataSource;
  inherited DoAssign(Source);
end;

function TdxChartSeriesDBDataBinding.GetDataStorageClass: TdxDataStorageClass;
begin
  Result := TdxDBDataStorage;
end;

function TdxChartSeriesDBDataBinding.GetDefaultSeriesCaption: string;
begin
  Result := ValueField.FieldName;
end;

function TdxChartSeriesDBDataBinding.GetFieldClass: TdxChartSeriesDataFieldClass;
begin
  Result := TdxChartSeriesDBField;
end;

function TdxChartSeriesDBDataBinding.GetSharedStorageKey: TComponent;
begin
  Result := DataSource;
end;

class function TdxChartSeriesDBDataBinding.IsCompatibleWidth(ASeriesClass: TdxChartSeriesClass): Boolean;
begin
  Result := False;
end;

class function TdxChartSeriesDBDataBinding.IsSharedStorage: Boolean;
begin
  Result := True;
end;

function TdxChartSeriesDBDataBinding.GetArgumentField: TdxChartSeriesDBField;
begin
  Result := TdxChartSeriesDBField(inherited ArgumentField);
end;

function TdxChartSeriesDBDataBinding.GetDataSource: TDataSource;
begin
  Result := Storage.DataSource;
end;

function TdxChartSeriesDBDataBinding.GetStorage: TdxDBDataStorage;
begin
  Result := TdxDBDataStorage(inherited Storage);
end;

function TdxChartSeriesDBDataBinding.GetValueField: TdxChartSeriesDBField;
begin
  Result := TdxChartSeriesDBField(inherited ValueField);
end;

procedure TdxChartSeriesDBDataBinding.SetArgumentField(const AValue: TdxChartSeriesDBField);
begin
  ArgumentField.Assign(AValue);
end;

procedure TdxChartSeriesDBDataBinding.SetDataSource(AValue: TDataSource);
begin
  if AValue <> DataSource then
  begin
    DataController.SharedStorageRemove(Self);
    DataController.SharedStorageAdd(AValue, Self);
    Storage.BeginUpdate;
    try
      if DataSource <> AValue then
        Storage.DataSource := AValue;
    finally
      Storage.EndUpdate;
    end;
  end;
end;

procedure TdxChartSeriesDBDataBinding.SetValueField(const AValue: TdxChartSeriesDBField);
begin
  ValueField.Assign(AValue);
end;

{ TdxChartSimpleSeriesDBDataBinding }

class function TdxChartSimpleSeriesDBDataBinding.IsCompatibleWidth(ASeriesClass: TdxChartSeriesClass): Boolean;
begin
  Result := ASeriesClass.InheritsFrom(TdxChartSimpleSeries);
end;

{ TdxChartXYSeriesDBDataBinding }

class function TdxChartXYSeriesDBDataBinding.IsCompatibleWidth(ASeriesClass: TdxChartSeriesClass): Boolean;
begin
  Result := ASeriesClass.InheritsFrom(TdxChartXYSeries);
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  RegisterClass(TdxChartSeriesDBField);
  TdxChartSimpleSeriesDBDataBinding.Register;
  TdxChartXYSeriesDBDataBinding.Register;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxChartSimpleSeriesDBDataBinding.UnRegister;
  TdxChartXYSeriesDBDataBinding.UnRegister;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
