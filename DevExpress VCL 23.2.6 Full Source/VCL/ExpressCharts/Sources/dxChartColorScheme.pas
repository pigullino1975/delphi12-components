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

unit dxChartColorScheme;

{$I cxVer.inc}
{$R dxChartColorScheme.res}

{$SCOPEDENUMS ON}

interface

uses
  System.UITypes,
  Types, Windows, Classes, Graphics, Generics.Collections, Generics.Defaults,
  dxCore, dxCoreGraphics, dxCoreClasses, dxGenerics, dxXMLDoc, dxGDIPlusClasses, cxGeometry, cxClasses, cxGraphics;

type

  { TdxChartColorSchemeAccent }

  TdxChartColorSchemeAccent = class
  strict private const
    BaseBackground: TdxHSL = (H: 0; S: 1; L: 1);
    BaseForeground: TdxHSL = (H: 0; S: 0; L: 0);
  strict private
    FBackgroundColor: TdxHSL;
    FForegroundColor: TdxHSL;

    procedure TranslateColor(var AColor: TdxAlphaColor); overload;
    procedure TranslateColor(var AColor: TdxHSL); overload;
  public
    constructor Create(ABackgroundColor, AForegroundColor, AAccentColor: TdxAlphaColor);
    procedure ChangeAccent(var AColor: TdxAlphaColor); overload;
    procedure ChangeBackground(var AColor: TdxAlphaColor); overload;
    procedure ChangeForeground(var AColor: TdxAlphaColor); overload;
  end;

  { TdxChartColorSchemeCustomElement }

  TdxChartColorSchemeCustomElement = class(TPersistent)
  protected
    procedure DoApplyColorAccent(AAccent: TdxChartColorSchemeAccent); virtual;
    procedure DoAssign(AObject: TdxChartColorSchemeCustomElement); virtual;
    procedure DoRead(ANode: TdxXMLNode); virtual;
    procedure DoReset; virtual;
  public
    procedure AfterConstruction; override;
    procedure Assign(Source: TPersistent); override; final;
  end;

  { TdxChartColorSchemeCustomVisualElement }

  TdxChartColorSchemeCustomVisualElement = class(TdxChartColorSchemeCustomElement)
  protected
    FBackgroundColor: TdxAlphaColor;
    FBorderColor: TdxAlphaColor;

    procedure DoApplyColorAccent(AAccent: TdxChartColorSchemeAccent); override;
    procedure DoAssign(AObject: TdxChartColorSchemeCustomElement); override;
    procedure DoRead(ANode: TdxXMLNode); override;
    procedure DoReset; override;
  public
    property BackgroundColor: TdxAlphaColor read FBackgroundColor;
    property BorderColor: TdxAlphaColor read FBorderColor;
  end;

  { TdxChartColorSchemeVisualElement }

  TdxChartColorSchemeVisualElement = class(TdxChartColorSchemeCustomVisualElement)
  protected
    procedure DoRead(ANode: TdxXMLNode); override;
  end;

  { TdxChartColorSchemeChart }

  TdxChartColorSchemeChart = class(TdxChartColorSchemeCustomVisualElement)
  strict private
    FTitleColor: TdxAlphaColor;
  protected
    procedure DoApplyColorAccent(AAccent: TdxChartColorSchemeAccent); override;
    procedure DoAssign(AObject: TdxChartColorSchemeCustomElement); override;
    procedure DoRead(ANode: TdxXMLNode); override;
    procedure DoReset; override;
  public
    property TitleColor: TdxAlphaColor read FTitleColor;
  end;

  { TdxChartColorSchemeAnnotation }

  TdxChartColorSchemeAnnotation = class(TdxChartColorSchemeCustomVisualElement)
  protected
    procedure DoRead(ANode: TdxXMLNode); override;
  end;

  { TdxChartColorSchemeDiagram }

  TdxChartColorSchemeDiagram = class(TdxChartColorSchemeCustomVisualElement);

  { TdxChartColorSchemeAxisBasedDiagram }

  TdxChartColorSchemeAxisBasedDiagram = class(TdxChartColorSchemeDiagram)
  protected
    FAxisColor: TdxAlphaColor;
    FBackgroundInterlacedColor: TdxAlphaColor;
    FGridLinesColor: TdxAlphaColor;
    FLabelsColor: TdxAlphaColor;
    FMinorGridLinesColor: TdxAlphaColor;

    procedure DoApplyColorAccent(AAccent: TdxChartColorSchemeAccent); override;
    procedure DoAssign(AObject: TdxChartColorSchemeCustomElement); override;
    procedure DoRead(ANode: TdxXMLNode); override;
    procedure DoReset; override;
  public
    property AxisColor: TdxAlphaColor read FAxisColor;
    property BackgroundInterlacedColor: TdxAlphaColor read FBackgroundInterlacedColor;
    property GridLinesColor: TdxAlphaColor read FGridLinesColor;
    property LabelsColor: TdxAlphaColor read FLabelsColor;
    property MinorGridLinesColor: TdxAlphaColor read FMinorGridLinesColor;
  end;

  { TdxChartColorSchemeDiagramXY }

  TdxChartColorSchemeDiagramXY = class(TdxChartColorSchemeAxisBasedDiagram)
  strict private
    FAxisTitleColor: TdxAlphaColor;
    FInnerAxisColor: TdxAlphaColor;
    FTextColor: TdxAlphaColor;
    FZoomRectangleBorderColor: TdxAlphaColor;
    FZoomRectangleColor: TdxAlphaColor;
  protected
    procedure DoApplyColorAccent(AAccent: TdxChartColorSchemeAccent); override;
    procedure DoAssign(AObject: TdxChartColorSchemeCustomElement); override;
    procedure DoRead(ANode: TdxXMLNode); override;
    procedure DoReset; override;
  public
    property AxisTitleColor: TdxAlphaColor read FAxisTitleColor;
    property InnerAxisColor: TdxAlphaColor read FInnerAxisColor;
    property TextColor: TdxAlphaColor read FTextColor;
    property ZoomRectangleBorderColor: TdxAlphaColor read FZoomRectangleBorderColor;
    property ZoomRectangleColor: TdxAlphaColor read FZoomRectangleColor;
  end;

  { TdxChartColorSchemeLegend }

  TdxChartColorSchemeLegend = class(TdxChartColorSchemeCustomVisualElement)
  strict private
    FPadding: TdxRectF;
    FTextColor: TdxAlphaColor;
  protected
    procedure DoApplyColorAccent(AAccent: TdxChartColorSchemeAccent); override;
    procedure DoAssign(AObject: TdxChartColorSchemeCustomElement); override;
    procedure DoRead(ANode: TdxXMLNode); override;
    procedure DoReset; override;
  public
    property Padding: TdxRectF read FPadding;
    property TextColor: TdxAlphaColor read FTextColor;
  end;

  { TdxChartColorSchemeTextAnnotation }

  TdxChartColorSchemeTextAnnotation = class(TdxChartColorSchemeAnnotation)
  strict private
    FTextColor: TdxAlphaColor;
  protected
    procedure DoApplyColorAccent(AAccent: TdxChartColorSchemeAccent); override;
    procedure DoAssign(AObject: TdxChartColorSchemeCustomElement); override;
    procedure DoRead(ANode: TdxXMLNode); override;
    procedure DoReset; override;
  public
    property TextColor: TdxAlphaColor read FTextColor;
  end;

  { TdxChartColorSchemeView }

  TdxChartColorSchemeView = class(TdxChartColorSchemeVisualElement);

  { TdxChartColorSchemeBarSeriesView }

  TdxChartColorSchemeBarSeriesView = class(TdxChartColorSchemeView)
  strict private
    FShowBorder: Boolean;
  protected
    procedure DoAssign(AObject: TdxChartColorSchemeCustomElement); override;
    procedure DoRead(ANode: TdxXMLNode); override;
    procedure DoReset; override;
  public
    property ShowBorder: Boolean read FShowBorder;
  end;

  { TdxChartColorSchemeLabel }

  TdxChartColorSchemeLabel = class(TdxChartColorSchemeCustomVisualElement)
  strict private
    FShowBorder: Boolean;
    FTextColor: TdxAlphaColor;
  protected
    procedure DoApplyColorAccent(AAccent: TdxChartColorSchemeAccent); override;
    procedure DoAssign(AObject: TdxChartColorSchemeCustomElement); override;
    procedure DoRead(ANode: TdxXMLNode); override;
    procedure DoReset; override;
  public
    property ShowBorder: Boolean read FShowBorder;
    property TextColor: TdxAlphaColor read FTextColor;
  end;

  { TdxChartColorSchemeSeriesLabel }

  TdxChartColorSchemeSeriesLabel = class(TdxChartColorSchemeLabel)
  strict private
    FConnectorColor: TdxAlphaColor;
    FShowBubbleConnector: Boolean;
    FShowConnector: Boolean;
  protected
    procedure DoApplyColorAccent(AAccent: TdxChartColorSchemeAccent); override;
    procedure DoAssign(AObject: TdxChartColorSchemeCustomElement); override;
    procedure DoRead(ANode: TdxXMLNode); override;
    procedure DoReset; override;
  public
    property ConnectorColor: TdxAlphaColor read FConnectorColor;
    property ShowBubbleConnector: Boolean read FShowBubbleConnector;
    property ShowConnector: Boolean read FShowConnector;
  end;

  { TdxChartColorSchemeConstantLine }

  TdxChartColorSchemeConstantLine = class(TdxChartColorSchemeCustomElement)
  strict private
    FColor: TdxAlphaColor;
    FDashStyle: TdxGPPenStyle;
    FTitleColor: TdxAlphaColor;
  protected
    procedure DoApplyColorAccent(AAccent: TdxChartColorSchemeAccent); override;
    procedure DoAssign(AObject: TdxChartColorSchemeCustomElement); override;
    procedure DoRead(ANode: TdxXMLNode); override;
    procedure DoReset; override;
  public
    property Color: TdxAlphaColor read FColor;
    property DashStyle: TdxGPPenStyle read FDashStyle;
    property TitleColor: TdxAlphaColor read FTitleColor;
  end;

  { TdxChartColorSchemePaneTitle }

  TdxChartColorSchemePaneTitle = class(TdxChartColorSchemeCustomVisualElement)
  strict private
    FArrowOffset: TdxPointF;
    FFontSize: Integer;
    FFontStyle: TFontStyles;
    FMargins: TdxRectF;
    FTextColor: TdxAlphaColor;
    FTextColorHot: TdxAlphaColor;
  protected
    procedure DoApplyColorAccent(AAccent: TdxChartColorSchemeAccent); override;
    procedure DoAssign(AObject: TdxChartColorSchemeCustomElement); override;
    procedure DoRead(ANode: TdxXMLNode); override;
    procedure DoReset; override;
  public
    property ArrowOffset: TdxPointF read FArrowOffset;
    property FontSize: Integer read FFontSize;
    property FontStyle: TFontStyles read FFontStyle;
    property Margins: TdxRectF read FMargins;
    property TextColor: TdxAlphaColor read FTextColor;
    property TextColorHot: TdxAlphaColor read FTextColorHot;
  end;

  { TdxChartColorSchemePaletteEntry }

  TdxChartColorSchemePaletteEntry = class
  protected
    FColor: TdxAlphaColor;
    FColor2: TdxAlphaColor;

    function Clone: TdxChartColorSchemePaletteEntry;
    procedure DoApplyColorAccent(AAccent: TdxChartColorSchemeAccent);
  public
    constructor Create(const AColor, AColor2: TdxAlphaColor);
    property Color: TdxAlphaColor read FColor;
    property Color2: TdxAlphaColor read FColor2;
  end;

  { TdxChartColorSchemePalette }

  TdxChartColorSchemePalette = class(TdxChartColorSchemeCustomElement)
  strict private
    FList: TcxObjectList;
    FName: string;

    procedure GenerateColorShades;
    function GetCount: Integer;
    function GetItem(Index: Integer): TdxChartColorSchemePaletteEntry;
  protected
    procedure Add(AColor1, AColor2: TdxAlphaColor);
    procedure DoApplyColorAccent(AAccent: TdxChartColorSchemeAccent); override;
    procedure DoAssign(AObject: TdxChartColorSchemeCustomElement); override;
    procedure DoRead(ANode: TdxXMLNode); override;
    procedure DoReset; override;
  public
    constructor Create;
    destructor Destroy; override;
    function Clone: TdxChartColorSchemePalette;
    function GetByElementIndex(AElementIndex: Integer): TdxChartColorSchemePaletteEntry;
    procedure LoadFromFile(const AFileName: string);
    procedure LoadFromResource(const AInstance: THandle; const AName: string; AType: PChar);
    procedure LoadFromStream(const AStream: TStream);
    //
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TdxChartColorSchemePaletteEntry read GetItem; default;
    property Name: string read FName;
  end;

  { TdxChartColorSchemePaletteRepository }

  TdxChartColorSchemePaletteRepository = class
  public const
    DefaultName = 'Default';
  strict private const
    ResourcePrefix = 'DXCHART_PALETTE_';
    ResourceType = 'DXCHART';
  strict private
    class var FRepository: TObjectDictionary<string, TdxChartColorSchemePalette>;

    class function EnumProc(hModule: HMODULE; AType: LPCTSTR; AName: LPTSTR; AData: Pointer): Boolean; stdcall; static;
    class function GetDefault: TdxChartColorSchemePalette; static;
  protected
    class procedure CheckInitialized;
    class procedure Finalize;
  public
    class function Get(const AName: string): TdxChartColorSchemePalette;
    //
    class property Default: TdxChartColorSchemePalette read GetDefault;
  end;

  { TdxChartColorScheme }

  TdxChartColorScheme = class(TdxChartColorSchemeCustomElement)
  strict private
    FAreaSeriesView: TdxChartColorSchemeView;
    FBarSeriesView: TdxChartColorSchemeBarSeriesView;
    FChart: TdxChartColorSchemeChart;
    FConstantLine: TdxChartColorSchemeConstantLine;
    FDiagramXY: TdxChartColorSchemeDiagramXY;
    FImageAnnotation: TdxChartColorSchemeAnnotation;
    FLegend: TdxChartColorSchemeLegend;
    FMarker: TdxChartColorSchemeVisualElement;
    FPaneTitle: TdxChartColorSchemePaneTitle;
    FPieSeriesView: TdxChartColorSchemeView;
    FPieTotalLabel: TdxChartColorSchemeLabel;
    FSeriesColors: TdxChartColorSchemePalette;
    FSeriesLabel: TdxChartColorSchemeSeriesLabel;
    FStackedBarTotalLabel: TdxChartColorSchemeLabel;
    FStrip: TdxChartColorSchemeVisualElement;
    FTextAnnotation: TdxChartColorSchemeTextAnnotation;

    FName: string;

    procedure SetSeriesColorsReference(APalette: TdxChartColorSchemePalette);
  protected
    procedure DoApplyColorAccent(AAccent: TdxChartColorSchemeAccent); override;
    procedure DoAssign(AObject: TdxChartColorSchemeCustomElement); override;
    procedure DoRead(ANode: TdxXMLNode); override;
    procedure DoReset; override;
  public
    constructor Create(const AName: string);
    destructor Destroy; override;
    procedure ApplyColorAccent(ABackgroundColor, AForegroundColor, AAccentColor: TdxAlphaColor);
    procedure LoadFromFile(const AFileName: string);
    procedure LoadFromStream(const AStream: TStream);
    procedure LoadFromResource(const AInstance: THandle; const AName: string; AType: PChar);
    //
    property AreaSeriesView: TdxChartColorSchemeView read FAreaSeriesView;
    property BarSeriesView: TdxChartColorSchemeBarSeriesView read FBarSeriesView;
    property Chart: TdxChartColorSchemeChart read FChart;
    property ConstantLine: TdxChartColorSchemeConstantLine read FConstantLine;
    property DiagramXY: TdxChartColorSchemeDiagramXY read FDiagramXY;
    property ImageAnnotation: TdxChartColorSchemeAnnotation read FImageAnnotation;
    property Legend: TdxChartColorSchemeLegend read FLegend;
    property Marker: TdxChartColorSchemeVisualElement read FMarker;
    property PaneTitle: TdxChartColorSchemePaneTitle read FPaneTitle;
    property PieSeriesView: TdxChartColorSchemeView read FPieSeriesView;
    property PieTotalLabel: TdxChartColorSchemeLabel read FPieTotalLabel;
    property SeriesColors: TdxChartColorSchemePalette read FSeriesColors;
    property SeriesLabel: TdxChartColorSchemeSeriesLabel read FSeriesLabel;
    property StackedBarTotalLabel: TdxChartColorSchemeLabel read FStackedBarTotalLabel;
    property Strip: TdxChartColorSchemeVisualElement read FStrip;
    property TextAnnotation: TdxChartColorSchemeTextAnnotation read FTextAnnotation;
    //
    property Name: string read FName;
  end;

  { TdxChartColorSchemeRepository }

  TdxChartColorSchemeRepository = class
  public const
    DefaultName = 'Default';
  strict private const
    ResourcePrefix = 'DXCHART_COLORSCHEME_';
    ResourceType = 'DXCHART';
  strict private
    class var FDefault: TdxChartColorScheme;
    class var FRepository: TcxObjectList;

    class function EnumProc(hModule: HMODULE; AType: LPCTSTR; AName: LPTSTR; AData: Pointer): Boolean; stdcall; static;
    class function GetCount: Integer; static;
    class function GetDefault: TdxChartColorScheme; static;
    class function GetItem(Index: Integer): TdxChartColorScheme; static;
  protected
    class procedure CheckInitialized;
    class procedure Finalize;
  public
    class function Get(const AName: string): TdxChartColorScheme;

    class property Count: Integer read GetCount;
    class property Default: TdxChartColorScheme read GetDefault;
    class property Items[Index: Integer]: TdxChartColorScheme read GetItem; default;
  end;

