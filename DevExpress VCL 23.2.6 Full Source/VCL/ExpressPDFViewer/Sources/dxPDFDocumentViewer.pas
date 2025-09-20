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

unit dxPDFDocumentViewer;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Types, SysUtils, Classes, Controls, Windows, Graphics, Generics.Defaults, Generics.Collections, dxCoreClasses,
  cxGraphics, cxGeometry, dxGenerics, cxClasses, cxControls, cxLookAndFeels, dxCustomPreview, dxPDFBase, dxPDFCore,
  dxPDFDocument, dxPDFCommandInterpreter, dxPDFDocumentState;

const
  dxPDFDocumentPageThumbnailViewerMaxSize = 1000;
  dxPDFDocumentPageThumbnailViewerMinSize = 160;
  dxPDFDocumentPageThumbnailViewerSizeStep = 50;
  dxPDFDocumentViewerDefaultRenderContentDelay = 100;

type
  TdxPDFDocumentCustomViewer = class;
  TdxPDFDocumentCustomViewerPage = class;
  TdxPDFDocumentPageThumbnailViewer = class;

  TdxPDFDocumentViewerOnCancelRendering = procedure(Sender: TObject; const APageIndexes: TIntegerDynArray) of object;
  TdxPDFDocumentViewerOnGetRenderFactor = function(APageIndex: Integer): Single of object;

  TdxPDFDocumentViewerCachePageInfo = class // for internal use
  public
    Index: Integer;
    Factor: Single;
  end;

  TdxPDFPreRenderPageInfo = record
    Bounds: TRect;
    PageIndex: Integer;
    Scale: Single;
    Thumbnail: TBitmap;
  end;

  TdxPDFDocumentViewerOnCustomDrawPreRenderPageEvent = procedure(Sender: TObject; ACanvas: TcxCanvas;
    const APageInfo: TdxPDFPreRenderPageInfo; var ADone: Boolean) of object;

  { TdxPDFDocumentViewerCacheStorage }

  TdxPDFDocumentViewerCacheStorage = class // for internal use
  strict private type
  {$REGION 'internal types'}
    { TCacheItem }

    TCacheItem = class
    public
      Bitmap: TBitmap;
      Factor: Single;
      constructor Create(ABitmap: TBitmap; AFactor: Single);
      destructor Destroy; override;
    end;

    { TCache }

    TCache = class
    strict private
      FDictionary: TdxPDFIntegerObjectDictionary<TCacheItem>;
      FLimit: Int64;
      FQueue: TdxIntegerList;
      FSize: Int64;
      function GetSize(AValue: TBitmap): Int64;
      procedure CheckSize;
    protected
      function TryGetValue(APageIndex: Integer; out ABitmap: TBitmap): Boolean; overload;
      function TryGetValue(APageIndex: Integer; out ACache: TCacheItem): Boolean; overload;
      function TryGetValue(APageIndex: Integer; AFactor: Single; out ACache: TCacheItem): Boolean; overload;
      procedure Add(APageIndex: Integer; ACache: TCacheItem);
      procedure Clear; overload;
      procedure Remove(APageIndex: Integer);
    public
      constructor Create(ALimit: Int64);
      destructor Destroy; override;
    end;
  {$ENDREGION}
  strict private
    FCacheInfos: TDictionary<Integer, Single>;
    FCacheVisiblePagesOnly: Boolean;
    FContainer: TdxPDFIntegerObjectDictionary<TCacheItem>;
    procedure SetCacheVisiblePagesOnly(const AValue: Boolean);
    procedure AddThumbnail(APageIndex: Integer; ACache: TCacheItem);
  protected
    FThumbnails: TCache;
    OnCancelRendering: TdxPDFDocumentViewerOnCancelRendering;
    function CheckThumbnails(APageIndex: Integer; AFactor: Single): Boolean;
    function Contains(APageIndex: Integer; AFactor: Single): Boolean;
    function ContainsThumbnail(APageIndex: Integer; AFactor: Single): Boolean;
    function CreateCache(ABitmap: TBitmap; AFactor: Single): TCacheItem;
    function GetBitmap(APageIndex: Integer): TBitmap;
    function GetThumbnail(APageIndex: Integer): TBitmap;
    procedure Add(APageIndex: Integer; AFactor: Single; ABitmap: TBitmap);
    procedure Clear;
    procedure Remove(APageIndex: Integer; AForceAddThumbnail: Boolean);
    procedure SetVisiblePages(APages: TList<TdxPDFDocumentViewerCachePageInfo>);

    property CacheVisiblePagesOnly: Boolean read FCacheVisiblePagesOnly write SetCacheVisiblePagesOnly;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  { TdxPDFRenderTaskInfo }

  TdxPDFRenderTaskInfo = record // for internal use
    Factor: Single;
    PageIndex: Integer;
    class function Create(APageIndex: Integer; AFactor: Single): TdxPDFRenderTaskInfo; static;
  end;

  { TdxPDFDocumentViewerCustomRenderer }

  TdxPDFDocumentViewerCustomRendererClass = class of TdxPDFDocumentViewerCustomRenderer;
  TdxPDFDocumentViewerCustomRenderer = class
  strict private
    FEndVisiblePageIndex: Integer;
    FNeedPackDocumentContent: Boolean;
    FQueue: TQueue<TdxPDFRenderTaskInfo>;
    FStartVisiblePageIndex: Integer;
    FStorage: TdxPDFDocumentViewerCacheStorage;
    FTimer: TcxTimer;
    FViewer: TdxPDFDocumentCustomViewer;
    //
    FOnGetRenderFactor: TdxPDFDocumentViewerOnGetRenderFactor;
    //
    function GetCacheVisiblePagesOnly: Boolean;
    procedure SetCacheVisiblePagesOnly(const AValue: Boolean);
    //
    function CreatePageInfo(APageIndex: Integer): TdxPDFDocumentViewerCachePageInfo;
    procedure AddPageIndex(APages: TdxPDFIntegerObjectDictionary<TdxPDFDocumentViewerCachePageInfo>; APageIndex: Integer);
    procedure AddPageIndexes(APages: TdxPDFIntegerObjectDictionary<TdxPDFDocumentViewerCachePageInfo>; AStartIndex, AEndIndex: Integer);
    procedure AddPageIndexesToRenderQueue(APages: TList<TdxPDFDocumentViewerCachePageInfo>; AForce: Boolean);
    procedure InitializeVisiblePageIndexes;
    procedure OnCancelRenderingHandler(Sender: TObject; const APageIndexes: TIntegerDynArray);
    procedure OnTimerHandler(Sender: TObject);
  strict protected
    function CanRenderNextPage: Boolean; virtual;
    function GetPreRenderPageScale(APageIndex: Integer): Single; virtual;
    function NeedProcessRenderTask(const ATask: TdxPDFRenderTaskInfo): Boolean; virtual;
    function TryPackDocumentContent: Boolean; virtual;
    procedure CancelRendering(const APageIndexes: TIntegerDynArray); virtual;
    procedure CreateSubClasses; virtual;
    procedure DestroySubClasses; virtual;
    procedure DoDrawPage(ACanvas: TcxCanvas; APageIndex: Integer; const ARect: TRect); virtual;
    procedure Render(APageIndex: Integer; AFactor: Single); virtual;
    procedure RenderNextPage; virtual;
    //
    procedure Add(APageIndex: Integer; AFactor: Single; ABitmap: TBitmap);
    procedure PackDocumentContent;
    //
    property CacheVisiblePagesOnly: Boolean read GetCacheVisiblePagesOnly write SetCacheVisiblePagesOnly;
    property Storage: TdxPDFDocumentViewerCacheStorage read FStorage;
    property Viewer: TdxPDFDocumentCustomViewer read FViewer;
  protected
    function GetRenderingPageRowDelta: Integer; virtual;
    procedure Clear; virtual;
    procedure DrawPage(ACanvas: TcxCanvas; APageIndex: Integer; const ARect: TRect); virtual;
    procedure Start; virtual;
    procedure Stop; virtual;
    //
    procedure UpdateRenderQueue(AForce: Boolean = False);
    //
    property OnGetRenderFactor: TdxPDFDocumentViewerOnGetRenderFactor read FOnGetRenderFactor write FOnGetRenderFactor;
  public
    constructor Create(AViewer: TdxPDFDocumentCustomViewer); virtual;
    destructor Destroy; override;
  end;

  { TdxPDFDocumentViewerAsyncRenderer }

  TdxPDFDocumentViewerAsyncRenderer = class(TdxPDFDocumentViewerCustomRenderer)
  strict private
    FActiveTaskCount: Integer;
    FMaxActiveTaskCount: Integer;
    FStopped: Boolean;
    procedure IncrementActiveTaskCount;
    procedure DecrementActiveTaskCount;
    procedure OnCanceledHandler(APageIndex: Integer; AFactor: Single);
    procedure OnCompleteHandler(APageIndex: Integer; AFactor: Single; ABitmap: TBitmap);
  strict protected
    FService: TObject;
  protected
    function CanRenderNextPage: Boolean; override;
    function NeedProcessRenderTask(const ATask: TdxPDFRenderTaskInfo): Boolean; override;
    function TryPackDocumentContent: Boolean; override;
    procedure CancelRendering(const APageIndexes: TIntegerDynArray); override;
    procedure Clear; override;
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure Render(APageIndex: Integer; AFactor: Single); override;
    procedure RenderNextPage; override;
    procedure Start; override;
    procedure Stop; override;
  public
    constructor Create(AViewer: TdxPDFDocumentCustomViewer); override;
  end;

  { TdxPDFViewerPageSizeOptions }

  TdxPDFViewerPageSizeOptions = class(TdxPreviewPageSizeOptions)
  protected
    function GetActualSizeInPixels: TPoint; override;
    function GetDefaultMinUsefulSize: TPoint; override;
  end;

  { TdxPDFViewerCustomDocumentState }

  TdxPDFViewerCustomDocumentState = class(TdxPDFDocumentState) // for internal use
  strict private
    FDocumentToViewerFactor: TdxPointF;
    FDPI: TdxPointF;
    FHandTool: Boolean;
    FViewer: TdxPDFDocumentCustomViewer;
    //
    function GetDocument: TdxPDFDocument;
    function GetScaleFactor: TdxPointF;
    function GetTextExpansionFactor: TdxPointF;
    procedure SetHandTool(const AValue: Boolean);
  protected
    procedure Initialize; override;
    //
    function CreateRenderParameters: TdxPDFRenderParameters;
    function ToDocumentPoint(APage: TdxPDFDocumentCustomViewerPage; const P: TdxPointF): TdxPointF;
    //
    property DPI: TdxPointF read FDPI;
    property Viewer: TdxPDFDocumentCustomViewer read FViewer;
  public
    constructor Create(AParent: TObject; AViewer: TdxPDFDocumentCustomViewer); reintroduce;
    //
    function ToDocumentRect(APage: TdxPDFDocumentCustomViewerPage; const R: TdxRectF): TdxRectF;
    function ToPageRect(APage: TdxPDFDocumentCustomViewerPage; const R: TdxRectF): TdxRectF;
    function ToViewerPoint(APage: TdxPDFDocumentCustomViewerPage; const P: TdxPointF): TdxPointF;
    function ToViewerRect(APage: TdxPDFDocumentCustomViewerPage; const R: TdxRectF): TdxRectF; overload;
    function TryPackDocumentContent: Boolean; virtual;
    procedure CalculateScreenFactors;
    //
    property Document: TdxPDFDocument read GetDocument;
    property DocumentToViewerFactor: TdxPointF read FDocumentToViewerFactor;
    property HandTool: Boolean read FHandTool write SetHandTool;
    property ScaleFactor: TdxPointF read GetScaleFactor;
    property TextExpansionFactor: TdxPointF read GetTextExpansionFactor;
  end;

  { TdxPDFDocumentCustomViewerPage }

  TdxPDFDocumentCustomViewerPage = class(TdxPreviewPage)
  strict private
    FDocumentPage: TdxPDFPage;
    FInteractiveLayerDrawingLockCount: Integer;
    //
    function GetDocumentState: TdxPDFViewerCustomDocumentState;
    procedure SetDocumentPage(const AValue: TdxPDFPage);
  protected
    function GetPageSizeOptionsClass: TdxPreviewPageSizeOptionsClass; override;
    //
    procedure CalculatePageSize; virtual; abstract; // for internal use
    //
    function GetPageSize(const AScreenFactor: TdxPointF): TPoint; // for internal use
    function ToDocumentPoint(const P: TdxPointF): TdxPointF; // for internal use
    function ToDocumentRect(const R: TdxRectF): TdxRectF; // for internal use
    function ToPageRect(const R: TdxRectF): TdxRectF; // for internal use
    function ToViewerPoint(const P: TdxPointF): TdxPointF; // for internal use
    function ToViewerRect(const R: TdxRectF): TdxRectF; // for internal use
    //
    function IsInteractiveLayerDrawingLocked: Boolean; // for internal use
    procedure LockInteractiveLayerDrawing; // for internal use
    procedure UnLockInteractiveLayerDrawing; // for internal use
    //
    property DocumentPage: TdxPDFPage read FDocumentPage write SetDocumentPage; // for internal use
    property DocumentState: TdxPDFViewerCustomDocumentState read GetDocumentState; // for internal use
  public
    constructor Create(APreview: TdxCustomPreview); override;  // for internal use
  end;

  { TViewerDocument }

  TdxPDFViewerCustomDocument = class(TdxPDFDocument) // for internal use
  strict private
    FViewer: TdxPDFDocumentCustomViewer;
  protected
    function DoCreateDocumentState: TdxPDFDocumentState; override;
    procedure BeforeClear; override;
    //
    property Viewer: TdxPDFDocumentCustomViewer read FViewer;
  public
    constructor Create(AViewer: TdxPDFDocumentCustomViewer); reintroduce;
  end;

  { TdxPDFDocumentCustomViewer }

  TdxPDFDocumentCustomViewer = class(TdxCustomPreview, IdxPDFDocumentListener)
  strict private type
  {$REGION 'internal types'}
    TDefaultRenderer = class(TdxPDFDocumentViewerCustomRenderer)
    strict private
      procedure ClearViewerCache;
    protected
      procedure DoDrawPage(ACanvas: TcxCanvas; APageIndex: Integer; const ARect: TRect); override;
      procedure Render(APageIndex: Integer; AFactor: Single); override;
    public
      destructor Destroy; override;
      procedure Start; override;
    end;
  {$ENDREGION}
  strict private
    FIsDocumentZooming: Boolean;
    FModified: Boolean;
    FRenderContentDelay: Integer;
    FRenderContentInBackground: Boolean;
    FRenderContentTimer: TcxTimer;
    FRenderer: TdxPDFDocumentViewerCustomRenderer;
    //
    FResyncSelPageIndexLockCount: Integer;
    FNeedResyncSelPageIndex: Boolean;
    //
    FOnCustomDrawPreRenderPage: TdxPDFDocumentViewerOnCustomDrawPreRenderPageEvent;
    //
    function GetDocumentPages: TdxPDFPageList;
    function GetDocumentState: TdxPDFViewerCustomDocumentState;
    function GetIsDocumentZooming: Boolean;
    function GetRotationAngle: TcxRotationAngle;
    procedure SetRenderContentDelay(const AValue: Integer);
    procedure SetRenderContentInBackground(const AValue: Boolean);
    //
    procedure StartZoomTimer;
    procedure StopZoomTimer;
    //
    function OnGetRenderFactorHandler(APageIndex: Integer): Single;
    procedure OnRenderContentTimerHandler(Sender: TObject);
  strict protected
    FDocument: TdxPDFViewerCustomDocument;
    //
    procedure DocumentAttachmentsChanged; virtual;
    procedure DocumentBookmarksChanged; virtual;
    procedure DocumentDataChanged; virtual;
    procedure DocumentInteractiveLayerChanged; virtual;
    procedure DocumentLayoutChanged; virtual;
    // IdxPDFDocumentListener
    procedure Changed(AChanges: TdxPDFDocumentChanges);
    //
    function IsResyncSelPageIndexLocked: Boolean;
    procedure ClearRenderer;
    procedure PerformRecreatePages(AProc: TProc);
  protected
    FForceUpdate: Boolean;
    //
    procedure BoundsChanged; override;
    procedure Calculate(AType: TdxChangeType); override;
    procedure CreateSubClasses; override;
    procedure Initialize; override;
    procedure ScaleFactorChanged; override;
    procedure CheckMargins; override;
    procedure ResyncMargins; override;
    procedure ResyncSelPageIndex; override;
    //
    function CanUpdateRenderQueue: Boolean; virtual;
    function CreateRenderer: TdxPDFDocumentViewerCustomRenderer; virtual;
    function GetPageRenderFactor(APageIndex: Integer): Single; virtual; abstract;
    procedure BeforeClearDocument; virtual;
    procedure ClearSelection; virtual;
    procedure DestroySubClasses; virtual;
    procedure DoCalculate(AType: TdxChangeType); virtual;
    //
    function GetNearestPageIndex(const P: TPoint; AGetPageBoundsFunc: TFunc<Integer, TdxRectF>): Integer;
    function IsPageVisible(AIndex: Integer): Boolean;
    function IsRectVisible(const ARect: TdxRectF): Boolean;
    procedure RecreateRenderer;
    procedure RestartRenderContentTimer;
    procedure UpdateRenderQueue(AForce: Boolean = False);
    //
    property Document: TdxPDFViewerCustomDocument read FDocument;
    property DocumentPages: TdxPDFPageList read GetDocumentPages;
    property DocumentState: TdxPDFViewerCustomDocumentState read GetDocumentState;
    property IsDocumentZooming: Boolean read GetIsDocumentZooming;
    property RenderContentDelay: Integer read FRenderContentDelay write SetRenderContentDelay;
    property RenderContentInBackground: Boolean read FRenderContentInBackground write SetRenderContentInBackground;
    property RotationAngle: TcxRotationAngle read GetRotationAngle;
    property Renderer: TdxPDFDocumentViewerCustomRenderer read FRenderer;
    //
    property OnCustomDrawPreRenderPage: TdxPDFDocumentViewerOnCustomDrawPreRenderPageEvent read FOnCustomDrawPreRenderPage
      write FOnCustomDrawPreRenderPage;
  public
    destructor Destroy; override;
    procedure Clear; virtual;
  end;

  { TdxPDFDocumentPageThumbnailViewer }

  TdxPDFDocumentPageThumbnailViewer = class(TdxPDFDocumentCustomViewer, IdxSkinSupport, IcxFontListener)
  strict private type
  {$REGION 'internal types'}
    TRenderer = class(TdxPDFDocumentViewerAsyncRenderer)
    protected
      function GetPreRenderPageScale(APageIndex: Integer): Single; override;
      function GetRenderingPageRowDelta: Integer; override;
      procedure CreateSubClasses; override;
      procedure Render(APageIndex: Integer; AFactor: Single); override;
    end;

    TPage = class(TdxPDFDocumentCustomViewerPage)
    strict private const
      DefaultIndent = 10;
    strict private
      FCaptionBounds: TRect;
      FImageBorderBounds: TRect;
      FImageBounds: TRect;
      FSelectionBounds: TRect;
      FThumbnailBounds: TRect;

      function GetImageSize: Integer;
      function GetSelectionSize: TRect;
      function GetThumbnailsPreview: TdxPDFDocumentPageThumbnailViewer;

      procedure DrawBackground(ACanvas: TcxCanvas);
      procedure DrawContent(ACanvas: TcxCanvas);
      procedure DrawFocusRect(ACanvas: TcxCanvas);
      procedure DrawSelection(ACanvas: TcxCanvas);
      procedure DrawIndex(ACanvas: TcxCanvas);
    protected
      procedure CalculatePageSize; override;
      procedure CalculateLayout;

      property ImageSize: Integer read GetImageSize;
      property ThumbnailsPreview: TdxPDFDocumentPageThumbnailViewer read GetThumbnailsPreview;
    public
      procedure Draw(ACanvas: TcxCanvas); override;
      property ImageBounds: TRect read FImageBounds;
    end;
  {$ENDREGION}
  strict private
    FCurrentFocusedPageIndex: Integer;
    FLastClickedPageIndex: Integer;
    FMaxSize: Integer;
    FMinSize: Integer;
    FPageCaptionSize: TSize;
    FPopupMenu: TComponent;
    FSaveSelectedPages: TdxIntegerList;
    FSelectedPages: TdxIntegerList;
    FSize: Integer;

    FOnThumbnailSizeChanged: TNotifyEvent;

    function GetPageCaptionAreaHeight: Integer;
    function GetPageCaptionMargin: Integer;
    procedure SetDocument(const AValue: TdxPDFViewerCustomDocument);
    procedure SetMaxSize(const AValue: Integer);
    procedure SetMinSize(const AValue: Integer);
    procedure SetSize(const AValue: Integer);

    procedure Changed(Sender: TObject; AFont: TFont); overload;
    procedure CheckSize;
    procedure CalculateCaptionSize;
    procedure RecreatePages(AForce: Boolean = True);
    procedure UpdateSelectionRange;
  strict protected
    procedure DocumentLayoutChanged; override;
  protected
    function CreateRenderer: TdxPDFDocumentViewerCustomRenderer; override;
    function GetPageRenderFactor(APageIndex: Integer): Single; override;
    procedure Calculate(AType: TdxChangeType); override;
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure DoCalculate(AType: TdxChangeType); override;
    procedure Initialize; override;
    procedure LookAndFeelChanged(Sender: TcxLookAndFeel; AChangedValues: TcxLookAndFeelValues); override;

    function CreatePage: TdxPreviewPage; override;
    function CanMakeVisibleAnimate: Boolean; override;
    function GetAbsoluteIndentLeft: Integer; override;
    function GetAbsoluteIndentRight: Integer; override;
    function GetCursor: TCursor; override;
    function GetDefaultZoomStep: Integer; override;
    function GetPageClass: TdxPreviewPageClass; override;
    function NonVerticalCenterizePages: Boolean; override;
    procedure DoContextPopup(MousePos: TPoint; var Handled: Boolean); override;
    procedure DoSelectedPageChanged; override;
    procedure DoZoomIn; override;
    procedure DoZoomOut; override;
    procedure DrawPageBackground(ACanvas: TcxCanvas; APage: TdxPreviewPage; ASelected: Boolean); override;
    procedure DrawViewerBackground(ACanvas: TcxCanvas; const R: TRect); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure ProcessLeftClickByPage(Shift: TShiftState; X, Y: Integer); override;

    function IsPageSelected(APageIndex: Integer): Boolean;
    function GetPagesToPrint: TIntegerDynArray;
    function GetSelectedPages: TIntegerDynArray;
    procedure SaveSelection;
    procedure RestoreSelection;

    property Document: TdxPDFViewerCustomDocument read FDocument write SetDocument;
    property MaxSize: Integer read FMaxSize write SetMaxSize;
    property MinSize: Integer read FMinSize write SetMinSize;
    property PageCaptionAreaHeight: Integer read GetPageCaptionAreaHeight;
    property PageCaptionSize: TSize read FPageCaptionSize;
    property PageCaptionMargin: Integer read GetPageCaptionMargin;
    property Size: Integer read FSize write SetSize;
    property OnThumbnailSizeChanged: TNotifyEvent read FOnThumbnailSizeChanged write FOnThumbnailSizeChanged;
  public
    procedure Clear; override;
    //
    property SelPageIndex;
  end;

  { TdxPDFDocumentOutlineItem }

  TdxPDFDocumentOutlineItem = class
  strict private
    FColor: TColor;
    FHasChildren: Boolean;
    FID: Integer;
    FInteractiveOperation: TdxPDFInteractiveOperation;
    FIsBold: Boolean;
    FIsItalic: Boolean;
    FOutline: TdxPDFOutline;
    FParentID: Integer;
    FTitle: string;
    function GetInteractiveOperation: TdxPDFInteractiveOperation;
  protected
    property Color: TColor read FColor;
    property HasChildren: Boolean read FHasChildren;
    property ID: Integer read FID;
    property InteractiveOperation: TdxPDFInteractiveOperation read GetInteractiveOperation;
    property IsBold: Boolean read FIsBold;
    property IsItalic: Boolean read FIsItalic;
    property Outline: TdxPDFOutline read FOutline;
    property ParentID: Integer read FParentID;
    property Title: string read FTitle;
  public
    constructor Create(AOutline: TdxPDFOutline; AID, AParentID: Integer);
  end;

  { TdxPDFDocumentOutlineList }

  TdxPDFDocumentOutlineList = class(TObjectList<TdxPDFDocumentOutlineItem>)
  strict private
    FPages: TdxPDFPageList;
    function AddOutline(AOutline: TdxPDFOutline; AParentID: Integer): Integer;
    function GetNextPageNumber(AOutline: TdxPDFOutline): Integer;
    function GetPageNumber(AOutline: TdxPDFOutline): Integer;
  protected
    function GetPrintPageNumbers(AItems: TList<TdxPDFDocumentOutlineItem>; APrintSection: Boolean): TIntegerDynArray;
    procedure Read(ACatalog: TdxPDFCatalog);
  end;

