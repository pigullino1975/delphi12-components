{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressPDFViewer                                         }
{                                                                    }
{           Copyright (c) 2015-2024 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSPDFVIEWER AND ALL              }
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

unit dxPDFViewer;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Types, Windows, SysUtils, Classes, Buttons, Messages, Forms, Controls, ComCtrls, ImgList, StdCtrls,
  Graphics, Generics.Defaults, StrUtils, dxDPIAwareUtils, dxListView, dxTreeView, dxShellControls, cxShellCommon,
  Generics.Collections, dxCore, dxCoreClasses, cxClasses, dxCoreGraphics, cxGraphics, cxGeometry,
  dxGDIPlusClasses, dxThreading, dxProtectionUtils, dxAnimation, dxFading, cxLookAndFeelPainters, cxLookAndFeels, cxCustomCanvas,
  cxControls, cxEdit, dxImCtrl, dxCustomHint, dxCustomPreview, cxTextEdit, cxTrackBar, dxPDFBase, dxPDFCore,
  dxPDFDocument, dxPDFText, dxPDFCommandInterpreter, dxPDFFontUtils, dxPDFTypes, dxPDFSelection, dxPDFInteractivity,
  dxPDFRecognizedObject, dxPDFForm, dxPDFAnnotation, dxPDFDocumentViewer, cxListBox, dxPDFDocumentState, dxSmartImage;

const
  dxPDFViewerDefaultScrollStep: Integer = 30;
  dxPDFViewerDefaultSize: TSize = (cx: 200; cy: 150);
  dxPDFViewerDefaultZoomFactor = 100;
  dxPDFViewerFindPanelDefaultAnimationTime = 200;
  dxPDFViewerMaxZoomFactor = 500;
  dxPDFViewerMinZoomFactor = 10;
  dxPDFViewerZoomStep = 10;
  // HitTests bits
  hcBackground = 32;
  hcButton = 2; // for internal use
  hcField = 12;
  hcFindPanel = 32768;
  hcNavigationPaneSplitter = 65536;
  hcPageArea = 16;
  hcSelectionFrame = 4096;

type
  TdxPDFCustomViewer = class;
  TdxPDFViewerAttachments = class;
  TdxPDFViewerBookmarks = class;
  TdxPDFViewerButtonFadingHelper = class;
  TdxPDFViewerCellHitTest = class;
  TdxPDFViewerCellViewInfo = class;
  TdxPDFViewerContainerController = class;
  TdxPDFViewerContainerViewInfo = class;
  TdxPDFViewerCustomAnnotationViewInfo = class;
  TdxPDFViewerCustomController = class;
  TdxPDFViewerCustomHitTest = class;
  TdxPDFViewerWidgetViewInfo = class;
  TdxPDFViewerController = class;
  TdxPDFViewerControllerClass = class of TdxPDFViewerController;
  TdxPDFViewerDocumentHitTest = class;
  TdxPDFViewerFindPanel = class;
  TdxPDFViewerFindPanelAnimationController = class;
  TdxPDFViewerFindPanelController = class;
  TdxPDFViewerFindPanelHitTest = class;
  TdxPDFViewerFindPanelViewInfo = class;
  TdxPDFViewerHighlights = class;
  TdxPDFViewerInteractivityController = class;
  TdxPDFViewerNavigationPane = class;
  TdxPDFViewerNavigationPaneController = class;
  TdxPDFViewerNavigationPanePage = class;
  TdxPDFViewerNavigationPanePageViewInfo = class;
  TdxPDFViewerNavigationPaneViewInfo = class;
  TdxPDFViewerOptionsNavigationPane = class;
  TdxPDFViewerPageThumbnailPreview = class;
  TdxPDFViewerPainter = class;
  TdxPDFViewerSelection = class;
  TdxPDFViewerSelectionController = class;
  TdxPDFViewerTabNavigationController = class;
  TdxPDFViewerTextSearch = class;
  TdxPDFViewerThumbnails = class;
  TdxPDFViewerPagesViewInfo = class;
  TdxPDFViewerViewInfoList = class;
  TdxPDFViewerViewStateHistory = class;
  TdxPDFViewerViewStateHistoryController = class;


  TdxPDFViewerGetFindPanelVisibilityEvent = function(Sender: TdxPDFCustomViewer): Boolean of object;
  TdxPDFViewerOnAttachmentActionEvent = procedure(Sender: TdxPDFCustomViewer; AAttachment: TdxPDFFileAttachment; var AHandled: Boolean) of object;
  TdxPDFViewerOnHyperlinkClickEvent = procedure(Sender: TdxPDFCustomViewer; const AURI: string; var AHandled: Boolean) of object;
  TdxPDFViewerPrepareLockedStateImageEvent = procedure(Sender: TdxPDFCustomViewer; AImage: TcxBitmap32;
    var ADone: Boolean) of object;

  TdxPDFViewerNavigationPaneActivePage = (apNone, apThumbnails, apBookmarks, apAttachments);
  TdxPDFViewerBookmarksTextSize = (btsSmall, btsMedium, btsLarge);
  TdxPDFViewerFindPanelAnimation = (fpaSlide, fpaFade);
  TdxPDFViewerFindPanelDisplayMode = (fpdmManual, fpdmAlways, fpdmNever);
  TdxPDFViewerFindPanelAlignment = (fpalTopClient, fpalTopRight, fpalTopCenter, fpalTopLeft, fpalBottomClient, fpalBottomRight,
    fpalBottomCenter, fpalBottomLeft);
  TdxPDFViewerPageLayout = (plDefault, plSinglePageContinuous);
  TdxPDFViewerViewStateChangeType = (vsctNone, vsctRotation, vsctZooming, vsctSelecting, vsctScrolling);

  { IdxPDFInteractiveObject }

  IdxPDFInteractiveObject = interface // for internal use
  ['{87C72E68-8DD3-482F-B1A3-A0B344C0B254}']
    function AllowActivateByMouseDown: Boolean;
    function GetAction: TdxPDFInteractiveOperation;
    function GetCursor: TCursor;
    procedure Execute(AShift: TShiftState);
  end;

  { IdxPDFHintableObject }

  IdxPDFHintableObject = interface
  ['{3360F634-1A56-48AF-B133-6DC15C8CCC0A}']
    function GetBounds: TRect;
    function GetHint: string;
  end;

  { TdxPDFViewerOptionsPersistent }

  TdxPDFViewerOptionsPersistent = class(TcxOwnedPersistent)
  strict private
    function GetViewer: TdxPDFCustomViewer;
  protected
    procedure Initialize; virtual;

    procedure Changed; overload;
    procedure Changed(AType: TdxChangeType); overload; virtual;

    property Viewer: TdxPDFCustomViewer read GetViewer; 
  public
    constructor Create(AOwner: TPersistent); override;
    procedure Assign(Source: TPersistent); override;
  end;

  { TdxPDFViewerOptionsBehavior }

  TdxPDFViewerOptionsBehavior = class(TdxPDFViewerOptionsPersistent)
  strict private
    FShowHints: Boolean;
    //
    function GetRenderContentDelay: Integer;
    function GetRenderContentInBackground: Boolean;
    procedure SetRenderContentDelay(const AValue: Integer);
    procedure SetRenderContentInBackground(const AValue: Boolean);
    procedure SetShowHints(const AValue: Boolean);
  protected
    procedure DoAssign(ASource: TPersistent); override;
    property RenderContentInBackground: Boolean read GetRenderContentInBackground write
      SetRenderContentInBackground default False; 
  published
    constructor Create(AOwner: TPersistent); override;
    property RenderContentDelay: Integer read GetRenderContentDelay write SetRenderContentDelay
      default dxPDFDocumentViewerDefaultRenderContentDelay;
    property ShowHints: Boolean read FShowHints write SetShowHints default True;
  end;

  { TdxPDFViewerOptionsView }

  TdxPDFViewerOptionsView = class(TdxPDFViewerOptionsPersistent)
  strict private
    FPageLayout: TdxPDFViewerPageLayout;
    function GetHighlightCurrentPage: Boolean;
    procedure SetHighlightCurrentPage(const AValue: Boolean);
    procedure SetPageLayout(const AValue: TdxPDFViewerPageLayout);
  protected
    procedure DoAssign(ASource: TPersistent); override;
  published
    constructor Create(AOwner: TPersistent); override;
    property HighlightCurrentPage: Boolean read GetHighlightCurrentPage write SetHighlightCurrentPage
      default True;
    property PageLayout: TdxPDFViewerPageLayout read FPageLayout write SetPageLayout default plDefault;
  end;

  { TdxPDFViewerOptionsForm }

  TdxPDFViewerOptionsForm = class(TdxPDFViewerOptionsPersistent)
  strict private
    FAllowEdit: Boolean;
    FFocusRect: Boolean;
    //
    procedure SetAllowEdit(const AValue: Boolean);
    procedure SetFocusRect(const AValue: Boolean);
  protected
    procedure DoAssign(ASource: TPersistent); override;
  published
    constructor Create(AOwner: TPersistent); override;
    //
    property AllowEdit: Boolean read FAllowEdit write SetAllowEdit default False;
    property FocusRect: Boolean read FFocusRect write SetFocusRect default True;
  end;

  { TdxPDFViewerOptionsSelection }

  TdxPDFViewerOptionsSelection = class(TdxPDFViewerOptionsPersistent)
  strict private
    FAnnotations: Boolean;
    FImages: Boolean;
    FText: Boolean;
    //
    procedure SetAnnotations(const AValue: Boolean);
    procedure SetImages(const AValue: Boolean);
    procedure SetText(const AValue: Boolean);
    procedure InternalChanged;
  protected
    procedure DoAssign(ASource: TPersistent); override;
  published
    constructor Create(AOwner: TPersistent); override;
    //
    property Annotations: Boolean read FAnnotations write SetAnnotations default True;
    property Images: Boolean read FImages write SetImages default True;
    property Text: Boolean read FText write SetText default True;
  end;

  { TdxPDFViewerOptionsZoom }

  TdxPDFViewerOptionsZoom = class(TdxPDFViewerOptionsPersistent)
  strict private
    function GetMaxZoomFactor: Integer;
    function GetMinZoomFactor: Integer;
    function GetZoomFactor: Integer;
    function GetZoomMode: TdxPreviewZoomMode;
    function GetZoomStep: Integer;
    procedure SetMaxZoomFactor(const AValue: Integer);
    procedure SetMinZoomFactor(const AValue: Integer);
    procedure SetZoomFactor(const AValue: Integer);
    procedure SetZoomMode(const AValue: TdxPreviewZoomMode);
    procedure SetZoomStep(const AValue: Integer);
  protected
    procedure DoAssign(ASource: TPersistent); override;
  published
    property MaxZoomFactor: Integer read GetMaxZoomFactor write SetMaxZoomFactor default dxPDFViewerMaxZoomFactor;
    property MinZoomFactor: Integer read GetMinZoomFactor write SetMinZoomFactor default dxPDFViewerMinZoomFactor;
    property ZoomFactor: Integer read GetZoomFactor write SetZoomFactor default dxPDFViewerDefaultZoomFactor;
    property ZoomMode: TdxPreviewZoomMode read GetZoomMode write SetZoomMode default pzmNone;
    property ZoomStep: Integer read GetZoomStep write SetZoomStep default dxPDFViewerZoomStep;
  end;

  { TdxPDFViewerFindPanelInnerTextEdit }

  TdxPDFViewerFindPanelInnerTextEdit = class(TcxCustomInnerTextEdit)
  private
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
  end;

  { TdxPDFViewerFindPanelTextEdit }

  TdxPDFViewerFindPanelTextEdit = class(TcxCustomTextEdit)
  strict private
    FFindPanel: TdxPDFViewerFindPanel;
  protected
    function GetInnerEditClass: TControlClass; override;
    function DoMouseWheel(AShift: TShiftState; AWheelDelta: Integer; AMousePos: TPoint): Boolean; override;
    procedure FocusChanged; override;
  public
    constructor Create(AFindPanel: TdxPDFViewerFindPanel); reintroduce;
  end;

  { TdxPDFViewerCustomObject }

  TdxPDFViewerCustomObject = class
  strict private
    FViewer: TdxPDFCustomViewer;

    function GetScaleFactor: TdxScaleFactor;
    function GetViewInfo: TdxPDFViewerPagesViewInfo;
  protected
    procedure CreateSubClasses; virtual;
    procedure DestroySubClasses; virtual;
    procedure ScaleFactorChanged(Sender: TObject; M, D: Integer; IsLoading: Boolean); virtual;
    property ScaleFactor: TdxScaleFactor read GetScaleFactor;
    property Viewer: TdxPDFCustomViewer read FViewer;
    property ViewInfo: TdxPDFViewerPagesViewInfo read GetViewInfo;
  public
    constructor Create(AViewer: TdxPDFCustomViewer); virtual;
    destructor Destroy; override;
  end;

  { TdxPDFViewerOptionsFindPanel }

  TdxPDFViewerOptionsFindPanel = class(TdxPDFViewerOptionsPersistent)
  strict private
    FAlignment: TdxPDFViewerFindPanelAlignment;
    FAnimation: TdxPDFViewerFindPanelAnimation;
    FAnimationTime: Integer;
    FClearSearchStringOnClose: Boolean;
    FDisplayMode: TdxPDFViewerFindPanelDisplayMode;
    FHighlightSearchResults: Boolean;
    FOptions: TdxPDFDocumentTextSearchOptions;
    FSearchString: string;
    FShowCloseButton: Boolean;
    FShowNextButton: Boolean;
    FShowOptionsButton: Boolean;
    FShowPreviousButton: Boolean;
    //
    function GetCaseSensitive: Boolean;
    function GetDirection: TdxPDFDocumentTextSearchDirection;
    function GetWholeWords: Boolean;
    procedure SetAlignment(const AValue: TdxPDFViewerFindPanelAlignment);
    procedure SetAnimation(const AValue: TdxPDFViewerFindPanelAnimation);
    procedure SetAnimationTime(const AValue: Integer);
    procedure SetCaseSensitive(const AValue: Boolean);
    procedure SetClearSearchStringOnClose(const AValue: Boolean);
    procedure SetDirection(const AValue: TdxPDFDocumentTextSearchDirection);
    procedure SetDisplayMode(const AValue: TdxPDFViewerFindPanelDisplayMode);
    procedure SetHighlightSearchResults(const AValue: Boolean);
    procedure SetSearchString(const AValue: string);
    procedure SetShowCloseButton(const AValue: Boolean);
    procedure SetShowNextButton(const AValue: Boolean);
    procedure SetShowOptionsButton(const AValue: Boolean);
    procedure SetShowPreviousButton(const AValue: Boolean);
    procedure SetWholeWords(const AValue: Boolean);

    procedure ClearTextSearch;
  protected
    procedure Changed(AType: TdxChangeType); override;
    procedure DoAssign(ASource: TPersistent); override;
    procedure Initialize; override;
    //
    property Direction: TdxPDFDocumentTextSearchDirection read GetDirection write SetDirection;
    property ShowCloseButton: Boolean read FShowCloseButton write SetShowCloseButton;
    property ShowNextButton: Boolean read FShowNextButton write SetShowNextButton;
    property ShowOptionsButton: Boolean read FShowOptionsButton write SetShowOptionsButton;
    property ShowPreviousButton: Boolean read FShowPreviousButton write SetShowPreviousButton;
  public
    property CaseSensitive: Boolean read GetCaseSensitive write SetCaseSensitive;
    property HighlightSearchResults: Boolean read FHighlightSearchResults write SetHighlightSearchResults;
    property SearchString: string read FSearchString write SetSearchString;
    property WholeWords: Boolean read GetWholeWords write SetWholeWords;
  published
    property Alignment: TdxPDFViewerFindPanelAlignment read FAlignment write SetAlignment default fpalTopClient;
    property Animation: TdxPDFViewerFindPanelAnimation read FAnimation write SetAnimation default fpaSlide;
    property AnimationTime: Integer read FAnimationTime write SetAnimationTime default dxPDFViewerFindPanelDefaultAnimationTime;
    property ClearSearchStringOnClose: Boolean read FClearSearchStringOnClose write SetClearSearchStringOnClose default False;
    property DisplayMode: TdxPDFViewerFindPanelDisplayMode read FDisplayMode write SetDisplayMode default fpdmManual;
  end;

  { TdxPDFViewerFindPanel }

  TdxPDFViewerFindPanel = class(TdxPDFViewerCustomObject)
  strict private
    FAnimationController: TdxPDFViewerFindPanelAnimationController;
    FController: TdxPDFViewerFindPanelController;
    FEdit: TdxPDFViewerFindPanelTextEdit;
    FHitTest: TdxPDFViewerFindPanelHitTest;
    FLockCount: Integer;
    FOptions: TdxPDFViewerOptionsFindPanel;
    FOptionsButtonGlyph: TdxSmartGlyph;
    FViewInfo: TdxPDFViewerFindPanelViewInfo;
    FVisible: Boolean;
    //
    procedure SetEdit(const AValue: TdxPDFViewerFindPanelTextEdit);
    procedure SetOptions(const AValue: TdxPDFViewerOptionsFindPanel);
    procedure SetVisible(const AValue: Boolean);
    //
    function CreateEdit: TdxPDFViewerFindPanelTextEdit;
    procedure DestroyEdit;
    procedure ForceUpdate;
    procedure InternalSetEdit(const AValue: TdxPDFViewerFindPanelTextEdit);
    //
    procedure EditKeyPressHandler(Sender: TObject; var Key: Char);
    procedure EditKeyDownHandler(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditValueChangedHandler(Sender: TObject);
  protected
    procedure CreateAnimationController; virtual;
    //
    function IsLocked: Boolean;
    procedure BeginUpdate;
    procedure Calculate(AType: TdxChangeType);
    procedure EndUpdate;
    procedure Find;
    procedure HideBeep(var AKey: Char);
    procedure Invalidate;
    procedure SetFocuse;
    procedure SetSearchEditValue(const AValue: string);
    //
    property AnimationController: TdxPDFViewerFindPanelAnimationController read FAnimationController;
    property Controller: TdxPDFViewerFindPanelController read FController;
    property Edit: TdxPDFViewerFindPanelTextEdit read FEdit write SetEdit;
    property HitTest: TdxPDFViewerFindPanelHitTest read FHitTest;
    property Options: TdxPDFViewerOptionsFindPanel read FOptions write SetOptions;
    property OptionsButtonGlyph: TdxSmartGlyph read FOptionsButtonGlyph;
    property Visible: Boolean read FVisible write SetVisible;
    property ViewInfo: TdxPDFViewerFindPanelViewInfo read FViewInfo;
  public
    constructor Create(AViewer: TdxPDFCustomViewer); reintroduce;
    destructor Destroy; override;
  end;

  { TdxPDFViewerPage }

  TdxPDFViewerPage = class(TdxPDFDocumentCustomViewerPage)
  strict private
    function CreatePath(ASelection: TdxPDFTextHighlight; AExcludeTextSelection: Boolean = False): TdxGPPath;
    function GetPainter: TdxPDFViewerPainter;
    function GetSelectionBackColor(AColor: TdxAlphaColor): TdxAlphaColor;
    function GetSelectionFrameColor(AColor: TdxAlphaColor): TdxAlphaColor;
    function GetViewer: TdxPDFCustomViewer;
    procedure DrawBackground(ACanvas: TcxCanvas);
    procedure DrawContent(ACanvas: TcxCanvas);
    procedure DrawHighlights(ACanvas: TcxCanvas);
    procedure DrawImageSelection(ACanvas: TcxCanvas; ASelection: TdxPDFImageSelection);
    procedure DrawSelection(ACanvas: TcxCanvas);
    procedure DrawTextSelection(ACanvas: TcxCanvas; ASelection: TdxPDFTextSelection);
  protected
    function GetVisible: Boolean; override;
    procedure CalculatePageSize; override;
    procedure DrawPath(ACanvas: TcxCanvas; APath: TdxGPPath; AColor, AFrameColor: TdxAlphaColor);

    property Painter: TdxPDFViewerPainter read GetPainter;
    property Viewer: TdxPDFCustomViewer read GetViewer;
  public
    procedure Draw(ACanvas: TcxCanvas); override;
  end;

  { TdxPDFViewerPainter }

  TdxPDFViewerPainterClass = class of TdxPDFViewerPainter;
  TdxPDFViewerPainter = class(TdxPDFViewerCustomObject)
  strict private
    function GetLookAndFeelPainter: TcxCustomLookAndFeelPainter;
    function GetScaleFactor: TdxScaleFactor;
  protected
    function ButtonSymbolColor(AState: TcxButtonState): TColor; virtual;
    function ButtonTextShift: Integer; virtual;
    function FindPanelCloseButtonSize: TSize; virtual;
    function FindPanelOptionsDropDownButtonWidth: Integer; virtual;
    //
    function NavigationPaneButtonContentOffsets: TRect;
    function NavigationPaneButtonOverlay: TPoint;
    function NavigationPaneButtonSize: TSize;
    function NavigationPanePageCaptionContentOffsets: TRect;
    function NavigationPanePageCaptionTextColor: TColor;
    function NavigationPanePageToolbarContentOffsets: TRect;
    //
    function NavigationPaneContentOffsets: TRect;
    function NavigationPanePageContentOffsets: TRect;
    function HighlightBackColor: TdxAlphaColor; virtual;
    function HighlightFrameColor: TdxAlphaColor; virtual;
    function SelectionBackColor: TdxAlphaColor; virtual;
    function SelectionFrameColor: TdxAlphaColor; virtual;
    function TitleTextColor: TColor; virtual;
    procedure DrawButton(ACanvas: TcxCanvas; const ARect: TRect; const ACaption: string; AState: TcxButtonState); virtual;
    procedure DrawButtonBackground(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState); virtual;
    procedure DrawButtonGlyph(ACanvas: TcxCanvas; AImage: TdxSmartGlyph; const ARect: TRect; AState: TcxButtonState); overload;
    procedure DrawButtonGlyph(ACanvas: TcxCanvas; AImage: TdxSmartGlyph; const ARect: TRect; AState: TcxButtonState;
      AColorize: Boolean); overload;
    procedure DrawDropDownButton(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState);
    procedure DrawDropDownButtonGlyph(ACanvas: TcxCanvas; AImage: TdxSmartGlyph; const ARect: TRect;
      AState: TcxButtonState; AColorize: Boolean = True);
    procedure DrawFocusRect(ACanvas: TcxCanvas; const ARect: TRect); virtual;
    procedure DrawFindPanelBackground(ACanvas: TcxCanvas; const ARect: TRect); virtual;
    procedure DrawFindPanelCloseButton(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState); virtual;
    procedure DrawFindPanelOptionsButtonGlyph(ACanvas: TcxCanvas; AImage: TdxSmartGlyph; const ARect: TRect; AState: TcxButtonState); virtual;
    procedure DrawFindPanelOptionsDropDownButton(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState); virtual;
    procedure DrawNavigationPaneBackground(ACanvas: TcxCanvas; const ARect: TRect);
    procedure DrawNavigationPaneButton(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState;
      AMinimized, ASelected, AIsFirst: Boolean);
    procedure DrawNavigationPaneButtonGlyph(ACanvas: TcxCanvas; AImage: TdxSmartGlyph; const ARect: TRect;
      AState: TcxButtonState);
    procedure DrawNavigationPanePageBackground(ACanvas: TcxCanvas; const ARect: TRect);
    procedure DrawNavigationPanePageButton(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState);
    procedure DrawNavigationPanePageCaptionBackground(ACanvas: TcxCanvas; const ARect: TRect);
    procedure DrawNavigationPanePageToolbarBackground(ACanvas: TcxCanvas; const ARect: TRect);
    procedure DrawPageBackground(ACanvas: TcxCanvas; const ABorderRect, AContentRect: TRect; ASelected: Boolean); virtual;
    //
    function IsFadingAvailable: Boolean;
    function IsSkinUsed: Boolean;
    //
  public
    function DropDownButtonWidth: Integer;
    //
    property LookAndFeelPainter: TcxCustomLookAndFeelPainter read GetLookAndFeelPainter;
    property ScaleFactor: TdxScaleFactor read GetScaleFactor;
  end;

  { TdxPDFViewerLockedStatePaintHelper }

  TdxPDFViewerLockedStatePaintHelper = class(TcxLockedStatePaintHelper)
  strict private
    function GetViewer: TdxPDFCustomViewer;
  protected
    function CanCreateLockedImage: Boolean; override;
    function DoPrepareImage: Boolean; override;
    function GetControl: TcxControl; override;
    function GetOptions: TcxLockedStateImageOptions; override;

    property Viewer: TdxPDFCustomViewer read GetViewer;
  end;

  { TdxPDFViewerLockedStateImageOptions }

  TdxPDFViewerLockedStateImageOptions = class(TcxLockedStateImageOptions)
  protected
    function GetFont: TFont; override;
  published
    property AssignedValues;
    property Color;
    property Effect;
    property Font;
    property ShowText;
    property Text;
  end;

  { TdxPDFViewerCustomLayoutCalculator }

  TdxPDFViewerCustomLayoutCalculator = class(TdxCustomPreviewLayoutCalculator)
  strict private
    function GetCurrentPageIndex: Integer;
    function GetCurrentPageRect: TRect;
    function GetViewer: TdxPDFCustomViewer;
    function GetZoomFactorForPageWidthPreviewZoomMode(AFirstPageIndex, ALastPageIndex: Integer): Integer;
  strict protected
    function GetScrollStep: Integer; override;
    procedure InternalCalculatePages; virtual;
    procedure CalculateScrollBarPosition(var ALeftTop: TPoint);
  protected
    function GetContentHeight: Integer; override;
    function GetContentWidth: Integer; override;
    function GetPageSiteBounds(APageIndex: Integer): TRect; override;
    procedure CalculateVisiblePageRange(out AStartIndex, AEndIndex: Integer); override;
    procedure CalculateZoomFactorForPageWidthPreviewZoomMode(AFirstPageIndex, ALastPageIndex: Integer); override;
    procedure CalculateZoomFactorForPagesPreviewZoomMode(AFirstPageIndex, ALastPageIndex: Integer); override;
    procedure CalculatePages; override;

    procedure ScrollContent(const AOffset: TPoint); virtual;
    procedure ZoomContent;

    function GetCurrentPageCenterRect: TRect;
    function GetPageIndexByRect(const ARect: TRect): Integer;
    function GetVisibleSelectedPageIndex: Integer; virtual;

    procedure ActivateCurrentPage;
    procedure ActivateVisiblePage(ACheckZoomLocking: Boolean = True);
    procedure MoveTo(const APoint: TPoint); overload;
    procedure MoveTo(const ARect: TRect); overload;
    procedure SetCurrentPageByRect(const ARect: TRect);

    property CurrentPageIndex: Integer read GetCurrentPageIndex;
    property CurrentPageRect: TRect read GetCurrentPageRect;
    property Viewer: TdxPDFCustomViewer read GetViewer;
  end;

  { TdxPDFViewerDocumentState }

  TdxPDFViewerDocumentState = class(TdxPDFViewerCustomDocumentState)  // for internal use
  strict private type
  {$REGION 'private types'}
    TPageContent = class
    strict private
      FAnnotationList: TdxFastObjectList;
      FContentList: TdxFastObjectList;
      FImageHolderList: TdxPDFImageList;
      FTextLineList: TdxPDFTextLineList;
    public
      class procedure ForEach(APage: TdxPDFPage; AAllowAnnotation, AAllowEdit: Boolean;
        AProc: TdxPDFPageForEachAnnotationProc); static;
      constructor Create(APage: TdxPDFPage; AAllowedObjects: TdxPDFRecognitionObjects; AAllowFieldEdit: Boolean);
      destructor Destroy; override;
      //
      property AnnotationList: TdxFastObjectList read FAnnotationList;
      property ContentList: TdxFastObjectList read FContentList;
      property TextLineList: TdxPDFTextLineList read FTextLineList;
    end;
  {$ENDREGION}
  strict private
    FPageContentCache: TObjectDictionary<Integer, TPageContent>;
    //
    function AllowedRecognitionObjects: TdxPDFRecognitionObjects;
    function GetAnnotationWidgetMap: TDictionary<TObject, TdxPDFCustomWidget>;
    function GetContent(APageIndex: Integer): TdxFastObjectList;
    function GetPageAnnotationList(APageIndex: Integer): TdxFastObjectList;
    function GetPageContent(APageIndex: Integer): TPageContent;
    function GetTextLines(APageIndex: Integer): TdxPDFTextLineList;
    function GetViewer: TdxPDFCustomViewer;
    //
    property PageContent[APageIndex: Integer]: TPageContent read GetPageContent;
  protected
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    //
    function FindLine(const APosition: TdxPDFPagePoint; out ALine: TdxPDFTextLine): Boolean;
    function FindStartTextPosition(const APosition: TdxPDFPagePoint): TdxPDFTextPosition;
    procedure ClearCache;
    //
    property AnnotationWidgetMap: TDictionary<TObject, TdxPDFCustomWidget> read GetAnnotationWidgetMap;
    property Content[APageIndex: Integer]: TdxFastObjectList read GetContent;
    property PageAnnotationList[APageIndex: Integer]: TdxFastObjectList read GetPageAnnotationList;
    property TextLines[APageIndex: Integer]: TdxPDFTextLineList read GetTextLines;
    property Viewer: TdxPDFCustomViewer read GetViewer;
  public
    procedure Update(AChanges: TdxPDFDocumentChanges); override;
  end;

  { TdxPDFViewerDocument }

  TdxPDFViewerDocument = class(TdxPDFViewerCustomDocument) // for internal use
  protected
    function DoCreateDocumentState: TdxPDFDocumentState; override;
  end;

  { TdxPDFCustomViewer }

  TdxPDFCustomViewer = class(TdxPDFDocumentCustomViewer, IdxSkinSupport, IcxLockedStatePaint)
  strict private type
    TChangePageProc = procedure of object;
  strict private
    FActiveController: TdxPDFViewerCustomController;
    FCanMakeVisibleAnimate: Boolean;
    FCaretBitmap: TcxBitmap32;
    FController: TdxPDFViewerController;
    FDocumentArea: TRect;
    FHighlights: TdxPDFViewerHighlights;
    FHitTest: TdxPDFViewerDocumentHitTest;
    FFindPanel: TdxPDFViewerFindPanel;
    FLockedStatePaintHelper: TdxPDFViewerLockedStatePaintHelper;
    FNavigationPane: TdxPDFViewerNavigationPane;
    FPainter: TdxPDFViewerPainter;
    FOutlines: TdxPDFDocumentOutlineList;
    FSelection: TdxPDFViewerSelection;
    // scroll animation
    FStartSelectedPageIndex: Integer;
    FTargetSelectedPageIndex: Integer;
    //
    FIsBoundsChanging: Boolean;
    FScrollingLockCount: Integer;
    FZoomingLockCount: Integer;
    //
    FTextSearch: TdxPDFViewerTextSearch;
    FViewInfo: TdxPDFViewerPagesViewInfo;
    //
    FDialogsLookAndFeel: TcxLookAndFeel;
    FIsDocumentLoading: Boolean;
    FIsDocumentClearing: Boolean;
    FOptionsBehavior: TdxPDFViewerOptionsBehavior;
    FOptionsLockedStateImage: TdxPDFViewerLockedStateImageOptions;
    FOptionsForm: TdxPDFViewerOptionsForm;
    FOptionsSelection: TdxPDFViewerOptionsSelection;
    FOptionsView: TdxPDFViewerOptionsView;
    FOptionsZoom: TdxPDFViewerOptionsZoom;
    FPasswordAttemptsLimit: Integer;
    //
    FOnDocumentLoaded: TdxPDFDocumentLoadedEvent;
    FOnDocumentUnloaded: TNotifyEvent;
    FOnGetPassword: TdxGetPasswordEvent;
    FOnSearchProgress: TdxPDFDocumentTextSearchProgressEvent;
    FOnSelectionChanged: TNotifyEvent;
    //
    FOnAttachmentOpen: TdxPDFViewerOnAttachmentActionEvent;
    FOnAttachmentSave: TdxPDFViewerOnAttachmentActionEvent;
    FOnGetFindPanelVisibility: TdxPDFViewerGetFindPanelVisibilityEvent;
    FOnHideFindPanel: TNotifyEvent;
    FOnHyperlinkClick: TdxPDFViewerOnHyperlinkClickEvent;
    FOnPrepareLockedStateImage: TdxPDFViewerPrepareLockedStateImageEvent;
    FOnShowFindPanel: TNotifyEvent;

    //
    function GetActivePage: TdxPDFViewerPage;
    function GetAttachments: TdxPDFViewerAttachments;
    function GetBookmarks: TdxPDFViewerBookmarks;
    function GetCurrentPageIndex: Integer;
    function GetDocument: TdxPDFDocument;
    //
    function GetDocumentScaleFactor: TdxPointF;
    function GetDocumentState: TdxPDFViewerDocumentState;
    function GetDocumentToViewerFactor: TdxPointF;
    function GetHandTool: Boolean;
    function GetOptionsFindPanel: TdxPDFViewerOptionsFindPanel;
    function GetOptionsNavigationPane: TdxPDFViewerOptionsNavigationPane;
    function GetOnCustomDrawPreRenderPageThumbnail: TdxPDFDocumentViewerOnCustomDrawPreRenderPageEvent;
    function GetOutlines: TdxPDFDocumentOutlineList;
    function GetRotationAngle: TcxRotationAngle;
    function GetSelectionController: TdxPDFViewerSelectionController;
    function GetThumbnails: TdxPDFViewerThumbnails;
    procedure SetCurrentPageIndex(const AValue: Integer);
    procedure SetDialogsLookAndFeel(const AValue: TcxLookAndFeel);
    procedure SetHandTool(const AValue: Boolean);
    procedure SetOnSearchProgress(const AValue: TdxPDFDocumentTextSearchProgressEvent);
    procedure SetOnCustomDrawPreRenderPageThumbnail(const AValue: TdxPDFDocumentViewerOnCustomDrawPreRenderPageEvent);
    procedure SetOptionsBehavior(const AValue: TdxPDFViewerOptionsBehavior);
    procedure SetOptionsFindPanel(const AValue: TdxPDFViewerOptionsFindPanel);
    procedure SetOptionsForm(const AValue: TdxPDFViewerOptionsForm);
    procedure SetOptionsLockedStateImage(AValue: TdxPDFViewerLockedStateImageOptions);
    procedure SetOptionsNavigationPane(const AValue: TdxPDFViewerOptionsNavigationPane);
    procedure SetOptionsSelection(const AValue: TdxPDFViewerOptionsSelection);
    procedure SetOptionsView(const AValue: TdxPDFViewerOptionsView);
    procedure SetOptionsZoom(const AValue: TdxPDFViewerOptionsZoom);
    procedure SetRotationAngle(const AValue: TcxRotationAngle);
    //
    function ControllerFromPoint(const P: TPoint; var AController: TdxPDFViewerCustomController): Boolean; overload;
    function ControllerFromPoint(X, Y: Integer; var AController: TdxPDFViewerCustomController): Boolean; overload;
    procedure AfterLoadDocument;
    procedure BeforeLoadDocument;
    procedure DestroyOutlines;
    procedure DoSetSelPageIndex(AValue: Integer; AIsEventFired: Boolean);
    procedure ChangePage(AProc: TChangePageProc);
    procedure CreateDocument;
    procedure LoadDocumentPages;
    procedure ResetScrollAnimationPageRange;
    procedure ScrollToDocumentFooter;
    // IcxLockedStatePaint
    function IcxLockedStatePaint.GetImage = GetLockedStateImage;
    function IcxLockedStatePaint.GetTopmostControl = GetLockedStateTopmostControl;
    function GetLockedStateImage: TcxBitmap32;
    function GetLockedStateTopmostControl: TcxControl;
    //
    function OnGetPasswordHandler(Sender: TObject; {$IFDEF BCBCOMPATIBLE}var{$ELSE}out{$ENDIF} APassword: string): Boolean;
    procedure OnDocumentLoadedHandler(Sender: TdxPDFDocument; const AInfo: TdxPDFDocumentLoadInfo);
    procedure OnDocumentUnLoadedHandler(Sender: TObject);
    procedure OnHighlightsChangedHandler(Sender: TObject);
    procedure OnSelectionChangedHandler(Sender: TObject);
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMMouseActivate(var Message: TWMMouseActivate); Message WM_MOUSEACTIVATE;
  strict protected
    procedure DocumentAttachmentsChanged; override;
    procedure DocumentBookmarksChanged; override;
    procedure DocumentInteractiveLayerChanged; override;
    procedure DocumentLayoutChanged; override;
  protected
    function CanMakeVisibleAnimate: Boolean; override;
    function CanUpdateRenderQueue: Boolean; override;
    function GetCurrentCursor(X, Y: Integer): TCursor; override;
    function GetHitInfoAt(const P: TPoint): TdxPreviewHitTests; override;
    function GetPageRenderFactor(APageIndex: Integer): Single; override;
    procedure BeforeClearDocument; override;
    procedure BoundsChanged; override;
    procedure ClearSelection; override;
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure DoCalculate(AType: TdxChangeType); override;
    procedure Initialize; override;
    procedure FocusChanged; override;
    procedure HideAllHints; override;
    //
    function CanProcessScrollEvents(var Message: TMessage): Boolean; override;
    function CreateLayoutCalculator: TdxCustomPreviewLayoutCalculator; override;
    function CreatePage: TdxPreviewPage; override;
    function DoMouseWheel(AShift: TShiftState; AWheelDelta: Integer; AMousePos: TPoint): Boolean; override;
    function GetClientBounds: TRect; override;
    function GetDefaultHeight: Integer; override;
    function GetDefaultMaxZoomFactor: Integer; override;
    function GetDefaultMinZoomFactor: Integer; override;
    function GetDefaultZoomFactor: Integer; override;
    function GetDefaultZoomStep: Integer; override;
    function GetDefaultWidth: Integer; override;
    function GetDragAndDropObjectClass: TcxDragAndDropObjectClass; override;
    function GetPageClass: TdxPreviewPageClass; override;
    function GetPageSizeOptionsClass: TdxPreviewPageSizeOptionsClass; override;
    function StartDragAndDrop(const P: TPoint): Boolean; override;
    procedure CalculatePageNumberHintText(AStartPage, AEndPage: Integer; var AText: string); override;
    procedure ChangeScaleEx(M, D: Integer; isDpiChange: Boolean); override;
    procedure DoContextPopup(MousePos: TPoint; var Handled: Boolean); override;
    procedure DoSelectedPageChanged; override;
    procedure SetZoomFactor(Value: Integer); override;
    procedure DoZoomFactorChanged; override;
    procedure DoZoomModeChanged; override;
    procedure DoPaint; override;
    procedure DrawContent(ACanvas: TcxCanvas; const R: TRect); override;
    procedure DrawNoPages(ACanvas: TcxCanvas); override;
    procedure DrawPageBackground(ACanvas: TcxCanvas; APage: TdxPreviewPage; ASelected: Boolean); override;
    procedure DrawScrollBars(ACanvas: TcxCustomCanvas); override;
    procedure InternalGoToFirstPage; override;
    procedure InternalGoToLastPage; override;
    procedure InternalGoToNextPage; override;
    procedure InternalGoToPrevPage; override;
    procedure FontChanged; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure LayoutChanged(AType: TdxChangeType = ctHard); override;
    procedure MakePageVisible(APageIndex: Integer; AAnimated: Boolean); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseEnter(AControl: TControl); override;
    procedure MouseLeave(AControl: TControl); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure ProcessLeftClickByPage(Shift: TShiftState; X, Y: Integer); override;
    procedure SetPaintRegion; override;
    procedure SetSelPageIndex(Value: Integer); override;
    procedure Scroll(AScrollBarKind: TScrollBarKind; AScrollCode: TScrollCode; var AScrollPos: Integer); override;
    procedure ScrollPosChanged(const AOffset: TPoint); override;
    procedure SelectFirstPage; override;
    procedure SelectLastPage; override;
    procedure SelectNextPage; override;
    procedure SelectPrevPage; override;
    procedure UpdateLeftTopPosition(const ATopLeft: TPoint; AAnimated: Boolean = False);
    //
    function CanOpenAttachment(AAttachment: TdxPDFFileAttachment): Boolean; virtual;
    function CanOpenUri(const AUri: string): Boolean; virtual;
    function CanSaveAttachment(AAttachment: TdxPDFFileAttachment): Boolean; virtual;
    function DoCreateDocument: TdxPDFDocument; virtual;
    function DoGetPassword(var APassword: string): Boolean; virtual;
    function DoPrepareLockedStateImage: Boolean; virtual;
    //
    function CreateLockedStatePaintHelper: TdxPDFViewerLockedStatePaintHelper; virtual;
    function CreateOptionsLockedStateImage: TdxPDFViewerLockedStateImageOptions; virtual;
    function GetControllerClass: TdxPDFViewerControllerClass; virtual;
    function GetPainterClass: TdxPDFViewerPainterClass; virtual;
    //
    function CanChangeVisibility: Boolean;
    function CanHighlightCurrentPage(AIsPageActive: Boolean): Boolean;
    function CanShowFindPanel: Boolean; virtual;
    function CanHideFindPanel: Boolean; virtual;
    procedure SetFindPanelFocus; virtual;
    //
    function IsZoomingLocked: Boolean;
    procedure BeginBoundsChange;
    procedure BeginScrolling;
    procedure BeginZooming;
    procedure EndBoundsChange;
    procedure EndScrolling;
    procedure EndZooming;
    //
    function CanExtractContent: Boolean;
    function CanDrawCaret: Boolean;
    function CanPrint: Boolean;
    function CanUseAnimation: Boolean;
    function CanZoomIn: Boolean;
    function CanZoomOut: Boolean;
    function CreatePainter: TdxPDFViewerPainter;
    function IsDocumentAvailable: Boolean; inline;
    function IsDocumentLoading: Boolean; inline;
    function IsDocumentPanning: Boolean; inline;
    function IsDocumentSelecting: Boolean; inline;
    function GetLayoutCalculator: TdxPDFViewerCustomLayoutCalculator;
    function GetTargetSelectedPageIndex: Integer;
    procedure DeleteCaret;
    procedure DoSetFocus;
    procedure DrawCaret; overload;
    procedure DrawCaret(const P, ASize: TPoint); overload;
    procedure LockHistoryAndExecute(AProc: TProc);
    procedure MakeVisibleWithoutAnimation(APageIndex: Integer);
    procedure FindNext;
    procedure SetScrollPosition(const APosition: TPoint; AAnimated: Boolean = False);
    procedure RecreatePages;
    procedure UpdateActiveController(const P: TPoint);
    procedure UpdateCursor;
    //
    procedure AfterHorzScrollAnimationEnded; override;
    procedure AfterVertScrollAnimationEnded; override;
    procedure BeforeVertScrollAnimationStarted; override;
    procedure DoSelectPage(APageIndex: Integer); override;
    procedure InternalSetCurrentPage(AValue: Integer; AAnimated: Boolean);
    procedure StopVertScrollAnimation; override;
    //
    procedure OpenAttachment(AAttachment: TdxPDFFileAttachment);
    procedure SaveAttachment(AAttachment: TdxPDFFileAttachment);
    //
    property ActiveController: TdxPDFViewerCustomController read FActiveController write FActiveController;
    property ActivePage: TdxPDFViewerPage read GetActivePage;
    property Attachments: TdxPDFViewerAttachments read GetAttachments;
    property Bookmarks: TdxPDFViewerBookmarks read GetBookmarks;
    property DialogsLookAndFeel: TcxLookAndFeel read FDialogsLookAndFeel write SetDialogsLookAndFeel;
    property DocumentScaleFactor: TdxPointF read GetDocumentScaleFactor;
    property DocumentState: TdxPDFViewerDocumentState read GetDocumentState;
    property DocumentToViewerFactor: TdxPointF read GetDocumentToViewerFactor;
    property FindPanel: TdxPDFViewerFindPanel read FFindPanel;
    property LayoutCalculator: TdxPDFViewerCustomLayoutCalculator read GetLayoutCalculator;
    property LockedStatePaintHelper: TdxPDFViewerLockedStatePaintHelper read FLockedStatePaintHelper;
    property NavigationPane: TdxPDFViewerNavigationPane read FNavigationPane;
    property OptionsBehavior: TdxPDFViewerOptionsBehavior read FOptionsBehavior write SetOptionsBehavior;
    property OptionsFindPanel: TdxPDFViewerOptionsFindPanel read GetOptionsFindPanel write SetOptionsFindPanel;
    property OptionsForm: TdxPDFViewerOptionsForm read FOptionsForm write SetOptionsForm;
    property OptionsLockedStateImage: TdxPDFViewerLockedStateImageOptions read FOptionsLockedStateImage write SetOptionsLockedStateImage;
    property OptionsNavigationPane: TdxPDFViewerOptionsNavigationPane read GetOptionsNavigationPane write SetOptionsNavigationPane;
    property OptionsSelection: TdxPDFViewerOptionsSelection read FOptionsSelection write SetOptionsSelection;
    property OptionsView: TdxPDFViewerOptionsView read FOptionsView write SetOptionsView;
    property OptionsZoom: TdxPDFViewerOptionsZoom read FOptionsZoom write SetOptionsZoom;
    property Outlines: TdxPDFDocumentOutlineList read GetOutlines;
    property Painter: TdxPDFViewerPainter read FPainter;
    property SelectionController: TdxPDFViewerSelectionController read GetSelectionController;
    property Thumbnails: TdxPDFViewerThumbnails read GetThumbnails;
    property ViewInfo: TdxPDFViewerPagesViewInfo read FViewInfo;
    property ViewerController: TdxPDFViewerController read FController;
    //
    property OnAttachmentOpen: TdxPDFViewerOnAttachmentActionEvent read FOnAttachmentOpen write FOnAttachmentOpen;
    property OnAttachmentSave: TdxPDFViewerOnAttachmentActionEvent read FOnAttachmentSave write FOnAttachmentSave;
    property OnDocumentLoaded: TdxPDFDocumentLoadedEvent read FOnDocumentLoaded write FOnDocumentLoaded;
    property OnDocumentUnloaded: TNotifyEvent read FOnDocumentUnloaded write FOnDocumentUnloaded;
    property OnGetFindPanelVisibility: TdxPDFViewerGetFindPanelVisibilityEvent read FOnGetFindPanelVisibility
      write FOnGetFindPanelVisibility;
    property OnGetPassword: TdxGetPasswordEvent read FOnGetPassword write FOnGetPassword;
    property OnHideFindPanel: TNotifyEvent read FOnHideFindPanel write FOnHideFindPanel;
    property OnHyperlinkClick: TdxPDFViewerOnHyperlinkClickEvent  read FOnHyperlinkClick write FOnHyperlinkClick;
    property OnPrepareLockedStateImage: TdxPDFViewerPrepareLockedStateImageEvent read FOnPrepareLockedStateImage
      write FOnPrepareLockedStateImage;
    property OnCustomDrawPreRenderPageThumbnail: TdxPDFDocumentViewerOnCustomDrawPreRenderPageEvent
      read GetOnCustomDrawPreRenderPageThumbnail write SetOnCustomDrawPreRenderPageThumbnail;
    property OnSearchProgress: TdxPDFDocumentTextSearchProgressEvent read FOnSearchProgress write SetOnSearchProgress;
    property OnSelectionChanged: TNotifyEvent read FOnSelectionChanged write FOnSelectionChanged;
    property OnShowFindPanel: TNotifyEvent read FOnShowFindPanel write FOnShowFindPanel;
  public
    function CanGoToNextView: Boolean;
    function CanGoToPrevView: Boolean;
    function IsDocumentLoaded: Boolean;
    procedure Clear; override; 
    procedure ClearViewStateHistory;
    procedure GoToNextView;
    procedure GoToPrevView;
    procedure LoadFromFile(const AFileName: string);
    procedure LoadFromStream(AStream: TStream);
    procedure RotateClockwise;
    procedure RotateCounterclockwise;
    //
    function IsFindPanelVisible: Boolean;
    procedure HideFindPanel;
    procedure ShowFindPanel;
    //
    property CurrentPageIndex: Integer read GetCurrentPageIndex write SetCurrentPageIndex;
    property Document: TdxPDFDocument read GetDocument;
    property HandTool: Boolean read GetHandTool write SetHandTool;
    property Highlights: TdxPDFViewerHighlights read FHighlights;
    property HitTest: TdxPDFViewerDocumentHitTest read FHitTest;
    property PasswordAttemptsLimit: Integer read FPasswordAttemptsLimit write FPasswordAttemptsLimit;
    property RotationAngle: TcxRotationAngle read GetRotationAngle write SetRotationAngle;
    property Selection: TdxPDFViewerSelection read FSelection;
    property TextSearch: TdxPDFViewerTextSearch read FTextSearch;
  end;
  { TdxPDFViewer }

  TdxPDFViewer = class(TdxPDFCustomViewer)
  published
    property Align;
    property Anchors;
    property BorderStyle default cxcbsDefault;
    property Constraints;
    property Font;
    property LookAndFeel;
    property ParentColor default False;
    property ParentFont;
    property PopupMenu;
    property Transparent;
    property Visible;

    property DialogsLookAndFeel;
    property OptionsBehavior;
    property OptionsFindPanel;
    property OptionsForm;
    property OptionsLockedStateImage;
    property OptionsNavigationPane;
    property OptionsSelection;
    property OptionsView;
    property OptionsZoom;

    property OnClick;
    property OnContextPopup;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;

    property OnAttachmentOpen;
    property OnAttachmentSave;
    property OnCustomDrawPreRenderPage;
    property OnCustomDrawPreRenderPageThumbnail;
    property OnDocumentLoaded;
    property OnDocumentUnloaded;
    property OnGetPassword;
    property OnHideFindPanel;
    property OnHyperlinkClick;
    property OnPrepareLockedStateImage;
    property OnShowFindPanel;
    property OnSearchProgress;
    property OnSelectedPageChanged;
    property OnSelectionChanged;
    property OnZoomFactorChanged;
  end;

  { TdxPDFViewerSelection }

  TdxPDFViewerSelection = class
  strict private
    FController: TdxPDFViewerSelectionController;
    function GetSelection: TdxPDFCustomSelection;
    procedure SetSelection(const AValue: TdxPDFCustomSelection);
    procedure MakeVisible(AMake: Boolean);
  protected
    function IsImageSelection: Boolean;
    function IsTextSelection: Boolean;

    property Selection: TdxPDFCustomSelection read GetSelection write SetSelection;
  public
    constructor Create(AViewer: TdxPDFCustomViewer);

    function AsBitmap: TBitmap;
    function AsText: string;
    function IsEmpty: Boolean;
    procedure Clear;
    procedure CopyToClipboard;
    procedure Select(const ARect: TRect; AMakeVisible: Boolean = False); overload;
    procedure SelectText(const ARange: TdxPDFPageTextRange; AMakeVisible: Boolean = True); overload;
    procedure SelectAll;
  end;

  { TdxPDFViewerTextSearch }

  TdxPDFViewerTextSearch = class(TdxPDFViewerCustomObject)
  strict private
    FLockCount: Integer;
    FOptions: TdxPDFDocumentTextSearchOptions;
    FSearchString: string;

    FAdvancedTextSearch: TdxPDFDocumentContinuousTextSearch;
    FTextSearch: TdxPDFDocumentSequentialTextSearch;

    function GetDocumentTextSearch: TdxPDFDocumentSequentialTextSearch;
    function GetSelection: TdxPDFViewerSelection;
    function GetSearchCompleteMessage: string;
    function GetSearchNoMatchesFoundMessage: string;

    function DoFind: TdxPDFDocumentTextSearchResult;
    procedure AdvancedSearchCompleteHandler(Sender: TObject);

    property DocumentTextSearch: TdxPDFDocumentSequentialTextSearch read GetDocumentTextSearch;
    property Selection: TdxPDFViewerSelection read GetSelection;
  protected
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;

    function InternalFind: TdxPDFDocumentTextSearchResult;
    function IsLocked: Boolean;
    procedure BeginUpdate;
    procedure Clear;
    procedure EndUpdate;
  public
    function Find(const AText: string): TdxPDFDocumentTextSearchResult; overload;
    function Find(const AText: string; const AOptions: TdxPDFDocumentTextSearchOptions): TdxPDFDocumentTextSearchResult; overload;
    procedure Find(const AText: string; const AOptions: TdxPDFDocumentTextSearchOptions;
      var AFoundRanges: TdxPDFPageTextRanges); overload;
  end;

  { TdxPDFViewerHighlights }

  TdxPDFViewerHighlights = class
  strict private
    FController: TdxPDFViewerSelectionController;
    FItems: TdxFastObjectList;
    FVisible: TdxDefaultBoolean;

    FOnChanged: TNotifyEvent;

    procedure SetVisible(const AValue: TdxDefaultBoolean);

    procedure Changed;
    procedure InternalAdd(AValue: TdxPDFTextHighlight);
  protected
    property Items: TdxFastObjectList read FItems;
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
  public
    constructor Create(AViewer: TdxPDFCustomViewer);
    destructor Destroy; override;

    procedure Add(const ARange: TdxPDFPageTextRange; ABackColor, AFrameColor: TdxAlphaColor); overload;
    procedure Add(const ARanges: TdxPDFPageTextRanges; ABackColor, AFrameColor: TdxAlphaColor); overload;
    procedure Remove(const ARange: TdxPDFPageTextRange);
    procedure Clear;

    property Visible: TdxDefaultBoolean read FVisible write SetVisible;
  end;

  { TdxPDFViewerCustomHitTest }

  TdxPDFViewerCustomHitTest = class(TdxPDFViewerCustomObject)
  strict protected
    FHitPoint: TPoint;
  protected
    procedure DestroySubClasses; override;

    function CanCalculate: Boolean; virtual;
    function GetPopupMenuClass: TComponentClass; virtual;
    procedure Clear; virtual;
    procedure DoCalculate(const AHitPoint: TPoint); virtual;

    procedure Calculate(const AHitPoint: TPoint);
  public
    property HitPoint: TPoint read FHitPoint;
    property Viewer;
  end;

  { TdxPDFViewerCellHitTest }

  TdxPDFViewerCellHitTest = class(TdxPDFViewerCustomHitTest)
  strict private
    FHitCode: Int64;
    FHitObject: TdxPDFViewerCellViewInfo;
    //
    function GetCursor: TCursor;
  protected
    procedure Clear; override;
    procedure DoCalculate(const AHitPoint: TPoint); override;
    //
    function DoGetCursor: TCursor; virtual;
    //
    function GetHitCode(ACode: Integer): Boolean; inline;
    procedure SetHitCode(ACode: Integer; AValue: Boolean); inline;
    //
    property Cursor: TCursor read GetCursor;
    property HitCodes[ACode: Integer]: Boolean read GetHitCode write SetHitCode;
    property HitObject: TdxPDFViewerCellViewInfo read FHitObject write FHitObject;
  end;

  { TdxPDFViewerDocumentHitTest }

  TdxPDFViewerHitTest = class(TdxPDFViewerCellHitTest);
  TdxPDFViewerDocumentHitTest = class(TdxPDFViewerHitTest)
  strict private
    FHitContentObject: TObject;
    FPosition: TdxPDFPagePoint;
    //
    function GetHitAtDocumentViewer: Boolean;
    function GetHitAtSelection: Boolean;
    function GetPage: TdxPDFViewerPage;
    function GetNearestPage: TdxPDFViewerPage;
  protected
    function CanCalculate: Boolean; override;
    function DoGetCursor: TCursor; override;
    function GetPopupMenuClass: TComponentClass; override;
    procedure Clear; override;
    procedure DoCalculate(const AHitPoint: TPoint); override;
    //
    function CanShowHint: Boolean;
    function GetAttachment: TdxPDFFileAttachment;
    function GetHintBounds: TRect;
    function GetHintText: string;
    function HitAtHintableObject: Boolean; overload;
    function HitAtHintableObject(out AObject: IdxPDFHintableObject): Boolean; overload;
    function HitAtInteractiveObject: Boolean; overload;
    function HitAtInteractiveObject(out AObject: IdxPDFInteractiveObject): Boolean; overload;
    //
    property HitAtDocumentViewer: Boolean read GetHitAtDocumentViewer;
    property HitAtFindPanel: Boolean index hcFindPanel read GetHitCode;
    property Position: TdxPDFPagePoint read FPosition;
  public
    property Cursor;
    property HitAtAttachment: Boolean index hcAttachment read GetHitCode;
    property HitAtBackground: Boolean index hcBackground read GetHitCode;
    property HitAtImage: Boolean index hcImage read GetHitCode;
    property HitAtHyperlink: Boolean index hcHyperlink read GetHitCode;
    property HitAtText: Boolean index hcText read GetHitCode;
    property HitAtSelection: Boolean index hcSelectionFrame read GetHitCode;
    property HitAtPage: Boolean index hcPageArea read GetHitCode;
  end;

  { TdxPDFViewerNavigationPaneHitTest }

  TdxPDFViewerNavigationPaneHitTest = class(TdxPDFViewerCellHitTest)
  protected
    function DoGetCursor: TCursor; override;
    procedure DoCalculate(const AHitPoint: TPoint); override;
    //
    property HitAtSplitter: Boolean index hcNavigationPaneSplitter read GetHitCode;
  end;

  { TdxPDFViewerCustomController }

  TdxPDFViewerCustomController = class(TdxPDFViewerCustomObject)
  strict private
    FPopupMenu: TComponent;
  strict protected
    FLeftMouseButtonPressed: Boolean;
  protected
    function DoKeyDown(AKey: Word; AShift: TShiftState): Boolean; virtual;
    function DoMouseWheel(AShift: TShiftState; AWheelDelta: Integer; const AMousePos: TPoint): Boolean; virtual;
    function GetCursor: TCursor; virtual;
    function GetPopupMenuClass: TComponentClass; virtual;
    function IsAvailable: Boolean; virtual;
    procedure CalculateHitTest(X, Y: Integer); virtual;
    procedure CalculateMouseButtonPressed(Shift: TShiftState; X, Y: Integer); virtual;
    procedure DoMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure DoMouseEnter(AControl: TControl); virtual;
    procedure DoMouseLeave(AControl: TControl); virtual;
    procedure DoMouseMove(Shift: TShiftState; X, Y: Integer); virtual;
    procedure DoMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure UpdateState; virtual;
    //
    function ContextPopup(const P: TPoint): Boolean; overload;
    function ContextPopup(const P: TPoint; APopupMenuClass: TComponentClass): Boolean; overload;
    function KeyDown(var AKey: Word; AShift: TShiftState): Boolean;
    function MouseWheel(Shift: TShiftState; WheelDelta: Integer; const MousePos: TPoint): Boolean;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MouseEnter(AControl: TControl; X, Y: Integer);
    procedure MouseLeave(AControl: TControl; X, Y: Integer);
    procedure MouseMove(Shift: TShiftState; X, Y: Integer);
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ResetLeftMouseButtonPressed;
    //
    property Cursor: TCursor read GetCursor;
    property LeftMouseButtonPressed: Boolean read FLeftMouseButtonPressed;
    property PopupMenu: TComponent read FPopupMenu;
  end;

  { TdxPDFViewerViewState }

  TdxPDFViewerViewState = class
  strict private
    FChangeType: TdxPDFViewerViewStateChangeType;
    FCurrentPageIndex: Integer;
    FRotationAngle: TcxRotationAngle;
    FScrollPosition: TPoint;
    FTimeStamp: TTimeStamp;
    FZoomFactor: Integer;
    FZoomMode: TdxPreviewZoomMode;
  protected
    function CalculatePageSize(APage: TdxPDFPage): TdxPointF; overload;
    function IsSame(AView: TdxPDFViewerViewState): Boolean;

    property ChangeType: TdxPDFViewerViewStateChangeType read FChangeType;
    property CurrentPageIndex: Integer read FCurrentPageIndex write FCurrentPageIndex;
    property RotationAngle: TcxRotationAngle read FRotationAngle write FRotationAngle;
    property ScrollPosition: TPoint read FScrollPosition write FScrollPosition;
    property TimeStamp: TTimeStamp read FTimeStamp;
    property ZoomFactor: Integer read FZoomFactor write FZoomFactor;
    property ZoomMode: TdxPreviewZoomMode read FZoomMode write FZoomMode;
  public
    constructor Create(AChangeType: TdxPDFViewerViewStateChangeType);
    class function CalculatePageSize(const ASize: TdxPointF; ARotationAngle: TcxRotationAngle): TdxPointF; overload;
  end;

  { TdxPDFViewerViewStateHistory }

  TdxPDFViewerViewStateHistory = class
  strict private
    FCurrentViewStateIndex: Integer;
    FLockCount: Integer;
    FViewStateList: TObjectList<TdxPDFViewerViewState>;

    function GetCurrentViewState: TdxPDFViewerViewState;
    function GetCount: Integer;
    function SameView(AView, ACurrentView: TdxPDFViewerViewState): Boolean;
  protected
    function CanGoToNextView: Boolean;
    function CanGoToPreviousView: Boolean;
    procedure BeginUpdate;
    procedure Clear;
    procedure EndUpdate;
    procedure GoToNextView;
    procedure GoToPrevView;
    procedure Initialize(AView: TdxPDFViewerViewState);
    function IsLocked: Boolean;
    procedure StoreViewState(AView: TdxPDFViewerViewState);

    property Count: Integer read GetCount;
    property CurrentViewState: TdxPDFViewerViewState read GetCurrentViewState;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  { TdxPDFViewerViewStateHistoryController }

  TdxPDFViewerViewStateHistoryController = class(TdxPDFViewerCustomController)
  strict private
    FHistory: TdxPDFViewerViewStateHistory;

    function CreateView(AChangeType: TdxPDFViewerViewStateChangeType): TdxPDFViewerViewState;
    function GetCurrentViewState: TdxPDFViewerViewState;
    procedure RecreateHistory;
  protected
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;

    function CanGoToNextView: Boolean;
    function CanGoToPreviousView: Boolean;
    procedure BeginUpdate;
    procedure Clear;
    procedure EndUpdate;
    procedure GoToNextView;
    procedure GoToPrevView;
    procedure StoreCurrentViewState(AChangeType: TdxPDFViewerViewStateChangeType);
    procedure RestoreViewState;

    property CurrentViewState: TdxPDFViewerViewState read GetCurrentViewState;
    property History: TdxPDFViewerViewStateHistory read FHistory;
  end;

  { TdxPDFViewerContentSelector }

  TdxPDFViewerContentSelector = class
  strict private
    FInProgress: Boolean;
    FViewer: TdxPDFCustomViewer;
    function GetHitTest: TdxPDFViewerDocumentHitTest;
    function GetSelection: TdxPDFCustomSelection;
    function GetSelectionBackColor: TdxAlphaColor;
    function GetSelectionFrameColor: TdxAlphaColor;
    procedure SetSelection(const AValue: TdxPDFCustomSelection);
  protected
    procedure Clear; virtual;
    procedure Reset; virtual;

    property InProgress: Boolean read FInProgress write FInProgress;
    property HitTest: TdxPDFViewerDocumentHitTest read GetHitTest;
    property Selection: TdxPDFCustomSelection read GetSelection write SetSelection;
    property SelectionBackColor: TdxAlphaColor read GetSelectionBackColor;
    property SelectionFrameColor: TdxAlphaColor read GetSelectionFrameColor;
    property Viewer: TdxPDFCustomViewer read FViewer;
  public
    constructor Create(AViewer: TdxPDFCustomViewer); virtual;
  end;

  { TdxPDFViewerImageSelector }

  TdxPDFViewerImageSelector = class(TdxPDFViewerContentSelector)
  strict private
    FImageBounds: TdxPDFPageRect;
    FImageID: string;
    FIsSelected: Boolean;
    FStartPosition: TdxPDFPagePoint;
    //
    function CreateImageSelection(const ABounds: TdxRectF): TdxPDFImageSelection;
  protected
    procedure Clear; override;
    procedure Reset; override;
    //
    function Select: Boolean;
    procedure StartSelection(var AInOutsideContent: Boolean);
  end;

  { TdxPDFViewerTextSelector }

  TdxPDFViewerTextSelector = class(TdxPDFViewerContentSelector)
  strict private type
    TdxPDFMovingCaretProc = procedure of object;
  strict private
    FStartPageIndex: Integer;
    FStartPoint: TdxPointF;
    FStartTextPosition: TdxPDFTextPosition;

    function GetCaret: TdxPDFDocumentCaret;
    function GetPage(AIndex: Integer): TdxPDFPage;
    function GetScaleFactor: TdxPointF;
    function GetTextLines(APageIndex: Integer): TdxPDFTextLineList;
    procedure SetCaret(const AValue: TdxPDFDocumentCaret);

    function CreateRangeList(const AStart, AEnd: TdxPDFTextPosition): TdxPDFPageTextRanges; overload;
    function CreateRangeList(const AStart: TdxPDFTextPosition; const AEnd: TdxPDFPagePoint): TdxPDFPageTextRanges; overload;
    function HasCaret: Boolean;
    function IsArrowKeys(ADirection: TdxPDFMovementDirection): Boolean;
    function IsEmptySelection: Boolean;
    function IsPositionInLine(APageIndex, ALineIndex, AWordIndex, AOffset: Integer): Boolean;
    function FindLine(const APosition: TdxPDFTextPosition; out ALine: TdxPDFTextLine): Boolean;
    function FindNearestLineByDistance(const APosition: TdxPDFPagePoint): TdxPDFTextLine;
    function FindNearestPosition(const APosition: TdxPDFPagePoint; const ATextPosition: TdxPDFTextPosition): TdxPDFTextPosition;
    function FindStartTextPosition(const APosition: TdxPDFPagePoint): TdxPDFTextPosition;
    function FindWordEndPosition(APosition: TdxPDFTextPosition): Integer;
    function MoveCaretToLeft: Boolean;
    function MoveCaretToRight: Boolean;
    function MoveRight(AWordParts: TdxPDFTextWordPartList; APageIndex, ALineIndex, AWordIndex, AOffset: Integer;
      AProcessLastWordPart: Boolean): Boolean; overload;
    function NormalizeDirection(ADirection: TdxPDFMovementDirection): TdxPDFMovementDirection;
    function SameNextWordPartIndex(APageIndex, ALineIndex, AWordIndex: Integer): Boolean;
    function ValidateRanges(const ARanges: TdxPDFPageTextRanges): Boolean;
    procedure DoMoveCaret(AProc: TdxPDFMovingCaretProc);
    procedure MakeCaretVisible;
    procedure MoveAndMakeCaretVisible(const APosition: TdxPDFTextPosition);
    procedure MoveDown;
    procedure MoveLeft;
    procedure MoveRight; overload;
    procedure MoveToDocumentEnd;
    procedure MoveToDocumentStart;
    procedure MoveToLineStart;
    procedure MoveToLineEnd;
    procedure MoveToNextWord;
    procedure MoveToPreviousWord;
    procedure MoveUp;
    procedure Select(APage: TdxPDFPage; AProc: TProc); overload;
    procedure SetCaretPosition(const APosition: TdxPDFTextPosition);
    procedure StoreSelectionStartTextPosition;
    procedure UpdateSelection(const APosition: TdxPDFTextPosition);
  protected
    function CreateTextHighlights(const ARanges: TdxPDFPageTextRanges;
      ABackColor, AFrameColor: TdxAlphaColor): TdxPDFTextHighlight;
    function CreateTextSelection(const ARange: TdxPDFPageTextRange): TdxPDFTextSelection; overload;
    function CreateTextSelection(const ARanges: TdxPDFPageTextRanges): TdxPDFTextSelection; overload;
    function GetCaretViewData(const APosition: TdxPDFTextPosition): TdxPDFDocumentCaretViewData;
    function StartSelection(const APosition: TdxPDFPagePoint): Boolean;
    procedure MoveCaret(const APosition: TdxPDFTextPosition); overload;
    procedure MoveCaret(ADirection: TdxPDFMovementDirection); overload;
    procedure Select(const APosition: TdxPDFPagePoint); overload;
    procedure SelectByKeyboard(ADirection: TdxPDFMovementDirection);
    procedure SelectLine(const APosition: TdxPDFPagePoint);
    procedure SelectPage(const APosition: TdxPDFPagePoint);
    procedure SelectWord(const APosition: TdxPDFPagePoint);

    property Caret: TdxPDFDocumentCaret read GetCaret write SetCaret;
    property Page[AIndex: Integer]: TdxPDFPage read GetPage;
    property TextLines[APageIndex: Integer]: TdxPDFTextLineList read GetTextLines;
    property ScaleFactor: TdxPointF read GetScaleFactor;
  end;

  { TdxPDFViewerSelectionController }

  TdxPDFViewerSelectionController = class(TdxPDFViewerCustomObject)
  strict private type
    TMakeRectVisibleEvent = procedure(APageIndex: Integer; const ARect: TdxRectF) of object;
  strict private
    FCaret: TdxPDFDocumentCaret;
    FClickController: TdxPDFViewerClickController;
    FImageSelector: TdxPDFViewerImageSelector;
    FInOutsideContent: Boolean;
    FSelection: TdxPDFCustomSelection;
    FStartSelectionPosition: TdxPDFPagePoint;
    FTextSelector: TdxPDFViewerTextSelector;

    FOnMakeRectVisible: TMakeRectVisibleEvent;
    FOnSelectionChanged: TNotifyEvent;

    function GetHitTest: TdxPDFViewerDocumentHitTest;
    function GetImages(APageIndex: Integer): TdxPDFImageList;
    function GetScaleFactor: TdxPointF;
    function GetTextLines(APageIndex: Integer): TdxPDFTextLineList;
    procedure SetCaret(const AValue: TdxPDFDocumentCaret);
    procedure SetSelection(const AValue: TdxPDFCustomSelection);

    function CanExtractSelectedContent(AHitCode: Int64): Boolean;
    function IsEmptySelection: Boolean;
    function GetImageSelection(const AArea: TdxPDFPageRect): TdxPDFImageSelection;
    function GetTextRanges(const AArea: TdxPDFPageRect): TdxPDFPageTextRanges;
    function GetTextSelection(const AArea: TdxPDFPageRect): TdxPDFTextSelection;
    procedure CopyImageToClipboard;
    procedure CopyTextToClipboard;
    procedure EndSelection; overload;
    procedure EndSelection(AShift: TShiftState); overload;
    procedure DoSelect; overload;
    procedure DoSelect(AShift: TShiftState); overload;
    procedure SelectByKeyboard(ADirection: TdxPDFMovementDirection);
    procedure SelectImage(const AArea: TdxPDFPageRect); overload;
    procedure SelectText(const ARanges: TdxPDFPageTextRanges); overload;
    procedure StartSelection; overload;
    procedure StartSelection(AShift: TShiftState); overload;
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MouseMove(Shift: TShiftState; X, Y: Integer);
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

    function CreateHighlight(ARange: TdxPDFPageTextRange;
      ABackColor, AFrameColor: TdxAlphaColor): TdxPDFTextHighlight; overload;
    function CreateHighlight(const ARanges: TdxPDFPageTextRanges;
      ABackColor, AFrameColor: TdxAlphaColor): TdxPDFTextHighlight; overload;
    function KeyDown(var AKey: Word; AShift: TShiftState): Boolean;
    function GetSelectionAsBitmap: TcxBitmap;
    function GetSelectionAsText: string;
    function GetPage(AIndex: Integer): TdxPDFPage;
    function HitAtSelection: Boolean;
    procedure Clear;
    procedure LockedClear;
    procedure CopyToClipboard;
    procedure HideCaret;
    procedure MakeVisible;
    procedure Select(const ARect: TRect);
    procedure SelectText(ARange: TdxPDFPageTextRange); overload;
    procedure SelectAll;
    procedure SelectionChanged;

    property Caret: TdxPDFDocumentCaret read FCaret write SetCaret;
    property ClickController: TdxPDFViewerClickController read FClickController;
    property HitTest: TdxPDFViewerDocumentHitTest read GetHitTest;
    property Images[APageIndex: Integer]: TdxPDFImageList read GetImages;
    property Page[AIndex: Integer]: TdxPDFPage read GetPage;
    property Selection: TdxPDFCustomSelection read FSelection write SetSelection;
    property ScaleFactor: TdxPointF read GetScaleFactor;
    property TextLines[APageIndex: Integer]: TdxPDFTextLineList read GetTextLines;

    property OnMakeRectVisible: TMakeRectVisibleEvent read FOnMakeRectVisible write FOnMakeRectVisible;
    property OnSelectionChanged: TNotifyEvent read FOnSelectionChanged write FOnSelectionChanged;
  public
    constructor Create(AViewer: TdxPDFCustomViewer); override;
    destructor Destroy; override;
  end;

  { TdxPDFViewerContainerController }

  TdxPDFViewerContainerController = class(TdxPDFViewerCustomController)
  strict private
    FFocusedCell: TdxPDFViewerCellViewInfo;
    FHotCell: TdxPDFViewerCellViewInfo;
    FPressedCell: TdxPDFViewerCellViewInfo;
    //
    procedure SetHotCell(const AValue: TdxPDFViewerCellViewInfo);
    procedure SetPressedCell(const AValue: TdxPDFViewerCellViewInfo);
    procedure SetFocusedCell(const AValue: TdxPDFViewerCellViewInfo);
  protected
    function DoKeyDown(AKey: Word; AShift: TShiftState): Boolean; override;
    function GetCursor: TCursor; override;
    procedure CalculateHitTest(X, Y: Integer); override;
    procedure DoMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure DoMouseEnter(AControl: TControl); override;
    procedure DoMouseLeave(AControl: TControl); override;
    procedure DoMouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure DoMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure UpdateState; override;
    //
    function CanActivate(const P: TPoint): Boolean; virtual;
    function GetHitTest: TdxPDFViewerCellHitTest; virtual;
    function GetViewInfo: TdxPDFViewerContainerViewInfo; virtual;
    function FindNextFocusableCell(ACell: TdxPDFViewerCellViewInfo; AGoForward: Boolean): TdxPDFViewerCellViewInfo; virtual;
    function ProcessKeyDown(AKey: Word; AShift: TShiftState): Boolean; virtual;
    procedure Clear; virtual;
    procedure DoSetFocus; virtual;
    procedure SetPressedAndFocusedCells; virtual;
    //
    function DoFindNextFocusableCell(ACell: TdxPDFViewerCellViewInfo;
      AOrderList: TdxPDFViewerViewInfoList; AGoForward: Boolean): TdxPDFViewerCellViewInfo;
    procedure CellRemoving(ACell: TdxPDFViewerCellViewInfo);
    procedure FocusNextCell(AGoForward: Boolean); virtual;
    procedure ProcessAccel(ACell: TdxPDFViewerCellViewInfo);
    procedure ProcessClick(ACell: TdxPDFViewerCellViewInfo);
    //
    property FocusedCell: TdxPDFViewerCellViewInfo read FFocusedCell write SetFocusedCell;
    property HitTest: TdxPDFViewerCellHitTest read GetHitTest;
    property HotCell: TdxPDFViewerCellViewInfo read FHotCell write SetHotCell;
    property PressedCell: TdxPDFViewerCellViewInfo read FPressedCell write SetPressedCell;
    property ViewInfo: TdxPDFViewerContainerViewInfo read GetViewInfo;
  end;

  { TdxPDFViewerNavigationPaneController }

  TdxPDFViewerNavigationPaneController = class(TdxPDFViewerContainerController)
  strict private
    FHintCell: TdxPDFViewerCellViewInfo;
    FHintHelper: TcxControlHintHelper;
    FShowHintTimer: TcxTimer;
    //
    function GetHintText: string;
    function GetNavigationPane: TdxPDFViewerNavigationPane;
    function GetNavigationPaneHitTest: TdxPDFViewerNavigationPaneHitTest;
    function GetNavigationViewInfo: TdxPDFViewerNavigationPaneViewInfo;
    function NeedShowHint(const AHint: string): Boolean;
    procedure CheckHint;
    procedure ShowHintTimerExpired(Sender: TObject);
  protected
    function GetHitTest: TdxPDFViewerCellHitTest; override;
    function GetViewInfo: TdxPDFViewerContainerViewInfo; override;
    function DoMouseWheel(AShift: TShiftState; AWheelDelta: Integer; const AMousePos: TPoint): Boolean; override;
    procedure CreateSubClasses; override;
    procedure Clear; override;
    procedure DestroySubClasses; override;
    procedure DoMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure DoMouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure DoMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    //
    procedure ExecuteOperation(const AOperation: TdxPDFInteractiveOperation);
    procedure Refresh;
    //
    property HitTest: TdxPDFViewerNavigationPaneHitTest read GetNavigationPaneHitTest;
    property NavigationPane: TdxPDFViewerNavigationPane read GetNavigationPane;
    property ViewInfo: TdxPDFViewerNavigationPaneViewInfo read GetNavigationViewInfo;
  end;

  { TdxPDFViewerEditingController }

  TdxPDFViewerEditingController = class(TcxCustomEditingController) // for internal use
  strict private type
    TActivateEditProc = reference to procedure;
  strict private
    FController: TdxPDFViewerController;
    FEditData: TcxCustomEditData;
    //
    function GetWidget: TdxPDFViewerWidgetViewInfo;
    function PrepareEdit(AIsMouseEvent: Boolean): Boolean;
    procedure AssignEditStyle;
    procedure DoShowEdit(AProc: TActivateEditProc; AIsMouseEvent: Boolean);
  protected
    function CanInitEditing: Boolean; override;
    procedure DoEditChanged; override;
    function GetCancelEditingOnExit: Boolean; override;
    function GetEditParent: TWinControl; override;
    function GetFocusedCellBounds: TRect; override;
    function GetHideEditOnExit: Boolean; override;
    function GetHideEditOnFocusedRecordChange: Boolean; override;
    function GetIsEditing: Boolean; override;
    function GetValue: Variant; override;
    procedure ClearEditingItem; override;
    procedure DoHideEdit(AAccept: Boolean); override;
    procedure DoUpdateEdit; override;
    procedure EditAfterKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); override;
    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); override;
    procedure SetValue(const AValue: Variant); override;
    procedure StartEditingByTimer; override;
    procedure UpdateInplaceParamsPosition; override;
    //
    procedure UpdateEditPosition;
    procedure UpdateEditFontSize;
    //
    property Controller: TdxPDFViewerController read FController;
    property Widget: TdxPDFViewerWidgetViewInfo read GetWidget;
  public
    FShift: TShiftState;
    constructor Create(AController: TdxPDFViewerController);
    destructor Destroy; override;
    //
    procedure ShowEdit; override;
    procedure ShowEditByKey(const AChar: Char);
    procedure ShowEditByMouse(AShift: TShiftState = []);
  end;

  { TdxPDFViewerTabNavigationStrategy }

  TdxPDFViewerTabNavigationStrategy = class
  strict private
    FController: TdxPDFViewerController;
    FTabNavigationController: TdxPDFViewerTabNavigationController;
    //
    function GetFirstAnnotation: TdxPDFCustomAnnotation;
    function GetPageCount: Integer;
  strict protected
    function GetPageFirstAnnotation(AAnnotationList: TdxFastObjectList): TdxPDFCustomAnnotation; virtual; abstract;
    function GetStartPageIndex: Integer; virtual; abstract;
    function GetStep: Integer; virtual; abstract;
    //
    function DoGetFirstAnnotation(ALastPageIndex: Integer): TdxPDFCustomAnnotation;
    function GetNextAnnotation(ACurrent: TdxPDFCustomAnnotation): TdxPDFCustomAnnotation;
    function GetNextPageWithAnnotations(ACurrentPageIndex: Integer): TdxFastObjectList;
    //
    property Controller: TdxPDFViewerController read FController;
    property FirstAnnotation: TdxPDFCustomAnnotation read GetFirstAnnotation;
    property PageCount: Integer read GetPageCount;
    property StartPageIndex: Integer read GetStartPageIndex;
    property Step: Integer read GetStep;
    property TabNavigationController: TdxPDFViewerTabNavigationController read FTabNavigationController;
  public
    constructor Create(ATabNavigationController: TdxPDFViewerTabNavigationController; AController: TdxPDFViewerController);
    function GetTabNext(ALastPageIndex: Integer): TdxPDFCustomAnnotation;
  end;

  { TdxPDFTabForwardNavigationStrategy }

  TdxPDFTabForwardNavigationStrategy = class(TdxPDFViewerTabNavigationStrategy)
  strict protected
    function GetPageFirstAnnotation(AAnnotationList: TdxFastObjectList): TdxPDFCustomAnnotation; override;
    function GetStartPageIndex: Integer; override;
    function GetStep: Integer; override;
  end;

  { TdxPDFTabBackwardNavigationStrategy }

  TdxPDFTabBackwardNavigationStrategy = class(TdxPDFViewerTabNavigationStrategy)
  strict protected
    function GetPageFirstAnnotation(AAnnotationList: TdxFastObjectList): TdxPDFCustomAnnotation; override;
    function GetStartPageIndex: Integer; override;
    function GetStep: Integer; override;
  end;

  { TdxPDFViewerTabNavigationController }

  TdxPDFViewerTabNavigationController = class
  strict private
    FLastPageIndex: Integer;
    FTabBackwardStrategy: TdxPDFViewerTabNavigationStrategy;
    FTabForwardStrategy: TdxPDFViewerTabNavigationStrategy;
  public
    constructor Create(AController: TdxPDFViewerController);
    destructor Destroy; override;
    //
    procedure Clear;
    function TabBackward: TdxPDFCustomAnnotation;
    function TabForward: TdxPDFCustomAnnotation;
    //
    property LastPageIndex: Integer read FLastPageIndex write FLastPageIndex;
  end;

  { TdxPDFViewerController }

  TdxPDFViewerController = class(TdxPDFViewerContainerController)
  strict private type
    TFieldPropertiesDictionary = class(TObjectDictionary<TcxCustomEditPropertiesClass, TcxCustomEditProperties>);
  strict private
    FEditingController: TdxPDFViewerEditingController;
    FFieldProperties: TFieldPropertiesDictionary;
    FFocusedAnnotation: TdxPDFCustomAnnotation;
    FInteractiveObjectHintHelper: TcxCustomHintHelper;
    FInteractivityController: TdxPDFViewerInteractivityController;
    FPrevHandPoint: TPoint;
    FSelectionController: TdxPDFViewerSelectionController;
    FTabNavigationController: TdxPDFViewerTabNavigationController;
    FViewStateHistoryController: TdxPDFViewerViewStateHistoryController;
    //
    function GetDocumentHitTest: TdxPDFViewerDocumentHitTest;
    function GetDocumentState: TdxPDFViewerDocumentState;
    //
    function GetAttachmentSavingPath(AAttachment: TdxPDFFileAttachment): string;
    procedure DoSaveAttachment(const APath: string; AAttachment: TdxPDFFileAttachment);
    //
    function NeedHorizontalScroll: Boolean;
    procedure CheckHandToolCursor;
    procedure OnMakeRectVisibleHandler(APageIndex: Integer; const ARect: TdxRectF);
  protected
    function CanActivate(const P: TPoint): Boolean; override;
    function DoMouseWheel(AShift: TShiftState; AWheelDelta: Integer; const AMousePos: TPoint): Boolean; override;
    function GetCursor: TCursor; override;
    function GetHitTest: TdxPDFViewerCellHitTest; override;
    function GetPopupMenuClass: TComponentClass; override;
    function ProcessKeyDown(AKey: Word; AShift: TShiftState): Boolean; override;
    procedure CalculateMouseButtonPressed(Shift: TShiftState; X, Y: Integer); override;
    procedure Clear; override;
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure FocusNextCell(AGoForward: Boolean); override;
    procedure SetPressedAndFocusedCells; override;
    //
    procedure DoMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure DoMouseLeave(AControl: TControl); override;
    procedure DoMouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure DoMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure KeyPress(var AKey: Char);
    //
    function GetPageScrollPosition(APage: TdxPDFViewerPage; AScrollPositionX, AScrollPositionY: Single): TdxPointF;
    function GetPageTopLeft(APage: TdxPDFViewerPage): TdxPointF;
    //
    function AllowSelection: Boolean;
    //
    function GetFocusedWidgetViewInfo: TdxPDFViewerWidgetViewInfo;
    function IsDocumentPanning: Boolean;
    function IsDocumentSelecting: Boolean;
    function TryGetViewInfo(AAnnotation: TdxPDFCustomAnnotation; out AViewInfo: TdxPDFViewerCustomAnnotationViewInfo): Boolean;
    procedure MakeRectVisible(const ARect: TdxRectF; AType: TdxVisibilityType = vtCentered; AIsTopAlignment: Boolean = False);
    procedure MakeSelectionRectVisible(APageIndex: Integer; const ARect: TdxRectF);
    procedure HideEdit(AAccept: Boolean = False);
    procedure HideHints;
    procedure FocusChanged;
    procedure OffsetContent(const AOffset: TPoint);
    procedure Rotate(AAngleDelta: Integer);
    procedure SetActiveAndMakeVisiblePage(APageIndex: Integer; AAnimated: Boolean);
    procedure SetScrollPosition(const APosition: TPoint; AAnimated: Boolean = False);
    procedure ScrollPosChanged;
    procedure ShowDocumentPosition(const ATarget: TdxPDFTarget);
    procedure ShowEditByMouse(AShift: TShiftState = []);
    //
    procedure OpenAttachment(AAttachment: TdxPDFFileAttachment);
    procedure SaveAttachment(AAttachment: TdxPDFFileAttachment);
    //
    property DocumentHitTest: TdxPDFViewerDocumentHitTest read GetDocumentHitTest;
    property DocumentState: TdxPDFViewerDocumentState read GetDocumentState;
    property EditingController: TdxPDFViewerEditingController read FEditingController;
    property FocusedAnnotation: TdxPDFCustomAnnotation read FFocusedAnnotation write FFocusedAnnotation;
    property SelectionController: TdxPDFViewerSelectionController read FSelectionController;
    property TabNavigationController: TdxPDFViewerTabNavigationController read FTabNavigationController;
    property ViewStateHistoryController: TdxPDFViewerViewStateHistoryController read FViewStateHistoryController;
  public
    function GetProperties(AClass: TcxCustomEditPropertiesClass): TcxCustomEditProperties; // for internal use
    procedure ExecuteOperation(const AOperation: TdxPDFInteractiveOperation); // for internal use
    //
    property FocusedCell;
  end;

  { TdxPDFViewerCellViewInfo }

  TdxPDFViewerCellViewInfoClass = class of TdxPDFViewerCellViewInfo; // for internal use
  TdxPDFViewerCellViewInfo = class(TcxIUnknownObject) // for internal use
  private
    FBounds: TRect;
    FController: TdxPDFViewerContainerController;
    //
    function GetPainter: TdxPDFViewerPainter;
    function GetScaleFactor: TdxScaleFactor;
    function GetViewer: TdxPDFCustomViewer;
  protected
    procedure CreateSubClasses; virtual;
    procedure DestroySubClasses; virtual;
    //
    function CalculateHitTest(AHitTest: TdxPDFViewerCellHitTest): Boolean; virtual;
    function CanDrawContent: Boolean; virtual;
    function CanDrawFocusRect: Boolean; virtual;
    function CanFocus: Boolean; virtual;
    function IsFocused: Boolean; virtual;
    function IsHot: Boolean; virtual;
    function IsPressed: Boolean; virtual;
    function GetClipRect: TRect; virtual;
    function GetFont: TFont; virtual;
    function GetVisible: Boolean; virtual;
    function MeasureHeight: Integer; virtual;
    function MeasureWidth: Integer; virtual;
    procedure Calculate;
    procedure DoCalculate; virtual;
    procedure DrawBackground(ACanvas: TcxCanvas); virtual;
    procedure DrawChildren(ACanvas: TcxCanvas); virtual;
    procedure DrawContent(ACanvas: TcxCanvas); virtual;
    procedure DrawFocusRect(ACanvas: TcxCanvas); virtual;
    procedure Execute(AShift: TShiftState = []); virtual;
    procedure Invalidate; virtual;
    procedure SetBounds(const ABounds: TRect); virtual;
    procedure UpdateState; virtual;
    //
    function ApplyScaleFactor(AValue: Integer): Integer; overload;
    function ApplyScaleFactor(AValue: TSize): TSize; overload;
    function ApplyScaleFactor(AValue: TRect): TRect; overload;
    procedure Draw(ACanvas: TcxCanvas; AForce: Boolean = False); virtual;
    procedure Offset(const AOffset: TPoint); virtual;
    //
    property Controller: TdxPDFViewerContainerController read FController;
    property Painter: TdxPDFViewerPainter read GetPainter;
    property ScaleFactor: TdxScaleFactor read GetScaleFactor;
    property Viewer: TdxPDFCustomViewer read GetViewer;
    property Visible: Boolean read GetVisible;
  public
    constructor Create(AController: TdxPDFViewerContainerController); virtual;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    //
    property Bounds: TRect read FBounds write SetBounds;
  end;

  { TdxPDFViewerViewInfoList }

  TdxPDFViewerViewInfoList = class(TObjectList<TdxPDFViewerCellViewInfo>) // for internal use
  protected
    function CalculateHitTest(AHitTest: TdxPDFViewerCellHitTest): Boolean;
    function MaxMeasureHeight: Integer;
    procedure Calculate;
    procedure Draw(ACanvas: TcxCanvas);
    procedure Offset(const AOffset: TPoint);
    procedure UpdateState;
  end;

  { TdxPDFViewerContainerViewInfo }

  TdxPDFViewerContainerViewInfo = class(TdxPDFViewerCellViewInfo) // for internal use
  strict private
    FCellList: TdxPDFViewerViewInfoList;
    //
    function GetCount: Integer;
  protected
    function CalculateHitTest(AHitTest: TdxPDFViewerCellHitTest): Boolean; override;
    function MeasureHeight: Integer; override;
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure DoCalculate; override;
    procedure DrawChildren(ACanvas: TcxCanvas); override;
    procedure Offset(const AOffset: TPoint); override;
    procedure UpdateState; override;
    //
    function GetContentMargins: TRect; virtual;
    function GetIndentBetweenElements: Integer; virtual;
    function NeedRecreateCells(AType: TdxChangeType): Boolean; virtual;
    procedure Calculate(AType: TdxChangeType; const ARect: TRect); reintroduce; overload;
    procedure CalculateBounds(const ARect: TRect; out ABounds: TRect); virtual;
    procedure CalculateContent; virtual;
    procedure ClearCells; virtual;
    procedure CreateCells; virtual;
    procedure PopulateTabOrders(ACellList: TdxPDFViewerViewInfoList); virtual;
    //
    function AddCell(ACellClass: TdxPDFViewerCellViewInfoClass): TdxPDFViewerCellViewInfo; overload;
    function AddCell(ACellClass: TdxPDFViewerCellViewInfoClass;
      AController: TdxPDFViewerContainerController): TdxPDFViewerCellViewInfo; overload;
    function AlignToTopClientSide(AViewInfo: TdxPDFViewerCellViewInfo; var R: TRect): Boolean;
    function AlignToLeftSide(AViewInfo: TdxPDFViewerCellViewInfo; var R: TRect): Boolean; overload;
    function AlignToRightSide(AViewInfo: TdxPDFViewerCellViewInfo; var R: TRect): Boolean; overload;
    function GetContentBounds: TRect;
    procedure AddTabOrder(ACell: TdxPDFViewerCellViewInfo; AList: TdxPDFViewerViewInfoList);
    procedure RecreateCells(AType: TdxChangeType);
    procedure SetEmptyBounds(AViewInfo: TdxPDFViewerCellViewInfo);
    //
    property ContentMargins: TRect read GetContentMargins;
    property IndentBetweenElements: Integer read GetIndentBetweenElements;
  public
    class function AlignToLeftSide(AViewInfo: TdxPDFViewerCellViewInfo; AIndent: Integer; var R: TRect): Boolean; overload; static;
    class function AlignToRightSide(AViewInfo: TdxPDFViewerCellViewInfo; AIndent: Integer; var R: TRect): Boolean; overload; static;
    //
    property CellList: TdxPDFViewerViewInfoList read FCellList;
    property Count: Integer read GetCount;
  end;

  { TdxPDFViewerDocumentObjectViewInfo }

  TdxPDFViewerDocumentObjectViewInfoClass = class of TdxPDFViewerDocumentObjectViewInfo; // for internal use
  TdxPDFViewerDocumentObjectViewInfo = class(TdxPDFViewerCellViewInfo) // for internal use
  strict private
    FClientBounds: TRect;
    FPageIndex: Integer;
    //
    function GetMousePos: TPoint;
    function GetPage: TdxPDFViewerPage;
  strict protected
    FObject: TObject;
  protected
    procedure DoCalculate; override;
    //
    function GetCursor: TCursor; virtual;
    function GetHint: string; virtual;
    function GetHitCode: Integer; virtual; abstract;
    function GetPageRect: TdxRectF; virtual; abstract;
    //
    function ToPageRect(const R: TdxRectF): TRect;
    function ToViewerRect(const R: TdxRectF): TRect;
    function ToViewerEditRect(const R: TdxRectF): TRect;
    //
    property Page: TdxPDFViewerPage read GetPage;
    property PageIndex: Integer read FPageIndex;
    property PageRect: TdxRectF read GetPageRect;
  public
    constructor Create(AController: TdxPDFViewerContainerController; APageIndex: Integer; AObject: TObject); reintroduce; virtual;
    destructor Destroy; override;
    //
    property Cursor: TCursor read GetCursor;
    property Hint: string read GetHint;
    property HitCode: Integer read GetHitCode;
    property MousePos: TPoint read GetMousePos;
  end;

  { TdxPDFViewerCustomAnnotationViewInfo }

  TdxPDFViewerCustomAnnotationViewInfo = class(TdxPDFViewerDocumentObjectViewInfo, IdxPDFHintableObject) // for internal use
  strict private
    function GetBounds: TRect;
  protected
    function GetAnnotation: TdxPDFCustomAnnotation; virtual;
    function GetHitCode: Integer; override;
    function GetPageRect: TdxRectF; override;
    function IsFocused: Boolean; override;
    procedure Execute(AShift: TShiftState = []); override;
  public
    property Annotation: TdxPDFCustomAnnotation read GetAnnotation;
  end;

  { TdxPDFViewerImageViewInfo }

  TdxPDFViewerImageViewInfo = class(TdxPDFViewerDocumentObjectViewInfo) // for internal use
  strict private
    FID: string;
    FImageBounds: TdxPDFPageRect;
  strict protected
    function GetPageRect: TdxRectF; override;
  protected
    function CanFocus: Boolean; override;
    function GetHitCode: Integer; override;
    //
    property ID: string read FID;
    property ImageBounds: TdxPDFPageRect read FImageBounds;
  public
    constructor Create(AController: TdxPDFViewerContainerController; APageIndex: Integer; AObject: TObject); override;
  end;

  { TdxPDFViewerWidgetViewInfo }

  TdxPDFViewerWidgetViewInfo = class(TdxPDFViewerCustomAnnotationViewInfo, IdxPDFInteractiveObject)  // for internal use
  strict private
    FEditBounds: TRect;
    FNeedSetRegion: Boolean;
    //
    function GetActualColor(AColor: TColor): TColor;
    function GetBackgroundColor: TColor;
    function GetTextColor: TColor;
    //
    function GetCanvas: TcxCanvas;
    function GetField: TdxPDFCustomField;
    function GetFieldType: TdxPDFInteractiveFormFieldType;
    function GetOriginalBorderWidth: Single;
    function GetOriginalFontSize: Single;
    function GetProperties: TcxCustomEditProperties;
    function GetScaledFontSize: Integer;
    function GetWidget: TdxPDFCustomWidget;
    function GetViewerDocumentScaleFactor: Single;
  strict protected
    // IdxPDFInteractiveObject
    function AllowActivateByMouseDown: Boolean; virtual;
    function GetAction: TdxPDFInteractiveOperation; virtual;
    //
    function GetEditValue: Variant; virtual;
    procedure SetEditValue(const AValue: Variant); virtual;
  protected
    function CanDrawFocusRect: Boolean; override;
    function CanFocus: Boolean; override;
    function GetAnnotation: TdxPDFCustomAnnotation; override;
    function GetHint: string; override;
    function GetHitCode: Integer; override;
    function GetPageRect: TdxRectF; override;
    procedure DoCalculate; override;
    procedure DrawFocusRect(ACanvas: TcxCanvas); override;
    procedure Execute(AShift: TShiftState = []); override;
    procedure Offset(const AOffset: TPoint); override;
    function NeedExtraSymbolWidthForEditor: Boolean; virtual;
    //
    function GetRotatedWidgetCursor(ACursor: TCursor): TCursor;
    function IsRotated: Boolean;
    //
    function GetPropertiesClass: TcxCustomEditPropertiesClass; virtual;
    function UseWindowRegion(out ARegion: TcxRegion): Boolean; virtual;
    //
    property BackgroundColor: TColor read GetBackgroundColor;
    property TextColor: TColor read GetTextColor;
    //
    property NeedSetRegion: Boolean read FNeedSetRegion;
    property Widget: TdxPDFCustomWidget read GetWidget;
  public
    function IsMultiLine: Boolean; virtual;
    function TryGetProperties(out AProperties: TcxCustomEditProperties): Boolean;
    procedure InitFont(AFont: TFont); virtual;
    procedure InitProperties(AProperties: TcxCustomEditProperties); virtual;
    procedure InitStyle(AStyle: TcxCustomEditStyle); virtual;
    procedure UpdateEditFontSize(AEdit: TcxCustomEdit); virtual; // for internal use
    property ViewerDocumentScaleFactor: Single read GetViewerDocumentScaleFactor; // for internal use
    //
    property Canvas: TcxCanvas read GetCanvas;
    property EditBounds: TRect read FEditBounds;
    property EditValue: Variant read GetEditValue write SetEditValue;
    property Field: TdxPDFCustomField read GetField;
    property FieldType: TdxPDFInteractiveFormFieldType read GetFieldType;
    property OriginalFontSize: Single read GetOriginalFontSize;
    property ScaledFontSize: Integer read GetScaledFontSize;
    property ScaleFactor;
    property Viewer;
  end;

  { TdxPDFViewerPageViewInfo }

  TdxPDFViewerPageViewInfo = class(TdxPDFViewerContainerViewInfo) // for internal use
  strict private
    FPageIndex: Integer;
    //
    function TryCreateWidgetViewInfo(AObject: TObject): Boolean;
    procedure AddCellViewInfo(AClass: TdxPDFViewerDocumentObjectViewInfoClass; AObject: TObject);
    procedure CreateObjectViewInfo(AObject: TObject);
  protected
    procedure CalculateContent; override;
    procedure CreateCells; override;
    procedure PopulateTabOrders(ACellList: TdxPDFViewerViewInfoList); override;
    procedure SetBounds(const ABounds: TRect); override;
    //
    property PageIndex: Integer read FPageIndex;
  public
    constructor Create(AController: TdxPDFViewerContainerController; APageIndex: Integer); reintroduce;
  end;

  { TdxPDFViewerPagesViewInfo }

  TdxPDFViewerPagesViewInfo = class(TdxPDFViewerContainerViewInfo) // for internal use
  strict private
    FItems: TdxPDFIntegerObjectDictionary<TdxPDFViewerPageViewInfo>;
    FLockCount: Integer;
    //
    function GetController: TdxPDFViewerController;
    function GetPageViewInfo(APageIndex: Integer): TdxPDFViewerPageViewInfo;
    //
    function AddPageViewInfo(APageIndex: Integer): TdxPDFViewerPageViewInfo;
    procedure UpdateEditPosition;
    procedure UpdateEditFontSize;
  protected
    function CanFocus: Boolean; override;
    function NeedRecreateCells(AType: TdxChangeType): Boolean; override;
    procedure CalculateContent; override;
    procedure ClearCells; override;
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure Offset(const AOffset: TPoint); override;
    //
    function TryGetViewInfo(APageIndex: Integer; out AViewInfo: TdxPDFViewerPageViewInfo): Boolean;
    procedure LockRecreateCells;
    procedure UnLockRecreateCells;
    //
    property Controller: TdxPDFViewerController read GetController;
  public
    property PageViewInfos[APageIndex: Integer]: TdxPDFViewerPageViewInfo read GetPageViewInfo;
  end;

  { TdxPDFViewerCaptionViewInfo }

  TdxPDFViewerCaptionViewInfo = class(TdxPDFViewerCellViewInfo)
  protected
    function CanDrawContent: Boolean; override;
    function MeasureHeight: Integer; override;
    function MeasureWidth: Integer; override;
    procedure DrawContent(ACanvas: TcxCanvas); override;

    function GetPainterTextColor: TColor; virtual;
    function GetText: string; virtual;
    function GetTextAlignment: TAlignment; virtual;
    procedure PrepareCanvas(ACanvas: TcxCanvas); virtual;

    property Font: TFont read GetFont;
    property Text: string read GetText;
  end;

  { TdxPDFViewerButtonViewInfo }

  TdxPDFViewerButtonViewInfoClass = class of TdxPDFViewerButtonViewInfo;
  TdxPDFViewerButtonViewInfo = class(TdxPDFViewerCellViewInfo, IcxHintableObject)
  strict private
    FFadingHelper: TdxPDFViewerButtonFadingHelper;
    FState: TcxButtonState;
    function GetGlyphSize: TSize;
    procedure SetState(const AState: TcxButtonState);

    function GetButtonOffset(AButtonState: TcxButtonState): TPoint;
    procedure DrawFading(ACanvas: TcxCanvas);
    // IcxHintableObject
    function HasHintPoint(const P: TPoint): Boolean;
    function IsHintAtMousePos: Boolean;
    function UseHintHidePause: Boolean;
  protected
    FCaption: string;
    FCaptionRect: TRect;
    FGlyph: TdxSmartGlyph;
    FGlyphRect: TRect;

    function CanFocus: Boolean; override;
    function MeasureHeight: Integer; override;
    function MeasureWidth: Integer; override;
    procedure DoCalculate; override;
    procedure DrawContent(ACanvas: TcxCanvas); override;
    procedure DrawFocusRect(ACanvas: TcxCanvas); override;
    procedure UpdateState; override;

    function CalculateState: TcxButtonState; virtual;
    function IsDefault: Boolean; virtual;
    function IsEnabled: Boolean; virtual;
    function IsFadingAvailable: Boolean;
    function IsSkinUsed: Boolean;
    function GetDefaultCaption: string; virtual;
    function GetGlyph: TdxSmartGlyph; virtual;
    function GetGlyphAlignmentHorz: TAlignment; virtual;
    function GetHint: string; virtual;
    function GetMargins: TRect; virtual;
    procedure CalculateCaptionRect; virtual;
    procedure CalculateGlyphRect; virtual;
    procedure DoExecute; virtual;
    procedure DrawButtonBackground(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState); virtual;
    procedure DrawButtonContent(ACanvas: TcxCanvas); virtual;

    procedure DrawButton(ACanvas: TcxCanvas);
    procedure Execute(AShift: TShiftState = []); override;

    property CaptionRect: TRect read FCaptionRect;
    property FadingHelper: TdxPDFViewerButtonFadingHelper read FFadingHelper;
    property Font: TFont read GetFont;
    property GlyphRect: TRect read FGlyphRect;
    property GlyphSize: TSize read GetGlyphSize;
    property Margins: TRect read GetMargins;
    property State: TcxButtonState read FState write SetState;
  public
    constructor Create(AController: TdxPDFViewerContainerController); override;
    destructor Destroy; override;
  end;

  { TdxPDFViewerCustomDropDownButtonViewInfo }

  TdxPDFViewerCustomDropDownButtonViewInfo = class(TdxPDFViewerButtonViewInfo)
  strict private
    FDropDownButtonArrowRect: TRect;
    procedure CalculateDropDownButtonArrowRect;
  protected
    function IsEnabled: Boolean; override;
    function MeasureWidth: Integer; override;
    procedure DoCalculate; override;
    procedure DoExecute; override;
    procedure DrawButtonContent(ACanvas: TcxCanvas); override;

    function GetColorizeGlyph: Boolean; virtual;
    function GetPopupMenuClass: TComponentClass; virtual; abstract;
  end;

  { TdxPDFViewerButtonFadingHelper }

  TdxPDFViewerButtonFadingHelper = class(TdxFadingObjectHelper)
  private
    FButtonViewInfo: TdxPDFViewerButtonViewInfo;
  protected
    function CanFade: Boolean; override;
    procedure DrawFadeImage; override;
    procedure GetFadingImages(out AFadeOutImage, AFadeInImage: TcxBitmap); override;

    property ButtonViewInfo: TdxPDFViewerButtonViewInfo read FButtonViewInfo;
  public
    constructor Create(AViewInfo: TdxPDFViewerButtonViewInfo); virtual;
  end;

  { TdxPDFViewerImageAnimationTransition }

  TdxPDFViewerImageAnimationTransition = class(TdxAnimationTransition)
  strict private
    FDestination: TcxBitmap32;
    FImage: TdxGPImage;
    FIsHiding: Boolean;
    FMode: TdxDrawAnimationMode;

    function TransitionLength(AImageHeight: Integer): Integer;
    procedure Draw(AGraphics: TdxGPGraphics; const ADestRect: TRect); overload;
    procedure DrawFade(AGraphics: TdxGPGraphics; ALeft, ATop, AWidth, AHeight: Integer; AProgress: Byte);
    procedure DrawScrollDown(AGraphics: TdxGPGraphics; ALeft, ATop, AWidth, AHeight, AOffset: Integer);
    procedure DrawScrollDownFade(AGraphics: TdxGPGraphics; ALeft, ATop, AWidth, AHeight, AOffset: Integer);
    procedure DrawScrollUp(AGraphics: TdxGPGraphics; ALeft, ATop, AWidth, AHeight, AOffset: Integer);
    procedure DrawScrollUpFade(AGraphics: TdxGPGraphics; ALeft, ATop, AWidth, AHeight, AOffset: Integer);
    procedure PrepareImage(AImage: TGraphic);
  protected
    procedure Draw(ACanvas: TCanvas; const ADestRect: TRect); overload;
  public
    constructor Create(AImage: TGraphic; ATime: Cardinal; AMode: TdxDrawAnimationMode; AIsHiding: Boolean); reintroduce; virtual;
    destructor Destroy; override;
  end;

  { TdxPDFViewerFindPanelAnimationController }

  TdxPDFViewerFindPanelAnimationController = class(TdxPDFViewerCustomObject)
  private
    FActive: Boolean;
    FAnimatedRect: TRect;
    FAnimation: TdxPDFViewerImageAnimationTransition;
    //
    function CreateFindPanelBitmap: TcxBitmap;
    function GetAnimation: TdxPDFViewerFindPanelAnimation;
    procedure DoAnimate(AShowing: Boolean);
    procedure AnimationHandler(Sender: TdxAnimationTransition; var APosition: Integer; var AFinished: Boolean);
    procedure RedrawArea(const ARect: TRect);
    procedure RunAnimation(AImage: TBitmap; ATime: Cardinal; AMode: TdxDrawAnimationMode; AIsHiding: Boolean);
  protected
    procedure Animate(AShowing: Boolean);
    procedure Draw(ACanvas: TcxCanvas);
    //
    property Active: Boolean read FActive;
  end;

  { TdxPDFViewerFindPanelHitTest }

  TdxPDFViewerFindPanelHitTest = class(TdxPDFViewerCellHitTest)
  protected
    procedure DoCalculate(const AHitPoint: TPoint); override;
  end;

  { TdxPDFViewerFindPanelController }

  TdxPDFViewerFindPanelController = class(TdxPDFViewerContainerController)
  strict private
    FOptions: TdxPDFViewerOptionsFindPanel;
    //
    function GetFindPanelViewInfo: TdxPDFViewerFindPanelViewInfo;
  protected
    function CanActivate(const P: TPoint): Boolean; override;
    function GetViewInfo: TdxPDFViewerContainerViewInfo; override;
    function GetHitTest: TdxPDFViewerCellHitTest; override;
    function IsAvailable: Boolean; override;
    function ProcessKeyDown(AKey: Word; AShift: TShiftState): Boolean; override;
    procedure DoSetFocus; override;
    //
    function CanSearchText: Boolean;
    procedure DoFindText;
    procedure SetFocuse;
    //
    property Options: TdxPDFViewerOptionsFindPanel read FOptions;
    property ViewInfo: TdxPDFViewerFindPanelViewInfo read GetFindPanelViewInfo;
  public
    constructor Create(AViewer: TdxPDFCustomViewer; AOptions: TdxPDFViewerOptionsFindPanel); reintroduce;
  end;

  { TdxPDFViewerFindPanelViewInfo }

  TdxPDFViewerFindPanelViewInfo = class(TdxPDFViewerContainerViewInfo)
  strict private type
  {$REGION 'private types'}
    TEditViewInfo = class(TdxPDFViewerCellViewInfo)
    strict private
      function GetEdit: TdxPDFViewerFindPanelTextEdit;
      function GetMaxWidth: Integer;
      function GetMinWidth: Integer;
    protected
      ActualWidth: Integer;

      function CanDrawFocusRect: Boolean; override;
      function CanFocus: Boolean; override;
      function MeasureHeight: Integer; override;
      function MeasureWidth: Integer; override;
      procedure DoCalculate; override;
      procedure UpdateState; override;

      procedure SetFocus;

      property MaxWidth: Integer read GetMaxWidth;
      property MinWidth: Integer read GetMinWidth;
      property InternalEdit: TdxPDFViewerFindPanelTextEdit read GetEdit;
    public
      constructor Create(AController: TdxPDFViewerContainerController); override;
    end;

    TFindPanelButtonViewInfo = class(TdxPDFViewerButtonViewInfo)
    strict private
      function GetController: TdxPDFViewerFindPanelController;
    protected
      property Controller: TdxPDFViewerFindPanelController read GetController;
    end;

    TButtonViewInfo = class(TFindPanelButtonViewInfo)
    protected
      function IsEnabled: Boolean; override;
      function MeasureWidth: Integer; override;
    end;

    TCloseButtonViewInfo = class(TButtonViewInfo)
    protected
      function IsEnabled: Boolean; override;
      function MeasureHeight: Integer; override;
      function MeasureWidth: Integer; override;
      function GetVisible: Boolean; override;
      procedure DoExecute; override;
      procedure DrawButtonBackground(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState); override;
      procedure DrawButtonContent(ACanvas: TcxCanvas); override;
    end;

    TSearchButtonViewInfo = class(TButtonViewInfo)
    protected
      procedure DoExecute; override;
      function GetSearchDirection: TdxPDFDocumentTextSearchDirection; virtual;
    end;

    TNextButtonViewInfo = class(TSearchButtonViewInfo)
    protected
      function GetDefaultCaption: string; override;
      function GetVisible: Boolean; override;
    end;

    TOptionsButtonViewInfo = class(TdxPDFViewerCustomDropDownButtonViewInfo)
    protected
      function IsEnabled: Boolean; override;
      function GetGlyph: TdxSmartGlyph; override;
      function GetPopupMenuClass: TComponentClass; override;
      function GetVisible: Boolean; override;
    end;

    TPreviousButtonViewInfo = class(TSearchButtonViewInfo)
    protected
      function GetDefaultCaption: string; override;
      function GetSearchDirection: TdxPDFDocumentTextSearchDirection; override;
      function GetVisible: Boolean; override;
    end;
  {$ENDREGION}
  strict private
    FCaption: TdxPDFViewerCaptionViewInfo;
    FCloseButton: TCloseButtonViewInfo;
    FEdit: TEditViewInfo;
    FNextButton: TNextButtonViewInfo;
    FOptions: TOptionsButtonViewInfo;
    FPreviousButton: TPreviousButtonViewInfo;
    //
    function GetActualNextButtonViewInfo: TButtonViewInfo;
    function GetController: TdxPDFViewerFindPanelController;
    function GetOptionsFindPanel: TdxPDFViewerOptionsFindPanel;
  protected
    function GetContentMargins: TRect; override;
    function GetIndentBetweenElements: Integer; override;
    function GetVisible: Boolean; override;
    function MeasureWidth(const ABounds: TRect): Integer; reintroduce;
    procedure CalculateBounds(const ARect: TRect; out ABounds: TRect); override;
    procedure CalculateContent; override;
    procedure ClearCells; override;
    procedure CreateCells; override;
    procedure DrawBackground(ACanvas: TcxCanvas); override;
    procedure PopulateTabOrders(ACellList: TdxPDFViewerViewInfoList); override;
    //
    property ActualNextButtonViewInfo: TButtonViewInfo read GetActualNextButtonViewInfo;
    property Caption: TdxPDFViewerCaptionViewInfo read FCaption;
    property CloseButton: TCloseButtonViewInfo read FCloseButton;
    property Controller: TdxPDFViewerFindPanelController read GetController;
    property Edit: TEditViewInfo read FEdit;
    property NextButton: TNextButtonViewInfo read FNextButton;
    property OptionsFindPanel: TdxPDFViewerOptionsFindPanel read GetOptionsFindPanel;
    property OptionsButton: TOptionsButtonViewInfo read FOptions;
    property PreviousButton: TPreviousButtonViewInfo read FPreviousButton;
  end;

  { TdxPDFViewerInteractivityController }

  TdxPDFViewerInteractivityController = class(TdxPDFViewerCustomObject, IUnknown, IdxPDFInteractivityController)
  strict private
    // IUnknown
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;

    // IdxPDFInteractivityController
    procedure GoToFirstPage;
    procedure GoToLastPage;
    procedure GoToNextPage;
    procedure GoToPrevPage;
    procedure OpenUri(const AUri: string);

    procedure ExecuteActions(AAction: TdxPDFCustomAction; AExecutedActions: TdxPDFActionList);
  protected
    class procedure Execute(AViewer: TdxPDFCustomViewer; const AOperation: TdxPDFInteractiveOperation); overload; static;
    procedure ExecuteOperation(const AObject: IdxPDFInteractiveObject); overload;
    procedure ExecuteOperation(const AOperation: TdxPDFInteractiveOperation); overload;
    procedure ShowDocumentPosition(const ATarget: TdxPDFTarget);
  public
    class procedure Execute(AViewer: TdxPDFCustomViewer; AOutline: TdxPDFDocumentOutlineItem); overload; static;
    class procedure Execute(AViewer: TdxPDFCustomViewer; AHyperlink: TdxPDFHyperlink); overload; static;
  end;

  { TdxPDFViewerBookmarkTreeView }
  TdxPDFViewerNavigationPaneInternalControlClass = class of TdxPDFViewerNavigationPaneInternalControl;
  TdxPDFViewerNavigationPaneInternalControl = class(TdxPDFViewerCustomObject)
  strict private
    function GetBounds: TRect;
    function GetVisible: Boolean;
    procedure SetBounds(const AValue: TRect);
  strict protected
    FInternalControl: TWinControl;

    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;

    function GetEmpty: Boolean; virtual; abstract;
    procedure ClearInternalControl; virtual; abstract;
    procedure CreateInternalControl; virtual; abstract;
    procedure PopulateInternalControl; virtual; abstract;
    procedure UpdateInternalControlTextSize; virtual; abstract;

    procedure InitializeInternalControl; virtual;
  protected
    procedure Clear;
    procedure Refresh;
    procedure UpdateState;
    procedure UpdateTextSize;

    property Bounds: TRect read GetBounds write SetBounds;
    property Empty: Boolean read GetEmpty;
    property Visible: Boolean read GetVisible;
  end;

  { TdxPDFViewerBookmarkTreeView }

  TdxPDFViewerBookmarkTreeView = class(TdxPDFViewerNavigationPaneInternalControl)
  strict private type
  {$REGION 'private types'}
    TTree = class(TdxTreeViewControl, IcxFontListener)
    strict private
      FFontSize: Integer;
      function GetViewer: TdxPDFCustomViewer;
      procedure Changed(Sender: TObject; AFont: TFont);
    protected
      function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; override;
      procedure DoContextPopup(MousePos: TPoint; var Handled: Boolean); override;
      procedure KeyDown(var Key: Word; Shift: TShiftState); override;
      procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

      procedure SetTextSize(ATextSize: TdxPDFViewerBookmarksTextSize);

      property Viewer: TdxPDFCustomViewer read GetViewer;
    public
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
    end;
  {$ENDREGION}
  strict private
    function GetLookAndFeel: TcxLookAndFeel;
    function GetOutlines: TdxPDFDocumentOutlineList;
    function GetSelectedOutline: TdxPDFDocumentOutlineItem;
    function GetTreeView: TTree;

    function GetPrintPageNumbers(APrintSections: Boolean): TIntegerDynArray;

    procedure OnCustomDrawItemHandle(Sender: TdxCustomTreeView; ACanvas: TcxCanvas; ANodeViewInfo: TdxTreeViewNodeViewInfo; var AHandled: Boolean);
    procedure OnExpandedHandler(Sender: TdxCustomTreeView; ANode: TdxTreeViewNode);
    procedure OnMouseUpHandler(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure OnKeyDownHandler(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure OnSelectionChanged(Sender: TObject);

    property Outlines: TdxPDFDocumentOutlineList read GetOutlines;
    property SelectedOutline: TdxPDFDocumentOutlineItem read GetSelectedOutline;
    property TreeView: TTree read GetTreeView;
  strict protected
    function GetEmpty: Boolean; override;
    procedure ClearInternalControl; override;
    procedure CreateInternalControl; override;
    procedure InitializeInternalControl; override;
    procedure PopulateInternalControl; override;
    procedure UpdateInternalControlTextSize; override;
  protected
    function CanExpandSelectedBookmark: Boolean;
    function IsBookmarkSelected: Boolean;
    function IsTopLevelBookmarksExpanded: Boolean;
    procedure ExpandCollapseTopLevelBookmarks;
    procedure ExpandCurrentBookmark;
    procedure GoToBookmark;
    procedure PrintSelectedPages(APrintSections: Boolean);

    property LookAndFeel: TcxLookAndFeel read GetLookAndFeel;
  end;

  { TdxPDFViewerAttachmentFileList }

  TdxPDFViewerAttachmentFileList = class(TdxPDFViewerNavigationPaneInternalControl)
  strict private
    FImages: TdxShellImageList;
    FPrevItemIndex: Integer;

    function GetDocumentAttachments: TdxPDFFileAttachmentList;
    function GetView: TdxListViewControl;
    function GetShowHint: Boolean;
    procedure SetShowHint(const AValue: Boolean);

    procedure OpenAttachment;
    procedure OnClickHandler(Sender: TObject);
    procedure OnContextPopupHandler(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure OnDblClickHandler(Sender: TObject);
    procedure OnKeyDownHandler(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure OnMouseLeaveHandler(Sender: TObject);
    procedure OnMouseMoveHandler(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  strict protected
    function GetEmpty: Boolean; override;
    procedure ClearInternalControl; override;
    procedure CreateInternalControl; override;
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure InitializeInternalControl; override;
    procedure PopulateInternalControl; override;
    procedure UpdateInternalControlTextSize; override;
  protected
    procedure ScaleFactorChanged(Sender: TObject; M, D: Integer; IsLoading: Boolean); override;
    property DocumentAttachments: TdxPDFFileAttachmentList read GetDocumentAttachments;
    property ShowHint: Boolean read GetShowHint write SetShowHint;
  public
    property View: TdxListViewControl read GetView;
  end;

  { TdxPDFViewerNavigationPanePageCaptionButton }

  TdxPDFViewerNavigationPanePageCaptionButton = class(TdxPDFViewerButtonViewInfo)
  protected
    function CanFocus: Boolean; override;
    function GetGlyphAlignmentHorz: TAlignment; override;
    function MeasureHeight: Integer; override;
    function MeasureWidth: Integer; override;
    procedure DrawButtonContent(ACanvas: TcxCanvas); override;
    procedure DrawButtonBackground(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState); override;

    function GetColorizeGlyph: Boolean; virtual;
  end;

  { TdxPDFViewerNavigationPanePageButtonViewInfo }

  TdxPDFViewerNavigationPanePageButtonViewInfo = class(TdxPDFViewerButtonViewInfo)
  strict private
    FPage: TdxPDFViewerNavigationPanePageViewInfo;
    function IsActive: Boolean;
    function IsFirst: Boolean;
  protected
    function CalculateState: TcxButtonState; override;
    function CanFocus: Boolean; override;
    function IsEnabled: Boolean; override;
    function GetClipRect: TRect; override;
    function GetGlyph: TdxSmartGlyph; override;
    function GetGlyphAlignmentHorz: TAlignment; override;
    function MeasureHeight: Integer; override;
    function MeasureWidth: Integer; override;
    procedure DoExecute; override;
    procedure DrawButtonBackground(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState); override;
    procedure DrawButtonContent(ACanvas: TcxCanvas); override;
  public
    constructor Create(AController: TdxPDFViewerContainerController; APage: TdxPDFViewerNavigationPanePageViewInfo); reintroduce;
  end;

  { TdxPDFViewerNavigationPanePageToolBarOptionsButtonViewInfo }

  TdxPDFViewerNavigationPanePageToolBarOptionsButtonViewInfo = class(TdxPDFViewerCustomDropDownButtonViewInfo)
  protected
    OnGetPopupMenuClass: TComponentClass;
    function CanFocus: Boolean; override;
    function IsEnabled: Boolean; override;
    function GetColorizeGlyph: Boolean; override;
    function GetGlyph: TdxSmartGlyph; override;
    function GetHint: string; override;
    function GetPopupMenuClass: TComponentClass; override;
    function MeasureHeight: Integer; override;
    procedure DrawButtonBackground(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState); override;
  end;

  { TdxPDFViewerNavigationPanePageToolBarViewInfo }

  TdxPDFViewerNavigationPanePageToolBarViewInfo = class(TdxPDFViewerContainerViewInfo)
  strict private
    FActualContentBounds: TRect;
    FOptionsButton: TdxPDFViewerNavigationPanePageToolBarOptionsButtonViewInfo;
  protected
    function GetContentMargins: TRect; override;
    function MeasureWidth: Integer; override;
    function HasOptionsButton: Boolean; virtual;
    procedure CreateCells; override;
    procedure DoCalculate; override;
    procedure DrawBackground(ACanvas: TcxCanvas); override;
    //
    function GetPopupMenuClass: TComponentClass; virtual;
    //
    property ActualContentBounds: TRect read FActualContentBounds;
  end;

  { TdxPDFViewerNavigationPanePageViewInfo }

  TdxPDFViewerNavigationPanePageViewInfoClass = class of TdxPDFViewerNavigationPanePageViewInfo;
  TdxPDFViewerNavigationPanePageViewInfo = class(TdxPDFViewerContainerViewInfo)
  strict protected type
  {$REGION 'private types'}
    THeaderOnGetTextEvent = function: string of object;

    TCaptionText = class(TdxPDFViewerCaptionViewInfo)
    protected
      OnGetText: THeaderOnGetTextEvent;
      function GetFont: TFont; override;
      function GetPainterTextColor: TColor; override;
      function GetText: string; override;
      function GetTextAlignment: TAlignment; override;
      procedure PrepareCanvas(ACanvas: TcxCanvas); override;
    end;

    TMinimizeButton  = class(TdxPDFViewerNavigationPanePageCaptionButton)
    protected
      function GetGlyph: TdxSmartGlyph; override;
      function GetHint: string; override;
      procedure DoExecute; override;
    end;

    TMaximizeButton  = class(TdxPDFViewerNavigationPanePageCaptionButton)
    protected
      function GetGlyph: TdxSmartGlyph; override;
      function GetHint: string; override;
      procedure DoExecute; override;
    end;

    THeader = class(TdxPDFViewerContainerViewInfo)
    strict private
      FCaption: TCaptionText;
      FMinimizeButton: TdxPDFViewerNavigationPanePageCaptionButton;
      FMaximizeButton: TMaximizeButton;
      //
      function GetOnGetText: THeaderOnGetTextEvent;
      function GetViewInfo: TdxPDFViewerNavigationPaneViewInfo;
      procedure SetOnGetText(const AValue: THeaderOnGetTextEvent);
      function AlignToClient(AViewInfo: TdxPDFViewerCellViewInfo; var R: TRect): Boolean;
    protected
      function GetContentMargins: TRect; override;
      function MeasureHeight: Integer; override;
      function MeasureWidth: Integer; override;
      procedure CreateCells; override;
      procedure DoCalculate; override;
      procedure DrawBackground(ACanvas: TcxCanvas); override;
      //
      property OnGetText: THeaderOnGetTextEvent read GetOnGetText write SetOnGetText;
      property ViewInfo: TdxPDFViewerNavigationPaneViewInfo read GetViewInfo;
    end;
  {$ENDREGION}
  strict private
    FCaption: THeader;
    FButton: TdxPDFViewerNavigationPanePageButtonViewInfo;
    FPage: TdxPDFViewerNavigationPanePage;
    function OnGetHeaderTextHandler: string;
  protected
    FActualContentBounds: TRect;
    FToolBar: TdxPDFViewerNavigationPanePageToolBarViewInfo;
    function GetGlyph: TdxSmartGlyph;
  protected
    function CalculateHitTest(AHitTest: TdxPDFViewerCellHitTest): Boolean; override;
    function MeasureWidth: Integer; override;
    procedure CreateCells; override;
    procedure DoCalculate; override;
    procedure DrawBackground(ACanvas: TcxCanvas); override;

    function GetToolbarClass: TdxPDFViewerCellViewInfoClass; virtual;
    function CanShow: Boolean;

    property Button: TdxPDFViewerNavigationPanePageButtonViewInfo read FButton;
    property Glyph: TdxSmartGlyph read GetGlyph;
    property Page: TdxPDFViewerNavigationPanePage read FPage;
  public
    constructor Create(AController: TdxPDFViewerContainerController; APage: TdxPDFViewerNavigationPanePage); reintroduce;
  end;

  { TdxPDFViewerBookmarksPageViewInfo }

  TdxPDFViewerBookmarksPageViewInfo = class(TdxPDFViewerNavigationPanePageViewInfo)
  strict private type
  {$REGION 'private types'}
    TExpandBookmarkButton =  class(TdxPDFViewerNavigationPanePageCaptionButton)
    protected
      function GetColorizeGlyph: Boolean; override;
      function GetGlyph: TdxSmartGlyph; override;
      function GetHint: string; override;
      function IsEnabled: Boolean; override;
      procedure DoExecute; override;
      procedure DrawButtonBackground(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState); override;
    end;

    TBookmarksToolBar = class(TdxPDFViewerNavigationPanePageToolBarViewInfo)
    strict private
      FExpandButton: TExpandBookmarkButton;
    protected
      function GetPopupMenuClass: TComponentClass; override;
      procedure CreateCells; override;
      procedure DoCalculate; override;
    end;
  {$ENDREGION}
  strict private
    function GetOutlineTreeView: TdxPDFViewerBookmarkTreeView;
  protected
    function GetToolbarClass: TdxPDFViewerCellViewInfoClass; override;
    procedure CreateCells; override;
    procedure DoCalculate; override;

    property Tree: TdxPDFViewerBookmarkTreeView read GetOutlineTreeView;
  end;

  { TdxPDFViewerThumbnailsPageViewInfo }

  TdxPDFViewerThumbnailsPageViewInfo = class(TdxPDFViewerNavigationPanePageViewInfo)
  strict private type
  {$REGION 'private types'}
    TThumbnailsToolBar = class(TdxPDFViewerNavigationPanePageToolBarViewInfo)
    protected
      function GetPopupMenuClass: TComponentClass; override;
    end;
  {$ENDREGION}
  strict private
    function GetPreview: TdxPDFViewerPageThumbnailPreview;
    function GetZoomTrackBar: TcxTrackBar;
  protected
    function GetToolbarClass: TdxPDFViewerCellViewInfoClass; override;
    procedure DoCalculate; override;

    property Preview: TdxPDFViewerPageThumbnailPreview read GetPreview;
    property SizeTrackBar: TcxTrackBar read GetZoomTrackBar;
  end;

  { TdxPDFViewerAttachmentsPageViewInfo }

  TdxPDFViewerAttachmentsPageViewInfo = class(TdxPDFViewerNavigationPanePageViewInfo)
  strict private type
  {$REGION 'private types'}
    TOpenButton =  class(TdxPDFViewerNavigationPanePageCaptionButton)
    protected
      function GetColorizeGlyph: Boolean; override;
      function GetGlyph: TdxSmartGlyph; override;
      function GetHint: string; override;
      function IsEnabled: Boolean; override;
      procedure DoExecute; override;
      procedure DrawButtonBackground(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState); override;
    end;

    TSaveButton =  class(TdxPDFViewerNavigationPanePageCaptionButton)
    protected
      function GetColorizeGlyph: Boolean; override;
      function GetGlyph: TdxSmartGlyph; override;
      function GetHint: string; override;
      function IsEnabled: Boolean; override;
      procedure DoExecute; override;
      procedure DrawButtonBackground(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState); override;
    end;

    TAttachmentsToolBar = class(TdxPDFViewerNavigationPanePageToolBarViewInfo)
    strict private
      FOpenButton: TOpenButton;
      FSaveButton: TSaveButton;
    protected
      function GetPopupMenuClass: TComponentClass; override;
      function HasOptionsButton: Boolean; override;
      procedure CreateCells; override;
      procedure DoCalculate; override;
    end;
  {$ENDREGION}
  strict private
    function GetFileList: TdxPDFViewerAttachmentFileList;
  protected
    function GetToolbarClass: TdxPDFViewerCellViewInfoClass; override;
    procedure DoCalculate; override;
    //
    property FileList: TdxPDFViewerAttachmentFileList read GetFileList;
  end;

  { TdxPDFViewerPageThumbnailPreview }

  TdxPDFViewerPageThumbnailPreview = class(TdxPDFViewerNavigationPaneInternalControl)
  strict private type
    TThumbnailPreviewAccess = class(TdxPDFDocumentPageThumbnailViewer);
  strict private
    FLockCount: Integer;

    function GetLookAndFeel: TcxLookAndFeel;
    function GetMaxSize: Integer;
    function GetMinSize: Integer;
    function GetOnCustomDrawPreRenderPage: TdxPDFDocumentViewerOnCustomDrawPreRenderPageEvent;
    function GetOnSizeChanged: TNotifyEvent;
    function GetPreview: TThumbnailPreviewAccess;
    function GetSelectedPageIndex: Integer;
    function GetSize: Integer;
    procedure SetMaxSize(const AValue: Integer);
    procedure SetMinSize(const AValue: Integer);
    procedure SetOnCustomDrawPreRenderPage(const AValue: TdxPDFDocumentViewerOnCustomDrawPreRenderPageEvent);
    procedure SetOnSizeChanged(const AValue: TNotifyEvent);
    procedure SetSelectedPageIndex(const AValue: Integer);
    procedure SetSize(const AValue: Integer);
    procedure OnSelectedPageChangedHandler(Sender: TObject; APageIndex: Integer);

    property Preview: TThumbnailPreviewAccess read GetPreview;
  strict protected
    function GetEmpty: Boolean; override;
    procedure ClearInternalControl; override;
    procedure CreateInternalControl; override;
    procedure DestroySubClasses; override;
    procedure InitializeInternalControl; override;
    procedure PopulateInternalControl; override;
    procedure UpdateInternalControlTextSize; override;
  protected
    function Locked: Boolean;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure PrintSelectedPages;
    procedure RotatePages;

    property LookAndFeel: TcxLookAndFeel read GetLookAndFeel;
    property MaxSize: Integer read GetMaxSize write SetMaxSize;
    property MinSize: Integer read GetMinSize write SetMinSize;
    property SelectedPageIndex: Integer read GetSelectedPageIndex write SetSelectedPageIndex;
    property Size: Integer read GetSize write SetSize;

    property OnCustomDrawPreRenderPage: TdxPDFDocumentViewerOnCustomDrawPreRenderPageEvent read GetOnCustomDrawPreRenderPage
      write SetOnCustomDrawPreRenderPage;
    property OnSizeChanged: TNotifyEvent read GetOnSizeChanged write SetOnSizeChanged;
  end;

  { TdxPDFViewerNavigationPaneViewInfo }

  TdxPDFViewerNavigationPaneViewInfo = class(TdxPDFViewerContainerViewInfo)
  strict private
    FButtonsBounds: TRect;
    FNavigationPane: TdxPDFViewerNavigationPane;
    FPageBounds: TRect;
    FPageButtons: TList<TdxPDFViewerNavigationPanePageButtonViewInfo>;
    FSplitterBounds: TRect;
    FPages: TList<TdxPDFViewerNavigationPanePageViewInfo>;

    function GetActivePage: TdxPDFViewerNavigationPanePageViewInfo;
    function GetButtonsWidth: Integer;
    function GetFirstPageButton: TdxPDFViewerNavigationPanePageButtonViewInfo;
    function GetPageWidth: Integer;
    function ButtonMaxWidth: Integer;
    procedure AddPage(APage: TdxPDFViewerNavigationPanePage);
    procedure CalculateButtonsBounds;
    procedure CalculatePagesBounds;
    procedure CalculateSplitterBounds;
  protected
    function GetContentMargins: TRect; override;
    function GetIndentBetweenElements: Integer; override;
    function MeasureWidth: Integer; override;
    procedure CalculateBounds(const ARect: TRect; out ABounds: TRect); override;
    procedure CalculateContent; override;
    procedure ClearCells; override;
    procedure CreateSubClasses; override;
    procedure CreateCells; override;
    procedure DestroySubClasses; override;
    procedure DrawBackground(ACanvas: TcxCanvas); override;
    procedure DrawChildren(ACanvas: TcxCanvas); override;
    //
    function GetPageIndex(AButton: TdxPDFViewerNavigationPanePageButtonViewInfo): Integer;
    //
    property ActivePage: TdxPDFViewerNavigationPanePageViewInfo read GetActivePage;
    property ButtonsBounds: TRect read FButtonsBounds;
    property FirstPageButton: TdxPDFViewerNavigationPanePageButtonViewInfo read GetFirstPageButton;
    property SplitterBounds: TRect read FSplitterBounds;
  public
    constructor Create(AController: TdxPDFViewerContainerController; ANavigationPane: TdxPDFViewerNavigationPane); reintroduce;
  end;

  { TdxPDFViewerOptionsNavigationPage }

  TdxPDFViewerOptionsNavigationPage = class(TdxPDFViewerOptionsPersistent)
  strict private
    FPage: TdxPDFViewerNavigationPanePage;
    function GetGlyph: TdxSmartGlyph;
    function GetVisible: TdxDefaultBoolean;
    procedure SetGlyph(const AValue: TdxSmartGlyph);
    procedure SetVisible(const AValue: TdxDefaultBoolean);
  protected
    procedure DoAssign(ASource: TPersistent); override;
    property Glyph: TdxSmartGlyph read GetGlyph write SetGlyph;
    property Visible: TdxDefaultBoolean read GetVisible write SetVisible;
  public
    constructor Create(AOwner: TPersistent; APage: TdxPDFViewerNavigationPanePage); reintroduce;
  end;

  { TdxPDFViewerOptionsBookmarks }

  TdxPDFViewerOptionsBookmarks = class(TdxPDFViewerOptionsNavigationPage)
  strict private
    FHideAfterUse: Boolean;
    FTextSize: TdxPDFViewerBookmarksTextSize;
    function GetShowEmpty: Boolean;
    procedure SetHideAfterUse(const AValue: Boolean);
    procedure SetTextSize(const AValue: TdxPDFViewerBookmarksTextSize);
  protected
    procedure DoAssign(ASource: TPersistent); override;
    property ShowEmpty: Boolean read GetShowEmpty;
  published
    property Glyph;
    property HideAfterUse: Boolean read FHideAfterUse write SetHideAfterUse default False;
    property TextSize: TdxPDFViewerBookmarksTextSize read FTextSize write SetTextSize default btsSmall;
    property Visible default bDefault;
  end;

  { TdxPDFViewerOptionsThumbnails }

  TdxPDFViewerOptionsThumbnails = class(TdxPDFViewerOptionsNavigationPage)
  published
    property Glyph;
    property Visible default bDefault;
  end;

  { TdxPDFViewerOptionsAttachments }

  TdxPDFViewerOptionsAttachments = class(TdxPDFViewerOptionsNavigationPage)
  published
    property Glyph;
    property Visible default bDefault;
  end;

  { TdxPDFViewerNavigationPanePage }

  TdxPDFViewerNavigationPanePage = class(TdxPDFViewerCustomObject)
  strict private
    FGlyph: TdxSmartGlyph;
    FOptions: TdxPDFViewerOptionsNavigationPage;
    FVisible: TdxDefaultBoolean;
    function GetBounds: TRect;
    function GetEmpty: Boolean;
    function GetGlyph: TdxSmartGlyph;
    procedure SetGlyph(const AValue: TdxSmartGlyph);
    procedure SetOptions(const AValue: TdxPDFViewerOptionsNavigationPage);
    procedure SetVisible(const AValue: TdxDefaultBoolean);
    procedure OnGlyphChangeHandler(Sender: TObject);
  private
    FControl: TdxPDFViewerNavigationPaneInternalControl;
    FDefaultGlyph: TdxSmartGlyph;
    FViewInfo: TdxPDFViewerNavigationPanePageViewInfo;
  protected
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;

    function CreateViewInfo: TdxPDFViewerNavigationPanePageViewInfo; virtual; abstract;
    function GetCaption: string; virtual; abstract;
    function GetControlClass: TdxPDFViewerNavigationPaneInternalControlClass; virtual; abstract;
    procedure LoadDefaultGlyphs; virtual; abstract;

    function CanShow: Boolean; virtual;
    function CreateOptions: TdxPDFViewerOptionsNavigationPage; virtual;
    procedure SetBounds(const AValue: TRect); virtual;

    function IsFirst: Boolean;
    procedure Clear;
    procedure Refresh;

    property Bounds: TRect read GetBounds write SetBounds;
    property Caption: string read GetCaption;
    property Empty: Boolean read GetEmpty;
    property Glyph: TdxSmartGlyph read GetGlyph write SetGlyph;
    property Options: TdxPDFViewerOptionsNavigationPage read FOptions write SetOptions;
    property ViewInfo: TdxPDFViewerNavigationPanePageViewInfo read FViewInfo;
    property Visible: TdxDefaultBoolean read FVisible write SetVisible;
  end;

  { TdxPDFViewerThumbnails }

  TdxPDFViewerThumbnails = class(TdxPDFViewerNavigationPanePage)
  strict private
    FSizeTrackBar: TcxTrackBar;

    function GetShowHints: Boolean;
    function GetThumbnailPreview: TdxPDFViewerPageThumbnailPreview;
    procedure SetShowHints(const AValue: Boolean);

    procedure CreateSizeTrackBar;
    procedure OnSizeChangedHandler(Sender: TObject);
    procedure OnThumbnailSizeChangedHandler(Sender: TObject);
  protected
    function CanShow: Boolean; override;
    function CreateOptions: TdxPDFViewerOptionsNavigationPage; override;
    function CreateViewInfo: TdxPDFViewerNavigationPanePageViewInfo; override;
    function GetCaption: string; override;
    function GetControlClass: TdxPDFViewerNavigationPaneInternalControlClass; override;
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure LoadDefaultGlyphs; override;
    procedure SetBounds(const AValue: TRect); override;

    function CanEnlargePageThumbnails: Boolean;
    function CanReducePageThumbnails: Boolean;
    procedure SynchronizeSelectedPage;

    property ShowHints: Boolean read GetShowHints write SetShowHints;
    property SizeTrackBar: TcxTrackBar read FSizeTrackBar;
    property ThumbnailPreview: TdxPDFViewerPageThumbnailPreview read GetThumbnailPreview;
  public
    procedure EnlargePageThumbnails;
    procedure PrintPages;
    procedure ReducePageThumbnails;
    procedure RotatePages;
  end;

  { TdxPDFViewerOptionsNavigationPane }

  TdxPDFViewerOptionsNavigationPane = class(TdxPDFViewerOptionsPersistent)
  strict private
    FVisible: Boolean;
    function GetActivePage: TdxPDFViewerNavigationPaneActivePage;
    function GetActivePageState: TWindowState;
    function GetAttachments: TdxPDFViewerOptionsAttachments;
    function GetBookmarks: TdxPDFViewerOptionsBookmarks;
    function GetThumbnails: TdxPDFViewerOptionsThumbnails;
    procedure SetActivePage(const AValue: TdxPDFViewerNavigationPaneActivePage);
    procedure SetActivePageState(const AValue: TWindowState);
    procedure SetAttachments(const AValue: TdxPDFViewerOptionsAttachments);
    procedure SetBookmarks(const AValue: TdxPDFViewerOptionsBookmarks);
    procedure SetThumbnails(const AValue: TdxPDFViewerOptionsThumbnails);
    procedure SetVisible(const AValue: Boolean);
  protected
    procedure DoAssign(ASource: TPersistent); override;
  public
    property ActivePage: TdxPDFViewerNavigationPaneActivePage read GetActivePage write SetActivePage default apNone;
    property ActivePageState: TWindowState read GetActivePageState write SetActivePageState default wsMinimized;
  published
    property Attachments: TdxPDFViewerOptionsAttachments read GetAttachments write SetAttachments;
    property Bookmarks: TdxPDFViewerOptionsBookmarks read GetBookmarks write SetBookmarks;
    property Thumbnails: TdxPDFViewerOptionsThumbnails read GetThumbnails write SetThumbnails;
    property Visible: Boolean read FVisible write SetVisible default False;
  end;

  { TdxPDFViewerBookmarks }

  TdxPDFViewerBookmarks = class(TdxPDFViewerNavigationPanePage)
  strict private
    FExpandBookmarkGlyph: TdxSmartGlyph;
    function GetTree: TdxPDFViewerBookmarkTreeView;
  protected
    function CanShow: Boolean; override;
    function CreateOptions: TdxPDFViewerOptionsNavigationPage; override;
    function CreateViewInfo: TdxPDFViewerNavigationPanePageViewInfo; override;
    function GetCaption: string; override;
    function GetControlClass: TdxPDFViewerNavigationPaneInternalControlClass; override;
    procedure DestroySubClasses; override;
    procedure LoadDefaultGlyphs; override;

    function CanExpandCurrentBookmark: Boolean;
    function IsBookmarkSelected: Boolean;
    function IsTopLevelBookmarksExpanded: Boolean;

    property ExpandBookmarkGlyph: TdxSmartGlyph read FExpandBookmarkGlyph;
    property Tree: TdxPDFViewerBookmarkTreeView read GetTree;
  public
    procedure ExpandCollapseTopLevelBookmarks;
    procedure ExpandCurrentBookmark;
    procedure GoToBookmark;
    procedure PrintPages;
    procedure PrintSections;
  end;

  { TdxPDFViewerAttachments }

  TdxPDFViewerAttachments = class(TdxPDFViewerNavigationPanePage)
  strict private
    FOpenAttachmentGlyph: TdxSmartGlyph;
    FSaveAttachmentGlyph: TdxSmartGlyph;
    FShowHints: Boolean;
    //
    function GetFileList: TdxPDFViewerAttachmentFileList;
    function GetSelectedAttachment: TdxPDFFileAttachment;
    procedure SetShowHints(const AValue: Boolean);
  protected
    function CanShow: Boolean; override;
    function CreateOptions: TdxPDFViewerOptionsNavigationPage; override;
    function CreateViewInfo: TdxPDFViewerNavigationPanePageViewInfo; override;
    function GetCaption: string; override;
    function GetControlClass: TdxPDFViewerNavigationPaneInternalControlClass; override;
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure LoadDefaultGlyphs; override;
    //
    property OpenAttachmentGlyph: TdxSmartGlyph read FOpenAttachmentGlyph;
    property SaveAttachmentGlyph: TdxSmartGlyph read FSaveAttachmentGlyph;
    property SelectedAttachment: TdxPDFFileAttachment read GetSelectedAttachment;
    property ShowHints: Boolean read FShowHints write SetShowHints;
  public
    function HasAttachments: Boolean;
    procedure OpenAttachment;
    procedure SaveAttachment;
    //
    property FileList: TdxPDFViewerAttachmentFileList read GetFileList;
  end;

  { TdxPDFViewerNavigationPane }

  TdxPDFViewerNavigationPane = class(TcxIUnknownObject, IcxFontListener)
  strict private
    FMaximizeButtonGlyph: TdxSmartGlyph;
    FMenuButtonGlyph: TdxSmartGlyph;
    FMinimizeButtonGlyph: TdxSmartGlyph;
    FRestoreButtonGlyph: TdxSmartGlyph;

    FActivePage: TdxPDFViewerNavigationPanePage;
    FActivePageState: TWindowState;
    FAttachments: TdxPDFViewerAttachments;
    FBookmarks: TdxPDFViewerBookmarks;
    FController: TdxPDFViewerNavigationPaneController;
    FFont: TFont;
    FHitTest: TdxPDFViewerNavigationPaneHitTest;
    FOptions: TdxPDFViewerOptionsNavigationPane;
    FPages: TObjectList<TdxPDFViewerNavigationPanePage>;
    FPageSize: Integer;
    FPrevActivePageState: TWindowState;
    FShowHints: Boolean;
    FThumbnails: TdxPDFViewerThumbnails;
    FViewer: TdxPDFCustomViewer;
    FViewInfo: TdxPDFViewerNavigationPaneViewInfo;
    FVisiblePages: TList<TdxPDFViewerNavigationPanePage>;

    function GetActivePageType: TdxPDFViewerNavigationPaneActivePage;
    function GetMaximizeButtonGlyph: TdxSmartGlyph;
    function GetVisiblePages: TList<TdxPDFViewerNavigationPanePage>;
    procedure SetActivePage(const AValue: TdxPDFViewerNavigationPanePage);
    procedure SetActivePageType(const AValue: TdxPDFViewerNavigationPaneActivePage);
    procedure SetActivePageState(const AValue: TWindowState);
    procedure SetOptions(const AValue: TdxPDFViewerOptionsNavigationPane);
    procedure SetPageSize(const AValue: Integer);
    procedure SetShowHints(const AValue: Boolean);
    procedure Changed(Sender: TObject; AFont: TFont); overload;
    procedure LoadGlyphs;
    procedure UpdateVisiblePages;
  protected
    function CanShow: Boolean;
    function CalculateParentClientBounds(const AClientRect: TRect): TRect;
    function IsFirst(APage: TdxPDFViewerNavigationPanePage): Boolean;
    function IsVisible(APage: TdxPDFViewerNavigationPanePage): Boolean;
    function IsMaximized: Boolean;
    function MeasureWidth: Integer;
    procedure AddPages;
    procedure ActivatePage;
    procedure Changed; overload;
    procedure Clear;
    procedure MaximizePage;
    procedure MinimizePage;
    procedure RestorePage;
    procedure Refresh(ASaveActivePageState: Boolean = False);
    procedure VisibilityChanged(APage: TdxPDFViewerNavigationPanePage);
    //
    property Controller: TdxPDFViewerNavigationPaneController read FController;
    property HitTest: TdxPDFViewerNavigationPaneHitTest read FHitTest;
    property ViewInfo: TdxPDFViewerNavigationPaneViewInfo read FViewInfo;
    //
    property MaximizeButtonGlyph: TdxSmartGlyph read GetMaximizeButtonGlyph;
    property MenuButtonGlyph: TdxSmartGlyph read FMenuButtonGlyph;
    property MinimizeButtonGlyph: TdxSmartGlyph read FMinimizeButtonGlyph;
    property RestoreButtonGlyph: TdxSmartGlyph read FRestoreButtonGlyph;
    //
    property ActivePageType: TdxPDFViewerNavigationPaneActivePage read GetActivePageType write SetActivePageType;
    property Font: TFont read FFont;
    property Options: TdxPDFViewerOptionsNavigationPane read FOptions write SetOptions;
    property Pages: TObjectList<TdxPDFViewerNavigationPanePage> read FPages;
    property PageSize: Integer read FPageSize write SetPageSize;
    property ShowHints: Boolean read FShowHints write SetShowHints;
    property Thumbnails: TdxPDFViewerThumbnails read FThumbnails;
    property VisiblePages: TList<TdxPDFViewerNavigationPanePage> read GetVisiblePages;
  public
    constructor Create(AViewer: TdxPDFCustomViewer);
    destructor Destroy; override;
    //
    property ActivePage: TdxPDFViewerNavigationPanePage read FActivePage write SetActivePage;
    property ActivePageState: TWindowState read FActivePageState write SetActivePageState;
    property Attachments: TdxPDFViewerAttachments read FAttachments;
    property Bookmarks: TdxPDFViewerBookmarks read FBookmarks;
  end;

procedure ShowPrintDialog(AViewer: TdxPDFCustomViewer);

procedure dxPDFViewerRegisterDocumentObjectViewInfo(AClass: TClass; AViewInfoClass: TdxPDFViewerDocumentObjectViewInfoClass); // for internal use
procedure dxPDFViewerUnregisterDocumentObjectViewInfo(AClass: TClass); // for internal use

implementation

{$R dxPDFViewer.res}
{$R dxPDFViewer_svg.res}

uses
  RTLConsts, Math, Clipbrd, Variants, Contnrs, Dialogs, ShellApi, IOUtils, dxTypeHelpers, cxLibraryConsts, dxPrinting,
  dxGDIPlusAPI, dxGenerics, cxVariants, cxContainer, cxDropDownEdit, cxSplitter, dxShellDialogs, dxMessageDialog,
  dxPDFUtils, dxPDFViewerPopupMenu, dxPDFViewerPasswordDialog, dxPDFViewerRotatePagesDialog, dxPDFViewerDialogsStrs,
  dxPDFViewerAnnotations, dxPDFViewerEditors;

const
  dxThisUnitName = 'dxPDFViewer';

const
  dxPDFViewerViewCreationTimeOut = 2000;

const
  dxPDFViewerFindPanelContentMargins: TRect = (Left: 9; Top: 9; Right: 9; Bottom: 9);
  dxPDFViewerFindPanelDefaultButtonWidth = 79;
  dxPDFViewerFindPanelEditMaxWidth = 150;
  dxPDFViewerFindPanelEditMinWidth = 40;
  dxPDFViewerIndentBetweenElements = 6;
  dxPDFViewerNavigationPaneContentMargins: TRect = (Left: 2; Top: 2; Right: 2; Bottom: 2);
  dxPDFViewerNavigationPageToolbarButtonHeight = 26;
  dxPDFViewerBookmarksPageContentMargins: TRect = (Left: 7; Top: 7; Right: 7; Bottom: 7);

type
  TcxScrollingControlAccess = class(TcxScrollingControl);
  TcxCustomEditStyleAccess = class(TcxCustomEditStyle);
  TdxCustomPreviewAccess = class(TdxCustomPreview);
  TdxPDFCustomActionAccess = class(TdxPDFCustomAction);
  TdxPDFCustomFieldAccess = class(TdxPDFCustomField);
  TdxPDFCustomWidgetAccess = class(TdxPDFCustomWidget);
  TdxPDFCustomSelectionAccess = class(TdxPDFCustomSelection);
  TdxPDFDocumentAccess = class(TdxPDFDocument);
  TdxPDFDocumentOutlineTreeAccess = class(TdxPDFDocumentOutlineList);
  TdxPDFDocumentOutlineTreeItemAccess = class(TdxPDFDocumentOutlineItem);
  TdxPDFDocumentCustomViewerPageAccess = class(TdxPDFDocumentCustomViewerPage);
  TdxPDFDocumentSequentialTextSearchAccess = class(TdxPDFDocumentSequentialTextSearch);
  TdxPDFDocumentViewerCustomRendererAccess = class(  TdxPDFDocumentViewerCustomRenderer);
  TdxPDFFileAttachmentAccess = class(TdxPDFFileAttachment);
  TdxPDFFormAccess = class(TdxPDFForm);
  TdxPDFHyperlinkAccess = class(TdxPDFHyperlink);
  TdxPDFHyperlinkListAccess = class(TdxPDFHyperlinkList);
  TdxPDFImageAccess = class(TdxPDFImage);
  TdxPDFImageListAccess = class(TdxPDFImageList);
  TdxPDFImageSelectionAccess = class(TdxPDFImageSelection);
  TdxPDFPageAccess = class(TdxPDFPage);
  TdxPDFPagesAccess = class(TdxPDFPages);
  TdxPDFRecognizedImageAccess = class(TdxPDFImage);
  TdxPDFTextHighlightAccess = class(TdxPDFTextHighlight);
  TdxPDFTextLineAccess = class(TdxPDFTextLine);
  TdxPDFTextObjectAccess = class(TdxPDFTextObject);
  TdxPDFTextWordAccess = class(TdxPDFTextWord);
  TdxPDFTextWordPartAccess = class(TdxPDFTextWordPart);
  TdxPDFViewerAccess = class(TdxPDFCustomViewer);
  TdxPDFViewerFileAttachmentViewInfoAccess = class(TdxPDFViewerFileAttachmentViewInfo);
  TdxPDFViewerPopupMenuAccess = class(TdxPDFViewerCustomPopupMenu);
  TdxPreviewPageListAccess = class(TdxPreviewPageList);
  TdxSplitterDragImageAccess = class(TdxSplitterDragImage);
  TdxListViewControlAccess = class(TdxListViewControl);

  {TdxPDFViewerAutomaticLayoutCalculator }

  TdxPDFViewerAutomaticLayoutCalculator = class(TdxPDFViewerCustomLayoutCalculator)
  public
    procedure ScrollContent(const AOffset: TPoint); override;
  end;

  { TdxPDFViewerColumnContinuousCalculator }

  TdxPDFViewerColumnContinuousCalculator = class(TdxPDFViewerCustomLayoutCalculator)
  strict private
    FColumnCount: Integer;
  strict protected
    function CanAddRow(AColumnIndex: Integer; const ABounds: TRect; const APageSize: TPoint): Boolean; override;
    procedure AlignPagesToHorizontalCenter(const ABounds: TRect); override;
  public
    constructor Create(APreview: TdxCustomPreview; AColumnCount: Integer); reintroduce;

    procedure ScrollContent(const AOffset: TPoint); override;
  end;

  { TdxPDFViewerResizeNavigationPaneDragAndDropObject }

  TdxPDFViewerResizeNavigationPaneDragAndDropObject = class(TcxDragAndDropObject)
  strict private
    function GetClientBounds: TRect;
    function GetDragDropArea: TRect;
    function GetDragImageBounds: TRect;
    function GetNavigationPane: TdxPDFViewerNavigationPane;
    function GetPadding: Integer;
    function GetViewer: TdxPDFCustomViewer;
    function GetViewInfo: TdxPDFViewerNavigationPaneViewInfo;
  protected
    FDragImage: TdxSplitterDragImage;
    FStartMousePos: TPoint;
    //
    function GetDragAndDropCursor(Accepted: Boolean): TCursor; override;
    function GetImmediateStart: Boolean; override;
    procedure BeginDragAndDrop; override;
    procedure DragAndDrop(const P: TPoint; var Accepted: Boolean); override;
    procedure EndDragAndDrop(Accepted: Boolean); override;
    //
    property ClientBounds: TRect read GetClientBounds;
    property NavigationPane: TdxPDFViewerNavigationPane read GetNavigationPane;
    property ViewInfo: TdxPDFViewerNavigationPaneViewInfo read GetViewInfo;
  public
    destructor Destroy; override;
  end;

  { TdxPDFFileAttachmentComparer }

  TdxPDFFileAttachmentComparer = class(TInterfacedObject, IComparer<TdxPDFFileAttachment>) // for internal use
  strict private
    function Compare(const Left, Right: TdxPDFFileAttachment): Integer;
  end;

  { TdxPDFViewerCustomHintHelper }

  TdxPDFViewerCustomHintHelper = class(TcxControlHintHelper)
  strict private
    FViewer: TdxPDFCustomViewer;
  protected
    function GetOwnerControl: TcxControl; override;
    procedure CorrectHintWindowRect(var ARect: TRect); override;
    //
    function GetHintOffset: TPoint; virtual;
    //
    property Viewer: TdxPDFCustomViewer read FViewer;
  public
    constructor Create(AViewer: TdxPDFCustomViewer); virtual;
  end;

  { TdxPDFViewerNavigationPaneHintHelper }

  TdxPDFViewerNavigationPaneHintHelper = class(TdxPDFViewerCustomHintHelper)
  protected
    function IsHintWindowVisible: Boolean;
  end;

  { TInteractiveObjectHinHelper }

  TdxPDFViewerHintableObjectHintHelper = class(TdxPDFViewerCustomHintHelper)
  private
    FShowingTimer: TcxTimer;
    //
    procedure ShowingTimerHandler(Sender: TObject);
  protected
    function CanShowHint: Boolean; override;
    function GetHintOffset: TPoint; override;
    procedure MouseLeave; override;
    //
    procedure EnableShowing;
  public
    constructor Create(AViewer: TdxPDFCustomViewer); override;
    destructor Destroy; override;
    //
    procedure MouseDown; override;
  end;

  { TdxPDFViewerDocumentObjectViewInfoDictionary }

  TdxPDFViewerDocumentObjectViewInfoDictionary = class(TdxClassDictionary<TdxPDFViewerDocumentObjectViewInfoClass>);

var
  dxgPDFViewerDocumentObjectViewInfoDictionary: TdxPDFViewerDocumentObjectViewInfoDictionary;

function dxPDFViewerDocumentObjectViewInfoDictionary: TdxPDFViewerDocumentObjectViewInfoDictionary;
begin
  if dxgPDFViewerDocumentObjectViewInfoDictionary = nil then
    dxgPDFViewerDocumentObjectViewInfoDictionary := TdxPDFViewerDocumentObjectViewInfoDictionary.Create;
  Result := dxgPDFViewerDocumentObjectViewInfoDictionary;
end;

procedure dxPDFViewerRegisterDocumentObjectViewInfo(AClass: TClass; AViewInfoClass: TdxPDFViewerDocumentObjectViewInfoClass);
begin
  dxPDFViewerDocumentObjectViewInfoDictionary.AddOrSetValue(AClass, AViewInfoClass);
end;

procedure dxPDFViewerUnregisterDocumentObjectViewInfo(AClass: TClass);
begin
  if dxgPDFViewerDocumentObjectViewInfoDictionary <> nil then
    dxgPDFViewerDocumentObjectViewInfoDictionary.Remove(AClass);
end;

{ TdxPDFViewerCustomLayoutCalculator }

function TdxPDFViewerCustomLayoutCalculator.GetContentHeight: Integer;
begin
  Result := Viewer.AbsoluteIndent;
  if PageCount > 0 then
    Inc(Result, Pages.Bounds.Height);
end;

function TdxPDFViewerCustomLayoutCalculator.GetContentWidth: Integer;
begin
  if (PageCount = 0) or (ZoomMode = pzmPageWidth) then
    Result := Viewer.ClientWidth
  else
    Result := Viewer.AbsoluteIndent + Pages.Bounds.Width;
end;

function TdxPDFViewerCustomLayoutCalculator.GetPageSiteBounds(APageIndex: Integer): TRect;
begin
  Result := Pages[APageIndex].Bounds;
end;

procedure TdxPDFViewerCustomLayoutCalculator.CalculateVisiblePageRange(out AStartIndex, AEndIndex: Integer);
var
  APageCount: Integer;
begin
  APageCount := PageCount;
  AEndIndex := -1;
  AStartIndex := -1;
  if APageCount > 0 then
  begin
    AStartIndex := 0;
    while (AStartIndex < PageCount) and not Pages.Items[AStartIndex].PartVisible do
      Inc(AStartIndex);

    if AStartIndex = APageCount then
    begin
      AStartIndex := 0;
      AEndIndex := APageCount - 1;
    end
    else
    begin
      AEndIndex := AStartIndex;
      while (AEndIndex < APageCount) and Pages.Items[AEndIndex].PartVisible do
        Inc(AEndIndex);
      Dec(AEndIndex);
    end;
  end;
end;

procedure TdxPDFViewerCustomLayoutCalculator.CalculateZoomFactorForPageWidthPreviewZoomMode(
  AFirstPageIndex, ALastPageIndex: Integer);

  function GetMaxPageSize(AFirstIndex, ALastIndex: Integer): Integer;
  var
    I: Integer;
  begin
    Result := 0;
    for I := AFirstIndex to ALastIndex do
      Result := Max(Result, ScaleFactor.Apply(Pages[I].PageSize.ActualSizeInPixels.X));
  end;

begin
  ZoomFactor := GetZoomFactorForPageWidthPreviewZoomMode(AFirstPageIndex, ALastPageIndex);
end;

procedure TdxPDFViewerCustomLayoutCalculator.CalculateZoomFactorForPagesPreviewZoomMode(
  AFirstPageIndex, ALastPageIndex: Integer);
var
  AZoomFactorForPagesMode: Integer;
  AZoomFactorForPageWidthMode: Integer;
begin
  AZoomFactorForPagesMode := Floor(PagesArea.Height / ScaleFactor.Apply(Viewer.ActivePage.PageSize.ActualSizeInPixels.Y) * 100);
  AZoomFactorForPageWidthMode := GetZoomFactorForPageWidthPreviewZoomMode(AFirstPageIndex, ALastPageIndex);
  ZoomFactor := Min(AZoomFactorForPagesMode, AZoomFactorForPageWidthMode);
end;

procedure TdxPDFViewerCustomLayoutCalculator.CalculatePages;
var
  ALeftTop: TPoint;
begin
  if not Viewer.IsUpdateLocked and Viewer.IsDocumentAvailable then
  begin
    PagesRows.Clear;
    InternalCalculatePages;
    if Viewer.IsZoomingLocked then
    begin
      CalculateScrollBarPosition(ALeftTop);
      ActivateVisiblePage(False);
      Viewer.SetLeftTop(ALeftTop, False);
    end;
  end;
end;

procedure TdxPDFViewerCustomLayoutCalculator.ScrollContent(const AOffset: TPoint);
begin
  OffsetContent(AOffset);
  Viewer.ViewInfo.Offset(AOffset);
  Viewer.UpdateRenderQueue;
  Viewer.UpdateScrollBars;
  Viewer.Invalidate;
end;

procedure TdxPDFViewerCustomLayoutCalculator.ZoomContent;
begin
  if Viewer.ViewerController <> nil then
    Viewer.ViewerController.ViewStateHistoryController.StoreCurrentViewState(vsctZooming);
end;

function TdxPDFViewerCustomLayoutCalculator.GetCurrentPageCenterRect: TRect;
var
  ACenterPoint: TPoint;
begin
  if Viewer.IsDocumentAvailable then
  begin
    ACenterPoint := CurrentPageRect.CenterPoint;
    Result := cxRect(ACenterPoint, ACenterPoint)
  end
  else
    Result := cxInvalidRect;
end;

function TdxPDFViewerCustomLayoutCalculator.GetPageIndexByRect(const ARect: TRect): Integer;
var
  I: Integer;
  APageRect: TRect;
begin
  Result := CurrentPageIndex;
  for I := 0 to PageCount - 1 do
  begin
    APageRect := Pages[I].Bounds;
    if APageRect.IntersectsWith(ARect) then
    begin
      Result := I;
      Break;
    end;
  end;
end;

function TdxPDFViewerCustomLayoutCalculator.GetVisibleSelectedPageIndex: Integer;
begin
  Pages.GetVisibleSelectedPageIndex(Result);
end;

procedure TdxPDFViewerCustomLayoutCalculator.ActivateCurrentPage;
begin
  MoveTo(GetCurrentPageCenterRect);
end;

procedure TdxPDFViewerCustomLayoutCalculator.ActivateVisiblePage(ACheckZoomLocking: Boolean = True);
begin
  if not Viewer.IsZoomingLocked or not ACheckZoomLocking then
    Viewer.SetSelPageIndex(GetVisibleSelectedPageIndex);
end;

procedure TdxPDFViewerCustomLayoutCalculator.MoveTo(const APoint: TPoint);
begin
  MoveTo(cxRect(APoint, APoint));
end;

procedure TdxPDFViewerCustomLayoutCalculator.MoveTo(const ARect: TRect);
begin
  if Viewer.IsDocumentAvailable then
  begin
    Viewer.ViewerController.MakeRectVisible(ARect);
    Viewer.UpdateScrollBars;
  end;
end;

procedure TdxPDFViewerCustomLayoutCalculator.SetCurrentPageByRect(const ARect: TRect);
begin
  Viewer.SetSelPageIndex(GetPageIndexByRect(ARect));
end;

function TdxPDFViewerCustomLayoutCalculator.GetScrollStep: Integer;
begin
  Result := dxPDFViewerDefaultScrollStep;
end;

procedure TdxPDFViewerCustomLayoutCalculator.InternalCalculatePages;
begin
  inherited CalculatePages;
end;

procedure TdxPDFViewerCustomLayoutCalculator.CalculateScrollBarPosition(var ALeftTop: TPoint);
var
  AScale: Single;
  ADelta, AZoomPoint: TdxPointF;
  AAnchorPoint: TPoint;
begin
  AAnchorPoint := Viewer.GetMouseCursorClientPos;
  Viewer.HitTest.Calculate(AAnchorPoint);
  if not Viewer.HitTest.HitAtDocumentViewer then
    AAnchorPoint := cxPoint(Viewer.GetPagesArea.Width div 2, Viewer.GetPagesArea.Height div 2);
  AZoomPoint := cxPointF(AAnchorPoint);
  if Viewer.PrevZoomFactor <> 0 then
  begin
    AScale := Viewer.ZoomFactor / Viewer.PrevZoomFactor;
    ADelta.X := (Viewer.LeftPos + AZoomPoint.X) * AScale;
    ADelta.Y := (Viewer.TopPos + AZoomPoint.Y) * AScale;
  end
  else
    ADelta := cxPointF(cxNullPoint);
  ALeftTop.X := TdxPDFUtils.ConvertToInt(ADelta.X - AZoomPoint.X);
  ALeftTop.Y := TdxPDFUtils.ConvertToInt(ADelta.Y - AZoomPoint.Y);
end;

function TdxPDFViewerCustomLayoutCalculator.GetCurrentPageIndex: Integer;
begin
  Result := Viewer.SelPageIndex;
end;

function TdxPDFViewerCustomLayoutCalculator.GetCurrentPageRect: TRect;
begin
  Result := Viewer.ActivePage.Bounds;
end;

function TdxPDFViewerCustomLayoutCalculator.GetViewer: TdxPDFCustomViewer;
begin
  Result := Preview as TdxPDFCustomViewer;
end;

function TdxPDFViewerCustomLayoutCalculator.GetZoomFactorForPageWidthPreviewZoomMode(
  AFirstPageIndex, ALastPageIndex: Integer): Integer;

  function GetMaxPageSize(AFirstIndex, ALastIndex: Integer): Integer;
  var
    I: Integer;
  begin
    Result := 0;
    for I := AFirstIndex to ALastIndex do
      Result := Max(Result, ScaleFactor.Apply(Pages[I].PageSize.ActualSizeInPixels.X));
  end;

begin
  Result := Floor(PagesArea.Width / GetMaxPageSize(0, PageCount - 1) * 100);
end;

{ TdxPDFViewerAutomaticLayoutCalculator }

procedure TdxPDFViewerAutomaticLayoutCalculator.ScrollContent(const AOffset: TPoint);
begin
  inherited ScrollContent(AOffset);
  ActivateVisiblePage;
end;

{ TdxPDFViewerColumnContinuousCalculator }

constructor TdxPDFViewerColumnContinuousCalculator.Create(APreview: TdxCustomPreview; AColumnCount: Integer);
begin
  inherited Create(APreview);
  FColumnCount := AColumnCount;
end;

procedure TdxPDFViewerColumnContinuousCalculator.ScrollContent(const AOffset: TPoint);
begin
  inherited ScrollContent(AOffset);
  ActivateVisiblePage;
end;

function TdxPDFViewerColumnContinuousCalculator.CanAddRow(AColumnIndex: Integer; const ABounds: TRect;
  const APageSize: TPoint): Boolean;
begin
  Result := AColumnIndex = FColumnCount;
end;

procedure TdxPDFViewerColumnContinuousCalculator.AlignPagesToHorizontalCenter(const ABounds: TRect);
var
  I, ABoundsWidth: Integer;
  ACenterPoint: TPoint;
  APage: TdxPreviewPage;
begin
  dxTestCheck(PagesRows.Count = PageCount, 'PagesRows.Count <> PageCount');
  ACenterPoint := cxNullPoint;
  ABoundsWidth := ABounds.Width;
  for I := 0 to PageCount - 1 do
  begin
    TdxPreviewPageListAccess(Pages).CenterPagesInRow(PagesRows[I], ABoundsWidth);
    ACenterPoint.X := Max(Pages[I].Bounds.CenterPoint.X, ACenterPoint.X);
  end;
  for I := 0 to PageCount - 1 do
  begin
    APage := Pages[I];
    APage.Bounds.Offset(ACenterPoint.X - APage.Bounds.CenterPoint.X, 0);
  end;
end;

{ TdxPDFViewerResizeNavigationPaneDragAndDropObject }

destructor TdxPDFViewerResizeNavigationPaneDragAndDropObject.Destroy;
begin
  FreeAndNil(FDragImage);
  inherited Destroy;
end;

procedure TdxPDFViewerResizeNavigationPaneDragAndDropObject.BeginDragAndDrop;
begin
  FStartMousePos := GetMouseCursorPos;
  FDragImage := TdxSplitterDragImage.Create;
  TdxSplitterDragImageAccess(FDragImage).Canvas.Brush.Bitmap := AllocPatternBitmap(clBlack, clWhite);
  NavigationPane.RestorePage;
  FDragImage.BoundsRect := GetDragImageBounds;
  FDragImage.Show;
end;

procedure TdxPDFViewerResizeNavigationPaneDragAndDropObject.DragAndDrop(const P: TPoint; var Accepted: Boolean);
var
  ADragDropArea: TRect;
begin
  ADragDropArea := GetDragDropArea;
  Accepted := InRange(P.X, ADragDropArea.Left, ADragDropArea.Right);
  FDragImage.BoundsRect := GetDragImageBounds;
  inherited;
end;

procedure TdxPDFViewerResizeNavigationPaneDragAndDropObject.EndDragAndDrop(Accepted: Boolean);
const
  Sign: array[Boolean] of Integer = (-1, 1);
var
  R: TRect;
begin
  if Accepted then
  begin
    R := cxRectOffset(GetDragImageBounds, Control.ClientToScreen(cxNullPoint), False);
    if R.Right = ClientBounds.Right then
      NavigationPane.MaximizePage
    else
      if R.Left = ViewInfo.ButtonsBounds.Right then
        NavigationPane.MinimizePage
      else
        NavigationPane.PageSize := NavigationPane.PageSize + (R.Left - ViewInfo.SplitterBounds.Left) * Sign[True];
  end;
  inherited EndDragAndDrop(Accepted);
end;

function TdxPDFViewerResizeNavigationPaneDragAndDropObject.GetClientBounds: TRect;
begin
  Result := GetViewer.ClientBounds;
end;

function TdxPDFViewerResizeNavigationPaneDragAndDropObject.GetDragDropArea: TRect;
var
  APadding: Integer;
begin
  APadding := GetPadding;
  Result.Left := ViewInfo.ButtonsBounds.Right + APadding;
  Result.Right := ClientBounds.Right - APadding;
end;

function TdxPDFViewerResizeNavigationPaneDragAndDropObject.GetDragAndDropCursor(Accepted: Boolean): TCursor;
begin
  Result := crcxHorzSize;
end;

function TdxPDFViewerResizeNavigationPaneDragAndDropObject.GetDragImageBounds: TRect;
var
  R: TRect;
  AOffset: TPoint;
begin
  AOffset := cxPointOffset(GetMouseCursorPos, FStartMousePos, False);
  Result := cxRectOffset(ViewInfo.SplitterBounds, Control.ClientToScreen(cxNullPoint));
  R := cxRectOffset(GetDragDropArea, Control.ClientToScreen(cxNullPoint));
  Result := cxRectOffset(Result, AOffset.X, 0);
  if Result.Left < R.Left then
    Result := cxRectSetLeft(Result, R.Left - GetPadding)
  else
    if Result.Right > R.Right then
      Result := cxRectSetRight(Result, R.Right + GetPadding);
end;

function TdxPDFViewerResizeNavigationPaneDragAndDropObject.GetNavigationPane: TdxPDFViewerNavigationPane;
begin
  Result := GetViewer.NavigationPane
end;

function TdxPDFViewerResizeNavigationPaneDragAndDropObject.GetPadding: Integer;
begin
  Result := GetViewer.ScaleFactor.Apply(50);
end;

function TdxPDFViewerResizeNavigationPaneDragAndDropObject.GetViewer: TdxPDFCustomViewer;
begin
  Result := TdxPDFCustomViewer(Control);
end;

function TdxPDFViewerResizeNavigationPaneDragAndDropObject.GetViewInfo: TdxPDFViewerNavigationPaneViewInfo;
begin
  Result := GetViewer.NavigationPane.ViewInfo;
end;

function TdxPDFViewerResizeNavigationPaneDragAndDropObject.GetImmediateStart: Boolean;
begin
  Result := True;
end;

procedure ShowPrintDialog(AViewer: TdxPDFCustomViewer);
begin
  dxPrintingRepository.PrintReport(AViewer);
end;

{ TdxPDFFileAttachmentComparer }

function TdxPDFFileAttachmentComparer.Compare(const Left, Right: TdxPDFFileAttachment): Integer;
begin
  Result := CompareStr(Left.FileName, Right.FileName);
end;

{ TdxPDFViewerCustomHintHelper }

constructor TdxPDFViewerCustomHintHelper.Create(AViewer: TdxPDFCustomViewer);
begin
  inherited Create;
  FViewer := AViewer;
end;

function TdxPDFViewerCustomHintHelper.GetOwnerControl: TcxControl;
begin
  Result := FViewer;
end;

procedure TdxPDFViewerCustomHintHelper.CorrectHintWindowRect(var ARect: TRect);
var
  AOffset: TPoint;
begin
  inherited;
  ARect := cxRectSetOrigin(ARect, GetMouseCursorPos);
  AOffset := GetHintOffset;
  OffsetRect(ARect, AOffset.X, AOffset.Y);
end;

function TdxPDFViewerCustomHintHelper.GetHintOffset: TPoint;
begin
  Result := cxPoint(0, cxGetCursorSize.cy);
end;

{ TdxPDFViewerNavigationPaneHintHelper }

function TdxPDFViewerNavigationPaneHintHelper.IsHintWindowVisible: Boolean;
begin
  Result := (HintWindow <> nil) and HintWindow.HandleAllocated and IsWindowVisible(HintWindow.Handle);
end;

{ TdxPDFViewerHintableObjectHintHelper }

constructor TdxPDFViewerHintableObjectHintHelper.Create(AViewer: TdxPDFCustomViewer);
begin
  inherited Create(AViewer);
  FShowingTimer := cxCreateTimer(ShowingTimerHandler, 1000, False);
end;

destructor TdxPDFViewerHintableObjectHintHelper.Destroy;
begin
  FreeAndNil(FShowingTimer);
  inherited Destroy;
end;

procedure TdxPDFViewerHintableObjectHintHelper.MouseDown;
begin
  FShowingTimer.Enabled := False;
  inherited MouseDown;
  ResetLastHintElement;
end;

function TdxPDFViewerHintableObjectHintHelper.CanShowHint: Boolean;
begin
  Result := Viewer.OptionsBehavior.ShowHints and Viewer.HitTest.CanShowHint;
end;

function TdxPDFViewerHintableObjectHintHelper.GetHintOffset: TPoint;
begin
  Result := inherited GetHintOffset;
  Inc(Result.Y, Viewer.ScaleFactor.Apply(5));
end;

procedure TdxPDFViewerHintableObjectHintHelper.MouseLeave;
begin
// do nothing
end;

procedure TdxPDFViewerHintableObjectHintHelper.EnableShowing;
begin
  FShowingTimer.Enabled := True;
end;

procedure TdxPDFViewerHintableObjectHintHelper.ShowingTimerHandler(Sender: TObject);
var
  ABounds: TRect;
begin
  ABounds := Viewer.HitTest.GetHintBounds;
  if not cxRectIsEmpty(ABounds) then
  begin
    ShowHint(ABounds, ABounds, Viewer.HitTest.GetHintText, False, Self, Viewer.Font);
    FShowingTimer.Enabled := False;
  end;
end;

{ TdxPDFViewerOptionsPersistent }

constructor TdxPDFViewerOptionsPersistent.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  Initialize;
end;

procedure TdxPDFViewerOptionsPersistent.Assign(Source: TPersistent);
begin
  if Source is TcxOwnedPersistent then
  begin
    Viewer.BeginUpdate;
    try
      DoAssign(Source);
    finally
      Viewer.EndUpdate;
    end;
  end
  else
    inherited;
end;

procedure TdxPDFViewerOptionsPersistent.Initialize;
begin
// do nothing
end;

procedure TdxPDFViewerOptionsPersistent.Changed;
begin
  Changed(ctLight);
end;

procedure TdxPDFViewerOptionsPersistent.Changed(AType: TdxChangeType);
begin
  Viewer.LayoutChanged(AType);
end;

function TdxPDFViewerOptionsPersistent.GetViewer: TdxPDFCustomViewer;
begin
  Result := Owner as TdxPDFCustomViewer;
end;

{ TdxPDFViewerOptionsBehavior }

constructor TdxPDFViewerOptionsBehavior.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FShowHints := True;
end;

procedure TdxPDFViewerOptionsBehavior.DoAssign(ASource: TPersistent);
var
  ASourceOptions: TdxPDFViewerOptionsBehavior;
begin
  ASourceOptions := ASource as TdxPDFViewerOptionsBehavior;
  RenderContentDelay := ASourceOptions.RenderContentDelay;
  RenderContentInBackground := ASourceOptions.RenderContentInBackground;
end;

function TdxPDFViewerOptionsBehavior.GetRenderContentDelay: Integer;
begin
  Result := Viewer.RenderContentDelay;
end;

function TdxPDFViewerOptionsBehavior.GetRenderContentInBackground: Boolean;
begin
  Result := Viewer.RenderContentInBackground;
end;

procedure TdxPDFViewerOptionsBehavior.SetRenderContentDelay(const AValue: Integer);
begin
  Viewer.RenderContentDelay := AValue;
end;

procedure TdxPDFViewerOptionsBehavior.SetRenderContentInBackground(const AValue: Boolean);
begin
  Viewer.RenderContentInBackground := AValue;
end;

procedure TdxPDFViewerOptionsBehavior.SetShowHints(const AValue: Boolean);
begin
  if FShowHints <> AValue then
  begin
    FShowHints := AValue;
    Viewer.NavigationPane.ShowHints := FShowHints;
    Changed;
  end;
end;

{ TdxPDFViewerOptionsView }

constructor TdxPDFViewerOptionsView.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  HighlightCurrentPage := True;
end;

procedure TdxPDFViewerOptionsView.DoAssign(ASource: TPersistent);
begin
  HighlightCurrentPage := TdxPDFViewerOptionsView(ASource).HighlightCurrentPage;
end;

function TdxPDFViewerOptionsView.GetHighlightCurrentPage: Boolean;
begin
  Result := povPageSelection in Viewer.InternalOptionsView;
end;

procedure TdxPDFViewerOptionsView.SetHighlightCurrentPage(const AValue: Boolean);
var
  AOptions: TdxPreviewOptionsView;
begin
  if HighlightCurrentPage <> AValue then
  begin
    AOptions := Viewer.InternalOptionsView;
    if AValue then
      AOptions := AOptions + [povPageSelection]
    else
      AOptions := AOptions - [povPageSelection];
    Viewer.InternalOptionsView := AOptions;
  end;
end;

procedure TdxPDFViewerOptionsView.SetPageLayout(const AValue: TdxPDFViewerPageLayout);
begin
  if FPageLayout <> AValue then
  begin
    FPageLayout := AValue;
    Viewer.RecreateLayoutCalculator;
    Viewer.RecreatePages;
    Changed(ctHard);
    Viewer.MakeVisible(Viewer.CurrentPageIndex);
  end;
end;

{ TdxPDFViewerOptionsForm }

constructor TdxPDFViewerOptionsForm.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FFocusRect := True;
end;

procedure TdxPDFViewerOptionsForm.DoAssign(ASource: TPersistent);
begin
  AllowEdit := TdxPDFViewerOptionsForm(ASource).AllowEdit;
  FocusRect := TdxPDFViewerOptionsForm(ASource).FocusRect;
end;

procedure TdxPDFViewerOptionsForm.SetAllowEdit(const AValue: Boolean);
begin
  if FAllowEdit <> AValue then
  begin
    FAllowEdit := AValue;
    Viewer.BeforeClearDocument;
    Changed(ctHard);
  end;
end;

procedure TdxPDFViewerOptionsForm.SetFocusRect(const AValue: Boolean);
begin
  if FFocusRect <> AValue then
  begin
    FFocusRect := AValue;
    Changed;
  end;
end;

{ TdxPDFViewerOptionsSelection }

constructor TdxPDFViewerOptionsSelection.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FAnnotations := True;
  FImages := True;
  FText := True;
end;

procedure TdxPDFViewerOptionsSelection.DoAssign(ASource: TPersistent);
begin
  Annotations := TdxPDFViewerOptionsSelection(ASource).Annotations;
  Images := TdxPDFViewerOptionsSelection(ASource).Images;
  Text := TdxPDFViewerOptionsSelection(ASource).Text;
end;

procedure TdxPDFViewerOptionsSelection.SetAnnotations(const AValue: Boolean);
begin
  if FAnnotations <> AValue then
  begin
    FAnnotations := AValue;
    InternalChanged;
  end;
end;

procedure TdxPDFViewerOptionsSelection.SetImages(const AValue: Boolean);
begin
  if FImages <> AValue then
  begin
    FImages := AValue;
    InternalChanged;
  end;
end;

procedure TdxPDFViewerOptionsSelection.SetText(const AValue: Boolean);
begin
  if FText <> AValue then
  begin
    FText := AValue;
    InternalChanged;
  end;
end;

procedure TdxPDFViewerOptionsSelection.InternalChanged;
begin
  Viewer.ViewerController.HideEdit;
  Viewer.DocumentState.ClearCache;
  Viewer.SelectionController.Clear;
  Changed(ctHard);
end;

{ TdxPDFViewerOptionsZoom }

procedure TdxPDFViewerOptionsZoom.DoAssign(ASource: TPersistent);
var
  ASourceOptions: TdxPDFViewerOptionsZoom;
begin
  ASourceOptions := ASource as TdxPDFViewerOptionsZoom;
  ZoomFactor := ASourceOptions.ZoomFactor;
  MaxZoomFactor := ASourceOptions.MaxZoomFactor;
  MinZoomFactor := ASourceOptions.MinZoomFactor;
end;

function TdxPDFViewerOptionsZoom.GetMaxZoomFactor: Integer;
begin
  Result := Viewer.MaxZoomFactor;
end;

function TdxPDFViewerOptionsZoom.GetMinZoomFactor: Integer;
begin
  Result := Viewer.MinZoomFactor;
end;

function TdxPDFViewerOptionsZoom.GetZoomFactor: Integer;
begin
  Result := Viewer.ZoomFactor;
end;

function TdxPDFViewerOptionsZoom.GetZoomMode: TdxPreviewZoomMode;
begin
  Result := Viewer.ZoomMode;
end;

function TdxPDFViewerOptionsZoom.GetZoomStep: Integer;
begin
  Result := Viewer.ZoomStep;
end;

procedure TdxPDFViewerOptionsZoom.SetMaxZoomFactor(const AValue: Integer);
begin
  Viewer.MaxZoomFactor := AValue;
end;

procedure TdxPDFViewerOptionsZoom.SetMinZoomFactor(const AValue: Integer);
begin
  Viewer.MinZoomFactor := AValue;
end;

procedure TdxPDFViewerOptionsZoom.SetZoomFactor(const AValue: Integer);
begin
  Viewer.ZoomFactor := AValue;
end;

procedure TdxPDFViewerOptionsZoom.SetZoomMode(const AValue: TdxPreviewZoomMode);
begin
  Viewer.ZoomMode := AValue;
end;

procedure TdxPDFViewerOptionsZoom.SetZoomStep(const AValue: Integer);
begin
  Viewer.ZoomStep := AValue;
end;

{ TdxPDFViewerFindPanelTextEdit }

constructor TdxPDFViewerFindPanelTextEdit.Create(AFindPanel: TdxPDFViewerFindPanel);
begin
  inherited Create(AFindPanel.Viewer);
  FFindPanel := AFindPanel;
  Parent := AFindPanel.Viewer;
  AutoSize := False;
  ParentCtl3D := False;
  Ctl3D := False;
  TabStop := False;
  DoubleBuffered := False;
  LookAndFeel.MasterLookAndFeel := AFindPanel.Viewer.LookAndFeel;
  Properties.BeepOnError := False;
  Visible := False;
end;

function TdxPDFViewerFindPanelTextEdit.GetInnerEditClass: TControlClass;
begin
  Result := TdxPDFViewerFindPanelInnerTextEdit;
end;

function TdxPDFViewerFindPanelTextEdit.DoMouseWheel(AShift: TShiftState; AWheelDelta: Integer; AMousePos: TPoint): Boolean;
begin
  if PtInRect(FFindPanel.ViewInfo.Edit.Bounds, GetMouseCursorClientPos) then
    Result := inherited DoMouseWheel(AShift, AWheelDelta, AMousePos)
  else
    Result := TdxPDFViewerAccess(FFindPanel.Viewer).ProcessMouseWheelMessage(AWheelDelta);
end;

procedure TdxPDFViewerFindPanelTextEdit.FocusChanged;
begin
  if csDestroying in Parent.ComponentState then
    Exit;
  inherited FocusChanged;
end;

{ TdxPDFViewerFindPanelInnerTextEdit }

procedure TdxPDFViewerFindPanelInnerTextEdit.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  Message.Result := Message.Result or DLGC_WANTTAB or DLGC_WANTALLKEYS;
end;

{ TdxPDFViewerCustomObject }

constructor TdxPDFViewerCustomObject.Create(AViewer: TdxPDFCustomViewer);
begin
  inherited Create;
  FViewer := AViewer;
  FViewer.ScaleFactor.ListenerAdd(ScaleFactorChanged);
  CreateSubClasses;
end;

destructor TdxPDFViewerCustomObject.Destroy;
begin
  FViewer.ScaleFactor.ListenerRemove(ScaleFactorChanged);
  DestroySubClasses;
  inherited Destroy;
end;

procedure TdxPDFViewerCustomObject.CreateSubClasses;
begin
// do nothing
end;

procedure TdxPDFViewerCustomObject.DestroySubClasses;
begin
// do nothing
end;

function TdxPDFViewerCustomObject.GetScaleFactor: TdxScaleFactor;
begin
  Result := Viewer.ScaleFactor;
end;

function TdxPDFViewerCustomObject.GetViewInfo: TdxPDFViewerPagesViewInfo;
begin
  Result := Viewer.ViewInfo;
end;

procedure TdxPDFViewerCustomObject.ScaleFactorChanged(Sender: TObject; M,
  D: Integer; IsLoading: Boolean);
begin
// nothing todo
end;

{ TdxPDFViewerOptionsFinPanel }

procedure TdxPDFViewerOptionsFindPanel.Changed(AType: TdxChangeType);
begin
  Viewer.FindPanel.Calculate(AType);
  Viewer.FindPanel.Invalidate;
end;

procedure TdxPDFViewerOptionsFindPanel.DoAssign(ASource: TPersistent);
var
  ASourceOptions: TdxPDFViewerOptionsFindPanel;
begin
  inherited DoAssign(ASource);
  ASourceOptions := ASource as TdxPDFViewerOptionsFindPanel;
  FAlignment := ASourceOptions.Alignment;
  FAnimationTime := ASourceOptions.AnimationTime;
  FAnimation := ASourceOptions.Animation;
  FShowCloseButton := ASourceOptions.ShowCloseButton;
  FShowPreviousButton := ASourceOptions.ShowPreviousButton;
  FShowOptionsButton := ASourceOptions.ShowOptionsButton;
  FShowNextButton := ASourceOptions.ShowNextButton;
end;

procedure TdxPDFViewerOptionsFindPanel.Initialize;
begin
  inherited Initialize;
  FAnimationTime := dxPDFViewerFindPanelDefaultAnimationTime;
  FShowCloseButton := True;
  FShowNextButton := True;
  FShowOptionsButton := True;
  FShowPreviousButton := True;
end;

function TdxPDFViewerOptionsFindPanel.GetCaseSensitive: Boolean;
begin
  Result := FOptions.CaseSensitive;
end;

function TdxPDFViewerOptionsFindPanel.GetDirection: TdxPDFDocumentTextSearchDirection;
begin
  Result := FOptions.Direction;
end;

function TdxPDFViewerOptionsFindPanel.GetWholeWords: Boolean;
begin
  Result := FOptions.WholeWords;
end;

procedure TdxPDFViewerOptionsFindPanel.SetCaseSensitive(const AValue: Boolean);
begin
  if FOptions.CaseSensitive <> AValue then
  begin
    FOptions.CaseSensitive := AValue;
    ClearTextSearch;
  end;
end;

procedure TdxPDFViewerOptionsFindPanel.SetDirection(const AValue: TdxPDFDocumentTextSearchDirection);
begin
  FOptions.Direction := AValue;
end;

procedure TdxPDFViewerOptionsFindPanel.SetSearchString(const AValue: string);
begin
  if FSearchString <> AValue then
  begin
    FSearchString := AValue;
    ClearTextSearch;
    Viewer.FindPanel.SetSearchEditValue(SearchString);
  end;
end;

procedure TdxPDFViewerOptionsFindPanel.SetWholeWords(const AValue: Boolean);
begin
  if FOptions.WholeWords <> AValue then
  begin
    FOptions.WholeWords := AValue;
    ClearTextSearch;
  end;
end;

procedure TdxPDFViewerOptionsFindPanel.ClearTextSearch;
begin
  if HighlightSearchResults then
    Viewer.TextSearch.Clear;
end;

procedure TdxPDFViewerOptionsFindPanel.SetAlignment(const AValue: TdxPDFViewerFindPanelAlignment);
begin
  if FAlignment <> AValue then
  begin
    FAlignment := AValue;
    Changed(ctHard);
  end;
end;

procedure TdxPDFViewerOptionsFindPanel.SetAnimation(const AValue: TdxPDFViewerFindPanelAnimation);
begin
  if FAnimation <> AValue then
  begin
    FAnimation := AValue;
    Changed;
  end;
end;

procedure TdxPDFViewerOptionsFindPanel.SetAnimationTime(const AValue: Integer);
begin
  if FAnimationTime <> AValue then
  begin
    FAnimationTime := Max(AValue, 0);
    Changed;
  end;
end;

procedure TdxPDFViewerOptionsFindPanel.SetClearSearchStringOnClose(const AValue: Boolean);
begin
  if FClearSearchStringOnClose <> AValue then
  begin
    FClearSearchStringOnClose := AValue;
    Changed;
  end;
end;

procedure TdxPDFViewerOptionsFindPanel.SetDisplayMode(const AValue: TdxPDFViewerFindPanelDisplayMode);
const
  VisibilityMap: array[fpdmAlways..fpdmNever] of Boolean = (True, False);
begin
  if FDisplayMode <> AValue then
  begin
    FDisplayMode := AValue;
    Changed(ctHard);
    if not Viewer.IsDesigning then
    begin
      if DisplayMode in [fpdmNever, fpdmAlways] then
        Viewer.FindPanel.Visible := VisibilityMap[DisplayMode] and Viewer.IsDocumentLoaded
    end
    else
      Viewer.FindPanel.Visible := (DisplayMode = fpdmAlways) and Viewer.IsDocumentLoaded;
  end;
end;

procedure TdxPDFViewerOptionsFindPanel.SetHighlightSearchResults(const AValue: Boolean);
begin
  if FHighlightSearchResults <> AValue then
  begin
    FHighlightSearchResults := AValue;
    ClearTextSearch;
  end;
end;

procedure TdxPDFViewerOptionsFindPanel.SetShowCloseButton(const AValue: Boolean);
begin
  if FShowCloseButton <> AValue then
  begin
    FShowCloseButton := AValue;
    Changed(ctHard);
  end;
end;

procedure TdxPDFViewerOptionsFindPanel.SetShowNextButton(const AValue: Boolean);
begin
  if FShowNextButton <> AValue then
  begin
    FShowNextButton := AValue;
    Changed(ctHard);
  end;
end;

procedure TdxPDFViewerOptionsFindPanel.SetShowOptionsButton(const AValue: Boolean);
begin
  if FShowOptionsButton <> AValue then
  begin
    FShowOptionsButton := AValue;
    Changed(ctHard);
  end;
end;

procedure TdxPDFViewerOptionsFindPanel.SetShowPreviousButton(const AValue: Boolean);
begin
  if FShowPreviousButton <> AValue then
  begin
    FShowPreviousButton := AValue;
    Changed(ctHard);
  end;
end;

{ TdxPDFViewerFindPanel }

constructor TdxPDFViewerFindPanel.Create(AViewer: TdxPDFCustomViewer);
begin
  inherited Create(AViewer);
  FOptions := TdxPDFViewerOptionsFindPanel.Create(Viewer);
  FOptionsButtonGlyph := TdxPDFUtils.LoadGlyph('DX_PDFVIEWERFINDPANELOPTIONSBUTTON', IfThen(dxUseVectorIcons, 'SVG', 'PNG'));
  CreateAnimationController;
  FController := TdxPDFViewerFindPanelController.Create(Viewer, FOptions);
  FViewInfo := TdxPDFViewerFindPanelViewInfo.Create(FController);
  FHitTest := TdxPDFViewerFindPanelHitTest.Create(Viewer);
  Edit := CreateEdit;
end;

destructor TdxPDFViewerFindPanel.Destroy;
begin
  Edit := nil;
  FreeAndNil(FHitTest);
  FreeAndNil(FViewInfo);
  FreeAndNil(FController);
  FreeAndNil(FOptions);
  FreeAndNil(FAnimationController);
  FreeAndNil(FOptionsButtonGlyph);
  inherited Destroy;
end;

procedure TdxPDFViewerFindPanel.CreateAnimationController;
begin
  FAnimationController := TdxPDFViewerFindPanelAnimationController.Create(Viewer);
end;

function TdxPDFViewerFindPanel.IsLocked: Boolean;
begin
  Result := FLockCount <> 0;
end;

procedure TdxPDFViewerFindPanel.BeginUpdate;
begin
  Inc(FLockCount);
end;

procedure TdxPDFViewerFindPanel.Calculate(AType: TdxChangeType);
begin
  ViewInfo.Calculate(AType, Viewer.ClientBounds);
end;

procedure TdxPDFViewerFindPanel.EndUpdate;
begin
  Dec(FLockCount);
end;

procedure TdxPDFViewerFindPanel.Find;
begin
  if not Viewer.TextSearch.IsLocked and (Trim(Edit.EditingValue) <> '') then
  begin
    ForceUpdate;
    Options.Direction := tsdForward;
    FController.DoFindText;
  end;
end;

procedure TdxPDFViewerFindPanel.HideBeep(var AKey: Char);
begin
  if Ord(AKey) in [13, 27] then
    AKey := #0;
end;

procedure TdxPDFViewerFindPanel.Invalidate;
begin
  Viewer.Invalidate;
end;

procedure TdxPDFViewerFindPanel.SetFocuse;
begin
  FController.SetFocuse;
  if (FController.FocusedCell = ViewInfo.Edit) and not ViewInfo.Edit.InternalEdit.Focused then
    FController.DoSetFocus;
end;

procedure TdxPDFViewerFindPanel.SetSearchEditValue(const AValue: string);
begin
  Edit.EditValue := AValue;
end;

procedure TdxPDFViewerFindPanel.SetEdit(const AValue: TdxPDFViewerFindPanelTextEdit);
begin
  InternalSetEdit(AValue);
end;

procedure TdxPDFViewerFindPanel.SetOptions(const AValue: TdxPDFViewerOptionsFindPanel);
begin
  FOptions.Assign(AValue);
end;

procedure TdxPDFViewerFindPanel.SetVisible(const AValue: Boolean);
var
  ARestoreFocusedCell: Boolean;
begin
  if FVisible <> AValue then
  begin
    FVisible := AValue;
    AnimationController.Animate(AValue);
    Edit.Visible := FVisible;
    ARestoreFocusedCell := not FVisible;
    Viewer.BeginUpdate;
    try
      if ARestoreFocusedCell then
      begin
        Controller.FocusedCell := nil;
        if Options.ClearSearchStringOnClose then
          SetSearchEditValue('');
        Viewer.DoSetFocus;
      end
      else
      begin
        SetSearchEditValue(Viewer.OptionsFindPanel.SearchString);
        Controller.FocusedCell := ViewInfo.Edit;
        ARestoreFocusedCell := True;
      end;
    finally
      Viewer.CancelUpdate;
      Calculate(ctHard);
      if ARestoreFocusedCell then
        Controller.FocusedCell := ViewInfo.Edit;
    end;
    Invalidate;
  end;
end;

function TdxPDFViewerFindPanel.CreateEdit: TdxPDFViewerFindPanelTextEdit;
begin
  Result := TdxPDFViewerFindPanelTextEdit.Create(Self);
  Result.EditValue := FOptions.SearchString;
  Result.OnKeyDown := EditKeyDownHandler;
  Result.OnKeyPress := EditKeyPressHandler;
  Result.Properties.OnChange := EditValueChangedHandler;
  Result.Properties.OnEditValueChanged := EditValueChangedHandler;
end;

procedure TdxPDFViewerFindPanel.DestroyEdit;
begin
  FreeAndNil(FEdit);
end;

procedure TdxPDFViewerFindPanel.InternalSetEdit(const AValue: TdxPDFViewerFindPanelTextEdit);
begin
  if FEdit <> AValue then
  begin
    if FEdit <> nil then
    begin
      if AValue <> nil then
        AValue.Properties.LookupItems.Assign(FEdit.Properties.LookupItems);
      DestroyEdit;
    end;
    FEdit := AValue;
  end;
end;

procedure TdxPDFViewerFindPanel.ForceUpdate;
begin
  Options.SearchString := Edit.EditingValue;
  ViewInfo.Calculate;
  ViewInfo.UpdateState;
  ViewInfo.Invalidate;
end;

procedure TdxPDFViewerFindPanel.EditKeyPressHandler(Sender: TObject; var Key: Char);
begin
  HideBeep(Key);
end;

procedure TdxPDFViewerFindPanel.EditKeyDownHandler(Sender: TObject; var Key: Word; Shift: TShiftState);

  function IsCtrlShiftPressed(AShift: TShiftState): Boolean;
  begin
    Result := (ssShift in AShift) and IsCtrlPressed;
  end;

begin
  case Key of
    VK_TAB:
      begin
        Controller.FocusNextCell(True);
        Key := 0;
      end;
    VK_ESCAPE:
      Viewer.HideFindPanel;
    VK_ADD:
      if IsCtrlPressed then
        Viewer.ZoomIn;
    VK_SUBTRACT:
      if IsCtrlPressed then
        Viewer.ZoomOut;
    VK_PRIOR:
      Viewer.GoToPrevPage;
    VK_NEXT:
      Viewer.GoToNextPage;
    VK_RETURN, VK_F3:
      begin
        Find;
        FEdit.SetFocus;
      end;
  end;
end;

procedure TdxPDFViewerFindPanel.EditValueChangedHandler(Sender: TObject);
begin
  ForceUpdate;
end;

{ TdxPDFViewerPage }

procedure TdxPDFViewerPage.Draw(ACanvas: TcxCanvas);
begin
  ACanvas.Lock;
  try
    DrawBackground(ACanvas);
    DrawContent(ACanvas);
    DrawHighlights(ACanvas);
    DrawSelection(ACanvas);
  finally
    ACanvas.Unlock;
  end;
end;

function TdxPDFViewerPage.GetVisible: Boolean;
begin
  Result := inherited GetVisible or cxRectIntersect(Bounds, TdxPDFViewerAccess(Preview).GetPagesArea);
end;

procedure TdxPDFViewerPage.CalculatePageSize;
begin
  PageSize.Size := GetPageSize(TdxPDFViewerAccess(Preview).DocumentToViewerFactor);
  PageSize.MinUsefulSize := PageSize.Size;
end;

function TdxPDFViewerPage.CreatePath(ASelection: TdxPDFTextHighlight; AExcludeTextSelection: Boolean = False): TdxGPPath;

  function IsTextSelection: Boolean;
  begin
    Result := not Viewer.Selection.IsEmpty and (Viewer.Selection.Selection.HitCode = hcTextSelection);
  end;

  function InflateSelectionRect(const ARect: TdxRectF): TdxRectF;
  begin
    Result := cxRectInflate(ARect, DocumentState.ScaleFactor.X, DocumentState.ScaleFactor.X);
  end;

var
  R: TdxRectF;
  AHighlights: TdxPDFRectFList;
  ATextSelectionRects: TdxPDFRectFList;
begin
  Result := TdxGPPath.Create(gpfmWinding);
  AHighlights := TdxPDFTextHighlightAccess(ASelection).PageRects[Index];
  if AHighlights <> nil then
  begin
    if IsTextSelection then
      ATextSelectionRects := TdxPDFTextHighlightAccess(Viewer.Selection.Selection).PageRects[Index]
    else
      ATextSelectionRects := nil;
    Result.FigureStart;
    try
      for R in AHighlights do
        if not AExcludeTextSelection or ((ATextSelectionRects <> nil) and not ATextSelectionRects.Contains(R) or
          (ATextSelectionRects = nil)) then
          Result.AddRect(InflateSelectionRect(ToViewerRect(R)));
    finally
      Result.FigureFinish;
    end;
  end;
end;

function TdxPDFViewerPage.GetPainter: TdxPDFViewerPainter;
begin
  Result := Viewer.Painter;
end;

function TdxPDFViewerPage.GetSelectionBackColor(AColor: TdxAlphaColor): TdxAlphaColor;
begin
  if AColor = dxacDefault then
    Result := Painter.SelectionBackColor
  else
    Result := AColor;
end;

function TdxPDFViewerPage.GetSelectionFrameColor(AColor: TdxAlphaColor): TdxAlphaColor;
begin
  if AColor = dxacDefault then
    Result := Painter.SelectionFrameColor
  else
    Result := AColor;
end;

function TdxPDFViewerPage.GetViewer: TdxPDFCustomViewer;
begin
  Result := Preview as TdxPDFCustomViewer;
end;

procedure TdxPDFViewerPage.DrawBackground(ACanvas: TcxCanvas);
begin
  Painter.DrawPageBackground(ACanvas, SiteBounds, Bounds, Viewer.CanHighlightCurrentPage(Selected));
end;

procedure TdxPDFViewerPage.DrawContent(ACanvas: TcxCanvas);
var
  AViewInfo: TdxPDFViewerPageViewInfo;
begin
  TdxPDFDocumentViewerCustomRendererAccess(Viewer.Renderer).DrawPage(ACanvas, Index, Bounds);
  if not IsInteractiveLayerDrawingLocked and Viewer.ViewInfo.TryGetViewInfo(Index, AViewInfo) then
    AViewInfo.Draw(ACanvas);
end;

procedure TdxPDFViewerPage.DrawHighlights(ACanvas: TcxCanvas);

  function GetBackColor(AColor: TdxAlphaColor): TdxAlphaColor;
  begin
    if AColor = dxacDefault then
      Result := Painter.HighlightBackColor
    else
      Result := AColor;
  end;

  function GetFrameColor(AColor: TdxAlphaColor): TdxAlphaColor;
  begin
    if AColor = dxacDefault then
      Result := Painter.HighlightFrameColor
    else
      Result := AColor;
  end;

  procedure DrawHighlight(ACanvas: TcxCanvas; AHighlight: TdxPDFTextHighlight);
  var
    APath: TdxGPPath;
  begin
    APath := CreatePath(AHighlight, True);
    try
      DrawPath(ACanvas, APath, GetBackColor(TdxPDFTextHighlightAccess(AHighlight).BackColor),
        GetFrameColor(TdxPDFTextHighlightAccess(AHighlight).FrameColor));
    finally
      APath.Free;
    end;
  end;

  function NeedDraw: Boolean;
  begin
   Result := (Viewer.Highlights.Visible = bTrue) or (Viewer.Highlights.Visible = bDefault) and Viewer.IsFindPanelVisible;
  end;

var
  AHighlight: TdxPDFTextHighlight;
  I: Integer;
begin
  if NeedDraw then
    for I := 0 to Viewer.Highlights.Items.Count - 1 do
    begin
      AHighlight := TdxPDFTextHighlight(Viewer.Highlights.Items[I]);
      DrawHighlight(ACanvas, AHighlight);
    end;
end;

procedure TdxPDFViewerPage.DrawImageSelection(ACanvas: TcxCanvas; ASelection: TdxPDFImageSelection);
var
  APath: TdxGPPath;
begin
  if TdxPDFImageSelectionAccess(ASelection).PageIndex = Index then
  begin
   APath := TdxGPPath.Create(gpfmWinding);
   try
     APath.FigureStart;
     APath.AddRect(ToViewerRect(TdxPDFImageSelection(ASelection).Bounds));
     APath.FigureFinish;
     DrawPath(ACanvas, APath, GetSelectionBackColor(ASelection.BackColor), GetSelectionFrameColor(ASelection.FrameColor));
   finally
      APath.Free;
   end;
  end;
end;

procedure TdxPDFViewerPage.DrawPath(ACanvas: TcxCanvas; APath: TdxGPPath; AColor, AFrameColor: TdxAlphaColor);
var
  AGraphics: TdxGPGraphics;
  ARegion: TdxGPRegion;
begin
  AGraphics := TdxGPGraphics.Create(ACanvas.Handle);
  ARegion := TdxGPRegion.Create;
  ARegion.CombineRegionRect(Bounds, gmIntersect);
  AGraphics.SaveClipRegion;
  try
    AGraphics.SetClipRegion(ARegion, gmIntersect);
    AGraphics.Path(APath, AFrameColor, AColor);
  finally
    AGraphics.RestoreClipRegion;
    ARegion.Free;
    AGraphics.Free;
  end;
end;

procedure TdxPDFViewerPage.DrawSelection(ACanvas: TcxCanvas);
var
  ASelection: TdxPDFCustomSelection;
begin
  ASelection := Viewer.Selection.Selection;
  if ASelection <> nil then
    case ASelection.HitCode of
      hcImage:
        DrawImageSelection(ACanvas, TdxPDFImageSelection(ASelection));
      hcTextSelection:
        DrawTextSelection(ACanvas, TdxPDFTextSelection(ASelection));
    end;
end;

procedure TdxPDFViewerPage.DrawTextSelection(ACanvas: TcxCanvas; ASelection: TdxPDFTextSelection);
var
  APath: TdxGPPath;
begin
  APath := CreatePath(ASelection);
  try
    DrawPath(ACanvas, APath, GetSelectionBackColor(ASelection.BackColor), GetSelectionFrameColor(ASelection.FrameColor));
  finally
    APath.Free;
  end;
end;

{ TdxPDFViewerPainter }

function TdxPDFViewerPainter.ButtonSymbolColor(AState: TcxButtonState): TColor;
begin
  Result := LookAndFeelPainter.ButtonSymbolColor(AState);
end;

function TdxPDFViewerPainter.ButtonTextShift: Integer;
begin
  Result := LookAndFeelPainter.ScaledButtonTextShift(ScaleFactor);
end;

function TdxPDFViewerPainter.DropDownButtonWidth: Integer;
begin
  Result := LookAndFeelPainter.GetScaledDropDownButtonRightPartSize(ScaleFactor);
end;

function TdxPDFViewerPainter.FindPanelCloseButtonSize: TSize;
begin
  Result := cxSize(LookAndFeelPainter.ScaledFilterCloseButtonSize(ScaleFactor));
  dxAdjustToTouchableSize(Result, ScaleFactor);
end;

function TdxPDFViewerPainter.FindPanelOptionsDropDownButtonWidth: Integer;
begin
  Result := LookAndFeelPainter.GetScaledDropDownButtonRightPartSize(ScaleFactor);
end;

function TdxPDFViewerPainter.NavigationPaneButtonContentOffsets: TRect;
begin
  Result := LookAndFeelPainter.PDFViewerNavigationPaneButtonContentOffsets(ScaleFactor);
end;

function TdxPDFViewerPainter.NavigationPaneButtonOverlay: TPoint;
begin
  Result := LookAndFeelPainter.PDFViewerNavigationPaneButtonOverlay(ScaleFactor);
end;

function TdxPDFViewerPainter.NavigationPaneButtonSize: TSize;
begin
  Result := LookAndFeelPainter.PDFViewerNavigationPaneButtonSize(ScaleFactor);
end;

function TdxPDFViewerPainter.NavigationPanePageCaptionContentOffsets: TRect;
begin
  Result := LookAndFeelPainter.PDFViewerNavigationPanePageCaptionContentOffsets(ScaleFactor);
end;

function TdxPDFViewerPainter.NavigationPanePageCaptionTextColor: TColor;
begin
  Result := LookAndFeelPainter.PDFViewerNavigationPanePageCaptionTextColor;
end;

function TdxPDFViewerPainter.NavigationPanePageToolbarContentOffsets: TRect;
begin
  Result := LookAndFeelPainter.PDFViewerNavigationPanePageToolbarContentOffsets(ScaleFactor);
end;

function TdxPDFViewerPainter.NavigationPaneContentOffsets: TRect;
begin
  Result := LookAndFeelPainter.PDFViewerNavigationPaneContentOffsets(ScaleFactor);
end;

function TdxPDFViewerPainter.NavigationPanePageContentOffsets: TRect;
begin
  Result := LookAndFeelPainter.PDFViewerNavigationPanePageContentOffsets(ScaleFactor);
end;

function TdxPDFViewerPainter.HighlightBackColor: TdxAlphaColor;
begin
  Result := dxColorToAlphaColor(LookAndFeelPainter.PDFViewerSelectionColor, 30);
end;

function TdxPDFViewerPainter.HighlightFrameColor: TdxAlphaColor;
begin
  Result := SelectionBackColor;
end;

function TdxPDFViewerPainter.SelectionBackColor: TdxAlphaColor;
begin
  Result := dxColorToAlphaColor(LookAndFeelPainter.PDFViewerSelectionColor, 127);
end;

function TdxPDFViewerPainter.SelectionFrameColor: TdxAlphaColor;
begin
  Result := dxacNone;
end;

function TdxPDFViewerPainter.TitleTextColor: TColor;
begin
  Result := LookAndFeelPainter.GetWindowContentTextColor;
end;

procedure TdxPDFViewerPainter.DrawButton(ACanvas: TcxCanvas; const ARect: TRect; const ACaption: string;
  AState: TcxButtonState);
begin
  LookAndFeelPainter.DrawScaledButton(ACanvas, ARect, ACaption, AState, ScaleFactor);
end;

procedure TdxPDFViewerPainter.DrawButtonBackground(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState);
begin
  DrawButton(ACanvas, ARect, '', AState);
end;

procedure TdxPDFViewerPainter.DrawButtonGlyph(ACanvas: TcxCanvas; AImage: TdxSmartGlyph; const ARect: TRect;
  AState: TcxButtonState);
begin
  TdxImageDrawer.DrawImage(ACanvas, ARect, AImage, nil, -1, AState <> cxbsDisabled, LookAndFeelPainter.PDFViewerNavigationPaneButtonColorPalette(AState), ScaleFactor);
end;

procedure TdxPDFViewerPainter.DrawButtonGlyph(ACanvas: TcxCanvas; AImage: TdxSmartGlyph; const ARect: TRect;
  AState: TcxButtonState; AColorize: Boolean);
begin
  if AColorize and not Supports(AImage, IdxVectorImage) then
    AImage.ChangeColor(ButtonSymbolColor(AState));
  DrawButtonGlyph(ACanvas, AImage, ARect, AState);
end;

procedure TdxPDFViewerPainter.DrawDropDownButton(ACanvas: TcxCanvas; const ARect: TRect;
  AState: TcxButtonState);
begin
  LookAndFeelPainter.DrawScaledScrollBarArrow(ACanvas, ARect, AState, adDown, ScaleFactor);
end;

procedure TdxPDFViewerPainter.DrawDropDownButtonGlyph(ACanvas: TcxCanvas; AImage: TdxSmartGlyph;
  const ARect: TRect; AState: TcxButtonState; AColorize: Boolean = True);
begin
  DrawButtonGlyph(ACanvas, AImage, ARect, AState, AColorize);
end;

procedure TdxPDFViewerPainter.DrawFocusRect(ACanvas: TcxCanvas; const ARect: TRect);
begin
  if LookAndFeelPainter.SupportsNativeFocusRect then
    ACanvas.DrawFocusRect(LookAndFeelPainter.ScaledButtonFocusRect(ACanvas, ARect, ScaleFactor));
end;

procedure TdxPDFViewerPainter.DrawFindPanelBackground(ACanvas: TcxCanvas; const ARect: TRect);
const
  VisibleBordersMap: array[TdxPDFViewerFindPanelAlignment] of TcxBorders = (
    [bBottom], [bBottom, bLeft], [bBottom, bLeft, bRight], [bBottom, bRight],
    [bTop], [bTop, bLeft], [bTop, bLeft, bRight], [bTop, bRight]);
begin
  LookAndFeelPainter.PDFViewerDrawFindPanelBackground(ACanvas, ARect,
    VisibleBordersMap[Viewer.OptionsFindPanel.Alignment]);
end;

procedure TdxPDFViewerPainter.DrawFindPanelCloseButton(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState);
begin
  LookAndFeelPainter.DrawScaledFilterCloseButton(ACanvas, ARect, AState, ScaleFactor);
end;

procedure TdxPDFViewerPainter.DrawFindPanelOptionsButtonGlyph(
  ACanvas: TcxCanvas; AImage: TdxSmartGlyph; const ARect: TRect; AState: TcxButtonState);
begin
  AImage.ChangeColor(ButtonSymbolColor(AState));
  TdxImageDrawer.DrawImage(ACanvas, ARect, AImage, nil, -1, True, nil, ScaleFactor);
end;

procedure TdxPDFViewerPainter.DrawFindPanelOptionsDropDownButton(ACanvas: TcxCanvas; const ARect: TRect;
  AState: TcxButtonState);
begin
  LookAndFeelPainter.DrawScaledScrollBarArrow(ACanvas, ARect, AState, adDown, ScaleFactor);
end;

procedure TdxPDFViewerPainter.DrawNavigationPaneBackground(ACanvas: TcxCanvas; const ARect: TRect);
begin
  LookAndFeelPainter.PDFViewerDrawNavigationPaneBackground(ACanvas, ARect, ScaleFactor);
end;

procedure TdxPDFViewerPainter.DrawNavigationPaneButton(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState;
  AMinimized, ASelected, AIsFirst: Boolean);
begin
  LookAndFeelPainter.PDFViewerDrawNavigationPaneButton(ACanvas, ARect, AState, ScaleFactor, AMinimized, ASelected,
    AIsFirst);
end;

procedure TdxPDFViewerPainter.DrawNavigationPaneButtonGlyph(ACanvas: TcxCanvas; AImage: TdxSmartGlyph; const ARect: TRect;
  AState: TcxButtonState);
begin
  TdxImageDrawer.DrawImage(ACanvas, ARect, AImage, nil, -1, True, LookAndFeelPainter.PDFViewerNavigationPaneButtonColorPalette(AState),
    ScaleFactor);
end;

procedure TdxPDFViewerPainter.DrawNavigationPanePageBackground(ACanvas: TcxCanvas; const ARect: TRect);
begin
  LookAndFeelPainter.PDFViewerDrawNavigationPanePageBackground(ACanvas, ARect);
end;

procedure TdxPDFViewerPainter.DrawNavigationPanePageButton(ACanvas: TcxCanvas; const ARect: TRect;
  AState: TcxButtonState);
begin
  if AState in [cxbsHot, cxbsPressed, cxbsDisabled] then
    LookAndFeelPainter.PDFViewerDrawNavigationPanePageButton(ACanvas, ARect, AState, ScaleFactor);
end;

procedure TdxPDFViewerPainter.DrawNavigationPanePageCaptionBackground(ACanvas: TcxCanvas; const ARect: TRect);
begin
  LookAndFeelPainter.PDFViewerDrawNavigationPanePageCaptionBackground(ACanvas, ARect);
end;

procedure TdxPDFViewerPainter.DrawNavigationPanePageToolbarBackground(ACanvas: TcxCanvas; const ARect: TRect);
begin
  LookAndFeelPainter.PDFViewerDrawNavigationPanePageToolbarBackground(ACanvas, ARect);
end;

procedure TdxPDFViewerPainter.DrawPageBackground(ACanvas: TcxCanvas; const ABorderRect, AContentRect: TRect; ASelected: Boolean);
begin
  LookAndFeelPainter.DrawPrintPreviewPageBackground(ACanvas, ABorderRect, AContentRect, ASelected, True);
end;

function TdxPDFViewerPainter.IsFadingAvailable: Boolean;
begin
  Result := (LookAndFeelPainter.LookAndFeelStyle = lfsNative) or IsSkinUsed;
end;

function TdxPDFViewerPainter.IsSkinUsed: Boolean;
begin
  Result := LookAndFeelPainter.LookAndFeelStyle = lfsSkin;
end;

function TdxPDFViewerPainter.GetLookAndFeelPainter: TcxCustomLookAndFeelPainter;
begin
  Result := Viewer.LookAndFeelPainter;
end;

function TdxPDFViewerPainter.GetScaleFactor: TdxScaleFactor;
begin
  Result := Viewer.ScaleFactor;
end;

{ TdxPDFViewerLockedStatePaintHelper }

function TdxPDFViewerLockedStatePaintHelper.CanCreateLockedImage: Boolean;
begin
  Result := inherited CanCreateLockedImage and not Viewer.IsUpdateLocked;
end;

function TdxPDFViewerLockedStatePaintHelper.DoPrepareImage: Boolean;
begin
  Result := Viewer.DoPrepareLockedStateImage;
end;

function TdxPDFViewerLockedStatePaintHelper.GetControl: TcxControl;
begin
  Result := Viewer;
end;

function TdxPDFViewerLockedStatePaintHelper.GetOptions: TcxLockedStateImageOptions;
begin
  Result := Viewer.OptionsLockedStateImage;
end;

function TdxPDFViewerLockedStatePaintHelper.GetViewer: TdxPDFCustomViewer;
begin
  Result := TdxPDFCustomViewer(Owner);
end;

{ TdxPDFViewerLockedStateImageOptions }

function TdxPDFViewerLockedStateImageOptions.GetFont: TFont;
begin
  Result := (Owner as TdxPDFCustomViewer).Font;
end;

{ TdxPDFViewerDocumentState }

procedure TdxPDFViewerDocumentState.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FPageContentCache := TObjectDictionary<Integer, TPageContent>.Create([doOwnsValues]);
end;

procedure TdxPDFViewerDocumentState.DestroySubClasses;
begin
  FreeAndNil(FPageContentCache);
  inherited DestroySubClasses;
end;

function TdxPDFViewerDocumentState.FindLine(const APosition: TdxPDFPagePoint; out ALine: TdxPDFTextLine): Boolean;
begin
  Result := TextLines[APosition.PageIndex].Find(APosition, TextExpansionFactor, ALine);
end;

function TdxPDFViewerDocumentState.FindStartTextPosition(const APosition: TdxPDFPagePoint): TdxPDFTextPosition;
begin
  Result := TextLines[APosition.PageIndex].FindStartTextPosition(APosition, TextExpansionFactor)
end;

procedure TdxPDFViewerDocumentState.ClearCache;
begin
  FPageContentCache.Clear;
end;

procedure TdxPDFViewerDocumentState.Update(AChanges: TdxPDFDocumentChanges);
begin
  inherited Update(AChanges);
  ClearCache;
  if (Viewer.TextSearch <> nil) and (dcInteractiveLayer in AChanges) then
  begin
    Viewer.TextSearch.Clear;
    Viewer.Highlights.Clear;
    Viewer.Selection.Clear;
    Viewer.InvalidatePages;
  end;
end;

function TdxPDFViewerDocumentState.AllowedRecognitionObjects: TdxPDFRecognitionObjects;
begin
  Result := dxPDFAllRecognitionObjects;
  if not Viewer.OptionsSelection.Annotations then
    Exclude(Result, rmAnnotations);
  if not Viewer.OptionsSelection.Images then
    Exclude(Result, rmImages);
  if not Viewer.OptionsSelection.Text then
    Exclude(Result, rmText);
  if Viewer.OptionsForm.AllowEdit then
    Include(Result, rmExcludeField);
end;

function TdxPDFViewerDocumentState.GetAnnotationWidgetMap: TDictionary<TObject, TdxPDFCustomWidget>;
begin
  Result := TdxPDFFormAccess(Document.Form).AnnotationWidgetMap;
end;

function TdxPDFViewerDocumentState.GetContent(APageIndex: Integer): TdxFastObjectList;
begin
  Result := PageContent[APageIndex].ContentList;
end;

function TdxPDFViewerDocumentState.GetPageAnnotationList(APageIndex: Integer): TdxFastObjectList;
begin
  Result := PageContent[APageIndex].AnnotationList;
end;

function TdxPDFViewerDocumentState.GetPageContent(APageIndex: Integer): TPageContent;
var
  APage: TdxPDFPage;
begin
  if not FPageContentCache.TryGetValue(APageIndex, Result) then
  begin
    APage := Pages[APageIndex];
    try
      Result := TPageContent.Create(APage, AllowedRecognitionObjects, Viewer.OptionsForm.AllowEdit);
    finally
      APage.PackRecognizedContent;
    end;
    FPageContentCache.Add(APageIndex, Result);
  end;
end;

function TdxPDFViewerDocumentState.GetTextLines(APageIndex: Integer): TdxPDFTextLineList;
begin
  Result := PageContent[APageIndex].TextLineList;
end;

function TdxPDFViewerDocumentState.GetViewer: TdxPDFCustomViewer;
begin
  Result := inherited Viewer as TdxPDFCustomViewer;
end;

{ TdxPDFViewerDocumentState.TPageContent }

class procedure TdxPDFViewerDocumentState.TPageContent.ForEach(APage: TdxPDFPage; AAllowAnnotation, AAllowEdit: Boolean;
  AProc: TdxPDFPageForEachAnnotationProc);
begin
  if AAllowAnnotation or AAllowEdit then
    APage.ForEachAnnotation(
        procedure(AAnnotation: TdxPDFCustomAnnotation)
        begin
          if AAllowAnnotation or not AAllowAnnotation and AAllowEdit and (AAnnotation is TdxPDFWidgetAnnotation) then
          begin
            if AAnnotation is TdxPDFWidgetAnnotation then
            begin
              if AAllowEdit then
                AProc(AAnnotation);
            end
            else
              AProc(AAnnotation);
          end;
        end);
end;

constructor TdxPDFViewerDocumentState.TPageContent.Create(APage: TdxPDFPage; AAllowedObjects: TdxPDFRecognitionObjects;
  AAllowFieldEdit: Boolean);
var
  AContent: TdxPDFRecognizedContent;
  I: Integer;
begin
  inherited Create;
  FAnnotationList := TdxFastObjectList.Create(False);
  FContentList := TdxFastObjectList.Create(False);
  AContent := APage.CreateRecognizedContent(AAllowedObjects);
  try
    FImageHolderList := TdxPDFImageListAccess(AContent.Images).Clone;
    FTextLineList := AContent.TextLines.Clone;
    for I := 0 to FImageHolderList.Count - 1 do
      ContentList.Add(FImageHolderList[I]);
    ForEach(APage, rmAnnotations in AAllowedObjects, AAllowFieldEdit,
      procedure(AAnnotation: TdxPDFCustomAnnotation)
      begin
        FAnnotationList.Add(AAnnotation);
      end);
    ContentList.AddRange(FAnnotationList);
  finally
    AContent.Free;
  end;
end;

destructor TdxPDFViewerDocumentState.TPageContent.Destroy;
begin
  FreeAndNil(FImageHolderList);
  FreeAndNil(FTextLineList);
  FreeAndNil(FContentList);
  FreeAndNil(FAnnotationList);
  inherited Destroy;
end;

{ TdxPDFViewerDocument }

function TdxPDFViewerDocument.DoCreateDocumentState: TdxPDFDocumentState;
begin
  Result := TdxPDFViewerDocumentState.Create(Self, Viewer);
end;

{ TdxPDFCustomViewer }

function TdxPDFCustomViewer.CanGoToNextView: Boolean;
begin
  Result := FController.ViewStateHistoryController.CanGoToNextView;
end;

function TdxPDFCustomViewer.CanGoToPrevView: Boolean;
begin
  Result := FController.ViewStateHistoryController.CanGoToPreviousView;
end;

function TdxPDFCustomViewer.IsDocumentLoaded: Boolean;
begin
  Result := not FIsDocumentClearing and (FDocument <> nil) and not TdxPDFDocumentAccess(FDocument).IsEmpty;
end;

procedure TdxPDFCustomViewer.Clear;
begin
  if not TextSearch.IsLocked then
  begin
    ResetScrollAnimationPageRange;
    if not FIsDocumentClearing then
    begin
      FIsDocumentClearing := True;
      try
        inherited Clear;
        FController.Clear;
        NavigationPane.Clear;

        FTextSearch.Clear;
        DestroyOutlines;
        FDocument.Clear;
      finally
        FIsDocumentClearing := False;
      end;
      Calculate(ctHard);
    end
    else
    begin
      RecreatePages;
      if OptionsFindPanel.DisplayMode <> fpdmNever then
        HideFindPanel;
      NavigationPane.Refresh;
      dxCallNotify(OnDocumentUnloaded, Self);
    end;
    Invalidate;
  end;
end;

procedure TdxPDFCustomViewer.ClearViewStateHistory;
begin
  ViewerController.ViewStateHistoryController.Clear;
end;

procedure TdxPDFCustomViewer.GoToNextView;
begin
  FController.ViewStateHistoryController.GoToNextView;
end;

procedure TdxPDFCustomViewer.GoToPrevView;
begin
  FController.ViewStateHistoryController.GoToPrevView;
end;

procedure TdxPDFCustomViewer.LoadFromFile(const AFileName: string);
begin
  BeforeLoadDocument;
  try
    try
      FDocument.LoadFromFile(AFileName);
    except
      Clear;
      raise;
    end;
  finally
    AfterLoadDocument;
  end;
end;

procedure TdxPDFCustomViewer.LoadFromStream(AStream: TStream);
begin
  BeforeLoadDocument;
  try
    try
      FDocument.LoadFromStream(AStream);
    except
      Clear;
      raise;
    end;
  finally
    AfterLoadDocument;
  end;
end;

procedure TdxPDFCustomViewer.RotateClockwise;
begin
  FController.Rotate(-90);
end;

procedure TdxPDFCustomViewer.RotateCounterclockwise;
begin
  FController.Rotate(90);
end;

function TdxPDFCustomViewer.IsFindPanelVisible: Boolean;
begin
  if Assigned(FOnGetFindPanelVisibility) then
    Result := OnGetFindPanelVisibility(Self)
  else
    Result := not FindPanel.AnimationController.Active and FindPanel.Visible;
end;

procedure TdxPDFCustomViewer.HideFindPanel;
begin
  if CanHideFindPanel then
  begin
    FindPanel.Visible := False;
    if OptionsFindPanel.ClearSearchStringOnClose then
      Highlights.Clear;
    dxCallNotify(OnHideFindPanel, Self);
    DoSetFocus;
  end;
end;

procedure TdxPDFCustomViewer.ShowFindPanel;
begin
  if CanShowFindPanel then
  begin
    if not IsFindPanelVisible then
    begin
      dxCallNotify(OnShowFindPanel, Self);
      FindPanel.Visible := True;
    end
    else
      SetFindPanelFocus;
  end;
end;

function TdxPDFCustomViewer.CanMakeVisibleAnimate: Boolean;
begin
  Result := FCanMakeVisibleAnimate;
end;

function TdxPDFCustomViewer.CanUpdateRenderQueue: Boolean;
begin
  Result := IsDocumentAvailable;
end;

function TdxPDFCustomViewer.GetCurrentCursor(X, Y: Integer): TCursor;
var
  AController: TdxPDFViewerCustomController;
  P: TPoint;
begin
  Result := crDefault;
  P := cxPoint(X, Y);
  if IsScrollBarsArea(P) then
    Result := crDefault
  else
    if ControllerFromPoint(P, AController) then
      Result := AController.Cursor;
end;

function TdxPDFCustomViewer.GetHitInfoAt(const P: TPoint): TdxPreviewHitTests;
begin
  Result := [];
end;

function TdxPDFCustomViewer.GetPageRenderFactor(APageIndex: Integer): Single;
begin
  Result := ZoomFactor / 100;
end;

procedure TdxPDFCustomViewer.BoundsChanged;
begin
  LockHistoryAndExecute(
    procedure
    begin
      ViewInfo.LockRecreateCells;
      BeginBoundsChange;
      inherited BoundsChanged;
      EndBoundsChange;
      ViewInfo.UnLockRecreateCells;
    end);
end;

procedure TdxPDFCustomViewer.ClearSelection;
begin
  inherited ClearSelection;
  SelectionController.Clear;
end;

procedure TdxPDFCustomViewer.CreateSubClasses;

  procedure CreateOptions;
  begin
    FOptionsZoom := TdxPDFViewerOptionsZoom.Create(Self);
    FOptionsLockedStateImage := CreateOptionsLockedStateImage;
    FOptionsBehavior := TdxPDFViewerOptionsBehavior.Create(Self);
    FOptionsForm := TdxPDFViewerOptionsForm.Create(Self);
    FOptionsSelection := TdxPDFViewerOptionsSelection.Create(Self);
    FOptionsView := TdxPDFViewerOptionsView.Create(Self);
  end;

begin
  CreateDocument;
  CreateOptions;
  inherited CreateSubClasses;
  FPainter := GetPainterClass.Create(Self);
  FDialogsLookAndFeel := TcxLookAndFeel.Create(Self);
  FDialogsLookAndFeel.MasterLookAndFeel := LookAndFeel;
  FTextSearch := TdxPDFViewerTextSearch.Create(Self);
  FFindPanel := TdxPDFViewerFindPanel.Create(Self);
  FController := GetControllerClass.Create(Self);
  FNavigationPane := TdxPDFViewerNavigationPane.Create(Self);
  FNavigationPane.AddPages;
  FViewInfo := TdxPDFViewerPagesViewInfo.Create(FController);
  ViewInfo.CreateCells;
  FSelection := TdxPDFViewerSelection.Create(Self);
  SelectionController.OnSelectionChanged := OnSelectionChangedHandler;
  FHighlights := TdxPDFViewerHighlights.Create(Self);
  FHighlights.OnChanged := OnHighlightsChangedHandler;
  FHitTest := TdxPDFViewerDocumentHitTest.Create(Self);
  FLockedStatePaintHelper := CreateLockedStatePaintHelper;
  RecreateRenderer;
end;

procedure TdxPDFCustomViewer.DestroySubClasses;
begin
  TdxPDFDocumentAccess(FDocument).RemoveListener(Self);
  Clear;
  FreeAndNil(FLockedStatePaintHelper);
  FreeAndNil(FOptionsView);
  FreeAndNil(FOptionsSelection);
  FreeAndNil(FOptionsForm);
  FreeAndNil(FOptionsBehavior);
  FreeAndNil(FOptionsLockedStateImage);
  FreeAndNil(FHitTest);
  FreeAndNil(FHighlights);
  FreeAndNil(FSelection);
  FreeAndNil(FOptionsZoom);
  FreeAndNil(FViewInfo);
  FreeAndNil(FController);
  FreeAndNil(FDialogsLookAndFeel);
  FreeAndNil(FNavigationPane);
  FreeAndNil(FFindPanel);
  FreeAndNil(FPainter);
  FreeAndNil(FTextSearch);
  FreeAndNil(FDocument);
  inherited DestroySubClasses;
end;

procedure TdxPDFCustomViewer.DoCalculate(AType: TdxChangeType);
var
  APrevValue: Boolean;
  ARect: TRect;
begin
  ARect := cxRectInflate(Bounds, -BorderSize);
  NavigationPane.ViewInfo.Calculate(AType, ARect);
  FDocumentArea := cxRectUnion(ARect, NavigationPane.ViewInfo.Bounds);
  FindPanel.ViewInfo.Calculate(AType, ClientBounds);
  inherited DoCalculate(AType);
  ViewInfo.Calculate(AType, ClientBounds);

  UpdateScrollBars;
  if not FIsDocumentClearing then
  begin
    APrevValue := FCanMakeVisibleAnimate;
    try
      FCanMakeVisibleAnimate := False;
      CheckPositions;
    finally
      FCanMakeVisibleAnimate := APrevValue;
    end;
  end;

  UpdateRenderQueue(True);
end;

procedure TdxPDFCustomViewer.Initialize;
begin
  inherited Initialize;
  FCanMakeVisibleAnimate := True;
  FPasswordAttemptsLimit := dxPDFDefaultPasswordAttemptsLimit;
  BeginUpdate;
  try
    InternalOptionsBehavior := [pobKeyNavigation, pobThumbTracking];
    InternalOptionsView := [povAutoHideScrollBars, povDefaultDrawPageBackground, povPageSelection];
    OptionsHint := [pohShowOnScroll];
    Keys := [kArrows, kChars];
  finally
    CancelUpdate;
  end;
end;

procedure TdxPDFCustomViewer.HideAllHints;
begin
  inherited HideAllHints;
  if ViewerController <> nil then  
    ViewerController.HideHints;
end;

procedure TdxPDFCustomViewer.FocusChanged;
begin
  inherited FocusChanged;
  if ViewerController <> nil then 
    ViewerController.FocusChanged;
end;

function TdxPDFCustomViewer.CanProcessScrollEvents(var Message: TMessage): Boolean;
begin
  Result := inherited CanProcessScrollEvents(Message) and not IsDesigning;
end;

function TdxPDFCustomViewer.CreateLayoutCalculator: TdxCustomPreviewLayoutCalculator;
begin
  if OptionsView.PageLayout = plSinglePageContinuous then
    Result := TdxPDFViewerColumnContinuousCalculator.Create(Self, 1)
  else
    Result := TdxPDFViewerAutomaticLayoutCalculator.Create(Self);
end;

function TdxPDFCustomViewer.CreatePage: TdxPreviewPage;
var
  APage: TdxPDFViewerPage;
begin
  if (FDocument <> nil) and (FDocument.Pages <> nil) and (FDocument.PageCount > 0) then
  begin
    Result := inherited CreatePage;
    APage := Result as TdxPDFViewerPage;
    APage.DocumentPage := TdxPDFPagesAccess(FDocument.Pages).List[PageCount - 1];
  end
  else
    Result := nil;
end;

function TdxPDFCustomViewer.DoMouseWheel(AShift: TShiftState; AWheelDelta: Integer; AMousePos: TPoint): Boolean;
var
  AController: TdxPDFViewerCustomController;
begin
  Result := IsDocumentLoaded;
  if Result then
  begin
    AController := ActiveController;
    Result := (AController <> nil) or ControllerFromPoint(GetMouseCursorClientPos, AController) and
      AController.MouseWheel(AShift, AWheelDelta, AMousePos);
  end;
  if not Result then
    Result := inherited DoMouseWheel(AShift, AWheelDelta, AMousePos);
end;

function TdxPDFCustomViewer.GetClientBounds: TRect;
begin
  Result := inherited GetClientBounds;
  if NavigationPane.CanShow then
    Result := NavigationPane.CalculateParentClientBounds(Result);
end;

function TdxPDFCustomViewer.GetDefaultHeight: Integer;
begin
  Result := dxPDFViewerDefaultSize.cy;
end;

function TdxPDFCustomViewer.GetDefaultMaxZoomFactor: Integer;
begin
  Result := dxPDFViewerMaxZoomFactor;
end;

function TdxPDFCustomViewer.GetDefaultMinZoomFactor: Integer;
begin
  Result := dxPDFViewerMinZoomFactor;
end;

function TdxPDFCustomViewer.GetDefaultWidth: Integer;
begin
  Result := dxPDFViewerDefaultSize.cx;
end;

function TdxPDFCustomViewer.GetDragAndDropObjectClass: TcxDragAndDropObjectClass;
begin
  Result := TdxPDFViewerResizeNavigationPaneDragAndDropObject;
end;

function TdxPDFCustomViewer.GetDefaultZoomFactor: Integer;
begin
  Result := dxPDFViewerDefaultZoomFactor;
end;

function TdxPDFCustomViewer.GetDefaultZoomStep: Integer;
begin
  Result := dxPDFViewerZoomStep;
end;

function TdxPDFCustomViewer.GetPageClass: TdxPreviewPageClass;
begin
  Result := TdxPDFViewerPage;
end;

function TdxPDFCustomViewer.GetPageSizeOptionsClass: TdxPreviewPageSizeOptionsClass;
begin
  Result := TdxPDFViewerPageSizeOptions;
end;

function TdxPDFCustomViewer.StartDragAndDrop(const P: TPoint): Boolean;
begin
  Result := not IsDesigning and NavigationPane.HitTest.HitAtSplitter;
end;

procedure TdxPDFCustomViewer.CalculatePageNumberHintText(AStartPage, AEndPage: Integer; var AText: string);
begin
  AText := AText + IntToStr(CurrentPageIndex + 1)
end;

procedure TdxPDFCustomViewer.ChangeScaleEx(M, D: Integer; isDpiChange: Boolean);
begin
  inherited ChangeScaleEx(M, D, isDpiChange);
  NavigationPane.PageSize := MulDiv(NavigationPane.PageSize, M, D);
end;

procedure TdxPDFCustomViewer.DoContextPopup(MousePos: TPoint; var Handled: Boolean);

  function CanShowContextPopup: Boolean;
  begin
    Result := not (IsFindPanelVisible and HitTest.HitAtFindPanel);
  end;

begin
  inherited DoContextPopup(MousePos, Handled);
  if not Handled and IsDocumentLoaded and not TextSearch.IsLocked then
  begin
    UpdateActiveController(GetMouseCursorClientPos);
    if CanShowContextPopup then
      Handled := ActiveController.ContextPopup(ClientToScreen(GetMouseCursorClientPos));
    ActiveController := nil;
  end;
end;

procedure TdxPDFCustomViewer.DoSelectedPageChanged;
begin
  NavigationPane.Thumbnails.SynchronizeSelectedPage;
  inherited DoSelectedPageChanged;
end;

procedure TdxPDFCustomViewer.SetZoomFactor(Value: Integer);
begin
  BeginZooming;
  try
    inherited SetZoomFactor(Value);
  finally
    EndZooming;
  end;
end;

procedure TdxPDFCustomViewer.DoZoomFactorChanged;
begin
  inherited DoZoomFactorChanged;
  LayoutCalculator.ZoomContent;
end;

procedure TdxPDFCustomViewer.DoZoomModeChanged;
begin
  inherited DoZoomModeChanged;
  if not IsUpdateLocked then
    FController.ViewStateHistoryController.StoreCurrentViewState(vsctZooming);
end;

procedure TdxPDFCustomViewer.DoPaint;
begin
  DrawViewerBackground(Canvas, ClientRect);
  Canvas.Brush.Color := clNone;
  inherited DoPaint;
end;

procedure TdxPDFCustomViewer.DrawContent(ACanvas: TcxCanvas; const R: TRect);
begin
  if PageCount = 0 then
    DrawNoPages(ACanvas)
  else
  begin
    ACanvas.SaveClipRegion;
    try
      if GetScrollbarMode <> sbmHybrid then
        ACanvas.IntersectClipRect(ClientBounds);
      DrawPages(ACanvas);
      DrawCaret;
    finally
      ACanvas.RestoreClipRegion;
    end;
  end;

  if FindPanel.AnimationController.Active then
    FindPanel.AnimationController.Draw(ACanvas)
  else
    FindPanel.ViewInfo.Draw(ACanvas);

  NavigationPane.ViewInfo.Draw(ACanvas);
end;

procedure TdxPDFCustomViewer.DrawNoPages(ACanvas: TcxCanvas);
begin
  if not OptionsLockedStateImage.Enabled or OptionsLockedStateImage.Enabled and not FIsDocumentLoading then
    inherited DrawNoPages(ACanvas);
end;

procedure TdxPDFCustomViewer.DrawPageBackground(ACanvas: TcxCanvas; APage: TdxPreviewPage; ASelected: Boolean);
begin
  inherited DrawPageBackground(ACanvas, APage, CanHighlightCurrentPage(ASelected));
end;

procedure TdxPDFCustomViewer.DrawScrollBars(ACanvas: TcxCustomCanvas);
begin
  ACanvas.SaveClipRegion;
  try
    ACanvas.IntersectClipRect(FDocumentArea);
    inherited DrawScrollBars(ACanvas);
  finally
    ACanvas.RestoreClipRegion;
  end;
end;

procedure TdxPDFCustomViewer.InternalGoToFirstPage;
begin
  ChangePage(SelectFirstPage);
end;

procedure TdxPDFCustomViewer.InternalGoToLastPage;
begin
  ChangePage(SelectLastPage);
end;

procedure TdxPDFCustomViewer.InternalGoToNextPage;
begin
  ChangePage(SelectNextPage);
end;

procedure TdxPDFCustomViewer.InternalGoToPrevPage;
begin
  ChangePage(SelectPrevPage);
end;

procedure TdxPDFCustomViewer.FontChanged;
begin
  inherited FontChanged;
  LayoutChanged(ctMedium);
end;

procedure TdxPDFCustomViewer.KeyDown(var Key: Word; Shift: TShiftState);
var
  AHandled: Boolean;
begin
  if not IsDocumentAvailable then
    Exit;
  if Assigned(OnKeyDown) then
     OnKeyDown(Self, Key, Shift);
  AHandled := False;
  if not TextSearch.IsLocked then
    AHandled := FindPanel.Controller.KeyDown(Key, Shift);
  if not AHandled then
    AHandled := ViewerController.KeyDown(Key, Shift);
  if not AHandled then
    inherited KeyDown(Key, Shift)
  else
    Key := 0;
end;

procedure TdxPDFCustomViewer.KeyUp(var Key: Word; Shift: TShiftState);
begin
  if IsDocumentLoaded and not TextSearch.IsLocked then
    if Assigned(OnKeyUp) then
      OnKeyUp(Self, Key, Shift)
    else
      if ViewInfo.IsFocused then
        inherited KeyUp(Key, Shift);
end;

procedure TdxPDFCustomViewer.KeyPress(var Key: Char);
begin
  if IsDocumentLoaded and not TextSearch.IsLocked then
  begin
    if Assigned(OnKeyPress) then
      OnKeyPress(Self, Key)
    else
      inherited KeyPress(Key);
   ViewerController.KeyPress(Key);
  end;
end;

procedure TdxPDFCustomViewer.LayoutChanged(AType: TdxChangeType = ctHard);
begin
  if CanCalculate and not FIsDocumentClearing then
  begin
    Calculate(AType);
    Invalidate;
  end;
end;

procedure TdxPDFCustomViewer.MakePageVisible(APageIndex: Integer;
  AAnimated: Boolean);
var
  ATopLeft: TPoint;
begin
  BeginScrolling;
  try
    ATopLeft := cxPoint(LeftPos, TopPos);
    inherited MakePageVisible(APageIndex, AAnimated);
    if AAnimated then
      SetLeftPosAnimated(ATopLeft.X)
    else
      LeftPos := ATopLeft.X;
  finally
    EndScrolling;
    ViewerController.ViewStateHistoryController.StoreCurrentViewState(vsctScrolling);
  end;
end;

procedure TdxPDFCustomViewer.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  AController: TdxPDFViewerCustomController;
begin
  ActiveController := nil;
  if ControllerFromPoint(X, Y, AController) then
    ActiveController := AController;
  inherited MouseDown(Button, Shift, X, Y);
  if ActiveController <> nil then
  begin
    StopScrollAnimation;
    ActiveController.MouseDown(Button, Shift, X, Y);
  end;
end;

procedure TdxPDFCustomViewer.MouseEnter(AControl: TControl);
var
  P: TPoint;
begin
  inherited MouseLeave(AControl);
  if DragAndDropState <> ddsInProcess then
  begin
    P := GetMouseCursorClientPos;
    UpdateActiveController(P);
    ActiveController.MouseEnter(AControl, P.X, P.Y);
  end;
  ActiveController := nil;
end;

procedure TdxPDFCustomViewer.MouseLeave(AControl: TControl);
var
  P: TPoint;
begin
  inherited MouseLeave(AControl);
  if DragAndDropState <> ddsInProcess then
  begin
    P := GetMouseCursorClientPos;
    UpdateActiveController(P);
    ActiveController.MouseLeave(AControl, P.X, P.Y);
  end;
  ActiveController := nil;
end;

procedure TdxPDFCustomViewer.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove(Shift, X, Y);
  if DragAndDropState <> ddsInProcess then
  begin
    UpdateActiveController(cxPoint(X, Y));
    ActiveController.MouseMove(Shift, X, Y);
  end;
  ActiveController := nil;
end;

procedure TdxPDFCustomViewer.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  AController: TdxPDFViewerCustomController;
begin
  inherited MouseUp(Button, Shift, X, Y);
  if ControllerFromPoint(X, Y, AController) then
    AController.MouseUp(Button, Shift, X, Y);
  ActiveController := nil;
end;

procedure TdxPDFCustomViewer.ProcessLeftClickByPage(Shift: TShiftState; X, Y: Integer);
begin
  // do nothing
end;

procedure TdxPDFCustomViewer.SetPaintRegion;
begin
  Canvas.IntersectClipRect(cxRectInflate(Bounds, -BorderSize));
end;

procedure TdxPDFCustomViewer.SetSelPageIndex(Value: Integer);
begin
  Value := TdxPDFUtils.MinMax(Value, -1, PageCount - 1);
  if (FSelPageIndex <> Value) and ((Value = -1) or CanSelectPage(Value)) then
    DoSetSelPageIndex(Value, not IsVertScrollAnimationProcessing);
end;

procedure TdxPDFCustomViewer.Scroll(AScrollBarKind: TScrollBarKind; AScrollCode: TScrollCode; var AScrollPos: Integer);
begin
  if not IsDesigning then
    inherited Scroll(AScrollBarKind, AScrollCode, AScrollPos);
end;

procedure TdxPDFCustomViewer.ScrollPosChanged(const AOffset: TPoint);
begin
  LayoutCalculator.ScrollContent(AOffset);
  ViewerController.ScrollPosChanged;
end;

procedure TdxPDFCustomViewer.SelectFirstPage;
var
  APreviousPageIndex: Integer;
begin
  if IsScrollAnimationEnabled then
  begin
    APreviousPageIndex := GetTargetSelectedPageIndex;
    inherited SelectFirstPage;
    if APreviousPageIndex = GetTargetSelectedPageIndex then
      SetScrollPosition(cxNullPoint, IsScrollAnimationEnabled)
    else
      MakeVisible(FTargetSelectedPageIndex);
  end
  else
  begin
    BeginUpdate;
    try
      APreviousPageIndex := GetTargetSelectedPageIndex;
      inherited SelectFirstPage;
      if APreviousPageIndex = GetTargetSelectedPageIndex then
      begin
        UpdateLeftTopPosition(cxNullPoint);
        CurrentPageIndex := 0;
      end;
      MakeVisible(CurrentPageIndex);
    finally
      EndUpdate;
    end;
  end;
  ViewerController.ViewStateHistoryController.StoreCurrentViewState(vsctScrolling);
end;

procedure TdxPDFCustomViewer.SelectLastPage;
var
  APreviousPageIndex: Integer;
begin
  if IsScrollAnimationEnabled then
  begin
    APreviousPageIndex := GetTargetSelectedPageIndex;
    inherited SelectLastPage;
    if APreviousPageIndex = GetTargetSelectedPageIndex then
      SetScrollPosition(cxPoint(LeftPos, MaxInt), IsScrollAnimationEnabled)
    else
      MakeVisible(FTargetSelectedPageIndex);
  end
  else
  begin
    BeginUpdate;
    try
      APreviousPageIndex := GetTargetSelectedPageIndex;
      inherited SelectLastPage;
      if APreviousPageIndex = GetTargetSelectedPageIndex then
        ScrollToDocumentFooter
      else
        MakeVisible(GetCurrentPageIndex);
    finally
      EndUpdate;
    end;
  end;
  ViewerController.ViewStateHistoryController.StoreCurrentViewState(vsctScrolling);
end;

procedure TdxPDFCustomViewer.SelectNextPage;
var
  APreviousPageIndex: Integer;
begin
  if IsScrollAnimationEnabled then
  begin
    APreviousPageIndex := GetTargetSelectedPageIndex;
    DoSelectNextPage(APreviousPageIndex);
    if APreviousPageIndex = GetTargetSelectedPageIndex then
      SelectLastPage
    else
      MakeVisible(FTargetSelectedPageIndex)
  end
  else
  begin
    BeginUpdate;
    try
      APreviousPageIndex := GetTargetSelectedPageIndex;
      inherited SelectNextPage;
      if (APreviousPageIndex = GetTargetSelectedPageIndex) and (APreviousPageIndex = PageCount - 1) then
        ScrollToDocumentFooter
      else
        MakeVisible(CurrentPageIndex);
    finally
      EndUpdate;
    end;
  end;
  ViewerController.ViewStateHistoryController.StoreCurrentViewState(vsctScrolling);
end;

procedure TdxPDFCustomViewer.SelectPrevPage;
var
  APreviousPageIndex: Integer;
begin
  if IsScrollAnimationEnabled then
  begin
    if (GetTargetSelectedPageIndex = PageCount - 1) and not PageList.Last.HeaderPartVisible then
      MakeVisible(GetTargetSelectedPageIndex)
    else
    begin
      APreviousPageIndex := GetTargetSelectedPageIndex;
      DoSelectPrevPage(APreviousPageIndex);
      if APreviousPageIndex = GetTargetSelectedPageIndex then
        SelectFirstPage
      else
        MakeVisible(FTargetSelectedPageIndex);
    end;
  end
  else
  begin
    BeginUpdate;
    try
      if (GetTargetSelectedPageIndex = PageCount - 1) and not PageList.Last.HeaderPartVisible then
        MakeVisible(GetTargetSelectedPageIndex)
      else
      begin
        APreviousPageIndex := GetTargetSelectedPageIndex;
        inherited SelectPrevPage;
        if APreviousPageIndex = GetTargetSelectedPageIndex then
          SelectFirstPage
        else
          MakeVisible(GetTargetSelectedPageIndex);
      end;
    finally
      EndUpdate;
    end;
  end;
  ViewerController.ViewStateHistoryController.StoreCurrentViewState(vsctScrolling);
end;

procedure TdxPDFCustomViewer.UpdateLeftTopPosition(const ATopLeft: TPoint; AAnimated: Boolean = False);
begin
  LockScrollBars;
  try
    Thumbnails.ThumbnailPreview.BeginUpdate;
    try
      SetScrollPosition(ATopLeft, AAnimated);
      LayoutCalculator.ActivateVisiblePage;
    finally
      Thumbnails.ThumbnailPreview.EndUpdate;
      Thumbnails.SynchronizeSelectedPage;
    end;
  finally
    UnlockScrollBars;
  end;
end;


function TdxPDFCustomViewer.CanOpenAttachment(AAttachment: TdxPDFFileAttachment): Boolean;
begin
  if Assigned(FOnAttachmentOpen) then
  begin
    FOnAttachmentOpen(Self, AAttachment, Result);
    Result := not Result;
  end
  else
    Result := True;
end;

function TdxPDFCustomViewer.CanOpenUri(const AUri: string): Boolean;
begin
  if Assigned(FOnHyperlinkClick) then
  begin
    FOnHyperlinkClick(Self, AUri, Result);
    Result := not Result;
  end
  else
    Result := True;
end;

function TdxPDFCustomViewer.CanSaveAttachment(AAttachment: TdxPDFFileAttachment): Boolean;
begin
  if Assigned(FOnAttachmentSave) then
  begin
    FOnAttachmentSave(Self, AAttachment, Result);
    Result := not Result;
  end
  else
    Result := True;
end;

function TdxPDFCustomViewer.DoCreateDocument: TdxPDFDocument;
begin
  Result := TdxPDFViewerDocument.Create(Self);
  Result.PasswordAttemptsLimit := FPasswordAttemptsLimit;
end;

function TdxPDFCustomViewer.DoGetPassword(var APassword: string): Boolean;
begin
  if Assigned(OnGetPassword) then
    Result := OnGetPassword(Self, APassword)
  else
    Result := ShowPasswordDialog(Self, APassword);
end;

function TdxPDFCustomViewer.DoPrepareLockedStateImage: Boolean;
begin
  Result := False;
  if Assigned(OnPrepareLockedStateImage) then
    OnPrepareLockedStateImage(Self, LockedStatePaintHelper.Bitmap, Result);
end;

function TdxPDFCustomViewer.CreateLockedStatePaintHelper: TdxPDFViewerLockedStatePaintHelper;
begin
  Result := TdxPDFViewerLockedStatePaintHelper.Create(Self);
end;

function TdxPDFCustomViewer.CreateOptionsLockedStateImage: TdxPDFViewerLockedStateImageOptions;
begin
  Result := TdxPDFViewerLockedStateImageOptions.Create(Self);
end;

function TdxPDFCustomViewer.GetControllerClass: TdxPDFViewerControllerClass;
begin
  Result := TdxPDFViewerController;
end;

function TdxPDFCustomViewer.GetPainterClass: TdxPDFViewerPainterClass;
begin
  Result := TdxPDFViewerPainter;
end;

function TdxPDFCustomViewer.CanChangeVisibility: Boolean;
begin
  Result := (OptionsFindPanel.DisplayMode = fpdmManual) or Assigned(OnShowFindPanel) and Assigned(OnHideFindPanel) and
    Assigned(OnGetFindPanelVisibility);
end;

function TdxPDFCustomViewer.CanHighlightCurrentPage(AIsPageActive: Boolean): Boolean;
begin
  Result := AIsPageActive and OptionsView.HighlightCurrentPage;
end;

function TdxPDFCustomViewer.CanShowFindPanel: Boolean;
begin
  Result := IsDocumentLoaded and (OptionsFindPanel.DisplayMode <> fpdmNever) and not TextSearch.IsLocked;
end;

function TdxPDFCustomViewer.CanHideFindPanel: Boolean;
begin
  Result := not TextSearch.IsLocked and (not IsDestroying and not IsDocumentLoaded and IsFindPanelVisible or
    IsDocumentLoaded and (OptionsFindPanel.DisplayMode <> fpdmAlways));
end;

procedure TdxPDFCustomViewer.SetFindPanelFocus;
begin
  FindPanel.SetFocuse;
end;

function TdxPDFCustomViewer.IsZoomingLocked: Boolean;
begin
  Result := FZoomingLockCount <> 0;
end;

procedure TdxPDFCustomViewer.BeginBoundsChange;
begin
  FIsBoundsChanging := True;
end;

procedure TdxPDFCustomViewer.BeginScrolling;
begin
  Inc(FScrollingLockCount);
end;

procedure TdxPDFCustomViewer.BeginZooming;
begin
  ViewInfo.LockRecreateCells;
  RestartRenderContentTimer;
  Inc(FZoomingLockCount);
end;

procedure TdxPDFCustomViewer.EndBoundsChange;
begin
  FIsBoundsChanging := False;
end;

procedure TdxPDFCustomViewer.EndScrolling;
begin
  Dec(FScrollingLockCount);
  if FScrollingLockCount = 0 then
  begin
    UpdateScrollBars;
    UpdateRenderQueue;
    Invalidate;
  end;
end;

procedure TdxPDFCustomViewer.EndZooming;
begin
  Dec(FZoomingLockCount);
  ViewInfo.UnLockRecreateCells;
end;

function TdxPDFCustomViewer.CanExtractContent: Boolean;
begin
  Result := IsDocumentLoaded and Document.AllowContentExtraction;
end;

function TdxPDFCustomViewer.CanDrawCaret: Boolean;
begin
  Result := IsDocumentAvailable and not FindPanel.AnimationController.Active and
    SelectionController.Caret.IsValid and (not IsFindPanelVisible or IsFindPanelVisible and not FindPanel.Edit.Focused);
end;

function TdxPDFCustomViewer.CanPrint: Boolean;
begin
  Result := dxPrintingRepository.CanBuildReport(Self) and IsDocumentLoaded and Document.AllowPrinting;
end;

function TdxPDFCustomViewer.CanUseAnimation: Boolean;
begin
  Result := not IsDesigning and Visible and HandleAllocated and IsWindowVisible(Handle) and
    (OptionsFindPanel.AnimationTime > 0);
end;

function TdxPDFCustomViewer.CanZoomIn: Boolean;
begin
  Result := ZoomFactor < MaxZoomFactor;
end;

function TdxPDFCustomViewer.CanZoomOut: Boolean;
begin
  Result := ZoomFactor > MinZoomFactor;
end;

function TdxPDFCustomViewer.CreatePainter: TdxPDFViewerPainter;
begin
  Result := GetPainterClass.Create(Self);
end;

function TdxPDFCustomViewer.IsDocumentAvailable: Boolean;
begin
  Result := IsDocumentLoaded and not FIsDocumentClearing;
end;

function TdxPDFCustomViewer.IsDocumentLoading: Boolean;
begin
  Result := FIsDocumentLoading;
end;

function TdxPDFCustomViewer.IsDocumentPanning: Boolean;
begin
  Result := ViewerController.IsDocumentPanning;
end;

function TdxPDFCustomViewer.IsDocumentSelecting: Boolean;
begin
  Result := ViewerController.IsDocumentSelecting;
end;

function TdxPDFCustomViewer.GetLayoutCalculator: TdxPDFViewerCustomLayoutCalculator;
begin
  Result := inherited LayoutCalculator as TdxPDFViewerCustomLayoutCalculator;
end;

procedure TdxPDFCustomViewer.DeleteCaret;
begin
  if FCaretBitmap <> nil then
  begin
    DeleteObject(FCaretBitmap.Handle);
    FreeAndNil(FCaretBitmap);
    DestroyCaret;
    Invalidate;
  end;
end;

procedure TdxPDFCustomViewer.DoSetFocus;
begin
  if CanFocusEx then
    SetFocus;
end;


procedure TdxPDFCustomViewer.DrawCaret;
var
  ASize: TPoint;
  AHeight: Double;
  R: TdxRectF;
  AAngle: Integer;
  ACaretPage: TdxPDFViewerPage;
  ARotationAngle: TcxRotationAngle;
begin
  if CanDrawCaret then
  begin
    ACaretPage := Pages[SelectionController.Caret.Position.PageIndex] as TdxPDFViewerPage;
    R.TopLeft := SelectionController.Caret.ViewData.TopLeft;
    R.Right := R.Left + 1;
    R.Bottom := R.Top - SelectionController.Caret.ViewData.Height;
    R := ACaretPage.ToViewerRect(cxRectAdjustF(R));
    AHeight := SelectionController.Caret.ViewData.Height * DocumentScaleFactor.X * DocumentToViewerFactor.X;
    ASize.X := 1;
    ASize.Y := Round(AHeight) + 1;
    ARotationAngle := RotationAngle;
    AAngle := Trunc(RadToDeg(SelectionController.Caret.ViewData.Angle));
    if (ARotationAngle in [raPlus90, raMinus90]) or (AAngle = 90) then
    begin
      ASize.X := Round(AHeight) + 1;
      ASize.Y := 1;
    end;
    DrawCaret(cxPoint(R.TopLeft), ASize);
  end;
end;

procedure TdxPDFCustomViewer.DrawCaret(const P, ASize: TPoint);
const
  Color = clBlack;
var
  ACaretRect: TRect;
  ARealSize, ARealDestPoint: TPoint;
  AFindPanelBounds: TRect;
begin
  ARealSize := ASize;
  ARealDestPoint := P;
  ACaretRect := cxRectSetSize(cxRect(P, P), ASize.X, ASize.Y) ;
  AFindPanelBounds := FindPanel.ViewInfo.Bounds;
  if cxRectIntersect(ACaretRect, AFindPanelBounds) and IsFindPanelVisible then
    case RotationAngle of
      raMinus90, raPlus90:
        begin
          if FindPanel.Controller.CanActivate(P) then
          begin
            ARealSize.X := ARealDestPoint.X + ARealSize.X - AFindPanelBounds.Right;
            ARealDestPoint.X := AFindPanelBounds.Right;
          end
          else
            ARealSize.X := AFindPanelBounds.Left - ARealDestPoint.X;
          ACaretRect := cxRect(0, 0, ARealSize.X, ARealSize.Y);
        end;
      ra0, ra180:
        begin
          if FindPanel.Controller.CanActivate(ARealDestPoint) then
          begin
            ARealSize.Y := ARealDestPoint.Y - AFindPanelBounds.Top;
            ARealDestPoint.Y := AFindPanelBounds.Bottom;
          end
          else
            ARealSize.Y := AFindPanelBounds.Top - ARealDestPoint.Y;
         if RotationAngle = ra180 then
           ACaretRect := cxRect(0, ARealSize.Y, ARealSize.X, 0);
        end;
    end;
  DestroyCaret;
  if (ARealSize.X > 0) and (ARealSize.Y > 0) and PtInRect(ClientBounds, ARealDestPoint) then
  begin
    FreeAndNil(FCaretBitmap);
    FCaretBitmap := TcxBitmap32.Create;
    FCaretBitmap.SetSize(ARealSize.X, ARealSize.Y);
    dxGPPaintCanvas.BeginPaint(FCaretBitmap.Canvas.Handle, FCaretBitmap.ClientRect);
    try
      dxGPPaintCanvas.Line(ACaretRect.Left, ACaretRect.Top, ACaretRect.Right, ACaretRect.Bottom, Color);
    finally
      dxGPPaintCanvas.EndPaint;
    end;
    CreateCaret(Handle, FCaretBitmap.Handle, 0, 0);
    SetCaretPos(ARealDestPoint.X, ARealDestPoint.Y);
  end;
end;

procedure TdxPDFCustomViewer.LockHistoryAndExecute(AProc: TProc);
begin
  if not Assigned(AProc) then
    Exit;
  ViewerController.ViewStateHistoryController.BeginUpdate;
  try
    AProc;
  finally
    ViewerController.ViewStateHistoryController.EndUpdate;
  end;
end;

procedure TdxPDFCustomViewer.MakeVisibleWithoutAnimation(APageIndex: Integer);
var
  APrevValue: Boolean;
begin
  SelPageIndex := APageIndex;
  APrevValue := FCanMakeVisibleAnimate;
  try
    FCanMakeVisibleAnimate := False;
    MakeVisible(CurrentPageIndex);
  finally
    FCanMakeVisibleAnimate := APrevValue;
  end;
end;

procedure TdxPDFCustomViewer.FindNext;
begin
  if not IsFindPanelVisible then
    ShowFindPanel;
  FindPanel.Find;
end;

procedure TdxPDFCustomViewer.SetScrollPosition(const APosition: TPoint; AAnimated: Boolean = False);
begin
  ViewerController.SetScrollPosition(APosition, AAnimated);
end;

procedure TdxPDFCustomViewer.RecreatePages;
begin
  LockHistoryAndExecute(
    procedure
    begin
      BeginUpdate;
      try
        ViewerController.FocusedCell := nil;
        ViewerController.HideEdit;
        TdxPDFDocumentViewerCustomRendererAccess(Renderer).Clear;
        DocumentState.CalculateScreenFactors;
        LoadDocumentPages;
      finally
        EndUpdate;
      end;
      ViewerController.SetActiveAndMakeVisiblePage(ViewerController.ViewStateHistoryController.CurrentViewState.CurrentPageIndex, False);
    end);
end;

procedure TdxPDFCustomViewer.OpenAttachment(AAttachment: TdxPDFFileAttachment);
begin
  ViewerController.OpenAttachment(AAttachment);
end;

procedure TdxPDFCustomViewer.SaveAttachment(AAttachment: TdxPDFFileAttachment);
begin
  ViewerController.SaveAttachment(AAttachment);
end;

procedure TdxPDFCustomViewer.BeforeClearDocument;
begin
  inherited BeforeClearDocument;
  ViewerController.HideEdit;
  ViewerController.SelectionController.Clear;
  ViewerController.FocusedAnnotation := nil;
  ViewerController.TabNavigationController.LastPageIndex := CurrentPageIndex;
  DocumentState.ClearCache;
  ViewInfo.ClearCells;
end;

procedure TdxPDFCustomViewer.DocumentAttachmentsChanged;
begin
  inherited DocumentAttachmentsChanged;
  NavigationPane.Refresh(True);
end;

procedure TdxPDFCustomViewer.DocumentBookmarksChanged;
begin
  inherited DocumentBookmarksChanged;
  DestroyOutlines;
  NavigationPane.Refresh(True);
end;

procedure TdxPDFCustomViewer.DocumentInteractiveLayerChanged;
begin
  ViewerController.HideEdit;
  inherited DocumentInteractiveLayerChanged;
end;

procedure TdxPDFCustomViewer.DocumentLayoutChanged;
begin
  RecreatePages;
  UpdateRenderQueue(True);
  NavigationPane.Thumbnails.SynchronizeSelectedPage;
end;

procedure TdxPDFCustomViewer.UpdateActiveController(const P: TPoint);

  procedure Reset(AController: TdxPDFViewerContainerController);
  begin
    if AController <> ActiveController then
    begin
      AController.HitTest.Clear;
      AController.HotCell := nil;
      AController.UpdateState;
    end;
  end;

var
  AController: TdxPDFViewerCustomController;
begin
  if ControllerFromPoint(P, AController) then
    ActiveController := AController
  else
    ActiveController := ViewerController;
  Reset(FindPanel.Controller);
  Reset(NavigationPane.Controller);
  Reset(ViewerController);
end;

procedure TdxPDFCustomViewer.UpdateCursor;
begin
  if HandleAllocated then
    Perform(WM_SETCURSOR, Handle, HTCLIENT);
end;

procedure TdxPDFCustomViewer.AfterHorzScrollAnimationEnded;
begin
  if not IsUpdateLocked and IsDocumentAvailable then
    ViewerController.ScrollPosChanged;
end;

procedure TdxPDFCustomViewer.InternalSetCurrentPage(AValue: Integer; AAnimated: Boolean);
var
  APageIndex: Integer;
begin
  if AAnimated and IsVertScrollAnimationActive then
    APageIndex := FTargetSelectedPageIndex
  else
    APageIndex := SelPageIndex;
  if (APageIndex <> AValue) and (PageCount > 0) then
  begin
    BeginUpdate;
    try
      ViewerController.SetActiveAndMakeVisiblePage(AValue, AAnimated);
    finally
      EndUpdate;
      FController.ViewStateHistoryController.StoreCurrentViewState(vsctScrolling);
    end;
  end;
end;

procedure TdxPDFCustomViewer.BeforeVertScrollAnimationStarted;
begin
  inherited BeforeVertScrollAnimationStarted;
  FStartSelectedPageIndex := CurrentPageIndex;
end;

procedure TdxPDFCustomViewer.StopVertScrollAnimation;
begin
  FTargetSelectedPageIndex := -1;
  inherited StopVertScrollAnimation;
end;

procedure TdxPDFCustomViewer.AfterVertScrollAnimationEnded;
var
  AValue: Integer;
begin
  if not IsUpdateLocked and IsDocumentAvailable then
  begin
    AValue := GetTargetSelectedPageIndex;
    DoSetSelPageIndex(AValue, FStartSelectedPageIndex <> AValue);
    ViewerController.ScrollPosChanged;
  end;
  ResetScrollAnimationPageRange;
end;

function TdxPDFCustomViewer.GetActivePage: TdxPDFViewerPage;
begin
  Result := Pages[CurrentPageIndex] as TdxPDFViewerPage;
end;

function TdxPDFCustomViewer.GetAttachments: TdxPDFViewerAttachments;
begin
  Result := NavigationPane.Attachments;
end;

function TdxPDFCustomViewer.GetBookmarks: TdxPDFViewerBookmarks;
begin
  Result := NavigationPane.Bookmarks;
end;

function TdxPDFCustomViewer.GetCurrentPageIndex: Integer;
begin
  Result := IfThen(SelPageIndex <> -1, SelPageIndex, 0);
end;

function TdxPDFCustomViewer.GetDocument: TdxPDFDocument;
begin
  Result := FDocument;
end;

function TdxPDFCustomViewer.GetDocumentScaleFactor: TdxPointF;
begin
  Result := DocumentState.ScaleFactor;
end;

function TdxPDFCustomViewer.GetDocumentState: TdxPDFViewerDocumentState;
begin
  Result := inherited DocumentState as TdxPDFViewerDocumentState;
end;

function TdxPDFCustomViewer.GetDocumentToViewerFactor: TdxPointF;
begin
  Result := DocumentState.DocumentToViewerFactor;
end;

function TdxPDFCustomViewer.GetHandTool: Boolean;
begin
  Result := DocumentState.HandTool;
end;

function TdxPDFCustomViewer.GetOptionsFindPanel: TdxPDFViewerOptionsFindPanel;
begin
  Result := FindPanel.Options;
end;

function TdxPDFCustomViewer.GetOptionsNavigationPane: TdxPDFViewerOptionsNavigationPane;
begin
  Result := NavigationPane.Options;
end;

function TdxPDFCustomViewer.GetOnCustomDrawPreRenderPageThumbnail: TdxPDFDocumentViewerOnCustomDrawPreRenderPageEvent;
begin
  Result := Thumbnails.ThumbnailPreview.OnCustomDrawPreRenderPage;
end;

function TdxPDFCustomViewer.GetOutlines: TdxPDFDocumentOutlineList;
begin
  if not IsDocumentLoaded then
    Exit(nil);
  if FOutlines = nil then
  begin
    FOutlines := TdxPDFDocumentOutlineList.Create;
    TdxPDFDocumentOutlineTreeAccess(FOutlines).Read(TdxPDFDocumentAccess(Document).Catalog);
  end;
  Result := FOutlines;
end;

function TdxPDFCustomViewer.GetRotationAngle: TcxRotationAngle;
begin
  Result := DocumentState.RotationAngle;
end;

function TdxPDFCustomViewer.GetSelectionController: TdxPDFViewerSelectionController;
begin
  Result := FController.SelectionController;
end;

function TdxPDFCustomViewer.GetThumbnails: TdxPDFViewerThumbnails;
begin
  Result := NavigationPane.Thumbnails;
end;

procedure TdxPDFCustomViewer.SetCurrentPageIndex(const AValue: Integer);
begin
  InternalSetCurrentPage(AValue, IsScrollAnimationEnabled);
end;

procedure TdxPDFCustomViewer.SetDialogsLookAndFeel(const AValue: TcxLookAndFeel);
begin
  FDialogsLookAndFeel.Assign(AValue);
end;

procedure TdxPDFCustomViewer.SetHandTool(const AValue: Boolean);
begin
  DocumentState.HandTool := AValue;
end;

procedure TdxPDFCustomViewer.SetOnSearchProgress(const AValue: TdxPDFDocumentTextSearchProgressEvent);
begin
  FOnSearchProgress := AValue;
  if IsDocumentLoaded then
    FDocument.OnSearchProgress := FOnSearchProgress;
end;

procedure TdxPDFCustomViewer.SetOnCustomDrawPreRenderPageThumbnail(const AValue: TdxPDFDocumentViewerOnCustomDrawPreRenderPageEvent);
begin
  Thumbnails.ThumbnailPreview.OnCustomDrawPreRenderPage := AValue;
end;

procedure TdxPDFCustomViewer.SetOptionsBehavior(const AValue: TdxPDFViewerOptionsBehavior);
begin
  FOptionsBehavior.Assign(AValue);
end;

procedure TdxPDFCustomViewer.SetOptionsFindPanel(const AValue: TdxPDFViewerOptionsFindPanel);
begin
  FindPanel.Options := AValue;
end;

procedure TdxPDFCustomViewer.SetOptionsForm(const AValue: TdxPDFViewerOptionsForm);
begin
  FOptionsForm.Assign(AValue);
end;

procedure TdxPDFCustomViewer.SetOptionsLockedStateImage(AValue: TdxPDFViewerLockedStateImageOptions);
begin
  FOptionsLockedStateImage.Assign(AValue);
end;

procedure TdxPDFCustomViewer.SetOptionsNavigationPane(const AValue: TdxPDFViewerOptionsNavigationPane);
begin
  NavigationPane.Options := AValue;
end;

procedure TdxPDFCustomViewer.SetOptionsSelection(const AValue: TdxPDFViewerOptionsSelection);
begin
  FOptionsSelection.Assign(AValue);
end;

procedure TdxPDFCustomViewer.SetOptionsView(const AValue: TdxPDFViewerOptionsView);
begin
  FOptionsView.Assign(AValue);
end;

procedure TdxPDFCustomViewer.SetOptionsZoom(const AValue: TdxPDFViewerOptionsZoom);
begin
  FOptionsZoom.Assign(AValue);
end;

procedure TdxPDFCustomViewer.SetRotationAngle(const AValue: TcxRotationAngle);
begin
  if RotationAngle <> AValue then
  begin
    FController.HideEdit;
    DocumentState.RotationAngle := AValue;
    RecreatePages;
    FController.ViewStateHistoryController.StoreCurrentViewState(vsctRotation);
  end;
end;

function TdxPDFCustomViewer.ControllerFromPoint(const P: TPoint; var AController: TdxPDFViewerCustomController): Boolean;
begin
  Result := IsDocumentLoaded and not TextSearch.IsLocked and not (DragAndDropState = ddsInProcess);
  if Result then
  begin
    AController := ActiveController;
    if AController = nil then
    begin
      if FindPanel.Controller.CanActivate(P) then
          AController := FindPanel.Controller
      else
        if NavigationPane.Controller.CanActivate(P) then
          AController := NavigationPane.Controller
        else
          if ViewerController.CanActivate(P) then
            AController := ViewerController;
    end;
    Result := AController <> nil;
  end;
end;

function TdxPDFCustomViewer.ControllerFromPoint(X, Y: Integer; var AController: TdxPDFViewerCustomController): Boolean;
begin
  Result := ControllerFromPoint(Point(X, Y), AController);
end;

function TdxPDFCustomViewer.GetTargetSelectedPageIndex: Integer;
begin
  if FTargetSelectedPageIndex <> -1 then
    Result := FTargetSelectedPageIndex
  else
    Result := CurrentPageIndex;
end;

procedure TdxPDFCustomViewer.AfterLoadDocument;
begin
  HideHourglassCursor;
  EndUpdate;
  LockedStatePaintHelper.EndLockedPaint;
  FIsDocumentLoading := False;
end;

procedure TdxPDFCustomViewer.BeforeLoadDocument;
begin
  FIsDocumentLoading := True;
  BeginUpdate;
  Clear;
  CancelUpdate;
  LockedStatePaintHelper.BeginLockedPaint(lsimImmediate);
  Document.PasswordAttemptsLimit := PasswordAttemptsLimit;
  BeginUpdate;
  ShowHourglassCursor;
end;

procedure TdxPDFCustomViewer.DestroyOutlines;
begin
  FreeAndNil(FOutlines)
end;

procedure TdxPDFCustomViewer.DoSetSelPageIndex(AValue: Integer; AIsEventFired: Boolean);
begin
  if AIsEventFired then
    DoSelectedPageChanging;
  FSelPageIndex := AValue;
  if AIsEventFired then
    DoSelectedPageChanged;
end;

procedure TdxPDFCustomViewer.ChangePage(AProc: TChangePageProc);
begin
  if IsScrollAnimationEnabled then
    AProc
  else
  begin
    BeginUpdate;
    try
      AProc;
    finally
      EndUpdate;
      ViewerController.ViewStateHistoryController.StoreCurrentViewState(vsctScrolling);
    end;
  end;
end;

procedure TdxPDFCustomViewer.CreateDocument;
begin
  FDocument := DoCreateDocument as TdxPDFViewerDocument;
  FDocument.OnGetPassword := OnGetPasswordHandler;
  FDocument.OnLoaded := OnDocumentLoadedHandler;
  FDocument.OnUnloaded := OnDocumentUnLoadedHandler;
  FDocument.OnSearchProgress := OnSearchProgress;
  TdxPDFDocumentAccess(FDocument).AddListener(Self);
end;

procedure TdxPDFCustomViewer.DoSelectPage(APageIndex: Integer);
begin
  if IsScrollAnimationEnabled then
    FTargetSelectedPageIndex := APageIndex
  else
    inherited;
end;

procedure TdxPDFCustomViewer.LoadDocumentPages;
begin
  PerformRecreatePages(
    procedure
    var
      I: Integer;
    begin
      ViewerController.FocusedCell := nil;
      ViewerController.HideEdit;
      NavigationPane.Thumbnails.Refresh;
      PageCount := 0;
      if not FIsDocumentClearing then
        for I := 0 to DocumentPages.Count - 1 do
          CreatePage;
    end);
end;

procedure TdxPDFCustomViewer.ResetScrollAnimationPageRange;
begin
  FStartSelectedPageIndex := -1;
  FTargetSelectedPageIndex := -1;
end;

procedure TdxPDFCustomViewer.ScrollToDocumentFooter;
begin
  UpdateLeftTopPosition(cxPoint(LeftPos, MaxInt));
  CurrentPageIndex := PageCount - 1;
end;

function TdxPDFCustomViewer.GetLockedStateImage: TcxBitmap32;
begin
  Result := LockedStatePaintHelper.GetImage;
end;

function TdxPDFCustomViewer.GetLockedStateTopmostControl: TcxControl;
begin
  Result := Self;
end;

function TdxPDFCustomViewer.OnGetPasswordHandler(Sender: TObject;
  {$IFDEF BCBCOMPATIBLE}var{$ELSE}out{$ENDIF} APassword: string): Boolean;
begin
  Result := DoGetPassword(APassword);
end;

procedure TdxPDFCustomViewer.OnDocumentLoadedHandler(Sender: TdxPDFDocument; const AInfo: TdxPDFDocumentLoadInfo);
begin
  BeginUpdate;
  try
    ResetScrollAnimationPageRange;
    RotationAngle := ra0;
    RecreatePages;
    GoToFirstPage;
    ClearViewStateHistory;
    if OptionsFindPanel.DisplayMode = fpdmAlways then
      ShowFindPanel;
    NavigationPane.Refresh;
  finally
    EndUpdate;
  end;
  if Assigned(FOnDocumentLoaded) then
    OnDocumentLoaded(Document, AInfo);
end;

procedure TdxPDFCustomViewer.OnDocumentUnLoadedHandler(Sender: TObject);
begin
  if not IsUpdateLocked and not IsDestroying then
    Clear;
end;

procedure TdxPDFCustomViewer.OnSelectionChangedHandler(Sender: TObject);
begin
  dxCallNotify(OnSelectionChanged, Self);
end;

procedure TdxPDFCustomViewer.OnHighlightsChangedHandler(Sender: TObject);
begin
  if not IsDestroying then
    Invalidate;
end;

procedure TdxPDFCustomViewer.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  Message.Result := Message.Result or DLGC_WANTTAB;
end;

procedure TdxPDFCustomViewer.WMMouseActivate(var Message: TWMMouseActivate);
begin
  DefaultHandler(Message);
end;

{ TdxPDFViewerSelection }

constructor TdxPDFViewerSelection.Create(AViewer: TdxPDFCustomViewer);
begin
  inherited Create;
  FController := AViewer.SelectionController;
end;

function TdxPDFViewerSelection.IsEmpty: Boolean;
begin
  Result := Selection = nil;
end;

procedure TdxPDFViewerSelection.Clear;
begin
  FController.Clear;
end;

procedure TdxPDFViewerSelection.CopyToClipboard;
begin
  FController.CopyToClipboard;
end;

procedure TdxPDFViewerSelection.Select(const ARect: TRect; AMakeVisible: Boolean = False);
begin
  FController.Select(ARect);
  MakeVisible(AMakeVisible);
end;

procedure TdxPDFViewerSelection.SelectText(const ARange: TdxPDFPageTextRange; AMakeVisible: Boolean = True);
begin
  if ARange.IsValid then
  begin
    FController.SelectText(ARange);
    MakeVisible(AMakeVisible);
  end;
end;

procedure TdxPDFViewerSelection.SelectAll;
begin
  FController.SelectAll;
end;

function TdxPDFViewerSelection.AsBitmap: TBitmap;
begin
  Result := FController.GetSelectionAsBitmap;
end;

function TdxPDFViewerSelection.AsText: string;
begin
  Result := FController.GetSelectionAsText;
end;

function TdxPDFViewerSelection.IsImageSelection: Boolean;
begin
  Result := (Selection <> nil) and (Selection.HitCode = hcImage);
end;

function TdxPDFViewerSelection.IsTextSelection: Boolean;
begin
  Result := (Selection <> nil) and (Selection.HitCode = hcTextSelection);
end;

function TdxPDFViewerSelection.GetSelection: TdxPDFCustomSelection;
begin
  Result := FController.Selection;
end;

procedure TdxPDFViewerSelection.SetSelection(const AValue: TdxPDFCustomSelection);
begin
  FController.Selection := AValue;
end;

procedure TdxPDFViewerSelection.MakeVisible(AMake: Boolean);
begin
  if AMake then
    FController.MakeVisible;
end;

{ TdxPDFViewerTextSearch }

function TdxPDFViewerTextSearch.Find(const AText: string): TdxPDFDocumentTextSearchResult;
begin
  Result := Find(AText, FOptions);
end;

function TdxPDFViewerTextSearch.Find(const AText: string;
  const AOptions: TdxPDFDocumentTextSearchOptions): TdxPDFDocumentTextSearchResult;
begin
  FSearchString := AText;
  FOptions := AOptions;
  Result := InternalFind;
end;

procedure TdxPDFViewerTextSearch.Find(const AText: string; const AOptions: TdxPDFDocumentTextSearchOptions;
  var AFoundRanges: TdxPDFPageTextRanges);
begin
  FSearchString := AText;
  FOptions := AOptions;
  TdxPDFDocumentSequentialTextSearchAccess(FAdvancedTextSearch).Clear;
  TdxPDFDocumentSequentialTextSearchAccess(FAdvancedTextSearch).Find(Viewer.Document, AText, AOptions, 0);
  AFoundRanges := FAdvancedTextSearch.FoundRanges;
end;

procedure TdxPDFViewerTextSearch.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FAdvancedTextSearch := TdxPDFDocumentContinuousTextSearch.Create;
  FAdvancedTextSearch.OnComplete := AdvancedSearchCompleteHandler;
  FTextSearch := TdxPDFDocumentSequentialTextSearch.Create;
end;

procedure TdxPDFViewerTextSearch.DestroySubClasses;
begin
  FreeAndNil(FTextSearch);
  FreeAndNil(FAdvancedTextSearch);
  inherited DestroySubClasses;
end;

function TdxPDFViewerTextSearch.InternalFind: TdxPDFDocumentTextSearchResult;
var
  AMessage: string;
begin
  if Viewer.IsDocumentLoaded then
  begin
    Result := DoFind;
    if Result.Status = tssFound then
      Selection.SelectText(Result.Range)
    else
    begin
      if Result.Status = tssNotFound then
        AMessage := GetSearchNoMatchesFoundMessage
      else
        AMessage := GetSearchCompleteMessage;

      dxMessageBox(AMessage, Application.Title, MB_OK or MB_ICONINFORMATION);
      if Viewer.IsFindPanelVisible then
        Viewer.SetFindPanelFocus;
      Selection.Clear;
    end;
  end;
end;

function TdxPDFViewerTextSearch.IsLocked: Boolean;
begin
  Result := FLockCount > 0;
end;

procedure TdxPDFViewerTextSearch.BeginUpdate;
begin
  Inc(FLockCount);
  Viewer.FindPanel.ViewInfo.UpdateState;
end;

procedure TdxPDFViewerTextSearch.Clear;
begin
  TdxPDFDocumentSequentialTextSearchAccess(DocumentTextSearch).Clear;
end;

procedure TdxPDFViewerTextSearch.EndUpdate;
begin
  Dec(FLockCount);
  if not IsLocked then
    Viewer.FindPanel.ViewInfo.UpdateState;
end;

function TdxPDFViewerTextSearch.DoFind: TdxPDFDocumentTextSearchResult;
begin
  BeginUpdate;
  try
    Result := TdxPDFDocumentSequentialTextSearchAccess(DocumentTextSearch).Find(Viewer.Document, FSearchString,
      FOptions, Viewer.CurrentPageIndex);
  finally
    EndUpdate;
  end;
end;

procedure TdxPDFViewerTextSearch.AdvancedSearchCompleteHandler(Sender: TObject);
var
  ATextSearch: TdxPDFDocumentContinuousTextSearch;
begin
  if DocumentTextSearch is TdxPDFDocumentContinuousTextSearch then
  begin
    ATextSearch := TdxPDFDocumentContinuousTextSearch(DocumentTextSearch);
    Viewer.BeginUpdate;
    try
      Viewer.Highlights.Clear;
      Viewer.Highlights.Add(ATextSearch.FoundRanges, dxacDefault, dxacDefault);
    finally
      Viewer.EndUpdate;
    end;
  end;
end;

function TdxPDFViewerTextSearch.GetDocumentTextSearch: TdxPDFDocumentSequentialTextSearch;
begin
  if Viewer.OptionsFindPanel.HighlightSearchResults then
    Result := FAdvancedTextSearch
  else
    Result := FTextSearch;
  Result.OnProgress := Viewer.OnSearchProgress;
end;

function TdxPDFViewerTextSearch.GetSelection: TdxPDFViewerSelection;
begin
  Result := Viewer.Selection;
end;

function TdxPDFViewerTextSearch.GetSearchCompleteMessage: string;
begin
  Result := cxGetResourceString(@sdxPDFViewerTextSearchingCompleteMessage);
end;

function TdxPDFViewerTextSearch.GetSearchNoMatchesFoundMessage: string;
begin
  Result := cxGetResourceString(@sdxPDFViewerTextSearchingNoMatchesFoundMessage);
end;

{ TdxPDFViewerHighlights }

constructor TdxPDFViewerHighlights.Create(AViewer: TdxPDFCustomViewer);
begin
  inherited Create;
  FController := AViewer.SelectionController;
  FItems := TdxFastObjectList.Create;
  FVisible := bDefault;
end;

destructor TdxPDFViewerHighlights.Destroy;
begin
  FreeAndNil(FItems);
  inherited Destroy;
end;

procedure TdxPDFViewerHighlights.Add(const ARange: TdxPDFPageTextRange; ABackColor, AFrameColor: TdxAlphaColor);
begin
  InternalAdd(FController.CreateHighlight(ARange, ABackColor, AFrameColor));
end;

procedure TdxPDFViewerHighlights.Add(const ARanges: TdxPDFPageTextRanges; ABackColor, AFrameColor: TdxAlphaColor);
begin
  InternalAdd(FController.CreateHighlight(ARanges, ABackColor, AFrameColor));
end;

procedure TdxPDFViewerHighlights.Remove(const ARange: TdxPDFPageTextRange);
var
  AExcluded, AFound: Boolean;
  AHighlight: TdxPDFTextHighlight;
  I: Integer;
begin
  AFound := False;
  for I := 0 to Items.Count - 1 do
  begin
    AHighlight := TdxPDFTextHighlight(Items[I]);
    AExcluded := TdxPDFTextHighlightAccess(AHighlight).Exclude(ARange);
    if not AFound then
      AFound := AExcluded;
  end;
  if AFound then
    Changed;
end;

procedure TdxPDFViewerHighlights.Clear;
begin
  FItems.Clear;
  Changed;
end;

procedure TdxPDFViewerHighlights.SetVisible(const AValue: TdxDefaultBoolean);
begin
  if FVisible <> AValue then
  begin
    FVisible := AValue;
    Changed;
  end;
end;

procedure TdxPDFViewerHighlights.Changed;
begin
  dxCallNotify(OnChanged, Self);
end;

procedure TdxPDFViewerHighlights.InternalAdd(AValue: TdxPDFTextHighlight);
begin
  if (AValue <> nil) and (Items.IndexOf(AValue) = -1) then
  begin
    Items.Add(AValue);
    Changed;
  end;
end;

{ TdxPDFViewerCustomHitTest }

procedure TdxPDFViewerCustomHitTest.DestroySubClasses;
begin
  Clear;
  inherited DestroySubClasses;
end;

function TdxPDFViewerCustomHitTest.CanCalculate: Boolean;
begin
  Result := True;
end;

function TdxPDFViewerCustomHitTest.GetPopupMenuClass: TComponentClass;
begin
  Result := nil;
end;

procedure TdxPDFViewerCustomHitTest.Clear;
begin
  FHitPoint := cxInvalidPoint;
end;

procedure TdxPDFViewerCustomHitTest.DoCalculate(const AHitPoint: TPoint);
begin
  FHitPoint := AHitPoint;
end;

procedure TdxPDFViewerCustomHitTest.Calculate(const AHitPoint: TPoint);
begin
  Clear;
  if CanCalculate then
    DoCalculate(AHitPoint);
end;

{ TdxPDFViewerDocumentHitTest }

function TdxPDFViewerDocumentHitTest.CanCalculate: Boolean;
begin
  Result := not Viewer.TextSearch.IsLocked;
end;

function TdxPDFViewerDocumentHitTest.DoGetCursor: TCursor;
var
  AObject: IdxPDFInteractiveObject;
begin
  if HitAtInteractiveObject(AObject) then
    Result := AObject.GetCursor
  else
    if HitAtSelection then
      Result := crdxPDFViewerContext
    else
      if HitAtText then
        Result := crIBeam
      else
        if HitAtImage or Viewer.IsDocumentSelecting and Viewer.Selection.IsImageSelection then
          Result := crdxPDFViewerCross
        else
          Result := inherited DoGetCursor;
end;

function TdxPDFViewerDocumentHitTest.GetPopupMenuClass: TComponentClass;
begin
  if HitAtText and HitAtSelection then
    Result := TdxPDFViewerTextPopupMenu
  else
    if HitAtImage and HitAtSelection then
      Result := TdxPDFViewerImagePopupMenu
    else
      if HitAtAttachment then
        Result := TdxPDFViewerAttachmentPopupMenu
      else
        Result := TdxPDFViewerPagePopupMenu;
end;

procedure TdxPDFViewerDocumentHitTest.Clear;
begin
  inherited Clear;
  FHitContentObject := nil;
  FPosition.PageIndex := -1;
  FPosition.Point := dxNullPointF;
end;

procedure TdxPDFViewerDocumentHitTest.DoCalculate(const AHitPoint: TPoint);
var
  APage: TdxPDFViewerPage;
begin
  inherited DoCalculate(AHitPoint);
  FHitContentObject := nil;
  Viewer.ViewInfo.CalculateHitTest(Self);

  HitCodes[hcNavigationPaneSplitter] := Viewer.NavigationPane.HitTest.HitAtSplitter;
  HitCodes[hcFindPanel] := Viewer.FindPanel.Controller.CanActivate(HitPoint);

  APage := GetPage;
  HitCodes[hcBackground] := APage = nil;
  if HitAtBackground then
    APage := GetNearestPage;

  if APage <> nil then
  begin
    FPosition.PageIndex := APage.Index;
    FPosition.Point := APage.ToDocumentPoint(dxPointF(HitPoint));
    if HitAtDocumentViewer then
    begin
      if HitObject is TdxPDFViewerDocumentObjectViewInfo then
        FHitContentObject := HitObject;
      HitCodes[hcPageArea] := not HitAtBackground;
      if HitAtPage and Viewer.IsDocumentLoaded and not Viewer.IsZooming and (HitObject is TdxPDFViewerDocumentObjectViewInfo) then
        HitCodes[TdxPDFViewerDocumentObjectViewInfo(HitObject).HitCode] := True;
      HitCodes[hcSelectionFrame] := GetHitAtSelection;
      HitCodes[hcText] := Viewer.DocumentState.FindStartTextPosition(FPosition).IsValid;
    end;
  end;
end;

function TdxPDFViewerDocumentHitTest.CanShowHint;
begin
  Result := GetHintText <> '';
end;

function TdxPDFViewerDocumentHitTest.GetAttachment: TdxPDFFileAttachment;
begin
  if (FHitContentObject <> nil) and (FHitContentObject is TdxPDFViewerFileAttachmentViewInfo) then
    Result := TdxPDFViewerFileAttachmentViewInfoAccess(FHitContentObject).Attachment
  else
    Result := nil;
end;

function TdxPDFViewerDocumentHitTest.GetHintBounds: TRect;
var
  AObject: IdxPDFHintableObject;
begin
  Calculate(Viewer.GetMouseCursorClientPos);
  if Position.IsValid and HitAtHintableObject(AObject) then
    Result := AObject.GetBounds
  else
    Result := cxNullRect;
end;

function TdxPDFViewerDocumentHitTest.GetHintText: string;
var
  AObject: IdxPDFHintableObject;
begin
  if HitAtHintableObject(AObject) then
    Result := AObject.GetHint
  else
    Result := '';
end;

function TdxPDFViewerDocumentHitTest.HitAtHintableObject: Boolean;
begin
  Result := Supports(FHitContentObject, IdxPDFHintableObject);
end;

function TdxPDFViewerDocumentHitTest.HitAtHintableObject(out AObject: IdxPDFHintableObject): Boolean;
begin
  Result := Supports(FHitContentObject, IdxPDFHintableObject, AObject);
end;

function TdxPDFViewerDocumentHitTest.HitAtInteractiveObject: Boolean;
begin
  Result := Supports(FHitContentObject, IdxPDFInteractiveObject);
end;

function TdxPDFViewerDocumentHitTest.HitAtInteractiveObject(out AObject: IdxPDFInteractiveObject): Boolean;
begin
  Result := Supports(FHitContentObject, IdxPDFInteractiveObject, AObject);
end;

function TdxPDFViewerDocumentHitTest.GetHitAtDocumentViewer: Boolean;
begin
  Result := not (Viewer.NavigationPane.Controller.CanActivate(HitPoint) or Viewer.NavigationPane.HitTest.HitAtSplitter or
    (Viewer.DragAndDropState = ddsInProcess));
end;

function TdxPDFViewerDocumentHitTest.GetHitAtSelection: Boolean;
begin
  Result := Viewer.SelectionController.HitAtSelection;
end;

function TdxPDFViewerDocumentHitTest.GetPage: TdxPDFViewerPage;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Viewer.PageCount - 1 do
    if PtInRect(Viewer.Pages[I].Bounds, HitPoint) then
      Exit(Viewer.Pages[I] as TdxPDFViewerPage);
end;

function TdxPDFViewerDocumentHitTest.GetNearestPage: TdxPDFViewerPage;
var
  APageIndex: Integer;
begin
  Result := nil;
  if Viewer.IsDocumentLoaded and (Viewer.Document.PageCount > 0) then
  begin
    APageIndex := Viewer.GetNearestPageIndex(HitPoint,
      function(PageIndex: Integer): TdxRectF
      begin
        Result := dxRectF(Viewer.Pages[APageIndex].Bounds);
      end);
    Result := Viewer.Pages[IfThen(APageIndex = -1, 0, APageIndex)] as TdxPDFViewerPage;
  end;
end;

{ TdxPDFViewerNavigationPaneHitTest }

function TdxPDFViewerNavigationPaneHitTest.DoGetCursor: TCursor;
begin
  Result := inherited DoGetCursor;
  if HitAtSplitter then
    Result := crHSplit;
end;

procedure TdxPDFViewerNavigationPaneHitTest.DoCalculate(const AHitPoint: TPoint);
begin
  inherited DoCalculate(AHitPoint);
  Viewer.NavigationPane.ViewInfo.CalculateHitTest(Self);
  HitCodes[hcNavigationPaneSplitter] := PtInRect(Viewer.NavigationPane.ViewInfo.SplitterBounds, HitPoint);
end;

{ TdxPDFViewerCustomController }

function TdxPDFViewerCustomController.DoKeyDown(AKey: Word; AShift: TShiftState): Boolean;
begin
  Result := False;
end;

function TdxPDFViewerCustomController.DoMouseWheel(AShift: TShiftState; AWheelDelta: Integer;
  const AMousePos: TPoint): Boolean;
begin
  Result := False;
end;

function TdxPDFViewerCustomController.GetCursor: TCursor;
begin
  Result := crDefault;
end;

function TdxPDFViewerCustomController.GetPopupMenuClass: TComponentClass;
begin
  Result := nil;
end;

function TdxPDFViewerCustomController.IsAvailable: Boolean;
begin
  Result := not Viewer.IsDestroying and Viewer.IsDocumentAvailable and not Viewer.IsScrollAnimationActive;
end;

procedure TdxPDFViewerCustomController.CalculateHitTest(X, Y: Integer);
begin
  // do nothing
end;

procedure TdxPDFViewerCustomController.CalculateMouseButtonPressed(Shift: TShiftState; X, Y: Integer);
begin
  FLeftMouseButtonPressed := ssLeft in Shift;
end;

procedure TdxPDFViewerCustomController.DoMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  CalculateMouseButtonPressed(Shift, X, Y);
end;

procedure TdxPDFViewerCustomController.DoMouseEnter(AControl: TControl);
begin
// do nothing
end;

procedure TdxPDFViewerCustomController.DoMouseLeave(AControl: TControl);
begin
// do nothing
end;

procedure TdxPDFViewerCustomController.DoMouseMove(Shift: TShiftState; X, Y: Integer);
begin
// do nothing
end;

procedure TdxPDFViewerCustomController.DoMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ResetLeftMouseButtonPressed;
end;

procedure TdxPDFViewerCustomController.UpdateState;
begin
  // do nothing
end;

function TdxPDFViewerCustomController.ContextPopup(const P: TPoint): Boolean;
begin
  Result := ContextPopup(P, GetPopupMenuClass);
end;

function TdxPDFViewerCustomController.ContextPopup(const P: TPoint; APopupMenuClass: TComponentClass): Boolean;
begin
  if (APopupMenuClass <> nil) and ((FPopupMenu = nil) or (FPopupMenu.ClassType <> APopupMenuClass)) then
  begin
    FreeAndNil(FPopupMenu);
    if APopupMenuClass <> nil then
      FPopupMenu := APopupMenuClass.Create(Viewer);
  end;
  Result := (FPopupMenu <> nil) and (FPopupMenu as TdxPDFViewerCustomPopupMenu).Popup(P);
end;

function TdxPDFViewerCustomController.KeyDown(var AKey: Word; AShift: TShiftState): Boolean;
begin
  if IsAvailable then
  begin
    Result := DoKeyDown(AKey, AShift);
    if Result then
      AKey := 0;
  end
  else
    Result := False;
end;

function TdxPDFViewerCustomController.MouseWheel(Shift: TShiftState; WheelDelta: Integer; const MousePos: TPoint): Boolean;
begin
  Result := DoMouseWheel(Shift, WheelDelta, MousePos);
end;

procedure TdxPDFViewerCustomController.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if not IsAvailable then
    Exit;
  CalculateHitTest(X, Y);
  DoMouseDown(Button, Shift, X, Y);
  UpdateState;
end;

procedure TdxPDFViewerCustomController.MouseEnter(AControl: TControl; X, Y: Integer);
begin
  if not IsAvailable then
    Exit;
  CalculateHitTest(X, Y);
  DoMouseEnter(AControl);
  UpdateState;
end;

procedure TdxPDFViewerCustomController.MouseLeave(AControl: TControl; X, Y: Integer);
begin
  if not IsAvailable then
    Exit;
  CalculateHitTest(X, Y);
  DoMouseLeave(AControl);
  UpdateState;
end;

procedure TdxPDFViewerCustomController.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if not IsAvailable then
    Exit;
  CalculateHitTest(X, Y);
  DoMouseMove(Shift, X, Y);
  UpdateState;
end;

procedure TdxPDFViewerCustomController.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if not IsAvailable then
    Exit;
  CalculateHitTest(X, Y);
  DoMouseUp(Button, Shift, X, Y);
  UpdateState;
end;

procedure TdxPDFViewerCustomController.ResetLeftMouseButtonPressed;
begin
  FLeftMouseButtonPressed := False;
end;

{ TdxPDFViewerViewState }

constructor TdxPDFViewerViewState.Create(AChangeType: TdxPDFViewerViewStateChangeType);
begin
  inherited Create;
  FChangeType := AChangeType;
  FTimeStamp := DateTimeToTimeStamp(Now);
end;

class function TdxPDFViewerViewState.CalculatePageSize(const ASize: TdxPointF; ARotationAngle: TcxRotationAngle): TdxPointF;
begin
  if (ARotationAngle = raPlus90) or (ARotationAngle = raMinus90) then
    Result := dxPointF(ASize.Y, ASize.X)
  else
    Result := ASize;
end;

function TdxPDFViewerViewState.CalculatePageSize(APage: TdxPDFPage): TdxPointF;
begin
  Result := TdxPDFViewerViewState.CalculatePageSize(APage.Size, RotationAngle);
end;

function TdxPDFViewerViewState.IsSame(AView: TdxPDFViewerViewState): Boolean;
begin
  Result := (ChangeType = AView.ChangeType) and (ChangeType in [vsctZooming, vsctScrolling, vsctSelecting]) and
    (AView.TimeStamp.Date = TimeStamp.Date) and (AView.TimeStamp.Time - TimeStamp.Time <= dxPDFViewerViewCreationTimeOut);
end;

{ TdxPDFViewerViewStateHistory }

constructor TdxPDFViewerViewStateHistory.Create;
begin
  inherited Create;
  FViewStateList := TObjectList<TdxPDFViewerViewState>.Create;
end;

destructor TdxPDFViewerViewStateHistory.Destroy;
begin
  FreeAndNil(FViewStateList);
  inherited Destroy;
end;

function TdxPDFViewerViewStateHistory.CanGoToNextView: Boolean;
begin
  Result := FCurrentViewStateIndex < FViewStateList.Count - 1;
end;

function TdxPDFViewerViewStateHistory.CanGoToPreviousView: Boolean;
begin
  Result := FCurrentViewStateIndex > 0;
end;

procedure TdxPDFViewerViewStateHistory.BeginUpdate;
begin
  Inc(FLockCount);
end;

procedure TdxPDFViewerViewStateHistory.Clear;
begin
  FCurrentViewStateIndex := 0;
  FViewStateList.Clear;
end;

procedure TdxPDFViewerViewStateHistory.EndUpdate;
begin
  Dec(FLockCount);
end;

procedure TdxPDFViewerViewStateHistory.GoToNextView;
begin
  if CanGoToNextView then
    Inc(FCurrentViewStateIndex);
end;

procedure TdxPDFViewerViewStateHistory.GoToPrevView;
begin
  if CanGoToPreviousView then
    Dec(FCurrentViewStateIndex);
end;

procedure TdxPDFViewerViewStateHistory.Initialize(AView: TdxPDFViewerViewState);
begin
  Clear;
  FViewStateList.Add(AView);
end;

function TdxPDFViewerViewStateHistory.IsLocked: Boolean;
begin
  Result := FLockCount > 0;
end;

procedure TdxPDFViewerViewStateHistory.StoreViewState(AView: TdxPDFViewerViewState);
var
  ACountToDelete: Integer;
begin
  if (FLockCount = 0) and not SameView(AView, CurrentViewState) then
  begin
    if CurrentViewState.IsSame(AView) then
      GoToPrevView;
    Inc(FCurrentViewStateIndex);
    ACountToDelete := FViewStateList.Count - FCurrentViewStateIndex;
    if ACountToDelete > 0 then
      FViewStateList.DeleteRange(FCurrentViewStateIndex, ACountToDelete);
    if not SameView(AView, FViewStateList[FCurrentViewStateIndex - 1]) then
      FViewStateList.Add(AView)
    else
    begin
      Dec(FCurrentViewStateIndex);
      AView.Free;
    end;
  end
  else
    AView.Free;
end;

function TdxPDFViewerViewStateHistory.GetCurrentViewState: TdxPDFViewerViewState;
begin
  Result := FViewStateList[FCurrentViewStateIndex];
end;

function TdxPDFViewerViewStateHistory.GetCount: Integer;
begin
  Result := FViewStateList.Count;
end;

function TdxPDFViewerViewStateHistory.SameView(AView, ACurrentView: TdxPDFViewerViewState): Boolean;
begin
  Result := (ACurrentView.ChangeType = AView.ChangeType) and (ACurrentView.RotationAngle = AView.RotationAngle) and
    (ACurrentView.ZoomFactor = AView.ZoomFactor) and (ACurrentView.ZoomMode = AView.ZoomMode) and
    (ACurrentView.CurrentPageIndex = AView.CurrentPageIndex) and
    cxPointIsEqual(ACurrentView.ScrollPosition, AView.ScrollPosition);
end;

{ TdxPDFViewerViewStateHistoryController }

function TdxPDFViewerViewStateHistoryController.CanGoToNextView: Boolean;
begin
  Result := FHistory.CanGoToNextView;
end;

function TdxPDFViewerViewStateHistoryController.CanGoToPreviousView: Boolean;
begin
  Result := FHistory.CanGoToPreviousView;
end;

procedure TdxPDFViewerViewStateHistoryController.Clear;
begin
  RecreateHistory;
end;

procedure TdxPDFViewerViewStateHistoryController.GoToNextView;
begin
  FHistory.GoToNextView;
  RestoreViewState;
end;

procedure TdxPDFViewerViewStateHistoryController.GoToPrevView;
begin
  FHistory.GoToPrevView;
  RestoreViewState;
end;

procedure TdxPDFViewerViewStateHistoryController.StoreCurrentViewState(AChangeType: TdxPDFViewerViewStateChangeType);
begin
  if not Viewer.IsUpdateLocked and Viewer.IsDocumentLoaded then
  begin
    if not Viewer.IsZoomingLocked or Viewer.IsZoomingLocked and (AChangeType = vsctZooming) then
      FHistory.StoreViewState(CreateView(AChangeType));
  end;
end;

procedure TdxPDFViewerViewStateHistoryController.RestoreViewState;
begin
  FHistory.BeginUpdate;
  try
    Viewer.BeginUpdate;
    try
      Viewer.RotationAngle := FHistory.CurrentViewState.RotationAngle;
      Viewer.ZoomFactor := FHistory.CurrentViewState.ZoomFactor;
      Viewer.SetScrollPosition(FHistory.CurrentViewState.ScrollPosition);
      Viewer.InternalSetCurrentPage(FHistory.CurrentViewState.CurrentPageIndex, False);
      Viewer.RecreateRenderer;
    finally
      Viewer.EndUpdate;
    end;
    Viewer.ZoomMode := FHistory.CurrentViewState.ZoomMode;
  finally
    FHistory.EndUpdate;
  end;
end;

procedure TdxPDFViewerViewStateHistoryController.CreateSubClasses;
begin
  inherited CreateSubClasses;
  RecreateHistory;
end;

procedure TdxPDFViewerViewStateHistoryController.DestroySubClasses;
begin
  FreeAndNil(FHistory);
  inherited DestroySubClasses;
end;

procedure TdxPDFViewerViewStateHistoryController.BeginUpdate;
begin
  FHistory.BeginUpdate;
end;

procedure TdxPDFViewerViewStateHistoryController.EndUpdate;
begin
  FHistory.EndUpdate;
end;

function TdxPDFViewerViewStateHistoryController.CreateView(AChangeType: TdxPDFViewerViewStateChangeType): TdxPDFViewerViewState;
begin
  Result := TdxPDFViewerViewState.Create(AChangeType);
  Result.CurrentPageIndex := Viewer.GetTargetSelectedPageIndex;
  Result.ScrollPosition := cxPoint(Viewer.LeftPos, Viewer.TopPos);
  Result.RotationAngle := Viewer.RotationAngle;
  Result.ZoomFactor := Viewer.ZoomFactor;
  Result.ZoomMode := Viewer.ZoomMode;
end;

function TdxPDFViewerViewStateHistoryController.GetCurrentViewState: TdxPDFViewerViewState;
begin
  Result := FHistory.CurrentViewState;
end;

procedure TdxPDFViewerViewStateHistoryController.RecreateHistory;
begin
  if FHistory <> nil then
    FreeAndNil(FHistory);
  FHistory := TdxPDFViewerViewStateHistory.Create;
  FHistory.Initialize(CreateView(vsctNone));
end;

{ TdxPDFViewerContentSelector }

constructor TdxPDFViewerContentSelector.Create(AViewer: TdxPDFCustomViewer);
begin
  inherited Create;
  FViewer := AViewer;
end;

procedure TdxPDFViewerContentSelector.Clear;
begin
  FInProgress := False;
end;

procedure TdxPDFViewerContentSelector.Reset;
begin
  FInProgress := False;
end;

function TdxPDFViewerContentSelector.GetHitTest: TdxPDFViewerDocumentHitTest;
begin
  Result := Viewer.HitTest;
end;

function TdxPDFViewerContentSelector.GetSelection: TdxPDFCustomSelection;
begin
  Result := FViewer.Selection.Selection;
end;

function TdxPDFViewerContentSelector.GetSelectionBackColor: TdxAlphaColor;
begin
  Result := dxacDefault;
end;

function TdxPDFViewerContentSelector.GetSelectionFrameColor: TdxAlphaColor;
begin
  Result := dxacDefault;
end;

procedure TdxPDFViewerContentSelector.SetSelection(const AValue: TdxPDFCustomSelection);
begin
  FViewer.Selection.Selection := AValue;
end;

{ TdxPDFViewerImageSelector }

procedure TdxPDFViewerImageSelector.Clear;
begin
  inherited Clear;
  FIsSelected := False;
end;

procedure TdxPDFViewerImageSelector.Reset;
begin
  inherited Reset;
  FImageBounds.Invalid;
  FStartPosition.Invalid;
end;

function TdxPDFViewerImageSelector.Select: Boolean;
const
  Precision = 0.001;
var
  ASelectionRect, AImageBounds: TdxRectF;
  AStartPositionPage: TdxPDFDocumentCustomViewerPage;
begin
  Result := not FIsSelected and FImageBounds.IsValid;
  if Result then
  begin
    if (Abs(FStartPosition.Point.X - HitTest.Position.Point.X) < Precision) or
      (Abs(FStartPosition.Point.Y - HitTest.Position.Point.Y) < Precision) then
    begin
      if not InProgress then
        Selection := CreateImageSelection(dxNullRectF);
    end
    else
      if InProgress then
      begin
        AImageBounds := FImageBounds.Rect;
        AStartPositionPage := Viewer.PageList[FStartPosition.PageIndex] as TdxPDFDocumentCustomViewerPage;
        ASelectionRect.TopLeft := Viewer.DocumentState.ToViewerPoint(AStartPositionPage, FStartPosition.Point);
        ASelectionRect.BottomRight := HitTest.HitPoint;
        ASelectionRect.Normalize;
        AImageBounds := Viewer.DocumentState.ToViewerRect(AStartPositionPage, AImageBounds);
        ASelectionRect.Intersect(AImageBounds);
        ASelectionRect := Viewer.DocumentState.ToDocumentRect(AStartPositionPage, ASelectionRect);
        ASelectionRect.Normalize;
        Selection := CreateImageSelection(ASelectionRect);
      end;
  end;
end;

procedure TdxPDFViewerImageSelector.StartSelection(var AInOutsideContent: Boolean);
var
  AImageViewInfo: TdxPDFViewerImageViewInfo;
begin
  FStartPosition := HitTest.Position;
  InProgress := HitTest.HitAtImage;
  if HitTest.HitAtImage then
  begin
    AImageViewInfo := HitTest.HitObject as TdxPDFViewerImageViewInfo;
    FImageBounds := AImageViewInfo.ImageBounds;
    FImageID := AImageViewInfo.ID;
  end
  else
    FImageBounds.Invalid;
  AInOutsideContent := InProgress;
end;

function TdxPDFViewerImageSelector.CreateImageSelection(const ABounds: TdxRectF): TdxPDFImageSelection;
begin
  Result := TdxPDFImageSelection.Create(Viewer, SelectionBackColor, SelectionFrameColor, FImageID, FImageBounds, ABounds);
end;

{ TdxPDFViewerTextSelector }

function TdxPDFViewerTextSelector.CreateTextHighlights(const ARanges: TdxPDFPageTextRanges;
  ABackColor, AFrameColor: TdxAlphaColor): TdxPDFTextHighlight;
begin
  if ValidateRanges(ARanges) then
    Result := TdxPDFTextHighlight.Create(ABackColor, AFrameColor, Viewer.DocumentPages, ARanges)
  else
    Result := nil;
end;

function TdxPDFViewerTextSelector.CreateTextSelection(const ARange: TdxPDFPageTextRange): TdxPDFTextSelection;
var
  ARanges: TdxPDFPageTextRanges;
begin
  SetLength(ARanges, 1);
  ARanges[0] := ARange;
  Result := CreateTextSelection(ARanges);
end;

function TdxPDFViewerTextSelector.CreateTextSelection(const ARanges: TdxPDFPageTextRanges): TdxPDFTextSelection;
begin
  if Viewer.OptionsSelection.Text and ValidateRanges(ARanges) then
    Result := TdxPDFTextSelection.Create(SelectionBackColor, SelectionFrameColor, Viewer.DocumentPages, ARanges)
  else
    Result := nil;
end;

function TdxPDFViewerTextSelector.GetCaretViewData(const APosition: TdxPDFTextPosition): TdxPDFDocumentCaretViewData;
var
  ACurrentPart: TdxPDFTextWordPart;
  AFoundLine: TdxPDFTextLine;
  ALine: TdxPDFTextLineAccess;
  ALocation: TdxPointF;
  AOffset: Integer;
  X, Y, AK0, K: Double;
  AWordPart: TdxPDFTextWordPartAccess;
begin
  Result := TdxPDFDocumentCaretViewData.Create(dxPointF(0, 0), 0, 0);
  if FindLine(APosition, AFoundLine) then
  begin
    ALine := TdxPDFTextLineAccess(AFoundLine);
    for ACurrentPart in ALine.WordPartList do
    begin
      AWordPart := TdxPDFTextWordPartAccess(ACurrentPart);
      if AWordPart.Same(APosition.Position.WordIndex, APosition.Position.Offset) then
      begin
        AOffset := APosition.Position.Offset - AWordPart.WrapOffset;
        if AOffset = AWordPart.Characters.Count then
          ALocation := AWordPart.Characters[AOffset - 1].Bounds.TopRight
        else
          ALocation := AWordPart.Characters[AOffset].Bounds.TopLeft;
        if (AWordPart.Bounds.Angle = 0) or (AWordPart.Bounds.Angle = PI) then
        begin
          X := ALocation.X;
          Y := AWordPart.Bounds.Top;
        end
        else
          if (AWordPart.Bounds.Angle = 3 * PI / 2) or (AWordPart.Bounds.Angle = PI / 2) then
          begin
            X := AWordPart.Bounds.Left;
            Y := ALocation.Y;
          end
          else
          begin
            AK0 := Tan(AWordPart.Bounds.Angle);
            K := Tan(AWordPart.Bounds.Angle + PI / 2);
            X := (AWordPart.Bounds.Left * AK0 - AWordPart.Bounds.Top - ALocation.X * K + ALocation.Y) / (AK0 - K);
            Y := AK0 * (X - AWordPart.Bounds.Left) + AWordPart.Bounds.Top;
          end;
        Exit(TdxPDFDocumentCaretViewData.Create(dxPointF(X, Y), AWordPart.Bounds.Height, ALine.Bounds.Angle));
      end;
    end;
    Result := TdxPDFDocumentCaretViewData.Create(dxPointF(cxNullPoint), 0, TdxPDFTextObjectAccess(ALine).Bounds.Angle);
  end;
end;

function TdxPDFViewerTextSelector.StartSelection(const APosition: TdxPDFPagePoint): Boolean;
var
  APageIndex: Integer;
  ATextPosition: TdxPDFTextPosition;
begin
  APageIndex := APosition.PageIndex;
  ATextPosition := FindStartTextPosition(APosition);
  InProgress := ATextPosition.IsValid;
  if not InProgress then
  begin
    FStartPageIndex := -1;
    FStartPoint := dxPointF(cxNullPoint);
    if Viewer.SelectionController.Caret.IsValid then
      Caret := TdxPDFDocumentCaret.Invalid;
  end
  else
  begin
    FStartPageIndex := APageIndex;
    FStartPoint := APosition.Point;
    UpdateSelection(ATextPosition);
  end;
  Result := InProgress;
end;

procedure TdxPDFViewerTextSelector.MoveCaret(const APosition: TdxPDFTextPosition);
var
  AData: TdxPDFDocumentCaretViewData;
begin
  AData := GetCaretViewData(APosition);
  Caret := TdxPDFDocumentCaret.Create(APosition, AData, AData.TopLeft);
end;

procedure TdxPDFViewerTextSelector.MoveCaret(ADirection: TdxPDFMovementDirection);
var
  ACaretDirection: TdxPDFMovementDirection;
begin
  if IsArrowKeys(ADirection) then
    ACaretDirection := NormalizeDirection(ADirection)
  else
    ACaretDirection := ADirection;
  case ACaretDirection of
    mdLeft:
      if not MoveCaretToLeft then
        DoMoveCaret(MoveLeft);
    mdRight:
      if not MoveCaretToRight and Caret.IsValid then
        DoMoveCaret(MoveRight);
    mdUp:
      begin
        MoveCaretToLeft;
        DoMoveCaret(MoveUp);
      end;
    mdDown:
      begin
        MoveCaretToRight;
        DoMoveCaret(MoveDown);
      end;
    mdNextWord:
      DoMoveCaret(MoveToNextWord);
    mdPreviousWord:
      DoMoveCaret(MoveToPreviousWord);
    mdLineStart:
      DoMoveCaret(MoveToLineStart);
    mdLineEnd:
      DoMoveCaret(MoveToLineEnd);
    mdDocumentStart:
      DoMoveCaret(MoveToDocumentStart);
    mdDocumentEnd:
      DoMoveCaret(MoveToDocumentEnd);
  end;
end;

procedure TdxPDFViewerTextSelector.Select(const APosition: TdxPDFPagePoint);
var
  AEnd: TdxPDFPageTextPosition;
  ARange: TdxPDFPageTextRange;
  ARanges: TdxPDFPageTextRanges;
  ATextPosition: TdxPDFPageTextPosition;
begin
  if InProgress and ((APosition.PageIndex <> FStartPageIndex) or not cxPointIsEqual(APosition.Point, FStartPoint)) then
  begin
    StoreSelectionStartTextPosition;
    ARanges := CreateRangeList(FStartTextPosition, APosition);
    if Length(ARanges) > 0 then
    begin
      ARange := ARanges[Length(ARanges) - 1];
      AEnd := ARange.EndPosition;
      if AEnd.IsSame(FStartTextPosition.Position) then
        ATextPosition := ARange.StartPosition
      else
        ATextPosition := AEnd;
      MoveCaret(TdxPDFTextPosition.Create(ARange.PageIndex, ATextPosition));
      Selection := CreateTextSelection(ARanges);
    end
  end;
end;

procedure TdxPDFViewerTextSelector.SelectByKeyboard(ADirection: TdxPDFMovementDirection);
var
  ACaretDirection: TdxPDFMovementDirection;
  ARanges: TdxPDFPageTextRanges;
begin
  if IsArrowKeys(ADirection) then
    ACaretDirection := NormalizeDirection(ADirection)
  else
    ACaretDirection := ADirection;
  StoreSelectionStartTextPosition;
  case ACaretDirection of
    mdLeft:
      MoveLeft;
    mdRight:
      MoveRight;
    mdUp:
      MoveUp;
    mdDown:
      MoveDown;
    mdNextWord:
      MoveToNextWord;
    mdPreviousWord:
      MoveToPreviousWord;
    mdLineStart:
      MoveToLineStart;
    mdLineEnd:
      MoveToLineEnd;
    mdDocumentStart:
      MoveToDocumentStart;
    mdDocumentEnd:
      MoveToDocumentEnd;
  end;
  if Caret.IsValid then
  begin
    ARanges := CreateRangeList(FStartTextPosition, Caret.Position);
    Selection := CreateTextSelection(ARanges);
    MakeCaretVisible;
  end;
end;

procedure TdxPDFViewerTextSelector.SelectLine(const APosition: TdxPDFPagePoint);
var
  ADocumentPosition: TdxPDFPagePoint;
begin
  ADocumentPosition := APosition;
  Select(Page[APosition.PageIndex],
    procedure
    var
      ALine: TdxPDFTextLine;
      AWordPartList: TdxPDFTextWordPartList;
    begin
      if Viewer.DocumentState.FindLine(ADocumentPosition, ALine) then
      begin
        AWordPartList := TdxPDFTextLineAccess(ALine).WordPartList;
        if AWordPartList.Count = 0 then
          Selection := nil
        else
          Selection := CreateTextSelection(TdxPDFPageTextRange.Create(ADocumentPosition.PageIndex,
            AWordPartList[0].WordIndex, 0, AWordPartList.Last.WordIndex, AWordPartList.Last.Characters.Count));
      end;
    end);
end;

procedure TdxPDFViewerTextSelector.SelectPage(const APosition: TdxPDFPagePoint);
var
  ADocumentPosition: TdxPDFPagePoint;
begin
  ADocumentPosition := APosition;
  Select(Page[APosition.PageIndex],
    procedure
    var
      APageIndex: Integer;
    begin
      APageIndex := ADocumentPosition.PageIndex;
      if (APageIndex >= 0) and FindStartTextPosition(ADocumentPosition).IsValid then
        Selection := CreateTextSelection(TdxPDFPageTextRange.Create(APageIndex));
    end);
end;

procedure TdxPDFViewerTextSelector.SelectWord(const APosition: TdxPDFPagePoint);
var
  ADocumentPosition: TdxPDFPagePoint;
begin
  ADocumentPosition := APosition;
  Select(Page[APosition.PageIndex],
    procedure
    var
      ARange: TdxPDFPageTextRange;
      AStartPosition: TdxPDFTextPosition;
    begin
      AStartPosition := FindStartTextPosition(ADocumentPosition);
      if AStartPosition.IsValid then
      begin
        ARange := TdxPDFPageTextRange.Create(AStartPosition.PageIndex,
          TdxPDFPageTextPosition.Create(AStartPosition.Position.WordIndex, 0),
          TdxPDFPageTextPosition.Create(AStartPosition.Position.WordIndex, FindWordEndPosition(AStartPosition)));
        Selection := CreateTextSelection(ARange);
      end;
    end);
end;

function TdxPDFViewerTextSelector.GetCaret: TdxPDFDocumentCaret;
begin
  Result := Viewer.SelectionController.Caret;
end;

function TdxPDFViewerTextSelector.GetPage(AIndex: Integer): TdxPDFPage;
begin
  Result := Viewer.SelectionController.GetPage(AIndex);
end;

function TdxPDFViewerTextSelector.GetScaleFactor: TdxPointF;
begin
  Result := Viewer.DocumentScaleFactor;
end;

function TdxPDFViewerTextSelector.GetTextLines(APageIndex: Integer): TdxPDFTextLineList;
begin
  Result := Viewer.DocumentState.TextLines[APageIndex];
end;

procedure TdxPDFViewerTextSelector.SetCaret(const AValue: TdxPDFDocumentCaret);
begin
  Viewer.SelectionController.Caret := AValue;
end;

function TdxPDFViewerTextSelector.CreateRangeList(const AStart, AEnd: TdxPDFTextPosition): TdxPDFPageTextRanges;
var
  I: Integer;
  AStartPosition, AEndPosition: TdxPDFTextPosition;
begin
  SetLength(Result, 0);
  if AEnd.IsValid then
  begin
    if AStart.PageIndex = AEnd.PageIndex then
    begin
      if (AStart.Position.WordIndex > AEnd.Position.WordIndex) or
        (AStart.Position.WordIndex = AEnd.Position.WordIndex) and (AStart.Position.Offset > AEnd.Position.Offset) then
        TdxPDFTextUtils.AddRange(TdxPDFPageTextRange.Create(AEnd.PageIndex, AEnd.Position, AStart.Position), Result)
      else
        TdxPDFTextUtils.AddRange(TdxPDFPageTextRange.Create(AStart.PageIndex, AStart.Position, AEnd.Position), Result);
    end
    else
    begin
      AStartPosition := AStart;
      AEndPosition := AEnd;
      if AStartPosition.PageIndex > AEndPosition.PageIndex then
      begin
        AStartPosition := AEnd;
        AEndPosition := AStart;
      end;
      TdxPDFTextUtils.AddRange(TdxPDFPageTextRange.Create(AStartPosition.PageIndex, AStartPosition.Position,
        TdxPDFPageTextPosition.Create(0, -1)), Result);

      for I := AStartPosition.PageIndex + 1 to AEndPosition.PageIndex - 1 do
        TdxPDFTextUtils.AddRange(TdxPDFPageTextRange.Create(I), Result);

      TdxPDFTextUtils.AddRange(TdxPDFPageTextRange.Create(AEndPosition.PageIndex, TdxPDFPageTextPosition.Create(0, 0),
        AEndPosition.Position), Result);
    end;
  end;
end;

function TdxPDFViewerTextSelector.CreateRangeList(const AStart: TdxPDFTextPosition;
  const AEnd: TdxPDFPagePoint): TdxPDFPageTextRanges;
begin
  if AStart.IsValid then
    Result := CreateRangeList(AStart, FindNearestPosition(AEnd, AStart))
  else
    SetLength(Result, 0);
end;

function TdxPDFViewerTextSelector.HasCaret: Boolean;
begin
  Result := Caret.IsValid;
end;

function TdxPDFViewerTextSelector.IsArrowKeys(ADirection: TdxPDFMovementDirection): Boolean;
begin
  Result := ADirection in [mdUp, mdDown, mdLeft, mdRight];
end;

function TdxPDFViewerTextSelector.IsEmptySelection: Boolean;
begin
  Result := Viewer.Selection.IsEmpty;
end;

function TdxPDFViewerTextSelector.IsPositionInLine(APageIndex, ALineIndex, AWordIndex, AOffset: Integer): Boolean;
var
  ALine: TdxPDFTextLineAccess;
  ALines: TdxPDFTextLineList;
  AParts: TdxPDFTextWordPartList;
  ALastPageIndex: Integer;
begin
  ALines := TextLines[APageIndex];

  ALine := TdxPDFTextLineAccess(ALines[ALineIndex]);
  if not ALine.PositionInLine(AWordIndex, AOffset) then
    Exit(False);

  AParts := TdxPDFTextLineAccess(ALine).WordPartList;
  if AParts[AParts.Count - 1].WordIndex <> AWordIndex then
    Exit(True);
  if ALineIndex < ALines.Count - 1 then
    Exit(not TdxPDFTextLineAccess(ALines[ALineIndex + 1]).PositionInLine(AWordIndex, AOffset));

  ALastPageIndex := Viewer.PageCount - 1;
  repeat
    if APageIndex = ALastPageIndex then
      Exit(True);
    ALines := TextLines[APageIndex];
    Inc(APageIndex);
  until not ((ALines = nil) or (ALines.Count = 0));

  ALine := TdxPDFTextLineAccess(ALines[0]);
  Result := not ALine.PositionInLine(AWordIndex, AOffset) or (ALine.WordPartList[0].WordIndex <> AWordIndex);
end;

function TdxPDFViewerTextSelector.FindLine(const APosition: TdxPDFTextPosition; out ALine: TdxPDFTextLine): Boolean;
var
  I: Integer;
  ATextLineList: TdxPDFTextLineList;
begin
  ALine := nil;
  Result := False;
  ATextLineList := TextLines[APosition.PageIndex];
  for I := 0 to ATextLineList.Count - 1 do
    if IsPositionInLine(APosition.PageIndex, I, APosition.Position.WordIndex, APosition.Position.Offset) then
    begin
      ALine := ATextLineList[I];
      Exit(True);
    end;
end;

function TdxPDFViewerTextSelector.FindNearestLineByDistance(const APosition: TdxPDFPagePoint): TdxPDFTextLine;
var
  I: Integer;
  ADistance, AMinDistance: Double;
  ALine: TdxPDFTextLineAccess;
  ALineRect: TdxRectF;
  ALines: TdxPDFTextLineList;
  APart: TdxPDFTextWordPart;
begin
  Result := nil;
  AMinDistance := MaxDouble;
  ALines := TextLines[APosition.PageIndex];
  if ALines <> nil then
  begin
    for I := 0 to ALines.Count - 1  do
    begin
      ALine := TdxPDFTextLineAccess(ALines[I]);
      if ALine.Bounds.PtInRect(APosition.Point) then
        for APart in TdxPDFTextLineAccess(ALine).WordPartList do
          if TdxPDFTextObjectAccess(APart).Bounds.PtInRect(APosition.Point) then
            Exit(ALine);
      ADistance := TdxPDFUtils.DistanceToRect(APosition.Point, ALine.Bounds.RotatedRect);
      if ADistance < AMinDistance then
      begin
        Result := ALine;
        AMinDistance := ADistance;
      end;
    end;
    if Result = nil then
      for I := ALines.Count - 1 downto 0 do
      begin
        ALine := TdxPDFTextLineAccess(ALines[I]);
        ALineRect := ALine.Bounds.RotatedRect;
        if (ALineRect.Bottom <= APosition.Point.Y) and (ALineRect.Right >= APosition.Point.X) then
          Result := ALine;
      end;
  end;
end;

function TdxPDFViewerTextSelector.FindNearestPosition(const APosition: TdxPDFPagePoint;
  const ATextPosition: TdxPDFTextPosition): TdxPDFTextPosition;
var
  I, AWordIndex, ALastLineIndex: Integer;
  ALines: TdxPDFTextLineList;
  ALine, ANearestLine: TdxPDFTextLineAccess;
begin
  Result := TdxPDFTextPosition.Invalid;
  if APosition.PageIndex >= 0 then
  begin
    ANearestLine := TdxPDFTextLineAccess(FindNearestLineByDistance(APosition));
    if ANearestLine = nil then
    begin
      AWordIndex := ATextPosition.Position.WordIndex;
      ALines := TextLines[ATextPosition.PageIndex];
      for I := 0 to ALines.Count - 1  do
      begin
        ALine := TdxPDFTextLineAccess(ALines[I]);
        begin
          ALastLineIndex := ALine.WordList.Count - 1;
          if ((ALastLineIndex >= 0) and (AWordIndex >= ALine.WordList[0].Index)) and
            (ALine.WordList[ALastLineIndex].Index >= AWordIndex) then
          begin
            ANearestLine := ALine;
            Break;
          end;
        end;
      end;
    end;
    if ANearestLine <> nil then
      Result := ANearestLine.GetPosition(APosition);
  end
end;

function TdxPDFViewerTextSelector.FindStartTextPosition(const APosition: TdxPDFPagePoint): TdxPDFTextPosition;
begin
  Result := Viewer.DocumentState.FindStartTextPosition(APosition);
end;

function TdxPDFViewerTextSelector.FindWordEndPosition(APosition: TdxPDFTextPosition): Integer;
var
  ALineIndex, ALastWordPartIndex, J: Integer;
  ALine: TdxPDFTextLine;
  AWordParts: TdxPDFTextWordPartList;
  AWordPart, ALastWordPart: TdxPDFTextWordPart;
begin
  Result := -1;
  ALineIndex := 0;
  for ALine in TextLines[APosition.PageIndex] do
  begin
    AWordParts := TdxPDFTextLineAccess(ALine).WordPartList;
    ALastWordPartIndex := AWordParts.Count - 1;
    if ALastWordPartIndex >= 0 then
    begin
      for J := 0 to ALastWordPartIndex - 1 do
      begin
        AWordPart := AWordParts[J];
        if AWordPart.WordIndex = APosition.Position.WordIndex then
          Exit(TdxPDFTextWordPartAccess(AWordPart).EndWordPosition);
      end;
      ALastWordPart := AWordParts[ALastWordPartIndex];
      if (ALastWordPart.WordIndex = APosition.Position.WordIndex) and
        not SameNextWordPartIndex(APosition.PageIndex, ALineIndex, APosition.Position.WordIndex) then
          Exit(TdxPDFTextWordPartAccess(ALastWordPart).EndWordPosition);
    end;
    Inc(ALineIndex);
  end;
end;

function TdxPDFViewerTextSelector.MoveCaretToLeft: Boolean;
var
  ARange: TdxPDFPageTextRange;
begin
  Result := Selection is TdxPDFTextSelection;
  if Result then
  begin
    ARange := TdxPDFTextHighlightAccess(Selection).Ranges[0];
    UpdateSelection(TdxPDFTextPosition.Create(ARange.PageIndex, ARange.StartPosition));
  end;
end;

function TdxPDFViewerTextSelector.MoveCaretToRight: Boolean;
var
  ARange: TdxPDFPageTextRange;
  ARanges: TdxPDFPageTextRanges;
begin
  Result := Selection is TdxPDFTextSelection;
  if Result then
  begin
    ARanges := TdxPDFTextHighlightAccess(Selection).Ranges;
    ARange := ARanges[Length(ARanges) - 1];
    UpdateSelection(TdxPDFTextPosition.Create(ARange.PageIndex, ARange.EndPosition));
  end;
end;

function TdxPDFViewerTextSelector.MoveRight(AWordParts: TdxPDFTextWordPartList;
  APageIndex, ALineIndex, AWordIndex, AOffset: Integer; AProcessLastWordPart: Boolean): Boolean;
var
  ALastWordPartIndex, ALastWordIndex, J: Integer;
  AWordPart: TdxPDFTextWordPart;
begin
  ALastWordPartIndex := AWordParts.Count - 1;
  ALastWordIndex := AWordParts[ALastWordPartIndex].WordIndex;
  if not AProcessLastWordPart then
    Dec(ALastWordPartIndex);
  for J := 0 to ALastWordPartIndex do
  begin
    AWordPart := AWordParts[J];
    if AWordPart.Same(AWordIndex, AOffset) then
    begin
      if (TdxPDFTextWordPartAccess(AWordPart).NextWrapOffset > AOffset) or (((AWordIndex = ALastWordIndex) and
        SameNextWordPartIndex(APageIndex, ALineIndex, AWordIndex))) then
        MoveAndMakeCaretVisible(TdxPDFTextPosition.Create(APageIndex, TdxPDFPageTextPosition.Create(AWordIndex, AOffset + 1)))
      else
        if TdxPDFTextWordPartAccess(AWordPart).WordEnded then
          MoveAndMakeCaretVisible(TdxPDFTextPosition.Create(APageIndex, TdxPDFPageTextPosition.Create(AWordIndex + 1, 0)))
        else
          MoveAndMakeCaretVisible(TdxPDFTextPosition.Create(APageIndex, TdxPDFPageTextPosition.Create(AWordIndex + 1, 1)));
      Exit(True);
    end;
  end;
  Result := False;
end;

function TdxPDFViewerTextSelector.NormalizeDirection(ADirection: TdxPDFMovementDirection): TdxPDFMovementDirection;
const
  AngleMap: array[TdxPDFMovementDirection] of Integer = (0, 90, 180, 270, 270, 270, 270, 270, 270, 270);
  DocumentAngleMap: array[TcxRotationAngle] of Integer = (0, 270, 90, 180);
var
  AAngle: Integer;
begin
  AAngle := AngleMap[ADirection];
  AAngle := Trunc(TdxPDFUtils.NormalizeRotate(AAngle + DocumentAngleMap[Viewer.RotationAngle]));
  case AAngle of
    0:
      Result := mdLeft;
    90:
      Result := mdDown;
    180:
      Result := mdRight;
    else
      Result := mdUp;
  end;
end;

function TdxPDFViewerTextSelector.SameNextWordPartIndex(APageIndex, ALineIndex, AWordIndex: Integer): Boolean;
var
  I: Integer;
  ALineList: TdxPDFTextLineList;
begin
  ALineList := TextLines[APageIndex];
  Inc(ALineIndex);
  if ALineIndex < ALineList.Count then
    Exit(TdxPDFTextLineAccess(ALineList[ALineIndex]).WordPartList[0].WordIndex = AWordIndex);
  for I := APageIndex + 1 to Viewer.PageCount - 1 do
  begin
    ALineList := TextLines[I];
    if ALineList.Count > 0 then
      Exit(TdxPDFTextLineAccess(ALineList[0]).WordPartList[0].WordIndex = AWordIndex);
  end;
  Result := False;
end;

function TdxPDFViewerTextSelector.ValidateRanges(const ARanges: TdxPDFPageTextRanges): Boolean;
var
  I: Integer;
begin
  Result := Length(ARanges) > 0;
  for I := 0 to Length(ARanges) - 1 do
  begin
    Result := Result and ARanges[I].IsValid;
    if not Result then
      Break;
  end;
end;

procedure TdxPDFViewerTextSelector.DoMoveCaret(AProc: TdxPDFMovingCaretProc);
begin
  if HasCaret and Assigned(AProc) then
  begin
    AProc;
    Selection := nil;
    Viewer.SelectionController.SelectionChanged;
  end;
end;

procedure TdxPDFViewerTextSelector.MakeCaretVisible;
var
  R: TdxRectF;
begin
  if Caret.IsValid then
  begin
    R.TopLeft := Caret.ViewData.TopLeft;
    R.Right := R.TopLeft.X + Caret.ViewData.Height * Sin(Caret.ViewData.Angle);
    R.Bottom := R.Top - Caret.ViewData.Height;
    Viewer.ViewerController.MakeSelectionRectVisible(Caret.Position.PageIndex, R);
  end;
end;

procedure TdxPDFViewerTextSelector.MoveAndMakeCaretVisible(const APosition: TdxPDFTextPosition);
begin
  MoveCaret(APosition);
  MakeCaretVisible;
end;

procedure TdxPDFViewerTextSelector.MoveDown;
var
  ALineList: TdxPDFTextLineList;
  ALastLineIndex, AWordIndex, AOffset, I, ANextPageIndex: Integer;
begin
  ALineList := TextLines[Caret.Position.PageIndex];
  ALastLineIndex := ALineList.Count - 1;
  if ALastLineIndex >= 0 then
  begin
    AWordIndex := Caret.Position.Position.WordIndex;
    AOffset := Caret.Position.Position.Offset;
    for I := 0 to ALastLineIndex - 1 do
      if IsPositionInLine(Caret.Position.PageIndex, I, AWordIndex, AOffset) then
      begin
        SetCaretPosition(TdxPDFTextLineAccess(ALineList[I + 1]).GetPosition(Caret.Position.PageIndex, Caret.StartCoordinates));
        Exit;
      end;
    for ANextPageIndex := Caret.Position.PageIndex + 1 to Viewer.PageCount - 1 do
    begin
      ALineList := TextLines[ANextPageIndex];
      if ALineList.Count > 0 then
      begin
        SetCaretPosition(TdxPDFTextLineAccess(ALineList[0]).GetPosition(ANextPageIndex, Caret.StartCoordinates));
        Exit;
      end;
    end;
  end;
  SetCaretPosition(Caret.Position);
end;

procedure TdxPDFViewerTextSelector.MoveLeft;
var
  APageIndex, AWordIndex, AOffset, APreviousPageIndex, ALastLineIndex: Integer;
  ALineList: TdxPDFTextLineList;
  AWordParts: TdxPDFTextWordPartList;
  AWordPart: TdxPDFTextWordPart;
begin
  APageIndex := Caret.Position.PageIndex;
  AWordIndex := Caret.Position.Position.WordIndex;
  AOffset := Caret.Position.Position.Offset;
  if AOffset > 0 then
    MoveAndMakeCaretVisible(TdxPDFTextPosition.Create(APageIndex, TdxPDFPageTextPosition.Create(AWordIndex, AOffset - 1)))
  else
    if AWordIndex > 1 then
      MoveAndMakeCaretVisible(TdxPDFTextPosition.Create(APageIndex, TdxPDFPageTextPosition.Create(
        AWordIndex - 1, FindWordEndPosition(TdxPDFTextPosition.Create(APageIndex, AWordIndex - 1, 0)))))
    else
    begin
      for APreviousPageIndex := APageIndex - 1 downto 0 do
      begin
        ALineList := TextLines[APreviousPageIndex];
        ALastLineIndex := ALineList.Count - 1;
        if ALastLineIndex >= 0 then
        begin
          AWordParts := TdxPDFTextLineAccess(ALineList[ALastLineIndex]).WordPartList;
          AWordPart := AWordParts[AWordParts.Count - 1];
          MoveAndMakeCaretVisible(TdxPDFTextPosition.Create(APreviousPageIndex,
            TdxPDFPageTextPosition.Create(AWordPart.WordIndex, TdxPDFTextWordPartAccess(AWordPart).NextWrapOffset)));
          Exit;
        end;
      end;
      MoveAndMakeCaretVisible(Caret.Position);
    end;
end;

procedure TdxPDFViewerTextSelector.MoveRight;
var
  APageIndex, ALastLineIndex, AWordIndex, AOffset, I, ALastWordPartIndex, ANextPageIndex: Integer;
  ALineList: TdxPDFTextLineList;
  ALine, ALastLine: TdxPDFTextLineAccess;
  AWordParts: TdxPDFTextWordPartList;
  ALastWordPart: TdxPDFTextWordPartAccess;
begin
  APageIndex := Caret.Position.PageIndex;
  ALineList := TextLines[APageIndex];
  ALastLineIndex := ALineList.Count - 1;
  if ALastLineIndex >= 0 then
  begin
    AWordIndex := Caret.Position.Position.WordIndex;
    AOffset := Caret.Position.Position.Offset;
    for I := 0 to ALastLineIndex - 1 do
    begin
      ALine := TdxPDFTextLineAccess(ALineList[I]);
      if ALine.PositionInLine(AWordIndex, AOffset) and
        MoveRight(ALine.WordPartList, APageIndex, I, AWordIndex, AOffset, True) then
        Exit;
    end;
    ALastLine := TdxPDFTextLineAccess(ALineList[ALastLineIndex]);
    if ALastLine.PositionInLine(AWordIndex, AOffset) then
    begin
      AWordParts := ALastLine.WordPartList;
      if MoveRight(AWordParts, APageIndex, ALastLineIndex, AWordIndex, AOffset, False) then
        Exit;
      ALastWordPartIndex := AWordParts.Count - 1;
      ALastWordPart := TdxPDFTextWordPartAccess(AWordParts[ALastWordPartIndex]);
      if ALastWordPart.Same(AWordIndex, AOffset) then
      begin
        if (ALastWordPart.NextWrapOffset > AOffset) or (((AWordIndex = AWordParts[ALastWordPartIndex].WordIndex) and
          SameNextWordPartIndex(APageIndex, ALastLineIndex, AWordIndex))) then
        begin
          MoveAndMakeCaretVisible(TdxPDFTextPosition.Create(APageIndex, TdxPDFPageTextPosition.Create(AWordIndex, AOffset + 1)));
          Exit;
        end;
        for ANextPageIndex := APageIndex + 1 to Viewer.PageCount - 1 do
          if TextLines[ANextPageIndex].Count > 0 then
          begin
            MoveAndMakeCaretVisible(TdxPDFTextPosition.Create(ANextPageIndex, TdxPDFPageTextPosition.Create(1, 0)));
            Exit;
          end;
      end;
    end;
  end;
  MoveAndMakeCaretVisible(Caret.Position);
end;

procedure TdxPDFViewerTextSelector.MoveToDocumentEnd;
var
  I, ALineCount: Integer;
  ALines: TdxPDFTextLineList;
  ALastLine: TdxPDFTextWordPartList;
  ALastWord: TdxPDFTextWordPartAccess;
begin
  for I := Viewer.PageCount - 1 downto 0 do
  begin
    ALines := TextLines[I];
    if ALines = nil then
      ALineCount := 0
    else
      ALineCount := ALines.Count;
    if ALineCount > 0 then
    begin
      ALastLine := TdxPDFTextLineAccess(ALines[ALineCount - 1]).WordPartList;
      if ALastLine.Count > 0 then
      begin
        ALastWord := TdxPDFTextWordPartAccess(ALastLine[ALastLine.Count - 1]);
        MoveAndMakeCaretVisible(TdxPDFTextPosition.Create(I,
          TdxPDFPageTextPosition.Create(ALastWord.WordIndex, ALastWord.Characters.Count)));
        Exit;
      end;
    end;
  end;
end;

procedure TdxPDFViewerTextSelector.MoveToDocumentStart;
var
  I: Integer;
begin
  for I := 0 to Viewer.PageCount - 1 do
    if TextLines[I].Count > 0 then
    begin
      MoveAndMakeCaretVisible(TdxPDFTextPosition.Create(I, 1, 0));
      Break;
    end;
end;

procedure TdxPDFViewerTextSelector.MoveToLineStart;
var
  I: Integer;
  ALine: TdxPDFTextLineAccess;
  ALines: TdxPDFTextLineList;
begin
  ALines := TextLines[Caret.Position.PageIndex];
  for I := 0 to ALines.Count - 1 do
  begin
    ALine := TdxPDFTExtLineAccess(ALines[I]);
    if ALine.PositionInLine(Caret.Position.Position.WordIndex, Caret.Position.Position.Offset) then
      MoveAndMakeCaretVisible(TdxPDFTextPosition.Create(
        Caret.Position.PageIndex,
        TdxPDFPageTextPosition.Create(ALine.WordPartList[0].WordIndex,
        TdxPDFTextWordPartAccess(ALine.WordPartList[0]).WrapOffset)));
  end;
end;

procedure TdxPDFViewerTextSelector.MoveToLineEnd;
var
  I, ALastWordIndex: Integer;
  ALines: TdxPDFTextLineList;
  ALine: TdxPDFTextLineAccess;
  AParts: TdxPDFTextWordPartList;
  ALast: TdxPDFTextWordPartAccess;
begin
  ALines := TextLines[Caret.Position.PageIndex];
  for I := 0 to ALines.Count - 1 do
  begin
    ALine := TdxPDFTextLineAccess(ALines[I]);
    if ALine.PositionInLine(Caret.Position.Position.WordIndex, Caret.Position.Position.Offset) then
    begin
      AParts := ALine.WordPartList;
      ALastWordIndex := AParts.Count - 1;
      ALast := TdxPDFTextWordPartAccess(AParts[ALastWordIndex]);
      MoveAndMakeCaretVisible(TdxPDFTextPosition.Create(Caret.Position.PageIndex,
        TdxPDFPageTextPosition.Create(ALast.WordIndex, ALast.Characters.Count)));
    end;
  end;
end;

procedure TdxPDFViewerTextSelector.MoveToNextWord;
var
  ACaretWordIndex, ACaretPageIndex, ACaretOffset, I: Integer;
  ALineList: TdxPDFTextLineList;
  ALastLine, ALine: TdxPDFTextLineAccess;
  AHasNextWord: Boolean;
  AWord: TdxPDFTextWordPart;
begin
  ACaretWordIndex := Caret.Position.Position.WordIndex;
  ACaretPageIndex := Caret.Position.PageIndex;
  ACaretOffset := Caret.Position.Position.Offset;

  ALineList := TextLines[ACaretPageIndex];

  ALastLine := TdxPDFTextLineAccess(ALineList.Last);
  AHasNextWord := False;
  if (ALastLine.WordList.Count <> 0) and (ALastLine.WordList[ALastLine.WordList.Count - 1].Index = ACaretWordIndex) then
  begin
    while (ACaretPageIndex < Viewer.PageCount - 1) and not AHasNextWord do
    begin
      Inc(ACaretPageIndex);
      ALineList := TextLines[ACaretPageIndex];
      AHasNextWord := (ALineList <> nil) and (ALineList.Count > 0);
    end;
    if AHasNextWord then
      ACaretWordIndex := 0;
  end
  else
    AHasNextWord := True;
  if AHasNextWord then
    MoveAndMakeCaretVisible(TdxPDFTextPosition.Create(ACaretPageIndex, ACaretWordIndex + 1, 0))
  else
  begin
    ALineList := TextLines[Caret.Position.PageIndex];
    for I := 0 to ALineList.Count - 1 do
    begin
      ALine := TdxPDFTextLineAccess(ALineList[I]);
      if ALine.PositionInLine(ACaretWordIndex, ACaretOffset) then
        for AWord in ALine.WordPartList do
          if AWord.WordIndex = ACaretWordIndex then
            MoveAndMakeCaretVisible(TdxPDFTextPosition.Create(Caret.Position.PageIndex, ACaretWordIndex, AWord.Characters.Count));
    end;
  end;
end;

procedure TdxPDFViewerTextSelector.MoveToPreviousWord;
var
  ACaretPageIndex, ACaretOffset, ACaretWordIndex, ALastWordIndex: Integer;
  ALines: TdxPDFTextLineList;
  ALastLine: TdxPDFTextWordPartList;
begin
  ACaretPageIndex := Caret.Position.PageIndex;
  ACaretOffset := Caret.Position.Position.Offset;
  ACaretWordIndex := Caret.Position.Position.WordIndex;
  if ACaretOffset <> 0 then
    MoveAndMakeCaretVisible(TdxPDFTextPosition.Create(ACaretPageIndex, ACaretWordIndex, 0))
  else
    if ACaretWordIndex = 1 then
    begin
      while ACaretPageIndex > 0 do
      begin
        Dec(ACaretPageIndex);
        ALines := TextLines[ACaretPageIndex];
        if ALines.Count > 0 then
        begin
          ALastLine := TdxPDFTextLineAccess(ALines[ALines.Count - 1]).WordPartList;
          ALastWordIndex := ALastLine[ALastLine.Count - 1].WordIndex;
          MoveAndMakeCaretVisible(TdxPDFTextPosition.Create(ACaretPageIndex, ALastWordIndex, 0));
          Exit;
        end;
      end;
    end
    else
      MoveAndMakeCaretVisible(TdxPDFTextPosition.Create(ACaretPageIndex, ACaretWordIndex - 1, 0));
end;

procedure TdxPDFViewerTextSelector.MoveUp;
var
  ANewPosition: TdxPDFTextPosition;
  APageIndex, AWordIndex, AOffset, I, APrevPageIndex: Integer;
  ALineList: TdxPDFTextLineList;
  ALine: TdxPDFTextLineAccess;
begin
  APageIndex := Caret.Position.PageIndex;
  AWordIndex := Caret.Position.Position.WordIndex;
  AOffset := Caret.Position.Position.Offset;
  ALineList := TextLines[APageIndex];
  for I := ALineList.Count - 1 downto 0 + 1 do
  begin
    ALine := TdxPDFTextLineAccess(ALineList[I]);
    if ALine.PositionInLine(AWordIndex, AOffset) then
    begin
      ANewPosition := TdxPDFTextLineAccess(ALineList[I - 1]).GetPosition(APageIndex, Caret.StartCoordinates);
      AWordIndex := ANewPosition.Position.WordIndex;
      AOffset := ANewPosition.Position.Offset;
      if ALine.PositionInLine(AWordIndex, AOffset) then
        SetCaretPosition(TdxPDFTextPosition.Create(APageIndex, TdxPDFPageTextPosition.Create(AWordIndex, AOffset - 1)))
      else
        SetCaretPosition(TdxPDFTextPosition.Create(APageIndex, TdxPDFPageTextPosition.Create(AWordIndex, AOffset)));
      Exit;
    end;
  end;
  for APrevPageIndex := APageIndex - 1 downto 0 do
  begin
    ALineList := TextLines[APrevPageIndex];
    if ALineList.Count > 0 then
    begin
      SetCaretPosition(TdxPDFTextLineAccess(ALineList.Last).GetPosition(APrevPageIndex, Caret.StartCoordinates));
      Exit;
    end;
  end;
  SetCaretPosition(Caret.Position);
end;

procedure TdxPDFViewerTextSelector.Select(APage: TdxPDFPage; AProc: TProc);
begin
  if APage <> nil then
    TdxPDFPageAccess(APage).LockAndExecute(AProc);
end;

procedure TdxPDFViewerTextSelector.SetCaretPosition(const APosition: TdxPDFTextPosition);
begin
  if not HasCaret then
    Caret := TdxPDFDocumentCaret.Create(APosition, GetCaretViewData(APosition), Caret.StartCoordinates)
  else
    Caret := TdxPDFDocumentCaret.Create(APosition, GetCaretViewData(APosition), dxNullPointF);
  MakeCaretVisible;
end;

procedure TdxPDFViewerTextSelector.StoreSelectionStartTextPosition;
begin
  if IsEmptySelection and HasCaret then
    FStartTextPosition := Caret.Position;
end;

procedure TdxPDFViewerTextSelector.UpdateSelection(const APosition: TdxPDFTextPosition);
begin
  MoveCaret(APosition);
  if not IsEmptySelection then
  begin
    Selection := nil;
    Viewer.SelectionController.SelectionChanged;
  end;
end;

{ TdxPDFViewerSelectionController }

constructor TdxPDFViewerSelectionController.Create(AViewer: TdxPDFCustomViewer);
begin
  inherited Create(AViewer);
  FImageSelector := TdxPDFViewerImageSelector.Create(Viewer);
  FTextSelector := TdxPDFViewerTextSelector.Create(Viewer);
  FClickController := TdxPDFViewerClickController.Create;
  FSelection := nil;
  FCaret.Invalid;
end;

destructor TdxPDFViewerSelectionController.Destroy;
begin
  FreeAndNil(FSelection);
  FreeAndNil(FClickController);
  FreeAndNil(FTextSelector);
  FreeAndNil(FImageSelector);
  inherited Destroy;
end;

function TdxPDFViewerSelectionController.CanExtractSelectedContent(AHitCode: Int64): Boolean;
begin
  Result := Viewer.CanExtractContent and (Selection <> nil) and  (Selection.HitCode = AHitCode);
end;

function TdxPDFViewerSelectionController.IsEmptySelection: Boolean;
begin
  Result := FSelection = nil;
end;

procedure TdxPDFViewerSelectionController.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Viewer.IsDocumentLoaded then
  begin
    FClickController.Click(Button, X, Y);
    if (ssLeft in Shift) and HitTest.HitAtPage and not HitTest.HitAtInteractiveObject then
    begin
      if not Viewer.HandTool then
        StartSelection(Shift)
    end
    else
      if not HitTest.HitAtSelection then
        LockedClear;
  end;
end;

procedure TdxPDFViewerSelectionController.MouseMove(Shift: TShiftState; X, Y: Integer);

  function NeedSelect(AShift: TShiftState): Boolean;
  begin
    Result := (ssLeft in AShift) and ((FClickController.ClickCount <= 1) or HitTest.HitAtImage or
      FImageSelector.InProgress);
  end;

begin
  if Viewer.IsDocumentLoaded and NeedSelect(Shift) then
    DoSelect;
end;

procedure TdxPDFViewerSelectionController.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Viewer.IsDocumentLoaded then
    EndSelection(Shift);
end;

procedure TdxPDFViewerSelectionController.DoSelect;
begin
  if not FImageSelector.Select then
    FTextSelector.Select(HitTest.Position);
end;

procedure TdxPDFViewerSelectionController.DoSelect(AShift: TShiftState);
begin
  if ssShift in AShift then
  begin
    FTextSelector.InProgress := True;
    DoSelect;
  end
  else
    StartSelection;
end;

function TdxPDFViewerSelectionController.GetImageSelection(const AArea: TdxPDFPageRect): TdxPDFImageSelection;
var
  AImage: TdxPDFImage;
  AImageBounds: TdxRectF;
begin
  Result := nil;
  for AImage in Images[AArea.PageIndex] do
  begin
    AImageBounds := TdxPDFImageAccess(AImage).Bounds;
    if TdxPDFUtils.Intersects(AArea.Rect, AImageBounds) then
      Result := TdxPDFImageSelection.Create(Viewer, Viewer.Painter.SelectionBackColor, Viewer.Painter.SelectionFrameColor,
        TdxPDFImageAccess(AImage).GUID, TdxPDFPageRect.Create(AArea.PageIndex, AImageBounds), TdxPDFImageAccess(AImage).Bounds);
  end;
end;

function TdxPDFViewerSelectionController.GetTextRanges(const AArea: TdxPDFPageRect): TdxPDFPageTextRanges;
var
  ATextSelection: TdxPDFTextHighlightAccess;
begin
  ATextSelection := TdxPDFTextHighlightAccess(GetTextSelection(AArea));
  if ATextSelection <> nil then
  try
    SetLength(Result, Length(ATextSelection.Ranges));
    cxCopyData(@ATextSelection.Ranges[0], @Result[0], 0, 0, Length(ATextSelection.Ranges) * SizeOf(TdxPDFPageTextRange));
  finally
    ATextSelection.Free;
  end;
end;

function TdxPDFViewerSelectionController.GetTextSelection(const AArea: TdxPDFPageRect): TdxPDFTextSelection;
var
  ALine: TdxPDFTextLine;
  APageIndex: Integer;
  ARange: TdxPDFPageTextRange;
  ARanges: TdxPDFPageTextRanges;
begin
  SetLength(ARanges, 0);
  APageIndex := AArea.PageIndex;
  for ALine in TextLines[APageIndex] do
    if TdxPDFUtils.Intersects(AArea.Rect, TdxPDFTextLineAccess(ALine).Bounds.RotatedRect) then
    begin
      ARange := TdxPDFTextLineAccess(ALine).GetRange(APageIndex, AArea.Rect);
      if not TdxPDFPageTextRange.Same(ARange, TdxPDFPageTextRange.Invalid)  then
        TdxPDFTextUtils.AddRange(ARange, ARanges);
    end;
  Result := FTextSelector.CreateTextSelection(ARanges);
end;

function TdxPDFViewerSelectionController.HitAtSelection: Boolean;
begin
  if FTextSelector.InProgress then
    Result := False
  else
    if FImageSelector.InProgress then
      Result := False
    else
      Result := not IsEmptySelection and TdxPDFCustomSelectionAccess(Selection).Contains(HitTest.Position)
end;

procedure TdxPDFViewerSelectionController.Clear;
begin
  LockedClear;
  SelectionChanged;
end;

procedure TdxPDFViewerSelectionController.LockedClear;
begin
  Selection := nil;
  HideCaret;
  FImageSelector.Clear;
  FTextSelector.Clear;
end;

procedure TdxPDFViewerSelectionController.CopyToClipboard;
begin
  if Viewer.CanExtractContent and not IsEmptySelection then
  begin
    if Selection is TdxPDFImageSelection then
      CopyImageToClipboard;
    if Selection is TdxPDFTextSelection then
      CopyTextToClipboard;
  end;
end;

procedure TdxPDFViewerSelectionController.HideCaret;
begin
  Caret := TdxPDFDocumentCaret.Invalid;
  Viewer.DeleteCaret;
end;

procedure TdxPDFViewerSelectionController.MakeVisible;
var
  APageIndex: Integer;
  ARect:TdxRectF;
  APageRects: TdxPDFRectFList;
begin
  if Selection <> nil then
  begin
    APageIndex := -1;
    ARect := dxNullRectF;
    if Selection is TdxPDFImageSelection then
    begin
      APageIndex := TdxPDFImageSelectionAccess(Selection).PageIndex;
      ARect := TdxPDFImageSelectionAccess(Selection).Bounds;
    end
    else
      if Selection is TdxPDFTextSelection then
      begin
        APageIndex := TdxPDFTextHighlightAccess(Selection).Ranges[0].PageIndex;
        APageRects := TdxPDFTextHighlightAccess(Selection).PageRects[APageIndex];
        if (APageRects = nil) or (APageRects.Count = 0) then
          Exit;
        ARect := APageRects[0];
      end;
    if Assigned(FOnMakeRectVisible) and (APageIndex >= 0) then
      OnMakeRectVisible(APageIndex, ARect);
  end;
end;

procedure TdxPDFViewerSelectionController.Select(const ARect: TRect);
var
  I: Integer;
  AArea: TdxPDFPageRect;
  AAreaList: TList<TdxPDFPageRect>;
  AIntersection, R, ADocumentRect: TdxRectF;
  ARanges: TdxPDFPageTextRanges;
  AViewerPage: TdxPDFViewerPage;
begin
  if Viewer.IsDocumentLoaded then
  begin
    ADocumentRect := dxRectF(ARect);
    AAreaList := TList<TdxPDFPageRect>.Create;
    try
      for I := 0 to Viewer.PageCount - 1 do
      begin
        AViewerPage := Viewer.PageList[I] as TdxPDFViewerPage;
        if TdxPDFUtils.Intersects(AIntersection, dxRectF(AViewerPage.Bounds), ADocumentRect) then
        begin
          R := AViewerPage.ToDocumentRect(AIntersection);
          AArea := TdxPDFPageRect.Create(I, cxRectAdjustF(R));
          AAreaList.Add(AArea);
          ARanges := GetTextRanges(AArea);
        end;
      end;
      LockedClear;
      SelectText(ARanges);
      if Selection = nil then
        for AArea in AAreaList do
        begin
          SelectImage(AArea);
          if Selection <> nil then
            Break;
        end;
    finally
      AAreaList.Free;
    end;
  end;
end;

procedure TdxPDFViewerSelectionController.SelectText(ARange: TdxPDFPageTextRange);
begin
  if Viewer.IsDocumentLoaded then
  begin
    Selection := FTextSelector.CreateTextSelection(ARange);
    SelectionChanged;
  end;
end;

procedure TdxPDFViewerSelectionController.SelectAll;
var
  I: Integer;
  ARanges: TdxPDFPageTextRanges;
begin
  if Viewer.IsDocumentLoaded then
  begin
    SetLength(ARanges, 0);
    for I := 0 to Viewer.PageCount - 1 do
      TdxPDFTextUtils.AddRange(TdxPDFPageTextRange.Create(I), ARanges);
    SelectText(ARanges);
  end;
end;

procedure TdxPDFViewerSelectionController.SelectionChanged;
begin
  if not Viewer.HandTool and not Viewer.HitTest.HitAtBackground and not Viewer.IsDestroying then
    dxCallNotify(OnSelectionChanged, Self);
end;

procedure TdxPDFViewerSelectionController.SelectByKeyboard(ADirection: TdxPDFMovementDirection);
begin
  FTextSelector.SelectByKeyboard(ADirection);
  SelectionChanged;
end;

procedure TdxPDFViewerSelectionController.SelectImage(const AArea: TdxPDFPageRect);
begin
  Selection := GetImageSelection(AArea);
  SelectionChanged;
end;

procedure TdxPDFViewerSelectionController.SelectText(const ARanges: TdxPDFPageTextRanges);
begin
  Selection := FTextSelector.CreateTextSelection(ARanges);
  SelectionChanged;
end;

procedure TdxPDFViewerSelectionController.EndSelection;
begin
  FInOutsideContent := False;
  FTextSelector.Reset;
  DoSelect;
  SelectionChanged;
  FImageSelector.Reset;
  FStartSelectionPosition.Invalid;
end;

procedure TdxPDFViewerSelectionController.EndSelection(AShift: TShiftState);

  function NearTo(const P1, P2: TdxPDFPagePoint): Boolean;
  const
    Distance = 3;
  begin
    Result := (P1.PageIndex = P2.PageIndex) and
      (Abs(P1.Point.X - P2.Point.X) <= Distance) and
      (Abs(P1.Point.Y - P2.Point.Y) <= Distance);
  end;

begin
  if NearTo(FStartSelectionPosition, HitTest.Position) then
  begin
    if HitTest.HitAtImage then
      LockedClear
    else
      DoSelect(AShift);
  end;
  EndSelection;
end;

function TdxPDFViewerSelectionController.CreateHighlight(ARange: TdxPDFPageTextRange;
  ABackColor, AFrameColor: TdxAlphaColor): TdxPDFTextHighlight;
var
  ARanges: TdxPDFPageTextRanges;
begin
  SetLength(ARanges, 0);
  TdxPDFTextUtils.AddRange(ARange, ARanges);
  Result := CreateHighlight(ARanges, ABackColor, AFrameColor);
end;

function TdxPDFViewerSelectionController.CreateHighlight(const ARanges: TdxPDFPageTextRanges;
  ABackColor, AFrameColor: TdxAlphaColor): TdxPDFTextHighlight;
begin
  Result := FTextSelector.CreateTextHighlights(ARanges, ABackColor, AFrameColor);
end;

function TdxPDFViewerSelectionController.KeyDown(var AKey: Word; AShift: TShiftState): Boolean;
var
  AShiftPressed: Boolean;
begin
  Result := True;
  AShiftPressed := ssShift in AShift;
  case AKey of
     VK_LEFT:
       if IsCtrlPressed then
       begin
         if AShiftPressed then
           SelectByKeyboard(mdPreviousWord)
         else
           FTextSelector.MoveCaret(mdPreviousWord)
       end
       else
         if AShiftPressed then
           SelectByKeyboard(mdLeft)
         else
           FTextSelector.MoveCaret(mdLeft);
     VK_RIGHT:
       if IsCtrlPressed then
       begin
         if AShiftPressed then
           SelectByKeyboard(mdNextWord)
         else
           FTextSelector.MoveCaret(mdNextWord);
       end
       else
         if AShiftPressed then
           SelectByKeyboard(mdRight)
         else
           FTextSelector.MoveCaret(mdRight);
     VK_UP:
       if AShiftPressed then
         SelectByKeyboard(mdUp)
       else
         FTextSelector.MoveCaret(mdUp);
     VK_DOWN:
       if AShiftPressed then
         SelectByKeyboard(mdDown)
       else
         FTextSelector.MoveCaret(mdDown);
     VK_HOME:
       if IsCtrlPressed then
       begin
         if AShiftPressed then
           SelectByKeyboard(mdDocumentStart)
         else
           FTextSelector.MoveCaret(mdDocumentStart);
       end
       else
         if AShiftPressed then
           SelectByKeyboard(mdLineStart)
         else
           FTextSelector.MoveCaret(mdLineStart);
     VK_END:
       if IsCtrlPressed then
       begin
         if AShiftPressed then
           SelectByKeyboard(mdDocumentEnd)
         else
           FTextSelector.MoveCaret(mdDocumentEnd);
       end
       else
         if AShiftPressed then
           SelectByKeyboard(mdLineEnd)
         else
           FTextSelector.MoveCaret(mdLineEnd);
  else
    Result := False;
  end;
end;

procedure TdxPDFViewerSelectionController.StartSelection;
begin
  FStartSelectionPosition := HitTest.Position;
  LockedClear;
  if FStartSelectionPosition.IsValid then
    if not FTextSelector.StartSelection(FStartSelectionPosition) then
      FImageSelector.StartSelection(FInOutsideContent);
end;

procedure TdxPDFViewerSelectionController.StartSelection(AShift: TShiftState);
begin
  if HitTest.HitAtImage and not HitTest.HitAtText then
  begin
    if HitTest.HitAtSelection then
      FStartSelectionPosition := HitTest.Position
    else
      StartSelection;
  end
  else
    case FClickController.ClickCount of
      2:
        FTextSelector.SelectWord(HitTest.Position);
      3:
        FTextSelector.SelectLine(HitTest.Position);
      4:
        FTextSelector.SelectPage(HitTest.Position);
    else
      if HitTest.HitAtSelection then
        FStartSelectionPosition := HitTest.Position
      else
        DoSelect(AShift);
    end;
end;

function TdxPDFViewerSelectionController.GetSelectionAsBitmap: TcxBitmap;

  function GetActualRotationAngle(APageIndex: Integer): TcxRotationAngle;
  var
    AAngle: Integer;
    APage: TdxPDFPageAccess;
  begin
    APage := TdxPDFPageAccess(TdxPDFViewerPage(Viewer.PageList[APageIndex]).DocumentPage);
    AAngle := APage.CalculateRotationAngle(Viewer.RotationAngle);
    case AAngle of
      90:
        Result := raMinus90;
      270:
        Result := raPlus90;
      180:
        Result := ra180;
    else
      Result := ra0;
    end;
  end;

var
  ASelection: TdxPDFImageSelectionAccess;
begin
  Result := nil;
  if CanExtractSelectedContent(hcImage) then
  begin
    ASelection := TdxPDFImageSelectionAccess(Selection as TdxPDFImageSelection);
    Result := ASelection.GetImageBitmap;
    Result.Rotate(GetActualRotationAngle(ASelection.PageIndex));
  end;
end;

function TdxPDFViewerSelectionController.GetSelectionAsText: string;
begin
  if CanExtractSelectedContent(hcTextSelection) then
    Result := TdxPDFTextSelection(Selection).Text
  else
    Result := '';
end;

function TdxPDFViewerSelectionController.GetPage(AIndex: Integer): TdxPDFPage;
begin
  Result := Viewer.DocumentPages[AIndex];
end;

procedure TdxPDFViewerSelectionController.SetCaret(const AValue: TdxPDFDocumentCaret);
begin
  if not FCaret.Same(AValue) then
    FCaret := AValue;
end;

procedure TdxPDFViewerSelectionController.SetSelection(const AValue: TdxPDFCustomSelection);
begin
  if IsEmptySelection or not TdxPDFCustomSelectionAccess(Selection).Same(AValue) then
  begin
    FreeAndNil(FSelection);
    FSelection := AValue;
    Viewer.Invalidate;
  end
  else
    AValue.Free;
end;

function TdxPDFViewerSelectionController.GetImages(APageIndex: Integer): TdxPDFImageList;
begin
  Result := Page[APageIndex].RecognizedContent.Images;
end;

function TdxPDFViewerSelectionController.GetScaleFactor: TdxPointF;
begin
  Result := Viewer.DocumentScaleFactor;
end;

function TdxPDFViewerSelectionController.GetTextLines(APageIndex: Integer): TdxPDFTextLineList;
begin
  Result := Viewer.DocumentState.TextLines[APageIndex];
end;

function TdxPDFViewerSelectionController.GetHitTest: TdxPDFViewerDocumentHitTest;
begin
  Result := Viewer.HitTest;
end;

procedure TdxPDFViewerSelectionController.CopyImageToClipboard;
var
  ABitmap: TcxBitmap;
begin
  ABitmap := GetSelectionAsBitmap;
  if ABitmap <> nil then
    try
      Clipboard.Assign(ABitmap);
    finally
      ABitmap.Free;
    end;
end;

procedure TdxPDFViewerSelectionController.CopyTextToClipboard;
begin
  Clipboard.Open;
  try
    Clipboard.Clear;
    Clipboard.AsText := GetSelectionAsText;
  finally
    Clipboard.Close;
  end;
end;

{ TdxPDFViewerContainerController }

procedure TdxPDFViewerContainerController.DoMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited DoMouseDown(Button, Shift, X, Y);
  if LeftMouseButtonPressed then
    SetPressedAndFocusedCells;
end;

procedure TdxPDFViewerContainerController.DoMouseEnter(AControl: TControl);
begin
  inherited DoMouseEnter(AControl);
  HotCell := nil;
end;

procedure TdxPDFViewerContainerController.DoMouseLeave(AControl: TControl);
begin
  inherited DoMouseLeave(AControl);
  HitTest.Clear;
  HotCell := nil;
end;

procedure TdxPDFViewerContainerController.DoMouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited DoMouseMove(Shift, X, Y);
  HotCell := HitTest.HitObject;
end;

procedure TdxPDFViewerContainerController.DoMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited DoMouseUp(Button, Shift, X, Y);
  if (HitTest.HitObject <> nil) and HitTest.HitObject.IsPressed then
    ProcessClick(PressedCell);
  PressedCell := nil;
end;

procedure TdxPDFViewerContainerController.UpdateState;
begin
  ViewInfo.UpdateState;
end;

function TdxPDFViewerContainerController.CanActivate(const P: TPoint): Boolean;
begin
  Result := PtInRect(ViewInfo.Bounds, P);
end;

function TdxPDFViewerContainerController.GetHitTest: TdxPDFViewerCellHitTest;
begin
  Result := nil;
end;

function TdxPDFViewerContainerController.GetViewInfo: TdxPDFViewerContainerViewInfo;
begin
  Result := inherited ViewInfo;
end;

function TdxPDFViewerContainerController.ProcessKeyDown(AKey: Word; AShift: TShiftState): Boolean;
begin
  Result := False;
end;

procedure TdxPDFViewerContainerController.DoSetFocus;
begin
  Viewer.DoSetFocus;
end;

procedure TdxPDFViewerContainerController.SetPressedAndFocusedCells;
begin
  PressedCell := HitTest.HitObject;
  FocusedCell := HitTest.HitObject;
end;

procedure TdxPDFViewerContainerController.Clear;
begin
// do nothing
end;

function TdxPDFViewerContainerController.DoKeyDown(AKey: Word; AShift: TShiftState): Boolean;
begin
  Result := True;
  if AKey in [VK_TAB, VK_RETURN, VK_SPACE] then
  begin
    if (AKey = VK_TAB) then
      FocusNextCell(not (ssShift in AShift))
    else
      if (FocusedCell <> nil) and (AKey in [VK_RETURN, VK_SPACE]) then
         FocusedCell.Execute;
  end
  else
    Result := ProcessKeyDown(AKey, AShift);
end;

function TdxPDFViewerContainerController.GetCursor: TCursor;
begin
  Result := HitTest.Cursor;
end;

procedure TdxPDFViewerContainerController.CalculateHitTest(X, Y: Integer);
begin
  HitTest.Calculate(cxPoint(X, Y));
end;

procedure TdxPDFViewerContainerController.CellRemoving(ACell: TdxPDFViewerCellViewInfo);
begin
  if FHotCell = ACell then
    FHotCell := nil;
  if FPressedCell = ACell then
    FPressedCell := nil;
  if FFocusedCell = ACell then
    FFocusedCell := nil;
end;

procedure TdxPDFViewerContainerController.FocusNextCell(AGoForward: Boolean);
begin
  FocusedCell := FindNextFocusableCell(FocusedCell, AGoForward);
end;

procedure TdxPDFViewerContainerController.ProcessAccel(ACell: TdxPDFViewerCellViewInfo);
begin
  FocusedCell := ACell;
  ProcessClick(ACell);
end;

procedure TdxPDFViewerContainerController.ProcessClick(ACell: TdxPDFViewerCellViewInfo);
begin
  if ACell is TdxPDFViewerWidgetViewInfo then
    FocusedCell := ACell;
  ACell.Execute;
end;

function TdxPDFViewerContainerController.DoFindNextFocusableCell(ACell: TdxPDFViewerCellViewInfo;
  AOrderList: TdxPDFViewerViewInfoList; AGoForward: Boolean): TdxPDFViewerCellViewInfo;
const
  StepMap: array[Boolean] of Integer = (-1, 1);
var
  AIndex: Integer;
begin
  Result := nil;
  if AOrderList.Count = 0 then
    Exit;
  AIndex := (AOrderList.IndexOf(ACell) + StepMap[AGoForward]) mod AOrderList.Count;
  if (AIndex = -1) and not AGoForward then
    AIndex := AOrderList.Count - 1;
  while (AIndex >= 0) and (AIndex < AOrderList.Count) do
  begin
    if AOrderList[AIndex].CanFocus then
    begin
      Result := AOrderList[AIndex];
      Break;
    end;
    Inc(AIndex, StepMap[AGoForward]);
  end;
  if Result = nil then
    Result := AOrderList[0];
end;

function TdxPDFViewerContainerController.FindNextFocusableCell(ACell: TdxPDFViewerCellViewInfo;
  AGoForward: Boolean): TdxPDFViewerCellViewInfo;
var
  ATabOrderList: TdxPDFViewerViewInfoList;
begin
  ATabOrderList := TdxPDFViewerViewInfoList.Create(False);
  try
    ViewInfo.PopulateTabOrders(ATabOrderList);
    Result := DoFindNextFocusableCell(ACell, ATabOrderList, AGoForward);
  finally
    ATabOrderList.Free;
  end;
end;

procedure TdxPDFViewerContainerController.SetHotCell(const AValue: TdxPDFViewerCellViewInfo);
begin
  if FHotCell <> AValue then
  begin
    FHotCell := AValue;
    UpdateState;
  end;
end;

procedure TdxPDFViewerContainerController.SetPressedCell(const AValue: TdxPDFViewerCellViewInfo);
begin
  if FPressedCell <> AValue then
  begin
    FPressedCell := AValue;
    UpdateState;
  end;
end;

procedure TdxPDFViewerContainerController.SetFocusedCell(const AValue: TdxPDFViewerCellViewInfo);
begin
  if (FFocusedCell <> AValue) and ((AValue = nil) or AValue.CanFocus) then
  begin
    FFocusedCell := AValue;
    if Viewer.HandleAllocated and Viewer.CanFocusEx and Viewer.IsDocumentLoaded then
      DoSetFocus;
    UpdateState;
  end;
end;

{ TdxPDFViewerNavigationPaneController }

function TdxPDFViewerNavigationPaneController.GetHitTest: TdxPDFViewerCellHitTest;
begin
  Result := NavigationPane.HitTest;
end;

function TdxPDFViewerNavigationPaneController.GetViewInfo: TdxPDFViewerContainerViewInfo;
begin
  Result := GetNavigationViewInfo;
end;

function TdxPDFViewerNavigationPaneController.DoMouseWheel(AShift: TShiftState; AWheelDelta: Integer;
  const AMousePos: TPoint): Boolean;
begin
  Result := True;
end;

procedure TdxPDFViewerNavigationPaneController.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FHintHelper := TdxPDFViewerNavigationPaneHintHelper.Create(Viewer);
  FShowHintTimer := TcxTimer.Create(nil);
  FShowHintTimer.OnTimer := ShowHintTimerExpired;
end;

procedure TdxPDFViewerNavigationPaneController.Clear;
var
  APage: TdxPDFViewerNavigationPanePage;
begin
  inherited Clear;
  for APage in NavigationPane.Pages do
    APage.Clear;
  NavigationPane.ActivePage := nil;
  NavigationPane.ActivePageState := wsMinimized;
end;

procedure TdxPDFViewerNavigationPaneController.DestroySubClasses;
begin
  FHintHelper.HideHint;
  FreeAndNil(FShowHintTimer);
  FreeAndNil(FHintHelper);
  inherited DestroySubClasses;
end;

procedure TdxPDFViewerNavigationPaneController.DoMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FHintHelper.MouseDown;
  if PtInRect(ViewInfo.ButtonsBounds, HitTest.HitPoint) then
  begin
    if (HitTest.HitObject <> nil) and HitTest.HitObject.IsHot then
      ProcessClick(HotCell);
    HotCell := nil;
  end
  else
    inherited DoMouseDown(Button, Shift, X, Y);
end;

procedure TdxPDFViewerNavigationPaneController.DoMouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited DoMouseMove(Shift, X, Y);
  CheckHint;
end;

procedure TdxPDFViewerNavigationPaneController.DoMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Viewer.ViewerController.ResetLeftMouseButtonPressed;
  if not PtInRect(ViewInfo.ButtonsBounds, HitTest.HitPoint) then
    inherited DoMouseUp(Button, Shift, X, Y);
end;

procedure TdxPDFViewerNavigationPaneController.ExecuteOperation(const AOperation: TdxPDFInteractiveOperation);
begin
  Viewer.ViewerController.ExecuteOperation(AOperation);
  if Viewer.OptionsNavigationPane.Bookmarks.HideAfterUse then
    NavigationPane.MinimizePage;
end;

procedure TdxPDFViewerNavigationPaneController.Refresh;
var
  APage: TdxPDFViewerNavigationPanePage;
begin
  for APage in NavigationPane.Pages do
    APage.Refresh;
end;

function TdxPDFViewerNavigationPaneController.GetHintText: string;
begin
  if (FHintCell <> nil) and (FHintCell is TdxPDFViewerButtonViewInfo) then
    Result := TdxPDFViewerButtonViewInfo(FHintCell).GetHint
  else
    Result := '';
end;

function TdxPDFViewerNavigationPaneController.GetNavigationPane: TdxPDFViewerNavigationPane;
begin
  Result := Viewer.NavigationPane;
end;

function TdxPDFViewerNavigationPaneController.GetNavigationPaneHitTest: TdxPDFViewerNavigationPaneHitTest;
begin
  Result := inherited HitTest as TdxPDFViewerNavigationPaneHitTest;
end;

function TdxPDFViewerNavigationPaneController.GetNavigationViewInfo: TdxPDFViewerNavigationPaneViewInfo;
begin
  Result := NavigationPane.ViewInfo;
end;

function TdxPDFViewerNavigationPaneController.NeedShowHint(const AHint: string): Boolean;
begin
  Result := Viewer.OptionsBehavior.ShowHints and (FHintCell <> nil) and (AHint <> '') and
    Supports(FHintCell, IcxHintableObject) and cxCanShowHint(Viewer);
end;

procedure TdxPDFViewerNavigationPaneController.CheckHint;
var
  APreviousHotCell: TdxPDFViewerCellViewInfo;
  AVisible: Boolean;
begin
  APreviousHotCell := FHintCell;
  FHintCell := HotCell;
  if FHintCell <> APreviousHotCell then
  begin
    FShowHintTimer.Enabled := False;
    AVisible := TdxPDFViewerNavigationPaneHintHelper(FHintHelper).IsHintWindowVisible;
    FHintHelper.ResetLastHintElement;
    if NeedShowHint(GetHintText) then
    begin
      if AVisible then
        FShowHintTimer.Interval := Application.HintShortPause
      else
        FShowHintTimer.Interval := Application.HintPause;
      FShowHintTimer.Enabled := True;
    end;
  end;
end;

procedure TdxPDFViewerNavigationPaneController.ShowHintTimerExpired(Sender: TObject);
var
  AHint: string;
  AHintAreaBounds: TRect;
begin
  FShowHintTimer.Enabled := False;
  if HotCell <> nil then
  begin
    AHint := GetShortHint(GetHintText);
    AHintAreaBounds := HotCell.Bounds;
  end;
  if NeedShowHint(AHint) then
    FHintHelper.ShowHint(AHintAreaBounds, AHintAreaBounds, AHint, False, HotCell, Viewer.Font);
end;

{ TdxPDFViewerEditingController }

constructor TdxPDFViewerEditingController.Create(AController: TdxPDFViewerController);
begin
  inherited Create(AController.Viewer);
  FController := AController;
end;

destructor TdxPDFViewerEditingController.Destroy;
begin
  FreeAndNil(FEditData);
  inherited Destroy;
end;

procedure TdxPDFViewerEditingController.ShowEdit;
begin
  DoShowEdit(
    procedure
    begin
      FEdit.Activate(FEditData, Controller.Viewer.Focused);
    end, False);
end;

procedure TdxPDFViewerEditingController.ShowEditByKey(const AChar: Char);
begin
  DoShowEdit(
    procedure
    begin
      Edit.ActivateByKey(AChar, FEditData);
    end, False);
end;

procedure TdxPDFViewerEditingController.ShowEditByMouse(AShift: TShiftState = []);
begin
  FShift := AShift;
  DoShowEdit(
    procedure
    var
      AMousePos: TPoint;
    begin
      AMousePos := Widget.MousePos;
      Edit.ActivateByMouse(AShift, AMousePos.X, AMousePos.Y, FEditData);
    end, True);
end;

function TdxPDFViewerEditingController.CanInitEditing: Boolean;
var
  AWidget: TdxPDFViewerWidgetViewInfo;
begin
  AWidget := Widget;
  Result := (AWidget <> nil) and not AWidget.Field.ReadOnly and not AWidget.IsRotated and
    TdxPDFCustomWidgetAccess(AWidget.Widget).Visible;
end;

function TdxPDFViewerEditingController.GetCancelEditingOnExit: Boolean;
begin
  Result := False;
end;

function TdxPDFViewerEditingController.GetEditParent: TWinControl;
begin
  Result := Controller.Viewer;
end;

function TdxPDFViewerEditingController.GetFocusedCellBounds: TRect;
begin
  Result := Widget.EditBounds;
end;

function TdxPDFViewerEditingController.GetHideEditOnExit: Boolean;
begin
  Result := True;
end;

function TdxPDFViewerEditingController.GetHideEditOnFocusedRecordChange: Boolean;
begin
  Result := True;
end;

function TdxPDFViewerEditingController.GetIsEditing: Boolean;
begin
  Result := (Edit <> nil) and CanInitEditing;
end;

function TdxPDFViewerEditingController.GetValue: Variant;
begin
  Result := Widget.EditValue;
end;

procedure TdxPDFViewerEditingController.ClearEditingItem;
begin
// do nothing
end;

procedure TdxPDFViewerEditingController.DoHideEdit(AAccept: Boolean);
var
  AEditValue, APreviousValue: Variant;
begin
  if Edit = nil then
    Exit;

  if AAccept then
    Edit.Deactivate;

  if AAccept and Edit.EditModified then
  begin
    AEditValue := Edit.EditValue;
    APreviousValue := GetValue;
    if not VarEquals(APreviousValue, AEditValue) then
      SetValue(AEditValue);
  end;
  UnInitEdit;
  Edit.EditModified := False;
  if (Edit <> nil) and Edit.IsFocused then
    Controller.Viewer.DoSetFocus;
  Edit.Visible := False;
  if Widget <> nil then
    Widget.Invalidate;
  HideInplaceEditor;
end;

procedure TdxPDFViewerEditingController.DoUpdateEdit;
begin
  if not IsEditing or (Edit = nil) then
    Exit;
  if EditPreparing then
  begin
    AssignEditStyle;
    FEditPlaceBounds := GetFocusedCellBounds;
  end;
end;

procedure TdxPDFViewerEditingController.EditAfterKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  AIsReplacementMode: Boolean;
  ATextEdit: TcxCustomTextEdit;
begin
  inherited EditAfterKeyDown(Sender, Key, Shift);
  AIsReplacementMode := VarIsSoftNull(Edit.EditValue) or VarIsSoftEmpty(Edit.EditValue) or VarIsSoftNull(GetValue)
    or VarIsSoftEmpty(GetValue);
  if Key in [VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT, VK_NEXT, VK_PRIOR, VK_HOME, VK_END] then
  begin
    if Edit is TcxCustomTextEdit then
      ATextEdit := TcxCustomTextEdit(Edit)
    else
      ATextEdit := nil;
    if AIsReplacementMode or (ATextEdit = nil) or
      (((Key in [VK_UP, VK_DOWN, VK_NEXT, VK_PRIOR]) or
        ((ATextEdit.SelLength = 0) and
          ((Key in [VK_HOME, VK_LEFT]) and (ATextEdit.SelStart = 0)) or
          ((Key in [VK_END, VK_RIGHT]) and (ATextEdit.SelStart = Length(ATextEdit.Text)))))) then
    begin
      Controller.KeyDown(Key, Shift);
    end;
  end;
end;

procedure TdxPDFViewerEditingController.DoEditChanged;
begin
  inherited DoEditChanged;
  UpdateEditFontSize;
end;

procedure TdxPDFViewerEditingController.EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  AChar: Char;
begin
  inherited EditKeyDown(Sender, Key, Shift);
  case Key of
    VK_ESCAPE:
      HideEdit(False);
    VK_TAB, VK_RETURN:
      begin
        HideEdit(True);
        Controller.KeyDown(Key, Shift);
        AChar := Char(Key);
        Controller.KeyPress(AChar);
      end;
  end;
end;

procedure TdxPDFViewerEditingController.SetValue(const AValue: Variant);
begin
  Widget.EditValue := AValue;
end;

procedure TdxPDFViewerEditingController.StartEditingByTimer;
begin
// do nothing
end;

procedure TdxPDFViewerEditingController.UpdateInplaceParamsPosition;
begin
// do nothing
end;

procedure TdxPDFViewerEditingController.UpdateEditFontSize;
begin
  if (Edit <> nil) and (Widget <> nil) then
    Widget.UpdateEditFontSize(Edit);
end;

procedure TdxPDFViewerEditingController.UpdateEditPosition;
var
  ARegion: TcxRegion;
  ARect: TRect;
  AMetric: TTextMetric;
begin
  if (Edit = nil) or (Widget = nil) then
    Exit;
  ARect := Widget.EditBounds;
  if not Widget.UseWindowRegion(ARegion) then
  begin
    Edit.BoundsRect := ARect;
    Exit;
  end;
  try
    if Widget.NeedExtraSymbolWidthForEditor and TdxTextMeasurer.TextMetrics(Edit.Style.Font, AMetric) then
     ARect.Width := ARect.Width + AMetric.tmMaxCharWidth; 
    Edit.BoundsRect := ARect;
    SetWindowRegion(Edit.Handle, ARegion.Handle);
    ARegion.Handle := 0;
  finally
    ARegion.Free;
  end;
end;

function TdxPDFViewerEditingController.GetWidget: TdxPDFViewerWidgetViewInfo;
begin
  Result := Controller.GetFocusedWidgetViewInfo;
end;

function TdxPDFViewerEditingController.PrepareEdit(AIsMouseEvent: Boolean): Boolean;
var
  AProperties: TcxCustomEditProperties;
  AWidget: TdxPDFViewerWidgetViewInfo;
begin
  Result := IsEditing;
  if EditPreparing or EditHiding or not CanInitEditing then
    Exit;
  FEditPreparing := True;
  try
    AWidget := Widget;
    Result := (AWidget <> nil) and AWidget.TryGetProperties(AProperties);
    FEditPreparing := Result;
    if Result then
    begin
      FreeAndNil(FEditData);
      FEdit := EditList.GetEdit(AProperties);
      Edit.Visible := False;
      Result := Edit <> nil;
      if Result then
      begin
        Edit.Parent := nil;
        Edit.ActiveProperties.AutoSelect := not AIsMouseEvent;
      end;
    end;
    Result := Edit <> nil;
    if Result then
    begin
      InitEdit;
      UpdateEditPosition;
    end;
  finally
    FEditPreparing := False;
  end;
end;

procedure TdxPDFViewerEditingController.AssignEditStyle;
var
  AStyle: TcxCustomEditStyleAccess;
begin
  AStyle := TcxCustomEditStyleAccess(Edit.Style);
  AStyle.BeginUpdate;
  try
    Widget.InitStyle(AStyle);
    AStyle.ButtonTransparency := ebtHideInactive;
    AStyle.TransparentBorder := False;
  finally
    AStyle.EndUpdate;
  end;
end;

procedure TdxPDFViewerEditingController.DoShowEdit(AProc: TActivateEditProc; AIsMouseEvent: Boolean);
begin
  try
    if PrepareEdit(AIsMouseEvent) then
    begin
      Controller.SelectionController.Clear;
      AProc;
    end;
  except
    HideEdit(False);
    raise;
  end;
end;

{ TdxPDFViewerTabNavigationStrategy }

constructor TdxPDFViewerTabNavigationStrategy.Create(ATabNavigationController: TdxPDFViewerTabNavigationController;
  AController: TdxPDFViewerController);
begin
  inherited Create;
  FTabNavigationController := ATabNavigationController;
  FController := AController;
end;

function TdxPDFViewerTabNavigationStrategy.GetTabNext(ALastPageIndex: Integer): TdxPDFCustomAnnotation;
begin
  if FController.FocusedAnnotation <> nil then
    Result := GetNextAnnotation(FController.FocusedAnnotation)
  else
    Result := DoGetFirstAnnotation(ALastPageIndex);
end;

function TdxPDFViewerTabNavigationStrategy.DoGetFirstAnnotation(ALastPageIndex: Integer): TdxPDFCustomAnnotation;
var
  ADelta: Integer;
  AFirstPageAnnotationList: TdxFastObjectList;
begin
  ADelta := IfThen(ALastPageIndex = -1, StartPageIndex, ALastPageIndex) - Step;
  AFirstPageAnnotationList := GetNextPageWithAnnotations(ADelta);
  if AFirstPageAnnotationList <> nil then
    Result := GetPageFirstAnnotation(AFirstPageAnnotationList)
  else
    Result := nil
end;

function TdxPDFViewerTabNavigationStrategy.GetNextAnnotation(ACurrent: TdxPDFCustomAnnotation): TdxPDFCustomAnnotation;
var
  AAnnotationList: TdxFastObjectList;
  ADelta: Integer;
  APageIndex: Integer;
begin
  if ACurrent = nil then
    Exit(FirstAnnotation);
  APageIndex := ACurrent.PageIndex;
  AAnnotationList := FController.DocumentState.PageAnnotationList[APageIndex];
  if AAnnotationList.Count > 0 then
  begin
    ADelta := AAnnotationList.IndexOf(ACurrent);
    if ADelta <> -1 then
    begin
      Inc(ADelta, Step);
      if InRange(ADelta, 0, AAnnotationList.Count - 1) then
        Result := AAnnotationList[ADelta] as TdxPDFCustomAnnotation
      else
        Result := GetPageFirstAnnotation(GetNextPageWithAnnotations(APageIndex));
    end
    else
      Result := nil;
  end
  else
    Result := GetPageFirstAnnotation(GetNextPageWithAnnotations(APageIndex));
end;

function TdxPDFViewerTabNavigationStrategy.GetNextPageWithAnnotations(ACurrentPageIndex: Integer): TdxFastObjectList;
var
  AAnnotationList: TdxFastObjectList;
  AStartPageIndex, APageIndex, APageCount: Integer;
begin
  APageCount := PageCount;
  if (APageCount = 0) then
    Exit(nil);
  AStartPageIndex := ACurrentPageIndex + Step;
  APageIndex := AStartPageIndex;
  if (APageIndex >= APageCount) or (APageIndex < 0) then
    APageIndex := StartPageIndex;
  repeat
    AAnnotationList := Controller.DocumentState.PageAnnotationList[APageIndex];
    if AAnnotationList.Count > 0 then
    begin
      Exit(AAnnotationList);
      Break;
    end;
    Inc(APageIndex, Step);
    if (APageIndex < 0) or (APageIndex >= APageCount) then
      APageIndex := StartPageIndex;
  until APageIndex = AStartPageIndex;
  Result := nil;
end;

function TdxPDFViewerTabNavigationStrategy.GetFirstAnnotation: TdxPDFCustomAnnotation;
begin
  Result := DoGetFirstAnnotation(-1);
end;

function TdxPDFViewerTabNavigationStrategy.GetPageCount: Integer;
begin
  Result := FController.DocumentState.Document.PageCount;
end;

{ TdxPDFTabForwardNavigationStrategy }

function TdxPDFTabForwardNavigationStrategy.GetPageFirstAnnotation(
  AAnnotationList: TdxFastObjectList): TdxPDFCustomAnnotation;
begin
  if (AAnnotationList = nil) or (AAnnotationList.Count = 0) then
    Result := nil
  else
    Result := AAnnotationList[0] as TdxPDFCustomAnnotation;
end;

function TdxPDFTabForwardNavigationStrategy.GetStartPageIndex: Integer;
begin
  Result := 0;
end;

function TdxPDFTabForwardNavigationStrategy.GetStep: Integer;
begin
  Result := 1;
end;

{ TdxPDFTabBackwardNavigationStrategy }

function TdxPDFTabBackwardNavigationStrategy.GetPageFirstAnnotation(
  AAnnotationList: TdxFastObjectList): TdxPDFCustomAnnotation;
begin
  if (AAnnotationList = nil) or (AAnnotationList.Count = 0) then
    Result := nil
  else
    Result := AAnnotationList[AAnnotationList.Count - 1] as TdxPDFCustomAnnotation;
end;

function TdxPDFTabBackwardNavigationStrategy.GetStartPageIndex: Integer;
begin
  Result := PageCount - 1;
end;

function TdxPDFTabBackwardNavigationStrategy.GetStep: Integer;
begin
  Result := -1;
end;

{ TdxPDFViewerTabNavigationController }

constructor TdxPDFViewerTabNavigationController.Create(AController: TdxPDFViewerController);
begin
  inherited Create;
  FTabForwardStrategy := TdxPDFTabForwardNavigationStrategy.Create(Self, AController);
  FTabBackwardStrategy := TdxPDFTabBackwardNavigationStrategy.Create(Self, AController);
end;

destructor TdxPDFViewerTabNavigationController.Destroy;
begin
  FreeAndNil(FTabBackwardStrategy);
  FreeAndNil(FTabForwardStrategy);
  inherited Destroy;
end;

procedure TdxPDFViewerTabNavigationController.Clear;
begin
  FLastPageIndex := 0;
end;

function TdxPDFViewerTabNavigationController.TabBackward: TdxPDFCustomAnnotation;
begin
  Result := FTabBackwardStrategy.GetTabNext(LastPageIndex);
end;

function TdxPDFViewerTabNavigationController.TabForward: TdxPDFCustomAnnotation;
begin
  Result := FTabForwardStrategy.GetTabNext(LastPageIndex);
end;

{ TdxPDFViewerController }

procedure TdxPDFViewerController.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FSelectionController := TdxPDFViewerSelectionController.Create(Viewer);
  FSelectionController.OnMakeRectVisible := OnMakeRectVisibleHandler;
  FViewStateHistoryController := TdxPDFViewerViewStateHistoryController.Create(Viewer);
  FInteractivityController := TdxPDFViewerInteractivityController.Create(Viewer);
  FInteractiveObjectHintHelper := TdxPDFViewerHintableObjectHintHelper.Create(Viewer);
  FFieldProperties := TFieldPropertiesDictionary.Create([doOwnsValues]);
  FEditingController := TdxPDFViewerEditingController.Create(Self);
  FTabNavigationController := TdxPDFViewerTabNavigationController.Create(Self);
end;

procedure TdxPDFViewerController.DestroySubClasses;
begin
  FreeAndNil(FTabNavigationController);
  FreeAndNil(FEditingController);
  FreeAndNil(FFieldProperties);
  FreeAndNil(FInteractivityController);
  FreeAndNil(FInteractiveObjectHintHelper);
  FreeAndNil(FViewStateHistoryController);
  FreeAndNil(FSelectionController);
  inherited DestroySubClasses;
end;

procedure TdxPDFViewerController.FocusNextCell(AGoForward: Boolean);

  function GetRequiredVisibleBounds: TRect;
  var
    AViewInfo: TdxPDFViewerCustomAnnotationViewInfo;
  begin
    if TryGetViewInfo(FFocusedAnnotation, AViewInfo) then
    begin
      Result := AViewInfo.Bounds;
      Result := cxRectCenterVertically(Result, Result.Height div 3);
      Result.Width := Result.Width div 10;
    end;
  end;

var
  AAnnotation: TdxPDFCustomAnnotation;
  AAnnotationViewInfo: TdxPDFViewerCustomAnnotationViewInfo;
  ARequiredVisibleBounds: TRect;
begin
  if AGoForward then
    AAnnotation := FTabNavigationController.TabForward
  else
    AAnnotation := FTabNavigationController.TabBackward;
  if (AAnnotation <> nil) and TryGetViewInfo(AAnnotation, AAnnotationViewInfo) then
  begin
    FTabNavigationController.LastPageIndex := AAnnotation.PageIndex;
    FFocusedAnnotation := AAnnotation;
    ARequiredVisibleBounds := GetRequiredVisibleBounds;
    if not cxRectIntersect(ARequiredVisibleBounds, Viewer.ClientBounds) then
      MakeRectVisible(ARequiredVisibleBounds, vtCentered);
    Viewer.Pages[AAnnotation.PageIndex].Invalidate;
  end;
end;

procedure TdxPDFViewerController.SetPressedAndFocusedCells;
begin
  if HitTest.HitObject is TdxPDFViewerPageViewInfo then
    Exit;
  inherited SetPressedAndFocusedCells;
end;

procedure TdxPDFViewerController.DoMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  AObject: IdxPDFInteractiveObject;
begin
  FPrevHandPoint := Point(X, Y);
  Viewer.HideAllHints;
  inherited DoMouseDown(Button, Shift, X, Y);
  if not DocumentHitTest.HitAtFindPanel then
  begin
    if (Button = mbLeft) and DocumentHitTest.HitAtInteractiveObject(AObject) and AObject.AllowActivateByMouseDown then
      AObject.Execute(Shift)
    else
      if AllowSelection then
      begin
        FSelectionController.MouseDown(Button, Shift, X, Y);
        FFocusedAnnotation := nil;
      end;
    CheckHandToolCursor;
  end;
end;

procedure TdxPDFViewerController.DoMouseLeave(AControl: TControl);
begin
  inherited DoMouseLeave(AControl);
  DocumentHitTest.Clear;
  FInteractiveObjectHintHelper.HideHint;
end;

procedure TdxPDFViewerController.DoMouseMove(Shift: TShiftState; X, Y: Integer);
var
  P: TPoint;
begin
  inherited DoMouseMove(Shift, X, Y);
  P := cxPoint(X, Y);
  if IsDocumentPanning then
    OffsetContent(cxPointOffset(P, FPrevHandPoint, False))
  else
  begin
    if DocumentHitTest.HitAtHintableObject then
      TdxPDFViewerHintableObjectHintHelper(FInteractiveObjectHintHelper).EnableShowing;
    SelectionController.MouseMove(Shift, X, Y);
  end;
  FPrevHandPoint := P;
end;

procedure TdxPDFViewerController.DoMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  AIsDocumentArea: Boolean;
begin
  ResetLeftMouseButtonPressed;
  AIsDocumentArea := not DocumentHitTest.HitAtFindPanel;
  if AIsDocumentArea then
  begin
    if IsDocumentPanning then
      ViewStateHistoryController.StoreCurrentViewState(vsctScrolling)
    else
      if (Button = mbLeft) and (PressedCell <> nil) and DocumentHitTest.HitAtInteractiveObject then
        PressedCell.Execute([ssLeft])
      else
      begin
        SelectionController.MouseUp(Button, Shift, X, Y);
        FocusedAnnotation := nil;
      end;
    FTabNavigationController.LastPageIndex := DocumentHitTest.Position.PageIndex;
  end;
  PressedCell := nil;
  CheckHandToolCursor;
end;

procedure TdxPDFViewerController.KeyPress(var AKey: Char);
begin
  if not EditingController.IsEditing then
    EditingController.ShowEditByKey(AKey);
end;

function TdxPDFViewerController.GetPageScrollPosition(APage: TdxPDFViewerPage; AScrollPositionX,
  AScrollPositionY: Single): TdxPointF;
var
  ACropBox: TdxRectF;
  APosition: TdxPointF;
  AHasX, AHasY: Boolean;
begin
  Result := dxPointF(cxNullPoint);
  AHasX := TdxPDFUtils.IsDoubleValid(AScrollPositionX);
  AHasY := TdxPDFUtils.IsDoubleValid(AScrollPositionY);
  if not AHasX or not AHasY then
  begin
    APosition := dxPointF(cxPointOffset(cxPoint(Viewer.LeftPos, Viewer.TopPos),
      Viewer.Pages[Viewer.CurrentPageIndex].Bounds.TopLeft, False));
    Result := APage.ToDocumentPoint(APosition);
  end;
  if APage <> nil then
  begin
    ACropBox := TdxPDFPageAccess(APage.DocumentPage).CropBox;
    Result.X := IfThen(AHasX, AScrollPositionX - ACropBox.Left, Result.X);
    Result.Y := IfThen(AHasY, AScrollPositionY - ACropBox.Bottom, Result.Y);
  end;
end;

function TdxPDFViewerController.GetPageTopLeft(APage: TdxPDFViewerPage): TdxPointF;
begin
  Result := APage.DocumentPage.GetTopLeft(Viewer.RotationAngle);
end;

function TdxPDFViewerController.AllowSelection: Boolean;
begin
  Result := Viewer.OptionsSelection.Images or Viewer.OptionsSelection.Text;
end;

procedure TdxPDFViewerController.MakeRectVisible(const ARect: TdxRectF; AType: TdxVisibilityType = vtCentered;
  AIsTopAlignment: Boolean = False);

  procedure DoMakeRectVisible(const R: TRect);

    function GetOffset(AItemMin, AItemMax, AClientMin, AClientMax: Integer): Integer;
    begin
      Result := 0;
      if AItemMin < AClientMax then
        Result := AItemMin - AClientMin
      else
        if AItemMax > AClientMax then
        begin
          if AIsTopAlignment then
            Result := Max(AItemMax - AClientMax, AItemMin - AClientMin)
          else
            Result := Min(AItemMax - AClientMax, AItemMin - AClientMin)
        end;
    end;

  var
    AClientRect: TRect;
    P: TPoint;
  begin
    AClientRect := Viewer.GetPagesArea;
    P.X := Viewer.LeftPos + GetOffset(R.Left, R.Right, AClientRect.Left, AClientRect.Right);
    P.Y := Viewer.TopPos + GetOffset(R.Top, R.Bottom, AClientRect.Top, AClientRect.Bottom);
    Viewer.SetScrollPosition(P, Viewer.IsScrollAnimationEnabled);
  end;

var
  R: TRect;
begin
  FViewStateHistoryController.BeginUpdate;
  try
    R := ARect.DeflateToTRect;
    Viewer.LayoutCalculator.SetCurrentPageByRect(R);
    if not AIsTopAlignment then
    begin
      Viewer.BeginScrolling;
      TcxScrollingControlAccess(Viewer).MakeVisible(R, AType);
      Viewer.EndScrolling;
    end
    else
      DoMakeRectVisible(R);
  finally
    FViewStateHistoryController.EndUpdate;
  end;
  FViewStateHistoryController.StoreCurrentViewState(vsctSelecting);
end;

procedure TdxPDFViewerController.MakeSelectionRectVisible(APageIndex: Integer; const ARect: TdxRectF);

  function GetRect(const ALeft, ATop, ARight, ABottom: Double; APageIndex: Integer): TdxRectF;
  begin
    Result.TopLeft := FSelectionController.Caret.ViewData.TopLeft;
    Result.Right := Result.Left + 1;
    Result.Bottom := Result.Top - Viewer.SelectionController.Caret.ViewData.Height;
    Result := (Viewer.Pages[APageIndex] as TdxPDFViewerPage).ToViewerRect(cxRectAdjustF(Result));
    Result := cxRectOffset(Result, dxPointF(Viewer.ClientRect.TopLeft), False);
  end;

begin
  MakeRectVisible(GetRect(ARect.Left, ARect.Top, ARect.Right, ARect.Bottom, APageIndex), vtFully);
end;

procedure TdxPDFViewerController.HideEdit(AAccept: Boolean = False);
begin
  EditingController.HideEdit(AAccept);
end;

procedure TdxPDFViewerController.HideHints;
begin
  if FInteractiveObjectHintHelper <> nil then 
    FInteractiveObjectHintHelper.MouseDown;
end;

procedure TdxPDFViewerController.FocusChanged;
begin
  if Viewer.IsFocused and FEditingController.IsEditing then
    HideEdit(True);
end;

procedure TdxPDFViewerController.OffsetContent(const AOffset: TPoint);
begin
  Viewer.UpdateLeftTopPosition(cxPoint(Viewer.LeftPos - AOffset.X, Viewer.TopPos - AOffset.Y));
end;

procedure TdxPDFViewerController.ScrollPosChanged;
begin
  if not Viewer.IsScrollAnimationActive then
    ViewStateHistoryController.StoreCurrentViewState(vsctScrolling);
end;

procedure TdxPDFViewerController.ShowDocumentPosition(const ATarget: TdxPDFTarget);
begin
  FInteractivityController.ShowDocumentPosition(ATarget);
end;

procedure TdxPDFViewerController.ShowEditByMouse(AShift: TShiftState = []);
begin
  ResetLeftMouseButtonPressed;
  EditingController.ShowEditByMouse(AShift);
end;

function TdxPDFViewerController.TryGetViewInfo(AAnnotation: TdxPDFCustomAnnotation;
  out AViewInfo: TdxPDFViewerCustomAnnotationViewInfo): Boolean;
var
  AAnnotationViewInfo: TdxPDFViewerCustomAnnotationViewInfo;
  APageViewInfo: TdxPDFViewerPageViewInfo;
  I: Integer;
begin
  AViewInfo := nil;
  APageViewInfo := Viewer.ViewInfo.PageViewInfos[AAnnotation.PageIndex];
  for I := 0 to APageViewInfo.Count - 1 do
    if Safe.Cast(APageViewInfo.CellList[I], TdxPDFViewerCustomAnnotationViewInfo, AAnnotationViewInfo) and
      (AAnnotationViewInfo.Annotation = AAnnotation) then
    begin
      AViewInfo := AAnnotationViewInfo;
      Break;
    end;
  Result := AViewInfo <> nil;
end;

procedure TdxPDFViewerController.OpenAttachment(AAttachment: TdxPDFFileAttachment);
var
  AFileName: string;
begin
  if (AAttachment <> nil) and Viewer.CanOpenAttachment(AAttachment) then
  begin
    AFileName := AAttachment.FileName;
    if AFileName = '' then
      AFileName := TPath.GetRandomFileName;
    AFileName := TPath.Combine(TdxPDFDocumentAccess(Viewer.Document).Repository.FolderName, AFileName);
    DoSaveAttachment(AFileName, AAttachment);
    dxShellExecute(AFileName, SW_SHOWMAXIMIZED);
  end;
end;

procedure TdxPDFViewerController.SaveAttachment(AAttachment: TdxPDFFileAttachment);
var
  APath: string;
begin
  if (AAttachment <> nil) and Viewer.CanSaveAttachment(AAttachment) then
  begin
    APath := GetAttachmentSavingPath(AAttachment);
    if APath <> '' then
      DoSaveAttachment(APath, AAttachment);
  end;
end;

function TdxPDFViewerController.GetProperties(AClass: TcxCustomEditPropertiesClass): TcxCustomEditProperties;
begin
  if not FFieldProperties.TryGetValue(AClass, Result) then
  begin
    Result := AClass.Create(Viewer);
    FFieldProperties.AddOrSetValue(AClass, Result);
  end;
end;

function TdxPDFViewerController.GetFocusedWidgetViewInfo: TdxPDFViewerWidgetViewInfo;
var
  AAnnotationViewInfo: TdxPDFViewerCustomAnnotationViewInfo;
  AWidgetAnnotation: TdxPDFWidgetAnnotation;
begin
  if Safe.Cast(FFocusedAnnotation, TdxPDFWidgetAnnotation, AWidgetAnnotation) and
    TryGetViewInfo(AWidgetAnnotation, AAnnotationViewInfo) then
    Result := AAnnotationViewInfo as TdxPDFViewerWidgetViewInfo
  else
    Result := nil
end;

function TdxPDFViewerController.IsDocumentPanning: Boolean;
begin
  Result := Viewer.IsDocumentLoaded and Viewer.DocumentState.HandTool and LeftMouseButtonPressed;
end;

function TdxPDFViewerController.IsDocumentSelecting: Boolean;
begin
  Result := Viewer.IsDocumentLoaded and not IsDocumentPanning and LeftMouseButtonPressed;
end;

procedure TdxPDFViewerController.Rotate(AAngleDelta: Integer);
begin
  case TdxPDFUtils.NormalizeRotate(TdxPDFUtils.ConvertToIntEx(Viewer.RotationAngle) + AAngleDelta) of
    -90, 270:
      Viewer.RotationAngle := raMinus90;
    90, -270:
      Viewer.RotationAngle := raPlus90;
    -180, 180:
      Viewer.RotationAngle := ra180;
  else
    Viewer.RotationAngle := ra0;
  end;
end;

procedure TdxPDFViewerController.SetActiveAndMakeVisiblePage(APageIndex: Integer; AAnimated: Boolean);
begin
  if AAnimated then
  begin
    Viewer.DoSelectPage(APageIndex);
    Viewer.MakePageVisible(APageIndex, AAnimated);
  end
  else
    Viewer.MakeVisibleWithoutAnimation(APageIndex);
end;

procedure TdxPDFViewerController.SetScrollPosition(const APosition: TPoint; AAnimated: Boolean = False);
begin
  Viewer.SetLeftTop(APosition, AAnimated);
end;

procedure TdxPDFViewerController.ExecuteOperation(const AOperation: TdxPDFInteractiveOperation);
begin
  FInteractivityController.ExecuteOperation(AOperation);
  FocusedCell := nil;
end;

function TdxPDFViewerController.CanActivate(const P: TPoint): Boolean;
begin
  Result := inherited CanActivate(P) or LeftMouseButtonPressed;
end;

function TdxPDFViewerController.DoMouseWheel(AShift: TShiftState; AWheelDelta: Integer; const AMousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheel(AShift, AWheelDelta, AMousePos);
  if IsCtrlPressed then
  begin
    if not Viewer.IsZoomingLocked then
      HideEdit(True);
    Result := Viewer.ProcessMouseWheelMessage(AWheelDelta);
  end;
end;

function TdxPDFViewerController.GetCursor: TCursor;
begin
  DocumentHitTest.Calculate(Viewer.GetMouseCursorClientPos);
  if not DocumentHitTest.HitAtInteractiveObject and Viewer.DocumentState.HandTool then
  begin
    Result := crDefault;
    if LeftMouseButtonPressed then
      Result := crcxHandDrag
    else
      if not Viewer.IsScrollBarsArea(HitTest.HitPoint) and not cxPointIsInvalid(DocumentHitTest.HitPoint) then
        Result := crcxHand;
  end
  else
    Result := DocumentHitTest.Cursor;
end;

function TdxPDFViewerController.GetHitTest: TdxPDFViewerCellHitTest;
begin
  Result := Viewer.HitTest;
end;

function TdxPDFViewerController.GetPopupMenuClass: TComponentClass;
begin
  Result := DocumentHitTest.GetPopupMenuClass;
end;

function TdxPDFViewerController.ProcessKeyDown(AKey: Word; AShift: TShiftState): Boolean;

  function IsAltPressed(AShift: TShiftState): Boolean;
  begin
    Result := ssAlt in AShift;
  end;

  function IsCtrlShiftPressed(AShift: TShiftState): Boolean;
  begin
    Result := (ssShift in AShift) and IsCtrlPressed;
  end;

var
  AAltPressed: Boolean;
begin
  if not Viewer.Focused then
    Exit(False);
  if SelectionController.Caret.IsValid and SelectionController.KeyDown(AKey, AShift) then
    Exit(True);
  AAltPressed := IsAltPressed(AShift);
  Result := True;
  case AKey of
    VK_UP:
      if IsCtrlPressed then
        Viewer.GoToPrevPage
      else
        TdxPDFViewerAccess(Viewer).ScrollPage(psdUp);
    VK_DOWN:
      if IsCtrlPressed then
        Viewer.GoToNextPage
      else
        TdxPDFViewerAccess(Viewer).ScrollPage(psdDown);
    VK_LEFT:
      if AAltPressed then
        Viewer.GoToPrevView
      else
        if NeedHorizontalScroll then
          TdxPDFViewerAccess(Viewer).ScrollPage(psdLeft)
        else
          Viewer.GoToPrevPage;
    VK_RIGHT:
      if AAltPressed then
        Viewer.GoToNextView
      else
        if NeedHorizontalScroll then
          TdxPDFViewerAccess(Viewer).ScrollPage(psdRight)
        else
          Viewer.GoToNextPage;
    Ord('F'):
      if IsCtrlPressed then
        Viewer.ShowFindPanel;
    VK_ADD:
      if IsCtrlShiftPressed(AShift) then
        Viewer.RotateClockwise
      else
        if IsCtrlPressed then
          Viewer.ZoomIn;
    VK_SUBTRACT:
      if IsCtrlShiftPressed(AShift) then
        Viewer.RotateCounterclockwise
      else
        if IsCtrlPressed then
          Viewer.ZoomOut;
    VK_RETURN:
      Viewer.GoToNextPage;
    Ord('C'):
       if IsCtrlPressed then
         Viewer.Selection.CopyToClipboard;
    Ord('A'):
      if IsCtrlPressed then
        Viewer.Selection.SelectAll;
    Ord('P'):
      if IsCtrlPressed then
        ShowPrintDialog(Viewer);
    VK_F3:
      Viewer.FindNext;
  else
    Result := False;
  end;
end;

procedure TdxPDFViewerController.CalculateMouseButtonPressed(Shift: TShiftState; X, Y: Integer);
begin
  inherited CalculateMouseButtonPressed(Shift, X, Y);
  FLeftMouseButtonPressed := LeftMouseButtonPressed and not Viewer.FindPanel.Controller.CanActivate(cxPoint(X, Y));
end;

procedure TdxPDFViewerController.Clear;
begin
  inherited Clear;
  Viewer.BeginUpdate;
  try
    HideEdit;
    FocusedCell := nil;
    FocusedAnnotation := nil;
    Viewer.ViewInfo.ClearCells;
    FTabNavigationController.Clear;
    FSelectionController.Clear;
    FFieldProperties.Clear;
    FViewStateHistoryController.Clear;
    Viewer.DeleteCaret;
    Viewer.HandTool := False;
    Viewer.Highlights.Clear;
    Viewer.TextSearch.Clear;
    Viewer.PageCount := 0;
  finally
    Viewer.EndUpdate;
  end;
end;

function TdxPDFViewerController.GetDocumentHitTest: TdxPDFViewerDocumentHitTest;
begin
  Result := inherited HitTest as TdxPDFViewerDocumentHitTest;
end;

function TdxPDFViewerController.GetDocumentState: TdxPDFViewerDocumentState;
begin
  Result := Viewer.DocumentState;
end;

function TdxPDFViewerController.GetAttachmentSavingPath(AAttachment: TdxPDFFileAttachment): string;
var
  ASaveDialog: TSaveDialog;
  AResult: Boolean;
begin
  ASaveDialog := TdxSaveFileDialog.Create(nil);
  try
    ASaveDialog.FileName := AAttachment.FileName;
    ASaveDialog.Filter := '*.*';
    if Application.ActiveFormHandle <> 0 then
      AResult := ASaveDialog.Execute(Application.ActiveFormHandle)
    else
      AResult := ASaveDialog.Execute;
    if AResult then
      Result := ASaveDialog.FileName
    else
      Result := '';
  finally
    ASaveDialog.Free;
  end;
end;

procedure TdxPDFViewerController.DoSaveAttachment(const APath: string; AAttachment: TdxPDFFileAttachment);
var
  ADirectoryName: string;
begin
  ADirectoryName := TPath.GetDirectoryName(APath);
  if not DirectoryExists(ADirectoryName) then
    if not ForceDirectories(ADirectoryName) then
      TdxPDFUtils.RaiseException('Cannot create temp directory');
  TdxPDFUtils.SaveToFile(APath, AAttachment.Data);
end;

function TdxPDFViewerController.NeedHorizontalScroll: Boolean;
begin
  Result := Viewer.ZoomFactor > 100;
end;

procedure TdxPDFViewerController.CheckHandToolCursor;
begin
  if IsDocumentPanning then
    Viewer.UpdateCursor;
end;

procedure TdxPDFViewerController.OnMakeRectVisibleHandler(APageIndex: Integer; const ARect: TdxRectF);
var
  R: TdxRectF;
begin
  R := (Viewer.Pages[Max(APageIndex, 0)] as TdxPDFViewerPage).ToViewerRect(cxRectAdjustF(ARect));
  if not Viewer.IsRectVisible(R) then
    MakeRectVisible(cxRectOffset(R, dxPointF(Viewer.ClientRect.TopLeft), False));
end;

{ TdxPDFViewerCellHitTest }

procedure TdxPDFViewerCellHitTest.Clear;
begin
  inherited Clear;
  FHitCode := 0;
end;

procedure TdxPDFViewerCellHitTest.DoCalculate(const AHitPoint: TPoint);
begin
  inherited DoCalculate(AHitPoint);
  FHitObject := nil;
end;

function TdxPDFViewerCellHitTest.DoGetCursor: TCursor;
begin
  Result := crDefault;
end;

function TdxPDFViewerCellHitTest.GetCursor: TCursor;
begin
  if Viewer.IsScrollBarsArea(HitPoint) then
    Result := crDefault
  else
    Result := DoGetCursor;
end;

function TdxPDFViewerCellHitTest.GetHitCode(ACode: Integer): Boolean;
begin
  Result := FHitCode and ACode <> 0;
end;

procedure TdxPDFViewerCellHitTest.SetHitCode(ACode: Integer; AValue: Boolean);
begin
  if AValue then
    FHitCode := FHitCode or ACode
  else
    FHitCode := FHitCode and not ACode;
end;

{ TdxPDFViewerCellViewInfo }

constructor TdxPDFViewerCellViewInfo.Create(AController: TdxPDFViewerContainerController);
begin
  inherited Create;
  FController := AController;
end;

procedure TdxPDFViewerCellViewInfo.AfterConstruction;
begin
  inherited AfterConstruction;
  CreateSubClasses;
end;

procedure TdxPDFViewerCellViewInfo.BeforeDestruction;
begin
  inherited BeforeDestruction;
  DestroySubClasses;
end;

procedure TdxPDFViewerCellViewInfo.CreateSubClasses;
begin
  // do nothing
end;

procedure TdxPDFViewerCellViewInfo.DestroySubClasses;
begin
  Controller.CellRemoving(Self);
end;

function TdxPDFViewerCellViewInfo.CalculateHitTest(AHitTest: TdxPDFViewerCellHitTest): Boolean;
begin
  Result := Visible and cxRectPtIn(Bounds, AHitTest.HitPoint);
  if Result then
    AHitTest.HitObject := Self;
end;

function TdxPDFViewerCellViewInfo.CanDrawContent: Boolean;
begin
  Result := Visible;
end;

function TdxPDFViewerCellViewInfo.CanDrawFocusRect: Boolean;
begin
  Result := CanFocus;
end;

function TdxPDFViewerCellViewInfo.CanFocus: Boolean;
begin
  Result := False;
end;

function TdxPDFViewerCellViewInfo.IsFocused: Boolean;
begin
  Result := Self = Controller.FocusedCell;
end;

function TdxPDFViewerCellViewInfo.IsHot: Boolean;
begin
  Result := Self = Controller.HotCell;
end;

function TdxPDFViewerCellViewInfo.IsPressed: Boolean;
begin
  Result := Self = Controller.PressedCell;
end;

function TdxPDFViewerCellViewInfo.GetClipRect: TRect;
begin
  Result := Bounds;
end;

function TdxPDFViewerCellViewInfo.GetFont: TFont;
begin
  Result := Viewer.Font;
end;

function TdxPDFViewerCellViewInfo.GetVisible: Boolean;
begin
  Result := not cxRectIsEmpty(Bounds);
end;

function TdxPDFViewerCellViewInfo.MeasureHeight: Integer;
begin
  Result := 0;
end;

function TdxPDFViewerCellViewInfo.MeasureWidth: Integer;
begin
  Result := 0;
end;

procedure TdxPDFViewerCellViewInfo.Calculate;
begin
  DoCalculate;
end;

procedure TdxPDFViewerCellViewInfo.DoCalculate;
begin
  // do nothing
end;

procedure TdxPDFViewerCellViewInfo.DrawBackground(ACanvas: TcxCanvas);
begin
  // do nothing
end;

procedure TdxPDFViewerCellViewInfo.DrawChildren(ACanvas: TcxCanvas);
begin
  // do nothing
end;

procedure TdxPDFViewerCellViewInfo.DrawContent(ACanvas: TcxCanvas);
begin
  // do nothing
end;

procedure TdxPDFViewerCellViewInfo.DrawFocusRect(ACanvas: TcxCanvas);
begin
  if IsFocused and CanDrawFocusRect and Painter.LookAndFeelPainter.SupportsNativeFocusRect then
    ACanvas.DrawFocusRect(Bounds);
end;

procedure TdxPDFViewerCellViewInfo.Execute(AShift: TShiftState = []);
begin
  // do nothing
end;

procedure TdxPDFViewerCellViewInfo.Invalidate;
begin
  Viewer.InvalidateRect(Bounds, True);
end;

procedure TdxPDFViewerCellViewInfo.UpdateState;
begin
// do nothing
end;

function TdxPDFViewerCellViewInfo.ApplyScaleFactor(AValue: Integer): Integer;
begin
  Result := Painter.ScaleFactor.Apply(AValue);
end;

function TdxPDFViewerCellViewInfo.ApplyScaleFactor(AValue: TSize): TSize;
begin
  Result := Painter.ScaleFactor.Apply(AValue);
end;

function TdxPDFViewerCellViewInfo.ApplyScaleFactor(AValue: TRect): TRect;
begin
  Result := Painter.ScaleFactor.Apply(AValue);
end;

procedure TdxPDFViewerCellViewInfo.Draw(ACanvas: TcxCanvas; AForce: Boolean = False);
begin
  if ACanvas.RectVisible(Bounds) and CanDrawContent or AForce then
  begin
    ACanvas.SaveClipRegion;
    try
      ACanvas.IntersectClipRect(GetClipRect);
      DrawBackground(ACanvas);
      DrawContent(ACanvas);
      DrawChildren(ACanvas);
      DrawFocusRect(ACanvas);
    finally
      ACanvas.RestoreClipRegion;
    end;
  end;
end;

procedure TdxPDFViewerCellViewInfo.Offset(const AOffset: TPoint);
begin
  FBounds := cxRectOffset(FBounds, AOffset.X, AOffset.Y);
end;

function TdxPDFViewerCellViewInfo.GetPainter: TdxPDFViewerPainter;
begin
  Result := Viewer.Painter;
end;

function TdxPDFViewerCellViewInfo.GetScaleFactor: TdxScaleFactor;
begin
  Result := Viewer.ScaleFactor;
end;

function TdxPDFViewerCellViewInfo.GetViewer: TdxPDFCustomViewer;
begin
  Result := Controller.Viewer;
end;

procedure TdxPDFViewerCellViewInfo.SetBounds(const ABounds: TRect);
begin
  FBounds := ABounds;
  Calculate;
end;

{ TdxPDFViewerViewInfoList }

function TdxPDFViewerViewInfoList.CalculateHitTest(AHitTest: TdxPDFViewerCellHitTest): Boolean;
var
  I: Integer;
  AViewInfo: TdxPDFViewerCellViewInfo;
begin
  Result := False;
  for I := Count - 1 downto 0 do
  begin
    AViewInfo := Items[I];
    if AViewInfo.CalculateHitTest(AHitTest) then
    begin
      Result := True;
      Break;
    end;
  end;
end;

function TdxPDFViewerViewInfoList.MaxMeasureHeight: Integer;
var
  AViewInfo: TdxPDFViewerCellViewInfo;
begin
  Result := 0;
  for AViewInfo in Self do
    Result := Max(Result, AViewInfo.MeasureHeight);
end;

procedure TdxPDFViewerViewInfoList.Calculate;
var
  AViewInfo: TdxPDFViewerCellViewInfo;
begin
  for AViewInfo in Self do
    AViewInfo.Calculate;
end;

procedure TdxPDFViewerViewInfoList.Draw(ACanvas: TcxCanvas);
var
  AViewInfo: TdxPDFViewerCellViewInfo;
begin
  for AViewInfo in Self do
    AViewInfo.Draw(ACanvas);
end;

procedure TdxPDFViewerViewInfoList.Offset(const AOffset: TPoint);
var
  AViewInfo: TdxPDFViewerCellViewInfo;
begin
  for AViewInfo in Self do
    AViewInfo.Offset(AOffset);
end;

procedure TdxPDFViewerViewInfoList.UpdateState;
var
  AViewInfo: TdxPDFViewerCellViewInfo;
begin
  for AViewInfo in Self do
    AViewInfo.UpdateState;
end;

{ TdxPDFViewerContainerViewInfo }

class function TdxPDFViewerContainerViewInfo.AlignToLeftSide(AViewInfo: TdxPDFViewerCellViewInfo; AIndent: Integer;
  var R: TRect): Boolean;
var
  ARect: TRect;
begin
  Result := AViewInfo <> nil;
  if Result then
  begin
    ARect := cxRectSetLeft(R, R.Left, AViewInfo.MeasureWidth);
    AViewInfo.Bounds := cxRectCenterVertically(ARect, AViewInfo.MeasureHeight);
    R.Left := AViewInfo.Bounds.Right;
    Inc(R.Left, AIndent);
  end;
end;

class function TdxPDFViewerContainerViewInfo.AlignToRightSide(AViewInfo: TdxPDFViewerCellViewInfo; AIndent: Integer;
  var R: TRect): Boolean;
var
  ARect: TRect;
begin
  Result := AViewInfo <> nil;
  if Result then
  begin
    ARect := cxRectSetRight(R, R.Right, AViewInfo.MeasureWidth);
    AViewInfo.Bounds := cxRectCenterVertically(ARect, AViewInfo.MeasureHeight);
    R.Right := AViewInfo.Bounds.Left;
    Dec(R.Right, AIndent);
  end;
end;

function TdxPDFViewerContainerViewInfo.CalculateHitTest(AHitTest: TdxPDFViewerCellHitTest): Boolean;
begin
  Result := inherited CalculateHitTest(AHitTest);
  if Result then
    CellList.CalculateHitTest(AHitTest);
end;

function TdxPDFViewerContainerViewInfo.MeasureHeight: Integer;
begin
  Result := CellList.MaxMeasureHeight + cxMarginsHeight(ContentMargins);
end;

procedure TdxPDFViewerContainerViewInfo.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FCellList := TdxPDFViewerViewInfoList.Create;
  CreateCells;
end;

procedure TdxPDFViewerContainerViewInfo.DestroySubClasses;
begin
  ClearCells;
  FreeAndNil(FCellList);
  inherited DestroySubClasses;
end;

procedure TdxPDFViewerContainerViewInfo.DrawChildren(ACanvas: TcxCanvas);
begin
  CellList.Draw(ACanvas);
end;

procedure TdxPDFViewerContainerViewInfo.Offset(const AOffset: TPoint);
begin
  inherited Offset(AOffset);
  CellList.Offset(AOffset);
end;

procedure TdxPDFViewerContainerViewInfo.UpdateState;
begin
  inherited UpdateState;
  CellList.UpdateState;
end;

function TdxPDFViewerContainerViewInfo.GetContentMargins: TRect;
begin
  Result := cxNullRect;
end;

function TdxPDFViewerContainerViewInfo.GetIndentBetweenElements: Integer;
begin
  Result := 0;
end;

function TdxPDFViewerContainerViewInfo.NeedRecreateCells(AType: TdxChangeType): Boolean;
begin
  Result := AType = ctHard;
end;

procedure TdxPDFViewerContainerViewInfo.DoCalculate;
var
  I: Integer;
begin
  inherited DoCalculate;
  if not cxRectIsEmpty(Bounds) then
    CalculateContent
  else
    for I := 0 to CellList.Count - 1 do
      SetEmptyBounds(CellList[I]);
  UpdateState;
end;

procedure TdxPDFViewerContainerViewInfo.Calculate(AType: TdxChangeType; const ARect: TRect);
var
  ABounds: TRect;
begin
  if not Viewer.CanCalculate then
    Exit;
  RecreateCells(AType);
  CalculateBounds(ARect, ABounds);
  Bounds := ABounds;
end;

procedure TdxPDFViewerContainerViewInfo.CalculateBounds(const ARect: TRect; out ABounds: TRect);
begin
  ABounds := ARect;
end;

procedure TdxPDFViewerContainerViewInfo.CalculateContent;
begin
// do nothing
end;

procedure TdxPDFViewerContainerViewInfo.ClearCells;
begin
  CellList.Clear;
end;

procedure TdxPDFViewerContainerViewInfo.CreateCells;
begin
// do nothing
end;

procedure TdxPDFViewerContainerViewInfo.PopulateTabOrders(ACellList: TdxPDFViewerViewInfoList);
begin
  // do nothing
end;

procedure TdxPDFViewerContainerViewInfo.SetEmptyBounds(AViewInfo: TdxPDFViewerCellViewInfo);
begin
  if AViewInfo <> nil then
    AViewInfo.Bounds := cxNullRect;
end;

function TdxPDFViewerContainerViewInfo.AddCell(ACellClass: TdxPDFViewerCellViewInfoClass): TdxPDFViewerCellViewInfo;
begin
  Result := AddCell(ACellClass, Controller);
end;

function TdxPDFViewerContainerViewInfo.AddCell(ACellClass: TdxPDFViewerCellViewInfoClass;
  AController: TdxPDFViewerContainerController): TdxPDFViewerCellViewInfo;
begin
  Result := ACellClass.Create(AController);
  CellList.Add(Result);
end;

function TdxPDFViewerContainerViewInfo.AlignToTopClientSide(AViewInfo: TdxPDFViewerCellViewInfo; var R: TRect): Boolean;
var
  ARect: TRect;
begin
  Result := AViewInfo <> nil;
  if Result then
  begin
    ARect := cxRectSetTop(R, R.Top, AViewInfo.MeasureHeight);
    AViewInfo.Bounds := cxRectCenterHorizontally(ARect, ARect.Width);
    R.Top := AViewInfo.Bounds.Bottom;
    Inc(R.Top, IndentBetweenElements);
  end;
end;

function TdxPDFViewerContainerViewInfo.AlignToLeftSide(AViewInfo: TdxPDFViewerCellViewInfo;
  var R: TRect): Boolean;
begin
  Result := AlignToLeftSide(AViewInfo, IndentBetweenElements, R);
end;

function TdxPDFViewerContainerViewInfo.AlignToRightSide(AViewInfo: TdxPDFViewerCellViewInfo; var R: TRect): Boolean;
begin
  Result := AlignToRightSide(AViewInfo, IndentBetweenElements, R);
end;

function TdxPDFViewerContainerViewInfo.GetContentBounds: TRect;
begin
  Result := cxRectContent(Bounds, ContentMargins);
end;

procedure TdxPDFViewerContainerViewInfo.AddTabOrder(ACell: TdxPDFViewerCellViewInfo; AList: TdxPDFViewerViewInfoList);
begin
  if (ACell <> nil) and ACell.Visible then
    AList.Add(ACell);
end;

procedure TdxPDFViewerContainerViewInfo.RecreateCells(AType: TdxChangeType);
begin
  if NeedRecreateCells(AType) then
  begin
    ClearCells;
    CreateCells;
  end;
end;

function TdxPDFViewerContainerViewInfo.GetCount: Integer;
begin
  Result := CellList.Count;
end;

{ TdxPDFViewerDocumentObjectViewInfo }

constructor TdxPDFViewerDocumentObjectViewInfo.Create(AController: TdxPDFViewerContainerController; APageIndex: Integer;
  AObject: TObject);
begin
  inherited Create(AController);
  FObject := AObject;
  FPageIndex := APageIndex;
end;

destructor TdxPDFViewerDocumentObjectViewInfo.Destroy;
begin
  inherited Destroy;
end;

procedure TdxPDFViewerDocumentObjectViewInfo.DoCalculate;
var
  R: TdxRectF;
begin
  inherited DoCalculate;
  R := GetPageRect;
  FBounds := ToViewerRect(R);
  FClientBounds := ToPageRect(R);
end;

function TdxPDFViewerDocumentObjectViewInfo.GetCursor: TCursor;
begin
  Result := crDefault;
end;

function TdxPDFViewerDocumentObjectViewInfo.GetHint: string;
begin
  Result := '';
end;

function TdxPDFViewerDocumentObjectViewInfo.ToPageRect(const R: TdxRectF): TRect;
begin
  Result := Page.ToPageRect(R).DeflateToTRect;
end;

function TdxPDFViewerDocumentObjectViewInfo.ToViewerRect(const R: TdxRectF): TRect;
begin
  Result := Page.ToViewerRect(R).DeflateToTRect
end;

function TdxPDFViewerDocumentObjectViewInfo.ToViewerEditRect(const R: TdxRectF): TRect;
begin
  Result := Page.ToViewerRect(R).InflateToTRect;
end;

function TdxPDFViewerDocumentObjectViewInfo.GetMousePos: TPoint;
begin
  if Viewer.HandleAllocated and not Viewer.IsDestroying then
    Result := Viewer.ScreenToClient(GetMouseCursorPos)
  else
    Result := cxInvisiblePoint;
end;

function TdxPDFViewerDocumentObjectViewInfo.GetPage: TdxPDFViewerPage;
begin
  Result := TdxPDFViewerPage(Viewer.Pages[FPageIndex]);
end;

{ TdxPDFViewerCustomAnnotationViewInfo }

function TdxPDFViewerCustomAnnotationViewInfo.GetHitCode: Integer;
begin
  Result := hcAnnotationObject;
end;

function TdxPDFViewerCustomAnnotationViewInfo.GetPageRect: TdxRectF;
begin
  Result := Annotation.PageRect.Rect;
end;

function TdxPDFViewerCustomAnnotationViewInfo.IsFocused: Boolean;
begin
  Result := Viewer.ViewerController.FocusedAnnotation = Annotation;
end;

procedure TdxPDFViewerCustomAnnotationViewInfo.Execute(AShift: TShiftState = []);
begin
  Viewer.ViewerController.FocusedAnnotation := Annotation;
end;

function TdxPDFViewerCustomAnnotationViewInfo.GetAnnotation: TdxPDFCustomAnnotation;
begin
  Result := FObject as TdxPDFCustomAnnotation;
end;

function TdxPDFViewerCustomAnnotationViewInfo.GetBounds: TRect;
begin
  Result := Bounds;
end;

{ TdxPDFViewerImageViewInfo }

function TdxPDFViewerImageViewInfo.CanFocus: Boolean;
begin
  Result := False;
end;

constructor TdxPDFViewerImageViewInfo.Create(AController: TdxPDFViewerContainerController; APageIndex: Integer;
  AObject: TObject);
var
  AImage: TdxPDFImage;
begin
  inherited Create(AController, APageIndex, nil);
  AImage := AObject as TdxPDFImage;
  FID := TdxPDFImageAccess(AImage).GUID;
  FImageBounds := TdxPDFPageRect.Create(APageIndex, TdxPDFImageAccess(AImage).Bounds);
end;

function TdxPDFViewerImageViewInfo.GetHitCode: Integer;
begin
  Result := hcImage;
end;

function TdxPDFViewerImageViewInfo.GetPageRect: TdxRectF;
begin
  Result := FImageBounds.Rect;
end;

{ TdxPDFViewerWidgetViewInfo }

function TdxPDFViewerWidgetViewInfo.IsMultiLine: Boolean;
begin
  Result := False;
end;

function TdxPDFViewerWidgetViewInfo.TryGetProperties(out AProperties: TcxCustomEditProperties): Boolean;
begin
  AProperties := GetProperties;
  Result := AProperties <> nil;
end;

function TdxPDFViewerWidgetViewInfo.CanDrawFocusRect: Boolean;
begin
  Result := inherited CanDrawFocusRect and Viewer.OptionsForm.FocusRect and not Viewer.ViewerController.EditingController.IsEditing;
end;

function TdxPDFViewerWidgetViewInfo.CanFocus: Boolean;
begin
  Result := True;
end;

function TdxPDFViewerWidgetViewInfo.GetAnnotation: TdxPDFCustomAnnotation;
begin
  Result := TdxPDFCustomWidgetAccess(Widget).Annotation;
end;

function TdxPDFViewerWidgetViewInfo.GetHint: string;
begin
  Result := TdxPDFCustomWidgetAccess(Widget).Hint;
end;

function TdxPDFViewerWidgetViewInfo.AllowActivateByMouseDown: Boolean;
begin
  Result := True;
end;

function TdxPDFViewerWidgetViewInfo.GetAction: TdxPDFInteractiveOperation;
begin
  Result := Result.Invalid;
end;

function TdxPDFViewerWidgetViewInfo.GetEditValue: Variant;
begin
  Result := Null;
end;

procedure TdxPDFViewerWidgetViewInfo.InitProperties(AProperties: TcxCustomEditProperties);
const
  HorzAlignmentMap: array[TdxPDFTextJustify] of TcxEditHorzAlignment = (taLeftJustify, taCenter, taRightJustify);
begin
  AProperties.ReadOnly := Field.ReadOnly;
  AProperties.Alignment.Horz := HorzAlignmentMap[TdxPDFCustomWidgetAccess(Widget).TextJustify];
  AProperties.UseLeftAlignmentOnEditing := AProperties.Alignment.Horz = taLeftJustify;
end;

function TdxPDFViewerWidgetViewInfo.GetOriginalBorderWidth: Single;
begin
  Result := TdxPDFCustomWidgetAccess(Widget).BorderWidth;
end;

function TdxPDFViewerWidgetViewInfo.GetOriginalFontSize: Single;
begin
  Result := TdxPDFCustomWidgetAccess(Widget).FontSize;
end;

function TdxPDFViewerWidgetViewInfo.GetProperties: TcxCustomEditProperties;
var
  AClass: TcxCustomEditPropertiesClass;
begin
  Result := nil;
  AClass := GetPropertiesClass;
  if AClass = nil then
    Exit;
  Result := (Controller as TdxPDFViewerController).GetProperties(AClass);
  if Result <> nil then
  begin
    Result.BeginUpdate;
    try
      InitProperties(Result);
    finally
      Result.EndUpdate;
    end;
  end;
end;

function TdxPDFViewerWidgetViewInfo.GetScaledFontSize: Integer;
begin
  Result := Round(GetOriginalFontSize * Viewer.DocumentToViewerFactor.X * Viewer.DocumentScaleFactor.X);
end;

function TdxPDFViewerWidgetViewInfo.GetWidget: TdxPDFCustomWidget;
begin
  Result := FObject as TdxPDFCustomWidget;
end;

function TdxPDFViewerWidgetViewInfo.UseWindowRegion(out ARegion: TcxRegion): Boolean;

  function ToEditBounds(const AIntersection: TRect): TRect;
  begin
    Result := cxRectOffset(AIntersection, EditBounds.TopLeft, False);
  end;

var
  AIntersection: TRect;
begin
  cxRectIntersect(AIntersection, EditBounds, Viewer.ClientBounds);
  Result := not AIntersection.IsEmpty;
  if Result then
  begin
    ARegion := TcxRegion.Create(ToEditBounds(AIntersection));
    if Viewer.IsFindPanelVisible then
    begin
      cxRectIntersect(AIntersection, AIntersection, Viewer.FindPanel.ViewInfo.Bounds);
      if not AIntersection.IsEmpty then
        ARegion.Combine(ToEditBounds(AIntersection), roSubtract);
    end;
  end;
end;

procedure TdxPDFViewerWidgetViewInfo.InitFont(AFont: TFont);
var
  AWidget: TdxPDFCustomWidgetAccess;
begin
  AWidget := TdxPDFCustomWidgetAccess(Widget);
  AFont.Name := AWidget.FontName;
  if AWidget.FontBold then
    AFont.Style := AFont.Style + [fsBold];
  if AWidget.FontItalic then
    AFont.Style := AFont.Style + [fsItalic];
end;

procedure TdxPDFViewerWidgetViewInfo.UpdateEditFontSize(AEdit: TcxCustomEdit);
begin
// nothing to do
end;

function TdxPDFViewerWidgetViewInfo.GetHitCode: Integer;
begin
  Result := hcField;
end;

function TdxPDFViewerWidgetViewInfo.GetPageRect: TdxRectF;
begin
  Result := Widget.Bounds.Rect;
end;

procedure TdxPDFViewerWidgetViewInfo.DoCalculate;
var
  ABounds: TdxRectF;
  ABorderWidth: Single;
begin
  inherited DoCalculate;
  ABounds := GetPageRect;
  FBounds := ToViewerEditRect(ABounds);

  ABorderWidth := GetOriginalBorderWidth;
  FEditBounds := ToViewerEditRect(cxRectInflate(ABounds, -ABorderWidth, ABorderWidth));
end;

procedure TdxPDFViewerWidgetViewInfo.DrawFocusRect(ACanvas: TcxCanvas);
begin
  if Viewer.OptionsForm.FocusRect then
    inherited DrawFocusRect(ACanvas);
end;

procedure TdxPDFViewerWidgetViewInfo.Execute(AShift: TShiftState = []);
begin
  inherited Execute(AShift);
  Viewer.ViewerController.ShowEditByMouse(AShift);
end;

procedure TdxPDFViewerWidgetViewInfo.Offset(const AOffset: TPoint);
begin
  inherited Offset(AOffset);
  FEditBounds := cxRectOffset(FEditBounds, AOffset.X, AOffset.Y);
end;

function TdxPDFViewerWidgetViewInfo.NeedExtraSymbolWidthForEditor: Boolean;
begin
  Result := False;
end;

function TdxPDFViewerWidgetViewInfo.GetActualColor(AColor: TColor): TColor;
begin
  Result := IfThen(AColor <> clNone, AColor, clWhite);
end;

function TdxPDFViewerWidgetViewInfo.GetBackgroundColor: TColor;
begin
  Result := GetActualColor(TdxPDFCustomWidgetAccess(Widget).BackgroundColor);
end;

function TdxPDFViewerWidgetViewInfo.GetTextColor: TColor;
begin
  Result := GetActualColor(TdxPDFCustomWidgetAccess(Widget).FontColor);
end;

function TdxPDFViewerWidgetViewInfo.GetViewerDocumentScaleFactor: Single;
begin
  Result := Viewer.DocumentScaleFactor.X;
end;

function TdxPDFViewerWidgetViewInfo.GetCanvas: TcxCanvas;
begin
  Result := Viewer.ActiveCanvas;
end;

function TdxPDFViewerWidgetViewInfo.GetField: TdxPDFCustomField;
begin
  Result := TdxPDFCustomWidgetAccess(Widget).Field;
end;

function TdxPDFViewerWidgetViewInfo.GetFieldType: TdxPDFInteractiveFormFieldType;
begin
  Result := Field.FieldType;
end;

function TdxPDFViewerWidgetViewInfo.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := nil;
end;

function TdxPDFViewerWidgetViewInfo.GetRotatedWidgetCursor(ACursor: TCursor): TCursor;
begin
  if not IsRotated then
    Result := ACursor
  else
    Result := crDefault;
end;

function TdxPDFViewerWidgetViewInfo.IsRotated: Boolean;
begin
  Result := Viewer.DocumentState.RotationAngle <> ra0;
end;

procedure TdxPDFViewerWidgetViewInfo.InitStyle(AStyle: TcxCustomEditStyle);
begin
  AStyle.LookAndFeel.NativeStyle := True;
  AStyle.Color := BackgroundColor;
  AStyle.TextColor := TextColor;
  InitFont(AStyle.Font);
end;

procedure TdxPDFViewerWidgetViewInfo.SetEditValue(const AValue: Variant);
begin
  // do nothing
end;

{ TdxPDFViewerPageViewInfo }

constructor TdxPDFViewerPageViewInfo.Create(AController: TdxPDFViewerContainerController; APageIndex: Integer);
begin
  FPageIndex := APageIndex;
  inherited Create(AController);
end;

procedure TdxPDFViewerPageViewInfo.CalculateContent;
begin
  CellList.Calculate;
end;

procedure TdxPDFViewerPageViewInfo.CreateCells;
var
  AContentList: TdxFastObjectList;
  I: Integer;
begin
  inherited CreateCells;
  AContentList := Viewer.DocumentState.Content[FPageIndex];
  for I := 0 to AContentList.Count - 1 do
    CreateObjectViewInfo(AContentList[I]);
end;

procedure TdxPDFViewerPageViewInfo.PopulateTabOrders(ACellList: TdxPDFViewerViewInfoList);
var
  ACell: TdxPDFViewerCellViewInfo;
  I: Integer;
begin
  for I := 0 to CellList.Count - 1 do
  begin
    ACell := CellList[I];
    if ACell.CanFocus then
      ACellList.Add(ACell);
  end;
end;

procedure TdxPDFViewerPageViewInfo.SetBounds(const ABounds: TRect);
var
  ASize: TSize;
begin
  if not cxRectIsEqual(FBounds, ABounds) then
  begin
    ASize := FBounds.Size;
    FBounds := ABounds;
    Calculate;
  end;
end;

function TdxPDFViewerPageViewInfo.TryCreateWidgetViewInfo(AObject: TObject): Boolean;
var
  AClass: TdxPDFViewerDocumentObjectViewInfoClass;
  AWidget: TdxPDFCustomWidget;
begin
  Result := Viewer.OptionsForm.AllowEdit and (AObject is TdxPDFWidgetAnnotation) and
    Viewer.DocumentState.AnnotationWidgetMap.TryGetValue(AObject, AWidget) and
    dxgPDFViewerDocumentObjectViewInfoDictionary.TryGetValue(TdxPDFCustomWidgetAccess(AWidget).Field, AClass) and
    TdxPDFCustomWidgetAccess(AWidget).Visible;
  if Result then
    AddCellViewInfo(AClass, AWidget);
end;

procedure TdxPDFViewerPageViewInfo.AddCellViewInfo(AClass: TdxPDFViewerDocumentObjectViewInfoClass; AObject: TObject);
begin
  CellList.Add(AClass.Create(Controller, FPageIndex, AObject))
end;

procedure TdxPDFViewerPageViewInfo.CreateObjectViewInfo(AObject: TObject);
var
  AClass: TdxPDFViewerDocumentObjectViewInfoClass;
begin
  if not TryCreateWidgetViewInfo(AObject) and dxgPDFViewerDocumentObjectViewInfoDictionary.TryGetValue(AObject, AClass) then
    AddCellViewInfo(AClass, AObject);
end;

{ TdxPDFViewerPagesViewInfo }

function TdxPDFViewerPagesViewInfo.TryGetViewInfo(APageIndex: Integer; out AViewInfo: TdxPDFViewerPageViewInfo): Boolean;
begin
  Result := FItems.TryGetValue(APageIndex, AViewInfo);
end;

function TdxPDFViewerPagesViewInfo.CanFocus: Boolean;
begin
  Result := True;
end;

procedure TdxPDFViewerPagesViewInfo.CalculateContent;
var
  ABounds: TRect;
  AViewInfo: TdxPDFViewerPageViewInfo;
  I: Integer;
begin
  for I := 0 to Viewer.PageCount - 1 do
  begin
    ABounds := Viewer.Pages[I].Bounds;
    if Viewer.IsPageVisible(I) then
      PageViewInfos[I].Bounds := ABounds
    else
      if TryGetViewInfo(I, AViewInfo) then
        AViewInfo.Bounds := ABounds;
  end;
  UpdateEditPosition;
  UpdateEditFontSize;
end;

procedure TdxPDFViewerPagesViewInfo.ClearCells;
begin
  if Viewer.HitTest <> nil then
    Viewer.HitTest.Clear;
  FItems.Clear;
  inherited ClearCells;
end;

procedure TdxPDFViewerPagesViewInfo.CreateSubClasses;
begin
  FItems := TdxPDFIntegerObjectDictionary<TdxPDFViewerPageViewInfo>.Create;
  inherited CreateSubClasses;
end;

procedure TdxPDFViewerPagesViewInfo.DestroySubClasses;
begin
  inherited DestroySubClasses;
  FreeAndNil(FItems);
end;

procedure TdxPDFViewerPagesViewInfo.Offset(const AOffset: TPoint);
begin
  CalculateContent;
end;

function TdxPDFViewerPagesViewInfo.NeedRecreateCells(AType: TdxChangeType): Boolean;
begin
  Result := (FLockCount = 0) and inherited NeedRecreateCells(AType);
  if Result then
    Viewer.ViewerController.HideEdit;
end;

procedure TdxPDFViewerPagesViewInfo.LockRecreateCells;
begin
  Inc(FLockCount);
end;

procedure TdxPDFViewerPagesViewInfo.UnLockRecreateCells;
begin
  Dec(FLockCount);
end;

function TdxPDFViewerPagesViewInfo.AddPageViewInfo(APageIndex: Integer): TdxPDFViewerPageViewInfo;
begin
  Result := TdxPDFViewerPageViewInfo.Create(Controller, APageIndex);
  FItems.Add(APageIndex, Result);
  CellList.Add(Result);
end;

function TdxPDFViewerPagesViewInfo.GetController: TdxPDFViewerController;
begin
  Result := inherited Controller as TdxPDFViewerController;
end;

function TdxPDFViewerPagesViewInfo.GetPageViewInfo(APageIndex: Integer): TdxPDFViewerPageViewInfo;
begin
  if not TryGetViewInfo(APageIndex, Result) then
  begin
    Result := AddPageViewInfo(APageIndex);
    Result.Bounds := Viewer.Pages[APageIndex].Bounds;
  end;
end;

procedure TdxPDFViewerPagesViewInfo.UpdateEditPosition;
begin
  Controller.EditingController.UpdateEditPosition;
end;

procedure TdxPDFViewerPagesViewInfo.UpdateEditFontSize;
begin
  Controller.EditingController.UpdateEditFontSize;
end;

{ TdxPDFViewerCaptionViewInfo }

function TdxPDFViewerCaptionViewInfo.CanDrawContent: Boolean;
begin
  Result := True;
end;

function TdxPDFViewerCaptionViewInfo.MeasureHeight: Integer;
begin
  Result := cxTextHeight(Font);
end;

function TdxPDFViewerCaptionViewInfo.MeasureWidth: Integer;
begin
  Result := cxTextWidth(Font, Text) + Painter.ScaleFactor.Apply(cxTextOffset * 2);
end;

procedure TdxPDFViewerCaptionViewInfo.DrawContent(ACanvas: TcxCanvas);
begin
  ACanvas.SaveState;
  try
    PrepareCanvas(ACanvas);
    ACanvas.DrawTexT(Text, Bounds, GetTextAlignment, vaCenter, False, True);
  finally
    ACanvas.RestoreState;
  end;
end;

function TdxPDFViewerCaptionViewInfo.GetPainterTextColor: TColor;
begin
  Result := Painter.TitleTextColor;
end;

function TdxPDFViewerCaptionViewInfo.GetText: string;
begin
  Result := cxGetResourceString(@sdxPDFViewerFindPanelFindCaption);
end;

function TdxPDFViewerCaptionViewInfo.GetTextAlignment: TAlignment;
begin
  Result := taCenter;
end;

procedure TdxPDFViewerCaptionViewInfo.PrepareCanvas(ACanvas: TcxCanvas);
begin
  ACanvas.Font := Font;
  ACanvas.Font.Color := cxGetActualColor(GetPainterTextColor, clWindowText);
end;

{ TdxPDFViewerButtonViewInfo }

constructor TdxPDFViewerButtonViewInfo.Create(AController: TdxPDFViewerContainerController);
begin
  inherited Create(AController);
  FFadingHelper := TdxPDFViewerButtonFadingHelper.Create(Self);
  FGlyph := TdxSmartGlyph.Create;
  FCaption := GetDefaultCaption;
  FState := cxbsNormal;
end;

destructor TdxPDFViewerButtonViewInfo.Destroy;
begin
  FreeAndNil(FGlyph);
  FreeAndNil(FFadingHelper);
  inherited Destroy;
end;

function TdxPDFViewerButtonViewInfo.CanFocus: Boolean;
begin
  Result := Visible and IsEnabled;
end;

function TdxPDFViewerButtonViewInfo.MeasureHeight: Integer;
var
  AActualMeasureWidth: Integer;
begin
  Result := cxTextHeight(Font) + ApplyScaleFactor(cxMarginsHeight(Margins));
  AActualMeasureWidth := MeasureWidth;
  if GlyphSize.cx > AActualMeasureWidth then
    Result := Trunc(Result * (AActualMeasureWidth / GlyphSize.cx));
end;

function TdxPDFViewerButtonViewInfo.MeasureWidth: Integer;
begin
  Result := ApplyScaleFactor(cxMarginsWidth(Margins)) + GlyphSize.cx
end;

procedure TdxPDFViewerButtonViewInfo.DoCalculate;
begin
  CalculateCaptionRect;
  CalculateGlyphRect;
end;

procedure TdxPDFViewerButtonViewInfo.DrawContent(ACanvas: TcxCanvas);
begin
  DrawFading(ACanvas);
  ACanvas.SaveState;
  try
    DrawButtonContent(ACanvas);
    if CanFocus then
      DrawFocusRect(ACanvas);
  finally
    ACanvas.RestoreState;
  end;
end;

procedure TdxPDFViewerButtonViewInfo.DrawFocusRect(ACanvas: TcxCanvas);
begin
  if IsFocused then
    Painter.DrawFocusRect(ACanvas, Bounds);
end;

procedure TdxPDFViewerButtonViewInfo.UpdateState;
begin
  State := CalculateState;
end;

function TdxPDFViewerButtonViewInfo.CalculateState: TcxButtonState;
begin
  if not IsEnabled then
    Result := cxbsDisabled
  else
    if IsPressed and (not Viewer.MouseCapture or IsHot) then
      Result := cxbsPressed
    else
      if IsHot then
        Result := cxbsHot
      else
        if IsDefault or IsFocused then
          Result := cxbsDefault
        else
          Result := cxbsNormal;
end;

function TdxPDFViewerButtonViewInfo.IsDefault: Boolean;
begin
  Result := (Controller.FocusedCell = nil) and (Viewer.FindPanel.ViewInfo.ActualNextButtonViewInfo = Self);
end;

function TdxPDFViewerButtonViewInfo.IsEnabled: Boolean;
begin
  Result := True;
end;

function TdxPDFViewerButtonViewInfo.IsFadingAvailable: Boolean;
begin
  Result := Painter.IsFadingAvailable;
end;

function TdxPDFViewerButtonViewInfo.IsSkinUsed: Boolean;
begin
  Result := Painter.IsSkinUsed;
end;

function TdxPDFViewerButtonViewInfo.GetDefaultCaption: string;
begin
  Result := '';
end;

function TdxPDFViewerButtonViewInfo.GetGlyph: TdxSmartGlyph;
begin
  Result := FGlyph;
end;

function TdxPDFViewerButtonViewInfo.GetGlyphAlignmentHorz: TAlignment;
begin
  Result := taLeftJustify;
end;

function TdxPDFViewerButtonViewInfo.GetHint: string;
begin
  Result := '';
end;

function TdxPDFViewerButtonViewInfo.GetMargins: TRect;
begin
  Result := Rect(4, 4, 4, 4);
end;

procedure TdxPDFViewerButtonViewInfo.CalculateCaptionRect;
begin
  FCaptionRect := cxRectContent(Bounds, Margins);
end;

procedure TdxPDFViewerButtonViewInfo.CalculateGlyphRect;

  procedure PlaceGlyphRect(const AContentBounds: TRect; const AWidth, AHeight: Integer);
  begin
    FGlyphRect := cxRectCenterVertically(AContentBounds, AHeight);
    if GetGlyphAlignmentHorz = taLeftJustify then
      FGlyphRect := cxRectSetLeft(GlyphRect, AContentBounds.Left, AWidth)
    else
      FGlyphRect := cxRectCenterHorizontally(GlyphRect, AWidth);
  end;

  procedure CheckGlyphRectSize(const AContentBounds: TRect; const AGlyphRect: TRect);
  begin
    if (cxRectWidth(AContentBounds) < cxRectWidth(AGlyphRect)) or
      (cxRectHeight(AContentBounds) < cxRectHeight(AGlyphRect)) then
      FGlyphRect := cxRectProportionalStretch(AContentBounds,
        cxRectWidth(AGlyphRect), cxRectHeight(AGlyphRect));
    PlaceGlyphRect(AContentBounds, cxRectWidth(GlyphRect), cxRectHeight(GlyphRect));
  end;

var
  AContentBounds: TRect;
begin
  FGlyphRect := cxNullRect;
  if not cxSizeIsEmpty(GlyphSize) then
  begin
    AContentBounds := cxRectContent(Bounds, Margins);
    PlaceGlyphRect(AContentBounds, GlyphSize.cx, GlyphSize.cy);
    CheckGlyphRectSize(AContentBounds, GlyphRect);
    FCaptionRect.Left := GlyphRect.Right + ApplyScaleFactor(cxTextOffset);
  end;
end;

procedure TdxPDFViewerButtonViewInfo.DoExecute;
begin
// do nothing
end;

procedure TdxPDFViewerButtonViewInfo.DrawButtonBackground(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState);
begin
  Painter.DrawButtonBackground(ACanvas, ARect, AState);
end;

procedure TdxPDFViewerButtonViewInfo.DrawButtonContent(ACanvas: TcxCanvas);
begin
  ACanvas.Font := Font;
  ACanvas.Font.Color := Painter.ButtonSymbolColor(State);
  if not cxRectIsEmpty(CaptionRect) then
  begin
    cxDrawText(ACanvas, FCaption, cxRectOffset(CaptionRect, GetButtonOffset(State)),
      DT_VCENTER or DT_SINGLELINE or DT_CENTER);
  end;
end;

procedure TdxPDFViewerButtonViewInfo.Execute(AShift: TShiftState = []);
begin
  if IsEnabled then
    DoExecute;
end;

function TdxPDFViewerButtonViewInfo.GetButtonOffset(AButtonState: TcxButtonState): TPoint;
var
  AShift: Integer;
begin
  if AButtonState = cxbsPressed then
  begin
    AShift := Painter.ButtonTextShift;
    Result := cxPoint(AShift, AShift);
  end
  else
    Result := cxNullPoint;
end;

procedure TdxPDFViewerButtonViewInfo.DrawButton(ACanvas: TcxCanvas);
begin
  Painter.DrawButton(ACanvas, Bounds, FCaption, State);
end;

procedure TdxPDFViewerButtonViewInfo.DrawFading(ACanvas: TcxCanvas);
begin
  if not FadingHelper.DrawImage(ACanvas.Handle, Bounds) then
    DrawButtonBackground(ACanvas, Bounds, State);
end;

function TdxPDFViewerButtonViewInfo.GetGlyphSize: TSize;
var
  AGlyph: TdxSmartGlyph;
begin
  AGlyph := GetGlyph;
  if AGlyph <> nil then
    Result := ApplyScaleFactor(AGlyph.Size)
  else
    Result := cxNullSize;
end;

procedure TdxPDFViewerButtonViewInfo.SetState(const AState: TcxButtonState);
begin
  if State <> AState then
  begin
    FadingHelper.CheckStartFading(State, AState);
    FState := AState;
    Invalidate;
  end;
end;

function TdxPDFViewerButtonViewInfo.HasHintPoint(const P: TPoint): Boolean;
begin
  Result := PtInRect(Bounds, P);
end;

function TdxPDFViewerButtonViewInfo.IsHintAtMousePos: Boolean;
begin
  Result := False;
end;

function TdxPDFViewerButtonViewInfo.UseHintHidePause: Boolean;
begin
  Result := True;
end;

{ TdxPDFViewerCustomDropDownButtonViewInfo }

function TdxPDFViewerCustomDropDownButtonViewInfo.IsEnabled: Boolean;
begin
  Result := not Viewer.TextSearch.IsLocked;
end;

function TdxPDFViewerCustomDropDownButtonViewInfo.MeasureWidth: Integer;
begin
  Result := cxMarginsWidth(Margins) + GlyphSize.cx + Painter.DropDownButtonWidth;
end;

procedure TdxPDFViewerCustomDropDownButtonViewInfo.DoCalculate;
begin
  inherited DoCalculate;
  CalculateDropDownButtonArrowRect;
end;

procedure TdxPDFViewerCustomDropDownButtonViewInfo.DoExecute;
begin
  Viewer.ViewerController.ContextPopup(Viewer.ClientToScreen(cxPoint(Bounds.Left, Bounds.Bottom)), GetPopupMenuClass);
end;

procedure TdxPDFViewerCustomDropDownButtonViewInfo.DrawButtonContent(ACanvas: TcxCanvas);
begin
  Painter.DrawDropDownButton(ACanvas, FDropDownButtonArrowRect, State);
  Painter.DrawDropDownButtonGlyph(ACanvas, GetGlyph, GlyphRect, State, GetColorizeGlyph);
end;

procedure TdxPDFViewerCustomDropDownButtonViewInfo.CalculateDropDownButtonArrowRect;
begin
  FDropDownButtonArrowRect := FGlyphRect;
  FDropDownButtonArrowRect.Left := FGlyphRect.Right;
  FDropDownButtonArrowRect.Right := FDropDownButtonArrowRect.Left + Painter.DropDownButtonWidth;
  if not Painter.IsSkinUsed then
    Inc(FDropDownButtonArrowRect.Right, 2);
end;

function TdxPDFViewerCustomDropDownButtonViewInfo.GetColorizeGlyph: Boolean;
begin
  Result := True;
end;

{ TdxPDFViewerButtonFadingHelper }

constructor TdxPDFViewerButtonFadingHelper.Create(AViewInfo: TdxPDFViewerButtonViewInfo);
begin
  inherited Create;
  FButtonViewInfo := AViewInfo;
end;

function TdxPDFViewerButtonFadingHelper.CanFade: Boolean;
begin
  Result := ButtonViewInfo.IsFadingAvailable and not ButtonViewInfo.Viewer.IsDesigning;
end;

procedure TdxPDFViewerButtonFadingHelper.DrawFadeImage;
begin
  ButtonViewInfo.Invalidate;
end;

procedure TdxPDFViewerButtonFadingHelper.GetFadingImages(out AFadeOutImage, AFadeInImage: TcxBitmap);

  function PrepareImage(AState: TcxButtonState): TcxBitmap32;
  begin
    Result := TcxBitmap32.CreateSize(ButtonViewInfo.Bounds, True);
    ButtonViewInfo.DrawButtonBackground(Result.cxCanvas, Result.ClientRect, AState);
  end;

const
  StateMap: array[Boolean] of TcxButtonState = (cxbsNormal, cxbsDefault);
begin
  AFadeOutImage := PrepareImage(StateMap[ButtonViewInfo.IsDefault or ButtonViewInfo.IsFocused]);
  AFadeInImage := PrepareImage(cxbsHot);
end;

{ TdxPDFViewerImageAnimationTransition }

constructor TdxPDFViewerImageAnimationTransition.Create(AImage: TGraphic; ATime: Cardinal;
  AMode: TdxDrawAnimationMode; AIsHiding: Boolean);
begin
  FMode := AMode;
  FIsHiding := AIsHiding;
  PrepareImage(AImage);
  FDestination := TcxBitmap32.CreateSize(FImage.Width, FImage.Height);
  inherited Create(ATime, ateLinear, TransitionLength(FImage.Height));
end;

destructor TdxPDFViewerImageAnimationTransition.Destroy;
begin
  FreeAndNil(FDestination);
  FreeAndNil(FImage);
  inherited Destroy;
end;

procedure TdxPDFViewerImageAnimationTransition.Draw(ACanvas: TCanvas; const ADestRect: TRect);
begin
  FDestination.Clear;
  cxBitBlt(FDestination.Canvas.Handle, ACanvas.Handle, cxRect(cxRectSize(ADestRect)), ADestRect.TopLeft, SRCCOPY);
  dxGPPaintCanvas.BeginPaint(FDestination.Canvas.Handle, FDestination.ClientRect);
  try
    Draw(dxGPPaintCanvas, cxRect(cxRectSize(ADestRect)));
  finally
    dxGPPaintCanvas.EndPaint;
  end;
  cxBitBlt(ACanvas.Handle, FDestination.Canvas.Handle, ADestRect, cxNullPoint, SRCCOPY);
end;

function TdxPDFViewerImageAnimationTransition.TransitionLength(AImageHeight: Integer): Integer;
begin
  Result := IfThen(FMode = amFade, 100, AImageHeight);
end;

procedure TdxPDFViewerImageAnimationTransition.Draw(AGraphics: TdxGPGraphics; const ADestRect: TRect);
var
  APosition, AWidth, AHeight: Integer;
begin
  AWidth := ADestRect.Right - ADestRect.Left;
  AHeight := ADestRect.Bottom - ADestRect.Top;
  APosition := Position;
  case FMode of
    amScrollUp:
      DrawScrollUp(AGraphics, ADestRect.Left, ADestRect.Top, AWidth, AHeight, APosition);
    amScrollUpFade:
      DrawScrollUpFade(AGraphics, ADestRect.Left, ADestRect.Bottom, AWidth, AHeight, APosition);
    amScrollDown:
      DrawScrollDown(AGraphics, ADestRect.Left, ADestRect.Top, AWidth, AHeight, APosition);
    amScrollDownFade:
      DrawScrollDownFade(AGraphics, ADestRect.Left, ADestRect.Top, AWidth, AHeight, APosition);
    amFade:
      begin
        APosition := IfThen(not FIsHiding, Position, Integer(Length) - Position);
        DrawFade(AGraphics, ADestRect.Left, ADestRect.Top, AWidth, AHeight, APosition);
      end;
  end;
end;

procedure TdxPDFViewerImageAnimationTransition.DrawFade(AGraphics: TdxGPGraphics; ALeft, ATop, AWidth, AHeight: Integer; AProgress: Byte);
begin
  AGraphics.Draw(FImage, cxRectBounds(ALeft, ATop, AWidth, AHeight), Rect(0, 0, AWidth, AHeight), MulDiv(255, AProgress, 100));
end;

procedure TdxPDFViewerImageAnimationTransition.DrawScrollDown(AGraphics: TdxGPGraphics; ALeft, ATop, AWidth, AHeight, AOffset: Integer);
begin
  AGraphics.Draw(FImage, cxRectBounds(ALeft, ATop - AHeight + AOffset, AWidth, AHeight));
end;

procedure TdxPDFViewerImageAnimationTransition.DrawScrollDownFade(AGraphics: TdxGPGraphics; ALeft, ATop, AWidth, AHeight, AOffset: Integer);
begin
  AGraphics.Draw(FImage, cxRectBounds(ALeft, ATop + AOffset, AWidth, AHeight));
end;

procedure TdxPDFViewerImageAnimationTransition.DrawScrollUp(AGraphics: TdxGPGraphics; ALeft, ATop, AWidth, AHeight, AOffset: Integer);
begin
  AGraphics.Draw(FImage, cxRectBounds(ALeft, ATop - AOffset, AWidth, AHeight));
end;

procedure TdxPDFViewerImageAnimationTransition.DrawScrollUpFade(AGraphics: TdxGPGraphics; ALeft, ATop, AWidth, AHeight, AOffset: Integer);
begin
  AGraphics.Draw(FImage, cxRectBounds(ALeft, ATop - AOffset, AWidth, AHeight));
end;

procedure TdxPDFViewerImageAnimationTransition.PrepareImage(AImage: TGraphic);
var
  ATemp: TcxBitmap32;
begin
  ATemp := TcxBitmap32.CreateSize(AImage.Width, AImage.Height);
  try
    ATemp.Canvas.Draw(0, 0, AImage);
    FImage := TdxGPImage.CreateFromBitmap(ATemp);
  finally
    ATemp.Free;
  end;
end;

{ TdxPDFViewerFindPanelAnimationController }

procedure TdxPDFViewerFindPanelAnimationController.Animate(AShowing: Boolean);
begin
  FActive := Viewer.CanUseAnimation;
  if Active then
    try
      DoAnimate(AShowing);
    finally
      FActive := False;
    end;
end;

procedure TdxPDFViewerFindPanelAnimationController.Draw(ACanvas: TcxCanvas);
begin
  if FAnimation <> nil then
    FAnimation.Draw(ACanvas.Canvas, FAnimatedRect);
end;

function TdxPDFViewerFindPanelAnimationController.CreateFindPanelBitmap: TcxBitmap;
var
  AViewInfo: TdxPDFViewerFindPanelViewInfo;
  R: TRect;
begin
  AViewInfo := Viewer.FindPanel.ViewInfo;
  Result := TcxBitmap.CreateSize(FAnimatedRect, pf24bit);
  Result.Canvas.Lock;
  try
    Result.cxCanvas.WindowOrg := FAnimatedRect.TopLeft;
    try
      AViewInfo.Draw(Result.cxCanvas, True);
    finally
      Result.cxCanvas.WindowOrg := cxNullPoint;
    end;
    AViewInfo.Edit.InternalEdit.Visible := True;
    AViewInfo.Edit.Calculate;
    R := FAnimatedRect;
    R.Intersect(AViewInfo.Edit.Bounds);
    SendMessage(AViewInfo.Edit.InternalEdit.Handle, WM_SETREDRAW, 1, 0);
    try
      cxPaintControlTo(AViewInfo.Edit.InternalEdit, Result.cxCanvas,
        cxPoint(R.Left - FAnimatedRect.Left, R.Top - FAnimatedRect.Top), AViewInfo.Edit.InternalEdit.Bounds, True, False);
    finally
      AViewInfo.Edit.InternalEdit.Visible := False;
      SendMessage(AViewInfo.Edit.InternalEdit.Handle, WM_SETREDRAW, 0, 0);
    end;
  finally
    Result.Canvas.Unlock;
  end;
end;

function TdxPDFViewerFindPanelAnimationController.GetAnimation: TdxPDFViewerFindPanelAnimation;
begin
  Result := Viewer.OptionsFindPanel.Animation;
end;

procedure TdxPDFViewerFindPanelAnimationController.DoAnimate(AShowing: Boolean);

  function GetMode: TdxDrawAnimationMode;
  begin
    Result := amFade;
    if GetAnimation = fpaSlide then
      case Viewer.OptionsFindPanel.Alignment of
        fpalTopClient, fpalTopLeft, fpalTopCenter, fpalTopRight:
          if AShowing then
            Result := amScrollDown
          else
            Result := amScrollUp;
        fpalBottomClient, fpalBottomLeft, fpalBottomCenter, fpalBottomRight:
          if AShowing then
            Result := amScrollUpFade
          else
            Result := amScrollDownFade;
      end;
  end;

var
  AFindPanelBitmap: TcxBitmap;
begin
  FAnimatedRect := Viewer.FindPanel.ViewInfo.Bounds;
  AFindPanelBitmap := CreateFindPanelBitmap;
  try
    RunAnimation(AFindPanelBitmap, Viewer.OptionsFindPanel.AnimationTime, GetMode, not AShowing);
  finally
    AFindPanelBitmap.Free;
  end;
end;

procedure TdxPDFViewerFindPanelAnimationController.AnimationHandler(Sender: TdxAnimationTransition; var APosition: Integer;
  var AFinished: Boolean);
begin
  if AFinished then
    RedrawArea(Viewer.ClientBounds)
  else
    RedrawArea(FAnimatedRect);
end;

procedure TdxPDFViewerFindPanelAnimationController.RedrawArea(const ARect: TRect);
begin
  Viewer.InvalidateRect(ARect, False);
  Viewer.Update;
end;

procedure TdxPDFViewerFindPanelAnimationController.RunAnimation(AImage: TBitmap; ATime: Cardinal;
  AMode: TdxDrawAnimationMode; AIsHiding: Boolean);
begin
  FAnimation := TdxPDFViewerImageAnimationTransition.Create(AImage, ATime, AMode, AIsHiding);
  try
    Viewer.DeleteCaret;
    FAnimation.FreeOnTerminate := False;
    FAnimation.OnAnimate := AnimationHandler;
    FAnimation.ImmediateAnimation;
  finally
    FreeAndNil(FAnimation);
  end;
end;

{ TdxPDFViewerFindPanelHitTest }

procedure TdxPDFViewerFindPanelHitTest.DoCalculate(const AHitPoint: TPoint);
begin
  inherited DoCalculate(AHitPoint);
  Viewer.FindPanel.ViewInfo.CalculateHitTest(Self);
end;

{ TdxPDFViewerFindPanelController }

constructor TdxPDFViewerFindPanelController.Create(AViewer: TdxPDFCustomViewer; AOptions: TdxPDFViewerOptionsFindPanel);
begin
  inherited Create(AViewer);
  FOptions := AOptions;
end;

function TdxPDFViewerFindPanelController.CanActivate(const P: TPoint): Boolean;
begin
  Result := Viewer.IsFindPanelVisible and inherited CanActivate(P) and not Viewer.ViewerController.LeftMouseButtonPressed;
end;

function TdxPDFViewerFindPanelController.GetViewInfo: TdxPDFViewerContainerViewInfo;
begin
  Result := ViewInfo;
end;

function TdxPDFViewerFindPanelController.GetHitTest: TdxPDFViewerCellHitTest;
begin
  Result := Viewer.FindPanel.HitTest;
end;

function TdxPDFViewerFindPanelController.IsAvailable: Boolean;
begin
  Result := Viewer.IsFindPanelVisible and inherited IsAvailable;
end;

function TdxPDFViewerFindPanelController.ProcessKeyDown(AKey: Word; AShift: TShiftState): Boolean;
begin
  Result := Viewer.IsFindPanelVisible;
  case AKey of
    VK_ESCAPE:
      Viewer.HideFindPanel;
    VK_F3:
      Viewer.FindNext;
  else
    Result := False;
  end
end;

procedure TdxPDFViewerFindPanelController.DoSetFocus;
begin
  if FocusedCell <> ViewInfo.Edit then
    Viewer.DoSetFocus
  else
    if ViewInfo.Edit.InternalEdit.HandleAllocated then
      ViewInfo.Edit.InternalEdit.SetFocus;
end;

function TdxPDFViewerFindPanelController.CanSearchText: Boolean;
begin
  Result := Viewer.IsDocumentLoaded and (ViewInfo.Edit.InternalEdit.EditingValue <> '') and
    not Viewer.TextSearch.IsLocked;
end;

procedure TdxPDFViewerFindPanelController.DoFindText;
var
  AOptions: TdxPDFDocumentTextSearchOptions;
begin
  AOptions.CaseSensitive := Viewer.OptionsFindPanel.CaseSensitive;
  AOptions.WholeWords := Viewer.OptionsFindPanel.WholeWords;
  AOptions.Direction := Viewer.OptionsFindPanel.Direction;
  Viewer.TextSearch.Find(Viewer.OptionsFindPanel.SearchString, AOptions);
  FocusedCell := ViewInfo.Edit;
end;

procedure TdxPDFViewerFindPanelController.SetFocuse;
begin
  FocusedCell := ViewInfo.Edit;
end;

function TdxPDFViewerFindPanelController.GetFindPanelViewInfo: TdxPDFViewerFindPanelViewInfo;
begin
  Result := Viewer.FindPanel.ViewInfo;
end;

{ TdxPDFViewerFindPanelViewInfo }

function TdxPDFViewerFindPanelViewInfo.GetContentMargins: TRect;
begin
  Result := ScaleFactor.Apply(dxPDFViewerFindPanelContentMargins);
end;

function TdxPDFViewerFindPanelViewInfo.GetIndentBetweenElements: Integer;
begin
  Result := ScaleFactor.Apply(dxPDFViewerIndentBetweenElements);
end;

function TdxPDFViewerFindPanelViewInfo.GetVisible: Boolean;
begin
  Result := inherited GetVisible and Viewer.IsFindPanelVisible;
end;

function TdxPDFViewerFindPanelViewInfo.MeasureWidth(const ABounds: TRect): Integer;

  function MeasureWidth(AViewInfo: TdxPDFViewerCellViewInfo): Integer;
  begin
    if AViewInfo <> nil then
      Result := AViewInfo.MeasureWidth + dxPDFViewerIndentBetweenElements
    else
      Result := 0;
  end;

var
  AEditWidth: Integer;
begin
  Result := cxMarginsWidth(ContentMargins);
  Inc(Result, MeasureWidth(FCaption));
  Inc(Result, MeasureWidth(FCloseButton));
  Inc(Result, MeasureWidth(FNextButton));
  Inc(Result, MeasureWidth(FPreviousButton));
  Inc(Result, MeasureWidth(FOptions));
  Inc(Result, MeasureWidth(FEdit));
  if FEdit <> nil then
  begin
    AEditWidth := FEdit.MeasureWidth;
    while (Result > cxRectWidth(ABounds)) and (AEditWidth > FEdit.MinWidth) do
    begin
      Dec(Result, AEditWidth + IndentBetweenElements);
      Dec(AEditWidth, 1);
      Inc(Result, AEditWidth + IndentBetweenElements);
    end;
    while (Result < cxRectWidth(ABounds)) and (AEditWidth < FEdit.MaxWidth) do
    begin
      Dec(Result, AEditWidth + IndentBetweenElements);
      Inc(AEditWidth, 1);
      Inc(Result, AEditWidth + IndentBetweenElements);
    end;
    dxAdjustToTouchableSize(AEditWidth, ScaleFactor);
    FEdit.ActualWidth := AEditWidth;
  end;
end;

procedure TdxPDFViewerFindPanelViewInfo.CalculateBounds(const ARect: TRect; out ABounds: TRect);
var
  AWidth: Integer;
begin
  ABounds := ARect;
  AWidth := MeasureWidth(ARect);
  if AWidth > cxRectWidth(ARect) then
    ABounds := cxNullRect
  else
  begin
    case OptionsFindPanel.Alignment of
      fpalBottomLeft, fpalTopLeft:
        ABounds.Right := ABounds.Left + AWidth;
      fpalBottomRight, fpalTopRight:
        ABounds.Left := ABounds.Right - AWidth;
      fpalTopCenter, fpalBottomCenter:
        begin
          ABounds.Left := cxRectCenter(ABounds).X - AWidth div 2;
          ABounds.Right := ABounds.Left + AWidth;
        end;
    end;

    case OptionsFindPanel.Alignment of
      fpalBottomClient, fpalBottomLeft, fpalBottomCenter, fpalBottomRight:
        ABounds.Top := ABounds.Bottom - MeasureHeight;
      fpalTopClient, fpalTopLeft, fpalTopCenter, fpalTopRight:
        begin
          ABounds.Top := ABounds.Top;
          ABounds.Bottom := ABounds.Top + MeasureHeight;
        end;
    end;
  end;
end;

procedure TdxPDFViewerFindPanelViewInfo.CalculateContent;
var
  AContentBounds: TRect;
begin
  inherited CalculateContent;
  AContentBounds := cxRectContent(Bounds, dxPDFViewerFindPanelContentMargins);
  AlignToRightSide(FCloseButton, AContentBounds);
  AlignToLeftSide(FCaption, AContentBounds);
  AlignToLeftSide(FEdit, AContentBounds);
  AlignToLeftSide(FOptions, AContentBounds);
  AlignToLeftSide(FPreviousButton, AContentBounds);
  AlignToLeftSide(FNextButton, AContentBounds);
end;

procedure TdxPDFViewerFindPanelViewInfo.ClearCells;
begin
  inherited ClearCells;
  FCaption := nil;
  FCloseButton := nil;
  FEdit := nil;
  FNextButton := nil;
  FOptions := nil;
  FPreviousButton := nil;
end;

procedure TdxPDFViewerFindPanelViewInfo.CreateCells;
var
  AOptions: TdxPDFViewerOptionsFindPanel;
begin
  inherited CreateCells;
  FCaption := AddCell(TdxPDFViewerCaptionViewInfo) as TdxPDFViewerCaptionViewInfo;
  AOptions := OptionsFindPanel;
  if AOptions.ShowCloseButton and (AOptions.DisplayMode = fpdmManual) then
    FCloseButton := AddCell(TCloseButtonViewInfo) as TCloseButtonViewInfo;
  FEdit := AddCell(TEditViewInfo) as TEditViewInfo;
  if AOptions.ShowNextButton then
    FNextButton := AddCell(TNextButtonViewInfo) as TNextButtonViewInfo;
  if AOptions.ShowPreviousButton then
    FPreviousButton := AddCell(TPreviousButtonViewInfo) as TPreviousButtonViewInfo;
  if AOptions.ShowOptionsButton then
    FOptions := AddCell(TOptionsButtonViewInfo) as TOptionsButtonViewInfo;
end;

procedure TdxPDFViewerFindPanelViewInfo.DrawBackground(ACanvas: TcxCanvas);
begin
  Painter.DrawFindPanelBackground(ACanvas, Bounds);
end;

procedure TdxPDFViewerFindPanelViewInfo.PopulateTabOrders(ACellList: TdxPDFViewerViewInfoList);
begin
  AddTabOrder(Edit, ACellList);
  AddTabOrder(OptionsButton, ACellList);
  if PreviousButton.IsEnabled then
    AddTabOrder(PreviousButton, ACellList);
  if NextButton.IsEnabled then
    AddTabOrder(NextButton, ACellList);
  AddTabOrder(CloseButton, ACellList);
end;

function TdxPDFViewerFindPanelViewInfo.GetActualNextButtonViewInfo: TButtonViewInfo;
begin
  Result := CloseButton;
end;

function TdxPDFViewerFindPanelViewInfo.GetController: TdxPDFViewerFindPanelController;
begin
  Result := FController as TdxPDFViewerFindPanelController;
end;

function TdxPDFViewerFindPanelViewInfo.GetOptionsFindPanel: TdxPDFViewerOptionsFindPanel;
begin
  Result := Controller.Options;
end;

{ TdxPDFViewerFindPanelViewInfo.TEditViewInfo }

constructor TdxPDFViewerFindPanelViewInfo.TEditViewInfo.Create(AController: TdxPDFViewerContainerController);
begin
  inherited Create(AController);
  ActualWidth := MaxWidth;
end;

function TdxPDFViewerFindPanelViewInfo.TEditViewInfo.CanDrawFocusRect: Boolean;
begin
  Result := False;
end;

function TdxPDFViewerFindPanelViewInfo.TEditViewInfo.CanFocus: Boolean;
begin
  Result := (InternalEdit <> nil) and InternalEdit.CanFocus;
end;

function TdxPDFViewerFindPanelViewInfo.TEditViewInfo.MeasureHeight: Integer;
var
  AEditSizeProperties: TcxEditSizeProperties;
begin
  AEditSizeProperties := cxSingleLineEditSizeProperties;
  Result := InternalEdit.Properties.GetEditSize(cxScreenCanvas, InternalEdit.Style, False, InternalEdit.Text,
    AEditSizeProperties).cy;
  cxScreenCanvas.Dormant;
end;

function TdxPDFViewerFindPanelViewInfo.TEditViewInfo.MeasureWidth: Integer;
begin
  Result := ActualWidth;
  dxAdjustToTouchableSize(Result, ScaleFactor);
end;

procedure TdxPDFViewerFindPanelViewInfo.TEditViewInfo.DoCalculate;
begin
  inherited DoCalculate;
  InternalEdit.BoundsRect := Bounds;
end;

procedure TdxPDFViewerFindPanelViewInfo.TEditViewInfo.UpdateState;
begin
  InternalEdit.Enabled := not Viewer.TextSearch.IsLocked;
end;

procedure TdxPDFViewerFindPanelViewInfo.TEditViewInfo.SetFocus;
begin
  if InternalEdit.HandleAllocated then
  begin
    InternalEdit.SetFocus;
    InternalEdit.SelectAll;
  end;
end;

function TdxPDFViewerFindPanelViewInfo.TEditViewInfo.GetEdit: TdxPDFViewerFindPanelTextEdit;
begin
  Result := Viewer.FindPanel.Edit;
end;

function TdxPDFViewerFindPanelViewInfo.TEditViewInfo.GetMaxWidth: Integer;
begin
  Result := ApplyScaleFactor(dxPDFViewerFindPanelEditMaxWidth);
end;

function TdxPDFViewerFindPanelViewInfo.TEditViewInfo.GetMinWidth: Integer;
begin
  Result := ApplyScaleFactor(dxPDFViewerFindPanelEditMinWidth);
end;

function TdxPDFViewerFindPanelViewInfo.TFindPanelButtonViewInfo.GetController: TdxPDFViewerFindPanelController;
begin
  Result := FController as TdxPDFViewerFindPanelController;
end;

{ TdxPDFViewerFindPanelViewInfo.TButtonViewInfo }

function TdxPDFViewerFindPanelViewInfo.TButtonViewInfo.IsEnabled: Boolean;
begin
  Result := Controller.CanSearchText;
end;

function TdxPDFViewerFindPanelViewInfo.TButtonViewInfo.MeasureWidth: Integer;
begin
  Result := ApplyScaleFactor(dxPDFViewerFindPanelDefaultButtonWidth);
end;

{ TdxPDFViewerFindPanelViewInfo.TCloseButtonViewInfo }

function TdxPDFViewerFindPanelViewInfo.TCloseButtonViewInfo.IsEnabled: Boolean;
begin
  Result := not Viewer.TextSearch.IsLocked;
end;

function TdxPDFViewerFindPanelViewInfo.TCloseButtonViewInfo.MeasureHeight: Integer;
begin
  Result := Painter.FindPanelCloseButtonSize.cy;
end;

function TdxPDFViewerFindPanelViewInfo.TCloseButtonViewInfo.MeasureWidth: Integer;
begin
  Result := Painter.FindPanelCloseButtonSize.cx;
end;

function TdxPDFViewerFindPanelViewInfo.TCloseButtonViewInfo.GetVisible: Boolean;
begin
  Result := Viewer.OptionsFindPanel.ShowCloseButton;
end;

procedure TdxPDFViewerFindPanelViewInfo.TCloseButtonViewInfo.DoExecute;
begin
  Controller.Viewer.HideFindPanel;
end;

procedure TdxPDFViewerFindPanelViewInfo.TCloseButtonViewInfo.DrawButtonBackground(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState);
begin
//
end;

procedure TdxPDFViewerFindPanelViewInfo.TCloseButtonViewInfo.DrawButtonContent(ACanvas: TcxCanvas);
begin
  Painter.DrawFindPanelCloseButton(ACanvas, Bounds, State);
end;

{ TdxPDFViewerFindPanelViewInfo.TSearchButtonViewInfo }

procedure TdxPDFViewerFindPanelViewInfo.TSearchButtonViewInfo.DoExecute;
begin
  Viewer.OptionsFindPanel.Direction := GetSearchDirection;
  Controller.DoFindText;
end;

function TdxPDFViewerFindPanelViewInfo.TSearchButtonViewInfo.GetSearchDirection: TdxPDFDocumentTextSearchDirection;
begin
  Result := tsdForward;
end;

{ TdxPDFViewerFindPanelViewInfo.TNextButtonViewInfo }

function TdxPDFViewerFindPanelViewInfo.TNextButtonViewInfo.GetDefaultCaption: string;
begin
  Result := cxGetResourceString(@sdxPDFViewerFindPanelNextButtonCaption);
end;

function TdxPDFViewerFindPanelViewInfo.TNextButtonViewInfo.GetVisible: Boolean;
begin
  Result := Viewer.OptionsFindPanel.ShowNextButton;
end;

{ TdxPDFViewerFindPanelViewInfo.TOptionsButtonViewInfo }

function TdxPDFViewerFindPanelViewInfo.TOptionsButtonViewInfo.IsEnabled: Boolean;
begin
  Result := not Viewer.TextSearch.IsLocked;
end;

function TdxPDFViewerFindPanelViewInfo.TOptionsButtonViewInfo.GetGlyph: TdxSmartGlyph;
begin
  Result := Viewer.FindPanel.OptionsButtonGlyph;
end;

function TdxPDFViewerFindPanelViewInfo.TOptionsButtonViewInfo.GetPopupMenuClass: TComponentClass;
begin
  Result := TdxPDFViewerFindPanelOptionsPopupMenu;
end;

function TdxPDFViewerFindPanelViewInfo.TOptionsButtonViewInfo.GetVisible: Boolean;
begin
  Result := Viewer.OptionsFindPanel.ShowOptionsButton;
end;

{ TdxPDFViewerFindPanelViewInfo.TPreviousButtonViewInfo }

function TdxPDFViewerFindPanelViewInfo.TPreviousButtonViewInfo.GetDefaultCaption: string;
begin
  Result := cxGetResourceString(@sdxPDFViewerFindPanelPreviousButtonCaption);
end;

function TdxPDFViewerFindPanelViewInfo.TPreviousButtonViewInfo.GetSearchDirection: TdxPDFDocumentTextSearchDirection;
begin
  Result := tsdBackward;
end;

function TdxPDFViewerFindPanelViewInfo.TPreviousButtonViewInfo.GetVisible: Boolean;
begin
  Result := Viewer.OptionsFindPanel.ShowPreviousButton;
end;

{ TdxPDFViewerInteractivityController }

class procedure TdxPDFViewerInteractivityController.Execute(AViewer: TdxPDFCustomViewer; AOutline: TdxPDFDocumentOutlineItem);
begin
  if AOutline <> nil then
    Execute(AViewer, TdxPDFDocumentOutlineTreeItemAccess(AOutline).InteractiveOperation);
end;

class procedure TdxPDFViewerInteractivityController.Execute(AViewer: TdxPDFCustomViewer; AHyperlink: TdxPDFHyperlink);
begin
  if AHyperlink <> nil then
    Execute(AViewer, TdxPDFHyperlinkAccess(AHyperlink).InteractiveOperation);
end;

class procedure TdxPDFViewerInteractivityController.Execute(AViewer: TdxPDFCustomViewer;
  const AOperation: TdxPDFInteractiveOperation);
var
  AController: TdxPDFViewerInteractivityController;
begin
  if AViewer <> nil then
  begin
    AController := TdxPDFViewerInteractivityController.Create(AViewer);
    try
      AController.ExecuteOperation(AOperation);
    finally
      AController.Free;
    end;
  end;
end;

procedure TdxPDFViewerInteractivityController.ExecuteOperation(const AObject: IdxPDFInteractiveObject);
begin
  ExecuteOperation(AObject.GetAction);
end;

procedure TdxPDFViewerInteractivityController.ExecuteOperation(const AOperation: TdxPDFInteractiveOperation);
var
  AExecutedActions: TdxPDFActionList;
begin
  if AOperation.IsValid then
  begin
    ShowDocumentPosition(AOperation.Target);
    AExecutedActions := TdxPDFActionList.Create;
    try
      ExecuteActions(AOperation.Action, AExecutedActions);
    finally
      AExecutedActions.Free;
    end;
  end;
end;

procedure TdxPDFViewerInteractivityController.ShowDocumentPosition(const ATarget: TdxPDFTarget);
var
  APage: TdxPDFViewerPage;
  P: TdxPointF;
  ARect: TdxRectF;
  ATargetPosition: TdxPDFTarget;
begin
  if ATarget.IsValid and InRange(ATarget.PageIndex, 0, Viewer.PageCount - 1) then
  begin
    ATargetPosition := ATarget;
    Viewer.LockHistoryAndExecute(
      procedure
      begin
        Viewer.BeginUpdate;
        Viewer.ViewInfo.LockRecreateCells;
        try
          APage := Viewer.Pages[ATargetPosition.PageIndex] as TdxPDFViewerPage;
          if (ATargetPosition.Mode = tmXYZ) and TdxPDFUtils.IsDoubleValid(ATargetPosition.X) and
            TdxPDFUtils.IsDoubleValid(ATargetPosition.Y) then
          begin
            P := dxPointF(ATargetPosition.X - TdxPDFPageAccess(APage.DocumentPage).CropBox.Left,
              ATargetPosition.Y - TdxPDFPageAccess(APage.DocumentPage).CropBox.Bottom);
            ARect := APage.ToViewerRect(dxRectF(P.X, P.Y, P.X + 1, P.Y - 1));
          end
          else
            ARect := APage.ToViewerRect(TdxPDFPageAccess(APage.DocumentPage).CropBox);
          if TdxPDFUtils.IsDoubleValid(ATargetPosition.Zoom) then
            Viewer.OptionsZoom.ZoomFactor := Trunc(ATargetPosition.Zoom * 100);
        finally
          Viewer.EndUpdate;
          Viewer.ViewInfo.UnLockRecreateCells;
        end;
        Viewer.ViewerController.MakeRectVisible(ARect, vtFully, True);
      end);
    Viewer.ViewerController.ViewStateHistoryController.StoreCurrentViewState(vsctScrolling);
  end;
end;

function TdxPDFViewerInteractivityController.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := S_OK
  else
    Result := E_NOINTERFACE;
end;

function TdxPDFViewerInteractivityController._AddRef: Integer;
begin
  Result := -1;
end;

function TdxPDFViewerInteractivityController._Release: Integer;
begin
  Result := -1;
end;

procedure TdxPDFViewerInteractivityController.GoToFirstPage;
begin
  Viewer.GoToFirstPage;
end;

procedure TdxPDFViewerInteractivityController.GoToLastPage;
begin
  Viewer.GoToLastPage;
end;

procedure TdxPDFViewerInteractivityController.GoToNextPage;
begin
  Viewer.GoToNextPage;
end;

procedure TdxPDFViewerInteractivityController.GoToPrevPage;
begin
  Viewer.GoToPrevPage;
end;

procedure TdxPDFViewerInteractivityController.OpenUri(const AUri: string);
begin
  if (AUri <> '') and Viewer.CanOpenUri(AUri) then
    dxShellExecute(AUri, SW_SHOWMAXIMIZED);
end;

procedure TdxPDFViewerInteractivityController.ExecuteActions(AAction: TdxPDFCustomAction;
  AExecutedActions: TdxPDFActionList);
var
  ACurrentAction: TdxPDFCustomAction;
begin
  if (AAction <> nil) and not AExecutedActions.Contains(AAction) then
  begin
    TdxPDFCustomActionAccess(AAction).Execute(Self);
    AExecutedActions.Add(AAction);
    if TdxPDFCustomActionAccess(AAction).Next <> nil then
      for ACurrentAction in TdxPDFCustomActionAccess(AAction).Next do
        ExecuteActions(ACurrentAction, AExecutedActions);
  end;
end;

{ TdxPDFViewerNavigationPaneInternalControl }

procedure TdxPDFViewerNavigationPaneInternalControl.Clear;
begin
  ClearInternalControl;
end;

procedure TdxPDFViewerNavigationPaneInternalControl.Refresh;
begin
  Clear;
  PopulateInternalControl;
end;

procedure TdxPDFViewerNavigationPaneInternalControl.UpdateState;
begin
  Viewer.NavigationPane.ViewInfo.UpdateState;
end;

procedure TdxPDFViewerNavigationPaneInternalControl.UpdateTextSize;
begin
  UpdateInternalControlTextSize;
end;

procedure TdxPDFViewerNavigationPaneInternalControl.CreateSubClasses;
begin
  inherited CreateSubClasses;
  CreateInternalControl;
end;

procedure TdxPDFViewerNavigationPaneInternalControl.DestroySubClasses;
begin
  FreeAndNil(FInternalControl);
  inherited DestroySubClasses;
end;

procedure TdxPDFViewerNavigationPaneInternalControl.InitializeInternalControl;
begin
  FInternalControl.Parent := Viewer;
  FInternalControl.Visible := False;
end;

function TdxPDFViewerNavigationPaneInternalControl.GetBounds: TRect;
begin
  Result := FInternalControl.BoundsRect;
end;

function TdxPDFViewerNavigationPaneInternalControl.GetVisible: Boolean;
begin
  Result := FInternalControl.Visible;
end;

procedure TdxPDFViewerNavigationPaneInternalControl.SetBounds(const AValue: TRect);
begin
  if not cxRectIsEqual(FInternalControl.BoundsRect, AValue) then
  begin
    FInternalControl.BoundsRect := AValue;
    FInternalControl.Visible := not cxRectIsEmpty(FInternalControl.BoundsRect);
  end;
end;

{ TdxPDFViewerBookmarkTreeView }

function TdxPDFViewerBookmarkTreeView.CanExpandSelectedBookmark: Boolean;
begin
  Result := IsBookmarkSelected and (TreeView.Selected.Count > 0) and not TreeView.Selected.Expanded;
end;

function TdxPDFViewerBookmarkTreeView.IsBookmarkSelected: Boolean;
begin
  Result := TreeView.SelectionCount > 0;
end;

function TdxPDFViewerBookmarkTreeView.IsTopLevelBookmarksExpanded: Boolean;
var
  ANode: TdxTreeViewNode;
begin
  Result := False;
  ANode := TreeView.Items.GetFirstNode;
  while ANode <> nil do
  begin
    Result := (ANode.Count > 0) and ANode.Expanded;
    if Result then
      Break;
    ANode := ANode.GetNext;
  end;
end;

procedure TdxPDFViewerBookmarkTreeView.ExpandCollapseTopLevelBookmarks;
var
  AExpanded: Boolean;
  ANode: TdxTreeViewNode;
begin
  if TreeView.Items.Count > 0 then
  begin
    AExpanded := not IsTopLevelBookmarksExpanded;
    TreeView.Items.BeginUpdate;
    try
      ANode := TreeView.Items.GetFirstNode;
      while ANode <> nil do
      begin
        ANode.Expanded := AExpanded;
        ANode := ANode.GetNext;
      end;
    finally
      TreeView.Items.EndUpdate;
      TreeView.Items[0].MakeVisible;
    end;
  end;
end;

procedure TdxPDFViewerBookmarkTreeView.ExpandCurrentBookmark;
begin
  if IsBookmarkSelected then
    TreeView.Selected.Expand(False);
end;

procedure TdxPDFViewerBookmarkTreeView.GoToBookmark;
var
  AOutline: TdxPDFDocumentOutlineItem;
begin
  AOutline := SelectedOutline;
  if AOutline <> nil then
    Viewer.NavigationPane.Controller.ExecuteOperation(TdxPDFDocumentOutlineTreeItemAccess(AOutline).InteractiveOperation);
end;

procedure TdxPDFViewerBookmarkTreeView.PrintSelectedPages(APrintSections: Boolean);
var
  APages: TIntegerDynArray;
begin
  if Viewer.CanPrint then
  begin
    APages := GetPrintPageNumbers(APrintSections);
    if Length(APages) > 0  then
      dxPrintingRepository.PrintReport(Viewer, APages);
  end;
end;

function TdxPDFViewerBookmarkTreeView.GetEmpty: Boolean;
begin
  Result := Outlines = nil;
  if not Result then
    Result := Outlines.Count = 0;
end;

procedure TdxPDFViewerBookmarkTreeView.ClearInternalControl;
begin
  TreeView.Items.Clear;
end;

procedure TdxPDFViewerBookmarkTreeView.CreateInternalControl;
begin
  FInternalControl := TTree.Create(Viewer);
  InitializeInternalControl;
end;

procedure TdxPDFViewerBookmarkTreeView.InitializeInternalControl;
var
  ATreeView: TTree;
begin
  inherited InitializeInternalControl;
  ATreeView := TreeView;
  ATreeView.LookAndFeel.MasterLookAndFeel := Viewer.LookAndFeel;
  ATreeView.OnCustomDrawNode := OnCustomDrawItemHandle;
  ATreeView.OnMouseUp := OnMouseUpHandler;
  ATreeView.OnKeyDown := OnKeyDownHandler;
  ATreeView.OnExpanded := OnExpandedHandler;
  ATreeView.OnCollapsed := OnExpandedHandler;
  ATreeView.OnSelectionChanged := OnSelectionChanged;
end;

procedure TdxPDFViewerBookmarkTreeView.PopulateInternalControl;

  procedure PopulateTree(AParent: TdxTreeViewNode; AParentID, AStartIndex: Integer);
  var
    AIndex: Integer;
    AOutline: TdxPDFDocumentOutlineTreeItemAccess;
    ANode: TdxTreeViewNode;
  begin
    TreeView.Items.BeginUpdate;
    try
      for AIndex := AStartIndex to Outlines.Count - 1 do
      begin
        AOutline := TdxPDFDocumentOutlineTreeItemAccess(Outlines[AIndex]);
        if AOutline.ParentID = AParentID then
        begin
          ANode := TreeView.Items.AddChildObject(AParent, AOutline.Title, AOutline);
          if AOutline.HasChildren then
            PopulateTree(ANode, AOutline.ID, AIndex);
        end;
      end;
    finally
      TreeView.Items.EndUpdate;
    end;
  end;

begin
  if Outlines <> nil then
    PopulateTree(nil, 0, 0);
end;

procedure TdxPDFViewerBookmarkTreeView.UpdateInternalControlTextSize;
begin
  TreeView.SetTextSize(Viewer.OptionsNavigationPane.Bookmarks.TextSize);
end;

function TdxPDFViewerBookmarkTreeView.GetLookAndFeel: TcxLookAndFeel;
begin
  Result := TreeView.LookAndFeel;
end;

function TdxPDFViewerBookmarkTreeView.GetOutlines: TdxPDFDocumentOutlineList;
begin
  Result := Viewer.Outlines;
end;

function TdxPDFViewerBookmarkTreeView.GetSelectedOutline: TdxPDFDocumentOutlineItem;
begin
  if TreeView.Selected <> nil then
    Result := TdxPDFDocumentOutlineItem(TreeView.Selected.Data)
  else
    Result := nil;
end;

function TdxPDFViewerBookmarkTreeView.GetTreeView: TTree;
begin
  Result := FInternalControl as TTree;
end;

function TdxPDFViewerBookmarkTreeView.GetPrintPageNumbers(APrintSections: Boolean): TIntegerDynArray;

  function GetSelectedOutlines: TList<TdxPDFDocumentOutlineItem>;
  var
    I: Integer;
    ANode: TdxTreeViewNode;
  begin
    Result := TList<TdxPDFDocumentOutlineItem>.Create;
    for I := 0 to TreeView.SelectionCount - 1 do
    begin
      ANode := TreeView.Selections[I];
      if ANode.Data <> nil then
        Result.Add(TdxPDFDocumentOutlineItem(ANode.Data));
    end;
  end;

var
  ASelectedOutlines: TList<TdxPDFDocumentOutlineItem>;
begin
  ASelectedOutlines := GetSelectedOutlines;
  try
    Result := TdxPDFDocumentOutlineTreeAccess(Outlines).GetPrintPageNumbers(ASelectedOutlines, APrintSections);
  finally
    ASelectedOutlines.Free;
  end;
end;

procedure TdxPDFViewerBookmarkTreeView.OnExpandedHandler(Sender: TdxCustomTreeView; ANode: TdxTreeViewNode);
begin
  UpdateState;
end;

procedure TdxPDFViewerBookmarkTreeView.OnCustomDrawItemHandle(Sender: TdxCustomTreeView;
    ACanvas: TcxCanvas; ANodeViewInfo: TdxTreeViewNodeViewInfo; var AHandled: Boolean);
var
  AOutline: TdxPDFDocumentOutlineTreeItemAccess;
begin
  if ANodeViewInfo.Node.Deleting then
    Exit;
  AHandled := False;
  AOutline := TdxPDFDocumentOutlineTreeItemAccess(ANodeViewInfo.Node.Data);
  if AOutline <> nil then
  begin
    if AOutline.Color <> dxPDFOutlineTreeItemDefaultColor then
      Sender.Canvas.Font.Color := AOutline.Color
    else
      Sender.Canvas.Font.Color := TreeView.LookAndFeelPainter.DefaultContentTextColor;
    if AOutline.IsBold then
      Sender.Canvas.Font.Style := [fsBold];
    if AOutline.IsItalic then
      Sender.Canvas.Font.Style := [fsItalic];
  end;
end;

procedure TdxPDFViewerBookmarkTreeView.OnMouseUpHandler(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  AItem: TdxTreeViewNode;
begin
  if Button = mbLeft then
  begin
    AItem := TreeView.HitTest.HitObjectAsNode;
    if (AItem <> nil) and (AItem = TreeView.Selected) then
      GoToBookmark;
  end;
end;

procedure TdxPDFViewerBookmarkTreeView.OnKeyDownHandler(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    GoToBookmark;
end;

procedure TdxPDFViewerBookmarkTreeView.OnSelectionChanged(Sender: TObject);
begin
  UpdateState;
end;

{ TdxPDFViewerAttachmentFileList }

procedure TdxPDFViewerAttachmentFileList.ClearInternalControl;
begin
  View.Items.Clear;
end;

procedure TdxPDFViewerAttachmentFileList.CreateInternalControl;
begin
  FInternalControl := TdxListViewControl.Create(Viewer);
  InitializeInternalControl;
end;

procedure TdxPDFViewerAttachmentFileList.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FImages := TdxShellImageList.CreateEx(nil, TdxShellImageListIconType.Large, ScaleFactor);
end;

procedure TdxPDFViewerAttachmentFileList.DestroySubClasses;
begin
  FreeAndNil(FImages);
  inherited DestroySubClasses;
end;

function TdxPDFViewerAttachmentFileList.GetEmpty: Boolean;
begin
  Result := DocumentAttachments = nil;
  if not Result then
    Result := DocumentAttachments.Count = 0;
end;

procedure TdxPDFViewerAttachmentFileList.InitializeInternalControl;
var
  AView: TdxListViewControl;
begin
  inherited InitializeInternalControl;
  AView := View;
  AView.ReadOnly := True;
  AView.LookAndFeel.MasterLookAndFeel := Viewer.LookAndFeel;
  AView.MultiSelect := False;
  AView.ShowHint := Viewer.NavigationPane.ShowHints;
  AView.ViewStyle := TdxListViewStyle.List;
  AView.ExplorerStyle := True;

  AView.OnClick := OnClickHandler;
  AView.OnDblClick := OnDblClickHandler;
  AView.OnKeyDown := OnKeyDownHandler;
  AView.OnMouseMove := OnMouseMoveHandler;
  AView.OnContextPopup := OnContextPopupHandler;
  AView.OnMouseLeave := OnMouseLeaveHandler;
end;

procedure TdxPDFViewerAttachmentFileList.PopulateInternalControl;

  function CreateSortedAttachmentList: TList<TdxPDFFileAttachment>;
  var
    AComparer: IComparer<TdxPDFFileAttachment>;
  begin
    Result := TList<TdxPDFFileAttachment>.Create;
    try
      Result.AddRange(DocumentAttachments);
      AComparer := TdxPDFFileAttachmentComparer.Create;
      Result.Sort(AComparer);
    except
      FreeAndNil(Result);
      raise;
    end;
  end;

  procedure PopulateView;
  var
    AAttachment: TdxPDFFileAttachment;
    ASortedList: TList<TdxPDFFileAttachment>;
    I: Integer;
  begin
    FImages.ShellBeginUpdate;
    try
      ASortedList := CreateSortedAttachmentList;
      try
        for I := 0 to ASortedList.Count - 1 do
        begin
          AAttachment := ASortedList[I];
          View.AddItem(AAttachment.FileName, AAttachment);
          View.Items[I].ImageIndex := FImages.GetShellIconIndex(AAttachment.FileName);
        end;
      finally
        ASortedList.Free;
      end;
    finally
      FImages.ShellEndUpdate;
    end;
  end;

begin
  if not Empty then
  begin
    View.BeginUpdate;
    try
      View.Clear;
      View.ImageOptions.ScaleOnDPIChanges := False;
      View.ImageOptions.SmallImages := FImages;
      PopulateView;
    finally
      View.EndUpdate;
    end;
  end;
  UpdateState;
end;

procedure TdxPDFViewerAttachmentFileList.UpdateInternalControlTextSize;
begin
// do nothing
end;

function TdxPDFViewerAttachmentFileList.GetDocumentAttachments: TdxPDFFileAttachmentList;
begin
  if Viewer.IsDocumentLoaded then
    Result := Viewer.Document.FileAttachments
  else
    Result := nil;
end;

function TdxPDFViewerAttachmentFileList.GetView: TdxListViewControl;
begin
  Result := FInternalControl as TdxListViewControl;
end;

function TdxPDFViewerAttachmentFileList.GetShowHint: Boolean;
begin
  Result := View.ShowHint;
end;

procedure TdxPDFViewerAttachmentFileList.ScaleFactorChanged(Sender: TObject; M,
  D: Integer; IsLoading: Boolean);
begin
  inherited ScaleFactorChanged(Sender, M, D, IsLoading);
  if FImages <> nil then
    FImages.ScaleChanged(ScaleFactor);
end;

procedure TdxPDFViewerAttachmentFileList.SetShowHint(const AValue: Boolean);
begin
  View.ShowHint := AValue;
end;

procedure TdxPDFViewerAttachmentFileList.OpenAttachment;
begin
  Viewer.Attachments.OpenAttachment;
end;

procedure TdxPDFViewerAttachmentFileList.OnClickHandler(Sender: TObject);
begin
  UpdateState;
end;

procedure TdxPDFViewerAttachmentFileList.OnContextPopupHandler(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
var
  APopupMenu: TdxPDFViewerNavigationPaneAttachmentPopupMenu;
begin
  if not Handled then
  begin
    Handled := True;
    if View.FocusedItem <> nil then
    begin
      APopupMenu := TdxPDFViewerNavigationPaneAttachmentPopupMenu.Create(Viewer);
      try
        Handled := TdxPDFViewerPopupMenuAccess(APopupMenu).Popup(View.ClientToScreen(MousePos));
      finally
        FreeAndNil(APopupMenu);
      end;
    end;
  end;
end;

procedure TdxPDFViewerAttachmentFileList.OnDblClickHandler(Sender: TObject);
begin
  if View.FocusedItem <> nil then
    OpenAttachment;
end;

procedure TdxPDFViewerAttachmentFileList.OnKeyDownHandler(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key in [VK_RETURN, VK_SPACE] then
    OpenAttachment;
end;

procedure TdxPDFViewerAttachmentFileList.OnMouseLeaveHandler(Sender: TObject);
begin
  Viewer.DoSetFocus;
end;

procedure TdxPDFViewerAttachmentFileList.OnMouseMoveHandler(Sender: TObject; Shift: TShiftState; X, Y: Integer);

  function GetCurrentItemIndex(const P: TPoint): Integer;
  var
    AItem: TdxListItem;
  begin
    AItem := TdxListViewControlAccess(View as TdxListViewControl).GetItemAtPos(P);
    if AItem <> nil then
      Result := AItem.Index
    else
      Result := -1;
  end;

  function NeedCancelPrevHint(ACurrentIndex: Integer): Boolean;
  begin
    Result := FPrevItemIndex <> ACurrentIndex;
  end;

  function GetItemHint(AIndex: Integer): string;
  var
    AAttachment: TdxPDFFileAttachmentAccess;
    S: string;
  begin
    AAttachment := TdxPDFFileAttachmentAccess(TObject(View.Items[AIndex].Data) as TdxPDFFileAttachment);
    if AAttachment.FileName <> '' then
      Result := cxGetResourceString(@sdxPDFViewerNavigationPageAttachmentFileNameCaption) + AAttachment.FileName + dxCRLF;
    if AAttachment.Description <> '' then
      Result := Result + cxGetResourceString(@sdxPDFViewerNavigationPageAttachmentDescriptionCaption) +
        AAttachment.Description + dxCRLF;
    S := AAttachment.GetModificationDateAsString;
    if S <> '' then
      Result := Result + cxGetResourceString(@sdxPDFViewerNavigationPageAttachmentModifiedCaption) + S + dxCRLF;
    S := AAttachment.GetSizeAsString;
    if S <> '' then
      Result := Result + cxGetResourceString(@sdxPDFViewerNavigationPageAttachmentFileSizeCaption) + S + dxCRLF;
    if Length(Result) > 0 then
      Result := Copy(Result, 1, Length(Result) - Length(dxCRLF))
  end;

var
  ACurrentItemIndex: Integer;
begin
  ACurrentItemIndex := GetCurrentItemIndex(cxPoint(X, Y));
  if NeedCancelPrevHint(ACurrentItemIndex) then
    Application.CancelHint;
  FPrevItemIndex := ACurrentItemIndex;
  if InRange(ACurrentItemIndex, 0, View.Items.Count - 1) then
    View.Hint := GetItemHint(ACurrentItemIndex)
  else
    View.Hint := '';
end;

{ TdxPDFViewerBookmarkTreeView.TTree }

constructor TdxPDFViewerBookmarkTreeView.TTree.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  LookAndFeel.MasterLookAndFeel := Viewer.LookAndFeel;
  OptionsSelection.HideSelection := False;
  OptionsSelection.MultiSelect := True;
  Viewer.AddFontListener(Self);
end;

destructor TdxPDFViewerBookmarkTreeView.TTree.Destroy;
begin
  Viewer.RemoveFontListener(Self);
  inherited Destroy;
end;

function TdxPDFViewerBookmarkTreeView.TTree.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint): Boolean;
begin
  if not Viewer.HitTest.HitAtDocumentViewer then
    Result := inherited DoMouseWheel(Shift, WheelDelta, MousePos)
  else
    Result := Viewer.ProcessMouseWheelMessage(WheelDelta);
end;

procedure TdxPDFViewerBookmarkTreeView.TTree.DoContextPopup(MousePos: TPoint; var Handled: Boolean);
var
  P: TPoint;
  APopupMenu: TdxPDFViewerBookmarkPopupMenu;
begin
  inherited DoContextPopup(MousePos, Handled);
  if not Handled then
  begin
    Handled := True;
    P := GetMouseCursorClientPos;
    if (Selected <> nil) and PtInRect(Selected.DisplayRect(True), P) then
    begin
      APopupMenu := TdxPDFViewerBookmarkPopupMenu.Create(Owner);
      try
        Handled := TdxPDFViewerPopupMenuAccess(APopupMenu).Popup(ClientToScreen(P));
      finally
        FreeAndNil(APopupMenu);
      end;
    end;
  end;
end;

procedure TdxPDFViewerBookmarkTreeView.TTree.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) and (Key = Ord('F')) then
    Viewer.ShowFindPanel
  else
    inherited KeyDown(Key, Shift);
end;

procedure TdxPDFViewerBookmarkTreeView.TTree.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  AItem: TdxTreeViewNode;
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbRight then
  begin
    AItem := HitTest.HitObjectAsNode;
    if AItem <> nil then
      AItem.Selected := True;
  end;
end;

procedure TdxPDFViewerBookmarkTreeView.TTree.SetTextSize(ATextSize: TdxPDFViewerBookmarksTextSize);
const
  FontSizeDelta: array[TdxPDFViewerBookmarksTextSize] of Integer = (0, 2, 4);
begin
  Font.Size := FFontSize + FontSizeDelta[ATextSize];
end;

function TdxPDFViewerBookmarkTreeView.TTree.GetViewer: TdxPDFCustomViewer;
begin
  Result := Owner as TdxPDFCustomViewer;
end;

procedure TdxPDFViewerBookmarkTreeView.TTree.Changed(Sender: TObject; AFont: TFont);
begin
  Font.Assign(AFont);
  FFontSize := Font.Size;
end;

{ TdxPDFViewerNavigationPanePageToolBarOptionsButtonViewInfo }

function TdxPDFViewerNavigationPanePageToolBarOptionsButtonViewInfo.CanFocus: Boolean;
begin
  Result := False;
end;

function TdxPDFViewerNavigationPanePageToolBarOptionsButtonViewInfo.IsEnabled: Boolean;
begin
  Result := not Viewer.TextSearch.IsLocked;
end;

function TdxPDFViewerNavigationPanePageToolBarOptionsButtonViewInfo.GetColorizeGlyph: Boolean;
begin
  Result := False;
end;

function TdxPDFViewerNavigationPanePageToolBarOptionsButtonViewInfo.GetGlyph: TdxSmartGlyph;
begin
  Result := Viewer.NavigationPane.MenuButtonGlyph;
end;

function TdxPDFViewerNavigationPanePageToolBarOptionsButtonViewInfo.GetHint: string;
begin
  Result := cxGetResourceString(@sdxPDFViewerNavigationPageOptionsButtonHint);
end;

function TdxPDFViewerNavigationPanePageToolBarOptionsButtonViewInfo.GetPopupMenuClass: TComponentClass;
begin
  if Assigned(OnGetPopupMenuClass) then
    Result := OnGetPopupMenuClass
  else
    Result := nil;
end;

function TdxPDFViewerNavigationPanePageToolBarOptionsButtonViewInfo.MeasureHeight: Integer;
begin
  Result := ApplyScaleFactor(dxPDFViewerNavigationPageToolbarButtonHeight);
end;

procedure TdxPDFViewerNavigationPanePageToolBarOptionsButtonViewInfo.DrawButtonBackground(ACanvas: TcxCanvas; const ARect: TRect;
  AState: TcxButtonState);
begin
  if AState in [cxbsHot, cxbsPressed] then
    Painter.DrawButtonBackground(ACanvas, ARect, AState);
end;

{ TdxPDFViewerNavigationPanePageToolBarViewInfo }

function TdxPDFViewerNavigationPanePageToolBarViewInfo.GetContentMargins: TRect;
begin
  Result := Painter.NavigationPanePageToolbarContentOffsets;
end;

function TdxPDFViewerNavigationPanePageToolBarViewInfo.MeasureWidth: Integer;
begin
  Result := ApplyScaleFactor(300);
end;

function TdxPDFViewerNavigationPanePageToolBarViewInfo.HasOptionsButton: Boolean;
begin
  Result := True;
end;

procedure TdxPDFViewerNavigationPanePageToolBarViewInfo.DoCalculate;
begin
  inherited DoCalculate;
  FActualContentBounds := GetContentBounds;
  if HasOptionsButton then
    AlignToLeftSide(FOptionsButton, FActualContentBounds);
end;

procedure TdxPDFViewerNavigationPanePageToolBarViewInfo.CreateCells;
begin
  inherited CreateCells;
  if HasOptionsButton then
  begin
    FOptionsButton := AddCell(TdxPDFViewerNavigationPanePageToolBarOptionsButtonViewInfo) as
      TdxPDFViewerNavigationPanePageToolBarOptionsButtonViewInfo;
    FOptionsButton.OnGetPopupMenuClass := GetPopupMenuClass;
  end;
end;

procedure TdxPDFViewerNavigationPanePageToolBarViewInfo.DrawBackground(ACanvas: TcxCanvas);
begin
  Painter.DrawNavigationPanePageToolbarBackground(ACanvas, Bounds);
end;

function TdxPDFViewerNavigationPanePageToolBarViewInfo.GetPopupMenuClass: TComponentClass;
begin
  Result := nil;
end;

{ TdxPDFViewerNavigationPanePageViewInfo }

constructor TdxPDFViewerNavigationPanePageViewInfo.Create(AController: TdxPDFViewerContainerController;
  APage: TdxPDFViewerNavigationPanePage);
begin
  inherited Create(AController);
  FPage := APage;
end;

function TdxPDFViewerNavigationPanePageViewInfo.CalculateHitTest(AHitTest: TdxPDFViewerCellHitTest): Boolean;
begin
  Result := inherited CalculateHitTest(AHitTest);
  if not FActualContentBounds.IsEmpty then
    AHitTest.HitCodes[hcNavigationPaneSplitter] := not cxRectPtIn(FActualContentBounds, AHitTest.HitPoint);
end;

function TdxPDFViewerNavigationPanePageViewInfo.MeasureWidth: Integer;
begin
  Result := Viewer.NavigationPane.PageSize;
end;

procedure TdxPDFViewerNavigationPanePageViewInfo.CreateCells;
begin
  inherited CreateCells;
  FCaption := AddCell(THeader) as THeader;
  FCaption.OnGetText := OnGetHeaderTextHandler;
  FToolBar := AddCell(GetToolbarClass) as TdxPDFViewerNavigationPanePageToolBarViewInfo;
  FButton := TdxPDFViewerNavigationPanePageButtonViewInfo.Create(Controller, Self);
end;

procedure TdxPDFViewerNavigationPanePageViewInfo.DoCalculate;
var
  AContentBounds: TRect;
begin
  FActualContentBounds := cxNullRect;
  inherited DoCalculate;
  AContentBounds := Bounds;

  AContentBounds.Top := Painter.LookAndFeelPainter.PDFViewerNavigationPaneButtonRect(
    Viewer.NavigationPane.ViewInfo.FirstPageButton.Bounds, cxbsPressed, True, ScaleFactor).Top;
  AlignToTopClientSide(FCaption, AContentBounds);
  FCaption.Bounds := cxRect(FCaption.Bounds.Left, Bounds.Top, FCaption.Bounds.Right, FCaption.Bounds.Bottom);

  FActualContentBounds := AContentBounds;

  FActualContentBounds := cxRectContent(FActualContentBounds, cxRect(Painter.NavigationPanePageContentOffsets.Left, 0,
    Painter.NavigationPanePageContentOffsets.Right, Painter.NavigationPanePageContentOffsets.Bottom));
  AlignToTopClientSide(FToolBar, FActualContentBounds);
end;

procedure TdxPDFViewerNavigationPanePageViewInfo.DrawBackground(ACanvas: TcxCanvas);
begin
  Painter.DrawNavigationPanePageBackground(ACanvas, Bounds);
end;

function TdxPDFViewerNavigationPanePageViewInfo.GetToolbarClass: TdxPDFViewerCellViewInfoClass;
begin
  Result := TdxPDFViewerNavigationPanePageToolBarViewInfo;
end;

function TdxPDFViewerNavigationPanePageViewInfo.CanShow: Boolean;
begin
  Result := FPage.CanShow;
end;

function TdxPDFViewerNavigationPanePageViewInfo.OnGetHeaderTextHandler: string;
begin
  Result := FPage.Caption;
end;

function TdxPDFViewerNavigationPanePageViewInfo.GetGlyph: TdxSmartGlyph;
begin
  Result := FPage.Glyph;
end;

{ TdxPDFViewerNavigationPanePageViewInfo.TCaptionText }

function TdxPDFViewerNavigationPanePageViewInfo.TCaptionText.GetFont: TFont;
begin
  Result := Viewer.NavigationPane.Font;
end;

function TdxPDFViewerNavigationPanePageViewInfo.TCaptionText.GetPainterTextColor: TColor;
begin
  Result := Painter.TitleTextColor;
end;

function TdxPDFViewerNavigationPanePageViewInfo.TCaptionText.GetText: string;
begin
  if Assigned(OnGetText) then
    Result := OnGetText
  else
    Result := '';
end;

function TdxPDFViewerNavigationPanePageViewInfo.TCaptionText.GetTextAlignment: TAlignment;
begin
  Result := taLeftJustify;
end;

procedure TdxPDFViewerNavigationPanePageViewInfo.TCaptionText.PrepareCanvas(ACanvas: TcxCanvas);
begin
  inherited PrepareCanvas(ACanvas);
  ACanvas.Font.Color := Painter.NavigationPanePageCaptionTextColor;
  ACanvas.Font.Style := [fsBold];
end;

{ TdxPDFViewerNavigationPanePageCaptionButton }

function TdxPDFViewerNavigationPanePageCaptionButton.CanFocus: Boolean;
begin
  Result := False;
end;

function TdxPDFViewerNavigationPanePageCaptionButton.GetGlyphAlignmentHorz: TAlignment;
begin
  Result := taCenter;
end;

function TdxPDFViewerNavigationPanePageCaptionButton.MeasureHeight: Integer;
begin
  Result := ApplyScaleFactor(dxPDFViewerNavigationPageToolbarButtonHeight);
end;

function TdxPDFViewerNavigationPanePageCaptionButton.MeasureWidth: Integer;
begin
  Result := MeasureHeight;
end;

procedure TdxPDFViewerNavigationPanePageCaptionButton.DrawButtonContent(ACanvas: TcxCanvas);
begin
  Painter.DrawButtonGlyph(ACanvas, GetGlyph, Bounds, State, GetColorizeGlyph);
end;

procedure TdxPDFViewerNavigationPanePageCaptionButton.DrawButtonBackground(ACanvas: TcxCanvas; const ARect: TRect;
  AState: TcxButtonState);
begin
  Painter.DrawNavigationPanePageButton(ACanvas, Bounds, State);
end;

function TdxPDFViewerNavigationPanePageCaptionButton.GetColorizeGlyph: Boolean;
begin
  Result := True;
end;

{ TdxPDFViewerNavigationPanePageButtonViewInfo }

constructor TdxPDFViewerNavigationPanePageButtonViewInfo.Create(AController: TdxPDFViewerContainerController;
  APage: TdxPDFViewerNavigationPanePageViewInfo);
begin
  inherited Create(AController);
  FPage := APage;
end;

function TdxPDFViewerNavigationPanePageButtonViewInfo.CalculateState: TcxButtonState;
begin
  Result := inherited CalculateState;
  if not cxRectIsEmpty(FPage.Bounds) and IsActive then
    Result := cxbsPressed;
end;

function TdxPDFViewerNavigationPanePageButtonViewInfo.CanFocus: Boolean;
begin
  Result := False;
end;

function TdxPDFViewerNavigationPanePageButtonViewInfo.IsEnabled: Boolean;
begin
  Result := FPage.CanShow;
end;

function TdxPDFViewerNavigationPanePageButtonViewInfo.GetClipRect: TRect;
begin
  if IsActive then
    Result := Viewer.NavigationPane.ViewInfo.Bounds
  else
    Result := Bounds;
end;

function TdxPDFViewerNavigationPanePageButtonViewInfo.GetGlyph: TdxSmartGlyph;
begin
  Result := FPage.GetGlyph;
end;

function TdxPDFViewerNavigationPanePageButtonViewInfo.GetGlyphAlignmentHorz: TAlignment;
begin
  Result := taCenter;
end;

function TdxPDFViewerNavigationPanePageButtonViewInfo.MeasureHeight: Integer;
begin
  Result := Max(GlyphSize.cy + cxMarginsHeight(Painter.NavigationPaneButtonContentOffsets),
    Min(Painter.NavigationPaneButtonSize.cy, Painter.NavigationPaneButtonSize.cy));
end;

function TdxPDFViewerNavigationPanePageButtonViewInfo.MeasureWidth: Integer;
begin
  Result := Max(GlyphSize.cx + cxMarginsWidth(Painter.NavigationPaneButtonContentOffsets),
    Min(Painter.NavigationPaneButtonSize.cx, Painter.NavigationPaneButtonSize.cy));
end;

procedure TdxPDFViewerNavigationPanePageButtonViewInfo.DoExecute;
begin
  Viewer.NavigationPane.ActivePage := FPage.Page;
end;

procedure TdxPDFViewerNavigationPanePageButtonViewInfo.DrawButtonBackground(ACanvas: TcxCanvas;
  const ARect: TRect; AState: TcxButtonState);
begin
// do nothing
end;

procedure TdxPDFViewerNavigationPanePageButtonViewInfo.DrawButtonContent(ACanvas: TcxCanvas);
begin
  Painter.DrawNavigationPaneButton(ACanvas, Bounds, State, Viewer.OptionsNavigationPane.ActivePageState = wsMinimized,
    IsActive, IsFirst);
  Painter.DrawNavigationPaneButtonGlyph(ACanvas, GetGlyph, GlyphRect, State);
end;

function TdxPDFViewerNavigationPanePageButtonViewInfo.IsActive: Boolean;
var
  AActivePage: TdxPDFViewerNavigationPanePageViewInfo;
begin
  Result := (Viewer.ViewInfo <> nil) and (Viewer.NavigationPane.ViewInfo <> nil);
  if Result then
  begin
    AActivePage := Viewer.NavigationPane.ViewInfo.ActivePage;
    Result := (AActivePage <> nil) and (Viewer.OptionsNavigationPane.ActivePageState <> wsMinimized) and
      (AActivePage.Button = Self);
  end;
end;

function TdxPDFViewerNavigationPanePageButtonViewInfo.IsFirst: Boolean;
begin
  Result := FPage.Page.IsFirst;
end;

{ TdxPDFViewerNavigationPanePageViewInfo.TMinimizeButton }

function TdxPDFViewerNavigationPanePageViewInfo.TMinimizeButton.GetGlyph: TdxSmartGlyph;
begin
  Result := Viewer.NavigationPane.MinimizeButtonGlyph;
end;

function TdxPDFViewerNavigationPanePageViewInfo.TMinimizeButton.GetHint: string;
begin
  Result := cxGetResourceString(@sdxPDFViewerNavigationPageHideButtonHint);
end;

procedure TdxPDFViewerNavigationPanePageViewInfo.TMinimizeButton.DoExecute;
begin
  Viewer.NavigationPane.MinimizePage;
end;

{ TdxPDFViewerNavigationPanePageViewInfo.TMaximizeButton }

function TdxPDFViewerNavigationPanePageViewInfo.TMaximizeButton.GetGlyph: TdxSmartGlyph;
begin
  Result := Viewer.NavigationPane.MaximizeButtonGlyph;
end;

function TdxPDFViewerNavigationPanePageViewInfo.TMaximizeButton.GetHint: string;
begin
  if Viewer.NavigationPane.IsMaximized then
    Result := cxGetResourceString(@sdxPDFViewerNavigationPageCollapseButtonHint)
  else
    Result := cxGetResourceString(@sdxPDFViewerNavigationPageExpandButtonHint);
end;

procedure TdxPDFViewerNavigationPanePageViewInfo.TMaximizeButton.DoExecute;
begin
  Viewer.NavigationPane.MaximizePage;
end;

{ TdxPDFViewerNavigationPanePageViewInfo.THeader }

function TdxPDFViewerNavigationPanePageViewInfo.THeader.GetContentMargins: TRect;
begin
  Result := Painter.NavigationPanePageCaptionContentOffsets;
end;

function TdxPDFViewerNavigationPanePageViewInfo.THeader.GetOnGetText: THeaderOnGetTextEvent;
begin
  Result := FCaption.OnGetText;
end;

function TdxPDFViewerNavigationPanePageViewInfo.THeader.GetViewInfo: TdxPDFViewerNavigationPaneViewInfo;
begin
  Result := Viewer.NavigationPane.ViewInfo;
end;

procedure TdxPDFViewerNavigationPanePageViewInfo.THeader.SetOnGetText(const AValue: THeaderOnGetTextEvent);
begin
  FCaption.OnGetText := AValue;
end;

function TdxPDFViewerNavigationPanePageViewInfo.THeader.AlignToClient(AViewInfo: TdxPDFViewerCellViewInfo;
  var R: TRect): Boolean;
var
  ARect: TRect;
begin
  Result := AViewInfo <> nil;
  if Result then
  begin
    ARect := R;
    AViewInfo.Bounds := cxRectCenterVertically(ARect, AViewInfo.MeasureHeight);
    R.Left := AViewInfo.Bounds.Right;
    Inc(R.Left, IndentBetweenElements);
  end;
end;

function TdxPDFViewerNavigationPanePageViewInfo.THeader.MeasureHeight: Integer;
begin
  Result := ViewInfo.FirstPageButton.Bounds.Height + Painter.NavigationPaneButtonOverlay.Y;
end;

function TdxPDFViewerNavigationPanePageViewInfo.THeader.MeasureWidth: Integer;
begin
  Result := ApplyScaleFactor(300);
end;

procedure TdxPDFViewerNavigationPanePageViewInfo.THeader.CreateCells;
begin
  inherited CreateCells;
  FCaption := AddCell(TCaptionText) as TCaptionText;
  FMinimizeButton := AddCell(TMinimizeButton) as TMinimizeButton;
  FMaximizeButton := AddCell(TMaximizeButton) as TMaximizeButton;
  FCaption.OnGetText := OnGetText;
end;

procedure TdxPDFViewerNavigationPanePageViewInfo.THeader.DoCalculate;
var
  AContentBounds: TRect;
begin
  inherited DoCalculate;
  AContentBounds := GetContentBounds;
  AlignToRightSide(FMaximizeButton, AContentBounds);
  AlignToRightSide(FMinimizeButton, AContentBounds);
  AlignToClient(FCaption, AContentBounds);
end;

procedure TdxPDFViewerNavigationPanePageViewInfo.THeader.DrawBackground(ACanvas: TcxCanvas);
begin
  Painter.DrawNavigationPanePageCaptionBackground(ACanvas, Bounds);
end;

{ TdxPDFViewerBookmarksPageViewInfo }

function TdxPDFViewerBookmarksPageViewInfo.GetOutlineTreeView: TdxPDFViewerBookmarkTreeView;
begin
  Result := Viewer.Bookmarks.Tree;
end;

function TdxPDFViewerBookmarksPageViewInfo.GetToolbarClass: TdxPDFViewerCellViewInfoClass;
begin
  Result := TBookmarksToolBar;
end;

procedure TdxPDFViewerBookmarksPageViewInfo.CreateCells;
begin
  inherited CreateCells;
  FToolBar := AddCell(TBookmarksToolBar) as TBookmarksToolBar;
end;

procedure TdxPDFViewerBookmarksPageViewInfo.DoCalculate;
begin
  inherited DoCalculate;
  Tree.Bounds := FActualContentBounds;
  Tree.UpdateTextSize;
end;

{ TdxPDFViewerThumbnailsPageViewInfo }

function TdxPDFViewerThumbnailsPageViewInfo.GetPreview: TdxPDFViewerPageThumbnailPreview;
begin
  Result := Viewer.Thumbnails.ThumbnailPreview;
end;

function TdxPDFViewerThumbnailsPageViewInfo.GetZoomTrackBar: TcxTrackBar;
begin
  Result := Viewer.Thumbnails.SizeTrackBar;
end;

function TdxPDFViewerThumbnailsPageViewInfo.GetToolbarClass: TdxPDFViewerCellViewInfoClass;
begin
  Result := TThumbnailsToolBar;
end;

procedure TdxPDFViewerThumbnailsPageViewInfo.DoCalculate;

  procedure CalculateZoomTrackBarBounds;
  var
    ABounds, AContentBounds: TRect;
  begin
    AContentBounds := cxRectSetRight(FToolBar.ActualContentBounds, FToolBar.ActualContentBounds.Right, ScaleFactor.Apply(196));
    ABounds := cxRectCenterVertically(AContentBounds, AContentBounds.Height);
    if FToolBar.ActualContentBounds.Width < ABounds.Width then
      ABounds := cxNullRect;
    if not cxRectIsEqual(Viewer.Thumbnails.SizeTrackBar.BoundsRect, ABounds) then
    begin
      Viewer.Thumbnails.SizeTrackBar.BoundsRect := ABounds;
      Viewer.Thumbnails.SizeTrackBar.Visible := not cxRectIsEmpty(Viewer.Thumbnails.SizeTrackBar.BoundsRect);
    end;
  end;

begin
  inherited DoCalculate;
  Preview.Bounds := FActualContentBounds;
  CalculateZoomTrackBarBounds;
end;

{ TdxPDFViewerThumbnailsPageViewInfo.TThumbnailsToolBar }

function TdxPDFViewerThumbnailsPageViewInfo.TThumbnailsToolBar.GetPopupMenuClass: TComponentClass;
begin
  Result := TdxPDFViewerThumbnailsPopupMenu;
end;

{ TdxPDFViewerAttachmentsPageViewInfo }

function TdxPDFViewerAttachmentsPageViewInfo.GetFileList: TdxPDFViewerAttachmentFileList;
begin
  Result := Viewer.Attachments.FileList;
end;

function TdxPDFViewerAttachmentsPageViewInfo.GetToolbarClass: TdxPDFViewerCellViewInfoClass;
begin
  Result := TAttachmentsToolBar;
end;

procedure TdxPDFViewerAttachmentsPageViewInfo.DoCalculate;
begin
  inherited DoCalculate;
  FileList.Bounds := FActualContentBounds;
end;

{ TdxPDFViewerAttachmentsPageViewInfo.TAttachmentsToolBar }

function TdxPDFViewerAttachmentsPageViewInfo.TAttachmentsToolBar.GetPopupMenuClass: TComponentClass;
begin
  Result := nil;
end;

function TdxPDFViewerAttachmentsPageViewInfo.TAttachmentsToolBar.HasOptionsButton: Boolean;
begin
  Result := False;
end;

procedure TdxPDFViewerAttachmentsPageViewInfo.TAttachmentsToolBar.CreateCells;
begin
  inherited CreateCells;
  FOpenButton := AddCell(TOpenButton) as TOpenButton;
  FSaveButton := AddCell(TSaveButton) as TSaveButton;
end;

procedure TdxPDFViewerAttachmentsPageViewInfo.TAttachmentsToolBar.DoCalculate;
var
  AContentBounds: TRect;
begin
  inherited DoCalculate;
  AContentBounds := ActualContentBounds;
  AlignToLeftSide(FOpenButton, AContentBounds);
  AlignToLeftSide(FSaveButton, AContentBounds);
end;

{ TdxPDFViewerAttachmentsPageViewInfo.TOpenButton }

function TdxPDFViewerAttachmentsPageViewInfo.TOpenButton.GetColorizeGlyph: Boolean;
begin
  Result := False;
end;

function TdxPDFViewerAttachmentsPageViewInfo.TOpenButton.GetGlyph: TdxSmartGlyph;
begin
  Result := Viewer.Attachments.OpenAttachmentGlyph;
end;

function TdxPDFViewerAttachmentsPageViewInfo.TOpenButton.GetHint: string;
begin
  Result := cxGetResourceString(@sdxPDFViewerNavigationPageOpenAttachmentButtonHint);
end;

function TdxPDFViewerAttachmentsPageViewInfo.TOpenButton.IsEnabled: Boolean;
begin
  Result := Viewer.Attachments.HasAttachments;
end;

procedure TdxPDFViewerAttachmentsPageViewInfo.TOpenButton.DoExecute;
begin
  Viewer.Attachments.OpenAttachment;
end;

procedure TdxPDFViewerAttachmentsPageViewInfo.TOpenButton.DrawButtonBackground(ACanvas: TcxCanvas; const ARect: TRect;
  AState: TcxButtonState);
begin
  if AState in [cxbsHot, cxbsPressed] then
    Painter.DrawButtonBackground(ACanvas, ARect, AState);
end;

{ TdxPDFViewerAttachmentsPageViewInfo.TSaveButton }

function TdxPDFViewerAttachmentsPageViewInfo.TSaveButton.GetColorizeGlyph: Boolean;
begin
  Result := False;
end;

function TdxPDFViewerAttachmentsPageViewInfo.TSaveButton.GetGlyph: TdxSmartGlyph;
begin
  Result := Viewer.Attachments.SaveAttachmentGlyph;
end;

function TdxPDFViewerAttachmentsPageViewInfo.TSaveButton.GetHint: string;
begin
  Result := cxGetResourceString(@sdxPDFViewerNavigationPageSaveAttachmentButtonHint);
end;

function TdxPDFViewerAttachmentsPageViewInfo.TSaveButton.IsEnabled: Boolean;
begin
  Result := Viewer.Attachments.HasAttachments;
end;

procedure TdxPDFViewerAttachmentsPageViewInfo.TSaveButton.DoExecute;
begin
  Viewer.Attachments.SaveAttachment;
end;

procedure TdxPDFViewerAttachmentsPageViewInfo.TSaveButton.DrawButtonBackground(ACanvas: TcxCanvas; const ARect: TRect;
  AState: TcxButtonState);
begin
  if AState in [cxbsHot, cxbsPressed] then
    Painter.DrawButtonBackground(ACanvas, ARect, AState);
end;

{ TdxPDFViewerPageThumbnailPreview }

function TdxPDFViewerPageThumbnailPreview.Locked: Boolean;
begin
  Result := FLockCount <> 0;
end;

procedure TdxPDFViewerPageThumbnailPreview.BeginUpdate;
begin
  Inc(FLockCount);
end;

procedure TdxPDFViewerPageThumbnailPreview.EndUpdate;
begin
  Dec(FLockCount);
end;

procedure TdxPDFViewerPageThumbnailPreview.PrintSelectedPages;
begin
  if Viewer.CanPrint then
    dxPrintingRepository.PrintReport(Viewer, Preview.GetPagesToPrint)
end;

procedure TdxPDFViewerPageThumbnailPreview.RotatePages;
begin
  Preview.SaveSelection;
  try
    ShowRotatePagesDialog(Viewer, Preview.GetSelectedPages);
  finally
    Preview.RestoreSelection;
  end;
end;

function TdxPDFViewerPageThumbnailPreview.GetEmpty: Boolean;
begin
  Result := False;
end;

procedure TdxPDFViewerPageThumbnailPreview.ClearInternalControl;
begin
  Preview.Clear;
end;

procedure TdxPDFViewerPageThumbnailPreview.CreateInternalControl;
begin
  FInternalControl := TdxPDFDocumentPageThumbnailViewer.Create(Viewer);
  InitializeInternalControl;
end;

procedure TdxPDFViewerPageThumbnailPreview.DestroySubClasses;
begin
  Viewer.RemoveFontListener(Preview);
  inherited DestroySubClasses;
end;

procedure TdxPDFViewerPageThumbnailPreview.InitializeInternalControl;
begin
  inherited InitializeInternalControl;
  LookAndFeel.MasterLookAndFeel := Viewer.LookAndFeel;
  Preview.BeginUpdate;
  try
    Preview.BorderStyle := cxcbsNone;
    Preview.OnSelectedPageChanged := OnSelectedPageChangedHandler;
  finally
    Preview.EndUpdate;
  end;
  Viewer.AddFontListener(Preview);
end;

procedure TdxPDFViewerPageThumbnailPreview.PopulateInternalControl;
begin
  Preview.Document := Viewer.Document as TdxPDFViewerDocument;
end;

procedure TdxPDFViewerPageThumbnailPreview.UpdateInternalControlTextSize;
begin
// do nothing
end;

function TdxPDFViewerPageThumbnailPreview.GetLookAndFeel: TcxLookAndFeel;
begin
  Result := Preview.LookAndFeel;
end;

function TdxPDFViewerPageThumbnailPreview.GetMaxSize: Integer;
begin
  Result := Preview.MaxSize;
end;

function TdxPDFViewerPageThumbnailPreview.GetMinSize: Integer;
begin
  Result := Preview.MinSize;
end;

function TdxPDFViewerPageThumbnailPreview.GetOnCustomDrawPreRenderPage: TdxPDFDocumentViewerOnCustomDrawPreRenderPageEvent;
begin
  Result := Preview.OnCustomDrawPreRenderPage;
end;

function TdxPDFViewerPageThumbnailPreview.GetOnSizeChanged: TNotifyEvent;
begin
  Result := Preview.OnThumbnailSizeChanged;
end;

function TdxPDFViewerPageThumbnailPreview.GetPreview: TThumbnailPreviewAccess;
begin
  Result := TThumbnailPreviewAccess(FInternalControl as TdxPDFDocumentPageThumbnailViewer);
end;

function TdxPDFViewerPageThumbnailPreview.GetSelectedPageIndex: Integer;
begin
  Result := Preview.SelPageIndex;
end;

function TdxPDFViewerPageThumbnailPreview.GetSize: Integer;
begin
  Result := Preview.Size;
end;


procedure TdxPDFViewerPageThumbnailPreview.SetMaxSize(const AValue: Integer);
begin
  Preview.MaxSize := AValue;
end;

procedure TdxPDFViewerPageThumbnailPreview.SetMinSize(const AValue: Integer);
begin
  Preview.MinSize := AValue;
end;

procedure TdxPDFViewerPageThumbnailPreview.SetOnCustomDrawPreRenderPage(
  const AValue: TdxPDFDocumentViewerOnCustomDrawPreRenderPageEvent);
begin
  Preview.OnCustomDrawPreRenderPage := AValue;
end;

procedure TdxPDFViewerPageThumbnailPreview.SetOnSizeChanged(const AValue: TNotifyEvent);
begin
  Preview.OnThumbnailSizeChanged := AValue;
end;

procedure TdxPDFViewerPageThumbnailPreview.SetSelectedPageIndex(const AValue: Integer);
begin
  if not Locked then
  begin
    BeginUpdate;
    try
      Preview.SelPageIndex := AValue;
      if not Preview.Focused then
        Viewer.DoSetFocus;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TdxPDFViewerPageThumbnailPreview.SetSize(const AValue: Integer);
begin
  Preview.Size := AValue;
end;

procedure TdxPDFViewerPageThumbnailPreview.OnSelectedPageChangedHandler(Sender: TObject; APageIndex: Integer);
begin
  if not Locked and not Viewer.IsScrolling then
  begin
    BeginUpdate;
    try
      Viewer.CurrentPageIndex := APageIndex;
    finally
      EndUpdate;
    end;
  end;
end;

{ TdxPDFViewerBookmarksPageViewInfo.TExpandBookmarkButton }

function TdxPDFViewerBookmarksPageViewInfo.TExpandBookmarkButton.GetColorizeGlyph: Boolean;
begin
  Result := False;
end;

function TdxPDFViewerBookmarksPageViewInfo.TExpandBookmarkButton.GetGlyph: TdxSmartGlyph;
begin
  Result := Viewer.Bookmarks.ExpandBookmarkGlyph;
end;

function TdxPDFViewerBookmarksPageViewInfo.TExpandBookmarkButton.GetHint: string;
begin
  Result := cxGetResourceString(@sdxPDFViewerNavigationPageExpandBookmarkButtonHint);
end;

function TdxPDFViewerBookmarksPageViewInfo.TExpandBookmarkButton.IsEnabled: Boolean;
begin
  Result := Viewer.Bookmarks.CanExpandCurrentBookmark;
end;

procedure TdxPDFViewerBookmarksPageViewInfo.TExpandBookmarkButton.DoExecute;
begin
  Viewer.Bookmarks.ExpandCurrentBookmark;
end;

procedure TdxPDFViewerBookmarksPageViewInfo.TExpandBookmarkButton.DrawButtonBackground(ACanvas: TcxCanvas; const ARect: TRect;
  AState: TcxButtonState);
begin
  if AState in [cxbsHot, cxbsPressed] then
    Painter.DrawButtonBackground(ACanvas, ARect, AState);
end;

{ TdxPDFViewerBookmarksPageViewInfo.TBookmarksToolBar }

function TdxPDFViewerBookmarksPageViewInfo.TBookmarksToolBar.GetPopupMenuClass: TComponentClass;
begin
  Result := TdxPDFViewerBookmarksPageOptionsPopupMenu;
end;

procedure TdxPDFViewerBookmarksPageViewInfo.TBookmarksToolBar.CreateCells;
begin
  inherited CreateCells;
  FExpandButton := AddCell(TExpandBookmarkButton) as  TExpandBookmarkButton;
end;

procedure TdxPDFViewerBookmarksPageViewInfo.TBookmarksToolBar.DoCalculate;
var
  AContentBounds: TRect;
begin
  inherited DoCalculate;
  AContentBounds := GetContentBounds;
  AlignToRightSide(FExpandButton, AContentBounds);
end;

{ TdxPDFViewerNavigationPaneViewInfo }

constructor TdxPDFViewerNavigationPaneViewInfo.Create(AController: TdxPDFViewerContainerController;
  ANavigationPane: TdxPDFViewerNavigationPane);
begin
  FNavigationPane := ANavigationPane;
  inherited Create(AController);
end;

function TdxPDFViewerNavigationPaneViewInfo.GetContentMargins: TRect;
begin
  Result := Painter.NavigationPaneContentOffsets;
end;

function TdxPDFViewerNavigationPaneViewInfo.GetIndentBetweenElements: Integer;
begin
  Result := 0;
end;

function TdxPDFViewerNavigationPaneViewInfo.MeasureWidth: Integer;
begin
  Result := GetButtonsWidth + GetPageWidth;
end;

procedure TdxPDFViewerNavigationPaneViewInfo.CalculateBounds(const ARect: TRect; out ABounds: TRect);
begin
  if FNavigationPane.CanShow then
  begin
    if FNavigationPane.IsMaximized then
      ABounds := ARect
    else
    begin
      ABounds := ARect;
      ABounds.Right := ABounds.Left + MeasureWidth
    end;
  end
  else
    ABounds := cxNullRect;
end;

procedure TdxPDFViewerNavigationPaneViewInfo.CalculateContent;
begin
  inherited CalculateContent;
  CalculateButtonsBounds;
  CalculatePagesBounds;
  CalculateSplitterBounds;
end;

procedure TdxPDFViewerNavigationPaneViewInfo.ClearCells;
begin
  inherited ClearCells;
  FPages.Clear;
  FPageButtons.Clear;
end;

procedure TdxPDFViewerNavigationPaneViewInfo.CreateSubClasses;
begin
  FPages := TList<TdxPDFViewerNavigationPanePageViewInfo>.Create;
  FPageButtons := TList<TdxPDFViewerNavigationPanePageButtonViewInfo>.Create;
  inherited CreateSubClasses;
end;

procedure TdxPDFViewerNavigationPaneViewInfo.CreateCells;
var
  I: Integer;
  APage: TdxPDFViewerNavigationPanePage;
  AVisiblePages: TList<TdxPDFViewerNavigationPanePage>;
begin
  inherited CreateCells;
  AVisiblePages := FNavigationPane.VisiblePages;
  for I := 0 to AVisiblePages.Count - 1 do
  begin
    APage := AVisiblePages[I];
    if APage.CanShow then
      AddPage(APage)
  end;
end;

procedure TdxPDFViewerNavigationPaneViewInfo.DestroySubClasses;
begin
  inherited DestroySubClasses;
  FreeAndNil(FPageButtons);
  FreeAndNil(FPages);
end;

procedure TdxPDFViewerNavigationPaneViewInfo.DrawBackground(ACanvas: TcxCanvas);
begin
  Painter.DrawNavigationPaneBackground(ACanvas, FButtonsBounds);
end;

procedure TdxPDFViewerNavigationPaneViewInfo.DrawChildren(ACanvas: TcxCanvas);
var
  APage: TdxPDFViewerNavigationPanePageViewInfo;
begin
  for APage in FPages do
  begin
    APage.Draw(ACanvas);
    if APage <> ActivePage then
      APage.Button.Draw(ACanvas);
  end;
  if (ActivePage <> nil) and (ActivePage.Button <> nil) then
    ActivePage.Button.Draw(ACanvas, True);
end;

function TdxPDFViewerNavigationPaneViewInfo.GetPageIndex(AButton: TdxPDFViewerNavigationPanePageButtonViewInfo): Integer;
begin
  Result := FPageButtons.IndexOf(AButton);
end;

function TdxPDFViewerNavigationPaneViewInfo.GetActivePage: TdxPDFViewerNavigationPanePageViewInfo;
begin
  if Viewer.NavigationPane.ActivePage <> nil then
    Result := Viewer.NavigationPane.ActivePage.ViewInfo
  else
    Result := nil;
end;

function TdxPDFViewerNavigationPaneViewInfo.GetButtonsWidth: Integer;
begin
  Result := ButtonMaxWidth + cxMarginsWidth(ContentMargins);
end;

function TdxPDFViewerNavigationPaneViewInfo.GetFirstPageButton: TdxPDFViewerNavigationPanePageButtonViewInfo;
begin
  if FPages.Count > 0 then
    Result := FPages.First.Button
  else
    Result := nil;
end;

function TdxPDFViewerNavigationPaneViewInfo.GetPageWidth: Integer;
begin
  Result := 0;
  if Viewer.NavigationPane.CanShow then
    case Viewer.NavigationPane.ActivePageState of
      wsNormal:
        if ActivePage <> nil then
          Result := ActivePage.MeasureWidth;
      wsMaximized:
        Result := Bounds.Width;
    else
      Result := 0;
    end;
end;

function TdxPDFViewerNavigationPaneViewInfo.ButtonMaxWidth: Integer;
begin
  if FirstPageButton <> nil then
    Result := FirstPageButton.MeasureWidth
  else
    Result := 0;
end;

procedure TdxPDFViewerNavigationPaneViewInfo.AddPage(APage: TdxPDFViewerNavigationPanePage);
var
  AViewInfo: TdxPDFViewerNavigationPanePageViewInfo;
begin
  AViewInfo := APage.CreateViewInfo;
  FPages.Add(AViewInfo);
  FPageButtons.Add(AViewInfo.Button);
  CellList.Add(AViewInfo);
  CellList.Add(AViewInfo.Button);
end;

procedure TdxPDFViewerNavigationPaneViewInfo.CalculateButtonsBounds;
var
  I: Integer;
  AContentBounds: TRect;
begin
  FButtonsBounds := cxRectSetWidth(Bounds, GetButtonsWidth);
  AContentBounds := cxRectContent(FButtonsBounds, ContentMargins);
  for I := 0 to FPages.Count - 1 do
    AlignToTopClientSide(FPages[I].Button, AContentBounds);
end;

procedure TdxPDFViewerNavigationPaneViewInfo.CalculatePagesBounds;
var
  AActivePage, APage: TdxPDFViewerNavigationPanePageViewInfo;
begin
  FPageBounds := cxNullRect;
  if GetPageWidth > 0 then
  begin
    FPageBounds := Bounds;
    FPageBounds.Left := FButtonsBounds.Right;
  end;
  AActivePage := ActivePage;
  for APage in FPages do
    if APage = AActivePage then
      APage.Bounds := FPageBounds
    else
      SetEmptyBounds(APage);
end;

procedure TdxPDFViewerNavigationPaneViewInfo.CalculateSplitterBounds;
const
  SplitterHotZone = 4;
begin
  if not cxRectIsEmpty(FPageBounds) and (Viewer.NavigationPane.ActivePageState = wsNormal) then
  begin
    FSplitterBounds := FPageBounds;
    FSplitterBounds.Left := FPageBounds.Right - ApplyScaleFactor(SplitterHotZone);
    FSplitterBounds.Right := FPageBounds.Right + ApplyScaleFactor(SplitterHotZone);
  end
  else
    FSplitterBounds := cxNullRect;
end;

{ TdxPDFViewerOptionsNavigationPage }

constructor TdxPDFViewerOptionsNavigationPage.Create(AOwner: TPersistent; APage: TdxPDFViewerNavigationPanePage);
begin
  inherited Create(AOwner);
  FPage := APage;
end;

procedure TdxPDFViewerOptionsNavigationPage.DoAssign(ASource: TPersistent);
begin
  inherited DoAssign(ASource);
  Visible := TdxPDFViewerOptionsNavigationPage(ASource).Visible;
end;

function TdxPDFViewerOptionsNavigationPage.GetGlyph: TdxSmartGlyph;
begin
  Result := FPage.Glyph;
end;

function TdxPDFViewerOptionsNavigationPage.GetVisible: TdxDefaultBoolean;
begin
  Result := FPage.Visible;
end;

procedure TdxPDFViewerOptionsNavigationPage.SetGlyph(const AValue: TdxSmartGlyph);
begin
  FPage.Glyph.Assign(AValue);
end;

procedure TdxPDFViewerOptionsNavigationPage.SetVisible(const AValue: TdxDefaultBoolean);
begin
  FPage.Visible := AValue;
end;

{ TdxPDFViewerOptionsBookmarks }

procedure TdxPDFViewerOptionsBookmarks.DoAssign(ASource: TPersistent);
var
  ASourceOptions: TdxPDFViewerOptionsBookmarks;
begin
  inherited DoAssign(ASource);
  ASourceOptions := ASource as TdxPDFViewerOptionsBookmarks;
  HideAfterUse := ASourceOptions.HideAfterUse;
  TextSize := ASourceOptions.TextSize;
end;

function TdxPDFViewerOptionsBookmarks.GetShowEmpty: Boolean;
begin
  Result := Visible = bTrue;
end;

procedure TdxPDFViewerOptionsBookmarks.SetHideAfterUse(const AValue: Boolean);
begin
  if FHideAfterUse <> AValue then
  begin
    FHideAfterUse := AValue;
    Changed;
  end;
end;

procedure TdxPDFViewerOptionsBookmarks.SetTextSize(const AValue: TdxPDFViewerBookmarksTextSize);
begin
  if FTextSize <> AValue then
  begin
    FTextSize := AValue;
    Changed;
  end;
end;

{ TdxPDFViewerNavigationPanePage }

procedure TdxPDFViewerNavigationPanePage.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FOptions := CreateOptions;
  FGlyph := TdxSmartGlyph.Create;
  FGlyph.OnChange := OnGlyphChangeHandler;
  LoadDefaultGlyphs;
  FVisible := bDefault;
  FControl := GetControlClass.Create(Viewer);
end;

procedure TdxPDFViewerNavigationPanePage.DestroySubClasses;
begin
  FreeAndNil(FGlyph);
  FreeAndNil(FDefaultGlyph);
  FreeAndNil(FOptions);
  FreeAndNil(FControl);
  inherited DestroySubClasses;
end;

function TdxPDFViewerNavigationPanePage.CanShow: Boolean;
begin
  Result := Options.Visible in [bTrue];
end;

function TdxPDFViewerNavigationPanePage.CreateOptions: TdxPDFViewerOptionsNavigationPage;
begin
  Result := TdxPDFViewerOptionsNavigationPage.Create(Viewer, Self);
end;

procedure TdxPDFViewerNavigationPanePage.SetBounds(const AValue: TRect);
begin
  FControl.Bounds := AValue;
end;

function TdxPDFViewerNavigationPanePage.IsFirst: Boolean;
begin
  Result := Viewer.NavigationPane.IsFirst(Self);
end;

procedure TdxPDFViewerNavigationPanePage.Clear;
begin
  FControl.Clear;
end;

procedure TdxPDFViewerNavigationPanePage.Refresh;
begin
  FControl.Refresh;
end;

function TdxPDFViewerNavigationPanePage.GetBounds: TRect;
begin
  Result := FControl.Bounds;
end;

function TdxPDFViewerNavigationPanePage.GetEmpty: Boolean;
begin
  Result := FControl.Empty;
end;

function TdxPDFViewerNavigationPanePage.GetGlyph: TdxSmartGlyph;
begin
  if IsImageAssigned(FGlyph) then
    Result := FGlyph
  else
    Result := FDefaultGlyph;
end;

procedure TdxPDFViewerNavigationPanePage.SetGlyph(const AValue: TdxSmartGlyph);
begin
  FGlyph.Assign(AValue);
end;

procedure TdxPDFViewerNavigationPanePage.SetOptions(const AValue: TdxPDFViewerOptionsNavigationPage);
begin
  FOptions.Assign(AValue);
end;

procedure TdxPDFViewerNavigationPanePage.SetVisible(const AValue: TdxDefaultBoolean);
begin
  if FVisible <> AValue then
  begin
    FVisible := AValue;
    Viewer.NavigationPane.VisibilityChanged(Self);
  end;
end;

procedure TdxPDFViewerNavigationPanePage.OnGlyphChangeHandler(Sender: TObject);
begin
  Viewer.NavigationPane.Changed;
end;

{ TdxPDFViewerThumbnails }

procedure TdxPDFViewerThumbnails.EnlargePageThumbnails;
begin
  FSizeTrackBar.Position := FSizeTrackBar.Position + dxPDFDocumentPageThumbnailViewerSizeStep;
end;

procedure TdxPDFViewerThumbnails.PrintPages;
begin
  ThumbnailPreview.PrintSelectedPages;
end;

procedure TdxPDFViewerThumbnails.ReducePageThumbnails;
begin
  FSizeTrackBar.Position := FSizeTrackBar.Position - dxPDFDocumentPageThumbnailViewerSizeStep;
end;

procedure TdxPDFViewerThumbnails.RotatePages;
begin
  ThumbnailPreview.RotatePages;
end;


function TdxPDFViewerThumbnails.CanShow: Boolean;
begin
  Result := inherited CanShow or (Options.Visible = bDefault);
end;

function TdxPDFViewerThumbnails.CreateOptions: TdxPDFViewerOptionsNavigationPage;
begin
  Result := TdxPDFViewerOptionsThumbnails.Create(Viewer, Self);
end;

function TdxPDFViewerThumbnails.CreateViewInfo: TdxPDFViewerNavigationPanePageViewInfo;
begin
  FViewInfo := TdxPDFViewerThumbnailsPageViewInfo.Create(Viewer.NavigationPane.Controller, Self);
  Result := FViewInfo;
end;

function TdxPDFViewerThumbnails.GetCaption: string;
begin
  Result := cxGetResourceString(@sdxPDFViewerNavigationPageThumbnailsCaption);
end;

function TdxPDFViewerThumbnails.GetControlClass: TdxPDFViewerNavigationPaneInternalControlClass;
begin
  Result := TdxPDFViewerPageThumbnailPreview;
end;

procedure TdxPDFViewerThumbnails.CreateSubClasses;

  procedure InitializeThumbnailPreview;
  var
    AThumbnailPreview: TdxPDFViewerPageThumbnailPreview;
  begin
    AThumbnailPreview := ThumbnailPreview;
    ThumbnailPreview.BeginUpdate;
    try
      AThumbnailPreview.MaxSize := dxPDFDocumentPageThumbnailViewerMaxSize;
      AThumbnailPreview.MinSize := dxPDFDocumentPageThumbnailViewerMinSize;
      AThumbnailPreview.Size := AThumbnailPreview.Size;
      AThumbnailPreview.OnSizeChanged := OnThumbnailSizeChangedHandler;
    finally
      AThumbnailPreview.EndUpdate;
    end;
  end;

begin
  inherited CreateSubClasses;
  InitializeThumbnailPreview;
  CreateSizeTrackBar;
end;

procedure TdxPDFViewerThumbnails.DestroySubClasses;
begin
  FreeAndNil(FSizeTrackBar);
  inherited DestroySubClasses;
end;

procedure TdxPDFViewerThumbnails.LoadDefaultGlyphs;
begin
  FDefaultGlyph := TdxPDFUtils.LoadGlyph('DX_PDFVIEWERTHUMBNAILSBUTTON', 'SVG');
end;

procedure TdxPDFViewerThumbnails.SetBounds(const AValue: TRect);
begin
  inherited SetBounds(AValue);
  SizeTrackBar.Visible := ThumbnailPreview.Visible;
end;

function TdxPDFViewerThumbnails.CanEnlargePageThumbnails: Boolean;
begin
  Result := FSizeTrackBar.Position < FSizeTrackBar.Properties.Max;
end;

function TdxPDFViewerThumbnails.CanReducePageThumbnails: Boolean;
begin
  Result := FSizeTrackBar.Position > FSizeTrackBar.Properties.Min;
end;

procedure TdxPDFViewerThumbnails.SynchronizeSelectedPage;
begin
  if FControl.Visible and not Viewer.IsVertScrollAnimationActive then
    ThumbnailPreview.SelectedPageIndex := Viewer.CurrentPageIndex;
end;

function TdxPDFViewerThumbnails.GetShowHints: Boolean;
begin
  Result := FSizeTrackBar.ShowHint;
end;

function TdxPDFViewerThumbnails.GetThumbnailPreview: TdxPDFViewerPageThumbnailPreview;
begin
  Result := FControl as TdxPDFViewerPageThumbnailPreview;
end;

procedure TdxPDFViewerThumbnails.SetShowHints(const AValue: Boolean);
begin
  FSizeTrackBar.ShowHint := AValue;
end;

procedure TdxPDFViewerThumbnails.CreateSizeTrackBar;
begin
  FSizeTrackBar := TcxTrackBar.Create(Viewer);
  FSizeTrackBar.Parent := Viewer;
  FSizeTrackBar.Visible := False;
  FSizeTrackBar.Hint := cxGetResourceString(@sdxPDFViewerNavigationPageThumbnailsSizeTrackBarHint);
  FSizeTrackBar.ShowHint := Viewer.OptionsBehavior.ShowHints;
  FSizeTrackBar.Style.BeginUpdate;
  try
    FSizeTrackBar.Style.LookAndFeel.MasterLookAndFeel := Viewer.LookAndFeel;
    FSizeTrackBar.Style.BorderStyle := ebsNone;
  finally
    FSizeTrackBar.Style.EndUpdate;
  end;
  try
    FSizeTrackBar.Properties.BeginUpdate;
    FSizeTrackBar.Properties.ShowChangeButtons := True;
    FSizeTrackBar.Properties.ShowTicks := False;
    FSizeTrackBar.Properties.ThumbStep := cxtsJump;
    FSizeTrackBar.Properties.Max := ThumbnailPreview.MaxSize;
    FSizeTrackBar.Properties.Min := ThumbnailPreview.MinSize;
    FSizeTrackBar.Properties.LineSize := dxPDFDocumentPageThumbnailViewerSizeStep;
  finally
    FSizeTrackBar.Properties.EndUpdate;
  end;
  FSizeTrackBar.Position := FSizeTrackBar.Properties.Min + 1;
  FSizeTrackBar.Properties.OnEditValueChanged := OnSizeChangedHandler;
  FSizeTrackBar.Position := FSizeTrackBar.Properties.Min;
  FSizeTrackBar.Transparent := True;
end;

procedure TdxPDFViewerThumbnails.OnSizeChangedHandler(Sender: TObject);
begin
  ThumbnailPreview.Size := FSizeTrackBar.Position;
end;

procedure TdxPDFViewerThumbnails.OnThumbnailSizeChangedHandler(Sender: TObject);
begin
  SizeTrackBar.Position := ThumbnailPreview.Size;
end;

{ TdxPDFViewerOptionsNavigationPane }

procedure TdxPDFViewerOptionsNavigationPane.DoAssign(ASource: TPersistent);
var
  ASourceOptions: TdxPDFViewerOptionsNavigationPane;
begin
  inherited DoAssign(ASource);
  ASourceOptions := ASource as TdxPDFViewerOptionsNavigationPane;
  ActivePageState := ASourceOptions.ActivePageState;
  Bookmarks.Assign(ASourceOptions.Bookmarks);
  Thumbnails.Assign(ASourceOptions.Thumbnails);
  Visible := ASourceOptions.Visible;
end;

procedure TdxPDFViewerOptionsNavigationPane.SetActivePageState(const AValue: TWindowState);
begin
  Viewer.NavigationPane.ActivePageState := AValue;
end;

procedure TdxPDFViewerOptionsNavigationPane.SetAttachments(const AValue: TdxPDFViewerOptionsAttachments);
begin
  Viewer.NavigationPane.Attachments.Options := AValue;
end;

procedure TdxPDFViewerOptionsNavigationPane.SetBookmarks(const AValue: TdxPDFViewerOptionsBookmarks);
begin
  Viewer.NavigationPane.Bookmarks.Options := AValue;
end;

procedure TdxPDFViewerOptionsNavigationPane.SetThumbnails(const AValue: TdxPDFViewerOptionsThumbnails);
begin
  Viewer.NavigationPane.Thumbnails.Options := AValue;
end;

function TdxPDFViewerOptionsNavigationPane.GetActivePage: TdxPDFViewerNavigationPaneActivePage;
begin
  Result := Viewer.NavigationPane.ActivePageType;
end;

function TdxPDFViewerOptionsNavigationPane.GetActivePageState: TWindowState;
begin
  Result := Viewer.NavigationPane.ActivePageState;
end;

function TdxPDFViewerOptionsNavigationPane.GetAttachments: TdxPDFViewerOptionsAttachments;
begin
  Result := Viewer.NavigationPane.Attachments.Options as TdxPDFViewerOptionsAttachments;
end;

function TdxPDFViewerOptionsNavigationPane.GetBookmarks: TdxPDFViewerOptionsBookmarks;
begin
  Result := Viewer.NavigationPane.Bookmarks.Options as TdxPDFViewerOptionsBookmarks;
end;

function TdxPDFViewerOptionsNavigationPane.GetThumbnails: TdxPDFViewerOptionsThumbnails;
begin
  Result := Viewer.NavigationPane.Thumbnails.Options as TdxPDFViewerOptionsThumbnails;
end;

procedure TdxPDFViewerOptionsNavigationPane.SetActivePage(const AValue: TdxPDFViewerNavigationPaneActivePage);
begin
  Viewer.NavigationPane.ActivePageType := AValue;
end;

procedure TdxPDFViewerOptionsNavigationPane.SetVisible(const AValue: Boolean);
begin
  if FVisible <> AValue then
  begin
    FVisible := AValue;
    Changed(ctLight);
  end;
end;

{ TdxPDFViewerBookmarks }

procedure TdxPDFViewerBookmarks.ExpandCollapseTopLevelBookmarks;
begin
  Tree.ExpandCollapseTopLevelBookmarks;
end;

procedure TdxPDFViewerBookmarks.ExpandCurrentBookmark;
begin
  Tree.ExpandCurrentBookmark;
end;

procedure TdxPDFViewerBookmarks.GoToBookmark;
begin
  Tree.GoToBookmark;
end;

procedure TdxPDFViewerBookmarks.PrintPages;
begin
  Tree.PrintSelectedPages(False);
end;

procedure TdxPDFViewerBookmarks.PrintSections;
begin
  Tree.PrintSelectedPages(True);
end;

function TdxPDFViewerBookmarks.CanShow: Boolean;
begin
  Result := inherited CanShow or ((Options.Visible = bDefault) and not Empty);
end;

function TdxPDFViewerBookmarks.CreateOptions: TdxPDFViewerOptionsNavigationPage;
begin
  Result := TdxPDFViewerOptionsBookmarks.Create(Viewer, Self);
end;

function TdxPDFViewerBookmarks.CreateViewInfo: TdxPDFViewerNavigationPanePageViewInfo;
begin
  FViewInfo := TdxPDFViewerBookmarksPageViewInfo.Create(Viewer.NavigationPane.Controller, Self);
  Result := FViewInfo;
end;

function TdxPDFViewerBookmarks.GetCaption: string;
begin
  Result := cxGetResourceString(@sdxPDFViewerNavigationPageBookmarksCaption);
end;

function TdxPDFViewerBookmarks.GetControlClass: TdxPDFViewerNavigationPaneInternalControlClass;
begin
  Result := TdxPDFViewerBookmarkTreeView;
end;

procedure TdxPDFViewerBookmarks.DestroySubClasses;
begin
  FreeAndNil(FExpandBookmarkGlyph);
  inherited DestroySubClasses;
end;

procedure TdxPDFViewerBookmarks.LoadDefaultGlyphs;
begin
  FDefaultGlyph := TdxPDFUtils.LoadGlyph('DX_PDFVIEWERBOOKMARKSBUTTON', 'SVG');
  FExpandBookmarkGlyph := TdxPDFUtils.LoadGlyph('DX_PDFVIEWEREXPANDBOOKMARKBUTTON', IfThen(dxUseVectorIcons, 'SVG', 'PNG'));
end;

function TdxPDFViewerBookmarks.CanExpandCurrentBookmark: Boolean;
begin
  Result := Tree.CanExpandSelectedBookmark;
end;

function TdxPDFViewerBookmarks.IsBookmarkSelected: Boolean;
begin
  Result := Tree.IsBookmarkSelected;
end;

function TdxPDFViewerBookmarks.IsTopLevelBookmarksExpanded: Boolean;
begin
  Result := Tree.IsTopLevelBookmarksExpanded;
end;

function TdxPDFViewerBookmarks.GetTree: TdxPDFViewerBookmarkTreeView;
begin
  Result := FControl as TdxPDFViewerBookmarkTreeView;
end;

{ TdxPDFViewerAttachments }

function TdxPDFViewerAttachments.HasAttachments: Boolean;
begin
  Result := FileList.View.FocusedItem <> nil;
end;

procedure TdxPDFViewerAttachments.OpenAttachment;
begin
  Viewer.OpenAttachment(GetSelectedAttachment);
end;

procedure TdxPDFViewerAttachments.SaveAttachment;
begin
  Viewer.SaveAttachment(GetSelectedAttachment);
end;

function TdxPDFViewerAttachments.CanShow: Boolean;
begin
  Result := inherited CanShow or ((Options.Visible = bDefault) and not Empty);
end;

function TdxPDFViewerAttachments.CreateOptions: TdxPDFViewerOptionsNavigationPage;
begin
  Result := TdxPDFViewerOptionsAttachments.Create(Viewer, Self);
end;

function TdxPDFViewerAttachments.CreateViewInfo: TdxPDFViewerNavigationPanePageViewInfo;
begin
  FViewInfo := TdxPDFViewerAttachmentsPageViewInfo.Create(Viewer.NavigationPane.Controller, Self);
  Result := FViewInfo;
end;

function TdxPDFViewerAttachments.GetCaption: string;
begin
  Result := cxGetResourceString(@sdxPDFViewerNavigationPageAttachmentsCaption);
end;

function TdxPDFViewerAttachments.GetControlClass: TdxPDFViewerNavigationPaneInternalControlClass;
begin
  Result := TdxPDFViewerAttachmentFileList;
end;

procedure TdxPDFViewerAttachments.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FShowHints := Viewer.OptionsBehavior.ShowHints;
end;

procedure TdxPDFViewerAttachments.DestroySubClasses;
begin
  FreeAndNil(FSaveAttachmentGlyph);
  FreeAndNil(FOpenAttachmentGlyph);
  inherited DestroySubClasses;
end;

procedure TdxPDFViewerAttachments.LoadDefaultGlyphs;
begin
  FDefaultGlyph := TdxPDFUtils.LoadGlyph('DX_PDFVIEWERATTACHMENTSBUTTON', 'SVG');
  FOpenAttachmentGlyph := TdxPDFUtils.LoadGlyph('DX_PDFVIEWERATTACHMENTOPENBUTTON', IfThen(dxUseVectorIcons, 'SVG', 'PNG'));
  FSaveAttachmentGlyph := TdxPDFUtils.LoadGlyph('DX_PDFVIEWERATTACHMENTSAVEBUTTON', IfThen(dxUseVectorIcons, 'SVG', 'PNG'));
end;

function TdxPDFViewerAttachments.GetFileList: TdxPDFViewerAttachmentFileList;
begin
  Result := FControl as TdxPDFViewerAttachmentFileList;
end;

function TdxPDFViewerAttachments.GetSelectedAttachment: TdxPDFFileAttachment;
begin
  if FileList.View.FocusedItem <> nil then
    Result := TObject(FileList.View.FocusedItem.Data) as TdxPDFFileAttachment
  else
    Result := nil;
end;

procedure TdxPDFViewerAttachments.SetShowHints(const AValue: Boolean);
begin
  if FShowHints <> AValue then
  begin
    FShowHints := AValue;
    FileList.ShowHint := FShowHints;
  end;
end;

{ TdxPDFViewerNavigationPane }

constructor TdxPDFViewerNavigationPane.Create(AViewer: TdxPDFCustomViewer);
begin
  inherited Create;
  FViewer := AViewer;
  FViewer.AddFontListener(Self);
  LoadGlyphs;
  FActivePage := nil;
  FActivePageState := wsMinimized;
  FPageSize := FViewer.ScaleFactor.Apply(300);
  FPrevActivePageState := wsNormal;
  FActivePageState := wsMinimized;
  FFont := TFont.Create;
  FFont.Assign(FViewer.Font);
  FHitTest := TdxPDFViewerNavigationPaneHitTest.Create(FViewer);
  FOptions := TdxPDFViewerOptionsNavigationPane.Create(FViewer);
  FController := TdxPDFViewerNavigationPaneController.Create(FViewer);
  FVisiblePages := TList<TdxPDFViewerNavigationPanePage>.Create;
  FShowHints := FViewer.OptionsBehavior.ShowHints;
end;

destructor TdxPDFViewerNavigationPane.Destroy;
begin
  FViewer.RemoveFontListener(Self);
  FreeAndNil(FVisiblePages);
  FreeAndNil(FViewInfo);
  FreeAndNil(FPages);
  FreeAndNil(FController);
  FreeAndNil(FRestoreButtonGlyph);
  FreeAndNil(FMinimizeButtonGlyph);
  FreeAndNil(FMenuButtonGlyph);
  FreeAndNil(FMaximizeButtonGlyph);
  FreeAndNil(FOptions);
  FreeAndNil(FHitTest);
  FreeAndNil(FFont);
  inherited Destroy;
end;

function TdxPDFViewerNavigationPane.CanShow: Boolean;
var
  APage: TdxPDFViewerNavigationPanePage;
begin
  Result := False;
  if FViewer.IsDocumentAvailable and FOptions.Visible then
    for APage in Pages do
    begin
      Result := APage.CanShow;
      if Result then
       Break;
     end;
end;

function TdxPDFViewerNavigationPane.CalculateParentClientBounds(const AClientRect: TRect): TRect;
begin
  if IsMaximized then
    Result := cxNullRect
  else
  begin
    Result := AClientRect;
    Result.Left := Result.Left + MeasureWidth;
    if Result.Left >= Result.Right + FViewer.VScrollBar.Width then
      Result := cxNullRect;
  end;
end;

function TdxPDFViewerNavigationPane.IsFirst(APage: TdxPDFViewerNavigationPanePage): Boolean;
begin
  Result := FVisiblePages.IndexOf(APage) = 0;
end;

function TdxPDFViewerNavigationPane.IsVisible(APage: TdxPDFViewerNavigationPanePage): Boolean;
begin
  Result := FVisiblePages.Contains(APage);
end;

function TdxPDFViewerNavigationPane.IsMaximized: Boolean;
begin
  Result := ActivePageState = wsMaximized;
end;

function TdxPDFViewerNavigationPane.MeasureWidth: Integer;
begin
  Result := FViewInfo.MeasureWidth;
end;

procedure TdxPDFViewerNavigationPane.AddPages;
begin
  FBookmarks := TdxPDFViewerBookmarks.Create(FViewer);
  FThumbnails := TdxPDFViewerThumbnails.Create(FViewer);
  FAttachments := TdxPDFViewerAttachments.Create(FViewer);

  FPages := TObjectList<TdxPDFViewerNavigationPanePage>.Create;
  FPages.Add(FThumbnails);
  FPages.Add(FBookmarks);
  FPages.Add(FAttachments);

  UpdateVisiblePages;

  FViewInfo := TdxPDFViewerNavigationPaneViewInfo.Create(FController, Self);
end;

procedure TdxPDFViewerNavigationPane.ActivatePage;
begin
  if ActivePageState = wsMinimized then
    ActivePageState := FPrevActivePageState
  else
    MinimizePage;
end;

procedure TdxPDFViewerNavigationPane.Changed;
begin
  FViewer.ViewInfo.LockRecreateCells;
  FViewer.LayoutChanged;
  Thumbnails.SynchronizeSelectedPage;
  FViewer.ViewInfo.UnLockRecreateCells;
end;

procedure TdxPDFViewerNavigationPane.Clear;
begin
  Controller.Clear;
end;

procedure TdxPDFViewerNavigationPane.MaximizePage;
begin
  if IsMaximized then
    RestorePage
  else
    ActivePageState := wsMaximized;
end;

procedure TdxPDFViewerNavigationPane.MinimizePage;
begin
  ActivePageState := wsMinimized;
end;

procedure TdxPDFViewerNavigationPane.RestorePage;
begin
  if ActivePage <> nil then
    ActivePageState := wsNormal
  else
    ActivePageState := wsMinimized;
end;

procedure TdxPDFViewerNavigationPane.Refresh(ASaveActivePageState: Boolean = False);
begin
  Changed;
  Controller.Refresh;
  if ActivePage <> nil then
  begin
    if ASaveActivePageState then
      RestorePage
    else
      MinimizePage;
  end;
end;

procedure TdxPDFViewerNavigationPane.VisibilityChanged(APage: TdxPDFViewerNavigationPanePage);
begin
  UpdateVisiblePages;
  if (ActivePage = APage) and not APage.CanShow then
    ActivePageType := apNone;
  Changed;
end;

function TdxPDFViewerNavigationPane.GetActivePageType: TdxPDFViewerNavigationPaneActivePage;
begin
  if ActivePage = nil then
    Result := apNone
  else
    if ActivePage = Bookmarks then
      Result := apBookmarks
    else
      if ActivePage = Attachments then
        Result := apAttachments
      else
        Result := apThumbnails;
end;

function TdxPDFViewerNavigationPane.GetMaximizeButtonGlyph: TdxSmartGlyph;
begin
  if IsMaximized then
    Result := RestoreButtonGlyph
  else
    Result := FMaximizeButtonGlyph;
end;

function TdxPDFViewerNavigationPane.GetVisiblePages: TList<TdxPDFViewerNavigationPanePage>;
begin
  UpdateVisiblePages;
  Result := FVisiblePages;
end;

procedure TdxPDFViewerNavigationPane.SetActivePage(const AValue: TdxPDFViewerNavigationPanePage);
begin
  if FActivePage <> AValue then
  begin
    FActivePage := AValue;
    if ActivePageState = wsMinimized then
      ActivePageState := wsNormal;
    Changed;
  end
  else
    ActivatePage;
end;

procedure TdxPDFViewerNavigationPane.SetActivePageType(const AValue: TdxPDFViewerNavigationPaneActivePage);
var
  APage: TdxPDFViewerNavigationPanePage;
begin
  APage := nil;
  case AValue of
    apBookmarks:
      if Bookmarks.CanShow then
        APage := Bookmarks;
    apThumbnails:
      if Thumbnails.CanShow then
        APage := Thumbnails;
    apAttachments:
      if Attachments.CanShow then
        APage := Attachments;
  end;
  ActivePage := APage;
end;

procedure TdxPDFViewerNavigationPane.SetActivePageState(const AValue: TWindowState);
begin
  if FActivePageState <> AValue then
  begin
    FPrevActivePageState := FActivePageState;
    if ActivePageType = apNone then
      FActivePageState := wsMinimized
    else
      FActivePageState := AValue;
    Changed;
  end;
end;

procedure TdxPDFViewerNavigationPane.SetOptions(const AValue: TdxPDFViewerOptionsNavigationPane);
begin
  FOptions.Assign(AValue);
end;

procedure TdxPDFViewerNavigationPane.SetPageSize(const AValue: Integer);
begin
  if FPageSize <> AValue then
  begin
    FPageSize := AValue;
    Changed;
    FViewer.MakeVisible(FViewer.CurrentPageIndex);
  end;
end;

procedure TdxPDFViewerNavigationPane.SetShowHints(const AValue: Boolean);
begin
  if FShowHints <> AValue then
  begin
    FShowHints := AValue;
    Attachments.ShowHints := ShowHints;
    Thumbnails.ShowHints := ShowHints;
  end;
end;

procedure TdxPDFViewerNavigationPane.Changed(Sender: TObject; AFont: TFont);
begin
  FFont.Assign(AFont);
  FFont.Style := [fsBold];
end;

procedure TdxPDFViewerNavigationPane.LoadGlyphs;
var
  ResourseKind: string;
begin
  ResourseKind := IfThen(dxUseVectorIcons, 'SVG', 'PNG');
  FMaximizeButtonGlyph := TdxPDFUtils.LoadGlyph('DX_PDFVIEWERMAXIMIZEBUTTON', ResourseKind);
  FMenuButtonGlyph := TdxPDFUtils.LoadGlyph('DX_PDFVIEWERMENUBUTTON', ResourseKind);
  FMinimizeButtonGlyph := TdxPDFUtils.LoadGlyph('DX_PDFVIEWERMINIMIZEBUTTON', ResourseKind);
  FRestoreButtonGlyph := TdxPDFUtils.LoadGlyph('DX_PDFVIEWERRESTOREBUTTON', ResourseKind);
end;

procedure TdxPDFViewerNavigationPane.UpdateVisiblePages;
var
  I: Integer;
  APage: TdxPDFViewerNavigationPanePage;
begin
  FVisiblePages.Clear;
  for I := 0 to FPages.Count - 1 do
  begin
    APage := FPages[I];
    if APage.CanShow then
      FVisiblePages.Add(APage)
    else
      APage.Bounds := cxNullRect;
  end;
end;




initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxRegisterCursor(crdxPDFViewerContext, HInstance, 'DXPDFVIEWER_CONTEXT');
  dxRegisterCursor(crdxPDFViewerCross, HInstance, 'DXPDFVIEWER_CROSS');

  dxPDFViewerRegisterDocumentObjectViewInfo(TdxPDFImage, TdxPDFViewerImageViewInfo);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxPDFViewerUnregisterDocumentObjectViewInfo(TdxPDFImage);

  FreeAndNil(dxgPDFViewerDocumentObjectViewInfoDictionary);
  dxUnregisterCursor(crdxPDFViewerContext);
  dxUnregisterCursor(crdxPDFViewerCross);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