implementation

uses
  SysUtils, StrUtils, Math;

const
  dxThisUnitName = 'dxChartColorScheme';

type

  { TdxXMLNodeHelper }

  TdxXMLNodeHelper = class helper for TdxXMLNode
  public
    procedure ReadSubNodeObject(AObject: TdxChartColorSchemeCustomElement; const AValueName: TdxXMLString);
    function ReadSubNodeBoolean(const AValueName: TdxXMLString): Boolean;
    function ReadSubNodeColor(const AValueName: TdxXMLString): TdxAlphaColor;
    function ReadSubNodeFloat(const AValueName: TdxXMLString): Single;
    function ReadSubNodeRectangle(const AValueName: TdxXMLString): TdxRectF;
    function ReadSubNodeString(const AValueName: TdxXMLString): string;
  end;


  { TdxChartColorSchemeKeywords }

  TdxChartColorSchemeKeywords = class
  protected const
    Appearance = 'Appearance';
    AreaSeriesView = 'AreaSeriesView';
    ArrowOffsetX = 'ArrowOffsetX';
    ArrowOffsetY = 'ArrowOffsetY';
    AxisColor = 'AxisColor';
    AxisTitleColor = 'AxisTitleColor';
    BackColor = 'BackColor';
    BackgroundColor = 'BackgroundColor';
    BackgroundStyle = 'BackgroundStyle';
    BarSeriesView = 'BarSeriesView';
    Bold = 'Bold';
    BorderColor = 'BorderColor';
    Bottom = 'Bottom';
    Chart = 'Chart';
    Color = 'Color';
    Color2 = 'Color2';
    ConnectorColor = 'ConnectorColor';
    ConstantLine = 'ConstantLine';
    ContentMargins = 'ContentMargins';
    Dash = 'Dash';
    DashStyle = 'DashStyle';
    Dot = 'Dot';
    Entry = 'Entry';
    FillMode = 'FillMode';
    FillModeGradient = 'Gradient';
    FillModeSolid = 'Solid';
    FillStyle = 'FillStyle';
    FontSize = 'FontSize';
    ForeColor = 'ForeColor';
    ForeColorHot = 'ForeColorHot';
    GridLinesColor = 'GridLinesColor';
    ImageAnnotation = 'ImageAnnotation';
    InnerAxisColor = 'InnerAxisColor';
    InnerAxisColorAlpha = 'InnerAxisColorAlpha';
    InterlacedColor = 'InterlacedColor';
    InterlacedFillStyle = 'InterlacedFillStyle';
    Items = 'Items';
    LabelsColor = 'LabelsColor';
    Left = 'Left';
    Legend = 'Legend';
    Marker = 'Marker';
    MinorGridLinesColor = 'MinorGridLinesColor';
    Name = 'Name';
    Options = 'Options';
    Padding = 'Padding';
    Palette = 'Palette';
    PaletteName = 'PaletteName';
    PaneTitle = 'PaneTitle';
    PieSeriesView = 'PieSeriesView';
    PieTotalLabel = 'PieTotalLabel';
    RectangleGradientMode = 'RectangleGradientMode';
    RectangleGradientModeBottomLeftToTopRight = 'BottomLeftToTopRight';
    RectangleGradientModeBottomRightToTopLeft = 'BottomRightToTopLeft';
		RectangleGradientModeBottomToTop = 'BottomToTop';
    RectangleGradientModeFromCenterHorizontal = 'FromCenterHorizontal';
    RectangleGradientModeFromCenterVertical = 'FromCenterVertical';
    RectangleGradientModeLeftToRight = 'LeftToRight';
    RectangleGradientModeRightToLeft = 'RightToLeft';
    RectangleGradientModeToCenterHorizontal = 'ToCenterHorizontal';
    RectangleGradientModeToCenterVertical = 'ToCenterVertical';
    RectangleGradientModeTopLeftToBottomRight = 'TopLeftToBottomRight';
    RectangleGradientModeTopRightToBottomLeft = 'TopRightToBottomLeft';
		RectangleGradientModeTopToBottom = 'TopToBottom';
    Right = 'Right';
    SeriesLabel2D = 'SeriesLabel2D';
    ShowBorder = 'ShowBorder';
    ShowBubbleConnector = 'ShowBubbleConnector';
    ShowConnector = 'ShowConnector';
    StackedBarTotalLabel = 'StackedBarTotalLabel';
    Strip = 'Strip';
    TextAnnotation = 'TextAnnotation';
    TextColor = 'TextColor';
    TitleColor = 'TitleColor';
    Top = 'Top';
    XYDiagram = 'XYDiagram';
    ZoomRectangleBorderColor = 'ZoomRectangleBorderColor';
    ZoomRectangleColor = 'ZoomRectangleColor';
  end;

