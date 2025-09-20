{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressGanttControl                                      }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSGANTTCONTROL AND ALL           }
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

unit dxGanttControlViewCommands; // for internal use

{$I cxVer.inc}
{$I dxGanttControl.inc}

interface

uses
  System.UITypes, System.Contnrs,
  Types, SysUtils, Classes, Graphics, ImgList, Windows, Controls,
  Generics.Defaults, Generics.Collections, Forms, StdCtrls, Variants,
  dxCore, dxCoreClasses, dxGDIPlusClasses,
  dxGanttControl,
  dxGanttControlCustomView,
  dxGanttControlCustomSheet,
  dxGanttControlCustomClasses,
  dxGanttControlCommands,
  dxGanttControlCustomDataModel,
  dxGanttControlDataModel,
  dxGanttControlTasks,
  dxGanttControlViewChart,
  dxGanttControlViewTimeline;

type
  { TdxGanttControlActivateViewCommand }

  TdxGanttControlActivateViewCommand = class abstract(TdxGanttControlViewCommand)
  protected
    procedure DoExecute; override;
  public
    class procedure SetActiveView(AControl: TdxGanttControlBase; AViewType: TdxGanttControlViewType); static;
    function Enabled: Boolean; override;
    function IsChecked: Boolean; override;
  end;

  { TdxGanttControlActivateChartViewCommand }

  TdxGanttControlActivateChartViewCommand = class(TdxGanttControlActivateViewCommand)
  protected
    function GetView: TdxGanttControlCustomView; override;
  end;

  { TdxGanttControlActivateResourceSheetViewCommand }

  TdxGanttControlActivateResourceSheetViewCommand = class(TdxGanttControlActivateViewCommand)
  protected
    function GetView: TdxGanttControlCustomView; override;
  end;

  { TdxGanttControlActivateTimelineViewCommand }

  TdxGanttControlActivateTimelineViewCommand = class(TdxGanttControlActivateViewCommand)
  protected
    function GetView: TdxGanttControlCustomView; override;
  end;

  { TdxGanttControlViewChartCommand }

  TdxGanttControlViewChartCommand = class(TdxGanttControlViewCommand)
  strict private
    function GetController: TdxGanttControlChartViewController; inline;
    function GetTask: TdxGanttControlTask;
    function InternalGetView: TdxGanttControlChartView; inline;
  protected
    function GetView: TdxGanttControlCustomView; override;

    property Task: TdxGanttControlTask read GetTask;
    property Controller: TdxGanttControlChartViewController read GetController;
  public
    function Enabled: Boolean; override;
    property View: TdxGanttControlChartView read InternalGetView;
  end;

  { TdxGanttControlViewChartShowBaselinesCommand }

  TdxGanttControlViewChartShowBaselinesCommand = class(TdxGanttControlViewChartCommand)
  strict private
    FNumber: Integer;
  protected
    procedure DoExecute; override;
  public
    constructor Create(AControl: TdxGanttControlBase; ANumber: Integer); reintroduce;
    function Enabled: Boolean; override;
  end;

  { TdxGanttControlViewChartBaselinesCustomCommand }

  TdxGanttControlViewChartBaselinesCustomCommand = class(TdxGanttControlViewChartCommand)
  strict private
    FNeedBaselineUpdateInformation: Boolean;
    FNumber: Integer;
    FSelected: Boolean;
  protected
    procedure AfterExecute; override;
    procedure BeforeExecute; override;
    procedure DoExecute; override;
    function DoProcessTask(ATask: TdxGanttControlTask): Boolean; virtual; abstract;
    procedure DoUpdateBaselineInformation; virtual;
    procedure ProcessTask(ATask: TdxGanttControlTask);
    procedure UpdateBaselineInformation;
    property Number: Integer read FNumber;
    property Selected: Boolean read FSelected;
  public
    constructor Create(AControl: TdxGanttControlBase; ANumber: Integer; ASelected: Boolean); reintroduce;
  end;

  { TdxGanttControlViewChartSetBaselinesCommand }

  TdxGanttControlViewChartSetBaselinesCommand = class(TdxGanttControlViewChartBaselinesCustomCommand)
  protected
    function DoProcessTask(ATask: TdxGanttControlTask): Boolean; override;
  end;

  { TdxGanttControlViewChartClearBaselinesCommand }

  TdxGanttControlViewChartClearBaselinesCommand = class(TdxGanttControlViewChartBaselinesCustomCommand)
  strict private
    procedure RemoveBaseline(ABaseline: TdxGanttControlCustomBaseline);
  protected
    function DoProcessTask(ATask: TdxGanttControlTask): Boolean; override;
    procedure DoUpdateBaselineInformation; override;
  public
    function Enabled: Boolean; override;
  end;

  { TdxGanttControlScrollToTaskCommand }

  TdxGanttControlScrollToTaskCommand = class(TdxGanttControlViewChartCommand)
  protected
    procedure DoExecute; override;
  public
    function GetMenuCaption: string; override;
    function GetMenuImage: TdxSmartImage; override;
    function Enabled: Boolean; override;
    function Visible: Boolean; override;
  end;

  { TdxGanttControlInsertTaskViewCommand }

  TdxGanttControlInsertTaskViewCommand = class(TdxGanttControlViewChartCommand)
  protected
    procedure DoExecute; override;
  public
    function GetMenuCaption: string; override;
    function Enabled: Boolean; override;
    function Visible: Boolean; override;
  end;

  { TdxGanttControlDeleteTaskViewCommand }

  TdxGanttControlDeleteTaskViewCommand = class(TdxGanttControlViewChartCommand)
  protected
    procedure DoExecute; override;
  public
    function GetMenuCaption: string; override;
    function Enabled: Boolean; override;
    function Visible: Boolean; override;
  end;

  { TdxGanttControlOpenTaskInformationDialogCommand }

  TdxGanttControlOpenTaskInformationDialogCommand = class(TdxGanttControlViewChartCommand)
  protected
    procedure DoExecute; override;
  public
    function Enabled: Boolean; override;
    function GetMenuCaption: string; override;
    function GetMenuImage: TdxSmartImage; override;
    function Visible: Boolean; override;
  end;

  { TdxGanttControlInsertRecurringTaskCommand }

  TdxGanttControlInsertRecurringTaskCommand = class(TdxGanttControlViewChartCommand)
  protected
    procedure DoExecute; override;
  public
    function Enabled: Boolean; override;
    function GetMenuCaption: string; override;
    function GetMenuImage: TdxSmartImage; override;
    function Visible: Boolean; override;
  end;

  { TdxGanttControlAddTaskToTimelineCommand }

  TdxGanttControlAddTaskToTimelineCommand = class(TdxGanttControlViewChartCommand)
  protected
    procedure DoExecute; override;
  public
    function Enabled: Boolean; override;
    function GetMenuCaption: string; override;
    function GetMenuImage: TdxSmartImage; override;
    function IsChecked: Boolean; override;
    function Visible: Boolean; override;
  end;

  { TdxGanttControlViewTimelineCommand }

  TdxGanttControlViewTimelineCommand = class(TdxGanttControlViewCommand)
  strict private
    function GetController: TdxGanttControlTimelineViewController; inline;
    function GetTasks: TdxFastObjectList;
    function InternalGetView: TdxGanttControlTimelineView; inline;
  protected
    function GetView: TdxGanttControlCustomView; override;

    property Tasks: TdxFastObjectList read GetTasks;
    property Controller: TdxGanttControlTimelineViewController read GetController;
  public
    function Enabled: Boolean; override;
    property View: TdxGanttControlTimelineView read InternalGetView;
  end;

  { TdxGanttControlGoToTaskCommand }

  TdxGanttControlGoToTaskCommand = class(TdxGanttControlViewTimelineCommand)
  protected
    procedure DoExecute; override;
  public
    function Enabled: Boolean; override;
    function GetMenuCaption: string; override;
    function Visible: Boolean; override;
  end;

  { TdxGanttControlRemoveTaskFromTimelineCommand }

  TdxGanttControlRemoveTaskFromTimelineCommand = class(TdxGanttControlViewTimelineCommand)
  protected
    procedure DoExecute; override;
  public
    function Enabled: Boolean; override;
    function GetMenuCaption: string; override;
    function Visible: Boolean; override;
  end;

  { TdxGanttControlTimelineOpenTaskInformationDialogCommand }

  TdxGanttControlTimelineOpenTaskInformationDialogCommand = class(TdxGanttControlViewTimelineCommand)
  protected
    procedure DoExecute; override;
  public
    function Enabled: Boolean; override;
    function GetMenuCaption: string; override;
    function GetMenuImage: TdxSmartImage; override;
    function Visible: Boolean; override;
  end;

  { TdxGanttControlViewSheetCommand }

  TdxGanttControlViewSheetCommand = class abstract(TdxGanttControlViewCommand)
  strict private
    FSheetController: TdxGanttControlViewSheetController;
    function GetOptions: TdxGanttControlSheetOptions;
  protected
    function GetView: TdxGanttControlCustomView; override;
    property Options: TdxGanttControlSheetOptions read GetOptions;
    property SheetController: TdxGanttControlViewSheetController read FSheetController;
  public
    constructor Create(ASheetController: TdxGanttControlViewSheetController); reintroduce;

    function Enabled: Boolean; override;
  end;

  { TdxGanttControlViewSheetColumnCommand }

  TdxGanttControlViewSheetColumnCommand = class abstract(TdxGanttControlViewSheetCommand)
  strict private
    FColumn: TdxGanttControlSheetColumn;
  protected
    property Column: TdxGanttControlSheetColumn read FColumn;
  public
    constructor Create(ASheetController: TdxGanttControlViewSheetController; AColumn: TdxGanttControlSheetColumn); reintroduce;
  end;

  { TdxGanttControlViewSheetBestFitColumnCommand }

  TdxGanttControlViewSheetBestFitColumnCommand = class(TdxGanttControlViewSheetColumnCommand)
  protected
    procedure DoExecute; override;
  public
    function GetMenuCaption: string; override;
    function GetMenuImage: TdxSmartImage; override;
    function Visible: Boolean; override;
  end;

  { TdxGanttControlViewSheetBestFitAllColumnsCommand }

  TdxGanttControlViewSheetBestFitAllColumnsCommand = class(TdxGanttControlViewSheetColumnCommand)
  protected
    procedure DoExecute; override;
  public
    function GetMenuCaption: string; override;
    function GetMenuImage: TdxSmartImage; override;
    function Visible: Boolean; override;
  end;

  { TdxGanttControlViewSheetRenameColumnCommand }

  TdxGanttControlViewSheetRenameColumnCommand = class(TdxGanttControlViewSheetColumnCommand)
  protected
    procedure BeginUpdate; override;
    procedure EndUpdate; override;

    procedure DoExecute; override;
  public
    function GetMenuCaption: string; override;
    function GetMenuImage: TdxSmartImage; override;
    function Visible: Boolean; override;
  end;

  { TdxGanttControlViewSheetWordWrapCommand }

  TdxGanttControlViewSheetWordWrapCommand = class(TdxGanttControlViewSheetColumnCommand)
  protected
    procedure DoExecute; override;
  public
    function GetMenuCaption: string; override;
    function GetMenuImage: TdxSmartImage; override;
    function IsChecked: Boolean; override;
    function Visible: Boolean; override;
  end;

  { TdxGanttControlViewSheetHideColumnCommand }

  TdxGanttControlViewSheetHideColumnCommand = class(TdxGanttControlViewSheetColumnCommand)
  protected
    procedure DoExecute; override;
  public
    function GetMenuCaption: string; override;
    function GetMenuImage: TdxSmartImage; override;
    function Visible: Boolean; override;
  end;

  { TdxGanttControlViewSheetInsertColumnCommand }

  TdxGanttControlViewSheetInsertColumnCommand = class(TdxGanttControlViewSheetColumnCommand)
  strict private
    function IsThereColumnToInsert: Boolean;
  protected
    procedure DoExecute; override;
  public
    function GetMenuCaption: string; override;
    function GetMenuImage: TdxSmartImage; override;
    function Visible: Boolean; override;
  end;

  { TdxGanttControlViewSheetShowChooseColumnDetailsDialogCommand }

  TdxGanttControlViewSheetShowChooseColumnDetailsDialogCommand = class(TdxGanttControlViewSheetColumnCommand)
  protected
    procedure DoExecute; override;
  public
    function GetMenuCaption: string; override;
    function GetMenuImage: TdxSmartImage; override;
    function Visible: Boolean; override;
  end;

