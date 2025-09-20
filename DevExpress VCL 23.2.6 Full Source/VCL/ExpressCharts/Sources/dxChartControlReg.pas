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

unit dxChartControlReg;

{$I cxVer.inc}

interface

uses
  Classes, SysUtils, TypInfo, Types, DesignEditors, VCLEditors, dxCore,
  Forms, cxDesignWindows, cxPropEditors, dxCoreReg, cxLibraryReg, dxChartControl;

procedure Register;

implementation

uses
  Windows, DB, DesignIntf, ColnEdit,
  dxCoreClasses, cxClasses, cxEditPropEditors, cxDataStorage, cxDBData, cxControls,
  cxGeometry,
  dxLayoutControl,
  dxLayoutContainer,
  dxChartStrs,
  dxChartCore,
  dxChartData,
  dxChartDBData,
  dxChartDesigner,
  dxChartSimpleDiagram,
  dxChartXYDiagram,
  dxChartXYSeriesLineView;

const
  dxThisUnitName = 'dxChartControlReg';

type
  TdxChartSeriesUnboundFieldAccess = class(TdxChartSeriesUnboundField);
  TdxChartSeriesDBFieldAccess = class(TdxChartSeriesDBField);
  TdxLayoutControlViewInfoAccess = class(TdxLayoutControlViewInfo);

  { TfrmChartControlDesignTimeDesigner }

  TfrmChartControlDesignTimeDesigner = class(TfrmChartDesigner, IcxDesignSelectionChanged)
  private
    FCustomizedScaleFactor: TdxScaleFactor;
    // IcxDesignSelectionChanged
    procedure DesignSelectionChanged(ASelection: TList);
  protected
    function CanDelete(AComponent: TComponent): Boolean; override;
    function CanResizeOptions(ANewSize: Integer): Boolean; override;
    function GetCustomizedScaleFactor: TdxScaleFactor; override;
    procedure Initialize; override;
    procedure InitializeLayoutControl; override;
    function IsDesigning: Boolean; override;
    procedure Resize; override;
    procedure SelectObject(AObject: TPersistent); override;
    procedure SyncSelection; override;
  public
    constructor Create(AChartControl: TdxCustomChartControl); override;
    destructor Destroy; override;
  end;

  { TdxChartControlComponentEditor }

  TdxChartControlComponentEditor = class(TdxComponentEditor)
  strict private class var
    FDesigners: TdxFastObjectList;
    class constructor Initialize;
    class destructor Finalize;
  strict private
    function GetChartControl: TdxCustomChartControl;
  protected
    class function FindDesigner(AChartControl: TdxCustomChartControl): TfrmChartControlDesignTimeDesigner; static;
    class procedure CloseDesigner(ADesigner: TfrmChartControlDesignTimeDesigner); static;
    class procedure ShowDesigner(AChartControl: TdxCustomChartControl); static;
  protected
    function GetProductName: string; override;
    function InternalGetVerb(AIndex: Integer): string; override;
    function InternalGetVerbCount: Integer; override;
    procedure InternalExecuteVerb(AIndex: Integer); override;
  public
    property ChartControl: TdxCustomChartControl read GetChartControl;
  end;

  { TdxChartSeriesDataBindingProperty }

  TdxChartSeriesDataBindingProperty = class(TClassProperty)
  strict private
    function GetSeries: TdxChartCustomSeries;
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const Value: string); override;
    property Series: TdxChartCustomSeries read GetSeries;
  end;

  { TdxChartSeriesUnboundFieldValueTypeProperty }

  TdxChartSeriesUnboundFieldValueTypeProperty = class(TcxValueTypeProperty)
  protected
    function IsValueTypeClassValid(AValueTypeClass: TcxValueTypeClass): Boolean; override;
  end;

  { TdxChartSeriesDBFieldNameProperty }

  TdxChartSeriesDBFieldNameProperty = class(TFieldNameProperty)
  strict private
    function GetProperty: TdxChartSeriesDBFieldAccess;
  public
    function GetDataSource: TDataSource; override;
    procedure GetValueList(AList: TStrings); override;

    property &Property: TdxChartSeriesDBFieldAccess read GetProperty;
  end;

  { TdxChartSeriesViewProperty }

  TdxChartSeriesViewProperty = class(TClassProperty)
  strict private
    function GetSeries: TdxChartCustomSeries;
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const Value: string); override;
  end;

  { TdxChartControlSelectionEditor }

  TdxChartControlSelectionEditor = class(TSelectionEditor)
  public
    procedure RequiresUnits(Proc: TGetStrProc); override;
  end;

  { TdxChartTitlesPropertyEditor }

  TdxChartTitlesPropertyEditor = class(TCollectionProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
  end;

  { TdxAxisXEventsPropertyEditor }

  TdxAxisXEventsPropertyEditor = class(TcxNestedEventProperty)
  protected
    function GetInstance: TPersistent; override;
  end;

  { TdxViewEventsPropertyEditor }

  TdxViewEventsPropertyEditor = class(TcxNestedEventProperty)
  protected
    function GetInstance: TPersistent; override;
  end;

{ TfrmChartControlDesignTimeDesigner }

constructor TfrmChartControlDesignTimeDesigner.Create(AChartControl: TdxCustomChartControl);
begin
  FCustomizedScaleFactor := TdxScaleFactor.Create;
  inherited Create(AChartControl);
  cxDesignHelper.AddSelectionChangedListener(Self);
end;

destructor TfrmChartControlDesignTimeDesigner.Destroy;
begin
  FreeAndNil(FCustomizedScaleFactor);
  cxDesignHelper.RemoveSelectionChangedListener(Self);
  TdxChartControlComponentEditor.CloseDesigner(Self);
  inherited Destroy;
end;

function TfrmChartControlDesignTimeDesigner.CanDelete(AComponent: TComponent): Boolean;
begin
  Result := cxDesignHelper.CanDeleteComponent(OriginalChartControl, AComponent);
end;

function TfrmChartControlDesignTimeDesigner.CanResizeOptions(ANewSize: Integer): Boolean;
begin
  if ANewSize > lgAllOptions.Width then
    Result := TreeView.Width + lgAllOptions.Width - ANewSize > ScaleFactor.Apply(TreeViewMinWidth)
  else
    Result := ANewSize > ScaleFactor.Apply(OptionsMinWidth);
end;

function TfrmChartControlDesignTimeDesigner.GetCustomizedScaleFactor: TdxScaleFactor;
begin
  Result := FCustomizedScaleFactor;
end;

procedure TfrmChartControlDesignTimeDesigner.Initialize;
begin
  Constraints.MinWidth := 490;
  Width := 550;
  inherited Initialize;
  Caption := Format('%s - Designer', [cxGetFullComponentName(OriginalChartControl)]);
end;

procedure TfrmChartControlDesignTimeDesigner.InitializeLayoutControl;
begin
  liChartControl.Visible := False;
  lsiTreeView.Visible := False;
  liTreeView.AlignHorz := ahClient;
  lgMain.AlignHorz := ahClient;
  inherited InitializeLayoutControl;
end;

function TfrmChartControlDesignTimeDesigner.IsDesigning: Boolean;
begin
  Result := True;
end;

procedure TfrmChartControlDesignTimeDesigner.SelectObject(AObject: TPersistent);
begin
  cxDesignHelper.SelectObject(OriginalChartControl, AObject);
end;

procedure TfrmChartControlDesignTimeDesigner.SyncSelection;
var
  ASelectedNodeObjects: TList;
  cxDesignHelper2: IcxDesignHelper2;
begin
  if IsLocked then
    Exit;
  BeginUpdate;
  ASelectedNodeObjects := TList.Create;
  try
    GetSelectedNodeObjects(ASelectedNodeObjects);
    if Supports(cxDesignHelper, IcxDesignHelper2, cxDesignHelper2) then
      cxDesignHelper2.SetSelection(OriginalChartControl, ASelectedNodeObjects);
  finally
    ASelectedNodeObjects.Free;
    EndUpdate;
  end;
end;

procedure TfrmChartControlDesignTimeDesigner.Resize;
var
  ADelta: Integer;
begin
  if not TdxLayoutControlViewInfoAccess(lcMain.ViewInfo).IsValid then
    Exit;
  ADelta := ScaleFactor.Apply(TreeViewMinWidth) - TreeView.Width + lcMain.ViewInfo.ContentWidth - lcMain.Width;
  if ADelta <= 0 then
    Exit;
  lgAllOptions.Width := lgAllOptions.Width - ADelta;
end;

procedure TfrmChartControlDesignTimeDesigner.DesignSelectionChanged(ASelection: TList);
begin
  if IsLocked then
    Exit;
  BeginUpdate;
  try
    SetTreeViewSelection(ASelection);
  finally
    EndUpdate;
  end;
end;

{ TdxChartControlComponentEditor }

class constructor TdxChartControlComponentEditor.Initialize;
begin
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.ConstructorStarted(UnitName, 'TdxChartControlComponentEditor.Initialize', SysInit.HInstance);{$ENDIF}
  FDesigners := TdxFastObjectList.Create;
  dxChartShowDesignTimeDesigner := TdxChartControlComponentEditor.ShowDesigner;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.ConstructorFinished(UnitName, 'TdxChartControlComponentEditor.Initialize', SysInit.HInstance);{$ENDIF}
end;

class destructor TdxChartControlComponentEditor.Finalize;
begin
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.DestructorStarted(UnitName, 'TdxChartControlComponentEditor.Finalize', SysInit.HInstance);{$ENDIF}
  dxChartShowDesignTimeDesigner := nil;
  FreeAndNil(FDesigners);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.DestructorFinished(UnitName, 'TdxChartControlComponentEditor.Finalize', SysInit.HInstance);{$ENDIF}
end;

class function TdxChartControlComponentEditor.FindDesigner(
  AChartControl: TdxCustomChartControl): TfrmChartControlDesignTimeDesigner;
var
  I: Integer;
begin
  for I := 0 to FDesigners.Count - 1 do
  begin
    Result := TfrmChartControlDesignTimeDesigner(FDesigners[I]);
    if Result.OriginalChartControl = AChartControl then
      Exit;
  end;
  Result := nil;
end;

class procedure TdxChartControlComponentEditor.CloseDesigner(ADesigner: TfrmChartControlDesignTimeDesigner);
begin
  FDesigners.Extract(ADesigner);
end;

function TdxChartControlComponentEditor.GetChartControl: TdxCustomChartControl;
begin
  Result := Component as TdxCustomChartControl;
end;

function TdxChartControlComponentEditor.GetProductName: string;
begin
  Result := dxChartControlProductName;
end;

function TdxChartControlComponentEditor.InternalGetVerb(AIndex: Integer): string;
begin
  case AIndex of
    0: Result := 'Designer...';
    1: Result := 'Add ' + cxGetResourceString(@sdxChartControlXYDiagramDisplayName);
    2: Result := 'Add ' + cxGetResourceString(@sdxChartControlSimpleDiagramDisplayName);
  else
    Result := inherited InternalGetVerb(AIndex);
  end;
end;

function TdxChartControlComponentEditor.InternalGetVerbCount: Integer;
begin
  Result := 3;
end;

class procedure TdxChartControlComponentEditor.ShowDesigner(AChartControl: TdxCustomChartControl);
var
  ADesigner: TfrmChartControlDesignTimeDesigner;
begin
  ADesigner := FindDesigner(AChartControl);
  if ADesigner <> nil then
  begin
    if ADesigner.WindowState = wsMinimized then
      ADesigner.WindowState := wsNormal;
    ADesigner.Show;
    ADesigner.Activate;
  end
  else
  begin
    ADesigner := TfrmChartControlDesignTimeDesigner.Create(AChartControl);
    FDesigners.Add(ADesigner);
    ADesigner.Show;
  end;
end;

procedure TdxChartControlComponentEditor.InternalExecuteVerb(AIndex: Integer);
begin
  case AIndex of
    0: ShowDesigner(ChartControl);
    1: cxDesignHelper.SelectObject(ChartControl, ChartControl.AddDiagram<TdxChartXYDiagram>);
    2: cxDesignHelper.SelectObject(ChartControl, ChartControl.AddDiagram<TdxChartSimpleDiagram>);
  else
    inherited InternalExecuteVerb(AIndex);
  end;
end;

{ TdxChartSeriesDataBindingProperty }

function TdxChartSeriesDataBindingProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes;
  if (Series <> nil) and (Series.DataBindingClass <> nil) then
    Include(Result, paSubProperties)
  else
    Exclude(Result, paSubProperties);
  Result := Result - [paReadOnly] + [paValueList, paSortList, paRevertable, paVolatileSubProperties];
end;

function TdxChartSeriesDataBindingProperty.GetValue: string;
begin
  if Series <> nil then
    Result := Series.DataBindingType
  else
    Result := '';
end;

procedure TdxChartSeriesDataBindingProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
begin
  inherited GetValues(Proc);
  for I := 0 to dxChartRegisteredDataBindings.Count - 1 do
    if TdxChartSeriesDataBindingClass(dxChartRegisteredDataBindings[I]).IsCompatibleWidth(TdxChartSeriesClass(Series.ClassType)) then
      Proc(dxChartRegisteredDataBindings.Descriptions[I]);
end;

procedure TdxChartSeriesDataBindingProperty.SetValue(const Value: string);
begin
  if Series <> nil then
  begin
    Series.DataBindingType := Value;
    Modified;
  end;
end;

function TdxChartSeriesDataBindingProperty.GetSeries: TdxChartCustomSeries;
var
  I: Integer;
begin
  for I := 0 to PropCount - 1 do
    if GetComponent(I) is TdxChartCustomSeries then
      Exit(TdxChartCustomSeries(GetComponent(I)));
  Result := nil;
end;

{ TdxChartSeriesUnboundFieldValueTypeProperty }

type
  TdxChartSeriesCustomDataBindingAccess = class(TdxChartSeriesCustomDataBinding);

function TdxChartSeriesUnboundFieldValueTypeProperty.IsValueTypeClassValid(
  AValueTypeClass: TcxValueTypeClass): Boolean;

  function GetField: TdxChartSeriesUnboundFieldAccess;
  var
    I: Integer;
  begin
    for I := 0 to PropCount - 1 do
      if GetComponent(I) is TdxChartSeriesUnboundField then
        Exit(TdxChartSeriesUnboundFieldAccess(GetComponent(I)));
    Result := nil;
  end;

var
  AField: TdxChartSeriesUnboundFieldAccess;
begin
  AField := GetField;
  Result := (AField <> nil) and AField.IsValueTypeSupported(AValueTypeClass);
end;

{ TdxChartSeriesDBFieldNameProperty }

function TdxChartSeriesDBFieldNameProperty.GetDataSource: TDataSource;
begin
  if &Property <> nil then
    Result := TdxChartSeriesDBDataBinding(&Property.DataBinding).DataSource
  else
    Result := nil;
end;

function TdxChartSeriesDBFieldNameProperty.GetProperty: TdxChartSeriesDBFieldAccess;
var
  I: Integer;
begin
  for I := 0 to PropCount - 1 do
    if GetComponent(I) is TdxChartSeriesDBField then
      Exit(TdxChartSeriesDBFieldAccess(GetComponent(I)));
  Result := nil;
end;

procedure TdxChartSeriesDBFieldNameProperty.GetValueList(AList: TStrings);
var
  I: Integer;
  AField: TField;
  AValueClass: TcxValueTypeClass;
  AProperty: TdxChartSeriesDBFieldAccess;
begin
  AProperty := &Property;
  if AProperty <> nil then
  begin
    inherited GetValueList(AList);
    for I := AList.Count - 1 downto 0 do
    begin
      AField := GetDataSource.DataSet.FindField(AList[I]);
      AValueClass := GetValueTypeClassByField(AField);
      if not AProperty.IsValueTypeSupported(AValueClass) then
        AList.Delete(I);
    end;
  end;
end;

{ TdxChartSeriesViewProperty }

function TdxChartSeriesViewProperty.GetAttributes: TPropertyAttributes;
var
  ASeries: TdxChartCustomSeries;
begin
  Result := inherited GetAttributes;
  ASeries := GetSeries;
  if (ASeries <> nil) and (ASeries.ViewClass <> nil) then
    Include(Result, paSubProperties)
  else
    Exclude(Result, paSubProperties);
  Result := Result - [paReadOnly] + [paValueList, paSortList, paRevertable, paVolatileSubProperties];
end;

function TdxChartSeriesViewProperty.GetSeries: TdxChartCustomSeries;
var
  I: Integer;
begin
  for I := 0 to PropCount - 1 do
    if GetComponent(I) is TdxChartCustomSeries then
      Exit(TdxChartCustomSeries(GetComponent(I)));
  Result := nil;
end;

function TdxChartSeriesViewProperty.GetValue: string;
var
  ASeries: TdxChartCustomSeries;
begin
  ASeries := GetSeries;
  if ASeries <> nil then
    Result := ASeries.ViewType
  else
    Result := '';
end;

procedure TdxChartSeriesViewProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
  ASeries: TdxChartCustomSeries;
begin
  inherited GetValues(Proc);
  ASeries := GetSeries;
  if ASeries = nil then
    Exit;
  for I := 0 to dxChartRegisteredSeriesView.Count - 1 do
    if ASeries.IsCompatibleWithView(TdxChartSeriesViewClass(dxChartRegisteredSeriesView[I])) then
      Proc(dxChartRegisteredSeriesView.Descriptions[I]);
end;

procedure TdxChartSeriesViewProperty.SetValue(const Value: string);
begin
  if GetSeries <> nil then
  begin
    GetSeries.ViewType := Value;
    Modified;
  end;
end;

{ TdxChartControlSelectionEditor }

procedure TdxChartControlSelectionEditor.RequiresUnits(Proc: TGetStrProc);
var
  I: Integer;
  AComponent: TComponent;
  ASeries: TdxChartCustomSeries;
  AUnit: string;
begin
  inherited RequiresUnits(Proc);
  Proc('cxGeometry');
  Proc('cxClasses');
  Proc('cxGraphics');
  Proc('cxVariants');
  Proc('dxCustomData');
  Proc('cxCustomCanvas');
  Proc('dxCoreGraphics');
  Proc('dxCustomData');
  Proc('dxChartCore');
  Proc('dxChartData');
  Proc('dxChartLegend');
  Proc('dxChartSimpleDiagram');
  Proc('dxChartXYDiagram');
  Proc('dxChartXYSeriesLineView');
  Proc('dxChartXYSeriesAreaView');
  Proc('dxChartMarkers');
  Proc('dxChartXYSeriesBarView');
  for I := 0 to Designer.Root.ComponentCount - 1 do
  begin
    AComponent := Designer.Root.Components[I];
    if AComponent is TdxChartCustomSeries then
    begin
      ASeries := TdxChartCustomSeries(AComponent);
      if ASeries.DataBindingClass <> nil then
      begin
        AUnit := cxGetUnitName(ASeries.DataBindingClass);
        if not SameText(AUnit, 'dxChartData') then
          Proc(AUnit);
      end;
    end;
  end;
end;

{ TdxChartTitlesPropertyEditor }

function TdxChartTitlesPropertyEditor.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paSubProperties];
end;