{ TdxXMLNodeHelper }

function TdxXMLNodeHelper.ReadSubNodeBoolean(const AValueName: TdxXMLString): Boolean;
begin
  Result := TdxXMLHelper.DecodeBoolean(ReadSubNodeString(AValueName));
end;


function TdxXMLNodeHelper.ReadSubNodeColor(const AValueName: TdxXMLString): TdxAlphaColor;
var
  AValue: string;
  AValueParts: TStringDynArray;
  I: Integer;
begin
  AValue := ReadSubNodeString(AValueName);
  if Pos(',', AValue) > 0 then
  begin
    AValueParts := SplitString(AValue, ',');
    for I := 0 to Length(AValueParts) - 1 do
      AValueParts[I] := Trim(AValueParts[I]);
    if Length(AValueParts) = 4 then
      Result := dxMakeAlphaColor(StrToInt(AValueParts[0]), StrToInt(AValueParts[1]), StrToInt(AValueParts[2]), StrToInt(AValueParts[3]))
    else if Length(AValueParts) = 3 then
      Result := dxMakeAlphaColor(MaxByte, StrToInt(AValueParts[0]), StrToInt(AValueParts[1]), StrToInt(AValueParts[2]))
    else
      Result := TdxAlphaColors.Default;
  end
  else
    Result := TdxAlphaColors.FromName(AValue);
end;

function TdxXMLNodeHelper.ReadSubNodeFloat(const AValueName: TdxXMLString): Single;
var
  ANode: TdxXMLNode;
begin
  if FindChild(AValueName, ANode) then
    Result := ANode.TextAsFloat
  else
    Result := 0;
end;

procedure TdxXMLNodeHelper.ReadSubNodeObject(AObject: TdxChartColorSchemeCustomElement; const AValueName: TdxXMLString);
var
  ANode: TdxXMLNode;
begin
  if FindChild(AValueName, ANode) then
    AObject.DoRead(ANode)
  else
    AObject.DoReset;
end;

function TdxXMLNodeHelper.ReadSubNodeRectangle(const AValueName: TdxXMLString): TdxRectF;
var
  ANode: TdxXMLNode;
  ANodeValue: TdxXMLNode;
