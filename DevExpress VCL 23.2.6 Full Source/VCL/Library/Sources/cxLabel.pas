{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressEditors                                           }
{                                                                    }
{           Copyright (c) 1998-2024 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSEDITORS AND ALL                }
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

unit cxLabel;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Types, Variants,
  Windows, Classes, Controls, Forms, Graphics, Messages, SysUtils, cxClasses,
  Generics.Defaults, Generics.Collections,
  dxCore, cxContainer, cxControls, cxGraphics, cxDataUtils, dxGDIPlusClasses,
  cxEdit, cxExtEditConsts, cxTextEdit, cxVariants, cxLookAndFeelPainters, cxAccessibility,
  cxLookAndFeels;

type
  TcxLabelEffect = (cxleNormal, cxleFun, cxleExtrude, cxleCool);
  TcxLabelLineAlignment = (cxllaTop, cxllaCenter, cxllaBottom);
  TcxLabelStyle = (cxlsNormal, cxlsRaised, cxlsLowered, cxlsOutLine);
  TcxLabelOrientation = (cxoLeft, cxoRight, cxoTop, cxoBottom, cxoLeftTop,
    cxoLeftBottom, cxoRightTop, cxoRightBottom);

  TcxCustomLabel = class;

  { TcxLabelEditStyle }

  TcxLabelEditStyle = class(TcxEditStyle)
  protected
    function DefaultBorderStyle: TcxContainerBorderStyle; override;
    function DefaultHotTrack: Boolean; override;
  end;

  { TcxLabelLineOptions }

  TcxLabelLineOptions = class(TPersistent)
  private
    FAlignment: TcxLabelLineAlignment;
    FInnerColor: TColor;
    FOnChanged: TNotifyEvent;
    FOuterColor: TColor;
    FVisible: Boolean;
    function GetIsCustomColorsAssigned: Boolean;
    procedure SetAlignment(AValue: TcxLabelLineAlignment);
    procedure SetInnerColor(AValue: TColor);
    procedure SetOuterColor(AValue: TColor);
    procedure SetVisible(AValue: Boolean);
  protected
    procedure Changed; virtual;

    property IsCustomColorsAssigned: Boolean read GetIsCustomColorsAssigned;
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
  public
    constructor Create; virtual;
    procedure Assign(Source: TPersistent); override;
  published
    property Alignment: TcxLabelLineAlignment read FAlignment write SetAlignment default cxllaCenter;
    property InnerColor: TColor read FInnerColor write SetInnerColor default clDefault;
    property OuterColor: TColor read FOuterColor write SetOuterColor default clDefault;
    property Visible: Boolean read FVisible write SetVisible default False;
  end;

  { TcxCustomLabelViewInfo }

  TcxCustomLabelViewInfo = class(TcxCustomTextEditViewInfo)
  private
    FAlignment: TcxEditAlignment;
    FAngle: Integer;
    FDepth: Word;
    FDepthDeltaSize: TSize;
    FGlyph: TBitmap;
    FLabelEffect: TcxLabelEffect;
    FLabelStyle: TcxLabelStyle;
    FLabelStyleOffset: Integer;
    FLineInnerColor: TColor;
    FLineOrientation: TdxOrientation;
    FLineOuterColor: TColor;
    FLineRect: TRect;
    FOrientation: TcxLabelOrientation;
    FPenWidth: Integer;
    FShadowedColor: TColor;
    FWordWrap: Boolean;

    function HasEffects: Boolean;
  protected
    procedure DrawFlatButtonBorder(ACanvas: TcxCanvas; AButtonViewInfo: TcxEditButtonViewInfo;
      var ARect: TRect; out AContentRect: TRect; var APenColor, ABrushColor: TColor); override;
    procedure DrawNativeButtonBackground(ACanvas: TcxCanvas;
      AButtonViewInfo: TcxEditButtonViewInfo; const ARect: TRect); override;
    procedure DrawLookAndFeelButtonBackground(ACanvas: TcxCanvas;
      AButtonViewInfo: TcxEditButtonViewInfo; const ARect: TRect); override;
    procedure DrawUltraFlatButtonBorder(ACanvas: TcxCanvas; AButtonViewInfo: TcxEditButtonViewInfo;
      AIsOffice11Style: Boolean; var ARect: TRect; var AContentRect: TRect; out APenColor, ABrushColor: TColor); override;
  protected
    FTextSizes: array[Boolean] of TdxCachedSize;

    function GetSkinnedTextColor(AKind: TcxEditStateColorKind): TColor; override;
    procedure InternalDrawBackground(ACanvas: TcxCanvas; const R: TRect); virtual;
    function IsPaintOnGlass: Boolean;
    procedure SetGlyph(AGlyph: TGraphic);

    property Alignment: TcxEditAlignment read FAlignment write FAlignment;
    property Angle: Integer read FAngle write FAngle;
    property Depth: Word read FDepth write FDepth;
    property DepthDeltaSize: TSize read FDepthDeltaSize write FDepthDeltaSize;
    property LabelEffect: TcxLabelEffect read FLabelEffect write FLabelEffect;
    property LabelStyle: TcxLabelStyle read FLabelStyle write FLabelStyle;
    property LabelStyleOffset: Integer read FLabelStyleOffset write FLabelStyleOffset;
    property LineInnerColor: TColor read FLineInnerColor write FLineInnerColor;
    property LineOrientation: TdxOrientation read FLineOrientation write FLineOrientation;
    property LineOuterColor: TColor read FLineOuterColor write FLineOuterColor;
    property LineRect: TRect read FLineRect write FLineRect;
    property Orientation: TcxLabelOrientation read FOrientation write FOrientation;
    property PenWidth: Integer read FPenWidth write FPenWidth;
    property ShadowedColor: TColor read FShadowedColor write FShadowedColor;
    property WordWrap: Boolean read FWordWrap write FWordWrap;
  public
    FocusRect: TRect;
    HasGlyph: Boolean;
    LeftTop: TPoint;
    ShowAccelChar: Boolean;

    constructor Create; override;
    destructor Destroy; override;
    procedure Offset(DX, DY: Integer); override;
    procedure Paint(ACanvas: TcxCanvas); override;
    procedure DrawLabel(ACanvas: TcxCanvas); virtual;
  end;

  { TcxCustomLabelViewData }

  TcxCustomLabelProperties = class;

  TcxCustomLabelViewData = class(TcxCustomEditViewData)
  private
    function GetLineOptions: TcxLabelLineOptions;
    function GetProperties: TcxCustomLabelProperties;
    function GetShowEndEllipsis: Boolean;
    procedure CalculateLabelViewInfoProps(AViewInfo: TcxCustomEditViewInfo);
  protected
    procedure AdjustPadding(var APadding: TdxPadding); override;
    function CalculateLabelStyleOffset(ACanvas: TcxCanvas): Integer; virtual;
    function CalculateLineRect(var ATextRect: TRect; const ABounds: TRect;
      AAlignment: TcxLabelLineAlignment; AVisible: Boolean; ALineHeight: Integer;
      AOrientation: TdxOrientation): TRect; virtual;
    function CalculateTextRect(ACanvas: TcxCanvas; AViewInfo: TcxCustomLabelViewInfo; ARealAngle: Integer): TRect; virtual;
    function CalculateTextSize(ACanvas: TcxCanvas; AViewInfo: TcxCustomLabelViewInfo; const R: TRect; const AText: string; AFixedWidth: Boolean): TSize; virtual;
    procedure CalculateViewParams(ACanvas: TcxCanvas; AViewInfo: TcxCustomLabelViewInfo);
    function GetDrawTextFlags: Integer; virtual;
    function GetIsEditClass: Boolean;
    function GetLineHeight: Integer; virtual;
    function CalculatePaintOptions: TcxEditPaintOptions; override;
    function InternalEditValueToDisplayText(AEditValue: TcxEditValue): string; override;
    function IsLineVisible(ARealAngle: Integer): Boolean; virtual;
  public
    procedure Calculate(ACanvas: TcxCanvas; const ABounds: TRect; const P: TPoint;
      Button: TcxMouseButton; Shift: TShiftState; AViewInfo: TcxCustomEditViewInfo;
      AIsMouseEvent: Boolean); override;
    procedure EditValueToDrawValue(const AEditValue: TcxEditValue;
      AViewInfo: TcxCustomEditViewInfo); override;
    function GetEditContentSize(ACanvas: TcxCanvas; const AEditValue: TcxEditValue;
      const AEditSizeProperties: TcxEditSizeProperties; AErrorData: TcxEditValidateInfo = nil): TSize; override;

    property LineOptions: TcxLabelLineOptions read GetLineOptions;
    property Properties: TcxCustomLabelProperties read GetProperties;
    property ShowEndEllipsis: Boolean read GetShowEndEllipsis;
  end;

  { TcxCustomLabelProperties }

  TcxCustomLabelProperties = class(TcxCustomEditProperties)
  private
    FAngle: Integer;
    FDepth: Word;
    FGlyph: TdxSmartGlyph;
    FLabelEffect: TcxLabelEffect;
    FLabelStyle: TcxLabelStyle;
    FLineOptions: TcxLabelLineOptions;
    FOrientation: TcxLabelOrientation;
    FPenWidth: Integer;
    FShadowedColor: TColor;
    FShowAccelChar: Boolean;
    FShowEndEllipsis: Boolean;
    FWordWrap: Boolean;
    procedure SetAngle(Value: Integer);
    procedure SetDepth(Value : Word);
    procedure SetLabelEffect(Value : TcxLabelEffect);
    procedure SetLabelStyle(Value : TcxLabelStyle);
    procedure SetLineOptions(AValue: TcxLabelLineOptions);
    procedure SetOrientation(Value : TcxLabelOrientation);
    procedure SetPenWidth(Value: Integer);
    procedure SetShadowedColor(Value : TColor);
    procedure SetGlyph(Value: TdxSmartGlyph);
    procedure SetShowAccelChar(Value: Boolean);
    procedure SetShowEndEllipsis(Value: Boolean);
    procedure SetWordWrap(Value: Boolean);

    function HasEffects: Boolean;
  protected
    procedure ChangeScale(M, D: Integer); override;
    procedure DoAssign(AProperties: TcxCustomEditProperties); override;
    class function GetViewDataClass: TcxCustomEditViewDataClass; override;
    function HasDisplayValue: Boolean; override;
    function GetDisplayFormatOptions: TcxEditDisplayFormatOptions; override;

    function CalculateDepthDelta: TSize; virtual;
  public
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;
    function CanCompareEditValue: Boolean; override;
    class function GetContainerClass: TcxContainerClass; override;
    class function GetStyleClass: TcxCustomEditStyleClass; override;
    function GetDisplayText(const AEditValue: TcxEditValue;
      AFullText: Boolean = False; AIsInplace: Boolean = True): string; override;
    function GetSupportedOperations: TcxEditSupportedOperations; override;
    class function GetViewInfoClass: TcxContainerViewInfoClass; override;
    function IsEditValueValid(var EditValue: TcxEditValue; AEditFocused: Boolean): Boolean; override;
    procedure PrepareDisplayValue(const AEditValue: TcxEditValue;
      var DisplayValue: TcxEditValue; AEditFocused: Boolean); override;
    function GetEditValueSource(AEditFocused: Boolean): TcxDataEditValueSource; override;
    // !!!
    property Angle: Integer read FAngle write SetAngle default 0;
    property Depth: Word read FDepth write SetDepth default 0;
    property Glyph: TdxSmartGlyph read FGlyph write SetGlyph;
    property LabelEffect: TcxLabelEffect read FLabelEffect write SetLabelEffect default cxleNormal;
    property LabelStyle: TcxLabelStyle read FLabelStyle write SetLabelStyle default cxlsNormal;
    property LineOptions: TcxLabelLineOptions read FLineOptions write SetLineOptions;
    property Orientation: TcxLabelOrientation read FOrientation write SetOrientation default cxoRightBottom;
    property PenWidth: Integer read FPenWidth write SetPenWidth default 1;
    property ShadowedColor: TColor read FShadowedColor write SetShadowedColor default clGrayText;
    property ShowAccelChar: Boolean read FShowAccelChar write SetShowAccelChar default True;
    property ShowEndEllipsis: Boolean read FShowEndEllipsis write SetShowEndEllipsis default False;
    property Transparent; // deprecated //# doc'd
    property WordWrap: Boolean read FWordWrap write SetWordWrap default False;
  end;

  { TcxLabelHelper }

  TcxLabelHelper = class
  public
    class function CalculatePositionOfRotatedText(ACanvas: TCanvas; AText: string;
      AShowAccelChar: Boolean; const ADrawingRect: TRect; const ADepthDeltaSize: TSize;
      AAngle: Integer; AAlignHorz: TcxEditHorzAlignment; AAlignVert: TcxEditVertAlignment): TPoint; overload;
    class function CalculatePositionOfRotatedText(ACanvas: TCanvas; const AText: string;
      const ADrawingRect: TRect; AProperties: TcxCustomLabelProperties): TPoint; overload;
  end;

  { TcxLabelProperties }

  TcxLabelProperties = class(TcxCustomLabelProperties)
  published
    property Alignment;
    property Angle;
    property Depth;
    property Glyph;
    property LabelEffect;
    property LabelStyle;
    property LineOptions;
    property Orientation;
    property PenWidth;
    property ShadowedColor;
    property ShowAccelChar;
    property ShowEndEllipsis;
    property Transparent; // deprecated
    property WordWrap;
  end;

  { TdxLabelAccessibilityHelper }

  TdxLabelAccessibilityHelper = class(TdxEditAccessibilityHelper) // for internal use
  protected
    function GetRole(AChildID: TcxAccessibleSimpleChildElementID): Integer; override;
    function GetSupportedProperties(AChildID: TcxAccessibleSimpleChildElementID): TcxAccessibleObjectProperties; override;
  end;

  { TcxCustomLabel }

  TcxCustomLabel = class(TcxCustomEdit)
  private
    FFocusControl: TWinControl;
    FLockCaption: Boolean;
    function GetProperties: TcxCustomLabelProperties;
    function GetActiveProperties: TcxCustomLabelProperties;
    function GetStyle: TcxLabelEditStyle;
    function GetViewInfo: TcxCustomLabelViewInfo;
    procedure SetFocusControl(Value: TWinControl);
    procedure SetProperties(Value: TcxCustomLabelProperties);
    procedure SetStyle(Value: TcxLabelEditStyle);
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure ResetCache;
  protected
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function FadingCanFadeBackground: Boolean; override;
    function GetAccessibilityHelperClass: TdxEditAccessibilityHelperClass; override;
    function GetDefaultSkinnedTextColor(AEnabled: Boolean): TColor; override;
    function GetEditStateColorKind: TcxEditStateColorKind; override;
    procedure Initialize; override;
    procedure InternalCanResize(var ANewWidth, ANewHeight: Integer); override;
    procedure InternalSetEditValue(const Value: TcxEditValue; AValidateEditValue: Boolean); override;
    procedure SetInternalDisplayValue(Value: TcxEditValue); override;
    procedure DoAutoSizeChanged; override;
    procedure TextChanged; override;
    function CanAutoHeight: Boolean; override;
    function CanAutoWidth: Boolean; override;
    function IsHeightDependOnWidth: Boolean; override;
    function CanFocusOnClick: Boolean; override;
    function DefaultParentColor: Boolean; override;
    procedure PropertiesChanged(Sender: TObject); override;
    function UseAnchorX: Boolean; override;
    function UseAnchorY: Boolean; override;

    property FocusControl: TWinControl read FFocusControl write SetFocusControl;
    property ViewInfo: TcxCustomLabelViewInfo read GetViewInfo;
  public
    destructor Destroy; override;
    class function GetPropertiesClass: TcxCustomEditPropertiesClass; override;
    function CanFocus: Boolean; override;
    function GetTextBaseLine: Integer; override;
    function HasTextBaseLine: Boolean; override;

    property ActiveProperties: TcxCustomLabelProperties read GetActiveProperties;
    property Caption;
    property Properties: TcxCustomLabelProperties read GetProperties write SetProperties;
    property Style: TcxLabelEditStyle read GetStyle write SetStyle;
    property TabOrder stored False;
    property Transparent;
  end;

  { TcxCustomLabel }

  TcxLabel = class(TcxCustomLabel)
  private
    function GetActiveProperties: TcxLabelProperties;
    function GetProperties: TcxLabelProperties;
    procedure SetProperties(Value: TcxLabelProperties);
  public
    class function GetPropertiesClass: TcxCustomEditPropertiesClass; override;
    property ActiveProperties: TcxLabelProperties read GetActiveProperties;
  published
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property Caption;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FocusControl;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Style;
    property StyleDisabled;
    property StyleFocused;
    property StyleHot;
    property Properties: TcxLabelProperties read GetProperties
      write SetProperties;
    property TabOrder;
    property Transparent;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