implementation

uses
  RTLConsts,
  dxGanttControlTaskCommands,
  dxGanttControlStrs,
  dxGanttControlImages;

const
  dxThisUnitName = 'dxGanttControlViewCommands';

type
  TdxGanttControlCustomControllerAccess = class(TdxGanttControlCustomController);
  TdxGanttControlSheetControllerAccess = class(TdxGanttControlSheetController);
  TdxCustomGanttControlAccess = class(TdxCustomGanttControl);
  TdxGanttControlCustomViewAccess = class(TdxGanttControlCustomView);
  TdxGanttControlChartViewAccess = class(TdxGanttControlChartView);
  TdxGanttControlChartViewSheetControllerAccess = class(TdxGanttControlChartViewSheetController);
  TdxGanttControlTimelineViewControllerAccess = class(TdxGanttControlTimelineViewController);
  TdxGanttControlTimelineViewAccess = class(TdxGanttControlTimelineView);
  TdxGanttControlSheetColumnAccess = class(TdxGanttControlSheetColumn);
  TdxGanttControlSheetColumnsAccess = class(TdxGanttControlSheetColumns);

  { TdxGanttControlActivateViewHistoryItem }

  TdxGanttControlActivateViewHistoryItem = class(TdxGanttControlHistoryItem)
  protected
    FOldActiveView: TdxGanttControlCustomView;
    FView: TdxGanttControlCustomView;
    procedure DoRedo; override;
    procedure DoUndo; override;
  end;

  { TdxGanttControlSheetToggleWordWrapHistoryItem }

  TdxGanttControlSheetToggleWordWrapHistoryItem = class(TdxGanttControlSheetControllerHistoryItem)
  strict private
    FOldValue: Boolean;
  protected
    FColumn: TdxGanttControlSheetColumn;
    procedure DoRedo; override;
    procedure DoUndo; override;
  end;

  { TdxGanttControlViewChartShowBaselinesHistoryItem }

  TdxGanttControlViewChartShowBaselinesHistoryItem = class(TdxGanttControlHistoryItem)
  strict private
    FOldValue: Integer;
  protected
    FNewValue: Integer;
    FView: TdxGanttControlChartView;
    procedure DoRedo; override;
    procedure DoUndo; override;
  end;