implementation

uses
  Math, SyncObjs, dxCore, RTLConsts, dxCoreGraphics, dxThreading, dxGDIPlusClasses, dxTypeHelpers, dxPDFTypes,
  dxPDFViewer, dxPDFViewerPopupMenu, dxPDFInteractivity, dxPDFUtils;

const
  dxThisUnitName = 'dxPDFDocumentViewer';

const
  dxPDFDocumentViewerPageCacheSize = 100;

type
  TdxCustomPreviewAccess = class(TdxCustomPreview);
  TdxPDFBackgroundService = class;
  TdxPDFBookmarkAccess = class(TdxPDFBookmark);
  TdxPDFCatalogAccess = class(TdxPDFCatalog);
  TdxPDFCustomDestinationAccess = class(TdxPDFCustomDestination);
  TdxPDFDocumentAccess = class(TdxPDFDocument);
  TdxPDFDocumentStateAccess = class(TdxPDFDocumentState);
  TdxPDFHyperlinkAccess = class(TdxPDFHyperlink);
  TdxPDFOutlineAccess = class(TdxPDFOutline);
  TdxPDFPageListAccess = class(TdxPDFPageList);
  TdxPDFPagesAccess = class(TdxPDFPages);
  TdxPreviewPageContentCachePoolAccess = class(TdxPreviewPageContentCachePool);

  TdxPDFOnRenderingCanceled = procedure(APageIndex: Integer; AFactor: Single) of object;
  TdxPDFOnRenderingComplete = procedure(APageIndex: Integer; AFactor: Single; ABitmap: TBitmap) of object;

  TdxPDFDocumentViewerCachePageInfoComparer = class(TInterfacedObject, IComparer<TdxPDFDocumentViewerCachePageInfo>)
  strict private
    function Compare(const Left, Right: TdxPDFDocumentViewerCachePageInfo): Integer;
  end;

  { TdxPDFRenderPageTask }

  TdxPDFRenderPageTaskClass = class of TdxPDFRenderPageTask;
  TdxPDFRenderPageTask = class(TInterfacedObject, IdxTask)
  strict private
    FService: TdxPDFBackgroundService;
  protected
    function Render(AImage: TdxSmartImage; const ACancelStatus: TdxTaskCancelCallback): Boolean; virtual; abstract;
  public
    Bitmap: TBitmap;
    Handle: THandle;
    PageIndex: Integer;
    Factor: Single;
    Viewer: TdxPDFDocumentCustomViewer;
    constructor Create(AService: TdxPDFBackgroundService; AViewer: TdxPDFDocumentCustomViewer; APageIndex: Integer;
      AFactor: Single);
    destructor Destroy; override;

    function Run(const ACancelStatus: TdxTaskCancelCallback): TdxTaskCompletedStatus;
    procedure OnComplete(AStatus: TdxTaskCompletedStatus);
  end;

  { TdxPDFRenderPageByScaleFactorTask }

  TdxPDFRenderPageByScaleFactorTask = class(TdxPDFRenderPageTask)
  protected
    function Render(AImage: TdxSmartImage; const ACancelStatus: TdxTaskCancelCallback): Boolean; override;
  end;

  { TdxPDFRenderPageBySizeTask }

  TdxPDFRenderPageBySizeTask = class(TdxPDFRenderPageTask)
  protected
    function Render(AImage: TdxSmartImage; const ACancelStatus: TdxTaskCancelCallback): Boolean; override;
  end;

  { TdxPDFBackgroundService }

  TdxPDFBackgroundService = class(TdxTaskDispatcher)
  strict private
    FTasks: TdxFastList;
    function CreateRenderingTask(AClass: TdxPDFRenderPageTaskClass; AViewer: TdxPDFDocumentCustomViewer;
      APageIndex: Integer; AFactor: Single): IdxTask;
    function Cancel(ATaskHandle: THandle; AWaitFor: Boolean = False): Boolean;
    function GetTaskCount: Integer;
    procedure AddRenderingTask(AClass: TdxPDFRenderPageTaskClass; AViewer: TdxPDFDocumentCustomViewer;
      APageIndex: Integer; AFactor: Single);
    procedure RemoveTask(ATask: TdxPDFRenderPageTask);
  protected
    procedure Complete(const ATask: IdxTask; AStatus: TdxTaskCompletedStatus);
  public
    OnRenderingCanceled: TdxPDFOnRenderingCanceled;
    OnRenderingComplete: TdxPDFOnRenderingComplete;
    constructor Create;
    destructor Destroy; override;

    procedure AddRenderingByScaleFactorTask(AViewer: TdxPDFDocumentCustomViewer; APageIndex: Integer; AFactor: Single);
    procedure AddRenderingBySizeTask(AViewer: TdxPDFDocumentCustomViewer; APageIndex: Integer; AFactor: Single);
    procedure CancelTask(APageIndex: Integer);
    procedure CancelAllAndWait;

    property TaskCount: Integer read GetTaskCount;
  end;

