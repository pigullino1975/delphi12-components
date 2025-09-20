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

unit cxFontNameComboBox;

interface

{$I cxVer.inc}

uses
  System.UITypes,
  Variants, Windows, Classes, Controls, Dialogs, Forms, Graphics, Messages, ImgList, SysUtils, Types,
  Generics.Defaults, Generics.Collections, StdCtrls,
  dxCore, dxCoreClasses, dxThreading, cxGeometry, cxGraphics, cxClasses, cxContainer, cxControls, cxButtons,
  cxDataStorage, cxVariants, cxEdit, cxTextEdit, cxDropDownEdit, cxEditUtils, dxGDIPlusClasses,
  cxExtEditConsts, cxExtEditUtils, cxImageComboBox, cxLookAndFeels, cxMaskEdit, dxSkinInfo,
  cxFilterControlUtils;

const
 {$EXTERNALSYM SYMBOL_FONTTYPE}
  SYMBOL_FONTTYPE = 256;
  FIXEDPITCH_FONTTYPE = 512;

type
  TcxFontType = (cxftTTF, cxftRaster, cxftDevice, cxftFixed, cxftSymbol);
  TcxFontTypes = set of TcxFontType;
  TcxShowFontIconType = (ftiShowInCombo, ftiShowInList);
  TcxShowFontIconTypes = set of TcxShowFontIconType;
  TcxMRUFontNameAction = (mfaInvalidFontName, mfaNone, mfaMoved, mfaAdded, mfaDeleted);
  TcxFontPreviewType = (cxfpFontName, cxfpCustom, cxfpFullAlphabet);
  TcxDeleteMRUFontEvent = procedure(Sender: TObject; const DeletedMRUFontName: string) of object;

  { TcxMRUFontNameItem }

  TcxMRUFontNameItem = class(TCollectionItem)
  private
    FFontName: TFontName;
    FTag: TcxTag;
    function IsTagStored: Boolean;
    procedure SetFontName(const Value: TFontName);
  public
    procedure Assign(Source: TPersistent); override;
  published
    property FontName: TFontName read FFontName write SetFontName;
    property Tag: TcxTag read FTag write FTag stored IsTagStored;
  end;

  { TcxMRUFontNameItems }

  TcxMRUFontNameItems = class(TOwnedCollection)
  strict private
    function GetItems(Index: Integer): TcxMRUFontNameItem;
    procedure SetItems(Index: Integer; const Value: TcxMRUFontNameItem);
  protected
    procedure Update(Item: TCollectionItem); override;
    function Add: TcxMRUFontNameItem;
    function Insert(Index: Integer): TcxMRUFontNameItem;
    function AddMRUFontName(const AFontName: TFontName): TcxMRUFontNameItem; virtual;
    function InsertMRUFontName(AIndex: Integer; const AFontName: TFontName): TcxMRUFontNameItem; virtual;
    procedure Move(ACurIndex, ANewIndex: Integer); virtual;
  public
    constructor Create(AOwner: TPersistent; ItemClass: TCollectionItemClass);
    destructor Destroy; override;
    property Items[Index: Integer]: TcxMRUFontNameItem read GetItems write SetItems; default;
    function FindFontName(const AFontName: TFontName): TcxMRUFontNameItem; virtual;
  end;

  { TcxFontLoader }

  TcxFontLoader = class(TThread)
  private
    FFontTypes: TcxFontTypes;

    class function EnumFontsProc(var ALogFont: TLogFont; var ATextMetric: TTextMetric; AFontType: DWORD; AData: LPARAM): Integer; stdcall; static;
    procedure DoCompleteEvent;
    procedure DoDestroyEvent;
  protected
    procedure Execute; override;
  public
    OnCompleteThread: TNotifyEvent;
    OnDestroyThread: TNotifyEvent;
    FontList: TStringList;

    constructor Create(const AFontTypes: TcxFontTypes); virtual;
    destructor Destroy; override;
  end;

  TcxSystemFontLoader = class(TdxTask)
  private type
    TFontLoaderListener = record
      FreeNotificatior: TComponent;
      CompleteHandler: TNotifyEvent;
      Items: TStrings;
      FontTypes: TcxFontTypes;
    public
      class function Create(AFreeNotificatior: TComponent; ACompleteHandler: TNotifyEvent; AItems: TStrings; AFontTypes: TcxFontTypes): TFontLoaderListener; static; inline;
    end;
  private
    FFinished: Boolean;
    FFontList: TStringList;
    FFreeNotificator: TcxFreeNotificator;
    FListeners: TList<TFontLoaderListener>;

    procedure CompleteHandler;
    procedure DeleteListener(AFreeNotificatior: TComponent);
    class function EnumFontsProc(var ALogFont: TLogFont; var ATextMetric: TTextMetric; AFontType: DWORD; AData: LPARAM): Integer; stdcall; static;
  protected
    procedure Complete; override;
    procedure DoFreeNotification(Sender: TComponent);
    procedure InternalPopulateFonts(AListener: TFontLoaderListener);

    property FontList: TStringList read FFontList;
    property Finished: Boolean read FFinished;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Execute; override;
    procedure PopulateFonts(AFreeNotificatior: TComponent; ACompleteHandler: TNotifyEvent; AItems: TStrings; AFontTypes: TcxFontTypes);
  end;

  TcxFontButtonType = (cxfbtBold, cxfbtItalic, cxfbtUnderline, cxfbtStrikeOut);
  TcxFontButtonClickEvent = procedure(Sender: TObject; ButtonType: TcxFontButtonType) of Object;

  { TcxFontPreview }

  TcxFontPreview = class(TPersistent)
  strict private
    FAlignment: TAlignment;
    FColor: TColor;
    FFontStyle: TFontStyles;
    FIsDestroying: Boolean;
    FModified: Boolean;
    FOwner: TPersistent;
    FPreviewText: TCaption;
    FPreviewType: TcxFontPreviewType;
    FShowButtons: Boolean;
    FShowEndEllipsis: Boolean;
    FUpdateCount: Integer;
    FVisible: Boolean;
    FWordWrap: Boolean;

    FOnChanged: TNotifyEvent;
    FOnButtonClick: TcxFontButtonClickEvent;

    procedure BeginUpdate;
    procedure EndUpdate;
    function IsDestroying: Boolean;
    procedure SetFontStyle(Value: TFontStyles);
    procedure SetVisible(Value: Boolean);
    procedure SetPreviewType(Value: TcxFontPreviewType);
    procedure SetPreviewText(Value: TCaption);
    procedure SetAlignment(Value: TAlignment);
    procedure SetShowEndEllipsis(Value: Boolean);
    procedure SetColor(Value: TColor);
    procedure SetWordWrap(Value: Boolean);
    procedure SetShowButtons(Value: Boolean);
  protected
    function GetOwner: TPersistent; override;
    procedure Changed; virtual;
  public
    constructor Create(AOwner: TPersistent); virtual;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property FontStyle: TFontStyles read FFontStyle write SetFontStyle default [];
    property Visible: Boolean read FVisible write SetVisible default True;
    property PreviewType: TcxFontPreviewType read FPreviewType write SetPreviewType default cxfpFontName;
    property PreviewText: TCaption read FPreviewText write SetPreviewText;
    property Alignment: TAlignment read FAlignment write SetAlignment default taCenter;
    property ShowButtons: Boolean read FShowButtons write SetShowButtons default True;
    property ShowEndEllipsis: Boolean read FShowEndEllipsis write SetShowEndEllipsis default True;
    property Color: TColor read FColor write SetColor default clWindow;
    property WordWrap: Boolean read FWordWrap write SetWordWrap default False;
    property OnButtonClick: TcxFontButtonClickEvent read FOnButtonClick write FOnButtonClick;
  end;

  { TFontPreviewPanel }

  TFontPreviewPanel = class(TcxCustomControl)
  strict private
    FAlignment: TAlignment;
    FBorderColor: TColor;
    FButtons: array [TFontStyle] of TcxButton;
    FcxCanvas: TcxCanvas;
    FEdges: TcxBorders;
    FFontColor: TColor;
    FFontName: string;
    FFontStyle: TFontStyles;
    FLocked: Boolean;
    FLookAndFeel: TcxLookAndFeel;
    FShowButtons: Boolean;
    FShowEndEllipsis: Boolean;
    FWordWrap: Boolean;

    procedure SetLocked(Value: Boolean);
    procedure SetAlignment(Value: TAlignment);
    procedure SetShowEndEllipsis(Value: Boolean);
    procedure SetEdges(Value: TcxBorders);
    procedure SetFontName(Value: string);
    procedure SetFontStyle(Value: TFontStyles);
    procedure SetWordWrap(Value: Boolean);
    procedure SetShowButtons(Value: Boolean);
    procedure SetLookAndFeel(Value: TcxLookAndFeel);
    function GetTextFlag(const AStartFlag: Longint): Longint;
    procedure CreateButtons;
    procedure SetFontStyleButtonsState;
    procedure FontButtonsClickHandler(Sender: TObject);
  protected
    FontPreview: TcxFontPreview;

    procedure Paint; override;
    procedure CalculateFont(const ARect: TRect); virtual;
    function CalculateFontStyle: TFontStyles; virtual;

    property cxCanvas: TcxCanvas read FcxCanvas write FcxCanvas;
    property Locked: Boolean read FLocked write SetLocked default False;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure RealignButtons;

    property BorderColor: TColor read FBorderColor write FBorderColor;
    property Color default clWindow;
    property Alignment: TAlignment read FAlignment write SetAlignment default taCenter;
    property ShowEndEllipsis: Boolean read FShowEndEllipsis write SetShowEndEllipsis default True;
    property Edges: TcxBorders read FEdges write SetEdges default [bLeft, bTop, bRight, bBottom];
    property FontColor: TColor read FFontColor write FFontColor;
    property FontStyle: TFontStyles read FFontStyle write SetFontStyle default [];
    property FontName: string read FFontName write SetFontName;
    property WordWrap: Boolean read FWordWrap write SetWordWrap default False;
    property ShowButtons: Boolean read FShowButtons write SetShowButtons default True;
    property LookAndFeel: TcxLookAndFeel read FLookAndFeel write SetLookAndFeel;
  end;

  { TcxCustomFontNameComboBoxViewInfo }
  
  TcxCustomFontNameComboBoxViewInfo = class(TcxCustomTextEditViewInfo)
  private
    FCurrentIndex: Integer;
    FIsTrueTypeFont: Boolean;
    FShowFontTypeIcon: TcxShowFontIconTypes;
    ImageRect: TRect;
  protected
    SaveClient: TRect;

    property IsTrueTypeFont: Boolean read FIsTrueTypeFont write FIsTrueTypeFont;
    property ShowFontTypeIcon: TcxShowFontIconTypes read FShowFontTypeIcon write FShowFontTypeIcon;
  public
    procedure Paint(ACanvas: TcxCanvas); override;
    procedure Offset(DX, DY: Integer); override;
  end;

  { TcxCustomFontNameComboBoxViewData }

  TcxCustomFontNameComboBoxProperties = class;

  TcxCustomFontNameComboBoxViewData = class(TcxCustomDropDownEditViewData)
  strict private
    function GetProperties: TcxCustomFontNameComboBoxProperties;
  protected
    function IsComboBoxStyle: Boolean; override;
  public
    procedure Calculate(ACanvas: TcxCanvas; const ABounds: TRect; const P: TPoint; Button: TcxMouseButton;
      Shift: TShiftState; AViewInfo: TcxCustomEditViewInfo; AIsMouseEvent: Boolean); override;
    procedure DisplayValueToDrawValue(const ADisplayValue: TcxEditValue; AViewInfo: TcxCustomEditViewInfo); override;
    procedure EditValueToDrawValue(const AEditValue: TcxEditValue; AViewInfo: TcxCustomEditViewInfo); override;
    function GetEditContentSize(ACanvas: TcxCanvas; const AEditValue: TcxEditValue;
      const AEditSizeProperties: TcxEditSizeProperties; AErrorData: TcxEditValidateInfo = nil): TSize; override;
    property Properties: TcxCustomFontNameComboBoxProperties read GetProperties;
  end;

  { TcxFontNameComboBoxListBox }

  TcxCustomFontNameComboBox = class;

  TcxFontNameComboBoxListBox = class(TcxCustomComboBoxListBox)
  strict private
    function GetActiveProperties: TcxCustomFontNameComboBoxProperties;
    function GetEdit: TcxCustomFontNameComboBox;
    function GetScaleFactor: TdxScaleFactor;
    function IsSymbolFontType(AItemIndex: Integer): Boolean;
  protected
    FGlyphLeftIndent: Integer;
    FGlyphRightIndent: Integer;
    FTextIndent: Integer;
    function GetRealStyle: TListBoxStyle; override;
    function IsBufferedItemPaint: Boolean; override;

    procedure CalculatePadding; override;
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
    procedure DrawItemContent(AIndex: Integer; ARect: TRect; AState: TOwnerDrawState); override;
    function GetDefaultItemPadding: TdxPadding; override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    property ActiveProperties: TcxCustomFontNameComboBoxProperties read GetActiveProperties;
    property Edit: TcxCustomFontNameComboBox read GetEdit;
    property ScaleFactor: TdxScaleFactor read GetScaleFactor;
  public
    function GetItemHeight(AIndex: Integer = -1): Integer; override;
    function GetItemWidth(AIndex: Integer): Integer; override;
  end;

  { TcxFontNameComboBoxLookupData }
  
  TcxFontNameComboBoxLookupData = class(TcxComboBoxLookupData)
  strict private
    FPanel: TFontPreviewPanel;

    function GetActiveProperties: TcxCustomFontNameComboBoxProperties;
    function GetFontName: string;
    function GetPreviewText: string;
    function GetScaleFactor: TdxScaleFactor; inline;
  protected
    procedure DoInitialize(AVisualControlsParent: TWinControl); override;
    procedure DoPositionVisualArea(const ARect: TRect); override;
    function GetListBoxClass: TcxCustomEditListBoxClass; override;
    procedure HandleSelectItem(Sender: TObject); override;
    procedure InternalChangeCurrentMRUFontNamePosition; virtual;

    property ActiveProperties: TcxCustomFontNameComboBoxProperties read GetActiveProperties;
    property ScaleFactor: TdxScaleFactor read GetScaleFactor;
  public
    destructor Destroy; override;
    function CanResizeVisualArea(var NewSize: TSize; AMaxHeight: Integer = 0; AMaxWidth: Integer = 0): Boolean; override;
    function GetVisualAreaPreferredSize(AMaxHeight: Integer; AWidth: Integer = 0): TSize; override;
  end;

  { TcxCustomFontNameComboBoxProperties }

  TcxCustomFontNameComboBoxProperties = class(TcxCustomComboBoxProperties)
  private
    FFontPreview: TcxFontPreview;
    FFontTypes: TcxFontTypes;
    FLoadFontComplete: Boolean;
    FMaxMRUFonts: Byte;
    FMRUFontNames: TcxMRUFontNameItems;
    FShowFontTypeIcon: TcxShowFontIconTypes;
    FUseOwnFont: Boolean;
    FOnAddedMRUFont: TNotifyEvent;
    FOnDeletedMRUFont: TcxDeleteMRUFontEvent;
    FOnInternalLoadFontComplete: TNotifyEvent;
    FOnLoadFontComplete: TNotifyEvent;
    FOnMovedMRUFont: TNotifyEvent;

    function GetFontItems: TStrings;
    function GetFontTypes: TcxFontTypes;
    function GetUseOwnFont: Boolean;
    procedure SetMaxMRUFonts(Value: Byte);
    procedure SetFontTypes(Value: TcxFontTypes);
    procedure SetUseOwnFont(Value: Boolean);
    procedure SetShowFontTypeIcon(Value: TcxShowFontIconTypes);
    function FindItemByValue(const AEditValue: TcxEditValue): Integer;
    procedure DeleteOverMRUFonts;
    procedure FontLoaderCompleteHandler(Sender: TObject);
    function GetItemTypes(Index: Integer): TcxFontTypes;
    procedure SetFontPreview(Value: TcxFontPreview);
  protected
    procedure DoAssign(AProperties: TcxCustomEditProperties); override;
    function FindLookupText(const AText: string): Boolean; override;
    class function GetLookupDataClass: TcxInterfacedPersistentClass; override;
    class function GetViewDataClass: TcxCustomEditViewDataClass; override;
    function AddMRUFontName(const AFontName: TFontName): TcxMRUFontNameAction; virtual;
    function DelMRUFontName(const AFontName: TFontName): TcxMRUFontNameAction; virtual;

    property ItemTypes[Index: Integer]: TcxFontTypes read GetItemTypes;
  public
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;
    function CompareDisplayValues(const AEditValue1, AEditValue2: TcxEditValue): Boolean; override;
    class function GetContainerClass: TcxContainerClass; override;
    procedure GetFontNameComboBoxDisplayValue(const AEditValue: TcxEditValue; out AItemIndex: Integer; out AText: string);
    class function GetViewInfoClass: TcxContainerViewInfoClass; override;
    property LoadFontComplete: Boolean read FLoadFontComplete;
    procedure LoadFontNames; virtual;
    procedure DoUpdate(AProperties: TcxCustomEditProperties); override;

    property FontItems: TStrings read GetFontItems;
    property MRUFontNames: TcxMRUFontNameItems read FMRUFontNames;
    // !!!
    property FontPreview: TcxFontPreview read FFontPreview write SetFontPreview;
    property FontTypes: TcxFontTypes read GetFontTypes write SetFontTypes default [cxftTTF, cxftRaster, cxftDevice, cxftFixed, cxftSymbol];
    property MaxMRUFonts: Byte read FMaxMRUFonts write SetMaxMRUFonts default 10;
    property ShowFontTypeIcon: TcxShowFontIconTypes read FShowFontTypeIcon write SetShowFontTypeIcon default [ftiShowInCombo, ftiShowInList];
    property UseOwnFont: Boolean read GetUseOwnFont write SetUseOwnFont default False;

    property OnAddedMRUFont: TNotifyEvent read FOnAddedMRUFont write FOnAddedMRUFont;
    property OnDeletedMRUFont: TcxDeleteMRUFontEvent read FOnDeletedMRUFont write FOnDeletedMRUFont;
    property OnLoadFontComplete: TNotifyEvent read FOnLoadFontComplete write FOnLoadFontComplete;
    property OnMovedMRUFont: TNotifyEvent read FOnMovedMRUFont write FOnMovedMRUFont;
  end;

  { TcxFontNameComboBoxProperties }

  TcxFontNameComboBoxProperties = class(TcxCustomFontNameComboBoxProperties)
  protected
    // IcxValueByItemIndexProvider
    function FindValueByItemIndex(AItemIndex: Integer; out AValue: Variant): Boolean; override;
    function SupportsItemIndex: Boolean; override;
  published
    property Alignment;
    property AllowDropDownWhenReadOnly;
    property AssignedValues;
    property BeepOnError;
    property ButtonGlyph;
    property CharCase;
    property ClearKey;
    property DropDownAutoWidth;
    property DropDownRows;
    property DropDownSizeable;
    property DropDownWidth;
    property FontPreview;
    property FontTypes;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property ImmediateDropDownWhenActivated;
    property ImmediateDropDownWhenKeyPressed;
    property ImmediatePost;
    property ImmediateUpdateText;
    property IncrementalFiltering;
    property IncrementalFilteringOptions;
    property ItemHeight;
    property MaxMRUFonts;
    property OEMConvert;
    property PopupAlignment;
    property PostPopupValueOnTab;
    property ReadOnly;
    property ShowFontTypeIcon;
    property UseOwnFont;
    property ValidateOnEnter;
    property ValidationErrorIconAlignment;
    property ValidationOptions;
    property OnAddedMRUFont;
    property OnChange;
    property OnCloseUp;
    property OnDeletedMRUFont;
    property OnDrawItem;
    property OnEditValueChanged;
    property OnInitPopup;
    property OnLoadFontComplete;
    property OnMeasureItem;
    property OnMovedMRUFont;
    property OnNewLookupDisplayText;
    property OnPopup;
    property OnValidate;
  end;

  { TcxCustomFontNameComboBoxInnerEdit }

  TcxCustomFontNameComboBoxInnerEdit = class(TcxCustomComboBoxInnerEdit);

  { TcxCustomFontNameComboBox }

  TcxCustomFontNameComboBox = class(TcxCustomComboBox)
  private
    FDontCheckModifiedWhenUpdatingMRUList: Boolean;
    FFontNameQueue: string;
    FNeedsUpdateMRUList: Boolean;

    function GetFontName: string;
    procedure SetFontName(Value: string);
    function GetLookupData: TcxFontNameComboBoxLookupData;
    function GetProperties: TcxCustomFontNameComboBoxProperties;
    function GetActiveProperties: TcxCustomFontNameComboBoxProperties;
    procedure SetProperties(Value: TcxCustomFontNameComboBoxProperties);
    procedure InternalLoadFontCompleteHandler(Sender: TObject);
    procedure UpdateMRUList;
  protected
    procedure AfterPosting; override;
    procedure InternalSetEditValue(const Value: TcxEditValue; AValidateEditValue: Boolean); override;
    function GetInnerEditClass: TControlClass; override;
    function GetPopupWindowClientPreferredSize: TSize; override;
    procedure Initialize; override;
    procedure InitializePopupWindow; override;
    procedure CloseUp(AReason: TcxEditCloseUpReason); override;
    procedure SetItemIndex(Value: Integer); override;
    property LookupData: TcxFontNameComboBoxLookupData read GetLookupData;
  public
    constructor Create(AOwner: TComponent); override;
    function Deactivate: Boolean; override;
    class function GetPropertiesClass: TcxCustomEditPropertiesClass; override;
    function AddMRUFontName(const AFontName: TFontName): TcxMRUFontNameAction;
    function DelMRUFontName(const AFontName: TFontName): TcxMRUFontNameAction;

    property ActiveProperties: TcxCustomFontNameComboBoxProperties read GetActiveProperties;
    property FontName: string read GetFontName write SetFontName;
    property Properties: TcxCustomFontNameComboBoxProperties read GetProperties write SetProperties;
  end;

  { TcxFontNameComboBox }

  TcxFontNameComboBox = class(TcxCustomFontNameComboBox)
  strict private
    function GetActiveProperties: TcxFontNameComboBoxProperties;
    function GetProperties: TcxFontNameComboBoxProperties;
    procedure SetProperties(Value: TcxFontNameComboBoxProperties);
  protected
    // IcxItemIndexHandler
    function SupportsItemIndex: Boolean; override;
  public
    class function GetPropertiesClass: TcxCustomEditPropertiesClass; override;
    property ActiveProperties: TcxFontNameComboBoxProperties read GetActiveProperties;
  published
    property Anchors;
    property AutoSize;
    property BeepOnEnter;
    property BiDiMode;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property Properties: TcxFontNameComboBoxProperties read GetProperties write SetProperties;
    property ShowHint;
    property Style;
    property StyleDisabled;
    property StyleFocused;
    property StyleHot;
    property StyleReadOnly;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEditing;
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

  { TcxFilterFontNameComboBoxHelper }

  TcxFilterFontNameComboBoxHelper = class(TcxFilterComboBoxHelper)
  public
    class function GetFilterEditClass: TcxCustomEditClass; override;
    class function GetSupportedFilterOperators(AProperties: TcxCustomEditProperties;
      AValueTypeClass: TcxValueTypeClass; AExtendedSet: Boolean = False): TcxFilterControlOperators; override;
  end;

