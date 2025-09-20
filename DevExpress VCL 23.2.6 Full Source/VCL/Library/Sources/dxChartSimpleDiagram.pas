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

unit dxChartSimpleDiagram;

{$I cxVer.inc}
{$SCOPEDENUMS ON}

interface

uses
  System.UITypes,
  Types, Classes, SysUtils, Controls, Graphics, Math, dxCore, Variants, dxTypeHelpers, dxCoreClasses, dxCoreGraphics,
  cxGeometry, cxClasses, cxGraphics, cxVariants, cxLookAndFeelPainters, cxDataStorage, cxCustomCanvas, dxCustomData,
  dxChartCore, dxChartStrs, dxGenerics, Generics.Defaults, Generics.Collections, Contnrs;

type
  TdxChartSimpleDiagram = class;
  TdxChartSimpleSeries = class;
  TdxChartSimpleSeriesCustomPieView = class;
  TdxChartSimpleSeriesViewData = class;
  TdxChartSimpleSeriesViewInfo = class;
  TdxChartSimpleSeriesValueViewInfo = class;
  TdxChartSimpleSeriesPieValueLabelViewInfo = class;
  TdxChartSimpleSeriesCustomView = class;
  TdxChartExplodedValueOptions = class;

  TdxSimpleDiagramLayout = (Auto, Horizontal, Vertical);  

  TdxChartPieSweepDirection = (Counterclockwise, Clockwise);
  TdxChartPieValueLabelPosition = (Inside, Outside, TwoColumns, Radial, Tangent);
  TdxChartPieValueLabelsResolveOverlappingMode =
    TdxChartSeriesValueLabelsResolveOverlappingMode.None..TdxChartSeriesValueLabelsResolveOverlappingMode.Default;

  {TdxChartGetTotalLabelDrawParametersEventArgs}

  TdxChartGetTotalLabelDrawParametersEventArgs = class(TdxEventArgs)
  private
    FSeries: TdxChartCustomSeries;
    FText: string;
    FTotalValue: Double;
  public
    constructor Create(ASeries: TdxChartCustomSeries; ATotalValue: Double; const AText: string);
    property Series: TdxChartCustomSeries read FSeries;
    property Text: string read FText write FText;
    property TotalValue: Double read FTotalValue;
  end;

  TdxChartGetTotalLabelDrawParametersEvent = procedure(Sender: TdxChartCustomDiagram; AArgs: TdxChartGetTotalLabelDrawParametersEventArgs) of object;

  TdxChartSimpleDiagramToolTipMode = TdxChartToolTipMode.Default..TdxChartToolTipMode.Simple;

  TdxChartSimpleDiagramToolTipOptions = class(TdxChartDiagramToolTipOptions)
  strict private
    FMode: TdxChartSimpleDiagramToolTipMode;
  protected
    procedure DoAssign(Source: TPersistent); override;
  public
    constructor Create(AOwner: TPersistent); override;
  published
    property Mode: TdxChartSimpleDiagramToolTipMode read FMode write FMode default TdxChartToolTipMode.Default;
  end;

  { TdxChartSimpleDiagram }

  TdxChartSimpleDiagram = class(TdxChartCustomDiagram)
  strict private
    FDimension: Integer;
    FLayout: TdxSimpleDiagramLayout;

    FOnGetTotalLabelDrawParameters: TdxChartGetTotalLabelDrawParametersEvent;
    function GetSeries(AIndex: Integer): TdxChartSimpleSeries; inline;
    function GetToolTips: TdxChartSimpleDiagramToolTipOptions;
    function GetVisibleSeries(AIndex: Integer): TdxChartSimpleSeries; inline;
    procedure SetDimension(AValue: Integer);
    procedure SetLayout(AValue: TdxSimpleDiagramLayout);
    procedure SetSeries(AIndex: Integer; const AValue: TdxChartSimpleSeries);
    procedure SetToolTips(AValue: TdxChartSimpleDiagramToolTipOptions);
  protected
    procedure AssignFrom(ASource: TdxChartCustomDiagram; ARecreate: Boolean = True; AStoreList: TdxFastObjectList = nil); override;
    function CreateToolTipOptions: TdxChartDiagramToolTipOptions; override;
    function CreateViewData: TdxChartDiagramCustomViewData; override;
    function CreateViewInfo: TdxChartDiagramCustomViewInfo; override;
    procedure DoGetTotalLabelDrawParameters(AArgs: TdxChartGetTotalLabelDrawParametersEventArgs);
    function GetActualToolTipMode: TdxChartActualToolTipMode; override;
    function GetSeriesClass: TdxChartSeriesClass; override;
  public type
    TForEachSeriesProc = reference to procedure(ASeries: TdxChartSimpleSeries);
  public
    constructor Create(AOwner: TComponent); override;
    function AddSeries(const ACaption: string = ''): TdxChartSimpleSeries;
    procedure ForEachSeries(AHandler: TForEachSeriesProc);

    property Series[AIndex: Integer]: TdxChartSimpleSeries read GetSeries write SetSeries; default;
    property VisibleSeries[Index: Integer]: TdxChartSimpleSeries read GetVisibleSeries;
  published
    property Layout: TdxSimpleDiagramLayout read FLayout write SetLayout default TdxSimpleDiagramLayout.Auto;
    property Dimension: Integer read FDimension write SetDimension default 1;
    property OnGetValueLabelDrawParameters;
    property OnGetTotalLabelDrawParameters: TdxChartGetTotalLabelDrawParametersEvent read FOnGetTotalLabelDrawParameters write FOnGetTotalLabelDrawParameters;
    property ToolTips: TdxChartSimpleDiagramToolTipOptions read GetToolTips write SetToolTips;
    property Visible;
  end;

  { TdxChartSimpleDiagramViewData }

  TdxChartSimpleDiagramViewData = class(TdxChartDiagramCustomViewData)
  protected
    function AllowSorting: Boolean; override;
  end;

  { TdxChartSimpleDiagramViewInfo }

  TdxChartSimpleDiagramViewInfo = class(TdxChartDiagramCustomViewInfo)
  strict private
    FHorizontalLayout: Boolean;
    FDimension: Integer;
    function GetDiagram: TdxChartSimpleDiagram; inline;
    function GetSeries(AIndex: Integer): TdxChartSimpleSeries; inline;
    function GetViewData: TdxChartSimpleDiagramViewData; inline;
  protected
    procedure CalculateOptimalAutoLayout; virtual;
    procedure CalculateViews(ACanvas: TcxCustomCanvas); override;

    property Diagram: TdxChartSimpleDiagram read GetDiagram;
    property Dimension: Integer read FDimension write FDimension;
    property HorizontalLayout: Boolean read FHorizontalLayout;
    property Series[Index: Integer]: TdxChartSimpleSeries read GetSeries;
    property ViewData: TdxChartSimpleDiagramViewData read GetViewData;
  end;

  { TdxChartSimpleSeries }

  TdxChartSimpleSeries = class(TdxChartCustomSeries)
  strict private
    FViewEvents: TNotifyEvent;
    function GetView: TdxChartSimpleSeriesCustomView; inline;
    procedure SetView(AValue: TdxChartSimpleSeriesCustomView);
  protected
    class function CanHaveTitle: Boolean; override;
    procedure DoChanged; override;
    procedure DoPopulateLegend(ALegend: TdxChartCustomLegend); override;
    class function GetBaseViewClass: TdxChartSeriesViewClass; override;
  published
    property DataBindingType;
    property DataBinding;
    property SortBy;
    property SortOrder;
    property ShowInLegend;
    property Title;
    property TopNOptions;
    property ViewType;
    property View: TdxChartSimpleSeriesCustomView read GetView write SetView;
    property ViewEvents: TNotifyEvent read FViewEvents write FViewEvents; // for internal use
    property Visible;
    property Index;
  end;

  { TdxChartSimpleSeriesViewAppearance }

  TdxChartSimpleSeriesViewAppearance = class(TdxChartSeriesViewAppearance)
  strict private
    FActualGlyphCorrection: Single;
  protected
    function GetActualColor(AIndex: Integer): TdxAlphaColor; override;
    function HasFillOptions: Boolean; override;
    function HasStrokeOptions: Boolean; override;
    procedure UpdateActualValues(ACanvas: TcxCustomCanvas); override;

    property ActualGlyphCorrection: Single read FActualGlyphCorrection;
  published
    property Margins;
  end;

  { TdxChartSimpleSeriesViewAppearanceValueLabelAppearance }

  TdxChartSimpleSeriesViewAppearanceValueLabelAppearance = class(TdxChartSeriesValueLabelAppearance)
  protected
    function GetActualColor(AIndex: Integer): TdxAlphaColor; override;
  end;

  { TdxChartSimpleSeriesCustomView }

  TdxChartSimpleSeriesCustomView = class(TdxChartSeriesCustomView)
  strict private
    function GetAppearance: TdxChartSimpleSeriesViewAppearance; inline;
    function GetViewData: TdxChartSimpleSeriesViewData; inline;
    function GetViewInfo: TdxChartSimpleSeriesViewInfo; inline;
    procedure SetAppearance(AValue: TdxChartSimpleSeriesViewAppearance);
  protected
    class function CanAggregate(AView: TdxChartSeriesCustomView): Boolean; override;
    function CreateAppearance: TdxChartVisualElementAppearance; override;
    function CreateViewData: TdxChartSeriesViewCustomViewData; override; 
    function CreateViewInfo: TdxChartSeriesViewCustomViewInfo; override; 
    function GetValueLabelAppearanceClass: TdxChartSeriesValueLabelAppearanceClass; override;
    procedure LayoutChanged; override;

    property Appearance: TdxChartSimpleSeriesViewAppearance read GetAppearance write SetAppearance;
    property ViewData: TdxChartSimpleSeriesViewData read GetViewData;
    property ViewInfo: TdxChartSimpleSeriesViewInfo read GetViewInfo;
  public
    class function IsCompatibleWith(AView: TdxChartSeriesCustomView): Boolean; override;
  end;

  { TdxChartSimpleSeriesViewData }

  TdxChartSimpleSeriesViewData = class(TdxChartSeriesViewCustomViewData)
  strict private
    FHiddenItems: TList;
    function GetSeries: TdxChartSimpleSeries; inline;
    function GetView: TdxChartSimpleSeriesCustomView; inline;
  protected
    function AllowSorting: Boolean; override;
    procedure Changed; override;
    procedure CheckValue(AValue: TdxChartSeriesValueViewInfo); override;
    procedure HiddenChanged(AValue: TdxChartSimpleSeriesValueViewInfo);
    function IsSourceValueValid(ARecord: PdxDataRecord): Boolean; override;
    function IsValueHidden(AValue: TdxChartSimpleSeriesValueViewInfo): Boolean;

    property HiddenItems: TList read FHiddenItems;
  public
    constructor Create(AOwner: TdxChartSeriesCustomView); override;
    destructor Destroy; override;
    procedure ClearHiddenItems;

    property Series: TdxChartSimpleSeries read GetSeries;
    property View: TdxChartSimpleSeriesCustomView read GetView;
  end;

  { TdxChartSimpleSeriesValueViewInfo }

  TdxChartSimpleSeriesValueViewInfo = class(TdxChartSeriesValueViewInfo, IUnknown, IdxChartLegendItem)
  strict private
    FDisplayLabel: string;
    function GetOwner: TdxChartSimpleSeriesViewInfo; inline;
    function GetViewData: TdxChartSimpleSeriesViewData; inline;
  protected
    FAppearance: TdxChartColorizedAppearance;
    procedure CalculateDisplayText; override;
    procedure CalculateValue; override;
    procedure DrawGlyph(ACanvas: TcxCustomCanvas; const R: TdxRectF); virtual; abstract;
    function GetAppearance: TdxChartVisualElementAppearance; override;
    procedure UpdateRecord(const ARecord: PdxDataRecord); override;
    // IUnknown
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall; 
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    // IdxChartLegendItem
    function GetCaption: string;
    function GetColor: TdxAlphaColor;
    function IsChecked: Boolean;
    function IsEnabled: Boolean;
    procedure SetChecked(AValue: Boolean);
    //
    property Owner: TdxChartSimpleSeriesViewInfo read GetOwner;
    property ViewData: TdxChartSimpleSeriesViewData read GetViewData;
  public
    constructor Create(AOwner: TdxChartSeriesViewCustomViewInfo; APriorValue: TdxChartSeriesValueViewInfo); override;
    destructor Destroy; override;

    property DisplayLabel: string read FDisplayLabel;
  end;

  { TdxChartSimpleSeriesViewInfo }

  TdxChartSimpleSeriesViewInfo = class(TdxChartSeriesViewCustomViewInfo)
  strict private
    function GetActualGlyphCorrection: Single; inline;
    function GetSeries: TdxChartSimpleSeries; inline;
    function GetView: TdxChartSimpleSeriesCustomView; inline;
    function GetViewData: TdxChartSimpleSeriesViewData; inline;
  protected
    FVisibleCount: Integer;
    procedure CalculateValues(ACanvas: TcxCustomCanvas); override;
    procedure ClearValues; override;
    procedure DoDraw(ACanvas: TcxCustomCanvas); override;
    function NeedDisplayTextCalculation: Boolean; override;
    procedure PrepareItems(ARecords: TdxFastList); override;
  public
    property ActualGlyphCorrection: Single read GetActualGlyphCorrection;
    property Series: TdxChartSimpleSeries read GetSeries;
    property View: TdxChartSimpleSeriesCustomView read GetView;
    property ViewData: TdxChartSimpleSeriesViewData read GetViewData;
    property VisibleCount: Integer read FVisibleCount;
  end;

  { TdxChartPieValueLabels }

  TdxChartPieValueLabels = class(TdxChartSeriesValueLabels)
  strict private
    FPosition: TdxChartPieValueLabelPosition;
    FResolveOverlappingMode: TdxChartPieValueLabelsResolveOverlappingMode;
    procedure SetPosition(AValue: TdxChartPieValueLabelPosition);
    procedure SetResolveOverlappingMode(AValue: TdxChartPieValueLabelsResolveOverlappingMode);
  protected
    procedure DoAssign(Source: TPersistent); override;
    function GetResolveOverlappingMode: TdxChartSeriesValueLabelsResolveOverlappingMode; override;
    function GetTextFormatter: TObject; override;
    function IsOutsideLabel: Boolean;
  public
    constructor Create(AOwner: TPersistent); override;
  published
    property Position: TdxChartPieValueLabelPosition read FPosition write SetPosition default TdxChartPieValueLabelPosition.Inside;
    property ResolveOverlappingMode: TdxChartPieValueLabelsResolveOverlappingMode read FResolveOverlappingMode write SetResolveOverlappingMode
      default TdxChartSeriesValueLabelsResolveOverlappingMode.Default;
  end;

  { TdxChartExplodedValueMode }

  TdxChartExplodedValueMode = (None, All, Min, Max, Custom);

  { TdxChartCanExplodeValueEventArgs }

  TdxChartCanExplodeValueEventArgs = class(TdxEventArgs)
  private
    FCanExplode: Boolean;
    FSeriesPoint: TdxChartSeriesPointInfo;
  public
    constructor Create(ASeriesPoint: TdxChartSeriesPointInfo);
    destructor Destroy; override;
    property CanExplode: Boolean read FCanExplode write FCanExplode;
    property SeriesPoint: TdxChartSeriesPointInfo read FSeriesPoint;
  end;

  TdxChartCanExplodeValueEvent = procedure(Sender: TdxChartSimpleSeriesCustomView; AArgs: TdxChartCanExplodeValueEventArgs) of object;

  { TdxChartExplodedValueOptions }

  TdxChartExplodedValueOptions = class(TdxChartOwnedPersistent)
  public const
    DefaultDistance: Single = 10;
  strict private
    FDistance: Single;
    FMode: TdxChartExplodedValueMode;
    FRuntimeExploding: Boolean;
    function GetView: TdxChartSimpleSeriesCustomPieView; inline;
    function IsDistanceStored: Boolean;
    procedure SetDistance(AValue: Single);
    procedure SetMode(AValue: TdxChartExplodedValueMode);
  protected
    procedure Changed; override;
    procedure DoAssign(Source: TPersistent); override;

    function IsValueExploded(AValue: TdxChartSimpleSeriesValueViewInfo): Boolean; virtual;

    property View: TdxChartSimpleSeriesCustomPieView read GetView;
  public
    constructor Create(AOwner: TPersistent); override;
  published
    property Distance: Single read FDistance write SetDistance stored IsDistanceStored; 
    property Mode: TdxChartExplodedValueMode read FMode write SetMode default TdxChartExplodedValueMode.None;
  end;

  { TdxChartSimpleSeriesTotalLabelViewInfo }

  TdxChartSimpleSeriesTotalLabelViewInfo = class(TdxChartVisualElementTitleViewInfo)
  end;

  { TdxChartSimpleSeriesTotalLabel }

  TdxChartSimpleSeriesTotalLabel = class(TdxChartVisualElementTitle)
  strict private
    FTextFormatter: TObject;
    FPosition: TdxAlignment;
    function GetActualPosition: TdxAlignment;
    function GetDefaultText: string;
    function GetTextFormat: TdxChartTextFormat;
    function GetView: TdxChartSimpleSeriesCustomPieView;
    function GetViewInfo: TdxChartSimpleSeriesTotalLabelViewInfo;
    procedure SetTextFormat(const AValue: TdxChartTextFormat);
    procedure SetPosition(AValue: TdxAlignment);
  protected
    function ActuallyVisible: Boolean; override;
    procedure CalculateAndAdjustContent(ACanvas: TcxCustomCanvas; var ABounds: TdxRectF); override;
    function CreateViewInfo: TdxChartVisualElementCustomViewInfo; override;
    procedure DoAssign(Source: TPersistent); override;
    function GetActualDisplayText: string; override;
    function GetActualDockPosition: TdxChartTitlePosition; override;
    function GetDefaultWordWrap: Boolean; override;
    class function GetHitCode: TdxChartHitCode; override;
    function GetOwnerComponent: TComponent; override;
    function GetText: string; override;
    function GetValueByName(const AName: string; out AValue: Variant): Boolean;
    procedure RaiseGetTotalLabelDrawParametersEvent(var AText: string);

    property ActualPosition: TdxAlignment read GetActualPosition;
    property TextFormatter: TObject read FTextFormatter;
    property ViewInfo: TdxChartSimpleSeriesTotalLabelViewInfo read GetViewInfo;
  public
    destructor Destroy; override;
    property View: TdxChartSimpleSeriesCustomPieView read GetView;
  published
    property Position: TdxAlignment read FPosition write SetPosition default TdxAlignment.Default;
    property TextFormat: TdxChartTextFormat read GetTextFormat write SetTextFormat;
  end;

  { TdxChartSimpleSeriesCustomPieView }

  TdxChartSimpleSeriesCustomPieView  = class(TdxChartSimpleSeriesCustomView)
  public const
    DefaultLineLength: Single = 30;
    DefaultStartAngle: Single = 90;
  strict private
    FExplodedValueOptions: TdxChartExplodedValueOptions;
    FHoleRadius: Single;
    FOnCanExplodeValue: TdxChartCanExplodeValueEvent;
    FStartAngle: Single;
    FSweepDirection: TdxChartPieSweepDirection;
    FTotalLabel: TdxChartSimpleSeriesTotalLabel;
    function GetValueLabels: TdxChartPieValueLabels; inline;
    function IsHoleRadiusStored: Boolean;
    function IsStartAngleStored: Boolean;
    procedure SetHoleRadius(AValue: Single);
    procedure SetStartAngle(AValue: Single);
    procedure SetSweepDirection(AValue: TdxChartPieSweepDirection);
    procedure SetExplodedValueOptions(AValue: TdxChartExplodedValueOptions);
    procedure SetOnCanExplodeValue(const Value: TdxChartCanExplodeValueEvent);
    procedure SetTotalLabel(AValue: TdxChartSimpleSeriesTotalLabel);
    procedure SetValueLabels(AValue: TdxChartPieValueLabels);
  protected
    procedure Changed; virtual;
    function CreateExplodedValueOptions: TdxChartExplodedValueOptions; virtual;
    function CreateTotalLabel: TdxChartSimpleSeriesTotalLabel; virtual;
    function CreateViewInfo: TdxChartSeriesViewCustomViewInfo; override;
    function CreateValueLabels: TdxChartSeriesValueLabels; override;
    procedure DoAssign(Source: TPersistent); override;
    procedure DoCanExplodeValue(AArgs: TdxChartCanExplodeValueEventArgs);
    function GetDefaultHoleRadius: Single; virtual;
    function GetDefaultLineLength: Single; override;
    function GetDefaultTotalLabelPosition: TdxAlignment; virtual;

    property ExplodedValueOptions: TdxChartExplodedValueOptions read FExplodedValueOptions write SetExplodedValueOptions;
    property HoleRadius: Single read FHoleRadius write SetHoleRadius stored IsHoleRadiusStored; 
    property StartAngle: Single read FStartAngle write SetStartAngle stored IsStartAngleStored; 
    property SweepDirection: TdxChartPieSweepDirection read FSweepDirection write SetSweepDirection default TdxChartPieSweepDirection.Clockwise;
  public
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;

    property OnCanExplodeValue: TdxChartCanExplodeValueEvent read FOnCanExplodeValue write SetOnCanExplodeValue;
    property TotalLabel: TdxChartSimpleSeriesTotalLabel read FTotalLabel write SetTotalLabel;
    property ValueLabels: TdxChartPieValueLabels read GetValueLabels write SetValueLabels;
  end;

  { TdxChartSimpleSeriesPieView }

  TdxChartSimpleSeriesPieView = class(TdxChartSimpleSeriesCustomPieView)
  public
    class function GetDescription: string; override;
  published
    property Appearance;
    property ExplodedValueOptions;
    property OnCanExplodeValue;
    property StartAngle;
    property SweepDirection;
    property TotalLabel;
    property ValueLabels;
  end;

  { TdxChartSimpleSeriesPieViewInfo }

  TdxChartSimpleSeriesPieViewInfo = class(TdxChartSimpleSeriesViewInfo)
  strict private
    function GetExplodedValueOptions: TdxChartExplodedValueOptions; inline;
    function GetTotalLabel: TdxChartSimpleSeriesTotalLabel; inline;
    function GetValueLabels: TdxChartPieValueLabels; inline;
    function GetView: TdxChartSimpleSeriesCustomPieView; inline;
  protected
    FExplodedCount: Integer;
    FExplodedDistance: Single;
    FSign: Integer;
    FStart: Single;
    FValueBounds: TdxRectF;
    procedure CalculateCanvasValue(const AValue: TdxChartSeriesValueViewInfo); override;
    procedure CalculateValues(ACanvas: TcxCustomCanvas); override;
    procedure CalculateValuesBounds(ASize: Single);
    procedure DoDraw(ACanvas: TcxCustomCanvas); override;
    procedure DoDrawLabels(ACanvas: TcxCustomCanvas); override;
    procedure DrawValues(ACanvas: TcxCustomCanvas); override;
    function GetHitElement(const P: TdxPointF): IdxChartHitTestElement; override;
    procedure ResolveValueLabelsOverlapping;
    function GetValueViewInfoClass: TdxChartSeriesValueViewInfoClass; override;
    procedure PrepareValuesToCanvasValues; override;
  public
    property ExplodedCount: Integer read FExplodedCount;
    property ExplodedDistance: Single read FExplodedDistance;
    property ExplodedValueOptions: TdxChartExplodedValueOptions read GetExplodedValueOptions;
    property TotalLabel: TdxChartSimpleSeriesTotalLabel read GetTotalLabel;
    property ValueBounds: TdxRectF read FValueBounds;
    property ValueLabels: TdxChartPieValueLabels read GetValueLabels;
    property View: TdxChartSimpleSeriesCustomPieView read GetView;
  end;

  { TdxChartSimpleSeriesPieValueViewInfo }

  TdxChartSimpleSeriesPieValueViewInfo = class(TdxChartSimpleSeriesValueViewInfo)
  strict private
    FStartAngle: Single;
    FSweepAngle: Single;
    function GetHalfAngle: Single;
    function GetOwner: TdxChartSimpleSeriesPieViewInfo; inline;
    function GetValueLabel: TdxChartSimpleSeriesPieValueLabelViewInfo; inline;
  strict private const
    ExplodedIndex = Integer(High(TdxChartSimpleSeriesValueViewInfo.TValueState)) + 1;
  protected
    procedure CalculateLabelLeaderLinePoints(var AStartPoint, AMiddlePoint, AEndPoint: TdxPointF); override;
    function CreateValueLabel: TdxChartValueLabelCustomViewInfo; override;
    procedure DrawGlyph(ACanvas: TcxCustomCanvas; const R: TdxRectF); override;
    procedure DrawGlyphSlice(ACanvas: TcxCustomCanvas; const R: TdxRectF); virtual;
    procedure Initialize(const AStartAngle, ASweepAngle: Single);
    function IsInBottomSemicircle: Boolean;
    function IsInRightSemicircle: Boolean;
    function GetClipRect: TdxRectF; override;
    function GetDisplayBounds: TdxRectF;
    function GetHitElement(const P: TdxPointF): IdxChartHitTestElement; override;
    function GetHoleRadiusInPixels: Single; virtual;
    function GetLabelAnchorPoint: TdxPointF; override;

    property Exploded: Boolean index ExplodedIndex read GetState write SetState;
    property HalfAngle: Single read GetHalfAngle;
    property Owner: TdxChartSimpleSeriesPieViewInfo read GetOwner;
  public
    procedure Draw(ACanvas: TcxCustomCanvas); override;

    property StartAngle: Single read FStartAngle;
    property SweepAngle: Single read FSweepAngle;
    property ValueLabel: TdxChartSimpleSeriesPieValueLabelViewInfo read GetValueLabel;

  end;

  { TdxChartSimpleSeriesPieValueLabelViewInfo }

  TdxChartSimpleSeriesPieValueLabelViewInfo = class(TdxChartSeriesValueLabelViewInfo)
  strict private
    function GetAppearance: TdxChartSimpleSeriesViewAppearanceValueLabelAppearance; inline;
    function GetHalfAngle: Single;
    function GetLabelOptions: TdxChartPieValueLabels; inline;
    function GetOwner: TdxChartSimpleSeriesPieValueViewInfo; inline;
  protected
    function CalculateValidBounds(const ABoundingRect: TdxRectF): TdxRectF; override;
    function GetActualPen: TcxCanvasBasedPen; override;
    function GetColor: TdxAlphaColor; override;
    function GetPieCenter: TdxPointF;
    function GetTextAngle: Single; override;
    function GetTextCenter: TdxPointF;

    property Appearance: TdxChartSimpleSeriesViewAppearanceValueLabelAppearance read GetAppearance;
    property HalfAngle: Single read GetHalfAngle;
    property Options: TdxChartPieValueLabels read GetLabelOptions;
    property Owner: TdxChartSimpleSeriesPieValueViewInfo read GetOwner;
  public
    procedure Offset(const ADistance: TdxPointF); overload; override;
  end;

  { TdxChartSimpleSeriesDoughnutView }

  TdxChartSimpleSeriesDoughnutView = class(TdxChartSimpleSeriesCustomPieView)
  public const
    DefaultHoleRadius: Single = 50;
  protected
    function CreateViewInfo: TdxChartSeriesViewCustomViewInfo; override;
    function GetDefaultHoleRadius: Single; override;
    function GetDefaultTotalLabelPosition: TdxAlignment; override;
  public
    class function GetDescription: string; override;
  published
    property Appearance;
    property ExplodedValueOptions;
    property HoleRadius;
    property OnCanExplodeValue;
    property StartAngle;
    property SweepDirection;
    property TotalLabel;
    property ValueLabels;
  end;

  { TdxChartSimpleSeriesDoughnutViewInfo }

  TdxChartSimpleSeriesDoughnutViewInfo = class(TdxChartSimpleSeriesPieViewInfo)
  protected
    function GetValueViewInfoClass: TdxChartSeriesValueViewInfoClass; override;
  end;

  { TdxChartSimpleSeriesDoughnutValueViewInfo }

  TdxChartSimpleSeriesDoughnutValueViewInfo = class(TdxChartSimpleSeriesPieValueViewInfo)
  strict private
    function GetHoleRadius: Single; inline;
  protected
    procedure DrawGlyphSlice(ACanvas: TcxCustomCanvas; const R: TdxRectF); override;
    function GetHoleRadiusInPixels: Single; override;
  public
    procedure Draw(ACanvas: TcxCustomCanvas); override;

    property HoleRadius: Single read GetHoleRadius;
  end;

  { TdxChartSeriesValueLabelsResolveOverlappingAlgorithm }

  TdxChartSeriesValueLabelsResolveOverlappingAlgorithm = class abstract // for internal use
  protected
    FDiagramBounds: TdxRectF;
    FIndent: Single;
    FLabels: TdxChartSeriesValueLabelViewInfoList;
  public
    constructor Create(const ALabels: TdxChartSeriesValueLabelViewInfoList;
      const ADiagramBounds: TdxRectF; AIndent: Single); virtual;
    procedure ArrangeLabels; virtual; abstract;
  end;

  { TdxChartSimpleSeriesResolveOverlappingByColumn }

  TdxChartSimpleSeriesResolveOverlappingByColumn = class(TdxChartSeriesValueLabelsResolveOverlappingAlgorithm) // for internal use
  private
    type
      { TdxLabelInfo }

      TdxLabelInfo = class
      public
        CorrectedLabelBounds: TdxRectF;
        DiagramBounds: TdxRectF;
        LabelBounds: TdxRectF;
        LabelViewInfo: TdxChartSimpleSeriesPieValueLabelViewInfo;
        Next: TdxLabelInfo;
        Prev: TdxLabelInfo;

        constructor Create(const ALabel: TdxChartSimpleSeriesPieValueLabelViewInfo;
          const ADiagramBounds: TdxRectF; AIndent: Single);
        procedure Flush;
        function GetCenter: Single;
        function GetOverlap: Single;
        procedure Offset(AOffset: Single);
      end;

      { TdxLabelInfoComparer }

      TdxLabelInfoComparer = class(TdxComparer<TdxLabelInfo>)
      public
        function Compare(const Left, Right: TdxLabelInfo): Integer; override;
      end;

      { TdxLabelInfoList }

      TdxLabelInfoList = class(TdxList<TdxLabelInfo>);

  private
    FComparer: TdxLabelInfoComparer;

    function Arrange(ALabelInfo: TdxLabelInfo; ABottomPriority: Boolean): Boolean;
    procedure ArrangeGroup(const ALabels: TdxChartSeriesValueLabelViewInfoList);
    procedure ArrangeNonOverlapping(const ALabels: TdxLabelInfoList; const AFocuses: TList<Single>);
    procedure ArrangeOverlapping(const ALabels: TdxLabelInfoList; AWholeOverlap: Single);
    procedure BottomArrange(ALabelInfo: TdxLabelInfo);
    function CalculateFocuses: TList<Single>;
    function CalculateBottomMargin(ALabelInfo: TdxLabelInfo): Single;
    function CalculateTopMargin(ALabelInfo: TdxLabelInfo): Single;
    function CalculateWholeOverlap(const ALabels: TdxLabelInfoList): Single;
    function GetLabelsForArrangeByColumn(const ALabels: TdxChartSeriesValueLabelViewInfoList): TdxLabelInfoList;
    procedure GroupLabelsByColumns(const ALabels: TdxChartSeriesValueLabelViewInfoList;
      const ALeft, ARight: TdxChartSeriesValueLabelViewInfoList);
    function IsBottomPriority(ALabel: TdxLabelInfo; const AFocuses: TList<Single>): Boolean;
    procedure PushNextToBottom(ALabelInfo: TdxLabelInfo; AValue: Single);
    procedure PushPrevToTop(ALabelInfo: TdxLabelInfo; AValue: Single);
    procedure PushToBottom(ALabelInfo: TdxLabelInfo; AValue: Single);
    procedure PushToTop(ALabelInfo: TdxLabelInfo; AValue: Single);
    procedure SetLabelItemPrevAndNext(ALabel: TdxLabelInfo; APrev: TdxLabelInfo; ANext: TdxLabelInfo);
    procedure TopArrange(ALabelInfo: TdxLabelInfo);
  public
    constructor Create(const ALabels: TdxChartSeriesValueLabelViewInfoList;
      const ADiagramBounds: TdxRectF; AIndent: Single); override;
    destructor Destroy; override;

    procedure ArrangeLabels; override;
  end;

  { TdxChartSimpleSeriesResolveOverlappingByEllipse }

  TdxChartSimpleSeriesResolveOverlappingByEllipse = class(TdxChartSeriesValueLabelsResolveOverlappingAlgorithm)  // for internal use
  strict private
    type
      { TdxLabelInfo }

      TdxLabelInfo = class
      public
        Arranged: Boolean;
        CurrentSrc: Boolean;
        EllipseCenter: TdxPointF;
        Indent: Single;
        LabelBounds: TdxRectF;
        LabelViewInfo: TdxChartSimpleSeriesPieValueLabelViewInfo;
        Next: TdxLabelInfo;
        NextLabelNearest: TdxNullableValue<Boolean>;
        OccupiedHeight: Single;
        OccupiedWidth: Single;
        Prev: TdxLabelInfo;
        RefAngle: Single;

        constructor Create(const ALabel: TdxChartSimpleSeriesPieValueLabelViewInfo;
          AIndent: Single; const AEllipseCenter: TdxPointF);
        procedure Flush;
        procedure SetCenter(APoint: TdxPointF);
      end;

      { TdxLabelInfoComparer }

      TdxLabelInfoComparer = class(TdxComparer<TdxLabelInfo>)
      public
        function Compare(const Left, Right: TdxLabelInfo): Integer; override;
      end;

      { TdxLabelInfoList }

      TdxLabelInfoList = class(TdxList<TdxLabelInfo>);

      { TdxLabelInfoComparer }

      TdxLabelInfoGroupComparer = class(TdxComparer<TdxLabelInfoList>)
      public
        function Compare(const Left, Right: TdxLabelInfoList): Integer; override;
      end;

  private
    FComparer: TdxLabelInfoComparer;
    FGroupComparer: TdxLabelInfoGroupComparer;
    FSortedList: TdxLabelInfoList;
    FEllipse: TdxRectF;
    FDirection: TdxChartPieSweepDirection;

    function Arrange(ALabelInfo: TdxLabelInfo): Boolean;
    procedure ArrangeByEllipse(const ALabels: TdxLabelInfoList);
    function CalculateAngle(const AP1, AP2: TdxPointF): Single;
    function CalculateCenter(ALabelInfo: TdxLabelInfo; AFromPrev: Boolean): TdxPointF;
    function CalculateGroups(const ALabelsInfo: TdxLabelInfoList): TdxList<TdxLabelInfoList>;
    procedure CorrectCenterByDiagramBounds(ALabelInfo: TdxLabelInfo; const ACenter: TdxPointF);
    function FindPoint(const APoints: TList<TdxPointF>; const ABounds: TdxRectF; const ACenter: TdxPointF; AForward: Boolean): TdxPointF;
    function GetArrangedNext(ALabelInfo: TdxLabelInfo): TdxLabelInfo;
    function GetArrangedPrev(ALabelInfo: TdxLabelInfo): TdxLabelInfo;
    function GetLabelsForArrangeByEllipse: TdxLabelInfoList;
    function GetNextByRefAngle(ALabelInfo: TdxLabelInfo): TdxLabelInfo;
    function GetPrevByRefAngle(ALabelInfo: TdxLabelInfo): TdxLabelInfo;
    function IsAngleInRange(AAngle, AAngle1, AAngle2: Single): Boolean;
    function IsCorrectedPositionValid(ALabelInfo: TdxLabelInfo; AFromPrev: TdxNullableValue<Boolean>): Boolean;
    function IsPositionValid(ALabelInfo: TdxLabelInfo): Boolean; overload;
    function IsPositionValid(ALabelInfo: TdxLabelInfo; AFromPrev: Boolean): Boolean; overload;
    function IsPositionValidByBounds(ALabelInfo: TdxLabelInfo): Boolean;
    function NextLabelIsNearest(ALabelInfo: TdxLabelInfo): Boolean;
    procedure Push(ALabelInfo: TdxLabelInfo; AForward: Boolean);
  public
    constructor Create(const ALabels: TdxChartSeriesValueLabelViewInfoList; const ADiagramBounds: TdxRectF; AIndent: Single;
      const AEllipse: TdxRectF; ADirection: TdxChartPieSweepDirection); reintroduce;
    destructor Destroy; override;

    procedure ArrangeLabels; override;
  end;

  { TdxChartSimpleSeriesPieValueLabelsOverlappingResolver }

  TdxChartSimpleSeriesPieValueLabelsOverlappingResolver = class  // for internal use
  public
    class procedure ArrangeByColumn(const ALabels: TdxChartSeriesValueLabelViewInfoList;
      const ADiagramBounds: TdxRectF; AIndent: Single);
    class procedure ArrangeByEllipse(const ALabels: TdxChartSeriesValueLabelViewInfoList;
      const ADiagramBounds: TdxRectF; AIndent: Single; const AEllipse: TdxRectF; ADirection: TdxChartPieSweepDirection);
  end;

