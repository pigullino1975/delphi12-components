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

unit dxInplaceEditing; // for internal use

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Types, Windows, Classes, Controls, Graphics, ImgList, Forms, StdCtrls, Messages, SysUtils, ComCtrls,
  dxCoreClasses, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxGraphics, cxGeometry, cxClasses,
  dxCoreGraphics;

type
  IdxInplaceEditContainer = interface
  ['{4C60E56F-3DD3-498B-9156-155BF29217D2}']
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
      MousePos: TPoint): Boolean;
    procedure FinishEditing(AAccept: Boolean = True);
    function GetClientBounds: TRect;
    function GetEditingControl: TWinControl;
    function GetLookAndFeelPainter: TcxCustomLookAndFeelPainter;
    function GetScaleFactor: TdxScaleFactor;
    function GetTextColor: TColor;
    procedure ValidatePasteText(var AText: string);

    property ClientBounds: TRect read GetClientBounds;
    property ScaleFactor: TdxScaleFactor read GetScaleFactor;
  end;

  { IdxListViewInplaceEdit }

  IdxInplaceEdit = interface
  ['{526C0124-CA8D-43A7-B842-4262B36DBDB6}']
    function GetValue: string;
    procedure Hide;
    function IsVisible: Boolean;
    procedure Show(AContainer: IdxInplaceEditContainer; const ABounds: TRect; const AText: string;
      AFont: TFont; ASelStart, ASelLength: Integer; AMaxLength: Integer);
    property Value: string read GetValue;
  end;

  TdxInplaceEditingController = class
  strict private
    FEditingTimer: TcxTimer;
    FInplaceEditImplementator: TCustomEdit;
    function GetInplaceEdit: IdxInplaceEdit;
    function CreateInplaceEditImplementator: TCustomEdit;
    procedure StartEditing(Sender: TObject);
  protected
    procedure DestroyEdit;
    procedure DestroyTimer;
    procedure InplaceEditKeyPress(Sender: TObject; var AKey: Char); virtual;
    function IsReadOnly: Boolean; virtual;
    function IsMultiline: Boolean; virtual;
    procedure StartItemCaptionEditing; virtual;
  public
    destructor Destroy; override;
    procedure StartEditingTimer;
    property InplaceEdit: IdxInplaceEdit read GetInplaceEdit;
  end;

implementation

uses
  dxTypeHelpers, Math, Clipbrd;

const
  dxThisUnitName = 'dxInplaceEditing';

type
  TCustomEditHelper = class helper for TCustomEdit
  public
    function GetExtraHeight: Integer;
    function GetExtraWidth: Integer;
    procedure SetMargins;
    function GetSingleLineHeight: Integer;
    procedure PaintNonClientArea(var Message: TWMNCPaint; APainter: TcxCustomLookAndFeelPainter);
    procedure SetAppearance(APainter: TcxCustomLookAndFeelPainter; AFont: TFont; ATextColor: TColor);
    procedure SetKeyPressEvent(AEvent: TKeyPressEvent);
  end;

  { TdxSingleLineInplaceEdit }

  TdxSingleLineInplaceEdit = class(TEdit, IdxInplaceEdit)
  protected const
    Margin = 2;
  private
    FClickTime: Longint;
    FHiding: Boolean;
    FContainer: IdxInplaceEditContainer;
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMNCPaint(var Message: TWMNCPaint); message WM_NCPAINT;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
  protected
    function GetValue: string;
    procedure Hide;
    function IsVisible: Boolean;
    procedure Show(AContainer: IdxInplaceEditContainer; const ABounds: TRect; const AText: string;
      AFont: TFont; ASelStart, ASelLength: Integer; AMaxLength: Integer);

    function CalculateWidth: Integer;
    procedure Change; override;
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; override;
    procedure KeyPress(var Key: Char); override;
    procedure WndProc(var Message: TMessage); override;

    property Container: IdxInplaceEditContainer read FContainer;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetFocus; override;
  end;

  { TdxMultiLineInplaceEdit }

  TdxMultiLineInplaceEdit = class(TMemo, IdxInplaceEdit) // for internal use
  private
    FAvailableWidth: Integer;
    FClickTime: Longint;
    FHiding: Boolean;
    FInitialBounds: TRect;
    FFContainer: IdxInplaceEditContainer;
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
    procedure WMNCPaint(var Message: TWMNCPaint); message WM_NCPAINT;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
  protected
    function GetValue: string;
    function IsVisible: Boolean;
    procedure Hide;
    procedure Show(AContainer: IdxInplaceEditContainer; const ABounds: TRect; const AText: string;
      AFont: TFont; ASelStart, ASelLength: Integer; AMaxLength: Integer);

    procedure CalculateBounds;
    procedure Change; override;
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; override;
    procedure KeyPress(var Key: Char); override;
    procedure WndProc(var Message: TMessage); override;

    property FContainer: IdxInplaceEditContainer read FFContainer;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetFocus; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
  end;