implementation

uses
{$IFDEF DELPHIXE8}
  System.Hash,
{$ENDIF}
  Math, cxEditConsts, cxEditPaintUtils, cxEditUtils, cxExtEditUtils, dxUxTheme,
  cxGeometry, cxFilterControlUtils, dxThemeConsts, dxThemeManager, dxCoreGraphics,
  dxDPIAwareUtils, dxHash;

const
  dxThisUnitName = 'cxLabel';

const
  TextFromBorderOffset = 1;
  TextFromLineOffset = 3;

function GetRealTextAngle(AAngle: Integer; AIsTrueTypeFont: Boolean): Integer;
begin
  Result := Integer(AIsTrueTypeFont) * (AAngle mod 360 + 360) mod 360;
end;

procedure CalculateCustomLabelViewInfo(ACanvas: TcxCanvas;
  AViewData: TcxCustomLabelViewData; AViewInfo: TcxCustomLabelViewInfo);

  procedure CheckFocusRectBounds;
  begin
    with AViewInfo do
    begin
      if FocusRect.Left < TextRect.Left - 1 then
        FocusRect.Left := TextRect.Left - 1;
      if FocusRect.Top < TextRect.Top - 1 then
        FocusRect.Top := TextRect.Top - 1;
      if FocusRect.Right > TextRect.Right + 1 then
        FocusRect.Right := TextRect.Right + 1;
      if FocusRect.Bottom > TextRect.Bottom + 1 then
        FocusRect.Bottom := TextRect.Bottom + 1;
    end;
  end;