var
  FTrueTypeFontGlyph, FNonTrueTypeFontGlyph: TdxSmartGlyph;

procedure GetFontSizes(const AFontName: string; AFontSizes: TStrings);
function GetFontTypes(const AFontName: string): TcxFontTypes;
function RealFontTypeToCxTypes(const AFontType: Integer): TcxFontTypes;
function FontLoader: TcxSystemFontLoader;

implementation

uses
  dxCoreGraphics, dxTypeHelpers, cxListBox, StrUtils, cxLookAndFeelPainters, Math;

const
  dxThisUnitName = 'cxFontNameComboBox';

{$R cxFontNameComboBox.res}
{$R cxFontNameComboBox_svg.res}

const
  DropDownListTextOffset = 2;
  cxFontPreviewPanelDefaultHeight = 38;
  IconBorderWidth = 4;
  IconTextOffset = 2;
  ItemSymbolFontExampleOffset = 4;

var
  FFontSizes: TStrings;
  FFontLoader: TcxSystemFontLoader;
  vbFtt : Boolean;

function FontLoader: TcxSystemFontLoader;
begin
  if FFontLoader = nil then
  begin
    FFontLoader := TcxSystemFontLoader.Create;
    dxTasksDispatcher.Run(FFontLoader, FFontLoader.CompleteHandler, tmcmSync, False);
  end;
  Result := FFontLoader;
