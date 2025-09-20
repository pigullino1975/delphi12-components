{********************************************************************}
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

unit dxShadowWindow;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Types, Windows, Messages, Controls, Graphics, Forms,
  dxCore, dxMessages, cxClasses, cxControls, cxGraphics, cxGeometry, dxSkinsCore, dxGDIPlusClasses;

const
  dxShadowDefaultOffsets: TRect = (Left: 8; Top: 8; Right: 8; Bottom: 8);
  dxShadowWindowThinBorderSize = 2;

type

  { TdxCustomShadowWindow }

  TdxCustomShadowWindow = class(TCustomControl)
  strict private
    FCornerRadius: Integer;
    FIntensity: Byte;
    FOutputBuffer: TcxBitmap32;
    FOwnerWindow: TWinControl;
    FShadowColor: TColor;
    FShadowOffsets: TRect;

    procedure CheckOutputBufferSize(AWidth, AHeight: Integer);
    function GetMaxShadowSize: Integer;
    function GetVisible: Boolean;
    procedure SetCornerRadius(AValue: Integer);
    procedure SetIntensity(AValue: Byte);
    procedure SetShadowColor(AValue: TColor);
    procedure SetShadowOffsets(const AValue: TRect);
    procedure SetVisible(AValue: Boolean);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DrawShadow(ACanvas: TdxGpCanvas); virtual;
    procedure DrawShadowCore(ACanvas: TdxGpCanvas; ARadius: Integer);
    function GetAlphaBlendValue: Byte; virtual;
    procedure Paint; override;
    procedure Resize; override;
    procedure ShadowOffsetsChanged; virtual;
    procedure UpdateLayer;
    // Messages
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  public
    constructor Create(AOwnerWindow: TWinControl); reintroduce; virtual;
    destructor Destroy; override;
    procedure Hide; virtual;
    procedure Refresh; virtual;
    procedure Show; virtual;
    //
    property OwnerWindow: TWinControl read FOwnerWindow;
    // Settings
    property CornerRadius: Integer read FCornerRadius write SetCornerRadius;
    property Intensity: Byte read FIntensity write SetIntensity;
    property ShadowColor: TColor read FShadowColor write SetShadowColor;
    property ShadowOffsets: TRect read FShadowOffsets write SetShadowOffsets;
    property Visible: Boolean read GetVisible write SetVisible;
  end;

  { TdxShadowWindow }

  TdxShadowWindowClass = class of TdxShadowWindow;
  TdxShadowWindow = class(TdxCustomShadowWindow)
  strict private const
    CMS_ANIMATION = 250;
  strict private
    FActivating: Boolean;
    FAnimatedShowing: Boolean;
    FAnimatedShowingDelayTimer: TcxTimer;
    FMergeWithNativeShadow: Boolean;
    FOwnerWindowIsActive: Boolean;
    FOwnerWindowWndProcObject: TcxWindowProcLinkedObject;
    FPrevFocusedWindow: HWND;
    FResizeOwnerWindowUsingShadow: Boolean;

    procedure HandlerDelayedShow(Sender: TObject);
    function GetOwnerWindowRegion: TcxRegion;
    function IsAnimatedShowingUsed(AWndHandle: HWND): Boolean;
    procedure SetResizeOwnerWindowUsingShadow(const AValue: Boolean);
  protected
    function CalculateVisibility: Boolean; virtual;
    function CanUseShadows: Boolean; virtual;
    procedure DrawShadow(ACanvas: TdxGpCanvas); override;
    function GetAlphaBlendValue: Byte; override;
    procedure OwnerWindowWndProc(var AMessage: TMessage); virtual;
    procedure ShadowOffsetsChanged; override;
    procedure UpdateZOrder;
    procedure WndProc(var Message: TMessage); override;
    // Messages
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
    procedure WMExitSizeMove(var Message: TMessage); message WM_EXITSIZEMOVE;
    procedure WMKillFocus(var Message: TWMSetFocus); message WM_KILLFOCUS;
    procedure WMMouseActivate(var Message: TWMMouseActivate); message WM_MOUSEACTIVATE;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMSizing(var Message: TMessage); message WM_SIZING;
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;
    //
    property Activating: Boolean read FActivating;
    property OwnerWindowIsActive: Boolean read FOwnerWindowIsActive;
    property OwnerWindowWndProcObject: TcxWindowProcLinkedObject read FOwnerWindowWndProcObject;
  public
    constructor Create(AOwnerWindow: TWinControl); override;
    destructor Destroy; override;
    procedure Refresh; override;
    procedure Show; override;
    procedure UpdateBounds;
    procedure UpdateVisibility;
    //
    property ResizeOwnerWindowUsingShadow: Boolean read FResizeOwnerWindowUsingShadow write SetResizeOwnerWindowUsingShadow;
  end;