{ TdxGanttControlActivateViewHistoryItem }

procedure TdxGanttControlActivateViewHistoryItem.DoRedo;
begin
  inherited DoRedo;
  TdxCustomGanttControlAccess(FView.Owner).DoSetActiveViewType(TdxGanttControlCustomViewAccess(FView).GetType);
end;

procedure TdxGanttControlActivateViewHistoryItem.DoUndo;
begin
  inherited DoUndo;
  if FOldActiveView <> nil then
    TdxCustomGanttControlAccess(FOldActiveView.Owner).DoSetActiveViewType(TdxGanttControlCustomViewAccess(FOldActiveView).GetType);
end;

{ TdxGanttControlSheetChangeWordWrapHistoryItem }

procedure TdxGanttControlSheetToggleWordWrapHistoryItem.DoRedo;
begin
  FOldValue := FColumn.WordWrap;
  FColumn.WordWrap := not FOldValue;
end;

procedure TdxGanttControlSheetToggleWordWrapHistoryItem.DoUndo;
begin
  FColumn.WordWrap := FOldValue;
end;

{ TdxGanttControlViewChartShowBaselinesHistoryItem }

procedure TdxGanttControlViewChartShowBaselinesHistoryItem.DoRedo;
begin
  inherited DoRedo;
  FOldValue := FView.BaselineNumber;
  FView.BaselineNumber := FNewValue;
end;

procedure TdxGanttControlViewChartShowBaselinesHistoryItem.DoUndo;
begin
  inherited DoUndo;
  FView.BaselineNumber := FOldValue;
end;

{ TdxGanttControlActivateViewCommand }

procedure TdxGanttControlActivateViewCommand.DoExecute;
var
  AHistoryItem: TdxGanttControlActivateViewHistoryItem;
  AOldActiveView: TdxGanttControlCustomView;
begin
  if View.Active then
    Exit;
  inherited DoExecute;
  AOldActiveView := TdxCustomGanttControl(Control).ActiveView;
  AHistoryItem := TdxGanttControlActivateViewHistoryItem.Create(Control.History);
  try
    AHistoryItem.FOldActiveView := AOldActiveView;
    AHistoryItem.FView := View;
    if AOldActiveView <> nil then
      Control.History.AddItem(AHistoryItem);
    AHistoryItem.Execute;
  finally
    if AOldActiveView = nil then
      AHistoryItem.Free;
  end;
end;

function TdxGanttControlActivateViewCommand.Enabled: Boolean;
begin
  Result := True;
end;

function TdxGanttControlActivateViewCommand.IsChecked: Boolean;
begin
  Result := View.Active;
end;

class procedure TdxGanttControlActivateViewCommand.SetActiveView(
  AControl: TdxGanttControlBase;
  AViewType: TdxGanttControlViewType);
var
  ACommand: TdxGanttControlActivateViewCommand;
