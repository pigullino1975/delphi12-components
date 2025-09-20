{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressCore Library                                      }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSCORE LIBRARY AND ALL           }
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

unit dxPopupMenus; // for internal use

interface

{$I cxVer.inc}

{$SCOPEDENUMS ON}


uses
  System.UITypes,
  Windows, Messages, Types, SysUtils, Classes, Graphics, Generics.Collections, Generics.Defaults,
  Controls, Menus, Forms,
  dxThemeConsts, dxUxTheme, dxGdiPlusClasses, cxGraphics, ImgList, cxLookAndFeels;

type

  { TdxPopupMenuItemInfo }

  TdxPopupMenuItemInfo = class // for internal use
  protected type
    TDrawImageKind = (None, ImageList, CheckMark, Bitmap, HBITMAP);
    TPaintMode = (Standard, Skin, Special);
  protected const
    ActualRightAlignment: array[Boolean] of Word = (DT_RIGHT, DT_LEFT);
    CheckMarkStates: array[Boolean, Boolean] of Cardinal = ((MC_CHECKMARKDISABLED, MC_BULLETDISABLED), (MC_CHECKMARKNORMAL, MC_BULLETNORMAL));
    ItemStates: array[Boolean, Boolean] of Cardinal = ((MPI_DISABLED, MPI_DISABLEDHOT), (MPI_NORMAL, MPI_HOT));
    SelectionBackgroundStates: array[Boolean] of Cardinal = (MPI_DISABLEDHOT, MPI_HOT);
  private
    FAlignment: TPopupAlignment;
    FBiDiMode: TBiDiMode;
    FBitmap: TBitmap;
    FBounds: TRect;
    FCaption: string;
    FGlyphSize: Integer;
    FGutterBounds: TRect;
    FImageBackgroundBounds: TRect;
    FImageBounds: TRect;
    FImageIndex: Integer;
    FImageKind: TDrawImageKind;
    FImageList: TCustomImageList;
    FInfo: TMenuItemInfo;
    FIsSeparator: Boolean;
    FPaintMode: TPaintMode;
    FPPI: Integer;
    FSelectionBounds: TRect;
    FSeparatorBounds: TRect;
    FShortCutBounds: TRect;
    FShortCutText: string;
    FState: TOwnerDrawState;
    FSubmenuArrowBounds: TRect;
    FSubmenuArrowExcludeBounds: TRect;
    FSubMenuSize: TSize;
    FTextAreaBounds: TRect;
    FTextBounds: TRect;
    FTextFlags: Longint;
    FTextMargins: TdxMargins;
    FTheme: TdxTheme;
    FWinXPFlatMenus: Boolean;
    FHasSubmenu: Boolean;
    FChecked: Boolean;
    FRadioItem: Boolean;
    procedure AdjustItemTextBounds(DC: HDC; const ACaption: string; var ARect: TRect);
    function GetActualRectangle(const ARectangle: TRect): TRect;
    function GetAlignment(AParentMenu: TMenu): TPopupAlignment;
    function GetTextFlags(AState: TOwnerDrawState): Longint;
    function GetChecked: Boolean; inline;
    function GetDefault: Boolean; inline;
    function GetEnabled: Boolean; inline;
    function GetHotLight: Boolean; inline;
    function GetSelected: Boolean; inline;
    class procedure BltColor(ADestDC: HDC; AColorBrush: HBRUSH; ASourceDC: HDC; x, y, cx, cy, ASrcX, ASrcY: Integer; ABltFlags: UINT); static;
    class procedure InternalDrawPopupSystemIcon(ADestDC: HDC; const ABounds: TRect; AGroup, AElement, ASize: Integer; AColor: TColor; AEnabled: Boolean); static;
    procedure CalculateSubmenuArrowBounds(ACanvas: TcxCanvas; const ABounds: TRect; AState: TOwnerDrawState);
  protected
    procedure CalculateThemedLayout(DC: HDC);
    procedure CalculateClassicLayout(DC: HDC);
    procedure DrawImageListItem(ACanvas: TcxCanvas; const ABounds: TRect);
    procedure DrawThemedTexts(ACanvas: TcxCanvas);
    procedure DrawHBITMAP(DC: HDC; const ABounds: TRect; AColor: TColor; AEnabled: Boolean);
    procedure ExcludeSubmenuArrow(DC: HDC);

    procedure Initialize(APPI: Integer);
    procedure ClassicDraw(ACanvas: TcxCanvas; const ABounds: TRect; AState: TOwnerDrawState);
    procedure ThemedDraw(ACanvas: TcxCanvas; const ABounds: TRect; AState: TOwnerDrawState);
    procedure SkinPainterDraw(ACanvas: TcxCanvas; const ABounds: TRect; AState: TOwnerDrawState);

    property Info: TMenuItemInfo read FInfo;
  public
    constructor CreateFromMenuItem(AMenuItem: TMenuItem; AImageList: TCustomImageList);
    constructor CreateFromMenuInfo(AMenuWindow: HWND; AMenu: HMENU; ADrawItem: PDrawItemStruct);
    procedure CalculateLayout(ACanvas: TcxCanvas; const ABounds: TRect; AState: TOwnerDrawState);
    procedure Draw(ACanvas: TcxCanvas; const ABounds: TRect; AState: TOwnerDrawState);
    procedure DrawPopupSystemCheck(ADestDC: HDC; const ABounds: TRect; AIsRadioItem: Boolean; AColor: TColor; AEnabled: Boolean);
    procedure DrawPopupSystemIcon(ADestDC: HDC; const ABounds: TRect; AID: Integer; AColor: TColor; AEnabled: Boolean);

    property Checked: Boolean read GetChecked;
    property Default: Boolean read GetDefault;
    property HotLight: Boolean read GetHotLight;
    property Selected: Boolean read GetSelected;
    property Enabled: Boolean read GetEnabled;
  end;

  { TdxPopupMenuController }

  TdxPopupMenuController = class
  strict protected type
    TPopupMenuKind = (External, VCL, Application);
    TContextMenuInfo = record
      Window: HWND;
      WndProc: Pointer;
      Menu: HMENU;
      OldBrush: HBRUSH;
      PopupMenu: TPopupMenu;
      constructor Create(AMenuWindow: HWND; AWndProc: Pointer);
    end;
  strict private
    class var FBypassWndProc: Boolean;
    class var FIsHookInstalled: Boolean;
    class var FIsPopupListWindowSubclassed: Boolean;
    class var FMatchWindows11Appearance: Boolean;
    class var FMenuWindows: TList<TContextMenuInfo>;
    class var FOldPopupListWndProc: Pointer;
    class var FUseSkins: Boolean;

    class procedure AddContextMenu(AMenuWindow: HWND); static;
    class function CallOriginalWindowProc(hwnd: HWND; uMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; static;
    class function GetContextMenuInfoIndex(AMenuWindow: HWND): Integer; static;
    class function GetPopupMenuKind(AWindowHandle: HWND): TPopupMenuKind; static;
    class function GetPopupMenuOwnerWindow(APopupMenuWindow: HWND): HWND; static;
    class function IsMenuWindow(AWindowHandle: HWND): Boolean; static;
    class procedure RemoveContextMenu(AMenuWindow: HWND); static;
    class procedure SetHook;
    class procedure SetMatchWindows11Appearance(AValue: Boolean); static;
    class procedure SetUseSkins(AValue: Boolean); static;
    class procedure SubclassPopupListWindow(AEnable: Boolean); static;
  protected
    class procedure DrawNonClientArea(Wnd: HWND; DC: HDC; Rgn: HRGN); static;
    class function DrawMenuItem(hwnd: HWND; wParam: WPARAM; lParam: LPARAM): LPARAM; static;

    class procedure Finalize; static;
    class function IsSkinPainting: Boolean; static; inline;
    class function IsMatchWindows11AppearancePainting: Boolean; static; inline;
    class function MenuWindowProc(hwnd: HWND; uMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall; static;
    class function PopupListWindowProc(hwnd: HWND; uMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall; static;
    class procedure ReleaseHook;
    class procedure WindowsWatcher(nCode: Integer; wParam: WPARAM; lParam: LPARAM; var AHookResult: LRESULT); static;
  public
    class property MatchWindows11Appearance: Boolean read FMatchWindows11Appearance write SetMatchWindows11Appearance;
    class property UseSkins: Boolean read FUseSkins write SetUseSkins;
  end;

implementation

uses
  dxTypeHelpers, cxControls, dxCore, dxThemeManager, cxGeometry, dxHooks, dxThreading,
  Math, dxCoreGraphics, dxDPIAwareUtils, dxSkinsCore, cxLookAndFeelPainters, dxSkinInfo, cxDWMApi, dxForms,
  dxCoreClasses;

const
  dxThisUnitName = 'dxPopupMenus';

const
  DCX_USESTYLE = $00010000;

  BC_INVERT                  = $00000001;
  BC_NOMIRROR                = $00000002;

  DFC_CACHE                  = $FFFF;

  DFCS_INMENU                = $0040;
  DFCS_INSMALL               = $0080;

  HBMMENU_POPUPFIRST         = 8;
  HBMMENU_POPUP_CLOSE        = 8;
  HBMMENU_POPUP_RESTORE      = 9;
  HBMMENU_POPUP_MAXIMIZE     = 10;
  HBMMENU_POPUP_MINIMIZE     = 11;
  HBMMENU_POPUPLAST          = 11;

  OBI_POPUPFIRST             = 87;      
  OBI_CLOSE_POPUP            = 87;
  OBI_RESTORE_POPUP          = 88;
  OBI_ZOOM_POPUP             = 89;
  OBI_REDUCE_POPUP           = 90;
  OBI_NCGRIP_L               = 91;
  OBI_MENUARROW_L            = 92;
  OBI_COUNT                  = 93;      

  WM_UAHDESTROYWINDOW        = $0090;
  WM_UAHDRAWMENU             = $0091;
  WM_UAHDRAWMENUITEM         = $0092;
  WM_UAHINITMENU             = $0093;
  WM_UAHMEASUREMENUITEM      = $0094;
  WM_UAHNCPAINTMENUPOPUP     = $0095;
  MN_SETHMENU                = $01E0;
  MN_GETHMENU                = $01E1;
  MN_SIZEWINDOW              = $01E2;
  MN_OPENHIERARCHY           = $01E3;
  MN_CLOSEHIERARCHY          = $01E4;
  MN_SELECTITEM              = $01E5;
  MN_CANCELMENUS             = $01E6;
  MN_SELECTFIRSTVALIDITEM    = $01E7;
  MN_GETPPOPUPMENU           = $01EA;
  MN_FINDMENUWINDOWFROMPOINT = $01EB;
  MN_SHOWPOPUPWINDOW         = $01EC;
  MN_BUTTONDOWN              = $01ED;
  MN_MOUSEMOVE               = $01EE;
  MN_BUTTONUP                = $01EF;
  MN_SETTIMERTOOPENHIERARCHY = $01F0;
  MN_DBLCLK                  = $01F1;

type
  TMenuItemAccess = class(TMenuItem);
  TMenuAccess = class(TMenu);

  PdxUAHMenu = ^TdxUAHMenu;
  TdxUAHMenu = packed record
    hmenu: HMENU;
    hdc: HDC;
    dwFlags: DWORD; 
  end;

  TdxUAHMenuItemMetrics = packed record
    rgsizeBar: array[0..1] of TSize;
    rgsizePopup: array[0..3] of TSize;
  end;

  TdxUAHMenuPopupMetrics = packed record
    rgcx: array[0..3] of DWORD;
    fUpdateMaxWidths: DWORD; 
  end;

  TdxUAHMenuItem = packed record
    iPosition: DWORD; 
    umim: TdxUAHMenuItemMetrics;
    umpm: TdxUAHMenuPopupMetrics;
  end;

  PdxUAHDrawMenuItem = ^TdxUAHDrawMenuItem;
  TdxUAHDrawMenuItem = packed record
    dis: TDrawItemStruct; 
    um: TdxUAHMenu;
    umi: TdxUAHMenuItem;
  end;

  PdxUAHMeasureMenuItem = ^TdxUAHMeasureMenuItem;
  TdxUAHMeasureMenuItem = packed record
    mis: TMeasureItemStruct;
    um: TdxUAHMenu;
    umi: TdxUAHMenuItem;
  end;

  { TdxPopupLookAndFeelListener }

  TdxPopupLookAndFeelListener = class(TcxIUnknownObject, IcxLookAndFeelNotificationListener)
  strict private
    class var FInstance: TcxIUnknownObject;
  strict private
    class procedure Refresh;
    // IcxLookAndFeelNotificationListener
    function GetObject: TObject;
    procedure MasterLookAndFeelChanged(Sender: TcxLookAndFeel; AChangedValues: TcxLookAndFeelValues); virtual;
    procedure MasterLookAndFeelDestroying(Sender: TcxLookAndFeel); virtual;
  public
    class procedure Register;
    class procedure Unregister;
  end;

  { TPopupSkinPainter }

  TPopupSkinPainter = record
  private
    FSkinPainter: TcxCustomLookAndFeelPainter;
    FBkgBrush: HBRUSH;
    FBorderSize: TRect;
    FBrushColor: TColor;
    function GetDisabledTextColor: TdxSkinColor;
    function GetDefaultEnabledTextColor(ASelected, AFlat: Boolean): TColor;
    function GetSkinPainterData(var AData: TdxSkinInfo): Boolean;
    function GetPopupMenuLinkSelected: TdxSkinElement;
    function GetPopupMenuSeparator: TdxSkinElement;
    function GetPopupMenu: TdxSkinElement;
    function GetPopupMenuCheck: TdxSkinElement;
    function GetThinSeparator: TdxSkinElement;
    function GetGutter: TdxSkinElement;
    function GetSkinElementTextColor(ASkinElement: TdxSkinElement; AState: TcxButtonState): TColor;
  public
    function DrawSkinElement(AElement: TdxSkinElement; DC: HDC; const ARect: TRect; AScaleFactor: TdxScaleFactor;
      AImageIndex: Integer = 0; AState: TdxSkinElementState = esNormal; AIsRightToLeft: Boolean = False): Boolean;
    procedure DrawNCBackground(DC: HDC; const AWindowRect, AClientRect: TRect);
    procedure DrawGutter(DC: HDC; const R: TRect);
    procedure DrawSeparator(DC: HDC; const R: TRect);

    constructor Init(APainter: TcxCustomLookAndFeelPainter);
    procedure DrawBackground(DC: HDC; const ARect: TRect);
    function DrawSkinElementContent(AElement: TdxSkinElement; DC: HDC; const ARect: TRect;
      AScaleFactor: TdxScaleFactor; AImageIndex: Integer = 0; AState: TdxSkinElementState = esNormal): Boolean;
    procedure DrawItemBackground(DC: HDC; AEnabled, AHot: Boolean; const ARect: TRect);
    function GetSkinElementSize(ASkinElement: TdxSkinElement; AScaleFactor: TdxScaleFactor): TSize;
    function GetTextColor(AEnabled, ASelected, AFlat: Boolean): TColor;
    procedure SetBrushColor(AColor: TColor);

    property BkgBrush: HBRUSH read FBkgBrush;
    property DisabledTextColor: TdxSkinColor read GetDisabledTextColor;
    property Gutter: TdxSkinElement read GetGutter;
    property PopupMenu: TdxSkinElement read GetPopupMenu;
    property PopupMenuLinkSelected: TdxSkinElement read GetPopupMenuLinkSelected;
    property PopupMenuSeparator: TdxSkinElement read GetPopupMenuSeparator;
    property PopupMenuCheck: TdxSkinElement read GetPopupMenuCheck;
    property ThinSeparator: TdxSkinElement read GetThinSeparator;
  end;

var
  Painter: TPopupSkinPainter;

function GetMenuBackgroundBrush(AMenuHandle: HMENU): HBRUSH;
var
  AMenuInfo: TMenuInfo;
begin
  AMenuInfo.cbSize := SizeOf(TMenuInfo);
  AMenuInfo.fMask := MIM_BACKGROUND;
  GetMenuInfo(AMenuHandle, AMenuInfo);
  Result := AMenuInfo.hbrBack;
end;

procedure SetMenuBackgroundBrush(AMenuHandle: HMENU; ABrush: HBRUSH);
var
  AMenuInfo: TMenuInfo;
begin
  AMenuInfo.cbSize := SizeOf(TMenuInfo);
  AMenuInfo.fMask := MIM_BACKGROUND or MIM_APPLYTOSUBMENUS;
  AMenuInfo.hbrBack := ABrush;
  SetMenuInfo(AMenuHandle, AMenuInfo);
end;

function GetMenuItemInfo(AMenuHandle: THandle; I: Cardinal; AByPosition: Boolean = True): TMenuItemInfo;
begin
  FillChar(Result, SizeOf(TMenuItemInfo), 0);
  Result.cbSize := SizeOf(TMenuItemInfo);
  Result.fMask := MIIM_STRING or MIIM_SUBMENU or MIIM_CHECKMARKS or MIIM_FTYPE or MIIM_BITMAP or MIIM_ID;
  Result.dwTypeData := nil;
  GetMenuItemInfoW(AMenuHandle, I, AByPosition, Result);
  Inc(Result.cch);

  Result.dwTypeData := AllocMem(Result.cch * SizeOf(Char));
  GetMenuItemInfoW(AMenuHandle, I, AByPosition, Result);
end;

function SetFontWeight(DC: HDC; ABold: Boolean; out ANewFont: HFONT): HFONT;
var
  lf: TLogFont;
begin
  ANewFont := 0;
  Result := GetCurrentObject(DC, OBJ_FONT);
  GetObject(Result, SizeOf(lf), @lf);
  if ABold then
    lf.lfWeight := FW_BOLD
  else
    lf.lfWeight := FW_NORMAL;
  ANewFont := CreateFontIndirect(lf);
  SelectObject(DC, ANewFont);
end;

function GetDevicePPI(AMenuItem: TMenuItem): Integer;
var
  DC: HDC;
  AParent: TMenu;
  APlacement: TWindowPlacement;
  AMonitor: TMonitor;
begin
  AParent := AMenuItem.GetParentMenu;
  if (AParent <> nil) and (AParent.Owner is TWinControl) and CheckWin32Version(6, 3) then
  begin
    APlacement.length := SizeOf(TWindowPlacement);
    if (TWinControl(AParent.Owner).Handle > 0) and GetWindowPlacement(TWinControl(AParent.Owner).Handle, APlacement) then
    begin
      if TWinControl(AParent.Owner).Parent = nil then
        AMonitor := Screen.MonitorFromPoint(APlacement.rcNormalPosition.CenterPoint)
      else
        AMonitor := Screen.MonitorFromPoint(TWinControl(AParent.Owner).ClientToScreen(APlacement.rcNormalPosition.CenterPoint))
    end
    else
      AMonitor := Screen.MonitorFromWindow(Application.Handle);
    if AMonitor <> nil then
      Result := dxGetMonitorDPI(AMonitor)
    else
      Result := Screen.PixelsPerInch;
  end
  else
    if Screen.ActiveCustomForm <> nil then
      Result := dxGetMonitorDPI(Screen.ActiveCustomForm.Handle)
    else
    begin
      DC := GetDC(0);
      Result := GetDeviceCaps(DC, LOGPIXELSY);
      ReleaseDC(0, DC);
    end;
end;

{ TdxPopupLookAndFeelListener }

function TdxPopupLookAndFeelListener.GetObject: TObject;
begin
  Result := Self;
end;

procedure TdxPopupLookAndFeelListener.MasterLookAndFeelChanged(Sender: TcxLookAndFeel; AChangedValues: TcxLookAndFeelValues);
begin
  Refresh;
end;

procedure TdxPopupLookAndFeelListener.MasterLookAndFeelDestroying(Sender: TcxLookAndFeel);
begin
  // do nothing
end;

class procedure TdxPopupLookAndFeelListener.Refresh;
begin
  TdxPopupMenuController.UseSkins := cxUseSkinsInPopupMenus;
  TdxPopupMenuController.MatchWindows11Appearance := dxSkinFormCorners <> fcRectangular;
end;

class procedure TdxPopupLookAndFeelListener.Register;
begin
  FInstance := TdxPopupLookAndFeelListener.Create;
  RootLookAndFeel.AddChangeListener(FInstance);
  Refresh;
end;

class procedure TdxPopupLookAndFeelListener.Unregister;
begin
  if IsRootLookAndFeelAssigned then
    RootLookAndFeel.RemoveChangeListener(FInstance);
  FreeAndNil(FInstance);
end;

{ TPopupSkinPainter }

constructor TPopupSkinPainter.Init(APainter: TcxCustomLookAndFeelPainter);
var
  AElement: TdxSkinElement;
begin
  FSkinPainter := APainter;
  AElement := PopupMenu;
  if AElement <> nil then
  begin
    SetBrushColor(PopupMenu.Color);
    with AElement.Image.Margins.Margin do
      FBorderSize.Init(
        Max(Left, AElement.Borders.Left.Thin),
        Max(Top, AElement.Borders.Top.Thin),
        Max(Right, AElement.Borders.Right.Thin),
        Max(Bottom, AElement.Borders.Bottom.Thin));
  end
  else
  begin
    FBorderSize.Init(1, 1, 1, 1);
    SetBrushColor(clMenu);
  end;
end;

function TPopupSkinPainter.DrawSkinElement(AElement: TdxSkinElement; DC: HDC; const ARect: TRect;
  AScaleFactor: TdxScaleFactor; AImageIndex: Integer = 0; AState: TdxSkinElementState = esNormal;
  AIsRightToLeft: Boolean = False): Boolean;
begin
  Result := AElement <> nil;
  if Result then
    AElement.RightToLeftDependentDraw(DC, ARect, AScaleFactor, AIsRightToLeft, Min(AImageIndex, AElement.ImageCount), AState);
end;

function TPopupSkinPainter.GetDisabledTextColor: TdxSkinColor;
var
  ASkinPainterInfo: TdxSkinInfo;
begin
  Result := nil;
  if GetSkinPainterData(ASkinPainterInfo) then
    Result := ASkinPainterInfo.BarDisabledTextColor;
end;

function TPopupSkinPainter.GetSkinPainterData(var AData: TdxSkinInfo): Boolean;
begin
  Result := (FSkinPainter <> nil) and FSkinPainter.GetPainterData(AData);
end;

function TPopupSkinPainter.GetTextColor(AEnabled, ASelected, AFlat: Boolean): TColor;
var
  ADisabledColor: TdxSkinColor;
begin
  if AEnabled then
    Result := GetDefaultEnabledTextColor(ASelected, AFlat)
  else
  begin
    ADisabledColor := DisabledTextColor;
    if ADisabledColor <> nil then
      Result := ADisabledColor.Value
    else
      Result := FSkinPainter.DefaultEditorTextColor(True);
  end;
end;

function TPopupSkinPainter.GetPopupMenu: TdxSkinElement;
var
  ASkinPainterInfo: TdxSkinInfo;
begin
  Result := nil;
  if GetSkinPainterData(ASkinPainterInfo) then
    Result := ASkinPainterInfo.PopupMenu;
end;

function TPopupSkinPainter.GetPopupMenuCheck: TdxSkinElement;
var
  ASkinPainterInfo: TdxSkinInfo;
begin
  Result := nil;
  if GetSkinPainterData(ASkinPainterInfo) then
    Result := ASkinPainterInfo.PopupMenuCheck;
end;

function TPopupSkinPainter.GetThinSeparator: TdxSkinElement;
var
  ASkinPainterInfo: TdxSkinInfo;
begin
  Result := nil;
  if GetSkinPainterData(ASkinPainterInfo) then
    Result := ASkinPainterInfo.LabelLine[False];
end;

function TPopupSkinPainter.GetGutter: TdxSkinElement;
var
  ASkinPainterInfo: TdxSkinInfo;
begin
  Result := nil;
  if GetSkinPainterData(ASkinPainterInfo) then
    Result := ASkinPainterInfo.PopupMenuSideStrip;
end;

function TPopupSkinPainter.GetPopupMenuLinkSelected: TdxSkinElement;
var
  ASkinPainterInfo: TdxSkinInfo;
begin
  Result := nil;
  if GetSkinPainterData(ASkinPainterInfo) then
    Result := ASkinPainterInfo.PopupMenuLinkSelected;
end;

function TPopupSkinPainter.GetPopupMenuSeparator: TdxSkinElement;
var
  ASkinPainterInfo: TdxSkinInfo;
begin
  Result := nil;
  if GetSkinPainterData(ASkinPainterInfo) then
    Result := ASkinPainterInfo.PopupMenuSeparator;
end;

procedure TPopupSkinPainter.DrawNCBackground(DC: HDC; const AWindowRect, AClientRect: TRect);
var
  R: TRect;
  AHasScrollArrows: Boolean;
begin
  AHasScrollArrows := AClientRect.Left * 2 < AClientRect.Top;
  if AHasScrollArrows then
  begin
    R := AWindowRect;
    R.Deflate(FBorderSize);
    R.Bottom := AClientRect.Top;
    ExcludeClipRect(DC, R.Left, R.Top, R.Right, R.Bottom); 
    R := AWindowRect;
    R.Deflate(FBorderSize);
    R.Top := AClientRect.Bottom;
    ExcludeClipRect(DC, R.Left, R.Top, R.Right, R.Bottom); 
  end;
  ExcludeClipRect(DC, AClientRect.Left, AClientRect.Top, AClientRect.Right, AClientRect.Bottom); 
  DrawSkinElement(PopupMenu, DC, AWindowRect, dxSystemScaleFactor);
end;

function TPopupSkinPainter.DrawSkinElementContent(AElement: TdxSkinElement; DC: HDC; const ARect: TRect;
  AScaleFactor: TdxScaleFactor; AImageIndex: Integer = 0; AState: TdxSkinElementState = esNormal): Boolean;
begin
  Result := AElement <> nil;
  if Result then
    AElement.Draw(DC, cxRectInflate(ARect, AElement.ContentOffset.Rect), ARect, AScaleFactor, AImageIndex, AState);
end;

procedure TPopupSkinPainter.DrawItemBackground(DC: HDC; AEnabled, AHot: Boolean; const ARect: TRect);
const
  MenuStatesMap: array[Boolean] of TdxSkinElementState = (esDisabled, esHot);
  SelectedStatesMap: array[Boolean, Boolean] of TdxSkinElementState = ((esHot, esPressed), (esHotCheck, esCheckPressed));
var
  AElement: TdxSkinElement;
begin
  if not AHot then
  begin
    DrawBackground(DC, ARect);
    Exit;
  end;
  AElement := PopupMenuLinkSelected;
  if AElement <> nil then
  begin
    if AHot then
      if AEnabled then
        DrawSkinElement(AElement, DC, ARect, dxDefaultScaleFactor, 0, esHot, False)
      else
        DrawSkinElement(AElement, DC, ARect, dxDefaultScaleFactor, 0, esDisabled, False);
  end;
end;

procedure TPopupSkinPainter.DrawBackground(DC: HDC; const ARect: TRect);
var
  R: TRect;
  AElement: TdxSkinElement;
  ASaveIndex: Integer;
begin
  AElement := PopupMenu;
  if AElement <> nil then
  begin
    ASaveIndex := SaveDC(DC);
    try
      IntersectClipRect(DC, ARect.Left, ARect.Top, ARect.Right, ARect.Bottom);
      R := ARect;
      R.Inflate(FBorderSize);
      DrawSkinElementContent(AElement, DC, R, dxDefaultScaleFactor);
    finally
      RestoreDC(DC, ASaveIndex);
    end;
  end;
end;

function TPopupSkinPainter.GetDefaultEnabledTextColor(ASelected, AFlat: Boolean): TColor;
var
  AElement: TdxSkinElement;
begin
  AElement := PopupMenu;
  if AElement <> nil then
  begin
    Result := clDefault;
    if ASelected then
    begin
      if Result = clDefault then
        Result := GetSkinElementTextColor(AElement, cxbsHot);
    end;
    if Result = clDefault then
      Result := AElement.TextColor;
  end
  else
  begin
    if ASelected and not AFlat then
      Result := GetSysColor(COLOR_HIGHLIGHTTEXT)
    else
      Result := GetSysColor(COLOR_BTNTEXT);
  end;
end;

procedure TPopupSkinPainter.DrawGutter(DC: HDC; const R: TRect);
begin
  DrawSkinElement(Gutter, DC, R, dxSystemScaleFactor);
end;

procedure TPopupSkinPainter.DrawSeparator(DC: HDC; const R: TRect);
var
  AContent: TRect;
  ASeparatorSize: Integer;
  AElement: TdxSkinElement;
begin
  DrawBackground(DC, R);
  AContent := R;
  AElement := PopupMenuSeparator;
  ASeparatorSize := GetSkinElementSize(AElement, dxDefaultScaleFactor).cy;
  if ASeparatorSize > R.Height then
  begin
    AElement := ThinSeparator;
    ASeparatorSize := GetSkinElementSize(AElement, dxDefaultScaleFactor).cy;
  end;
  if ASeparatorSize > 0 then
  begin
    ASeparatorSize := Min(ASeparatorSize, R.Height);
    AContent.Bottom := R.Top + ASeparatorSize;
    AContent.Offset(0, (R.Height - AContent.Height) div 2);
    DrawSkinElement(AElement, DC, AContent, dxSystemScaleFactor);
  end;
end;

function TPopupSkinPainter.GetSkinElementSize(ASkinElement: TdxSkinElement; AScaleFactor: TdxScaleFactor): TSize;
begin
  Result := cxNullSize;
  if ASkinElement <> nil then
  begin
    if ASkinElement.MinSize.IsEmpty then
      Result := ASkinElement.Size
    else
      Result := ASkinElement.MinSize.Size;

    Result := AScaleFactor.Apply(Result);
  end;
end;

function TPopupSkinPainter.GetSkinElementTextColor(ASkinElement: TdxSkinElement; AState: TcxButtonState): TColor;
begin
  Result := clDefault;
  if ASkinElement <> nil then
  begin
    Result := ASkinElement.GetTextColor(AState);
    if not cxColorIsValid(Result) then
      Result := clDefault;
  end
end;

procedure TPopupSkinPainter.SetBrushColor(AColor: TColor);
begin
  if AColor = clNone then
  begin
    if FBkgBrush <> 0 then
    begin
      DeleteObject(FBkgBrush);
      FBkgBrush := 0;
    end;
    Exit;
  end;
  if (FBkgBrush = 0) or (FBrushColor <> AColor) then
  begin
    if FBkgBrush <> 0 then
      DeleteObject(FBkgBrush);
    FBkgBrush := CreateSolidBrush(ColorToRGB(AColor));
    FBrushColor := AColor;
  end;
end;

{ TdxPopupMenuItemInfo }

constructor TdxPopupMenuItemInfo.CreateFromMenuItem(AMenuItem: TMenuItem; AImageList: TCustomImageList);
var
  AParentMenu: TMenu;
  AIsEmpty: Boolean;
begin
  Initialize(GetDevicePPI(AMenuItem));
  FHasSubmenu := AMenuItem.Count > 0;
  FIsSeparator := AMenuItem.Caption = cLineCaption;
  AParentMenu := AMenuItem.GetParentMenu;
  FBiDiMode := AParentMenu.BiDiMode;
  FAlignment := GetAlignment(AMenuItem.GetParentMenu);
  if AImageList <> nil then
    FImageList := AImageList
  else
    FImageList := AMenuItem.GetImageList;
  if TdxPopupMenuController.UseSkins then
    FPaintMode := TPaintMode.Skin
  else if TdxPopupMenuController.MatchWindows11Appearance then
    FPaintMode := TPaintMode.Special
  else
    FPaintMode := TPaintMode.Standard;
  FCaption := AMenuItem.Caption;
  FChecked := AMenuItem.Checked; 
  FRadioItem := AMenuItem.RadioItem;
  FImageIndex := AMenuItem.ImageIndex;
  if (AMenuItem.Count = 0) and (AMenuItem.ShortCut <> 0) then
    FShortCutText := ShortCutToText(AMenuItem.ShortCut);
  if IsImageAssigned(FImageList, AMenuItem.ImageIndex) then
    FImageKind := TDrawImageKind.ImageList
  else
  begin
    FBitmap := AMenuItem.Bitmap;
    AIsEmpty := FBitmap.Empty;
    if Checked and AIsEmpty then
      FImageKind := TDrawImageKind.CheckMark
    else if not AIsEmpty then
      FImageKind := TDrawImageKind.Bitmap
    else
      FImageKind := TDrawImageKind.None;
  end;
end;

constructor TdxPopupMenuItemInfo.CreateFromMenuInfo(AMenuWindow: HWND; AMenu: HMENU; ADrawItem: PDrawItemStruct);
var
  I: Integer;
begin
  Initialize(dxGetMonitorDPI(AMenuWindow));
  FInfo := GetMenuItemInfo(AMenu, ADrawItem.itemID, False);
  FIsSeparator := Info.fType and MFT_SEPARATOR <> 0;
  FHasSubmenu :=  Info.hSubMenu <> 0;
  FCaption := string(PChar(Info.dwTypeData));
  I := Pos(#9, FCaption);
  if I > 0 then
  begin
    FShortCutText := Copy(FCaption, I + 1, Length(FCaption));
    FCaption := Copy(FCaption, 1, I - 1);
  end;
  FreeMem(Info.dwTypeData);
  FRadioItem := Info.fType and MFT_RADIOCHECK <> 0;
  FImageKind := TDrawImageKind.HBITMAP;
end;

procedure TdxPopupMenuItemInfo.Initialize(APPI: Integer);
var
  hBmp: HBITMAP;
  Data: tagBITMAP;
begin
  FPPI := APPI;
  FWinXPFlatMenus := AreVisualStylesAvailable and GetThemeSysBool(0, TMT_FLATMENUS);
  hBmp := LoadBitmap(0, PChar(OBM_CHECK));
  GetObjectW(hBmp, sizeof(Data), @Data);
  DeleteObject(hBmp);
  FGlyphSize := MulDiv(Data.bmWidth, FPPI, Screen.PixelsPerInch);
  if IsWinVistaOrLater then
    FTheme := OpenTheme(totMenu, FPPI)
  else
    FTheme := 0;
end;

function TdxPopupMenuItemInfo.GetChecked: Boolean;
begin
  Result := FChecked or (odChecked in FState); 
end;

function TdxPopupMenuItemInfo.GetDefault: Boolean;
begin
  Result := odDefault in FState;
end;

function TdxPopupMenuItemInfo.GetEnabled: Boolean;
begin
  Result := [odGrayed, odDisabled] * FState = [];
end;

function TdxPopupMenuItemInfo.GetHotLight: Boolean;
begin
  Result := odHotLight in FState;
end;

function TdxPopupMenuItemInfo.GetSelected: Boolean;
begin
  Result := odSelected in FState;
end;

class procedure TdxPopupMenuItemInfo.BltColor(ADestDC: HDC; AColorBrush: HBRUSH; ASourceDC: HDC; x, y, cx, cy: Integer; ASrcX, ASrcY: Integer; ABltFlags: UINT);
const
  NOMIRRORBITMAP = $80000000;
  ROP_DSPDxax = $00E20746;
var
  ABrushSave: HBRUSH;
  ATextColorSave: DWORD;
  ABkgColorSave: DWORD;
  ARasterOperation: DWORD;
begin
  ATextColorSave := SetTextColor(ADestDC, $00000000);
  ABkgColorSave := SetBkColor(ADestDC, $00FFFFFF);

  if AColorBrush <> 0 then
    ABrushSave := SelectObject(ADestDC, AColorBrush)
  else
    ABrushSave := 0;

  if ABltFlags and BC_INVERT <> 0 then
    ARasterOperation := $B8074A
  else
    ARasterOperation := ROP_DSPDxax;

  if ABltFlags and BC_NOMIRROR <> 0 then
     ARasterOperation := ARasterOperation or NOMIRRORBITMAP;

  BitBlt(ADestDC, x, y, cx, cy, ASourceDC, ASrcX, ASrcY, ARasterOperation);

  if AColorBrush <> 0 then
    SelectObject(ADestDC, ABrushSave);
  SetTextColor(ADestDC, ATextColorSave);
  SetBkColor(ADestDC, ABkgColorSave);
end;

class procedure TdxPopupMenuItemInfo.InternalDrawPopupSystemIcon(ADestDC: HDC; const ABounds: TRect;
  AGroup, AElement, ASize: Integer; AColor: TColor; AEnabled: Boolean);
var
  R: TRect;
  DC, AMemDC: HDC;
  AOldBitmap, AMemBitmap: HBITMAP;
  ABrush: HBRUSH;
begin
  DC := CreateCompatibleDC(0);
  AMemBitmap := CreateCompatibleBitmap(DC, ASize, ASize);
  try
    AMemDC := CreateCompatibleDC(DC);
    AOldBitmap := SelectObject(AMemDC, AMemBitmap);
    try
      DrawFrameControl(AMemDC, TRect.Create(0, 0, ASize, ASize), AGroup, AElement);
      R.InitSize(
        ABounds.Left + (ABounds.Width - ASize) div 2,
        ABounds.Top + (ABounds.Height - ASize) div 2,
        ASize, ASize);
      if AEnabled then
      begin
        ABrush := CreateSolidBrush(ColorToRGB(AColor));
        BltColor(ADestDC, ABrush, AMemDC, R.Left, R.Top, R.Width, R.Height, 0, 0, BC_INVERT);
        DeleteObject(ABrush);
      end
      else
      begin
        ABrush := CreateSolidBrush(ColorToRGB(clBtnHighlight));
        BltColor(ADestDC, ABrush, AMemDC, R.Left + 1, R.Top + 1, R.Width, R.Height, 0, 0, BC_INVERT);
        DeleteObject(ABrush);
        ABrush := CreateSolidBrush(ColorToRGB(clBtnShadow));
        BltColor(ADestDC, ABrush, AMemDC, R.Left, R.Top, R.Width, R.Height, 0, 0, BC_INVERT);
        DeleteObject(ABrush);
      end;
    finally
      SelectObject(AMemDC, AOldBitmap);
      DeleteDC(AMemDC);
    end;
  finally
    DeleteDC(DC);
    DeleteObject(AMemBitmap);
  end;
end;

procedure TdxPopupMenuItemInfo.DrawPopupSystemIcon(ADestDC: HDC; const ABounds: TRect; AID: Integer; AColor: TColor; AEnabled: Boolean);
const
  Map: array[HBMMENU_POPUP_CLOSE..HBMMENU_POPUP_MINIMIZE, 0..1] of Integer = (
   (DFC_POPUPMENU, DFCS_CAPTIONCLOSE),
   (DFC_POPUPMENU, DFCS_CAPTIONRESTORE),
   (DFC_POPUPMENU, DFCS_CAPTIONMAX),
   (DFC_POPUPMENU, DFCS_CAPTIONMIN));
begin
  if (AID < HBMMENU_POPUP_CLOSE) or (AID > HBMMENU_POPUP_MINIMIZE) then
    Exit;
  InternalDrawPopupSystemIcon(ADestDC, ABounds, Map[AID, 0], Map[AID, 1], FGlyphSize, AColor, AEnabled);
end;

procedure TdxPopupMenuItemInfo.DrawPopupSystemCheck(ADestDC: HDC; const ABounds: TRect; AIsRadioItem: Boolean; AColor: TColor; AEnabled: Boolean);
const
  Map: array[Boolean] of Integer = (DFCS_MENUCHECK, DFCS_MENUBULLET);
begin
  InternalDrawPopupSystemIcon(ADestDC, ABounds, DFC_MENU, Map[AIsRadioItem], FGlyphSize, AColor, AEnabled);
end;

function TdxPopupMenuItemInfo.GetActualRectangle(const ARectangle: TRect): TRect;
begin
  Result := ARectangle;
  if FBiDiMode = bdRightToLeft then
    Result := TdxRightToLeftLayoutConverter.ConvertRect(Result, FBounds);
end;

function TdxPopupMenuItemInfo.GetAlignment(AParentMenu: TMenu): TPopupAlignment;
begin
  if AParentMenu is TMenu then
    Result := paLeft
  else if AParentMenu is TPopupMenu then
    Result := TPopupMenu(AParentMenu).Alignment
  else
    Result := paLeft;
  if FBiDiMode = bdRightToLeft then
    Result := TdxRightToLeftLayoutConverter.ConvertPopupAlignment(Result);
end;

function TdxPopupMenuItemInfo.GetTextFlags(AState: TOwnerDrawState): Longint;
const
  Alignments: array[TPopupAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);
begin
  Result := DT_EXPANDTABS or DT_SINGLELINE or Alignments[FAlignment];
  if FBiDiMode <> bdLeftToRight then
    Result := Result or DT_RTLREADING;
  if IsWin2KOrLater and (odNoAccel in AState) then
    Result := Result or DT_HIDEPREFIX;
end;

procedure TdxPopupMenuItemInfo.AdjustItemTextBounds(DC: HDC; const ACaption: string; var ARect: TRect);
var
  AText: string;
  ABoldFont, ASaveFont: HFONT;
begin
  AText := ACaption;
  if (AText = '') or (AText[1] = cHotkeyPrefix) and (AText[2] = #0) then
    AText := AText + ' ';
  if not FIsSeparator then
  begin
    if Default then
    begin
      ASaveFont := SetFontWeight(DC, True, ABoldFont);
      cxDrawText(DC, AText, ARect, FTextFlags or DT_CALCRECT or DT_NOCLIP);
      SelectObject(DC, ASaveFont);
      DeleteObject(ABoldFont);
    end
    else
      cxDrawText(DC, AText, ARect, FTextFlags or DT_CALCRECT or DT_NOCLIP);
  end;
end;

procedure TdxPopupMenuItemInfo.CalculateThemedLayout(DC: HDC);
var
  ASize, ACheckSize, AImageSize: TSize;
  AMargins, ACheckMargins: TdxMargins;
  ARect, AGlyphRect, AGutterRect, ACheckRect, R: TRect;
begin
  ARect := FBounds;
  GetThemePartSize(FTheme, DC, MENU_POPUPCHECK, CheckMarkStates[Enabled, FRadioItem], nil, TS_TRUE, @ACheckSize);
  GetThemeMargins(FTheme, DC, MENU_POPUPCHECK, CheckMarkStates[Enabled, FRadioItem], TMT_CONTENTMARGINS, nil, ACheckMargins);

  with ACheckMargins do
    ACheckRect.InitSize(ARect.TopLeft, ACheckSize.cx + cxRightWidth + cxRightWidth, ACheckSize.cy + cyBottomHeight + cyBottomHeight);
  AGlyphRect := ACheckRect;
  if Assigned(FImageList) then
  begin
    AImageSize := dxGetImageSize(FImageList, FPPI);
    if AImageSize.cy > ACheckSize.cy then
      Inc(AGlyphRect.Bottom, AImageSize.cy - ACheckSize.cy);
    if AImageSize.cx > ACheckSize.cx then
      Inc(AGlyphRect.Right, AImageSize.cx - ACheckSize.cx);
    ACheckRect.Offset((AGlyphRect.Right - ACheckRect.Right) div 2, (ARect.Bottom - ACheckRect.Bottom) div 2);
  end;
  AGutterRect := AGlyphRect;
  GetThemePartSize(FTheme, DC, MENU_POPUPGUTTER, 0, nil, TS_TRUE, @ASize);
  GetThemeMargins(FTheme, DC, MENU_POPUPGUTTER, 0, TMT_SIZINGMARGINS, nil, AMargins);
  Inc(AGutterRect.Right, ASize.cx + ACheckMargins.cxLeftWidth);
  Inc(AGutterRect.Right, AMargins.cxLeftWidth);
  FGutterBounds := GetActualRectangle(AGutterRect);
  FGutterBounds.Top := FBounds.Top;
  FGutterBounds.Bottom := FBounds.Bottom;

  if not FIsSeparator then
  begin
    if FImageKind <> TDrawImageKind.None then
    begin
      FImageBackgroundBounds := GetActualRectangle(ACheckMargins.GetContentRect(AGlyphRect));
      case FImageKind of
        TDrawImageKind.ImageList:
          FImageBounds := cxRectCenter(FImageBackgroundBounds, AImageSize);
        TDrawImageKind.CheckMark:
          FImageBounds := cxRectCenter(FImageBackgroundBounds, ACheckSize.cx, ACheckSize.cy);
        TDrawImageKind.Bitmap:
          begin
            R := GetActualRectangle(AGlyphRect);
            FImageBounds.InitSize(R.Left + ((R.Width - 16) div 2), R.Top + ((R.Height - 16) div 2), 16, 16);
            if FBitmap.Width < ACheckSize.cx then
              with FImageBounds do
              begin
                Left := Left + ((Right - Left) - FBitmap.Width) div 2;
                Right := Left + FBitmap.Width;
              end;
            if FBitmap.Height < ACheckSize.cy then
              with FImageBounds do
              begin
                Top := Top + ((Bottom - Top) - FBitmap.Height) div 2;
                Bottom := Top + FBitmap.Height;
              end;
          end;
      end;
    end;
  end;
  FSelectionBounds := GetActualRectangle(ARect);

  GetThemeMargins(FTheme, DC, MENU_POPUPITEM, MPI_NORMAL, TMT_SIZINGMARGINS, nil, FTextMargins);
  ARect.Left := AGutterRect.Right;
  Inc(ARect.Left, FTextMargins.cxLeftWidth);
  if not FIsSeparator then
  begin
    GetThemePartSize(FTheme, DC, MENU_POPUPSUBMENU, MSM_NORMAL, nil, TS_TRUE, @FSubMenuSize);
    Dec(ARect.Right, FSubMenuSize.cx);
    FTextAreaBounds := ARect;
  end
  else
  begin
    ARect.Left := AGutterRect.Right + MulDiv(2, FPPI, 96);
    GetThemeMargins(FTheme, DC, MENU_POPUPSEPARATOR, 0, TMT_SIZINGMARGINS, nil, AMargins);
    Dec(ARect.Bottom, AMargins.cyBottomHeight);
    FSeparatorBounds := GetActualRectangle(ARect);
  end;
end;

procedure TdxPopupMenuItemInfo.CalculateClassicLayout(DC: HDC);
var
  R, ARect, AGlyphRect, ACheckBkgRect: TRect;
begin
  ARect := FBounds;
  ACheckBkgRect := ARect;
  if FIsSeparator then
  begin
    ACheckBkgRect.Left := 0;
    ACheckBkgRect.Right := -4;
  end
  else
  begin
    ACheckBkgRect := cxRectCenterVertically(ARect, Min(IfThen(FImageList <> nil, FImageList.Height + 6, 22), ARect.Height));
    ACheckBkgRect.Right := ACheckBkgRect.Left + cxRectHeight(ACheckBkgRect);
    FImageBackgroundBounds := GetActualRectangle(ACheckBkgRect);

    if FImageKind <> TDrawImageKind.None then
    begin
      if (FImageKind in [TDrawImageKind.ImageList, TDrawImageKind.CheckMark]) and (FImageList <> nil) then
        AGlyphRect := cxRectCenter(ACheckBkgRect, FImageList.Width, FImageList.Height)
      else
        AGlyphRect := cxRectCenter(ACheckBkgRect, 16, 16);
      if FImageKind in [TDrawImageKind.ImageList, TDrawImageKind.CheckMark] then
        FImageBounds := GetActualRectangle(AGlyphRect)
      else
      begin
        if FBitmap.Width < AGlyphRect.Width then
          with AGlyphRect do
          begin
            Left := Left + ((Right - Left) - FBitmap.Width) div 2 + 1;
            Right := Left + FBitmap.Width;
          end;
        if FBitmap.Height < AGlyphRect.Height then
          with AGlyphRect do
          begin
            Top := Top + ((Bottom - Top) - FBitmap.Height) div 2 + 1;
            Bottom := Top + FBitmap.Height;
          end;
        FImageBounds := GetActualRectangle(AGlyphRect);
      end;
    end
    else
      if FImageList = nil then
      begin
        ACheckBkgRect.Right := ACheckBkgRect.Left;
        ACheckBkgRect.Bottom := ACheckBkgRect.Top;
      end;
  end;
  ARect.Left := ACheckBkgRect.Right + 3;
  Inc(ARect.Left, 2);
  Dec(ARect.Right, 1);
  R := ARect;
  AdjustItemTextBounds(DC, FCaption, ARect);
  ARect.Offset(0, (R.Height - ARect.Height) div 2);
  FTextBounds := GetActualRectangle(ARect);
  if FShortCutText <> '' then
  begin
    ARect.Left := ARect.Right;
    ARect.Right := R.Right - 10;
    FShortCutBounds := GetActualRectangle(ARect);
  end;
end;

procedure TdxPopupMenuItemInfo.DrawHBITMAP(DC: HDC; const ABounds: TRect; AColor: TColor; AEnabled: Boolean);
var
  hBmp: HBITMAP;
  AImage: TdxGPImage;
begin
  if Checked then
  begin
    hBmp := Info.hbmpChecked;
    if hBmp = 0 then
      DrawPopupSystemCheck(DC, ABounds, FRadioItem, AColor, AEnabled);
  end
  else
  begin
    hBmp := Info.hbmpItem;
    if hBmp = 0 then 
      if Selected then
      begin
        hBmp := Info.hbmpChecked;
        if hBmp = 0 then
          hBmp := Info.hbmpUnchecked;
      end
      else
        hBmp := Info.hbmpUnchecked;
    case hBmp of
      HBMMENU_POPUP_CLOSE,
      HBMMENU_POPUP_MAXIMIZE,
      HBMMENU_POPUP_MINIMIZE,
      HBMMENU_POPUP_RESTORE:
        DrawPopupSystemIcon(DC, ABounds, hBmp, AColor, AEnabled);
    else
      if hBmp <> 0 then
      begin
        AImage := TdxGPImage.CreateFromHBitmap(hBmp);
        try
          AImage.StretchDraw(DC, cxRectCenter(ABounds, AImage.Size));
        finally
          AImage.Free;
        end;
      end;
    end;
  end;
end;

procedure TdxPopupMenuItemInfo.ExcludeSubmenuArrow(DC: HDC);
begin
  if FHasSubmenu then
    cxExcludeClipRect(DC, FSubmenuArrowExcludeBounds);
end;

procedure TdxPopupMenuItemInfo.DrawImageListItem(ACanvas: TcxCanvas; const ABounds: TRect);
var
  AData: TdxSkinInfo;
  APalette: IdxColorPalette;
begin
  APalette := nil;
  if Assigned(RootLookAndFeel.SkinPainter) and RootLookAndFeel.SkinPainter.GetPainterData(AData) then
    APalette := AData.Skin.ActiveColorPalette;
  TdxImageDrawer.DrawImage(ACanvas, ABounds, nil, FImageList, FImageIndex, ifmStretch, EnabledImageDrawModeMap[Enabled], False, APalette);
end;

procedure DrawMenuItemText(ACanvas: TcxCanvas; const ACaption: string; const ARect: TRect; AEnabled, ASelected, ADefault: Boolean; AFlags: Longint);
var
  AText: string;
  R: TRect;
begin
  AText := ACaption;
  if (AFlags and DT_CALCRECT <> 0) and ((AText = '') or
    (AText[1] = cHotkeyPrefix) and (AText[2] = #0)) then AText := AText + ' ';
  if AText = cLineCaption then
  begin
    if AFlags and DT_CALCRECT = 0 then
    begin
      R := ARect;
      Inc(R.Top, 4);
      DrawEdge(ACanvas.Handle, R, EDGE_ETCHED, BF_TOP);
    end;
  end
  else
  begin
    R := ARect;
    if ADefault then
      ACanvas.Font.Style := ACanvas.Font.Style + [fsBold];
    if not AEnabled then
    begin
      if not ASelected then
      begin
        OffsetRect(R, 1, 1);
        cxDrawText(ACanvas.Handle, AText, R, AFlags, -1, clBtnHighlight);
        OffsetRect(R, -1, -1);
      end;
      if ASelected and (ColorToRGB(clHighlight) = ColorToRGB(clBtnShadow)) then
        ACanvas.Font.Color := clBtnHighlight
      else
        ACanvas.Font.Color := clBtnShadow;
    end;
    cxDrawText(ACanvas.Handle, AText, R, AFlags);
  end;
end;

procedure DrawThemedMenuItemText(ACanvas: TcxCanvas; const ACaption: string; ARect: TRect;
  AEnabled, ADefault: Boolean; AFlags: Longint; ATheme: TdxTheme);
const
  MenuStates: array[Boolean] of Cardinal = (MPI_DISABLED, MPI_NORMAL);
var
  AText: string;
  AOptions: TdxDTTOpts;
begin
  FillChar(AOptions, SizeOf(AOptions), 0);
  AOptions.dwSize := SizeOf(AOptions);
  AOptions.dwFlags := DTT_TEXTCOLOR or DTT_COMPOSITED;
  if AFlags and DT_CALCRECT = DT_CALCRECT then
    AOptions.dwFlags := AOptions.dwFlags or DTT_CALCRECT;
  AOptions.crText := ColorToRGB(ACanvas.Font.Color);
  AText := ACaption;
  if (AFlags and DT_CALCRECT <> 0) and ((AText = '') or
    (AText[1] = cHotkeyPrefix) and (AText[2] = #0)) then AText := AText + ' ';
  ACanvas.Brush.Style := bsClear;
  if ADefault then
    ACanvas.Font.Style := ACanvas.Font.Style + [fsBold];
  DrawThemeTextEx(ATheme, ACanvas.Handle, MENU_POPUPITEM, MenuStates[AEnabled], AText, Length(AText), AFlags, ARect, AOptions);
end;

procedure TdxPopupMenuItemInfo.DrawThemedTexts(ACanvas: TcxCanvas);
var
  R: TRect;
  AColorRef: TColorRef;
begin
  R := FTextAreaBounds;
  AdjustItemTextBounds(ACanvas.Handle, FCaption, R);
  R.Offset(0, (FTextAreaBounds.Height - R.Height) div 2);
  GetThemeColor(FTheme, MENU_POPUPITEM, ItemStates[Enabled, Selected], TMT_TEXTCOLOR, AColorRef);
  ACanvas.Font.Color := AColorRef;
  DrawThemedMenuItemText(ACanvas, FCaption, GetActualRectangle(R), Enabled, Default, FTextFlags, FTheme);
  if FShortCutText <> '' then
  begin
    R.Left := R.Right;
    R.Right := FTextAreaBounds.Right - FSubMenuSize.cx - FTextMargins.cxLeftWidth;
    DrawMenuItemText(ACanvas, FShortCutText, GetActualRectangle(R), Enabled, Selected, Default, ActualRightAlignment[FBiDiMode = bdRightToLeft]);
  end;
end;

procedure TdxPopupMenuItemInfo.ThemedDraw(ACanvas: TcxCanvas; const ABounds: TRect; AState: TOwnerDrawState);
const
  CheckMarkBkgs: array[Boolean] of Cardinal = (MCB_DISABLED, MCB_NORMAL);
var
  AHeight: Integer;
  R: TRect;
begin
  DrawThemeBackground(FTheme, ACanvas.Handle, MENU_POPUPBACKGROUND, 0, ABounds, nil);
  DrawThemeBackground(FTheme, ACanvas.Handle, MENU_POPUPGUTTER, 0, FGutterBounds, nil);
  if Selected then
    DrawThemeBackground(FTheme, ACanvas.Handle, MENU_POPUPITEM, SelectionBackgroundStates[Enabled], FSelectionBounds, nil);

  if not FIsSeparator and (FImageKind <> TDrawImageKind.None) then
  begin
    if Checked and (FImageKind <> TDrawImageKind.ImageList) then
      DrawThemeBackground(FTheme, ACanvas.Handle, MENU_POPUPCHECKBACKGROUND, CheckMarkBkgs[Enabled], FImageBackgroundBounds, nil);
    case FImageKind of
      TDrawImageKind.ImageList:
        begin
          if Checked then
          begin
            if FImageList.Height > FImageBackgroundBounds.Height then
            begin
              AHeight := FBounds.Height - 2 * MulDiv(1, FPPI, 96);
              R := cxRectCenter(FImageBounds, AHeight, AHeight);
            end
            else
              R := FImageBackgroundBounds;
            DrawThemeBackground(FTheme, ACanvas.Handle, MENU_POPUPCHECKBACKGROUND, CheckMarkBkgs[Enabled], R, nil);
          end;
          DrawImageListItem(ACanvas, FImageBounds);
        end;
      TDrawImageKind.CheckMark:
        DrawThemeBackground(FTheme, ACanvas.Handle, MENU_POPUPCHECK, CheckMarkStates[Enabled, FRadioItem], FImageBounds, nil);
      TDrawImageKind.Bitmap:
        ACanvas.StretchDraw(FImageBounds, FBitmap);
    end;
  end;
  if FIsSeparator then
    DrawThemeBackground(FTheme, ACanvas.Handle, MENU_POPUPSEPARATOR, 0, FSeparatorBounds, nil)
  else
    DrawThemedTexts(ACanvas);
end;

procedure TdxPopupMenuItemInfo.SkinPainterDraw(ACanvas: TcxCanvas; const ABounds: TRect; AState: TOwnerDrawState);
const
  ArrowMap: array[Boolean] of DWORD = (DFCS_MENUARROW, DFCS_MENUARROWRIGHT);
var
  R, AImageBounds, AImageBackgroundBounds: TRect;
  AHeight: Integer;
  AColor: TColor;
begin
  Painter.Init(RootLookAndFeel.Painter);
  FState := AState;
  Painter.DrawBackground(ACanvas.Handle, ABounds);
  if FGutterBounds.IsEmpty then
  begin
    AImageBounds := FImageBounds;
    AImageBackgroundBounds := FImageBackgroundBounds;
  end
  else
  begin
    Painter.DrawGutter(ACanvas.Handle, FGutterBounds);
    AImageBounds := cxRectCenter(FGutterBounds, FImageBounds.Size);
    AImageBackgroundBounds := cxRectCenter(FGutterBounds, FImageBackgroundBounds.Size);
  end;

  AColor := Painter.GetTextColor(Enabled, Selected, True);
  if Selected then
    Painter.DrawItemBackground(ACanvas.Handle, Enabled, Selected, FSelectionBounds);
  if not FIsSeparator and (FImageKind <> TDrawImageKind.None) then
  begin
    if Checked and (FImageKind = TDrawImageKind.ImageList) then
    begin
      AHeight := Min(FGutterBounds.Width, FGutterBounds.Height);
      Dec(AHeight, 2 * MulDiv(1, FPPI, 96));
      R := cxRectCenter(FGutterBounds, AHeight, AHeight);
      Painter.DrawItemBackground(ACanvas.Handle, Enabled, True, R);
    end;
    case FImageKind of
      TDrawImageKind.ImageList:
        DrawImageListItem(ACanvas, AImageBounds);
      TDrawImageKind.CheckMark:
        DrawPopupSystemCheck(ACanvas.Handle, AImageBounds, FRadioItem, AColor, True);
      TDrawImageKind.Bitmap:
        ACanvas.StretchDraw(AImageBounds, FBitmap);
      TDrawImageKind.HBITMAP:
        DrawHBITMAP(ACanvas.Handle, AImageBackgroundBounds, AColor, True);
    end;
  end;
  if FIsSeparator then
    Painter.DrawSeparator(ACanvas.Handle, FSeparatorBounds)
  else
  begin
    if Default then
      ACanvas.Font.Style := [fsBold];
    if FTheme = 0 then
    begin
      cxDrawText(ACanvas, FCaption, FTextBounds, FTextFlags, AColor);
      if FShortCutText <> '' then
        cxDrawText(ACanvas, FShortCutText, FShortCutBounds, ActualRightAlignment[FBiDiMode = bdRightToLeft], AColor);
    end
    else
    begin
      R := FTextAreaBounds;
      AdjustItemTextBounds(ACanvas.Handle, FCaption, R);
      R.Offset(0, (FTextAreaBounds.Height - R.Height) div 2);
      cxDrawText(ACanvas, FCaption, GetActualRectangle(R), FTextFlags, AColor);
      if FShortCutText <> '' then
      begin
        R.Left := R.Right;
        R.Right := FTextAreaBounds.Right - FSubMenuSize.cx - FTextMargins.cxLeftWidth;
        cxDrawText(ACanvas, FShortCutText, GetActualRectangle(R), ActualRightAlignment[FBiDiMode = bdRightToLeft], AColor);
      end;
    end;
  end;
  if FHasSubmenu then
    InternalDrawPopupSystemIcon(ACanvas.Handle, FSubmenuArrowBounds, DFC_MENU, ArrowMap[FBiDiMode <> bdLeftToRight], FGlyphSize, AColor, True);
end;

procedure TdxPopupMenuItemInfo.CalculateSubmenuArrowBounds(ACanvas: TcxCanvas; const ABounds: TRect; AState: TOwnerDrawState);
var
  ANewFont, ASaveFont: HFONT;
  R: TRect;
begin
  if not FHasSubmenu then
    Exit;
  ASaveFont := SetFontWeight(ACanvas.Handle, False, ANewFont);
  try
    R.InitSize(ABounds.Right - FGlyphSize, ABounds.Top + (ABounds.Height - FGlyphSize) div 2, FGlyphSize, FGlyphSize);
    FSubmenuArrowBounds := GetActualRectangle(R);
    FSubmenuArrowExcludeBounds := GetActualRectangle(TRect.Create(R.Left - 4, ABounds.Top, ABounds.Right, ABounds.Bottom));
    if FBiDiMode <> bdLeftToRight then
    begin
      FSubmenuArrowBounds.Offset(FGlyphSize, 0);
      FSubmenuArrowExcludeBounds.Offset(FGlyphSize, 0);
    end;
  finally
    SelectObject(ACanvas.Handle, ASaveFont);
    DeleteObject(ANewFont);
  end;
end;

procedure TdxPopupMenuItemInfo.ClassicDraw(ACanvas: TcxCanvas; const ABounds: TRect; AState: TOwnerDrawState);
var
  ABkColor, AForeColor, AOldBrushColor: TColor;
  R: TRect;
begin
  ABkColor := clMenu;
  AForeColor := clMenuText;
  if FWinXPFlatMenus or AreVisualStylesAvailable then
  begin
    if Selected or HotLight then
    begin
      if AreVisualStylesAvailable then
        ABkColor := clMenuHighlight
      else
        ABkColor := clHighlight;
      AForeColor := clHighlightText;
    end;
    ACanvas.Brush.Color := ABkColor;
    ACanvas.Font.Color := AForeColor;
  end;
  if not Selected or IsWinXPOrLater then
    ACanvas.FillRect(ABounds);
  if not FIsSeparator then
  begin
    if FImageKind <> TDrawImageKind.None then
    begin
      if Checked and (FImageKind in [TDrawImageKind.ImageList, TDrawImageKind.Bitmap]) then
      begin
        AOldBrushColor := ACanvas.Brush.Color;
        if Checked then
        begin
          ACanvas.Brush.Color := clBtnShadow;
          ACanvas.FrameRect(FImageBackgroundBounds);
          ACanvas.Brush.Color := clBtnFace;
          R := FImageBackgroundBounds;
          R.Deflate(1);
          ACanvas.FillRect(R);
          ACanvas.Brush.Color := AOldBrushColor;
        end;
      end;
      case FImageKind of
        TDrawImageKind.ImageList:
          DrawImageListItem(ACanvas, FImageBounds);
        TDrawImageKind.CheckMark:
          DrawPopupSystemCheck(ACanvas.Handle, FImageBackgroundBounds, FRadioItem, ACanvas.Font.Color, Enabled);
        TDrawImageKind.Bitmap:
          ACanvas.StretchDraw(FImageBounds, FBitmap);
        TDrawImageKind.HBITMAP:
          DrawHBITMAP(ACanvas.Handle, FImageBackgroundBounds, ACanvas.Font.Color, Enabled);
        end;
      end;
  end;
  if Default then
    ACanvas.Font.Style := [fsBold];
  DrawMenuItemText(ACanvas, FCaption, FTextBounds, Enabled, Selected, Default, FTextFlags);
  if FShortCutText <> '' then
    DrawMenuItemText(ACanvas, FShortCutText, FShortCutBounds, Enabled, Selected, Default, ActualRightAlignment[FBiDiMode = bdRightToLeft]);
end;

procedure TdxPopupMenuItemInfo.CalculateLayout(ACanvas: TcxCanvas; const ABounds: TRect; AState: TOwnerDrawState);
begin
  FBounds := ABounds;
  FState := AState;
  FTextFlags := GetTextFlags(AState);
  ACanvas.Font := Screen.MenuFont;
  ACanvas.Font.Size := MulDiv(ACanvas.Font.Size, FPPI, Screen.PixelsPerInch);
  if FTheme <> 0 then
    CalculateThemedLayout(ACanvas.Handle)
  else
    CalculateClassicLayout(ACanvas.Handle);
  CalculateSubmenuArrowBounds(ACanvas, ABounds, AState);
end;

procedure TdxPopupMenuItemInfo.Draw(ACanvas: TcxCanvas; const ABounds: TRect; AState: TOwnerDrawState);
begin
  if TdxPopupMenuController.IsSkinPainting then
    SkinPainterDraw(ACanvas, ABounds, AState)
  else if FTheme <> 0 then
    ThemedDraw(ACanvas, ABounds, AState)
  else
    ClassicDraw(ACanvas, ABounds, AState);
end;

{ TdxPopupMenuController.TContextMenuInfo }

constructor TdxPopupMenuController.TContextMenuInfo.Create(AMenuWindow: HWND; AWndProc: Pointer);
begin
  Window := AMenuWindow;
  WndProc := AWndProc;
  Menu := 0;
  OldBrush := 0;
  PopupMenu := nil;
end;

{ TdxPopupMenuPainter }

class procedure TdxPopupMenuController.AddContextMenu(AMenuWindow: HWND);
var
  AOldMenuWindowProc: Pointer;
begin
  if not (IsSkinPainting or IsMatchWindows11AppearancePainting) then
    Exit;
  if IsWindowUnicode(AMenuWindow) then
    AOldMenuWindowProc := Pointer(SetWindowLongW(AMenuWindow, GWL_WNDPROC, TdxNativeInt(@MenuWindowProc)))
  else
    AOldMenuWindowProc := Pointer(SetWindowLongA(AMenuWindow, GWL_WNDPROC, TdxNativeInt(@MenuWindowProc)));
  FMenuWindows.Add(TContextMenuInfo.Create(AMenuWindow, AOldMenuWindowProc));
  FBypassWndProc := False;
end;

class procedure TdxPopupMenuController.RemoveContextMenu(AMenuWindow: HWND);
var
  AIndex: Integer;
  AItem: TContextMenuInfo;
begin
  AIndex := GetContextMenuInfoIndex(AMenuWindow);
  if AIndex >=0 then
  begin
    AItem := FMenuWindows[AIndex];
    SetMenuBackgroundBrush(AItem.Menu, AItem.OldBrush);
    if IsWindowUnicode(AMenuWindow) then
      SetWindowLongW(AMenuWindow, GWL_WNDPROC, TdxNativeInt(AItem.WndProc))
    else
      SetWindowLongA(AMenuWindow, GWL_WNDPROC, TdxNativeInt(AItem.WndProc));
    FMenuWindows.Delete(AIndex);
    if FMenuWindows.Count = 0 then
      SubclassPopupListWindow(False);
  end;
end;

class function TdxPopupMenuController.CallOriginalWindowProc(hwnd: HWND; uMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT;
var
  AIndex: Integer;
begin
  AIndex := GetContextMenuInfoIndex(hwnd);
  if AIndex >= 0 then
    Result := CallWindowProc(FMenuWindows[AIndex].WndProc, hwnd, uMsg, wParam, lParam)
  else
    Result := 0;
end;

class function TdxPopupMenuController.GetContextMenuInfoIndex(AMenuWindow: HWND): Integer;
var
  I: Integer;
begin
  for I := FMenuWindows.Count - 1 downto 0 do
    if FMenuWindows[I].Window = AMenuWindow then
      Exit(I);
  Result := -1;
end;

class function TdxPopupMenuController.GetPopupMenuKind(AWindowHandle: HWND): TPopupMenuKind;
var
  AOwnerWindow: HWND;
  ABuffer: array[0..MAX_PATH] of Char;
begin
  Result := TPopupMenuKind.External;
  AOwnerWindow := GetPopupMenuOwnerWindow(AWindowHandle);
  if AOwnerWindow <> 0 then
  begin
    if AOwnerWindow = PopupList.Window then
      Exit(TPopupMenuKind.VCL);
    GetClassName(AOwnerWindow, @ABuffer, SizeOf(ABuffer));
    if StrComp(@ABuffer, 'TPUtilWindow') = 0 then
      Exit(TPopupMenuKind.VCL);
    if IsVCLControl(AOwnerWindow) then
      Exit(TPopupMenuKind.Application);
  end;
end;

class procedure TdxPopupMenuController.ReleaseHook;
begin
  if FIsHookInstalled then
  begin
    SubclassPopupListWindow(False);
    dxReleaseHook(WindowsWatcher);
    FreeAndNil(FMenuWindows);
    FIsHookInstalled := False;
  end;
end;

class procedure TdxPopupMenuController.SetHook;
begin
  if not FIsHookInstalled then
  begin
    FMenuWindows := TList<TContextMenuInfo>.Create;
    dxSetHook(htCBT, WindowsWatcher);
    FIsHookInstalled := True;
  end;
end;

class procedure TdxPopupMenuController.SetUseSkins(AValue: Boolean);
begin
  if not (IsWinVistaOrLater and AreVisualStylesAvailable) then
    AValue := False;
  if FUseSkins <> AValue then
  begin
    if AValue then
      SetHook
    else
      if not FMatchWindows11Appearance then
        ReleaseHook;
    FUseSkins := AValue;
  end;
end;

class procedure TdxPopupMenuController.SetMatchWindows11Appearance(AValue: Boolean);
begin
  if not IsWin11OrLater then
    AValue := False;
  if FMatchWindows11Appearance <> AValue then
  begin
    if AValue then
      SetHook
    else
      if not FUseSkins then
        ReleaseHook;
    FMatchWindows11Appearance := AValue;
  end;
end;

class procedure TdxPopupMenuController.SubclassPopupListWindow(AEnable: Boolean);
var
  AWindow: HWND;
begin
  AWindow := PopupList.Window;
  if not IsWindow(AWindow) then
    Exit;
  if FIsPopupListWindowSubclassed <> AEnable then
  begin
    if AEnable then
    begin
      if IsWindowUnicode(AWindow) then
        FOldPopupListWndProc := Pointer(SetWindowLongW(AWindow, GWL_WNDPROC, TdxNativeInt(@PopupListWindowProc)))
      else
        FOldPopupListWndProc := Pointer(SetWindowLongA(AWindow, GWL_WNDPROC, TdxNativeInt(@PopupListWindowProc)));
    end
    else
    begin
      if IsWindowUnicode(AWindow) then
        FOldPopupListWndProc := Pointer(SetWindowLongW(AWindow, GWL_WNDPROC, TdxNativeInt(FOldPopupListWndProc)))
      else
        FOldPopupListWndProc := Pointer(SetWindowLongA(AWindow, GWL_WNDPROC, TdxNativeInt(FOldPopupListWndProc)));
      FOldPopupListWndProc := nil;
    end;
    FIsPopupListWindowSubclassed := AEnable;
  end;
end;


class function TdxPopupMenuController.GetPopupMenuOwnerWindow(APopupMenuWindow: HWND): HWND;
var
  AGUIThreadInfo: TGUIThreadInfo;
  AProcessId: DWORD;
begin
  AProcessId := GetWindowThreadProcessId(APopupMenuWindow, nil);
  FillChar(AGUIThreadInfo, SizeOf(AGUIThreadInfo), 0);
  AGUIThreadInfo.cbSize := SizeOf(AGUIThreadInfo);
  if (AProcessId <> 0) and GetGUIThreadInfo(AProcessId, AGUIThreadInfo) then
    Result := AGUIThreadInfo.hwndMenuOwner
  else
    Result := 0;
end;

class function TdxPopupMenuController.IsMenuWindow(AWindowHandle: HWND): Boolean;
var
  szClassName: array[0..MAX_PATH - 1] of Char;
begin
  GetClassName(AWindowHandle, szClassName, MAX_PATH);
  Result := StrComp(@szClassName, '#32768') = 0;
end;

class procedure TdxPopupMenuController.DrawNonClientArea(Wnd: HWND; DC: HDC; Rgn: HRGN);
var
  AWindowRect, AClientRect: TRect;
  ADC: HDC;
  AClientOrg: TPoint;
begin
  if DC = 0 then
  begin
    ADC := GetDCEx(wnd, Rgn, DCX_USESTYLE or DCX_WINDOW or DCX_LOCKWINDOWUPDATE or DCX_INTERSECTRGN);
    if ADC = 0 then
      ADC := GetWindowDC(wnd);
  end
  else
    ADC := DC;
  AClientOrg.Init(0, 0);
  ClientToScreen(Wnd, AClientOrg);
  GetClientRect(Wnd, AClientRect);
  GetWindowRect(Wnd, AWindowRect);
  AClientRect.Offset(AClientOrg.X - AWindowRect.Left, AClientOrg.Y - AWindowRect.Top);
  OffsetRect(AWindowRect, -AWindowRect.Left, -AWindowRect.Top);
  Painter.Init(RootLookAndFeel.Painter);
  Painter.DrawNCBackground(ADC, AWindowRect, AClientRect);
  if DC = 0 then
    ReleaseDC(wnd, ADC);
end;

class function TdxPopupMenuController.DrawMenuItem(hwnd: HWND; wParam: WPARAM; lParam: LPARAM): LPARAM;
var
  dmi: PdxUAHDrawMenuItem absolute lParam;
  ASaveIndex: Integer;
  AState: TOwnerDrawState;
  AControlCanvas: TControlCanvas;
  ACanvas: TcxCanvas;
begin
  Result := 0;
  AState := TOwnerDrawState(LoWord(dmi.dis.itemState));
  Painter.Init(RootLookAndFeel.Painter);
  AControlCanvas := TControlCanvas.Create;
  try
    ACanvas := TcxCanvas.Create(AControlCanvas);
    try
      ASaveIndex := SaveDC(dmi.um.hdc);
      try
        AControlCanvas.Handle := dmi.um.hdc;
        AControlCanvas.Font := Screen.MenuFont;

        with TdxPopupMenuItemInfo.CreateFromMenuInfo(hwnd, dmi.um.hmenu, @dmi.dis) do
        try
          CalculateLayout(ACanvas, dmi.dis.rcItem, AState);
          Draw(ACanvas,  dmi.dis.rcItem, AState);
        finally
          Free;
        end;
      finally
        AControlCanvas.Handle := 0;
        RestoreDC(dmi.um.hdc, ASaveIndex);
      end;
    finally
      ACanvas.Free;
    end;
  finally
    AControlCanvas.Free;
  end;
end;

class procedure TdxPopupMenuController.Finalize;
begin
  FMatchWindows11Appearance := False;
  FUseSkins := False;
  ReleaseHook;
end;

class function TdxPopupMenuController.IsSkinPainting: Boolean;
begin
  Result := FUseSkins and (RootLookAndFeel.SkinPainter <> nil) and AreVisualStylesAvailable;
end;

class function TdxPopupMenuController.IsMatchWindows11AppearancePainting: Boolean;
begin
  Result := MatchWindows11Appearance and not IsSkinPainting;
end;

class function TdxPopupMenuController.MenuWindowProc(hwnd: HWND; uMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT;
var
  AContextMenuInfo: TContextMenuInfo;
  AIndex: Integer;
  AMenu: PdxUAHMenu absolute lParam;
  AMenuHandle: HMENU;
begin
  if FBypassWndProc or dxIsGdiScaledMode then
  begin
    if (uMsg = WM_UAHNCPAINTMENUPOPUP) and IsWin11OrLater and TdxPopupMenuController.IsMatchWindows11AppearancePainting then
      Exit(0);
    Exit(CallOriginalWindowProc(hwnd, uMsg, wParam, lParam));
  end;

  case uMsg of
    WM_CREATE:
      begin
        if not IsSkinPainting then
        begin
          FBypassWndProc := True;
        end;
        Exit(CallOriginalWindowProc(hwnd, uMsg, wParam, lParam));
      end;
    MN_SIZEWINDOW:
      begin
        case GetPopupMenuKind(hwnd) of
          TPopupMenuKind.External:
            begin
              FBypassWndProc := True;
              Exit(CallOriginalWindowProc(hwnd, uMsg, wParam, lParam));
            end;
        end;
        AIndex := GetContextMenuInfoIndex(hwnd);
        if AIndex >= 0 then
        begin
          AContextMenuInfo := FMenuWindows[AIndex];
          if AContextMenuInfo.Menu = 0 then
          begin
            AMenuHandle := SendMessage(hwnd, MN_GETHMENU, 0, 0);
            AContextMenuInfo.Menu := AMenuHandle;
            AContextMenuInfo.OldBrush := GetMenuBackgroundBrush(AMenuHandle);
            FMenuWindows[AIndex] := AContextMenuInfo;
            SubclassPopupListWindow(True);
            TdxUIThreadSyncService.EnqueueInvokeInUIThread(Application,
              procedure
              begin
                SetMenuBackgroundBrush(AMenuHandle, Painter.BkgBrush);
                dxSetFormCorners(Hwnd, fcRectangular);
              end);
          end;
        end;
      end;
    WM_NCPAINT:
      begin
        Result := CallOriginalWindowProc(hwnd, uMsg, wParam, lParam);
        DrawNonClientArea(hwnd, 0, wParam);
        Exit;
      end;
    WM_PRINT: 
      begin
        Result := CallOriginalWindowProc(hwnd, uMsg, wParam, lParam);
        DrawNonClientArea(hwnd, wParam, 0); 
        Exit;
      end;
    WM_ERASEBKGND: 
     begin
        Result := CallOriginalWindowProc(hwnd, uMsg, wParam, lParam);
        Exit;
      end;
    WM_UAHDRAWMENUITEM: 
        Exit(DrawMenuItem(hwnd, wParam, lParam));
    WM_UAHNCPAINTMENUPOPUP:
      begin
        CallOriginalWindowProc(hwnd, uMsg, wParam, lParam);
        DrawNonClientArea(hwnd, 0, 0);
        Exit(0); 
      end;
  end;
  Result := CallOriginalWindowProc(hwnd, uMsg, wParam, lParam);

end;

class function TdxPopupMenuController.PopupListWindowProc(hwnd: HWND; uMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT;
var
  I: Integer;
  AMenuItem: TMenuItem;
  ACanvas: TcxCanvas;
  AControlCanvas: TControlCanvas;
  ASaveIndex: Integer;
  AItemInfo: TdxPopupMenuItemInfo;
begin
  Result := 0;
  case uMsg of
    WM_DRAWITEM:
      with PDrawItemStruct(lParam)^ do
      begin
        for I := 0 to PopupList.Count - 1 do
        begin
          AMenuItem := TPopupMenu(PopupList[I]).FindItem(itemID, fkCommand);
          if AMenuItem <> nil then
          begin
            AItemInfo := TdxPopupMenuItemInfo.CreateFromMenuItem(AMenuItem, nil);
            try
              AControlCanvas := TControlCanvas.Create;
              try
                ACanvas := TcxCanvas.Create(AControlCanvas);
                try
                  ASaveIndex := SaveDC(hDC);
                  try
                    AControlCanvas.Handle := hDC;
                    AItemInfo.CalculateLayout(ACanvas, rcItem, TOwnerDrawState(LoWord(itemState)));
                    AItemInfo.Draw(ACanvas, rcItem, TOwnerDrawState(LoWord(itemState)));
                  finally
                    AControlCanvas.Handle := 0;
                    RestoreDC(hDC, ASaveIndex);
                  end;
                finally
                  ACanvas.Free;
                end;
              finally
                AControlCanvas.Free;
              end;
              AItemInfo.ExcludeSubmenuArrow(hDC);
            finally
              AItemInfo.Free;
            end;
            Exit;
          end;
        end;
      end;
  end;
  Result := CallWindowProc(FOldPopupListWndProc, hwnd, uMsg, wParam, lParam);
end;

class procedure TdxPopupMenuController.WindowsWatcher(nCode: Integer; wParam: WPARAM; lParam: LPARAM; var AHookResult: LRESULT);
begin
  case nCode of
    HCBT_CREATEWND:
      if IsMenuWindow(wParam) then
        AddContextMenu(wParam);
    HCBT_DESTROYWND:
      if GetContextMenuInfoIndex(wParam) >= 0 then
        RemoveContextMenu(wParam);
  end;
end;

procedure Initialize;
begin
  TdxPopupLookAndFeelListener.Register;
end;

procedure Finalize;
begin
  TdxPopupLookAndFeelListener.Unregister;
  TdxPopupMenuController.Finalize;
  Painter.SetBrushColor(clNone);
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxUnitsLoader.AddUnit(SysInit.HInstance, dxThisUnitName, Initialize, Finalize);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization

  dxUnitsLoader.RemoveUnit(SysInit.HInstance, dxThisUnitName, Finalize);

end.


