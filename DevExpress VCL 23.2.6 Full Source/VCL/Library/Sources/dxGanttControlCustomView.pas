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

unit dxGanttControlCustomView;

{$I cxVer.inc}
{$I dxGanttControl.inc}

interface

uses
  System.UITypes, System.Contnrs,
  SysUtils, Windows, Messages, MultiMon, Types, Forms, Controls, Graphics, Dialogs,
  Classes, Themes, Generics.Defaults, Generics.Collections, StdCtrls,
  cxClasses, dxCore, dxCoreClasses, cxControls, cxGeometry, cxLookAndFeels, cxLookAndFeelPainters,
  cxGraphics, cxCustomCanvas, dxTouch, dxGDIPlusClasses, dxBuiltInPopupMenu, cxStorage,
  dxGanttControlCustomClasses,
  dxGanttControlCommands,
  dxGanttControlCustomSheet,
  dxGanttControlSplitter,
  dxGanttControlCalendars,
  dxGanttControlDataModel,
  dxGanttControlTasks,
  dxGanttControlAssignments,
  dxGanttControlExtendedAttributes,
  dxGanttControlResources;

type
  TdxGanttControlCustomView = class;
  TdxGanttControlViewCustomController = class;

  { TdxGanttControlViewCommand }

  TdxGanttControlViewCommand = class abstract(TdxGanttControlCommand)
  strict private
    function GetController: TdxGanttControlViewCustomController;
  protected
    function GetView: TdxGanttControlCustomView; virtual; abstract;

    property Controller: TdxGanttControlViewCustomController read GetController;
  public
    function GetMenuCaption: string; virtual;
    function GetMenuDescription: string; virtual;
    function GetMenuImage: TdxSmartImage; virtual;
    function IsChecked: Boolean; virtual;

    property View: TdxGanttControlCustomView read GetView;
  end;
  TdxGanttControlViewCommandClass = class of TdxGanttControlViewCommand;

  { TdxGanttControlTaskViewInfoCachedValues }

  TdxGanttControlTaskViewInfoCachedValues = class // for internal use
  protected
    FManualTaskColor: TColor;
    FMilestoneColor: TColor;
    FMilestoneSize: TSize;
    FTaskColor: TColor;
    FTaskHeight: Integer;
    FSummaryColor: TColor;
    FSummaryHeight: Integer;
  public
    procedure Update(APainter: TcxCustomLookAndFeelPainter; AScaleFactor: TdxScaleFactor); virtual;
    property ManualTaskColor: TColor read FManualTaskColor;
    property MilestoneColor: TColor read FMilestoneColor;
    property MilestoneSize: TSize read FMilestoneSize;
    property SummaryColor: TColor read FSummaryColor;
    property SummaryHeight: Integer read FSummaryHeight;
    property TaskColor: TColor read FTaskColor;
    property TaskHeight: Integer read FTaskHeight;
  end;

  { TdxGanttControlTaskCustomViewInfo }

  TdxGanttControlTaskCustomViewInfo = class(TdxGanttControlCustomOwnedItemViewInfo)
  strict private
    FBarBounds: TRect;
    FBarProgressBounds: TRect;
    FCalendar: TdxGanttControlCalendar;
    FCaption: string;
    FCaptionBounds: TRect;
    FColor: TColor;
    FTask: TdxGanttControlTask;
  protected
    function CalculateBarBounds(const R: TRect): TRect; virtual; abstract;
    function CalculateBarProgressBounds(const R: TRect): TRect; virtual; abstract;
    function CalculateCaptionBounds(const R: TRect): TRect; virtual; abstract;

    procedure DoRightToLeftConversion(const AClientBounds: TRect); override;
    procedure DoScroll(const DX, DY: Integer); override;

    procedure CalculateColor;
    function CalculateHitTest(const AHitTest: TdxGanttControlHitTest): Boolean; override;
    function DoGetColor(const AColor: TColor): TColor; virtual;
    function GetCachedValues: TdxGanttControlTaskViewInfoCachedValues; virtual; abstract;
    function GetCaption: string; virtual; abstract;
    function GetCurrentCalendar: TdxGanttControlCalendar; virtual;
    function GetDefaultColor: TColor; overload; virtual;
    function GetDefaultColor(AIsManual: Boolean): TColor; overload; virtual;
    function GetHitBounds: TRect; virtual;
    function GetHintText: string; override;
    function GetMilestoneSize: TSize; virtual;
    function GetTaskHeight: Integer; virtual;
    function HasHint: Boolean; override;
    procedure Initialize; virtual;

    property Calendar: TdxGanttControlCalendar read FCalendar;
    property CachedValues: TdxGanttControlTaskViewInfoCachedValues read GetCachedValues;
    property Caption: string read FCaption;
    property Color: TColor read FColor;
  public
    constructor Create(AOwner: TdxGanttControlCustomItemViewInfo; ATask: TdxGanttControlTask); reintroduce; virtual;
    procedure Calculate(const R: TRect); override;

    property BarBounds: TRect read FBarBounds;
    property BarProgressBounds: TRect read FBarProgressBounds;
    property CaptionBounds: TRect read FCaptionBounds;
    property Task: TdxGanttControlTask read FTask;
  end;

  { TdxGanttControlViewCustomViewInfo }

  TdxGanttControlViewCustomViewInfo = class(TdxGanttControlCustomParentViewInfo)
  strict private
    FTextLayout: TcxCanvasBasedTextLayout;
    FView: TdxGanttControlCustomView;
    function GetController: TdxGanttControlViewCustomController; inline;
    function GetDataProvider: TdxGanttControlCustomDataProvider; inline;
  protected
    function GetTextLayout: TcxCanvasBasedTextLayout;

    procedure Reset; override;

    property Controller: TdxGanttControlViewCustomController read GetController;
    property DataProvider: TdxGanttControlCustomDataProvider read GetDataProvider;
  public
    constructor Create(AOwner: TdxGanttControlCustomItemViewInfo; AView: TdxGanttControlCustomView); reintroduce; overload; virtual;
    constructor Create(AView: TdxGanttControlCustomView); reintroduce; overload;
    destructor Destroy; override;

    property View: TdxGanttControlCustomView read FView;
  end;

  { TdxGanttControlPopupMenu }

  TdxGanttControlPopupMenu = class(TComponent)
  strict private
    FAdapter: TdxCustomBuiltInPopupMenuAdapter;
    FCommands: TdxFastObjectList;
    FControl: TdxGanttControlBase;
    FImages: TcxImageList;
    procedure MenuItemClick(Sender: TObject);
  protected
    function DoAddCommand(ACommand: TdxGanttControlViewCommand): Integer;
    function Initialize(var P: TPoint): Boolean;
  public
    constructor Create(AControl: TdxGanttControlBase); reintroduce;
    destructor Destroy; override;

    procedure AddCommand(ACommand: TdxGanttControlViewCommand; AKey: Word; AShift: TShiftState; AParentComponent: TComponent = nil); overload;
    function AddCommand(ACommand: TdxGanttControlViewCommand; AShortCut: TShortCut = 0; AParentComponent: TComponent = nil): TComponent; overload;
    function AddSubMenu(ACommand: TdxGanttControlViewCommand; AParentComponent: TComponent = nil): TComponent;
    procedure AddSeparator;

    function Popup(const P: TPoint): Boolean;
  end;

  { TdxGanttControlViewCustomController }

  TdxGanttControlViewCustomController = class abstract(TdxGanttControlCustomController)
  strict private
    FCaptureController: TdxGanttControlCustomController;
    FView: TdxGanttControlCustomView;
    function GetDataProvider: TdxGanttControlCustomDataProvider; inline;
    function InternalGetViewInfo: TdxGanttControlViewCustomViewInfo; inline;
  protected
    function GetControllerByCursorPos(const P: TPoint): TdxGanttControlCustomController; virtual;
    function GetCurrentController: TdxGanttControlCustomController; overload;
    function GetCurrentController(const P: TPoint): TdxGanttControlCustomController; overload; virtual;
    function GetDesignHitTest(X: Integer; Y: Integer; Shift: TShiftState): Boolean; override;
    function GetDragHelper: TdxGanttControlDragHelper; override;
    function GetGestureClient(const APoint: TPoint): IdxGestureClient; override;
    function GetViewInfo: TdxGanttControlCustomItemViewInfo; override;

    procedure DoClick; override;
    procedure DoDblClick; override;
    procedure DoMouseDown(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer); override;
    procedure DoMouseMove(Shift: TShiftState; X: Integer; Y: Integer); override;
    procedure DoMouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer); override;
    function DoMouseWheel(Shift: TShiftState; AIsIncrement: Boolean; const AMousePos: TPoint): Boolean; override;
    function GetTouchScrollUIOwner(const APoint: TPoint): IdxTouchScrollUIOwner; override;

    function InitializeBuiltInPopupMenu(APopupMenu: TdxGanttControlPopupMenu; var P: TPoint): Boolean; virtual;

    property CaptureController: TdxGanttControlCustomController read FCaptureController;
    property DataProvider: TdxGanttControlCustomDataProvider read GetDataProvider;
    property ViewInfo: TdxGanttControlViewCustomViewInfo read InternalGetViewInfo;
  public
    constructor Create(AView: TdxGanttControlCustomView); reintroduce; virtual;

    property View: TdxGanttControlCustomView read FView;
  end;

  { TdxGanttControlViewPersistent }

  TdxGanttControlViewPersistent = class(TdxGanttControlPersistent)
  strict private
    FOwner: TdxGanttControlCustomView;
  protected
    procedure DoAssign(Source: TPersistent); override;
    procedure DoChanged; override;
    procedure DoReset; override;

    property Owner: TdxGanttControlCustomView read FOwner;
  public
    constructor Create(AOwner: TdxGanttControlCustomView);
  end;

  { TdxGanttControlViewPopupMenuItems }

  TdxGanttControlViewPopupMenuItem = (Default, Disabled, Hidden);

  TdxGanttControlViewPopupMenuItems = class abstract(TdxGanttControlViewPersistent)
  strict private
    FUseBuiltInPopupMenu: TdxDefaultBoolean;
    function GetRealUseBuiltInPopupMenu: Boolean;
  protected
    procedure DoAssign(Source: TPersistent); override;
    procedure DoChanged; override;
    procedure DoReset; override;

    property RealUseBuiltInPopupMenu: Boolean read GetRealUseBuiltInPopupMenu;
  published
    property UseBuiltInPopupMenu: TdxDefaultBoolean read FUseBuiltInPopupMenu write FUseBuiltInPopupMenu default bDefault;
  end;

  { TdxGanttControlCustomView }

  TdxGanttControlViewType = (None, Chart, ResourceSheet, Timeline);

  TdxGanttControlCustomView = class abstract(TdxGanttControlCustomOptions, IcxStoredObject, IcxStoredParent)
  strict private
    FController: TdxGanttControlViewCustomController;
    FDataProvider: TdxGanttControlCustomDataProvider;

    // IcxStoredObject events
    FOnGetStoredProperties: TcxGetStoredPropertiesEvent;
    FOnGetStoredPropertyValue: TcxGetStoredPropertyValueEvent;
    FOnSetStoredPropertyValue: TcxSetStoredPropertyValueEvent;

    function GetActive: Boolean;
    function GetViewInfo: TdxGanttControlViewCustomViewInfo;
    function InternalGetOwner: TdxGanttControlBase; inline;
    procedure SetActive(const Value: Boolean);
    // IcxStoredParent
    function IcxStoredParent.CreateChild = StoredCreateChild;
    procedure IcxStoredParent.DeleteChild = StoredDeleteChild;
    procedure IcxStoredParent.GetChildren = StoredChildren;
  protected
    procedure DoChanged(AChanges: TdxGanttControlOptionsChangedTypes); override;
    procedure DoReset; override;

    function CreateController: TdxGanttControlViewCustomController; virtual; abstract;
    function CreateDataProvider: TdxGanttControlCustomDataProvider; virtual; abstract;
    function CreateViewInfo: TdxGanttControlViewCustomViewInfo; virtual; abstract;
    function GetScaleFactor: TdxScaleFactor; override;
    function GetType: TdxGanttControlViewType; virtual; abstract;

    // IcxStoredObject
    function GetObjectName: string; virtual;
    procedure GetCustomProperties(AProperties: TStrings); virtual;
    function GetProperties(AProperties: TStrings): Boolean; virtual;
    procedure GetPropertyValue(const AName: string; var AValue: Variant); virtual;
    procedure SetPropertyValue(const AName: string; const AValue: Variant); virtual;
    // IcxStoredParent
    function StoredCreateChild(const AObjectName, AClassName: string): TObject; virtual;
    procedure StoredDeleteChild(const AObjectName: string; AObject: TObject); virtual;
    procedure StoredChildren(AChildren: TStringList); virtual;

    property ViewInfo: TdxGanttControlViewCustomViewInfo read GetViewInfo;
  public
    destructor Destroy; override;
    procedure AfterConstruction; override;

    property Controller: TdxGanttControlViewCustomController read FController; // for internal use
    property DataProvider: TdxGanttControlCustomDataProvider read FDataProvider; // for internal use
    property Owner: TdxGanttControlBase read InternalGetOwner; // for internal use
  published
    property Active: Boolean read GetActive write SetActive default False;
    // IcxStoredObject events
    property OnGetStoredProperties: TcxGetStoredPropertiesEvent read FOnGetStoredProperties write FOnGetStoredProperties;
    property OnGetStoredPropertyValue: TcxGetStoredPropertyValueEvent read FOnGetStoredPropertyValue write FOnGetStoredPropertyValue;
    property OnSetStoredPropertyValue: TcxSetStoredPropertyValueEvent read FOnSetStoredPropertyValue write FOnSetStoredPropertyValue;
  end;

  { TdxGanttControlViewSheetOptions }

  TdxGanttControlViewSheetOptions = class abstract(TdxGanttControlSheetOptions)
  public
    function AddExtendedAttributeColumn(const AFieldName: string): TdxGanttControlSheetColumn;
    procedure AddExtendedAttributeColumns; overload;
    procedure AddExtendedAttributeColumns(AType: TdxGanttControlExtendedAttributeCFType); overload;
    procedure RetrieveMissingExtendedAttributeColumns;
  end;

  { TdxGanttControlViewSheetController }

  TdxGanttControlViewSheetController = class abstract(TdxGanttControlSheetController)
  protected
    function GetView: TdxGanttControlCustomView; virtual; abstract;
    function InitializeBuiltInPopupMenu(APopupMenu: TdxGanttControlPopupMenu; var P: TPoint): Boolean; virtual;
  public
    property View: TdxGanttControlCustomView read GetView; // for internal use
  end;

