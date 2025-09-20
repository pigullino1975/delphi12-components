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

unit dxChartControl;

{$I cxVer.inc}
{$SCOPEDENUMS ON}

interface

uses
  Messages, Windows, Classes, Graphics, SysUtils, Types, Controls, Forms, StdCtrls, Menus, Math,
  dxCore, dxCoreClasses, dxMessages, cxClasses, cxGraphics, cxControls, cxGeometry, dxTypeHelpers,
  cxCustomCanvas, dxSVGCanvas, dxGDIPlusClasses, cxLookAndFeels, cxLookAndFeelPainters, dxTouch,
  dxChartCore, dxChartSimpleDiagram, dxChartXYDiagram, dxChartLegend,
  dxSmartImage;

type
  TdxCustomChartControl = class;
  TdxChartControlController = class;
  TdxChartControlScrollBars = class;

  { TdxChartControlMainScrollbarsHelper }

  TdxChartControlMainScrollbarsHelper = class(TdxMainScrollbarsOwnerHelper) // for internal use
  strict private
    function GetOwner: TdxChartControlScrollBars;
  protected
    function GetControl: TcxControl; override;
    function GetHScrollBarBounds: TRect; override;
    function GetScrollBarLookAndFeel: TcxLookAndFeel; override;
    function GetScrollContentForegroundColor: TColor; override;
    function GetVScrollBarBounds: TRect; override;
    procedure InitScrollBarsParameters; override;
    function IsDataScrollbar(AKind: TScrollBarKind): Boolean; override;
    procedure Scroll(AScrollBarKind: TScrollBarKind; AScrollCode: TScrollCode; var AScrollPos: Integer); override;

    property Owner: TdxChartControlScrollBars read GetOwner;
  end;

  { TdxChartControlScrollBars }

  TdxChartControlScrollBars = class abstract(TcxIUnknownObject,
    IdxGestureClient,
    IdxGestureClient2,
    IdxTouchScrollUIOwner,
    IdxHybridScrollbarOwner) // for internal use
  strict private
    FController: TdxChartControlController;
    FHelper: TdxChartControlMainScrollBarsHelper;
    FScrollableElement: IdxChartHitTestScrollableElement;
  strict private
    procedure InternalScroll(AScrollBar: IcxControlScrollBar; ACode: TScrollCode);

    procedure ScrollableElementChangedHandler(ASender: TObject);

    function GetHScrollBar: IcxControlScrollBar;
    function GetVScrollBar: IcxControlScrollBar;
    procedure SetScrollInfo(AScrollBarKind: TScrollBarKind; const AData: TcxScrollBarData);
  protected
  {$REGION 'IdxGestureClient'}
    function AllowGesture(AGestureId: Integer): Boolean;
    function AllowPan(AScrollKind: TScrollBarKind): Boolean;
    procedure BeginGestureScroll(APos: TPoint);
    procedure EndGestureScroll;
    procedure GestureScroll(ADeltaX, ADeltaY: Integer);
    function GetPanOptions: Integer;
    function IsPanArea(const APoint: TPoint): Boolean;
    function NeedPanningFeedback(AScrollKind: TScrollBarKind): Boolean;
  {$ENDREGION}
  {$REGION 'IdxGestureClient2'}
    function UseRightToLeftScrollbar: Boolean;
  {$ENDREGION}
  {$REGION 'IdxTouchScrollUIOwner'}
    procedure CheckUIPosition;
    function GetOwnerControl: TcxControl;
    function HasVisibleUI: Boolean;
    procedure HideUI;
  {$ENDREGION}
  {$REGION 'IdxHybridScrollbarOwner'}
    function GetBaseColor: TColor;
    function GetManager: TdxHybridScrollbarsManager;
    procedure IdxHybridScrollbarOwner.Invalidate = InvalidateScrollBars;
    procedure InvalidateScrollBars;
  {$ENDREGION}
    procedure DoScrollContent(ADirection: TcxDirection);
    procedure DoShowTouchScrollUI;
    function GetHScrollBarBounds: TRect;
    function GetVScrollBarBounds: TRect;
    procedure HideTouchScrollUI(AImmediately: Boolean = False);
    procedure InitScrollBarsParameters;
    procedure Scroll(AScrollBarKind: TScrollBarKind; AScrollCode: TScrollCode; var AScrollPos: Integer);
    procedure ShowTouchScrollUI(const AScrollableElement: IdxChartHitTestScrollableElement);

    function MouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean;
    procedure ProcessHitElement(const AHitElement: IdxChartHitTestScrollableElement);
    procedure ProcessControlScrollingOnMiddleButton;

    property Controller: TdxChartControlController read FController;
    property HScrollBar: IcxControlScrollBar read GetHScrollBar;
    property Helper: TdxChartControlMainScrollBarsHelper read FHelper;
    property VScrollBar: IcxControlScrollBar read GetVScrollBar;
  public
    constructor Create(AController: TdxChartControlController); virtual;
    destructor Destroy; override;
  end;

  { TdxChartControlHintHelper }

  TdxChartControlHintHelper = class(TcxControlHintHelper) //for internal use
  strict private
    FControl: TdxCustomChartControl;
    FElement: IdxChartHitTestHintableElement;
  protected
    procedure CorrectHintWindowRect(var ARect: TRect); override;
    function GetOwnerControl: TcxControl; override;
  public
    constructor Create(AControl: TdxCustomChartControl); reintroduce;
    procedure ActivateHint(const AElement: IdxChartHitTestHintableElement); reintroduce;
    procedure CancelHint; override;
    procedure CorrectHintPositionIfNeeded;
    function IsHintVisible: Boolean;
    procedure ShowHintEx(const AElement: IdxChartHitTestHintableElement);
    procedure ShowOrActivateHint(const AElement: IdxChartHitTestHintableElement);
  end;

  { TdxChartHitTest }

  TdxChartHitTest = class
  strict private
    FHitArgument: Variant;
    FHitElement: IdxChartHitTestElement;
    FHitValue: Variant;
    FInPlotArea: Boolean;
    function GetAxis: TdxChartCustomAxis;
    function GetAxisValueLabel: TdxChartAxisValueLabelInfo;
    function GetDiagram: TdxChartCustomDiagram;
    function GetHitCode: TdxChartHitCode;
    function GetHitObject: TObject;
    function GetHitSubAreaCode: Integer;
    function GetLegend: TdxChartCustomLegend;
    function GetLegendItem: TdxChartLegendItem;
    function GetPoint: TPoint;
    function GetSeries: TdxChartCustomSeries;
    function GetSeriesPoint: TdxChartSeriesPointInfo;
    function GetSeriesValueLabel: TdxChartSeriesValueLabelInfo;
    function GetTitle: TdxChartVisualElementTitle;
    function GetTotalLabel: TdxChartSimpleSeriesTotalLabel;
  protected
    FPoint: TdxPointF;
    procedure Assign(const ASource: TdxChartHitTest);
    procedure Reset;
    procedure Update(const ASource: TdxChartHitTestEngine);

    property HitObject: TObject read GetHitObject;
    property HitElement: IdxChartHitTestElement read FHitElement write FHitElement;
    property HitSubAreaCode: Integer read GetHitSubAreaCode;
  public
    constructor Create;
    function Equals(Obj: TObject): Boolean; override;

    property Argument: Variant read FHitArgument;
    property Axis: TdxChartCustomAxis read GetAxis;
    property AxisValueLabel: TdxChartAxisValueLabelInfo read GetAxisValueLabel;
    property Diagram: TdxChartCustomDiagram read GetDiagram;
    property HitCode: TdxChartHitCode read GetHitCode;
    property InPlotArea: Boolean read FInPlotArea;
    property Legend: TdxChartCustomLegend read GetLegend;
    property LegendItem: TdxChartLegendItem read GetLegendItem;
    property Point: TPoint read GetPoint;
    property Series: TdxChartCustomSeries read GetSeries;
    property SeriesPoint: TdxChartSeriesPointInfo read GetSeriesPoint;
    property SeriesValueLabel: TdxChartSeriesValueLabelInfo read GetSeriesValueLabel;
    property Title: TdxChartVisualElementTitle read GetTitle;
    property TotalLabel: TdxChartSimpleSeriesTotalLabel read GetTotalLabel;
    property Value: Variant read FHitValue;
  end;

  { TdxChartControlController }

  TdxChartControlController = class(TInterfacedPersistent, IcxDesignSelectionChanged)  // for internal use
  strict private
    FActiveMouseActionExecutor: TdxChartMouseActionExecutor;
    FControl: TdxCustomChartControl;
    FCustomizationPopupMenuInvoker: TdxChartCustomDiagram;
    FHintHelper: TdxChartControlHintHelper;
    FHitTest: TdxChartHitTest;
    FHitTestEngine: TdxChartHitTestEngine;
    FHitPlotArea: IdxChartHitTestPlotAreaElement;
    FInternalPreviousHitTest: TdxChartHitTest;
    FMouseActionExecutors: array[TdxChart.TChartMouseActionKind] of TdxChartMouseActionExecutor;
    FPreviousHitTest: TdxChartHitTest;
    FScrollBars: TdxChartControlScrollBars;

    function GetChart: TdxChart; inline;
    procedure UpdateMouseCursor;

    procedure AddSeriesClickHandler(Sender: TObject);
    procedure AddXYDiagramClickHandler(Sender: TObject);
    procedure AddSimpleDiagramClickHandler(Sender: TObject);
    procedure DeleteDiagramClickHandler(Sender: TObject);
    procedure ShowDesignerClickHandler(Sender: TObject);
    procedure PopulateCustomizationPopupMenu(AMenu: TPopupMenu);
  protected
    function GetAppropriateMouseActionExecutor(AButton: TMouseButton; AShift: TShiftState): TdxChartMouseActionExecutor;

    // IcxDesignSelectionChanged
    procedure DesignSelectionChanged(ASelection: TList); virtual;
    procedure SelectObject(AObject: TObject);
    function IsObjectSelected(AObject: TObject): Boolean;

    procedure CalculateHitTest(X, Y: Integer; AForce: Boolean = True);
    function GetCurrentCursor(X, Y: Integer): TCursor;
    function GetDesignHitTest(X, Y: Integer; Shift: TShiftState): Boolean;
    procedure KeyDown(var Key: Word; Shift: TShiftState);
    procedure KeyUp(var Key: Word; Shift: TShiftState);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MouseLeave;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer);
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    function MouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean;
    procedure RaiseHotTrackElementEvent(AHitTest, APreviousHitTest: TdxChartHitTest);

    procedure CalculateDragAndDropInfo(Button: TMouseButton; Shift: TShiftState; X, Y: Integer;
      out AClass: TcxDragAndDropObjectClass; out ADiagram: TdxChartCustomDiagram);
    function StartDragAndDrop(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;

    property Control: TdxCustomChartControl read FControl;
    property Chart: TdxChart read GetChart;
    property HintHelper: TdxChartControlHintHelper read FHintHelper;
    property HitTest: TdxChartHitTest read FHitTest;
    property ScrollBars: TdxChartControlScrollBars read FScrollBars;
  public
    constructor Create(AControl: TdxCustomChartControl);
    destructor Destroy; override;
  end;

  { TdxChartHotTrackElementEventArgs }

  TdxChartHotTrackElementEventArgs = class(TdxEventArgs)
  strict private
    FHitTest: TdxChartHitTest;
    FPreviousHitTest: TdxChartHitTest;
    function GetElement: TObject;
    function GetPreviousElement: TObject;
  public
    constructor Create(AHitTest: TdxChartHitTest; APreviousHitTest: TdxChartHitTest);
    destructor Destroy; override;
    property Element: TObject read GetElement;
    property HitTest: TdxChartHitTest read FHitTest;
    property PreviousElement: TObject read GetPreviousElement;
    property PreviousHitTest: TdxChartHitTest read FPreviousHitTest;
  end;

  TdxChartHotTrackElementEvent = procedure(Sender: TObject; const AArgs: TdxChartHotTrackElementEventArgs) of object;

  { TdxCustomChartControl }

  TdxCustomChartControl = class(TcxControl, IdxSkinSupport, IdxChartOwner, IcxCustomCanvasSupport)
  strict private
    FChangingParentFont: Boolean;
    FChart: TdxChart;
    FController: TdxChartControlController;
    FOnChange: TNotifyEvent; 
    FOnChartChanged: TdxMulticastMethod<TNotifyEvent>;
    FOnHotTrackElement: TdxChartHotTrackElementEvent;
    FOnParentFontChanged: TNotifyEvent;
    FParentFontValue: TFont;
    function GetAppearance: TdxChartAppearance;
    function GetDiagramCount: Integer;
    function GetDiagram(AIndex: Integer): TdxChartCustomDiagram;
    function GetHitTest: TdxChartHitTest;
    function GetLegend: TdxChartLegend;
    function GetScrollOptions: TdxChartScrollOptions;
    function GetTitles: TdxChartTitles;
    function GetToolTips: TdxChartToolTips;
    function GetUseThreading: TdxDefaultBoolean;
    function GetVisibleDiagram(AIndex: Integer): TdxChartCustomDiagram;
    function GetVisibleDiagramCount: Integer;
    function GetZoomOptions: TdxChartZoomOptions;
    procedure SetAppearance(const AValue: TdxChartAppearance);
    procedure SetDiagram(AIndex: Integer; const AValue: TdxChartCustomDiagram);
    procedure SetLegend(const AValue: TdxChartLegend);
    procedure SetOnChange(AValue: TNotifyEvent);
    procedure SetScrollOptions(AValue: TdxChartScrollOptions);
    procedure SetTitles(const AValue: TdxChartTitles);
    procedure SetToolTips(const Value: TdxChartToolTips);
    procedure SetUseThreading(AValue: TdxDefaultBoolean);
    procedure SetZoomOptions(AValue: TdxChartZoomOptions);
  protected
    procedure ChartChangeHandler(Sender: TObject); virtual;
    function CreateController: TdxChartControlController; virtual;
    function CreateChart: TdxChart; virtual;
    procedure CreateSubClasses; virtual;
    procedure DestroySubClasses; virtual;

    // TcxControl
    function CreateActualCanvasCore(var ARenderMode: TdxRenderMode): TcxCustomCanvas; override;
    procedure DoContextPopup(MousePos: TPoint; var Handled: Boolean); override;
    procedure DoHotTrackElement(const AArgs: TdxChartHotTrackElementEventArgs); virtual;
    procedure DoPaint; override;
    function GetDefaultRenderMode: TdxRenderMode; override;

    // Notifications
    procedure BiDiModeChanged; override;
    procedure BoundsChanged; override;
    procedure ChangeScaleEx(M, D: Integer; isDpiChange: Boolean); override; 
    procedure CMParentFontChanged(var Message: TCMParentFontChanged); message CM_PARENTFONTCHANGED;

    // IdxChartOwner
    function GetOnParentFontChanged: TNotifyEvent;
    procedure SetOnParentFontChanged(AEventListener: TNotifyEvent);
    function GetIsParentFontUsed: Boolean;
    procedure SetIsParentFontUsed(AValue: Boolean);

    function GetChart: TdxChart;
    function GetParentFontValue: TFont;
    procedure InvalidateRect(const ARect: TdxRectF);

    // scroll
    function AllowTouchScrollUIMode: Boolean; override;
    function GetMainScrollBarsClass: TcxControlCustomScrollBarsClass; override;
    function GetScrollbarMode: TdxScrollbarMode; override;
    function GetTouchScrollUIOwner(const APoint: TPoint): IdxTouchScrollUIOwner; override;
    function NeedsScrollBars: Boolean; override;

    function GetDesignHitTest(X, Y: Integer; Shift: TShiftState): Boolean; override;

    // mouse
    function GetCurrentCursor(X, Y: Integer): TCursor; override;
    function InternalMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; override;
    function IsMouseWheelHandleNeeded(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer); override;
    procedure MouseLeave(AControl: TControl); override;
    procedure MouseMove(Shift: TShiftState; X: Integer; Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer); override;

    //keyboard
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;

    // internal drag and drop
    function CanStartDragAndDrop(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function StartDragAndDrop(const P: TPoint): Boolean; override;

    property Chart: TdxChart read FChart;
    property Controller: TdxChartControlController read FController;
    property OnChartChanged: TdxMulticastMethod<TNotifyEvent> read FOnChartChanged;
    property ScrollOptions: TdxChartScrollOptions read GetScrollOptions write SetScrollOptions;
    property ToolTips: TdxChartToolTips read GetToolTips write SetToolTips;
    property UseThreading: TdxDefaultBoolean read GetUseThreading write SetUseThreading default bDefault;
    property ZoomOptions: TdxChartZoomOptions read GetZoomOptions write SetZoomOptions;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function AddDiagram(ADiagramClass: TdxChartDiagramClass; const ACaption: string = ''): TdxChartCustomDiagram; overload;
    function AddDiagram<T: TdxChartCustomDiagram>(const ACaption: string = ''): T; overload;
    procedure Assign(Source: TPersistent); override;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure TranslationChanged; override;

    procedure BeginUpdate;
    procedure CancelUpdate;
    procedure EndUpdate;
    procedure LoadFromStream(AStream: TStream);
    procedure SaveToStream(AStream: TStream);
    procedure CalculateHitTest(X, Y: Integer);

    procedure ExportToImage(const AStream: TStream; ACodecClass: TdxSmartImageCodecClass = nil;
      AImageWidth: Integer = 0; AImageHeight: Integer = 0); overload;
    procedure ExportToImage(const AFileName: string; ACodecClass: TdxSmartImageCodecClass = nil;
      AImageWidth: Integer = 0; AImageHeight: Integer = 0); overload;
    procedure ExportToSVG(const AStream: TStream; AImageWidth: Integer = 0; AImageHeight: Integer = 0); overload;
    procedure ExportToSVG(const AFileName: string; AImageWidth: Integer = 0; AImageHeight: Integer = 0); overload;
    procedure ExportToBMP(const AStream: TStream; AImageWidth: Integer = 0; AImageHeight: Integer = 0); overload;
    procedure ExportToBMP(const AFileName: string; AImageWidth: Integer = 0; AImageHeight: Integer = 0); overload;
    procedure ExportToJPEG(const AStream: TStream; AImageWidth: Integer = 0; AImageHeight: Integer = 0); overload;
    procedure ExportToJPEG(const AFileName: string; AImageWidth: Integer = 0; AImageHeight: Integer = 0); overload;
    procedure ExportToPNG(const AStream: TStream; AImageWidth: Integer = 0; AImageHeight: Integer = 0); overload;
    procedure ExportToPNG(const AFileName: string; AImageWidth: Integer = 0; AImageHeight: Integer = 0); overload;
    procedure ExportToTIFF(const AStream: TStream; AImageWidth: Integer = 0; AImageHeight: Integer = 0); overload;
    procedure ExportToTIFF(const AFileName: string; AImageWidth: Integer = 0; AImageHeight: Integer = 0); overload;
    procedure ExportToGIF(const AStream: TStream; AImageWidth: Integer = 0; AImageHeight: Integer = 0); overload;
    procedure ExportToGIF(const AFileName: string; AImageWidth: Integer = 0; AImageHeight: Integer = 0); overload;
    procedure ExportToEMF(const AStream: TStream; AImageWidth: Integer = 0; AImageHeight: Integer = 0); overload;
    procedure ExportToEMF(const AFileName: string; AImageWidth: Integer = 0; AImageHeight: Integer = 0); overload;
    procedure ExportToWMF(const AStream: TStream; AImageWidth: Integer = 0; AImageHeight: Integer = 0); overload;
    procedure ExportToWMF(const AFileName: string; AImageWidth: Integer = 0; AImageHeight: Integer = 0); overload;

    procedure ExportToDOCX(const AStream: TStream; AImageWidth: Integer = 0; AImageHeight: Integer = 0); overload;
    procedure ExportToDOCX(const AFileName: string; AImageWidth: Integer = 0; AImageHeight: Integer = 0); overload;
    procedure ExportToXLSX(const AStream: TStream; AImageWidth: Integer = 0; AImageHeight: Integer = 0); overload;
    procedure ExportToXLSX(const AFileName: string; AImageWidth: Integer = 0; AImageHeight: Integer = 0); overload;

    property DiagramCount: Integer read GetDiagramCount;
    property Diagrams[AIndex: Integer]: TdxChartCustomDiagram read GetDiagram write SetDiagram; default;
    property HitTest: TdxChartHitTest read GetHitTest;
    property VisibleDiagramCount: Integer read GetVisibleDiagramCount;
    property VisibleDiagrams[AIndex: Integer]: TdxChartCustomDiagram read GetVisibleDiagram;

    property Appearance: TdxChartAppearance read GetAppearance write SetAppearance;
    property Legend: TdxChartLegend read GetLegend write SetLegend;
    property Titles: TdxChartTitles read GetTitles write SetTitles;
    property OnChange: TNotifyEvent read FOnChange write SetOnChange;
    property OnHotTrackElement: TdxChartHotTrackElementEvent read FOnHotTrackElement write FOnHotTrackElement;
  end;

  { TdxChartControl }

  TdxChartControl = class(TdxCustomChartControl)
  published
    property Align;
    property Anchors;
    property Appearance;
    property BiDiMode;
    property BorderStyle default cxcbsDefault;
    property Constraints;
    property Cursor;
    property HelpContext;
    property HelpKeyword;
    property HelpType;
    property Legend;
    property LookAndFeel;
    property ParentBiDiMode;
    property ParentFont default False;
    property PopupMenu;
    property ScrollOptions;
    property Titles;
    property ToolTips;
    property Visible;
    property ZoomOptions;

    property OnContextPopup;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnHotTrackElement;
    property OnMouseMove;
  end;

var
  dxChartShowDesignTimeDesigner: TProc<TdxCustomChartControl> = nil; // for internal use

implementation

uses
  RTLConsts, Variants,
  dxCustomHint, dxCoreGraphics, cxScrollBar, dxChartStrs, dxGdiplusCanvas, dxDPIAwareUtils;

const
  dxThisUnitName = 'dxChartControl';

type
  TcxScrollBarAccess = class(TcxScrollBar);
  TcxScrollBarHelperAccess = class(TcxScrollBarHelper);
  TcxScrollBarControllerAccess = class(TcxScrollBarController);
  TWinControlAccess = class(TWinControl);
  TdxChartAccess = class(TdxChart);
  TdxChartCustomDiagramAccess = class(TdxChartCustomDiagram);
  TdxChartXYDiagramAccess = class(TdxChartXYDiagram);
  TdxChartSeriesCustomViewAccess = class(TdxChartSeriesCustomView);
  TdxChartSeriesCustomViewAccessClass = class of TdxChartSeriesCustomViewAccess;
  TdxChartCustomAxisAccess = class(TdxChartCustomAxis);

  TdxChartHitTestHelper = class helper for TdxChartHitTest
    function Clone: TdxChartHitTest;
  end;

function dxModifierKeysToShiftState(AModifierKeys: TdxModifierKeys): TShiftState;
begin
  Result := [];
  if TdxModifierKey.Shift in AModifierKeys then
    Result := Result + [ssShift];
  if TdxModifierKey.Ctrl in AModifierKeys then
    Result := Result + [ssCtrl];
  if TdxModifierKey.Alt in AModifierKeys then
    Result := Result + [ssAlt];
end;

{ TdxChartControlMainScrollbarsHelper }

function TdxChartControlMainScrollbarsHelper.GetControl: TcxControl;
begin
  Result := Owner.Controller.Control;
end;

function TdxChartControlMainScrollbarsHelper.GetHScrollBarBounds: TRect;
begin
  Result := Owner.GetHScrollBarBounds;
end;

function TdxChartControlMainScrollbarsHelper.GetOwner: TdxChartControlScrollBars;
begin
  Result := TdxChartControlScrollBars(inherited Owner);
end;

function TdxChartControlMainScrollbarsHelper.GetScrollBarLookAndFeel: TcxLookAndFeel;
begin
  Result := Owner.Controller.Control.LookAndFeel;
end;

function TdxChartControlMainScrollbarsHelper.GetScrollContentForegroundColor: TColor;
begin
  Result := clWindowText;
end;

function TdxChartControlMainScrollbarsHelper.GetVScrollBarBounds: TRect;
begin
  Result := Owner.GetVScrollBarBounds;
end;

procedure TdxChartControlMainScrollbarsHelper.InitScrollBarsParameters;
begin
  Owner.InitScrollBarsParameters;
end;

function TdxChartControlMainScrollbarsHelper.IsDataScrollbar(
  AKind: TScrollBarKind): Boolean;
begin
  Result := False;
end;

procedure TdxChartControlMainScrollbarsHelper.Scroll(
  AScrollBarKind: TScrollBarKind; AScrollCode: TScrollCode;
  var AScrollPos: Integer);
begin
  Owner.Scroll(AScrollBarKind, AScrollCode, AScrollPos);
end;

{ TdxChartControlScrollBars }

constructor TdxChartControlScrollBars.Create(AController: TdxChartControlController);
begin
  inherited Create;
  FController := AController;
  FHelper := TdxChartControlMainScrollBarsHelper.Create(Self);
  FHelper.CreateScrollBars;
end;

destructor TdxChartControlScrollBars.Destroy;
begin
  TdxTouchScrollUIModeManager.Deactivate(Self);
  FHelper.DestroyScrollBars;
  FreeAndNil(FHelper);
  inherited Destroy;
end;

procedure TdxChartControlScrollBars.DoScrollContent(ADirection: TcxDirection);
const
  ACodeMap: array[TcxDirection] of TScrollCode = (scEndScroll, scLineUp, scLineDown, scLineUp, scLineDown);
var
  AScrollBar: IcxControlScrollBar;
begin
  if ADirection in [dirLeft, dirRight] then
    AScrollBar := HScrollBar
  else if ADirection in [dirUp, dirDown] then
    AScrollBar := VScrollBar
  else
    Exit;
  if (AScrollBar = nil) or not AScrollBar.Visible then
    Exit;
  InternalScroll(AScrollBar, ACodeMap[ADirection]);
end;

procedure TdxChartControlScrollBars.DoShowTouchScrollUI;
begin
  Helper.InitScrollBars;
  InitScrollBarsParameters;
  FHelper.UpdateScrollBars;
  FHelper.ShowTouchScrollUI(Self, False);
end;

function TdxChartControlScrollBars.MouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean;
const
  AScrollCodeMap: array[Boolean] of TScrollCode = (scLineUp, scLineDown);
  AScrollCodePageMap: array[Boolean] of TScrollCode = (scPageUp, scPageDown);

  function GetActiveScrollBar: IcxControlScrollBar;
  begin
    Result := nil;
    if not FHelper.IsScrollBarActive(sbHorizontal) then
      Exit(VScrollBar);
    if not FHelper.IsScrollBarActive(sbVertical) then
      Exit(HScrollBar);
    if Shift = [ssShift] then
      Result := HScrollBar
    else
      Result := VScrollBar;
  end;

var
  I: Integer;
  AScrollBar: IcxControlScrollBar;
begin
  Result := FScrollableElement <> nil;
  if not Result then
    Exit;
  DoShowTouchScrollUI;
  AScrollBar := GetActiveScrollBar;
  Result := AScrollBar <> nil;
  if not Result then
    Exit;
  if Mouse.WheelScrollLines = -1 then
    InternalScroll(AScrollBar, AScrollCodePageMap[WheelDelta < 0])
  else
    for I := 0 to Mouse.WheelScrollLines - 1 do
      InternalScroll(AScrollBar, AScrollCodeMap[WheelDelta < 0]);
end;

procedure TdxChartControlScrollBars.ProcessHitElement(const AHitElement: IdxChartHitTestScrollableElement);
begin
  if AHitElement <> nil then
    ShowTouchScrollUI(AHitElement)
  else
    HideTouchScrollUI(False);
end;

procedure TdxChartControlScrollBars.ProcessControlScrollingOnMiddleButton;
var
  AIsScrollingContent: Boolean;
begin
  cxProcessControlScrollingOnMiddleButton(Controller.Control, Helper.IsScrollBarActive(sbHorizontal),
    Helper.IsScrollBarActive(sbVertical), DoScrollContent, AIsScrollingContent);
end;

procedure TdxChartControlScrollBars.Scroll(AScrollBarKind: TScrollBarKind;
  AScrollCode: TScrollCode; var AScrollPos: Integer);
begin
  if FScrollableElement <> nil then
    FScrollableElement.Scroll(AScrollBarKind, AScrollCode, AScrollPos);
end;

procedure TdxChartControlScrollBars.SetScrollInfo(
  AScrollBarKind: TScrollBarKind; const AData: TcxScrollBarData);
begin
  FHelper.GetScrollBar(AScrollBarKind).Visible := AData.Visible;
  FHelper.SetScrollBarInfo(AScrollBarKind, AData.Min, AData.Max, AData.SmallChange, AData.LargeChange, AData.Position, AData.AllowShow, AData.AllowHide);
end;

procedure TdxChartControlScrollBars.ShowTouchScrollUI(const AScrollableElement: IdxChartHitTestScrollableElement);
begin
  if AScrollableElement = nil then
  begin
    HideTouchScrollUI;
    Exit;
  end;
  if (FScrollableElement = nil) or (FScrollableElement.GetChartElement <> AScrollableElement.GetChartElement) then
    HideTouchScrollUI(True);
  if FScrollableElement <> nil then
    FScrollableElement.RemoveChangedListener(ScrollableElementChangedHandler);
  FScrollableElement := AScrollableElement;
  DoShowTouchScrollUI;
  if FScrollableElement <> nil then
    FScrollableElement.AddChangedListener(ScrollableElementChangedHandler);
end;

function TdxChartControlScrollBars.GetHScrollBar: IcxControlScrollBar;
begin
  Result := FHelper.GetScrollBar(sbHorizontal);
end;

procedure TdxChartControlScrollBars.InternalScroll(AScrollBar: IcxControlScrollBar; ACode: TScrollCode);
begin
  TcxScrollBarControllerAccess(TcxScrollBarHelperAccess(TcxScrollBarAccess(AScrollBar.Control).Helper).Controller).SetPositionValue(ACode, AScrollBar.Position);
end;

procedure TdxChartControlScrollBars.ScrollableElementChangedHandler(ASender: TObject);
begin
  HideTouchScrollUI(True);
end;

function TdxChartControlScrollBars.GetVScrollBar: IcxControlScrollBar;
begin
  Result := FHelper.GetScrollBar(sbVertical);
end;

function TdxChartControlScrollBars.AllowGesture(AGestureId: Integer): Boolean;
begin
  Result := (GetInteractiveGestureByGestureID(AGestureId) in GetOwnerControl.Touch.InteractiveGestures);
end;

function TdxChartControlScrollBars.AllowPan(AScrollKind: TScrollBarKind): Boolean;
begin
  Result := Helper.IsScrollBarActive(AScrollKind);
end;

procedure TdxChartControlScrollBars.BeginGestureScroll(APos: TPoint);
begin
  FHelper.BeginGestureScroll(APos);
end;

procedure TdxChartControlScrollBars.EndGestureScroll;
begin
  FHelper.EndGestureScroll;
end;

procedure TdxChartControlScrollBars.GestureScroll(ADeltaX, ADeltaY: Integer);
var
  AScrollKind: TScrollBarKind;
begin
  for AScrollKind := Low(TScrollBarKind) to High(TScrollBarKind) do
    FHelper.ScrollBarBasedGestureScroll(AScrollKind, ADeltaX, ADeltaY);
end;

function TdxChartControlScrollBars.GetPanOptions: Integer;
begin
  Result := Controller.Control.GetPanOptions;
end;

function TdxChartControlScrollBars.IsPanArea(const APoint: TPoint): Boolean;
begin
  Result := (FScrollableElement <> nil) and FScrollableElement.IsPanArea(APoint);
end;

function TdxChartControlScrollBars.NeedPanningFeedback(AScrollKind: TScrollBarKind): Boolean;
var
  ASize: Integer;
begin
  Result := False;
  if HScrollBar <> nil then
  begin
    ASize := Helper.GetScrollBarSize.cy;
    if HScrollBar.Height <> ASize then
    begin
      HScrollBar.Height := ASize;
      Result := True;
    end;
  end;
  if VScrollBar <> nil then
  begin
    ASize := Helper.GetScrollBarSize.Width;
    if VScrollBar.Width <> ASize then
    begin
      VScrollBar.Width := ASize;
      Result := True;
    end;
  end;
  Helper.UpdateScrollBars;
end;

function TdxChartControlScrollBars.UseRightToLeftScrollbar: Boolean;
begin
  Result := GetOwnerControl.UseRightToLeftScrollBar;
end;

procedure TdxChartControlScrollBars.CheckUIPosition;
begin
  FHelper.UpdateScrollBars;
end;

function TdxChartControlScrollBars.GetOwnerControl: TcxControl;
begin
  Result := Controller.Control;
end;

function TdxChartControlScrollBars.HasVisibleUI: Boolean;
begin
  Result := FHelper.IsScrollBarVisible(sbVertical) or
    FHelper.IsScrollBarVisible(sbHorizontal);
end;

function TdxChartControlScrollBars.GetHScrollBarBounds: TRect;
var
  R: TRect;
begin
  R := FScrollableElement.GetScrollableArea;
  Result := R;
  Result.Top := Result.Bottom  -  Helper.GetScrollBarSize.cy;
  if FHelper.IsScrollBarVisible(sbVertical) then
    Result.Right := Result.Right - Helper.GetScrollBarSize.Width;
  if UseRightToLeftScrollbar then
    Result := TdxRightToLeftLayoutConverter.ConvertRect(Result, R);
end;

function TdxChartControlScrollBars.GetVScrollBarBounds: TRect;
var
  R: TRect;
begin
  R := FScrollableElement.GetScrollableArea;
  Result := R;
  Result.Left := Result.Right - Helper.GetScrollBarSize.Width;
  if FHelper.IsScrollBarVisible(sbHorizontal) then
    Result.Bottom := Result.Bottom - Helper.GetScrollBarSize.Height;
  if UseRightToLeftScrollbar then
    Result := TdxRightToLeftLayoutConverter.ConvertRect(Result, R);
end;

procedure TdxChartControlScrollBars.HideTouchScrollUI(AImmediately: Boolean);
begin
  if FScrollableElement = nil then
    Exit;
  Helper.HideTouchScrollUI(Self, AImmediately);
end;

procedure TdxChartControlScrollBars.InitScrollBarsParameters;

  procedure InternalSetScrollInfo(AScrollBarKind: TScrollBarKind);
  var
    AData: TcxScrollBarData;
  begin
    if AScrollBarKind = sbHorizontal then
      AData := FScrollableElement.GetHorizontalScrollBarData
    else
      AData := FScrollableElement.GetVerticalScrollBarData;
    try
      SetScrollInfo(AScrollBarKind, AData);
    finally
      AData.Free;
    end;
  end;

begin
  if FScrollableElement = nil then
    Exit;
  if not FScrollableElement.IsValid then
    HideTouchScrollUI(True)
  else
  begin
    InternalSetScrollInfo(sbHorizontal);
    InternalSetScrollInfo(sbVertical);
  end;
end;

procedure TdxChartControlScrollBars.HideUI;
begin
  if FScrollableElement <> nil then
    FScrollableElement.RemoveChangedListener(ScrollableElementChangedHandler);
  FScrollableElement := nil;
  FHelper.HideTouchScrollUIDirectly;
end;

function TdxChartControlScrollBars.GetBaseColor: TColor;
begin
  Result := FHelper.GetHybridScrollbarBaseColor;
end;

function TdxChartControlScrollBars.GetManager: TdxHybridScrollbarsManager;
begin
  Result := FHelper.GetHybridScrollBarsManager;
end;

procedure TdxChartControlScrollBars.InvalidateScrollBars;
begin
  FHelper.MainScrollBars.Invalidate;
end;


{ TdxChartControlHintHelper }

constructor TdxChartControlHintHelper.Create(AControl: TdxCustomChartControl);
begin
  inherited Create;
  FControl := AControl;
end;

procedure TdxChartControlHintHelper.ActivateHint(const AElement: IdxChartHitTestHintableElement);
var
  AHintableObject: IcxHintableObject2;
begin
  if AElement = nil then
    Exit;
  HideHint;
  FElement := nil;
  if not AElement.CanShowHint then
    Exit;
  AHintableObject := AElement.GetHintableObject;
  if (AHintableObject = nil) or (AHintableObject.GetHintText = '') then
    Exit;
  FElement := AElement;
  HintShowPause := Application.HintPause;
  inherited ActivateHint(AHintableObject);
end;

procedure TdxChartControlHintHelper.CancelHint;
begin
  inherited CancelHint;
  FElement := nil;
end;

procedure TdxChartControlHintHelper.CorrectHintPositionIfNeeded;
var
  AHintedElement: IdxChartHitTestHintableElement;
begin
  if (FElement <> nil) and (FElement.GetHintableObject <> nil) and FElement.GetHintableObject.IsHintAtMousePos then
    if (HintWindow <> nil) and IsWindowVisible(HintWindow.Handle) then
      ShowHintEx(FElement)
    else
    begin
      AHintedElement := FElement;
      CancelHint;
      ActivateHint(AHintedElement);
    end;
end;

procedure TdxChartControlHintHelper.CorrectHintWindowRect(var ARect: TRect);

  function GetCursorSize: TSize;
  var
    AControlDPI: Integer;
    APrimaryMonitorDPI: Integer;
  begin
    Result := cxGetCursorSize;
    AControlDPI := (FControl as IdxScaleFactor).Value.Apply(dxDefaultDPI);
    APrimaryMonitorDPI := dxGetMonitorDPI(Screen.PrimaryMonitor);
    Result.cx := MulDiv(Result.cx, AControlDPI, APrimaryMonitorDPI);
    Result.cy := MulDiv(Result.cy, AControlDPI, APrimaryMonitorDPI);
  end;

var
  AMousePos: TPoint;
  ACursorSize: TSize;
begin
  inherited CorrectHintWindowRect(ARect);
  if (FElement <> nil) and (FElement.GetHintableObject <> nil) and FElement.GetHintableObject.IsHintAtMousePos and GetCursorPos(AMousePos) then
  begin
    ACursorSize := GetCursorSize;
    if FControl.UseRightToLeftAlignment then
    begin
      ARect := cxRectSetTop(ARect, AMousePos.Y + ACursorSize.cy);
      ARect := cxRectSetRight(ARect, AMousePos.X + ACursorSize.cx);
    end
    else
      ARect := cxRectSetOrigin(ARect, Point(AMousePos.X, AMousePos.Y + ACursorSize.cy));
  end;
end;

function TdxChartControlHintHelper.GetOwnerControl: TcxControl;
begin
  Result := FControl;
end;

function TdxChartControlHintHelper.IsHintVisible: Boolean;
begin
  Result := (HintWindow <> nil) and IsWindowVisible(HintWindow.Handle);
end;

procedure TdxChartControlHintHelper.ShowHintEx(
  const AElement: IdxChartHitTestHintableElement);
var
  AHintAreaBounds, ATextRect: TRect;
  AText: string;
  AIsHintMultiLine: Boolean;
  AObject: IcxHintableObject2;
  AMousePos: TPoint;
begin
  if AElement = nil then
    Exit;
  FElement := nil;
  AObject := AElement.GetHintableObject;
  if not AElement.CanShowHint or (AObject = nil) then
  begin
    HideHint;
    Exit;
  end;
  AText := AObject.GetHintText;
  if AText = '' then
  begin
    HideHint;
    Exit;
  end;
  ATextRect := AObject.GetHintTextBounds;
  if AObject.IsHintAtMousePos and GetCursorPos(AMousePos) then
    ATextRect := cxRectSetOrigin(ATextRect, AMousePos);
  AIsHintMultiLine := AObject.IsHintMultiLine;
  AHintAreaBounds := AObject.GetHintAreaBounds;
  FElement := AElement;
  ShowHint(AHintAreaBounds, ATextRect, AText, AIsHintMultiLine, TObject(AObject), AObject.GetHintFont);
end;

procedure TdxChartControlHintHelper.ShowOrActivateHint(const AElement: IdxChartHitTestHintableElement);
var
  AHintableObject: IcxHintableObject2;
begin
  if AElement = nil then
    Exit;
  AHintableObject := AElement.GetHintableObject;
  if AHintableObject = nil then
    Exit;

  if AHintableObject.ImmediateShowHint then
    ShowHintEx(AElement)
  else
    ActivateHint(AElement);
end;

{ TdxChartHitTest }

constructor TdxChartHitTest.Create;
begin
  inherited Create;
  Reset;
end;

function TdxChartHitTest.Equals(Obj: TObject): Boolean;
var
  AComparedHitTest: TdxChartHitTest;
  AHitObject: TObject;
begin
  if Obj is TdxChartHitTest then
  begin
    AComparedHitTest := TdxChartHitTest(Obj);
    AHitObject := HitObject;
    if AHitObject = nil then
      Result := AComparedHitTest.HitObject = nil
    else
      Result := (HitCode = AComparedHitTest.HitCode) and AHitObject.Equals(AComparedHitTest.HitObject);
  end
  else
    Result := False;
end;

procedure TdxChartHitTest.Assign(const ASource: TdxChartHitTest);
begin
  HitElement := ASource.HitElement;
  FPoint := ASource.Point;
  FHitArgument := ASource.FHitArgument;
  FHitValue := ASource.FHitValue;
end;

procedure TdxChartHitTest.Reset;
begin
  HitElement := nil;
  FPoint := cxInvalidPoint;
end;

procedure TdxChartHitTest.Update(const ASource: TdxChartHitTestEngine);
begin
  FHitElement := ASource.HitElement;
  FPoint := ASource.Point;
  FInPlotArea := ASource.HitPlotArea <> nil;
  if ASource.HitPlotArea = nil then
  begin
    FHitArgument := Unassigned;
    FHitValue := Unassigned;
  end
  else
    ASource.HitPlotArea.GetDataPointFromCanvasPoint(ASource.Point, FHitArgument, FHitValue);
end;

function TdxChartHitTest.GetAxis: TdxChartCustomAxis;
begin
  case HitCode of
    TdxChartHitCode.Axis:
      begin
        Result := TdxChartCustomAxis(HitObject)
      end;
    TdxChartHitCode.AxisValueLabel:
      Result := AxisValueLabel.Axis;
    TdxChartHitCode.AxisTitle:
      begin
        Result := TdxChartAxisTitle(HitObject).Axis;
      end;
  else
    Result := nil;
  end;
end;

function TdxChartHitTest.GetAxisValueLabel: TdxChartAxisValueLabelInfo;
begin
  if HitCode = TdxChartHitCode.AxisValueLabel then
    Result := TdxChartAxisValueLabelInfo(HitObject)
  else
    Result := nil;
end;

function TdxChartHitTest.GetDiagram: TdxChartCustomDiagram;
begin
  case HitCode of
    TdxChartHitCode.Diagram, TdxChartHitCode.PlotArea:
      Result := TdxChartCustomDiagram(HitObject);
    TdxChartHitCode.Series:
      Result := Series.Diagram;
    TdxChartHitCode.SeriesPoint:
      Result := SeriesPoint.Series.Diagram;
    TdxChartHitCode.SeriesValueLabel:
      Result := SeriesValueLabel.SeriesPoint.Series.Diagram;
    TdxChartHitCode.Axis, TdxChartHitCode.AxisTitle, TdxChartHitCode.AxisValueLabel:
      Result := Axis.Diagram;
    TdxChartHitCode.DiagramTitle:
      Result := TdxChartDiagramTitle(HitObject).Diagram;
    TdxChartHitCode.LegendTitle, TdxChartHitCode.Legend, TdxChartHitCode.LegendItem:
       if Legend is TdxChartDiagramLegend then
         Result := TdxChartDiagramLegend(Legend).Diagram
       else
         Result := nil;
    TdxChartHitCode.TotalLabel:
      Result := TotalLabel.View.Series.Diagram;
    TdxChartHitCode.SeriesTitle:
      Result := TdxChartSeriesTitle(HitObject).Series.Diagram;
  else
    Result := nil;
  end;
end;

function TdxChartHitTest.GetHitCode: TdxChartHitCode;
begin
  if HitObject = nil then
    Result := TdxChartHitCode.None
  else
    Result := FHitElement.GetHitCode;
end;

function TdxChartHitTest.GetHitObject: TObject;
begin
  if FHitElement = nil then
    Result := nil
  else
    Result := FHitElement.GetChartElement;
end;

function TdxChartHitTest.GetHitSubAreaCode: Integer;
begin
  if FHitElement = nil then
    Result := 0
  else
    Result := FHitElement.GetSubAreaCode;
end;

function TdxChartHitTest.GetLegend: TdxChartCustomLegend;
begin
  case HitCode of
    TdxChartHitCode.LegendTitle:
      begin
        Result := TdxChartLegendTitle(HitObject).Legend;
      end;
    TdxChartHitCode.Legend:
      begin
        Result := TdxChartCustomLegend(HitObject);
      end;
    TdxChartHitCode.LegendItem:
      begin
        Result := TdxChartLegendItem(HitObject).Legend;
      end;
  else
    Result := nil;
  end;
end;

function TdxChartHitTest.GetLegendItem: TdxChartLegendItem;
begin
  if HitCode = TdxChartHitCode.LegendItem then
    Result := TdxChartLegendItem(HitObject)
  else
    Result := nil;
end;

function TdxChartHitTest.GetPoint: TPoint;
begin
  Result := FPoint;
end;

function TdxChartHitTest.GetSeries: TdxChartCustomSeries;
begin
  case HitCode of
    TdxChartHitCode.Series:
      begin
        Result := TdxChartCustomSeries(HitObject)
      end;
    TdxChartHitCode.SeriesPoint:
      Result := SeriesPoint.Series;
    TdxChartHitCode.SeriesValueLabel:
      Result := SeriesValueLabel.SeriesPoint.Series;
    TdxChartHitCode.TotalLabel:
      Result := TotalLabel.View.Series;
    TdxChartHitCode.SeriesTitle:
      Result := TdxChartSeriesTitle(HitObject).Series;
  else
    Result := nil;
  end;
end;

function TdxChartHitTest.GetSeriesPoint: TdxChartSeriesPointInfo;
begin
  case HitCode of
    TdxChartHitCode.SeriesPoint:
      Result := TdxChartSeriesPointInfo(HitObject);
    TdxChartHitCode.SeriesValueLabel:
      Result := SeriesValueLabel.SeriesPoint
  else
    Result := nil
  end;
end;

function TdxChartHitTest.GetSeriesValueLabel: TdxChartSeriesValueLabelInfo;
begin
  if HitCode = TdxChartHitCode.SeriesValueLabel then
    Result := TdxChartSeriesValueLabelInfo(HitObject)
  else
    Result := nil;
end;

function TdxChartHitTest.GetTitle: TdxChartVisualElementTitle;
var
  AHitObject: TObject;
begin
  AHitObject := HitObject;
  if (AHitObject is TdxChartVisualElementTitle) and (HitCode <> TdxChartHitCode.TotalLabel) then
    Result := TdxChartVisualElementTitle(AHitObject)
  else
    Result := nil;
end;

function TdxChartHitTest.GetTotalLabel: TdxChartSimpleSeriesTotalLabel;
begin
  if HitCode = TdxChartHitCode.TotalLabel then
    Result := TdxChartSimpleSeriesTotalLabel(HitObject)
  else
    Result := nil;
end;

{ TdxChartControlController }

constructor TdxChartControlController.Create(AControl: TdxCustomChartControl);
var
  AExecutorClasses: TdxChartMouseActionExecutorClassArray;
  I: TdxChart.TChartMouseActionKind;
begin
  inherited Create;
  FControl := AControl;
  FHintHelper := TdxChartControlHintHelper.Create(Control);
  FHitTestEngine := TdxChartHitTestEngine.Create(Chart);
  FHitTest := TdxChartHitTest.Create;
  FPreviousHitTest := TdxChartHitTest.Create;
  FInternalPreviousHitTest := TdxChartHitTest.Create;
  FScrollBars := TdxChartControlScrollBars.Create(Self);
  if Assigned(cxDesignHelper) then
    cxDesignHelper.AddSelectionChangedListener(Self);
  AExecutorClasses := TdxChartXYDiagramAccess.GetMouseActionExecutorClasses;
  for I := Low(TdxChart.TChartMouseActionKind) to High(TdxChart.TChartMouseActionKind) do begin
    FMouseActionExecutors[I] := AExecutorClasses[I].Create;
  end;
end;

destructor TdxChartControlController.Destroy;
var
  AKind: TdxChart.TChartMouseActionKind;
begin
  for AKind := Low(FMouseActionExecutors) to High(FMouseActionExecutors) do
    FreeAndNil(FMouseActionExecutors[AKind]);
  if Assigned(cxDesignHelper) then
    cxDesignHelper.RemoveSelectionChangedListener(Self);
  FreeAndNil(FScrollBars);
  FreeAndNil(FHitTest);
  FreeAndNil(FInternalPreviousHitTest);
  FreeAndNil(FPreviousHitTest);
  FreeAndNil(FHitTestEngine);
  FreeAndNil(FHintHelper);
  inherited Destroy;
end;

function TdxChartControlController.GetAppropriateMouseActionExecutor(AButton: TMouseButton; AShift: TShiftState): TdxChartMouseActionExecutor;
var
  AKind: TdxChart.TChartMouseActionKind;
  AChart: TdxChartAccess;
begin
  Result := nil;
  AChart := TdxChartAccess(Chart);
  for AKind := Low(TdxChart.TChartMouseActionKind) to High(TdxChart.TChartMouseActionKind) do
  begin
    if AChart.GetMouseAction(AKind).Enabled
      and (AChart.GetMouseAction(AKind).MouseButton = AButton)
      and (dxModifierKeysToShiftState(AChart.GetMouseAction(AKind).ModifierKeys) = AShift * [ssShift, ssCtrl, ssAlt]) then
    begin
      Result := FMouseActionExecutors[AKind];
      Break;
    end;
  end;
end;

procedure TdxChartControlController.DesignSelectionChanged(ASelection: TList);
begin
  Control.Invalidate;
end;

procedure TdxChartControlController.SelectObject(AObject: TObject);
begin
  if Assigned(cxDesignHelper) and (AObject is TPersistent) then
    cxDesignHelper.SelectObject(Control, TPersistent(AObject));
end;

procedure TdxChartControlController.ShowDesignerClickHandler(Sender: TObject);
begin
  dxChartShowDesignTimeDesigner(FCustomizationPopupMenuInvoker.GetParentComponent as TdxCustomChartControl);
end;

function TdxChartControlController.StartDragAndDrop(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  AClass: TcxDragAndDropObjectClass;
  ADiagram: TdxChartCustomDiagram;
begin
  CalculateDragAndDropInfo(Button, Shift, X, Y, AClass, ADiagram);
  Result := AClass <> nil;
  if Result then
  begin
    HintHelper.CancelHint;
    if FHitPlotArea <> nil then
      FHitPlotArea.MouseLeave;
    FHitPlotArea := nil;
    Control.DragAndDropObjectClass := AClass;
    (Control.DragAndDropObject as TdxChartDragAndDropObjectBase).Init(ADiagram, Point(X, Y));
  end;
end;

procedure TdxChartControlController.CalculateDragAndDropInfo(
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer; out AClass: TcxDragAndDropObjectClass;
  out ADiagram: TdxChartCustomDiagram);
var
  AMouseActionExecutor: TdxChartMouseActionExecutor;
begin
  AClass := nil;
  ADiagram := nil;
  if FActiveMouseActionExecutor <> nil then
    Exit;
  if csDesigning in Control.ComponentState then
    Exit;
  AMouseActionExecutor := GetAppropriateMouseActionExecutor(Button, Shift);
  if AMouseActionExecutor = nil then
    Exit;
  CalculateHitTest(X, Y);
  if HitTest.InPlotArea then
  begin
    if AMouseActionExecutor.IsAvailableFor(HitTest.Diagram) then
    begin
      AClass := AMouseActionExecutor.GetDragAndDropObjectClass;
      ADiagram := HitTest.Diagram;
    end;
  end;
end;

function TdxChartControlController.IsObjectSelected(AObject: TObject): Boolean;
begin
  Result := Assigned(cxDesignHelper) and cxDesignHelper.IsObjectSelected(Control, TPersistent(AObject));
end;

procedure TdxChartControlController.CalculateHitTest(X, Y: Integer; AForce: Boolean = True);
begin
  FHitTestEngine.Calculate(TdxPointF.Create(X, Y), AForce);
  HitTest.Update(FHitTestEngine);
end;

function TdxChartControlController.GetCurrentCursor(X, Y: Integer): TCursor;

  function GetModifierKeysState: TShiftState;
  begin
    Result := [];
    if GetKeyState(VK_CONTROL) < 0 then
      Result := Result + [ssCtrl];
    if GetKeyState(VK_MENU) < 0 then
      Result := Result + [ssAlt];
    if GetKeyState(VK_SHIFT) < 0 then
      Result := Result + [ssShift];
  end;

var
  AActionExecutor: TdxChartMouseActionExecutor;
begin
  Result := crDefault;
  if (csDesigning in Control.ComponentState) then
    Exit;
  CalculateHitTest(X, Y);
  if HitTest.InPlotArea then
  begin
    AActionExecutor := GetAppropriateMouseActionExecutor(mbLeft, GetModifierKeysState);
    if (AActionExecutor <> nil) and AActionExecutor.IsAvailableFor(HitTest.Diagram) then
      Result := AActionExecutor.GetDefaultMouseCursor;
  end;
end;

function TdxChartControlController.GetDesignHitTest(X, Y: Integer; Shift: TShiftState): Boolean;
begin
  CalculateHitTest(X, Y);
  if Control.MouseRightButtonReleased then
  begin
    Result := HitTest.Diagram <> nil;
    if not Result and not IsObjectSelected(Control) then
      SelectObject(Control);
  end
  else
    Result := ([ssLeft, ssDouble] * Shift = []) and (HitTest.HitCode <> TdxChartHitCode.None); 
end;

procedure TdxChartControlController.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if csDesigning in Control.ComponentState then
    Exit;

  if (Key = VK_SHIFT) or (Key = VK_CONTROL) or (Key = VK_MENU) then
    UpdateMouseCursor;
end;

procedure TdxChartControlController.KeyUp(var Key: Word; Shift: TShiftState);
begin
  if csDesigning in Control.ComponentState then
    Exit;

  if (Key = VK_SHIFT) or (Key = VK_CONTROL) or (Key = VK_MENU) then
    UpdateMouseCursor;
end;

procedure TdxChartControlController.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  AElement: IdxChartHitTestClickableElement;
begin

  CalculateHitTest(X, Y);
  HintHelper.MouseDown;
  if csDesigning in Control.ComponentState then
  begin
    if (HitTest.HitCode <> TdxChartHitCode.None) then
      SelectObject(HitTest.HitObject)
    else
      SelectObject(Control);
  end
  else
  begin
    if Button = mbMiddle then
      ScrollBars.ProcessControlScrollingOnMiddleButton;
    if Supports(FHitTestEngine.HitElement, IdxChartHitTestClickableElement, AElement) then
      AElement.MouseDown(Button, Shift, X, Y);
  end;
end;

procedure TdxChartControlController.MouseLeave;
var
  APreviousHitTest: TdxChartHitTest;
begin
  FHitTestEngine.Reset;
  HitTest.Update(FHitTestEngine);

  if FHitPlotArea <> nil then
    FHitPlotArea.MouseLeave;
  FHitPlotArea := nil;

  if not HitTest.Equals(FPreviousHitTest) then
  begin
    APreviousHitTest := FPreviousHitTest.Clone;
    FPreviousHitTest.Assign(HitTest);
    RaiseHotTrackElementEvent(HitTest.Clone, APreviousHitTest);
  end;
end;

procedure TdxChartControlController.MouseMove(Shift: TShiftState; X, Y: Integer);

  function GetSuitableToolTipMode(AToolTip: IdxChartHitTestElementWithToolTip; out AMode: TdxChartSimpleToolTipMode): Boolean;
  var
    ADiagram: IdxChartDiagram;
  begin
    Result := False;
    if AToolTip.HintedSeries = nil then
      Exit;
    ADiagram := AToolTip.HintedSeries.Diagram;
    if ADiagram = nil then
      Exit;
    if ADiagram.GetActualToolTipMode <> TdxChartToolTipMode.Simple then
      Exit;
    if Chart.ToolTips.SimpleToolTipOptions.ShowForPoints and AToolTip.IsModeSupported(TdxChartSimpleToolTipMode.Point) then
    begin
      Result := True;
      AMode := TdxChartSimpleToolTipMode.Point;
    end
    else if Chart.ToolTips.SimpleToolTipOptions.ShowForSeries and AToolTip.IsModeSupported(TdxChartSimpleToolTipMode.Series) then
    begin
      Result := True;
      AMode := TdxChartSimpleToolTipMode.Series;
    end;
  end;

var
  AHintableElement: IdxChartHitTestHintableElement;
  AElementWithToolTip: IdxChartHitTestElementWithToolTip;
  AToolTipMode: TdxChartSimpleToolTipMode;
  APreviousHitTest: TdxChartHitTest;
  AWasHintShown: Boolean;
begin
  if csDesigning in Control.ComponentState then
    Exit;
  if Control.DragAndDropState = ddsInProcess then begin
    CalculateHitTest(X, Y, False);
    ScrollBars.ProcessHitElement(FHitTestEngine.HitScrollableElement);
  end
  else
  begin
    CalculateHitTest(X, Y, True);
    ScrollBars.ProcessHitElement(FHitTestEngine.HitScrollableElement);
    if not HitTest.Equals(FInternalPreviousHitTest) or (HitTest.HitSubAreaCode <> FInternalPreviousHitTest.HitSubAreaCode) then
    begin
      AWasHintShown := HintHelper.IsHintVisible;
      HintHelper.CancelHint;
      if Supports(FHitTestEngine.HitElement, IdxChartHitTestElementWithToolTip, AElementWithToolTip) then
      begin
        if GetSuitableToolTipMode(AElementWithToolTip, AToolTipMode) then
        begin
          AElementWithToolTip.Mode := AToolTipMode;
          if AWasHintShown or not Chart.ToolTips.SimpleToolTipOptions.UseHintPause then
            HintHelper.ShowHintEx(AElementWithToolTip)
          else
            HintHelper.ShowOrActivateHint(AElementWithToolTip);
        end;
      end
      else if Supports(FHitTestEngine.HitElement, IdxChartHitTestHintableElement, AHintableElement) then
        HintHelper.ShowOrActivateHint(AHintableElement);
      FInternalPreviousHitTest.Assign(HitTest);
    end
    else
      HintHelper.CorrectHintPositionIfNeeded;

    if Control.DragAndDropState = ddsNone then
    begin
      if (FHitPlotArea <> nil) and ((FHitTestEngine.HitPlotArea = nil) or (FHitTestEngine.HitPlotArea.GetPlotArea <> FHitPlotArea.GetPlotArea)) then
        FHitPlotArea.MouseLeave;
      FHitPlotArea := FHitTestEngine.HitPlotArea;
      if FHitPlotArea <> nil then
        FHitPlotArea.MouseMove(Shift, X, Y);
    end;

    if not HitTest.Equals(FPreviousHitTest) then
    begin
      APreviousHitTest := FPreviousHitTest.Clone;
      FPreviousHitTest.Assign(HitTest);
      RaiseHotTrackElementEvent(HitTest.Clone, APreviousHitTest);
    end;
  end;
end;

procedure TdxChartControlController.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

  procedure ShowDiagramPopupMenu(ADiagram: TdxChartCustomDiagram);
  var
    AMenu: TPopupMenu;
    AIDEForm: TCustomForm;
  begin
    AIDEForm := GetParentForm(Control, True);
    AMenu := TPopupMenu.Create(AIDEForm);
    FCustomizationPopupMenuInvoker := ADiagram;
    try
      AMenu.Images := TdxChartSeriesCustomView.GetViewImages(dxGetTargetDPI(AIDEForm));
      PopulateCustomizationPopupMenu(AMenu);
      if AMenu.Items.Count > 0 then
      begin
        with GetMouseCursorPos do
          AMenu.Popup(X, Y);
        Application.ProcessMessages;
      end;
    finally
      FCustomizationPopupMenuInvoker := nil;
      AMenu.Free;
    end;
  end;

var
  AElement: IdxChartHitTestClickableElement;
  AActionExecutor: TdxChartMouseActionExecutor;
  ADiagram: TdxChartCustomDiagram;
begin
  CalculateHitTest(X, Y);
  if HitTest.HitCode = TdxChartHitCode.None then
    Exit;

  if (csDesigning in Control.ComponentState) then
  begin
    if Control.MouseRightButtonReleased and (HitTest.Diagram <> nil) then
      ShowDiagramPopupMenu(HitTest.Diagram);
  end
  else
  begin
    if Supports(FHitTestEngine.HitElement, IdxChartHitTestClickableElement, AElement) then
      AElement.MouseUp(Button, Shift, X, Y)
    else if HitTest.InPlotArea then
    begin
      ADiagram := HitTest.Diagram;
      AActionExecutor := GetAppropriateMouseActionExecutor(Button, Shift);
      if (AActionExecutor <> nil) and AActionExecutor.IsAvailableFor(ADiagram) then
        AActionExecutor.MouseUp(ADiagram, X, Y);
    end;
  end;
end;

function TdxChartControlController.MouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean;
var
  AAction: TdxChartMouseWheelAction;
  AHitDiagram : TdxChartXYDiagramAccess;
  ClientPos: TPoint;
begin
  Result := False;
  AAction := Chart.ZoomOptions.ZoomMouseWheelAction;
  if AAction.Enabled and (dxModifierKeysToShiftState(AAction.ModifierKeys) = Shift * [ssCtrl, ssAlt, ssShift]) then
  begin
    ClientPos := Control.ScreenToClient(MousePos);
    CalculateHitTest(ClientPos.X, ClientPos.Y);
    if HitTest.InPlotArea then
    begin
      AHitDiagram := TdxChartXYDiagramAccess(HitTest.Diagram);
      AHitDiagram.ZoomByMouseWheel(WheelDelta, ClientPos, True, True);
    end
    else if HitTest.Axis <> nil then
    begin
      if HitTest.Axis is TdxChartAxisX then
      begin
        AHitDiagram := TdxChartXYDiagramAccess(HitTest.Diagram);
        AHitDiagram.ZoomByMouseWheel(WheelDelta, ClientPos, True, False);
      end
      else if HitTest.Axis is TdxChartAxisY then
      begin
        AHitDiagram := TdxChartXYDiagramAccess(HitTest.Diagram);
        AHitDiagram.ZoomByMouseWheel(WheelDelta, ClientPos, False, True);
      end;
    end;
    Exit(True);
  end;

  AAction := Chart.ScrollOptions.ScrollMouseWheelAction;
  if AAction.Enabled and (dxModifierKeysToShiftState(AAction.ModifierKeys) - [ssShift] = Shift * [ssCtrl, ssAlt]) then
  begin
    Result := ScrollBars.MouseWheel(Shift, WheelDelta, MousePos);
  end;
end;

procedure TdxChartControlController.RaiseHotTrackElementEvent(AHitTest, APreviousHitTest: TdxChartHitTest);
var
  AArgs: TdxChartHotTrackElementEventArgs;
begin
  AArgs := TdxChartHotTrackElementEventArgs.Create(AHitTest, APreviousHitTest);
  try
    FControl.DoHotTrackElement(AArgs);
  finally
    FreeAndNil(AArgs);
  end;
end;


function TdxChartControlController.GetChart: TdxChart;
begin
  Result := Control.Chart;
end;

procedure TdxChartControlController.UpdateMouseCursor;
var
  AMousePos: TPoint;
  ACursor: TCursor;
begin
  AMousePos := Control.ScreenToClient(Mouse.CursorPos);
  ACursor := GetCurrentCursor(AMousePos.X, AMousePos.Y);
  if ACursor = crDefault then
    SetCursor(Screen.Cursors[Control.Cursor])
  else
    SetCursor(Screen.Cursors[ACursor]);
end;

procedure TdxChartControlController.AddSeriesClickHandler(Sender: TObject);
var
  ASeries: TdxChartCustomSeries;
begin
  ASeries := TdxChartCustomDiagramAccess(FCustomizationPopupMenuInvoker).AddSeries;
  ASeries.ViewClass := TdxChartSeriesViewClass((Sender as TComponent).Tag);
  if Assigned(cxDesignHelper) then
    cxDesignHelper.SelectObject(Control, ASeries);
end;

procedure TdxChartControlController.AddXYDiagramClickHandler(Sender: TObject);
var
  ADiagram: TdxChartCustomDiagram;
begin
  ADiagram := Chart.AddDiagram<TdxChartXYDiagram>;
  if Assigned(cxDesignHelper) then
    cxDesignHelper.SelectObject(Control, ADiagram);
end;

procedure TdxChartControlController.AddSimpleDiagramClickHandler(Sender: TObject);
var
  ADiagram: TdxChartCustomDiagram;
begin
  ADiagram := Chart.AddDiagram<TdxChartSimpleDiagram>;
  if Assigned(cxDesignHelper) then
    cxDesignHelper.SelectObject(Control, ADiagram);
end;

procedure TdxChartControlController.DeleteDiagramClickHandler(Sender: TObject);
begin
  FCustomizationPopupMenuInvoker.Free;
end;

procedure TdxChartControlController.PopulateCustomizationPopupMenu(AMenu: TPopupMenu);
var
  I: Integer;
  ACaption: string;
  AItem: TMenuItem;
begin
  if Assigned(dxChartShowDesignTimeDesigner) then
  begin
    AMenu.Items.Add(NewItem('Designer...', 0, False, True, ShowDesignerClickHandler, 0, ''));
    AMenu.Items.Add(NewLine);
  end;
  AMenu.Items.Add(NewItem('Add ' + cxGetResourceString(@sdxChartControlXYDiagramDisplayName), 0, False, True, AddXYDiagramClickHandler, 0, ''));
  AMenu.Items.Add(NewItem('Add ' + cxGetResourceString(@sdxChartControlSimpleDiagramDisplayName), 0, False, True, AddSimpleDiagramClickHandler, 0, ''));
  AMenu.Items.Add(NewItem('Delete Diagram', 0, False, True, DeleteDiagramClickHandler, 0, ''));
  AMenu.Items.Add(NewLine);

  for I := 0 to dxChartRegisteredSeriesView.Count - 1 do
    if TdxChartSeriesViewClass(dxChartRegisteredSeriesView[I]).IsCompatibleWith(TdxChartCustomDiagramAccess(FCustomizationPopupMenuInvoker).GetSeriesClass) then
    begin
      ACaption := Format(cxGetResourceString(@sdxChartDesignerAddSeriesTemplate),
        [TdxChartSeriesViewClass(dxChartRegisteredSeriesView[I]).GetDescription]);
      AItem := NewItem(ACaption, 0, False, True, AddSeriesClickHandler, 0, '');
      AItem.ImageIndex := TdxChartSeriesViewClass(dxChartRegisteredSeriesView[I]).GetViewImageIndex;
      AItem.Tag := NativeInt(dxChartRegisteredSeriesView[I]);
      if (Pos('Full', AItem.Caption) < 1) and (Pos('Full', AMenu.Items[AMenu.Items.Count - 1].Caption) > 0) then
        AMenu.Items.Add(NewLine);
      AMenu.Items.Add(AItem);
    end;
end;

{ TdxChartHotTrackElementEventArgs }

constructor TdxChartHotTrackElementEventArgs.Create(AHitTest: TdxChartHitTest; APreviousHitTest: TdxChartHitTest);
begin
  inherited Create;
  FHitTest := AHitTest;
  FPreviousHitTest := APreviousHitTest;
end;

destructor TdxChartHotTrackElementEventArgs.Destroy;
begin
  FreeAndNil(FHitTest);
  FreeAndNil(FPreviousHitTest);
  inherited Destroy;
end;

function TdxChartHotTrackElementEventArgs.GetElement: TObject;
begin
  Result := HitTest.HitObject;
end;

function TdxChartHotTrackElementEventArgs.GetPreviousElement: TObject;
begin
  Result := PreviousHitTest.HitObject;
end;

{ TdxCustomChartControl }

constructor TdxCustomChartControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ParentFont := False;
  CreateSubClasses;
  SetBounds(Left, Top, 300, 250);
  BorderStyle := cxcbsDefault;
  ScrollOptions.ScrollBars := True;
end;

destructor TdxCustomChartControl.Destroy;
begin
  DestroySubClasses;
  inherited Destroy;
end;

function TdxCustomChartControl.AddDiagram(ADiagramClass: TdxChartDiagramClass;
  const ACaption: string): TdxChartCustomDiagram;
begin
  Result := Chart.AddDiagram(ADiagramClass, ACaption);
end;

function TdxCustomChartControl.AddDiagram<T>(const ACaption: string = ''): T;
begin
  Result := Chart.AddDiagram<T>(ACaption);
end;

procedure TdxCustomChartControl.Assign(Source: TPersistent);
begin
  if Source is TdxCustomChartControl then
  begin
    Chart.AssignFrom(TdxCustomChartControl(Source).Chart, True);
    ParentFont := TdxCustomChartControl(Source).ParentFont;
    BoundsChanged;
  end;
end;

procedure TdxCustomChartControl.BeginUpdate;
begin
  Chart.BeginUpdate;
end;

procedure TdxCustomChartControl.CancelUpdate;
begin
  Chart.CancelUpdate;
end;

function TdxCustomChartControl.CanStartDragAndDrop(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := not (ssDouble in Shift) and Controller.StartDragAndDrop(Button, Shift, X, Y);
end;

procedure TdxCustomChartControl.EndUpdate;
begin
  Chart.EndUpdate;
end;

procedure TdxCustomChartControl.ExportToImage(const AStream: TStream; ACodecClass: TdxSmartImageCodecClass;
  AImageWidth, AImageHeight: Integer);
begin
  Chart.ExportToImage(AStream, ACodecClass, AImageWidth, AImageHeight);
end;

procedure TdxCustomChartControl.ExportToImage(const AFileName: string; ACodecClass: TdxSmartImageCodecClass;
  AImageWidth: Integer; AImageHeight: Integer);
begin
  Chart.ExportToImage(AFileName, ACodecClass, AImageWidth, AImageHeight);
end;

procedure TdxCustomChartControl.ExportToSVG(const AStream: TStream; AImageWidth, AImageHeight: Integer);
begin
  Chart.ExportToSVG(AStream, AImageWidth, AImageHeight);
end;

procedure TdxCustomChartControl.ExportToSVG(const AFileName: string; AImageWidth, AImageHeight: Integer);
begin
  Chart.ExportToSVG(AFileName, AImageWidth, AImageHeight);
end;

procedure TdxCustomChartControl.ExportToBMP(const AStream: TStream; AImageWidth, AImageHeight: Integer);
begin
  Chart.ExportToBMP(AStream, AImageWidth, AImageHeight);
end;

procedure TdxCustomChartControl.ExportToBMP(const AFileName: string; AImageWidth, AImageHeight: Integer);
begin
  Chart.ExportToBMP(AFileName, AImageWidth, AImageHeight);
end;

procedure TdxCustomChartControl.ExportToJPEG(const AStream: TStream; AImageWidth, AImageHeight: Integer);
begin
  Chart.ExportToJPEG(AStream, AImageWidth, AImageHeight);
end;

procedure TdxCustomChartControl.ExportToJPEG(const AFileName: string; AImageWidth, AImageHeight: Integer);
begin
  Chart.ExportToJPEG(AFileName, AImageWidth, AImageHeight);
end;

procedure TdxCustomChartControl.ExportToPNG(const AStream: TStream; AImageWidth, AImageHeight: Integer);
begin
  Chart.ExportToPNG(AStream, AImageWidth, AImageHeight);
end;

procedure TdxCustomChartControl.ExportToPNG(const AFileName: string; AImageWidth, AImageHeight: Integer);
begin
  Chart.ExportToPNG(AFileName, AImageWidth, AImageHeight);
end;

procedure TdxCustomChartControl.ExportToTIFF(const AStream: TStream; AImageWidth, AImageHeight: Integer);
begin
  Chart.ExportToTIFF(AStream, AImageWidth, AImageHeight);
end;

procedure TdxCustomChartControl.ExportToTIFF(const AFileName: string; AImageWidth, AImageHeight: Integer);
begin
  Chart.ExportToTIFF(AFileName, AImageWidth, AImageHeight);
end;

procedure TdxCustomChartControl.ExportToGIF(const AStream: TStream; AImageWidth, AImageHeight: Integer);
begin
  Chart.ExportToGIF(AStream, AImageWidth, AImageHeight);
end;

procedure TdxCustomChartControl.ExportToGIF(const AFileName: string; AImageWidth, AImageHeight: Integer);
begin
  Chart.ExportToGIF(AFileName, AImageWidth, AImageHeight);
end;

procedure TdxCustomChartControl.ExportToEMF(const AStream: TStream; AImageWidth, AImageHeight: Integer);
begin
  Chart.ExportToEMF(AStream, AImageWidth, AImageHeight);
end;

procedure TdxCustomChartControl.ExportToEMF(const AFileName: string; AImageWidth, AImageHeight: Integer);
begin
  Chart.ExportToEMF(AFileName, AImageWidth, AImageHeight);
end;

procedure TdxCustomChartControl.ExportToWMF(const AStream: TStream; AImageWidth, AImageHeight: Integer);
begin
  Chart.ExportToWMF(AStream, AImageWidth, AImageHeight);
end;

procedure TdxCustomChartControl.ExportToWMF(const AFileName: string; AImageWidth, AImageHeight: Integer);
begin
  Chart.ExportToWMF(AFileName, AImageWidth, AImageHeight);
end;

procedure TdxCustomChartControl.ExportToDOCX(const AStream: TStream; AImageWidth, AImageHeight: Integer);
begin
  Chart.ExportToDOCX(AStream, AImageWidth, AImageHeight);
end;

procedure TdxCustomChartControl.ExportToDOCX(const AFileName: string; AImageWidth, AImageHeight: Integer);
begin
  Chart.ExportToDOCX(AFileName, AImageWidth, AImageHeight);
end;

procedure TdxCustomChartControl.ExportToXLSX(const AStream: TStream; AImageWidth, AImageHeight: Integer);
begin
  Chart.ExportToXLSX(AStream, AImageWidth, AImageHeight);
end;

procedure TdxCustomChartControl.ExportToXLSX(const AFileName: string; AImageWidth, AImageHeight: Integer);
begin
  Chart.ExportToXLSX(AFileName, AImageWidth, AImageHeight);
end;

procedure TdxCustomChartControl.LoadFromStream(AStream: TStream);
begin
  Chart.LoadFromStream(AStream);
end;

procedure TdxCustomChartControl.SaveToStream(AStream: TStream);
begin
  Chart.SaveToStream(AStream);
end;

procedure TdxCustomChartControl.CalculateHitTest(X, Y: Integer);
begin
  Controller.CalculateHitTest(X, Y);
end;

procedure TdxCustomChartControl.GetChildren(Proc: TGetChildProc; Root: TComponent);

  procedure DoStore(ADiagram: TdxChartCustomDiagram);
  begin
    if ADiagram.Owner = Root then
      Proc(ADiagram);
  end;

var
  I: Integer;
begin
  inherited GetChildren(Proc, Root);
  for I := 0 to DiagramCount - 1 do
    DoStore(Diagrams[I]);
end;

procedure TdxCustomChartControl.ChartChangeHandler(Sender: TObject);
begin
  if not IsLoading and not FOnChartChanged.Empty then
    FOnChartChanged.Invoke(Self);
end;

procedure TdxCustomChartControl.CMParentFontChanged(var Message: TCMParentFontChanged);
begin
  inherited;
  if Message.WParam <> 0 then
    FParentFontValue.Assign(Message.Font)
  else
    FParentFontValue.Assign(TWinControlAccess(Parent).Font);
  if not FChangingParentFont and Assigned(FOnParentFontChanged) then
    FOnParentFontChanged(Self);
end;

function TdxCustomChartControl.CreateController: TdxChartControlController;
begin
  Result := TdxChartControlController.Create(Self);
end;

function TdxCustomChartControl.CreateChart: TdxChart;
begin
  Result := TdxChart.Create(Self);
  Result.OnChange := ChartChangeHandler;
end;

procedure TdxCustomChartControl.CreateSubClasses;
begin
  FChart := CreateChart;
  FController := CreateController;
  FParentFontValue := TFont.Create;
end;

procedure TdxCustomChartControl.DestroySubClasses;
begin
  FreeAndNil(FParentFontValue);
  FreeAndNil(FController);
  FreeAndNil(FChart);
end;

function TdxCustomChartControl.CreateActualCanvasCore(var ARenderMode: TdxRenderMode): TcxCustomCanvas;
var
  ACanvas: TdxGDIPlusControlCanvas;
begin
  if ARenderMode = rmGDI then
  begin
    ACanvas := TdxGDIPlusControlCanvas.Create(Canvas.Canvas);
    ACanvas.SmoothingMode := smNone;
    Result := ACanvas;
  end
  else
    Result := inherited CreateActualCanvasCore(ARenderMode);
  TdxChartAccess(FChart).CanvasChanged(Result);
end;

procedure TdxCustomChartControl.DoContextPopup(MousePos: TPoint; var Handled: Boolean);
begin
  if DragAndDropState = ddsInProcess then
    Handled := True
  else
  begin
    if DragAndDropState = ddsStarting then
      FinishDragAndDrop(False);
    if Assigned(OnContextPopup) then
      CalculateHitTest(MousePos.X, MousePos.Y);
    inherited DoContextPopup(MousePos, Handled);
  end;
end;

procedure TdxCustomChartControl.DoHotTrackElement(const AArgs: TdxChartHotTrackElementEventArgs);
begin
  if Assigned(FOnHotTrackElement) then
    FOnHotTrackElement(Self, AArgs);
end;

procedure TdxCustomChartControl.DoPaint;
begin
  inherited DoPaint;
  Chart.PaintTo(ActualCanvas);
end;

function TdxCustomChartControl.GetDefaultRenderMode: TdxRenderMode;
begin
  Result := rmGDIPlus;
end;

procedure TdxCustomChartControl.BiDiModeChanged;
begin
  inherited BiDiModeChanged;
  Chart.UseRightToLeftAlignment := UseRightToLeftAlignment;
  Chart.UseRightToLeftReading := UseRightToLeftReading;
  TdxChartAccess(Chart).BiDiModeChanged;
end;

procedure TdxCustomChartControl.BoundsChanged;
begin
  Chart.Bounds := ClientBounds;
  Invalidate;
end;

procedure TdxCustomChartControl.ChangeScaleEx(M, D: Integer; isDpiChange: Boolean);
begin
  Chart.ChangeScale(M, D);
  inherited ChangeScaleEx(M, D, isDpiChange);
end;

function TdxCustomChartControl.GetOnParentFontChanged: TNotifyEvent;
begin
  Result := FOnParentFontChanged;
end;

procedure TdxCustomChartControl.SetOnParentFontChanged(AEventListener: TNotifyEvent);
begin
  FOnParentFontChanged := AEventListener;
end;

function TdxCustomChartControl.GetChart: TdxChart;
begin
  Result := Chart;
end;

function TdxCustomChartControl.GetParentFontValue: TFont;
begin
  Result := FParentFontValue;
end;

procedure TdxCustomChartControl.InvalidateRect(const ARect: TdxRectF);
begin
  inherited InvalidateRect(ARect.DeflateToTRect, False);
end;

function TdxCustomChartControl.GetIsParentFontUsed: Boolean;
begin
  Result := ParentFont;
end;

procedure TdxCustomChartControl.SetIsParentFontUsed(AValue: Boolean);
begin
  FChangingParentFont := True;
  try
    ParentFont := AValue;
  finally
    FChangingParentFont := False;
  end;
end;


function TdxCustomChartControl.AllowTouchScrollUIMode: Boolean;
begin
  Result := not IsDesigning;
end;

function TdxCustomChartControl.GetMainScrollBarsClass: TcxControlCustomScrollBarsClass;
begin
  Result := TcxControlWindowedScrollBars;
end;

function TdxCustomChartControl.GetScrollbarMode: TdxScrollbarMode;
begin
  Result := sbmHybrid;
end;

function TdxCustomChartControl.GetToolTips: TdxChartToolTips;
begin
  Result := Chart.ToolTips;
end;

function TdxCustomChartControl.GetTouchScrollUIOwner(const APoint: TPoint): IdxTouchScrollUIOwner;
begin
  Result := Controller.ScrollBars;
end;

function TdxCustomChartControl.NeedsScrollBars: Boolean;
begin
  Result := True;
end;

function TdxCustomChartControl.GetDesignHitTest(X, Y: Integer; Shift: TShiftState): Boolean;
begin
  Result := inherited GetDesignHitTest(X, Y, Shift) or Controller.GetDesignHitTest(X, Y, Shift);
end;

function TdxCustomChartControl.GetCurrentCursor(X, Y: Integer): TCursor;
begin
  Result := Controller.GetCurrentCursor(X, Y);
  if Result = crDefault then
    Result := inherited GetCurrentCursor(X, Y);
end;

function TdxCustomChartControl.InternalMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean;
begin
  Result := Controller.MouseWheel(Shift, WheelDelta, MousePos);
end;

function TdxCustomChartControl.IsMouseWheelHandleNeeded(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean;
begin
  Result := True;
end;

procedure TdxCustomChartControl.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  Controller.KeyDown(Key, Shift);
end;

procedure TdxCustomChartControl.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited KeyUp(Key, Shift);
  Controller.KeyUp(Key, Shift);
end;

procedure TdxCustomChartControl.MouseDown(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  Controller.MouseDown(Button, Shift, X, Y);
end;

procedure TdxCustomChartControl.MouseLeave(AControl: TControl);
begin
  inherited;
  Controller.MouseLeave;
end;

procedure TdxCustomChartControl.MouseMove(Shift: TShiftState; X: Integer; Y: Integer);
begin
  Controller.MouseMove(Shift, X, Y);
  inherited MouseMove(Shift, X, Y);
end;

procedure TdxCustomChartControl.MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
begin
  Controller.MouseUp(Button, Shift, X, Y);
  inherited MouseUp(Button, Shift, X, Y);
end;

function TdxCustomChartControl.GetAppearance: TdxChartAppearance;
begin
  Result := Chart.Appearance;
end;

function TdxCustomChartControl.GetDiagramCount: Integer;
begin
  Result := Chart.DiagramCount;
end;

function TdxCustomChartControl.GetHitTest: TdxChartHitTest;
begin
  Result := Controller.HitTest;
end;

function TdxCustomChartControl.GetDiagram(AIndex: Integer): TdxChartCustomDiagram;
begin
  Result := Chart.Diagrams[AIndex];
end;

function TdxCustomChartControl.GetLegend: TdxChartLegend;
begin
  Result := Chart.Legend;
end;

function TdxCustomChartControl.GetScrollOptions: TdxChartScrollOptions;
begin
  Result := Chart.ScrollOptions;
end;

function TdxCustomChartControl.GetTitles: TdxChartTitles;
begin
  Result := Chart.Titles;
end;

function TdxCustomChartControl.GetUseThreading: TdxDefaultBoolean;
begin
  Result := Chart.UseThreading;
end;

function TdxCustomChartControl.GetVisibleDiagram(AIndex: Integer): TdxChartCustomDiagram;
begin
  Result := Chart.VisibleDiagrams[AIndex];
end;

function TdxCustomChartControl.GetVisibleDiagramCount: Integer;
begin
  Result := Chart.VisibleDiagramCount
end;

function TdxCustomChartControl.GetZoomOptions: TdxChartZoomOptions;
begin
  Result := Chart.ZoomOptions;
end;

procedure TdxCustomChartControl.SetAppearance(const AValue: TdxChartAppearance);
begin
  Appearance.Assign(AValue);
end;

procedure TdxCustomChartControl.SetDiagram(AIndex: Integer; const AValue: TdxChartCustomDiagram);
begin
  Diagrams[AIndex].Assign(AValue);
end;

procedure TdxCustomChartControl.SetLegend(const AValue: TdxChartLegend);
begin
  Chart.Legend.Assign(AValue);
end;

procedure TdxCustomChartControl.SetOnChange(AValue: TNotifyEvent);
begin
  if Assigned(FOnChange) then
    FOnChartChanged.Remove(FOnChange);
  FOnChange := AValue;
  if Assigned(FOnChange) then
    FOnChartChanged.Add(FOnChange);
end;

procedure TdxCustomChartControl.SetScrollOptions(
  AValue: TdxChartScrollOptions);
begin
  Chart.ScrollOptions := AValue;
end;

procedure TdxCustomChartControl.SetTitles(const AValue: TdxChartTitles);
begin
  Chart.Titles.Assign(AValue);
end;

procedure TdxCustomChartControl.SetToolTips(const Value: TdxChartToolTips);
begin
  Chart.ToolTips := Value;
end;

procedure TdxCustomChartControl.SetUseThreading(AValue: TdxDefaultBoolean);
begin
  Chart.UseThreading := AValue;
end;

procedure TdxCustomChartControl.SetZoomOptions(
  AValue: TdxChartZoomOptions);
begin
  Chart.ZoomOptions := AValue;
end;

function TdxCustomChartControl.StartDragAndDrop(const P: TPoint): Boolean;
begin
  Result := True;
end;

procedure TdxCustomChartControl.TranslationChanged;
begin
  inherited TranslationChanged;
  Invalidate;
end;

{ TdxChartHitTestHelper }

function TdxChartHitTestHelper.Clone: TdxChartHitTest;
begin
  Result := TdxChartHitTest.Create;
  Result.Assign(Self);
end;

end.