begin
  with AViewInfo do
  begin
    if not IsInplace and Focused then
      if Length(Text) = 0 then
        FocusRect := cxEmptyRect
      else
      begin
        FocusRect := TextRect;
        InflateRect(FocusRect, 1, 1);
        CheckFocusRectBounds;
      end;
  end;
end;

function PrepareTextFlag(
  AHorzAlignments: TAlignment; AVertAlignments: TcxAlignmentVert;
  AShowEndEllipsis, AWordWrap, AShowAccelChar: Boolean): Longint;
const
  cxShowAccelCharArray: array[Boolean] of Integer = (0, cxShowPrefix);
  cxShowEndEllipsisArray: array[Boolean] of Integer = (0, cxShowEndEllipsis);
  cxWordWrapArray: array[Boolean] of Integer = (0, cxWordBreak);
begin
  Result := cxAlignmentsHorz[AHorzAlignments] or
    cxAlignmentsVert[AVertAlignments] or
    cxShowEndEllipsisArray[AShowEndEllipsis] or
    cxWordWrapArray[AWordWrap] or
    cxShowAccelCharArray[AShowAccelChar];
end;

{ TcxLabelEditStyle }

function TcxLabelEditStyle.DefaultBorderStyle: TcxContainerBorderStyle;
begin
  if ParentStyle = nil then
    Result := cbsNone
  else
    Result := inherited DefaultBorderStyle;
end;

function TcxLabelEditStyle.DefaultHotTrack: Boolean;
begin
  Result := False;
end;

{ TcxCustomLabelViewInfo }

constructor TcxCustomLabelViewInfo.Create;
begin
  inherited Create;
  FAlignment := TcxEditAlignment.Create(nil);
end;

destructor TcxCustomLabelViewInfo.Destroy;
begin
  FreeAndNil(FAlignment);
  FreeAndNil(FGlyph);
  inherited;
end;

procedure TcxCustomLabelViewInfo.Offset(DX, DY: Integer);
begin
  inherited Offset(DX, DY);
  OffsetRect(FocusRect, DX, DY);
end;

procedure TcxCustomLabelViewInfo.Paint(ACanvas: TcxCanvas);
begin
  DrawCustomEdit(ACanvas, False, False);
  DrawLabel(ACanvas);
end;

function TcxCustomLabelViewInfo.GetSkinnedTextColor(AKind: TcxEditStateColorKind): TColor;
begin
  Result := Painter.DefaultLabelTextColorEx(AKind);
end;

procedure TcxCustomLabelViewInfo.InternalDrawBackground(ACanvas: TcxCanvas; const R: TRect);
begin
  if not DrawBackground(ACanvas) then
  begin
    if not Transparent or IsInplace and Focused then
      cxEditFillRect(ACanvas, R, BackgroundColor)
    else
      if not IsInplace then
        cxDrawTransparentControlBackground(Edit, ACanvas, R);
  end;
end;

function TcxCustomLabelViewInfo.IsPaintOnGlass: Boolean;
begin
  Result := (Edit <> nil) and dxIsPaintOnGlass(Edit);
end;

procedure TcxCustomLabelViewInfo.SetGlyph(AGlyph: TGraphic);
begin
  if IsImageAssigned(AGlyph) then
  begin
    if FGlyph = nil then
      FGlyph := TBitmap.Create;
    FGlyph.Assign(AGlyph);
  end
  else
    FreeAndNil(FGlyph);
end;

procedure TcxCustomLabelViewInfo.DrawLabel(ACanvas: TcxCanvas);

  function GetColor(BColor, EColor: TColor; N, H: Integer) : TColor;
  begin
    EColor := ColorToRGB(EColor);
    BColor := ColorToRGB(BColor);

    Result := RGB(Trunc(GetRValue(BColor) + (GetRValue(EColor) - GetRValue(BColor)) * N / H),
                  Trunc(GetGValue(BColor) + (GetGValue(EColor) - GetGValue(BColor)) * N / H),
                  Trunc(GetBValue(BColor) + (GetBValue(EColor) - GetBValue(BColor)) * N / H));
  end;

  function GetTextDrawingParameters(ACanvas: TCanvas; ADrawingRect: TRect; AAngle: Integer; out AStep: TSize): TPoint;
  begin
    if AAngle <> 0 then
    begin
      Result := TcxLabelHelper.CalculatePositionOfRotatedText(ACanvas, Text, ShowAccelChar,
        ADrawingRect, DepthDeltaSize, AAngle, Alignment.Horz, Alignment.Vert);
    end
    else
      Result := cxNullPoint;

    AStep := cxNullSize;
    if HasEffects then
    begin
      AStep := DepthDeltaSize;
      if Orientation in [cxoRight, cxoRightTop, cxoRightBottom] then
      begin
        Inc(Result.X, DepthDeltaSize.cx + LabelStyleOffset);
        AStep.cx := -AStep.cx;
      end;
      if Orientation in [cxoBottom, cxoLeftBottom , cxoRightBottom] then
      begin
        Inc(Result.Y, DepthDeltaSize.cy + LabelStyleOffset);
        AStep.cy := -AStep.cy;
      end;
      if LabelEffect in [cxleFun, cxleExtrude] then
      begin
        AStep.cx := Sign(AStep.cx);
        AStep.cy := Sign(AStep.cy);
      end;
    end;
  end;

  function GetActualHorzAlignment: TcxEditHorzAlignment;
  begin
    Result := Alignment.Horz;
    if UseRightToLeftAlignment then
      ChangeBiDiModeAlignment(Result);
  end;

  procedure DrawActualText(ACanvas: TcxCanvas; const ADrawingRect: TRect;
    const APosition: TPoint; AIsTextRotated: Boolean; AIsInPath: Boolean = False);
  var
    AText: string;
    ATextFlags: Cardinal;
    ATextRect: TRect;
  begin
    ATextRect := ADrawingRect;
    if AIsTextRotated then
    begin
      if ShowAccelChar then
        AText := RemoveAccelChars(Text)
      else
        AText := Text;

      ExtTextOut(ACanvas.Handle, APosition.X, APosition.Y, 0, @ATextRect, PChar(AText), Length(AText), nil);
    end
    else
    begin
      Dec(ATextRect.Right, DepthDeltaSize.cx);
      Dec(ATextRect.Bottom, DepthDeltaSize.cy);
      ATextRect := cxRectOffset(ATextRect, APosition.X, APosition.Y);
      ATextFlags := PrepareTextFlag(GetActualHorzAlignment, TcxAlignmentVert(Alignment.Vert),
        (epoShowEndEllipsis in PaintOptions), WordWrap, ShowAccelChar);
      if WordWrap then
        ATextFlags := ATextFlags or cxDontClip;
      if IsPaintOnGlass and not AIsInPath then
        dxDrawTextOnGlass(ACanvas, Text, ATextRect, cxFlagsToDTFlags(ATextFlags), True)
      else
        ACanvas.DrawText(Text, ATextRect, ATextFlags);
    end;
  end;

  procedure DrawLabelEffect(ACanvas: TcxCanvas; const ADrawingRect: TRect;
    var AStartPos: TPoint; const AStep: TSize; AIsTextRotated: Boolean);
  var
    AIterationCount, I: Integer;
  begin
    if not HasEffects then
      Exit;
    if AStep.cx = 0 then
      AIterationCount := FDepth div Abs(AStep.cy)
    else
      AIterationCount := FDepth div Abs(AStep.cx);

    if LabelEffect <> cxleFun then
      ACanvas.Font.Color := ShadowedColor;
    for I := 1 to AIterationCount do
    begin
      if LabelEffect = cxleFun then
        ACanvas.Font.Color := GetColor(BackgroundColor, ShadowedColor, I, AIterationCount);
      DrawActualText(ACanvas, ADrawingRect, AStartPos, AIsTextRotated);
      Inc(AStartPos.X, AStep.cx);
      Inc(AStartPos.Y, AStep.cy);
    end;
  end;

  procedure DrawConventionalizedText(ACanvas: TcxCanvas; ARect: TRect;
    const APosition: TPoint; AGlyph: TBitmap; AIsTrueType: Boolean; AIsTextRotated: Boolean);

    procedure DrawFilledText(X, Y: Integer; AGlyphOnly: Boolean = False);
    begin
      if IsImageAssigned(AGlyph) and AIsTrueType then
      begin
        BeginPath(ACanvas.Handle);
        DrawActualText(ACanvas, ARect, Point(APosition.X + X, APosition.Y + Y), AIsTextRotated, True);
        EndPath(ACanvas.Handle);
        SelectClipPath(ACanvas.Handle, RGN_COPY);
        ACanvas.FillRect(ARect, AGlyph);
        SelectClipRgn(ACanvas.Handle, 0);
      end
      else
        if not AGlyphOnly then
          DrawActualText(ACanvas, ARect, Point(APosition.X + X, APosition.Y + Y), AIsTextRotated);
    end;

  begin
    ACanvas.Font.Color := TextColor;
    case LabelStyle of
      cxlsNormal:
        DrawFilledText(0, 0);

      cxlsRaised:
        begin
          ACanvas.Font.Color := clBtnHighlight;
          DrawActualText(ACanvas, ARect, APosition, AIsTextRotated);
          if Font.Size >= 12 then
          begin
            ACanvas.Font.Color := clBtnShadow;
            DrawActualText(ACanvas, ARect, cxPointOffset(APosition, ScaleFactor.Apply(2)), AIsTextRotated);
          end;
          ACanvas.Font.Color := TextColor;
          DrawFilledText(ScaleFactor.Apply(1), ScaleFactor.Apply(1));
        end;

      cxlsLowered:
        begin
          if Font.Size >= 12 then
          begin
            ACanvas.Font.Color := clBtnShadow;
            DrawActualText(ACanvas, ARect, APosition, AIsTextRotated);
          end;
          ACanvas.Font.Color := clBtnHighlight;
          DrawActualText(ACanvas, ARect, cxPointOffset(APosition, ScaleFactor.Apply(2)), AIsTextRotated);
          ACanvas.Font.Color := TextColor;
          DrawFilledText(ScaleFactor.Apply(1), ScaleFactor.Apply(1));
        end;

      cxlsOutLine:
        begin
          DrawFilledText(0, 0, AIsTrueType);
          if AIsTrueType then
          begin
            BeginPath(ACanvas.Handle);
            DrawActualText(ACanvas, ARect, APosition, AIsTextRotated, True);
            EndPath(ACanvas.Handle);
            ACanvas.Pen.Color := TextColor;
            ACanvas.Pen.Width := FPenWidth;
            StrokePath(ACanvas.Handle);
            ACanvas.Pen.Width := 1;
          end;
        end;
    end;
  end;

  procedure AdjustTextPosWithLabelStyle(var APosition: TPoint; const AStep: TSize);
  begin
    if AStep.cx < 0 then
      Dec(APosition.X, LabelStyleOffset);
    if AStep.cy < 0 then
      Dec(APosition.Y, LabelStyleOffset);
  end;

  procedure DrawLabelLine(ACanvas: TcxCanvas; const ALineRect, ATextRect: TRect);
  var
    ARect: TRect;
  begin
    if not IsRectEmpty(ALineRect) then
    begin
      ACanvas.SaveClipRegion;
      try
        if LineOrientation = orVertical then
          ARect := cxRectInflate(ATextRect, 0, TextFromLineOffset)
        else
          ARect := cxRectInflate(ATextRect, TextFromLineOffset, 0);
        ACanvas.ExcludeClipRect(ARect);
        Painter.DrawLabelLine(ACanvas, ALineRect, LineOuterColor, LineInnerColor, LineOrientation = orVertical);
      finally
        ACanvas.RestoreClipRegion;
      end;
    end;
  end;

  procedure InternalDrawLabel(ADrawCanvas: TcxCanvas; const ABackgroundRect, ATextRect, ALineRect: TRect);
  var
    AIsTrueType: Boolean;
    ARealAngle: Integer;
    AStartPos: TPoint;
    AStep: TSize;
  begin
    InternalDrawBackground(ADrawCanvas, ABackgroundRect);

    if Text <> '' then
    begin
      ADrawCanvas.SaveState;
      try
        AIsTrueType := AdjustCanvasFont(ADrawCanvas.Canvas, Font, FAngle);
        ARealAngle := GetRealTextAngle(FAngle, AIsTrueType);
        AStartPos := GetTextDrawingParameters(ADrawCanvas.Canvas, ATextRect, ARealAngle, AStep);
        ADrawCanvas.Brush.Style := bsClear;
        DrawLabelEffect(ADrawCanvas, ATextRect, AStartPos, AStep, ARealAngle <> 0);
        AdjustTextPosWithLabelStyle(AStartPos, AStep);
        DrawConventionalizedText(ADrawCanvas, ATextRect, AStartPos, FGlyph, AIsTrueType, ARealAngle <> 0);
        ADrawCanvas.Brush.Style := bsSolid;
      finally
        ADrawCanvas.RestoreState;
      end;
    end;

    DrawLabelLine(ADrawCanvas, ALineRect, ATextRect);
  end;