implementation

uses
  Menus, RTLConsts,
  dxTypeHelpers, dxSVGCanvas,
  dxGanttControl,
  dxGanttControlSheetColumns,
  dxGanttControlViewCommands;

const
  dxThisUnitName = 'dxGanttControlCustomView';

type
  TdxGanttControlHitTestAccess = class(TdxGanttControlHitTest);
  TdxGanttControlBaseAccess = class(TdxGanttControlBase);
  TdxGanttControlCustomControllerAccess = class(TdxGanttControlCustomController);
  TdxGanttControlControllerAccess = class(TdxGanttControlController);
  TdxCustomGanttControlAccess = class(TdxCustomGanttControl);
  TdxGanttControlCustomViewInfoAccess = class(TdxGanttControlCustomViewInfo);
  TdxGanttControlSheetColumnsAccess = class(TdxGanttControlSheetColumns);

{ TdxGanttControlViewCommand }

function TdxGanttControlViewCommand.GetController: TdxGanttControlViewCustomController;
begin
  Result := View.Controller;
end;

function TdxGanttControlViewCommand.GetMenuCaption: string;
begin
  Result := '';
end;

function TdxGanttControlViewCommand.GetMenuDescription: string;
begin
  Result := '';
end;

function TdxGanttControlViewCommand.GetMenuImage: TdxSmartImage;
begin
  Result := nil;
