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
unit dxListView;

{$I cxVer.inc}
{$SCOPEDENUMS ON}

interface

uses
  ImgList,
  UITypes,
  Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, Messages, Types,
  Generics.Defaults, Generics.Collections, dxTypeHelpers, dxGenerics,  cxDrawTextUtils,
  dxCore, dxCoreClasses, cxClasses, cxControls, dxGDIPlusClasses, cxLookAndFeels, cxLookAndFeelPainters,
  cxGraphics, cxGeometry, dxCoreGraphics, cxCustomCanvas, dxInplaceEditing, dxCustomHint;

type
  TdxListItemChange = (Text, Image, State);
  TdxCustomListView = class;
  TdxListGroup = class;
  TdxListItem = class;
  TdxListViewPainter = class;
  TdxListViewPainterClass = class of TdxListViewPainter;
  TdxListViewController = class;
  TdxListItems = class;
  TdxListColumns = class;
  TdxListGroups = class;
  TdxListItemViewInfo = class;
  TdxListGroupCustomViewInfo = class;
  TdxListGroupViewInfo = class;
  TdxListViewViewInfo = class;
  TdxListViewColumnHeadersViewInfo = class;
  TdxListItemReportStyleViewInfo = class;
  TdxListViewCompareProc = function(AItem1, AItem2: TdxListItem; AData: TdxNativeInt): Integer;

  { TdxListViewPersistent }

  TdxListViewPersistent = class(TcxOwnedPersistent)
  strict private
    function GetListView: TdxCustomListView;
  protected
    property ListView: TdxCustomListView read GetListView;
  public
    constructor Create(AOwner: TdxCustomListView); reintroduce; virtual;
  end;

  { TdxListItem }

  TdxListItem = class(TPersistent)
  strict protected const
  private
    FOwner: TdxListItems;
    FSubItems: TStrings;
    FCut: Boolean;
    FImageIndex: TcxImageIndex;
    FIndex: Integer;
    FLoadingGroupID: Integer;
    FOverlayIndex: TcxImageIndex;
    FStateIndex: TcxImageIndex;
    FCaption: string;
    FDeleting: Boolean;
    FChecked: Boolean;
    FData: TCustomData;
    FGroup: TdxListGroup;
    FGroupID: Integer;
    FEnabled: Boolean;
    FHint: string;
    FTag: Int64;
    function GetChecked: Boolean;
    function GetDropTarget: Boolean;
    function GetFocused: Boolean;
    function GetIndex: Integer;
    function GetListView: TdxCustomListView; inline;
    function GetLeft: Integer;
    function GetSelected: Boolean;
    function GetTop: Integer;
    procedure DirectSetSubItemImage(AIndex: Integer; const AValue: Integer);
    procedure SetChecked(AValue: Boolean);
    procedure SetCaption(const AValue: string);
    procedure SetCut(AValue: Boolean);
    procedure SetData(AValue: TCustomData);
    procedure SetEnabled(AValue: Boolean);
    procedure SetFocused(AValue: Boolean);
    procedure SetImage(AIndex: Integer; AValue: TcxImageIndex);
    procedure SetSelected(AValue: Boolean);
    procedure SetSubItems(AValue: TStrings);
    function GetSubItemImage(AIndex: Integer): Integer;
    procedure SetSubItemImage(AIndex: Integer; const AValue: Integer);
    procedure SetGroup(AValue: TdxListGroup);
    procedure SetGroupID(AValue: Integer);
    procedure SetDropTarget(AValue: Boolean);
  protected
    procedure Changed(AType: TdxChangeType = ctHard); virtual;
    procedure FixupGroup;
    function GetPosition: TPoint;
    function IsEnabled: Boolean;
    function IsEqual(AItem: TdxListItem): Boolean;
  public
    constructor Create(AOwner: TdxListItems); virtual;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure BeforeDestruction; override;
    procedure CancelEdit;
    procedure Delete;
    function DisplayRect({Code: TDisplayCode}): TRect;
    function EditCaption: Boolean;
    procedure MakeVisible(PartialOK: Boolean);

    property Caption: string read FCaption write SetCaption;
    property Checked: Boolean read GetChecked write SetChecked;
    property Cut: Boolean read FCut write SetCut;
    property Data: TCustomData read FData write SetData;
    property Deleting: Boolean read FDeleting;
    property DropTarget: Boolean read GetDropTarget write SetDropTarget;
    property Focused: Boolean read GetFocused write SetFocused;
    property Group: TdxListGroup read FGroup write SetGroup;
    property GroupID: Integer read FGroupID write SetGroupID default -1;
    property ImageIndex: TcxImageIndex index 0 read FImageIndex write SetImage;
    property Index: Integer read GetIndex;
    property Left: Integer read GetLeft;
    property ListView: TdxCustomListView read GetListView;
    property Owner: TdxListItems read FOwner;
    property OverlayIndex: TcxImageIndex index 1 read FOverlayIndex write SetImage;
    property Position: TPoint read GetPosition;
    property Selected: Boolean read GetSelected write SetSelected;
    property StateIndex: TcxImageIndex index 2 read FStateIndex write SetImage;
    property SubItems: TStrings read FSubItems write SetSubItems;
    property SubItemImages[Index: Integer]: Integer read GetSubItemImage write SetSubItemImage;
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property Hint: string read FHint write FHint;
    property Tag: Int64 read FTag write FTag default 0;
    property Top: Integer read GetTop;
  end;
  TdxListItemClass = class of TdxListItem;

  { TdxListItemsEnumerator }

  TdxListItemsEnumerator = class // for internal use
  private
    FIndex: Integer;
    FListItems: TdxListItems;
  public
    constructor Create(AListItems: TdxListItems);
    function GetCurrent: TdxListItem;
    function MoveNext: Boolean;
    property Current: TdxListItem read GetCurrent;
  end;

  { TdxListItems }

  TdxListItems = class(TPersistent)
  private
    FCount: Integer;
    FList: TdxFastObjectList;
    FListView: TdxCustomListView;
    FNeedRebuildIndices: Boolean;
    function IsItemAddition(AIndex: Integer): Boolean;
    procedure ReadItemData(AStream: TStream);
    procedure WriteItemData(AStream: TStream);
  protected
    procedure Changed; virtual;
    procedure CustomSort(ASortProc: TdxListViewCompareProc; AData: TdxNativeInt);
    procedure DefineProperties(AFiler: TFiler); override;
    procedure FixupGroups;
    function GetCount: Integer;
    function GetItem(AIndex: Integer): TdxListItem;
    procedure InsertItem(AItem: TdxListItem; AIndex: Integer);
    procedure RemoveFromList(AIndex: Integer);
    procedure RebuildIndices(AStartIndex: Integer);
    procedure SetCount(AValue: Integer);
    procedure SetItem(AIndex: Integer; AValue: TdxListItem);
    procedure SetUpdateState(AUpdating: Boolean);
    procedure ValidateIndices;

    property List: TdxFastObjectList read FList;
    property NeedRebuildIndices: Boolean read FNeedRebuildIndices write FNeedRebuildIndices;
  public
    constructor Create(AListView: TdxCustomListView); virtual;
    destructor Destroy; override;
    function Add: TdxListItem;
    procedure Assign(ASource: TPersistent); override;
    procedure BeginUpdate;
    procedure Clear;
    procedure Delete(AIndex: Integer);
    procedure EndUpdate;
    function GetEnumerator: TdxListItemsEnumerator;
    function GetItemAtPos(const P: TPoint): TdxListItem;
    function IndexOf(AValue: TdxListItem): Integer;
    function Insert(AIndex: Integer): TdxListItem;
    property Count: Integer read GetCount write SetCount;
    property Items[Index: Integer]: TdxListItem read GetItem write SetItem; default;
    property ListView: TdxCustomListView read FListView;
  end;

  { TdxListGroup }

  TdxListGroupOption = (Collapsible, Focusable, Hidden, NoHeader, SelectItems);
  TdxListGroupOptions = set of TdxListGroupOption;

  TdxListGroup = class(TcxComponentCollectionItem)
  protected const
    DefaultOptions = [TdxListGroupOption.Focusable, TdxListGroupOption.SelectItems];
  strict private
    FCollapsed: Boolean;
    FHeader: string;
    FFooter: string;
    FHeaderAlign: TAlignment;
    FFooterAlign: TAlignment;
    FItemIndices: TdxIntegerList;
    FOptions: TdxListGroupOptions;
    FSubtitle: string;
    FTitleImage: TcxImageIndex;
    function GetFocused: Boolean;
    function GetGroups: TdxListGroups;
    function GetItemCount: Integer; inline;
    function GetItem(AIndex: Integer): TdxListItem; inline;
    function GetListView: TdxCustomListView; inline;
    procedure SetCollapsed(const AValue: Boolean);
    procedure SetFocused(const AValue: Boolean);
    procedure SetFooter(const AValue: string);
    procedure SetHeader(const AValue: string);
    procedure SetHeaderAlign(const AValue: TAlignment);
    procedure SetFooterAlign(const AValue: TAlignment);
    procedure SetGroupID(AValue: Integer);
    procedure SetOptions(const AValue: TdxListGroupOptions);
    procedure SetSubtitle(const AValue: string);
    procedure SetTitleImage(const AValue: TcxImageIndex);
  protected
    FGroupID: Integer;
    procedure AddItem(AItem: TdxListItem);
    procedure AlphaSort;
    procedure AttachItems;
    procedure RemoveItem(AItem: TdxListItem);
    procedure Changed;
    procedure DetachItems;
    function GetDisplayName: string; override;
    function IsCollapsible: Boolean;
    function IsFocusable: Boolean;
    function IsVisible: Boolean;
    function NeedSelectItems: Boolean;
    function CustomSort(ASortProc: TdxListViewCompareProc; AData: TdxNativeInt): Boolean;

    property Groups: TdxListGroups read GetGroups;
    property ItemIndices: TdxIntegerList read FItemIndices;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function GetCollectionFromParent(AParent: TComponent): TcxComponentCollection; override;
    procedure SelectAll;
    procedure SelectRange(AFirstIndex, ALastIndex: Integer);

    property Focused: Boolean read GetFocused write SetFocused;
    property ItemCount: Integer read GetItemCount;
    property Items[AIndex: Integer]: TdxListItem read GetItem;
    property ListView: TdxCustomListView read GetListView;
  published
    property Collapsed: Boolean read FCollapsed write SetCollapsed default False;
    property Header: string read FHeader write SetHeader;
    property Footer: string read FFooter write SetFooter;
    property HeaderAlign: TAlignment read FHeaderAlign write SetHeaderAlign default taLeftJustify;
    property FooterAlign: TAlignment read FFooterAlign write SetFooterAlign default taLeftJustify;
    property GroupID: Integer read FGroupID write SetGroupID;
    property Options: TdxListGroupOptions read FOptions write SetOptions default DefaultOptions;
    property Subtitle: string read FSubtitle write SetSubtitle;
    property TitleImage: TcxImageIndex read FTitleImage write SetTitleImage default -1;
  end;
  TdxListGroupClass = class of TdxListGroup;

  { TdxListGroups }

  TdxListGroups = class(TcxInterfacedComponentCollection)
  strict private
    FListView: TdxCustomListView;
    function GetItem(AIndex: Integer): TdxListGroup;
    function GetNextGroupID: Integer;
    procedure SetItem(AIndex: Integer; AValue: TdxListGroup);
  protected
    function GetFirstVisibleGroup: TdxListGroup;
    procedure Notify(AItem: TcxComponentCollectionItem; AAction: TcxComponentCollectionNotification); override;
    procedure RebuildItems;
    procedure SetItemName(AItem: TcxComponentCollectionItem; ABaseIndex: Integer = -1); override;

    property ListView: TdxCustomListView read FListView;
  public
    constructor Create(AParentComponent: TComponent; AItemClass: TcxComponentCollectionItemClass); override;
    function Add: TdxListGroup;
    function FindByHeader(const AHeader: string; out AGroup: TdxListGroup): Boolean;
    function FindByGroupID(AGroupID: Integer): TdxListGroup;
    function GetGroupAtPos(const P: TPoint): TdxListGroup;
    function GetItemAtPos(const P: TPoint): TdxListItem;

    property Items[AIndex: Integer]: TdxListGroup read GetItem write SetItem; default;
    property NextGroupID: Integer read GetNextGroupID;
  end;
  TdxListGroupsClass = class of TdxListGroups;

  { TdxListColumn }

  TdxListColumn = class(TcxComponentCollectionItem)
  protected const
    DefaultColumnWidth = 50;
    UndefinedCreatedOrderIndex = -2;
  strict private
    FAlignment: TAlignment;
    FCaption: string;
    FHeaderAlignment: TAlignment;
    FMaxWidth: Integer;
    FMinWidth: Integer;
    FImageIndex: TcxImageIndex;
    FSortOrder: TdxSortOrder;
    FWidth: Integer;
    function GetColumns: TdxListColumns; inline;
    function GetListView: TdxCustomListView; inline;
    procedure SetAlignment(AValue: TAlignment);
    procedure SetCaption(const AValue: string);
    procedure SetHeaderAlignment(AValue: TAlignment);
    procedure SetImageIndex(AValue: TcxImageIndex);
    procedure SetMaxWidth(AValue: Integer);
    procedure SetMinWidth(AValue: Integer);
    procedure SetSortOrder(AValue: TdxSortOrder);
    procedure SetWidth(AValue: Integer);
    //
    procedure ReadCreatedOrderIndex(AReader: TReader);
    procedure WriteCreatedOrderIndex(AWriter: TWriter);
  protected
    FSubItemIndex: Integer;
    FCreatedOrderIndex: Integer;
    procedure Changed(AType: TdxChangeType = ctMedium);
    procedure ChangeScale(M, D: Integer);
    procedure DefineProperties(AFiler: TFiler); override;
    function GetCollectionFromParent(AParent: TComponent): TcxComponentCollection; override;
    function GetDisplayName: string; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
    procedure ApplyBestFit(AVisibleItemsOnly: Boolean = False);

    property Columns: TdxListColumns read GetColumns;
    property ListView: TdxCustomListView read GetListView;
    property SortOrder: TdxSortOrder read FSortOrder write SetSortOrder default soNone;
  published
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property Caption: string read FCaption write SetCaption;
    property HeaderAlignment: TAlignment read FHeaderAlignment write SetHeaderAlignment default taLeftJustify;
    property ImageIndex: TcxImageIndex read FImageIndex write SetImageIndex default -1;
    property MaxWidth: Integer read FMaxWidth write SetMaxWidth default 0;
    property MinWidth: Integer read FMinWidth write SetMinWidth default 0;
    property Width: Integer read FWidth write SetWidth default DefaultColumnWidth;
  end;
  TdxListColumnClass = class of TdxListColumn;

  { TdxListColumns }

  TdxListColumns = class(TcxInterfacedComponentCollection)
  strict private
    FListView: TdxCustomListView;
    FSubItemIndices: TArray<Integer>;
    function GetItem(AIndex: Integer): TdxListColumn;
    procedure SetItem(AIndex: Integer; AValue: TdxListColumn);
  protected
    procedure ChangeScale(M, D: Integer);
    function FindSubItemColumn(ASubItemIndex: Integer): TdxListColumn;
    procedure Notify(AItem: TcxComponentCollectionItem; AAction: TcxComponentCollectionNotification); override;
    procedure RebuildSubItemIndices;
    procedure SetItemName(AItem: TcxComponentCollectionItem; ABaseIndex: Integer = -1); override;
    procedure Update(AItem: TcxComponentCollectionItem; AAction: TcxComponentCollectionNotification); override;
    procedure ValidateCreateIndices;
  public
    constructor Create(AParentComponent: TComponent; AItemClass: TcxComponentCollectionItemClass); override;
    function Add: TdxListColumn;
    procedure BeginUpdate; override;
    procedure EndUpdate(AForceUpdate: Boolean = True); override;

    property ListView: TdxCustomListView read FListView;
    property Items[AIndex: Integer]: TdxListColumn read GetItem write SetItem; default;
  end;

  { TdxListViewCustomViewInfo }

  TdxListViewCustomViewInfo = class(TcxIUnknownObject,
    IcxHintableObject,
    IcxHintableObject2) // for internal use
  strict private
    FExternalCanvas: TcxCanvas;
    FIsDirty: Boolean;
    FIsRightToLeftConverted: Boolean;
    FListView: TdxCustomListView;
    function GetController: TdxListViewController; inline;
    function GetExplorerStyle: Boolean; inline;
    function GetLookAndFeelPainter: TcxCustomLookAndFeelPainter; inline;
    function GetPainter: TdxListViewPainter; inline;
    function GetScaleFactor: TdxScaleFactor; inline;
    function GetUseRightToLeftAlignment: Boolean; inline;
  protected
    FBounds: TRect;

    procedure AfterDraw(ACanvas: TcxCustomCanvas); virtual;
    procedure BeforeDraw(ACanvas: TcxCustomCanvas); virtual;
    procedure DoCalculate(AType: TdxChangeType); virtual;
    procedure DoRightToLeftConversion(const ABounds: TRect); virtual;
    procedure DrawContent(ACanvas: TcxCustomCanvas); virtual; abstract;
    function GetGapBetweenItems: Integer; virtual;
    function GetHitTestBounds: TRect; virtual;
    procedure InitializeCanvasBasedElements(AForExternalCanvas: Boolean); virtual;
    function IsGroupView: Boolean; inline;
    function IsIconView: Boolean; inline;
    function IsReportView: Boolean; inline;
    procedure MakeDirty; inline;
    procedure Offset(ADX, ADY: Integer); virtual;
    procedure ResetBounds; virtual;
    procedure RightToLeftConversion(const ABounds: TRect);
    procedure CancelHint;
    procedure CheckShowHint;
    function NeedShowHint: Boolean; virtual;
    //IcxHintableObject
    function IsHintAtMousePos: Boolean; virtual;
    function UseHintHidePause: Boolean; virtual;
    function HasHintPoint(const P: TPoint): Boolean; virtual;
    function ImmediateShowHint: Boolean; virtual;
    function GetHintObject: TObject; virtual;
    function GetHintText: string; virtual;
    function IsHintMultiLine: Boolean; virtual;
    function GetHintFont: TFont; virtual;
    function GetHintAreaBounds: TRect; virtual;
    function GetHintTextBounds: TRect; virtual;
    procedure MouseDown(AButton: TMouseButton; AShift: TShiftState; const AMousePos: TPoint); virtual;
    procedure MouseLeave; virtual;
    procedure MouseMove(AShift: TShiftState; const AMousePos: TPoint); virtual;
    procedure MouseUp(AButton: TMouseButton; AShift: TShiftState; const AMousePos: TPoint); virtual;

    property ExplorerStyle: Boolean read GetExplorerStyle;
    property ExternalCanvas: TcxCanvas read FExternalCanvas;
    property IsDirty: Boolean read FIsDirty;
    property IsRightToLeftConverted: Boolean read FIsRightToLeftConverted;
    property ListView: TdxCustomListView read FListView;
  public
    constructor Create(AListView: TdxCustomListView);
    destructor Destroy; override;
    procedure Calculate(AType: TdxChangeType; const ABounds: TRect);
    procedure Draw(ACanvas: TcxCustomCanvas);
    procedure Invalidate; virtual;
    procedure PaintTo(ACanvas: TcxCanvas);
    procedure Repaint; virtual;
    //
    property Bounds: TRect read FBounds;
    property Controller: TdxListViewController read GetController;
    property LookAndFeelPainter: TcxCustomLookAndFeelPainter read GetLookAndFeelPainter;
    property Painter: TdxListViewPainter read GetPainter;
    property ScaleFactor: TdxScaleFactor read GetScaleFactor;
    property UseRightToLeftAlignment: Boolean read GetUseRightToLeftAlignment;
  end;

  { TdxListViewCellViewParams }

  TdxListItemStateViewKind = (None, CheckBox, Glyph); // for internal use

  TdxListViewCellViewParams = class // for internal use
  public
    Padding: TdxPadding;
    Font: TcxCanvasBasedFont;
    GdiFont: TFont;
    GlyphIndent: TSize;
    GlyphSize: TSize;
    StateGlyphSize: TSize;
    GlyphsAreaSize: TSize;
    Images: TCustomImageList;
    StateImages: TCustomImageList;
    TextConstraints: TSize;
    TextFlags: Integer;
    TextLineCount: Integer;
    TextPosition: TcxPosition;
    StateViewKind: TdxListItemStateViewKind;
    destructor Destroy; override;
    function GetNonTextWidth: Integer;
    function GetReportNonTextWidth(ACheckState, ACheckGlyph: Boolean): Integer;
  end;

  { TdxListViewCellViewInfo }

  TdxListViewCellViewInfo = class(TdxListViewCustomViewInfo) // for internal use
  strict private
    FImageIndex: Integer;
    FText: string;
    FTextLayout: TcxCanvasBasedTextLayout;
    FViewParams: TdxListViewCellViewParams;
    function GetOrigin: TPoint; inline;
    procedure SetOrigin(const P: TPoint);
  protected
    FContentBounds: TRect;
    FGlyphBounds: TRect;
    FGlyphsAreaBounds: TRect;
    FTextAreaBounds: TRect;
    FTextBounds: TRect;
    function CalculateBoundsCore(const ABounds, AFullBounds: TRect;
      const ASize: TSize; APosition: TcxPosition): TRect;
    procedure CalculateContentBounds; virtual;
    procedure CalculateGlyphsAreaBounds; virtual;
    procedure CalculateGlyphBounds(const ABounds: TRect); virtual;
    procedure CalculateGlyphsBounds(const ABounds: TRect); virtual;
    procedure CalculateTextAreaBounds(const ABounds: TRect); virtual;
    procedure CalculateTextAndGlyphLayout; virtual;
    procedure CalculateTextBounds; virtual;
    function CreateTextLayout: TcxCanvasBasedTextLayout;
    function HasGlyph: Boolean; virtual;
    function HasStateGlyph: Boolean; virtual;
    procedure InitializeCanvasBasedElements(AForExternalCanvas: Boolean); override;
    procedure DirectSetImageIndex(AImageIndex: Integer);
    procedure UpdateBounds; virtual;
    procedure DoCalculate(AType: TdxChangeType); override;
    procedure DoRightToLeftConversion(const ABounds: TRect); override;
    procedure DrawContent(ACanvas: TcxCustomCanvas); override;
    procedure DrawGlyphCore(ACanvas: TcxCustomCanvas; const ABounds: TRect;
      AImages: TCustomImageList; AImageIndex, AOverlayIndex: Integer; AMode: TcxImageDrawMode; AAlpha: Byte; const AColorPalette: IdxColorPalette);
    procedure DrawGlyph(ACanvas: TcxCustomCanvas); virtual;
    procedure DrawText(ACanvas: TcxCustomCanvas); virtual;
    function GetColorPalette: IdxColorPalette; virtual;
    function GetGlyphAlpha: Byte; virtual;
    function GetGlyphState: TcxImageDrawMode; virtual;
    function GetTextColor: TColor; virtual; abstract;
    function GetTextFlags: Integer; virtual;
    procedure Initialize(const AText: string; AImageIndex: Integer; AForExternalCanvas: Boolean = False); overload;
    procedure Offset(ADX, ADY: Integer); override;
    procedure ResetBounds; override;
    function GetHintTextBounds: TRect; override;
    procedure MouseDown(AButton: TMouseButton; AShift: TShiftState; const AMousePos: TPoint); override;
    procedure MouseLeave; override;
    procedure MouseMove(AShift: TShiftState; const AMousePos: TPoint); override;
    procedure MouseUp(AButton: TMouseButton; AShift: TShiftState; const AMousePos: TPoint); override;

    property ContentBounds: TRect read FContentBounds;
    property GlyphsAreaBounds: TRect read FGlyphsAreaBounds;
  public
    constructor Create(AListView: TdxCustomListView; const AViewParams: TdxListViewCellViewParams);
    destructor Destroy; override;

    property GlyphBounds: TRect read FGlyphBounds;
    property ImageIndex: Integer read FImageIndex;
    property Origin: TPoint read GetOrigin write SetOrigin;
    property Text: string read FText;
    property TextLayout: TcxCanvasBasedTextLayout read FTextLayout;
    property TextAreaBounds: TRect read FTextAreaBounds;
    property TextBounds: TRect read FTextBounds;
    property ViewParams: TdxListViewCellViewParams read FViewParams;
  end;

  { TdxListViewItemCustomViewInfo }

  TdxListItemHitTest = (None, Content, Text, SubItemText, Glyph, StateGlyph); // for internal use

  TdxListItemCustomViewInfo = class(TdxListViewCellViewInfo) // for internal use
  strict private
    FCachedItem: TdxListItem;
    FItemIndex: Integer;
    FOwner: TdxListGroupCustomViewInfo;
    function GetItem: TdxListItem; inline;
    procedure SetHotTrackPart(AValue: TdxListItemHitTest);
  protected
    FHotTrackPart: TdxListItemHitTest;
    FStateBounds: TRect;
    FStateGlyphBounds: TRect;
    FState: TdxListViewItemStates;
    procedure BeforeDraw(ACanvas: TcxCustomCanvas); override;
    procedure CalculateStateGlyphBounds; virtual;
    procedure CalculateStateBounds; virtual;
    procedure CalculateGlyphsBounds(const ABounds: TRect); override;
    procedure DoRightToLeftConversion(const ABounds: TRect); override;
    procedure DrawBackground(ACanvas: TcxCustomCanvas); virtual;
    procedure DrawContent(ACanvas: TcxCustomCanvas); override;
    procedure DrawGlyph(ACanvas: TcxCustomCanvas); override;
    procedure DrawStateGlyph(ACanvas: TcxCustomCanvas); virtual;
    function DrawCheckAsOverlay: Boolean;
    procedure DrawText(ACanvas: TcxCustomCanvas); override;
    function GetColorPalette: IdxColorPalette; override;
    function GetGlyphAlpha: Byte; override;
    function GetState: TdxListViewItemStates;
    function GetTextColor: TColor; override;
    procedure Initialize(AItem: TdxListItem); overload; virtual;
    function IsHovered: Boolean; virtual;
    procedure Offset(ADX, ADY: Integer); override;
    function GetHintFont: TFont; override;
    function GetHintableObject(const AMousePos: TPoint): TdxListViewCustomViewInfo; virtual;
    function GetHintText: string; override;
    function NeedShowHint: Boolean; override;
    procedure InvalidatePart(APart: TdxListItemHitTest); virtual;
    procedure MouseLeave; override;
    procedure MouseMove(AShift: TShiftState; const AMousePos: TPoint); override;
    function StartDrag(AShift: TShiftState; const AMousePos: TPoint): Boolean; virtual;
    function StartEdit(AShift: TShiftState; const AMousePos: TPoint): Boolean; virtual;
    function StartMultiSelection(AShift: TShiftState; const AMousePos: TPoint): Boolean; virtual;

    property CachedItem: TdxListItem read FCachedItem;
    property HotTrackPart: TdxListItemHitTest read FHotTrackPart write SetHotTrackPart;
    property ItemIndex: Integer read FItemIndex;
    property Owner: TdxListGroupCustomViewInfo read FOwner;
  public
    constructor Create(AOwner: TdxListGroupCustomViewInfo; const AItemIndex: Integer; const AViewParams: TdxListViewCellViewParams); reintroduce; virtual;
    function GetHitTest(const P: TPoint): TdxListItemHitTest; virtual;

    property Item: TdxListItem read GetItem;
    property CheckBounds: TRect read FStateBounds;           
    property CheckGlyphBounds: TRect read FStateGlyphBounds; 
    property StateBounds: TRect read FStateBounds;
    property StateGlyphBounds: TRect read FStateGlyphBounds;
    property State: TdxListViewItemStates read FState;
  end;

  { TdxListViewItemViewInfo }

  TdxListItemViewInfo = class(TdxListItemCustomViewInfo); // for internal use

  { TdxListSubItemViewInfo }

  TdxListSubItemViewInfo = class(TdxListViewCellViewInfo) // for internal use
  strict private
    FColumnIndex: Integer;
    FOwner: TdxListItemReportStyleViewInfo;
  protected
    procedure CalculateGlyphsAreaBounds; override;
    procedure DrawContent(ACanvas: TcxCustomCanvas); override;
    function GetColorPalette: IdxColorPalette; override;
    function GetTextColor: TColor; override;
    function GetTextFlags: Integer; override;
    function HasGlyph: Boolean; override;
    function HasStateGlyph: Boolean; override;
    procedure Initialize(AColumnIndex: Integer; const AText: string; AImageIndex: Integer); overload;
    function GetHintFont: TFont; override;
    function GetHintText: string; override;
    function GetHintTextBounds: TRect; override;
    function NeedShowHint: Boolean; override;

    property ColumnIndex: Integer read FColumnIndex;
    property Owner: TdxListItemReportStyleViewInfo read FOwner;
  public
    constructor Create(AOwner: TdxListItemReportStyleViewInfo; const AViewParams: TdxListViewCellViewParams);
  end;

  { TdxListItemReportStyleViewInfo }

  TdxListItemReportStyleViewInfo = class(TdxListItemCustomViewInfo) // for internal use
  strict private
    FColumnIndex: Integer;
    FHiddenGlyph: Boolean;
    FItemBounds: TRect;
    FSharedBackground: Boolean;
    FStateButtonInSubItem: Boolean;
    FSubItems: TdxFastObjectList;
    function GetSubItem(Index: Integer): TdxListSubItemViewInfo; inline;
    function GetSubItemCount: Integer;
  protected
    procedure AddSubItem(AViewInfo: TdxListSubItemViewInfo);
    procedure BeforeDraw(ACanvas: TcxCustomCanvas); override;
    procedure CalculateStateGlyphBounds; override;
    procedure CalculateGlyphsAreaBounds; override;
    procedure CalculateGlyphsBounds(const ABounds: TRect); override;
    procedure DoCalculate(AType: TdxChangeType); override;
    procedure DoRightToLeftConversion(const ABounds: TRect); override;
    procedure DrawBackground(ACanvas: TcxCustomCanvas); override;
    procedure DrawContent(ACanvas: TcxCustomCanvas); override;
    function GetColumnTextFlags(AColumnIndex: Integer): Integer;
    function GetHintableObject(const AMousePos: TPoint): TdxListViewCustomViewInfo; override;
    function GetHintTextBounds: TRect; override;
    function GetTextFlags: Integer; override;
    function HasGlyph: Boolean; override;
    function HasStateGlyph: Boolean; override;
    procedure Initialize(AItem: TdxListItem); override;
    procedure InvalidatePart(APart: TdxListItemHitTest); override;
    function IsHovered: Boolean; override;
    procedure Offset(ADX, ADY: Integer); override;
    function StartEdit(AShift: TShiftState; const AMousePos: TPoint): Boolean; override;
  public
    constructor Create(AOwner: TdxListGroupCustomViewInfo; const AItemIndex: Integer; const AViewParams: TdxListViewCellViewParams); override;
    destructor Destroy; override;
    function GetHitTest(const P: TPoint): TdxListItemHitTest; override;

    property ItemBounds: TRect read FItemBounds;
    property SharedBackground: Boolean read FSharedBackground;
    property SubItemCount: Integer read GetSubItemCount;
    property SubItems[Index: Integer]: TdxListSubItemViewInfo read GetSubItem; default;
  end;

  { TdxListGroupCustomViewInfo }

  TdxListGroupHitTest = (None, Content, Item, Header, Footer, ExpandButton); // for internal use

  TdxListGroupCustomViewInfo = class(TdxListViewCustomViewInfo) // for internal use
  strict private
    FGroup: TdxListGroup;
    FHotTrackPart: TdxListGroupHitTest;
    FIndex: Integer;
    FOwner: TdxListViewViewInfo;
    function GetItem(Index: Integer): TdxListItemCustomViewInfo; inline;
    function GetItemCount: Integer; inline;
    function GetItemSize: TSize; inline;
    function GetVisibleItem(Index: Integer): TdxListItemCustomViewInfo; inline;
    function GetVisibleItemCount: Integer; inline;
    procedure SetHotTrackPart(AValue: TdxListGroupHitTest);
  protected
    FColumnCount: Integer;
    FColumnWidths: TdxIntegerList;
    FContentBounds: TRect;
    FContentVisibleBounds: TRect;
    FEmpty: Boolean;
    FItems: TdxFastObjectList;
    FItemsAreaBounds: TRect;
    FVisibleItems: TdxFastList;
    FRowCount: Integer;

    procedure AddVisibleItemViewInfo(AViewInfo: TdxListItemCustomViewInfo);
    procedure AdjustItemBoundsForMakeVisible(AOrderIndex: Integer; var ABounds: TRect);
    procedure CalculateRowAndColumnCount; virtual;
    procedure CalculateContent(AType: TdxChangeType); virtual;
    procedure CalculateContentBounds; virtual;
    procedure CalculateContentVisibleBounds; virtual;
    procedure CalculateItems(AType: TdxChangeType); virtual;
    function CalculateItemViewInfo(AOrderIndex: Integer; const ABounds: TRect): TdxListItemCustomViewInfo; virtual;
    procedure CalculateHorizontallyArrangedIcons(AType: TdxChangeType); virtual;
    procedure CalculateVerticallyArrangedIcons(AType: TdxChangeType); virtual;
    procedure CalculateIconsViewStyle(AType: TdxChangeType); virtual;
    procedure CalculateListViewStyle(AType: TdxChangeType); virtual;
    procedure CalculateReportViewStyle(AType: TdxChangeType); virtual;
    procedure CalculateItemsArea; virtual;
    procedure DoCalculate(AType: TdxChangeType); override;
    procedure DoRightToLeftConversion(const ABounds: TRect); override;
    procedure DrawContent(ACanvas: TcxCustomCanvas); override;
    procedure ExpandButtonClick; virtual;
    function GetAvailableHeightForItems: Integer; virtual;
    function GetAvailableWidthForItems: Integer; virtual;
    function GetBoundsForItem(AOrderIndex: Integer; AMakeVisibleBounds: Boolean = False): TRect; overload;
    function GetFocused: Boolean; virtual;
    function GetHitTestBounds: TRect; override;
    function GetItemOrigin(AOrderIndex: Integer): TPoint;
    function GetItemsHeight(ACount: Integer): Integer;
    function GetItemsWidth(ACount: Integer): Integer;
    function GetVisibleItemsRange(out AFirstOrderIndex, ALastOrderIndex: Integer): Boolean;
    function HasFooter: Boolean; virtual;
    function HasHeader: Boolean; virtual;
    procedure InvalidatePart(APart: TdxListGroupHitTest); virtual;
    function IsFirst: Boolean;
    function IsHorizontalItemsArrangement: Boolean;
    function IsLast: Boolean;
    procedure PopulateItems; virtual; abstract;
    function PrepareVisibleItemsInfo(out AFirstOrderIndex, ALastOrderIndex: Integer): Boolean;
    procedure MouseDown(AButton: TMouseButton; AShift: TShiftState; const AMousePos: TPoint); override;
    procedure MouseLeave; override;
    procedure MouseMove(AShift: TShiftState; const AMousePos: TPoint); override;
    procedure AdjustPositionOnNavigation(AScrollToNext: Boolean); virtual;
    function FindFirstItemByRow(var ARow: Integer; out AOrderIndex: Integer): Boolean;
    function FindLastItemByRow(var ARow: Integer; out AOrderIndex: Integer): Boolean;
    function GetFirstFocusableOrderIndex: Integer;
    function GetLastFocusableOrderIndex: Integer;
    function GetItemPosition(AOrderIndex: Integer; out ARow, AColumn: Integer): Boolean;
    function GetNextItem(var AOrderIndex: Integer; ADirectionX, ADirectionY: Integer): Boolean;
    function ItemIndexToOrderIndex(AItemIndex: Integer): Integer;
    function MakeNextColumnVisible(AScrollToRight: Boolean): Boolean; virtual;
    function OrderIndexToItemIndex(AVisualIndex: Integer): Integer;

    function GetPrev: TdxListGroupCustomViewInfo;
    function GetNext: TdxListGroupCustomViewInfo;

    property ContentVisibleBounds: TRect read FContentVisibleBounds;
    property HotTrackPart: TdxListGroupHitTest read FHotTrackPart write SetHotTrackPart;
    property Index: Integer read FIndex write FIndex;
    property ItemCount: Integer read GetItemCount;
    property Items[Index: Integer]: TdxListItemCustomViewInfo read GetItem;
    property ItemSize: TSize read GetItemSize;
    property Owner: TdxListViewViewInfo read FOwner;
    property VisibleItemCount: Integer read GetVisibleItemCount;
    property VisibleItems[Index: Integer]: TdxListItemCustomViewInfo read GetVisibleItem;
  public
    constructor Create(AOwner: TdxListViewViewInfo; AGroup: TdxListGroup); virtual;
    destructor Destroy; override;
    function GetItemAtPos(const P: TPoint; out AViewInfo: TdxListItemCustomViewInfo): Boolean; overload;
    function GetHitTest(const P: TPoint; out AItemViewInfo: TdxListItemCustomViewInfo): TdxListGroupHitTest; virtual;
    //
    property ColumnCount: Integer read FColumnCount;
    property ContentBounds: TRect read FContentBounds;
    property Empty: Boolean read FEmpty;
    property Group: TdxListGroup read FGroup;
    property Focused: Boolean read GetFocused;
    property ItemsAreaBounds: TRect read FItemsAreaBounds;
    property RowCount: Integer read FRowCount;
  end;

  { TdxListRootGroupViewInfo }

  TdxListRootGroupViewInfo = class(TdxListGroupCustomViewInfo) // for internal use
  protected
    procedure PopulateItems; override;
  end;

  { TdxListGroupTextViewInfo }

  TdxListGroupTextViewInfo = class(TdxListViewCellViewInfo) // for internal use
  strict private
    FKind: TdxListViewGroupTextKind;
    FOwner: TdxListGroupViewInfo;
  protected
    procedure CalculateContentBounds; override;
    function GetTextColor: TColor; override;
    function GetTextFlags: Integer; override;
    function HasGlyph: Boolean; override;
    function HasStateGlyph: Boolean; override;
    property Owner: TdxListGroupViewInfo read FOwner;
  public
    constructor Create(AOwner: TdxListGroupViewInfo; AKind: TdxListViewGroupTextKind; const AViewParams: TdxListViewCellViewParams);

    property Kind: TdxListViewGroupTextKind read FKind;
  end;

  { TdxListGroupHeaderViewInfo }

  TdxListGroupHeaderViewInfo = class(TdxListViewCustomViewInfo) // for internal use
  public const
    GroupHeaderLineHeight = 20;
  strict private
    FExpandButtonBounds: TRect;
    FHeader: TdxListGroupTextViewInfo;
    FHeaderLineBounds: TRect;
    FGlyphBounds: TRect;
    FSubtitle: TdxListGroupTextViewInfo;
    FOwner: TdxListGroupViewInfo;
    function GetExpandButtonState: TcxButtonState; inline;
    function GetGroup: TdxListGroup; inline;
    function GetHeaderParams: TdxListViewCellViewParams; inline;
    function GetHeaderState: TdxListViewGroupHeaderStates; inline;
    function GetSubtitleParams: TdxListViewCellViewParams; inline;
    function GetHeaderTextHeight: Integer;
    function GetSubtitleTextHeight: Integer;
  protected
    FContentBounds: TRect;
    FEmpty: Boolean;
    procedure DrawContent(ACanvas: TcxCustomCanvas); override;
    procedure DoCalculate(AType: TdxChangeType); override;
    procedure DoRightToLeftConversion(const ABounds: TRect); override;
    function ExpandButtonAtLeft: Boolean;
    function GetColorPalette: IdxColorPalette; virtual;
    function GetContentHeight: Integer;
    function GetHeaderHeight: Integer;
    function GetHeaderTextFlags: Integer; virtual;
    function HasExpandButton: Boolean; inline;
    function HasGlyph: Boolean; inline;
    function HasHeader: Boolean; inline;
    function HasSubtitle: Boolean; inline;
    procedure Offset(ADX, ADY: Integer); override;

    property HeaderTextHeight: Integer read GetHeaderTextHeight;
    property SubtitleTextHeight: Integer read GetSubtitleTextHeight;
    property Group: TdxListGroup read GetGroup;
    property Owner: TdxListGroupViewInfo read FOwner;
  public
    constructor Create(AOwner: TdxListGroupViewInfo);
    destructor Destroy; override;
    function GetHeight: Integer;
    property Empty: Boolean read FEmpty;
    property ExpandButtonBounds: TRect read FExpandButtonBounds;
    property ExpandButtonState: TcxButtonState read GetExpandButtonState;
    property GlyphBounds: TRect read FGlyphBounds;
    property Header: TdxListGroupTextViewInfo read FHeader;
    property HeaderLineBounds: TRect read FHeaderLineBounds;
    property HeaderState: TdxListViewGroupHeaderStates read GetHeaderState;
    property HeaderParams: TdxListViewCellViewParams read GetHeaderParams;
    property Subtitle: TdxListGroupTextViewInfo read FSubtitle;
    property SubtitleParams: TdxListViewCellViewParams read GetSubtitleParams;
  end;

  { TdxListGroupViewInfo }

  TdxListGroupViewInfo = class(TdxListGroupCustomViewInfo) // for internal use
  strict private
    FExpandButtonState: TcxButtonState;
    FHeaderState: TdxListViewGroupHeaderStates;
    function GetCollapsed: Boolean; inline;
    function GetContentPadding: TdxPadding; inline;
    function GetHotTracked: Boolean; inline;
    function GetFooterHeight: Integer; inline;
    function GetFooterParams: TdxListViewCellViewParams; inline;
    function GetHeaderHeight: Integer;
  protected
    FHeader: TdxListGroupHeaderViewInfo;
    FFooter: TdxListGroupTextViewInfo;
    FFooterBounds: TRect;
    FSubtitleBounds: TRect;
    procedure BeforeDraw(ACanvas: TcxCustomCanvas); override;
    procedure CalculateContent(AType: TdxChangeType); override;
    function CalculateContentBottom: Integer;
    procedure CalculateContentBounds; override;
    function CalculateContentRight: Integer;
    procedure CalculateFooter(AType: TdxChangeType); virtual;
    procedure CalculateHeader(AType: TdxChangeType); virtual;
    function CalculateHeaderWidth: Integer;
    procedure CalculateItemsArea; override;
    procedure CalculateRowAndColumnCount; override;
    procedure DoRightToLeftConversion(const ABounds: TRect); override;
    procedure DrawContent(ACanvas: TcxCustomCanvas); override;
    procedure ExpandButtonClick; override;
    function HasFooter: Boolean; override;
    function HasHeader: Boolean; override;
    function GetAvailableHeightForItems: Integer; override;
    function GetAvailableWidthForItems: Integer; override;
    function GetExpandButtonState: TcxButtonState; virtual;
    function GetFocused: Boolean; override;
    function GetFooterTextFlags: Integer; virtual;
    function GetHeaderBounds: TRect;
    function GetHeaderState: TdxListViewGroupHeaderStates; virtual;
    procedure InvalidatePart(APart: TdxListGroupHitTest); override;
    procedure PopulateItems; override;
    procedure MouseLeave; override;
    procedure AdjustPositionOnNavigation(AScrollToNext: Boolean); override;
    function MakeNextColumnVisible(AScrollToRight: Boolean): Boolean; override;

    property ContentPadding: TdxPadding read GetContentPadding;
    property HeaderHeight: Integer read GetHeaderHeight;
    property FooterHeight: Integer read GetFooterHeight;
    property FooterParams: TdxListViewCellViewParams read GetFooterParams;
  public
    destructor Destroy; override;
    function GetHitTest(const P: TPoint; out AItemViewInfo: TdxListItemCustomViewInfo): TdxListGroupHitTest; override;
    procedure Invalidate; override;
    //
    property Collapsed: Boolean read GetCollapsed;
    property ExpandButtonState: TcxButtonState read FExpandButtonState;
    property Header: TdxListGroupHeaderViewInfo read FHeader;
    property HeaderState: TdxListViewGroupHeaderStates read FHeaderState;
    property HotTracked: Boolean read GetHotTracked;
    property Footer: TdxListGroupTextViewInfo read FFooter;
    property FooterBounds: TRect read FFooterBounds;
  end;

 { TdxListColumnHeaderViewInfo }

  TdxListColumnHeaderHitTest = (None, Content, FilterButton, CheckBox); // for internal use

  TdxListColumnHeaderViewInfo = class(TdxListViewCellViewInfo) // for internal use
  strict private
    FOwner: TdxListViewColumnHeadersViewInfo;
    FCheckBoxState: TcxButtonState;
    FColumn: TdxListColumn;
    FChecked: Boolean;
    FHasCheckBox: Boolean;
    FHottrackPart: TdxListColumnHeaderHitTest;
    FNeighbors: TcxNeighbors;
    FState: TcxButtonState;
    procedure SetHottrackPart(AValue: TdxListColumnHeaderHitTest);
  protected
    FCheckBoxBounds: TRect;
    FSortArrowBounds: TRect;
    procedure AfterDraw(ACanvas: TcxCustomCanvas); override;
    procedure BeforeDraw(ACanvas: TcxCustomCanvas); override;
    procedure CalculateCheckBoxBounds; virtual;
    procedure CalculateGlyphsAreaBounds; override;
    procedure CalculateContentBounds; override;
    procedure CalculateTextAndGlyphLayout; override;
    procedure DoRightToLeftConversion(const ABounds: TRect); override;
    procedure DrawCheckBox(ACanvas: TcxCustomCanvas); virtual;
    procedure DrawContent(ACanvas: TcxCustomCanvas); override;
    function GetBestFitWidth: Integer;
    function GetCheckBoxState: TcxButtonState; virtual;
    function GetColorPalette: IdxColorPalette; override;
    function GetHitTest(const AMousePos: TPoint): TdxListColumnHeaderHitTest; virtual;
    function GetState: TcxButtonState; virtual;
    function GetTextColor: TColor; override;
    function GetTextFlags: Integer; override;
    function HasGlyph: Boolean; override;
    function HasStateGlyph: Boolean; override;
    function IsCheckBoxVisible: Boolean; virtual;
    function GetHintFont: TFont; override;
    function GetHintText: string; override;
    function NeedShowHint: Boolean; override;

    procedure Offset(ADX, ADY: Integer); override;
    procedure ResetBounds; override;
    function CanStartDrag(const AMousePos: TPoint): Boolean; virtual;
    procedure MouseDown(AButton: TMouseButton; AShift: TShiftState; const AMousePos: TPoint); override;
    procedure MouseLeave; override;
    procedure MouseMove(AShift: TShiftState; const AMousePos: TPoint); override;

    property HottrackPart: TdxListColumnHeaderHitTest read FHottrackPart write SetHottrackPart;
    property Owner: TdxListViewColumnHeadersViewInfo read FOwner;
  public
    constructor Create(AOwner: TdxListViewColumnHeadersViewInfo; AColumn: TdxListColumn; const AViewParams: TdxListViewCellViewParams);

    property CheckBoxBounds: TRect read FCheckBoxBounds;
    property CheckBoxState: TcxButtonState read FCheckBoxState;
    property Checked: Boolean read FChecked;
    property Column: TdxListColumn read FColumn;
    property HasCheckBox: Boolean read FHasCheckBox;
    property Neighbors: TcxNeighbors read FNeighbors;
    property SortArrowBounds: TRect read FSortArrowBounds;
    property State: TcxButtonState read FState;
  end;

  { TdxListViewColumnHeadersViewInfo}

  TdxListViewColumnHeadersViewInfo = class(TdxListViewCustomViewInfo) // for internal use
  strict private
    FHottrackItem: TdxListColumnHeaderViewInfo;
    FItems: TdxFastObjectList;
    FOwner: TdxListViewViewInfo;
    FResizeHitTestWidth: Integer;
    FSortArrowSize: TPoint;
    FViewParams: TdxListViewCellViewParams;
    function GetItem(Index: Integer): TdxListColumnHeaderViewInfo;
    function GetItemCount: Integer;
    procedure SetHottrackItem(AValue: TdxListColumnHeaderViewInfo);
  protected
    function CalculateHeight: Integer; virtual;
    function CalculateHeaderBestFitWidth(AColumn: TdxListColumn): Integer;
    procedure CalculateViewParams; virtual;
    procedure DoCalculate(AType: TdxChangeType); override;
    procedure DoRightToLeftConversion(const ABounds: TRect); override;
    procedure DrawContent(ACanvas: TcxCustomCanvas); override;
    function FindDragItem(const AMousePos: TPoint): TdxListColumnHeaderViewInfo;
    function FindItem(const AMousePos: TPoint): TdxListColumnHeaderViewInfo;
    function GetCursor(const AMousePos: TPoint): TCursor; virtual;
    function GetDesignHitTest(const P: TPoint): Boolean; virtual;
    function GetHitTestBounds: TRect; override;
    function GetResizingColumn(const AMousePos: TPoint): TdxListColumn; virtual;
    procedure MouseDown(AButton: TMouseButton; AShift: TShiftState; const AMousePos: TPoint); override;
    procedure MouseLeave; override;
    procedure MouseMove(AShift: TShiftState; const AMousePos: TPoint); override;

    property HottrackItem: TdxListColumnHeaderViewInfo read FHottrackItem write SetHottrackItem;
    property Owner: TdxListViewViewInfo read FOwner;
    property SortArrowSize: TPoint read FSortArrowSize;
  public
    constructor Create(AOwner: TdxListViewViewInfo); reintroduce; virtual;
    destructor Destroy; override;
    procedure PopulateItems;
    property ItemCount: Integer read GetItemCount;
    property Items[Index: Integer]: TdxListColumnHeaderViewInfo read GetItem; default;
    property ViewParams: TdxListViewCellViewParams read FViewParams;
  end;

  { TdxListViewViewInfo }

  TdxListViewViewInfo = class(TdxListViewCustomViewInfo) // for internal use
  strict private
    FColumnHeadersViewInfo: TdxListViewColumnHeadersViewInfo;
    FItems: TDictionary<Integer, TdxListItemCustomViewInfo>;
    FItemViewParams: TdxListViewCellViewParams;
    FGroupHeaderViewParams: TdxListViewCellViewParams;
    FGroupFooterViewParams: TdxListViewCellViewParams;
    FGroupSubtitleViewParams: TdxListViewCellViewParams;
    function GetContentOffset: TRect; inline;
    function GetItemCount: Integer; inline;
    function GetGroup(Index: Integer): TdxListGroupCustomViewInfo; inline;
    function GetGroupCount: Integer; inline;
  protected
    FColumnHeadersWidth: Integer;
    FContentBounds: TRect;
    FEmptyTextLayout: TcxCanvasBasedTextLayout;
    FGroupColumnCount: Integer;
    FGroupContentPadding: TdxPadding;
    FGroupFooterHeight: Integer;
    FGroupHeaderTextHeight: Integer;
    FGroupRowCount: Integer;
    FGroups: TdxFastObjectList;
    FGroupHeaderSubtitleTextHeight: Integer;
    FItemSize: TSize;
    FTextAreaSize: TSize;
    function AreGroupsVertical: Boolean;
    procedure CalculateContent(AType: TdxChangeType); virtual;
    procedure CalculateContentBounds; virtual;
    procedure CalculateCommonParameters; virtual;
    function CalculateColumnHeaderGlyphsAreaSize: TSize; virtual;
    procedure CalculateColumnHeaders(AType: TdxChangeType; out AHeaderHeight: Integer); virtual;
    procedure CalculateColumnHeadersWidth;
    procedure CalculateEmptyText;
    procedure CalculateItemSize; virtual;
    function CalculateImagesGlyphSize(AImages: TCustomImageList): TSize; virtual;
    function CalculateItemStateGlyphSize: TSize; virtual;
    function CalculateItemTextSize: TSize; virtual;
    function CalculateItemGlyphsAreaSize: TSize; virtual;
    function GetDefaultItemGlyphIndent: TSize; virtual;
    function GetIconsGlyphSideGap: Integer; virtual;
    function GetItemBoundsForMakeVisible(AItemIndex: Integer): TRect;
    function GetItemStateViewKind: TdxListItemStateViewKind;
    function GetScrollArea: TRect;
    function GetGroupVisibleBounds: TRect;
    function IsOverlappedItemStateGlyph: Boolean;

    procedure CalculateCommonViewParams(AViewParams: TdxListViewCellViewParams;
      APadding: TdxPadding; AFont: TFont; AImages: TCustomImageList); virtual;
    procedure CalculateItemViewParams(AViewParams: TdxListViewCellViewParams); virtual;
    procedure CalculateGroupCommonViewParams(AViewParams: TdxListViewCellViewParams;
      AFont: TFont; AImages: TCustomImageList; AUsePainterPadding: Boolean); virtual;
    procedure CalculateGroupHeaderViewParams(AViewParams: TdxListViewCellViewParams); virtual;
    procedure CalculateGroupFooterViewParams(AViewParams: TdxListViewCellViewParams); virtual;
    procedure CalculateGroupSubtitleViewParams(AViewParams: TdxListViewCellViewParams); virtual;
    procedure CalculateGroupHeaderSizes; virtual;
    procedure CalculateGroupViewParams; virtual;
    procedure CalculateViewParams; virtual;

    function CreateGroupViewInfo(AGroup: TdxListGroup): TdxListGroupViewInfo; virtual;
    function CreateItemViewInfo(AOwner: TdxListGroupCustomViewInfo; AItemIndex: Integer): TdxListItemCustomViewInfo; virtual;
    procedure DoCalculate(AType: TdxChangeType); override;
    procedure DoRightToLeftConversion(const ABounds: TRect); override;
    procedure DrawContent(ACanvas: TcxCustomCanvas); override;
    function FindColumn(const APosition: TPoint): TdxListColumn;
    function FindDragColumnHeaderViewInfo(const APosition: TPoint): TdxListColumnHeaderViewInfo;
    function FindColumnHeaderViewInfo(const APosition: TPoint): TdxListColumnHeaderViewInfo;
    function GetAvailableGroupsAreaHeight: Integer; virtual;
    function GetAvailableGroupsAreaWidth: Integer; virtual;
    function GetBorderWidths: TRect; virtual;
    function GetBoundsForItem(AItem: TdxListItem): TRect; overload;
    function GetBoundsForItem(AItemIndex: Integer): TRect; overload;
    function GetDesignHitTest(const P: TPoint): Boolean; virtual;
    function GetItemGlyphImages: TCustomImageList; virtual;
    function GetItemsOffset: TSize;
    function GetItemTextLineCount: Integer; virtual;
    function GetItemTextFlags: Integer; virtual;
    function GetItemTextPosition: TcxPosition; virtual;
    function IsPointAtColumnHeaders(const P: TPoint): Boolean;
    procedure RecreateSubItems; virtual;
    procedure ValidateColumnHeadersViewInfo;

    function CanStartMultiSelectionByMouse(const AMousePos: TPoint): Boolean; virtual;
    procedure MouseLeave; override;
    procedure MouseMove(AShift: TShiftState; const AMousePos: TPoint); override;

    procedure AdjustGroupPositionOnNavigation(AGroup: TdxListGroup; AScrollToNext: Boolean);
    function ScrollGroupHorizontally(AGroup: TdxListGroup; AScrollToRight: Boolean): Boolean;

    procedure CalculateColumnBestFitParams(AColumn: TdxListColumn; var ACheckState, ACheckGlyph: Boolean; out AExtraWidth: Integer); virtual;
    function CalculateColumnValueWidth(AItem: TdxListItem; ASubIndex: Integer; ACheckState, ACheckGlyph: Boolean): Integer; virtual;
    function CalculateColumnHeaderBestFitWidth(AColumn: TdxListColumn): Integer; virtual;
    function CalculateColumnBestFitWidth(AColumn: TdxListColumn; AVisibleItemsOnly: Boolean = False): Integer; virtual;

    property ItemCount: Integer read GetItemCount;
    property Items: TDictionary<Integer, TdxListItemCustomViewInfo> read FItems;

    property ContentOffset: TRect read GetContentOffset;
    property ColumnHeadersViewInfo: TdxListViewColumnHeadersViewInfo read FColumnHeadersViewInfo;
    property GroupContentPadding: TdxPadding read FGroupContentPadding;
    property GroupHeaderTextHeight: Integer read FGroupHeaderTextHeight;
    property GroupHeaderViewParams: TdxListViewCellViewParams read FGroupHeaderViewParams;
    property GroupFooterHeight: Integer read FGroupFooterHeight;
    property GroupFooterViewParams: TdxListViewCellViewParams read FGroupFooterViewParams;
    property GroupHeaderSubtitleTextHeight: Integer read FGroupHeaderSubtitleTextHeight;
    property GroupSubtitleViewParams: TdxListViewCellViewParams read FGroupSubtitleViewParams;
    property ItemViewParams: TdxListViewCellViewParams read FItemViewParams;
  public
    constructor Create(AListView: TdxCustomListView); virtual;
    destructor Destroy; override;
    function FindGroupViewInfo(AGroup: TdxListGroup; out AViewInfo: TdxListGroupCustomViewInfo): Boolean; overload;
    function FindGroupViewInfo(AItem: TdxListItem; out AViewInfo: TdxListGroupCustomViewInfo): Boolean; overload;
    function FindGroupViewInfo(AItemIndex: Integer; out AViewInfo: TdxListGroupCustomViewInfo; out AIndexInGroup: Integer): Boolean; overload;
    function FindGroupViewInfo(AItemIndex: Integer; out AViewInfo: TdxListGroupCustomViewInfo): Boolean; overload;
    function FindItemViewInfo(AItemIndex: Integer; out AViewInfo: TdxListItemCustomViewInfo): Boolean; overload;
    function GetGroupAtPos(const P: TPoint; out AViewInfo: TdxListGroupCustomViewInfo): Boolean; overload;
    function GetItemAtPos(const P: TPoint; out AViewInfo: TdxListItemCustomViewInfo): Boolean; overload;
    procedure InvalidateItem(AItemIndex: Integer);
    //
    property BorderWidths: TRect read GetBorderWidths;
    property GroupColumnCount: Integer read FGroupColumnCount;
    property ContentBounds: TRect read FContentBounds;
    property GroupCount: Integer read GetGroupCount;
    property Groups[Index: Integer]: TdxListGroupCustomViewInfo read GetGroup;
    property ItemSize: TSize read FItemSize;
    property GroupRowCount: Integer read FGroupRowCount;
    property TextAreaSize: TSize read FTextAreaSize;
  end;

  { TdxListViewDragAndDropObject }

  TdxListViewDragAndDropObject = class(TcxDragAndDropObject) // for internal use
  strict private
    FAutoScrollHelper: TdxAutoScrollHelper;
    function GetController: TdxListViewController;
    function GetListView: TdxCustomListView;
    function GetViewInfo: TdxListViewViewInfo;
  protected
    FParams: TObject;
    procedure AfterPaint; virtual;
    procedure BeforePaint; virtual;
    function CreateAutoScrollHelper: TdxAutoScrollHelper; virtual;
    procedure BeginDragAndDrop; override;
    procedure DragAndDrop(const P: TPoint; var Accepted: Boolean); override;
    procedure EndDragAndDrop(Accepted: Boolean); override;
    function GetDragAndDropCursor(Accepted: Boolean): TCursor; override;
  public
    SourcePoint: TPoint;
    procedure AfterScrolling; virtual;
    procedure BeforeScrolling; virtual;
    procedure Init(const P: TPoint; AParams: TObject); virtual;

    property AutoScrollHelper: TdxAutoScrollHelper read FAutoScrollHelper;
    property Controller: TdxListViewController read GetController;
    property ListView: TdxCustomListView read GetListView;
    property ViewInfo: TdxListViewViewInfo read GetViewInfo;
  end;
  TdxListViewDragAndDropObjectClass = class of TdxListViewDragAndDropObject;

  { TdxListViewDragSelectDragAndDropObject }

  TdxListViewDragSelectDragAndDropObject = class(TdxListViewDragAndDropObject) // for internal use
  strict private
    FAnchor: TPoint;
    FExtendedMode: Boolean;
    FFinishPos: TPoint;
    FStartPos: TPoint;
    procedure UpdateAnchor;
  protected
    procedure BeginDragAndDrop; override;
    function CreateAutoScrollHelper: TdxAutoScrollHelper; override;
    procedure DragAndDrop(const P: TPoint; var Accepted: Boolean); override;
    procedure EndDragAndDrop(Accepted: Boolean); override;
    function ProcessKeyDown(AKey: Word; AShiftState: TShiftState): Boolean; override;
    function ProcessKeyUp(AKey: Word; AShiftState: TShiftState): Boolean; override;
  public
    property FinishPos: TPoint read FFinishPos;
    property StartPos: TPoint read FStartPos;
  end;

  { TdxListViewColumnHeaderDragAndDropObject }

  TdxListViewColumnHeaderDragAndDropObject = class(TdxListViewDragAndDropObject) // for internal use
  protected type
    TArrowNumber = (First, Last);
    TDestinationInfo = record
      Index: Integer;
      Accepted: Boolean;
    end;
  strict private
    FCenterPoint: TPoint;
    FColumn: TdxListColumn;
    FDestinationInfo: TDestinationInfo;
    FDragImage: TcxDragImage;
    FHeaderBounds: TRect;
    function GetArrowPlace(AArrowNumber: TArrowNumber): TcxArrowPlace;
    function GetHeader: TdxListColumnHeaderViewInfo; inline;
    function HasArrows: Boolean;
    procedure SetDestinationInfo(const Value: TDestinationInfo);
    function GetHeadersViewInfo: TdxListViewColumnHeadersViewInfo; inline;
  protected
    Arrows: array[TArrowNumber] of TcxDragAndDropArrow;
    function CalculateDestinationInfo(const P: TPoint): TDestinationInfo;
    procedure ChangeArrowsPosition(AVisible: Boolean = True);
    procedure ChangeDragImagePosition(AVisible: Boolean = True);
    function CreateAutoScrollHelper: TdxAutoScrollHelper; override;
    procedure DirtyChanged; override;

    function AreArrowsVertical: Boolean; virtual;
    function CanRemove: Boolean; virtual;
    function GetArrowAreaBounds(APlace: TcxArrowPlace): TRect; virtual;
    function GetArrowClass: TcxDragAndDropArrowClass; virtual;
    function GetArrowsClientRect: TRect; virtual;
    function GetDragAndDropCursor(Accepted: Boolean): TCursor; override;
    function GetDragImageClass: TcxDragImageClass; virtual;
    procedure InitDragImage(const ABounds: TRect; ACanvas: TcxCanvas); virtual;
    procedure InitDragObjects; virtual;
    function IsValidDestination: Boolean; virtual;
    function TranslateCoords(const P: TPoint): TPoint; override;

    procedure BeginDragAndDrop; override;
    procedure DragAndDrop(const P: TPoint; var Accepted: Boolean); override;
    procedure EndDragAndDrop(Accepted: Boolean); override;

    property ArrowPlaces[AArrowNumber: TArrowNumber]: TcxArrowPlace read GetArrowPlace;
    property ArrowsClientRect: TRect read GetArrowsClientRect;
    property Column: TdxListColumn read FColumn;
    property DestinationInfo: TDestinationInfo read FDestinationInfo write SetDestinationInfo;
    property DragImage: TcxDragImage read FDragImage;
    property Header: TdxListColumnHeaderViewInfo read GetHeader;
    property HeaderBounds: TRect read FHeaderBounds;
    property HeadersViewInfo: TdxListViewColumnHeadersViewInfo read GetHeadersViewInfo;
  public
    procedure AfterScrolling; override;
  end;

  { TdxListViewDragObject }

  TdxListViewDragObject = class(TcxDragControlObject) // for internal use
  strict private
    FAutoScrollHelper: TdxAutoScrollHelper;
    function GetListView: TdxCustomListView;
  protected
    function CreateAutoScrollHelper: TdxAutoScrollHelper; virtual;
    function GetDragCursor(Accepted: Boolean; X, Y: Integer): TCursor; override;
  public
    constructor Create(AControl: TControl); override;
    destructor Destroy; override;

    property AutoScrollHelper: TdxAutoScrollHelper read FAutoScrollHelper;
    property ListView: TdxCustomListView read GetListView;
  end;

  { TdxListViewController }

  TdxListViewController = class(TdxListViewPersistent) // for internal use
  protected type
    TSelectAnchorInfo = record
    public
      GroupID: Integer;
      ItemIndex: Integer;
      constructor Create(AGroupID, AItemIndex: Integer);
      function IsNull: Boolean;
      procedure Reset;
    end;
  strict private
    FCheckSelectAllOnMouseUp: Boolean;
    FColumnResizeMouseDownPos: TPoint;
    FDragCopy: Boolean;
    FDragItemIndex: Integer;
    FEditingItemIndex: Integer;
    FEditWasClosed: Boolean;
    FFocusedGroup: TdxListGroup;
    FFocusedItemIndex: Integer;
    FForceVisibleItemIndex: Integer;
    FIsPressedItemSelected: Boolean;
    FMouseHoveredGroup: TdxListGroup;
    FMouseHoveredItemIndex: Integer;
    FMousePressed: Boolean;
    FOriginalResizingColumnWidth: Integer;
    FPressedColumn: TdxListColumn;
    FPressedItemIndex: Integer;
    FResizingColumn: TdxListColumn;
    FSelectAnchor: TSelectAnchorInfo;
    FSelectionChangedCount: Integer;
    FSelectedIndices: TdxIntegerList;
    FSelectGroupItemsTimer: TcxTimer;
    FSelectionChangedFlag: Boolean;
    FUpdateItemsSelectionOnMouseUp: Boolean;
    procedure FinishSelectGroupItemsTimer;
    function GetExplorerStyle: Boolean;
    function GetViewInfo: TdxListViewViewInfo; inline;
    procedure OnSelectGroupItemsTimer(Sender: TObject);
    procedure SetFocusedGroup(AValue: TdxListGroup);
    procedure SetFocusedItemIndex(AItemIndex: Integer);
    procedure SetMouseHoveredGroup(AValue: TdxListGroup);
    procedure SetMouseHoveredItemIndex(AItemIndex: Integer);
    procedure SetMousePressed(AValue: Boolean);
    procedure SetPressedColumn(AValue: TdxListColumn);
    procedure StartSelectGroupItemsTimer;
  protected
    FSelectItemsGroup: TdxListGroup;
    procedure CancelEdit;
    function CanSelectColumnInDesigner: Boolean; virtual;
    procedure FinishEditingTimer;
    function CheckStartEditingOnMouseUp(AItemViewInfo: TdxListItemCustomViewInfo; AButton: TMouseButton;
      AShift: TShiftState; const AMousePos: TPoint): Boolean; virtual;
    procedure CheckVisibleItem;

    procedure InvalidateItem(AItem: TdxListItem); overload;
    function IsGroupView: Boolean;
    procedure MakeItemVisible(AItemIndex: Integer; AVisibleType: TdxVisibilityType;
      ACheckHorizontalPosition, ACheckVerticalPosition: Boolean); overload; virtual;
    procedure MakeItemVisible(AItem: TdxListItem; AVisibleType: TdxVisibilityType); overload;
    procedure MakeItemVisible(AItemIndex: Integer; AVisibleType: TdxVisibilityType); overload;
    procedure RemoveContentHottrack(ACancelHint: Boolean = True); virtual;
    procedure ResetContent; virtual;
    procedure SetFocusedItemIndexCore(AItemIndex: Integer; AVisibleType: TdxVisibilityType;
      ACheckHorizontalPosition, ACheckVerticalPosition: Boolean); virtual;

    procedure AfterKeyDown(AKey: Word; AShift: TShiftState); virtual;
    procedure AfterMouseDown(AButton: TMouseButton; AShift: TShiftState; const AMousePos: TPoint); virtual;
    procedure BeforeKeyDown(AKey: Word; AShift: TShiftState); virtual;
    procedure BeforeMouseDown(AButton: TMouseButton; AShift: TShiftState; const AMousePos: TPoint); virtual;
    function GetDesignHitTest(const P: TPoint): Boolean; virtual;
    function ProcessColumnHeadersMouseDown(AButton: TMouseButton;
      AShift: TShiftState; const AMousePos: TPoint): Boolean; virtual;
    procedure ProcessColumnHeadersMouseUp(AButton: TMouseButton;
      AShift: TShiftState; const AMousePos: TPoint); virtual;
    procedure ProcessColumnResize(const AMousePos: TPoint);
    procedure ProcessItemMouseDown(AItemViewInfo: TdxListItemCustomViewInfo; AButton: TMouseButton;
      AShift: TShiftState; const AMousePos: TPoint); virtual;

    procedure UpdateColumnHeadersViewState;
    procedure UpdateGroupViewState(AGroup: TdxListGroup; AMakeHeaderVisible: Boolean = False);
    procedure UpdateItemViewState(AItemIndex: Integer);
    procedure UpdateMouseHottrack(const AMousePos: TPoint); overload; inline;
    procedure UpdateMouseHottrack; overload;

    // ListView selection
    procedure DeleteItem(AIndex: Integer);
    procedure InsertItem(AIndex: Integer);

    procedure AddSelection(ASelection: TdxIntegerList);
    function AreAllItemsSelected: Boolean;
    procedure ClearSelection(AItemIndexToExclude: Integer = -1);
    procedure DeselectItems(const ANewAnchor: TSelectAnchorInfo);
    function GetFirstFocusableItemInGroup(AGroup: TdxListGroup): Integer;
    function GetLastFocusableItemInGroup(AGroup: TdxListGroup): Integer;
    function GetItems(const ANewAnchor: TSelectAnchorInfo): TdxIntegerList; overload;
    procedure GetItems(const AAnchor1, AAnchor2: TSelectAnchorInfo; AItems: TdxIntegerList); overload;
    procedure GetItems(AGroup: TdxListGroup; AItemIndex: Integer; ADown: Boolean; AItems: TdxIntegerList); overload;
    function IsItemSelected(AItemIndex: Integer): Boolean;
    function MultiSelect: Boolean;
    function NeedToRestoreSingleItemSelection(AShift: TShiftState): Boolean; virtual;
    procedure ReplaceSelection(ASelection: TdxIntegerList);
    procedure ResetSelection;
    procedure SelectAll;
    procedure SelectFirstAvailableItemInGroup(AGroup: TdxListGroup);
    procedure SelectGroupItems(AGroup: TdxListGroup; AReplaceSelection: Boolean);
    procedure SelectItem(AItemIndex: Integer; ASelect: Boolean; AProcessOnChangingEvent: Boolean = True); virtual;
    procedure SelectItems(AStartIndex, AFinishIndex: Integer); overload; virtual;
    procedure SelectItems(const ANewAnchor: TSelectAnchorInfo; AReplaceSelection: Boolean = True); overload;
    procedure SelectSingleItem(AItemIndex: Integer; AProcessOnChangingEvent: Boolean = True); virtual;
    procedure BeginSelectionChanged;
    procedure EndSelectionChanged;

    // Navigation
    function CanGroupChangeCollapsedState(AGroup: TdxListGroup): Boolean;
    function CanNavigateGroupItems(AGroup: TdxListGroup): Boolean;
    function GetGroupViewInfo(AItemIndex: Integer): TdxListGroupCustomViewInfo;
    procedure GotoItemIndex(AItemIndex: Integer; AShift: TShiftState; AProcessOnChangingEvent: Boolean = True);
    procedure GotoFirstFocusableItem(AShift: TShiftState);
    procedure GotoLastFocusableItem(AShift: TShiftState);
    function GetStartItemIndexForKeyboardNavigation: Integer; virtual;
    procedure SelectNextItem(ADirectionX, ADirectionY: Integer; AShift: TShiftState); overload; virtual;
    procedure ShowPriorPage(AShift: TShiftState);
    procedure ShowNextPage(AShift: TShiftState);

    // drag and drop
    procedure CalculateDragAndDropInfo(const AMousePos: TPoint;
      out AClass: TdxListViewDragAndDropObjectClass; out AParams: TObject); virtual;
    function CanDrag(const AMousePos: TPoint): Boolean; virtual;
    procedure EndDragAndDrop(Accepted: Boolean); virtual;
    function StartDragAndDrop(const P: TPoint): Boolean; virtual;

    property CheckSelectAllOnMouseUp: Boolean read FCheckSelectAllOnMouseUp write FCheckSelectAllOnMouseUp;
    property EditingItemIndex: Integer read FEditingItemIndex;
    property ExplorerStyle: Boolean read GetExplorerStyle;
    property PressedColumn: TdxListColumn read FPressedColumn write SetPressedColumn;
    property ResizingColumn: TdxListColumn read FResizingColumn;
    property SelectedIndices: TdxIntegerList read FSelectedIndices;
  public
    constructor Create(AOwner: TdxCustomListView); override;
    destructor Destroy; override;

    // Keyboard
    procedure FocusEnter; virtual;
    procedure FocusLeave; virtual;
    procedure KeyDown(AKey: Word; AShift: TShiftState); virtual;
    procedure KeyUp(AKey: Word; AShift: TShiftState); virtual;
    // Mouse
    procedure CancelMode; virtual;
    procedure Click; virtual;
    procedure DblClick; virtual;
    function GetCursor(const AMousePos: TPoint): TCursor; virtual;
    procedure MouseDown(AButton: TMouseButton; AShift: TShiftState; const AMousePos: TPoint); virtual;
    procedure MouseLeave; virtual;
    procedure MouseMove(AShift: TShiftState; const AMousePos: TPoint); virtual;
    procedure MouseUp(AButton: TMouseButton; AShift: TShiftState; const AMousePos: TPoint); virtual;
    // Drag-n-Drop
    procedure DragEnter; virtual;
    procedure DragLeave; virtual;
    procedure DragDrop(Source: TObject; X, Y: Integer); virtual;
    procedure DragOver(ASource: TObject; const AMousePos: TPoint; var AAccept: Boolean); virtual;
    //
    property DragCopy: Boolean read FDragCopy write FDragCopy;
    property FocusedItemIndex: Integer read FFocusedItemIndex write SetFocusedItemIndex;
    property FocusedGroup: TdxListGroup read FFocusedGroup write SetFocusedGroup;
    property MouseHoveredGroup: TdxListGroup read FMouseHoveredGroup write SetMouseHoveredGroup;
    property MouseHoveredItemIndex: Integer read FMouseHoveredItemIndex write SetMouseHoveredItemIndex;
    property MousePressed: Boolean read FMousePressed write SetMousePressed;
    property ViewInfo: TdxListViewViewInfo read GetViewInfo;
  end;

  { TdxListViewCustomOptions }

  TdxListViewCustomOptions = class(TdxListViewPersistent)
  protected
    procedure Changed(AType: TdxChangeType = ctHard);
    procedure ChangeScale(M, D: Integer); virtual;
    function NeedNotifyControl: Boolean; virtual;
  end;

  { TdxListViewIconOptions }

  TdxListIconsArrangement = (Horizontal, Vertical);

  TdxListViewIconOptions = class(TdxListViewCustomOptions)
  public const
    MaxTextLineCount = 8;
    MaxGapBetweenItems = 48;
  strict private
    FArrangement: TdxListIconsArrangement;
    FAutoArrange: Boolean;
    FGapBetweenItems: Integer;
    FTextLineCount: Integer;
    procedure SetArrangement(AValue: TdxListIconsArrangement);
    procedure SetAutoArrange(AValue: Boolean);
    procedure SetTextLineCount(AValue: Integer);
    procedure SetGapBetweenItems(AValue: Integer);
  protected
    procedure ChangeScale(M: Integer; D: Integer); override;
    procedure DoAssign(Source: TPersistent); override;

    property AutoArrange: Boolean read FAutoArrange write SetAutoArrange default True;
  public
    constructor Create(AOwner: TdxCustomListView); override;
  published
    property Arrangement: TdxListIconsArrangement read FArrangement write SetArrangement default TdxListIconsArrangement.Horizontal;
    property GapBetweenItems: Integer read FGapBetweenItems write SetGapBetweenItems default 1;
    property TextLineCount: Integer read FTextLineCount write SetTextLineCount default 2;
  end;

  { TdxListViewListOptions }

  TdxListViewListOptions = class(TdxListViewCustomOptions)
  public const
    DefaultColumnWidth = 300;
    MinColumnWidth = 32;
    MaxGapBetweenItems = 48;
  strict private
    FColumnWidth: Integer;
    FGapBetweenItems: Integer;
    procedure SetColumnWidth(AValue: Integer);
    procedure SetGapBetweenItems(AValue: Integer);
  protected
    procedure ChangeScale(M: Integer; D: Integer); override;
    procedure DoAssign(Source: TPersistent); override;
    function NeedNotifyControl: Boolean; override;
  public
    constructor Create(AOwner: TdxCustomListView); override;
  published
    property ColumnWidth: Integer read FColumnWidth write SetColumnWidth default DefaultColumnWidth;
    property GapBetweenItems: Integer read FGapBetweenItems write SetGapBetweenItems default 1;
  end;

  { TdxListViewReportOptions }

  TdxListViewReportOptions = class(TdxListViewCustomOptions)
  strict private
    FAlwaysShowItemImageInFirstColumn: Boolean;
    FRowSelect: Boolean;
    FShowColumnHeaders: Boolean;
    procedure SetAlwaysShowItemImageInFirstColumn(AValue: Boolean);
    procedure SetRowSelect(AValue: Boolean);
    procedure SetShowColumnHeaders(AValue: Boolean);
  protected
    procedure DoAssign(Source: TPersistent); override;
    function IsAlwaysShowItemImageInFirstColumnStored: Boolean; virtual;
    function IsRowSelectStored: Boolean; virtual;
    function NeedNotifyControl: Boolean; override;
  public
    constructor Create(AOwner: TdxCustomListView); override;
  published
    property AlwaysShowItemImageInFirstColumn: Boolean read FAlwaysShowItemImageInFirstColumn write SetAlwaysShowItemImageInFirstColumn stored IsAlwaysShowItemImageInFirstColumnStored;
    property RowSelect: Boolean read FRowSelect write SetRowSelect stored IsRowSelectStored;
    property ShowColumnHeaders: Boolean read FShowColumnHeaders write SetShowColumnHeaders default True;
  end;

  { TdxListViewSmallIconOptions }

  TdxListViewSmallIconOptions = class(TdxListViewCustomOptions)
  public const
    DefaultColumnWidth = 100;
    MinColumnWidth = 32;
  strict private
    FArrangement: TdxListIconsArrangement;
    FColumnWidth: Integer;
    procedure SetArrangement(AValue: TdxListIconsArrangement);
    procedure SetColumnWidth(AValue: Integer);
  protected
    procedure ChangeScale(M: Integer; D: Integer); override;
    procedure DoAssign(Source: TPersistent); override;
    function NeedNotifyControl: Boolean; override;
  public
    constructor Create(AOwner: TdxCustomListView); override;
  published
    property Arrangement: TdxListIconsArrangement read FArrangement write SetArrangement default TdxListIconsArrangement.Horizontal;
    property ColumnWidth: Integer read FColumnWidth write SetColumnWidth default DefaultColumnWidth;
  end;

  { TdxListViewPaddingOptions }

  TdxListViewPaddingOptions = class(TdxListViewCustomOptions)
  private
    FGroupContent: TcxMargin;
    FGroupHeader: TcxMargin;
    FItem: TcxMargin;
    FView: TcxMargin;
    procedure ChangeHandler(Sender: TObject);
    procedure SetGroupContent(const AValue: TcxMargin);
    procedure SetGroupHeader(const AValue: TcxMargin);
    procedure SetItem(const AValue: TcxMargin);
    procedure SetView(const AValue: TcxMargin);
  protected
    procedure ChangeScale(M: Integer; D: Integer); override;
    function CreatePadding(ADefaultValue: Integer): TcxMargin;
    procedure DoAssign(Source: TPersistent); override;
  public
    constructor Create(AOwner: TdxCustomListView); override;
    destructor Destroy; override;
  published
    property GroupContent: TcxMargin read FGroupContent write SetGroupContent;
    property GroupHeader: TcxMargin read FGroupHeader write SetGroupHeader;
    property Item: TcxMargin read FItem write SetItem;
    property View: TcxMargin read FView write SetView;
  end;

  { TdxListViewFonts }

  TdxListViewFontValue = (ColumnHeader, GroupHeader, GroupFooter, GroupSubtitle, Item, SubItem); // don't change this order!
  TdxListViewFontValues = set of TdxListViewFontValue;

  TdxListViewFonts = class(TdxListViewPersistent)
  strict private
    FAssignedValues: TdxListViewFontValues;
    FValues: array[TdxListViewFontValue] of TFont;
    procedure FontChanged(Sender: TObject);
    function GetValue(AIndex: Integer): TFont;
    function IsStored(AIndex: Integer): Boolean;
    procedure SetValue(AIndex: Integer; AValue: TFont);
    procedure SetAssignedValues(AValue: TdxListViewFontValues);
  protected
    FLockChanges: Boolean;
    procedure AssignFont(ASource, ADest: TFont; AKeepColors: Boolean);
    procedure Changed; virtual;
    function CreateFont: TFont;
    procedure ChangeScale(M, D: Integer); virtual;
    procedure UpdateFonts;
  public
    constructor Create(AOwner: TdxCustomListView); override;
    destructor Destroy; override;
    procedure Assign(ASource: TPersistent); override;
    procedure SetFont(AFont: TFont; AKeepColors: Boolean);
  published
    property AssignedValues: TdxListViewFontValues read FAssignedValues write SetAssignedValues default [];
    property ColumnHeader: TFont index 0 read GetValue write SetValue stored IsStored;
    property GroupHeader: TFont index 1 read GetValue write SetValue stored IsStored;
    property GroupFooter: TFont index 2 read GetValue write SetValue stored IsStored;
    property GroupSubtitle: TFont index 3 read GetValue write SetValue stored IsStored;
    property Item: TFont index 4 read GetValue write SetValue stored IsStored;
    property SubItem: TFont index 5 read GetValue write SetValue stored IsStored;
  end;

  { TdxListViewImageOptions }

  TdxListViewImageOptions = class(TdxListViewPersistent)
  strict private
    FColumnHeaderImages: TCustomImageList;
    FGroupHeaderImages: TCustomImageList;
    FLargeImages: TCustomImageList;
    FSmallImages: TCustomImageList;
    FStateImages: TCustomImageList;
    FColumnHeaderImagesChangeLink: TChangeLink;
    FGroupHeaderImagesChangeLink: TChangeLink;
    FLargeImagesChangeLink: TChangeLink;
    FSmallImagesChangeLink: TChangeLink;
    FStateImagesChangeLink: TChangeLink;
    FScaleOnDPIChanges: Boolean;
    procedure ImageListChanged(Sender: TObject);
    procedure ImageListChangeNotify(Sender: TComponent; Operation: TOperation);
    procedure SetColumnHeaderImages(const AValue: TCustomImageList);
    procedure SetGroupHeaderImages(const AValue: TCustomImageList);
    procedure SetLargeImages(const AValue: TCustomImageList);
    procedure SetScaleOnDPIChanges(const Value: Boolean);
    procedure SetSmallImages(const AValue: TCustomImageList);
    procedure SetStateImages(const AValue: TCustomImageList);
  protected
    function AreImagesLinked(const AValue: TObject): Boolean; virtual;
    function CreateImagesChangeLink: TChangeLink;
    procedure Notification(AComponent: TComponent; Operation: TOperation); virtual;
  public
    constructor Create(AOwner: TdxCustomListView); override;
    destructor Destroy; override;
    procedure Assign(ASource: TPersistent); override;
  published
    property ColumnHeaderImages: TCustomImageList read FColumnHeaderImages write SetColumnHeaderImages;
    property GroupHeaderImages: TCustomImageList read FGroupHeaderImages write SetGroupHeaderImages;
    property LargeImages: TCustomImageList read FLargeImages write SetLargeImages;
    property ScaleOnDPIChanges: Boolean read FScaleOnDPIChanges write SetScaleOnDPIChanges default True;
    property SmallImages: TCustomImageList read FSmallImages write SetSmallImages;
    property StateImages: TCustomImageList read FStateImages write SetStateImages;
  end;

  TdxListViewInplaceEditingController = class(TdxInplaceEditingController) // for internal use
  strict private
    FListView: TdxCustomListView;
  protected
    procedure InplaceEditKeyPress(Sender: TObject; var Key: Char); override;
    function IsMultiline: Boolean; override;
    function IsReadOnly: Boolean; override;
    procedure StartItemCaptionEditing; override;
  public
    constructor Create(AListView: TdxCustomListView);
  end;

  { TdxListViewHintHelper }

  TdxListViewHintHelper = class(TcxControlHintHelper) // for internal use
  private
    FListView: TdxCustomListView;
  protected
    procedure CorrectHintWindowRect(var ARect: TRect); override;
    function GetOwnerControl: TcxControl; override;
    property ListView: TdxCustomListView read FListView;
  public
    constructor Create(AListView: TdxCustomListView);
  end;

  { TdxCustomListView }

  TdxListViewStyle = (Icon, SmallIcon, List, Report);
  TdxListViewSortType = (None, Data, Text, Both);
  TdxListItemFind = (Data, PartialString, ExactString);
  TdxListItemSearchDirection = (Left, Right, Above, Below, All); 
  TdxListItemRequests = (Text, Image, Param, State, Indent);
  TdxListItemRequest = set of TdxListItemRequests;
  TdxListViewEvent = procedure(Sender: TdxCustomListView) of object;
  TdxListViewCompareEvent = procedure(Sender: TdxCustomListView; AItem1, AItem2: TdxListItem; AData: TdxNativeInt; var ACompare: Integer) of object;
  TdxListViewItemEvent = procedure(Sender: TdxCustomListView; AItem: TdxListItem) of object;
  TdxListViewEditingEvent = procedure(Sender: TdxCustomListView; AItem: TdxListItem; var AllowEdit: Boolean) of object;
  TdxListViewEditedEvent = procedure(Sender: TdxCustomListView; AItem: TdxListItem; var S: string) of object;
  TdxListViewChangeEvent = procedure(Sender: TdxCustomListView; AItem: TdxListItem; AChange: TdxListItemChange) of object;
  TdxListViewChangingEvent = procedure(Sender: TdxCustomListView; AItem: TdxListItem; AChange: TdxListItemChange; var AllowChange: Boolean) of object;
  TdxListViewColumnClickEvent = procedure(Sender: TdxCustomListView; AColumn: TdxListColumn) of object;
  TdxListViewColumnPosChangedEvent = procedure(Sender: TdxCustomListView; AColumn: TdxListColumn) of object;
  TdxListViewColumnRightClickEvent = procedure(Sender: TdxCustomListView; AColumn: TdxListColumn; APoint: TPoint) of object;
  TdxListViewColumnSizeChangedEvent = procedure(Sender: TdxCustomListView; AColumn: TdxListColumn) of object;
  TdxListViewCreateItemClassEvent = procedure(Sender: TdxCustomListView; var AItemClass: TdxListItemClass) of object;
  TdxListViewInfoTipEvent = procedure(Sender: TdxCustomListView; AItem: TdxListItem; var AInfoTip: string) of object;
  TdxListViewOwnerDataEvent = procedure(Sender: TdxCustomListView; AItem: TdxListItem) of object;
  TdxListViewOwnerDataFindEvent = procedure(Sender: TdxCustomListView; AFind: TdxListItemFind;
    const AFindString: string; const AFindPosition: TPoint; AFindData: TCustomData;
    AStartIndex: Integer; ADirection: TdxListItemSearchDirection; AWrap: Boolean; var AIndex: Integer) of object;
  TdxListViewOwnerDataHintEvent = procedure(Sender: TdxCustomListView; AStartIndex, AEndIndex: Integer) of object;
  TdxListViewSelectItemEvent = procedure(Sender: TdxCustomListView; AItem: TdxListItem; ASelected: Boolean) of object;
  TdxListViewItemImageEvent = procedure(Sender: TdxCustomListView; AItem: TdxListItem; var AImageIndex: Integer) of object;
  TdxListViewSubItemImageEvent = procedure(Sender: TdxCustomListView; AItem: TdxListItem; ASubItem: Integer; var AImageIndex: Integer) of object;
  TdxListViewColumnDraggedEvent = procedure(Sender: TdxCustomListView; AColumn: TdxListColumn) of object;

  TdxCustomListView = class(TcxScrollingControl,
    IdxSkinSupport,
    IcxCustomCanvasSupport,
    IdxInplaceEditContainer)
  strict private
    FCanBeFocused: Boolean;
    FColumns: TdxListColumns;
    FController: TdxListViewController;
    FCurrentDragSelection: TdxHashSet<Integer>;
    FDeletingAllItems: Boolean;
    FDragSelectRectangle: TRect;
    FDropTargetIndices: TdxIntegerList;
    FEditingItemIndex: Integer;
    FEmptyText: string;
    FExplorerStyle: Boolean;
    FFonts: TdxListViewFonts;
    FGroups: TdxListGroups;
    FGroupView: Boolean;
    FHintHelper: TdxListViewHintHelper;
    FImageOptions: TdxListViewImageOptions;
    FIncSearchText: string;
    FInplaceEditingController: TdxListViewInplaceEditingController;
    FItems: TdxListItems;
    FLastKeyPressTicks: Cardinal;
    FShowItemHints: Boolean;
    FMultiSelect: Boolean;
    FOriginalSelection: TdxHashSet<Integer>;
    FOwnerData: Boolean;
    FPaddingOptions: TdxListViewPaddingOptions;
    FPainter: TdxListViewPainter;
    FReadOnly: Boolean;
    FCheckboxes: Boolean;
    FSavedSort: TdxListViewSortType;
    FSortType: TdxListViewSortType;
    FTempItem: TdxListItem;
    FViewInfo: TdxListViewViewInfo;
    FViewStyle: TdxListViewStyle;
    FViewStyleIcon: TdxListViewIconOptions;
    FViewStyleList: TdxListViewListOptions;
    FViewStyleReport: TdxListViewReportOptions;
    FViewStyleSmallIcon: TdxListViewSmallIconOptions;

    FOnCancelEdit: TNotifyEvent;
    FOnChange: TdxListViewChangeEvent;
    FOnChanging: TdxListViewChangingEvent;
    FOnColumnClick: TdxListViewColumnClickEvent;
    FOnColumnDragged: TdxListViewColumnDraggedEvent;
    FOnColumnPosChanged: TdxListViewColumnPosChangedEvent;
    FOnColumnRightClick: TdxListViewColumnRightClickEvent;
    FOnColumnSizeChanged: TdxListViewColumnSizeChangedEvent;
    FOnCompare: TdxListViewCompareEvent;
    FOnCreateItemClass: TdxListViewCreateItemClassEvent;
    FOnData: TdxListViewOwnerDataEvent;
    FOnDataFind: TdxListViewOwnerDataFindEvent;
    FOnDataHint: TdxListViewOwnerDataHintEvent;
    FOnDeletion: TdxListViewItemEvent;
    FOnEdited: TdxListViewEditedEvent;
    FOnEditing: TdxListViewEditingEvent;
    FOnGetSubItemImageIndex: TdxListViewSubItemImageEvent;
    FOnGetImageIndex: TdxListViewItemImageEvent;
    FOnInfoTip: TdxListViewInfoTipEvent;
    FOnInsert: TdxListViewItemEvent;
    FOnSelectionChanged: TNotifyEvent;
    FOnSelectItem: TdxListViewSelectItemEvent;
    FOnViewStyleChanged: TdxListViewEvent;
    function AreItemsStored: Boolean;
    function GetDropTarget: TdxListItem;
    function GetEditingItem: TdxListItem;
    function GetFocusedItem: TdxListItem;
    function GetInplaceEdit: IdxInplaceEdit;
    function GetSelectedItemCount: Integer;
    function GetSelectedItem(Index: Integer): TdxListItem;
    function GetUseLightBorders: Boolean;
    function GetViewStyleReport: TdxListViewReportOptions;
    function GetViewStyleSmallIcon: TdxListViewSmallIconOptions;
    procedure SetColumns(const AValue: TdxListColumns);
    procedure SetDropTarget(AValue: TdxListItem);
    procedure SetEmptyText(const AValue: string);
    procedure SetExplorerStyle(AValue: Boolean);
    procedure SetFocusedItem(AItem: TdxListItem);
    procedure SetFonts(const AValue: TdxListViewFonts);
    procedure SetGroups(const AValue: TdxListGroups);
    procedure SetGroupView(AValue: Boolean);
    procedure SetImageOptions(const AValue: TdxListViewImageOptions);
    procedure SetItems(const AValue: TdxListItems);
    procedure SetMultiSelect(AValue: Boolean);
    procedure SetOwnerData(AValue: Boolean);
    procedure SetPaddingOptions(const AValue: TdxListViewPaddingOptions);
    procedure SetReadOnly(AValue: Boolean);
    procedure SetCheckboxes(AValue: Boolean);
    procedure SetSortType(AValue: TdxListViewSortType);
    procedure SetViewStyle(const AValue: TdxListViewStyle);
    procedure SetViewStyleIcon(const AValue: TdxListViewIconOptions);
    procedure SetViewStyleList(const AValue: TdxListViewListOptions);
    procedure SetViewStyleReport(const AValue: TdxListViewReportOptions);
    procedure SetViewStyleSmallIcon(const AValue: TdxListViewSmallIconOptions);

    procedure CMDrag(var Message: TCMDrag); message CM_DRAG;
    procedure CMHintShow(var Message: TCMHintShow); message CM_HINTSHOW;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
  protected const
    DragShadowSize = 4;
    DragImagePadding = 2;
  protected
    FLockCount: Integer;
    FIsDragSelectPaintMode: Boolean;
    FLastDropTarget: TdxListItem;
    FSortNeedeed: Boolean;
    function CreateColumns: TdxListColumns; virtual;
    function CreateController: TdxListViewController; virtual;
    function CreatePainter: TdxListViewPainter; virtual;
    function CreateViewInfo: TdxListViewViewInfo; virtual;
    function CreateFonts: TdxListViewFonts; virtual;
    function CreateGroups: TdxListGroups; virtual;
    function CreateImages: TdxListViewImageOptions; virtual;
    function CreateItems: TdxListItems; virtual;

    // IdxInplaceEditContainer
    procedure IdxInplaceEditContainer.FinishEditing = FinishItemCaptionEditing;
    function GetEditingControl: TWinControl;
    function IdxInplaceEditContainer.GetTextColor = GetItemCaptionTextColor;

    function CreateListItem: TdxListItem; virtual;
    procedure CreateViewSubClasses; virtual;
    procedure DestroyViewSubClasses; virtual;
    function GetColumnClass: TdxListColumnClass; virtual;
    function GetGroupClass: TdxListGroupClass; virtual;

    // Keyboard operations
    procedure DoIncSearch(var Key: Char); virtual;
    procedure FocusEnter; override;
    procedure FocusLeave; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure ProcessIncSearch(var Key: Char);

    // Mouse operations
    procedure Click; override;
    procedure DblClick; override;
    function GetDesignHitTest(X, Y: Integer; Shift: TShiftState): Boolean; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseLeave(AControl: TControl); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    // TWinControl
    function CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure WndProc(var Message: TMessage); override;

    // TcxScrollingControl
    procedure AfterScrolling; virtual;
    procedure BeforeScrolling; virtual;
    procedure BoundsChanged; override;
    procedure Calculate(AType: TdxChangeType); override;
    function CanCalculate: Boolean; override;
    function GetContentSize: TSize; override;
    function GetMouseWheelScrollingKind: TcxMouseWheelScrollingKind; override;
    function GetScrollStep: Integer; override;
    function IsScrollDataValid: Boolean; override;
    procedure LayoutChanged(AType: TdxChangeType = ctHard); override;
    procedure ScrollPosChanged(const AOffset: TPoint); override;
    procedure ValidateVisibleContent; override;

    // TcxControl
    function AllowTouchScrollUIMode: Boolean; override;
    procedure ChangeScaleEx(M, D: Integer; isDpiChange: Boolean); override;
    procedure CreateCanvasBasedResources; override;
    procedure DoCancelMode; override;
    procedure DoChangeScaleEx(M, D: Integer; isDpiChange: Boolean); virtual;
    procedure DoPaint; override;
    procedure FreeCanvasBasedResources; override;
    procedure FontChanged; override;
    function GetCurrentCursor(X, Y: Integer): TCursor; override;
    function GetScrollContentForegroundColor: TColor; override;
    function HasScrollBarArea: Boolean; override;
    function IsActive: Boolean;
    // drag and drop
    function IsDragging: Boolean;
    // delphi drag and drop
    function CanDrag(X, Y: Integer): Boolean; override;
    procedure DoEndDrag(Target: TObject; X, Y: Integer); override;

    procedure DoDragOver(Source: TDragObject; X, Y: Integer; CanDrop: Boolean);
    procedure DragOver(Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean); override;
    procedure DrawDragImage(ACanvas: TcxCanvas; const R: TRect); override;
    procedure DrawDragImageContent(ACanvas: TcxCanvas; const ABounds: TRect); virtual;
    function GetActiveDragAndDropObject: TdxListViewDragAndDropObject;
    function GetDragImagesSize: TPoint; override;
    function GetDragObjectClass: TDragControlObjectClass; override;
    function HasDragImages: Boolean; override;
    procedure InitDragImages(ADragImages: TcxDragImageList); override;
    // internal drag and drop
    procedure BeginDragSelectOperation(AExtendedMode: Boolean);
    procedure EndDragAndDrop(Accepted: Boolean); override;
    procedure EndDragSelectOperation;
    function StartDragAndDrop(const P: TPoint): Boolean; override;
    procedure UpdateDragSelectState(const ABounds: TRect; AExtendedSelection: Boolean);

    // TdxCustomListView
    // Initialization
    function CreateHintHelper: TdxListViewHintHelper; virtual;
    function CreateIconOptions: TdxListViewIconOptions; virtual;
    function CreateListOptions: TdxListViewListOptions; virtual;
    function CreatePaddingOptions: TdxListViewPaddingOptions; virtual;
    function CreateReportOptions: TdxListViewReportOptions; virtual;
    function CreateSmallIconOptions: TdxListViewSmallIconOptions; virtual;
    procedure CreateViewStyleOptions; virtual;
    procedure DestroyViewStyleOptions; virtual;

    function CheckSorting(AGroup: TdxListGroup): Boolean;
    procedure ClearItems;
    function ColumnsShowing: Boolean;
    procedure DeleteItem(AItem: TdxListItem); virtual;
    procedure DoCancelEdit(Sender: TObject); virtual;
    function DoChanging(AItem: TdxListItem; AChange: TdxListItemChange): Boolean; virtual;
    procedure DoChange(AItem: TdxListItem; AChange: TdxListItemChange); virtual;
    procedure DoColumnClick(AColumn: TdxListColumn); virtual;
    procedure DoColumnDragged(AColumn: TdxListColumn); virtual;
    procedure DoColumnPosChanged(AColumn: TdxListColumn); virtual;
    procedure DoColumnRightClick(AColumn: TdxListColumn; APoint: TPoint); virtual;
    procedure DoColumnSizeChanged(AColumn: TdxListColumn); virtual;
    procedure DoEdited(AItem: TdxListItem; var ACaption: string); virtual;
    procedure DoInfoTip(AItem: TdxListItem; var AInfoTip: string); virtual;
    procedure DoSelectionChanged; virtual;
    procedure DoSelectItem(AItemIndex: Integer; ASelected: Boolean);
    procedure DoViewStyleChanged; virtual;
    procedure DrawMultiSelection(const ABounds: TRect);
    function GetGapBetweenItems: Integer;
    function GetItemAtPos(const P: TPoint): TdxListItem;
    function GetItemCaptionTextColor: TColor;
    function IsDropTargetItem(AItemIndex: Integer): Boolean;
    function IsHorizontalItemsArrangement: Boolean;
    procedure InsertItem(AItem: TdxListItem); virtual;
    function IsItemSelected(AItem: TdxListItem): Boolean;
    function IsUpdateLocked: Boolean;
    procedure RemoveItem(AItem: TdxListItem);
    procedure SetDropTargetItem(AItemIndex: Integer; AValue: Boolean);
    function SupportsItemEnabledState: Boolean; virtual;
    procedure ResetContent;
    procedure UpdateGroups;
    function UseDisplayedItemsForBestFit: Boolean; virtual;
    procedure ValidateGroupItems;
    procedure ViewStyleChanged; virtual;
    // OwnerData
    function GetItem(AIndex: Integer): TdxListItem;
    function OwnerDataFetch(AItem: TdxListItem; ARequest: TdxListItemRequest): Boolean; virtual;
    function OwnerDataFind(AFind: TdxListItemFind; const AFindString: string;
      const AFindPosition: TPoint; AFindData: TCustomData; AStartIndex: Integer;
      ADirection: TdxListItemSearchDirection; AWrap: Boolean): Integer; virtual;
    function OwnerDataHint(AStartIndex, AEndIndex: Integer): Boolean; virtual;
    // Editing
    function CanEdit(AItem: TdxListItem): Boolean; virtual;
    procedure Edit(AItemIndex: Integer; const AText: string); virtual;
    function GetEditingText(AItem: TdxListItem): string; virtual;
    procedure InplaceEditKeyPress(Sender: TObject; var Key: Char); virtual;
    function IsEditingItem(AItemIndex: Integer): Boolean;
    function StartItemCaptionEditing(AItemIndex: Integer): Boolean; virtual;
    procedure FinishItemCaptionEditing(AAccept: Boolean = True); virtual;
    procedure ShowInplaceEdit(AItemIndex: Integer; ABounds: TRect; const AText: string); virtual;
    procedure ValidatePasteText(var AText: string); virtual;

    property CanBeFocused: Boolean read FCanBeFocused write FCanBeFocused;
    property DeletingAllItems: Boolean read FDeletingAllItems write FDeletingAllItems;
    property EditingItem: TdxListItem read GetEditingItem;
    property EmptyText: string read FEmptyText write SetEmptyText;
    property HintHelper: TdxListViewHintHelper read FHintHelper;
    property InplaceEdit: IdxInplaceEdit read GetInplaceEdit;
    property InplaceEditingController: TdxListViewInplaceEditingController read FInplaceEditingController;
    property Painter: TdxListViewPainter read FPainter;
    property ShowItemHints: Boolean read FShowItemHints write FShowItemHints default False;
    property TempItem: TdxListItem read FTempItem;
    property UseLightBorders: Boolean read GetUseLightBorders;
    property ViewInfo: TdxListViewViewInfo read FViewInfo;

    property OnCancelEdit: TNotifyEvent read FOnCancelEdit write FOnCancelEdit;
    property OnChange: TdxListViewChangeEvent read FOnChange write FOnChange;
    property OnChanging: TdxListViewChangingEvent read FOnChanging write FOnChanging;
    property OnColumnClick: TdxListViewColumnClickEvent read FOnColumnClick write FOnColumnClick;
    property OnColumnDragged: TdxListViewColumnDraggedEvent read FOnColumnDragged write FOnColumnDragged;
    property OnColumnPosChanged: TdxListViewColumnPosChangedEvent read FOnColumnPosChanged write FOnColumnPosChanged;
    property OnColumnRightClick: TdxListViewColumnRightClickEvent read FOnColumnRightClick write FOnColumnRightClick;
    property OnColumnSizeChanged: TdxListViewColumnSizeChangedEvent read FOnColumnSizeChanged write FOnColumnSizeChanged;
    property OnCompare: TdxListViewCompareEvent read FOnCompare write FOnCompare;
    property OnCreateItemClass: TdxListViewCreateItemClassEvent read FOnCreateItemClass write FOnCreateItemClass;
    property OnData: TdxListViewOwnerDataEvent read FOnData write FOnData;
    property OnDataFind: TdxListViewOwnerDataFindEvent read FOnDataFind write FOnDataFind;
    property OnDataHint: TdxListViewOwnerDataHintEvent read FOnDataHint write FOnDataHint;
    property OnDeletion: TdxListViewItemEvent read FOnDeletion write FOnDeletion;
    property OnEdited: TdxListViewEditedEvent read FOnEdited write FOnEdited;
    property OnEditing: TdxListViewEditingEvent read FOnEditing write FOnEditing;
    property OnGetImageIndex: TdxListViewItemImageEvent read FOnGetImageIndex write FOnGetImageIndex;
    property OnGetSubItemImageIndex: TdxListViewSubItemImageEvent read FOnGetSubItemImageIndex write FOnGetSubItemImageIndex;
    property OnInfoTip: TdxListViewInfoTipEvent read FOnInfoTip write FOnInfoTip;
    property OnInsert: TdxListViewItemEvent read FOnInsert write FOnInsert;
    property OnSelectionChanged: TNotifyEvent read FOnSelectionChanged write FOnSelectionChanged;
    property OnSelectItem: TdxListViewSelectItemEvent read FOnSelectItem write FOnSelectItem;
    property OnViewStyleChanged: TdxListViewEvent read FOnViewStyleChanged write FOnViewStyleChanged;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeginUpdate;
    procedure EndUpdate;

    procedure AddItem(const AItem: string; AObject: TObject);
    function AlphaSort: Boolean;
    procedure ApplyBestFit(AColumn: TdxListColumn = nil; AVisibleItemsOnly: Boolean = False);
    function CanFocus: Boolean; override;
    procedure Clear;            
    function CustomSort(ASortProc: TdxListViewCompareProc; AData: TdxNativeInt): Boolean;
    procedure ExpandAllGroups;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    function GetItemAt(X, Y: Integer): TdxListItem;
    function IsEditing: Boolean;
    procedure MakeItemVisible(AItem: TdxListItem; AVisibleType: TdxVisibilityType);
    procedure UpdateItems(AFirstIndex, ALastIndex: Integer);
    // selection
    procedure ClearDropTargets;
    procedure ClearSelection;
    procedure DeleteSelected;   
    procedure SelectAll;
    function GetCount: Integer; 
    // search
    function FindCaption(AStartIndex: Integer; const AValue: string; APartial, AInclusive, AWrap: Boolean): TdxListItem;
    function FindData(AStartIndex: Integer; AValue: TCustomData; AInclusive, AWrap: Boolean): TdxListItem;
    // drag-n-drop
    procedure DragDrop(Source: TObject; X, Y: Integer); override;
    function StartDrag(DragObject: TDragObject): Boolean; override;

    property BorderStyle default cxcbsDefault;
    property Checkboxes: Boolean read FCheckboxes write SetCheckboxes default False;
    property Columns: TdxListColumns read FColumns write SetColumns;
    property Controller: TdxListViewController read FController; // for internal use
    property DropTarget: TdxListItem read GetDropTarget write SetDropTarget;
    property ExplorerStyle: Boolean read FExplorerStyle write SetExplorerStyle default False;
    property FocusedItem: TdxListItem read GetFocusedItem write SetFocusedItem;
    property Fonts: TdxListViewFonts read FFonts write SetFonts;
    property Groups: TdxListGroups read FGroups write SetGroups;
    property GroupView: Boolean read FGroupView write SetGroupView default False;
    property ImageOptions: TdxListViewImageOptions read FImageOptions write SetImageOptions;
    property Items: TdxListItems read FItems write SetItems stored AreItemsStored;
    property MultiSelect: Boolean read FMultiSelect write SetMultiSelect default False;
    property OwnerData: Boolean read FOwnerData write SetOwnerData default False;
    property PaddingOptions: TdxListViewPaddingOptions read FPaddingOptions write SetPaddingOptions;
    property ReadOnly: Boolean read FReadOnly write SetReadOnly default False;
    property SelectedItemCount: Integer read GetSelectedItemCount;
    property SelectedItems[Index: Integer]: TdxListItem read GetSelectedItem;
    property ShowHint default False;
    property SortType: TdxListViewSortType read FSortType write SetSortType default TdxListViewSortType.None;
    property ViewStyle: TdxListViewStyle read FViewStyle write SetViewStyle default TdxListViewStyle.Icon;
    property ViewStyleIcon: TdxListViewIconOptions read FViewStyleIcon write SetViewStyleIcon;
    property ViewStyleList: TdxListViewListOptions read FViewStyleList write SetViewStyleList;
    property ViewStyleReport: TdxListViewReportOptions read GetViewStyleReport write SetViewStyleReport;
    property ViewStyleSmallIcon: TdxListViewSmallIconOptions read GetViewStyleSmallIcon write SetViewStyleSmallIcon;
  end;

  { TdxListViewControl }

  TdxListViewControl = class(TdxCustomListView)
  published
    property Align;
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Fonts;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property PopupMenu;
    property Visible;

    property BorderStyle;
    property Columns;
    property ExplorerStyle;
    property Groups;
    property GroupView;
    property ImageOptions;
    property Items;
    property LookAndFeel;
    property MultiSelect;
    property OwnerData;
    property PaddingOptions;
    property ParentShowHint;
    property ReadOnly;
    property Checkboxes;
    property ShowHint;
    property SortType;
    property TabOrder;
    property TabStop;
    property Transparent;
    property ViewStyle;
    property ViewStyleIcon;
    property ViewStyleList;
    property ViewStyleReport;
    property ViewStyleSmallIcon;

    property OnCancelEdit;
    property OnChange;
    property OnChanging;
    property OnClick;
    property OnColumnClick;
    property OnColumnDragged;
    property OnColumnPosChanged;
    property OnColumnRightClick;
    property OnColumnSizeChanged;
    property OnCompare;
    property OnContextPopup;
    property OnCreateItemClass;
    property OnData;
    property OnDataFind;
    property OnDataHint;
    property OnDblClick;
    property OnDeletion;
    property OnDragDrop;
    property OnDragOver;
    property OnEdited;
    property OnEditing;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetImageIndex;
    property OnGetSubItemImageIndex;
    property OnInfoTip;
    property OnInsert;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnSelectItem;
    property OnStartDock;
    property OnStartDrag;
  end;

  { TdxListViewPainter }

  TdxListViewPainter = class(TdxListViewPersistent) // for internal use
  strict private
    FImageLists: TcxCanvasBasedImageListMap;

    function GetLookAndFeelPainter: TcxCustomLookAndFeelPainter; inline;
    function GetScaleFactor: TdxScaleFactor; inline;
    function GetUseRightToLeftAlignment: Boolean; inline;
  protected
    function CreateCanvasBasedFont(AFont: TFont): TcxCanvasBasedFont; virtual;
    function CreateCanvasBasedImage(ABitmap: TBitmap; AAlphaFormat: TAlphaFormat): TcxCanvasBasedImage; virtual;
    function CreateCanvasBasedTextLayout: TcxCanvasBasedTextLayout; virtual;

    procedure DrawGlyphCore(ACanvas: TcxCustomCanvas; const ABounds: TRect;
      AImages: TCustomImageList; AImageIndex, AOverlayIndex: Integer; AMode: TcxImageDrawMode; AAlpha: Byte; const AColorPalette: IdxColorPalette); virtual;
    function DrawItemSelectionFirst: Boolean; virtual;
  public
    destructor Destroy; override;
    procedure InvalidateImageList(AImageList: TCustomImageList);
    // Background
    procedure DrawBackground(ACanvas: TcxCustomCanvas; const ABounds: TRect; AExplorerStyle: Boolean); virtual;
    // Group
    procedure DrawGroupHeader(ACanvas: TcxCustomCanvas; AViewInfo: TdxListGroupHeaderViewInfo); virtual;
    procedure DrawGroupHeaderBackground(ACanvas: TcxCustomCanvas; AViewInfo: TdxListGroupHeaderViewInfo); virtual;
    procedure DrawGroupText(ACanvas: TcxCustomCanvas; AViewInfo: TdxListGroupTextViewInfo); virtual;
    // Items
    procedure DrawCheckButton(ACanvas: TcxCustomCanvas; const ABounds: TRect; AState: TcxButtonState; AChecked: Boolean); virtual;
    procedure DrawItemBackground(ACanvas: TcxCustomCanvas; AViewInfo: TdxListItemCustomViewInfo); virtual;
    procedure DrawReportItemBackground(ACanvas: TcxCustomCanvas; AViewInfo: TdxListItemReportStyleViewInfo); virtual;

    procedure DrawMultiSelectionRect(ACanvas: TcxCustomCanvas; const ABounds: TRect); virtual;
    //
    procedure DrawDesignSelection(ACanvas: TcxCustomCanvas; ABounds: TRect);
    
    property LookAndFeelPainter: TcxCustomLookAndFeelPainter read GetLookAndFeelPainter;
    property ScaleFactor: TdxScaleFactor read GetScaleFactor;
    property UseRightToLeftAlignment: Boolean read GetUseRightToLeftAlignment;
  end;

implementation

uses
{$IFDEF DELPHIXE8}
  System.Hash,
{$ENDIF}
  Math, cxImageList, RTLConsts, dxHash, cxScrollBar, dxDPIAwareUtils, cxLibraryConsts,
  Clipbrd, cxContainer, Character, dxCharacters, dxStringHelper;

const
  dxThisUnitName = 'dxListView';

const
  OppositePositionMap: array[TcxPosition] of TcxPosition = (posNone, posRight, posLeft, posBottom, posTop);
  HorizontalAlignmentMap: array[TAlignment] of Integer = (CXTO_LEFT, CXTO_RIGHT, CXTO_CENTER_HORIZONTALLY);

type
  TdxKeyboard = class
  strict private
    class function CheckIsKeyPressed(const Index: Integer): Boolean; static;
  public
    class property IsAltPressed: Boolean index VK_MENU read CheckIsKeyPressed;
    class property IsControlPressed: Boolean index VK_CONTROL read CheckIsKeyPressed;
    class property IsShiftPressed: Boolean index VK_SHIFT read CheckIsKeyPressed;
  end;

function CeilDiv(ADividend, ADivisor: Integer): Integer;
begin
  Result := ADividend div ADivisor;
  if ADividend mod ADivisor <> 0 then
    Inc(Result);
end;

function DefaultListViewSort(AItem1, AItem2: TdxListItem; AData: TdxNativeInt): Integer;
begin
  with AItem1 do
    if Assigned(ListView.OnCompare) then
      ListView.OnCompare(ListView, AItem1, AItem2, AData, Result)
    else
      Result := CompareStr(AItem1.Caption, AItem2.Caption)
end;

{ TdxListViewPersistent }

constructor TdxListViewPersistent.Create(AOwner: TdxCustomListView);
begin
  inherited Create(AOwner);
end;

function TdxListViewPersistent.GetListView: TdxCustomListView;
begin
  Result := TdxCustomListView(Owner);
end;

type
  TdxSubItems = class(TStringList)
  private
    FOwner: TdxListItem;
    FImageIndices: TList;
    procedure RefreshItem(Index: Integer);
    function GetImageIndex(AIndex: Integer): TcxImageIndex;
    procedure SetImageIndex(AIndex: Integer; const AValue: TcxImageIndex);
  protected
    procedure Put(AIndex: Integer; const S: string); override;
    procedure SetUpdateState(AUpdating: Boolean); override;
  public
    constructor Create(AOwner: TdxListItem);
    destructor Destroy; override;
    function Add(const S: string): Integer; override;
    function AddObject(const S: string; AObject: TObject): Integer; override;
    procedure Assign(Source: TPersistent); override;
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
    procedure Insert(AIndex: Integer; const S: string); override;
    property Owner: TdxListItem read FOwner;
    property ImageIndex[Index: Integer]: TcxImageIndex read GetImageIndex write SetImageIndex;
  end;

constructor TdxSubItems.Create(AOwner: TdxListItem);
begin
  inherited Create;
  FOwner := AOwner;
  FImageIndices := TList.Create;
end;

destructor TdxSubItems.Destroy;
begin
  FreeAndNil(FImageIndices);
  inherited Destroy;
end;

function TdxSubItems.Add(const S: string): Integer;
begin
  Result := inherited Add(S);
  FImageIndices.Add(Pointer(-1));
  RefreshItem(Result);
end;

function TdxSubItems.AddObject(const S: string; AObject: TObject): Integer;
begin
  Result := inherited AddObject(S, AObject);
  FImageIndices.Add(Pointer(-1));
  RefreshItem(Result);
end;

procedure TdxSubItems.Assign(Source: TPersistent);
var
  I: Integer;
begin
  inherited Assign(Source);
  FImageIndices.Count := Count;
  for I := 0 to Count - 1 do
  begin
    FImageIndices.List[I] := Pointer(-1);
    if (Source is TdxSubItems) and (I < TdxSubItems(Source).FImageIndices.Count) then
      FImageIndices.List[I] := TdxSubItems(Source).FImageIndices[I]
  end;
end;

procedure TdxSubItems.Clear;
begin
  inherited Clear;
  FImageIndices.Clear;
end;

procedure TdxSubItems.Delete(Index: Integer);
begin
  inherited Delete(Index);
  FImageIndices.Delete(Index);
  Owner.Changed(ctMedium);
end;

procedure TdxSubItems.Insert(AIndex: Integer; const S: string);
var
  i: Integer;
begin
  inherited Insert(AIndex, S);
  FImageIndices.Insert(AIndex, Pointer(-1));
  for i := AIndex + 1 to Count do
    RefreshItem(i);
end;

procedure TdxSubItems.Put(AIndex: Integer; const S: string);
begin
  inherited Put(AIndex, S);
  RefreshItem(AIndex);
end;

procedure TdxSubItems.RefreshItem(Index: Integer);
var
  AColumn: TdxListColumn;
begin
  AColumn := Owner.ListView.Columns.FindSubItemColumn(Index);
  if AColumn <> nil then
  begin
    Owner.Changed(ctMedium);
  end;
end;

procedure TdxSubItems.SetUpdateState(AUpdating: Boolean);
begin
  if AUpdating then
    Owner.Owner.BeginUpdate
  else
    Owner.Owner.EndUpdate;
end;

function TdxSubItems.GetImageIndex(AIndex: Integer): TcxImageIndex;
begin
  Result := TcxImageIndex(FImageIndices[AIndex]);
end;

procedure TdxSubItems.SetImageIndex(AIndex: Integer; const AValue: TcxImageIndex);
begin
  FImageIndices[AIndex] := Pointer(AValue);
end;

{ TdxListItem }

constructor TdxListItem.Create(AOwner: TdxListItems);
begin
  inherited Create;
  FOwner := AOwner;
  FGroupID := -1;
  FSubItems := TdxSubItems.Create(Self);
  FEnabled := True;
  FImageIndex := -1;
  FOverlayIndex := -1;
  FStateIndex := -1;
end;

destructor TdxListItem.Destroy;
begin
  ListView.RemoveItem(Self);
  FreeAndNil(FSubItems);
  inherited Destroy;
end;

procedure TdxListItem.Assign(Source: TPersistent);
var
  AItem: TdxListItem;
begin
  if Safe.Cast(Source, TdxListItem, AItem) then
  begin
    Caption := AItem.Caption;
    Data := AItem.Data;
    ImageIndex := AItem.ImageIndex;
    Cut := AItem.Cut;
    OverlayIndex := AItem.OverlayIndex;
    StateIndex := AItem.StateIndex;
    SubItems := AItem.SubItems;
    Checked := AItem.Checked;
    GroupID := AItem.GroupID;
    Hint := AItem.Hint;
    Tag := AItem.Tag;
  end
  else
    inherited Assign(Source);
end;

procedure TdxListItem.BeforeDestruction;
begin
  FDeleting := True;
  ListView.DeleteItem(Self);
  FGroup := nil;
  FGroupID := -1;
  if not (ListView.DeletingAllItems or ListView.IsDestroying) then
  begin
    Owner.RemoveFromList(Index);
    Changed;
  end;
end;

function TdxListItem.GetListView: TdxCustomListView;
begin
  Result := Owner.ListView;
end;

function TdxListItem.GetIndex: Integer;
begin
  if not Owner.ListView.OwnerData then
    Owner.ValidateIndices;
  Result := FIndex
end;

procedure TdxListItem.Delete;
begin
  if not FDeleting and (Self <> ListView.TempItem) then
    Free;
end;

procedure TdxListItem.MakeVisible(PartialOK: Boolean);
const
  VisibleTypeMap: array[Boolean] of TdxVisibilityType = (vtFully, vtPartially);
begin
  ListView.MakeItemVisible(Self, VisibleTypeMap[PartialOK]);
end;

function TdxListItem.GetChecked: Boolean;
begin
  Result := FChecked; 
end;

function TdxListItem.GetDropTarget: Boolean;
begin
  Result := ListView.IsDropTargetItem(Index);
end;

function TdxListItem.GetFocused: Boolean;
begin
  Result := ListView.Controller.FocusedItemIndex = Index;
end;

function TdxListItem.GetLeft: Integer;
begin
  Result := GetPosition.X;
end;

function TdxListItem.GetSelected: Boolean;
begin
  Result := ListView.IsItemSelected(Self);
end;

function TdxListItem.GetTop: Integer;
begin
  Result := GetPosition.Y;
end;

procedure TdxListItem.SetChecked(AValue: Boolean);
begin
  if (AValue <> Checked) and Owner.ListView.DoChanging(Self, TdxListItemChange.State) then
  begin
    FChecked := AValue;
    Owner.ListView.DoChange(Self, TdxListItemChange.State);
    Changed(ctLight);
  end;
end;

procedure TdxListItem.SetGroup(AValue: TdxListGroup);
begin
  if AValue <> FGroup then
  begin
    if FGroup <> nil then
      FGroup.RemoveItem(Self);
    FGroup := AValue;
    if FGroup <> nil then
    begin
      FGroup.AddItem(Self);
      FGroupID := FGroup.GroupID;
      if ListView.CheckSorting(FGroup) then
        Exit;
    end
    else
      FGroupID := -1;
    ListView.UpdateGroups;
  end;
end;

procedure TdxListItem.SetGroupID(AValue: Integer);
begin
  if FGroupID <> AValue then
  begin
    FGroupID := AValue;
    if FGroup <> nil then
      FGroup.RemoveItem(Self);
    FGroup := ListView.Groups.FindByGroupID(AValue);
    if FGroup <> nil then
    begin
      FGroup.AddItem(Self);
    end;
    ListView.UpdateGroups;
  end;
end;

procedure TdxListItem.SetSelected(AValue: Boolean);
begin
  ListView.Controller.SelectItem(Index, AValue);
end;

procedure TdxListItem.SetCaption(const AValue: string);
begin
  if (AValue <> Caption) and ListView.DoChanging(Self, TdxListItemChange.Text) then
  begin
    FCaption := AValue;
    ListView.DoChange(Self, TdxListItemChange.Text);
    if ListView.TempItem = Self then
      Exit;
    if ListView.SortType in [TdxListViewSortType.Both, TdxListViewSortType.Text] then
      ListView.AlphaSort
    else
      ListView.LayoutChanged;// UpdateItems(Index, Index);
  end;
end;

procedure TdxListItem.SetCut(AValue: Boolean);
begin
  if FCut <> AValue then
  begin
    FCut := AValue;
    Changed(ctLight);
  end;
end;

procedure TdxListItem.SetData(AValue: TCustomData);
begin
  if AValue <> Data then
  begin
    FData := AValue;
    if ListView.TempItem = Self then
      Exit;
    if ListView.SortType in [TdxListViewSortType.Both, TdxListViewSortType.Data] then
      ListView.AlphaSort;
  end;
end;

procedure TdxListItem.SetDropTarget(AValue: Boolean);
begin
  ListView.SetDropTargetItem(Index, AValue);
end;

procedure TdxListItem.SetEnabled(AValue: Boolean);
begin
  if FEnabled <> AValue then
  begin
    FEnabled := AValue;
    if ListView.TempItem = Self then
      Exit;
    Changed(ctLight);
  end;
end;

procedure TdxListItem.SetFocused(AValue: Boolean);
begin
  if AValue then
    ListView.Controller.FocusedItemIndex := Index
  else if Focused then
    ListView.Controller.FocusedItemIndex := -1;
end;

function TdxListItem.EditCaption: Boolean;
begin
  Result := ListView.StartItemCaptionEditing(Index);
end;

procedure TdxListItem.CancelEdit;
begin
  ListView.FinishItemCaptionEditing;
end;

procedure TdxListItem.SetImage(AIndex: Integer; AValue: TcxImageIndex);

  procedure ProcessChanging(var AChanged: Boolean; AAValue: Integer; var AIndex: TcxImageIndex; Change: TdxListItemChange);
  begin
    if AAValue <> AIndex then
    begin
      AChanged := Owner.ListView.DoChanging(Self, Change);
      if AChanged then
      begin
        AIndex := AAValue;
        Owner.ListView.DoChange(Self, Change);
      end;
    end;
  end;

var
  AChanged: Boolean;
begin
  AChanged := False;
  case AIndex of
    0:
      ProcessChanging(AChanged, AValue, FImageIndex, TdxListItemChange.Image);
    1:
      if AValue <> FOverlayIndex then
      begin
        AChanged := True;
        FOverlayIndex := AValue;
      end;
    2:
      ProcessChanging(AChanged, AValue, FStateIndex, TdxListItemChange.State);
  end;
  if AChanged and not Owner.ListView.OwnerData then
    Changed(ctLight);
end;

procedure TdxListItem.Changed(AType: TdxChangeType = ctHard);
begin
  if Self <> ListView.TempItem then
    ListView.LayoutChanged(AType);
end;

procedure TdxListItem.FixupGroup;
begin
  GroupID := FLoadingGroupID;
end;

procedure TdxListItem.DirectSetSubItemImage(AIndex: Integer; const AValue: Integer);
begin
  TdxSubItems(FSubItems).SetImageIndex(AIndex, AValue);
end;

function TdxListItem.IsEnabled: Boolean;
begin
  Result := not ListView.SupportsItemEnabledState or Enabled;
end;

function TdxListItem.IsEqual(AItem: TdxListItem): Boolean;
begin
  Result := (Caption = AItem.Caption) and (Data = AItem.Data);
end;

procedure TdxListItem.SetSubItems(AValue: TStrings);
begin
  if AValue <> nil then
    FSubItems.Assign(AValue);
end;

function TdxListItem.GetPosition: TPoint;
begin
  Result := ListView.ViewInfo.GetBoundsForItem(Self).Location;
end;

function TdxListItem.DisplayRect({Code: TDisplayCode}): TRect;
begin
  Result := ListView.ViewInfo.GetBoundsForItem(Self);
end;

function TdxListItem.GetSubItemImage(AIndex: Integer): Integer;
begin
  Result := TdxSubItems(FSubItems).ImageIndex[AIndex];
end;

procedure TdxListItem.SetSubItemImage(AIndex: Integer; const AValue: Integer);
begin
  if TdxSubItems(FSubItems).ImageIndex[AIndex] <> AValue then
  begin
    TdxSubItems(FSubItems).ImageIndex[AIndex] := AValue;
    Changed
  end;
end;

{ TdxListItemsEnumerator }

constructor TdxListItemsEnumerator.Create(AListItems: TdxListItems);
begin
  inherited Create;
  FIndex := -1;
  FListItems := AListItems;
end;

function TdxListItemsEnumerator.GetCurrent: TdxListItem;
begin
  Result := FListItems[FIndex];
end;

function TdxListItemsEnumerator.MoveNext: Boolean;
begin
  Result := FIndex < FListItems.Count - 1;
  if Result then
    Inc(FIndex);
end;

{ TdxListItems }

type
  TItemDataInfo = record
    ImageIndex: Integer;
    StateIndex: Integer;
    OverlayIndex: Integer;
    SubItemCount: Integer;
    GroupID: Integer;
    Tag: Int64;
    CaptionLength: Integer;
  end;

  TSubItemDataInfo = record
    ImageIndex: Integer;
    CaptionLength: Integer;
  end;

constructor TdxListItems.Create(AListView: TdxCustomListView);
begin
  inherited Create;
  FListView := AListView;
  FList := TdxFastObjectList.Create(True, 1024);
  FNeedRebuildIndices := True;
end;

destructor TdxListItems.Destroy;
begin
  FreeAndNil(FList);
  inherited Destroy;
end;

function TdxListItems.Add: TdxListItem;
begin
  Result := Insert(Count);
end;

function TdxListItems.Insert(AIndex: Integer): TdxListItem;
begin
  if ListView.OwnerData then
    raise EInvalidOperation.Create('Cannot add an item in OwnerData mode');
  Result := ListView.CreateListItem;
  InsertItem(Result, AIndex);
end;

function TdxListItems.GetItemAtPos(const P: TPoint): TdxListItem;
var
  AViewInfo: TdxListItemCustomViewInfo;
begin
  if ListView.ViewInfo.GetItemAtPos(P, AViewInfo) then
    Result := AViewInfo.Item
  else
    Result := nil;
end;

function TdxListItems.GetCount: Integer;
begin
  if ListView.OwnerData then
    Result := FCount
  else
    Result := FList.Count;
end;

function TdxListItems.GetEnumerator: TdxListItemsEnumerator;
begin
  Result := TdxListItemsEnumerator.Create(Self);
end;

function TdxListItems.GetItem(AIndex: Integer): TdxListItem;
begin
  if ListView.OwnerData then
    Result := ListView.GetItem(AIndex)
  else
    Result := TdxListItem(FList[AIndex]);
end;

function TdxListItems.IndexOf(AValue: TdxListItem): Integer;
begin
  if (AValue = nil) or (AValue.Owner <> Self) then
    Result := -1
  else
    Result := AValue.Index;
end;

procedure TdxListItems.InsertItem(AItem: TdxListItem; AIndex: Integer);
begin
  if IsItemAddition(AIndex) then
  begin
    if NeedRebuildIndices then
      RebuildIndices(0);
    FList.Insert(AIndex, AItem);
    AItem.FIndex := AIndex;
  end
  else
  begin
    FList.Insert(AIndex, AItem);
    RebuildIndices(IfThen(NeedRebuildIndices, 0, AIndex));
    ListView.Controller.InsertItem(AIndex);
  end;
  ListView.InsertItem(AItem);
  Changed;
end;

procedure TdxListItems.RebuildIndices(AStartIndex: Integer);
var
  I: Integer;
begin
  for I := 0 to List.Count - 1 do
    TdxListItem(List.List[I]).FIndex := I;
end;

procedure TdxListItems.RemoveFromList(AIndex: Integer);
begin
  List.OwnsObjects := False;
  List.Delete(AIndex);
  List.OwnsObjects := True;
  ListView.Controller.DeleteItem(AIndex);
  NeedRebuildIndices := True;
end;

procedure TdxListItems.SetCount(AValue: Integer);
begin
  if ListView.OwnerData then
  begin
    FCount := EnsureRange(AValue, 0, MaxInt);
    Clear;
  end
  else
    FCount := 0;
end;

procedure TdxListItems.SetItem(AIndex: Integer; AValue: TdxListItem);
begin
  Items[AIndex].Assign(AValue);
end;

procedure TdxListItems.Clear;
begin
  ListView.Clear;
end;

procedure TdxListItems.BeginUpdate;
begin
  ListView.BeginUpdate;
end;

procedure TdxListItems.SetUpdateState(AUpdating: Boolean);
begin
end;

procedure TdxListItems.ValidateIndices;
begin
  if FNeedRebuildIndices then
  begin
    RebuildIndices(0);
    FNeedRebuildIndices := False;
  end;
end;

procedure TdxListItems.EndUpdate;
begin
  ListView.EndUpdate;
end;

procedure TdxListItems.Assign(ASource: TPersistent);
var
  Items: TdxListItems;
  I: Integer;
begin
  if ASource is TdxListItems then
  begin
    Clear;
    Items := TdxListItems(ASource);
    for I := 0 to Items.Count - 1 do Add.Assign(Items[I]);
  end
  else inherited Assign(ASource);
end;

procedure TdxListItems.Changed;
begin
end;

procedure TdxListItems.CustomSort(ASortProc: TdxListViewCompareProc; AData: TdxNativeInt);
begin
  if ListView.OwnerData then
    Exit;
  List.SortList(
    function (AItem1, AItem2: Pointer): Integer
    begin
      Result := ASortProc(TdxListItem(AItem1), TdxListItem(AItem2), AData);
    end, True);
  NeedRebuildIndices := True;
  ValidateIndices;
end;

procedure TdxListItems.DefineProperties(AFiler: TFiler);

  function WriteItems: Boolean;
  var
    I: Integer;
    AItems: TdxListItems;
  begin
    AItems := TdxListItems(AFiler.Ancestor);
    if AItems = nil then
      Result := Count > 0
    else if AItems.Count <> Count then
      Result := True
    else
    begin
      Result := False;
      for I := 0 to Count - 1 do
      begin
        Result := not Items[I].IsEqual(AItems[I]);
        if Result then Break;
      end
    end;
  end;

begin
  inherited DefineProperties(AFiler);
  AFiler.DefineBinaryProperty('ItemData', ReadItemData, WriteItemData, WriteItems);
end;

procedure TdxListItems.FixupGroups;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].FixupGroup;
end;

function TdxListItems.IsItemAddition(AIndex: Integer): Boolean;
begin
  Result := AIndex = FList.Count;
end;

const
  dxListItemStreamVersion = $1;

procedure TdxListItems.ReadItemData(AStream: TStream);
var
  AItemInfo: TItemDataInfo;
  ASubItemInfo: TSubItemDataInfo;
  I, J, AItemCount: Integer;
  AStreamVersion: Byte;
  ACaption: string;
begin
  BeginUpdate;
  try
    Clear;
    if AStream.Size = 0 then
      Exit;

    AStream.ReadBuffer(AStreamVersion, SizeOf(AStreamVersion));
    case AStreamVersion of
      dxListItemStreamVersion:
        begin
          AStream.ReadBuffer(AItemCount, SizeOf(Integer));
          for I := 0 to AItemCount - 1 do
          begin
            AStream.ReadBuffer(AItemInfo, SizeOf(TItemDataInfo));
            with Add do
            begin
              ImageIndex   := AItemInfo.ImageIndex;
              OverlayIndex := AItemInfo.OverlayIndex;
              StateIndex   := AItemInfo.StateIndex;
              Tag          := AItemInfo.Tag;
              FLoadingGroupID := AItemInfo.GroupID;
              SetLength(ACaption, AItemInfo.CaptionLength);
              AStream.ReadBuffer(ACaption[1], AItemInfo.CaptionLength * SizeOf(Char));
              Caption := ACaption;
              for J := 0 to AItemInfo.SubItemCount - 1 do
              begin
                AStream.ReadBuffer(ASubItemInfo, SizeOf(TSubItemDataInfo));
                SetLength(ACaption, ASubItemInfo.CaptionLength);
                AStream.ReadBuffer(ACaption[1], ASubItemInfo.CaptionLength * SizeOf(Char));
                SubItems.Add(ACaption);
                SubItemImages[J] := ASubItemInfo.ImageIndex;
              end;
            end;
          end;
        end;
    end;
  finally
    EndUpdate;
  end;
end;

procedure TdxListItems.WriteItemData(AStream: TStream);
var
  AItemInfo: TItemDataInfo;
  ASubItemInfo: TSubItemDataInfo;
  ACaption: string;
  AStreamVersion: Byte;
  I, J, AItemCount: Integer;
begin
  AItemCount := Count;
  AStreamVersion := dxListItemStreamVersion;
  AStream.WriteBuffer(AStreamVersion, SizeOf(Byte));
  AStream.WriteBuffer(AItemCount, SizeOf(Integer));
  for I := 0 to Count - 1 do
  begin
    with Items[I] do
    begin
      AItemInfo.ImageIndex := ImageIndex;
      AItemInfo.OverlayIndex := OverlayIndex;
      AItemInfo.StateIndex := StateIndex;
      AItemInfo.Tag := Tag;
      AItemInfo.GroupID := GroupID;
      AItemInfo.SubItemCount := SubItems.Count;
      ACaption := Caption;
      AItemInfo.CaptionLength := Length(ACaption);
      AStream.WriteBuffer(AItemInfo, SizeOf(TItemDataInfo));
      AStream.WriteBuffer(ACaption[1], AItemInfo.CaptionLength * SizeOf(Char));
      for J := 0 to SubItems.Count - 1 do
      begin
        ASubItemInfo.ImageIndex := SubItemImages[J];
        ACaption := SubItems[J];
        ASubItemInfo.CaptionLength := Length(ACaption);
        AStream.WriteBuffer(ASubItemInfo, SizeOf(TSubItemDataInfo));
        AStream.WriteBuffer(ACaption[1], ASubItemInfo.CaptionLength * SizeOf(Char));
      end;
    end;
  end;
end;

procedure TdxListItems.Delete(AIndex: Integer);
begin
  Items[AIndex].Delete;
end;

{ TdxListGroup }

constructor TdxListGroup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FGroupID := -1;
  FHeaderAlign := taLeftJustify;
  FFooterAlign := taLeftJustify;
  FTitleImage := -1;
  FOptions := DefaultOptions;
  FItemIndices := TdxIntegerList.Create;
end;

destructor TdxListGroup.Destroy;
begin
  if not ListView.IsDestroying then
    DetachItems;
  FreeAndNil(FItemIndices);
  inherited Destroy;
end;

function TdxListGroup.GetCollectionFromParent(AParent: TComponent): TcxComponentCollection;
begin
  Result := (AParent as TdxCustomListView).Groups;
end;

function TdxListGroup.GetItemCount: Integer;
begin
  Result := FItemIndices.Count;
end;

function TdxListGroup.GetItem(AIndex: Integer): TdxListItem;
begin
  Result := ListView.GetItem(FItemIndices[AIndex]);
end;

procedure TdxListGroup.AddItem(AItem: TdxListItem);
begin
  FItemIndices.Add(AItem.Index);
end;

procedure TdxListGroup.AlphaSort;
begin
  if ListView.FLockCount > 0 then
    ListView.FSortNeedeed := True
  else
    CustomSort(nil, 0);
end;

procedure TdxListGroup.AttachItems;
var
  I: Integer;
  AItem: TdxListItem;
  AItems: TdxListItems;
begin
  if ListView.OwnerData then
    Exit;
  ListView.BeginUpdate;
  try
    AItems := ListView.Items;
    for I := 0 to AItems.Count - 1 do
    begin
      AItem := AItems[I];
      if AItem.GroupID = GroupID then
        AItem.Group := Self;
    end;
  finally
    ListView.EndUpdate;
  end;
end;

procedure TdxListGroup.Assign(Source: TPersistent);
var
  AGroup: TdxListGroup;
begin
  if Safe.Cast(Source, TdxListGroup, AGroup) then
  begin
    FCollapsed := AGroup.Collapsed;
    FHeader := AGroup.Header;
    FFooter := AGroup.Footer;
    FHeaderAlign := AGroup.HeaderAlign;
    FFooterAlign := AGroup.FooterAlign;
    FSubtitle := AGroup.Subtitle;
    FOptions := AGroup.Options;
    FGroupID := AGroup.GroupID;
  end
  else
    inherited Assign(Source);
end;

function TdxListGroup.GetListView: TdxCustomListView;
begin
  if Collection <> nil then
    Result := TdxListGroups(Collection).ListView
  else
    Result := nil;
end;

procedure TdxListGroup.SetCollapsed(const AValue: Boolean);
begin
  if FCollapsed <> AValue then
  begin
    FCollapsed := AValue;
    Changed;
  end;
end;

procedure TdxListGroup.SetFocused(const AValue: Boolean);
begin
  if Focused <> AValue then
  begin
    if AValue and not IsFocusable then
      Exit;
    ListView.Controller.FocusedGroup := Self;
  end;
end;

procedure TdxListGroup.SetHeader(const AValue: string);
begin
  if FHeader <> AValue then
  begin
    FHeader := AValue;
    Changed;
  end;
end;

procedure TdxListGroup.SetFooter(const AValue: string);
begin
  if FFooter <> AValue then
  begin
    FFooter := AValue;
    Changed;
  end;
end;

procedure TdxListGroup.SetHeaderAlign(const AValue: TAlignment);
begin
  if FHeaderAlign <> AValue then
  begin
    FHeaderAlign := AValue;
    Changed;
  end;
end;

procedure TdxListGroup.SetFooterAlign(const AValue: TAlignment);
begin
  if FFooterAlign <> AValue then
  begin
    FFooterAlign := AValue;
    Changed;
  end;
end;

procedure TdxListGroup.SetGroupID(AValue: Integer);
var
  I: Integer;
  AGroups: TdxListGroups;
  AItem: TdxListItem;
begin
  if AValue <> FGroupID then
  begin
    AGroups := Groups;
    for I := 0 to AGroups.Count - 1 do
      if AGroups[I].GroupID = AValue then
        Exit;

    FGroupID := AValue;

    for I := 0 to ItemCount - 1 do
    begin
      AItem := Items[I];
      AItem.FGroupID := AValue;
      AItem.FGroup := Self;
    end;
  end;
end;

procedure TdxListGroup.SetOptions(const AValue: TdxListGroupOptions);
begin
  if FOptions <> AValue then
  begin
    FOptions := AValue;
    if Focused and not IsFocusable then
      ListView.Controller.FocusedGroup := nil;
    Changed;
  end;
end;

procedure TdxListGroup.SetSubtitle(const AValue: string);
begin
  if FSubtitle <> AValue then
  begin
    FSubtitle := AValue;
    Changed;
  end;
end;

procedure TdxListGroup.SetTitleImage(const AValue: TcxImageIndex);
begin
  if FTitleImage <> AValue then
  begin
    FTitleImage := AValue;
    Changed;
  end;
end;

function TdxListGroup.IsCollapsible: Boolean;
begin
  Result := TdxListGroupOption.Collapsible in Options;
end;

function TdxListGroup.IsFocusable: Boolean;
begin
  Result :=
    (TdxListGroupOption.Focusable in Options) and
    not (TdxListGroupOption.Hidden in Options) and
    not (TdxListGroupOption.NoHeader in Options);
end;

function TdxListGroup.GetFocused: Boolean;
begin
  Result := ListView.Controller.FocusedGroup = Self;
end;

function TdxListGroup.GetGroups: TdxListGroups;
begin
  Result := TdxListGroups(Collection);
end;

function TdxListGroup.IsVisible: Boolean;
begin
  Result := not (TdxListGroupOption.Hidden in Options) and (ItemCount > 0);
end;

function TdxListGroup.NeedSelectItems: Boolean;
begin
  Result := (TdxListGroupOption.SelectItems in Options) and (ItemCount > 0);
end;

procedure TdxListGroup.SelectAll;
begin
  SelectRange(0, ItemCount - 1);
end;

procedure TdxListGroup.SelectRange(AFirstIndex, ALastIndex: Integer);
var
  I: Integer;
  AMultiSelect: Boolean;
begin
  AMultiSelect := ListView.MultiSelect;
  ListView.BeginUpdate;
  try
    ListView.ClearSelection;
    for I := AFirstIndex to ALastIndex do
    begin
      ListView.Controller.SelectItem(ItemIndices[I], True);
      if not AMultiSelect and (ListView.SelectedItemCount = 1) then
        Break;
    end;
  finally
    ListView.EndUpdate;
  end;
end;

function TdxListGroup.CustomSort(ASortProc: TdxListViewCompareProc; AData: TdxNativeInt): Boolean;
var
  AListView: TdxCustomListView;
begin
  Result := False;
  if ItemCount > 1 then
  begin
    if not Assigned(ASortProc) then
      ASortProc := @DefaultListViewSort;
    ListView.BeginUpdate;
    try
      AListView := ListView;
      ItemIndices.Sort(
        function (Left, Right: Pointer): Integer
        begin
          Result := ASortProc(
            TdxListItem(AListView.GetItem(Integer(Left))),
            TdxListItem(AListView.GetItem(Integer(Right))), AData);
        end);
      Result := True;
    finally
      ListView.EndUpdate;
    end;
  end;
end;

procedure TdxListGroup.RemoveItem(AItem: TdxListItem);
begin
  FItemIndices.Remove(AItem.Index);
end;

procedure TdxListGroup.Changed;
var
  AListView: TdxCustomListView;
begin
  AListView := ListView;
  if (AListView <> nil) and not (csLoading in ListView.ComponentState) then
    ListView.UpdateGroups;
end;

procedure TdxListGroup.DetachItems;
var
  I: Integer;
  AItem: TdxListItem;
  AItems: TdxListItems;
begin
  if ListView.OwnerData then
    Exit;
  AItems := ListView.Items;
  for I := 0 to AItems.Count - 1 do
  begin
    AItem := AItems[I];
    if AItem.GroupID = GroupID then
      AItem.GroupID := -1;
  end;
end;

function TdxListGroup.GetDisplayName: string;
begin
  Result := Header;
  if Result = '' then
    Result := inherited GetDisplayName;
end;

{ TdxListGroups }

constructor TdxListGroups.Create(AParentComponent: TComponent; AItemClass: TcxComponentCollectionItemClass);
begin
  inherited Create(AParentComponent, AItemClass);
  FListView := TdxCustomListView(AParentComponent);
end;

function TdxListGroups.Add: TdxListGroup;
begin
  Result := TdxListGroup(inherited Add);
end;

function TdxListGroups.FindByHeader(const AHeader: string; out AGroup: TdxListGroup): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to Count - 1 do
  begin
    Result := SameText(Items[I].Header, AHeader);
    if Result then
    begin
      AGroup := Items[I];
      Break;
    end;
  end;
end;

function TdxListGroups.FindByGroupID(AGroupID: Integer): TdxListGroup;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if Items[I].GroupID = AGroupID then
      Exit(Items[I]);
  Result := nil;
end;

function TdxListGroups.GetFirstVisibleGroup: TdxListGroup;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if Items[I].IsVisible then
      Exit(Items[I]);
  Result := nil;
end;

function TdxListGroups.GetNextGroupID: Integer;
label
  NextTry;
var
  I: Integer;
begin
  Result := 0;
NextTry:
  for I := 0 to Count - 1 do
    if Items[I].GroupID = Result then
    begin
      Inc(Result);
      goto NextTry;
    end;
end;

function TdxListGroups.GetGroupAtPos(const P: TPoint): TdxListGroup;
var
  AViewInfo: TdxListGroupCustomViewInfo;
begin
  if ListView.GroupView and ListView.ViewInfo.GetGroupAtPos(P, AViewInfo) then
    Result := AViewInfo.Group
  else
    Result := nil;
end;

function TdxListGroups.GetItemAtPos(const P: TPoint): TdxListItem;
var
  AViewInfo: TdxListItemCustomViewInfo;
begin
  if ListView.ViewInfo.GetItemAtPos(P, AViewInfo) then
    Result := AViewInfo.Item
  else
    Result := nil;
end;

procedure TdxListGroups.Notify(AItem: TcxComponentCollectionItem; AAction: TcxComponentCollectionNotification);
var
  AGroup: TdxListGroup;
begin
  inherited Notify(AItem, AAction);
  if AAction = ccnAdded then
  begin
    AGroup := AItem as TdxListGroup;
    AGroup.FGroupID := GetNextGroupID;
    AGroup.AttachItems;
  end;
end;

procedure TdxListGroups.RebuildItems;
var
  I, J, AItemGroupID: Integer;
  AGroup: TdxListGroup;
begin
  if ListView.IsDestroying or not ListView.GroupView then
    Exit;
  for I := 0 to Count - 1 do
    Items[I].ItemIndices.Clear;
  for I := 0 to ListView.Items.Count - 1 do
  begin
    AItemGroupID := ListView.GetItem(I).GroupID;
    for J := 0 to Count - 1 do
    begin
      AGroup := Items[J];
      if AItemGroupID = AGroup.GroupID then
      begin
        AGroup.ItemIndices.Add(I);
        Break;
      end;
    end;
  end;
end;

function TdxListGroups.GetItem(AIndex: Integer): TdxListGroup;
begin
  Result := TdxListGroup(inherited Items[AIndex]);
end;

procedure TdxListGroups.SetItem(AIndex: Integer; AValue: TdxListGroup);
begin
  Items[AIndex].Assign(AValue);
end;

procedure TdxListGroups.SetItemName(AItem: TcxComponentCollectionItem; ABaseIndex: Integer);
begin
  AItem.Name := CreateUniqueName(ParentComponent.Owner, ParentComponent, AItem, 'TdxList', '', Count);
end;

{ TdxListColumn }

constructor TdxListColumn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCreatedOrderIndex := UndefinedCreatedOrderIndex;
  FAlignment := taLeftJustify;
  FHeaderAlignment := taLeftJustify;
  FImageIndex := -1;
  FSortOrder := soNone;
  FWidth := 50;
end;

procedure TdxListColumn.DefineProperties(AFiler: TFiler);
begin
  inherited DefineProperties(AFiler);
  AFiler.DefineProperty('CreatedOrderIndex', ReadCreatedOrderIndex, WriteCreatedOrderIndex, True);
end;

procedure TdxListColumn.Assign(Source: TPersistent);
var
  AColumn: TdxListColumn;
begin
  if Safe.Cast(Source, TdxListColumn, AColumn) then
  begin
    Alignment := AColumn.Alignment;
    Caption := AColumn.Caption;
    HeaderAlignment := AColumn.HeaderAlignment;
    ImageIndex := AColumn.ImageIndex;
    MaxWidth := AColumn.MaxWidth;
    MinWidth := AColumn.MinWidth;
    Width := AColumn.Width;
    SortOrder := AColumn.SortOrder;
  end
  else
    inherited Assign(Source);
end;

procedure TdxListColumn.ApplyBestFit(AVisibleItemsOnly: Boolean = False);
begin
  ListView.ApplyBestFit(Self, AVisibleItemsOnly);
end;

procedure TdxListColumn.Changed(AType: TdxChangeType = ctMedium);
begin
  if (Columns.UpdateCount = 0) and ListView.ColumnsShowing then
    ListView.LayoutChanged(AType);
end;

procedure TdxListColumn.ChangeScale(M, D: Integer);
begin
  FMaxWidth := MulDiv(FMaxWidth, M, D);
  FMinWidth := MulDiv(FMinWidth, M, D);
  FWidth := MulDiv(FWidth, M, D);
end;

function TdxListColumn.GetCollectionFromParent(AParent: TComponent): TcxComponentCollection;
begin
  Result := (AParent as TdxCustomListView).Columns;
end;

function TdxListColumn.GetDisplayName: string;
begin
  Result := Caption;
  if Result = '' then
    Result := inherited GetDisplayName;
end;

function TdxListColumn.GetColumns: TdxListColumns;
begin
  Result := TdxListColumns(Collection);
end;

function TdxListColumn.GetListView: TdxCustomListView;
begin
  if Collection <> nil then
    Result := TdxListColumns(Collection).ListView
  else
    Result := nil;
end;

procedure TdxListColumn.ReadCreatedOrderIndex(AReader: TReader);
begin
  FCreatedOrderIndex := AReader.ReadInteger;
end;

procedure TdxListColumn.SetAlignment(AValue: TAlignment);
begin
  if FAlignment <> AValue then
  begin
    FAlignment := AValue;
    Changed;
  end;
end;


procedure TdxListColumn.SetCaption(const AValue: string);
begin
  if FCaption <> AValue then
  begin
    FCaption := AValue;
    Changed;
  end;
end;

procedure TdxListColumn.SetHeaderAlignment(AValue: TAlignment);
begin
  if FHeaderAlignment <> AValue then
  begin
    FHeaderAlignment := AValue;
    Changed;
  end;
end;

procedure TdxListColumn.SetImageIndex(AValue: TcxImageIndex);
begin
  if FImageIndex <> AValue then
  begin
    FImageIndex := AValue;
    Changed;
  end;
end;

procedure TdxListColumn.SetMaxWidth(AValue: Integer);
begin
  AValue := Max(0, AValue);
  if MinWidth > 0 then
    AValue := Max(MinWidth, AValue);
  if FMaxWidth <> AValue then
  begin
    FMaxWidth := AValue;
    Changed;
  end;
end;

procedure TdxListColumn.SetMinWidth(AValue: Integer);
begin
  AValue := Max(0, AValue);
  if MaxWidth > 0 then
    AValue := Min(MaxWidth, AValue);
  if FMinWidth <> AValue then
  begin
    FMinWidth := AValue;
    Changed;
  end;
end;

procedure TdxListColumn.SetSortOrder(AValue: TdxSortOrder);
begin
  if FSortOrder <> AValue then
  begin
    FSortOrder := AValue;
    Changed;
  end;
end;

procedure TdxListColumn.SetWidth(AValue: Integer);
begin
  if MinWidth <> MaxWidth then
  begin
    AValue := Max(MinWidth, AValue);
    AValue := Min(MaxWidth, AValue);
  end;
  AValue := Max(4, AValue);
  if FWidth <> AValue then
  begin
    FWidth := AValue;
    Changed(ctMedium);
  end;
end;

procedure TdxListColumn.WriteCreatedOrderIndex(AWriter: TWriter);
begin
  AWriter.WriteInteger(FCreatedOrderIndex);
end;

{ TdxListColumns }

constructor TdxListColumns.Create(AParentComponent: TComponent; AItemClass: TcxComponentCollectionItemClass);
begin
  inherited Create(AParentComponent, AItemClass);
  FListView := TdxCustomListView(AParentComponent);
end;

procedure TdxListColumns.BeginUpdate;
begin
  if ListView <> nil then
    ListView.BeginUpdate;
  inherited BeginUpdate;
end;

procedure TdxListColumns.EndUpdate(AForceUpdate: Boolean);
begin
  inherited EndUpdate(AForceUpdate);
  if ListView <> nil then
    ListView.EndUpdate;
end;

function TdxListColumns.Add: TdxListColumn;
begin
  Result := TdxListColumn(inherited Add);
end;

procedure TdxListColumns.ChangeScale(M, D: Integer);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].ChangeScale(M, D);
end;

function TdxListColumns.FindSubItemColumn(ASubItemIndex: Integer): TdxListColumn;
var
  I: Integer;
begin
  for I := Low(FSubItemIndices) to High(FSubItemIndices) do
    if FSubItemIndices[I] = ASubItemIndex then
      Exit(Items[I]);
  Result := nil;
end;

procedure TdxListColumns.Notify(AItem: TcxComponentCollectionItem; AAction: TcxComponentCollectionNotification);
begin
  inherited Notify(AItem, AAction);
  if (AAction in [ccnAdded, ccnExtracted]) and (AItem <> nil) and
    (AItem.ComponentState * [csLoading, csReading, csDestroying] = []) then
  begin
    if AAction = ccnAdded then
      TdxListColumn(AItem).FCreatedOrderIndex := AItem.ID;
    RebuildSubItemIndices;
  end;
end;

procedure TdxListColumns.RebuildSubItemIndices;
var
  AList: TdxFastList;
  I: Integer;
begin
  if Count = 0 then
    Exit;
  AList := TdxFastList.Create(Count);
  try
    for I := 0 to Count - 1 do
      AList.Add(Items[I]);
    AList.SortList(
      function (Item1, Item2: Pointer): Integer
      begin
        Result := TdxListColumn(Item1).FCreatedOrderIndex - TdxListColumn(Item2).FCreatedOrderIndex;
      end);
    SetLength(FSubItemIndices, Count);
    for I := 0 to Count - 1 do
    begin
      FSubItemIndices[I] := I - 1;
      TdxListColumn(AList[I]).FSubItemIndex := I - 1;
    end;
  finally
    AList.Free;
  end;
end;

function TdxListColumns.GetItem(AIndex: Integer): TdxListColumn;
begin
  Result := TdxListColumn(inherited Items[AIndex]);
end;

procedure TdxListColumns.SetItem(AIndex: Integer; AValue: TdxListColumn);
begin
  Items[AIndex].Assign(AValue);
end;

procedure TdxListColumns.SetItemName(AItem: TcxComponentCollectionItem; ABaseIndex: Integer);
begin
  AItem.Name := CreateUniqueName(ParentComponent.Owner, ParentComponent, AItem, 'TdxList', '', Count);
end;

procedure TdxListColumns.Update(AItem: TcxComponentCollectionItem; AAction: TcxComponentCollectionNotification);
begin
  inherited Update(AItem, AAction);
  if (ListView.ComponentState * [csLoading, csReading, csDestroying] = []) then
    ListView.LayoutChanged;
end;

procedure TdxListColumns.ValidateCreateIndices;
var
  AList: TdxFastList;
  AColumn: TdxListColumn;
  I: Integer;
begin
  if Count = 0 then
    Exit;
  AList := TdxFastList.Create(Count);
  try
    for I := 0 to Count - 1 do
    begin
      AColumn := Items[I];
      if AColumn.FCreatedOrderIndex = TdxListColumn.UndefinedCreatedOrderIndex then
        AColumn.FCreatedOrderIndex := AColumn.ID;
      AList.Add(AColumn);
    end;
    AList.SortList(
      function (Item1, Item2: Pointer): Integer
      begin
        Result := TdxListColumn(Item1).FCreatedOrderIndex - TdxListColumn(Item2).FCreatedOrderIndex;
      end);
    for I := 0 to Count - 1 do
      TdxListColumn(AList[I]).FCreatedOrderIndex := I;
  finally
    AList.Free;
  end;
  RebuildSubItemIndices;
end;

{ TdxListViewCustomViewInfo }

constructor TdxListViewCustomViewInfo.Create(AListView: TdxCustomListView);
begin
  inherited Create;
  FListView := AListView;
  FIsDirty := True;
end;

destructor TdxListViewCustomViewInfo.Destroy;
begin
  ListView.HintHelper.UnsubscribeHintObject(Self);
  inherited Destroy;
end;

procedure TdxListViewCustomViewInfo.Calculate(AType: TdxChangeType; const ABounds: TRect);
begin
  FIsRightToLeftConverted := False;
  FBounds := ABounds;
  ResetBounds;
  DoCalculate(AType);
  FIsDirty := False;
end;

procedure TdxListViewCustomViewInfo.Draw(ACanvas: TcxCustomCanvas);
var
  AVisibleBounds: TRect;
begin
  AVisibleBounds := Bounds;
  AVisibleBounds.Intersect(ListView.ViewInfo.Bounds);
  if not AVisibleBounds.IsEmpty and ACanvas.RectVisible(AVisibleBounds) then
  begin
    BeforeDraw(ACanvas);
    DrawContent(ACanvas);
    AfterDraw(ACanvas);
  end;
end;

procedure TdxListViewCustomViewInfo.AfterDraw(ACanvas: TcxCustomCanvas);
begin
end;

procedure TdxListViewCustomViewInfo.BeforeDraw(ACanvas: TcxCustomCanvas);
begin
end;

procedure TdxListViewCustomViewInfo.DoCalculate(AType: TdxChangeType);
begin
end;

procedure TdxListViewCustomViewInfo.DoRightToLeftConversion(const ABounds: TRect);
begin
  FBounds := TdxRightToLeftLayoutConverter.ConvertRect(FBounds, ABounds);
end;

procedure TdxListViewCustomViewInfo.InitializeCanvasBasedElements(AForExternalCanvas: Boolean);
begin
end;

function TdxListViewCustomViewInfo.GetGapBetweenItems: Integer;
begin
  Result := ListView.GetGapBetweenItems;
end;

function TdxListViewCustomViewInfo.GetHitTestBounds: TRect;
begin
  Result := Bounds;
end;

function TdxListViewCustomViewInfo.IsGroupView: Boolean;
begin
  Result := ListView.GroupView;
end;

function TdxListViewCustomViewInfo.IsIconView: Boolean;
begin
  Result := ListView.ViewStyle = TdxListViewStyle.Icon;
end;

function TdxListViewCustomViewInfo.IsReportView: Boolean;
begin
  Result := ListView.ViewStyle = TdxListViewStyle.Report;
end;

procedure TdxListViewCustomViewInfo.RightToLeftConversion(const ABounds: TRect);
begin
  if not IsRightToLeftConverted then
  begin
    DoRightToLeftConversion(ABounds);
    FIsRightToLeftConverted := True;
  end;
end;

procedure TdxListViewCustomViewInfo.ResetBounds;
begin
end;

procedure TdxListViewCustomViewInfo.MakeDirty;
begin
  FIsDirty := True;
end;

procedure TdxListViewCustomViewInfo.Offset(ADX, ADY: Integer);
begin
  FBounds.Offset(ADX, ADY);
end;

procedure TdxListViewCustomViewInfo.CancelHint;
begin
  ListView.HintHelper.CancelHint;
end;

procedure TdxListViewCustomViewInfo.CheckShowHint;
begin
  if NeedShowHint then
    ListView.HintHelper.ActivateHint(Self);
end;

function TdxListViewCustomViewInfo.NeedShowHint: Boolean;
begin
  Result := False;
end;

function TdxListViewCustomViewInfo.IsHintAtMousePos: Boolean;
begin
  Result := False;
end;

function TdxListViewCustomViewInfo.UseHintHidePause: Boolean;
begin
  Result := True;
end;

function TdxListViewCustomViewInfo.HasHintPoint(const P: TPoint): Boolean;
begin
  Result := Bounds.Contains(P);
end;

function TdxListViewCustomViewInfo.ImmediateShowHint: Boolean;
begin
  Result := False;
end;

function TdxListViewCustomViewInfo.GetHintObject: TObject;
begin
  Result := Self;
end;

function TdxListViewCustomViewInfo.GetHintText: string;
begin
  Result := '';
end;

function TdxListViewCustomViewInfo.IsHintMultiLine: Boolean;
begin
  Result := False;
end;

function TdxListViewCustomViewInfo.GetHintFont: TFont;
begin
   Result := nil;
end;

function TdxListViewCustomViewInfo.GetHintAreaBounds: TRect;
begin
  Result := Bounds;
end;

function TdxListViewCustomViewInfo.GetHintTextBounds: TRect;
begin
  Result := Bounds;
end;

procedure TdxListViewCustomViewInfo.MouseDown(AButton: TMouseButton; AShift: TShiftState; const AMousePos: TPoint);
begin
end;

procedure TdxListViewCustomViewInfo.MouseLeave;
begin
  CancelHint;
end;

procedure TdxListViewCustomViewInfo.MouseMove(AShift: TShiftState; const AMousePos: TPoint);
begin
end;

procedure TdxListViewCustomViewInfo.MouseUp(AButton: TMouseButton; AShift: TShiftState; const AMousePos: TPoint);
begin
end;

procedure TdxListViewCustomViewInfo.Invalidate;
begin
  ListView.InvalidateRect(Bounds, True);
end;

procedure TdxListViewCustomViewInfo.PaintTo(ACanvas: TcxCanvas);
begin
  FExternalCanvas := ACanvas;
  try
    InitializeCanvasBasedElements(True);
    Calculate(ctHard, Bounds);
    if ListView.UseRightToLeftReading then
      RightToLeftConversion(Bounds);
    Draw(ACanvas);
  finally
    FExternalCanvas := nil;
    InitializeCanvasBasedElements(False);
    Calculate(ctHard, Bounds);
    if ListView.UseRightToLeftReading then
      RightToLeftConversion(Bounds);
  end;
end;

procedure TdxListViewCustomViewInfo.Repaint;
begin
  Invalidate;
  ListView.Update;
end;

function TdxListViewCustomViewInfo.GetController: TdxListViewController;
begin
  Result := ListView.Controller;
end;

function TdxListViewCustomViewInfo.GetExplorerStyle: Boolean;
begin
  Result := ListView.ExplorerStyle;
end;

function TdxListViewCustomViewInfo.GetLookAndFeelPainter: TcxCustomLookAndFeelPainter;
begin
  Result := ListView.LookAndFeelPainter;
end;

function TdxListViewCustomViewInfo.GetPainter: TdxListViewPainter;
begin
  Result := ListView.Painter;
end;

function TdxListViewCustomViewInfo.GetScaleFactor: TdxScaleFactor;
begin
  Result := ListView.ScaleFactor;
end;

function TdxListViewCustomViewInfo.GetUseRightToLeftAlignment: Boolean;
begin
  Result := ListView.UseRightToLeftAlignment;
end;

{ TdxListViewCellViewInfo }

constructor TdxListViewCellViewInfo.Create(AListView: TdxCustomListView; const AViewParams: TdxListViewCellViewParams);
begin
  inherited Create(AListView);
  FViewParams := AViewParams;
end;

destructor TdxListViewCellViewInfo.Destroy;
begin
  FreeAndNil(FTextLayout);
  inherited Destroy;
end;

procedure TdxListViewCellViewInfo.CalculateContentBounds;
begin
  FContentBounds := Bounds;
  FContentBounds.Deflate(FViewParams.Padding);
end;

procedure TdxListViewCellViewInfo.CalculateGlyphsAreaBounds;
begin
  FGlyphsAreaBounds := CalculateBoundsCore(ContentBounds, Bounds,
    ViewParams.GlyphsAreaSize, OppositePositionMap[ViewParams.TextPosition]);
end;

function TdxListViewCellViewInfo.CalculateBoundsCore(const ABounds, AFullBounds: TRect;
  const ASize: TSize; APosition: TcxPosition): TRect;
var
  AAnchor: TPoint;
begin
  if ABounds.IsEmpty then
  begin
    Result.Empty;
    Exit;
  end;
  AAnchor.Init(
    ABounds.Left + (ABounds.Width - ASize.cx) div 2,
    ABounds.Top + (ABounds.Height - ASize.cy) div 2);
  case APosition of
    posNone:
      Result := cxRectCenter(AFullBounds, ASize);
    posLeft:
      begin
        Result.Init(
          ABounds.Left,
          AAnchor.Y,
          ABounds.Left + ASize.cx,
          AAnchor.Y + ASize.cy);
      end;
    posRight:
      begin
        Result.Init(
          ABounds.Right - ASize.cx,
          AAnchor.Y,
          ABounds.Right,
          AAnchor.Y + ASize.cy);
      end;
    posTop:
      begin
        Result.Init(
          AAnchor.X,
          ABounds.Top,
          AAnchor.X + ASize.cx,
          ABounds.Top + ASize.cy);
      end;
    posBottom:
      begin
        Result.Init(
          AAnchor.X,
          ABounds.Bottom - ASize.cy,
          AAnchor.X + ASize.cx,
          ABounds.Bottom);
      end;
  end;
end;

procedure TdxListViewCellViewInfo.CalculateGlyphBounds(const ABounds: TRect);
begin
  if HasGlyph then
    FGlyphBounds := cxRectCenter(ABounds, ViewParams.GlyphSize)
  else
    FGlyphBounds.Empty;
end;

procedure TdxListViewCellViewInfo.CalculateGlyphsBounds(const ABounds: TRect);
begin
  CalculateGlyphBounds(ABounds);
end;

procedure TdxListViewCellViewInfo.CalculateTextAndGlyphLayout;
begin
  CalculateGlyphsBounds(FGlyphsAreaBounds);
  CalculateTextAreaBounds(FContentBounds);
end;

procedure TdxListViewCellViewInfo.CalculateTextBounds;
var
  ATextSize: TSize;
  ATextBox: TRect;
  ATextFlags: Integer;
begin
  if TextLayout <> nil then
  begin
    FTextLayout.SetLayoutConstraints(TextAreaBounds.Width, 0, ViewParams.TextLineCount);
    ATextSize := TextLayout.MeasureSize;
    ATextBox.InitSize(TextBounds.Left, TextBounds.Top, ATextSize);
    ATextFlags := GetTextFlags;
    if (CXTO_CENTER_HORIZONTALLY and ATextFlags) <> 0 then
      ATextBox.Offset((TextBounds.Width - ATextSize.cx) div 2, 0)
    else if (CXTO_RIGHT and ATextFlags) <> 0 then
      ATextBox.Offset(TextBounds.Width - ATextSize.cx, 0);
    if (CXTO_CENTER_VERTICALLY and ATextFlags) <> 0 then
      ATextBox.Offset(0, (TextBounds.Height - ATextSize.cy) div 2);
    ATextBox.Inflate(1, 0);
    FTextBounds := ATextBox;
  end;
end;

function TdxListViewCellViewInfo.CreateTextLayout: TcxCanvasBasedTextLayout;
begin
  if ExternalCanvas = nil then
    Result := Painter.CreateCanvasBasedTextLayout
  else
    Result := ExternalCanvas.CreateTextLayout;
end;

procedure TdxListViewCellViewInfo.InitializeCanvasBasedElements(AForExternalCanvas: Boolean);
begin
  FreeAndNil(FTextLayout);
  Initialize(FText, FImageIndex, AForExternalCanvas);
end;

procedure TdxListViewCellViewInfo.DirectSetImageIndex(AImageIndex: Integer);
begin
  FImageIndex := AImageIndex;
end;

function TdxListViewCellViewInfo.HasGlyph: Boolean;
begin
  Result := not ViewParams.GlyphSize.IsZero;
end;

function TdxListViewCellViewInfo.HasStateGlyph: Boolean;
begin
  Result := not ViewParams.StateGlyphSize.IsZero;
end;

procedure TdxListViewCellViewInfo.UpdateBounds;
begin
  if (TextLayout <> nil) and (ViewParams.TextPosition = posBottom) then
  begin
    FContentBounds.Bottom := FTextBounds.Bottom;
    FBounds.Bottom := Min(FBounds.Bottom, FTextBounds.Bottom + ViewParams.Padding.Bottom);
    FTextAreaBounds.Intersect(FContentBounds);
  end;
end;

procedure TdxListViewCellViewInfo.CalculateTextAreaBounds(const ABounds: TRect);
begin
  if HasGlyph or HasStateGlyph then
  begin
    case ViewParams.TextPosition of
      posNone:
        FTextAreaBounds.Empty;
      posLeft:
        begin
          FTextAreaBounds.Init(
            ABounds.Left,
            ABounds.Top,
            ABounds.Right - (FGlyphsAreaBounds.Width + ViewParams.GlyphIndent.cx),
            ABounds.Bottom);
        end;
      posRight:
        begin
          FTextAreaBounds.Init(
            ABounds.Left + FGlyphsAreaBounds.Width + ViewParams.GlyphIndent.cx,
            ABounds.Top,
            ABounds.Right,
            ABounds.Bottom);
        end;
      posTop:
        begin
          FTextAreaBounds.Init(
            ABounds.Left,
            ABounds.Top,
            ABounds.Right,
            ABounds.Bottom - (FGlyphsAreaBounds.Height + ViewParams.GlyphIndent.cy));
        end;
      posBottom:
        begin
          FTextAreaBounds.Init(
            ABounds.Left,
            ABounds.Top + FGlyphsAreaBounds.Height + ViewParams.GlyphIndent.cy,
            ABounds.Right,
            ABounds.Bottom);
        end;
    end;
  end
  else
    FTextAreaBounds := ABounds;
  if FTextAreaBounds.IsEmpty then
    FTextAreaBounds := TRect.Null;
  FTextBounds := TextAreaBounds;
end;

procedure TdxListViewCellViewInfo.DoCalculate(AType: TdxChangeType);
begin
  inherited DoCalculate(AType);
  CalculateContentBounds;
  if FContentBounds.IsEmpty then
    Exit;
  CalculateGlyphsAreaBounds;
  CalculateTextAndGlyphLayout;
  CalculateTextBounds;
  UpdateBounds;
end;

procedure TdxListViewCellViewInfo.DoRightToLeftConversion(const ABounds: TRect);
begin
  inherited DoRightToLeftConversion(ABounds);
  FContentBounds := TdxRightToLeftLayoutConverter.ConvertRect(FContentBounds, ABounds);
  FGlyphBounds := TdxRightToLeftLayoutConverter.ConvertRect(FGlyphBounds, ABounds);
  FTextAreaBounds := TdxRightToLeftLayoutConverter.ConvertRect(FTextAreaBounds, ABounds);
  FTextBounds := TdxRightToLeftLayoutConverter.ConvertRect(FTextBounds, ABounds);
  FGlyphsAreaBounds := TdxRightToLeftLayoutConverter.ConvertRect(FGlyphsAreaBounds, ABounds);
end;

procedure TdxListViewCellViewInfo.DrawContent(ACanvas: TcxCustomCanvas);
begin
  DrawGlyph(ACanvas);
  DrawText(ACanvas);
end;

procedure TdxListViewCellViewInfo.DrawGlyphCore(ACanvas: TcxCustomCanvas; const ABounds: TRect;
  AImages: TCustomImageList; AImageIndex, AOverlayIndex: Integer; AMode: TcxImageDrawMode;
  AAlpha: Byte; const AColorPalette: IdxColorPalette);
begin
  if AImages <> nil then
  begin
    if ExternalCanvas <> nil then
      TdxImageDrawer.DrawImage(ExternalCanvas, ABounds, nil, AImages, AImageIndex, True, AColorPalette, ScaleFactor)
    else
      Painter.DrawGlyphCore(ACanvas, ABounds, AImages, AImageIndex, AOverlayIndex, AMode, AAlpha, AColorPalette);
  end;
end;

procedure TdxListViewCellViewInfo.DrawGlyph(ACanvas: TcxCustomCanvas);
begin
  DrawGlyphCore(ACanvas, GlyphBounds, ViewParams.Images, FImageIndex, -1, GetGlyphState, GetGlyphAlpha, GetColorPalette);
end;

procedure TdxListViewCellViewInfo.DrawText(ACanvas: TcxCustomCanvas);
begin
  if (TextLayout <> nil) and not TextBounds.IsEmpty then
  begin
    TextLayout.SetColor(GetTextColor);
    TextLayout.Draw(TextBounds);
  end;
end;

function TdxListViewCellViewInfo.GetColorPalette: IdxColorPalette;
begin
  Result := nil;
end;

function TdxListViewCellViewInfo.GetGlyphAlpha: Byte;
begin
  Result := 255;
end;

function TdxListViewCellViewInfo.GetGlyphState: TcxImageDrawMode;
begin
  Result := idmNormal;
end;

function TdxListViewCellViewInfo.GetTextFlags: Integer;
begin
  Result := ViewParams.TextFlags;
end;

function TdxListViewCellViewInfo.GetOrigin: TPoint;
begin
  Result := FBounds.TopLeft;
end;

procedure TdxListViewCellViewInfo.Initialize(const AText: string; AImageIndex: Integer; AForExternalCanvas: Boolean = False);
begin
  if AText = '' then
    FreeAndNil(FTextLayout)
  else
  begin
    if FTextLayout = nil then
      FTextLayout := CreateTextLayout;
    FTextLayout.SetText(AText);
    FTextLayout.SetFlags(GetTextFlags);
    if AForExternalCanvas then
      FTextLayout.SetFont(ViewParams.GdiFont)
    else
      FTextLayout.SetFont(ViewParams.Font);
  end;

  if not IsImageAssigned(ViewParams.Images, AImageIndex) then
    AImageIndex := -1;
  FImageIndex := AImageIndex;
  FText := AText;
  MakeDirty;
end;

procedure TdxListViewCellViewInfo.Offset(ADX, ADY: Integer);
begin
  inherited Offset(ADX, ADY);
  FContentBounds.Offset(ADX, ADY);
  FGlyphsAreaBounds.Offset(ADX, ADY);
  FGlyphBounds.Offset(ADX, ADY);
  FTextAreaBounds.Offset(ADX, ADY);
  FTextBounds.Offset(ADX, ADY);
end;

procedure TdxListViewCellViewInfo.ResetBounds;
begin
  FContentBounds.Empty;
  FGlyphBounds.Empty;
  FGlyphsAreaBounds.Empty;
  FTextAreaBounds.Empty;
  FTextBounds.Empty;
end;

function TdxListViewCellViewInfo.GetHintTextBounds: TRect;
begin
  Result := TextBounds;
end;

procedure TdxListViewCellViewInfo.MouseDown(AButton: TMouseButton; AShift: TShiftState; const AMousePos: TPoint);
begin
end;

procedure TdxListViewCellViewInfo.MouseLeave;
begin
  Invalidate;
end;

procedure TdxListViewCellViewInfo.MouseMove(AShift: TShiftState; const AMousePos: TPoint);
begin
end;

procedure TdxListViewCellViewInfo.MouseUp(AButton: TMouseButton; AShift: TShiftState; const AMousePos: TPoint);
begin
end;

procedure TdxListViewCellViewInfo.SetOrigin(const P: TPoint);
begin
  Offset(P.X - FBounds.Left, P.Y - FBounds.Top);
end;

{ TdxListItemCustomViewInfo }

constructor TdxListItemCustomViewInfo.Create(AOwner: TdxListGroupCustomViewInfo; const AItemIndex: Integer;
  const AViewParams: TdxListViewCellViewParams);
begin
  inherited Create(AOwner.ListView, AViewParams);
  FOwner := AOwner;
  FItemIndex := AItemIndex;
end;

function TdxListItemCustomViewInfo.GetColorPalette: IdxColorPalette;
begin
  Result := LookAndFeelPainter.GetListViewItemColorPalette(FState);
end;

function TdxListItemCustomViewInfo.GetGlyphAlpha: Byte;
begin
  Result := IfThen(CachedItem.Cut, 128, 255);
end;

function TdxListItemCustomViewInfo.GetItem: TdxListItem;
begin
  Result := ListView.GetItem(FItemIndex);
end;

procedure TdxListItemCustomViewInfo.BeforeDraw(ACanvas: TcxCustomCanvas);
begin
  inherited BeforeDraw(ACanvas);
  FCachedItem := GetItem;
  FState := GetState;
end;

function TdxListItemCustomViewInfo.DrawCheckAsOverlay: Boolean;
begin
  Result := (ViewParams.StateViewKind = TdxListItemStateViewKind.CheckBox) and Owner.Owner.IsOverlappedItemStateGlyph;
end;

procedure TdxListItemCustomViewInfo.CalculateStateBounds;
begin
  FStateBounds.Empty;
  CalculateStateGlyphBounds;
  FStateBounds := FStateGlyphBounds;
  if not IsIconView then
  begin
    FStateBounds.Top := Bounds.Top;
    FStateBounds.Bottom := Bounds.Bottom;
  end;
end;

procedure TdxListItemCustomViewInfo.CalculateStateGlyphBounds;
var
  R: TRect;
  ASize: TSize;
begin
  if ViewParams.StateViewKind = TdxListItemStateViewKind.None then
    FStateGlyphBounds.Empty
  else if DrawCheckAsOverlay then
    FStateGlyphBounds.InitSize(GlyphsAreaBounds.TopLeft, ViewParams.StateGlyphSize)
  else
  begin
    ASize.Init(
      ViewParams.GlyphSize.cx + ViewParams.StateGlyphSize.cx + ViewParams.GlyphIndent.cx,
      Max(ViewParams.GlyphSize.cy, ViewParams.StateGlyphSize.cy));
    R := cxRectCenter(GlyphsAreaBounds, ASize);
    FStateGlyphBounds := CalculateBoundsCore(R, GlyphsAreaBounds,
      ViewParams.StateGlyphSize, posLeft);
  end;
end;

procedure TdxListItemCustomViewInfo.CalculateGlyphsBounds(const ABounds: TRect);
var
  R: TRect;
begin
  if ViewParams.StateViewKind = TdxListItemStateViewKind.None then
    inherited CalculateGlyphsBounds(ABounds)
  else
  begin
    CalculateStateBounds;
    R := ABounds;
    if DrawCheckAsOverlay then
      FGlyphBounds := CalculateBoundsCore(R, GlyphsAreaBounds, ViewParams.GlyphSize, posNone)
    else
    begin
      R.Left := FStateGlyphBounds.Right + ViewParams.GlyphIndent.cx;
      FGlyphBounds := CalculateBoundsCore(R, GlyphsAreaBounds, ViewParams.GlyphSize, posLeft);
    end;
  end;
end;

procedure TdxListItemCustomViewInfo.DoRightToLeftConversion(const ABounds: TRect);
begin
  inherited DoRightToLeftConversion(ABounds);
  FStateBounds := TdxRightToLeftLayoutConverter.ConvertRect(FStateBounds, ABounds);
  FStateGlyphBounds := TdxRightToLeftLayoutConverter.ConvertRect(FStateGlyphBounds, ABounds);
end;

procedure TdxListItemCustomViewInfo.DrawBackground(ACanvas: TcxCustomCanvas);
begin
  Painter.DrawItemBackground(ACanvas, Self);
end;

procedure TdxListItemCustomViewInfo.DrawStateGlyph(ACanvas: TcxCustomCanvas);
const
  CheckBoxMap: array[Boolean] of TcxButtonState = (cxbsDisabled, cxbsNormal);
var
  AGlyphState: TcxButtonState;
  AChecked: Boolean;
begin
  case ViewParams.StateViewKind of
    TdxListItemStateViewKind.CheckBox:
      begin
        if (State * [dxlisHot, dxlisSelected] <> []) or not ExplorerStyle then
        begin
          if FHotTrackPart = TdxListItemHitTest.StateGlyph then
            AGlyphState := cxbsHot
          else
            AGlyphState := CheckBoxMap[CachedItem.IsEnabled];
          if ExplorerStyle then
            AChecked := CachedItem.Selected
          else
            AChecked := CachedItem.Checked;
          Painter.DrawCheckButton(ACanvas, StateGlyphBounds, AGlyphState, AChecked);
        end;
      end;
    TdxListItemStateViewKind.Glyph:
      DrawGlyphCore(ACanvas, StateGlyphBounds, ViewParams.StateImages, CachedItem.StateIndex, -1, idmNormal, GetGlyphAlpha, GetColorPalette);
  end;
end;

procedure TdxListItemCustomViewInfo.DrawText(ACanvas: TcxCustomCanvas);
begin
  if ListView.IsEditingItem(ItemIndex) then
    Exit;
  inherited DrawText(ACanvas);
end;

function TdxListItemCustomViewInfo.GetState: TdxListViewItemStates;
var
  AIsDropTarget: Boolean;
begin
  Result := [];
  if not ListView.Enabled then
    Include(Result, dxlisDisabled);
  AIsDropTarget := ListView.IsDropTargetItem(ItemIndex);
  if not (AIsDropTarget or ListView.IsActive) then
    Include(Result, dxlisInactive);
  if CachedItem.Focused and not ListView.IsEditingItem(ItemIndex) then
    Include(Result, dxlisFocused);
  if AIsDropTarget or CachedItem.Selected then
    Include(Result, dxlisSelected);
  if IsHovered then
    Include(Result, dxlisHot);
end;

function TdxListItemCustomViewInfo.GetTextColor: TColor;
begin
  Result := ListView.Fonts.Item.Color;
  if Result = clDefault then
    Result := ListView.LookAndFeel.Painter.GetListViewItemTextColor(State, ExplorerStyle);
end;

procedure TdxListItemCustomViewInfo.Initialize(AItem: TdxListItem);
begin
  Initialize(AItem.Caption, AItem.ImageIndex);
end;

function TdxListItemCustomViewInfo.IsHovered: Boolean;
begin
  Result :=
    not ListView.IsDragging and
    (ListView.Controller.MouseHoveredItemIndex = ItemIndex) and
    (ExplorerStyle or (FHotTrackPart <> TdxListItemHitTest.StateGlyph));
end;

procedure TdxListItemCustomViewInfo.DrawContent(ACanvas: TcxCustomCanvas);
begin
  DrawBackground(ACanvas);
  inherited DrawContent(ACanvas);
  DrawStateGlyph(ACanvas);
end;


procedure TdxListItemCustomViewInfo.DrawGlyph(ACanvas: TcxCustomCanvas);
var
  AImageIndex: Integer;
begin
  if Assigned(ListView.OnGetImageIndex) then
  begin
    AImageIndex := FCachedItem.ImageIndex;
    ListView.OnGetImageIndex(ListView, FCachedItem, AImageIndex);
    FCachedItem.FImageIndex := AImageIndex;
  end;

  DrawGlyphCore(ACanvas, GlyphBounds, ViewParams.Images, CachedItem.ImageIndex,
    CachedItem.OverlayIndex, GetGlyphState, GetGlyphAlpha, GetColorPalette);
end;

function TdxListItemCustomViewInfo.GetHitTest(const P: TPoint): TdxListItemHitTest;
begin
  Result := TdxListItemHitTest.None;
  if Bounds.Contains(P) then
  begin
    if TextBounds.Contains(P) then
      Result := TdxListItemHitTest.Text
    else if GlyphBounds.Contains(P) then
      Result := TdxListItemHitTest.Glyph
    else if StateBounds.Contains(P) then
      Result := TdxListItemHitTest.StateGlyph
    else if ContentBounds.Contains(P) then
      Result := TdxListItemHitTest.Content;
  end;
end;

procedure TdxListItemCustomViewInfo.Offset(ADX, ADY: Integer);
begin
  inherited Offset(ADX, ADY);
  FStateBounds.Offset(ADX, ADY);
  FStateGlyphBounds.Offset(ADX, ADY);
end;

function TdxListItemCustomViewInfo.NeedShowHint: Boolean;
begin
  Result := Assigned(ListView.OnInfoTip) or ((TextLayout <> nil) and TextLayout.IsTruncated);
end;

function TdxListItemCustomViewInfo.GetHintFont: TFont;
begin
  Result := ListView.Fonts.Item;
end;

function TdxListItemCustomViewInfo.GetHintableObject(const AMousePos: TPoint): TdxListViewCustomViewInfo;
begin
  Result := Self;
end;

function TdxListItemCustomViewInfo.GetHintText: string;
begin
  Result := Text;
  if Assigned(ListView.OnInfoTip) then
    ListView.DoInfoTip(ListView.GetItem(ItemIndex), Result);
end;

procedure TdxListItemCustomViewInfo.InvalidatePart(APart: TdxListItemHitTest);
begin
  case APart of
    TdxListItemHitTest.StateGlyph:
      ListView.InvalidateRect(StateGlyphBounds, True);
  else
    Invalidate;
  end;
end;

procedure TdxListItemCustomViewInfo.MouseLeave;
begin
  HotTrackPart := TdxListItemHitTest.None;
  Invalidate;
end;

procedure TdxListItemCustomViewInfo.MouseMove(AShift: TShiftState; const AMousePos: TPoint);
begin
  HotTrackPart := GetHitTest(AMousePos);
end;

function TdxListItemCustomViewInfo.StartDrag(AShift: TShiftState; const AMousePos: TPoint): Boolean;
begin
  Result := GetHitTest(AMousePos) in [TdxListItemHitTest.Text, TdxListItemHitTest.Glyph];
end;

function TdxListItemCustomViewInfo.StartEdit(AShift: TShiftState; const AMousePos: TPoint): Boolean;
begin
  Result := TextBounds.Contains(AMousePos);
end;

function TdxListItemCustomViewInfo.StartMultiSelection(AShift: TShiftState; const AMousePos: TPoint): Boolean;
begin
  Result := not (TextBounds.Contains(AMousePos) or GlyphsAreaBounds.Contains(AMousePos) or
    Controller.IsItemSelected(ItemIndex));
end;

procedure TdxListItemCustomViewInfo.SetHotTrackPart(AValue: TdxListItemHitTest);
begin
  if FHotTrackPart <> AValue then
  begin
    InvalidatePart(FHotTrackPart);
    InvalidatePart(AValue);
    FHotTrackPart := AValue;
  end;
end;

{ TdxListSubItemViewInfo }

constructor TdxListSubItemViewInfo.Create(AOwner: TdxListItemReportStyleViewInfo;
  const AViewParams: TdxListViewCellViewParams);
begin
  inherited Create(AOwner.ListView, AViewParams);
  FOwner := AOwner;
end;

procedure TdxListSubItemViewInfo.CalculateGlyphsAreaBounds;
var
  ASize: TSize;
begin
  ASize := ViewParams.GlyphsAreaSize;
  ASize.cx := ViewParams.GlyphSize.cx;
  FGlyphsAreaBounds := CalculateBoundsCore(ContentBounds, Bounds, ASize, OppositePositionMap[ViewParams.TextPosition]);
end;

procedure TdxListSubItemViewInfo.DrawContent(ACanvas: TcxCustomCanvas);

  procedure DoOnGetSubItemImageIndex;
  var
    AImageIndex: Integer;
    AItem: TdxListItem;
    APrevImageIndex: Integer;
    ASubItemViewInfo: TdxListSubItemViewInfo;
    ASubItemIndex: Integer;
  begin
    if Assigned(ListView.OnGetSubItemImageIndex) then
    begin
      ASubItemViewInfo := TdxListSubItemViewInfo(Self);
      AItem := ListView.GetItem(ASubItemViewInfo.Owner.ItemIndex);
      ASubItemIndex := ListView.Columns[ASubItemViewInfo.ColumnIndex].FSubItemIndex;
      AImageIndex := AItem.SubItemImages[ASubItemIndex];
      APrevImageIndex := AImageIndex;
      ListView.OnGetSubItemImageIndex(ListView, AItem, ASubItemIndex, AImageIndex);
      AItem.DirectSetSubItemImage(ASubItemIndex, AImageIndex);
      ASubItemViewInfo.DirectSetImageIndex(AImageIndex);

      if (AImageIndex <> APrevImageIndex) and ((APrevImageIndex = -1) or (AImageIndex = -1)) then
      begin
        Calculate(ctHard, Bounds);
        if ListView.UseRightToLeftAlignment then
          RightToLeftConversion(Bounds);
      end;
    end;
  end;

var
  AClippingBound: TRect;
begin
  if not Owner.SharedBackground then
    LookAndFeelPainter.DrawListViewBackground(ACanvas, Bounds, ExplorerStyle, ListView.Enabled);
  AClippingBound := Bounds;
  AClippingBound.Deflate(1);
  if not AClippingBound.IsEmpty then
  begin
    DoOnGetSubItemImageIndex;
    ACanvas.SaveClipRegion;
    ACanvas.IntersectClipRect(AClippingBound);
    inherited DrawContent(ACanvas);
    ACanvas.RestoreClipRegion;
  end;
end;

function TdxListSubItemViewInfo.GetColorPalette: IdxColorPalette;
begin
  Result := LookAndFeelPainter.GetListViewItemColorPalette(Owner.FState);
end;

function TdxListSubItemViewInfo.GetTextColor: TColor;
begin
  Result := ListView.Fonts.SubItem.Color;
  if Result = clDefault then
    if ListView.ViewStyleReport.RowSelect then
      Result := Owner.GetTextColor
    else
      Result := LookAndFeelPainter.GetListViewItemTextColor([], ExplorerStyle);
end;

function TdxListSubItemViewInfo.GetTextFlags: Integer;
begin
  Result := Owner.GetColumnTextFlags(ColumnIndex);
end;

function TdxListSubItemViewInfo.HasGlyph: Boolean;
begin
  Result := inherited HasGlyph and (ImageIndex >= 0);
end;

function TdxListSubItemViewInfo.HasStateGlyph: Boolean;
begin
  Result := False;
end;

procedure TdxListSubItemViewInfo.Initialize(AColumnIndex: Integer;
  const AText: string; AImageIndex: Integer);
begin
  FColumnIndex := AColumnIndex;
  inherited Initialize(AText, AImageIndex);
end;

function TdxListSubItemViewInfo.GetHintFont: TFont;
begin
  Result := ListView.Fonts.SubItem;
end;

function TdxListSubItemViewInfo.GetHintText: string;
begin
  Result := Text;
end;

function TdxListSubItemViewInfo.GetHintTextBounds: TRect;
begin
  Result := TextBounds;
end;

function TdxListSubItemViewInfo.NeedShowHint: Boolean;
begin
  Result := (TextLayout <> nil) and TextLayout.IsTruncated;
end;

{ TdxListItemReportStyleViewInfo }

constructor TdxListItemReportStyleViewInfo.Create(AOwner: TdxListGroupCustomViewInfo;
  const AItemIndex: Integer; const AViewParams: TdxListViewCellViewParams);
begin
  inherited Create(AOwner, AItemIndex, AViewParams);
  FSubItems := TdxFastObjectList.Create(True, ListView.Columns.Count);
end;

destructor TdxListItemReportStyleViewInfo.Destroy;
begin
  FreeAndNil(FSubItems);
  inherited Destroy;
end;

function TdxListItemReportStyleViewInfo.GetHitTest(const P: TPoint): TdxListItemHitTest;
var
  I: Integer;
begin
  for I := 0 to SubItemCount - 1 do
    if SubItems[I].Bounds.Contains(P) then
      Exit(TdxListItemHitTest.SubItemText);
  Result := inherited GetHitTest(P);
end;

function TdxListItemReportStyleViewInfo.GetSubItem(Index: Integer): TdxListSubItemViewInfo;
begin
  Result := TdxListSubItemViewInfo(FSubItems.List[Index]);
end;

function TdxListItemReportStyleViewInfo.GetSubItemCount: Integer;
begin
  Result := FSubItems.Count;
end;

function TdxListItemReportStyleViewInfo.GetTextFlags: Integer;
begin
  Result := GetColumnTextFlags(FColumnIndex);
end;

function TdxListItemReportStyleViewInfo.HasGlyph: Boolean;
begin
  Result := inherited HasGlyph and not FHiddenGlyph;
end;

function TdxListItemReportStyleViewInfo.HasStateGlyph: Boolean;
begin
  Result := inherited HasStateGlyph and not FHiddenGlyph;
end;

procedure TdxListItemReportStyleViewInfo.AddSubItem(AViewInfo: TdxListSubItemViewInfo);
begin
  FSubItems.Add(AViewInfo);
end;

procedure TdxListItemReportStyleViewInfo.BeforeDraw(ACanvas: TcxCustomCanvas);
begin
  inherited BeforeDraw(ACanvas);
  FSharedBackground := ListView.ViewStyleReport.RowSelect;
end;

procedure TdxListItemReportStyleViewInfo.CalculateStateGlyphBounds;
var
  AGlyphsAreaBounds, R: TRect;
  ASize: TSize;
begin
  if FStateButtonInSubItem and (ViewParams.StateViewKind <> TdxListItemStateViewKind.None) then
  begin
    ASize.Init(
      ViewParams.GlyphSize.cx + ViewParams.StateGlyphSize.cx + ViewParams.GlyphIndent.cx,
      Max(ViewParams.GlyphSize.cy, ViewParams.StateGlyphSize.cy));

    R := Bounds;
    R.Deflate(ViewParams.Padding);
    AGlyphsAreaBounds := CalculateBoundsCore(R, Bounds,
      ViewParams.GlyphsAreaSize, OppositePositionMap[ViewParams.TextPosition]);
    R := cxRectCenter(AGlyphsAreaBounds, ASize);
    FStateGlyphBounds := CalculateBoundsCore(R, AGlyphsAreaBounds,
      ViewParams.StateGlyphSize, posLeft);
  end
  else
    inherited CalculateStateGlyphBounds;
end;

procedure TdxListItemReportStyleViewInfo.CalculateGlyphsAreaBounds;
var
  AWidth: Integer;
begin
  inherited CalculateGlyphsAreaBounds;
  if FStateButtonInSubItem then
  begin
    AWidth := FGlyphsAreaBounds.Width;
    Dec(AWidth, ViewParams.GlyphIndent.cx + ViewParams.StateGlyphSize.cx);
    FGlyphsAreaBounds.Width := AWidth;
  end;
end;

procedure TdxListItemReportStyleViewInfo.CalculateGlyphsBounds(const ABounds: TRect);
begin
  if FStateButtonInSubItem and (ViewParams.StateViewKind <> TdxListItemStateViewKind.None) then
  begin
    CalculateStateBounds;
    FGlyphBounds := CalculateBoundsCore(ABounds, GlyphsAreaBounds, ViewParams.GlyphSize, posLeft);
  end
  else
    inherited CalculateGlyphsBounds(ABounds)
end;

procedure TdxListItemReportStyleViewInfo.DoCalculate(AType: TdxChangeType);
var
  I, ASubItemCount, ASubItemIndex: Integer;
  ASubItemViewInfo: TdxListSubItemViewInfo;
  ABounds, ASubItemBounds: TRect;
  AColumn: TdxListColumn;
begin
  ABounds := Bounds;
  ASubItemIndex := 0;
  ASubItemCount := GetSubItemCount;
  for I := 0 to ListView.Columns.Count - 1 do
  begin
    AColumn := ListView.Columns[I];
    ABounds.Width := AColumn.Width;
    if I = 0 then
      Dec(ABounds.Right, Owner.Owner.ContentOffset.Left);
    if AColumn.FSubItemIndex < 0 then
    begin
      FColumnIndex := I;
      FItemBounds := ABounds;
      FContentBounds := ABounds;
      FContentBounds.Deflate(ViewParams.Padding);
      if not FContentBounds.IsEmpty then
      begin
        CalculateGlyphsAreaBounds;
        CalculateTextAndGlyphLayout;
        CalculateTextBounds;
      end;
    end
    else
      if ASubItemIndex < ASubItemCount then
      begin
        ASubItemViewInfo := SubItems[ASubItemIndex];
        ASubItemBounds := ABounds;
        if FStateButtonInSubItem and (I = 0) then
          Inc(ASubItemBounds.Left, ViewParams.StateGlyphSize.cx + ViewParams.GlyphIndent.cx);
        ASubItemViewInfo.Calculate(ctLight, ASubItemBounds);
        Inc(ASubItemIndex);
      end;
    ABounds.Offset(ABounds.Width, 0);
  end;
  FBounds.Right := Min(FBounds.Right, ABounds.Left);
  CalculateContentBounds;
end;

procedure TdxListItemReportStyleViewInfo.DoRightToLeftConversion(const ABounds: TRect);
var
  I: Integer;
  ASubItemIndex: Integer;
  ASubItemViewInfo: TdxListSubItemViewInfo;
  ASubItemCount: Integer;
begin
  inherited DoRightToLeftConversion(ABounds);
  FItemBounds := TdxRightToLeftLayoutConverter.ConvertRect(FItemBounds, ABounds);
  ASubItemCount := GetSubItemCount;
  for I := 0 to ListView.Columns.Count - 1 do
  begin
    ASubItemIndex := ListView.Columns[I].FSubItemIndex;
    if (ASubItemIndex >= 0) and (ASubItemIndex < ASubItemCount) then
    begin
      ASubItemViewInfo := SubItems[ASubItemIndex];
      ASubItemViewInfo.RightToLeftConversion(ABounds);
    end;
  end;
end;

procedure TdxListItemReportStyleViewInfo.DrawBackground(ACanvas: TcxCustomCanvas);
begin
  Painter.DrawReportItemBackground(ACanvas, Self);
end;

procedure TdxListItemReportStyleViewInfo.DrawContent(ACanvas: TcxCustomCanvas);
var
  I: Integer;
begin
  DrawBackground(ACanvas);
  DrawStateGlyph(ACanvas);
  ACanvas.SaveClipRegion;
  try
    ACanvas.IntersectClipRect(ItemBounds);
    if HasGlyph then
      DrawGlyph(ACanvas);
    DrawText(ACanvas);
  finally
    ACanvas.RestoreClipRegion;
  end;
  for I := 0 to SubItemCount - 1 do
    SubItems[I].Draw(ACanvas);
end;

function TdxListItemReportStyleViewInfo.GetColumnTextFlags(AColumnIndex: Integer): Integer;
begin
  Result := CXTO_PREVENT_LEFT_EXCEED or CXTO_PREVENT_TOP_EXCEED or CXTO_END_ELLIPSIS or
    CXTO_SINGLELINE or CXTO_LEFT or CXTO_CENTER_VERTICALLY;
  Result := Result or HorizontalAlignmentMap[ListView.Columns[AColumnIndex].Alignment];
  if UseRightToLeftAlignment then
    Result := Result or CXTO_RTLREADING;
end;

function TdxListItemReportStyleViewInfo.GetHintableObject(const AMousePos: TPoint): TdxListViewCustomViewInfo;
var
  I: Integer;
begin
  for I := 0 to SubItemCount - 1 do
    if SubItems[I].Bounds.Contains(AMousePos) then
    begin
      Result := SubItems[I];
      Exit;
    end;
  Result := inherited GetHintableObject(AMousePos);
end;

function TdxListItemReportStyleViewInfo.GetHintTextBounds: TRect;
begin
  Result := TextBounds;
end;

procedure TdxListItemReportStyleViewInfo.Initialize(AItem: TdxListItem);
var
  I, ASubItemIndex, ASubItemCount, AImageIndex: Integer;
  ASubItemViewInfo: TdxListSubItemViewInfo;
  AColumn: TdxListColumn;
  AShowItemImageInFirstColumn: Boolean;
begin
  AShowItemImageInFirstColumn := ListView.ViewStyleReport.AlwaysShowItemImageInFirstColumn;
  ASubItemCount := AItem.SubItems.Count;
  FSubItems.Clear;
  for I := 0 to ListView.Columns.Count - 1 do
  begin
    AColumn := ListView.Columns[I];
    ASubItemIndex := AColumn.FSubItemIndex;
    if ASubItemIndex < 0 then
    begin
      FStateButtonInSubItem := (I > 0) and (ViewParams.StateViewKind <> TdxListItemStateViewKind.None);
      FHiddenGlyph := AShowItemImageInFirstColumn and (I > 0);
      if FHiddenGlyph then
        AImageIndex := -1
      else
        AImageIndex := AItem.ImageIndex;
      inherited Initialize(AItem.Caption, AImageIndex);
    end
    else
    begin
      if ASubItemIndex >= ASubItemCount then
        Continue;
      ASubItemViewInfo := TdxListSubItemViewInfo.Create(Self, ViewParams);
      if AShowItemImageInFirstColumn and (I = 0) then
        AImageIndex := AItem.ImageIndex
      else
        AImageIndex := AItem.SubItemImages[ASubItemIndex];
      ASubItemViewInfo.Initialize(I, AItem.SubItems[ASubItemIndex], AImageIndex);
      AddSubItem(ASubItemViewInfo);
    end;
  end;
end;

procedure TdxListItemReportStyleViewInfo.InvalidatePart(
  APart: TdxListItemHitTest);
begin
  Invalidate;
end;

function TdxListItemReportStyleViewInfo.IsHovered: Boolean;
begin
  Result := inherited IsHovered;
  if Result and not SharedBackground then
    Result := (FHotTrackPart <> TdxListItemHitTest.SubItemText);
end;

procedure TdxListItemReportStyleViewInfo.Offset(ADX, ADY: Integer);
begin
  inherited Offset(ADX, ADY);
  FItemBounds.Offset(ADX, ADY);
end;

function TdxListItemReportStyleViewInfo.StartEdit(AShift: TShiftState; const AMousePos: TPoint): Boolean;
begin
  Result := FTextAreaBounds.Contains(AMousePos);
end;

{ TdxListColumnHeaderViewInfo }

constructor TdxListColumnHeaderViewInfo.Create(AOwner: TdxListViewColumnHeadersViewInfo; AColumn: TdxListColumn;
  const AViewParams: TdxListViewCellViewParams);
begin
  inherited Create(AOwner.ListView, AViewParams);
  FColumn := AColumn;
  FOwner := AOwner;
  FHasCheckBox := IsCheckBoxVisible;
  Initialize(Column.Caption, Column.ImageIndex);
end;

procedure TdxListColumnHeaderViewInfo.AfterDraw(ACanvas: TcxCustomCanvas);
begin
  inherited AfterDraw(ACanvas);
  if (cxDesignHelper <> nil) and cxDesignHelper.IsObjectSelected(ListView, Column) then
    Painter.DrawDesignSelection(ACanvas, Bounds);
end;

procedure TdxListColumnHeaderViewInfo.BeforeDraw(ACanvas: TcxCustomCanvas);
begin
  inherited BeforeDraw(ACanvas);
  FCheckBoxState := GetCheckBoxState;
  FState := GetState;
  FChecked := HasCheckBox and Controller.AreAllItemsSelected;
end;

procedure TdxListColumnHeaderViewInfo.CalculateTextAndGlyphLayout;
var
  ASortArrowSize: TPoint;
  ABounds: TRect;
begin
  CalculateGlyphsBounds(FGlyphsAreaBounds);
  ABounds := FContentBounds;
  if Column.SortOrder <> soNone then
  begin
    FSortArrowBounds := ABounds;
    ASortArrowSize := Owner.SortArrowSize;
    FSortArrowBounds.Left := FSortArrowBounds.Right - ASortArrowSize.X;
    FSortArrowBounds.Height := ASortArrowSize.Y;
    FSortArrowBounds.Offset(0, (FContentBounds.Height - ASortArrowSize.Y) div 2);
    ABounds.Right := FSortArrowBounds.Left - ViewParams.Padding.Left;
  end;
  if not CheckBoxBounds.IsEmpty then
    ABounds.Left := CheckBoxBounds.Right + ViewParams.GlyphIndent.cx;
  CalculateTextAreaBounds(ABounds);
end;

procedure TdxListColumnHeaderViewInfo.CalculateCheckBoxBounds;
var
  ACheckBoxSize: TSize;
begin
  ACheckBoxSize := ViewParams.StateGlyphSize;
  FCheckBoxBounds.InitSize(ContentBounds.TopLeft, ACheckBoxSize);
  FCheckBoxBounds.Offset(0, (ContentBounds.Height - ACheckBoxSize.cy) div 2);
end;

procedure TdxListColumnHeaderViewInfo.CalculateContentBounds;
begin
  inherited CalculateContentBounds;
  FContentBounds.Deflate(LookAndFeelPainter.HeaderBorderSize);
  if ExternalCanvas = nil then
  begin
    FNeighbors := [nLeft, nRight];
    if not ListView.UseLightBorders then
    begin
      if Column.Index = 0 then
        Exclude(FNeighbors, nLeft);
    end
    else
      Include(FNeighbors, nTop);
    if Column.Index = ListView.Columns.Count - 1 then
      Exclude(FNeighbors, nRight);
  end
  else
    FNeighbors := [];
end;

procedure TdxListColumnHeaderViewInfo.CalculateGlyphsAreaBounds;
var
  ABounds: TRect;
begin
  if HasCheckBox then
    CalculateCheckBoxBounds;
  ABounds := ContentBounds;
  if not CheckBoxBounds.IsEmpty then
    ABounds.Left := CheckBoxBounds.Right + ViewParams.GlyphIndent.cx;
  FGlyphsAreaBounds := CalculateBoundsCore(ABounds, Bounds,
    ViewParams.GlyphsAreaSize, OppositePositionMap[ViewParams.TextPosition]);
end;

procedure TdxListColumnHeaderViewInfo.DoRightToLeftConversion(const ABounds: TRect);
begin
  inherited DoRightToLeftConversion(ABounds);
  FCheckBoxBounds := TdxRightToLeftLayoutConverter.ConvertRect(FCheckBoxBounds, ABounds);
  FSortArrowBounds := TdxRightToLeftLayoutConverter.ConvertRect(FSortArrowBounds, ABounds);
  FNeighbors := TdxRightToLeftLayoutConverter.ConvertNeighbors(FNeighbors);
end;

procedure TdxListColumnHeaderViewInfo.DrawCheckBox(ACanvas: TcxCustomCanvas);
const
  CheckBoxMap: array[Boolean] of TcxButtonState = (cxbsNormal, cxbsHot);
var
  AGlyphState: TcxButtonState;
begin
  if CheckBoxBounds.IsEmpty then
    Exit;
  AGlyphState := CheckBoxMap[HotTrackPart = TdxListColumnHeaderHitTest.CheckBox];
  Painter.DrawCheckButton(ACanvas, CheckBoxBounds, AGlyphState, Checked);
end;

procedure TdxListColumnHeaderViewInfo.DrawContent(ACanvas: TcxCustomCanvas);
var
  AClipBounds: TRect;
begin
  LookAndFeelPainter.DrawScaledHeader(ACanvas, Bounds, State, Neighbors,
    LookAndFeelPainter.HeaderBorders(Neighbors), ScaleFactor);
  ACanvas.SaveClipRegion;
  AClipBounds := Bounds;
  AClipBounds.Deflate(LookAndFeelPainter.HeaderBorderSize);
  ACanvas.IntersectClipRect(AClipBounds);
  inherited DrawContent(ACanvas);
  if HasCheckBox then
    DrawCheckBox(ACanvas);
  if Column.SortOrder <> soNone then
    LookAndFeelPainter.DrawListViewSortingMark(ACanvas, SortArrowBounds, Column.SortOrder = soAscending, ScaleFactor);
  ACanvas.RestoreClipRegion;
end;

function TdxListColumnHeaderViewInfo.GetBestFitWidth: Integer;
var
  ANonTextWidth, ATextWidth: Integer;
  AParams: TdxListViewCellViewParams;
begin
  AParams := Owner.ViewParams;
  ANonTextWidth := AParams.Padding.Width + LookAndFeelPainter.HeaderBorderSize * 2;
  if HasGlyph then
    Inc(ANonTextWidth, AParams.GlyphSize.cx + AParams.GlyphIndent.cx);
  if HasCheckBox then
    Inc(ANonTextWidth, AParams.StateGlyphSize.cx + AParams.GlyphIndent.cx);
  if Column.SortOrder <> soNone then
    Inc(ANonTextWidth, Owner.SortArrowSize.X + AParams.Padding.Left);
  if Column.Caption <> '' then
  begin
    if TextLayout <> nil then
    begin
      TextLayout.SetLayoutConstraints(0, 0);
      ATextWidth := TextLayout.MeasureSize.cx;
    end
    else
      ATextWidth := TdxTextMeasurer.TextWidthTO(ListView.Fonts.ColumnHeader, Column.Caption);
  end
  else
    ATextWidth := 0;
  Result := ATextWidth + ANonTextWidth;
end;

function TdxListColumnHeaderViewInfo.GetCheckBoxState: TcxButtonState;
begin
  case HottrackPart of
    TdxListColumnHeaderHitTest.CheckBox:
      Result := cxbsHot;
    else
      Result := cxbsNormal;
  end;
end;

function TdxListColumnHeaderViewInfo.GetColorPalette: IdxColorPalette;
begin
  Result := LookAndFeelPainter.GetListViewColumnHeaderColorPalette(State);
end;

function TdxListColumnHeaderViewInfo.GetHintFont: TFont;
begin
  Result := ListView.Fonts.ColumnHeader;
end;

function TdxListColumnHeaderViewInfo.GetHintText: string;
begin
  Result := Column.Caption;
end;

function TdxListColumnHeaderViewInfo.NeedShowHint: Boolean;
begin
  Result := (TextLayout <> nil) and TextLayout.IsTruncated;
end;

function TdxListColumnHeaderViewInfo.GetHitTest(const AMousePos: TPoint): TdxListColumnHeaderHitTest;
begin
  if ListView.IsDragging then
    Exit(TdxListColumnHeaderHitTest.None);
  if HasCheckBox and CheckBoxBounds.Contains(AMousePos) then
    Result := TdxListColumnHeaderHitTest.CheckBox
  else if Bounds.Contains(AMousePos) then
    Result := TdxListColumnHeaderHitTest.Content
  else
    Result := TdxListColumnHeaderHitTest.None;
end;

function TdxListColumnHeaderViewInfo.GetState: TcxButtonState;
begin
  if Column = Controller.PressedColumn then
    Result := cxbsPressed
  else
    case HottrackPart of
      TdxListColumnHeaderHitTest.Content,
      TdxListColumnHeaderHitTest.CheckBox:
        begin
          if ListView.IsDesigning then
            Result := cxbsNormal
          else
            Result := cxbsHot;
        end
      else
        Result := cxbsNormal;
    end;
end;

function TdxListColumnHeaderViewInfo.GetTextColor: TColor;
begin
  Result := ListView.Fonts.ColumnHeader.Color;
  if Result = clDefault then
    Result := LookAndFeelPainter.GetListViewColumnHeaderTextColor(State, ExplorerStyle);
end;

function TdxListColumnHeaderViewInfo.GetTextFlags: Integer;
begin
  Result := CXTO_PREVENT_LEFT_EXCEED or CXTO_PREVENT_TOP_EXCEED or CXTO_END_ELLIPSIS or
    CXTO_SINGLELINE or CXTO_LEFT or CXTO_CENTER_VERTICALLY;
  Result := Result or HorizontalAlignmentMap[Column.HeaderAlignment];
  if UseRightToLeftAlignment then
    Result := Result or CXTO_RTLREADING;
end;

function TdxListColumnHeaderViewInfo.HasGlyph: Boolean;
begin
  Result := inherited HasGlyph and (ImageIndex >= 0);
end;

function TdxListColumnHeaderViewInfo.HasStateGlyph: Boolean;
begin
  Result := HasCheckBox;
end;

function TdxListColumnHeaderViewInfo.IsCheckBoxVisible: Boolean;
begin
  Result := (Column.Index = 0) and ListView.MultiSelect and ListView.Checkboxes and ExplorerStyle;
end;

function TdxListColumnHeaderViewInfo.CanStartDrag(const AMousePos: TPoint): Boolean;
begin
  Result := GetHitTest(AMousePos) = TdxListColumnHeaderHitTest.Content;
end;

procedure TdxListColumnHeaderViewInfo.MouseDown(AButton: TMouseButton; AShift: TShiftState; const AMousePos: TPoint);
begin
  if AButton = mbMiddle then
    Exit;
  Controller.PressedColumn := Column;
  if AButton = mbLeft then
    Controller.CheckSelectAllOnMouseUp := GetHitTest(AMousePos) = TdxListColumnHeaderHitTest.CheckBox;
end;

procedure TdxListColumnHeaderViewInfo.MouseLeave;
begin
  HottrackPart := TdxListColumnHeaderHitTest.None;
end;

procedure TdxListColumnHeaderViewInfo.MouseMove(AShift: TShiftState; const AMousePos: TPoint);
begin
  HottrackPart := GetHitTest(AMousePos);
end;

procedure TdxListColumnHeaderViewInfo.Offset(ADX, ADY: Integer);
begin
  inherited Offset(ADX, ADY);
  FCheckBoxBounds.Offset(ADX, ADY);
  FSortArrowBounds.Offset(ADX, ADY);
end;

procedure TdxListColumnHeaderViewInfo.ResetBounds;
begin
  inherited ResetBounds;
  FCheckBoxBounds.Empty;
  FSortArrowBounds.Empty;
end;

procedure TdxListColumnHeaderViewInfo.SetHottrackPart(AValue: TdxListColumnHeaderHitTest);
begin
  if FHottrackPart <> AValue then
  begin
    FHottrackPart := AValue;
    Invalidate;
  end;
end;

{ TdxListViewHeadersViewInfo }

constructor TdxListViewColumnHeadersViewInfo.Create(AOwner: TdxListViewViewInfo);
begin
  inherited Create(AOwner.ListView);
  FItems := TdxFastObjectList.Create(True, ListView.Columns.Count);
  FOwner := AOwner;
  FViewParams := TdxListViewCellViewParams.Create;
  FResizeHitTestWidth := ScaleFactor.Apply(10); 
  CalculateViewParams;
end;

destructor TdxListViewColumnHeadersViewInfo.Destroy;
begin
  FreeAndNil(FViewParams);
  FreeAndNil(FItems);
  inherited Destroy;
end;

procedure TdxListViewColumnHeadersViewInfo.DrawContent(ACanvas: TcxCustomCanvas);
var
  I: Integer;
begin
  for I := 0 to ItemCount - 1 do
    Items[I].Draw(ACanvas);
end;

function TdxListViewColumnHeadersViewInfo.FindDragItem(const AMousePos: TPoint): TdxListColumnHeaderViewInfo;
begin
  if GetResizingColumn(AMousePos) <> nil then
    Exit(nil);
  Result := FindItem(AMousePos);
  if Result <> nil then
    if not Result.CanStartDrag(AMousePos) then
      Result := nil;
end;

function TdxListViewColumnHeadersViewInfo.FindItem(const AMousePos: TPoint): TdxListColumnHeaderViewInfo;
var
  I: Integer;
begin
  for I := 0 to ItemCount - 1 do
  begin
    Result := Items[I];
    if Result.Bounds.Contains(AMousePos) then
      Exit;
  end;
  Result := nil;
end;

function TdxListViewColumnHeadersViewInfo.GetCursor(const AMousePos: TPoint): TCursor;
begin
  if GetResizingColumn(AMousePos) <> nil then
    Result := crcxGridHorzSize
  else
    Result := crDefault;
end;

function TdxListViewColumnHeadersViewInfo.GetDesignHitTest(const P: TPoint): Boolean;
begin
  Result := Bounds.Contains(P) or (GetResizingColumn(P) <> nil);
end;

function TdxListViewColumnHeadersViewInfo.GetHitTestBounds: TRect;
begin
  Result := Bounds;
  if ListView.UseRightToLeftAlignment then
    Dec(Result.Left, FResizeHitTestWidth)
  else
    Inc(Result.Right, FResizeHitTestWidth);
  Result.Intersect(ListView.ClientBounds);
end;

function TdxListViewColumnHeadersViewInfo.GetResizingColumn(const AMousePos: TPoint): TdxListColumn;
var
  I: Integer;
  ANextItemIndex: Integer;
  ARightmostItemIndex: Integer;
  R: TRect;
  AItem: TdxListColumnHeaderViewInfo;
begin
  Result := nil;
  if ListView.IsDesigning and not Controller.CanSelectColumnInDesigner then
    Exit;

  if UseRightToLeftAlignment then
  begin
    I := ItemCount - 1;
    ARightmostItemIndex := 0;
  end
  else
  begin
    I := 0;
    ARightmostItemIndex := ItemCount - 1;
  end;
  ANextItemIndex := I;

  while (I >= 0) and (I <= ItemCount - 1) do
  begin
    AItem := Items[I];
    R := AItem.Bounds;
    if UseRightToLeftAlignment then
    begin
      Dec(ANextItemIndex);
      R.Right := R.Left + 1;
      Dec(R.Left, FResizeHitTestWidth);
    end
    else
    begin
      Inc(ANextItemIndex);
      R.Left := R.Right - 1;
      Inc(R.Right, FResizeHitTestWidth);
    end;
    if I <> ARightmostItemIndex then
      R.Right := Min(R.Right, Items[ANextItemIndex].Bounds.Right - 1);
    if R.Contains(AMousePos) then
    begin
      Result := AItem.Column;
      if AItem.HasCheckBox then
      begin
        R.Intersect(AItem.CheckBoxBounds);
        if R.Contains(AMousePos) then
          Result := nil;
      end;
      Break;
    end;
    I := ANextItemIndex;
  end;
end;

procedure TdxListViewColumnHeadersViewInfo.DoCalculate(AType: TdxChangeType);
var
  AHeaderBounds: TRect;
  I, AWidth: Integer;
  ARecalculate: Boolean;
  AItemViewInfo: TdxListColumnHeaderViewInfo;
begin
  inherited DoCalculate(AType);
  FBounds.InitSize(FBounds.TopLeft, 0, CalculateHeight);
  ARecalculate := AType > TdxChangeType.ctLight;
  if ARecalculate then
    PopulateItems;
  AHeaderBounds := Bounds;
  AHeaderBounds.Right := AHeaderBounds.Left;
  for I := 0 to ItemCount - 1 do
  begin
    AWidth := ListView.Columns[I].Width;
    Inc(FBounds.Right, AWidth);
    AHeaderBounds.Width := AWidth;
    AItemViewInfo := Items[I];
    if ARecalculate then
      AItemViewInfo.MakeDirty;
    AItemViewInfo.Calculate(AType, AHeaderBounds);
    AHeaderBounds.Offset(AWidth, 0);
  end;
end;

procedure TdxListViewColumnHeadersViewInfo.DoRightToLeftConversion(const ABounds: TRect);
var
  I: Integer;
begin
  inherited DoRightToLeftConversion(ABounds);
  for I := 0 to ItemCount - 1 do
    Items[I].RightToLeftConversion(ABounds);
end;

function TdxListViewColumnHeadersViewInfo.CalculateHeight: Integer;
begin
  Result := TdxTextMeasurer.TextLineHeight(ListView.Fonts.ColumnHeader);
  Result := Max(Result, Max(ViewParams.GlyphSize.cy, ViewParams.StateGlyphSize.cy));
  Inc(Result, ViewParams.Padding.Height);
end;

function TdxListViewColumnHeadersViewInfo.CalculateHeaderBestFitWidth(AColumn: TdxListColumn): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to ItemCount - 1 do
    if Items[I].Column = AColumn then
    begin
      Result := Items[I].GetBestFitWidth;
      Break;
    end;
end;

procedure TdxListViewColumnHeadersViewInfo.CalculateViewParams;
var
  APadding: TRect;
begin
  APadding := LookAndFeelPainter.GetListViewColumnHeaderContentOffsets(ExplorerStyle, ScaleFactor);
  Owner.CalculateCommonViewParams(ViewParams, APadding, ListView.Fonts.ColumnHeader, ListView.ImageOptions.ColumnHeaderImages);
  ViewParams.StateImages := ListView.ImageOptions.ColumnHeaderImages;
  if ViewParams.StateImages = nil then
    ViewParams.StateViewKind := TdxListItemStateViewKind.None
  else
    ViewParams.StateViewKind := TdxListItemStateViewKind.Glyph;
  ViewParams.StateGlyphSize := LookAndFeelPainter.ScaledCheckButtonSize(ScaleFactor);
  ViewParams.GlyphsAreaSize := Owner.CalculateColumnHeaderGlyphsAreaSize;
  ViewParams.TextPosition := posRight;
  ViewParams.TextLineCount := 0;
  FSortArrowSize := LookAndFeelPainter.GetListViewColumnHeaderSortingMarkSize(ScaleFactor);
end;

function TdxListViewColumnHeadersViewInfo.GetItem(Index: Integer): TdxListColumnHeaderViewInfo;
begin
  Result := TdxListColumnHeaderViewInfo(FItems.List[Index]);
end;

function TdxListViewColumnHeadersViewInfo.GetItemCount: Integer;
begin
  Result := FItems.Count;
end;

procedure TdxListViewColumnHeadersViewInfo.MouseDown(AButton: TMouseButton; AShift: TShiftState; const AMousePos: TPoint);
var
  AItemViewInfo: TdxListColumnHeaderViewInfo;
begin
  AItemViewInfo := FindItem(AMousePos);
  if AItemViewInfo <> nil then
    AItemViewInfo.MouseDown(AButton, AShift, AMousePos);
end;

procedure TdxListViewColumnHeadersViewInfo.MouseLeave;
begin
  HottrackItem := nil;
end;

procedure TdxListViewColumnHeadersViewInfo.MouseMove(AShift: TShiftState; const AMousePos: TPoint);
begin
  HottrackItem := FindItem(AMousePos);
  if HottrackItem <> nil then
    HottrackItem.MouseMove(AShift, AMousePos);
end;

procedure TdxListViewColumnHeadersViewInfo.PopulateItems;
var
  I: Integer;
begin
  FHottrackItem := nil;
  FItems.Clear;
  for I := 0 to ListView.Columns.Count - 1 do
    FItems.Add(TdxListColumnHeaderViewInfo.Create(Self, ListView.Columns[I], ViewParams));
end;

procedure TdxListViewColumnHeadersViewInfo.SetHottrackItem(AValue: TdxListColumnHeaderViewInfo);
begin
  if FHottrackItem <> AValue then
  begin
    ExchangePointers(FHottrackItem, AValue);
    if AValue <> nil then
      AValue.MouseLeave;
    if FHottrackItem <> nil then
      FHottrackItem.CheckShowHint;
  end;
end;

{ TdxListViewPainter }

destructor TdxListViewPainter.Destroy;
begin
  FreeAndNil(FImageLists);
  inherited Destroy;
end;

procedure TdxListViewPainter.InvalidateImageList(AImageList: TCustomImageList);
begin
  if FImageLists <> nil then
  begin
    if AImageList <> nil then
      FImageLists.Remove(AImageList)
    else
      FImageLists.Clear;
  end;
end;

procedure TdxListViewPainter.DrawBackground(ACanvas: TcxCustomCanvas; const ABounds: TRect; AExplorerStyle: Boolean);
begin
  if ListView.GetBackgroundStyle <> bgTransparent then
    LookAndFeelPainter.DrawListViewBackground(ACanvas, ABounds, AExplorerStyle, ListView.Enabled);
end;

procedure TdxListViewPainter.DrawGroupHeader(ACanvas: TcxCustomCanvas; AViewInfo: TdxListGroupHeaderViewInfo);
begin
  DrawGroupHeaderBackground(ACanvas, AViewInfo);
  DrawGroupText(ACanvas, AViewInfo.Header);
  if not AViewInfo.HeaderLineBounds.IsEmpty then
    LookAndFeelPainter.DrawListViewGroupHeaderLine(ACanvas, AViewInfo.HeaderLineBounds);
  if AViewInfo.HasExpandButton then
    LookAndFeelPainter.DrawListViewGroupExpandButton(ACanvas, AViewInfo.ExpandButtonBounds, AViewInfo.ExpandButtonState,
      not AViewInfo.Group.Collapsed, AViewInfo.ExplorerStyle, ScaleFactor);
  if AViewInfo.HasGlyph then
    DrawGlyphCore(ACanvas, AViewInfo.GlyphBounds, AViewInfo.HeaderParams.Images, AViewInfo.Group.TitleImage, -1, idmNormal,
      255, AViewInfo.GetColorPalette);
  DrawGroupText(ACanvas, AViewInfo.Subtitle);
end;

procedure TdxListViewPainter.DrawGroupHeaderBackground(ACanvas: TcxCustomCanvas; AViewInfo: TdxListGroupHeaderViewInfo);
begin
  if AViewInfo.HeaderState * [dxlgsFocused, dxlgsHot] <> [] then
    LookAndFeelPainter.DrawListViewGroupHeaderBackground(ACanvas, AViewInfo.Bounds,
      AViewInfo.HeaderState, AViewInfo.ExplorerStyle, ScaleFactor);
end;

procedure TdxListViewPainter.DrawGroupText(ACanvas: TcxCustomCanvas; AViewInfo: TdxListGroupTextViewInfo);
begin
  if AViewInfo <> nil then
  begin
    AViewInfo.Draw(ACanvas);
  end;
end;

procedure TdxListViewPainter.DrawCheckButton(ACanvas: TcxCustomCanvas; const ABounds: TRect;
  AState: TcxButtonState; AChecked: Boolean);
begin
  LookAndFeelPainter.DrawListViewCheckButton(ACanvas, ABounds, AState, AChecked, ScaleFactor);
end;

procedure TdxListViewPainter.DrawItemBackground(ACanvas: TcxCustomCanvas; AViewInfo: TdxListItemCustomViewInfo);
begin
  if AViewInfo.State * [dxlisFocused, dxlisHot, dxlisSelected] <> [] then
    LookAndFeelPainter.DrawListViewItemBackground(ACanvas, AViewInfo.Bounds, AViewInfo.State, AViewInfo.ExplorerStyle);
end;

procedure TdxListViewPainter.DrawReportItemBackground(ACanvas: TcxCustomCanvas; AViewInfo: TdxListItemReportStyleViewInfo);
var
  ABounds: TRect;
begin
  if AViewInfo.State * [dxlisFocused, dxlisHot, dxlisSelected] <> [] then
  begin
    if AViewInfo.SharedBackground then
      ABounds := AViewInfo.Bounds
    else
      ABounds := AViewInfo.ItemBounds;
    LookAndFeelPainter.DrawListViewItemBackground(ACanvas, ABounds, AViewInfo.State, AViewInfo.ExplorerStyle);
  end;
end;

procedure TdxListViewPainter.DrawMultiSelectionRect(ACanvas: TcxCustomCanvas; const ABounds: TRect);
var
  R: TRect;
begin
  R := ListView.ClientBounds;
  R.Inflate(2); 
  R.Intersect(ABounds);
  ACanvas.Rectangle(R, clNone, clBlue, psSolid);
  ACanvas.FillRect(R, RGB($49, $A7, $FF), 96);
end;

procedure TdxListViewPainter.DrawDesignSelection(ACanvas: TcxCustomCanvas; ABounds: TRect);
begin
  ABounds.Deflate(1);
  ACanvas.FocusRectangle(ABounds);
  ABounds.Deflate(1);
  ACanvas.FocusRectangle(ABounds);
end;

function TdxListViewPainter.CreateCanvasBasedFont(AFont: TFont): TcxCanvasBasedFont;
begin
  Result := ListView.ActualCanvas.CreateFonT(AFont);
end;

function TdxListViewPainter.CreateCanvasBasedImage(ABitmap: TBitmap; AAlphaFormat: TAlphaFormat): TcxCanvasBasedImage;
begin
  Result := ListView.ActualCanvas.CreateImage(ABitmap, AAlphaFormat);
end;

function TdxListViewPainter.CreateCanvasBasedTextLayout: TcxCanvasBasedTextLayout;
begin
  Result := ListView.ActualCanvas.CreateTextLayout;
end;

procedure TdxListViewPainter.DrawGlyphCore(ACanvas: TcxCustomCanvas; const ABounds: TRect;
  AImages: TCustomImageList; AImageIndex, AOverlayIndex: Integer; AMode: TcxImageDrawMode;
  AAlpha: Byte; const AColorPalette: IdxColorPalette);
begin
  if IsImageAssigned(AImages, AImageIndex) then
  begin
    if not ACanvas.CheckIsValid(FImageLists) then
    begin
      FreeAndNil(FImageLists);
      FImageLists := TcxCanvasBasedImageListMap.Create(ACanvas);
    end;
    FImageLists.GetOrCreate(AImages).Draw(ABounds, AImageIndex, AOverlayIndex, AMode, AAlpha, AColorPalette);
  end;
end;

function TdxListViewPainter.DrawItemSelectionFirst: Boolean;
begin
  Result := LookAndFeelPainter.DrawGalleryItemSelectionFirst;
end;

function TdxListViewPainter.GetLookAndFeelPainter: TcxCustomLookAndFeelPainter;
begin
  Result := ListView.LookAndFeelPainter;
end;

function TdxListViewPainter.GetScaleFactor: TdxScaleFactor;
begin
  Result := ListView.ScaleFactor;
end;

function TdxListViewPainter.GetUseRightToLeftAlignment: Boolean;
begin
  Result := ListView.UseRightToLeftAlignment;
end;

{ TdxListGroupCustomViewInfo }

constructor TdxListGroupCustomViewInfo.Create(AOwner: TdxListViewViewInfo; AGroup: TdxListGroup);
begin
  FOwner := AOwner;
  inherited Create(AOwner.ListView);
  FGroup := AGroup;
  FItems := TdxFastObjectList.Create(True, 512);
  FVisibleItems := TdxFastList.Create(512);
end;

destructor TdxListGroupCustomViewInfo.Destroy;
begin
  FreeAndNil(FVisibleItems);
  FreeAndNil(FItems);
  FreeAndNil(FColumnWidths);
  inherited Destroy;
end;

function TdxListGroupCustomViewInfo.GetItem(Index: Integer): TdxListItemCustomViewInfo;
begin
  Result := TdxListItemCustomViewInfo(FItems.List[Index]);
end;

function TdxListGroupCustomViewInfo.GetItemCount: Integer;
begin
  Result := FItems.Count;
end;

function TdxListGroupCustomViewInfo.GetItemSize: TSize;
begin
  Result := Owner.ItemSize;
end;

function TdxListGroupCustomViewInfo.GetVisibleItem(Index: Integer): TdxListItemCustomViewInfo;
begin
  Result := TdxListItemCustomViewInfo(FVisibleItems.List[Index]);
end;

function TdxListGroupCustomViewInfo.GetVisibleItemCount: Integer;
begin
  Result := FVisibleItems.Count;
end;

procedure TdxListGroupCustomViewInfo.SetHotTrackPart(AValue: TdxListGroupHitTest);
begin
  if FHotTrackPart <> AValue then
  begin
    InvalidatePart(FHotTrackPart);
    InvalidatePart(AValue);
    FHotTrackPart := AValue;
  end;
end;

function TdxListGroupCustomViewInfo.GetItemAtPos(const P: TPoint; out AViewInfo: TdxListItemCustomViewInfo): Boolean;
var
  I: Integer;
begin
  Result := False;
  if not ContentVisibleBounds.Contains(P) then
    Exit;
  for I := 0 to VisibleItemCount - 1 do
  begin
    AViewInfo := VisibleItems[I];
    if AViewInfo.Bounds.Contains(P) then
      Exit(True);
  end;
  AViewInfo := nil;
end;

function TdxListGroupCustomViewInfo.GetHitTest(const P: TPoint; out AItemViewInfo: TdxListItemCustomViewInfo): TdxListGroupHitTest;
begin
  if not Owner.IsPointAtColumnHeaders(P) and ContentBounds.Contains(P) then
  begin
    if GetItemAtPos(P, AItemViewInfo) then
      Exit(TdxListGroupHitTest.Item)
    else
      Result := TdxListGroupHitTest.Content;
  end
  else
    Result := TdxListGroupHitTest.None;
  AItemViewInfo := nil;
end;

procedure TdxListGroupCustomViewInfo.AddVisibleItemViewInfo(AViewInfo: TdxListItemCustomViewInfo);
begin
  FVisibleItems.Add(AViewInfo);
  Owner.Items.Add(AViewInfo.ItemIndex, AViewInfo);
end;

procedure TdxListGroupCustomViewInfo.CalculateRowAndColumnCount;
var
  AGapBetweenItems: Integer;
begin
  AGapBetweenItems := GetGapBetweenItems;
  if IsReportView then
  begin
    FColumnCount := 1;
    FRowCount := ItemCount;
  end
  else
    if IsHorizontalItemsArrangement then
    begin
      FColumnCount := Max(1, (GetAvailableWidthForItems + AGapBetweenItems) div (ItemSize.cx + AGapBetweenItems));
      FRowCount := ItemCount div FColumnCount;
      if ItemCount mod FColumnCount > 0 then
        Inc(FRowCount);
      FRowCount := Max(1, FRowCount);
    end
    else
    begin
      FRowCount := Max(1, (GetAvailableHeightForItems + AGapBetweenItems) div (ItemSize.cy + AGapBetweenItems));
      FColumnCount := ItemCount div FRowCount;
      if ItemCount mod FRowCount > 0 then
        Inc(FColumnCount);
      FColumnCount := Max(1, FColumnCount);
    end
end;

procedure TdxListGroupCustomViewInfo.CalculateContent(AType: TdxChangeType);
begin
  CalculateItemsArea;
  CalculateItems(AType);
end;

procedure TdxListGroupCustomViewInfo.CalculateItems(AType: TdxChangeType);
begin
  FVisibleItems.Count := 0;
  case ListView.ViewStyle of
    TdxListViewStyle.Icon,
    TdxListViewStyle.SmallIcon:
      CalculateIconsViewStyle(AType);
    TdxListViewStyle.List:
      CalculateListViewStyle(AType);
    TdxListViewStyle.Report:
      CalculateReportViewStyle(AType);
  end;
end;

function TdxListGroupCustomViewInfo.CalculateItemViewInfo(AOrderIndex: Integer; const ABounds: TRect): TdxListItemCustomViewInfo;
var
  AItem: TdxListItem;
begin
  Result := Items[AOrderIndex];
  AItem := ListView.GetItem(Result.ItemIndex);
  Result.Initialize(AItem);
  Result.Calculate(TdxChangeType.ctHard, ABounds);
  AddVisibleItemViewInfo(Result);
end;

procedure TdxListGroupCustomViewInfo.CalculateHorizontallyArrangedIcons(AType: TdxChangeType);
var
  I, AColumnIndex, AFirstVisibleOrderIndex, ALastVisibleOrderIndex, AGapBetweenItems, ACount: Integer;
  AItemBounds: TRect;
begin
  if PrepareVisibleItemsInfo(AFirstVisibleOrderIndex, ALastVisibleOrderIndex) then
  begin
    AItemBounds.InitSize(GetItemOrigin(AFirstVisibleOrderIndex), ItemSize);
    AColumnIndex := 0;
    AGapBetweenItems := GetGapBetweenItems;
    for I := AFirstVisibleOrderIndex to ALastVisibleOrderIndex do
    begin
      CalculateItemViewInfo(I, AItemBounds);
      Inc(AColumnIndex);
      if AColumnIndex = ColumnCount then
      begin
        AColumnIndex := 0;
        AItemBounds.Offset(0, ItemSize.cy + AGapBetweenItems);
        AItemBounds.X := ItemsAreaBounds.Left;
      end
      else
        AItemBounds.Offset(ItemSize.cx + AGapBetweenItems, 0);
    end;
  end;
  FItemsAreaBounds.Bottom := ItemsAreaBounds.Top + GetItemsHeight(RowCount);
  ACount := IfThen(ColumnCount < ItemCount, ColumnCount, ItemCount);
  FItemsAreaBounds.Width := Max(GetItemsWidth(ACount), ItemSize.cx);
end;

procedure TdxListGroupCustomViewInfo.CalculateVerticallyArrangedIcons(AType: TdxChangeType);
var
  I, ARowIndex, AFirstVisibleOrderIndex, ALastVisibleOrderIndex, AGapBetweenItems, ACount: Integer;
  AItemBounds: TRect;
begin
  if PrepareVisibleItemsInfo(AFirstVisibleOrderIndex, ALastVisibleOrderIndex) then
  begin
    AItemBounds.InitSize(GetItemOrigin(AFirstVisibleOrderIndex), ItemSize);
    ARowIndex := 0;
    AGapBetweenItems := GetGapBetweenItems;
    for I := AFirstVisibleOrderIndex to ALastVisibleOrderIndex do
    begin
      CalculateItemViewInfo(I, AItemBounds);
      Inc(ARowIndex);
      if ARowIndex = RowCount then
      begin
        ARowIndex := 0;
        AItemBounds.Offset(ItemSize.cx + AGapBetweenItems, 0);
        AItemBounds.Y := ItemsAreaBounds.Top;
      end
      else
        AItemBounds.Offset(0, ItemSize.cy + AGapBetweenItems);
    end;
  end;
  FItemsAreaBounds.Right := ItemsAreaBounds.Left + GetItemsWidth(ColumnCount);
  ACount := IfThen(RowCount < ItemCount, RowCount, ItemCount);
  FItemsAreaBounds.Height := Max(GetItemsHeight(ACount), ItemSize.cy);
end;

procedure TdxListGroupCustomViewInfo.CalculateIconsViewStyle(AType: TdxChangeType);
begin
  if IsHorizontalItemsArrangement then
    CalculateHorizontallyArrangedIcons(AType)
  else
    CalculateVerticallyArrangedIcons(AType);
end;

procedure TdxListGroupCustomViewInfo.CalculateListViewStyle(AType: TdxChangeType);
var
  I, ARowIndex, AFirstVisibleOrderIndex, ALastVisibleOrderIndex, AGapBetweenItems, ACount: Integer;
  AItemBounds: TRect;
begin
  if PrepareVisibleItemsInfo(AFirstVisibleOrderIndex, ALastVisibleOrderIndex) then
  begin
    AItemBounds.InitSize(GetItemOrigin(AFirstVisibleOrderIndex), ItemSize);
    ARowIndex := 0;
    AGapBetweenItems := GetGapBetweenItems;
    for I := AFirstVisibleOrderIndex to ALastVisibleOrderIndex do
    begin
      CalculateItemViewInfo(I, AItemBounds);
      Inc(ARowIndex);
      if ARowIndex = RowCount then
      begin
        ARowIndex := 0;
        AItemBounds.Offset(ItemSize.cx + AGapBetweenItems, 0);
        AItemBounds.Y := ItemsAreaBounds.Top;
      end
      else
        AItemBounds.Offset(0, ItemSize.cy + AGapBetweenItems);
    end;
  end;
  FItemsAreaBounds.Right := ItemsAreaBounds.Left + GetItemsWidth(ColumnCount);
  ACount := IfThen(RowCount < ItemCount, RowCount, ItemCount);
  FItemsAreaBounds.Height := Max(GetItemsHeight(ACount), ItemSize.cy);
end;

procedure TdxListGroupCustomViewInfo.CalculateReportViewStyle(AType: TdxChangeType);
var
  I, ARowIndex, AFirstVisibleOrderIndex, ALastVisibleOrderIndex, AGapBetweenItems, ACount: Integer;
  AItemBounds: TRect;
begin
  if PrepareVisibleItemsInfo(AFirstVisibleOrderIndex, ALastVisibleOrderIndex) then
  begin
    AItemBounds.InitSize(GetItemOrigin(AFirstVisibleOrderIndex), Owner.FColumnHeadersWidth, ItemSize.cy);
    ARowIndex := 0;
    AGapBetweenItems := GetGapBetweenItems;
    for I := AFirstVisibleOrderIndex to ALastVisibleOrderIndex do
    begin
      CalculateItemViewInfo(I, AItemBounds);
      Inc(ARowIndex);
      if ARowIndex = RowCount then
      begin
        ARowIndex := 0;
        AItemBounds.Offset(ItemSize.cx + AGapBetweenItems, 0);
        AItemBounds.Y := ItemsAreaBounds.Top;
      end
      else
        AItemBounds.Offset(0, ItemSize.cy + AGapBetweenItems);
    end;
  end;
  FItemsAreaBounds.Right := ItemsAreaBounds.Left + GetItemsWidth(ColumnCount);
  ACount := IfThen(RowCount < ItemCount, RowCount, ItemCount);
  FItemsAreaBounds.Height := Max(GetItemsHeight(ACount), ItemSize.cy);
end;

procedure TdxListGroupCustomViewInfo.CalculateItemsArea;
begin
  FItemsAreaBounds := Bounds;
end;

procedure TdxListGroupCustomViewInfo.DoCalculate(AType: TdxChangeType);
begin
  inherited DoCalculate(AType);
  CalculateRowAndColumnCount;
  CalculateContentVisibleBounds;
  CalculateContent(AType);
  CalculateContentBounds;
  FEmpty := not ContentBounds.IntersectsWith(Owner.Bounds);
end;

procedure TdxListGroupCustomViewInfo.DoRightToLeftConversion(const ABounds: TRect);
var
  I: Integer;
begin
  inherited DoRightToLeftConversion(ABounds);
  FContentBounds := TdxRightToLeftLayoutConverter.ConvertRect(FContentBounds, ABounds);
  FContentVisibleBounds := TdxRightToLeftLayoutConverter.ConvertRect(FContentVisibleBounds, ABounds);
  FItemsAreaBounds := TdxRightToLeftLayoutConverter.ConvertRect(FItemsAreaBounds, ABounds);
  for I := 0 to ItemCount - 1 do
    Items[I].RightToLeftConversion(ABounds);
end;

procedure TdxListGroupCustomViewInfo.CalculateContentBounds;
begin
  FContentBounds := ItemsAreaBounds;
end;

procedure TdxListGroupCustomViewInfo.CalculateContentVisibleBounds;
begin
  FContentVisibleBounds := Owner.GetGroupVisibleBounds;
end;

procedure TdxListGroupCustomViewInfo.DrawContent(ACanvas: TcxCustomCanvas);
var
  I: Integer;
begin
  if not Empty then
    for I := 0 to VisibleItemCount - 1 do
      VisibleItems[I].Draw(ACanvas);
end;

procedure TdxListGroupCustomViewInfo.ExpandButtonClick;
begin
end;

function TdxListGroupCustomViewInfo.GetAvailableHeightForItems: Integer;
begin
  Result := Bounds.Height;
end;

function TdxListGroupCustomViewInfo.GetAvailableWidthForItems: Integer;
begin
  Result := Bounds.Width;
end;


procedure TdxListGroupCustomViewInfo.AdjustItemBoundsForMakeVisible(AOrderIndex: Integer; var ABounds: TRect);
var
  ALastColumnIndex, ALastRowIndex: Integer;
  AIsFirstGroup, AIsLastGroup: Boolean;
  AOffset: TRect;
begin
  AIsFirstGroup := Self = Owner.Groups[0];
  AIsLastGroup := Self = Owner.Groups[Owner.GroupCount - 1];
  AOffset := Owner.ContentOffset;
  if Owner.AreGroupsVertical then
  begin
    if AIsLastGroup and not HasFooter then
    begin
      ALastRowIndex := (ItemCount div ColumnCount) * ColumnCount;
      if ItemCount mod ColumnCount = 0 then
        Dec(ALastRowIndex, ColumnCount);
      if AOrderIndex >= ALastRowIndex then
        Inc(ABounds.Bottom, AOffset.Bottom);
    end;
    if AIsFirstGroup and (AOrderIndex < ColumnCount) and not HasHeader then
      Dec(ABounds.Top, AOffset.Top);
    if IsReportView then
      Dec(ABounds.Left, AOffset.Left);
  end
  else
  begin
    if AIsLastGroup then
    begin
      ALastColumnIndex := (ItemCount div RowCount) * RowCount;
      if ItemCount mod RowCount = 0 then
        Dec(ALastColumnIndex, RowCount);
      if AOrderIndex >= ALastColumnIndex then
        Inc(ABounds.Right, AOffset.Right);
    end;
    if AIsFirstGroup and (AOrderIndex < RowCount) then
      Dec(ABounds.Left, AOffset.Left);
  end;
end;

function TdxListGroupCustomViewInfo.GetBoundsForItem(AOrderIndex: Integer; AMakeVisibleBounds: Boolean = False): TRect;
var
  AGapBetweenItems: Integer;
begin
  if AOrderIndex < 0 then
    Exit(TRect.Null);

  AGapBetweenItems := GetGapBetweenItems;
  if IsHorizontalItemsArrangement or IsReportView then
  begin
    Result.Top := ItemsAreaBounds.Top + (AOrderIndex div ColumnCount) * (ItemSize.cy + AGapBetweenItems);
    if ListView.UseRightToLeftAlignment then
      Result.Left := ItemsAreaBounds.Right - (AOrderIndex mod ColumnCount) * (ItemSize.cx + AGapBetweenItems) - ItemSize.cx
    else
      Result.Left := ItemsAreaBounds.Left + (AOrderIndex mod ColumnCount) * (ItemSize.cx + AGapBetweenItems);
  end
  else
  begin
    Result.Top := ItemsAreaBounds.Top + (AOrderIndex mod RowCount) * (ItemSize.cy + AGapBetweenItems);
    if ListView.UseRightToLeftAlignment then
      Result.Left := ItemsAreaBounds.Right - (AOrderIndex div RowCount) * (ItemSize.cx + AGapBetweenItems) - ItemSize.cx
    else
      Result.Left := ItemsAreaBounds.Left + (AOrderIndex div RowCount) * (ItemSize.cx + AGapBetweenItems);
  end;
  Result.Size := ItemSize;

  if AMakeVisibleBounds then
    AdjustItemBoundsForMakeVisible(AOrderIndex, Result);
end;

function TdxListGroupCustomViewInfo.GetHitTestBounds: TRect;
begin
  Result := ContentBounds;
  if not Result.IsEmpty and (not IsGroupView or Owner.AreGroupsVertical) then
    if UseRightToLeftAlignment then
      Result.Left := Owner.GetScrollArea.Left
    else
      Result.Right := Owner.GetScrollArea.Right;
end;

function TdxListGroupCustomViewInfo.GetFocused: Boolean;
begin
  Result := False;
end;

function TdxListGroupCustomViewInfo.GetItemOrigin(AOrderIndex: Integer): TPoint;
begin
  Result := ItemsAreaBounds.TopLeft;
  if IsHorizontalItemsArrangement or IsReportView then
    Inc(Result.Y, (AOrderIndex div ColumnCount) * (ItemSize.cy + GetGapBetweenItems))
  else
    Inc(Result.X, (AOrderIndex div RowCount) * (ItemSize.cx + GetGapBetweenItems));
end;

function TdxListGroupCustomViewInfo.GetItemsHeight(ACount: Integer): Integer;
begin
  if ACount = 0 then
    Exit(0);
  Result := (ItemSize.cy * ACount) + ((ACount - 1) * GetGapBetweenItems);
end;

function TdxListGroupCustomViewInfo.GetItemsWidth(ACount: Integer): Integer;
begin
  if ACount = 0 then
    Exit(0);
  Result := (ItemSize.cx * ACount) + ((ACount - 1) * GetGapBetweenItems);
end;

function TdxListGroupCustomViewInfo.GetVisibleItemsRange(out AFirstOrderIndex, ALastOrderIndex: Integer): Boolean;
var
  ASize, ACount, AGapBetweenItems, AOverlap: Integer;
  AVisibleBounds: TRect;
begin
  AFirstOrderIndex := 0;
  AGapBetweenItems := GetGapBetweenItems;
  AVisibleBounds := FContentVisibleBounds;
  AVisibleBounds.Intersect(ItemsAreaBounds);
  if AVisibleBounds.IsEmpty then
  begin
    ALastOrderIndex := -1;
    Exit(False);
  end;
  if IsHorizontalItemsArrangement or IsReportView then
  begin
    if ItemsAreaBounds.Top < AVisibleBounds.Top then
    begin
      AOverlap := AVisibleBounds.Top - ItemsAreaBounds.Top;
      ACount := (AOverlap + AGapBetweenItems) div (ItemSize.cy + AGapBetweenItems);
      AFirstOrderIndex := ACount * ColumnCount;
    end;
    ASize := AVisibleBounds.Bottom - ItemsAreaBounds.Top;
    ACount := (ASize + AGapBetweenItems) div (ItemSize.cy + AGapBetweenItems);
    ALastOrderIndex := ACount * ColumnCount + (ColumnCount - 1);
  end
  else
  begin
    if ItemsAreaBounds.Left < AVisibleBounds.Left then
    begin
      AOverlap := AVisibleBounds.Left - ItemsAreaBounds.Left;
      ACount := (AOverlap + AGapBetweenItems) div (ItemSize.cx + AGapBetweenItems);
      AFirstOrderIndex := ACount * RowCount;
    end;
    ASize := AVisibleBounds.Right - ItemsAreaBounds.Left;
    ACount := (ASize + AGapBetweenItems) div (ItemSize.cx + AGapBetweenItems);
    ALastOrderIndex := ACount * RowCount + (RowCount - 1);
  end;
  ALastOrderIndex := Min(ALastOrderIndex, ItemCount - 1);
  Result := ALastOrderIndex >= AFirstOrderIndex;
end;

function TdxListGroupCustomViewInfo.HasFooter: Boolean;
begin
  Result := False;
end;

function TdxListGroupCustomViewInfo.HasHeader: Boolean;
begin
  Result := False;
end;

procedure TdxListGroupCustomViewInfo.InvalidatePart(APart: TdxListGroupHitTest);
begin
end;

function TdxListGroupCustomViewInfo.IsFirst: Boolean;
begin
  Result := Owner.FGroups.First = Self;
end;

function TdxListGroupCustomViewInfo.IsHorizontalItemsArrangement: Boolean;
begin
  Result := ListView.IsHorizontalItemsArrangement;
end;

function TdxListGroupCustomViewInfo.IsLast: Boolean;
begin
  Result := Owner.FGroups.Last = Self;
end;

function TdxListGroupCustomViewInfo.PrepareVisibleItemsInfo(out AFirstOrderIndex, ALastOrderIndex: Integer): Boolean;
begin
  Result := GetVisibleItemsRange(AFirstOrderIndex, ALastOrderIndex);
  if Result and ListView.OwnerData then
    ListView.OwnerDataHint(AFirstOrderIndex, ALastOrderIndex);
end;

procedure TdxListGroupCustomViewInfo.MouseDown(AButton: TMouseButton; AShift: TShiftState; const AMousePos: TPoint);
var
  AItemViewInfo: TdxListItemCustomViewInfo;
begin
  HotTrackPart := GetHitTest(AMousePos, AItemViewInfo);

  if (HotTrackPart = TdxListGroupHitTest.Header) and Group.IsFocusable and
    (ExplorerStyle or (AButton <> mbMiddle)) then
  begin
    if AButton <> mbMiddle then
      Controller.FSelectItemsGroup := Group;
    Controller.FocusedGroup := Group;
  end;
  if AButton = mbMiddle then
    Exit;
  case HotTrackPart of
    TdxListGroupHitTest.ExpandButton:
      ExpandButtonClick;
    TdxListGroupHitTest.Item:
      Controller.ProcessItemMouseDown(AItemViewInfo, AButton, AShift, AMousePos);
    TdxListGroupHitTest.Content,
    TdxListGroupHitTest.Footer:
      if not (ssCtrl in AShift) then
        Controller.ClearSelection;
  end;
end;

procedure TdxListGroupCustomViewInfo.MouseLeave;
begin
  Invalidate;
end;

procedure TdxListGroupCustomViewInfo.MouseMove(AShift: TShiftState; const AMousePos: TPoint);
var
  AItemViewInfo: TdxListItemCustomViewInfo;
  AHintableObject: TdxListViewCustomViewInfo;
begin
  HotTrackPart := GetHitTest(AMousePos, AItemViewInfo);
  case HotTrackPart of
    TdxListGroupHitTest.Header,
    TdxListGroupHitTest.ExpandButton:
      begin
        Controller.MouseHoveredItemIndex := -1;
        Controller.MouseHoveredGroup := Group;
      end;
    TdxListGroupHitTest.Item:
      begin
        if not ListView.SupportsItemEnabledState or ListView.GetItem(AItemViewInfo.ItemIndex).Enabled then
        begin
          AItemViewInfo.MouseMove([], AMousePos);
          Controller.MouseHoveredItemIndex := AItemViewInfo.ItemIndex;
          AHintableObject := AItemViewInfo.GetHintableObject(AMousePos);
          if AHintableObject <> nil then
            AHintableObject.CheckShowHint;
        end;
        Controller.MouseHoveredGroup := nil;
      end;
  else
    Controller.RemoveContentHottrack;
  end;
end;

procedure TdxListGroupCustomViewInfo.AdjustPositionOnNavigation(AScrollToNext: Boolean);
begin
end;

function TdxListGroupCustomViewInfo.GetFirstFocusableOrderIndex: Integer;
var
  I: Integer;
  AItem: TdxListItem;
begin
  Result := -1;
  if ItemCount = 0 then
    Exit;
  if not ListView.SupportsItemEnabledState then 
    Exit(0);
  for I := 0 to ItemCount - 1 do
  begin
    AItem := ListView.GetItem(Items[I].ItemIndex);
    if AItem.IsEnabled then
      Exit(I);
  end;
end;

function TdxListGroupCustomViewInfo.GetLastFocusableOrderIndex: Integer;
var
  I: Integer;
  AItem: TdxListItem;
begin
  Result := -1;
  if ItemCount = 0 then
    Exit;
  if not ListView.SupportsItemEnabledState then 
    Exit(ItemCount - 1);
  for I := ItemCount - 1 downto 0 do
  begin
    AItem := ListView.GetItem(Items[I].ItemIndex);
    if AItem.IsEnabled then
      Exit(I);
  end;
end;

function TdxListGroupCustomViewInfo.FindFirstItemByRow(var ARow: Integer; out AOrderIndex: Integer): Boolean;
var
  AColumn: Integer;
begin
  AOrderIndex := -1;
  Result := ItemCount > 0;
  if not Result then
    Exit;
  AOrderIndex := Min(ARow, ItemCount - 1);
  if ListView.SupportsItemEnabledState and not ListView.GetItem(Items[AOrderIndex].ItemIndex).IsEnabled then
  begin
    AOrderIndex := GetFirstFocusableOrderIndex;
    Result := AOrderIndex >= 0;
  end;
  if Result then
    GetItemPosition(AOrderIndex, ARow, AColumn);
end;

function TdxListGroupCustomViewInfo.FindLastItemByRow(var ARow: Integer; out AOrderIndex: Integer): Boolean;
var
  ALastItemRow, AColumn: Integer;
begin
  AOrderIndex := -1;
  Result := ItemCount > 0;
  if not Result then
    Exit;
  GetItemPosition(ItemCount - 1, ALastItemRow, AColumn);
  ARow := Min(ARow, ALastItemRow);
  AOrderIndex := AColumn * RowCount + ARow;
  if ListView.SupportsItemEnabledState and not ListView.GetItem(Items[AOrderIndex].ItemIndex).IsEnabled then
  begin
    AOrderIndex := GetLastFocusableOrderIndex;
    Result := AOrderIndex >= 0;
  end;
  if Result then
    GetItemPosition(AOrderIndex, ARow, AColumn);
end;

function TdxListGroupCustomViewInfo.GetItemPosition(AOrderIndex: Integer; out ARow, AColumn: Integer): Boolean;
begin
  Result := InRange(AOrderIndex, 0, ItemCount - 1);
  if not Result then
  begin
    ARow := -1;
    AColumn := -1;
    Exit;
  end;
  if IsReportView then
  begin
    AColumn := 0;
    ARow := AOrderIndex;
  end
  else
    if IsHorizontalItemsArrangement then
    begin
      AColumn := AOrderIndex mod ColumnCount;
      ARow := AOrderIndex div ColumnCount;
    end
    else
    begin
      AColumn := AOrderIndex div RowCount;
      ARow := AOrderIndex mod RowCount;
    end
end;

function TdxListGroupCustomViewInfo.GetNextItem(var AOrderIndex: Integer; ADirectionX, ADirectionY: Integer): Boolean;

  function GetVerticalIndexIncrement(AHorizontalArrangement: Boolean): Integer;
  begin
    if AHorizontalArrangement then
      Result := ColumnCount * ADirectionY
    else
      Result := ADirectionY;
  end;

  function GetHorizontalIndexIncrement(AHorizontalArrangement: Boolean): Integer;
  begin
    if AHorizontalArrangement then
      Result := ADirectionX
    else
      Result := RowCount * ADirectionX
  end;

  function IsLastRow(AIndex: Integer): Boolean;
  begin
    Result := (AIndex div ColumnCount) = (RowCount - 1);
  end;

  function IsLastColumn(AIndex: Integer): Boolean;
  begin
    Result := (AIndex div RowCount) = (ColumnCount - 1);
  end;

var
  ANextOrderIndex, APrevOrderIndex: Integer;
  AHorizontalArrangement: Boolean;
begin
  if not InRange(AOrderIndex, 0, ItemCount - 1) then
    Exit(False);
  ANextOrderIndex := AOrderIndex;
  repeat
    APrevOrderIndex := ANextOrderIndex;
    AHorizontalArrangement := IsHorizontalItemsArrangement;
    if ADirectionY <> 0 then
    begin
      ANextOrderIndex := APrevOrderIndex + GetVerticalIndexIncrement(AHorizontalArrangement);
      if (ADirectionY < 0) and (ANextOrderIndex < 0) then
        Exit(False);
      if (ADirectionY > 0) and (ANextOrderIndex >= ItemCount) then
        if AHorizontalArrangement and not IsLastRow(APrevOrderIndex) then
          ANextOrderIndex := ItemCount - 1
        else
          Exit(False);
    end;
    if ADirectionX <> 0 then
    begin
      if not AHorizontalArrangement and (ColumnCount = 1) then
        Exit(False);
      ANextOrderIndex := APrevOrderIndex + GetHorizontalIndexIncrement(AHorizontalArrangement);
      if (ADirectionX < 0) and (ANextOrderIndex < 0) then
        Exit(False);
      if (ADirectionX > 0) and (ANextOrderIndex >= ItemCount) then
        if not AHorizontalArrangement and not IsLastColumn(APrevOrderIndex) then
          ANextOrderIndex := ItemCount - 1
        else
          Exit(False);
    end;
  until not ListView.SupportsItemEnabledState or ListView.GetItem(OrderIndexToItemIndex(ANextOrderIndex)).IsEnabled;
  AOrderIndex := ANextOrderIndex;
  Result := True;
end;

function TdxListGroupCustomViewInfo.ItemIndexToOrderIndex(AItemIndex: Integer): Integer;
begin
  if IsGroupView then
    Result := Group.ItemIndices.IndexOf(AItemIndex)
  else
    Result := AItemIndex;
end;

function TdxListGroupCustomViewInfo.MakeNextColumnVisible(AScrollToRight: Boolean): Boolean;
begin
  Result := False;
end;

function TdxListGroupCustomViewInfo.GetPrev: TdxListGroupCustomViewInfo;
begin
  if Index > 0 then
    Result := Owner.Groups[Index - 1]
  else
    Result := nil;
end;

function TdxListGroupCustomViewInfo.GetNext: TdxListGroupCustomViewInfo;
begin
  if Index < Owner.GroupCount - 1 then
    Result := Owner.Groups[Index + 1]
  else
    Result := nil;
end;

function TdxListGroupCustomViewInfo.OrderIndexToItemIndex(AVisualIndex: Integer): Integer;
begin
  if IsGroupView then
    Result := Group.ItemIndices[AVisualIndex]
  else
    Result := AVisualIndex;
end;

{ TdxListRootGroupViewInfo }

procedure TdxListRootGroupViewInfo.PopulateItems;
var
  I: Integer;
begin
  for I := 0 to ListView.Items.Count - 1 do
    FItems.Add(Owner.CreateItemViewInfo(Self, I));
end;

{ TdxListGroupTextViewInfo }

procedure TdxListGroupTextViewInfo.CalculateContentBounds;
begin
  if Kind = TdxListViewGroupTextKind.dxlgtFooter then
    inherited CalculateContentBounds
  else
    FContentBounds := Bounds;
end;

constructor TdxListGroupTextViewInfo.Create(AOwner: TdxListGroupViewInfo;
  AKind: TdxListViewGroupTextKind; const AViewParams: TdxListViewCellViewParams);
begin
  inherited Create(AOwner.ListView, AViewParams);
  FKind := AKind;
  FOwner := AOwner;
end;

function TdxListGroupTextViewInfo.GetTextColor: TColor;
begin
  case Kind of
    dxlgtHeader:
      Result := ListView.Fonts.GroupHeader.Color;
    dxlgtSubtitle:
      Result := ListView.Fonts.GroupSubtitle.Color;
  else
    Result := ListView.Fonts.GroupFooter.Color;
  end;
  if Result = clDefault then
    Result := LookAndFeelPainter.GetListViewGroupTextColor(FKind, Owner.HeaderState, ExplorerStyle);
end;

function TdxListGroupTextViewInfo.GetTextFlags: Integer;
begin
  if Kind in [dxlgtHeader, dxlgtSubtitle] then
    Result := Owner.Header.GetHeaderTextFlags
  else
    Result := Owner.GetFooterTextFlags;
end;

function TdxListGroupTextViewInfo.HasGlyph: Boolean;
begin
  Result := False;
end;

function TdxListGroupTextViewInfo.HasStateGlyph: Boolean;
begin
  Result := False;
end;

{ TdxListGroupHeaderViewInfo }

constructor TdxListGroupHeaderViewInfo.Create(AOwner: TdxListGroupViewInfo);
begin
  inherited Create(AOwner.ListView);
  FOwner := AOwner;
  FHeader := TdxListGroupTextViewInfo.Create(AOwner, dxlgtHeader, HeaderParams);
  FSubtitle := TdxListGroupTextViewInfo.Create(AOwner, dxlgtSubtitle, SubtitleParams);
end;

destructor TdxListGroupHeaderViewInfo.Destroy;
begin
  FreeAndNil(FHeader);
  FreeAndNil(FSubtitle);
  inherited Destroy;
end;

procedure TdxListGroupHeaderViewInfo.DrawContent(ACanvas: TcxCustomCanvas);
begin
  if not Empty then
    Painter.DrawGroupHeader(ACanvas, Self);
end;

procedure TdxListGroupHeaderViewInfo.DoRightToLeftConversion(const ABounds: TRect);
begin
  inherited DoRightToLeftConversion(ABounds);
  FContentBounds := TdxRightToLeftLayoutConverter.ConvertRect(FContentBounds, ABounds);
  FExpandButtonBounds := TdxRightToLeftLayoutConverter.ConvertRect(FExpandButtonBounds, ABounds);
  FHeaderLineBounds := TdxRightToLeftLayoutConverter.ConvertRect(FHeaderLineBounds, ABounds);
  FGlyphBounds := TdxRightToLeftLayoutConverter.ConvertRect(FGlyphBounds, ABounds);
  if HasHeader then
    FHeader.RightToLeftConversion(ABounds);
  if HasSubtitle then
    FSubtitle.RightToLeftConversion(ABounds);
end;

function TdxListGroupHeaderViewInfo.ExpandButtonAtLeft: Boolean;
begin
  Result := ExplorerStyle;
end;

function TdxListGroupHeaderViewInfo.GetColorPalette: IdxColorPalette;
begin
  Result := LookAndFeelPainter.GetListViewGroupHeaderColorPalette(HeaderState);
end;

function TdxListGroupHeaderViewInfo.GetExpandButtonState: TcxButtonState;
begin
  Result := Owner.ExpandButtonState;
end;

function TdxListGroupHeaderViewInfo.GetGroup: TdxListGroup;
begin
   Result := Owner.Group;
end;

function TdxListGroupHeaderViewInfo.HasGlyph: Boolean;
begin
  Result := (Group.TitleImage >= 0) and not HeaderParams.GlyphSize.IsZero;
end;

function TdxListGroupHeaderViewInfo.HasExpandButton: Boolean;
begin
  Result := Group.IsCollapsible and Owner.Owner.AreGroupsVertical;
end;

function TdxListGroupHeaderViewInfo.HasHeader: Boolean;
begin
  Result := Group.Header <> '';
end;

function TdxListGroupHeaderViewInfo.HasSubtitle: Boolean;
begin
  Result := Group.Subtitle <> '';
end;

procedure TdxListGroupHeaderViewInfo.Offset(ADX, ADY: Integer);
begin
  inherited Offset(ADX, ADY);
  FContentBounds.Offset(ADX, ADY);
  FExpandButtonBounds.Offset(ADX, ADY);
  FHeaderLineBounds.Offset(ADX, ADY);
  FGlyphBounds.Offset(ADX, ADY);
end;

function TdxListGroupHeaderViewInfo.GetHeaderTextHeight: Integer;
begin
  Result := Owner.Owner.GroupHeaderTextHeight;
end;

function TdxListGroupHeaderViewInfo.GetSubtitleParams: TdxListViewCellViewParams;
begin
  Result := Owner.Owner.GroupSubtitleViewParams;
end;

function TdxListGroupHeaderViewInfo.GetSubtitleTextHeight: Integer;
begin
  Result := Owner.Owner.GroupHeaderSubtitleTextHeight;
end;

procedure TdxListGroupHeaderViewInfo.DoCalculate(AType: TdxChangeType);
var
  R: TRect;
  AIndents: TSize;
  AHasHeaderLine: Boolean;
begin
  inherited DoCalculate(AType);
  FContentBounds := Bounds;
  FEmpty := Bounds.IsEmpty;
  HeaderParams.Padding.Deflate(FContentBounds);
  AIndents.Init(HeaderParams.Padding.Right, HeaderParams.Padding.Top);
  R := FContentBounds;
  if HasExpandButton then
  begin
    if ExpandButtonAtLeft then
    begin
      FExpandButtonBounds.InitSize(R.TopLeft, HeaderParams.StateGlyphSize);
      Inc(R.Left, HeaderParams.StateGlyphSize.cx + AIndents.cx);
    end
    else
    begin
      FExpandButtonBounds.InitSize(R.Right - HeaderParams.StateGlyphSize.cx, R.Top, HeaderParams.StateGlyphSize);
      R.Right := FExpandButtonBounds.Left - AIndents.cx;
    end;
    FExpandButtonBounds.Offset(0, (R.Height - HeaderParams.StateGlyphSize.cy) div 2);
  end;
  if HasGlyph then
  begin
    FGlyphBounds.InitSize(R.TopLeft, HeaderParams.GlyphSize);
    R.Left := FGlyphBounds.Right + AIndents.cx;
  end;
  R.Height := GetHeaderHeight;
  if R.IsEmpty then
  begin
    if HasHeader then
      Header.FTextBounds.Empty;
    if HasSubtitle then
      Subtitle.FTextBounds.Empty;
    Exit;
  end;

  AHasHeaderLine := Group.HeaderAlign <> taCenter;
  if AHasHeaderLine then
  begin
    FHeaderLineBounds.Init(R.Left, R.CenterPoint.Y, R.Right, R.CenterPoint.Y + ScaleFactor.Apply(1));
    if ExplorerStyle and (Group.HeaderAlign = taLeftJustify) then
      Dec(R.Right, 4 * AIndents.cx);
  end
  else
    FHeaderLineBounds.Empty;

  if HasHeader then
  begin
    FHeader.Initialize(Group.Header, -1); 
    FHeader.Calculate(AType, R);
    if AHasHeaderLine then
      case Group.HeaderAlign of
        taLeftJustify:
          FHeaderLineBounds.Left := Header.TextBounds.Right + AIndents.cx;
        taRightJustify:
          FHeaderLineBounds.Right := Header.TextBounds.Left - AIndents.cx;
      end;
  end;
  R.Top := R.Bottom + AIndents.cy;
  if HasSubtitle then
  begin
    FSubtitle.Initialize(Group.Subtitle, -1);
    R.Height := SubtitleTextHeight;
    FSubtitle.Calculate(AType, R);
  end;
end;

function TdxListGroupHeaderViewInfo.GetContentHeight: Integer;
begin
  Result := GetHeaderHeight;
  if HasSubtitle then
  begin
    Inc(Result, SubtitleTextHeight);
    if Group.Header <> '' then
      Inc(Result, HeaderParams.Padding.Top); 
  end;
  Result := Max(Result, HeaderParams.GlyphSize.cy);
  Result := Max(Result, HeaderParams.StateGlyphSize.cy);
end;

function TdxListGroupHeaderViewInfo.GetHeaderHeight: Integer;
begin
  Result := 0;
  if HasHeader then
    Inc(Result, HeaderTextHeight)
  else
    Inc(Result, ScaleFactor.Apply(GroupHeaderLineHeight));
end;

function TdxListGroupHeaderViewInfo.GetHeight: Integer;
begin
  Result := GetContentHeight;
  Inc(Result, HeaderParams.Padding.Height);
end;

function TdxListGroupHeaderViewInfo.GetHeaderParams: TdxListViewCellViewParams;
begin
  Result := Owner.Owner.GroupHeaderViewParams;
end;

function TdxListGroupHeaderViewInfo.GetHeaderState: TdxListViewGroupHeaderStates;
begin
  Result := Owner.HeaderState;
end;

function TdxListGroupHeaderViewInfo.GetHeaderTextFlags: Integer;
begin
  Result := HeaderParams.TextFlags or HorizontalAlignmentMap[Group.HeaderAlign];
end;

{ TdxListGroupViewInfo }

destructor TdxListGroupViewInfo.Destroy;
begin
  FreeAndNil(FHeader);
  FreeAndNil(FFooter);
  inherited Destroy;
end;

function TdxListGroupViewInfo.GetFocused: Boolean;
begin
  Result := ListView.Controller.FocusedGroup = Group;
end;

function TdxListGroupViewInfo.GetHotTracked: Boolean;
begin
  Result := ListView.Controller.MouseHoveredGroup = Group;
end;

function TdxListGroupViewInfo.HasFooter: Boolean;
begin
  Result := HasHeader and (Group.Footer <> '');
end;

function TdxListGroupViewInfo.HasHeader: Boolean;
begin
  Result := not (TdxListGroupOption.NoHeader in Group.Options);
end;

function TdxListGroupViewInfo.GetCollapsed: Boolean;
begin
  Result := Group.Collapsed and Owner.AreGroupsVertical;
end;

function TdxListGroupViewInfo.GetHitTest(const P: TPoint; out AItemViewInfo: TdxListItemCustomViewInfo): TdxListGroupHitTest;
begin
  Result := inherited GetHitTest(P, AItemViewInfo);
  if Result in [TdxListGroupHitTest.Content, TdxListGroupHitTest.None] then
  begin
    if FooterBounds.Contains(P) then
      Exit(TdxListGroupHitTest.Footer);
    if HasHeader then
    begin
      if Header.ExpandButtonBounds.Contains(P) then
        Exit(TdxListGroupHitTest.ExpandButton);
      if Header.Bounds.Contains(P) then
        Exit(TdxListGroupHitTest.Header);
    end;
  end;
end;

procedure TdxListGroupViewInfo.Invalidate;
begin
  if HasHeader then
    Header.Invalidate;
end;

procedure TdxListGroupViewInfo.BeforeDraw(ACanvas: TcxCustomCanvas);
begin
  FExpandButtonState := GetExpandButtonState;
  FHeaderState := GetHeaderState;
end;

function TdxListGroupViewInfo.GetFooterHeight: Integer;
begin
  Result := Owner.GroupFooterHeight;
end;

function TdxListGroupViewInfo.GetFooterParams: TdxListViewCellViewParams;
begin
  Result := Owner.GroupFooterViewParams;
end;

procedure TdxListGroupViewInfo.CalculateContent(AType: TdxChangeType);
begin
  if HasHeader then
    CalculateHeader(AType);
  if not Collapsed then
    inherited CalculateContent(AType);
  if HasFooter then
    CalculateFooter(AType);
end;

function TdxListGroupViewInfo.CalculateContentBottom: Integer;
begin
  if HasFooter then
    Result := FooterBounds.Bottom
  else
    if Collapsed then
    begin
      if HasHeader then
        Result := Bounds.Top + Header.GetHeight
      else
        Result := FContentBounds.Top;
    end
    else
      Result := ItemsAreaBounds.Bottom + ContentPadding.Bottom;
end;

procedure TdxListGroupViewInfo.CalculateContentBounds;
begin
  inherited CalculateContentBounds;
  FContentBounds := Bounds;
  FContentBounds.Bottom := CalculateContentBottom;
  FContentBounds.Right := CalculateContentRight;
end;

function TdxListGroupViewInfo.CalculateContentRight: Integer;
begin
  if IsHorizontalItemsArrangement then
  begin
    if Collapsed then
      Result := Bounds.Right
    else
      Result := ItemsAreaBounds.Right + ContentPadding.Right
  end
  else
    if Collapsed then
      Result := Bounds.Left + CalculateHeaderWidth
    else
      Result := ItemsAreaBounds.Right + ContentPadding.Right;
end;

function TdxListGroupViewInfo.CalculateHeaderWidth: Integer;
begin
  if Owner.AreGroupsVertical then
    Result := Owner.GetAvailableGroupsAreaWidth
  else
  begin
    Result := ColumnCount * ItemSize.cx + (ColumnCount - 1) * GetGapBetweenItems;
    Inc(Result, ContentPadding.Width);
  end;
  Result := Max(Result, ItemSize.cx);
end;

procedure TdxListGroupViewInfo.PopulateItems;
var
  I: Integer;
begin
  for I := 0 to Group.ItemCount - 1 do
    FItems.Add(Owner.CreateItemViewInfo(Self, Group.ItemIndices[I]));
end;

procedure TdxListGroupViewInfo.CalculateFooter(AType: TdxChangeType);
begin
  if Group.Footer <> '' then
  begin
    FFooterBounds := Header.Bounds;
    if Collapsed then
      FFooterBounds.Top := Header.Bounds.Bottom
    else
    begin
      FFooterBounds.Top := ItemsAreaBounds.Bottom;
      Inc(FFooterBounds.Top, ContentPadding.Bottom);
    end;
    FFooterBounds.Right := Min(FFooterBounds.Right, Owner.Bounds.Right - Owner.ContentOffset.Right);
    FFooterBounds.Height := Owner.GroupFooterHeight;
    if AType >= ctMedium  then
    begin
      if Footer = nil then
        FFooter := TdxListGroupTextViewInfo.Create(Self, dxlgtFooter, FooterParams);
      Footer.Initialize(Group.Footer, -1);
    end;
    if FFooterBounds.IsEmpty then
    begin
      FFooterBounds.Empty;
      Footer.FTextBounds.Empty;
    end
    else
      Footer.Calculate(AType, FooterBounds);
  end
  else
    FFooterBounds.Empty;
end;

function TdxListGroupViewInfo.GetHeaderBounds: TRect;
begin
  Result := Bounds;
  Result.Bottom := Result.Top + Header.GetHeight;
  if IsReportView then
  begin
    Result.Right := Bounds.Right;
    if Owner.ColumnHeadersViewInfo <> nil then
      Result.Right := Max(Bounds.Right, Owner.ColumnHeadersViewInfo.Bounds.Right)
    else
      Result.Right := Max(Bounds.Right, Bounds.Left + Owner.FColumnHeadersWidth);
  end
  else
    Result.Width := CalculateHeaderWidth;
end;

procedure TdxListGroupViewInfo.CalculateHeader(AType: TdxChangeType);
begin
  if FHeader = nil then
    FHeader := TdxListGroupHeaderViewInfo.Create(Self);
  FHeader.Calculate(AType, GetHeaderBounds);
end;

procedure TdxListGroupViewInfo.CalculateItemsArea;
begin
  FItemsAreaBounds := Bounds;
  if HasHeader then
    FItemsAreaBounds.Top := Bounds.Top + Header.GetHeight;
  FItemsAreaBounds.Deflate(ContentPadding);
end;

procedure TdxListGroupViewInfo.CalculateRowAndColumnCount;
begin
  if HasHeader and (Header = nil) then
    FHeader := TdxListGroupHeaderViewInfo.Create(Self);
  inherited CalculateRowAndColumnCount;
end;

procedure TdxListGroupViewInfo.DoRightToLeftConversion(const ABounds: TRect);
begin
  inherited DoRightToLeftConversion(ABounds);
  FFooterBounds := TdxRightToLeftLayoutConverter.ConvertRect(FFooterBounds, ABounds);
  FSubtitleBounds := TdxRightToLeftLayoutConverter.ConvertRect(FSubtitleBounds, ABounds);
  if HasHeader then
    FHeader.RightToLeftConversion(ABounds);
  if HasFooter then
    FFooter.RightToLeftConversion(ABounds);
end;

procedure TdxListGroupViewInfo.DrawContent(ACanvas: TcxCustomCanvas);
begin
  if HasHeader then
    Header.Draw(ACanvas);
  if HasFooter then
    Painter.DrawGroupText(ACanvas, Footer);
  if not Collapsed then
    inherited DrawContent(ACanvas);
end;

procedure TdxListGroupViewInfo.ExpandButtonClick;
begin
  ListView.InvalidateRect(Header.ExpandButtonBounds, True);
  if Group.IsCollapsible then
    Group.Collapsed := not Group.Collapsed;
end;

function TdxListGroupViewInfo.GetAvailableHeightForItems: Integer;
begin
  Result := inherited GetAvailableHeightForItems;
  if HasHeader then
    Dec(Result, Header.GetHeight + ContentPadding.Height);
  if HasFooter then
    Dec(Result, FooterHeight);
end;

function TdxListGroupViewInfo.GetAvailableWidthForItems: Integer;
begin
  Result := inherited GetAvailableWidthForItems;
  Dec(Result, ContentPadding.Width);
end;

function TdxListGroupViewInfo.GetContentPadding: TdxPadding;
begin
  Result := Owner.GroupContentPadding;
end;

function TdxListGroupViewInfo.GetExpandButtonState: TcxButtonState;
begin
  if HasHeader and Header.ExpandButtonBounds.Contains(ListView.GetMouseCursorClientPos) then
  begin
    if GetAsyncKeyState(VK_LBUTTON) < 0 then
      Result := cxbsPressed
    else
      Result := cxbsHot;
  end
  else
    Result := cxbsNormal;
end;

function TdxListGroupViewInfo.GetFooterTextFlags: Integer;
begin
  Result := Owner.GroupFooterViewParams.TextFlags or HorizontalAlignmentMap[Group.FooterAlign];
end;

function TdxListGroupViewInfo.GetHeaderHeight: Integer;
begin
  if not HasHeader then
    Exit(0);
  Result := Header.GetHeight;
end;

function TdxListGroupViewInfo.GetHeaderState: TdxListViewGroupHeaderStates;
begin
  Result := [];
  if (ExpandButtonState = cxbsNormal) and HotTracked and not ListView.IsDragging then
    Include(Result, dxlgsHot);
  if Focused then
    Include(Result, dxlgsFocused);
  if Collapsed then
    Include(Result, dxlgsCollapsed);
  if not ListView.Focused then
    Include(Result, dxlgsInactive);
end;

procedure TdxListGroupViewInfo.InvalidatePart(APart: TdxListGroupHitTest);
begin
  case APart of
    TdxListGroupHitTest.ExpandButton:
      ListView.InvalidateRect(Header.ExpandButtonBounds, True);
    TdxListGroupHitTest.Header:
      Header.Invalidate;
  end;
end;

procedure TdxListGroupViewInfo.AdjustPositionOnNavigation(AScrollToNext: Boolean);
var
  ABounds: TRect;
begin
  if not HasHeader then
    Exit;
  if Owner.AreGroupsVertical then
  begin
    if not AScrollToNext then
      Exit;
  end
  else
  begin
    if AScrollToNext or (ColumnCount = 1) then
      ABounds.InitSize(TPoint.Create(ItemsAreaBounds.Left, Header.Bounds.Top), ItemSize)
    else
      ABounds.InitSize(TPoint.Create(ItemsAreaBounds.Right - ItemSize.cx, Header.Bounds.Top), ItemSize);
    ListView.MakeVisible(ABounds, vtFully);
  end;
end;

function TdxListGroupViewInfo.MakeNextColumnVisible(AScrollToRight: Boolean): Boolean;
var
  AColumnIndex, AColumnEdge, AGapBetweenItems: Integer;
  AVisibleBounds: TRect;
begin
  if not HasHeader then
    Exit(False);
  AGapBetweenItems := GetGapBetweenItems;
  AVisibleBounds := Header.Bounds;
  if AScrollToRight then
  begin
    AColumnEdge := ItemsAreaBounds.Left;
    for AColumnIndex := 0 to ColumnCount - 1 do
    begin
      if AColumnEdge + ItemSize.cx <= Owner.Bounds.Right then
      begin
        Inc(AColumnEdge, ItemSize.cx + AGapBetweenItems);
        Continue;
      end;
      AVisibleBounds.Left  := AColumnEdge;
      AVisibleBounds.Right := AColumnEdge + ItemSize.cx;
      ListView.MakeVisible(AVisibleBounds, vtFully);
      Exit(True);
    end;
    if IsLast then
      Exit(True);
  end
  else
  begin
    AColumnEdge := ItemsAreaBounds.Right;
    for AColumnIndex := 0 to ColumnCount - 1 do
    begin
      if AColumnEdge - ItemSize.cx >= Owner.Bounds.Left then
      begin
        Dec(AColumnEdge, ItemSize.cx + AGapBetweenItems);
        Continue;
      end;
      AVisibleBounds.Right  := AColumnEdge;
      AVisibleBounds.Left := AColumnEdge - ItemSize.cx;
      ListView.MakeVisible(AVisibleBounds, vtFully);
      Exit(True);
    end;
    if IsFirst then
      Exit(True);
  end;
  Result := False;
end;

procedure TdxListGroupViewInfo.MouseLeave;
begin
  inherited;
  FHeaderState := [];
end;

{ TdxListViewHintHelper }

constructor TdxListViewHintHelper.Create(AListView: TdxCustomListView);
begin
  inherited Create;
  FListView := AListView;
end;

procedure TdxListViewHintHelper.CorrectHintWindowRect(var ARect: TRect);
begin
  inherited CorrectHintWindowRect(ARect);
end;

function TdxListViewHintHelper.GetOwnerControl: TcxControl;
begin
  Result := FListView;
end;

{ TdxListViewViewInfo }

constructor TdxListViewViewInfo.Create(AListView: TdxCustomListView);
begin
  inherited Create(AListView);
  FGroups := TdxFastObjectList.Create;
  FItems := TDictionary<Integer, TdxListItemCustomViewInfo>.Create;
  FItemViewParams := TdxListViewCellViewParams.Create;
  FGroupHeaderViewParams := TdxListViewCellViewParams.Create;
  FGroupFooterViewParams := TdxListViewCellViewParams.Create;
  FGroupSubtitleViewParams := TdxListViewCellViewParams.Create;
end;

destructor TdxListViewViewInfo.Destroy;
begin
  FreeAndNil(FEmptyTextLayout);
  FreeAndNil(FColumnHeadersViewInfo);
  FreeAndNil(FGroups);
  FreeAndNil(FItemViewParams);
  FreeAndNil(FGroupHeaderViewParams);
  FreeAndNil(FGroupFooterViewParams);
  FreeAndNil(FGroupSubtitleViewParams);
  FreeAndNil(FItems);
  inherited Destroy;
end;

function TdxListViewViewInfo.GetContentOffset: TRect;
begin
  Result := ListView.PaddingOptions.View.Margin;
end;

function TdxListViewViewInfo.GetItemCount: Integer;
begin
  Result := FItems.Count;
end;

function TdxListViewViewInfo.FindGroupViewInfo(AGroup: TdxListGroup; out AViewInfo: TdxListGroupCustomViewInfo): Boolean;
var
  AGroupViewInfo: TdxListGroupCustomViewInfo;
  I: Integer;
begin
  for I := 0 to GroupCount - 1 do
  begin
    AGroupViewInfo := Groups[I];
    if AGroupViewInfo.Group = AGroup then
    begin
      AViewInfo := AGroupViewInfo;
      Exit(True);
    end;
  end;
  Result := False;
end;

function TdxListViewViewInfo.FindGroupViewInfo(AItemIndex: Integer; out AViewInfo: TdxListGroupCustomViewInfo): Boolean;
var
  AGroupViewInfo: TdxListGroupCustomViewInfo;
  I: Integer;
begin
  if not IsGroupView then
  begin
    AViewInfo := Groups[0];
    Exit(True);
  end
  else
  begin
    for I := 0 to GroupCount - 1 do
    begin
      AGroupViewInfo := Groups[I];
      if AGroupViewInfo.Group.ItemIndices.Contains(AItemIndex) then
      begin
        AViewInfo := AGroupViewInfo;
        Exit(True);
      end;
    end;
  end;
  AViewInfo := nil;
  Result := False;
end;

function TdxListViewViewInfo.FindGroupViewInfo(AItemIndex: Integer; out AViewInfo: TdxListGroupCustomViewInfo; out AIndexInGroup: Integer): Boolean;
begin
  Result := FindGroupViewInfo(AItemIndex, AViewInfo);
  if Result then
    AIndexInGroup := AViewInfo.ItemIndexToOrderIndex(AItemIndex)
  else
    AIndexInGroup := -1;
end;

function TdxListViewViewInfo.FindGroupViewInfo(AItem: TdxListItem; out AViewInfo: TdxListGroupCustomViewInfo): Boolean;
var
  AGroupViewInfo: TdxListGroupCustomViewInfo;
  I: Integer;
begin
  if not IsGroupView then
  begin
    AViewInfo := Groups[0];
    Exit(True);
  end
  else
  begin
    for I := 0 to GroupCount - 1 do
    begin
      AGroupViewInfo := Groups[I];
      if AGroupViewInfo.Group = AItem.Group then
      begin
        AViewInfo := AGroupViewInfo;
        Exit(True);
      end;
    end;
  end;
  Result := False;
end;

function TdxListViewViewInfo.FindItemViewInfo(AItemIndex: Integer; out AViewInfo: TdxListItemCustomViewInfo): Boolean;
begin
  Result := (AItemIndex >= 0) and Items.TryGetValue(AItemIndex, AViewInfo);
  if not Result then
    AViewInfo := nil;
end;

function TdxListViewViewInfo.GetGroupAtPos(const P: TPoint; out AViewInfo: TdxListGroupCustomViewInfo): Boolean;
var
  AGroupViewInfo: TdxListGroupCustomViewInfo;
  I: Integer;
begin
  if not GetGroupVisibleBounds.Contains(P) then
    Exit(False);
  for I := 0 to GroupCount - 1 do
  begin
    AGroupViewInfo := Groups[I];
    if AGroupViewInfo.GetHitTestBounds.Contains(P) then
    begin
      AViewInfo := AGroupViewInfo;
      Exit(True);
    end;
  end;
  Result := False;
end;

function TdxListViewViewInfo.GetItemAtPos(const P: TPoint; out AViewInfo: TdxListItemCustomViewInfo): Boolean;
var
  AGroupViewInfo: TdxListGroupCustomViewInfo;
begin
  Result := GetGroupAtPos(P, AGroupViewInfo) and AGroupViewInfo.GetItemAtPos(P, AViewInfo);
end;

procedure TdxListViewViewInfo.InvalidateItem(AItemIndex: Integer);
var
  AItemViewInfo: TdxListItemCustomViewInfo;
begin
  if Items.TryGetValue(AItemIndex, AItemViewInfo) then
    AItemViewInfo.Invalidate;
end;

function TdxListViewViewInfo.AreGroupsVertical: Boolean;
begin
  case ListView.ViewStyle of
    TdxListViewStyle.Icon:
      Result := ListView.ViewStyleIcon.Arrangement = TdxListIconsArrangement.Horizontal;
    TdxListViewStyle.SmallIcon:
      Result := ListView.ViewStyleSmallIcon.Arrangement = TdxListIconsArrangement.Horizontal;
    TdxListViewStyle.List:
      Result := False;
  else 
    Result := True;
  end;
end;

function TdxListViewViewInfo.CalculateColumnHeaderGlyphsAreaSize: TSize;
begin
  Result := CalculateImagesGlyphSize(ListView.ImageOptions.ColumnHeaderImages);
end;

procedure TdxListViewViewInfo.CalculateColumnHeaders(AType: TdxChangeType; out AHeaderHeight: Integer);
var
  AHeadersBounds: TRect;
begin
  if ColumnHeadersViewInfo <> nil then
  begin
    AHeadersBounds.InitSize(Bounds.Left - ListView.LeftPos, Bounds.Top, 0, 0);
    ColumnHeadersViewInfo.Calculate(AType, AHeadersBounds);
    AHeaderHeight := ColumnHeadersViewInfo.Bounds.Height;
  end
  else
    AHeaderHeight := 0;
end;

function TdxListViewViewInfo.GetItemBoundsForMakeVisible(AItemIndex: Integer): TRect;
var
  AGroupViewInfo: TdxListGroupCustomViewInfo;
  AOrderIndex: Integer;
begin
  if not FindGroupViewInfo(AItemIndex, AGroupViewInfo, AOrderIndex) then
    Exit(TRect.Null)
  else
  begin
    Result := AGroupViewInfo.GetBoundsForItem(AOrderIndex, True);
    if ListView.UseRightToLeftAlignment then
      Result := TdxRightToLeftLayoutConverter.ConvertRect(Result, ListView.ClientBounds);
  end;
end;

procedure TdxListViewViewInfo.CalculateContent(AType: TdxChangeType);
var
  I, AHeaderHeight: Integer;
  AGroupViewInfo: TdxListGroupCustomViewInfo;
  AGroupAreaBounds: TRect;
begin
  if ListView.HandleAllocated then
  begin
    FContentBounds.Init(
      Bounds.Left - ListView.LeftPos + ContentOffset.Left,
      Bounds.Top  - ListView.TopPos + ContentOffset.Top,
      Bounds.Right - ContentOffset.Right,
      Bounds.Bottom - ContentOffset.Bottom);
    CalculateColumnHeaders(AType, AHeaderHeight);
    Inc(FContentBounds.Top, AHeaderHeight);
    if FContentBounds.IsEmpty then
      Exit;
    AGroupAreaBounds := ContentBounds;
    for I := 0 to GroupCount - 1 do
    begin
      AGroupViewInfo := Groups[I];
      if AGroupViewInfo.IsHorizontalItemsArrangement then
        AGroupAreaBounds.Bottom := MaxInt
      else
        if not IsReportView then
          AGroupAreaBounds.Right := MaxInt
        else
          AGroupAreaBounds.Bottom := Bounds.Bottom;
      AGroupViewInfo.Calculate(AType, AGroupAreaBounds);
      if AreGroupsVertical then
        AGroupAreaBounds.Offset(0, AGroupViewInfo.ContentBounds.Height)
      else
        AGroupAreaBounds.Offset(AGroupViewInfo.ContentBounds.Width, 0);
    end;
    CalculateEmptyText;
  end;
end;

procedure TdxListViewViewInfo.CalculateContentBounds;
var
  I: Integer;
  AGroupContentBounds: TRect;
begin
  FContentBounds.Empty;
  if ListView.HandleAllocated then
  begin
    if GroupCount = 0 then
      Exit;
    FContentBounds := Groups[0].ContentBounds;
    for I := 1 to GroupCount - 1 do
    begin
      AGroupContentBounds := Groups[I].ContentBounds;
      FContentBounds.Bottom := Max(FContentBounds.Bottom, AGroupContentBounds.Bottom);
      FContentBounds.Right := Max(FContentBounds.Right, AGroupContentBounds.Right);
    end;
    if ColumnHeadersViewInfo <> nil then
    begin
      Inc(FContentBounds.Bottom, ColumnHeadersViewInfo.Bounds.Height);
      FContentBounds.Width := Max(FContentBounds.Width, ColumnHeadersViewInfo.Bounds.Width);
    end;
  end;
end;

procedure TdxListViewViewInfo.CalculateCommonParameters;
begin
  FGroupContentPadding := ListView.PaddingOptions.GroupContent.Margin;
  CalculateViewParams;
end;

procedure TdxListViewViewInfo.CalculateColumnHeadersWidth;
var
  I: Integer;
begin
  FColumnHeadersWidth := 0;
  for I := 0 to ListView.Columns.Count - 1 do
    Inc(FColumnHeadersWidth, ListView.Columns[I].Width);
end;

procedure TdxListViewViewInfo.CalculateEmptyText;
begin
  if (ListView.EmptyText = '') or (ItemCount > 0) then
  begin
    FreeAndNil(FEmptyTextLayout);
    Exit;
  end;
  if FEmptyTextLayout = nil then
    FEmptyTextLayout := Painter.CreateCanvasBasedTextLayout;
  FEmptyTextLayout.SetText(ListView.EmptyText);
  FEmptyTextLayout.SetFlags(CXTO_CENTER_HORIZONTALLY or CXTO_CENTER_VERTICALLY or CXTO_WORDBREAK or IfThen(UseRightToLeftAlignment, CXTO_RTLREADING));
  FEmptyTextLayout.SetFont(ItemViewParams.Font);
  FEmptyTextLayout.SetColor(LookAndFeelPainter.GetListViewItemTextColor([dxlisDisabled], ExplorerStyle));
end;

function TdxListViewViewInfo.CalculateImagesGlyphSize(AImages: TCustomImageList): TSize;
begin
  if AImages <> nil then
  begin
    Result.Init(AImages.Width, AImages.Height);
    if ListView.ImageOptions.ScaleOnDPIChanges then
      Result := ScaleFactor.Apply(Result);
  end
  else
    Result.Init(0, 0);
end;

function TdxListViewViewInfo.CalculateItemStateGlyphSize: TSize;
begin
  case GetItemStateViewKind of
    TdxListItemStateViewKind.CheckBox:
      Result := Painter.LookAndFeelPainter.ScaledCheckButtonSize(ScaleFactor);
    TdxListItemStateViewKind.Glyph:
      Result := CalculateImagesGlyphSize(ItemViewParams.StateImages);
  else
    Result.Init(0, 0);
  end;
end;

function TdxListViewViewInfo.IsOverlappedItemStateGlyph: Boolean;
begin
  Result := ListView.ExplorerStyle and (ListView.ViewStyle = TdxListViewStyle.Icon);
end;

function TdxListViewViewInfo.CalculateItemGlyphsAreaSize: TSize;
begin
  Result := ItemViewParams.GlyphSize;
  if ListView.ViewStyle = TdxListViewStyle.Icon then
    Inc(Result.cx, 2 * ScaleFactor.Apply(GetIconsGlyphSideGap));
  if ItemViewParams.StateGlyphSize.IsZero then
    Exit;
  if not IsOverlappedItemStateGlyph then
  begin
    if (Result.cx > 0) and (ItemViewParams.StateGlyphSize.cx > 0) then
      Inc(Result.cx, ItemViewParams.GlyphIndent.cx);
    Inc(Result.cx, ItemViewParams.StateGlyphSize.cx);
  end;
  Result.cy := Max(Result.cy, ItemViewParams.StateGlyphSize.cy);
end;

function TdxListViewViewInfo.CalculateItemTextSize: TSize;
begin
  case ListView.ViewStyle of
    TdxListViewStyle.SmallIcon:
      Result.cx := ListView.ViewStyleSmallIcon.ColumnWidth - ItemViewParams.GetNonTextWidth;
    TdxListViewStyle.Icon:
      Result.cx := Max(1, FItemViewParams.Padding.Width);
    TdxListViewStyle.List:
      Result.cx := ListView.ViewStyleList.ColumnWidth - ItemViewParams.GetNonTextWidth;
  end;
  Result.cy := TdxTextMeasurer.TextLineHeight(ListView.Fonts.Item) * Max(1, FItemViewParams.TextLineCount);
end;

function TdxListViewViewInfo.GetItemStateViewKind: TdxListItemStateViewKind;
begin
  if ListView.Checkboxes then
    Result := TdxListItemStateViewKind.CheckBox
  else if ListView.ImageOptions.StateImages <> nil then
    Result := TdxListItemStateViewKind.Glyph
  else
    Result := TdxListItemStateViewKind.None;
end;

function TdxListViewViewInfo.GetScrollArea: TRect;
begin
  Result := GetGroupVisibleBounds;
end;

function TdxListViewViewInfo.GetGroupVisibleBounds: TRect;
begin
  Result := ListView.ClientBounds;
  if ColumnHeadersViewInfo <> nil then
    Result.Top := ColumnHeadersViewInfo.Bounds.Bottom;
end;

procedure TdxListViewViewInfo.CalculateItemSize;
var
  ATextAreaSize: TSize;
begin
  ATextAreaSize := CalculateItemTextSize;
  if ItemViewParams.TextPosition in [posTop, posBottom] then
  begin
    FItemSize.Init(
      Max(ATextAreaSize.cx, ItemViewParams.GlyphsAreaSize.cx), ATextAreaSize.cy);
    if ItemViewParams.GlyphsAreaSize.cy > 0 then
      Inc(FItemSize.cy, ItemViewParams.GlyphIndent.cy + ItemViewParams.GlyphsAreaSize.cy);
  end
  else
  begin
    FItemSize.Init(
      ATextAreaSize.cx + ItemViewParams.GlyphIndent.cx + ItemViewParams.GlyphsAreaSize.cx,
      Max(ATextAreaSize.cy, ItemViewParams.GlyphsAreaSize.cy));
  end;
  Inc(FItemSize.cx, ItemViewParams.Padding.Width);
  Inc(FItemSize.cy, ItemViewParams.Padding.Height);
  if IsReportView then
    if ListView.Columns.Count > 0 then
      FItemSize.cx := FColumnHeadersWidth
    else
      FItemSize.cx := TdxListColumn.DefaultColumnWidth;
  Assert(FItemSize.cx > 0);
end;

procedure TdxListViewViewInfo.CalculateCommonViewParams(AViewParams: TdxListViewCellViewParams;
  APadding: TdxPadding; AFont: TFont; AImages: TCustomImageList);
begin
  AViewParams.Padding := APadding;
  AViewParams.Font.Free;
  AViewParams.Font := Painter.CreateCanvasBasedFont(AFont);
  AViewParams.GdiFont := AFont;
  AViewParams.Images := AImages;
  AViewParams.GlyphSize := CalculateImagesGlyphSize(AImages);

  AViewParams.GlyphIndent := ScaleFactor.Apply(GetDefaultItemGlyphIndent);
  AViewParams.StateViewKind := TdxListItemStateViewKind.None;
end;

procedure TdxListViewViewInfo.CalculateItemViewParams(AViewParams: TdxListViewCellViewParams);
var
  AItemPadding: TdxPadding;
  APadding: TRect;
begin
  APadding := ScaleFactor.Apply(LookAndFeelPainter.GetListViewItemContentPadding);
  AItemPadding := ListView.PaddingOptions.Item.Margin;
  AItemPadding.InflatePadding(APadding);
  CalculateCommonViewParams(AViewParams, APadding, ListView.Fonts.Item, GetItemGlyphImages);

  AViewParams.StateViewKind := GetItemStateViewKind;
  AViewParams.StateImages := ListView.ImageOptions.StateImages;
  AViewParams.StateGlyphSize := CalculateItemStateGlyphSize;
  AViewParams.GlyphsAreaSize := CalculateItemGlyphsAreaSize;
  AViewParams.TextFlags := GetItemTextFlags;
  AViewParams.TextPosition := GetItemTextPosition;
  AViewParams.TextLineCount := GetItemTextLineCount;
end;

procedure TdxListViewViewInfo.CalculateGroupCommonViewParams(AViewParams: TdxListViewCellViewParams;
  AFont: TFont; AImages: TCustomImageList; AUsePainterPadding: Boolean);
var
  AGroupPadding: TdxPadding;
  APadding: TRect;
begin
  if AUsePainterPadding then
  begin
    APadding := LookAndFeelPainter.GetListViewItemContentPadding;
    AGroupPadding := ListView.PaddingOptions.GroupHeader.Margin;
    AGroupPadding.InflatePadding(APadding, UseRightToLeftAlignment);
  end
  else
    APadding := ListView.PaddingOptions.GroupHeader.Margin;
  CalculateCommonViewParams(AViewParams, APadding, AFont, AImages);
  AViewParams.TextFlags := CXTO_PREVENT_LEFT_EXCEED or CXTO_PREVENT_TOP_EXCEED or
    CXTO_END_ELLIPSIS or CXTO_SINGLELINE or CXTO_CENTER_VERTICALLY or IfThen(UseRightToLeftAlignment, CXTO_RTLREADING);
  AViewParams.TextPosition := posRight;
  AViewParams.TextLineCount := 1;
end;

procedure TdxListViewViewInfo.CalculateGroupHeaderViewParams(AViewParams: TdxListViewCellViewParams);
begin
  CalculateGroupCommonViewParams(AViewParams, ListView.Fonts.GroupHeader, ListView.ImageOptions.GroupHeaderImages, True);
  AViewParams.GlyphsAreaSize := AViewParams.GlyphSize;
  AViewParams.StateGlyphSize.Init(LookAndFeelPainter.GetListViewExpandButtonSize(ScaleFactor));
end;

procedure TdxListViewViewInfo.CalculateGroupSubtitleViewParams(AViewParams: TdxListViewCellViewParams);
begin
  CalculateGroupCommonViewParams(AViewParams, ListView.Fonts.GroupSubtitle, nil, False);
  AViewParams.Padding := TRect.Null;
end;

procedure TdxListViewViewInfo.CalculateGroupFooterViewParams(AViewParams: TdxListViewCellViewParams);
begin
  CalculateGroupCommonViewParams(AViewParams, ListView.Fonts.GroupFooter, nil, False);
end;

procedure TdxListViewViewInfo.CalculateGroupHeaderSizes;
begin
  FGroupHeaderTextHeight := TdxTextMeasurer.TextLineHeight(ListView.Fonts.GroupHeader);
  FGroupHeaderSubtitleTextHeight := TdxTextMeasurer.TextLineHeight(ListView.Fonts.GroupSubtitle);
  FGroupFooterHeight := TdxTextMeasurer.TextLineHeight(ListView.Fonts.GroupFooter);
  Inc(FGroupFooterHeight, GroupHeaderViewParams.Padding.Height);
end;

procedure TdxListViewViewInfo.CalculateGroupViewParams;
begin
  CalculateGroupHeaderViewParams(FGroupHeaderViewParams);
  CalculateGroupSubtitleViewParams(FGroupSubtitleViewParams);
  CalculateGroupFooterViewParams(FGroupFooterViewParams);
  CalculateGroupHeaderSizes;
end;

procedure TdxListViewViewInfo.CalculateViewParams;
begin
  CalculateItemViewParams(FItemViewParams);
  if IsGroupView then
    CalculateGroupViewParams;
  if ColumnHeadersViewInfo <> nil then
    ColumnHeadersViewInfo.CalculateViewParams;
end;

function TdxListViewViewInfo.CreateGroupViewInfo(AGroup: TdxListGroup): TdxListGroupViewInfo;
begin
  Result := TdxListGroupViewInfo.Create(Self, AGroup);
end;

function TdxListViewViewInfo.CreateItemViewInfo(AOwner: TdxListGroupCustomViewInfo; AItemIndex: Integer): TdxListItemCustomViewInfo;
begin
  if IsReportView then
    Result := TdxListItemReportStyleViewInfo.Create(AOwner, AItemIndex, FItemViewParams)
  else
    Result := TdxListItemViewInfo.Create(AOwner, AItemIndex, FItemViewParams);
end;

procedure TdxListViewViewInfo.DoCalculate(AType: TdxChangeType);
begin
  inherited DoCalculate(AType);
  FItems.Clear;
  if AType = ctHard then
  begin
    CalculateCommonParameters;
    RecreateSubItems;
  end;
  if AType <> ctLight then
  begin
    CalculateColumnHeadersWidth;
    CalculateItemSize;
  end;
  CalculateContent(AType);
  CalculateContentBounds;
end;

procedure TdxListViewViewInfo.DoRightToLeftConversion(const ABounds: TRect);
var
  I: Integer;
begin
  inherited DoRightToLeftConversion(ABounds);
  if ColumnHeadersViewInfo <> nil then
    ColumnHeadersViewInfo.RightToLeftConversion(ABounds);
  for I := 0 to GroupCount - 1 do
    Groups[I].RightToLeftConversion(ABounds);
end;

procedure TdxListViewViewInfo.DrawContent(ACanvas: TcxCustomCanvas);
var
  I: Integer;
  AContentDrawingBounds: TRect;
begin
  Painter.DrawBackground(ACanvas, Bounds, ExplorerStyle);
  AContentDrawingBounds := Bounds;
  if ColumnHeadersViewInfo <> nil then
  begin
    ColumnHeadersViewInfo.Draw(ACanvas);
    AContentDrawingBounds.Top := ColumnHeadersViewInfo.Bounds.Bottom;
    ACanvas.IntersectClipRect(AContentDrawingBounds);
  end;
  for I := 0 to GroupCount - 1 do
    Groups[I].Draw(ACanvas);
  if FEmptyTextLayout <> nil then
    FEmptyTextLayout.Draw(AContentDrawingBounds);
end;

function TdxListViewViewInfo.FindColumn(const APosition: TPoint): TdxListColumn;
var
  AHeaderViewInfo: TdxListColumnHeaderViewInfo;
begin
  AHeaderViewInfo := FindColumnHeaderViewInfo(APosition);
  if AHeaderViewInfo <> nil then
    Result := AHeaderViewInfo.Column
  else
    Result := nil;
end;

function TdxListViewViewInfo.FindDragColumnHeaderViewInfo(const APosition: TPoint): TdxListColumnHeaderViewInfo;
begin
  if ColumnHeadersViewInfo <> nil then
    Result := ColumnHeadersViewInfo.FindDragItem(APosition)
  else
    Result := nil;
end;

function TdxListViewViewInfo.FindColumnHeaderViewInfo(const APosition: TPoint): TdxListColumnHeaderViewInfo;
begin
  if ColumnHeadersViewInfo <> nil then
    Result := ColumnHeadersViewInfo.FindItem(APosition)
  else
    Result := nil;
end;

function TdxListViewViewInfo.GetAvailableGroupsAreaHeight: Integer;
var
  AOffset: Integer;
begin
  AOffset := cxMarginsHeight(BorderWidths); 
  if not ListView.IsTouchScrollUIMode then
  begin
    if ListView.IsScrollBarActive(sbHorizontal) then
      Inc(AOffset, ListView.GetHScrollBarDefaultAreaHeight);
  end;
  Result := ListView.Height - AOffset;
end;

function TdxListViewViewInfo.GetAvailableGroupsAreaWidth: Integer;
var
  AOffset: Integer;
begin
  AOffset := cxMarginsWidth(BorderWidths); 
  if not ListView.IsTouchScrollUIMode then
  begin
    if ListView.IsScrollBarActive(sbVertical) then
      Inc(AOffset, ListView.GetVScrollBarDefaultAreaWidth);
  end;
  Result := ListView.Width - AOffset;
end;

function TdxListViewViewInfo.GetBorderWidths: TRect;
var
  ABorderSize: Integer;
begin
  Result := ContentOffset;
  ABorderSize := ListView.BorderSize;
  Inc(Result.Bottom, ABorderSize);
  Inc(Result.Left, ABorderSize);
  Inc(Result.Right, ABorderSize);
  Inc(Result.Top, ABorderSize);
end;

function TdxListViewViewInfo.GetBoundsForItem(AItem: TdxListItem): TRect;
begin
  Result := GetBoundsForItem(AItem.Index);
end;

function TdxListViewViewInfo.GetBoundsForItem(AItemIndex: Integer): TRect;
var
  AGroupViewInfo: TdxListGroupCustomViewInfo;
  AOrderIndex: Integer;
begin
  if not FindGroupViewInfo(AItemIndex, AGroupViewInfo, AOrderIndex) then
    Result.Empty
  else
    Result := AGroupViewInfo.GetBoundsForItem(AOrderIndex);
end;

function TdxListViewViewInfo.GetDesignHitTest(const P: TPoint): Boolean;
begin
  Result := (ColumnHeadersViewInfo <> nil) and ColumnHeadersViewInfo.GetDesignHitTest(P);
end;

function TdxListViewViewInfo.GetDefaultItemGlyphIndent: TSize;
begin
  Result.Init(5, 2);
end;

function TdxListViewViewInfo.GetIconsGlyphSideGap: Integer;
begin
  Result := 20;
end;

function TdxListViewViewInfo.GetItemGlyphImages: TCustomImageList;
begin
  if ListView.ViewStyle = TdxListViewStyle.Icon then
    Result := ListView.ImageOptions.LargeImages
  else
    Result := ListView.ImageOptions.SmallImages;
end;

function TdxListViewViewInfo.GetItemsOffset: TSize;
var
  APadding: TdxListViewPaddingOptions;
  AGroupPadding: TRect;
begin
  Result.Init(0, 0);
  APadding := ListView.PaddingOptions;
  if IsGroupView then
    AGroupPadding := GroupContentPadding
  else
    AGroupPadding.Empty;
  if UseRightToLeftAlignment then
  begin
    Inc(Result.cx, APadding.View.Margin.Right);
    Inc(Result.cx, AGroupPadding.Right);
  end
  else
  begin
    Inc(Result.cx, APadding.View.Margin.Left);
    Inc(Result.cx, AGroupPadding.Left);
  end;
  Inc(Result.cy, APadding.View.Margin.Top);
  Inc(Result.cy, AGroupPadding.Top);
end;

function TdxListViewViewInfo.GetItemTextLineCount: Integer;
begin
  if ListView.ViewStyle = TdxListViewStyle.Icon then
    Result := ListView.ViewStyleIcon.TextLineCount
  else
    Result := 1;
end;

function TdxListViewViewInfo.GetItemTextFlags: Integer;
begin
  Result := CXTO_PREVENT_LEFT_EXCEED or CXTO_PREVENT_TOP_EXCEED or CXTO_END_ELLIPSIS;
  if ListView.ViewStyle = TdxListViewStyle.Icon then
    Result := Result or CXTO_CENTER_HORIZONTALLY or CXTO_WORDBREAK or CXTO_CHARBREAK
  else
    Result := Result or CXTO_SINGLELINE or CXTO_LEFT or CXTO_CENTER_VERTICALLY;
  if UseRightToLeftAlignment then
    Result := Result or CXTO_RTLREADING;
end;

function TdxListViewViewInfo.GetItemTextPosition: TcxPosition;
begin
  if ListView.ViewStyle = TdxListViewStyle.Icon then
    Result := posBottom
  else
    Result := posRight;
end;

function TdxListViewViewInfo.IsPointAtColumnHeaders(const P: TPoint): Boolean;
begin
  if ColumnHeadersViewInfo = nil then
    Exit(False);
  Result := ColumnHeadersViewInfo.Bounds.Contains(P);
end;

procedure TdxListViewViewInfo.RecreateSubItems;
var
  AGroup: TdxListGroup;
  AGroups: TdxListGroups;
  AGroupViewInfo: TdxListGroupCustomViewInfo;
  I, AGroupIndex: Integer;
begin
  ValidateColumnHeadersViewInfo;
  FGroups.Clear;
  AGroups := ListView.Groups;
  if IsGroupView then
  begin
    AGroupIndex := 0;
    FGroups.Capacity := FGroups.Count;
    for I := 0 to AGroups.Count - 1 do
    begin
      AGroup := AGroups[I];
      if AGroup.IsVisible then
      begin
        AGroupViewInfo := CreateGroupViewInfo(AGroup);
        AGroupViewInfo.Index := AGroupIndex;
        Inc(AGroupIndex);
        AGroupViewInfo.PopulateItems;
        FGroups.Add(AGroupViewInfo);
      end;
    end;
  end
  else
  begin
    AGroupViewInfo := TdxListRootGroupViewInfo.Create(Self, nil);
    AGroupViewInfo.PopulateItems;
    FGroups.Add(AGroupViewInfo);
  end;
end;

procedure TdxListViewViewInfo.ValidateColumnHeadersViewInfo;
begin
  if IsReportView and ListView.ViewStyleReport.ShowColumnHeaders then
  begin
    if FColumnHeadersViewInfo = nil then
      FColumnHeadersViewInfo := TdxListViewColumnHeadersViewInfo.Create(Self);
  end
  else
    FreeAndNil(FColumnHeadersViewInfo);
end;

function TdxListViewViewInfo.CanStartMultiSelectionByMouse(const AMousePos: TPoint): Boolean;
var
  AItemViewInfo: TdxListItemCustomViewInfo;
begin
  if IsPointAtColumnHeaders(AMousePos) then
    Exit(False);
  if (ColumnHeadersViewInfo <> nil) and (ColumnHeadersViewInfo.GetResizingColumn(AMousePos) <> nil) then
    Exit(False);
  if GetItemAtPos(AMousePos, AItemViewInfo) then
    Exit(AItemViewInfo.StartMultiSelection([], AMousePos));
  Result := True;
end;

procedure TdxListViewViewInfo.MouseLeave;
begin
  if ColumnHeadersViewInfo <> nil then
    ColumnHeadersViewInfo.MouseLeave;
end;

procedure TdxListViewViewInfo.MouseMove(AShift: TShiftState; const AMousePos: TPoint);
var
  AGroupViewInfo: TdxListGroupCustomViewInfo;
begin
  if not Bounds.Contains(AMousePos) then
  begin
    Controller.RemoveContentHottrack;
    if ColumnHeadersViewInfo <> nil then
      ColumnHeadersViewInfo.MouseLeave;
    Exit;
  end;
  if ColumnHeadersViewInfo <> nil then
  begin
    if ColumnHeadersViewInfo.Bounds.Contains(AMousePos) then
    begin
      ColumnHeadersViewInfo.MouseMove([], AMousePos);
      Controller.RemoveContentHottrack(False);
      Exit;
    end
    else
      ColumnHeadersViewInfo.MouseLeave;
  end;
  if GetGroupAtPos(AMousePos, AGroupViewInfo) then
    AGroupViewInfo.MouseMove([], AMousePos)
  else
    Controller.RemoveContentHottrack;
end;

procedure TdxListViewViewInfo.AdjustGroupPositionOnNavigation(AGroup: TdxListGroup; AScrollToNext: Boolean);
var
  AGroupViewInfo: TdxListGroupCustomViewInfo;
begin
  if not IsGroupView then
    Exit;
  if FindGroupViewInfo(AGroup, AGroupViewInfo) then
    AGroupViewInfo.AdjustPositionOnNavigation(AScrollToNext);
end;

function TdxListViewViewInfo.ScrollGroupHorizontally(AGroup: TdxListGroup; AScrollToRight: Boolean): Boolean;
var
  AGroupViewInfo: TdxListGroupCustomViewInfo;
begin
  if not IsGroupView or AreGroupsVertical then
    Exit(False);
  Result := FindGroupViewInfo(AGroup, AGroupViewInfo) and AGroupViewInfo.MakeNextColumnVisible(AScrollToRight);
end;


procedure TdxListViewViewInfo.CalculateColumnBestFitParams(AColumn: TdxListColumn; var ACheckState, ACheckGlyph: Boolean; out AExtraWidth: Integer);
var
  ASubIndex, AColumnIndex: Integer;
  AImageInFirstColumn: Boolean;
begin
  AColumnIndex := AColumn.Index;
  ASubIndex := AColumn.FSubItemIndex;
  AImageInFirstColumn := ListView.ViewStyleReport.AlwaysShowItemImageInFirstColumn;
  if ASubIndex < 0 then
  begin
    ACheckGlyph := not ((AColumnIndex > 0) and AImageInFirstColumn);
    if ExplorerStyle then
      ACheckState := AColumnIndex = 0
    else
      ACheckState := not AImageInFirstColumn;
  end
  else
  begin
    if (AColumnIndex = 0) and AImageInFirstColumn then
    begin
      ACheckState := True;
      ACheckGlyph := True;
    end
    else
    begin
      ACheckState := (AColumnIndex = 0) and ExplorerStyle;
      ACheckGlyph := True;
    end;
  end;
  if AColumnIndex = 0 then
    AExtraWidth := ContentOffset.Left
  else
    AExtraWidth := 0;
end;

function TdxListViewViewInfo.CalculateColumnHeaderBestFitWidth(AColumn: TdxListColumn): Integer;
begin
  if ColumnHeadersViewInfo = nil then
    Exit(0)
  else
    Result := ColumnHeadersViewInfo.CalculateHeaderBestFitWidth(AColumn);
end;

function TdxListViewViewInfo.CalculateColumnValueWidth(AItem: TdxListItem; ASubIndex: Integer;
  ACheckState, ACheckGlyph: Boolean): Integer;
var
  AValue: string;
  AImageIndex, ANonTextWidth: Integer;
begin
  if ASubIndex < 0 then
    AValue := AItem.Caption
  else
  begin
    if ASubIndex < AItem.SubItems.Count then
    begin
      AValue := AItem.SubItems[ASubIndex];
      AImageIndex := AItem.SubItemImages[ASubIndex];
    end
    else
    begin
      AValue := '';
      AImageIndex := -1;
    end;
    if ACheckGlyph and not ACheckState then
      ACheckGlyph := AImageIndex >= 0;
  end;
  ANonTextWidth := ItemViewParams.GetReportNonTextWidth(ACheckState, ACheckGlyph);
  Result := TdxTextMeasurer.TextWidthTO(ListView.Fonts.Item, AValue) + ANonTextWidth;
end;

function TdxListViewViewInfo.CalculateColumnBestFitWidth(AColumn: TdxListColumn; AVisibleItemsOnly: Boolean = False): Integer;
var
  AItem: TdxListItem;
  ACheckState, ACheckGlyph: Boolean;
  I, AExtraWidth: Integer;
begin
  Result := CalculateColumnHeaderBestFitWidth(AColumn);
  CalculateColumnBestFitParams(AColumn, ACheckState, ACheckGlyph, AExtraWidth);
  if AVisibleItemsOnly then
  begin
    for I in Items.Keys do
    begin
      AItem := ListView.GetItem(Items[I].ItemIndex);
      Result := Max(Result, AExtraWidth + CalculateColumnValueWidth(AItem, AColumn.FSubItemIndex, ACheckState, ACheckGlyph));
    end;
  end
  else
    for I := 0 to ListView.Items.Count - 1 do
    begin
      AItem := ListView.GetItem(I);
      Result := Max(Result, AExtraWidth + CalculateColumnValueWidth(AItem, AColumn.FSubItemIndex, ACheckState, ACheckGlyph));
    end;
end;

function TdxListViewViewInfo.GetGroup(Index: Integer): TdxListGroupCustomViewInfo;
begin
  Result := TdxListGroupCustomViewInfo(FGroups.List[Index]);
end;

function TdxListViewViewInfo.GetGroupCount: Integer;
begin
  Result := FGroups.Count;
end;

{ TdxListViewController.TSelectAnchorInfo }

constructor TdxListViewController.TSelectAnchorInfo.Create(AGroupID, AItemIndex: Integer);
begin
  GroupID   := AGroupID;
  ItemIndex := AItemIndex;
end;

function TdxListViewController.TSelectAnchorInfo.IsNull: Boolean;
begin
  Result := ItemIndex < 0;
end;

procedure TdxListViewController.TSelectAnchorInfo.Reset;
begin
  GroupID   := -1;
  ItemIndex := -1;
end;

{ TdxListViewController }

constructor TdxListViewController.Create(AOwner: TdxCustomListView);
begin
  inherited Create(AOwner);
  FFocusedItemIndex := -1;
  FEditingItemIndex := -1;
  FMouseHoveredItemIndex := -1;
  FForceVisibleItemIndex := -1;
  FSelectedIndices := TdxIntegerList.Create;
end;

destructor TdxListViewController.Destroy;
begin
  FreeAndNil(FSelectedIndices);
  FinishEditingTimer;
  FinishSelectGroupItemsTimer;
  inherited Destroy;
end;

procedure TdxListViewController.FocusEnter;
begin
  ListView.Invalidate;
end;

procedure TdxListViewController.FocusLeave;
begin
  ListView.Invalidate;
end;

function TdxListViewController.CanGroupChangeCollapsedState(AGroup: TdxListGroup): Boolean;
begin
  Result := (AGroup <> nil) and (ViewInfo.AreGroupsVertical and AGroup.IsCollapsible);
end;

procedure TdxListViewController.KeyDown(AKey: Word; AShift: TShiftState);
var
  AItem: TdxListItem;
  AItemIndex: Integer;
  AWasSelected: Boolean;
begin
  case AKey of
    VK_SHIFT:
      if MultiSelect and (AShift = [ssShift]) and FSelectAnchor.IsNull then
      begin
        AItemIndex := GetStartItemIndexForKeyboardNavigation;
        if AItemIndex < 0 then
          Exit;
        AItem := ListView.GetItem(AItemIndex);
        FSelectAnchor := TSelectAnchorInfo.Create(AItem.GroupID, AItemIndex);
      end;
    VK_RIGHT:
      if CanGroupChangeCollapsedState(FocusedGroup) then
      begin
        if FocusedGroup.Collapsed then
          FocusedGroup.Collapsed := False;
      end
      else
        SelectNextItem(IfThen(ListView.UseRightToLeftAlignment, -1, 1), 0, AShift);
    VK_LEFT:
      if CanGroupChangeCollapsedState(FocusedGroup)  then
      begin
        if not FocusedGroup.Collapsed then
          FocusedGroup.Collapsed := True;
      end
      else
        SelectNextItem(IfThen(ListView.UseRightToLeftAlignment, 1, -1), 0, AShift);
    VK_SPACE:
      if FocusedItemIndex >= 0 then
      begin
        if ListView.Checkboxes and not ExplorerStyle then
        begin
          AItem := ListView.GetItem(FocusedItemIndex);
          if not ListView.SupportsItemEnabledState or AItem.Enabled then
            AItem.Checked := not AItem.Checked;
        end
        else
        begin
          if MultiSelect then
          begin
            AWasSelected := SelectedIndices.Contains(FocusedItemIndex);
            if not AWasSelected or (ssCtrl in AShift) then
              SelectItem(FocusedItemIndex, not AWasSelected);
          end
          else
          begin
            ClearSelection(FocusedItemIndex);
            SelectItem(FocusedItemIndex, True);
          end;
        end;
      end;
    VK_UP:
      SelectNextItem(0, -1, AShift);
    VK_DOWN:
      SelectNextItem(0, 1, AShift);
    VK_PRIOR:
      ShowPriorPage(AShift);
    VK_NEXT:
      ShowNextPage(AShift);
    VK_HOME:
      GotoFirstFocusableItem(AShift);
    VK_END:
      GotoLastFocusableItem(AShift);
    VK_ESCAPE:
      if (ResizingColumn <> nil) and not ListView.ExplorerStyle then
      begin
        ResizingColumn.Width := FOriginalResizingColumnWidth;
        FResizingColumn := nil;
        SetCapture(0);
      end;
    VK_F2:
      if AShift = [] then
        ListView.StartItemCaptionEditing(FocusedItemIndex);
  end;
end;

procedure TdxListViewController.KeyUp(AKey: Word; AShift: TShiftState);
begin
end;

procedure TdxListViewController.CancelMode;
begin
  FinishEditingTimer;
  ListView.FinishItemCaptionEditing;
  PressedColumn := nil;
  FResizingColumn := nil; 
end;

procedure TdxListViewController.Click;
begin
  if FSelectItemsGroup <> nil then
  begin
    if FSelectItemsGroup.NeedSelectItems then
    begin
      if not TdxKeyboard.IsControlPressed then
        StartSelectGroupItemsTimer;
    end
    else
      ClearSelection;
  end;
end;

procedure TdxListViewController.DblClick;
var
  AGroupViewInfo: TdxListGroupCustomViewInfo;
  AGroupPart: TdxListGroupHitTest;
  AGroup: TdxListGroup;
  AItemViewInfo: TdxListItemCustomViewInfo;
  AMousePos: TPoint;
begin
  FinishSelectGroupItemsTimer;
  AMousePos := ListView.GetMouseCursorClientPos;
  if ViewInfo.GetGroupAtPos(AMousePos, AGroupViewInfo) then
  begin
    AGroup := AGroupViewInfo.Group;
    if CanGroupChangeCollapsedState(AGroup) then
    begin
      AGroupPart := AGroupViewInfo.GetHitTest(AMousePos, AItemViewInfo);
      if (AGroupPart = TdxListGroupHitTest.Header) and AGroup.IsFocusable then
        AGroup.Collapsed := not AGroup.Collapsed;
    end;
  end;
end;

function TdxListViewController.GetCursor(const AMousePos: TPoint): TCursor;
begin
  if (ViewInfo.ColumnHeadersViewInfo <> nil) and ViewInfo.ColumnHeadersViewInfo.GetHitTestBounds.Contains(AMousePos) then
    Result := ViewInfo.ColumnHeadersViewInfo.GetCursor(AMousePos)
  else
    Result := crDefault;
end;

procedure TdxListViewController.MouseDown(AButton: TMouseButton; AShift: TShiftState; const AMousePos: TPoint);
var
  AGroupViewInfo: TdxListGroupCustomViewInfo;
begin
  ListView.HintHelper.MouseDown;
  if ProcessColumnHeadersMouseDown(AButton, AShift, AMousePos) then
    Exit;
  FResizingColumn := nil;
  FSelectItemsGroup := nil;
  if ViewInfo.GetGroupAtPos(AMousePos, AGroupViewInfo) then
    AGroupViewInfo.MouseDown(AButton, AShift, AMousePos)
  else
  begin
    if not (ssCtrl in AShift) then
      ClearSelection;
    FocusedGroup := nil;
  end;
end;

procedure TdxListViewController.MouseLeave;
begin
  MouseHoveredItemIndex := -1;
  MouseHoveredGroup := nil;
  ViewInfo.MouseLeave;
end;

procedure TdxListViewController.MouseMove(AShift: TShiftState; const AMousePos: TPoint);
begin
  if (ssLeft in AShift) and (FResizingColumn <> nil) then
  begin
    ProcessColumnResize(AMousePos);
    Exit;
  end;
  if not ListView.Dragging {IsInDragAndDropOperation} then
    ViewInfo.MouseMove([], AMousePos);
end;

procedure TdxListViewController.MouseUp(AButton: TMouseButton; AShift: TShiftState; const AMousePos: TPoint);
var
  AViewInfo: TdxListItemCustomViewInfo;
begin
  if PressedColumn <> nil then
    ProcessColumnHeadersMouseUp(AButton, AShift, AMousePos);
  if AButton = mbLeft then
  begin
    if FResizingColumn <> nil then
    begin
      SetDesignerModified(FResizingColumn);
      FResizingColumn := nil;
    end;
    if (AShift = []) and ViewInfo.GetItemAtPos(AMousePos, AViewInfo) then
    begin
      if FUpdateItemsSelectionOnMouseUp and (AViewInfo.ItemIndex = FPressedItemIndex) and
        (ListView.DragAndDropState = ddsNone) then
      begin
        FUpdateItemsSelectionOnMouseUp := False;
        SelectSingleItem(FPressedItemIndex);
        Exit;
      end;
      if (FEditingItemIndex >= 0) and (FEditingItemIndex = AViewInfo.ItemIndex) then
      begin
        if AViewInfo.StartEdit(AShift, AMousePos) then
          ListView.InplaceEditingController.StartEditingTimer;
      end;
    end;
  end;
end;

procedure TdxListViewController.DragEnter;
begin
  MouseHoveredItemIndex := -1;
  MousePressed := False;
end;

procedure TdxListViewController.DragLeave;
begin
  UpdateMouseHottrack;
end;

procedure TdxListViewController.DragDrop(Source: TObject; X, Y: Integer);
begin
end;

procedure TdxListViewController.DragOver(ASource: TObject; const AMousePos: TPoint; var AAccept: Boolean);
var
  ADragObject: TdxListViewDragObject;
begin
  ADragObject := Safe<TdxListViewDragObject>.Cast(ASource);
  if (ADragObject <> nil) and (ADragObject.AutoScrollHelper <> nil) then
    ADragObject.AutoScrollHelper.CheckMousePosition(AMousePos);
end;

function TdxListViewController.CheckStartEditingOnMouseUp(AItemViewInfo: TdxListItemCustomViewInfo;
  AButton: TMouseButton; AShift: TShiftState; const AMousePos: TPoint): Boolean;
begin
  if FEditWasClosed or ListView.ReadOnly then
    Exit(False);
  Result := (FocusedItemIndex = AItemViewInfo.ItemIndex) and
    (AShift = [ssLeft]) and
    (SelectedIndices.Count = 1) and AItemViewInfo.StartEdit(AShift, AMousePos);
end;

procedure TdxListViewController.CheckVisibleItem;
begin
  if FForceVisibleItemIndex >= 0 then
  begin
    MakeItemVisible(FForceVisibleItemIndex, TdxVisibilityType.vtFully);
    FForceVisibleItemIndex := -1;
  end;
end;

procedure TdxListViewController.InvalidateItem(AItem: TdxListItem);
begin
  if AItem <> nil then
    UpdateItemViewState(AItem.Index);
end;

function TdxListViewController.IsGroupView: Boolean;
begin
  Result := ListView.GroupView;
end;

procedure TdxListViewController.MakeItemVisible(AItem: TdxListItem; AVisibleType: TdxVisibilityType);
begin
  if AItem <> nil then
    MakeItemVisible(AItem.Index, AVisibleType, True, True);
end;

procedure TdxListViewController.MakeItemVisible(AItemIndex: Integer; AVisibleType: TdxVisibilityType);
begin
  MakeItemVisible(AItemIndex, AVisibleType, True, True);
end;

procedure TdxListViewController.RemoveContentHottrack(ACancelHint: Boolean = True);
begin
  MouseHoveredItemIndex := -1;
  MouseHoveredGroup := nil;
  if ACancelHint then
    ViewInfo.CancelHint;
end;

procedure TdxListViewController.ResetContent;
begin
  ResetSelection;
  FFocusedItemIndex := -1;
  FFocusedGroup := nil;
end;

procedure TdxListViewController.SetFocusedItemIndexCore(AItemIndex: Integer; AVisibleType: TdxVisibilityType;
  ACheckHorizontalPosition, ACheckVerticalPosition: Boolean);
begin
  if FFocusedItemIndex <> AItemIndex then
  begin
    FinishEditingTimer;
    ListView.FinishItemCaptionEditing(True);
    ExchangeIntegers(FFocusedItemIndex, AItemIndex);
    UpdateItemViewState(AItemIndex);
    UpdateItemViewState(FocusedItemIndex);
    if FocusedItemIndex >= 0 then
      FocusedGroup := nil;
    MakeItemVisible(FocusedItemIndex, vtFully, ACheckHorizontalPosition, ACheckVerticalPosition);
    if not TdxKeyboard.IsShiftPressed then
      FSelectAnchor.Reset;
  end;
end;

procedure TdxListViewController.AfterKeyDown(AKey: Word; AShift: TShiftState);
begin
  EndSelectionChanged;
end;

procedure TdxListViewController.AfterMouseDown(AButton: TMouseButton; AShift: TShiftState; const AMousePos: TPoint);
begin
  EndSelectionChanged;
  if AButton = mbLeft then
    FEditWasClosed := False;
end;

procedure TdxListViewController.BeforeKeyDown(AKey: Word; AShift: TShiftState);
begin
  BeginSelectionChanged;
end;

procedure TdxListViewController.BeforeMouseDown(AButton: TMouseButton; AShift: TShiftState; const AMousePos: TPoint);
begin
  BeginSelectionChanged;
  FDragItemIndex := -1;
  FEditingItemIndex := -1;
  FPressedItemIndex := -1;
  FIsPressedItemSelected := False;
  FUpdateItemsSelectionOnMouseUp := False;
end;

function TdxListViewController.GetDesignHitTest(const P: TPoint): Boolean;
begin
  Result := ViewInfo.GetDesignHitTest(P);
end;

function TdxListViewController.ProcessColumnHeadersMouseDown(AButton: TMouseButton;
  AShift: TShiftState; const AMousePos: TPoint): Boolean;
begin
  Result := False;
  FCheckSelectAllOnMouseUp := False;
  if ListView.IsDesigning and not CanSelectColumnInDesigner then
    Exit;
  if (AButton <> mbMiddle) and (ViewInfo.ColumnHeadersViewInfo <> nil) then
  begin
    if AButton = mbLeft then
    begin
      FResizingColumn := ViewInfo.ColumnHeadersViewInfo.GetResizingColumn(AMousePos);
      if FResizingColumn <> nil then
      begin
        if ssDouble in AShift then
        begin
          FResizingColumn.ApplyBestFit(ListView.UseDisplayedItemsForBestFit);
          FResizingColumn := nil;
        end
        else
        begin
          FColumnResizeMouseDownPos := ListView.MouseDownPos;
          FOriginalResizingColumnWidth := FResizingColumn.Width;
          ListView.FinishItemCaptionEditing(True);
        end;
        Exit(True);
      end;
    end;
    ViewInfo.ColumnHeadersViewInfo.MouseDown(AButton, AShift, AMousePos);
    if PressedColumn <> nil then
    begin
      if cxDesignHelper <> nil then
        cxDesignHelper.SelectObject(ListView, PressedColumn, not TdxKeyboard.IsShiftPressed);
      Exit(True);
    end;
  end;
end;

procedure TdxListViewController.ProcessColumnHeadersMouseUp(AButton: TMouseButton;
  AShift: TShiftState; const AMousePos: TPoint);
var
  AHeaderViewInfo: TdxListColumnHeaderViewInfo;
begin
  AHeaderViewInfo := ViewInfo.FindColumnHeaderViewInfo(AMousePos);
  try
    if AHeaderViewInfo = nil then
      Exit;
    if AHeaderViewInfo.Column = PressedColumn then
    begin
      case AButton of
        mbLeft:
          begin
            if CheckSelectAllOnMouseUp then
            begin
              CheckSelectAllOnMouseUp := False;
              if AHeaderViewInfo.GetHitTest(AMousePos) = TdxListColumnHeaderHitTest.CheckBox then
              begin
                BeginSelectionChanged;
                try
                  if AreAllItemsSelected then
                    ClearSelection
                  else
                    SelectAll;
                finally
                  EndSelectionChanged;
                end;
              end;
            end
            else
              ListView.DoColumnClick(PressedColumn);
          end;
        mbRight:
          ListView.DoColumnRightClick(PressedColumn, AMousePos);
      end;
    end;
  finally
    PressedColumn := nil;
  end;
end;

procedure TdxListViewController.ProcessColumnResize(const AMousePos: TPoint);
var
  ANewWidth, ASaveColumnWidth, ADelta, AColumnWidth, AContentWidth, AMouseContentWidth, I: Integer;
begin
  ASaveColumnWidth := FResizingColumn.Width;
  ADelta := AMousePos.X - FColumnResizeMouseDownPos.X;
  if ListView.UseRightToLeftAlignment then
    ANewWidth := FOriginalResizingColumnWidth - ADelta
  else
    ANewWidth := FOriginalResizingColumnWidth + ADelta;

  if (ANewWidth < FOriginalResizingColumnWidth) and (ListView.LeftPos > 0) then 
  begin
    AContentWidth := ViewInfo.ContentOffset.Left;
    for I := 0 to ListView.Columns.Count - 1 do
    begin
      AColumnWidth := ListView.Columns[I].Width;
      if ListView.Columns[I] <> FResizingColumn then
        Inc(AContentWidth, AColumnWidth)
      else
      begin
        if ListView.UseRightToLeftAlignment then
          AMouseContentWidth := ListView.ClientWidth - AMousePos.X + ListView.LeftPos
        else
          AMouseContentWidth := AMousePos.X + ListView.LeftPos;
        if AMouseContentWidth < AContentWidth + AColumnWidth then
        begin
          ANewWidth := AMouseContentWidth - AContentWidth;
          FResizingColumn.Width := ANewWidth;
          ANewWidth := FResizingColumn.Width;
          if ListView.UseRightToLeftAlignment then
            FColumnResizeMouseDownPos.X := ListView.ClientWidth - AContentWidth - ANewWidth + ListView.LeftPos
          else
            FColumnResizeMouseDownPos.X := AContentWidth + ANewWidth - ListView.LeftPos;
          FOriginalResizingColumnWidth := ANewWidth;
        end;
        Break;
      end;
    end;
  end;
  FResizingColumn.Width := ANewWidth;
  if FResizingColumn.Width <> ASaveColumnWidth then
  begin
    ListView.DoColumnSizeChanged(FResizingColumn);
    ListView.Update;
  end;
end;

procedure TdxListViewController.ProcessItemMouseDown(AItemViewInfo: TdxListItemCustomViewInfo;
  AButton: TMouseButton; AShift: TShiftState; const AMousePos: TPoint);
var
  AHitAtCheckBox, ASelectItems: Boolean;
  AItem: TdxListItem;
  AItemIndex: Integer;
  ASelectAnchor: TSelectAnchorInfo;
  AListViewChangingAllowed: Boolean;
  ADoChangingProcessed: Boolean;
begin
  AItemIndex := AItemViewInfo.ItemIndex;
  AItem := ListView.GetItem(AItemIndex);
  if not AItem.IsEnabled then
    Exit;
  FPressedItemIndex := AItemIndex;
  FIsPressedItemSelected := SelectedIndices.Contains(FPressedItemIndex);
  if CheckStartEditingOnMouseUp(AItemViewInfo, AButton, AShift, AMousePos) then
  begin
    FEditingItemIndex := AItemIndex;
    Exit;
  end;
  AHitAtCheckBox := ListView.Checkboxes and
    (AItemViewInfo.GetHitTest(AMousePos) = TdxListItemHitTest.StateGlyph);

  ADoChangingProcessed := False;
  AListViewChangingAllowed := True;
  if ExplorerStyle or not AHitAtCheckBox then
  begin
    ADoChangingProcessed := True;
    AListViewChangingAllowed := ListView.DoChanging(AItem, TdxListItemChange.State);
    if AListViewChangingAllowed then
      SetFocusedItemIndexCore(AItemIndex, vtFully, not ViewInfo.IsReportView, True);
  end;
  if AListViewChangingAllowed then
  begin
    if MultiSelect then
    begin
      ASelectAnchor := TSelectAnchorInfo.Create(AItem.GroupID, AItemIndex);
      if ssLeft in AShift then
      begin
        if ssShift in AShift then
        begin
          if ssCtrl in AShift then
          begin
            ASelectItems := FSelectAnchor.IsNull or IsItemSelected(FSelectAnchor.ItemIndex);
            if ASelectItems then
              SelectItems(ASelectAnchor, False)
            else
              DeselectItems(ASelectAnchor);
          end
          else
            SelectItems(ASelectAnchor)
        end
        else if ssCtrl in AShift then
        begin
          SelectItem(AItemIndex, not AItem.Selected, not ADoChangingProcessed);
          FSelectAnchor := ASelectAnchor;
        end
        else
        begin
          if AHitAtCheckBox then
          begin
            if ExplorerStyle then
              SelectItem(AItemIndex, not AItem.Selected, not ADoChangingProcessed)
            else
              AItem.Checked := not AItem.Checked;
          end
          else
          begin
            if FIsPressedItemSelected then
              FUpdateItemsSelectionOnMouseUp := True
            else
              SelectSingleItem(AItemIndex, not ADoChangingProcessed);
          end;
          FSelectAnchor := ASelectAnchor;
        end;
      end
      else
        if (ssRight in AShift) and not (ssCtrl in AShift) and not FIsPressedItemSelected then
        begin
          if AItemViewInfo.GetHitTest(AMousePos) <> TdxListItemHitTest.StateGlyph then
          begin
            SelectSingleItem(AItemIndex);
            FSelectAnchor := ASelectAnchor;
          end;
        end;
    end
    else
    begin
      if AHitAtCheckBox then
      begin
        if ExplorerStyle then
          SelectSingleItem(AItemIndex, not ADoChangingProcessed)
        else
          AItem.Checked := not AItem.Checked;
      end
      else
        if NeedToRestoreSingleItemSelection(AShift) then
          SelectSingleItem(AItemIndex, not ADoChangingProcessed);
    end;
  end;
end;

procedure TdxListViewController.MakeItemVisible(AItemIndex: Integer; AVisibleType: TdxVisibilityType;
  ACheckHorizontalPosition, ACheckVerticalPosition: Boolean);
var
  ABounds, AScrollAreaBounds: TRect;
begin
  if AItemIndex >= 0 then
  begin
    if ViewInfo.IsDirty then
    begin
      FForceVisibleItemIndex := AItemIndex;
      Exit;
    end;
    FForceVisibleItemIndex := -1;
    ABounds := ViewInfo.GetItemBoundsForMakeVisible(AItemIndex);
    AScrollAreaBounds := ViewInfo.GetScrollArea;
    ListView.MakeVisible(ABounds, AScrollAreaBounds, AVisibleType, ACheckHorizontalPosition, ACheckVerticalPosition);
  end;
end;

procedure TdxListViewController.UpdateColumnHeadersViewState;
begin
  if ViewInfo.ColumnHeadersViewInfo <> nil then
    ViewInfo.ColumnHeadersViewInfo.Invalidate;
end;

procedure TdxListViewController.UpdateGroupViewState(AGroup: TdxListGroup; AMakeHeaderVisible: Boolean = False);
var
  AViewInfo: TdxListGroupCustomViewInfo;
  ABounds: TRect;
begin
  if AGroup = nil then
    Exit;
  if ViewInfo.FindGroupViewInfo(AGroup, AViewInfo) then
  begin
    if AMakeHeaderVisible and AViewInfo.HasHeader then
    begin
      ABounds := TdxListGroupViewInfo(AViewInfo).Header.Bounds;
      if AViewInfo.Group.Index = 0 then
        Dec(ABounds.Top, ViewInfo.ContentOffset.Top);
      if ViewInfo.AreGroupsVertical then
        ListView.MakeVisible(ABounds, ViewInfo.GetScrollArea, vtFully, False, True);
    end;
    AViewInfo.Invalidate;
  end;
end;

procedure TdxListViewController.UpdateItemViewState(AItemIndex: Integer);
var
  AViewInfo: TdxListItemCustomViewInfo;
begin
  if ViewInfo.FindItemViewInfo(AItemIndex, AViewInfo) then
    AViewInfo.Invalidate;
end;

procedure TdxListViewController.UpdateMouseHottrack;
begin
  UpdateMouseHottrack(ListView.GetMouseCursorClientPos)
end;

procedure TdxListViewController.UpdateMouseHottrack(const AMousePos: TPoint);
begin
  MouseMove([], AMousePos);
end;

procedure TdxListViewController.DeleteItem(AIndex: Integer);
var
  I, ASelectedIndex: Integer;
begin
  if ListView.OwnerData then
    Exit;
  if FocusedItemIndex = AIndex then
    FFocusedItemIndex := -1;
  for I := 0 to FSelectedIndices.Count - 1 do 
  begin
    ASelectedIndex := FSelectedIndices[I];
    if ASelectedIndex > AIndex then
      FSelectedIndices[I] := ASelectedIndex - 1;
  end;
end;

procedure TdxListViewController.InsertItem(AIndex: Integer);
var
  I, ASelectedIndex: Integer;
begin
  if ListView.OwnerData then
    Exit;
  if AIndex <= FocusedItemIndex then
    FFocusedItemIndex := FocusedItemIndex + 1;
  for I := 0 to FSelectedIndices.Count - 1 do 
  begin
    ASelectedIndex := FSelectedIndices[I];
    if ASelectedIndex >= AIndex then
      FSelectedIndices[I] := ASelectedIndex + 1;
  end;
end;

procedure TdxListViewController.AddSelection(ASelection: TdxIntegerList);
var
  I: Integer;
begin
  if not MultiSelect and (ASelection.Count > 1) then
    Exit;
  ListView.BeginUpdate;
  try
    for I := 0 to ASelection.Count - 1 do
      SelectItem(ASelection[I], True);
  finally
    ListView.EndUpdate;
  end;
end;

function TdxListViewController.AreAllItemsSelected: Boolean;
var
  AItemCount: Integer;
begin
  AItemCount := ListView.Items.Count;
  Result := (AItemCount > 0) and (SelectedIndices.Count = AItemCount);
end;

procedure TdxListViewController.ClearSelection(AItemIndexToExclude: Integer = -1);
var
  I, AItemIndex: Integer;
begin
  for I := SelectedIndices.Count - 1 downto 0 do
  begin
    AItemIndex := SelectedIndices[I];
    if AItemIndex <> AItemIndexToExclude then
      SelectItem(AItemIndex, False);
  end;
end;

function TdxListViewController.GetFirstFocusableItemInGroup(AGroup: TdxListGroup): Integer;
var
  I, AItemIndex: Integer;
  AItem: TdxListItem;
begin
  Result := -1;
  if not CanNavigateGroupItems(AGroup) then
    Exit;
  if not ListView.SupportsItemEnabledState then 
  begin
    if AGroup.ItemIndices.Count > 0 then
      Result := 0;
    Exit;
  end;
  for I := 0 to AGroup.ItemIndices.Count - 1 do
  begin
    AItemIndex := AGroup.ItemIndices[I];
    AItem := ListView.GetItem(AItemIndex);
    if AItem.Enabled then
      Exit(AItemIndex);
  end;
end;

function TdxListViewController.GetLastFocusableItemInGroup(AGroup: TdxListGroup): Integer;
var
  I, AItemIndex: Integer;
  AItem: TdxListItem;
begin
  Result := -1;
  if not CanNavigateGroupItems(AGroup) then
    Exit;
  if not ListView.SupportsItemEnabledState then 
  begin
    Result := AGroup.ItemIndices.Count - 1;
    Exit;
  end;
  for I := AGroup.ItemIndices.Count - 1 downto 0 do
  begin
    AItemIndex := AGroup.ItemIndices[I];
    AItem := ListView.GetItem(AItemIndex);
    if AItem.Enabled then
      Exit(AItemIndex);
  end;
end;

function TdxListViewController.GetItems(const ANewAnchor: TSelectAnchorInfo): TdxIntegerList;
var
  I, AFirstItemIndex, ALastItemIndex: Integer;
  AGroup: TdxListGroup;
begin
  Result := TdxIntegerList.Create;
  Result.Capacity := 1024;
  if IsGroupView then
  begin
    if FSelectAnchor.IsNull then
    begin
      AGroup := ListView.Groups.GetFirstVisibleGroup;
      if AGroup = nil then
        Exit;
      FSelectAnchor.GroupID := AGroup.GroupID;
      FSelectAnchor.ItemIndex := AGroup.ItemIndices[0];
    end;
    GetItems(FSelectAnchor, ANewAnchor, Result);
  end
  else
  begin
    if FSelectAnchor.IsNull then
      AFirstItemIndex := 0
    else
      AFirstItemIndex := FSelectAnchor.ItemIndex;
    ALastItemIndex := ANewAnchor.ItemIndex;
    for I := Min(AFirstItemIndex, ALastItemIndex) to Max(AFirstItemIndex, ALastItemIndex) do
      Result.Add(I);
  end;
end;

procedure TdxListViewController.GetItems(const AAnchor1, AAnchor2: TSelectAnchorInfo;
  AItems: TdxIntegerList);
var
  AGroup1, AGroup2: TdxListGroup;
  I, AGroupIndex1, AGroupIndex2, AGroupItemIndex1, AGroupItemIndex2: Integer;
  ADown: Boolean;
begin
  AGroup1 := ListView.Groups.FindByGroupID(AAnchor1.GroupID);
  AGroup2 := ListView.Groups.FindByGroupID(AAnchor2.GroupID);
  if AGroup1 = AGroup2 then
  begin
    AGroupItemIndex1 := AGroup1.ItemIndices.IndexOf(AAnchor1.ItemIndex);
    AGroupItemIndex2 := AGroup1.ItemIndices.IndexOf(AAnchor2.ItemIndex);
    for I := Min(AGroupItemIndex1, AGroupItemIndex2) to Max(AGroupItemIndex1, AGroupItemIndex2) do
      AItems.Add(AGroup1.ItemIndices[I]);
  end
  else
  begin
    AGroupIndex1 := AGroup1.Index;
    AGroupIndex2 := AGroup2.Index;
    ADown := AGroupIndex1 <= AGroupIndex2;
    GetItems(AGroup1, AAnchor1.ItemIndex, ADown, AItems);
    GetItems(AGroup2, AAnchor2.ItemIndex, not ADown, AItems);
    for I := Min(AGroupIndex1, AGroupIndex2) + 1 to Max(AGroupIndex1, AGroupIndex2) - 1 do
      if ListView.Groups[I].IsVisible then
        AItems.AddRange(ListView.Groups[I].ItemIndices);
  end;
end;

procedure TdxListViewController.GetItems(AGroup: TdxListGroup; AItemIndex: Integer; ADown: Boolean;
  AItems: TdxIntegerList);
var
  I, AGroupItemIndex1, AGroupItemIndex2: Integer;
begin
  AGroupItemIndex1 := AGroup.ItemIndices.IndexOf(AItemIndex);
  if ADown then
    AGroupItemIndex2 := AGroup.ItemIndices.Count - 1
  else
    AGroupItemIndex2 := 0;
  for I := Min(AGroupItemIndex1, AGroupItemIndex2) to Max(AGroupItemIndex1, AGroupItemIndex2) do
    AItems.Add(AGroup.ItemIndices[I]);
end;

function TdxListViewController.IsItemSelected(AItemIndex: Integer): Boolean;
begin
  Result := SelectedIndices.IndexOf(AItemIndex) >= 0;
end;

function TdxListViewController.MultiSelect: Boolean;
begin
  Result := ListView.MultiSelect;
end;

function TdxListViewController.NeedToRestoreSingleItemSelection(AShift: TShiftState): Boolean;
begin
  Result := (ssLeft in AShift) or (ssRight in AShift);
end;

procedure TdxListViewController.SelectItem(AItemIndex: Integer; ASelect: Boolean; AProcessOnChangingEvent: Boolean = True);
var
  AWasSelected: Boolean;
  ASelectionIndex: Integer;
  AItem: TdxListItem;
  ADoChange: Boolean;
begin
  AItem := ListView.GetItem(AItemIndex);
  ASelect := ASelect and AItem.IsEnabled;
  ASelectionIndex := SelectedIndices.IndexOf(AItemIndex);
  AWasSelected := ASelectionIndex >= 0;
  ADoChange := False;
  if AWasSelected <> ASelect then
  begin
    if ASelect then
    begin
      if (not AProcessOnChangingEvent) or ListView.DoChanging(AItem, TdxListItemChange.State) then
      begin
        FSelectionChangedFlag := True;
        ADoChange := True;
        SelectedIndices.Add(AItemIndex);
      end;
    end
    else
    begin
      if (not ListView.MultiSelect) or (not AProcessOnChangingEvent) or ListView.DoChanging(AItem, TdxListItemChange.State) then
      begin
        FSelectionChangedFlag := True;
        ADoChange := True;
        SelectedIndices.Delete(ASelectionIndex);
      end;
    end;
    if FSelectionChangedFlag then
    begin
      if ADoChange then
        ListView.DoChange(AItem, TdxListItemChange.State);
      ListView.DoSelectItem(AItemIndex, ASelect);
      UpdateItemViewState(AItemIndex);
      UpdateColumnHeadersViewState;
    end;
  end;
end;

procedure TdxListViewController.SelectItems(AStartIndex, AFinishIndex: Integer);
var
  I: Integer;
begin
  if (AStartIndex < 0) or (AFinishIndex < 0) then
    Exit;
  ListView.BeginUpdate;
  try
   for I := Min(AStartIndex, AFinishIndex) to Max(AStartIndex, AFinishIndex) do
     SelectItem(I, True);
  finally
    ListView.EndUpdate;
  end;
end;

procedure TdxListViewController.ReplaceSelection(ASelection: TdxIntegerList);
var
  I, AItemIndex, ANewPosition: Integer;
  ACurrentSelection: TdxIntegerList;
begin
  if not MultiSelect and (ASelection.Count > 1) then
    Exit;
  ListView.BeginUpdate;
  try
    ACurrentSelection := TdxIntegerList.Create(ASelection);
    try
      for I := SelectedIndices.Count - 1 downto 0 do
      begin
        AItemIndex := SelectedIndices[I];
        ANewPosition := ACurrentSelection.IndexOf(AItemIndex);
        if ANewPosition < 0 then
          SelectItem(AItemIndex, False)
        else
          ACurrentSelection.Delete(ANewPosition);
      end;
      for I := 0 to ACurrentSelection.Count - 1 do
        SelectItem(ACurrentSelection[I], True);
    finally
      ACurrentSelection.Free;
    end;
  finally
    ListView.EndUpdate;
  end;
end;

procedure TdxListViewController.ResetSelection;
begin
  SelectedIndices.Clear;
end;

procedure TdxListViewController.SelectItems(const ANewAnchor: TSelectAnchorInfo; AReplaceSelection: Boolean = True);
var
  ASelection: TdxIntegerList;
begin
  ASelection := GetItems(ANewAnchor);
  try
    if AReplaceSelection then
      ReplaceSelection(ASelection)
    else
      AddSelection(ASelection);
  finally
    ASelection.Free;
  end;
end;

procedure TdxListViewController.DeselectItems(const ANewAnchor: TSelectAnchorInfo);
var
  ASelection: TdxIntegerList;
  I: Integer;
begin
  if not MultiSelect then
    Exit;
  ASelection := GetItems(ANewAnchor);
  try
    if ASelection.Count = 0 then
      Exit;
    ListView.BeginUpdate;
    try
      for I := 0 to ASelection.Count - 1 do
        SelectItem(ASelection[I], False);
    finally
      ListView.EndUpdate;
    end;
  finally
    ASelection.Free;
  end;
end;

procedure TdxListViewController.SelectAll;
begin
  BeginSelectionChanged;
  try
    SelectItems(0, ListView.Items.Count - 1);
  finally
    EndSelectionChanged;
  end;
end;

procedure TdxListViewController.SelectGroupItems(AGroup: TdxListGroup; AReplaceSelection: Boolean);
begin
  BeginSelectionChanged;
  try
    if MultiSelect then
    begin
      if AReplaceSelection then
        ReplaceSelection(AGroup.ItemIndices)
      else
        AddSelection(AGroup.ItemIndices);
    end
    else
      SelectFirstAvailableItemInGroup(AGroup);
  finally
    EndSelectionChanged;
  end;
end;

procedure TdxListViewController.SelectFirstAvailableItemInGroup(AGroup: TdxListGroup);
var
  AItemIndex: Integer;
begin
  AItemIndex := GetFirstFocusableItemInGroup(AGroup);
  if AItemIndex >= 0 then
  begin
    ClearSelection(AItemIndex);
    SelectItem(AItemIndex, True);
  end;
end;

procedure TdxListViewController.SelectSingleItem(AItemIndex: Integer; AProcessOnChangingEvent: Boolean = True);
begin
  BeginSelectionChanged;
  try
    ClearSelection(AItemIndex);
    SelectItem(AItemIndex, True, AProcessOnChangingEvent);
  finally
    EndSelectionChanged;
  end;
end;

procedure TdxListViewController.BeginSelectionChanged;
begin
  if FSelectionChangedCount = 0 then
    FSelectionChangedFlag := False;
  Inc(FSelectionChangedCount);
end;

procedure TdxListViewController.EndSelectionChanged;
begin
  Dec(FSelectionChangedCount);
  if FSelectionChangedCount = 0 then
  begin
    if FSelectionChangedFlag then
    begin
      FSelectionChangedFlag := False;
      ListView.DoSelectionChanged;
    end;
  end;
end;

function TdxListViewController.CanNavigateGroupItems(AGroup: TdxListGroup): Boolean;
begin
  Result := (AGroup <> nil) and AGroup.IsVisible and not (ViewInfo.AreGroupsVertical and AGroup.Collapsed);
end;

function TdxListViewController.GetGroupViewInfo(AItemIndex: Integer): TdxListGroupCustomViewInfo;
var
  I: Integer;
  AItemViewInfo: TdxListItemCustomViewInfo;
begin
  if ViewInfo.FindItemViewInfo(AItemIndex, AItemViewInfo) then
    Result := AItemViewInfo.Owner
  else
  begin
    if IsGroupView then
    begin
      Result := nil;
      for I := 0 to ViewInfo.GroupCount - 1 do
        if ViewInfo.Groups[I].Group.ItemIndices.Contains(AItemIndex) then
        begin
          Result := ViewInfo.Groups[I];
          Break;
        end;
    end
    else
      Result := ViewInfo.Groups[0];
  end;
  Assert(Result <> nil, 'Can''t find group ViewInfo');
end;

procedure TdxListViewController.GotoItemIndex(AItemIndex: Integer; AShift: TShiftState; AProcessOnChangingEvent: Boolean = True);
var
  AItem: TdxListItem;
  ASelectionEnd: TSelectAnchorInfo;
begin
  if (AItemIndex < 0) or (FocusedItemIndex = AItemIndex) then
    Exit;
  SetFocusedItemIndexCore(AItemIndex, vtFully, not ViewInfo.IsReportView, True);
  if AShift <> [ssCtrl] then // explorer-style for a single-selection mode
  begin
    AItem := ListView.GetItem(AItemIndex);
    if MultiSelect and (ssShift in AShift) then
    begin
      ASelectionEnd := TSelectAnchorInfo.Create(AItem.GroupID, AItemIndex);
      SelectItems(ASelectionEnd, not (ssCtrl in AShift));
    end
    else
    begin
      ClearSelection(AItemIndex);
      SelectItem(FocusedItemIndex, True, AProcessOnChangingEvent);
      FSelectAnchor := TSelectAnchorInfo.Create(AItem.GroupID, AItemIndex);
    end;
  end;
end;

procedure TdxListViewController.GotoFirstFocusableItem(AShift: TShiftState);
var
  I, AItemIndex: Integer;
  AGroup: TdxListGroup;
  AItem: TdxListItem;
begin
  AItemIndex := -1;
  if IsGroupView then
  begin
    for I := 0 to ListView.Groups.Count - 1 do
    begin
      AGroup := ListView.Groups[I];
      AItemIndex := GetFirstFocusableItemInGroup(AGroup);
      if AItemIndex >= 0 then
        Break;
    end
  end
  else
  begin
    if ListView.SupportsItemEnabledState then
    begin
      for I := 0 to ListView.Items.Count - 1 do
      begin
        AItem := ListView.Items[I];
        if AItem.Enabled then
        begin
          AItemIndex := I;
          Break;
        end;
      end;
    end
    else
      if ListView.Items.Count > 0 then
        AItemIndex := 0;
  end;
  GotoItemIndex(AItemIndex, AShift);
end;

procedure TdxListViewController.GotoLastFocusableItem(AShift: TShiftState);
var
  I, AItemIndex: Integer;
  AGroup: TdxListGroup;
  AItem: TdxListItem;
begin
  AItemIndex := -1;
  if IsGroupView then
  begin
    for I := ListView.Groups.Count - 1 downto 0 do
    begin
      AGroup := ListView.Groups[I];
      AItemIndex := GetLastFocusableItemInGroup(AGroup);
      if AItemIndex >= 0 then
        Break;
    end
  end
  else
  begin
    if ListView.SupportsItemEnabledState then
    begin
      for I := ListView.Items.Count - 1 downto 0 do
      begin
        AItem := ListView.Items[I];
        if AItem.Enabled then
        begin
          AItemIndex := I;
          Break;
        end;
      end;
    end
    else
      AItemIndex := ListView.Items.Count - 1;
  end;
  GotoItemIndex(AItemIndex, AShift);
end;

function TdxListViewController.GetStartItemIndexForKeyboardNavigation: Integer;
var
  I: Integer;
  AGroup: TdxListGroup;
  AItem: TdxListItem;
begin
  Result := FocusedItemIndex;
  if Result < 0 then
  begin
    if IsGroupView then
    begin
      for I := 0 to ListView.Groups.Count - 1 do
      begin
        AGroup := ListView.Groups[I];
        if (FocusedGroup = nil) or (FocusedGroup = AGroup) then
        begin
          Result := GetFirstFocusableItemInGroup(AGroup);
          if Result >= 0 then
            Break;
        end;
      end;
    end
    else
    begin
      if ListView.SupportsItemEnabledState then
      begin
        for I := 0 to ListView.Items.Count - 1 do
        begin
          AItem := ListView.GetItem(I);
          if AItem.IsEnabled then
            Exit(I);
        end;
      end
      else
        if ListView.Items.Count > 0 then
          Result := 0;
    end;
  end;
end;

procedure TdxListViewController.SelectNextItem(ADirectionX, ADirectionY: Integer; AShift: TShiftState);

  function IsHorizontalGroupNavigation: Boolean;
  begin
    Result := (ADirectionX <> 0) and not ViewInfo.AreGroupsVertical;
  end;

  function IsHorizontalGroupOnlyNavigation: Boolean;
  begin
    Result := (FocusedGroup <> nil) and IsHorizontalGroupNavigation;
  end;

  function CanFocusGroup(AGroup: TdxListGroup): Boolean;
  begin
    Result := AGroup.IsFocusable and (IsHorizontalGroupOnlyNavigation or (ADirectionY <> 0));
  end;

  procedure FocusGroup(AGroup: TdxListGroup; AForward: Boolean);
  begin
    if AGroup.NeedSelectItems then
    begin
      if not (ssCtrl in AShift) or (AShift = [ssShift, ssCtrl]) then
        SelectGroupItems(AGroup, not (ssShift in AShift));
    end
    else
      ClearSelection;
    ViewInfo.AdjustGroupPositionOnNavigation(AGroup, AForward);
    FocusedGroup := AGroup;
  end;

  function FocusNextGroup(AGroup: TdxListGroup): Boolean;
  var
    AItemIndex: Integer;
  begin
    if CanFocusGroup(AGroup) then
    begin
      FocusGroup(AGroup, True);
      Exit(True);
    end
    else
      if not IsHorizontalGroupOnlyNavigation and CanNavigateGroupItems(AGroup) then
      begin
        AItemIndex := GetFirstFocusableItemInGroup(AGroup);
        if AItemIndex >= 0 then
        begin
          GotoItemIndex(AItemIndex, AShift);
          Exit(True);
        end;
      end;
    Result := False;
  end;

  function FocusPrevGroup(AGroup: TdxListGroup): Boolean;
  var
    AItemIndex: Integer;
  begin
    if not IsHorizontalGroupOnlyNavigation and CanNavigateGroupItems(AGroup) then
    begin
      AItemIndex := GetLastFocusableItemInGroup(AGroup);
      if AItemIndex >= 0 then
      begin
        GotoItemIndex(AItemIndex, AShift);
        Exit(True);
      end;
    end
    else
      if CanFocusGroup(AGroup) then
      begin
        FocusGroup(AGroup, False);
        Exit(True);
      end;
    Result := False;
  end;

  function ProcessFocusedGroup(AGroup: TdxListGroup; AForward: Boolean): Boolean;
  var
    I: Integer;
    AIsHorizontalNavigation: Boolean;
  begin
    AIsHorizontalNavigation := IsHorizontalGroupNavigation;
    if AIsHorizontalNavigation then
    begin
      if ViewInfo.ScrollGroupHorizontally(AGroup, AForward) then
        Exit(True);
    end;
    if AForward then
    begin
      if AIsHorizontalNavigation or not CanNavigateGroupItems(AGroup) then
        for I := AGroup.Index + 1 to ListView.Groups.Count - 1 do
        begin
          AGroup := ListView.Groups[I];
          if AGroup.IsVisible and FocusNextGroup(AGroup) then
            Exit(True);
        end;
    end
    else
    begin
      for I := AGroup.Index - 1 downto 0 do
      begin
        AGroup := ListView.Groups[I];
        if AGroup.IsVisible and FocusPrevGroup(AGroup) then
          Exit(True);
      end;
      Exit(True);
    end;
    Result := AIsHorizontalNavigation;
  end;

  procedure GotoItemIndexWithCheck(AItemIndex: Integer);
  var
    AItem: TdxListItem;
  begin
    AItem := ListView.GetItem(AItemIndex);
    if ListView.DoChanging(AItem, TdxListItemChange.State) then
      GotoItemIndex(AItemIndex, AShift, False);
  end;

var
  AForward: Boolean;
  AGroupViewInfo: TdxListGroupCustomViewInfo;
  AItemIndex, AOrderIndex, ARow, AColumn: Integer;
begin
  AItemIndex := GetStartItemIndexForKeyboardNavigation;
  if (FocusedItemIndex < 0) and (FocusedGroup = nil) then
  begin
    if AItemIndex >= 0 then
      GotoItemIndexWithCheck(AItemIndex);
    Exit;
  end;
  AForward := (ADirectionX > 0) or (ADirectionY > 0);
  if FocusedGroup <> nil then
  begin
    if not ProcessFocusedGroup(FocusedGroup, AForward) then
      GotoItemIndexWithCheck(AItemIndex);
    Exit;
  end;

  Assert(AItemIndex >= 0);

  if not ViewInfo.FindGroupViewInfo(AItemIndex, AGroupViewInfo, AOrderIndex) then
    Exit;

  if AGroupViewInfo.GetNextItem(AOrderIndex, ADirectionX, ADirectionY) then
  begin
    GotoItemIndexWithCheck(AGroupViewInfo.OrderIndexToItemIndex(AOrderIndex));
    Exit;
  end
  else
    if not IsGroupView then
      Exit;

  AGroupViewInfo.GetItemPosition(AOrderIndex, ARow, AColumn);
  if AForward then
  begin
    repeat
      AGroupViewInfo := AGroupViewInfo.GetNext;
      if AGroupViewInfo = nil then
        Exit;
      if IsHorizontalGroupNavigation and (FocusedGroup = nil) then
      begin
        if AGroupViewInfo.FindFirstItemByRow(ARow, AOrderIndex) then
        begin
          GotoItemIndexWithCheck(AGroupViewInfo.OrderIndexToItemIndex(AOrderIndex));
          Exit;
        end;
        Continue;
      end;
      if FocusNextGroup(AGroupViewInfo.Group) then
        Exit;
    until False;
  end
  else
  begin
    repeat
      if CanFocusGroup(AGroupViewInfo.Group) then
      begin
        FocusGroup(AGroupViewInfo.Group, False);
        Exit;
      end;
      AGroupViewInfo := AGroupViewInfo.GetPrev;
      if AGroupViewInfo = nil then
        Exit;
      if IsHorizontalGroupNavigation and (FocusedGroup = nil) then
      begin
        if AGroupViewInfo.FindLastItemByRow(ARow, AOrderIndex) then
        begin
          GotoItemIndexWithCheck(AGroupViewInfo.OrderIndexToItemIndex(AOrderIndex));
          Exit;
        end;
        Continue;
      end;
      if FocusPrevGroup(AGroupViewInfo.Group) then
        Exit;
    until False;
  end;
end;

procedure TdxListViewController.ShowPriorPage(AShift: TShiftState);
var
  AItemIndex, AOrderIndex, ASize, ANextIndex, ATopFullVisibleRowIndex, ARowIndex,
  ALeftFullVisibleColumn, AGapSize, AItemSize, AColumnIndex, ARowCount, AColumnCount: Integer;
  AGroupViewInfo: TdxListGroupCustomViewInfo;
  ABounds: TRect;
  AItemsOffset: TSize;
  AIsItemVisible: Boolean;
begin
  AItemIndex := GetStartItemIndexForKeyboardNavigation;
  if AItemIndex < 0 then
    Exit;
  AGroupViewInfo := GetGroupViewInfo(AItemIndex);
  AColumnCount := AGroupViewInfo.ColumnCount;
  AOrderIndex := AGroupViewInfo.ItemIndexToOrderIndex(AItemIndex);
  AGapSize := ViewInfo.GetGapBetweenItems;
  ABounds := ViewInfo.GetGroupVisibleBounds;
  AIsItemVisible := ABounds.IntersectsWith(ViewInfo.GetItemBoundsForMakeVisible(AItemIndex));
  AItemsOffset := ViewInfo.GetItemsOffset;
  if AGroupViewInfo.IsHorizontalItemsArrangement or ViewInfo.IsReportView then
  begin
    ASize := ListView.TopPos - AItemsOffset.cy;
    AItemSize := ViewInfo.ItemSize.cy;
    ARowIndex := AOrderIndex div AColumnCount;
    ATopFullVisibleRowIndex := (ASize + AGapSize + (AItemSize - 1)) div (AItemSize + AGapSize);
    if AIsItemVisible and (ARowIndex > ATopFullVisibleRowIndex) then 
      ANextIndex := AOrderIndex - (ARowIndex - ATopFullVisibleRowIndex) * AColumnCount
    else 
      ANextIndex := AOrderIndex - ((ABounds.Height + AGapSize) div (AItemSize + AGapSize)) * AColumnCount;
  end
  else
  begin
    ARowCount := AGroupViewInfo.RowCount;
    ASize := ListView.LeftPos - AItemsOffset.cx;
    AItemSize := ViewInfo.ItemSize.cx;
    AColumnIndex := AOrderIndex div ARowCount;
    ALeftFullVisibleColumn := (ASize + AGapSize + (AItemSize - 1)) div (AItemSize + AGapSize);
    if AIsItemVisible and (AColumnIndex > ALeftFullVisibleColumn) then
      ANextIndex := AOrderIndex - (AColumnIndex - ALeftFullVisibleColumn) * ARowCount
    else
      ANextIndex := AOrderIndex - ((ABounds.Width + AGapSize) div (AItemSize + AGapSize)) * ARowCount;
  end;
  if ANextIndex < 0 then
  begin
    if IsGroupView and not AGroupViewInfo.IsFirst then
    begin
      repeat
        Inc(ANextIndex, AGroupViewInfo.ItemCount);
        AGroupViewInfo := AGroupViewInfo.GetPrev;
        if InRange(ANextIndex, 0, AGroupViewInfo.ItemCount - 1) then
          Break;
        if AGroupViewInfo.IsFirst then
        begin
          ANextIndex := EnsureRange(ANextIndex, 0, AGroupViewInfo.ItemCount - 1);
          Break;
        end;
      until False;
    end
    else
      ANextIndex := 0;
  end;
  GotoItemIndex(AGroupViewInfo.OrderIndexToItemIndex(ANextIndex), AShift);
end;

procedure TdxListViewController.ShowNextPage(AShift: TShiftState);
var
  AItemIndex, AOrderIndex, ASize, ANextIndex, ALastFullVisibleRowIndex, ARowIndex,
  ARightFullVisibleColumn, AGapSize, AItemSize, AColumnIndex, AColumnCount, ARowCount: Integer;
  AGroupViewInfo: TdxListGroupCustomViewInfo;
  ABounds: TRect;
  AItemsOffset: TSize;
  AIsItemVisible: Boolean;
begin
  AItemIndex := GetStartItemIndexForKeyboardNavigation;
  if AItemIndex < 0 then
    Exit;
  AGroupViewInfo := GetGroupViewInfo(AItemIndex);
  AColumnCount := AGroupViewInfo.ColumnCount;
  AOrderIndex := AGroupViewInfo.ItemIndexToOrderIndex(AItemIndex);
  AGapSize := ViewInfo.GetGapBetweenItems;
  ABounds := ViewInfo.GetGroupVisibleBounds;
  AIsItemVisible := ABounds.IntersectsWith(ViewInfo.GetItemBoundsForMakeVisible(AItemIndex));
  AItemsOffset := ViewInfo.GetItemsOffset;
  if AGroupViewInfo.IsHorizontalItemsArrangement or ViewInfo.IsReportView then
  begin
    ASize := ABounds.Height + ListView.TopPos - AItemsOffset.cy;
    AItemSize := ViewInfo.ItemSize.cy;
    ARowIndex := AOrderIndex div AColumnCount;
    ALastFullVisibleRowIndex := Max(0, (ASize + AGapSize) div (AItemSize + AGapSize) - 1);
    if AIsItemVisible and (ARowIndex < ALastFullVisibleRowIndex) then 
      ANextIndex := AOrderIndex + (ALastFullVisibleRowIndex - ARowIndex) * AColumnCount
    else 
      ANextIndex := AOrderIndex + ((ABounds.Height + AGapSize) div (AItemSize + AGapSize)) * AColumnCount;

  end
  else
  begin
    ARowCount := AGroupViewInfo.RowCount;
    ASize := ABounds.Width + ListView.LeftPos - AItemsOffset.cx;
    AItemSize := ViewInfo.ItemSize.cx;
    AColumnIndex := AOrderIndex div ARowCount;
    ARightFullVisibleColumn := Max(0, (ASize + AGapSize) div (AItemSize + AGapSize) - 1);
    if AIsItemVisible and (AColumnIndex < ARightFullVisibleColumn) then
      ANextIndex := AOrderIndex + (ARightFullVisibleColumn - AColumnIndex) * ARowCount
    else
      ANextIndex := AOrderIndex + ((ABounds.Width + AGapSize) div (AItemSize + AGapSize)) * ARowCount;
  end;
  if ANextIndex >= AGroupViewInfo.ItemCount then
  begin
    if IsGroupView and not AGroupViewInfo.IsLast then
    begin
      repeat
        Dec(ANextIndex, AGroupViewInfo.ItemCount);
        AGroupViewInfo := AGroupViewInfo.GetNext;
        if InRange(ANextIndex, 0, AGroupViewInfo.ItemCount - 1) then
          Break;
        if AGroupViewInfo.IsLast then
        begin
          ANextIndex := EnsureRange(ANextIndex, 0, AGroupViewInfo.ItemCount - 1);
          Break;
        end;
      until False;
    end
    else
      ANextIndex := AGroupViewInfo.ItemCount - 1;
  end;
  GotoItemIndex(AGroupViewInfo.OrderIndexToItemIndex(ANextIndex), AShift);
end;

function TdxListViewController.CanDrag(const AMousePos: TPoint): Boolean;
var
  AItemViewInfo: TdxListItemCustomViewInfo;
begin
  if FPressedItemIndex < 0 then
    Exit(False);

  if FIsPressedItemSelected then
    FDragItemIndex := FPressedItemIndex
  else
  begin
    if ViewInfo.FindItemViewInfo(FPressedItemIndex, AItemViewInfo) and
       AItemViewInfo.StartDrag([], AMousePos) then
      FDragItemIndex := FPressedItemIndex;
  end;
  Result := FDragItemIndex >= 0;
end;

procedure TdxListViewController.EndDragAndDrop(Accepted: Boolean);
begin
  PressedColumn := nil;
  FDragItemIndex := -1;
end;

procedure TdxListViewController.CalculateDragAndDropInfo(const AMousePos: TPoint;
  out AClass: TdxListViewDragAndDropObjectClass;
  out AParams: TObject);
var
  ADragHeaderViewInfo: TdxListColumnHeaderViewInfo;
begin
  AParams := nil;
  AClass := nil;

  if ListView.IsDesigning and not CanSelectColumnInDesigner then
    Exit;
  if FResizingColumn <> nil then
    Exit;
  ADragHeaderViewInfo := ViewInfo.FindDragColumnHeaderViewInfo(AMousePos);
  if ADragHeaderViewInfo <> nil then
  begin
    AClass := TdxListViewColumnHeaderDragAndDropObject;
    AParams := ADragHeaderViewInfo;
    Exit;
  end;
  if MultiSelect and ViewInfo.CanStartMultiSelectionByMouse(AMousePos) then
    AClass := TdxListViewDragSelectDragAndDropObject;
end;

function TdxListViewController.StartDragAndDrop(const P: TPoint): Boolean;
var
  AClass: TdxListViewDragAndDropObjectClass;
  AParams: TObject;
begin
  CalculateDragAndDropInfo(P, AClass, AParams);
  Result := AClass <> nil;
  if Result then
  begin
    ViewInfo.CancelHint;
    ListView.DragAndDropObjectClass := AClass;
    (ListView.DragAndDropObject as TdxListViewDragAndDropObject).Init(P, AParams);
  end;
end;

procedure TdxListViewController.CancelEdit;
begin
  FEditWasClosed := True;
end;

function TdxListViewController.CanSelectColumnInDesigner: Boolean;
begin
  Result := True;
end;

procedure TdxListViewController.FinishEditingTimer;
begin
  FEditingItemIndex := -1;
  ListView.InplaceEditingController.DestroyTimer;
end;

procedure TdxListViewController.FinishSelectGroupItemsTimer;
begin
  FreeAndNil(FSelectGroupItemsTimer);
end;

function TdxListViewController.GetExplorerStyle: Boolean;
begin
  Result := ListView.ExplorerStyle;
end;

function TdxListViewController.GetViewInfo: TdxListViewViewInfo;
begin
  Result := ListView.ViewInfo;
end;

procedure TdxListViewController.OnSelectGroupItemsTimer(Sender: TObject);
begin
  FinishSelectGroupItemsTimer;
  if FSelectItemsGroup <> nil then
  try
    SelectGroupItems(FSelectItemsGroup, not TdxKeyBoard.IsControlPressed);
  finally
    FSelectItemsGroup := nil;
  end;
end;

procedure TdxListViewController.SetFocusedGroup(AValue: TdxListGroup);
begin
  if (AValue <> nil) and not AValue.IsFocusable then
    Exit;
  if FFocusedGroup <> AValue then
  begin
    FinishEditingTimer;
    ExchangePointers(FFocusedGroup, AValue);
    UpdateGroupViewState(FFocusedGroup, True);
    UpdateGroupViewState(AValue);
    if FocusedGroup <> nil then
      FocusedItemIndex := -1;
  end;
end;

procedure TdxListViewController.SetFocusedItemIndex(AItemIndex: Integer);
begin
  SetFocusedItemIndexCore(AItemIndex, vtFully, True, True);
end;

procedure TdxListViewController.SetMouseHoveredGroup(AValue: TdxListGroup);
var
  AOldGroup: TdxListGroup;
begin
  if FMouseHoveredGroup <> AValue then
  begin
    ViewInfo.CancelHint;
    AOldGroup := FMouseHoveredGroup;
    FMouseHoveredGroup := AValue;
    UpdateGroupViewState(AValue);
    UpdateGroupViewState(AOldGroup);
  end;
end;

procedure TdxListViewController.SetMouseHoveredItemIndex(AItemIndex: Integer);
var
  AOldIndex: Integer;
  AViewInfo: TdxListItemCustomViewInfo;
begin
  if MouseHoveredItemIndex <> AItemIndex then
  begin
    AOldIndex := FMouseHoveredItemIndex;
    FMouseHoveredItemIndex := AItemIndex;
    UpdateItemViewState(AItemIndex);
    if ViewInfo.FindItemViewInfo(AOldIndex, AViewInfo) then
      AViewInfo.MouseLeave;
  end;
end;

procedure TdxListViewController.SetMousePressed(AValue: Boolean);
begin
  if MousePressed <> AValue then
  begin
    FMousePressed := AValue;
    UpdateItemViewState(MouseHoveredItemIndex);
  end;
end;

procedure TdxListViewController.SetPressedColumn(AValue: TdxListColumn);
begin
  if FPressedColumn <> AValue then
  begin
    FPressedColumn := AValue;
    UpdateColumnHeadersViewState;
  end;
end;

procedure TdxListViewController.StartSelectGroupItemsTimer;
begin
  FinishSelectGroupItemsTimer;
  FSelectGroupItemsTimer := TcxTimer.Create(nil);
  FSelectGroupItemsTimer.Interval := GetDoubleClickTime;
  FSelectGroupItemsTimer.OnTimer := OnSelectGroupItemsTimer;
end;

{ TdxListViewCustomOptions }

procedure TdxListViewCustomOptions.Changed(AType: TdxChangeType);
begin
  if NeedNotifyControl then
    ListView.LayoutChanged(AType);
end;

procedure TdxListViewCustomOptions.ChangeScale(M, D: Integer);
begin
  // do nothing
end;

function TdxListViewCustomOptions.NeedNotifyControl: Boolean;
begin
  Result := True;
end;

{ TdxListViewIconOptions }

constructor TdxListViewIconOptions.Create(AOwner: TdxCustomListView);
begin
  inherited Create(AOwner);
  FAutoArrange := True;
  FGapBetweenItems := 1;
  FTextLineCount := 2;
end;

procedure TdxListViewIconOptions.ChangeScale(M, D: Integer);
begin
  inherited ChangeScale(M, D);
  GapBetweenItems := MulDiv(GapBetweenItems, M, D);
end;

procedure TdxListViewIconOptions.DoAssign(Source: TPersistent);
var
  AOptions: TdxListViewIconOptions;
begin
  inherited DoAssign(Source);
  if Safe.Cast(Source, TdxListViewIconOptions, AOptions) then
  begin
    Arrangement := AOptions.Arrangement;
    AutoArrange := AOptions.AutoArrange;
    GapBetweenItems := AOptions.GapBetweenItems;
    TextLineCount := AOptions.TextLineCount;
  end;
end;

procedure TdxListViewIconOptions.SetArrangement(AValue: TdxListIconsArrangement);
begin
  if FArrangement <> AValue then
  begin
    FArrangement := AValue;
    if AutoArrange then
    try
      ListView.BeginUpdate;
      ListView.SetLeftTop(TPoint.Null, False);
    finally
      ListView.EndUpdate;
    end;
  end;
end;

procedure TdxListViewIconOptions.SetAutoArrange(AValue: Boolean);
begin
  if FAutoArrange <> AValue then
  begin
    FAutoArrange := AValue;
    Changed;
  end;
end;

procedure TdxListViewIconOptions.SetGapBetweenItems(AValue: Integer);
begin
  AValue := EnsureRange(AValue, 0, MaxGapBetweenItems);
  if FGapBetweenItems <> AValue then
  begin
    FGapBetweenItems := AValue;
    Changed;
  end;
end;

procedure TdxListViewIconOptions.SetTextLineCount(AValue: Integer);
begin
  AValue := EnsureRange(AValue, 1, MaxTextLineCount);
  if FTextLineCount <> AValue then
  begin
    FTextLineCount := AValue;
    Changed;
  end;
end;

{ TdxListViewListOptions }

constructor TdxListViewListOptions.Create(AOwner: TdxCustomListView);
begin
  inherited Create(AOwner);
  FGapBetweenItems := 1;
  FColumnWidth := DefaultColumnWidth;
end;

procedure TdxListViewListOptions.ChangeScale(M, D: Integer);
begin
  inherited ChangeScale(M, D);
  ColumnWidth := MulDiv(ColumnWidth, M, D);
  GapBetweenItems := MulDiv(GapBetweenItems, M, D);
end;

procedure TdxListViewListOptions.DoAssign(Source: TPersistent);
var
  AOptions: TdxListViewListOptions;
begin
  inherited DoAssign(Source);
  if Safe.Cast(Source, TdxListViewListOptions, AOptions) then
  begin
    ColumnWidth := AOptions.ColumnWidth;
    GapBetweenItems := AOptions.GapBetweenItems;
  end;
end;

function TdxListViewListOptions.NeedNotifyControl: Boolean;
begin
  Result := ListView.ViewStyle = TdxListViewStyle.List;
end;

procedure TdxListViewListOptions.SetColumnWidth(AValue: Integer);
begin
  AValue := EnsureRange(AValue, MinColumnWidth, AValue);
  if FColumnWidth <> AValue then
  begin
    FColumnWidth := AValue;
    Changed;
  end;
end;

procedure TdxListViewListOptions.SetGapBetweenItems(AValue: Integer);
begin
  AValue := EnsureRange(AValue, 0, MaxGapBetweenItems);
  if FGapBetweenItems <> AValue then
  begin
    FGapBetweenItems := AValue;
    Changed;
  end;
end;

{ TdxListViewSmallIconOptions }

constructor TdxListViewSmallIconOptions.Create(AOwner: TdxCustomListView);
begin
  inherited Create(AOwner);
  FColumnWidth := DefaultColumnWidth;
end;

procedure TdxListViewSmallIconOptions.ChangeScale(M, D: Integer);
begin
  inherited ChangeScale(M, D);
  ColumnWidth := MulDiv(ColumnWidth, M, D);
end;

procedure TdxListViewSmallIconOptions.DoAssign(Source: TPersistent);
var
  AOptions: TdxListViewSmallIconOptions;
begin
  inherited DoAssign(Source);
  if Safe.Cast(Source, TdxListViewSmallIconOptions, AOptions) then
  begin
    Arrangement := AOptions.Arrangement;
    ColumnWidth := AOptions.ColumnWidth;
  end;
end;

function TdxListViewSmallIconOptions.NeedNotifyControl: Boolean;
begin
  Result := ListView.ViewStyle = TdxListViewStyle.SmallIcon;
end;

procedure TdxListViewSmallIconOptions.SetArrangement(AValue: TdxListIconsArrangement);
begin
  if FArrangement <> AValue then
  begin
    FArrangement := AValue;
    if NeedNotifyControl then
    begin
      ListView.BeginUpdate;
      try
        ListView.SetLeftTop(TPoint.Null, False);
      finally
        ListView.EndUpdate;
      end;
    end;
  end;
end;

procedure TdxListViewSmallIconOptions.SetColumnWidth(AValue: Integer);
begin
  AValue := EnsureRange(AValue, MinColumnWidth, AValue);
  if FColumnWidth <> AValue then
  begin
    FColumnWidth := AValue;
    Changed;
  end;
end;

{ TdxListViewReportOptions }

constructor TdxListViewReportOptions.Create(AOwner: TdxCustomListView);
begin
  inherited Create(AOwner);
  FRowSelect := IsRowSelectStored;
  FAlwaysShowItemImageInFirstColumn := IsAlwaysShowItemImageInFirstColumnStored;
  FShowColumnHeaders := True;
end;

procedure TdxListViewReportOptions.DoAssign(Source: TPersistent);
var
  AOptions: TdxListViewReportOptions;
begin
  inherited DoAssign(Source);
  if Safe.Cast(Source, TdxListViewReportOptions, AOptions) then
  begin
    AlwaysShowItemImageInFirstColumn := AOptions.AlwaysShowItemImageInFirstColumn;
    RowSelect := AOptions.RowSelect;
    ShowColumnHeaders := AOptions.ShowColumnHeaders;
  end;
end;

function TdxListViewReportOptions.IsAlwaysShowItemImageInFirstColumnStored: Boolean;
begin
  Result := AlwaysShowItemImageInFirstColumn;
end;

function TdxListViewReportOptions.IsRowSelectStored: Boolean;
begin
  Result := RowSelect;
end;

function TdxListViewReportOptions.NeedNotifyControl: Boolean;
begin
  Result := ListView.ViewStyle = TdxListViewStyle.Report;
end;

procedure TdxListViewReportOptions.SetAlwaysShowItemImageInFirstColumn(AValue: Boolean);
begin
  if FAlwaysShowItemImageInFirstColumn <> AValue then
  begin
    FAlwaysShowItemImageInFirstColumn := AValue;
    Changed;
  end;
end;

procedure TdxListViewReportOptions.SetRowSelect(AValue: Boolean);
begin
  if FRowSelect <> AValue then
  begin
    FRowSelect := AValue;
    Changed;
  end;
end;

procedure TdxListViewReportOptions.SetShowColumnHeaders(AValue: Boolean);
begin
  if FShowColumnHeaders <> AValue then
  begin
    FShowColumnHeaders := AValue;
    Changed;
  end;
end;

{ TdxListViewPaddingOptions }

procedure TdxListViewPaddingOptions.ChangeScale(M, D: Integer);
begin
  inherited ChangeScale(M, D);
  GroupContent.Margin := cxRectScale(GroupContent.Margin, M, D);
  GroupHeader.Margin := cxRectScale(GroupHeader.Margin, M, D);
  Item.Margin := cxRectScale(Item.Margin, M, D);
  View.Margin := cxRectScale(View.Margin, M, D);
end;

constructor TdxListViewPaddingOptions.Create(AOwner: TdxCustomListView);
begin
  inherited Create(AOwner);
  FGroupContent := CreatePadding(1);
  FGroupHeader := CreatePadding(2);
  FItem := CreatePadding(2);
  FView := CreatePadding(1);
end;

function TdxListViewPaddingOptions.CreatePadding(ADefaultValue: Integer): TcxMargin;
begin
  Result := TcxMargin.Create(Self, ADefaultValue);
  Result.OnChange := ChangeHandler;
end;

destructor TdxListViewPaddingOptions.Destroy;
begin
  FreeAndNil(FGroupContent);
  FreeAndNil(FGroupHeader);
  FreeAndNil(FItem);
  FreeAndNil(FView);
  inherited Destroy;
end;

procedure TdxListViewPaddingOptions.DoAssign(Source: TPersistent);
var
  AOptions: TdxListViewPaddingOptions;
begin
  inherited DoAssign(Source);
  if Safe.Cast(Source, TdxListViewPaddingOptions, AOptions) then
  begin
    GroupContent := AOptions.GroupContent;
    GroupHeader := AOptions.GroupHeader;
    Item := AOptions.Item;
    View := AOptions.View;
  end;
end;

procedure TdxListViewPaddingOptions.SetGroupContent(const AValue: TcxMargin);
begin
  FGroupContent.Assign(AValue);
end;

procedure TdxListViewPaddingOptions.SetGroupHeader(const AValue: TcxMargin);
begin
  FGroupHeader.Assign(AValue);
end;

procedure TdxListViewPaddingOptions.SetItem(const AValue: TcxMargin);
begin
  FItem.Assign(AValue);
end;

procedure TdxListViewPaddingOptions.SetView(const AValue: TcxMargin);
begin
  FView.Assign(AValue);
end;

procedure TdxListViewPaddingOptions.ChangeHandler(Sender: TObject);
begin
  Changed;
end;

{ TdxListViewDragAndDropObject }

procedure TdxListViewDragAndDropObject.AfterPaint;
begin
end;

procedure TdxListViewDragAndDropObject.AfterScrolling;
var
  AAccepted: Boolean;
begin
  AAccepted := False;
  DragAndDrop(ListView.GetMouseCursorClientPos, AAccepted);
end;

procedure TdxListViewDragAndDropObject.BeforePaint;
begin
end;

procedure TdxListViewDragAndDropObject.BeforeScrolling;
begin
end;

procedure TdxListViewDragAndDropObject.BeginDragAndDrop;
begin
  inherited BeginDragAndDrop;
  FAutoScrollHelper := CreateAutoScrollHelper;
end;

function TdxListViewDragAndDropObject.CreateAutoScrollHelper: TdxAutoScrollHelper;
begin
  Result := nil;
end;

procedure TdxListViewDragAndDropObject.DragAndDrop(const P: TPoint; var Accepted: Boolean);
begin
  if FAutoScrollHelper <> nil then
    FAutoScrollHelper.CheckMousePosition(P);
  inherited DragAndDrop(P, Accepted);
end;

procedure TdxListViewDragAndDropObject.EndDragAndDrop(Accepted: Boolean);
begin
  FreeAndNil(FAutoScrollHelper);
  inherited EndDragAndDrop(Accepted);
end;

function TdxListViewDragAndDropObject.GetController: TdxListViewController;
begin
  Result := ListView.Controller;
end;

function TdxListViewDragAndDropObject.GetDragAndDropCursor(Accepted: Boolean): TCursor;
begin
  Result := crDefault;
end;

function TdxListViewDragAndDropObject.GetListView: TdxCustomListView;
begin
  Result := TdxCustomListView(Control);
end;

function TdxListViewDragAndDropObject.GetViewInfo: TdxListViewViewInfo;
begin
  Result := ListView.ViewInfo;
end;

procedure TdxListViewDragAndDropObject.Init(const P: TPoint; AParams: TObject);
begin
  SourcePoint := P;
  FParams := AParams;
end;

{ TdxListViewDragSelectDragAndDropObject }

procedure TdxListViewDragSelectDragAndDropObject.BeginDragAndDrop;
begin
  inherited BeginDragAndDrop;
  UpdateAnchor;
  FStartPos := SourcePoint;
  FFinishPos := FStartPos;
  FExtendedMode := TdxKeyboard.IsControlPressed;
  ListView.BeginDragSelectOperation(FExtendedMode);
end;

function TdxListViewDragSelectDragAndDropObject.CreateAutoScrollHelper: TdxAutoScrollHelper;
begin
  Result := TdxAutoScrollHelper.CreateScroller(ListView, ViewInfo.GetGroupVisibleBounds, 20,
    nil, nil, [TdxScrollAxis.Horizontal, TdxScrollAxis.Vertical], False);
end;

procedure TdxListViewDragSelectDragAndDropObject.DragAndDrop(const P: TPoint; var Accepted: Boolean);
var
  ABounds: TRect;
begin
  inherited DragAndDrop(P, Accepted);
  FFinishPos := P;
  FStartPos.Offset(FAnchor.X - ListView.LeftPos, FAnchor.Y - ListView.TopPos);
  UpdateAnchor;
  ABounds.Init(FStartPos, FFinishPos, True);
  ListView.UpdateDragSelectState(ABounds, FExtendedMode);
end;

procedure TdxListViewDragSelectDragAndDropObject.EndDragAndDrop(Accepted: Boolean);
begin
  inherited EndDragAndDrop(Accepted);
  ListView.EndDragSelectOperation;
end;

function TdxListViewDragSelectDragAndDropObject.ProcessKeyDown(AKey: Word; AShiftState: TShiftState): Boolean;
begin
  Result := True;
end;

function TdxListViewDragSelectDragAndDropObject.ProcessKeyUp(AKey: Word; AShiftState: TShiftState): Boolean;
begin
  if AKey = VK_CONTROL then 
    FExtendedMode := False;
  Result := True;
end;

procedure TdxListViewDragSelectDragAndDropObject.UpdateAnchor;
begin
  FAnchor.Init(ListView.LeftPos, ListView.TopPos);
end;

{ TdxListViewColumnHeaderDragAndDropObject }

procedure TdxListViewColumnHeaderDragAndDropObject.AfterScrolling;
begin
  ChangeArrowsPosition;
  inherited AfterScrolling;
end;

function TdxListViewColumnHeaderDragAndDropObject.AreArrowsVertical: Boolean;
begin
  Result := True;
end;

function TdxListViewColumnHeaderDragAndDropObject.GetHeader: TdxListColumnHeaderViewInfo;
begin
  Result := TdxListColumnHeaderViewInfo(FParams);
end;

function TdxListViewColumnHeaderDragAndDropObject.GetHeadersViewInfo: TdxListViewColumnHeadersViewInfo;
begin
  Result := ViewInfo.ColumnHeadersViewInfo;
end;

procedure TdxListViewColumnHeaderDragAndDropObject.BeginDragAndDrop;
begin
  InitDragObjects;
  ListView.UpdateWithChildren;
  inherited BeginDragAndDrop;
end;

function TdxListViewColumnHeaderDragAndDropObject.CanRemove: Boolean;
begin
  Result := False;
end;

procedure TdxListViewColumnHeaderDragAndDropObject.ChangeArrowsPosition(AVisible: Boolean);
var
  AArrowNumber: TArrowNumber;
begin
  if not HasArrows then
    Exit;
  if AVisible and not IsValidDestination then
    AVisible := False;
  for AArrowNumber := Low(Arrows) to High(Arrows) do
  begin
    if AVisible then
      Arrows[AArrowNumber].Init(ListView, GetArrowAreaBounds(ArrowPlaces[AArrowNumber]),
        ArrowsClientRect, ArrowPlaces[AArrowNumber]);
    Arrows[AArrowNumber].Visible := AVisible;
  end;
end;

procedure TdxListViewColumnHeaderDragAndDropObject.ChangeDragImagePosition(AVisible: Boolean);
begin
  if AVisible then
    DragImage.MoveTo(Control.ClientToScreen(CurMousePos));
  DragImage.Visible := AVisible;
end;

function TdxListViewColumnHeaderDragAndDropObject.CreateAutoScrollHelper: TdxAutoScrollHelper;
var
  AStep: TSize;
begin
  AStep.cx := ListView.GetScrollStep;
  AStep.cy := AStep.cx;
  Result := TdxAutoScrollHelper.CreateScroller(ListView, ListView.ClientBounds, 30, 50, AStep, [TdxScrollAxis.Horizontal]);
end;

procedure TdxListViewColumnHeaderDragAndDropObject.DirtyChanged;
begin
  inherited DirtyChanged;
  ChangeArrowsPosition(not Dirty);
  ChangeDragImagePosition(not Dirty);
end;

function TdxListViewColumnHeaderDragAndDropObject.CalculateDestinationInfo(const P: TPoint): TDestinationInfo;
var
  ADestHeader: TdxListColumnHeaderViewInfo;
  ABounds: TRect;
begin
  ADestHeader := ViewInfo.FindColumnHeaderViewInfo(P);
  if ADestHeader <> nil then
  begin
    Result.Index := ADestHeader.Column.Index;
    ABounds := ADestHeader.Bounds;
    if Column.Index <> Result.Index then
      if ViewInfo.UseRightToLeftAlignment then
        if P.X < ABounds.CenterPoint.X then
          Inc(Result.Index)
        else
        begin
          if Column.Index + 1 = Result.Index then
            Result.Index := Column.Index;
        end
      else
        if P.X > ABounds.CenterPoint.X then
          Inc(Result.Index)
        else
        begin
          if Column.Index + 1 = Result.Index then
            Result.Index := Column.Index;
        end;
  end
  else
  begin
    Result.Index := -1;
    if (ViewInfo.UseRightToLeftAlignment and (P.X < HeadersViewInfo.Bounds.Left))
      or (not ViewInfo.UseRightToLeftAlignment and (P.X >= HeadersViewInfo.Bounds.Right)) then
    begin
      Result.Index := HeadersViewInfo.ItemCount;
    end;
  end;
  Result.Accepted := ViewInfo.Bounds.Contains(P);
end;

procedure TdxListViewColumnHeaderDragAndDropObject.DragAndDrop(const P: TPoint; var Accepted: Boolean);
begin
  DestinationInfo := CalculateDestinationInfo(P);
  Accepted := DestinationInfo.Accepted;
  inherited DragAndDrop(P, Accepted);
  ChangeDragImagePosition;
end;

procedure TdxListViewColumnHeaderDragAndDropObject.EndDragAndDrop(Accepted: Boolean);
var
  AArrowNumber: TArrowNumber;
  ANewIndex: Integer;
begin
  inherited EndDragAndDrop(Accepted);
  for AArrowNumber := Low(Arrows) to High(Arrows) do
    FreeAndNil(Arrows[AArrowNumber]);
  FreeAndNil(FDragImage);
  if Accepted and IsValidDestination then
  begin
    ANewIndex := DestinationInfo.Index;
    if ANewIndex > Column.Index then
      Dec(ANewIndex);
    ANewIndex := Max(0, ANewIndex);
    if Column.Index <> ANewIndex then
    begin
      Column.Index := ANewIndex;
      ListView.DoColumnPosChanged(Column);
      ListView.DoColumnDragged(Column);
      SetDesignerModified(Column);
    end;
  end;
end;

function TdxListViewColumnHeaderDragAndDropObject.GetArrowClass: TcxDragAndDropArrowClass;
begin
  Result := TcxDragAndDropArrow;
end;

function TdxListViewColumnHeaderDragAndDropObject.GetArrowPlace(AArrowNumber: TArrowNumber): TcxArrowPlace;
begin
  if AreArrowsVertical then
    if AArrowNumber = TArrowNumber.First then
      Result := apTop
    else
      Result := apBottom
  else
    if AArrowNumber = TArrowNumber.First then
      Result := apLeft
    else
      Result := apRight;
end;

function TdxListViewColumnHeaderDragAndDropObject.GetArrowAreaBounds(APlace: TcxArrowPlace): TRect;
begin
  with ViewInfo.ColumnHeadersViewInfo do
    if DestinationInfo.Index = ItemCount then
      if ItemCount = 0 then
        Result := Bounds
      else
      begin
        Result := Items[ItemCount - 1].Bounds;
        if UseRightToLeftAlignment then
          Result.Right := Result.Left
        else
          Result.Left := Result.Right;
      end
    else
      Result := Items[DestinationInfo.Index].Bounds;
end;

function TdxListViewColumnHeaderDragAndDropObject.GetArrowsClientRect: TRect;
begin
  Result := ViewInfo.Bounds;
end;

function TdxListViewColumnHeaderDragAndDropObject.GetDragAndDropCursor(Accepted: Boolean): TCursor;
begin
  if Accepted then
    Result := crArrow
  else
    if CanRemove then
      Result := crcxRemove
    else
      Result := crcxNoDrop;
end;

function TdxListViewColumnHeaderDragAndDropObject.GetDragImageClass: TcxDragImageClass;
begin
  Result := TcxDragImage;
end;

function TdxListViewColumnHeaderDragAndDropObject.HasArrows: Boolean;
var
  AArrowNumber: TArrowNumber;
begin
  Result := True;
  for AArrowNumber := Low(Arrows) to High(Arrows) do
    if Arrows[AArrowNumber] = nil then
    begin
      Result := False;
      Break;
    end;
end;

procedure TdxListViewColumnHeaderDragAndDropObject.InitDragImage(const ABounds: TRect; ACanvas: TcxCanvas);
begin
  Header.PaintTo(ACanvas);
end;

procedure TdxListViewColumnHeaderDragAndDropObject.InitDragObjects;
var
  AArrowNumber: TArrowNumber;
begin
  FCenterPoint := HeaderBounds.CenterPoint;
  FDestinationInfo.Index := -1;
  FDragImage := GetDragImageClass.Create;
  FColumn := Header.Column;
  FHeaderBounds := Header.Bounds;
  DragImage.Init(FHeaderBounds, SourcePoint);
  with FHeaderBounds.TopLeft do
    SetViewportOrgEx(DragImage.Canvas.Handle, -X, -Y, nil);
  InitDragImage(HeaderBounds, DragImage.Canvas);
  for AArrowNumber := Low(Arrows) to High(Arrows) do
  begin
    Arrows[AArrowNumber] := GetArrowClass.Create(DragImage.AlphaBlended);
    Arrows[AArrowNumber].BiDiMode := Control.BiDiMode;
  end;
end;

function TdxListViewColumnHeaderDragAndDropObject.IsValidDestination: Boolean;
begin
  Result := (Column.Index <> DestinationInfo.Index) and (DestinationInfo.Index >= 0);
end;

procedure TdxListViewColumnHeaderDragAndDropObject.SetDestinationInfo(const Value: TDestinationInfo);
begin
  if (FDestinationInfo.Index <> Value.Index) or (FDestinationInfo.Accepted <> Value.Accepted) then
    Dirty := True;
  FDestinationInfo := Value;
end;

function TdxListViewColumnHeaderDragAndDropObject.TranslateCoords(const P: TPoint): TPoint;
begin
  Result := inherited TranslateCoords(P);
  Result.Y := SourcePoint.Y;
end;

{ TdxListViewDragObject }

constructor TdxListViewDragObject.Create(AControl: TControl);
begin
  inherited Create(AControl);
  AlwaysShowDragImages := True;
  FAutoScrollHelper := CreateAutoScrollHelper;
end;

destructor TdxListViewDragObject.Destroy;
begin
  FreeAndNil(FAutoScrollHelper);
  inherited Destroy;
end;

function TdxListViewDragObject.CreateAutoScrollHelper: TdxAutoScrollHelper;
var
  AStep: Integer;
  ASize: TSize;
begin
  AStep := ListView.ViewInfo.ItemSize.cy + ListView.ViewInfo.GetGapBetweenItems;
  ASize.Init(AStep);
  Result := TdxAutoScrollHelper.CreateScroller(ListView, ListView.ClientBounds, ListView.ScaleFactor.Apply(20), 250, ASize);
end;

function TdxListViewDragObject.GetDragCursor(Accepted: Boolean; X, Y: Integer): TCursor;
begin
  Result := inherited GetDragCursor(Accepted, X, Y);
end;

function TdxListViewDragObject.GetListView: TdxCustomListView;
begin
  Result := TdxCustomListView(inherited Control);
end;

{ TdxListViewFonts }

constructor TdxListViewFonts.Create(AOwner: TdxCustomListView);
var
  I: TdxListViewFontValue;
begin
  inherited Create(AOwner);
  for I := Low(TdxListViewFontValue) to High(TdxListViewFontValue) do
    FValues[I] := CreateFont;
end;

destructor TdxListViewFonts.Destroy;
var
  I: TdxListViewFontValue;
begin
  for I := Low(TdxListViewFontValue) to High(TdxListViewFontValue) do
    FreeAndNil(FValues[I]);
  inherited Destroy;
end;

procedure TdxListViewFonts.Assign(ASource: TPersistent);
var
  AFonts: TdxListViewFonts;
begin
  if Safe.Cast(ASource, TdxListViewFonts, AFonts) then
  begin
    ColumnHeader := AFonts.ColumnHeader;
    GroupHeader := AFonts.GroupHeader;
    GroupFooter := AFonts.GroupFooter;
    GroupSubtitle := AFonts.GroupSubtitle;
    Item := AFonts.Item;
    SubItem := AFonts.SubItem;
  end;
end;

procedure TdxListViewFonts.AssignFont(ASource, ADest: TFont; AKeepColors: Boolean);
var
  ASaveColor: TColor;
begin
  FLockChanges := True;
  try
    ASaveColor := ADest.Color;
    ADest.Assign(ASource);
    if AKeepColors then
      ADest.Color := ASaveColor;
  finally
    FLockChanges := False;
  end;
end;

procedure TdxListViewFonts.Changed;
begin
  ListView.LayoutChanged;
end;

procedure TdxListViewFonts.ChangeScale(M, D: Integer);
var
  I: TdxListViewFontValue;
begin
  if M <> D then
    for I := Low(TdxListViewFontValue) to High(TdxListViewFontValue) do
    begin
      if (I in FAssignedValues) or not ListView.ParentFont then
        dxScaleFont(FValues[I], M, D);
    end;
end;

function TdxListViewFonts.CreateFont: TFont;
begin
  Result := dxCreateFontForDefaultDPI;
  Result.Color := clDefault;
  Result.OnChange := FontChanged;
end;

procedure TdxListViewFonts.FontChanged(Sender: TObject);
begin
  if FLockChanges then
    Exit;
  if Sender = ColumnHeader then
    Include(FAssignedValues, TdxListViewFontValue.ColumnHeader)
  else if Sender = GroupHeader then
    Include(FAssignedValues, TdxListViewFontValue.GroupHeader)
  else if Sender = GroupFooter then
    Include(FAssignedValues, TdxListViewFontValue.GroupFooter)
  else if Sender = GroupSubtitle then
    Include(FAssignedValues, TdxListViewFontValue.GroupSubtitle)
  else if Sender = Item then
    Include(FAssignedValues, TdxListViewFontValue.Item)
  else
    Include(FAssignedValues, TdxListViewFontValue.SubItem);
  Changed;
end;

function TdxListViewFonts.GetValue(AIndex: Integer): TFont;
begin
  Result := FValues[TdxListViewFontValue(AIndex)];
end;

function TdxListViewFonts.IsStored(AIndex: Integer): Boolean;
begin
  Result := TdxListViewFontValue(AIndex) in AssignedValues;
end;

procedure TdxListViewFonts.SetValue(AIndex: Integer; AValue: TFont);
begin
  FValues[TdxListViewFontValue(AIndex)].Assign(AValue);
end;

procedure TdxListViewFonts.UpdateFonts;
var
  I: TdxListViewFontValue;
begin
  ListView.BeginUpdate;
  try
    for I := Low(TdxListViewFontValue) to High(TdxListViewFontValue) do
      if not (I in FAssignedValues) then
        AssignFont(ListView.Font, FValues[I], True);
  finally
    ListView.EndUpdate;
  end;
end;

procedure TdxListViewFonts.SetAssignedValues(AValue: TdxListViewFontValues);
var
  I: TdxListViewFontValue;
begin
  if FAssignedValues <> AValue then
  begin
    ListView.BeginUpdate;
    try
      for I := Low(TdxListViewFontValue) to High(TdxListViewFontValue) do
        if (I in AValue) <> (I in FAssignedValues) then
        begin
          if not (I in AValue) then
            AssignFont(ListView.Font, FValues[I], True);
        end;
      FAssignedValues := AValue;
    finally
      ListView.EndUpdate;
    end;
  end;
end;

procedure TdxListViewFonts.SetFont(AFont: TFont; AKeepColors: Boolean);
var
  I: TdxListViewFontValue;
begin
  if AFont = nil then
    Exit;
  ListView.BeginUpdate;
  try
    for I := Low(TdxListViewFontValue) to High(TdxListViewFontValue) do
      AssignFont(AFont, FValues[I], AKeepColors);
  finally
    ListView.EndUpdate;
  end;
end;

{ TdxListViewImageOptions }

constructor TdxListViewImageOptions.Create(AOwner: TdxCustomListView);
begin
  inherited Create(AOwner);
  FScaleOnDPIChanges := True;
  FColumnHeaderImagesChangeLink := CreateImagesChangeLink;
  FGroupHeaderImagesChangeLink := CreateImagesChangeLink;
  FLargeImagesChangeLink := CreateImagesChangeLink;
  FSmallImagesChangeLink := CreateImagesChangeLink;
  FStateImagesChangeLink := CreateImagesChangeLink;
end;

destructor TdxListViewImageOptions.Destroy;
begin
  FreeAndNil(FColumnHeaderImagesChangeLink);
  FreeAndNil(FGroupHeaderImagesChangeLink);
  FreeAndNil(FLargeImagesChangeLink);
  FreeAndNil(FSmallImagesChangeLink);
  FreeAndNil(FStateImagesChangeLink);
  inherited Destroy;
end;

procedure TdxListViewImageOptions.Assign(ASource: TPersistent);
var
  AImages: TdxListViewImageOptions;
begin
  if Safe.Cast(ASource, TdxListViewImageOptions, AImages) then
  begin
    ColumnHeaderImages := AImages.ColumnHeaderImages;
    GroupHeaderImages := AImages.GroupHeaderImages;
    LargeImages := AImages.LargeImages;
    SmallImages := AImages.SmallImages;
    StateImages := AImages.StateImages;
    ScaleOnDPIChanges := AImages.ScaleOnDPIChanges;
  end;
end;

function TdxListViewImageOptions.AreImagesLinked(const AValue: TObject): Boolean;
begin
  Result :=
    (AValue = FColumnHeaderImages) or
    (AValue = FGroupHeaderImages) or
    (AValue = FLargeImages) or
    (AValue = FSmallImages) or
    (AValue = FStateImages);
end;

function TdxListViewImageOptions.CreateImagesChangeLink: TChangeLink;
begin
  Result := TChangeLink.Create;
  Result.OnChange := ImageListChanged;
end;

procedure TdxListViewImageOptions.ImageListChanged(Sender: TObject);
begin
  if AreImagesLinked(Sender) then
    ListView.LayoutChanged;
end;

procedure TdxListViewImageOptions.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if Operation = opRemove then
  begin
    if AComponent = ColumnHeaderImages then
      ColumnHeaderImages := nil;
    if AComponent = GroupHeaderImages then
      GroupHeaderImages := nil;
    if AComponent = LargeImages then
      LargeImages := nil;
    if AComponent = SmallImages then
      SmallImages := nil;
    if AComponent = StateImages then
      StateImages := nil;
  end;
end;

procedure TdxListViewImageOptions.SetColumnHeaderImages(const AValue: TCustomImageList);
begin
  cxSetImageList(AValue, FColumnHeaderImages, FColumnHeaderImagesChangeLink, ListView, ImageListChangeNotify);
end;

procedure TdxListViewImageOptions.SetGroupHeaderImages(const AValue: TCustomImageList);
begin
  cxSetImageList(AValue, FGroupHeaderImages, FGroupHeaderImagesChangeLink, ListView, ImageListChangeNotify);
end;

procedure TdxListViewImageOptions.SetLargeImages(const AValue: TCustomImageList);
begin
  cxSetImageList(AValue, FLargeImages, FLargeImagesChangeLink, ListView, ImageListChangeNotify);
end;

procedure TdxListViewImageOptions.SetScaleOnDPIChanges(const Value: Boolean);
begin
  if FScaleOnDPIChanges <> Value then
  begin
    FScaleOnDPIChanges := Value;
    ListView.LayoutChanged;
  end;
end;

procedure TdxListViewImageOptions.SetSmallImages(const AValue: TCustomImageList);
begin
  cxSetImageList(AValue, FSmallImages, FSmallImagesChangeLink, ListView, ImageListChangeNotify)
end;

procedure TdxListViewImageOptions.SetStateImages(const AValue: TCustomImageList);
begin
  cxSetImageList(AValue, FStateImages, FStateImagesChangeLink, ListView, ImageListChangeNotify);
  if AValue <> nil then
    ListView.Checkboxes := False;
end;

procedure TdxListViewImageOptions.ImageListChangeNotify(Sender: TComponent; Operation: TOperation);
begin
  if Operation = opRemove then
  begin
    if ListView.Painter <> nil then
      ListView.Painter.InvalidateImageList(Sender as TCustomImageList);
  end;
end;

{ TdxCustomListView }

constructor TdxCustomListView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csParentBackground];
  CanBeFocused := True;
  ParentShowHint := True;
  Keys := [kArrows, kChars];
  BorderStyle := cxcbsDefault;
  Width := 150;
  Height := 100;

  FPaddingOptions := CreatePaddingOptions;
  FFonts := CreateFonts;
  FImageOptions := CreateImages;
  FColumns := CreateColumns;
  FGroups := CreateGroups;
  FItems := CreateItems;
  CreateViewStyleOptions;
  FHintHelper := CreateHintHelper;
  FInplaceEditingController := TdxListViewInplaceEditingController.Create(Self);
  FDropTargetIndices := TdxIntegerList.Create;
  FTempItem := CreateListItem;
  FEditingItemIndex := -1;
end;

destructor TdxCustomListView.Destroy;
begin
  FreeAndNil(FDropTargetIndices);
  FreeAndNil(FHintHelper);
  FreeAndNil(FInplaceEditingController);
  FTempItem.Free; 
  Items.List.Clear; 
  FreeAndNil(FItems);
  FreeAndNil(FGroups);
  FreeAndNil(FColumns);
  DestroyViewStyleOptions;
  FreeAndNil(FImageOptions);
  FreeAndNil(FFonts);
  FreeAndNil(FPaddingOptions);
  inherited Destroy;
end;

procedure TdxCustomListView.BeginUpdate;
begin
  if FLockCount = 0 then
  begin
    FSavedSort := SortType;
    FSortNeedeed := False;
  end;
  Inc(FLockCount);
end;

procedure TdxCustomListView.EndUpdate;
begin
  Dec(FLockCount);
  if FLockCount = 0 then
  try
    if SortType <> FSavedSort then
      SortType := FSavedSort
    else if FSortNeedeed then
      AlphaSort
    else
      LayoutChanged;
  finally
    FSortNeedeed := False;
  end;
end;

function TdxCustomListView.IsDragging: Boolean;
begin
  Result := Dragging or (DragAndDropState <> ddsNone);
end;

function TdxCustomListView.CanDrag(X, Y: Integer): Boolean;
begin
  Result := inherited CanDrag(X, Y) and Controller.CanDrag(TPoint.Create(X, Y));
end;

procedure TdxCustomListView.DoEndDrag(Target: TObject; X, Y: Integer);
begin
  inherited DoEndDrag(Target, X, Y);
  ClearDropTargets;
end;

procedure TdxCustomListView.CMDrag(var Message: TCMDrag);
begin
  inherited;
  with Message, DragRec^ do
    case DragMessage of
      dmDragMove:
        with ScreenToClient(Pos) do
          DoDragOver(Source, X, Y, Message.Result <> 0);
      dmDragLeave:
        begin
          TDragObject(Source).HideDragImage;
          FLastDropTarget := DropTarget;
          DropTarget := nil;
          Update;
          TDragObject(Source).ShowDragImage;
        end;
    end
end;

procedure TdxCustomListView.DrawDragImage(ACanvas: TcxCanvas; const R: TRect);
const
  FrameColor = $FFD199;
var
  AColor: TColor;
  ABounds, AShadowHLineBounds, AShadowVLineBounds: TRect;
  I: Integer;
begin
  ABounds := R;
  Dec(ABounds.Right, DragShadowSize);
  Dec(ABounds.Bottom, DragShadowSize);
  ACanvas.Rectangle(ABounds, $FFE8CC, FrameColor, psSolid);
  AShadowVLineBounds.Init(ABounds.Right, ABounds.Top + 1, ABounds.Right + 1, ABounds.Bottom + 1);
  AShadowHLineBounds.Init(ABounds.Left + 1, ABounds.Bottom, ABounds.Right + 1, ABounds.Bottom + 1);
  for I := 1 to DragShadowSize do
  begin
    AColor := TdxColorUtils.ChangeLightness(clBlack, 0.25 + I / 6);
    ACanvas.FillRect(AShadowHLineBounds, AColor);
    ACanvas.FillRect(AShadowVLineBounds, AColor);
    AShadowHLineBounds.Offset(1, 1);
    AShadowVLineBounds.Offset(1, 1);
  end;
  ABounds.Deflate(DragImagePadding);
  ACanvas.IntersectClipRect(ABounds);
  DrawDragImageContent(ACanvas, ABounds);
end;

procedure TdxCustomListView.DrawDragImageContent(ACanvas: TcxCanvas; const ABounds: TRect);
const
  Offset = 3;
  MaxPaintItemCount = 4;
var
  I, ACount, APaintCount, ADelta, AOffset: Integer;
  ASize: TSize;
  R: TRect;
  S: string;
  AImages: TCustomImageList;
begin
  ACount := Min(MaxPaintItemCount, SelectedItemCount);
  AImages := ImageOptions.LargeImages;
  if AImages = nil then
    AImages := ImageOptions.SmallImages;
  if AImages <> nil then
  begin
    AOffset := ScaleFactor.Apply(Offset);
    R := ABounds;
    ASize.Init(AImages.Width, AImages.Height);
    ADelta := Min(R.Width - ASize.cx, R.Height - ASize.cy);
    if ADelta >= 0 then
    begin
      APaintCount := Max(1, Min(ACount, ADelta div AOffset + 1));
      R := cxRectCenter(ABounds, ASize);
      R.Offset((-AOffset * APaintCount) div 2, (-AOffset * APaintCount) div 2);
      for I := 0 to APaintCount - 1 do
      begin
        TdxImageDrawer.DrawImage(ACanvas, R, nil, AImages, SelectedItems[I].ImageIndex, True);
        R.Offset(AOffset, AOffset);
      end;
    end;
  end;
  if ACount > 1 then
  begin
    S := IntToStr(ACount);
    ACanvas.Font := Font;
    ACanvas.Font.Style := [fsBold];
    ASize := ACanvas.TextExtent(S);
    Inc(ASize.cx, ScaleFactor.Apply(8));
    Inc(ASize.cy, ScaleFactor.Apply(4));
    R := cxRectCenter(ABounds, ASize);
    ACanvas.Brush.Style := bsSolid;
    ACanvas.Rectangle(R, TdxAlphaColors.FromArgb($30, 0, $60), clWhite, psSolid);
    ACanvas.Brush.Style := bsClear;
    ACanvas.Font.Color := clWhite;
    ACanvas.TextOut(R.Left + ScaleFactor.Apply(4), R.Top + ScaleFactor.Apply(2), S);
  end;
end;

procedure TdxCustomListView.EndDragAndDrop(Accepted: Boolean);
begin
  Controller.EndDragAndDrop(Accepted);
  inherited EndDragAndDrop(Accepted);
end;

function TdxCustomListView.GetDragImagesSize: TPoint;
const
  DefaultExplorerDragImageSize = 104;
  DefaultDragImageSize = 48;
var
  AImages: TCustomImageList;
begin
  if ExplorerStyle then
    Result.Init(DefaultExplorerDragImageSize, DefaultExplorerDragImageSize)
  else
  begin
    AImages := ImageOptions.LargeImages;
    if AImages = nil then
      AImages := ImageOptions.SmallImages;
    if AImages <> nil then
      Result.Init(Max(DefaultDragImageSize, AImages.Width), Max(DefaultDragImageSize, AImages.Height))
    else
      Result.Init(DefaultDragImageSize, DefaultDragImageSize);
  end;
  Result := ScaleFactor.Apply(Result);
  Inc(Result.X, DragShadowSize + DragImagePadding * 2);
  Inc(Result.Y, DragShadowSize + DragImagePadding * 2);
end;

function TdxCustomListView.HasDragImages: Boolean;
begin
  Result := True;
end;

procedure TdxCustomListView.BeginDragSelectOperation(AExtendedMode: Boolean);
begin
  FIsDragSelectPaintMode := True;
  FDragSelectRectangle.Empty;
  FOriginalSelection := TdxHashSet<Integer>.Create;
  if AExtendedMode then
    FOriginalSelection.Include(Controller.SelectedIndices.ToArray)
  else
    Controller.ClearSelection;
  FCurrentDragSelection := TdxHashSet<Integer>.Create;
end;

procedure TdxCustomListView.EndDragSelectOperation;
begin
  FIsDragSelectPaintMode := False;
  FreeAndNil(FCurrentDragSelection);
  FreeAndNil(FOriginalSelection);
  Invalidate;
end;

function TdxCustomListView.StartDragAndDrop(const P: TPoint): Boolean;
begin
  Result := Controller.StartDragAndDrop(P);
end;

procedure TdxCustomListView.UpdateDragSelectState(const ABounds: TRect; AExtendedSelection: Boolean);

  function GetItemBounds(AItemIndex: Integer): TRect;
  var
    AItemViewInfo: TdxListItemCustomViewInfo;
  begin
    if not ViewInfo.FindItemViewInfo(AItemIndex, AItemViewInfo) then
      Result := ViewInfo.GetBoundsForItem(AItemIndex)
    else
      Result := AItemViewInfo.Bounds;
  end;

var
  I: Integer;
  R: TRect;
  ANewSelection: TdxHashSet<Integer>;
  ASelect, AControlPressed: Boolean;
begin
  R.InitSize(ABounds.TopLeft, Max(1, ABounds.Width), Max(1, ABounds.Height));
  if FDragSelectRectangle.IsEqual(R) then
    Exit;
  FDragSelectRectangle := R;
  Controller.BeginSelectionChanged;
  try
    ANewSelection := TdxHashSet<Integer>.Create;
    try
      AControlPressed := TdxKeyboard.IsControlPressed;
      for I := 0 to Items.Count - 1 do
      begin
        if AExtendedSelection and AControlPressed then
          ASelect := not FOriginalSelection.Contains(I)
        else
          ASelect := True;
        R := GetItemBounds(I);
        if R.IntersectsWith(FDragSelectRectangle) then
        begin
          ANewSelection.Include(I);
          Controller.SelectItem(I, ASelect);
        end
        else
          if FCurrentDragSelection.Contains(I) then
            Controller.SelectItem(I, not ASelect);
      end;
    finally
      FCurrentDragSelection.Free;
      FCurrentDragSelection := ANewSelection;
    end;
  finally
    Controller.EndSelectionChanged;
  end;
  Repaint;
end;

procedure TdxCustomListView.InitDragImages(ADragImages: TcxDragImageList);
var
  B: TcxBitmap32;
  ASize: TPoint;
begin
  ASize := GetDragImagesSize;
  ADragImages.DragHotspot := TPoint.Create(ASize.X div 2, ASize.Y - 8);
  ADragImages.Masked := False;
  ADragImages.Width := ASize.X;
  ADragImages.Height := ASize.Y;
  B := TcxBitmap32.Create;
  try
    B.SetSize(ASize.X, ASize.Y);
    DrawDragImage(B.cxCanvas, Rect(0, 0, ASize.X, ASize.Y));
    ADragImages.Add(B, nil);
  finally
    B.Free;
  end;
end;

procedure TdxCustomListView.AddItem(const AItem: string; AObject: TObject);
begin
  with Items.Add do
  begin
    Caption := AItem;
    Data := AObject;
  end;
end;

function TdxCustomListView.AlphaSort: Boolean;
begin
  if FLockCount = 0 then
    Result := CustomSort(nil, 0)
  else
  begin
    Result := False;
    FSortNeedeed := True;
  end;
end;

procedure TdxCustomListView.ApplyBestFit(AColumn: TdxListColumn = nil;
  AVisibleItemsOnly: Boolean = False);
var
  I, ANewWidth: Integer;
begin
  BeginUpdate;
  try
    if AColumn = nil then
    begin
      for I := 0 to Columns.Count - 1 do
      begin
        AColumn := Columns[I];
        ANewWidth := ViewInfo.CalculateColumnBestFitWidth(AColumn, AVisibleItemsOnly);
        if ANewWidth <> AColumn.Width then
        begin
          AColumn.Width := ANewWidth;
          DoColumnSizeChanged(AColumn);
          SetDesignerModified(AColumn);
        end;
      end;
      Exit;
    end;
    ANewWidth := ViewInfo.CalculateColumnBestFitWidth(AColumn, AVisibleItemsOnly);
    if ANewWidth <> AColumn.Width then
    begin
      AColumn.Width := ANewWidth;
      DoColumnSizeChanged(AColumn);
      SetDesignerModified(AColumn);
    end;
  finally
    EndUpdate;
  end;
end;

function TdxCustomListView.CanFocus: Boolean;
begin
  Result := inherited CanFocus and CanBeFocused;
end;

procedure TdxCustomListView.Clear;
begin
  BeginUpdate;
  try
    ClearItems;
  finally
    EndUpdate;
  end;
end;

function TdxCustomListView.CustomSort(ASortProc: TdxListViewCompareProc; AData: TdxNativeInt): Boolean;
var
  I, AIndex: Integer;
  AFocusedItem: TdxListItem;
  ASelectedItems: TdxFastList;
begin
  Result := False;
  if OwnerData then
    Exit;
  if FItems.Count > 1 then
  begin
    FinishItemCaptionEditing(True);
    if not Assigned(ASortProc) then
      ASortProc := @DefaultListViewSort;
    AFocusedItem := FocusedItem;
    BeginUpdate;
    try
      ASelectedItems := TdxFastList.Create(SelectedItemCount);
      try
        for I := 0 to SelectedItemCount - 1 do
          ASelectedItems.Add(SelectedItems[I]);
        Controller.SelectedIndices.Clear;
        if GroupView then
        begin
          for I := 0 to Groups.Count - 1 do
            Groups[I].CustomSort(ASortProc, AData);
        end
        else
          FItems.CustomSort(ASortProc, AData);
        Result := True;
        for I := 0 to ASelectedItems.Count - 1 do
        begin
          AIndex := TdxListItem(ASelectedItems[I]).Index;
          Controller.SelectedIndices.Add(AIndex);
        end;
      finally
        ASelectedItems.Free;
      end;
    finally
      EndUpdate;
      if AFocusedItem <> nil then
        Controller.FocusedItemIndex := AFocusedItem.Index;
    end;
  end;
end;

procedure TdxCustomListView.ExpandAllGroups;
var
  I: Integer;
begin
  if Groups.Count = 0 then
    Exit;
  BeginUpdate;
  try
    for I := 0 to Groups.Count - 1 do
      Groups[I].Collapsed := False;
  finally
    EndUpdate;
  end;
end;

procedure TdxCustomListView.GetChildren(Proc: TGetChildProc; Root: TComponent);
var
  I: Integer;
begin
  for I := 0 to Groups.Count - 1 do
    if Groups[I].Owner = Root then Proc(Groups[I]);
  for I := 0 to Columns.Count - 1 do
    if Columns[I].Owner = Root then Proc(Columns[I]);
end;

procedure TdxCustomListView.MakeItemVisible(AItem: TdxListItem; AVisibleType: TdxVisibilityType);
begin
  Controller.MakeItemVisible(AItem, AVisibleType);
end;

function TdxCustomListView.CreateColumns: TdxListColumns;
begin
  Result := TdxListColumns.Create(Self, GetColumnClass);
end;

function TdxCustomListView.CreateController: TdxListViewController;
begin
  Result := TdxListViewController.Create(Self);
end;

function TdxCustomListView.CreatePainter: TdxListViewPainter;
begin
  Result := TdxListViewPainter.Create(Self);
end;

function TdxCustomListView.CreateViewInfo: TdxListViewViewInfo;
begin
  Result := TdxListViewViewInfo.Create(Self);
end;

function TdxCustomListView.CreateListItem: TdxListItem;
var
  AClass: TdxListItemClass;
begin
  AClass := TdxListItem;
  if Assigned(FOnCreateItemClass) then
    FOnCreateItemClass(Self, AClass);
  Result := AClass.Create(Items);
end;

procedure TdxCustomListView.CreateViewSubClasses;
begin
  FViewInfo := CreateViewInfo;
  FController := CreateController;
  FPainter := CreatePainter;
end;

procedure TdxCustomListView.DestroyViewSubClasses;
begin
  FreeAndNil(FViewInfo);
  FreeAndNil(FController);
  FreeAndNil(FPainter);
end;

function TdxCustomListView.GetColumnClass: TdxListColumnClass;
begin
  Result := TdxListColumn;
end;

function TdxCustomListView.GetGroupClass: TdxListGroupClass;
begin
  Result := TdxListGroup;
end;

procedure TdxCustomListView.FocusEnter;
begin
  inherited FocusEnter;
  Controller.FocusEnter;
end;

procedure TdxCustomListView.FocusLeave;
begin
  inherited FocusLeave;
  Controller.FocusLeave;
end;

procedure TdxCustomListView.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  Controller.BeforeKeyDown(Key, Shift);
  try
    Controller.KeyDown(Key, Shift);
  finally
    Controller.AfterKeyDown(Key, Shift);
  end;
end;

procedure TdxCustomListView.DoIncSearch(var Key: Char);
var
  ATicks: Cardinal;
  AStartIndex: Integer;
  AUpperKey: Char;
  AItem: TdxListItem;
begin
  AStartIndex := Controller.FocusedItemIndex + 1;
  ATicks := GetTickCount;
  AUpperKey := TdxCharacters.ToUpper(Key);
  if ATicks - FLastKeyPressTicks < GetDoubleClickTime * 2 then
  begin
    if FIncSearchText <> AUpperKey then
    begin
      FIncSearchText := FIncSearchText + AUpperKey;
      if Controller.FocusedItemIndex >= 0 then
        Dec(AStartIndex);
    end;
  end
  else
    FIncSearchText := AUpperKey;
  Key := #0;
  FLastKeyPressTicks := ATicks;
  if FIncSearchText = ' ' then
  begin
    FIncSearchText := '';
    Exit;
  end;
  AItem := FindCaption(AStartIndex, FIncSearchText, True, True, True);
  if AItem <> nil then
    Controller.GotoItemIndex(AItem.Index, [])
  else
    Beep;
end;

procedure TdxCustomListView.ProcessIncSearch(var Key: Char);
begin
  if (Key >= ' ') and not (TdxKeyboard.IsAltPressed or TdxKeyboard.IsControlPressed) then
  begin
    Controller.BeginSelectionChanged;
    try
      DoIncSearch(Key);
    finally
      Controller.EndSelectionChanged;
    end;
  end;
end;

procedure TdxCustomListView.KeyPress(var Key: Char);
begin
  if not (TdxKeyboard.IsAltPressed or TdxKeyboard.IsControlPressed)  then
    ProcessIncSearch(Key);
  inherited KeyPress(Key);
end;

procedure TdxCustomListView.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited KeyUp(Key, Shift);
  Controller.KeyUp(Key, Shift);
end;

procedure TdxCustomListView.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  Controller.MouseUp(Button, Shift, TPoint.Create(X, Y));
end;

procedure TdxCustomListView.Click;
begin
  inherited Click;
  Controller.Click;
end;

procedure TdxCustomListView.DblClick;
begin
  inherited DblClick;
  Controller.DblClick;
end;

function TdxCustomListView.GetDesignHitTest(X, Y: Integer; Shift: TShiftState): Boolean;
begin
  Result := Controller.GetDesignHitTest(TPoint.Create(X, Y)) or
    inherited GetDesignHitTest(X, Y, Shift);
end;

procedure TdxCustomListView.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  Controller.BeforeMouseDown(Button, Shift, TPoint.Create(X, Y));
  try
    Controller.MouseDown(Button, Shift, TPoint.Create(X, Y));
  finally
    Controller.AfterMouseDown(Button, Shift, TPoint.Create(X, Y));
  end;
end;

procedure TdxCustomListView.MouseLeave(AControl: TControl);
begin
  inherited MouseLeave(AControl);
  Controller.MouseLeave;
end;

procedure TdxCustomListView.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove(Shift, X, Y);
  Controller.MouseMove(Shift, TPoint.Create(X, Y));
end;

procedure TdxCustomListView.DoDragOver(Source: TDragObject; X, Y: Integer; CanDrop: Boolean);
var
  Item: TdxListItem;
  Target: TdxListItem;
begin
  Item := GetItemAtPos(TPoint.Create(X, Y));
  if Item <> nil then
  begin
    Target := DropTarget;
    if (Item <> Target) or (Item = FLastDropTarget) then
    begin
      ClearDropTargets;
      TDragObject(Source).HideDragImage;
      Update;
      if Target <> nil then
        Target.DropTarget := False;
      Item.DropTarget := CanDrop;
      Update;
      TDragObject(Source).ShowDragImage;
    end;
  end;
end;

procedure TdxCustomListView.DragOver(Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  inherited DragOver(Source, X, Y, State, Accept);
  case State of
    dsDragEnter:
      Controller.DragEnter;
    dsDragLeave:
      Controller.DragLeave;
    dsDragMove:
      Controller.DragOver(Source, TPoint.Create(X, Y), Accept);
  end;
end;

function TdxCustomListView.GetDragObjectClass: TDragControlObjectClass;
begin
  Result := TdxListViewDragObject;
end;

procedure TdxCustomListView.DragDrop(Source: TObject; X, Y: Integer);
begin
  Controller.DragDrop(Source, X, Y);
  inherited DragDrop(Source, X, Y);
end;

function TdxCustomListView.StartDrag(DragObject: TDragObject): Boolean;
begin
  if DragObject is TdxListViewDragObject then
  begin
    ClearDropTargets;
    Result := (SelectedItemCount > 0) and (Controller.MouseHoveredItemIndex >= 0);
  end
  else
    Result := False;
end;

procedure TdxCustomListView.ShowInplaceEdit(AItemIndex: Integer; ABounds: TRect; const AText: string);
begin
  InplaceEdit.Show(Self, ABounds, AText, ViewInfo.ItemViewParams.GdiFont, 0, MaxInt, 0);
end;

procedure TdxCustomListView.ValidatePasteText(var AText: string);
begin
end;

function TdxCustomListView.CanAutoSize(var NewWidth, NewHeight: Integer): Boolean;
begin
  Result := False;
end;

procedure TdxCustomListView.Loaded;
begin
  BeginUpdate;
  try
    FSortType := TdxListViewSortType.None;
    Columns.ValidateCreateIndices;
    Items.FixupGroups;
    inherited Loaded;
  finally
    EndUpdate;
  end;
end;

procedure TdxCustomListView.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if ImageOptions <> nil then
    ImageOptions.Notification(AComponent, Operation);
end;

procedure TdxCustomListView.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  Controller.FinishEditingTimer;
  inherited;
end;

procedure TdxCustomListView.WndProc(var Message: TMessage);
var
  PS: TPaintStruct;
begin
  if (Message.Msg = WM_PAINT) and (FLockCount > 0) then
  begin
    BeginPaint(Handle, PS);
    EndPaint(Handle, PS);
    Message.Result := 0;
    Exit;
  end;
  inherited WndProc(Message);
end;

function TdxCustomListView.GetContentSize: TSize;
var
  ABounds: TRect;
begin
  Result.Init(0, 0);
  if ViewInfo = nil then
    Exit;
  ABounds := ViewInfo.ContentBounds;
  if ABounds.IsEmpty then
    Exit;
  ABounds.Inflate(PaddingOptions.View.Margin);
  Result := ABounds.Size;
  if ViewStyle = TdxListViewStyle.Report then
    Dec(Result.cx, ViewInfo.ContentOffset.Left);
end;

function TdxCustomListView.GetMouseWheelScrollingKind: TcxMouseWheelScrollingKind;
begin
  if ViewInfo = nil then
    Result := inherited GetMouseWheelScrollingKind
  else
    if ViewInfo.AreGroupsVertical then
      Result := mwskVertical
    else
      Result := mwskHorizontal;
end;

function TdxCustomListView.GetScrollStep: Integer;
begin
  if HandleAllocated then
    Result := ViewInfo.ItemSize.cy + GetGapBetweenItems
  else
    Result := inherited GetScrollStep;
end;

function TdxCustomListView.IsScrollDataValid: Boolean;
begin
  Result := inherited IsScrollDataValid and not IsDestroying;
end;

function TdxCustomListView.GetActiveDragAndDropObject: TdxListViewDragAndDropObject;
begin
  if DragAndDropState = ddsInProcess then
    Result := Safe<TdxListViewDragAndDropObject>.Cast(DragAndDropObject)
  else
    Result := nil;
end;

procedure TdxCustomListView.AfterScrolling;

  function HasScrollBarCapture: Boolean;
  var
    AScrollBar: TcxScrollBar;
  begin
    AScrollBar := VScrollBar.Control;
    Result := (AScrollBar <> nil) and AScrollBar.HandleAllocated and (AScrollBar.Handle = GetCapture);
    if Result then
      Exit;
    AScrollBar := HScrollBar.Control;
    Result := (AScrollBar <> nil) and AScrollBar.HandleAllocated and (AScrollBar.Handle = GetCapture);
  end;

var
  ADragAndDropObject: TdxListViewDragAndDropObject;
begin
  if FLockCount > 0 then
    Exit;
  if not HasScrollBarCapture then
    Controller.UpdateMouseHottrack;
  ADragAndDropObject := GetActiveDragAndDropObject;
  if ADragAndDropObject <> nil then
    ADragAndDropObject.AfterScrolling;
  Repaint;
end;

procedure TdxCustomListView.BeforeScrolling;
var
  ADragAndDropObject: TdxListViewDragAndDropObject;
begin
  FinishItemCaptionEditing(True);
  ADragAndDropObject := GetActiveDragAndDropObject;
  if ADragAndDropObject <> nil then
    ADragAndDropObject.BeforeScrolling;
end;

procedure TdxCustomListView.BoundsChanged;
begin
  FinishItemCaptionEditing;
  LayoutChanged(ctMedium);
end;

procedure TdxCustomListView.Calculate(AType: TdxChangeType);
begin
  ViewInfo.Calculate(AType, ClientBounds);
  if UseRightToLeftAlignment then
    ViewInfo.RightToLeftConversion(ClientBounds);
end;

function TdxCustomListView.CanCalculate: Boolean;
begin
  Result := inherited CanCalculate and (FLockCount = 0);
end;

procedure TdxCustomListView.LayoutChanged(AType: TdxChangeType);
begin
  if not IsUpdateLocked then
    inherited LayoutChanged(AType);
end;

procedure TdxCustomListView.ScrollPosChanged(const AOffset: TPoint);
begin
  BeforeScrolling;
  try
    LayoutChanged(ctLight);
  finally
    AfterScrolling;
  end;
end;

procedure TdxCustomListView.ValidateVisibleContent;
begin
  Controller.CheckVisibleItem;
end;

function TdxCustomListView.AllowTouchScrollUIMode: Boolean;
begin
  Result := not IsDesigning;
end;

procedure TdxCustomListView.ChangeScaleEx(M, D: Integer; isDpiChange: Boolean);
begin
  BeginUpdate;
  try
    FinishItemCaptionEditing;
    inherited ChangeScaleEx(M, D, isDpiChange);
    DoChangeScaleEx(M, D, isDpiChange);
  finally
    EndUpdate;
  end;
end;

procedure TdxCustomListView.CreateCanvasBasedResources;
begin
  inherited CreateCanvasBasedResources;
  CreateViewSubClasses;
  if HandleAllocated then
  begin
    LayoutChanged;
    Invalidate;
  end;
end;

procedure TdxCustomListView.FreeCanvasBasedResources;
begin
  DestroyViewSubClasses;
  inherited FreeCanvasBasedResources;
end;

procedure TdxCustomListView.DoCancelMode;
begin
  Controller.CancelMode;
  inherited DoCancelMode;
end;

procedure TdxCustomListView.DoChangeScaleEx(M, D: Integer; isDpiChange: Boolean);
begin
  BeginUpdate;
  try
    Fonts.ChangeScale(M, D);
    ViewStyleIcon.ChangeScale(M, D);
    ViewStyleList.ChangeScale(M, D);
    ViewStyleReport.ChangeScale(M, D);
    ViewStyleSmallIcon.ChangeScale(M, D);
    Columns.ChangeScale(M, D);
    PaddingOptions.ChangeScale(M, D);
  finally
    EndUpdate;
  end;
end;

procedure TdxCustomListView.DoPaint;
begin
  inherited DoPaint;
  ViewInfo.Draw(ActualCanvas);
  if FIsDragSelectPaintMode and not FDragSelectRectangle.IsEmpty then
    Painter.DrawMultiSelectionRect(ActualCanvas, FDragSelectRectangle);
end;

procedure TdxCustomListView.FontChanged;
begin
  inherited FontChanged;
  Fonts.UpdateFonts;
end;

function TdxCustomListView.GetCurrentCursor(X, Y: Integer): TCursor;
begin
  Result := Controller.GetCursor(TPoint.Create(X, Y));
  if Result = crDefault then
    Result := inherited GetCurrentCursor(X, Y);
end;

function TdxCustomListView.GetScrollContentForegroundColor: TColor;
var
  AState: TdxGalleryItemViewState;
begin
  ZeroMemory(@AState, SizeOf(AState));
  AState.Enabled := True;
  Result := LookAndFeelPainter.GetGalleryItemCaptionTextColor(AState);
end;

function TdxCustomListView.HasScrollBarArea: Boolean;
begin
  Result := inherited HasScrollBarArea or (GetScrollbarMode = sbmHybrid);
end;

function TdxCustomListView.IsActive: Boolean;
begin
  Result := Focused or IsEditing;
end;

function TdxCustomListView.ColumnsShowing: Boolean;
begin
  Result := ViewStyle = TdxListViewStyle.Report;
end;

function TdxCustomListView.CreateFonts: TdxListViewFonts;
begin
  Result := TdxListViewFonts.Create(Self);
end;

function TdxCustomListView.CreateGroups: TdxListGroups;
begin
  Result := TdxListGroups.Create(Self, GetGroupClass);
end;

function TdxCustomListView.CreateImages: TdxListViewImageOptions;
begin
  Result := TdxListViewImageOptions.Create(Self);
end;

function TdxCustomListView.CreateItems: TdxListItems;
begin
  Result := TdxListItems.Create(Self);
end;

function TdxCustomListView.GetEditingControl: TWinControl;
begin
  Result := Self;
end;

procedure TdxCustomListView.DeleteItem(AItem: TdxListItem);
begin
  if (AItem <> nil) and (AItem <> TempItem) then
  begin
    if not IsDestroying then
    begin
      AItem.Focused := False;
      AItem.Selected := False;
    end;
    if Assigned(FOnDeletion) then
      FOnDeletion(Self, AItem);
    LayoutChanged;
  end;
end;

procedure TdxCustomListView.DoCancelEdit(Sender: TObject);
begin
  if Assigned(FOnCancelEdit) then
    FOnCancelEdit(Self);
end;

procedure TdxCustomListView.DoChange(AItem: TdxListItem; AChange: TdxListItemChange);
begin
  if ((not OwnerData) or (AChange = TdxListItemChange.State)) and Assigned(FOnChange) then
    FOnChange(Self, AItem, AChange);
end;

function TdxCustomListView.DoChanging(AItem: TdxListItem; AChange: TdxListItemChange): Boolean;
begin
  Result := True;
  if (not OwnerData) and Assigned(FOnChanging) then
    FOnChanging(Self, AItem, AChange, Result);
end;

procedure TdxCustomListView.DoColumnClick(AColumn: TdxListColumn);
begin
  if Assigned(FOnColumnClick) then
    FOnColumnClick(Self, AColumn);
end;

procedure TdxCustomListView.DoColumnDragged(AColumn: TdxListColumn);
begin
  if Assigned(FOnColumnDragged) then
    FOnColumnDragged(Self, AColumn);
end;

procedure TdxCustomListView.DoColumnPosChanged(AColumn: TdxListColumn);
begin
  if Assigned(FOnColumnPosChanged) then
    FOnColumnPosChanged(Self, AColumn);
end;

procedure TdxCustomListView.DoColumnRightClick(AColumn: TdxListColumn; APoint: TPoint);
begin
  if Assigned(FOnColumnRightClick) then
    FOnColumnRightClick(Self, AColumn, APoint);
end;

procedure TdxCustomListView.DoColumnSizeChanged(AColumn: TdxListColumn);
begin
  if Assigned(FOnColumnSizeChanged) then
    FOnColumnSizeChanged(Self, AColumn);
end;

procedure TdxCustomListView.DoEdited(AItem: TdxListItem; var ACaption: string);
begin
  if Assigned(FOnEdited) then
    FOnEdited(Self, AItem, ACaption);
end;

procedure TdxCustomListView.DoInfoTip(AItem: TdxListItem; var AInfoTip: string);
begin
  if Assigned(FOnInfoTip) then
    FOnInfoTip(Self, AItem, AInfoTip);
end;

procedure TdxCustomListView.DoSelectionChanged;
begin
  if Assigned(FOnSelectionChanged) then
    FOnSelectionChanged(Self);
end;

procedure TdxCustomListView.DoSelectItem(AItemIndex: Integer; ASelected: Boolean);
begin
  if Assigned(FOnSelectItem) then
    FOnSelectItem(Self, GetItem(AItemIndex), ASelected);
end;

procedure TdxCustomListView.DoViewStyleChanged;
begin
  if Assigned(FOnViewStyleChanged) then
    FOnViewStyleChanged(Self);
end;

procedure TdxCustomListView.DrawMultiSelection(const ABounds: TRect);
begin
  if ABounds.IsEqual(FDragSelectRectangle) then
    Exit;
  FDragSelectRectangle := ABounds;
  Repaint;
end;

function TdxCustomListView.GetGapBetweenItems: Integer;
begin
  case ViewStyle of
    TdxListViewStyle.Icon:
      Result := ViewStyleIcon.GapBetweenItems;
    TdxListViewStyle.List:
      Result := ViewStyleList.GapBetweenItems;
    else 
      Result := 1;
  end;
end;

function TdxCustomListView.GetItemAt(X, Y: Integer): TdxListItem;
begin
  Result := GetItemAtPos(TPoint.Create(X, Y));
end;

function TdxCustomListView.GetItemAtPos(const P: TPoint): TdxListItem;
var
  AViewInfo: TdxListItemCustomViewInfo;
begin
  if ViewInfo.GetItemAtPos(P, AViewInfo) then
    Result := AViewInfo.Item
  else
    Result := nil;
end;

function TdxCustomListView.GetItemCaptionTextColor: TColor;
begin
  Result := Fonts.Item.Color;
  if Result = clDefault then
    Result := LookAndFeelPainter.GetListViewItemTextColor([], ExplorerStyle);
end;

function TdxCustomListView.IsDropTargetItem(AItemIndex: Integer): Boolean;
begin
  Result := FDropTargetIndices.Contains(AItemIndex);
end;

function TdxCustomListView.IsHorizontalItemsArrangement: Boolean;
begin
  case ViewStyle of
    TdxListViewStyle.Icon:
      Result := ViewStyleIcon.Arrangement = TdxListIconsArrangement.Horizontal;
    TdxListViewStyle.SmallIcon:
      Result := ViewStyleSmallIcon.Arrangement = TdxListIconsArrangement.Horizontal;
  else 
    Result := False;
  end;
end;

procedure TdxCustomListView.InsertItem(AItem: TdxListItem);
begin
  if Assigned(FOnInsert) then
    FOnInsert(Self, AItem);
end;

function TdxCustomListView.IsItemSelected(AItem: TdxListItem): Boolean;
begin
  Result := Controller.IsItemSelected(AItem.Index);
end;

function TdxCustomListView.IsUpdateLocked: Boolean;
begin
  Result := (FLockCount > 0) or IsLoading or IsDestroying or CreatingWindow;
end;

procedure TdxCustomListView.RemoveItem(AItem: TdxListItem);
begin
  if FDeletingAllItems or IsDestroying then
    Exit;
  if FLastDropTarget = AItem then
    FLastDropTarget := nil;
  ValidateGroupItems;
end;

procedure TdxCustomListView.SetDropTargetItem(AItemIndex: Integer; AValue: Boolean);
var
  AIndex: Integer;
begin
  AIndex := FDropTargetIndices.IndexOf(AItemIndex);
  if (AIndex >= 0) <> AValue then
  begin
    if AValue then
      FDropTargetIndices.Add(AItemIndex)
    else
      FDropTargetIndices.Delete(AIndex);
    FDropTargetIndices.Sort;
    ViewInfo.InvalidateItem(AItemIndex);
  end;
end;

function TdxCustomListView.SupportsItemEnabledState: Boolean;
begin
  Result := True;
end;

procedure TdxCustomListView.ResetContent;
begin
  SetLeftTop(TPoint.Null);
end;

procedure TdxCustomListView.UpdateItems(AFirstIndex, ALastIndex: Integer);
begin
  LayoutChanged;
end;

procedure TdxCustomListView.ClearDropTargets;
begin
  FDropTargetIndices.Clear;
  FLastDropTarget := nil;
  Invalidate;
end;

procedure TdxCustomListView.ClearSelection;
begin
  if Controller <> nil then
    Controller.ClearSelection;
end;

procedure TdxCustomListView.DeleteSelected;
var
  I: Integer;
begin
  BeginUpdate;
  try
    for I := Items.Count - 1 downto 0 do
      if Items[I].Selected then
        Items[I].Delete;
  finally
    EndUpdate;
  end;
end;

procedure TdxCustomListView.SelectAll;
begin
  Controller.SelectAll;
end;

function TdxCustomListView.GetCount: Integer;
begin
  Result := Items.Count;
end;

function TdxCustomListView.FindCaption(AStartIndex: Integer; const AValue: string; APartial, AInclusive, AWrap: Boolean): TdxListItem;

   function Match(const ACaption: string): Boolean;
   begin
     if APartial then
       Result := TdxStringHelper.StartsWith(ACaption, AValue)
     else
       Result := SameText(ACaption, AValue);
   end;

const
  FindTextMap: array[Boolean] of TdxListItemFind = (TdxListItemFind.ExactString, TdxListItemFind.PartialString);
var
  I, AIndex: Integer;
  AItem: TdxListItem;
begin
  Result := nil;
  if (AValue = '') or not InRange(AStartIndex, 0, Items.Count - 1) then
    Exit;
  if OwnerData then
  begin
    AIndex := OwnerDataFind(FindTextMap[APartial], AValue, TPoint.Null, nil, AStartIndex, TdxListItemSearchDirection.All, AWrap);
    if InRange(AIndex, 0, Items.Count) then
      Exit(GetItem(AIndex));
  end
  else
  begin
    if AInclusive then
      Dec(AStartIndex);
    for I := AStartIndex + 1 to Items.Count - 1 do
    begin
      AItem := GetItem(I);
      if (AItem <> nil) and Match(AItem.Caption) then
      begin
        Result := AItem;
        Exit;
      end;
    end;
    if AWrap then
    begin
      if AInclusive then
        Inc(AStartIndex);
      for I := 0 to AStartIndex - 1 do
      begin
        AItem := GetItem(I);
        if (AItem <> nil) and Match(AItem.Caption) then
        begin
          Result := AItem;
          Exit;
        end;
      end;
    end;
  end;
end;

function TdxCustomListView.FindData(AStartIndex: Integer; AValue: TCustomData; AInclusive, AWrap: Boolean): TdxListItem;
var
  I, AIndex: Integer;
  AItem: TdxListItem;
begin
  Result := nil;
  if not InRange(AStartIndex, 0, Items.Count - 1) then
    Exit;
  if OwnerData then
  begin
    AIndex := OwnerDataFind(TdxListItemFind.Data, '', TPoint.Null, AValue, AStartIndex, TdxListItemSearchDirection.All, AWrap);
    if InRange(AIndex, 0, Items.Count) then
      Exit(GetItem(AIndex));
  end
  else
  begin
    if AInclusive then
      Dec(AStartIndex);
    for I := AStartIndex + 1 to Items.Count - 1 do
    begin
      AItem := GetItem(I);
      if (AItem <> nil) and (AItem.Data = AValue) then
      begin
        Result := AItem;
        Exit;
      end;
    end;
    if AWrap then
    begin
      if AInclusive then
        Inc(AStartIndex);
      for I := 0 to AStartIndex - 1 do
      begin
        AItem := GetItem(I);
        if (AItem <> nil) and (AItem.Data = AValue) then
        begin
          Result := AItem;
          Exit;
        end;
      end;
    end;
  end;
end;

procedure TdxCustomListView.UpdateGroups;
begin
  LayoutChanged;
end;

function TdxCustomListView.UseDisplayedItemsForBestFit: Boolean;
begin
  Result := OwnerData;
end;

procedure TdxCustomListView.ValidateGroupItems;
begin
  if GroupView then
    Groups.RebuildItems;
end;

procedure TdxCustomListView.ViewStyleChanged;
begin
  DoViewStyleChanged;
end;

function TdxCustomListView.GetItem(AIndex: Integer): TdxListItem;
var
  Request: TdxListItemRequest;
begin
  if OwnerData then
  begin
    if AIndex < 0 then
      Exit(nil)
    else
    begin
      Inc(FLockCount);
      try
        Request := [TdxListItemRequests.Text, TdxListItemRequests.Image, TdxListItemRequests.Param,
          TdxListItemRequests.State, TdxListItemRequests.Indent];
        FTempItem.FIndex := AIndex;
        FTempItem.FData := nil;
        FTempItem.FSubItems.Clear;
        OwnerDataFetch(FTempItem, Request);
      finally
        Dec(FLockCount);
      end;
    end;
    Result := FTempItem;
  end
  else
  begin
    Items.ValidateIndices;
    Result := Items[AIndex];
  end;
end;

function TdxCustomListView.OwnerDataFetch(AItem: TdxListItem; ARequest: TdxListItemRequest): Boolean;
begin
  Result := Assigned(FOnData);
  if Result then
    FOnData(Self, AItem);
end;

function TdxCustomListView.OwnerDataFind(AFind: TdxListItemFind; const AFindString: string;
  const AFindPosition: TPoint; AFindData: TCustomData; AStartIndex: Integer;
  ADirection: TdxListItemSearchDirection; AWrap: Boolean): Integer;
begin
  Result := -1;
  if Assigned(FOnDataFind) then
    FOnDataFind(Self, AFind, AFindString, AFindPosition, AFindData, AStartIndex, ADirection, AWrap, Result);
end;

function TdxCustomListView.OwnerDataHint(AStartIndex, AEndIndex: Integer): Boolean;
begin
  Result :=  Assigned(FOnDataHint);
  if Result then
    FOnDataHint(Self, AStartIndex, AEndIndex);
end;

function TdxCustomListView.CanEdit(AItem: TdxListItem): Boolean;
begin
  Result := not ReadOnly and (not SupportsItemEnabledState or AItem.Enabled);
  if Assigned(FOnEditing) then
    FOnEditing(Self, AItem, Result);

  if Assigned(FOnChanging) then
    FOnChanging(Self, AItem, TdxListItemChange.Text, Result);
end;

procedure TdxCustomListView.Edit(AItemIndex: Integer; const AText: string);
var
  ABounds: TRect;
  AItemViewInfo: TdxListItemCustomViewInfo;
begin
  Controller.FocusedItemIndex := AItemIndex;
  if ViewInfo.FindItemViewInfo(AItemIndex, AItemViewInfo) then
  begin
    ABounds := AItemViewInfo.TextAreaBounds;
    if ViewStyle = TdxListViewStyle.Icon then
    begin
      ABounds.Left := AItemViewInfo.Bounds.Left;
      ABounds.Right := AItemViewInfo.Bounds.Right;
    end;
    ShowInplaceEdit(AItemIndex, ABounds, AText);
    FEditingItemIndex := AItemIndex;
  end;
end;

function TdxCustomListView.GetEditingText(AItem: TdxListItem): string;
begin
  Result := AItem.Caption;
end;

procedure TdxCustomListView.InplaceEditKeyPress(Sender: TObject; var Key: Char);
begin
end;

function TdxCustomListView.IsEditingItem(AItemIndex: Integer): Boolean;
begin
  Result := IsEditing and (FEditingItemIndex = AItemIndex);
end;

function TdxCustomListView.IsEditing: Boolean;
begin
  Result := HandleAllocated and (FEditingItemIndex >= 0);
end;

function TdxCustomListView.StartItemCaptionEditing(AItemIndex: Integer): Boolean;
var
  AItem: TdxListItem;
begin
  if AItemIndex < 0 then
    Exit(False);
  AItem := GetItem(AItemIndex);
  Result := CanEdit(AItem);
  if Result then
    Edit(AItemIndex, GetEditingText(AItem));
end;

procedure TdxCustomListView.FinishItemCaptionEditing(AAccept: Boolean = True);
var
  ACaption: string;
  AItem: TdxListItem;
begin
  if IsEditing then
  try
    if AAccept then
    begin
      ACaption := InplaceEdit.Value;
      AItem := EditingItem;
      DoEdited(AItem, ACaption);
      AItem.Caption := ACaption;
    end;
  finally
    FEditingItemIndex := -1;
    InplaceEdit.Hide;
    Controller.CancelEdit;
    if not AAccept then
      DoCancelEdit(Self);
    Invalidate;
  end;
end;

function TdxCustomListView.AreItemsStored: Boolean;
begin
  Result := not OwnerData;
end;

function TdxCustomListView.GetDropTarget: TdxListItem;
begin
  if FDropTargetIndices.Count = 0 then
    Result := nil
  else
    Result := GetItem(FDropTargetIndices.First);
end;

function TdxCustomListView.GetEditingItem: TdxListItem;
begin
  if FEditingItemIndex < 0 then
    Result := nil
  else
    Result := GetItem(FEditingItemIndex);
end;

function TdxCustomListView.GetFocusedItem: TdxListItem;
begin
  if Controller.FocusedItemIndex < 0 then
    Result := nil
  else
    Result := GetItem(Controller.FocusedItemIndex);
end;

function TdxCustomListView.GetInplaceEdit: IdxInplaceEdit;
begin
  Result := FInplaceEditingController.InplaceEdit;
end;

function TdxCustomListView.GetSelectedItemCount: Integer;
begin
  Result := Controller.SelectedIndices.Count;
end;

function TdxCustomListView.GetUseLightBorders: Boolean;
begin
  Result := TdxVisualRefinements.LightBorders;
end;

function TdxCustomListView.GetSelectedItem(Index: Integer): TdxListItem;
begin
  Result := GetItem(Controller.SelectedIndices[Index]);
end;

procedure TdxCustomListView.SetMultiSelect(AValue: Boolean);
begin
  if FMultiSelect <> AValue then
  begin
    FMultiSelect := AValue;
    if not AValue then
      Controller.ClearSelection;
    LayoutChanged;
  end;
end;

procedure TdxCustomListView.SetOwnerData(AValue: Boolean);
begin
  if FOwnerData <> AValue then
  begin
    FOwnerData := AValue;
    if AValue then
      Items.Clear;
  end;
end;

procedure TdxCustomListView.SetReadOnly(AValue: Boolean);
begin
  if FReadOnly <> AValue then
  begin
    FReadOnly := AValue;
    if AValue then
      FinishItemCaptionEditing(False);
  end;
end;

procedure TdxCustomListView.SetCheckboxes(AValue: Boolean);
begin
  if FCheckboxes <> AValue then
  begin
    FCheckboxes := AValue;
    if Checkboxes then
      ImageOptions.StateImages := nil;
    LayoutChanged;
  end;
end;

procedure TdxCustomListView.SetSortType(AValue: TdxListViewSortType);
begin
  if FLockCount > 0 then
  begin
    FSavedSort := AValue;
    Exit;
  end;
  if FSortType <> AValue then
  begin
    FSortType := AValue;
    CheckSorting(nil);
  end;
end;

procedure TdxCustomListView.SetExplorerStyle(AValue: Boolean);
begin
  if FExplorerStyle <> AValue then
  begin
    FExplorerStyle := AValue;
    LayoutChanged;
  end;
end;

procedure TdxCustomListView.SetPaddingOptions(const AValue: TdxListViewPaddingOptions);
begin
  FPaddingOptions.Assign(AValue);
end;

procedure TdxCustomListView.SetGroupView(AValue: Boolean);
begin
  if FGroupView <> AValue then
  begin
    FGroupView := AValue;
    BeginUpdate;
    try
      FSortType := TdxListViewSortType.None;
      SetLeftTop(TPoint.Null, False);
      Groups.RebuildItems;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TdxCustomListView.SetColumns(const AValue: TdxListColumns);
begin
  FColumns.Assign(AValue);
end;

procedure TdxCustomListView.SetDropTarget(AValue: TdxListItem);
begin
  if AValue <> nil then
    SetDropTargetItem(AValue.Index, True)
  else
    if FDropTargetIndices.Count > 0 then
      SetDropTargetItem(FDropTargetIndices.First, False);
end;

procedure TdxCustomListView.SetEmptyText(const AValue: string);
begin
  if FEmptyText <> AValue then
  begin
    FEmptyText := AValue;
    if Items.Count = 0 then
      LayoutChanged;
  end;
end;

procedure TdxCustomListView.SetFocusedItem(AItem: TdxListItem);
begin
  if AItem <> nil then
    AItem.Focused := True
  else
    Controller.FocusedItemIndex := -1;
end;

procedure TdxCustomListView.SetFonts(const AValue: TdxListViewFonts);
begin
  FFonts.Assign(AValue);
end;

procedure TdxCustomListView.SetGroups(const AValue: TdxListGroups);
begin
  FGroups.Assign(AValue);
end;

procedure TdxCustomListView.SetImageOptions(const AValue: TdxListViewImageOptions);
begin
  FImageOptions.Assign(AValue);
end;

procedure TdxCustomListView.SetItems(const AValue: TdxListItems);
begin
  FItems.Assign(AValue);
end;

function TdxCustomListView.CreateHintHelper: TdxListViewHintHelper;
begin
  Result := TdxListViewHintHelper.Create(Self);
end;

function TdxCustomListView.CreateIconOptions: TdxListViewIconOptions;
begin
  Result := TdxListViewIconOptions.Create(Self);
end;

function TdxCustomListView.CreateListOptions: TdxListViewListOptions;
begin
  Result := TdxListViewListOptions.Create(Self);
end;

function TdxCustomListView.CreatePaddingOptions: TdxListViewPaddingOptions;
begin
  Result := TdxListViewPaddingOptions.Create(Self);
end;

function TdxCustomListView.CreateReportOptions: TdxListViewReportOptions;
begin
  Result := TdxListViewReportOptions.Create(Self);
end;

function TdxCustomListView.CreateSmallIconOptions: TdxListViewSmallIconOptions;
begin
  Result := TdxListViewSmallIconOptions.Create(Self);
end;

procedure TdxCustomListView.CreateViewStyleOptions;
begin
  FViewStyleIcon := CreateIconOptions;
  FViewStyleList := CreateListOptions;
  FViewStyleReport := CreateReportOptions;
  FViewStyleSmallIcon := CreateSmallIconOptions;
end;

procedure TdxCustomListView.DestroyViewStyleOptions;
begin
  FreeAndNil(FViewStyleIcon);
  FreeAndNil(FViewStyleList);
  FreeAndNil(FViewStyleReport);
  FreeAndNil(FViewStyleSmallIcon);
end;

function TdxCustomListView.CheckSorting(AGroup: TdxListGroup): Boolean;
begin
  Result := ((SortType in [TdxListViewSortType.Data, TdxListViewSortType.Both]) and Assigned(OnCompare)) or
    (SortType in [TdxListViewSortType.Text, TdxListViewSortType.Both]);
  if Result then
  begin
    if AGroup = nil then
      AlphaSort
    else
      AGroup.AlphaSort;
  end;
end;

procedure TdxCustomListView.ClearItems;
begin
  DeletingAllItems := True;
  try
    if Controller <> nil then
      Controller.ResetContent;
    Items.List.Clear;
  finally
    DeletingAllItems := False;
    Groups.RebuildItems;
  end;
  ResetContent;
end;

procedure TdxCustomListView.SetViewStyle(const AValue: TdxListViewStyle);
begin
  if FViewStyle <> AValue then
  begin
    BeginUpdate;
    try
      FViewStyle := AValue;
      SetLeftTop(TPoint.Null);
      FinishItemCaptionEditing(True);
      FInplaceEditingController.DestroyEdit;
      ViewStyleChanged;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TdxCustomListView.SetViewStyleIcon(const AValue: TdxListViewIconOptions);
begin
  FViewStyleIcon.Assign(AValue);
end;

procedure TdxCustomListView.SetViewStyleList(const AValue: TdxListViewListOptions);
begin
  FViewStyleList.Assign(AValue);
end;

procedure TdxCustomListView.SetViewStyleReport(const AValue: TdxListViewReportOptions);
begin
  FViewStyleReport.Assign(AValue);
end;

procedure TdxCustomListView.SetViewStyleSmallIcon(const AValue: TdxListViewSmallIconOptions);
begin
  FViewStyleSmallIcon.Assign(AValue);
end;

procedure TdxCustomListView.CMHintShow(var Message: TCMHintShow);
var
  AItemViewInfo: TdxListItemCustomViewInfo;
  AItem: TdxListItem;
begin
  if ShowItemHints and not IsDragging then
  begin
    if ViewInfo.GetItemAtPos(Message.HintInfo.CursorPos, AItemViewInfo) then
    begin
      AItem := AItemViewInfo.Item;
      if AItem.Enabled and (AItem.Hint <> '') then
      begin
        Message.HintInfo.CursorRect := AItemViewInfo.Bounds;
        Message.HintInfo.HintStr := AItem.Hint;
        Message.Result := 0;
      end;
    end;
  end;
end;

function TdxCustomListView.GetViewStyleReport: TdxListViewReportOptions;
begin
  Result := FViewStyleReport;
end;

function TdxCustomListView.GetViewStyleSmallIcon: TdxListViewSmallIconOptions;
begin
  Result := FViewStyleSmallIcon;
end;

{ TdxListViewCellViewParams }

destructor TdxListViewCellViewParams.Destroy;
begin
  FreeAndNil(Font);
  inherited Destroy;
end;

function TdxListViewCellViewParams.GetNonTextWidth: Integer;
begin
  Result := Padding.Width;
  if GlyphsAreaSize.cx > 0 then
    Inc(Result, GlyphsAreaSize.cx + GlyphIndent.cx);
end;

function TdxListViewCellViewParams.GetReportNonTextWidth(ACheckState, ACheckGlyph: Boolean): Integer;
begin
  Result := Padding.Width;
  if ACheckState and (StateGlyphSize.cx > 0) then
    Inc(Result, StateGlyphSize.cx + GlyphIndent.cx);
  if ACheckGlyph and (GlyphSize.cx > 0) then
    Inc(Result, GlyphSize.cx + GlyphIndent.cx);
end;

{ TdxKeyboard }

class function TdxKeyboard.CheckIsKeyPressed(const Index: Integer): Boolean;
begin
  Result := GetAsyncKeyState(Index) < 0;
end;

{ TdxListViewInplaceEditingController }

constructor TdxListViewInplaceEditingController.Create(AListView: TdxCustomListView);
begin
  inherited Create;
  FListView := AListView;
end;

procedure TdxListViewInplaceEditingController.InplaceEditKeyPress(Sender: TObject; var Key: Char);
begin
  FListView.InplaceEditKeyPress(Sender, Key);
end;

function TdxListViewInplaceEditingController.IsMultiline: Boolean;
begin
  Result := FListView.ViewStyle = TdxListViewStyle.Icon;
end;

function TdxListViewInplaceEditingController.IsReadOnly: Boolean;
begin
  Result := FListView.ReadOnly;
end;

procedure TdxListViewInplaceEditingController.StartItemCaptionEditing;
begin
  FListView.StartItemCaptionEditing(FListView.Controller.EditingItemIndex)
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  RegisterClasses([TdxListItem, TdxListGroup, TdxListColumn]);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
end.