implementation

uses
  RTLConsts;

const
  dxThisUnitName = 'dxChartSimpleDiagram';

type
  TdxChartCustomLegendAccess = class(TdxChartCustomLegend);
  TdxChartCustomSeriesAccess = class(TdxChartCustomSeries);

function GetPointOnCircle(const ACenter: TdxPointF; ARadius, AAngle: Single): TdxPointF; inline;
var
  ASin, ACos: Single;
begin
  SinCos(DegToRad(360 - AAngle), ASin, ACos);
  Result.X := ACenter.X + Round(ARadius * ACos);
  Result.Y := ACenter.Y + Round(ARadius * ASin);
end;

procedure GetStartAndMiddleRadialPoints(const R: TdxRectF; AStartAngle, ASweepAngle, AHoleRadius: Single; var AStart, AFinish: TdxPointF);
const
  HalfRadius: Single = 0.5; 
  CenterOfMassOffset: Single = 0.15;
var
  ARadius, ACenterOfMass: Single;
begin
  AStart := R.CenterPoint;
  ARadius := R.Width / 2;
  ACenterOfMass := HalfRadius;
  if (AHoleRadius < ARadius * 0.5) and (ASweepAngle < 180) then
    ACenterOfMass := ACenterOfMass + CenterOfMassOffset * (1 - (ASweepAngle / 180));
  ARadius := ((ARadius - AHoleRadius)  * ACenterOfMass) + AHoleRadius;
  AFinish := GetPointOnCircle(AStart, ARadius, AStartAngle + ASweepAngle / 2);