end;

function TdxGanttControlViewCommand.IsChecked: Boolean;
begin
  Result := False;
end;

{ TdxGanttControlTaskViewInfoCachedValues }

procedure TdxGanttControlTaskViewInfoCachedValues.Update(
  APainter: TcxCustomLookAndFeelPainter; AScaleFactor: TdxScaleFactor);
begin
  FMilestoneSize := AScaleFactor.Apply(APainter.GetGanttMilestoneSize);
  FSummaryHeight := AScaleFactor.Apply(APainter.GetGanttSummaryTaskHeight);
  FTaskHeight := AScaleFactor.Apply(APainter.GetGanttTaskHeight);

  FTaskColor := APainter.GetGanttTaskColor(False);
  FManualTaskColor := APainter.GetGanttTaskColor(True);
  FSummaryColor := APainter.GetGanttSummaryTaskColor;
  FMilestoneColor := APainter.GetGanttMilestoneColor;
end;

{ TdxGanttControlTaskCustomViewInfo }

constructor TdxGanttControlTaskCustomViewInfo.Create(AOwner: TdxGanttControlCustomItemViewInfo; ATask: TdxGanttControlTask);
begin
  inherited Create(AOwner);
  FTask := ATask;
  Initialize;
end;

procedure TdxGanttControlTaskCustomViewInfo.Calculate(const R: TRect);
begin
  inherited Calculate(R);
  FCalendar := GetCurrentCalendar;
  FBarBounds := CalculateBarBounds(R);
  FBarProgressBounds := CalculateBarProgressBounds(R);
  FCaptionBounds := CalculateCaptionBounds(R);
  CalculateColor;
