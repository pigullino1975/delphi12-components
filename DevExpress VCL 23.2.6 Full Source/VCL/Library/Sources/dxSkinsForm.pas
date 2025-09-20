{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressSkins Library                                     }
{                                                                    }
{           Copyright (c) 2006-2024 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSSKINS AND ALL ACCOMPANYING     }
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

unit dxSkinsForm;

interface

{$I cxVer.inc}

uses
  System.UITypes,
  Types, Windows, Classes, SysUtils, Messages, Forms, Graphics, Controls, MultiMon, ShellApi, StdCtrls, ExtCtrls,
  cxLookAndFeelPainters, cxClasses, cxDWMAPI, dxCore, dxCoreClasses, dxCoreGraphics, dxMessages, cxGraphics, cxControls,
  cxGeometry, cxContainer, dxSkinsLookAndFeelPainter, dxSkinsCore, cxScrollBar, cxLookAndFeels, dxSkinInfo, dxForms,
  dxTypeHelpers, dxShadowWindow, dxFluentDesignFormInterfaces;

const
  dxSkinFormTextOffset = 5;
  dxSkinIconSpacing = 2;
  dxSkinIsDesigning: Boolean = False;

type
  TdxSkinCustomFormController = class;
  TdxSkinForm = class;
  TdxSkinFormController = class;
  TdxSkinFormIconInfo = class;
  TdxSkinFormIconInfoList = class;
  TdxSkinFormNonClientAreaInfo = class;
  TdxSkinFormPainter = class;
  TdxSkinFormScrollBarsController = class;
  TdxSkinFormScrollBarViewInfo = class;

  { TdxSkinWinController }

  TdxSkinWinControllerClass = class of TdxSkinWinController;
  TdxSkinWinController = class(TcxIUnknownObject, IcxMouseTrackingCaller)
  strict private
    FCanUseSkin: Boolean;
    FHandle: HWND;
    FMaster: TdxSkinWinController;
    FScaleFactor: TdxScaleFactor;
    FWinControl: TWinControl;
    FWindowProcObject: TcxWindowProcLinkedObject;

    function GetHasGraphicChildren: Boolean;
    function GetIsHooked: Boolean;
    function GetLookAndFeelPainter: TdxSkinLookAndFeelPainter;
    procedure SetHandle(AHandle: HWND);
  protected
    FLookAndFeelPainter: TdxSkinLookAndFeelPainter;

    function CanFinalizeEngine: Boolean; virtual;
    procedure CalculateScaleFactor; virtual;
    function FindLookAndFeelPainter: TdxSkinLookAndFeelPainter; virtual;
    function FindMasterController: TdxSkinWinController; virtual;
    function GetCanUseSkin: Boolean; virtual;
    function GetUseSkin: Boolean; virtual;
    function IsHookAvailable: Boolean; virtual;
    procedure DefWndProc(var AMessage); virtual;
    procedure MasterDestroyed; virtual;
    procedure MasterDestroying(AMaster: TdxSkinWinController);
    procedure RedrawWindow(AUpdateNow: Boolean);
    procedure WndProc(var AMessage: TMessage); virtual;

    procedure HookWndProc; virtual;
    procedure UnhookWndProc; virtual;
    // IcxMouseTrackingCaller
    procedure MouseLeave; virtual;
  public
    constructor Create(AHandle: HWND); virtual;
    destructor Destroy; override;

    class function IsMDIChildWindow(AHandle: HWND): Boolean; virtual;
    class function IsMDIClientWindow(AHandle: HWND): Boolean; virtual;
    class function IsMessageDlgWindow(AHandle: HWND): Boolean; virtual;
    class function IsSkinActive(AHandle: HWND): Boolean;
    class procedure FinalizeEngine(AHandle: HWND);
    class procedure InitializeEngine(AHandle: HWND);
    class procedure PostCheckRegion(AHandle: HWND; AForceCheck: Boolean = False);

    procedure InvalidateNC; virtual;
    procedure Refresh; virtual;
    procedure RefreshController; virtual;
    procedure RefreshControllerAndUpdate;
    procedure Update; virtual;

    property Handle: HWND read FHandle write SetHandle;
    property HasGraphicChildren: Boolean read GetHasGraphicChildren;
    property IsHooked: Boolean read GetIsHooked;
    property LookAndFeelPainter: TdxSkinLookAndFeelPainter read GetLookAndFeelPainter;
    property Master: TdxSkinWinController read FMaster;
    property ScaleFactor: TdxScaleFactor read FScaleFactor;
    property UseSkin: Boolean read GetUseSkin;
    property WinControl: TWinControl read FWinControl;
  end;

  { TdxSkinWinControllerList }

  TdxSkinWinControllerList = class(TcxObjectList)
  strict private
    function GetItem(Index: TdxListIndex): TdxSkinWinController;
  public
    function GetControllerByControl(AControl: TWinControl): TdxSkinWinController;
    function GetControllerByHandle(AHandle: HWND): TdxSkinWinController;
    procedure Refresh;
    //
    property Items[Index: TdxListIndex]: TdxSkinWinController read GetItem; default;
  end;

  { TdxSkinCustomFormController }

  TdxSkinCustomFormController = class(TdxSkinWinController)
  strict private
    FForceRedraw: Boolean;
    FHasRegion: Boolean;
    FLockRedrawCount: Integer;
    FPainter: TdxSkinFormPainter;
    FPrevVisibleRegion: TcxRegionHandle;
    FScrollBarsController: TdxSkinFormScrollBarsController;
    FViewInfo: TdxSkinFormNonClientAreaInfo;

    function GetIconsInfo: TdxSkinFormIconInfoList;
  protected
    function CreatePainter: TdxSkinFormPainter; virtual;
    function CreateViewInfo: TdxSkinFormNonClientAreaInfo; virtual;
    function GetForm: TCustomForm; virtual;
    function GetFormCorners: TdxFormCorners; virtual;
    function GetUseSkin: Boolean; override;
    //
    procedure CalculateViewInfo; virtual;
    procedure DrawWindowBackground(DC: HDC); virtual;
    procedure DrawWindowBorder(DC: HDC = 0); virtual;
    procedure DrawWindowScrollArea(DC: HDC = 0); virtual;
    procedure InitializeMessageForm; virtual;
    procedure InvalidateBorders;
    procedure MouseLeave; override;
    procedure RefreshNativeFormCorners;
    function RefreshOnMouseEvent(AForceRefresh: Boolean = False): Boolean;
    procedure RefreshOnSystemMenuShown;
    // Region
    procedure CheckWindowRgn(AForceUpdate: Boolean = False); virtual;
    procedure FlushWindowRgn(ARedraw: Boolean = True); virtual;
    procedure SetWindowRegion(ARegion: TcxRegionHandle); virtual;
    // WndProc
    procedure AfterWndProc(var AMessage: TMessage);
    procedure BeforeWndProc(var AMessage: TMessage);
    procedure UnhookWndProc; override;

    //
    function NCMouseDown(const P: TPoint): Boolean; virtual;
    function NCMouseUp(const P: TPoint): Boolean; virtual;
    // Redraw
    procedure LockRedraw;
    procedure PostRedraw;
    procedure UnlockRedraw;
    // Menu
    procedure DoPopupSystemMenu(AForm: TCustomForm; ASysMenu: HMENU);
    procedure ShowSystemMenu(const P: TPoint); overload;
    procedure ShowSystemMenu(const P: TPoint; const AExcludeRect: TRect; ABottomAlign: Boolean = False); overload;
    // Messages
    function HandleInternalMessages(var AMessage: TMessage): Boolean; virtual;
    function HandleWindowMessage(var AMessage: TMessage): Boolean; virtual;
    procedure WMActivate(var Message: TMessage); virtual;
    function WMContextMenu(var Message: TWMContextMenu): Boolean; virtual;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); virtual;
    procedure WMInitMenu(var Message: TWMInitMenu); virtual;
    procedure WMNCActivate(var Message: TWMNCActivate); virtual;
    procedure WMNCButtonDown(var Message: TWMNCHitMessage); virtual;
    procedure WMNCCalcSize(var Message: TWMNCCALCSIZE); virtual;
    function WMNCHitTest(var Message: TWMNCHitTest): Boolean; virtual;
    procedure WMNCMouseMove(var Message: TWMNCHitMessage);
    procedure WMNCPaint(var Message: TWMNCPaint); virtual;
    procedure WMPaint(var Message: TWMPaint); virtual;
    procedure WMPrint(var Message: TWMPrint); virtual;
    procedure WMSetText(var Message: TWMSetText); virtual;
    procedure WMSize(var Message: TWMSize); virtual;
    procedure WMSysCommand(var Message: TWMSysCommand); virtual;
    procedure WMSysMenu(var Message: TMessage); virtual;
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged); virtual;
    procedure WndProc(var AMessage: TMessage); override;
  public
    constructor Create(AHandle: HWND); override;
    destructor Destroy; override;
    procedure Refresh; override;
    procedure RefreshController; override;

    property ForceRedraw: Boolean read FForceRedraw write FForceRedraw;
    property Form: TCustomForm read GetForm;
    property HasRegion: Boolean read FHasRegion write FHasRegion;
    property IconsInfo: TdxSkinFormIconInfoList read GetIconsInfo;
    property Painter: TdxSkinFormPainter read FPainter;
    property ScrollBarsController: TdxSkinFormScrollBarsController read FScrollBarsController;
    property ViewInfo: TdxSkinFormNonClientAreaInfo read FViewInfo;
  end;

  { TdxSkinFormIconInfo }

  TdxSkinFormIconInfo = class
  strict private
    function GetCommand: Integer;
    function GetEnabled: Boolean;
    function GetHitTest: Integer;
    function GetNonClientAreaInfo: TdxSkinFormNonClientAreaInfo;
  protected
    FBounds: TRect;
    FHitBounds: TRect;
    FIconType: TdxSkinFormIcon;
    FOwner: TdxSkinFormIconInfoList;
    FState: TdxSkinElementState;
  public
    constructor Create(AType: TdxSkinFormIcon; AOwner: TdxSkinFormIconInfoList); virtual;
    function CalculateState: TdxSkinElementState;
    //
    property Bounds: TRect read FBounds write FBounds;
    property Command: Integer read GetCommand;
    property Enabled: Boolean read GetEnabled;
    property HitBounds: TRect read FHitBounds write FHitBounds;
    property HitTest: Integer read GetHitTest;
    property IconType: TdxSkinFormIcon read FIconType;
    property NonClientAreaInfo: TdxSkinFormNonClientAreaInfo read GetNonClientAreaInfo;
    property Owner: TdxSkinFormIconInfoList read FOwner;
    property State: TdxSkinElementState read FState write FState;
  end;

  { TdxSkinFormIconInfoList }

  TdxSkinFormIconInfoList = class(TcxObjectList)
  strict private
    FIconHot: TdxSkinFormIconInfo;
    FIconPressed: TdxSkinFormIconInfo;
    FNonClientAreaInfo: TdxSkinFormNonClientAreaInfo;

    function GetItem(Index: TdxListIndex): TdxSkinFormIconInfo;
  public
    constructor Create(ANonClientInfo: TdxSkinFormNonClientAreaInfo); virtual;
    function Add(AIcon: TdxSkinFormIcon): TdxSkinFormIconInfo;
    function CalculateStates(const P: TPoint): Boolean;
    function Find(AIcon: TdxSkinFormIcon; out AInfo: TdxSkinFormIconInfo): Boolean;
    function HitTest(const P: TPoint): TdxSkinFormIconInfo; overload;
    function HitTest(const P: TPoint; out AInfo: TdxSkinFormIconInfo): Boolean; overload;
    procedure MouseDown(const P: TPoint);
    procedure MouseUp(const P: TPoint; out AIcon: TdxSkinFormIconInfo);
    procedure Validate(const AIcons: TdxSkinFormIcons);
    //
    property IconHot: TdxSkinFormIconInfo read FIconHot;
    property IconPressed: TdxSkinFormIconInfo read FIconPressed;
    property Items[Index: TdxListIndex]: TdxSkinFormIconInfo read GetItem; default;
    property NonClientAreaInfo: TdxSkinFormNonClientAreaInfo read FNonClientAreaInfo;
  end;

  { TdxSkinFormScrollBarPartViewInfo }

  TdxSkinFormScrollBarPartViewInfo = class
  protected
    FBounds: TRect;
    FKind: TcxScrollBarPart;
    FOwner: TdxSkinFormScrollBarViewInfo;
    FState: TcxButtonState;
    FVisible: Boolean;
  public
    constructor Create(AOwner: TdxSkinFormScrollBarViewInfo; AKind: TcxScrollBarPart); virtual;
    procedure Calculate(APos1, APos2: Integer; AState: Integer);
    //
    property Bounds: TRect read FBounds;
    property Kind: TcxScrollBarPart read FKind;
    property Owner: TdxSkinFormScrollBarViewInfo read FOwner;
    property State: TcxButtonState read FState;
    property Visible: Boolean read FVisible;
  end;

  { TdxSkinFormScrollBarViewInfo }

  TdxSkinFormScrollBarViewInfo = class
  protected
    FBounds: TRect;
    FController: TdxSkinFormScrollBarsController;
    FInfo: TScrollBarInfo;
    FKind: TScrollBarKind;
    FParts: array[TcxScrollBarPart] of TdxSkinFormScrollBarPartViewInfo;
    FVisible: Boolean;

    function GetPartViewInfo(APart: TcxScrollBarPart): TdxSkinFormScrollBarPartViewInfo;
    function GetScaleFactor: TdxScaleFactor;
  public
    constructor Create(AKind: TScrollBarKind; AController: TdxSkinFormScrollBarsController);
    destructor Destroy; override;
    procedure CalculatePart(APos1, APos2: Integer; APart: TcxScrollBarPart);
    procedure CalculateParts;
    function HitTest(const P: TPoint; out APart: TdxSkinFormScrollBarPartViewInfo): Boolean;
    //
    property Bounds: TRect read FBounds;
    property Controller: TdxSkinFormScrollBarsController read FController;
    property Info: TScrollBarInfo read FInfo;
    property Kind: TScrollBarKind read FKind;
    property PartViewInfo[APart: TcxScrollBarPart]: TdxSkinFormScrollBarPartViewInfo read GetPartViewInfo;
    property ScaleFactor: TdxScaleFactor read GetScaleFactor;
    property Visible: Boolean read FVisible;
  end;

  { TdxSkinFormScrollBarsController }

  TdxSkinFormScrollBarsController = class
  strict private
    FController: TdxSkinCustomFormController;
    FHotPart: TdxSkinFormScrollBarPartViewInfo;
    FIsTracking: Boolean;
    FPressedPart: TdxSkinFormScrollBarPartViewInfo;
    FScrollBarViewInfo: array[TScrollBarKind] of TdxSkinFormScrollBarViewInfo;
    FScrolling: Boolean;
    FScrollTimer: TcxTimer;
    FSizeGripBounds: TRect;
    FTrackingAreaInfo: TScrollInfo;
    FTrackingLastPoint: TPoint;
    FTrackingScale: Single;
    FTrackPosition: Single;

    function CanScrollPage: Boolean;
    function GetHasScrollBars: Boolean;
    function GetScrollBarViewInfo(AKind: TScrollBarKind): TdxSkinFormScrollBarViewInfo;
    function GetSizeGripVisible: Boolean;
    function GetTrackingScrollBarKind: TScrollBarKind;
    function GetViewInfo: TdxSkinFormNonClientAreaInfo;
    procedure SetHotPart(AValue: TdxSkinFormScrollBarPartViewInfo);
    procedure SetPressedPart(AValue: TdxSkinFormScrollBarPartViewInfo);
  protected
    procedure Click; virtual;
    procedure ScrollTimer(Sender: TObject);
    procedure SendScrollMessage(AParam: WPARAM);
    procedure StartScrollTimer;
    procedure StopScrollTimer;
    procedure Tracking(const P: TPoint);
    procedure TrackingBegin(const P: TPoint);
    procedure TrackingEnd(const P: TPoint);
    procedure TrackingSetThumbPosition(APosition: Integer);
    //
    property HotPart: TdxSkinFormScrollBarPartViewInfo read FHotPart write SetHotPart;
    property IsTracking: Boolean read FIsTracking;
    property PressedPart: TdxSkinFormScrollBarPartViewInfo read FPressedPart write SetPressedPart;
    property Scrolling: Boolean read FScrolling;
    property TrackingAreaInfo: TScrollInfo read FTrackingAreaInfo;
    property TrackingScale: Single read FTrackingScale;
    property TrackingScrollBarKind: TScrollBarKind read GetTrackingScrollBarKind;
  public
    constructor Create(AController: TdxSkinCustomFormController); virtual;
    destructor Destroy; override;
    function HitTest(const P: TPoint): TdxSkinFormScrollBarPartViewInfo; overload;
    function HitTest(const P: TPoint; out AScrollBarPart: TdxSkinFormScrollBarPartViewInfo): Boolean; overload;
    procedure CalculateDrawRegion(ARegion: HRGN);
    procedure CalculateScrollArea; virtual;
    procedure MouseDown(const P: TPoint);
    procedure MouseMove(const P: TPoint);
    procedure MouseUp(const P: TPoint);
    //
    property Controller: TdxSkinCustomFormController read FController;
    property HasScrollBars: Boolean read GetHasScrollBars;
    property ScrollBarViewInfo[AKind: TScrollBarKind]: TdxSkinFormScrollBarViewInfo read GetScrollBarViewInfo;
    property SizeGripBounds: TRect read FSizeGripBounds;
    property SizeGripVisible: Boolean read GetSizeGripVisible;
    property ViewInfo: TdxSkinFormNonClientAreaInfo read GetViewInfo;
  end;

  { TdxSkinFormNonClientAreaInfo }

  TdxSkinFormNonClientAreaInfo = class
  strict private const
    HitTestAreaMinSize = 6;
    MenuSeparatorSize = 1;
  private
    FAcrylicForm: IdxAcrylicHostControl;
    FClientOffset: Integer;
    FClientRect: TRect;
    FController: TdxSkinCustomFormController;
    FIconInfoList: TdxSkinFormIconInfoList;
    FIsAcrylicEnabled: Boolean;
    FRightToLeftLayout: Boolean;
    FSizeType: Integer;
    FSuppressed: Boolean;
    FSystemMenu: HMENU;
    FThemeActive: Boolean;
    FThemeActiveAssigned: Boolean;
    FWindowRect: TRect;

    function GetBorderBounds(ASide: TcxBorder): TRect;
    function GetButtonPressed: Boolean;
    function GetCaptionBounds: TRect;
    function GetCaptionContentOffset: TRect;
    function GetCaptionElement: TdxSkinElement;
    function GetCaptionIconSize(AIcon: TdxSkinFormIcon): TSize;
    function GetCaptionTextAreaOffset: TRect;
    function GetCaptionTextColor: TColor;
    function GetClientCursorPos: TPoint;
    function GetClientRectOnClient: TRect;
    function GetContentRect: TRect;
    function GetCornerRadius: Integer;
    function GetHandle: HWND;
    function GetHasBorder: Boolean;
    function GetHasCaption: Boolean;
    function GetHasCaptionTextShadow: Boolean;
    function GetHasClientEdge: Boolean;
    function GetHasMenu: Boolean;
    function GetHasParent: Boolean;
    function GetHasScrollsArea: Boolean;
    function GetHasSizeConstraints: Boolean;
    function GetIsAlphaBlendUsed: Boolean;
    function GetIsChild: Boolean;
    function GetIsDialog: Boolean;
    function GetIsIconic: Boolean;
    function GetIsSizeBox: Boolean;
    function GetIsZoomed: Boolean;
    function GetNeedCheckNonClientSize: Boolean;
    function GetNonClientMetrics: TNonClientMetrics;
    function GetRTLDependentClientCursorPos: TPoint;
    function GetRTLDependentPos(const P: TPoint): TPoint;
    function GetScaleFactor: TdxScaleFactor;
    function GetScreenRect: TRect;
    function GetScrollBarsController: TdxSkinFormScrollBarsController;
    function GetSizeArea(ASide: TcxBorder): TRect;
    function GetSizeCorners(ACorner: TdxCorner): TRect;
    function GetSkinBorderWidth(ASide: TcxBorder): Integer;
    function GetSuppressFactor: Single;
    function GetSystemBorderWidths: TRect;
    function GetSystemSizeFrame: TSize;
    function GetThemeActive: Boolean;
    function GetToolWindow: Boolean;
    function GetWindowState: TWindowState;
    procedure SetActive(AActive: Boolean);
    procedure SetSizeType(AValue: Integer);
    procedure SetUpdateRgn(ARgn: HRGN);
  protected
    FActive: Boolean;
    FAreBordersThin: Boolean;
    FBorderBounds: array[TcxBorder] of TRect;
    FBorderWidths: TRect;
    FCaption: string;
    FCaptionFont: TFont;
    FCaptionTextBounds: TRect;
    FCaptionTextColor: array[Boolean] of TColor;
    FCaptionTextShadowColor: TColor;
    FClientBounds: TRect;
    FClientEdgeSize: TSize;
    FExStyle: Integer;
    FIsMDIChild: Boolean;
    FIsMDIClient: Boolean;
    FIsSysMenuIconAlphaUsed: Boolean;
    FMenuBounds: TRect;
    FMenuSeparatorBounds: TRect;
    FPainter: TcxCustomLookAndFeelPainter;
    FPainterInfo: TdxSkinLookAndFeelPainterInfo;
    FSizeFrame: TSize;
    FStyle: Integer;
    FSysMenuIcon: HICON;
    FUpdateRgn: HRGN;
    FWindowBounds: TRect;

    // Fluent UI
    FFluentDesignForm: IdxFluentDesignForm;
    FIsNavigationControlAssigned: Boolean;
    FIsNavigationControlCollapsed: Boolean;
    FNavigationControlBounds: TRect;
    FNavigationControlDisplayMode: TdxFluentDesignNavigationControlDisplayMode;

    procedure CalculateBordersInfo; virtual;
    procedure CalculateBorderWidths; virtual;
    procedure CalculateCaptionIconsInfo; virtual;
    function CalculateCaptionButtonSize(const ACaptionRect: TRect; AElement: TdxSkinElement): TSize; virtual;
    function CalculateCaptionContentHeight: Integer; virtual;
    function CalculateCaptionHeight: Integer; virtual;
    function CalculateCaptionIconsHeight: Integer; virtual;
    function CalculateCaptionTextHeight: Integer; virtual;
    procedure CalculateFontInfo;
    procedure CalculateFrameSizes; virtual;
    function CalculateMargins: TRect; virtual;
    procedure CalculateMenuBarInfo; virtual;
    function CalculateMenuIconSize(AToolWindow: Boolean): TSize; virtual;
    procedure CalculateNavigationControlBounds; virtual;
    procedure CalculateScrollArea; virtual;
    procedure CalculateWindowInfo; virtual;
    procedure CombineRectWithRegion(ADest: HRGN; const R: TRect);
    function CheckAreBordersThin(const ABorderWidths: TRect): Boolean;
    function EmulatedRoundedCorners: Boolean;
    function GetBorderRect(ASide: TcxBorder; const ABounds, AWidths: TRect): TRect;
    function GetExtendedNavigationControlBounds: TRect;
    function GetIcons: TdxSkinFormIcons; virtual;
    function GetIsMenuCommandEnabled(AMenuCommandId: Integer): Boolean;
    function GetMDIClientDrawRgn: HRGN; virtual;
    function GetShadowOffsets: TRect;
    function HasAcrylicBackground: Boolean;
    function IsNativeBorderWidth(ACheckZoomed: Boolean = True): Boolean;
    function UpdateCaptionIconStates: Boolean;
    procedure UpdateCaption(const ANewText: string);
    procedure UpdateSysMenuIcon;
    // System Menu
    procedure BuildSystemMenu(ASysMenu: THandle);
    procedure DestroyStandardMenu;
    procedure LoadStandardMenu;
    procedure ModifySystemMenu(ASysMenu: THandle);
    procedure ResetSystemMenu;

    property FluentDesignForm: IdxFluentDesignForm read FFluentDesignForm;
    property IsSysMenuIconAlphaUsed: Boolean read FIsSysMenuIconAlphaUsed;
  public
    constructor Create(AController: TdxSkinCustomFormController); virtual;
    destructor Destroy; override;
    procedure Calculate; virtual;
    function ClientToScreen(const P: TPoint): TPoint; overload;
    function ClientToScreen(const R: TRect): TRect; overload;
    function CreateDrawRgn: HRGN; virtual;
    function GetHitTest(AHitPoint: TPoint; AHitTest: Integer = 0): Integer;
    function ScreenToClient(const P: TSmallPoint): TPoint; overload;
    function ScreenToClient(const P: TPoint): TPoint; overload;
    function ScreenToClient(const R: TRect): TRect; overload;
    procedure UpdateFormCaption;

    property Active: Boolean read FActive write SetActive;
    property AreBordersThin: Boolean read FAreBordersThin;
    property BorderBounds[ASide: TcxBorder]: TRect read GetBorderBounds;
    property BorderWidths: TRect read FBorderWidths;
    property ButtonPressed: Boolean read GetButtonPressed;
    property Caption: string read FCaption;
    property CaptionElement: TdxSkinElement read GetCaptionElement;
    property CaptionFont: TFont read FCaptionFont;
    property CaptionTextBounds: TRect read FCaptionTextBounds;
    property CaptionTextColor: TColor read GetCaptionTextColor;
    property CaptionTextShadowColor: TColor read FCaptionTextShadowColor write FCaptionTextShadowColor;
    property ClientBounds: TRect read FClientBounds;
    property ClientCursorPos: TPoint read GetClientCursorPos;
    property ClientEdgeSize: TSize read FClientEdgeSize;
    property CornerRadius: Integer read GetCornerRadius;
    property ClientOffset: Integer read FClientOffset;
    property ClientRect: TRect read FClientRect;
    property ClientRectOnClient: TRect read GetClientRectOnClient;
    property ContentRect: TRect read GetContentRect;
    property Controller: TdxSkinCustomFormController read FController;
    property ExStyle: Integer read FExStyle;
    property Handle: HWND read GetHandle;
    property HasBorder: Boolean read GetHasBorder;
    property HasCaption: Boolean read GetHasCaption;
    property HasCaptionTextShadow: Boolean read GetHasCaptionTextShadow;
    property HasClientEdge: Boolean read GetHasClientEdge;
    property HasMenu: Boolean read GetHasMenu;
    property HasParent: Boolean read GetHasParent;
    property HasScrollsArea: Boolean read GetHasScrollsArea;
    property HasSizeConstraints: Boolean read GetHasSizeConstraints;
    property IconInfoList: TdxSkinFormIconInfoList read FIconInfoList;
    property Icons: TdxSkinFormIcons read GetIcons;
    property IsAlphaBlendUsed: Boolean read GetIsAlphaBlendUsed;
    property IsChild: Boolean read GetIsChild;
    property IsDialog: Boolean read GetIsDialog;
    property IsIconic: Boolean read GetIsIconic;
    property IsMDIChild: Boolean read FIsMDIChild;
    property IsMDIClient: Boolean read FIsMDIClient;
    property IsSizeBox: Boolean read GetIsSizeBox;
    property IsZoomed: Boolean read GetIsZoomed;
    property MenuBounds: TRect read FMenuBounds;
    property MenuSeparatorBounds: TRect read FMenuSeparatorBounds;
    property NeedCheckNonClientSize: Boolean read GetNeedCheckNonClientSize;
    property NonClientMetrics: TNonClientMetrics read GetNonClientMetrics;
    property Painter: TcxCustomLookAndFeelPainter read FPainter;
    property PainterInfo: TdxSkinLookAndFeelPainterInfo read FPainterInfo;
    property RightToLeftLayout: Boolean read FRightToLeftLayout;
    property ScaleFactor: TdxScaleFactor read GetScaleFactor;
    property ScreenRect: TRect read GetScreenRect;
    property ScrollBarsController: TdxSkinFormScrollBarsController read GetScrollBarsController;
    property SizeArea[ASide: TcxBorder]: TRect read GetSizeArea;
    property SizeCorners[ACorner: TdxCorner]: TRect read GetSizeCorners;
    property SizeFrame: TSize read FSizeFrame;
    property SizeType: Integer read FSizeType write SetSizeType;
    property SkinBorderWidth[ASide: TcxBorder]: Integer read GetSkinBorderWidth;
    property Style: Integer read FStyle;
    property Suppressed: Boolean read FSuppressed;
    property SuppressFactor: Single read GetSuppressFactor;
    property SysMenuIcon: HICON read FSysMenuIcon;
    property SystemBorderWidths: TRect read GetSystemBorderWidths;
    property SystemMenu: HMENU read FSystemMenu;
    property SystemSizeFrame: TSize read GetSystemSizeFrame;
    property ThemeActive: Boolean read GetThemeActive;
    property ThemeActiveAssigned: Boolean read FThemeActiveAssigned write FThemeActiveAssigned;
    property ToolWindow: Boolean read GetToolWindow;
    property UpdateRgn: HRGN read FUpdateRgn write SetUpdateRgn;
    property WindowBounds: TRect read FWindowBounds;
    property WindowRect: TRect read FWindowRect;
    property WindowState: TWindowState read GetWindowState;
  end;

  { TdxSkinFormPainter }

  TdxSkinFormPainter = class
  strict private
    FBackgroundCache: TdxSkinElementCache;
    FBordersCache: array[TcxBorder] of TdxSkinElementCache;
    FCanvas: TcxCanvas;
    FCornersPainter: TdxFormCornersPainter;
    FIconsCache: array[TdxSkinFormIcon] of TdxSkinElementCache;
    FNeedRelease: Boolean;
    FRecursionCounter: Integer;
    FViewInfo: TdxSkinFormNonClientAreaInfo;

    function CalculateCornerColor(Active: Boolean; Corner: TdxCorner): TdxAlphaColor;
    function GetActive: Boolean;
    function GetFormContent: TdxSkinElement;
    function GetFormContentTextColor: TColor;
    function GetIconElement(AIcon: TdxSkinFormIcon): TdxSkinElement;
    function GetIsBordersThin: Boolean;
    function GetPainter: TcxCustomLookAndFeelPainter;
    function GetPainterInfo: TdxSkinLookAndFeelPainterInfo;
    function GetScrollBars: TdxSkinFormScrollBarsController;
  protected
    procedure CreateCacheInfos;
    procedure DrawBackground(DC: HDC; const R: TRect); virtual;
    procedure DrawCaptionText(DC: HDC; R: TRect; const AText: string); virtual;
    procedure DrawScrollAreaElements(DC: HDC); virtual;
    procedure DrawScrollBar(DC: HDC; AScrollBar: TdxSkinFormScrollBarViewInfo); virtual;
    procedure DrawSizeGrip(DC: HDC; const R: TRect);
    procedure DrawWindowBorder(DC: HDC; const R: TRect; ASide: TcxBorder; AFillBackground: Boolean); virtual;
    procedure DrawWindowBorderCore(DC: HDC; const R: TRect; ASide: TcxBorder; AActive, AFillBackground: Boolean);
    procedure DrawWindowBorderCorners(DC: HDC; ACorners: TdxCorners); virtual;
    procedure DrawWindowCaption(DC: HDC; const R: TRect); virtual;
    procedure DrawWindowCaptionBackground(DC: HDC; const R: TRect); virtual;
    procedure DrawWindowCaptionText(DC: HDC; R: TRect); virtual;
    procedure DrawWindowIcon(DC: HDC; AIconInfo: TdxSkinFormIconInfo); overload;
    procedure DrawWindowIcon(DC: HDC; const R: TRect; AIcon: TdxSkinFormIcon;
      AElement: TdxSkinElement; AElementState: TdxSkinElementState); overload; virtual;
    procedure FreeCacheInfos;

    procedure InternalDrawBorders;
    procedure InternalDrawCaption(const R: TRect);
    function IsRectVisible(const R: TRect): Boolean;
  public
    constructor Create(AViewInfo: TdxSkinFormNonClientAreaInfo); virtual;
    destructor Destroy; override;
    procedure BeginPaint(ADestDC: HDC = 0);
    procedure EndPaint;
    procedure FlushCache;

    procedure DrawClientOffsetArea; virtual;
    procedure DrawMDIClientEdgeArea; virtual;
    procedure DrawMenuSeparator; virtual;
    procedure DrawWindowBackground; virtual;
    procedure DrawWindowNonClientArea; virtual;
    procedure DrawWindowScrollArea; virtual;

    property Active: Boolean read GetActive;
    property Canvas: TcxCanvas read FCanvas;
    property FormContent: TdxSkinElement read GetFormContent;
    property FormContentTextColor: TColor read GetFormContentTextColor;
    property IconElements[AIcon: TdxSkinFormIcon]: TdxSkinElement read GetIconElement;
    property IsBordersThin: Boolean read GetIsBordersThin;
    property Painter: TcxCustomLookAndFeelPainter read GetPainter;
    property PainterInfo: TdxSkinLookAndFeelPainterInfo read GetPainterInfo;
    property ScrollBars: TdxSkinFormScrollBarsController read GetScrollBars;
    property ViewInfo: TdxSkinFormNonClientAreaInfo read FViewInfo;
  end;

  { TdxSkinFormController }

  TdxSkinFormController = class(TdxSkinCustomFormController)
  strict private
    FShadowWindow: TdxShadowWindow;
  protected
    procedure CalculateViewInfo; override;
    function FindLookAndFeelPainter: TdxSkinLookAndFeelPainter; override;
    function FindMasterController: TdxSkinWinController; override;
    function GetCanUseSkin: Boolean; override;
    function GetFormCorners: TdxFormCorners; override;
    procedure SetWindowRegion(ARegion: TcxRegionHandle); override;
    //
    procedure HookWndProc; override;
    procedure UnhookWndProc; override;
    //
    function CanShowShadow: Boolean; virtual;
    procedure UpdateFormShadow;
    procedure UpdateFormShadowSettings;

    property ShadowWindow: TdxShadowWindow read FShadowWindow;
  public
    procedure Refresh; override;
    procedure RefreshController; override;
  end;

  { TdxSkinFormBasedFormController }

  TdxSkinFormBasedFormController = class(TdxSkinFormController)
  strict private
    FSkinForm: TdxSkinForm;
  protected
    function CanFinalizeEngine: Boolean; override;
    function CanShowShadow: Boolean; override;
    procedure DefWndProc(var AMessage); override;
    function GetForm: TCustomForm; override;
    function GetFormCorners: TdxFormCorners; override;
    function IsHookAvailable: Boolean; override;
    //
    property SkinForm: TdxSkinForm read FSkinForm;
  public
    constructor Create(ASkinForm: TdxSkinForm); reintroduce;
  end;

  { TdxSkinFormMDIClientController }

  TdxSkinFormMDIClientController = class(TdxSkinCustomFormController)
  protected
    function FindMasterController: TdxSkinWinController; override;
    function GetCanUseSkin: Boolean; override;
    function GetUseSkin: Boolean; override;
  end;

  { TdxSkinForm }

  TdxSkinForm = class(TdxForm)
  strict private
    FController: TdxSkinFormController;
    FFormCorners: TdxFormCorners;
    FShowFormShadow: TdxDefaultBoolean;

    procedure SetFormCorners(AValue: TdxFormCorners);
    procedure SetShowFormShadow(AValue: TdxDefaultBoolean);
  protected
    procedure CreateWindowHandle(const Params: TCreateParams); override;
    procedure DefaultWndProc(var Message: TMessage);
    procedure DestroyWindowHandle; override;
    procedure FinalizeController;
    procedure InitializeController;
    procedure InitializeNewForm; override;
    procedure WndProc(var Message: TMessage); override;

    property Controller: TdxSkinFormController read FController;
  public
    property FormCorners: TdxFormCorners read FFormCorners write SetFormCorners default fcDefault;
    property ShowFormShadow: TdxDefaultBoolean read FShowFormShadow write SetShowFormShadow default bDefault;
  end;

  { TdxSkinFormHelper }

  TdxSkinFormHelper = class(TObject)
  public
    class function CanUseSkin(AForm: TCustomForm): Boolean;
    class function GetActiveMDIChild(AHandle: HWND): TCustomForm;
    class function GetClientOffset(AHandle: HWND): Integer;
    class function GetForm(AHandle: HWND): TCustomForm;
    class function GetZoomedMDIChild(AHandle: HWND): TCustomForm;
    class function HasClientEdge(AHandle: HWND): Boolean;
    class function IsAlphaBlendUsed(AHandle: HWND): Boolean;
  end;

  { TdxSkinFrameController }

  TdxSkinFrameController = class(TdxSkinCustomFormController)
  private
    function GetIsTransparent: Boolean;
  protected
    procedure DrawWindowBackground(DC: HDC); override;
    procedure WMWindowPosChanged(var Message: TWMWindowPosMsg); override;
    //
    property IsTransparent: Boolean read GetIsTransparent;
  end;

  { TdxSkinCustomControlViewInfo }

  TdxSkinCustomControlViewInfo = class
  strict private
    FController: TdxSkinWinController;

    function GetClientHeight: Integer;
    function GetClientRect: TRect;
    function GetClientWidth: Integer;
    function GetFont: TFont;
    function GetIsEnabled: Boolean;
    function GetIsFocused: Boolean;
    function GetIsMouseAtControl: Boolean;
    function GetLookAndFeelPainter: TcxCustomLookAndFeelPainter;
    function GetScaleFactor: TdxScaleFactor;
  protected
    function GetFocusRect: TRect; virtual;
  public
    constructor Create(AController: TdxSkinWinController); virtual;
    procedure DrawBackground(ACanvas: TcxCanvas); virtual;
    procedure DrawContent(ACanvas: TcxCanvas); virtual; 
    //
    property ClientHeight: Integer read GetClientHeight;
    property ClientRect: TRect read GetClientRect;
    property ClientWidth: Integer read GetClientWidth;
    property Controller: TdxSkinWinController read FController;
    property FocusRect: TRect read GetFocusRect;
    property Font: TFont read GetFont;
    property IsEnabled: Boolean read GetIsEnabled;
    property IsFocused: Boolean read GetIsFocused;
    property IsMouseAtControl: Boolean read GetIsMouseAtControl;
    property LookAndFeelPainter: TcxCustomLookAndFeelPainter read GetLookAndFeelPainter;
    property ScaleFactor: TdxScaleFactor read GetScaleFactor;
  end;

  { TdxSkinCustomControlController }

  TdxSkinCustomControlController = class(TdxSkinWinController)
  strict private
    FDoubleBuffered: Boolean;
    FViewInfo: TdxSkinCustomControlViewInfo;

    procedure DoDraw(DC: HDC);
  protected
    function CreateViewInfo: TdxSkinCustomControlViewInfo; virtual;
    procedure WndProc(var AMessage: TMessage); override;
    // Messages
    function WMEraseBk(var AMessage: TWMEraseBkgnd): Boolean; virtual;
    function WMPaint(var AMessage: TWMPaint): Boolean; virtual;
  public
    constructor Create(AHandle: HWND); override;
    destructor Destroy; override;
    procedure Draw(DC: HDC = 0); virtual;

    property DoubleBuffered: Boolean read FDoubleBuffered write FDoubleBuffered;
    property ViewInfo: TdxSkinCustomControlViewInfo read FViewInfo;
  end;

  { TdxSkinCustomButtonViewInfo }

  TdxSkinCustomButtonViewInfo = class(TdxSkinCustomControlViewInfo)
  strict private
    FState: TcxButtonState;

    function GetIsRTL: Boolean;
    function GetIsPressed: Boolean;
    function GetWordWrap: Boolean;
    procedure SetState(AState: TcxButtonState);
  protected
    function CalculateButtonState: TcxButtonState; virtual;
    function GetCaption: string; virtual;
    procedure UpdateButtonState;
  public
    procedure AfterConstruction; override;
    //
    property Caption: string read GetCaption;
    property IsRTL: Boolean read GetIsRTL;
    property IsPressed: Boolean read GetIsPressed;
    property State: TcxButtonState read FState write SetState;
    property WordWrap: Boolean read GetWordWrap;
  end;

  { TdxSkinCustomButtonController }

  TdxSkinCustomButtonController = class(TdxSkinCustomControlController)
  private
    function GetViewInfo: TdxSkinCustomButtonViewInfo;
  protected
    procedure MouseLeave; override;
    procedure WndProc(var AMessage: TMessage); override;
  public
    constructor Create(AHandle: HWND); override;
    //
    property ViewInfo: TdxSkinCustomButtonViewInfo read GetViewInfo;
  end;

  { TdxSkinButtonController }

  TdxSkinButtonController = class(TdxSkinCustomButtonController)
  protected
    function CreateViewInfo: TdxSkinCustomControlViewInfo; override;
    procedure WndProc(var AMessage: TMessage); override;
  end;

  { TdxSkinButtonViewInfo }

  TdxSkinButtonViewInfo = class(TdxSkinCustomButtonViewInfo)
  strict private
    FActive: Boolean;

    function GetButton: TButton;
    function GetIsCommandLink: Boolean;
    function GetIsDefault: Boolean;
    function GetIsSplitButton: Boolean;
    procedure SetActive(AActive: Boolean);
  protected
    function CalculateButtonState: TcxButtonState; override;
    function GetCaption: string; override;
    function GetCommandLinkGlyphPos: TPoint;
    function GetCommandLinkGlyphSize: TSize;
    function GetDropDownButtonSize: Integer;
    function GetDropDownLeftPartBounds: TRect;
    function GetDropDownRightPartBounds: TRect;
    function GetFocusRect: TRect; override;
    function GetTextRect: TRect;
  public
    procedure DrawButtonBackground(ACanvas: TcxCanvas); virtual;
    procedure DrawButtonText(ACanvas: TcxCanvas); virtual;
    procedure DrawContent(ACanvas: TcxCanvas); override;

    property Active: Boolean read FActive write SetActive;
    property Button: TButton read GetButton;
    property IsCommandLink: Boolean read GetIsCommandLink;
    property IsDefault: Boolean read GetIsDefault;
    property IsSplitButton: Boolean read GetIsSplitButton;
  end;

  { TdxSkinCustomCheckButtonViewInfo }

  TdxSkinCustomCheckButtonViewInfo = class(TdxSkinCustomButtonViewInfo)
  private
    function GetCheckMarkState: TcxCheckBoxState;
    function GetIsLeftText: Boolean;
  protected
    procedure Calculate(out ATextRect: TRect; out ACheckMarkRect: TRect);
    function GetCheckMarkSize: TSize; virtual; abstract;
    function GetFocusRect: TRect; override;
    procedure DrawCheckMark(ACanvas: TcxCanvas; const R: TRect); virtual; abstract;
    procedure DrawText(ACanvas: TcxCanvas; const R: TRect); virtual;
  public
    procedure DrawContent(ACanvas: TcxCanvas); override;
    //
    property CheckMarkState: TcxCheckBoxState read GetCheckMarkState;
    property IsLeftText: Boolean read GetIsLeftText;
  end;

  { TdxSkinCheckBoxViewInfo }

  TdxSkinCheckBoxViewInfo = class(TdxSkinCustomCheckButtonViewInfo)
  protected
    procedure DrawCheckMark(ACanvas: TcxCanvas; const R: TRect); override;
    function GetCheckMarkSize: TSize; override;
  end;

  { TdxSkinCheckBoxController }

  TdxSkinCheckBoxController = class(TdxSkinCustomButtonController)
  private
    function GetViewInfo: TdxSkinCheckBoxViewInfo;
  protected
    function CreateViewInfo: TdxSkinCustomControlViewInfo; override;
    procedure WndProc(var AMessage: TMessage); override;
    property ViewInfo: TdxSkinCheckBoxViewInfo read GetViewInfo;
  end;

  { TdxSkinRadioButtonController }

  TdxSkinRadioButtonController = class(TdxSkinCustomButtonController)
  protected
    function CreateViewInfo: TdxSkinCustomControlViewInfo; override;
  end;

  { TdxSkinRadioButtonViewInfo }

  TdxSkinRadioButtonViewInfo = class(TdxSkinCustomCheckButtonViewInfo)
  protected
    procedure DrawCheckMark(ACanvas: TcxCanvas; const R: TRect); override;
    function GetCheckMarkSize: TSize; override;
  end;

  { TdxSkinPanelViewInfo }

  TdxSkinPanelViewInfo = class(TdxSkinCustomControlViewInfo)
  public
    procedure DrawBackground(ACanvas: TcxCanvas); override;
    procedure DrawContent(ACanvas: TcxCanvas); override;
  end;

  { TdxSkinPanelController }

  TdxSkinPanelController = class(TdxSkinCustomControlController)
  private
    FPainting: Boolean;
  protected
    function CreateViewInfo: TdxSkinCustomControlViewInfo; override;
    function WMEraseBk(var AMessage: TWMEraseBkgnd): Boolean; override;
    function WMPaint(var AMessage: TWMPaint): Boolean; override;
    function WMPrintClient(var AMessage: TWMPrintClient): Boolean; virtual;
    procedure WndProc(var AMessage: TMessage); override;
  end;

  { TdxSkinController }

  TdxSkinControlEvent = procedure(Sender: TObject; AControl: TWinControl; var UseSkin: Boolean) of object;
  TdxSkinFormEvent = procedure(Sender: TObject; AForm: TCustomForm; var ASkinName: string; var UseSkin: Boolean) of object;
  TdxSkinPopupSysMenuEvent = procedure (Sender: TObject; AForm: TCustomForm; ASysMenu: HMENU) of object;

  TdxSkinGetControllerClassForWindowProc = function (AWnd: HWND): TdxSkinWinControllerClass;

  TdxSkinController = class(TcxLookAndFeelController)
  strict private
    FOnPopupSysMenu: TdxSkinPopupSysMenuEvent;
    FOnSkinControl: TdxSkinControlEvent;
    FOnSkinForm: TdxSkinFormEvent;

    function GetFormCorners: TdxFormCorners;
    function GetShowFormShadow: TdxDefaultBoolean;
    function GetSkinPaletteName: string;
    function GetUseImageSet: TdxSkinImageSet;
    function GetUseSkins: Boolean;
    function GetUseSkinsInPopupMenus: Boolean;
    function IsSkinPaletteNameStored: Boolean;
    procedure SetFormCorners(AValue: TdxFormCorners);
    procedure SetShowFormShadow(AValue: TdxDefaultBoolean);
    procedure SetSkinPaletteName(const Value: string);
    procedure SetUseImageSet(AValue: TdxSkinImageSet);
    procedure SetUseSkins(AValue: Boolean);
    procedure SetUseSkinsInPopupMenus(AValue: Boolean);
  protected
    procedure FullRefresh;
    procedure DoPopupSystemMenu(AForm: TCustomForm; ASysMenu: HMENU); virtual;
    procedure DoSkinControl(AControl: TWinControl; var AUseSkin: Boolean); virtual;
    procedure DoSkinForm(AForm: TCustomForm; var ASkinName: string; var AUseSkin: Boolean); virtual;
    procedure Loaded; override;
    procedure MasterLookAndFeelChanged(Sender: TcxLookAndFeel; AChangedValues: TcxLookAndFeelValues); override;
    procedure MasterLookAndFeelDestroying(Sender: TcxLookAndFeel); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function GetFormSkin(AForm: TCustomForm; var ASkinName: string): Boolean;
    class function GetPainterData(var AData): Boolean;
    class procedure PopulateSkinColorPalettes(AValues: TStrings);
    class procedure Refresh(AControl: TWinControl = nil);
  published
    property Kind;
    property NativeStyle;
    property SkinName;
    property FormCorners: TdxFormCorners read GetFormCorners write SetFormCorners default fcDefault;
    property SkinPaletteName: string read GetSkinPaletteName write SetSkinPaletteName stored IsSkinPaletteNameStored;
    property ShowFormShadow: TdxDefaultBoolean read GetShowFormShadow write SetShowFormShadow default bDefault;
    property UseImageSet: TdxSkinImageSet read GetUseImageSet write SetUseImageSet default imsDefault;
    property UseSkins: Boolean read GetUseSkins write SetUseSkins default True;
    property UseSkinsInPopupMenus: Boolean read GetUseSkinsInPopupMenus write SetUseSkinsInPopupMenus default True;
    //
    property OnPopupSysMenu: TdxSkinPopupSysMenuEvent read FOnPopupSysMenu write FOnPopupSysMenu;
    property OnSkinControl: TdxSkinControlEvent read FOnSkinControl write FOnSkinControl;
    property OnSkinForm: TdxSkinFormEvent read FOnSkinForm write FOnSkinForm;
  end;

  { TdxSkinControllersList }

  TdxSkinControllersList = class(TList)
  strict private
    function GetDefaultSkinName: string;
    function GetDefaultUseSkins: Boolean;
    function GetItem(Index: TdxListIndex): TdxSkinController;
  protected
    procedure Notify(APtr: Pointer; AAction: TListNotification); override;
  public
    function CanSkinControl(AControl: TWinControl): Boolean;
    function CanSkinForm(AForm: TCustomForm): TdxSkinLookAndFeelPainter;
    function GetSkinPainter(const AName: string; out APainter: TdxSkinLookAndFeelPainter): Boolean;
    function FindItem(AForm: TCustomForm): TdxSkinController;
    //
    property Items[Index: TdxListIndex]: TdxSkinController read GetItem; default;
  end;

  { TdxSkinManagerProvider }

  TdxSkinManagerProvider = class(TInterfacedObject, // for internal use
    IdxSkinManager,
    IcxLookAndFeelPainterListener,
    IcxLookAndFeelNotificationListener)
  strict private
    FOnSkinControllersListChanged: TdxMulticastMethod<TdxSkinManagerSkinControllerListChangeEvent>;
    FOnSkinControllersListChangedLocked: Boolean;

    FOnSkinValuesChanged: TdxMulticastMethod<TdxSkinManagerSkinValuesChangeEvent>;
    FOnSkinValuesChangedLocked: Boolean;

    FOnPaintersChanged: TdxMulticastMethod<TdxSkinManagerPaintersChangeEvent>;
    FOnPaintersChangedLocked: Boolean;

    function GetSkinController: TdxSkinController;
    function TryGetSkinController: TdxSkinController;
    procedure InternalSetUserSkin(const ASetter: TProc);
  protected
    property SkinController: TdxSkinController read GetSkinController;


    // IcxLookAndFeelPainterListener
    procedure PainterAdded(APainter: TcxCustomLookAndFeelPainter);
    procedure PainterRemoved(APainter: TcxCustomLookAndFeelPainter);

    // IcxLookAndFeelNotificationListener
    function IcxLookAndFeelNotificationListener.GetObject = GetInstance;
    procedure MasterLookAndFeelChanged(Sender: TcxLookAndFeel; AChangedValues: TcxLookAndFeelValues);
    procedure MasterLookAndFeelDestroying(Sender: TcxLookAndFeel);

    //IdxSkinManager
    function GetInstance: TObject;

    function FindColorByName(const AColorName: string; out AColor: TdxAlphaColor): Boolean;
    function GetActiveColorPalette: TdxSkinColorPalette;
    function GetActiveColorPaletteName(out APaletteName: string): Boolean;
    function GetActivePainter: TcxCustomLookAndFeelPainter;
    function GetActiveSkin: TdxSkin;
    function GetActiveSkinDetails: TdxSkinDetails;
    function GetActiveSkinInfo: TdxSkinInfo;
    function GetActiveSkinName(out ASkinName: string): Boolean;
    function GetDefaultColorPaletteName: string;
    function GetDefaultPaletteGroupName: string;
    function GetDefaultSkinGroupName: string;
    function IsAdvancedActivePainter: Boolean;
    procedure PopulateSkinColorPalettes(AValues: TStringList);

    function GetLocalizedSkinInfo(const ASkinID: string; out ADisplaySkinName, ADisplayGroupName, AGroupName: string): Boolean;
    function GetLocalizedPaletteInfo(const ASkinID, APaletteID: string; out APaletteName, AGroupName: string): Boolean;

    procedure AddListenerOnSkinControllerListChanged(const AMethod: TdxSkinManagerSkinControllerListChangeEvent);
    procedure RemoveListenerOnSkinControllerListChanged(const AMethod: TdxSkinManagerSkinControllerListChangeEvent);
    procedure SkinControllerListNotify(AList: TList; ASkinController: TComponent; AAction: TListNotification);

    procedure AddListenerOnSkinValuesChanged(const AMethod: TdxSkinManagerSkinValuesChangeEvent);
    procedure RemoveListenerOnSkinValuesChanged(const AMethod: TdxSkinManagerSkinValuesChangeEvent);
    procedure SkinValuesChanged(ALookAndFeel: TcxLookAndFeel; AChangedValues: TcxLookAndFeelValues);

    procedure AddListenerOnPaintersChanged(const AMethod: TdxSkinManagerPaintersChangeEvent);
    procedure RemoveListenerOnPaintersChanged(const AMethod: TdxSkinManagerPaintersChangeEvent);
    procedure PaintersChanged(APainter: TcxCustomLookAndFeelPainter; AOperation: TOperation);


    function HasSkinController: Boolean;
    function GetStyle: TcxLookAndFeelStyle;
    function GetSkinName: string;
    function GetPaletteName: string;
    procedure SetPaletteName(const AValue: string);
    procedure SetSkin(AStyle: TcxLookAndFeelStyle; const ASkinName: string);
    procedure SetSkinFromResource(AInstance: THandle; const AResourceName, ASkinName: string);
    procedure SetSkinFromFile(const ASkinName, AFileName: string);
    procedure SetSkinFromStream(const ASkinName: string; AStream: TStream);
    procedure RootLookAndFeelBeginUpdate;
    procedure RootLookAndFeelEndUpdate;

    function UserSkinLoadFromFile(const AFileName, ASkinName: string): Boolean;
    function UserSkinLoadFromStream(AStream: TStream; ASkinName: string): Boolean;
    function UserSkinLoadFromResource(AInstance: THandle; const AResourceName, ASkinName: string): Boolean;
    function GetUserSkinName: string;
    
    class procedure Initialize;
    class procedure Finalize;
  public
    destructor Destroy; override;
  end;