end;

procedure GetStartAndOutsideRadialPoints(const R: TdxRectF; AAngle, ALineSize: Single; var AStart, AFinish: TdxPointF);
var
  ARadius: Single;
begin
  ARadius := R.Width / 2;
  if ARadius > 0 then
    AStart := GetPointOnCircle(R.CenterPoint, ARadius, AAngle)
  else
    AStart := R.CenterPoint;
  AFinish := GetPointOnCircle(R.CenterPoint, ARadius + ALineSize, AAngle);
end;

{ TdxChartGetTotalLabelDrawParametersEventArgs }

constructor TdxChartGetTotalLabelDrawParametersEventArgs.Create(ASeries: TdxChartCustomSeries;
  ATotalValue: Double; const AText: string);
begin
  inherited Create;
  FSeries := ASeries;
  FTotalValue := ATotalValue;
  FText := AText;
end;

{ TdxChartSimpleDiagramToolTipOptions }

constructor TdxChartSimpleDiagramToolTipOptions.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FMode := TdxChartToolTipMode.Default;
end;

procedure TdxChartSimpleDiagramToolTipOptions.DoAssign(Source: TPersistent);
begin
  inherited DoAssign(Source);
  if Source is TdxChartSimpleDiagramToolTipOptions then
    Mode := TdxChartSimpleDiagramToolTipOptions(Source).Mode;
end;

{ TdxChartSimpleDiagram }

constructor TdxChartSimpleDiagram.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDimension := 1;
end;

procedure TdxChartSimpleDiagram.AssignFrom(
  ASource: TdxChartCustomDiagram; ARecreate: Boolean = True; AStoreList: TdxFastObjectList = nil);
begin
  if ASource is TdxChartSimpleDiagram then
  begin
    FDimension := TdxChartSimpleDiagram(ASource).Dimension;
    FLayout := TdxChartSimpleDiagram(ASource).Layout;
  end;
  inherited AssignFrom(ASource, ARecreate, AStoreList);
end;

procedure TdxChartSimpleDiagram.SetDimension(AValue: Integer);
begin
  AValue := Max(AValue, 1);
  if AValue <> Dimension then
  begin
    FDimension := AValue;
    Changed;
  end;
end;

procedure TdxChartSimpleDiagram.SetLayout(AValue: TdxSimpleDiagramLayout);
begin
  if AValue <> FLayout then
  begin
    FLayout := AValue;
    Changed;
  end;
end;

function TdxChartSimpleDiagram.AddSeries(const ACaption: string = ''): TdxChartSimpleSeries;
begin
  Result := inherited AddSeries(ACaption) as TdxChartSimpleSeries;
end;

procedure TdxChartSimpleDiagram.ForEachSeries(AHandler: TForEachSeriesProc);
var
  I: Integer;
begin
  for I := 0 to SeriesCount - 1 do
    AHandler(Series[I]);
end;

function TdxChartSimpleDiagram.CreateToolTipOptions: TdxChartDiagramToolTipOptions;
begin
  Result := TdxChartSimpleDiagramToolTipOptions.Create(Self);
end;

function TdxChartSimpleDiagram.CreateViewData: TdxChartDiagramCustomViewData;
begin
  Result := TdxChartSimpleDiagramViewData.Create(Self);
end;

function TdxChartSimpleDiagram.CreateViewInfo: TdxChartDiagramCustomViewInfo;
begin
  Result := TdxChartSimpleDiagramViewInfo.Create(Self);
end;

procedure TdxChartSimpleDiagram.DoGetTotalLabelDrawParameters(AArgs: TdxChartGetTotalLabelDrawParametersEventArgs);
begin
  if Assigned(OnGetTotalLabelDrawParameters) then
    OnGetTotalLabelDrawParameters(Self, AArgs);
end;

function TdxChartSimpleDiagram.GetSeriesClass: TdxChartSeriesClass;
begin
  Result := TdxChartSimpleSeries;
end;

function TdxChartSimpleDiagram.GetToolTips: TdxChartSimpleDiagramToolTipOptions;
begin
  Result := TdxChartSimpleDiagramToolTipOptions(inherited ToolTips);
end;

function TdxChartSimpleDiagram.GetActualToolTipMode: TdxChartActualToolTipMode;
begin
  if ToolTips.Mode = TdxChartToolTipMode.Default then
  begin
    if Chart.ToolTips.DefaultMode = TdxChartToolTipMode.Simple then
      Result := TdxChartToolTipMode.Simple
    else
      Result := TdxChartToolTipMode.None;
  end
  else
    Result := TdxChartActualToolTipMode(ToolTips.Mode);
end;

function TdxChartSimpleDiagram.GetSeries(AIndex: Integer): TdxChartSimpleSeries;
begin
  Result := TdxChartSimpleSeries(inherited SeriesList[AIndex]);
end;

function TdxChartSimpleDiagram.GetVisibleSeries(AIndex: Integer): TdxChartSimpleSeries;
begin
  Result := TdxChartSimpleSeries(inherited VisibleSeries[AIndex]);
end;

procedure TdxChartSimpleDiagram.SetSeries(AIndex: Integer; const AValue: TdxChartSimpleSeries);
begin
  Series[AIndex].Assign(AValue);
end;

procedure TdxChartSimpleDiagram.SetToolTips(AValue: TdxChartSimpleDiagramToolTipOptions);
begin
  ToolTips.Assign(AValue);
end;

{ TdxChartSimpleDiagramViewData }

function TdxChartSimpleDiagramViewData.AllowSorting: Boolean;
begin
  Result := True;
end;

{ TdxChartSimpleDiagramViewInfo }

function TdxChartSimpleDiagramViewInfo.GetDiagram: TdxChartSimpleDiagram;
begin
  Result := TdxChartSimpleDiagram(inherited Diagram);
end;

function TdxChartSimpleDiagramViewInfo.GetViewData: TdxChartSimpleDiagramViewData;
begin
  Result := TdxChartSimpleDiagramViewData(inherited ViewData);
end;

function TdxChartSimpleDiagramViewInfo.GetSeries(AIndex: Integer): TdxChartSimpleSeries;
begin
  Result := TdxChartSimpleSeries(inherited Series[AIndex]);
end;

procedure TdxChartSimpleDiagramViewInfo.CalculateOptimalAutoLayout;
var
  I, AColCount, ARowCount: Integer;
  W, H: Single;
begin
  W := ContentBounds.Width;
  H := ContentBounds.Height;
  FHorizontalLayout := W > H;
  FDimension := 1;
  if (Round(W) = 0) or (Round(H) = 0) then
    Exit;
  for I := 1 to SeriesCount - 1 do
  begin
    FDimension := I;
    AColCount := Dimension;
    ARowCount := Ceil(SeriesCount / AColCount);
    if not HorizontalLayout then
      ExchangeIntegers(AColCount, ARowCount);
    if (HorizontalLayout and ((W / Dimension) / (H / ARowCount) < 1.5)) or
      (not HorizontalLayout and ((H / Dimension) / (W / AColCount) < 1.5)) then
        Break;
  end;
end;

procedure TdxChartSimpleDiagramViewInfo.CalculateViews(ACanvas: TcxCustomCanvas);
var
  ALineBounds, ASeriesBounds: TdxRectF;
  I, AIndex, AItemsInLine, AColumnCount, ARowCount: Integer;
  ASeries: TdxChartSimpleSeries;
  ASeriesViewInfo: TdxChartSimpleSeriesViewInfo;
begin
  Items.Clear;
  if SeriesCount = 0 then
    Exit;
  FHorizontalLayout := Diagram.Layout = TdxSimpleDiagramLayout.Horizontal;
  FDimension := Diagram.Dimension;
  if Diagram.Layout = TdxSimpleDiagramLayout.Auto then
    CalculateOptimalAutoLayout;
  ALineBounds := PlotArea;
  AColumnCount := Min(Dimension, SeriesCount);
  ARowCount := Ceil(SeriesCount / AColumnCount);
  if not HorizontalLayout then
    ExchangeIntegers(AColumnCount, ARowCount);
  AItemsInLine := 0;
  for I := 0 to SeriesCount - 1 do
  begin
    AIndex := I mod Dimension;
    if AIndex = 0 then
    begin
      if HorizontalLayout then
      begin
        AItemsInLine := Min(AColumnCount, SeriesCount - I);
        dxCalcPosition(I div AColumnCount, ARowCount, PlotArea.Height, PlotArea.Top,
          0, ALineBounds.Top, ALineBounds.Bottom) 
      end
      else
      begin
        AItemsInLine := Min(ARowCount, SeriesCount - I);
        dxCalcPosition(I div ARowCount, AColumnCount, PlotArea.Width, PlotArea.Left,
          0, ALineBounds.Left, ALineBounds.Right); 
      end;
      ASeriesBounds := ALineBounds;
    end;
    if HorizontalLayout then
      dxCalcPosition(AIndex, AItemsInLine, ALineBounds.Width, ALineBounds.Left,
        0, ASeriesBounds.Left, ASeriesBounds.Right) 
    else
      dxCalcPosition(AIndex, AItemsInLine, ALineBounds.Height, ALineBounds.Top,
        0, ASeriesBounds.Top, ASeriesBounds.Bottom); 
    ASeries := Series[I];
    ASeriesViewInfo := ASeries.View.ViewInfo;
    ASeriesViewInfo.Visible := ASeries.ActuallyVisible;
    if ASeriesViewInfo.Visible then
    begin
       ASeriesViewInfo.SetBounds(ASeriesBounds.Content(ASeriesViewInfo.Margins), PlotArea);
       Items.Add(ASeriesViewInfo);
    end;
  end;
end;

{ TdxChartSimpleSeries }

class function TdxChartSimpleSeries.CanHaveTitle: Boolean;
begin
  Result := True;
end;

procedure TdxChartSimpleSeries.DoChanged;
begin
  if TSeriesChange.Data in Changes then
    Changes := Changes + LegendChanges[ShowInLegend];
  inherited DoChanged;
end;

procedure TdxChartSimpleSeries.DoPopulateLegend(ALegend: TdxChartCustomLegend);
begin
  View.ViewInfo.ForEachValue(
    procedure(AValue: TdxChartSeriesValueViewInfo)
    var
      AIntf: IdxChartLegendItem;
    begin
      if Supports(AValue, IdxChartLegendItem, AIntf) then
        TdxChartCustomLegendAccess(ALegend).AddItem(AIntf);
    end);
end;

class function TdxChartSimpleSeries.GetBaseViewClass: TdxChartSeriesViewClass;
begin
  Result := TdxChartSimpleSeriesCustomView;
end;

function TdxChartSimpleSeries.GetView: TdxChartSimpleSeriesCustomView;
begin
  Result := TdxChartSimpleSeriesCustomView(inherited View);
end;

procedure TdxChartSimpleSeries.SetView(AValue: TdxChartSimpleSeriesCustomView);
begin
  View.Assign(AValue);
end;

{ TdxChartSimpleSeriesViewAppearance }

function TdxChartSimpleSeriesViewAppearance.GetActualColor(AIndex: Integer): TdxAlphaColor;
begin
  if AIndex = PenColorIndex then
    Result := ColorScheme.PieSeriesView.BorderColor
  else
    Result := inherited GetActualColor(AIndex);
end;

function TdxChartSimpleSeriesViewAppearance.HasFillOptions: Boolean;
begin
  Result := True;
end;

function TdxChartSimpleSeriesViewAppearance.HasStrokeOptions: Boolean;
begin
  Result := True;
end;

procedure TdxChartSimpleSeriesViewAppearance.UpdateActualValues(ACanvas: TcxCustomCanvas);
begin
  inherited UpdateActualValues(ACanvas);
  FActualGlyphCorrection := StrokeOptions.Width;
end;

{ TdxChartSimpleSeriesViewAppearanceValueLabelAppearance }

function TdxChartSimpleSeriesViewAppearanceValueLabelAppearance.GetActualColor(AIndex: Integer): TdxAlphaColor;
begin
  if AIndex = TextColorIndex then
    Result := TdxAlphaColors.FromColor(ColorScheme.SeriesLabel.TextColor)
  else
    Result := inherited GetActualColor(AIndex);
end;

{ TdxChartSimpleSeriesCustomView }

function TdxChartSimpleSeriesCustomView.GetAppearance: TdxChartSimpleSeriesViewAppearance;
begin
  Result := TdxChartSimpleSeriesViewAppearance(inherited Appearance);
end;

function TdxChartSimpleSeriesCustomView.GetViewData: TdxChartSimpleSeriesViewData;
begin
  Result := TdxChartSimpleSeriesViewData(inherited ViewData);