end;

function TdxGanttControlTaskCustomViewInfo.DoGetColor(const AColor: TColor): TColor;
begin
  if Task <> nil then
    Result := Task.Color
  else
    Result := clDefault;
  if Result = clDefault then
    Result := AColor;
end;

procedure TdxGanttControlTaskCustomViewInfo.DoRightToLeftConversion(const AClientBounds: TRect);
begin
  inherited DoRightToLeftConversion(AClientBounds);
  FBarBounds := TdxRightToLeftLayoutConverter.ConvertRect(BarBounds, AClientBounds);
  FBarProgressBounds := TdxRightToLeftLayoutConverter.ConvertRect(BarProgressBounds, AClientBounds);
  FCaptionBounds := TdxRightToLeftLayoutConverter.ConvertRect(FCaptionBounds, AClientBounds);
end;

procedure TdxGanttControlTaskCustomViewInfo.DoScroll(const DX, DY: Integer);
begin
  inherited DoScroll(DX, DY);
  FBarBounds := cxRectOffset(FBarBounds, DX, DY);
  FBarProgressBounds := cxRectOffset(FBarProgressBounds, DX, DY);
  FCaptionBounds := cxRectOffset(FCaptionBounds, DX, DY);
end;

function TdxGanttControlTaskCustomViewInfo.GetCurrentCalendar: TdxGanttControlCalendar;
begin
  Result := Task.RealCalendar;
end;

function TdxGanttControlTaskCustomViewInfo.GetDefaultColor(AIsManual: Boolean): TColor;
begin
  if AIsManual then
    Result := CachedValues.ManualTaskColor
  else
    Result := CachedValues.TaskColor;
end;

function TdxGanttControlTaskCustomViewInfo.GetHintText: string;
var
  AStart, AFinish, ADuration, AComplete: string;
begin
  Result := Format('[B]%s[/B]', [Task.Name]);
  AStart := Task.GetStartInfo;
  if AStart <> '' then
    Result := Result + #13#10 + AStart;
  if not Task.Milestone then
  begin
    AFinish := Task.GetFinishInfo;
    ADuration := Task.GetDurationInfo;
    AComplete := Task.GetPercentCompleteInfo;
    if AFinish <> '' then
      Result := Result + #13#10 + AFinish;
    if ADuration <> '' then
      Result := Result + #13#10 + ADuration;
    if AComplete <> '' then
      Result := Result + #13#10 + AComplete;
  end;
end;