var
  dxSkinControllersList: TdxSkinControllersList;
  dxSkinFormShadowClass: TdxShadowWindowClass = TdxShadowWindow; // for internal use
  dxSkinGetControllerClassForWindowProc: TdxSkinGetControllerClassForWindowProc;

function dxSkinGetControllerClassForWindow(AWnd: HWND): TdxSkinWinControllerClass;

implementation

uses
  FlatSB, Math, dxUxTheme, dxHooks, cxDrawTextUtils, dxDPIAwareUtils, dxSkinsStrs, dxGdiPlusClasses, dxGdiPlusApi,
  dxPopupMenus, dxSkinNames;

const
  dxThisUnitName = 'dxSkinsForm';

const
  SC_TITLEDBLCLICK = 61490;
  WM_NCUAHDRAWCAPTION = $00AE;
  WM_NCUAHDRAWFRAME   = $00AF;
  WM_SYNCPAINT        = $0088;
  WM_SYSMENU          = $313;

  dxScrollInitialInterval = 400;
  dxScrollInterval = 60;

  // HitTests
  CornerHitTests: array[TdxCorner] of DWORD = (HTTOPLEFT, HTTOPRIGHT, HTBOTTOMLEFT, HTBOTTOMRIGHT);
  ResizeHitTests: array[TcxBorder] of DWORD = (HTLEFT, HTTOP, HTRIGHT, HTBOTTOM);

const
  CaptionFlags = DT_VCENTER or DT_SINGLELINE or DT_EDITCONTROL or DT_END_ELLIPSIS or DT_NOPREFIX;
  FrameStates: array[Boolean] of TdxSkinElementState = (esActiveDisabled, esActive);
  RTLDependentCaptionFlags: array [Boolean] of Integer = (CaptionFlags, CaptionFlags or DT_RIGHT or DT_RTLREADING);

type
  TControlAccess = class(TControl);
  TCustomFormAccess = class(TCustomForm);
  TCustomFrameAccess = class(TCustomFrame);
  TCustomLabelAccess = class(TCustomLabel);
  TCustomPanelAccess = class(TCustomPanel);
  TWinControlAccess = class(TWinControl);

type
  TDrawOnAcrylicProc = reference to procedure (ADC: HDC; const R: TRect);

  { TdxSkinWinControllerHelper }

  TdxSkinWinControllerHelper = class
  strict private
    FHandle: HWND;
  protected
    procedure InternalInitializeEngine(AHandle: HWND);
    procedure WndProc(var AMsg: TMessage);
  public
    constructor Create;
    destructor Destroy; override;
    procedure ChildChanged(AHandle: HWND);
    procedure FinalizeEngine(AHandle: HWND);
    procedure InitializeEngine(AHandle: HWND);
    //
    property Handle: HWND read FHandle;
  end;

  { TdxSkinSkinnedControlsControllers }

  TdxSkinSkinnedControlsControllers = class(TdxSkinWinControllerList)
  public
    procedure NotifyMasterDestroying(AMaster: TdxSkinWinController);
    procedure Refresh(AControl: TWinControl); overload;
    procedure Refresh(AHandle: HWND); overload;
    procedure Refresh(AMaster: TdxSkinWinController); overload;
  end;

var
  SkinHelper: TdxSkinWinControllerHelper;
  SkinnedControlsControllers: TdxSkinSkinnedControlsControllers;

function CompareWindowRegion(AWindowHandle: HWND; ANewRegion: HRGN): Boolean;
var
  ARegion: HRGN;
begin
  Result := False;
  ARegion := CreateRectRgnIndirect(cxNullRect);
  if GetWindowRgn(AWindowHandle, ARegion) <> ERROR then
    Result := CombineRgn(ARegion, ARegion, ANewRegion, RGN_XOR) = NULLREGION;
  DeleteObject(ARegion);
end;

procedure ExcludeOpaqueChildren(AControl: TWinControl; DC: HDC);
var
  AChildControl: TControl;
  I: Integer;
  R: TRect;
  ARightToLeftLayout: Boolean;
  AParentRect: TRect;
begin
  if (AControl <> nil) and (AControl.ControlCount > 0) then
  begin
    ARightToLeftLayout := dxWindowHasRightToLeftLayout(AControl.Handle);
    AParentRect := AControl.ClientRect;
    for I := 0 to AControl.ControlCount - 1 do
    begin
      AChildControl := AControl.Controls[I];
      if AChildControl.Visible and (csOpaque in AChildControl.ControlStyle) then
      begin
        if AChildControl is TWinControl then
        begin
          R := cxGetWindowBounds(TWinControl(AChildControl));
          R := dxMapWindowRect(TWinControl(AChildControl).Handle, AControl.Handle, R);
        end
        else
          R := AChildControl.BoundsRect;

        if ARightToLeftLayout then
          R := TdxRightToLeftLayoutConverter.ConvertRect(R, AParentRect);
        ExcludeClipRect(DC, R.Left, R.Top, R.Right, R.Bottom);
      end;
    end;
  end;
end;

procedure DrawAcrylicNCPart(DC: HDC; const R: TRect; AProc: TDrawOnAcrylicProc);
var
  ACachedDC: HDC;
  APaintBuffer: TdxPaintBuffer;
  ABParams: TdxBPPaintParams;
  APrevLayoutMode: Integer;
begin
  ZeroMemory(@ABParams, SizeOf(ABParams));
  ABParams.cbSize := SizeOf(ABParams);
  ABParams.dwFlags := BPPF_NONCLIENT or BPPF_ERASE;
  APrevLayoutMode := SetLayout(DC, LAYOUT_LTR);
  APaintBuffer := BeginBufferedPaint(DC, @R, BPBF_COMPOSITED, @ABParams, ACachedDC);
  if APaintBuffer <> 0 then
  try
    AProc(ACachedDC, R);
  finally
    EndBufferedPaint(APaintBuffer, True);
    SetLayout(DC, APrevLayoutMode);
  end;
end;

function GetWindowCaption(AWnd: HWND): string;
var
  AControl: TControl;
begin
  AControl := FindControl(AWnd);
  if AControl <> nil then 
    Result := TControlAccess(AControl).Caption
  else
    Result := cxGetWindowText(AWnd);
end;

{ TdxSkinFrameController }

procedure TdxSkinFrameController.DrawWindowBackground(DC: HDC);
begin
  if not IsTransparent then
    inherited DrawWindowBackground(DC)
  else
  begin
    Painter.BeginPaint(DC);
    try
      cxDrawTransparentControlBackground(WinControl, Painter.Canvas, ViewInfo.ClientBounds, False);
    finally
      Painter.EndPaint;
    end;
  end;
end;

function TdxSkinFrameController.GetIsTransparent: Boolean;
begin
  Result := Assigned(WinControl) and (csParentBackground in WinControl.ControlStyle);
end;

procedure TdxSkinFrameController.WMWindowPosChanged(var Message: TWMWindowPosMsg);
begin
  inherited WMWindowPosChanged(Message);
  if IsTransparent then
  begin
    if (Message.WindowPos^.flags and SWP_NOSIZE = 0) or (Message.WindowPos^.flags and SWP_NOMOVE = 0) then
      PostRedraw;
  end;
end;

{ TdxSkinFormPainter }

constructor TdxSkinFormPainter.Create(AViewInfo: TdxSkinFormNonClientAreaInfo);
begin
  inherited Create;
  FViewInfo := AViewInfo;
  FCornersPainter := TdxFormCornersPainter.Create(CalculateCornerColor);
  CreateCacheInfos;
  FlushCache;
end;

destructor TdxSkinFormPainter.Destroy;
begin
  FreeCacheInfos;
  FreeAndNil(FCornersPainter);
  inherited Destroy;
end;

procedure TdxSkinFormPainter.CreateCacheInfos;
var
  AIcon: TdxSkinFormIcon;
  ASide: TcxBorder;