begin
  if AViewType = TdxGanttControlViewType.None then
    Exit;
  case AViewType of
    TdxGanttControlViewType.ResourceSheet: ACommand := TdxGanttControlActivateResourceSheetViewCommand.Create(AControl);
    TdxGanttControlViewType.Timeline: ACommand := TdxGanttControlActivateTimelineViewCommand.Create(AControl);
  else
    ACommand := TdxGanttControlActivateChartViewCommand.Create(AControl);
  end;
  try
    ACommand.Execute;
  finally
    ACommand.Free;
  end;
end;

{ TdxGanttControlActivateChartViewCommand }

function TdxGanttControlActivateChartViewCommand.GetView: TdxGanttControlCustomView;
begin
  Result := TdxCustomGanttControl(Control).ViewChart;
end;

{ TdxGanttControlActivateResourceSheetViewCommand }

function TdxGanttControlActivateResourceSheetViewCommand.GetView: TdxGanttControlCustomView;
begin
  Result := TdxCustomGanttControl(Control).ViewResourceSheet;
end;

{ TdxGanttControlActivateTimelineViewCommand }

function TdxGanttControlActivateTimelineViewCommand.GetView: TdxGanttControlCustomView;
begin
  Result := TdxCustomGanttControl(Control).ViewTimeline;
end;

{ TdxGanttControlViewChartCommand }

function TdxGanttControlViewChartCommand.Enabled: Boolean;
begin
  Result := TdxCustomGanttControl(Control).ViewChart.Active;
end;

function TdxGanttControlViewChartCommand.GetController: TdxGanttControlChartViewController;
begin
  Result := TdxGanttControlChartViewController(inherited Controller);
end;

function TdxGanttControlViewChartCommand.GetTask: TdxGanttControlTask;
begin
  Result := TdxGanttControlChartViewSheetControllerAccess(Controller.SheetController).FocusedDataItem;
end;

function TdxGanttControlViewChartCommand.GetView: TdxGanttControlCustomView;
begin
  Result := TdxCustomGanttControl(Control).ViewChart;
end;

function TdxGanttControlViewChartCommand.InternalGetView: TdxGanttControlChartView;
begin
  Result := TdxCustomGanttControl(Control).ViewChart;
end;

{ TdxGanttControlViewChartShowBaselinesCommand }

constructor TdxGanttControlViewChartShowBaselinesCommand.Create(
  AControl: TdxGanttControlBase; ANumber: Integer);
begin
  inherited Create(AControl);
  FNumber := ANumber;
end;

procedure TdxGanttControlViewChartShowBaselinesCommand.DoExecute;
var
  AItem: TdxGanttControlViewChartShowBaselinesHistoryItem;
begin
  inherited DoExecute;
  AItem := TdxGanttControlViewChartShowBaselinesHistoryItem.Create(Control.History);
  AItem.FNewValue := FNumber;
  AItem.FView := View;
  Control.History.AddItem(AItem);
  AItem.Execute;
end;

function TdxGanttControlViewChartShowBaselinesCommand.Enabled: Boolean;
begin
  Result := inherited Enabled and (View.BaselineNumber <> FNumber);
end;

{ TdxGanttControlViewChartBaselinesCustomCommand }

constructor TdxGanttControlViewChartBaselinesCustomCommand.Create(
  AControl: TdxGanttControlBase; ANumber: Integer; ASelected: Boolean);
begin
  inherited Create(AControl);
  FNumber := ANumber;
  FSelected := ASelected;
end;

procedure TdxGanttControlViewChartBaselinesCustomCommand.AfterExecute;
begin
  inherited AfterExecute;
  UpdateBaselineInformation;
end;

procedure TdxGanttControlViewChartBaselinesCustomCommand.BeforeExecute;
begin
  inherited BeforeExecute;
  FNeedBaselineUpdateInformation := False;
end;

procedure TdxGanttControlViewChartBaselinesCustomCommand.DoExecute;
var
  I: Integer;
begin
  inherited DoExecute;
  if Selected then
  begin
    if Controller.FocusedRowIndex < View.DataProvider.Count then
      ProcessTask(TdxGanttControlTask(View.DataProvider.Items[Controller.FocusedRowIndex]))
  end
  else
    for I := 0 to DataModel.Tasks.Count - 1 do
      ProcessTask(DataModel.Tasks[I]);
end;

procedure TdxGanttControlViewChartBaselinesCustomCommand.DoUpdateBaselineInformation;
var
  ABaseline: TdxGanttControlDataModelBaseline;
  AItem: TdxGanttControlCreateBaselineHistoryItem;
begin
  ABaseline := DataModel.Baselines.Find(FNumber);
  if ABaseline = nil then
  begin
    AItem := TdxGanttControlCreateBaselineHistoryItem.Create(Control.History, DataModel.Baselines);
    AItem.Number := FNumber;
    Control.History.AddItem(AItem);
    AItem.Execute;
    ABaseline := DataModel.Baselines[AItem.Index];
  end;
  with TdxGanttControlDataModelBaselineUpdateCommand.Create(Control, ABaseline) do
  try
    Execute;
  finally
    Free;
  end;
end;

procedure TdxGanttControlViewChartBaselinesCustomCommand.ProcessTask(ATask: TdxGanttControlTask);
begin
  if ATask.Blank then
    Exit;
  if DoProcessTask(ATask) then
    FNeedBaselineUpdateInformation := True;
end;

procedure TdxGanttControlViewChartBaselinesCustomCommand.UpdateBaselineInformation;
begin
  if not FNeedBaselineUpdateInformation then
    Exit;
  DoUpdateBaselineInformation;
end;

{ TdxGanttControlViewChartSetBaselinesCommand }

function TdxGanttControlViewChartSetBaselinesCommand.DoProcessTask(ATask: TdxGanttControlTask): Boolean;
begin
  with TdxGanttControlTaskSetBaselineCommand.Create(Control, ATask, Number) do
  try
    Result := Enabled;
    Execute;
  finally
    Free;
  end;