function TdxGanttControlTaskCustomViewInfo.GetHitBounds: TRect;
begin
  Result := FBarBounds;
end;

function TdxGanttControlTaskCustomViewInfo.GetDefaultColor: TColor;
begin
  Result := GetDefaultColor(Task.Manual);
end;

function TdxGanttControlTaskCustomViewInfo.GetMilestoneSize: TSize;
begin
  Result := CachedValues.MilestoneSize;
end;

function TdxGanttControlTaskCustomViewInfo.GetTaskHeight: Integer;
begin
  Result := CachedValues.TaskHeight;
end;

function TdxGanttControlTaskCustomViewInfo.HasHint: Boolean;
begin
  Result := True;
end;

procedure TdxGanttControlTaskCustomViewInfo.CalculateColor;
begin
  FColor := DoGetColor(GetDefaultColor);
end;

function TdxGanttControlTaskCustomViewInfo.CalculateHitTest(const AHitTest: TdxGanttControlHitTest): Boolean;
begin
  Result := PtInRect(GetHitBounds, AHitTest.HitPoint);
  if Result then
    TdxGanttControlHitTestAccess(AHitTest).SetHitObject(Self);
end;

procedure TdxGanttControlTaskCustomViewInfo.Initialize;
begin
  FCaption := GetCaption;
end;

{ TdxGanttControlViewCustomViewInfo }

constructor TdxGanttControlViewCustomViewInfo.Create(AOwner: TdxGanttControlCustomItemViewInfo; AView: TdxGanttControlCustomView);
begin
  inherited Create(AOwner);
  FView := AView;
end;

constructor TdxGanttControlViewCustomViewInfo.Create(AView: TdxGanttControlCustomView);
begin
  Create(TdxGanttControlBaseAccess(AView.Owner).ViewInfo, AView);
end;

destructor TdxGanttControlViewCustomViewInfo.Destroy;
begin
  FreeAndNil(FTextLayout);
  inherited Destroy;
end;

function TdxGanttControlViewCustomViewInfo.GetController: TdxGanttControlViewCustomController;
begin
  Result := View.Controller;
end;

function TdxGanttControlViewCustomViewInfo.GetDataProvider: TdxGanttControlCustomDataProvider;
begin
  Result := View.DataProvider;
end;

function TdxGanttControlViewCustomViewInfo.GetTextLayout: TcxCanvasBasedTextLayout;
begin
  if FTextLayout = nil then
    FTextLayout := Canvas.CreateTextLayout;
  Result := FTextLayout;
end;

procedure TdxGanttControlViewCustomViewInfo.Reset;
begin
  inherited Reset;
  FreeAndNil(FTextLayout);
end;

{ TdxGanttControlPopupMenu }

constructor TdxGanttControlPopupMenu.Create(AControl: TdxGanttControlBase);
begin
  inherited Create(nil);
  FControl := AControl;
  FCommands := TdxFastObjectList.Create;
  FImages := TcxImageList.Create(Self);
  FAdapter := TdxBuiltInPopupMenuAdapterManager.GetActualAdapterClass.Create(Self);
  FAdapter.SetImages(FImages);
end;

destructor TdxGanttControlPopupMenu.Destroy;
begin
  FreeAndNil(FAdapter);
  FreeAndNil(FCommands);
  FreeAndNil(FImages);
  inherited Destroy;
end;

procedure TdxGanttControlPopupMenu.AddCommand(ACommand: TdxGanttControlViewCommand; AKey: Word; AShift: TShiftState; AParentComponent: TComponent = nil);
begin
  AddCommand(ACommand, ShortCut(AKey, AShift), AParentComponent);
end;

function TdxGanttControlPopupMenu.AddCommand(
  ACommand: TdxGanttControlViewCommand; AShortCut: TShortCut = 0; AParentComponent: TComponent = nil): TComponent;
var
  AImageIndex: Integer;
begin
  AImageIndex := DoAddCommand(ACommand);
  if ACommand.Visible then
  begin
    Result := FAdapter.Add(ACommand.GetMenuCaption, MenuItemClick, FCommands.Count - 1, AImageIndex, ACommand.Enabled, AShortCut, AParentComponent);
    if ACommand.IsChecked then
      FAdapter.SetChecked(Result, True);
  end
  else
    Result := nil;
end;

function TdxGanttControlPopupMenu.AddSubMenu(ACommand: TdxGanttControlViewCommand; AParentComponent: TComponent = nil): TComponent;
var
  AImageIndex: Integer;
begin
  AImageIndex := DoAddCommand(ACommand);
  if ACommand.Visible then
  begin
    Result := FAdapter.AddSubMenu(ACommand.GetMenuCaption, nil, -1, AImageIndex, ACommand.Enabled, 0, AParentComponent);
    if ACommand.IsChecked then
      FAdapter.SetChecked(Result, True);
  end
  else
    Result := nil;
end;

procedure TdxGanttControlPopupMenu.AddSeparator;
begin
  FAdapter.AddSeparator;
end;

function TdxGanttControlPopupMenu.DoAddCommand(ACommand: TdxGanttControlViewCommand): Integer;
var
  AImage: TdxSmartImage;