begin
  Result := dxNullRectF;
  if FindChild(AValueName, ANode) then
  begin
    if ANode.FindChild(TdxChartColorSchemeKeywords.Left, ANodeValue) then
      Result.Left := ANodeValue.TextAsFloat;
    if ANode.FindChild(TdxChartColorSchemeKeywords.Top, ANodeValue) then
      Result.Top := ANodeValue.TextAsFloat;
    if ANode.FindChild(TdxChartColorSchemeKeywords.Right, ANodeValue) then
      Result.Right := ANodeValue.TextAsFloat;
    if ANode.FindChild(TdxChartColorSchemeKeywords.Bottom, ANodeValue) then
      Result.Bottom := ANodeValue.TextAsFloat;
  end;
end;

function TdxXMLNodeHelper.ReadSubNodeString(const AValueName: TdxXMLString): string;
var
  ANode: TdxXMLNode;
begin
  if FindChild(AValueName, ANode) then
    Result := ANode.TextAsString
  else
    Result := '';
end;


{ TdxChartColorSchemeAccent }

constructor TdxChartColorSchemeAccent.Create(ABackgroundColor, AForegroundColor, AAccentColor: TdxAlphaColor);
begin
  FBackgroundColor := TdxColorUtils.AlphaColorToHSL(ABackgroundColor);
  FForegroundColor := TdxColorUtils.AlphaColorToHSL(AForegroundColor);
end;

procedure TdxChartColorSchemeAccent.ChangeAccent(var AColor: TdxAlphaColor);
begin
  TranslateColor(AColor);
end;

procedure TdxChartColorSchemeAccent.ChangeBackground(var AColor: TdxAlphaColor);
begin
  TranslateColor(AColor);
end;

procedure TdxChartColorSchemeAccent.ChangeForeground(var AColor: TdxAlphaColor);
begin
  TranslateColor(AColor);
end;

procedure TdxChartColorSchemeAccent.TranslateColor(var AColor: TdxHSL);
var
  K: Single;
begin
  K := (AColor.L - BaseBackground.L) / (BaseForeground.L - BaseBackground.L);
  K := (FBackgroundColor.L * (1 - K) + FForegroundColor.L * K);
  AColor.L := EnsureRange(K, 0, 1);
end;

procedure TdxChartColorSchemeAccent.TranslateColor(var AColor: TdxAlphaColor);
var
  AAlpha: Byte;
  AHSL: TdxHSL;
begin
  if dxAlphaColorIsValid(AColor) then
  begin
    AHSL := TdxColorUtils.AlphaColorToHSL(AColor, AAlpha);
    TranslateColor(AHSL);
    AColor := TdxColorUtils.HSLToAlphaColor(AHSL, AAlpha);
  end;
end;

{ TdxChartColorSchemeCustomElement }

procedure TdxChartColorSchemeCustomElement.AfterConstruction;
begin
  inherited;
  DoReset;
end;

procedure TdxChartColorSchemeCustomElement.Assign(Source: TPersistent);
begin
  if Source <> Self then
  begin
    if Source is TdxChartColorSchemeCustomElement then
      DoAssign(TdxChartColorSchemeCustomElement(Source))
    else if Source = nil then
      DoReset
    else
      inherited;
  end;
end;

procedure TdxChartColorSchemeCustomElement.DoApplyColorAccent(AAccent: TdxChartColorSchemeAccent);
begin
  // do nothing
end;

procedure TdxChartColorSchemeCustomElement.DoAssign(AObject: TdxChartColorSchemeCustomElement);
begin
  // do nothing
end;

procedure TdxChartColorSchemeCustomElement.DoRead(ANode: TdxXMLNode);
begin
  // do nothing
end;

procedure TdxChartColorSchemeCustomElement.DoReset;
begin
  // do nothing
end;

{ TdxChartColorSchemeCustomVisualElement }

procedure TdxChartColorSchemeCustomVisualElement.DoApplyColorAccent(AAccent: TdxChartColorSchemeAccent);
begin
  inherited;
  AAccent.ChangeBackground(FBackgroundColor);
  AAccent.ChangeForeground(FBorderColor);
end;

procedure TdxChartColorSchemeCustomVisualElement.DoAssign(AObject: TdxChartColorSchemeCustomElement);
begin
  inherited;

  if AObject is TdxChartColorSchemeCustomVisualElement then
  begin
    FBackgroundColor := TdxChartColorSchemeCustomVisualElement(AObject).BackgroundColor;
    FBorderColor := TdxChartColorSchemeCustomVisualElement(AObject).BorderColor;
  end;
end;

procedure TdxChartColorSchemeCustomVisualElement.DoRead(ANode: TdxXMLNode);
begin
  inherited;
  FBorderColor := ANode.ReadSubNodeColor(TdxChartColorSchemeKeywords.BorderColor);
end;

procedure TdxChartColorSchemeCustomVisualElement.DoReset;
begin
  inherited;
  FBorderColor := TdxAlphaColors.Default;
end;

{ TdxChartColorSchemeVisualElement }

procedure TdxChartColorSchemeVisualElement.DoRead(ANode: TdxXMLNode);
begin
  inherited;
  FBackgroundColor := ANode.ReadSubNodeColor(TdxChartColorSchemeKeywords.Color);
//  ANode.ReadSubNodeBrush(Background, TdxChartColorSchemeKeywords.Color, TdxChartColorSchemeKeywords.FillStyle);
end;

{ TdxChartColorSchemeChart }

procedure TdxChartColorSchemeChart.DoApplyColorAccent(AAccent: TdxChartColorSchemeAccent);
begin
  inherited;
  AAccent.ChangeForeground(FTitleColor);
end;

procedure TdxChartColorSchemeChart.DoAssign(AObject: TdxChartColorSchemeCustomElement);
begin
  inherited;
  if AObject is TdxChartColorSchemeChart then
    FTitleColor := TdxChartColorSchemeChart(AObject).TitleColor;
end;

procedure TdxChartColorSchemeChart.DoRead(ANode: TdxXMLNode);
begin
  inherited;
//  ANode.ReadSubNodeBrush(Background, TdxChartColorSchemeKeywords.BackColor, '');
  FBackgroundColor := ANode.ReadSubNodeColor(TdxChartColorSchemeKeywords.BackColor);
  FTitleColor := ANode.ReadSubNodeColor(TdxChartColorSchemeKeywords.TitleColor);
end;

procedure TdxChartColorSchemeChart.DoReset;
begin
  inherited;
  FBackgroundColor := TdxAlphaColors.Default;
  FTitleColor := TdxAlphaColors.Default;
end;

{ TdxChartColorSchemeAnnotation }

procedure TdxChartColorSchemeAnnotation.DoRead(ANode: TdxXMLNode);
begin
  inherited;
  FBackgroundColor := ANode.ReadSubNodeColor(TdxChartColorSchemeKeywords.BackColor);
//  ANode.ReadSubNodeBrush(Background, TdxChartColorSchemeKeywords.BackColor, TdxChartColorSchemeKeywords.FillStyle);
end;

{ TdxChartColorSchemeAxisBasedDiagram }

procedure TdxChartColorSchemeAxisBasedDiagram.DoApplyColorAccent(AAccent: TdxChartColorSchemeAccent);
begin
  inherited;

  AAccent.ChangeBackground(FBackgroundInterlacedColor);
  AAccent.ChangeForeground(FGridLinesColor);
  AAccent.ChangeForeground(FMinorGridLinesColor);
  AAccent.ChangeForeground(FAxisColor);
  AAccent.ChangeForeground(FLabelsColor);
end;

procedure TdxChartColorSchemeAxisBasedDiagram.DoAssign(AObject: TdxChartColorSchemeCustomElement);
begin
  inherited;

  if AObject is TdxChartColorSchemeAxisBasedDiagram then
  begin
    FAxisColor := TdxChartColorSchemeAxisBasedDiagram(AObject).AxisColor;
    FLabelsColor := TdxChartColorSchemeAxisBasedDiagram(AObject).LabelsColor;
    FGridLinesColor := TdxChartColorSchemeAxisBasedDiagram(AObject).GridLinesColor;
    FMinorGridLinesColor := TdxChartColorSchemeAxisBasedDiagram(AObject).MinorGridLinesColor;
    FBackgroundInterlacedColor := TdxChartColorSchemeAxisBasedDiagram(AObject).BackgroundInterlacedColor;
  end;
end;