{ TdxSingleLineInplaceEdit }

constructor TdxSingleLineInplaceEdit.Create(AOwner: TComponent);
begin
  inherited Create(nil);
  Ctl3D := True;
  TabStop := False;
  BorderStyle := bsSingle;
  BorderWidth := 0;
  DoubleBuffered := False;
end;

function TdxSingleLineInplaceEdit.CalculateWidth: Integer;
const
  MinimalWidth = 48;
  ExtraWidth = 20;
var
  ATextWidth: Integer;
  AText: string;
  AMargins: DWord;
begin
  if Container = nil then
    Exit(MinimalWidth);
  AMargins := SendMessage(Handle, EM_GETMARGINS, 0, 0);
  AText := Text;
  ATextWidth := TdxTextMeasurer.TextSizeDT(Font, AText, DT_SINGLELINE or DT_CALCRECT or DT_NOPREFIX).cx;
  Result := Max(MinimalWidth, ATextWidth + LongRec(AMargins).Lo + LongRec(AMargins).Hi + ExtraWidth);
end;

procedure TdxSingleLineInplaceEdit.Change;
var
  AWidth: Integer;
begin
  AWidth := CalculateWidth;
  if Container <> nil then
    if UseRightToLeftAlignment then
    begin
      AWidth := Min(AWidth, BoundsRect.Right - Container.ClientBounds.Left);
      SetBounds(BoundsRect.Right - AWidth, Top, AWidth, Height);
    end
    else
      Width := Min(AWidth, Container.ClientBounds.Right - Left);
  inherited Change;
end;

procedure TdxSingleLineInplaceEdit.CMShowingChanged(var Message: TMessage);
begin
// do nothing
end;

function TdxSingleLineInplaceEdit.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint): Boolean;
begin
  Result := Container.DoMouseWheel(Shift, WheelDelta, MousePos);
end;


function TdxSingleLineInplaceEdit.GetValue: string;
begin
  Result := Text;
end;

procedure TdxSingleLineInplaceEdit.Hide;
begin
  FHiding := True;
  try
    if IsVisible then
    begin
      Invalidate;
      SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_HIDEWINDOW or SWP_NOZORDER or
        SWP_NOREDRAW);
      if (Container <> nil) and Focused then
        Windows.SetFocus(Container.GetEditingControl.Handle);
    end;
  finally
    FHiding := False;
  end;
end;

function TdxSingleLineInplaceEdit.IsVisible: Boolean;
begin
  Result := HandleAllocated and dxIsWindowStyleSet(Handle, WS_VISIBLE);
end;

procedure TdxSingleLineInplaceEdit.Show(AContainer: IdxInplaceEditContainer; const ABounds: TRect; const AText: string; AFont: TFont; ASelStart, ASelLength: Integer; AMaxLength: Integer);
var
  AEditBounds: TRect;
  AOffset: Integer;
begin
  FContainer := AContainer;
  Parent := AContainer.GetEditingControl;
  SetAppearance(AContainer.GetLookAndFeelPainter, AFont, AContainer.GetTextColor);
  MaxLength := AMaxLength;
  Text := AText;
  SetMargins;
  AEditBounds := ABounds;
  if UseRightToLeftAlignment then
  begin
    if AEditBounds.Right > Container.ClientBounds.Right then
    begin
      AEditBounds.Left := 0;
      AEditBounds.Right := Container.ClientBounds.Right;
      AOffset := 0;
    end
    else
    begin
      AEditBounds.Left := AEditBounds.Right - Min(CalculateWidth, Min(Container.ClientBounds.Right, AEditBounds.Right) - Container.ClientBounds.Left + 4);
      AOffset := 4;
    end;
  end
  else
  begin
    if AEditBounds.Left < Container.ClientBounds.Left then
    begin
      AEditBounds.Left := 0;
      AEditBounds.Right := Container.ClientBounds.Right;
      AOffset := 0;
    end
    else
    begin
      AEditBounds.Width := Min(CalculateWidth, Container.ClientBounds.Right - Max(0, AEditBounds.Left) + 4);
      AOffset := -4;
    end;
  end;
  AEditBounds.Height := GetSingleLineHeight;
  AEditBounds.Offset(AOffset, Floor((ABounds.Height - AEditBounds.Height) / 2));
  BoundsRect := AEditBounds;
  ShowWindow(Handle, SW_SHOWNORMAL);
  SetFocus;
  case ASelLength of
    MaxInt: SelectAll;
    0: Exit;
  else
    SelStart := ASelStart;
    SelLength := ASelLength;
  end;