end;

{ TdxGanttControlViewChartClearBaselinesCommand }

function TdxGanttControlViewChartClearBaselinesCommand.DoProcessTask(ATask: TdxGanttControlTask): Boolean;
var
  ABaseline: TdxGanttControlTaskBaseline;
begin
  ABaseline := ATask.Baselines.Find(Number);
  Result := ABaseline <> nil;
  if Result then
    RemoveBaseline(ABaseline);
end;

procedure TdxGanttControlViewChartClearBaselinesCommand.DoUpdateBaselineInformation;
var
  ABaseline: TdxGanttControlDataModelBaseline;
begin
  if Selected then
    inherited DoUpdateBaselineInformation
  else
  begin
    ABaseline := DataModel.Baselines.Find(Number);
    if ABaseline <> nil then
      RemoveBaseline(ABaseline);
  end;
end;

procedure TdxGanttControlViewChartClearBaselinesCommand.RemoveBaseline(ABaseline: TdxGanttControlCustomBaseline);
var
  AHistoryItem: TdxGanttControlRemoveItemHistoryItem;
begin
  AHistoryItem := TdxGanttControlRemoveItemHistoryItem.Create(Control.History, ABaseline.Owner);
  AHistoryItem.Index := ABaseline.Owner.IndexOf(ABaseline);
  Control.History.AddItem(AHistoryItem);
  AHistoryItem.Execute;
end;

function TdxGanttControlViewChartClearBaselinesCommand.Enabled: Boolean;
begin
  Result := inherited Enabled and (DataModel.Baselines.Find(Number) <> nil);
end;

{ TdxGanttControlScrollToTaskCommand }

procedure TdxGanttControlScrollToTaskCommand.DoExecute;
begin
  inherited DoExecute;
  if not((Task.Start >= View.FirstVisibleDateTime) and ((Task.Start < TdxGanttControlChartViewAccess(View).GetLastVisibleDateTime))) then
    View.FirstVisibleDateTime := Task.Start;
end;

function TdxGanttControlScrollToTaskCommand.Enabled: Boolean;
begin
  Result := inherited Enabled and (Task <> nil) and (not Task.Blank) and
    Task.IsValueAssigned(TdxGanttTaskAssignedValue.Start) and Task.IsValueAssigned(TdxGanttTaskAssignedValue.Finish) and
    (View.PopupMenuItems.ScrollToTask = TdxGanttControlViewPopupMenuItem.Default);
end;

function TdxGanttControlScrollToTaskCommand.GetMenuCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlCommandScrollToTaskCaption);
end;

function TdxGanttControlScrollToTaskCommand.GetMenuImage: TdxSmartImage;
begin
  Result := TdxGanttControlImages.MenuScrollToTask;
end;

function TdxGanttControlScrollToTaskCommand.Visible: Boolean;
begin
  Result := inherited Visible and
    (View.PopupMenuItems.ScrollToTask <> TdxGanttControlViewPopupMenuItem.Hidden);
end;

{ TdxGanttControlInsertTaskViewCommand }

procedure TdxGanttControlInsertTaskViewCommand.DoExecute;
begin
  inherited DoExecute;
  with TdxGanttControlSheetInsertNewItemCommand.Create(Controller.SheetController) do
  try
    Execute;
  finally
    Free;
  end;
end;

function TdxGanttControlInsertTaskViewCommand.Enabled: Boolean;
begin
  Result := inherited Enabled and not Control.OptionsBehavior.ReadOnly and Control.IsEditable and
    (View.PopupMenuItems.InsertTask = TdxGanttControlViewPopupMenuItem.Default);
end;

function TdxGanttControlInsertTaskViewCommand.GetMenuCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlCommandInsertTaskCaption);
end;

function TdxGanttControlInsertTaskViewCommand.Visible: Boolean;
begin
  Result := inherited Visible and
    (View.PopupMenuItems.InsertTask <> TdxGanttControlViewPopupMenuItem.Hidden);
end;

{ TdxGanttControlDeleteTaskViewCommand }

procedure TdxGanttControlDeleteTaskViewCommand.DoExecute;
begin
  inherited DoExecute;
  TdxGanttControlChartViewSheetControllerAccess(Controller.SheetController).DeleteFocusedItem;
end;

function TdxGanttControlDeleteTaskViewCommand.Enabled: Boolean;
begin
  Result := inherited Enabled and Control.IsEditable and (Task <> nil) and
    (View.PopupMenuItems.DeleteTask = TdxGanttControlViewPopupMenuItem.Default);
end;

function TdxGanttControlDeleteTaskViewCommand.GetMenuCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlCommandDeleteTaskCaption);
end;

function TdxGanttControlDeleteTaskViewCommand.Visible: Boolean;
begin
  Result := inherited Visible and
    (View.PopupMenuItems.DeleteTask <> TdxGanttControlViewPopupMenuItem.Hidden);
end;

{ TdxGanttControlOpenTaskInformationDialogCommand }

procedure TdxGanttControlOpenTaskInformationDialogCommand.DoExecute;
begin
  inherited DoExecute;
  TdxGanttControlChartViewSheetControllerAccess(Controller.SheetController).ShowTaskInformationDialog(Task);
end;

function TdxGanttControlOpenTaskInformationDialogCommand.Enabled: Boolean;
begin
  Result := inherited Enabled and (Control.IsEditable or ((Task <> nil) and not Task.Blank)) and
    (View.PopupMenuItems.ShowTaskInformationDialog = TdxGanttControlViewPopupMenuItem.Default);
end;

function TdxGanttControlOpenTaskInformationDialogCommand.GetMenuCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlCommandInformationCaption);
end;

function TdxGanttControlOpenTaskInformationDialogCommand.GetMenuImage: TdxSmartImage;
begin
  Result := TdxGanttControlImages.MenuTaskInformation;