end;

function RealFontTypeToCxTypes(const AFontType: Integer): TcxFontTypes;
begin
  Result := [];
  if (AFontType and TRUETYPE_FONTTYPE) <> 0 then
    Result := Result + [cxftTTF];
  if (AFontType and RASTER_FONTTYPE) <> 0 then
    Result := Result + [cxftRaster];
  if (AFontType and DEVICE_FONTTYPE) <> 0 then
    Result := Result + [cxftDevice];
  if (AFontType and FIXEDPITCH_FONTTYPE) <> 0 then
    Result := Result + [cxftFixed];
  if (AFontType and SYMBOL_FONTTYPE) <> 0 then
    Result := Result + [cxftSymbol];
end;

function IsValidFontCondition(AFontTypes: TcxFontTypes; const ALogFont: TLogFont; AFontType: Integer): Boolean; overload;
begin
  Result :=
    ((cxftTTF in AFontTypes) and (AFontType and TRUETYPE_FONTTYPE = TRUETYPE_FONTTYPE)) or
    ((cxftDevice in AFontTypes) and (AFontType and DEVICE_FONTTYPE = DEVICE_FONTTYPE)) or
    ((cxftRaster in AFontTypes) and (AFontType and RASTER_FONTTYPE = RASTER_FONTTYPE)) or
    ((cxftFixed in AFontTypes) and (ALogFont.lfPitchAndFamily and FIXED_PITCH = FIXED_PITCH)) or
    ((cxftSymbol in AFontTypes) and (ALogFont.lfCharSet = SYMBOL_CHARSET));
end;

function EnumFontsProc(var ALogFont: TLogFont; var ATextMetric: TTextMetric;
  AFontType: DWORD; AData: LPARAM): Integer; stdcall;
var
  AFontList: TStringList;
begin
  AFontList := TObject(AData) as TStringList;
  if ALogFont.lfCharSet = SYMBOL_CHARSET then
    AFontType := AFontType or SYMBOL_FONTTYPE;
  if ALogFont.lfPitchAndFamily and FIXED_PITCH = FIXED_PITCH then
    AFontType := AFontType or FIXEDPITCH_FONTTYPE;
  AFontList.AddObject(ALogFont.lfFaceName, TObject(AFontType));
  Result := 0;
end;

procedure EnumFonts(const AFontName: string; AEnumFontsProc: TProcedure; ADataObject: TObject);
var
  ADC: HDC;
  ALogFont: TLogFont;
begin
  ADC := GetDC(0);
  try
    cxInitLogFont(ALogFont, AFontName);
    EnumFontFamiliesEx(ADC, ALogFont, @AEnumFontsProc, TdxNativeInt(ADataObject), 0);
  finally
    ReleaseDC(0, ADC);
  end;
end;

function GetFontTypes(const AFontName: string): TcxFontTypes;
var
  AFontList: TStringList;
begin
  AFontList := TStringList.Create;
  try
    Result := [];
    EnumFonts(AFontName, @EnumFontsProc, AFontList);
    if AFontList.Count > 0 then
      Result := RealFontTypeToCxTypes(Integer(AFontList.Objects[0]));
  finally
    AFontList.Free;
  end;
end;

function SetFontSizes(var ALogFont: TLogFont; var ATextMetric: TTextMetric;
  AFontType: DWORD; AData: LPARAM): Integer; stdcall;
var
  S: string;
begin
  S := IntToStr(((ATextMetric.tmHeight - ATextMetric.tmInternalLeading) * 72 +
    ATextMetric.tmDigitizedAspectX div 2) div ATextMetric.tmDigitizedAspectY);
  if FFontSizes.IndexOf(S) = -1 then
    FFontSizes.Add(S);
  Result := 1;
end;

function SetFTypeFlag(var ALogFont: TLogFont; var ATextMetric: TTextMetric;
  AFontType: DWORD; AData: LPARAM): Integer; stdcall;
begin
  vbFtt := (ATextMetric.tmPitchAndFamily and TMPF_TRUETYPE) = TMPF_TRUETYPE;
  Result := 0;
end;

procedure GetFontSizes(const AFontName: string; AFontSizes: TStrings);

  function IsTrueTypeFont(ADC: HDC; var ALogFont: TLogFont): Boolean;
  begin
    EnumFontFamiliesEx(ADC, ALogFont, @SetFTypeFlag, 0, 0);
    Result := vbFtt;
  end;

var
  ADC: HDC;
  ALogFont: TLogFont;
  I: Integer;
begin
  ADC := GetDC(0);
  try
    cxInitLogFont(ALogFont, AFontName);
    FFontSizes := AFontSizes;
    FFontSizes.Clear;
    if IsTrueTypeFont(ADC, ALogFont) then
    begin
      for I := 0 to dxDefaultFontSizeCount - 1 do
        AFontSizes.Add(IntToStr(dxDefaultFontSizes[I]));
    end
    else
      EnumFontFamiliesEx(ADC, ALogFont, @SetFontSizes, 0, 0);
  finally
    ReleaseDC(0, ADC);
  end;
end;

function GetFontGlyph(AIsTrueType: Boolean; AScaleFactor: TdxScaleFactor): TdxSmartGlyph;
begin
  if AIsTrueType then
    Result := FTrueTypeFontGlyph
  else
    Result := FNonTrueTypeFontGlyph;
end;

function GetFontGlyphSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  Result := dxGetImageSize(FTrueTypeFontGlyph, AScaleFactor);
end;

{ TcxFontLoader }

constructor TcxFontLoader.Create(const AFontTypes: TcxFontTypes);
begin
  FFontTypes := AFontTypes;
  FontList := TStringList.Create;
  inherited Create(True);
  FreeOnTerminate := True;
end;

destructor TcxFontLoader.Destroy;
begin
  Synchronize(DoCompleteEvent);
  FreeAndNil(FontList);
  Synchronize(DoDestroyEvent);
  inherited Destroy;
end;

procedure TcxFontLoader.DoCompleteEvent;
begin
  if Assigned(OnCompleteThread) then
    OnCompleteThread(Self);
end;

procedure TcxFontLoader.DoDestroyEvent;
begin
  if Assigned(OnDestroyThread) then
    OnDestroyThread(Self);
end;

class function TcxFontLoader.EnumFontsProc(var ALogFont: TLogFont; var ATextMetric: TTextMetric; AFontType: DWORD; AData: LPARAM): Integer;
var
  AFaceName: string;
  AFontLoader: TcxFontLoader;
begin
  AFontLoader := TObject(AData) as TcxFontLoader;
  AFaceName := ALogFont.lfFaceName;
  if (AFaceName <> '') and (AFaceName[1] <> '@') and 
    (AFontLoader.FontList.IndexOf(AFaceName) = -1) and
    IsValidFontCondition(AFontLoader.FFontTypes, ALogFont, AFontType) then
  begin
    if ALogFont.lfCharSet = SYMBOL_CHARSET then
      AFontType := AFontType or SYMBOL_FONTTYPE;
    if ALogFont.lfPitchAndFamily and FIXED_PITCH = FIXED_PITCH then
      AFontType := AFontType or FIXEDPITCH_FONTTYPE;
    AFontLoader.FontList.AddObject(AFaceName, TObject(AFontType));
  end;
  if AFontLoader.Terminated then
    Result := 0
  else
    Result := 1;
end;

procedure TcxFontLoader.Execute;
begin
  inherited;
  FontList.BeginUpdate;
  try
    FontList.Clear;
    EnumFonts('', @EnumFontsProc, Self);
    TStringList(FontList).Sort;
  finally
    FontList.EndUpdate;
  end;
end;

{ TcxSystemFontLoader.TFontLoaderListener }

class function TcxSystemFontLoader.TFontLoaderListener.Create(AFreeNotificatior: TComponent; ACompleteHandler: TNotifyEvent; AItems: TStrings;
  AFontTypes: TcxFontTypes): TFontLoaderListener;
begin
  Result.FreeNotificatior := AFreeNotificatior;
  Result.CompleteHandler := ACompleteHandler;
  Result.Items := AItems;
  Result.FontTypes := AFontTypes;
end;

{ TcxSystemFontLoader }

constructor TcxSystemFontLoader.Create;
begin
  inherited;
  FFontList := TStringList.Create;
  FListeners := TList<TFontLoaderListener>.Create;
  FFreeNotificator := TcxFreeNotificator.Create(nil);
  FFreeNotificator.OnFreeNotification := DoFreeNotification;
end;

destructor TcxSystemFontLoader.Destroy;
begin
  FreeAndNil(FFreeNotificator);
  FreeAndNil(FFontList);
  FreeAndNil(FListeners);
  inherited;
end;

procedure TcxSystemFontLoader.Execute;
begin
  inherited;
  FontList.BeginUpdate;
  try
    FontList.Clear;
    EnumFonts('', @EnumFontsProc, Self);
    TStringList(FontList).Sort;
  finally
    FontList.EndUpdate;
  end;
end;

procedure TcxSystemFontLoader.PopulateFonts(AFreeNotificatior: TComponent; ACompleteHandler: TNotifyEvent; AItems: TStrings; AFontTypes: TcxFontTypes);
begin
  if Finished then
    InternalPopulateFonts(TFontLoaderListener.Create(AFreeNotificatior, ACompleteHandler, AItems, AFontTypes))
  else
  begin
    FFreeNotificator.AddSender(AFreeNotificatior);
    DeleteListener(AFreeNotificatior);
    FListeners.Add(TFontLoaderListener.Create(AFreeNotificatior, ACompleteHandler, AItems, AFontTypes));
  end;