procedure TdxChartColorSchemeAxisBasedDiagram.DoRead(ANode: TdxXMLNode);
begin
  inherited;

  FAxisColor := ANode.ReadSubNodeColor(TdxChartColorSchemeKeywords.AxisColor);
  FLabelsColor := ANode.ReadSubNodeColor(TdxChartColorSchemeKeywords.LabelsColor);
  FGridLinesColor := ANode.ReadSubNodeColor(TdxChartColorSchemeKeywords.GridLinesColor);
  FMinorGridLinesColor := ANode.ReadSubNodeColor(TdxChartColorSchemeKeywords.MinorGridLinesColor);

  FBackgroundColor := ANode.ReadSubNodeColor(TdxChartColorSchemeKeywords.BackgroundColor);
  FBackgroundInterlacedColor := ANode.ReadSubNodeColor(TdxChartColorSchemeKeywords.InterlacedColor);
//  ANode.ReadSubNodeBrush(Background, TdxChartColorSchemeKeywords.BackgroundColor, TdxChartColorSchemeKeywords.BackgroundStyle);
//  ANode.ReadSubNodeBrush(BackgroundInterlaced, TdxChartColorSchemeKeywords.InterlacedColor, TdxChartColorSchemeKeywords.InterlacedFillStyle);
end;

procedure TdxChartColorSchemeAxisBasedDiagram.DoReset;
begin
  inherited;
  FAxisColor := TdxAlphaColors.Default;
  FLabelsColor := TdxAlphaColors.Default;
  FGridLinesColor := TdxAlphaColors.Default;
  FMinorGridLinesColor := TdxAlphaColors.Default;
  FBackgroundInterlacedColor := TdxAlphaColors.Default;
end;

{ TdxChartColorSchemeDiagramXY }

procedure TdxChartColorSchemeDiagramXY.DoApplyColorAccent(AAccent: TdxChartColorSchemeAccent);
begin
  inherited;

  AAccent.ChangeForeground(FAxisTitleColor);
  AAccent.ChangeForeground(FInnerAxisColor);
  AAccent.ChangeForeground(FTextColor);
  AAccent.ChangeForeground(FZoomRectangleBorderColor);
  AAccent.ChangeForeground(FZoomRectangleColor);
end;

procedure TdxChartColorSchemeDiagramXY.DoAssign(AObject: TdxChartColorSchemeCustomElement);
begin
  inherited;

  if AObject is TdxChartColorSchemeDiagramXY then
  begin
    FAxisTitleColor := TdxChartColorSchemeDiagramXY(AObject).AxisTitleColor;
    FInnerAxisColor := TdxChartColorSchemeDiagramXY(AObject).InnerAxisColor;
    FTextColor := TdxChartColorSchemeDiagramXY(AObject).TextColor;
    FZoomRectangleBorderColor := TdxChartColorSchemeDiagramXY(AObject).ZoomRectangleBorderColor;
    FZoomRectangleColor := TdxChartColorSchemeDiagramXY(AObject).ZoomRectangleColor;
  end;
end;

procedure TdxChartColorSchemeDiagramXY.DoRead(ANode: TdxXMLNode);
var
  AInnerAxisColorAlpha: Integer;
begin
  inherited;
  FAxisTitleColor := ANode.ReadSubNodeColor(TdxChartColorSchemeKeywords.AxisTitleColor);
  FTextColor := ANode.ReadSubNodeColor(TdxChartColorSchemeKeywords.TextColor);
  FZoomRectangleBorderColor := ANode.ReadSubNodeColor(TdxChartColorSchemeKeywords.ZoomRectangleBorderColor);
  FZoomRectangleColor := ANode.ReadSubNodeColor(TdxChartColorSchemeKeywords.ZoomRectangleColor);

  FInnerAxisColor := ANode.ReadSubNodeColor(TdxChartColorSchemeKeywords.InnerAxisColor);
  if TryStrToInt(ANode.ReadSubNodeString(TdxChartColorSchemeKeywords.InnerAxisColorAlpha), AInnerAxisColorAlpha) then
  begin
    with dxAlphaColorToRGBQuad(FInnerAxisColor) do
      FInnerAxisColor := dxMakeAlphaColor(MulDiv(rgbReserved, AInnerAxisColorAlpha, MaxByte), rgbRed, rgbGreen, rgbBlue);
  end;
end;

procedure TdxChartColorSchemeDiagramXY.DoReset;
begin
  inherited;
  FAxisTitleColor := TdxAlphaColors.Default;
  FInnerAxisColor := TdxAlphaColors.Default;
  FTextColor := TdxAlphaColors.Default;
  FZoomRectangleBorderColor := TdxAlphaColors.Default;
  FZoomRectangleColor := TdxAlphaColors.Default;
end;

{ TdxChartColorSchemeLegend }

procedure TdxChartColorSchemeLegend.DoApplyColorAccent(AAccent: TdxChartColorSchemeAccent);
begin
  inherited;
  AAccent.ChangeForeground(FTextColor);
end;

procedure TdxChartColorSchemeLegend.DoAssign(AObject: TdxChartColorSchemeCustomElement);
begin
  inherited;
  if AObject is TdxChartColorSchemeLegend then
  begin
    FTextColor := TdxChartColorSchemeLegend(AObject).TextColor;
    FPadding := TdxChartColorSchemeLegend(AObject).Padding;
  end;
end;

procedure TdxChartColorSchemeLegend.DoRead(ANode: TdxXMLNode);
begin
  inherited;
  FPadding := ANode.ReadSubNodeRectangle(TdxChartColorSchemeKeywords.Padding);
  FTextColor := ANode.ReadSubNodeColor(TdxChartColorSchemeKeywords.TextColor);
  FBackgroundColor := ANode.ReadSubNodeColor(TdxChartColorSchemeKeywords.BackgroundColor);
//  ANode.ReadSubNodeBrush(Background, TdxChartColorSchemeKeywords.BackgroundColor, TdxChartColorSchemeKeywords.BackgroundStyle);
end;

procedure TdxChartColorSchemeLegend.DoReset;
begin
  inherited;
  FPadding := dxNullRectF;
  FTextColor := TdxAlphaColors.Default;
end;

{ TdxChartColorSchemeTextAnnotation }

procedure TdxChartColorSchemeTextAnnotation.DoApplyColorAccent(AAccent: TdxChartColorSchemeAccent);
begin
  inherited;
  AAccent.ChangeForeground(FTextColor);
end;

procedure TdxChartColorSchemeTextAnnotation.DoAssign(AObject: TdxChartColorSchemeCustomElement);
begin
  inherited;
  if AObject is TdxChartColorSchemeTextAnnotation then
    FTextColor := TdxChartColorSchemeTextAnnotation(AObject).TextColor
end;

procedure TdxChartColorSchemeTextAnnotation.DoRead(ANode: TdxXMLNode);
begin
  inherited;
  FTextColor := ANode.ReadSubNodeColor(TdxChartColorSchemeKeywords.TextColor);
end;

procedure TdxChartColorSchemeTextAnnotation.DoReset;
begin
  inherited;
  FTextColor := TdxAlphaColors.Default;
end;

{ TdxChartColorSchemeBarSeriesView }

procedure TdxChartColorSchemeBarSeriesView.DoAssign(AObject: TdxChartColorSchemeCustomElement);
begin
  inherited;
  if AObject is TdxChartColorSchemeBarSeriesView then
    FShowBorder := TdxChartColorSchemeBarSeriesView(AObject).ShowBorder;
end;

procedure TdxChartColorSchemeBarSeriesView.DoRead(ANode: TdxXMLNode);
begin
  inherited;
  FShowBorder := ANode.ReadSubNodeBoolean(TdxChartColorSchemeKeywords.ShowBorder);
end;

procedure TdxChartColorSchemeBarSeriesView.DoReset;
begin
  inherited;
  FShowBorder := True;
end;

{ TdxChartColorSchemeLabel }

procedure TdxChartColorSchemeLabel.DoApplyColorAccent(AAccent: TdxChartColorSchemeAccent);
begin
  inherited;
  AAccent.ChangeForeground(FTextColor);
end;

procedure TdxChartColorSchemeLabel.DoAssign(AObject: TdxChartColorSchemeCustomElement);
begin
  inherited;

  if AObject is TdxChartColorSchemeSeriesLabel then
  begin
    FShowBorder := TdxChartColorSchemeSeriesLabel(AObject).ShowBorder;
    FTextColor := TdxChartColorSchemeSeriesLabel(AObject).TextColor;
  end;
end;

procedure TdxChartColorSchemeLabel.DoRead(ANode: TdxXMLNode);
begin
  inherited;