begin
  for ASide := Low(TcxBorder) to High(TcxBorder) do
    FBordersCache[ASide] := TdxSkinElementCache.Create;
  for AIcon := Low(TdxSkinFormIcon) to High(TdxSkinFormIcon) do
    FIconsCache[AIcon] := TdxSkinElementCache.Create;
  FBackgroundCache := TdxSkinElementCache.Create;
end;

procedure TdxSkinFormPainter.FreeCacheInfos;
var
  AIcon: TdxSkinFormIcon;
  ASide: TcxBorder;
begin
  for ASide := Low(TcxBorder) to High(TcxBorder) do
    FreeAndNil(FBordersCache[ASide]);
  for AIcon := Low(TdxSkinFormIcon) to High(TdxSkinFormIcon) do
    FreeAndNil(FIconsCache[AIcon]);
  FreeAndNil(FBackgroundCache);
end;

procedure TdxSkinFormPainter.BeginPaint(ADestDC: HDC = 0);
const
  Flags = DCX_CACHE or DCX_CLIPSIBLINGS or DCX_WINDOW or DCX_VALIDATE;
begin
  FNeedRelease := ADestDC = 0;
  if FNeedRelease then
    ADestDC := GetDCEx(ViewInfo.Handle, 0, Flags);
  Inc(FRecursionCounter);
  cxPaintCanvas.BeginPaint(ADestDC);
  FCanvas := cxPaintCanvas;
end;

procedure TdxSkinFormPainter.EndPaint;
var
  DC: HDC;
begin
  Dec(FRecursionCounter);
  if FRecursionCounter = 0 then
    FCanvas := nil;
  DC := cxPaintCanvas.Handle;
  cxPaintCanvas.EndPaint;
  if FNeedRelease then
    ReleaseDC(ViewInfo.Handle, DC);
end;

procedure TdxSkinFormPainter.DrawClientOffsetArea;
begin
  if (ViewInfo.ClientOffset > 0) and not ViewInfo.IsIconic then
  begin
    Canvas.SaveClipRegion;
    try
      Canvas.ExcludeClipRect(cxRectInflate(ViewInfo.ContentRect, -ViewInfo.ClientOffset));
      DrawBackground(Canvas.Handle, ViewInfo.ContentRect);
    finally
      Canvas.RestoreClipRegion;
    end;
  end;
end;

procedure TdxSkinFormPainter.DrawMDIClientEdgeArea;
begin
  if ViewInfo.IsMDIClient and ViewInfo.HasClientEdge then
  begin
    Canvas.SaveClipRegion;
    try
      Canvas.ExcludeClipRect(cxRectInflate(ViewInfo.WindowBounds, -ViewInfo.ClientEdgeSize.cx, -ViewInfo.ClientEdgeSize.cy));
      FormContent.Draw(Canvas.Handle, ViewInfo.WindowBounds);
    finally
      Canvas.RestoreClipRegion;
    end;
  end;
end;

procedure TdxSkinFormPainter.DrawMenuSeparator;
begin
  if ViewInfo.HasMenu and not ViewInfo.IsIconic then
    FillRect(Canvas.Handle, ViewInfo.MenuSeparatorBounds, GetSysColorBrush(COLOR_MENU));
end;

procedure TdxSkinFormPainter.DrawWindowBackground;
var
  R: TRect;
begin
  if PainterInfo <> nil then
  begin
    Canvas.SaveState;
    try
      if ViewInfo.RightToLeftLayout and not FNeedRelease then
        R := cxRectSetNullOrigin(ViewInfo.ClientRect)
      else
      begin
        R := cxRectOffset(ViewInfo.ClientRect, cxPointInvert(ViewInfo.WindowRect.TopLeft));
        MoveWindowOrg(Canvas.Handle, -R.Left, -R.Top);
      end;
      DrawBackground(Canvas.Handle, R);
    finally
      Canvas.RestoreState;
    end;
  end;
end;

procedure TdxSkinFormPainter.DrawWindowNonClientArea;
begin
  DrawMDIClientEdgeArea;
  DrawClientOffsetArea;
  InternalDrawCaption(ViewInfo.BorderBounds[bTop]);
  InternalDrawBorders;
  DrawMenuSeparator;
  DrawWindowScrollArea;
end;

procedure TdxSkinFormPainter.DrawWindowScrollArea;
begin
  if not ViewInfo.IsIconic and ViewInfo.HasScrollsArea then
    DrawScrollAreaElements(Canvas.Handle);
end;

procedure TdxSkinFormPainter.DrawBackground(DC: HDC; const R: TRect);
var
  ASavedIndex: Integer;
  AContentRect: TRect;
begin
  ASavedIndex := SaveDC(DC);
  try
    if ViewInfo.RightToLeftLayout and not FNeedRelease then
      AContentRect := cxRectSetNullOrigin(ViewInfo.ContentRect)
    else
      AContentRect := ViewInfo.ContentRect;

    if cxIntersectClipRect(DC, AContentRect) and cxIntersectClipRect(DC, R) then
    begin
      if ViewInfo.RightToLeftLayout then
        Dec(AContentRect.Left);

      if FormContent.Image.Empty then
        FormContent.Draw(DC, AContentRect, ViewInfo.ScaleFactor)
      else
        FBackgroundCache.DrawEx(DC, FormContent, AContentRect, ViewInfo.ScaleFactor);

      DrawWindowBorderCorners(DC, dxAllCorners);
    end;
  finally
    RestoreDC(DC, ASavedIndex);
  end;
end;

procedure TdxSkinFormPainter.DrawCaptionText(DC: HDC; R: TRect; const AText: string);
begin
  if ViewInfo.HasAcrylicBackground then
    dxDrawTextOnGlass(DC, AText, nil, R, clDefault, RTLDependentCaptionFlags[ViewInfo.RightToLeftLayout], 0, True)
  else
    cxDrawText(DC, AText, R, RTLDependentCaptionFlags[ViewInfo.RightToLeftLayout]);
end;

procedure TdxSkinFormPainter.DrawScrollAreaElements(DC: HDC);
begin
  DrawScrollBar(DC, ScrollBars.ScrollBarViewInfo[sbHorizontal]);
  DrawScrollBar(DC, ScrollBars.ScrollBarViewInfo[sbVertical]);
  if ScrollBars.SizeGripVisible then
    DrawSizeGrip(DC, ScrollBars.SizeGripBounds);
end;

procedure TdxSkinFormPainter.DrawScrollBar(DC: HDC; AScrollBar: TdxSkinFormScrollBarViewInfo);
var
  AMemBitmap: HBITMAP;
  AMemDC: HDC;
  APart: TcxScrollBarPart;
  R: TRect;
begin
  if AScrollBar.Visible then
  begin
    R := AScrollBar.Bounds;
    AMemDC := CreateCompatibleDC(0);
    try
      AMemBitmap := CreateCompatibleBitmap(DC, cxRectWidth(R), cxRectHeight(R));
      AMemBitmap := SelectObject(AMemDC, AMemBitmap);
      SetWindowOrgEx(AMemDC, R.Left, R.Top, nil);
      cxPaintCanvas.BeginPaint(AMemDC);
      try
        DrawBackground(DC, R);
        Painter.DrawScaledScrollBarBackground(cxPaintCanvas, R, AScrollBar.Kind = sbHorizontal, AScrollBar.ScaleFactor);
        for APart := Low(TcxScrollBarPart) to High(TcxScrollBarPart) do
        begin
          if AScrollBar.PartViewInfo[APart].Visible then
            Painter.DrawScaledScrollBarPart(cxPaintCanvas,
              AScrollBar.Kind = sbHorizontal,
              AScrollBar.PartViewInfo[APart].Bounds, APart,
              AScrollBar.PartViewInfo[APart].State,
              AScrollBar.ScaleFactor);
        end;
      finally
        cxPaintCanvas.EndPaint;
      end;
      cxBitBlt(DC, AMemDC, R, R.TopLeft, SRCCOPY);
      AMemBitmap := SelectObject(AMemDC, AMemBitmap);
      DeleteObject(AMemBitmap);
    finally
      DeleteDC(AMemDC)
    end;
  end;
end;

procedure TdxSkinFormPainter.DrawSizeGrip(DC: HDC; const R: TRect);
var
  B: TcxBitmap;
begin
  B := TcxBitmap.CreateSize(R);
  try
    B.cxCanvas.WindowOrg := R.TopLeft;
    DrawBackground(B.cxCanvas.Handle, R);
    Painter.DoDrawSizeGrip(B.cxCanvas, R);
    cxBitBlt(DC, B.Canvas.Handle, R, R.TopLeft, SRCCOPY);
  finally
    B.Free;
  end;
end;

procedure TdxSkinFormPainter.DrawWindowBorder(DC: HDC; const R: TRect; ASide: TcxBorder; AFillBackground: Boolean);
var
  ACachedDC: HDC;
  AMemBmp: HBitmap;
  APrevLayoutMode: Integer;
begin
  if ViewInfo.HasAcrylicBackground then
  begin
    DrawAcrylicNCPart(DC, R,
      procedure (ACachedDC: HDC; const ARect: TRect)
      begin
        DrawWindowBorderCore(ACachedDC, ARect, ASide, Active, AFillBackground);
      end);
  end
  else
  begin
    APrevLayoutMode := SetLayout(DC, LAYOUT_LTR);
    try
      if AFillBackground then
      begin
        ACachedDC := CreateCompatibleDC(DC);
        AMemBmp := CreateCompatibleBitmap(DC, R.Width, R.Height);
        AMemBmp := SelectObject(ACachedDC, AMemBmp);
        SetWindowOrgEx(ACachedDC, R.Left, R.Top, nil);
        DrawWindowBorderCore(ACachedDC, R, ASide, Active, True);
        BitBlt(DC, R.Left, R.Top, R.Width, R.Height, ACachedDC, R.Left, R.Top, SRCCOPY);
        AMemBMP := SelectObject(ACachedDC, AMemBmp);
        DeleteObject(AMemBmp);
        DeleteDC(ACachedDC);
      end
      else
        DrawWindowBorderCore(DC, R, ASide, Active, False);
    finally
      SetLayout(DC, APrevLayoutMode);
    end;
  end;
end;

procedure TdxSkinFormPainter.DrawWindowBorderCorners(DC: HDC; ACorners: TdxCorners);
begin
  if ViewInfo.EmulatedRoundedCorners then
    FCornersPainter.Draw(DC, ViewInfo.WindowBounds, ACorners, ViewInfo.Active, ViewInfo.CornerRadius);
end;

procedure TdxSkinFormPainter.DrawWindowCaption(DC: HDC; const R: TRect);
var
  I: Integer;
begin
  DrawWindowCaptionBackground(DC, R);
  DrawWindowCaptionText(DC, ViewInfo.CaptionTextBounds);
  for I := 0 to ViewInfo.IconInfoList.Count - 1 do
    DrawWindowIcon(DC, ViewInfo.IconInfoList[I]);
end;

procedure TdxSkinFormPainter.DrawWindowCaptionBackground(DC: HDC; const R: TRect);
var
  R1: TRect;
begin
  R1 := R;
  if ViewInfo.IsIconic then
  begin
    DrawWindowBorder(DC, R1, bBottom, ViewInfo.IsAlphaBlendUsed);
    Dec(R1.Bottom);
  end;

  DrawWindowBorderCore(DC, R1, bTop, ViewInfo.Active, True);
  DrawWindowBorderCorners(DC, [coTopLeft, coTopRight]);
end;

procedure TdxSkinFormPainter.DrawWindowCaptionText(DC: HDC; R: TRect);
var
  APrevColor: TColor;
  APrevFont: HFONT;
  APrevTransparent: Integer;
begin
  if ViewInfo.Caption <> '' then
  begin
    APrevFont := SelectObject(DC, ViewInfo.CaptionFont.Handle);
    APrevTransparent := SetBkMode(DC, Transparent);
    if ViewInfo.RightToLeftLayout then
      R := TdxRightToLeftLayoutConverter.ConvertRect(R, ViewInfo.WindowBounds);
    if ViewInfo.HasCaptionTextShadow then
    begin
      APrevColor := SetTextColor(DC, ColorToRGB(ViewInfo.CaptionTextShadowColor));
      DrawCaptionText(DC, R, ViewInfo.Caption);
      SetTextColor(DC, APrevColor);
    end;
    if ViewInfo.RightToLeftLayout then
      OffsetRect(R, 1, -1)
    else
      OffsetRect(R, -1, -1);
    APrevColor := SetTextColor(DC, ColorToRGB(ViewInfo.CaptionTextColor));
    DrawCaptionText(DC, R, ViewInfo.Caption);
    SetBkMode(DC, APrevTransparent);
    SelectObject(DC, APrevFont);
    SetTextColor(DC, APrevColor);
  end;
end;

procedure TdxSkinFormPainter.DrawWindowIcon(DC: HDC; AIconInfo: TdxSkinFormIconInfo);
begin
  DrawWindowIcon(DC, AIconInfo.Bounds, AIconInfo.IconType,
    PainterInfo.FormIcons[not ViewInfo.ToolWindow, AIconInfo.IconType], AIconInfo.State);
end;

procedure TdxSkinFormPainter.DrawWindowIcon(DC: HDC; const R: TRect;
  AIcon: TdxSkinFormIcon; AElement: TdxSkinElement; AElementState: TdxSkinElementState);
var
  AGpBitmap: gpBitmap;
  AGpGraphics: GpGraphics;
begin
  if ((AIcon = sfiMenu) and (ViewInfo.SysMenuIcon = 0)) or ((AIcon <> sfiMenu) and (AElement = nil)) then
    Exit;

  if RectVisible(DC, R) then
    if AElement <> nil then
      FIconsCache[AIcon].DrawEx(DC, AElement, R, ViewInfo.ScaleFactor, AElementState)
    else
      if ViewInfo.HasAcrylicBackground and not ViewInfo.IsSysMenuIconAlphaUsed then
      begin
        GdipCheck(GdipCreateBitmapFromHICON(ViewInfo.SysMenuIcon, AGpBitmap));
        try
          GdipCheck(GdipCreateFromHDC(DC, AGpGraphics));
          try
            GdipCheck(GdipDrawImage(AGpGraphics, AGpBitmap, R.Left, R.Top));
          finally
            GdipCheck(GdipDeleteGraphics(AGpGraphics));
          end;
        finally
          GdipCheck(GdipDisposeImage(AGpBitmap));
        end;
      end
      else
        DrawIconEx(DC, R.Left, R.Top, ViewInfo.SysMenuIcon, R.Right - R.Left, R.Bottom - R.Top, 0, 0, DI_NORMAL);
end;

procedure TdxSkinFormPainter.FlushCache;
var
  AIcon: TdxSkinFormIcon;
  ASide: TcxBorder;
begin
  FCornersPainter.FlushCache;
  for ASide := Low(TcxBorder) to High(TcxBorder) do
    FBordersCache[ASide].Flush;
  for AIcon := Low(TdxSkinFormIcon) to High(TdxSkinFormIcon) do
    FIconsCache[AIcon].Flush;
  FBackgroundCache.Flush;
end;

procedure TdxSkinFormPainter.InternalDrawBorders;
var
  AIsAlphaBlendUsed: Boolean;
  ASide: TcxBorder;
  R: TRect;
begin
  if IsBordersThin then
  begin
    DrawWindowBorder(Canvas.Handle, ViewInfo.BorderBounds[bBottom], bBottom, True);
    for ASide := Low(TcxBorder) to High(TcxBorder) do
      if ASide in [bLeft, bRight] then
      begin
        R := ViewInfo.BorderBounds[ASide];
        if IsRectVisible(R) then
        begin
          R.Top := ViewInfo.BorderBounds[bTop].Bottom;
          R.Bottom := ViewInfo.WindowBounds.Bottom - ViewInfo.SkinBorderWidth[bBottom];
          DrawWindowBorder(Canvas.Handle, R, ASide, True);
        end;
      end;
  end
  else
  begin
    AIsAlphaBlendUsed := ViewInfo.IsAlphaBlendUsed;
    for ASide := Low(TcxBorder) to High(TcxBorder) do
    begin
      R := ViewInfo.BorderBounds[ASide];
      if (ASide <> bTop) and IsRectVisible(R) then
      begin
        if ASide in [bLeft, bRight] then
        begin
          R.Top := ViewInfo.BorderBounds[bTop].Bottom;
          R.Bottom := ViewInfo.BorderBounds[bBottom].Top;
        end;
        DrawWindowBorder(Canvas.Handle, R, ASide, AIsAlphaBlendUsed);
      end;
    end;
  end;
  DrawWindowBorderCorners(Canvas.Handle, [coBottomLeft, coBottomRight]);
end;

procedure TdxSkinFormPainter.InternalDrawCaption(const R: TRect);
var
  ACachedDC: HDC;
  AMemBmp: HBitmap;
  APrevLayoutMode: Integer;
begin
  if ViewInfo.HasAcrylicBackground then
    DrawAcrylicNCPart(Canvas.Handle, R, DrawWindowCaption)
  else
  begin
    APrevLayoutMode := SetLayout(Canvas.Handle, LAYOUT_LTR);
    try
      ACachedDC := CreateCompatibleDC(Canvas.Handle);
      AMemBmp := CreateCompatibleBitmap(Canvas.Handle, R.Right, R.Bottom);
      AMemBmp := SelectObject(ACachedDC, AMemBmp);
      DrawWindowCaption(ACachedDC, R);
      BitBlt(Canvas.Handle, 0, 0, R.Right, R.Bottom, ACachedDC, 0, 0, SRCCOPY);
      AMemBMP := SelectObject(ACachedDC, AMemBmp);
      DeleteObject(AMemBmp);
      DeleteDC(ACachedDC);
    finally
      SetLayout(Canvas.Handle, APrevLayoutMode);
    end;
  end;
end;

function TdxSkinFormPainter.IsRectVisible(const R: TRect): Boolean;
begin
  Result := not cxRectIsEmpty(R) and
    ((FViewInfo.FUpdateRgn = 0) or RectInRegion(FViewInfo.FUpdateRgn, R)) and
    (Canvas <> nil) and Canvas.RectVisible(R);
end;

procedure TdxSkinFormPainter.DrawWindowBorderCore(DC: HDC; const R: TRect; ASide: TcxBorder; AActive, AFillBackground: Boolean);

  procedure DrawBorder(DC: HDC; const R: TRect);
  begin
    FBordersCache[ASide].RightToLeftDependentDraw(DC,
      PainterInfo.FormFrames[not ViewInfo.ToolWindow, ASide], R,
      ViewInfo.ScaleFactor, ViewInfo.RightToLeftLayout, FrameStates[AActive]);
  end;

  function GetBorderRect(const R: TRect; ASide: TcxBorder): TRect;
  var
    AAlignSide: TcxBorder;
  begin
    Result := R;
    if IsBordersThin then
    begin
      AAlignSide := ASide;
      if ViewInfo.RightToLeftLayout then
        AAlignSide := TdxRightToLeftLayoutConverter.ConvertBorder(AAlignSide);
      case AAlignSide of
        bLeft:
          Result.Right := Result.Left + ViewInfo.GetSkinBorderWidth(ASide);
        bRight:
          Result.Left := Result.Right - ViewInfo.GetSkinBorderWidth(ASide);
        bBottom:
          Result.Top := Result.Bottom - ViewInfo.GetSkinBorderWidth(ASide);
      end;
    end;
  end;

var
  ANavigationControlRect: TRect;
  ASaveIndex: Integer;
begin
  if AFillBackground then
  begin
    ANavigationControlRect := ViewInfo.GetExtendedNavigationControlBounds;
    if cxRectIntersect(ANavigationControlRect, ANavigationControlRect, R) then
    begin
      ASaveIndex := SaveDC(DC);
      try
        cxExcludeClipRect(DC, ViewInfo.ClientBounds);

        dxGPPaintCanvas.BeginPaint(DC, ANavigationControlRect);
        dxGPPaintCanvas.FillRectangle(ANavigationControlRect, ViewInfo.FluentDesignForm.GetNavigationControlBackgroundColor);
        dxGPPaintCanvas.EndPaint;

        cxExcludeClipRect(DC, ANavigationControlRect);

        FormContent.Draw(DC, R, ViewInfo.ScaleFactor, 0, FrameStates[Active]);
        DrawBorder(DC, GetBorderRect(R, ASide));
      finally
        RestoreDC(DC, ASaveIndex);
      end;
    end
    else
    begin
      FormContent.Draw(DC, R, ViewInfo.ScaleFactor, 0, FrameStates[Active]);
      DrawBorder(DC, GetBorderRect(R, ASide));
    end;
  end
  else
    DrawBorder(DC, R);
end;

function TdxSkinFormPainter.CalculateCornerColor(Active: Boolean; Corner: TdxCorner): TdxAlphaColor;
const
  CornerToBorder: array[TdxCorner] of TcxBorder = (bTop, bTop, bBottom, bBottom);
var
  ABorder: TcxBorder;
begin
  ABorder := CornerToBorder[Corner];
  Result := dxSkinCalculateBorderColor(PainterInfo.FormFrames[True, ABorder], ABorder, 0, FrameStates[Active]);
end;

function TdxSkinFormPainter.GetActive: Boolean;
begin
  Result := ViewInfo.Active;
end;

function TdxSkinFormPainter.GetFormContent: TdxSkinElement;
begin
  Result := dxSkinCheckSkinElement(PainterInfo.FormContent);
end;

function TdxSkinFormPainter.GetFormContentTextColor: TColor;
begin
  if Painter <> nil then
    Result := cxGetActualColor(FormContent.TextColor, Painter.DefaultContentTextColor)
  else
    Result := clWindowText;
end;

function TdxSkinFormPainter.GetIconElement(AIcon: TdxSkinFormIcon): TdxSkinElement;
begin
  Result := PainterInfo.FormIcons[ViewInfo.ToolWindow, AIcon];
end;

function TdxSkinFormPainter.GetIsBordersThin: Boolean;
var
  ASide: TcxBorder;
begin
  Result := False;
  for ASide := Low(TcxBorder) to High(TcxBorder) do
    Result := Result or (ViewInfo.SkinBorderWidth[ASide] < 3);
end;

function TdxSkinFormPainter.GetPainter: TcxCustomLookAndFeelPainter;
begin
  Result := ViewInfo.Painter;
end;

function TdxSkinFormPainter.GetPainterInfo: TdxSkinLookAndFeelPainterInfo;
begin
  Result := ViewInfo.PainterInfo;
end;

function TdxSkinFormPainter.GetScrollBars: TdxSkinFormScrollBarsController;
begin
  Result := ViewInfo.ScrollBarsController;
end;

{ TdxSkinWinControllerHelper }

constructor TdxSkinWinControllerHelper.Create;
begin
  FHandle := Classes.AllocateHWnd(WndProc);
end;

destructor TdxSkinWinControllerHelper.Destroy;
begin
  Classes.DeallocateHWnd(FHandle);
  inherited Destroy;
end;

procedure TdxSkinWinControllerHelper.ChildChanged(AHandle: HWND);
begin
  AHandle := GetParent(AHandle);
  if TdxSkinWinController.IsMDIClientWindow(AHandle) then
  begin
    AHandle := GetParent(AHandle);
    if AHandle <> 0 then
      PostMessage(AHandle, DXM_SKINS_CHILDCHANGED, 0, 0);
  end;
end;

procedure TdxSkinWinControllerHelper.FinalizeEngine(AHandle: HWND);
begin
  TdxSkinWinController.FinalizeEngine(AHandle);
  SkinHelper.ChildChanged(AHandle);
end;

procedure TdxSkinWinControllerHelper.InitializeEngine(AHandle: HWND);
begin
  if SendMessage(AHandle, DXM_SKINS_HASOWNSKINENGINE, 0, 0) = 0 then
  begin
    if TdxSkinWinController.IsMDIClientWindow(AHandle) then
      PostMessage(SkinHelper.Handle, DXM_SKINS_POSTCREATE, 0, AHandle)
    else
      InternalInitializeEngine(AHandle);
  end;
end;

procedure TdxSkinWinControllerHelper.InternalInitializeEngine(AHandle: HWND);

  function GetSkinClassForWindow(AWnd: HWND): TdxSkinWinControllerClass;
  begin
    if dxIsCurrentProcessWindow(AWnd) then
      Result := dxSkinGetControllerClassForWindowProc(AWnd)
    else
      Result := nil;
  end;

var
  ASkinClass: TdxSkinWinControllerClass;
begin
  ASkinClass := GetSkinClassForWindow(AHandle);
  if ASkinClass <> nil then
    ASkinClass.InitializeEngine(AHandle);
end;

procedure TdxSkinWinControllerHelper.WndProc(var AMsg: TMessage);
begin
  if AMsg.Msg = DXM_SKINS_POSTCREATE then
    InternalInitializeEngine(AMsg.LParam)
  else
    AMsg.Result := DefWindowProc(Handle, AMsg.Msg, AMsg.WParam, AMsg.LParam);
end;

{ TdxSkinFormNonClientAreaInfo }

constructor TdxSkinFormNonClientAreaInfo.Create(AController: TdxSkinCustomFormController);
begin
  inherited Create;
  FController := AController;
  FCaptionFont := TFont.Create;
  FIconInfoList := TdxSkinFormIconInfoList.Create(Self);
  UpdateFormCaption;
  FActive := True;
  if not Supports(FController.WinControl, IdxFluentDesignForm, FFluentDesignForm) then
    Supports(FController.WinControl, IdxAcrylicHostControl, FAcrylicForm);
end;

destructor TdxSkinFormNonClientAreaInfo.Destroy;
begin
  FFluentDesignForm := nil;
  FAcrylicForm := nil;
  DestroyStandardMenu;
  UpdateRgn := 0;
  DestroyIcon(FSysMenuIcon);
  FSysMenuIcon := 0;
  FreeAndNil(FCaptionFont);
  FreeAndNil(FIconInfoList);
  inherited Destroy;
end;

procedure TdxSkinFormNonClientAreaInfo.Calculate;
begin
  FIsAcrylicEnabled := (FluentDesignForm <> nil) and FluentDesignForm.IsAcrylic or (FAcrylicForm <> nil) and FAcrylicForm.IsAcrylic;
  FIsMDIChild := TdxSkinWinController.IsMDIChildWindow(Handle);
  FIsMDIClient := TdxSkinWinController.IsMDIClientWindow(Handle);
  FPainter := Controller.LookAndFeelPainter;
  FPainterInfo := Controller.LookAndFeelPainter.SkinInfo;
  CalculateFrameSizes;
  CalculateWindowInfo;
  CalculateNavigationControlBounds;
  CalculateFontInfo;
  CalculateBorderWidths;
  CalculateBordersInfo;
  CalculateCaptionIconsInfo;
  CalculateScrollArea;
end;

function TdxSkinFormNonClientAreaInfo.ClientToScreen(const P: TPoint): TPoint;
begin
  Result := cxPointOffset(P, WindowRect.TopLeft);
end;

function TdxSkinFormNonClientAreaInfo.ClientToScreen(const R: TRect): TRect;
begin
  Result := cxRectOffset(R, WindowRect.TopLeft);
end;

procedure TdxSkinFormNonClientAreaInfo.CombineRectWithRegion(ADest: HRGN; const R: TRect);
var
  ARgn: HRGN;
begin
  ARgn := CreateRectRgnIndirect(ClientToScreen(R));
  CombineRgn(ADest, ADest, ARgn, RGN_OR);
  DeleteObject(ARgn);
end;

function TdxSkinFormNonClientAreaInfo.CreateDrawRgn: HRGN;
var
  ARgn: HRGN;
  ASide: TcxBorder;
begin
  Result := CreateRectRgnIndirect(cxNullRect);
  for ASide := Low(TcxBorder) to High(TcxBorder) do
  begin
    if not cxRectIsEmpty(BorderBounds[ASide]) then
      CombineRectWithRegion(Result, BorderBounds[ASide]);
  end;
  if IsMDIClient then
  begin
    ARgn := GetMDIClientDrawRgn;
    CombineRgn(Result, Result, ARgn, RGN_OR);
    DeleteObject(ARgn);
  end;
  if HasMenu then
    CombineRectWithRegion(Result, MenuSeparatorBounds);
  Controller.ScrollBarsController.CalculateDrawRegion(Result);
end;

function TdxSkinFormNonClientAreaInfo.GetHitTest(AHitPoint: TPoint; AHitTest: Integer = 0): Integer;
var
  ASide: TcxBorder;
  AIconInfo: TdxSkinFormIconInfo;
  ACorner: TdxCorner;
begin
  Result := AHitTest;
  AHitPoint := ScreenToClient(AHitPoint);
  if IsSizeBox and not (IsZoomed or IsIconic) then
  begin
    for ACorner := coTopLeft to coBottomRight do
    begin
      if (Result = HTNOWHERE) and PtInRect(SizeCorners[ACorner], AHitPoint) then
        Result := CornerHitTests[ACorner];
    end;
    for ASide := bLeft to bBottom do
    begin
      if (Result = HTNOWHERE) and PtInRect(SizeArea[ASide], AHitPoint) then
        Result := ResizeHitTests[ASide];
    end;
  end;
  if IconInfoList.HitTest(AHitPoint, AIconInfo) then
    Result := AIconInfo.HitTest;
  if (Result = HTNOWHERE) and PtInRect(BorderBounds[bTop], AHitPoint) then
    Result := HTCAPTION;
end;

function TdxSkinFormNonClientAreaInfo.ScreenToClient(const P: TSmallPoint): TPoint;
begin
  Result := ScreenToClient(SmallPointToPoint(P));
end;

function TdxSkinFormNonClientAreaInfo.ScreenToClient(const P: TPoint): TPoint;
begin
  Result := cxPointOffset(P, cxPointInvert(WindowRect.TopLeft));
end;

function TdxSkinFormNonClientAreaInfo.ScreenToClient(const R: TRect): TRect;
begin
  Result := cxRectOffset(R, cxPointInvert(WindowRect.TopLeft));
end;

procedure TdxSkinFormNonClientAreaInfo.CalculateBordersInfo;
var
  ASide: TcxBorder;
begin
  for ASide := Low(TcxBorder) to High(TcxBorder) do
    FBorderBounds[ASide] := GetBorderRect(ASide, WindowBounds, BorderWidths);

  if RightToLeftLayout then
  begin
    for ASide := Low(TcxBorder) to High(TcxBorder) do
      FBorderBounds[ASide] := TdxRightToLeftLayoutConverter.ConvertRect(FBorderBounds[ASide], WindowBounds);
  end;
end;

procedure TdxSkinFormNonClientAreaInfo.CalculateBorderWidths;
var
  AMinBorderWidth: Integer;