{ TdxPDFRenderPageTask }

constructor TdxPDFRenderPageTask.Create(AService: TdxPDFBackgroundService; AViewer: TdxPDFDocumentCustomViewer;
  APageIndex: Integer; AFactor: Single);
begin
  inherited Create;
  FService := AService;
  PageIndex := APageIndex;
  Factor := AFactor;
  Viewer := AViewer;
end;

destructor TdxPDFRenderPageTask.Destroy;
begin
  FreeAndNil(Bitmap);
  inherited Destroy;
end;

function TdxPDFRenderPageTask.Run(const ACancelStatus: TdxTaskCancelCallback): TdxTaskCompletedStatus;
var
  AImage: TdxSmartImage;
begin
  Result := TdxTaskCompletedStatus.Fail;
  if not ACancelStatus then
  try
    AImage := TdxSmartImage.Create;
    try
      if Render(AImage, ACancelStatus) and not ACancelStatus then
      begin
        Bitmap := AImage.GetAsBitmap;
        Result := TdxTaskCompletedStatus.Success;
      end
      else
        Result := TdxTaskCompletedStatus.Cancelled;
    finally
      AImage.Free;
    end;
  except
    Result := TdxTaskCompletedStatus.Fail;
  end;
end;

procedure TdxPDFRenderPageTask.OnComplete(AStatus: TdxTaskCompletedStatus);
begin
  FService.Complete(Self, AStatus);
end;

{ TdxPDFRenderPageByScaleFactorTask }

function TdxPDFRenderPageByScaleFactorTask.Render(AImage: TdxSmartImage; const ACancelStatus: TdxTaskCancelCallback): Boolean;
var
  ABitmap: TcxBitmap;
  ADevice: TdxPDFGraphicsDevice;
  AParameters: TdxPDFRenderParameters;
begin
  Result := not ACancelStatus;
  if Result then
  begin
    ABitmap := TcxBitmap.CreateSize(Viewer.PageList[PageIndex].Bounds);
    try
      ABitmap.Canvas.Lock;
      try
        AParameters := Viewer.DocumentState.CreateRenderParameters;
        try
          AParameters.CancelCallback := ACancelStatus;
          AParameters.Canvas := ABitmap.Canvas;
          AParameters.Rect := ABitmap.ClientRect;
          Result := not ACancelStatus;
          if Result then
          begin
            ADevice := TdxPDFGraphicsDevice.Create;
            try
              ADevice.Export(TdxPDFPagesAccess(Viewer.Document.Pages).List[PageIndex], AParameters);
            finally
              ADevice.Free;
            end;
          end;
        finally
          AParameters.Free;
        end;
      finally
        ABitmap.Canvas.Unlock;
      end;
      Result := not ACancelStatus;
      if Result then
        AImage.SetBitmap(ABitmap);
    finally
      ABitmap.Free;
    end;
  end;
end;

{ TdxPDFRenderPageBySizeTask }

function TdxPDFRenderPageBySizeTask.Render(AImage: TdxSmartImage; const ACancelStatus: TdxTaskCancelCallback): Boolean;
begin
  Result := dxPDFDocumentExportToImage(Viewer.Document, PageIndex, Trunc(Factor), AImage, Viewer.RotationAngle, ACancelStatus);
end;

{ TdxPDFDocumentViewerCachePageInfoComparer }

function TdxPDFDocumentViewerCachePageInfoComparer.Compare(const Left, Right: TdxPDFDocumentViewerCachePageInfo): Integer;
begin
  Result := Left.Index - Right.Index;
end;

{ TdxPDFBackgroundService }

constructor TdxPDFBackgroundService.Create;
begin
  inherited Create;
  MaxActiveTasks := 1;
  FTasks := TdxFastList.Create;
end;

destructor TdxPDFBackgroundService.Destroy;
begin
  FreeAndNil(FTasks);
  inherited Destroy;
end;

procedure TdxPDFBackgroundService.AddRenderingByScaleFactorTask(AViewer: TdxPDFDocumentCustomViewer;
  APageIndex: Integer; AFactor: Single);
begin
  AddRenderingTask(TdxPDFRenderPageByScaleFactorTask, AViewer, APageIndex, AFactor);
end;

procedure TdxPDFBackgroundService.AddRenderingBySizeTask(AViewer: TdxPDFDocumentCustomViewer;
  APageIndex: Integer; AFactor: Single);
begin
  AddRenderingTask(TdxPDFRenderPageBySizeTask, AViewer, APageIndex, AFactor);
end;

procedure TdxPDFBackgroundService.CancelTask(APageIndex: Integer);
var
  ATask: TdxPDFRenderPageTask;
  I: Integer;
begin
  for I := 0 to FTasks.Count - 1 do
  begin
    ATask := TdxPDFRenderPageTask(FTasks[I]);
    if ATask.PageIndex = APageIndex then
    begin
      RemoveTask(ATask);
      Cancel(ATask.Handle);
      Break;
    end;
  end;
end;

procedure TdxPDFBackgroundService.CancelAllAndWait;
begin
  CancelAll;
end;

function TdxPDFBackgroundService.CreateRenderingTask(AClass: TdxPDFRenderPageTaskClass;
  AViewer: TdxPDFDocumentCustomViewer; APageIndex: Integer; AFactor: Single): IdxTask;
begin
  Result := AClass.Create(Self, AViewer, APageIndex, AFactor);
end;

function TdxPDFBackgroundService.Cancel(ATaskHandle: THandle; AWaitFor: Boolean = False): Boolean;
begin
  Result := dxTasksDispatcher.Cancel(ATaskHandle, AWaitFor);
end;

function TdxPDFBackgroundService.GetTaskCount: Integer;
begin
  Result := FTasks.Count;
end;

procedure TdxPDFBackgroundService.AddRenderingTask(AClass: TdxPDFRenderPageTaskClass; AViewer: TdxPDFDocumentCustomViewer;
  APageIndex: Integer; AFactor: Single);
var
  ATask: TdxPDFRenderPageTask;
begin
  if AViewer.Document <> nil then
  begin
    CancelTask(APageIndex);
    ATask := CreateRenderingTask(AClass, AViewer, APageIndex, AFactor) as TdxPDFRenderPageTask;
    FTasks.Add(ATask);
    ATask.Handle := Run(ATask);
  end;
end;

procedure TdxPDFBackgroundService.RemoveTask(ATask: TdxPDFRenderPageTask);
begin
  FTasks.Remove(ATask);
end;

procedure TdxPDFBackgroundService.Complete(const ATask: IdxTask; AStatus: TdxTaskCompletedStatus);
var
  ARenderTask: TdxPDFRenderPageTask;
begin
  if ATask is TdxPDFRenderPageTask then
  begin
    ARenderTask := TdxPDFRenderPageTask(ATask);
    case AStatus of
      TdxTaskCompletedStatus.Success:
        if Assigned(OnRenderingComplete) then
          OnRenderingComplete(ARenderTask.PageIndex, ARenderTask.Factor, ARenderTask.Bitmap);
      TdxTaskCompletedStatus.Cancelled, TdxTaskCompletedStatus.Fail:
        if Assigned(OnRenderingCanceled) then
          OnRenderingCanceled(ARenderTask.PageIndex, ARenderTask.Factor);
    end;
    RemoveTask(ARenderTask);
  end;
end;

{ TdxPDFDocumentViewerCacheStorage }

constructor TdxPDFDocumentViewerCacheStorage.Create;
begin
  inherited Create;
  FThumbnails := TCache.Create(dxPDFDocumentViewerPageCacheSize);
  FContainer := TdxPDFIntegerObjectDictionary<TCacheItem>.Create([doOwnsValues]);
  FCacheInfos := TDictionary<Integer, Single>.Create;
end;

destructor TdxPDFDocumentViewerCacheStorage.Destroy;
begin
  FreeAndNil(FThumbnails);
  FreeAndNil(FContainer);
  FreeAndNil(FCacheInfos);
  inherited Destroy;
end;

function TdxPDFDocumentViewerCacheStorage.CheckThumbnails(APageIndex: Integer; AFactor: Single): Boolean;
var
 ACache: TCacheItem;
begin
  Result := FThumbnails.TryGetValue(APageIndex, AFactor, ACache);
  if Result then
  begin
    Add(APageIndex, AFactor, ACache.Bitmap);
    FThumbnails.Remove(APageIndex);
  end
end;

function TdxPDFDocumentViewerCacheStorage.Contains(APageIndex: Integer; AFactor: Single): Boolean;
var
  ACache: TCacheItem;
begin
  Result := FContainer.TryGetValue(APageIndex, ACache);
  if Result then
    Result := SameValue(ACache.Factor, AFactor);
end;

function TdxPDFDocumentViewerCacheStorage.ContainsThumbnail(APageIndex: Integer; AFactor: Single): Boolean;
var
  ACache: TCacheItem;
begin
  Result := FThumbnails.TryGetValue(APageIndex, ACache);
  if Result then
    Result := SameValue(ACache.Factor, AFactor);
end;

function TdxPDFDocumentViewerCacheStorage.CreateCache(ABitmap: TBitmap; AFactor: Single): TCacheItem;
var
  AClone: TBitmap;
begin
  AClone := TBitmap.Create;
  AClone.Assign(ABitmap);
  Result := TCacheItem.Create(AClone, AFactor);
end;

function TdxPDFDocumentViewerCacheStorage.GetBitmap(APageIndex: Integer): TBitmap;
var
  AInfo: TCacheItem;
begin
  if FContainer.TryGetValue(APageIndex, AInfo) then
    Result := AInfo.Bitmap
  else
    Result := nil;
end;

function TdxPDFDocumentViewerCacheStorage.GetThumbnail(APageIndex: Integer): TBitmap;
begin
  if not FThumbnails.TryGetValue(APageIndex, Result) then
    Result := nil;
end;

procedure TdxPDFDocumentViewerCacheStorage.Add(APageIndex: Integer; AFactor: Single; ABitmap: TBitmap);
var
  AScale: Single;
begin
  AScale := 0;
  if FCacheInfos.TryGetValue(APageIndex, AScale) or SameValue(AFactor, AScale) then
    FContainer.AddOrSetValue(APageIndex, CreateCache(ABitmap, AFactor));
end;

procedure TdxPDFDocumentViewerCacheStorage.SetCacheVisiblePagesOnly(const AValue: Boolean);
begin
  if FCacheVisiblePagesOnly <> AValue then
  begin
    FCacheVisiblePagesOnly := AValue;
    if CacheVisiblePagesOnly then
      FThumbnails.Clear;
  end;
end;

procedure TdxPDFDocumentViewerCacheStorage.AddThumbnail(APageIndex: Integer; ACache: TCacheItem);
var
  AClone: TBitmap;
begin
  AClone := TBitmap.Create;
  AClone.Assign(ACache.Bitmap);
  FThumbnails.Add(APageIndex, TCacheItem.Create(AClone, ACache.Factor));
end;

