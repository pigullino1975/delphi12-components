﻿{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           Express Cross Platform Library controls                  }
{                                                                    }
{           Copyright (c) 2000-2024 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSCROSSPLATFORMLIBRARY AND ALL   }
{   ACCOMPANYING VCL CONTROLS AS PART OF AN EXECUTABLE PROGRAM       }
{   ONLY.                                                            }
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

unit dxCalloutPopup;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Classes, Controls, Types, Windows, Messages, RTLConsts, SysUtils, Math, Menus, MultiMon,
  Forms, Graphics,
  dxCore, cxScrollBar, cxClasses, cxGraphics, cxGeometry, cxLookAndFeelPainters,
  dxCoreClasses, dxAnimation, dxGdiPlusClasses, cxControls, dxThemeManager, cxLookAndFeels,
  cxAccessibility, cxLibraryConsts, dxCustomHint, dxCoreGraphics, cxContainer, dxGdiPlusApi;

type
  TdxCustomCalloutPopupWindow = class;
  TdxCustomCalloutPopup = class;

  TdxCalloutPopupAlignment = (cpaLeftBottom, cpaLeftCenter, cpaLeftTop, cpaTopLeft, cpaTopCenter, cpaTopRight,
    cpaRightTop, cpaRightCenter, cpaRightBottom, cpaBottomRight, cpaBottomCenter, cpaBottomLeft);

  TdxCalloutPopupViewInfo = class
  private
    FBounds: TRect;
    FBorderBounds: TRect;
    FCalloutBounds: TRect;
    FCalloutPosition: Integer;
    FCalloutPolygon: TcxArrowPoints;
    FClientBounds: TRect;
    FPopupControlBounds: TRect;
    FPopup: TdxCustomCalloutPopupWindow;
    FRequiredSize: TSize;
    FIsCalloutVisible: Boolean;
  protected
    procedure CalculateBorderBounds;
    procedure CalculateCalloutBounds;
    procedure CalculateCalloutPolygon;
    procedure CalculateClientBounds;
    procedure CalculatePopupControlBounds;

    function DoCalculateBorderBounds: TRect; virtual;
    function DoCalculateCalloutBounds: TRect; virtual;
    function DoCalculateCalloutPolygon: TcxArrowPoints; virtual;
    procedure DoCalculateCalloutPositionAndVisibility(const APopupPos, AOrigin: TPoint;
      const APopupSize: TSize; var ACalloutPosition: Integer; var AIsCalloutVisible: Boolean); virtual;
    function DoCalculateClientBounds: TRect; virtual;
    function DoCalculatePopupControlBounds: TRect; virtual;
    function DoCalculateRequiredSize(const AAvailableSize: TSize): TSize; virtual;

    function CreateRegion: HRGN; virtual;
    function GetBorders: TRect; virtual;
    function GetCalloutElementMinOffset: Integer; virtual;
    function GetCalloutElementSize: TSize; virtual;
    function GetClientOffsets: TRect; virtual;

    property CalloutBounds: TRect read FCalloutBounds;
    property CalloutPolygon: TcxArrowPoints read FCalloutPolygon;
    property CalloutPosition: Integer read FCalloutPosition;
    property IsCalloutVisible: Boolean read FIsCalloutVisible;
    property BorderBounds: TRect read FBorderBounds;
    property Bounds: TRect read FBounds;
    property ClientBounds: TRect read FClientBounds;
    property Popup: TdxCustomCalloutPopupWindow read FPopup;
  public
    constructor Create(APopup: TdxCustomCalloutPopupWindow); virtual;
    procedure Calculate(const ABounds: TRect); virtual;
    procedure CalculateCalloutPositionAndVisibility(const APopupPos, AOrigin: TPoint;
      const APopupSize: TSize); virtual;
    procedure CalculateRequiredSize(const AAvailableSize: TSize); virtual;
    procedure Paint(ACanvas: TcxCanvas); virtual;

    property PopupControlBounds: TRect read FPopupControlBounds;
    property RequiredSize: TSize read FRequiredSize;
  end;

  TdxCalloutPopupAnimationOptions = class(TcxOwnedPersistent)
  private
    FFadeEffect: Boolean;
    FHidingAnimationTime: Cardinal;
    FMoveEffect: Boolean;
    FShowingAnimationTime: Cardinal;
  protected
    procedure DoAssign(Source: TPersistent); override;
  public
    constructor Create(AOwner: TPersistent); override;
  published
    property FadeEffect: Boolean read FFadeEffect write FFadeEffect default True;
    property HidingAnimationTime: Cardinal read FHidingAnimationTime write FHidingAnimationTime default 100;
    property MoveEffect: Boolean read FMoveEffect write FMoveEffect default True;
    property ShowingAnimationTime: Cardinal read FShowingAnimationTime write FShowingAnimationTime default 200;
  end;

  TdxCalloutPopupAnimationType = (atShow, atHide);
  TdxFlyoutPanelAlign = (fpaTop, fpaBottom, fpaLeft, fpaRight);

  TdxCustomCalloutPopupWindow = class(TcxCustomPopupWindow)
  private const
    TransitionEffect: TdxAnimationTransitionEffect = ateLinear;
  strict private
    FAnimationTime: array [TdxCalloutPopupAnimationType] of Cardinal;
    FCalloutVisible: Boolean;
    FFadeAnimation: Boolean;
    FFlyoutPanelAlign: TdxFlyoutPanelAlign;
    FFlyoutPanelMode: Boolean;
    FMoveAnimation: Boolean;
    FMoveFactor: Double;
    FPosition: Integer;
    FPrevPopupControlData: TcxPrevPopupControlData;
    FPopupControl: TWinControl;
    FRounded: Boolean;
    FRoundRadius: Integer;
    FShowPosition: Integer;
    FViewInfo: TdxCalloutPopupViewInfo;

    procedure DoAnimate(AAnimationType: TdxCalloutPopupAnimationType);
    procedure DoFlyoutPanelMoveAnimation(APosition: Integer);
    function GetAnimationTime(AnimationType: TdxCalloutPopupAnimationType): Cardinal;
    procedure RestorePopupControlData;
    procedure SavePopupControlData;
    procedure SetAnimationTime(AnimationType: TdxCalloutPopupAnimationType; const Value: Cardinal);
  protected
    procedure AdjustClientRect(var Rect: TRect); override;
    procedure CalculateCommonPosition(var APosition: TPoint; var AOrigin: TPoint; const ASize: TSize); override;
    function CalculatePosition(const ASize: TSize): TPoint; override;
    function CalculateSize: TSize; override;
    procedure CorrectPositionWithDesktopWorkArea(var APosition: TPoint; var AOrigin: TPoint; const ASize: TSize); override;
    function CreateViewInfo: TdxCalloutPopupViewInfo; virtual;
    procedure DoClosed; override;
    procedure DoClosing; override;
    procedure DoHideAnimation(Sender: TdxAnimationTransition; var APosition: Integer; var AFinished: Boolean); virtual;
    procedure DoShowAnimation(Sender: TdxAnimationTransition; var APosition: Integer; var AFinished: Boolean); virtual;
    procedure DoShowed; override;
    procedure DoShowing; override;
    procedure InitPopup; override;
    procedure InternalCalculateHorizontalDirectionPosition(var APosition: TPoint; var AOrigin: TPoint; const ASize: TSize); override;
    procedure InternalCalculateVerticalDirectionPosition(var APosition: TPoint; var AOrigin: TPoint; const ASize: TSize); override;
    procedure Paint; override;
    procedure Resize; override;
    procedure ScaleFactorChanged(M, D: Integer); override;
    function UseOwnerParentToGetScreenBounds: Boolean; override;
    function GetPopupControlSize: TSize;

    property AnimationTime [AnimationType: TdxCalloutPopupAnimationType]: Cardinal read GetAnimationTime write SetAnimationTime;
    property CalloutVisible: Boolean read FCalloutVisible write FCalloutVisible;
    property FadeAnimation: Boolean read FFadeAnimation write FFadeAnimation;
    property FlyoutPanelAlign: TdxFlyoutPanelAlign read FFlyoutPanelAlign write FFlyoutPanelAlign;
    property FlyoutPanelMode: Boolean read FFlyoutPanelMode write FFlyoutPanelMode;
    property MoveAnimation: Boolean read FMoveAnimation write FMoveAnimation;
    property PopupControl: TWinControl read FPopupControl write FPopupControl;
    property Rounded: Boolean read FRounded write FRounded;
    property RoundRadius: Integer read FRoundRadius write FRoundRadius;
    property ViewInfo: TdxCalloutPopupViewInfo read FViewInfo;
  public
    constructor Create(AOwnerControl: TWinControl); override;
    destructor Destroy; override;
  end;

  TdxFlyoutPanel = class(TcxOwnedPersistent)
  strict private
    FActive: Boolean;
    FAlign: TdxFlyoutPanelAlign;
  protected
    procedure DoAssign(Source: TPersistent); override;
  published
    property Active: Boolean read FActive write FActive default False;
    property Align: TdxFlyoutPanelAlign read FAlign write FAlign default fpaTop;
  end;

  TdxCustomCalloutPopup = class(TcxCustomComponent, IdxSkinSupport)
  private
    FAcceptAnyPosition: Boolean;
    FAlignment: TdxCalloutPopupAlignment;
    FAnimationOptions: TdxCalloutPopupAnimationOptions;
    FBorderColor: TColor;
    FCallout: TdxCustomCalloutPopupWindow;
    FColor: TColor;
    FFlyoutPanel: TdxFlyoutPanel;
    FHideCallout: Boolean;
    FLookAndFeel: TcxLookAndFeel;
    FPopupControl: TWinControl;
    FRounded: Boolean;
    FRoundRadius: Integer;
    FOnHide: TNotifyEvent;
    FOnShow: TNotifyEvent;
    function CanPopup(AOwnerControl: TWinControl): Boolean;
    procedure DestroyPopup;
    procedure DoPopupClosed(Sender: TObject);
    procedure DoPopupShowed(Sender: TObject);
    procedure RecreatePopupIfNeeded(AOwnerControl: TWinControl);
    procedure SetAnimationOptions(const Value: TdxCalloutPopupAnimationOptions);
    procedure SetLookAndFeel(const Value: TcxLookAndFeel);
    procedure SetPopupControl(AValue: TWinControl);
    procedure SetFlyoutPanel(const AValue: TdxFlyoutPanel);
  protected
    function CreatePopupWindow(AOwnerControl: TWinControl): TdxCustomCalloutPopupWindow; virtual;
    procedure InitializeCalloutWindow; virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    property AcceptAnyPosition: Boolean read FAcceptAnyPosition write FAcceptAnyPosition;
    property Callout: TdxCustomCalloutPopupWindow read FCallout;
  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Close;
    function IsVisible: Boolean;
    procedure Popup(AOwnerControl: TWinControl; const AOwnerBounds: TRect); overload;
    procedure Popup(AOwnerControl: TWinControl); overload;

    property AnimationOptions: TdxCalloutPopupAnimationOptions read FAnimationOptions write SetAnimationOptions;
    property BorderColor: TColor read FBorderColor write FBorderColor default clDefault;
    property HideCallout: Boolean read FHideCallout write FHideCallout default False;
    property Color: TColor read FColor write FColor default clDefault;
    property FlyoutPanel: TdxFlyoutPanel read FFlyoutPanel write SetFlyoutPanel;
    property LookAndFeel: TcxLookAndFeel read FLookAndFeel write SetLookAndFeel;
    property PopupControl: TWinControl read FPopupControl write SetPopupControl;
    property Alignment: TdxCalloutPopupAlignment read FAlignment write FAlignment default cpaBottomCenter;
    property Rounded: Boolean read FRounded write FRounded default False;
    property RoundRadius: Integer read FRoundRadius write FRoundRadius default 3;
    property OnHide: TNotifyEvent read FOnHide write FOnHide;
    property OnShow: TNotifyEvent read FOnShow write FOnShow;
  end;

  TdxCalloutPopup = class(TdxCustomCalloutPopup)
  published
    property AnimationOptions;
    property BorderColor;
    property Color;
    property FlyoutPanel;
    property HideCallout;
    property LookAndFeel;
    property PopupControl;
    property Alignment;
    property Rounded;
    property RoundRadius;
    property OnHide;
    property OnShow;
  end;

