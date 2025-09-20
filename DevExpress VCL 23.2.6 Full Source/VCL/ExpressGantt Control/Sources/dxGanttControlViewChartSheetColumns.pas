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

unit dxGanttControlViewChartSheetColumns;

{$I cxVer.inc}
{$I dxGanttControl.inc}

interface

uses
  System.UITypes, System.Contnrs,
  Types, SysUtils, Graphics, Generics.Defaults, Generics.Collections, Windows,
  Controls, Classes, Variants,
  dxCore, dxCoreClasses, cxVariants, cxEdit, cxControls, cxCustomCanvas, dxGDIPlusClasses,
  cxGeometry, cxCheckBox, dxTreeView, cxSpinEdit, dxMeasurementUnitEdit,
  dxGanttControlCustomClasses,
  dxGanttControlCustomSheet,
  dxGanttControlCustomDataModel,
  dxGanttControlDataModel,
  dxGanttControlCommands,
  dxGanttControlDialogUtils,
  dxGanttControlTaskCommands,
  dxGanttControlResources,
  dxGanttControlTasks,
  dxGanttControlCalendars,
  dxGanttControlExtendedAttributes,
  dxGanttControlSheetColumns;

type
  TdxGanttControlViewChartSheetColumn = class;

  { TdxGanttControlViewChartSheetColumn }

  TdxGanttControlViewChartSheetColumn = class abstract(TdxGanttControlSheetColumn)
  strict private
    function GetDataModel: TdxGanttControlDataModel; inline;
  protected
    function CreateChangeValueCommand(AControl: TdxGanttControlBase; ADataItem: TObject; const ANewValue: Variant): TdxGanttControlCommand; override;
    function CreateProperties: TcxCustomEditProperties; override;
    function GetChangeValueCommandClass: TdxGanttControlChangeTaskPropertyCommandClass; virtual; abstract;
    function DoGetEditValue(ATask: TdxGanttControlTask): Variant; virtual; abstract;

    function GetEditValue(AData: TObject): Variant; override; final;

    property DataModel: TdxGanttControlDataModel read GetDataModel;
  end;

  { TdxGanttControlChangeTaskDurationValueCommand }

  TdxGanttControlChangeTaskDurationValueCommand = class(TdxGanttControlChangeTaskPropertyCommand)
  strict private
    FDuration: Variant;
    FDurationFormat: TdxDurationFormat;
    FEstimated: Boolean;
  protected
    procedure BeforeExecute; override;
    function GetAssignedValue: TdxGanttTaskAssignedValue; override;
    function GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass; override;
    function GetDurationFormat(const ADescription: string; ADefaultFormat: TdxDurationFormat): TdxDurationFormat;
    function HasAssignedValue: Boolean; override;
    procedure SetValue; override;
  public
    constructor Create(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask; const ANewValue: Variant); override;
  end;

  { TdxGanttControlViewChartSheetColumns }

  TdxGanttControlViewChartSheetColumns = class(TdxGanttControlViewSheetColumns)
  protected
    function GetExtendedAttributeColumnClass: TdxGanttControlExtendedAttributeSheetColumnClass; override;
    function GetFieldLevel: TdxGanttControlExtendedAttributeLevel; override;
    procedure RegisterColumnClasses; override;
    function StoredCreateChild(const AObjectName, AClassName: string): TObject; override;
  end;

  { TdxGanttControlViewChartSheetColumnIndicator }

  TdxGanttControlViewChartSheetColumnIndicator = class(TdxGanttControlViewChartSheetColumn)
  protected
    function CanShowFilterButton: Boolean; override;
    function CreateViewInfo(ASheetViewInfo: TdxGanttControlSheetCustomViewInfo): TdxGanttControlSheetColumnHeaderViewInfo; override;
    function GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass; override;
    function GetDefaultAllowRename: TdxDefaultBoolean; override;
    function GetDefaultAllowWordWrap: TdxDefaultBoolean; override;
    function GetDefaultCaption: string; override;
    function GetDefaultShowFilterButton: Boolean; override;
    function GetDefaultWidth: Integer; override;
    class function GetDesignCaption: string; override;
    function GetHintText: string; override;
  end;

  { TdxGanttControlImageViewInfo }

  TdxGanttControlImageViewInfo = class(TdxGanttControlCustomOwnedItemViewInfo)
  strict private
    FImage: TdxGPImage;
  protected
    FHintText: string;
    procedure DoDraw; override;
    function GetHintText: string; override;
    function HasHint: Boolean; override;

    property Image: TdxGPImage read FImage;
  public
    constructor Create(AOwner: TdxGanttControlCustomItemViewInfo; AImage: TdxGPImage); reintroduce;
  end;

  { TdxGanttControlViewChartSheetColumnIndicatorCellViewInfo }

  TdxGanttControlViewChartSheetColumnIndicatorCellViewInfo = class(TdxGanttControlSheetCellViewInfo)
  strict private
    FImages: TObjectList<TdxGanttControlImageViewInfo>;
  protected
    function CalculateBestFit: Integer; override;
    function CalculateHitTest(const AHitTest: TdxGanttControlHitTest): Boolean; override;
    procedure DoDraw; override;
    procedure DoScroll(const DX: Integer; const DY: Integer); override;
  public
    constructor Create(AOwner: TdxGanttControlSheetDataRowViewInfo; AColumnViewInfo: TdxGanttControlSheetColumnHeaderViewInfo;
      AColumn: TdxGanttControlSheetColumn); override;
    destructor Destroy; override;

    procedure Calculate(const R: TRect); override;
  end;

  { TdxGanttControlViewChartSheetColumnIndicatorHeaderViewInfo }

  TdxGanttControlViewChartSheetColumnIndicatorHeaderViewInfo = class(TdxGanttControlSheetColumnHeaderImageViewInfo)
  protected
    function CalculateImage: TdxGPImage; override;
  end;

  { TdxGanttControlViewChartSheetColumnTaskMode }

  TdxGanttControlViewChartSheetColumnTaskMode = class(TdxGanttControlViewChartSheetColumn)
  protected
    function CreateProperties: TcxCustomEditProperties; override;
    function GetChangeValueCommandClass: TdxGanttControlChangeTaskPropertyCommandClass; override;
    function GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass; override;
    function GetDefaultAllowWordWrap: TdxDefaultBoolean; override;
    function GetDefaultCaption: string; override;
    function GetDefaultWidth: Integer; override;
    class function GetDesignCaption: string; override;
    function GetHintText: string; override;
    function GetPropertiesClass: TcxCustomEditPropertiesClass; override;
    function DoGetEditValue(ATask: TdxGanttControlTask): Variant; override;
  end;

  { TdxGanttControlViewChartSheetColumnTaskModeViewInfo }

  TdxGanttControlViewChartSheetColumnTaskModeViewInfo = class(TdxGanttControlSheetCellViewInfo)
  strict private
    FImage: TdxGPImage;
    FImageRect: TRect;
  protected
    procedure DoDraw; override;
    procedure DoScroll(const DX: Integer; const DY: Integer); override;
  public
    procedure Calculate(const R: TRect); override;
  end;

  { TdxGanttControlViewChartSheetColumnViewInfo }

  TdxGanttControlViewChartSheetColumnViewInfo = class(TdxGanttControlSheetCellStringValueViewInfo)
  protected
    function HasDisplayText: Boolean; override;
    function GetFont: TFont; override;
    function IsSummary: Boolean;
  end;

  { TdxGanttControlViewChartSheetColumnTaskName }

  TdxGanttControlViewChartSheetColumnTaskName = class(TdxGanttControlViewChartSheetColumn)
  protected
    function GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass; override;
    function GetDefaultCaption: string; override;
    function GetDefaultWidth: Integer; override;
    function GetDefaultWordWrap: Boolean; override;
    function GetChangeValueCommandClass: TdxGanttControlChangeTaskPropertyCommandClass; override;
    class function GetDesignCaption: string; override;
    function GetHintText: string; override;
    function GetPropertiesClass: TcxCustomEditPropertiesClass; override;

    function DoGetEditValue(ATask: TdxGanttControlTask): Variant; override;
  end;

  { TdxGanttControlViewChartSheetColumnTaskNameViewInfo }

  TdxGanttControlViewChartSheetColumnTaskNameViewInfo = class(TdxGanttControlViewChartSheetColumnViewInfo)
  strict private
    function CalculateExpandButtonBounds: TRect;
    function CalculateTextOffset: Integer;
    function GetLevelOffset: Integer;
  protected
    function CalculateBestFit: Integer; override;
    function CalculateTextBounds: TRect; override;
    function CalculateItemBounds(AItem: TdxGanttControlCustomItemViewInfo): TRect; override;
    function GetCurrentCursor(const P: TPoint; const ADefaultCursor: TCursor): TCursor; override;
  public
    procedure CalculateLayout; override;
    function MeasureHeight(AWidth: Integer): Integer; override;

    class function CalculateOutlineLevelOffset(AScaleFactor: TdxScaleFactor; AOutlineLevel: Integer; AIsTouchModeEnabled: Boolean): Integer; static;

    function IsOutlineLevelChangeZone(const P: TPoint): Boolean;
  end;

  { TdxGanttControlViewChartSheetExpandButtonViewInfo }

  TdxGanttControlViewChartSheetExpandButtonViewInfo = class(TdxGanttControlCustomOwnedItemViewInfo)
  strict private
    FButtonBounds: TRect;
    function IsExpanded: Boolean;
    function GetOwner: TdxGanttControlViewChartSheetColumnTaskNameViewInfo; inline;
  protected
    procedure DoDraw; override;
    procedure DoScroll(const DX: Integer; const DY: Integer); override;
  public
    procedure Calculate(const R: TRect); override;
    property Owner: TdxGanttControlViewChartSheetColumnTaskNameViewInfo read GetOwner;
  end;

  { TdxGanttControlViewChartSheetCustomColumnPercentComplete }

  TdxGanttControlViewChartSheetCustomColumnPercentComplete = class(TdxGanttControlViewChartSheetColumn)
  strict private
    FShowProgressBar: Boolean;
    procedure SetShowProgressBar(const Value: Boolean);
  protected
    function CreateProperties: TcxCustomEditProperties; override;
    function GetAlignment: TAlignment; override;
    function GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass; override;
    function GetDefaultVisible: Boolean; override;
    function GetDefaultWidth: Integer; override;
    function GetPropertiesClass: TcxCustomEditPropertiesClass; override;
    procedure DoReset; override;

    property ShowProgressBar: Boolean read FShowProgressBar write SetShowProgressBar default False;
  public
    procedure Assign(Source: TPersistent); override;
  end;

  { TdxGanttControlViewChartSheetColumnPercentComplete }

  TdxGanttControlViewChartSheetColumnPercentComplete = class(TdxGanttControlViewChartSheetCustomColumnPercentComplete)
  protected
    function GetDefaultCaption: string; override;
    function GetChangeValueCommandClass: TdxGanttControlChangeTaskPropertyCommandClass; override;
    class function GetDesignCaption: string; override;
    function GetHintText: string; override;

    function DoGetEditValue(ATask: TdxGanttControlTask): Variant; override;
  end;

  { TdxGanttControlViewChartSheetColumnPercentWorkComplete }

  TdxGanttControlViewChartSheetColumnPercentWorkComplete = class(TdxGanttControlViewChartSheetCustomColumnPercentComplete)
  protected
    function GetDefaultCaption: string; override;
    function GetChangeValueCommandClass: TdxGanttControlChangeTaskPropertyCommandClass; override;
    class function GetDesignCaption: string; override;
    function GetHintText: string; override;

    function DoGetEditValue(ATask: TdxGanttControlTask): Variant; override;
  end;

  { TdxGanttControlViewChartSheetColumnTaskPercentCompleteViewInfo }

  TdxGanttControlViewChartSheetColumnTaskPercentCompleteViewInfo = class(TdxGanttControlViewChartSheetColumnViewInfo)
  strict private
    FProgressBarBounds: TRect;
    function CalculateProgressBarBounds: TRect;
    function GetColumn: TdxGanttControlViewChartSheetCustomColumnPercentComplete; inline;
  protected
    function DoCalculateDisplayText: string; override;
    procedure DoDraw; override;
    function GetDrawTextFlags: Integer; override;
  public
    procedure Calculate(const R: TRect); override;
    property Column: TdxGanttControlViewChartSheetCustomColumnPercentComplete read GetColumn;
  end;

  { TdxGanttControlViewChartSheetColumnTaskDuration }

  TdxGanttControlViewChartSheetColumnTaskDuration = class(TdxGanttControlViewChartSheetColumn,
    IdxGanttControlDurationEditPropertiesHelper)
  strict private
  {$REGION 'IdxGanttControlDurationEditPropertiesHelper'}
    function GetDurationFormat(ADataItem: TObject): TdxDurationFormat;
    function GetValue(ADataItem: TObject): Double;
  {$ENDREGION}
  protected
    function GetChangeValueCommandClass: TdxGanttControlChangeTaskPropertyCommandClass; override;
    function GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass; override;
    function GetDefaultCaption: string; override;
    function GetDefaultWidth: Integer; override;
    class function GetDesignCaption: string; override;
    function GetHintText: string; override;
    function GetPropertiesClass: TcxCustomEditPropertiesClass; override;
    procedure PrepareEditProperties(AProperties: TcxCustomEditProperties; AData: TObject); override;

    function DoGetEditValue(ATask: TdxGanttControlTask): Variant; override;
  end;

  { TdxGanttControlViewChartSheetColumnTaskDurationViewInfo }

  TdxGanttControlViewChartSheetColumnTaskDurationViewInfo = class(TdxGanttControlViewChartSheetColumnViewInfo);

  { TdxGanttControlViewChartSheetColumnDateTime }

  TdxGanttControlViewChartSheetColumnDateTime = class abstract(TdxGanttControlViewChartSheetColumn,
    IdxGanttControlDateEditPropertiesHelper)
  protected
    function GetActiveCalendar(ADataItem: TObject): TdxGanttControlCalendar;
    procedure PrepareEditProperties(AProperties: TcxCustomEditProperties; AData: TObject); override;
  end;

  { TdxGanttControlViewChartSheetColumnTaskStart }

  TdxGanttControlViewChartSheetColumnTaskStart = class(TdxGanttControlViewChartSheetColumnDateTime)
  protected
    function GetDefaultCaption: string; override;
    function GetDefaultWidth: Integer; override;
    class function GetDesignCaption: string; override;
    function GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass; override;
    function GetHintText: string; override;

    function DoGetEditValue(ATask: TdxGanttControlTask): Variant; override;
    function GetChangeValueCommandClass: TdxGanttControlChangeTaskPropertyCommandClass; override;
    function GetPropertiesClass: TcxCustomEditPropertiesClass; override;
  end;

  { TdxGanttControlViewChartSheetColumnTaskStartViewInfo }

  TdxGanttControlViewChartSheetColumnTaskStartViewInfo = class(TdxGanttControlViewChartSheetColumnViewInfo);

  { TdxGanttControlViewChartSheetColumnTaskFinish }

  TdxGanttControlViewChartSheetColumnTaskFinish = class(TdxGanttControlViewChartSheetColumnDateTime)
  protected
    function GetDefaultCaption: string; override;
    function GetDefaultWidth: Integer; override;
    class function GetDesignCaption: string; override;
    function GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass; override;
    function GetHintText: string; override;

    function DoGetEditValue(ATask: TdxGanttControlTask): Variant; override;
    function GetChangeValueCommandClass: TdxGanttControlChangeTaskPropertyCommandClass; override;
    function GetPropertiesClass: TcxCustomEditPropertiesClass; override;
  end;

  { TdxGanttControlViewChartSheetColumnTaskFinishViewInfo }

  TdxGanttControlViewChartSheetColumnTaskFinishViewInfo = class(TdxGanttControlViewChartSheetColumnViewInfo);

  { TdxGanttControlViewChartSheetColumnPopupTreeView }

  TdxGanttControlViewChartSheetColumnPopupTreeView = class abstract(TdxGanttControlViewChartSheetColumn)
  strict private
    FTreeView: TdxInternalTreeView;

    procedure PopupEditPropertiesCloseUpHandler(Sender: TObject);
    procedure PopupEditPrepareDisplayValueHandler(Sender: TObject; const AEditValue: Variant; var ADisplayValue: Variant);
    procedure TreeView1KeyDownHandler(Sender: TObject; var Key: Word; Shift: TShiftState);
  protected
    function CreateProperties: TcxCustomEditProperties; override;
    function GetPropertiesClass: TcxCustomEditPropertiesClass; override;
    procedure PrepareEditProperties(AProperties: TcxCustomEditProperties; AData: TObject); override;

    procedure DoPopupEditPrepareDisplayValueHandler(Sender: TObject; const AEditValue: Variant; var ADisplayValue: Variant); virtual;
    function GetTreeViewValue: Variant; virtual; abstract;
    procedure PrepareTreeViewCheckedStates(AData: TObject); virtual;
    procedure SubscribeDataModelChanges; virtual;
    procedure UnsubscribeDataModelChanges; virtual;
    procedure UpdateTreeView; virtual;

    property TreeView: TdxInternalTreeView read FTreeView;
  public
    constructor Create(AOwner: TdxGanttControlSheetColumns); override;
    destructor Destroy; override;
  end;

  { TdxGanttControlViewChartSheetColumnPredecessors }

  TdxGanttControlViewChartSheetColumnPredecessors = class(TdxGanttControlViewChartSheetColumnPopupTreeView)
  strict private
    procedure TasksChangedHandler(Sender: TdxGanttControlDataModel; ATask: TdxGanttControlTask);
    procedure DoUpdateTreeView(ATasks: TdxGanttControlTasks);
  protected
    function GetDefaultCaption: string; override;
    function GetDefaultVisible: Boolean; override;
    function GetDefaultWidth: Integer; override;
    class function GetDesignCaption: string; override;
    function GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass; override;
    function GetHintText: string; override;

    procedure DoPopupEditPrepareDisplayValueHandler(Sender: TObject; const AEditValue: Variant; var ADisplayValue: Variant); override;
    function GetTreeViewValue: Variant; override;
    procedure PrepareTreeViewCheckedStates(AData: TObject); override;
    procedure SubscribeDataModelChanges; override;
    procedure UnsubscribeDataModelChanges; override;
    procedure UpdateTreeView; override;

    function CreateChangeValueCommand(AControl: TdxGanttControlBase; ADataItem: TObject; const ANewValue: Variant): TdxGanttControlCommand; override;
    function DoGetEditValue(ATask: TdxGanttControlTask): Variant; override;
    function GetChangeValueCommandClass: TdxGanttControlChangeTaskPropertyCommandClass; override;
  end;

  { TdxGanttControlViewChartSheetColumnPredecessorsViewInfo }

  TdxGanttControlViewChartSheetColumnPredecessorsViewInfo = class(TdxGanttControlViewChartSheetColumnViewInfo)
  protected
    function DoCalculateDisplayText: string; override;
    function HasDisplayText: Boolean; override;
  end;

  { TdxGanttControlViewChartSheetColumnResourceName }

  TdxGanttControlViewChartSheetColumnResourceName = class(TdxGanttControlViewChartSheetColumnPopupTreeView)
  strict private
    procedure ResourcesChangedHandler(Sender: TdxGanttControlDataModel; AResource: TdxGanttControlResource);
    procedure DoUpdateTreeView(AResources: TdxGanttControlResources);
  protected
    function GetDefaultCaption: string; override;
    function GetDefaultWidth: Integer; override;
    function GetDefaultWordWrap: Boolean; override;
    class function GetDesignCaption: string; override;
    function GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass; override;
    function GetHintText: string; override;

    procedure DoPopupEditPrepareDisplayValueHandler(Sender: TObject; const AEditValue: Variant; var ADisplayValue: Variant); override;
    function GetTreeViewValue: Variant; override;
    procedure PrepareTreeViewCheckedStates(AData: TObject); override;
    procedure SubscribeDataModelChanges; override;
    procedure UnsubscribeDataModelChanges; override;
    procedure UpdateTreeView; override;

    function DoGetEditValue(ATask: TdxGanttControlTask): Variant; override;
    function GetChangeValueCommandClass: TdxGanttControlChangeTaskPropertyCommandClass; override;
  public
    constructor Create(AOwner: TdxGanttControlSheetColumns); override;
  end;

  { TdxGanttControlViewChartSheetColumnResourceNameViewInfo }

  TdxGanttControlViewChartSheetColumnResourceNameViewInfo = class(TdxGanttControlViewChartSheetColumnViewInfo)
  protected
    function DoCalculateDisplayText: string; override;
  end;

  { TdxGanttControlViewChartExtendedAttributeSheetColumn }

  TdxGanttControlViewChartExtendedAttributeSheetColumn = class(TdxGanttControlExtendedAttributeSheetColumn)
  protected
    function CreateChangeValueCommand(AControl: TdxGanttControlBase; ADataItem: TObject; const ANewValue: Variant): TdxGanttControlCommand; override;
    function GetActiveCalendar(ADataItem: TObject): TdxGanttControlCalendar; override;
    function GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass; override;
    function GetFieldID: Integer; override;
    function GetExtendedAttributeValues(AData: TObject): TdxGanttControlExtendedAttributeValues; override;
  end;

  { TdxGanttControlViewChartExtendedAttributeSheetColumnViewInfo }

  TdxGanttControlViewChartExtendedAttributeSheetColumnViewInfo = class(TdxGanttControlViewChartSheetColumnViewInfo)
  strict private
    function GetColumn: TdxGanttControlViewChartExtendedAttributeSheetColumn; inline;
  protected
    function CalculateItemBounds(AItem: TdxGanttControlCustomItemViewInfo): TRect; override;
    function DoCalculateDisplayText: string; override;
    function GetCurrentCursor(const P: TPoint; const ADefaultCursor: TCursor): TCursor; override;
    function HasDisplayText: Boolean; override;
    property Column: TdxGanttControlViewChartExtendedAttributeSheetColumn read GetColumn;
  public
    procedure CalculateLayout; override;
  end;