end;

function TdxGanttControlOpenTaskInformationDialogCommand.Visible: Boolean;
begin
  Result := inherited Visible and
    (View.PopupMenuItems.ShowTaskInformationDialog <> TdxGanttControlViewPopupMenuItem.Hidden);
end;

{ TdxGanttControlInsertRecurringTaskCommand }

procedure TdxGanttControlInsertRecurringTaskCommand.DoExecute;
begin
  inherited DoExecute;
  TdxGanttControlChartViewSheetControllerAccess(Controller.SheetController).ShowRecurringTaskInformationDialog(nil);
end;

function TdxGanttControlInsertRecurringTaskCommand.Enabled: Boolean;
begin
  Result := inherited Enabled and Control.IsEditable and
    (View.PopupMenuItems.InsertRecurringTask = TdxGanttControlViewPopupMenuItem.Default);
end;

function TdxGanttControlInsertRecurringTaskCommand.GetMenuCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlCommandInsertRecurringTaskCaption);
end;

function TdxGanttControlInsertRecurringTaskCommand.GetMenuImage: TdxSmartImage;
begin
  Result := TdxGanttControlImages.TaskRecurring;
end;

function TdxGanttControlInsertRecurringTaskCommand.Visible: Boolean;
begin
  Result := inherited Visible and
    (View.PopupMenuItems.InsertRecurringTask <> TdxGanttControlViewPopupMenuItem.Hidden);
end;

{ TdxGanttControlAddTaskToTimelineCommand }

procedure TdxGanttControlAddTaskToTimelineCommand.DoExecute;
begin
  inherited DoExecute;
  with TdxGanttControlChangeTaskDisplayOnTimelineCommand.Create(Control, Task, not IsChecked) do
  try
    Execute;
  finally
    Free;
  end;
end;

function TdxGanttControlAddTaskToTimelineCommand.Enabled: Boolean;
begin
  Result := inherited Enabled and Control.IsEditable and (Task <> nil) and (not Task.Blank) and
    (View.PopupMenuItems.AddToTimeline = TdxGanttControlViewPopupMenuItem.Default);
end;

function TdxGanttControlAddTaskToTimelineCommand.GetMenuCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlCommandAddTaskToTimelineCaption);
end;

function TdxGanttControlAddTaskToTimelineCommand.GetMenuImage: TdxSmartImage;
begin
  Result := nil;
end;

function TdxGanttControlAddTaskToTimelineCommand.IsChecked: Boolean;
begin
  Result := (Task <> nil) and not Task.Blank and
    Task.IsValueAssigned(TdxGanttTaskAssignedValue.DisplayOnTimeline) and Task.DisplayOnTimeline;
end;

function TdxGanttControlAddTaskToTimelineCommand.Visible: Boolean;
begin
  Result := inherited Visible and
    (View.PopupMenuItems.AddToTimeline <> TdxGanttControlViewPopupMenuItem.Hidden);
end;

{ TdxGanttControlViewTimelineCommand }

function TdxGanttControlViewTimelineCommand.Enabled: Boolean;
begin
  Result := TdxCustomGanttControl(Control).ViewTimeline.Active;
end;

function TdxGanttControlViewTimelineCommand.GetController: TdxGanttControlTimelineViewController;
begin
  Result := TdxGanttControlTimelineViewController(inherited Controller);
end;

function TdxGanttControlViewTimelineCommand.GetTasks: TdxFastObjectList;
begin
  Result := TdxGanttControlTimelineViewAccess(View).ViewInfo.Controller.Selection;
end;

function TdxGanttControlViewTimelineCommand.GetView: TdxGanttControlCustomView;
begin
  Result := TdxCustomGanttControl(Control).ViewTimeline;
end;

function TdxGanttControlViewTimelineCommand.InternalGetView: TdxGanttControlTimelineView;
begin
  Result := TdxCustomGanttControl(Control).ViewTimeline;
end;

{ TdxGanttControlGoToTaskCommand }

procedure TdxGanttControlGoToTaskCommand.DoExecute;

  function GetParent(
    ATask: TdxGanttControlTask): TdxGanttControlTask;
  var
    I: Integer;
  begin
    Result := nil;
    if ATask.OutlineLevel = 0 then
      Exit;
    for I := ATask.ID - 1 downto 0 do
      if (ATask.Owner[I].Summary) and (ATask.Owner[I].OutlineLevel = ATask.OutlineLevel - 1) then
        Exit(ATask.Owner[I]);
  end;

  procedure ExpandTaskParent(AParent: TdxGanttControlTask);
  var
    AView: TdxGanttControlChartView;
  begin
    if (AParent = nil) or (AParent.ID = 0) then
      Exit;
    AView := TdxCustomGanttControlAccess(Control).ViewChart;
    ExpandTaskParent(GetParent(AParent));
    if not AView.DataProvider.IsExpanded(AParent) then
    begin
      TdxCustomGanttControl(Control).ViewChart.Controller.FocusedRowIndex := TdxCustomGanttControl(Control).ViewChart.DataProvider.IndexOf(AParent);
      TdxGanttControlSheetControllerAccess(AView.Controller.SheetController).ExpandItem;
      AView.DataProvider.Refresh(True);
      TdxCustomGanttControlAccess(Control).ViewInfo.Recalculate;
    end;
  end;

var
  ATask: TdxGanttControlTask;