var
  ABackgroundRect: TRect;
  ATextRect: TRect;
  I: Integer;
begin
  if not cxRectIsEmpty(BorderRect) and ACanvas.RectVisible(BorderRect) then
  begin
    ABackgroundRect := BorderRect;
    ATextRect := TextRect;
    if NativeStyle and not (Transparent or IsInplace or HasEffects) then
      GetThemeBackgroundContentRect(OpenTheme(totEdit, ScaleFactor), ACanvas.Handle, EP_EDITTEXT, NativeState, Bounds, ABackgroundRect);
    for I := 0 to High(ButtonsInfo) do
      if ButtonsInfo[I].Data.LeftAlignment then
        ABackgroundRect.Left := Max(ABackgroundRect.Left, ButtonsInfo[I].Bounds.Right)
      else
        ABackgroundRect.Right := Min(ABackgroundRect.Right, ButtonsInfo[I].Bounds.Left);
    if UseRightToLeftAlignment then
      ATextRect := TdxRightToLeftLayoutConverter.ConvertRect(ATextRect, ClientRect);
    InternalDrawLabel(ACanvas, ABackgroundRect, ATextRect, LineRect);
  end;
end;

procedure TcxCustomLabelViewInfo.DrawFlatButtonBorder(ACanvas: TcxCanvas; AButtonViewInfo: TcxEditButtonViewInfo;
  var ARect: TRect; out AContentRect: TRect; var APenColor, ABrushColor: TColor);
begin
  APenColor := clBtnText;
  ABrushColor := clBtnFace;
  if AButtonViewInfo.Data.State = ebsPressed then
  begin
    FrameRectEx(ACanvas, ARect, clBtnShadow);
    FrameRectEx(ACanvas, ARect, ABrushColor);
  end
  else
  begin
    DrawComplexFrameEx(ACanvas, ARect, cl3DLight, cl3DDkShadow);
    if AButtonViewInfo.Data.State = ebsSelected then
      DrawComplexFrameEx(ACanvas, ARect, clBtnHighlight, clBtnShadow);
  end;
  AContentRect := ARect;
end;

procedure TcxCustomLabelViewInfo.DrawLookAndFeelButtonBackground(ACanvas: TcxCanvas;
  AButtonViewInfo: TcxEditButtonViewInfo; const ARect: TRect);
begin
  if Transparent then
    cxDrawTransparentControlBackground(Edit, ACanvas, ARect);
  inherited DrawLookAndFeelButtonBackground(ACanvas, AButtonViewInfo, ARect);
end;

procedure TcxCustomLabelViewInfo.DrawNativeButtonBackground(ACanvas: TcxCanvas; AButtonViewInfo: TcxEditButtonViewInfo;
  const ARect: TRect);
var
  APart: Integer;
  AThemeObject: TdxThemedObjectType;
begin
  if AButtonViewInfo.Data.ComboBoxStyle then
  begin
    AThemeObject := totComboBox;
    if IsWinVistaOrLater and not IsInplace then
      if AButtonViewInfo.Data.LeftAlignment then
        APart := CP_DROPDOWNBUTTONLEFT
      else
        APart := CP_DROPDOWNBUTTONRIGHT
    else
      APart := CP_DROPDOWNBUTTON;
  end
  else
  begin
    AThemeObject := totButton;
    APart := BP_PUSHBUTTON;
  end;
  if Transparent then
    cxDrawTransparentControlBackground(Edit, ACanvas, ARect);
  if AButtonViewInfo.Data.NativeState <> PBS_NORMAL then
    dxDrawThemeBackground(ACanvas.Handle, AThemeObject, ScaleFactor, ARect, APart, AButtonViewInfo.Data.NativeState);
end;

procedure TcxCustomLabelViewInfo.DrawUltraFlatButtonBorder(ACanvas: TcxCanvas; AButtonViewInfo: TcxEditButtonViewInfo;
  AIsOffice11Style: Boolean; var ARect, AContentRect: TRect; out APenColor, ABrushColor: TColor);
begin
  if Transparent then
    cxDrawTransparentControlBackground(Edit, ACanvas, ARect);
  inherited DrawUltraFlatButtonBorder(ACanvas, AButtonViewInfo, AIsOffice11Style, ARect, AContentRect, APenColor,
    ABrushColor);
end;

function TcxCustomLabelViewInfo.HasEffects: Boolean;
begin
  Result := (LabelEffect <> cxleNormal) and (FDepth <> 0);
end;

{ TcxCustomLabelViewData }