implementation

uses
  Math, DateUtils,

  dxCultureInfo, cxGraphics, dxTypeHelpers, cxLookAndFeelPainters,
  cxContainer, cxCalendar, cxTextEdit, cxCheckComboBox, cxDropDownEdit, cxMaskEdit,
  cxDateUtils, cxDrawTextUtils, dxCustomTree,
  dxGanttControlUtils,
  dxGanttControl,
  dxGanttControlCustomView,
  dxGanttControlStrs,
  dxGanttControlCursors,
  dxGanttControlImages,
  dxGanttControlViewChart,
  dxGanttControlTaskInformationDialog;

const
  dxThisUnitName = 'dxGanttControlViewChartSheetColumns';

type
  TcxCustomEditAccess = class(TcxCustomEdit);
  TcxPopupEditAccess = class(TcxPopupEdit);
  TdxGanttControlSheetEditingControllerAccess = class(TdxGanttControlSheetEditingController);
  TdxGanttControlDataModelPropertiesAccess = class(TdxGanttControlDataModelProperties);
  TdxGanttControlSheetCustomViewInfoAccess = class(TdxGanttControlSheetCustomViewInfo);
  TdxGanttControlSheetControllerAccess = class(TdxGanttControlSheetController);
  TdxMeasurementUnitEditHelperAccess = class(TdxMeasurementUnitEditHelper);
  TdxTreeViewCustomOptionsBehaviorAccess = class(TdxTreeViewCustomOptionsBehavior);