implementation

uses
  dxDPIAwareUtils, dxTypeHelpers;

const
  dxThisUnitName = 'dxCallOutPopup';

type
  TWinControlAccess = class(TWinControl);

function dxRightToLeftConvertCalloutPopupAlignment(const AAlignment: TdxCalloutPopupAlignment): TdxCalloutPopupAlignment;
begin
  Result := AAlignment;
  case Result of
    cpaLeftBottom:  Result := cpaRightBottom;
    cpaLeftCenter:  Result := cpaRightCenter;
    cpaLeftTop:     Result := cpaRightTop;
    cpaTopLeft:     Result := cpaTopRight;
    cpaTopRight:    Result := cpaTopLeft;
    cpaRightTop:    Result := cpaLeftTop;
    cpaRightCenter: Result := cpaLeftCenter;
    cpaRightBottom: Result := cpaLeftBottom;
    cpaBottomRight: Result := cpaBottomLeft;
    cpaBottomLeft:  Result := cpaBottomRight;
  end;
end;

function dxRightToLeftConvertFlyoutPanelAlign(const AAlign: TdxFlyoutPanelAlign): TdxFlyoutPanelAlign;
begin
  Result := AAlign;
  case Result of
    fpaLeft: Result := fpaRight;
    fpaRight: Result := fpaLeft;
  end;