procedure TdxPDFDocumentViewerCacheStorage.Clear;
begin
  FContainer.Clear;
  FCacheInfos.Clear;
  FThumbnails.Clear;
end;

procedure TdxPDFDocumentViewerCacheStorage.Remove(APageIndex: Integer; AForceAddThumbnail: Boolean);
var
  ACache: TCacheItem;
begin
  if (AForceAddThumbnail or not (AForceAddThumbnail or CacheVisiblePagesOnly)) and
    FContainer.TryGetValue(APageIndex, ACache) and not ACache.Bitmap.Empty then
    AddThumbnail(APageIndex, ACache);
  FContainer.Remove(APageIndex);
end;

procedure TdxPDFDocumentViewerCacheStorage.SetVisiblePages(APages: TList<TdxPDFDocumentViewerCachePageInfo>);
var
  AKeysToRemove: TIntegerDynArray;
  APageIndexes: TdxIntegerList;
  APageIndex: Integer;
  APageInfo: TdxPDFDocumentViewerCachePageInfo;
begin
  FCacheInfos.Clear;
  APageIndexes := TdxIntegerList.Create;
  try
    for APageInfo in APages do
    begin
      FCacheInfos.Add(APageInfo.Index, APageInfo.Factor);
      APageIndexes.Add(APageInfo.Index);
    end;
    SetLength(AKeysToRemove, 0);
    for APageIndex in FContainer.Keys do
      if not APageIndexes.Contains(APageIndex) then
        TdxPDFUtils.AddValue(APageIndex, AKeysToRemove);
    if Assigned(OnCancelRendering) then
      OnCancelRendering(Self, AKeysToRemove);
    for APageIndex in AKeysToRemove do
      Remove(APageIndex, False);
  finally
    APageIndexes.Free;
  end;
end;

{ TdxPDFDocumentViewerCacheStorage.TCacheItem }

constructor TdxPDFDocumentViewerCacheStorage.TCacheItem.Create(ABitmap: TBitmap; AFactor: Single);
begin
  inherited Create;
  Bitmap := ABitmap;
  Factor := AFactor;
end;

destructor TdxPDFDocumentViewerCacheStorage.TCacheItem.Destroy;
begin
  FreeAndNil(Bitmap);
  inherited Destroy;
end;

{ TdxPDFDocumentViewerCacheStorage.TCache }

constructor TdxPDFDocumentViewerCacheStorage.TCache.Create(ALimit: Int64);
begin
  inherited Create;
  FDictionary := TdxPDFIntegerObjectDictionary<TCacheItem>.Create([doOwnsValues]);
  FQueue := TdxIntegerList.Create;
  FLimit := ALimit * 1024 * 1024;
end;

destructor TdxPDFDocumentViewerCacheStorage.TCache.Destroy;
begin
  Clear;
  FreeAndNil(FQueue);
  FreeAndNil(FDictionary);
  inherited Destroy;
end;

procedure TdxPDFDocumentViewerCacheStorage.TCache.Clear;
begin
  FDictionary.Clear;
  FQueue.Clear;
  FSize := 0;
end;

function TdxPDFDocumentViewerCacheStorage.TCache.GetSize(AValue: TBitmap): Int64;
var
  AStream: TStream;
begin
  Result := 0;
  if AValue <> nil then
  begin
    AStream := TMemoryStream.Create;
    try
      AValue.SaveToStream(AStream);
      Result := AStream.Size;
    finally
      AStream.Free;
    end;
  end;
end;

procedure TdxPDFDocumentViewerCacheStorage.TCache.CheckSize;
var
  ADestSize: Integer;
begin
  if (FLimit > 0) and (FSize > FLimit) then
  begin
    ADestSize := FLimit - Trunc(FLimit * 0.25);
    while FSize > ADestSize do
      Remove(FQueue.First);
  end;
end;

procedure TdxPDFDocumentViewerCacheStorage.TCache.Remove(APageIndex: Integer);
var
  ABitmap: TBitmap;
begin
  if TryGetValue(APageIndex, ABitmap) then
  begin
    Dec(FSize, GetSize(ABitmap));
    FQueue.Remove(APageIndex);
    FDictionary.Remove(APageIndex);
  end;
end;

procedure TdxPDFDocumentViewerCacheStorage.TCache.Add(APageIndex: Integer;
  ACache: TCacheItem);
begin
  Inc(FSize, GetSize(ACache.Bitmap));
  if FDictionary.ContainsKey(APageIndex) then
    Remove(APageIndex);
  FDictionary.Add(APageIndex, ACache);
  FQueue.Add(APageIndex);
  CheckSize;
end;

function TdxPDFDocumentViewerCacheStorage.TCache.TryGetValue(APageIndex: Integer;
  out ABitmap: TBitmap): Boolean;
var
  ACache: TCacheItem;
begin
  Result := TryGetValue(APageIndex, ACache);
  if Result then
    ABitmap := ACache.Bitmap;
end;

function TdxPDFDocumentViewerCacheStorage.TCache.TryGetValue(APageIndex: Integer;
  out ACache: TCacheItem): Boolean;
begin
  Result := FDictionary.TryGetValue(APageIndex, ACache);
end;

function TdxPDFDocumentViewerCacheStorage.TCache.TryGetValue(APageIndex: Integer; AFactor: Single;
  out ACache: TCacheItem): Boolean;
begin
  Result := FDictionary.TryGetValue(APageIndex, ACache);
  if Result then
    Result := SameValue(AFactor, ACache.Factor);
end;

{ TdxPDFRenderTaskInfo }

class function TdxPDFRenderTaskInfo.Create(APageIndex: Integer; AFactor: Single): TdxPDFRenderTaskInfo;
begin
  Result.Factor := AFactor;
  Result.PageIndex := APageIndex;
end;

{ TdxPDFDocumentViewerCustomRenderer }

constructor TdxPDFDocumentViewerCustomRenderer.Create(AViewer: TdxPDFDocumentCustomViewer);
begin
  inherited Create;
  FViewer := AViewer;
  CreateSubClasses;
end;

destructor TdxPDFDocumentViewerCustomRenderer.Destroy;
begin
  DestroySubClasses;
  inherited Destroy;
end;

function TdxPDFDocumentViewerCustomRenderer.GetRenderingPageRowDelta: Integer;
begin
  Result := 1;
end;

procedure TdxPDFDocumentViewerCustomRenderer.Clear;
begin
  FQueue.Clear;
  FStorage.Clear;
  InitializeVisiblePageIndexes;
end;

procedure TdxPDFDocumentViewerCustomRenderer.DrawPage(ACanvas: TcxCanvas; APageIndex: Integer; const ARect: TRect);
begin
  DoDrawPage(ACanvas, APageIndex, ARect);
end;

procedure TdxPDFDocumentViewerCustomRenderer.Start;
begin
// do nothing
end;

procedure TdxPDFDocumentViewerCustomRenderer.Stop;
begin
// do nothing
end;

procedure TdxPDFDocumentViewerCustomRenderer.UpdateRenderQueue(AForce: Boolean = False);

  procedure CalculateAdditionalPageIndexes(APages: TdxPDFIntegerObjectDictionary<TdxPDFDocumentViewerCachePageInfo>;
    APageIndex, ARowDelta: Integer);
  var
    I, J, ARowIndex: Integer;
    ARows: TdxPreviewPagesRowList;
  begin
    ARows := TdxCustomPreviewAccess(FViewer).PagesRows;
    for I := 0 to ARows.Count - 1 do
      if InRange(APageIndex, ARows[I].StartIndex, ARows[I].FinishIndex) then
      begin
        for J := 1 to Abs(ARowDelta) do
        begin
          ARowIndex := Min(Max(I + J * Sign(ARowDelta), 0), ARows.Count - 1);
          AddPageIndexes(APages, ARows[ARowIndex].StartIndex, ARows[ARowIndex].FinishIndex);
        end;
        Break;
      end;
  end;

  procedure CalculateVisiblePageIndexes(APages: TdxPDFIntegerObjectDictionary<TdxPDFDocumentViewerCachePageInfo>;
    out AStartPageIndex, AEndPageIndex: Integer);
  var
    I: Integer;
  begin
    AStartPageIndex := -1;
    AEndPageIndex := -1;
    for I := 0 to Viewer.PageCount - 1 do
      if Viewer.IsPageVisible(I) then
      begin
        if APages.Count = 0 then
          AStartPageIndex := I;
        AEndPageIndex := Max(I, AEndPageIndex);
        AddPageIndex(APages, I);
      end;
  end;

var
  AStartPageIndex, AEndPageIndex: Integer;
  APair: TPair<Integer, TdxPDFDocumentViewerCachePageInfo>;
  APages: TdxPDFIntegerObjectDictionary<TdxPDFDocumentViewerCachePageInfo>;
  APageIndexes: TList<TdxPDFDocumentViewerCachePageInfo>;
  APageRowDelta: Integer;
begin
  if Viewer.PageCount > 0 then
  begin
    APages := TdxPDFIntegerObjectDictionary<TdxPDFDocumentViewerCachePageInfo>.Create([doOwnsValues]);
    try
      CalculateVisiblePageIndexes(APages, AStartPageIndex, AEndPageIndex);
      if AForce or (FStartVisiblePageIndex <> AStartPageIndex) or (FEndVisiblePageIndex <> AEndPageIndex) then
      begin
        FStartVisiblePageIndex := AStartPageIndex;
        FEndVisiblePageIndex := AEndPageIndex;
        APageRowDelta := GetRenderingPageRowDelta;
        CalculateAdditionalPageIndexes(APages, FStartVisiblePageIndex, -APageRowDelta);
        CalculateAdditionalPageIndexes(APages, FEndVisiblePageIndex, APageRowDelta);
        APageIndexes := TList<TdxPDFDocumentViewerCachePageInfo>.Create;
        try
          for APair in APages do
            APageIndexes.Add(APair.Value);
          AddPageIndexesToRenderQueue(APageIndexes, AForce);
        finally
          APageIndexes.Free;
        end;
      end;
    finally
      APages.Free;
    end;
  end;
end;

function TdxPDFDocumentViewerCustomRenderer.CanRenderNextPage: Boolean;
begin
  Result := FQueue.Count > 0;
end;

function TdxPDFDocumentViewerCustomRenderer.GetPreRenderPageScale(APageIndex: Integer): Single;
begin
  Result := Viewer.DocumentState.ScaleFactor.X;
end;

function TdxPDFDocumentViewerCustomRenderer.NeedProcessRenderTask(const ATask: TdxPDFRenderTaskInfo): Boolean;
begin
  Result := FViewer.FForceUpdate and not FViewer.IsDocumentZooming and
    not (FViewer.IsVertScrollAnimationActive or FViewer.IsHorzScrollAnimationActive);
end;

function TdxPDFDocumentViewerCustomRenderer.TryPackDocumentContent: Boolean;
begin
  Result := Viewer.DocumentState.TryPackDocumentContent;
end;

procedure TdxPDFDocumentViewerCustomRenderer.CancelRendering(const APageIndexes: TIntegerDynArray);
begin
// do nothing
end;

procedure TdxPDFDocumentViewerCustomRenderer.CreateSubClasses;
begin
  FQueue := TQueue<TdxPDFRenderTaskInfo>.Create;

  FStorage := TdxPDFDocumentViewerCacheStorage.Create;
  FStorage.OnCancelRendering := OnCancelRenderingHandler;

  FTimer := TcxTimer.Create(nil);
  FTimer.Enabled := not(FViewer.IsDesigning or FViewer.IsDestroying);
  FTimer.Interval := 10;
  FTimer.OnTimer := OnTimerHandler;

  InitializeVisiblePageIndexes;
end;

procedure TdxPDFDocumentViewerCustomRenderer.DestroySubClasses;
begin
  FreeAndNil(FTimer);
  Clear;
  FreeAndNil(FQueue);
  FreeAndNil(FStorage);
end;

procedure TdxPDFDocumentViewerCustomRenderer.DoDrawPage(ACanvas: TcxCanvas; APageIndex: Integer; const ARect: TRect);

  function GetPreRenderPageInfo(ABitmap: TBitmap): TdxPDFPreRenderPageInfo;
  begin
    Result.Bounds := ARect;
    Result.PageIndex := APageIndex;
    Result.Scale := GetPreRenderPageScale(Result.PageIndex);
    Result.Thumbnail := ABitmap;
  end;

  procedure Draw(ABitmap: TBitmap);
  begin
    if ABitmap <> nil then
      ACanvas.StretchDraw(ARect, ABitmap)
    else
      ACanvas.FillRect(ARect, clWhite);
  end;

  function IsStretchNeeded(ABitmap: TBitmap; const ARect: TRect): Boolean;
  begin
    Result := (ABitmap.Width > ARect.Width) or (ABitmap.Height > ARect.Height);
  end;

var
  ABitmap: TBitmap;
  ADone: Boolean;
begin
  ABitmap := FStorage.GetBitmap(APageIndex);
  if ABitmap <> nil then
  begin
    if IsStretchNeeded(ABitmap, ARect) then
      ACanvas.StretchDraw(ARect, ABitmap)
    else
      ACanvas.Draw(ARect.Left, ARect.Top, ABitmap)
  end
  else
  begin
    ABitmap := FStorage.GetThumbnail(APageIndex);
    ADone := False;
    if Assigned(Viewer.OnCustomDrawPreRenderPage) then
    begin
      Viewer.OnCustomDrawPreRenderPage(Viewer, ACanvas, GetPreRenderPageInfo(ABitmap), ADone);
      if not ADone then
        Draw(ABitmap);
    end
    else
      Draw(ABitmap);
  end;
end;