type
  { TdxGanttPopupEditProperties }

  TdxGanttPopupEditPropertiesPrepareDisplayValueEvent = procedure(Sender: TObject; const AEditValue: Variant; var ADisplayValue: Variant) of object;

  TdxGanttPopupEditProperties = class(TcxPopupEditProperties)
  strict private
    FOnPrepareDisplayValue: TdxGanttPopupEditPropertiesPrepareDisplayValueEvent;
  protected
    FData: TObject;
  public
    class function GetContainerClass: TcxContainerClass; override;
    procedure DoPrepareDisplayValue(const AEditValue: Variant; var ADisplayValue: Variant; AEditFocused: Boolean); override;
    property OnPrepareDisplayValue: TdxGanttPopupEditPropertiesPrepareDisplayValueEvent read FOnPrepareDisplayValue write FOnPrepareDisplayValue;
  end;

  { TdxGanttPopupEdit }

  TdxGanttPopupEdit = class(TcxPopupEdit)
  public
    class function GetPropertiesClass: TcxCustomEditPropertiesClass; override;
  end;

{ TdxGanttPopupEditProperties }

procedure TdxGanttPopupEditProperties.DoPrepareDisplayValue(
  const AEditValue: Variant; var ADisplayValue: Variant; AEditFocused: Boolean);
begin
  inherited DoPrepareDisplayValue(AEditValue, ADisplayValue, AEditFocused);
  if Assigned(OnPrepareDisplayValue) then
    OnPrepareDisplayValue(Self, AEditValue, ADisplayValue);
end;

class function TdxGanttPopupEditProperties.GetContainerClass: TcxContainerClass;
begin
  Result := TdxGanttPopupEdit;
end;

{ TdxGanttPopupEdit }

class function TdxGanttPopupEdit.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TdxGanttPopupEditProperties;
end;

{ TdxGanttControlViewChartSheetColumn }

function TdxGanttControlViewChartSheetColumn.CreateProperties: TcxCustomEditProperties;
begin
  Result := inherited CreateProperties;
  if Result <> nil then
    Result.Alignment.Vert := taTopJustify;
end;

function TdxGanttControlViewChartSheetColumn.GetDataModel: TdxGanttControlDataModel;
begin
  Result := TdxCustomGanttControl(TdxGanttControlCustomView(Owner.Owner.Owner).Owner).DataModel;
end;

function TdxGanttControlViewChartSheetColumn.CreateChangeValueCommand(AControl: TdxGanttControlBase;
  ADataItem: TObject; const ANewValue: Variant): TdxGanttControlCommand;
var
  ATask: TdxGanttControlTask;
begin
  ATask := TdxGanttControlTask(ADataItem);
  Result := GetChangeValueCommandClass.Create(AControl, ATask, ANewValue);
end;

function TdxGanttControlViewChartSheetColumn.GetEditValue(AData: TObject): Variant;
begin
  try
    if TdxGanttControlTask(AData).Blank then
      Result := Null
    else
      Result := DoGetEditValue(TdxGanttControlTask(AData));
  except
    Result := Null;
  end;
end;

{ TdxGanttControlChangeTaskDurationValueCommand }

constructor TdxGanttControlChangeTaskDurationValueCommand.Create(
  AControl: TdxGanttControlBase; ATask: TdxGanttControlTask; const ANewValue: Variant);
var
  ATaskDurationFormat: TdxDurationFormat;
  AValueStr, ADescription: string;
  AValue: Double;
begin
  inherited Create(AControl, ATask, ANewValue);
  ATaskDurationFormat := ATask.RealDurationFormat;
  if VarIsNull(ANewValue) or (Trim(VarToStr(ANewValue)) = '') then
  begin
    FDurationFormat := ATaskDurationFormat;
    FDuration := Null;
  end
  else
  begin
    TdxMeasurementUnitEditHelperAccess.ExtractActualValueAndDescriptionStrings(ANewValue, AValueStr, ADescription);
    FDurationFormat := GetDurationFormat(ADescription, ATaskDurationFormat);
    if ((ATaskDurationFormat = TdxDurationFormat.Null) and (FDurationFormat = TdxDurationFormat.Days)) or
       ((ATaskDurationFormat = TdxDurationFormat.EstimatedNull) and (FDurationFormat = TdxDurationFormat.EstimatedDays)) then
      FDurationFormat := ATaskDurationFormat;
    TryStrToFloat(AValueStr, AValue);
    FDuration := TdxGanttControlDuration.Create(AValue, FDurationFormat).ToString;
  end;
  FEstimated := FDurationFormat in [TdxDurationFormat.EstimatedMinutes .. TdxDurationFormat.EstimatedNull];
end;

procedure TdxGanttControlChangeTaskDurationValueCommand.BeforeExecute;
begin
  if not Task.Manual and VarIsNull(FDuration) then
    FDuration := (Task.Owner.DataModel as TdxGanttControlDataModel).DefaultTaskDuration;
  inherited BeforeExecute;;
end;

function TdxGanttControlChangeTaskDurationValueCommand.GetAssignedValue: TdxGanttTaskAssignedValue;
begin
  Result := TdxGanttTaskAssignedValue(-1); 
end;

function TdxGanttControlChangeTaskDurationValueCommand.GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass;
begin
  Result := nil;
end;

function TdxGanttControlChangeTaskDurationValueCommand.GetDurationFormat(const ADescription: string;
  ADefaultFormat: TdxDurationFormat): TdxDurationFormat;
begin
  Result := TdxGanttControlDurationFieldHelper.GetDurationFormat(ADescription, ADefaultFormat);
end;

function TdxGanttControlChangeTaskDurationValueCommand.HasAssignedValue: Boolean;
begin
  Result := False;
end;

procedure TdxGanttControlChangeTaskDurationValueCommand.SetValue;
begin
  with TdxGanttControlChangeTaskDurationFormatCommand.Create(Control, Task, FDurationFormat) do
  try
    Execute;
  finally
    Free;
  end;
  with TdxGanttControlChangeTaskDurationCommand.Create(Control, Task, FDuration) do
  try
    Execute;
  finally
    Free;
  end;
  with TdxGanttControlChangeTaskEstimatedCommand.Create(Control, Task, FEstimated) do
  try
    Execute;
  finally
    Free;
  end;
end;

{ TdxGanttControlViewChartSheetColumns }

function TdxGanttControlViewChartSheetColumns.GetExtendedAttributeColumnClass: TdxGanttControlExtendedAttributeSheetColumnClass;
begin
  Result := TdxGanttControlViewChartExtendedAttributeSheetColumn;
end;

function TdxGanttControlViewChartSheetColumns.GetFieldLevel: TdxGanttControlExtendedAttributeLevel;
begin
  Result := TdxGanttControlExtendedAttributeLevel.Task;
end;

procedure TdxGanttControlViewChartSheetColumns.RegisterColumnClasses;
begin
  inherited RegisterColumnClasses;
  RegisterColumnClass(TdxGanttControlViewChartSheetColumnIndicator);
  RegisterColumnClass(TdxGanttControlViewChartSheetColumnTaskMode);
  RegisterColumnClass(TdxGanttControlViewChartSheetColumnTaskName);
  RegisterColumnClass(TdxGanttControlViewChartSheetColumnTaskDuration);
  RegisterColumnClass(TdxGanttControlViewChartSheetColumnTaskStart);
  RegisterColumnClass(TdxGanttControlViewChartSheetColumnTaskFinish);
  RegisterColumnClass(TdxGanttControlViewChartSheetColumnPredecessors);
  RegisterColumnClass(TdxGanttControlViewChartSheetColumnResourceName);
  RegisterColumnClass(TdxGanttControlViewChartSheetColumnPercentComplete);
end;

function TdxGanttControlViewChartSheetColumns.StoredCreateChild(const AObjectName, AClassName: string): TObject;
var
  AUpperCaseClassName: string;
begin
  AUpperCaseClassName := UpperCase(AClassName);
  if AUpperCaseClassName = UpperCase(TdxGanttControlViewChartSheetColumnIndicator.ClassName) then
    Result := Add(TdxGanttControlViewChartSheetColumnIndicator)
  else
  if AUpperCaseClassName = UpperCase(TdxGanttControlViewChartSheetColumnTaskMode.ClassName) then
    Result := Add(TdxGanttControlViewChartSheetColumnTaskMode)
  else
  if AUpperCaseClassName = UpperCase(TdxGanttControlViewChartSheetColumnTaskName.ClassName) then
    Result := Add(TdxGanttControlViewChartSheetColumnTaskName)
  else
  if AUpperCaseClassName = UpperCase(TdxGanttControlViewChartSheetColumnTaskDuration.ClassName) then
    Result := Add(TdxGanttControlViewChartSheetColumnTaskDuration)
  else
  if AUpperCaseClassName = UpperCase(TdxGanttControlViewChartSheetColumnTaskStart.ClassName) then
    Result := Add(TdxGanttControlViewChartSheetColumnTaskStart)
  else
  if AUpperCaseClassName = UpperCase(TdxGanttControlViewChartSheetColumnTaskFinish.ClassName) then
    Result := Add(TdxGanttControlViewChartSheetColumnTaskFinish)
  else
  if AUpperCaseClassName = UpperCase(TdxGanttControlViewChartSheetColumnPredecessors.ClassName) then
    Result := Add(TdxGanttControlViewChartSheetColumnPredecessors)
  else
  if AUpperCaseClassName = UpperCase(TdxGanttControlViewChartSheetColumnResourceName.ClassName) then
    Result := Add(TdxGanttControlViewChartSheetColumnResourceName)
  else
  if AUpperCaseClassName = UpperCase(TdxGanttControlViewChartSheetColumnPercentComplete.ClassName) then
    Result := Add(TdxGanttControlViewChartSheetColumnPercentComplete)
  else
  if AUpperCaseClassName = UpperCase(TdxGanttControlViewChartSheetColumnPercentWorkComplete.ClassName) then
    Result := Add(TdxGanttControlViewChartSheetColumnPercentWorkComplete)
  else
  if AUpperCaseClassName = UpperCase(TdxGanttControlViewChartExtendedAttributeSheetColumn.ClassName) then
    Result := Add(TdxGanttControlViewChartExtendedAttributeSheetColumn)
  else
    Result := inherited StoredCreateChild(AObjectName, AClassName);
  if Result <> nil then
    DoInitStoredObject(Result);
end;

{ TdxGanttControlViewChartSheetColumnIndicator }

function TdxGanttControlViewChartSheetColumnIndicator.CanShowFilterButton: Boolean;
begin
  Result := False;
end;

function TdxGanttControlViewChartSheetColumnIndicator.CreateViewInfo(
  ASheetViewInfo: TdxGanttControlSheetCustomViewInfo): TdxGanttControlSheetColumnHeaderViewInfo;
begin
  Result := TdxGanttControlViewChartSheetColumnIndicatorHeaderViewInfo.Create(ASheetViewInfo, Self);
end;

function TdxGanttControlViewChartSheetColumnIndicator.GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass;
begin
  Result := TdxGanttControlViewChartSheetColumnIndicatorCellViewInfo;
end;

function TdxGanttControlViewChartSheetColumnIndicator.GetDefaultAllowRename: TdxDefaultBoolean;
begin
  Result := bFalse;
end;

function TdxGanttControlViewChartSheetColumnIndicator.GetDefaultAllowWordWrap: TdxDefaultBoolean;
begin
  Result := bFalse;
end;

function TdxGanttControlViewChartSheetColumnIndicator.GetDefaultCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewChartSheetColumnIndicatorCaption);
end;

function TdxGanttControlViewChartSheetColumnIndicator.GetDefaultShowFilterButton: Boolean;
begin
  Result := False;
end;

function TdxGanttControlViewChartSheetColumnIndicator.GetDefaultWidth: Integer;
begin
  Result := 39;