end;

procedure TdxSingleLineInplaceEdit.SetFocus;
begin
  if IsVisible then
    Windows.SetFocus(Handle);
end;

procedure TdxSingleLineInplaceEdit.KeyPress(var Key: Char);
begin
  case Key of
    #9, #13, #27:
      begin
        Container.FinishEditing(Key <> #27);
        Key := #0;
      end;
  else
    inherited KeyPress(Key);
  end;
end;

procedure TdxSingleLineInplaceEdit.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  Message.Result := Message.Result or DLGC_WANTALLKEYS; 
end;

procedure TdxSingleLineInplaceEdit.WMNCPaint(var Message: TWMNCPaint);
begin
  PaintNonClientArea(Message, FContainer.GetLookAndFeelPainter);
end;

procedure TdxSingleLineInplaceEdit.WMPaste(var Message: TMessage);
var
  AClipboardText: string;
begin
  if ReadOnly then
    inherited
  else
  begin
    Clipboard.Open;
    AClipboardText := Clipboard.AsText;
    Clipboard.Close;
    Container.ValidatePasteText(AClipboardText);
    if Length(AClipboardText) > 0 then
      SetSelText(AClipboardText);
  end;
end;

procedure TdxSingleLineInplaceEdit.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_SETFOCUS:
      begin
        if (GetParentForm(Self) = nil) or
           ((Container <> nil) and GetParentForm(Self).SetFocusedControl(Container.GetEditingControl)) then
          Dispatch(Message);
        Exit;
      end;
    WM_KILLFOCUS:
      if (Container <> nil) and not FHiding then
        Container.FinishEditing(not (csDestroying in ComponentState));
    WM_LBUTTONDOWN:
      begin
        if UINT(GetMessageTime - FClickTime) < GetDoubleClickTime then
          Message.Msg := WM_LBUTTONDBLCLK;
        FClickTime := 0;
      end;
  end;
  inherited WndProc(Message);
end;

{ TCustomEditHelper }

function TCustomEditHelper.GetExtraHeight: Integer;
var
  ADC: HDC;
  ASaveFont: HFont;
  ASysMetrics, AMetrics: TTextMetric;
begin
  if NewStyleControls then
    Result := GetSystemMetrics(SM_CYBORDER) * 6
  else
  begin
    ADC := GetDC(0);
    try
      GetTextMetrics(ADC, ASysMetrics);
      ASaveFont := SelectObject(ADC, Font.Handle);
      GetTextMetrics(ADC, AMetrics);
      SelectObject(ADC, ASaveFont);
    finally
      ReleaseDC(0, ADC);
    end;
    Result := ASysMetrics.tmHeight;
    if Result > AMetrics.tmHeight then
      Result := AMetrics.tmHeight;
    Result := Result div 4 + GetSystemMetrics(SM_CYBORDER) * 4;
  end;
end;

function TCustomEditHelper.GetExtraWidth: Integer;
begin
  if NewStyleControls then
    Result := GetSystemMetrics(SM_CXBORDER) * 6
  else
    Result := 4 + GetSystemMetrics(SM_CXBORDER) * 4;
  Inc(Result, 2); 
end;

function TCustomEditHelper.GetSingleLineHeight: Integer;
begin
  Result := TdxTextMeasurer.TextLineHeight(Font) + GetExtraHeight;
end;

procedure TCustomEditHelper.PaintNonClientArea(var Message: TWMNCPaint; APainter: TcxCustomLookAndFeelPainter);
var
  DC: HDC;
  AClientRect, AWindowRect: TRect;
  ABorderColor: TColor;
begin
  DC := GetWindowDC(Handle);
  try
    Windows.GetClientRect(Handle, AClientRect);
    GetWindowRect(Handle, AWindowRect);
    MapWindowPoints(0, Handle, AWindowRect, 2);
    OffsetRect(AClientRect, -AWindowRect.Left, -AWindowRect.Top);
    OffsetRect(AWindowRect, -AWindowRect.Left, -AWindowRect.Top);
    ExcludeClipRect(DC, AClientRect.Left, AClientRect.Top, AClientRect.Right, AClientRect.Bottom);
    Windows.FillRect(DC, AWindowRect, Brush.Handle);
    ABorderColor := APainter.DefaultEditorTextColor(False);
    if ABorderColor = clDefault then
      ABorderColor := clWindowText;
    Windows.FrameRect(DC, AWindowRect, TdxSolidBrushCache.Get(ABorderColor));
  finally
    ReleaseDC(Handle, DC);
  end;
  Message.Result := 0;
end;

procedure TCustomEditHelper.SetAppearance(APainter: TcxCustomLookAndFeelPainter; AFont: TFont; ATextColor: TColor);
var
  AColor: TColor;
begin
  if AFont <> nil then
    Font.Assign(AFont);
  Font.Color := ATextColor;
  AColor := APainter.DefaultEditorBackgroundColor(False);
  if AColor = clDefault then
    Color := clWindow
  else
    Color := AColor;
end;

procedure TCustomEditHelper.SetKeyPressEvent(AEvent: TKeyPressEvent);
begin
  OnKeyPress := AEvent;
end;

procedure TCustomEditHelper.SetMargins;
var
  AMargins: DWord;
begin
  AMargins := MakeLong(1, 1);
  SendMessage(Handle, EM_SETMARGINS, EC_LEFTMARGIN or EC_RIGHTMARGIN, AMargins);
end;

{ TdxInplaceEditingController }

destructor TdxInplaceEditingController.Destroy;
begin
  DestroyTimer;
  DestroyEdit;
  inherited Destroy;
end;

procedure TdxInplaceEditingController.StartEditingTimer;
begin
  DestroyTimer;
  FEditingTimer := TcxTimer.Create(nil);
  FEditingTimer.Interval := GetDoubleClickTime;
  FEditingTimer.OnTimer := StartEditing;
end;

procedure TdxInplaceEditingController.DestroyEdit;
begin
  FreeAndNil(FInplaceEditImplementator);
end;

procedure TdxInplaceEditingController.DestroyTimer;
begin
  FreeAndNil(FEditingTimer);
end;

procedure TdxInplaceEditingController.InplaceEditKeyPress(Sender: TObject; var AKey: Char);
begin
end;

function TdxInplaceEditingController.IsReadOnly: Boolean;
begin
  Result := False;
end;

function TdxInplaceEditingController.IsMultiline: Boolean;
begin
  Result := False;
end;

procedure TdxInplaceEditingController.StartItemCaptionEditing;
begin
end;

function TdxInplaceEditingController.CreateInplaceEditImplementator: TCustomEdit;
begin
  if IsMultiline then
    Result := TdxMultiLineInplaceEdit.Create(nil)
  else
    Result := TdxSingleLineInplaceEdit.Create(nil);
  Result.SetKeyPressEvent(InplaceEditKeyPress);
  Result.ReadOnly := IsReadOnly;
end;

function TdxInplaceEditingController.GetInplaceEdit: IdxInplaceEdit;
begin
  if FInplaceEditImplementator = nil then
    FInplaceEditImplementator := CreateInplaceEditImplementator;
  Supports(FInplaceEditImplementator, IdxInplaceEdit, Result);
end;

procedure TdxInplaceEditingController.StartEditing(Sender: TObject);
begin
  DestroyTimer;
  StartItemCaptionEditing;
end;

{ TdxMultiLineInplaceEdit }

constructor TdxMultiLineInplaceEdit.Create(AOwner: TComponent);
begin
  inherited Create(nil);
  Alignment := taCenter;
  Ctl3D := True;
  TabStop := False;
  BorderStyle := bsSingle;
  BorderWidth := 0;
  DoubleBuffered := False;
  WordWrap := True;
  ScrollBars := ssNone;
end;

procedure TdxMultiLineInplaceEdit.CMShowingChanged(var Message: TMessage);
begin
// do nothing
end;

function TdxMultiLineInplaceEdit.DoMouseWheel(Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint): Boolean;
begin
  Result := FContainer.DoMouseWheel(Shift, WheelDelta, MousePos);
end;


function TdxMultiLineInplaceEdit.GetValue: string;
begin
  Result := Text;
end;

function TdxMultiLineInplaceEdit.IsVisible: Boolean;
begin
  Result := HandleAllocated and dxIsWindowStyleSet(Handle, WS_VISIBLE);
end;

procedure TdxMultiLineInplaceEdit.Hide;
begin
  FHiding := True;
  try
    if IsVisible then
    begin
      Invalidate;
      SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_HIDEWINDOW or SWP_NOZORDER or
        SWP_NOREDRAW);
      if Focused then
        Windows.SetFocus(FContainer.GetEditingControl.Handle);
    end;
  finally
    FHiding := False;
  end;