procedure TcxCustomLabelViewData.CalculateLabelViewInfoProps(AViewInfo: TcxCustomEditViewInfo);
begin
  with TcxCustomLabelViewInfo(AViewInfo) do
  begin
    LabelEffect := Properties.LabelEffect;
    LabelStyle := Properties.LabelStyle;
    Orientation := Properties.Orientation;
    Depth := ScaleFactor.Apply(Properties.Depth, Properties.ScaleFactor);
    ShadowedColor := Properties.ShadowedColor;
    ShowAccelChar := Properties.ShowAccelChar;
    Angle := Properties.Angle;
    PenWidth := Properties.PenWidth;
    WordWrap := Properties.WordWrap;
    LineOuterColor := Properties.LineOptions.OuterColor;
    LineInnerColor := Properties.LineOptions.InnerColor;
    Alignment.Assign(Properties.Alignment);
    SetGlyph(Properties.Glyph);
  end;
end;

procedure TcxCustomLabelViewData.Calculate(ACanvas: TcxCanvas;
  const ABounds: TRect; const P: TPoint; Button: TcxMouseButton; Shift: TShiftState;
  AViewInfo: TcxCustomEditViewInfo; AIsMouseEvent: Boolean);
var
  ALabelViewInfo: TcxCustomLabelViewInfo;
begin
  inherited Calculate(ACanvas, ABounds, P, Button, Shift, AViewInfo, AIsMouseEvent);
  if ((ABounds.Bottom >= cxMaxRectSize) or (ABounds.Right >= cxMaxRectSize)) and IsInplace then
    Exit;
  ALabelViewInfo := TcxCustomLabelViewInfo(AViewInfo);

  ALabelViewInfo.IsEditClass := GetIsEditClass;
  ALabelViewInfo.DrawSelectionBar := False;
  ALabelViewInfo.HasPopupWindow := False;
  ALabelViewInfo.DrawTextFlags := GetDrawTextFlags;
  if AreVisualStylesMustBeUsed(ALabelViewInfo.NativeStyle, totButton) and (ALabelViewInfo.BorderStyle = ebsNone) then
    ALabelViewInfo.NativeStyle := False;
  if not IsInplace then
    ALabelViewInfo.Transparent := TcxCustomLabel(Edit).Transparent;

  CalculateLabelViewInfoProps(ALabelViewInfo);
  ALabelViewInfo.DepthDeltaSize := ScaleFactor.Apply(Properties.CalculateDepthDelta, Properties.ScaleFactor);
  CalculateViewParams(ACanvas, ALabelViewInfo);
  CalculateCustomLabelViewInfo(ACanvas, Self, ALabelViewInfo);
  if not IsInplace then
    ALabelViewInfo.DrawSelectionBar := False;

  if Edit <> nil then
    ALabelViewInfo.LeftTop := Point(Edit.Left, Edit.Top);
end;

procedure TcxCustomLabelViewData.AdjustPadding(var APadding: TdxPadding);
begin
  inherited AdjustPadding(APadding);
  if not IsInplace then
  begin
    APadding.Left := 0;
    APadding.Right := 0;
  end;
end;


function TcxCustomLabelViewData.CalculateLabelStyleOffset(ACanvas: TcxCanvas): Integer;
const
  LabelStyleOffsetsMap: array[Boolean] of Integer = (1, 2);
begin
  if Properties.LabelStyle in [cxlsRaised, cxlsLowered] then
    Result := LabelStyleOffsetsMap[ACanvas.Font.Size >= 12]
  else
    Result := 0;
end;

function TcxCustomLabelViewData.CalculateLineRect(var ATextRect: TRect;
  const ABounds: TRect; AAlignment: TcxLabelLineAlignment; AVisible: Boolean;
  ALineHeight: Integer; AOrientation: TdxOrientation): TRect;
const
  SignsMap: array[TcxLabelLineAlignment] of Integer = (1, 0, -1);

  function CalcHorLineRect: TRect;
  begin
    Result := ABounds;
    case AAlignment of
      cxllaTop:
        Result.Bottom := Result.Top + ALineHeight;
      cxllaBottom:
        Result.Top := Result.Bottom - ALineHeight;
      else
        begin
          Result := cxRectCenterVertically(Result, ALineHeight);
          case Properties.Alignment.Horz of
            taLeftJustify:
              Result.Left := ATextRect.Right + TextFromLineOffset;
            taRightJustify:
              Result.Right := ATextRect.Left - TextFromLineOffset;
          end;
        end;
    end;
    if cxRectIntersect(ATextRect, Result) then
      OffsetRect(ATextRect, 0, SignsMap[AAlignment] * ALineHeight);
  end;

  function CalcVertLineRect: TRect;
  begin
    Result := ABounds;
    case AAlignment of
      cxllaTop:
        Result.Right := Result.Left + ALineHeight;
      cxllaBottom:
        Result.Left := Result.Right - ALineHeight;
      else
        begin
          Result := cxRectCenterHorizontally(Result, ALineHeight);
          case Properties.Alignment.Vert of
            taTopJustify:
              Result.Top := ATextRect.Bottom - TextFromLineOffset;
            taBottomJustify:
              Result.Bottom := ATextRect.Top + TextFromLineOffset;
          end;
        end;
    end;
    if cxRectIntersect(ATextRect, Result) then
      OffsetRect(ATextRect, SignsMap[AAlignment] * ALineHeight, 0);
  end;

begin
  Result := cxEmptyRect;
  if AVisible then
  begin
    if AOrientation = orHorizontal then
      Result := CalcHorLineRect
    else
      Result := CalcVertLineRect;
  end;
end;

function TcxCustomLabelViewData.CalculateTextRect(
  ACanvas: TcxCanvas; AViewInfo: TcxCustomLabelViewInfo; ARealAngle: Integer): TRect;
var
  ATextSize: TSize;
begin
  if IsInplace then
    Result := cxRectContent(AViewInfo.ClientRect, EditContentParams.Offsets)
  else
    Result := AViewInfo.ClientRect;

  if IsInplace and (ARealAngle = 0) and not IsLineVisible(ARealAngle) then Exit;

  ATextSize := CalculateTextSize(ACanvas, AViewInfo, Result, AViewInfo.Text, False);
  case Properties.Alignment.Horz of
    taLeftJustify:
      Result.Right := Min(Result.Left + ATextSize.cx, Result.Right);
    taRightJustify:
      Result.Left := Max(Result.Right - ATextSize.cx, Result.Left);
    taCenter:
      Result := cxRectCenterHorizontally(Result, ATextSize.cx);
  end;

  ATextSize := CalculateTextSize(ACanvas, AViewInfo, Result, AViewInfo.Text, True);
  case Properties.Alignment.Vert of
    taTopJustify:
      Result.Bottom := Min(Result.Top + ATextSize.cy, Result.Bottom);
    taBottomJustify:
      Result.Top := Max(Result.Bottom - ATextSize.cy, Result.Top);
    taVCenter:
      Result := cxRectCenterVertically(Result, ATextSize.cy);
  end;
end;

function TcxCustomLabelViewData.CalculateTextSize(
  ACanvas: TcxCanvas; AViewInfo: TcxCustomLabelViewInfo; const R: TRect; const AText: string; AFixedWidth: Boolean): TSize;

  function GetHash(ATextFlags: Integer): Integer;
  var
    AHandle: THandle;
  begin
    Result := 0;
    AHandle := ACanvas.Font.Handle;
    Result := dxBobJenkinsHash(R, SizeOf(R), Result);
    Result := dxBobJenkinsHash(AHandle, SizeOf(THandle), Result);
    Result := dxBobJenkinsHash(ATextFlags, SizeOf(ATextFlags), Result);
  end;

var
  ADepthSize: TSize;
  ALabelStyleOffset: Integer;
  ARealAngle: Integer;
  ARect: TRect;
  ATextMetric: TTextMetric;
  ATextFlags: Integer;
  AHash: Integer;