end;

function TdxChartSimpleSeriesCustomView.GetViewInfo: TdxChartSimpleSeriesViewInfo;
begin
  Result := TdxChartSimpleSeriesViewInfo(inherited ViewInfo);
end;

procedure TdxChartSimpleSeriesCustomView.SetAppearance(AValue: TdxChartSimpleSeriesViewAppearance);
begin
  Appearance.Assign(AValue);
end;

class function TdxChartSimpleSeriesCustomView.CanAggregate(AView: TdxChartSeriesCustomView): Boolean;
begin
  Result := False;
end;

function TdxChartSimpleSeriesCustomView.CreateAppearance: TdxChartVisualElementAppearance;
begin
  Result := TdxChartSimpleSeriesViewAppearance.Create(Self);
end;

function TdxChartSimpleSeriesCustomView.CreateViewData: TdxChartSeriesViewCustomViewData;
begin
  Result := TdxChartSimpleSeriesViewData.Create(Self);
end;

function TdxChartSimpleSeriesCustomView.CreateViewInfo: TdxChartSeriesViewCustomViewInfo;
begin
  Result := TdxChartSimpleSeriesViewInfo.Create(Self);
end;

function TdxChartSimpleSeriesCustomView.GetValueLabelAppearanceClass: TdxChartSeriesValueLabelAppearanceClass;
begin
  Result := TdxChartSimpleSeriesViewAppearanceValueLabelAppearance;
end;

class function TdxChartSimpleSeriesCustomView.IsCompatibleWith(AView: TdxChartSeriesCustomView): Boolean;
begin
  Result := AView.InheritsFrom(TdxChartSimpleSeriesCustomView);
end;

procedure TdxChartSimpleSeriesCustomView.LayoutChanged;
var
  ASeries: TdxChartCustomSeriesAccess;
begin
  ASeries := TdxChartCustomSeriesAccess(Series);
  if ActuallyVisible then
    ASeries.Changed(TdxChartCustomSeriesAccess.TSeriesChange.Layout)
  else
    ASeries.Changed(ASeries.LegendChanges[ASeries.ShowInLegend]);
end;

{ TdxChartSimpleSeriesViewData }

constructor TdxChartSimpleSeriesViewData.Create(AOwner: TdxChartSeriesCustomView);
begin
  inherited Create(AOwner);
  FHiddenItems := TList.Create;
end;

destructor TdxChartSimpleSeriesViewData.Destroy;
begin
  FreeAndNil(FHiddenItems);
  inherited Destroy;
end;

procedure TdxChartSimpleSeriesViewData.ClearHiddenItems;
begin
  FHiddenItems.Clear;
  Changed;
end;

function TdxChartSimpleSeriesViewData.GetView: TdxChartSimpleSeriesCustomView;
begin
  Result := TdxChartSimpleSeriesCustomView(inherited View);
end;

function TdxChartSimpleSeriesViewData.GetSeries: TdxChartSimpleSeries;
begin
  Result := TdxChartSimpleSeries(View.Series);
end;

function TdxChartSimpleSeriesViewData.AllowSorting: Boolean;
begin
  Result := True;
end;

procedure TdxChartSimpleSeriesViewData.Changed;
begin
  View.ViewInfo.Dirty := True;
  inherited Changed;
end;

procedure TdxChartSimpleSeriesViewData.CheckValue(AValue: TdxChartSeriesValueViewInfo);
begin
  if not AValue.Hidden then
  begin
    inherited CheckValue(AValue);
    Inc(View.ViewInfo.FVisibleCount);
  end;
end;

procedure TdxChartSimpleSeriesViewData.HiddenChanged(AValue: TdxChartSimpleSeriesValueViewInfo);
begin
  if AValue.Hidden then
    HiddenItems.Add(AValue.&Record)
  else
    HiddenItems.Remove(AValue.&Record);
  Changed;
end;

function TdxChartSimpleSeriesViewData.IsSourceValueValid(ARecord: PdxDataRecord): Boolean;
begin
  Result := (ARecord <> nil) and (ValueField <> nil) and not ValueField.IsNull[ARecord] and
    (CompareValue(ValueField.Value[ARecord], 0.0) > 0);
end;

function TdxChartSimpleSeriesViewData.IsValueHidden(AValue: TdxChartSimpleSeriesValueViewInfo): Boolean;
begin
  Result := FHiddenItems.IndexOf(AValue.&Record) >= 0;
end;

{ TdxChartSimpleSeriesValueViewInfo }

constructor TdxChartSimpleSeriesValueViewInfo.Create(
  AOwner: TdxChartSeriesViewCustomViewInfo; APriorValue: TdxChartSeriesValueViewInfo);
begin
  inherited Create(AOwner, APriorValue);
  FAppearance := Owner.GetColorizedAppearance(Index)
end;

destructor TdxChartSimpleSeriesValueViewInfo.Destroy;
begin
  FreeAndNil(FAppearance);
  inherited Destroy;
end;

procedure TdxChartSimpleSeriesValueViewInfo.CalculateDisplayText;
begin
  inherited CalculateDisplayText;
  if Assigned(TdxChartSimpleDiagram(ViewData.Series.Diagram).OnGetValueLabelDrawParameters) then
    RaiseGetValueLabelDrawParametersEvent(FDisplayText);
end;

procedure TdxChartSimpleSeriesValueViewInfo.CalculateValue;
begin
  inherited CalculateValue;
  Hidden := ViewData.IsValueHidden(Self);
end;

function TdxChartSimpleSeriesValueViewInfo.GetAppearance: TdxChartVisualElementAppearance;
begin
  Result := FAppearance;
end;

procedure TdxChartSimpleSeriesValueViewInfo.UpdateRecord(const ARecord: PdxDataRecord);
begin
  inherited UpdateRecord(ARecord);
  if ARecord = nil then
    FDisplayLabel := cxGetResourceString(@sdxChartOtherValueLabel)
  else
  begin
    if ViewData.ArgumentField = nil then
      FDisplayLabel := ''
    else
      FDisplayLabel := ViewData.ArgumentField.DisplayText[ARecord];
  end;
end;

function TdxChartSimpleSeriesValueViewInfo.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := S_OK
  else
    Result := E_NOINTERFACE;
end;

function TdxChartSimpleSeriesValueViewInfo._AddRef: Integer;
begin
  Result := -1;
end;

function TdxChartSimpleSeriesValueViewInfo._Release: Integer;
begin
  Result := -1;
end;

function TdxChartSimpleSeriesValueViewInfo.GetCaption: string;
begin
  Result := DisplayLabel;
end;

function TdxChartSimpleSeriesValueViewInfo.GetColor: TdxAlphaColor;
begin
  Result := FAppearance.ActualColor;
end;

function TdxChartSimpleSeriesValueViewInfo.IsChecked: Boolean;
begin
  Result := not Hidden;
end;

function TdxChartSimpleSeriesValueViewInfo.IsEnabled: Boolean;
begin
  Result := Hidden or (Owner.VisibleCount > 1);
end;

procedure TdxChartSimpleSeriesValueViewInfo.SetChecked(AValue: Boolean);
begin
  if AValue = not Hidden then
    Exit;
  Hidden := not AValue;
  ViewData.HiddenChanged(Self);
end;

function TdxChartSimpleSeriesValueViewInfo.GetOwner: TdxChartSimpleSeriesViewInfo;
begin
  Result := TdxChartSimpleSeriesViewInfo(inherited Owner);
end;

function TdxChartSimpleSeriesValueViewInfo.GetViewData: TdxChartSimpleSeriesViewData;
begin
  Result := TdxChartSimpleSeriesViewData(inherited ViewData);
end;

{ TdxChartSimpleSeriesViewInfo }

function TdxChartSimpleSeriesViewInfo.GetActualGlyphCorrection: Single;
begin
  Result := TdxChartSimpleSeriesViewAppearance(Appearance).ActualGlyphCorrection;
end;

function TdxChartSimpleSeriesViewInfo.GetSeries: TdxChartSimpleSeries;
begin
  Result := TdxChartSimpleSeries(inherited Series);
end;

function TdxChartSimpleSeriesViewInfo.GetView: TdxChartSimpleSeriesCustomView;
begin
  Result := TdxChartSimpleSeriesCustomView(inherited View);
end;

function TdxChartSimpleSeriesViewInfo.GetViewData: TdxChartSimpleSeriesViewData;
begin
  Result := TdxChartSimpleSeriesViewData(inherited ViewData);
end;

procedure TdxChartSimpleSeriesViewInfo.PrepareItems(ARecords: TdxFastList);
begin
  ViewData.CalculateSummary(ARecords);
  inherited PrepareItems(ARecords);
end;

{ TdxChartSimpleSeriesViewInfo }

procedure TdxChartSimpleSeriesViewInfo.CalculateValues(ACanvas: TcxCustomCanvas);
begin
  FVisibleCount := 0;
  inherited CalculateValues(ACanvas);
end;

procedure TdxChartSimpleSeriesViewInfo.ClearValues;
begin
  inherited ClearValues;
  FVisibleCount := 0;
end;

procedure TdxChartSimpleSeriesViewInfo.DoDraw(ACanvas: TcxCustomCanvas);
begin
  inherited DoDraw(ACanvas);
end;

function TdxChartSimpleSeriesViewInfo.NeedDisplayTextCalculation: Boolean;
begin
  Result := FDrawLabels or FShowInLegend;
end;

{ TdxChartPieValueLabels }

constructor TdxChartPieValueLabels.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FResolveOverlappingMode := TdxChartSeriesValueLabelsResolveOverlappingMode.Default;
end;

procedure TdxChartPieValueLabels.DoAssign(Source: TPersistent);
begin
  inherited DoAssign(Source);
  if Source is TdxChartPieValueLabels then
  begin
    FPosition := TdxChartPieValueLabels(Source).Position;
    FResolveOverlappingMode := TdxChartPieValueLabels(Source).ResolveOverlappingMode;
  end;
end;

function TdxChartPieValueLabels.GetResolveOverlappingMode: TdxChartSeriesValueLabelsResolveOverlappingMode;
begin
  Result := FResolveOverlappingMode;
end;

function TdxChartPieValueLabels.GetTextFormatter: TObject;
begin
  if TdxChartTextFormatController.GetFormat(inherited GetTextFormatter) = '' then
    Result := TdxChartTextFormatController.FormatController.SimpleSeriesDefaultFormatter
  else
    Result := inherited GetTextFormatter;
end;

function TdxChartPieValueLabels.IsOutsideLabel: Boolean;
begin
  Result := ActuallyVisible and
    (FPosition in [TdxChartPieValueLabelPosition.Outside, TdxChartPieValueLabelPosition.TwoColumns]);
end;

procedure TdxChartPieValueLabels.SetPosition(AValue: TdxChartPieValueLabelPosition);
begin
  if AValue <> FPosition then
  begin
    FPosition := AValue;
    LayoutChanged;
  end;
end;

procedure TdxChartPieValueLabels.SetResolveOverlappingMode(AValue: TdxChartPieValueLabelsResolveOverlappingMode);
begin
  if AValue <> ResolveOverlappingMode then
  begin
    FResolveOverlappingMode := AValue;
    LayoutChanged;
  end;
end;

{ TdxChartCanExplodeValueEventArgs }

constructor TdxChartCanExplodeValueEventArgs.Create(ASeriesPoint: TdxChartSeriesPointInfo);
begin
  inherited Create;
  FSeriesPoint := ASeriesPoint;
end;

destructor TdxChartCanExplodeValueEventArgs.Destroy;
begin
  FreeAndNil(FSeriesPoint);
  inherited Destroy;
end;

{ TdxChartExplodedValueOptions }

constructor TdxChartExplodedValueOptions.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  Distance := DefaultDistance;
end;

procedure TdxChartExplodedValueOptions.Changed;
begin
  View.Changed;
end;

procedure TdxChartExplodedValueOptions.DoAssign(Source: TPersistent);
begin
  inherited DoAssign(Source);
  if Source is TdxChartExplodedValueOptions then
  begin
    FDistance := TdxChartExplodedValueOptions(Source).FDistance;
    FMode := TdxChartExplodedValueOptions(Source).FMode;
    FRuntimeExploding := TdxChartExplodedValueOptions(Source).FRuntimeExploding;
  end;
end;

function TdxChartExplodedValueOptions.IsValueExploded(AValue: TdxChartSimpleSeriesValueViewInfo): Boolean;
var
  AArgs: TdxChartCanExplodeValueEventArgs;
begin
  case Mode of
    TdxChartExplodedValueMode.None:
      Result := False;
    TdxChartExplodedValueMode.All:
      Result := True;
    TdxChartExplodedValueMode.Min:
      Result := View.ViewData.MinValue = AValue;
    TdxChartExplodedValueMode.Max:
      Result := View.ViewData.MaxValue = AValue;
    TdxChartExplodedValueMode.Custom:
      begin
        AArgs := TdxChartCanExplodeValueEventArgs.Create(AValue.CreateSeriesPointInfo);
        try
          View.DoCanExplodeValue(AArgs);
          Result := AArgs.CanExplode;
        finally
          FreeAndNil(AArgs);
        end;
      end;
  else
    Result := False;
  end;
end;

function TdxChartExplodedValueOptions.GetView: TdxChartSimpleSeriesCustomPieView;
begin
  Result := TdxChartSimpleSeriesCustomPieView(Owner);
end;

function TdxChartExplodedValueOptions.IsDistanceStored: Boolean;
begin
  Result := not SameValue(Distance, DefaultDistance);
end;

procedure TdxChartExplodedValueOptions.SetDistance(AValue: Single);
begin
  AValue := Min(90, Max(0, AValue));
  if not SameValue(AValue, FDistance) then
  begin
    FDistance := AValue;
    if Mode <> TdxChartExplodedValueMode.None then
      Changed;
  end;
end;

procedure TdxChartExplodedValueOptions.SetMode(AValue: TdxChartExplodedValueMode);
begin
  if AValue <> FMode then
  begin
    FMode := AValue;
    Changed;
  end
end;

{ TdxChartSimpleSeriesTotalLabel }

function TdxChartSimpleSeriesTotalLabel.CreateViewInfo: TdxChartVisualElementCustomViewInfo;
begin
  Result := TdxChartSimpleSeriesTotalLabelViewInfo.Create(Self);
end;

destructor TdxChartSimpleSeriesTotalLabel.Destroy;
begin
  TdxChartTextFormatController.Release(FTextFormatter);
  inherited Destroy;
end;

function TdxChartSimpleSeriesTotalLabel.ActuallyVisible: Boolean;
begin
  Result := Visible and ((View.ViewInfo.VisibleCount > 0) or (Text <> ''));
end;

procedure TdxChartSimpleSeriesTotalLabel.CalculateAndAdjustContent(ACanvas: TcxCustomCanvas; var ABounds: TdxRectF);
var
  R: TdxRectF;
begin
  R := ABounds;
  inherited CalculateAndAdjustContent(ACanvas, R);
  if not ViewInfo.ActuallyVisible then
    Exit;
  if ActualPosition <> TdxAlignment.Center then
    ABounds := R
  else
  begin
    R.Size := TdxSizeF.Create((ABounds.Width - ViewInfo.Bounds.Width) + ViewInfo.TextBounds.Width, ViewInfo.Bounds.Height);
    R.SetCenter(ABounds.CenterPoint);
    ViewInfo.UpdateBounds(R);
  end;
end;

procedure TdxChartSimpleSeriesTotalLabel.DoAssign(Source: TPersistent);
begin
  inherited DoAssign(Source);
  if Source is TdxChartSimpleSeriesTotalLabel then
    Position := TdxChartSimpleSeriesTotalLabel(Source).Position;
end;

function TdxChartSimpleSeriesTotalLabel.GetActualDisplayText: string;
begin
  if TextFormat <> '' then
    Result := TdxChartTextFormatController.FormatPattern(TextFormatter, GetValueByName)
  else
  begin
    if ActualPosition = TdxAlignment.Center then
      Result := TdxChartTextFormatController.FormatPattern(
        TdxChartTextFormatController.FormatController.SimpleSeriesCenteredTotalValueTextFormatter, GetValueByName)
    else
      Result := TdxChartTextFormatController.FormatPattern(
        TdxChartTextFormatController.FormatController.SimpleSeriesTotalValueFormatter, GetValueByName)
  end;
  if Assigned(TdxChartSimpleDiagram(View.Series.Diagram).OnGetTotalLabelDrawParameters) then
    RaiseGetTotalLabelDrawParametersEvent(Result);
end;

function TdxChartSimpleSeriesTotalLabel.GetActualDockPosition: TdxChartTitlePosition;
const
  PositionToDocPosition: array[TdxAlignment] of TdxChartTitlePosition =
    (TdxChartTitlePosition.Bottom, TdxChartTitlePosition.Top, TdxChartTitlePosition.Top, TdxChartTitlePosition.Bottom);
begin
  Result := PositionToDocPosition[ActualPosition];
end;

function TdxChartSimpleSeriesTotalLabel.GetText: string;
begin
  Result := inherited GetText;
  if Result = '' then
    Result := GetDefaultText;
end;