begin
  FAreBordersThin := True;
  FBorderWidths := cxNullRect;

  if IsIconic then
  begin
    FBorderWidths.Top := cxRectHeight(WindowBounds);
    Exit;
  end;

  if HasBorder then
  begin
    FBorderWidths.Left := SkinBorderWidth[bLeft];
    FBorderWidths.Right := SkinBorderWidth[bRight];
    FBorderWidths.Bottom := SkinBorderWidth[bBottom];
    FAreBordersThin := CheckAreBordersThin(FBorderWidths);

    if (CornerRadius > 0) and not IsWin11OrLater then
    begin
      AMinBorderWidth := TdxFormHelper.GetMinBorderWidth(CornerRadius);
      FBorderWidths.Bottom := Max(FBorderWidths.Bottom, AMinBorderWidth);
      FBorderWidths.Right := Max(FBorderWidths.Right, AMinBorderWidth);
      FBorderWidths.Left := Max(FBorderWidths.Left, AMinBorderWidth);
    end;

    if IsNativeBorderWidth then
    begin
      FBorderWidths.Left := Min(FBorderWidths.Left, SystemBorderWidths.Left);
      FBorderWidths.Right := Min(FBorderWidths.Right, SystemBorderWidths.Right);
      FBorderWidths.Bottom := Min(FBorderWidths.Bottom, SystemBorderWidths.Bottom);
      FAreBordersThin := CheckAreBordersThin(FBorderWidths);
    end;
  end;

  FBorderWidths.Top := CalculateCaptionHeight;

  if HasMenu then
  begin
    FMenuSeparatorBounds := cxRectContent(WindowBounds, BorderWidths);
    FMenuSeparatorBounds := cxRectSetHeight(FMenuSeparatorBounds, MenuSeparatorSize);
  end;
end;

function TdxSkinFormNonClientAreaInfo.CalculateCaptionButtonSize(const ACaptionRect: TRect; AElement: TdxSkinElement): TSize;
begin
  if IsIconic then
    Result := cxSize(cxRectHeight(ACaptionRect), cxRectHeight(ACaptionRect))
  else
    Result := TdxSkinElementHelper.CalculateCaptionButtonSize(cxRectHeight(ACaptionRect), AElement);
end;

function TdxSkinFormNonClientAreaInfo.CalculateCaptionContentHeight: Integer;
begin
  Result := Max(CalculateCaptionTextHeight, CalculateCaptionIconsHeight);
end;

function TdxSkinFormNonClientAreaInfo.CalculateCaptionHeight: Integer;
begin
  if not HasCaption then
    Result := IfThen(HasBorder, BorderWidths.Bottom)
  else
    if IsNativeBorderWidth(False) then
      Result := SystemBorderWidths.Top - WindowBounds.Top
    else
    begin
      Result := cxMarginsHeight(ScaleFactor.Apply(CaptionElement.ContentOffset.Rect)) + CalculateCaptionContentHeight;
      if IsZoomed then
        Result := Max(Result, SystemBorderWidths.Top - WindowBounds.Top);
    end;
end;

function TdxSkinFormNonClientAreaInfo.CalculateCaptionIconsHeight: Integer;
var
  AElement: TdxSkinElement;
  AIcon: TdxSkinFormIcon;
begin
  Result := 0;
  for AIcon := Low(TdxSkinFormIcon) to High(TdxSkinFormIcon) do
  begin
    if AIcon = sfiMenu then
      Result := Max(Result, CalculateMenuIconSize(ToolWindow).cy)
    else
    begin
      AElement := PainterInfo.FormIcons[not ToolWindow, AIcon];
      if AElement <> nil then
        Result := Max(Result, ScaleFactor.Apply(AElement.MinSize.Height));
    end;
  end;
end;

function TdxSkinFormNonClientAreaInfo.CalculateCaptionTextHeight: Integer;
begin
  Result := cxTextHeight(FCaptionFont);
end;

procedure TdxSkinFormNonClientAreaInfo.CalculateMenuBarInfo;
var
  AMenu: HMENU;
  AMenuBarInfo: TMenuBarInfo;
begin
  FMenuBounds := cxNullRect;
  FMenuSeparatorBounds := cxNullRect;

  if not FIsMDIChild then
  begin
    AMenu := GetMenu(Handle);
    if IsMenu(AMenu) then
    begin
      FillChar(AMenuBarInfo, SizeOf(AMenuBarInfo), 0);
      AMenuBarInfo.cbSize := SizeOf(AMenuBarInfo);
      if GetMenuBarInfo(Handle, Integer(OBJID_MENU), 0, AMenuBarInfo) then
        FMenuBounds := cxRectOffset(AMenuBarInfo.rcBar, FWindowRect.TopLeft, False);
    end;
  end;
end;

function TdxSkinFormNonClientAreaInfo.CalculateMenuIconSize(AToolWindow: Boolean): TSize;
var
  ASysIconSize: Integer;
begin
  if AToolWindow then
    ASysIconSize := dxGetSystemMetrics(SM_CYSMCAPTION, ScaleFactor) - 2 * dxGetSystemMetrics(SM_CYEDGE, ScaleFactor)
  else
    ASysIconSize := dxGetSystemMetrics(SM_CYSMICON, ScaleFactor);

  Result := cxSize(ASysIconSize);
end;

procedure TdxSkinFormNonClientAreaInfo.CalculateCaptionIconsInfo;

  function CalculateCaptionIconBounds(AIcon: TdxSkinFormIcon; var R: TRect): TRect;
  begin
    Result := R;
    if AIcon = sfiMenu then
    begin
      Result.Right := Result.Left + GetCaptionIconSize(AIcon).cx;
      R.Left := Result.Right;
    end
    else
    begin
      Result.Left := Result.Right - GetCaptionIconSize(AIcon).cx;
      R.Right := Result.Left - ScaleFactor.Apply(dxSkinIconSpacing);
    end;
  end;

  function CalculateCaptionTextAreaBounds(const R: TRect): TRect;
  begin
    if HasCaption then
    begin
      Result := R;
      if FIsNavigationControlAssigned and not FIsNavigationControlCollapsed then
        Result.Right := Min(Result.Right, FNavigationControlBounds.Right);
      Result := cxRectContent(Result, GetCaptionTextAreaOffset);
      Result := cxRectCenterVertically(Result, CalculateCaptionTextHeight)
    end
    else
      Result := cxNullRect;
  end;

  procedure AddCaptionIcon(AIcon: TdxSkinFormIcon; var R: TRect; const AParentRect: TRect);
  var
    AInfo: TdxSkinFormIconInfo;
  begin
    if AIcon in Icons then
    begin
      AInfo := IconInfoList.Add(AIcon);
      AInfo.HitBounds := CalculateCaptionIconBounds(AIcon, R);
      AInfo.Bounds := cxRectCenter(AInfo.HitBounds, GetCaptionIconSize(AIcon));
      if IsZoomed then
      begin
        AInfo.FHitBounds.Top := Min(AInfo.HitBounds.Top, SystemSizeFrame.cy);
        if AIcon = sfiMenu then
          AInfo.FHitBounds.Left := Min(AInfo.HitBounds.Left, SystemSizeFrame.cx);
        if AIcon = sfiClose then
          AInfo.FHitBounds.Right := Max(AInfo.FHitBounds.Right, WindowBounds.Right - SystemSizeFrame.cx);
      end;
      if RightToLeftLayout then
      begin
        AInfo.HitBounds := TdxRightToLeftLayoutConverter.ConvertRect(AInfo.HitBounds, AParentRect);
        AInfo.Bounds := TdxRightToLeftLayoutConverter.ConvertRect(AInfo.Bounds, AParentRect);
      end;
    end;
  end;

var
  R, AParentRect: TRect;
begin
  R := GetCaptionBounds;
  if FIsNavigationControlAssigned and FIsNavigationControlCollapsed and (FNavigationControlDisplayMode = ncdmInline) then
    R.Left := FNavigationControlBounds.Right + ScaleFactor.Apply(dxSkinFormTextOffset);
  IconInfoList.Validate(Icons);
  AParentRect := cxRectSetNullOrigin(WindowRect);

  // Don't change order
  AddCaptionIcon(sfiMenu, R, AParentRect);
  AddCaptionIcon(sfiClose, R, AParentRect);
  AddCaptionIcon(sfiMaximize, R, AParentRect);
  AddCaptionIcon(sfiRestore, R, AParentRect);
  AddCaptionIcon(sfiMinimize, R, AParentRect);
  AddCaptionIcon(sfiHelp, R, AParentRect);

  FCaptionTextBounds := CalculateCaptionTextAreaBounds(R);
  UpdateCaptionIconStates;
end;

procedure TdxSkinFormNonClientAreaInfo.CalculateFontInfo;
begin
  if ToolWindow then
    FCaptionFont.Handle := CreateFontIndirect(NonClientMetrics.lfSmCaptionFont)
  else
  begin
    FCaptionFont.Handle := CreateFontIndirect(NonClientMetrics.lfCaptionFont);
    if PainterInfo <> nil then
    begin
      FCaptionFont.Size := FCaptionFont.Size + (PainterInfo.FormCaptionFontDelta - 1);
      if (PainterInfo.FormCaptionFontIsBold <> nil) and PainterInfo.FormCaptionFontIsBold.Value then
        FCaptionFont.Style := FCaptionFont.Style + [fsBold];
    end;
  end;
  FCaptionFont.Height := ScaleFactor.Apply(FCaptionFont.Height, dxSystemScaleFactor);

  if FIsNavigationControlAssigned and not FIsNavigationControlCollapsed then
  begin
    FCaptionTextColor[True] := FluentDesignForm.GetNavigationControlForegroundColor;
    FCaptionTextColor[False] := FCaptionTextColor[True];
    FCaptionTextShadowColor := clNone;
  end
  else
  begin
    FCaptionTextShadowColor := clBtnShadow;
    FCaptionTextColor[True] := GetSysColor(COLOR_CAPTIONTEXT);
    FCaptionTextColor[False] := GetSysColor(COLOR_INACTIVECAPTIONTEXT);
    if PainterInfo <> nil then
    begin
      FCaptionTextColor[True] := PainterInfo.FormFrames[True, bTop].TextColor;
      if PainterInfo.FormTextShadowColor <> nil then
        FCaptionTextShadowColor := PainterInfo.FormTextShadowColor.Value;
      if PainterInfo.FormInactiveColor <> nil then
        FCaptionTextColor[False] := PainterInfo.FormInactiveColor.Value
      else
        FCaptionTextColor[False] := FCaptionTextColor[True];
    end;
  end;
end;

procedure TdxSkinFormNonClientAreaInfo.CalculateFrameSizes;
begin
  if HasClientEdge then
    FClientEdgeSize := Size(GetSystemMetrics(SM_CXEDGE), GetSystemMetrics(SM_CYEDGE))  
  else
    FClientEdgeSize := cxNullSize;

  if HasBorder then
    FSizeFrame := Size(SkinBorderWidth[bRight], SkinBorderWidth[bBottom])
  else
    FSizeFrame := cxNullSize;

  FSuppressed := IsNativeBorderWidth;
  if Suppressed then
    FSizeFrame := cxSizeMin(SizeFrame, SystemSizeFrame);
end;

function TdxSkinFormNonClientAreaInfo.CalculateMargins: TRect;
var
  ASystemSizeFrame: TSize;
begin
  Result := cxRectOffset(BorderWidths, ClientOffset, ClientOffset);
  if ScrollBarsController.ScrollBarViewInfo[sbVertical].Visible then
    Inc(Result.Right, dxGetSystemMetrics(SM_CXVSCROLL, ScaleFactor));  
  if ScrollBarsController.ScrollBarViewInfo[sbHorizontal].Visible then
    Inc(Result.Bottom, dxGetSystemMetrics(SM_CYHSCROLL, ScaleFactor));  
  if IsZoomed and IsSizeBox then
  begin
    ASystemSizeFrame := GetSystemSizeFrame;
    OffsetRect(Result, ASystemSizeFrame.cx - SizeFrame.cx, ASystemSizeFrame.cy - SizeFrame.cy);
  end;
  if RightToLeftLayout then
    Result := TdxRightToLeftLayoutConverter.ConvertOffsets(Result);
end;

procedure TdxSkinFormNonClientAreaInfo.CalculateNavigationControlBounds;
var
  ANavigationControl: IdxFluentDesignNavigationControl;
begin
  FIsNavigationControlAssigned := False;
  FIsNavigationControlCollapsed := False;
  FNavigationControlDisplayMode := ncdmInline;
  FNavigationControlBounds := cxNullRect;

  if (FluentDesignForm <> nil) and (PainterInfo <> nil) and not IsIconic and
    (PainterInfo.FormSupportsNavigationControlExtensionToFormCaption <> nil) and
    (PainterInfo.FormSupportsNavigationControlExtensionToFormCaption.Value) then
  begin
    ANavigationControl := FluentDesignForm.GetNavigationControl;
    FNavigationControlBounds := FluentDesignForm.GetExtendedNavigationControlBounds;
    if (ANavigationControl <> nil) and not cxRectIsEmpty(FNavigationControlBounds) then
    begin
      FNavigationControlDisplayMode := ANavigationControl.GetDisplayMode;
      FNavigationControlBounds := cxRectOffset(FNavigationControlBounds, ClientBounds.TopLeft);
      FIsNavigationControlCollapsed := ANavigationControl.IsCollapsed or (FNavigationControlDisplayMode <> ncdmInline);
      FIsNavigationControlAssigned := True;
    end;
  end;
end;

procedure TdxSkinFormNonClientAreaInfo.CalculateScrollArea;
begin
  ScrollBarsController.CalculateScrollArea;
end;

procedure TdxSkinFormNonClientAreaInfo.CalculateWindowInfo;
var
  APoint: TPoint;
begin
  APoint := cxNullPoint;
  FStyle := GetWindowLong(Handle, GWL_STYLE);
  FExStyle := GetWindowLong(Handle, GWL_EXSTYLE);
  FRightToLeftLayout := FExStyle and WS_EX_LAYOUTRTL <> 0;
  FClientRect := cxGetClientRect(Handle);
  FWindowRect := cxGetWindowRect(Handle);
  Windows.ClientToScreen(Handle, APoint);
  if RightToLeftLayout then
    OffsetRect(FClientRect, APoint.X - FClientRect.Width, APoint.Y)
  else
    OffsetRect(FClientRect, APoint.X, APoint.Y);
  FClientOffset := TdxSkinFormHelper.GetClientOffset(Handle);
  FClientBounds := cxRectOffset(ClientRect, WindowRect.TopLeft, False);
  FWindowBounds := cxRectOffset(WindowRect, WindowRect.TopLeft, False);
  if IsNativeBorderWidth and not IsIconic then
  begin
    InflateRect(FWindowBounds,
      Min(0, SizeFrame.cx - SystemSizeFrame.cx),
      Min(0, SizeFrame.cy - SystemSizeFrame.cy));
  end;
  CalculateMenuBarInfo;
  UpdateSysMenuIcon;
end;

function TdxSkinFormNonClientAreaInfo.CheckAreBordersThin(const ABorderWidths: TRect): Boolean;
begin
  Result := cxMarginsWidth(ABorderWidths) <= 2 * dxShadowWindowThinBorderSize;
end;

function TdxSkinFormNonClientAreaInfo.EmulatedRoundedCorners: Boolean;
begin
  Result := (CornerRadius > 0) and not (IsZoomed or IsWin11OrLater and not IsMDIChild) and HasBorder;
end;

function TdxSkinFormNonClientAreaInfo.GetBorderRect(ASide: TcxBorder; const ABounds, AWidths: TRect): TRect;
begin
  Result := ABounds;
  case ASide of
    bLeft:
      Result.Right := Result.Left + AWidths.Left;
    bTop:
      Result.Bottom := Result.Top + AWidths.Top;
    bRight:
      Result.Left := Result.Right - AWidths.Right;
    bBottom:
      Result.Top := Result.Bottom - AWidths.Bottom;
  end;
end;

function TdxSkinFormNonClientAreaInfo.GetExtendedNavigationControlBounds: TRect;
begin
  if FIsNavigationControlAssigned then
  begin
    if FNavigationControlDisplayMode = ncdmInline then
    begin
      Result := WindowBounds;
      Result.Right := FNavigationControlBounds.Right;
      Inc(Result.Left, ScaleFactor.Apply(PainterInfo.FormFrames[True, bLeft].Borders.Left.Thin));
      Inc(Result.Top, ScaleFactor.Apply(PainterInfo.FormFrames[True, bTop].Borders.Top.Thin));
      Dec(Result.Bottom, ScaleFactor.Apply(PainterInfo.FormFrames[True, bBottom].Borders.Bottom.Thin));
    end
    else
    begin
      Result := FNavigationControlBounds;
      Result.Left := WindowBounds.Left + ScaleFactor.Apply(PainterInfo.FormFrames[True, bLeft].Borders.Left.Thin);
    end;
    if RightToLeftLayout then
      Result := TdxRightToLeftLayoutConverter.ConvertRect(Result, WindowBounds);
  end
  else
    Result := cxNullRect;
end;

function TdxSkinFormNonClientAreaInfo.GetIcons: TdxSkinFormIcons;
const
  MaximizeMenuIcons: array[Boolean] of TdxSkinFormIcon = (sfiMaximize, sfiRestore);
  MinimizeMenuIcons: array[Boolean] of TdxSkinFormIcon = (sfiMinimize, sfiRestore);
  SysMenuIcons: array[Boolean] of TdxSkinFormIcons = ([sfiMenu, sfiClose], [sfiClose]);
begin
  Result := [];
  if HasCaption then
  begin
    if Style and WS_SYSMENU = WS_SYSMENU then
      Result := SysMenuIcons[ToolWindow or IsDialog];
    if Style and WS_MINIMIZEBOX = WS_MINIMIZEBOX then
      Include(Result, MinimizeMenuIcons[IsIconic]);
    if Style and WS_MAXIMIZEBOX = WS_MAXIMIZEBOX then
      Include(Result, MaximizeMenuIcons[IsZoomed]);
    if ExStyle and WS_EX_CONTEXTHELP = WS_EX_CONTEXTHELP then
    begin
      if IsDialog or ([sfiMinimize, sfiMaximize] * Result = []) then
        Include(Result, sfiHelp);
    end;
  end;
end;

function TdxSkinFormNonClientAreaInfo.GetIsMenuCommandEnabled(AMenuCommandId: Integer): Boolean;
var
  AMenu: HMENU;
  AMenuItemInfo: TMenuItemInfo;
begin
  AMenu := GetSystemMenu(Handle, False);
  ZeroMemory(@AMenuItemInfo, SizeOf(AMenuItemInfo));
  AMenuItemInfo.cbSize := SizeOf(AMenuItemInfo);
  AMenuItemInfo.fMask := MIIM_STATE;
  if GetMenuItemInfo(AMenu, AMenuCommandId, False, AMenuItemInfo) then
    Result := AMenuItemInfo.fState and MF_GRAYED = 0
  else
    Result := True;
end;

function TdxSkinFormNonClientAreaInfo.GetMDIClientDrawRgn: HRGN;
var
  ARgn: HRGN;
  R: TRect;
begin
  R := WindowRect;
  Result := CreateRectRgnIndirect(R);
  InflateRect(R, -ClientEdgeSize.cx, -ClientEdgeSize.cy);
  ARgn := CreateRectRgnIndirect(R);
  CombineRgn(Result, Result, ARgn, RGN_XOR);
  DeleteObject(ARgn);
end;

function TdxSkinFormNonClientAreaInfo.GetShadowOffsets: TRect;
begin
  Result := dxShadowDefaultOffsets;
  if IsNativeBorderWidth then
  begin
    Dec(Result.Bottom, SystemBorderWidths.Bottom - FBorderWidths.Bottom);
    Dec(Result.Left, SystemBorderWidths.Left - FBorderWidths.Left);
    Dec(Result.Right, SystemBorderWidths.Right - FBorderWidths.Right);
    Dec(Result.Top, SystemBorderWidths.Top - FBorderWidths.Top);
  end;
end;

function TdxSkinFormNonClientAreaInfo.HasAcrylicBackground: Boolean;
begin
  Result := FIsAcrylicEnabled;
end;

function TdxSkinFormNonClientAreaInfo.IsNativeBorderWidth(ACheckZoomed: Boolean = True): Boolean;
begin
  Result := IsZoomed and (ACheckZoomed or FIsMDIChild) or HasMenu or FIsMDIClient or not ThemeActive or IsIconic;
end;

procedure TdxSkinFormNonClientAreaInfo.BuildSystemMenu(ASysMenu: THandle);
begin
  LoadStandardMenu;
  DeleteMenu(ASysMenu, 0, MF_BYPOSITION);
  cxMoveMenuItems(GetSubMenu(SystemMenu, 0), ASysMenu);
  ModifySystemMenu(ASysMenu);
end;

procedure TdxSkinFormNonClientAreaInfo.DestroyStandardMenu;
begin
  if FSystemMenu <> 0 then
  begin
    DestroyMenu(FSystemMenu);
    FSystemMenu := 0;
  end;
end;

procedure TdxSkinFormNonClientAreaInfo.LoadStandardMenu;
const
  SysMenuTypes: array[Boolean] of TcxSystemMenuType = (smSystem, smChild);
begin
  DestroyStandardMenu;
  FSystemMenu := cxLoadSysMenu(SysMenuTypes[IsMDIChild]);
end;

procedure TdxSkinFormNonClientAreaInfo.ModifySystemMenu(ASysMenu: THandle);
var
  ABorderIcons: TBorderIcons;
begin
  if HasBorder then
  begin
    ABorderIcons := [];
    if Style and WS_SYSMENU <> 0 then
      Include(ABorderIcons, biSystemMenu);
    if Style and WS_MAXIMIZEBOX <> 0 then
      Include(ABorderIcons, biMaximize);
    if Style and WS_MINIMIZEBOX <> 0 then
      Include(ABorderIcons, biMinimize);
    if ExStyle and WS_EX_CONTEXTHELP <> 0 then
      Include(ABorderIcons, biHelp);
    cxModifySystemMenu(ASysMenu, Handle, IsDialog, ABorderIcons, WindowState, False);
  end;
end;

procedure TdxSkinFormNonClientAreaInfo.ResetSystemMenu;
begin
  GetSystemMenu(Handle, True); // Win2k redrawing bug
  if IsMDIChild then // #AI: for correct mdi buttons drawing on main menu bar
    BuildSystemMenu(GetSystemMenu(Handle, False));
end;

procedure TdxSkinFormNonClientAreaInfo.UpdateCaption(const ANewText: string);
begin
  FCaption := ANewText;
  if IsMDIChild then
    SkinHelper.ChildChanged(Handle);
end;

procedure TdxSkinFormNonClientAreaInfo.UpdateSysMenuIcon;
var
  AIconInfo: TIconInfo;
  ABitmap: TBitmap;
begin
  DestroyIcon(FSysMenuIcon);
  FSysMenuIcon := 0;
  FIsSysMenuIconAlphaUsed := False;
  FSysMenuIcon := dxGetFormIcon(Handle,
    dxGetSystemMetrics(SM_CXSMICON, ScaleFactor),
    dxGetSystemMetrics(SM_CYSMICON, ScaleFactor));
  if (FSysMenuIcon <> 0) and HasAcrylicBackground then
  begin
    GetIconInfo(SysMenuIcon, AIconInfo);
    try
      ABitmap := TBitmap.Create;
      try
        ABitmap.Handle := AIconInfo.hbmColor;
        FIsSysMenuIconAlphaUsed := dxIsAlphaUsed(ABitmap);
      finally
        ABitmap.Free;
      end;
    finally
      if AIconInfo.hbmColor <> 0 then
        DeleteObject(AIconInfo.hbmColor);
      if AIconInfo.hbmMask <> 0 then
        DeleteObject(AIconInfo.hbmMask);
    end;
  end;
end;

function TdxSkinFormNonClientAreaInfo.UpdateCaptionIconStates: Boolean;
begin
  Result := IconInfoList.CalculateStates(ClientCursorPos);
end;

function TdxSkinFormNonClientAreaInfo.GetContentRect: TRect;
begin
  Result := cxRectContent(WindowBounds, BorderWidths);
end;

function TdxSkinFormNonClientAreaInfo.GetCornerRadius: Integer;
begin
  if HasBorder or IsWin11OrLater then
    Result := ScaleFactor.Apply(dxStandardFormCornerRadius[Controller.GetFormCorners])
  else
    Result := 0;
end;

function TdxSkinFormNonClientAreaInfo.GetBorderBounds(ASide: TcxBorder): TRect;
begin
  Result := FBorderBounds[ASide];
end;

function TdxSkinFormNonClientAreaInfo.GetButtonPressed: Boolean;
begin
  Result := GetMouseKeys and MK_LBUTTON = MK_LBUTTON;
end;

function TdxSkinFormNonClientAreaInfo.GetCaptionBounds: TRect;
begin
  Result := cxRectContent(BorderBounds[bTop], GetCaptionContentOffset);
  Inc(Result.Top, Byte(ToolWindow));
  Inc(Result.Left, ScaleFactor.Apply(dxSkinIconSpacing));
end;

function TdxSkinFormNonClientAreaInfo.GetCaptionContentOffset: TRect;
var
  ATopMargin: Integer;
begin
  if CaptionElement <> nil then
    Result := ScaleFactor.Apply(CaptionElement.ContentOffset.Rect)
  else
    Result := cxNullRect;

  Result.Left := SkinBorderWidth[bLeft];

  if Suppressed and HasCaption then
  begin
    Result.Top := Trunc(Result.Top / SuppressFactor);
    Result.Bottom := Trunc(Result.Bottom / SuppressFactor);
    Result.Left := Trunc(Result.Left / SuppressFactor);
    Result.Right := Trunc(Result.Right / SuppressFactor);
  end;

  if IsZoomed then
  begin
    ATopMargin := Max(Result.Top, SizeFrame.cy);
    Result.Left := Max(Result.Left, SizeFrame.cx);
    Result.Right := Max(Result.Right, SizeFrame.cx);
    Result.Bottom := Max(0, Result.Bottom - (ATopMargin - Result.Top));
    Result.Top := ATopMargin;
  end;
end;

function TdxSkinFormNonClientAreaInfo.GetCaptionTextAreaOffset: TRect;
begin
  Result := Rect(dxSkinFormTextOffset, 0, dxSkinFormTextOffset, 0);
  if CaptionElement <> nil then
    Result.Left := CaptionElement.ContentOffset.Left;
  Result := ScaleFactor.Apply(Result);
end;

function TdxSkinFormNonClientAreaInfo.GetCaptionElement: TdxSkinElement;
begin
  Result := PainterInfo.FormFrames[not ToolWindow, bTop];
end;

function TdxSkinFormNonClientAreaInfo.GetCaptionIconSize(AIcon: TdxSkinFormIcon): TSize;
begin
  if AIcon = sfiMenu then
    Result := CalculateMenuIconSize(ToolWindow)
  else
    Result := CalculateCaptionButtonSize(GetCaptionBounds, PainterInfo.FormIcons[not ToolWindow, AIcon]);
end;

function TdxSkinFormNonClientAreaInfo.GetCaptionTextColor: TColor;
begin
  Result := FCaptionTextColor[Active];
end;

function TdxSkinFormNonClientAreaInfo.GetHandle: HWND;
begin
  Result := Controller.Handle;
end;

function TdxSkinFormNonClientAreaInfo.GetRTLDependentClientCursorPos: TPoint;
begin
  Result := GetRTLDependentPos(ClientCursorPos);
end;

function TdxSkinFormNonClientAreaInfo.GetRTLDependentPos(const P: TPoint): TPoint;
begin
  Result := P;
  if RightToLeftLayout then
    Result := TdxRightToLeftLayoutConverter.ConvertPoint(Result, WindowBounds);
end;

function TdxSkinFormNonClientAreaInfo.GetClientCursorPos: TPoint;
begin
  Result := ScreenToClient(GetMouseCursorPos);
end;

function TdxSkinFormNonClientAreaInfo.GetClientRectOnClient: TRect;
begin
  Result := cxRectOffset(ClientRect, cxPointInvert(ClientRect.TopLeft));
end;

function TdxSkinFormNonClientAreaInfo.GetHasBorder: Boolean;
begin
  Result := (Style and WS_BORDER = WS_BORDER) or IsMDIChild and
    (SendMessage(Handle, DXM_SKINS_SUPPRESSMDICHILDBORDERS, 0, 0) = 0);
end;

function TdxSkinFormNonClientAreaInfo.GetHasCaption: Boolean;
begin
  Result := Style and WS_CAPTION = WS_CAPTION;
end;

function TdxSkinFormNonClientAreaInfo.GetHasCaptionTextShadow: Boolean;
begin
  Result := Active and not ToolWindow and cxColorIsValid(CaptionTextShadowColor);
end;

function TdxSkinFormNonClientAreaInfo.GetHasClientEdge: Boolean;
begin
  Result := TdxSkinFormHelper.HasClientEdge(Handle);
end;

function TdxSkinFormNonClientAreaInfo.GetHasMenu: Boolean;
begin
  Result := not cxRectIsEmpty(FMenuBounds);
end;

function TdxSkinFormNonClientAreaInfo.GetHasParent: Boolean;
begin
  Result := GetParent(Handle) <> 0;
end;

function TdxSkinFormNonClientAreaInfo.GetHasScrollsArea: Boolean;
begin
  Result :=
    ScrollBarsController.ScrollBarViewInfo[sbHorizontal].Visible or
    ScrollBarsController.ScrollBarViewInfo[sbVertical].Visible;
end;

function TdxSkinFormNonClientAreaInfo.GetHasSizeConstraints: Boolean;
begin
  Result := False;
  if Assigned(Controller.Form) then
  begin
    with Controller.Form.Constraints do
      Result := (MaxHeight <> 0) or (MaxWidth <> 0);
  end;
end;

function TdxSkinFormNonClientAreaInfo.GetIsAlphaBlendUsed: Boolean;
begin
  Result := TdxSkinFormHelper.IsAlphaBlendUsed(Handle);
end;

function TdxSkinFormNonClientAreaInfo.GetIsChild: Boolean;
begin
  Result := Style and WS_CHILD = WS_CHILD;
end;

function TdxSkinFormNonClientAreaInfo.GetIsDialog: Boolean;
begin
  Result := ExStyle and WS_EX_DLGMODALFRAME = WS_EX_DLGMODALFRAME;
end;

function TdxSkinFormNonClientAreaInfo.GetIsIconic: Boolean;
begin
  Result := Style and WS_ICONIC = WS_ICONIC;
end;

function TdxSkinFormNonClientAreaInfo.GetIsSizeBox: Boolean;
begin
  Result := Style and WS_SIZEBOX = WS_SIZEBOX;
end;

function TdxSkinFormNonClientAreaInfo.GetIsZoomed: Boolean;
begin
  Result := Style and WS_MAXIMIZE = WS_MAXIMIZE;
end;

function TdxSkinFormNonClientAreaInfo.GetNeedCheckNonClientSize: Boolean;
begin
  Result := HasBorder and not (IsNativeBorderWidth(False) or
    IsZoomed and TdxSkinCustomFormController.IsMDIChildWindow(Handle));