end;

{ TdxCalloutPopupViewInfo }

constructor TdxCalloutPopupViewInfo.Create(
  APopup: TdxCustomCalloutPopupWindow);
begin
  inherited Create;
  FPopup := APopup;
end;

procedure TdxCalloutPopupViewInfo.Calculate(
  const ABounds: TRect);
begin
  FBounds := ABounds;
  CalculateBorderBounds;
  CalculateClientBounds;
  CalculatePopupControlBounds;

  if FIsCalloutVisible then
  begin
    CalculateCalloutBounds;
    CalculateCalloutPolygon;
  end;
end;

procedure TdxCalloutPopupViewInfo.CalculateCalloutPositionAndVisibility(
  const APopupPos, AOrigin: TPoint; const APopupSize: TSize);
begin
  if FPopup.CalloutVisible then
    DoCalculateCalloutPositionAndVisibility(APopupPos, AOrigin, APopupSize, FCalloutPosition, FIsCalloutVisible)
  else
    FIsCalloutVisible := False;
end;

procedure TdxCalloutPopupViewInfo.CalculateRequiredSize(const AAvailableSize: TSize);
begin
  FRequiredSize := DoCalculateRequiredSize(AAvailableSize);
end;

procedure TdxCalloutPopupViewInfo.Paint(ACanvas: TcxCanvas);
var
  ARegion: HRGN;
  APainter: TcxCustomLookAndFeelPainter;
  AColor: TColor;
begin
  ARegion := CreateRegion;
  if ARegion <> 0 then
  begin
    APainter := FPopup.Style.LookAndFeel.Painter;
    AColor := FPopup.Style.Color;
    if AColor = clDefault then
      AColor := APainter.DefaultContentColor;
    ACanvas.FillRegion(ARegion, AColor);
    AColor := FPopup.Style.BorderColor;
    if AColor = clDefault then
      AColor := APainter.GetContainerBorderColor(False);
    ACanvas.FrameRegion(ARegion, AColor);
    DeleteObject(ARegion);
  end;
end;

procedure TdxCalloutPopupViewInfo.CalculateBorderBounds;
begin
  FBorderBounds := DoCalculateBorderBounds;
end;

procedure TdxCalloutPopupViewInfo.CalculateCalloutBounds;
begin
  FCalloutBounds := DoCalculateCalloutBounds;
end;

procedure TdxCalloutPopupViewInfo.CalculateCalloutPolygon;
begin
  FCalloutPolygon := DoCalculateCalloutPolygon;
end;

procedure TdxCalloutPopupViewInfo.CalculateClientBounds;
begin
  FClientBounds := DoCalculateClientBounds;
end;

procedure TdxCalloutPopupViewInfo.CalculatePopupControlBounds;
begin
  FPopupControlBounds := DoCalculatePopupControlBounds;
end;

function TdxCalloutPopupViewInfo.CreateRegion: HRGN;
var
  ACalloutRegion: HRGN;
begin
  if FPopup.Rounded then
    Result := CreateRoundRectRgn(FBorderBounds.Left, FBorderBounds.Top, FBorderBounds.Right + 1, FBorderBounds.Bottom + 1, FPopup.RoundRadius, FPopup.RoundRadius)
  else
    Result := CreateRectRgnIndirect(FBorderBounds);

  if FIsCalloutVisible then
  begin
    ACalloutRegion := CreatePolygonRgn(CalloutPolygon, 3, WINDING);
    if ACalloutRegion <> 0 then
    begin
      CombineRgn(Result, Result, ACalloutRegion, RGN_OR);
      DeleteObject(ACalloutRegion);
    end;
  end;
end;

function TdxCalloutPopupViewInfo.DoCalculateBorderBounds: TRect;
begin
  Result := FBounds;
  if FPopup.Direction = pdVertical then
  begin
    if FPopup.AlignVert = pavTop then
      Dec(Result.Bottom, GetCalloutElementSize.cy)
    else
      Inc(Result.Top, GetCalloutElementSize.cy)
  end
  else
    if FPopup.AlignHorz = pahLeft then
      Dec(Result.Right, GetCalloutElementSize.cy)
    else
      Inc(Result.Left, GetCalloutElementSize.cy);
end;

function TdxCalloutPopupViewInfo.DoCalculateCalloutBounds: TRect;
begin
  Result := FBounds;
  if FPopup.Direction = pdVertical then
  begin
    if FPopup.AlignVert = pavTop then
      Result.Top := Result.Bottom - GetCalloutElementSize.cy
    else
      Result.Bottom := Result.Top + GetCalloutElementSize.cy;
    Result.Left := FCalloutPosition;
    Result.Right := Result.Left + GetCalloutElementSize.cx;
  end
  else
  begin
    if FPopup.AlignHorz = pahLeft then
      Result.Left := Result.Right - GetCalloutElementSize.cy
    else
      Result.Right := Result.Left + GetCalloutElementSize.cy;
    Result.Top := FCalloutPosition;
    Result.Bottom := Result.Top + GetCalloutElementSize.cx;
  end;
end;

function TdxCalloutPopupViewInfo.DoCalculateCalloutPolygon: TcxArrowPoints;
var
  ACalloutHalfSize: Integer;