begin
  FCommands.Add(ACommand);
  AImage := ACommand.GetMenuImage;
  if AImage <> nil then
  begin
    Result := FImages.Count;
    FImages.Add(AImage);
  end
  else
    Result := -1;
end;

function TdxGanttControlPopupMenu.Initialize(var P: TPoint): Boolean;
begin
  FAdapter.Clear;
  FCommands.Clear;
  FImages.Clear;
  Result := TdxGanttControlControllerAccess(FControl.Controller).InitializeBuiltInPopupMenu(Self, P);
end;

procedure TdxGanttControlPopupMenu.MenuItemClick(Sender: TObject);
begin
  TdxGanttControlCommand(FCommands[TComponent(Sender).Tag]).Execute;
end;

function TdxGanttControlPopupMenu.Popup(const P: TPoint): Boolean;
var
  APopupPoint: TPoint;
begin
  TdxGanttControlBaseAccess(FControl).HintController.Hide;
  TdxGanttControlBaseAccess(FControl).HintController.LockHint := True;
  try
    APopupPoint := P;
    FAdapter.BiDiMode := FControl.BiDiMode;
    Result := Initialize(APopupPoint) and FAdapter.Popup(FControl.ClientToScreen(APopupPoint));
  finally
    TdxGanttControlBaseAccess(FControl).HintController.LockHint := False;
  end;
end;

{ TdxGanttControlViewCustomController }

constructor TdxGanttControlViewCustomController.Create(
  AView: TdxGanttControlCustomView);
begin
  inherited Create(AView.Owner);
  FView := AView;
end;

function TdxGanttControlViewCustomController.GetControllerByCursorPos(const P: TPoint): TdxGanttControlCustomController;
begin
  Result := nil;
end;

function TdxGanttControlViewCustomController.GetCurrentController: TdxGanttControlCustomController;
begin
  Result := GetCurrentController(HitTest.HitPoint);
end;

function TdxGanttControlViewCustomController.GetCurrentController(const P: TPoint): TdxGanttControlCustomController;
begin
  if FCaptureController <> nil then
    Result := FCaptureController
  else
    Result := GetControllerByCursorPos(P);
end;

function TdxGanttControlViewCustomController.GetDataProvider: TdxGanttControlCustomDataProvider;
begin
  Result := View.DataProvider;
end;

function TdxGanttControlViewCustomController.GetDesignHitTest(X, Y: Integer;
  Shift: TShiftState): Boolean;
var
  AController: TdxGanttControlCustomController;
begin
  AController := GetControllerByCursorPos(TPoint.Create(X, Y));
  if AController <> nil then
    Result := TdxGanttControlCustomControllerAccess(AController).GetDesignHitTest(X, Y, Shift)
  else
    Result := inherited GetDesignHitTest(X, Y, Shift);
end;

function TdxGanttControlViewCustomController.InitializeBuiltInPopupMenu(
  APopupMenu: TdxGanttControlPopupMenu; var P: TPoint): Boolean;
begin
  Result := False;
end;

function TdxGanttControlViewCustomController.InternalGetViewInfo: TdxGanttControlViewCustomViewInfo;
begin
  Result := TdxGanttControlViewCustomViewInfo(inherited ViewInfo);
end;

function TdxGanttControlViewCustomController.GetDragHelper: TdxGanttControlDragHelper;
begin
  if GetCurrentController <> nil then
    Result := TdxGanttControlCustomControllerAccess(GetCurrentController).DragHelper
  else
    Result := inherited GetDragHelper;
end;

function TdxGanttControlViewCustomController.GetGestureClient(const APoint: TPoint): IdxGestureClient;
var
  AController: TdxGanttControlCustomController;
begin
  if FCaptureController <> nil then
    Result := TdxGanttControlCustomControllerAccess(FCaptureController).GetGestureClient(APoint)
  else
  begin
    AController := GetControllerByCursorPos(APoint);
    if AController <> nil then
      Result := TdxGanttControlCustomControllerAccess(AController).GetGestureClient(APoint)
    else
      Result := inherited GetGestureClient(APoint);
  end;
end;

function TdxGanttControlViewCustomController.GetViewInfo: TdxGanttControlCustomItemViewInfo;
begin
  Result := View.ViewInfo;
end;

procedure TdxGanttControlViewCustomController.DoClick;
begin
  if FCaptureController <> nil then
    FCaptureController.Click;
  inherited DoClick;
end;

procedure TdxGanttControlViewCustomController.DoDblClick;
begin
  if GetCurrentController <> nil then
    GetCurrentController.DblClick;
  inherited DoDblClick;
end;