end;

class function TdxGanttControlViewChartSheetColumnIndicator.GetDesignCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewChartSheetColumnIndicatorCaption);
end;

function TdxGanttControlViewChartSheetColumnIndicator.GetHintText: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewChartSheetColumnIndicatorDescription);
end;

{ TdxGanttControlImageViewInfo }

constructor TdxGanttControlImageViewInfo.Create(
  AOwner: TdxGanttControlCustomItemViewInfo; AImage: TdxGPImage);
begin
  inherited Create(AOwner);
  FImage := AImage;
end;

procedure TdxGanttControlImageViewInfo.DoDraw;
var
  AImage: TcxCanvasBasedImage;
begin
  AImage := CanvasCache.GetImage(FImage);
  Canvas.DrawImage(FImage, Bounds, @AImage);
end;

function TdxGanttControlImageViewInfo.GetHintText: string;
begin
  Result := FHintText;
end;

function TdxGanttControlImageViewInfo.HasHint: Boolean;
begin
  Result := True;
end;

{ TdxGanttControlViewChartSheetColumnIndicatorCellViewInfo }

constructor TdxGanttControlViewChartSheetColumnIndicatorCellViewInfo.Create(
  AOwner: TdxGanttControlSheetDataRowViewInfo;
  AColumnViewInfo: TdxGanttControlSheetColumnHeaderViewInfo;
  AColumn: TdxGanttControlSheetColumn);
begin
  inherited Create(AOwner, AColumnViewInfo, AColumn);
  FImages := TObjectList<TdxGanttControlImageViewInfo>.Create;
end;

destructor TdxGanttControlViewChartSheetColumnIndicatorCellViewInfo.Destroy;
begin
  FreeAndNil(FImages);
  inherited Destroy;
end;

function TdxGanttControlViewChartSheetColumnIndicatorCellViewInfo.CalculateBestFit: Integer;
begin
  Result := 0;
  if FImages.Count > 0 then
  begin
    if UseRightToLeftAlignment then
      Result := FImages.First.Bounds.Right - FImages.Last.Bounds.Left
    else
      Result := FImages.Last.Bounds.Right - FImages.First.Bounds.Left;
  end;
  Result := Result + GridLineThickness + FocusRectThickness
    + 2 * LookAndFeelPainter.GetEditorGlyphIndent(True, True, ScaleFactor);
end;

function TdxGanttControlViewChartSheetColumnIndicatorCellViewInfo.CalculateHitTest(
  const AHitTest: TdxGanttControlHitTest): Boolean;
var
  I: Integer;
begin
  Result := inherited CalculateHitTest(AHitTest);
  if Result then
    for I := 0 to FImages.Count - 1 do
      if FImages[I].CalculateHitTest(AHitTest) then
        Exit;
end;

procedure TdxGanttControlViewChartSheetColumnIndicatorCellViewInfo.Calculate(
  const R: TRect);

  procedure CalculateImage(var ABounds: TRect);
  var
    AImageRect: TRect;
    AImage: TdxGPImage;
  begin
    ABounds.Offset(LookAndFeelPainter.GetEditorGlyphIndent(True, True, ScaleFactor), 0);
    AImage := FImages.Last.Image;
    AImageRect := TRect.Null;
    AImageRect.Height := TdxGanttControlSheetCustomViewInfoAccess(Owner.Owner).ImageHeight;
    AImageRect.Width := Ceil(AImage.Width * AImageRect.Height / AImage.Height);
    AImageRect.Offset(ABounds.TopLeft);
    if UseRightToLeftAlignment then
    begin
      AImageRect.MoveToRight(ABounds.Right);
      ABounds.Right := AImageRect.Left
    end
    else
      ABounds.Left := AImageRect.Right;
    FImages.Last.Calculate(AImageRect);
  end;

  function GetConstraintText(AType: TdxGanttControlTaskConstraintType): string;
  begin
    case AType of
      TdxGanttControlTaskConstraintType.AsSoonAsPossible: Result := cxGetResourceString(@sdxGanttControlTaskConstraintTypeASAP);
      TdxGanttControlTaskConstraintType.AsLateAsPossible: Result := cxGetResourceString(@sdxGanttControlTaskConstraintTypeALAP);
      TdxGanttControlTaskConstraintType.MustStartOn: Result := cxGetResourceString(@sdxGanttControlTaskConstraintTypeMSO);
      TdxGanttControlTaskConstraintType.MustFinishOn: Result := cxGetResourceString(@sdxGanttControlTaskConstraintTypeMFO);
      TdxGanttControlTaskConstraintType.StartNoEarlierThan: Result := cxGetResourceString(@sdxGanttControlTaskConstraintTypeSNET);
      TdxGanttControlTaskConstraintType.StartNoLaterThan: Result := cxGetResourceString(@sdxGanttControlTaskConstraintTypeSNLT);
      TdxGanttControlTaskConstraintType.FinishNoEarlierThan: Result := cxGetResourceString(@sdxGanttControlTaskConstraintTypeFNET);
    else
      Result := cxGetResourceString(@sdxGanttControlTaskConstraintTypeFNLT);
    end;
  end;

var
  ATask: TdxGanttControlTask;
  ABounds: TRect;
begin
  inherited Calculate(R);
  FImages.Clear;
  ATask := TdxGanttControlTask(Owner.Data);
  if (ATask = nil) or ATask.Blank then
    Exit;
  ABounds := Bounds;
  ABounds.Offset(0, TextPadding.Top);
  if ATask.IsValueAssigned(TdxGanttTaskAssignedValue.Recurring) and ATask.IsValueAssigned(TdxGanttTaskAssignedValue.Summary) and
    ATask.Recurring and ATask.Summary and ATask.IsRecurrencePattern then
  begin
    FImages.Add(TdxGanttControlImageViewInfo.Create(Self, TdxGanttControlImages.TaskRecurring));
    FImages.Last.FHintText := TdxGanttControlOccurrencesCalculator.GeDescription(ATask);
    CalculateImage(ABounds);
  end;
  if ATask.IsValueAssigned(TdxGanttTaskAssignedValue.PercentComplete) and (ATask.PercentComplete = 100) then
  begin
    FImages.Add(TdxGanttControlImageViewInfo.Create(Self, TdxGanttControlImages.TaskCompleted));
    FImages.Last.FHintText := Format(cxGetResourceString(@sdxGanttControlTaskCompletedHint), [DateTimeToStr(ATask.Finish)]);
    CalculateImage(ABounds);
  end;
  if ATask.IsValueAssigned(TdxGanttTaskAssignedValue.ConstraintType) and ATask.IsValueAssigned(TdxGanttTaskAssignedValue.ConstraintDate) then
  begin
    if ATask.ConstraintType in [TdxGanttControlTaskConstraintType.StartNoEarlierThan, TdxGanttControlTaskConstraintType.FinishNoEarlierThan] then
    begin
      FImages.Add(TdxGanttControlImageViewInfo.Create(Self, TdxGanttControlImages.TaskConstraintByStart));
      FImages.Last.FHintText := Format(cxGetResourceString(@sdxGanttControlTaskHasConstraintHint), [GetConstraintText(ATask.ConstraintType), DateTimeToStr(ATask.ConstraintDate)]);
      CalculateImage(ABounds);
    end;
    if ATask.ConstraintType in [TdxGanttControlTaskConstraintType.MustStartOn, TdxGanttControlTaskConstraintType.MustFinishOn,
      TdxGanttControlTaskConstraintType.StartNoLaterThan, TdxGanttControlTaskConstraintType.FinishNoLaterThan] then
    begin
      FImages.Add(TdxGanttControlImageViewInfo.Create(Self, TdxGanttControlImages.TaskConstraintByFinish));
      FImages.Last.FHintText := Format(cxGetResourceString(@sdxGanttControlTaskHasConstraintHint), [GetConstraintText(ATask.ConstraintType), DateTimeToStr(ATask.ConstraintDate)]);
      CalculateImage(ABounds);
    end;
  end;
end;

procedure TdxGanttControlViewChartSheetColumnIndicatorCellViewInfo.DoDraw;
var
  I: Integer;
begin
  inherited DoDraw;
  for I := 0 to FImages.Count - 1 do
    FImages[I].Draw;
end;

procedure TdxGanttControlViewChartSheetColumnIndicatorCellViewInfo.DoScroll(
  const DX, DY: Integer);
var
  I: Integer;
begin
  inherited DoScroll(DX, DY);
  for I := 0 to FImages.Count - 1 do
    FImages[I].DoScroll(DX, DY);
end;

{ TdxGanttControlViewChartSheetColumnIndicatorHeaderViewInfo }

function TdxGanttControlViewChartSheetColumnIndicatorHeaderViewInfo.CalculateImage: TdxGPImage;
begin
  Result := TdxGanttControlImages.Info;
end;

{ TdxGanttControlViewChartSheetColumnTaskMode }

function TdxGanttControlViewChartSheetColumnTaskMode.CreateProperties: TcxCustomEditProperties;
begin
  Result := inherited CreateProperties;
  TcxComboBoxProperties(Result).Items.Add(cxGetResourceString(@sdxGanttControlTaskModeManuallyScheduled));
  TcxComboBoxProperties(Result).Items.Add(cxGetResourceString(@sdxGanttControlTaskModeAutoScheduled));
  TcxComboBoxProperties(Result).DropDownListStyle := lsEditFixedList;
  TcxComboBoxProperties(Result).ImmediatePost := True;
  TcxComboBoxProperties(Result).ImmediateDropDown := False;
  TcxComboBoxProperties(Result).ImmediateDropDownWhenKeyPressed := False;
  TcxComboBoxProperties(Result).ImmediateDropDownWhenActivated := False;
end;

function TdxGanttControlViewChartSheetColumnTaskMode.GetChangeValueCommandClass: TdxGanttControlChangeTaskPropertyCommandClass;
begin
  Result := TdxGanttControlChangeTaskManualCommand
end;

function TdxGanttControlViewChartSheetColumnTaskMode.GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass;
begin
  Result := TdxGanttControlViewChartSheetColumnTaskModeViewInfo;
end;

function TdxGanttControlViewChartSheetColumnTaskMode.GetDefaultAllowWordWrap: TdxDefaultBoolean;
begin
  Result := bFalse;
end;

function TdxGanttControlViewChartSheetColumnTaskMode.GetDefaultCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewChartSheetColumnTaskModeCaption);
end;

function TdxGanttControlViewChartSheetColumnTaskMode.GetDefaultWidth: Integer;
begin
  Result := 57;
end;

class function TdxGanttControlViewChartSheetColumnTaskMode.GetDesignCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewChartSheetColumnTaskModeCaption);
end;

function TdxGanttControlViewChartSheetColumnTaskMode.GetHintText: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewChartSheetColumnTaskModeDescription);
end;

function TdxGanttControlViewChartSheetColumnTaskMode.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TcxComboBoxProperties;
end;

function TdxGanttControlViewChartSheetColumnTaskMode.DoGetEditValue(
  ATask: TdxGanttControlTask): Variant;
begin
  if (ATask = nil) or not ATask.IsValueAssigned(TdxGanttTaskAssignedValue.Manual) then
    Result := Null
  else
    if ATask.Manual then
      Result := cxGetResourceString(@sdxGanttControlTaskModeManuallyScheduled)
    else
      Result := cxGetResourceString(@sdxGanttControlTaskModeAutoScheduled);
end;

{ TdxGanttControlViewChartSheetColumnTaskModeViewInfo }

procedure TdxGanttControlViewChartSheetColumnTaskModeViewInfo.Calculate(
  const R: TRect);
var
  ATask: TdxGanttControlTask;