begin
  ACalloutHalfSize := cxHalfCoordinate(GetCalloutElementSize.cx);
  if FPopup.Direction = pdVertical then
    if FPopup.AlignVert = pavTop then
    begin
      Result[0] := FCalloutBounds.TopLeft;
      Result[1] := cxPoint(FCalloutBounds.Right, FCalloutBounds.Top);
      Result[2] := cxPoint(FCalloutBounds.Left + ACalloutHalfSize,
        FCalloutBounds.Bottom);
    end
    else
    begin
      Result[0] := cxPoint(FCalloutBounds.Left, FCalloutBounds.Bottom);
      Result[1] := cxPoint(FCalloutBounds.Left + ACalloutHalfSize,
        FCalloutBounds.Top);
      Result[2] := FCalloutBounds.BottomRight;
    end
  else
    if FPopup.AlignHorz = pahLeft then
    begin
      Result[0] := cxPoint(FCalloutBounds.Left, FCalloutBounds.Bottom);
      Result[1] := FCalloutBounds.TopLeft;
      Result[2] := cxPoint(FCalloutBounds.Right,
        FCalloutBounds.Top + ACalloutHalfSize);
    end
    else
    begin
      Result[0] := FCalloutBounds.BottomRight;
      Result[1] := cxPoint(FCalloutBounds.Left,
        FCalloutBounds.Top + ACalloutHalfSize);
      Result[2] := cxPoint(FCalloutBounds.Right, FCalloutBounds.Top);
    end;
end;

procedure TdxCalloutPopupViewInfo.DoCalculateCalloutPositionAndVisibility(
  const APopupPos, AOrigin: TPoint; const APopupSize: TSize; var ACalloutPosition: Integer;
  var AIsCalloutVisible: Boolean);

  procedure DirectionIndependentCalculateCalloutPositionAndVisibility(
    ACalloutPopupSize: Integer; ACalloutPopupStartCoordinate: Integer;
    AOwnerSize: Integer; AOwnerStartCoordinate: Integer;
    var ACalloutPosition: Integer; var AIsCalloutVisible: Boolean);
  var
    ACalloutElementSize, ACalloutElementHalfSize: Integer;
    AOwnerCenterCoordinate: Integer;
    ACalloutElementMinOffset: Integer;
  begin
    ACalloutElementSize := GetCalloutElementSize.cx;
    ACalloutElementMinOffset := GetCalloutElementMinOffset;

    ACalloutElementHalfSize := cxHalfCoordinate(ACalloutElementSize);

    AIsCalloutVisible := ((ACalloutPopupSize - 2 * ACalloutElementMinOffset) >= ACalloutElementSize) and
      ((ACalloutPopupStartCoordinate + ACalloutElementMinOffset) <= (AOwnerStartCoordinate + AOwnerSize - ACalloutElementHalfSize)) and
      ((ACalloutPopupStartCoordinate + ACalloutPopupSize - ACalloutElementMinOffset) >= (AOwnerStartCoordinate + ACalloutElementHalfSize));
    if AIsCalloutVisible then
    begin
      AOwnerCenterCoordinate := AOwnerStartCoordinate + cxHalfCoordinate(AOwnerSize);
      ACalloutPosition := AOwnerCenterCoordinate - ACalloutPopupStartCoordinate - ACalloutElementHalfSize;
      ACalloutPosition := EnsureRange(ACalloutPosition, ACalloutElementMinOffset,
        ACalloutPopupSize - ACalloutElementMinOffset - ACalloutElementSize);
    end;
  end;

var
  ADesktopWorkArea, R: TRect;
begin
  ADesktopWorkArea := GetDesktopWorkArea(AOrigin);
  cxRectIntersect(R, FPopup.OwnerScreenBounds, ADesktopWorkArea);
  if FPopup.Direction = pdVertical then
    DirectionIndependentCalculateCalloutPositionAndVisibility(APopupSize.cx, APopupPos.X,
      cxRectWidth(R), R.Left, ACalloutPosition, AIsCalloutVisible)
  else
    DirectionIndependentCalculateCalloutPositionAndVisibility(APopupSize.cy, APopupPos.Y,
      cxRectHeight(R), R.Top, ACalloutPosition, AIsCalloutVisible);
end;

function TdxCalloutPopupViewInfo.DoCalculateClientBounds: TRect;
begin
  Result := cxRectContent(FBorderBounds, GetClientOffsets);
end;

function TdxCalloutPopupViewInfo.DoCalculatePopupControlBounds: TRect;
begin
  Result := FClientBounds;
end;

function TdxCalloutPopupViewInfo.DoCalculateRequiredSize(const AAvailableSize: TSize): TSize;
begin
  Result := FPopup.GetPopupControlSize;
  if FPopup.Direction = pdVertical then
    Inc(Result.cy, GetCalloutElementSize.cy)
  else
    Inc(Result.cx, GetCalloutElementSize.cy);

  Result := cxSizeAddMargins(Result, GetClientOffsets);

  if FPopup.FlyoutPanelMode then
    if FPopup.FlyoutPanelAlign in [fpaTop, fpaBottom] then
    begin
      Result.Width := FPopup.OwnerBounds.Width;
      Result.Height := Min(Result.Height, FPopup.OwnerBounds.Height);
    end
    else
    begin
      Result.Height := FPopup.OwnerBounds.Height;
      Result.Width := Min(Result.Width, FPopup.OwnerBounds.Width);
    end;
end;

function TdxCalloutPopupViewInfo.GetBorders: TRect;
begin
  Result := cxRect(1, 1, 1, 1);
end;

function TdxCalloutPopupViewInfo.GetCalloutElementMinOffset: Integer;
begin
  if FPopup.Rounded then
    Result := FPopup.RoundRadius
  else
    Result := 0;
end;

function TdxCalloutPopupViewInfo.GetCalloutElementSize: TSize;
begin
  if FPopup.CalloutVisible then
    Result := FPopup.ScaleFactor.Apply(cxSize(20, 10))
  else
    Result := cxNullSize;
end;

function TdxCalloutPopupViewInfo.GetClientOffsets: TRect;
var
  AOffset: Integer;
begin
  if FPopup.Rounded then
    AOffset := Ceil(FPopup.RoundRadius * 0.3)
  else
    AOffset := 0;

  Result := cxRectOffset(GetBorders, AOffset, AOffset);