function TdxChartSimpleSeriesTotalLabel.GetActualPosition: TdxAlignment;
begin
  Result := FPosition;
  if Result = TdxAlignment.Default then
    Result := View.GetDefaultTotalLabelPosition;
end;

function TdxChartSimpleSeriesTotalLabel.GetDefaultText: string;
begin
  if ActualPosition <> TdxAlignment.Center then
    Result := cxGetResourceString(@sdxChartControlSimpleSeriesTotalLabel)
  else
    Result := cxGetResourceString(@sdxChartControlSimpleSeriesTotalCenteredLabel);
end;

function TdxChartSimpleSeriesTotalLabel.GetDefaultWordWrap: Boolean;
begin
  Result := True;
end;

class function TdxChartSimpleSeriesTotalLabel.GetHitCode: TdxChartHitCode;
begin
  Result := TdxChartHitCode.TotalLabel;
end;

function TdxChartSimpleSeriesTotalLabel.GetOwnerComponent: TComponent;
begin
  Result := View.Series;
end;

function TdxChartSimpleSeriesTotalLabel.GetTextFormat: TdxChartTextFormat;
begin
  Result := TdxChartTextFormatController.GetFormat(TextFormatter);
end;

function TdxChartSimpleSeriesTotalLabel.GetValueByName(const AName: string; out AValue: Variant): Boolean;
begin
  Result := True;
  if (AName = TdxChartTextFormatVariableNames.Value)
    or (AName = TdxChartTextFormatVariableNames.TotalValue) then
    AValue := View.ViewData.SummaryValue
  else if AName = TdxChartTextFormatVariableNames.Series then
    AValue := View.Series.Caption
  else
    Exit(False);
end;

function TdxChartSimpleSeriesTotalLabel.GetView: TdxChartSimpleSeriesCustomPieView;
begin
  Result := TdxChartSimpleSeriesCustomPieView(inherited Owner);
end;

function TdxChartSimpleSeriesTotalLabel.GetViewInfo: TdxChartSimpleSeriesTotalLabelViewInfo;
begin
  Result := TdxChartSimpleSeriesTotalLabelViewInfo(inherited ViewInfo);
end;

procedure TdxChartSimpleSeriesTotalLabel.RaiseGetTotalLabelDrawParametersEvent(var AText: string);
var
  AArgs: TdxChartGetTotalLabelDrawParametersEventArgs;
begin
  AArgs := TdxChartGetTotalLabelDrawParametersEventArgs.Create(View.Series, View.ViewData.SummaryValue, AText);
  try
    TdxChartSimpleDiagram(View.Series.Diagram).DoGetTotalLabelDrawParameters(AArgs);
    AText := AArgs.Text;
  finally
    FreeAndNil(AArgs);
  end;
end;

procedure TdxChartSimpleSeriesTotalLabel.SetPosition(AValue: TdxAlignment);
begin
  if AValue <> FPosition then
  begin
    FPosition := AValue;
    LayoutChanged;
  end;
end;

procedure TdxChartSimpleSeriesTotalLabel.SetTextFormat(const AValue: TdxChartTextFormat);
begin
  if TdxChartTextFormatController.Add(AValue, FTextFormatter) then
    LayoutChanged;
end;

{ TdxChartSimpleSeriesCustomPieView }

constructor TdxChartSimpleSeriesCustomPieView.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FExplodedValueOptions := CreateExplodedValueOptions;
  FTotalLabel := CreateTotalLabel;
  FStartAngle := DefaultStartAngle;
  HoleRadius := GetDefaultHoleRadius;
end;

destructor TdxChartSimpleSeriesCustomPieView.Destroy;
begin
  FreeAndNil(FTotalLabel);
  FreeAndNil(FExplodedValueOptions);
  inherited Destroy;
end;

procedure TdxChartSimpleSeriesCustomPieView.Changed;
begin
  ViewInfo.Dirty := True;
  if ActuallyVisible then
    StyleChanged;  
end;

function TdxChartSimpleSeriesCustomPieView.CreateExplodedValueOptions: TdxChartExplodedValueOptions;
begin
  Result := TdxChartExplodedValueOptions.Create(Self);
end;

function TdxChartSimpleSeriesCustomPieView.CreateTotalLabel: TdxChartSimpleSeriesTotalLabel;
begin
  Result := TdxChartSimpleSeriesTotalLabel.Create(Self);
end;

function TdxChartSimpleSeriesCustomPieView.CreateViewInfo: TdxChartSeriesViewCustomViewInfo;
begin
  Result := TdxChartSimpleSeriesPieViewInfo.Create(Self);
end;

function TdxChartSimpleSeriesCustomPieView.CreateValueLabels: TdxChartSeriesValueLabels;
begin
  Result := TdxChartPieValueLabels.Create(Self);
end;

procedure TdxChartSimpleSeriesCustomPieView.DoAssign(Source: TPersistent);
begin
  inherited DoAssign(Source);
  if Source is TdxChartSimpleSeriesCustomPieView then
  begin
    TotalLabel := TdxChartSimpleSeriesCustomPieView(Source).FTotalLabel;
    FStartAngle := TdxChartSimpleSeriesCustomPieView(Source).StartAngle;
    FHoleRadius := TdxChartSimpleSeriesCustomPieView(Source).HoleRadius;
    ExplodedValueOptions := TdxChartSimpleSeriesCustomPieView(Source).ExplodedValueOptions;
  end;
end;

procedure TdxChartSimpleSeriesCustomPieView.DoCanExplodeValue(AArgs: TdxChartCanExplodeValueEventArgs);
begin
  if Assigned(FOnCanExplodeValue) then
    FOnCanExplodeValue(Self, AArgs);
end;

function TdxChartSimpleSeriesCustomPieView.GetDefaultHoleRadius: Single;
begin
  Result := 0;
end;

function TdxChartSimpleSeriesCustomPieView.GetDefaultTotalLabelPosition: TdxAlignment;
begin
  Result := TdxAlignment.Far;
end;

function TdxChartSimpleSeriesCustomPieView.GetDefaultLineLength: Single;
begin
  Result := DefaultLineLength;
end;

function TdxChartSimpleSeriesCustomPieView.GetValueLabels: TdxChartPieValueLabels;
begin
  Result := TdxChartPieValueLabels(inherited ValueLabels);
end;

function TdxChartSimpleSeriesCustomPieView.IsHoleRadiusStored: Boolean;
begin
  Result := not SameValue(HoleRadius, GetDefaultHoleRadius);
end;

function TdxChartSimpleSeriesCustomPieView.IsStartAngleStored: Boolean;
begin
  Result := not SameValue(StartAngle, DefaultStartAngle)
end;

procedure TdxChartSimpleSeriesCustomPieView.SetHoleRadius(AValue: Single);
begin
  AValue := Min(90, Max(0, AValue));
  if not SameValue(AValue, HoleRadius) then
  begin
    FHoleRadius := AValue;
    Changed;
  end;
end;

procedure TdxChartSimpleSeriesCustomPieView.SetStartAngle(AValue: Single);
begin
  if not SameValue(AValue, StartAngle) then
  begin
    FStartAngle := AValue;
    Changed;
  end;
end;

procedure TdxChartSimpleSeriesCustomPieView.SetSweepDirection(AValue: TdxChartPieSweepDirection);
begin
  if AValue <> FSweepDirection then
  begin
    FSweepDirection := AValue;
    Changed;
  end;
end;

procedure TdxChartSimpleSeriesCustomPieView.SetExplodedValueOptions(AValue: TdxChartExplodedValueOptions);
begin
  ExplodedValueOptions.Assign(AValue);
end;

procedure TdxChartSimpleSeriesCustomPieView.SetOnCanExplodeValue(const Value: TdxChartCanExplodeValueEvent);
begin
  if not dxSameMethods(FOnCanExplodeValue, Value) then
  begin
    FOnCanExplodeValue := Value;
    Changed;
  end;
end;

procedure TdxChartSimpleSeriesCustomPieView.SetTotalLabel(AValue: TdxChartSimpleSeriesTotalLabel);
begin
  TotalLabel.Assign(AValue);
end;

procedure TdxChartSimpleSeriesCustomPieView.SetValueLabels(AValue: TdxChartPieValueLabels);
begin
  ValueLabels.Assign(AValue);
end;

{ TdxChartSimpleSeriesPieView }

class function TdxChartSimpleSeriesPieView.GetDescription: string;
begin
  Result := cxGetResourceString(@sdxChartControlPieDisplayName);
end;

{ TdxChartSimpleSeriesPieViewInfo }

function TdxChartSimpleSeriesPieViewInfo.GetValueLabels: TdxChartPieValueLabels;
begin
  Result := TdxChartPieValueLabels(inherited ValueLabels);
end;

function TdxChartSimpleSeriesPieViewInfo.GetView: TdxChartSimpleSeriesCustomPieView;
begin
  Result := TdxChartSimpleSeriesCustomPieView(inherited View);
end;

function TdxChartSimpleSeriesPieViewInfo.GetExplodedValueOptions: TdxChartExplodedValueOptions;
begin
  Result := View.ExplodedValueOptions;
end;

function TdxChartSimpleSeriesPieViewInfo.GetTotalLabel: TdxChartSimpleSeriesTotalLabel;
begin
  Result := View.TotalLabel;
end;

procedure TdxChartSimpleSeriesPieViewInfo.CalculateCanvasValue(const AValue: TdxChartSeriesValueViewInfo);
var
  ASweep: Single;
  ASlice: TdxChartSimpleSeriesPieValueViewInfo absolute AValue;
begin
  if not AValue.Visible then
  begin
    ASlice.Initialize(0, 0);
    Exit;
  end;
  if (FExplodedDistance > 0) and ExplodedValueOptions.IsValueExploded(ASlice) then
  begin
    ASlice.Exploded := True;
    Inc(FExplodedCount);
  end;
  Inc(FVisibleCount);
  if not IsZero(ViewData.TopValuesSummary) then
    ASweep := FSign * ASlice.Value * 360 / ViewData.TopValuesSummary
  else
    ASweep := 0;
  ASlice.Initialize(FStart, ASweep);
  FStart := FStart + ASweep;
end;

procedure TdxChartSimpleSeriesPieViewInfo.CalculateValues(ACanvas: TcxCustomCanvas);
var
  ALabelMaxSize: TdxSizeF;
begin
  TotalLabel.CalculateAndAdjustContent(ACanvas, FSeriesBounds);

  FExplodedDistance := 0;
  CalculateValuesBounds(Min(FSeriesBounds.Width, FSeriesBounds.Height) - 1);
  FSign := 1;
  if View.SweepDirection = TdxChartPieSweepDirection.Clockwise then
    FSign := -1;
  FStart := FSign * View.StartAngle;
  inherited CalculateValues(ACanvas);
  if FVisibleCount = 1 then
    FExplodedCount := 0;
  ALabelMaxSize := TdxSizeF.Null;
  ForEachValue(
    procedure(AValue: TdxChartSeriesValueViewInfo)
    var
      ASlice: TdxChartSimpleSeriesPieValueViewInfo absolute AValue;
    begin
      if FVisibleCount = 1 then
        ASlice.Exploded := False;
      if ASlice.Visible then
        ASlice.FAppearance.Validate(ACanvas);
      if ValueLabels.IsOutsideLabel then
        ALabelMaxSize := cxSizeMax(ALabelMaxSize, ASlice.ValueLabel.Bounds.Size);
    end);
  if ValueLabels.IsOutsideLabel then
  begin
    ALabelMaxSize.Width := ALabelMaxSize.Width + ValueLabels.LineLength;
    ALabelMaxSize.Height:= ALabelMaxSize.Height + ValueLabels.LineLength;
    CalculateValuesBounds(Min(FSeriesBounds.Width - ALabelMaxSize.Width * 2, FSeriesBounds.Height - ALabelMaxSize.Height * 2) - 1);
    ValidateValueLabels;
  end;
  ResolveValueLabelsOverlapping;
end;

procedure TdxChartSimpleSeriesPieViewInfo.CalculateValuesBounds(ASize: Single);
begin
  FValueBounds := cxRectCenter(FSeriesBounds, ASize, ASize);
  if Min(FValueBounds.Width, FValueBounds.Height) < Min(FSeriesBounds.Width, FSeriesBounds.Height) / 2 then
  begin
    ASize := Min(FSeriesBounds.Width, FSeriesBounds.Height) / 2 - 1;
    FValueBounds := cxRectCenter(FSeriesBounds, ASize, ASize);
  end;
  if ExplodedValueOptions.Mode <> TdxChartExplodedValueMode.None then
    FExplodedDistance := (ASize / 2) / 100 * ExplodedValueOptions.Distance;
  FValueBounds.Inflate(-FExplodedDistance, -FExplodedDistance);
end;

procedure TdxChartSimpleSeriesPieViewInfo.DoDraw(ACanvas: TcxCustomCanvas);
begin
  inherited DoDraw(ACanvas);
end;

procedure TdxChartSimpleSeriesPieViewInfo.DoDrawLabels(ACanvas: TcxCustomCanvas);
begin
  if not FValueBounds.IsEmpty then
    inherited DoDrawLabels(ACanvas);
end;

procedure TdxChartSimpleSeriesPieViewInfo.DrawValues(ACanvas: TcxCustomCanvas);
begin
  if not FValueBounds.IsEmpty then
    inherited DrawValues(ACanvas);
  TotalLabel.ViewInfo.Draw(ACanvas);
end;

procedure TdxChartSimpleSeriesPieViewInfo.PrepareValuesToCanvasValues;
var
  AValue: TdxChartSeriesValueViewInfo;
  APriorVisibleValue: TdxChartSeriesValueViewInfo;
begin
  if FFirstVisibleValue = nil then
    Exit;
  CalculateCanvasValue(FFirstVisibleValue);
  APriorVisibleValue := FFirstVisibleValue;
  AValue := FFirstVisibleValue;
  while AValue <> FLastVisibleValue do
  begin
    AValue := TdxChartSimpleSeriesPieValueViewInfo(AValue).Next;
    if AValue.Visible then
    begin
      TdxChartSimpleSeriesPieValueViewInfo(AValue).FPriorDisplayValue := APriorVisibleValue;
      TdxChartSimpleSeriesPieValueViewInfo(APriorVisibleValue).FNextDisplayValue := AValue;
      APriorVisibleValue := AValue;
      CalculateCanvasValue(AValue);
    end;
  end;
end;

function TdxChartSimpleSeriesPieViewInfo.GetHitElement(const P: TdxPointF): IdxChartHitTestElement;
begin
  Result := TotalLabel.ViewInfo.GetHitElement(P);
  if Result = nil then
    Result := inherited GetHitElement(P);
end;

procedure TdxChartSimpleSeriesPieViewInfo.ResolveValueLabelsOverlapping;
var
  ALabelsList: TdxChartSeriesValueLabelViewInfoList;
  AIndent: Single;
  ADiagramBounds: TdxRectF;
begin
  ADiagramBounds := GetValueLabelVisibleBounds;
  if ValueLabels.ResolveOverlappingMode = TdxChartSeriesValueLabelsResolveOverlappingMode.Default then
  begin
    AIndent := ValueLabels.ResolveOverlappingIndent;
    ALabelsList := TdxChartSeriesValueLabelViewInfoList.Create;
    try
      GetVisibleValueLabels(ALabelsList);
      if ALabelsList.Count > 1 then
        case ValueLabels.Position of
          TdxChartPieValueLabelPosition.TwoColumns:
            TdxChartSimpleSeriesPieValueLabelsOverlappingResolver.ArrangeByColumn(ALabelsList, ADiagramBounds, AIndent);
          TdxChartPieValueLabelPosition.Outside:
            TdxChartSimpleSeriesPieValueLabelsOverlappingResolver.ArrangeByEllipse(ALabelsList, ADiagramBounds, AIndent,
              ValueBounds, View.SweepDirection);
        end;
    finally
      ALabelsList.Free;
    end;
  end;
  ForEachValue(
    procedure(AValue: TdxChartSeriesValueViewInfo)
    begin
      if (AValue.ValueLabel <> nil) and not ADiagramBounds.Contains(AValue.ValueLabel.Bounds) then
        AValue.ValueLabel.Visible := False;
    end);
end;

function TdxChartSimpleSeriesPieViewInfo.GetValueViewInfoClass: TdxChartSeriesValueViewInfoClass;
begin
  Result := TdxChartSimpleSeriesPieValueViewInfo;
end;

{ TdxChartSimpleSeriesPieValueViewInfo }

procedure TdxChartSimpleSeriesPieValueViewInfo.Draw(ACanvas: TcxCustomCanvas);
begin
  ACanvas.Pie(ClipRect, StartAngle, SweepAngle, FAppearance.ActualBrush, nil);
end;

procedure TdxChartSimpleSeriesPieValueViewInfo.DrawGlyph(ACanvas: TcxCustomCanvas; const R: TdxRectF);
var
  AClipRect, AGlyphRect: TdxRectF;
  ACorrection: Single;