begin
  inherited Calculate(R);
  if Owner.Data <> nil then
  begin
    ATask := TdxGanttControlTask(Owner.Data);
    if ATask.Blank then
      FImage := nil
    else
    begin
      if not ATask.Manual then
        FImage := TdxGanttControlImages.TaskAutoSchedule
      else
        if ATask.IsValueAssigned(TdxGanttTaskAssignedValue.Start) and ATask.IsValueAssigned(TdxGanttTaskAssignedValue.Finish) then
          FImage := TdxGanttControlImages.TaskManualSchedule
        else
          FImage := TdxGanttControlImages.TaskManualScheduleMoreInformationNeeded;
      FImageRect := TRect.Null;
      FImageRect.Height := TdxGanttControlSheetCustomViewInfoAccess(Owner.Owner).ImageHeight;
      FImageRect.Width := Ceil(FImage.Width * FImageRect.Height / FImage.Height);
      FImageRect.Offset(Bounds.TopLeft);
      FImageRect.Offset(LookAndFeelPainter.GetEditorGlyphIndent(True, True, ScaleFactor), TextPadding.Top);
      if UseRightToLeftAlignment then
        FImageRect.MoveToRight(Bounds.Right);
    end;
  end
  else
    FImage := nil;
end;

procedure TdxGanttControlViewChartSheetColumnTaskModeViewInfo.DoDraw;
var
  AImage: TcxCanvasBasedImage;
begin
  inherited DoDraw;
  if FImage <> nil then
  begin
    AImage := CanvasCache.GetImage(FImage);
    Canvas.DrawImage(FImage, FImageRect, @AImage);
  end;
end;

procedure TdxGanttControlViewChartSheetColumnTaskModeViewInfo.DoScroll(const DX,
  DY: Integer);
begin
  inherited DoScroll(DX, DY);
  FImageRect.Offset(DX, DY);
end;

{ TdxGanttControlViewChartSheetColumnViewInfo }

function TdxGanttControlViewChartSheetColumnViewInfo.GetFont: TFont;
begin
  if (Owner.Data <> nil) and TdxGanttControlTask(Owner.Data).Summary then
    Result := CanvasCache.GetBaseBoldFont
  else
    Result := inherited GetFont;
end;

function TdxGanttControlViewChartSheetColumnViewInfo.HasDisplayText: Boolean;
begin
  Result := inherited HasDisplayText and
    not TdxGanttControlTask(Owner.Data).Blank;
end;

function TdxGanttControlViewChartSheetColumnViewInfo.IsSummary: Boolean;
var
  ATask: TdxGanttControlTask;
begin
  Result := Safe.Cast(Owner.Data, TdxGanttControlTask, ATask) and not ATask.Blank and ATask.Summary;
end;

{ TdxGanttControlViewChartSheetColumnTaskName }

function TdxGanttControlViewChartSheetColumnTaskName.GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass;
begin
  Result := TdxGanttControlViewChartSheetColumnTaskNameViewInfo;
end;

function TdxGanttControlViewChartSheetColumnTaskName.GetDefaultCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewChartSheetColumnTaskNameCaption);
end;

function TdxGanttControlViewChartSheetColumnTaskName.GetDefaultWidth: Integer;
begin
  Result := 285;
end;

function TdxGanttControlViewChartSheetColumnTaskName.GetDefaultWordWrap: Boolean;
begin
  Result := True;
end;

function TdxGanttControlViewChartSheetColumnTaskName.GetChangeValueCommandClass: TdxGanttControlChangeTaskPropertyCommandClass;
begin
  Result := TdxGanttControlChangeTaskNameCommand;
end;

class function TdxGanttControlViewChartSheetColumnTaskName.GetDesignCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewChartSheetColumnTaskNameCaption);
end;

function TdxGanttControlViewChartSheetColumnTaskName.GetHintText: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewChartSheetColumnTaskNameDescription);
end;

function TdxGanttControlViewChartSheetColumnTaskName.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TdxGanttControlPropertiesClassCollection.GetTextFieldPropertiesClass;
end;

function TdxGanttControlViewChartSheetColumnTaskName.DoGetEditValue(ATask: TdxGanttControlTask): Variant;
begin
  if ATask.IsValueAssigned(TdxGanttTaskAssignedValue.Name) then
    Result := ATask.Name
  else
    Result := Null;
end;

{ TdxGanttControlViewChartSheetColumnTaskNameViewInfo }

function TdxGanttControlViewChartSheetColumnTaskNameViewInfo.CalculateBestFit: Integer;
begin
  Result := inherited CalculateBestFit;
  Result := Result + CalculateTextOffset;
end;

function TdxGanttControlViewChartSheetColumnTaskNameViewInfo.CalculateExpandButtonBounds: TRect;
begin
  Result := Bounds;
  Result.Offset(GridLineThickness + FocusRectThickness + TextPadding.Left - cxTextOffsetHalf, - GridLineThickness div 2);
  Result.Width := GetLevelOffset;
  if UseRightToLeftAlignment then
    Result.MoveToRight(Bounds.Right);
  Result := cxRectOffset(Result, ((Owner.Data as TdxGanttControlTask).OutlineLevel - 1) * GetLevelOffset, 0, not UseRightToLeftAlignment);
end;

function TdxGanttControlViewChartSheetColumnTaskNameViewInfo.CalculateItemBounds(
  AItem: TdxGanttControlCustomItemViewInfo): TRect;
begin
  if AItem is TdxGanttControlViewChartSheetExpandButtonViewInfo then
    Result := CalculateExpandButtonBounds
  else
    Result := inherited CalculateItemBounds(AItem);
end;

procedure TdxGanttControlViewChartSheetColumnTaskNameViewInfo.CalculateLayout;
begin
  inherited CalculateLayout;
  if TdxGanttControlSheetCustomViewInfoAccess(Owner.Owner).AreExpandButtonsVisible and IsSummary then
    AddChild(TdxGanttControlViewChartSheetExpandButtonViewInfo.Create(Self));
end;

function TdxGanttControlViewChartSheetColumnTaskNameViewInfo.CalculateTextBounds: TRect;
begin
  Result := inherited CalculateTextBounds;
  if UseRightToLeftAlignment then
    Result.Right := Result.Right - CalculateTextOffset
  else
    Result.Left := Result.Left + CalculateTextOffset;
end;

function TdxGanttControlViewChartSheetColumnTaskNameViewInfo.CalculateTextOffset: Integer;
var
  AOutlineLevel: Integer;
begin
  if Owner.Data <> nil then
    AOutlineLevel := TdxGanttControlTask(Owner.Data).OutlineLevel
  else
    AOutlineLevel := 1;

  if not TdxGanttControlSheetCustomViewInfoAccess(Owner.Owner).AreExpandButtonsVisible then
    Dec(AOutlineLevel);
  AOutlineLevel := Max(AOutlineLevel, 0);
  Result := CalculateOutlineLevelOffset(ScaleFactor, AOutlineLevel, TdxGanttControlSheetCustomViewInfoAccess(Owner.Owner).IsTouchModeEnabled);
  Result := Result + TextPadding.Left;
end;

function TdxGanttControlViewChartSheetColumnTaskNameViewInfo.GetCurrentCursor(
  const P: TPoint; const ADefaultCursor: TCursor): TCursor;
begin
  if IsOutlineLevelChangeZone(P) then
    Result := TdxGanttControlCursors.HResize
  else
    Result := inherited GetCurrentCursor(P, ADefaultCursor);
end;

function TdxGanttControlViewChartSheetColumnTaskNameViewInfo.GetLevelOffset: Integer;
begin
  Result := CalculateOutlineLevelOffset(ScaleFactor, 1, TdxGanttControlSheetCustomViewInfoAccess(Owner.Owner).IsTouchModeEnabled);
end;

function TdxGanttControlViewChartSheetColumnTaskNameViewInfo.MeasureHeight(
  AWidth: Integer): Integer;
begin
  Result := inherited MeasureHeight(AWidth - CalculateTextOffset);
end;

class function TdxGanttControlViewChartSheetColumnTaskNameViewInfo.CalculateOutlineLevelOffset(AScaleFactor: TdxScaleFactor; AOutlineLevel: Integer;
  AIsTouchModeEnabled: Boolean): Integer;
begin
  Result := AScaleFactor.Apply(16);
  if AIsTouchModeEnabled then
    Result := dxGetTouchableSize(Result, AScaleFactor);
  Result := AOutlineLevel * Result;
end;

function TdxGanttControlViewChartSheetColumnTaskNameViewInfo.IsOutlineLevelChangeZone(const P: TPoint): Boolean;
var
  R: TRect;
begin
  if not HasDisplayText or not Column.Owner.Owner.Control.IsEditable then
    Exit(False);
  R := TextBounds;
  R.Width := 0;
  if UseRightToLeftAlignment then
    R.MoveToRight(TextBounds.Right);
  R.Inflate(GetResizeHitZoneWidth div 2, 0);
  Result := R.Contains(P);
end;

{ TdxGanttControlViewChartSheetExpandButtonViewInfo }

procedure TdxGanttControlViewChartSheetExpandButtonViewInfo.Calculate(
  const R: TRect);
begin
  inherited Calculate(R);
  FButtonBounds := cxRectCenter(Bounds, LookAndFeelPainter.ScaledExpandButtonSize(ScaleFactor), LookAndFeelPainter.ScaledExpandButtonSize(ScaleFactor));
end;

procedure TdxGanttControlViewChartSheetExpandButtonViewInfo.DoDraw;
begin
  LookAndFeelPainter.DrawScaledExpandButton(Canvas, FButtonBounds, IsExpanded, ScaleFactor);
end;

procedure TdxGanttControlViewChartSheetExpandButtonViewInfo.DoScroll(const DX,
  DY: Integer);
begin
  inherited DoScroll(DX, DY);
  FButtonBounds.Offset(DX, DY);
end;

function TdxGanttControlViewChartSheetExpandButtonViewInfo.GetOwner: TdxGanttControlViewChartSheetColumnTaskNameViewInfo;
begin
  Result := TdxGanttControlViewChartSheetColumnTaskNameViewInfo(inherited Owner);
end;

function TdxGanttControlViewChartSheetExpandButtonViewInfo.IsExpanded: Boolean;
begin
  Result := TdxGanttControlSheetCustomViewInfoAccess(Owner.Owner.Owner).DataProvider.IsExpanded(Owner.Owner.Data);
end;

{ TdxGanttControlViewChartSheetCustomColumnPercentComplete }

procedure TdxGanttControlViewChartSheetCustomColumnPercentComplete.Assign(
  Source: TPersistent);
begin
  if Source is TdxGanttControlViewChartSheetCustomColumnPercentComplete then
    ShowProgressBar := TdxGanttControlViewChartSheetCustomColumnPercentComplete(Source).ShowProgressBar;
  inherited Assign(Source);
end;

function TdxGanttControlViewChartSheetCustomColumnPercentComplete.CreateProperties: TcxCustomEditProperties;
begin
  Result := inherited CreateProperties;
  TcxSpinEditProperties(Result).MinValue := 0;
  TcxSpinEditProperties(Result).MaxValue := 100;
end;

function TdxGanttControlViewChartSheetCustomColumnPercentComplete.GetAlignment: TAlignment;
begin
  Result := taRightJustify;
end;

function TdxGanttControlViewChartSheetCustomColumnPercentComplete.GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass;
begin
  Result := TdxGanttControlViewChartSheetColumnTaskPercentCompleteViewInfo;
end;

function TdxGanttControlViewChartSheetCustomColumnPercentComplete.GetDefaultVisible: Boolean;
begin
  Result := False;
end;

function TdxGanttControlViewChartSheetCustomColumnPercentComplete.GetDefaultWidth: Integer;
begin
  Result := 123;
end;

function TdxGanttControlViewChartSheetCustomColumnPercentComplete.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TcxSpinEditProperties;
end;

procedure TdxGanttControlViewChartSheetCustomColumnPercentComplete.DoReset;
begin
  inherited DoReset;
  FShowProgressBar := False;