function dxCanUseShadows: Boolean;
function dxCanUseTransparentShadows: Boolean;
implementation

uses
  Math, SysUtils, cxContainer, dxForms, dxDPIAwareUtils, dxCoreGraphics, cxLookAndFeels;

const
  dxThisUnitName = 'dxShadowWindow';

function dxCanUseShadows: Boolean;
begin
  Result := dxSystemInfo.IsDropShadow and not dxSystemInfo.IsRemoteSession and dxCanUseTransparentShadows;
end;

function dxCanUseTransparentShadows: Boolean;
begin
  Result := cxIsUpdateLayeredWindowAvailable and not cxScreenCanvas.IsLowColorsMode;
end;

{ TdxCustomShadowWindow }

constructor TdxCustomShadowWindow.Create(AOwnerWindow: TWinControl);
begin
  inherited Create(nil);
  FOwnerWindow := AOwnerWindow;
  FShadowColor := clBlack;
  FShadowOffsets := dxShadowDefaultOffsets;
  FIntensity := 60;
  ControlStyle := ControlStyle + [csOverrideStylePaint];
  Enabled := False;
end;

destructor TdxCustomShadowWindow.Destroy;
begin
  FreeAndNil(FOutputBuffer);
  inherited Destroy;
end;

procedure TdxCustomShadowWindow.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := WS_POPUP;
  Params.WndParent := OwnerWindow.Handle;
  Params.WindowClass.style := 0;

  Params.ExStyle := WS_EX_LAYERED;
  if GetWindowLong(OwnerWindow.Handle, GWL_EXSTYLE) and WS_EX_TOPMOST <> 0 then
    Params.ExStyle := Params.ExStyle or WS_EX_TOPMOST;
  if not Enabled then
    Params.Style := Params.Style or WS_DISABLED;
end;

procedure TdxCustomShadowWindow.DrawShadow(ACanvas: TdxGpCanvas);
begin
  DrawShadowCore(ACanvas, CornerRadius + Max(GetMaxShadowSize - 2, 0));
end;

procedure TdxCustomShadowWindow.DrawShadowCore(ACanvas: TdxGpCanvas; ARadius: Integer);
var
  ABrush: TdxGPBrush;
  ARect: TRect;
  ASize: Integer;
begin
  ASize := GetMaxShadowSize;
  if ASize > 0 then
  begin
    ARect := cxRectInflate(ClientRect, 0, 0, 1, 1);
    ABrush := TdxGPBrush.Create;
    try
      ABrush.Color := dxColorToAlphaColor(ShadowColor, Max(Intensity div ASize, 1));
      repeat
        InflateRect(ARect, -1, -1);
        ACanvas.RoundRect(ARect, nil, ABrush, ARadius, ARadius);
        Dec(ASize);
      until ASize = 0;
    finally
      ABrush.Free;
    end;
  end;
end;

function TdxCustomShadowWindow.GetAlphaBlendValue: Byte;
begin
  Result := MaxByte;
end;

procedure TdxCustomShadowWindow.Hide;
begin
  if HandleAllocated then
  begin
    ShowWindow(Handle, SW_HIDE);
    DestroyHandle;
  end;
end;

procedure TdxCustomShadowWindow.Paint;
begin
  Canvas.Brush.Color := ShadowColor;
  Canvas.FillRect(ClientRect);
end;

procedure TdxCustomShadowWindow.Refresh;
begin
  UpdateLayer
end;

procedure TdxCustomShadowWindow.Resize;
begin
  inherited Resize;
  Refresh;
end;

procedure TdxCustomShadowWindow.ShadowOffsetsChanged;
begin
  Refresh;
end;

procedure TdxCustomShadowWindow.Show;
begin
  dxSetZOrder(Handle, OwnerWindow.Handle, False, SWP_SHOWWINDOW);
  Refresh;
end;

procedure TdxCustomShadowWindow.UpdateLayer;
begin
  if HandleAllocated and Visible then
  begin
    CheckOutputBufferSize(Width, Height);
    FOutputBuffer.Clear;

    dxGPPaintCanvas.BeginPaint(FOutputBuffer.Canvas.Handle, ClientRect);
    try
      dxGPPaintCanvas.SmoothingMode := smAntiAlias;
      DrawShadow(dxGPPaintCanvas);
    finally
      dxGPPaintCanvas.EndPaint;
    end;

    cxUpdateLayeredWindow(Handle, FOutputBuffer, cxSize(Width, Height), GetAlphaBlendValue);
  end;