//  ANode.ReadSubNodeBrush(Background, TdxChartColorSchemeKeywords.BackColor, '');
  FBackgroundColor := ANode.ReadSubNodeColor(TdxChartColorSchemeKeywords.BackColor);
  FShowBorder := ANode.ReadSubNodeBoolean(TdxChartColorSchemeKeywords.ShowBorder);
  FTextColor := ANode.ReadSubNodeColor(TdxChartColorSchemeKeywords.TextColor);
end;

procedure TdxChartColorSchemeLabel.DoReset;
begin
  inherited;
  FTextColor := TdxAlphaColors.Default;
  FShowBorder := True;
end;

{ TdxChartColorSchemeSeriesLabel }

procedure TdxChartColorSchemeSeriesLabel.DoApplyColorAccent(AAccent: TdxChartColorSchemeAccent);
begin
  inherited;
  AAccent.ChangeForeground(FConnectorColor);
end;

procedure TdxChartColorSchemeSeriesLabel.DoAssign(AObject: TdxChartColorSchemeCustomElement);
begin
  inherited;

  if AObject is TdxChartColorSchemeSeriesLabel then
  begin
    FConnectorColor := TdxChartColorSchemeSeriesLabel(AObject).ConnectorColor;
    FShowBubbleConnector := TdxChartColorSchemeSeriesLabel(AObject).ShowBubbleConnector;
    FShowConnector := TdxChartColorSchemeSeriesLabel(AObject).ShowConnector;
  end;
end;

procedure TdxChartColorSchemeSeriesLabel.DoRead(ANode: TdxXMLNode);
begin
  inherited;

  FConnectorColor := ANode.ReadSubNodeColor(TdxChartColorSchemeKeywords.ConnectorColor);
  FShowBubbleConnector := ANode.ReadSubNodeBoolean(TdxChartColorSchemeKeywords.ShowBubbleConnector);
  FShowConnector := ANode.ReadSubNodeBoolean(TdxChartColorSchemeKeywords.ShowConnector);
end;

procedure TdxChartColorSchemeSeriesLabel.DoReset;
begin
  inherited;
  FConnectorColor := TdxAlphaColors.Default;
  FShowBubbleConnector := True;
  FShowConnector := True;
end;

{ TdxChartColorSchemeConstantLine }

procedure TdxChartColorSchemeConstantLine.DoApplyColorAccent(AAccent: TdxChartColorSchemeAccent);
begin
  inherited;
  AAccent.ChangeForeground(FColor);
  AAccent.ChangeForeground(FTitleColor);
end;

procedure TdxChartColorSchemeConstantLine.DoAssign(AObject: TdxChartColorSchemeCustomElement);
begin
  inherited;
  if AObject is TdxChartColorSchemeConstantLine then
  begin
    FColor := TdxChartColorSchemeConstantLine(AObject).Color;
    FDashStyle := TdxChartColorSchemeConstantLine(AObject).DashStyle;
    FTitleColor := TdxChartColorSchemeConstantLine(AObject).TitleColor;
  end;
end;

procedure TdxChartColorSchemeConstantLine.DoRead(ANode: TdxXMLNode);
var
  ADashStyle: string;
begin
  inherited;
  FColor := ANode.ReadSubNodeColor(TdxChartColorSchemeKeywords.Color);
  FTitleColor := ANode.ReadSubNodeColor(TdxChartColorSchemeKeywords.TitleColor);

  ADashStyle := ANode.ReadSubNodeString(TdxChartColorSchemeKeywords.DashStyle);
  if dxSameText(ADashStyle, TdxChartColorSchemeKeywords.Dot) then
    FDashStyle := gppsDot
  else if dxSameText(ADashStyle, TdxChartColorSchemeKeywords.Dash) then
    FDashStyle := gppsDash
  else
    FDashStyle := gppsSolid;
end;

procedure TdxChartColorSchemeConstantLine.DoReset;
begin
  inherited;
  FColor := TdxAlphaColors.Default;
  FDashStyle := gppsSolid;
  FTitleColor := TdxAlphaColors.Default;
end;

{ TdxChartColorSchemePaneTitle }

procedure TdxChartColorSchemePaneTitle.DoApplyColorAccent(AAccent: TdxChartColorSchemeAccent);
begin
  inherited;
  AAccent.ChangeForeground(FTextColor);
  AAccent.ChangeForeground(FTextColorHot);
end;

procedure TdxChartColorSchemePaneTitle.DoAssign(AObject: TdxChartColorSchemeCustomElement);
begin
  inherited;
  if AObject is TdxChartColorSchemePaneTitle then
  begin
    FArrowOffset := TdxChartColorSchemePaneTitle(AObject).ArrowOffset;
    FFontSize := TdxChartColorSchemePaneTitle(AObject).FontSize;
    FFontStyle := TdxChartColorSchemePaneTitle(AObject).FontStyle;
    FMargins := TdxChartColorSchemePaneTitle(AObject).Margins;
    FTextColor := TdxChartColorSchemePaneTitle(AObject).TextColor;
    FTextColorHot := TdxChartColorSchemePaneTitle(AObject).TextColorHot;
  end;
end;

procedure TdxChartColorSchemePaneTitle.DoRead(ANode: TdxXMLNode);
begin
  inherited;

  FTextColor := ANode.ReadSubNodeColor(TdxChartColorSchemeKeywords.ForeColor);
  FTextColorHot := ANode.ReadSubNodeColor(TdxChartColorSchemeKeywords.ForeColorHot);
  FMargins := ANode.ReadSubNodeRectangle(TdxChartColorSchemeKeywords.ContentMargins);
  FFontSize := Round(ANode.ReadSubNodeFloat(TdxChartColorSchemeKeywords.FontSize));
  FArrowOffset.X := ANode.ReadSubNodeFloat(TdxChartColorSchemeKeywords.ArrowOffsetX);
  FArrowOffset.Y := ANode.ReadSubNodeFloat(TdxChartColorSchemeKeywords.ArrowOffsetY);

  if ANode.ReadSubNodeBoolean(TdxChartColorSchemeKeywords.Bold) then
    FFontStyle := [fsBold]
  else
    FFontStyle := [];
end;

procedure TdxChartColorSchemePaneTitle.DoReset;
begin
  inherited;
  FArrowOffset := dxNullPointF;
  FFontSize := 8;
  FFontStyle := [];
  FMargins := dxNullRectF;
  FTextColor := TdxAlphaColors.Default;
  FTextColorHot := TdxAlphaColors.Default;
end;

{ TdxChartColorSchemePaletteEntry }

constructor TdxChartColorSchemePaletteEntry.Create(const AColor, AColor2: TdxAlphaColor);
begin
  FColor := AColor;
  FColor2 := AColor2;
end;

function TdxChartColorSchemePaletteEntry.Clone: TdxChartColorSchemePaletteEntry;
begin
  Result := TdxChartColorSchemePaletteEntry.Create(FColor, FColor2);
end;

procedure TdxChartColorSchemePaletteEntry.DoApplyColorAccent(AAccent: TdxChartColorSchemeAccent);
begin
  AAccent.ChangeAccent(FColor);
  AAccent.ChangeAccent(FColor2);
end;

{ TdxChartColorSchemePalette }

constructor TdxChartColorSchemePalette.Create;
begin
  FList := TcxObjectList.Create;
end;

destructor TdxChartColorSchemePalette.Destroy;
begin
  FreeAndNil(FList);
  inherited;
end;

procedure TdxChartColorSchemePalette.Add(AColor1, AColor2: TdxAlphaColor);
begin
  FList.Add(TdxChartColorSchemePaletteEntry.Create(AColor1, AColor2));
end;

function TdxChartColorSchemePalette.Clone: TdxChartColorSchemePalette;
begin
  Result := TdxChartColorSchemePalette.Create;
  Result.Assign(Self);
end;

function TdxChartColorSchemePalette.GetByElementIndex(AElementIndex: Integer): TdxChartColorSchemePaletteEntry;
begin
  Result := Items[AElementIndex mod Count];
end;

procedure TdxChartColorSchemePalette.LoadFromFile(const AFileName: string);
var
  AStream: TStream;
begin
  AStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  try
    LoadFromStream(AStream);
  finally
    AStream.Free;
  end;
end;

procedure TdxChartColorSchemePalette.LoadFromResource(const AInstance: THandle; const AName: string; AType: PChar);
var
  AStream: TStream;
begin
  AStream := TResourceStream.Create(AInstance, AName, AType);
  try
    LoadFromStream(AStream);
  finally
    AStream.Free;
  end;