begin
  AClipRect := R;
  AGlyphRect := R;
  AGlyphRect.Height := Max(AClipRect.Height * 2, AClipRect.Width * 2);
  AGlyphRect.Left := AGlyphRect.Right - AGlyphRect.Height;
  ACorrection := -Owner.ActualGlyphCorrection;
  AGlyphRect.Inflate(ACorrection, ACorrection);
  ACanvas.SaveClipRegion;
  AClipRect.Inflate(0, 0, ACorrection, ACorrection);
  ACanvas.IntersectClipRect(AClipRect);
  FAppearance.Validate(ACanvas);
  DrawGlyphSlice(ACanvas, AGlyphRect);
  ACanvas.RestoreClipRegion;
end;

procedure TdxChartSimpleSeriesPieValueViewInfo.DrawGlyphSlice(ACanvas: TcxCustomCanvas; const R: TdxRectF);
begin
  ACanvas.Pie(R, 0, 90, FAppearance.ActualBrush, FAppearance.ActualPen);
end;

procedure TdxChartSimpleSeriesPieValueViewInfo.Initialize(const AStartAngle, ASweepAngle: Single);
begin
  FStartAngle := AStartAngle;
  FSweepAngle := ASweepAngle;
end;

function TdxChartSimpleSeriesPieValueViewInfo.IsInBottomSemicircle: Boolean;
begin
  Result := HalfAngle > 90;
end;

function TdxChartSimpleSeriesPieValueViewInfo.IsInRightSemicircle: Boolean;
begin
  Result := HalfAngle - Owner.View.StartAngle >= 180;
end;

function TdxChartSimpleSeriesPieValueViewInfo.GetClipRect: TdxRectF;
begin
  Result := GetDisplayBounds;
end;

function TdxChartSimpleSeriesPieValueViewInfo.GetDisplayBounds: TdxRectF;
begin
  Result := Owner.ValueBounds;
  if not Exploded or (Owner.VisibleCount = 1) then
    Exit;
  if Owner.ExplodedDistance > 0 then
    Result := TdxRectF.Create(
       GetPointOnCircle(Result.CenterPoint, Owner.ExplodedDistance, StartAngle + SweepAngle / 2),
       Result.Width, Result.Height);
end;

function TdxChartSimpleSeriesPieValueViewInfo.GetHitElement(const P: TdxPointF): IdxChartHitTestElement;
var
  ABoundingRect: TdxRectF;
  ADistanceToCenter: Single;
  ACos: Single;
  AAngle: Single;
  AStartAngle, ASweepAngle: Single;
begin
  Result := nil;
  ABoundingRect := GetDisplayBounds;
  if ABoundingRect.Contains(P) then
  begin
    ADistanceToCenter := Sqrt(Sqr(P.X - ABoundingRect.CenterPoint.X) + Sqr(P.Y - ABoundingRect.CenterPoint.Y));
    if IsZero(ADistanceToCenter) then
      Result := TdxChartComponentHitElement.Create(Series, TdxChartHitCode.Series)
    else if (ADistanceToCenter <= ABoundingRect.Width / 2) and (ADistanceToCenter >= GetHoleRadiusInPixels) then
    begin
      ACos := (P.X - ABoundingRect.CenterPoint.X) / ADistanceToCenter;
      AAngle := RadToDeg(ArcCos(ACos));
      if P.Y > ABoundingRect.CenterPoint.Y then
        AAngle := 360 - AAngle;
      AStartAngle := Min(StartAngle, StartAngle + SweepAngle);
      ASweepAngle := Abs(SweepAngle);
      AAngle := AAngle - Floor((AAngle - AStartAngle)/ 360) * 360;
      if AAngle < AStartAngle + ASweepAngle then
        Result := TdxChartSeriesPointHitElement.Create(CreateSeriesPointInfo, ToolTipText);
    end;
  end;
end;

function TdxChartSimpleSeriesPieValueViewInfo.GetHoleRadiusInPixels: Single;
begin
  Result := 0;
end;

procedure TdxChartSimpleSeriesPieValueViewInfo.CalculateLabelLeaderLinePoints(var AStartPoint, AMiddlePoint, AEndPoint: TdxPointF);
begin
  AEndPoint := TdxPointF.Null;
  if Owner.ValueLabels.IsOutsideLabel then
  begin
    GetStartAndOutsideRadialPoints(ClipRect, HalfAngle, Owner.ValueLabels.LineLength, AStartPoint, AMiddlePoint);
    if Owner.ValueLabels.Position = TdxChartPieValueLabelPosition.TwoColumns then
    begin
      AEndPoint.Y := AMiddlePoint.Y;
      if AMiddlePoint.X < ClipRect.CenterPoint.X then
        AEndPoint.X := Owner.FSeriesBounds.Left + ValueLabel.Bounds.Width
      else
        AEndPoint.X := Owner.FSeriesBounds.Right - ValueLabel.Bounds.Width;
    end;
  end
  else
  begin
    GetStartAndMiddleRadialPoints(ClipRect, StartAngle, SweepAngle, GetHoleRadiusInPixels, AStartPoint, AMiddlePoint);
    AStartPoint := TdxPointF.Null;
  end;
end;

function TdxChartSimpleSeriesPieValueViewInfo.CreateValueLabel: TdxChartValueLabelCustomViewInfo;
begin
  Result := TdxChartSimpleSeriesPieValueLabelViewInfo.Create(Self);
end;

function TdxChartSimpleSeriesPieValueViewInfo.GetLabelAnchorPoint: TdxPointF;
var
  R, R1: TdxRectF;
  C: TdxPointF;
  DX, DY: Single;
const
  Threshold = 5;
begin
  Result := ValueLabel.MiddlePoint;
  if Owner.ValueLabels.IsOutsideLabel then
  begin
    R := cxRectInflate(ClipRect, -2, -2);
    R1 := ValueLabel.Bounds;
    C := R.CenterPoint;
    if Owner.ValueLabels.Position = TdxChartPieValueLabelPosition.Outside then
    begin
      if (Result.X > C.X - Threshold) and (Result.X < C.X + Threshold)  then 
      begin
        R1 := TdxRectF.Create(TdxPointF.Create(Result.X, Result.Y + R1.Height / 2), R1.Width, R1.Height);
        if Result.Y <= R.Top then   
          R1 := TdxRectF.Create(TdxPointF.Create(Result.X, Result.Y - R1.Height / 2), R1.Width, R1.Height);
      end
      else
        if (Result.Y > C.Y - Threshold) and (Result.Y < C.Y + Threshold)  then 
        begin
          R1 := TdxRectF.Create(TdxPointF.Create(Result.X + R1.Width / 2, Result.Y), R1.Width, R1.Height);
          if Result.X <= R.Left then   
            R1 := TdxRectF.Create(TdxPointF.Create(Result.X - R1.Width / 2, Result.Y), R1.Width, R1.Height);
        end
        else
        begin
          DX := Result.X - R1.Left;
          if Result.X <= C.X then
            DX := Result.X - R1.Right;
          DY := Result.Y - R1.Top;
          if Result.Y <= C.Y then
            DY := Result.Y - R1.Bottom;
          R1.Offset(DX, DY);
        end;
      Result := R1.CenterPoint;
    end
    else
      Result := cxPointOffset(ValueLabel.EndPoint, R1.Width / 2, 0, Result.X >= C.X);
  end;
end;

function TdxChartSimpleSeriesPieValueViewInfo.GetHalfAngle: Single;
begin
  Result := StartAngle + SweepAngle / 2
end;

function TdxChartSimpleSeriesPieValueViewInfo.GetOwner: TdxChartSimpleSeriesPieViewInfo;
begin
  Result := TdxChartSimpleSeriesPieViewInfo(inherited Owner);
end;

function TdxChartSimpleSeriesPieValueViewInfo.GetValueLabel: TdxChartSimpleSeriesPieValueLabelViewInfo;
begin
  Result := TdxChartSimpleSeriesPieValueLabelViewInfo(inherited ValueLabel);
end;

{ TdxChartSimpleSeriesPieValueLabelViewInfo }

function TdxChartSimpleSeriesPieValueLabelViewInfo.GetAppearance: TdxChartSimpleSeriesViewAppearanceValueLabelAppearance;
begin
  Result := TdxChartSimpleSeriesViewAppearanceValueLabelAppearance(inherited Appearance);
end;

function TdxChartSimpleSeriesPieValueLabelViewInfo.GetLabelOptions: TdxChartPieValueLabels;
begin
  Result := TdxChartPieValueLabels(inherited GetOptions);
end;

function TdxChartSimpleSeriesPieValueLabelViewInfo.GetOwner: TdxChartSimpleSeriesPieValueViewInfo;
begin
  Result := TdxChartSimpleSeriesPieValueViewInfo(inherited Owner);
end;

function TdxChartSimpleSeriesPieValueLabelViewInfo.GetHalfAngle: Single;
begin
  Result := Owner.HalfAngle;
end;

function TdxChartSimpleSeriesPieValueLabelViewInfo.CalculateValidBounds(const ABoundingRect: TdxRectF): TdxRectF;
begin
  Result := inherited CalculateValidBounds(ABoundingRect);
  if Options.Position = TdxChartPieValueLabelPosition.TwoColumns then
    if MiddlePoint.X < ABoundingRect.CenterPoint.X then
    begin
      if Result.Right >= MiddlePoint.X then
      begin
        EndPoint.Offset(MiddlePoint.X - Bounds.Right, 0);
        Result.Right := MiddlePoint.X;
      end;
    end
    else
      if Result.Left <= MiddlePoint.X then
      begin
        EndPoint.Offset(MiddlePoint.X - Bounds.Left, 0);
        Result.Left := MiddlePoint.X;
      end;
end;

function TdxChartSimpleSeriesPieValueLabelViewInfo.GetActualPen: TcxCanvasBasedPen;
begin
  if Options.IsOutsideLabel then
    Result := Owner.FAppearance.ActualPen
  else
    Result := inherited GetActualPen;
end;

function TdxChartSimpleSeriesPieValueLabelViewInfo.GetColor: TdxAlphaColor;
begin
  Result := inherited GetColor;
  if Options.IsOutsideLabel then
    Result := TdxAlphaColors.GetActualValue(Appearance.TextColor, Owner.FAppearance.ActualColor);
end;

function TdxChartSimpleSeriesPieValueLabelViewInfo.GetPieCenter: TdxPointF;
begin
  Result := Owner.GetClipRect.CenterPoint;
end;

function TdxChartSimpleSeriesPieValueLabelViewInfo.GetTextAngle: Single;
begin
  Result := 0;
  case Options.Position of
    TdxChartPieValueLabelPosition.Radial:
      begin
        Result := -HalfAngle;
        if GetTextCenter.X < GetPieCenter.X then
          Result := Result + 180;
      end;
    TdxChartPieValueLabelPosition.Tangent:
      Result := 90 - HalfAngle;
  end;
end;

function TdxChartSimpleSeriesPieValueLabelViewInfo.GetTextCenter: TdxPointF;
begin
  Result := Owner.GetLabelAnchorPoint;
end;

procedure TdxChartSimpleSeriesPieValueLabelViewInfo.Offset(const ADistance: TdxPointF);
var
  AOffsetX, AOffsetY: Single;
  ANearestPoint: TdxPointF;
begin
  AOffsetX := ADistance.X - Bounds.CenterPoint.X;
  AOffsetY := ADistance.Y - Bounds.CenterPoint.Y;
  if IsZero(AOffsetX) and IsZero(AOffsetY) then
    Exit;
  Realign(ADistance);
  case Owner.Owner.ValueLabels.Position of
    TdxChartPieValueLabelPosition.TwoColumns:
    begin
      EndPoint.Offset(AOffsetX, AOffsetY);
      if StartPoint.Y >= Owner.Owner.ValueBounds.CenterPoint.Y then
        MiddlePoint.Init(MiddlePoint.X, Max(StartPoint.Y, EndPoint.Y))
      else
        MiddlePoint.Init(MiddlePoint.X, Min(StartPoint.Y, EndPoint.Y))
    end;
    TdxChartPieValueLabelPosition.Outside:
    begin
      ANearestPoint := TConnectionPointFinder.GetNearest(StartPoint, Bounds);
      MiddlePoint.Init(ANearestPoint.X, ANearestPoint.Y);
    end;
  end;
end;

{ TdxChartSimpleSeriesDoughnutView }

class function TdxChartSimpleSeriesDoughnutView.GetDescription: string;
begin
  Result := cxGetResourceString(@sdxChartControlDoughnutDisplayName);
end;

function TdxChartSimpleSeriesDoughnutView.CreateViewInfo: TdxChartSeriesViewCustomViewInfo;
begin
  Result := TdxChartSimpleSeriesDoughnutViewInfo.Create(Self);
end;

function TdxChartSimpleSeriesDoughnutView.GetDefaultTotalLabelPosition: TdxAlignment;
begin
  Result := TdxAlignment.Center;
end;

function TdxChartSimpleSeriesDoughnutView.GetDefaultHoleRadius: Single;
begin
  Result := DefaultHoleRadius;
end;

{ TdxChartSimpleSeriesDoughnutViewInfo }

function TdxChartSimpleSeriesDoughnutViewInfo.GetValueViewInfoClass: TdxChartSeriesValueViewInfoClass;
begin
  Result := TdxChartSimpleSeriesDoughnutValueViewInfo;
end;

{ TdxChartSimpleSeriesDoughnutValueViewInfo }

function TdxChartSimpleSeriesDoughnutValueViewInfo.GetHoleRadius: Single;
begin
  Result := TdxChartSimpleSeriesDoughnutViewInfo(Owner).View.HoleRadius;
end;

procedure TdxChartSimpleSeriesDoughnutValueViewInfo.Draw(ACanvas: TcxCustomCanvas);
begin
  ACanvas.DonutSlice(ClipRect, StartAngle, SweepAngle, HoleRadius,
    FAppearance.ActualBrush, FAppearance.ActualPen);
end;

procedure TdxChartSimpleSeriesDoughnutValueViewInfo.DrawGlyphSlice(ACanvas: TcxCustomCanvas; const R: TdxRectF);
var
  AStart: Single;
begin
  AStart := Abs((1 - R.Height / R.Width)) * 100;
  ACanvas.DonutSlice(R, AStart, 90 - AStart, 72, FAppearance.ActualBrush, FAppearance.ActualPen);
end;

function TdxChartSimpleSeriesDoughnutValueViewInfo.GetHoleRadiusInPixels: Single;
begin
  Result := ClipRect.Width / 2 * HoleRadius / 100;
end;

{ TdxChartSeriesValueLabelsResolveOverlappingAlgorithm }

constructor TdxChartSeriesValueLabelsResolveOverlappingAlgorithm.Create(
  const ALabels: TdxChartSeriesValueLabelViewInfoList; const ADiagramBounds: TdxRectF; AIndent: Single);
begin
  FLabels := ALabels;
  FDiagramBounds := ADiagramBounds;
  FIndent := AIndent;
end;

{ TdxChartSimpleSeriesResolveOverlappingByColumn }

function TdxChartSimpleSeriesResolveOverlappingByColumn.Arrange(ALabelInfo: TdxLabelInfo; ABottomPriority: Boolean): Boolean;
begin
  if ABottomPriority then
  begin
    BottomArrange(ALabelInfo);
    TopArrange(ALabelInfo);
  end
  else
  begin
    TopArrange(ALabelInfo);
    BottomArrange(ALabelInfo);
  end;
  Result := IsZero(ALabelInfo.GetOverlap);
end;

procedure TdxChartSimpleSeriesResolveOverlappingByColumn.ArrangeGroup(const ALabels: TdxChartSeriesValueLabelViewInfoList);
var
  AActualLabels: TdxLabelInfoList;
  AOverlap: Single;
  AFocuses: TList<Single>;
  I: Integer;
begin
  AActualLabels := GetLabelsForArrangeByColumn(ALabels);
  try
    AOverlap := CalculateWholeOverlap(AActualLabels);
    if AOverlap > 0 then
      ArrangeOverlapping(AActualLabels, AOverlap)
    else
    begin
      AFocuses := CalculateFocuses;
      try
        ArrangeNonOverlapping(AActualLabels, AFocuses);
      finally
        AFocuses.Free;
      end;
    end;
    for I := 0 to AActualLabels.Count - 1 do
      AActualLabels[I].Flush;
  finally
    AActualLabels.Free;
  end;
end;

procedure TdxChartSimpleSeriesResolveOverlappingByColumn.ArrangeLabels;
var
  ALeftGroup, ARightGroup: TdxChartSeriesValueLabelViewInfoList;
begin
  ALeftGroup := TdxChartSeriesValueLabelViewInfoList.Create;
  ARightGroup := TdxChartSeriesValueLabelViewInfoList.Create;
  try
    GroupLabelsByColumns(FLabels, ALeftGroup, ARightGroup);
    ArrangeGroup(ALeftGroup);
    ArrangeGroup(ARightGroup);
  finally
    ALeftGroup.Free;
    ARightGroup.Free;
  end;
end;

procedure TdxChartSimpleSeriesResolveOverlappingByColumn.ArrangeNonOverlapping(
  const ALabels: TdxLabelInfoList; const AFocuses: TList<Single>);
var
  AActualLabels: TdxLabelInfoList;
  APrev, ANext, ALabel: TdxLabelInfo;
  I, AIndex: Integer;
  AIsFirst, ABottomPriority: Boolean;