end;

function TdxSkinFormNonClientAreaInfo.GetNonClientMetrics: TNonClientMetrics;
begin
  Result := dxSystemInfo.NonClientMetrics;
end;

function TdxSkinFormNonClientAreaInfo.GetScaleFactor: TdxScaleFactor;
begin
  Result := Controller.ScaleFactor;
end;

function TdxSkinFormNonClientAreaInfo.GetScreenRect: TRect;
begin
  Result := GetMonitorWorkArea(MonitorFromWindow(Handle, MONITOR_DEFAULTTONEAREST));
end;

function TdxSkinFormNonClientAreaInfo.GetScrollBarsController: TdxSkinFormScrollBarsController;
begin
  Result := Controller.ScrollBarsController;
end;

function TdxSkinFormNonClientAreaInfo.GetSizeArea(ASide: TcxBorder): TRect;
begin
  Result := WindowBounds;
  if ASide in [bLeft, bRight] then
    Inc(Result.Top, BorderWidths.Top);
  with cxSizeMax(SizeFrame, cxSize(ScaleFactor.Apply(HitTestAreaMinSize))) do
    Result := GetBorderRect(ASide, Result, Rect(cx, cy, cx, cy));
end;

function TdxSkinFormNonClientAreaInfo.GetSizeCorners(ACorner: TdxCorner): TRect;
begin
  Result := WindowBounds;
  if ACorner in [coTopLeft, coBottomLeft] then
    Result.Right := Result.Left + Max(ScaleFactor.Apply(HitTestAreaMinSize), SizeFrame.cx)
  else
    Result.Left := Result.Right - Max(ScaleFactor.Apply(HitTestAreaMinSize), SizeFrame.cx);

  if ACorner in [coTopLeft, coTopRight] then
    Result.Bottom := Result.Top + BorderWidths.Top
  else
    Result.Top := Result.Bottom - Max(ScaleFactor.Apply(HitTestAreaMinSize), SizeFrame.cy);
end;

function TdxSkinFormNonClientAreaInfo.GetSkinBorderWidth(ASide: TcxBorder): Integer;
var
  AElement: TdxSkinElement;
begin
  AElement := PainterInfo.FormFrames[not ToolWindow, ASide];
  if AElement <> nil then
  begin
    if ASide in [bLeft, bRight] then
      Result := Max(AElement.Size.cx, AElement.MinSize.Width)
    else
      Result := Max(AElement.Size.cy, AElement.MinSize.Height);

    Result := ScaleFactor.Apply(Result);
  end
  else
    Result := 0;
end;

function TdxSkinFormNonClientAreaInfo.GetSuppressFactor: Single;
var
  ACaptionHeight: Integer;
begin
  Result := 1;
  if HasCaption and Suppressed then
  begin
    ACaptionHeight := CalculateCaptionHeight - CalculateCaptionContentHeight;
    if ACaptionHeight > 0 then
      Result := Max(1, cxMarginsHeight(ScaleFactor.Apply(CaptionElement.ContentOffset.Rect))) / ACaptionHeight;
  end;
end;

function TdxSkinFormNonClientAreaInfo.GetSystemBorderWidths: TRect;
const
  ObjectIdMap: array[Boolean] of Integer = (SM_CYCAPTION, SM_CYSMCAPTION);
var
  ASystemSizeFrame: TSize;
begin
  ASystemSizeFrame := GetSystemSizeFrame;
  Result := cxRect(ASystemSizeFrame.cx, ASystemSizeFrame.cy, ASystemSizeFrame.cx, ASystemSizeFrame.cy);
  if HasCaption then
    Inc(Result.Top, dxGetSystemMetrics(ObjectIdMap[ToolWindow], ScaleFactor)); 
  if HasMenu {and IsWinVistaCompatibilityMode} then
    Result.Top := MenuBounds.Top;
end;

function TdxSkinFormNonClientAreaInfo.GetSystemSizeFrame: TSize;
begin
  Result := cxNullSize;
  if HasBorder then
  begin
    if HasMenu {and IsWinVistaCompatibilityMode} then
    begin
      Result.cx := MenuBounds.Left;
      Result.cy := MenuBounds.Left;
    end
    else
    begin
      Result := cxSize(dxGetSystemMetrics(SM_CXSIZEFRAME, ScaleFactor), dxGetSystemMetrics(SM_CYSIZEFRAME, ScaleFactor));  
      if not IsSizeBox then
      begin
        Dec(Result.cx, NonClientMetrics.iBorderWidth);
        Dec(Result.cy, NonClientMetrics.iBorderWidth);
      end;
    end;
  end;
end;

function TdxSkinFormNonClientAreaInfo.GetThemeActive: Boolean;
begin
  if not ThemeActiveAssigned then
  begin
    FThemeActive := IsThemeActive;
    ThemeActiveAssigned := True;
  end;
  Result := FThemeActive;
end;

function TdxSkinFormNonClientAreaInfo.GetToolWindow: Boolean;
begin
  Result := ExStyle and WS_EX_TOOLWINDOW = WS_EX_TOOLWINDOW;
{$IFDEF DELPHI120}
  if Result then
  begin
    var AForm: TCustomForm := Controller.Form;
    Result := (AForm <> nil) and (TCustomFormAccess(AForm).FormStyle <> fsMDIChild);
  end;
{$ENDIF}
end;

function TdxSkinFormNonClientAreaInfo.GetWindowState: TWindowState;
begin
  Result := wsNormal;
  if IsZoomed then
    Result := wsMaximized;
  if IsIconic then
    Result := wsMinimized;
end;

procedure TdxSkinFormNonClientAreaInfo.SetActive(AActive: Boolean);
begin
  if FActive <> AActive then
  begin
    FActive := AActive;
    UpdateCaptionIconStates;
  end;
end;

procedure TdxSkinFormNonClientAreaInfo.SetSizeType(AValue: Integer);
begin
  if FSizeType <> AValue then
  begin
    if SizeType = SIZE_MAXIMIZED then
    begin
      if IsMDIChild then
        ResetSystemMenu;
      Controller.CheckWindowRgn;
    end;
    FSizeType := AValue;
  end;
end;

procedure TdxSkinFormNonClientAreaInfo.SetUpdateRgn(ARgn: HRGN);
begin
  if FUpdateRgn <> 0 then
    DeleteObject(FUpdateRgn);
  FUpdateRgn := ARgn;
  if FUpdateRgn <> 0 then
    OffsetRgn(FUpdateRgn, -WindowRect.Left, -WindowRect.Top);
end;

procedure TdxSkinFormNonClientAreaInfo.UpdateFormCaption;
begin
  UpdateCaption(GetWindowCaption(Handle));
end;

{ TdxSkinControllersList }

function TdxSkinControllersList.CanSkinControl(AControl: TWinControl): Boolean;
var
  AController: TdxSkinController;
  I: Integer;
begin
  Result := AControl <> nil;
  if Result then
    for I := Count - 1 downto 0 do
    begin
      AController := Items[I];
      if not (csDestroying in AController.ComponentState) then
      begin
        AController.DoSkinControl(AControl, Result);
        if Result then Break;
      end;
    end;
end;

function TdxSkinControllersList.CanSkinForm(AForm: TCustomForm): TdxSkinLookAndFeelPainter;
var
  AController: TdxSkinController;
  ASkinName: string;
  AUseSkin: Boolean;
  I: Integer;
begin
  Result := nil;
  if AForm <> nil then
  begin
    AUseSkin := GetDefaultUseSkins;
    ASkinName := GetDefaultSkinName;
    for I := Count - 1 downto 0 do
    begin
      AController := Items[I];
      if not (csDestroying in AController.ComponentState) then
      begin
        AController.DoSkinForm(AForm, ASkinName, AUseSkin);
        if AUseSkin and GetSkinPainter(ASkinName, Result) then
          Break;
      end;
    end;
  end;
end;

function TdxSkinControllersList.GetSkinPainter(const AName: string; out APainter: TdxSkinLookAndFeelPainter): Boolean;
var
  ATempPainter: TcxCustomLookAndFeelPainter;
begin
  Result := cxLookAndFeelPaintersManager.GetPainter(AName, ATempPainter) and (ATempPainter is TdxSkinLookAndFeelPainter);
  if Result then
    APainter := TdxSkinLookAndFeelPainter(ATempPainter);
end;

function TdxSkinControllersList.GetDefaultSkinName: string;
begin
  Result := RootLookAndFeel.SkinName;
end;

function TdxSkinControllersList.GetDefaultUseSkins: Boolean;
begin
  Result := cxUseSkins and not RootLookAndFeel.NativeStyle;
end;

function TdxSkinControllersList.GetItem(Index: TdxListIndex): TdxSkinController;
begin
  Result := TdxSkinController(inherited Items[Index]);
end;

function TdxSkinControllersList.FindItem(AForm: TCustomForm): TdxSkinController;

  function GetItemByForm(AForm: TCustomForm): TdxSkinController;
  var
    I: Integer;
  begin
    if AForm = nil then
      Exit(nil);
    for I := 0 to Count - 1 do
     if Items[I].Owner = AForm then
       Exit(Items[I]);
    Result := nil;
  end;

var
 P: TWinControl;
 I: Integer;
begin
  Result := nil;
  if Count = 0 then
    Exit;
  P := AForm;
  while P <> nil do
  begin
    if P is TCustomForm then
      Result := GetItemByForm(TCustomForm(P));
    if Result <> nil then
      Exit;
    P := P.Parent;
  end;
  for I := 0 to Screen.CustomFormCount - 1 do
  begin  
    Result := GetItemByForm(Screen.CustomForms[I]);
    if Result <> nil then
      Exit;
  end;    
  Result := Items[Count - 1];
end;

procedure TdxSkinControllersList.Notify(APtr: Pointer; AAction: TListNotification);
begin
  if dxISkinManager <> nil then
    dxISkinManager.SkinControllerListNotify(Self, TComponent(APtr), AAction);
end;

{ TdxSkinSkinnedControlsControllers }

procedure TdxSkinSkinnedControlsControllers.NotifyMasterDestroying(AMaster: TdxSkinWinController);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].MasterDestroying(AMaster);
end;

procedure TdxSkinSkinnedControlsControllers.Refresh(AControl: TWinControl);
begin
  Refresh(GetControllerByControl(AControl));
end;

procedure TdxSkinSkinnedControlsControllers.Refresh(AHandle: HWND);
begin
  Refresh(GetControllerByHandle(AHandle));
end;

procedure TdxSkinSkinnedControlsControllers.Refresh(AMaster: TdxSkinWinController);
var
  AList: TdxSkinWinControllerList;
  I: Integer;
begin
  if AMaster <> nil then
  begin
    AList := TdxSkinWinControllerList.Create(False);
    try
      AList.Add(AMaster);
      for I := 0 to Count - 1 do
      begin
        if Items[I].Master = AMaster then
          AList.Add(Items[I]);
      end;
      AList.Refresh;
    finally
      AList.Free;
    end;
  end;
end;

{ TdxSkinCustomFormController }

constructor TdxSkinCustomFormController.Create(AHandle: HWND);
begin
  inherited Create(AHandle);
  FViewInfo := CreateViewInfo;
  FPainter := CreatePainter;
  if IsMessageDlgWindow(AHandle) then
    PostMessage(AHandle, DXM_SKINS_POSTMSGFORMINIT, 0, 0);
  FScrollBarsController := TdxSkinFormScrollBarsController.Create(Self);
end;

destructor TdxSkinCustomFormController.Destroy;
begin
  Handle := 0;
  cxClearObjectLinks(Self);
  DeleteObject(FPrevVisibleRegion);
  FreeAndNil(FScrollBarsController);
  FreeAndNil(FPainter);
  FreeAndNil(FViewInfo);
  inherited Destroy;
end;

function TdxSkinCustomFormController.NCMouseDown(const P: TPoint): Boolean;
begin
  Result := True;
  IconsInfo.MouseDown(P);
  ScrollBarsController.MouseDown(ViewInfo.GetRTLDependentPos(P));
end;

function TdxSkinCustomFormController.NCMouseUp(const P: TPoint): Boolean;
var
  APressedIcon: TdxSkinFormIconInfo;
begin
  ScrollBarsController.MouseUp(ViewInfo.GetRTLDependentPos(P));
  IconsInfo.MouseUp(P, APressedIcon);
  RefreshOnMouseEvent(True);
  Result := Assigned(APressedIcon);
  if Result and APressedIcon.Enabled then
    SendMessage(Handle, WM_SYSCOMMAND, APressedIcon.Command, 0);
end;

procedure TdxSkinCustomFormController.RefreshController;
begin
  inherited RefreshController;
  ViewInfo.UpdateFormCaption;
end;

procedure TdxSkinCustomFormController.SetWindowRegion(ARegion: TcxRegionHandle);
begin
  HasRegion := ARegion <> 0;
  SetWindowRgn(Handle, ARegion, HasRegion);
end;

procedure TdxSkinCustomFormController.Refresh;
const
  WindowState: array[Boolean] of Integer = (0, SIZE_MAXIMIZED);
begin
  inherited Refresh;
  if Painter <> nil then
    Painter.FlushCache;
  if Handle <> 0 then
  begin
    if UseSkin then
    begin
      ViewInfo.SizeType := WindowState[ViewInfo.IsZoomed];
      ViewInfo.ResetSystemMenu;
      CheckWindowRgn(True);
    end
    else
      FlushWindowRgn(False);

    RefreshNativeFormCorners;
  end;
end;

procedure TdxSkinCustomFormController.UnhookWndProc;
begin
  if IsHooked then
    ViewInfo.BuildSystemMenu(GetSystemMenu(Handle, False));
  inherited UnhookWndProc;
end;

procedure TdxSkinCustomFormController.DoPopupSystemMenu(AForm: TCustomForm; ASysMenu: HMENU);
var
  I: Integer;
begin
  for I := 0 to dxSkinControllersList.Count - 1 do
    dxSkinControllersList[I].DoPopupSystemMenu(AForm, ASysMenu);
end;

procedure TdxSkinCustomFormController.DrawWindowBackground(DC: HDC);
begin
  Painter.BeginPaint(DC);
  try
    Painter.DrawWindowBackground;
  finally
    Painter.EndPaint;
  end;
end;

procedure TdxSkinCustomFormController.DrawWindowBorder(DC: HDC = 0);
begin
  Painter.BeginPaint(DC);
  try
    Painter.DrawWindowNonClientArea;
  finally
    Painter.EndPaint;
  end;
end;

procedure TdxSkinCustomFormController.DrawWindowScrollArea(DC: HDC = 0);
begin
  Painter.BeginPaint(DC);
  try
    Painter.DrawWindowScrollArea;
  finally
    Painter.EndPaint;
  end;
end;

procedure TdxSkinCustomFormController.CalculateViewInfo;
begin
  CalculateScaleFactor;
  ViewInfo.Calculate;
end;

procedure TdxSkinCustomFormController.CheckWindowRgn(AForceUpdate: Boolean = False);
var
  ARegion: HRGN;
  AScreenRegion: HRGN;
begin
  CalculateViewInfo;
  if ViewInfo.HasBorder then
  begin
    if ViewInfo.EmulatedRoundedCorners then
      ARegion := TdxFormHelper.CreateRoundedRegion(ViewInfo.WindowBounds, ViewInfo.CornerRadius)
    else
      ARegion := CreateRectRgnIndirect(ViewInfo.WindowBounds);

    if ViewInfo.IsZoomed and not ViewInfo.HasParent then
    begin
      AScreenRegion := CreateRectRgnIndirect(cxRectOffset(ViewInfo.ScreenRect, ViewInfo.WindowRect.TopLeft, False));
      CombineRgn(ARegion, ARegion, AScreenRegion, RGN_AND);
      DeleteObject(AScreenRegion);
    end;

    if AForceUpdate or not CompareWindowRegion(Handle, ARegion) then
      SetWindowRegion(ARegion)
    else
      DeleteObject(ARegion);
  end
  else
    FlushWindowRgn;
end;

procedure TdxSkinCustomFormController.FlushWindowRgn(ARedraw: Boolean = True);
begin
  if HasRegion then
  begin
    SetWindowRegion(0);
    if ARedraw then
      PostRedraw;
  end;
end;

procedure TdxSkinCustomFormController.InitializeMessageForm;
var
  AColor: TColor;
  AControl: TControl;
  AForm: TCustomForm;
  I: Integer;
begin
  AForm := Form;
  AColor := Painter.FormContentTextColor;
  for I := AForm.ControlCount - 1 downto 0 do
  begin
    AControl := AForm.Controls[I];
  {$IFDEF DELPHI104}
    if AControl is TImage then
      TImage(AControl).Transparent := True;
  {$ENDIF}
    if AControl is TCustomLabel then
    begin
      if AColor <> clDefault then
        TCustomLabelAccess(AControl).Font.Color := AColor;
      TCustomLabelAccess(AControl).Transparent := True;
    end;
  end;
end;

procedure TdxSkinCustomFormController.InvalidateBorders;
begin
  CalculateViewInfo;
  DrawWindowBorder;
end;

function TdxSkinCustomFormController.HandleInternalMessages(var AMessage: TMessage): Boolean;
begin
  Result := True;
  case AMessage.Msg of
    DXM_SKINS_POSTCHECKRGN:
      CheckWindowRgn(AMessage.WParam <> 0);
    DXM_SKINS_POSTREDRAW:
      RedrawWindow(False);
    DXM_SKINS_CHILDCHANGED:
      begin
        ViewInfo.UpdateFormCaption;
        DrawWindowBorder;
      end;
  else
    Result := False;
  end;
end;

function TdxSkinCustomFormController.HandleWindowMessage(var AMessage: TMessage): Boolean;
var
  AUpdateWindow: Boolean;
  AForm: TCustomForm;
begin
  Result := True;
  if ForceRedraw then
  begin
    DrawWindowBorder;
    ForceRedraw := False;
  end;
  case AMessage.Msg of
    CM_SHOWINGCHANGED: 
      begin
        AForm := Form;
        AUpdateWindow := (AForm <> nil) and UseSkin and AForm.Visible and (AForm.ParentWindow = 0);
        DefWndProc(AMessage);
        if AUpdateWindow then
        begin
          if IsWindowVisible(Handle) then
            UpdateWindow(Handle);
        end;
      end;
    WM_CONTEXTMENU:
      Result := WMContextMenu(TWMContextMenu(AMessage));
    WM_NCCALCSIZE:
      WMNCCalcSize(TWMNCCalcSize(AMessage));
    WM_NCMOUSEMOVE:
      WMNCMouseMove(TWMNCHitMessage(AMessage));
    WM_NCACTIVATE:
      WMNCActivate(TWMNCActivate(AMessage));
    WM_NCUAHDRAWFRAME, WM_NCUAHDRAWCAPTION, WM_SYNCPAINT:
      DrawWindowBorder;
    WM_NCLBUTTONDOWN, WM_NCLBUTTONDBLCLK:
      WMNCButtonDown(TWMNCHitMessage(AMessage));
    WM_NCLBUTTONUP:
      Result := NCMouseUp(ViewInfo.ClientCursorPos);
    WM_NCPAINT:
      WMNCPaint(TWMNCPaint(AMessage));
    WM_NCHITTEST:
      Result := WMNCHitTest(TWMNCHitTest(AMessage));
    WM_ERASEBKGND:
      WMEraseBkgnd(TWMEraseBkgnd(AMessage));
    WM_SYSMENU:
      WMSysMenu(AMessage);
    WM_SYSCOMMAND:
      WMSysCommand(TWMSysCommand(AMessage));
    WM_INITMENU:
      WMInitMenu(TWMInitMenu(AMessage));
    WM_ACTIVATE, WM_MOUSEACTIVATE:
      WMActivate(AMessage);

    WM_MOUSEMOVE:
      begin
        Result := ScrollBarsController.Scrolling;
        if Result then
          ScrollBarsController.MouseMove(ViewInfo.GetRTLDependentClientCursorPos);
      end;

    WM_LBUTTONUP:
      begin
        Result := ScrollBarsController.Scrolling;
        if Result then
        begin
          ScrollBarsController.MouseUp(ViewInfo.GetRTLDependentClientCursorPos);
          RefreshOnMouseEvent(True);
        end;
      end;

    WM_MOUSEWHEEL, CM_MOUSEWHEEL:
      if ViewInfo.ScrollBarsController.HasScrollBars then
      begin
        LockRedraw;
        try
          DefWndProc(AMessage);
          CalculateViewInfo;
        finally
          UnlockRedraw;
        end;
        RedrawWindow(False);
      end
      else
        Result := False;

    $3F:
      begin
        DefWndProc(AMessage);
        Refresh;
      end;
    else
      Result := HandleInternalMessages(AMessage);
  end;
end;

procedure TdxSkinCustomFormController.LockRedraw;
begin
  Inc(FLockRedrawCount);
  if FLockRedrawCount = 1 then
    DefWindowProc(Handle, WM_SETREDRAW, 0, 0);
end;

procedure TdxSkinCustomFormController.UnlockRedraw;
begin
  Dec(FLockRedrawCount);
  if FLockRedrawCount = 0 then
    DefWindowProc(Handle, WM_SETREDRAW, 1, 0);
end;

procedure TdxSkinCustomFormController.PostRedraw;
begin
  PostMessage(Handle, DXM_SKINS_POSTREDRAW, 0, 0);
end;

procedure TdxSkinCustomFormController.RefreshNativeFormCorners;
begin
  if IsWin11OrLater then
  begin
    if Assigned(ViewInfo) and ViewInfo.IsZoomed then 
      dxSetFormCorners(Handle, fcRectangular)
    else
      dxSetFormCorners(Handle, GetFormCorners);
  end;
end;

function TdxSkinCustomFormController.RefreshOnMouseEvent(AForceRefresh: Boolean = False): Boolean;

  procedure DoBeginMouseTracking(const R: TRect);
  begin
    BeginMouseTracking(nil, ViewInfo.ClientToScreen(R), Self);
  end;

begin
  ScrollBarsController.MouseMove(ViewInfo.GetRTLDependentClientCursorPos);
  Result := ViewInfo.UpdateCaptionIconStates;
  if Assigned(IconsInfo.IconHot) then
    DoBeginMouseTracking(IconsInfo.IconHot.Bounds)
  else
    if ScrollBarsController.HotPart <> nil then
    begin
      Result := not IsMouseTracking(Self);
      DoBeginMouseTracking(ScrollBarsController.HotPart.Bounds);
    end
    else
    begin
      Result := Result or IsMouseTracking(Self);
      EndMouseTracking(Self);
    end;

  if Result or AForceRefresh then
    InvalidateBorders;
end;

procedure TdxSkinCustomFormController.RefreshOnSystemMenuShown;
begin
  if IsWin2K or ViewInfo.IsNativeBorderWidth then
    PostRedraw;
end;

procedure TdxSkinCustomFormController.ShowSystemMenu(
  const P: TPoint; const AExcludeRect: TRect; ABottomAlign: Boolean);
const
  AlignMap: array[Boolean] of Integer = (TPM_TOPALIGN, TPM_BOTTOMALIGN);
var
  ACommand: LongWord;
  AParams: TTPMParams;
begin
  RefreshOnSystemMenuShown;
  ZeroMemory(@AParams, SizeOf(AParams));
  AParams.cbSize := SizeOf(AParams);
  AParams.rcExclude := AExcludeRect;
  ACommand := LongWord(TrackPopupMenuEx(GetSystemMenu(Handle, False),
    TPM_RETURNCMD or TPM_LEFTALIGN or AlignMap[ABottomAlign], P.X, P.Y, Handle, @AParams));
  PostMessage(Handle, WM_SYSCOMMAND, ACommand, 0);
end;

procedure TdxSkinCustomFormController.ShowSystemMenu(const P: TPoint);
begin
  ShowSystemMenu(P, cxNullRect);
end;

procedure TdxSkinCustomFormController.AfterWndProc(var AMessage: TMessage);
begin
  case AMessage.Msg of
    WM_SETICON:
      InvalidateNC;
    WM_PRINT:
      WMPrint(TWMPrint(AMessage));
    WM_SIZE:
      WMSize(TWMSize(AMessage));
    WM_WINDOWPOSCHANGED:
      WMWindowPosChanged(TWMWindowPosMsg(AMessage));
    WM_VSCROLL, WM_HSCROLL:
      RedrawWindow(True);
    WM_DESTROY, WM_MDIDESTROY:
      if AMessage.WParam = 0 then
      begin
        FLookAndFeelPainter := nil;
        UnhookWndProc;
      end;
  end;
end;

procedure TdxSkinCustomFormController.BeforeWndProc(var AMessage: TMessage);
begin
  case AMessage.Msg of
    WM_PAINT:
      WMPaint(TWMPaint(AMessage));
    WM_EXITMENULOOP, WM_QUERYOPEN:
      ViewInfo.ResetSystemMenu;
    WM_SHOWWINDOW:
      PostRedraw;
    WM_NCCREATE:
      begin
        FlushWindowRgn;
        CalculateViewInfo;
      end;
  end;
end;

procedure TdxSkinCustomFormController.WMActivate(var Message: TMessage);
var
  AObjectLink: TcxObjectLink;
begin
  AObjectLink := cxAddObjectLink(Self);
  try
    DefWndProc(Message);
    if Assigned(AObjectLink.Ref) then
      DrawWindowBorder;
  finally
    cxRemoveObjectLink(AObjectLink);
  end;
end;

function TdxSkinCustomFormController.WMContextMenu(var Message: TWMContextMenu): Boolean;
var
  APoint: TPoint;
begin
  APoint := SmallPointToPoint(Message.Pos);
  Result := (APoint.X <> -1) and (APoint.Y <> -1) and (ViewInfo.GetHitTest(APoint) in [HTCAPTION, HTSYSMENU]);
  if Result then
  begin
    ShowSystemMenu(APoint);
    Message.Result := 0;
  end;
end;

procedure TdxSkinCustomFormController.WMEraseBkgnd(var Message: TWMEraseBkgnd);

  function NeedExcludeOpaqueChildren: Boolean;
  begin
    Result := not (ViewInfo.RightToLeftLayout or cxIsDrawToMemory(Message) or (Form <> nil) and (csPaintCopy in Form.ControlState));
  end;

var
  ABuffer: TdxFastDIB;
  ASaveIndex: Integer;
begin
  if Message.DC <> 0 then
  begin
    ASaveIndex := SaveDC(Message.DC);
    try
      if NeedExcludeOpaqueChildren then
        ExcludeOpaqueChildren(Form, Message.DC);
      if dxIsGDIScaledMode then
      begin
        ABuffer := TdxFastDIB.Create(ViewInfo.ClientRectOnClient);
        try
          DrawWindowBackground(ABuffer.DC);
          cxBitBlt(Message.DC, ABuffer.DC, ViewInfo.ClientRectOnClient, cxNullPoint, SRCCOPY);
        finally
          ABuffer.Free;
        end;
      end
      else
        DrawWindowBackground(Message.DC);
    finally
      RestoreDC(Message.DC, ASaveIndex);
    end;
    Message.Result := 1;
  end;
end;

procedure TdxSkinCustomFormController.WMInitMenu(var Message: TWMInitMenu);
var
  AStyles: Integer;
begin
  Message.Menu := GetSystemMenu(Handle, False);
  AStyles := dxSetWindowStyle(Handle, WS_VISIBLE, soSubtract);
  try
    ViewInfo.BuildSystemMenu(Message.Menu);
    DoPopupSystemMenu(Form, Message.Menu);
    DefWndProc(Message);
  finally
    dxSetWindowStyle(Handle, AStyles, soSet);
  end;
end;

procedure TdxSkinCustomFormController.WMNCActivate(var Message: TWMNCActivate);
var
  AChildForm: TCustomForm;
  AStyles: DWORD;
begin
  ViewInfo.Active := Message.Active;
  if ViewInfo.IsChild then
  begin
    AStyles := dxSetWindowStyle(Handle, WS_VISIBLE, soSubtract);
    Message.Result := DefWindowProc(Handle, WM_NCACTIVATE, TMessage(Message).WParam, 0);
    dxSetWindowStyle(Handle, AStyles, soSet);
  end
  else
  begin
    if ViewInfo.HasAcrylicBackground then
      DefWndProc(Message);
    Message.Result := 1;
  end;

  AChildForm := TdxSkinFormHelper.GetActiveMDIChild(Handle);
  if Assigned(AChildForm) then
    AChildForm.Perform(WM_NCACTIVATE, TMessage(Message).WParam, 0);
  DrawWindowBorder;
end;

procedure TdxSkinCustomFormController.WMNCButtonDown(var Message: TWMNCHitMessage);
var
  AForm: TCustomForm;
  ALink: TcxObjectLink;
begin
  ALink := cxAddObjectLink(Self);
  try
    AForm := Form;
    if AForm <> nil then
      AForm.SendCancelMode(AForm);

    ForceRedraw := True;
    NCMouseDown(ViewInfo.ClientCursorPos);

    if not (Message.HitTest in [HTHSCROLL, HTVSCROLL]) then
    begin
      if (IconsInfo.IconPressed = nil) or
         (IconsInfo.IconPressed.IconType = sfiMenu)
      then
        DefWndProc(Message);
    end;

    if Assigned(ALink.Ref) then
    begin
      RefreshOnMouseEvent(True);
      DrawWindowBorder;
    end;
  finally
    cxRemoveObjectLink(ALink);
  end;
  Message.Result := 0;
end;

procedure TdxSkinCustomFormController.WMNCMouseMove(var Message: TWMNCHitMessage);
begin
  if not RefreshOnMouseEvent then
  begin
    Message.HitTest := HTNOWHERE;
    DefWndProc(Message);
    DrawWindowBorder;
  end;
end;

procedure TdxSkinCustomFormController.WMNCCalcSize(var Message: TWMNCCalcSize);
var
  R: TRect;
begin
  R := Message.CalcSize_Params^.rgrc[0];
  DefWndProc(Message);
  CalculateViewInfo;
  if ViewInfo.NeedCheckNonClientSize then
    Message.CalcSize_Params^.rgrc[0] := cxRectContent(R, ViewInfo.CalculateMargins);
end;

function TdxSkinCustomFormController.WMNCHitTest(var Message: TWMNCHitTest): Boolean;
begin
  Message.Result := ViewInfo.GetHitTest(SmallPointToPoint(Message.Pos), Message.Result);
  Result := (Message.Result <> HTNOWHERE) and (Message.Result <> HTSYSMENU);
end;

procedure TdxSkinCustomFormController.WMNCPaint(var Message: TWMNCPaint);
var
  AFrameRgn, AWindowRgn: HRgn;
begin
  InvalidateBorders;
  if ViewInfo.HasMenu or ViewInfo.IsMDIClient then
  begin
    AFrameRgn := ViewInfo.CreateDrawRgn;
    AWindowRgn := CreateRectRgnIndirect(ViewInfo.WindowRect);
    CombineRgn(AWindowRgn, AWindowRgn, AFrameRgn, RGN_XOR);
    DeleteObject(AFrameRgn);
    if Message.RGN <> 1 then
    begin
      CombineRgn(AWindowRgn, AWindowRgn, Message.RGN, RGN_AND);
      DeleteObject(Message.RGN);
    end;
    Message.RGN := AWindowRgn;
    DefWndProc(Message);
    DeleteObject(AWindowRgn);
  end;
  Message.RGN := 1;
  Message.Result := 0;