begin
  ATask := TdxGanttControlTask(Tasks[Tasks.Count - 1]);
  with TdxGanttControlActivateChartViewCommand.Create(Control) do
  try
    Execute;
  finally
    Free;
  end;

  TdxCustomGanttControlAccess(Control).ViewInfo.CalculateLayout;
  TdxCustomGanttControlAccess(Control).ViewInfo.Recalculate;
  TdxGanttControlCustomControllerAccess(TdxCustomGanttControl(Control).ViewChart.Controller).InitScrollbars;
  TdxCustomGanttControlAccess(Control).ViewInfo.Recalculate;
  ExpandTaskParent(GetParent(ATask));
  TdxCustomGanttControl(Control).ViewChart.Controller.FocusedRowIndex := TdxCustomGanttControl(Control).ViewChart.DataProvider.IndexOf(ATask);
  if not((ATask.Start >= TdxCustomGanttControl(Control).ViewChart.FirstVisibleDateTime) and
     ((ATask.Start < TdxGanttControlChartViewAccess(TdxCustomGanttControl(Control).ViewChart).GetLastVisibleDateTime))) then
    TdxCustomGanttControl(Control).ViewChart.FirstVisibleDateTime := ATask.Start;
end;

function TdxGanttControlGoToTaskCommand.Enabled: Boolean;
begin
  Result := inherited Enabled and (Tasks.Count = 1) and
    (View.PopupMenuItems.GoToTask = TdxGanttControlViewPopupMenuItem.Default);
end;

function TdxGanttControlGoToTaskCommand.GetMenuCaption: string;
begin
    Result := cxGetResourceString(@sdxGanttControlCommandGoToTaskCaption)
end;

function TdxGanttControlGoToTaskCommand.Visible: Boolean;
begin
  Result := inherited Visible and
    (View.PopupMenuItems.GoToTask <> TdxGanttControlViewPopupMenuItem.Hidden);
end;

{ TdxGanttControlRemoveTaskFromTimelineCommand }

procedure TdxGanttControlRemoveTaskFromTimelineCommand.DoExecute;
var
  I: Integer;
begin
  View.BeginUpdate;
  try
    for I := 0 to Tasks.Count - 1 do
      with TdxGanttControlChangeTaskDisplayOnTimelineCommand.Create(Control, TdxGanttControlTask(Tasks[I]), False) do
      try
        Execute;
      finally
        Free;
      end;
  finally
    TdxGanttControlTimelineViewAccess(View).Changed([TdxGanttControlOptionsChangedType.Layout]);
    View.EndUpdate;
  end;
end;

function TdxGanttControlRemoveTaskFromTimelineCommand.Enabled: Boolean;
begin
  Result := inherited Enabled and (Tasks.Count > 0) and Control.IsEditable and
    (View.PopupMenuItems.RemoveTask = TdxGanttControlViewPopupMenuItem.Default);
end;

function TdxGanttControlRemoveTaskFromTimelineCommand.GetMenuCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlCommandRemoveFromTimelineCaption);
end;

function TdxGanttControlRemoveTaskFromTimelineCommand.Visible: Boolean;
begin
  Result := inherited Visible and
    (View.PopupMenuItems.RemoveTask <> TdxGanttControlViewPopupMenuItem.Hidden);
end;

{ TdxGanttControlTimelineOpenTaskInformationDialogCommand }

procedure TdxGanttControlTimelineOpenTaskInformationDialogCommand.DoExecute;
begin
  inherited DoExecute;
  TdxGanttControlTimelineViewControllerAccess(Controller).ShowTaskInformationDialog(TdxGanttControlTask(Tasks[Tasks.Count - 1]));
end;

function TdxGanttControlTimelineOpenTaskInformationDialogCommand.Enabled: Boolean;
begin
  Result := inherited Enabled and (Tasks.Count = 1) and
    (View.PopupMenuItems.ShowTaskInformationDialog = TdxGanttControlViewPopupMenuItem.Default);
end;

function TdxGanttControlTimelineOpenTaskInformationDialogCommand.GetMenuCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlCommandInformationCaption);
end;

function TdxGanttControlTimelineOpenTaskInformationDialogCommand.GetMenuImage: TdxSmartImage;
begin
  Result := TdxGanttControlImages.MenuTaskInformation;
end;

function TdxGanttControlTimelineOpenTaskInformationDialogCommand.Visible: Boolean;
begin
  Result := inherited Visible and
    (View.PopupMenuItems.ShowTaskInformationDialog <> TdxGanttControlViewPopupMenuItem.Hidden);
end;

{ TdxGanttControlViewSheetCommand }

constructor TdxGanttControlViewSheetCommand.Create(
  ASheetController: TdxGanttControlViewSheetController);
begin
  inherited Create(ASheetController.Control);
  FSheetController := ASheetController;
end;

function TdxGanttControlViewSheetCommand.Enabled: Boolean;
begin
  Result := TdxGanttControlSheetControllerAccess(SheetController).ViewInfo <> nil;
end;

function TdxGanttControlViewSheetCommand.GetOptions: TdxGanttControlSheetOptions;
begin
  Result := TdxGanttControlSheetControllerAccess(SheetController).Options;
end;

function TdxGanttControlViewSheetCommand.GetView: TdxGanttControlCustomView;
begin
  Result := SheetController.View;
end;

{ TdxGanttControlViewSheetColumnCommand }

constructor TdxGanttControlViewSheetColumnCommand.Create(
  ASheetController: TdxGanttControlViewSheetController;
  AColumn: TdxGanttControlSheetColumn);
begin
  inherited Create(ASheetController);
  FColumn := AColumn;
end;

{ TdxGanttControlViewSheetBestFitColumnCommand }

procedure TdxGanttControlViewSheetBestFitColumnCommand.DoExecute;
begin
  TdxGanttControlSheetControllerAccess(SheetController).CalculateBestFit(Column);
end;

function TdxGanttControlViewSheetBestFitColumnCommand.GetMenuCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlCommandBestFitColumnCaption);
end;

function TdxGanttControlViewSheetBestFitColumnCommand.GetMenuImage: TdxSmartImage;
begin
  Result := nil;
end;

function TdxGanttControlViewSheetBestFitColumnCommand.Visible: Boolean;
begin
  Result := inherited Visible and (Column <> nil) and TdxGanttControlSheetColumnAccess(Column).RealAllowSize;
end;

{ TdxGanttControlViewSheetBestFitAllColumnsCommand }