begin
  AActualLabels := TdxLabelInfoList.Create;
  try
    AActualLabels.Assign(ALabels);
    APrev := nil;
    ANext := nil;
    for I := 0 to ALabels.Count - 1 do
    begin
      AIsFirst := I mod 2 = 0;
      if AIsFirst then
        AIndex := 0
      else
        AIndex := AActualLabels.Count - 1;
      ALabel := AActualLabels[AIndex];
      AActualLabels.Delete(AIndex);
      SetLabelItemPrevAndNext(ALabel, APrev, ANext);
      if APrev <> nil then
        APrev.Next := ALabel;
      if ANext <> nil then
        ANext.Prev := ALabel;
      ABottomPriority := IsBottomPriority(ALabel, AFocuses);
      if not Arrange(ALabel, ABottomPriority) then
        Break;
      if AIsFirst then
        APrev := ALabel
      else
        ANext := ALabel;
    end;
  finally
    AActualLabels.Free;
  end;
end;

procedure TdxChartSimpleSeriesResolveOverlappingByColumn.ArrangeOverlapping(
  const ALabels: TdxLabelInfoList; AWholeOverlap: Single);
var
  AOverlap, ACenter: Single;
  I: Integer;
  APrev, ACurr: TdxLabelInfo;
begin
  if ALabels.Count = 0 then
    Exit;
  ALabels[0].Offset(-CalculateTopMargin(ALabels[0]));
  if ALabels.Count = 1 then
    Exit;
  AOverlap := AWholeOverlap / (ALabels.Count - 1);
  for I := 1 to ALabels.Count - 1 do
  begin
    APrev := ALabels[I - 1];
    ACurr := ALabels[I];
    ACenter := APrev.CorrectedLabelBounds.Bottom + ACurr.CorrectedLabelBounds.Height / 2 - AOverlap;
    ACurr.Offset(ACenter - ACurr.GetCenter);
    if CalculateBottomMargin(ACurr) < 0 then
      ACurr.Offset(CalculateBottomMargin(ACurr));
    if CalculateTopMargin(ACurr) < 0 then
      ACurr.Offset(-CalculateTopMargin(ACurr));
  end;
end;

procedure TdxChartSimpleSeriesResolveOverlappingByColumn.BottomArrange(ALabelInfo: TdxLabelInfo);
var
  AOverlap: Single;
begin
  AOverlap := ALabelInfo.GetOverlap;
  if not IsZero(AOverlap) then
  begin
    if CalculateBottomMargin(ALabelInfo) < 0 then
      ALabelInfo.Offset(CalculateBottomMargin(ALabelInfo));
    PushToBottom(ALabelInfo, AOverlap);
  end;
end;

function TdxChartSimpleSeriesResolveOverlappingByColumn.CalculateFocuses: TList<Single>;
begin
  Result := TList<Single>.Create;
  Result.Add(FDiagramBounds.Top);
  Result.Add(FDiagramBounds.Bottom);
end;

function TdxChartSimpleSeriesResolveOverlappingByColumn.CalculateBottomMargin(ALabelInfo: TdxLabelInfo): Single;
begin
  if ALabelInfo.Next = nil then
    Result := ALabelInfo.DiagramBounds.Bottom - ALabelInfo.LabelBounds.Bottom
  else
    Result := ALabelInfo.Next.CorrectedLabelBounds.Top - ALabelInfo.CorrectedLabelBounds.Bottom;
end;

function TdxChartSimpleSeriesResolveOverlappingByColumn.CalculateTopMargin(ALabelInfo: TdxLabelInfo): Single;
begin
  if ALabelInfo.Prev = nil then
    Result := ALabelInfo.LabelBounds.Top - ALabelInfo.DiagramBounds.Top
  else
    Result := ALabelInfo.CorrectedLabelBounds.Top - ALabelInfo.Prev.CorrectedLabelBounds.Bottom;
end;

function TdxChartSimpleSeriesResolveOverlappingByColumn.CalculateWholeOverlap(
  const ALabels: TdxLabelInfoList): Single;
var
  AHeight: Single;
  I: Integer;
begin
  Result := 0;
  AHeight := 0;
  for I := 0 to ALabels.Count - 1 do
  begin
    if (I = 0) or (I = ALabels.Count - 1) then
      AHeight := AHeight + ALabels[I].LabelBounds.Height / 2 + ALabels[I].CorrectedLabelBounds.Height / 2
    else
      AHeight := AHeight + ALabels[I].CorrectedLabelBounds.Height;
  end;
  if FDiagramBounds.Height < AHeight then
    Result := AHeight - FDiagramBounds.Height;
end;

constructor TdxChartSimpleSeriesResolveOverlappingByColumn.Create(
  const ALabels: TdxChartSeriesValueLabelViewInfoList; const ADiagramBounds: TdxRectF; AIndent: Single);
begin
  inherited Create(ALabels, ADiagramBounds, AIndent);
  FComparer := TdxLabelInfoComparer.Create;
end;

destructor TdxChartSimpleSeriesResolveOverlappingByColumn.Destroy;
begin
  FComparer.Free;
  inherited Destroy;
end;

function TdxChartSimpleSeriesResolveOverlappingByColumn.GetLabelsForArrangeByColumn(
  const ALabels: TdxChartSeriesValueLabelViewInfoList): TdxLabelInfoList;
var
  I: Integer;
begin
  Result := TdxLabelInfoList.Create(True);
  for I := 0 to ALabels.Count - 1 do
    Result.Add(TdxLabelInfo.Create(TdxChartSimpleSeriesPieValueLabelViewInfo(ALabels[I]), FDiagramBounds, FIndent));
  if Result.Count > 1 then
    Result.Sort(FComparer);
end;

procedure TdxChartSimpleSeriesResolveOverlappingByColumn.GroupLabelsByColumns(
  const ALabels: TdxChartSeriesValueLabelViewInfoList; const ALeft, ARight: TdxChartSeriesValueLabelViewInfoList);
var
  I: Integer;
begin
  for I := 0 to ALabels.Count - 1 do
    if ALabels[I].Bounds.CenterPoint.X >= FDiagramBounds.CenterPoint.X then
      ARight.Add(ALabels[I])
    else
      ALeft.Add(ALabels[I]);
end;

function TdxChartSimpleSeriesResolveOverlappingByColumn.IsBottomPriority(
  ALabel: TdxLabelInfo; const AFocuses: TList<Single>): Boolean;
var
  ANearestFocus, AFocus, ADistance: Single;
begin
  ANearestFocus := NaN;
  for AFocus in AFocuses do
  begin
    ADistance := Abs(ALabel.GetCenter - AFocus);
    if IsNaN(ANearestFocus) or (ADistance < Abs(ALabel.GetCenter - ANearestFocus)) then
      ANearestFocus := AFocus;
  end;
  Result := not IsNaN(ANearestFocus) and (ALabel.GetCenter < ANearestFocus);
end;

procedure TdxChartSimpleSeriesResolveOverlappingByColumn.PushNextToBottom(ALabelInfo: TdxLabelInfo; AValue: Single);
begin
  if ALabelInfo.Next <> nil then
    PushToBottom(ALabelInfo.Next, AValue);
end;

procedure TdxChartSimpleSeriesResolveOverlappingByColumn.PushPrevToTop(ALabelInfo: TdxLabelInfo; AValue: Single);
begin
  if ALabelInfo.Prev <> nil then
    PushToTop(ALabelInfo.Prev, AValue);
end;

procedure TdxChartSimpleSeriesResolveOverlappingByColumn.PushToBottom(ALabelInfo: TdxLabelInfo; AValue: Single);
begin
  if CalculateBottomMargin(ALabelInfo) >= AValue then
    ALabelInfo.Offset(AValue)
  else
  begin
    PushNextToBottom(ALabelInfo, AValue - CalculateBottomMargin(ALabelInfo));
    ALabelInfo.Offset(CalculateBottomMargin(ALabelInfo));
  end;
end;

procedure TdxChartSimpleSeriesResolveOverlappingByColumn.PushToTop(ALabelInfo: TdxLabelInfo; AValue: Single);
begin
  if CalculateTopMargin(ALabelInfo) >= AValue then
    ALabelInfo.Offset(-AValue)
  else
  begin
    PushPrevToTop(ALabelInfo, AValue - CalculateTopMargin(ALabelInfo));
    ALabelInfo.Offset(-CalculateTopMargin(ALabelInfo));
  end;
end;

procedure TdxChartSimpleSeriesResolveOverlappingByColumn.SetLabelItemPrevAndNext(ALabel, APrev, ANext: TdxLabelInfo);
begin
  ALabel.Prev := APrev;
  ALabel.Next := ANext;
end;

procedure TdxChartSimpleSeriesResolveOverlappingByColumn.TopArrange(ALabelInfo: TdxLabelInfo);
var
  AOverlap: Single;
begin
  AOverlap := ALabelInfo.GetOverlap;
  if not IsZero(AOverlap) then
  begin
    if CalculateTopMargin(ALabelInfo) < 0 then
      ALabelInfo.Offset(CalculateTopMargin(ALabelInfo));
    PushToTop(ALabelInfo, AOverlap);
  end;
end;

{ TdxChartSimpleSeriesResolveOverlappingByColumn.TdxLabelInfo }

constructor TdxChartSimpleSeriesResolveOverlappingByColumn.TdxLabelInfo.Create(
  const ALabel: TdxChartSimpleSeriesPieValueLabelViewInfo; const ADiagramBounds: TdxRectF; AIndent: Single);
begin
  LabelViewInfo := ALabel;
  LabelBounds := ALabel.Bounds;
  CorrectedLabelBounds := cxRectInflate(LabelBounds, AIndent / 2, AIndent / 2);
  DiagramBounds := ADiagramBounds;
end;

procedure TdxChartSimpleSeriesResolveOverlappingByColumn.TdxLabelInfo.Flush;
begin
  LabelViewInfo.Offset(LabelBounds.CenterPoint);
end;

function TdxChartSimpleSeriesResolveOverlappingByColumn.TdxLabelInfo.GetCenter: Single;
begin
  Result := LabelBounds.CenterPoint.Y;
end;

function TdxChartSimpleSeriesResolveOverlappingByColumn.TdxLabelInfo.GetOverlap: Single;
var
  ATopMargin, ABottomMargin, AOverlap: Single;
begin
  if Prev = nil then
    ATopMargin := LabelBounds.Top - DiagramBounds.Top
  else
    ATopMargin := CorrectedLabelBounds.Top - Prev.CorrectedLabelBounds.Bottom;
  if Next = nil then
    ABottomMargin := DiagramBounds.Bottom - LabelBounds.Bottom
  else
    ABottomMargin := Next.CorrectedLabelBounds.Top - CorrectedLabelBounds.Bottom;
  AOverlap := 0;
  if ATopMargin < 0 then
    AOverlap := AOverlap + Abs(ATopMargin);
  if ABottomMargin < 0 then
    AOverlap := AOverlap + Abs(ABottomMargin);
  Result := AOverlap;
end;

procedure TdxChartSimpleSeriesResolveOverlappingByColumn.TdxLabelInfo.Offset(AOffset: Single);
begin
  LabelBounds.Offset(0, AOffset);
  CorrectedLabelBounds.Offset(0, AOffset);
end;

{ TdxChartSimpleSeriesResolveOverlappingByColumn.TdxLabelInfoComparer }

function TdxChartSimpleSeriesResolveOverlappingByColumn.TdxLabelInfoComparer.Compare(const Left, Right: TdxLabelInfo): Integer;
var
  AValue1, AValue2: Single;
begin
  if Left = Right then
    Exit(0);
  AValue1 := Left.LabelViewInfo.Bounds.LeftCenter.Y;
  AValue2 := Right.LabelViewInfo.Bounds.LeftCenter.Y;
  Result := 0;
  if SameValue(AValue1, AValue2) then
  begin
    AValue1 := Left.LabelViewInfo.HalfAngle;
    AValue2 := Right.LabelViewInfo.HalfAngle;
    if Left.LabelViewInfo.Owner.IsInRightSemicircle then
      ExchangeSingle(AValue1, AValue2);
  end;
  if AValue1 < AValue2 then
    Result := -1
  else
    if AValue1 > AValue2 then
      Result := 1;
end;

{ TdxChartSimpleSeriesResolveOverlappingByEllipse }

function TdxChartSimpleSeriesResolveOverlappingByEllipse.Arrange(ALabelInfo: TdxLabelInfo): Boolean;
begin
  FSortedList.Add(ALabelInfo);
  FSortedList.Sort(FComparer);
  ALabelInfo.Arranged := True;
  if IsPositionValid(ALabelInfo) then
    Exit(True);
  ALabelInfo.CurrentSrc := True;
  try
    Push(GetArrangedNext(ALabelInfo), True);
    Push(GetArrangedPrev(ALabelInfo), False);
  finally
    ALabelInfo.CurrentSrc := False;
  end;
  Result := IsPositionValid(ALabelInfo);
end;

procedure TdxChartSimpleSeriesResolveOverlappingByEllipse.ArrangeByEllipse(const ALabels: TdxLabelInfoList);
var
  I, J, K: Integer;
  AGroups: TdxList<TdxLabelInfoList>;
  AGroup: TdxLabelInfoList;
begin
  K := ALabels.Count;
  for I := 0 to K - 1 do
  begin
    ALabels[I].Next := ALabels[(I + 1 + K) mod K];
    ALabels[I].Prev := ALabels[(I - 1 + K) mod K];
  end;
  AGroups := CalculateGroups(ALabels);
  FSortedList := TdxLabelInfoList.Create;
  try
    for I := 0 to AGroups.Count - 1 do
    begin
      AGroup := AGroups[I];
      J := 0;
      K := AGroup.Count - 1;
      while J <= K do
      begin
        Arrange(AGroup[J]);
        if J <> K then
          Arrange(AGroup[K]);
        Inc(J);
        Dec(K);
      end;
    end;
  finally
    FSortedList.Free;
    AGroups.Free;
  end;
end;

procedure TdxChartSimpleSeriesResolveOverlappingByEllipse.ArrangeLabels;
var
  AActualLabels: TdxLabelInfoList;
  I: Integer;
begin
  AActualLabels := GetLabelsForArrangeByEllipse;
  try
    if AActualLabels.Count > 1 then
    begin
      ArrangeByEllipse(AActualLabels);
      for I := 0 to AActualLabels.Count - 1 do
        AActualLabels[I].Flush;
    end;
  finally
    AActualLabels.Free;
  end;
end;

function TdxChartSimpleSeriesResolveOverlappingByEllipse.CalculateAngle(const AP1, AP2: TdxPointF): Single;
begin
  Result := Arctan2(AP2.Y - AP1.Y, AP2.X - AP1.X);
end;

function TdxChartSimpleSeriesResolveOverlappingByEllipse.CalculateCenter(
  ALabelInfo: TdxLabelInfo; AFromPrev: Boolean): TdxPointF;
var
  AActualBounds: TdxRectF;
  ARadius: Single;
  AEllipse: TdxRectF;
  APoints: TList<TdxPointF>;
begin
  if AFromPrev then
    AActualBounds := GetArrangedPrev(ALabelInfo).LabelBounds
  else
    AActualBounds := GetArrangedNext(ALabelInfo).LabelBounds;
  AActualBounds.Inflate(ALabelInfo.LabelBounds.Width / 2, ALabelInfo.LabelBounds.Height / 2);
  ARadius := cxPointDistanceF(FEllipse.CenterPoint, ALabelInfo.LabelBounds.CenterPoint);
  AEllipse.InitSize(FEllipse.CenterPoint.X - ARadius, FEllipse.CenterPoint.Y - ARadius, ARadius * 2, ARadius * 2);
  APoints := dxCalculateIntersectionBetweenRectAndEllipse(AActualBounds, AEllipse);
  try
    if APoints.Count = 0 then
      Result := ALabelInfo.LabelBounds.CenterPoint
    else
      Result := FindPoint(APoints, AActualBounds, FEllipse.CenterPoint, AFromPrev);
  finally
    APoints.Free;
  end;
end;

function TdxChartSimpleSeriesResolveOverlappingByEllipse.CalculateGroups(const ALabelsInfo: TdxLabelInfoList): TdxList<TdxLabelInfoList>;
var
  AInvalidGroup, ANewGroup: TdxLabelInfoList;
  I: Integer;
begin
  AInvalidGroup := nil;
  Result := TdxList<TdxLabelInfoList>.Create(True);
  for I := 0 to ALabelsInfo.Count - 1 do
  begin
    if IsPositionValidByBounds(ALabelsInfo[I]) then
    begin
      if (AInvalidGroup <> nil) and (AInvalidGroup.Count > 0) then
      begin
        Result.Add(AInvalidGroup);
        AInvalidGroup := nil;
      end;
      ANewGroup := TdxLabelInfoList.Create;
      ANewGroup.Add(ALabelsInfo[I]);
      Result.Add(ANewGroup);
    end
    else
    begin
      if AInvalidGroup = nil then
        AInvalidGroup := TdxLabelInfoList.Create;
      AInvalidGroup.Add(ALabelsInfo[I]);
    end;
  end;
  if (AInvalidGroup <> nil) and (AInvalidGroup.Count > 0) then
  begin
    if (Result.Count = 0) or IsPositionValidByBounds(ALabelsInfo[0]) then
      Result.Add(AInvalidGroup)
    else
    begin
      AInvalidGroup.AddRange(Result[0]);
      Result[0] := AInvalidGroup;
    end;
  end;
  Result.Sort(FGroupComparer);