{ TdxAxesAxisXEventsPropertyEditor }

function TdxAxisXEventsPropertyEditor.GetInstance: TPersistent;
begin
  Result := TdxChartXYDiagram(GetComponent(0)).Axes.AxisX;
end;

{ TdxViewEventsPropertyEditor }

function TdxViewEventsPropertyEditor.GetInstance: TPersistent;
begin
  Result := TdxChartSimpleSeries(GetComponent(0)).View;
end;

procedure Register;
begin
  ForceDemandLoadState(dlDisable);
  RegisterComponents(dxLibraryProductPage, [TdxChartControl]);
  RegisterComponentEditor(TdxChartControl, TdxChartControlComponentEditor);
  RegisterSelectionEditor(TdxChartControl, TdxChartControlSelectionEditor);
  RegisterNoIcon([TdxChartXYDiagram, TdxChartSimpleDiagram]);
  RegisterNoIcon([TdxChartSimpleSeries, TdxChartXYSeries]);

  RegisterPropertyEditor(TypeInfo(TdxChartTitles), TdxCustomChartControl, 'Titles', TdxChartTitlesPropertyEditor);
  RegisterPropertyEditor(TypeInfo(TdxChartSeriesCustomDataBinding), TdxChartCustomSeries, 'DataBinding', TdxChartSeriesDataBindingProperty);
  RegisterPropertyEditor(TypeInfo(string), TdxChartSeriesUnboundField, 'ValueType', TdxChartSeriesUnboundFieldValueTypeProperty);
  RegisterPropertyEditor(TypeInfo(string), TdxChartSeriesDBField, 'FieldName', TdxChartSeriesDBFieldNameProperty);
  HideClassProperties(TdxChartCustomSeries, ['DataBindingType']);

  RegisterPropertyEditor(TypeInfo(TdxChartSeriesCustomView), TdxChartCustomSeries, 'View', TdxChartSeriesViewProperty);
  HideClassProperties(TdxChartCustomSeries, ['ViewType']);

  RegisterPropertyEditor(TypeInfo(TdxDefaultBoolean), TdxChartVisualElementAppearance, 'Border', TdxParentlessDefaultBooleanPropertyEditor);
  RegisterPropertyEditor(TypeInfo(TdxDefaultBoolean), TdxChartSeriesValueLabels, 'LineVisible', TdxParentlessDefaultBooleanPropertyEditor);
  RegisterPropertyEditor(TypeInfo(TNotifyEvent), TdxChartXYDiagram, 'AxisXEvents', TdxAxisXEventsPropertyEditor);
  RegisterPropertyEditor(TypeInfo(TNotifyEvent), TdxChartSimpleSeries, 'ViewEvents', TdxViewEventsPropertyEditor);
end;

end.