procedure TdxPDFDocumentViewerCustomRenderer.Render(APageIndex: Integer; AFactor: Single);
var
  ABitmap: TBitmap;
  AImage: TdxSmartImage;
begin
  AImage := TdxSmartImage.Create;
  try
    if dxPDFDocumentExportToImageEx(Viewer.Document, APageIndex, AFactor, AImage, Viewer.RotationAngle) then
    begin
      ABitmap := AImage.GetAsBitmap;
      try
        Add(APageIndex, AFactor, ABitmap);
      finally
        ABitmap.Free;
      end;
    end;
  finally
    AImage.Free;
  end;
end;

procedure TdxPDFDocumentViewerCustomRenderer.RenderNextPage;
var
  AFactor: Single;
  APageIndex: Integer;
  ATask: TdxPDFRenderTaskInfo;
begin
  if CanRenderNextPage then
  begin
    ATask := FQueue.Dequeue;
    APageIndex := ATask.PageIndex;
    AFactor := ATask.Factor;
    if NeedProcessRenderTask(ATask) then
    begin
      Render(APageIndex, AFactor);
      FNeedPackDocumentContent := Viewer.PageCount > 1;
      if FQueue.Count = 0 then
        FViewer.FForceUpdate := False;
    end;
    Viewer.Update;
  end
  else
    PackDocumentContent;
end;

procedure TdxPDFDocumentViewerCustomRenderer.Add(APageIndex: Integer; AFactor: Single; ABitmap: TBitmap);
begin
  FStorage.Add(APageIndex, AFactor, ABitmap);
end;

procedure TdxPDFDocumentViewerCustomRenderer.PackDocumentContent;
begin
  if FNeedPackDocumentContent then
    FNeedPackDocumentContent := not TryPackDocumentContent;
end;

function TdxPDFDocumentViewerCustomRenderer.GetCacheVisiblePagesOnly: Boolean;
begin
  Result := FStorage.CacheVisiblePagesOnly;
end;

procedure TdxPDFDocumentViewerCustomRenderer.SetCacheVisiblePagesOnly(const AValue: Boolean);
begin
  FStorage.CacheVisiblePagesOnly := AValue;
end;

function TdxPDFDocumentViewerCustomRenderer.CreatePageInfo(APageIndex: Integer): TdxPDFDocumentViewerCachePageInfo;
begin
  Result := TdxPDFDocumentViewerCachePageInfo.Create;
  Result.Index := APageIndex;
  Result.Factor := OnGetRenderFactor(APageIndex);
end;

procedure TdxPDFDocumentViewerCustomRenderer.AddPageIndex(APages: TdxPDFIntegerObjectDictionary<TdxPDFDocumentViewerCachePageInfo>;
  APageIndex: Integer);
begin
  if not APages.ContainsKey(APageIndex) then
    APages.Add(APageIndex, CreatePageInfo(APageIndex));
end;

procedure TdxPDFDocumentViewerCustomRenderer.AddPageIndexes(APages: TdxPDFIntegerObjectDictionary<TdxPDFDocumentViewerCachePageInfo>;
  AStartIndex, AEndIndex: Integer);
var
  I: Integer;
begin
  for I := AStartIndex to AEndIndex do
    AddPageIndex(APages, I);
end;

procedure TdxPDFDocumentViewerCustomRenderer.AddPageIndexesToRenderQueue(APages: TList<TdxPDFDocumentViewerCachePageInfo>;
  AForce: Boolean);
var
  I: Integer;
  AComparer: IComparer<TdxPDFDocumentViewerCachePageInfo>;
  APageInfo: TdxPDFDocumentViewerCachePageInfo;
  APageIndex: Integer;
  AFactor: Single;
begin
  FQueue.Clear;
  AComparer := TdxPDFDocumentViewerCachePageInfoComparer.Create;
  APages.Sort(AComparer);
  FStorage.SetVisiblePages(APages);
  for I := 0 to APages.Count - 1 do
  begin
    APageInfo := APages[I];
    APageIndex := APageInfo.Index;
    AFactor := APageInfo.Factor;
    if AForce or not FStorage.Contains(APageIndex, AFactor) then
    begin
      FStorage.Remove(APageIndex, True);
      FQueue.Enqueue(TdxPDFRenderTaskInfo.Create(APageIndex, AFactor));
    end;
  end;
end;

procedure TdxPDFDocumentViewerCustomRenderer.InitializeVisiblePageIndexes;
begin
  FStartVisiblePageIndex := -1;
  FEndVisiblePageIndex := -1;
end;

procedure TdxPDFDocumentViewerCustomRenderer.OnCancelRenderingHandler(Sender: TObject;
  const APageIndexes: TIntegerDynArray);
begin
  CancelRendering(APageIndexes);
end;

procedure TdxPDFDocumentViewerCustomRenderer.OnTimerHandler(Sender: TObject);
begin
  RenderNextPage;
end;

{ TdxPDFDocumentViewerAsyncRenderer }

constructor TdxPDFDocumentViewerAsyncRenderer.Create(AViewer: TdxPDFDocumentCustomViewer);
begin
  inherited Create(AViewer);
  FMaxActiveTaskCount := 1;
end;

function TdxPDFDocumentViewerAsyncRenderer.CanRenderNextPage: Boolean;
begin
  Result := (FActiveTaskCount < FMaxActiveTaskCount) and inherited CanRenderNextPage;
end;

function TdxPDFDocumentViewerAsyncRenderer.NeedProcessRenderTask(const ATask: TdxPDFRenderTaskInfo): Boolean;
begin
  Result := inherited NeedProcessRenderTask(ATask) or not Storage.CheckThumbnails(ATask.PageIndex, ATask.Factor);
end;

function TdxPDFDocumentViewerAsyncRenderer.TryPackDocumentContent: Boolean;
begin
  Result := TdxPDFBackgroundService(FService).TaskCount = 0;
  if Result then
    Result := inherited TryPackDocumentContent;
end;

procedure TdxPDFDocumentViewerAsyncRenderer.CancelRendering(const APageIndexes: TIntegerDynArray);
var
  I: Integer;
begin
  inherited CancelRendering(APageIndexes);
  for I := 0 to Length(APageIndexes) - 1 do
    TdxPDFBackgroundService(FService).CancelTask(APageIndexes[I]);
end;

procedure TdxPDFDocumentViewerAsyncRenderer.Clear;
begin
  inherited Clear;
  if FService <> nil then
    TdxPDFBackgroundService(FService).CancelAllAndWait;
  FActiveTaskCount := 0;
end;

procedure TdxPDFDocumentViewerAsyncRenderer.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FService := TdxPDFBackgroundService.Create;
  TdxPDFBackgroundService(FService).OnRenderingComplete := OnCompleteHandler;
  TdxPDFBackgroundService(FService).OnRenderingCanceled := OnCanceledHandler;
end;

procedure TdxPDFDocumentViewerAsyncRenderer.DestroySubClasses;
begin
  FreeAndNil(FService);
  inherited DestroySubClasses;
end;

procedure TdxPDFDocumentViewerAsyncRenderer.RenderNextPage;
begin
  if not FStopped then
    inherited RenderNextPage;
end;

procedure TdxPDFDocumentViewerAsyncRenderer.Render(APageIndex: Integer; AFactor: Single);
begin
  IncrementActiveTaskCount;
  TdxPDFDocumentCustomViewerPage(Viewer.Pages[APageIndex]).LockInteractiveLayerDrawing;
  TdxPDFBackgroundService(FService).AddRenderingByScaleFactorTask(Viewer, APageIndex, AFactor);
end;

procedure TdxPDFDocumentViewerAsyncRenderer.DecrementActiveTaskCount;
begin
  InterlockedDecrement(FActiveTaskCount);
  FActiveTaskCount := Max(FActiveTaskCount - 1, 0);
end;

procedure TdxPDFDocumentViewerAsyncRenderer.IncrementActiveTaskCount;
begin
  InterlockedIncrement(FActiveTaskCount);
end;

procedure TdxPDFDocumentViewerAsyncRenderer.OnCanceledHandler(APageIndex: Integer; AFactor: Single);
begin
  DecrementActiveTaskCount;
end;

procedure TdxPDFDocumentViewerAsyncRenderer.OnCompleteHandler(APageIndex: Integer; AFactor: Single; ABitmap: TBitmap);
begin
  Add(APageIndex, AFactor, ABitmap);
  TdxPDFDocumentCustomViewerPage(Viewer.Pages[APageIndex]).UnLockInteractiveLayerDrawing;
  Viewer.InvalidatePage(APageIndex);
  DecrementActiveTaskCount;
end;

procedure TdxPDFDocumentViewerAsyncRenderer.Start;
begin
  FStopped := False;
end;

procedure TdxPDFDocumentViewerAsyncRenderer.Stop;
begin
  FStopped := True;
end;

{ TdxPDFViewerCustomDocumentState }

constructor TdxPDFViewerCustomDocumentState.Create(AParent: TObject; AViewer: TdxPDFDocumentCustomViewer);
begin
  inherited Create(AParent);
  FViewer := AViewer;
end;

function TdxPDFViewerCustomDocumentState.ToDocumentRect(APage: TdxPDFDocumentCustomViewerPage; const R: TdxRectF): TdxRectF;
begin
  Result := APage.DocumentPage.FromUserSpace(R, DPI , ScaleFactor, dxRectF(APage.Bounds), Viewer.RotationAngle);
end;

function TdxPDFViewerCustomDocumentState.ToPageRect(APage: TdxPDFDocumentCustomViewerPage; const R: TdxRectF): TdxRectF;
begin
  Result := APage.DocumentPage.ToUserSpace(R, DPI, ScaleFactor, cxNullRect, Viewer.RotationAngle);
end;

function TdxPDFViewerCustomDocumentState.ToViewerPoint(APage: TdxPDFDocumentCustomViewerPage; const P: TdxPointF): TdxPointF;
begin
  Result := APage.DocumentPage.ToUserSpace(P, DPI, ScaleFactor, dxRectF(APage.Bounds), Viewer.RotationAngle);
end;

function TdxPDFViewerCustomDocumentState.ToViewerRect(APage: TdxPDFDocumentCustomViewerPage; const R: TdxRectF): TdxRectF;
begin
  Result := APage.DocumentPage.ToUserSpace(R, DPI, ScaleFactor, dxRectF(APage.Bounds), Viewer.RotationAngle);
end;

function TdxPDFViewerCustomDocumentState.TryPackDocumentContent: Boolean;
begin
  if not Viewer.IsDestroying then
    TdxPDFDocumentAccess(Viewer.Document).ClearRecognizedContent;
  Result := True;
end;

procedure TdxPDFViewerCustomDocumentState.CalculateScreenFactors;
begin
  FDocumentToViewerFactor := dxPointF(FDPI.X / 72, FDPI.Y / 72);
end;

procedure TdxPDFViewerCustomDocumentState.Initialize;
begin
  inherited Initialize;
  FDPI := dxPointF(96, 96);
end;

function TdxPDFViewerCustomDocumentState.CreateRenderParameters: TdxPDFRenderParameters;
begin
  Result := TdxPDFRenderParameters.Create(Self);
  Result.Angle := RotationAngle;
  Result.ScaleFactor := ScaleFactor.X * DocumentToViewerFactor.X;
end;

function TdxPDFViewerCustomDocumentState.ToDocumentPoint(APage: TdxPDFDocumentCustomViewerPage; const P: TdxPointF): TdxPointF;
begin
  Result := APage.DocumentPage.FromUserSpace(P, DPI , ScaleFactor, dxRectF(APage.Bounds), Viewer.RotationAngle);
end;

function TdxPDFViewerCustomDocumentState.GetDocument: TdxPDFDocument;
begin
  Result := Viewer.Document;
end;

function TdxPDFViewerCustomDocumentState.GetScaleFactor: TdxPointF;
begin
  Result.X := Viewer.ScaleFactor.Apply(Viewer.ZoomFactor) / 100;
  Result.Y := Viewer.ScaleFactor.Apply(Viewer.ZoomFactor) / 100;
end;

function TdxPDFViewerCustomDocumentState.GetTextExpansionFactor: TdxPointF;
begin
  Result.X := 15 / ScaleFactor.X;
  Result.Y := 5 / ScaleFactor.Y;
end;

procedure TdxPDFViewerCustomDocumentState.SetHandTool(const AValue: Boolean);
begin
  if FHandTool <> AValue then
  begin
    FHandTool := AValue;
    Viewer.ClearSelection;
  end;
end;

{ TdxPDFViewerCustomDocument }

constructor TdxPDFViewerCustomDocument.Create(AViewer: TdxPDFDocumentCustomViewer);
begin
  FViewer := AViewer;
  inherited Create;
end;

function TdxPDFViewerCustomDocument.DoCreateDocumentState: TdxPDFDocumentState;
begin
  Result := TdxPDFViewerCustomDocumentState.Create(Self, FViewer);
end;

procedure TdxPDFViewerCustomDocument.BeforeClear;
begin
  if not FViewer.IsDestroying then
  begin
    FViewer.BeforeClearDocument;
    FViewer.RecreateRenderer;
  end;
end;

{ TdxPDFDocumentCustomViewer }

destructor TdxPDFDocumentCustomViewer.Destroy;
begin
  DestroySubClasses;
  inherited Destroy;
end;

procedure TdxPDFDocumentCustomViewer.BoundsChanged;
var
  APageIndex: Integer;
begin
  inherited BoundsChanged;
  APageIndex := SelPageIndex;
  if HandleAllocated and (APageIndex > -1) and (APageIndex < PageCount) and not IsPageVisible(APageIndex) then
    MakePageVisible(APageIndex, False);
end;

procedure TdxPDFDocumentCustomViewer.Calculate(AType: TdxChangeType);
begin
  DoCalculate(AType);