end;

{ TdxCalloutPopupAnimationOptions }

constructor TdxCalloutPopupAnimationOptions.Create(AOwner: TPersistent);
begin
  inherited;
  ShowingAnimationTime := 200;
  HidingAnimationTime := 100;
  FFadeEffect := True;
  FMoveEffect := True;
end;

procedure TdxCalloutPopupAnimationOptions.DoAssign(Source: TPersistent);
var
  AAnimationOptions: TdxCalloutPopupAnimationOptions;
begin
  inherited DoAssign(Source);
  if Source is TdxCalloutPopupAnimationOptions then
  begin
    AAnimationOptions := TdxCalloutPopupAnimationOptions(Source);
    ShowingAnimationTime := AAnimationOptions.ShowingAnimationTime;
    HidingAnimationTime := AAnimationOptions.HidingAnimationTime;
    FFadeEffect := AAnimationOptions.FadeEffect;
    FMoveEffect := AAnimationOptions.MoveEffect;
  end;
end;

{ TdxCustomCalloutPopup }

constructor TdxCustomCalloutPopupWindow.Create(AOwnerControl: TWinControl);
begin
  inherited Create(AOwnerControl);
  FViewInfo := CreateViewInfo;
  FShowWithoutActivation := True;
  AlignHorz := pahCenter;
  FCalloutVisible := True;
end;

destructor TdxCustomCalloutPopupWindow.Destroy;
begin
  FreeAndNil(FViewInfo);
  inherited Destroy;
end;

procedure TdxCustomCalloutPopupWindow.DoShowed;
const
  AAnchors: array [TdxFlyoutPanelAlign] of TAnchors = (
    [akRight, akBottom],
    [akLeft, akTop],
    [akRight, akBottom],
    [akLeft, akBottom]);

  procedure PrepareFlyoutMoveAnimation;
  begin
    PopupControl.Anchors := AAnchors[FlyoutPanelAlign];
    if FlyoutPanelAlign in [fpaTop, fpaBottom] then
    begin
      FMoveFactor := FViewInfo.Bounds.Height/255;
      Height := 0;
    end
    else
    begin
      FMoveFactor := FViewInfo.Bounds.Width/255;
      Width := 0;
    end;
  end;

begin
  PopupControl.Align := alNone;
  PopupControl.BoundsRect := FViewInfo.PopupControlBounds;

  if FFlyoutPanelMode and MoveAnimation then
    PrepareFlyoutMoveAnimation;

  Update;
  if FadeAnimation or MoveAnimation then
    DoAnimate(atShow);
  AlphaBlend := False;
  inherited DoShowed;
end;

procedure TdxCustomCalloutPopupWindow.DoShowing;
begin
  inherited;
  AlphaBlend := True;
  AlphaBlendValue := 0;
end;

procedure TdxCustomCalloutPopupWindow.AdjustClientRect(
  var Rect: TRect);
begin
  Rect := FViewInfo.PopupControlBounds;
end;

procedure TdxCustomCalloutPopupWindow.CalculateCommonPosition(var APosition: TPoint; var AOrigin: TPoint; const ASize: TSize);
begin
  inherited CalculateCommonPosition(APosition, AOrigin, ASize);
  if AlignHorz = pahCenter then
    AOrigin.X := OwnerScreenBounds.Left;
  if AlignVert = pavCenter then
    AOrigin.Y := OwnerScreenBounds.Top;
end;

function TdxCustomCalloutPopupWindow.CalculatePosition(const ASize: TSize): TPoint;
begin
  if FFlyoutPanelMode then
  begin
    if Direction = pdHorizontal then
    begin
      Result.Y := OwnerScreenBounds.Top;
      if AlignHorz = pahLeft then
        Result.X := OwnerScreenBounds.Right - ASize.cx
      else
        Result.X := OwnerScreenBounds.Left;
    end
    else
    begin
      Result.X := OwnerScreenBounds.Left;
      if AlignVert = pavTop then
        Result.Y := OwnerScreenBounds.Bottom - ASize.cy
      else
        Result.Y := OwnerScreenBounds.Top;
    end;

    FViewInfo.CalculateCalloutPositionAndVisibility(Result, OwnerScreenBounds.TopLeft, ASize);

    if MoveAnimation then
    begin
      if Direction = pdVertical then
      begin
        FShowPosition := Result.Y;
        if FFlyoutPanelAlign = fpaBottom then
          Result.Y := Result.Y + ViewInfo.RequiredSize.cy;
      end
      else
      begin
        FShowPosition := Result.X;
        if FFlyoutPanelAlign = fpaRight then
          Result.X := Result.X + ViewInfo.RequiredSize.cx;
      end;
    end;
  end
  else
    Result := inherited CalculatePosition(ASize);
end;

function TdxCustomCalloutPopupWindow.CalculateSize: TSize;
begin
  FViewInfo.CalculateRequiredSize(cxSize(MaxInt, MaxInt));
  Result := FViewInfo.RequiredSize;
end;

procedure TdxCustomCalloutPopupWindow.CorrectPositionWithDesktopWorkArea(
  var APosition, AOrigin: TPoint; const ASize: TSize);
var
  ARect: TRect;
  ADesktopWorkArea, R: TRect;
  ADistance: Integer;