procedure TdxGanttControlViewSheetBestFitAllColumnsCommand.DoExecute;
var
  I: Integer;
begin
  for I := 0 to Options.Columns.Count - 1 do
    if Options.Columns[I].Visible then
      TdxGanttControlSheetControllerAccess(SheetController).CalculateBestFit(Options.Columns[I]);
end;

function TdxGanttControlViewSheetBestFitAllColumnsCommand.GetMenuCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlCommandBestFitAllColumnsCaption);
end;

function TdxGanttControlViewSheetBestFitAllColumnsCommand.GetMenuImage: TdxSmartImage;
begin
  Result := nil;
end;

function TdxGanttControlViewSheetBestFitAllColumnsCommand.Visible: Boolean;
begin
  Result := inherited Visible and Options.AllowColumnSize;
end;

{ TdxGanttControlViewSheetRenameColumnCommand }

procedure TdxGanttControlViewSheetRenameColumnCommand.BeginUpdate;
begin
// do nothing
end;

procedure TdxGanttControlViewSheetRenameColumnCommand.EndUpdate;
begin
// do nothing
end;

procedure TdxGanttControlViewSheetRenameColumnCommand.DoExecute;
begin
  inherited DoExecute;
  TdxGanttControlSheetControllerAccess(SheetController).ShowColumnRenameEdit(Column);
end;

function TdxGanttControlViewSheetRenameColumnCommand.GetMenuCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlCommandRenameColumnCaption);
end;

function TdxGanttControlViewSheetRenameColumnCommand.GetMenuImage: TdxSmartImage;
begin
  Result := TdxGanttControlImages.MenuRenameColumn;
end;

function TdxGanttControlViewSheetRenameColumnCommand.Visible: Boolean;
begin
  Result := inherited Visible and (Column <> nil) and TdxGanttControlSheetColumnAccess(Column).RealAllowRename;
end;

{ TdxGanttControlViewSheetWordWrapCommand }

procedure TdxGanttControlViewSheetWordWrapCommand.DoExecute;
var
  AHistoryItem: TdxGanttControlSheetToggleWordWrapHistoryItem;
begin
  inherited DoExecute;
  AHistoryItem := TdxGanttControlSheetToggleWordWrapHistoryItem.Create(SheetController);
  AHistoryItem.FColumn := Column;
  Control.History.AddItem(AHistoryItem);
  AHistoryItem.Execute;
end;

function TdxGanttControlViewSheetWordWrapCommand.GetMenuCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlCommandWordWrapCaption);
end;

function TdxGanttControlViewSheetWordWrapCommand.GetMenuImage: TdxSmartImage;
begin
  Result := TdxGanttControlImages.MenuWordWrap;
end;

function TdxGanttControlViewSheetWordWrapCommand.IsChecked: Boolean;
begin
  Result := Column.WordWrap;
end;

function TdxGanttControlViewSheetWordWrapCommand.Visible: Boolean;
begin
  Result := inherited Visible and (Column <> nil) and TdxGanttControlSheetColumnAccess(Column).RealAllowWordWrap;
end;

{ TdxGanttControlViewSheetHideColumnCommand }

procedure TdxGanttControlViewSheetHideColumnCommand.DoExecute;
begin
  inherited DoExecute;
  with TdxGanttControlSheetHideColumnCommand.Create(SheetController, Column.Index) do
  try
    Execute;
  finally
    Free;
  end;
end;

function TdxGanttControlViewSheetHideColumnCommand.GetMenuCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlCommandHideColumnCaption);
end;

function TdxGanttControlViewSheetHideColumnCommand.GetMenuImage: TdxSmartImage;
begin
  Result := TdxGanttControlImages.MenuHideColumn;
end;

function TdxGanttControlViewSheetHideColumnCommand.Visible: Boolean;
begin
  Result := inherited Visible and (Column <> nil) and TdxGanttControlSheetColumnAccess(Column).RealAllowHide;
end;

{ TdxGanttControlViewSheetInsertColumnCommand }

procedure TdxGanttControlViewSheetInsertColumnCommand.DoExecute;
begin
  inherited DoExecute;
  TdxGanttControlSheetControllerAccess(SheetController).ShowColumnInsertEdit(Column);
end;

function TdxGanttControlViewSheetInsertColumnCommand.GetMenuCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlCommandInsertColumnCaption);
end;

function TdxGanttControlViewSheetInsertColumnCommand.GetMenuImage: TdxSmartImage;
begin
  Result := TdxGanttControlImages.MenuInsertColumn;
end;

function TdxGanttControlViewSheetInsertColumnCommand.IsThereColumnToInsert: Boolean;
var
  I: Integer;
begin
  for I := 0 to Options.Columns.Count - 1 do
  begin
    if Options.Columns[I].Visible then
      Continue;
    if TdxGanttControlSheetColumnAccess(Options.Columns[I]).RealAllowInsert then
      Exit(True);
  end;
  Result := False;
end;

function TdxGanttControlViewSheetInsertColumnCommand.Visible: Boolean;
begin
  Result := inherited Visible and IsThereColumnToInsert;
end;

{ TdxGanttControlViewSheetShowChooseColumnDetailsDialogCommand }

procedure TdxGanttControlViewSheetShowChooseColumnDetailsDialogCommand.DoExecute;
begin
  TdxGanttControlSheetControllerAccess(SheetController).ShowChooseColumnDetailsDialog;
end;

function TdxGanttControlViewSheetShowChooseColumnDetailsDialogCommand.GetMenuCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlCommandShowChooseColumnDetailsDialogCaption);
end;

function TdxGanttControlViewSheetShowChooseColumnDetailsDialogCommand.GetMenuImage: TdxSmartImage;
begin
  Result := nil;
end;

function TdxGanttControlViewSheetShowChooseColumnDetailsDialogCommand.Visible: Boolean;
begin
  Result := inherited Visible and Options.AllowColumnDetailCustomization;
end;

end.