end;

procedure TcxSystemFontLoader.Complete;
begin
  FFinished := True;
  inherited Complete;
end;

procedure TcxSystemFontLoader.DoFreeNotification(Sender: TComponent);
begin
  DeleteListener(Sender);
end;

procedure TcxSystemFontLoader.InternalPopulateFonts(AListener: TFontLoaderListener);

  function IsFontMatch(AFontTypes: TcxFontTypes; AFontType: Integer): Boolean; overload;
  begin
    Result :=
      ((cxftTTF in AFontTypes) and (AFontType and TRUETYPE_FONTTYPE = TRUETYPE_FONTTYPE)) or
      ((cxftDevice in AFontTypes) and (AFontType and DEVICE_FONTTYPE = DEVICE_FONTTYPE)) or
      ((cxftRaster in AFontTypes) and (AFontType and RASTER_FONTTYPE = RASTER_FONTTYPE)) or
      ((cxftFixed in AFontTypes) and (AFontType and FIXEDPITCH_FONTTYPE = FIXEDPITCH_FONTTYPE)) or
      ((cxftSymbol in AFontTypes) and (AFontType and SYMBOL_FONTTYPE = SYMBOL_FONTTYPE));
  end;

var
  I: Integer;
begin
  AListener.Items.BeginUpdate;
  try
    AListener.Items.Clear;
    for I := 0 to FontList.Count - 1 do
    begin
      if IsFontMatch(AListener.FontTypes, DWORD(FontList.Objects[I])) then
        AListener.Items.AddObject(FontList[I], FontList.Objects[I]);
    end;
  finally
    AListener.Items.EndUpdate;
  end;
  dxCallNotify(AListener.CompleteHandler, Self);
end;

procedure TcxSystemFontLoader.CompleteHandler;
var
  I: Integer;
begin
  for I := 0 to FListeners.Count - 1 do
    InternalPopulateFonts(FListeners[I]);
  FreeAndNil(FFreeNotificator);
  FreeAndNil(FListeners);
end;

procedure TcxSystemFontLoader.DeleteListener(AFreeNotificatior: TComponent);
var
  I: Integer;
begin
  for I := 0 to FListeners.Count - 1 do
    if FListeners[I].FreeNotificatior = AFreeNotificatior then
    begin
      FListeners.Delete(I);
      Break;
    end;
end;

class function TcxSystemFontLoader.EnumFontsProc(var ALogFont: TLogFont; var ATextMetric: TTextMetric; AFontType: DWORD; AData: LPARAM): Integer;
var
  AFaceName: string;
  AFontLoader: TcxSystemFontLoader;
begin
  AFontLoader := TObject(AData) as TcxSystemFontLoader;
  AFaceName := ALogFont.lfFaceName;

  if (AFaceName <> '') and (AFaceName[1] <> '@') and 
    IsValidFontCondition([cxftTTF..cxftSymbol], ALogFont, AFontType) and
    ((AFontLoader.FontList.Count = 0) or (AnsiCompareText(AFontLoader.FontList[AFontLoader.FontList.Count - 1], AFaceName) <> 0)) then
  begin
    if ALogFont.lfCharSet = SYMBOL_CHARSET then
      AFontType := AFontType or SYMBOL_FONTTYPE;
    if ALogFont.lfPitchAndFamily and FIXED_PITCH = FIXED_PITCH then
      AFontType := AFontType or FIXEDPITCH_FONTTYPE;
    AFontLoader.FontList.AddObject(AFaceName, TObject(AFontType));
  end;
  if AFontLoader.Canceled then
    Result := 0
  else
    Result := 1;
end;

{ TcxFontPreview }

constructor TcxFontPreview.Create(AOwner: TPersistent);
begin
  inherited Create;
  FOwner := AOwner;
  FUpdateCount := 0;
  FModified := False;
  FFontStyle := [];
  FVisible := True;
  FPreviewType := cxfpFontName;
  FPreviewText := '';
  FAlignment := taCenter;
  FShowEndEllipsis := True;
  FColor := clWindow;
  FWordWrap := False;
  FShowButtons := True;
end;

destructor TcxFontPreview.Destroy;
begin
  FIsDestroying := True;
  inherited Destroy;
end;

procedure TcxFontPreview.Assign(Source: TPersistent);
begin
  if Source is TcxFontPreview then
  begin
    BeginUpdate;
    try
      with Source as TcxFontPreview do
      begin
        Self.Visible := Visible;
        Self.FontStyle := FontStyle;
        Self.PreviewType := PreviewType;
        Self.PreviewText := PreviewText;
        Self.Alignment := Alignment;
        Self.ShowEndEllipsis := ShowEndEllipsis;
        Self.Color := Color;
        Self.WordWrap := WordWrap;
        Self.ShowButtons := ShowButtons;
        Self.OnButtonClick := OnButtonClick;
      end;
    finally
      EndUpdate;
    end
  end
  else
    inherited Assign(Source);
end;

function TcxFontPreview.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TcxFontPreview.Changed;
begin
  if FUpdateCount = 0 then
  begin
    if Assigned(FOnChanged) and not IsDestroying then
      FOnChanged(Self);
    FModified := False;
  end
  else
    FModified := True;
end;

procedure TcxFontPreview.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TcxFontPreview.EndUpdate;
begin
  if FUpdateCount <> 0 then
  begin
    Dec(FUpdateCount);
    if FModified then
      Changed;
  end;
end;

function TcxFontPreview.IsDestroying: Boolean;
begin
  Result := FIsDestroying;
end;

procedure TcxFontPreview.SetFontStyle(Value: TFontStyles);
begin
  if FFontStyle <> Value then
  begin
    FFontStyle := Value;
    Changed;
  end;
end;

procedure TcxFontPreview.SetVisible(Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Changed;
  end;
end;

procedure TcxFontPreview.SetPreviewType(Value: TcxFontPreviewType);
begin
  if FPreviewType <> Value then
  begin
    FPreviewType := Value;
    Changed;
  end;
end;

procedure TcxFontPreview.SetPreviewText(Value: TCaption);
begin
  if FPreviewText <> Value then
  begin
    FPreviewText := Value;
    Changed;
  end;
end;

procedure TcxFontPreview.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    Changed;
  end;
end;

procedure TcxFontPreview.SetShowEndEllipsis(Value: Boolean);
begin
  if FShowEndEllipsis <> Value then
  begin
    FShowEndEllipsis := Value;
    Changed;
  end;
end;

procedure TcxFontPreview.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    Changed;
  end;
end;

procedure TcxFontPreview.SetWordWrap(Value: Boolean);
begin
  if FWordWrap <> Value then
  begin
    FWordWrap := Value;
    Changed;
  end;
end;

procedure TcxFontPreview.SetShowButtons(Value: Boolean);
begin
  if FShowButtons <> Value then
  begin
    FShowButtons := Value;
    Changed;
  end;
end;

{ TFontPreviewPanel }

constructor TFontPreviewPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csAcceptsControls, csCaptureMouse, csClickEvents,
    csSetCaption, csOpaque, csDoubleClicks, csReplicatable];
  Width := 100;
  Height := 40;
  FAlignment := taCenter;
  FShowEndEllipsis := True;
  FShowButtons := True;
  FEdges := [bLeft, bTop, bRight, bBottom];
  FBorderColor := clWindowFrame;
  FFontColor := clWindowText;
  FWordWrap := False;
  FFontStyle := [];
  Color := clWindow;
  UseDockManager := True;
  FcxCanvas := TcxCanvas.Create(Canvas);
  FLookAndFeel := TcxLookAndFeel.Create(Self);
  CreateButtons;
end;

destructor TFontPreviewPanel.Destroy;
var
  I: TFontStyle;
begin
  for I := Low(TFontStyle) to High(TFontStyle) do
    FreeAndNil(FButtons[I]);
  FreeAndNil(FLookAndFeel);
  FreeAndNil(FcxCanvas);
  inherited;
end;

procedure TFontPreviewPanel.CreateButtons;

  procedure InitButton(AButton: TcxButton; const AButtonSize: TSize);
  begin
    AButton.Font.Name := 'Arial';
    AButton.Font.Size := 8;
    AButton.Height := AButtonSize.cx;
    AButton.LookAndFeel.MasterLookAndFeel := LookAndFeel;
    AButton.UseSystemPaint := True;
    AButton.Width := AButtonSize.cy;
    AButton.CanBeFocused := False;
    AButton.Parent := Self;
    AButton.OnClick := FontButtonsClickHandler;
  end;

const
  SButtonCaption: array [TFontStyle] of string = ('B', 'I', 'U', 'S');

var
  AButtonSize: TSize;
  I: TFontStyle;
  AFont: TFont;
begin
  AFont := TFont.Create;
  try
    AFont.Name := 'Arial';
    AFont.Size := 8;
    AButtonSize.cx := cxTextWidth(AFont, 'B') + 8;
    AButtonSize.cy := TdxTextMeasurer.TextLineHeight(AFont) + 2;
  finally
    AFont.Free;
  end;
  for I := Low(TFontStyle) to High(TFontStyle) do
  begin
    FButtons[I] := TcxButton.Create(Self);
    FButtons[I].Caption := SButtonCaption[I];
    FButtons[I].Tag := Ord(I);
    InitButton(FButtons[I], AButtonSize);
  end;
end;

procedure TFontPreviewPanel.RealignButtons;
var
  R: TRect;
  I: TFontStyle;
  ALeft, ATop: Integer;
begin
  for I := Low(TFontStyle) to High(TFontStyle) do
    FButtons[I].Visible := ShowButtons;
  if ShowButtons then
  begin
    ATop := Height - FButtons[Low(TFontStyle)].Height - 2;
    ALeft := Width;

    for I := High(TFontStyle) downto Low(TFontStyle) do
    begin
      ALeft := ALeft - FButtons[I].Width - 1;
      R := TRect.CreateSize(ALeft, ATop, FButtons[I].Width, FButtons[I].Height);
      if UseRightToLeftAlignment then
        FButtons[I].BoundsRect := TdxRightToLeftLayoutConverter.ConvertRect(R, ClientRect)
      else
        FButtons[I].BoundsRect := R;
    end;
  end;
end;

procedure TFontPreviewPanel.SetFontStyleButtonsState;
var
  I: TFontStyle;
begin
  for I := Low(TFontStyle) to High(TFontStyle) do
    if I in FFontStyle then
    begin
      FButtons[I].Colors.Normal := GetLightSelColor;
      FButtons[I].Font.Style := [fsBold];
    end
    else
    begin
      FButtons[I].Colors.Normal := clDefault;
      FButtons[I].Font.Style := [];
    end;
end;

procedure TFontPreviewPanel.Paint;
var
  ARect: TRect;
begin
  ARect := GetClientRect;

  cxCanvas.FillRect(ARect, Color);
  cxCanvas.DrawComplexFrame(ARect, BorderColor, BorderColor, FEdges);

  ARect := cxRectInflate(ARect, -2);
  cxCanvas.Brush.Style := bsClear;
  CalculateFont(ARect);
  cxDrawText(cxCanvas.Handle, Caption, ARect, GetTextFlag(DT_NOPREFIX));
end;