end;

procedure TdxChartColorSchemePalette.LoadFromStream(const AStream: TStream);
var
  ADocument: TdxXMLDocument;
  ANode: TdxXMLNode;
begin
  DoReset;
  ADocument := TdxXMLDocument.Create;
  try
    ADocument.LoadFromStream(AStream);
    if ADocument.FindChild(TdxChartColorSchemeKeywords.Palette, ANode) then
      DoRead(ANode);
  finally
    ADocument.Free;
  end;
end;

procedure TdxChartColorSchemePalette.DoApplyColorAccent(AAccent: TdxChartColorSchemeAccent);
var
  I: Integer;
begin
  inherited;
  for I := 0 to Count - 1 do
    Items[I].DoApplyColorAccent(AAccent);
end;

procedure TdxChartColorSchemePalette.DoAssign(AObject: TdxChartColorSchemeCustomElement);
var
  I: Integer;
begin
  inherited;
  if AObject is TdxChartColorSchemePalette then
  begin
    FList.Clear;
    FList.Capacity := TdxChartColorSchemePalette(AObject).Count;
    for I := 0 to TdxChartColorSchemePalette(AObject).Count - 1 do
      FList.Add(TdxChartColorSchemePalette(AObject).Items[I].Clone);
  end;
end;

procedure TdxChartColorSchemePalette.DoRead(ANode: TdxXMLNode);
var
  ASubNode: TdxXMLNode;
begin
  inherited;
  if ANode.FindChild(TdxChartColorSchemeKeywords.Name, ASubNode) then
    FName := ASubNode.TextAsString;
  if ANode.FindChild(TdxChartColorSchemeKeywords.Items, ASubNode) then
  begin
    ASubNode := ASubNode.First;
    while ASubNode <> nil do
    begin
      if ASubNode.Name = TdxChartColorSchemeKeywords.Entry then
        Add(ASubNode.ReadSubNodeColor(TdxChartColorSchemeKeywords.Color), ASubNode.ReadSubNodeColor(TdxChartColorSchemeKeywords.Color2));
      ASubNode := ASubNode.Next;
    end;
  end;
  GenerateColorShades;
end;

procedure TdxChartColorSchemePalette.DoReset;
begin
  inherited;
  FList.Clear;
end;

procedure TdxChartColorSchemePalette.GenerateColorShades;

  function GenerateColorShade(const AColor: TdxAlphaColor; ALightnessDelta: Single): TdxAlphaColor;
  var
    AHSL: TdxHSL;
  begin
    AHSL := TdxColorUtils.RGBToHSL(dxAlphaColorToRGBQuad(AColor));
    AHSL.L := EnsureRange(AHSL.L + ALightnessDelta, TdxColorPaletteBuilder.MinLightness, TdxColorPaletteBuilder.MaxLightness);
    Result := dxRGBQuadToAlphaColor(TdxColorUtils.HSLToRGB(AHSL));
  end;

  procedure GenerateColorShadesCore(ABaseItem: TdxChartColorSchemePaletteEntry; ALightnessDelta: Single);
  begin
    Add(GenerateColorShade(ABaseItem.Color, ALightnessDelta), GenerateColorShade(ABaseItem.Color2, ALightnessDelta));
  end;

var
  ACount: Integer;
  I: Integer;
begin
  ACount := FList.Count;
  for I := 0 to ACount - 1 do
    GenerateColorShadesCore(Items[I], -TdxColorPaletteBuilder.DefaultLightnessDelta);
  for I := 0 to ACount - 1 do
    GenerateColorShadesCore(Items[I], TdxColorPaletteBuilder.DefaultLightnessDelta);
end;

function TdxChartColorSchemePalette.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TdxChartColorSchemePalette.GetItem(Index: Integer): TdxChartColorSchemePaletteEntry;
begin
  Result := TdxChartColorSchemePaletteEntry(FList[Index]);
end;

{ TdxChartColorSchemePaletteRepository }

class procedure TdxChartColorSchemePaletteRepository.CheckInitialized;
begin
  if FRepository = nil then
  begin
    FRepository := TObjectDictionary<string, TdxChartColorSchemePalette>.Create([doOwnsValues]);
    EnumResourceNames(HInstance, PChar(ResourceType), @EnumProc, 0);
  end;
end;

class procedure TdxChartColorSchemePaletteRepository.Finalize;
begin
  FreeAndNil(FRepository);
end;

class function TdxChartColorSchemePaletteRepository.Get(const AName: string): TdxChartColorSchemePalette;
begin
  CheckInitialized;
  if not FRepository.TryGetValue(AName, Result) then
    Result := Default;
end;

class function TdxChartColorSchemePaletteRepository.GetDefault: TdxChartColorSchemePalette;
begin
  CheckInitialized;
  Result := FRepository.Items[DefaultName];
end;

class function TdxChartColorSchemePaletteRepository.EnumProc(
  hModule: HMODULE; AType: LPCTSTR; AName: LPTSTR; AData: Pointer): Boolean;
var
  APalette: TdxChartColorSchemePalette;
  AResourceName: string;
begin
  AResourceName := AName;
  if StartsText(ResourcePrefix, AResourceName) then
  begin
    APalette := TdxChartColorSchemePalette.Create;
    APalette.LoadFromResource(hModule, AResourceName, AType);
    FRepository.Add(APalette.Name, APalette);
  end;
  Result := True;
end;

{ TdxChartColorScheme }

constructor TdxChartColorScheme.Create(const AName: string);
begin
  inherited Create;
  FName := AName;
  FChart := TdxChartColorSchemeChart.Create;
  FLegend := TdxChartColorSchemeLegend.Create;
  FSeriesColors := TdxChartColorSchemePalette.Create;
  FConstantLine := TdxChartColorSchemeConstantLine.Create;
  FDiagramXY := TdxChartColorSchemeDiagramXY.Create;
  FTextAnnotation := TdxChartColorSchemeTextAnnotation.Create;
  FImageAnnotation := TdxChartColorSchemeAnnotation.Create;
  FAreaSeriesView := TdxChartColorSchemeView.Create;
  FBarSeriesView := TdxChartColorSchemeBarSeriesView.Create;
  FPieSeriesView := TdxChartColorSchemeView.Create;
  FStrip := TdxChartColorSchemeVisualElement.Create;
  FMarker := TdxChartColorSchemeVisualElement.Create;
  FSeriesLabel := TdxChartColorSchemeSeriesLabel.Create;
  FStackedBarTotalLabel := TdxChartColorSchemeLabel.Create;
  FPieTotalLabel := TdxChartColorSchemeLabel.Create;
  FPaneTitle := TdxChartColorSchemePaneTitle.Create;
end;

destructor TdxChartColorScheme.Destroy;
begin
  FreeAndNil(FAreaSeriesView);
  FreeAndNil(FBarSeriesView);
  FreeAndNil(FPieSeriesView);
  FreeAndNil(FImageAnnotation);
  FreeAndNil(FTextAnnotation);
  FreeAndNil(FPieTotalLabel);
  FreeAndNil(FSeriesLabel);
  FreeAndNil(FStackedBarTotalLabel);
  FreeAndNil(FSeriesColors);
  FreeAndNil(FConstantLine);
  FreeAndNil(FDiagramXY);
  FreeAndNil(FPaneTitle);
  FreeAndNil(FLegend);
  FreeAndNil(FChart);
  FreeAndNil(FStrip);
  FreeAndNil(FMarker);
  inherited;
end;

procedure TdxChartColorScheme.ApplyColorAccent(ABackgroundColor, AForegroundColor, AAccentColor: TdxAlphaColor);
var
  AAccent: TdxChartColorSchemeAccent;
begin
  AAccent := TdxChartColorSchemeAccent.Create(ABackgroundColor, AForegroundColor, AAccentColor);
  try
    DoApplyColorAccent(AAccent);
  finally
    AAccent.Free;
  end;
  Chart.FBackgroundColor := ABackgroundColor;
  DiagramXY.FBackgroundColor := ABackgroundColor;
end;

procedure TdxChartColorScheme.LoadFromFile(const AFileName: string);
var
  AStream: TStream;
begin
  AStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  try
    LoadFromStream(AStream);
  finally
    AStream.Free;
  end;
end;

procedure TdxChartColorScheme.LoadFromStream(const AStream: TStream);
var
  ADocument: TdxXMLDocument;
  ANode: TdxXMLNode;