begin
  ARect := R;
  if Properties.Angle <> 0 then
  begin
    GetTextMetrics(ACanvas.Handle, ATextMetric);
    ARealAngle := GetRealTextAngle(Properties.Angle, ATextMetric.tmPitchAndFamily and TMPF_TRUETYPE <> 0);
  end
  else
    ARealAngle := 0;

  ATextFlags := PrepareTextFlag(taLeftJustify, vaTop, ShowEndEllipsis,
    Properties.WordWrap and (ARealAngle = 0) and not (IsInplace and (R.Right <= 0)),
     Properties.ShowAccelChar and (ARealAngle = 0));
  if not AFixedWidth then
    ATextFlags := ATextFlags or cxDontBreakChars;

  if AViewInfo <> nil then
    AHash := GetHash(ATextFlags)
  else
    AHash := 0;

  if (AViewInfo = nil) or (AViewInfo.FTextSizes[AFixedWidth].Hash <> AHash) then
  begin
    if (ARealAngle <> 0) and Properties.ShowAccelChar then
      cxDrawText(ACanvas.Handle, RemoveAccelChars(AText), ARect, DT_CALCRECT or cxFlagsToDTFlags(ATextFlags))
    else
      cxDrawText(ACanvas.Handle, AText, ARect, DT_CALCRECT or cxFlagsToDTFlags(ATextFlags));

    if ARealAngle = 0 then
      Result := Size(cxRectWidth(ARect), cxRectHeight(ARect))
    else
    begin
      Result.cx := Trunc(Abs(cxRectWidth(ARect) * Cos(ARealAngle * PI / 180)) +
        Abs(cxRectHeight(ARect) * Sin(ARealAngle  * PI / 180)) + 0.5);
      Result.cy := Trunc(Abs(cxRectWidth(ARect) * Sin(ARealAngle * PI / 180)) +
        Abs(cxRectHeight(ARect) * Cos(ARealAngle  * PI / 180)) + 0.5);
    end;

    if AViewInfo <> nil then
    begin
      AViewInfo.FTextSizes[AFixedWidth].Hash := AHash;
      AViewInfo.FTextSizes[AFixedWidth].Size := Result;
    end;
  end
  else
    Result := AViewInfo.FTextSizes[AFixedWidth].Size; 

  ADepthSize := ScaleFactor.Apply(Properties.CalculateDepthDelta, Properties.ScaleFactor);
  ALabelStyleOffset := CalculateLabelStyleOffset(ACanvas);
  Inc(Result.cx, ALabelStyleOffset + ADepthSize.cx);
  Inc(Result.cy, ALabelStyleOffset + ADepthSize.cy);
end;

procedure TcxCustomLabelViewData.CalculateViewParams(ACanvas: TcxCanvas; AViewInfo: TcxCustomLabelViewInfo);
const
  LineOrientationMap: array[Boolean] of TdxOrientation = (orHorizontal, orVertical);
var
  ARealAngle: Integer;
  ARect: TRect;
begin
  ACanvas.SaveState;
  try
    ARealAngle := GetRealTextAngle(Properties.Angle, AdjustCanvasFont(ACanvas.Canvas, Style.GetVisibleFont, Properties.Angle));
    AViewInfo.LabelStyleOffset := CalculateLabelStyleOffset(ACanvas);
    ARect := CalculateTextRect(ACanvas, AViewInfo, ARealAngle);
    AViewInfo.LineOrientation := LineOrientationMap[ARealAngle <> 0];
    AViewInfo.LineRect := CalculateLineRect(ARect, AViewInfo.ClientRect, LineOptions.Alignment,
      IsLineVisible(ARealAngle), GetLineHeight, AViewInfo.LineOrientation);
    AViewInfo.TextRect := ARect;
  finally
    ACanvas.RestoreState;
  end;
end;

procedure TcxCustomLabelViewData.EditValueToDrawValue(
  const AEditValue: TcxEditValue; AViewInfo: TcxCustomEditViewInfo);
begin
  TcxCustomLabelViewInfo(AViewInfo).Text := EditValueToDisplayText(AEditValue);
end;

function TcxCustomLabelViewData.GetEditContentSize(ACanvas: TcxCanvas;
  const AEditValue: TcxEditValue; const AEditSizeProperties: TcxEditSizeProperties; AErrorData: TcxEditValidateInfo): TSize;

  function GetEditDisplayText: string;
  begin
    if Edit = nil then
      Result := EditValueToDisplayText(AEditValue)
    else
      Result := TcxCustomLabel(Edit).ViewInfo.Text;

    if Result = '' then
      Result := ' ';
  end;

  function GetViewInfo: TcxCustomLabelViewInfo;
  begin
    if Edit = nil then
      Result := nil
    else
      Result := TcxCustomLabel(Edit).ViewInfo;
  end;

  function CalculateLabelMinSize(ACanvas: TcxCanvas; const AText: string;
    const ATextRect: TRect; ARealAngle: Integer; ADepthSize, AContentSizeCorrection: TSize;
    ALabelStyleOffset: Integer; AIsInplace, AWordWrap, AShowAccelChar: Boolean): TSize;
  var
    ARect: TRect;
  begin
    ARect := cxRectOffset(ATextRect, -ATextRect.Left, -ATextRect.Top);
    if ARect.Right >= 0 then
    begin
      Dec(ARect.Right, ADepthSize.cx + ALabelStyleOffset);
      if AIsInplace then
        Dec(ARect.Right, AContentSizeCorrection.cx)
      else
        if Style.BorderStyle <> ebsNone then
          Dec(ARect.Right, TextFromBorderOffset * 2);
    end;

    Result := CalculateTextSize(ACanvas, GetViewInfo, ARect, AText, False);
    if AIsInplace then
    begin
      Inc(Result.cx, AContentSizeCorrection.cx);
      Inc(Result.cy, AContentSizeCorrection.cy);
    end
    else
      if Style.BorderStyle <> ebsNone then
        Inc(Result.cx, TextFromBorderOffset * 2);

    if IsLineVisible(ARealAngle) and (LineOptions.Alignment <> cxllaCenter) then
    begin
      if ARealAngle = 0 then
        Inc(Result.cy, GetLineHeight)
      else
        Dec(Result.cx, GetLineHeight);
    end;
  end;

var
  ARealAngle: Integer;
begin
  ACanvas.SaveState;
  try
    ARealAngle := GetRealTextAngle(Properties.Angle,
      AdjustCanvasFont(ACanvas.Canvas, Style.GetVisibleFont, Properties.Angle));
    Result := Size(AEditSizeProperties.Width, 0);

    Result := CalculateLabelMinSize(ACanvas, GetEditDisplayText,
      Rect(0, 0, Result.cx, Result.cy), ARealAngle, ScaleFactor.Apply(Properties.CalculateDepthDelta, Properties.ScaleFactor),
      GetEditContentSizeCorrection, CalculateLabelStyleOffset(ACanvas),
      IsInplace, Properties.WordWrap, Properties.ShowAccelChar);
  finally
    ACanvas.RestoreState;
  end;
end;

function TcxCustomLabelViewData.IsLineVisible(ARealAngle: Integer): Boolean;
begin
  Result := LineOptions.Visible and ((ARealAngle = 0) or (ARealAngle = 90));
end;

function TcxCustomLabelViewData.GetDrawTextFlags: Integer;
var
  ARealAngle: Integer;
begin
  ARealAngle := (Properties.Angle mod 360 + 360) mod 360;
  Result := DrawTextFlagsTocxTextOutFlags(
    PrepareTextFlag(Properties.Alignment.Horz,
      TcxAlignmentVert(Ord(Properties.Alignment.Vert)),
      ShowEndEllipsis,
      Properties.WordWrap and (ARealAngle = 0), False));
end;

function TcxCustomLabelViewData.GetIsEditClass: Boolean;
begin
  Result := False;
end;

function TcxCustomLabelViewData.GetLineHeight: Integer;
begin
  if Edit = nil then
    Result := cxLookAndFeelPaintersManager.GetPainter(lfsStandard).LabelLineHeight
  else
    Result := Edit.Style.LookAndFeel.Painter.LabelLineHeight;
end;

function TcxCustomLabelViewData.CalculatePaintOptions: TcxEditPaintOptions;
begin
  Result := inherited CalculatePaintOptions;
  if ShowEndEllipsis then
    Include(Result, epoShowEndEllipsis);
end;

function TcxCustomLabelViewData.InternalEditValueToDisplayText(
  AEditValue: TcxEditValue): string;
begin
  Result := VarToStr(AEditValue);
end;

function TcxCustomLabelViewData.GetLineOptions: TcxLabelLineOptions;
begin
  Result := Properties.LineOptions;
end;

function TcxCustomLabelViewData.GetProperties: TcxCustomLabelProperties;
begin
  Result := TcxCustomLabelProperties(FProperties);
end;

function TcxCustomLabelViewData.GetShowEndEllipsis: Boolean;
begin
  Result := Properties.ShowEndEllipsis and ((Edit = nil) or not TcxCustomLabel(Edit).IsAutoWidth);
end;

{ TcxCustomLabelProperties }

constructor TcxCustomLabelProperties.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FLabelEffect := cxleNormal;
  FLabelStyle := cxlsNormal;
  FOrientation := cxoRightBottom;
  FDepth := 0;
  FShadowedColor := clGrayText;
  FShowAccelChar := True;
  FAngle := 0;
  FPenWidth := 1;
  FWordWrap := False;
  FLineOptions := TcxLabelLineOptions.Create;
  FLineOptions.OnChanged := ChangeHandler;
  FGlyph := TdxSmartGlyph.Create;
  FGlyph.OnChange := ChangeHandler;
end;

destructor TcxCustomLabelProperties.Destroy;
begin
  FreeAndNil(FGlyph);
  FreeAndNil(FLineOptions);
  inherited Destroy;
end;

function TcxCustomLabelProperties.CanCompareEditValue: Boolean;
begin
  Result := True;
end;

class function TcxCustomLabelProperties.GetContainerClass: TcxContainerClass;
begin
  Result := TcxLabel;
end;

class function TcxCustomLabelProperties.GetStyleClass: TcxCustomEditStyleClass;
begin
  Result := TcxLabelEditStyle;