end;

procedure TdxPDFDocumentCustomViewer.CreateSubClasses;
begin
  inherited CreateSubClasses;
  RecreateRenderer;
  FRenderContentTimer := TcxTimer.Create(Self);
  FRenderContentTimer.OnTimer := OnRenderContentTimerHandler;
end;

procedure TdxPDFDocumentCustomViewer.Clear;
begin
  FModified := False;
  RecreateRenderer;
end;

procedure TdxPDFDocumentCustomViewer.ScaleFactorChanged;
begin
  ClearRenderer;
  inherited ScaleFactorChanged;
end;

procedure TdxPDFDocumentCustomViewer.CheckMargins;
begin
// do nothing
end;

procedure TdxPDFDocumentCustomViewer.ResyncMargins;
begin
// do nothing
end;

procedure TdxPDFDocumentCustomViewer.ResyncSelPageIndex;
begin
  if not IsResyncSelPageIndexLocked then
  begin
    FNeedResyncSelPageIndex := False;
    inherited ResyncSelPageIndex
  end
  else
    FNeedResyncSelPageIndex := True;
end;

function TdxPDFDocumentCustomViewer.CanUpdateRenderQueue: Boolean;
begin
  Result := not IsUpdateLocked;
end;

function TdxPDFDocumentCustomViewer.CreateRenderer: TdxPDFDocumentViewerCustomRenderer;
begin
  if RenderContentInBackground then
    Result := TdxPDFDocumentViewerAsyncRenderer.Create(Self)
  else
    Result := TDefaultRenderer.Create(Self);
end;

procedure TdxPDFDocumentCustomViewer.BeforeClearDocument;
begin
  // do nothing
end;

procedure TdxPDFDocumentCustomViewer.ClearSelection;
begin
  // do nothing
end;

procedure TdxPDFDocumentCustomViewer.DestroySubClasses;
begin
  StopZoomTimer;
  FreeAndNil(FRenderContentTimer);
  FreeAndNil(FRenderer);
end;

procedure TdxPDFDocumentCustomViewer.DoCalculate(AType: TdxChangeType);
begin
  LayoutCalculator.Calculate(AType);
end;

procedure TdxPDFDocumentCustomViewer.Initialize;
begin
  inherited Initialize;
  RenderContentInBackground := True;
  RenderContentDelay := dxPDFDocumentViewerDefaultRenderContentDelay;
end;

procedure TdxPDFDocumentCustomViewer.RecreateRenderer;
begin
  FreeAndNil(FRenderer);
  FRenderer := CreateRenderer;
  FRenderer.OnGetRenderFactor := OnGetRenderFactorHandler;
end;

procedure TdxPDFDocumentCustomViewer.RestartRenderContentTimer;
begin
  if RenderContentDelay > 0 then
  begin
    StopZoomTimer;
    StartZoomTimer;
  end;
end;

procedure TdxPDFDocumentCustomViewer.UpdateRenderQueue(AForce: Boolean = False);
begin
  if CanUpdateRenderQueue then
    FRenderer.UpdateRenderQueue(AForce);
end;

function TdxPDFDocumentCustomViewer.GetNearestPageIndex(const P: TPoint; AGetPageBoundsFunc: TFunc<Integer, TdxRectF>): Integer;
var
  I: Integer;
  AMinDistance, ADistance: Single;
  R: TdxRectF;
begin
  Result := -1;
  if not Assigned(AGetPageBoundsFunc) then
    Exit;
  AMinDistance := MaxSingle;
  for I := 0 to PageCount - 1 do
  begin
    R := AGetPageBoundsFunc(I);
    if IsRectVisible(R) then
    begin
      ADistance := TdxPDFUtils.DistanceToRect(P, dxRectF(R.Left, R.Top, R.Right, R.Bottom));
      if ADistance < AMinDistance then
      begin
        AMinDistance := ADistance;
        Result := I;
      end;
    end;
  end;
end;

function TdxPDFDocumentCustomViewer.IsPageVisible(AIndex: Integer): Boolean;
var
  APage: TdxPDFViewerPage;
begin
  APage := TdxPDFViewerPage(Pages[AIndex]);
  Result := cxRectIntersect(ClientBounds, APage.Bounds);
end;

function TdxPDFDocumentCustomViewer.IsRectVisible(const ARect: TdxRectF): Boolean;
var
  R: TdxRectF;
begin
  Result := TdxPDFUtils.Intersects(R, ARect, dxRectF(ClientRect)) and TdxPDFUtils.RectIsEqual(R, ARect, 0.001);
end;

function TdxPDFDocumentCustomViewer.IsResyncSelPageIndexLocked: Boolean;
begin
  Result := FResyncSelPageIndexLockCount <> 0;
end;

procedure TdxPDFDocumentCustomViewer.ClearRenderer;
begin
  FRenderer.Clear;
end;

procedure TdxPDFDocumentCustomViewer.PerformRecreatePages(AProc: TProc);
begin
  if not Assigned(AProc) then
    Exit;
  Inc(FResyncSelPageIndexLockCount);
  try
    AProc;
  finally
    Dec(FResyncSelPageIndexLockCount);
    if FNeedResyncSelPageIndex then
      ResyncSelPageIndex;
  end;
end;

function TdxPDFDocumentCustomViewer.GetDocumentPages: TdxPDFPageList;
begin
  Result := TdxPDFPagesAccess(FDocument.Pages).List;
end;

function TdxPDFDocumentCustomViewer.GetDocumentState: TdxPDFViewerCustomDocumentState;
begin
  Result := TdxPDFDocumentAccess(FDocument).State as TdxPDFViewerCustomDocumentState;
end;

function TdxPDFDocumentCustomViewer.GetIsDocumentZooming: Boolean;
begin
  Result := FIsDocumentZooming and (FRenderContentDelay > 0);
end;

function TdxPDFDocumentCustomViewer.GetRotationAngle: TcxRotationAngle;
begin
  Result := TdxPDFDocumentAccess(Document).State.RotationAngle;
end;

procedure TdxPDFDocumentCustomViewer.SetRenderContentDelay(const AValue: Integer);
begin
  if FRenderContentDelay <> AValue then
  begin
    FRenderContentDelay := Min(Max(AValue, 50), 1000);
    FRenderContentTimer.Interval := RenderContentDelay;
  end;
end;

procedure TdxPDFDocumentCustomViewer.SetRenderContentInBackground(const AValue: Boolean);
begin
  if dxCanUseMultiThreading and (FRenderContentInBackground <> AValue) then
  begin
    FRenderContentInBackground := AValue;
    RecreateRenderer;
    DoZoomFactorChanged;
  end;
end;

procedure TdxPDFDocumentCustomViewer.StartZoomTimer;
begin
  Renderer.Stop;
  FIsDocumentZooming := True;
  FRenderContentTimer.Enabled := False;
  FRenderContentTimer.Enabled := True;
end;

procedure TdxPDFDocumentCustomViewer.StopZoomTimer;
begin
  FRenderContentTimer.Enabled := False;
  InvalidatePages;
  if Renderer <> nil then
    Renderer.Start;
  FIsDocumentZooming := False;
end;

procedure TdxPDFDocumentCustomViewer.Changed(AChanges: TdxPDFDocumentChanges);

  function IsLayoutChanged: Boolean;
  begin
    Result := dcLayout in AChanges;
  end;

  function IsDataChanged: Boolean;
  begin
    Result := dcData in AChanges;
  end;

  function IsBookmarksChanged: Boolean;
  begin
    Result := dcOutlines in AChanges;
  end;

  function IsAttachmentsChanged: Boolean;
  begin
    Result := dcAttachments in AChanges;
  end;

  function IsInteractiveLayerChanged: Boolean;
  begin
    Result := dcInteractiveLayer in AChanges;
  end;

begin
  FModified := True;
  if IsLayoutChanged and IsDataChanged and IsAttachmentsChanged and IsBookmarksChanged then
  begin
    DocumentLayoutChanged;
    DocumentAttachmentsChanged;
    DocumentBookmarksChanged;
    Exit;
  end;

  if IsLayoutChanged then
    DocumentLayoutChanged;

  if IsInteractiveLayerChanged then
    DocumentInteractiveLayerChanged;

  if IsDataChanged then
    DocumentDataChanged;

  if IsAttachmentsChanged then
     DocumentAttachmentsChanged;

  if IsBookmarksChanged then
     DocumentBookmarksChanged;
end;

procedure TdxPDFDocumentCustomViewer.DocumentDataChanged;
begin
  FForceUpdate := True;
  UpdateRenderQueue(FForceUpdate);
end;

procedure TdxPDFDocumentCustomViewer.DocumentLayoutChanged;
begin
  // do nothing
end;

procedure TdxPDFDocumentCustomViewer.DocumentInteractiveLayerChanged;
begin
  DocumentDataChanged;
end;

procedure TdxPDFDocumentCustomViewer.DocumentAttachmentsChanged;
begin
  // do nothing
end;

procedure TdxPDFDocumentCustomViewer.DocumentBookmarksChanged;
begin
  // do nothing
end;

function TdxPDFDocumentCustomViewer.OnGetRenderFactorHandler(APageIndex: Integer): Single;
begin
  Result := GetPageRenderFactor(APageIndex);
end;

procedure TdxPDFDocumentCustomViewer.OnRenderContentTimerHandler(Sender: TObject);
begin
  StopZoomTimer;
end;

{ TdxPDFDocumentCustomViewer.TDefaultRenderer }

destructor TdxPDFDocumentCustomViewer.TDefaultRenderer.Destroy;
begin
  ClearViewerCache;
  inherited Destroy;
end;

procedure TdxPDFDocumentCustomViewer.TDefaultRenderer.Start;
begin
  ClearViewerCache;
end;

procedure TdxPDFDocumentCustomViewer.TDefaultRenderer.DoDrawPage(ACanvas: TcxCanvas; APageIndex: Integer; const ARect: TRect);
var
  ACache: TdxPreviewPageContentCache;
  ADevice: TdxPDFGraphicsDevice;
  APage: TdxPDFDocumentCustomViewerPage;
  AParameters: TdxPDFRenderParameters;
  AViewer: TdxCustomPreviewAccess;
begin
  if not Viewer.IsZooming then
  begin
    AViewer := TdxCustomPreviewAccess(Viewer);
    APage := AViewer.Pages[APageIndex] as TdxPDFDocumentCustomViewerPage;
    ACache := AViewer.PagesContentCache.Add(APage);
    if ACache.Dirty then
    begin
      ACache.Canvas.Lock;
      try
        ACache.Dirty := False;
        ACache.cxCanvas.WindowOrg := APage.Bounds.TopLeft;
        AViewer.DrawPageBackground(ACache.cxCanvas, APage, APage.Selected);
        ACache.cxCanvas.WindowOrg := cxNullPoint;
        AParameters := Viewer.DocumentState.CreateRenderParameters;
        AParameters.Canvas := ACache.cxCanvas.Canvas;
        AParameters.Rect := ACache.ClientRect;
        try
          ADevice := TdxPDFGraphicsDevice.Create;
          try
            ADevice.Export(APage.DocumentPage, AParameters);
            PackDocumentContent;
          finally
            ADevice.Free;
          end;
        finally
          AParameters.Free;
        end;
      finally
        ACache.Canvas.Unlock;
      end;
      Add(APageIndex, Viewer.DocumentState.ScaleFactor.X, ACache);
    end;
    cxBitBlt(ACanvas.Handle, ACache.Canvas.Handle, APage.Bounds, cxNullPoint, SRCCOPY);
  end
  else
    inherited DoDrawPage(ACanvas, APageIndex, ARect);
end;

procedure TdxPDFDocumentCustomViewer.TDefaultRenderer.Render(APageIndex: Integer; AFactor: Single);
begin
  Viewer.InvalidatePage(APageIndex);
end;

procedure TdxPDFDocumentCustomViewer.TDefaultRenderer.ClearViewerCache;
begin
  TdxPreviewPageContentCachePoolAccess(TdxCustomPreviewAccess(Viewer).PagesContentCache).Clear;
end;

{ TdxPDFDocumentPageThumbnailViewer }

function TdxPDFDocumentPageThumbnailViewer.GetPagesToPrint: TIntegerDynArray;
begin
  Result := GetSelectedPages;
end;

function TdxPDFDocumentPageThumbnailViewer.GetSelectedPages: TIntegerDynArray;
var
  I: Integer;
begin
  FSelectedPages.Sort;
  SetLength(Result, FSelectedPages.Count);
  for I := 0 to FSelectedPages.Count - 1 do
    Result[I] := FSelectedPages[I] + 1;
end;

procedure TdxPDFDocumentPageThumbnailViewer.SaveSelection;
begin
  FSaveSelectedPages.Clear;
  FSaveSelectedPages.AddRange(FSelectedPages);
end;

procedure TdxPDFDocumentPageThumbnailViewer.RestoreSelection;
begin
  FSelectedPages.Clear;
  FSelectedPages.AddRange(FSaveSelectedPages);
  FSaveSelectedPages.Clear;
  if FSelectedPages.Count > 0 then
    SelPageIndex := FSelectedPages.First;
end;

function TdxPDFDocumentPageThumbnailViewer.CreateRenderer: TdxPDFDocumentViewerCustomRenderer;
begin
  Result := TRenderer.Create(Self);
end;

function TdxPDFDocumentPageThumbnailViewer.GetPageRenderFactor(APageIndex: Integer): Single;
begin
  Result := (PageList[APageIndex] as TPage).ImageSize;
end;

procedure TdxPDFDocumentPageThumbnailViewer.Calculate(AType: TdxChangeType);
begin
  CalculateCaptionSize;
  inherited Calculate(AType);
  UpdateRenderQueue;