end;

procedure TdxMultiLineInplaceEdit.Show(AContainer: IdxInplaceEditContainer; const ABounds: TRect; const AText: string; AFont: TFont; ASelStart, ASelLength: Integer; AMaxLength: Integer);
var
  AEditBounds: TRect;
begin
  FFContainer := AContainer;
  Parent := AContainer.GetEditingControl;
  SetAppearance(AContainer.GetLookAndFeelPainter, AFont, AContainer.GetTextColor);
  MaxLength := AMaxLength;
  Text := AText;
  SetMargins;
  AEditBounds := ABounds;
  FAvailableWidth := ABounds.Width - GetExtraWidth;
  AEditBounds.Offset(0, -GetExtraHeight div 2);
  FInitialBounds := AEditBounds;
  CalculateBounds;
  ShowWindow(Handle, SW_SHOWNORMAL);
  SetFocus;
  case ASelLength of
    MaxInt: SelectAll;
    0: Exit;
  else
    SelStart := ASelStart;
    SelLength := ASelLength;
  end;
end;

procedure TdxMultiLineInplaceEdit.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  if (FContainer <> nil) and (ATop + AHeight > FContainer.GetClientBounds.Bottom) then
    ATop := FContainer.GetClientBounds.Bottom - AHeight;
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
end;