end;

function TcxCustomLabelProperties.GetDisplayText(const AEditValue: TcxEditValue;
  AFullText: Boolean = False; AIsInplace: Boolean = True): string;
var
  ADisplayValue: TcxEditValue;
begin
  PrepareDisplayValue(AEditValue, ADisplayValue, False);
  Result := ADisplayValue;
end;

function TcxCustomLabelProperties.GetSupportedOperations: TcxEditSupportedOperations;
begin
  if LineOptions.Visible and ((Angle = 0) or (Angle = 90)) then
    Result := [esoAutoHeight, esoFiltering, esoShowingCaption, esoSorting, esoTransparency]
  else
    Result := [esoAutoHeight, esoFiltering, esoShowingCaption, esoSorting, esoTransparency, esoAutoWidth];
end;

class function TcxCustomLabelProperties.GetViewInfoClass: TcxContainerViewInfoClass;
begin
  Result := TcxCustomLabelViewInfo;
end;

function TcxCustomLabelProperties.IsEditValueValid(var EditValue: TcxEditValue; AEditFocused: Boolean): Boolean;
begin
  Result := inherited IsEditValueValid(EditValue, AEditFocused);
end;

procedure TcxCustomLabelProperties.PrepareDisplayValue(const AEditValue:
  TcxEditValue; var DisplayValue: TcxEditValue; AEditFocused: Boolean);
begin
  DisplayValue := VarToStr(AEditValue);
end;

procedure TcxCustomLabelProperties.ChangeScale(M, D: Integer);
begin
  inherited;
  Depth := MulDiv(Depth, M, D);
end;

procedure TcxCustomLabelProperties.DoAssign(AProperties: TcxCustomEditProperties);
begin
  inherited;
  if AProperties is TcxCustomLabelProperties then
    with TcxCustomLabelProperties(AProperties) do
    begin
      Self.LabelEffect := LabelEffect;
      Self.LabelStyle := LabelStyle;
      Self.Orientation := Orientation;
      Self.Depth := Self.ScaleFactor.Apply(Depth, ScaleFactor);
      Self.ShadowedColor := ShadowedColor;
      Self.ShowEndEllipsis := ShowEndEllipsis;
      Self.Angle := Angle;
      Self.PenWidth := PenWidth;
      Self.Glyph := Glyph;
      Self.ShowAccelChar := ShowAccelChar;
      Self.WordWrap := WordWrap;
      Self.LineOptions := LineOptions;
    end;
end;

class function TcxCustomLabelProperties.GetViewDataClass: TcxCustomEditViewDataClass;
begin
  Result := TcxCustomLabelViewData;
end;

function TcxCustomLabelProperties.HasDisplayValue: Boolean;
begin
  Result := True;
end;

procedure TcxCustomLabelProperties.SetLabelEffect(Value : TcxLabelEffect);
begin
  if FLabelEffect <> Value then
  begin
    FLabelEffect := Value;
    Changed;
  end;
end;

procedure TcxCustomLabelProperties.SetLineOptions(AValue: TcxLabelLineOptions);
begin
  FLineOptions.Assign(AValue);
end;

procedure TcxCustomLabelProperties.SetLabelStyle(Value : TcxLabelStyle);
begin
  if FLabelStyle <> Value then
  begin
    FLabelStyle := Value;
    Changed;
  end;
end;

procedure TcxCustomLabelProperties.SetOrientation(Value : TcxLabelOrientation);
begin
  if FOrientation <> Value then
  begin
    FOrientation := Value;
    Changed;
  end;
end;

procedure TcxCustomLabelProperties.SetDepth(Value : Word);
begin
  if FDepth <> Value then
  begin
    FDepth := Value;
    Changed;
  end;
end;

procedure TcxCustomLabelProperties.SetShadowedColor(Value : TColor);
begin
  if FShadowedColor <> Value then
  begin
    FShadowedColor := Value;
    Changed;
  end;
end;

procedure TcxCustomLabelProperties.SetAngle(Value: Integer);
begin
  if FAngle <> Value then
  begin
    FAngle := Value;
    Changed;
  end;
end;

procedure TcxCustomLabelProperties.SetPenWidth(Value: Integer);
begin
  if FPenWidth <> Value then
  begin
    FPenWidth := Value;
    Changed;
  end;
end;

procedure TcxCustomLabelProperties.SetGlyph(Value: TdxSmartGlyph);
begin
  Glyph.Assign(Value);
end;

procedure TcxCustomLabelProperties.SetShowAccelChar(Value: Boolean);
begin
  if FShowAccelChar <> Value then
  begin
    FShowAccelChar := Value;
    Changed;
  end;
end;

procedure TcxCustomLabelProperties.SetShowEndEllipsis(Value: Boolean);
begin
  if ShowEndEllipsis <> Value then
  begin
    FShowEndEllipsis := Value;
    Changed;
  end;
end;

procedure TcxCustomLabelProperties.SetWordWrap(Value: Boolean);
begin
  if FWordWrap <> Value then
  begin
    FWordWrap := Value;
    Changed;
  end;
end;

function TcxCustomLabelProperties.HasEffects: Boolean;
begin
  Result := (LabelEffect <> cxleNormal) and (FDepth <> 0);
end;

function TcxCustomLabelProperties.CalculateDepthDelta: TSize;
begin
  Result.cx := 0;
  Result.cy := 0;
  if not HasEffects then Exit;
  case FOrientation of
    cxoLeft, cxoRight: Result.cx := FDepth;
    cxoTop, cxoBottom: Result.cy := FDepth;
    cxoLeftTop, cxoLeftBottom, cxoRightTop, cxoRightBottom:
    begin
      Result.cx := FDepth;
      Result.cy := FDepth;
    end;
  end;
end;

function TcxCustomLabelProperties.GetDisplayFormatOptions: TcxEditDisplayFormatOptions;
begin
  Result := [];
end;

function TcxCustomLabelProperties.GetEditValueSource(AEditFocused: Boolean): TcxDataEditValueSource;
begin
  Result := evsText;
end;

{ TcxLabelHelper }

class function TcxLabelHelper.CalculatePositionOfRotatedText(ACanvas: TCanvas;
  AText: string; AShowAccelChar: Boolean; const ADrawingRect: TRect; const ADepthDeltaSize: TSize;
  AAngle: Integer; AAlignHorz: TcxEditHorzAlignment; AAlignVert: TcxEditVertAlignment): TPoint;
var
  ACos: Extended;
  AHeight: Extended;
  AOffsetX: Extended;
  AOffsetY: Extended;
  ARadian: Extended;
  ARealAngle: Integer;
  ASin: Extended;
  ATextSize: TSize;
  AWidth: Extended;
  X, Y: Extended;
begin
  if AShowAccelChar then
    AText := RemoveAccelChars(AText);

  ATextSize := TdxTextMeasurer.TextSizeTO(ACanvas.Font, AText);
  ARealAngle := GetRealTextAngle(AAngle, True);
  ARadian := ARealAngle * PI / 180;

  ACos := Cos(ARadian);
  ASin := Sin(ARadian);
  AWidth := Abs(ATextSize.cx * ACos) + Abs(ATextSize.cy * ASin) + ADepthDeltaSize.cx;
  AHeight := Abs(ATextSize.cx * ASin) + Abs(ATextSize.cy * ACos) + ADepthDeltaSize.cy;

  if ARealAngle >= 180 then
  begin
    AOffsetX := Abs(ATextSize.cy * ASin);
    AOffsetY := Abs(ATextSize.cy * ACos);
    X := IfThen(ARealAngle >= 270, AOffsetX, AWidth);
    Y := IfThen(ARealAngle >= 270, 0, AOffsetY);
  end
  else
  begin
    AOffsetX := Abs(ATextSize.cx * ACos);
    AOffsetY := Abs(ATextSize.cx * ASin);
    X := IfThen(ARealAngle <= 90, 0, AOffsetX);
    Y := IfThen(ARealAngle > 90, AHeight, AOffsetY);
  end;

  case AAlignHorz of
    taLeftJustify:
      Result.X := Round(ADrawingRect.Left + X);
    taRightJustify:
      Result.X := Round(ADrawingRect.Right + 1 - AWidth + X);
  else
    Result.X := Round((ADrawingRect.Left + ADrawingRect.Right - (ATextSize.cx * ACos + ATextSize.cy * ASin)) / 2);
  end;

  case AAlignVert of
    taTopJustify:
      Result.Y := Round(ADrawingRect.Top + Y);
    taBottomJustify:
      Result.Y := Round(ADrawingRect.Bottom - AHeight + Y);
  else
    Result.Y := Round((ADrawingRect.Top + ADrawingRect.Bottom + (ATextSize.cx * ASin - ATextSize.cy * ACos)) / 2);
  end;
end;

class function TcxLabelHelper.CalculatePositionOfRotatedText(
  ACanvas: TCanvas; const AText: string; const ADrawingRect: TRect; AProperties: TcxCustomLabelProperties): TPoint;