end;

procedure TdxPDFDocumentPageThumbnailViewer.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FSelectedPages := TdxIntegerList.Create;
  FSaveSelectedPages := TdxIntegerList.Create;
end;

procedure TdxPDFDocumentPageThumbnailViewer.DestroySubClasses;
begin
  FreeAndNil(FPopupMenu);
  FreeAndNil(FSelectedPages);
  FreeAndNil(FSaveSelectedPages);
  inherited DestroySubClasses;
end;

procedure TdxPDFDocumentPageThumbnailViewer.DoCalculate(AType: TdxChangeType);
var
  I: Integer;
begin
  inherited DoCalculate(AType);
  for I := 0 to PageCount - 1 do
    TPage(PageList[I]).CalculateLayout;
end;

procedure TdxPDFDocumentPageThumbnailViewer.Initialize;
begin
  inherited Initialize;
  FMaxSize := dxPDFDocumentPageThumbnailViewerMaxSize;
  FMinSize := dxPDFDocumentPageThumbnailViewerMinSize;
  FSize := MinSize;
  BeginUpdate;
  try
    RenderContentDelay := 250;
    InternalOptionsBehavior := [pobThumbTracking];
    InternalOptionsView := [povAutoHideScrollBars, povDefaultDrawPageBackground];
    InternalOptionsZoom := [];
    OptionsHint := [];
    Keys := [kArrows, kChars];
  finally
    CancelUpdate;
  end;
end;

procedure TdxPDFDocumentPageThumbnailViewer.LookAndFeelChanged(Sender: TcxLookAndFeel;
  AChangedValues: TcxLookAndFeelValues);
begin
  inherited LookAndFeelChanged(Sender, AChangedValues);
  ClearRenderer;
  LayoutChanged(ctHard);
end;

function TdxPDFDocumentPageThumbnailViewer.CreatePage: TdxPreviewPage;
var
  ADocument: TdxPDFDocumentAccess;
  APage: TPage;
begin
  ADocument := TdxPDFDocumentAccess(FDocument);
  if (ADocument <> nil) and (ADocument.Pages <> nil) then
  begin
    Result := inherited CreatePage;
    APage := Result as TPage;
    if not ADocument.IsEmpty then
      APage.DocumentPage := TdxPDFPagesAccess(ADocument.Pages).List[PageCount - 1];
  end
  else
    Result := nil;
end;

function TdxPDFDocumentPageThumbnailViewer.CanMakeVisibleAnimate: Boolean;
begin
  Result := False;
end;

function TdxPDFDocumentPageThumbnailViewer.GetAbsoluteIndentLeft: Integer;
begin
  Result := 0;
end;

function TdxPDFDocumentPageThumbnailViewer.GetAbsoluteIndentRight: Integer;
begin
  Result := 0;
end;

function TdxPDFDocumentPageThumbnailViewer.GetCursor: TCursor;
begin
  Result := crDefault;
end;

function TdxPDFDocumentPageThumbnailViewer.GetDefaultZoomStep: Integer;
begin
  Result := 0;
end;

procedure TdxPDFDocumentPageThumbnailViewer.DocumentLayoutChanged;
begin
  RecreatePages;
end;

function TdxPDFDocumentPageThumbnailViewer.GetPageCaptionAreaHeight: Integer;
begin
  Result := PageCaptionSize.cy + PageCaptionMargin;
end;

function TdxPDFDocumentPageThumbnailViewer.GetPageCaptionMargin: Integer;
begin
  Result := ScaleFactor.Apply(10);
end;

function TdxPDFDocumentPageThumbnailViewer.GetPageClass: TdxPreviewPageClass;
begin
  Result := TPage;
end;

function TdxPDFDocumentPageThumbnailViewer.NonVerticalCenterizePages: Boolean;
begin
  Result := True;
end;

procedure TdxPDFDocumentPageThumbnailViewer.DoContextPopup(MousePos: TPoint; var Handled: Boolean);

  function ContextPopup(const P: TPoint): Boolean;
  begin
    if FPopupMenu = nil then
    begin
      FreeAndNil(FPopupMenu);
      FPopupMenu := TdxPDFViewerThumbnailsPopupMenu.Create(Owner);
    end;
    Result := (FPopupMenu as TdxPDFViewerCustomPopupMenu).Popup(P);
  end;

begin
  inherited DoContextPopup(MousePos, Handled);
  if not Handled then
    Handled := ContextPopup(ClientToScreen(MousePos));
end;

procedure TdxPDFDocumentPageThumbnailViewer.DoSelectedPageChanged;
begin
  inherited DoSelectedPageChanged;
  FCurrentFocusedPageIndex := Max(SelPageIndex, 0);
end;

procedure TdxPDFDocumentPageThumbnailViewer.DoZoomIn;
begin
  Size := Size + dxPDFDocumentPageThumbnailViewerSizeStep;
end;

procedure TdxPDFDocumentPageThumbnailViewer.DoZoomOut;
begin
  Size := Size - dxPDFDocumentPageThumbnailViewerSizeStep;
end;

procedure TdxPDFDocumentPageThumbnailViewer.DrawPageBackground(ACanvas: TcxCanvas; APage: TdxPreviewPage; ASelected: Boolean);
begin
// do nothing
end;

procedure TdxPDFDocumentPageThumbnailViewer.DrawViewerBackground(ACanvas: TcxCanvas; const R: TRect);
begin
  LookAndFeelPainter.PDFViewerDrawPageThumbnailPreviewBackground(ACanvas, R);
end;

procedure TdxPDFDocumentPageThumbnailViewer.KeyDown(var Key: Word; Shift: TShiftState);
var
  I: Integer;
begin
  if not (Key in [VK_RETURN, VK_ADD, VK_SUBTRACT]) then
  begin
    inherited KeyDown(Key, Shift);
    case Key of
      VK_ESCAPE:
        FSelectedPages.Clear;
      VK_LEFT, VK_RIGHT, VK_UP, VK_DOWN, VK_HOME, VK_END:
        if ssShift in Shift then
          UpdateSelectionRange;
      Ord('A'):
        if IsCtrlPressed then
        begin
          FSelectedPages.Clear;
          for I := 0 to PageCount - 1 do
            FSelectedPages.Add(I);
        end;
    end;
    Invalidate;
  end;
end;

procedure TdxPDFDocumentPageThumbnailViewer.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  APageIndex: Integer;
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbRight then
  begin
    APageIndex := GetNearestPageIndex(cxPoint(X, Y),
     function(AIndex: Integer): TdxRectF
      begin
        Result := dxRectF((Pages[AIndex] as TPage).ImageBounds);
      end);
    APageIndex := IfThen(APageIndex = -1, 0, APageIndex);
    if not FSelectedPages.Contains(APageIndex) then
    begin
      FSelectedPages.Clear;
      FSelectedPages.Add(APageIndex);
      Invalidate;
    end;
  end;
end;

procedure TdxPDFDocumentPageThumbnailViewer.ProcessLeftClickByPage(Shift: TShiftState; X, Y: Integer);
var
  APageIndex: Integer;
  AIsMouseLeftButtonPressed: Boolean;
  P: TPoint;
begin
  P := cxPoint(X, Y);
  AIsMouseLeftButtonPressed := True;
  APageIndex := PageList.PageIndexFromPoint(X, Y);
  if APageIndex >= 0 then
  begin
    if ssCtrl in Shift then
    begin
      if FSelectedPages.Contains(APageIndex) then
        FSelectedPages.Remove(APageIndex)
      else
        FSelectedPages.Add(APageIndex);
      FLastClickedPageIndex := APageIndex;
      SelPageIndex := APageIndex;
    end
    else
      if ssShift in Shift then
      begin
        FCurrentFocusedPageIndex := APageIndex;
        UpdateSelectionRange;
        FLastClickedPageIndex := APageIndex;
        SelPageIndex := APageIndex;
      end
      else
      begin
        FLastClickedPageIndex := APageIndex;
        SelPageIndex := APageIndex;
        FSelectedPages.Clear;
        FSelectedPages.Add(APageIndex);
      end;
    AIsMouseLeftButtonPressed := False;
  end;
  if AIsMouseLeftButtonPressed then
    if not (ssShift in Shift) then
      FSelectedPages.Clear;
  Invalidate;
end;

function TdxPDFDocumentPageThumbnailViewer.IsPageSelected(APageIndex: Integer): Boolean;
begin
  Result := FSelectedPages.Contains(APageIndex);
end;

procedure TdxPDFDocumentPageThumbnailViewer.Clear;
begin
  inherited Clear;
  Document := nil;
end;

procedure TdxPDFDocumentPageThumbnailViewer.SetDocument(const AValue: TdxPDFViewerCustomDocument);
begin
  if FDocument <> AValue then
  begin
    FSelectedPages.Clear;
    FSaveSelectedPages.Clear;

    Renderer.Clear;
    Size := 0;
    if Document <> nil then
      TdxPDFDocumentAccess(Document).RemoveListener(Self);
    FDocument := AValue;
    if Document <> nil then
      TdxPDFDocumentAccess(Document).AddListener(Self);

    RecreatePages;
  end;
end;

procedure TdxPDFDocumentPageThumbnailViewer.SetMaxSize(const AValue: Integer);
begin
  if FMaxSize <> AValue then
  begin
    FMaxSize := AValue;
    CheckSize;
  end;
end;

procedure TdxPDFDocumentPageThumbnailViewer.SetMinSize(const AValue: Integer);
begin
  if FMinSize <> AValue then
  begin
    FMinSize := AValue;
    CheckSize;
  end;
end;

procedure TdxPDFDocumentPageThumbnailViewer.SetSize(const AValue: Integer);
var
  I, ACurrentPageIndex, AActualValue: Integer;
begin
  AActualValue := Min(Max(AValue, MinSize), MaxSize);
  if FSize <> AActualValue then
  begin
    FSize := AActualValue;
    ACurrentPageIndex := SelPageIndex;
    BeginUpdate;
    try
      if Document <> nil then
        for I := 0 to Document.PageCount - 1 do
          TdxPDFDocumentCustomViewerPage(PageList[I]).CalculatePageSize;
      dxCallNotify(OnThumbnailSizeChanged, Self);
    finally
      EndUpdate;
    end;
    MakeVisible(ACurrentPageIndex);
    RestartRenderContentTimer;
    UpdateRenderQueue(True);
  end;
end;

procedure TdxPDFDocumentPageThumbnailViewer.CalculateCaptionSize;
begin
  if Document <> nil then
    FPageCaptionSize := cxTextSize(Font, IntToStr(Document.PageCount + 1))
  else
    FPageCaptionSize := cxNullSize;
end;

procedure TdxPDFDocumentPageThumbnailViewer.Changed(Sender: TObject; AFont: TFont);
begin
  Font.Assign(AFont);
  LayoutChanged(ctLight);
end;

procedure TdxPDFDocumentPageThumbnailViewer.CheckSize;
begin
  Size := TdxPDFUtils.MinMax(Size, FMinSize, FMaxSize);
end;

procedure TdxPDFDocumentPageThumbnailViewer.RecreatePages(AForce: Boolean = True);
begin
  BeginUpdate;
  try
    if AForce then
    begin
      Renderer.Clear;
      FSelectedPages.Clear;
    end;
    PerformRecreatePages(
      procedure
      var
        I: Integer;
      begin
        PageCount := 0;
        if (Document <> nil) and not TdxPDFDocumentAccess(Document).IsEmpty then
        begin
          CalculateCaptionSize;
          for I := 0 to Document.PageCount - 1 do
            CreatePage;
        end;
      end);
  finally
    EndUpdate;
  end;
end;

procedure TdxPDFDocumentPageThumbnailViewer.UpdateSelectionRange;
var
  I, AMaxIndex: Integer;
begin
  FSelectedPages.Clear;
  AMaxIndex := Max(FCurrentFocusedPageIndex, FLastClickedPageIndex);
  for I := Min(FCurrentFocusedPageIndex, FLastClickedPageIndex) to AMaxIndex do
    FSelectedPages.Add(I);
end;

{ TdxPDFDocumentPageThumbnailViewer.TPage }

procedure TdxPDFDocumentPageThumbnailViewer.TPage.Draw(ACanvas: TcxCanvas);
begin
  ACanvas.Lock;
  try
    DrawSelection(ACanvas);
    DrawFocusRect(ACanvas);
    DrawBackground(ACanvas);
    DrawContent(ACanvas);
    DrawIndex(ACanvas);
  finally
    ACanvas.Unlock;
  end;
end;

procedure TdxPDFDocumentPageThumbnailViewer.TPage.CalculatePageSize;
var
  ASize: TPoint;
begin
  ASize := GetPageSize(dxPointF(1, 1));
  PageSize.Assigned := not PageSize.Assigned;
  PageSize.Assigned := True;
  PageSize.MinUsefulSize := cxPoint(ThumbnailsPreview.Size, ThumbnailsPreview.Size);
  PageSize.Size := PageSize.MinUsefulSize;
end;

procedure TdxPDFDocumentPageThumbnailViewer.TPage.CalculateLayout;

  function GetImageMargins: TSize;
  begin
    Result.cx := Bounds.Width - ThumbnailsPreview.ScaleFactor.Apply(DefaultIndent * 2) -
      Max(ThumbnailsPreview.PageBorders.Left, ThumbnailsPreview.PageBorders.Top);
    Result.cy := Bounds.Height - ThumbnailsPreview.ScaleFactor.Apply(DefaultIndent * 2) -
      ThumbnailsPreview.PageCaptionAreaHeight - Max(ThumbnailsPreview.PageBorders.Right, ThumbnailsPreview.PageBorders.Bottom);
  end;

  function GetRealPageSize: TPoint;
  var
    AMaximumSize: TSize;
    APageSize: TPoint;
    AScale: Single;
  begin
    AMaximumSize := GetImageMargins;
    APageSize := GetPageSize(dxPointF(1, 1));
    AScale := Min(AMaximumSize.cx / Max(1, APageSize.X), AMaximumSize.cy / Max(1, APageSize.Y));
    Result := GetPageSize(dxPointF(AScale, AScale));
  end;