procedure TdxMultiLineInplaceEdit.SetFocus;
begin
  if IsVisible then
    Windows.SetFocus(Handle);
end;

procedure TdxMultiLineInplaceEdit.KeyPress(var Key: Char);
begin
  case Key of
    #9, #13, #27:
      begin
        FContainer.FinishEditing(Key <> #27);
        Key := #0;
      end;
  end;
  if Key <> #0 then
    inherited KeyPress(Key);
end;

procedure TdxMultiLineInplaceEdit.CalculateBounds;
var
  R: TRect;
  ALineHeight, ATextLength, AExtraHSize: Integer;
  AText: string;
  ASize: TSize;
begin
  AExtraHSize := FContainer.GetScaleFactor.Apply(32);
  ALineHeight := TdxTextMeasurer.TextLineHeight(Font);
  AText := Text;
  ATextLength := Length(AText);
  if (FContainer = nil) or (ATextLength = 0) then
    ASize.Init(AExtraHSize, ALineHeight)
  else
  begin
    R.InitSize(0, 0, FAvailableWidth, $FFFF);
    TdxTextMeasurer.TextRectDT(R, AText, Font, DT_EDITCONTROL or DT_WORDBREAK or DT_CALCRECT or DT_NOPREFIX);
    ASize := R.Size;
    if (ATextLength >= 2) and (AText[ATextLength - 1] = #13) and (AText[ATextLength] = #10) then
      Inc(ASize.cy, ALineHeight);
    Inc(ASize.cx, AExtraHSize);
    if ASize.cx > FAvailableWidth then
      ASize.cx := FAvailableWidth;
  end;
  Inc(ASize.cx, GetExtraWidth);
  Inc(ASize.cy, GetExtraHeight);
  R.InitSize(FInitialBounds.Left + (FInitialBounds.Width - ASize.cx) div 2, FInitialBounds.Top, ASize);
  BoundsRect := R;
end;

procedure TdxMultiLineInplaceEdit.Change;
begin
  CalculateBounds;
  inherited Change;
end;

procedure TdxMultiLineInplaceEdit.WMNCPaint(var Message: TWMNCPaint);
begin
  PaintNonClientArea(Message, FContainer.GetLookAndFeelPainter);
end;

procedure TdxMultiLineInplaceEdit.WMPaste(var Message: TMessage);
var
  AClipboardText: string;
begin
  if ReadOnly then
    inherited
  else
  begin
    Clipboard.Open;
    AClipboardText := Clipboard.AsText;
    Clipboard.Close;
    FContainer.ValidatePasteText(AClipboardText);
    if Length(AClipboardText) > 0 then
      SetSelText(AClipboardText);
  end;
end;

procedure TdxMultiLineInplaceEdit.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_SETFOCUS:
      begin
        if (GetParentForm(Self) = nil) or
           ((FContainer <> nil) and GetParentForm(Self).SetFocusedControl(FContainer.GetEditingControl)) then
          Dispatch(Message);
        Exit;
      end;
    WM_KILLFOCUS:
      if (FContainer <> nil) and not FHiding then
        FContainer.FinishEditing(not (csDestroying in ComponentState));
    WM_LBUTTONDOWN:
      begin
        if UINT(GetMessageTime - FClickTime) < GetDoubleClickTime then
          Message.Msg := WM_LBUTTONDBLCLK;
        FClickTime := 0;
      end;
  end;
  inherited WndProc(Message);
end;

end.
