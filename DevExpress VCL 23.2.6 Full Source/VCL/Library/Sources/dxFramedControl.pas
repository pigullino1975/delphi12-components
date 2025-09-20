{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressCommonLibrary                                     }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSCOMMONLIBRARY AND ALL          }
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

unit dxFramedControl;

{$I cxVer.inc}

interface

uses
  Types, Messages, Windows, Classes, Graphics, Controls, cxGeometry, cxControls, cxCustomCanvas, cxGraphics, cxLookAndFeels,
  dxCoreClasses;

type
  TdxDragBorderEvent = reference to procedure(AControl: TControl; ABorder: TcxBorder; var ADone: Boolean); // for internal use

  IdxControlDefaultColorHelper = interface // for internal use
  ['{22C5E77A-136F-4108-A313-EF1CBF856329}']
    function IsDefaultColor: Boolean;
  end;

  IdxControlDragBorderHelper = interface // for internal use
  ['{7A9BFA5C-1A1C-4200-951B-39E2EB9BC1EE}']
    function GetAutoDetectBorders: Boolean;
    function GetBorderSizes: TRect;
    function GetBorders: TcxBorders;
    function GetControl: TWinControl;
    function GetDetectionAreaSize: Integer;
    function GetEnabled: Boolean;
    function GetScaledDetectionAreaSize: Integer;
    function GetSizingEvent: TdxDragBorderEvent;
    procedure SetAutoDetectBorders(AValue: Boolean);
    procedure SetBorderSizes(const AValue: TRect);
    procedure SetBorders(const AValue: TcxBorders);
    procedure SetEnabled(AValue: Boolean);
    procedure SetDetectionAreaSize(AValue: Integer);
    procedure SetSizingEvent(AValue: TdxDragBorderEvent);
    property AutoDetectBorders: Boolean read GetAutoDetectBorders write SetAutoDetectBorders;
    property Borders: TcxBorders read GetBorders write SetBorders;
    property Control: TWinControl read GetControl;
    property DetectionAreaSize: Integer read GetDetectionAreaSize write SetDetectionAreaSize;
    property DragBorderEvent: TdxDragBorderEvent read GetSizingEvent write SetSizingEvent;
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property ScaledDetectionAreaSize: Integer read GetScaledDetectionAreaSize;
    property BorderSizes: TRect read GetBorderSizes write SetBorderSizes;
  end;

  TdxFramedControl = class;

  TdxControlFrameDragOptions = class(TcxInterfacedPersistent)
  public const DefaultDetectionAreaSize = 4;
  strict private
    FControl: TdxFramedControl;
    FEnabled: Boolean;
    function GetBorders: TcxBorders;
    function GetEnabled: Boolean;
    function GetDetectionAreaSize: Integer;
    function GetAutoDetectBorders: Boolean;
    procedure SetBorders(const AValue: TcxBorders);
    procedure SetEnabled(AValue: Boolean);
    procedure SetDetectionAreaSize(AValue: Integer);
    procedure SetAutoDetectBorders(const AValue: Boolean);
  protected
    procedure AssignTo(ADest: TPersistent); override;
    property Control: TdxFramedControl read FControl;
  public
    constructor Create(AControl: TdxFramedControl); reintroduce;
  published
    property AutoDetectBorders: Boolean read GetAutoDetectBorders write SetAutoDetectBorders default True;
    property Borders: TcxBorders read GetBorders write SetBorders default [];
    property DetectionAreaSize: Integer read GetDetectionAreaSize write SetDetectionAreaSize default DefaultDetectionAreaSize;
    property Enabled: Boolean read GetEnabled write SetEnabled default False;
  end;

  TdxControlFrameOptions = class(TcxInterfacedPersistent)
  public const ScaleByDefault = False; // for internal use
  strict private
    FControl: TdxFramedControl;
    FColor: TColor;
    FBorders: TcxBorders;
    FVisible: Boolean;
    FDrawInNonClientArea: Boolean;
    FDrag: TdxControlFrameDragOptions;
    FThickness: Integer;
    FScale: Boolean;
    FScaledThickness: Integer;
    function GetScaledThickness: Integer;
    procedure SetColor(AValue: TColor);
    procedure SetBorders(const AValue: TcxBorders);
    procedure SetVisible(AValue: Boolean);
    procedure SetDrawInNonClientArea(AValue: Boolean);
    procedure SetDrag(const AValue: TdxControlFrameDragOptions);
    procedure SetThickness(AValue: Integer);
    procedure SetScale(const AValue: Boolean);
  protected
    procedure AssignTo(ADest: TPersistent); override;
    procedure ScaleFactorChanged;
    procedure ClearScaledThickness;
    property Control: TdxFramedControl read FControl;
  public
    constructor Create(AControl: TdxFramedControl); reintroduce;
    destructor Destroy; override;
    property ScaledThickness: Integer read GetScaledThickness;
  published
    property Color: TColor read FColor write SetColor default clDefault;
    property Borders: TcxBorders read FBorders write SetBorders default cxBordersAll;
    property Drag: TdxControlFrameDragOptions read FDrag write SetDrag;
    property DrawInNonClientArea: Boolean read FDrawInNonClientArea write SetDrawInNonClientArea default True;
    property Scale: Boolean read FScale write SetScale default ScaleByDefault;
    property Thickness: Integer read FThickness write SetThickness default 1;
    property Visible: Boolean read FVisible write SetVisible default True;
  end;

  TdxFramedControlDragBorderEvent = procedure(ASender: TdxFramedControl; ABorder: TcxBorder; var ADone: Boolean) of object;

  TdxFramedControl = class(TcxControl, IdxControlDefaultColorHelper)
  strict private
    FFrame: TdxControlFrameOptions;
    FDragBorderHelper: IdxControlDragBorderHelper;
    FOnDragBorder: TdxFramedControlDragBorderEvent;
    FColorIsDefault: Boolean;
    procedure DrawFrame(ACanvas: TcxCustomCanvas);
    function GetActualColor: TColor;
    function GetClientOffset(ABorder: TcxBorder): Integer;
    function GetColor: TColor;
    procedure InternalAdjustClientRect(var ARect: TRect);
    procedure SetColor(AValue: TColor);
    procedure SetFrame(const AValue: TdxControlFrameOptions);
    procedure SetOnDragBorder(const AValue: TdxFramedControlDragBorderEvent);
    procedure CMInvalidate(var AMessage: TMessage); message CM_INVALIDATE;
    procedure CMIsToolControl(var AMessage: TMessage); message CM_ISTOOLCONTROL;
    procedure CMParentColorChanged(var AMessage: TMessage); message CM_PARENTCOLORCHANGED;
    procedure WMEraseBkgnd(var AMessage: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMNCCalcSize(var AMessage: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure WMNCPaint(var AMessage: TWMNCPaint); message WM_NCPAINT;
  protected
    procedure AdjustClientRect(var ARect: TRect); override;
    procedure CreateWindowHandle(const Params: TCreateParams); override;
    function FluentDesignContainerControlCanBeOpaque: Boolean; override;
    procedure DoNonClientPaint(AWindowDC: HDC); override;
    procedure DoPaint; override;
    procedure DrawBorder(ACanvas: TcxCustomCanvas); override;
    function GetBorderSize: Integer; override;
    function GetClientBounds: TRect; override;
    function GetDefaultColor: TColor; virtual; abstract;
    function HasNonClientArea: Boolean; override;
    procedure Loaded; override;
    procedure LookAndFeelChanged(Sender: TcxLookAndFeel; AChangedValues: TcxLookAndFeelValues); override;
    function NeedRedrawOnResize: Boolean; override;
    function NeedsScrollBars: Boolean; override;
    procedure PaintNonClientArea(ACanvas: TcxCanvas); override;
    procedure ScaleFactorChanged; override;
    procedure SetPaintRegion; override;
    procedure FrameColorChanged;
    procedure FrameStyleChanged(AHard: Boolean);
    function ParentHasRtlLayout: Boolean;
    function RtlConvertBorders(const ABorders: TcxBorders): TcxBorders;
    { IdxControlDefaultColorHelper }
    function IsDefaultColor: Boolean;
  protected
    property DragBorderHelper: IdxControlDragBorderHelper read FDragBorderHelper;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Frame: TdxControlFrameOptions read FFrame write SetFrame;
    property Color: TColor read GetColor write SetColor;
    property OnDragBorder: TdxFramedControlDragBorderEvent read FOnDragBorder write SetOnDragBorder;
  end;

implementation

uses
  SysUtils, dxGenerics, dxDPIAwareUtils, Contnrs, dxTypeHelpers, dxMessages, dxCustomFluentDesignForm,
  Vcl.Forms;

const
  dxThisUnitName = 'dxFramedControl';

type
  TdxChildControlWndProcHelperList = class;
  TdxControlDragBorderHelper = class;

  TdxControlWndProcHelper = class(TInterfacedObject)
  protected
    FDragBorderHelper: TdxControlDragBorderHelper;
    FWindowProcObject: TcxWindowProcLinkedObject;
    FControl: TWinControl;
    FChildren: TdxChildControlWndProcHelperList;
    procedure DoWndProc(var AMessage: TMessage);
    procedure RegisterChildHooks;
    procedure UnRegisterChildHooks;
    procedure WndProc(var AMessage: TMessage); virtual;
  public
    constructor Create(AControl: TWinControl; ADragBorderHelper: TdxControlDragBorderHelper);
    destructor Destroy; override;
    property Control: TWinControl read FControl;
  end;

  TdxChildControlWndProcHelper = class(TdxControlWndProcHelper)
  protected
    procedure WndProc(var AMessage: TMessage); override;
  public
    constructor Create(AControl: TWinControl; ADragBorderHelper: TdxControlDragBorderHelper);
  end;

  TdxChildControlWndProcHelperList = class(TdxObjectList<TdxChildControlWndProcHelper>)
  public
    procedure RemoveByControl(AControl: TWinControl);
  end;

  TdxControlDragBorderHelper = class(TdxControlWndProcHelper, IdxControlDragBorderHelper)
  strict private
    FEnabled: Boolean;
    FBorders: TcxBorders;
    FDragBorderEvent: TdxDragBorderEvent;
    FLastHitTestedBorder: TcxBorder;
    FInSizing: Boolean;
    FDetectionAreaSize: Integer;
    FScaledDetectionAreaSize: Integer;
    FAutoDetectBorders: Boolean;
    FBorderSizes: TRect;
    procedure CalcScaledDetectionAreaSize;
  protected
    function GetBorderAtPos(const APos: TPoint; out ABorder: TcxBorder): Boolean;
    procedure WndProc(var AMessage: TMessage); override;
    { IdxControlDragBorderHelper }
    function GetAutoDetectBorders: Boolean;
    function GetBorderSizes: TRect;
    function GetBorders: TcxBorders;
    function GetControl: TWinControl;
    function GetDetectionAreaSize: Integer;
    function GetEnabled: Boolean;
    function GetScaledDetectionAreaSize: Integer;
    function GetSizingEvent: TdxDragBorderEvent;
    procedure SetAutoDetectBorders(AValue: Boolean);
    procedure SetBorderSizes(const AValue: TRect);
    procedure SetBorders(const AValue: TcxBorders);
    procedure SetDetectionAreaSize(AValue: Integer);
    procedure SetEnabled(AValue: Boolean);
    procedure SetSizingEvent(AValue: TdxDragBorderEvent);
  public
    constructor Create(AControl: TWinControl; AAutoDetectBorders: Boolean; const ABorders: TcxBorders;
      AAreaSize: Integer; ADragBorderEvent: TdxDragBorderEvent); reintroduce;
  end;

  TWinControlAccess = class(TWinControl);

{ TdxControlFrameOptions }

procedure TdxControlFrameOptions.ClearScaledThickness;
begin
  FScaledThickness := -1;
end;

constructor TdxControlFrameOptions.Create(AControl: TdxFramedControl);
begin
  inherited Create(nil);
  FControl := AControl;
  FDrag := TdxControlFrameDragOptions.Create(Control);
  FScaledThickness := -1;
  FColor := clDefault;
  FBorders := cxBordersAll;
  FVisible := True;
  FThickness := 1;
  FScale := ScaleByDefault;
  FDrawInNonClientArea := True;
end;

destructor TdxControlFrameOptions.Destroy;
begin
  FreeAndNil(FDrag);
  inherited Destroy;
end;

procedure TdxControlFrameOptions.AssignTo(ADest: TPersistent);
var
  ADestObj: TdxControlFrameOptions;
begin
  if ADest is TdxControlFrameOptions then
  begin
    ADestObj := ADest as TdxControlFrameOptions;
    ADestObj.Color := Self.Color;
    ADestObj.Borders := Self.Borders;
    ADestObj.DrawInNonClientArea := Self.DrawInNonClientArea;
    ADestObj.Scale := Self.Scale;
    ADestObj.Thickness := Self.Thickness;
    ADestObj.Visible := Self.Visible;
    Self.Drag.AssignTo(ADestObj.Drag);
  end
  else
    inherited AssignTo(ADest);
end;

function TdxControlFrameOptions.GetScaledThickness: Integer;
begin
  if FScale then
  begin
    if FScaledThickness = -1 then
      FScaledThickness := Control.ScaleFactor.Apply(FThickness);
    Result := FScaledThickness;
  end
  else
    Result := FThickness;
end;

procedure TdxControlFrameOptions.ScaleFactorChanged;
begin
  if FScale then
    Control.FrameStyleChanged(DrawInNonClientArea and Visible and (Borders <> []));
end;

procedure TdxControlFrameOptions.SetBorders(const AValue: TcxBorders);
begin
  if FBorders <> AValue then
  begin
    FBorders:= AValue;
    Control.FrameStyleChanged(DrawInNonClientArea and Visible);
  end;
end;

procedure TdxControlFrameOptions.SetColor(AValue: TColor);
begin
  if FColor <> AValue then
  begin
    FColor := AValue;
    Control.FrameColorChanged;
  end;
end;

procedure TdxControlFrameOptions.SetDrag(
  const AValue: TdxControlFrameDragOptions);
begin
  FDrag.Assign(AValue);
end;

procedure TdxControlFrameOptions.SetDrawInNonClientArea(AValue: Boolean);
begin
  if FDrawInNonClientArea <> AValue then
  begin
    FDrawInNonClientArea := AValue;
    Control.FrameStyleChanged(Visible and (Borders <> []))
  end;
end;

procedure TdxControlFrameOptions.SetScale(const AValue: Boolean);
begin
  if FScale <> AValue then
  begin
    FScale := AValue;
    Control.FrameStyleChanged(DrawInNonClientArea and Visible and (Borders <> []))
  end;
end;

procedure TdxControlFrameOptions.SetThickness(AValue: Integer);
begin
  if AValue < 1 then
    AValue := 1;
  if FThickness <> AValue then
  begin
    FThickness := AValue;
    Control.FrameStyleChanged(DrawInNonClientArea and Visible and (Borders <> []))
  end;
end;

procedure TdxControlFrameOptions.SetVisible(AValue: Boolean);
begin
  if FVisible <> AValue then
  begin
    FVisible := AValue;
    Control.FrameStyleChanged(DrawInNonClientArea and (Borders <> []))
  end;
end;

{ TdxControlFrameDragOptions }

constructor TdxControlFrameDragOptions.Create(AControl: TdxFramedControl);
begin
  inherited Create(nil);
  FControl := AControl;
  DetectionAreaSize := DefaultDetectionAreaSize;
  AutoDetectBorders := True;
end;

function TdxControlFrameDragOptions.GetAutoDetectBorders: Boolean;
begin
  Result := Control.DragBorderHelper.AutoDetectBorders;
end;

function TdxControlFrameDragOptions.GetBorders: TcxBorders;
begin
  Result := Control.DragBorderHelper.Borders;
end;

function TdxControlFrameDragOptions.GetDetectionAreaSize: Integer;
begin
  Result := Control.DragBorderHelper.DetectionAreaSize;
end;

function TdxControlFrameDragOptions.GetEnabled: Boolean;
begin
  if Control.IsDesigning then
    Result := FEnabled
  else
    Result := Control.DragBorderHelper.Enabled;
end;

procedure TdxControlFrameDragOptions.AssignTo(ADest: TPersistent);
var
  ADestObj: TdxControlFrameDragOptions;
begin
  if ADest is TdxControlFrameDragOptions then
  begin
    ADestObj := ADest as TdxControlFrameDragOptions;
    ADestObj.AutoDetectBorders := Self.AutoDetectBorders;
    ADestObj.DetectionAreaSize := Self.DetectionAreaSize;
    ADestObj.Borders := Self.Borders;
    ADestObj.Enabled := Self.Enabled;
  end
  else
    inherited AssignTo(ADest);
end;

procedure TdxControlFrameDragOptions.SetAutoDetectBorders(const AValue: Boolean);
begin
  Control.DragBorderHelper.AutoDetectBorders := AValue;
end;

procedure TdxControlFrameDragOptions.SetDetectionAreaSize(AValue: Integer);
begin
  Control.DragBorderHelper.DetectionAreaSize := AValue;
end;

procedure TdxControlFrameDragOptions.SetBorders(const AValue: TcxBorders);
begin
  Control.DragBorderHelper.Borders := AValue;
end;

procedure TdxControlFrameDragOptions.SetEnabled(AValue: Boolean);
begin
  if Control.IsDesigning then
    FEnabled := AValue
  else
    Control.DragBorderHelper.Enabled := AValue;
end;

{ TdxControlWndProcHelper }

constructor TdxControlWndProcHelper.Create(AControl: TWinControl; ADragBorderHelper: TdxControlDragBorderHelper);
begin
  inherited Create;
  FControl := AControl;
  FDragBorderHelper := ADragBorderHelper;
  FChildren := TdxChildControlWndProcHelperList.Create;
end;

destructor TdxControlWndProcHelper.Destroy;
begin
  FChildren.Free;
  cxWindowProcController.Remove(FWindowProcObject);
  inherited Destroy;
end;

procedure TdxControlWndProcHelper.DoWndProc(var AMessage: TMessage);
begin
  WndProc(AMessage);
end;

procedure TdxControlWndProcHelper.RegisterChildHooks;
var
  I: Integer;
  AControl: TControl;
begin
  for I := 0 to FControl.ControlCount - 1 do
  begin
    AControl := FControl.Controls[I];
    if AControl is TWinControl then
      FChildren.Add(TdxChildControlWndProcHelper.Create(TWinControl(AControl), FDragBorderHelper));
  end;
end;

procedure TdxControlWndProcHelper.UnRegisterChildHooks;
begin
  FChildren.Clear;
end;

procedure TdxControlWndProcHelper.WndProc(var AMessage: TMessage);
begin
  FWindowProcObject.DefaultProc(AMessage);
end;

{ TdxChildControlWndProcHelperList }

procedure TdxChildControlWndProcHelperList.RemoveByControl(AControl: TWinControl);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if Items[I].Control = AControl then
    begin
      Delete(I);
      Exit;
    end;
end;

{ TdxChildControlWndProcHelper }

constructor TdxChildControlWndProcHelper.Create(AControl: TWinControl;
  ADragBorderHelper: TdxControlDragBorderHelper);
begin
  inherited Create(AControl, ADragBorderHelper);
  FWindowProcObject := cxWindowProcController.Add(FControl, DoWndProc);
  RegisterChildHooks;
end;

procedure TdxChildControlWndProcHelper.WndProc(var AMessage: TMessage);
var
  ABorder: TcxBorder;
  AChildControl: TWinControl;
begin
  if AMessage.Msg = WM_NCHITTEST then
  begin
    inherited WndProc(AMessage);
    if FDragBorderHelper.GetBorderAtPos(Point(TWMNCHitTest(AMessage).Pos.X, TWMNCHitTest(AMessage).Pos.Y), ABorder) then
      AMessage.Result := HTTRANSPARENT;
  end
  else if AMessage.Msg = CM_CONTROLCHANGE then
  begin
    if TCMControlChange(AMessage).Control is TWinControl then
    begin
      AChildControl := TWinControl(TCMControlChange(AMessage).Control);
      if TCMControlChange(AMessage).Inserting then
        FChildren.Add(TdxChildControlWndProcHelper.Create(AChildControl, FDragBorderHelper))
      else
        FChildren.RemoveByControl(AChildControl);
    end;
    inherited WndProc(AMessage);
  end
  else
    inherited WndProc(AMessage);
end;

{ TdxControlDragBorderHelper }

constructor TdxControlDragBorderHelper.Create(AControl: TWinControl; AAutoDetectBorders: Boolean; const ABorders: TcxBorders;
  AAreaSize: Integer; ADragBorderEvent: TdxDragBorderEvent);
begin
  inherited Create(AControl, Self);
  FBorders := ABorders;
  if AAreaSize < 0 then
    AAreaSize := 0;
  FDetectionAreaSize := AAreaSize;
  FDragBorderEvent := ADragBorderEvent;
  FScaledDetectionAreaSize := -1;
  FAutoDetectBorders := AAutoDetectBorders;
end;

procedure TdxControlDragBorderHelper.CalcScaledDetectionAreaSize;
var
  M, D: Integer;
begin
  if FScaledDetectionAreaSize = -1 then
  begin
    if dxGetCurrentScaleFactor(FControl, M, D) and (M <> D) then
      FScaledDetectionAreaSize := Round(FDetectionAreaSize * M / D)
    else
      FScaledDetectionAreaSize := FDetectionAreaSize;
  end;
end;

function TdxControlDragBorderHelper.GetScaledDetectionAreaSize: Integer;
begin
  CalcScaledDetectionAreaSize;
  Result := FScaledDetectionAreaSize;
end;

function TdxControlDragBorderHelper.GetSizingEvent: TdxDragBorderEvent;
begin
  Result := FDragBorderEvent;
end;

function TdxControlDragBorderHelper.GetControl: TWinControl;
begin
  Result := FControl;
end;

function TdxControlDragBorderHelper.GetBorderAtPos(const APos: TPoint; out ABorder: TcxBorder): Boolean;

  function ParentHasRtlLayout: Boolean;
  begin
    Result := GetWindowLong(FControl.Parent.Handle, GWL_EXSTYLE) and WS_EX_LAYOUTRTL <> 0;
  end;

  function RtlScreenToClient(AControl: TControl; const Point: TPoint): TPoint;
  var
    Origin: TPoint;
  begin
    Origin := AControl.ClientOrigin;
    Result.X := AControl.Width + APos.X - Origin.X;
    Result.Y := Point.Y - Origin.Y;
  end;

  function RtlConvertBorders(AControl: TWinControl; ABorders: TcxBorders): TcxBorders;
  begin
    Result := ABorders;
    if AControl.IsRightToLeft then
    begin
      if bLeft in ABorders then
        Include(Result, bRight)
      else
        Exclude(Result, bRight);
      if bRight in ABorders then
        Include(Result, bLeft)
      else
        Exclude(Result, bLeft);
    end;
  end;

var
  P: TPoint;
  ABorders: TcxBorders;
begin
  if (not FControl.IsRightToLeft) then
  begin
    P := FControl.ScreenToClient(APos);
    CalcScaledDetectionAreaSize;
    ABorders := FBorders;

    Result := True;
    begin
      if (P.X <= FScaledDetectionAreaSize + FBorderSizes.Left) and ((FAutoDetectBorders and (FControl.Align in [alRight, alNone])) or (bLeft in ABorders)) then
        ABorder := bLeft
      else if (P.Y <= FScaledDetectionAreaSize + FBorderSizes.Top) and ((FAutoDetectBorders and (FControl.Align in [alBottom, alNone])) or (bTop in ABorders)) then
        ABorder := bTop
      else if ((FControl.Width - P.X) <= FScaledDetectionAreaSize + FBorderSizes.Right) and ((FAutoDetectBorders and (FControl.Align in [alLeft, alNone])) or (bRight in ABorders)) then
        ABorder := bRight
      else if ((FControl.Height - P.Y) <= FScaledDetectionAreaSize + FBorderSizes.Bottom) and ((FAutoDetectBorders and (FControl.Align in [alTop, alNone])) or (bBottom in ABorders)) then
        ABorder := bBottom
      else
        Result := False;
    end;
  end
  else if (not ParentHasRtlLayout) then
  begin
    P := RtlScreenToClient(FControl, APos);
    CalcScaledDetectionAreaSize;
    ABorders := FBorders;

    Result := True;
    begin
      if (P.X <= FScaledDetectionAreaSize + FBorderSizes.Left) and ((FAutoDetectBorders and (FControl.Align in [alRight, alNone])) or (bLeft in ABorders)) then
        ABorder := bLeft
      else if (P.Y <= FScaledDetectionAreaSize + FBorderSizes.Top) and ((FAutoDetectBorders and (FControl.Align in [alBottom, alNone])) or (bTop in ABorders)) then
        ABorder := bTop
      else if ((FControl.Width - P.X) <= FScaledDetectionAreaSize + FBorderSizes.Right) and ((FAutoDetectBorders and (FControl.Align in [alLeft, alNone])) or (bRight in ABorders)) then
        ABorder := bRight
      else if ((FControl.Height - P.Y) <= FScaledDetectionAreaSize + FBorderSizes.Bottom) and ((FAutoDetectBorders and (FControl.Align in [alTop, alNone])) or (bBottom in ABorders)) then
        ABorder := bBottom
      else
        Result := False;
    end;
  end
  else
  begin
    P := RtlScreenToClient(FControl, APos);
    CalcScaledDetectionAreaSize;
    ABorders := RtlConvertBorders(FControl, FBorders);

    Result := True;
    begin
      if (P.X <= FScaledDetectionAreaSize + FBorderSizes.Left) and ((FAutoDetectBorders and (FControl.Align in [alLeft, alNone])) or (bLeft in ABorders)) then
        ABorder := bLeft
      else if (P.Y <= FScaledDetectionAreaSize + FBorderSizes.Top) and ((FAutoDetectBorders and (FControl.Align in [alBottom, alNone])) or (bTop in ABorders)) then
        ABorder := bTop
      else if ((FControl.Width - P.X) <= FScaledDetectionAreaSize + FBorderSizes.Right) and ((FAutoDetectBorders and (FControl.Align in [alRight, alNone])) or (bRight in ABorders)) then
        ABorder := bRight
      else if ((FControl.Height - P.Y) <= FScaledDetectionAreaSize + FBorderSizes.Bottom) and ((FAutoDetectBorders and (FControl.Align in [alTop, alNone])) or (bBottom in ABorders)) then
        ABorder := bBottom
      else
        Result := False;
    end;
  end;
  Result := Result and (not TWinControlAccess(FControl).AutoSize);
end;

function TdxControlDragBorderHelper.GetBorders: TcxBorders;
begin
  Result := FBorders;
end;

function TdxControlDragBorderHelper.GetBorderSizes: TRect;
begin
  Result := FBorderSizes;
end;

function TdxControlDragBorderHelper.GetEnabled: Boolean;
begin
  Result := FEnabled;
end;

function TdxControlDragBorderHelper.GetDetectionAreaSize: Integer;
begin
  Result := FDetectionAreaSize;
end;

function TdxControlDragBorderHelper.GetAutoDetectBorders: Boolean;
begin
  Result := FAutoDetectBorders;
end;

procedure TdxControlDragBorderHelper.SetSizingEvent(
  AValue: TdxDragBorderEvent);
begin
  FDragBorderEvent := AValue;
end;

procedure TdxControlDragBorderHelper.SetBorders(const AValue: TcxBorders);
begin
  FBorders := AValue
end;

procedure TdxControlDragBorderHelper.SetBorderSizes(const AValue: TRect);
begin
  FBorderSizes := AValue;
end;

procedure TdxControlDragBorderHelper.SetEnabled(AValue: Boolean);
begin
  if FEnabled <> AValue then
  begin
    FEnabled := AValue;
    if FEnabled then
    begin
      FWindowProcObject := cxWindowProcController.Add(FControl, DoWndProc);
      RegisterChildHooks;
    end
    else
    begin
      UnRegisterChildHooks;
      cxWindowProcController.Remove(FWindowProcObject);
    end;
  end;
end;

procedure TdxControlDragBorderHelper.SetDetectionAreaSize(AValue: Integer);
begin
  if AValue < 0 then
    AValue := 0;
  FDetectionAreaSize := AValue;
  FScaledDetectionAreaSize := -1;
end;

procedure TdxControlDragBorderHelper.SetAutoDetectBorders(AValue: Boolean);
begin
  FAutoDetectBorders := AValue;
end;

procedure TdxControlDragBorderHelper.WndProc(var AMessage: TMessage);
var
  ADone: Boolean;
  AChildControl: TWinControl;
begin
  case AMessage.Msg of
    WM_NCHITTEST:
      begin
        inherited WndProc(AMessage);
        if GetBorderAtPos(Point(TWMNCHitTest(AMessage).Pos.X, TWMNCHitTest(AMessage).Pos.Y), FLastHitTestedBorder) then
        begin
          case FLastHitTestedBorder of
            bLeft: TWMNCHitTest(AMessage).Result := HTLEFT;
            bTop: TWMNCHitTest(AMessage).Result := HTTOP;
            bRight: TWMNCHitTest(AMessage).Result := HTRIGHT;
            bBottom: TWMNCHitTest(AMessage).Result := HTBOTTOM;
          end;
        end;
        Exit;
      end;
    WM_ENTERSIZEMOVE: FInSizing := True;
    WM_EXITSIZEMOVE:
      begin
        FScaledDetectionAreaSize := -1;
        FInSizing := False;
      end;
    CM_CONTROLCHANGE:
      begin
        if TCMControlChange(AMessage).Control is TWinControl then
        begin
          AChildControl := TWinControl(TCMControlChange(AMessage).Control);
          if TCMControlChange(AMessage).Inserting then
            FChildren.Add(TdxChildControlWndProcHelper.Create(AChildControl, Self))
          else
            FChildren.RemoveByControl(AChildControl);
          FScaledDetectionAreaSize := -1;
        end;
      end;
    WM_SIZE:
      begin
        if FInSizing then
        begin
          ADone := False;
          if Assigned(FDragBorderEvent) then
            FDragBorderEvent(FControl, FLastHitTestedBorder, ADone);
          if not ADone then
          begin
            if Assigned(FControl.Parent) and (TWinControlAccess(FControl).Align <> alNone) then
              FControl.Parent.Realign;
          end;
        end;
      end;
    DXM_SCALECHANGED: FScaledDetectionAreaSize := -1;
  end;
  inherited WndProc(AMessage);
end;

{ TdxFramedControl }

constructor TdxFramedControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColorIsDefault := True;
  FDragBorderHelper := TdxControlDragBorderHelper.Create(Self, True, [], TdxControlFrameDragOptions.DefaultDetectionAreaSize, nil);
  FFrame := TdxControlFrameOptions.Create(Self);
  BorderStyle := cxcbsNone;
end;

destructor TdxFramedControl.Destroy;
begin
  FreeAndNil(FFrame);
  FDragBorderHelper := nil;
  inherited Destroy;
end;

procedure TdxFramedControl.CreateWindowHandle(const Params: TCreateParams);
begin
  inherited CreateWindowHandle(Params);
  TdxFluentDesignContainerControlHelper.CheckStyle(Self);
end;

function TdxFramedControl.FluentDesignContainerControlCanBeOpaque: Boolean;
begin
  Result := True;
end;

procedure TdxFramedControl.AdjustClientRect(var ARect: TRect);
begin
  if FFrame.DrawInNonClientArea then
    inherited AdjustClientRect(ARect)
  else
    InternalAdjustClientRect(ARect);
end;

procedure TdxFramedControl.CMInvalidate(var AMessage: TMessage);
var
  I: Integer;
begin
  if HandleAllocated then
  begin
    if Parent <> nil then
      Parent.Perform(CM_INVALIDATE, 1, 0);
    if AMessage.WParam = 0 then
    begin
      Windows.InvalidateRect(WindowHandle, nil, False);
      for I := 0 to ControlCount - 1 do
        if csParentBackground in Controls[I].ControlStyle then
          Controls[I].Invalidate;
    end;
  end;
end;

procedure TdxFramedControl.CMIsToolControl(var AMessage: TMessage);
begin
  AMessage.Result := 1;
end;

procedure TdxFramedControl.CMParentColorChanged(var AMessage: TMessage);
var
  AParent: IdxControlDefaultColorHelper;
  APreviousIsDefaultColor: Boolean;
begin
  if ParentColor then
  begin
    APreviousIsDefaultColor := IsDefaultColor;
    FColorIsDefault := Assigned(Parent) and Supports(Parent, IdxControlDefaultColorHelper, AParent) and AParent.IsDefaultColor;
    inherited;
    if APreviousIsDefaultColor <> IsDefaultColor then
      Perform(CM_COLORCHANGED, 0, 0);
  end
  else
    inherited;
end;

procedure TdxFramedControl.DoNonClientPaint(AWindowDC: HDC);
var
  ACanvas: TCanvas;
  AcxCanvas: TcxCanvas;
begin
  ACanvas := TCanvas.Create;
  try
    ACanvas.Handle := AWindowDC;
    AcxCanvas := TcxCanvas.Create(ACanvas);
    try
      AcxCanvas.SaveState;
      try
        PaintNonClientArea(AcxCanvas);
      finally
        AcxCanvas.RestoreState;
      end;
    finally
      AcxCanvas.Free;
    end;
  finally
    ACanvas.Free;
  end;
end;

procedure TdxFramedControl.DoPaint;
begin
  if not FFrame.DrawInNonClientArea then
  begin
    DrawFrame(ActualCanvas);
    SetPaintRegion;
  end;
  if not ParentBackground then
  begin
    if Color = clDefault then
    begin
      if ActualCanvas is TcxControlCanvas then
        LookAndFeelPainter.DrawPanelContentEx(TcxControlCanvas(ActualCanvas), ClientBounds, ScaleFactor)
      else
        LookAndFeelPainter.DrawPanelContent(ActualCanvas, ClientBounds, IsRightToLeft);
    end
    else
      ActualCanvas.FillRect(ClientBounds, Color);
  end;
end;

procedure TdxFramedControl.DrawBorder(ACanvas: TcxCustomCanvas);
begin 
end;

procedure TdxFramedControl.DrawFrame(ACanvas: TcxCustomCanvas);
var
  R: TRect;
  AFrameColor: TColor;
begin
  if FFrame.Visible then
  begin
    GetWindowRect(Handle, R);
    R.Location := TPoint.Null;
    AFrameColor := FFrame.Color;
    if AFrameColor = clDefault then
    begin
      AFrameColor := LookAndFeelPainter.GetContainerBorderColor(False);
      if (AFrameColor = clBtnText) and (LookAndFeel.NativeStyle or (LookAndFeel.SkinPainter = nil)) then
        AFrameColor := clWindowFrame;
    end;
    ACanvas.FrameRect(R, AFrameColor, FFrame.ScaledThickness, RtlConvertBorders(FFrame.Borders));
  end;
end;

procedure TdxFramedControl.FrameColorChanged;
begin
  if [csLoading, csDestroying] * ComponentState <> [] then
    Exit;
  if FFrame.Visible and HandleAllocated then
  begin
    if FFrame.DrawInNonClientArea then
      RedrawWindow(Handle, nil, 0, RDW_INVALIDATE or RDW_FRAME)
    else
      RedrawWindow(Handle, nil, 0, RDW_INVALIDATE);
  end;
end;

procedure TdxFramedControl.FrameStyleChanged(AHard: Boolean);
begin
  Frame.ClearScaledThickness;

  if [csLoading, csDestroying] * ComponentState <> [] then
    Exit;

  if AHard then
  begin
    if HandleAllocated then
      dxRecalculateNonClientPart(Handle, True);
  end
  else
  begin
    BoundsChanged;
    Realign;
  end;

  DragBorderHelper.BorderSizes := TRect.Create(GetClientOffset(bLeft), GetClientOffset(bTop), GetClientOffset(bRight), GetClientOffset(bBottom));
end;

function TdxFramedControl.GetBorderSize: Integer;
begin
  Result := 0;
end;

function TdxFramedControl.GetClientBounds: TRect;
begin
  if FFrame.DrawInNonClientArea then
    Result := ClientRect
  else
  begin
    Result := Bounds;
    AdjustClientRect(Result);
  end;
end;

function TdxFramedControl.GetClientOffset(ABorder: TcxBorder): Integer;
begin
  if FFrame.Visible and (ABorder in FFrame.Borders) then
    Result := FFrame.ScaledThickness
  else
    Result := 0;
end;

function TdxFramedControl.GetColor: TColor;
begin
  if IsDefaultColor then
    Result := clDefault
  else
    Result := inherited Color;
end;

function TdxFramedControl.GetActualColor: TColor;
begin
  if Color = clDefault then
    Result := GetDefaultColor
  else
    Result := inherited Color;
end;

function TdxFramedControl.IsDefaultColor: Boolean;
begin
  Result := FColorIsDefault or (inherited Color = clDefault);
end;

function TdxFramedControl.HasNonClientArea: Boolean;
begin
  Result := FFrame.DrawInNonClientArea;
end;

procedure TdxFramedControl.InternalAdjustClientRect(var ARect: TRect);
var
  ABorders: TcxBorders;
begin
  if FFrame.Visible then
  begin
    ABorders := FFrame.Borders;
    if bLeft in ABorders then
    begin
      if IsRightToLeft and (
        ((not Frame.DrawInNonClientArea) and (not ParentHasRtlLayout)) or
        (Frame.DrawInNonClientArea and ParentHasRtlLayout)
      ) then
        Dec(ARect.Right, GetClientOffset(bLeft))
      else
        Inc(ARect.Left, GetClientOffset(bLeft));
    end;
    if bTop in ABorders then
      Inc(ARect.Top, GetClientOffset(bTop));
    if bRight in ABorders then
    begin
      if IsRightToLeft and (
        ((not Frame.DrawInNonClientArea) and (not ParentHasRtlLayout)) or
        (Frame.DrawInNonClientArea and ParentHasRtlLayout)
      ) then
        Inc(ARect.Left, GetClientOffset(bRight))
      else
        Dec(ARect.Right, GetClientOffset(bRight));
    end;
    if bBottom in ABorders then
      Dec(ARect.Bottom, GetClientOffset(bBottom));
  end;
end;

procedure TdxFramedControl.Loaded;
begin
  inherited;
  FrameStyleChanged(True);
end;

procedure TdxFramedControl.LookAndFeelChanged(Sender: TcxLookAndFeel;
  AChangedValues: TcxLookAndFeelValues);
begin
  inherited LookAndFeelChanged(Sender, AChangedValues);
  if [lfvKind, lfvNativeStyle, lfvSkinName, lfvRenderMode] * AChangedValues <> [] then
  begin
    if FFrame.DrawInNonClientArea then
      FrameColorChanged;
    if not ParentBackground then
      inherited Color := GetActualColor;
    Invalidate;
  end;
end;

function TdxFramedControl.NeedRedrawOnResize: Boolean;
begin
  Result := True;
end;

function TdxFramedControl.NeedsScrollBars: Boolean;
begin
  Result := False;
end;

procedure TdxFramedControl.PaintNonClientArea(ACanvas: TcxCanvas);
begin
  DrawFrame(ACanvas);
end;

function TdxFramedControl.ParentHasRtlLayout: Boolean;
begin
  Result := (Parent <> nil) and (GetWindowLong(Parent.Handle, GWL_EXSTYLE) and WS_EX_LAYOUTRTL <> 0);
end;

function TdxFramedControl.RtlConvertBorders(
  const ABorders: TcxBorders): TcxBorders;
begin
  Result := ABorders;
  if IsRightToLeft and (not ParentHasRtlLayout) then
  begin
    if bLeft in ABorders then
      Include(Result, bRight)
    else
      Exclude(Result, bRight);
    if bRight in ABorders then
      Include(Result, bLeft)
    else
      Exclude(Result, bLeft);
  end;
end;

procedure TdxFramedControl.ScaleFactorChanged;
begin
  inherited ScaleFactorChanged;
  FFrame.ScaleFactorChanged;
end;

procedure TdxFramedControl.SetColor(AValue: TColor);
begin
  FColorIsDefault := AValue = clDefault;
  if IsDefaultColor then
    AValue := GetDefaultColor;
  inherited Color := AValue;
end;

procedure TdxFramedControl.SetFrame(const AValue: TdxControlFrameOptions);
begin
  Frame.Assign(AValue);
end;

procedure TdxFramedControl.SetOnDragBorder(
  const AValue: TdxFramedControlDragBorderEvent);
begin
  if @FOnDragBorder <> @AValue then
  begin
    FOnDragBorder := AValue;
    if Assigned(FOnDragBorder) then
    begin
      FDragBorderHelper.DragBorderEvent :=
        procedure(AControl: TControl; ABorder: TcxBorder; var ADone: Boolean)
        begin
          FOnDragBorder(AControl as TdxFramedControl, ABorder, ADone);
        end;
    end
    else
      FDragBorderHelper.DragBorderEvent := nil;
  end;
end;

procedure TdxFramedControl.SetPaintRegion;
var
  AClientBounds: TRect;
begin
  if (not FFrame.DrawInNonClientArea) then
  begin
    AClientBounds := ClientBounds;
    ActualCanvas.IntersectClipRect(AClientBounds);
  end;
end;

procedure TdxFramedControl.WMEraseBkgnd(var AMessage: TWMEraseBkgnd);
begin
  if not ParentBackground then
    AMessage.Result := 1
  else
    inherited;
end;

procedure TdxFramedControl.WMNCCalcSize(var AMessage: TWMNCCalcSize);
begin
  inherited;
  if FFrame.DrawInNonClientArea then
    InternalAdjustClientRect(AMessage.CalcSize_Params^.rgrc[0]);
end;

procedure TdxFramedControl.WMNCPaint(var AMessage: TWMNCPaint);
var
  DC: THandle;
  AFlags: Integer;
  ARegion, AUpdateRegion: HRGN;
begin
  if HasNonClientArea then
  begin
    AFlags := DCX_CACHE or DCX_CLIPSIBLINGS or DCX_WINDOW or DCX_VALIDATE;
    AUpdateRegion := AMessage.RGN;

    if AUpdateRegion <> 1 then
    begin
      ARegion := CreateRectRgnIndirect(cxEmptyRect);
      CombineRgn(ARegion, AUpdateRegion, 0, RGN_COPY);
      AFlags := AFlags or DCX_INTERSECTRGN;
    end
    else
      ARegion := 0;

    DC := GetDCEx(Handle, ARegion, AFlags);
    try
      DoNonClientPaint(DC);
    finally
      ReleaseDC(Handle, DC);
    end;
    AMessage.Result := 0;
  end;
end;

end.