end;

procedure TdxChartSimpleSeriesResolveOverlappingByEllipse.CorrectCenterByDiagramBounds(
  ALabelInfo: TdxLabelInfo; const ACenter: TdxPointF);
var
  APrevLabelBounds, ANextLabelBounds: TdxRectF;
  ANeedTopCorrection, ANeedBottomCorrection, AIsClockWiseDirection: Boolean;
  ACorrectedCenter: TdxPointF;
begin
  APrevLabelBounds := ALabelInfo.Prev.LabelBounds;
  ANextLabelBounds := ALabelInfo.Next.LabelBounds;
  ANeedTopCorrection := ALabelInfo.LabelBounds.Top - FDiagramBounds.Top <= 0;
  ANeedBottomCorrection := FDiagramBounds.Bottom - ALabelInfo.LabelBounds.Bottom <= 0;
  AIsClockWiseDirection := FDirection = TdxChartPieSweepDirection.Clockwise;
  if ANeedTopCorrection or ANeedBottomCorrection then
  begin
    if ANeedTopCorrection then
      ACorrectedCenter.Init(ACenter.X, FDiagramBounds.Top + ALabelInfo.LabelBounds.Height / 2)
    else
      ACorrectedCenter.Init(ACenter.X, FDiagramBounds.Bottom - ALabelInfo.LabelBounds.Height / 2);
    ALabelInfo.SetCenter(ACorrectedCenter);
    if not ALabelInfo.NextLabelNearest.HasValue then
      ALabelInfo.NextLabelNearest := NextLabelIsNearest(ALabelInfo);
    if not IsCorrectedPositionValid(ALabelInfo, not ALabelInfo.NextLabelNearest) then
    begin
      if not AIsClockWiseDirection xor ANeedTopCorrection then
        ACorrectedCenter.X := IfThen(NextLabelIsNearest(ALabelInfo), ANextLabelBounds.Left - ALabelInfo.LabelBounds.Width / 2,
          APrevLabelBounds.Right + ALabelInfo.LabelBounds.Width / 2)
      else
        ACorrectedCenter.X := IfThen(NextLabelIsNearest(ALabelInfo), ANextLabelBounds.Right + ALabelInfo.LabelBounds.Width / 2,
          APrevLabelBounds.Left - ALabelInfo.LabelBounds.Width / 2);
      ALabelInfo.SetCenter(ACorrectedCenter);
    end;
  end;
end;

constructor TdxChartSimpleSeriesResolveOverlappingByEllipse.Create(
  const ALabels: TdxChartSeriesValueLabelViewInfoList; const ADiagramBounds: TdxRectF; AIndent: Single;
  const AEllipse: TdxRectF; ADirection: TdxChartPieSweepDirection);
begin
  inherited Create(ALabels, ADiagramBounds, AIndent);
  FEllipse := AEllipse;
  FDirection := ADirection;
  FComparer := TdxLabelInfoComparer.Create;
  FGroupComparer := TdxLabelInfoGroupComparer.Create;
end;

destructor TdxChartSimpleSeriesResolveOverlappingByEllipse.Destroy;
begin
  FComparer.Free;
  FGroupComparer.Free;
  inherited Destroy;
end;

function TdxChartSimpleSeriesResolveOverlappingByEllipse.FindPoint(
  const APoints: TList<TdxPointF>; const ABounds: TdxRectF; const ACenter: TdxPointF; AForward: Boolean): TdxPointF;
var
  AAngle1, AAngle2, AMaxCos, AAngle, ACos: Single;
  P, ACalcPoint: TdxPointF;
  AV1, AV2: TdxPointF;
  AIsClockwiseDirection: Boolean;
  I: Integer;
begin
  AAngle1 := CalculateAngle(ACenter, ABounds.CenterPoint);
  ACalcPoint.Init(ACenter.X - (ABounds.CenterPoint.X - ACenter.X), ACenter.Y + (ACenter.Y - ABounds.CenterPoint.Y));
  AAngle2 := CalculateAngle(ACenter, ACalcPoint);
  AMaxCos := -MaxSingle;
  Result := ABounds.CenterPoint;
  AV1.Init(ABounds.CenterPoint.X - ACenter.X, ABounds.CenterPoint.Y - ACenter.Y);
  AV1 := TdxVectors.Normalize(AV1);
  for I := 0 to APoints.Count - 1 do
  begin
    P := APoints[I];
    AAngle := CalculateAngle(ACenter, P);
    AV2.Init(P.X - ABounds.CenterPoint.X, P.Y - ABounds.CenterPoint.Y);
    AV2 := TdxVectors.Normalize(AV2);
    ACos := TdxVectors.ScalarProduct(AV1, AV2);
    if FDirection = TdxChartPieSweepDirection.Clockwise then
      AIsClockwiseDirection := not AForward
    else
      AIsClockwiseDirection := AForward;
    if (ACos > AMaxCos) and (((not AIsClockwiseDirection and IsAngleInRange(AAngle, AAngle1, AAngle2))) or
      ((AIsClockwiseDirection and IsAngleInRange(AAngle, AAngle2, AAngle1)))) then
    begin
      AMaxCos := ACos;
      Result := P;
    end;
  end;
end;

function TdxChartSimpleSeriesResolveOverlappingByEllipse.GetArrangedNext(ALabelInfo: TdxLabelInfo): TdxLabelInfo;
begin
  if ALabelInfo.Next.Arranged then
    Result := ALabelInfo.Next
  else
    Result := GetArrangedNext(ALabelInfo.Next);
end;

function TdxChartSimpleSeriesResolveOverlappingByEllipse.GetArrangedPrev(ALabelInfo: TdxLabelInfo): TdxLabelInfo;
begin
  if ALabelInfo.Prev.Arranged then
    Result := ALabelInfo.Prev
  else
    Result := GetArrangedPrev(ALabelInfo.Prev);
end;

function TdxChartSimpleSeriesResolveOverlappingByEllipse.GetLabelsForArrangeByEllipse: TdxLabelInfoList;
var
  ALabelBounds: TdxRectF;
  I: Integer;
begin
  Result := TdxLabelInfoList.Create(True);
  for I := 0 to FLabels.Count - 1 do
  begin
    ALabelBounds := FLabels[I].Bounds;
    ALabelBounds.Inflate(FIndent / 2, FIndent / 2);
    if (ALabelBounds.Width > 0) and (ALabelBounds.Height > 0) then
      Result.Add(TdxLabelInfo.Create(TdxChartSimpleSeriesPieValueLabelViewInfo(FLabels[I]), FIndent, FEllipse.CenterPoint));
  end;
end;

function TdxChartSimpleSeriesResolveOverlappingByEllipse.GetNextByRefAngle(ALabelInfo: TdxLabelInfo): TdxLabelInfo;
var
  AIndex: Integer;
begin
  AIndex := FSortedList.IndexOf(ALabelInfo);
  if AIndex = FSortedList.Count - 1 then
    Result := FSortedList[0]
  else
    Result := FSortedList[AIndex + 1];
end;

function TdxChartSimpleSeriesResolveOverlappingByEllipse.GetPrevByRefAngle(ALabelInfo: TdxLabelInfo): TdxLabelInfo;
var
  AIndex: Integer;
begin
  AIndex := FSortedList.IndexOf(ALabelInfo);
  if AIndex = 0 then
    Result := FSortedList[FSortedList.Count - 1]
  else
    Result := FSortedList[AIndex - 1];
end;

function TdxChartSimpleSeriesResolveOverlappingByEllipse.IsAngleInRange(AAngle, AAngle1, AAngle2: Single): Boolean;
begin
  if AAngle1 < AAngle2 then
    Result := (AAngle >= AAngle1) and (AAngle <= AAngle2)
  else
    Result := (AAngle <= AAngle2) or (AAngle >= AAngle1);
end;

function TdxChartSimpleSeriesResolveOverlappingByEllipse.IsCorrectedPositionValid(ALabelInfo: TdxLabelInfo; AFromPrev: TdxNullableValue<Boolean>): Boolean;
var
  AActualBounds: TdxRectF;
begin
  if AFromPrev.Value then
    AActualBounds := GetArrangedPrev(ALabelInfo).LabelBounds
  else
    AActualBounds := GetArrangedNext(ALabelInfo).LabelBounds;
  AActualBounds.Inflate(ALabelInfo.LabelBounds.Width / 2, ALabelInfo.LabelBounds.Height / 2);
  Result := not AActualBounds.Contains(ALabelInfo.LabelBounds.CenterPoint);
end;

function TdxChartSimpleSeriesResolveOverlappingByEllipse.IsPositionValid(ALabelInfo: TdxLabelInfo; AFromPrev: Boolean): Boolean;
var
  AActualBounds: TdxRectF;
begin
  if AFromPrev then
    AActualBounds := GetArrangedPrev(ALabelInfo).LabelBounds
  else
    AActualBounds := GetArrangedNext(ALabelInfo).LabelBounds;
  AActualBounds.Inflate(ALabelInfo.LabelBounds.Width / 2, ALabelInfo.LabelBounds.Height / 2);
  Result := not AActualBounds.Contains(ALabelInfo.LabelBounds.CenterPoint) and
    GetNextByRefAngle(ALabelInfo).Arranged and GetPrevByRefAngle(ALabelInfo).Arranged;
end;

function TdxChartSimpleSeriesResolveOverlappingByEllipse.IsPositionValid(ALabelInfo: TdxLabelInfo): Boolean;
var
  AWidthCorrection, AHeightCorrection: Single;
  APrevInfo, ANextInfo: TdxLabelInfo;
  APrev, ANext: TdxRectF;
begin
  AWidthCorrection := ALabelInfo.LabelBounds.Width / 2;
  AHeightCorrection := ALabelInfo.LabelBounds.Height / 2;
  APrevInfo := GetArrangedPrev(ALabelInfo);
  ANextInfo := GetArrangedNext(ALabelInfo);
  APrev := APrevInfo.LabelBounds;
  APrev.Inflate(AWidthCorrection, AHeightCorrection);
  ANext := ANextInfo.LabelBounds;
  ANext.Inflate(AWidthCorrection, AHeightCorrection);
  Result := ((((ALabelInfo = APrevInfo) or (not APrev.Contains(ALabelInfo.LabelBounds.CenterPoint))) and
    ((ALabelInfo = ANextInfo) or (not ANext.Contains(ALabelInfo.LabelBounds.CenterPoint)))) and
    GetNextByRefAngle(ALabelInfo).Arranged) and GetPrevByRefAngle(ALabelInfo).Arranged;
end;

function TdxChartSimpleSeriesResolveOverlappingByEllipse.IsPositionValidByBounds(ALabelInfo: TdxLabelInfo): Boolean;
var
  AWidthCorrection, AHeightCorrection: Single;
  APrevRect, ANextRect: TdxRectF;
begin
  AWidthCorrection := ALabelInfo.LabelBounds.Width / 2;
  AHeightCorrection := ALabelInfo.LabelBounds.Height / 2;
  APrevRect := ALabelInfo.Prev.LabelBounds;
  APrevRect.Inflate(AWidthCorrection, AHeightCorrection);
  ANextRect := ALabelInfo.Next.LabelBounds;
  ANextRect.Inflate(AWidthCorrection, AHeightCorrection);
  Result := not APrevRect.Contains(ALabelInfo.LabelBounds.CenterPoint) and not ANextRect.Contains(ALabelInfo.LabelBounds.CenterPoint);
end;

function TdxChartSimpleSeriesResolveOverlappingByEllipse.NextLabelIsNearest(ALabelInfo: TdxLabelInfo): Boolean;
var
  ADistanceToPrevLabel, ADistanceToNextLabel: Single;
begin
  ADistanceToPrevLabel := cxPointDistanceF(ALabelInfo.LabelBounds.CenterPoint, ALabelInfo.Prev.LabelBounds.CenterPoint);
  ADistanceToNextLabel := cxPointDistanceF(ALabelInfo.LabelBounds.CenterPoint, ALabelInfo.Next.LabelBounds.CenterPoint);
  Result := ADistanceToNextLabel < ADistanceToPrevLabel;
end;

procedure TdxChartSimpleSeriesResolveOverlappingByEllipse.Push(ALabelInfo: TdxLabelInfo; AForward: Boolean);
var
  APoint: TdxPointF;
begin
  if ALabelInfo.CurrentSrc or IsPositionValid(ALabelInfo, AForward) then
    Exit;
  APoint := CalculateCenter(ALabelInfo, AForward);
  ALabelInfo.SetCenter(APoint);
  CorrectCenterByDiagramBounds(ALabelInfo, APoint);
  if FSortedList <> nil then
    FSortedList.Sort(FComparer);
  if AForward then
    Push(GetArrangedNext(ALabelInfo), AForward)
  else
    Push(GetArrangedPrev(ALabelInfo), AForward);
end;

{ TdxChartSimpleSeriesResolveOverlappingByEllipse.TdxLabelInfo }

constructor TdxChartSimpleSeriesResolveOverlappingByEllipse.TdxLabelInfo.Create(
  const ALabel: TdxChartSimpleSeriesPieValueLabelViewInfo; AIndent: Single; const AEllipseCenter: TdxPointF);
begin
  LabelViewInfo := ALabel;
  Indent := AIndent;
  EllipseCenter := AEllipseCenter;
  OccupiedWidth := ALabel.Bounds.Width + AIndent;
  OccupiedHeight := ALabel.Bounds.Height + AIndent;
  SetCenter(ALabel.Bounds.CenterPoint);
end;

procedure TdxChartSimpleSeriesResolveOverlappingByEllipse.TdxLabelInfo.Flush;
begin
  LabelViewInfo.Offset(LabelBounds.CenterPoint);
end;

procedure TdxChartSimpleSeriesResolveOverlappingByEllipse.TdxLabelInfo.SetCenter(APoint: TdxPointF);
begin
  LabelBounds.InitSize(APoint.X - 0.5 * OccupiedWidth, APoint.Y - 0.5 * OccupiedHeight, OccupiedWidth, OccupiedHeight);
  RefAngle := Arctan2(EllipseCenter.Y - LabelBounds.CenterPoint.Y, LabelBounds.CenterPoint.X - EllipseCenter.X);
end;

{ TdxChartSimpleSeriesResolveOverlappingByEllipse.TdxLabelInfoComparer }

function TdxChartSimpleSeriesResolveOverlappingByEllipse.TdxLabelInfoComparer.Compare(
  const Left, Right: TdxLabelInfo): Integer;
begin
  Result := Sign(Left.RefAngle - Right.RefAngle);
end;

{ TdxChartSimpleSeriesResolveOverlappingByEllipse.TdxLabelInfoGroupComparer }

function TdxChartSimpleSeriesResolveOverlappingByEllipse.TdxLabelInfoGroupComparer.Compare(
  const Left, Right: TdxLabelInfoList): Integer;
begin
  Result := Sign(Left.Count - Right.Count);
end;

{ TdxChartSimpleSeriesPieValueLabelsResolveOverlapping }

class procedure TdxChartSimpleSeriesPieValueLabelsOverlappingResolver.ArrangeByColumn(
  const ALabels: TdxChartSeriesValueLabelViewInfoList; const ADiagramBounds: TdxRectF; AIndent: Single);
var
  AAlgorithm: TdxChartSimpleSeriesResolveOverlappingByColumn;
begin
  AAlgorithm := TdxChartSimpleSeriesResolveOverlappingByColumn.Create(ALabels, ADiagramBounds, AIndent);
  try
    AAlgorithm.ArrangeLabels;
  finally
    AAlgorithm.Free;
  end;
end;

class procedure TdxChartSimpleSeriesPieValueLabelsOverlappingResolver.ArrangeByEllipse(
  const ALabels: TdxChartSeriesValueLabelViewInfoList; const ADiagramBounds: TdxRectF; AIndent: Single;
  const AEllipse: TdxRectF; ADirection: TdxChartPieSweepDirection);
var
  AAlgorithm: TdxChartSimpleSeriesResolveOverlappingByEllipse;
begin
  AAlgorithm := TdxChartSimpleSeriesResolveOverlappingByEllipse.Create(ALabels, ADiagramBounds, AIndent,
    AEllipse, ADirection);
  try
    AAlgorithm.ArrangeLabels;
  finally
    AAlgorithm.Free;
  end;
end;

initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  RegisterClasses([TdxChartSimpleDiagram, TdxChartSimpleSeries, TdxChartSimpleSeriesViewAppearance,
    TdxChartSimpleSeriesViewAppearanceValueLabelAppearance, TdxChartSimpleSeriesTotalLabel]);
  TdxChartSimpleSeriesPieView.Register;
  TdxChartSimpleSeriesDoughnutView.Register;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxChartSimpleSeriesPieView.UnRegister;
  TdxChartSimpleSeriesDoughnutView.UnRegister;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.