end;

procedure TdxGanttControlViewChartSheetCustomColumnPercentComplete.SetShowProgressBar(
  const Value: Boolean);
begin
  if FShowProgressBar <> Value then
  begin
    FShowProgressBar := Value;
    Changed;
  end;
end;

{ TdxGanttControlViewChartSheetColumnPercentComplete }

function TdxGanttControlViewChartSheetColumnPercentComplete.DoGetEditValue(
  ATask: TdxGanttControlTask): Variant;
begin
  Result := ATask.GetRealPercentComplete;
end;

function TdxGanttControlViewChartSheetColumnPercentComplete.GetChangeValueCommandClass: TdxGanttControlChangeTaskPropertyCommandClass;
begin
  Result := TdxGanttControlChangeTaskPercentCompleteCommand;
end;

function TdxGanttControlViewChartSheetColumnPercentComplete.GetDefaultCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewChartSheetColumnPercentCompleteCaption);
end;

class function TdxGanttControlViewChartSheetColumnPercentComplete.GetDesignCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewChartSheetColumnPercentCompleteCaption);
end;

function TdxGanttControlViewChartSheetColumnPercentComplete.GetHintText: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewChartSheetColumnPercentCompleteDescription);
end;

{ TdxGanttControlViewChartSheetColumnPercentWorkComplete }

function TdxGanttControlViewChartSheetColumnPercentWorkComplete.GetDefaultCaption: string;
begin
  Result := '% Work Complete'; 
end;

function TdxGanttControlViewChartSheetColumnPercentWorkComplete.GetChangeValueCommandClass: TdxGanttControlChangeTaskPropertyCommandClass;
begin
  Result := TdxGanttControlChangeTaskPercentWorkCompleteCommand;
end;

class function TdxGanttControlViewChartSheetColumnPercentWorkComplete.GetDesignCaption: string;
begin
  Result := '% Work Complete'; 
end;

function TdxGanttControlViewChartSheetColumnPercentWorkComplete.GetHintText: string;
begin
  Result := ''; 
end;

function TdxGanttControlViewChartSheetColumnPercentWorkComplete.DoGetEditValue(ATask: TdxGanttControlTask): Variant;
begin
  Result := ATask.GetRealPercentWorkComplete;
end;

{ TdxGanttControlViewChartSheetColumnTaskPercentCompleteViewInfo }

procedure TdxGanttControlViewChartSheetColumnTaskPercentCompleteViewInfo.Calculate(
  const R: TRect);
begin
  inherited Calculate(R);
  FProgressBarBounds := CalculateProgressBarBounds;
end;

function TdxGanttControlViewChartSheetColumnTaskPercentCompleteViewInfo.CalculateProgressBarBounds: TRect;
begin
  if (Owner.Data = nil) or not Column.ShowProgressBar then
    Exit(TRect.Null);
  Result := Bounds;
  Result.Width := MulDiv(Bounds.Width, TdxGanttControlTask(Owner.Data).PercentComplete, 100); 
  if UseRightToLeftAlignment then
    Result.MoveToRight(Bounds.Right);
end;

function TdxGanttControlViewChartSheetColumnTaskPercentCompleteViewInfo.DoCalculateDisplayText: string;
begin
  Result := Format('%s%%', [inherited DoCalculateDisplayText]);
end;

procedure TdxGanttControlViewChartSheetColumnTaskPercentCompleteViewInfo.DoDraw;
begin
  inherited DoDraw;
end;

function TdxGanttControlViewChartSheetColumnTaskPercentCompleteViewInfo.GetColumn: TdxGanttControlViewChartSheetCustomColumnPercentComplete;
begin
  Result := TdxGanttControlViewChartSheetCustomColumnPercentComplete(inherited Column);
end;

function TdxGanttControlViewChartSheetColumnTaskPercentCompleteViewInfo.GetDrawTextFlags: Integer;
begin
  Result := inherited GetDrawTextFlags;
  if Column.ShowProgressBar then
    Result := Result and not CXTO_RIGHT or CXTO_CENTER_HORIZONTALLY;
end;

{ TdxGanttControlViewChartSheetColumnTaskDuration }

function TdxGanttControlViewChartSheetColumnTaskDuration.GetChangeValueCommandClass: TdxGanttControlChangeTaskPropertyCommandClass;
begin
  Result := TdxGanttControlChangeTaskDurationValueCommand;
end;

function TdxGanttControlViewChartSheetColumnTaskDuration.GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass;
begin
  Result := TdxGanttControlViewChartSheetColumnTaskDurationViewInfo;
end;

function TdxGanttControlViewChartSheetColumnTaskDuration.GetDefaultCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewChartSheetColumnTaskDurationCaption);
end;

function TdxGanttControlViewChartSheetColumnTaskDuration.GetDefaultWidth: Integer;
begin
  Result := 81;
end;

class function TdxGanttControlViewChartSheetColumnTaskDuration.GetDesignCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewChartSheetColumnTaskDurationCaption);
end;

function TdxGanttControlViewChartSheetColumnTaskDuration.GetHintText: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewChartSheetColumnTaskDurationDescription);
end;

function TdxGanttControlViewChartSheetColumnTaskDuration.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TdxGanttControlPropertiesClassCollection.GetDurationFieldPropertiesClass;
end;

function TdxGanttControlViewChartSheetColumnTaskDuration.GetDurationFormat(
  ADataItem: TObject): TdxDurationFormat;
var
  ATask: TdxGanttControlTask;
begin
  if Safe.Cast(ADataItem, TdxGanttControlTask, ATask) then
    Result := ATask.RealDurationFormat
  else
    Result := TdxGanttControlDataModelPropertiesAccess(DataModel.Properties).GetActualDurationFormat
end;

function TdxGanttControlViewChartSheetColumnTaskDuration.GetValue(
  ADataItem: TObject): Double;
var
  ATask: TdxGanttControlTask;
begin
  if Safe.Cast(ADataItem, TdxGanttControlTask, ATask) then
  begin
    if ATask.Duration <> '' then
      Result := TdxGanttControlDuration.GetDurationValue(ATask.Duration, ATask.RealDurationFormat)
    else
      Result := TdxGanttControlDuration.GetDurationValue(DataModel.DefaultTaskDuration, ATask.RealDurationFormat);
  end
  else
    Result := TdxGanttControlDuration.GetDurationValue(DataModel.DefaultTaskDuration, GetDurationFormat(ADataItem));
end;

procedure TdxGanttControlViewChartSheetColumnTaskDuration.PrepareEditProperties(
  AProperties: TcxCustomEditProperties; AData: TObject);
begin
  inherited PrepareEditProperties(AProperties, AData);
  TdxGanttControlPropertiesClassCollection.PrepareEditProperties(Self, AProperties, AData);
end;

function TdxGanttControlViewChartSheetColumnTaskDuration.DoGetEditValue(ATask: TdxGanttControlTask): Variant;
begin
  Result := ATask.DurationAsDisplayValue;
end;

{ TdxGanttControlViewChartSheetColumnDateTime }

function TdxGanttControlViewChartSheetColumnDateTime.GetActiveCalendar(
  ADataItem: TObject): TdxGanttControlCalendar;
begin
  if ADataItem <> nil then
    Result := TdxGanttControlTask(ADataItem).RealCalendar
  else
    Result := DataModel.ActiveCalendar;
end;

procedure TdxGanttControlViewChartSheetColumnDateTime.PrepareEditProperties(
  AProperties: TcxCustomEditProperties; AData: TObject);
begin
  inherited PrepareEditProperties(AProperties, AData);
  TdxGanttControlPropertiesClassCollection.PrepareEditProperties(Self, AProperties, AData);
end;

{ TdxGanttControlViewChartSheetColumnTaskStart }

function TdxGanttControlViewChartSheetColumnTaskStart.GetChangeValueCommandClass: TdxGanttControlChangeTaskPropertyCommandClass;
begin
  Result := TdxGanttControlChangeTaskStartCommand;
end;

function TdxGanttControlViewChartSheetColumnTaskStart.GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass;
begin
  Result := TdxGanttControlViewChartSheetColumnTaskStartViewInfo;
end;

function TdxGanttControlViewChartSheetColumnTaskStart.DoGetEditValue(ATask: TdxGanttControlTask): Variant;
begin
  if ATask.IsValueAssigned(TdxGanttTaskAssignedValue.Start) then
    Result := ATask.Start
  else
    Result := Null;
end;

function TdxGanttControlViewChartSheetColumnTaskStart.GetDefaultCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewChartSheetColumnTaskStartCaption);
end;

function TdxGanttControlViewChartSheetColumnTaskStart.GetDefaultWidth: Integer;
begin
  Result := 81;
end;

class function TdxGanttControlViewChartSheetColumnTaskStart.GetDesignCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewChartSheetColumnTaskStartCaption);
end;

function TdxGanttControlViewChartSheetColumnTaskStart.GetHintText: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewChartSheetColumnTaskStartDescription);
end;

function TdxGanttControlViewChartSheetColumnTaskStart.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TdxGanttControlPropertiesClassCollection.GetStartFieldPropertiesClass;
end;

{ TdxGanttControlViewChartSheetColumnTaskFinish }

function TdxGanttControlViewChartSheetColumnTaskFinish.GetChangeValueCommandClass: TdxGanttControlChangeTaskPropertyCommandClass;
begin
  Result := TdxGanttControlChangeTaskFinishCommand;
end;

function TdxGanttControlViewChartSheetColumnTaskFinish.GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass;
begin
  Result :=TdxGanttControlViewChartSheetColumnTaskFinishViewInfo;
end;

function TdxGanttControlViewChartSheetColumnTaskFinish.DoGetEditValue(ATask: TdxGanttControlTask): Variant;
begin
  if ATask.IsValueAssigned(TdxGanttTaskAssignedValue.Finish) then
    Result := ATask.Finish
  else
    Result := Null;
end;

function TdxGanttControlViewChartSheetColumnTaskFinish.GetDefaultCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewChartSheetColumnTaskFinishCaption);
end;

function TdxGanttControlViewChartSheetColumnTaskFinish.GetDefaultWidth: Integer;
begin
  Result := 81;
end;

class function TdxGanttControlViewChartSheetColumnTaskFinish.GetDesignCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewChartSheetColumnTaskFinishCaption);
end;

function TdxGanttControlViewChartSheetColumnTaskFinish.GetHintText: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewChartSheetColumnTaskFinishDescription);
end;

function TdxGanttControlViewChartSheetColumnTaskFinish.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TdxGanttControlPropertiesClassCollection.GetFinishFieldPropertiesClass;
end;

{ TdxGanttControlViewChartSheetColumnPopupTreeView }

constructor TdxGanttControlViewChartSheetColumnPopupTreeView.Create(
  AOwner: TdxGanttControlSheetColumns);
begin
  inherited Create(AOwner);
  FTreeView := TdxInternalTreeView.Create(nil);
  FTreeView.BorderStyle := cxcbsNone;
  FTreeView.Width := 200;
  FTreeView.OptionsView.ShowCheckBoxes := True;
  FTreeView.OptionsView.ShowLines := False;
  FTreeView.OnKeyDown := TreeView1KeyDownHandler;
  FTreeView.ShowHint := True;
  SubscribeDataModelChanges;
  UpdateTreeView;
end;

destructor TdxGanttControlViewChartSheetColumnPopupTreeView.Destroy;
begin
  UnsubscribeDataModelChanges;
  FreeAndNil(FTreeView);
  inherited Destroy;
end;