end;

procedure TdxSkinCustomFormController.WMPaint(var Message: TWMPaint);
begin
  ViewInfo.CalculateScrollArea;
  DrawWindowScrollArea;
end;

procedure TdxSkinCustomFormController.WMPrint(var Message: TWMPrint);
begin
  if (Message.Flags and PRF_CHECKVISIBLE = 0) or IsWindowVisible(Handle) then
  begin
    if Message.Flags and PRF_NONCLIENT <> 0 then
      DrawWindowBorder(Message.DC);
  end;
end;

procedure TdxSkinCustomFormController.WMSetText(var Message: TWMSetText);
begin
  DefWndProc(Message);
  ViewInfo.UpdateFormCaption;
  if UseSkin then
    InvalidateBorders;
end;

procedure TdxSkinCustomFormController.WMSize(var Message: TWMSize);
begin
  if ViewInfo.SizeType = SIZE_MAXIMIZED then
    PostRedraw;
  ViewInfo.SizeType := Message.SizeType;
  PostCheckRegion(Handle, True);
  RefreshNativeFormCorners;
end;

procedure TdxSkinCustomFormController.WMSysCommand(var Message: TWMSysCommand);
var
  ACommand: Integer;
  ALink: TcxObjectLink;
begin
  ACommand := Message.CmdType and $FFF0;
  if ACommand = SC_SCREENSAVE then
  begin
    DefWndProc(Message);
    Exit;
  end;

  ALink := cxAddObjectLink(Self);
  try
    RefreshOnSystemMenuShown;
    if (ACommand = SC_KEYMENU) and (Message.Key = $20) then
    begin
      LockWindowUpdate(Handle);
      DefWndProc(Message);
      LockWindowUpdate(0);
    end
    else
      DefWndProc(Message);

    if Assigned(ALink.Ref) then
    begin
      DrawWindowBorder;
      InvalidateRect(Handle, nil, False);
    end;

  finally
    cxRemoveObjectLink(ALink);
  end;
end;

procedure TdxSkinCustomFormController.WMSysMenu(var Message: TMessage);
begin
  if IsWindowEnabled(Handle) then //B136020
  begin
    DoPopupSystemMenu(Form, Message.LParam);
    ShowSystemMenu(GetMouseCursorPos);
  end;
  Message.Result := 0;
end;

procedure TdxSkinCustomFormController.WMWindowPosChanged(var Message: TWMWindowPosChanged);
var
  AIsMoving: Boolean;
  AIsSizing: Boolean;
  ANeedRecalculateNC: Boolean;
begin
  AIsMoving := Message.WindowPos^.flags and SWP_NOMOVE = 0;
  AIsSizing := Message.WindowPos^.flags and SWP_NOSIZE = 0;
  ANeedRecalculateNC := AIsMoving and IsZoomed(Handle) and IsWindowVisible(Handle);
  if AIsSizing or ANeedRecalculateNC then
  begin
    if ANeedRecalculateNC then
      dxRecalculateNonClientPart(Handle);
    CheckWindowRgn;
  end;
  if IsWin10FallCreatorsUpdate and (AIsMoving or AIsSizing) then
    TdxFormHelper.RepaintVisibleWindowArea(Handle, FPrevVisibleRegion);
end;

procedure TdxSkinCustomFormController.MouseLeave;
begin
  RefreshOnMouseEvent(True);
  UpdateWindow(Handle);
end;

function TdxSkinCustomFormController.GetForm: TCustomForm;
begin
  Result := TdxSkinFormHelper.GetForm(Handle);
end;

function TdxSkinCustomFormController.GetFormCorners: TdxFormCorners;
begin
  Result := fcRectangular;
end;

function TdxSkinCustomFormController.GetIconsInfo: TdxSkinFormIconInfoList;
begin
  Result := ViewInfo.IconInfoList;
end;

function TdxSkinCustomFormController.CreatePainter: TdxSkinFormPainter;
begin
  Result := TdxSkinFormPainter.Create(ViewInfo);
end;

function TdxSkinCustomFormController.CreateViewInfo: TdxSkinFormNonClientAreaInfo;
begin
  Result := TdxSkinFormNonClientAreaInfo.Create(Self);
end;

function TdxSkinCustomFormController.GetUseSkin: Boolean;
begin
  Result := inherited GetUseSkin and (ViewInfo <> nil);
end;

procedure TdxSkinCustomFormController.WndProc(var AMessage: TMessage);
begin
  case AMessage.Msg of
    WM_SETTEXT:
      WMSetText(TWMSetText(AMessage));
    WM_THEMECHANGED:
      ViewInfo.ThemeActiveAssigned := False;
    DXM_SKINS_POSTMSGFORMINIT:
      InitializeMessageForm;
  else
    if not UseSkin then
      DefWndProc(AMessage)
    else
      if not HandleWindowMessage(AMessage) then
      begin
        BeforeWndProc(AMessage);
        DefWndProc(AMessage);
        AfterWndProc(AMessage);
      end;
  end;
end;


{ TdxSkinWinController }

constructor TdxSkinWinController.Create(AHandle: HWND);
begin
  inherited Create;
  FScaleFactor := TdxScaleFactor.Create;
  Handle := AHandle;
end;

destructor TdxSkinWinController.Destroy;
begin
  MasterDestroyed;
  EndMouseTracking(Self);
  Handle := 0;
  FreeAndNil(FScaleFactor);
  inherited Destroy;
end;

class function TdxSkinWinController.IsMDIChildWindow(AHandle: HWND): Boolean;
begin
  Result := dxIsMDIChildWindow(AHandle);
end;

class function TdxSkinWinController.IsMDIClientWindow(AHandle: HWND): Boolean;
begin
  Result := (AHandle <> 0) and AnsiSameText(cxGetClassName(AHandle), 'MDICLIENT');
end;

class function TdxSkinWinController.IsMessageDlgWindow(AHandle: HWND): Boolean;
var
  AWindowClass: string;
begin
  AWindowClass := cxGetClassName(AHandle);
  Result := SameText(AWindowClass, 'TMessageForm') or SameText(AWindowClass, 'TForm');
end;

class function TdxSkinWinController.IsSkinActive(AHandle: HWND): Boolean;
var
  AController: TdxSkinWinController;
begin
  AController := SkinnedControlsControllers.GetControllerByHandle(AHandle);
  Result := Assigned(AController) and AController.UseSkin;
end;

class procedure TdxSkinWinController.FinalizeEngine(AHandle: HWND);
var
  AController: TdxSkinWinController;
begin
  AController := SkinnedControlsControllers.GetControllerByHandle(AHandle);
  if (AController <> nil) and AController.CanFinalizeEngine then
    SkinnedControlsControllers.FreeAndRemove(AController);
end;

class procedure TdxSkinWinController.InitializeEngine(AHandle: HWND);
var
  AController: TdxSkinWinController;
begin
  AController := SkinnedControlsControllers.GetControllerByHandle(AHandle);
  if AController = nil then
  begin
    AController := SkinnedControlsControllers.GetControllerByControl(FindControl(AHandle));
    if AController <> nil then
      AController.Handle := AHandle
    else
    begin
      AController := Create(AHandle);
      SkinnedControlsControllers.Add(AController);
    end;
    AController.RefreshControllerAndUpdate;
  end;
  PostCheckRegion(AHandle);
end;

procedure TdxSkinWinController.InvalidateNC;
begin
  if Handle <> 0 then
    dxRecalculateNonClientPart(Handle);
end;

procedure TdxSkinWinController.Refresh;
begin
  InvalidateNC;
end;

procedure TdxSkinWinController.RefreshController;
begin
  FMaster := FindMasterController;
  FLookAndFeelPainter := FindLookAndFeelPainter;
  FCanUseSkin := GetCanUseSkin;
end;

procedure TdxSkinWinController.RefreshControllerAndUpdate;
begin
  RefreshController;
  Update;
end;

procedure TdxSkinWinController.Update;
begin
  HookWndProc;
  Refresh;
  RedrawWindow(HasGraphicChildren);
end;

class procedure TdxSkinWinController.PostCheckRegion(AHandle: HWND; AForceCheck: Boolean = False);
begin
  PostMessage(AHandle, DXM_SKINS_POSTCHECKRGN, Ord(AForceCheck), 0);
end;

function TdxSkinWinController.CanFinalizeEngine: Boolean;
begin
  Result := True;
end;

procedure TdxSkinWinController.CalculateScaleFactor;
var
  M, D: Integer;
begin
  if dxGetCurrentScaleFactor(WinControl, M, D) then
    ScaleFactor.Assign(M, D)
  else
    ScaleFactor.Assign(dxSystemScaleFactor);
end;

function TdxSkinWinController.FindLookAndFeelPainter: TdxSkinLookAndFeelPainter;
begin
  Result := nil;
end;

function TdxSkinWinController.FindMasterController: TdxSkinWinController;
var
  AParentForm: TCustomForm;
begin
  Result := nil;
  if WinControl <> nil then
  begin
    AParentForm := GetParentForm(WinControl);
    if AParentForm <> nil then
      Result := SkinnedControlsControllers.GetControllerByHandle(AParentForm.Handle);
  end;
end;

function TdxSkinWinController.GetCanUseSkin: Boolean;
begin
  Result := dxSkinControllersList.CanSkinControl(WinControl);
end;

function TdxSkinWinController.GetUseSkin: Boolean;
begin
  Result := FCanUseSkin and (LookAndFeelPainter <> nil);
end;

function TdxSkinWinController.IsHookAvailable: Boolean;
begin
  Result := UseSkin;
end;

procedure TdxSkinWinController.DefWndProc(var AMessage);
begin
  if FWindowProcObject <> nil then
    FWindowProcObject.DefaultProc(TMessage(AMessage));
end;

procedure TdxSkinWinController.MasterDestroyed;
begin
  SkinnedControlsControllers.NotifyMasterDestroying(Self);
end;

procedure TdxSkinWinController.MasterDestroying(AMaster: TdxSkinWinController);
begin
  if FMaster = AMaster then
    FMaster := nil;
end;

procedure TdxSkinWinController.RedrawWindow(AUpdateNow: Boolean);
var
  AFlags: Integer;
const
  DefaultFlags = RDW_ERASE or RDW_INVALIDATE or RDW_FRAME or RDW_ALLCHILDREN;
begin
  if Handle = 0 then Exit;
  AFlags := DefaultFlags;
  if AUpdateNow then
    AFlags := AFlags or RDW_UPDATENOW;
  cxRedrawWindow(Handle, AFlags);
end;

procedure TdxSkinWinController.WndProc(var AMessage: TMessage);
begin
  DefWndProc(AMessage);
end;

procedure TdxSkinWinController.HookWndProc;
begin
  UnhookWndProc;
  if (Handle <> 0) and IsHookAvailable then
  begin
    if FWinControl = nil then
      FWindowProcObject := cxWindowProcController.Add(Handle, WndProc)
    else
      FWindowProcObject := cxWindowProcController.Add(FWinControl, WndProc);
  end;
end;

procedure TdxSkinWinController.UnhookWndProc;
begin
  if IsHooked then
    cxWindowProcController.Remove(FWindowProcObject);
end;

procedure TdxSkinWinController.MouseLeave;
begin
  // do nothing
end;

function TdxSkinWinController.GetHasGraphicChildren: Boolean;
var
  I: Integer;
begin
  Result := False;
  if WinControl <> nil then
    for I := 0 to WinControl.ControlCount - 1 do
    begin
      Result := not (WinControl.Controls[I] is TWinControl);
      if Result then Break;
    end;
end;

function TdxSkinWinController.GetIsHooked: Boolean;
begin
  Result := (Handle <> 0) and Assigned(FWindowProcObject);
end;

function TdxSkinWinController.GetLookAndFeelPainter: TdxSkinLookAndFeelPainter;
begin
  Result := FLookAndFeelPainter;
  if Master <> nil then
    Result := Master.LookAndFeelPainter;
end;

procedure TdxSkinWinController.SetHandle(AHandle: HWND);
begin
  UnhookWndProc;
  FHandle := AHandle;
  FWinControl := FindControl(Handle);
  Update;
end;

{ TdxSkinWinControllerList }

function TdxSkinWinControllerList.GetControllerByControl(AControl: TWinControl): TdxSkinWinController;
var
  I: Integer;
begin
  Result := nil;
  if AControl <> nil then
  begin
    for I := 0 to Count - 1 do
      if Items[I].WinControl = AControl then
      begin
        Result := Items[I];
        Break;
      end;
  end;
end;

function TdxSkinWinControllerList.GetControllerByHandle(AHandle: HWND): TdxSkinWinController;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
    if Items[I].Handle = AHandle then
    begin
      Result := Items[I];
      Break;
    end;
end;

procedure TdxSkinWinControllerList.Refresh;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].RefreshController;
  for I := 0 to Count - 1 do
    Items[I].Update;
end;

function TdxSkinWinControllerList.GetItem(Index: TdxListIndex): TdxSkinWinController;
begin
  Result := TdxSkinWinController(inherited Items[Index]);
end;

{ TdxSkinFormScrollBarsController }

constructor TdxSkinFormScrollBarsController.Create(AController: TdxSkinCustomFormController);
var
  AKind: TScrollBarKind;
begin
  inherited Create;
  FController := AController;
  for AKind := Low(TScrollBarKind) to High(TScrollBarKind) do
    FScrollBarViewInfo[AKind] := TdxSkinFormScrollBarViewInfo.Create(AKind, Self);
end;

destructor TdxSkinFormScrollBarsController.Destroy;
var
  AKind: TScrollBarKind;
begin
  FreeAndNil(FScrollTimer);
  for AKind := Low(TScrollBarKind) to High(TScrollBarKind) do
    FreeAndNil(FScrollBarViewInfo[AKind]);
  inherited Destroy;
end;

procedure TdxSkinFormScrollBarsController.CalculateDrawRegion(ARegion: HRGN);
begin
  if ScrollBarViewInfo[sbHorizontal].Visible then
    ViewInfo.CombineRectWithRegion(ARegion, ScrollBarViewInfo[sbHorizontal].Bounds);
  if ScrollBarViewInfo[sbVertical].Visible then
    ViewInfo.CombineRectWithRegion(ARegion, ScrollBarViewInfo[sbVertical].Bounds);
  if SizeGripVisible then
    ViewInfo.CombineRectWithRegion(ARegion, SizeGripBounds);
end;

procedure TdxSkinFormScrollBarsController.CalculateScrollArea;

  function DoGetScrollBarInfo(AKind: TScrollBarKind): TScrollBarInfo;
  const
    ScrollBarOBJIDs: array[TScrollBarKind] of DWORD = (OBJID_HSCROLL, OBJID_VSCROLL);
  var
    AScrollInfo: TScrollInfo;
  begin
    ZeroMemory(@Result, SizeOf(TScrollBarInfo));
    Result.cbSize := SizeOf(TScrollBarInfo);
    if IsTracking and (ScrollBarViewInfo[AKind] = PressedPart.Owner) then
    begin
      ZeroMemory(@AScrollInfo, SizeOf(AScrollInfo));
      AScrollInfo.cbSize := SizeOf(AScrollInfo);
      AScrollInfo.fMask := SIF_TRACKPOS or SIF_POS;
      GetScrollInfo(ViewInfo.Handle, Integer(AKind), AScrollInfo);
      Controller.LockRedraw;
      try
        SetScrollPos(Controller.Handle, Integer(AKind), AScrollInfo.nTrackPos, False);
        cxGetScrollBarInfo(Controller.Handle, Integer(ScrollBarOBJIDs[AKind]), Result);
        SetScrollPos(Controller.Handle, Integer(AKind), AScrollInfo.nPos, False);
      finally
        Controller.UnlockRedraw;
      end;
    end
    else
      cxGetScrollBarInfo(Controller.Handle, Integer(ScrollBarOBJIDs[AKind]), Result);
  end;

  function GetScrollBarBounds(const R: TRect; AKind: TScrollBarKind): TRect;
  begin
    if AKind = sbHorizontal then
      Result := cxRectSetTop(R, R.Bottom, dxGetSystemMetrics(SM_CYHSCROLL, ViewInfo.ScaleFactor)) 
    else
      Result := cxRectSetLeft(R, R.Right, dxGetSystemMetrics(SM_CXVSCROLL, ViewInfo.ScaleFactor));  
  end;

  function IsScrollBarVisible(AKind: TScrollBarKind): Boolean;
  const
    FlagsMap: array[TScrollBarKind] of Integer = (WS_HSCROLL, WS_VSCROLL);
  begin
    Result := UsecxScrollBars and (ViewInfo.Style and FlagsMap[AKind] <> 0) and
      not cxRectIsEmpty(ScrollBarViewInfo[AKind].Info.rcScrollBar);
  end;

  procedure CalculateScrollBarBounds(const AClientBounds: TRect; AKind: TScrollBarKind);
  begin
    ScrollBarViewInfo[AKind].FInfo := DoGetScrollBarInfo(AKind);
    ScrollBarViewInfo[AKind].FVisible := IsScrollBarVisible(AKind);
    ScrollBarViewInfo[AKind].FBounds := GetScrollBarBounds(AClientBounds, AKind);
  end;

var
  R: TRect;
begin
  R := ViewInfo.ClientBounds;
  if ViewInfo.RightToLeftLayout then
    R := TdxRightToLeftLayoutConverter.ConvertRect(R, ViewInfo.WindowBounds);
  CalculateScrollBarBounds(R, sbHorizontal);
  CalculateScrollBarBounds(R, sbVertical);
  if SizeGripVisible then
  begin
    ScrollBarViewInfo[sbHorizontal].FBounds.Right := ScrollBarViewInfo[sbVertical].Bounds.Left;
    ScrollBarViewInfo[sbVertical].FBounds.Bottom := ScrollBarViewInfo[sbHorizontal].Bounds.Top;
    FSizeGripBounds := cxRect(R.Right, R.Bottom,
      ScrollBarViewInfo[sbVertical].Bounds.Right, ScrollBarViewInfo[sbHorizontal].Bounds.Bottom);
  end;
  ScrollBarViewInfo[sbHorizontal].CalculateParts;
  ScrollBarViewInfo[sbVertical].CalculateParts;
end;

function TdxSkinFormScrollBarsController.CanScrollPage: Boolean;
begin
  Result := (PressedPart <> nil) and not
    PtInRect(PressedPart.Owner.PartViewInfo[sbpThumbnail].Bounds, ViewInfo.GetRTLDependentClientCursorPos);
end;

procedure TdxSkinFormScrollBarsController.Click;
const
  PageCodes: array[Boolean] of Integer = (SB_PAGEUP, SB_PAGEDOWN);
begin
  Controller.LockRedraw;
  try
    case PressedPart.Kind of
      sbpLineDown:
        SendScrollMessage(SB_LINEDOWN);
      sbpLineUp:
        SendScrollMessage(SB_LINEUP);
      sbpPageDown, sbpPageUp:
        if CanScrollPage then
          SendScrollMessage(PageCodes[PressedPart.Kind = sbpPageDown]);
    end;
  finally
    Controller.UnlockRedraw;
    Controller.RedrawWindow(True);
  end;
end;

procedure TdxSkinFormScrollBarsController.MouseDown(const P: TPoint);
begin
  PressedPart := HitTest(P);
  if PressedPart <> nil then
  begin
    FScrolling := True;
    SetCapture(Controller.Handle);
    if PressedPart.Kind = sbpThumbnail then
      TrackingBegin(P)
    else
      StartScrollTimer;
    Click;
  end;
end;

procedure TdxSkinFormScrollBarsController.MouseMove(const P: TPoint);
begin
  if IsTracking then
    Tracking(P)
  else
    HotPart := HitTest(P);
end;

procedure TdxSkinFormScrollBarsController.MouseUp(const P: TPoint);
begin
  if Scrolling then
  begin
    StopScrollTimer;
    TrackingEnd(P);
    SendScrollMessage(SB_ENDSCROLL);
    ReleaseCapture;
    PressedPart := nil;
    FScrolling := False;
  end;
end;

function TdxSkinFormScrollBarsController.HitTest(const P: TPoint): TdxSkinFormScrollBarPartViewInfo;
begin
  if not HitTest(P, Result) then
    Result := nil;
end;

function TdxSkinFormScrollBarsController.HitTest(
  const P: TPoint; out AScrollBarPart: TdxSkinFormScrollBarPartViewInfo): Boolean;
var
  AItem: TScrollBarKind;
begin
  for AItem := Low(AItem) to High(AItem) do
  begin
    Result := ScrollBarViewInfo[AItem].HitTest(P, AScrollBarPart);
    if Result then Break;
  end;
end;

procedure TdxSkinFormScrollBarsController.ScrollTimer(Sender: TObject);
begin
  if Scrolling then
  begin
    FScrollTimer.Interval := dxScrollInterval;
    if PtInRect(PressedPart.Bounds, ViewInfo.GetRTLDependentClientCursorPos) then
      Click;
  end;
end;

procedure TdxSkinFormScrollBarsController.SendScrollMessage(AParam: WPARAM);
const
  MessageMap: array[TScrollBarKind] of Integer = (WM_HSCROLL, WM_VSCROLL);
begin
  if PressedPart <> nil then
    SendMessage(Controller.Handle, MessageMap[PressedPart.Owner.Kind], AParam, 0);
end;

procedure TdxSkinFormScrollBarsController.StartScrollTimer;
begin
  if FScrollTimer = nil then
    FScrollTimer := TcxTimer.Create(nil);
  FScrollTimer.Interval := dxScrollInitialInterval;
  FScrollTimer.OnTimer := ScrollTimer;
end;

procedure TdxSkinFormScrollBarsController.StopScrollTimer;
begin
  FreeAndNil(FScrollTimer);
end;

procedure TdxSkinFormScrollBarsController.Tracking(const P: TPoint);

  function CalculateTrackDelta: Integer;
  begin
    if PressedPart.Owner.Kind = sbVertical then
      Result := P.Y - FTrackingLastPoint.Y
    else
      Result := P.X - FTrackingLastPoint.X;
  end;

begin
  FTrackPosition := FTrackPosition + CalculateTrackDelta * TrackingScale;
  FTrackPosition := Min(FTrackPosition, TrackingAreaInfo.nMax);
  FTrackPosition := Max(FTrackPosition, TrackingAreaInfo.nMin);
  TrackingSetThumbPosition(Trunc(FTrackPosition));
  Controller.InvalidateBorders;
  FTrackingLastPoint := P;
end;

procedure TdxSkinFormScrollBarsController.TrackingBegin(const P: TPoint);

  function GetFreeTrackBarSize: Integer;
  begin
    if TrackingScrollBarKind = sbVertical then
      Result :=
        cxRectHeight(PressedPart.Owner.PartViewInfo[sbpPageUp].Bounds) +
        cxRectHeight(PressedPart.Owner.PartViewInfo[sbpPageDown].Bounds)
    else
      Result :=
        cxRectWidth(PressedPart.Owner.PartViewInfo[sbpPageUp].Bounds) +
        cxRectWidth(PressedPart.Owner.PartViewInfo[sbpPageDown].Bounds);
  end;

begin
  FIsTracking := True;
  FTrackingLastPoint := P;

  ZeroMemory(@FTrackingAreaInfo, SizeOf(TScrollInfo));
  FTrackingAreaInfo.cbSize := SizeOf(TScrollInfo);
  FTrackingAreaInfo.fMask := SIF_ALL;
  GetScrollInfo(Controller.Handle, Integer(TrackingScrollBarKind), FTrackingAreaInfo);

  FTrackingScale := (TrackingAreaInfo.nMax - TrackingAreaInfo.nMin -
    Integer(TrackingAreaInfo.nPage)) / GetFreeTrackBarSize;
  FTrackPosition := TrackingAreaInfo.nPos;
end;

procedure TdxSkinFormScrollBarsController.TrackingEnd(const P: TPoint);
begin
  if IsTracking then
  begin
    Controller.LockRedraw;
    try
      TrackingSetThumbPosition(TrackingAreaInfo.nPos);
      SendScrollMessage(MakeLong(SB_THUMBPOSITION, Trunc(FTrackPosition)));
    finally
      Controller.UnlockRedraw;
    end;
    FIsTracking := False;
  end;
end;

procedure TdxSkinFormScrollBarsController.TrackingSetThumbPosition(APosition: Integer);
const
  ScrollBarsMap: array[TScrollBarKind] of Integer = (SB_HORZ, SB_VERT);
begin
  SetScrollPos(Controller.Handle, ScrollBarsMap[TrackingScrollBarKind], APosition, False);
end;

function TdxSkinFormScrollBarsController.GetHasScrollBars: Boolean;
begin
  Result := ScrollBarViewInfo[sbHorizontal].Visible or ScrollBarViewInfo[sbVertical].Visible;
end;

function TdxSkinFormScrollBarsController.GetScrollBarViewInfo(AKind: TScrollBarKind): TdxSkinFormScrollBarViewInfo;
begin
  Result := FScrollBarViewInfo[AKind];
end;

function TdxSkinFormScrollBarsController.GetSizeGripVisible: Boolean;
begin
  Result :=
    ScrollBarViewInfo[sbHorizontal].Visible and
    ScrollBarViewInfo[sbVertical].Visible;
end;

function TdxSkinFormScrollBarsController.GetTrackingScrollBarKind: TScrollBarKind;
begin
  if IsTracking then
    Result := PressedPart.Owner.Kind
  else
    raise EdxException.Create('GetTrackingScrollBarKind');
end;

function TdxSkinFormScrollBarsController.GetViewInfo: TdxSkinFormNonClientAreaInfo;
begin
  Result := Controller.ViewInfo;
end;

procedure TdxSkinFormScrollBarsController.SetHotPart(AValue: TdxSkinFormScrollBarPartViewInfo);
begin
  if FHotPart <> AValue then
  begin
    FHotPart := AValue;
    Controller.InvalidateBorders;
  end;
end;

procedure TdxSkinFormScrollBarsController.SetPressedPart(AValue: TdxSkinFormScrollBarPartViewInfo);
begin
  if FPressedPart <> AValue then
  begin
    FPressedPart := AValue;
    Controller.InvalidateBorders;
  end;
end;

{ TdxSkinFormIconInfo }

constructor TdxSkinFormIconInfo.Create(AType: TdxSkinFormIcon; AOwner: TdxSkinFormIconInfoList);
begin
  inherited Create;
  FOwner := AOwner;
  FIconType := AType;
end;

function TdxSkinFormIconInfo.CalculateState: TdxSkinElementState;
const
  PressedStateMap: array[Boolean] of TdxSkinElementState = (esHot, esPressed);
begin
  if (Owner.IconHot = Self) and Enabled then
    Result := PressedStateMap[(Owner.IconPressed = Self) and NonClientAreaInfo.ButtonPressed]
  else
    if NonClientAreaInfo.Active then
      Result := esNormal
    else
      Result := esActiveDisabled;
end;

function TdxSkinFormIconInfo.GetCommand: Integer;
const
  CommandMap: array[TdxSkinFormIcon] of Integer =
    (SC_DEFAULT, SC_CONTEXTHELP, SC_MINIMIZE, SC_MAXIMIZE, SC_RESTORE, SC_CLOSE);
begin
  Result := CommandMap[IconType];
end;

function TdxSkinFormIconInfo.GetEnabled: Boolean;
begin
  case IconType of
    sfiClose:
      Result := NonClientAreaInfo.GetIsMenuCommandEnabled(SC_CLOSE);
    sfiMinimize:
      Result := NonClientAreaInfo.Style and WS_MINIMIZEBOX = WS_MINIMIZEBOX;
    sfiMaximize:
      Result := NonClientAreaInfo.Style and WS_MAXIMIZEBOX = WS_MAXIMIZEBOX;
    else
      Result := True;
  end;
end;

function TdxSkinFormIconInfo.GetHitTest: Integer;
const
  HitTestMap: array[TdxSkinFormIcon] of Integer =
    (HTSYSMENU, HTHELP, HTMINBUTTON, HTMAXBUTTON, HTMAXBUTTON, HTCLOSE);
begin
  Result := HitTestMap[IconType];
end;

function TdxSkinFormIconInfo.GetNonClientAreaInfo: TdxSkinFormNonClientAreaInfo;
begin
  Result := Owner.NonClientAreaInfo;
end;

{ TdxSkinFormIconInfoList }

constructor TdxSkinFormIconInfoList.Create(ANonClientInfo: TdxSkinFormNonClientAreaInfo);
begin
  inherited Create;
  FNonClientAreaInfo := ANonClientInfo;
end;

function TdxSkinFormIconInfoList.Add(AIcon: TdxSkinFormIcon): TdxSkinFormIconInfo;
begin
  if not Find(AIcon, Result) then
  begin
    Result := TdxSkinFormIconInfo.Create(AIcon, Self);
    inherited Add(Result);
  end;
end;

function TdxSkinFormIconInfoList.CalculateStates(const P: TPoint): Boolean;
var
  AIconInfo: TdxSkinFormIconInfo;
  AState: TdxSkinElementState;
  I: Integer;
begin
  Result := False;
  FIconHot := HitTest(P);
  for I := 0 to Count - 1 do
  begin
    AIconInfo := Items[I];
    AState := AIconInfo.CalculateState;
    Result := Result or (AState <> AIconInfo.State);
    AIconInfo.State := AState;
  end;
end;

function TdxSkinFormIconInfoList.Find(
  AIcon: TdxSkinFormIcon; out AInfo: TdxSkinFormIconInfo): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to Count - 1 do
  begin
    Result := Items[I].IconType = AIcon;
    if Result then
    begin
      AInfo := Items[I];
      Break;
    end;
  end;
end;

function TdxSkinFormIconInfoList.HitTest(const P: TPoint): TdxSkinFormIconInfo;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
  begin
    if PtInRect(Items[I].HitBounds, P) then
    begin
      Result := Items[I];
      Break;
    end;
  end;
end;

function TdxSkinFormIconInfoList.HitTest(const P: TPoint; out AInfo: TdxSkinFormIconInfo): Boolean;
begin
  AInfo := HitTest(P);
  Result := Assigned(AInfo);
end;

procedure TdxSkinFormIconInfoList.MouseDown(const P: TPoint);
begin
  if not HitTest(P, FIconPressed) then
    FIconPressed := nil;
  CalculateStates(P);
end;

procedure TdxSkinFormIconInfoList.MouseUp(const P: TPoint; out AIcon: TdxSkinFormIconInfo);
begin
  if IconPressed = IconHot then
    AIcon := IconPressed
  else
    AIcon := nil;

  FIconPressed := nil;
  CalculateStates(P);
end;