end;

procedure TdxCustomShadowWindow.CheckOutputBufferSize(AWidth, AHeight: Integer);
const
  ResizeDelta = 32;

  function CheckNeedResize(ABufferSize, ATargetSize: Integer): Boolean;
  begin
    Result := (ABufferSize < ATargetSize) or (ABufferSize - ATargetSize > ResizeDelta);
  end;

begin
  if FOutputBuffer = nil then
    FOutputBuffer := TcxBitmap32.CreateSize(AWidth, AHeight);
  if CheckNeedResize(FOutputBuffer.Width, AWidth) or CheckNeedResize(FOutputBuffer.Height, AHeight) then
  begin
    FOutputBuffer.Height := (AHeight div ResizeDelta + 1) * ResizeDelta;
    FOutputBuffer.Width := (AWidth div ResizeDelta + 1) * ResizeDelta;
  end;
end;

function TdxCustomShadowWindow.GetMaxShadowSize: Integer;
begin
  Result := Max(Max(ShadowOffsets.Left, ShadowOffsets.Right), Max(ShadowOffsets.Top, ShadowOffsets.Bottom));
end;

function TdxCustomShadowWindow.GetVisible: Boolean;
begin
  Result := HandleAllocated and IsWindowVisible(Handle);
end;

procedure TdxCustomShadowWindow.SetCornerRadius(AValue: Integer);
begin
  AValue := Max(AValue, 0);
  if FCornerRadius <> AValue then
  begin
    FCornerRadius := AValue;
    Refresh;
  end;
end;

procedure TdxCustomShadowWindow.SetIntensity(AValue: Byte);
begin
  if Intensity <> AValue then
  begin
    FIntensity := AValue;
    Refresh;
  end;
end;

procedure TdxCustomShadowWindow.SetShadowColor(AValue: TColor);
begin
  if (FShadowColor <> AValue) and cxColorIsValid(AValue) then
  begin
    FShadowColor := AValue;
    Refresh;
  end;
end;

procedure TdxCustomShadowWindow.SetShadowOffsets(const AValue: TRect);
begin
  if not cxRectIsEqual(FShadowOffsets, AValue) then
  begin
    FShadowOffsets := AValue;
    ShadowOffsetsChanged;
  end;
end;

procedure TdxCustomShadowWindow.SetVisible(AValue: Boolean);
begin
  if Visible <> AValue then
  begin
    if AValue then
      Show
    else
      Hide;
  end;
end;

procedure TdxCustomShadowWindow.WMNCHitTest(var Message: TWMNCHitTest);
begin
  inherited;
  Message.Result := HTTRANSPARENT;
end;

procedure TdxCustomShadowWindow.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  Message.Result := 0;
end;

procedure TdxCustomShadowWindow.WMPaint(var Message: TWMPaint);
begin
  DefaultHandler(Message);
  Message.Result := 0;
end;

{ TdxShadowWindow }

constructor TdxShadowWindow.Create(AOwnerWindow: TWinControl);
begin
  inherited Create(AOwnerWindow);
  FOwnerWindowWndProcObject := cxWindowProcController.Add(OwnerWindow, OwnerWindowWndProc);
  FOwnerWindowIsActive := OwnerWindow.HandleAllocated and (OwnerWindow.Handle = GetActiveWindow);
end;

destructor TdxShadowWindow.Destroy;
begin
  FreeAndNil(FAnimatedShowingDelayTimer);
  cxWindowProcController.Remove(FOwnerWindowWndProcObject);
  inherited Destroy;
end;

function TdxShadowWindow.CalculateVisibility: Boolean;
begin
  Result := (ResizeOwnerWindowUsingShadow or (OwnerWindowIsActive or FActivating)) and
    CanUseShadows and IsWindowVisible(OwnerWindow.Handle) and
    not (IsZoomed(OwnerWindow.Handle) or IsIconic(OwnerWindow.Handle)) and
    not IsChildClassWindow(OwnerWindow.Handle);
end;

function TdxShadowWindow.CanUseShadows: Boolean;
begin
  Result := dxCanUseShadows;
end;

procedure TdxShadowWindow.DrawShadow(ACanvas: TdxGpCanvas);
var
  ARegion: TcxRegion;
begin
  ACanvas.SaveClipRegion;
  try
    ARegion := GetOwnerWindowRegion;
    try
      ACanvas.SetClipRegion(ARegion.Handle, gmExclude);
      inherited DrawShadow(ACanvas);
    finally
      ARegion.Free;
    end;
  finally
    ACanvas.RestoreClipRegion;
  end;