function TdxGanttControlViewChartSheetColumnPopupTreeView.CreateProperties: TcxCustomEditProperties;
begin
  Result := inherited CreateProperties;
  TdxGanttPopupEditProperties(Result).AutoSelect := True;
  TcxPopupEditProperties(Result).PopupAutoSize := False;
  TcxPopupEditProperties(Result).ImmediateDropDownWhenKeyPressed := False;
  TcxPopupEditProperties(Result).ImmediateDropDownWhenActivated := False;
  TcxPopupEditProperties(Result).ImmediateDropDown := False;
  TcxPopupEditProperties(Result).ImmediatePost := True;
  TcxPopupEditProperties(Result).OnCloseUp := PopupEditPropertiesCloseUpHandler;
end;

function TdxGanttControlViewChartSheetColumnPopupTreeView.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TdxGanttPopupEditProperties;
end;

procedure TdxGanttControlViewChartSheetColumnPopupTreeView.PopupEditPrepareDisplayValueHandler(
  Sender: TObject; const AEditValue: Variant; var ADisplayValue: Variant);
begin
  if VarIsNull(AEditValue) then
    ADisplayValue := ''
  else
    if VarIsStr(AEditValue) then
      ADisplayValue := AEditValue
    else
      DoPopupEditPrepareDisplayValueHandler(Sender, AEditValue, ADisplayValue);
end;

procedure TdxGanttControlViewChartSheetColumnPopupTreeView.PopupEditPropertiesCloseUpHandler(
  Sender: TObject);
var
  AValue: Variant;
  AEdit: TcxPopupEditAccess absolute Sender;
begin
  TcxPopupEditProperties(Properties).PopupWidth := AEdit.PopupWindow.Width;
  TcxPopupEditProperties(Properties).PopupHeight := AEdit.PopupWindow.Height;
  AValue := GetTreeViewValue;
  if VarCompare(AEdit.EditValue, AValue) <> 0 then
  begin
    AEdit.EditValue := AValue;
    AEdit.EditModified := True;
  end;
end;

procedure TdxGanttControlViewChartSheetColumnPopupTreeView.PrepareEditProperties(
  AProperties: TcxCustomEditProperties; AData: TObject);
begin
  TcxPopupEditProperties(AProperties).PopupControl := FTreeView;
  TdxGanttPopupEditProperties(AProperties).FData := AData;
  TdxGanttPopupEditProperties(AProperties).OnPrepareDisplayValue := PopupEditPrepareDisplayValueHandler;
  FTreeView.Root.BeginUpdate;
  try
    TdxTreeViewCustomOptionsBehaviorAccess(FTreeView.OptionsBehavior).ReadOnly := AProperties.ReadOnly;
    PrepareTreeViewCheckedStates(AData);
  finally
    FTreeView.Root.EndUpdate;
  end;
end;

procedure TdxGanttControlViewChartSheetColumnPopupTreeView.DoPopupEditPrepareDisplayValueHandler(Sender: TObject; const AEditValue: Variant; var ADisplayValue: Variant);
begin
// do nothing
end;

procedure TdxGanttControlViewChartSheetColumnPopupTreeView.PrepareTreeViewCheckedStates(AData: TObject);
begin
// do nothing
end;

procedure TdxGanttControlViewChartSheetColumnPopupTreeView.SubscribeDataModelChanges;
begin
// do nothing
end;

procedure TdxGanttControlViewChartSheetColumnPopupTreeView.UnsubscribeDataModelChanges;
begin
// do nothing
end;

procedure TdxGanttControlViewChartSheetColumnPopupTreeView.UpdateTreeView;
begin
// do nothing
end;

procedure TdxGanttControlViewChartSheetColumnPopupTreeView.TreeView1KeyDownHandler(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (FTreeView.FocusedNode = nil) or (Key in [VK_ESCAPE, VK_RETURN, VK_TAB]) then
    TdxGanttControlSheetEditingControllerAccess(TdxGanttControlSheetControllerAccess(Owner.Owner.Controller).EditingController).EditKeyDown(Sender, Key, Shift)
  else
    if ((Key in [VK_UP, VK_PRIOR]) and (FTreeView.FocusedNode = FTreeView.Root.First)) or
      ((Key in [VK_DOWN, VK_NEXT]) and (FTreeView.FocusedNode = FTreeView.Root.Last)) or
      (not FTreeView.FocusedNode.HasChildren and (Key = VK_RIGHT)) or
      ((FTreeView.FocusedNode.Parent = FTreeView.Root) and (not FTreeView.FocusedNode.HasChildren or not FTreeView.FocusedNode.Expanded) and (Key = VK_LEFT)) then
    TdxGanttControlSheetEditingControllerAccess(TdxGanttControlSheetControllerAccess(Owner.Owner.Controller).EditingController).EditAfterKeyDown(Sender, Key, Shift);
end;

{ TdxGanttControlViewChartSheetColumnPredecessors }

function TdxGanttControlViewChartSheetColumnPredecessors.GetChangeValueCommandClass: TdxGanttControlChangeTaskPropertyCommandClass;
begin
  Result := TdxGanttControlChangeTaskPredecessorsCommand;
end;

function TdxGanttControlViewChartSheetColumnPredecessors.GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass;
begin
  Result := TdxGanttControlViewChartSheetColumnPredecessorsViewInfo;
end;

procedure TdxGanttControlViewChartSheetColumnPredecessors.SubscribeDataModelChanges;
begin
  DataModel.TaskChangedHandlers.Add(TasksChangedHandler);
end;

procedure TdxGanttControlViewChartSheetColumnPredecessors.UnsubscribeDataModelChanges;
begin
  DataModel.TaskChangedHandlers.Remove(TasksChangedHandler);
end;

procedure TdxGanttControlViewChartSheetColumnPredecessors.UpdateTreeView;
begin
  DoUpdateTreeView(DataModel.Tasks);
end;

function TdxGanttControlViewChartSheetColumnPredecessors.DoGetEditValue(ATask: TdxGanttControlTask): Variant;
var
  AResult: TArray<Integer>;
begin
  if ATask.IsValueAssigned(TdxGanttTaskAssignedValue.PredecessorLinks) then
    AResult := ATask.PredecessorLinks.ToArray
  else
    AResult := nil;
  if Length(AResult) > 0 then
    Result := AResult
  else
    Result := Null;
end;

function TdxGanttControlViewChartSheetColumnPredecessors.CreateChangeValueCommand(AControl: TdxGanttControlBase; ADataItem: TObject; const ANewValue: Variant): TdxGanttControlCommand;
begin
  Result := inherited CreateChangeValueCommand(AControl, ADataItem, ANewValue);
  TdxGanttControlChangeTaskPredecessorsCommand(Result).RaiseValidateException := True;
end;

function TdxGanttControlViewChartSheetColumnPredecessors.GetDefaultCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewChartSheetColumnTaskPredecessorsCaption);
end;

function TdxGanttControlViewChartSheetColumnPredecessors.GetDefaultVisible: Boolean;
begin
  Result := False;
end;

function TdxGanttControlViewChartSheetColumnPredecessors.GetDefaultWidth: Integer;
begin
  Result := 81;
end;

class function TdxGanttControlViewChartSheetColumnPredecessors.GetDesignCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewChartSheetColumnTaskPredecessorsCaption);
end;

function TdxGanttControlViewChartSheetColumnPredecessors.GetHintText: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewChartSheetColumnTaskPredecessorsDescription);
end;

procedure TdxGanttControlViewChartSheetColumnPredecessors.DoPopupEditPrepareDisplayValueHandler(
  Sender: TObject; const AEditValue: Variant; var ADisplayValue: Variant);
var
  I: Integer;
  APredecessor: TdxGanttControlTaskPredecessorLink;
  ATask: TdxGanttControlTask;
  ATasks: TdxGanttControlTasks;
  S: string;
begin
  ADisplayValue := '';
  if VarIsNull(AEditValue) then
    Exit;
  if VarIsArray(AEditValue) then
  begin
    for I := VarArrayLowBound(AEditValue, 1) to VarArrayHighBound(AEditValue, 1) do
    begin
      ATask := TdxGanttControlTask(TdxGanttPopupEditProperties(Sender).FData);
      if (ATask <> nil) and ATask.IsValueAssigned(TdxGanttTaskAssignedValue.PredecessorLinks) then
      begin
        ATasks := ATask.Owner;
        APredecessor := ATask.PredecessorLinks.GetItemByPredecessorUID(ATasks[AEditValue[I]].UID);
      end
      else
        APredecessor := nil;
      if APredecessor <> nil then
        S := APredecessor.ToString
      else
        S := IntToStr(AEditValue[I]);
      if ADisplayValue = '' then
        ADisplayValue := S
      else
        ADisplayValue := Format('%s%s%s', [ADisplayValue, TdxCultureInfo.CurrentCulture.FormatSettings.ListSeparator, S]);
    end;
  end;
end;

function TdxGanttControlViewChartSheetColumnPredecessors.GetTreeViewValue: Variant;

  procedure GetNodeValue(AList: TList<Integer>; ANode: TdxTreeViewNode);
  begin
    while ANode <> nil do
    begin
      if ANode.Checked then
        AList.Add(TdxGanttControlTask(ANode.Data).ID);
      if ANode.Count > 0 then
        GetNodeValue(AList, ANode.Items[0]);
      ANode := ANode.Next;
    end;
  end;

var
  AList: TList<Integer>;
begin
  AList := TList<Integer>.Create;
  try
    GetNodeValue(AList, TreeView.Root);
    if AList.Count = 0 then
      Exit(Null);
    AList.Sort;
    Result := AList.ToArray;
  finally
    AList.Free;
  end;
end;

procedure TdxGanttControlViewChartSheetColumnPredecessors.PrepareTreeViewCheckedStates(AData: TObject);

  function FindLink(AUID: Integer): TdxGanttControlTaskPredecessorLink;
  begin
    Result := nil;
    if (AData = nil) or not TdxGanttControlTask(AData).IsValueAssigned(TdxGanttTaskAssignedValue.PredecessorLinks) then
      Exit;
    Result := TdxGanttControlTask(AData).PredecessorLinks.GetItemByPredecessorUID(AUID);
  end;

  procedure HideParentCheckBoxes(ANode: TdxTreeViewNode);
  var
    AParent: TdxTreeViewNode;
  begin
    ANode.HideCheckBox := True;
    AParent := ANode.Parent;
    while (AParent <> nil) and not AParent.IsRoot do
    begin
      AParent.HideCheckBox := True;
      AParent := AParent.Parent;
    end;
  end;

  procedure DoPrepareCheckedStates(ANode: TdxTreeViewNode; AHideCheckBoxes: Boolean);
  begin
    while ANode <> nil do
    begin
      ANode.Checked := FindLink(TdxGanttControlTask(ANode.Data).UID) <> nil;
      if ANode.Data = AData then
        ANode.TreeView.FocusedNode := ANode;
      ANode.HideCheckBox := AHideCheckBoxes or (ANode.Data = AData);
      if ANode.Count > 0 then
      begin
        DoPrepareCheckedStates(ANode.Items[0], ANode.HideCheckBox);
      end;
      if ANode.Data = AData then
        HideParentCheckBoxes(ANode);
      ANode := ANode.Next;
    end;
  end;

begin
  DoPrepareCheckedStates(TreeView.Root.First, False);
end;

procedure TdxGanttControlViewChartSheetColumnPredecessors.TasksChangedHandler(
  Sender: TdxGanttControlDataModel; ATask: TdxGanttControlTask);
begin
  UpdateTreeView;
end;

procedure TdxGanttControlViewChartSheetColumnPredecessors.DoUpdateTreeView(ATasks: TdxGanttControlTasks);

  function CanAddTask(ATask: TdxGanttControlTask): Boolean;
  begin
    Result := (ATask.ID > 0) and not ATask.Blank;
  end;

var
  I: Integer;
  AParent, ANode: TdxTreeViewNode;