begin
  ADesktopWorkArea := GetDesktopWorkArea(AOrigin);
  cxRectIntersect(R, OwnerScreenBounds, ADesktopWorkArea);
  if (Direction = pdVertical) and (AlignHorz = pahCenter) then
  begin
    ARect := cxRectCenterHorizontally(R, ASize.cx);
    APosition.X := ARect.Left;
  end
  else
    if (Direction = pdHorizontal) and (AlignVert = pavCenter) then
    begin
      ARect := cxRectCenterVertically(R, ASize.cy);
      APosition.Y := ARect.Top;
    end;
  inherited CorrectPositionWithDesktopWorkArea(APosition, AOrigin, ASize);

  if not AcceptAnyPosition then
    if Direction = pdVertical then
      case AlignVert of
        pavTop:
          begin
            if APosition.Y < ADesktopWorkArea.Top then
              APosition.Y := ADesktopWorkArea.Top;
          end;
        pavBottom:
          begin
            if APosition.Y + ASize.cy > ADesktopWorkArea.Bottom then
              APosition.Y := ADesktopWorkArea.Bottom - ASize.cy;
          end;
      end
    else
      case AlignHorz of
        pahLeft:
          begin
            if APosition.X < ADesktopWorkArea.Left then
              APosition.X := ADesktopWorkArea.Left;
          end;
        pahRight:
          begin
            if APosition.X + ASize.cx > ADesktopWorkArea.Right then
              APosition.X := ADesktopWorkArea.Right - ASize.cx;
          end;
    end;

  FViewInfo.CalculateCalloutPositionAndVisibility(APosition, AOrigin, ASize);
  if MoveAnimation then
  begin
    ADistance := ViewInfo.GetCalloutElementSize.cy;
    if Direction = pdVertical then
    begin
      FShowPosition := APosition.Y;
      ADistance := Min(ADistance, cxHalfCoordinate(cxRectHeight(OwnerBounds)));
      if AlignVert = pavTop then
        APosition.Y := APosition.Y + ADistance
      else
        APosition.Y := APosition.Y - ADistance;
      FMoveFactor := (APosition.Y - FShowPosition)/255;
    end
    else
    begin
      FShowPosition := APosition.X;
      ADistance := Min(ADistance, cxHalfCoordinate(cxRectWidth(OwnerBounds)));
      if AlignHorz = pahLeft then
        APosition.X := APosition.X + ADistance
      else
        APosition.X := APosition.X - ADistance;
      FMoveFactor := (APosition.X - FShowPosition)/255;
    end;
  end;
end;

function TdxCustomCalloutPopupWindow.CreateViewInfo: TdxCalloutPopupViewInfo;
begin
  Result := TdxCalloutPopupViewInfo.Create(Self);
end;

procedure TdxCustomCalloutPopupWindow.DoClosed;
begin
  RestorePopupControlData;
  ActiveControl := nil;
  inherited DoClosed;
end;

procedure TdxCustomCalloutPopupWindow.DoClosing;
begin
  inherited DoClosing;
  FPrevPopupControlData.ActiveControl := ActiveControl;
  if FadeAnimation or FlyoutPanelMode and MoveAnimation then
    DoAnimate(atHide);
end;

procedure TdxCustomCalloutPopupWindow.DoHideAnimation(
  Sender: TdxAnimationTransition; var APosition: Integer;
  var AFinished: Boolean);
begin
  if FPosition = APosition then
    Exit;
  FPosition := APosition;
  if FadeAnimation then
    AlphaBlendValue := 255 - APosition;

  if MoveAnimation and FlyoutPanelMode then
    DoFlyoutPanelMoveAnimation(APosition);
end;

procedure TdxCustomCalloutPopupWindow.DoShowAnimation(
  Sender: TdxAnimationTransition; var APosition: Integer;
  var AFinished: Boolean);
var
  ANextPosition: Integer;
begin
  if FPosition = APosition then
    Exit;
  FPosition := APosition;

  if FadeAnimation then
    AlphaBlendValue := APosition
  else
    AlphaBlendValue := 255;

  if MoveAnimation then
  begin
    if FlyoutPanelMode then
      DoFlyoutPanelMoveAnimation(255 - APosition)
    else
    begin
      ANextPosition := FShowPosition + Trunc(FMoveFactor * (255 - APosition));
      if Direction = pdVertical then
        Top := ANextPosition
      else
        Left := ANextPosition;
    end;
  end;
end;

procedure TdxCustomCalloutPopupWindow.InitPopup;
begin
  inherited InitPopup;
  SavePopupControlData;
  dxAssignFont(Font, TWinControlAccess(PopupControl).Font, ScaleFactor, dxGetScaleFactor(GetParentForm(PopupControl)));
  PopupControl.Parent := Self;
  PopupControl.Visible := True;
  Width := 0; 
end;

procedure TdxCustomCalloutPopupWindow.InternalCalculateHorizontalDirectionPosition(
  var APosition, AOrigin: TPoint; const ASize: TSize);
begin
  inherited;
  if cxRectHeight(OwnerScreenBounds) < ViewInfo.GetCalloutElementSize.cx then
    if AlignVert = pavTop then
      APosition.Y := cxRectCenter(OwnerScreenBounds).Y - cxHalfCoordinate(ViewInfo.GetCalloutElementSize.cx)
    else
      if AlignVert = pavBottom then
        APosition.Y := cxRectCenter(OwnerScreenBounds).Y + cxHalfCoordinate(ViewInfo.GetCalloutElementSize.cx) - ASize.cy;
end;

procedure TdxCustomCalloutPopupWindow.InternalCalculateVerticalDirectionPosition(
  var APosition, AOrigin: TPoint; const ASize: TSize);
begin
  inherited;
  if cxRectWidth(OwnerScreenBounds) < ViewInfo.GetCalloutElementSize.cx then
    if AlignHorz = pahLeft then
      APosition.X := cxRectCenter(OwnerScreenBounds).X - cxHalfCoordinate(ViewInfo.GetCalloutElementSize.cx)
    else
      if AlignHorz = pahRight then
        APosition.X := cxRectCenter(OwnerScreenBounds).X + cxHalfCoordinate(ViewInfo.GetCalloutElementSize.cx) - ASize.cx;
end;

procedure TdxCustomCalloutPopupWindow.Paint;
begin
  FViewInfo.Paint(Canvas);
end;

procedure TdxCustomCalloutPopupWindow.Resize;
begin
  inherited Resize;
  FViewInfo.Calculate(ClientRect);
  SetWindowRgn(Handle, FViewInfo.CreateRegion, True);
end;

procedure TdxCustomCalloutPopupWindow.ScaleFactorChanged(M, D: Integer);
begin
  inherited;
  RoundRadius := MulDiv(RoundRadius, M, D);
end;

function TdxCustomCalloutPopupWindow.UseOwnerParentToGetScreenBounds: Boolean;
begin
  Result := True;
end;

function TdxCustomCalloutPopupWindow.GetPopupControlSize: TSize;
begin
  Result := ScaleFactor.Apply(cxSize(FPrevPopupControlData.Bounds));
end;