end;

function TdxShadowWindow.GetAlphaBlendValue: Byte;
begin
  if FAnimatedShowing then
    Result := 0
  else
    if FMergeWithNativeShadow then
      Result := 10 
    else
      if Activating or OwnerWindowIsActive then
        Result := MaxByte
      else
        Result := 100;
end;

procedure TdxShadowWindow.OwnerWindowWndProc(var AMessage: TMessage);
var
  AWindowPos: PWindowPos;
  ACommand: Integer;
  AProcessingSysCommand: Boolean; 
begin
  AProcessingSysCommand := False;
  case AMessage.Msg of
    WM_SHOWWINDOW:
      begin
        FreeAndNil(FAnimatedShowingDelayTimer);
        if IsAnimatedShowingUsed(OwnerWindow.Handle) then
        begin
          FAnimatedShowing := True;
          FAnimatedShowingDelayTimer := cxCreateTimer(HandlerDelayedShow, CMS_ANIMATION);
        end;
      end;
     CM_SHOWINGCHANGED:
      if not OwnerWindow.Visible then
        Hide;
     WM_SYSCOMMAND:
       begin
         AProcessingSysCommand := True;
         ACommand := AMessage.WParam and $FFF0;
         if (ACommand = SC_MAXIMIZE) or (ACommand = SC_MINIMIZE) then
           Hide;
       end;
  end;

  OwnerWindowWndProcObject.DefaultProc(AMessage);

  case AMessage.Msg of
    WM_SIZE:
      Refresh;

    WM_NCACTIVATE:
      begin
        FOwnerWindowIsActive := TWMNCActivate(AMessage).Active;
        UpdateVisibility;
        if Visible then
        begin
          UpdateZOrder;
          Refresh;
        end;
      end;

    WM_WINDOWPOSCHANGED:
      begin
        AWindowPos := TWMWindowPosChanged(AMessage).WindowPos;
        if (AWindowPos.flags and SWP_SHOWWINDOW <> 0) or (AWindowPos.flags and SWP_HIDEWINDOW <> 0) then
          UpdateVisibility;
        if (AWindowPos.flags and SWP_NOSIZE = 0) or (AWindowPos.flags and SWP_NOMOVE = 0) then
          UpdateBounds;
        if (AWindowPos.flags and SWP_NOZORDER = 0) and Visible and not FOwnerWindowIsActive then 
          UpdateZOrder;
      end;
  else
    if AProcessingSysCommand then
    begin
      if AMessage.WParam and $FFF0 = SC_RESTORE then
        UpdateVisibility;
    end;
  end;
end;

procedure TdxShadowWindow.Refresh;
begin
  FMergeWithNativeShadow := IsWin11OrLater and OwnerWindow.HandleAllocated and
    (dxGetFormCorners(OwnerWindow.Handle) in [fcRounded, fcSmallRounded]);
  UpdateLayer;
end;

procedure TdxShadowWindow.ShadowOffsetsChanged;
begin
  if Visible then
    UpdateBounds;
end;

procedure TdxShadowWindow.Show;
begin
  UpdateBounds;
  inherited Show;
end;

procedure TdxShadowWindow.UpdateBounds;
var
  R: TRect;
begin
  R := cxRectInflate(OwnerWindow.BoundsRect, ShadowOffsets);
  SetWindowPos(Handle, OwnerWindow.Handle, R.Left, R.Top, cxRectWidth(R), cxRectHeight(R),
    SWP_NOACTIVATE or SWP_NOOWNERZORDER); 
end;

procedure TdxShadowWindow.UpdateZOrder;
begin
  SetWindowPos(Handle, OwnerWindow.Handle, 0, 0, 0, 0,
    SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_NOOWNERZORDER); 
end;

procedure TdxShadowWindow.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_NCLBUTTONDOWN:
      if ResizeOwnerWindowUsingShadow then
      begin
        SendMessage(OwnerWindow.Handle, Message.Msg, Message.WParam, Message.LParam);
        Message.Result := 0;
      end
      else
        inherited
  else
    inherited;
  end;
end;

procedure TdxShadowWindow.UpdateVisibility;
begin
  Visible := CalculateVisibility;
end;

procedure TdxShadowWindow.WMActivate(var Message: TWMActivate);
begin
  if not FActivating and (Message.Active <> WA_INACTIVE) then
  begin
    SetActiveWindow(OwnerWindow.Handle);
    Message.Result := 0;
    Exit;
  end;

  inherited;
  if Message.Active <> WA_INACTIVE then
    SendMessage(Message.ActiveWindow, WM_NCACTIVATE, WPARAM(True), 0);
  FActivating := False;
  UpdateZOrder;