procedure TdxSkinFormIconInfoList.Validate(const AIcons: TdxSkinFormIcons);
var
  I: Integer;
begin
  for I := Count - 1 downto 0 do
  begin
    if not (Items[I].IconType in AIcons) then
      FreeAndDelete(I);
  end;
end;

function TdxSkinFormIconInfoList.GetItem(Index: TdxListIndex): TdxSkinFormIconInfo;
begin
  Result := TdxSkinFormIconInfo(inherited Items[Index]);
end;


function dxSkinCanSkinControl(AControl: TControl): Boolean;
var
  AHelper: IdxSkinSupport2;
begin
  if Supports(AControl, IdxSkinSupport2, AHelper) then
    Result := AHelper.IsSkinnable
  else
    Result := AControl <> nil;
end;

function dxSkinGetControllerClassForWindow(AWnd: HWND): TdxSkinWinControllerClass;
var
  AControl: TControl;
begin
  Result := nil;
  if TdxSkinWinController.IsMDIClientWindow(AWnd) then
    Result := TdxSkinFormMDIClientController
  else
  begin
    AControl := FindControl(AWnd);
    if dxSkinCanSkinControl(AControl) then
    begin
      if AControl is TCustomForm then
        Result := TdxSkinFormController;
      if AControl is TCustomFrame then
        Result := TdxSkinFrameController;
      if AControl is TCustomCheckBox then
        Result := TdxSkinCheckBoxController;      
      if AControl.ClassType = TButton then
        Result := TdxSkinButtonController;
      if AControl.ClassType = TRadioButton then
        Result := TdxSkinRadioButtonController;      
      if AControl.ClassType = TPanel then
        Result := TdxSkinPanelController;
    end;
  end;
end;

procedure dxSkinsWndProcHook(ACode: Integer; wParam: WPARAM; lParam: LPARAM; var AHookResult: LRESULT);
var
  AMsg: PCWPStruct;
begin
  if dxIsDesignTime then Exit;
  
  AMsg := PCWPStruct(lParam);
  case AMsg.message of
    WM_CHILDACTIVATE, WM_MDIACTIVATE:
      SkinHelper.ChildChanged(AMsg.hwnd);
    WM_CREATE, WM_MDICREATE:
      SkinHelper.InitializeEngine(AMsg.hwnd);
    DXM_SKINS_SETISSKINNED:
      SkinnedControlsControllers.Refresh(AMsg.hwnd);
    WM_DESTROY, WM_MDIDESTROY:
      if AMsg.wParam = 0 then
        SkinHelper.FinalizeEngine(AMsg.hwnd);
  end;
end;

var
  SetScrollInfo: function(hWnd: HWND; BarFlag: Integer; const ScrollInfo: TScrollInfo; Redraw: BOOL): Integer; stdcall;
  SetScrollPos: function (hWnd: HWND; nBar, nPos: Integer; bRedraw: BOOL): Integer stdcall;

function dxSkinsFormSetScrollPos(hWnd: HWND; nBar, nPos: Integer; bRedraw: BOOL): Integer; stdcall;
begin
  Result := SetScrollPos(hWnd, nBar, nPos, bRedraw and not TdxSkinWinController.IsSkinActive(hWnd));
end;

function dxSkinsFormSetScrollInfo(hWnd: HWND; BarFlag: Integer; const ScrollInfo: TScrollInfo; Redraw: BOOL): Integer; stdcall;
begin
  Result := SetScrollInfo(hWnd, BarFlag, ScrollInfo, Redraw and not TdxSkinWinController.IsSkinActive(hWnd));
end;

procedure RegisterAssistants;
begin
  SetScrollPos := FlatSB_SetScrollPos;
  SetScrollInfo := FlatSB_SetScrollInfo;
  FlatSB_SetScrollPos := dxSkinsFormSetScrollPos;
  FlatSB_SetScrollInfo := dxSkinsFormSetScrollInfo;
  dxSkinControllersList := TdxSkinControllersList.Create;
  SkinHelper := TdxSkinWinControllerHelper.Create;
  dxSetHook(htWndProc, dxSkinsWndProcHook);
  SkinnedControlsControllers := TdxSkinSkinnedControlsControllers.Create;
end;

procedure UnregisterAssistants;
begin
  FlatSB_SetScrollPos := SetScrollPos;
  FlatSB_SetScrollInfo := SetScrollInfo;
  dxReleaseHook(dxSkinsWndProcHook);
  SkinnedControlsControllers.Clear; // destroy all active controllers
  dxFreeGlobalObject(SkinnedControlsControllers);
  dxFreeGlobalObject(SkinHelper);
  dxFreeGlobalObject(dxSkinControllersList);
end;

{ TdxSkinFormController }

procedure TdxSkinFormController.Refresh;
begin
  inherited;
  UpdateFormShadow;
end;

procedure TdxSkinFormController.RefreshController;
begin
  inherited;
  UpdateFormShadow;
end;

procedure TdxSkinFormController.SetWindowRegion(ARegion: TcxRegionHandle);
begin
  inherited;
  if FShadowWindow <> nil then
    FShadowWindow.Refresh;
end;

function TdxSkinFormController.CanShowShadow: Boolean;
begin
  Result := dxDefaultBooleanToBoolean(dxSkinShowFormShadow, ViewInfo.AreBordersThin) and
    (WinControl <> nil) and (WinControl.Parent = nil);
end;

procedure TdxSkinFormController.CalculateViewInfo;
begin
  inherited;
  UpdateFormShadowSettings;
end;

function TdxSkinFormController.FindLookAndFeelPainter: TdxSkinLookAndFeelPainter;
begin
  Result := dxSkinControllersList.CanSkinForm(Form);
end;

function TdxSkinFormController.FindMasterController: TdxSkinWinController;
begin
  Result := nil;
end;

function TdxSkinFormController.GetCanUseSkin: Boolean;
begin
  Result := TdxSkinFormHelper.CanUseSkin(Form);
end;

function TdxSkinFormController.GetFormCorners: TdxFormCorners;
begin
  Result := dxSkinFormCorners;
end;

procedure TdxSkinFormController.HookWndProc;
begin
  inherited;
  UpdateFormShadow;
end;

procedure TdxSkinFormController.UnhookWndProc;
begin
  FreeAndNil(FShadowWindow);
  inherited;
end;

procedure TdxSkinFormController.UpdateFormShadow;
begin
  if (WinControl <> nil) and UseSkin and CanShowShadow then
  begin
    if FShadowWindow = nil then
      FShadowWindow := dxSkinFormShadowClass.Create(WinControl);
    UpdateFormShadowSettings;
    FShadowWindow.UpdateVisibility;
  end
  else
    FreeAndNil(FShadowWindow);
end;

procedure TdxSkinFormController.UpdateFormShadowSettings;
begin
  if FShadowWindow <> nil then
  begin
    FShadowWindow.CornerRadius := ViewInfo.CornerRadius;
    FShadowWindow.ResizeOwnerWindowUsingShadow := ViewInfo.IsSizeBox;
    FShadowWindow.ShadowOffsets := ViewInfo.GetShadowOffsets;
  end;
end;

{ TdxSkinFormBasedFormController }

constructor TdxSkinFormBasedFormController.Create(ASkinForm: TdxSkinForm);
begin
  FSkinForm := ASkinForm;
  inherited Create(ASkinForm.Handle);
end;

function TdxSkinFormBasedFormController.CanFinalizeEngine: Boolean;
begin
  Result := False;
end;

function TdxSkinFormBasedFormController.CanShowShadow: Boolean;
var
  AValue: TdxDefaultBoolean;
begin
  AValue := SkinForm.ShowFormShadow;
  if AValue = bDefault then
    AValue := dxSkinShowFormShadow;
  if AValue = bDefault then
    AValue := dxBooleanToDefaultBoolean(ViewInfo.AreBordersThin);
  Result := AValue = bTrue;
end;

procedure TdxSkinFormBasedFormController.DefWndProc(var AMessage);
begin
  SkinForm.DefaultWndProc(TMessage(AMessage))
end;

function TdxSkinFormBasedFormController.GetForm: TCustomForm;
begin
  Result := SkinForm;
end;

function TdxSkinFormBasedFormController.GetFormCorners: TdxFormCorners;
begin
  Result := SkinForm.FormCorners;
  if Result = fcDefault then
    Result := inherited GetFormCorners;
end;

function TdxSkinFormBasedFormController.IsHookAvailable: Boolean;
begin
  Result := False;
end;

{ TdxSkinFormMDIClientController }

function TdxSkinFormMDIClientController.FindMasterController: TdxSkinWinController;
begin
  Result := SkinnedControlsControllers.GetControllerByHandle(GetParent(Handle));
end;

function TdxSkinFormMDIClientController.GetCanUseSkin: Boolean;
begin
  Result := True;
end;

function TdxSkinFormMDIClientController.GetUseSkin: Boolean;
begin
  Result := inherited GetUseSkin and (Master <> nil) and Master.UseSkin;
end;

{ TdxSkinForm }

procedure TdxSkinForm.CreateWindowHandle(const Params: TCreateParams);
begin
  inherited CreateWindowHandle(Params);
  InitializeController;
end;

procedure TdxSkinForm.DestroyWindowHandle;
begin
  FinalizeController;
  inherited DestroyWindowHandle;
end;

procedure TdxSkinForm.DefaultWndProc(var Message: TMessage);
begin
  inherited WndProc(Message);
end;

procedure TdxSkinForm.FinalizeController;
begin
  if Controller <> nil then
  begin
    SkinnedControlsControllers.Remove(Controller);
    FreeAndNil(FController);
  end;
end;

procedure TdxSkinForm.InitializeController;
begin
  FController := TdxSkinFormBasedFormController.Create(Self);
  SkinnedControlsControllers.Add(Controller);
  Controller.RefreshControllerAndUpdate;
end;

procedure TdxSkinForm.InitializeNewForm;
begin
  inherited;
  FShowFormShadow := bDefault;
end;

procedure TdxSkinForm.WndProc(var Message: TMessage);
begin
  if Message.Msg = DXM_SKINS_HASOWNSKINENGINE then
  begin
    Message.Result := 1;
    Exit;
  end;

  if Message.Msg = WM_NCDESTROY then
    FinalizeController;

  if (Controller <> nil) and (Controller.Handle <> 0) then
    Controller.WndProc(Message)
  else
    DefaultWndProc(Message);
end;

procedure TdxSkinForm.SetFormCorners(AValue: TdxFormCorners);
begin
  if FFormCorners <> AValue then
  begin
    FFormCorners := AValue;
    if Controller <> nil then
      Controller.Refresh;
  end;
end;

procedure TdxSkinForm.SetShowFormShadow(AValue: TdxDefaultBoolean);
begin
  if FShowFormShadow <> AValue then
  begin
    FShowFormShadow := AValue;
    if Controller <> nil then
      Controller.Refresh;
  end;
end;

{ TdxSkinFormHelper }

class function TdxSkinFormHelper.CanUseSkin(AForm: TCustomForm): Boolean;
begin
  Result := Assigned(AForm) and (SendMessage(AForm.Handle, DXM_SKINS_GETISSKINNED, 0, 0) = 0);
end;

class function TdxSkinFormHelper.GetActiveMDIChild(AHandle: HWND): TCustomForm;
var
  ACustomForm: TCustomFormAccess;
begin
  Result := nil;
  ACustomForm := TCustomFormAccess(GetForm(AHandle));
  if (ACustomForm <> nil) and (ACustomForm.FormStyle = fsMDIForm) then
    if ACustomForm.ActiveMDIChild <> nil then
      Result := ACustomForm.ActiveMDIChild;
end;

class function TdxSkinFormHelper.GetClientOffset(AHandle: HWND): Integer;
var
  ACustomForm: TCustomFormAccess;
begin
  ACustomForm := TCustomFormAccess(GetForm(AHandle));
  if ACustomForm = nil then
    Result := 0
  else
    Result := ACustomForm.BorderWidth;
end;

class function TdxSkinFormHelper.GetForm(AHandle: HWND): TCustomForm;
var
  AControl: TWinControl;
begin
  AControl := FindControl(AHandle);
  if AControl is TCustomForm then
    Result := TCustomForm(AControl)
  else
    Result := nil;
end;

class function TdxSkinFormHelper.GetZoomedMDIChild(AHandle: HWND): TCustomForm;
var
  AActiveChild: TCustomForm;
begin
  AActiveChild := GetActiveMDIChild(AHandle);
  if Assigned(AActiveChild) and IsZoomed(AActiveChild.Handle) then
    Result := AActiveChild
  else
    Result := nil;
end;

class function TdxSkinFormHelper.HasClientEdge(AHandle: HWND): Boolean;
begin
  Result := GetWindowLong(AHandle, GWL_EXSTYLE) and WS_EX_CLIENTEDGE <> 0;
end;

class function TdxSkinFormHelper.IsAlphaBlendUsed(AHandle: HWND): Boolean;
begin
  Result := GetWindowLong(AHandle, GWL_EXSTYLE) and WS_EX_LAYERED <> 0;
  AHandle := GetParent(AHandle);
  if TdxSkinWinController.IsMDIClientWindow(AHandle) then
    Result := GetWindowLong(GetParent(AHandle), GWL_EXSTYLE) and WS_EX_LAYERED <> 0;
end;

{ TdxSkinCustomControlViewInfo }

constructor TdxSkinCustomControlViewInfo.Create(AController: TdxSkinWinController);
begin
  FController := AController;
end;

procedure TdxSkinCustomControlViewInfo.DrawBackground(ACanvas: TcxCanvas);
var
  AControl: TWinControl;
begin
  AControl := Controller.WinControl;
  if AControl <> nil then
    cxDrawTransparentControlBackground(AControl, ACanvas, ClientRect);
end;

procedure TdxSkinCustomControlViewInfo.DrawContent(ACanvas: TcxCanvas);
begin
  // do nothing
end;

function TdxSkinCustomControlViewInfo.GetClientHeight: Integer;
begin
  Result := cxRectHeight(ClientRect);
end;

function TdxSkinCustomControlViewInfo.GetClientRect: TRect;
begin
  Result := cxRectSetNullOrigin(cxGetWindowRect(Controller.Handle));
end;

function TdxSkinCustomControlViewInfo.GetClientWidth: Integer;
begin
  Result := cxRectWidth(ClientRect);
end;

function TdxSkinCustomControlViewInfo.GetFocusRect: TRect;
begin
  Result := cxNullRect;
end;

function TdxSkinCustomControlViewInfo.GetFont: TFont;
begin
  Result := TControlAccess(Controller.WinControl).Font;
end;

function TdxSkinCustomControlViewInfo.GetIsEnabled: Boolean;
begin
  Result := IsWindowEnabled(Controller.Handle);
end;

function TdxSkinCustomControlViewInfo.GetIsFocused: Boolean;
begin
  Result := GetFocus = Controller.Handle;
end;

function TdxSkinCustomControlViewInfo.GetIsMouseAtControl: Boolean;
begin
  Result := Controller.Handle = WindowFromPoint(GetMouseCursorPos);
end;

function TdxSkinCustomControlViewInfo.GetLookAndFeelPainter: TcxCustomLookAndFeelPainter;
begin
  Result := Controller.LookAndFeelPainter;
end;

function TdxSkinCustomControlViewInfo.GetScaleFactor: TdxScaleFactor;
begin
  Result := Controller.ScaleFactor;
end;

{ TdxSkinCustomControlController }

constructor TdxSkinCustomControlController.Create(AHandle: HWND);
begin
  inherited Create(AHandle);
  FViewInfo := CreateViewInfo;
end;

destructor TdxSkinCustomControlController.Destroy;
begin
  FreeAndNil(FViewInfo);
  inherited Destroy;
end;

procedure TdxSkinCustomControlController.Draw(DC: HDC = 0);
var
  AMemBmp: HBITMAP;
  AMemDC: HDC;
  ANeedReleaseDC: Boolean;
begin
  ANeedReleaseDC := DC = 0;
  if ANeedReleaseDC then
    DC := GetDCEx(Handle, 0, DCX_CACHE or DCX_CLIPSIBLINGS or DCX_WINDOW or DCX_VALIDATE);
  try
    if DoubleBuffered then
    begin
      AMemDC := CreateCompatibleDC(DC);
      AMemBmp := CreateCompatibleBitmap(DC, ViewInfo.ClientWidth, ViewInfo.ClientHeight);
      SelectObject(AMemDC, AMemBmp);
      try
        DoDraw(AMemDC);
      finally
        cxBitBlt(DC, AMemDC, ViewInfo.ClientRect, cxNullPoint, SRCCOPY);
        DeleteObject(AMemBmp);
        DeleteObject(AMemDC);
      end;
    end
    else
      DoDraw(DC);
  finally
    if ANeedReleaseDC then
      ReleaseDC(Handle, DC);
  end;
end;

function TdxSkinCustomControlController.CreateViewInfo: TdxSkinCustomControlViewInfo;
begin
  Result := TdxSkinCustomControlViewInfo.Create(Self);
end;

procedure TdxSkinCustomControlController.WndProc(var AMessage: TMessage);
var
  AHandled: Boolean;
begin
  AHandled := False;
  if UseSkin then
  begin
    case AMessage.Msg of
      WM_ERASEBKGND:
        AHandled := WMEraseBk(TWMEraseBkgnd(AMessage));
      WM_PAINT:
        AHandled := WMPaint(TWMPaint(AMessage));
    end;
  end;
  if not AHandled then
    inherited WndProc(AMessage);
end;

function TdxSkinCustomControlController.WMEraseBk(var AMessage: TWMEraseBkgnd): Boolean;
begin
  AMessage.Result := 1;
  Result := True;
end;

function TdxSkinCustomControlController.WMPaint(var AMessage: TWMPaint): Boolean;
var
  ADC: HDC;
  APaintStruct: TPaintStruct;
begin
  Result := True;
  if AMessage.DC = 0 then
  begin
    ADC := BeginPaint(Handle, APaintStruct);
    try
      Draw(ADC);
    finally
      EndPaint(Handle, APaintStruct);
    end;
  end
  else
    Draw(AMessage.DC);
end;

procedure TdxSkinCustomControlController.DoDraw(DC: HDC);
var
  AControl: TWinControlAccess;
begin
  CalculateScaleFactor;

  cxPaintCanvas.BeginPaint(DC);
  try
    cxPaintCanvas.SaveClipRegion;
    try
      ViewInfo.DrawBackground(cxPaintCanvas);
      ViewInfo.DrawContent(cxPaintCanvas);
      if ViewInfo.IsFocused and ViewInfo.LookAndFeelPainter.SupportsNativeFocusRect then
      begin
        cxPaintCanvas.Brush.Style := bsSolid;
        cxPaintCanvas.DrawFocusRect(ViewInfo.FocusRect);
      end;
    finally
      cxPaintCanvas.RestoreClipRegion;
    end;

    AControl := TWinControlAccess(WinControl);
    if AControl <> nil then
      AControl.PaintControls(cxPaintCanvas.Handle, nil);
  finally
    cxPaintCanvas.EndPaint;
  end;
end;

{ TdxSkinCustomButtonViewInfo }

procedure TdxSkinCustomButtonViewInfo.AfterConstruction;
begin
  inherited AfterConstruction;
  UpdateButtonState;
end;

function TdxSkinCustomButtonViewInfo.CalculateButtonState: TcxButtonState;
begin
  Result := cxbsNormal;
  if IsMouseAtControl then
    Result := cxbsHot;
  if IsPressed then
    Result := cxbsPressed;
end;

function TdxSkinCustomButtonViewInfo.GetCaption: string;
begin
  Result := GetWindowCaption(Controller.Handle);
end;

procedure TdxSkinCustomButtonViewInfo.UpdateButtonState;
begin
  State := CalculateButtonState;
end;

function TdxSkinCustomButtonViewInfo.GetIsPressed: Boolean;
begin
  Result := SendMessage(Controller.Handle, BM_GETSTATE, 0, 0) and BST_PUSHED <> 0;
end;

function TdxSkinCustomButtonViewInfo.GetIsRTL: Boolean;
begin
  Result := Controller.WinControl.BiDiMode in [bdRightToLeft, bdRightToLeftNoAlign];
end;

function TdxSkinCustomButtonViewInfo.GetWordWrap: Boolean;
begin
  Result := GetWindowLong(Controller.Handle, GWL_STYLE) and BS_MULTILINE <> 0;
end;

procedure TdxSkinCustomButtonViewInfo.SetState(AState: TcxButtonState);
var
  ANewState: TcxButtonState;
begin
  if IsEnabled then
    ANewState := AState
  else
    ANewState := cxbsDisabled;

  if ANewState <> FState then
  begin
    FState := ANewState;
    if Controller.UseSkin then
      Controller.RedrawWindow(True);
  end;
end;

{ TdxSkinCustomButtonController }

constructor TdxSkinCustomButtonController.Create(AHandle: HWND);
begin
  inherited Create(AHandle);
  DoubleBuffered := True;
end;

procedure TdxSkinCustomButtonController.MouseLeave;
begin
  inherited MouseLeave;
  ViewInfo.UpdateButtonState;
end;

procedure TdxSkinCustomButtonController.WndProc(var AMessage: TMessage);
begin
  inherited WndProc(AMessage); 
  case AMessage.Msg of
    WM_ENABLE, BM_SETSTATE, WM_MOUSELEAVE, WM_MOUSEMOVE, CM_MOUSELEAVE, WM_MOUSEHOVER:
      ViewInfo.UpdateButtonState;
    WM_UPDATEUISTATE:
      if UseSkin and (AMessage.WParamLo in [UIS_SET, UIS_CLEAR]) then
        Draw;
    WM_SETTEXT:
      if UseSkin then
        Draw;
  end;
end;

function TdxSkinCustomButtonController.GetViewInfo: TdxSkinCustomButtonViewInfo;
begin
  Result := inherited ViewInfo as TdxSkinCustomButtonViewInfo;
end;

{ TdxSkinButtonController }

function TdxSkinButtonController.CreateViewInfo: TdxSkinCustomControlViewInfo;
begin
  Result := TdxSkinButtonViewInfo.Create(Self);
end;

procedure TdxSkinButtonController.WndProc(var AMessage: TMessage);
var
  AButtonViewInfo: TdxSkinButtonViewInfo;
begin
  if AMessage.Msg = CM_FOCUSCHANGED then
  begin
    AButtonViewInfo := ViewInfo as TdxSkinButtonViewInfo;
    if TCMFocusChanged(AMessage).Sender is TButton then
      AButtonViewInfo.Active := TCMFocusChanged(AMessage).Sender = WinControl
    else
      AButtonViewInfo.Active := AButtonViewInfo.IsDefault;
  end;
  inherited WndProc(AMessage);
end;

{ TdxSkinButtonViewInfo }

procedure TdxSkinButtonViewInfo.DrawButtonBackground(ACanvas: TcxCanvas);
begin
  if IsCommandLink then
  begin
    LookAndFeelPainter.DrawScaledCommandLinkBackground(ACanvas, ClientRect, State, ScaleFactor);
    LookAndFeelPainter.DrawScaledCommandLinkGlyph(ACanvas, GetCommandLinkGlyphPos, State, ScaleFactor);
  end
  else
    if IsSplitButton then
    begin
      LookAndFeelPainter.DrawScaledButton(ACanvas, GetDropDownLeftPartBounds, State, ScaleFactor, cxbpDropDownLeftPart);
      LookAndFeelPainter.DrawScaledButton(ACanvas, GetDropDownRightPartBounds, State, ScaleFactor, cxbpDropDownRightPart);
    end
    else
      LookAndFeelPainter.DrawScaledButton(ACanvas, ClientRect, State, ScaleFactor);
end;

procedure TdxSkinButtonViewInfo.DrawButtonText(ACanvas: TcxCanvas);

  function GetDrawTextFlags: Integer;
  const
    TextAlignFlagsMap: array[Boolean] of Integer = (cxSingleLine, cxWordBreak);
  begin
    if IsCommandLink then
      Result := cxShowPrefix or cxAlignLeft
    else
      Result := cxShowPrefix or cxAlignCenter or TextAlignFlagsMap[WordWrap];
    Result := Result or IfThen(IsRTL, cxRTLReading);
  end;

  procedure DoDrawText(ATextColor: TColor);
  begin
    ACanvas.Font := Font;
    ACanvas.Font.Color := ATextColor;
    ACanvas.DrawText(Caption, GetTextRect, GetDrawTextFlags, True)
  end;

begin
  if Length(Caption) > 0 then
  begin
    ACanvas.Brush.Style := bsClear;
    if State = cxbsDisabled then
      DoDrawText(clBtnHighlight);
    DoDrawText(LookAndFeelPainter.ButtonSymbolColor(State));
  end;
end;

procedure TdxSkinButtonViewInfo.DrawContent(ACanvas: TcxCanvas);
begin
  DrawButtonBackground(ACanvas);
  DrawButtonText(ACanvas);
end;

function TdxSkinButtonViewInfo.CalculateButtonState: TcxButtonState;
begin
  Result := inherited CalculateButtonState;
  if (Result = cxbsNormal) and Active then
    Result := cxbsDefault;  
end; 

function TdxSkinButtonViewInfo.GetButton: TButton;
begin
  Result := Controller.WinControl as TButton;
end;

function TdxSkinButtonViewInfo.GetCaption: string;
begin
  Result := inherited GetCaption;
  if IsCommandLink then
    Result := Result + #13#10 + Button.CommandLinkHint;
end;

function TdxSkinButtonViewInfo.GetCommandLinkGlyphPos: TPoint;
begin
  Result := Point(8, 10);
end;

function TdxSkinButtonViewInfo.GetCommandLinkGlyphSize: TSize;
begin
  Result := LookAndFeelPainter.GetScaledCommandLinkGlyphSize(ScaleFactor);
end;

function TdxSkinButtonViewInfo.GetDropDownButtonSize: Integer;
begin
  Result := 16;
end;

function TdxSkinButtonViewInfo.GetDropDownLeftPartBounds: TRect;
begin
  Result := ClientRect;
  Dec(Result.Right, GetDropDownButtonSize);
end;

function TdxSkinButtonViewInfo.GetDropDownRightPartBounds: TRect;
begin
  Result := ClientRect;
  Result.Left := Result.Right - GetDropDownButtonSize;
end;

function TdxSkinButtonViewInfo.GetFocusRect: TRect;
begin
  if IsSplitButton then
    Result := GetDropDownLeftPartBounds
  else
    Result := ClientRect;

  Result := cxRectInflate(Result, -4, -4);
end;

function TdxSkinButtonViewInfo.GetIsCommandLink: Boolean;
begin
  Result := IsWinVistaOrLater and (Button.Style = bsCommandLink)
end;

function TdxSkinButtonViewInfo.GetIsDefault: Boolean;
begin
  Result := Button.Default;
end;

function TdxSkinButtonViewInfo.GetIsSplitButton: Boolean;
begin
  Result := IsWinVistaOrLater and (Button.Style = bsSplitButton)
end;

function TdxSkinButtonViewInfo.GetTextRect: TRect;
begin
  Result := GetFocusRect;
  if IsCommandLink then
  begin
    Result.TopLeft := GetCommandLinkGlyphPos;
    Inc(Result.Left, GetCommandLinkGlyphSize.cx);
  end;
end;

procedure TdxSkinButtonViewInfo.SetActive(AActive: Boolean);
begin
  if AActive <> FActive then
  begin
    FActive := AActive;
    UpdateButtonState;
  end;
end;

{ TdxSkinCustomCheckButtonViewInfo }

procedure TdxSkinCustomCheckButtonViewInfo.Calculate(out ATextRect, ACheckMarkRect: TRect);
var
  ACheckMarkPosition: TPoint;
  ACheckMarkSize: TSize;
  AIsLeftText: Boolean;
  ATextOffset: Integer;
const
  TextOffset = 4;
begin
  AIsLeftText := IsLeftText;
  ACheckMarkSize := GetCheckMarkSize;

  ACheckMarkPosition.Y := cxRectCenterVertically(ClientRect, ACheckMarkSize.cy).Top;
  if AIsLeftText then
    ACheckMarkPosition.X := ClientRect.Right - ACheckMarkSize.cx
  else
    ACheckMarkPosition.X := ClientRect.Left;
  ACheckMarkRect := cxRectBounds(ACheckMarkPosition, ACheckMarkSize.cx, ACheckMarkSize.cy);

  ATextRect := ClientRect;
  ATextOffset := ScaleFactor.GetDiscreteFactor.Apply(TextOffset);
  if AIsLeftText then
    ATextRect.Right := ACheckMarkRect.Left - ATextOffset
  else
    ATextRect.Left := ACheckMarkRect.Right + ATextOffset;
end;

function TdxSkinCustomCheckButtonViewInfo.GetFocusRect: TRect;
var
  ACheckMarkRect, R, AClientRect: TRect;
  AFocusRectOffset: Integer;
const
  FocusRectOffset = 1;
begin
  Calculate(Result, ACheckMarkRect);

  R := Result;
  cxTextOut(cxScreenCanvas.Handle, Caption, R, IfThen(WordWrap, CXTO_WORDBREAK) or CXTO_CALCRECT, Font);
  cxScreenCanvas.Dormant;

  Result := cxRectCenterVertically(Result, cxRectHeight(R));
  if not IsRTL then
    Result.Right := R.Right
  else
    Result.Left := Result.Right - R.Width;

  AClientRect := ClientRect;
  AFocusRectOffset := ScaleFactor.GetDiscreteFactor.Apply(FocusRectOffset);
  Result.Bottom := Min(Result.Bottom + AFocusRectOffset, AClientRect.Bottom);
  Result.Right := Min(Result.Right + AFocusRectOffset, AClientRect.Right);
  Result.Left := Max(Result.Left - AFocusRectOffset, AClientRect.Left);
  Result.Top := Max(Result.Top - AFocusRectOffset, AClientRect.Top);
end;

procedure TdxSkinCustomCheckButtonViewInfo.DrawContent(ACanvas: TcxCanvas);
var
  ATextRect, ACheckMarkRect: TRect;
begin
  Calculate(ATextRect, ACheckMarkRect);
  DrawCheckMark(ACanvas, ACheckMarkRect);
  DrawText(ACanvas, ATextRect);
end;

procedure TdxSkinCustomCheckButtonViewInfo.DrawText(ACanvas: TcxCanvas; const R: TRect);
var
  ATextFlags: Integer;
const
  TextAlignFlagsMap: array[Boolean] of Integer = (cxSingleLine, cxWordBreak);
begin
  ACanvas.Font := Font;
  ACanvas.Font.Color := LookAndFeelPainter.DefaultEditorTextColor(not IsEnabled);
  ATextFlags := cxAlignVCenter or cxShowPrefix or TextAlignFlagsMap[WordWrap] or IfThen(IsRTL, cxRTLReading or cxAlignRight);
  ACanvas.DrawText(Caption, R, ATextFlags, True);
end;

function TdxSkinCustomCheckButtonViewInfo.GetCheckMarkState: TcxCheckBoxState;
begin
  Result := TcxCheckBoxState(SendMessage(Controller.Handle, BM_GETCHECK, 0, 0));