procedure TdxCustomCalloutPopupWindow.DoAnimate(AAnimationType: TdxCalloutPopupAnimationType);
begin
  FPosition := -1;
  with TdxAnimationTransition.Create(AnimationTime[AAnimationType], TransitionEffect, 255) do
  begin
    if AAnimationType = atShow then
      OnAnimate := DoShowAnimation
    else
      OnAnimate := DoHideAnimation;
    ImmediateAnimation;
  end;
end;

procedure TdxCustomCalloutPopupWindow.DoFlyoutPanelMoveAnimation(APosition: Integer);
var
  ANextPosition, ANextSize: Integer;
  R: TRect;
begin
  R := BoundsRect;

  ANextSize := Round(FMoveFactor * (255 - APosition));
  if Direction = pdVertical then
    R.Height := ANextSize
  else
    R.Width := ANextSize;

  if FFlyoutPanelAlign in [fpaRight, fpaBottom] then
  begin
    ANextPosition := FShowPosition + Round(FMoveFactor * APosition);
    if FFlyoutPanelAlign = fpaRight then
      R := cxRectSetLeft(R, ANextPosition)
    else
      R := cxRectSetTop(R, ANextPosition);
  end;

  BoundsRect := R;
  Refresh;
end;

function TdxCustomCalloutPopupWindow.GetAnimationTime(AnimationType: TdxCalloutPopupAnimationType): Cardinal;
begin
  Result := FAnimationTime[AnimationType];
end;

procedure TdxCustomCalloutPopupWindow.RestorePopupControlData;
begin
  if PopupControl <> nil then
  begin
    while (FPrevPopupControlData.ActiveControl <> nil) and (FPrevPopupControlData.ActiveControl <> Self) do
    begin
      FPrevPopupControlData.ActiveControl.Perform(CM_EXIT, 0, 0);
      FPrevPopupControlData.ActiveControl := FPrevPopupControlData.ActiveControl.Parent;
    end;
    PopupControl.Visible := False;
    InternalEnableWindow(False);
    try
      PopupControl.Parent := FPrevPopupControlData.Parent;
    finally
      InternalEnableWindow(True);
    end;
    if PopupControl is TCustomForm then
      TCustomForm(PopupControl).BorderStyle := FPrevPopupControlData.BorderStyle;
    PopupControl.Align := FPrevPopupControlData.Align;
    PopupControl.BoundsRect := dxGetScaleFactor(PopupControl).Apply(FPrevPopupControlData.Bounds);
    PopupControl.Visible := FPrevPopupControlData.Visible;
  end;
end;

procedure TdxCustomCalloutPopupWindow.SavePopupControlData;
begin
  FPrevPopupControlData.Align := PopupControl.Align;
  if PopupControl is TCustomForm then
  begin
    FPrevPopupControlData.BorderStyle := TCustomForm(PopupControl).BorderStyle;
    TCustomForm(PopupControl).BorderStyle := bsNone;
  end;
  FPrevPopupControlData.Bounds := dxGetScaleFactor(PopupControl).Revert(PopupControl.BoundsRect);
  FPrevPopupControlData.Parent := PopupControl.Parent;
  FPrevPopupControlData.Visible := PopupControl.Visible;
  FPrevPopupControlData.ActiveControl := nil;
end;

procedure TdxCustomCalloutPopupWindow.SetAnimationTime(
  AnimationType: TdxCalloutPopupAnimationType; const Value: Cardinal);
begin
  FAnimationTime[AnimationType] := Value;
end;

{ TdxFlyoutPanel }

procedure TdxFlyoutPanel.DoAssign(Source: TPersistent);
begin
  inherited DoAssign(Source);
  if Source is TdxFlyoutPanel then
  begin
    Active := TdxFlyoutPanel(Source).Active;
    Align := TdxFlyoutPanel(Source).Align;
  end;
end;

{ TdxCalloutPopup }

constructor TdxCustomCalloutPopup.Create(Owner: TComponent);
begin
  inherited;
  FAnimationOptions := TdxCalloutPopupAnimationOptions.Create(Self);
  FLookAndFeel := TcxLookAndFeel.Create(nil);
  FRoundRadius := 3;
  FAlignment := cpaBottomCenter;
  FColor := clDefault;
  FBorderColor := clDefault;
  FFlyoutPanel := TdxFlyoutPanel.Create(Self);
end;

destructor TdxCustomCalloutPopup.Destroy;
begin
  DestroyPopup;
  FreeAndNil(FFlyoutPanel);
  FreeAndNil(FLookAndFeel);
  FreeAndNil(FAnimationOptions);
  inherited;
end;

procedure TdxCustomCalloutPopup.Assign(Source: TPersistent);
var
  ACalloutPopup: TdxCustomCalloutPopup;
begin
  if Source is TdxCustomCalloutPopup then
  begin
    ACalloutPopup := TdxCustomCalloutPopup(Source);
    AnimationOptions := ACalloutPopup.AnimationOptions;
    Alignment := ACalloutPopup.Alignment;
    Color := ACalloutPopup.Color;
    BorderColor := ACalloutPopup.BorderColor;
    LookAndFeel := ACalloutPopup.LookAndFeel;
    PopupControl := ACalloutPopup.PopupControl;
    Rounded := ACalloutPopup.Rounded;
    RoundRadius := ACalloutPopup.RoundRadius;
    FlyoutPanel := ACalloutPopup.FlyoutPanel;
  end
  else
    inherited Assign(Source);
end;

procedure TdxCustomCalloutPopup.Close;
begin
  if FCallout <> nil then
    FCallout.CloseUp;
end;

function TdxCustomCalloutPopup.IsVisible: Boolean;
begin
  Result := (FCallout <> nil) and FCallout.IsVisible;
end;

procedure TdxCustomCalloutPopup.Popup(AOwnerControl: TWinControl);
begin
  Popup(AOwnerControl, AOwnerControl.ClientRect);
end;

procedure TdxCustomCalloutPopup.Popup(AOwnerControl: TWinControl; const AOwnerBounds: TRect);
begin
  if CanPopup(AOwnerControl) then
  begin
    if (PopupControl = AOwnerControl) or IsRelatedWindow(PopupControl, AOwnerControl.Handle) then
      raise EdxException.Create(SCircularReferencingError);
    RecreatePopupIfNeeded(AOwnerControl);
    CloseUnrelatedPopups(AOwnerControl.Handle);
    if FCallout.IsVisible then
      FCallout.CloseUp;
    FCallout.OwnerBounds := AOwnerBounds;
    FCallout.OwnerParent := AOwnerControl;
    FCallout.BiDiMode := AOwnerControl.BiDiMode;
    InitializeCalloutWindow;
    FCallout.Popup(nil);
  end;