procedure TFontPreviewPanel.CalculateFont(const ARect: TRect);
var
  ACalculator: TdxAdjustFontSizeHelper;
begin
  Canvas.Font.Style := CalculateFontStyle;
  Canvas.Font.Name := IfThen(FontName <> '', FontName, 'Arial');
  Canvas.Font.Color := FontColor;
  Canvas.Font.Size := 8;

  if Trim(Caption) <> '' then
  begin
    ACalculator := TdxAdjustFontSizeHelper.Create;
    try
      ACalculator.Font := Canvas.Font;
      ACalculator.Calculate(cxSize(ARect), Caption, False, GetTextFlag(DT_NOPREFIX), MaxByte);
      Canvas.Font.Size := ACalculator.Font.Size;
    finally
      ACalculator.Free;
    end;
  end;
end;

function TFontPreviewPanel.GetTextFlag(const AStartFlag: Longint): Longint;
const
  ShowEndEllipsisArray: array[Boolean] of Integer = (0, DT_END_ELLIPSIS);
  WordWrapArray: array[Boolean] of Integer = (0, DT_WORDBREAK);
begin
  Result := AStartFlag or SystemAlignmentsHorz[Alignment] or DT_VCENTER or
    ShowEndEllipsisArray[ShowEndEllipsis] or WordWrapArray[WordWrap] or
    DrawTextBiDiModeFlagsReadingOnly;
end;

function TFontPreviewPanel.CalculateFontStyle: TFontStyles;
begin
  Result := FFontStyle;
end;

procedure TFontPreviewPanel.FontButtonsClickHandler(Sender: TObject);
var
  AFontStyle: TFontStyle;
begin
  AFontStyle := TFontStyle(TComponent(Sender).Tag);
  if AFontStyle in FFontStyle then
    Exclude(FFontStyle, AFontStyle)
  else
    Include(FFontStyle, AFontStyle);

  FontPreview.FontStyle := FFontStyle;
  if Assigned(FontPreview.OnButtonClick) then
    FontPreview.OnButtonClick(Self, TcxFontButtonType((Sender as TComponent).Tag));

  if TcxButton(Sender).Colors.Normal <> clDefault then
  begin
    TcxButton(Sender).Colors.Normal := clDefault;
    TcxButton(Sender).Font.Style := [];
  end else
  begin
    TcxButton(Sender).Colors.Normal := GetLightSelColor;
    TcxButton(Sender).Font.Style := [fsBold];
  end;

  Invalidate;
end;

procedure TFontPreviewPanel.SetLocked(Value: Boolean);
begin
  FLocked := Value;
  if not FLocked then
    Invalidate;
end;

procedure TFontPreviewPanel.SetAlignment(Value: TAlignment);
begin
  FAlignment := Value;
  if not FLocked then
    Invalidate;
end;

procedure TFontPreviewPanel.SetShowEndEllipsis(Value: Boolean);
begin
  FShowEndEllipsis := Value;
  if not FLocked then
    Invalidate;
end;

procedure TFontPreviewPanel.SetEdges(Value: TcxBorders);
begin
  FEdges := Value;
  if not FLocked then
    Invalidate;
end;

procedure TFontPreviewPanel.SetFontName(Value: string);
begin
  FFontName := Value;
  if not FLocked then
    Invalidate;
end;

procedure TFontPreviewPanel.SetFontStyle(Value: TFontStyles);
begin
  FFontStyle := Value;
  SetFontStyleButtonsState;
end;

procedure TFontPreviewPanel.SetWordWrap(Value: Boolean);
begin
  FWordWrap := Value;
  if not FLocked then
    Invalidate;
end;

procedure TFontPreviewPanel.SetShowButtons(Value: Boolean);
begin
  if FShowButtons <> Value then
  begin
    FShowButtons := Value;
    RealignButtons;
  end;
end;

procedure TFontPreviewPanel.SetLookAndFeel(Value: TcxLookAndFeel);
begin
  FLookAndFeel.Assign(Value);
  RealignButtons;
end;

{ TcxMRUFontNameItem }

procedure TcxMRUFontNameItem.Assign(Source: TPersistent);
begin
  if Source is TcxMRUFontNameItem then
  begin
    FontName := TcxMRUFontNameItem(Source).FontName;
    Tag := TcxMRUFontNameItem(Source).Tag;
  end
  else
    inherited Assign(Source);
end;

function TcxMRUFontNameItem.IsTagStored: Boolean;
begin
  Result := FTag <> 0;
end;

procedure TcxMRUFontNameItem.SetFontName(const Value: TFontName);
begin
  if FFontName <> Value then
  begin
    FFontName := Value;
    Changed(True);
  end;
end;

{ TcxMRUFontNameItems }

constructor TcxMRUFontNameItems.Create(AOwner: TPersistent; ItemClass: TCollectionItemClass);
begin
  inherited Create(AOwner, ItemClass);
end;

destructor TcxMRUFontNameItems.Destroy;
begin
  inherited Destroy;
end;

function TcxMRUFontNameItems.GetItems(Index: Integer): TcxMRUFontNameItem;
begin
  Result := TcxMRUFontNameItem(inherited Items[Index]);
end;

procedure TcxMRUFontNameItems.SetItems(Index: Integer; const Value: TcxMRUFontNameItem);
begin
  inherited Items[Index] := Value;
end;

procedure TcxMRUFontNameItems.Update(Item: TCollectionItem);
begin
  TcxCustomFontNameComboBoxProperties(Owner).Changed;
end;

function TcxMRUFontNameItems.Add: TcxMRUFontNameItem;
begin
  Result := TcxMRUFontNameItem(inherited Add);
end;

function TcxMRUFontNameItems.Insert(Index: Integer): TcxMRUFontNameItem;
begin
  Result := TcxMRUFontNameItem(inherited Insert(Index));
end;

procedure TcxMRUFontNameItems.Move(ACurIndex, ANewIndex: Integer);
var
  ANewFontNameItem, AOldFontNameItem: TcxMRUFontNameItem;
begin
  if ACurIndex = ANewIndex then
    Exit;
  AOldFontNameItem := Items[ACurIndex];
  ANewFontNameItem := Insert(ANewIndex);
  ANewFontNameItem.Assign(AOldFontNameItem);
  AOldFontNameItem.Free;
end;

function TcxMRUFontNameItems.AddMRUFontName(const AFontName: TFontName): TcxMRUFontNameItem;
begin
  Result := nil;
  if (AFontName = '') or (FindFontName(AFontName) <> nil) then
    Exit;
  Result := Add;
  Result.FontName := AFontName;
end;

function TcxMRUFontNameItems.InsertMRUFontName(AIndex: Integer; const AFontName: TFontName): TcxMRUFontNameItem;
begin
  Result := nil;
  if (AFontName = '') or (FindFontName(AFontName) <> nil) then
    Exit;
  Result := Insert(AIndex);
  Result.FontName := AFontName;
end;

function TcxMRUFontNameItems.FindFontName(const AFontName: TFontName): TcxMRUFontNameItem;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
  begin
    if Items[I].FontName = AFontName then
    begin
      Result := Items[I];
      Break;
    end;
  end;
end;

{ TcxCustomFontNameComboBoxViewInfo }

procedure TcxCustomFontNameComboBoxViewInfo.Paint(ACanvas: TcxCanvas);
begin
  inherited Paint(ACanvas);

  if (FCurrentIndex <> -1) and (ftiShowInCombo in ShowFontTypeIcon) then
  begin
    TdxImageDrawer.DrawImage(ACanvas, ImageRect, GetFontGlyph(IsTrueTypeFont, ScaleFactor), nil, -1, ifmNormal, idmNormal, True, Painter.DefaultContentGlyphColorPalette(cxbsNormal), ScaleFactor);
  end;
end;

procedure TcxCustomFontNameComboBoxViewInfo.Offset(DX, DY: Integer);
begin
  inherited;
  OffsetRect(ImageRect, DX, DY);
end;

{ TcxCustomFontNameComboBoxViewData }

procedure TcxCustomFontNameComboBoxViewData.Calculate(ACanvas: TcxCanvas;
  const ABounds: TRect; const P: TPoint; Button: TcxMouseButton;
  Shift: TShiftState; AViewInfo: TcxCustomEditViewInfo; AIsMouseEvent: Boolean);

  function GetIconOffset(AClientRect: TRect): TPoint;
  begin
    Result.Y := (cxRectHeight(AClientRect) - GetFontGlyphSize(ScaleFactor).cy) div 2;
    if IsInplace then
      Result.X := IconBorderWidth - cxInplaceEditOffset
    else
      Result.X := IconBorderWidth;
  end;

  procedure CalculateImageRect(AViewInfo: TcxCustomFontNameComboBoxViewInfo);
  begin
    AViewInfo.ImageRect := cxRectSetSize(AViewInfo.ClientRect, GetFontGlyphSize(ScaleFactor));
    cxOffsetRect(AViewInfo.ImageRect, GetIconOffset(AViewInfo.ClientRect));
  end;

var
  AEditViewInfo: TcxCustomFontNameComboBoxViewInfo;
begin
  inherited Calculate(ACanvas, ABounds, P, Button, Shift, AViewInfo, AIsMouseEvent);
  if (ABounds.Right = cxMaxRectSize) or (ABounds.Bottom = cxMaxRectSize) or IsRectEmpty(ABounds) then
    Exit;

  AEditViewInfo := TcxCustomFontNameComboBoxViewInfo(AViewInfo);
  AEditViewInfo.ShowFontTypeIcon := Properties.ShowFontTypeIcon;

  AEditViewInfo.TextRect.Left := IconBorderWidth + ScaleFactor.Apply(IconTextOffset);
  if (ftiShowInCombo in AEditViewInfo.ShowFontTypeIcon) then
  begin
    CalculateImageRect(AEditViewInfo);
    AEditViewInfo.TextRect.Left := AEditViewInfo.ImageRect.Right + AEditViewInfo.TextRect.Left;
    if UseRightToLeftAlignment then
    begin
      AEditViewInfo.ImageRect := TdxRightToLeftLayoutConverter.ConvertRect(AEditViewInfo.ImageRect, AViewInfo.ClientRect);
      AEditViewInfo.TextRect := TdxRightToLeftLayoutConverter.ConvertRect(AEditViewInfo.TextRect, AViewInfo.ClientRect);
    end;
  end;

  if not IsInplace then
    AEditViewInfo.DrawSelectionBar := False;
end;

procedure TcxCustomFontNameComboBoxViewData.DisplayValueToDrawValue(
  const ADisplayValue: TcxEditValue; AViewInfo: TcxCustomEditViewInfo);
var
  AViewInfoAccess: TcxCustomFontNameComboBoxViewInfo;
begin
  AViewInfoAccess := TcxCustomFontNameComboBoxViewInfo(AViewInfo);
  Properties.GetFontNameComboBoxDisplayValue(ADisplayValue,
    AViewInfoAccess.FCurrentIndex, AViewInfoAccess.Text);
  if PreviewMode then
    AViewInfoAccess.Text := '';
  if AViewInfoAccess.FCurrentIndex <> -1 then
    AViewInfoAccess.IsTrueTypeFont := cxftTTF in Properties.ItemTypes[AViewInfoAccess.FCurrentIndex];
end;

procedure TcxCustomFontNameComboBoxViewData.EditValueToDrawValue(
  const AEditValue: TcxEditValue; AViewInfo: TcxCustomEditViewInfo);