end;

function TdxSkinCustomCheckButtonViewInfo.GetIsLeftText: Boolean;
begin
  Result := GetWindowLong(Controller.Handle, GWL_STYLE) and BS_LEFTTEXT <> 0;
end;

{ TdxSkinCheckBoxController }

function TdxSkinCheckBoxController.CreateViewInfo: TdxSkinCustomControlViewInfo;
begin
  Result := TdxSkinCheckBoxViewInfo.Create(Self);
end;

function TdxSkinCheckBoxController.GetViewInfo: TdxSkinCheckBoxViewInfo;
begin
  Result := TdxSkinCheckBoxViewInfo(inherited ViewInfo);
end;

procedure TdxSkinCheckBoxController.WndProc(var AMessage: TMessage);
begin
  inherited WndProc(AMessage);
end;

{ TdxSkinCheckBoxViewInfo }

procedure TdxSkinCheckBoxViewInfo.DrawCheckMark(ACanvas: TcxCanvas; const R: TRect);
begin
  LookAndFeelPainter.DrawScaledCheckButton(ACanvas, R, State, CheckMarkState, ScaleFactor);
end;

function TdxSkinCheckBoxViewInfo.GetCheckMarkSize: TSize;
begin
  Result := LookAndFeelPainter.ScaledCheckButtonSize(ScaleFactor);
end;

{ TdxSkinRadioButtonController }

function TdxSkinRadioButtonController.CreateViewInfo: TdxSkinCustomControlViewInfo;
begin
  Result := TdxSkinRadioButtonViewInfo.Create(Self);
end;

{ TdxSkinRadioButtonViewInfo }

procedure TdxSkinRadioButtonViewInfo.DrawCheckMark(ACanvas: TcxCanvas; const R: TRect);
begin
  LookAndFeelPainter.DrawScaledRadioButton(ACanvas, R.Left, R.Top, State, CheckMarkState = cbsChecked, IsFocused, clNone, ScaleFactor);
end;

function TdxSkinRadioButtonViewInfo.GetCheckMarkSize: TSize;
begin
  Result := LookAndFeelPainter.ScaledRadioButtonSize(ScaleFactor);
end;

{ TdxSkinPanelViewInfo }

procedure TdxSkinPanelViewInfo.DrawBackground(ACanvas: TcxCanvas);
var
  APanel: TCustomPanelAccess;
begin
  APanel := TCustomPanelAccess(Controller.WinControl);
  if not (csPaintCopy in APanel.ControlState) then
    ExcludeOpaqueChildren(APanel, ACanvas.Handle);

  if csParentBackground in APanel.ControlStyle then
    cxDrawTransparentControlBackground(APanel, ACanvas, ClientRect, False)
  else
    if APanel.Color = clBtnFace then
      LookAndFeelPainter.DrawPanelContent(ACanvas, ClientRect)
    else
      LookAndFeelPainter.DrawPanelBackground(ACanvas, APanel, ClientRect, APanel.Color);

  if (APanel.BevelOuter <> bvNone) or (APanel.BevelInner <> bvNone) then
    LookAndFeelPainter.DrawPanelScaledBorders(ACanvas, ClientRect, ScaleFactor);
end;

procedure TdxSkinPanelViewInfo.DrawContent(ACanvas: TcxCanvas);
const
  AlignHorz: array[TAlignment] of Longint = (DT_LEFT, DT_RIGHT, DT_CENTER);
  AlignVert: array[TVerticalAlignment] of Longint = (DT_TOP, DT_BOTTOM, DT_VCENTER);
var
  APanel: TCustomPanelAccess;
  R: TRect;
begin
  APanel := TCustomPanelAccess(Controller.WinControl);
  if APanel.ShowCaption then
  begin
    R := cxRectInflate(cxRectContent(ClientRect, LookAndFeelPainter.PanelBorderSize), -1);
    ACanvas.Brush.Style := bsClear;
    ACanvas.Font := Font;
    if (APanel.Font.Color = clWindowText) and (LookAndFeelPainter.PanelTextColor <> clDefault) then
      ACanvas.Font.Color := LookAndFeelPainter.PanelTextColor;
    cxDrawText(ACanvas.Handle, APanel.Caption, R, APanel.DrawTextBiDiModeFlags(
      DT_EXPANDTABS or DT_SINGLELINE or AlignHorz[APanel.Alignment] or AlignVert[APanel.VerticalAlignment]));
    ACanvas.Brush.Style := bsSolid;
  end;
end;

{ TdxSkinPanelController }

function TdxSkinPanelController.CreateViewInfo: TdxSkinCustomControlViewInfo;
begin
  Result := TdxSkinPanelViewInfo.Create(Self);
end;

function TdxSkinPanelController.WMEraseBk(var AMessage: TWMEraseBkgnd): Boolean;
begin
  Result := False;
end;

function TdxSkinPanelController.WMPaint(var AMessage: TWMPaint): Boolean;
begin
  Result := False;
  if not FPainting then
  begin
    FPainting := True;
    try
      Result := inherited WMPaint(AMessage);
    finally
      FPainting := False;
    end;
  end;
end;

function TdxSkinPanelController.WMPrintClient(var AMessage: TWMPrintClient): Boolean;
begin
  Result := (AMessage.Result <> 1) and 
    ((AMessage.Flags and PRF_CHECKVISIBLE = 0) or IsWindowVisible(Handle)) and WMPaint(TWMPaint(AMessage));
end;

procedure TdxSkinPanelController.WndProc(var AMessage: TMessage);
var
  AHandled: Boolean;
begin
  AHandled := False;
  if UseSkin then
  begin
    case AMessage.Msg of
      CM_COLORCHANGED:
        RedrawWindow(False);
      WM_PRINTCLIENT:
        AHandled := WMPrintClient(TWMPrintClient(AMessage));
    end;
  end;
  if not AHandled then
    inherited WndProc(AMessage);
end;

{ TdxSkinFormScrollBarPartViewInfo }

constructor TdxSkinFormScrollBarPartViewInfo.Create(
  AOwner: TdxSkinFormScrollBarViewInfo; AKind: TcxScrollBarPart);
begin
  inherited Create;
  FKind := AKind;
  FOwner := AOwner;
  FVisible := True;
end;

procedure TdxSkinFormScrollBarPartViewInfo.Calculate(APos1, APos2: Integer; AState: Integer);

  function IsPartPressed: Boolean;
  begin
    Result := (AState and STATE_SYSTEM_PRESSED <> 0) or
      (Self = Owner.Controller.PressedPart) and
      (Owner.Controller.IsTracking or (Self = Owner.Controller.HotPart));
  end;

  function CalculatePartBounds: TRect;
  begin
    Result := Owner.Bounds;
    if (APos1 <> APos2) and (APos1 <> -1) then
    begin
      if Owner.Kind = sbHorizontal then
        Result := cxRectSetXPos(Result, APos1, APos2)
      else
        Result := cxRectSetYPos(Result, APos1, APos2);
    end;
  end;

  function CalculatePartState: TcxButtonState;
  begin
    if IsPartPressed then
      Result := cxbsPressed
    else
      if AState and STATE_SYSTEM_UNAVAILABLE <> 0 then
        Result := cxbsDisabled
      else
        if (AState and STATE_SYSTEM_HOTTRACKED <> 0) or (Self = Owner.Controller.HotPart) then
          Result := cxbsHot
        else
          Result := cxbsNormal;
  end;

begin
  FVisible := AState and STATE_SYSTEM_INVISIBLE = 0;
  if Visible then
  begin
    FBounds := CalculatePartBounds;
    FState := CalculatePartState;
  end
  else
  begin
    FState := cxbsDefault;
    FBounds := cxNullRect;
  end;
end;

{ TdxSkinFormScrollBarViewInfo }

constructor TdxSkinFormScrollBarViewInfo.Create(
  AKind: TScrollBarKind; AController: TdxSkinFormScrollBarsController);
var
  APart: TcxScrollBarPart;
begin
  inherited Create;
  FKind := AKind;
  FController := AController;
  for APart := Low(TcxScrollBarPart) to High(TcxScrollBarPart) do
    FParts[APart] := TdxSkinFormScrollBarPartViewInfo.Create(Self, APart);
end;

destructor TdxSkinFormScrollBarViewInfo.Destroy;
var
  APart: TcxScrollBarPart;
begin
  for APart := Low(TcxScrollBarPart) to High(TcxScrollBarPart) do
    FreeAndNil(FParts[APart]);
  inherited Destroy;
end;

procedure TdxSkinFormScrollBarViewInfo.CalculatePart(APos1, APos2: Integer; APart: TcxScrollBarPart);
const
  PartToStateIndex: array[TcxScrollBarPart] of Integer = (0, 1, 5, 3, 2, 4);
begin
  PartViewInfo[APart].Calculate(APos1, APos2, Info.rgState[PartToStateIndex[APart]]);
end;

procedure TdxSkinFormScrollBarViewInfo.CalculateParts;
var
  R: TRect;
begin
  if Visible then
  begin
    R := Bounds;
    if Kind = sbVertical then
      R := cxRectSetXPos(R, R.Top, R.Bottom);

    CalculatePart(R.Left, R.Left + Info.dxyLineButton, sbpLineUp);
    CalculatePart(R.Right - Info.dxyLineButton, R.Right, sbpLineDown);
    CalculatePart(R.Left + Info.xyThumbTop, R.Left + Info.xyThumbBottom, sbpThumbnail);
    CalculatePart(R.Left + Info.dxyLineButton, R.Left + Info.xyThumbTop, sbpPageUp);
    CalculatePart(R.Left + Info.xyThumbBottom, R.Right - Info.dxyLineButton, sbpPageDown);
  end;
end;

function TdxSkinFormScrollBarViewInfo.HitTest(
  const P: TPoint; out APart: TdxSkinFormScrollBarPartViewInfo): Boolean;
var
  APartItem: TcxScrollBarPart;
begin
  Result := Visible and PtInRect(Bounds, P);
  if Result then
  begin
    for APartItem := Low(TcxScrollBarPart) to High(TcxScrollBarPart) do
    begin
      Result := PartViewInfo[APartItem].Visible and PtInRect(PartViewInfo[APartItem].Bounds, P);
      if Result then
      begin
        APart := PartViewInfo[APartItem];
        Break;
      end;
    end;
  end;
end;

function TdxSkinFormScrollBarViewInfo.GetPartViewInfo(APart: TcxScrollBarPart): TdxSkinFormScrollBarPartViewInfo;
begin
  Result := FParts[APart];
end;

function TdxSkinFormScrollBarViewInfo.GetScaleFactor: TdxScaleFactor;
begin
  Result := Controller.Controller.ViewInfo.ScaleFactor;
end;

{ TdxSkinController }

constructor TdxSkinController.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if dxSkinControllersList <> nil then
    dxSkinControllersList.Add(Self);
  Refresh;
end;

destructor TdxSkinController.Destroy;
begin
  Refresh;
  if dxSkinControllersList <> nil then
    dxSkinControllersList.Remove(Self);
  inherited Destroy;
end;

class procedure TdxSkinController.PopulateSkinColorPalettes(AValues: TStrings);
var
  AData: TdxSkinInfo;
  APaletteName: string;
  I: Integer;
begin
  AValues.Clear;
  if RootLookAndFeel.Painter.GetPainterData(AData) then
  begin
    AValues.BeginUpdate;
    try
      AValues.Add(sdxDefaultColorPaletteName);
      for I := 0 to AData.Skin.ColorPalettes.Count - 1 do
      begin
        APaletteName := AData.Skin.ColorPalettes[I].Name;
        if AValues.IndexOf(APaletteName) < 0 then
          AValues.Add(APaletteName);
      end;
      if AValues is TStringList then
        TStringList(AValues).Sort;
    finally
      AValues.EndUpdate;
    end;
  end;
end;

class procedure TdxSkinController.Refresh(AControl: TWinControl = nil);
begin
  if not (csDestroying in Application.ComponentState) then
  begin
    if SkinnedControlsControllers <> nil then
    begin
      if AControl = nil then
        SkinnedControlsControllers.Refresh
      else
        SkinnedControlsControllers.Refresh(AControl);
    end;
  end;
end;

function TdxSkinController.GetFormCorners: TdxFormCorners;
begin
  Result := dxSkinFormCorners;
end;

class function TdxSkinController.GetFormSkin(AForm: TCustomForm; var ASkinName: string): Boolean;
var
  AController: TdxSkinWinController;
begin
  AController := SkinnedControlsControllers.GetControllerByControl(AForm);
  Result := (AController <> nil) and (AController.LookAndFeelPainter <> nil);
  if Result then
    ASkinName := AController.LookAndFeelPainter.LookAndFeelName;
end;

class function TdxSkinController.GetPainterData(var AData): Boolean;
begin
  Result := (RootLookAndFeel.SkinPainter <> nil) and RootLookAndFeel.SkinPainter.GetPainterData(AData);
end;

procedure TdxSkinController.FullRefresh;
begin
  RootLookAndFeel.Refresh;
end;

procedure TdxSkinController.DoPopupSystemMenu(AForm: TCustomForm; ASysMenu: HMENU);
begin
  if Assigned(AForm) then
  begin
    if Assigned(OnPopupSysMenu) then
      OnPopupSysMenu(Self, AForm, ASysMenu);
  end;
end;

procedure TdxSkinController.DoSkinControl(AControl: TWinControl; var AUseSkin: Boolean);
begin
  if Assigned(OnSkinControl) then
    OnSkinControl(Self, AControl, AUseSkin);
end;

procedure TdxSkinController.DoSkinForm(AForm: TCustomForm; var ASkinName: string; var AUseSkin: Boolean);
begin
  if Assigned(OnSkinForm) then
    OnSkinForm(Self, AForm, ASkinName, AUseSkin);
end;

procedure TdxSkinController.Loaded;
begin
  inherited Loaded;
  Refresh;
end;

procedure TdxSkinController.MasterLookAndFeelChanged(Sender: TcxLookAndFeel; AChangedValues: TcxLookAndFeelValues);
begin
  inherited MasterLookAndFeelChanged(Sender, AChangedValues);
  Refresh;
end;

procedure TdxSkinController.MasterLookAndFeelDestroying(Sender: TcxLookAndFeel);
begin
  inherited MasterLookAndFeelDestroying(Sender);
  Refresh;
end;

function TdxSkinController.GetShowFormShadow: TdxDefaultBoolean;
begin
  Result := dxSkinShowFormShadow;
end;

function TdxSkinController.GetSkinPaletteName: string;
var
  AData: TdxSkinInfo;
begin
  if GetPainterData(AData) then
    Result := AData.Skin.ActiveColorPaletteName
  else
    Result := '';

  if Result = '' then
    Result := sdxDefaultColorPaletteName;
end;

function TdxSkinController.GetUseImageSet: TdxSkinImageSet;
begin
  Result := dxSkinsUseImageSet;
end;

function TdxSkinController.GetUseSkins: Boolean;
begin
  Result := cxUseSkins;
end;

function TdxSkinController.GetUseSkinsInPopupMenus: Boolean;
begin
  Result := cxUseSkinsInPopupMenus;
end;

function TdxSkinController.IsSkinPaletteNameStored: Boolean;
begin
  Result := SkinPaletteName <> sdxDefaultColorPaletteName;
end;

procedure TdxSkinController.SetFormCorners(AValue: TdxFormCorners);
begin
  if FormCorners <> AValue then
  begin
    dxSkinFormCorners := AValue;
    FullRefresh;
  end;
end;

procedure TdxSkinController.SetShowFormShadow(AValue: TdxDefaultBoolean);
begin
  if ShowFormShadow <> AValue then
  begin
    dxSkinShowFormShadow := AValue;
    FullRefresh;
  end;
end;

procedure TdxSkinController.SetSkinPaletteName(const Value: string);
var
  AData: TdxSkinInfo;
begin
  if GetPainterData(AData) then
  begin
    BeginUpdate;
    try
      AData.Skin.ActiveColorPaletteName := Value;
      FullRefresh;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TdxSkinController.SetUseImageSet(AValue: TdxSkinImageSet);
begin
  if AValue <> dxSkinsUseImageSet then
  begin
    dxSkinsUseImageSet := AValue;
    if UseSkins then
      FullRefresh;
  end;
end;

procedure TdxSkinController.SetUseSkins(AValue: Boolean);
begin
  if AValue <> UseSkins then
  begin
    cxUseSkins := AValue;
    FullRefresh;
  end;
end;

procedure TdxSkinController.SetUseSkinsInPopupMenus(AValue: Boolean);
begin
  if AValue <> UseSkinsInPopupMenus then
  begin
    cxUseSkinsInPopupMenus := AValue;
    FullRefresh;
  end;
end;



{ TdxSkinManagerProvider }

destructor TdxSkinManagerProvider.Destroy;
begin
  inherited Destroy;
end;

class procedure TdxSkinManagerProvider.Initialize;
begin
  dxISkinManager := TdxSkinManagerProvider.Create;
end;

function TdxSkinManagerProvider.IsAdvancedActivePainter: Boolean;
var
  APainter: TdxAdvancedSkinLookAndFeelPainter;
begin
  APainter := Safe<TdxAdvancedSkinLookAndFeelPainter>.Cast(GetActivePainter);
  Result := (APainter <> nil) and APainter.IsAdvanced;
end;

class procedure TdxSkinManagerProvider.Finalize;
begin
  dxISkinManager := nil;
end;

function TdxSkinManagerProvider.TryGetSkinController: TdxSkinController;
begin
  Result := dxSkinControllersList.FindItem(Application.MainForm);
end;

function TdxSkinManagerProvider.GetSkinController: TdxSkinController;
begin
  Result := TryGetSkinController;
end;

function TdxSkinManagerProvider.GetActiveColorPalette: TdxSkinColorPalette;
var
 ASkinInfo: TdxSkinInfo;
begin
  Result := nil;
  ASkinInfo := GetActiveSkinInfo;
  if ASkinInfo <> nil then
    Result := ASkinInfo.Skin.ActiveColorPalette;
end;

function TdxSkinManagerProvider.FindColorByName(const AColorName: string; out AColor: TdxAlphaColor): Boolean;
var
  AActivePalette: TdxSkinColorPalette;
  I: Integer;
begin
  AActivePalette := GetActiveColorPalette;
  if AActivePalette <> nil then
    for I := 0 to AActivePalette.Count - 1 do
     if AActivePalette.Items[I].Name = AColorName then
     begin
       AColor := TdxAlphaColors.FromColor(AActivePalette.Items[I].Value);
       Exit(True);
     end;
  Result := False;
end;

function TdxSkinManagerProvider.GetActiveColorPaletteName(out APaletteName: string): Boolean;
var
  AColorPalette: TdxSkinColorPalette;
begin
  AColorPalette := GetActiveColorPalette;
  Result := AColorPalette <> nil;
  if Result then
    APaletteName := AColorPalette.Name;
end;

function TdxSkinManagerProvider.GetActivePainter: TcxCustomLookAndFeelPainter;
var
  ALookAndFeel: TcxLookAndFeel;
begin
  Result := nil;
  ALookAndFeel := RootLookAndFeel;
  if ALookAndFeel <> nil then
    Result := ALookAndFeel.Painter;
end;

function TdxSkinManagerProvider.HasSkinController: Boolean;
begin
  Result := dxSkinControllersList.Count > 0;
end;

function TdxSkinManagerProvider.GetActiveSkinDetails: TdxSkinDetails;
var
  APainter: TcxCustomLookAndFeelPainter;
begin
  Result := nil;
  APainter := GetActivePainter;
  if APainter <> nil then
     APainter.GetPainterDetails(Result);
end;

function TdxSkinManagerProvider.GetActiveSkin: TdxSkin;
var
  ASkinInfo: TdxSkinInfo;
begin
  Result := nil;
  ASkinInfo := GetActiveSkinInfo;
  if ASkinInfo <> nil then
    Result := ASkinInfo.Skin;
end;

function TdxSkinManagerProvider.GetActiveSkinInfo: TdxSkinInfo;
var
  APainter: TcxCustomLookAndFeelPainter;
begin
  Result := nil;
  APainter := GetActivePainter;
  if APainter <> nil then
     APainter.GetPainterData(Result);
end;

function TdxSkinManagerProvider.GetActiveSkinName(out ASkinName: string): Boolean;
var
  ASkinDetails: TdxSkinDetails;
begin
  ASkinDetails := GetActiveSkinDetails;
  Result := ASkinDetails <> nil;
  if Result then
    ASkinName := ASkinDetails.Name;
end;

function TdxSkinManagerProvider.GetLocalizedSkinInfo(const ASkinID: string; out ADisplaySkinName, ADisplayGroupName, AGroupName: string): Boolean;
begin
  Result := TdxSkinNameList.GetLocalizedSkinInfo(ASkinID, ADisplaySkinName, ADisplayGroupName, AGroupName);
end;

function TdxSkinManagerProvider.GetLocalizedPaletteInfo(const ASkinID, APaletteID: string; out APaletteName, AGroupName: string): Boolean;
begin
  Result := TdxSkinNameList.GetLocalizedPaletteInfo(ASkinID, APaletteID, APaletteName, AGroupName);
end;

function TdxSkinManagerProvider.GetDefaultColorPaletteName: string;
begin
  Result := sdxDefaultColorPaletteName;
end;

function TdxSkinManagerProvider.GetDefaultPaletteGroupName: string;
begin
  Result := sdxDefaultColorPaletteGroupName;
end;

function TdxSkinManagerProvider.GetDefaultSkinGroupName: string;
begin
  Result := sdxDefaultSkinGroupName;
end;

function TdxSkinManagerProvider.GetInstance: TObject;
begin
  Result := Self;
end;

function TdxSkinManagerProvider.GetPaletteName: string;
begin
  Result := SkinController.SkinPaletteName;
end;

function TdxSkinManagerProvider.GetSkinName: string;
begin
  if SkinController <> nil then
    Result := SkinController.SkinName
  else
    Result := '';
end;

function TdxSkinManagerProvider.GetStyle: TcxLookAndFeelStyle;
begin
  Result := RootLookAndFeel.Painter.LookAndFeelStyle;
end;

procedure TdxSkinManagerProvider.RootLookAndFeelBeginUpdate;
begin
  RootLookAndFeel.BeginUpdate;
end;

procedure TdxSkinManagerProvider.RootLookAndFeelEndUpdate;
begin
  RootLookAndFeel.EndUpdate;
end;

procedure TdxSkinManagerProvider.SetSkin(AStyle: TcxLookAndFeelStyle; const ASkinName: string);
var
  ALookAndFeel: TcxLookAndFeel;
  ASkinController: TdxSkinController;
begin
  ALookAndFeel := RootLookAndFeel;
  ALookAndFeel.BeginUpdate;
  try
    case AStyle of
      lfsNative:
        ALookAndFeel.NativeStyle := True;
      lfsSkin:
        begin
          ALookAndFeel.SkinName := ASkinName;
          ALookAndFeel.NativeStyle := False;
        end;
    else
      begin
        ALookAndFeel.NativeStyle := False;
        ALookAndFeel.SkinName := '';
        ALookAndFeel.Kind := cxLookAndFeelKindMap[AStyle];
      end;
    end;

    if AStyle = lfsSkin then
    begin
      ASkinController := SkinController;
      if ASkinController <> nil then
        ASkinController.UseSkins := True;
    end;

  finally
    ALookAndFeel.EndUpdate;
  end;
end;

procedure TdxSkinManagerProvider.SetSkinFromResource(AInstance: THandle; const AResourceName, ASkinName: string);
begin
  if AInstance <> 0 then
    InternalSetUserSkin(procedure
      begin
        UserSkinLoadFromResource(AInstance, AResourceName, ASkinName);
      end);
end;

procedure TdxSkinManagerProvider.SetSkinFromFile(const ASkinName, AFileName: string);
begin
  if AFileName <> '' then
    InternalSetUserSkin(procedure
      begin
        UserSkinLoadFromFile(AFileName, ASkinName);
      end);
end;

procedure TdxSkinManagerProvider.SetSkinFromStream(const ASkinName: string; AStream: TStream);
begin
  if AStream <> nil then
    InternalSetUserSkin(procedure
      begin
        UserSkinLoadFromStream(AStream, ASkinName);
      end);
end;

procedure TdxSkinManagerProvider.InternalSetUserSkin(const ASetter: TProc);
var
  ALookAndFeel: TcxLookAndFeel;
  ASkinController: TdxSkinController;
begin
  if dxIUserSkinLoader = nil then 
    Exit;
  ALookAndFeel := RootLookAndFeel;
  ALookAndFeel.BeginUpdate;
  try
    ALookAndFeel.NativeStyle := False;
    ASetter();
    ALookAndFeel.SkinName := GetUserSkinName;
    ASkinController := SkinController;
    if ASkinController <> nil then
      ASkinController.UseSkins := True;
  finally
    ALookAndFeel.EndUpdate;
  end;
end;

procedure TdxSkinManagerProvider.PopulateSkinColorPalettes(AValues: TStringList);
var
  I: Integer;
  ASkin: TdxSkin;
begin
  ASkin := GetActiveSkin;
  if ASkin = nil then
  begin
    AValues.Clear;
    Exit;
  end;
  AValues.BeginUpdate;
  try
    AValues.Clear;
    for I := 0 to ASkin.ColorPalettes.Count - 1 do
      AValues.AddObject(ASkin.ColorPalettes[I].Name, ASkin.ColorPalettes[I]);
    AValues.Sort;
  finally
    AValues.EndUpdate;
  end;
end;

procedure TdxSkinManagerProvider.SetPaletteName(const AValue: string);
var
  ASkinController: TdxSkinController;
begin
  ASkinController := SkinController;
  if ASkinController <> nil then
    ASkinController.SkinPaletteName := AValue;
end;

function TdxSkinManagerProvider.UserSkinLoadFromResource(AInstance: THandle; const AResourceName, ASkinName: string): Boolean;
begin
  Result := (dxIUserSkinLoader <> nil) and dxIUserSkinLoader.LoadFromResource(AInstance, AResourceName, ASkinName);
end;

function TdxSkinManagerProvider.UserSkinLoadFromFile(const AFileName, ASkinName: string): Boolean;
begin
  Result := (dxIUserSkinLoader <> nil) and dxIUserSkinLoader.LoadFromFile(AFileName, ASkinName);
end;

function TdxSkinManagerProvider.UserSkinLoadFromStream(AStream: TStream; ASkinName: string): Boolean;
begin
  Result := (dxIUserSkinLoader <> nil) and dxIUserSkinLoader.LoadFromStream(AStream, ASkinName);
end;

function TdxSkinManagerProvider.GetUserSkinName: string;
begin
  if dxIUserSkinLoader <> nil then
    Result := dxIUserSkinLoader.GetUserSkinName
  else
    Result := '';
end;

procedure TdxSkinManagerProvider.AddListenerOnSkinControllerListChanged(const AMethod: TdxSkinManagerSkinControllerListChangeEvent);
begin
  FOnSkinControllersListChanged.Add(AMethod);
end;

procedure TdxSkinManagerProvider.RemoveListenerOnSkinControllerListChanged(const AMethod: TdxSkinManagerSkinControllerListChangeEvent);
begin
  FOnSkinControllersListChanged.Remove(AMethod);
end;

procedure TdxSkinManagerProvider.SkinControllerListNotify(AList: TList; ASkinController: TComponent; AAction: TListNotification);
begin
  if FOnSkinControllersListChangedLocked then
    Exit;
  FOnSkinControllersListChangedLocked := True;
  try
    FOnSkinControllersListChanged.Invoke(AList.Count, ASkinController, AAction);
  finally
    FOnSkinControllersListChangedLocked := False;
  end;
end;

procedure TdxSkinManagerProvider.AddListenerOnPaintersChanged(const AMethod: TdxSkinManagerPaintersChangeEvent);
begin
  if FOnPaintersChanged.Empty then
    cxLookAndFeelPaintersManager.AddListener(Self);
  FOnPaintersChanged.Add(AMethod);
end;

procedure TdxSkinManagerProvider.RemoveListenerOnPaintersChanged(const AMethod: TdxSkinManagerPaintersChangeEvent);
begin
  FOnPaintersChanged.Remove(AMethod);
  if FOnPaintersChanged.Empty then
    cxLookAndFeelPaintersManager.RemoveListener(Self);
end;

procedure TdxSkinManagerProvider.PaintersChanged(APainter: TcxCustomLookAndFeelPainter; AOperation: TOperation);
begin
  if FOnPaintersChangedLocked then
    Exit;
  FOnPaintersChangedLocked := True;
  try
    FOnPaintersChanged.Invoke(APainter, AOperation);
  finally
    FOnPaintersChangedLocked := False;
  end;
end;

procedure TdxSkinManagerProvider.AddListenerOnSkinValuesChanged(
  const AMethod: TdxSkinManagerSkinValuesChangeEvent);
begin
  if FOnSkinValuesChanged.Empty then
    RootLookAndFeel.AddChangeListener(Self);
  FOnSkinValuesChanged.Add(AMethod);
end;

procedure TdxSkinManagerProvider.RemoveListenerOnSkinValuesChanged(
  const AMethod: TdxSkinManagerSkinValuesChangeEvent);
begin
  FOnSkinValuesChanged.Remove(AMethod);
  if FOnSkinValuesChanged.Empty then
    RootLookAndFeel.RemoveChangeListener(Self);
end;

procedure TdxSkinManagerProvider.SkinValuesChanged(ALookAndFeel: TcxLookAndFeel; AChangedValues: TcxLookAndFeelValues);
begin
  if FOnSkinValuesChangedLocked then
    Exit;
  FOnSkinValuesChangedLocked := True;
  try
    FOnSkinValuesChanged.Invoke(ALookAndFeel, AChangedValues);
  finally
    FOnSkinValuesChangedLocked := False;
  end;
end;

// IcxLookAndFeelPainterListener
procedure TdxSkinManagerProvider.PainterAdded(APainter: TcxCustomLookAndFeelPainter);
begin
  PaintersChanged(APainter, TOperation.opInsert);
end;

procedure TdxSkinManagerProvider.PainterRemoved(APainter: TcxCustomLookAndFeelPainter);
begin
  PaintersChanged(APainter, TOperation.opRemove);
end;

// IcxLookAndFeelNotificationListener
procedure TdxSkinManagerProvider.MasterLookAndFeelChanged(Sender: TcxLookAndFeel; AChangedValues: TcxLookAndFeelValues);
begin
  SkinValuesChanged(Sender, AChangedValues);
end;

procedure TdxSkinManagerProvider.MasterLookAndFeelDestroying(Sender: TcxLookAndFeel);
begin
// nothing to do
end;

initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxSkinGetControllerClassForWindowProc := dxSkinGetControllerClassForWindow;
  RegisterAssistants;
  TdxSkinManagerProvider.Initialize;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxSkinManagerProvider.Finalize;
  UnregisterAssistants;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