end;

function TdxCustomCalloutPopup.CreatePopupWindow(AOwnerControl: TWinControl): TdxCustomCalloutPopupWindow;
begin
  Result := TdxCustomCalloutPopupWindow.Create(AOwnerControl);
end;

procedure TdxCustomCalloutPopup.InitializeCalloutWindow;
var
  AActualAlignment: TdxCalloutPopupAlignment;
begin
  FCallout.AcceptAnyPosition := AcceptAnyPosition or FFlyoutPanel.Active;
  FCallout.FadeAnimation := AnimationOptions.FadeEffect;
  FCallout.MoveAnimation := AnimationOptions.MoveEffect;
  FCallout.FlyoutPanelMode := FFlyoutPanel.Active;
  if FCallout.UseRightToLeftAlignment then
    FCallout.FlyoutPanelAlign := dxRightToLeftConvertFlyoutPanelAlign(FlyoutPanel.Align)
  else
    FCallout.FlyoutPanelAlign := FlyoutPanel.Align;
  FCallout.AnimationTime[atShow] := AnimationOptions.ShowingAnimationTime;
  FCallout.AnimationTime[atHide] := AnimationOptions.HidingAnimationTime;
  FCallout.Rounded := Rounded;
  FCallout.RoundRadius := FCallout.ScaleFactor.Apply(RoundRadius);
  FCallout.Style.LookAndFeel := LookAndFeel;
  FCallout.Style.BorderColor := BorderColor;
  FCallout.Style.Color := Color;
  FCallout.FShowWithoutActivation := False;
  FCallout.ModalMode := False;
  if FCallout.UseRightToLeftAlignment then
    AActualAlignment := dxRightToLeftConvertCalloutPopupAlignment(FAlignment)
  else
    AActualAlignment := FAlignment;
  if FFlyoutPanel.Active then
  begin
    if FCallout.FlyoutPanelAlign in [fpaTop, fpaBottom] then
    begin
      FCallout.Direction := pdVertical;
      FCallout.AlignHorz := pahCenter;
    end
    else
    begin
      FCallout.Direction := pdHorizontal;
      FCallout.AlignVert := pavCenter;
    end;
    case FCallout.FlyoutPanelAlign of
      fpaTop: FCallout.AlignVert := pavBottom;
      fpaBottom: FCallout.AlignVert := pavTop;
      fpaLeft: FCallout.AlignHorz := pahRight;
      fpaRight: FCallout.AlignHorz := pahLeft;
    end;
  end
  else
  begin
    case AActualAlignment of
      cpaTopLeft..cpaTopRight, cpaLeftTop, cpaRightTop:
        FCallout.AlignVert := pavTop;
      cpaLeftCenter, cpaRightCenter:
        FCallout.AlignVert := pavCenter
    else
      FCallout.AlignVert := pavBottom;
    end;
    case AActualAlignment of
      cpaRightTop..cpaRightBottom, cpaTopRight, cpaBottomRight:
        FCallout.AlignHorz := pahRight;
      cpaTopCenter, cpaBottomCenter:
        FCallout.AlignHorz := pahCenter
    else
      FCallout.AlignHorz := pahLeft;
    end;
    case AActualAlignment of
      cpaLeftBottom..cpaLeftTop, cpaRightTop..cpaRightBottom:
        FCallout.Direction := pdHorizontal
    else
      FCallout.Direction := pdVertical;
    end;
  end;
  FCallout.CalloutVisible := not HideCallout and not FlyoutPanel.Active;
  FCallout.PopupControl := PopupControl;
  FCallout.OnClosed := DoPopupClosed;
  FCallout.OnShowed := DoPopupShowed;
end;

procedure TdxCustomCalloutPopup.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
    if AComponent = FPopupControl then
      PopupControl := nil
    else
      if (FCallout <> nil) and
        (AComponent = FCallout.OwnerControl) then
        DestroyPopup;
end;

function TdxCustomCalloutPopup.CanPopup(AOwnerControl: TWinControl): Boolean;
begin
  Result := (AOwnerControl <> nil) and AOwnerControl.HandleAllocated and (PopupControl <> nil);
end;

procedure TdxCustomCalloutPopup.DestroyPopup;
begin
  FreeAndNil(FCallout);
end;

procedure TdxCustomCalloutPopup.DoPopupClosed(Sender: TObject);
begin
  if Assigned(FOnHide) then
    dxCallNotify(FOnHide, Self);
end;

procedure TdxCustomCalloutPopup.DoPopupShowed(Sender: TObject);
begin
  if Assigned(FOnShow) then
    dxCallNotify(FOnShow, Self);
end;

procedure TdxCustomCalloutPopup.RecreatePopupIfNeeded(AOwnerControl: TWinControl);
begin
  if (FCallout = nil) or
    (FCallout.OwnerControl <> AOwnerControl) then
  begin
    if FCallout <> nil then
    begin
      FCallout.OwnerControl.RemoveFreeNotification(Self);
      DestroyPopup;
    end;
    FCallout := CreatePopupWindow(AOwnerControl);
    FCallout.OwnerControl.FreeNotification(Self);
  end;
end;

procedure TdxCustomCalloutPopup.SetAnimationOptions(
  const Value: TdxCalloutPopupAnimationOptions);
begin
  FAnimationOptions.Assign(Value);
end;

procedure TdxCustomCalloutPopup.SetFlyoutPanel(const AValue: TdxFlyoutPanel);
begin
  FFlyoutPanel.Assign(AValue);
end;

procedure TdxCustomCalloutPopup.SetLookAndFeel(const Value: TcxLookAndFeel);
begin
  FLookAndFeel.Assign(Value);
end;

procedure TdxCustomCalloutPopup.SetPopupControl(AValue: TWinControl);
begin
  if FPopupControl <> AValue then
  begin
    DestroyPopup;
    if FPopupControl <> nil then
      FPopupControl.RemoveFreeNotification(Self);
    FPopupControl := AValue;
    if FPopupControl <> nil then
      FPopupControl.FreeNotification(Self);
  end;
end;

end.