end;

procedure TdxShadowWindow.WMExitSizeMove(var Message: TMessage);
begin
  inherited;
  if ResizeOwnerWindowUsingShadow then
    OwnerWindow.BoundsRect := cxRectContent(BoundsRect, ShadowOffsets);
  if FPrevFocusedWindow <> 0 then
    Windows.SetFocus(FPrevFocusedWindow);
end;

procedure TdxShadowWindow.WMKillFocus(var Message: TWMSetFocus);
begin
  inherited;
  FPrevFocusedWindow := 0;
end;

procedure TdxShadowWindow.WMMouseActivate(var Message: TWMMouseActivate);
begin
  FActivating := True;
  inherited; 
  CloseRelatedPopups(OwnerWindow.Handle);
  Message.Result := MA_NOACTIVATE;
end;

procedure TdxShadowWindow.WMNCHitTest(var Message: TWMNCHitTest);

  function CheckVerticalSide(const R: TRect; ATopCornerCode, ABottomCornerCode, ASideCode: Integer): Integer;
  begin
    if Message.YPos <= R.Top then
      Result := ATopCornerCode
    else
      if Message.YPos >= R.Bottom then
        Result := ABottomCornerCode
      else
        Result := ASideCode;
  end;
  
var
  R: TRect;
begin
  inherited; 
  if ResizeOwnerWindowUsingShadow then
  begin  
    R := cxRectInflate(BoundsRect, -dxGetSystemMetrics(SM_CXSIZEFRAME), -dxGetSystemMetrics(SM_CYSIZEFRAME));
    if not PtInRect(R, SmallPointToPoint(Message.Pos)) then
    begin    
      if Message.XPos >= R.Right then
        Message.Result := CheckVerticalSide(R, HTTOPRIGHT, HTBOTTOMRIGHT, HTRIGHT)
      else

      if Message.XPos <= R.Left then
        Message.Result := CheckVerticalSide(R, HTTOPLEFT, HTBOTTOMLEFT, HTLEFT)
      else

      if Message.YPos <= R.Top then
        Message.Result := HTTOP
      else
        Message.Result := HTBOTTOM;
    end;
  end;
end;

procedure TdxShadowWindow.WMSetFocus(var Message: TWMSetFocus);
begin
  if FActivating then
  begin
    FPrevFocusedWindow := Message.FocusedWnd;
    inherited;
  end
  else
    Windows.SetFocus(Message.FocusedWnd);
end;

procedure TdxShadowWindow.WMSizing(var Message: TMessage);
var
  R: PRect;
begin
  if ResizeOwnerWindowUsingShadow then
  begin
    R := PRect(Message.LParam);
    OwnerWindow.BoundsRect := cxRectContent(R^, ShadowOffsets);
    R^ := cxRectInflate(OwnerWindow.BoundsRect, ShadowOffsets);
  end;
  inherited;
end;

procedure TdxShadowWindow.WMWindowPosChanged(var Message: TWMWindowPosChanged);
begin
  Message.WindowPos^.hwndInsertAfter := OwnerWindow.Handle; 
  inherited;
end;

procedure TdxShadowWindow.HandlerDelayedShow(Sender: TObject);
begin
  FreeAndNil(FAnimatedShowingDelayTimer);
  FAnimatedShowing := False;
  UpdateLayer;
end;

function TdxShadowWindow.GetOwnerWindowRegion: TcxRegion;
begin
  Result := TdxFormHelper.GetRegion(OwnerWindow);
  Result.Offset(dxMapWindowPoint(OwnerWindow.Handle, Handle, cxNullPoint, False));
end;

function TdxShadowWindow.IsAnimatedShowingUsed(AWndHandle: HWND): Boolean;
begin
  Result := IsWinSevenOrLater and TdxFormHelper.GetAnimation and
    (GetWindowLong(OwnerWindow.Handle, GWL_STYLE) and WS_CAPTION = WS_CAPTION) and
    (GetWindowLong(OwnerWindow.Handle, GWL_EXSTYLE) and WS_EX_TOOLWINDOW = 0);
end;

procedure TdxShadowWindow.SetResizeOwnerWindowUsingShadow(const AValue: Boolean);
begin
  if FResizeOwnerWindowUsingShadow <> AValue then
  begin
    FResizeOwnerWindowUsingShadow := AValue;
    Enabled := ResizeOwnerWindowUsingShadow;
  end;
end;

end.