begin
  PrepareSelection(AViewInfo);
  DisplayValueToDrawValue(AEditValue, AViewInfo);
  DoOnGetDisplayText(TcxCustomTextEditViewInfo(AViewInfo).Text);
end;

function TcxCustomFontNameComboBoxViewData.GetEditContentSize(ACanvas: TcxCanvas; const AEditValue: TcxEditValue;
  const AEditSizeProperties: TcxEditSizeProperties; AErrorData: TcxEditValidateInfo): TSize;
var
  FItemIndex: Integer;
begin
  Result := inherited GetEditContentSize(ACanvas, AEditValue, AEditSizeProperties);
  FItemIndex := Properties.FindItemByValue(AEditValue);
  if (FItemIndex >= 0) and (ftiShowInCombo in Properties.ShowFontTypeIcon) then
    Inc(Result.cx, GetFontGlyphSize(ScaleFactor).cx + 4);
end;

function TcxCustomFontNameComboBoxViewData.IsComboBoxStyle: Boolean;
begin
  Result := True;
end;

function TcxCustomFontNameComboBoxViewData.GetProperties: TcxCustomFontNameComboBoxProperties;
begin
  Result := TcxCustomFontNameComboBoxProperties(FProperties);
end;

{ TcxFontNameComboBoxListBox }

function TcxFontNameComboBoxListBox.GetItemHeight(AIndex: Integer = -1): Integer;
var
  AMinItemHeight: Integer;
begin
  if ActiveProperties.ItemHeight > 0 then
    Result := ActiveProperties.ItemHeight
  else
  begin
    Result := inherited GetItemHeight;
    if ActiveProperties.UseOwnFont then
      Inc(Result, 4)
    else
    begin
      AMinItemHeight := GetFontGlyphSize(ScaleFactor).cy;
      if Result <= AMinItemHeight then
        Result := AMinItemHeight + 4;
    end;
  end;
  if (AIndex >= 0) and Edit.IsOnMeasureItemEventAssigned then
    Edit.DoOnMeasureItem(AIndex, Canvas, Result);
  if AIndex = (ActiveProperties.FMRUFontNames.Count - 1) then
    Inc(Result, MRUDelimiterWidth);
end;

function TcxFontNameComboBoxListBox.GetItemWidth(AIndex: Integer): Integer;
var
  AFontName, ACanvasFontName: string;
  ACanvasFontCharSet: TFontCharSet;
begin
  if ActiveProperties.UseOwnFont then
  begin
    Canvas.Font.Assign(Font);
    ACanvasFontName := Canvas.Font.Name;
    ACanvasFontCharSet := Canvas.Font.Charset;
    try
      Result := 0;
      AFontName := GetItem(AIndex);
      if IsSymbolFontType(AIndex) then
      begin
        Canvas.Font.Name := 'Arial';
        Result := Canvas.TextWidth(AFontName);
        Inc(Result, ItemSymbolFontExampleOffset);
        Canvas.Font.Charset := SYMBOL_CHARSET;
      end;
      Canvas.Font.Name := AFontName;
      Inc(Result, Canvas.TextWidth(AFontName));
    finally
      Canvas.Font.Name := ACanvasFontName;
      Canvas.Font.Charset := ACanvasFontCharSet;
    end;
  end
  else
    Result := inherited GetItemWidth(AIndex);
end;

function TcxFontNameComboBoxListBox.GetRealStyle: TListBoxStyle;
begin
  Result := TListBoxStyle.lbOwnerDrawVariable;
end;

function TcxFontNameComboBoxListBox.IsBufferedItemPaint: Boolean;
begin
  Result := True;
end;

procedure TcxFontNameComboBoxListBox.DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  AItemRect: TRect;
begin
  AItemRect := Rect;
  if Index = ActiveProperties.FMRUFontNames.Count - 1 then
  begin
    Dec(AItemRect.Bottom, MRUDelimiterWidth);
    DrawMRUDelimiter(Canvas.Canvas, Rect, False); 
  end;
  inherited DrawItem(Index, AItemRect, State);
end;

procedure TcxFontNameComboBoxListBox.DrawItemContent(AIndex: Integer; ARect: TRect; AState: TOwnerDrawState);

  procedure DoDrawImage(var ATextRect: TRect);
  var
    AGlyph: TdxSmartGlyph;
    AGlyphRect: TRect;
    AGlyphSize: TSize;
  begin
    AGlyph := GetFontGlyph(cxftTTF in ActiveProperties.ItemTypes[
      Edit.LookupData.GetLookupItemIndexFromFilteredItemIndex(AIndex)], ScaleFactor); 
    if (ftiShowInList in ActiveProperties.ShowFontTypeIcon) and (AGlyph <> nil) then
    begin
      Inc(ATextRect.Left, FGlyphLeftIndent);
      AGlyphSize := GetFontGlyphSize(ActiveProperties.ScaleFactor);
      AGlyphRect := cxRectCenterVertically(cxRectSetWidth(ATextRect, AGlyphSize.cx), AGlyphSize.cy);
      ATextRect.Left := AGlyphRect.Right + FGlyphLeftIndent + FGlyphRightIndent;
      if UseRightToLeftAlignment then
      begin
        AGlyphRect := TdxRightToLeftLayoutConverter.ConvertRect(AGlyphRect, ARect);
        ATextRect := TdxRightToLeftLayoutConverter.ConvertRect(ATextRect, ARect);
      end;
      TdxImageDrawer.DrawImage(Canvas, AGlyphRect, AGlyph, nil, -1, ifmProportionalStretch, idmNormal, True, Painter.DefaultContentGlyphColorPalette(cxbsNormal), ScaleFactor); 
    end
    else
      Inc(ATextRect.Left, FTextIndent);
  end;

var
  AFlags: Cardinal;
  AText: string;
  ATextRect: TRect;
begin
  ATextRect := ARect;

  DoDrawImage(ATextRect);

  AText := GetItem(AIndex);
  if ActiveProperties.UseOwnFont then
    Canvas.Font.Name := AText;
  AFlags := GetDrawTextFlags;
  Canvas.Brush.Style := bsClear;

  if ActiveProperties.UseOwnFont and IsSymbolFontType(AIndex) then
  begin
    Canvas.Font.Name := 'Arial';
    if IsHighlightSearchText then
      DrawItemText(AText, ATextRect, AState)
    else
      DrawText(Canvas.Handle, PChar(AText), Length(AText), ATextRect, AFlags);

    Inc(ATextRect.Left, Canvas.TextWidth(AText) + ItemSymbolFontExampleOffset);
    Canvas.Font.Name := AText;
    Canvas.Font.Charset := SYMBOL_CHARSET;
    AFlags := AFlags and not DT_END_ELLIPSIS;
  end;

  if IsHighlightSearchText and not (ActiveProperties.UseOwnFont and IsSymbolFontType(AIndex)) then
    DrawItemText(AText, ATextRect, AState)
  else
    DrawText(Canvas.Handle, PChar(AText), Length(AText), ATextRect, AFlags);

  Canvas.Brush.Style := bsSolid;
end;

function TcxFontNameComboBoxListBox.GetDefaultItemPadding: TdxPadding;
begin
  if SupportsListBoxSkinPadding then
    Result := inherited GetDefaultItemPadding
  else
    Result := TdxPadding.Null;
end;

procedure TcxFontNameComboBoxListBox.CalculatePadding;
begin
  inherited CalculatePadding;
  if SupportsListBoxSkinPadding then
  begin
    FItemPadding.Left := Painter.GetEditorGlyphIndent(True, False, ScaleFactor);
    FGlyphLeftIndent := 0;
    FGlyphRightIndent := Painter.GetEditorGlyphIndent(False, False, ScaleFactor);
    FTextIndent := FGlyphLeftIndent;
  end
  else
  begin
    FTextIndent := ScaleFactor.Apply(DropDownListTextOffset);
    FGlyphLeftIndent := ScaleFactor.Apply(IconBorderWidth);
    FGlyphRightIndent := ScaleFactor.Apply(IconTextOffset);
  end;
end;

procedure TcxFontNameComboBoxListBox.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  AItemIndex: Integer;
begin
  Edit.BeginUserAction;
  try
    inherited MouseUp(Button, Shift, X, Y);
    if Button <> mbLeft then
      Exit;
    AItemIndex := ItemAtPos(Point(X, Y), True);
    if AItemIndex <> -1 then
    begin
      SetCaptureControl(nil);
      ItemIndex := AItemIndex;
      Edit.CloseUp(crEnter);
    end;
  finally
    Edit.EndUserAction;
  end;
end;



function TcxFontNameComboBoxListBox.GetActiveProperties: TcxCustomFontNameComboBoxProperties;
begin
  Result := Edit.ActiveProperties;
end;

function TcxFontNameComboBoxListBox.GetEdit: TcxCustomFontNameComboBox;
begin
  Result := inherited Edit as TcxCustomFontNameComboBox;
end;

function TcxFontNameComboBoxListBox.GetScaleFactor: TdxScaleFactor;
begin
  Result := Edit.ScaleFactor;
end;

function TcxFontNameComboBoxListBox.IsSymbolFontType(AItemIndex: Integer): Boolean;
begin
  Result := Integer(ActiveProperties.Items.Objects[
    Edit.LookupData.GetLookupItemIndexFromFilteredItemIndex(AItemIndex)]) and SYMBOL_FONTTYPE <> 0;
end;

{ TcxFontNameComboBoxLookupData }

destructor TcxFontNameComboBoxLookupData.Destroy;
begin
  FPanel := nil;
  inherited Destroy;
end;

function TcxFontNameComboBoxLookupData.CanResizeVisualArea(var NewSize: TSize; AMaxHeight, AMaxWidth: Integer): Boolean;
var
  AFontPreviewPanelHeight: Integer;
begin
  if ActiveProperties.FontPreview.Visible then
    AFontPreviewPanelHeight := ActiveProperties.ScaleFactor.Apply(cxFontPreviewPanelDefaultHeight)
  else
    AFontPreviewPanelHeight := 0;

  Result := (AMaxHeight = 0) or (AMaxHeight > AFontPreviewPanelHeight);
  if Result then
  begin
    if AMaxHeight > 0 then
      Dec(AMaxHeight, AFontPreviewPanelHeight);
    NewSize.cy := NewSize.cy - AFontPreviewPanelHeight;
    Result := inherited CanResizeVisualArea(NewSize, AMaxHeight);
    NewSize.cy := NewSize.cy + AFontPreviewPanelHeight;
  end;
end;

function TcxFontNameComboBoxLookupData.GetVisualAreaPreferredSize(AMaxHeight: Integer; AWidth: Integer = 0): TSize;
var
  AScrollWidth, AWidthDelta: Integer;
begin
  Result := inherited GetVisualAreaPreferredSize(AMaxHeight, AWidth);
  if ActiveProperties.FontPreview.Visible then
    Inc(Result.cy, ScaleFactor.Apply(cxFontPreviewPanelDefaultHeight));
  if ftiShowInCombo in ActiveProperties.ShowFontTypeIcon then
    AWidthDelta := GetFontGlyphSize(ScaleFactor).cx + IconBorderWidth * 2 + ScaleFactor.Apply(IconTextOffset)
  else
    AWidthDelta := ScaleFactor.Apply(DropDownListTextOffset);

  AScrollWidth := List.ScrollWidth;
  List.ScrollWidth := 0;
  List.ScrollWidth := AScrollWidth + AWidthDelta;
  Inc(Result.cx, AWidthDelta);
end;

