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

unit dxChartCore;

{$I cxVer.inc}
{$R dxChart.res}
{$SCOPEDENUMS ON}

interface

uses
  System.UITypes,
  Generics.Defaults, Generics.Collections,
  Windows, Types, Classes, Contnrs, SysUtils, Controls, Graphics, Variants, Math, ImgList, StdCtrls, Forms,
  dxCore, dxCoreClasses, dxCoreGraphics, cxClasses, cxGeometry, cxGraphics, cxVariants, dxGenerics, dxCustomHint,
  dxGDIPlusClasses, cxDrawTextUtils, dxThreading, cxControls, cxFormats,
  cxLookAndFeels, cxLookAndFeelPainters, dxTypeHelpers, cxCustomCanvas, cxDataStorage, dxCustomData,
  dxChartColorScheme, dxSpreadSheetClasses, dxSpreadSheetCoreStyles, dxHashUtils,
  dxSVGCanvas, dxXMLDoc, dxSmartImage, dxSVGCore, dxSVGImage, dxSmartImageExporter;


type
  TdxChartVisualElementAppearance = class;
  TdxChartColorizedAppearance = class;
  TdxChartVisualElementTitle = class;
  TdxChartVisualElementCustomViewInfo = class;
  TdxChartTitles = class;
  TdxChartCustomLegend = class;
  TdxChartLegend = class;
  TdxChartDiagramLegend = class;
  TdxChartCustomItemViewData = class;
  TdxChartCustomItemViewInfo = class;
  TdxChartSeriesCustomView = class;
  TdxChartSeriesValueViewInfo = class;
  TdxChartSeriesValueViewInfoClass = class of TdxChartSeriesValueViewInfo;
  TdxChartValueLabelCustomViewInfo = class;
  TdxChartSeriesViewClass = class of TdxChartSeriesCustomView;
  TdxChartSeriesViewCustomViewInfo = class;
  TdxChartSeriesViewCustomViewData = class;
  TdxChartCustomDiagram = class;
  TdxChartDiagramCustomViewData = class;
  TdxChartDiagramCustomViewInfo = class;
  TdxChartDiagramSeriesGroup = class;
  TdxChartDiagramSeriesGroupClass = class of TdxChartDiagramSeriesGroup;
  TdxChartSeriesPoints = class;
  TdxChartSeriesPointsClass = class of TdxChartSeriesPoints;
  TdxChartSeriesTopNOptions = class;
  TdxChartCustomSeries = class;
  TdxChartSeriesClass = class of TdxChartCustomSeries;
  TdxChartSeriesCustomDataField = class;
  TdxChartSeriesDataFieldClass = class of TdxChartSeriesCustomDataField;
  TdxChartSeriesCustomDataBinding = class;
  TdxChartSeriesDataBindingClass = class of TdxChartSeriesCustomDataBinding;
  TdxChartDataController = class;
  TdxChartDiagramClass = class of TdxChartCustomDiagram;
  TdxChartDiagramViewInfoClass = class of TdxChartDiagramCustomViewInfo;
  TdxChartSeriesValueLabelAppearanceClass = class of TdxChartSeriesValueLabelAppearance;
  TdxChart = class;
  TdxChartFormats = class;
  TdxChartSeriesPointInfo = class;
  EdxChartException = class(Exception);

  // common types

  TdxChartTextFormat = type string;

  TdxChartEmptyPointsDisplayMode = (Default, Zero, Gap);

  TdxChartSeriesSortBy = (Argument, Value);

  TdxChartSeriesShowInLegend = (Diagram, Chart, None);

  TdxChartTitlePosition = (Default, Left, Top, Right, Bottom);

  TdxChartToolTipMode = (Default, None, Simple, Crosshair);
  TdxChartActualToolTipMode = TdxChartToolTipMode.None .. TdxChartToolTipMode.Crosshair;

  TdxChartLegendAlignment = (Default, NearOutside, Near, Center, Far, FarOutside);

  TdxChartLegendDirection = (TopToBottom, BottomToTop, LeftToRight, RightToLeft);

  TdxChartSeriesValueLabelsResolveOverlappingMode = (None, Default, HideOverlapped, JustifyAroundPoint, JustifyAllAroundPoint); // for internal use

  TdxChartNamedValueProvider = reference to function(const AName: string; out AValue: Variant): Boolean;  // for internal use

  TdxChartNamedValueDelegate = class  // for internal use
  protected
    FValue: Variant;
  public
    constructor Create(const AValue: Variant);
    procedure SetValue(const AValue: Variant);
    function GetValueByName(const AName: string; out AValue: Variant): Boolean; virtual;
  end;

  TdxChartAxisNamedValueProvider = class(TdxChartNamedValueDelegate)  // for internal use
  public
    function GetValueByName(const AName: string; out AValue: Variant): Boolean; override;
  end;

  TdxChartTextFormatVariableNames = class
    const
      Argument = 'A';
      Value = 'V';
      Series = 'S';
      TotalValue = 'TV';
  end;

  { IdxChartOwner }

  IdxChartOwner = interface  // for internal use
  ['{BA5DD019-059D-4E0F-BF6C-A0D8797BC3BA}']
    function GetOnParentFontChanged: TNotifyEvent;
    procedure SetOnParentFontChanged(AEventListener: TNotifyEvent);
    function GetIsParentFontUsed: Boolean;
    procedure SetIsParentFontUsed(AValue: Boolean);

    function GetChart: TdxChart;
    function GetParentFontValue: TFont;
    procedure Invalidate;
    procedure InvalidateRect(const ARect: TdxRectF);
    property IsParentFontUsed: Boolean read GetIsParentFontUsed write SetIsParentFontUsed;
    property OnParentFontChanged: TNotifyEvent read GetOnParentFontChanged write SetOnParentFontChanged;
  end;

  { IdxChartVisualElement }

  IdxChartVisualElement = interface // for internal use
  ['{2F3B7920-7255-4587-9D56-1A0E68BDC073}']
    function ActuallyVisible: Boolean;
    function GetAppearance: TdxChartVisualElementAppearance;
    function GetChart: TdxChart;
    function GetParentElement: IdxChartVisualElement;
    procedure LayoutChanged;
    procedure StyleChanged;
    procedure TextColorChanged;
  end;

  { IdxChartCloneComponent }

  IdxChartCloneComponent = interface // for internal use
  ['{98E5BFE3-649A-4E15-B6B4-91A50BF921DD}']
    function GetSource: TObject;
    procedure SetSource(AValue: TObject);
  end;

  { IdxDefaultFontScaleFactorProvider }

  IdxDefaultFontScaleFactorProvider = interface // for internal use
  ['{D1A8E4FB-DB33-41BE-9BA3-3557539DA4FE}']
    function GetScaleFactor: Single;
  end;

  IdxChartDiagram = interface 
  ['{35991152-8948-49FA-B549-6FAECA83F18E}']
    function GetActualToolTipMode: TdxChartActualToolTipMode;
  end;

  { IdxChartDisplayFormat }

  IdxChartDisplayFormat = interface
  ['{F3EFB2F6-1895-42B5-9FCF-39C504AD87BC}']
    function GetDisplayFormat: string;
  end;

  { IdxChartLegendItem }

  IdxChartLegendItem = interface
  ['{21AC2B1E-B230-4335-8069-4E6BCB0C5A81}']
    procedure DrawGlyph(ACanvas: TcxCustomCanvas; const R: TdxRectF);
    function GetCaption: string;
    function GetColor: TdxAlphaColor;
    function IsChecked: Boolean;
    function IsEnabled: Boolean;
    procedure SetChecked(AValue: Boolean);
  end;

  { TdxChartOwnedPersistent }

  TdxChartOwnedPersistent = class(TcxOwnedInterfacedPersistent)
  protected
    procedure Changed; virtual;
  end;

  { TdxChartVisualElementPersistent }

  TdxChartVisualElementPersistent = class(TcxOwnedInterfacedPersistent, IdxChartVisualElement)
  strict private
    FAppearance: TdxChartVisualElementAppearance;
    FVisible: Boolean;
    function GetAppearance: TdxChartVisualElementAppearance;
    function IsVisibleStored: Boolean;
    procedure SetAppearance(AValue: TdxChartVisualElementAppearance);
    procedure SetVisible(AValue: Boolean);
  protected
    // IdxChartVisualElement
    function ActuallyVisible: Boolean; virtual;
    procedure ChangeScale(M, D: Integer); virtual;
    function CreateAppearance: TdxChartVisualElementAppearance; virtual; abstract;
    procedure DoAssign(Source: TPersistent); override;
    function GetChart: TdxChart; virtual;
    function GetDefaultVisible: Boolean; virtual;
    function GetParentElement: IdxChartVisualElement; virtual;
    procedure LayoutChanged; virtual;
    procedure StyleChanged; virtual;
    procedure TextColorChanged;
    procedure Invalidate; virtual;
    procedure VisibleChanged; virtual;
    procedure UpdateTextColors; virtual;

    property Appearance: TdxChartVisualElementAppearance read FAppearance write SetAppearance;
    property Visible: Boolean read FVisible write SetVisible stored IsVisibleStored;
  public
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;
  end;

  { TdxChartCustomVisualElement }

  TdxChartCustomVisualElement = class(TdxChartVisualElementPersistent)
  strict private
    FViewInfo: TdxChartVisualElementCustomViewInfo;
  protected
    procedure BiDiModeChanged; virtual;
    function CreateViewInfo: TdxChartVisualElementCustomViewInfo; virtual; abstract;
    procedure ChangeScale(M, D: Integer); override;
    procedure Invalidate; override;
    procedure LayoutChanged; override;
    procedure RecreateViewInfo;
    procedure UpdateTextColors; override;

    property ViewInfo: TdxChartVisualElementCustomViewInfo read FViewInfo;
  public
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;
  end;

  TdxChartHitCode = (None, Chart, ChartTitle, DiagramTitle, LegendTitle, SeriesTitle, AxisTitle, TotalLabel, Legend, LegendItem, Axis, AxisValueLabel, SeriesValueLabel, SeriesPoint, Diagram, PlotArea, Series);

  { IdxChartHitTestElement }

  IdxChartHitTestElement = interface  // for internal use
  ['{B0675F48-1083-4CB5-B689-6C4EA3C017E3}']
    function GetChartElement: TObject;
    function GetHitCode: TdxChartHitCode;
    function GetSubAreaCode: Integer;
  end;

  { IdxChartHitTestClickableElement }

  IdxChartHitTestClickableElement = interface(IdxChartHitTestElement) // for internal use
  ['{E750E648-09CE-43E1-B569-C13B61B6F586}']
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
  end;

  { IdxChartHitTestHintableElement }

  IdxChartHitTestHintableElement = interface(IdxChartHitTestElement) // for internal use
  ['{853E5140-D72D-4978-9683-161981C86B83}']
    function CanShowHint: Boolean;
    function GetHintableObject: IcxHintableObject2;
  end;

  TdxChartSimpleToolTipMode = (Point, Series);

  IdxChartHitTestElementWithToolTip = interface(IdxChartHitTestHintableElement) // for internal use
  ['{9F9546FC-F4C9-4B78-B0F3-6AF670B54F8D}']
    function GetHintedSeries: TdxChartCustomSeries;
    function GetMode: TdxChartSimpleToolTipMode;
    function IsModeSupported(AMode: TdxChartSimpleToolTipMode): Boolean;
    procedure SetMode(AValue: TdxChartSimpleToolTipMode);

    property HintedSeries: TdxChartCustomSeries read GetHintedSeries;
    property Mode: TdxChartSimpleToolTipMode read GetMode write SetMode;
  end;

  { IdxChartHitTestScrollableElement }

  IdxChartHitTestScrollableElement = interface(IdxChartHitTestElement)
  ['{073260FA-90F8-4078-9A49-27464B723C38}']
    procedure AddChangedListener(AHandler: TNotifyEvent);
    function GetHorizontalScrollBarData: TcxScrollBarData;
    function GetScrollableArea: TRect;
    function GetVerticalScrollBarData: TcxScrollBarData;
    function IsPanArea(const APoint: TPoint): Boolean;
    function IsValid: Boolean;
    procedure RemoveChangedListener(AHandler: TNotifyEvent);
    procedure Scroll(AScrollBarKind: TScrollBarKind; AScrollCode: TScrollCode; var AScrollPos: Integer);
  end;

  IdxChartHitTestPlotAreaElement = interface
  ['{1629A419-2589-4C05-8F45-E647F4A7D8D2}']
    procedure GetDataPointFromCanvasPoint(const P: TdxPointF; out AArgument, AValue: Variant);
    function GetPlotArea: TObject;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer);
    procedure MouseLeave;
  end;

  { TdxChartHitTestEngine }

  TdxChartHitTestEngine = class // for internal use
  strict private
    FChart: TdxChart;
    FHitElement: IdxChartHitTestElement;
    FHitPlotArea: IdxChartHitTestPlotAreaElement;
    FHitPoint: TdxPointF;
    FHitScrollableElement: IdxChartHitTestScrollableElement;
  protected
    procedure SetHitItemViewInfo(const AHitItemViewInfo: TdxChartCustomItemViewInfo);
  public
    constructor Create(AChart: TdxChart);
    destructor Destroy; override;

    procedure Calculate(const P: TdxPointF; AForce: Boolean);
    procedure Reset;

    property Chart: TdxChart read FChart;
    property HitElement: IdxChartHitTestElement read FHitElement;
    property HitPlotArea: IdxChartHitTestPlotAreaElement read FHitPlotArea;
    property HitScrollableElement: IdxChartHitTestScrollableElement read FHitScrollableElement;
    property Point: TdxPointF read FHitPoint;
  end;

  { TdxChartCustomItemViewData }

  TdxChartCustomItemViewData = class
  strict private
    FDirty: Boolean;
  protected
    procedure DoCalculate; virtual;
    procedure MakeDirty; virtual;
    property Dirty: Boolean read FDirty write FDirty;
  public
    procedure Calculate;
  end;

  { TdxChartCustomItemViewInfo }

  TdxChartCustomItemViewInfo = class
  strict private
    FDirty: Boolean;
    FVisible: Boolean;
    FVisibleBounds: TdxRectF;
  protected
    FBounds: TdxRectF;
    FIsExportMode: Boolean;
    FClipRect: TdxRectF;
    FHasClipping: Boolean;
    procedure BeforeCalculate(ACanvas: TcxCustomCanvas); virtual;
    function CalculateHitTest(AHitTest: TdxChartHitTestEngine; const P: TdxPointF): Boolean; virtual;
    procedure DoCalculate(ACanvas: TcxCustomCanvas); virtual;
    procedure DoDraw(ACanvas: TcxCustomCanvas); virtual;
    procedure EnableExportMode(AEnable: Boolean); virtual;
    function GetHitElement(const P: TdxPointF): IdxChartHitTestElement; virtual;
    function GetHitPlotArea(const P: TdxPointF): IdxChartHitTestPlotAreaElement; virtual;
    function GetHitScrollableElement(const P: TdxPointF): IdxChartHitTestScrollableElement; virtual;
    function NeedClipping: Boolean; virtual;
    procedure Offset(const ADistance: TdxPointF; const ANewVisibleBounds: TdxRectF); overload;
    procedure UpdateClipping;
    procedure UpdateTextColors; virtual;
    property Dirty: Boolean read FDirty write FDirty;
  public
    constructor Create;
    function ActuallyVisible: Boolean;
    procedure Calculate(ACanvas: TcxCustomCanvas);
    procedure Draw(ACanvas: TcxCustomCanvas);
    procedure Offset(const ADistance: TdxPointF); overload; virtual;
    procedure SetBounds(const ABounds, AVisibleBounds: TdxRectF); virtual; 
    procedure UpdateBounds(const ABounds: TdxRectF); overload; virtual;
    procedure UpdateBounds(const ABounds, AVisibleBounds: TdxRectF); overload;

    property Bounds: TdxRectF read FBounds;
    property ClipRect: TdxRectF read FClipRect;
    property HasClipping: Boolean read FHasClipping;
    property Visible: Boolean read FVisible write FVisible;
    property VisibleBounds: TdxRectF read FVisibleBounds;
  end;

  { TdxChartSeriesValueViewInfo }

  TdxChartSeriesValueViewInfo = class
  strict private
    FIndex: Integer;
    FNext: TdxChartSeriesValueViewInfo;
    FOwner: TdxChartSeriesViewCustomViewInfo;
    FPrior: TdxChartSeriesValueViewInfo;
    FRecord: PdxDataRecord;

    function GetSeries: TdxChartCustomSeries; inline;
    function GetToolTipText: string;
    function GetViewData: TdxChartSeriesViewCustomViewData; inline;
    function GetVisible: Boolean; inline;
    procedure SetVisible(AValue: Boolean); inline;
  protected type
    TValueState = (Dirty, Hidden, Gap, Visible, SegmentStart, SegmentFinish, DisplayTextCalculated);
    TValueStates = set of TValueState;
  protected const
    TGapStates: TValueStates = [TValueState.Hidden, TValueState.Gap, TValueState.Visible];
    function GetState(AIndex: Integer): Boolean; inline;
    procedure SetGap(AIndex: Integer; AValue: Boolean); inline;
    procedure SetHidden(AIndex: Integer; AValue: Boolean); inline;
    procedure SetState(AIndex: Integer; AValue: Boolean); inline;
  protected
    FDisplayText: string;
    FNextDisplayValue: TdxChartSeriesValueViewInfo;
    FPriorDisplayValue: TdxChartSeriesValueViewInfo;
    FState: TValueStates;
    FValue: Double;
    FValueText: string;
    FValueLabel: TdxChartValueLabelCustomViewInfo;

    procedure CalculateDisplayText; virtual;
    procedure CalculateLabel(ACanvas: TcxCustomCanvas); virtual;
    procedure CalculateLabelLeaderLinePoints(var AStartPoint, AMiddlePoint, AEndPoint: TdxPointF); virtual;
    procedure CalculateValue; virtual;
    function CreateValueLabel: TdxChartValueLabelCustomViewInfo; virtual;
    function CreateSeriesPointInfo: TdxChartSeriesPointInfo; virtual;
    procedure DeleteNextItems;
    procedure FreeValueLabel;
    function GetAppearance: TdxChartVisualElementAppearance; virtual;
    function GetClipRect: TdxRectF; virtual;
    function GetDefaultPointToolTipFormatter: TObject; virtual;
    function GetDisplayText: string;
    function GetHitElement(const P: TdxPointF): IdxChartHitTestElement; virtual;
    function GetLabelAnchorPoint: TdxPointF; virtual;
    function GetValueByName(const AName: string; out AValue: Variant): Boolean; virtual;
    procedure RaiseGetValueLabelDrawParametersEvent(var AText: string);
    procedure UpdateRecord(const ARecord: PdxDataRecord); virtual;
    //
    property Owner: TdxChartSeriesViewCustomViewInfo read FOwner;
    property &Record: PdxDataRecord read FRecord;
    property Series: TdxChartCustomSeries read GetSeries;
    property ViewData: TdxChartSeriesViewCustomViewData read GetViewData;
  public
    constructor Create(AOwner: TdxChartSeriesViewCustomViewInfo; APriorValue: TdxChartSeriesValueViewInfo); virtual;
    destructor Destroy; override;
    procedure Draw(ACanvas: TcxCustomCanvas); virtual;

    property Appearance: TdxChartVisualElementAppearance read GetAppearance;
    property ClipRect: TdxRectF read GetClipRect;
    property Dirty: Boolean index TValueState.Dirty read GetState write SetState;
    property DisplayText: string read GetDisplayText;
    property Hidden: Boolean index TValueState.Hidden read GetState write SetHidden;
    property Index: Integer read FIndex;
    property IsGap: Boolean index TValueState.Gap read GetState write SetGap;
    property Next: TdxChartSeriesValueViewInfo read FNext;
    property NextVisibleValue: TdxChartSeriesValueViewInfo read FNextDisplayValue;
    property Prior: TdxChartSeriesValueViewInfo read FPrior;
    property PriorVisibleValue: TdxChartSeriesValueViewInfo read FPriorDisplayValue;
    property ToolTipText: string read GetToolTipText;
    property Value: Double read FValue;
    property Visible: Boolean read GetVisible write SetVisible;
    property ValueLabel: TdxChartValueLabelCustomViewInfo read FValueLabel;
  end;

  { TdxChartVisualElementCustomViewInfo }

  TdxChartVisualElementCustomViewInfo = class(TdxChartCustomItemViewInfo) // for internal use
  strict private
    FAppearance: TdxChartVisualElementAppearance;
    function GetBorderColor: TdxAlphaColor; inline;
    function GetBorderThickness: Single; inline;
    function GetBrush: TcxCanvasBasedBrush; inline;
    function GetFont: TcxCanvasBasedFont; inline;
    function GetMargins: TRect; inline;
    function GetPadding: TRect; inline;
    function GetPainter: TcxCustomLookAndFeelPainter; inline;
    function GetPen: TcxCanvasBasedPen; inline;
    function GetTextColor: TdxAlphaColor; inline;
    function GetUseRightToLeftAlignment: Boolean; inline;
    function GetUseRightToLeftReading: Boolean; inline;
  protected
    FContentBounds: TdxRectF;
    procedure BeforeCalculate(ACanvas: TcxCustomCanvas); override;
    procedure DoDraw(ACanvas: TcxCustomCanvas); override;
    procedure FreeCanvasBasedResources; virtual;

    property Appearance: TdxChartVisualElementAppearance read FAppearance;
    property Brush: TcxCanvasBasedBrush read GetBrush;
    property Font: TcxCanvasBasedFont read GetFont;
    property Margins: TRect read GetMargins;
    property Padding: TRect read GetPadding;
    property Painter: TcxCustomLookAndFeelPainter read GetPainter;
    property Pen: TcxCanvasBasedPen read GetPen;
  public
    constructor Create(AAppearance: TdxChartVisualElementAppearance); virtual;
    procedure UpdateBounds(const ABounds: TdxRectF); override;

    property ContentBounds: TdxRectF read FContentBounds;
    property BorderColor: TdxAlphaColor read GetBorderColor;
    property BorderThickness: Single read GetBorderThickness;
    property FontOptions: TcxCanvasBasedFont read GetFont;
    property TextColor: TdxAlphaColor read GetTextColor;
    property UseRightToLeftAlignment: Boolean read GetUseRightToLeftAlignment;
    property UseRightToLeftReading: Boolean read GetUseRightToLeftReading;
  end;

 { TdxChartItemsViewInfoList }

  TdxChartItemsViewInfoList = class(TdxFastObjectList)
  strict private
    function GetItem(AIndex: Integer): TdxChartCustomItemViewInfo; inline;
  protected type
    TForEachViewInfoItemProc = reference to procedure(AItem: TdxChartCustomItemViewInfo);
  protected
    procedure ForEach(AProc: TForEachViewInfoItemProc); inline;
  public
    procedure Calculate(ACanvas: TcxCustomCanvas); inline;
    procedure Draw(ACanvas: TcxCustomCanvas); inline;

    property Items[Index: Integer]: TdxChartCustomItemViewInfo read GetItem; default;
  end;

  { TdxChartVisualElementFontOptions }

  TdxChartVisualElementFontOptions = class(TdxChildFontOptions)
  protected
    function GetParent: TdxFontOptions; override;
  end;

  { TdxChartVisualElementFontOptionsWithDefaultSize }

  TdxChartVisualElementFontOptionsWithOverridenSize = class(TdxChartVisualElementFontOptions) // for internal use
  strict private
    FDefaultHeightFactor: Single;
  protected
    procedure DoAssign(Source: TPersistent); override;
    function GetHeight: Integer; override;
  public
    constructor Create(AOwner: TdxChartVisualElementAppearance; AFactorForDefaultFontHeight: Single); reintroduce;
  end;

  { TdxChartVisualElementAppearance }

  TdxChartVisualElementAppearance = class(TcxLockablePersistent)
  public type
    TForEachProc = reference to procedure(AListener: TdxChartVisualElementAppearance); // for internal use
  protected type
    TAppearanceChange = (Color, Font, Fill, Size, Stroke, Resources, TextColor);
    TAppearanceChanges = set of TAppearanceChange;
  protected const
    SizeChanges = [TAppearanceChange.Font, TAppearanceChange.Size, TAppearanceChange.Stroke];
    TotalChanges = [Low(TAppearanceChange)..High(TAppearanceChange)];
  protected var
    FParent: TdxChartVisualElementAppearance;
  strict private
    FActualBorderThickness: Single;
    FActualBrush: TcxCanvasBasedBrush;
    FActualColors: array of TdxAlphaColor;
    FActualFont: TcxCanvasBasedFont;
    FActualMargins: TRect;
    FActualPadding: TRect;
    FActualPen: TcxCanvasBasedPen;
    FBorder: TdxDefaultBoolean;
    FBorderThickness: Single;
    FListeners: TList;
    FChartReference: TdxChart;
    FColors: array of TdxAlphaColor;
    FIsActualColorsValid: Boolean;
    FMargins: TcxMargin;
    FOwnerElement: IdxChartVisualElement;
    FPadding: TcxMargin;
    FParentBackground: Boolean;
    FFillOptions: TdxFillOptions;
    FFontOptions: TdxFontOptions;
    FStrokeOptions: TdxStrokeOptions;
    procedure AssignColors(ASource: TdxChartVisualElementAppearance);
    procedure ChangeHandlerFillOptions(Sender: TObject);
    procedure ChangeHandlerFontOptions(Sender: TObject);
    procedure ChangeHandlerOffsets(Sender: TObject);
    procedure ChangeHandlerStrokeOptions(Sender: TObject);
    function GetChart: TdxChart; inline;
    function GetColorScheme: TdxChartColorScheme;
    function GetDefaultColor: TdxAlphaColor;
    function GetOwnerElement: IdxChartVisualElement; inline;
    function GetLookAndFeelPainter: TcxCustomLookAndFeelPainter; inline;
    function GetScaleFactor: TdxScaleFactor;
    function GetUseRightToLeftAlignment: Boolean; inline;
    function GetUseRightToLeftReading: Boolean; inline;
    procedure SetBorder(AValue: TdxDefaultBoolean);
    procedure SetBorderThickness(AValue: Single);
    procedure SetFillOptions(AValue: TdxFillOptions);
    procedure SetFontOptions(AValue: TdxFontOptions);
    procedure SetMargins(AValue: TcxMargin);
    procedure SetPadding(AValue: TcxMargin);
    procedure SetParentBackground(AValue: Boolean);
    procedure SetStrokeOptions(AValue: TdxStrokeOptions);
    function IsBorderThicknessStored: Boolean;
    function IsParentBackgroundStored: Boolean;
    procedure UpdateActualBrush(ACanvas: TcxCustomCanvas);
    procedure UpdateActualFont(ACanvas: TcxCustomCanvas);
    procedure UpdateActualPadding;
    procedure UpdateActualPen(ACanvas: TcxCustomCanvas);
    procedure UpdateReferences;
  protected const
    BorderColorIndex = 0;
    ColorIndex = 1;
    Color2Index = 2;
    PenColorIndex = 3;
    TextColorIndex = 4;
    DefaultChartFontSize = 8;
  protected
    Changes: TAppearanceChanges;
    procedure Changed(AChange: TAppearanceChange); overload;
    procedure Changed(AChanges: TAppearanceChanges); overload;
    procedure ChangeScale(M, D: Integer);
    procedure ChangeScaleCore(M, D: Integer); virtual;
    function CloneAsColorized(AIndex: Integer): TdxChartColorizedAppearance; virtual;
    function CreateFillOptions: TdxFillOptions; virtual;
    function CreateFontOptions: TdxFontOptions; virtual;
    function CreateSolidPen(ACanvas: TcxCustomCanvas; AColor: TdxAlphaColor; const AThickness: Single): TcxCanvasBasedPen;
    function CreateStrokeOptions: TdxStrokeOptions; virtual;
    function DefaultBorder: Boolean; virtual;
    function DefaultBorderThickness: Single; virtual;
    function DefaultPadding: Integer; virtual;
    function DefaultMargins: Integer; virtual;
    function DefaultParentBackground: Boolean; virtual;
    function DefaultPenColor: TdxAlphaColor; virtual;
    procedure DoAssign(Source: TPersistent); override;
    procedure DoChanged; override;
    procedure DoFlushCache; virtual;
    function GetActualBorder: Boolean;
    function GetActualColor(AIndex: Integer): TdxAlphaColor; virtual;
    function GetActualColorValue(AIndex: Integer): TdxAlphaColor; inline; 
    function GetActualMargins: TRect; virtual;
    function GetActualPadding: TRect; virtual;
    function GetColorCount: Integer; virtual;
    function GetColorValue(AIndex: Integer): TdxAlphaColor; inline;
    function HasBorder: Boolean;
    function HasFillOptions: Boolean; virtual;
    function HasFontOptions: Boolean; virtual;
    function HasStrokeOptions: Boolean; virtual;
    procedure RecreateSubClasses; virtual;
    procedure SetActualColor(AIndex: Integer; AValue: TdxAlphaColor); inline;
    procedure SetColorValue(AIndex: Integer; AValue: TdxAlphaColor);
    procedure SetParent(AParent: TdxChartVisualElementAppearance); virtual;
    procedure UpdateActualColors; virtual;
    procedure UpdateActualValues(ACanvas: TcxCustomCanvas); virtual;
    procedure UpdateMetrics(ACanvas: TcxCustomCanvas);
    // listeners and notifications
    procedure AddListener(AListener: TdxChartVisualElementAppearance);
    procedure Notification(AParentChanges: TAppearanceChanges); virtual;
    procedure NotifyListeners(AChanges: TAppearanceChanges);
    procedure ForEachListener(AProc: TdxChartVisualElementAppearance.TForEachProc);
    procedure RemoveListener(AListener: TdxChartVisualElementAppearance);
    property ActualBorderColor: TdxAlphaColor index BorderColorIndex read GetActualColorValue;
    property ActualBorderThickness: Single read FActualBorderThickness;
    property ActualBrush: TcxCanvasBasedBrush read FActualBrush;
    property ActualColor: TdxAlphaColor index ColorIndex read GetActualColorValue;
    property ActualFont: TcxCanvasBasedFont read FActualFont;
    property ActualMargins: TRect read FActualMargins;
    property ActualPadding: TRect read FActualPadding;
    property ActualPen: TcxCanvasBasedPen read FActualPen;
    property ActualPenColor: TdxAlphaColor index PenColorIndex read GetActualColorValue;
    property ActualTextColor: TdxAlphaColor index TextColorIndex read GetActualColorValue;
    property Chart: TdxChart read GetChart;
    property ColorScheme: TdxChartColorScheme read GetColorScheme;
    property IsActualColorsValid: Boolean read FIsActualColorsValid write FIsActualColorsValid;
    property Parent: TdxChartVisualElementAppearance read FParent write SetParent;
    property UseRightToLeftAlignment: Boolean read GetUseRightToLeftAlignment;
    property UseRightToLeftReading: Boolean read GetUseRightToLeftReading;
    property Border: TdxDefaultBoolean read FBorder write SetBorder default TdxDefaultBoolean.bDefault;
    property BorderColor: TdxAlphaColor index BorderColorIndex read GetColorValue write SetColorValue default TdxAlphaColors.Default;
    property BorderThickness: Single read FBorderThickness write SetBorderThickness stored IsBorderThicknessStored;
    property FillOptions: TdxFillOptions read FFillOptions write SetFillOptions;
    property FontOptions: TdxFontOptions read FFontOptions write SetFontOptions;
    property TextColor: TdxAlphaColor index TextColorIndex read GetColorValue write SetColorValue default TdxAlphaColors.Default;
    property LookAndFeelPainter: TcxCustomLookAndFeelPainter read GetLookAndFeelPainter;
    property Margins: TcxMargin read FMargins write SetMargins;
    property OwnerElement: IdxChartVisualElement read FOwnerElement;
    property Padding: TcxMargin read FPadding write SetPadding;
    property ParentBackground: Boolean read FParentBackground write SetParentBackground stored IsParentBackgroundStored;
    property PenColor: TdxAlphaColor index PenColorIndex read GetColorValue write SetColorValue default TdxAlphaColors.Default;
    property ScaleFactor: TdxScaleFactor read GetScaleFactor;
    property StrokeOptions: TdxStrokeOptions read FStrokeOptions write SetStrokeOptions;
  public
    constructor Create(AOwner: TPersistent); overload; override;
    constructor Create(AOwner: TPersistent; AParent: TdxChartVisualElementAppearance); reintroduce; overload; virtual;
    destructor Destroy; override;
  end;

  { TdxChartColorizedAppearance }

  TdxChartColorizedAppearance = class(TdxChartVisualElementAppearance)
  strict private
    FActualColor: TdxAlphaColor;
    FActualColor2: TdxAlphaColor;
    FIndex: Integer;
    FPaletteEntry: TdxChartColorSchemePaletteEntry;
    function GetActualColorProperty(AIndex: Integer): TdxAlphaColor; inline;
    procedure SetIndex(AValue: Integer);
  protected
    procedure ApplyColors(AColor, AColor2: TdxAlphaColor);
    function DefaultBorder: Boolean; override;
    function DefaultBorderThickness: Single; override;
    procedure DoAssign(ASource: TPersistent); override;
    procedure DoChanged; override;
    function GetActualColor(AIndex: Integer): TdxAlphaColor; override;
    function GetActualMargins: TRect; override;
    function GetActualPadding: TRect; override;
    function HasFillOptions: Boolean; override;
    function HasFontOptions: Boolean; override;
    function HasStrokeOptions: Boolean; override;
    procedure ParentChanged;
    procedure Notification(AParentChanges: TdxChartVisualElementAppearance.TAppearanceChanges); override;
    procedure SetParent(AParent: TdxChartVisualElementAppearance); override;
    procedure UpdateActualValues(ACanvas: TcxCustomCanvas); override;
    procedure UpdateColorizedColors; virtual;

    property PaletteEntry: TdxChartColorSchemePaletteEntry read FPaletteEntry;
  public
    constructor Create(AParent: TdxChartVisualElementAppearance; AIndex: Integer); reintroduce; virtual;
    procedure Validate(ACanvas: TcxCustomCanvas);

    property ActualBorderColor;
    property ActualBorderThickness;
    property ActualBrush;
    property ActualColor: TdxAlphaColor index TdxChartVisualElementAppearance.ColorIndex read GetActualColorProperty;
    property ActualColor2: TdxAlphaColor index TdxChartVisualElementAppearance.Color2Index read GetActualColorProperty;
    property ActualFont;
    property ActualMargins;
    property ActualPadding;
    property ActualPen;
    property ActualTextColor: TdxAlphaColor index TdxChartVisualElementAppearance.TextColorIndex read GetActualColorProperty;
    property ColorScheme;
    property Index: Integer read FIndex write SetIndex;
    property LookAndFeelPainter;
    property UseRightToLeftAlignment;
    property UseRightToLeftReading;
  end;

  { TdxChartVisualElementTitleViewInfo }

  TdxChartVisualElementTitleViewInfo = class(TdxChartVisualElementCustomViewInfo)
  strict private
    FHasText: Boolean;
    FTitle: TdxChartVisualElementTitle;
    FTextBounds: TdxRectF;
    FTextLayout: TcxCanvasBasedTextLayout;
    function GetTextSize: TdxSizeF;
  protected
    function CalculateTextFlags: Cardinal;
    procedure DoCalculate(ACanvas: TcxCustomCanvas); override;
    procedure DoDraw(ACanvas: TcxCustomCanvas); override;
    procedure FreeCanvasBasedResources; override;
    function GetHitElement(const P: TdxPointF): IdxChartHitTestElement; override;
    procedure UpdateTextColors; override;

//    property HasText: Boolean read FHasText;
    property TextLayout: TcxCanvasBasedTextLayout read FTextLayout;
  public
    constructor Create(AOwner: TdxChartVisualElementTitle); reintroduce; virtual;
    destructor Destroy; override;
    procedure AdjustContent(var ABounds: TdxRectF);
    procedure UpdateBounds(const ABounds: TdxRectF); override;

    property Title: TdxChartVisualElementTitle read FTitle;
    property TextBounds: TdxRectF read FTextBounds;
    property TextSize: TdxSizeF read GetTextSize;
  end;

  { TdxChartVisualElementTitleAppearance }

  TdxChartVisualElementTitleAppearance = class(TdxChartVisualElementAppearance)
  strict private
    function GetFontOptions: TdxChartVisualElementFontOptions;
    procedure SetFontOptions(AValue: TdxChartVisualElementFontOptions);
  protected
    function DefaultParentBackground: Boolean; override;
    function GetActualColor(AIndex: Integer): TdxAlphaColor; override;
    function GetActualPadding: TRect; override;
    function HasFillOptions: Boolean; override;
  published
    property Border;
    property BorderColor;
    property BorderThickness;
    property FillOptions;
    property FontOptions: TdxChartVisualElementFontOptions read GetFontOptions write SetFontOptions;
    property Margins;
    property TextColor;
  end;

  { TdxChartTitleAppearance }

  TdxChartTitleAppearance = class(TdxChartVisualElementTitleAppearance)
  protected
    function HasFontOptions: Boolean; override;
  end;

  { TdxChartVisualElementTitle }

  TdxChartVisualElementTitle = class abstract(TdxChartCustomVisualElement, IdxDefaultFontScaleFactorProvider)
  public const
    DefaultTitleSize: Integer = 12;
    PositionToSide: array[TdxChartTitlePosition] of TcxBorder = (bTop, bLeft, bTop, bRight, bBottom); 
  strict private
    FAlignment: TdxAlignment;
    FIsTextChanged: Boolean;
    FMaxLineCount: Integer;
    FPosition: TdxChartTitlePosition;
    FText: string;
    FWordWrap: Boolean;
    function GetAppearance: TdxChartVisualElementTitleAppearance;
    function GetViewInfo: TdxChartVisualElementTitleViewInfo;
    function IsWordWrapStored: Boolean;
    procedure SetAlignment(AValue: TdxAlignment);
    procedure SetAppearance(AValue: TdxChartVisualElementTitleAppearance);
    procedure SetMaxLineCount(AValue: Integer);
    procedure SetPosition(AValue: TdxChartTitlePosition);
    procedure SetText(AValue: string);
    procedure SetWordWrap(AValue: Boolean);
  protected
    //IdxDefaultFontScaleFactorProvider
    function GetDefaultFontScaleFactor: Single; virtual;
    function IdxDefaultFontScaleFactorProvider.GetScaleFactor = GetDefaultFontScaleFactor;

    function ActuallyVisible: Boolean; override;
    procedure CalculateAndAdjustContent(ACanvas: TcxCustomCanvas; var ABounds: TdxRectF); virtual;
    function CreateAppearance: TdxChartVisualElementAppearance; override;
    function CreateViewInfo: TdxChartVisualElementCustomViewInfo; override;
    procedure DoAssign(Source: TPersistent); override;
    function GetActualDisplayText: string; virtual;
    function GetActualDockPosition: TdxChartTitlePosition; virtual;
    function GetChart: TdxChart; override;
    function GetDefaultWordWrap: Boolean; virtual;
    class function GetHitCode: TdxChartHitCode; virtual; abstract;
    function GetOwnerComponent: TComponent; virtual; abstract;
    function GetText: string; virtual;
    function SamePosition(APosition: TdxChartTitlePosition): Boolean;

    property ActualDockPosition: TdxChartTitlePosition read GetActualDockPosition;
    property Position: TdxChartTitlePosition read FPosition write SetPosition default TdxChartTitlePosition.Default;
    property Text: string read GetText write SetText;
    property ViewInfo: TdxChartVisualElementTitleViewInfo read GetViewInfo;
  public
    constructor Create(AOwner: TPersistent); override;
  published
    property Appearance: TdxChartVisualElementTitleAppearance read GetAppearance write SetAppearance;
    property Alignment: TdxAlignment read FAlignment write SetAlignment default TdxAlignment.Default;
    property MaxLineCount: Integer read FMaxLineCount write SetMaxLineCount default 0;
    property WordWrap: Boolean read FWordWrap write SetWordWrap stored IsWordWrapStored;
    property Visible;
  end;

  { TdxChartTitle }

  TdxChartTitle = class(TdxChartVisualElementTitle)
  public const
    DefaultChartTitleSize: Integer = 18;
  protected
    function ActuallyVisible: Boolean; override;
    function GetDefaultFontScaleFactor: Single; override;
    function GetOwnerComponent: TComponent; override;
    class function GetHitCode: TdxChartHitCode; override;
  published
    property Position;
    property Text;
  end;

  { TdxChartDiagramTitle }

  TdxChartDiagramTitle = class(TdxChartVisualElementTitle)
  public const
    DefaultChartTitleSize: Integer = 10;
  strict private

    function GetDiagram: TdxChartCustomDiagram;
  protected
    function ActuallyVisible: Boolean; override;
    function GetDefaultFontScaleFactor: Single; override;
    class function GetHitCode: TdxChartHitCode; override;
    function GetOwnerComponent: TComponent; override;
    function GetParentElement: IdxChartVisualElement; override;
  public
    property Diagram: TdxChartCustomDiagram read GetDiagram;
  published
    property Text;
  end;

  { TdxChartLegendTitle }

  TdxChartLegendTitle = class(TdxChartVisualElementTitle)
  private
    function GetLegend: TdxChartCustomLegend;
  protected
    function ActuallyVisible: Boolean; override;
    class function GetHitCode: TdxChartHitCode; override;
    function GetOwnerComponent: TComponent; override;
    function GetParentElement: IdxChartVisualElement; override;
    procedure VisibleChanged; override;
  public
    constructor Create(AOwner: TdxChartCustomLegend); reintroduce;
    property Legend: TdxChartCustomLegend read GetLegend;
  published
    property Position;
    property Text;
  end;

  {TdxChartSeriesTitle }

  TdxChartSeriesTitle = class(TdxChartVisualElementTitle)
  strict private
    function GetSeries: TdxChartCustomSeries; inline;
  protected
    function GetChart: TdxChart; override;
    class function GetHitCode: TdxChartHitCode; override;
    function GetOwnerComponent: TComponent; override;
    function GetParentElement: IdxChartVisualElement; override;
  public
    property Series: TdxChartCustomSeries read GetSeries;
  published
    property Text;
  end;

  { TdxChartTitleCollectionItem }

  TdxChartTitleCollectionItem = class(TcxInterfacedCollectionItem, IdxChartVisualElement)
  strict private
    FTitle: TdxChartTitle;
    function GetAlignment: TdxAlignment;
    function GetAppearance: TdxChartVisualElementTitleAppearance;
    function GetChart: TdxChart;
    function GetParentAppearance: TdxChartVisualElementAppearance;
    function GetParentElement: IdxChartVisualElement;
    function GetPosition: TdxChartTitlePosition;
    function GetMaxLineCount: Integer;
    function GetText: string;
    function GetVisible: Boolean;
    function GetWordWrap: Boolean;
    procedure LayoutChanged;
    procedure SetAlignment(AValue: TdxAlignment);
    procedure SetAppearance(AValue: TdxChartVisualElementTitleAppearance);
    procedure SetPosition(AValue: TdxChartTitlePosition);
    procedure SetMaxLineCount(AValue: Integer);
    procedure SetText(const AValue: string);
    procedure SetVisible(AValue: Boolean);
    procedure SetWordWrap(AValue: Boolean);
    procedure StyleChanged;
    procedure TextColorChanged;
    function IdxChartVisualElement.GetAppearance = GetParentAppearance;
  protected
    function ActuallyVisible: Boolean;
    function CreateTitle: TdxChartTitle; virtual;

    property Chart: TdxChart read GetChart;
    property Title: TdxChartTitle read FTitle;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Appearance: TdxChartVisualElementTitleAppearance read GetAppearance write SetAppearance;
    property Alignment: TdxAlignment read GetAlignment write SetAlignment default TdxAlignment.Default;
    property Position: TdxChartTitlePosition read GetPosition write SetPosition default TdxChartTitlePosition.Default;
    property MaxLineCount: Integer read GetMaxLineCount write SetMaxLineCount default 0;
    property Text: string read GetText write SetText;
    property Visible: Boolean read GetVisible write SetVisible default True;
    property WordWrap: Boolean read GetWordWrap write SetWordWrap default False;
  end;

  { TdxChartTitles }

  TdxChartTitles = class(TcxOwnedInterfacedCollection)
  strict private
    FChart: TdxChart;
    FVisible: Boolean;
    function GetItem(AIndex: Integer): TdxChartTitleCollectionItem;
    procedure SetItem(AIndex: Integer; AValue: TdxChartTitleCollectionItem);
    procedure SetVisible(AValue: Boolean);
  protected
    procedure BiDiModeChanged;
    function GetVisibleCount: Integer;
    procedure LayoutChanged;
    procedure Update(Item: TCollectionItem); override;
    property Chart: TdxChart read FChart;
  public
    constructor Create(AOwner: TdxChart); reintroduce; virtual;
    procedure Assign(Source: TPersistent); override;
    function Add: TdxChartTitleCollectionItem;
  public
    property Items[Index: Integer]: TdxChartTitleCollectionItem read GetItem write SetItem; default;
  published
    property Visible: Boolean read FVisible write SetVisible default True;
  end;


  { TdxChartLegendCustomViewData }

  TdxChartLegendCustomViewData = class(TdxChartCustomItemViewData)
  protected
    procedure AddItem(const AItem: IdxChartLegendItem); virtual; abstract;
    procedure Clear; virtual; abstract;
    function IsEmpty: Boolean; virtual; abstract;
  end;

  { TdxChartLegendAppearance }

  TdxChartLegendAppearance = class(TdxChartVisualElementAppearance)
  public const
    DefaultCaptionOffset: Single = 4;
    DefaultImageOffset: Single = 5;
    DefaultImageSize: TdxSizeF = (cx: 20; cy: 16);
    DefaultItemIndent: TdxSizeF = (cx: 12; cy: 2);
  strict private
    FActualCheckBoxSize: TdxSizeF;
    FActualItemBoxPadding: TRect;
    FCaptionOffset: Single;
    FImageOffset: Single;
    FImageSize: TdxSizeFloat;
    FItemIndent: TdxSizeFloat;
    FItemBoxPadding: TcxMargin;
    function GetFontOptions: TdxChartVisualElementFontOptions;
    function IsCaptionOffsetStored: Boolean;
    function IsImageOffsetStored: Boolean;
    procedure SetCaptionOffset(AValue: Single);
    procedure SetFontOptions(AValue: TdxChartVisualElementFontOptions);
    procedure SetImageOffset(AValue: Single);
    procedure SetImageSize(const AValue: TdxSizeFloat);
    procedure SetItemIndent(AValue: TdxSizeFloat);
    procedure SetItemBoxPadding(AValue: TcxMargin);
    procedure SizeChangeHandler(Sender: TObject);
  protected
    procedure ChangeScaleCore(M, D: Integer); override;
    function DefaultBorder: Boolean; override;
    procedure DoAssign(Source: TPersistent); override;
    function GetActualColor(AIndex: Integer): TdxAlphaColor; override;
    function GetActualItemBoxPadding: TRect; virtual;
    function GetActualMargins: TRect; override;
    function HasFillOptions: Boolean; override;
    function HasFontOptions: Boolean; override;
    procedure UpdateActualValues(ACanvas: TcxCustomCanvas); override;
  public
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;

  {$REGION 'for internal use only'}
    property ActualCheckBoxSize: TdxSizeF read FActualCheckBoxSize;
    property ActualColor;
    property ActualFont;
    property ActualItemBoxPadding: TRect read FActualItemBoxPadding;
    property ActualTextColor;
    property LookAndFeelPainter;
    property UseRightToLeftReading;
  {$ENDREGION}
  published
    property CaptionOffset: Single read FCaptionOffset write SetCaptionOffset stored IsCaptionOffsetStored;  
    property ImageOffset: Single read FImageOffset write SetImageOffset stored IsImageOffsetStored; 
    property ImageSize: TdxSizeFloat read FImageSize write SetImageSize;
    property ItemIndent: TdxSizeFloat read FItemIndent write SetItemIndent;  
    property ItemBoxPadding: TcxMargin read FItemBoxPadding write SetItemBoxPadding;

    property Border;
    property BorderColor;
    property BorderThickness;
    property FillOptions;
    property FontOptions: TdxChartVisualElementFontOptions read GetFontOptions write SetFontOptions;
    property Margins;
    property ParentBackground;
    property TextColor;
  end;

  { TdxChartCustomLegend }

  TdxChartCustomLegend = class(TdxChartCustomVisualElement)
  private const
    AlignHorzToAlign: array[TdxChartLegendAlignment] of TdxAlignment =
      (TdxAlignment.Far, TdxAlignment.Near, TdxAlignment.Near, TdxAlignment.Center, TdxAlignment.Far, TdxAlignment.Far);
    AlignVertToAlign: array[TdxChartLegendAlignment] of TdxAlignment =
      (TdxAlignment.Far, TdxAlignment.Near, TdxAlignment.Near, TdxAlignment.Center, TdxAlignment.Far, TdxAlignment.Far);
  public const
    DefaultMaxCaptionWidth = 120.0;
    DefaultMaxSizePercent = 100.0;
  strict private
    FAlignmentHorz: TdxChartLegendAlignment;
    FAlignmentVert: TdxChartLegendAlignment;
    FDirection: TdxChartLegendDirection;
    FImages: TCustomImageList;
    FImagesChangeLink: TChangeLink;
    FImagesNotifyComponent: TcxFreeNotificator;
    FMaxCaptionWidth: Single;
    FMaxHeightPercent: Single;
    FMaxWidthPercent: Single;
    FShowCaptions: Boolean;
    FShowCheckBoxes: Boolean;
    FShowImages: Boolean;
    FTitle: TdxChartLegendTitle;
    FViewData: TdxChartLegendCustomViewData;
    function IsMaxCaptionWidthStored: Boolean;
    function IsMaxHeightPercentStored: Boolean;
    function IsMaxWidthPercentStored: Boolean;
    function GetAppearance: TdxChartLegendAppearance;
    procedure SetAlignmentHorz(AValue: TdxChartLegendAlignment);
    procedure SetAlignmentVert(AValue: TdxChartLegendAlignment);
    procedure SetAppearance(AValue: TdxChartLegendAppearance);
    procedure SetDirection(AValue: TdxChartLegendDirection);
    procedure SetImages(AValue: TCustomImageList);
    procedure SetMaxCaptionWidth(AValue: Single);
    procedure SetMaxHeightPercent(AValue: Single);
    procedure SetMaxWidthPercent(AValue: Single);
    procedure SetShowCaptions(AValue: Boolean);
    procedure SetShowCheckBoxes(AValue: Boolean);
    procedure SetShowImages(AValue: Boolean);
    procedure SetTitle(AValue: TdxChartLegendTitle);
  protected
    function ActualAlignment(AAlignment, ADefaultAlignment: TdxChartLegendAlignment): TdxChartLegendAlignment;
    function ActuallyVisible: Boolean; override;
    procedure AddItem(const AItem: IdxChartLegendItem);
    procedure CalculateAndAdjustContent(ACanvas: TcxCustomCanvas; var ABounds: TdxRectF); virtual;
    procedure ChangeScale(M, D: Integer); override;
    procedure Clear;
    function CreateAppearance: TdxChartVisualElementAppearance; override;
    function CreateTitle: TdxChartLegendTitle; virtual;
    function CreateViewData: TdxChartLegendCustomViewData; virtual;
    function CreateViewInfo: TdxChartVisualElementCustomViewInfo; override;
    procedure DataChanged(ANotifyOwner: Boolean = False);
    procedure DoAssign(Source: TPersistent); override;
    function GetDefaultAlignmentHorz: TdxChartLegendAlignment; virtual;
    function GetDefaultAlignmentVert: TdxChartLegendAlignment; virtual;
    procedure ImagesChanged(Sender: TObject);
    procedure ImagesFreeNotification(AComponent: TComponent);
    procedure Invalidate; override;
    function IsOutside: Boolean;

    property Images: TCustomImageList read FImages write SetImages; 
    property ViewData: TdxChartLegendCustomViewData read FViewData;
  public
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;
  published
    property Appearance: TdxChartLegendAppearance read GetAppearance write SetAppearance;
    property AlignmentHorz: TdxChartLegendAlignment read FAlignmentHorz write SetAlignmentHorz default TdxChartLegendAlignment.Default;
    property AlignmentVert: TdxChartLegendAlignment read FAlignmentVert write SetAlignmentVert default TdxChartLegendAlignment.Default;
    property Direction: TdxChartLegendDirection read FDirection write SetDirection default TdxChartLegendDirection.TopToBottom;
    property MaxCaptionWidth: Single read FMaxCaptionWidth write SetMaxCaptionWidth stored IsMaxCaptionWidthStored;
    property MaxHeightPercent: Single read FMaxHeightPercent write SetMaxHeightPercent stored IsMaxHeightPercentStored;
    property MaxWidthPercent: Single read FMaxWidthPercent write SetMaxWidthPercent stored IsMaxWidthPercentStored;
    property ShowCaptions: Boolean read FShowCaptions write SetShowCaptions default True;
    property ShowCheckBoxes: Boolean read FShowCheckBoxes write SetShowCheckBoxes default True;
    property ShowImages: Boolean read FShowImages write SetShowImages default True;
    property Title: TdxChartLegendTitle read FTitle write SetTitle;
    property Visible;
  end;

  { TdxChartLegend }

  TdxChartLegend = class(TdxChartCustomLegend)
  protected
    function GetChart: TdxChart; override;
    function GetOwner: TPersistent; override;
  end;

  { TdxChartDiagramLegend }

  TdxChartDiagramLegend = class(TdxChartCustomLegend)
  strict private
    function GetDiagram: TdxChartCustomDiagram;
  protected
    function ActuallyVisible: Boolean; override;
    function GetChart: TdxChart; override;
    function GetDefaultAlignmentHorz: TdxChartLegendAlignment; override;
  public
    property Diagram: TdxChartCustomDiagram read GetDiagram;
  end;

  { TdxChartSeriesViewAppearance }

  TdxChartSeriesViewAppearance = class(TdxChartVisualElementAppearance)
  private
    function GetSeries: TdxChartCustomSeries; inline;
    function GetView: TdxChartSeriesCustomView; inline;
  protected
    function GetActualColor(AIndex: Integer): TdxAlphaColor; override;

    property Series: TdxChartCustomSeries read GetSeries;
    property View: TdxChartSeriesCustomView read GetView;
  end;

  { TdxChartCustomLabelsAppearance }

  TdxChartCustomLabelsAppearance = class(TdxChartVisualElementAppearance)
  strict private
    function GetFontOptions: TdxChartVisualElementFontOptions;
    procedure SetFontOptions(AValue: TdxChartVisualElementFontOptions);
  protected
    function GetActualColor(AIndex: Integer): TdxAlphaColor; override;
    function GetLineOptions: TdxStrokeOptions; inline;
    function HasFillOptions: Boolean; override;
    function HasFontOptions: Boolean; override;
    function HasStrokeOptions: Boolean; override;
    procedure SetLineOptions(AValue: TdxStrokeOptions); inline;

    property LineOptions: TdxStrokeOptions read GetLineOptions write SetLineOptions;
  published
    property Border;
    property BorderColor;
    property BorderThickness;
    property FontOptions: TdxChartVisualElementFontOptions read GetFontOptions write SetFontOptions;
    property FillOptions;
    property Padding;
    property TextColor;
  end;

  { TdxChartCustomLabels }

  TdxChartCustomLabels = class(TdxChartVisualElementPersistent)
  strict private
    FAngle: Single;
    FLineLength: Single;
    FLineVisible: TdxDefaultBoolean;
    FMaxLineCount: Integer;
    FMaxWidth: Single;
    FResolveOverlappingIndent: Single;
    FTextAlignment: TdxAlignment;
    FTextAngle: Single;
    FTextFormatter: TObject;
    FValueProvider: TdxChartAxisNamedValueProvider;
    function GetAppearance: TdxChartCustomLabelsAppearance; inline;
    function GetTextFormat: TdxChartTextFormat;
    procedure SetAngle(AValue: Single);
    procedure SetAppearance(AValue: TdxChartCustomLabelsAppearance);
    procedure SetLineLength(AValue: Single);
    procedure SetLineVisible(AValue: TdxDefaultBoolean);
    procedure SetMaxWidth(AValue: Single);
    procedure SetMaxLineCount(AValue: Integer);
    procedure SetResolveOverlappingIndent(AValue: Single);
    procedure SetTextAlignment(AValue: TdxAlignment);
    procedure SetTextFormat(const AValue: TdxChartTextFormat);
    //
    function IsAngleStored: Boolean;
    function IsLineLengthStored: Boolean;
    function IsMaxWidthStored: Boolean;
    function IsResolveOverlappingIndentStored: Boolean;
  protected
    procedure ChangeScale(M, D: Integer); override;
    function CreateAppearance: TdxChartVisualElementAppearance; override;
    procedure DoAssign(Source: TPersistent); override;
    function GetActualColor(AIndex: Integer): TdxAlphaColor; virtual;
    function GetDefaultAngle: Single; virtual;
    function GetDefaultLineLength: Single; virtual;
    function GetDefaultMaxWidth: Single; virtual;
    function GetDefaultResolveOverlappingIndent: Single; virtual;
    function GetDefaultTextAngle: Single; virtual;
    function GetFormattedValue(const AValue: Variant; const AGetVariable: TdxChartNamedValueProvider = nil): string; virtual;
    function GetTextFormatter: TObject; virtual;
    function GetValueAsText(const AValue: Variant): string; virtual;
    procedure ResolveOverlappingIndentChanged; virtual; // for internal use
    procedure UpdateResolveOverlappingIndent(AValue: Single); // for internal use

    property Angle: Single read FAngle write SetAngle stored IsAngleStored;
    property Appearance: TdxChartCustomLabelsAppearance read GetAppearance write SetAppearance;
    property LineLength: Single read FLineLength write SetLineLength stored IsLineLengthStored;
    property LineVisible: TdxDefaultBoolean read FLineVisible write SetLineVisible default TdxDefaultBoolean.bDefault;
    property MaxLineCount: Integer read FMaxLineCount write SetMaxLineCount default 0;
    property MaxWidth: Single read FMaxWidth write SetMaxWidth stored IsMaxWidthStored;
    property TextFormat: TdxChartTextFormat read GetTextFormat write SetTextFormat;
    property TextFormatter: TObject read GetTextFormatter;
    property ResolveOverlappingIndent: Single read FResolveOverlappingIndent write SetResolveOverlappingIndent stored IsResolveOverlappingIndentStored;
    property TextAlignment: TdxAlignment read FTextAlignment write SetTextAlignment default TdxAlignment.Default;
  public
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;
  end;

  { TdxChartSeriesValueLabelAppearance }

  TdxChartSeriesValueLabelAppearance = class(TdxChartCustomLabelsAppearance)
  strict private
    function GetViewAppearance: TdxChartSeriesViewAppearance; inline;
  protected
    function DefaultBorder: Boolean; override;
    function DefaultParentBackground: Boolean; override;
    function GetActualColor(AIndex: Integer): TdxAlphaColor; override;

    property ViewAppearance: TdxChartSeriesViewAppearance read GetViewAppearance;
  published
    property LineOptions: TdxStrokeOptions read GetLineOptions write SetLineOptions;
  end;

  { TdxChartSeriesValueLabels }

  TdxChartSeriesValueLabels = class(TdxChartCustomLabels)
  strict private
    function GetAppearance: TdxChartSeriesValueLabelAppearance; inline;
    function GetSeries: TdxChartCustomSeries; inline;
    function GetView: TdxChartSeriesCustomView; inline;
    procedure SetAppearance(AValue: TdxChartSeriesValueLabelAppearance);
  protected
    function ActuallyVisible: Boolean; override;
    function CreateAppearance: TdxChartVisualElementAppearance; override;
    function GetChart: TdxChart; override;
    function GetDefaultAngle: Single; override;
    function GetDefaultLineLength: Single; override;
    function GetDefaultVisible: Boolean; override;
    function GetParentElement: IdxChartVisualElement; override;
    function GetResolveOverlappingMode: TdxChartSeriesValueLabelsResolveOverlappingMode; virtual; //for internal use

    property Series: TdxChartCustomSeries read GetSeries;
    property View: TdxChartSeriesCustomView read GetView;
  published
    property Appearance: TdxChartSeriesValueLabelAppearance read GetAppearance write SetAppearance;
    // inherited published
    property LineLength;
    property LineVisible;
    property MaxLineCount;
    property MaxWidth;
    property ResolveOverlappingIndent;
    property TextAlignment;
    property TextFormat;
    property Visible;
  end;

  { TdxChartValueLabelCustomViewInfo }

  TdxChartValueLabelCustomViewInfo = class(TdxChartCustomItemViewInfo)
  public const
    AutoMaxLineCount: Integer = 2;
  protected type
    TLeaderLineType = (None, TwoPoints, ThreePoints);
  strict private
    FCalculatedMaxLineCount: Integer;
    FCalculatedMaxWidth: Single;
    FEndPoint: TdxPointF;
    FLeaderLineType: TLeaderLineType;
    FMiddlePoint: TdxPointF;
    FOwner: TObject;
    FStartPoint: TdxPointF;
    FTextBounds: TdxRectF;
    FTextLayout: TcxCanvasBasedTextLayout;
    function GetAppearance: TdxChartSeriesValueLabelAppearance;
    function GetTextSize: TdxSizeF;
    function GetWordWrap: Boolean;
  protected
    procedure CalculateLeaderLineType;
    function CalculateTextFlags: Cardinal;
    procedure CalculateTextLayout;
    function CalculateValidBounds(const ABoundingRect: TdxRectF): TdxRectF; virtual;
    procedure CreateTextLayout(ACanvas: TcxCustomCanvas); virtual;
    procedure DoCalculate(ACanvas: TcxCustomCanvas); override;
    procedure DoDraw(ACanvas: TcxCustomCanvas); override;
    function GetActualMaxLineCount: Integer;
    function GetActualMaxWidth: Single;
    function GetActualPen: TcxCanvasBasedPen; virtual;
    function GetColor: TdxAlphaColor; virtual;
    function GetDisplayText: string; virtual; abstract;
    function GetFont: TcxCanvasBasedFont; virtual;
    function GetOptions: TdxChartCustomLabels; virtual; abstract;
    procedure GetPoints(var ACenterPoint, AStartPoint, AMiddlePoint, AEndPoint: TdxPointF); virtual;
    function GetTextAlignment: TdxAlignment; virtual;
    function GetTextAngle: Single; virtual;
    function GetTextLayoutConstraints: TdxRectF; virtual;
    function GetValue: Variant; virtual; abstract;
    function IsTextTruncated: Boolean;
    procedure Realign(const ACenterPoint: TdxPointF); overload; virtual;
    procedure Realign; overload; virtual;
    procedure ResetCalculatedConstraints;
    procedure UpdateBounds; overload; virtual;
    procedure Validate(const ABoundingRect: TdxRectF);

    property LeaderLineType: TLeaderLineType read FLeaderLineType;
    property Owner: TObject read FOwner;
    property Options: TdxChartCustomLabels read GetOptions;
    property TextSize: TdxSizeF read GetTextSize;
    property WordWrap: Boolean read GetWordWrap;
  public
    constructor Create(AOwner: TObject); virtual;
    destructor Destroy; override;

    property Appearance: TdxChartSeriesValueLabelAppearance read GetAppearance;
    property DisplayText: string read GetDisplayText;
    property EndPoint: TdxPointF read FEndPoint;
    property MiddlePoint: TdxPointF read FMiddlePoint;
    property StartPoint: TdxPointF read FStartPoint;
    property TextBounds: TdxRectF read FTextBounds;
    property Value: Variant read GetValue;
  end;

  { TdxChartSeriesValueLabelViewInfo }

  TdxChartSeriesValueLabelViewInfo = class(TdxChartValueLabelCustomViewInfo)
  private const
    BackgroundSubAreaCode = 0;
    TextSubAreaCode = 1;
  strict private
    function GetOwner: TdxChartSeriesValueViewInfo; inline;
    function GetSeriesValueLabels: TdxChartSeriesValueLabels; inline;
  protected
    function GetDisplayText: string; override;
    function GetHitElement(const P: TdxPointF): IdxChartHitTestElement; override;
    function GetOptions: TdxChartCustomLabels; override;
    procedure GetPoints(var ACenter, AStartPoint, AMiddlePoint, AEndPoint: TdxPointF); override;
    function GetValue: Variant; override;

    property Options: TdxChartSeriesValueLabels read GetSeriesValueLabels;
  public
    property Owner: TdxChartSeriesValueViewInfo read GetOwner;
  end;

  { TdxChartSeriesValueLabelViewInfoList }

  TdxChartSeriesValueLabelViewInfoList = class(TdxList<TdxChartSeriesValueLabelViewInfo>); // for internal use

  { TdxChartSeriesCustomView }

  TdxChartSeriesCustomView = class(TdxChartVisualElementPersistent)
  public const
    DefaultLineLength: Single = 10;
  strict private
    FValueLabels: TdxChartSeriesValueLabels;
    FViewData: TdxChartSeriesViewCustomViewData;
    FViewInfo: TdxChartSeriesViewCustomViewInfo;
    function GetAppearance: TdxChartSeriesViewAppearance; inline;
    function GetSeries: TdxChartCustomSeries; inline;
    procedure SetAppearance(AValue: TdxChartSeriesViewAppearance);
    procedure SetValueLabels(AValue: TdxChartSeriesValueLabels);
  protected
    function ActuallyLabelsVisible: Boolean; virtual;
    function ActuallyVisible: Boolean; override;
    procedure Calculate(ADiagram: TdxChartCustomDiagram; ACanvas: TcxCustomCanvas);
    procedure ChangeScale(M, D: Integer); override;
    class function CanAggregate(AView: TdxChartSeriesCustomView): Boolean; virtual;
    function CreateAppearance: TdxChartVisualElementAppearance; override;
    function CreateValueLabels: TdxChartSeriesValueLabels; virtual;
    function CreateViewData: TdxChartSeriesViewCustomViewData; virtual;
    function CreateViewInfo: TdxChartSeriesViewCustomViewInfo; virtual;
    procedure DoAssign(Source: TPersistent); override;
    function GetDefaultLabelAngle: Single; virtual;
    function GetDefaultLineLength: Single; virtual;
    function GetParentElement: IdxChartVisualElement; override;
    function GetValueLabelAppearanceClass: TdxChartSeriesValueLabelAppearanceClass; virtual;
    class function GetTypeName: string; virtual;
    class function IsEqual(AView: TdxChartSeriesCustomView): Boolean; virtual;
    procedure LayoutChanged; override;
    procedure StyleChanged; override;
    class procedure Register;
    class procedure UnRegister;

    property Appearance: TdxChartSeriesViewAppearance read GetAppearance write SetAppearance;
    property Chart: TdxChart read GetChart;
    property ViewData: TdxChartSeriesViewCustomViewData read FViewData;
    property ViewInfo: TdxChartSeriesViewCustomViewInfo read FViewInfo;
  public
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;

    class function GetDescription: string; virtual;
    class function GetViewImageIndex: Integer;
    class function GetViewImages(ADPI: Integer): TcxImageList;
    class function IsCompatibleWith(AView: TdxChartSeriesCustomView): Boolean; overload; virtual; // for internal use
    class function IsCompatibleWith(ASeriesClass: TdxChartSeriesClass): Boolean; overload; virtual; // for internal use

    property Series: TdxChartCustomSeries read GetSeries;
    property ValueLabels: TdxChartSeriesValueLabels read FValueLabels write SetValueLabels;
  end;

  { TdxChartSeriesViewCustomViewInfo }

  TdxChartSeriesViewCustomViewInfo = class(TdxChartVisualElementCustomViewInfo)
  strict private const
    ValuesGroupCount = 8; 
  strict private type
    TValueGroup = packed record
      Start, Finish: TdxChartSeriesValueViewInfo;
      FirstVisibleValue, LastVisibleValue: TdxChartSeriesValueViewInfo;
      function Empty: Boolean;
      procedure SetValue(const AValue: TdxChartSeriesValueViewInfo);
      procedure FindOutermostVisibleValues;
    end;
  strict private
    FColorizedItems: TdxFastObjectList;
    FGroup: TdxChartDiagramSeriesGroup;
    FListener: TdxChartVisualElementAppearance;
    FView: TdxChartSeriesCustomView;
    FViewData: TdxChartSeriesViewCustomViewData;
    function GetAppearance: TdxChartSeriesViewAppearance; inline;
    function GetDiagram: TdxChartCustomDiagram; inline;
    function GetDiagramViewInfo: TdxChartDiagramCustomViewInfo; inline;
    function GetMargins: TRect; inline;
    function GetPadding: TRect; inline;
    function GetSeries: TdxChartCustomSeries; inline;
    function GetTitle: TdxChartSeriesTitle; inline;
    function GetValueLabels: TdxChartSeriesValueLabels;
  protected type
    TForEachValueProc = reference to procedure(AValue: TdxChartSeriesValueViewInfo);
  protected const
    MaxCapacity: Integer = 1024;
  protected
    FCount: Integer;
    FFirstValue: TdxChartSeriesValueViewInfo;
    FLastValue: TdxChartSeriesValueViewInfo;
    FFirstVisibleValue: TdxChartSeriesValueViewInfo;
    FLastVisibleValue: TdxChartSeriesValueViewInfo;
    FTotalCount: Integer;
    FValuesGroups: array[0..ValuesGroupCount - 1] of TValueGroup;
    //
    FDrawLabels: Boolean;
    FIndex: Integer;
    FSeriesBounds: TdxRectF;
    FSeriesIndexInGroup: Integer;
    FShowInLegend: Boolean;
    procedure CalculateCanvasValue(const AValue: TdxChartSeriesValueViewInfo); virtual;
    function CalculateHitTest(AHitTest: TdxChartHitTestEngine; const P: TdxPointF): Boolean; override;
    procedure CalculateLabels(ACanvas: TcxCustomCanvas); virtual;
    function CalculateLabelsHitTest(AHitTest: TdxChartHitTestEngine; const P: TdxPointF): Boolean;
    procedure CalculateValues(ACanvas: TcxCustomCanvas); virtual;
    procedure ClearValues; virtual;
    function GetColorizedAppearance(AIndex: Integer): TdxChartColorizedAppearance; overload;
    function CreateValueViewInfo(const ARecord: PdxDataRecord; const APriorValue: TdxChartSeriesValueViewInfo): TdxChartSeriesValueViewInfo; virtual;

    procedure DoCalculate(ACanvas: TcxCustomCanvas); override;
    procedure DoDraw(ACanvas: TcxCustomCanvas); override;
    procedure DoDrawLabels(ACanvas: TcxCustomCanvas); virtual;
    procedure DrawLegendGlyph(ACanvas: TcxCustomCanvas; const R: TdxRectF); virtual;
    procedure DrawValue(ACanvas: TcxCustomCanvas; const AValue: TdxChartSeriesValueViewInfo); virtual;
    procedure DrawValueLabel(ACanvas: TcxCustomCanvas; const AValue: TdxChartSeriesValueViewInfo); virtual;
    procedure DrawValues(ACanvas: TcxCustomCanvas); virtual;
    procedure ForEachValue(AProc: TForEachValueProc);
    procedure ForEachVisibleValue(AProc: TForEachValueProc);
    function GetHitElement(const P: TdxPointF): IdxChartHitTestElement; override;
    function GetLegendItemColor: TdxAlphaColor; virtual;
    function GetValueLabelVisibleBounds: TdxRectF; virtual;
    procedure GetVisibleValueLabels(ALabelsList: TdxChartSeriesValueLabelViewInfoList);
    function GetValueViewInfoClass: TdxChartSeriesValueViewInfoClass; virtual;
    function NeedDisplayTextCalculation: Boolean; virtual;
    function NeedValuesResampling: Boolean; virtual;
    procedure PrepareItems(ARecords: TdxFastList); virtual;
    procedure PrepareValuesToCanvasValues; virtual;
    procedure ResampleValues(const AStartValue, AFinishValue: TdxChartSeriesValueViewInfo); virtual;
    procedure SetGroup(AGroup: TdxChartDiagramSeriesGroup; AIndex: Integer = 0);
    procedure ValidateValueLabels; virtual;
    procedure UpdateLabelsBoundingRect;

    property Appearance: TdxChartSeriesViewAppearance read GetAppearance;
    property ColorizedItems: TdxFastObjectList read FColorizedItems;
    property Count: Integer read FCount;
    property Diagram: TdxChartCustomDiagram read GetDiagram;
    property DiagramViewInfo: TdxChartDiagramCustomViewInfo read GetDiagramViewInfo;
    property DrawLabels: Boolean read FDrawLabels;
    property Group: TdxChartDiagramSeriesGroup read FGroup;
    property Index: Integer read FIndex;
    property Margins: TRect read GetMargins;
    property Padding: TRect read GetPadding;
    property Series: TdxChartCustomSeries read GetSeries;
    property Title: TdxChartSeriesTitle read GetTitle;
    property ValueLabels: TdxChartSeriesValueLabels read GetValueLabels;
    property View: TdxChartSeriesCustomView read FView;
    property ViewData: TdxChartSeriesViewCustomViewData read FViewData;
  public
    constructor Create(AOwner: TdxChartSeriesCustomView); reintroduce; virtual;
    destructor Destroy; override;
    procedure UpdateBounds(const ABounds: TdxRectF); override;

    property ContentBounds: TdxRectF read FContentBounds;
  end;

  { TdxChartSeriesViewCustomViewData }

  TdxChartSeriesViewCustomViewData = class(TdxChartCustomItemViewData)
  strict private
    FArgumentField: TdxStorageItem;
    FArgumentOffset: Cardinal;
    FMaxValue: TdxChartSeriesValueViewInfo;
    FMinValue: TdxChartSeriesValueViewInfo;
    FOthersValue: Double;
    FSeries: TdxChartCustomSeries;
    FSummaryValue: Double;
    FTopValuesSummary: Double;
    FView: TdxChartSeriesCustomView;
    FVisibleCount: Integer;
    FValueField: TdxStorageItem;
    FValueOffset: Cardinal;

    function GetDiagram: TdxChartCustomDiagram; inline;
    function GetIsNumeric: Boolean;
    function GetTopNOptions: TdxChartSeriesTopNOptions; inline;
  protected
    function AllowSorting: Boolean; virtual;
    procedure ApplySorting(ARecords: TdxFastList);
    procedure ApplyTopNOptions(ARecords: TdxFastList);
    procedure CalculateSummary(ARecords: TdxFastList);
    procedure Changed; virtual;
    procedure CheckValue(AValue: TdxChartSeriesValueViewInfo); virtual;
    procedure ClearInfo; virtual;
    procedure DoCalculate; override;
    function GetValueAsFloat(ARecord: PdxDataRecord): Variant; inline;
    function IsSourceValueValid(ARecord: PdxDataRecord): Boolean; virtual;
    procedure PostPrepareValues; virtual;
    procedure PrepareItems(ARecords: TdxFastList); virtual;
    procedure PrepareValues; virtual;
    procedure RemoveInvalidValues(ARecords: TdxFastList);
    procedure UpdateReferences(APoints: TdxChartSeriesPoints);

    property ArgumentField: TdxStorageItem read FArgumentField;
    property Diagram: TdxChartCustomDiagram read GetDiagram;
    property IsNumeric: Boolean read GetIsNumeric;
    property MaxValue: TdxChartSeriesValueViewInfo read FMaxValue;
    property MinValue: TdxChartSeriesValueViewInfo read FMinValue;
    property OthersValue: Double read FOthersValue write FOthersValue;
    property TopValuesSummary: Double read FTopValuesSummary write FTopValuesSummary;
    property SummaryValue: Double read FSummaryValue write FSummaryValue;
    property TopNOptions: TdxChartSeriesTopNOptions read GetTopNOptions;
    property ValueField: TdxStorageItem read FValueField;
    property VisibleCount: Integer read FVisibleCount;
  public
    constructor Create(AOwner: TdxChartSeriesCustomView); virtual;

    function GetArgument(const ARecord: PdxDataRecord; var AValue: Double; var ADisplayText: string): Boolean; inline;
    function GetValue(const ARecord: PdxDataRecord; var AValue: Double; var ADisplayText: string): Boolean; inline;
    property Series: TdxChartCustomSeries read FSeries;
    property View: TdxChartSeriesCustomView read FView;
  end;

  { TdxChartSeriesPoints }

  TdxChartSeriesPoints = class
  strict private
    FArgumentField: TdxStorageItem;
    FArgumentOffset: Cardinal;
    FCustomFields: TcxObjectList;
    FDataChanged: Boolean;
    FFields: TcxObjectList;
    FSeries: TdxChartCustomSeries;
    FStorage: TdxDataStorage;
    FValueField: TdxStorageItem;
    FValueOffset: Cardinal;
    function GetArgumentDisplayText(AIndex: Integer): string;
    function GetArgumentValue(AIndex: Integer): Variant;
    function GetCount: Integer;
    function GetField(AIndex: Integer): TdxStorageItem; inline;
    function GetFieldCount: Integer; inline;
    function GetFieldDisplayText(ARecordIndex, AIndex: Integer): string;
    function GetFieldValue(ARecordIndex, AIndex: Integer): Variant;
    function GetValueDisplayText(AIndex: Integer): string;
    function GetValueValue(AIndex: Integer): Variant;
    procedure SetArgumentDisplayText(AIndex: Integer; const AValue: string);
    procedure SetArgumentValue(AIndex: Integer; const AValue: Variant);
    procedure SetFieldDisplayText(ARecordIndex, AIndex: Integer; const AValue: string);
    procedure SetFieldValue(ARecordIndex, AIndex: Integer; const AValue: Variant);
    procedure SetValueDisplayText(AIndex: Integer; const AValue: string);
    procedure SetValueValue(AIndex: Integer; const AValue: Variant);
  protected type
    PNumericValue = ^TNumericValue;
    TNumericValue = packed record
      Flag: Byte;
      Value: Double;
      Text: string;
    end;
  protected
    procedure Add(const AArgs: array of const); overload;
    procedure Changed; inline;
    procedure CheckNumericFastAccess(const AField: TdxStorageItem; var AOffset: Cardinal);
    procedure Insert(AIndex: Integer; const AArgs: array of const); overload;
    procedure RefreshFields;
    procedure SetRecordData(ARecord: PdxDataRecord; const AArgs: array of const); overload; virtual;
    procedure SetRecordData(ARecord: PdxDataRecord; const AArgument, AValue: Variant;
      const AArgumentDisplayText, AValueDisplayText: string); overload; virtual;

    property ArgumentField: TdxStorageItem read FArgumentField;
    property ArgumentOffset: Cardinal read FArgumentOffset;
    property FieldCount: Integer read GetFieldCount;
    property FieldDisplayText[ARecordIndex, AIndex: Integer]: string read GetFieldDisplayText write SetFieldDisplayText;
    property Fields[Index: Integer]: TdxStorageItem read GetField;
    property FieldValues[RecordIndex, Index: Integer]: Variant read GetFieldValue write SetFieldValue;
    property DataChanged: Boolean read FDataChanged write FDataChanged;
    property Storage: TdxDataStorage read FStorage;
    property ValueField: TdxStorageItem read FValueField;
    property ValueOffset: Cardinal read FValueOffset;
  public
    constructor Create(AOwner: TdxChartCustomSeries); virtual;
    procedure Clear;
    procedure Add(const AValue: Double); overload; 
    procedure Add(const AArgument, AValue: Double); overload; inline; 
    procedure Add(const AArgument: string; const AValue: Double); overload; inline;
    procedure Add(const AArgument, AValue: Variant; const AArgumentDisplayText: string = ''; AValueDisplayText: string = ''); overload;
    procedure Delete(AIndex: Integer; ACount: Integer = 1);
    procedure Insert(AIndex: Integer; const AArgument, AValue: Variant; const AArgumentDisplayText: string = ''; const AValueDisplayText: string = ''); overload;

    property Count: Integer read GetCount;
    property Series: TdxChartCustomSeries read FSeries;
    property Arguments[Index: Integer]: Variant read GetArgumentValue write SetArgumentValue;
    property ArgumentDisplayTexts[Index: Integer]: string read GetArgumentDisplayText write SetArgumentDisplayText;
    property Values[Index: Integer]: Variant read GetValueValue write SetValueValue;
    property ValueDisplayTexts[Index: Integer]: string read GetValueDisplayText write SetValueDisplayText;
  end;

  { TdxChartSeriesTopNOptions}

  TdxChartSeriesTopNOptionsMode = (Count, ThresholdValue, ThresholdPercent);

  TdxChartSeriesTopNOptions = class(TcxOwnedPersistent)
  strict private
    FEnabled: Boolean;
    FMode: TdxChartSeriesTopNOptionsMode;
    FShowOthers: Boolean;
    FOthersValueFormat: string;
    FOthersValueFormatter: TObject;
    FValue: Double;
    function GetSeries: TdxChartCustomSeries;
    procedure SetEnabled(AValue: Boolean);
    procedure SetMode(AValue: TdxChartSeriesTopNOptionsMode);
    procedure SetOthersValueFormat(AValue: string);
    procedure SetShowOthers(AValue: Boolean);
    procedure SetValue(AValue: Double);
    function IsValueStored: Boolean;
  protected
    procedure Changed; virtual;
    procedure ChangedIfEnabled;
    procedure DoAssign(Source: TPersistent); override;
    function GetOthersDisplayText: string;
    function GetValueByName(const AName: string; out AValue: Variant): Boolean;
    procedure ValidateValue(var AValue: Double);
  public
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;

    property Series: TdxChartCustomSeries read GetSeries;
  published
    property Mode: TdxChartSeriesTopNOptionsMode read FMode write SetMode default TdxChartSeriesTopNOptionsMode.Count;
    property OthersValueFormat: string read FOthersValueFormat write SetOthersValueFormat;
    property ShowOthers: Boolean read FShowOthers write SetShowOthers default True;
    property Value: Double read FValue write SetValue stored IsValueStored;
    property Enabled: Boolean read FEnabled write SetEnabled default False;
  end;

  TdxChartSeriesToolTipOptions = class(TcxOwnedPersistent)
  strict private
    FEnabled: Boolean;
    FPointToolTipFormatter: TObject;
    FSeriesToolTipFormatter: TObject;
    function GetPointToolTipFormat: TdxChartTextFormat;
    function GetSeriesToolTipFormat: TdxChartTextFormat;
    procedure SetPointToolTipFormat(const Value: TdxChartTextFormat);
    procedure SetSeriesToolTipFormat(const Value: TdxChartTextFormat);
  protected
    procedure DoAssign(Source: TPersistent); override;
    property PointToolTipFormatter: TObject read FPointToolTipFormatter;
    property SeriesToolTipFormatter: TObject read FSeriesToolTipFormatter;
  public
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;
  published
    property Enabled: Boolean read FEnabled write FEnabled default True;
    property PointToolTipFormat: TdxChartTextFormat read GetPointToolTipFormat write SetPointToolTipFormat;
    property SeriesToolTipFormat: TdxChartTextFormat read GetSeriesToolTipFormat write SetSeriesToolTipFormat;
  end;

  { TdxChartCustomSeries }

  TdxChartCustomSeries = class(TcxLockableComponent, IdxChartLegendItem, IdxChartCloneComponent)
  protected type
    TSeriesChange = (Layout, ChartLegend, DiagramLegend, Data, Style, View, Visible);
    TSeriesChanges = set of TSeriesChange;
  protected const
    LegendChanges: array[TdxChartSeriesShowInLegend] of TSeriesChanges =
      ([TSeriesChange.DiagramLegend], [TSeriesChange.ChartLegend], []);
  strict private
    FCaption: string;
    FChanges: TSeriesChanges;
    FCheckableInLegend: Boolean;
    FColorSchemeIndex: Integer;
    FDataBinding: TdxChartSeriesCustomDataBinding;
    FDiagram: TdxChartCustomDiagram;
    FEmptyPointsDisplayMode: TdxChartEmptyPointsDisplayMode;
    FPointCount: Integer;
    FPoints: TdxChartSeriesPoints;
    FShowInLegend: TdxChartSeriesShowInLegend;
    FSortBy: TdxChartSeriesSortBy;
    FSortOrder: TdxSortOrder;
    FStoredName: string;
    FToolTips: TdxChartSeriesToolTipOptions;
    FTopNOptions: TdxChartSeriesTopNOptions;
    FTitle: TdxChartSeriesTitle;
    FView: TdxChartSeriesCustomView;
    FVisible: Boolean;
    function CanChangeVisibility: Boolean;
    function GetCaption: string;
    function GetColorSchemeIndex: Integer;
    function GetDataBindingClass: TdxChartSeriesDataBindingClass;
    function GetDataBindingType: string;
    function GetDataController: TdxChartDataController;
    function GetIndex: Integer;
    function GetSource: TObject;
    function GetStorage: TdxDataStorage; inline;
    function GetViewClass: TdxChartSeriesViewClass;
    function GetViewType: string;
    procedure SetCaption(const AValue: string);
    procedure SetCheckableInLegend(AValue: Boolean);
    procedure SetDataBindingClass(const AValue: TdxChartSeriesDataBindingClass);
    procedure SetDataBindingProperty(AValue: TdxChartSeriesCustomDataBinding);
    procedure SetDataBindingType(const AValue: string);
    procedure SetEmptyPointsDisplayMode(AValue: TdxChartEmptyPointsDisplayMode);
    procedure SetIndex(AValue: Integer);
    procedure SetShowInLegend(AValue: TdxChartSeriesShowInLegend);
    procedure SetSource(AValue: TObject);
    procedure SetSortBy(AValue: TdxChartSeriesSortBy);
    procedure SetSortOrder(AValue: TdxSortOrder);
    procedure SetTitle(AValue: TdxChartSeriesTitle);
    procedure SetToolTips(AValue: TdxChartSeriesToolTipOptions);
    procedure SetTopNOptions(AValue: TdxChartSeriesTopNOptions);
    procedure SetView(AValue: TdxChartSeriesCustomView);
    procedure SetViewClass(const AValue: TdxChartSeriesViewClass);
    procedure SetViewType(const AValue: string);
    procedure SetVisible(AValue: Boolean);
    procedure ValidateColorSchemeIndex;

    function IsCaptionStored: Boolean;
    function IsDataBindingTypeStored: Boolean;
    function IsViewTypeStored: Boolean;
    function IsVisible: Boolean;

    // IdxChartLegendItem
    function IdxChartLegendItem.GetColor = GetLegendItemColor;
    function IdxChartLegendItem.GetCaption = GetLegendItemCaption;
    function IdxChartLegendItem.IsChecked = IsVisible;
    function IdxChartLegendItem.IsEnabled = CanChangeVisibility;
    procedure IdxChartLegendItem.DrawGlyph = DrawLegendGlyph;
    procedure IdxChartLegendItem.SetChecked = SetVisible;
    procedure DrawLegendGlyph(ACanvas: TcxCustomCanvas; const R: TdxRectF);
    function GetLegendItemCaption: string;
    function GetLegendItemColor: TdxAlphaColor;

    procedure ReadColorSchemeIndex(Reader: TReader);
    procedure WriteColorSchemeIndex(Writer: TWriter);
  protected
    FSource: TObject;
    function ActuallyVisible: Boolean;
    procedure AddToChart(AChart: TdxChart);
    procedure BiDiModeChanged; virtual;
    class function CanHaveTitle: Boolean; virtual;
    function CanVisible: Boolean;
    procedure Changed(AChange: TSeriesChange); overload;
    procedure Changed(AChanges: TSeriesChanges); overload;
    procedure ClearLegend;
    procedure CreateSubClasses; virtual;
    function CreateTitle: TdxChartSeriesTitle; virtual;
    procedure ChangeScale(M, D: Integer); virtual;
    function ComparePointsBy(P1, P2: Pointer; AField: TdxStorageItem): Integer; inline;
    function ComparePointsByArgument(P1, P2: Pointer): Integer; virtual;
    function ComparePointsByValue(P1, P2: Pointer): Integer; virtual;
    procedure DataChanged;
    procedure DefineProperties(Filer: TFiler); override;
    procedure DestroySubClasses; virtual;
    procedure DoChanged; override;
    procedure DoPopulateLegend(ALegend: TdxChartCustomLegend); virtual;
    class function GetBaseDataBindingClass: TdxChartSeriesDataBindingClass; virtual;
    class function GetBaseViewClass: TdxChartSeriesViewClass; virtual;
    class function GetDefaultViewClass: TdxChartSeriesViewClass; virtual;
    function GetStoredName: string;
    function GetSeriesToolTipText: TdxChartTextFormat;
    procedure Loaded; override;
    procedure PopulateLegend(ALegend: TdxChartCustomLegend; ALegendType: TdxChartSeriesShowInLegend);
    procedure RemoveFromChart(AChart: TdxChart);
    procedure SetDataBinding(ADataBinding: TdxChartSeriesCustomDataBinding);
    procedure SetDiagram(AValue: TdxChartCustomDiagram); virtual;
    procedure SetName(const NewName: TComponentName); override;
    procedure UpdateColorSchemeIndexFromSeries(ASeries: TdxChartCustomSeries);
    procedure UpdateParentAppearance;

    // internal properties
    property Changes: TSeriesChanges read FChanges write FChanges;
    property ColorSchemeIndex: Integer read GetColorSchemeIndex;
    //
    property CheckableInLegend: Boolean read FCheckableInLegend write SetCheckableInLegend default True;
    property DataController: TdxChartDataController read GetDataController;
    property SortBy: TdxChartSeriesSortBy read FSortBy write SetSortBy default TdxChartSeriesSortBy.Argument;
    property SortOrder: TdxSortOrder read FSortOrder write SetSortOrder default TdxSortOrder.soNone;
    property ShowInLegend: TdxChartSeriesShowInLegend read FShowInLegend write SetShowInLegend default TdxChartSeriesShowInLegend.Chart;
    property Storage: TdxDataStorage read GetStorage;
    property Title: TdxChartSeriesTitle read FTitle write SetTitle;
    property TopNOptions: TdxChartSeriesTopNOptions read FTopNOptions write SetTopNOptions;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure AssignFrom(ASource: TdxChartCustomSeries); virtual;
    function GetParentComponent: TComponent; override;
    function HasParent: Boolean; override;
    function IsCompatibleWithDataBinding(ADataBindingClass: TdxChartSeriesDataBindingClass): Boolean; // for internal use
    function IsCompatibleWithView(AViewClass: TdxChartSeriesViewClass): Boolean; // for internal use
    procedure SetParentComponent(Value: TComponent); override;

    property DataBindingClass: TdxChartSeriesDataBindingClass read GetDataBindingClass write SetDataBindingClass;
    property Diagram: TdxChartCustomDiagram read FDiagram write SetDiagram;
    property Points: TdxChartSeriesPoints read FPoints;
    property StoredName: string read FStoredName write FStoredName;
    property ViewClass: TdxChartSeriesViewClass read GetViewClass write SetViewClass;
  published
    property Caption: string read GetCaption write SetCaption stored IsCaptionStored;
    property DataBindingType: string read GetDataBindingType write SetDataBindingType stored IsDataBindingTypeStored;
    property DataBinding: TdxChartSeriesCustomDataBinding read FDataBinding write SetDataBindingProperty;
    property EmptyPointsDisplayMode: TdxChartEmptyPointsDisplayMode read FEmptyPointsDisplayMode write SetEmptyPointsDisplayMode default TdxChartEmptyPointsDisplayMode.Default;
    property ToolTips: TdxChartSeriesToolTipOptions read FToolTips write SetToolTips;
    property ViewType: string read GetViewType write SetViewType stored IsViewTypeStored;
    property View: TdxChartSeriesCustomView read FView write SetView;
    property Visible: Boolean read FVisible write SetVisible default True;
    property Index: Integer read GetIndex write SetIndex stored False;
  end;

  { TdxChartSeriesCustomDataField }

  TdxChartSeriesCustomDataField = class(TdxStorageItemCustomDataBinding)
  private
    FFieldName: string;
    function GetDataBinding: TdxChartSeriesCustomDataBinding; inline;
    function GetIndex: Integer;
    function GetSeries: TdxChartCustomSeries; inline;
    function GetStorage: TdxDataStorage; inline;
  protected
    procedure Changed; override;
    procedure DoAssign(Source: TPersistent); override;
    function GetDefaultTextStored: Boolean; override;
    function GetDefaultValueTypeClass: TcxValueTypeClass; override;
    function GetFieldName: string; virtual;
    procedure InternalSetItem(AItem: TdxStorageItem); override;
    function IsValueTypeSupported(AValueTypeClass: TcxValueTypeClass): Boolean; override;
    procedure RecreateItem(AStorage: TdxDataStorage);
    procedure SetFieldName(const AValue: string); virtual;

    property DataBinding: TdxChartSeriesCustomDataBinding read GetDataBinding;
    property FieldName: string read GetFieldName write SetFieldName;
    property Index: Integer read GetIndex;
    property Series: TdxChartCustomSeries read GetSeries;
    property Storage: TdxDataStorage read GetStorage;
  public
    constructor Create(AOwner: TdxChartSeriesCustomDataBinding); reintroduce; overload;
    destructor Destroy; override;
    function IsNumeric: Boolean;
    function IsString: Boolean;
  end;

 { TdxChartSeriesCustomDataBinding }

  TdxChartSeriesCustomDataBinding = class(TcxOwnedPersistent)
  private
    FArgumentField: TdxChartSeriesCustomDataField;
    FCustomFields: TcxObjectList;
    FDataController: TdxChartDataController;
    FFields: TcxObjectList;
    FStorage: TdxDataStorage;
    FSharedLink: TObject;
    FValueField: TdxChartSeriesCustomDataField;
    function GetDataController: TdxChartDataController; inline;
    function GetField(AIndex: Integer): TdxChartSeriesCustomDataField; inline;
    function GetFieldCount: Integer; inline;
    function GetSeries: TdxChartCustomSeries; inline;
    procedure ReadCustomFields(AReader: TReader);
    procedure RestoreDefaultStorage;
    procedure SetArgumentField(AValue: TdxChartSeriesCustomDataField);
    procedure SetStorage(AValue: TdxDataStorage);
    procedure SetValueField(AValue: TdxChartSeriesCustomDataField);
    procedure UpdateDataControllerReference;
    procedure WriteCustomFields(AWriter: TWriter);
  protected
    function CanStored: Boolean; virtual;
    procedure ClearRecords;
    procedure ClearFields;
    procedure Changed; virtual;
    procedure ChangeStorage(ANewStorage: TdxDataStorage); virtual;
    function CreateField: TdxChartSeriesCustomDataField;
    procedure CreateInternalFields; virtual;
    procedure DefineProperties(Filer: TFiler); override;
    procedure DoAssign(Source: TPersistent); override;
    function FieldByName(const AFieldName: string): TdxChartSeriesCustomDataField;
    function GetFieldClass: TdxChartSeriesDataFieldClass; virtual;
    function GetDataStorageClass: TdxDataStorageClass; virtual;
    function GetDefaultSeriesCaption: string; virtual;
    class function GetPointsClass: TdxChartSeriesPointsClass; virtual;
    function GetSharedStorageKey: TComponent; virtual;
    class function GetTypeName: string; virtual;
    class function IsSharedStorage: Boolean; virtual;
    function IsValueTypeSupported(AField: TdxChartSeriesCustomDataField; AValueTypeClass: TcxValueTypeClass): Boolean;
    procedure LoadFromStream(AStream: TStream); virtual;
    class procedure Register;
    procedure Remove(AField: TdxChartSeriesCustomDataField);
    procedure SaveToStream(AStream: TStream); virtual;
    procedure StorageChanged(Sender: TObject); virtual;
    class procedure UnRegister;


    property ArgumentField: TdxChartSeriesCustomDataField read FArgumentField write SetArgumentField;
    property CustomFields: TcxObjectList read FCustomFields;  
    property DataController: TdxChartDataController read GetDataController;
    property FieldList: TcxObjectList read FFields;
    property FieldCount: Integer read GetFieldCount;
    property Fields[Index: Integer]: TdxChartSeriesCustomDataField read GetField;
    property Storage: TdxDataStorage read FStorage;
    property ValueField: TdxChartSeriesCustomDataField read FValueField write SetValueField;
  public
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;
    class function IsCompatibleWidth(ASeriesClass: TdxChartSeriesClass): Boolean; virtual; // for internal use
    procedure Refresh;

    property Series: TdxChartCustomSeries read GetSeries;
  end;

  {  TdxChartDiagramSeriesGroup }

  TdxChartDiagramSeriesGroup = class(TdxFastObjectList)  
  strict private
    FMasterView: TdxChartSeriesCustomView;
    FOwner: TdxChartDiagramCustomViewData;
    function GetSeries(AIndex: Integer): TdxChartCustomSeries; inline;
    function GetView(AIndex: Integer): TdxChartSeriesCustomView; inline;
  protected
    procedure AfterCalculate; virtual;
    procedure BeforeCalculate; virtual;
    procedure DoCalculate; virtual;
    function EnableReverseOrder: Boolean; virtual;
    function IsNumeric: Boolean;
    procedure ReverseOrder;
    function TryAggregate(ASeries: TdxChartCustomSeries): Boolean; virtual;
  public
    constructor Create(AOwner: TdxChartDiagramCustomViewData; AMasterSeries: TdxChartCustomSeries); virtual;
    procedure AsyncCalculate;

    property MasterView: TdxChartSeriesCustomView read FMasterView;
    property Owner: TdxChartDiagramCustomViewData read FOwner;
    property Series[Index: Integer]: TdxChartCustomSeries read GetSeries;
    property Views[Index: Integer]: TdxChartSeriesCustomView read GetView;
  end;

  { TdxChartDiagramCustomViewData }

  TdxChartDiagramCustomViewData = class(TdxChartCustomItemViewData)
  private
    FDiagram: TdxChartCustomDiagram;
    FGroups: TdxFastObjectList;
    FSeries: TdxFastObjectList;
    FTotalRecords: Integer;
    function GetGroup(AIndex: Integer): TdxChartDiagramSeriesGroup; inline;
    function GetGroupCount: Integer; inline;
    function GetSeries(AIndex: Integer): TdxChartCustomSeries; inline;
    function GetSeriesCount: Integer;
    function GetView(AIndex: Integer): TdxChartSeriesCustomView; inline;
  protected
    function AllowSorting: Boolean; virtual;
    procedure DoCalculate; override;
    function GetSeriesGroupClass(ASeries: TdxChartCustomSeries): TdxChartDiagramSeriesGroupClass; virtual;
    function IsReverseOrder: Boolean; virtual;
    procedure TryAddSeries(ASeries: TdxChartCustomSeries);

    property TotalRecords: Integer read FTotalRecords;
  public
    constructor Create(AOwner: TdxChartCustomDiagram); virtual;
    destructor Destroy; override;

    property Diagram: TdxChartCustomDiagram read FDiagram;
    property GroupCount: Integer read GetGroupCount;
    property Groups[Index: Integer]: TdxChartDiagramSeriesGroup read GetGroup;
    property SeriesCount: Integer read GetSeriesCount;
    property Series[Index: Integer]: TdxChartCustomSeries read GetSeries;
    property Views[Index: Integer]: TdxChartSeriesCustomView read GetView;
  end;

  { TdxChartDiagramCustomViewInfo }

  TdxChartDiagramCustomViewInfo = class(TdxChartVisualElementCustomViewInfo) // for internal use
  strict private
    FDiagram: TdxChartCustomDiagram;
    FItems: TdxChartItemsViewInfoList;
    FLabelsBoundingRect: TdxRectF;
    FMutableItems: TdxChartItemsViewInfoList;
    FPlotArea: TdxRectF;
    FTopmostItems: TdxChartItemsViewInfoList;
    function GetLegend: TdxChartDiagramLegend; inline;
    function GetSeries(AIndex: Integer): TdxChartCustomSeries; inline;
    function GetSeriesCount: Integer; inline;
    function GetTitle: TdxChartVisualElementTitle; inline;
    function GetTitleViewInfo: TdxChartVisualElementTitleViewInfo;
    function GetViewData: TdxChartDiagramCustomViewData; inline;
  protected
    function AdjustPlotAreaByLabelsBounding(ACanvas: TcxCustomCanvas): Boolean; virtual;
    function CalculateChartHitTest(AHitTest: TdxChartHitTestEngine; const P: TdxPointF): Boolean; virtual;
    function CalculateHitTest(AHitTest: TdxChartHitTestEngine; const P: TdxPointF): Boolean; override;
    procedure CalculateView(AView: TdxChartSeriesCustomView; ACanvas: TcxCustomCanvas); virtual;
    procedure CalculateViews(ACanvas: TcxCustomCanvas); virtual;
    procedure DoCalculate(ACanvas: TcxCustomCanvas); override;
    procedure DoDraw(ACanvas: TcxCustomCanvas); override;
    procedure DrawChart(ACanvas: TcxCustomCanvas); virtual;
    procedure DrawValuesLabels(ACanvas: TcxCustomCanvas); virtual;
    procedure EnableExportMode(AEnable: Boolean); override;
    function GetHitElement(const P: TdxPointF): IdxChartHitTestElement; override;
    function GetContentRect: TdxRectF; virtual;
    function HasZeroBasedSeries: Boolean; virtual;
    function IsLabelsOutsideOfPlotArea: Boolean; virtual;
    function IsOutsideLegend: Boolean;
    procedure SetPlotArea(const ARect: TdxRectF);
    procedure ResetLabelsBoundingRect;
    procedure UpdateLabelsBoundingRect(AValue: TdxChartSeriesValueViewInfo); virtual;

    property TitleViewInfo: TdxChartVisualElementTitleViewInfo read GetTitleViewInfo;
  public
    constructor Create(AOwner: TdxChartCustomDiagram); reintroduce; virtual;
    destructor Destroy; override;

    property Diagram: TdxChartCustomDiagram read FDiagram;
    property Items: TdxChartItemsViewInfoList read FItems;
    property LabelsBoundingRect: TdxRectF read FLabelsBoundingRect;
    property Legend: TdxChartDiagramLegend read GetLegend;
    property MutableItems: TdxChartItemsViewInfoList read FMutableItems;
    property PlotArea: TdxRectF read FPlotArea;
    property SeriesCount: Integer read GetSeriesCount;
    property Series[Index: Integer]: TdxChartCustomSeries read GetSeries;
    property Title: TdxChartVisualElementTitle read GetTitle;
    property TopmostItems: TdxChartItemsViewInfoList read FTopmostItems;
    property ViewData: TdxChartDiagramCustomViewData read GetViewData;
  end;

  { TdxChartWeakReferenceHitElement }

  TdxChartWeakReferenceHitElement = class(TInterfacedObject,
                                          IdxChartHitTestElement) // for internal use
  strict private
    FObjectLink: TcxObjectLink;
    FHitCode: TdxChartHitCode;
    FSubAreaCode: Integer;
  protected
    // IdxChartHitTestElement
    function GetChartElement: TObject;
    function GetHitCode: TdxChartHitCode;
    function GetSubAreaCode: Integer;
  public
    constructor Create(AObject: TObject; AHitCode: TdxChartHitCode; ASubAreaCode: Integer = 0);
    destructor Destroy; override;
  end;

  { TdxComponentReference }

  TdxComponentReference<T: TComponent> = class(TInterfacedObject)  // for internal use
  protected
    FObject: T;
    FFreeNotificator: TcxFreeNotificator;
    procedure DoObjectRemoved; virtual;
    procedure FreeNotificatorHandler(Sender: TComponent);
  public
    constructor Create(AObject: T);
    destructor Destroy; override;
  end;

  { TdxChartComponentHitElement }

  TdxChartComponentHitElement = class(TdxComponentReference<TComponent>, IdxChartHitTestElement) // for internal use
  strict private
    FHitCode: TdxChartHitCode;
    FSubAreaCode: Integer;
  protected
    function GetChartElement: TObject;
    function GetHitCode: TdxChartHitCode;
    function GetSubAreaCode: Integer;
  public
    constructor Create(AObject: TComponent; AHitCode: TdxChartHitCode; ASubAreaCode: Integer = 0);
  end;

  { TdxChartComponentDependentHitElement }

  TdxChartComponentDependentHitElement = class(TdxComponentReference<TComponent>, IdxChartHitTestElement) // for internal use
  private
    FHitObject: TObject;
    FHitCode: TdxChartHitCode;
    FOwnsObject: Boolean;
    FSubAreaCode: Integer;
  protected
    procedure DoObjectRemoved; override;
    function GetChartElement: TObject;
    function GetHitCode: TdxChartHitCode;
    function GetSubAreaCode: Integer;
  public
    constructor Create(AHitObject: TObject; AOwnsObject: Boolean; AComponent: TComponent;
                                     AHitCode: TdxChartHitCode; ASubAreaCode: Integer = 0);
    destructor Destroy; override;
  end;

  { TdxChartHintableCaptionHitElement }

  TdxChartHintableCaptionHitElement = class(TInterfacedObject,
    IdxChartHitTestElement,
    IdxChartHitTestHintableElement,
    IcxHintableObject,
    IcxHintableObject2) //for internal use
  strict private
    FBounds: TRect;
    FIHitTestElement: IdxChartHitTestElement;
    FIsTruncated: Boolean;
    FFont: TFont;
    FMultiline: Boolean;
    FText: string;
    procedure UpdateFont;
  {$REGION 'IdxChartHitTestHintableElement'}
    function CanShowHint: Boolean;
    function GetHintableObject: IcxHintableObject2;
  {$ENDREGION}
  {$REGION 'IcxHintableObject'}
    function HasHintPoint(const P: TPoint): Boolean;
    function IsHintAtMousePos: Boolean;
    function UseHintHidePause: Boolean;
  {$ENDREGION}
  {$REGION 'IcxHintableObject2'}
    function ImmediateShowHint: Boolean;
    function GetHintObject: TObject;
    function GetHintText: string;
    function IsHintMultiLine: Boolean;
    function GetHintFont: TFont;
    function GetHintAreaBounds: TRect;
    function GetHintTextBounds: TRect;
  {$ENDREGION}
  protected
  {$REGION 'IdxChartHitTestElement'}
    function GetChartElement: TObject;
    function GetHitCode: TdxChartHitCode;
    function GetSubAreaCode: Integer;
  {$ENDREGION}
    function GetAppearance: TdxChartVisualElementAppearance; virtual;
    function GetBounds: TRect;

    property Bounds: TRect read GetBounds;
  public
    constructor Create(const AIHitTestElement: IdxChartHitTestElement; const ABounds: TdxRectF; AText: string; AIsTruncated: Boolean; AMultiline: Boolean = False);
    destructor Destroy; override;
  end;

  TdxChartCustomHitElementWithToolTip = class(TInterfacedObject,
    IdxChartHitTestElement,
    IdxChartHitTestHintableElement,
    IdxChartHitTestElementWithToolTip,
    IcxHintableObject,
    IcxHintableObject2)
  strict private
    FBounds: TdxRectF;
    FIHitTestElement: IdxChartHitTestElement;
    FMode: TdxChartSimpleToolTipMode;
  protected
    // IdxChartHitTestElement
    function GetChartElement: TObject;
    function GetHitCode: TdxChartHitCode;
    function GetSubAreaCode: Integer;

    // IdxChartHitTestHintableElement
    function CanShowHint: Boolean;
    function GetHintableObject: IcxHintableObject2;

    // IdxChartHitTestElementWithToolTip
    function GetHintedSeries: TdxChartCustomSeries; virtual; abstract;
    function GetMode: TdxChartSimpleToolTipMode;
    function IsModeSupported(AMode: TdxChartSimpleToolTipMode): Boolean; virtual; abstract;
    procedure SetMode(AValue: TdxChartSimpleToolTipMode);

    // IcxHintableObject
    function HasHintPoint(const P: TPoint): Boolean;
    function IsHintAtMousePos: Boolean;
    function UseHintHidePause: Boolean;

    // IcxHintableObject2
    function ImmediateShowHint: Boolean;
    function GetHintObject: TObject;
    function GetHintText: string; virtual; abstract;
    function IsHintMultiLine: Boolean;
    function GetHintFont: TFont;
    function GetHintAreaBounds: TRect;
    function GetHintTextBounds: TRect;
  public
    constructor Create(const AIHitTestElement: IdxChartHitTestElement; ABounds: TdxRectF);
  end;

  TdxChartSeriesHitElement = class(TdxChartCustomHitElementWithToolTip)
  protected
    function GetHintedSeries: TdxChartCustomSeries; override;
    function GetHintText: string; override;
    function IsModeSupported(AMode: TdxChartSimpleToolTipMode): Boolean; override;
  public
    constructor Create(ASeries: TdxChartCustomSeries);
  end;

  { TdxChartSeriesPointInfo }

  TdxChartSeriesPointInfo = class
  strict private
    FValueViewInfo: TdxChartSeriesValueViewInfo;
    function GetArgument: Variant;
    function GetArgumentDisplayText: string;
    function GetIndex: Integer;
    function GetSeries: TdxChartCustomSeries;
    function GetValue: Variant;
    function GetValueDisplayText: string;
  protected
    constructor Create(AValueViewInfo: TdxChartSeriesValueViewInfo);
  public
    function Equals(Obj: TObject): Boolean; override;
    property Argument: Variant read GetArgument;
    property ArgumentDisplayText: string read GetArgumentDisplayText;
    property Index: Integer read GetIndex;
    property Series: TdxChartCustomSeries read GetSeries;
    property Value: Variant read GetValue;
    property ValueDisplayText: string read GetValueDisplayText;
  end;

  { TdxChartSeriesPointHitElement }

  TdxChartSeriesPointHitElement = class(TdxChartCustomHitElementWithToolTip)
  strict private
    FPointToolTipText: string;
  protected
    function GetHintedSeries: TdxChartCustomSeries; override;
    function GetHintText: string; override;
    function IsModeSupported(AMode: TdxChartSimpleToolTipMode): Boolean; override;
  public
    constructor Create(APointInfo: TdxChartSeriesPointInfo; APointToolTipText: string);
  end;

  { TdxChartSeriesValueLabelInfo }

  TdxChartSeriesValueLabelInfo = class
  private
    FSeriesPoint: TdxChartSeriesPointInfo;
    FText: string;
  protected
    constructor Create(APointInfo: TdxChartSeriesPointInfo; const AText: string);
  public
    destructor Destroy; override;
    function Equals(Obj: TObject): Boolean; override;
    property Text: string read FText;
    property SeriesPoint: TdxChartSeriesPointInfo read FSeriesPoint;
  end;

  TdxChartSeriesValueLabelCaptionHitElement = class(TdxChartHintableCaptionHitElement)
  strict private
    FViewInfo: TdxChartSeriesValueLabelViewInfo;
  protected
    function GetAppearance: TdxChartVisualElementAppearance; override;
  public
    constructor Create(AValueLabelViewInfo: TdxChartSeriesValueLabelViewInfo);
  end;

  TdxChartDiagramToolTipOptions = class(TcxOwnedPersistent)
    FPointToolTipFormatter: TObject;
    FSeriesToolTipFormatter: TObject;
    function GetPointToolTipFormat: TdxChartTextFormat;
    function GetSeriesToolTipFormat: TdxChartTextFormat;
    procedure SetPointToolTipFormat(const Value: TdxChartTextFormat);
    procedure SetSeriesToolTipFormat(const Value: TdxChartTextFormat);
  protected
    procedure DoAssign(Source: TPersistent); override;
    property PointToolTipFormatter: TObject read FPointToolTipFormatter;
    property SeriesToolTipFormatter: TObject read FSeriesToolTipFormatter;
  public
    destructor Destroy; override;
  published
    property PointToolTipFormat: TdxChartTextFormat read GetPointToolTipFormat write SetPointToolTipFormat;
    property SeriesToolTipFormat: TdxChartTextFormat read GetSeriesToolTipFormat write SetSeriesToolTipFormat;
  end;


  { TdxChartDiagramAppearance }

  TdxChartDiagramAppearance = class(TdxChartVisualElementAppearance)
  protected
    function GetActualColor(AIndex: Integer): TdxAlphaColor; override;
    function HasFillOptions: Boolean; override;
  published
    property Border;
    property BorderColor;
    property BorderThickness;
    property FillOptions;
    property Margins;
  end;

  TdxChartGetValueLabelDrawParametersEventArgs = class(TdxEventArgs)
  private
    FSeriesPoint: TdxChartSeriesPointInfo;
    FText: string;
  public
    constructor Create(ASeriesPoint: TdxChartSeriesPointInfo; const AText: string);
    destructor Destroy; override;
    property SeriesPoint: TdxChartSeriesPointInfo read FSeriesPoint;
    property Text: string read FText write FText;
  end;

  TdxChartGetValueLabelDrawParametersEvent = procedure(Sender: TdxChartCustomDiagram; AArgs: TdxChartGetValueLabelDrawParametersEventArgs) of object;

  { TdxCustomChartDiagram }

  TdxChartCustomDiagram = class(TcxLockableComponent, IdxChartVisualElement, IdxChartCloneComponent, IdxChartDiagram)
  protected type
    TDiagramChange = (Layout, Series, Style, Visible);
    TDiagramChanges = set of TDiagramChange;
  strict private
    FAppearance: TdxChartDiagramAppearance;
    FChart: TdxChart;
    FLegend: TdxChartDiagramLegend;
    FOnGetValueLabelDrawParameters: TdxChartGetValueLabelDrawParametersEvent;
    FTitle: TdxChartDiagramTitle;
    FToolTips: TdxChartDiagramToolTipOptions;
    FSeries: TdxFastObjectList;
    FSource: TObject;
    FViewData: TdxChartDiagramCustomViewData;
    FViewInfo: TdxChartDiagramCustomViewInfo;
    FVisible: Boolean;
    function GetAppearance: TdxChartVisualElementAppearance; inline;
    function GetChart: TdxChart; inline;
    function GetIndex: Integer;
    function GetParentElement: IdxChartVisualElement;
    function GetSeries(AIndex: Integer): TdxChartCustomSeries; inline;
    function GetSeriesCount: Integer; inline;
    function GetSource: TObject;
    function GetVisibleSeries(AIndex: Integer): TdxChartCustomSeries; inline;
    function GetVisibleSeriesCount: Integer; inline;
    procedure LayoutChanged;
    procedure SetAppearance(AValue: TdxChartDiagramAppearance);
    procedure SetIndex(AValue: Integer);
    procedure SetLegend(AValue: TdxChartDiagramLegend);
    procedure SetTitle(AValue: TdxChartDiagramTitle);
    procedure SetSeriesList(AValue: TdxFastObjectList);
    procedure SetSource(AValue: TObject);
    procedure SetVisible(AValue: Boolean);
    procedure StyleChanged;
    procedure TextColorChanged;
  protected
    Changes: TDiagramChanges;

    // IdxChartDiagram
    function GetActualToolTipMode: TdxChartActualToolTipMode; virtual; abstract;

    function ActuallyVisible: Boolean;
    function AddSeries(const ACaption: string = ''): TdxChartCustomSeries; overload;
    procedure AddSeries(ASeries: TdxChartCustomSeries); overload;
    procedure AddSeriesToChart(AChart: TdxChart);
    procedure AssignFrom(ASource: TdxChartCustomDiagram; ARecreate: Boolean = True; AStoreList:  TdxFastObjectList = nil); virtual;
    procedure BiDiModeChanged; virtual;
    procedure Changed(AChange: TDiagramChange); overload;
    procedure Changed(AChanges: TDiagramChanges); overload;
    procedure ChangeScale(M, D: Integer); virtual;
    function CreateAppearance: TdxChartDiagramAppearance; virtual;
    function CreateLegend: TdxChartDiagramLegend; virtual;
    function CreateTitle: TdxChartDiagramTitle; virtual;
    function CreateToolTipOptions: TdxChartDiagramToolTipOptions; virtual; abstract;
    function CreateViewData: TdxChartDiagramCustomViewData; virtual;
    function CreateViewInfo: TdxChartDiagramCustomViewInfo; virtual;
    procedure DoChanged; override;
    procedure DoGetValueLabelDrawParameters(AArgs: TdxChartGetValueLabelDrawParametersEventArgs);
    function GetSeriesClass: TdxChartSeriesClass; virtual; abstract;
    procedure Invalidate;
    function IsCompatibleWith(ASeries: TdxChartCustomSeries): Boolean; virtual;
    procedure RemoveSeries(ASeries: TdxChartCustomSeries);
    procedure RemoveSeriesFromChart(AChart: TdxChart);
    procedure SetChart(AValue: TdxChart); virtual;
    procedure SetName(const NewName: TComponentName); override;

    property Chart: TdxChart read FChart write SetChart;
    property OnGetValueLabelDrawParameters: TdxChartGetValueLabelDrawParametersEvent read FOnGetValueLabelDrawParameters write FOnGetValueLabelDrawParameters;
    property SeriesList: TdxFastObjectList read FSeries write SetSeriesList;
    property ToolTips: TdxChartDiagramToolTipOptions read FToolTips;
    property ViewData: TdxChartDiagramCustomViewData read FViewData;
    property ViewInfo: TdxChartDiagramCustomViewInfo read FViewInfo;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure DeleteAllSeries;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    function GetParentComponent: TComponent; override;
    function HasParent: Boolean; override;
    procedure SetParentComponent(Value: TComponent); override;

    property Series[Index: Integer]: TdxChartCustomSeries read GetSeries; default;
    property SeriesCount: Integer read GetSeriesCount;
    property VisibleSeries[Index: Integer]: TdxChartCustomSeries read GetVisibleSeries;
    property VisibleSeriesCount: Integer read GetVisibleSeriesCount;
  published
    property Appearance: TdxChartDiagramAppearance read FAppearance write SetAppearance;
    property Legend: TdxChartDiagramLegend read FLegend write SetLegend;
    property Index: Integer read GetIndex write SetIndex stored False;
    property Title: TdxChartDiagramTitle read FTitle write SetTitle;
    property Visible: Boolean read FVisible write SetVisible default True;
  end;

  { TdxChartViewInfo }

  TdxChartViewInfo = class(TdxChartVisualElementCustomViewInfo)
  strict private
    FChart: TdxChart;
    FIsCachedImageValid: Boolean;
    FItems: TdxChartItemsViewInfoList;
    FOverlays: TdxChartItemsViewInfoList;
    function GetLegend: TdxChartLegend;
    function GetTitles: TdxChartTitles;
  protected
    FDiagramsArea: TdxRectF;
    function CalculateHitTest(AHitTest: TdxChartHitTestEngine; const P: TdxPointF): Boolean; override;
    procedure CalculateLegend(ACanvas: TcxCustomCanvas); virtual;
    procedure CalculateTitles(ACanvas: TcxCustomCanvas); virtual;
    procedure DiscardCachedImage;
    procedure DoCalculate(ACanvas: TcxCustomCanvas); override;
    procedure DoDraw(ACanvas: TcxCustomCanvas); override;
    function GetHitElement(const P: TdxPointF): IdxChartHitTestElement; override;
  public
    constructor Create(AOwner: TdxChart); reintroduce; virtual;
    destructor Destroy; override;

    property Chart: TdxChart read FChart;
    property DiagramsArea: TdxRectF read FDiagramsArea;
    property Legend: TdxChartLegend read GetLegend;
    property Items: TdxChartItemsViewInfoList read FItems;
    property Overlays: TdxChartItemsViewInfoList read FOverlays;
    property Titles: TdxChartTitles read GetTitles;
  end;

  { TdxChartAppearance }

  TdxChartAppearance = class(TdxChartVisualElementAppearance)
  strict private
    function GetChart: TdxChart; inline;
  protected
    function GetOwner: TPersistent; override;
    function HasFillOptions: Boolean; override;
    function HasFontOptions: Boolean; override;

    property Chart: TdxChart read GetChart;
  published
    property Border;
    property BorderColor;
    property BorderThickness;
    property FillOptions;
    property FontOptions;
    property Padding;
    property TextColor;
  end;

  { TdxChartMouseAction }

  TdxChartMouseAction = class(TcxOwnedPersistent)
  strict private
    FDefaultMouseButton: TMouseButton;
    FDefaultModifierKeys: TdxModifierKeys;
    FEnabled: Boolean;
    FMouseButton: TMouseButton;
    FModifierKeys: TdxModifierKeys;
    function IsModifierKeysStored: Boolean;
    function IsMouseButtonStored: Boolean;
  protected
    procedure DoAssign(ASource: TPersistent); override;
  public
    constructor Create(AOwner: TPersistent; AMouseButton: TMouseButton; AModifierKeys: TdxModifierKeys); reintroduce;
  published
    property Enabled: Boolean read FEnabled write FEnabled default True;
    property ModifierKeys: TdxModifierKeys read FModifierKeys write FModifierKeys stored IsModifierKeysStored;
    property MouseButton: TMouseButton read FMouseButton write FMouseButton stored IsMouseButtonStored;
  end;

  { TdxChartMouseWheelAction }

  TdxChartMouseWheelAction = class(TcxOwnedPersistent)
  strict private
    FDefaultModifierKeys: TdxModifierKeys;
    FEnabled: Boolean;
    FModifierKeys: TdxModifierKeys;
    function IsModifierKeysStored: Boolean;
  protected
    procedure DoAssign(ASource: TPersistent); override;
  public
    constructor Create(AOwner: TPersistent; AModifierKeys: TdxModifierKeys); reintroduce;
  published
    property Enabled: Boolean read FEnabled write FEnabled default True;
    property ModifierKeys: TdxModifierKeys read FModifierKeys write FModifierKeys stored IsModifierKeysStored;
  end;

  { TdxChartZoomingOptions }

  TdxChartZoomOptions = class(TcxOwnedPersistent)
  private const
    DefaultSmallStep = 20;
    DefaultLargeStep = 100;
  strict private
    FLargeStep: Single;
    FMarqueeZoomMouseAction: TdxChartMouseAction;
    FSmallStep: Single;
    FZoomMouseWheelAction: TdxChartMouseWheelAction;
    FZoomOutMouseAction: TdxChartMouseAction;
    FZoomInMouseAction: TdxChartMouseAction;
    function IsLargeStepStored: Boolean;
    function IsSmallStepStored: Boolean;
    procedure SetLargeStep(AValue: Single);
    procedure SetMarqueeZoomMouseAction(AValue: TdxChartMouseAction);
    procedure SetSmallStep(AValue: Single);
    procedure SetZoomMouseWheelAction(AValue: TdxChartMouseWheelAction);
    procedure SetZoomInMouseAction(AValue: TdxChartMouseAction);
    procedure SetZoomOutMouseAction(AValue: TdxChartMouseAction);
  protected
    procedure DoAssign(ASource: TPersistent); override;
  public
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;
  published
    property LargeStep: Single read FLargeStep write SetLargeStep stored IsLargeStepStored;
    property MarqueeZoomMouseAction: TdxChartMouseAction read FMarqueeZoomMouseAction write SetMarqueeZoomMouseAction;
    property SmallStep: Single read FSmallStep write SetSmallStep stored IsSmallStepStored;
    property ZoomMouseWheelAction: TdxChartMouseWheelAction read FZoomMouseWheelAction write SetZoomMouseWheelAction;
    property ZoomInMouseAction: TdxChartMouseAction read FZoomInMouseAction write SetZoomInMouseAction;
    property ZoomOutMouseAction: TdxChartMouseAction read FZoomOutMouseAction write SetZoomOutMouseAction;
  end;

  TdxChartScrollOptions = class(TcxOwnedPersistent)
  strict private
    FPanMouseAction: TdxChartMouseAction;
    FScrollBars: Boolean;
    FScrollMouseWheelAction: TdxChartMouseWheelAction;
    procedure SetPanMouseAction(AValue: TdxChartMouseAction);
    procedure SetScrollMouseWheelAction(const Value: TdxChartMouseWheelAction);
  protected
    procedure DoAssign(ASource: TPersistent); override;
  public
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;
  published
    property PanMouseAction: TdxChartMouseAction read FPanMouseAction write SetPanMouseAction;
    property ScrollBars: Boolean read FScrollBars write FScrollBars default True;
    property ScrollMouseWheelAction: TdxChartMouseWheelAction read FScrollMouseWheelAction write SetScrollMouseWheelAction;
  end;

  TdxChartSimpleToolTipOptions = class(TcxOwnedPersistent)
  private
    FShowForSeries: Boolean;
    FShowForPoints: Boolean;
    FUseHintPause: Boolean;
  protected
    procedure DoAssign(Source: TPersistent); override;
  public
    constructor Create(AOwner: TPersistent); override;
  published
    property ShowForPoints: Boolean read FShowForPoints write FShowForPoints default True;
    property ShowForSeries: Boolean read FShowForSeries write FShowForSeries default False;
    property UseHintPause: Boolean read FUseHintPause write FUseHintPause default False;
  end;

  TdxChartCrosshairLayer = (AboveMarkers, BelowLegend, AboveLegend); // for internal use

  IdxChartCrosshairController = interface //for internal use
  ['{C2D8B55F-6F77-4C65-88B5-E918F4146AFD}']
    procedure DiagramsChanged;
    function GetCrosshairViewInfos(ALayer: TdxChartCrosshairLayer): TdxChartItemsViewInfoList;
    procedure HideCrosshair(ADiagram: TdxChartCustomDiagram);
    procedure LayoutChanged;
    procedure OptionsChanged;
    procedure ShowCrosshair(ADiagram: TdxChartCustomDiagram; APosition: TdxPointF);
  end;


  TdxChartCrosshairLabelAppearance = class(TdxChartVisualElementAppearance)
  strict private const
    DefaultCaptionOffset: Single = 4;
    DefaultItemIndent = 2.0;
    DefaultImageSize: TdxSizeF = (cx: 20; cy: 16);
    DefaultPaddingValue = 8;
  strict private
    FCaptionOffset: Single;
    FImageSize: TdxSizeFloat;
    FItemIndent: Single;
    function GetFontOptions: TdxChartVisualElementFontOptions;
    function IsCaptionOffsetStored: Boolean;
    function IsItemIndentStored: Boolean;
    procedure SetCaptionOffset(const AValue: Single);
    procedure SetFontOptions(AValue: TdxChartVisualElementFontOptions);
    procedure SetImageSize(const AValue: TdxSizeFloat);
    procedure SetItemIndent(const Value: Single);
    procedure SizeChangeHandler(Sender: TObject);
  protected
    procedure ChangeScaleCore(M, D: Integer); override;
    function DefaultBorder: Boolean; override;
    function DefaultPadding: Integer; override;
    function HasFillOptions: Boolean; override;
    function HasFontOptions: Boolean; override;
    property ItemIndent: Single read FItemIndent write SetItemIndent stored IsItemIndentStored; 
  public
    constructor Create(AOwner: TPersistent; AParent: TdxChartVisualElementAppearance); override;
    destructor Destroy; override;
  published
    property Border;
    property BorderColor;
    property BorderThickness;
    property CaptionOffset: Single read FCaptionOffset write SetCaptionOffset stored IsCaptionOffsetStored;  
    property FillOptions;
    property FontOptions: TdxChartVisualElementFontOptions read GetFontOptions write SetFontOptions;
    property ImageSize: TdxSizeFloat read FImageSize write SetImageSize;
    property Padding;
    property TextColor;
  end;

  TdxChartCrosshairLabels = class(TdxChartVisualElementPersistent)
  strict private
    function GetAppearance: TdxChartCrosshairLabelAppearance;
    procedure SetAppearance(AValue: TdxChartCrosshairLabelAppearance);
  protected
    // TdxChartVisualElementPersistent
    function CreateAppearance: TdxChartVisualElementAppearance; override;

  published
    property Appearance: TdxChartCrosshairLabelAppearance read GetAppearance write SetAppearance;
    property Visible;
  end;

  TdxChartCrosshairLineAppearance = class(TdxChartVisualElementAppearance)
  public const
    DefaultCrosshairLineColor = $ffde39cd; //for internal use
  protected
    procedure DoChanged; override;
    function HasStrokeOptions: Boolean; override;
    function GetActualColor(AIndex: Integer): TdxAlphaColor; override;
  published
    property StrokeOptions;
  end;

  TdxChartCrosshairLines = class(TdxChartVisualElementPersistent)
  strict private
    FVisibleByDefault: Boolean;
    function GetAppearance: TdxChartCrosshairLineAppearance;
    procedure SetAppearance(AValue: TdxChartCrosshairLineAppearance);
  protected
    // TdxChartVisualElementPersistent
    function CreateAppearance: TdxChartVisualElementAppearance; override;
    function GetDefaultVisible: Boolean; override;
  public
    constructor Create(AOwner: TPersistent; AVisibleByDefault: Boolean); reintroduce;
  published
    property Appearance: TdxChartCrosshairLineAppearance read GetAppearance write SetAppearance;
    property Visible;
  end;

  TdxChartCrosshairSnapToPointMode = (Argument, Value, NearestToCursor);
  TdxChartCrosshairSnapToSeriesMode = (NearestToFreeLine, NearestToCursor, All);
  TdxChartCrosshairStickyLines = (None, SingleAxis, Crosshair);

  TdxChartCrosshairOptions = class(TdxChartVisualElementPersistent)
  private
    FArgumentLines: TdxChartCrosshairLines;
    FChart: TdxChart;
    FHighlightPoints: Boolean;
    FLabels: TdxChartCrosshairLabels;
    FSnapToOutRangePoints: Boolean;
    FSnapToPointMode: TdxChartCrosshairSnapToPointMode;
    FSnapToSeriesMode: TdxChartCrosshairSnapToSeriesMode;
    FStickyLines: TdxChartCrosshairStickyLines;
    FValueLines: TdxChartCrosshairLines;
    FShowValueLabels: Boolean;
    FShowArgumentLabels: Boolean;
    procedure SetSnapToSeriesMode(const Value: TdxChartCrosshairSnapToSeriesMode);
    procedure SetSnapToPointMode(const Value: TdxChartCrosshairSnapToPointMode);
    procedure SetStickyLines(const Value: TdxChartCrosshairStickyLines);
    procedure SetLabels(const Value: TdxChartCrosshairLabels);
    procedure SetArgumentLines(const Value: TdxChartCrosshairLines);
    procedure SetValueLines(const Value: TdxChartCrosshairLines);
  protected
    //TdxChartVisualElementPersistent
    function CreateAppearance: TdxChartVisualElementAppearance; override;
    function GetParentElement: IdxChartVisualElement; override;
    procedure DoAssign(Source: TPersistent); override;
    procedure LayoutChanged; override;
  public
    constructor Create(AOwner: TPersistent; AChart: TdxChart); reintroduce;
    destructor Destroy; override;
  published
    property ArgumentLines: TdxChartCrosshairLines read FArgumentLines write SetArgumentLines;
    property HighlightPoints: Boolean read FHighlightPoints write FHighlightPoints default True;
    property Labels: TdxChartCrosshairLabels read FLabels write SetLabels;
    property ShowArgumentLabels: Boolean read FShowArgumentLabels write FShowArgumentLabels default True;
    property ShowValueLabels: Boolean read FShowValueLabels write FShowValueLabels default False;
    property SnapToOutRangePoints: Boolean read FSnapToOutRangePoints write FSnapToOutRangePoints default False;
    property SnapToPointMode: TdxChartCrosshairSnapToPointMode read FSnapToPointMode write SetSnapToPointMode default TdxChartCrosshairSnapToPointMode.Argument;  
    property SnapToSeriesMode: TdxChartCrosshairSnapToSeriesMode read FSnapToSeriesMode write SetSnapToSeriesMode default TdxChartCrosshairSnapToSeriesMode.All; 
    property StickyLines: TdxChartCrosshairStickyLines read FStickyLines write SetStickyLines default TdxChartCrosshairStickyLines.SingleAxis; 
    property ValueLines: TdxChartCrosshairLines read FValueLines write SetValueLines;
  end;

  TdxChartToolTips = class(TcxOwnedPersistent)
  strict private
    FCrosshairOptions: TdxChartCrosshairOptions;
    FDefaultMode: TdxChartActualToolTipMode;
    FSimpleToolTipOptions: TdxChartSimpleToolTipOptions;
    procedure SetCrosshairOptions(const Value: TdxChartCrosshairOptions);
    procedure SetSimpleToolTipOptions(const Value: TdxChartSimpleToolTipOptions);
  protected
    procedure DoAssign(Source: TPersistent); override;
  public
    constructor Create(AOwner: TdxChart); reintroduce;
    destructor Destroy; override;
  published
    property CrosshairOptions: TdxChartCrosshairOptions read FCrosshairOptions write SetCrosshairOptions;
    property DefaultMode: TdxChartActualToolTipMode read FDefaultMode write FDefaultMode default TdxChartToolTipMode.None;
    property SimpleToolTipOptions: TdxChartSimpleToolTipOptions read FSimpleToolTipOptions write SetSimpleToolTipOptions;
  end;

  { TdxChart }

  TdxChart = class(TcxLockablePersistent, IdxSkinSupport, IcxCustomCanvasSupport, IdxChartVisualElement) // for internal use
  protected type
    TChartChange = (Layout, Style);
    TChartChanges = set of TChartChange;
  public const
    DefaultMargins: Integer = 5;
    DefaultPadding: Integer = 2;
    ThreadingMinRecords = 500;
    DefaultUseThreading: Boolean = True;
  public type
    TChartMouseActionKind = (Pan, ZoomIn, ZoomOut, MarqueeZoom); // for internal use
  strict private
    FAppearance: TdxChartAppearance;
    FCanvas: TcxCustomCanvas;
    FColorScheme: TdxChartColorScheme;
    FColorSchemeName: string;
    FCrosshairController: IdxChartCrosshairController;
    FDataController: TdxChartDataController;
    FDiagrams: TdxFastObjectList;
    FLegend: TdxChartLegend;
    FLookAndFeel: TcxLookAndFeel;
    FOwnerControl: IdxChartOwner;
    FScaleFactor: TdxScaleFactor;
    FScrollOptions: TdxChartScrollOptions;
    FTitles: TdxChartTitles;
    FToolTips: TdxChartToolTips;
    FUseRightToLeftAlignment: Boolean;
    FUseRightToLeftReading: Boolean;
    FUseThreading: TdxDefaultBoolean;
    FViewInfo: TdxChartViewInfo;
    FVisibleDiagrams: TdxFastObjectList;
    FZoomOptions: TdxChartZoomOptions;

    FOnChange: TNotifyEvent;

    function ActuallyVisible: Boolean;
    function GetAppearance: TdxChartVisualElementAppearance;
    function GetBounds: TRect;
    function GetChart: TdxChart; inline;
    function GetDiagram(AIndex: Integer): TdxChartCustomDiagram;
    function GetDiagramCount: Integer;
    function GetLookAndFeelPainter: TcxCustomLookAndFeelPainter;
    function GetParentElement: IdxChartVisualElement;
    function GetVisibleDiagram(AIndex: Integer): TdxChartCustomDiagram; inline;
    function GetVisibleDiagramCount: Integer; inline;
    procedure LayoutChanged;
    procedure SetAppearance(AValue: TdxChartAppearance);
    procedure SetBounds(const AValue: TRect);
    procedure SetColorSchemeName(const Value: string);
    procedure SetDiagram(AIndex: Integer; AValue: TdxChartCustomDiagram);
    procedure SetDiagramList(AValue: TdxFastObjectList);
    procedure SetScrollOptions(AValue: TdxChartScrollOptions);
    procedure SetUseRightToLeftAlignment(AValue: Boolean);
    procedure SetUseRightToLeftReading(AValue: Boolean);
    procedure SetZoomOptions(AValue: TdxChartZoomOptions);
    procedure StyleChanged;
    procedure TextColorChanged;
    procedure SetToolTips(const Value: TdxChartToolTips);
  protected
    Changes: TChartChanges;
    procedure AddDiagram(ADiagram: TdxChartCustomDiagram); overload;
    procedure BiDiModeChanged;
    procedure Calculate;
    procedure CalculateColorScheme;
    function CanCalculate: Boolean;
    procedure Changed(AChange: TChartChange); overload;
    procedure Changed(AChange: TChartChanges); overload;
    function CreateAppearance: TdxChartAppearance; virtual;
    function CreateDataController: TdxChartDataController; virtual;
    function CreateLegend: TdxChartLegend; virtual;
    procedure CreateSubClasses; virtual;
    function CreateTitles: TdxChartTitles; virtual;
    procedure DestroySubClasses; virtual;
    procedure DiagramsChanged; virtual;
    procedure DoChanged; override;
    procedure EnableExportMode(AEnable: Boolean);
    function ExportToSmartImage(ACodecClass: TdxSmartImageCodecClass = nil; AImageWidth: Integer = 0; AImageHeight: Integer = 0): TdxSmartImage;
    procedure ExportToDocument(const AStream: TStream; AExporterClass: TdxSmartImageExporterClass = nil;
      AImageWidth: Integer = 0; AImageHeight: Integer = 0); overload;
    procedure ExportToDocument(const AFileName: string; AExporterClass: TdxSmartImageExporterClass;
      AImageWidth: Integer = 0; AImageHeight: Integer = 0); overload;
    procedure ExtractItemsBeforeAssign(var ADiagramsList, ASeriesList: TdxFastObjectList);
    procedure FormatChanged(Sender: TObject); virtual;
    function GetMouseAction(AKind: TChartMouseActionKind): TdxChartMouseAction;
    function GetOwnerComponent: TComponent;
    function GetOwnerForm: TComponent;
    function GetRootOwner: TComponent;
    procedure Invalidate;
    procedure InvalidateRect(const ARect: TdxRectF);
    procedure RemoveDiagram(ADiagram: TdxChartCustomDiagram);
    procedure CanvasChanged(ACanvas: TcxCustomCanvas);
    procedure ColorSchemeChanged;
    procedure LookAndFeelChanged(Sender: TcxLookAndFeel; AChangedValues: TcxLookAndFeelValues); virtual;
    function NeedThreading(ACount: Integer): Boolean; inline;

    property ColorScheme: TdxChartColorScheme read FColorScheme;
    property CrosshairController: IdxChartCrosshairController read FCrosshairController;
    property DataController: TdxChartDataController read FDataController;
    property DiagramList: TdxFastObjectList read FDiagrams write SetDiagramList;
    property OwnerComponent: TComponent read GetOwnerComponent;
    property OwnerControl: IdxChartOwner read FOwnerControl;
    property ScaleFactor: TdxScaleFactor read FScaleFactor;
    property ViewInfo: TdxChartViewInfo read FViewInfo write FViewInfo;
  public
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure AssignFrom(ASource: TdxChart; ARecreate: Boolean = True); virtual;
    function AddDiagram(ADiagramClass: TdxChartDiagramClass; const ACaption: string = ''): TdxChartCustomDiagram; overload;
    function AddDiagram<T: TdxChartCustomDiagram>(const ACaption: string = ''): T; overload;
    procedure ChangeScale(M, D: Integer);
    procedure LoadFromStream(AStream: TStream);
    procedure PaintTo(ACanvas: TcxCustomCanvas); overload;
    procedure PaintTo(ACanvas: TcxCustomCanvas; const ABounds: TRect; ARecalculate: Boolean = False); overload;  
    procedure SaveToStream(AStream: TStream);

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

    property Appearance: TdxChartAppearance read FAppearance write SetAppearance;
    property Bounds: TRect read GetBounds write SetBounds;
    property ColorSchemeName: string read FColorSchemeName write SetColorSchemeName;
    property DiagramCount: Integer read GetDiagramCount;
    property Diagrams[Index: Integer]: TdxChartCustomDiagram read GetDiagram write SetDiagram; default;
    property Legend: TdxChartLegend read FLegend;
    property LookAndFeel: TcxLookAndFeel read FLookAndFeel;
    property LookAndFeelPainter: TcxCustomLookAndFeelPainter read GetLookAndFeelPainter;
    property ScrollOptions: TdxChartScrollOptions read FScrollOptions write SetScrollOptions;
    property Titles: TdxChartTitles read FTitles;
    property ToolTips: TdxChartToolTips read FToolTips write SetToolTips;
    property UseRightToLeftAlignment: Boolean read FUseRightToLeftAlignment write SetUseRightToLeftAlignment;
    property UseRightToLeftReading: Boolean read FUseRightToLeftReading write SetUseRightToLeftReading;
    property UseThreading: TdxDefaultBoolean read FUseThreading write FUseThreading;
    property VisibleDiagrams[Index: Integer]: TdxChartCustomDiagram read GetVisibleDiagram;
    property VisibleDiagramCount: Integer read GetVisibleDiagramCount;
    property ZoomOptions: TdxChartZoomOptions read FZoomOptions write SetZoomOptions;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  { TdxChartDataController }

  TdxChartDataController = class(TcxOwnedPersistent)
  protected type
    TForEachSeriesProc = reference to procedure(ASeries: TdxChartCustomSeries);
  strict private
    FEmptySharedStorage: TObject;
    FSeries: TdxFastObjectList;
    FSharedStorages: TdxFastObjectList;

    function GetChart: TdxChart; inline;
  protected
    procedure AddSeries(ASeries: TdxChartCustomSeries);
//    procedure Changed; virtual;
    procedure PopulateStoredSeries(AList: TList);
    procedure RefreshSeriesData(ASeries: TdxChartCustomSeries);
    procedure RemoveSeries(ASeries: TdxChartCustomSeries);
    procedure StorageDataChanged(Sender: TObject);
  public
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;
    procedure ClearAllRecords;
    procedure ForEachSeries(AProc: TForEachSeriesProc);
    function GetSeriesByName(const AName: string; ASeriesList: TList = nil): TdxChartCustomSeries;
    procedure LoadFromStream(AStream: TStream); virtual;
    procedure SaveToStream(AStream: TStream); virtual;
    procedure SharedStorageAdd(AKey: TComponent; ADataBinding: TdxChartSeriesCustomDataBinding);
    procedure SharedStorageRemove(ADataBinding: TdxChartSeriesCustomDataBinding);

    property Chart: TdxChart read GetChart;
    property SeriesList: TdxFastObjectList read FSeries;
  end;

  {  TdxChartTextFormatController }

  TdxChartTextFormatController = class(TInterfacedPersistent, IcxFormatControllerListener, IdxLocalizerListener)
  private class var
    FInstance: TdxChartTextFormatController;
    FPointToolTipDefaultFormatter: TObject;
    FSimpleSeriesDefaultFormatter: TObject;
    FSimpleSeriesCenteredTotalValueTextFormatter: TObject;
    FSimpleSeriesTotalValueFormatter: TObject;
    FXYSeriesPointToolTipDefaultFormatter: TObject;
    function GetSimpleSeriesDefaultFormatter: TObject;
    function GetSimpleSeriesCenteredTotalValueTextFormatter: TObject;
    function GetSimpleSeriesTotalValueFormatter: TObject;
    function GetPointToolTipDefaultFormatter: TObject;
    function GetXYSeriesPointToolTipDefaultFormatter: TObject;
  strict private
    FFormats: TdxSpreadSheetFormats;
    FChartFormats: TdxChartFormats;
    FChangeHandler: TdxMulticastMethod<TNotifyEvent>;
    FSettings: TObject;
  protected
    procedure FormatChanged;
    class function GetSpreadsheetValueFormatter(const AFormatCode: string): TdxSpreadSheetFormatHandle;
    class function FormatValue(const AValue: Variant; AFormat: TObject): string; overload;
    class function FormatValue(const AValue: Variant; AFormat: TObject; const AFormatSettings: TFormatSettings): string; overload;
    // IdxLocalizerListener
    procedure TranslationChanged;
  public
    class function FormatController: TdxChartTextFormatController; inline;
    property Formats: TdxSpreadSheetFormats read FFormats;
    property ChartFormats: TdxChartFormats read FChartFormats;
    property Settings: TObject read FSettings;
    property ChangeHandler: TdxMulticastMethod<TNotifyEvent> read FChangeHandler;
    property PointToolTipDefaultFormatter: TObject read GetPointToolTipDefaultFormatter;
    property SimpleSeriesDefaultFormatter: TObject read GetSimpleSeriesDefaultFormatter;
    property SimpleSeriesCenteredTotalValueTextFormatter: TObject read GetSimpleSeriesCenteredTotalValueTextFormatter;
    property SimpleSeriesTotalValueFormatter: TObject read GetSimpleSeriesTotalValueFormatter;
    property XYSeriesPointToolTipDefaultFormatter: TObject read GetXYSeriesPointToolTipDefaultFormatter;
  public
    constructor Create;
    destructor Destroy; override;

    class function Add(const AFormat: string; var AHandler: TObject; ALocaleID: Integer = -1): Boolean;
    class function FormatPattern(AFormatter: TObject; const AGetVariable: TdxChartNamedValueProvider): string;
    class function GetFormat(AFormat: TObject): string; overload;
    class function GetFormatByID(const AID: Integer): TObject;
    class procedure PopulatePredefinedFormats(AList: TStrings);
    class procedure Release(var AHandler: TObject);
  end;

  TdxChartDragAndDropObjectBase = class(TcxDragAndDropObject) // for internal use
  strict private
    FDiagram: TdxChartCustomDiagram;
    FDiagramViewInfo: TdxChartDiagramCustomViewInfo;
    FStartPoint: TPoint;
  protected
    function ProcessKeyDown(AKey: Word; AShiftState: TShiftState): Boolean; override;
    function ProcessKeyUp(AKey: Word; AShiftState: TShiftState): Boolean; override;
    property StartPoint: TPoint read FStartPoint;
    property Diagram: TdxChartCustomDiagram read FDiagram;
    property DiagramViewInfo: TdxChartDiagramCustomViewInfo read FDiagramViewInfo;
  public
    procedure Init(ADiagram: TdxChartCustomDiagram; AStartPoint: TPoint); virtual;
  end;

  { TConnectionPointFinder }

  TConnectionPointFinder = class // for internal use
  private
    class function GetSquareDistance(const APoint1, APoint2: TdxPointF): Single;
  public
    class function GetNearest(const APoint: TdxPointF; const ARect: TdxRectF): TdxPointF;
  end;

  TdxChartValueTextCalculator = class(TdxHashTableItem) // for internal use
  private type
    TItem = class
    strict private
      FHandler: TdxSpreadSheetFormatHandle;
      FText: string;
    public
      constructor Create(const AText: string; AHandler: TdxSpreadSheetFormatHandle = nil);
      destructor Destroy; override;
      function GetText(ACalculator: TdxChartValueTextCalculator): string;
    end;
  strict private
    FItems: TObjectList<TItem>;
    FResult: TStringBuilder;
    FPattern: string;
    FCurrent: PChar;
    FGetVariable: TdxChartNamedValueProvider;
    procedure FlushText;
    procedure FlushVariable(const AName: string; AHandler: TdxSpreadSheetFormatHandle);
    function GetHandlerByFormat(const AFormat: string): TdxSpreadSheetFormatHandle;
    function ParseVariable: Boolean;
    function ParseVariableName: string;
    function ParseVariableFormat: string;
  protected
    procedure CalculateHash(var AHash: Integer); override;
    function DoIsEqual(const AItem: TdxHashTableItem): Boolean; override;
    property GetVariable: TdxChartNamedValueProvider read FGetVariable;
  public
    function Parse(const APattern: string): Boolean;
    function Format(const AGetVariable: TdxChartNamedValueProvider): string;
    destructor Destroy; override;
    property Pattern: string read FPattern;
  end;

  { TdxChartFormats }

  TdxChartFormats = class(TdxHashTable) // for internal use
  public
    function AddFormat(const AFormatText: string): TdxChartValueTextCalculator;
  end;

function dxChartRegisteredDataBindings: TcxRegisteredClasses;
function dxChartRegisteredSeriesView: TcxRegisteredClasses;

procedure dxTestMessage(const AMessage: string);
function dxChartCalculateTextFlags(AAlignment: TdxAlignment; AHorizontal, AWordWrap, AUseRTL: Boolean): Cardinal;

implementation

uses
  RTLConsts,
{$IFNDEF NONDB}
  FMTBcd, SqlTimSt,
{$ENDIF}
  dxSpreadSheetNumberFormatCore, dxSpreadSheetTypes, dxSpreadSheetNumberFormat,

  dxChartSimpleDiagram, dxChartXYDiagram, dxChartData,
  dxChartXYSeriesLineView, dxChartXYSeriesAreaView, dxChartXYSeriesBarView,
  dxChartLegend, dxChartStrs, cxDateUtils, dxDPIAwareUtils, dxChartCrosshair;

const
  dxThisUnitName = 'dxChartCore';

type
  TdxChartLegendAlignments = set of TdxChartLegendAlignment;
  TdxStorageItemAccess = class(TdxStorageItem);
  TdxFontOptionsAccess = class(TdxFontOptions);
  TdxSpreadSheetFormatsAccess = class(TdxSpreadSheetFormats);
  TdxNumberFormatAccess = class(TdxSpreadSheetFormatHandle);

  TdxCloneComponentInitProc = reference to procedure(ASource, AClone: TComponent);

  TdxChartFontOptions = class(TdxFontOptions) // for internal use
  strict private
    FChartOwner: IdxChartOwner;
    FParentFont: Boolean;
    procedure ParentFontChanged(Sender: TObject);
    procedure ResetParentFont;
  protected
    function GetBold: Boolean; override;
    function GetCharset: TFontCharset; override;
    function GetHeight: Integer; override;
    function GetItalic: Boolean; override;
    function GetName: TFontName; override;
    function GetPitch: TdxFontPitch; override;
    function GetQuality: TdxFontQuality; override;
    function GetStrikeOut: Boolean; override;
    function GetUnderline: Boolean; override;
    function IsBoldStored: Boolean; override;
    function IsCharsetStored: Boolean; override;
    function IsItalicStored: Boolean; override;
    function IsNameStored: Boolean; override;
    function IsPitchStored: Boolean; override;
    function IsQualityStored: Boolean; override;
    function IsSizeStored: Boolean; override;
    function IsStrikeOutStored: Boolean; override;
    function IsUnderlineStored: Boolean; override;
    procedure SetBold(const AValue: Boolean); override;
    procedure SetCharset(AValue: TFontCharset); override;
    procedure SetHeight(AValue: Integer); override;
    procedure SetItalic(const AValue: Boolean); override;
    procedure SetName(const AValue: TFontName); override;
    procedure SetPitch(AValue: TdxFontPitch); override;
    procedure SetQuality(AValue: TdxFontQuality); override;
    procedure SetStrikeOut(const AValue: Boolean); override;
    procedure SetUnderline(const AValue: Boolean); override;

    property ChartOwner: IdxChartOwner read FChartOwner;
  public
    constructor Create(AOwner: TdxChartAppearance); reintroduce;
    destructor Destroy; override;
  end;

  TdxChartGroupValueTask = class(TdxTask)
  public type
    TAsyncValueProc = procedure(const AValue: TdxChartSeriesValueViewInfo) of object;
  strict private
    FAsyncProc: TAsyncValueProc;
    FFinish: TdxChartSeriesValueViewInfo;
    FStart: TdxChartSeriesValueViewInfo;
  public
    constructor Create(AStart, AFinish: TdxChartSeriesValueViewInfo; AProc: TAsyncValueProc);
    procedure Execute; override;
  end;

  TdxChartGroupResamplingTask = class(TdxTask)
  public type
    TAsyncResamplingProc = procedure(const AStart, AFinish: TdxChartSeriesValueViewInfo) of object;
  strict private
    FAsyncProc: TAsyncResamplingProc;
    FFinish: TdxChartSeriesValueViewInfo;
    FStart: TdxChartSeriesValueViewInfo;
  public
    constructor Create(AStart, AFinish: TdxChartSeriesValueViewInfo; AProc: TAsyncResamplingProc);
    procedure Execute; override;
  end;

  { TdxChartSeriesSharedStorage }

  TdxChartSeriesSharedStorage = class
  strict private
  protected
    Key: TComponent;
    RefCount: Integer;
    Storage: TdxDataStorage;
  public
    constructor Create(AKey: TComponent; AStorage: TdxDataStorage);
    destructor Destroy; override;
    function AddRef: Integer;
    function Release: Integer;

  end;

  { TdxChartStreamHeader }

  TdxChartStreamHeader = packed record
    ID: array[0..1] of AnsiChar;
    Version: Byte;
    Size: Integer;
    SeriesCount: Word;
  end;

  { TdxAppearanceListener }

  TdxAppearanceListener = class(TdxChartVisualElementAppearance)
  private
    FViewInfo: TdxChartSeriesViewCustomViewInfo;
  protected
    procedure DoChanged; override;
    function HasFillOptions: Boolean; override;
    function HasFontOptions: Boolean; override;
    function HasStrokeOptions: Boolean; override;

    property ViewInfo: TdxChartSeriesViewCustomViewInfo read FViewInfo;
  public
    constructor Create(AOwner: TdxChartSeriesViewCustomViewInfo); reintroduce; overload;
  end;

  { TdxChartFormatSettings }

  TdxChartFormatSettings = class(TdxSpreadSheetFormatSettings)
  protected
    function GetLocaleID: Integer; override;
  public
    procedure UpdateSettings; override;
  end;

  {TdxChartCustomDateTimeNumberFormat}

  TdxChartCustomDateTimeNumberFormat = class(TdxSpreadSheetNumberFormat)
  private
    FFormatCode: string;
  protected
    const UseSystemLongDateCode = 'dddddd';
    procedure Format(const AValue: Variant; AValueType: TdxSpreadSheetCellDataType;
      const AFormatSettings: TdxSpreadSheetCustomFormatSettings; var AResult: TdxSpreadSheetNumberFormatResult); override;
    function GetFormatCode(const ALocaleID: Integer): string; override;
  public
    constructor Create(const AFormatCode: string; AFormatCodeId: Integer = -1);
  end;

  TdxChartFormatterInfo = record
    FormatCode: string;
    FormatCodeID: Integer;
    procedure Create(AFormatCodeID: Integer; const AFormatCode: string);
  end;

procedure TdxChartFormatterInfo.Create(AFormatCodeID: Integer; const AFormatCode: string);
begin
  FormatCodeID := AFormatCodeID;
  FormatCode := AFormatCode;
end;

var
  dxChartAdditionalFormatters: array of TdxChartFormatterInfo;

const
  DefaultStreamHeader: TdxChartStreamHeader = (ID: ('D', 'X'); Version: 1; Size: 0; SeriesCount: 0);
  DefaultTopNModeValue: array[TdxChartSeriesTopNOptionsMode] of Double = (5, 50, 10);
  LegendOutsideAlignments: TdxChartLegendAlignments = [TdxChartLegendAlignment.NearOutside, TdxChartLegendAlignment.FarOutside];

var
  FRegisteredDataBindings: TcxRegisteredClasses;
  FRegisteredSeriesView: TcxRegisteredClasses;
  FRegisteredSeriesViewImages: TcxImageList;

procedure dxTestMessage(const AMessage: string);
begin
  raise EdxChartException.Create(AMessage);
end;

function dxChartCalculateTextFlags(AAlignment: TdxAlignment; AHorizontal, AWordWrap, AUseRTL: Boolean): Cardinal;
const
  RTLFlags: array[Boolean] of Cardinal = (0, CXTO_RTLREADING);
  HorzAlignmentFlags: array[Boolean, TdxAlignment] of Cardinal = (
    (CXTO_CENTER_HORIZONTALLY, CXTO_LEFT, CXTO_CENTER_HORIZONTALLY, CXTO_RIGHT),
    (CXTO_CENTER_HORIZONTALLY, CXTO_RIGHT, CXTO_CENTER_HORIZONTALLY, CXTO_LEFT));
  VertAlignmentFlags: array[TdxAlignment] of Cardinal =
    (CXTO_CENTER_VERTICALLY, CXTO_BOTTOM, CXTO_CENTER_VERTICALLY, CXTO_TOP);
  WordWrapFlags: array[Boolean] of Cardinal = (CXTO_SINGLELINE, CXTO_WORDBREAK or CXTO_CHARBREAK);
  PreventExceedFlags: array[Boolean] of Cardinal = (
    (CXTO_PREVENT_LEFT_EXCEED or CXTO_CENTER_HORIZONTALLY),
    (CXTO_PREVENT_TOP_EXCEED or CXTO_CENTER_VERTICALLY));
begin
  if AHorizontal then
    Result := HorzAlignmentFlags[AUseRTL, AAlignment]
  else
    Result := VertAlignmentFlags[AAlignment];
  Result := Result or RTLFlags[AUseRTL] or WordWrapFlags[AWordWrap] or PreventExceedFlags[AHorizontal];
  Result := Result or CXTO_END_ELLIPSIS;
end;

{ TdxAppearanceListener }

constructor TdxAppearanceListener.Create(AOwner: TdxChartSeriesViewCustomViewInfo);
begin
  FViewInfo := AOwner;
  inherited Create(AOwner.View, AOwner.Appearance);
end;

procedure TdxAppearanceListener.DoChanged;
var
  I: Integer;
begin
  for I := 0 to ViewInfo.ColorizedItems.Count - 1 do
    TdxChartColorizedAppearance(ViewInfo.ColorizedItems.List[I]).ParentChanged;
end;

function TdxAppearanceListener.HasFillOptions: Boolean;
begin
  Result := False;
end;

function TdxAppearanceListener.HasFontOptions: Boolean;
begin
  Result := False;
end;

function TdxAppearanceListener.HasStrokeOptions: Boolean;
begin
  Result := False;
end;

{ TdxChartGroupValueTask }

constructor TdxChartGroupValueTask.Create(AStart, AFinish: TdxChartSeriesValueViewInfo; AProc: TAsyncValueProc);
begin
  FAsyncProc := AProc;
  FStart := AStart;
  FFinish := AFinish;
end;

procedure TdxChartGroupValueTask.Execute;
var
  APriorValue,  AValue: TdxChartSeriesValueViewInfo;
begin
  FStart.FPriorDisplayValue := nil;
  FStart.FNextDisplayValue := nil;
  FAsyncProc(FStart);
  if FStart = FFinish then
    Exit;

  AValue := FStart.Next;
  APriorValue := FStart;

  while AValue <> FFinish do
  begin
    if TdxChartSeriesValueViewInfo.TValueState.Visible in AValue.FState then
    begin
      AValue.FPriorDisplayValue := APriorValue;
      APriorValue.FNextDisplayValue := AValue;
      APriorValue := AValue;
      FAsyncProc(AValue);
    end
    else
    begin
      AValue.FPriorDisplayValue := nil;
      AValue.FNextDisplayValue := nil;
    end;
    AValue := AValue.Next;
  end;

  FFinish.FPriorDisplayValue := APriorValue;
  APriorValue.FNextDisplayValue := FFinish;
  FFinish.FNextDisplayValue := nil;
  FAsyncProc(FFinish);
end;

{ TdxChartGroupResamplingTask }

constructor TdxChartGroupResamplingTask.Create(AStart, AFinish: TdxChartSeriesValueViewInfo; AProc: TAsyncResamplingProc);
begin
  FAsyncProc := AProc;
  FStart := AStart;
  FFinish := AFinish;
end;

procedure TdxChartGroupResamplingTask.Execute;
begin
  FAsyncProc(FStart, FFinish);
end;

//
function dxChartRegisteredDataBindings: TcxRegisteredClasses;
begin
  if FRegisteredDataBindings = nil then
    FRegisteredDataBindings := TcxRegisteredClasses.Create;
  Result := FRegisteredDataBindings;
end;

function dxChartRegisteredSeriesView: TcxRegisteredClasses;
begin
  if FRegisteredSeriesView = nil then
    FRegisteredSeriesView := TcxRegisteredClasses.Create;
  Result := FRegisteredSeriesView;
end;

procedure dxClearComponentList(AList: TdxFastObjectList);
var
  I: Integer;
begin
  for I := AList.Count - 1 downto 0 do
      AList[I].Free;
  AList.Clear;
end;

procedure dxSafeCloneComponentList(ASource: TdxFastObjectList; AOwnerForm, AOwner: TComponent;
  AInitProc: TdxCloneComponentInitProc; AStoreList: TdxFastObjectList);
var
  I: Integer;
  AIntf: IdxChartCloneComponent;
  AClone, ASourceComponent: TComponent;
begin
  for I := 0 to ASource.Count - 1 do
  begin
    ASourceComponent := TComponent(ASource[I]);
    AClone := nil;
    AIntf := nil;
    if Supports(ASourceComponent, IdxChartCloneComponent, AIntf) then
      AClone := AStoreList.Extract(AIntf.GetSource) as TComponent;
    if AClone = nil then
    begin
      AClone := TComponentClass(ASourceComponent.ClassType).Create(AOwner);
      AClone.Name := CreateUniqueName(AOwnerForm, AOwner, AClone, 'TdxChart', '');
    end;
    AInitProc(ASourceComponent, AClone);
  end;
end;

{ TdxChartSeriesSharedStorage }

constructor TdxChartSeriesSharedStorage.Create(AKey: TComponent; AStorage: TdxDataStorage);
begin
  Key := AKey;
  RefCount := 1;
  Storage := AStorage;
end;

destructor TdxChartSeriesSharedStorage.Destroy;
begin
  if RefCount > 0 then
    raise EdxChartException.Create('Shared storage reference not empty!');
  FreeAndNil(Storage);
  inherited Destroy;
end;

function TdxChartSeriesSharedStorage.AddRef: Integer;
begin
  Inc(RefCount);
  Result := RefCount;
end;

function TdxChartSeriesSharedStorage.Release: Integer;
begin
  Dec(RefCount);
  Result := RefCount;
end;

{ TdxChartOwnedPersistent }

procedure TdxChartOwnedPersistent.Changed;
var
  AIntf: IdxChartVisualElement;
begin
  if Supports(Owner, IdxChartVisualElement, AIntf) then
    AIntf.LayoutChanged
  else
    if Owner is TdxChartOwnedPersistent then
      (Owner as TdxChartOwnedPersistent).Changed
    else
       raise Exception.Create(ClassName + ' does not implement Changed method');
end;

{ TdxChartVisualElementPersistent }

constructor TdxChartVisualElementPersistent.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FAppearance := CreateAppearance;
  FVisible := GetDefaultVisible;
end;

destructor TdxChartVisualElementPersistent.Destroy;
begin
  FreeAndNil(FAppearance);
  inherited Destroy;
end;

function TdxChartVisualElementPersistent.ActuallyVisible: Boolean;
begin
  Result := FVisible;
end;

procedure TdxChartVisualElementPersistent.ChangeScale(M, D: Integer);
begin
end;

procedure TdxChartVisualElementPersistent.DoAssign(Source: TPersistent);
var
  ASource: TdxChartVisualElementPersistent;
begin
  if Source is TdxChartVisualElementPersistent then
  begin
    ASource := TdxChartVisualElementPersistent(Source);
    FVisible := False;
    Appearance.Assign(ASource.Appearance);
    Visible := ASource.Visible;
  end;
  inherited DoAssign(Source);
end;

procedure TdxChartVisualElementPersistent.LayoutChanged;
begin
  if ActuallyVisible and (GetParentElement <> nil) then 
    GetParentElement.LayoutChanged;
end;

function TdxChartVisualElementPersistent.GetParentElement: IdxChartVisualElement;
begin
  if not Supports(Owner, IdxChartVisualElement, Result) then
    Result := nil;
end;

function TdxChartVisualElementPersistent.GetChart: TdxChart;
begin
  if GetParentElement <> nil then
    Result := GetParentElement.GetChart
  else
    Result := nil;
end;

function TdxChartVisualElementPersistent.GetDefaultVisible: Boolean;
begin
  Result := True;
end;

function TdxChartVisualElementPersistent.IsVisibleStored: Boolean;
begin
  Result := Visible = not GetDefaultVisible;
end;

procedure TdxChartVisualElementPersistent.StyleChanged;
begin
  if ActuallyVisible then
    Invalidate;
end;

procedure TdxChartVisualElementPersistent.TextColorChanged;
begin
  UpdateTextColors;
  StyleChanged;
end;

procedure TdxChartVisualElementPersistent.Invalidate;
begin
  if ActuallyVisible then 
    GetParentElement.StyleChanged;
end;

procedure TdxChartVisualElementPersistent.UpdateTextColors;
begin
  // do nothing
end;

procedure TdxChartVisualElementPersistent.VisibleChanged;
begin
  LayoutChanged;
  if not ActuallyVisible and (GetParentElement <> nil) then
    GetParentElement.LayoutChanged;
end;

function TdxChartVisualElementPersistent.GetAppearance: TdxChartVisualElementAppearance;
begin
  Result := FAppearance;
end;

procedure TdxChartVisualElementPersistent.SetAppearance(AValue: TdxChartVisualElementAppearance);
begin
  Appearance.Assign(AValue);
end;

procedure TdxChartVisualElementPersistent.SetVisible(AValue: Boolean);
var
  APrevVisible: Boolean;
begin
  if AValue <> FVisible then
  begin
    APrevVisible := ActuallyVisible;
    FVisible := AValue;
    if APrevVisible <> ActuallyVisible then
      VisibleChanged;
  end;
end;

  { TdxChartCustomVisualElement }

constructor TdxChartCustomVisualElement.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  RecreateViewInfo;
end;

destructor TdxChartCustomVisualElement.Destroy;
begin
  FreeAndNil(FViewInfo);
  inherited Destroy;
end;

procedure TdxChartCustomVisualElement.BiDiModeChanged;
begin
  ViewInfo.Dirty := True;
end;

procedure TdxChartCustomVisualElement.ChangeScale(M, D: Integer);
begin
  ViewInfo.Dirty := True;
  inherited ChangeScale(M, D);
end;

procedure TdxChartCustomVisualElement.Invalidate;
begin
  if not ViewInfo.Dirty and ViewInfo.ActuallyVisible then
    GetChart.InvalidateRect(ViewInfo.ClipRect)
  else
    if GetParentElement <> nil then
      GetParentElement.StyleChanged;
end;

procedure TdxChartCustomVisualElement.LayoutChanged;
begin
  ViewInfo.FreeCanvasBasedResources;
  inherited LayoutChanged;
end;

procedure TdxChartCustomVisualElement.RecreateViewInfo;
begin
  FreeAndNil(FViewInfo);
  FViewInfo := CreateViewInfo;
end;

procedure TdxChartCustomVisualElement.UpdateTextColors; 
begin
  if not ViewInfo.Dirty then
    ViewInfo.UpdateTextColors;
end;

{ TdxChartHintableCaptionHitElement }

constructor TdxChartHintableCaptionHitElement.Create(const AIHitTestElement: IdxChartHitTestElement;
  const ABounds: TdxRectF; AText: string; AIsTruncated: Boolean; AMultiline: Boolean = False);
begin
  inherited Create;
  FFont := TFont.Create;
  FIHitTestElement := AIHitTestElement;
  FBounds := ABounds.DeflateToTRect;
  FText := AText;
  FIsTruncated := AIsTruncated;
  FMultiline := AMultiline;
end;

destructor TdxChartHintableCaptionHitElement.Destroy;
begin
  FreeAndNil(FFont);
  inherited Destroy;
end;

procedure TdxChartHintableCaptionHitElement.UpdateFont;

  procedure DoUpdateFont(AAppearance: TdxChartVisualElementAppearance);
  begin
    if not AAppearance.HasFontOptions and (AAppearance.Parent <> nil) then
      DoUpdateFont(AAppearance.Parent)
    else
      if AAppearance.HasFontOptions then
        TdxFontOptionsAccess(AAppearance.FontOptions).AssignTo(FFont);
  end;

var
  AAppearance: TdxChartVisualElementAppearance;
begin
  AAppearance := GetAppearance;
  if AAppearance <> nil then
    DoUpdateFont(AAppearance);
end;

function TdxChartHintableCaptionHitElement.CanShowHint: Boolean;
begin
  Result := FIsTruncated;
end;

function TdxChartHintableCaptionHitElement.GetAppearance: TdxChartVisualElementAppearance;
var
  AIntf: IdxChartVisualElement;
begin
  if Supports(GetChartElement, IdxChartVisualElement, AIntf) then
    Result := AIntf.GetAppearance
  else
    Result := nil;
end;

function TdxChartHintableCaptionHitElement.GetBounds: TRect;
begin
  Result := FBounds;
end;

function TdxChartHintableCaptionHitElement.GetChartElement: TObject;
begin
  Result := FIHitTestElement.GetChartElement;
end;

function TdxChartHintableCaptionHitElement.GetHintableObject: IcxHintableObject2;
begin
  Result := Self;
end;

function TdxChartHintableCaptionHitElement.GetHintAreaBounds: TRect;
begin
  Result := Bounds;
end;

function TdxChartHintableCaptionHitElement.GetHintFont: TFont;
begin
  UpdateFont;
  Result := FFont;
end;

function TdxChartHintableCaptionHitElement.GetHintObject: TObject;
begin
  Result := nil;
end;

function TdxChartHintableCaptionHitElement.GetHintText: string;
begin
  Result := FText;
end;

function TdxChartHintableCaptionHitElement.GetHintTextBounds: TRect;
begin
  Result := Bounds;
end;

function TdxChartHintableCaptionHitElement.GetHitCode: TdxChartHitCode;
begin
  Result := FIHitTestElement.GetHitCode;
end;

function TdxChartHintableCaptionHitElement.GetSubAreaCode: Integer;
begin
  Result := FIHitTestElement.GetSubAreaCode;
end;

function TdxChartHintableCaptionHitElement.HasHintPoint(const P: TPoint): Boolean;
begin
  Result := Bounds.Contains(P);
end;

function TdxChartHintableCaptionHitElement.ImmediateShowHint: Boolean;
begin
  Result := True;
end;

function TdxChartHintableCaptionHitElement.IsHintAtMousePos: Boolean;
begin
  Result := False;
end;

function TdxChartHintableCaptionHitElement.IsHintMultiLine: Boolean;
begin
  Result := FMultiline;
end;

function TdxChartHintableCaptionHitElement.UseHintHidePause: Boolean;
begin
  Result := False;
end;

{ TdxChartHitTestEngine }

constructor TdxChartHitTestEngine.Create(AChart: TdxChart);
begin
  inherited Create;
  FChart := AChart;
end;

destructor TdxChartHitTestEngine.Destroy;
begin
  Reset;
  inherited Destroy;
end;

procedure TdxChartHitTestEngine.Calculate(const P: TdxPointF; AForce: Boolean);
begin
  Reset;
  FHitPoint := P;
  if Chart.ViewInfo = nil then
    Exit;
  if AForce then
  begin
    if Chart.CanCalculate then
      Chart.Calculate
    else
      Exit;
  end;
  Chart.ViewInfo.CalculateHitTest(Self, P);
end;

procedure TdxChartHitTestEngine.Reset;
begin
  FHitPoint := cxInvalidPoint;
  FHitElement := nil;
  FHitPlotArea := nil;
  FHitScrollableElement := nil;
end;

procedure TdxChartHitTestEngine.SetHitItemViewInfo(const AHitItemViewInfo: TdxChartCustomItemViewInfo);
var
  AHitElement: IdxChartHitTestElement;
  AHitScrollableElement: IdxChartHitTestScrollableElement;
  AHitPlotArea: IdxChartHitTestPlotAreaElement;
begin
  if AHitItemViewInfo <> nil then
  begin
    AHitElement := AHitItemViewInfo.GetHitElement(Point);
    if AHitElement <> nil then
      FHitElement := AHitElement;
    AHitScrollableElement := AHitItemViewInfo.GetHitScrollableElement(Point);
    if AHitScrollableElement <> nil then
      FHitScrollableElement := AHitScrollableElement;
    AHitPlotArea := AHitItemViewInfo.GetHitPlotArea(Point);
    if AHitPlotArea <> nil then
      FHitPlotArea := AHitPlotArea;
  end
  else
    FHitElement := nil;
end;

{ TdxChartCustomItemViewData }

procedure TdxChartCustomItemViewData.Calculate;
begin
  if Dirty then
  begin
    Dirty := False;
    DoCalculate;
  end;
end;

procedure TdxChartCustomItemViewData.DoCalculate;
begin
end;

procedure TdxChartCustomItemViewData.MakeDirty;
begin
  FDirty := True;
end;

{ TdxChartCustomItemViewInfo }

constructor TdxChartCustomItemViewInfo.Create;
begin
  inherited Create;
  FVisible := True;
end;

function TdxChartCustomItemViewInfo.ActuallyVisible: Boolean;
begin
  Result := FVisible and not FClipRect.IsEmpty;
end;

procedure TdxChartCustomItemViewInfo.Calculate(ACanvas: TcxCustomCanvas);
begin
  if Dirty then
  begin
    BeforeCalculate(ACanvas);
    DoCalculate(ACanvas);
    Dirty := False;
  end;
end;

procedure TdxChartCustomItemViewInfo.Draw(ACanvas: TcxCustomCanvas);
begin
  if Visible and Dirty then
    Calculate(ACanvas);
  if ActuallyVisible and ACanvas.RectVisible(ClipRect) then
  begin
    if HasClipping then
    begin
      ACanvas.SaveClipRegion;
      ACanvas.IntersectClipRect(ClipRect);
    end;
    DoDraw(ACanvas);
    if HasClipping then
      ACanvas.RestoreClipRegion;
  end;
end;

procedure TdxChartCustomItemViewInfo.EnableExportMode(AEnable: Boolean);
begin
  FIsExportMode := AEnable;
end;

procedure TdxChartCustomItemViewInfo.Offset(const ADistance: TdxPointF);
var
  R: TdxRectF;
begin
  R := Bounds;
  R.Offset(ADistance);
  UpdateBounds(R);
end;

procedure TdxChartCustomItemViewInfo.Offset(const ADistance: TdxPointF; const ANewVisibleBounds: TdxRectF);
var
  R: TdxRectF;
begin
  R := Bounds;
  R.Offset(ADistance);
  UpdateBounds(R, ANewVisibleBounds);
end;

procedure TdxChartCustomItemViewInfo.SetBounds(const ABounds, AVisibleBounds: TdxRectF);
begin
  Dirty := Dirty or (ABounds <> FBounds) or (VisibleBounds <> AVisibleBounds);
  FBounds := ABounds;
  FVisibleBounds := AVisibleBounds;
  UpdateClipping;
end;

procedure TdxChartCustomItemViewInfo.UpdateBounds(const ABounds: TdxRectF);
begin
  FBounds := ABounds;
  UpdateClipping;
end;

procedure TdxChartCustomItemViewInfo.UpdateBounds(const ABounds, AVisibleBounds: TdxRectF);
begin
  FVisibleBounds := AVisibleBounds;
  UpdateBounds(ABounds);
end;

procedure TdxChartCustomItemViewInfo.BeforeCalculate(ACanvas: TcxCustomCanvas);
begin
end;

procedure TdxChartCustomItemViewInfo.DoCalculate(ACanvas: TcxCustomCanvas);
begin
end;

procedure TdxChartCustomItemViewInfo.DoDraw(ACanvas: TcxCustomCanvas);
begin
end;

function TdxChartCustomItemViewInfo.CalculateHitTest(AHitTest: TdxChartHitTestEngine; const P: TdxPointF): Boolean;
begin
  Result := not Dirty and ActuallyVisible and FBounds.Contains(P);
  if Result then
    AHitTest.SetHitItemViewInfo(Self);
end;

function TdxChartCustomItemViewInfo.GetHitElement(const P: TdxPointF): IdxChartHitTestElement;
begin
  Result := nil;
end;

function TdxChartCustomItemViewInfo.GetHitPlotArea(const P: TdxPointF): IdxChartHitTestPlotAreaElement;
begin
  Result := nil;
end;

function TdxChartCustomItemViewInfo.GetHitScrollableElement(const P: TdxPointF): IdxChartHitTestScrollableElement;
begin
  if not Supports(GetHitElement(P), IdxChartHitTestScrollableElement, Result) then
    Result := nil;
end;

function TdxChartCustomItemViewInfo.NeedClipping: Boolean;
begin
  Result := FHasClipping;
end;

procedure TdxChartCustomItemViewInfo.UpdateClipping;
begin
  FHasClipping := cxRectIntersect(FClipRect, FBounds, FVisibleBounds) and (FClipRect <> FBounds);
  FHasClipping := FHasClipping or NeedClipping;
end;

procedure TdxChartCustomItemViewInfo.UpdateTextColors;
begin
 //do nothing
end;

{ TdxChartSeriesValueViewInfo }

constructor TdxChartSeriesValueViewInfo.Create(AOwner: TdxChartSeriesViewCustomViewInfo; APriorValue: TdxChartSeriesValueViewInfo);
begin
  FOwner := AOwner;
  FIndex := AOwner.FTotalCount;
  FPrior := APriorValue;
  if APriorValue <> nil then
    APriorValue.FNext := Self;
end;

function TdxChartSeriesValueViewInfo.CreateSeriesPointInfo: TdxChartSeriesPointInfo;
begin
  Result := TdxChartSeriesPointInfo.Create(Self);
end;

procedure TdxChartSeriesValueViewInfo.Draw(ACanvas: TcxCustomCanvas);
begin
end;

destructor TdxChartSeriesValueViewInfo.Destroy;
begin
  FreeValueLabel;
  DeleteNextItems;
  inherited Destroy;
end;

procedure TdxChartSeriesValueViewInfo.CalculateDisplayText;
begin
  if FRecord <> nil then
    FDisplayText := TdxChartTextFormatController.FormatPattern(Owner.ValueLabels.TextFormatter, GetValueByName)
  else
    FDisplayText := Series.TopNOptions.GetOthersDisplayText
end;

procedure TdxChartSeriesValueViewInfo.CalculateLabel(ACanvas: TcxCustomCanvas);
begin
  if FValueLabel = nil then
    FValueLabel := CreateValueLabel;
  FValueLabel.SetBounds(Owner.GetValueLabelVisibleBounds, Owner.GetValueLabelVisibleBounds);
  FValueLabel.DoCalculate(ACanvas);
end;

procedure TdxChartSeriesValueViewInfo.CalculateLabelLeaderLinePoints(
  var AStartPoint, AMiddlePoint, AEndPoint: TdxPointF);
begin
  AStartPoint := TdxPointF.Null;
  AMiddlePoint := TdxPointF.Null;
  AEndPoint := TdxPointF.Null;
end;

procedure TdxChartSeriesValueViewInfo.CalculateValue;
begin
  if FRecord <> nil then
    IsGap := not Owner.ViewData.GetValue(FRecord, FValue, FValueText)
  else
    FValue := Owner.ViewData.OthersValue;
  if IsGap then
    FState := FState - [TValueState.Visible];
end;

function TdxChartSeriesValueViewInfo.CreateValueLabel: TdxChartValueLabelCustomViewInfo;
begin
  Result := TdxChartSeriesValueLabelViewInfo.Create(Self);
end;

procedure TdxChartSeriesValueViewInfo.DeleteNextItems;
var
  ANext: TdxChartSeriesValueViewInfo;
begin
  if FNext = nil then
    Exit;
  try
    while FNext <> nil do
    begin
      ANext := FNext.FNext;
      try
        FNext.FNext := nil;
        FNext.Free;
      finally
        FNext := ANext;
      end;
    end;
  finally
    FreeAndNil(FNext);
  end;
end;

procedure TdxChartSeriesValueViewInfo.FreeValueLabel;
begin
  FreeAndNil(FValueLabel);
end;

function TdxChartSeriesValueViewInfo.GetAppearance: TdxChartVisualElementAppearance;
begin
  Result := Owner.Appearance;
end;

function TdxChartSeriesValueViewInfo.GetClipRect: TdxRectF;
begin
  Result := Owner.Bounds;
end;

function TdxChartSeriesValueViewInfo.GetDefaultPointToolTipFormatter: TObject;
begin
  Result := TdxChartTextFormatController.FormatController.PointToolTipDefaultFormatter;
end;

function TdxChartSeriesValueViewInfo.GetDisplayText: string;
begin
  if not (TValueState.DisplayTextCalculated in FState) and (TValueState.Visible in FState) then
  begin
    CalculateDisplayText;
    FState := FState + [TValueState.DisplayTextCalculated];
  end;
  Result := FDisplayText;
end;

function TdxChartSeriesValueViewInfo.GetHitElement(const P: TdxPointF): IdxChartHitTestElement;
begin
  Result := nil;
end;

function TdxChartSeriesValueViewInfo.GetLabelAnchorPoint: TdxPointF;
begin
  Result := TdxPointF.Null;
end;

procedure TdxChartSeriesValueViewInfo.UpdateRecord(const ARecord: PdxDataRecord);
begin
  FRecord := ARecord;
  FState := FState - [TValueState.DisplayTextCalculated];
  FDisplayText := '';
  FState := [TValueState.Visible];
  CalculateValue; 
end;

function TdxChartSeriesValueViewInfo.GetSeries: TdxChartCustomSeries;
begin
  Result := Owner.Series;
end;

function TdxChartSeriesValueViewInfo.GetState(AIndex: Integer): Boolean;
begin
  Result := TValueState(AIndex) in FState;
end;

function TdxChartSeriesValueViewInfo.GetValueByName(const AName: string; out AValue: Variant): Boolean;
var
  ARecordValue: Double;
  AValueText: string;
begin
  Result := True;
  if AName = TdxChartTextFormatVariableNames.Value then
  begin
    if FValueText <> '' then
      AValue := FValueText
    else
      AValue := FValue;
  end
  else if AName = TdxChartTextFormatVariableNames.Argument then
  begin
    if FRecord <> nil then
    begin
      Owner.ViewData.GetArgument(FRecord, ARecordValue, AValueText);
      if AValueText <> '' then
        AValue := AValueText
      else
        AValue := ARecordValue;
    end;
  end
  else if AName = TdxChartTextFormatVariableNames.Series then
    AValue := Series.Caption
  else
    Exit(False);
end;

function TdxChartSeriesValueViewInfo.GetViewData: TdxChartSeriesViewCustomViewData;
begin
  Result := FOwner.ViewData;
end;

function TdxChartSeriesValueViewInfo.GetVisible: Boolean;
begin
  Result :=  FState * TGapStates = [TValueState.Visible];
end;

procedure TdxChartSeriesValueViewInfo.RaiseGetValueLabelDrawParametersEvent(var AText: string);
var
  AArgs: TdxChartGetValueLabelDrawParametersEventArgs;
begin
  AArgs := TdxChartGetValueLabelDrawParametersEventArgs.Create(CreateSeriesPointInfo, AText);
  try
    ViewData.Diagram.DoGetValueLabelDrawParameters(AArgs);
    AText := AArgs.Text;
  finally
    FreeAndNil(AArgs);
  end;
end;

procedure TdxChartSeriesValueViewInfo.SetState(AIndex: Integer; AValue: Boolean);
begin
  if AValue then
    Include(FState, TValueState(AIndex))
  else
    Exclude(FState, TValueState(AIndex));
end;

procedure TdxChartSeriesValueViewInfo.SetGap(AIndex: Integer; AValue: Boolean);
begin
  if AValue then
    FState := FState + [TValueState.Gap] - [TValueState.Visible]
  else
    FState := FState - [TValueState.Gap];
end;

procedure TdxChartSeriesValueViewInfo.SetHidden(AIndex: Integer; AValue: Boolean);
begin
  if AValue then
    FState := FState - [TValueState.Visible] + [TValueState.Hidden]
  else
    FState := FState - [TValueState.Hidden];
end;

function TdxChartSeriesValueViewInfo.GetToolTipText: string;
var
  AFormatter: TObject;
begin
  AFormatter := Series.ToolTips.PointToolTipFormatter;
  if AFormatter = nil then
    AFormatter := Series.Diagram.ToolTips.PointToolTipFormatter;
  if AFormatter = nil then
    AFormatter := GetDefaultPointToolTipFormatter;
  if FRecord <> nil then
    Result := TdxChartTextFormatController.FormatPattern(AFormatter, GetValueByName)
  else
    Result := TdxChartTextFormatController.FormatPattern(AFormatter, Series.TopNOptions.GetValueByName);
  Result := Trim(Result);
end;

procedure TdxChartSeriesValueViewInfo.SetVisible(AValue: Boolean);
begin
  SetState(Integer(TValueState.Visible), AValue);
end;

{ TdxChartVisualElementCustomViewInfo }

constructor TdxChartVisualElementCustomViewInfo.Create(AAppearance: TdxChartVisualElementAppearance);
begin
  inherited Create;
  FAppearance := AAppearance;
end;

function TdxChartVisualElementCustomViewInfo.GetBorderColor: TdxAlphaColor;
begin
  Result := FAppearance.ActualBorderColor;
end;

function TdxChartVisualElementCustomViewInfo.GetBorderThickness: Single;
begin
  Result := FAppearance.ActualBorderThickness;
end;

function TdxChartVisualElementCustomViewInfo.GetBrush: TcxCanvasBasedBrush;
begin
  Result := FAppearance.ActualBrush;
end;

function TdxChartVisualElementCustomViewInfo.GetFont: TcxCanvasBasedFont;
begin
  Result := FAppearance.ActualFont;
end;

function TdxChartVisualElementCustomViewInfo.GetPadding: TRect;
begin
  Result := FAppearance.ActualPadding;
end;

function TdxChartVisualElementCustomViewInfo.GetMargins: TRect;
begin
  Result := FAppearance.ActualMargins;
end;

function TdxChartVisualElementCustomViewInfo.GetPainter: TcxCustomLookAndFeelPainter;
begin
  Result := FAppearance.LookAndFeelPainter;
end;

function TdxChartVisualElementCustomViewInfo.GetPen: TcxCanvasBasedPen;
begin
  Result := FAppearance.ActualPen;
end;

function TdxChartVisualElementCustomViewInfo.GetTextColor: TdxAlphaColor;
begin
  Result := FAppearance.ActualTextColor;
end;

function TdxChartVisualElementCustomViewInfo.GetUseRightToLeftAlignment: Boolean;
begin
  Result := FAppearance.UseRightToLeftAlignment;
end;

function TdxChartVisualElementCustomViewInfo.GetUseRightToLeftReading: Boolean;
begin
  Result := FAppearance.UseRightToLeftReading;
end;

procedure TdxChartVisualElementCustomViewInfo.BeforeCalculate(ACanvas: TcxCustomCanvas);
begin
  FContentBounds := cxRectInflate(Bounds.Content(Padding), -BorderThickness, -BorderThickness);
  Visible := FAppearance.OwnerElement.ActuallyVisible;
end;

procedure TdxChartVisualElementCustomViewInfo.DoDraw(ACanvas: TcxCustomCanvas);
var
  ABounds: TRect;
begin
  ABounds := Bounds.DeflateToTRect;
  ACanvas.EnableAntialiasing(False);
  if not TdxAlphaColors.IsTransparentOrEmpty(Appearance.ActualColor) then
    ACanvas.FillRect(ABounds, Appearance.ActualBrush);
  if BorderThickness > 0 then
    ACanvas.FrameRect(ABounds, BorderColor, BorderThickness);
  ACanvas.RestoreAntialiasing;
end;

procedure TdxChartVisualElementCustomViewInfo.FreeCanvasBasedResources;
begin
  Dirty := True;
end;

procedure TdxChartVisualElementCustomViewInfo.UpdateBounds(const ABounds: TdxRectF);
begin
  inherited UpdateBounds(ABounds);
  FContentBounds := cxRectInflate(Bounds.Content(Padding), -BorderThickness, -BorderThickness);
end;

{ TdxChartItemsViewInfoList }

function TdxChartItemsViewInfoList.GetItem(AIndex: Integer): TdxChartCustomItemViewInfo;
begin
  Result := TdxChartCustomItemViewInfo(List[AIndex])
end;

procedure TdxChartItemsViewInfoList.ForEach(AProc: TForEachViewInfoItemProc);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    AProc(TdxChartCustomItemViewInfo(List[I]));
end;

procedure TdxChartItemsViewInfoList.Calculate(ACanvas: TcxCustomCanvas);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    TdxChartCustomItemViewInfo(List[I]).Calculate(ACanvas);
end;

procedure TdxChartItemsViewInfoList.Draw(ACanvas: TcxCustomCanvas);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    TdxChartCustomItemViewInfo(List[I]).Draw(ACanvas);
end;


{ TdxChartVisualElementFontOptions }

function TdxChartVisualElementFontOptions.GetParent: TdxFontOptions;
var
  AAppearance: TdxChartVisualElementAppearance;
begin
  AAppearance := TdxChartVisualElementAppearance(Owner).Parent;
  while (AAppearance <> nil) and not AAppearance.HasFontOptions do
    AAppearance := AAppearance.Parent;
  if AAppearance = nil then
    Result := nil
  else
    Result := AAppearance.FontOptions;
end;

{ TdxChartVisualElementFontOptionsWithOverridenSize }

constructor TdxChartVisualElementFontOptionsWithOverridenSize.Create(AOwner: TdxChartVisualElementAppearance; AFactorForDefaultFontHeight: Single);
begin
  inherited Create(AOwner);
  FDefaultHeightFactor := AFactorForDefaultFontHeight;
end;

procedure TdxChartVisualElementFontOptionsWithOverridenSize.DoAssign(Source: TPersistent);
begin
  if Source is TdxChartVisualElementFontOptionsWithOverridenSize then
    FDefaultHeightFactor := TdxChartVisualElementFontOptionsWithOverridenSize(Source).FDefaultHeightFactor;
  inherited DoAssign(Source);
end;

function TdxChartVisualElementFontOptionsWithOverridenSize.GetHeight: Integer;
var
  AParent: TdxFontOptions;
begin
  AParent := GetParent;
  if (TdxFontOptionsValue.Size in AssignedValues) or (AParent = nil) then
    Result := inherited GetHeight
  else
    Result := Round(FDefaultHeightFactor * AParent.Height);
end;

{ TdxChartVisualElementAppearance }

constructor TdxChartVisualElementAppearance.Create(AOwner: TPersistent);
var
  AParent: TdxChartVisualElementAppearance;
  AOwnerElement: IdxChartVisualElement;
  AParentElement: IdxChartVisualElement;
begin
  Supports(AOwner, IdxChartVisualElement, AOwnerElement);
  AParentElement := AOwnerElement.GetParentElement;
  if AParentElement = nil then
    AParent := nil
  else
    AParent := AParentElement.GetAppearance;
  Create(AOwner, AParent);
end;

constructor TdxChartVisualElementAppearance.Create(AOwner: TPersistent; AParent: TdxChartVisualElementAppearance);
var
  I: Integer;
begin
  inherited Create(AOwner);
  FListeners := TList.Create;
  FOwnerElement := GetOwnerElement;
  Parent := AParent;
  RecreateSubClasses;
  FBorder := TdxDefaultBoolean.bDefault;
  FBorderThickness := DefaultBorderThickness;
  FPadding := TcxMargin.Create(Self, DefaultPadding);
  FPadding.OnChange := ChangeHandlerOffsets;
  FMargins := TcxMargin.Create(Self, DefaultMargins);
  FMargins.OnChange := ChangeHandlerOffsets;
  FParentBackground := DefaultParentBackground;
  SetLength(FColors, GetColorCount);
  SetLength(FActualColors, GetColorCount);
  for I := 0 to GetColorCount - 1 do
    FColors[I] := TdxAlphaColors.Default;
  IsActualColorsValid:= False;
  Changes := TotalChanges;
end;

destructor TdxChartVisualElementAppearance.Destroy;
begin
  ForEachListener( 
    procedure(AListener: TdxChartVisualElementAppearance)
    begin
      AListener.Parent := nil;
    end);
  Parent := nil;
  FreeAndNil(FFontOptions);
  FreeAndNil(FFillOptions);
  FreeAndNil(FStrokeOptions);
  FreeAndNil(FPadding);
  FreeAndNil(FMargins);
  FreeAndNil(FListeners);
  inherited Destroy;
end;

function TdxChartVisualElementAppearance.GetChart: TdxChart;
begin
  if FChartReference = nil then
    UpdateReferences;
  Result := FChartReference;
end;

function TdxChartVisualElementAppearance.GetOwnerElement: IdxChartVisualElement;
begin
  if not Supports(Owner, IdxChartVisualElement, Result) then
    Result := nil;
end;

function TdxChartVisualElementAppearance.GetLookAndFeelPainter: TcxCustomLookAndFeelPainter;
begin
  if Chart <> nil then
    Result := Chart.LookAndFeelPainter
  else
    Result := nil;
end;

function TdxChartVisualElementAppearance.GetUseRightToLeftAlignment: Boolean;
begin
  if Chart <> nil then
    Result := Chart.UseRightToLeftAlignment
  else
    Result := False;
end;

function TdxChartVisualElementAppearance.GetUseRightToLeftReading: Boolean;
begin
  if Chart <> nil then
    Result := Chart.UseRightToLeftReading
  else
    Result := False;
end;

procedure TdxChartVisualElementAppearance.AddListener(AListener: TdxChartVisualElementAppearance);
begin
  FListeners.Add(AListener);
end;

procedure TdxChartVisualElementAppearance.Changed(AChanges: TAppearanceChanges);
begin
  Changes := Changes + AChanges;
  inherited Changed;
end;

procedure TdxChartVisualElementAppearance.Changed(AChange: TAppearanceChange);
begin
  Changed([AChange]);
end;

procedure TdxChartVisualElementAppearance.ChangeScale(M, D: Integer);
begin
  BeginUpdate;
  try
    ChangeScaleCore(M, D);
  finally
    EndUpdate;
  end;
end;

procedure TdxChartVisualElementAppearance.ChangeScaleCore(M, D: Integer);
begin
  if HasFontOptions then
    FontOptions.ChangeScale(M, D);
  if HasStrokeOptions then
    StrokeOptions.ChangeScale(M, D);
  Padding.ChangeScale(M, D);
  Margins.ChangeScale(M, D);
  ForEachListener(
    procedure (AChild: TdxChartVisualElementAppearance)
    begin
      AChild.ChangeScale(M, D);
    end);
end;

function TdxChartVisualElementAppearance.CloneAsColorized(AIndex: Integer): TdxChartColorizedAppearance;
begin
  Result := TdxChartColorizedAppearance.Create(Self, AIndex);
end;

function TdxChartVisualElementAppearance.CreateFillOptions: TdxFillOptions;
begin
  if HasFillOptions then
  begin
    Result := TdxFillOptions.Create(Self, GetDefaultColor, GetDefaultColor);
    Result.OnChange := ChangeHandlerFillOptions;
  end
  else
    Result := nil;
end;

function TdxChartVisualElementAppearance.CreateFontOptions: TdxFontOptions;
var
  AIntf: IdxDefaultFontScaleFactorProvider;
begin
  if HasFontOptions then
  begin
    if Self is TdxChartAppearance then
      Result := TdxChartFontOptions.Create(TdxChartAppearance(Self))
    else if Supports(Owner, IdxDefaultFontScaleFactorProvider, AIntf) then
      Result := TdxChartVisualElementFontOptionsWithOverridenSize.Create(Self, AIntf.GetScaleFactor)
    else
      Result := TdxChartVisualElementFontOptions.Create(Self);
    Result.OnChange := ChangeHandlerFontOptions;
  end
  else
    Result := nil;
end;

function TdxChartVisualElementAppearance.CreateSolidPen(
  ACanvas: TcxCustomCanvas; AColor: TdxAlphaColor; const AThickness: Single): TcxCanvasBasedPen;
var
  AStrokeOptions: TdxStrokeOptions;
begin
  AStrokeOptions := TdxStrokeOptions.Create(nil);
  try
    AStrokeOptions.Style := TdxStrokeStyle.Solid;
    AStrokeOptions.Color := AColor;
    AStrokeOptions.Width := AThickness;
    Result := ACanvas.CreatePeN(AStrokeOptions);
  finally
    AStrokeOptions.Free;
  end;
end;

function TdxChartVisualElementAppearance.CreateStrokeOptions: TdxStrokeOptions;
begin
  if HasStrokeOptions then
  begin
    Result := TdxStrokeOptions.Create(Self, DefaultPenColor);
    Result.OnChange := ChangeHandlerStrokeOptions;
  end
  else
    Result := nil;
end;

function TdxChartVisualElementAppearance.DefaultBorder: Boolean;
begin
  Result := False;
end;

function TdxChartVisualElementAppearance.DefaultBorderThickness: Single;
begin
  Result := 1;
end;

function TdxChartVisualElementAppearance.DefaultPadding: Integer;
begin
  Result := TdxChart.DefaultPadding;
end;

function TdxChartVisualElementAppearance.DefaultMargins: Integer;
begin
  Result := TdxChart.DefaultMargins;
end;

function TdxChartVisualElementAppearance.DefaultParentBackground: Boolean;
begin
  Result := True;
end;

function TdxChartVisualElementAppearance.DefaultPenColor: TdxAlphaColor;
begin
  Result := GetActualColor(PenColorIndex);
end;

procedure TdxChartVisualElementAppearance.AssignColors(ASource: TdxChartVisualElementAppearance);
const
  ColorChanges = [TAppearanceChange.Color, TAppearanceChange.Fill, TAppearanceChange.Stroke, TAppearanceChange.TextColor];
var
  ALength: Integer;
begin
  ALength := Min(GetColorCount, ASource.GetColorCount) * SizeOf(TdxAlphaColor);
  if not CompareMem(@ASource.FColors[0], @FColors[0], ALength) then
  begin
    Move(ASource.FColors[0], FColors[0], ALength);
    IsActualColorsValid := False;
    Changed(ColorChanges);
  end;
end;

procedure TdxChartVisualElementAppearance.DoAssign(Source: TPersistent);
var
  ASource: TdxChartVisualElementAppearance;
begin
  inherited DoAssign(Source);
  if Source is TdxChartVisualElementAppearance then
  begin
    ASource := TdxChartVisualElementAppearance(Source);
    Border := ASource.Border;
    BorderThickness := ASource.BorderThickness;
    FontOptions := ASource.FontOptions;
    AssignColors(ASource);
    FillOptions := ASource.FillOptions;
    StrokeOptions := ASource.StrokeOptions;
    Padding := ASource.Padding;
    Margins := ASource.Margins;
    ParentBackground := ASource.ParentBackground;
  end;
end;

procedure TdxChartVisualElementAppearance.DoChanged;
begin
  if Changes = [] then
    Exit;

  if TAppearanceChange.Resources in Changes then
    DoFlushCache;

  NotifyListeners(Changes);

  if OwnerElement <> nil then
  begin
    if Changes * SizeChanges <> [] then
      OwnerElement.LayoutChanged
    else if TAppearanceChange.TextColor in Changes then
      OwnerElement.TextColorChanged
    else
      OwnerElement.StyleChanged;
  end;
end;

procedure TdxChartVisualElementAppearance.DoFlushCache;
begin
  if HasFillOptions then
    FillOptions.FlushCache;
  if HasFontOptions then
    FontOptions.FlushCache;
  if HasStrokeOptions then
    StrokeOptions.FlushCache;
end;

function TdxChartVisualElementAppearance.GetActualColor(AIndex: Integer): TdxAlphaColor;
begin
  case AIndex of
    PenColorIndex, BorderColorIndex:
      Result := ColorScheme.Chart.BorderColor;
    ColorIndex:
      Result := ColorScheme.Chart.BackgroundColor;
    Color2Index:
      Result := ColorScheme.Chart.BackgroundColor;
    TextColorIndex:
      Result := ColorScheme.Chart.TitleColor;
  else
    raise EdxChartException.CreateFmt('GetActualColor: %d - Invalid color index', [AIndex]);
  end;
end;

function TdxChartVisualElementAppearance.GetActualColorValue(AIndex: Integer): TdxAlphaColor;
begin
  if not IsActualColorsValid then
    UpdateActualColors;
  Result := FActualColors[AIndex];
end;

function TdxChartVisualElementAppearance.GetActualPadding: TRect;
begin
  Result := Padding.Margin;
end;

function TdxChartVisualElementAppearance.GetActualMargins: TRect;
begin
  Result := Margins.Margin;
end;

function TdxChartVisualElementAppearance.GetActualBorder: Boolean;
begin
  Result := (Border = bTrue) or ((Border = bDefault) and DefaultBorder);
end;

function TdxChartVisualElementAppearance.GetColorCount: Integer;
begin
  Result := TextColorIndex + 1;
end;

function TdxChartVisualElementAppearance.GetColorValue(AIndex: Integer): TdxAlphaColor;
begin
  Result := FColors[AIndex];
  if (AIndex = ColorIndex) and HasFillOptions then
    Result := FillOptions.Color
  else
    if (AIndex = PenColorIndex) and HasStrokeOptions then
        Result := StrokeOptions.Color;
end;

function TdxChartVisualElementAppearance.HasBorder: Boolean;
begin
  Result := not TdxAlphaColors.IsTransparentOrEmpty(ActualBorderColor);
end;

function TdxChartVisualElementAppearance.HasFillOptions: Boolean;
begin
  Result := False;
end;

function TdxChartVisualElementAppearance.HasFontOptions: Boolean;
begin
  Result := False;
end;

function TdxChartVisualElementAppearance.HasStrokeOptions: Boolean;
begin
  Result := False;
end;

procedure TdxChartVisualElementAppearance.Notification(AParentChanges: TAppearanceChanges);
begin
  Changed(AParentChanges);
end;

procedure TdxChartVisualElementAppearance.NotifyListeners(AChanges: TAppearanceChanges);
begin
  ForEachListener(
    procedure(AListener: TdxChartVisualElementAppearance)
    begin
      AListener.Notification(AChanges);
    end)
end;

procedure TdxChartVisualElementAppearance.RemoveListener(AListener: TdxChartVisualElementAppearance);
begin
  FListeners.Remove(AListener);
end;

procedure TdxChartVisualElementAppearance.RecreateSubClasses;
begin
  FreeAndNil(FFillOptions);
  FreeAndNil(FFontOptions);
  FreeAndNil(FStrokeOptions);
  FFillOptions := CreateFillOptions;
  FFontOptions := CreateFontOptions;
  FStrokeOptions := CreateStrokeOptions;
end;

procedure TdxChartVisualElementAppearance.ForEachListener(AProc: TdxChartVisualElementAppearance.TForEachProc);
var
  I: Integer;
begin
  for I := FListeners.Count - 1 downto 0 do
    AProc(TdxChartVisualElementAppearance(FListeners[I]));
end;

procedure TdxChartVisualElementAppearance.SetActualColor(AIndex: Integer; AValue: TdxAlphaColor);
begin
  FActualColors[AIndex] := AValue;
end;

procedure TdxChartVisualElementAppearance.SetColorValue(AIndex: Integer; AValue: TdxAlphaColor);
begin
  if AValue <> GetColorValue(AIndex) then
  begin
    IsActualColorsValid := False;
    if AIndex = ColorIndex then
      FillOptions.Color := AValue
    else
      if AIndex = PenColorIndex then
        StrokeOptions.Color := AValue
      else
        if AIndex = TextColorIndex then
        begin
          FColors[AIndex] := AValue;
          Changed(TAppearanceChange.TextColor);
        end
        else
        begin
           FColors[AIndex] := AValue;
           Changed(TAppearanceChange.Color);
        end;
  end;
end;

procedure TdxChartVisualElementAppearance.SetParent(AParent: TdxChartVisualElementAppearance);
begin
  if FParent <> AParent then
  begin
    if Parent <> nil then
      Parent.RemoveListener(Self);
    FParent := AParent;
    if Parent <> nil then
      Parent.AddListener(Self);
    Changes := TotalChanges;
  end;
  UpdateReferences;
end;

procedure TdxChartVisualElementAppearance.UpdateActualValues(ACanvas: TcxCustomCanvas);
begin
  if Changes = [] then
    Exit;
  UpdateActualColors;
  UpdateActualPadding;
  UpdateActualBrush(ACanvas);
  UpdateActualFont(ACanvas);
  UpdateActualPen(ACanvas);
  //
  if not HasBorder then
    FActualBorderThickness := 0
  else
    FActualBorderThickness := BorderThickness;
  Changes := [];
end;

procedure TdxChartVisualElementAppearance.UpdateMetrics(ACanvas: TcxCustomCanvas);
begin
  if Changes = TotalChanges then
    UpdateReferences;
  UpdateActualValues(ACanvas);
  ForEachListener(
    procedure(AListener: TdxChartVisualElementAppearance)
    begin
      AListener.UpdateMetrics(ACanvas);
    end);
end;

procedure TdxChartVisualElementAppearance.ChangeHandlerFillOptions(Sender: TObject);
begin
  ParentBackground := False;
  Changed(TAppearanceChange.Fill);
end;

procedure TdxChartVisualElementAppearance.ChangeHandlerFontOptions(Sender: TObject);
begin
  Changed(TAppearanceChange.Font);
end;

procedure TdxChartVisualElementAppearance.ChangeHandlerOffsets(Sender: TObject);
begin
  Changed(TAppearanceChange.Size);
end;

procedure TdxChartVisualElementAppearance.ChangeHandlerStrokeOptions(Sender: TObject);
begin
  Changed(TAppearanceChange.Stroke);
end;

function TdxChartVisualElementAppearance.GetColorScheme: TdxChartColorScheme;
begin
  if Chart <> nil then
    Result := Chart.ColorScheme
  else
    Result := TdxChartColorSchemeRepository.Default;
end;

function TdxChartVisualElementAppearance.GetDefaultColor: TdxAlphaColor;
begin
  Result := GetActualColor(ColorIndex);
end;

function TdxChartVisualElementAppearance.GetScaleFactor: TdxScaleFactor;
begin
  if Chart <> nil then
    Result := Chart.ScaleFactor
  else
    Result := nil;
end;

procedure TdxChartVisualElementAppearance.SetBorder(AValue: TdxDefaultBoolean);
begin
  if AValue <> Border then
  begin
    FBorder := AValue;
    Changed(TAppearanceChange.Size);
  end;
end;

procedure TdxChartVisualElementAppearance.SetBorderThickness(AValue: Single);
begin
  AValue := Max(0, AValue);
  if AValue <> BorderThickness then
  begin
    FBorderThickness := AValue;
    Changed(TAppearanceChange.Size);
  end;
end;

procedure TdxChartVisualElementAppearance.SetFillOptions(AValue: TdxFillOptions);
begin
  if HasFillOptions then
    FillOptions.Assign(AValue);
end;

procedure TdxChartVisualElementAppearance.SetFontOptions(AValue: TdxFontOptions);
begin
  if HasFontOptions then
    FontOptions.Assign(AValue);
end;

procedure TdxChartVisualElementAppearance.SetPadding(AValue: TcxMargin);
begin
  Padding.Assign(AValue);
end;

procedure TdxChartVisualElementAppearance.SetMargins(AValue: TcxMargin);
begin
  Margins.Assign(AValue);
end;

procedure TdxChartVisualElementAppearance.SetParentBackground(AValue: Boolean);
begin
  if AValue <> FParentBackground then
  begin
    FParentBackground := AValue;
    Changed(TAppearanceChange.Fill);
  end;
end;

procedure TdxChartVisualElementAppearance.SetStrokeOptions(AValue: TdxStrokeOptions);
begin
  if HasStrokeOptions then
    StrokeOptions.Assign(AValue);
end;

function TdxChartVisualElementAppearance.IsBorderThicknessStored: Boolean;
begin
  Result := not SameValue(BorderThickness, DefaultBorderThickness);
end;

function TdxChartVisualElementAppearance.IsParentBackgroundStored: Boolean;
begin
  Result := ParentBackground <> DefaultParentBackground;
end;

procedure TdxChartVisualElementAppearance.UpdateActualColors;
var
  I: Integer;
begin
  for I := 0 to GetColorCount - 1 do
  begin
    FActualColors[I] := GetColorValue(I);
    if FActualColors[I] = TdxAlphaColors.Default then
      FActualColors[I] := GetActualColor(I);
  end;
  if not GetActualBorder and (BorderColorIndex < GetColorCount) then
    FActualColors[BorderColorIndex] := TdxAlphaColors.Empty;
  IsActualColorsValid := True;
end;

procedure TdxChartVisualElementAppearance.UpdateActualBrush(ACanvas: TcxCustomCanvas);
begin
  if not (TAppearanceChange.Fill in Changes) then
    Exit;
  if not HasFillOptions and not ParentBackground then
  begin
    FActualColors[ColorIndex] := TdxAlphaColors.Empty;
    FActualColors[Color2Index] := TdxAlphaColors.Empty;
  end
  else
    if ParentBackground and (Parent <> nil) then
    begin
      FActualColors[ColorIndex] := Parent.ActualColor;
      FActualBrush := Parent.ActualBrush;
    end
    else
      if HasFillOptions then
        FActualBrush := FillOptions.GetHandle(ACanvas)
end;

procedure TdxChartVisualElementAppearance.UpdateActualFont(ACanvas: TcxCustomCanvas);
begin
  if not (TAppearanceChange.Font in Changes) then
    Exit;
  if HasFontOptions then
  begin
    FontOptions.FlushCache;
    FActualFont := FontOptions.GetHandle(ACanvas);
  end;
end;

procedure TdxChartVisualElementAppearance.UpdateActualPadding;
begin
  if Padding.All = DefaultPadding then
    FActualPadding := GetActualPadding
  else
    FActualPadding := Padding.Margin;
  if Margins.All = DefaultMargins then
    FActualMargins := GetActualMargins
  else
    FActualMargins := Margins.Margin;
end;

procedure TdxChartVisualElementAppearance.UpdateActualPen(ACanvas: TcxCustomCanvas);
begin
  if not (TAppearanceChange.Stroke in Changes) then
    Exit;
  if not HasStrokeOptions then
    FActualPen := nil
  else
    FActualPen := StrokeOptions.GetHandle(ACanvas);
end;

procedure TdxChartVisualElementAppearance.UpdateReferences;
var
  AElement: IdxChartVisualElement;
begin
  FChartReference := nil;
  AElement := OwnerElement;
  if AElement <> nil then
    FChartReference := AElement.GetChart;
end;

{ TdxChartColorizedAppearance }

constructor TdxChartColorizedAppearance.Create(AParent: TdxChartVisualElementAppearance; AIndex: Integer);
begin
  BeginUpdate;
  try
    FIndex := AIndex;
    inherited Create(nil, AParent);
    ParentBackground := False;
  finally
    EndUpdate;
  end;
end;

function TdxChartColorizedAppearance.GetActualColorProperty(AIndex: Integer): TdxAlphaColor;
begin
  if TAppearanceChange.Color in Changes then
  begin
    UpdateColorizedColors;
    Exclude(Changes, TAppearanceChange.Color);
  end;
  Result := GetActualColor(AIndex);
end;

procedure TdxChartColorizedAppearance.Validate(ACanvas: TcxCustomCanvas);
begin
  if Changes = [] then
    Exit;
  UpdateActualValues(ACanvas);
end;

procedure TdxChartColorizedAppearance.ApplyColors(AColor, AColor2: TdxAlphaColor);
begin
  if HasFillOptions then
  begin
    FillOptions.Color := AColor;
    FillOptions.Color2 := AColor;
    SetColorValue(ColorIndex, AColor);
    Changed(TAppearanceChange.Fill);
  end;
  if HasStrokeOptions then
  begin
    StrokeOptions.Color := AColor;
    Changed(TAppearanceChange.Stroke);
  end;
end;

function TdxChartColorizedAppearance.DefaultBorder: Boolean;
begin
  Result := Parent.DefaultBorder;
end;

function TdxChartColorizedAppearance.DefaultBorderThickness: Single;
begin
  Result := Parent.DefaultBorderThickness;
end;

procedure TdxChartColorizedAppearance.DoAssign(ASource: TPersistent);
begin
  FActualColor := TdxAlphaColors.Default;
  FActualColor2 := TdxAlphaColors.Default;
  inherited DoAssign(ASource);
  if HasFontOptions then
    TdxChartVisualElementFontOptions(FontOptions).AssignedValues := [];
  ParentBackground := False;
end;

procedure TdxChartColorizedAppearance.DoChanged;
begin
  Changes := Changes + Parent.Changes;
end;

function TdxChartColorizedAppearance.GetActualColor(AIndex: Integer): TdxAlphaColor;
begin
  if (AIndex = ColorIndex) or (AIndex = PenColorIndex) then
    Result := FActualColor
  else
    if AIndex = Color2Index then
      Result := FActualColor2
    else
      Result := Parent.GetActualColor(AIndex);
end;

function TdxChartColorizedAppearance.GetActualPadding: TRect;
begin
  Result := Parent.GetActualPadding;
end;

function TdxChartColorizedAppearance.GetActualMargins: TRect;
begin
  Result := Parent.GetActualMargins;
end;

function TdxChartColorizedAppearance.HasFillOptions: Boolean;
begin
  Result := Parent.HasFillOptions;
end;

function TdxChartColorizedAppearance.HasFontOptions: Boolean;
begin
  Result := Parent.HasFontOptions;
end;

function TdxChartColorizedAppearance.HasStrokeOptions: Boolean;
begin
  Result := Parent.HasStrokeOptions;
end;

procedure TdxChartColorizedAppearance.ParentChanged;
begin
  Changes := Changes + Parent.Changes;
end;

procedure TdxChartColorizedAppearance.Notification(AParentChanges: TdxChartVisualElementAppearance.TAppearanceChanges);
begin
  Changed(AParentChanges);
end;

procedure TdxChartColorizedAppearance.SetParent(AParent: TdxChartVisualElementAppearance);
begin
  FParent := AParent;
end;

procedure TdxChartColorizedAppearance.UpdateActualValues(ACanvas: TcxCustomCanvas);
begin
  Changes := Changes + Parent.Changes;
  if Changes = [] then
    Exit;
  BeginUpdate;
  try
    Assign(Parent);
    UpdateColorizedColors;
  finally
    EndUpdate;
  end;
  inherited UpdateActualValues(ACanvas);
end;

procedure TdxChartColorizedAppearance.UpdateColorizedColors;
var
  AColor, AColor2: TdxAlphaColor;
begin
  FPaletteEntry := Parent.ColorScheme.SeriesColors.GetByElementIndex(Index);
  AColor := cxGetActualAlphaColor(Parent.GetColorValue(ColorIndex), PaletteEntry.Color);
  AColor2 := cxGetActualAlphaColor(Parent.GetColorValue(Color2Index), PaletteEntry.Color2);
  if (AColor <> FActualColor) or (AColor2 <> FActualColor2) then
    ApplyColors(FActualColor, FActualColor2);
  FActualColor := AColor;
  FActualColor2 := AColor;
end;

procedure TdxChartColorizedAppearance.SetIndex(AValue: Integer);
begin
  if AValue <> FIndex then
  begin
    FIndex := AValue;
    Changed(TotalChanges);
  end;
end;

{ TdxChartCustomLegend }

constructor TdxChartCustomLegend.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FViewData := CreateViewData;
  FTitle := CreateTitle;
  FImagesChangeLink := TChangeLink.Create;
  FImagesChangeLink.OnChange := ImagesChanged;
  FImagesNotifyComponent := TcxFreeNotificator.Create(nil);
  FImagesNotifyComponent.OnFreeNotification := ImagesFreeNotification;
  FMaxCaptionWidth := DefaultMaxCaptionWidth;
  FMaxHeightPercent := DefaultMaxSizePercent;
  FMaxWidthPercent := DefaultMaxSizePercent;
  FDirection := TdxChartLegendDirection.TopToBottom;
  FShowCaptions := True;
  FShowCheckBoxes := True;
  FShowImages := True;
end;

destructor TdxChartCustomLegend.Destroy;
begin
  FImagesChangeLink.OnChange := nil;
  FImagesNotifyComponent.OnFreeNotification := nil;
  FreeAndNil(FImagesChangeLink);
  FreeAndNil(FImagesNotifyComponent);
  FreeAndNil(FTitle);
  FreeAndNil(FViewData);
  inherited Destroy;
end;

function TdxChartCustomLegend.ActualAlignment(AAlignment, ADefaultAlignment: TdxChartLegendAlignment): TdxChartLegendAlignment;
begin
  Result := AAlignment;
  if Result = TdxChartLegendAlignment.Default then
    Result := ADefaultAlignment;
end;

function TdxChartCustomLegend.ActuallyVisible: Boolean;
begin
  Result := (GetChart <> nil) and Visible and
    (((Title <> nil) and Title.ActuallyVisible) or not ViewData.IsEmpty or ViewData.Dirty);
end;

procedure TdxChartCustomLegend.AddItem(const AItem: IdxChartLegendItem);
begin
  ViewData.AddItem(AItem);
end;

procedure TdxChartCustomLegend.CalculateAndAdjustContent(ACanvas: TcxCustomCanvas; var ABounds: TdxRectF);
var
  R, R1: TdxRectF;
  AOrientation: TdxOrientation;
  AAlignHorz, AAlignVert: TdxChartLegendAlignment;
const
  AOutsideCorrection: array[Boolean] of TdxChartLegendAlignment = (TdxChartLegendAlignment.Near, TdxChartLegendAlignment.Far);
  AHorzTruncSide: array[Boolean] of TcxBorder = (bLeft, bRight);
  AVertTruncSide: array[Boolean] of TcxBorder = (bBottom, bTop);
begin
  if not ActuallyVisible then
  begin
    ViewInfo.Visible := False;
    Exit;
  end;
  ViewData.Calculate;
  AOrientation := orHorizontal;
  AAlignHorz := ActualAlignment(AlignmentHorz, GetDefaultAlignmentHorz);
  AAlignVert := ActualAlignment(AlignmentVert, GetDefaultAlignmentVert);
  if Direction in [TdxChartLegendDirection.TopToBottom, TdxChartLegendDirection.BottomToTop] then
    AOrientation := orVertical;
  //
  if (AAlignHorz in LegendOutsideAlignments) and (AAlignVert in LegendOutsideAlignments) then
  begin
    if AOrientation = orHorizontal then
      AAlignHorz := AOutsideCorrection[AAlignHorz = TdxChartLegendAlignment.FarOutside]
    else
      AAlignVert := AOutsideCorrection[AAlignVert = TdxChartLegendAlignment.FarOutside];
  end;
  //
  R1 := ABounds.Content(Appearance.ActualMargins);
  R := TdxRectF.Create(0, 0, R1.Width * MaxWidthPercent / 100, R1.Height * MaxHeightPercent / 100);
  if AOrientation = orHorizontal then
    R := R1.AlignVertically(R.Size, AlignVertToAlign[AAlignVert])
  else
    R := R1.AlignHorizontally(R.Size, AlignHorzToAlign[AAlignHorz]);
  ViewInfo.SetBounds(R, R1);
  ViewInfo.Calculate(ACanvas);
  R := R1.AlignHorizontally(ViewInfo.Bounds, AlignHorzToAlign[AAlignHorz]);
  R := R1.AlignVertically(R, AlignVertToAlign[AAlignVert]);
  ViewInfo.UpdateBounds(R);
  //
  if AAlignHorz in LegendOutsideAlignments then
    ABounds.TruncBorder(R, [AHorzTruncSide[AAlignHorz = TdxChartLegendAlignment.FarOutside]], Appearance.ActualMargins);
  if AAlignVert in LegendOutsideAlignments then
    ABounds.TruncBorder(R, [AVertTruncSide[AAlignVert = TdxChartLegendAlignment.FarOutside]], Appearance.ActualMargins);
end;

procedure TdxChartCustomLegend.ChangeScale(M, D: Integer);
begin
  inherited ChangeScale(M, D);
  FMaxCaptionWidth := FMaxCaptionWidth * M / D;
end;

procedure TdxChartCustomLegend.Clear;
begin
  ViewData.Clear;
  ViewInfo.Dirty := True;
end;

function TdxChartCustomLegend.CreateAppearance: TdxChartVisualElementAppearance;
begin
  Result := TdxChartLegendAppearance.Create(Self);
end;

function TdxChartCustomLegend.CreateTitle: TdxChartLegendTitle;
begin
  Result := TdxChartLegendTitle.Create(Self);
end;

function TdxChartCustomLegend.CreateViewData: TdxChartLegendCustomViewData;
begin
  Result := TdxChartLegendViewData.Create(Self);
end;

function TdxChartCustomLegend.CreateViewInfo: TdxChartVisualElementCustomViewInfo;
begin
  Result := TdxChartLegendViewInfo.Create(Self);
end;

procedure TdxChartCustomLegend.DataChanged(ANotifyOwner: Boolean = False);
begin
  Clear;
  if ANotifyOwner and ActuallyVisible then
    LayoutChanged;
end;

procedure TdxChartCustomLegend.DoAssign(Source: TPersistent);
var
  ASource: TdxChartCustomLegend;
begin
  inherited DoAssign(Source);
  if Source is TdxChartCustomLegend then
  begin
    ASource := TdxChartCustomLegend(Source);
    Appearance := ASource.Appearance;
    FAlignmentHorz := ASource.AlignmentHorz;
    FAlignmentVert := ASource.AlignmentVert;
    FDirection := ASource.Direction;
    Images := ASource.Images;
    FMaxCaptionWidth := ASource.MaxCaptionWidth;
    FMaxHeightPercent := ASource.MaxHeightPercent;
    FMaxWidthPercent := ASource.MaxWidthPercent;
    FShowCaptions := ASource.ShowCaptions;
    FShowCheckBoxes := ASource.ShowCheckBoxes;
    FShowImages := ASource.ShowImages;
    Title := ASource.Title;
  end;
end;

function TdxChartCustomLegend.GetDefaultAlignmentHorz: TdxChartLegendAlignment;
begin
  Result := TdxChartLegendAlignment.FarOutside;
end;

function TdxChartCustomLegend.GetDefaultAlignmentVert: TdxChartLegendAlignment;
begin
  Result := TdxChartLegendAlignment.Far;
end;

procedure TdxChartCustomLegend.ImagesChanged(Sender: TObject);
begin
  LayoutChanged;
end;

procedure TdxChartCustomLegend.ImagesFreeNotification(AComponent: TComponent);
begin
  Images := nil;
end;

procedure TdxChartCustomLegend.Invalidate;
begin
  if not ViewData.Dirty then
    inherited Invalidate
  else
    GetParentElement.StyleChanged;
end;

function TdxChartCustomLegend.IsOutside: Boolean;
begin
  Result := LegendOutsideAlignments * [ActualAlignment(AlignmentHorz, GetDefaultAlignmentHorz)] +
    [ActualAlignment(AlignmentVert, GetDefaultAlignmentVert)] <> [];
end;

function TdxChartCustomLegend.IsMaxCaptionWidthStored: Boolean;
begin
  Result := not SameValue(FMaxCaptionWidth, DefaultMaxCaptionWidth);
end;

function TdxChartCustomLegend.IsMaxHeightPercentStored: Boolean;
begin
  Result := not SameValue(FMaxHeightPercent, DefaultMaxSizePercent);
end;

function TdxChartCustomLegend.IsMaxWidthPercentStored: Boolean;
begin
  Result := not SameValue(FMaxWidthPercent, DefaultMaxSizePercent);
end;

function TdxChartCustomLegend.GetAppearance: TdxChartLegendAppearance;
begin
  Result := TdxChartLegendAppearance(inherited Appearance);
end;

procedure TdxChartCustomLegend.SetAlignmentHorz(AValue: TdxChartLegendAlignment);
begin
  if AValue <> FAlignmentHorz then
  begin
    FAlignmentHorz := AValue;
    LayoutChanged;
  end;
end;

procedure TdxChartCustomLegend.SetAlignmentVert(AValue: TdxChartLegendAlignment);
begin
  if AValue <> FAlignmentVert then
  begin
    FAlignmentVert := AValue;
    LayoutChanged;
  end;
end;

procedure TdxChartCustomLegend.SetAppearance(AValue: TdxChartLegendAppearance);
begin
  Appearance.Assign(AValue);
end;

procedure TdxChartCustomLegend.SetImages(AValue: TCustomImageList);
begin
  if AValue <> FImages then
  begin
    cxSetImageList(AValue, FImages, FImagesChangeLink, FImagesNotifyComponent);
    LayoutChanged;
  end;
end;

procedure TdxChartCustomLegend.SetMaxCaptionWidth(AValue: Single);
begin
  AValue := Max(0, AValue);
  if FMaxCaptionWidth <> AValue then
  begin
    FMaxCaptionWidth := AValue;
    LayoutChanged;
  end;
end;

procedure TdxChartCustomLegend.SetMaxHeightPercent(AValue: Single);
begin
  AValue := Min(Max(0, AValue), 100);
  if not SameValue(FMaxHeightPercent, AValue) then
  begin
    FMaxHeightPercent := AValue;
    LayoutChanged;
  end;
end;

procedure TdxChartCustomLegend.SetMaxWidthPercent(AValue: Single);
begin
  AValue := Min(Max(0, AValue), 100);
  if not SameValue(FMaxWidthPercent, AValue) then
  begin
    FMaxWidthPercent := AValue;
    LayoutChanged;
  end;
end;

procedure TdxChartCustomLegend.SetShowCaptions(AValue: Boolean);
begin
  if FShowCaptions <> AValue then
  begin
    FShowCaptions := AValue;
    LayoutChanged;
  end;
end;

procedure TdxChartCustomLegend.SetShowCheckBoxes(AValue: Boolean);
begin
  if FShowCheckBoxes <> AValue then
  begin
    FShowCheckBoxes := AValue;
    LayoutChanged;
  end;
end;

procedure TdxChartCustomLegend.SetShowImages(AValue: Boolean);
begin
  if FShowImages <> AValue then
  begin
    FShowImages := AValue;
    LayoutChanged;
  end;
end;

procedure TdxChartCustomLegend.SetTitle(AValue: TdxChartLegendTitle);
begin
  Title.Assign(AValue);
end;

{ TdxChartLegend }

function TdxChartLegend.GetChart: TdxChart;
begin
  Result := TdxChart(Owner);
end;

function TdxChartLegend.GetOwner: TPersistent;
begin
  Result := GetChart;
  if TdxChart(Result).Owner <> nil then
    Result := TdxChart(Result).Owner;
end;

{ TdxChartDiagramLegend }

function TdxChartDiagramLegend.ActuallyVisible: Boolean;
begin
  Result := Diagram.ActuallyVisible and inherited ActuallyVisible;
end;

function TdxChartDiagramLegend.GetChart: TdxChart;
begin
  Result := Diagram.Chart;
end;

function TdxChartDiagramLegend.GetDefaultAlignmentHorz: TdxChartLegendAlignment;
begin
  Result := TdxChartLegendAlignment.Far;
end;

function TdxChartDiagramLegend.GetDiagram: TdxChartCustomDiagram;
begin
  Result := TdxChartCustomDiagram(GetOwner);
end;

{ TdxChartVisualElementTitleViewInfo }

constructor TdxChartVisualElementTitleViewInfo.Create(AOwner: TdxChartVisualElementTitle);
begin
  inherited Create(AOwner.Appearance);
  FTitle := AOwner;
end;

destructor TdxChartVisualElementTitleViewInfo.Destroy;
begin
  FreeAndNil(FTextLayout);
  inherited Destroy;
end;

procedure TdxChartVisualElementTitleViewInfo.UpdateBounds(const ABounds: TdxRectF);
const
  AlignTodxAlign: array[TdxAlignment] of TdxAlignment = (TdxAlignment.Center,
    TdxAlignment.Near, TdxAlignment.Center, TdxAlignment.Far);
var
  ABorderThickness: Integer;
  APadding: TRect;
begin
  inherited UpdateBounds(ABounds);
  if FTextLayout <> nil then
  begin
    FBounds := ABounds;
    FTextLayout.SetLayoutConstraints(ContentBounds, Title.MaxLineCount);
    ABorderThickness := Trunc(BorderThickness);
    APadding := cxMarginsCombine(Padding, cxRect(ABorderThickness, ABorderThickness, ABorderThickness, ABorderThickness));
    Bounds.AdjustByBorder(FTextLayout.MeasureSizeF, Title.PositionToSide[Title.ActualDockPosition], APadding);
    FContentBounds := Bounds.Content(APadding);
    FTextBounds := ContentBounds;
    if Title.PositionToSide[Title.ActualDockPosition] in [bTop, bBottom] then
    begin
      FTextBounds.Width := TextSize.Width;
      FTextBounds := ContentBounds.AlignHorizontally(FTextBounds, AlignTodxAlign[Title.Alignment])
    end
    else
    begin
      FTextBounds.Height := TextSize.Height;
      FTextBounds := ContentBounds.AlignVertically(FTextBounds, AlignTodxAlign[Title.Alignment]);
    end;
    FTextBounds.Intersect(ContentBounds);
  end;
end;

procedure TdxChartVisualElementTitleViewInfo.AdjustContent(var ABounds: TdxRectF);
begin
  ABounds.TruncBorder(Bounds, [Title.PositionToSide[Title.ActualDockPosition]], Title.Appearance.ActualMargins);
end;

function TdxChartVisualElementTitleViewInfo.CalculateTextFlags: Cardinal;
begin
  Result := dxChartCalculateTextFlags(Title.Alignment,
    Title.PositionToSide[Title.ActualDockPosition] in [bTop, bBottom],
    Title.WordWrap, Appearance.UseRightToLeftReading);
end;

procedure TdxChartVisualElementTitleViewInfo.DoCalculate(ACanvas: TcxCustomCanvas);
const
  TextAngle: array[TdxChartTitlePosition] of TcxRotationAngle = (ra0, raMinus90, ra0, raPlus90, ra0);
  ExceedHorzTextAlignment: array[Boolean] of Cardinal = (CXTO_LEFT, CXTO_RIGHT);
  ExceedVertTextAlignment: array[Boolean, Boolean] of Cardinal = ((CXTO_BOTTOM, CXTO_TOP), (CXTO_TOP, CXTO_BOTTOM));
var
  ATextFlags: Cardinal;
begin
  if not ACanvas.CheckIsValid(FTextLayout) then
  begin
    FreeAndNil(FTextLayout);
    FTextLayout := ACanvas.CreateTextLayout;
  end;

  FTextLayout.SetText(Title.GetActualDisplayText);
  if FTextLayout.Text = '' then
    FTextLayout.SetText('Wg');
  FHasText := FTextLayout.Text <> '' ;
  FTextLayout.SetRotation(TextAngle[Title.ActualDockPosition]);
  FTextLayout.SetColor(TextColor);
  FTextLayout.SetFont(Font);
  ATextFlags := CalculateTextFlags;
  FTextLayout.SetFlags(ATextFlags);
  UpdateBounds(Bounds);
  if (TextSize.Width > Bounds.Width) and (ATextFlags and CXTO_CENTER_HORIZONTALLY = CXTO_CENTER_HORIZONTALLY) then
    FTextLayout.SetFlags(ATextFlags and not CXTO_CENTER_HORIZONTALLY or
      ExceedHorzTextAlignment[UseRightToLeftReading] or CXTO_END_ELLIPSIS);
  if (TextSize.Height > Bounds.Height) and (ATextFlags and CXTO_CENTER_VERTICALLY = CXTO_CENTER_VERTICALLY) then
    FTextLayout.SetFlags(ATextFlags and not CXTO_CENTER_VERTICALLY or
      ExceedVertTextAlignment[Title.PositionToSide[Title.ActualDockPosition] = bRight, UseRightToLeftReading] or CXTO_END_ELLIPSIS);
end;

procedure TdxChartVisualElementTitleViewInfo.DoDraw(ACanvas: TcxCustomCanvas);
begin
  inherited DoDraw(ACanvas);
  if (FTextLayout <> nil)and (FTextLayout.Text <> '') { and HasText} then
    FTextLayout.Draw(TextBounds);
end;

procedure TdxChartVisualElementTitleViewInfo.FreeCanvasBasedResources;
begin
  if FTextLayout <> nil then
    FreeAndNil(FTextLayout);
  inherited FreeCanvasBasedResources;
end;

function TdxChartVisualElementTitleViewInfo.GetHitElement(const P: TdxPointF): IdxChartHitTestElement;
const
  BackgroundSubAreaCode = 0;
  TextSubAreaCode = 1;
begin
  if Bounds.Contains(P) then
  begin
    Result := TdxChartComponentDependentHitElement.Create(Title, False, Title.GetOwnerComponent, Title.GetHitCode, IfThen(TextBounds.Contains(P), TextSubAreaCode, BackgroundSubAreaCode));
    if TextBounds.Contains(P) then
      Result := TdxChartHintableCaptionHitElement.Create(Result, TextBounds, TextLayout.Text, TextLayout.IsTruncated);
  end
  else
    Result := inherited GetHitElement(P);
end;

procedure TdxChartVisualElementTitleViewInfo.UpdateTextColors;
begin
  if FTextLayout <> nil then
    FTextLayout.SetColor(TextColor);
end;

function TdxChartVisualElementTitleViewInfo.GetTextSize: TdxSizeF;
begin
  if FTextLayout <> nil then
    Result := FTextLayout.MeasureSizeF
  else
    Result := TdxSizeF.Null;
end;

{ TdxChartVisualElementTitleAppearance }

function TdxChartVisualElementTitleAppearance.DefaultParentBackground: Boolean;
begin
  Result := False;
end;

function TdxChartVisualElementTitleAppearance.GetActualPadding: TRect;
begin
  Result := ColorScheme.PaneTitle.Margins.DeflateToTRect;
end;

function TdxChartVisualElementTitleAppearance.GetActualColor(AIndex: Integer): TdxAlphaColor;
begin
  if AIndex = TextColorIndex then
    Result := ColorScheme.Chart.TitleColor
  else
    if (AIndex = ColorIndex) or (AIndex = Color2Index) then
      Result := TdxAlphaColors.Transparent
    else
      Result := inherited GetActualColor(AIndex);
end;

function TdxChartVisualElementTitleAppearance.HasFillOptions: Boolean;
begin
  Result := True;
end;

function TdxChartVisualElementTitleAppearance.GetFontOptions: TdxChartVisualElementFontOptions;
begin
  Result := TdxChartVisualElementFontOptions(inherited FontOptions);
end;

procedure TdxChartVisualElementTitleAppearance.SetFontOptions(AValue: TdxChartVisualElementFontOptions);
begin
  inherited FontOptions := AValue;
end;

{ TdxChartTitleAppearance }

function TdxChartTitleAppearance.HasFontOptions: Boolean;
begin
  Result := True;
end;

{ TdxChartVisualElementTitle }

constructor TdxChartVisualElementTitle.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FWordWrap := GetDefaultWordWrap;
end;

procedure TdxChartVisualElementTitle.DoAssign(Source: TPersistent);
begin
  inherited DoAssign(Source);
  if Source is TdxChartVisualElementTitle then
  begin
    FAlignment := TdxChartVisualElementTitle(Source).Alignment;
    FMaxLineCount := TdxChartVisualElementTitle(Source).MaxLineCount;
    FPosition := TdxChartVisualElementTitle(Source).Position;
    FText := TdxChartVisualElementTitle(Source).Text;
    FWordWrap := TdxChartVisualElementTitle(Source).WordWrap;
  end;
end;

function TdxChartVisualElementTitle.ActuallyVisible: Boolean;
begin
  if not Visible then
    Exit(False);
  Result := ((Length(Text) > 0) or FIsTextChanged) or ((Appearance <> nil) and not Appearance.FillOptions.Texture.Empty);
end;

procedure TdxChartVisualElementTitle.CalculateAndAdjustContent(ACanvas: TcxCustomCanvas; var ABounds: TdxRectF);
begin
  if not ActuallyVisible then
  begin
    ViewInfo.Visible := False;
    Exit;
  end;
//  ViewInfo.SetBounds(ABounds.Content(CorrectPaddingByPosition(Appearance.ActualPadding, PositionToSide[Position]), ABounds);
  ViewInfo.SetBounds(ABounds.Content(Appearance.ActualMargins).InflateToTRect, ABounds);
  ViewInfo.Calculate(ACanvas);
  ViewInfo.AdjustContent(ABounds);
end;

function TdxChartVisualElementTitle.CreateAppearance: TdxChartVisualElementAppearance;
begin
  Result := TdxChartTitleAppearance.Create(Self);
end;

function TdxChartVisualElementTitle.CreateViewInfo: TdxChartVisualElementCustomViewInfo;
begin
  Result := TdxChartVisualElementTitleViewInfo.Create(Self);
end;

function TdxChartVisualElementTitle.GetActualDisplayText: string;
begin
  Result := Text;
end;

function TdxChartVisualElementTitle.GetActualDockPosition: TdxChartTitlePosition;
begin
  if Position = TdxChartTitlePosition.Default then
    Result := TdxChartTitlePosition.Top
  else
    Result := Position;
end;

function TdxChartVisualElementTitle.GetChart: TdxChart;
var
  AOwner: IdxChartVisualElement;
begin
  if Supports(Owner, IdxChartVisualElement, AOwner) then
    Result := AOwner.GetChart
  else
    Result := nil;
end;

function TdxChartVisualElementTitle.GetDefaultFontScaleFactor: Single;
begin
  Result := TdxChartVisualElementFontOptions.SizeToHeight(DefaultTitleSize) / TdxChartVisualElementFontOptions.SizeToHeight(TdxChartVisualElementAppearance.DefaultChartFontSize); 
end;

function TdxChartVisualElementTitle.GetDefaultWordWrap: Boolean;
begin
  Result := False;
end;

function TdxChartVisualElementTitle.GetText: string;
begin
  Result := FText;
end;

function TdxChartVisualElementTitle.SamePosition(APosition: TdxChartTitlePosition): Boolean;
begin
  Result := APosition = Position;
  if not Result and ((Position = TdxChartTitlePosition.Default) or (APosition = TdxChartTitlePosition.Default)) then
    Result := (APosition = TdxChartTitlePosition.Top) or (Position = TdxChartTitlePosition.Top);
end;

function TdxChartVisualElementTitle.GetAppearance: TdxChartVisualElementTitleAppearance;
begin
  Result := TdxChartVisualElementTitleAppearance(inherited Appearance);
end;

function TdxChartVisualElementTitle.GetViewInfo: TdxChartVisualElementTitleViewInfo;
begin
  Result := TdxChartVisualElementTitleViewInfo(inherited ViewInfo);
end;

function TdxChartVisualElementTitle.IsWordWrapStored: Boolean;
begin
  Result := WordWrap <> GetDefaultWordWrap;
end;

procedure TdxChartVisualElementTitle.SetAlignment(AValue: TdxAlignment);
var
  AChart: TdxChart;
begin
  if AValue <> FAlignment then
  begin
    FAlignment := AValue;
    if ActuallyVisible then
    begin
      ViewInfo.Dirty := True;
      AChart := GetChart;
      if AChart <> nil then
        AChart.InvalidateRect(ViewInfo.Bounds);
    end;
  end;
end;

procedure TdxChartVisualElementTitle.SetAppearance(AValue: TdxChartVisualElementTitleAppearance);
begin
  Appearance.Assign(AValue);
end;

procedure TdxChartVisualElementTitle.SetMaxLineCount(AValue: Integer);
begin
  if AValue <> FMaxLineCount then
  begin
    FMaxLineCount := AValue;
    LayoutChanged;
  end;
end;

procedure TdxChartVisualElementTitle.SetPosition(AValue: TdxChartTitlePosition);
begin
  if AValue <> FPosition then
  begin
    FPosition := AValue;
    LayoutChanged;
  end;
end;

procedure TdxChartVisualElementTitle.SetText(AValue: string);
begin
  if AValue <> FText then
  begin
    FText := AValue;
    FIsTextChanged := True;
    try
      LayoutChanged;
    finally
      FIsTextChanged := False;
    end;
  end;
end;

procedure TdxChartVisualElementTitle.SetWordWrap(AValue: Boolean);
begin
  if AValue <> FWordWrap then
  begin
    FWordWrap := AValue;
    LayoutChanged;
  end;
end;

{ TdxChartTitle }

function TdxChartTitle.ActuallyVisible: Boolean;
begin
  Result := inherited ActuallyVisible and GetChart.Titles.Visible;
end;

function TdxChartTitle.GetDefaultFontScaleFactor: Single;
begin
  Result := TdxChartVisualElementFontOptions.SizeToHeight(DefaultChartTitleSize) / TdxChartVisualElementFontOptions.SizeToHeight(TdxChartVisualElementAppearance.DefaultChartFontSize); 
end;

class function TdxChartTitle.GetHitCode: TdxChartHitCode;
begin
  Result := TdxChartHitCode.ChartTitle;
end;

function TdxChartTitle.GetOwnerComponent: TComponent;
begin
  Result := GetChart.GetOwnerComponent;
end;

{ TdxChartDiagramTitle }

function TdxChartDiagramTitle.ActuallyVisible: Boolean;
begin
  Result := inherited ActuallyVisible and Diagram.ActuallyVisible;
end;

function TdxChartDiagramTitle.GetDefaultFontScaleFactor: Single;
begin
  Result := TdxChartVisualElementFontOptions.SizeToHeight(DefaultChartTitleSize) / TdxChartVisualElementFontOptions.SizeToHeight(TdxChartVisualElementAppearance.DefaultChartFontSize); 
end;

class function TdxChartDiagramTitle.GetHitCode: TdxChartHitCode;
begin
  Result := TdxChartHitCode.DiagramTitle;
end;

function TdxChartDiagramTitle.GetOwnerComponent: TComponent;
begin
  Result := Diagram;
end;

function TdxChartDiagramTitle.GetParentElement: IdxChartVisualElement;
begin
  Result := Diagram;
end;

function TdxChartDiagramTitle.GetDiagram: TdxChartCustomDiagram;
begin
  Result := TdxChartCustomDiagram(Owner);
end;

{ TdxChartLegendTitle }

constructor TdxChartLegendTitle.Create(AOwner: TdxChartCustomLegend);
begin
  inherited Create(AOwner);
end;

function TdxChartLegendTitle.ActuallyVisible: Boolean;
begin
  Result := inherited ActuallyVisible and Legend.Visible;
end;

class function TdxChartLegendTitle.GetHitCode: TdxChartHitCode;
begin
  Result := TdxChartHitCode.LegendTitle;
end;

function TdxChartLegendTitle.GetLegend: TdxChartCustomLegend;
begin
  Result := TdxChartCustomLegend(Owner);
end;

function TdxChartLegendTitle.GetOwnerComponent: TComponent;
begin
  Result := Legend.GetOwner as TComponent;
end;

function TdxChartLegendTitle.GetParentElement: IdxChartVisualElement;
begin
  Result := Legend;
end;

procedure TdxChartLegendTitle.VisibleChanged;
begin
  ViewInfo.FreeCanvasBasedResources;
  Legend.VisibleChanged; 
end;

{ TdxChartSeriesTitle }

function TdxChartSeriesTitle.GetSeries: TdxChartCustomSeries;
begin
  Result := TdxChartCustomSeries(inherited Owner);
end;

function TdxChartSeriesTitle.GetChart: TdxChart;
begin
  if Series.Diagram <> nil then
    Result := Series.Diagram.Chart
  else
    Result := nil;
end;

class function TdxChartSeriesTitle.GetHitCode: TdxChartHitCode;
begin
  Result := TdxChartHitCode.SeriesTitle;
end;

function TdxChartSeriesTitle.GetOwnerComponent: TComponent;
begin
  Result := Series;
end;

function TdxChartSeriesTitle.GetParentElement: IdxChartVisualElement;
begin
  Result := Series.View;
end;

{ TdxChartTitleCollectionItem }

constructor TdxChartTitleCollectionItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FTitle := CreateTitle;
end;

destructor TdxChartTitleCollectionItem.Destroy;
begin
  FreeAndNil(FTitle);
  inherited Destroy;
end;

procedure TdxChartTitleCollectionItem.Assign(Source: TPersistent);
begin
  if Source is TdxChartTitleCollectionItem then
    Title.Assign(TdxChartTitleCollectionItem(Source).Title)
  else
    inherited Assign(Source);
end;

function TdxChartTitleCollectionItem.CreateTitle: TdxChartTitle;
begin
  Result := TdxChartTitle.Create(Self);
end;

function TdxChartTitleCollectionItem.ActuallyVisible: Boolean;
begin
  Result := Chart.Titles.Visible;
end;

function TdxChartTitleCollectionItem.GetAlignment: TdxAlignment;
begin
  Result := FTitle.Alignment;
end;

function TdxChartTitleCollectionItem.GetAppearance: TdxChartVisualElementTitleAppearance;
begin
  Result := FTitle.Appearance;
end;

function TdxChartTitleCollectionItem.GetChart: TdxChart;
begin
  if Collection <> nil then
    Result := TdxChartTitles(Collection).Chart
  else
    Result := nil;
end;

function TdxChartTitleCollectionItem.GetParentAppearance: TdxChartVisualElementAppearance;
begin
  if Chart <> nil then
    Result := Chart.Appearance
  else
    Result := nil;
end;

function TdxChartTitleCollectionItem.GetParentElement: IdxChartVisualElement;
begin
  Result := Chart;
end;

function TdxChartTitleCollectionItem.GetPosition: TdxChartTitlePosition;
begin
  Result := FTitle.Position;
end;

function TdxChartTitleCollectionItem.GetMaxLineCount: Integer;
begin
  Result := FTitle.MaxLineCount;
end;

function TdxChartTitleCollectionItem.GetText: string;
begin
  Result := FTitle.Text;
end;

function TdxChartTitleCollectionItem.GetVisible: Boolean;
begin
  Result := FTitle.Visible;
end;

function TdxChartTitleCollectionItem.GetWordWrap: Boolean;
begin
  Result := FTitle.WordWrap;
end;

procedure TdxChartTitleCollectionItem.LayoutChanged;
begin
  Chart.Changed(TdxChart.TChartChange.Layout);
end;

procedure TdxChartTitleCollectionItem.SetAlignment(AValue: TdxAlignment);
begin
  Title.Alignment := AValue;
end;

procedure TdxChartTitleCollectionItem.SetAppearance(AValue: TdxChartVisualElementTitleAppearance);
begin
  Appearance.Assign(AValue);
end;

procedure TdxChartTitleCollectionItem.SetPosition(AValue: TdxChartTitlePosition);
begin
  Title.Position := AValue;
end;

procedure TdxChartTitleCollectionItem.SetMaxLineCount(AValue: Integer);
begin
  Title.MaxLineCount := AValue;
end;

procedure TdxChartTitleCollectionItem.SetText(const AValue: string);
begin
  Title.Text := AValue;
end;

procedure TdxChartTitleCollectionItem.SetVisible(AValue: Boolean);
begin
  Title.Visible := AValue;
end;

procedure TdxChartTitleCollectionItem.SetWordWrap(AValue: Boolean);
begin
  Title.WordWrap := AValue;
end;

procedure TdxChartTitleCollectionItem.StyleChanged;
begin
end;

procedure TdxChartTitleCollectionItem.TextColorChanged;
begin
end;

{ TdxChartTitles }

constructor TdxChartTitles.Create(AOwner: TdxChart);
begin
  inherited Create(AOwner.OwnerComponent, TdxChartTitleCollectionItem);
  FChart := AOwner;
  FVisible := True;
end;

procedure TdxChartTitles.Assign(Source: TPersistent);
begin
  if Source is TdxChartTitles then
    Visible := TdxChartTitles(Source).Visible;
  inherited Assign(Source);
end;

function TdxChartTitles.Add: TdxChartTitleCollectionItem;
begin
  Result := TdxChartTitleCollectionItem(inherited Add);
end;

procedure TdxChartTitles.BiDiModeChanged;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if Items[I].Title.ActuallyVisible then
      Items[I].Title.BiDiModeChanged;
end;

function TdxChartTitles.GetVisibleCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Count - 1 do
    if Items[I].Title.ActuallyVisible then
      Inc(Result);
end;

procedure TdxChartTitles.LayoutChanged;
begin
  if Chart <> nil then
    Chart.Changed(TdxChart.TChartChange.Layout);
end;

procedure TdxChartTitles.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
  if (Item = nil) or (TdxChartTitleCollectionItem(Item).Title.ActuallyVisible) then
    LayoutChanged;
end;

function TdxChartTitles.GetItem(AIndex: Integer): TdxChartTitleCollectionItem;
begin
  Result := TdxChartTitleCollectionItem(inherited Items[AIndex]);
end;

procedure TdxChartTitles.SetItem(AIndex: Integer; AValue: TdxChartTitleCollectionItem);
begin
  Items[AIndex].Assign(AValue);
end;

procedure TdxChartTitles.SetVisible(AValue: Boolean);
var
  AVisibleCount: Integer;
begin
  if AValue <> FVisible then
  begin
    AVisibleCount := GetVisibleCount;
    FVisible := AValue;
    if AVisibleCount <> GetVisibleCount then
      LayoutChanged;
  end;
end;

{ TdxChartSeriesViewAppearance }

function TdxChartSeriesViewAppearance.GetView: TdxChartSeriesCustomView;
begin
  Result := TdxChartSeriesCustomView(Owner)
end;

function TdxChartSeriesViewAppearance.GetSeries: TdxChartCustomSeries;
begin
  Result := View.Series;
end;

function TdxChartSeriesViewAppearance.GetActualColor(AIndex: Integer): TdxAlphaColor;
begin
  case AIndex of
    ColorIndex, BorderColorIndex, PenColorIndex:
      Result := ColorScheme.SeriesColors.GetByElementIndex(Series.ColorSchemeIndex).Color;
    Color2Index:
      Result := ColorScheme.SeriesColors.GetByElementIndex(Series.ColorSchemeIndex).Color2;
  else
    Result := inherited GetActualColor(AIndex);
  end;
end;

{ TdxChartCustomLabelsAppearance }

function TdxChartCustomLabelsAppearance.GetActualColor(AIndex: Integer): TdxAlphaColor;
begin
  Result := TdxChartCustomLabels(Owner).GetActualColor(AIndex);
  if Result = TdxAlphaColors.Default then
    Result := inherited GetActualColor(AIndex);
end;

function TdxChartCustomLabelsAppearance.GetLineOptions: TdxStrokeOptions;
begin
  Result := StrokeOptions;
end;

function TdxChartCustomLabelsAppearance.HasFillOptions: Boolean;
begin
  Result := True;
end;

function TdxChartCustomLabelsAppearance.HasFontOptions: Boolean;
begin
  Result := True;
end;

function TdxChartCustomLabelsAppearance.HasStrokeOptions: Boolean;
begin
  Result := True;
end;

procedure TdxChartCustomLabelsAppearance.SetLineOptions(AValue: TdxStrokeOptions);
begin
  StrokeOptions.Assign(AValue);
end;

function TdxChartCustomLabelsAppearance.GetFontOptions: TdxChartVisualElementFontOptions;
begin
  Result := TdxChartVisualElementFontOptions(inherited FontOptions);
end;

procedure TdxChartCustomLabelsAppearance.SetFontOptions(AValue: TdxChartVisualElementFontOptions);
begin
  inherited FontOptions := AValue;
end;

{ TdxChartCustomLabels }

constructor TdxChartCustomLabels.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FResolveOverlappingIndent := GetDefaultResolveOverlappingIndent;
  FLineLength := GetDefaultLineLength;
  FLineVisible := TdxDefaultBoolean.bDefault;
  FMaxWidth := GetDefaultMaxWidth;
  FTextAngle := GetDefaultTextAngle;
  FValueProvider := TdxChartAxisNamedValueProvider.Create(Unassigned);
end;

destructor TdxChartCustomLabels.Destroy;
begin
  TdxChartTextFormatController.Release(FTextFormatter);
  FValueProvider.Free;
  inherited Destroy;
end;

function TdxChartCustomLabels.GetAppearance: TdxChartCustomLabelsAppearance;
begin
  Result := TdxChartCustomLabelsAppearance(inherited Appearance)
end;

procedure TdxChartCustomLabels.ChangeScale(M, D: Integer);
begin
  inherited ChangeScale(M, D);
  FLineLength := dxScale(FLineLength, M, D);
  FResolveOverlappingIndent := dxScale(FResolveOverlappingIndent, M, D);
  FMaxWidth := dxScale(FMaxWidth, M, D);
end;

function TdxChartCustomLabels.CreateAppearance: TdxChartVisualElementAppearance;
begin
  Result := TdxChartCustomLabelsAppearance.Create(Self);
end;

procedure TdxChartCustomLabels.DoAssign(Source: TPersistent);
var
  ASource: TdxChartCustomLabels;
begin
  inherited DoAssign(Source);
  if Source is TdxChartCustomLabels then
  begin
    ASource := TdxChartCustomLabels(Source);
    FAngle := ASource.Angle;
    FLineLength := ASource.LineLength;
    FLineVisible := ASource.LineVisible;
    FMaxLineCount := ASource.MaxLineCount;
    FMaxWidth := ASource.MaxWidth;
    FTextAlignment := ASource.TextAlignment;
    TextFormat := ASource.TextFormat;
    ResolveOverlappingIndent := ASource.ResolveOverlappingIndent;
  end;
end;

function TdxChartCustomLabels.GetActualColor(AIndex: Integer): TdxAlphaColor;
begin
  Result := TdxAlphaColors.Default;
end;

function TdxChartCustomLabels.GetDefaultAngle: Single;
begin
  Result := 0;
end;

function TdxChartCustomLabels.GetDefaultLineLength: Single;
begin
  Result := 0;
end;

function TdxChartCustomLabels.GetDefaultMaxWidth: Single;
begin
  Result := 0;
end;

function TdxChartCustomLabels.GetDefaultResolveOverlappingIndent: Single;
begin
  Result := 0;
end;

function TdxChartCustomLabels.GetDefaultTextAngle: Single;
begin
  Result := 0;
end;

function TdxChartCustomLabels.GetFormattedValue(const AValue: Variant; const AGetVariable: TdxChartNamedValueProvider): string;
begin
  if Assigned(AGetVariable) then
    Result := TdxChartTextFormatController.FormatPattern(TextFormatter, AGetVariable)
  else
  begin
    FValueProvider.SetValue(AValue);
    Result := TdxChartTextFormatController.FormatPattern(TextFormatter, FValueProvider.GetValueByName);
  end;
end;

function TdxChartCustomLabels.GetValueAsText(const AValue: Variant): string;
begin
  Result := GetFormattedValue(AValue);
end;

function TdxChartCustomLabels.GetTextFormat: TdxChartTextFormat;
begin
  Result := TdxChartTextFormatController.GetFormat(FTextFormatter);
end;

function TdxChartCustomLabels.GetTextFormatter: TObject;
begin
  Result := FTextFormatter;
end;

procedure TdxChartCustomLabels.SetAngle(AValue: Single);
begin
  if not SameValue(FAngle, AValue) then
  begin
    FAngle := AValue;
    LayoutChanged;
  end;
end;

procedure TdxChartCustomLabels.SetAppearance(AValue: TdxChartCustomLabelsAppearance);
begin
  Appearance.Assign(AValue);
end;

procedure TdxChartCustomLabels.SetLineLength(AValue: Single);
begin
  AValue := Max(0, AValue);
  if FLineLength <> AValue then
  begin
    FLineLength := AValue;
    LayoutChanged;
  end;
end;

procedure TdxChartCustomLabels.SetLineVisible(AValue: TdxDefaultBoolean);
begin
  if FLineVisible <> AValue then
  begin
    FLineVisible := AValue;
    LayoutChanged;
  end;
end;

procedure TdxChartCustomLabels.SetMaxWidth(AValue: Single);
begin
  AValue := Max(0, AValue);
  if not SameValue(AValue, FMaxWidth) then
  begin
    FMaxWidth := AValue;
    LayoutChanged;
  end;
end;

procedure TdxChartCustomLabels.SetMaxLineCount(AValue: Integer);
begin
  AValue := Max(0, AValue);
  if AValue <> MaxLineCount then
  begin
    FMaxLineCount := AValue;
    LayoutChanged;
  end;
end;

procedure TdxChartCustomLabels.SetTextFormat(const AValue: TdxChartTextFormat);
begin
  if TdxChartTextFormatController.Add(AValue, FTextFormatter) then
    LayoutChanged;
end;

procedure TdxChartCustomLabels.UpdateResolveOverlappingIndent(AValue: Single);
begin
  FResolveOverlappingIndent := AValue;
end;

procedure TdxChartCustomLabels.SetResolveOverlappingIndent(AValue: Single);
begin
  if not SameValue(AValue, FResolveOverlappingIndent) then
  begin
    FResolveOverlappingIndent := AValue;
    ResolveOverlappingIndentChanged;
    LayoutChanged;
  end;
end;

procedure TdxChartCustomLabels.SetTextAlignment(AValue: TdxAlignment);
begin
  if AValue <> TextAlignment then
  begin
    FTextAlignment := AValue;
    LayoutChanged;
  end;
end;

function TdxChartCustomLabels.IsAngleStored: Boolean;
begin
  Result := not SameValue(FAngle, GetDefaultAngle);
end;

function TdxChartCustomLabels.IsLineLengthStored: Boolean;
begin
  Result := not SameValue(FLineLength, GetDefaultLineLength);
end;

function TdxChartCustomLabels.IsMaxWidthStored: Boolean;
begin
  Result := not SameValue(FMaxWidth, GetDefaultMaxWidth);
end;

function TdxChartCustomLabels.IsResolveOverlappingIndentStored: Boolean;
begin
  Result := not SameValue(ResolveOverlappingIndent, GetDefaultResolveOverlappingIndent);
end;

procedure TdxChartCustomLabels.ResolveOverlappingIndentChanged;
begin
  // do nothing
end;

{ TdxChartSeriesValueLabelAppearance }

function TdxChartSeriesValueLabelAppearance.GetViewAppearance: TdxChartSeriesViewAppearance;
begin
  Result := TdxChartSeriesValueLabels(Owner).View.Appearance;
end;

function TdxChartSeriesValueLabelAppearance.DefaultBorder: Boolean;
begin
  Result := ColorScheme.SeriesLabel.ShowBorder;
end;

function TdxChartSeriesValueLabelAppearance.DefaultParentBackground: Boolean;
begin
  Result := False;
end;

function TdxChartSeriesValueLabelAppearance.GetActualColor(AIndex: Integer): TdxAlphaColor;
begin
  if (AIndex = TdxChartVisualElementAppearance.TextColorIndex) or (AIndex = TdxChartVisualElementAppearance.BorderColorIndex) then
    Result := ViewAppearance.GetActualColor(TdxChartVisualElementAppearance.PenColorIndex)
  else
    Result := TdxAlphaColors.Transparent;
end;

{ TdxChartSeriesValueLabels }

function TdxChartSeriesValueLabels.GetResolveOverlappingMode: TdxChartSeriesValueLabelsResolveOverlappingMode;
begin
  Result := TdxChartSeriesValueLabelsResolveOverlappingMode.Default;
end;

function TdxChartSeriesValueLabels.GetAppearance: TdxChartSeriesValueLabelAppearance;
begin
  Result := TdxChartSeriesValueLabelAppearance(inherited Appearance)
end;

function TdxChartSeriesValueLabels.GetChart: TdxChart;
begin
  Result := View.Chart;
end;

function TdxChartSeriesValueLabels.GetDefaultAngle: Single;
begin
  Result := View.GetDefaultLabelAngle;
end;

function TdxChartSeriesValueLabels.GetDefaultLineLength: Single;
begin
  Result := View.GetDefaultLineLength;
end;

function TdxChartSeriesValueLabels.GetParentElement: IdxChartVisualElement;
begin
  Result := View;
end;

function TdxChartSeriesValueLabels.GetSeries: TdxChartCustomSeries;
begin
  Result := TdxChartSeriesCustomView(Owner).Series;
end;

function TdxChartSeriesValueLabels.GetView: TdxChartSeriesCustomView;
begin
  Result := TdxChartSeriesCustomView(Owner);
end;

function TdxChartSeriesValueLabels.ActuallyVisible: Boolean;
begin
  Result := Visible and Series.ActuallyVisible;
end;

function TdxChartSeriesValueLabels.CreateAppearance: TdxChartVisualElementAppearance;
begin
  Result := View.GetValueLabelAppearanceClass.Create(Self);
end;

function TdxChartSeriesValueLabels.GetDefaultVisible: Boolean;
begin
  Result := False;
end;

procedure TdxChartSeriesValueLabels.SetAppearance(AValue: TdxChartSeriesValueLabelAppearance);
begin
  Appearance.Assign(AValue);
end;

{ TdxChartValueLabelCustomViewInfo }

constructor TdxChartValueLabelCustomViewInfo.Create(AOwner: TObject);
begin
  inherited Create;
  FOwner := AOwner;
  ResetCalculatedConstraints;
end;

destructor TdxChartValueLabelCustomViewInfo.Destroy;
begin
  FTextLayout.Free;
  inherited Destroy;
end;

procedure TdxChartValueLabelCustomViewInfo.CalculateLeaderLineType;
begin
  FLeaderLineType := TLeaderLineType.None;
  if (Options.LineVisible <> bFalse) and (StartPoint <> EndPoint) then
  begin
    if StartPoint <> FMiddlePoint then
      FLeaderLineType := TLeaderLineType.TwoPoints;
    if (FLeaderLineType = TLeaderLineType.TwoPoints) and (EndPoint <> TdxPointF.Null) then
      FLeaderLineType := TLeaderLineType.ThreePoints;
  end;
end;

function TdxChartValueLabelCustomViewInfo.CalculateTextFlags: Cardinal;
begin
  Result := dxChartCalculateTextFlags(GetTextAlignment, IsZero(GetTextAngle),
    WordWrap, Appearance.UseRightToLeftReading);
end;

procedure TdxChartValueLabelCustomViewInfo.CalculateTextLayout;
begin
  FTextLayout.SetText(GetDisplayText);
  FTextLayout.SetFlags(CalculateTextFlags);
  FTextLayout.SetRotation(GetTextAngle);
  FTextLayout.SetColor(GetColor);
  FTextLayout.SetFont(GetFont);
  FTextLayout.SetLayoutConstraints(GetTextLayoutConstraints, GetActualMaxLineCount);
end;

function TdxChartValueLabelCustomViewInfo.CalculateValidBounds(const ABoundingRect: TdxRectF): TdxRectF;
begin
  Result := FBounds;
  if Result.Left < ABoundingRect.Left then
    Result.Left := ABoundingRect.Left;
  if Result.Right > ABoundingRect.Right then
    Result.Right := ABoundingRect.Right;
end;

procedure TdxChartValueLabelCustomViewInfo.CreateTextLayout(ACanvas: TcxCustomCanvas);
begin
  if not ACanvas.CheckIsValid(FTextLayout) then
  begin
    FreeAndNil(FTextLayout);
    FTextLayout := ACanvas.CreateTextLayout;
  end;
end;

procedure TdxChartValueLabelCustomViewInfo.DoCalculate(ACanvas: TcxCustomCanvas);
var
  ACenter: TdxPointF;
begin
  inherited DoCalculate(ACanvas);
  Visible := True;
  GetPoints(ACenter, FStartPoint, FMiddlePoint, FEndPoint);
  CalculateLeaderLineType;
  CreateTextLayout(ACanvas);
  UpdateBounds;
  Dirty := False;
end;

procedure TdxChartValueLabelCustomViewInfo.DoDraw(ACanvas: TcxCustomCanvas);
var
  ABounds: TRect;
begin
  if Bounds.IsEmpty or TextBounds.IsEmpty or (FTextLayout = nil) or (FTextLayout.Text = '') then
    Exit;

  case FLeaderLineType of
    TLeaderLineType.TwoPoints:
    begin
      ACanvas.EnableAntialiasing((FStartPoint.X <> FMiddlePoint.X) and (FStartPoint.Y <> FMiddlePoint.Y));
      ACanvas.Line(FStartPoint, FMiddlePoint, GetActualPen);
      ACanvas.RestoreAntialiasing;
    end;
    TLeaderLineType.ThreePoints:
      ACanvas.Polyline([FStartPoint, FMiddlePoint, FEndPoint], GetActualPen);
  end;

  ACanvas.EnableAntialiasing(False);
  ABounds := Bounds.DeflateToTRect;
  ACanvas.FillRect(ABounds, Appearance.ActualBrush);
  if not TdxAlphaColors.IsTransparentOrEmpty(Appearance.ActualBorderColor) and
   not IsZero(Appearance.ActualBorderThickness) then
    ACanvas.FrameRect(ABounds, Appearance.ActualBorderColor, Appearance.ActualBorderThickness);

  ACanvas.RestoreAntialiasing;

  FTextLayout.Draw(TextBounds);
end;

function TdxChartValueLabelCustomViewInfo.GetActualMaxLineCount: Integer;
begin
  if FCalculatedMaxLineCount > 0 then
    Result := Max(FCalculatedMaxLineCount, Options.MaxLineCount)
  else
    Result := Options.MaxLineCount;
end;

function TdxChartValueLabelCustomViewInfo.GetActualMaxWidth: Single;
begin
  if FCalculatedMaxWidth > 0 then
    Result := Min(FCalculatedMaxWidth, IfThen(IsZero(Options.MaxWidth), FCalculatedMaxWidth, Options.MaxWidth))
  else
    Result := Options.MaxWidth;
end;

function TdxChartValueLabelCustomViewInfo.GetActualPen: TcxCanvasBasedPen;
begin
  Result := Appearance.ActualPen;
end;

function TdxChartValueLabelCustomViewInfo.GetColor: TdxAlphaColor;
begin
  Result := Appearance.ActualTextColor;
end;

procedure TdxChartValueLabelCustomViewInfo.GetPoints(var ACenterPoint, AStartPoint, AMiddlePoint, AEndPoint: TdxPointF);
begin
  ACenterPoint := Bounds.CenterPoint;
end;

function TdxChartValueLabelCustomViewInfo.GetTextAlignment: TdxAlignment;
begin
  Result := Options.TextAlignment;
end;

function TdxChartValueLabelCustomViewInfo.GetTextAngle: Single;
begin
  Result := Options.Angle;
end;

function TdxChartValueLabelCustomViewInfo.GetTextLayoutConstraints: TdxRectF;
var
  AActualMaxWidth: Single;
begin
  Result := VisibleBounds;
  AActualMaxWidth := GetActualMaxWidth;
  if not IsZero(AActualMaxWidth) then
    Result.Width := Min(AActualMaxWidth, Result.Width);
end;

function TdxChartValueLabelCustomViewInfo.GetAppearance: TdxChartSeriesValueLabelAppearance;
begin
  Result := TdxChartSeriesValueLabelAppearance(Options.Appearance);
end;

function TdxChartValueLabelCustomViewInfo.GetFont: TcxCanvasBasedFont;
begin
  Result := Appearance.ActualFont;
end;

function TdxChartValueLabelCustomViewInfo.GetTextSize: TdxSizeF;
const
  GDIToGDIPlusTextWidthCompensation = 4;
begin
  if FTextLayout <> nil then
  begin
    Result := FTextLayout.MeasureSizeF;
    Result.Width := Result.Width + GDIToGDIPlusTextWidthCompensation;
  end
  else
    Result := TdxSizeF.Null;
end;

function TdxChartValueLabelCustomViewInfo.GetWordWrap: Boolean;
begin
  Result := ((GetActualMaxWidth > 0) or (Pos(dxCR, DisplayText) > 0)) and (GetActualMaxLineCount <> 1);
end;

function TdxChartValueLabelCustomViewInfo.IsTextTruncated: Boolean;
begin
  Result := FTextLayout.IsTruncated;
end;

procedure TdxChartValueLabelCustomViewInfo.Realign(const ACenterPoint: TdxPointF);
begin
  FBounds.SetCenter(ACenterPoint);
  FTextBounds := FBounds.Content(Appearance.ActualPadding);
  FTextBounds.Inflate(-Appearance.ActualBorderThickness);
end;

procedure TdxChartValueLabelCustomViewInfo.Realign;
var
  ACenter: TdxPointF;
begin
  GetPoints(ACenter, FStartPoint, FMiddlePoint, FEndPoint);
  Realign(ACenter);
end;

procedure TdxChartValueLabelCustomViewInfo.ResetCalculatedConstraints;
begin
  FCalculatedMaxWidth := 0;
  FCalculatedMaxLineCount := 0;
end;

procedure TdxChartValueLabelCustomViewInfo.UpdateBounds;
var
  AActualMaxWidth: Single;
begin
  CalculateTextLayout;
  FBounds.Size := TextSize;
  if not FBounds.IsEmpty then
  begin
    AActualMaxWidth := GetActualMaxWidth;
    if not IsZero(AActualMaxWidth) then
      FBounds.Width := Min(FBounds.Width, AActualMaxWidth);
    FBounds.Inflate(Appearance.ActualPadding);
    FBounds.Inflate(Appearance.ActualBorderThickness);
  end;
  Realign;
end;

procedure TdxChartValueLabelCustomViewInfo.Validate(const ABoundingRect: TdxRectF);
var
  ABounds: TdxRectF;
  AMaxWidth: Single;
begin
  ResetCalculatedConstraints;
  Visible := True;
  UpdateBounds;
  if not ABoundingRect.Contains(FMiddlePoint) then
  begin
    Visible := False;
    Exit;
  end;
  ABounds := CalculateValidBounds(ABoundingRect);
  if ABounds <> FBounds then
  begin
    AMaxWidth := ABounds.Width - Appearance.Padding.Left - Appearance.Padding.Right - Appearance.ActualBorderThickness * 2;
    if AMaxWidth > 0 then
    begin
      FCalculatedMaxWidth := AMaxWidth;
      FCalculatedMaxLineCount := AutoMaxLineCount;
      UpdateBounds;
    end
    else
      Visible := False;
  end;
end;

{ TdxChartSeriesValueLabelViewInfo }

function TdxChartSeriesValueLabelViewInfo.GetOwner: TdxChartSeriesValueViewInfo;
begin
  Result := TdxChartSeriesValueViewInfo(inherited Owner)
end;

function TdxChartSeriesValueLabelViewInfo.GetDisplayText: string;
begin
  Result := Owner.DisplayText;
end;

function TdxChartSeriesValueLabelViewInfo.GetHitElement(const P: TdxPointF): IdxChartHitTestElement;
var
  APointInfo: TdxChartSeriesPointInfo;
  AValueLabelInfo: TdxChartSeriesValueLabelInfo;
begin
  if Bounds.Contains(P) then
  begin
    if TextBounds.Contains(P) then
      Result := TdxChartSeriesValueLabelCaptionHitElement.Create(Self)
    else begin
      APointInfo := Owner.CreateSeriesPointInfo;
      AValueLabelInfo := TdxChartSeriesValueLabelInfo.Create(APointInfo, DisplayText);
      Result := TdxChartComponentDependentHitElement.Create(AValueLabelInfo, True, Owner.Series, TdxChartHitCode.SeriesValueLabel, TdxChartSeriesValueLabelViewInfo.BackgroundSubAreaCode);
    end;
  end
  else
    Result := nil;
end;

function TdxChartSeriesValueLabelViewInfo.GetOptions: TdxChartCustomLabels;
begin
  Result := GetSeriesValueLabels;
end;

procedure TdxChartSeriesValueLabelViewInfo.GetPoints(var ACenter, AStartPoint, AMiddlePoint, AEndPoint: TdxPointF);
begin
  Owner.CalculateLabelLeaderLinePoints(AStartPoint, AMiddlePoint, AEndPoint);
  ACenter := Owner.GetLabelAnchorPoint;
end;

function TdxChartSeriesValueLabelViewInfo.GetValue: Variant;
begin
  Result := Owner.Value;
end;

function TdxChartSeriesValueLabelViewInfo.GetSeriesValueLabels: TdxChartSeriesValueLabels;
begin
  Result := Owner.Owner.ValueLabels;
end;

{ TdxChartDiagramSeriesGroup }

constructor TdxChartDiagramSeriesGroup.Create(
  AOwner: TdxChartDiagramCustomViewData; AMasterSeries: TdxChartCustomSeries);
begin
  inherited Create(False);
  FOwner := AOwner;
  TryAggregate(AMasterSeries);
end;

procedure TdxChartDiagramSeriesGroup.AsyncCalculate;
begin
  System.TMonitor.Enter(Self);
  try
    BeforeCalculate;
    try
      DoCalculate;
    finally
      AfterCalculate
    end;
  finally
    System.TMonitor.Exit(Self);
  end;
end;

procedure TdxChartDiagramSeriesGroup.AfterCalculate;
begin
end;

procedure TdxChartDiagramSeriesGroup.BeforeCalculate;
begin
end;

procedure TdxChartDiagramSeriesGroup.DoCalculate;
begin
end;

function TdxChartDiagramSeriesGroup.EnableReverseOrder: Boolean;
begin
  Result := True;
end;

function TdxChartDiagramSeriesGroup.IsNumeric: Boolean;
begin
  Result := MasterView.ViewData.IsNumeric;
end;

procedure TdxChartDiagramSeriesGroup.ReverseOrder;
var
  I: Integer;
begin
  if not EnableReverseOrder then
    Exit;
  Reverse;
  for I := 0 to Count - 1 do
    Views[I].ViewInfo.FIndex := I;
end;

function TdxChartDiagramSeriesGroup.TryAggregate(ASeries: TdxChartCustomSeries): Boolean;
begin
  Result := (MasterView = nil) or MasterView.CanAggregate(ASeries.View);
  if not Result then
    Exit;
  if MasterView = nil then
    FMasterView := ASeries.View;
  ASeries.View.ViewInfo.SetGroup(Self, Add(ASeries));
end;

function TdxChartDiagramSeriesGroup.GetSeries(AIndex: Integer): TdxChartCustomSeries;
begin
  Result := TdxChartCustomSeries(List[AIndex])
end;

function TdxChartDiagramSeriesGroup.GetView(AIndex: Integer): TdxChartSeriesCustomView;
begin
  Result := TdxChartCustomSeries(List[AIndex]).View;
end;

{ TdxChartDiagramCustomViewData }

constructor TdxChartDiagramCustomViewData.Create(AOwner: TdxChartCustomDiagram);
begin
  FDiagram := AOwner;
  FGroups := TdxFastObjectList.Create(True);
  FSeries := TdxFastObjectList.Create(False);
end;

destructor TdxChartDiagramCustomViewData.Destroy;
begin
  FreeAndNil(FSeries);
  FreeAndNil(FGroups);
  inherited Destroy;
end;

function TdxChartDiagramCustomViewData.AllowSorting: Boolean;
begin
  Result := False;
end;

procedure TdxChartDiagramCustomViewData.DoCalculate;
var
  I: Integer;
  ATaskGroup: TdxTaskGroup;
begin
  FGroups.Clear;
  FSeries.Clear;
  FTotalRecords := 0;
  for I := 0 to Diagram.SeriesCount - 1 do
    TryAddSeries(Diagram.Series[I]);
  if IsReverseOrder then
    for I := 0 to GroupCount - 1 do
      Groups[I].ReverseOrder;
  if Diagram.Chart.NeedThreading(TotalRecords) then
  begin
    ATaskGroup := TdxTaskGroup.Create;
    try
      for I := 0 to SeriesCount - 1 do
        ATaskGroup.AddTask(Series[I].View.ViewData.Calculate);
      ATaskGroup.RunAndWait;
    finally
      ATaskGroup.Free;
    end;
    ATaskGroup := TdxTaskGroup.Create;
    try
      for I := 0 to GroupCount - 1 do
        ATaskGroup.AddTask(Groups[I].AsyncCalculate);
      ATaskGroup.RunAndWait;
    finally
      ATaskGroup.Free;
    end;
  end
  else
  begin
    for I := 0 to SeriesCount - 1 do
      Series[I].View.ViewData.Calculate;
    for I := 0 to GroupCount - 1 do
      Groups[I].AsyncCalculate;
  end;
end;

function TdxChartDiagramCustomViewData.GetSeriesGroupClass(ASeries: TdxChartCustomSeries): TdxChartDiagramSeriesGroupClass;
begin
  Result := TdxChartDiagramSeriesGroup;
end;

function TdxChartDiagramCustomViewData.IsReverseOrder: Boolean;
begin
  Result := False;
end;

procedure TdxChartDiagramCustomViewData.TryAddSeries(ASeries: TdxChartCustomSeries);
var
 I: Integer;
begin
  if ASeries.View <> nil then
    ASeries.View.ViewInfo.SetGroup(nil);
  if not ASeries.ActuallyVisible or ((GroupCount > 0) and (ASeries.View.ViewData.IsNumeric <> Groups[0].IsNumeric)) then
    Exit;
  Inc(FTotalRecords, ASeries.Points.Count);
  FSeries.Add(ASeries);
  for I := 0 to GroupCount - 1 do
    if Groups[I].TryAggregate(ASeries) then
      Exit;
  FGroups.Add(GetSeriesGroupClass(ASeries).Create(Self, ASeries));
end;

function TdxChartDiagramCustomViewData.GetGroup(AIndex: Integer): TdxChartDiagramSeriesGroup;
begin
  Result := TdxChartDiagramSeriesGroup(FGroups.List[AIndex]);
end;

function TdxChartDiagramCustomViewData.GetGroupCount: Integer;
begin
  Result := FGroups.Count;
end;

function TdxChartDiagramCustomViewData.GetSeries(AIndex: Integer): TdxChartCustomSeries;
begin
  Result := TdxChartCustomSeries(FSeries.List[AIndex]);
end;

function TdxChartDiagramCustomViewData.GetSeriesCount: Integer;
begin
  Result := FSeries.Count;
end;

function TdxChartDiagramCustomViewData.GetView(AIndex: Integer): TdxChartSeriesCustomView;
begin
  Result := TdxChartCustomSeries(FSeries.List[AIndex]).View;
end;

{ TdxChartDiagramCustomViewInfo }

constructor TdxChartDiagramCustomViewInfo.Create(AOwner: TdxChartCustomDiagram);
begin
  inherited Create(AOwner.Appearance);
  FDiagram := AOwner;
  FItems := TdxChartItemsViewInfoList.Create(False);
  FMutableItems := TdxChartItemsViewInfoList.Create(False);
  FTopmostItems := TdxChartItemsViewInfoList.Create(False);
end;

destructor TdxChartDiagramCustomViewInfo.Destroy;
begin
  FreeAndNil(FItems);
  FreeAndNil(FMutableItems);
  FreeAndNil(FTopmostItems);
  inherited Destroy;
end;

function TdxChartDiagramCustomViewInfo.GetContentRect: TdxRectF;
begin
  Result := Bounds.Content(Padding);
  Result.Inflate(-BorderThickness);
end;

function TdxChartDiagramCustomViewInfo.GetLegend: TdxChartDiagramLegend;
begin
  Result := Diagram.Legend;
end;

function TdxChartDiagramCustomViewInfo.GetTitle: TdxChartVisualElementTitle;
begin
  Result := Diagram.Title;
end;

function TdxChartDiagramCustomViewInfo.GetTitleViewInfo: TdxChartVisualElementTitleViewInfo;
begin
  Result := Title.ViewInfo;
end;

function TdxChartDiagramCustomViewInfo.GetSeries(AIndex: Integer): TdxChartCustomSeries;
begin
  Result := Diagram.Series[AIndex];
end;

function TdxChartDiagramCustomViewInfo.GetSeriesCount: Integer;
begin
  Result := Diagram.SeriesCount;
end;

function TdxChartDiagramCustomViewInfo.GetViewData: TdxChartDiagramCustomViewData;
begin
  Result := Diagram.ViewData;
end;

procedure TdxChartDiagramCustomViewInfo.UpdateLabelsBoundingRect(AValue: TdxChartSeriesValueViewInfo);
var
  ALabelBounds: TdxRectF;
begin
  if (AValue.ValueLabel <> nil) and AValue.ValueLabel.ActuallyVisible then
  begin
    ALabelBounds := AValue.ValueLabel.Bounds;
    if not ALabelBounds.IsEmpty then
      FLabelsBoundingRect.Union(ALabelBounds);
  end;
end;

function TdxChartDiagramCustomViewInfo.CalculateChartHitTest(AHitTest: TdxChartHitTestEngine; const P: TdxPointF): Boolean;
var
  I: Integer;
  AViewViewInfo: TdxChartSeriesViewCustomViewInfo;
begin
  Result := False;
  for I := FItems.Count - 1 downto 0 do
  begin
    if FItems[I] is TdxChartSeriesViewCustomViewInfo then
    begin
      AViewViewInfo := TdxChartSeriesViewCustomViewInfo(FItems[I]);
      if AViewViewInfo.ActuallyVisible and AViewViewInfo.CalculateLabelsHitTest(AHitTest, P) then
      begin
        Result := True;
        Break;
      end;
    end;
  end;
end;

function TdxChartDiagramCustomViewInfo.CalculateHitTest(AHitTest: TdxChartHitTestEngine; const P: TdxPointF): Boolean;
var
  I: Integer;
begin
  Result := inherited CalculateHitTest(AHitTest, P);
  if not Result then
    Exit;
  if Title.ViewInfo.CalculateHitTest(AHitTest, P) then
    Exit;
  if Legend.ViewInfo.CalculateHitTest(AHitTest, P) then
    Exit;
  if CalculateChartHitTest(AHitTest, P) then
    Exit;
  for I := FItems.Count - 1 downto 0 do
    if FItems[I].CalculateHitTest(AHitTest, P) then
      Break;
end;

procedure TdxChartDiagramCustomViewInfo.CalculateView(AView: TdxChartSeriesCustomView; ACanvas: TcxCustomCanvas);
begin
  AView.ViewInfo.SetBounds(PlotArea, PlotArea);
  AView.ViewInfo.Calculate(ACanvas);
  Items.Add(AView.ViewInfo);
end;

procedure TdxChartDiagramCustomViewInfo.CalculateViews(ACanvas: TcxCustomCanvas);
var
  I: Integer;
begin
  Items.Clear;
  for I := 0 to SeriesCount - 1 do
    if Series[I].ActuallyVisible then
      CalculateView(Series[I].View, ACanvas)
    else
      Series[I].View.ViewInfo.Visible := False;
end;

function TdxChartDiagramCustomViewInfo.AdjustPlotAreaByLabelsBounding(ACanvas: TcxCustomCanvas): Boolean;
begin
  Result := False;
end;

procedure TdxChartDiagramCustomViewInfo.DoCalculate(ACanvas: TcxCustomCanvas);
var
  I: Integer;
  AContentRect: TdxRectF;
begin
  Legend.Clear;
  for I := 0 to Diagram.SeriesCount - 1 do
    Diagram.Series[I].PopulateLegend(Legend, TdxChartSeriesShowInLegend.Diagram);
  AContentRect := GetContentRect;
  Title.CalculateAndAdjustContent(ACanvas, AContentRect);
  if IsOutsideLegend then
    Legend.CalculateAndAdjustContent(ACanvas, AContentRect);
  SetPlotArea(AContentRect);
  ResetLabelsBoundingRect;
  CalculateViews(ACanvas);
  if IsLabelsOutsideOfPlotArea and AdjustPlotAreaByLabelsBounding(ACanvas) then
    CalculateViews(ACanvas);

  if not IsOutsideLegend then
    Legend.CalculateAndAdjustContent(ACanvas, FPlotArea);
end;

procedure TdxChartDiagramCustomViewInfo.DoDraw(ACanvas: TcxCustomCanvas);
begin
  inherited DoDraw(ACanvas);
  Title.ViewInfo.Draw(ACanvas);
  DrawChart(ACanvas);
end;

procedure TdxChartDiagramCustomViewInfo.DrawChart(ACanvas: TcxCustomCanvas);
begin
  Items.Draw(ACanvas);
  DrawValuesLabels(ACanvas);
end;

procedure TdxChartDiagramCustomViewInfo.DrawValuesLabels(ACanvas: TcxCustomCanvas);
var
  I: Integer;
begin
  for I := 0 to SeriesCount - 1 do
    Series[I].View.ViewInfo.DoDrawLabels(ACanvas);
end;

procedure TdxChartDiagramCustomViewInfo.EnableExportMode(AEnable: Boolean);
var
  I: Integer;
begin
  inherited EnableExportMode(AEnable);
  for I := 0 to SeriesCount - 1 do
    Series[I].View.ViewInfo.EnableExportMode(AEnable);
end;

function TdxChartDiagramCustomViewInfo.GetHitElement(const P: TdxPointF): IdxChartHitTestElement;
var
  I: Integer;
begin
  for I := FItems.Count - 1 downto 0 do
  begin
    Result := FItems[I].GetHitElement(P);
    if Result <> nil then
      Break;
  end;
  if Result = nil then
    Result := TdxChartComponentHitElement.Create(Diagram, TdxChartHitCode.Diagram);
end;

function TdxChartDiagramCustomViewInfo.HasZeroBasedSeries: Boolean;
begin
  Result := False;
end;

function TdxChartDiagramCustomViewInfo.IsLabelsOutsideOfPlotArea: Boolean;
begin
  Result := FLabelsBoundingRect <> FPlotArea;
end;

function TdxChartDiagramCustomViewInfo.IsOutsideLegend: Boolean;
begin
  Result := (Legend.AlignmentHorz in LegendOutsideAlignments) or (Legend.AlignmentVert in LegendOutsideAlignments);
end;

procedure TdxChartDiagramCustomViewInfo.ResetLabelsBoundingRect;
begin
  FLabelsBoundingRect := FPlotArea;
end;

procedure TdxChartDiagramCustomViewInfo.SetPlotArea(const ARect: TdxRectF);
begin
  FPlotArea := ARect.DeflateToTRect;
end;

{ TdxChartWeakReferenceHitElement }

constructor TdxChartWeakReferenceHitElement.Create(AObject: TObject; AHitCode: TdxChartHitCode; ASubAreaCode: Integer = 0);
begin
  inherited Create;
  FObjectLink := cxAddObjectLink(AObject);
  FHitCode := AHitCode;
  FSubAreaCode := ASubAreaCode;
end;

destructor TdxChartWeakReferenceHitElement.Destroy;
begin
  cxRemoveObjectLink(FObjectLink);
  inherited Destroy;
end;

function TdxChartWeakReferenceHitElement.GetChartElement: TObject;
begin
  Result := FObjectLink.Ref;
end;

function TdxChartWeakReferenceHitElement.GetHitCode: TdxChartHitCode;
begin
  Result := FHitCode;
end;

function TdxChartWeakReferenceHitElement.GetSubAreaCode: Integer;
begin
  Result := FSubAreaCode;
end;

{ TdxComponentReference }

constructor TdxComponentReference<T>.Create(AObject: T);
begin
  inherited Create;
  FObject := AObject;
  FFreeNotificator := TcxFreeNotificator.Create(nil);
  FFreeNotificator.OnFreeNotification := FreeNotificatorHandler;
  FObject.FreeNotification(FFreeNotificator);
end;

destructor TdxComponentReference<T>.Destroy;
begin
  if FObject <> nil then
    FObject.RemoveFreeNotification(FFreeNotificator);
  FreeAndNil(FFreeNotificator);
  inherited Destroy;
end;

procedure TdxComponentReference<T>.DoObjectRemoved;
begin
  FObject := nil;
end;

procedure TdxComponentReference<T>.FreeNotificatorHandler(Sender: TComponent);
begin
  DoObjectRemoved;
end;

{ TdxChartComponentHitElement }

constructor TdxChartComponentHitElement.Create(AObject: TComponent; AHitCode: TdxChartHitCode; ASubAreaCode: Integer = 0);
begin
  inherited Create(AObject);
  FHitCode := AHitCode;
  FSubAreaCode := ASubAreaCode;
end;

function TdxChartComponentHitElement.GetChartElement: TObject;
begin
  Result := FObject;
end;

function TdxChartComponentHitElement.GetHitCode: TdxChartHitCode;
begin
  Result := FHitCode;
end;

function TdxChartComponentHitElement.GetSubAreaCode: Integer;
begin
  Result := FSubAreaCode;
end;

{ TdxChartComponentDependentHitElement }

constructor TdxChartComponentDependentHitElement.Create(AHitObject: TObject; AOwnsObject: Boolean; AComponent: TComponent;
                           AHitCode: TdxChartHitCode; ASubAreaCode: Integer = 0);
begin
  inherited Create(AComponent);
  FHitObject := AHitObject;
  FHitCode := AHitCode;
  FOwnsObject := AOwnsObject;
  FSubAreaCode := ASubAreaCode;
end;

destructor TdxChartComponentDependentHitElement.Destroy;
begin
  if FOwnsObject then
    FreeAndNil(FHitObject);
  inherited Destroy;
end;

procedure TdxChartComponentDependentHitElement.DoObjectRemoved;
begin
  inherited DoObjectRemoved;
  if FOwnsObject then
    FHitObject.Free;
  FHitObject := nil;
end;

function TdxChartComponentDependentHitElement.GetChartElement: TObject;
begin
  Result := FHitObject;
end;

function TdxChartComponentDependentHitElement.GetHitCode: TdxChartHitCode;
begin
  Result := FHitCode;
end;

function TdxChartComponentDependentHitElement.GetSubAreaCode: Integer;
begin
  Result := FSubAreaCode;
end;

{ TdxChartSeriesPointInfo }

constructor TdxChartSeriesPointInfo.Create(AValueViewInfo: TdxChartSeriesValueViewInfo);
begin
  inherited Create;
  FValueViewInfo := AValueViewInfo;
end;

function TdxChartSeriesPointInfo.Equals(Obj: TObject): Boolean;
var
  APoint: TdxChartSeriesPointInfo;
begin
  if Safe.Cast(Obj, TdxChartSeriesPointInfo, APoint) then
    Result := FValueViewInfo = APoint.FValueViewInfo
  else
    Result := False;
end;

function TdxChartSeriesPointInfo.GetArgument: Variant;
begin
  if FValueViewInfo.&Record = nil then
    Result := Unassigned
  else
    Result := FValueViewInfo.&Record.Value[FValueViewInfo.ViewData.ArgumentField];
end;

function TdxChartSeriesPointInfo.GetArgumentDisplayText: string;
var
  AField: TdxStorageItem;
begin
  AField := FValueViewInfo.ViewData.ArgumentField;
  if (FValueViewInfo.&Record = nil) or (AField.ValueTypeClass.IsString) then
    Result := ''
  else
    Result := FValueViewInfo.&Record.DisplayText[AField];
end;

function TdxChartSeriesPointInfo.GetIndex: Integer;
begin
  if FValueViewInfo.&Record = nil then
    Result := -1
  else
    Result := FValueViewInfo.&Record.Index;
end;

function TdxChartSeriesPointInfo.GetSeries: TdxChartCustomSeries;
begin
  Result := FValueViewInfo.Owner.Series;
end;

function TdxChartSeriesPointInfo.GetValue: Variant;
begin
  if FValueViewInfo.&Record = nil then
    Result := FValueViewInfo.Value
  else
    Result := FValueViewInfo.&Record.Value[FValueViewInfo.ViewData.ValueField];
end;

function TdxChartSeriesPointInfo.GetValueDisplayText: string;
var
  AField: TdxStorageItem;
begin
  AField := FValueViewInfo.ViewData.ValueField;
  if (FValueViewInfo.&Record = nil) or (AField.ValueTypeClass.IsString) then
    Result := ''
  else
    Result := FValueViewInfo.&Record.DisplayText[AField];
end;

{ TdxChartSeriesValueLabelInfo }

constructor TdxChartSeriesValueLabelInfo.Create(APointInfo: TdxChartSeriesPointInfo; const AText: string);
begin
  inherited Create;
  FSeriesPoint := APointInfo;
  FText := AText;
end;

destructor TdxChartSeriesValueLabelInfo.Destroy;
begin
  FreeAndNil(FSeriesPoint);
  inherited Destroy;
end;

function TdxChartSeriesValueLabelInfo.Equals(Obj: TObject): Boolean;
var
  AHitLabel: TdxChartSeriesValueLabelInfo;
begin
  Result := Safe.Cast(Obj, TdxChartSeriesValueLabelInfo, AHitLabel) and
            SeriesPoint.Equals(AHitLabel.SeriesPoint) and (Text = AHitLabel.Text);
end;

{ TdxChartDiagramToolTipOptions }

destructor TdxChartDiagramToolTipOptions.Destroy;
begin
  TdxChartTextFormatController.Release(FPointToolTipFormatter);
  TdxChartTextFormatController.Release(FSeriesToolTipFormatter);
  inherited Destroy;
end;

procedure TdxChartDiagramToolTipOptions.DoAssign(Source: TPersistent);
var
  ASourceOptions: TdxChartDiagramToolTipOptions;
begin
  inherited DoAssign(Source);
  if Safe.Cast(Source, TdxChartDiagramToolTipOptions, ASourceOptions) then
  begin
    PointToolTipFormat := ASourceOptions.PointToolTipFormat;
    SeriesToolTipFormat := ASourceOptions.SeriesToolTipFormat;
  end;
end;

function TdxChartDiagramToolTipOptions.GetPointToolTipFormat: TdxChartTextFormat;
begin
  Result := TdxChartTextFormatController.GetFormat(FPointToolTipFormatter);
end;

function TdxChartDiagramToolTipOptions.GetSeriesToolTipFormat: TdxChartTextFormat;
begin
  Result := TdxChartTextFormatController.GetFormat(FSeriesToolTipFormatter);
end;

procedure TdxChartDiagramToolTipOptions.SetPointToolTipFormat(const Value: TdxChartTextFormat);
begin
  if Value = '' then
    TdxChartTextFormatController.Release(FPointToolTipFormatter)
  else
    TdxChartTextFormatController.Add(Value, FPointToolTipFormatter);
end;

procedure TdxChartDiagramToolTipOptions.SetSeriesToolTipFormat(const Value: TdxChartTextFormat);
begin
  if Value = '' then
    TdxChartTextFormatController.Release(FSeriesToolTipFormatter)
  else
    TdxChartTextFormatController.Add(Value, FSeriesToolTipFormatter);
end;

{ TdxChartDiagramAppearance }

function TdxChartDiagramAppearance.GetActualColor(AIndex: Integer): TdxAlphaColor;
begin
  case AIndex of
    BorderColorIndex:
      Result := ColorScheme.DiagramXY.BorderColor;
    ColorIndex:
      Result := ColorScheme.DiagramXY.AxisColor;
    TextColorIndex:
      Result := ColorScheme.DiagramXY.TextColor;
  else
    Result := inherited GetActualColor(AIndex);
  end;
end;

function TdxChartDiagramAppearance.HasFillOptions: Boolean;
begin
  Result := True;
end;

{ TdxChartGetValueLabelDrawParametersEventArgs }

constructor TdxChartGetValueLabelDrawParametersEventArgs.Create(ASeriesPoint: TdxChartSeriesPointInfo;
  const AText: string);
begin
  inherited Create;
  FSeriesPoint := ASeriesPoint;
  FText := AText;
end;

destructor TdxChartGetValueLabelDrawParametersEventArgs.Destroy;
begin
  FreeAndNil(FSeriesPoint);
  inherited Destroy;
end;


{ TdxChartCustomDiagram }

constructor TdxChartCustomDiagram.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAppearance := CreateAppearance;
  FSeries := TdxFastObjectList.Create(False);
  FViewData := CreateViewData;
  FViewInfo := CreateViewInfo;
  FLegend := CreateLegend;
  FTitle := CreateTitle;
  FViewInfo.TopmostItems.Add(FLegend.ViewInfo);
  FToolTips := CreateToolTipOptions;
  FVisible := True;
end;

destructor TdxChartCustomDiagram.Destroy;
begin
  FreeAndNil(FToolTips);
  FLegend.Clear;
  SetChart(nil);
  DeleteAllSeries;
  FreeAndNil(FSeries);
  FreeAndNil(FLegend);
  FreeAndNil(FTitle);
  FreeAndNil(FViewInfo);
  FreeAndNil(FViewData);
  FreeAndNil(FAppearance);
  inherited Destroy;
end;

procedure TdxChartCustomDiagram.Assign(Source: TPersistent);
begin
  if Source is TdxChartCustomDiagram then
    AssignFrom(TdxChartCustomDiagram(Source), False)
  else
    inherited Assign(Source);
end;

procedure TdxChartCustomDiagram.DeleteAllSeries;
begin
  BeginUpdate;
  try
    dxClearComponentList(FSeries);
  finally
    EndUpdate;
  end;
end;

procedure TdxChartCustomDiagram.GetChildren(Proc: TGetChildProc; Root: TComponent);

  procedure DoStore(ASeries: TdxChartCustomSeries);
  begin
    if ASeries.Owner = Root then
      Proc(ASeries);
  end;

var
  I: Integer;
begin
  inherited GetChildren(Proc, Root);
  for I := 0 to SeriesCount - 1 do
    DoStore(SeriesList[I] as TdxChartCustomSeries);
end;

function TdxChartCustomDiagram.GetParentComponent: TComponent;
begin
  if Chart = nil then
    Result := nil
  else
    Result := Chart.OwnerComponent;
end;

function TdxChartCustomDiagram.HasParent: Boolean;
begin
  Result := True;
end;

procedure TdxChartCustomDiagram.SetParentComponent(Value: TComponent);
var
  AChartOwner: IdxChartOwner;
begin
  if Supports(Value, IdxChartOwner, AChartOwner) then
    SetChart(AChartOwner.GetChart)
  else
    SetChart(nil);
end;

function TdxChartCustomDiagram.ActuallyVisible: Boolean;
begin
  Result := Visible and (Chart <> nil);
end;

function TdxChartCustomDiagram.AddSeries(const ACaption: string = ''): TdxChartCustomSeries;
begin
  Result := GetSeriesClass.Create(Chart.GetRootOwner);
  Result.SetParentComponent(Self);
  Result.Name := CreateUniqueName(Chart.GetOwnerForm, Chart.GetOwnerComponent, Result, 'TdxChart', '');
  if ACaption <> '' then
    Result.Caption := ACaption;
  Result.DataBindingType := 'Unbound';
end;

procedure TdxChartCustomDiagram.AddSeries(ASeries: TdxChartCustomSeries);
begin
  SeriesList.Add(ASeries);
  if Chart <> nil then
    ASeries.AddToChart(Chart);
  ASeries.View.Appearance.Parent := Appearance;
  Changed(TdxChartCustomDiagram.TDiagramChange.Series);
end;

procedure TdxChartCustomDiagram.AddSeriesToChart(AChart: TdxChart);
var
  I: Integer;
begin
  for I := 0 to SeriesCount - 1 do
    Series[I].AddToChart(AChart);
end;

procedure TdxChartCustomDiagram.AssignFrom(
  ASource: TdxChartCustomDiagram; ARecreate: Boolean = True; AStoreList: TdxFastObjectList = nil);
begin
  if not  ASource.InheritsFrom(ClassType) then
    raise EdxChartException.CreateFmt('It is impossible to assign a class (%s) value to a variable of the (%s) type !', [ASource.ClassName, Self.ClassName]);
  BeginUpdate;
  try
    if ARecreate then
    begin
      dxSafeCloneComponentList(ASource.SeriesList, Chart.GetOwnerForm, Chart.GetRootOwner,
        procedure(ASource, AClone: TComponent)
        var
          AIntf: IdxChartCloneComponent;
        begin
          TdxChartCustomSeries(AClone).SetDiagram(Self);
          if Supports(AClone, IdxChartCloneComponent, AIntf) then
            AIntf.SetSource(ASource);
        end, AStoreList);

    end;
    SeriesList := ASource.SeriesList;
    Title := ASource.Title;
    Legend := ASource.Legend;
    Appearance := ASource.Appearance;
    Visible := ASource.Visible;
    ToolTips.Assign(ASource.ToolTips);
  finally
    EndUpdate;
  end;    
end;

procedure TdxChartCustomDiagram.Changed(AChanges: TDiagramChanges);
begin
  Changes := Changes + AChanges;
  if Changes <> [] then
    inherited Changed;
end;

procedure TdxChartCustomDiagram.BiDiModeChanged;
var
  I: Integer;
begin
  Legend.BiDiModeChanged;
  Title.BiDiModeChanged;
  for I := 0 to SeriesCount - 1 do
    Series[I].BiDiModeChanged;
end;

procedure TdxChartCustomDiagram.Changed(AChange: TDiagramChange);
begin
  Changed([AChange]);
end;

procedure TdxChartCustomDiagram.ChangeScale(M, D: Integer);
var
  I: Integer;
begin
  Legend.ChangeScale(M, D);
  for I := 0 to SeriesCount - 1 do
    Series[I].ChangeScale(M, D);
end;

function TdxChartCustomDiagram.CreateAppearance: TdxChartDiagramAppearance;
begin
  Result := TdxChartDiagramAppearance.Create(Self);
end;

function TdxChartCustomDiagram.CreateLegend: TdxChartDiagramLegend;
begin
  Result := TdxChartDiagramLegend.Create(Self);
end;

function TdxChartCustomDiagram.CreateTitle: TdxChartDiagramTitle;
begin
  Result := TdxChartDiagramTitle.Create(Self);
end;

function TdxChartCustomDiagram.CreateViewData: TdxChartDiagramCustomViewData;
begin
  Result := TdxChartDiagramCustomViewData.Create(Self);
end;

function TdxChartCustomDiagram.CreateViewInfo: TdxChartDiagramCustomViewInfo;
begin
  Result := TdxChartDiagramCustomViewInfo.Create(Self);
end;

procedure TdxChartCustomDiagram.DoChanged;
var
  I: Integer;
begin
  if TDiagramChange.Series in Changes then
  begin
    ViewData.MakeDirty;
    for I := 0 to SeriesCount - 1 do
      Series[I].View.ViewInfo.Dirty := True;
  end;
  ViewInfo.Dirty := ViewInfo.Dirty or (Changes <> [TDiagramChange.Style]);
  for I := 0 to ViewInfo.MutableItems.Count - 1 do
    ViewInfo.MutableItems[I].Dirty := ViewInfo.MutableItems[I].Dirty or (Changes <> [TDiagramChange.Style]);
  if (TDiagramChange.Visible in Changes) and (Chart <> nil) then
    Chart.DiagramsChanged
  else
    if ActuallyVisible then
    begin
      if Changes = [TDiagramChange.Style] then
        Invalidate
      else
        Chart.Changed(TdxChart.TChartChange.Layout);
    end;
end;

procedure TdxChartCustomDiagram.DoGetValueLabelDrawParameters(AArgs: TdxChartGetValueLabelDrawParametersEventArgs);
begin
  if Assigned(OnGetValueLabelDrawParameters) then
    OnGetValueLabelDrawParameters(Self, AArgs);
end;

procedure TdxChartCustomDiagram.Invalidate;
begin
  if ActuallyVisible then
    Chart.InvalidateRect(ViewInfo.ClipRect);
end;

function TdxChartCustomDiagram.IsCompatibleWith(ASeries: TdxChartCustomSeries): Boolean;
begin
  Result := ASeries.InheritsFrom(GetSeriesClass);
end;

procedure TdxChartCustomDiagram.RemoveSeries(ASeries: TdxChartCustomSeries);
begin
  Legend.DataChanged();
  SeriesList.Remove(ASeries);
  if Chart <> nil then
    ASeries.RemoveFromChart(Chart);
  ASeries.View.Appearance.Parent := nil;
  Changed(TDiagramChange.Series);
end;

procedure TdxChartCustomDiagram.RemoveSeriesFromChart(AChart: TdxChart);
var
  I: Integer;
begin
  AChart.Legend.DataChanged();
  for I := 0 to SeriesCount - 1 do
    Series[I].RemoveFromChart(AChart);
end;

{
procedure TdxChartCustomDiagram.SetChart(AValue: TdxChart);
begin
  if AValue = Chart then
    Exit;
  if Chart <> nil then
  begin
    Chart.RemoveDiagram(Self);
    RemoveSeriesFromChart(Chart);
  end;
  FChart := AValue;
  if Chart <> nil then
  begin
    Chart.AddDiagram(Self);
    AddSeriesToChart(Chart);
    Appearance.SetParent(AValue.Appearance);
  end;
end;   }

procedure TdxChartCustomDiagram.SetChart(AValue: TdxChart);
begin
  if AValue = Chart then
    Exit;
  Appearance.Parent := nil;
  if Chart <> nil then
  begin
    RemoveSeriesFromChart(Chart);
    Chart.RemoveDiagram(Self);
  end;
  FChart := AValue;
  if Chart <> nil then
  begin
    Chart.AddDiagram(Self);
    AddSeriesToChart(Chart);
    Appearance.Parent := AValue.Appearance;
  end;
end;


procedure TdxChartCustomDiagram.SetName(const NewName: TComponentName);
begin
  inherited SetName(NewName);
  Changed(TDiagramChange.Layout);
end;

function TdxChartCustomDiagram.GetAppearance: TdxChartVisualElementAppearance;
begin
  Result := Appearance;
end;

function TdxChartCustomDiagram.GetChart: TdxChart;
begin
  Result := Chart;
end;

function TdxChartCustomDiagram.GetIndex: Integer;
begin
  Result := -1;
  if Chart <> nil then
    Result := Chart.DiagramList.IndexOf(Self);
end;

function TdxChartCustomDiagram.GetParentElement: IdxChartVisualElement;
begin
  Result := Chart;
end;

function TdxChartCustomDiagram.GetSeries(AIndex: Integer): TdxChartCustomSeries;
begin
  Result := TdxChartCustomSeries(SeriesList.List[AIndex]);
end;

function TdxChartCustomDiagram.GetSeriesCount: Integer;
begin
  Result := SeriesList.Count;
end;

function TdxChartCustomDiagram.GetSource: TObject;
begin
  Result := FSource;
end;

function TdxChartCustomDiagram.GetVisibleSeries(AIndex: Integer): TdxChartCustomSeries;
begin
  ViewData.Calculate;
  Result := ViewData.Series[AIndex];
end;

function TdxChartCustomDiagram.GetVisibleSeriesCount: Integer;
begin
  ViewData.Calculate;
  Result := ViewData.SeriesCount;
end;

procedure TdxChartCustomDiagram.LayoutChanged;
begin
  Changed(TDiagramChange.Layout);
end;

procedure TdxChartCustomDiagram.SetAppearance(AValue: TdxChartDiagramAppearance);
begin
  Appearance.Assign(AValue);
end;

procedure TdxChartCustomDiagram.SetIndex(AValue: Integer);
begin
  if Chart = nil then
    Exit;
  AValue := Min(Chart.DiagramCount - 1, Max(0, AValue));
  if AValue <> Index then
  begin
    Chart.DiagramList.Move(Index, AValue);
    if Visible then
      Chart.DiagramsChanged;
  end;
end;

procedure TdxChartCustomDiagram.SetLegend(AValue: TdxChartDiagramLegend);
begin
  Legend.Assign(AValue);
end;

procedure TdxChartCustomDiagram.SetTitle(AValue: TdxChartDiagramTitle);
begin
  Title.Assign(AValue);
end;

procedure TdxChartCustomDiagram.SetSeriesList(AValue: TdxFastObjectList);
var
  I: Integer;
begin
  for I := 0 to SeriesCount - 1 do
  begin
    TPersistent(SeriesList[I]).Assign(AValue[I] as TPersistent);
    TdxChartCustomSeries(SeriesList[I]).UpdateColorSchemeIndexFromSeries(TdxChartCustomSeries(AValue[I]));
  end;
end;

procedure TdxChartCustomDiagram.SetSource(AValue: TObject);
begin
  FSource := AValue;
end;

procedure TdxChartCustomDiagram.SetVisible(AValue: Boolean);
begin
  if FVisible <> AValue then
  begin
    FVisible := AValue;
    if Chart <> nil then
      Chart.DiagramsChanged;
  end;
end;

procedure TdxChartCustomDiagram.StyleChanged;
begin
  Changed(TDiagramChange.Style)
end;

procedure TdxChartCustomDiagram.TextColorChanged;
begin
  StyleChanged;
end;

{ TdxChartViewInfo }

constructor TdxChartViewInfo.Create(AOwner: TdxChart);
begin
  inherited Create(AOwner.Appearance);
  FChart := AOwner;
  FItems := TdxChartItemsViewInfoList.Create(False);
  FOverlays := TdxChartItemsViewInfoList.Create(False);
end;

destructor TdxChartViewInfo.Destroy;
begin
  FreeAndNil(FItems);
  FreeAndNil(FOverlays);
  inherited Destroy;
end;

function TdxChartViewInfo.CalculateHitTest(AHitTest: TdxChartHitTestEngine; const P: TdxPointF): Boolean;
var
  I: Integer;
begin
  Result := inherited CalculateHitTest(AHitTest, P);
  if not Result then
    Exit;
  for I := 0 to Items.Count - 1 do
    if Items[I].CalculateHitTest(AHitTest, P) then
      Break;
end;

procedure TdxChartViewInfo.CalculateLegend(ACanvas: TcxCustomCanvas);
var
  ADiagram: TdxChartCustomDiagram;
  I, J: Integer;
begin
  if not Legend.Visible then
  begin
    Legend.ViewInfo.Visible := False;
    Exit;
  end;
  if Legend.ViewData.Dirty then
  begin
    Legend.Clear;
    for I := 0 to Chart.DiagramCount - 1 do
    begin
      ADiagram := Chart.Diagrams[I];
      if ADiagram.Visible then
      begin
        for J := 0 to ADiagram.SeriesCount - 1 do
          ADiagram.Series[J].PopulateLegend(Legend, TdxChartSeriesShowInLegend.Chart);
      end;
    end;
    Legend.ViewData.Calculate;
  end;
  Legend.CalculateAndAdjustContent(ACanvas, FDiagramsArea);
end;

procedure TdxChartViewInfo.CalculateTitles(ACanvas: TcxCustomCanvas);
const
  PositionByCalculateOrderMap: array[TdxChartTitlePosition] of TdxChartTitlePosition = (
    TdxChartTitlePosition.Top, TdxChartTitlePosition.Top, TdxChartTitlePosition.Bottom,
    TdxChartTitlePosition.Left, TdxChartTitlePosition.Right
  );
var
  APosition: TdxChartTitlePosition;
  ATitle: TdxChartVisualElementTitle;
  I: Integer;
begin
  if Titles.GetVisibleCount = 0 then
    Exit;
  for APosition := TdxChartTitlePosition.Left to TdxChartTitlePosition.Bottom do
    for I := 0 to Chart.Titles.Count - 1 do
    begin
      ATitle := Titles[I].Title;
      if ATitle.ActuallyVisible and ATitle.SamePosition(PositionByCalculateOrderMap[APosition]) then
      begin
        ATitle.CalculateAndAdjustContent(ACanvas, FDiagramsArea);
        Items.Add(ATitle.ViewInfo);
      end;
  end;
end;

procedure TdxChartViewInfo.DiscardCachedImage;
begin
  FIsCachedImageValid := False;
end;

procedure TdxChartViewInfo.DoCalculate(ACanvas: TcxCustomCanvas);
var
  R: TdxRectF;
  I: Integer;
  ADiagram: TdxChartCustomDiagram;
begin
  Items.Count := 0;
  Overlays.Count := 0;
  FDiagramsArea := ContentBounds;
  CalculateTitles(ACanvas);
  for I := 0 to Chart.VisibleDiagramCount - 1 do
    Chart.VisibleDiagrams[I].ViewData.Calculate;
  //
  CalculateLegend(ACanvas);
  R := DiagramsArea;
  for I := 0 to Chart.VisibleDiagramCount - 1 do
  begin
    ADiagram := Chart.VisibleDiagrams[I];
    R.Top := DiagramsArea.Top + I * DiagramsArea.Height / Chart.VisibleDiagramCount;
    R.Bottom := DiagramsArea.Top + (I + 1) * DiagramsArea.Height / Chart.VisibleDiagramCount;
    ADiagram.ViewInfo.SetBounds(R.Content(ADiagram.Appearance.ActualMargins), R);
    Items.Add(ADiagram.ViewInfo);
    if not FIsExportMode then
      Overlays.AddRange(ADiagram.ViewInfo.MutableItems);
    Overlays.AddRange(ADiagram.ViewInfo.TopmostItems);
  end;
  Items.Calculate(ACanvas);
  Items.Add(Legend.ViewInfo);
end;

procedure TdxChartViewInfo.DoDraw(ACanvas: TcxCustomCanvas);

  procedure DrawCrosshairLayer(ALayer: TdxChartCrosshairLayer);
  var
    AViewInfoList: TdxChartItemsViewInfoList;
  begin
    if FIsExportMode then
      Exit;
    AViewInfoList := FChart.CrosshairController.GetCrosshairViewInfos(ALayer);
    AViewInfoList.Draw(ACanvas);
  end;

var
  I: Integer;
begin
  Calculate(ACanvas);
    inherited DoDraw(ACanvas);
    Items.Draw(ACanvas);
    FIsCachedImageValid := True;

  DrawCrosshairLayer(TdxChartCrosshairLayer.AboveMarkers);

  for I := 0 to Items.Count - 1 do
    if Items[I] is TdxChartXYDiagramViewInfo then
      TdxChartXYDiagramViewInfo(Items[I]).DrawSecondLayer(ACanvas);

  DrawCrosshairLayer(TdxChartCrosshairLayer.BelowLegend);
  Overlays.Draw(ACanvas);
  DrawCrosshairLayer(TdxChartCrosshairLayer.AboveLegend);

end;

function TdxChartViewInfo.GetHitElement(const P: TdxPointF): IdxChartHitTestElement;
var
  AOwnerComponent: TComponent;
begin
  AOwnerComponent := Chart.GetOwnerComponent;
  if AOwnerComponent <> nil then
    Result := TdxChartComponentHitElement.Create(AOwnerComponent, TdxChartHitCode.Chart);
end;

function TdxChartViewInfo.GetLegend: TdxChartLegend;
begin
  Result := Chart.Legend;
end;

function TdxChartViewInfo.GetTitles: TdxChartTitles;
begin
  Result := Chart.Titles;
end;

{ TdxChartAppearance }

function TdxChartAppearance.GetChart: TdxChart;
begin
  Result := TdxChart(inherited Owner);
end;

function TdxChartAppearance.GetOwner: TPersistent;
begin
  if Chart.OwnerComponent <> nil then
    Result := Chart.OwnerComponent
  else
    Result := Chart;
end;

function TdxChartAppearance.HasFillOptions: Boolean;
begin
  Result := True;
end;

function TdxChartAppearance.HasFontOptions: Boolean;
begin
  Result := True;
end;

{ TdxChartMouseAction }

constructor TdxChartMouseAction.Create(AOwner: TPersistent;
  AMouseButton: TMouseButton; AModifierKeys: TdxModifierKeys);
begin
  inherited Create(AOwner);
  FDefaultMouseButton := AMouseButton;
  FMouseButton := AMouseButton;
  FDefaultModifierKeys := AModifierKeys;
  FModifierKeys := AModifierKeys;
  FEnabled := True;
end;

procedure TdxChartMouseAction.DoAssign(ASource: TPersistent);
var
  ASourceMouseAction: TdxChartMouseAction;
begin
  inherited;
  if ASource is TdxChartMouseAction then
  begin
    ASourceMouseAction := TdxChartMouseAction(ASource);
    Enabled := ASourceMouseAction.Enabled;
    MouseButton := ASourceMouseAction.MouseButton;
    ModifierKeys := ASourceMouseAction.ModifierKeys;
  end;
end;

function TdxChartMouseAction.IsModifierKeysStored: Boolean;
begin
  Result := FModifierKeys <> FDefaultModifierKeys;
end;

function TdxChartMouseAction.IsMouseButtonStored: Boolean;
begin
  Result := FMouseButton <> FDefaultMouseButton;
end;

{ TdxChartMouseWheelAction }

constructor TdxChartMouseWheelAction.Create(AOwner: TPersistent;
  AModifierKeys: TdxModifierKeys);
begin
  inherited Create(AOwner);
  FModifierKeys := AModifierKeys;
  FDefaultModifierKeys := AModifierKeys;
  FEnabled := True;
end;

procedure TdxChartMouseWheelAction.DoAssign(ASource: TPersistent);
var
  ASourceMouseWheelUsage: TdxChartMouseWheelAction;
begin
  inherited;
  if ASource is TdxChartMouseWheelAction then
  begin
    ASourceMouseWheelUsage := TdxChartMouseWheelAction(ASource);
    Enabled := ASourceMouseWheelUsage.Enabled;
    ModifierKeys := ASourceMouseWheelUsage.ModifierKeys;
  end;
end;

function TdxChartMouseWheelAction.IsModifierKeysStored: Boolean;
begin
  Result := FModifierKeys <> FDefaultModifierKeys;
end;

{ TdxChartZoomingOptions }

constructor TdxChartZoomOptions.Create(AOwner: TPersistent);
begin
  inherited;
  FZoomInMouseAction := TdxChartMouseAction.Create(Self, mbLeft, [TdxModifierKey.Shift]);
  FZoomOutMouseAction := TdxChartMouseAction.Create(Self, mbLeft, [TdxModifierKey.Alt]);
  FMarqueeZoomMouseAction := TdxChartMouseAction.Create(Self, mbRight, []);
  FZoomMouseWheelAction := TdxChartMouseWheelAction.Create(Self, [TdxModifierKey.Ctrl]);
  FSmallStep := DefaultSmallStep;
  FLargeStep := DefaultLargeStep;
end;

destructor TdxChartZoomOptions.Destroy;
begin
  FreeAndNil(FZoomOutMouseAction);
  FreeAndNil(FZoomInMouseAction);
  FreeAndNil(FMarqueeZoomMouseAction);
  FreeAndNil(FZoomMouseWheelAction);
  inherited;
end;

procedure TdxChartZoomOptions.DoAssign(ASource: TPersistent);
var
  ASourceOptions: TdxChartZoomOptions;
begin
  inherited;
  if ASource is TdxChartZoomOptions then
  begin
    ASourceOptions := TdxChartZoomOptions(ASource);
    ZoomInMouseAction := ASourceOptions.ZoomInMouseAction;
    ZoomOutMouseAction := ASourceOptions.ZoomOutMouseAction;
    MarqueeZoomMouseAction := ASourceOptions.MarqueeZoomMouseAction;
    ZoomMouseWheelAction := ASourceOptions.ZoomMouseWheelAction;
  end;
end;

function TdxChartZoomOptions.IsLargeStepStored: Boolean;
begin
  Result := FLargeStep <> DefaultLargeStep;
end;

function TdxChartZoomOptions.IsSmallStepStored: Boolean;
begin
  Result := FSmallStep <> DefaultSmallStep;
end;

procedure TdxChartZoomOptions.SetLargeStep(AValue: Single);
begin
  if AValue < 0.01 then
    AValue := 0.01;
  FLargeStep := AValue;
end;

procedure TdxChartZoomOptions.SetSmallStep(AValue: Single);
begin
  if AValue < 0.01 then
    AValue := 0.01;
  FSmallStep := AValue;
end;

procedure TdxChartZoomOptions.SetZoomMouseWheelAction(AValue: TdxChartMouseWheelAction);
begin
  FZoomMouseWheelAction.Assign(AValue);
end;

procedure TdxChartZoomOptions.SetZoomInMouseAction(AValue: TdxChartMouseAction);
begin
  FZoomInMouseAction.Assign(AValue);
end;

procedure TdxChartZoomOptions.SetZoomOutMouseAction(AValue: TdxChartMouseAction);
begin
  FZoomOutMouseAction.Assign(AValue);
end;

procedure TdxChartZoomOptions.SetMarqueeZoomMouseAction(AValue: TdxChartMouseAction);
begin
  FMarqueeZoomMouseAction.Assign(AValue);
end;

{ TdxChartScrollOptions }

constructor TdxChartScrollOptions.Create(AOwner: TPersistent);
begin
  inherited;
  FScrollMouseWheelAction := TdxChartMouseWheelAction.Create(Self, []);
  FPanMouseAction := TdxChartMouseAction.Create(Self, mbLeft, []);
  FScrollBars := True;
end;

destructor TdxChartScrollOptions.Destroy;
begin
  FreeAndNil(FPanMouseAction);
  FreeAndNil(FScrollMouseWheelAction);
  inherited;
end;

procedure TdxChartScrollOptions.DoAssign(ASource: TPersistent);
var
  ASourceOptions: TdxChartScrollOptions;
begin
  inherited;
  if ASource is TdxChartScrollOptions then
  begin
    ASourceOptions := TdxChartScrollOptions(ASource);
    PanMouseAction := ASourceOptions.PanMouseAction;
    ScrollMouseWheelAction := ASourceOptions.ScrollMouseWheelAction;
    ScrollBars := ASourceOptions.ScrollBars;
  end;
end;

procedure TdxChartScrollOptions.SetPanMouseAction(AValue: TdxChartMouseAction);
begin
  FPanMouseAction.Assign(AValue);
end;

procedure TdxChartScrollOptions.SetScrollMouseWheelAction(
  const Value: TdxChartMouseWheelAction);
begin
  FScrollMouseWheelAction := Value;
end;

{ TdxChart }

constructor TdxChart.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  Supports(AOwner, IdxChartOwner, FOwnerControl);
  FUseThreading := bDefault;
  CreateSubClasses;
  ColorSchemeName := TdxChartColorSchemeRepository.DefaultName;
  TdxChartTextFormatController.FormatController.ChangeHandler.Add(FormatChanged);
end;

destructor TdxChart.Destroy;
begin
  DestroySubClasses;
  TdxChartTextFormatController.FormatController.ChangeHandler.Remove(FormatChanged);
  inherited Destroy;
end;

procedure TdxChart.Assign(Source: TPersistent);
var
  AChartOwner: IdxChartOwner;
begin
  if Source is TdxChart then
    AssignFrom(TdxChart(Source))
  else
    if Supports(Source, IdxChartOwner, AChartOwner) then
      Assign(AChartOwner.GetChart)
    else
      inherited Assign(Source);
end;

procedure TdxChart.AssignFrom(ASource: TdxChart; ARecreate: Boolean = True);
var
  ADiagramsList, ASeriesList: TdxFastObjectList;
begin
  BeginUpdate;
  try
    ColorScheme.Assign(ASource.ColorScheme);
    Appearance.Assign(ASource.Appearance);
    LookAndFeel.Assign(ASource.LookAndFeel);
    Bounds := ASource.Bounds;
    Titles.Assign(ASource.Titles);
    if ARecreate then
    begin
      ExtractItemsBeforeAssign(ADiagramsList, ASeriesList);
      try
        dxSafeCloneComponentList(ASource.DiagramList, GetOwnerForm, GetRootOwner,
          procedure (ASource, AClone: TComponent)
          var
            AIntf: IdxChartCloneComponent;
          begin
            TdxChartCustomDiagram(AClone).Chart := Self;
            if Supports(AClone, IdxChartCloneComponent, AIntf) then
              AIntf.SetSource(ASource);
            TdxChartCustomDiagram(AClone).AssignFrom(TdxChartCustomDiagram(ASource), True, ASeriesList);
          end, ADiagramsList);
        dxClearComponentList(ADiagramsList);
        dxClearComponentList(ASeriesList);
      finally
        ASeriesList.Free;
        ADiagramsList.Free;
      end;
    end
    else
      DiagramList := ASource.DiagramList;
    Legend.Assign(ASource.Legend);
    ToolTips.Assign(ASource.ToolTips);
  finally
    EndUpdate;
  end;
end;

function TdxChart.AddDiagram(ADiagramClass: TdxChartDiagramClass; const ACaption: string): TdxChartCustomDiagram;
begin
  Result := ADiagramClass.Create(GetRootOwner);
  BeginUpdate;
  try
    TdxChartCustomDiagram(Result).SetParentComponent(OwnerComponent);
    Result.Name := CreateUniqueName(GetOwnerForm, OwnerComponent, Result, 'TdxChart', '');
    if ACaption <> '' then
      Result.Title.Text := ACaption;
  finally
    EndUpdate;
  end;
end;

function TdxChart.AddDiagram<T>(const ACaption: string = ''): T;
begin
  Result := T(AddDiagram(TdxChartDiagramClass(T), ACaption));
end;

procedure TdxChart.BiDiModeChanged;
var
  I: Integer;
begin
  BeginUpdate;
  try
    Titles.BiDiModeChanged;
    Legend.BiDiModeChanged;
    for I := 0 to DiagramCount - 1 do
      Diagrams[I].BiDiModeChanged;
  finally
    EndUpdate;
  end;
end;

procedure TdxChart.ChangeScale(M, D: Integer);
var
  I: Integer;
begin
  BeginUpdate;
  try
    ScaleFactor.Change(M, D);
    Legend.ChangeScale(M, D);
    for I := 0 to DiagramCount - 1 do
      Diagrams[I].ChangeScale(M, D);
    Appearance.ChangeScale(M, D);
  finally
    EndUpdate;
  end;
end;

procedure TdxChart.LoadFromStream(AStream: TStream);
begin
  DataController.LoadFromStream(AStream);
end;

procedure TdxChart.PaintTo(ACanvas: TcxCustomCanvas);
begin
  PaintTo(ACanvas, Bounds);
end;

procedure TdxChart.PaintTo(ACanvas: TcxCustomCanvas; const ABounds: TRect; ARecalculate: Boolean);
var
  ASaveBounds: TRect;
  ASaveCanvas: TcxCustomCanvas;
begin
  if (ViewInfo.FIsExportMode) and (FCanvas <> ACanvas) then
    ASaveCanvas := FCanvas
  else
    ASaveCanvas := nil;
  ASaveBounds := Bounds;
  BeginUpdate;
  try
    ViewInfo.Dirty := ViewInfo.Dirty or not Bounds.IsEqual(ABounds) or ARecalculate;
    ViewInfo.FBounds := ABounds;
    if FCanvas <> ACanvas then
      CanvasChanged(ACanvas);
    Appearance.UpdateMetrics(ACanvas);
    ViewInfo.Draw(ACanvas);
  finally
    ViewInfo.FBounds := ASaveBounds;
    if ASaveCanvas <> nil then
      CanvasChanged(ASaveCanvas);
    CancelUpdate;
  end;
end;

procedure TdxChart.SaveToStream(AStream: TStream);
begin
  DataController.SaveToStream(AStream);
end;

procedure TdxChart.CreateSubClasses;
var
  AOwnerContainer: IcxLookAndFeelContainer;
begin
  FScaleFactor := TdxScaleFactor.Create;
  FLookAndFeel := TcxLookAndFeel.Create(Self);
  FLookAndFeel.OnChanged := LookAndFeelChanged;
  FScrollOptions := TdxChartScrollOptions.Create(Self);
  FZoomOptions := TdxChartZoomOptions.Create(Self);
  FAppearance := CreateAppearance;
  FTitles := CreateTitles;
  FLegend := CreateLegend;
  FCrosshairController := dxChartCreateCrosshairController(Self);
  FToolTips := TdxChartToolTips.Create(Self);
  if Supports(Owner, IcxLookAndFeelContainer, AOwnerContainer) then
    FLookAndFeel.MasterLookAndFeel := AOwnerContainer.GetLookAndFeel;
  FColorScheme := TdxChartColorScheme.Create(EmptyStr);
  FDiagrams := TdxFastObjectList.Create(False);
  FVisibleDiagrams := TdxFastObjectList.Create(False);
  FDataController := CreateDataController;
  FViewInfo := TdxChartViewInfo.Create(Self);
end;

procedure TdxChart.AddDiagram(ADiagram: TdxChartCustomDiagram);
begin
  DiagramList.Add(ADiagram);
  DiagramsChanged;
end;

procedure TdxChart.Calculate;
begin
  Appearance.UpdateMetrics(FCanvas);
  ViewInfo.Calculate(FCanvas);
end;

procedure TdxChart.CalculateColorScheme;
begin
  ColorScheme.Assign(TdxChartColorSchemeRepository.Get(ColorSchemeName));
  ColorScheme.ApplyColorAccent(
    dxColorToAlphaColor(LookAndFeelPainter.DefaultChartHistogramPlotColor),
    dxColorToAlphaColor(LookAndFeelPainter.DefaultChartDiagramValueCaptionTextColor),
    dxColorToAlphaColor(LookAndFeelPainter.DefaultSelectionColor));
end;

function TdxChart.CanCalculate: Boolean;
begin
  Result := FCanvas <> nil;
end;

procedure TdxChart.Changed(AChange: TChartChanges);
begin
  Changes := Changes + AChange;
  inherited Changed;
end;

procedure TdxChart.Changed(AChange: TChartChange);
begin
  Changed([AChange]);
end;

procedure TdxChart.CanvasChanged(ACanvas: TcxCustomCanvas);
begin
  if FCanvas <> ACanvas then
  begin
    FCanvas := ACanvas;
    ViewInfo.Dirty := True;
    Appearance.Changed(Appearance.TotalChanges);
  end;
end;

procedure TdxChart.ColorSchemeChanged;
begin
  BeginUpdate;
  try
    CalculateColorScheme;
    Appearance.Changed(Appearance.TotalChanges);
  finally
    EndUpdate;
  end;
end;

function TdxChart.CreateAppearance: TdxChartAppearance;
begin
  Result := TdxChartAppearance.Create(Self);
end;

function TdxChart.CreateDataController: TdxChartDataController;
begin
  Result := TdxChartDataController.Create(Self);
end;

function TdxChart.CreateLegend: TdxChartLegend;
begin
  Result := TdxChartLegend.Create(Self);
end;

function TdxChart.CreateTitles: TdxChartTitles;
begin
  Result := TdxChartTitles.Create(Self);
end;

procedure TdxChart.DestroySubClasses;
begin
  FLegend.Clear;
  FLookAndFeel.OnChanged := nil;
  FDataController.ClearAllRecords;
  dxClearComponentList(FDiagrams);
  FreeAndNil(FDiagrams);
  FreeAndNil(FVisibleDiagrams);
  FreeAndNil(FLookAndFeel);
  FreeAndNil(FViewInfo);
  FreeAndNil(FTitles);
  FreeAndNil(FDataController);
  FreeAndNil(FScaleFactor);
  FreeAndNil(FColorScheme);
  FreeAndNil(FLegend);
  FreeAndNil(FAppearance);
  FreeAndNil(FToolTips);
  FCrosshairController := nil;
  FreeAndNil(FZoomOptions);
  FreeAndNil(FScrollOptions);
end;

procedure TdxChart.DiagramsChanged;
var
  I: Integer;
begin
  FVisibleDiagrams.Clear;
  if Legend <> nil then
    Legend.DataChanged();
  for I := 0 to DiagramCount - 1 do
    if Diagrams[I].Visible then
      FVisibleDiagrams.Add(Diagrams[I]);
  FCrosshairController.DiagramsChanged;
  Changed(TChartChange.Layout);
end;

procedure TdxChart.DoChanged;
begin
  if Changes = []  then
    Exit;
  if TChartChange.Layout in Changes then
  begin
    ViewInfo.Dirty := ViewInfo.Dirty or (TChartChange.Layout in Changes);
    FCrosshairController.LayoutChanged;
    CallNotify(FOnChange, Self);
  end;
  if Changes <> [] then
    Invalidate;
  ViewInfo.DiscardCachedImage;
  Changes := [];
end;

procedure TdxChart.EnableExportMode(AEnable: Boolean);
var
  I: Integer;
begin
  ViewInfo.EnableExportMode(AEnable);
  for I := 0 to DiagramCount - 1 do
    Diagrams[I].ViewInfo.EnableExportMode(AEnable);
end;

function TdxChart.ExportToSmartImage(ACodecClass: TdxSmartImageCodecClass; AImageWidth, AImageHeight: Integer): TdxSmartImage;
var
  ABounds: TRect;
  ASVGStream: TMemoryStream;
  ABitmap: TcxBitmap32;

  function GetSVGStream: TMemoryStream;
  var
    ASVGCanvas: TdxSVGCanvas;
  begin
    Result := TMemoryStream.Create;
    ASVGCanvas := TdxSVGCanvas.Create(TdxSVGShapeRendering.srAuto);
    try
      ASVGCanvas.Initialize(ABounds);
      ASVGCanvas.UseGDITextCalculation := True;
      EnableExportMode(True);
      try
        PaintTo(ASVGCanvas, ABounds, True);
      finally
        EnableExportMode(False);
      end;
      ASVGCanvas.Export(Result);
    finally
      ASVGCanvas.Free;
    end;
    Result.Position := 0;
  end;

  function GetRenderedSVG: TcxBitmap32;
  var
    ASVGDocument: TdxSVGElementRoot;
    AGPCanvas: TdxGPCanvas;
    ARenderer: TdxSVGRenderer;
  begin
    Result := TcxBitmap32.CreateSize(ABounds);
    if TdxSVGImporter.Import(ASVGStream, ASVGDocument) then
    try
      AGPCanvas := TdxGPCanvas.Create(Result.cxCanvas.Handle);
      try
        AGPCanvas.SmoothingMode := smAntiAlias;
        ARenderer := TdxSVGRenderer.Create(AGPCanvas);
        ARenderer.ShapeRendering := TdxSVGShapeRendering.srAuto;
        ARenderer.UseDrawCorrection := True;
        try
          ASVGDocument.Draw(ARenderer, ABounds);
        finally
          ARenderer.Free;
        end;
      finally
        AGPCanvas.Free;
      end;
    finally
      ASVGDocument.Free;
    end;
  end;

begin
  Result := nil;
  if (AImageWidth = 0) and (AImageHeight = 0) then
    ABounds.InitSize(Bounds.Size)
  else
    ABounds.InitSize(0, 0, AImageWidth, AImageHeight);
  ASVGStream := GetSVGStream;
  try
    if (ACodecClass = nil) or (ACodecClass = TdxSVGImageCodec) or
      (ACodecClass = TdxGPImageCodecEMF) or (ACodecClass = TdxGPImageCodecWMF) then
      Result := TdxSmartImage.CreateFromStream(ASVGStream)
    else
    begin
      ABitmap := GetRenderedSVG;
      try
        if ACodecClass = TdxGPImageCodecBMP then
          Result := TdxBMPImage.CreateFromBitmap(ABitmap)
        else
          if ACodecClass = TdxGPImageCodecGIF then
            Result := TdxGIFImage.CreateFromBitmap(ABitmap)
          else
            if ACodecClass = TdxGPImageCodecJPEG then
              Result := TdxJPEGImage.CreateFromBitmap(ABitmap)
            else
              if ACodecClass = TdxGPImageCodecPNG then
                Result := TdxPNGImage.CreateFromBitmap(ABitmap)
              else
                if ACodecClass = TdxGPImageCodecTIFF then
                  Result := TdxTIFFImage.CreateFromBitmap(ABitmap);
      finally
        ABitmap.Free;
      end;
    end;
  finally
    ASVGStream.Free;
  end;
end;

procedure TdxChart.ExportToImage(const AStream: TStream; ACodecClass: TdxSmartImageCodecClass;
  AImageWidth, AImageHeight: Integer);
var
  AImage: TdxSmartImage;
begin
  AImage := ExportToSmartImage(ACodecClass, AImageWidth, AImageHeight);
  try
    if ACodecClass = nil then
      AImage.SaveToStream(AStream)
    else
      AImage.SaveToStreamByCodec(AStream, ACodecClass);
  finally
    AImage.Free;
  end;
end;

procedure TdxChart.ExportToImage(const AFileName: string; ACodecClass: TdxSmartImageCodecClass;
  AImageWidth: Integer; AImageHeight: Integer);
var
  AStream: TStream;
begin
  AStream := TFileStream.Create(AFileName, fmCreate);
  try
    if ACodecClass = nil then
      ACodecClass := TdxSmartImageCodecsRepository.GetFormatByExt(ExtractFileExt(AFileName));
    ExportToImage(AStream, ACodecClass, AImageWidth, AImageHeight);
  finally
    AStream.Free;
  end;
end;

procedure TdxChart.ExportToSVG(const AStream: TStream; AImageWidth, AImageHeight: Integer);
begin
  ExportToImage(AStream, TdxSVGImageCodec, AImageWidth, AImageHeight);
end;

procedure TdxChart.ExportToSVG(const AFileName: string; AImageWidth, AImageHeight: Integer);
begin
  ExportToImage(AFileName, TdxSVGImageCodec, AImageWidth, AImageHeight);
end;

procedure TdxChart.ExportToBMP(const AStream: TStream; AImageWidth, AImageHeight: Integer);
begin
  ExportToImage(AStream, TdxGPImageCodecBMP, AImageWidth, AImageHeight);
end;

procedure TdxChart.ExportToBMP(const AFileName: string; AImageWidth, AImageHeight: Integer);
begin
  ExportToImage(AFileName, TdxGPImageCodecBMP, AImageWidth, AImageHeight);
end;

procedure TdxChart.ExportToJPEG(const AStream: TStream; AImageWidth, AImageHeight: Integer);
begin
  ExportToImage(AStream, TdxGPImageCodecJPEG, AImageWidth, AImageHeight);
end;

procedure TdxChart.ExportToJPEG(const AFileName: string; AImageWidth, AImageHeight: Integer);
begin
  ExportToImage(AFileName, TdxGPImageCodecJPEG, AImageWidth, AImageHeight);
end;

procedure TdxChart.ExportToPNG(const AStream: TStream; AImageWidth, AImageHeight: Integer);
begin
  ExportToImage(AStream, TdxGPImageCodecPNG, AImageWidth, AImageHeight);
end;

procedure TdxChart.ExportToPNG(const AFileName: string; AImageWidth, AImageHeight: Integer);
begin
  ExportToImage(AFileName, TdxGPImageCodecPNG, AImageWidth, AImageHeight);
end;

procedure TdxChart.ExportToTIFF(const AStream: TStream; AImageWidth, AImageHeight: Integer);
begin
  ExportToImage(AStream, TdxGPImageCodecTIFF, AImageWidth, AImageHeight);
end;

procedure TdxChart.ExportToTIFF(const AFileName: string; AImageWidth, AImageHeight: Integer);
begin
  ExportToImage(AFileName, TdxGPImageCodecTIFF, AImageWidth, AImageHeight);
end;

procedure TdxChart.ExportToGIF(const AStream: TStream; AImageWidth, AImageHeight: Integer);
begin
  ExportToImage(AStream, TdxGPImageCodecGIF, AImageWidth, AImageHeight);
end;

procedure TdxChart.ExportToGIF(const AFileName: string; AImageWidth, AImageHeight: Integer);
begin
  ExportToImage(AFileName, TdxGPImageCodecGIF, AImageWidth, AImageHeight);
end;

procedure TdxChart.ExportToEMF(const AStream: TStream; AImageWidth, AImageHeight: Integer);
begin
  ExportToImage(AStream, TdxGPImageCodecEMF, AImageWidth, AImageHeight);
end;

procedure TdxChart.ExportToEMF(const AFileName: string; AImageWidth, AImageHeight: Integer);
begin
  ExportToImage(AFileName, TdxGPImageCodecEMF, AImageWidth, AImageHeight);
end;

procedure TdxChart.ExportToWMF(const AStream: TStream; AImageWidth, AImageHeight: Integer);
begin
  ExportToImage(AStream, TdxGPImageCodecWMF, AImageWidth, AImageHeight);
end;

procedure TdxChart.ExportToWMF(const AFileName: string; AImageWidth, AImageHeight: Integer);
begin
  ExportToImage(AFileName, TdxGPImageCodecWMF, AImageWidth, AImageHeight);
end;

procedure TdxChart.ExportToDocument(const AStream: TStream;
  AExporterClass: TdxSmartImageExporterClass; AImageWidth, AImageHeight: Integer);
var
  AImage: TdxSmartImage;
begin
  AImage := ExportToSmartImage(TdxGPImageCodecPNG, AImageWidth, AImageHeight);
  try
    dxSmartImageExporters.Export(AStream, AExporterClass, AImage);
  finally
    AImage.Free;
  end;
end;

procedure TdxChart.ExportToDocument(const AFileName: string;
  AExporterClass: TdxSmartImageExporterClass; AImageWidth, AImageHeight: Integer);
var
  AStream: TStream;
begin
  AStream := TFileStream.Create(AFileName, fmCreate);
  try
    ExportToDocument(AStream, AExporterClass, AImageWidth, AImageHeight);
  finally
    AStream.Free;
  end;
end;

procedure TdxChart.ExportToDOCX(const AStream: TStream; AImageWidth, AImageHeight: Integer);
begin
  ExportToDocument(AStream, TdxSmartImageDOCXExporter, AImageWidth, AImageHeight);
end;

procedure TdxChart.ExportToDOCX(const AFileName: string; AImageWidth, AImageHeight: Integer);
begin
  ExportToDocument(AFileName, TdxSmartImageDOCXExporter, AImageWidth, AImageHeight)
end;

procedure TdxChart.ExportToXLSX(const AStream: TStream; AImageWidth, AImageHeight: Integer);
begin
  ExportToDocument(AStream, TdxSmartImageXLSXExporter, AImageWidth, AImageHeight);
end;

procedure TdxChart.ExportToXLSX(const AFileName: string; AImageWidth, AImageHeight: Integer);
begin
  ExportToDocument(AFileName, TdxSmartImageXLSXExporter, AImageWidth, AImageHeight)
end;

procedure TdxChart.ExtractItemsBeforeAssign(var ADiagramsList, ASeriesList: TdxFastObjectList);
var
  I: Integer;
begin
  ASeriesList := TdxFastObjectList.Create(False);
  ASeriesList.Assign(DataController.SeriesList);
  for I := 0 to ASeriesList.Count - 1 do
    TdxChartCustomSeries(ASeriesList[I]).Diagram := nil;
  ADiagramsList := TdxFastObjectList.Create(False);
  ADiagramsList.Assign(FDiagrams);
  for I := FDiagrams.Count - 1 downto 0 do
  begin
    Diagrams[I].Chart := nil;
  end;
end;

procedure TdxChart.FormatChanged(Sender: TObject);
begin
  BeginUpdate;
  try
    DataController.ForEachSeries(
      procedure(ASeries: TdxChartCustomSeries)
      begin
        ASeries.DataChanged;
      end);
  finally
    EndUpdate;
  end;
end;

procedure TdxChart.LookAndFeelChanged(Sender: TcxLookAndFeel; AChangedValues: TcxLookAndFeelValues);
begin
  ColorSchemeChanged;
end;

function TdxChart.NeedThreading(ACount: Integer): Boolean;
begin
  Result := UseThreading <> bFalse;
  if FUseThreading = bDefault then
    Result := DefaultUseThreading;
  Result := Result and (ACount >= ThreadingMinRecords) and dxCanUseMultiThreading;
end;

procedure TdxChart.RemoveDiagram(ADiagram: TdxChartCustomDiagram);
begin
  ADiagram.Appearance.Parent := nil;
  DiagramList.Remove(ADiagram);
  DiagramsChanged;
end;

procedure TdxChart.LayoutChanged;
begin
  Changed(TChartChange.Layout);
end;

function TdxChart.ActuallyVisible: Boolean;
begin
  Result := True;
end;

function TdxChart.GetAppearance: TdxChartVisualElementAppearance;
begin
  Result := Appearance;
end;

function TdxChart.GetBounds: TRect;
begin
  Result := ViewInfo.Bounds.DeflateToTRect;
end;

function TdxChart.GetChart: TdxChart;
begin
  Result := Self;
end;

function TdxChart.GetDiagram(AIndex: Integer): TdxChartCustomDiagram;
begin
  Result := TdxChartCustomDiagram(DiagramList[AIndex]);
end;

function TdxChart.GetDiagramCount: Integer;
begin
  Result := DiagramList.Count;
end;

function TdxChart.GetLookAndFeelPainter: TcxCustomLookAndFeelPainter;
begin
  Result := LookAndFeel.Painter;
end;

function TdxChart.GetParentElement: IdxChartVisualElement;
begin
  Result := nil;
end;

function TdxChart.GetVisibleDiagram(AIndex: Integer): TdxChartCustomDiagram;
begin
  Result := FVisibleDiagrams[AIndex] as TdxChartCustomDiagram;
end;

function TdxChart.GetVisibleDiagramCount: Integer;
begin
  Result := FVisibleDiagrams.Count;
end;

function TdxChart.GetMouseAction(AKind: TChartMouseActionKind): TdxChartMouseAction;
begin
  case AKind of
    TChartMouseActionKind.Pan:
      Result := ScrollOptions.PanMouseAction;
    TChartMouseActionKind.ZoomIn:
      Result := ZoomOptions.ZoomInMouseAction;
    TChartMouseActionKind.ZoomOut:
      Result := ZoomOptions.ZoomOutMouseAction;
    TChartMouseActionKind.MarqueeZoom:
      Result := ZoomOptions.MarqueeZoomMouseAction;
  else
    Result := nil;
  end;
end;

function TdxChart.GetOwnerComponent: TComponent;
begin
  if Owner is TComponent then
    Result := Owner as TComponent
  else
    Result := nil;
end;

function TdxChart.GetOwnerForm: TComponent;
begin
  if OwnerComponent <> nil then
    Result := OwnerComponent.Owner
  else
    Result := nil;
end;

function TdxChart.GetRootOwner: TComponent;
begin
  Result := GetOwnerForm;
  if Result = nil then
    Result := GetOwnerComponent;
end;

procedure TdxChart.Invalidate;
begin
  if OwnerControl <> nil then
    OwnerControl.Invalidate;
end;

procedure TdxChart.InvalidateRect(const ARect: TdxRectF);
begin
  if OwnerControl <> nil then
    OwnerControl.InvalidateRect(ARect);
end;

procedure TdxChart.SetAppearance(AValue: TdxChartAppearance);
begin
  Appearance.Assign(AValue);
end;

procedure TdxChart.SetBounds(const AValue: TRect);
begin
  if not AValue.IsEqual(Bounds) then
  begin
    ViewInfo.SetBounds(cxRectF(AValue), cxRectF(AValue));
    ViewInfo.DiscardCachedImage;
  end;
end;

procedure TdxChart.SetColorSchemeName(const Value: string);
begin
  if FColorSchemeName <> Value then
  begin
    FColorSchemeName := Value;
    ColorSchemeChanged;
  end;
end;

procedure TdxChart.SetDiagram(AIndex: Integer; AValue: TdxChartCustomDiagram);
begin
  Diagrams[AIndex].Assign(AValue);
end;

procedure TdxChart.SetDiagramList(AValue: TdxFastObjectList);
var
  I: Integer;
begin
  for I := 0 to DiagramCount - 1 do
    Diagrams[I] := TdxChartCustomDiagram(AValue[I]);
  DiagramsChanged;
end;

procedure TdxChart.SetScrollOptions(AValue: TdxChartScrollOptions);
begin
  FScrollOptions.Assign(AValue);
end;

procedure TdxChart.SetToolTips(const Value: TdxChartToolTips);
begin
  if FToolTips <> Value then
    FToolTips.Assign(Value);
end;

procedure TdxChart.SetUseRightToLeftAlignment(AValue: Boolean);
begin
  if AValue <> UseRightToLeftAlignment then
  begin
    FUseRightToLeftAlignment := AValue;
    LayoutChanged;
  end;
end;

procedure TdxChart.SetUseRightToLeftReading(AValue: Boolean);
begin
  if AValue <> UseRightToLeftReading then
  begin
    FUseRightToLeftReading := AValue;
    LayoutChanged;
  end;
end;

procedure TdxChart.SetZoomOptions(AValue: TdxChartZoomOptions);
begin
  FZoomOptions.Assign(AValue);
end;

procedure TdxChart.StyleChanged;
begin
  Changed(TChartChange.Style);
end;

procedure TdxChart.TextColorChanged;
begin
  StyleChanged;
end;

{ TdxChartSeriesCustomView }

constructor TdxChartSeriesCustomView.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FValueLabels := CreateValueLabels;
  FViewData := CreateViewData;
  FViewInfo := CreateViewInfo;
end;

destructor TdxChartSeriesCustomView.Destroy;
begin
  Series.ClearLegend;
  FreeAndNil(FValueLabels);
  FreeAndNil(FViewInfo);
  FreeAndNil(FViewData);
  inherited Destroy;
end;

procedure TdxChartSeriesCustomView.DoAssign(Source: TPersistent);
begin
  if Source is TdxChartSeriesCustomView then
  begin
    Appearance := TdxChartSeriesCustomView(Source).Appearance;
    ValueLabels := TdxChartSeriesCustomView(Source).ValueLabels;
  end;
  inherited DoAssign(Source);
end;

function TdxChartSeriesCustomView.GetAppearance: TdxChartSeriesViewAppearance;
begin
  Result := TdxChartSeriesViewAppearance(inherited Appearance);
end;

function TdxChartSeriesCustomView.GetSeries: TdxChartCustomSeries;
begin
  Result := TdxChartCustomSeries(Owner);
end;

procedure TdxChartSeriesCustomView.SetAppearance(AValue: TdxChartSeriesViewAppearance);
begin
  Appearance.Assign(AValue);
end;

procedure TdxChartSeriesCustomView.SetValueLabels(AValue: TdxChartSeriesValueLabels);
begin
  ValueLabels.Assign(AValue)
end;

function TdxChartSeriesCustomView.ActuallyLabelsVisible: Boolean;
begin
  Result := ActuallyVisible and (Series.Points.Count > 0) and ValueLabels.Visible;
end;

function TdxChartSeriesCustomView.ActuallyVisible: Boolean;
begin
  Result := (Series <> nil) and Series.ActuallyVisible;
end;

procedure TdxChartSeriesCustomView.Calculate(ADiagram: TdxChartCustomDiagram; ACanvas: TcxCustomCanvas);
begin
  ViewData.Calculate;
  ViewInfo.Calculate(ACanvas);
end;

procedure TdxChartSeriesCustomView.ChangeScale(M, D: Integer);
begin
  ValueLabels.ChangeScale(M, D);
  ViewInfo.Dirty := True;
end;

class function TdxChartSeriesCustomView.CanAggregate(AView: TdxChartSeriesCustomView): Boolean;
begin
  Result := IsEqual(AView);
end;

function TdxChartSeriesCustomView.CreateAppearance: TdxChartVisualElementAppearance;
begin
  Result := TdxChartSeriesViewAppearance.Create(Self);
end;

function TdxChartSeriesCustomView.CreateValueLabels: TdxChartSeriesValueLabels;
begin
  Result := TdxChartSeriesValueLabels.Create(Self);
end;

function TdxChartSeriesCustomView.CreateViewData: TdxChartSeriesViewCustomViewData;
begin
  Result := TdxChartSeriesViewCustomViewData.Create(Self);
end;

function TdxChartSeriesCustomView.CreateViewInfo: TdxChartSeriesViewCustomViewInfo;
begin
   Result := TdxChartSeriesViewCustomViewInfo.Create(Self);
end;

function TdxChartSeriesCustomView.GetDefaultLabelAngle: Single;
begin
  Result := 0;
end;

function TdxChartSeriesCustomView.GetDefaultLineLength: Single;
begin
  Result := DefaultLineLength;
end;

function TdxChartSeriesCustomView.GetParentElement: IdxChartVisualElement;
begin
  if Series <> nil then
    Result := Series.Diagram
  else
    Result := nil;
end;

function TdxChartSeriesCustomView.GetValueLabelAppearanceClass: TdxChartSeriesValueLabelAppearanceClass;
begin
  Result := TdxChartSeriesValueLabelAppearance;
end;

class function TdxChartSeriesCustomView.GetTypeName: string;
const
  ViewPrefix = 'Series';
  ViewSuffix = 'View';
begin
  Result := StringReplace(ClassName, ViewSuffix, '', [rfReplaceAll, rfIgnoreCase]);
  Delete(Result, 1, Pos(ViewPrefix, Result) + Length(ViewPrefix) - 1);
end;

class function TdxChartSeriesCustomView.GetDescription: string;
begin
  Result := '';
end;

class function TdxChartSeriesCustomView.GetViewImageIndex: Integer;
begin
  Result := dxChartRegisteredSeriesView.GetIndexByClass(Self);
end;

class function TdxChartSeriesCustomView.GetViewImages(ADPI: Integer): TcxImageList;
var
  I, ARequiredImageSize: Integer;
  AViewClass: TdxChartSeriesViewClass;
const
  ImageResType = 'DXCHART';
begin
  ARequiredImageSize := Muldiv(16, ADPI, dxDefaultDPI);
  if Assigned(FRegisteredSeriesViewImages) and
    (FRegisteredSeriesViewImages.Width <> ARequiredImageSize) then
    FreeAndNil(FRegisteredSeriesViewImages);
  if FRegisteredSeriesViewImages = nil then
  begin
    FRegisteredSeriesViewImages := TcxImageList.CreateSize(ARequiredImageSize, ARequiredImageSize);
    for I := 0 to dxChartRegisteredSeriesView.Count - 1 do
    begin
      AViewClass := TdxChartSeriesViewClass(dxChartRegisteredSeriesView.Items[I]);
      FRegisteredSeriesViewImages.AddImageFromResource(HInstance, AViewClass.ClassName, ImageResType);
    end;
  end;
  Result := FRegisteredSeriesViewImages;
end;

class function TdxChartSeriesCustomView.IsCompatibleWith(AView: TdxChartSeriesCustomView): Boolean;
begin
  Result := IsEqual(AView) or AView.InheritsFrom(Self) or InheritsFrom(AView.ClassType);
end;

class function TdxChartSeriesCustomView.IsCompatibleWith(ASeriesClass: TdxChartSeriesClass): Boolean;
begin
  Result := InheritsFrom(ASeriesClass.GetBaseViewClass);
end;

class function TdxChartSeriesCustomView.IsEqual(AView: TdxChartSeriesCustomView): Boolean;
begin
  Result := AView.ClassType = Self;
end;

procedure TdxChartSeriesCustomView.LayoutChanged;
begin
  if ActuallyVisible then
    Series.Changed(TdxChartCustomSeries.TSeriesChange.Layout);
end;

procedure TdxChartSeriesCustomView.StyleChanged;
begin
  if ActuallyVisible then
    Series.Changed(TdxChartCustomSeries.TSeriesChange.Style);
end;

class procedure TdxChartSeriesCustomView.Register;
begin
  RegisterClass(Self);
  FreeAndNil(FRegisteredSeriesViewImages);
  dxChartRegisteredSeriesView.Register(Self, GetTypeName);
end;

class procedure TdxChartSeriesCustomView.UnRegister;
begin
  UnRegisterClass(Self);
  FreeAndNil(FRegisteredSeriesViewImages);
  if FRegisteredSeriesView <> nil then  
    dxChartRegisteredSeriesView.UnRegister(Self);
end;

{ TdxChartSeriesViewCustomViewInfo }

constructor TdxChartSeriesViewCustomViewInfo.Create(AOwner: TdxChartSeriesCustomView);
begin
  inherited Create(AOwner.Appearance);
  FColorizedItems := TdxFastObjectList.Create(False);
  FView := AOwner;
  FViewData := View.ViewData;
  FListener := TdxAppearanceListener.Create(Self);
end;

destructor TdxChartSeriesViewCustomViewInfo.Destroy;
begin
  FreeAndNil(FListener);
  FreeAndNil(FColorizedItems);
  ClearValues;
  inherited Destroy;
end;

procedure TdxChartSeriesViewCustomViewInfo.UpdateBounds(const ABounds: TdxRectF);
begin
  inherited UpdateBounds(ABounds);
  FContentBounds := cxRectInflate(Bounds.Content(Padding),
    -Appearance.ActualBorderThickness, -Appearance.ActualBorderThickness);
end;

procedure TdxChartSeriesViewCustomViewInfo.UpdateLabelsBoundingRect;
begin
  ForEachValue(
    procedure(AValue: TdxChartSeriesValueViewInfo)
    begin
      DiagramViewInfo.UpdateLabelsBoundingRect(AValue);
    end);
end;

procedure TdxChartSeriesViewCustomViewInfo.ValidateValueLabels;
begin
  if not DrawLabels then
    Exit;
  ForEachVisibleValue(
    procedure(AValue: TdxChartSeriesValueViewInfo)
    begin
      if AValue.ValueLabel <> nil then
        AValue.ValueLabel.Validate(FSeriesBounds);
    end);
end;

procedure TdxChartSeriesViewCustomViewInfo.ResampleValues(const AStartValue, AFinishValue: TdxChartSeriesValueViewInfo);
begin
end;

procedure TdxChartSeriesViewCustomViewInfo.CalculateCanvasValue(const AValue: TdxChartSeriesValueViewInfo);
begin
end;

function TdxChartSeriesViewCustomViewInfo.CalculateHitTest(AHitTest: TdxChartHitTestEngine; const P: TdxPointF): Boolean;
begin
  Result := Title.ViewInfo.CalculateHitTest(AHitTest, P);
end;

procedure TdxChartSeriesViewCustomViewInfo.CalculateLabels(ACanvas: TcxCustomCanvas);
begin
end;

function TdxChartSeriesViewCustomViewInfo.CalculateLabelsHitTest(AHitTest: TdxChartHitTestEngine; const P: TdxPointF): Boolean;
var
  AValue: TdxChartSeriesValueViewInfo;
begin
  Result := False;
  if (Count > 0) and DrawLabels then
  begin
    AValue := FLastVisibleValue;
    while AValue <> nil  do
    begin
      if AValue.ValueLabel <> nil then
        Result := AValue.ValueLabel.CalculateHitTest(AHitTest, P);
      if Result then
        Break;
      AValue := AValue.FPriorDisplayValue;
    end;
  end;
end;

procedure TdxChartSeriesViewCustomViewInfo.CalculateValues(ACanvas: TcxCustomCanvas);
var
  AValue: TdxChartSeriesValueViewInfo;
begin
  if Count = 0 then
    Exit;
  PrepareValuesToCanvasValues;
  if not FDrawLabels then
    Exit;
  AValue := FFirstVisibleValue;
  while AValue <> nil do
  begin
    AValue.CalculateLabel(ACanvas);
    DiagramViewInfo.UpdateLabelsBoundingRect(AValue);
    AValue := AValue.FNextDisplayValue;
  end;
end;

procedure TdxChartSeriesViewCustomViewInfo.ClearValues;
begin
  FillChar(FValuesGroups, SizeOf(FValuesGroups), 0);
  try
    FreeAndNil(FFirstValue);
  finally
    FCount := 0;
    FTotalCount := 0;
    FFirstValue := nil;
    FLastValue := nil;
  end;
end;

function TdxChartSeriesViewCustomViewInfo.GetColorizedAppearance(AIndex: Integer): TdxChartColorizedAppearance;
begin
  if AIndex >= FColorizedItems.Count then
    FColorizedItems.Add(Appearance.CloneAsColorized(AIndex));
  Result := TdxChartColorizedAppearance(FColorizedItems.List[AIndex]);
end;

function TdxChartSeriesViewCustomViewInfo.CreateValueViewInfo(const ARecord: PdxDataRecord; const APriorValue: TdxChartSeriesValueViewInfo): TdxChartSeriesValueViewInfo;
begin
  Result := GetValueViewInfoClass.Create(Self, APriorValue);
  Result.UpdateRecord(ARecord);
end;

procedure TdxChartSeriesViewCustomViewInfo.DoCalculate(ACanvas: TcxCustomCanvas);
begin
  Visible := Visible and Series.ActuallyVisible;
  if not ActuallyVisible then
    Exit;
  FDrawLabels := View.ValueLabels.ActuallyVisible;
  FShowInLegend := View.Series.ShowInLegend <> TdxChartSeriesShowInLegend.None;
  FSeriesBounds := FContentBounds;
  Title.CalculateAndAdjustContent(ACanvas, FSeriesBounds);
  CalculateValues(ACanvas);
  CalculateLabels(ACanvas);
end;

procedure TdxChartSeriesViewCustomViewInfo.DoDraw(ACanvas: TcxCustomCanvas);
begin
  Title.ViewInfo.Draw(ACanvas);
  if not FSeriesBounds.IsEmpty then
    DrawValues(ACanvas);
end;

procedure TdxChartSeriesViewCustomViewInfo.DoDrawLabels(ACanvas: TcxCustomCanvas);
var
  AValue: TdxChartSeriesValueViewInfo;
begin
  if not DrawLabels or (FCount = 0) or not ActuallyVisible then
    Exit;
  AValue := FFirstVisibleValue;
  while AValue <> nil do
  begin
    DrawValueLabel(ACanvas, AValue);
    AValue := AValue.FNextDisplayValue;
  end;
end;

procedure TdxChartSeriesViewCustomViewInfo.DrawLegendGlyph(ACanvas: TcxCustomCanvas; const R: TdxRectF);
var
  AEllipse: TRect;
  ARadius: Single;
begin
  ARadius := Min(R.Width, R.Height);
  AEllipse := cxRectCenter(R, ARadius, ARadius).DeflateToTRect;
  ACanvas.Rectangle(AEllipse, GetLegendItemColor, Appearance.ActualBorderColor);
end;

procedure TdxChartSeriesViewCustomViewInfo.DrawValue(ACanvas: TcxCustomCanvas;
  const AValue: TdxChartSeriesValueViewInfo);
begin
  AValue.Draw(ACanvas);
end;

procedure TdxChartSeriesViewCustomViewInfo.DrawValueLabel(ACanvas: TcxCustomCanvas;
  const AValue: TdxChartSeriesValueViewInfo);
begin
  if FDrawLabels and (AValue.ValueLabel <> nil) then
    AValue.ValueLabel.Draw(ACanvas);
end;

procedure TdxChartSeriesViewCustomViewInfo.DrawValues(ACanvas: TcxCustomCanvas);
var
  AValue: TdxChartSeriesValueViewInfo;
begin
  if Count = 0 then
    Exit;
  AValue := FFirstVisibleValue;
  while AValue <> nil do
  begin
    DrawValue(ACanvas, AValue);
    AValue := AValue.FNextDisplayValue;
  end;
end;

procedure TdxChartSeriesViewCustomViewInfo.ForEachValue(AProc: TForEachValueProc);
var
  AValue: TdxChartSeriesValueViewInfo;
begin
  ViewData.Calculate;
  if Count = 0 then
    Exit;
  AValue := FFirstValue;
  while AValue <> nil do
  begin
    AProc(AValue);
    if AValue = FLastValue then
      Break;
    AValue := AValue.Next;
  end;
end;

procedure TdxChartSeriesViewCustomViewInfo.ForEachVisibleValue(AProc: TForEachValueProc);
var
  AValue: TdxChartSeriesValueViewInfo;
begin
  ViewData.Calculate;
  if Count = 0 then
    Exit;
  AValue := FFirstVisibleValue;
  while AValue <> nil do
  begin
    AProc(AValue);
    AValue := AValue.NextVisibleValue;
  end;
end;

function TdxChartSeriesViewCustomViewInfo.GetHitElement(const P: TdxPointF): IdxChartHitTestElement;
var
  AValue: TdxChartSeriesValueViewInfo;
begin
  Result := nil;
  if (Count > 0) and ActuallyVisible then
  begin
    AValue := FLastVisibleValue;
    while AValue <> nil do
    begin
      Result := AValue.GetHitElement(P);
      if Result <> nil then
        Break;
      AValue := AValue.FPriorDisplayValue;
    end;
  end;
end;

function TdxChartSeriesViewCustomViewInfo.GetLegendItemColor: TdxAlphaColor;
begin
  Result := Appearance.ActualPenColor;
end;

function TdxChartSeriesViewCustomViewInfo.GetValueViewInfoClass: TdxChartSeriesValueViewInfoClass;
begin
  Result := TdxChartSeriesValueViewInfo;
end;

procedure TdxChartSeriesViewCustomViewInfo.GetVisibleValueLabels(ALabelsList: TdxChartSeriesValueLabelViewInfoList);
begin
  ForEachVisibleValue(
    procedure(AValue: TdxChartSeriesValueViewInfo)
    begin
      if (AValue.ValueLabel <> nil) and AValue.ValueLabel.ActuallyVisible and not AValue.ValueLabel.Bounds.IsEmpty then
        ALabelsList.Add(AValue.ValueLabel);
    end);
end;

function TdxChartSeriesViewCustomViewInfo.NeedDisplayTextCalculation: Boolean;
begin
  Result := FDrawLabels;
end;

function TdxChartSeriesViewCustomViewInfo.NeedValuesResampling: Boolean;
begin
  Result := False;
end;

procedure TdxChartSeriesViewCustomViewInfo.PrepareItems(ARecords: TdxFastList);

  procedure DetermineOutermostVisibleValues;
  var
    J: Integer;
  begin
    FFirstVisibleValue := nil;
    for J := 0 to ValuesGroupCount - 1 do
    begin
      FValuesGroups[J].FindOutermostVisibleValues;
      if FFirstVisibleValue = nil then
        FFirstVisibleValue := FValuesGroups[J].FirstVisibleValue;
    end;

    FLastVisibleValue := nil;
    for J := ValuesGroupCount - 1 downto 0 do
      if (FLastVisibleValue = nil) and (FValuesGroups[J].LastVisibleValue <> nil) then
      begin
        FLastVisibleValue := FValuesGroups[J].LastVisibleValue;
        Break;
      end;
  end;

var
  ACountInGroup, I: Integer;
  AData: PdxDataRecord;
  APriorVisible, AValue: TdxChartSeriesValueViewInfo;
begin
  FCount := 0;
  //
  FillChar(FValuesGroups, SizeOf(FValuesGroups), 0);
  APriorVisible := nil;
  FDrawLabels := ValueLabels.ActuallyVisible;
  FShowInLegend := View.Series.ShowInLegend <> TdxChartSeriesShowInLegend.None;
  if ARecords.Count > 0 then
  begin
    AValue := FFirstValue;
    ACountInGroup := Max(1, Ceil(ARecords.Count / ValuesGroupCount ));
    for I := 0 to ARecords.Count - 1 do
    begin
      AData := ARecords.List^[I];
      if I >= FTotalCount then
      begin
        AValue := CreateValueViewInfo(AData, FLastValue);
        if FLastValue = nil then
          FFirstValue := AValue;
        FLastValue := AValue;
        Inc(FCount);
        Inc(FTotalCount);
      end
      else
      begin
        Inc(FCount);
        AValue.UpdateRecord(AData);
        AValue.FNextDisplayValue := nil;
        AValue.FPriorDisplayValue := nil;
        FLastValue := AValue;
        AValue := AValue.Next;
      end;
      if TdxChartSeriesValueViewInfo.TGapStates * FLastValue.FState = [TdxChartSeriesValueViewInfo.TValueState.Visible] then
      begin
        if APriorVisible = nil then
          Include(FLastValue.FState, TdxChartSeriesValueViewInfo.TValueState.SegmentStart);
        APriorVisible := FLastValue;
      end
      else
        if APriorVisible <> nil then
        begin
          Include(APriorVisible.FState, TdxChartSeriesValueViewInfo.TValueState.SegmentFinish);
          APriorVisible := nil;
        end;
      FValuesGroups[I div ACountInGroup].SetValue(FLastValue);
      if TdxChartSeriesValueViewInfo.TValueState.Visible in FLastValue.FState then
        ViewData.CheckValue(FLastValue);
    end;
  end;
  if APriorVisible <> nil then
    Include(APriorVisible.FState, TdxChartSeriesValueViewInfo.TValueState.SegmentFinish);

  DetermineOutermostVisibleValues;

  if FTotalCount - FCount >= MaxCapacity then
  begin
    FLastValue.DeleteNextItems;
    FTotalCount := FLastValue.Index + 1;
  end;
end;

procedure TdxChartSeriesViewCustomViewInfo.PrepareValuesToCanvasValues;

  procedure ConnectValueGroups;
  var
    APriorValue: TdxChartSeriesValueViewInfo;
    I: Integer;
  begin
    APriorValue := nil;
    for I := 0 to ValuesGroupCount - 1 do
    begin
      if FValuesGroups[I].Empty or (FValuesGroups[I].FirstVisibleValue = nil) then
        Continue;
      FValuesGroups[I].FirstVisibleValue.FPriorDisplayValue := APriorValue;
      if APriorValue <> nil then
        APriorValue.FNextDisplayValue := FValuesGroups[I].FirstVisibleValue;
      APriorValue := FValuesGroups[I].LastVisibleValue;
    end;

  end;

var
  AValueGroupTask: TdxChartGroupValueTask;
  ATaskGroup: TdxTaskGroup;
  AValueGroup: TValueGroup;
  I: Integer;
begin
  if FFirstVisibleValue = nil then
    Exit;
  if View.Chart.NeedThreading(Count) then
  begin
    ATaskGroup := TdxTaskGroup.Create;
    try
      for I := 0 to ValuesGroupCount - 1  do
      begin
        AValueGroup := FValuesGroups[I];
        if not AValueGroup.Empty then
          ATaskGroup.AddTask(TdxChartGroupValueTask.Create(AValueGroup.FirstVisibleValue, AValueGroup.LastVisibleValue, CalculateCanvasValue));
      end;
      ATaskGroup.RunAndWait;
      ConnectValueGroups;
    finally
      ATaskGroup.Free;
    end;
    if NeedValuesResampling then
    begin
      ATaskGroup := TdxTaskGroup.Create;
      try
        for I := 0 to ValuesGroupCount - 1  do
        begin
          AValueGroup := FValuesGroups[I];
          if not AValueGroup.Empty then
            ATaskGroup.AddTask(TdxChartGroupResamplingTask.Create(AValueGroup.FirstVisibleValue, AValueGroup.LastVisibleValue, ResampleValues));
        end;
        ATaskGroup.RunAndWait;
      finally
        ATaskGroup.Free;
      end;
    end;
  end
  else
  begin
    AValueGroupTask := TdxChartGroupValueTask.Create(FFirstVisibleValue, FLastVisibleValue, CalculateCanvasValue);
    try
      AValueGroupTask.Execute;
    finally
      FreeAndNil(AValueGroupTask);
    end;
    if NeedValuesResampling then
      ResampleValues(FFirstVisibleValue, FLastVisibleValue);
  end;
end;

procedure TdxChartSeriesViewCustomViewInfo.SetGroup(AGroup: TdxChartDiagramSeriesGroup; AIndex: Integer = 0);
begin
  FGroup := AGroup;
  FIndex := AIndex;
  Dirty := True;
  ViewData.MakeDirty;
end;

function TdxChartSeriesViewCustomViewInfo.TValueGroup.Empty: Boolean;
begin
  Result := (Start = nil) or (Finish = nil)
end;

procedure TdxChartSeriesViewCustomViewInfo.TValueGroup.FindOutermostVisibleValues;
var
  AValue: TdxChartSeriesValueViewInfo;
begin
  if Empty then
    Exit;

  AValue := Start;
  while not AValue.Visible and (AValue <> Finish) do
    AValue := AValue.Next;
  if AValue.Visible then
    FirstVisibleValue := AValue;

  AValue := Finish;
  while not AValue.Visible and (AValue <> Start) do
    AValue := AValue.Prior;
  if AValue.Visible then
    LastVisibleValue := AValue;
end;

procedure TdxChartSeriesViewCustomViewInfo.TValueGroup.SetValue(const AValue: TdxChartSeriesValueViewInfo);
begin
  Finish := AValue;
  if Start = nil then
    Start := AValue;
end;

function TdxChartSeriesViewCustomViewInfo.GetAppearance: TdxChartSeriesViewAppearance;
begin
  Result := TdxChartSeriesViewAppearance(inherited Appearance);
end;

function TdxChartSeriesViewCustomViewInfo.GetSeries: TdxChartCustomSeries;
begin
  Result := View.Series;
end;

function TdxChartSeriesViewCustomViewInfo.GetTitle: TdxChartSeriesTitle;
begin
  Result := Series.Title;
end;

function TdxChartSeriesViewCustomViewInfo.GetValueLabels: TdxChartSeriesValueLabels;
begin
  Result := View.ValueLabels;
end;

function TdxChartSeriesViewCustomViewInfo.GetValueLabelVisibleBounds: TdxRectF;
begin
  Result := FSeriesBounds;
end;

function TdxChartSeriesViewCustomViewInfo.GetDiagram: TdxChartCustomDiagram;
begin
  Result := Series.Diagram;
end;

function TdxChartSeriesViewCustomViewInfo.GetDiagramViewInfo: TdxChartDiagramCustomViewInfo;
begin
  Result := Diagram.ViewInfo;
end;

function TdxChartSeriesViewCustomViewInfo.GetPadding: TRect;
begin
  Result := Appearance.ActualPadding;
end;

function TdxChartSeriesViewCustomViewInfo.GetMargins: TRect;
begin
  Result := Appearance.ActualMargins;
end;

{ TdxChartSeriesViewCustomViewData }

constructor TdxChartSeriesViewCustomViewData.Create(AOwner: TdxChartSeriesCustomView);
begin
  FView := AOwner;
  FSeries := View.Series;
end;

function TdxChartSeriesViewCustomViewData.GetArgument(
  const ARecord: PdxDataRecord; var AValue: Double; var ADisplayText: string): Boolean;
var
  PValue: TdxChartSeriesPoints.PNumericValue;
begin
  AValue := 0;
  ADisplayText := '';
  Result := FArgumentField <> nil;
  if not Result then
    Exit;
  if FArgumentOffset > 0 then
  begin
    PValue := Pointer(TdxNativeUInt(ARecord) + FArgumentOffset);
    if PValue.Flag and ValueNotNullFlag = ValueNotNullFlag then
      AValue := PValue.Value
    else
      Result := Series.EmptyPointsDisplayMode = TdxChartEmptyPointsDisplayMode.Zero;
    if PValue.Flag and ValueTextFlag = ValueTextFlag then
      ADisplayText := PValue.Text;
  end
  else
    begin
      if ArgumentField.IsNull[ARecord] then
        Result := Series.EmptyPointsDisplayMode = TdxChartEmptyPointsDisplayMode.Zero
      else
        if IsNumeric then
        begin
          AValue := ArgumentField.Value[ARecord];
          ADisplayText := ArgumentField.DisplayText[ARecord];
        end
        else
          ADisplayText := ArgumentField.Value[ARecord];
    end;
end;

function TdxChartSeriesViewCustomViewData.GetValue(
  const ARecord: PdxDataRecord; var AValue: Double; var ADisplayText: string): Boolean;
var
  PValue: TdxChartSeriesPoints.PNumericValue;
begin
  AValue := 0;
  ADisplayText := '';
  Result := FValueField <> nil;
  if not Result then
    Exit;
  if FValueOffset > 0 then
  begin
    PValue := Pointer(TdxNativeUInt(ARecord) + FValueOffset);
    if PValue.Flag and ValueNotNullFlag = ValueNotNullFlag then
      AValue := PValue.Value
    else
      Result := Series.EmptyPointsDisplayMode = TdxChartEmptyPointsDisplayMode.Zero;
    if PValue.Flag and ValueTextFlag = ValueTextFlag then
      ADisplayText := PValue.Text;
  end
  else
    if Result then
    begin
      if ValueField.IsNull[ARecord] then
        Result := Series.EmptyPointsDisplayMode = TdxChartEmptyPointsDisplayMode.Zero
      else
      begin
        AValue := ValueField.Value[ARecord];
        ADisplayText := ValueField.DisplayText[ARecord];
      end;
    end;
end;

function TdxChartSeriesViewCustomViewData.GetTopNOptions: TdxChartSeriesTopNOptions;
begin
  Result := Series.TopNOptions;
end;

function TdxChartSeriesViewCustomViewData.GetValueAsFloat(ARecord: PdxDataRecord): Variant;
var
  V: Variant;
begin
  Result := 0;
  if ARecord = nil then
    Exit;
  V := FValueField.Value[ARecord];
  if VarIsNumeric(V) then
    Result := V;
end;

function TdxChartSeriesViewCustomViewData.GetDiagram: TdxChartCustomDiagram;
begin
  Result := Series.Diagram;
end;

function TdxChartSeriesViewCustomViewData.GetIsNumeric: Boolean;
begin
  if Dirty then
    UpdateReferences(Series.Points);
  Result := (ArgumentField <> nil) and (ArgumentField.ValueTypeClass <> nil) and ArgumentField.ValueTypeClass.IsNumeric;
end;

function TdxChartSeriesViewCustomViewData.AllowSorting: Boolean;
begin
  Result := False;
end;

procedure TdxChartSeriesViewCustomViewData.ApplySorting(ARecords: TdxFastList);
begin
  if Series.SortOrder = soNone then
    Exit;
  if Series.SortBy = TdxChartSeriesSortBy.Value then
    ARecords.Sort(Series.ComparePointsByValue, True)
  else
    ARecords.Sort(Series.ComparePointsByArgument, True);
end;

procedure TdxChartSeriesViewCustomViewData.ApplyTopNOptions(ARecords: TdxFastList);
var
  APercentMode: Boolean;
  ATopValuePoints: TdxFastList;
  AValue: Double;
  I, AIndex: Integer;
begin
  FOthersValue := 0;
  if not TopNOptions.Enabled then
    Exit;
  if ValueField = nil then
    Exit;
  APercentMode := TopNOptions.Mode = TdxChartSeriesTopNOptionsMode.ThresholdPercent;
  if APercentMode then
    CalculateSummary(ARecords);
  if TopNOptions.Mode = TdxChartSeriesTopNOptionsMode.Count then
  begin
    if ARecords.Count > TopNOptions.Value then
    begin
      ATopValuePoints := TdxFastList.Create(ARecords.Count);
      try
        ATopValuePoints.Assign(ARecords);
        ApplySorting(ATopValuePoints);
        ATopValuePoints.Count := Trunc(TopNOptions.Value);
        for I := 0 to ARecords.Count - 1 do
        begin
          AIndex := ATopValuePoints.IndexOf(ARecords.List[I]);
          AValue := GetValueAsFloat(ARecords.List[I]);
          if AIndex >= 0 then
            ATopValuePoints.Delete(AIndex)
          else
          begin
            FOthersValue := FOthersValue + AValue;
            ARecords.List[I] := nil;
          end;
        end;
      finally
        ATopValuePoints.Free;
      end;
    end;
  end
  else
    for I := 0 to ARecords.Count - 1 do
    begin
      AValue := GetValueAsFloat(ARecords.List[I]);
      if (APercentMode and (CompareValue(AValue / SummaryValue * 100 , TopNOptions.Value) < 0)) or
       (not APercentMode and (CompareValue(AValue, TopNOptions.Value) < 0)) then
      begin
        ARecords.List[I] := nil;
        FOthersValue := FOthersValue + AValue;
      end;
    end;
  ARecords.Pack;
  if (ARecords.Count > 0) and TopNOptions.ShowOthers then
    ARecords.Add(nil);
end;

procedure TdxChartSeriesViewCustomViewData.CalculateSummary(ARecords: TdxFastList);
var
  I: Integer;
begin
  if FSummaryValue <> 0 then
    Exit;
  FSummaryValue := 0;
  FTopValuesSummary := 0;
  if ValueField <> nil then
  begin
    for I := 0 to ARecords.Count - 1 do
      FSummaryValue := FSummaryValue + GetValueAsFloat(ARecords.List[I]);
  end;
  FSummaryValue := FSummaryValue + OthersValue;
end;

procedure TdxChartSeriesViewCustomViewData.Changed;
begin
  View.LayoutChanged;
end;

procedure TdxChartSeriesViewCustomViewData.ClearInfo;
begin
  FVisibleCount := 0;
  FMinValue := nil;
  FMaxValue := nil;
  FSummaryValue := 0;
  FTopValuesSummary := 0;
end;

procedure TdxChartSeriesViewCustomViewData.CheckValue(AValue: TdxChartSeriesValueViewInfo);
begin
  if (FMinValue = nil) or (CompareValue(FMinValue.Value, AValue.Value) = 1) then
    FMinValue := AValue;
  if (FMaxValue = nil) or (CompareValue(FMaxValue.Value, AValue.Value) = -1) then
    FMaxValue := AValue;
  FTopValuesSummary := FTopValuesSummary + AValue.Value;
  Inc(FVisibleCount);
end;

procedure TdxChartSeriesViewCustomViewData.DoCalculate;
begin
  inherited DoCalculate;
  UpdateReferences(Series.Points);
  PrepareValues;
  PostPrepareValues;
end;

function TdxChartSeriesViewCustomViewData.IsSourceValueValid(ARecord: PdxDataRecord): Boolean;
begin
  Result := False;
end;

procedure TdxChartSeriesViewCustomViewData.PostPrepareValues;
begin
end;

procedure TdxChartSeriesViewCustomViewData.PrepareItems(ARecords: TdxFastList);
begin
  View.ViewInfo.PrepareItems(ARecords);
end;

procedure TdxChartSeriesViewCustomViewData.PrepareValues;
var
  ARecords: TdxFastList;
begin
  ClearInfo;
  ARecords := Series.Storage.CreateRecordsList;
  try
    RemoveInvalidValues(ARecords);
    ApplyTopNOptions(ARecords);
    ApplySorting(ARecords);
    PrepareItems(ARecords);
  finally
    FreeAndNil(ARecords);
  end;
end;

procedure TdxChartSeriesViewCustomViewData.RemoveInvalidValues(ARecords: TdxFastList);
var
  I: Integer;
  AEmptyCount: Integer;
begin
  AEmptyCount := 0;
  for I := 0 to ARecords.Count - 1 do
    if not IsSourceValueValid(ARecords.List[I]) then
    begin
      ARecords.List[I] := nil;
      Inc(AEmptyCount);
    end;
  if AEmptyCount > 0 then
    ARecords.Pack();
end;

procedure TdxChartSeriesViewCustomViewData.UpdateReferences(APoints: TdxChartSeriesPoints);
begin
  FArgumentField := APoints.ArgumentField;
  FArgumentOffset := APoints.ArgumentOffset;
  FValueField := APoints.ValueField;
  FValueOffset := APoints.ValueOffset;
end;

{
function TdxChartSeriesViewCustomViewData.GetSeries(AIndex: Integer): TdxChartCustomSeries;
begin
  Result := TdxChartCustomSeries(FSeries.List[AIndex]);
end;

function TdxChartSeriesViewCustomViewData.GetSeriesCount: Integer;
begin
  Result := FSeries.Count;
end;
}

{ TdxChartSeriesPoints }

constructor TdxChartSeriesPoints.Create(AOwner: TdxChartCustomSeries);
begin
  FSeries := AOwner;
  RefreshFields;
end;

procedure TdxChartSeriesPoints.Add(const AArgs: array of const);
begin
  SetRecordData(Storage.Append, AArgs);
end;

procedure TdxChartSeriesPoints.Add(const AValue: Double);
begin
  Add(Count, AValue);
end;

procedure TdxChartSeriesPoints.Add(const AArgument, AValue: Double);
var
  ARecord: PdxDataRecord;
  PValue: PNumericValue;
begin
  ARecord := Storage.Append;
  if ArgumentOffset > 0 then
  begin
    PValue := PNumericValue(TdxNativeUInt(ARecord) + FArgumentOffset);
    PValue.Flag := ValueNotNullFlag;
    PValue.Value := AArgument;
  end
  else
    ARecord.Value[FArgumentField] := AArgument;
  if ValueOffset > 0 then
  begin
    PValue := PNumericValue(TdxNativeUInt(ARecord) + FValueOffset);
    PValue.Flag := ValueNotNullFlag;
    PValue.Value := AValue;
  end
  else
    ARecord.Value[FValueField] := AValue;
  Changed;
end;

procedure TdxChartSeriesPoints.Add(const AArgument, AValue: Variant;
  const AArgumentDisplayText: string = ''; AValueDisplayText: string = '');
begin
  SetRecordData(Storage.Append, AArgument, AValue, AArgumentDisplayText, AValueDisplayText);
end;

procedure TdxChartSeriesPoints.Add(const AArgument: string; const AValue: Double);
var
  ARecord: PdxDataRecord;
  PValue: PNumericValue;
begin
  ARecord := Storage.Append;
  ARecord.Value[FArgumentField] := AArgument;
  if ValueOffset > 0 then
  begin
    PValue := PNumericValue(TdxNativeUInt(ARecord) + FValueOffset);
    PValue.Flag := ValueNotNullFlag;
    PValue.Value := AValue;
  end
  else
    ARecord.Value[FValueField] := AValue;
  Changed;
end;

procedure TdxChartSeriesPoints.Clear;
begin
  Series.DataBinding.ClearRecords;
end;

procedure TdxChartSeriesPoints.Delete(AIndex: Integer; ACount: Integer = 1);
begin
  if not Series.DataBinding.IsSharedStorage then
  begin
    Storage.Delete(AIndex, ACount);
    Changed;
  end;
end;

procedure TdxChartSeriesPoints.Insert(AIndex: Integer; const AArgs: array of const);
begin
  SetRecordData(Storage.Insert(AIndex), AArgs);
end;

procedure TdxChartSeriesPoints.Insert(AIndex: Integer; const AArgument, AValue: Variant;
  const AArgumentDisplayText: string = ''; const AValueDisplayText: string = '');
begin
  SetRecordData(Storage.Insert(AIndex), AArgument, AValue, AArgumentDisplayText, AValueDisplayText);
end;

procedure TdxChartSeriesPoints.Changed;
begin
  if not DataChanged then 
  begin
    FDataChanged := True;
    Series.DataChanged;
  end;
end;

procedure TdxChartSeriesPoints.CheckNumericFastAccess(const AField: TdxStorageItem; var AOffset: Cardinal);
begin
  AOffset := 0;
  if (AField <> nil) and (AField.ValueTypeClass = TcxFloatValueType) then
    AOffset := TdxStorageItemAccess(AField).DataOffset
end;

procedure TdxChartSeriesPoints.RefreshFields;

  function GetFieldFromDataField(AField: TdxChartSeriesCustomDataField): TdxStorageItem;
  begin
    Result := nil;
    if AField <> nil then
      Result := AField.Item;
  end;

begin
  try
    if Series.DataBinding = nil then
    begin
      FStorage := nil;
      FArgumentField := nil;
      FValueField := nil;
      FFields := nil;
      FCustomFields := nil;
      FArgumentOffset := 0;
      FValueOffset := 0;
      Exit;
    end;
    FStorage := Series.DataBinding.Storage;
    FArgumentField := GetFieldFromDataField(Series.DataBinding.ArgumentField);
    FValueField := GetFieldFromDataField(Series.DataBinding.ValueField);
    FFields := Series.DataBinding.FieldList;
    FCustomFields := Series.DataBinding.CustomFields;
    CheckNumericFastAccess(FArgumentField, FArgumentOffset);
    CheckNumericFastAccess(FValueField, FValueOffset);
  finally
    if Series.View <> nil then
      Series.View.ViewData.UpdateReferences(Self);
  end;
end;

procedure TdxChartSeriesPoints.SetRecordData(ARecord: PdxDataRecord; const AArgs: array of const);
begin
end;

procedure TdxChartSeriesPoints.SetRecordData(ARecord: PdxDataRecord; const AArgument, AValue: Variant;
 const AArgumentDisplayText, AValueDisplayText: string);
begin
  ARecord.Value[ArgumentField] := AArgument;
  ARecord.DisplayText[ArgumentField] := AArgumentDisplayText;
  ARecord.Value[ValueField] := AValue;
  ARecord.DisplayText[ValueField] := AValueDisplayText;
  Changed;
end;

function TdxChartSeriesPoints.GetArgumentDisplayText(AIndex: Integer): string;
begin
  Result := ArgumentField.DisplayText[Storage.Records[AIndex]]
end;

function TdxChartSeriesPoints.GetArgumentValue(AIndex: Integer): Variant;
begin
  Result := ArgumentField.Value[Storage.Records[AIndex]]
end;

function TdxChartSeriesPoints.GetCount: Integer;
begin
  if FStorage = nil then
    Result := 0
  else
    Result := Storage.RecordCount;
end;

function TdxChartSeriesPoints.GetField(AIndex: Integer): TdxStorageItem;
begin
  Result := TdxChartSeriesCustomDataField(FFields.List[AIndex]).Item;
end;

function TdxChartSeriesPoints.GetFieldCount: Integer;
begin
  Result := FFields.Count;
end;

function TdxChartSeriesPoints.GetFieldDisplayText(ARecordIndex, AIndex: Integer): string;
begin
  Result := Fields[AIndex].DisplayText[Storage.Records[ARecordIndex]];
end;

function TdxChartSeriesPoints.GetFieldValue(ARecordIndex, AIndex: Integer): Variant;
begin
  Result := Fields[AIndex].Value[Storage.Records[ARecordIndex]];
end;

function TdxChartSeriesPoints.GetValueDisplayText(AIndex: Integer): string;
begin
  Result := ValueField.DisplayText[Storage.Records[AIndex]];
end;

function TdxChartSeriesPoints.GetValueValue(AIndex: Integer): Variant;
begin
  Result := ValueField.Value[Storage.Records[AIndex]];
end;

procedure TdxChartSeriesPoints.SetArgumentDisplayText(AIndex: Integer; const AValue: string);
begin
  ArgumentField.DisplayText[Storage.Records[AIndex]] := AValue;
end;

procedure TdxChartSeriesPoints.SetArgumentValue(AIndex: Integer; const AValue: Variant);
begin
  ArgumentField.Value[Storage.Records[AIndex]] := AValue;
  Changed;
end;

procedure TdxChartSeriesPoints.SetFieldDisplayText(ARecordIndex, AIndex: Integer; const AValue: string);
begin
  Fields[AIndex].DisplayText[Storage.Records[ARecordIndex]] := AValue;
end;

procedure TdxChartSeriesPoints.SetFieldValue(ARecordIndex, AIndex: Integer; const AValue: Variant);
begin
  Fields[AIndex].Value[Storage.Records[ARecordIndex]] := AValue;
end;

procedure TdxChartSeriesPoints.SetValueValue(AIndex: Integer; const AValue: Variant);
begin
  ValueField.Value[Storage.Records[AIndex]] := AValue;
  Changed;
end;

procedure TdxChartSeriesPoints.SetValueDisplayText(AIndex: Integer; const AValue: string);
begin
  ValueField.DisplayText[Storage.Records[AIndex]] := AValue;
end;

{ TdxChartSeriesTopNOptions }

constructor TdxChartSeriesTopNOptions.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FShowOthers := True;
  FValue := DefaultTopNModeValue[Mode];
end;

destructor TdxChartSeriesTopNOptions.Destroy;
begin
  TdxChartTextFormatController.Release(FOthersValueFormatter);
  inherited Destroy;
end;

procedure TdxChartSeriesTopNOptions.Changed;
begin
  Series.Changed(TdxChartCustomSeries.TSeriesChange.Data);
end;

procedure TdxChartSeriesTopNOptions.ChangedIfEnabled;
begin
  if Enabled then
    Changed;
end;

procedure TdxChartSeriesTopNOptions.DoAssign(Source: TPersistent);
var
  AWasEnabled: Boolean;
begin
  inherited DoAssign(Source);
  if Source is TdxChartSeriesTopNOptions then
  begin
    AWasEnabled := FEnabled;
    FMode := TdxChartSeriesTopNOptions(Source).Mode;
    FShowOthers := TdxChartSeriesTopNOptions(Source).ShowOthers;
    FOthersValueFormat := TdxChartSeriesTopNOptions(Source).OthersValueFormat;
    FValue := TdxChartSeriesTopNOptions(Source).Value;
    FEnabled := TdxChartSeriesTopNOptions(Source).Enabled;
    if AWasEnabled or Enabled then
      Changed;
  end;
end;

function TdxChartSeriesTopNOptions.GetOthersDisplayText: string;
begin
  if OthersValueFormat <> '' then
    Result := TdxChartTextFormatController.FormatPattern(FOthersValueFormatter, GetValueByName)
  else
    Result := Series.View.ValueLabels.GetFormattedValue(Series.View.ViewData.OthersValue, GetValueByName);
end;

procedure TdxChartSeriesTopNOptions.ValidateValue(var AValue: Double);
begin
  if Mode = TdxChartSeriesTopNOptionsMode.Count then
    AValue := Max(1, Trunc(AValue))
  else
    if Mode = TdxChartSeriesTopNOptionsMode.ThresholdPercent then
      AValue := Max(MinDouble, Min(100, AValue));
end;

procedure TdxChartSeriesTopNOptions.SetEnabled(AValue: Boolean);
begin
  if AValue <> Enabled then
  begin
    FEnabled := AValue;
    Changed;
  end;
end;

procedure TdxChartSeriesTopNOptions.SetMode(AValue: TdxChartSeriesTopNOptionsMode);
begin
  if AValue <> Mode then
  begin
    FMode := AValue;
    FValue := DefaultTopNModeValue[Mode];
    ChangedIfEnabled;
  end;
end;

procedure TdxChartSeriesTopNOptions.SetOthersValueFormat(AValue: string);
begin
  if AValue <> FOthersValueFormat then
  begin
    FOthersValueFormat := AValue;
    if FOthersValueFormat <> '' then
      TdxChartTextFormatController.Add(FOthersValueFormat, FOthersValueFormatter);
    ChangedIfEnabled;
  end;
end;

procedure TdxChartSeriesTopNOptions.SetShowOthers(AValue: Boolean);
begin
  if AValue <> ShowOthers then
  begin
    FShowOthers := AValue;
    ChangedIfEnabled;
  end;
end;

procedure TdxChartSeriesTopNOptions.SetValue(AValue: Double);
begin
  ValidateValue(AValue);
  if AValue <> Value then
  begin
    FValue := AValue;
    ChangedIfEnabled;
  end;
end;

function TdxChartSeriesTopNOptions.GetSeries: TdxChartCustomSeries;
begin
  Result := TdxChartCustomSeries(GetOwner);
end;

function TdxChartSeriesTopNOptions.GetValueByName(const AName: string; out AValue: Variant): Boolean;
begin
  Result := True;
  if AName = TdxChartTextFormatVariableNames.Value then
    AValue := Series.View.ViewData.OthersValue
  else if AName = TdxChartTextFormatVariableNames.Argument then
    AValue := cxGetResourceString(@sdxChartOtherValueLabel)
  else if AName = TdxChartTextFormatVariableNames.Series then
    AValue := Series.Caption
  else
    Result := False;
end;

function TdxChartSeriesTopNOptions.IsValueStored: Boolean;
begin
  Result := Value <> DefaultTopNModeValue[Mode];
end;

{ TdxChartSeriesToolTipOptions }

constructor TdxChartSeriesToolTipOptions.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FEnabled := True;
end;

destructor TdxChartSeriesToolTipOptions.Destroy;
begin
  TdxChartTextFormatController.Release(FPointToolTipFormatter);
  TdxChartTextFormatController.Release(FSeriesToolTipFormatter);
  inherited Destroy;
end;

procedure TdxChartSeriesToolTipOptions.DoAssign(Source: TPersistent);
var
  ASourceOptions: TdxChartSeriesToolTipOptions;
begin
  inherited DoAssign(Source);
  if Safe.Cast(Source, TdxChartSeriesToolTipOptions, ASourceOptions) then
  begin
    PointToolTipFormat := ASourceOptions.PointToolTipFormat;
    SeriesToolTipFormat := ASourceOptions.SeriesToolTipFormat;
    Enabled := ASourceOptions.Enabled;
  end;
end;

function TdxChartSeriesToolTipOptions.GetPointToolTipFormat: TdxChartTextFormat;
begin
  Result := TdxChartTextFormatController.GetFormat(FPointToolTipFormatter);
end;

function TdxChartSeriesToolTipOptions.GetSeriesToolTipFormat: TdxChartTextFormat;
begin
  Result := TdxChartTextFormatController.GetFormat(FSeriesToolTipFormatter);
end;

procedure TdxChartSeriesToolTipOptions.SetPointToolTipFormat(const Value: TdxChartTextFormat);
begin
  if Value = '' then
    TdxChartTextFormatController.Release(FPointToolTipFormatter)
  else
    TdxChartTextFormatController.Add(Value, FPointToolTipFormatter);
end;

procedure TdxChartSeriesToolTipOptions.SetSeriesToolTipFormat(const Value: TdxChartTextFormat);
begin
  if Value = '' then
    TdxChartTextFormatController.Release(FSeriesToolTipFormatter)
  else
    TdxChartTextFormatController.Add(Value, FSeriesToolTipFormatter);
end;

{ TdxChartCustomSeries }

constructor TdxChartCustomSeries.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FShowInLegend := TdxChartSeriesShowInLegend.Chart;
  FCheckableInLegend := True;
  FVisible := True;
  FColorSchemeIndex := -1;
  CreateSubClasses;
end;

destructor TdxChartCustomSeries.Destroy;
begin
  SetDiagram(nil);
  DestroySubClasses;
  inherited Destroy;
end;

procedure TdxChartCustomSeries.Assign(Source: TPersistent);
begin
  if Source is TdxChartCustomSeries then
  begin
    BeginUpdate;
    try
      FVisible := False;
      AssignFrom(TdxChartCustomSeries(Source));
      Visible := TdxChartCustomSeries(Source).Visible;
    finally
      EndUpdate;
    end;
  end
  else
    inherited Assign(Source);
end;

procedure TdxChartCustomSeries.AssignFrom(ASource: TdxChartCustomSeries);
begin
  FShowInLegend := ASource.ShowInLegend;
  FCheckableInLegend := ASource.CheckableInLegend;
  FStoredName := ASource.StoredName;
  FEmptyPointsDisplayMode := ASource.EmptyPointsDisplayMode;
  if ASource.IsCaptionStored then
    FCaption := ASource.FCaption;
  FSortBy := ASource.SortBy;
  FSortOrder := ASource.SortOrder;
  if ASource.CanHaveTitle and CanHaveTitle then
    Title := ASource.Title;
  ViewClass := ASource.ViewClass;
  DataBindingClass := ASource.DataBindingClass;
  View := ASource.View;
  DataBinding := ASource.DataBinding;
  TopNOptions := ASource.TopNOptions;
  ToolTips := ASource.ToolTips;

end;

function TdxChartCustomSeries.GetParentComponent: TComponent;
begin
  Result := FDiagram;
end;

function TdxChartCustomSeries.HasParent: Boolean;
begin
  Result := True;
end;

procedure TdxChartCustomSeries.SetParentComponent(Value: TComponent);
begin
  if (Value <> nil) and not ((Value is TdxChartCustomDiagram) and TdxChartCustomDiagram(Value).IsCompatibleWith(Self)) then
    raise EdxChartException.CreateFmt('Incompatible series %s class with diagram %s class!', [ClassName, Value.ClassName]);
  SetDiagram(Value as TdxChartCustomDiagram);
end;

function TdxChartCustomSeries.IsCompatibleWithDataBinding(ADataBindingClass: TdxChartSeriesDataBindingClass): Boolean;
begin
  Result := ADataBindingClass.InheritsFrom(GetBaseDataBindingClass) and
    ADataBindingClass.IsCompatibleWidth(TdxChartSeriesClass(ClassType));
end;

function TdxChartCustomSeries.IsCompatibleWithView(AViewClass: TdxChartSeriesViewClass): Boolean;
begin
  Result := AViewClass.InheritsFrom(GetBaseViewClass);
end;

function TdxChartCustomSeries.ActuallyVisible: Boolean;
begin
  Result := Visible and CanVisible;
end;

procedure TdxChartCustomSeries.BiDiModeChanged;
begin
  Title.BiDiModeChanged;
end;

procedure TdxChartCustomSeries.AddToChart(AChart: TdxChart);
begin
  if AChart = nil then
    Exit;
  AChart.DataController.SeriesList.Add(Self);
  DataBinding.UpdateDataControllerReference;
  AChart.DataController.SharedStorageAdd(DataBinding.GetSharedStorageKey, DataBinding);
  AChart.Legend.DataChanged();
end;

function TdxChartCustomSeries.CanVisible: Boolean;
begin
  Result := (View <> nil) and (Diagram <> nil) and Diagram.ActuallyVisible;
end;

procedure TdxChartCustomSeries.ClearLegend;
begin
  if (ShowInLegend = TdxChartSeriesShowInLegend.None) or (Diagram = nil) then
    Exit;
  if ShowInLegend = TdxChartSeriesShowInLegend.Diagram then
    Diagram.Legend.Clear
  else
    if ShowInLegend = TdxChartSeriesShowInLegend.Chart then
      Diagram.Chart.Legend.Clear;
  FChanges := FChanges + LegendChanges[ShowInLegend];
end;

procedure TdxChartCustomSeries.Changed(AChanges: TSeriesChanges);
begin
  if TSeriesChange.Data in AChanges then   
  begin                                    
    if (FPointCount = 0) and ((Points = nil) or (Points.Count = 0)) then
      Exclude(FChanges, TSeriesChange.Data)
    else
    begin
      if Points = nil then
        FPointCount := 0
      else
        FPointCount := Points.Count;
    end;
  end;
  FChanges := FChanges + AChanges;
  if FChanges <> [] then
    inherited Changed;
end;

procedure TdxChartCustomSeries.Changed(AChange: TSeriesChange);
begin
  Changed([AChange]);
end;

procedure TdxChartCustomSeries.CreateSubClasses;
begin
  SetDataBinding(GetBaseDataBindingClass.Create(Self));
  SetViewClass(GetDefaultViewClass);
  FTopNOptions := TdxChartSeriesTopNOptions.Create(Self);
  FTitle := CreateTitle;
  FTitle.Visible := CanHaveTitle;
  FToolTips := TdxChartSeriesToolTipOptions.Create(Self);
end;

function TdxChartCustomSeries.CreateTitle: TdxChartSeriesTitle;
begin
  Result := TdxChartSeriesTitle.Create(Self);
end;

procedure TdxChartCustomSeries.ChangeScale(M, D: Integer);
begin
  View.ChangeScale(M, D);
end;

function TdxChartCustomSeries.ComparePointsBy(P1, P2: Pointer; AField: TdxStorageItem): Integer;
begin
  Result := 0;
  if P1 = P2 then
    Exit
  else
    if (P1 <> nil) and (P2 <> nil) then
    begin
      Result := AField.Compare(P1, P2);
      if SortOrder = TdxSortOrder.soDescending then
        Result := -Result;
    end
    else
      if P1 = nil then
        Result := 1
      else
        if P2 = nil then
          Result := -1;
end;

function TdxChartCustomSeries.ComparePointsByArgument(P1, P2: Pointer): Integer;
begin
  Result := ComparePointsBy(P1, P2, Points.ArgumentField);
end;

function TdxChartCustomSeries.ComparePointsByValue(P1, P2: Pointer): Integer;
begin
  Result := ComparePointsBy(P1, P2, Points.ValueField);
end;

procedure TdxChartCustomSeries.DataChanged;
begin
  Changed(TSeriesChange.Data);
end;

procedure TdxChartCustomSeries.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('ColorSchemeIndex', ReadColorSchemeIndex, WriteColorSchemeIndex, FColorSchemeIndex >= 0);
end;

procedure TdxChartCustomSeries.ReadColorSchemeIndex(Reader: TReader);
begin
  FColorSchemeIndex := Reader.ReadInteger;
end;

procedure TdxChartCustomSeries.WriteColorSchemeIndex(Writer: TWriter);
begin
   Writer.WriteInteger(FColorSchemeIndex);
end;

procedure TdxChartCustomSeries.DestroySubClasses;
begin
  FreeAndNil(FToolTips);
  FreeAndNil(FDataBinding);
  FreeAndNil(FTitle);
  FreeAndNil(FView);
  FreeAndNil(FPoints);
//  FreeAndNil(FArgumentRange);
  FreeAndNil(FTopNOptions);
//  FreeAndNil(FValueRange);
end;

procedure TdxChartCustomSeries.DoChanged;
var
  AChart: TdxChart;
begin
  if FPoints <> nil then
    FPoints.DataChanged := False;
  if (Changes = []) or (Diagram = nil) or (csLoading in ComponentState) then
    Exit;
  AChart := nil;
  if Diagram <> nil then
  begin
    if Changes = [TSeriesChange.Style] then
    begin
      Diagram.Changed(TdxChartCustomDiagram.TDiagramChange.Style);
      Exit;
    end;
    AChart := Diagram.Chart;
    Include(Diagram.Changes, TdxChartCustomDiagram.TDiagramChange.Series);
  end;
  if TSeriesChange.Data in Changes then
  begin
//    FArgumentRange.Clear;
//    FValueRange.Clear;
    View.ViewData.MakeDirty;
  end;
  if (TSeriesChange.ChartLegend in Changes) and (AChart <> nil) then
    AChart.Legend.DataChanged;
  if (TSeriesChange.DiagramLegend in Changes) and (Diagram <> nil) then
    Diagram.Legend.DataChanged;
  View.ViewInfo.Dirty := View.ViewInfo.Dirty or ([TSeriesChange.Data, TSeriesChange.Layout] * Changes <> []);
  Changes := [];
  if Diagram <> nil then
    Diagram.Changed;
end;

procedure TdxChartCustomSeries.DoPopulateLegend(ALegend: TdxChartCustomLegend);
begin
  ALegend.AddItem(Self);
end;

class function TdxChartCustomSeries.GetBaseDataBindingClass: TdxChartSeriesDataBindingClass;
begin
  Result := TdxChartSeriesCustomDataBinding;
end;

class function TdxChartCustomSeries.GetBaseViewClass: TdxChartSeriesViewClass;
begin
  Result := TdxChartSeriesCustomView;
end;

class function TdxChartCustomSeries.GetDefaultViewClass: TdxChartSeriesViewClass;
var
  I: Integer;
begin
  Result := GetBaseViewClass;
  for I := 0 to dxChartRegisteredSeriesView.Count - 1 do
    if dxChartRegisteredSeriesView.Items[I].InheritsFrom(GetBaseViewClass) then
      Exit(TdxChartSeriesViewClass(dxChartRegisteredSeriesView.Items[I]));
end;

function TdxChartCustomSeries.GetStoredName: string;
begin
  Result := FStoredName;
  if Result = '' then
    Result := Name;
end;

function TdxChartCustomSeries.GetSeriesToolTipText: TdxChartTextFormat;
var
  AFormatter: TObject;
begin
  AFormatter := ToolTips.SeriesToolTipFormatter;
  if AFormatter = nil then
    AFormatter := Diagram.ToolTips.SeriesToolTipFormatter;
  if AFormatter = nil then
    Result := Caption
  else
    Result := TdxChartTextFormatController.FormatPattern(AFormatter,
      function(const AName: string; out AValue: Variant): Boolean
      begin
        Result := AName = TdxChartTextFormatVariableNames.Series;
        if Result then
          AValue := Caption;
      end
    );
end;

procedure TdxChartCustomSeries.PopulateLegend(ALegend: TdxChartCustomLegend; ALegendType: TdxChartSeriesShowInLegend);
begin
  if CanVisible and (ShowInLegend = ALegendType) then
    DoPopulateLegend(ALegend);
end;

procedure TdxChartCustomSeries.RemoveFromChart(AChart: TdxChart);
begin
  if (AChart = nil) or (AChart.DataController.SeriesList.Remove(Self) < 0) then
    Exit;
  AChart.Legend.DataChanged;
  AChart.DataController.SharedStorageRemove(DataBinding);
  DataBinding.UpdateDataControllerReference;
end;

procedure TdxChartCustomSeries.SetDataBinding(ADataBinding: TdxChartSeriesCustomDataBinding);
var
  APrevDataBinding: TObject;
begin
  APrevDataBinding := FDataBinding;
  try
    BeginUpdate;
    try
      FDataBinding := ADataBinding;
      FreeAndNil(FPoints);
      if FDataBinding <> nil then
        FPoints := FDataBinding.GetPointsClass.Create(Self);
    finally
      EndUpdate;
    end;
  finally
    FreeAndNil(APrevDataBinding);
  end;
end;

procedure TdxChartCustomSeries.SetDiagram(AValue: TdxChartCustomDiagram);
begin
  if AValue = Diagram then
    Exit;
  if Diagram <> nil then
    Diagram.RemoveSeries(Self);
  FDiagram := nil;
  UpdateParentAppearance;
  FDiagram := AValue;
  if FDiagram <> nil then
  begin
    FDiagram.AddSeries(Self);
    ValidateColorSchemeIndex;
  end;
  UpdateParentAppearance;  
end;

procedure TdxChartCustomSeries.SetName(const NewName: TComponentName);
var
  APrevName: string;
begin
  APrevName := Name;
  inherited SetName(NewName);
  if (Caption = '') or SameText(FCaption, APrevName) then
    Caption := NewName;
end;

procedure TdxChartCustomSeries.UpdateParentAppearance;
var
  AParent: TdxChartVisualElementAppearance;
begin
  AParent := nil;
  if Diagram <> nil then
    AParent := Diagram.Appearance;
  View.Appearance.Parent := AParent;
  if Title <> nil then
    Title.Appearance.Parent := View.Appearance;
end;

function TdxChartCustomSeries.CanChangeVisibility: Boolean;
begin
  Result := CheckableInLegend;
end;

class function TdxChartCustomSeries.CanHaveTitle: Boolean;
begin
  Result := False;
end;

function TdxChartCustomSeries.GetCaption: string;
begin
  Result := FCaption;
  if SameText(Result, Name) and (DataBinding.GetDefaultSeriesCaption <> '') then
    Result := DataBinding.GetDefaultSeriesCaption;
end;

function TdxChartCustomSeries.GetColorSchemeIndex: Integer;
begin
  ValidateColorSchemeIndex;
  Result := FColorSchemeIndex;
end;

procedure TdxChartCustomSeries.UpdateColorSchemeIndexFromSeries(ASeries: TdxChartCustomSeries);
begin
  FColorSchemeIndex := ASeries.FColorSchemeIndex;
end;

function TdxChartCustomSeries.GetDataBindingClass: TdxChartSeriesDataBindingClass;
begin
  Result := TdxChartSeriesDataBindingClass(DataBinding.ClassType);
end;

function TdxChartCustomSeries.GetDataBindingType: string;
begin
  Result := DataBinding.GetTypeName;
end;

function TdxChartCustomSeries.GetDataController: TdxChartDataController;
begin
  if (Diagram <> nil) and (Diagram.Chart <> nil) then
    Result := Diagram.Chart.DataController
  else
    Result := nil;
end;

function TdxChartCustomSeries.GetIndex: Integer;
begin
  Result := -1;
  if Diagram <> nil then
    Result := Diagram.SeriesList.IndexOf(Self);
end;

function TdxChartCustomSeries.GetSource: TObject;
begin
  Result := FSource;
end;

function TdxChartCustomSeries.GetStorage: TdxDataStorage;
begin
  Result := DataBinding.Storage;
end;

function TdxChartCustomSeries.GetViewClass: TdxChartSeriesViewClass;
begin
  if View = nil then
    Result := nil
  else
    Result := TdxChartSeriesViewClass(View.ClassType);
end;

function TdxChartCustomSeries.GetViewType: string;
begin
  if View <> nil then
    Result := View.GetTypeName
  else
    Result := '';
end;

procedure TdxChartCustomSeries.SetCaption(const AValue: string);
begin
  if AValue <> FCaption then
  begin
    FCaption := AValue;
    Changed([TSeriesChange.Data, TSeriesChange.View, TSeriesChange.Layout]);
  end;
end;

procedure TdxChartCustomSeries.SetCheckableInLegend(AValue: Boolean);
begin
  if AValue <> FCheckableInLegend then
  begin
    FCheckableInLegend := AValue;
    Changed(LegendChanges[ShowInLegend]);
  end;
end;

procedure TdxChartCustomSeries.SetDataBindingClass(const AValue: TdxChartSeriesDataBindingClass);
begin
  if (AValue <> DataBindingClass) and IsCompatibleWithDataBinding(AValue) then
  begin
    BeginUpdate;
    try
      SetDataBinding(AValue.Create(Self));
      Changed(TSeriesChange.Data);
    finally
      EndUpdate;
    end;
  end;
end;

procedure TdxChartCustomSeries.SetDataBindingProperty(AValue: TdxChartSeriesCustomDataBinding);
begin
  DataBinding.Assign(AValue);
end;

procedure TdxChartCustomSeries.SetDataBindingType(const AValue: string);
var
  I: Integer;
  ACandidate: TdxChartSeriesDataBindingClass;
begin
  if AValue <> DataBindingType then
  begin
    for I := dxChartRegisteredDataBindings.Count - 1 downto 0 do
    begin
      ACandidate := TdxChartSeriesDataBindingClass(dxChartRegisteredDataBindings.Items[I]);
      if SameText(ACandidate.GetTypeName, AValue) and ACandidate.IsCompatibleWidth(TdxChartSeriesClass(ClassType)) then
      begin
        DataBindingClass := ACandidate;
        Break;
      end;
    end;
  end;
end;

procedure TdxChartCustomSeries.SetEmptyPointsDisplayMode(AValue: TdxChartEmptyPointsDisplayMode);
begin
  if AValue <> FEmptyPointsDisplayMode then
  begin
    FEmptyPointsDisplayMode := AValue;
    Changed(TSeriesChange.Data);
  end;
end;

procedure TdxChartCustomSeries.SetIndex(AValue: Integer);
begin
  if Diagram = nil then
    Exit;
  AValue := Min(Diagram.SeriesCount - 1, Max(0, AValue));
  if AValue <> Index then
  begin
    Diagram.SeriesList.Move(Index, AValue);
    Changed(LegendChanges[ShowInLegend] + [TSeriesChange.Layout]);
  end;
end;

procedure TdxChartCustomSeries.SetShowInLegend(AValue: TdxChartSeriesShowInLegend);
begin
  if AValue <> ShowInLegend then
  begin
    Changes := Changes + LegendChanges[ShowInLegend];
    FShowInLegend := AValue;
    Changed(LegendChanges[ShowInLegend]);
  end;
end;

procedure TdxChartCustomSeries.SetSource(AValue: TObject);
begin
  FSource := AValue;
end;

procedure TdxChartCustomSeries.SetSortBy(AValue: TdxChartSeriesSortBy);
begin
  if AValue <> SortBy then
  begin
    FSortBy := AValue;
    if SortOrder <> TdxSortOrder.soNone then
      Changed(TSeriesChange.Data);
  end;
end;

procedure TdxChartCustomSeries.SetSortOrder(AValue: TdxSortOrder);
begin
  if AValue <> SortOrder then
  begin
    FSortOrder := AValue;
    Changed(TSeriesChange.Data);
  end;
end;

procedure TdxChartCustomSeries.SetTitle(AValue: TdxChartSeriesTitle);
begin
  Title.Assign(AValue);
end;

procedure TdxChartCustomSeries.SetToolTips(AValue: TdxChartSeriesToolTipOptions);
begin
  FToolTips.Assign(AValue);
end;

procedure TdxChartCustomSeries.SetTopNOptions(AValue: TdxChartSeriesTopNOptions);
begin
  TopNOptions.Assign(AValue);
end;

procedure TdxChartCustomSeries.SetView(AValue: TdxChartSeriesCustomView);
begin
  View.Assign(AValue);
end;

procedure TdxChartCustomSeries.SetViewClass(const AValue: TdxChartSeriesViewClass);
begin
  if (AValue <> nil) and (AValue <> ViewClass) then
  begin
    FreeAndNil(FView);
    FView := AValue.Create(Self);
    UpdateParentAppearance;
    Changed([TSeriesChange.Data]);
  end;
end;

procedure TdxChartCustomSeries.SetViewType(const AValue: string);
begin
  ViewClass := TdxChartSeriesViewClass(dxChartRegisteredSeriesView.FindByDescription(AValue));
end;

procedure TdxChartCustomSeries.SetVisible(AValue: Boolean);
begin
  if FVisible <> AValue then
  begin
    if ActuallyVisible then
      Changes := Changes + LegendChanges[ShowInLegend];
    FVisible := AValue;
    if ActuallyVisible then
      Changes := Changes + LegendChanges[ShowInLegend];
    Changed(TSeriesChange.Visible);
  end;
end;

procedure TdxChartCustomSeries.ValidateColorSchemeIndex;

  function HasValue(AValue: Integer): Boolean;
  var 
    I: Integer; 
  begin    
    for I := 0 to Diagram.SeriesCount - 1 do
      if Diagram.Series[I].FColorSchemeIndex = AValue then 
        Exit(True);
    Result := False;
  end;
  
  function GetNextIndex: Integer;
  var 
    I: Integer;
  begin
     Result := 0;
     for I := 0 to Diagram.SeriesCount - 1 do
       if HasValue(Result) then
         Inc(Result)
       else 
         Break;
  end;
  
begin
  if not (csLoading in ComponentState) and (FColorSchemeIndex < 0) then
    FColorSchemeIndex := GetNextIndex;
end;

function TdxChartCustomSeries.IsCaptionStored: Boolean;
begin
  Result := (FCaption <> '') and not SameText(Caption, Name);
end;

function TdxChartCustomSeries.IsDataBindingTypeStored: Boolean;
begin
  Result := DataBindingClass <> GetBaseDataBindingClass;
end;

function TdxChartCustomSeries.IsViewTypeStored: Boolean;
begin
  Result := ViewClass <> GetBaseViewClass;
end;

function TdxChartCustomSeries.IsVisible: Boolean;
begin
  Result := Visible;
end;

procedure TdxChartCustomSeries.Loaded;
begin
  inherited;
  ValidateColorSchemeIndex;
end;

function TdxChartCustomSeries.GetLegendItemCaption: string;
begin
  Result := Caption;
end;

function TdxChartCustomSeries.GetLegendItemColor: TdxAlphaColor;
begin
  Result := View.ViewInfo.GetLegendItemColor;
end;

procedure TdxChartCustomSeries.DrawLegendGlyph(ACanvas: TcxCustomCanvas; const R: TdxRectF);
begin
  View.Appearance.UpdateActualValues(ACanvas);
  if View <> nil then
    View.ViewInfo.DrawLegendGlyph(ACanvas, R);
end;

{ TdxChartSeriesCustomDataField }

constructor TdxChartSeriesCustomDataField.Create(AOwner: TdxChartSeriesCustomDataBinding);
begin
  inherited Create(AOwner, AOwner.Storage, True);
end;

destructor TdxChartSeriesCustomDataField.Destroy;
begin
  DataBinding.Remove(Self);
  inherited Destroy;
end;

function TdxChartSeriesCustomDataField.IsNumeric: Boolean;
begin
  if Item <> nil then
    Result := (Item.ValueTypeClass <> nil) and Item.ValueTypeClass.IsNumeric
  else
    Result := False;
end;

function TdxChartSeriesCustomDataField.IsString: Boolean;
begin
  if Item <> nil then
    Result := (Item.ValueTypeClass <> nil) and Item.ValueTypeClass.IsString
  else
    Result := False;
end;

function TdxChartSeriesCustomDataField.GetDataBinding: TdxChartSeriesCustomDataBinding;
begin
  Result := TdxChartSeriesCustomDataBinding(Owner);
end;

function TdxChartSeriesCustomDataField.GetIndex: Integer;
begin
  Result := DataBinding.FieldList.IndexOf(Self);
end;

function TdxChartSeriesCustomDataField.GetSeries: TdxChartCustomSeries;
begin
  Result := DataBinding.Series;
end;

function TdxChartSeriesCustomDataField.GetStorage: TdxDataStorage;
begin
  Result := DataBinding.Storage;
end;

procedure TdxChartSeriesCustomDataField.Changed;
begin
  DataBinding.Changed;
end;

procedure TdxChartSeriesCustomDataField.DoAssign(Source: TPersistent);
begin
  FieldName := (Source as TdxChartSeriesCustomDataField).FieldName;
  inherited DoAssign(Source);
end;

function TdxChartSeriesCustomDataField.GetDefaultTextStored: Boolean;
begin
  Result := False;
end;

function TdxChartSeriesCustomDataField.GetDefaultValueTypeClass: TcxValueTypeClass;
begin
  Result := TcxFloatValueType;
end;

function TdxChartSeriesCustomDataField.GetFieldName: string;
begin
  if Item <> nil then
    Result := TdxStorageItemAccess(Item).Name
  else
    Result := FFieldName;
end;

procedure TdxChartSeriesCustomDataField.InternalSetItem(AItem: TdxStorageItem);
begin
  if (Item <> AItem)and (Item <> nil) then
    Item.Release;
  if AItem <> nil then
    AItem.AddRef;
  inherited InternalSetItem(AItem);
end;

function TdxChartSeriesCustomDataField.IsValueTypeSupported(AValueTypeClass: TcxValueTypeClass): Boolean;
begin
  Result := (AValueTypeClass <> nil) and DataBinding.IsValueTypeSupported(Self, AValueTypeClass);
end;

procedure TdxChartSeriesCustomDataField.RecreateItem(AStorage: TdxDataStorage);
var
  AItem: TdxStorageItem;
begin
  if AStorage <> nil then
  begin
    AItem := AStorage.ItemByName(FFieldName);
    if AItem = nil then
      AItem := AStorage.AddItem(FFieldName, nil, TcxValueType, False);
    InternalSetItem(AItem);
  end
  else
    InternalSetItem(nil);
end;

procedure TdxChartSeriesCustomDataField.SetFieldName(const AValue: string);
begin
  if (AValue <> FieldName) or (FFieldName = '') then
  begin
    FFieldName := AValue;
    Storage.BeginUpdate;
    try
      if DataBinding.IsSharedStorage and (Storage.ItemByName(AValue) <> nil) then
        InternalSetItem(Storage.ItemByName(AValue))
      else
      begin
        if DataBinding.IsSharedStorage and (Item = nil) then
          InternalSetItem(Storage.AddItem(AValue, nil, TcxValueType, False))
        else
          if Item <> nil then
          begin
            if Item.RefCount = 1 then
              TdxStorageItemAccess(Item).Name := AValue
            else
              RecreateItem(Storage);
          end;
      end;
      DataBinding.Changed;
    finally
      Storage.EndUpdate;
    end;
  end;
end;

{ TdxChartSeriesCustomDataBinding }

constructor TdxChartSeriesCustomDataBinding.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FFields := TcxObjectList.Create(False);
  FCustomFields := TcxObjectList.Create(False);
  FStorage := GetDataStorageClass.Create();
  FStorage.OnChange := StorageChanged;
  UpdateDataControllerReference;
  CreateInternalFields;
end;

destructor TdxChartSeriesCustomDataBinding.Destroy;
begin
  ClearRecords;
  ClearFields;
  FDataController.SharedStorageRemove(Self);
  FreeAndNil(FCustomFields);
  FreeAndNil(FFields);
  FreeAndNil(FStorage);
  inherited Destroy;
end;

procedure TdxChartSeriesCustomDataBinding.DoAssign(Source: TPersistent);
var
  I: Integer;
  AStream: TMemoryStream;
  ASource: TdxChartSeriesCustomDataBinding;
begin
  inherited DoAssign(Source);
  if Source is TdxChartSeriesCustomDataBinding then
  begin
    ASource := TdxChartSeriesCustomDataBinding(Source);
    ClearRecords;
    ClearFields;
    FFields.Clear;
    for I := 0 to ASource.FieldCount - 1 do
      CreateField.DoAssign(ASource.Fields[I]);
    for I := 0 to ASource.CustomFields.Count - 1 do
      CustomFields.Add(Fields[TdxChartSeriesCustomDataField(ASource.CustomFields[I]).Index]);
    FArgumentField := Fields[ASource.ArgumentField.Index];
    FValueField := Fields[ASource.ValueField.Index];
    if not IsSharedStorage then
    begin
      AStream := TMemoryStream.Create;
      try
        ASource.Storage.SaveToStream(AStream);
        AStream.Position := 0;
        FStorage.LoadFromStream(AStream);
      finally
        AStream.Free;
      end;
    end;
    Changed;
  end;
end;

class function TdxChartSeriesCustomDataBinding.IsCompatibleWidth(ASeriesClass: TdxChartSeriesClass): Boolean;
begin
  Result := True;
end;

function TdxChartSeriesCustomDataBinding.GetSeries: TdxChartCustomSeries;
begin
  Result := TdxChartCustomSeries(Owner)
end;

function TdxChartSeriesCustomDataBinding.GetDataController: TdxChartDataController;
begin
  Result := Series.DataController;
end;

function TdxChartSeriesCustomDataBinding.GetField(AIndex: Integer): TdxChartSeriesCustomDataField;
begin
  Result := TdxChartSeriesCustomDataField(FFields.List[AIndex])
end;

function TdxChartSeriesCustomDataBinding.GetFieldCount: Integer;
begin
//  if FFields <> nil thenh
  Result := FFields.Count;
//  else
//    Result := 0;
end;

procedure TdxChartSeriesCustomDataBinding.ReadCustomFields(AReader: TReader);
begin
end;

procedure TdxChartSeriesCustomDataBinding.RestoreDefaultStorage;
begin
  SetStorage(GetDataStorageClass.Create())
end;

procedure TdxChartSeriesCustomDataBinding.SetArgumentField(AValue: TdxChartSeriesCustomDataField);
begin
  FArgumentField.Assign(AValue);
end;

procedure TdxChartSeriesCustomDataBinding.SetStorage(AValue: TdxDataStorage);
var
  APrevStorage: TdxDataStorage;
begin
  if AValue <> Storage then
  begin
    APrevStorage := Storage;
    APrevStorage.BeginUpdate;
    try
      ChangeStorage(AValue);
      Changed;
    finally
      APrevStorage.EndUpdate;
    end;
  end;
end;

procedure TdxChartSeriesCustomDataBinding.SetValueField(AValue: TdxChartSeriesCustomDataField);
begin
  FValueField.Assign(AValue);
end;

procedure TdxChartSeriesCustomDataBinding.UpdateDataControllerReference;
begin
  FDataController := GetDataController;
  if Storage = nil then
    RestoreDefaultStorage;
end;

procedure TdxChartSeriesCustomDataBinding.WriteCustomFields(AWriter: TWriter);
begin
end;

procedure TdxChartSeriesCustomDataBinding.Refresh;
begin
  DataController.RefreshSeriesData(Series);
end;

function TdxChartSeriesCustomDataBinding.CanStored: Boolean;
begin
  Result := False;
end;

procedure TdxChartSeriesCustomDataBinding.ClearRecords;
begin
  if (FSharedLink = nil) or (TdxChartSeriesSharedStorage(FSharedLink).RefCount = 1) then
    Storage.ClearRecords;
end;

procedure TdxChartSeriesCustomDataBinding.ClearFields;
var
  I: Integer;
begin
  for I := FieldCount - 1 downto 0 do
    Fields[I].Free;
end;

procedure TdxChartSeriesCustomDataBinding.Changed;
begin
  Series.Points.RefreshFields;
  Series.DataChanged;
end;

procedure TdxChartSeriesCustomDataBinding.ChangeStorage(ANewStorage: TdxDataStorage);
begin
  FStorage := ANewStorage;
  FSharedLink := nil;
end;

function TdxChartSeriesCustomDataBinding.CreateField: TdxChartSeriesCustomDataField;
begin
  Result := GetFieldClass.Create(Self);
  FFields.Add(Result);
end;

procedure TdxChartSeriesCustomDataBinding.CreateInternalFields;
begin
  FArgumentField := CreateField;
  FValueField := CreateField;
end;

procedure TdxChartSeriesCustomDataBinding.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('CustomFields', ReadCustomFields, WriteCustomFields, CustomFields.Count > 0);
end;

function TdxChartSeriesCustomDataBinding.FieldByName(const AFieldName: string): TdxChartSeriesCustomDataField;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to FieldCount - 1 do
    if SameText(AFieldName, Fields[I].FieldName) then
      Exit(Fields[I]);
end;

function TdxChartSeriesCustomDataBinding.GetFieldClass: TdxChartSeriesDataFieldClass;
begin
  Result := TdxChartSeriesCustomDataField;
end;

function TdxChartSeriesCustomDataBinding.GetDataStorageClass: TdxDataStorageClass;
begin
  Result := TdxDataStorage;
end;

function TdxChartSeriesCustomDataBinding.GetDefaultSeriesCaption: string;
begin
  Result := '';
end;

class function TdxChartSeriesCustomDataBinding.GetPointsClass: TdxChartSeriesPointsClass;
begin
  Result := TdxChartSeriesPoints;
end;

function TdxChartSeriesCustomDataBinding.IsValueTypeSupported(
  AField: TdxChartSeriesCustomDataField; AValueTypeClass: TcxValueTypeClass): Boolean;
begin
  if AValueTypeClass = nil then
    Exit(False);
  if AField = ValueField then
    Result := AValueTypeClass.IsNumeric and (AValueTypeClass <> TcxObjectValueType)
  else
    if AField = ArgumentField then
      Result := (AValueTypeClass.IsNumeric or AValueTypeClass.IsString) and (AValueTypeClass <> TcxObjectValueType)
    else
      Result := True;
end;

function TdxChartSeriesCustomDataBinding.GetSharedStorageKey: TComponent;
begin
  Result := nil;
end;

class function TdxChartSeriesCustomDataBinding.GetTypeName: string;
const
  ViewPrefix = 'Series';
  ViewSuffix = 'DataBinding';
begin
  Result := StringReplace(ClassName, ViewSuffix, '', [rfReplaceAll, rfIgnoreCase]);
  Delete(Result, 1, Pos(ViewPrefix, Result) + Length(ViewPrefix) - 1);
end;

class function TdxChartSeriesCustomDataBinding.IsSharedStorage: Boolean;
begin
  Result := False;
end;

procedure TdxChartSeriesCustomDataBinding.LoadFromStream(AStream: TStream);
var
  AMemoryStream: TMemoryStream;
begin
  AMemoryStream := TMemoryStream.Create;
  try
    AMemoryStream.CopyFrom(AStream, ReadIntegerFunc(AStream));
    AMemoryStream.Position := 0;
    Storage.LoadFromStream(AMemoryStream);
  finally
    AMemoryStream.Free;
  end;
end;

class procedure TdxChartSeriesCustomDataBinding.Register;
begin
  RegisterClass(Self);
  dxChartRegisteredDataBindings.Register(Self, GetTypeName);
end;

procedure TdxChartSeriesCustomDataBinding.Remove(AField: TdxChartSeriesCustomDataField);
begin
  FCustomFields.Remove(AField);
  FFields.Remove(AField);
  if AField = FArgumentField then
    FArgumentField := nil
  else
    if AField = FValueField then
      FValueField := nil;
  Changed;
end;

procedure TdxChartSeriesCustomDataBinding.SaveToStream(AStream: TStream);
var
  AMemoryStream: TMemoryStream;
begin
  AMemoryStream := TMemoryStream.Create;
  try
    try
      Storage.SaveToStream(AMemoryStream);
    finally
      WriteIntegerProc(AStream, AMemoryStream.Size);
      AMemoryStream.Position := 0;
      AStream.CopyFrom(AMemoryStream, AMemoryStream.Size);
    end;
  finally
    AMemoryStream.Free;
  end;
end;

procedure TdxChartSeriesCustomDataBinding.StorageChanged(Sender: TObject);
begin
  Changed;
end;

class procedure TdxChartSeriesCustomDataBinding.UnRegister;
begin
  UnRegisterClass(Self);
  if FRegisteredDataBindings <> nil then 
    dxChartRegisteredDataBindings.Unregister(Self);
end;

{ TdxChartDataController }

constructor TdxChartDataController.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FSeries := TdxFastObjectList.Create(False);
  FSharedStorages := TdxFastObjectList.Create();
end;

destructor TdxChartDataController.Destroy;
begin
  if FEmptySharedStorage <> nil then
    TdxChartSeriesSharedStorage(FEmptySharedStorage).Release;
  FreeAndNil(FSeries);
  FreeAndNil(FSharedStorages);
  inherited Destroy;
end;

procedure TdxChartDataController.ClearAllRecords;
var
  I: Integer;
begin
  for I := 0 to FSharedStorages.Count - 1 do
    TdxChartSeriesSharedStorage(FSharedStorages[I]).Storage.ClearRecords;
  for I := 0 to SeriesList.Count - 1 do
    TdxChartCustomSeries(SeriesList[I]).DataBinding.ClearRecords;
end;

procedure TdxChartDataController.ForEachSeries(AProc: TForEachSeriesProc);
var
  I: Integer;
begin
  for I := 0 to SeriesList.Count - 1 do
    AProc(TdxChartCustomSeries(SeriesList.List[I]));
end;

function TdxChartDataController.GetSeriesByName(const AName: string; ASeriesList: TList = nil): TdxChartCustomSeries;
var
  I, ACount: Integer;
  AList: PdxPointerList;
begin
  Result := nil;
  ACount := SeriesList.Count;
  AList := SeriesList.List;
  if ASeriesList <> nil then
  begin
    ACount := ASeriesList.Count;
    AList := PdxPointerList(ASeriesList.List);
  end;
  for I := 0 to ACount - 1 do
    if TdxChartCustomSeries(AList[I]).GetStoredName = AName then
      Exit(TdxChartCustomSeries(AList[I]));
end;

procedure TdxChartDataController.LoadFromStream(AStream: TStream);
var
  I: Integer;
  AList: TList;
  AHeader: TdxChartStreamHeader;
  AReader: TcxReader;
  ASeries: TdxChartCustomSeries;
begin
  AList := TList.Create;
  try
    PopulateStoredSeries(AList);
    AReader := TcxReader.Create(AStream);
    try
      AStream.ReadBuffer(AHeader, SizeOf(AHeader));
      if not CompareMem(@AHeader.ID, @DefaultStreamHeader.ID, SizeOf(DefaultStreamHeader.ID)) then
      begin
        AStream.Position := AStream.Position - SizeOf(AHeader);
        raise EdxChartException.Create('Invalid stream format');
      end;
      if (AList.Count > 0) and (AHeader.SeriesCount > 0) and (AStream.Position + AHeader.Size <= AStream.Size) then
      try
        Inc(AHeader.Size, AStream.Position);
        for I := 0 to AList.Count - 1 do
          TdxChartCustomSeries(AList[I]).Points.Clear;
        while AStream.Position < AHeader.Size do
        begin
          ASeries := GetSeriesByName(AReader.ReadString, AList);
          if ASeries <> nil then
          begin
            ASeries.DataBinding.LoadFromStream(AStream);
            AList.Remove(ASeries);
          end
          else
            AStream.Position := AStream.Position + AReader.ReadInteger;
        end;
      finally
        AStream.Position := AHeader.Size;
      end;
    finally
      AReader.Free;
    end;
  finally
    AList.Free;
    AStream.Position := AHeader.Size;
  end;
end;

procedure TdxChartDataController.SaveToStream(AStream: TStream);
var
  I: Integer;
  AList: TList;
  AWriter: TcxWriter;
  AHeader: TdxChartStreamHeader;
begin
  AList := TList.Create;
  try
    PopulateStoredSeries(AList);
    if AList.Count = 0 then
      Exit;
    AHeader := DefaultStreamHeader;
    AHeader.SeriesCount := AList.Count;
    AWriter := TcxWriter.Create(AStream);
    try
      AStream.WriteBuffer(AHeader, SizeOf(AHeader));
      AHeader.Size := AStream.Position;
      for I := 0 to AList.Count - 1 do
      begin
        AWriter.WriteString(TdxChartCustomSeries(AList[I]).GetStoredName);
        TdxChartCustomSeries(AList[I]).DataBinding.SaveToStream(AStream);
      end;
      I := AStream.Position;
      AStream.Position := AHeader.Size - 6; 
      AWriter.WriteInteger(I - AHeader.Size);
      AStream.Position := I;
    finally
      AWriter.Free;
    end;
  finally
    AList.Free;
  end;
end;

procedure TdxChartDataController.SharedStorageAdd(AKey: TComponent; ADataBinding: TdxChartSeriesCustomDataBinding);

  function IsSharedKeyFound(ASharedStorage: TdxChartSeriesSharedStorage): Boolean;
  var
    AStorage: TdxDataStorage;
  begin
    Result := ASharedStorage.Key = AKey;
    if not Result then
      Exit;
    ASharedStorage.AddRef;
    AStorage := ADataBinding.Storage;
    try
      ADataBinding.SetStorage(ASharedStorage.Storage);
      ADataBinding.FSharedLink := ASharedStorage;
    finally
      FreeAndNil(AStorage);
    end;
  end;

var
  I: Integer;
begin
  if not ADataBinding.IsSharedStorage then
    Exit;
  if AKey <> nil then
  begin
    for I := 0 to FSharedStorages.Count - 1 do
      if IsSharedKeyFound(TdxChartSeriesSharedStorage(FSharedStorages[I])) then
        Exit;
  end;
  if ADataBinding.Storage = nil then
    ADataBinding.RestoreDefaultStorage;
  ADataBinding.FSharedLink := TdxChartSeriesSharedStorage.Create(AKey, ADataBinding.Storage);
  TdxChartSeriesSharedStorage(ADataBinding.FSharedLink).Storage.OnChange := StorageDataChanged;
  FSharedStorages.Add(ADataBinding.FSharedLink);
end;

procedure TdxChartDataController.SharedStorageRemove(ADataBinding: TdxChartSeriesCustomDataBinding);
var
  ASharedStorage: TdxChartSeriesSharedStorage;
begin
  if ADataBinding.FSharedLink = nil then
    Exit;
  ASharedStorage := TdxChartSeriesSharedStorage(ADataBinding.FSharedLink);
  ADataBinding.RestoreDefaultStorage;
  if ASharedStorage.Release = 0 then
  begin
    ASharedStorage.Storage.OnChange := nil;
    FSharedStorages.Remove(ASharedStorage);
  end;
end;

procedure TdxChartDataController.AddSeries(ASeries: TdxChartCustomSeries);
begin
  SeriesList.Add(ASeries);
end;

procedure TdxChartDataController.PopulateStoredSeries(AList: TList);
begin
  AList.Capacity := SeriesList.Count;
  ForEachSeries(
    procedure(ASeries: TdxChartCustomSeries)
    begin
      if ASeries.DataBinding.CanStored then
        AList.Add(ASeries);
    end);
end;

procedure TdxChartDataController.RefreshSeriesData(ASeries: TdxChartCustomSeries);
begin
  ASeries.Changed(TdxChartCustomSeries.TSeriesChange.Data);
end;

procedure TdxChartDataController.RemoveSeries(ASeries: TdxChartCustomSeries);
begin
  SeriesList.Remove(ASeries);
end;

procedure TdxChartDataController.StorageDataChanged(Sender: TObject);
begin
  ForEachSeries(
    procedure(ASeries: TdxChartCustomSeries)
    begin
      if ASeries.DataBinding.Storage = Sender then
        ASeries.DataBinding.Changed;
    end);
end;

function TdxChartDataController.GetChart: TdxChart;
begin
  Result := TdxChart(Owner);
end;

{ TdxChartLegendAppearance }

constructor TdxChartLegendAppearance.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FCaptionOffset := DefaultCaptionOffset;
  FImageOffset := DefaultImageOffset;
  FImageSize := TdxSizeFloat.Create(Self, DefaultImageSize);
  FImageSize.OnChange := SizeChangeHandler;
  FItemIndent := TdxSizeFloat.Create(Self, DefaultItemIndent);
  FItemIndent.OnChange := SizeChangeHandler;
  FItemBoxPadding := TcxMargin.Create(Self, DefaultMargins);
  FItemBoxPadding.OnChange := SizeChangeHandler;
end;

function TdxChartLegendAppearance.DefaultBorder: Boolean;
begin
  Result := True;
end;

destructor TdxChartLegendAppearance.Destroy;
begin
  FreeAndNil(FItemBoxPadding);
  FreeAndNil(FImageSize);
  FreeAndNil(FItemIndent);
  inherited Destroy;
end;

procedure TdxChartLegendAppearance.ChangeScaleCore(M, D: Integer);
begin
  inherited ChangeScaleCore(M, D);
  FCaptionOffset := dxScale(FCaptionOffset, M, D);
  FImageOffset := dxScale(FImageOffset, M, D);
  FImageSize.ChangeScale(M, D);
  FItemIndent.ChangeScale(M, D);
  FItemBoxPadding.ChangeScale(M, D);
end;

procedure TdxChartLegendAppearance.DoAssign(Source: TPersistent);
var
  ASource: TdxChartLegendAppearance;
begin
  inherited DoAssign(Source);
  if Source is TdxChartLegendAppearance then
  begin
    ASource := TdxChartLegendAppearance(Source);
    CaptionOffset := ASource.CaptionOffset;
    ImageOffset := ASource.ImageOffset;
    ImageSize.Assign(ASource.ImageSize);
    ItemIndent.Assign(ASource.ItemIndent);
    ItemBoxPadding := ASource.Margins;
  end;
end;

function TdxChartLegendAppearance.GetActualColor(AIndex: Integer): TdxAlphaColor;
begin
  case AIndex of
    BorderColorIndex:
      Result := ColorScheme.Legend.BorderColor;
    ColorIndex:
      Result := ColorScheme.Legend.BackgroundColor;
    TextColorIndex:
      Result := ColorScheme.Legend.TextColor;
  else
    Result := inherited GetActualColor(AIndex)
  end;
end;

function TdxChartLegendAppearance.GetActualItemBoxPadding: TRect;
begin
  Result := ItemBoxPadding.Margin;
end;

function TdxChartLegendAppearance.GetActualMargins: TRect;
begin
  Result := ColorScheme.Legend.Padding.DeflateToTRect;
end;

function TdxChartLegendAppearance.HasFillOptions: Boolean;
begin
  Result := True;
end;

function TdxChartLegendAppearance.HasFontOptions: Boolean;
begin
  Result := True;
end;

procedure TdxChartLegendAppearance.UpdateActualValues(ACanvas: TcxCustomCanvas);
begin
  FActualCheckBoxSize := LookAndFeelPainter.ScaledCheckButtonAreaSize(ScaleFactor);
  FActualItemBoxPadding := ItemBoxPadding.Margin;
  inherited UpdateActualValues(ACanvas);
end;

function TdxChartLegendAppearance.GetFontOptions: TdxChartVisualElementFontOptions;
begin
  Result := TdxChartVisualElementFontOptions(inherited FontOptions);
end;

function TdxChartLegendAppearance.IsCaptionOffsetStored: Boolean;
begin
  Result := not SameValue(FCaptionOffset, DefaultCaptionOffset);
end;

function TdxChartLegendAppearance.IsImageOffsetStored: Boolean;
begin
  Result := not SameValue(FImageOffset, DefaultImageOffset);
end;

procedure TdxChartLegendAppearance.SetCaptionOffset(AValue: Single);
begin
  if AValue <> FCaptionOffset then
  begin
    FCaptionOffset := AValue;
    Changed(TAppearanceChange.Size);
  end;
end;

procedure TdxChartLegendAppearance.SetFontOptions(AValue: TdxChartVisualElementFontOptions);
begin
  inherited FontOptions := AValue;
end;

procedure TdxChartCustomLegend.SetDirection(AValue: TdxChartLegendDirection);
begin
  if AValue <> FDirection then
  begin
    FDirection := AValue;
    LayoutChanged;
  end;
end;

procedure TdxChartLegendAppearance.SetImageOffset(AValue: Single);
begin
  if AValue <> FImageOffset then
  begin
    FImageOffset := AValue;
    Changed(TAppearanceChange.Size);
  end;
end;

procedure TdxChartLegendAppearance.SetImageSize(const AValue: TdxSizeFloat);
begin
  ImageSize.Assign(AValue);
end;

procedure TdxChartLegendAppearance.SetItemIndent(AValue: TdxSizeFloat);
begin
  ItemIndent.Assign(AValue);
end;

procedure TdxChartLegendAppearance.SetItemBoxPadding(AValue: TcxMargin);
begin
  ItemBoxPadding.Assign(AValue);
end;

procedure TdxChartLegendAppearance.SizeChangeHandler(Sender: TObject);
begin
  Changed(TAppearanceChange.Size);
end;

{ TdxChartFormatSettings }

procedure TdxChartFormatSettings.UpdateSettings;
const
  AListSeparator: array[Boolean] of Char = (',', ';');
begin
  inherited UpdateSettings;
  CurrencyFormat := dxFormatSettings.CurrencyString;
  Data.ListSeparator := dxFormatSettings.ListSeparator;
  Data.DecimalSeparator := dxFormatSettings.DecimalSeparator;
  if ListSeparator = DecimalSeparator then
    ListSeparator := AListSeparator[DecimalSeparator = ','];
  UpdateOperations;
end;

function TdxChartFormatSettings.GetLocaleID: Integer;
begin
  Result := GetThreadLocale;
end;

{ TdxChartTextPatternController }

constructor TdxChartTextFormatController.Create;
begin
  FFormats := TdxSpreadSheetFormats.Create(nil);
  FSettings := TdxChartFormatSettings.Create;
  FChartFormats := TdxChartFormats.Create;
  cxFormatController.AddListener(Self);
  dxResourceStringsRepository.AddListener(Self);
end;

destructor TdxChartTextFormatController.Destroy;
begin
  cxFormatController.RemoveListener(Self);
  dxResourceStringsRepository.RemoveListener(Self);
  Release(FSimpleSeriesCenteredTotalValueTextFormatter);
  Release(FSimpleSeriesTotalValueFormatter);
  Release(FSimpleSeriesDefaultFormatter);
  Release(FPointToolTipDefaultFormatter);
  Release(FXYSeriesPointToolTipDefaultFormatter);
  FreeAndNil(FFormats);
  FreeAndNil(FSettings);
  FreeAndNil(FChartFormats);
  inherited Destroy;
end;

procedure TdxChartTextFormatController.FormatChanged;
begin
  TdxSpreadSheetFormatSettings(FormatController.Settings).UpdateSettings;
  TdxSpreadSheetFormats(FFormats).PredefinedFormats.Refresh;
  if not ChangeHandler.Empty then
    ChangeHandler.Invoke(Self);
end;

class function TdxChartTextFormatController.FormatController: TdxChartTextFormatController;
begin
  if FInstance = nil then
    FInstance := TdxChartTextFormatController.Create;
  Result := FInstance;
end;

class function TdxChartTextFormatController.Add(const AFormat: string; var AHandler: TObject; ALocaleID: Integer): Boolean;
var
  AFormatCode: string;
  ANewHandler: TdxChartValueTextCalculator;
begin
  AFormatCode := AFormat;
  ANewHandler := FormatController.ChartFormats.AddFormat(AFormat);
  Result := ANewHandler <> AHandler;
  if Result then
    dxChangeHandle(TdxChartValueTextCalculator(AHandler), ANewHandler);
end;

class function TdxChartTextFormatController.FormatValue(const AValue: Variant; AFormat: TObject): string;
var
  AFormattedValue: TdxSpreadSheetNumberFormatResult;
  AValueType: TdxSpreadSheetCellDataType;
  AVarType: TVarType;
begin
  System.TMonitor.Enter(FInstance);
  try
    AFormattedValue.Reset;
    if AFormat = nil then
      AFormat := FormatController.Formats.DefaultFormat;
    AVarType := VarType(AValue);
    case AVarType of
      varBoolean:
        AValueType := cdtBoolean;
      varCurrency:
        AValueType := cdtCurrency;
      varSmallInt,
      varInteger,
      varShortInt,
      varByte,
      varWord,
      varLongWord,
      varInt64,
      varUInt64:
        AValueType := cdtInteger;
      varSingle,
      varDouble:
        AValueType := cdtFloat;
      varDate:
        AValueType := cdtDateTime;
      varOleStr,
      varString,
      varUString:
        Exit(AValue); 
      else
      {$IFNDEF NONDB}
        if (AVarType = VarSQLTimeStamp) or (AVarType = varSQLTimeStampOffset) then
          AValueType := cdtDateTime
        else
        if AVarType = VarFMTBcd then
          AValueType := cdtFloat
        else
      {$ENDIF}
        AValueType := cdtFloat;
    end;
    TdxSpreadSheetFormatHandle(AFormat).Format(AValue, AValueType, FormatController.Settings, AFormattedValue);
    Result := AFormattedValue.Text;
  finally
    System.TMonitor.Exit(FInstance);
  end;
end;

class function TdxChartTextFormatController.FormatValue(const AValue: Variant; AFormat: TObject;
  const AFormatSettings: TFormatSettings): string;
var
  AData: TFormatSettings;
begin
  AData := TdxSpreadSheetFormatSettings(FormatController.Settings).Data;
  try
    TdxSpreadSheetFormatSettings(FormatController.Settings).Data := AFormatSettings;
    Result := FormatValue(AValue, AFormat);
  finally
    TdxSpreadSheetFormatSettings(FormatController.Settings).Data := AData;
  end;
end;

class function TdxChartTextFormatController.FormatPattern(AFormatter: TObject;
  const AGetVariable: TdxChartNamedValueProvider): string;
var
  AValue: Variant;
begin
  if Assigned(AFormatter) and ((AFormatter as TdxChartValueTextCalculator).Pattern <> '') then
    Result := (AFormatter as TdxChartValueTextCalculator).Format(AGetVariable)
  else
  begin
    if AGetVariable(TdxChartTextFormatVariableNames.Value, AValue) then
      Result := FormatValue(AValue, FormatController.Formats.DefaultFormat)
    else
      Result := '';
  end;
end;

class function TdxChartTextFormatController.GetFormat(AFormat: TObject): string;
begin
  if AFormat = nil then
    Result := ''
  else
    Result := TdxChartValueTextCalculator(AFormat).Pattern;
end;

class function TdxChartTextFormatController.GetFormatByID(const AID: Integer): TObject;
var
  I: Integer;
  AList: TStringList;
begin
  Result := nil;
  AList := TStringList.Create;
  try
    PopulatePredefinedFormats(AList);
    for I := 0 to AList.Count - 1 do
      if (TdxSpreadSheetFormatHandle(AList.Objects[I]).FormatCodeID = AID) then
        Exit(TdxSpreadSheetFormatHandle(AList.Objects[I]));
  finally
    AList.Free;
  end;
end;

function TdxChartTextFormatController.GetPointToolTipDefaultFormatter: TObject;
begin
  if not Assigned(FPointToolTipDefaultFormatter) then
    TdxChartTextFormatController.Add(sdxChartControlPointToolTipDefaultFormat, FPointToolTipDefaultFormatter);
  Result := FPointToolTipDefaultFormatter;
end;

function TdxChartTextFormatController.GetSimpleSeriesDefaultFormatter: TObject;
begin
  if not Assigned(FSimpleSeriesDefaultFormatter) then
    TdxChartTextFormatController.Add(sdxChartControlSimpleSeriesDefaultFormat, FSimpleSeriesDefaultFormatter);
  Result := FSimpleSeriesDefaultFormatter;
end;

function TdxChartTextFormatController.GetSimpleSeriesCenteredTotalValueTextFormatter: TObject;
begin
  if not Assigned(FSimpleSeriesCenteredTotalValueTextFormatter) then
    TdxChartTextFormatController.Add(cxGetResourceString(@sdxChartControlSimpleSeriesTotalCenteredLabel), FSimpleSeriesCenteredTotalValueTextFormatter);
  Result := FSimpleSeriesCenteredTotalValueTextFormatter;
end;

function TdxChartTextFormatController.GetSimpleSeriesTotalValueFormatter: TObject;
begin
  if not Assigned(FSimpleSeriesTotalValueFormatter) then
    TdxChartTextFormatController.Add(cxGetResourceString(@sdxChartControlSimpleSeriesTotalLabel), FSimpleSeriesTotalValueFormatter);
  Result := FSimpleSeriesTotalValueFormatter;
end;

class function TdxChartTextFormatController.GetSpreadsheetValueFormatter(const AFormatCode: string): TdxSpreadSheetFormatHandle;
var
  I: Integer;
begin
  Result := nil;
  for I := Low(dxChartAdditionalFormatters) to High(dxChartAdditionalFormatters) do
    if dxChartAdditionalFormatters[I].FormatCode = AFormatCode then
    begin
      Result := FormatController.Formats.AddFormat(AFormatCode, dxChartAdditionalFormatters[I].FormatCodeID);
      if not Assigned(TdxNumberFormatAccess(Result).FFormatter) then
        TdxNumberFormatAccess(Result).FFormatter := TdxChartCustomDateTimeNumberFormat.Create(AFormatCode, dxChartAdditionalFormatters[I].FormatCodeID);
      Exit;
    end;
  if (AFormatCode <> '') and not SameText(AFormatCode, 'General') then
    Result := FormatController.Formats.AddFormat(AFormatCode);
end;

function TdxChartTextFormatController.GetXYSeriesPointToolTipDefaultFormatter: TObject;
begin
  if not Assigned(FXYSeriesPointToolTipDefaultFormatter) then
    TdxChartTextFormatController.Add(sdxChartControlXYSeriesPointToolTipDefaultFormat, FXYSeriesPointToolTipDefaultFormatter);
  Result := FXYSeriesPointToolTipDefaultFormatter;
end;

class procedure TdxChartTextFormatController.PopulatePredefinedFormats(AList: TStrings);
var
  I: Integer;
  AFormats: TdxFastObjectList;
begin
  AFormats := TdxFastObjectList.Create(False);
  try
    GetSpreadsheetValueFormatter('c');
    GetSpreadsheetValueFormatter('ddddd');
    GetSpreadsheetValueFormatter('dddddd'); 
    GetSpreadsheetValueFormatter('t');
    GetSpreadsheetValueFormatter('tt');
    TdxSpreadSheetFormatsAccess(FormatController.Formats).ForEach(
      procedure(AItem: TdxDynamicListItem)
      var
        AFormat: TdxSpreadSheetFormatHandle absolute AItem;
      begin
        if Pos('[', AFormat.FormatCode) = 0 then 
          AFormats.Add(AItem);
      end);
    AFormats.SortList(
      function(AItem1, AItem2: Pointer): Integer
      var
        AFormat1: TdxSpreadSheetFormatHandle absolute AItem1;
        AFormat2: TdxSpreadSheetFormatHandle absolute AItem2;
      begin
        if AFormat1 = AFormat2 then
          Result := 0
        else
          if AFormat1 = FInstance.Formats.DefaultFormat then
            Result := -1
          else
            if AFormat2 = FInstance.Formats.DefaultFormat then
              Result := 1
            else
              Result := dxCompareValues(AFormat1.FormatCodeID, AFormat2.FormatCodeID);
      end, True);
    AList.BeginUpdate;
    try
      for I := 0 to AFormats.Count - 1 do
        AList.AddObject(GetFormat(AFormats.Items[I]), AFormats.Items[I]);
    finally
      AList.EndUpdate;
    end;
  finally
    AFormats.Free;
  end;
end;

class procedure TdxChartTextFormatController.Release(var AHandler: TObject);
begin
  dxChangeHandle(TdxChartValueTextCalculator(AHandler), nil);
end;

procedure TdxChartTextFormatController.TranslationChanged;
begin
  Release(FSimpleSeriesCenteredTotalValueTextFormatter);
  Release(FSimpleSeriesTotalValueFormatter);
end;

{ TdxChartDragAndDropObjectBase }

procedure TdxChartDragAndDropObjectBase.Init(ADiagram: TdxChartCustomDiagram; AStartPoint: TPoint);
begin
  FDiagram := ADiagram;
  FStartPoint := AStartPoint;
  FDiagramViewInfo := ADiagram.ViewInfo;
end;

function TdxChartDragAndDropObjectBase.ProcessKeyDown(AKey: Word;
  AShiftState: TShiftState): Boolean;
begin
  Result := AKey in [vkShift, vkControl, vkMenu];
end;

function TdxChartDragAndDropObjectBase.ProcessKeyUp(AKey: Word;
  AShiftState: TShiftState): Boolean;
begin
  Result := AKey in [vkShift, vkControl, vkMenu];
end;

{ TConnectionPointFinder }

class function TConnectionPointFinder.GetNearest(const APoint: TdxPointF; const ARect: TdxRectF): TdxPointF;
var
  AConnectionPoints: array [0..15] of TdxPointF;
  AMinSquareDistance, ASquareDistance: Single;
  I, AMinSquareDistanceIndex: Integer;
begin
  AConnectionPoints[0].Init(ARect.Left, ARect.Top);
  AConnectionPoints[1].Init(ARect.Left + ARect.Width / 3, ARect.Top);
  AConnectionPoints[2].Init(ARect.Left + ARect.Width / 2, ARect.Top);
  AConnectionPoints[3].Init(ARect.Right - ARect.Width / 3, ARect.Top);
  AConnectionPoints[4].Init(ARect.Right, ARect.Top);
  AConnectionPoints[5].Init(ARect.Right, ARect.Top + ARect.Height / 3);
  AConnectionPoints[6].Init(ARect.Right, ARect.Top + ARect.Height / 2);
  AConnectionPoints[7].Init(ARect.Right, ARect.Bottom - ARect.Height / 3);
  AConnectionPoints[8].Init(ARect.Right, ARect.Bottom);
  AConnectionPoints[9].Init(ARect.Right - ARect.Width / 3, ARect.Bottom);
  AConnectionPoints[10].Init(ARect.Right - ARect.Width / 2, ARect.Bottom); // Default point
  AConnectionPoints[11].Init(ARect.Left + ARect.Width / 3, ARect.Bottom);
  AConnectionPoints[12].Init(ARect.Left, ARect.Bottom);
  AConnectionPoints[13].Init(ARect.Left, ARect.Bottom - ARect.Height / 3);
  AConnectionPoints[14].Init(ARect.Left, ARect.Bottom - ARect.Height / 2);
  AConnectionPoints[15].Init(ARect.Left, ARect.Top + ARect.Height / 3);

  AMinSquareDistance := MaxSingle;
  AMinSquareDistanceIndex := 10;
  for I := 0 to 15 do
  begin
    ASquareDistance := GetSquareDistance(APoint, AConnectionPoints[I]);
    if ASquareDistance < AMinSquareDistance then
    begin
      AMinSquareDistance := ASquareDistance;
      AMinSquareDistanceIndex := I;
    end;
  end;

  Result := AConnectionPoints[AMinSquareDistanceIndex];
end;

class function TConnectionPointFinder.GetSquareDistance(const APoint1, APoint2: TdxPointF): Single;
begin
  Result := Sqr(APoint1.X - APoint2.X) + Sqr(APoint1.Y - APoint2.Y);
end;

{ TdxChartCustomDateTimeNumberFormat }

constructor TdxChartCustomDateTimeNumberFormat.Create(const AFormatCode: string; AFormatCodeId: Integer);
begin
  inherited Create(AFormatCode, AFormatCodeId);
  FFormatCode := AFormatCode;
end;

procedure TdxChartCustomDateTimeNumberFormat.Format(const AValue: Variant;
  AValueType: TdxSpreadSheetCellDataType; const AFormatSettings: TdxSpreadSheetCustomFormatSettings;
  var AResult: TdxSpreadSheetNumberFormatResult);
begin
  if FFormatCode = UseSystemLongDateCode then
    AResult.Text := DateToLongDateStr(AValue)
  else
    AResult.Text := FormatDateTime(FFormatCode, AValue);
end;

function TdxChartCustomDateTimeNumberFormat.GetFormatCode(const ALocaleID: Integer): string;
begin
  Result := FFormatCode;
end;

{ TValueTextCalculator.TItem }

constructor TdxChartValueTextCalculator.TItem.Create(const AText: string; AHandler: TdxSpreadSheetFormatHandle = nil);
begin
  FText := AText;
  FHandler := AHandler;
end;

destructor TdxChartValueTextCalculator.TItem.Destroy;
begin
  if FHandler <> nil then
    dxChangeHandle(FHandler, nil);
  inherited Destroy;
end;

function TdxChartValueTextCalculator.TItem.GetText(ACalculator: TdxChartValueTextCalculator): string;
var
  AValue: Variant;
begin
  if FHandler <> nil then
  begin
    if ACalculator.GetVariable(FText, AValue) then
      Result := TdxChartTextFormatController.FormatValue(AValue, FHandler)
    else
      Result := SysUtils.Format('<Variable "%s" not found!>', [FText]);
  end
  else
    Result := FText;
end;

{ TValueTextCalculator }

procedure TdxChartValueTextCalculator.CalculateHash(var AHash: Integer);
begin
  AHash := 0;
  AddToHash(AHash, FPattern);
end;

destructor TdxChartValueTextCalculator.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

function TdxChartValueTextCalculator.Parse(const APattern: string): Boolean;
begin
  FItems.Free;
  FItems := TObjectList<TItem>.Create;
  FPattern := Trim(APattern);
  if Trim(FPattern) = '' then
    Exit(True);
  FCurrent := PChar(FPattern);
  FResult := TStringBuilder.Create;
  try
    while FCurrent^ <> #0 do
    begin
      if FCurrent^ = '{' then
      begin
        Inc(FCurrent);
        if FCurrent^ = '{' then
        begin
          FResult.Append(FCurrent^);
          Inc(FCurrent);
        end
        else
          ParseVariable;
      end
      else
        if FCurrent^ = '}' then
        begin
          Inc(FCurrent);
          if FCurrent^ = '}' then
          begin
            FResult.Append(FCurrent^);
            Inc(FCurrent);
          end
          else
            Exit(False);
        end
        else
        begin
          FResult.Append(FCurrent^);
          Inc(FCurrent);
        end;
    end;
    FlushText;
    Result := True;
  finally
    FResult.Free;
  end;
end;

function TdxChartValueTextCalculator.DoIsEqual(const AItem: TdxHashTableItem): Boolean;
var
  ACalcItem: TdxChartValueTextCalculator absolute AItem;
begin
  Result := FPattern = ACalcItem.FPattern;
end;

procedure TdxChartValueTextCalculator.FlushText;
begin
  if FResult.Length > 0 then
  begin
    FItems.Add(TItem.Create(FResult.ToString));
    FResult.Clear;
  end;
end;

procedure TdxChartValueTextCalculator.FlushVariable(const AName: string; AHandler: TdxSpreadSheetFormatHandle);
begin
  if AName <> '' then
  begin
    FItems.Add(TItem.Create(AName, AHandler));
    FResult.Clear;
  end;
end;

function TdxChartValueTextCalculator.Format(const AGetVariable: TdxChartNamedValueProvider): string;
var
  I: Integer;
begin
  if (FItems = nil) or (FItems.Count = 0) then
    Exit('<Empty!>');
  FGetVariable := AGetVariable;
  FResult := TStringBuilder.Create;
  try
    for I := 0 to FItems.Count - 1 do
      FResult.Append(FItems[I].GetText(Self));
    Result := FResult.ToString;
  finally
    FResult.Free;
  end;
end;

function TdxChartValueTextCalculator.GetHandlerByFormat(const AFormat: string): TdxSpreadSheetFormatHandle;
var
  AHandler: TdxSpreadSheetFormatHandle;
begin
  if AFormat <> '' then
    AHandler := TdxChartTextFormatController.GetSpreadsheetValueFormatter(AFormat)
  else
    AHandler := TdxChartTextFormatController.GetSpreadsheetValueFormatter('@');
  Result := nil;
  dxChangeHandle(Result, AHandler);
end;

function TdxChartValueTextCalculator.ParseVariable: Boolean;
var
  AName, AFormat: string;
begin
  FlushText;
  AName := Trim(ParseVariableName.ToUpper);
  if AName = '' then
    Exit(False);
  Dec(FCurrent);
  if FCurrent^ = '}' then
  begin
    Inc(FCurrent);
    AFormat := '@';
  end
  else if FCurrent^ = ':' then
  begin
    Inc(FCurrent);
    AFormat := Trim(ParseVariableFormat);
    if AFormat = '' then
      Exit(False);
  end;
  FlushVariable(AName, GetHandlerByFormat(AFormat));
  Result := True;
end;

function TdxChartValueTextCalculator.ParseVariableName: string;
var
  S: PChar;
begin
  Result := '';
  while FCurrent^ = ' ' do
    Inc(FCurrent);
  S := FCurrent;
  while not ((FCurrent^ = #0) or (FCurrent^ = ':') or (FCurrent^ = '}')) do
    Inc(FCurrent);
  if FCurrent^ = #0 then
    Exit;
  SetString(Result, S, NativeInt(FCurrent - S));
  Inc(FCurrent);
end;

function TdxChartValueTextCalculator.ParseVariableFormat: string;
var
  S: PChar;
begin
  Result := '';
  while FCurrent^ = ' ' do
    Inc(FCurrent);
  S := FCurrent;
  while not ((FCurrent^ = #0) or (FCurrent^ = '}')) do
    Inc(FCurrent);
  if FCurrent^ = #0 then
    Exit;
  SetString(Result, S, NativeInt(FCurrent - S));
  Inc(FCurrent);
end;

{ TdxChartFormats }

function TdxChartFormats.AddFormat(const AFormatText: string): TdxChartValueTextCalculator;
begin
  Result := TdxChartValueTextCalculator.Create(nil, 0);
  Result.Parse(AFormatText);
  CheckAndAddItem(Result);
end;

{ TValueTextDelegateObject }

constructor TdxChartNamedValueDelegate.Create(const AValue: Variant);
begin
  FValue := AValue;
end;

function TdxChartNamedValueDelegate.GetValueByName(const AName: string; out AValue: Variant): Boolean;
begin
  Result := TdxChartTextFormatVariableNames.Value = AName;
  if Result then
    AValue := FValue;
end;

procedure TdxChartNamedValueDelegate.SetValue(const AValue: Variant);
begin
  FValue := AValue;
end;

{ TdxChartAxisValueTextDelegateObject }

function TdxChartAxisNamedValueProvider.GetValueByName(const AName: string; out AValue: Variant): Boolean;
begin
  Result := (TdxChartTextFormatVariableNames.Value = AName)
    or (TdxChartTextFormatVariableNames.Argument = AName);
  if Result then
    AValue := FValue;
end;

{ TdxChartFontOptions }

constructor TdxChartFontOptions.Create(AOwner: TdxChartAppearance);
begin
  inherited Create(AOwner, string(DefFontData.Name), AOwner.ScaleFactor.Apply(TdxChartVisualElementAppearance.DefaultChartFontSize));
  FChartOwner := AOwner.Chart.OwnerControl;
  if FChartOwner <> nil then
  begin
    FChartOwner.OnParentFontChanged := ParentFontChanged;
    FParentFont := FChartOwner.IsParentFontUsed;
  end;
end;

destructor TdxChartFontOptions.Destroy;
begin
  if FChartOwner <> nil then
    FChartOwner.OnParentFontChanged := nil;
  inherited;
end;

function TdxChartFontOptions.GetBold: Boolean;
begin
  if (ChartOwner <> nil) and ChartOwner.IsParentFontUsed then
    Result := fsBold in ChartOwner.GetParentFontValue.Style
  else
    Result := inherited GetBold;
end;

function TdxChartFontOptions.GetCharset: TFontCharset;
begin
  if (ChartOwner <> nil) and ChartOwner.IsParentFontUsed then
    Result := ChartOwner.GetParentFontValue.Charset
  else
    Result := inherited GetCharset;
end;

function TdxChartFontOptions.GetHeight: Integer;
begin
  if (ChartOwner <> nil) and ChartOwner.IsParentFontUsed then
    Result := ChartOwner.GetParentFontValue.Height
  else
    Result := inherited GetHeight;
end;

function TdxChartFontOptions.GetItalic: Boolean;
begin
  if (ChartOwner <> nil) and ChartOwner.IsParentFontUsed then
    Result := fsItalic in ChartOwner.GetParentFontValue.Style
  else
    Result := inherited GetItalic;
end;

function TdxChartFontOptions.GetName: TFontName;
begin
  if (ChartOwner <> nil) and ChartOwner.IsParentFontUsed then
    Result := ChartOwner.GetParentFontValue.Name
  else
    Result := inherited GetName;
end;

function TdxChartFontOptions.GetPitch: TdxFontPitch;
begin
  if (ChartOwner <> nil) and ChartOwner.IsParentFontUsed then
    Result := TdxFontPitch(ChartOwner.GetParentFontValue.Pitch)
  else
    Result := inherited GetPitch;
end;

function TdxChartFontOptions.GetQuality: TdxFontQuality;
begin
  if (ChartOwner <> nil) and ChartOwner.IsParentFontUsed then
    {$IFDEF DELPHIBERLIN}
    Result := TdxFontQuality(ChartOwner.GetParentFontValue.Quality)
    {$ELSE}
    Result := TdxFontQuality.Default
    {$ENDIF}
  else
    Result := inherited GetQuality;
end;

function TdxChartFontOptions.GetStrikeOut: Boolean;
begin
  if (ChartOwner <> nil) and ChartOwner.IsParentFontUsed then
    Result := fsStrikeOut in ChartOwner.GetParentFontValue.Style
  else
    Result := inherited GetStrikeOut;
end;

function TdxChartFontOptions.GetUnderline: Boolean;
begin
  if (ChartOwner <> nil) and ChartOwner.IsParentFontUsed then
    Result := fsUnderline in ChartOwner.GetParentFontValue.Style
  else
    Result := inherited GetUnderline;
end;

function TdxChartFontOptions.IsBoldStored: Boolean;
begin
  Result := ((ChartOwner = nil) or not ChartOwner.IsParentFontUsed) and inherited IsBoldStored;
end;

function TdxChartFontOptions.IsCharsetStored: Boolean;
begin
  Result := ((ChartOwner = nil) or not ChartOwner.IsParentFontUsed) and inherited IsCharsetStored;
end;

function TdxChartFontOptions.IsItalicStored: Boolean;
begin
  Result := ((ChartOwner = nil) or not ChartOwner.IsParentFontUsed) and inherited IsItalicStored;
end;

function TdxChartFontOptions.IsNameStored: Boolean;
begin
  Result := ((ChartOwner = nil) or not ChartOwner.IsParentFontUsed) and inherited IsNameStored;
end;

function TdxChartFontOptions.IsPitchStored: Boolean;
begin
  Result := ((ChartOwner = nil) or not ChartOwner.IsParentFontUsed) and inherited IsPitchStored;
end;

function TdxChartFontOptions.IsQualityStored: Boolean;
begin
  Result := ((ChartOwner = nil) or not ChartOwner.IsParentFontUsed) and inherited IsQualityStored;
end;

function TdxChartFontOptions.IsSizeStored: Boolean;
begin
  Result := ((ChartOwner = nil) or not ChartOwner.IsParentFontUsed) and inherited IsSizeStored;
end;

function TdxChartFontOptions.IsStrikeOutStored: Boolean;
begin
  Result := ((ChartOwner = nil) or not ChartOwner.IsParentFontUsed) and inherited IsStrikeOutStored;
end;

function TdxChartFontOptions.IsUnderlineStored: Boolean;
begin
  Result := ((ChartOwner = nil) or not ChartOwner.IsParentFontUsed) and inherited IsUnderlineStored;
end;

procedure TdxChartFontOptions.SetBold(const AValue: Boolean);
begin
  BeginUpdate;
  try
    ResetParentFont;
    inherited SetBold(AValue);
  finally
    EndUpdate;
  end;
end;

procedure TdxChartFontOptions.SetCharset(AValue: TFontCharset);
begin
  BeginUpdate;
  try
    ResetParentFont;
    inherited SetCharset(AValue);
  finally
    EndUpdate;
  end;
end;

procedure TdxChartFontOptions.SetHeight(AValue: Integer);
begin
  BeginUpdate;
  try
    ResetParentFont;
    inherited SetHeight(AValue);
  finally
    EndUpdate;
  end;
end;

procedure TdxChartFontOptions.SetItalic(const AValue: Boolean);
begin
  BeginUpdate;
  try
    ResetParentFont;
    inherited SetItalic(AValue);
  finally
    EndUpdate;
  end;
end;

procedure TdxChartFontOptions.SetName(const AValue: TFontName);
begin
  BeginUpdate;
  try
    ResetParentFont;
    inherited SetName(AValue);
  finally
    EndUpdate;
  end;
end;

procedure TdxChartFontOptions.SetPitch(AValue: TdxFontPitch);
begin
  BeginUpdate;
  try
    ResetParentFont;
    inherited SetPitch(AValue);
  finally
    EndUpdate;
  end;
end;

procedure TdxChartFontOptions.SetQuality(AValue: TdxFontQuality);
begin
  BeginUpdate;
  try
    ResetParentFont;
    inherited SetQuality(AValue);
  finally
    EndUpdate;
  end;
end;

procedure TdxChartFontOptions.SetStrikeOut(const AValue: Boolean);
begin
  BeginUpdate;
  try
    ResetParentFont;
    inherited SetStrikeOut(AValue);
  finally
    EndUpdate;
  end;
end;

procedure TdxChartFontOptions.SetUnderline(const AValue: Boolean);
begin
  BeginUpdate;
  try
    ResetParentFont;
    inherited SetUnderline(AValue);
  finally
    EndUpdate;
  end;
end;

procedure TdxChartFontOptions.ParentFontChanged(Sender: TObject);
begin
  if not ChartOwner.IsParentFontUsed and FParentFont then
  begin
    FParentFont := False;
    Assign(ChartOwner.GetParentFontValue);
    Exit;
  end;

  if (FParentFont <> ChartOwner.IsParentFontUsed) or ChartOwner.IsParentFontUsed then
  begin
    FParentFont := ChartOwner.IsParentFontUsed;
    Changed;
  end;
end;

procedure TdxChartFontOptions.ResetParentFont;
begin
  if ChartOwner = nil then
    Exit;
  if FParentFont then
  begin
    FParentFont := False;
    ChartOwner.IsParentFontUsed := False;
    Assign(ChartOwner.GetParentFontValue);
    Changed;
  end;
end;

{ TdxChartToolTips }

constructor TdxChartToolTips.Create(AOwner: TdxChart);
begin
  inherited Create(AOwner);
  FSimpleToolTipOptions := TdxChartSimpleToolTipOptions.Create(Self);
  FCrosshairOptions := TdxChartCrosshairOptions.Create(Self, AOwner);
  FDefaultMode := TdxChartToolTipMode.None;
end;

destructor TdxChartToolTips.Destroy;
begin
  FreeAndNil(FCrosshairOptions);
  FreeAndNil(FSimpleToolTipOptions);
  inherited Destroy;
end;

procedure TdxChartToolTips.DoAssign(Source: TPersistent);
var
  AToolTipsSource: TdxChartToolTips;
begin
  inherited;
  if Source is TdxChartToolTips then
  begin
    AToolTipsSource := TdxChartToolTips(Source);
    DefaultMode := AToolTipsSource.DefaultMode;
    SimpleToolTipOptions := AToolTipsSource.SimpleToolTipOptions;
    CrosshairOptions := AToolTipsSource.CrosshairOptions;
  end;
end;

procedure TdxChartToolTips.SetCrosshairOptions(const Value: TdxChartCrosshairOptions);
begin
  if FCrosshairOptions <> Value then
    FCrosshairOptions.Assign(Value);
end;

procedure TdxChartToolTips.SetSimpleToolTipOptions(const Value: TdxChartSimpleToolTipOptions);
begin
  if FSimpleToolTipOptions <> Value then
    FSimpleToolTipOptions.Assign(Value);
end;

{ TdxChartSimpleToolTipsOptions }

constructor TdxChartSimpleToolTipOptions.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FShowForPoints := True;
end;

procedure TdxChartSimpleToolTipOptions.DoAssign(Source: TPersistent);
var
  ASourceOptions: TdxChartSimpleToolTipOptions;
begin
  inherited;
  if Source is TdxChartSimpleToolTipOptions then
  begin
    ASourceOptions := TdxChartSimpleToolTipOptions(Source);
    ShowForPoints := ASourceOptions.ShowForPoints;
    ShowForSeries := ASourceOptions.ShowForSeries;
    UseHintPause := ASourceOptions.UseHintPause;
  end;
end;

{ TdxChartCrosshairOptions }

constructor TdxChartCrosshairOptions.Create(AOwner: TPersistent; AChart: TdxChart);
begin
  FChart := AChart;
  inherited Create(AOwner);
  FSnapToPointMode := TdxChartCrosshairSnapToPointMode.Argument;
  FSnapToSeriesMode := TdxChartCrosshairSnapToSeriesMode.All;
  FStickyLines := TdxChartCrosshairStickyLines.SingleAxis;
  FLabels := TdxChartCrosshairLabels.Create(Self);
  FArgumentLines := TdxChartCrosshairLines.Create(Self, True);
  FValueLines := TdxChartCrosshairLines.Create(Self, False);
  FHighlightPoints := True;
  FShowArgumentLabels := True;
  FShowValueLabels := False;
end;

destructor TdxChartCrosshairOptions.Destroy;
begin
  FreeAndNil(FLabels);
  FreeAndNil(FArgumentLines);
  FreeAndNil(FValueLines);
  inherited Destroy;
end;

procedure TdxChartCrosshairOptions.DoAssign(Source: TPersistent);
var
  ASourceOptions: TdxChartCrosshairOptions;
begin
  inherited;
  if Safe.Cast(Source, TdxChartCrosshairOptions, ASourceOptions) then
  begin
    ArgumentLines := ASourceOptions.ArgumentLines;
    Labels := ASourceOptions.Labels;
    SnapToOutRangePoints := ASourceOptions.SnapToOutRangePoints;
    SnapToPointMode := ASourceOptions.SnapToPointMode;
    SnapToSeriesMode := ASourceOptions.SnapToSeriesMode;
    StickyLines := ASourceOptions.StickyLines;
    ValueLines := ASourceOptions.ValueLines;
    HighlightPoints := ASourceOptions.HighlightPoints;
    ShowArgumentLabels := ASourceOptions.ShowArgumentLabels;
    ShowValueLabels := ASourceOptions.ShowValueLabels;
  end;
end;

function TdxChartCrosshairOptions.CreateAppearance: TdxChartVisualElementAppearance;
begin
  Result := TdxChartVisualElementAppearance.Create(Self);
end;

function TdxChartCrosshairOptions.GetParentElement: IdxChartVisualElement;
begin
  Result := FChart;
end;

procedure TdxChartCrosshairOptions.LayoutChanged;
begin
  FChart.CrosshairController.OptionsChanged;
end;

procedure TdxChartCrosshairOptions.SetArgumentLines(const Value: TdxChartCrosshairLines);
begin
  FArgumentLines.Assign(Value);
end;

procedure TdxChartCrosshairOptions.SetLabels(const Value: TdxChartCrosshairLabels);
begin
  FLabels.Assign(Value);
end;

procedure TdxChartCrosshairOptions.SetSnapToPointMode(const Value: TdxChartCrosshairSnapToPointMode);
begin
  FSnapToPointMode := Value;
  if FSnapToPointMode = TdxChartCrosshairSnapToPointMode.NearestToCursor then
  begin
    if FStickyLines = TdxChartCrosshairStickyLines.SingleAxis then
      FStickyLines := TdxChartCrosshairStickyLines.Crosshair;
    if FSnapToSeriesMode = TdxChartCrosshairSnapToSeriesMode.NearestToFreeLine then
      FSnapToSeriesMode := TdxChartCrosshairSnapToSeriesMode.NearestToCursor;
  end;
end;

procedure TdxChartCrosshairOptions.SetSnapToSeriesMode(const Value: TdxChartCrosshairSnapToSeriesMode);
begin
  FSnapToSeriesMode := Value;
  if (FSnapToSeriesMode = TdxChartCrosshairSnapToSeriesMode.NearestToFreeLine) and (FSnapToPointMode = TdxChartCrosshairSnapToPointMode.NearestToCursor) then
    FSnapToPointMode := TdxChartCrosshairSnapToPointMode.Argument;
end;

procedure TdxChartCrosshairOptions.SetStickyLines(const Value: TdxChartCrosshairStickyLines);
begin
  FStickyLines := Value;
  if (FStickyLines = TdxChartCrosshairStickyLines.SingleAxis) and (FSnapToPointMode = TdxChartCrosshairSnapToPointMode.NearestToCursor) then
    FSnapToPointMode := TdxChartCrosshairSnapToPointMode.Argument;
end;

procedure TdxChartCrosshairOptions.SetValueLines(const Value: TdxChartCrosshairLines);
begin
  FValueLines.Assign(Value);
end;

{ TdxChartCustomHitElementWithToolTip }

constructor TdxChartCustomHitElementWithToolTip.Create(const AIHitTestElement: IdxChartHitTestElement; ABounds: TdxRectF);
begin
  inherited Create;
  FIHitTestElement := AIHitTestElement;
  FBounds := ABounds;
  if IsModeSupported(TdxChartSimpleToolTipMode.Point) then
    FMode := TdxChartSimpleToolTipMode.Point
  else
    FMode := TdxChartSimpleToolTipMode.Series;
end;

function TdxChartCustomHitElementWithToolTip.GetChartElement: TObject;
begin
  Result := FIHitTestElement.GetChartElement;
end;

function TdxChartCustomHitElementWithToolTip.GetHitCode: TdxChartHitCode;
begin
  Result := FIHitTestElement.GetHitCode;
end;

function TdxChartCustomHitElementWithToolTip.GetSubAreaCode: Integer;
begin
  Result := FIHitTestElement.GetSubAreaCode;
end;

function TdxChartCustomHitElementWithToolTip.CanShowHint: Boolean;
var
  AHintedSeries: TdxChartCustomSeries;
begin
  AHintedSeries := GetHintedSeries;
  Result := (AHintedSeries <> nil) and AHintedSeries.ToolTips.Enabled;
end;

function TdxChartCustomHitElementWithToolTip.GetHintableObject: IcxHintableObject2;
begin
  Result := Self;
end;

function TdxChartCustomHitElementWithToolTip.HasHintPoint(const P: TPoint): Boolean;
begin
  Result := PtInRect(GetHintAreaBounds, P);
end;

function TdxChartCustomHitElementWithToolTip.IsHintAtMousePos: Boolean;
begin
  Result := True;
end;

function TdxChartCustomHitElementWithToolTip.UseHintHidePause: Boolean;
begin
  Result := False;
end;

function TdxChartCustomHitElementWithToolTip.ImmediateShowHint: Boolean;
begin
  Result := False;
end;

function TdxChartCustomHitElementWithToolTip.GetHintObject: TObject;
begin
  Result := Self;
end;

function TdxChartCustomHitElementWithToolTip.IsHintMultiLine: Boolean;
begin
  Result := False;
end;

function TdxChartCustomHitElementWithToolTip.GetHintFont: TFont;
begin
  Result := nil;
end;

function TdxChartCustomHitElementWithToolTip.GetHintAreaBounds: TRect;
begin
  Result := Rect(Floor(FBounds.Left), Floor(FBounds.Top), Ceil(FBounds.Right), Ceil(FBounds.Bottom));
end;

function TdxChartCustomHitElementWithToolTip.GetHintTextBounds: TRect;
begin
  Result := TRect.Null;
end;

function TdxChartCustomHitElementWithToolTip.GetMode: TdxChartSimpleToolTipMode;
begin
  Result := FMode;
end;

procedure TdxChartCustomHitElementWithToolTip.SetMode(AValue: TdxChartSimpleToolTipMode);
begin
  if IsModeSupported(AValue) then
    FMode := AValue;
end;

{ TdxChartSeriesHitElement }

constructor TdxChartSeriesHitElement.Create(ASeries: TdxChartCustomSeries);
begin
  inherited Create(TdxChartComponentHitElement.Create(ASeries, TdxChartHitCode.Series), ASeries.View.ViewInfo.Bounds);
end;

function TdxChartSeriesHitElement.GetHintedSeries: TdxChartCustomSeries;
begin
  Result := TdxChartCustomSeries(GetChartElement);
end;

function TdxChartSeriesHitElement.GetHintText: string;
var
  ASeries: TdxChartCustomSeries;
begin
  ASeries := GetHintedSeries;
  if ASeries = nil then
    Result := ''
  else
    Result := ASeries.GetSeriesToolTipText;
end;

function TdxChartSeriesHitElement.IsModeSupported(AMode: TdxChartSimpleToolTipMode): Boolean;
begin
  Result := AMode = TdxChartSimpleToolTipMode.Series;
end;

{ TdxChartSeriesPointHitElement }

constructor TdxChartSeriesPointHitElement.Create(APointInfo: TdxChartSeriesPointInfo; APointToolTipText: string);
var
  AEmbeddedHitElement: IdxChartHitTestElement;
begin
  AEmbeddedHitElement := TdxChartComponentDependentHitElement.Create(APointInfo, True, APointInfo.Series, TdxChartHitCode.SeriesPoint);
  inherited Create(AEmbeddedHitElement, APointInfo.Series.View.ViewInfo.Bounds);
  FPointToolTipText := APointToolTipText;
end;

function TdxChartSeriesPointHitElement.GetHintedSeries: TdxChartCustomSeries;
var
  APointInfo: TdxChartSeriesPointInfo;
begin
  APointInfo := TdxChartSeriesPointInfo(GetChartElement);
  if APointInfo = nil then
    Result := nil
  else
    Result := APointInfo.Series;
end;

function TdxChartSeriesPointHitElement.GetHintText: string;
var
  ASeries: TdxChartCustomSeries;
begin
  if GetMode = TdxChartSimpleToolTipMode.Point then
    Result := FPointToolTipText
  else if GetMode = TdxChartSimpleToolTipMode.Series then
  begin
    ASeries := GetHintedSeries;
    if ASeries = nil then
      Result := ''
    else
      Result := ASeries.GetSeriesToolTipText;
  end;
end;

function TdxChartSeriesPointHitElement.IsModeSupported(AMode: TdxChartSimpleToolTipMode): Boolean;
begin
  Result := True;
end;

{ TdxChartSeriesValueLabelHitElement }

constructor TdxChartSeriesValueLabelCaptionHitElement.Create(AValueLabelViewInfo: TdxChartSeriesValueLabelViewInfo);
var
  APointInfo: TdxChartSeriesPointInfo;
  ALabelInfo: TdxChartSeriesValueLabelInfo;
  AEmbeddedHitElement: IdxChartHitTestElement;
begin
  APointInfo := AValueLabelViewInfo.Owner.CreateSeriesPointInfo;
  ALabelInfo := TdxChartSeriesValueLabelInfo.Create(APointInfo, AValueLabelViewInfo.DisplayText);
  AEmbeddedHitElement := TdxChartComponentDependentHitElement.Create(ALabelInfo, True, APointInfo.Series, TdxChartHitCode.SeriesValueLabel, TdxChartSeriesValueLabelViewInfo.TextSubAreaCode);
  inherited Create(AEmbeddedHitElement, AValueLabelViewInfo.TextBounds, ALabelInfo.Text, AValueLabelViewInfo.IsTextTruncated, AValueLabelViewInfo.WordWrap);
  FViewInfo := AValueLabelViewInfo;
end;

function TdxChartSeriesValueLabelCaptionHitElement.GetAppearance: TdxChartVisualElementAppearance;
begin
  Result := FViewInfo.Appearance;
end;

{ TdxChartCrosshairLabels }

function TdxChartCrosshairLabels.CreateAppearance: TdxChartVisualElementAppearance;
begin
  Result := TdxChartCrosshairLabelAppearance.Create(Self);
end;

function TdxChartCrosshairLabels.GetAppearance: TdxChartCrosshairLabelAppearance;
begin
  Result := TdxChartCrosshairLabelAppearance(inherited Appearance);
end;

procedure TdxChartCrosshairLabels.SetAppearance(AValue: TdxChartCrosshairLabelAppearance);
begin
  inherited Appearance := AValue;
end;

{ TdxChartCrosshairLabelAppearance }

constructor TdxChartCrosshairLabelAppearance.Create(AOwner: TPersistent; AParent: TdxChartVisualElementAppearance);
begin
  inherited Create(AOwner, AParent);
  FCaptionOffset := DefaultCaptionOffset;
  FItemIndent := DefaultItemIndent;
  FImageSize := TdxSizeFloat.Create(Self, DefaultImageSize);
  FImageSize.OnChange := SizeChangeHandler;
end;

destructor TdxChartCrosshairLabelAppearance.Destroy;
begin
  FreeAndNil(FImageSize);
  inherited;
end;

procedure TdxChartCrosshairLabelAppearance.ChangeScaleCore(M, D: Integer);
begin
  inherited ChangeScaleCore(M, D);
  FItemIndent := dxScale(FItemIndent, M, D);
  FImageSize.ChangeScale(M, D);
  FCaptionOffset := dxScale(FCaptionOffset, M, D);
end;

function TdxChartCrosshairLabelAppearance.DefaultBorder: Boolean;
begin
  Result := True;
end;

function TdxChartCrosshairLabelAppearance.DefaultPadding: Integer;
begin
  Result := DefaultPaddingValue;
end;

function TdxChartCrosshairLabelAppearance.HasFillOptions: Boolean;
begin
  Result := True;
end;

function TdxChartCrosshairLabelAppearance.HasFontOptions: Boolean;
begin
  Result := True;
end;

function TdxChartCrosshairLabelAppearance.GetFontOptions: TdxChartVisualElementFontOptions;
begin
  Result := TdxChartVisualElementFontOptions(inherited FontOptions);
end;

function TdxChartCrosshairLabelAppearance.IsCaptionOffsetStored: Boolean;
begin
  Result := FCaptionOffset <> DefaultCaptionOffset;
end;

function TdxChartCrosshairLabelAppearance.IsItemIndentStored: Boolean;
begin
  Result := FItemIndent <> DefaultItemIndent;
end;

procedure TdxChartCrosshairLabelAppearance.SetCaptionOffset(const AValue: Single);
begin
  if AValue <> FCaptionOffset then
  begin
    FCaptionOffset := AValue;
    Changed(TAppearanceChange.Size);
  end;
end;

procedure TdxChartCrosshairLabelAppearance.SetFontOptions(AValue: TdxChartVisualElementFontOptions);
begin
  inherited FontOptions := AValue;
end;

procedure TdxChartCrosshairLabelAppearance.SetItemIndent(const Value: Single);
begin
  FItemIndent := Value;
  Changed(TAppearanceChange.Size);
end;

procedure TdxChartCrosshairLabelAppearance.SizeChangeHandler(Sender: TObject);
begin
  Changed(TAppearanceChange.Size);
end;

procedure TdxChartCrosshairLabelAppearance.SetImageSize(const AValue: TdxSizeFloat);
begin
  ImageSize.Assign(AValue);
end;

{ TdxChartCrosshairLineAppearance }

procedure TdxChartCrosshairLineAppearance.DoChanged;
var
  I: Integer;
  ADiagram: TdxChartXYDiagram;
begin
  inherited DoChanged;
  for I := 0 to Chart.DiagramCount - 1 do
    if Safe.Cast(Chart.Diagrams[I], TdxChartXYDiagram, ADiagram) then
    begin
      TdxChartVisualElementAppearance(ADiagram.Axes.AxisX.CrosshairLabels.Appearance).Changed([TdxChartVisualElementAppearance.TAppearanceChange.Fill]);
      TdxChartVisualElementAppearance(ADiagram.Axes.AxisY.CrosshairLabels.Appearance).Changed([TdxChartVisualElementAppearance.TAppearanceChange.Fill]);
    end;
end;

function TdxChartCrosshairLineAppearance.GetActualColor(AIndex: Integer): TdxAlphaColor;
begin
  if AIndex = PenColorIndex then
    Result := DefaultCrosshairLineColor
  else
    Result := inherited GetActualColor(AIndex);
end;

function TdxChartCrosshairLineAppearance.HasStrokeOptions: Boolean;
begin
  Result := True;
end;

{ TdxChartCrosshairLines }

constructor TdxChartCrosshairLines.Create(AOwner: TPersistent; AVisibleByDefault: Boolean);
begin
  FVisibleByDefault := AVisibleByDefault;
  inherited Create(AOwner);
end;

function TdxChartCrosshairLines.CreateAppearance: TdxChartVisualElementAppearance;
begin
  Result := TdxChartCrosshairLineAppearance.Create(Self);
end;

function TdxChartCrosshairLines.GetAppearance: TdxChartCrosshairLineAppearance;
begin
  Result := TdxChartCrosshairLineAppearance(inherited Appearance);
end;

function TdxChartCrosshairLines.GetDefaultVisible: Boolean;
begin
  Result := FVisibleByDefault;
end;

procedure TdxChartCrosshairLines.SetAppearance(AValue: TdxChartCrosshairLineAppearance);
begin
  inherited Appearance := AValue;
end;

initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  RegisterClasses([TdxChart, TdxChartCustomDiagram, TdxChartCustomSeries, TdxChartSeriesCustomView,
    TdxChartVisualElementAppearance, TdxChartSeriesValueLabelAppearance,
    TdxChartVisualElementTitle, TdxChartTitle, TdxChartDiagramTitle, TdxChartTitles, TdxChartTitleCollectionItem,
    TdxChartCustomLegend, TdxChartLegend, TdxChartDiagramLegend,
    TdxChartSeriesCustomDataBinding, TdxChartDataController]);

  SetLength(dxChartAdditionalFormatters, 5);
  dxChartAdditionalFormatters[0].Create($32, 'c');
  dxChartAdditionalFormatters[1].Create($33, 'ddddd');
  dxChartAdditionalFormatters[2].Create($34, 'dddddd'); 
  dxChartAdditionalFormatters[3].Create($35, 't');
  dxChartAdditionalFormatters[4].Create($36, 'tt');
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  FreeAndNil(FRegisteredSeriesView);
  FreeAndNil(FRegisteredDataBindings);
  FreeAndNil(FRegisteredSeriesViewImages);
  FreeAndNil(TdxChartTextFormatController.FInstance);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