begin
  TreeView.Root.BeginUpdate;
  try
    TreeView.Root.Clear;
    AParent := TreeView.Root;
    for I := 0 to ATasks.Count - 1 do
    begin
      if not CanAddTask(ATasks[I]) then
        Continue;
      while (AParent.Data <> nil) and (TdxGanttControlTask(AParent.Data).OutlineLevel >= ATasks[I].OutlineLevel) do
        AParent := AParent.Parent;
      ANode := AParent.AddChild(Format('%d %s', [ATasks[I].ID, ATasks[I].Name]), ATasks[I]);
      if ATasks[I].Summary then
        AParent := ANode;
    end;
  finally
    TreeView.Root.EndUpdate;
  end;
end;

{ TdxGanttControlViewChartSheetColumnPredecessorsViewInfo }

function TdxGanttControlViewChartSheetColumnPredecessorsViewInfo.DoCalculateDisplayText: string;
begin
  Result := TdxGanttControlTask(Owner.Data).PredecessorLinks.ToString;
end;

function TdxGanttControlViewChartSheetColumnPredecessorsViewInfo.HasDisplayText: Boolean;
begin
  Result := inherited HasDisplayText and TdxGanttControlTask(Owner.Data).IsValueAssigned(TdxGanttTaskAssignedValue.PredecessorLinks)
end;

{ TdxGanttControlViewChartSheetColumnResourceName }

constructor TdxGanttControlViewChartSheetColumnResourceName.Create(
  AOwner: TdxGanttControlSheetColumns);
begin
  inherited Create(AOwner);
  TreeView.OptionsView.ShowRoot := False;
end;

function TdxGanttControlViewChartSheetColumnResourceName.GetChangeValueCommandClass: TdxGanttControlChangeTaskPropertyCommandClass;
begin
  Result := TdxGanttControlChangeTaskResourcesCommand;
end;

function TdxGanttControlViewChartSheetColumnResourceName.GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass;
begin
  Result := TdxGanttControlViewChartSheetColumnResourceNameViewInfo;
end;

procedure TdxGanttControlViewChartSheetColumnResourceName.DoPopupEditPrepareDisplayValueHandler(Sender: TObject; const AEditValue: Variant; var ADisplayValue: Variant);
var
  I: Integer;
  AResource: TdxGanttControlResource;
begin
  ADisplayValue := '';
  if VarIsNull(AEditValue) then
    Exit;
  if VarIsArray(AEditValue) then
  begin
    for I := VarArrayLowBound(AEditValue, 1) to VarArrayHighBound(AEditValue, 1) do
    begin
      AResource := TdxGanttControlResource(DataModel.Resources.GetItemByUID(AEditValue[I]));
      if AResource = nil then
        Continue;
      if ADisplayValue = '' then
        ADisplayValue := AResource.Name
      else
        ADisplayValue := Format('%s%s%s', [ADisplayValue, TdxCultureInfo.CurrentCulture.FormatSettings.ListSeparator, AResource.Name]);
    end;
  end;
end;

function TdxGanttControlViewChartSheetColumnResourceName.GetTreeViewValue: Variant;

  procedure GetNodeValue(AList: TList<Integer>; ANode: TdxTreeViewNode);
  begin
    while ANode <> nil do
    begin
      if ANode.Checked then
        AList.Add(TdxGanttControlResource(ANode.Data).UID);
      if ANode.Count > 0 then
        GetNodeValue(AList, ANode.Items[0]);
      ANode := ANode.Next;
    end;
  end;

var
  AList: TList<Integer>;
begin
  AList := TList<Integer>.Create;
  try
    GetNodeValue(AList, TreeView.Root);
    if AList.Count = 0 then
      Exit(Null);
    Result := AList.ToArray;
  finally
    AList.Free;
  end;
end;

procedure TdxGanttControlViewChartSheetColumnResourceName.PrepareTreeViewCheckedStates(AData: TObject);
var
  ATask: TdxGanttControlTask absolute AData;
  AResources: TArray<Integer>;
  I: Integer;
  ANode: TdxTreeViewNode;
  AFindFirstSelectedNode: Boolean;
begin
  if ATask = nil then
    AResources := nil
  else
    AResources := ATask.Resources;
  ANode := TreeView.Root.First;
  AFindFirstSelectedNode := False;
  while ANode <> nil do
  begin
    ANode.Checked := False;
    for I := 0 to Length(AResources) - 1 do
    begin
      if TdxGanttControlResource(ANode.Data).UID = AResources[I] then
      begin
        ANode.Checked := True;
        Break;
      end;
    end;
    if not AFindFirstSelectedNode and (ANode.Checked) then
    begin
      AFindFirstSelectedNode := True;
      TreeView.FocusedNode := ANode;
    end;
    ANode := ANode.Next;
  end;
  if not AFindFirstSelectedNode then
    TreeView.FocusedNode := TreeView.Root.First;
end;

procedure TdxGanttControlViewChartSheetColumnResourceName.SubscribeDataModelChanges;
begin
  DataModel.ResourceChangedHandlers.Add(ResourcesChangedHandler);
end;

procedure TdxGanttControlViewChartSheetColumnResourceName.UnsubscribeDataModelChanges;
begin
  DataModel.ResourceChangedHandlers.Remove(ResourcesChangedHandler);
end;

procedure TdxGanttControlViewChartSheetColumnResourceName.UpdateTreeView;
begin
  DoUpdateTreeView(DataModel.Resources);
end;

function TdxGanttControlViewChartSheetColumnResourceName.DoGetEditValue(ATask: TdxGanttControlTask): Variant;
var
  AResult: TArray<Integer>;
begin
  AResult := ATask.Resources;
  if Length(AResult) > 0 then
    Result := AResult
  else
    Result := Null;
end;

function TdxGanttControlViewChartSheetColumnResourceName.GetDefaultCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewChartSheetColumnTaskResourceNameCaption);
end;

function TdxGanttControlViewChartSheetColumnResourceName.GetDefaultWidth: Integer;
begin
  Result := 81;
end;

function TdxGanttControlViewChartSheetColumnResourceName.GetDefaultWordWrap: Boolean;
begin
  Result := True;
end;

class function TdxGanttControlViewChartSheetColumnResourceName.GetDesignCaption: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewChartSheetColumnTaskResourceNameCaption);
end;

function TdxGanttControlViewChartSheetColumnResourceName.GetHintText: string;
begin
  Result := cxGetResourceString(@sdxGanttControlViewChartSheetColumnTaskResourceNameDescription);
end;

procedure TdxGanttControlViewChartSheetColumnResourceName.ResourcesChangedHandler(Sender: TdxGanttControlDataModel; AResource: TdxGanttControlResource);
begin
  UpdateTreeView;
end;

procedure TdxGanttControlViewChartSheetColumnResourceName.DoUpdateTreeView(AResources: TdxGanttControlResources);
var
  I: Integer;
  AResource: TdxGanttControlResource;
  AStringList: TStringList;
begin
  TreeView.Root.BeginUpdate;
  AStringList := TStringList.Create;
  try
    TreeView.Root.Clear;
    for I := 0 to AResources.Count - 1 do
    begin
      AResource := AResources[I];
      if not AResource.Blank and (AResource.UID > 0) then
        AStringList.AddObject(AResource.Name, AResource);
    end;
    AStringList.Sort;
    for I := 0 to AStringList.Count - 1 do
      TreeView.Root.AddChild(AStringList[I], AStringList.Objects[I]);
  finally
    AStringList.Free;
    TreeView.Root.EndUpdate;
  end;
end;

{ TdxGanttControlViewChartSheetColumnResourceNameViewInfo }

function TdxGanttControlViewChartSheetColumnResourceNameViewInfo.DoCalculateDisplayText: string;
begin
  Result := TdxGanttControlTask(Owner.Data).ResourceName;
end;

{ TdxGanttControlViewChartExtendedAttributeSheetColumn }

function TdxGanttControlViewChartExtendedAttributeSheetColumn.CreateChangeValueCommand(
  AControl: TdxGanttControlBase; ADataItem: TObject;
  const ANewValue: Variant): TdxGanttControlCommand;
begin
  Result := TdxGanttControlChangeTaskExtendedAttributeValueCommand.Create(Owner.Owner.Control, TdxGanttControlTask(ADataItem), FieldName, ANewValue);
end;

function TdxGanttControlViewChartExtendedAttributeSheetColumn.GetActiveCalendar(
  ADataItem: TObject): TdxGanttControlCalendar;
begin
  if ADataItem <> nil then
    Result := TdxGanttControlTask(ADataItem).RealCalendar
  else
    Result := inherited GetActiveCalendar(ADataItem);
end;

function TdxGanttControlViewChartExtendedAttributeSheetColumn.GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass;
begin
  Result := TdxGanttControlViewChartExtendedAttributeSheetColumnViewInfo;
end;

function TdxGanttControlViewChartExtendedAttributeSheetColumn.GetFieldID: Integer;
begin
  Result := TdxGanttControlExtendedAttributeHelper.GetFieldID(FieldName, TdxGanttControlExtendedAttributeLevel.Task);
end;

function TdxGanttControlViewChartExtendedAttributeSheetColumn.GetExtendedAttributeValues(
  AData: TObject): TdxGanttControlExtendedAttributeValues;
begin
  Result := TdxGanttControlTask(AData).ExtendedAttributes;
end;

{ TdxGanttControlViewChartExtendedAttributeSheetColumnViewInfo }

function TdxGanttControlViewChartExtendedAttributeSheetColumnViewInfo.CalculateItemBounds(
  AItem: TdxGanttControlCustomItemViewInfo): TRect;
begin
  Result := Bounds;
end;

procedure TdxGanttControlViewChartExtendedAttributeSheetColumnViewInfo.CalculateLayout;
begin
  inherited CalculateLayout;
  if HasDisplayText and (Column.&Type = TdxGanttControlExtendedAttributeCFType.Flag) then
    AddChild(TdxGanttControlCheckBoxViewInfo.Create(Self));
end;

function TdxGanttControlViewChartExtendedAttributeSheetColumnViewInfo.DoCalculateDisplayText: string;
begin
  if Column.&Type = TdxGanttControlExtendedAttributeCFType.Flag then
    Result := ''
  else
    Result := inherited DoCalculateDisplayText;
end;

function TdxGanttControlViewChartExtendedAttributeSheetColumnViewInfo.GetColumn: TdxGanttControlViewChartExtendedAttributeSheetColumn;
begin
  Result := TdxGanttControlViewChartExtendedAttributeSheetColumn(inherited Column);
end;

function TdxGanttControlViewChartExtendedAttributeSheetColumnViewInfo.GetCurrentCursor(
  const P: TPoint; const ADefaultCursor: TCursor): TCursor;
begin
  if Column.&Type = TdxGanttControlExtendedAttributeCFType.Flag then
    Result := crDefault
  else
    Result := inherited GetCurrentCursor(P, ADefaultCursor);
end;

function TdxGanttControlViewChartExtendedAttributeSheetColumnViewInfo.HasDisplayText: Boolean;
begin
  Result := inherited HasDisplayText and
    ((Column.GetExtendedAttributeValues(Owner.Data)[Column.FieldName] <> nil) or
    (Column.&Type = TdxGanttControlExtendedAttributeCFType.Flag));
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  RegisterClasses([TdxGanttControlViewChartSheetColumnIndicator,
    TdxGanttControlViewChartSheetColumnTaskMode,
    TdxGanttControlViewChartSheetColumnTaskName,
    TdxGanttControlViewChartSheetColumnTaskDuration,
    TdxGanttControlViewChartSheetColumnTaskStart,
    TdxGanttControlViewChartSheetColumnTaskFinish,
    TdxGanttControlViewChartSheetColumnPredecessors,
    TdxGanttControlViewChartSheetColumnResourceName,
    TdxGanttControlViewChartSheetColumnPercentComplete,
    TdxGanttControlViewChartSheetColumnPercentWorkComplete,
    TdxGanttControlViewChartExtendedAttributeSheetColumn]);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