procedure TcxFontNameComboBoxLookupData.DoInitialize(AVisualControlsParent: TWinControl);
var
  AProperties: TcxCustomFontNameComboBoxProperties;
  AAlignment: TAlignment;
begin
  inherited DoInitialize(AVisualControlsParent);

  AProperties := ActiveProperties;
  if AProperties.FontPreview.Visible and Assigned(AVisualControlsParent) and AVisualControlsParent.HandleAllocated then
  begin
    if not Assigned(FPanel) then
    begin
      FPanel := TFontPreviewPanel.Create(AVisualControlsParent);
      FPanel.FontPreview := AProperties.FontPreview;
      FPanel.LookAndFeel.MasterLookAndFeel := (Edit as TcxCustomFontNameComboBox).PopupControlsLookAndFeel;
    end;

    FPanel.Locked := True;
    try
      FPanel.Edges := [bBottom];
      FPanel.Caption := GetPreviewText;
      FPanel.FontName := GetFontName;
      FPanel.FontStyle := AProperties.FontPreview.FontStyle;
      FPanel.ShowEndEllipsis := AProperties.FontPreview.ShowEndEllipsis and (AProperties.FontPreview.PreviewType <> cxfpFontName);

      if (AProperties.FontPreview.Color = clWindow) and (FPanel.LookAndFeel.SkinPainter <> nil) then
      begin
        FPanel.Color := FPanel.LookAndFeel.SkinPainter.DefaultEditorBackgroundColor(False);
        FPanel.FontColor := FPanel.LookAndFeel.SkinPainter.DefaultEditorTextColor(False);
      end
      else
      begin
        FPanel.Color := AProperties.FontPreview.Color;
        FPanel.FontColor := clWindowText;
      end;

      AAlignment := AProperties.FontPreview.Alignment;
      if FPanel.UseRightToLeftAlignment then
        ChangeBiDiModeAlignment(AAlignment);
      FPanel.Alignment := AAlignment;

      FPanel.WordWrap := AProperties.FontPreview.WordWrap and (AProperties.FontPreview.PreviewType <> cxfpFontName);
      FPanel.ShowButtons := AProperties.FontPreview.ShowButtons;
      FPanel.Parent := AVisualControlsParent;
      FPanel.Height := AProperties.ScaleFactor.Apply(cxFontPreviewPanelDefaultHeight);
      FPanel.Visible := True;
    finally
      FPanel.Locked := False;
    end;
  end
  else
    if Assigned(FPanel) then FPanel.Visible := False;
end;

procedure TcxFontNameComboBoxLookupData.DoPositionVisualArea(const ARect: TRect);
var
  R: TRect;
begin
  R := ARect;
  if ActiveProperties.FontPreview.Visible and Assigned(FPanel) and FPanel.HandleAllocated then
  begin
    FPanel.SetBounds(R.Left, R.Top, R.Right - R.Left, ActiveProperties.ScaleFactor.Apply(cxFontPreviewPanelDefaultHeight));
    FPanel.RealignButtons;
    Inc(R.Top, FPanel.Height);
  end;
  inherited DoPositionVisualArea(R);
end;

function TcxFontNameComboBoxLookupData.GetListBoxClass: TcxCustomEditListBoxClass;
begin
  Result := TcxFontNameComboBoxListBox;
end;

procedure TcxFontNameComboBoxLookupData.HandleSelectItem(Sender: TObject);
begin
  inherited HandleSelectItem(Sender);
  if Assigned(FPanel) and FPanel.HandleAllocated then
  begin
    FPanel.Locked := True;
    try
      if ItemIndex >= 0 then
        FPanel.FontName := GetFontName;
      if ActiveProperties.FontPreview.PreviewType <> cxfpFullAlphabet then
        FPanel.Caption := GetPreviewText;
    finally
      FPanel.Locked := False;
    end;
  end;
end;

procedure TcxFontNameComboBoxLookupData.InternalChangeCurrentMRUFontNamePosition;
var
  FIndex: Integer;
begin
  if ItemIndex > (ActiveProperties.FMRUFontNames.Count - 1) then
  begin
    FIndex := Items.IndexOf(Items[ItemIndex]);
    if FIndex >= 0 then
      InternalSetCurrentKey(FIndex);
  end;
end;

function TcxFontNameComboBoxLookupData.GetActiveProperties: TcxCustomFontNameComboBoxProperties;
begin
  Result := inherited ActiveProperties as TcxCustomFontNameComboBoxProperties;
end;

function TcxFontNameComboBoxLookupData.GetPreviewText: string;
begin
  case ActiveProperties.FontPreview.PreviewType of
    cxfpCustom: Result := ActiveProperties.FontPreview.PreviewText;
    cxfpFullAlphabet: Result := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz 1234567890';
    else
      Result := GetFontName;
  end;
end;

function TcxFontNameComboBoxLookupData.GetScaleFactor: TdxScaleFactor;
begin
  Result := ActiveProperties.ScaleFactor;
end;

function TcxFontNameComboBoxLookupData.GetFontName: string;
begin
  if ItemIndex = -1 then
    Result := ''
  else
    Result := Items[ItemIndex];
end;

{ TcxCustomFontNameComboBoxProperties }

constructor TcxCustomFontNameComboBoxProperties.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  DropDownListStyle := lsFixedList;
  FMaxMRUFonts := 10;
  FFontTypes := [cxftTTF, cxftRaster, cxftDevice, cxftFixed, cxftSymbol];
  FUseOwnFont := False;
  FShowFontTypeIcon := [ftiShowInCombo, ftiShowInList];
  FMRUFontNames := TcxMRUFontNameItems.Create(Self, TcxMRUFontNameItem);
  FFontPreview := TcxFontPreview.Create(Self);
  LoadFontNames;
end;

destructor TcxCustomFontNameComboBoxProperties.Destroy;
begin
  FreeAndNil(FFontPreview);
  FreeAndNil(FMRUFontNames);
  inherited Destroy;
end;

function TcxCustomFontNameComboBoxProperties.CompareDisplayValues(
  const AEditValue1, AEditValue2: TcxEditValue): Boolean;
var
  AItemIndex1, AItemIndex2: Integer;
  AText1, AText2: string;
begin
  GetFontNameComboBoxDisplayValue(AEditValue1, AItemIndex1, AText1);
  GetFontNameComboBoxDisplayValue(AEditValue2, AItemIndex2, AText2);
  Result := AItemIndex1 = AItemIndex2;
end;

class function TcxCustomFontNameComboBoxProperties.GetContainerClass: TcxContainerClass;
begin
  Result := TcxFontNameComboBox;
end;

procedure TcxCustomFontNameComboBoxProperties.GetFontNameComboBoxDisplayValue(
  const AEditValue: TcxEditValue; out AItemIndex: Integer; out AText: string);
begin
  if not LoadFontComplete then
  begin
    AItemIndex := -1;
    AText := cxGetResourceString(@scxLoadingFonts);
  end
  else
  begin
    AItemIndex := FindItemByValue(AEditValue);
    if AItemIndex = -1 then
      AText := ''
    else
      AText := Items[AItemIndex];
  end;
  CheckCharsRegister(AText, CharCase);
end;

procedure TcxCustomFontNameComboBoxProperties.DoAssign(AProperties: TcxCustomEditProperties);
begin
  inherited;
  if AProperties is TcxCustomFontNameComboBoxProperties then
    with TcxCustomFontNameComboBoxProperties(AProperties) do
    begin
      Self.UseOwnFont := UseOwnFont;
      Self.FontTypes := FontTypes;
      Self.ShowFontTypeIcon := ShowFontTypeIcon;
      Self.FontPreview := FontPreview;
      Self.MaxMRUFonts := MaxMRUFonts;
      Self.OnAddedMRUFont := OnAddedMRUFont;
      Self.OnMovedMRUFont := OnMovedMRUFont;
      Self.OnDeletedMRUFont := OnDeletedMRUFont;
      Self.OnLoadFontComplete := OnLoadFontComplete;
      Self.MRUFontNames.Assign(MRUFontNames);
    end;
end;

function TcxCustomFontNameComboBoxProperties.FindLookupText(const AText: string): Boolean;
begin
  Result := not LoadFontComplete or inherited FindLookupText(AText);
end;

class function TcxCustomFontNameComboBoxProperties.GetLookupDataClass: TcxInterfacedPersistentClass;
begin
  Result := TcxFontNameComboBoxLookupData;
end;

class function TcxCustomFontNameComboBoxProperties.GetViewDataClass: TcxCustomEditViewDataClass;
begin
  Result := TcxCustomFontNameComboBoxViewData;
end;

class function TcxCustomFontNameComboBoxProperties.GetViewInfoClass: TcxContainerViewInfoClass;
begin
  Result := TcxCustomFontNameComboBoxViewInfo;
end;

function TcxCustomFontNameComboBoxProperties.GetFontItems: TStrings;
begin
  Result := Items;
end;

function TcxCustomFontNameComboBoxProperties.GetFontTypes: TcxFontTypes;
begin
  Result := FFontTypes;
end;

procedure TcxCustomFontNameComboBoxProperties.SetFontTypes(Value: TcxFontTypes);
begin
  if FFontTypes <> Value then
  begin
    FFontTypes := Value;
    FMRUFontNames.Clear;
    LoadFontNames;
    Changed;
  end;
end;

procedure TcxCustomFontNameComboBoxProperties.SetMaxMRUFonts(Value: Byte);
var
  FOldMaxMRUFonts: Byte;
begin
  if FMaxMRUFonts <> Value then
  begin
    FOldMaxMRUFonts := FMaxMRUFonts;
    FMaxMRUFonts := Value;
    if FOldMaxMRUFonts > Value then
    begin
      DeleteOverMRUFonts;
      Changed;
    end;
  end;
end;

function TcxCustomFontNameComboBoxProperties.GetUseOwnFont: Boolean;
begin
  Result := FUseOwnFont;
end;

procedure TcxCustomFontNameComboBoxProperties.SetUseOwnFont(Value: Boolean);
begin
  if FUseOwnFont <> Value then
  begin
    FUseOwnFont := Value;
    Changed;
  end;
end;

procedure TcxCustomFontNameComboBoxProperties.SetShowFontTypeIcon(Value: TcxShowFontIconTypes);
begin
  if FShowFontTypeIcon <> Value then
  begin
    FShowFontTypeIcon := Value;
    Changed;
  end;
end;

function TcxCustomFontNameComboBoxProperties.FindItemByValue(const AEditValue: TcxEditValue): Integer;
begin
  if not LoadFontComplete or IsVarEmpty(AEditValue) then
    Result := -1
  else
    Result := Items.IndexOf(VarToStr(AEditValue));
end;

function TcxCustomFontNameComboBoxProperties.GetItemTypes(Index: Integer): TcxFontTypes;
begin
  Result := RealFontTypeToCxTypes(Integer(Items.Objects[Index]));
end;

procedure TcxCustomFontNameComboBoxProperties.SetFontPreview(Value: TcxFontPreview);
begin
  FontPreview.Assign(Value);
  Changed;
end;

procedure TcxCustomFontNameComboBoxProperties.LoadFontNames;
begin
  FLoadFontComplete := False;
  FontLoader.PopulateFonts(FreeNotificator, FontLoaderCompleteHandler, Items, FontTypes);
end;

procedure TcxCustomFontNameComboBoxProperties.DoUpdate(AProperties: TcxCustomEditProperties);
var
  AFontNameComboBoxProperties: TcxCustomFontNameComboBoxProperties;