var
  APageSize: TPoint;
  ASelectionSize: TRect;
begin
  FThumbnailBounds := Bounds;

  APageSize := GetRealPageSize;
  FImageBounds.Left := Bounds.Left + (Bounds.Width - APageSize.X) div 2;
  FImageBounds.Top := Bounds.Top + (Bounds.Height - APageSize.Y - ThumbnailsPreview.PageCaptionSize.cy) div 2;
  FImageBounds.Width := APageSize.X;
  FImageBounds.Height := APageSize.Y;

  FImageBorderBounds := cxRectInflate(FImageBounds, ThumbnailsPreview.PageBorders);

  ASelectionSize := GetSelectionSize;
  FSelectionBounds := cxRectInflate(FImageBounds, ASelectionSize);

  FCaptionBounds.Left := Bounds.Left + (Bounds.Width - ThumbnailsPreview.PageCaptionSize.cx) div 2;
  FCaptionBounds.Top := FSelectionBounds.Bottom + ThumbnailsPreview.PageCaptionMargin div 2;
  FCaptionBounds.Width := ThumbnailsPreview.PageCaptionSize.cx;
  FCaptionBounds.Height := ThumbnailsPreview.PageCaptionSize.cy;
end;

procedure TdxPDFDocumentPageThumbnailViewer.TPage.DrawBackground(ACanvas: TcxCanvas);
begin
  ThumbnailsPreview.LookAndFeel.Painter.DrawPrintPreviewPageBackground(ACanvas, FImageBorderBounds, FImageBounds,
    False, False);
end;

procedure TdxPDFDocumentPageThumbnailViewer.TPage.DrawContent(ACanvas: TcxCanvas);
begin
  ThumbnailsPreview.Renderer.DrawPage(ACanvas, Index, FImageBounds);
end;

procedure TdxPDFDocumentPageThumbnailViewer.TPage.DrawFocusRect(ACanvas: TcxCanvas);
begin
  if Selected and ThumbnailsPreview.LookAndFeel.Painter.SupportsNativeFocusRect then
    ACanvas.DrawFocusRect(FSelectionBounds);
end;

procedure TdxPDFDocumentPageThumbnailViewer.TPage.DrawSelection(ACanvas: TcxCanvas);
begin
  if ThumbnailsPreview.IsPageSelected(Index) then
    dxGpFillRect(ACanvas.Handle, FSelectionBounds, ThumbnailsPreview.LookAndFeel.Painter.DefaultSelectionColor, 200);
end;

procedure TdxPDFDocumentPageThumbnailViewer.TPage.DrawIndex(ACanvas: TcxCanvas);
begin
  ACanvas.Font.Assign(ThumbnailsPreview.Font);
  ACanvas.Font.Color := cxGetActualColor(ThumbnailsPreview.LookAndFeelPainter.GetWindowContentTextColor, clWindowText);
  cxDrawText(ACanvas, IntToStr(Index + 1), FCaptionBounds, DT_VCENTER or DT_SINGLELINE or DT_CENTER);
end;

function TdxPDFDocumentPageThumbnailViewer.TPage.GetImageSize: Integer;
begin
  if ThumbnailsPreview.RotationAngle in [ra0, ra180] then
    Result := FImageBounds.Width
  else
    Result := FImageBounds.Height;
end;

function TdxPDFDocumentPageThumbnailViewer.TPage.GetSelectionSize: TRect;
begin
  Result := ThumbnailsPreview.ScaleFactor.Apply(cxRect(DefaultIndent, DefaultIndent, DefaultIndent, DefaultIndent));
end;

function TdxPDFDocumentPageThumbnailViewer.TPage.GetThumbnailsPreview: TdxPDFDocumentPageThumbnailViewer;
begin
  Result := Preview as TdxPDFDocumentPageThumbnailViewer;
end;

{ TdxPDFDocumentPageThumbnailViewer.TRenderer }

function TdxPDFDocumentPageThumbnailViewer.TRenderer.GetPreRenderPageScale(APageIndex: Integer): Single;
begin
  Result := Viewer.GetPageRenderFactor(APageIndex) / Viewer.Document.PageInfo[APageIndex].Size.X;
end;

function TdxPDFDocumentPageThumbnailViewer.TRenderer.GetRenderingPageRowDelta: Integer;
begin
  Result := 0;
end;

procedure TdxPDFDocumentPageThumbnailViewer.TRenderer.CreateSubClasses;
begin
  inherited CreateSubClasses;
  CacheVisiblePagesOnly := True;
end;

procedure TdxPDFDocumentPageThumbnailViewer.TRenderer.Render(APageIndex: Integer; AFactor: Single);
begin
  TdxPDFBackgroundService(FService).AddRenderingBySizeTask(Viewer, APageIndex, AFactor);
end;

{ TdxPDFViewerPageSizeOptions }

function TdxPDFViewerPageSizeOptions.GetActualSizeInPixels: TPoint;
begin
  Result := Size;
end;

function TdxPDFViewerPageSizeOptions.GetDefaultMinUsefulSize: TPoint;
begin
  Result := cxPoint(2, 2);
end;

{ TdxPDFDocumentCustomViewerPage }

constructor TdxPDFDocumentCustomViewerPage.Create(APreview: TdxCustomPreview);
begin
  inherited Create(APreview);
  LockInteractiveLayerDrawing;
end;

function TdxPDFDocumentCustomViewerPage.GetPageSizeOptionsClass: TdxPreviewPageSizeOptionsClass;
begin
  Result := TdxPDFViewerPageSizeOptions;
end;

function TdxPDFDocumentCustomViewerPage.GetPageSize(const AScreenFactor: TdxPointF): TPoint;
var
  ASize: TdxPointF;
begin
  ASize := TdxPDFViewerViewState.CalculatePageSize(DocumentPage.Size, TdxPDFDocumentCustomViewer(Preview).RotationAngle);
  Result.X := Round(ASize.X * AScreenFactor.X);
  Result.Y := Round(ASize.Y * AScreenFactor.Y);
end;

function TdxPDFDocumentCustomViewerPage.ToDocumentPoint(const P: TdxPointF): TdxPointF;
begin
  Result := DocumentState.ToDocumentPoint(Self, P);
end;

function TdxPDFDocumentCustomViewerPage.ToDocumentRect(const R: TdxRectF): TdxRectF;
begin
  Result := DocumentState.ToDocumentRect(Self, R);
end;

function TdxPDFDocumentCustomViewerPage.ToPageRect(const R: TdxRectF): TdxRectF;
begin
  Result := DocumentState.ToPageRect(Self, R);
end;

function TdxPDFDocumentCustomViewerPage.ToViewerPoint(const P: TdxPointF): TdxPointF;
begin
  Result := DocumentState.ToViewerPoint(Self, P);
end;

function TdxPDFDocumentCustomViewerPage.ToViewerRect(const R: TdxRectF): TdxRectF;
begin
  Result := DocumentState.ToViewerRect(Self, R);
end;

function TdxPDFDocumentCustomViewerPage.IsInteractiveLayerDrawingLocked: Boolean;
begin
  Result := FInteractiveLayerDrawingLockCount <> 0;
end;

procedure TdxPDFDocumentCustomViewerPage.LockInteractiveLayerDrawing;
begin
  FInteractiveLayerDrawingLockCount := 1;
end;

procedure TdxPDFDocumentCustomViewerPage.UnLockInteractiveLayerDrawing;
begin
  FInteractiveLayerDrawingLockCount := 0;
end;

function TdxPDFDocumentCustomViewerPage.GetDocumentState: TdxPDFViewerCustomDocumentState;
begin
  Result := TdxPDFDocumentCustomViewer(Preview).DocumentState;
end;

procedure TdxPDFDocumentCustomViewerPage.SetDocumentPage(const AValue: TdxPDFPage);
begin
  if DocumentPage <> AValue then
  begin
    FDocumentPage := AValue;
    CalculatePageSize;
  end;
end;

{ TdxPDFDocumentOutlineItem }

constructor TdxPDFDocumentOutlineItem.Create(AOutline: TdxPDFOutline; AID, AParentID: Integer);
begin
  inherited Create;
  FOutline := AOutline;
  FID := AID;
  FParentID := AParentID;
  if FOutline <> nil then
  begin
    if not FOutline.Color.IsNull then
      FColor := dxAlphaColorToColor(TdxPDFUtils.ConvertToAlphaColor(AOutline.Color, 1))
    else
      FColor := dxPDFOutlineTreeItemDefaultColor;
    FTitle := FOutline.Title;
    FIsItalic := FOutline.IsItalic;
    FIsBold := FOutline.IsBold;
    FHasChildren := FOutline.First <> nil;
  end;
end;

{ TdxPDFDocumentOutlineItem }

function TdxPDFDocumentOutlineItem.GetInteractiveOperation: TdxPDFInteractiveOperation;
begin
  if not FInteractiveOperation.IsValid then
    FInteractiveOperation := TdxPDFInteractiveOperation.Create(FOutline.Action, FOutline.Destination);
  Result := FInteractiveOperation;
end;

{ TdxPDFDocumentOutlineList }

function TdxPDFDocumentOutlineList.GetPrintPageNumbers(AItems: TList<TdxPDFDocumentOutlineItem>;
  APrintSection: Boolean): TIntegerDynArray;

  procedure Calculate(AOutline: TdxPDFOutline; APageNumbers: TdxIntegerList);
  var
    AOutlinePageNumber, ANextOutlinePageNumber, APageNumber: Integer;
  begin
    AOutlinePageNumber := GetPageNumber(AOutline);
    if AOutlinePageNumber = 0 then
      Exit;
    if not APageNumbers.Contains(AOutlinePageNumber) then
      APageNumbers.Add(AOutlinePageNumber);
    if APrintSection then
    begin
      ANextOutlinePageNumber := GetNextPageNumber(AOutline);
      if ANextOutlinePageNumber = 0 then
        Exit;
      if ANextOutlinePageNumber > AOutlinePageNumber then
      begin
        for APageNumber := AOutlinePageNumber + 1 to ANextOutlinePageNumber - 1 do
          if not APageNumbers.Contains(APageNumber) then
            APageNumbers.Add(APageNumber);
      end
      else
        if ANextOutlinePageNumber < AOutlinePageNumber then
          for APageNumber := AOutlinePageNumber - 1 downto ANextOutlinePageNumber + 1 do
            if not APageNumbers.Contains(APageNumber) then
              APageNumbers.Add(APageNumber);
    end;
  end;

  procedure CalculatePageNumbers(AOutline: TdxPDFOutline; APageNumbers: TdxIntegerList);
  var
    AChild: TdxPDFOutline;
  begin
    if AOutline <> nil then
    begin
      Calculate(AOutline, APageNumbers);
      AChild := AOutline.First;
      if AChild <> nil then
        CalculatePageNumbers(AChild, APageNumbers);
    end;
  end;

var
  I: Integer;
  APageNumbers: TdxIntegerList;
  AItem: TdxPDFDocumentOutlineItem;
begin
  SetLength(Result, 0);
  APageNumbers := TdxIntegerList.Create;
  try
    for AItem in AItems do
      CalculatePageNumbers(AItem.Outline, APageNumbers);
    APageNumbers.Sort;
    SetLength(Result, APageNumbers.Count);
    for I := 0 to APageNumbers.Count - 1 do
      Result[I] := APageNumbers[I];
  finally
    APageNumbers.Free;
  end;
end;

procedure TdxPDFDocumentOutlineList.Read(ACatalog: TdxPDFCatalog);
var
  AOutlines: TdxPDFOutlines;
begin
  Clear;
  if ACatalog <> nil then
  begin
    FPages := ACatalog.Pages;
    try
      AOutlines := TdxPDFCatalogAccess(ACatalog).Outlines as TdxPDFOutlines;
      if AOutlines <> nil then
        AddOutline(AOutlines.First, 0);
    except
      on EdxPDFException do;
      on EdxPDFAbortException do;
      else
        raise;
    end;
  end;
end;

function TdxPDFDocumentOutlineList.AddOutline(AOutline: TdxPDFOutline; AParentID: Integer): Integer;
begin
  Result := AParentID;
  while AOutline <> nil do
  begin
    Inc(Result);
    Add(TdxPDFDocumentOutlineItem.Create(AOutline, Result, AParentID));
    if AOutline.First <> nil then
      Result := AddOutline(AOutline.First, Result);
    AOutline := AOutline.Next;
  end;
end;

function TdxPDFDocumentOutlineList.GetNextPageNumber(AOutline: TdxPDFOutline): Integer;
var
  ANextOutline: TdxPDFOutline;
begin
  repeat
    ANextOutline := AOutline.Next;
    if ANextOutline <> nil then
      Exit(GetPageNumber(ANextOutline));
    AOutline := Safe<TdxPDFOutline>.Cast(AOutline.Parent);
  until AOutline = nil;
  Result := FPages.Count + 1;
end;

function TdxPDFDocumentOutlineList.GetPageNumber(AOutline: TdxPDFOutline): Integer;
var
  ADestination: TdxPDFCustomDestinationAccess;
begin
  ADestination := TdxPDFCustomDestinationAccess(AOutline.ActualDestination);
  if ADestination <> nil then
    Result := ADestination.GetTarget.PageIndex + 1
  else
    Result := 0;
end;

end.