procedure TdxGanttControlViewCustomController.DoMouseDown(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
begin
  FCaptureController := GetControllerByCursorPos(TPoint.Create(X, Y));
  if GetCurrentController(TPoint.Create(X, Y)) <> nil then
    GetCurrentController(TPoint.Create(X, Y)).MouseDown(Button, Shift, X, Y);
  inherited DoMouseDown(Button, Shift, X, Y);
end;

procedure TdxGanttControlViewCustomController.DoMouseMove(Shift: TShiftState; X: Integer; Y: Integer);
begin
  if GetCurrentController(TPoint.Create(X, Y)) <> nil then
    GetCurrentController(TPoint.Create(X, Y)).MouseMove(Shift, X, Y);
  inherited DoMouseMove(Shift, X, Y);
end;

procedure TdxGanttControlViewCustomController.DoMouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
begin
  inherited DoMouseUp(Button, Shift, X, Y);
  if GetCurrentController(TPoint.Create(X, Y)) <> nil then
    GetCurrentController(TPoint.Create(X, Y)).MouseUp(Button, Shift, X, Y);
  FCaptureController := nil;
end;

function TdxGanttControlViewCustomController.DoMouseWheel(Shift: TShiftState; AIsIncrement: Boolean; const AMousePos: TPoint): Boolean;
var
  AController: TdxGanttControlCustomController;
begin
  AController := GetCurrentController(AMousePos);
  Result := (AController <> nil) and
    AController.MouseWheel(Shift, AIsIncrement, AMousePos);
end;

function TdxGanttControlViewCustomController.GetTouchScrollUIOwner(const APoint: TPoint): IdxTouchScrollUIOwner;
var
  AController: TdxGanttControlCustomController;
begin
  AController := GetCurrentController(APoint);
  if AController <> nil then
    Result := TdxGanttControlCustomControllerAccess(AController).GetTouchScrollUIOwner(APoint)
  else
    Result := inherited GetTouchScrollUIOwner(APoint);
end;

{ TdxGanttControlViewPersistent }

constructor TdxGanttControlViewPersistent.Create(
  AOwner: TdxGanttControlCustomView);
begin
  inherited Create;
  FOwner := AOwner;
end;

procedure TdxGanttControlViewPersistent.DoAssign(Source: TPersistent);
begin
// do nothing
end;

procedure TdxGanttControlViewPersistent.DoChanged;
begin
  FOwner.Changed([TdxGanttControlOptionsChangedType.View]);
end;

procedure TdxGanttControlViewPersistent.DoReset;
begin
// do nothing
end;

{ TdxGanttControlViewPopupMenuItems }

procedure TdxGanttControlViewPopupMenuItems.DoAssign(Source: TPersistent);
var
  ASource: TdxGanttControlViewPopupMenuItems;
begin
  inherited DoAssign(Source);
  if Source is TdxGanttControlViewPopupMenuItems then
  begin
    ASource := TdxGanttControlViewPopupMenuItems(Source);
    FUseBuiltInPopupMenu := ASource.UseBuiltInPopupMenu;
  end;
end;

procedure TdxGanttControlViewPopupMenuItems.DoChanged;
begin
// do nothing
end;

procedure TdxGanttControlViewPopupMenuItems.DoReset;
begin
  inherited DoReset;
  FUseBuiltInPopupMenu := bDefault;
end;

function TdxGanttControlViewPopupMenuItems.GetRealUseBuiltInPopupMenu: Boolean;
begin
  Result := dxDefaultBooleanToBoolean(FUseBuiltInPopupMenu, Owner.Owner.OptionsBehavior.UseBuiltInPopupMenus);
end;

{ TdxGanttControlCustomView }

destructor TdxGanttControlCustomView.Destroy;
begin
  FreeAndNil(FController);
  FreeAndNil(FDataProvider);
  inherited Destroy;
end;

procedure TdxGanttControlCustomView.AfterConstruction;
begin
  FDataProvider := CreateDataProvider;
  FController := CreateController;
  inherited AfterConstruction;
end;

procedure TdxGanttControlCustomView.DoChanged(AChanges: TdxGanttControlOptionsChangedTypes);
begin
  inherited DoChanged(AChanges);
  TdxCustomGanttControlAccess(Owner).ViewChanged(Self, AChanges)
end;

procedure TdxGanttControlCustomView.DoReset;
begin
// do nothing
end;

function TdxGanttControlCustomView.GetActive: Boolean;
begin
  Result := TdxCustomGanttControlAccess(Owner).ActiveViewType = GetType;
end;

function TdxGanttControlCustomView.GetViewInfo: TdxGanttControlViewCustomViewInfo;
var
  I: Integer;
  AControlViewInfo: TdxGanttControlCustomViewInfoAccess;
begin
  if not Active then
    Exit(nil);
  AControlViewInfo := TdxGanttControlCustomViewInfoAccess(TdxGanttControlBaseAccess(Owner).ViewInfo);
  for I := 0 to AControlViewInfo.ViewInfoCount - 1 do
    if (AControlViewInfo.ViewInfos[I] is TdxGanttControlViewCustomViewInfo) and
        (TdxGanttControlViewCustomViewInfo(AControlViewInfo.ViewInfos[I]).View = Self) then
      Exit(TdxGanttControlViewCustomViewInfo(AControlViewInfo.ViewInfos[I]));
  Result := nil;
end;

function TdxGanttControlCustomView.InternalGetOwner: TdxGanttControlBase;
begin
  Result := TdxGanttControlBase(inherited Owner);
end;

function TdxGanttControlCustomView.GetScaleFactor: TdxScaleFactor;
begin
  Result := TdxCustomGanttControlAccess(Owner).ScaleFactor;
end;

procedure TdxGanttControlCustomView.SetActive(const Value: Boolean);
var
  AType: TdxGanttControlViewType;
begin
  if Active <> Value then
  begin
    if Value then
      AType := GetType
    else
    begin
      AType := TdxCustomGanttControlAccess(Owner).ActiveViewType;
      Inc(AType);
      if AType > High(TdxGanttControlViewType) then
        AType := TdxGanttControlViewType.Chart;
    end;
    TdxCustomGanttControlAccess(Owner).ActiveViewType := AType;
  end;
end;

// IcxStoredObject }

function TdxGanttControlCustomView.GetObjectName: string;
begin
  Result := '';
end;

procedure TdxGanttControlCustomView.GetCustomProperties(AProperties: TStrings);
begin
//
end;

function TdxGanttControlCustomView.GetProperties(AProperties: TStrings): Boolean;
begin
  GetCustomProperties(AProperties);
  if Assigned(OnGetStoredProperties) then
    OnGetStoredProperties(Self, AProperties);
  Result := True;
end;

procedure TdxGanttControlCustomView.GetPropertyValue(const AName: string; var AValue: Variant);
begin
  if Assigned(OnGetStoredPropertyValue) then
    OnGetStoredPropertyValue(Self, AName, AValue);
end;

procedure TdxGanttControlCustomView.SetPropertyValue(const AName: string; const AValue: Variant);
begin
  if Assigned(OnSetStoredPropertyValue) then
    OnSetStoredPropertyValue(Self, AName, AValue);
end;

// IcxStoredParent
procedure TdxGanttControlCustomView.StoredChildren(AChildren: TStringList);
begin
//
end;

function TdxGanttControlCustomView.StoredCreateChild(const AObjectName, AClassName: string): TObject;
begin
  Result := nil;
end;

procedure TdxGanttControlCustomView.StoredDeleteChild(const AObjectName: string; AObject: TObject);
begin
//
end;

{ TdxGanttControlViewSheetOptions }

function TdxGanttControlViewSheetOptions.AddExtendedAttributeColumn(
  const AFieldName: string): TdxGanttControlSheetColumn;
begin
  Result := TdxGanttControlViewSheetColumns(Columns).AddExtendedAttributeColumn(AFieldName);
end;

procedure TdxGanttControlViewSheetOptions.AddExtendedAttributeColumns(
  AType: TdxGanttControlExtendedAttributeCFType);
begin
  TdxGanttControlViewSheetColumns(Columns).AddExtendedAttributeColumns(AType);
end;

procedure TdxGanttControlViewSheetOptions.AddExtendedAttributeColumns;
var
  AType: TdxGanttControlExtendedAttributeCFType;
begin
  for AType := Low(TdxGanttControlExtendedAttributeCFType) to High(TdxGanttControlExtendedAttributeCFType) do
    AddExtendedAttributeColumns(AType);
end;

procedure TdxGanttControlViewSheetOptions.RetrieveMissingExtendedAttributeColumns;
begin
  TdxGanttControlViewSheetColumns(Columns).RetrieveMissingExtendedAttributeColumns;
end;

{ TdxGanttControlViewSheetController }

function TdxGanttControlViewSheetController.InitializeBuiltInPopupMenu(
  APopupMenu: TdxGanttControlPopupMenu; var P: TPoint): Boolean;
var
  AColumn: TdxGanttControlSheetColumn;
begin
  Result := Control.OptionsBehavior.UseBuiltInPopupMenus and ((HitTest.HitObject is TdxGanttControlSheetColumnHeaderViewInfo) or
    (HitTest.HitObject is TdxGanttControlSheetColumnEmptyHeaderViewInfo));
  if Result then
  begin
    if CaptureColumn <> nil then
      AColumn := CaptureColumn
    else if HitTest.HitObject is TdxGanttControlSheetColumnHeaderViewInfo then
      AColumn := TdxGanttControlSheetColumnHeaderViewInfo(HitTest.HitObject).Column
    else
      AColumn := nil;
    APopupMenu.AddCommand(TdxGanttControlViewSheetBestFitColumnCommand.Create(Self, AColumn));
    APopupMenu.AddCommand(TdxGanttControlViewSheetBestFitAllColumnsCommand.Create(Self, AColumn));
    APopupMenu.AddSeparator;
    APopupMenu.AddCommand(TdxGanttControlViewSheetRenameColumnCommand.Create(Self, AColumn));
    APopupMenu.AddCommand(TdxGanttControlViewSheetWordWrapCommand.Create(Self, AColumn));
    APopupMenu.AddSeparator;
    APopupMenu.AddCommand(TdxGanttControlViewSheetInsertColumnCommand.Create(Self, AColumn));
    APopupMenu.AddCommand(TdxGanttControlViewSheetHideColumnCommand.Create(Self, AColumn));
    APopupMenu.AddSeparator;
    APopupMenu.AddCommand(TdxGanttControlViewSheetShowChooseColumnDetailsDialogCommand.Create(Self, AColumn));
  end;
end;

end.