begin
  Result := CalculatePositionOfRotatedText(ACanvas, AText, AProperties.ShowAccelChar, ADrawingRect,
    cxNullSize, AProperties.Angle, AProperties.Alignment.Horz, AProperties.Alignment.Vert);
end;

{ TdxLabelAccessibilityHelper }
function TdxLabelAccessibilityHelper.GetRole(AChildID: TcxAccessibleSimpleChildElementID): Integer;
begin
  Result := cxROLE_SYSTEM_STATICTEXT;
end;

function TdxLabelAccessibilityHelper.GetSupportedProperties(AChildID: TcxAccessibleSimpleChildElementID): TcxAccessibleObjectProperties;
begin
  if ChildCount = 0 then
    Result := [aopLocation]
  else
    Result := inherited;
end;

{ TcxCustomLabel }

destructor TcxCustomLabel.Destroy;
begin
  FFocusControl := nil;
  inherited Destroy;
end;

procedure TcxCustomLabel.DoAutoSizeChanged;
begin
  inherited DoAutoSizeChanged;
  if AutoSize then
    Properties.LineOptions.Visible := False;
end;

procedure TcxCustomLabel.PropertiesChanged(Sender: TObject);
begin
  ResetCache;
  inherited PropertiesChanged(Sender);
  if Properties.LineOptions.Visible then
    AutoSize := False;
end;

function TcxCustomLabel.UseAnchorX: Boolean;
begin
  Result := ActiveProperties.Alignment.Horz <> taLeftJustify;
end;

function TcxCustomLabel.UseAnchorY: Boolean;
begin
  Result := ActiveProperties.Alignment.Vert <> taTopJustify;
end;

class function TcxCustomLabel.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TcxCustomLabelProperties;
end;

procedure TcxCustomLabel.SetStyle(Value: TcxLabelEditStyle);
begin
  FStyles.Style := Value;
end;

procedure TcxCustomLabel.Loaded;
begin
  if CanAllocateHandle(Self) then
    HandleNeeded;
  inherited Loaded;
end;

procedure TcxCustomLabel.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FFocusControl) then
    FFocusControl := nil;
end;

function TcxCustomLabel.GetDefaultSkinnedTextColor(AEnabled: Boolean): TColor;
var
  AIntf: IdxCustomSkinnedContainer;
begin
  if Supports(Parent, IdxCustomSkinnedContainer, AIntf) then
    Result := AIntf.GetDefaultTextColor(AEnabled)
  else
    Result := inherited;
end;

function TcxCustomLabel.GetEditStateColorKind: TcxEditStateColorKind;
begin
  Result := cxEditStateColorKindMap[Enabled];
end;

procedure TcxCustomLabel.Initialize;
begin
  inherited Initialize;
  ControlStyle := ControlStyle - [csCaptureMouse];
  SetBounds(Left, Top, 121, 21);
end;

procedure TcxCustomLabel.SetFocusControl(Value: TWinControl);
begin
  if (FFocusControl <> Value) and (Value <> Self) then
    FFocusControl := Value;
end;

procedure TcxCustomLabel.InternalCanResize(var ANewWidth,
  ANewHeight: Integer);
begin
  if not IsScaleChanging then
    inherited;
end;

procedure TcxCustomLabel.InternalSetEditValue(const Value: TcxEditValue;
  AValidateEditValue: Boolean);
begin
  inherited InternalSetEditValue(Value, AValidateEditValue);
  if not FLockCaption then
    Caption := VarToStr(Value);
  SetInternalDisplayValue(Caption);
end;

procedure TcxCustomLabel.SetInternalDisplayValue(Value: TcxEditValue);
begin
  ViewInfo.Text := VarToStr(Value);
  ShortRefreshContainer(False);
end;

procedure TcxCustomLabel.TextChanged;
begin
  ResetCache;
  inherited TextChanged;
  FLockCaption := True;
  try
    InternalEditValue := Caption;
  finally
    FLockCaption := False;
  end;
end;

function TcxCustomLabel.CanFocus: Boolean;
begin
  Result := IsInplace;
end;

function TcxCustomLabel.GetTextBaseLine: Integer;
begin
  Result := ViewInfo.GetTextBaseLine;
end;

function TcxCustomLabel.HasTextBaseLine: Boolean;
begin
  Result := ActiveProperties.Angle = 0;
end;

function TcxCustomLabel.CanAutoHeight: Boolean;
begin
  Result := True;
end;

function TcxCustomLabel.CanAutoWidth: Boolean;
begin
  Result := True;
end;

function TcxCustomLabel.IsHeightDependOnWidth: Boolean;
begin
  Result := ActiveProperties.WordWrap;
end;

function TcxCustomLabel.CanFocusOnClick: Boolean;
begin
  Result := inherited CanFocusOnClick and IsInplace;
end;

function TcxCustomLabel.DefaultParentColor: Boolean;
begin
  Result := True;
end;

function TcxCustomLabel.FadingCanFadeBackground: Boolean;
begin
  Result := False;
end;

function TcxCustomLabel.GetAccessibilityHelperClass: TdxEditAccessibilityHelperClass;
begin
  Result := TdxLabelAccessibilityHelper;
end;

procedure TcxCustomLabel.CMDialogChar(var Message: TCMDialogChar);
begin
  if (FFocusControl <> nil) and Enabled and Properties.ShowAccelChar and
    IsAccel(Message.CharCode, Caption) and FFocusControl.CanFocus then
  begin
    FFocusControl.SetFocus;
    Message.Result := 1;
  end;
end;

procedure TcxCustomLabel.ResetCache;
begin
  ViewInfo.FTextSizes[False].Hash := 0;
  ViewInfo.FTextSizes[True].Hash := 0;
end;

function TcxCustomLabel.GetProperties: TcxCustomLabelProperties;
begin
  Result := TcxCustomLabelProperties(inherited Properties);
end;

function TcxCustomLabel.GetActiveProperties: TcxCustomLabelProperties;
begin
  Result := TcxCustomLabelProperties(InternalGetActiveProperties);
end;

function TcxCustomLabel.GetStyle: TcxLabelEditStyle;
begin
  Result := TcxLabelEditStyle(FStyles.Style);
end;

function TcxCustomLabel.GetViewInfo: TcxCustomLabelViewInfo;
begin
  Result := TcxCustomLabelViewInfo(FViewInfo);
end;

procedure TcxCustomLabel.SetProperties(Value: TcxCustomLabelProperties);
begin
  Properties.Assign(Value);
end;

{ TcxLabel }

class function TcxLabel.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TcxLabelProperties;
end;

function TcxLabel.GetActiveProperties: TcxLabelProperties;
begin
  Result := TcxLabelProperties(InternalGetActiveProperties);
end;

function TcxLabel.GetProperties: TcxLabelProperties;
begin
  Result := TcxLabelProperties(inherited Properties);
end;

procedure TcxLabel.SetProperties(Value: TcxLabelProperties);
begin
  Properties.Assign(Value);
end;

{ TcxLabelLineOptions }

constructor TcxLabelLineOptions.Create;
begin
  FAlignment := cxllaCenter;
  FInnerColor := clDefault;
  FOuterColor := clDefault;
end;

procedure TcxLabelLineOptions.Assign(Source: TPersistent);
begin
  if Source is TcxLabelLineOptions then
  begin
    FVisible := TcxLabelLineOptions(Source).FVisible;
    FAlignment := TcxLabelLineOptions(Source).FAlignment;
    FInnerColor := TcxLabelLineOptions(Source).FInnerColor;
    FOuterColor := TcxLabelLineOptions(Source).FOuterColor;
    Changed;
  end
  else
    inherited Assign(Source);
end;

procedure TcxLabelLineOptions.Changed;
begin
  if Assigned(OnChanged) then
    OnChanged(Self);
end;

function TcxLabelLineOptions.GetIsCustomColorsAssigned: Boolean;
begin
  Result := (InnerColor <> clDefault) and (OuterColor <> clDefault);
end;

procedure TcxLabelLineOptions.SetAlignment(AValue: TcxLabelLineAlignment);
begin
  if FAlignment <> AValue then
  begin
    FAlignment := AValue;
    Changed;
  end;
end;

procedure TcxLabelLineOptions.SetInnerColor(AValue: TColor);
begin
  if FInnerColor <> AValue then
  begin
    FInnerColor := AValue;
    Changed;
  end;
end;

procedure TcxLabelLineOptions.SetOuterColor(AValue: TColor);
begin
  if FOuterColor <> AValue then
  begin
    FOuterColor := AValue;
    Changed;
  end;
end;

procedure TcxLabelLineOptions.SetVisible(AValue: Boolean);
begin
  if Visible <> AValue then
  begin
    FVisible := AValue;
    Changed;
  end;
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  GetRegisteredEditProperties.Register(TcxLabelProperties, scxSEditRepositoryLabelItem);
  FilterEditsController.Register(TcxLabelProperties, TcxFilterTextEditHelper);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  FilterEditsController.Unregister(TcxLabelProperties, TcxFilterTextEditHelper);
  GetRegisteredEditProperties.Unregister(TcxLabelProperties);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