begin
  if FLoadFontComplete then
  begin
    AFontNameComboBoxProperties := AProperties as TcxCustomFontNameComboBoxProperties;
    AFontNameComboBoxProperties.Items.Assign(Items);
    AFontNameComboBoxProperties.MRUFontNames.Assign(MRUFontNames);
  end;
end;

procedure TcxCustomFontNameComboBoxProperties.FontLoaderCompleteHandler(Sender: TObject);
begin
  FLoadFontComplete := True;
  if Assigned(FOnInternalLoadFontComplete) then
    FOnInternalLoadFontComplete(Self);
  if Assigned(OnLoadFontComplete) then
    OnLoadFontComplete(Self);
  Changed;
end;

function TcxCustomFontNameComboBoxProperties.AddMRUFontName(const AFontName: TFontName): TcxMRUFontNameAction;
var
  FIndex: Integer;
begin
  Result := mfaNone;
  if MaxMRUFonts = 0 then
    Exit;
  Result := mfaInvalidFontName;
  FIndex := Items.IndexOf(AFontName);
  if FIndex < 0 then
    Exit;
  {If this font exists in MRU list, do not add, only move to first position}
  if FMRUFontNames.FindFontName(AFontName) <> nil then
  begin
    if (FIndex > 0) and (FIndex < FMRUFontNames.Count) then
    begin
      Result := mfaMoved;
      Items.Move(FIndex, 0);
      FMRUFontNames.Move(FIndex, 0);
      if Assigned(OnMovedMRUFont) then
        OnMovedMRUFont(Self);
    end
    else
      Result := mfaNone;
  end
  else
    Result := mfaAdded;
  if Result = mfaAdded then
  begin
    FMRUFontNames.InsertMRUFontName(0, AFontName);
    Items.InsertObject(0, AFontName, Items.Objects[FIndex]);
    DeleteOverMRUFonts;
    if Assigned(OnAddedMRUFont) then
      OnAddedMRUFont(Self);
  end;
end;

function TcxCustomFontNameComboBoxProperties.DelMRUFontName(const AFontName: TFontName): TcxMRUFontNameAction;
var
  FIndex: Integer;
begin
  Result := mfaInvalidFontName;
  {Check for right Font name}
  FIndex := Items.IndexOf(AFontName);
  if FIndex < 0 then
    Exit;
  if FMRUFontNames.FindFontName(AFontName) <> nil then
  begin
    FMRUFontNames.Delete(FIndex);
    Items.Delete(FIndex);
    Result := mfaDeleted;
    if Assigned(OnDeletedMRUFont) then
      OnDeletedMRUFont(Self, AFontName);
  end;
end;

procedure TcxCustomFontNameComboBoxProperties.DeleteOverMRUFonts;
var
  I: Integer;
  FDeletedFontName: string;
begin
  BeginUpdate;
  try
    for I := FMRUFontNames.Count - 1 downto 0 do
    begin
      if I >= FMaxMRUFonts then
      begin
        FMRUFontNames.Delete(I);
        FDeletedFontName := Items[I];
        Items.Delete(I);
        if Assigned(OnDeletedMRUFont) then
          OnDeletedMRUFont(Self, FDeletedFontName);
      end
      else
        Break;
    end;
  finally
    EndUpdate;
  end;
end;

{ TcxCustomFontNameComboBox }

constructor TcxCustomFontNameComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

function TcxCustomFontNameComboBox.Deactivate: Boolean;
begin
  Result := inherited Deactivate;
  UpdateMRUList;
end;

class function TcxCustomFontNameComboBox.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TcxCustomFontNameComboBoxProperties;
end;

function TcxCustomFontNameComboBox.GetInnerEditClass: TControlClass;
begin
  Result := TcxCustomFontNameComboBoxInnerEdit;
end;

function TcxCustomFontNameComboBox.GetPopupWindowClientPreferredSize: TSize;
begin
  Result := inherited GetPopupWindowClientPreferredSize;
end;

procedure TcxCustomFontNameComboBox.Initialize;
begin
  inherited Initialize;
  FFontNameQueue := '';
  ControlStyle := ControlStyle - [csClickEvents];
  Properties.FOnInternalLoadFontComplete := InternalLoadFontCompleteHandler;
end;

procedure TcxCustomFontNameComboBox.InitializePopupWindow;
begin
  inherited InitializePopupWindow;
  PopupWindow.SysPanelStyle := ActiveProperties.PopupSizeable;
end;

procedure TcxCustomFontNameComboBox.CloseUp(AReason: TcxEditCloseUpReason);
begin
  FNeedsUpdateMRUList := FNeedsUpdateMRUList or (AReason in [crTab, crEnter, crClose]);
  try
    inherited CloseUp(AReason);
  finally
    UpdateMRUList;
  end;
end;

procedure TcxCustomFontNameComboBox.SetItemIndex(Value: Integer);
begin
  if ActiveProperties.LoadFontComplete then
    inherited SetItemIndex(Value);
end;

function TcxCustomFontNameComboBox.AddMRUFontName(const AFontName: TFontName): TcxMRUFontNameAction;
begin
  Result := ActiveProperties.AddMRUFontName(AFontName);
end;

function TcxCustomFontNameComboBox.DelMRUFontName(const AFontName: TFontName): TcxMRUFontNameAction;
begin
  Result := ActiveProperties.DelMRUFontName(AFontName);
end;

function TcxCustomFontNameComboBox.GetProperties: TcxCustomFontNameComboBoxProperties;
begin
  Result := TcxCustomFontNameComboBoxProperties(inherited Properties);
end;

function TcxCustomFontNameComboBox.GetActiveProperties: TcxCustomFontNameComboBoxProperties;
begin
  Result := TcxCustomFontNameComboBoxProperties(InternalGetActiveProperties);
end;

function TcxCustomFontNameComboBox.GetFontName: string;
begin
  Result := FFontNameQueue;
  if (Result = '') and (ItemIndex <> -1) then
    Result := ActiveProperties.Items[ItemIndex];
end;

procedure TcxCustomFontNameComboBox.SetFontName(Value: string);
begin
  if Value = '' then
  begin
    FFontNameQueue := '';
    ItemIndex := -1;
  end
  else
  begin
    if not ActiveProperties.LoadFontComplete then
      FFontNameQueue := Value
    else
      ItemIndex := ActiveProperties.Items.IndexOf(Value);
  end;
end;

function TcxCustomFontNameComboBox.GetLookupData: TcxFontNameComboBoxLookupData;
begin
  Result := TcxFontNameComboBoxLookupData(FLookupData);
end;

procedure TcxCustomFontNameComboBox.SetProperties(Value: TcxCustomFontNameComboBoxProperties);
begin
  Properties.Assign(Value);
end;

procedure TcxCustomFontNameComboBox.InternalLoadFontCompleteHandler(Sender: TObject);
var
  FLocalFontName: string;
begin
  if FFontNameQueue <> '' then
  begin
    SetFontName(FFontNameQueue);
    FFontNameQueue := '';
  end
  else
  begin
    if IsVarEmpty(FEditValue) then
      FLocalFontName := ''
    else
      FLocalFontName := VarToStr(FEditValue);
    LookupData.InternalSetCurrentKey(ActiveProperties.Items.IndexOf(FLocalFontName));
  end;
end;

procedure TcxCustomFontNameComboBox.UpdateMRUList;
var
  AFontName: TFontName;
  AFontNameIndex: Integer;
begin
  try
    if FNeedsUpdateMRUList and (FDontCheckModifiedWhenUpdatingMRUList or ModifiedAfterEnter) then
    begin
      AFontNameIndex := ActiveProperties.Items.IndexOf(Text);
      if AFontNameIndex = -1 then
        AFontName := Text
      else
        AFontName := ActiveProperties.Items[AFontNameIndex];
      if AddMRUFontName(AFontName) in [mfaNone, mfaMoved] then
        LookupData.InternalChangeCurrentMRUFontNamePosition;
    end;
  finally
    FDontCheckModifiedWhenUpdatingMRUList := False;
    FNeedsUpdateMRUList := False;
  end;
end;
  
procedure TcxCustomFontNameComboBox.AfterPosting;
begin
  inherited AfterPosting;
  if IsInplace and FNeedsUpdateMRUList then
    FDontCheckModifiedWhenUpdatingMRUList := True;
end;

procedure TcxCustomFontNameComboBox.InternalSetEditValue(const Value: TcxEditValue; AValidateEditValue: Boolean);
begin
  if IsDestroying then
    Exit;
  inherited;
end;

{ TcxFontNameComboBox }

class function TcxFontNameComboBox.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TcxFontNameComboBoxProperties;
end;

function TcxFontNameComboBox.GetActiveProperties: TcxFontNameComboBoxProperties;
begin
  Result := TcxFontNameComboBoxProperties(InternalGetActiveProperties);
end;

function TcxFontNameComboBox.GetProperties: TcxFontNameComboBoxProperties;
begin
  Result := TcxFontNameComboBoxProperties(inherited Properties);
end;

procedure TcxFontNameComboBox.SetProperties(Value: TcxFontNameComboBoxProperties);
begin
  Properties.Assign(Value);
end;

function TcxFontNameComboBox.SupportsItemIndex: Boolean;
begin
  Result := True;
end;

{ TcxFilterFontNameComboBoxHelper }

class function TcxFilterFontNameComboBoxHelper.GetFilterEditClass: TcxCustomEditClass;
begin
  Result := TcxFontNameComboBox;
end;

class function TcxFilterFontNameComboBoxHelper.GetSupportedFilterOperators(
  AProperties: TcxCustomEditProperties; AValueTypeClass: TcxValueTypeClass;
  AExtendedSet: Boolean = False): TcxFilterControlOperators;
begin
  Result := [fcoEqual, fcoNotEqual, fcoBlanks, fcoNonBlanks];
  if AExtendedSet then
    Result := Result + [fcoInList, fcoNotInList];
end;


{ TcxFontNameComboBoxProperties }

function TcxFontNameComboBoxProperties.FindValueByItemIndex(AItemIndex: Integer;
  out AValue: Variant): Boolean;
begin
  Result := InRange(AItemIndex, 0, Items.Count - 1);
  if Result then
    AValue := Items[AItemIndex];
end;

function TcxFontNameComboBoxProperties.SupportsItemIndex: Boolean;
begin
  Result := True;
end;

initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  GetRegisteredEditProperties.Register(TcxFontNameComboBoxProperties, scxSEditRepositoryFontNameComboBoxItem);
  FTrueTypeFontGlyph := TdxSmartGlyph.Create;
  FTrueTypeFontGlyph.LoadFromResource(HInstance, 'CXFONTCOMBO_TTF', 'SVG');
  FNonTrueTypeFontGlyph := TdxSmartGlyph.Create;
  FNonTrueTypeFontGlyph.LoadFromResource(HInstance, 'CXFONTCOMBO_NONTTF', 'SVG');
  FilterEditsController.Register(TcxFontNameComboBoxProperties, TcxFilterFontNameComboBoxHelper);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  FilterEditsController.Unregister(TcxFontNameComboBoxProperties, TcxFilterFontNameComboBoxHelper);
  GetRegisteredEditProperties.Unregister(TcxFontNameComboBoxProperties);
  FreeAndNil(FNonTrueTypeFontGlyph);
  FreeAndNil(FTrueTypeFontGlyph);
  dxFreeGlobalObject(FFontLoader);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