begin
  DoReset;
  ADocument := TdxXMLDocument.Create;
  try
    ADocument.LoadFromStream(AStream);
    if ADocument.FindChild(TdxChartColorSchemeKeywords.Appearance, ANode) then
      DoRead(ANode);
  finally
    ADocument.Free;
  end;
end;

procedure TdxChartColorScheme.LoadFromResource(const AInstance: THandle; const AName: string; AType: PChar);
var
  AStream: TStream;
begin
  AStream := TResourceStream.Create(AInstance, AName, AType);
  try
    LoadFromStream(AStream);
  finally
    AStream.Free;
  end;
end;

procedure TdxChartColorScheme.DoApplyColorAccent(AAccent: TdxChartColorSchemeAccent);
begin
  inherited;
  Chart.DoApplyColorAccent(AAccent);
  Legend.DoApplyColorAccent(AAccent);
  DiagramXY.DoApplyColorAccent(AAccent);
  TextAnnotation.DoApplyColorAccent(AAccent);
  ImageAnnotation.DoApplyColorAccent(AAccent);
  AreaSeriesView.DoApplyColorAccent(AAccent);
  PieSeriesView.DoApplyColorAccent(AAccent);
  BarSeriesView.DoApplyColorAccent(AAccent);
  Marker.DoApplyColorAccent(AAccent);
  SeriesLabel.DoApplyColorAccent(AAccent);
  StackedBarTotalLabel.DoApplyColorAccent(AAccent);
  PieTotalLabel.DoApplyColorAccent(AAccent);
  PaneTitle.DoApplyColorAccent(AAccent);
  ConstantLine.DoApplyColorAccent(AAccent);
  SeriesColors.DoApplyColorAccent(AAccent);
end;

procedure TdxChartColorScheme.DoAssign(AObject: TdxChartColorSchemeCustomElement);
begin
  inherited;

  if AObject is TdxChartColorScheme then
  begin
    Chart.Assign(TdxChartColorScheme(AObject).Chart);
    Legend.Assign(TdxChartColorScheme(AObject).Legend);
    DiagramXY.Assign(TdxChartColorScheme(AObject).DiagramXY);
    TextAnnotation.Assign(TdxChartColorScheme(AObject).TextAnnotation);
    ImageAnnotation.Assign(TdxChartColorScheme(AObject).ImageAnnotation);
    AreaSeriesView.Assign(TdxChartColorScheme(AObject).AreaSeriesView);
    ConstantLine.Assign(TdxChartColorScheme(AObject).ConstantLine);
    PieSeriesView.Assign(TdxChartColorScheme(AObject).PieSeriesView);
    BarSeriesView.Assign(TdxChartColorScheme(AObject).BarSeriesView);
    Marker.Assign(TdxChartColorScheme(AObject).Marker);
    SeriesLabel.Assign(TdxChartColorScheme(AObject).SeriesLabel);
    StackedBarTotalLabel.Assign(TdxChartColorScheme(AObject).StackedBarTotalLabel);
    PieTotalLabel.Assign(TdxChartColorScheme(AObject).PieTotalLabel);
    PaneTitle.Assign(TdxChartColorScheme(AObject).PaneTitle);
    SeriesColors.Assign(TdxChartColorScheme(AObject).SeriesColors);
  end;
end;

procedure TdxChartColorScheme.DoRead(ANode: TdxXMLNode);
var
  AValue: TdxXMLNode;
begin
  if ANode.FindChild(TdxChartColorSchemeKeywords.PaletteName, AValue) then
    SetSeriesColorsReference(TdxChartColorSchemePaletteRepository.Get(AValue.TextAsString));

  ANode.ReadSubNodeObject(Chart, TdxChartColorSchemeKeywords.Chart);
  ANode.ReadSubNodeObject(Legend, TdxChartColorSchemeKeywords.Legend);
  ANode.ReadSubNodeObject(DiagramXY, TdxChartColorSchemeKeywords.XYDiagram);
  ANode.ReadSubNodeObject(TextAnnotation, TdxChartColorSchemeKeywords.TextAnnotation);
  ANode.ReadSubNodeObject(ImageAnnotation, TdxChartColorSchemeKeywords.ImageAnnotation);
  ANode.ReadSubNodeObject(Strip, TdxChartColorSchemeKeywords.Strip);
  ANode.ReadSubNodeObject(AreaSeriesView, TdxChartColorSchemeKeywords.AreaSeriesView);
  ANode.ReadSubNodeObject(PieSeriesView, TdxChartColorSchemeKeywords.PieSeriesView);
  ANode.ReadSubNodeObject(BarSeriesView, TdxChartColorSchemeKeywords.BarSeriesView);
  ANode.ReadSubNodeObject(Marker, TdxChartColorSchemeKeywords.Marker);
  ANode.ReadSubNodeObject(SeriesLabel, TdxChartColorSchemeKeywords.SeriesLabel2D);
  ANode.ReadSubNodeObject(StackedBarTotalLabel, TdxChartColorSchemeKeywords.StackedBarTotalLabel);
  ANode.ReadSubNodeObject(PieTotalLabel, TdxChartColorSchemeKeywords.PieTotalLabel);
  ANode.ReadSubNodeObject(PaneTitle, TdxChartColorSchemeKeywords.PaneTitle);
  ANode.ReadSubNodeObject(ConstantLine, TdxChartColorSchemeKeywords.ConstantLine);
end;

procedure TdxChartColorScheme.DoReset;
begin
  inherited;
  Chart.DoReset;
  Legend.DoReset;
  DiagramXY.DoReset;
  TextAnnotation.DoReset;
  ImageAnnotation.DoReset;
  AreaSeriesView.DoReset;
  PieSeriesView.DoReset;
  BarSeriesView.DoReset;
  Marker.DoReset;
  SeriesLabel.DoReset;
  StackedBarTotalLabel.DoReset;
  PieTotalLabel.DoReset;
  PaneTitle.DoReset;
  ConstantLine.DoReset;
  SetSeriesColorsReference(TdxChartColorSchemePaletteRepository.Default);
end;

procedure TdxChartColorScheme.SetSeriesColorsReference(APalette: TdxChartColorSchemePalette);
begin
  if FSeriesColors <> APalette then
  begin
    FreeAndNil(FSeriesColors);
    FSeriesColors := APalette.Clone;
  end;
end;

{ TdxChartColorSchemeRepository }

class function TdxChartColorSchemeRepository.Get(const AName: string): TdxChartColorScheme;
var
  I: Integer;
begin
  CheckInitialized;
  for I := 0 to Count - 1 do
  begin
    if dxSameText(Items[I].Name, AName) then
      Exit(Items[I]);
  end;
  raise EArgumentException.CreateFmt('The %s appearance schema was not found in repository', [AName]);
end;

class procedure TdxChartColorSchemeRepository.CheckInitialized;
begin
  if FRepository = nil then
  begin
    FRepository := TcxObjectList.Create;
    EnumResourceNames(HInstance, PChar(ResourceType), @EnumProc, 0);
    FDefault := Get(DefaultName);
  end;
end;

class procedure TdxChartColorSchemeRepository.Finalize;
begin
  FreeAndNil(FRepository);
end;

class function TdxChartColorSchemeRepository.GetCount: Integer;
begin
  CheckInitialized;
  Result := FRepository.Count;
end;

class function TdxChartColorSchemeRepository.GetDefault: TdxChartColorScheme;
begin
  CheckInitialized;
  Result := FDefault;
end;

class function TdxChartColorSchemeRepository.GetItem(Index: Integer): TdxChartColorScheme;
begin
  CheckInitialized;
  Result := TdxChartColorScheme(FRepository[Index]);
end;

class function TdxChartColorSchemeRepository.EnumProc(hModule: HMODULE; AType: LPCTSTR; AName: LPTSTR; AData: Pointer): Boolean;
var
  AAppearance: TdxChartColorScheme;
  AResourceName: string;
begin
  AResourceName := AName;
  if StartsText(ResourcePrefix, AResourceName) then
  begin
    AAppearance := TdxChartColorScheme.Create(Copy(AResourceName, Length(ResourcePrefix) + 1, MaxInt));
    AAppearance.LoadFromResource(hModule, AResourceName, AType);
    FRepository.Add(AAppearance);
  end;
  Result := True;
end;


initialization

finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxChartColorSchemePaletteRepository.Finalize;
  TdxChartColorSchemeRepository.Finalize;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
