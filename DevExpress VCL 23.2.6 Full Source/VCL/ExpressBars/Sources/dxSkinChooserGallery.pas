{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressBars components                                   }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSBARS AND ALL ACCOMPANYING VCL  }
{   CONTROLS AS PART OF AN EXECUTABLE PROGRAM ONLY.                  }
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

unit dxSkinChooserGallery;

{$I cxVer.inc}


interface

uses
  Windows, Messages, Classes, Contnrs, SysUtils, Graphics, Forms, Types, Generics.Collections, Generics.Defaults,
  dxCore, dxGallery, dxRibbonGallery, cxLookAndFeelPainters, dxSkinsCore, cxClasses, cxLookAndFeels,
  dxBar, dxSkinInfo, cxGeometry, dxDPIAwareUtils, dxGDIPlusClasses, dxSVGImage, dxGenerics,
  dxRibbon, cxBarEditItem, cxButtonEdit, cxEdit, cxGraphics, dxSkinsStrs,
  dxCoreGraphics, dxBarStrs, dxCoreClasses, dxTypeHelpers, dxScreenTip, dxSkinNames;

type

{$REGION 'ChooserGalleryItem'}

  TdxCustomChooserGalleryItem = class;
  TdxSkinChooserGalleryItem = class;
  TdxSkinPaletteChooserGalleryItem = class;
  TdxSkinChooserGalleryGroup = class;
  TdxSkinChooserGallerySkinChangedEvent = procedure (Sender: TObject; const ASkinName: string) of object;
  TdxSkinChooserGalleryPaletteChangedEvent = procedure (Sender: TObject; const ASkinName, APaletteName: string) of object;
  TdxSkinChooserGalleryAddEvent = procedure (Sender: TObject; ASkinDetails: TdxSkinDetails; var AAccepted: Boolean) of object;
  TdxSkinPaletteChooserGalleryAddEvent = procedure (Sender: TObject; const ASkinName: string; AColorPalette: TdxSkinColorPalette; var AAccepted: Boolean) of object;
  TdxSkinPaletteChooserGalleryPopulateEvent = procedure (Sender: TObject; const ASkinName: string; var AHandled: Boolean) of object;

{$REGION 'Options'}

  { TdxCustomChooserGalleryOptions }

  TdxCustomChooserGalleryOptions = class(TdxCustomRibbonGalleryOptions)
  strict private
    FGroupsHeaderHeight: Integer;
    FMaxDropDownHeight: Integer;
    FMinDropDownHeight: Integer;
    FMinDropDownWidth: Integer;
    procedure SetGroupsHeaderHeight(AValue: Integer);
    procedure SetMaxDropDownHeight(AValue: Integer);
    procedure SetMinDropDownHeight(AValue: Integer);
    procedure SetMinDropDownWidth(AValue: Integer);
  protected
    procedure ChangeScale(M: Integer; D: Integer); override;
    function IsItemImagePositionStored: Boolean; override;
    property GroupsHeaderHeight: Integer read FGroupsHeaderHeight write SetGroupsHeaderHeight default 0;
    property MinDropDownWidth: Integer read FMinDropDownWidth write SetMinDropDownWidth default -1;
    property MinDropDownHeight: Integer read FMinDropDownHeight write SetMinDropDownHeight default -1;
    property MaxDropDownHeight: Integer read FMaxDropDownHeight write SetMaxDropDownHeight default -1;
  public
    constructor Create(AOwner: TdxCustomRibbonGalleryItem); override;
    procedure Assign(ASource: TPersistent); override;
  published
    property ColumnCount;
    property ItemAllowDeselect;
    property ItemHintSource;
    property ItemImagePosition;
    property ShowItemHint stored False; // deprecated
    property SpaceAfterGroupHeader;
    property SpaceBetweenGroups;
    property SpaceBetweenItemCaptionAndDescription;
    property SpaceBetweenItemImageAndText;
    property SpaceBetweenItemsAndBorder;
    property SpaceBetweenItemsHorizontally;
    property SpaceBetweenItemsVertically;
  end;

  { TdxSkinPaletteChooserGalleryOptions }

  TdxSkinPaletteChooserGalleryOptions = class(TdxCustomChooserGalleryOptions); // for internal use

  { TdxSkinChooserGalleryOptions }

  TdxSkinChooserGalleryOptions = class(TdxCustomChooserGalleryOptions)
  published
    property ItemImageSize;
  end;

{$ENDREGION}

{$REGION 'CustomGroupItem'}

  { TdxCustomChooserGalleryGroupItem }

  TdxCustomChooserGalleryGroupItem = class abstract(TdxRibbonGalleryGroupItem)
  strict private
    FOriginalIndex: Integer;
    FSkinName: string;
  protected
    function GetItemName: string; virtual; abstract;
    function GetMinItemSize(AIsInRibbon: Boolean): TSize; override;

    property OriginalIndex: Integer read FOriginalIndex write FOriginalIndex;
    property SkinName: string read FSkinName write FSkinName;
  public
    constructor Create(AOwner: TComponent); override;
    property GlyphInDropDown;
  end;

{$ENDREGION}

{$REGION 'CustomGroup'}

  { TdxCustomChooserGalleryGroup }

  TdxCustomChooserGalleryGroup = class(TdxRibbonGalleryGroup)
  protected
    function GetGalleryItem: TdxCustomChooserGalleryItem;
    procedure SetVisible(AValue: Boolean); override;
  end;

{$ENDREGION}

{$REGION 'CustomBarItem'}

  { TdxCustomChooserGalleryItem }

  TdxCustomChooserGalleryItem = class abstract(TdxCustomRibbonGalleryItem,
    IcxLookAndFeelPainterListener)
  strict private
    FInternal: Boolean;
    FGroupVisibleChanging: Boolean;
    FPopulateGalleryNeeded: Boolean;
    FIsGalleryPopulating: Boolean;
    FLockPopulateGalleryCount: Integer;
    FIsGalleryPopulated: Boolean;
    FUseLocalizedNames: Boolean;
    FOnGroupVisibleChanged: TdxGalleryGroupEvent;
    function GetSkinManager: IdxSkinManager;
    function CanAutoPopulateGallery: Boolean;
    function GetSelectedGroupItemName: string;
    procedure SetSelectedGroupItemName(const AValue: string);
    function GetSelectedGroupItem: TdxCustomChooserGalleryGroupItem;
    procedure SetSelectedGroupItem(AValue: TdxCustomChooserGalleryGroupItem);
  protected
    procedure AfterLoadedInitialize; override;
    function CanPopulateGallery: Boolean; virtual;
    function UseGroupItemSizeInRibbon: Boolean; override;
    procedure ChangeScale(M, D: Integer); override;
    procedure DoAfterPopulate; virtual;
    procedure DoBeforePopulate; virtual;
    procedure DoSelectedGroupItemChanged(AItem: TdxRibbonGalleryGroupItem); override; final;
    procedure DoItemSelectedChanged(AItem: TdxCustomChooserGalleryGroupItem; const AName: string); virtual;
    procedure DoPopulateGallery; virtual;
    function FindItemByName(const AName: string; out AItem: TdxCustomChooserGalleryGroupItem): Boolean;
    procedure GroupVisibleChanged(AGroup: TdxCustomChooserGalleryGroup); virtual;
    procedure DoGroupVisibleChanged(AGroup: TdxCustomChooserGalleryGroup);
    function GetGalleryGroupClass: TdxRibbonGalleryGroupClass; override;
    function FindFirstBestItem: TdxCustomChooserGalleryGroupItem; virtual;
    function GetValidGroupIndexByName(const AName: string): Integer;
    procedure LinksChanged(AItemLink: TdxBarItemLink; AAction: TListNotification); override;
    procedure SetBarManager(AValue: TdxBarManager); override;

    // IcxLookAndFeelPainterListener
    procedure IcxLookAndFeelPainterListener.PainterAdded = PainterChanged;
    procedure IcxLookAndFeelPainterListener.PainterRemoved = PainterChanged;
    procedure PainterChanged(APainter: TcxCustomLookAndFeelPainter);


    procedure GetVisibleGroups(AList: TStrings);
    procedure SetGroupsVisible(AList: TStrings);
    function GetGroupName(AGroup: TdxRibbonGalleryGroup): string; virtual;
    function EqualGroupName(AGroup: TdxRibbonGalleryGroup; const AName: string): Boolean; virtual;
    procedure PopulateGalleryBeginUpdate;
    procedure PopulateGalleryEndUpdate(ACancel: Boolean = False);
    property LockPopulateGalleryCount: Integer read FLockPopulateGalleryCount;

    property Internal: Boolean read FInternal write FInternal;
    property UseLocalizedNames: Boolean read FUseLocalizedNames write FUseLocalizedNames;
    property IsGalleryPopulated: Boolean read FIsGalleryPopulated;
    property IsGalleryPopulating: Boolean read FIsGalleryPopulating;
    property SelectedGroupItem: TdxCustomChooserGalleryGroupItem read GetSelectedGroupItem write SetSelectedGroupItem;
    property SelectedGroupItemName: string read GetSelectedGroupItemName write SetSelectedGroupItemName;
    property SkinManager: IdxSkinManager read GetSkinManager;
    property OnGroupVisibleChanged: TdxGalleryGroupEvent read FOnGroupVisibleChanged write FOnGroupVisibleChanged;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure PopulateGallery;
  end;
{$ENDREGION}

{$REGION 'CustomItemControl'}

  { TdxCustomChooserGalleryControl }

  TdxCustomChooserGalleryControl = class(TdxRibbonGalleryControl)
  protected
    function CanDropDown: Boolean; override;
  end;

{$ENDREGION}

{$REGION 'PaletteGroupItem'}

  { TdxSkinPaletteChooserGalleryGroupItem }

  TdxSkinPaletteChooserGalleryGroupItem = class(TdxCustomChooserGalleryGroupItem)  // for internal use
  strict private
    FPaletteName: string;
    procedure AssignGlyph(ADestGlyph, ASourceTemplate: TdxSmartGlyph; APalette: TdxSkinColorPalette; ASize: TSize; ATargetDPI: Integer);
    function GetGalleryItem: TdxSkinPaletteChooserGalleryItem;
    procedure GetActualGlyphsSize(const ADefaultSizeFor96DPI: TSize; out ATargetDPI: Integer; out ASizeInRibbon, ASizeInMenu: TSize);
  protected
    function DontUseRibbonGlyphInDropDown: Boolean; override;
    function GetItemName: string; override;
    procedure UpdateGlyphs(ASourceTemplate: TdxSmartGlyph; APalette: TdxSkinColorPalette);

    property GalleryItem: TdxSkinPaletteChooserGalleryItem read GetGalleryItem;
  public
    property PaletteName: string read FPaletteName write FPaletteName;
    property SkinName;
  end;

{$ENDREGION}

{$REGION 'PaletteGroupEmptyItem'}

  { TdxSkinPaletteChooserGalleryGroupEmptyItem }

  TdxSkinPaletteChooserGalleryGroupEmptyItem = class(TdxSkinPaletteChooserGalleryGroupItem) // for internal use
  protected
    function ShowDescriptionInRibbon: Boolean; override;
    function GetMinItemSize(AIsInRibbon: Boolean): TSize; override;
  end;

{$ENDREGION}

{$REGION 'PaletteBarItem'}

  { TdxSkinPaletteChooserGalleryItem }

  TdxSkinPaletteChooserGalleryItem = class(TdxCustomChooserGalleryItem) // for internal use
  strict private
    FGeneralPaletteGlyph: TdxSmartGlyph;
    FWXIPaletteGlyph: TdxSmartGlyph;
    FPaletteIconSizeInMenu: TSize;
    FPaletteIconSizeInRibbon: TSize;
    FPaletteIconVisibleInMenu: Boolean;
    FPaletteIconVisibleInRibbon: Boolean;    
    FOnAddPalette: TdxSkinPaletteChooserGalleryAddEvent;
    FOnPaletteChanged: TdxSkinChooserGalleryPaletteChangedEvent;
    FOnPopulate: TdxSkinPaletteChooserGalleryPopulateEvent;
    function CreateTemplateGlyph(const AResName: string): TdxSmartGlyph;
    function GetGalleryOptions: TdxSkinPaletteChooserGalleryOptions;
    function GetGeneralPaletteGlyph: TdxSmartGlyph;
    function GetWXIPaletteGlyph: TdxSmartGlyph;
    function GetScaleFactor: TdxScaleFactor;
    function GetSelectedGroupItem: TdxSkinPaletteChooserGalleryGroupItem;
    function GetSelectedPaletteName: string;
    function IsWXIBasedSkin(const ASkinName: string): Boolean;
    procedure SetGalleryOptions(AValue: TdxSkinPaletteChooserGalleryOptions);
    procedure SetSelectedGroupItem(AValue: TdxSkinPaletteChooserGalleryGroupItem);
    procedure SetSelectedPaletteName(const AValue: string);
  protected
    function CanAddPalette(const ASkinName: string; AColorPalette: TdxSkinColorPalette): Boolean; virtual;
    procedure ChangeScale(M, D: Integer); override;
    procedure DoItemSelectedChanged(AItem: TdxCustomChooserGalleryGroupItem; const AName: string); override;
    function DoPopulate(const ASkinName: string): Boolean; virtual;
    procedure DoPopulateGallery; override;
    procedure AddEmptyItem(const ACaption, ADescription: string);
    function GetErrorCanPlaceText: string; override;
    function GetFirstPaletteName: string;
    function GetGalleryOptionsClass: TCustomdxRibbonGalleryOptionsClass; override;
    function GetGroupItemClass: TdxGalleryItemClass; override;
    function GetTemplateGlyphBySkinName(const ASkinName: string): TdxSmartGlyph;
    procedure UpdatePaletteItemGlyphs;
    class function GetNewCaption: string; override;



    function AddPalette(const ASkinName, APaletteName, APaletteGroupName: string): TdxSkinPaletteChooserGalleryGroupItem; overload;
    function AddPalette(const ASkinName: string; APalette: TdxSkinColorPalette): TdxSkinPaletteChooserGalleryGroupItem; overload;
    function FindPalette(const APaletteName: string; out AItem: TdxSkinPaletteChooserGalleryGroupItem): Boolean;
    procedure SetPaletteImageParameters(const AIconSizeInRibbon, AIconSizeInMenu: TSize; AIconVisibleInRibbon, AIconVisibleInMenu: Boolean);

    property ScaleFactor: TdxScaleFactor read GetScaleFactor;

    property GalleryOptions: TdxSkinPaletteChooserGalleryOptions read GetGalleryOptions write SetGalleryOptions;
    property PaletteIconSizeInMenu: TSize read FPaletteIconSizeInMenu;
    property PaletteIconSizeInRibbon: TSize read FPaletteIconSizeInRibbon;
    property PaletteIconVisibleInMenu: Boolean read FPaletteIconVisibleInMenu;
    property PaletteIconVisibleInRibbon: Boolean read FPaletteIconVisibleInRibbon;
    property SelectedPaletteName: string read GetSelectedPaletteName write SetSelectedPaletteName;
    property SelectedGroupItem: TdxSkinPaletteChooserGalleryGroupItem read GetSelectedGroupItem write SetSelectedGroupItem;
    property OnAddPalette: TdxSkinPaletteChooserGalleryAddEvent read FOnAddPalette write FOnAddPalette;
    property OnPaletteChanged: TdxSkinChooserGalleryPaletteChangedEvent read FOnPaletteChanged write FOnPaletteChanged;
    property OnPopulate: TdxSkinPaletteChooserGalleryPopulateEvent read FOnPopulate write FOnPopulate;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

{$ENDREGION}

{$REGION 'SkinGroupItem'}

  { TdxSkinChooserGalleryGroupItem }

  TdxSkinChooserGalleryGroupItem = class(TdxCustomChooserGalleryGroupItem)
  strict private
    FLookAndFeelStyle: TcxLookAndFeelStyle;
    FSaveGroup: TdxRibbonGalleryGroup;
    FSkinResInstance: HINST;
    FSkinResName: string;
    FVisible: Boolean;
    function GetHiddenGroup: TdxRibbonGalleryGroup;
    procedure SetVisible(AValue: Boolean);
    procedure Hide;
    procedure Show;
    function GetGroup: TdxSkinChooserGalleryGroup;
  protected
    function GetItemName: string; override;

    property Visible: Boolean read FVisible write SetVisible;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ApplyToLookAndFeel(ALookAndFeel: TcxLookAndFeel);
    procedure ApplyToRootLookAndFeel;

    property Group: TdxSkinChooserGalleryGroup read GetGroup;
    property LookAndFeelStyle: TcxLookAndFeelStyle read FLookAndFeelStyle write FLookAndFeelStyle;
    property SkinName;
    property SkinResInstance: HINST read FSkinResInstance write FSkinResInstance;
    property SkinResName: string read FSkinResName write FSkinResName;
  end;

{$ENDREGION}

{$REGION 'SkinGroup'}

  { TdxSkinChooserGalleryGroup }

  TdxSkinChooserGalleryGroup = class(TdxCustomChooserGalleryGroup)
  strict private
    FGroupID: string;
  protected
    property GroupID: string read FGroupID write FGroupID;
  end;

{$ENDREGION}

{$REGION 'SkinBarItem'}

  { TdxSkinChooserGalleryItem }

  TdxSkinChooserGalleryItem = class(TdxCustomChooserGalleryItem)
  strict private
    FHiddenGroup: TdxRibbonGalleryGroup;
    FSkinIconSize: TdxSkinIconSize;
    FSkinIconSizeInDropDown: TdxSkinIconSize;
    FVisibleLookAndFeelStyles: TcxLookAndFeelStyles;
    FOnAddSkin: TdxSkinChooserGalleryAddEvent;
    FOnSkinChanged: TdxSkinChooserGallerySkinChangedEvent;
    FOnPopulate: TNotifyEvent;
    function GetGalleryOptions: TdxSkinChooserGalleryOptions;
    function GetSelectedGroupItem: TdxSkinChooserGalleryGroupItem;
    function GetSelectedSkinName: string;
    function IsSkinIconSizeInDropDownStored: Boolean;
    function IsSkinIconSizeStored: Boolean;
    procedure SetGalleryOptions(AValue: TdxSkinChooserGalleryOptions);
    procedure SetSelectedGroupItem(AValue: TdxSkinChooserGalleryGroupItem);
    procedure SetSelectedSkinName(const AValue: string);
    procedure SetSkinIconSize(AValue: TdxSkinIconSize);
    procedure SetSkinIconSizeInDropDown(AValue: TdxSkinIconSize);
    procedure SetVisibleLookAndFeelStyles(AValue: TcxLookAndFeelStyles);
    function InternalFiltering(APainter: TcxCustomLookAndFeelPainter; ASkinDetails: TdxSkinDetails): Boolean;
  protected
    function CanAddSkin(APainter: TcxCustomLookAndFeelPainter; ASkinDetails: TdxSkinDetails): Boolean; virtual;
    function CanShowGroupInFilterMenu(AGroupIndex: Integer; AIgnoreVisibleProperty: Boolean = False): Boolean; override;
    procedure DoItemSelectedChanged(AItem: TdxCustomChooserGalleryGroupItem; const AName: string); override;
    function DoPopulate: Boolean; virtual;
    procedure DoPopulateGallery; override;
    function GetErrorCanPlaceText: string; override;
    function GetGalleryOptionsClass: TCustomdxRibbonGalleryOptionsClass; override;
    function GetGroupItemClass: TdxGalleryItemClass; override;
    function GetGalleryGroupClass: TdxRibbonGalleryGroupClass; override;
    function GetMaxDropDownGalleryControlSize: TSize; override;
    function GetMinDropDownGalleryControlSize: TSize; override;
    function IgnoreHeaderForGroupVisibility: Boolean; override;
    function FindFirstBestItem: TdxCustomChooserGalleryGroupItem; override;
    function GetGroupName(AGroup: TdxRibbonGalleryGroup): string; override;
    function EqualGroupName(AGroup: TdxRibbonGalleryGroup; const AName: string): Boolean; override;
    class function GetNewCaption: string; override;

    function GetFirstSkinName: string;
    procedure ItemsFilter(const ASourceText: string);
    procedure ShowPopupGroupFilter(const AScreenPoint: TPoint);

    property HiddenGroup: TdxRibbonGalleryGroup read FHiddenGroup;
    property OnAddSkin: TdxSkinChooserGalleryAddEvent read FOnAddSkin write FOnAddSkin;
  public
    constructor Create(AOwner: TComponent); override;
    function AddSkin(ASkinDetails: TdxSkinDetails): TdxSkinChooserGalleryGroupItem; overload;
    function AddSkin(const ASkinName, AGroupName: string): TdxSkinChooserGalleryGroupItem; overload;
    procedure AddSkinsFromFile(const AFileName: string);
    procedure AddSkinsFromResource(AInstance: HINST; const AResourceName: string);
    procedure AddSkinsFromResources(AInstance: HINST);
    procedure AddSkinsFromStream(AStream: TStream; const ASkinResName: string; ASkinResInstance: HINST);
    function FindSkin(const ASkinName: string; out AItem: TdxSkinChooserGalleryGroupItem): Boolean;

    property SelectedGroupItem: TdxSkinChooserGalleryGroupItem read GetSelectedGroupItem write SetSelectedGroupItem;
    property SelectedSkinName: string read GetSelectedSkinName write SetSelectedSkinName;
  published
    property GalleryOptions: TdxSkinChooserGalleryOptions read GetGalleryOptions write SetGalleryOptions;
    property SkinIconSize: TdxSkinIconSize read FSkinIconSize write SetSkinIconSize stored IsSkinIconSizeStored;
    property SkinIconSizeInDropDown: TdxSkinIconSize read FSkinIconSizeInDropDown write SetSkinIconSizeInDropDown stored IsSkinIconSizeInDropDownStored;
    property VisibleLookAndFeelStyles: TcxLookAndFeelStyles read FVisibleLookAndFeelStyles write SetVisibleLookAndFeelStyles default [lfsSkin];

    property OnSkinChanged: TdxSkinChooserGallerySkinChangedEvent read FOnSkinChanged write FOnSkinChanged;
    property OnPopulate: TNotifyEvent read FOnPopulate write FOnPopulate;

    //TCustomdxBarSubItem
    property Glyph;
    property ImageIndex;
    property LargeGlyph;
    property LargeImageIndex;
    property ShowCaption default True;
    property OnClick;

    //TCustomdxBarSubItem
    property ItemLinks;
    property ItemOptions;
    property OnCloseUp;
    property OnPopup;

    // TdxCustomRibbonGalleryItem
    property GalleryInRibbonOptions;
    property GalleryInMenuOptions;
    property OnHotTrackedItemChanged;
  end;

{$ENDREGION}

{$ENDREGION}

{$REGION 'RibbonCompositeItem'}

  TdxRibbonCompositeItem = class;
  TdxRibbonCompositeItemControl = class;
  TdxRibbonCompositeItemControlViewInfo = class;

  { TdxRibbonCompositeItem }

  TdxRibbonCompositeItem = class(TdxBarCustomCompositeItem) // for internal use
  strict private
    FScaleFactor: TdxScaleFactor;
  protected
    function CanBePlacedOn(AParentKind: TdxBarItemControlParentKind; AToolbar: TdxBar; out AErrorText: string): Boolean; override;
    procedure ChangeScale(M, D: Integer); override;
    function GetErrorCanPlaceText: string; virtual;
    class function GetNewCaption: string; override;
    property ScaleFactor: TdxScaleFactor read FScaleFactor;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  { TdxRibbonCompositeItemControl }

  TdxRibbonCompositeItemControl = class(TdxBarCustomCompositeItemControl) // for internal use
  strict private
    function GetVisibleChildCount: Integer; inline;
    function GetVisibleChild(AIndex: Integer): TdxBarItemControl; inline;
    function GetItem: TdxRibbonCompositeItem; inline;
    function GetViewInfo: TdxRibbonCompositeItemControlViewInfo; inline;
  protected
    function GetViewInfoClass: TdxBarItemControlViewInfoClass; override; final;
    function GetCompositeViewInfoClass: TdxBarItemControlViewInfoClass; virtual;
    function GetErrorWhenEmbedIntoDropDownWindow: string; virtual;
  public
    property Item: TdxRibbonCompositeItem read GetItem;
    property VisibleChildCount: Integer read GetVisibleChildCount;
    property VisibleChildren[AIndex: Integer]: TdxBarItemControl read GetVisibleChild;
    property ViewInfo: TdxRibbonCompositeItemControlViewInfo read GetViewInfo;
  end;

  { TdxRibbonCompositeItemControlViewInfo }

  TdxRibbonCompositeItemControlViewInfo = class(TdxBarCustomCompositeItemControlViewInfo, // for internal use
    IdxBarCompositeItemControlViewInfo,
    IdxBarMultiColumnItemControlViewInfo)
  private
    FCachedWidths: TList;
    FCollapsedChildIndex: Integer;
    FColumnCountChildIndex: Integer;
    FCanCollapse: Boolean;
    FColumnCount : Integer;
    FMaxColumnCount: Integer;
    function GetControl: TdxRibbonCompositeItemControl;
    function GetChildrenCount: Integer;
  protected
  const 
    DefaultEmptyWidth = 50;
    DefaultWidthIndent = 2;
    function GetWidthIndent: Integer; virtual;
    function GetHeightIndent: Integer; virtual;
    function GetDefaultWidth: Integer; virtual;

    //IdxBarCompositeItemControlViewInfo
    function IdxBarCompositeItemControlViewInfo.GetWidth = GetCompositeItemWidth;
    procedure IdxBarCompositeItemControlViewInfo.SetBounds = SetCompositeItemBounds;
    procedure IdxBarCompositeItemControlViewInfo.OffsetContent = CompositeItemOffsetContent;
    function IdxBarCompositeItemControlViewInfo.ItemAtPos = CompositeItemAtPos;
    procedure CompositeItemOffsetContent(AOffset: Integer);
    function GetCompositeItemWidth(AViewLevel: TdxBarItemRealViewLevel): Integer;
    procedure SetCompositeItemBounds(const AValue: TRect);
    function UpdateItemLinksBounds: Boolean;
    function CompositeItemAtPos(const APos: TPoint): TdxBarItemControl;
    procedure InitializeChildren;
    procedure DoRightToLeftConversion(const ABounds: TRect);

    //IdxBarMultiColumnItemControlViewInfo
    function CanCollapse: Boolean;
    function GetCollapsed: Boolean;
    function GetColumnCount: Integer;
    function GetMaxColumnCount: Integer;
    function GetMinColumnCount: Integer;
    function GetWidthForColumnCount(AColumnCount: Integer): Integer;
    procedure SetCollapsed(AValue: Boolean);
    procedure SetColumnCount(AValue: Integer);

    procedure BoundsCalculated; override;
  public
    constructor Create(AControl: TdxBarItemControl); override;
    destructor Destroy; override;
    procedure ResetCachedValues; override;
    property Control: TdxRibbonCompositeItemControl read GetControl;
    property ChildCount: Integer read GetChildrenCount;
    function GetChild(AIndex: Integer): IdxBarItemControlViewInfo;
    function GetObjectChild(AIndex: Integer): TdxBarItemControlViewInfo;
  end;

{$ENDREGION}

{$REGION 'SkinSelector'}

  TdxRibbonSkinSelector = class;
  TdxRibbonSkinSelectorController = class;
  TdxRibbonSkinSelectorControl = class;
  TdxRibbonSkinSelectorLoader = class;
  TdxRibbonSkinSelectorSetSkinHelper = class;
  TdxRibbonSkinSelectorSetSkinArgs = class;
  TdxRibbonSkinSelectorAddSkinEvent = procedure (Sender: TObject; const ASkinGroupName, ASkinName: string; var AAccepted: Boolean) of object;
  TdxRibbonSkinSelectorAddPaletteEvent = procedure (Sender: TObject; const ASkinName, APaletteName: string; var AAccepted: Boolean) of object;
  TdxRibbonSkinSelectorSkinChangedEvent =  TdxSkinChooserGallerySkinChangedEvent;
  TdxRibbonSkinSelectorPaletteChangedEvent = TdxSkinChooserGalleryPaletteChangedEvent;
  TdxRibbonSkinSelectorPopulateEvent = procedure (Sender: TObject; const ALoader: TdxRibbonSkinSelectorLoader; var AHandled: Boolean) of object;
  TdxRibbonSkinSelectorSetSkinEvent = procedure (Sender: TObject; const AHelper: TdxRibbonSkinSelectorSetSkinHelper; const AArgs: TdxRibbonSkinSelectorSetSkinArgs; var AHandled: Boolean) of object;

{$SCOPEDENUMS ON}

  TdxSkinGroup = dxSkinNames.TdxSkinGroup;
  TdxSkinGroups = dxSkinNames.TdxSkinGroups;

  TdxRibbonSkinSelectorChange = (Build, SkinChooserProperties, PaletteChooserProperties, SkinValues); // for internal use
  TdxRibbonSkinSelectorChanges = set of TdxRibbonSkinSelectorChange; // for internal use
  TdxRibbonSkinSelectorChooserType = (None, SkinChooser, PaletteChooser); // for internal use
  TdxRibbonSkinSelectorChooserTypes = set of TdxRibbonSkinSelectorChooserType; // for internal use

{$SCOPEDENUMS OFF}

{$REGION 'Options'}

{$REGION 'preliminary classes'}

   TdxRibbonSkinSelectorOwnerOptionsClass = class of TdxRibbonSkinSelectorOwnerOptions;
   TdxRibbonSkinSelectorSkinChooserOptions = class;
   TdxRibbonSkinSelectorPaletteChooserOptions = class;
   TdxRibbonSkinSelectorCustomChooserOptions = class;

{$ENDREGION}

{$REGION 'Base'}

  { TdxRibbonSkinSelectorBaseOptions }

  TdxRibbonSkinSelectorBaseOptions = class(TcxLockablePersistent)
  protected
    procedure DoChangeScale(M, D: Integer); virtual;
    procedure Initialize; virtual;
  public
    constructor Create(AOwner: TPersistent); override;
    procedure CancelUpdate; virtual;
    procedure ChangeScale(M, D: Integer);
  end;

  { TdxRibbonSkinSelectorOwnerOptions }

  TdxRibbonSkinSelectorOwnerOptions = class(TdxRibbonSkinSelectorBaseOptions)
  strict private
    function GetOwnerOptions: TdxRibbonSkinSelectorOwnerOptions;
  protected
    procedure DoChanged; override;
    property OwnerOptions: TdxRibbonSkinSelectorOwnerOptions read GetOwnerOptions;
  end;

{$ENDREGION}

{$REGION 'Internal Root'}

 { TdxRibbonSkinSelectorRootOptions }

 TdxRibbonSkinSelectorRootOptions = class(TdxRibbonSkinSelectorBaseOptions) // for internal use
  strict private
    FChanges: TdxRibbonSkinSelectorChanges;
    FPaletteChooser: TdxRibbonSkinSelectorPaletteChooserOptions;
    FSkinChooser: TdxRibbonSkinSelectorSkinChooserOptions;
    function GetSkinSelector: TdxRibbonSkinSelector;
    procedure SetPaletteChooser(AValue: TdxRibbonSkinSelectorPaletteChooserOptions);
    procedure SetSkinChooser(AValue: TdxRibbonSkinSelectorSkinChooserOptions);
  protected
    procedure ChooserOptionsChanged(AOption: TdxRibbonSkinSelectorOwnerOptions);
    procedure DoAssign(ASource: TPersistent); override;
    procedure DoChanged; override;
    procedure DoChangeScale(M, D: Integer); override;
    procedure Initialize; override;
    procedure PropertyChanged(AChange: TdxRibbonSkinSelectorChange);

    property PaletteChooser: TdxRibbonSkinSelectorPaletteChooserOptions read FPaletteChooser write SetPaletteChooser;
    property SkinChooser: TdxRibbonSkinSelectorSkinChooserOptions read FSkinChooser write SetSkinChooser;
    property SkinSelector: TdxRibbonSkinSelector read GetSkinSelector;
  public
    destructor Destroy; override;
    procedure CancelUpdate; override;
  end;

{$ENDREGION}

{$REGION 'Places'}

{$REGION 'Custom Place'}

  { TdxRibbonSkinSelectorCustomPlaceOptions }

  TdxRibbonSkinSelectorCustomPlaceOptions = class(TdxRibbonSkinSelectorOwnerOptions)
  strict private
    FCanCollapse: Boolean;
    FCollapsed: Boolean;
    FColumnCount: Integer;
    FItemIconVisible: Boolean;
    FItemSize: TcxItemSize;
    FMinColumnCount: Integer;
    FResizeMode: TdxRibbonGallerySubmenuResizing;
    FShowItemCaption: Boolean;
    function GetOwnerOptions: TdxRibbonSkinSelectorCustomChooserOptions;
    function IsItemSizeStored: Boolean;
    procedure SetCanCollapse(AValue: Boolean);
    procedure SetCollapsed(AValue: Boolean);
    procedure SetColumnCount(AValue: Integer);
    procedure SetItemIconVisible(AValue: Boolean);
    procedure SetItemSize(AValue: TcxItemSize);
    procedure SetMinColumnCount(AValue: Integer);
    procedure SetResizeMode(AValue: TdxRibbonGallerySubmenuResizing);
    procedure SetShowItemCaption(AValue: Boolean);
  protected
    procedure DefaultChangesHandler(Sender: TObject); virtual;
    procedure DoAssign(ASource: TPersistent); override;
    procedure DoChangeScale(M, D: Integer); override;
    procedure Initialize; override;

    property OwnerOptions: TdxRibbonSkinSelectorCustomChooserOptions read GetOwnerOptions;

    property CanCollapse: Boolean read FCanCollapse write SetCanCollapse default True;
    property Collapsed: Boolean read FCollapsed write SetCollapsed default False;
    property ColumnCount: Integer read FColumnCount write SetColumnCount default 1;
    property ItemIconVisible: Boolean read FItemIconVisible write SetItemIconVisible default True;
    property ItemSize: TcxItemSize read FItemSize write SetItemSize stored IsItemSizeStored;
    property MinColumnCount: Integer read FMinColumnCount write SetMinColumnCount default 1;
    property ResizeMode: TdxRibbonGallerySubmenuResizing read FResizeMode write SetResizeMode default TdxRibbonGallerySubmenuResizing.gsrNone;
    property ShowItemCaption: Boolean read FShowItemCaption write SetShowItemCaption default False;
  public
    destructor Destroy; override;
  end;

{$ENDREGION}

{$REGION 'Custom Place Skin'}

  { TdxRibbonSkinSelectorCustomPlaceSkinOptions }

  TdxRibbonSkinSelectorCustomPlaceSkinOptions = class(TdxRibbonSkinSelectorCustomPlaceOptions)
  strict private
    FItemIconSize: TdxSkinIconSize;
    procedure SetItemIconSize(AValue: TdxSkinIconSize);
  protected
    procedure DoAssign(ASource: TPersistent); override;
    procedure Initialize; override;

    property ItemIconSize: TdxSkinIconSize read FItemIconSize write SetItemIconSize default sis16;
  end;

{$ENDREGION}

{$REGION 'Custom Place Palette'}

  { TdxRibbonSkinSelectorCustomPlacePaletteOptions }

  TdxRibbonSkinSelectorCustomPlacePaletteOptions = class(TdxRibbonSkinSelectorCustomPlaceOptions)
  strict private
    FItemIconSize: TcxItemSize;
    function IsItemIconSizeStored: Boolean;
    procedure SetItemIconSize(AValue: TcxItemSize);
  protected
    procedure DoAssign(ASource: TPersistent); override;
    procedure DoChangeScale(M, D: Integer); override;
    procedure Initialize; override;

    property ItemIconSize: TcxItemSize read FItemIconSize write SetItemIconSize stored IsItemIconSizeStored;
  public
    destructor Destroy; override;
  end;

{$ENDREGION}

{$REGION 'Skin InRibbon and InMenu'}

  { TdxRibbonSkinSelectorCustomInMenuSkinOptions }

  TdxRibbonSkinSelectorCustomInMenuSkinOptions = class(TdxRibbonSkinSelectorCustomPlaceSkinOptions)
  strict private
    FRowCount: Integer;
    FSearchBoxVisible: Boolean;
    procedure SetRowCount(AValue: Integer);
    procedure SetSearchBoxVisible(AValue: Boolean);
  protected
    procedure DoAssign(ASource: TPersistent); override;
    procedure Initialize; override;

    property RowCount: Integer read FRowCount write SetRowCount default 10;
    property SearchBoxVisible: Boolean read FSearchBoxVisible write SetSearchBoxVisible default True;
  end;

  { TdxRibbonSkinSelectorCustomInRibbonSkinOptions }

  TdxRibbonSkinSelectorCustomInRibbonSkinOptions = class(TdxRibbonSkinSelectorCustomPlaceSkinOptions)
  strict private
    FCollapsedIconSize: TdxSkinIconSize;
    procedure SetCollapsedIconSize(AValue: TdxSkinIconSize);
  protected
    procedure DoAssign(ASource: TPersistent); override;
    procedure Initialize; override;

    property CollapsedIconSize: TdxSkinIconSize read FCollapsedIconSize write SetCollapsedIconSize default sis48;
  end;

  { TdxRibbonSkinSelectorInMenuSkinOptions }

  TdxRibbonSkinSelectorInMenuSkinOptions = class(TdxRibbonSkinSelectorCustomInMenuSkinOptions)
  protected
    procedure Initialize; override;
    property ShowItemCaption default True;
  published
    property ItemIconSize;
    property ItemSize;
    property SearchBoxVisible;
  end;

  { TdxRibbonSkinSelectorInRibbonSkinOptions }

  TdxRibbonSkinSelectorInRibbonSkinOptions = class(TdxRibbonSkinSelectorCustomInRibbonSkinOptions)
  protected
    procedure Initialize; override;
  published
    property CanCollapse;
    property Collapsed default True;
    property ColumnCount;
    property ItemSize;
    property MinColumnCount;
    property ShowItemCaption default True;

    property ItemIconSize default sis16;
    property CollapsedIconSize;
  end;

{$ENDREGION}

{$REGION 'Palette InRibbon and InMenu'}

  TdxRibbonSkinSelectorCustomInMenuPaletteOptions = class(TdxRibbonSkinSelectorCustomPlacePaletteOptions);

  TdxRibbonSkinSelectorCustomInRibbonPaletteOptions = class(TdxRibbonSkinSelectorCustomPlacePaletteOptions)
  strict private
    FCollapsedGlyph: TdxSmartGlyph;
    function IsCollapsedGlyphStored: Boolean;
    procedure SetCollapsedGlyph(AValue: TdxSmartGlyph);
  protected
    procedure DoAssign(ASource: TPersistent); override;
    procedure Initialize; override;

    property CollapsedGlyph: TdxSmartGlyph read FCollapsedGlyph write SetCollapsedGlyph stored IsCollapsedGlyphStored;
  public
    destructor Destroy; override;
  end;

  TdxRibbonSkinSelectorInMenuPaletteOptions = class(TdxRibbonSkinSelectorCustomInMenuPaletteOptions)
  protected
    procedure Initialize; override;
  published
    property ItemIconSize;
    property ShowItemCaption default True;
  end;

  TdxRibbonSkinSelectorInRibbonPaletteOptions = class(TdxRibbonSkinSelectorCustomInRibbonPaletteOptions)
  protected
    procedure Initialize; override;
    property ShowItemCaption default False;
  published
    property CanCollapse;
    property Collapsed;
    property CollapsedGlyph;
    property ColumnCount default 4;
    property ItemIconSize;
    property MinColumnCount default 2;
  end;

{$ENDREGION}

{$ENDREGION}

{$REGION 'Choosers'}

{$REGION 'Custom Chooser'}

  { TdxRibbonSkinSelectorBaseChooserOptions }

  TdxRibbonSkinSelectorBaseChooserOptions = class abstract(TdxRibbonSkinSelectorOwnerOptions)
  strict private
    FFreeNotificator: TcxFreeNotificator;
    function GetOwnerOptions: TdxRibbonSkinSelectorRootOptions;
    function GetFreeNotificator: TcxFreeNotificator;
  protected
    procedure DoChanged; override;
    procedure DoFreeNotification(AComponent: TComponent); virtual;
    property OwnerOptions: TdxRibbonSkinSelectorRootOptions read GetOwnerOptions;
    property FreeNotificator: TcxFreeNotificator read GetFreeNotificator;
  public
    destructor Destroy; override;
  end;

  { TdxRibbonSkinSelectorCustomChooserOptions }

  TdxRibbonSkinSelectorCustomChooserOptions = class abstract(TdxRibbonSkinSelectorBaseChooserOptions)
  strict private
    FHint: string;
    FInMenu: TdxRibbonSkinSelectorOwnerOptions;
    FInRibbon: TdxRibbonSkinSelectorOwnerOptions;
    FItemIconPosition: TdxRibbonGalleryImagePosition;
    FItemTextAlignVert: TcxAlignmentVert;
    FKeyTip: string;
    FScreenTip: TdxScreenTip;
    FVisible: TdxBarItemVisible;
    FOnGetScreenTip: TdxOnGetScreenTip;
    procedure SetHint(const AValue: string);
    procedure SetItemIconPosition(AValue: TdxRibbonGalleryImagePosition);
    procedure SetItemTextAlignVert(AValue: TcxAlignmentVert);
    procedure SetKeyTip(const AValue: string);
    procedure SetScreenTip(AValue: TdxScreenTip);
    procedure SetVisible(AValue: TdxBarItemVisible);
  protected
    procedure DoAssign(ASource: TPersistent); override;
    procedure DoChangeScale(M, D: Integer); override;
    procedure DoFreeNotification(AComponent: TComponent); override;
    function DoGetScreenTip: TdxScreenTip;
    function GetInMenuOptionClass: TdxRibbonSkinSelectorOwnerOptionsClass; virtual; abstract;
    function GetInRibbonOptionClass: TdxRibbonSkinSelectorOwnerOptionsClass; virtual; abstract;
    procedure Initialize; override;
    function SkinSelectorLoaded: Boolean;

    property Hint: string read FHint write SetHint;
    property InMenu: TdxRibbonSkinSelectorOwnerOptions read FInMenu;
    property InRibbon: TdxRibbonSkinSelectorOwnerOptions read FInRibbon;
    property ItemIconPosition: TdxRibbonGalleryImagePosition read FItemIconPosition write SetItemIconPosition default TdxRibbonGalleryImagePosition.gipLeft;
    property ItemTextAlignVert: TcxAlignmentVert read FItemTextAlignVert write SetItemTextAlignVert default TcxAlignmentVert.vaCenter;
    property KeyTip: string read FKeyTip write SetKeyTip;
    property ScreenTip: TdxScreenTip read FScreenTip write SetScreenTip;
    property Visible: TdxBarItemVisible read FVisible write SetVisible default TdxBarItemVisible.ivAlways;
    property OnGetScreenTip: TdxOnGetScreenTip read FOnGetScreenTip write FOnGetScreenTip;
  public
    destructor Destroy; override;
  end;

{$ENDREGION}

{$REGION 'SkinChooser'}

  { TdxRibbonSkinSelectorSkinChooserOptions }

  TdxRibbonSkinSelectorSkinChooserOptions = class(TdxRibbonSkinSelectorCustomChooserOptions)
  strict private
    FVisibleLookAndFeelStyles: TcxLookAndFeelStyles;
    FVisibleGroups: TdxSkinGroups;
    function GetInMenuOptions: TdxRibbonSkinSelectorInMenuSkinOptions;
    function GetInRibbonOptions: TdxRibbonSkinSelectorInRibbonSkinOptions;
    procedure SetInMenuOptions(AValue: TdxRibbonSkinSelectorInMenuSkinOptions);
    procedure SetInRibbonOptions(AValue: TdxRibbonSkinSelectorInRibbonSkinOptions);
    procedure SetVisibleLookAndFeelStyles(AValue: TcxLookAndFeelStyles);
    procedure SetVisibleGroups(AValue: TdxSkinGroups);
  protected
    procedure DoAssign(ASource: TPersistent); override;
    function GetInMenuOptionClass: TdxRibbonSkinSelectorOwnerOptionsClass; override;
    function GetInRibbonOptionClass: TdxRibbonSkinSelectorOwnerOptionsClass; override;
    procedure Initialize; override;
    procedure UpdateVisibleGroups(AValue: TdxSkinGroups);
  published
    property Hint;
    property InMenu: TdxRibbonSkinSelectorInMenuSkinOptions read GetInMenuOptions write SetInMenuOptions;
    property InRibbon: TdxRibbonSkinSelectorInRibbonSkinOptions read GetInRibbonOptions write SetInRibbonOptions;
    property ItemTextAlignVert;
    property KeyTip;
    property ScreenTip;
    property Visible;
    property VisibleLookAndFeelStyles: TcxLookAndFeelStyles read FVisibleLookAndFeelStyles write SetVisibleLookAndFeelStyles default [lfsSkin];
    property VisibleGroups: TdxSkinGroups read FVisibleGroups write SetVisibleGroups default [TdxSkinGroup.Vector];
    property OnGetScreenTip;
  end;

{$ENDREGION}

{$REGION 'PaletteChooser'}

  { TdxRibbonSkinSelectorPaletteChooserOptions }

  TdxRibbonSkinSelectorPaletteChooserOptions = class(TdxRibbonSkinSelectorCustomChooserOptions)
  strict private
    function GetInMenuOptions: TdxRibbonSkinSelectorInMenuPaletteOptions;
    function GetInRibbonOptions: TdxRibbonSkinSelectorInRibbonPaletteOptions;
    procedure SetInMenuOptions(AValue: TdxRibbonSkinSelectorInMenuPaletteOptions);
    procedure SetInRibbonOptions(AValue: TdxRibbonSkinSelectorInRibbonPaletteOptions);
  protected
    function GetInMenuOptionClass: TdxRibbonSkinSelectorOwnerOptionsClass; override;
    function GetInRibbonOptionClass: TdxRibbonSkinSelectorOwnerOptionsClass; override;
    procedure Initialize; override;
    property ItemIconPosition default TdxRibbonGalleryImagePosition.gipTop;
  published
    property Hint;
    property InMenu: TdxRibbonSkinSelectorInMenuPaletteOptions read GetInMenuOptions write SetInMenuOptions;
    property InRibbon: TdxRibbonSkinSelectorInRibbonPaletteOptions read GetInRibbonOptions write SetInRibbonOptions;
    property ItemTextAlignVert;
    property KeyTip;
    property ScreenTip;
    property Visible;
    property OnGetScreenTip;
  end;

{$ENDREGION}

{$ENDREGION}

{$ENDREGION}

{$REGION 'Loader'}

  { TdxRibbonSkinSelectorLoader }

  TdxRibbonSkinSelectorLoader = class
  strict private
    FChooser: TdxSkinChooserGalleryItem;
  public
    constructor Create(AChooser: TdxSkinChooserGalleryItem);
    procedure AddSkinsFromFile(const AFileName: string);
    procedure AddSkinsFromResource(AInstance: HINST; const AResourceName: string);
    procedure AddSkinsFromResources(AInstance: HINST);
    procedure AddSkinsFromStream(AStream: TStream; const ASkinResName: string; ASkinResInstance: HINST);
  end;

  { TdxRibbonSkinSelectorSetSkinHelper }

  TdxRibbonSkinSelectorSetSkinHelper = class
  strict private
    FManager: IdxSkinManager;
  public
    constructor Create(const AManager: IdxSkinManager); // for internal use
    procedure SetSkin(AStyle: TcxLookAndFeelStyle; const ASkinName: string);
    procedure SetSkinFromResource(AInstance: THandle; const AResourceName, ASkinName: string);
    procedure SetSkinFromFile(const ASkinName, AFileName: string);
    procedure SetSkinFromStream(const ASkinName: string; AStream: TStream);
  end;

  { TdxRibbonSkinSelectorSetSkinArgs }

  TdxRibbonSkinSelectorSetSkinArgs = class(TdxEventArgs)
  strict private
    FLookAndFeelStyle: TcxLookAndFeelStyle;
    FResInstance: NativeUInt;
    FResName: string;
    FSkinName: string;
  public
    constructor Create(const ASkinName, AResName: string; AResInstance: NativeUInt; ALookAndFeelStyle: TcxLookAndFeelStyle);
    property LookAndFeelStyle: TcxLookAndFeelStyle read FLookAndFeelStyle;
    property ResInstance: NativeUInt read FResInstance;
    property ResName: string read FResName;
    property SkinName: string read FSkinName;
  end;

{$ENDREGION}

{$REGION 'Controller'}

  { TdxRibbonSkinSelectorController }

  TdxRibbonSkinSelectorController = class // for internal use
  type
    TSkinValueSetter = class;
  {$SCOPEDENUMS ON}
    TDirection = (None, Up, Down);
    TSkinManagerUpdateType = (SelectedItems, SkinSelector);
    TSkinManagerUpdateTypes = set of TSkinManagerUpdateType;
    TSkinSetActionType = (None, SetNative, SetDefault, SetFromFileName, SetFromResource, SetFromSingleStream, SetFromCustomData);
  {$SCOPEDENUMS OFF}

    TSkinManager = class
    strict private
      class var FGlobalLockCount: Integer;
    strict private
      FInfo: IdxSkinManager;
      FOwner: TdxRibbonSkinSelectorController;
      FLockCount: Integer;
      FUpdateTypes: TSkinManagerUpdateTypes;
      FSkinValuesSetter: TSkinValueSetter;
      function GetSkinName: string;
      function GetPaletteName: string;
      function GetColorSchemeName: string;
      function GetStyle: TcxLookAndFeelStyle;
      procedure SkinControllersNotification(ASkinControllersCount: Integer; ASkinController: TComponent; AAction: TListNotification);
      procedure SkinValuesChanged(ALookAndFeel: TcxLookAndFeel; AChangedValues: TcxLookAndFeelValues);
      procedure PaintersNotification(APainter: TcxCustomLookAndFeelPainter; AOperation: TOperation);
    protected
      function CanPerformPostponedUpdate: Boolean;
      procedure PostponedUpdateHandler;
      procedure PostponedUpdate(AType: TSkinManagerUpdateType);
      function IsPostponedUpdateOfSelectedItems: Boolean;
      function IsPostponedUpdateOfSkinSelector: Boolean;
      function IsPostponedUpdate: Boolean;
    public
      constructor Create(AOwner: TdxRibbonSkinSelectorController);
      destructor Destroy; override;
      procedure SubscribeToNotifications;
      procedure UnsubscribeFromNotifications;
      function IsValid: Boolean;
      function GetActiveSkinValues(out ASkinName, APaletteName: string): Boolean;
      procedure SetSkinValues(ASkin: TdxSkinChooserGalleryGroupItem; const APaletteName: string);
      procedure SetSkin(AItem: TdxSkinChooserGalleryGroupItem);
      procedure SetPalette(AItem: TdxSkinPaletteChooserGalleryGroupItem);

      property Info: IdxSkinManager read FInfo;
      property Owner: TdxRibbonSkinSelectorController read FOwner;
      property PaletteName: string read GetPaletteName; 
      property ColorSchemeName: string read GetColorSchemeName; 
      property SkinName: string read GetSkinName; 
      property Style: TcxLookAndFeelStyle read GetStyle; 
    end;

    TSkinValueSetter = class
    strict private
      FSkinManager: TSkinManager; 
      function CalculateActionType(AItem: TdxSkinChooserGalleryGroupItem): TSkinSetActionType;
      function DoSetSkin(AItem: TdxSkinChooserGalleryGroupItem): Boolean;
      procedure SetPaletteName(AValue: string);
      property SkinManager: TSkinManager read FSkinManager;
    public
      constructor Create(ASkinManager: TSkinManager);
      procedure SetSkin(AItem: TdxSkinChooserGalleryGroupItem);
      procedure SetPalette(AItem: TdxSkinPaletteChooserGalleryGroupItem);
      procedure SetSkinValues(ASkin: TdxSkinChooserGalleryGroupItem; const APaletteName: string);
    end;

    TSkinManagerUpdater = class 
    strict private class var
      FInstance: TSkinManagerUpdater;
    strict private
      FList: TdxFastList;
      FLock: Boolean;
      FUpdating: Boolean;
      function InternalAdd(AManager: TSkinManager): Boolean;
      procedure InternalRemove(AManager: TSkinManager);
      procedure InternalUpdate;
      procedure Update;
    public
      constructor Create;
      destructor Destroy; override;
      class procedure Finalize;
      class function Add(AManager: TSkinManager): Boolean;
      class procedure Remove(AManager: TSkinManager);
      class function Updating: Boolean;
    end;

    TUserSkinSource = class
    type
      TSingleSkinData = class
      strict private
        FFileName: string;
        FResourceInstance: HINST;
        FResourcesInstance: HINST;
        FStream: TStream;
        function GetHasData: Boolean;
      protected
        procedure Clear;
        procedure UpdateStream(ASource: TStream);
        procedure UpdateResourceInstance(ASource: HINST; const AResourceName: string);
        procedure UpdateResourcesInstance(ASource: HINST);
        procedure UpdateFileName(const AFileName: string);

        property HasData: Boolean read GetHasData;
        property FileName: string read FFileName;
        property ResourceInstance: HINST read FResourceInstance;
        property ResourcesInstance: HINST read FResourcesInstance;
        property Stream: TStream read FStream;
      public
        destructor Destroy; override;
      end;

      TSkinResource = class
      strict private
        FInstance: HINST;
        FResourceName: string;
      protected
        property Instance: HINST read FInstance;
        property ResourceName: string read FResourceName;
      public
        constructor Create(AInstance: HINST; const AResourceName: string);
      end;

    strict private
      FSingleData: TSingleSkinData;
      FResourceList: TdxList<TSkinResource>;
      FResourcesList: TList<HINST>;
      FFileNames: TStringList;
      function GetHasData: Boolean;
      function GetHasListData: Boolean;
      function GetHasSingleData: Boolean;
    protected
      procedure AddToResourceList(AInstance: HINST; const AResourceName: string);
      procedure AddToResourcesList(AInstance: HINST);
      procedure AddToFileNames(const AFileName: string);
      procedure Clear;
      function Populate(const ALoader: TdxRibbonSkinSelectorLoader): Boolean;
      property HasData: Boolean read GetHasData;
      property HasListData: Boolean read GetHasListData;
      property HasSingleData: Boolean read GetHasSingleData;
      property SingleData: TSingleSkinData read FSingleData;
      property ResourceList: TdxList<TSkinResource> read FResourceList;
      property ResourcesList: TList<HINST> read FResourcesList;
      property FileNames: TStringList read FFileNames;
    public
      constructor Create;
      destructor Destroy; override;
    end;

    TRibbonSkinUpdater = class
    strict private
      FOwner: TdxRibbonSkinSelectorController;
      FIsUpdated: Boolean;
    protected
      procedure DoUpdate;
      function UpdateRibbonColorScheme(ARibbon: TdxCustomRibbon): Boolean;
    public
      constructor Create(AOwner: TdxRibbonSkinSelectorController);
      destructor Destroy; override;
      procedure Update(AForce: Boolean);
    end;

    TSearchEdit = class;
    TSkinChooser = class;
    TSkinChooserControl = class;
    TPaletteChooser = class;
    TChooserController = class;

    TSkinChooserVisibleGroupController = class
    strict private
      FOwner: TChooserController;
      FSkinChooser: TSkinChooser;
      FOptions: TdxRibbonSkinSelectorSkinChooserOptions;
      FList: TStringList;
      FLockCount: Integer;
      procedure ListChanged(Sender: TObject);
      procedure UpdateToChooser;
      procedure UpdateToOptions;
    protected
      property SkinChooser: TSkinChooser read FSkinChooser write FSkinChooser;
    public
      constructor Create(AOwner: TChooserController);
      destructor Destroy; override;
      procedure UpdateFromOptions;
      procedure UpdateFromChooser;
    end;

    TChooserController = class
    strict private const
      DefaultUseLocalizedNames = True;
    var
      FEmptyItemLoaded: Boolean;
      FLockChangePaletteCount: Integer;
      FLockPaletteNotificationCount: Integer;
      FNeedPaletteNotification: Boolean;
      FLockChangeSkinCount: Integer;
      FOwner: TdxRibbonSkinSelectorController;
      FPaletteChooser: TPaletteChooser;
      FSearchEdit: TSearchEdit;
      FSkinChooser: TSkinChooser;
      FVisibleGroupController: TSkinChooserVisibleGroupController;
      function CreateBarItem(AClass: TdxBarItemClass; ALinked: Boolean): TdxBarItem;
      procedure CreateSubItems;
      procedure DestroySubItems;
      function GetScaleFactor: TdxScaleFactor;
      function GetSearchEditProperties: TcxButtonEditProperties;
      function GetSkinManager: TSkinManager;
      function GetSkinSelector: TdxRibbonSkinSelector;
      procedure PaletteNotification;
      procedure PaletteNotificationBeginUpdate;
      procedure PaletteNotificationEndUpdate;
      procedure SkinNotification;
      procedure UpdateRibbons;
      procedure UpdatePalette;
      procedure UpdateSkin;
      procedure UpdateSkinChooser;
      procedure ValidatePaletteName(AUseDefaultPalette: Boolean; var APaletteName: string; out AChanged: Boolean);
      procedure ValidateSkinName(var ASkinName: string; AChooser: TdxSkinChooserGalleryItem; out AChanged: Boolean);
    protected
      procedure GetScreenTip(Sender: TObject; var AScreenTip: TdxScreenTip);

      procedure PaletteChangedHandler(Sender: TObject; const ASkinName, APaletteName: string);
      procedure PaletteChooserAddPaletteHandler(Sender: TObject; const ASkinName: string; AColorPalette: TdxSkinColorPalette; var AAccepted: Boolean);
      procedure DoAfterPopulatePalettes;
      procedure DoBeforePopulatePalettes;
      procedure UpdatePaletteChooserProperties;

      procedure SkinChooserSkinChangedHandler(Sender: TObject; const ASkinName: string);
      procedure SkinChooserAddSkinHandler(Sender: TObject; ASkinDetails: TdxSkinDetails; var AAccepted: Boolean);
      procedure SkinChooserGroupVisibleChanged(Sender: TObject; AGroup: TdxCustomGalleryGroup);
      procedure SkinPopulateHandler(Sender: TObject);
      procedure SkinChooserPopupHandler(Sender: TObject);
      procedure UpdateSkinChooserProperties;

      procedure SetFocusToSearchEdit;
      procedure SearchEditTextChanged;

      property Owner: TdxRibbonSkinSelectorController read FOwner;
      property PaletteChooser: TPaletteChooser read FPaletteChooser;
      property ScaleFactor: TdxScaleFactor read GetScaleFactor;
      property SearchEdit: TSearchEdit read FSearchEdit;
      property SearchEditProperties: TcxButtonEditProperties read GetSearchEditProperties;
      property SkinChooser: TSkinChooser read FSkinChooser;
      property SkinManager: TSkinManager read GetSkinManager;
      property SkinSelector: TdxRibbonSkinSelector read GetSkinSelector;
    public
      constructor Create(AOwner: TdxRibbonSkinSelectorController);
      destructor Destroy; override;
      procedure Build;
      procedure GetSelectedGroupNames(AList: TStrings);
      function IsPaletteChooserPlacedInRibbon: Boolean;
      procedure SetSelectedGroupNames(AList: TStrings);
      procedure SetSkinValues(ASkinName, APaletteName: string);
      procedure UpdateChooserProperties(AChooserTypes: TdxRibbonSkinSelectorChooserTypes);
      procedure UpdateEnabled;
      procedure UpdatePaletteChooserPlacement(AInRibbon: Boolean);

      property VisibleGroupController: TSkinChooserVisibleGroupController read FVisibleGroupController;
    end;

    TSearchEdit = class(TcxBarEditItem)
    strict private
      FCancelButton: TcxEditButton;
      FCancelButtonPalette: IdxColorPalette;
      FController: TChooserController; 
      FIconButton: TcxEditButton;
      FPostponedExecutionLocked: Boolean;
      FSettingButton: TcxEditButton;
      procedure ButtonGlyphDrawParametersHandler(Sender: TObject; AButtonIndex: Integer; AState: TcxEditButtonState; var AGlyph: TGraphic; var APalette : IdxColorPalette);
      procedure ButtonsClickHandler(Sender: TObject; AButtonIndex: Integer);
      procedure ChangedHandler(Sender: TObject);
      function GetProperties: TcxButtonEditProperties;
      function GetSelectedControl: TcxBarEditItemControl;
      procedure InternalSetFocus;
      procedure PostponedExecution(const AProc: TProc);
      procedure UpdateState;
    protected
      function GetControlClass(AIsVertical: Boolean): TdxBarItemControlClass; override;
      procedure ControlSelectionChanged(AControl: TdxBarItemControl); override;
      procedure KeyDown(var AKey: Word; AShift: TShiftState); override;
    public
      destructor Destroy; override;
      procedure PrepareOnShow;
      procedure PostponedSetFocus;
      procedure SettingButtonClick;
      procedure Setup(AController: TChooserController);
      property Properties: TcxButtonEditProperties read GetProperties;
    end;

    TSearchEditControl = class(TcxBarEditItemControl);

    TSkinChooser = class(TdxSkinChooserGalleryItem)
    strict private
      FController: TChooserController;
      FDisplaySelectedGroupItemLocked: Boolean;
      FDropDowned: Boolean;
      FNavigationDirection: TDirection;
      FNavigatedToSelectItem: Boolean;
      procedure InternalDisplaySelectedGroupItem;
    protected
      function DoGetScreenTip: TdxScreenTip; override;
      procedure FilterMenuControlDestroying; override;
      procedure GroupVisibleChanged(AGroup: TdxCustomChooserGalleryGroup); override;
      procedure DoAfterPopulate; override;
      procedure DoPopup; override;
      procedure DoCloseUp; override;
      procedure FilterUpdateUnlocked; override;

      property Controller: TChooserController read FController;
    public
      destructor Destroy; override;
      procedure PrepareOnShow;
      procedure PostponedDisplaySelectedGroupItem;
      procedure Setup(AController: TChooserController);
      property NavigationDirection: TDirection read FNavigationDirection write FNavigationDirection;
      property DropDowned: Boolean read FDropDowned;
      property NavigatedToSelectItem: Boolean read FNavigatedToSelectItem write FNavigatedToSelectItem;
    end;

    TSkinChooserOnSubmenuController = class(TdxRibbonOnSubmenuGalleryController)
    strict private
      FLockResizeCount: SmallInt;
      function GetItem: TSkinChooser;
      function GetControl: TSkinChooserControl;
    protected
      procedure DoCloseUp;
      procedure DoDropDown;
      function FilterDropDownAutoSize(AGroupIndex: Integer): Boolean; override;
      procedure UpdateHotTrack(ADirection: TdxRibbonDropDownGalleryNavigationDirection); override;
      property Item: TSkinChooser read GetItem;
      property Control: TSkinChooserControl read GetControl;
    end;

    TSkinChooserControl = class(TdxCustomChooserGalleryControl)
     strict private
      FNextTimeForDisplayDropDown: Cardinal;
      function GetSubmenuController: TSkinChooserOnSubmenuController;
    protected
      function CreateController: TdxRibbonGalleryController; override;
      procedure ControlClick(AByMouse: Boolean; AKey: Char = #0); override;
      procedure DoCloseUp(AHadSubMenuControl: Boolean); override;
      procedure DoDropDown(AByMouse: Boolean); override;

      property SubmenuController: TSkinChooserOnSubmenuController read GetSubmenuController;
    end;

    TPaletteChooser = class(TdxSkinPaletteChooserGalleryItem)
    strict private
      FController: TChooserController; 
    protected
      procedure DoAfterPopulate; override;
      procedure DoBeforePopulate; override;
      function DoGetScreenTip: TdxScreenTip; override;
    public
      procedure Setup(AController: TChooserController);
    end;

  strict private
    FLockCount: Integer;
    FIsReady: Boolean;
    FRibbonUpdater: TRibbonSkinUpdater;
    FSkinManager: TSkinManager;
    FSkinSelector: TdxRibbonSkinSelector; 
    FStoredPaletteName: string;
    FStoredSkinName: string;
    FSkinValuesAssignedExternally: Boolean;
    FChooserController: TChooserController;
    FUserSkinSource: TUserSkinSource;
    procedure InternalClearUserSkinSource;
    procedure Build;
    function CanBuild: Boolean;
    procedure InternalClear;
    procedure StoreSkinValues(AForce: Boolean);
    procedure RestoreSkinValues;
  protected
    function IsReady: Boolean;
    function DoPopulateWithSkins(const ALoader: TdxRibbonSkinSelectorLoader): Boolean;
    procedure RefreshSkinSelector;
    procedure UserSkinSourceChanged;
    procedure SynchronizeSelectedItems;
    function UsesCustomSkinSource: Boolean;
    function HasPopulateEvent: Boolean;
    function HasSetSkinEvent: Boolean;

    property ChooserController: TChooserController read FChooserController;
    property SkinManager: TSkinManager read FSkinManager;
    property SkinSelector: TdxRibbonSkinSelector read FSkinSelector;
    property UserSkinSource: TUserSkinSource read FUserSkinSource;
  public
    constructor Create(ASkinSelector: TdxRibbonSkinSelector);
    destructor Destroy; override;
    procedure ApplySkinValues;
    procedure SetSkinValues(const ANewSkinName, ANewPaletteName: string);
    procedure ClearUserSkinSource;
    procedure AddSkinsFromFile(const AFileName: string);
    procedure AddSkinsFromResource(AInstance: HINST; const AResourceName: string);
    procedure AddSkinsFromResources(AInstance: HINST);
    procedure LoadSkinsFromFile(const AFileName: string);
    procedure LoadSkinsFromStream(AStream: TStream);
    procedure LoadSkinsFromResource(AInstance: HINST; const AResourceName: string);
    procedure LoadSkinsFromResources(AInstance: HINST);
    procedure Refresh;
    procedure UpdateChooserProperties(AChooserTypes: TdxRibbonSkinSelectorChooserTypes);
    procedure UpdateRibbons(AForce: Boolean = True);
    procedure UpdateEnabled;
    procedure UpdateSkinVisibleGroups;
  end;

{$ENDREGION}

{$REGION 'BarItem'}

  { TdxRibbonSkinSelector }

  TdxRibbonSkinSelector = class(TdxRibbonCompositeItem, IdxLocalizerListener)
  strict protected const
    DefaultPreferredSkinName = dxSkinNames.TdxSkinNames.TWXI.ID;
    DefaultPreferredPaletteName = dxSkinNames.TdxSkinNames.TWXI.TPalettes.Default;
  strict private
    FLoaded: Boolean;
    FChanges: TdxRibbonSkinSelectorChanges;
    FController: TdxRibbonSkinSelectorController;
    FLockCount: Integer;
    FTranslationLocked: Boolean;
    FOptions: TdxRibbonSkinSelectorRootOptions;
    FOnAddPalette: TdxRibbonSkinSelectorAddPaletteEvent;
    FOnAddSkin: TdxRibbonSkinSelectorAddSkinEvent;
    FOnPaletteChanged: TdxRibbonSkinSelectorPaletteChangedEvent;
    FOnSkinChanged: TdxRibbonSkinSelectorSkinChangedEvent;
    FOnPopulate: TdxRibbonSkinSelectorPopulateEvent;
    FOnSetSkin: TdxRibbonSkinSelectorSetSkinEvent;
    FInternalEvents: TNotifyEvent;
    FPreferredPaletteName: string;
    FPreferredSkinName: string;
    FPopulateLocked: Boolean;
    function IsPreferredPaletteNameStored: Boolean;
    function IsPreferredSkinNameStored: Boolean;
    function GetActivePaletteName: string;
    function GetActiveSkinName: string;
    function GetPaletteChooserOptions: TdxRibbonSkinSelectorPaletteChooserOptions;
    function GetSkinChooserOptions: TdxRibbonSkinSelectorSkinChooserOptions;
    procedure InternalInitialization;
    procedure UpdateChildrenEnabled;
    procedure SetOptions(AValue: TdxRibbonSkinSelectorRootOptions);
    procedure SetPaletteChooserOptions(AValue: TdxRibbonSkinSelectorPaletteChooserOptions);
    procedure SetSkinChooserOptions(AValue: TdxRibbonSkinSelectorSkinChooserOptions);
    procedure SetSkinIfNeeded(const ASkinName, APaletteName: string);
  protected
    // IdxLocalizerListener
    procedure TranslationChanged;

    procedure AfterLoadedInitialize; override;
    procedure ChangeScale(M, D: Integer); override;
    procedure ChildrenListChanged; override;
    procedure ChildrenListNotification(AValue: TdxBarItem; AAction: TListNotification); override;
    procedure DoAddPalette(const ASkinName: string; AColorPalette: TdxSkinColorPalette; var AAccepted: Boolean);
    procedure DoAddSkin(ASkinDetails: TdxSkinDetails; var AAccepted: Boolean);
    procedure DoPaletteChanged(const ASkinName, APaletteName: string);
    procedure DoSkinChanged(const ASkinName: string);
    function DoPopulateWithSkins(const ALoader: TdxRibbonSkinSelectorLoader): Boolean;
    function DoSetSkin(AHelper: TdxRibbonSkinSelectorSetSkinHelper; AArgs: TdxRibbonSkinSelectorSetSkinArgs): Boolean;
    procedure DoSkinSelectorChanged(AChanges: TdxRibbonSkinSelectorChanges);
    procedure EnabledChanged; override;
    function GetErrorCanPlaceText: string; override;
    procedure LinksChanged(AItemLink: TdxBarItemLink; AAction: TListNotification); override;
    procedure SkinSelectorChanged(AChanges: TdxRibbonSkinSelectorChanges);
    procedure UpdateSkinValues; 
    class function GetNewCaption: string; override;

    property Controller: TdxRibbonSkinSelectorController read FController;
    property Options: TdxRibbonSkinSelectorRootOptions read FOptions write SetOptions;
    property SkinSelectorLoaded: Boolean read FLoaded;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    class function CreateSkinSelector(ABar: TdxBar; const ASkinResFileName: string = ''): TdxRibbonSkinSelector;    

    procedure AddFromFile(const AFileName: string);
    procedure AddFromResource(AInstance: HINST; const AResourceName: string);
    procedure AddFromResources(AInstance: HINST);
    procedure LoadFromFile(const AFileName: string; const ASkinName: string = ''; const APaletteName: string = '');
    procedure LoadFromStream(AStream: TStream; const ASkinName: string = ''; const APaletteName: string = '');
    procedure LoadFromResource(AInstance: HINST; const AResourceName: string; const ASkinName : string = ''; const APaletteName: string = '');
    procedure LoadFromResources(AInstance: HINST; const ASkinName: string = ''; const APaletteName: string = '');
    procedure Reset;

    procedure Refresh;
    procedure SetSkin(const ASkinName: string; const APaletteName: string = '');

    procedure BeginUpdate;
    procedure EndUpdate;

    property ActiveSkinName: string read GetActiveSkinName;
    property ActivePaletteName: string read GetActivePaletteName;
    property PreferredPaletteName: string read FPreferredPaletteName write FPreferredPaletteName stored IsPreferredPaletteNameStored;
    property PreferredSkinName: string read FPreferredSkinName write FPreferredSkinName stored IsPreferredSkinNameStored;
  published
    property PaletteChooserOptions: TdxRibbonSkinSelectorPaletteChooserOptions read GetPaletteChooserOptions write SetPaletteChooserOptions;
    property SkinChooserOptions: TdxRibbonSkinSelectorSkinChooserOptions read GetSkinChooserOptions write SetSkinChooserOptions;

    property OnAddPalette: TdxRibbonSkinSelectorAddPaletteEvent read FOnAddPalette write FOnAddPalette;
    property OnAddSkin: TdxRibbonSkinSelectorAddSkinEvent read FOnAddSkin write FOnAddSkin;
    property OnPaletteChanged: TdxRibbonSkinSelectorPaletteChangedEvent read FOnPaletteChanged write FOnPaletteChanged;
    property OnSkinChanged: TdxRibbonSkinSelectorSkinChangedEvent read FOnSkinChanged write FOnSkinChanged;
    property OnPopulate: TdxRibbonSkinSelectorPopulateEvent read FOnPopulate write FOnPopulate;
    property OnSetSkin: TdxRibbonSkinSelectorSetSkinEvent read FOnSetSkin write FOnSetSkin;

    property SkinChooserEvents: TNotifyEvent read FInternalEvents write FInternalEvents; // for internal use
    property PaletteChooserEvents: TNotifyEvent read FInternalEvents write FInternalEvents; // for internal use
  end;

  { TdxRibbonSkinSelectorControl }

  TdxRibbonSkinSelectorControl = class(TdxRibbonCompositeItemControl) // for internal use
  protected
    function GetCompositeViewInfoClass: TdxBarItemControlViewInfoClass; override;
    function GetErrorWhenEmbedIntoDropDownWindow: string; override;
  end;

  { TdxRibbonSkinSelectorControlViewInfo }

  TdxRibbonSkinSelectorControlViewInfo = class(TdxRibbonCompositeItemControlViewInfo) // for internal use
  protected
    function GetDefaultWidth: Integer; override;
    function NeedStub: Boolean;
    procedure DrawStub(ACanvas: TcxCanvas; ARect: TRect);
  public
    procedure DoPaint(ACanvas: TcxCanvas; ARect: TRect; APaintType: TdxBarPaintType); override;
  end;

{$ENDREGION}

{$ENDREGION}

implementation

uses
  dxRibbonSkins, dxThreading, cxVariants, dxBarAccessibility, cxAccessibility, cxControls,
  Math;

{$R dxSkinChooserGallery.res}
{$R dxRibbonSkinSelector.res}

const
  dxThisUnitName = 'dxSkinChooserGallery';
  sdxEmptyGroupName = 'Empty';
  sdxNoneSkinName = 'None';
  sdxDefaultGroupsHeaderHeight = 30;
  sdxInvalidRibbonCompositeItemParentKind = 'Invalid TdxRibbonCompositeItemControl parent kind';
  sdxSkinChooserDefaultItemSizeInMenu: TSize = (cx: 250; cy: 30);
  sdxSkinChooserMinDropDownGalleryControlHeight = 300;
  sdxSkinChooserMaxDropDownGalleryControlHeight = 600;

type
  TdxRibbonGalleryGroupHeaderAccess = class(TdxRibbonGalleryGroupHeader);
  TdxBarManagerAccess = class(TdxBarManager);
  TdxRibbonGalleryGroupItemsAccess = class(TdxRibbonGalleryGroupItems);
  TdxBarCompositeItemLinksAccess = class(TdxBarCompositeItemLinks);
  TdxBarAccess = class(TdxBar);
  TcxBarEditItemAccess = class(TcxBarEditItem);
  TcxBarEditItemControlAccess = class(TcxBarEditItemControl);
  TcxCustomEditAccess = class(TcxCustomEdit);
  TCustomdxBarControlAccess = class(TCustomdxBarControl);
  TdxBarItemControlAccess = class(TdxBarItemControl);
  TdxBarItemLinksAccess = class(TdxBarItemLinks);
  TdxRibbonGalleryGroupsAccess = class(TdxRibbonGalleryGroups);
  TdxRibbonGalleryFilterAccess = class(TdxRibbonGalleryFilter);
  TdxBarWinControlAccessibilityHelperAccess = class(TdxBarWinControlAccessibilityHelper);
  TdxRibbonOnMenuGalleryControlViewInfoAccess = class(TdxRibbonOnMenuGalleryControlViewInfo);
  TdxInMenuGalleryOptionsAccess = class(TdxInMenuGalleryOptions);
  TdxRibbonDropDownGalleryControlAccess = class(TdxRibbonDropDownGalleryControl);

{$REGION 'ChooserGalleryItem'}

function EnumResNameProc(hModule: HMODULE; lpszType: LPCTSTR;
  lpszName: LPTSTR; AData: TdxSkinChooserGalleryItem): Boolean; stdcall;
begin
  AData.AddSkinsFromResource(hModule, lpszName);
  Result := True;
end;

{$REGION 'Options'}

{ TdxCustomChooserGalleryOptions }

constructor TdxCustomChooserGalleryOptions.Create(AOwner: TdxCustomRibbonGalleryItem);
begin
  inherited Create(AOwner);
  ItemImagePosition := gipTop;
  FMinDropDownHeight := cxInvalidSize.cy;
  FMaxDropDownHeight := cxInvalidSize.cy;
end;

procedure TdxCustomChooserGalleryOptions.Assign(ASource: TPersistent);
begin
  inherited Assign(ASource);
  if ASource is TdxCustomChooserGalleryOptions then
  begin
    GroupsHeaderHeight := TdxCustomChooserGalleryOptions(ASource).GroupsHeaderHeight;
    MinDropDownHeight := TdxCustomChooserGalleryOptions(ASource).MinDropDownHeight;
    MaxDropDownHeight := TdxCustomChooserGalleryOptions(ASource).MaxDropDownHeight;
    MinDropDownWidth := TdxCustomChooserGalleryOptions(ASource).MaxDropDownHeight;
  end;
end;

procedure TdxCustomChooserGalleryOptions.ChangeScale(M, D: Integer);
begin
  inherited ChangeScale(M, D);
  GroupsHeaderHeight := MulDiv(GroupsHeaderHeight, M, D);
  if MinDropDownHeight > 0 then
    MinDropDownHeight := MulDiv(MinDropDownHeight, M, D);
  if MaxDropDownHeight > 0 then
    MaxDropDownHeight := MulDiv(MaxDropDownHeight, M, D);
  if MinDropDownWidth > 0 then
    MinDropDownWidth := MulDiv(MinDropDownWidth, M, D);
end;

function TdxCustomChooserGalleryOptions.IsItemImagePositionStored: Boolean;
begin
  Result := ItemImagePosition <> gipTop;
end;

procedure TdxCustomChooserGalleryOptions.SetGroupsHeaderHeight(AValue: Integer);
begin
  if AValue <> FGroupsHeaderHeight then
  begin
    FGroupsHeaderHeight := AValue;
    Changed;
  end;
end;

procedure TdxCustomChooserGalleryOptions.SetMaxDropDownHeight(
  AValue: Integer);
begin
  if AValue <> FMaxDropDownHeight then
  begin
    FMaxDropDownHeight := AValue;
    Changed;
  end;
end;

procedure TdxCustomChooserGalleryOptions.SetMinDropDownHeight(AValue: Integer);
begin
  if AValue <> FMinDropDownHeight then
  begin
    FMinDropDownHeight := AValue;
    Changed;
  end;
end;

procedure TdxCustomChooserGalleryOptions.SetMinDropDownWidth(AValue: Integer);
begin
  if AValue <> FMinDropDownWidth then
  begin
    FMinDropDownWidth := AValue;
    Changed;
  end;
end;

{$ENDREGION}

{$REGION 'CustomGroupItem'}

{ TdxCustomChooserGalleryGroupItem }

constructor TdxCustomChooserGalleryGroupItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

{$ENDREGION}

{$REGION 'CustomGroup'}

function TdxCustomChooserGalleryGroupItem.GetMinItemSize(AIsInRibbon: Boolean): TSize;
var
  ABarItem: TdxCustomChooserGalleryItem;
begin
  ABarItem := GalleryItem as TdxCustomChooserGalleryItem;
  if AIsInRibbon then
    Result := ABarItem.GalleryInRibbonOptions.ItemSize.Value
  else
    Result := ABarItem.GalleryInMenuOptions.ItemSize.Value;
  if Result.cx <= 0 then
    Result.cx := cxGeometry.cxInvalidSize.cx;
  if Result.cy <= 0 then
    Result.cy := cxGeometry.cxInvalidSize.cy;
end;

{ TdxCustomChooserGalleryGroup }

function TdxCustomChooserGalleryGroup.GetGalleryItem: TdxCustomChooserGalleryItem;
begin
  if Collection <> nil then
    Result := TdxRibbonGalleryGroupsAccess(Collection as TdxRibbonGalleryGroups).GalleryItem as TdxCustomChooserGalleryItem
  else
    Result := nil;
end;

procedure TdxCustomChooserGalleryGroup.SetVisible(AValue: Boolean);
var
  AGalleryItem: TdxCustomChooserGalleryItem;

  procedure Lock;
  begin
    AGalleryItem := nil;
    if csDestroying in ComponentState then
      Exit;
    AGalleryItem := GetGalleryItem;
    AGalleryItem.LockRecreateControls;
  end;

  procedure UnLock;
  begin
    if AGalleryItem <> nil then
      AGalleryItem.UnlockRecreateControls;
  end;

begin
  if AValue = Visible then
    Exit;
  Lock; 
  try
    inherited SetVisible(AValue);
    if AGalleryItem <> nil then
      AGalleryItem.GroupVisibleChanged(Self);
  finally
    UnLock;
  end;
end;

{$ENDREGION}


{$REGION 'SkinGroupItem'}

{ TdxSkinChooserGalleryGroupItem }

constructor TdxSkinChooserGalleryGroupItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLookAndFeelStyle := lfsSkin;
  FVisible := True;
end;

function TdxSkinChooserGalleryGroupItem.GetItemName: string;
begin
  Result := SkinName;
end;

procedure TdxSkinChooserGalleryGroupItem.ApplyToLookAndFeel(ALookAndFeel: TcxLookAndFeel);
begin
  if dxIsDesignTime then
    Exit;
  ALookAndFeel.BeginUpdate;
  try
    case LookAndFeelStyle of
      lfsNative:
        ALookAndFeel.NativeStyle := True;
      lfsSkin:
        begin
          ALookAndFeel.SkinName := SkinName;
          ALookAndFeel.NativeStyle := False;
        end;
    else
      begin
        ALookAndFeel.NativeStyle := False;
        ALookAndFeel.SkinName := '';
        ALookAndFeel.Kind := cxLookAndFeelKindMap[LookAndFeelStyle];
      end;
    end;
  finally
    ALookAndFeel.EndUpdate;
  end;
end;

procedure TdxSkinChooserGalleryGroupItem.ApplyToRootLookAndFeel;
begin
  ApplyToLookAndFeel(RootLookAndFeel);
end;

function TdxSkinChooserGalleryGroupItem.GetGroup: TdxSkinChooserGalleryGroup;
begin
  Result :=  TdxSkinChooserGalleryGroup(inherited Group);
end;

{$ENDREGION}

{$REGION 'PaletteGroupItem'}

procedure TdxSkinChooserGalleryGroupItem.Hide;
begin
  FSaveGroup := Group;
  Collection := GetHiddenGroup.Items;
end;

procedure TdxSkinChooserGalleryGroupItem.SetVisible(AValue: Boolean);
begin
  if Visible <> AValue then
  begin
    FVisible := AValue;
    if AValue then
      Show
    else
      Hide;
  end;
end;

function TdxSkinChooserGalleryGroupItem.GetHiddenGroup: TdxRibbonGalleryGroup;
begin
  Result := ((Collection.ParentComponent as TdxRibbonGalleryGroup).GalleryItem as TdxSkinChooserGalleryItem).HiddenGroup;
end;

procedure TdxSkinChooserGalleryGroupItem.Show;
begin
  Collection := FSaveGroup.Items;
end;

{ TdxSkinPaletteChooserGalleryGroupItem }

function TdxSkinPaletteChooserGalleryGroupItem.GetGalleryItem: TdxSkinPaletteChooserGalleryItem;
begin
  Result := TdxSkinPaletteChooserGalleryItem(inherited GalleryItem);
end;

function TdxSkinPaletteChooserGalleryGroupItem.DontUseRibbonGlyphInDropDown: Boolean;
begin
  Result := True;
end;

procedure TdxSkinPaletteChooserGalleryGroupItem.GetActualGlyphsSize(const ADefaultSizeFor96DPI: TSize;
  out ATargetDPI: Integer; out ASizeInRibbon, ASizeInMenu: TSize);

  function GetActualSize(const ATarget, AItemIconSize: TSize; AVisible: Boolean): TSize;
  begin
    if not AVisible then
    begin
      Result := TSize.Create(0, 0);
      Exit;
    end;
    Result := ATarget;
    if AItemIconSize.cx > 0 then
      Result.cx := AItemIconSize.cx;
    if AItemIconSize.cy > 0 then
      Result.cy := AItemIconSize.cy;
  end;

var
  AScaleFactor: TdxScaleFactor;
  AGalleryItem: TdxSkinPaletteChooserGalleryItem;
begin
  AGalleryItem := GalleryItem;
  AScaleFactor := AGalleryItem.ScaleFactor;
  if AScaleFactor <> nil then
  begin
    ATargetDPI := AScaleFactor.TargetDPI;
    ASizeInRibbon := AScaleFactor.Apply(ADefaultSizeFor96DPI);
    ASizeInMenu := ASizeInRibbon;
  end
  else
  begin
    ATargetDPI := dxDefaultDPI;
    ASizeInRibbon := ADefaultSizeFor96DPI;
    ASizeInMenu := ADefaultSizeFor96DPI;
  end;
  ASizeInRibbon := GetActualSize(ASizeInRibbon, AGalleryItem.PaletteIconSizeInRibbon, AGalleryItem.PaletteIconVisibleInRibbon);
  ASizeInMenu := GetActualSize(ASizeInMenu, AGalleryItem.PaletteIconSizeInMenu, AGalleryItem.PaletteIconVisibleInMenu);
end;

function TdxSkinPaletteChooserGalleryGroupItem.GetItemName: string;
begin
  Result := PaletteName;
end;

procedure TdxSkinPaletteChooserGalleryGroupItem.AssignGlyph(ADestGlyph, ASourceTemplate: TdxSmartGlyph;
  APalette: TdxSkinColorPalette; ASize: TSize; ATargetDPI: Integer);

  function CanAssign: Boolean;
  begin
    Result := (APalette <> nil) and (ASize.cx * ASize.cy > 0) and (SkinName <> '') and (PaletteName <> '');
  end;

var
  ABitmap: TcxBitmap32;
  R: TdxRectF;
begin
  if CanAssign then
  begin
    ABitmap := TcxBitmap32.Create;
    try
      ABitmap.SetSize(ASize.Width , ASize.Height);
      R := TdxRectF.Create(0, 0, ASize.Width, ASize.Height);
      ABitmap.Clear;
      ASourceTemplate.StretchDraw(ABitmap.Canvas.Handle, R, Byte.MaxValue, APalette);
      ADestGlyph.Assign(ABitmap);
    finally
      ABitmap.Free;
    end;
  end
  else
    ADestGlyph.Clear;
  ADestGlyph.SourceDPI := ATargetDPI;
end;

procedure TdxSkinPaletteChooserGalleryGroupItem.UpdateGlyphs(ASourceTemplate: TdxSmartGlyph; APalette: TdxSkinColorPalette);
var
  ATargetDPI: Integer;
  ASizeInMenu: TSize;
  ASizeInRibbon: TSize;
begin
  GetActualGlyphsSize(ASourceTemplate.Size, ATargetDPI, ASizeInRibbon, ASizeInMenu);
  AssignGlyph(Glyph, ASourceTemplate, APalette, ASizeInRibbon, ATargetDPI);
  AssignGlyph(GlyphInDropDown, ASourceTemplate, APalette, ASizeInMenu, ATargetDPI);
end;

{$ENDREGION}

{$REGION 'PaletteGroupEmptyItem'}

{ TdxSkinPaletteChooserGalleryGroupEmptyItem }

function TdxSkinPaletteChooserGalleryGroupEmptyItem.ShowDescriptionInRibbon: Boolean;
begin
  Result := True;
end;

function TdxSkinPaletteChooserGalleryGroupEmptyItem.GetMinItemSize(AIsInRibbon: Boolean): TSize;
begin
  Result := cxGeometry.cxInvalidSize;
end;

{$ENDREGION}

{$REGION 'CustomBarItem'}

{ TdxCustomChooserGalleryItem }

constructor TdxCustomChooserGalleryItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FInternal := False;
  FUseLocalizedNames := False;
  cxLookAndFeelPaintersManager.AddListener(Self);
end;

destructor TdxCustomChooserGalleryItem.Destroy;
begin
  cxLookAndFeelPaintersManager.RemoveListener(Self);
  inherited Destroy;
end;

procedure TdxCustomChooserGalleryItem.ChangeScale(M, D: Integer);
begin
  inherited ChangeScale(M, D);
end;

function TdxCustomChooserGalleryItem.FindItemByName(const AName: string; out AItem: TdxCustomChooserGalleryGroupItem): Boolean;
var
  P: TdxRibbonGalleryGroupItem;
begin
  P := nil;
  AItem := nil;
  Result := FindItem(P,
    function(AItem: TdxRibbonGalleryGroupItem): Boolean
    begin
      Result := SameText(AName, (AItem as TdxCustomChooserGalleryGroupItem).GetItemName);
    end);
  if Result then
    AItem := P as TdxCustomChooserGalleryGroupItem;
end;

function TdxCustomChooserGalleryItem.GetSelectedGroupItemName: string;
var
  AItem: TdxCustomChooserGalleryGroupItem;
begin
  AItem := SelectedGroupItem;
  if AItem <> nil then
    Result := AItem.GetItemName
  else
    Result := '';
end;

procedure TdxCustomChooserGalleryItem.SetSelectedGroupItemName(const AValue: string);
var
  AItem: TdxCustomChooserGalleryGroupItem;
begin
  if FindItemByName(AValue, AItem) then
    SelectedGroupItem := AItem
  else
    SelectedGroupItem := nil;
end;

function TdxCustomChooserGalleryItem.GetSelectedGroupItem: TdxCustomChooserGalleryGroupItem;
begin
  Result := inherited SelectedGroupItem as TdxCustomChooserGalleryGroupItem;
end;

procedure TdxCustomChooserGalleryItem.SetSelectedGroupItem(AValue: TdxCustomChooserGalleryGroupItem);
begin
  inherited SelectedGroupItem := AValue;
end;

procedure TdxCustomChooserGalleryItem.DoBeforePopulate;
begin
//nothing to do
end;

procedure TdxCustomChooserGalleryItem.DoAfterPopulate;
begin
//nothing to do
end;

procedure TdxCustomChooserGalleryItem.DoPopulateGallery;
begin
//nothing to do
end;

procedure TdxCustomChooserGalleryItem.DoSelectedGroupItemChanged(AItem: TdxRibbonGalleryGroupItem);

  function GetName: string;
  begin
    if AItem <> nil then
      Result := (AItem as TdxCustomChooserGalleryGroupItem).GetItemName
    else
      Result := '';
  end;

begin
  inherited DoSelectedGroupItemChanged(AItem);
  DoItemSelectedChanged(TdxCustomChooserGalleryGroupItem(AItem), GetName);
end;

procedure TdxCustomChooserGalleryItem.DoItemSelectedChanged(AItem: TdxCustomChooserGalleryGroupItem; const AName: string);
begin
//nothing to do
end;

function TdxCustomChooserGalleryItem.GetValidGroupIndexByName(const AName: string): Integer;
var
  AItem: TdxRibbonGalleryGroup;
begin
  Result := 0;
  while (Result < GalleryGroups.Count) and ( not EqualGroupName(GalleryGroups[Result], AName)) do
    Inc(Result);
  if Result = GalleryGroups.Count then
  begin
    AItem := GalleryGroups.Add;
    AItem.Header.Visible := True;
    AItem.Header.Caption := AName;
    TdxRibbonGalleryGroupHeaderAccess(AItem.Header).Height :=
      (GalleryOptions as TdxCustomChooserGalleryOptions).GroupsHeaderHeight;
  end;
end;

function TdxCustomChooserGalleryItem.GetSkinManager: IdxSkinManager;
begin
  Result := dxISkinManager;
end;

procedure TdxCustomChooserGalleryItem.PainterChanged(APainter: TcxCustomLookAndFeelPainter);
begin
  if not Internal then
    PopulateGallery;
end;

function TdxCustomChooserGalleryItem.CanAutoPopulateGallery: Boolean;
begin
  Result := not IsGalleryPopulated and
    (LinkCount >= 1) and
    (BarManager <> nil) and
    not TdxBarManagerAccess(BarManager).IsLoading and
    not IsDestroying and not Internal;
end;

procedure TdxCustomChooserGalleryItem.SetBarManager(AValue: TdxBarManager);
begin
  inherited SetBarManager(AValue);
  if CanAutoPopulateGallery then
    PopulateGallery;
end;

procedure TdxCustomChooserGalleryItem.LinksChanged(AItemLink: TdxBarItemLink; AAction: TListNotification);
begin
  inherited LinksChanged(AItemLink, AAction);
  if (AAction = TListNotification.lnAdded) and
    CanAutoPopulateGallery and
    not TdxBarManagerAccess(BarManager).IsAfterLoading then
      PopulateGallery;
end;

procedure TdxCustomChooserGalleryItem.AfterLoadedInitialize;
begin
  inherited AfterLoadedInitialize;
  if CanAutoPopulateGallery then
    PopulateGallery;
end;

procedure TdxCustomChooserGalleryItem.PopulateGalleryBeginUpdate;
begin
  Inc(FLockPopulateGalleryCount);
end;

procedure TdxCustomChooserGalleryItem.PopulateGalleryEndUpdate(ACancel: Boolean = False);
begin
  Dec(FLockPopulateGalleryCount);
  if (FLockPopulateGalleryCount = 0) and FPopulateGalleryNeeded then
    try
      if not ACancel then
        PopulateGallery;
    finally
      FPopulateGalleryNeeded := False;
    end;
end;

function TdxCustomChooserGalleryItem.CanPopulateGallery: Boolean;
begin
  Result := not IsDesigning and 
    (BarManager <> nil) and not TdxBarManagerAccess(BarManager).IsLoading and not IsDestroying;
end;

function TdxCustomChooserGalleryItem.UseGroupItemSizeInRibbon: Boolean;
begin
  Result := True;
end;

procedure TdxCustomChooserGalleryItem.PopulateGallery;
begin
  if FIsGalleryPopulating or not CanPopulateGallery then
    Exit;
  if FLockPopulateGalleryCount > 0 then
  begin
    FPopulateGalleryNeeded := True;
    Exit;
  end;
  FIsGalleryPopulating := True;
  try
    FPopulateGalleryNeeded := False;
    DoPopulateGallery;
    FIsGalleryPopulated := True;
  finally
    FIsGalleryPopulating := False;
  end;
end;

function TdxCustomChooserGalleryItem.GetGalleryGroupClass: TdxRibbonGalleryGroupClass;
begin
  Result := TdxCustomChooserGalleryGroup;
end;

procedure TdxCustomChooserGalleryItem.GroupVisibleChanged(AGroup: TdxCustomChooserGalleryGroup);
begin
  DoGroupVisibleChanged(AGroup);
end;

procedure TdxCustomChooserGalleryItem.DoGroupVisibleChanged(AGroup: TdxCustomChooserGalleryGroup);
begin
  if FGroupVisibleChanging then
    Exit;
  FGroupVisibleChanging := True;
  try
    if Assigned(FOnGroupVisibleChanged) then
      FOnGroupVisibleChanged(Self, AGroup);
  finally
    FGroupVisibleChanging := False;
  end;
end;

procedure TdxCustomChooserGalleryItem.GetVisibleGroups(AList: TStrings);
var
  I: Integer;
  AGroup: TdxRibbonGalleryGroup;
  AName: string;
begin
 AList.BeginUpdate;
 try
   AList.Clear;
   for I := 0 to GalleryGroups.Count - 1 do
   begin
     AGroup := GalleryGroups.Items[I];
     if AGroup.Visible then
     begin
       AName := GetGroupName(AGroup);
       if AName <> '' then
         AList.Add(AName);
     end;
   end;
 finally
   AList.EndUpdate;
 end;
end;

function TdxCustomChooserGalleryItem.GetGroupName(AGroup: TdxRibbonGalleryGroup): string;
begin
  Result := AGroup.Caption;
end;

function TdxCustomChooserGalleryItem.EqualGroupName(AGroup: TdxRibbonGalleryGroup; const AName: string): Boolean;
begin
  Result := AnsiUpperCase(AGroup.Caption) = AnsiUpperCase(AName);
end;

procedure TdxCustomChooserGalleryItem.SetGroupsVisible(AList: TStrings);
var
  AUniqueGroups: TdxHashSet<TObject>;

  function FindUniqueGroupByName(const AName: string): TdxRibbonGalleryGroup;
  var
    I: Integer;
    AItem: TdxRibbonGalleryGroup;
  begin
    for I := 0 to GalleryGroups.Count - 1 do
    begin
      AItem := GalleryGroups[I];
      if not AUniqueGroups.Contains(AItem) and (AName <> '') and EqualGroupName(AItem, AName) then
      begin
        Result := AItem;
        AUniqueGroups.Include(Result);
        Exit;
      end;
    end;
    Result := nil;
  end;

var
  AItem: TdxRibbonGalleryGroup;
  I: Integer;
begin
  if (AList.Count = 0) or FGroupVisibleChanging then
    Exit;

  FGroupVisibleChanging := True;
  try
    GalleryBeginUpdate;
    try
      AUniqueGroups := TdxHashSet<TObject>.Create(AList.Count);
      try
        for I := 0 to GalleryGroups.Count - 1 do
          GalleryGroups[I].Visible := False;
        for I := 0 to AList.Count - 1 do
        begin
          AItem := FindUniqueGroupByName(AnsiUpperCase(AList[I]));
          if AItem <> nil then
            AItem.Visible := True;
        end;
      finally
        AUniqueGroups.Free;
      end;
    finally
      GalleryEndUpdate;
    end;
  finally
   FGroupVisibleChanging := False;
  end;
end;

function TdxCustomChooserGalleryItem.FindFirstBestItem: TdxCustomChooserGalleryGroupItem;
begin
  Result := nil;
  if (GalleryGroups.Count > 0) and (GalleryGroups.Items[0].Items.Count > 0) then
    Result := GalleryGroups.Items[0].Items[0] as TdxCustomChooserGalleryGroupItem;
end;

{$ENDREGION}

{$REGION 'CustomBarItemControl'}

{ TdxCustomChooserGalleryControl }

function TdxCustomChooserGalleryControl.CanDropDown: Boolean;
begin
  Result := True;
  if Item is TdxCustomChooserGalleryItem then
    Result := not (TdxCustomChooserGalleryItem(Item).Internal and TdxCustomChooserGalleryItem(Item).IsDesigning);
end;

{$ENDREGION}

{$REGION 'PaletteBarItem'}

{ TdxSkinPaletteChooserGalleryItem }

constructor TdxSkinPaletteChooserGalleryItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPaletteIconSizeInMenu := TSize.Empty;
  FPaletteIconSizeInRibbon := TSize.Empty;
  FPaletteIconVisibleInMenu := True;
  FPaletteIconVisibleInRibbon := True;
end;

destructor TdxSkinPaletteChooserGalleryItem.Destroy;
begin
  FreeAndNil(FGeneralPaletteGlyph);
  FreeAndNil(FWXIPaletteGlyph);
  inherited Destroy;
end;

procedure TdxSkinPaletteChooserGalleryItem.ChangeScale(M, D: Integer);
begin
  inherited ChangeScale(M, D);
  FPaletteIconSizeInMenu := cxSizeScale(FPaletteIconSizeInMenu, M, D);
  FPaletteIconSizeInRibbon := cxSizeScale(FPaletteIconSizeInRibbon, M, D);
  UpdatePaletteItemGlyphs;
end;

function TdxSkinPaletteChooserGalleryItem.GetScaleFactor: TdxScaleFactor;
begin
  Result := TdxBarItemLinksAccess(GetItemLinks).ScaleFactor;
end;

procedure TdxSkinPaletteChooserGalleryItem.SetPaletteImageParameters(const AIconSizeInRibbon, AIconSizeInMenu: TSize;
  AIconVisibleInRibbon, AIconVisibleInMenu: Boolean);
var
  ANeedUpdate: Boolean;
begin
  ANeedUpdate := (FPaletteIconSizeInMenu <> AIconSizeInMenu) or
    (FPaletteIconSizeInRibbon <> AIconSizeInRibbon) or
    (FPaletteIconVisibleInMenu <> AIconVisibleInMenu) or
    (FPaletteIconVisibleInRibbon <> AIconVisibleInRibbon);

  FPaletteIconSizeInMenu := AIconSizeInMenu;
  FPaletteIconSizeInRibbon := AIconSizeInRibbon;
  FPaletteIconVisibleInMenu := AIconVisibleInMenu;
  FPaletteIconVisibleInRibbon := AIconVisibleInRibbon;

  if ANeedUpdate and IsGalleryPopulated and CanPopulateGallery then
    if LockPopulateGalleryCount > 0 then
      PopulateGallery  
    else
      UpdatePaletteItemGlyphs;
end;

procedure TdxSkinPaletteChooserGalleryItem.UpdatePaletteItemGlyphs;

  function GetPalette(AItem: TdxSkinPaletteChooserGalleryGroupItem; APalettes: TStringList): TdxSkinColorPalette;
  var
    AIndex: Integer;
  begin
    AIndex := APalettes.IndexOf(AItem.PaletteName);
    if AIndex >= 0 then
      Result := APalettes.Objects[AIndex] as TdxSkinColorPalette
    else
      Result := nil;
  end;

  procedure UpdateGlyphs(AItem: TdxSkinPaletteChooserGalleryGroupItem; APalettes: TStringList);
  begin
    AItem.UpdateGlyphs(GetTemplateGlyphBySkinName(AItem.SkinName), GetPalette(AItem, APalettes));
  end;

var
  I: Integer;
  APalettes: TStringList;
  AItems: TList;
begin
  if SkinManager = nil then
    Exit;
  APalettes := TStringList.Create;
  AItems := TList.Create;
  try
    SkinManager.PopulateSkinColorPalettes(APalettes);
    GetAllItems(AItems);
    GalleryBeginUpdate;
    try
      for I := 0 to AItems.Count - 1 do
        UpdateGlyphs(TdxSkinPaletteChooserGalleryGroupItem(AItems.List[I]), APalettes);
    finally
      GalleryEndUpdate;
    end;
  finally
    APalettes.Free;
    AItems.Free;
  end;
end;

function TdxSkinPaletteChooserGalleryItem.FindPalette(const APaletteName: string;
  out AItem: TdxSkinPaletteChooserGalleryGroupItem): Boolean;
var
  AGroupItem: TdxCustomChooserGalleryGroupItem;
begin
  Result := FindItemByName(APaletteName, AGroupItem);
  if Result then
    AItem := AGroupItem as TdxSkinPaletteChooserGalleryGroupItem;
end;

procedure TdxSkinPaletteChooserGalleryItem.DoItemSelectedChanged(AItem: TdxCustomChooserGalleryGroupItem; const AName: string);
begin
  if (AItem <> nil) and Assigned(FOnPaletteChanged) then
    FOnPaletteChanged(Self, AItem.SkinName, AName);
end;

function TdxSkinPaletteChooserGalleryItem.CanAddPalette(const ASkinName: string; AColorPalette: TdxSkinColorPalette): Boolean;
begin
  Result := True;
  if Assigned(FOnAddPalette) then
    FOnAddPalette(Self, ASkinName, AColorPalette, Result);
end;

function TdxSkinPaletteChooserGalleryItem.DoPopulate(const ASkinName: string): Boolean;
begin
  Result := False;
  if Assigned(FOnPopulate) then
    FOnPopulate(Self, ASkinName, Result);
end;

procedure TdxSkinPaletteChooserGalleryItem.DoPopulateGallery;

  procedure InternalPopulateGallery(const ASkinName: string);
  var
    APalette: TdxSkinColorPalette;
    AList: TStringList;
    I: Integer;
  begin
    AList := TStringList.Create;
    try
      SkinManager.PopulateSkinColorPalettes(AList);
      I := AList.IndexOf(SkinManager.GetDefaultColorPaletteName);
      if I > 0 then
        AList.Move(I, 0);
      for I := 0 to AList.Count - 1 do
      begin
        APalette := AList.Objects[I] as TdxSkinColorPalette;
        if CanAddPalette(ASkinName, APalette) then
          AddPalette(ASkinName, APalette);
      end;
    finally
      AList.Free;
    end;
  end;

var
  ASkinName: string;
  ASelectedPaletteName: string;
begin
  if SkinManager = nil then
  begin
    GalleryGroups.Clear;
    Exit;
  end;
  ASelectedPaletteName := SelectedPaletteName;
  try
    GalleryBeginUpdate;
    try
      GalleryGroups.Clear;
      DoBeforePopulate;
      try
        SkinManager.GetActiveSkinName(ASkinName);
        if not DoPopulate(ASkinName) then
          InternalPopulateGallery(ASkinName);
      finally
        DoAfterPopulate;
      end;
    finally
      GalleryEndUpdate;
    end;
  finally
    if ASelectedPaletteName <> '' then
      SelectedPaletteName := ASelectedPaletteName;
  end;
end;

function TdxSkinPaletteChooserGalleryItem.AddPalette(const ASkinName, APaletteName, APaletteGroupName: string): TdxSkinPaletteChooserGalleryGroupItem;
begin
  Result := GalleryCategories[GetValidGroupIndexByName(APaletteGroupName)].Items.Add as TdxSkinPaletteChooserGalleryGroupItem;
  Result.GlyphInDropDown.SourceDPI := dxDefaultDPI;
  Result.Glyph.SourceDPI := dxDefaultDPI;
  Result.SkinName := ASkinName;
  Result.PaletteName := APaletteName;
end;

function TdxSkinPaletteChooserGalleryItem.AddPalette(const ASkinName: string; APalette: TdxSkinColorPalette): TdxSkinPaletteChooserGalleryGroupItem;
var
  ADisplayPaletteName: string;
  ADisplayPaletteGroupName: string;
begin
  ADisplayPaletteGroupName := '';
  ADisplayPaletteName := '';
  if UseLocalizedNames then
    SkinManager.GetLocalizedPaletteInfo(ASkinName, APalette.Name, ADisplayPaletteName, ADisplayPaletteGroupName)
  else
  begin
    ADisplayPaletteName := APalette.Name;
    ADisplayPaletteGroupName := SkinManager.GetDefaultPaletteGroupName;
  end;
  Result := AddPalette(ASkinName, APalette.Name, ADisplayPaletteGroupName);
  Result.Caption := ADisplayPaletteName;
  Result.UpdateGlyphs(GetTemplateGlyphBySkinName(ASkinName), APalette);
end;

procedure TdxSkinPaletteChooserGalleryItem.AddEmptyItem(const ACaption, ADescription: string);
var
  AItem: TdxSkinPaletteChooserGalleryGroupEmptyItem;
  AGroup: TdxRibbonGalleryGroup;
begin
  GalleryBeginUpdate;
  try
    GalleryOptions.LongDescriptionDefaultRowCount := 1;
    GalleryOptions.ColumnCount := 1;
    AGroup := GalleryCategories[GetValidGroupIndexByName(sdxEmptyGroupName)];
    AGroup.Options.ItemImagePosition := gipTop;
    AGroup.Options.ItemTextAlignVert := vaCenter;
    AGroup.Options.ItemTextKind := itkCaptionAndDescription;
    AItem:= TdxSkinPaletteChooserGalleryGroupEmptyItem.Create(AGroup.Items.ParentComponent.Owner);
    AItem.Enabled := False;
    AItem.Caption := ACaption;
    AItem.Description := ADescription;
    AItem.Collection := AGroup.Items;
  finally
    GalleryEndUpdate;
  end;
end;

function TdxSkinPaletteChooserGalleryItem.GetErrorCanPlaceText: string;
begin
  Result := cxGetResourceString(@dxSBAR_CANTPLACEPALETTECHOOSERGALLERY);
end;

function TdxSkinPaletteChooserGalleryItem.GetGalleryOptions: TdxSkinPaletteChooserGalleryOptions;
begin
  Result := inherited GalleryOptions as TdxSkinPaletteChooserGalleryOptions;
end;

function TdxSkinPaletteChooserGalleryItem.GetGalleryOptionsClass: TCustomdxRibbonGalleryOptionsClass;
begin
  Result := TdxSkinPaletteChooserGalleryOptions;
end;

function TdxSkinPaletteChooserGalleryItem.GetGroupItemClass: TdxGalleryItemClass;
begin
  Result := TdxSkinPaletteChooserGalleryGroupItem;
end;

class function TdxSkinPaletteChooserGalleryItem.GetNewCaption: string;
begin
  Result := cxGetResourceString(@dxSBAR_NEWSKINPALETTECHOOSERGALLERYITEMCAPTION);
end;

function TdxSkinPaletteChooserGalleryItem.CreateTemplateGlyph(const AResName: string): TdxSmartGlyph;
begin
  Result := TdxSmartGlyph.Create;
  try
    Result.LoadFromResource(HInstance, AResName, RT_RCDATA);
  except
    FreeAndNil(Result);
    raise;
  end;
end;

function TdxSkinPaletteChooserGalleryItem.IsWXIBasedSkin(const ASkinName: string): Boolean;
begin
  Result := ((SkinManager <> nil) and SkinManager.IsAdvancedActivePainter) or (ASkinName = dxSkinNames.TdxSkinNames.TWXI.ID);
end;

function TdxSkinPaletteChooserGalleryItem.GetGeneralPaletteGlyph: TdxSmartGlyph;
begin
  if FGeneralPaletteGlyph = nil then
    FGeneralPaletteGlyph := CreateTemplateGlyph('SKINCHOOSERGALLERYPALETTEGALLERY');
  Result := FGeneralPaletteGlyph;
end;

function TdxSkinPaletteChooserGalleryItem.GetWXIPaletteGlyph: TdxSmartGlyph;
begin
  if FWXIPaletteGlyph = nil then
    FWXIPaletteGlyph := CreateTemplateGlyph('SKINCHOOSERGALLERYPALETTEGALLERYWXI');
  Result := FWXIPaletteGlyph;
end;

function TdxSkinPaletteChooserGalleryItem.GetTemplateGlyphBySkinName(const ASkinName: string): TdxSmartGlyph;
begin
  if IsWXIBasedSkin(ASkinName) then
    Result := GetWXIPaletteGlyph
  else
    Result := GetGeneralPaletteGlyph;
end;

procedure TdxSkinPaletteChooserGalleryItem.SetGalleryOptions(
  AValue: TdxSkinPaletteChooserGalleryOptions);
begin
  GalleryOptions.Assign(AValue);
end;

function TdxSkinPaletteChooserGalleryItem.GetSelectedPaletteName: string;
begin
  Result := SelectedGroupItemName;
end;

procedure TdxSkinPaletteChooserGalleryItem.SetSelectedPaletteName(const AValue: string);
begin
  SelectedGroupItemName := AValue;
end;

function TdxSkinPaletteChooserGalleryItem.GetSelectedGroupItem: TdxSkinPaletteChooserGalleryGroupItem;
begin
  Result := TdxSkinPaletteChooserGalleryGroupItem(inherited SelectedGroupItem);
end;

procedure TdxSkinPaletteChooserGalleryItem.SetSelectedGroupItem(AValue: TdxSkinPaletteChooserGalleryGroupItem);
begin
  inherited SelectedGroupItem := AValue
end;

function TdxSkinPaletteChooserGalleryItem.GetFirstPaletteName: string;
var
  AItem: TdxSkinPaletteChooserGalleryGroupItem;
begin
  AItem := FindFirstBestItem as TdxSkinPaletteChooserGalleryGroupItem;
  if AItem <> nil then
    Result := AItem.PaletteName
  else
    Result := '';
end;

{$ENDREGION}

{$REGION 'SkinBarItem'}

{ TdxSkinChooserGalleryItem }

constructor TdxSkinChooserGalleryItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSkinIconSize := sis16;
  FSkinIconSizeInDropDown := sis48;
  FVisibleLookAndFeelStyles := [lfsSkin];
end;

function TdxSkinChooserGalleryItem.AddSkin(ASkinDetails: TdxSkinDetails): TdxSkinChooserGalleryGroupItem;
var
  ADisplaySkinName, ADisplaySkinGroupName, ASkinGroupName: string;
begin
  ADisplaySkinName := '';
  ADisplaySkinGroupName := '';
  ASkinGroupName := '';
  if UseLocalizedNames then
  begin
    if not SkinManager.GetLocalizedSkinInfo(ASkinDetails.Name, ADisplaySkinName, ADisplaySkinGroupName, ASkinGroupName) then
    begin
      if ADisplaySkinGroupName = '' then
       ADisplaySkinGroupName := ASkinDetails.GroupName;
      if ADisplaySkinName = '' then
        ADisplaySkinName := ASkinDetails.DisplayName;
      if ASkinGroupName = '' then
       ASkinGroupName := ADisplaySkinGroupName;
    end;
  end
  else
  begin
    ADisplaySkinGroupName := ASkinDetails.GroupName;
    ADisplaySkinName := ASkinDetails.DisplayName;
    ASkinGroupName := ADisplaySkinGroupName;
  end;
  if ADisplaySkinGroupName = '' then
    ADisplaySkinGroupName := SkinManager.GetDefaultSkinGroupName;
  Result := AddSkin(ASkinDetails.Name, ASkinGroupName);
  if Result.Group.ItemCount = 1 then
  begin
    Result.Group.GroupID := ASkinGroupName;
    Result.Group.Header.Caption := ADisplaySkinGroupName;
  end
  else
  begin
  end;
  Result.Caption := ADisplaySkinName;
  Result.GlyphInDropDown.Assign(ASkinDetails.Icons[SkinIconSizeInDropDown]); 
  Result.Glyph.Assign(ASkinDetails.Icons[SkinIconSize]);
end;

function TdxSkinChooserGalleryItem.AddSkin(const ASkinName, AGroupName: string): TdxSkinChooserGalleryGroupItem;
begin
  Result := GalleryCategories[GetValidGroupIndexByName(AGroupName)].Items.Add as TdxSkinChooserGalleryGroupItem;
  Result.OriginalIndex := Result.Index;
  Result.GlyphInDropDown.SourceDPI := dxDefaultDPI;
  Result.Glyph.SourceDPI := dxDefaultDPI;
  Result.SkinName := ASkinName;
  if Result.Group.ItemCount = 1 then
    Result.Group.GroupID := AGroupName;
end;

procedure TdxSkinChooserGalleryItem.AddSkinsFromFile(const AFileName: string);
var
  AStream: TStream;
begin
  AStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  try
    AddSkinsFromStream(AStream, AFileName, 0);
  finally
    AStream.Free;
  end;
end;

procedure TdxSkinChooserGalleryItem.AddSkinsFromResource(AInstance: HINST; const AResourceName: string);
var
  AStream: TStream;
begin
  AStream := TResourceStream.Create(AInstance, AResourceName, sdxResourceType);
  try
    AddSkinsFromStream(AStream, AResourceName, AInstance);
  finally
    AStream.Free;
  end;
end;

procedure TdxSkinChooserGalleryItem.AddSkinsFromResources(AInstance: HINST);
begin
  if AInstance = 0 then
    Exit;
  GalleryBeginUpdate;
  try
    GalleryGroups.BeginUpdate;
    try
      Windows.EnumResourceNames(AInstance, PChar(sdxResourceType), @EnumResNameProc, LPARAM(Self));
    finally
      GalleryGroups.EndUpdate;
    end;
  finally
    GalleryEndUpdate;
  end;
end;

procedure TdxSkinChooserGalleryItem.AddSkinsFromStream(
  AStream: TStream; const ASkinResName: string; ASkinResInstance: HINST);
var
  AItem: TdxSkinChooserGalleryGroupItem;
  AReader: TdxSkinBinaryReader;
  I: Integer;
begin
  GalleryBeginUpdate;
  try
    GalleryGroups.BeginUpdate;
    try
      AReader := TdxSkinBinaryReader.Create(AStream);
      try
        for I := 0 to AReader.Count - 1 do
          if CanAddSkin(nil, AReader.SkinDetails[I]) then
          begin
            AItem := AddSkin(AReader.SkinDetails[I]);
            AItem.SkinResInstance := ASkinResInstance;
            AItem.SkinResName := ASkinResName;
          end;
      finally
        AReader.Free;
      end;
    finally
      GalleryGroups.EndUpdate;
    end;
  finally
    GalleryEndUpdate;
  end;
end;

function TdxSkinChooserGalleryItem.FindSkin(const ASkinName: string; out AItem: TdxSkinChooserGalleryGroupItem): Boolean;
var
  AGroupItem: TdxCustomChooserGalleryGroupItem;
begin
  Result := FindItemByName(ASkinName, AGroupItem);
  if Result then
    AItem := AGroupItem as TdxSkinChooserGalleryGroupItem;
end;

function TdxSkinChooserGalleryItem.GetFirstSkinName: string;
var
  AItem: TdxSkinChooserGalleryGroupItem;
begin
  AItem := FindFirstBestItem as TdxSkinChooserGalleryGroupItem;
  if AItem <> nil then
    Result := AItem.SkinName
  else
    Result := '';
end;

procedure TdxSkinChooserGalleryItem.DoItemSelectedChanged(AItem: TdxCustomChooserGalleryGroupItem; const AName: string);
begin
  if Assigned(FOnSkinChanged) then
    FOnSkinChanged(Self, AName);
end;

function TdxSkinChooserGalleryItem.DoPopulate: Boolean;
begin
  Result := Assigned(FOnPopulate);
  if Result then
    FOnPopulate(Self);
end;

procedure TdxSkinChooserGalleryItem.DoPopulateGallery;

  procedure InternalPopulateSkinsGallery;
  var
    APainter: TcxCustomLookAndFeelPainter;
    ASkinDetails: TdxSkinDetails;
    I: Integer;
  begin
    for I := 0 to cxLookAndFeelPaintersManager.Count - 1 do
    begin
      APainter := cxLookAndFeelPaintersManager[I];
      if APainter.GetPainterDetails(ASkinDetails) and CanAddSkin(APainter, ASkinDetails) then
        AddSkin(ASkinDetails).LookAndFeelStyle := APainter.LookAndFeelStyle;
    end;
  end;

var
  ASelectedSkinName: string;
begin
  ASelectedSkinName := SelectedSkinName;
  try
    GalleryBeginUpdate;
    try
      GalleryGroups.Clear;
      DoBeforePopulate;
      try
        FHiddenGroup := GalleryGroups.Add;
        FHiddenGroup.Visible := False;
        FHiddenGroup.Header.Visible := False;
        if not DoPopulate then
          InternalPopulateSkinsGallery;
      finally
        DoAfterPopulate;
      end;
    finally
      GalleryEndUpdate;
    end;
  finally
    if ASelectedSkinName <> '' then
      SelectedSkinName := ASelectedSkinName;
  end;
end;

function TdxSkinChooserGalleryItem.InternalFiltering(APainter: TcxCustomLookAndFeelPainter; ASkinDetails: TdxSkinDetails): Boolean;
begin
  Result := ASkinDetails.GroupName <> '';
  if APainter <> nil then
    Result := Result and (APainter.LookAndFeelStyle in VisibleLookAndFeelStyles) and not APainter.IsInternalPainter;
end;

function TdxSkinChooserGalleryItem.CanAddSkin(APainter: TcxCustomLookAndFeelPainter; ASkinDetails: TdxSkinDetails): Boolean;
begin
  Result := InternalFiltering(APainter, ASkinDetails);
  if Result and Assigned(FOnAddSkin) then
    FOnAddSkin(Self, ASkinDetails, Result);
end;

function TdxSkinChooserGalleryItem.GetErrorCanPlaceText: string;
begin
  Result := cxGetResourceString(@dxSBAR_CANTPLACESKINCHOOSERGALLERY);
end;

function TdxSkinChooserGalleryItem.GetGroupItemClass: TdxGalleryItemClass;
begin
  Result := TdxSkinChooserGalleryGroupItem;
end;

function TdxSkinChooserGalleryItem.GetGalleryGroupClass: TdxRibbonGalleryGroupClass;
begin
  Result := TdxSkinChooserGalleryGroup;
end;

function TdxSkinChooserGalleryItem.GetGalleryOptionsClass: TCustomdxRibbonGalleryOptionsClass;
begin
  Result := TdxSkinChooserGalleryOptions;
end;

class function TdxSkinChooserGalleryItem.GetNewCaption: string;
begin
  Result := cxGetResourceString(@dxSBAR_NEWSKINCHOOSERGALLERYITEMCAPTION);
end;

function TdxSkinChooserGalleryItem.GetMinDropDownGalleryControlSize: TSize;
begin
  Result.cx := Max(GalleryOptions.MinDropDownWidth, GalleryOptions.ItemSize.Width);
  Result.cy := GalleryOptions.MinDropDownHeight;
end;

function TdxSkinChooserGalleryItem.GetMaxDropDownGalleryControlSize: TSize;
begin
  Result.cx := cxInvalidSize.cx;
  Result.cy := GalleryOptions.MaxDropDownHeight;
end;

function TdxSkinChooserGalleryItem.GetGalleryOptions: TdxSkinChooserGalleryOptions;
begin
  Result := inherited GalleryOptions as TdxSkinChooserGalleryOptions;
end;

function TdxSkinChooserGalleryItem.GetSelectedGroupItem: TdxSkinChooserGalleryGroupItem;
begin
  Result := inherited SelectedGroupItem as TdxSkinChooserGalleryGroupItem;
end;

procedure TdxSkinChooserGalleryItem.SetGalleryOptions(AValue: TdxSkinChooserGalleryOptions);
begin
  GalleryOptions.Assign(AValue);
end;

procedure TdxSkinChooserGalleryItem.SetSelectedGroupItem(AValue: TdxSkinChooserGalleryGroupItem);
begin
  inherited SelectedGroupItem := AValue;
end;

function TdxSkinChooserGalleryItem.GetSelectedSkinName: string;
begin
  Result := SelectedGroupItemName;
end;

procedure TdxSkinChooserGalleryItem.SetSelectedSkinName(const AValue: string);
begin
  SelectedGroupItemName := AValue;
end;

procedure TdxSkinChooserGalleryItem.SetSkinIconSize(AValue: TdxSkinIconSize);
begin
  if AValue <> FSkinIconSize then
  begin
    FSkinIconSize := AValue;
    PopulateGallery;
  end;
end;

procedure TdxSkinChooserGalleryItem.SetSkinIconSizeInDropDown(AValue: TdxSkinIconSize);
begin
  if AValue <> FSkinIconSizeInDropDown then
  begin
    FSkinIconSizeInDropDown := AValue;
    PopulateGallery;
  end;
end;

procedure TdxSkinChooserGalleryItem.SetVisibleLookAndFeelStyles(AValue: TcxLookAndFeelStyles);
begin
  if FVisibleLookAndFeelStyles <> AValue then
  begin
    FVisibleLookAndFeelStyles := AValue;
    PopulateGallery;
  end;
end;

function TdxSkinChooserGalleryItem.IsSkinIconSizeInDropDownStored: Boolean;
begin
  Result := FSkinIconSizeInDropDown <> sis48;
end;

function TdxSkinChooserGalleryItem.IsSkinIconSizeStored: Boolean;
begin
  Result := FSkinIconSize <> sis16;
end;

procedure TdxSkinChooserGalleryItem.ShowPopupGroupFilter(const AScreenPoint: TPoint);
begin
  TdxRibbonGalleryFilterAccess(GalleryFilter).Show(AScreenPoint);
end;

function TdxSkinChooserGalleryItem.IgnoreHeaderForGroupVisibility: Boolean;
begin
  Result := True;
end;

function TdxSkinChooserGalleryItem.FindFirstBestItem: TdxCustomChooserGalleryGroupItem;

  function GetItem(AVisibleGroup, AVisibleItem, AIgnoreHiddenGroup: Boolean): TdxSkinChooserGalleryGroupItem;

    function IsValidGroup(AGroup: TdxSkinChooserGalleryGroup): Boolean;
    begin
      if (HiddenGroup <> nil) and (AGroup = HiddenGroup) then
        Result := not AIgnoreHiddenGroup
      else
        Result := (AGroup <> nil) and (not AVisibleGroup or AGroup.Visible);
    end;

    function IsValidItem(AItem: TdxSkinChooserGalleryGroupItem): Boolean;
    begin
      Result := (AItem <> nil) and (not AVisibleItem or AItem.Visible);
    end;
    
  var
    I, J: Integer;
    AGroup: TdxSkinChooserGalleryGroup;
    AItem: TdxSkinChooserGalleryGroupItem;
  begin
    Result := nil;
    for I := 0 to GalleryGroups.Count - 1 do
    begin
      AGroup := GalleryGroups[I] as TdxSkinChooserGalleryGroup;
      if IsValidGroup(AGroup) then
        for J := 0 to AGroup.Items.Count - 1 do
        begin
          AItem := AGroup.Items[J] as TdxSkinChooserGalleryGroupItem;
          if IsValidItem(AItem) then
            Exit(AItem);
        end;
    end;
  end;

begin
  Result := GetItem(True, True, True); 
  if Result = nil then
    Result := GetItem(True, False, True); 
  if Result = nil then
    Result := GetItem(False, False, True); 
  if Result = nil then
    Result := GetItem(False, False, False); 
end;

function TdxSkinChooserGalleryItem.GetGroupName(AGroup: TdxRibbonGalleryGroup): string;
begin
  Result := (AGroup as TdxSkinChooserGalleryGroup).GroupID;
end;

function TdxSkinChooserGalleryItem.EqualGroupName(AGroup: TdxRibbonGalleryGroup; const AName: string): Boolean;
begin
  Result := AnsiUpperCase((AGroup as TdxSkinChooserGalleryGroup).GroupID) = AnsiUpperCase(AName);
end;

function TdxSkinChooserGalleryItem.CanShowGroupInFilterMenu(AGroupIndex: Integer; AIgnoreVisibleProperty: Boolean = False): Boolean;
begin
  Result := FHiddenGroup <> GalleryGroups[AGroupIndex];
end;

procedure TdxSkinChooserGalleryItem.ItemsFilter(const ASourceText: string);

  procedure RestoreSequenceOfItems;
  var
   I: Integer;
  begin
    for I := 0 to GalleryGroups.Count - 1 do
    begin
      if GalleryGroups[I] = HiddenGroup then
        Continue;
      GalleryGroups[I].Items.CustomSort(
        function (const AItem1, AItem2: TcxComponentCollectionItem): Integer
         begin
           Result := TdxSkinChooserGalleryGroupItem(AItem1).OriginalIndex -
             TdxSkinChooserGalleryGroupItem(AItem2).OriginalIndex;
         end);
    end;
  end;

var
 AList: TList;
 I: Integer;
 AItem: TdxSkinChooserGalleryGroupItem;
 AText: string;
begin
  AText := AnsiUpperCase(Trim(ASourceText));
  LockRecreateControls;
  try
    GalleryBeginUpdate;
    try
      AList := TList.Create;
      try
        GetAllItems(AList);
        for I := 0 to AList.Count - 1 do
        begin
          AItem := TdxSkinChooserGalleryGroupItem(AList.List[I]);
          AItem.Visible := (AText = '') or AnsiUpperCase(AItem.Caption).Contains(ASourceText);
        end;
        RestoreSequenceOfItems;
      finally
        AList.Free;
      end;
    finally
      GalleryEndUpdate;
    end;
  finally
    UnlockRecreateControls;
  end;
end;

{$ENDREGION}

{$ENDREGION}

{$REGION 'RibbonCompositeItem'}

{ TdxRibbonCompositeItem }

constructor TdxRibbonCompositeItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FScaleFactor := TdxScaleFactor.Create;
end;

destructor TdxRibbonCompositeItem.Destroy;
begin
  FreeAndNil(FScaleFactor);
  inherited Destroy;
end;

procedure TdxRibbonCompositeItem.ChangeScale(M, D: Integer);
begin
  inherited ChangeScale(M, D);
  FScaleFactor.Change(M, D);
end;

class function TdxRibbonCompositeItem.GetNewCaption: string;
begin
  Result := cxGetResourceString(@dxSBAR_NEWRIBBONCOMPOSITEITEMCAPTION);
end;

function TdxRibbonCompositeItem.CanBePlacedOn(
  AParentKind: TdxBarItemControlParentKind; AToolbar: TdxBar;
  out AErrorText: string): Boolean;
begin
  Result := inherited CanBePlacedOn(AParentKind, AToolbar, AErrorText) or
    GetBarControlClass(AToolbar).InheritsFrom(TdxRibbonCustomBarControl);
  if not Result then
    AErrorText := GetErrorCanPlaceText;
end;

function TdxRibbonCompositeItem.GetErrorCanPlaceText: string;
begin
  Result := cxGetResourceString(@dxSBAR_CANTPLACERIBBONCOMPOSITEITEM);
end;

{ TdxRibbonCompositeItemControl }

function TdxRibbonCompositeItemControl.GetVisibleChildCount: Integer;
begin
  if ItemLinks = nil then
    Result := 0
  else
    Result := ItemLinks.CanVisibleItemCount;
end;

function TdxRibbonCompositeItemControl.GetVisibleChild(AIndex: Integer): TdxBarItemControl;
begin
  Result := ItemLinks.CanVisibleItems[AIndex].Control;
end;

function TdxRibbonCompositeItemControl.GetItem: TdxRibbonCompositeItem;
begin
  Result := TdxRibbonCompositeItem(inherited Item);
end;

function TdxRibbonCompositeItemControl.GetViewInfo: TdxRibbonCompositeItemControlViewInfo;
begin
  Result := TdxRibbonCompositeItemControlViewInfo(inherited ViewInfo);
end;

function TdxRibbonCompositeItemControl.GetViewInfoClass: TdxBarItemControlViewInfoClass;
begin
  case Parent.Kind of
    bkSubMenu:
      raise EdxException.Create(GetErrorWhenEmbedIntoDropDownWindow);
    bkBarControl:
      Result := GetCompositeViewInfoClass;
  else
    raise EdxException.Create(sdxInvalidRibbonCompositeItemParentKind);
  end;
end;

function TdxRibbonCompositeItemControl.GetErrorWhenEmbedIntoDropDownWindow: string;
begin
  Result := cxGetResourceString(@dxSBAR_CANTPLACERIBBONCOMPOSITEITEMCONTROLFORSUBMENU);
end;

function TdxRibbonCompositeItemControl.GetCompositeViewInfoClass: TdxBarItemControlViewInfoClass;
begin
  Result := TdxRibbonCompositeItemControlViewInfo;
end;

{ TdxRibbonCompositeItemControlViewInfo }

constructor TdxRibbonCompositeItemControlViewInfo.Create(AControl: TdxBarItemControl);
begin
  inherited Create(AControl);
  FCachedWidths := TList.Create;
  FCachedWidths.Capacity := ChildCount;
  FCollapsedChildIndex := -1;
  FColumnCount := -1;
  FMaxColumnCount := -1;
end;

destructor TdxRibbonCompositeItemControlViewInfo.Destroy;
begin
  FreeAndNil(FCachedWidths);
  inherited Destroy;
end;

procedure TdxRibbonCompositeItemControlViewInfo.ResetCachedValues;
var
  I: Integer;
begin
  inherited ResetCachedValues;
  FCollapsedChildIndex := -1;
  FCanCollapse := False;
  if FCachedWidths <> nil then
    FCachedWidths.Count := 0;
  for I := 0 to ChildCount - 1 do
    GetObjectChild(I).ResetCachedValues;
end;

function TdxRibbonCompositeItemControlViewInfo.GetChildrenCount: Integer;
begin
  Result := Control.VisibleChildCount;
end;

function TdxRibbonCompositeItemControlViewInfo.GetWidthIndent: Integer;
begin
  Result := Control.ScaleFactor.Apply(DefaultWidthIndent);
end;

function TdxRibbonCompositeItemControlViewInfo.GetHeightIndent: Integer;
begin
  Result := 0;
end;

function TdxRibbonCompositeItemControlViewInfo.GetDefaultWidth: Integer;
begin
  Result := Control.ScaleFactor.Apply(DefaultEmptyWidth);
end;

function TdxRibbonCompositeItemControlViewInfo.GetChild(AIndex: Integer): IdxBarItemControlViewInfo;
begin
  Result := Control.VisibleChildren[AIndex].ViewInfo;
end;

function TdxRibbonCompositeItemControlViewInfo.GetObjectChild(AIndex: Integer): TdxBarItemControlViewInfo;
begin
  Result := Control.VisibleChildren[AIndex].ViewInfo;
end;

function TdxRibbonCompositeItemControlViewInfo.GetControl: TdxRibbonCompositeItemControl;
begin
  Result := inherited Control as TdxRibbonCompositeItemControl;
end;

procedure TdxRibbonCompositeItemControlViewInfo.DoRightToLeftConversion(const ABounds: TRect);
var
  I: Integer;
  AItemViewInfo: IdxBarItemControlViewInfo;
begin
  for I := 0 to ChildCount - 1 do
  begin
    AItemViewInfo := GetChild(I);
    AItemViewInfo.SetBounds(TdxRightToLeftLayoutConverter.ConvertRect(AItemViewInfo.GetBounds, ABounds));
  end;
end;

function TdxRibbonCompositeItemControlViewInfo.GetCompositeItemWidth(AViewLevel: TdxBarItemRealViewLevel): Integer;
var
  I, AWidth, ACount: Integer;
  AItem: IdxBarItemControlViewInfo;
begin
  FCachedWidths.Count := 0;
  ACount := ChildCount;
  if ACount = 0 then
    Exit(GetDefaultWidth);
  if FCachedWidths.Capacity < ACount then
    FCachedWidths.Capacity := ACount;
  Result := GetWidthIndent;
  for I := 0 to ACount - 1 do
  begin
    AItem := GetChild(I);
    AWidth := AItem.GetWidth(AViewLevel);
    FCachedWidths.Add(Pointer(AWidth));
    Inc(Result, AWidth);
    Inc(Result, GetWidthIndent);
  end;
  Inc(Result, GetWidthIndent);
end;

procedure TdxRibbonCompositeItemControlViewInfo.SetCompositeItemBounds(const AValue: TRect);
var
  I, ALeft: Integer;
  AItem: IdxBarItemControlViewInfo;
  ABounds: TRect;
begin
  ALeft := AValue.Left + GetWidthIndent;
  for I := 0 to FCachedWidths.Count - 1 do
  begin
    AItem := GetChild(I);
    ABounds := ABounds.Create(ALeft, AValue.Top + GetHeightIndent, ALeft + Integer(FCachedWidths[I]), AValue.Bottom - GetHeightIndent);
    AItem.SetBounds(ABounds);
    Inc(ALeft, Integer(FCachedWidths[I]));
    Inc(ALeft, GetWidthIndent);
  end;
end;

procedure TdxRibbonCompositeItemControlViewInfo.CompositeItemOffsetContent(AOffset: Integer);
var
  I: Integer;
  AItem: IdxBarItemControlViewInfo;
  ABounds: TRect;
begin
  for I := 0 to FCachedWidths.Count - 1 do
  begin
    AItem := GetChild(I);
    ABounds := AItem.GetBounds;
    OffsetRect(ABounds, AOffset, 0);
    AItem.SetBounds(ABounds);
  end;
end;

function TdxRibbonCompositeItemControlViewInfo.CompositeItemAtPos(const APos: TPoint): TdxBarItemControl;
var
  I: Integer;
  AItem: IdxBarItemControlViewInfo;
begin
  if Control.BarManager.IsCustomizing or Control.BarManager.IsDesigning then
    Exit(Control);
  Result := nil;
  for I := 0 to ChildCount - 1 do
  begin
    AItem := GetChild(I);
    if AItem.GetBounds.Contains(APos) then
      Exit(AItem.GetControl);
  end;
end;

function TdxRibbonCompositeItemControlViewInfo.UpdateItemLinksBounds: Boolean;

  function UpdateBounds: Boolean;
  var
    I: Integer;
    AControl: TdxBarItemControl;
  begin
    TdxBarCompositeItemLinksAccess(Control.ItemLinks).BeginCalcItemRects;
    try
      Result := False;
      for I := 0 to ChildCount - 1 do
      begin
        AControl := GetChild(I).GetControl;
        Result := Result or not EqualRect(AControl.ItemLink.ItemRect, AControl.ViewInfo.Bounds);
        AControl.ItemLink.ItemRect := AControl.ViewInfo.Bounds;
      end;
    finally
      TdxBarCompositeItemLinksAccess(Control.ItemLinks).EndCalcItemRects;
    end;
  end;
begin
  Result := UpdateBounds;
end;

procedure TdxRibbonCompositeItemControlViewInfo.InitializeChildren;

  procedure InitializeColumnCount;
  var
    I: Integer;
    AMultiColumnItemControlViewInfo: IdxBarMultiColumnItemControlViewInfo;
  begin
    FMaxColumnCount := 0;
    for I := 0 to GetChildrenCount - 1 do
    begin
      Inc(FMaxColumnCount);
      if GetChild(I).IsMultiColumnItemControl(False, AMultiColumnItemControlViewInfo)
        and AMultiColumnItemControlViewInfo.CanCollapse and not AMultiColumnItemControlViewInfo.GetCollapsed then
          Inc(FMaxColumnCount, AMultiColumnItemControlViewInfo.GetColumnCount - AMultiColumnItemControlViewInfo.GetMinColumnCount);
    end;
    FColumnCount := FMaxColumnCount;
  end;

  procedure InitializeCollapsed;
  begin
    InitializeColumnCount;
    FCollapsedChildIndex := ChildCount - 1;
    FColumnCountChildIndex := FCollapsedChildIndex;
    FCanCollapse := True;
  end;

  procedure InitializeViewLevel;
  const
    ValidViewLevels = [ivlLargeIconWithText, ivlLargeControlOnly]; 

    function GetValidViewLevel(AViewLevel: TdxBarItemViewLevel): TdxBarItemViewLevel;
    begin
      Result := AViewLevel;
    end;

    function GetValidViewLevels(AViewLevels: TdxBarItemViewLevels): TdxBarItemViewLevel;
    begin
      AViewLevels := AViewLevels * ValidViewLevels;
      Result := GetMaxViewLevel(AViewLevels);
    end;

  var
    I: Integer;
    AItemControlViewInfo: IdxBarItemControlViewInfo;
    AMultiColumnItemControlViewInfo: IdxBarMultiColumnItemControlViewInfo;
  begin
    for I := 0 to ChildCount - 1 do
    begin
      AItemControlViewInfo := GetChild(I);

      if AItemControlViewInfo.GetRealPositionInButtonGroup = bgrpNone then
        AItemControlViewInfo.SetViewLevel(GetValidViewLevels(AItemControlViewInfo.GetAllowedViewLevels))
      else
        AItemControlViewInfo.SetViewLevel(GetValidViewLevel(AItemControlViewInfo.GetViewLevelForButtonGroup));

      if AItemControlViewInfo.IsMultiColumnItemControl(False, AMultiColumnItemControlViewInfo) then
      begin
        AMultiColumnItemControlViewInfo.SetCollapsed(False);
        AMultiColumnItemControlViewInfo.SetColumnCount(AMultiColumnItemControlViewInfo.GetMaxColumnCount);
      end;
    end;
  end;

  procedure InitializeBounds;
  var
    I: Integer;
  begin
    for I := 0 to ChildCount - 1 do
      GetChild(I).SetBounds(cxEmptyRect);
  end;

begin
  InitializeBounds;
  InitializeViewLevel;
  InitializeCollapsed;
end;

function TdxRibbonCompositeItemControlViewInfo.CanCollapse: Boolean;
var
  ACount: Integer;
begin
  ACount := GetChildrenCount;
  Result := (ACount > 0) and FCanCollapse and ((FCollapsedChildIndex >= 0) and (FCollapsedChildIndex < ACount));
end;

function TdxRibbonCompositeItemControlViewInfo.GetCollapsed: Boolean;
begin
  Result := not CanCollapse;
end;

function TdxRibbonCompositeItemControlViewInfo.GetColumnCount: Integer;
begin
  Result := FColumnCount;
end;

function TdxRibbonCompositeItemControlViewInfo.GetMaxColumnCount: Integer;
begin
  Result := FMaxColumnCount;
end;

function TdxRibbonCompositeItemControlViewInfo.GetMinColumnCount: Integer;
begin
  Result := GetChildrenCount;
end;

function TdxRibbonCompositeItemControlViewInfo.GetWidthForColumnCount(AColumnCount: Integer): Integer;
begin
  Result := 0;
end;

procedure TdxRibbonCompositeItemControlViewInfo.SetCollapsed(AValue: Boolean);
var
  AMultiColumnItemControlViewInfo: IdxBarMultiColumnItemControlViewInfo;
begin
  if not AValue or not CanCollapse then
    Exit;
  try
    while FCollapsedChildIndex >= 0 do
    begin
      if GetChild(FCollapsedChildIndex).IsMultiColumnItemControl(True, AMultiColumnItemControlViewInfo) and
        AMultiColumnItemControlViewInfo.CanCollapse then
      begin
        AMultiColumnItemControlViewInfo.SetCollapsed(True);
        Dec(FCollapsedChildIndex);
        Exit;
      end;
      Dec(FCollapsedChildIndex);
    end;
  finally
    FCanCollapse := FCollapsedChildIndex >= 0;
  end;
end;

procedure TdxRibbonCompositeItemControlViewInfo.SetColumnCount(AValue: Integer);
var
  AMultiColumnItemControlViewInfo: IdxBarMultiColumnItemControlViewInfo;
begin
  if FColumnCount = AValue then 
    Exit;
  Dec(FColumnCount);
  while FColumnCountChildIndex >= 0 do
  begin
    if GetChild(FColumnCountChildIndex).IsMultiColumnItemControl(True, AMultiColumnItemControlViewInfo) and
      (AMultiColumnItemControlViewInfo.GetColumnCount > AMultiColumnItemControlViewInfo.GetMinColumnCount) then
    begin
      AMultiColumnItemControlViewInfo.SetColumnCount(AMultiColumnItemControlViewInfo.GetColumnCount - 1);
      Exit;
    end;
    Dec(FColumnCountChildIndex);
  end;
end;

procedure TdxRibbonCompositeItemControlViewInfo.BoundsCalculated;
var
  I: Integer;
begin
  for I := 0 to FCachedWidths.Count - 1 do
    GetChild(I).CalculateFinalize;
end;

{$ENDREGION}

{$REGION 'SkinSelector'}

{$REGION 'Options'}

{$REGION 'Base'}

{ TdxRibbonSkinSelectorBaseOptions }

constructor TdxRibbonSkinSelectorBaseOptions.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  BeginUpdate;
  try
    Initialize;
  finally
    CancelUpdate;
  end;
end;

procedure TdxRibbonSkinSelectorBaseOptions.ChangeScale(M, D: Integer);
begin
  BeginUpdate;
  try
    DoChangeScale(M, D);
  finally
    CancelUpdate; 
  end;
end;

procedure TdxRibbonSkinSelectorBaseOptions.CancelUpdate;
begin
  inherited CancelUpdate;
end;

procedure TdxRibbonSkinSelectorBaseOptions.DoChangeScale(M, D: Integer);
begin
// nothing to do
end;

procedure TdxRibbonSkinSelectorBaseOptions.Initialize;
begin
// nothing to do
end;

{ TdxRibbonSkinSelectorOwnerOptions }

procedure TdxRibbonSkinSelectorOwnerOptions.DoChanged;
begin
  if OwnerOptions <> nil then
    OwnerOptions.Changed;
end;

function TdxRibbonSkinSelectorOwnerOptions.GetOwnerOptions: TdxRibbonSkinSelectorOwnerOptions;
begin
  Result := Owner as TdxRibbonSkinSelectorOwnerOptions;
end;

{$ENDREGION}

{$REGION 'Internal Root'}

{ TdxRibbonSkinSelectorRootOptions }

destructor TdxRibbonSkinSelectorRootOptions.Destroy;
begin
  FreeAndNil(FSkinChooser);
  FreeAndNil(FPaletteChooser);
  inherited Destroy;
end;

procedure TdxRibbonSkinSelectorRootOptions.Initialize;
begin
  inherited Initialize;
  FChanges := [];
  FSkinChooser := TdxRibbonSkinSelectorSkinChooserOptions.Create(Self);
  FPaletteChooser := TdxRibbonSkinSelectorPaletteChooserOptions.Create(Self);
end;

procedure TdxRibbonSkinSelectorRootOptions.DoChangeScale(M, D: Integer);
begin
  FSkinChooser.ChangeScale(M, D);
  FPaletteChooser.ChangeScale(M, D);
end;

function TdxRibbonSkinSelectorRootOptions.GetSkinSelector: TdxRibbonSkinSelector;
begin
  Result := Owner as TdxRibbonSkinSelector;
end;

procedure TdxRibbonSkinSelectorRootOptions.DoAssign(ASource: TPersistent);
var
  AOptions: TdxRibbonSkinSelectorRootOptions;
begin
  if ASource is TdxRibbonSkinSelectorRootOptions then
  begin
     AOptions := TdxRibbonSkinSelectorRootOptions(ASource);
     SkinChooser.Assign(AOptions.SkinChooser);
     PaletteChooser.Assign(AOptions.PaletteChooser);
  end;
  inherited DoAssign(ASource);
end;

procedure TdxRibbonSkinSelectorRootOptions.ChooserOptionsChanged(AOption: TdxRibbonSkinSelectorOwnerOptions);
begin
  if AOption = SkinChooser then
    PropertyChanged(TdxRibbonSkinSelectorChange.SkinChooserProperties)
  else
    if AOption = PaletteChooser then
      PropertyChanged(TdxRibbonSkinSelectorChange.PaletteChooserProperties);
end;

procedure TdxRibbonSkinSelectorRootOptions.PropertyChanged(AChange: TdxRibbonSkinSelectorChange);
begin
  Include(FChanges, AChange);
  Changed;
end;

procedure TdxRibbonSkinSelectorRootOptions.DoChanged;
var
  AChanges: TdxRibbonSkinSelectorChanges;
begin
  if FChanges <> [] then
  begin
    AChanges := FChanges;
    FChanges := [];
    SkinSelector.SkinSelectorChanged(AChanges);
  end;
end;

procedure TdxRibbonSkinSelectorRootOptions.CancelUpdate;
begin
  inherited CancelUpdate;
  if not IsLocked then
    FChanges := [];
end;

procedure TdxRibbonSkinSelectorRootOptions.SetPaletteChooser(AValue: TdxRibbonSkinSelectorPaletteChooserOptions);
begin
  FPaletteChooser.Assign(AValue);
end;

procedure TdxRibbonSkinSelectorRootOptions.SetSkinChooser(AValue: TdxRibbonSkinSelectorSkinChooserOptions);
begin
  FSkinChooser.Assign(AValue);
end;

{$ENDREGION}

{$REGION 'Places'}

{$REGION 'Custom Place'}

{ TdxRibbonSkinSelectorCustomPlaceOptions }

destructor TdxRibbonSkinSelectorCustomPlaceOptions.Destroy;
begin
  FreeAndNil(FItemSize);
  inherited Destroy;
end;

procedure TdxRibbonSkinSelectorCustomPlaceOptions.Initialize;
begin
  inherited Initialize;
  FShowItemCaption := False;
  FResizeMode := TdxRibbonGallerySubmenuResizing.gsrNone;
  FItemIconVisible := True;
  FCanCollapse := True;
  FCollapsed := False;
  FColumnCount := 1;
  FMinColumnCount := 1;
  FItemSize := TcxItemSize.Create(Self, TSize.Empty);
  FItemSize.OnChange := DefaultChangesHandler;
end;

function TdxRibbonSkinSelectorCustomPlaceOptions.GetOwnerOptions: TdxRibbonSkinSelectorCustomChooserOptions;
begin
  Result := Owner as TdxRibbonSkinSelectorCustomChooserOptions;
end;

procedure TdxRibbonSkinSelectorCustomPlaceOptions.DoAssign(ASource: TPersistent);
var
  AOptions: TdxRibbonSkinSelectorCustomPlaceOptions;
begin
  if ASource is TdxRibbonSkinSelectorCustomPlaceOptions then
  begin
    AOptions := TdxRibbonSkinSelectorCustomPlaceOptions(ASource);
    ShowItemCaption := AOptions.ShowItemCaption;
    ResizeMode := AOptions.ResizeMode;
    ItemIconVisible := AOptions.ItemIconVisible;
    CanCollapse := AOptions.CanCollapse;
    Collapsed := AOptions.Collapsed;
    ColumnCount := AOptions.ColumnCount;
    MinColumnCount := AOptions.MinColumnCount;
    ItemSize.Assign(AOptions.ItemSize);
  end;
  inherited DoAssign(ASource);
end;

procedure TdxRibbonSkinSelectorCustomPlaceOptions.DoChangeScale(M, D: Integer);
begin
  inherited DoChangeScale(M, D);
  ItemSize.ChangeScale(M, D);
end;

procedure TdxRibbonSkinSelectorCustomPlaceOptions.DefaultChangesHandler(Sender: TObject);
begin
  Changed;
end;

function TdxRibbonSkinSelectorCustomPlaceOptions.IsItemSizeStored: Boolean;
begin
  Result := not ItemSize.Value.IsZero;
end;

procedure TdxRibbonSkinSelectorCustomPlaceOptions.SetCanCollapse(AValue: Boolean);
begin
  if FCanCollapse <> AValue then
  begin
    FCanCollapse := AValue;
    Changed;
  end;
end;

procedure TdxRibbonSkinSelectorCustomPlaceOptions.SetCollapsed(AValue: Boolean);
begin
  if FCollapsed <> AValue then
  begin
    FCollapsed := AValue;
    Changed;
  end;
end;

procedure TdxRibbonSkinSelectorCustomPlaceOptions.SetColumnCount(AValue: Integer);
begin
  if FColumnCount <> AValue then
  begin
    FColumnCount := AValue;
    Changed;
  end;
end;

procedure TdxRibbonSkinSelectorCustomPlaceOptions.SetItemIconVisible(AValue: Boolean);
begin
  if FItemIconVisible <> AValue then
  begin
    FItemIconVisible := AValue;
    Changed;
  end;
end;

procedure TdxRibbonSkinSelectorCustomPlaceOptions.SetItemSize(AValue: TcxItemSize);
begin
  FItemSize.Assign(AValue);
end;

procedure TdxRibbonSkinSelectorCustomPlaceOptions.SetMinColumnCount(AValue: Integer);
begin
  if FMinColumnCount <> AValue then
  begin
    FMinColumnCount := AValue;
    Changed;
  end;
end;

procedure TdxRibbonSkinSelectorCustomPlaceOptions.SetResizeMode(AValue: TdxRibbonGallerySubmenuResizing);
begin
  if FResizeMode <> AValue then
  begin
    FResizeMode := AValue;
    Changed;
  end;
end;

procedure TdxRibbonSkinSelectorCustomPlaceOptions.SetShowItemCaption(AValue: Boolean);
begin
  if FShowItemCaption <> AValue then
  begin
    FShowItemCaption := AValue;
    Changed;
  end;
end;

{$ENDREGION}

{$REGION 'Custom Place Skin'}

{ TdxRibbonSkinSelectorCustomPlaceSkinOptions }

procedure TdxRibbonSkinSelectorCustomPlaceSkinOptions.DoAssign(ASource: TPersistent);
begin
  if ASource is TdxRibbonSkinSelectorCustomPlaceSkinOptions then
    ItemIconSize := TdxRibbonSkinSelectorCustomPlaceSkinOptions(ASource).ItemIconSize;
  inherited DoAssign(ASource);
end;

procedure TdxRibbonSkinSelectorCustomPlaceSkinOptions.Initialize;
begin
  inherited Initialize;
  FItemIconSize := sis16;
end;

procedure TdxRibbonSkinSelectorCustomPlaceSkinOptions.SetItemIconSize(AValue: TdxSkinIconSize);
begin
  if FItemIconSize <> AValue then
  begin
    FItemIconSize := AValue;
    Changed;
  end;
end;

{$ENDREGION}

{$REGION 'Custom Place Palette'}

{ TdxRibbonSkinSelectorCustomPlacePaletteOptions }

destructor TdxRibbonSkinSelectorCustomPlacePaletteOptions.Destroy;
begin
  FreeAndNil(FItemIconSize);
  inherited Destroy;
end;

procedure TdxRibbonSkinSelectorCustomPlacePaletteOptions.Initialize;
begin
  inherited Initialize;
  FItemIconSize := TcxItemSize.Create(Self, TSize.Empty);
  FItemIconSize.OnChange := DefaultChangesHandler;
end;

procedure TdxRibbonSkinSelectorCustomPlacePaletteOptions.DoAssign(ASource: TPersistent);
begin
  if ASource is TdxRibbonSkinSelectorCustomPlacePaletteOptions then
    ItemIconSize.Assign(TdxRibbonSkinSelectorCustomPlacePaletteOptions(ASource).ItemIconSize);
  inherited DoAssign(ASource);
end;

procedure TdxRibbonSkinSelectorCustomPlacePaletteOptions.DoChangeScale(M, D: Integer);
begin
  inherited DoChangeScale(M, D);
  ItemIconSize.ChangeScale(M, D);
end;

function TdxRibbonSkinSelectorCustomPlacePaletteOptions.IsItemIconSizeStored: Boolean;
begin
  Result := not ItemIconSize.Value.IsZero;
end;

procedure TdxRibbonSkinSelectorCustomPlacePaletteOptions.SetItemIconSize(AValue: TcxItemSize);
begin
  FItemIconSize.Assign(AValue);
end;

{$ENDREGION}

{$REGION 'Skin InRibbon and InMenu'}

{ TdxRibbonSkinSelectorCustomInMenuSkinOptions }

procedure TdxRibbonSkinSelectorCustomInMenuSkinOptions.Initialize;
begin
  inherited Initialize;
  FRowCount := 10;
  FSearchBoxVisible := True;
end;

procedure TdxRibbonSkinSelectorCustomInMenuSkinOptions.DoAssign(ASource: TPersistent);
var
  AOptions: TdxRibbonSkinSelectorCustomInMenuSkinOptions;
begin
  if ASource is TdxRibbonSkinSelectorCustomInMenuSkinOptions then
  begin
    AOptions := TdxRibbonSkinSelectorCustomInMenuSkinOptions(ASource);
    RowCount := AOptions.RowCount;
    SearchBoxVisible := AOptions.SearchBoxVisible;
  end;
  inherited DoAssign(ASource);
end;

procedure TdxRibbonSkinSelectorCustomInMenuSkinOptions.SetRowCount(AValue: Integer);
begin
  if FRowCount <> AValue then
  begin
    FRowCount := AValue;
    Changed;
  end;
end;

procedure TdxRibbonSkinSelectorCustomInMenuSkinOptions.SetSearchBoxVisible(AValue: Boolean);
begin
  if FSearchBoxVisible <> AValue then
  begin
    FSearchBoxVisible := AValue;
    Changed;
  end;
end;

{ TdxRibbonSkinSelectorCustomInRibbonSkinOptions }

procedure TdxRibbonSkinSelectorCustomInRibbonSkinOptions.DoAssign(ASource: TPersistent);
begin
  if ASource is TdxRibbonSkinSelectorCustomInRibbonSkinOptions then
    CollapsedIconSize := TdxRibbonSkinSelectorCustomInRibbonSkinOptions(ASource).CollapsedIconSize;
  inherited DoAssign(ASource);
end;

procedure TdxRibbonSkinSelectorCustomInRibbonSkinOptions.Initialize;
begin
  inherited Initialize;
  FCollapsedIconSize := sis48;
end;

procedure TdxRibbonSkinSelectorCustomInRibbonSkinOptions.SetCollapsedIconSize(AValue: TdxSkinIconSize);
begin
  if FCollapsedIconSize <> AValue then
  begin
    FCollapsedIconSize := AValue;
    Changed;
  end;
end;

{ TdxRibbonSkinSelectorInMenuSkinOptions }

procedure TdxRibbonSkinSelectorInMenuSkinOptions.Initialize;
begin
  inherited Initialize;
  ShowItemCaption := True;
end;

{ TdxRibbonSkinSelectorInRibbonSkinOptions }

procedure TdxRibbonSkinSelectorInRibbonSkinOptions.Initialize;
begin
  inherited Initialize;
  Collapsed := True;
  ShowItemCaption := True;
end;

{$ENDREGION}

{$REGION 'Palette InRibbon and InMenu'}

{ TdxRibbonSkinSelectorCustomInRibbonPaletteOptions }

destructor TdxRibbonSkinSelectorCustomInRibbonPaletteOptions.Destroy;
begin
  FreeAndNil(FCollapsedGlyph);
  inherited Destroy;
end;

procedure TdxRibbonSkinSelectorCustomInRibbonPaletteOptions.Initialize;
begin
  inherited Initialize;
  FCollapsedGlyph := TdxSmartGlyph.Create;
  FCollapsedGlyph.OnChange := DefaultChangesHandler;
end;

procedure TdxRibbonSkinSelectorCustomInRibbonPaletteOptions.DoAssign(ASource: TPersistent);
begin
  if ASource is TdxRibbonSkinSelectorCustomInRibbonPaletteOptions then
    CollapsedGlyph.Assign(TdxRibbonSkinSelectorCustomInRibbonPaletteOptions(ASource).CollapsedGlyph);
  inherited DoAssign(ASource);
end;

function TdxRibbonSkinSelectorCustomInRibbonPaletteOptions.IsCollapsedGlyphStored: Boolean;
begin
  Result := not CollapsedGlyph.Empty;
end;

procedure TdxRibbonSkinSelectorCustomInRibbonPaletteOptions.SetCollapsedGlyph(AValue: TdxSmartGlyph);
begin
  FCollapsedGlyph.Assign(AValue);
end;

{ TdxSkinSelectorOptions.TInMenuPaletteOptions }

procedure TdxRibbonSkinSelectorInMenuPaletteOptions.Initialize;
begin
  inherited Initialize;
  ShowItemCaption := True;
end;

{ TdxSkinSelectorOptions.TInRibbonPaletteOptions }

procedure TdxRibbonSkinSelectorInRibbonPaletteOptions.Initialize;
begin
  inherited Initialize;
  ShowItemCaption := False;
  ColumnCount := 4;
  MinColumnCount := 2;
end;

{$ENDREGION}

{$ENDREGION}

{$REGION 'Choosers'}

{$REGION 'Custom Chooser'}

{ TdxRibbonSkinSelectorBaseChooserOptions }

destructor TdxRibbonSkinSelectorBaseChooserOptions.Destroy;
begin
  FreeAndNil(FFreeNotificator);
  inherited Destroy;
end;

procedure TdxRibbonSkinSelectorBaseChooserOptions.DoChanged;
begin
  OwnerOptions.ChooserOptionsChanged(Self);
end;

procedure TdxRibbonSkinSelectorBaseChooserOptions.DoFreeNotification(AComponent: TComponent);
begin
// nothing to do
end;

function TdxRibbonSkinSelectorBaseChooserOptions.GetFreeNotificator: TcxFreeNotificator;
begin
  if FFreeNotificator = nil then
  begin
    FFreeNotificator := TcxFreeNotificator.Create(nil);
    FFreeNotificator.OnFreeNotification := DoFreeNotification;
  end;
  Result := FFreeNotificator;
end;

function TdxRibbonSkinSelectorBaseChooserOptions.GetOwnerOptions: TdxRibbonSkinSelectorRootOptions;
begin
  Result := Owner as TdxRibbonSkinSelectorRootOptions;
end;

{ TdxRibbonSkinSelectorCustomChooserOptions }

destructor TdxRibbonSkinSelectorCustomChooserOptions.Destroy;
begin
  FreeAndNil(FInMenu);
  FreeAndNil(FInRibbon);
  inherited Destroy;
end;

procedure TdxRibbonSkinSelectorCustomChooserOptions.Initialize;
begin
  inherited Initialize;
  FItemIconPosition := TdxRibbonGalleryImagePosition.gipLeft;
  FItemTextAlignVert := TcxAlignmentVert.vaCenter;
  FVisible := TdxBarItemVisible.ivAlways;
  FInMenu := GetInMenuOptionClass.Create(Self);
  FInRibbon := GetInRibbonOptionClass.Create(Self);
end;

function TdxRibbonSkinSelectorCustomChooserOptions.SkinSelectorLoaded: Boolean;
begin
  Result := (OwnerOptions <> nil) and (OwnerOptions.SkinSelector <> nil) and OwnerOptions.SkinSelector.SkinSelectorLoaded;
end;

procedure TdxRibbonSkinSelectorCustomChooserOptions.DoAssign(ASource: TPersistent);
var
  AOptions: TdxRibbonSkinSelectorCustomChooserOptions;
begin
  if ASource is TdxRibbonSkinSelectorCustomChooserOptions then
  begin
    AOptions := TdxRibbonSkinSelectorCustomChooserOptions(ASource);
    ItemIconPosition := AOptions.ItemIconPosition;
    ItemTextAlignVert := AOptions.ItemTextAlignVert;
    Visible := AOptions.Visible;
    InMenu.Assign(AOptions.InMenu);
    InRibbon.Assign(AOptions.InRibbon);
  end;
  inherited DoAssign(ASource);
end;

procedure TdxRibbonSkinSelectorCustomChooserOptions.DoChangeScale(M, D: Integer);
begin
  inherited DoChangeScale(M, D);
  InMenu.ChangeScale(M, D);
  InRibbon.ChangeScale(M, D);
end;

procedure TdxRibbonSkinSelectorCustomChooserOptions.DoFreeNotification(AComponent: TComponent);
begin
  inherited DoFreeNotification(AComponent);
  if AComponent = FScreenTip then
    FScreenTip := nil;
end;

function TdxRibbonSkinSelectorCustomChooserOptions.DoGetScreenTip: TdxScreenTip;
begin
  Result := FScreenTip;
  if Assigned(FOnGetScreenTip) then
    FOnGetScreenTip(Self, Result);
end;

procedure TdxRibbonSkinSelectorCustomChooserOptions.SetHint(const AValue: string);
begin
  if FHint <> AValue then
  begin
    FHint := AValue;
    Changed;
  end;
end;

procedure TdxRibbonSkinSelectorCustomChooserOptions.SetItemIconPosition(AValue: TdxRibbonGalleryImagePosition);
begin
  if FItemIconPosition <> AValue then
  begin
    FItemIconPosition := AValue;
    Changed;
  end;
end;

procedure TdxRibbonSkinSelectorCustomChooserOptions.SetItemTextAlignVert(AValue: TcxAlignmentVert);
begin
  if FItemTextAlignVert <> AValue then
  begin
    FItemTextAlignVert := AValue;
    Changed;
  end;
end;

procedure TdxRibbonSkinSelectorCustomChooserOptions.SetKeyTip(const AValue: string);
begin
  if FKeyTip <> AValue then
  begin
    FKeyTip := AValue;
    Changed;
  end;
end;

procedure TdxRibbonSkinSelectorCustomChooserOptions.SetScreenTip(AValue: TdxScreenTip);
begin
  if FScreenTip <> AValue then
  begin
    if FScreenTip <> nil then
      FreeNotificator.RemoveSender(FScreenTip);
    FScreenTip := AValue;
    if FScreenTip <> nil then
      FreeNotificator.AddSender(FScreenTip);
  end;
end;

procedure TdxRibbonSkinSelectorCustomChooserOptions.SetVisible(AValue: TdxBarItemVisible);
begin
  if FVisible <> AValue then
  begin
    FVisible := AValue;
    Changed;
  end;
end;

{$ENDREGION}

{$REGION 'SkinChooser'}

{ TdxRibbonSkinSelectorSkinChooserOptions }

procedure TdxRibbonSkinSelectorSkinChooserOptions.DoAssign(ASource: TPersistent);
begin
  if ASource is TdxRibbonSkinSelectorSkinChooserOptions then
  begin
    VisibleLookAndFeelStyles := TdxRibbonSkinSelectorSkinChooserOptions(ASource).VisibleLookAndFeelStyles;
    VisibleGroups := TdxRibbonSkinSelectorSkinChooserOptions(ASource).VisibleGroups;
  end;
  inherited DoAssign(ASource);
end;

function TdxRibbonSkinSelectorSkinChooserOptions.GetInMenuOptionClass: TdxRibbonSkinSelectorOwnerOptionsClass;
begin
  Result := TdxRibbonSkinSelectorInMenuSkinOptions;
end;

function TdxRibbonSkinSelectorSkinChooserOptions.GetInMenuOptions: TdxRibbonSkinSelectorInMenuSkinOptions;
begin
  Result := inherited InMenu as TdxRibbonSkinSelectorInMenuSkinOptions;
end;

function TdxRibbonSkinSelectorSkinChooserOptions.GetInRibbonOptionClass: TdxRibbonSkinSelectorOwnerOptionsClass;
begin
  Result := TdxRibbonSkinSelectorInRibbonSkinOptions;
end;

function TdxRibbonSkinSelectorSkinChooserOptions.GetInRibbonOptions: TdxRibbonSkinSelectorInRibbonSkinOptions;
begin
  Result := inherited InRibbon as TdxRibbonSkinSelectorInRibbonSkinOptions;
end;

procedure TdxRibbonSkinSelectorSkinChooserOptions.Initialize;
begin
  inherited Initialize;
  FVisibleLookAndFeelStyles := [lfsSkin];
  FVisibleGroups := [TdxSkinGroup.Vector];
end;

procedure TdxRibbonSkinSelectorSkinChooserOptions.SetInMenuOptions(AValue: TdxRibbonSkinSelectorInMenuSkinOptions);
begin
  InMenu.Assign(AValue);
end;

procedure TdxRibbonSkinSelectorSkinChooserOptions.SetInRibbonOptions(AValue: TdxRibbonSkinSelectorInRibbonSkinOptions);
begin
  InRibbon.Assign(AValue);
end;

procedure TdxRibbonSkinSelectorSkinChooserOptions.SetVisibleLookAndFeelStyles(AValue: TcxLookAndFeelStyles);
begin
  if FVisibleLookAndFeelStyles <> AValue then
  begin
    FVisibleLookAndFeelStyles := AValue;
    Changed;
  end;
end;

procedure TdxRibbonSkinSelectorSkinChooserOptions.SetVisibleGroups(AValue: TdxSkinGroups);
begin
  if FVisibleGroups <> AValue then
  begin
    FVisibleGroups := AValue;
    if SkinSelectorLoaded then
      OwnerOptions.SkinSelector.Controller.UpdateSkinVisibleGroups;
  end;
end;

procedure TdxRibbonSkinSelectorSkinChooserOptions.UpdateVisibleGroups(AValue: TdxSkinGroups);
begin
  FVisibleGroups := AValue;
end;

{$ENDREGION}

{$REGION 'PaletteChooser'}

{ TdxRibbonSkinSelectorPaletteChooserOptions }

function TdxRibbonSkinSelectorPaletteChooserOptions.GetInMenuOptionClass: TdxRibbonSkinSelectorOwnerOptionsClass;
begin
  Result := TdxRibbonSkinSelectorInMenuPaletteOptions;
end;

function TdxRibbonSkinSelectorPaletteChooserOptions.GetInMenuOptions: TdxRibbonSkinSelectorInMenuPaletteOptions;
begin
  Result := inherited InMenu as TdxRibbonSkinSelectorInMenuPaletteOptions;
end;

function TdxRibbonSkinSelectorPaletteChooserOptions.GetInRibbonOptionClass: TdxRibbonSkinSelectorOwnerOptionsClass;
begin
  Result := TdxRibbonSkinSelectorInRibbonPaletteOptions;
end;

function TdxRibbonSkinSelectorPaletteChooserOptions.GetInRibbonOptions: TdxRibbonSkinSelectorInRibbonPaletteOptions;
begin
  Result := inherited InRibbon as TdxRibbonSkinSelectorInRibbonPaletteOptions;
end;

procedure TdxRibbonSkinSelectorPaletteChooserOptions.Initialize;
begin
  inherited Initialize;
  ItemIconPosition := TdxRibbonGalleryImagePosition.gipTop;
end;

procedure TdxRibbonSkinSelectorPaletteChooserOptions.SetInMenuOptions(AValue: TdxRibbonSkinSelectorInMenuPaletteOptions);
begin
  InMenu.Assign(AValue);
end;

procedure TdxRibbonSkinSelectorPaletteChooserOptions.SetInRibbonOptions(AValue: TdxRibbonSkinSelectorInRibbonPaletteOptions);
begin
  InRibbon.Assign(AValue);
end;

{$ENDREGION}

{$ENDREGION}

{$ENDREGION}

{$REGION 'Loader'}

{ TdxRibbonSkinSelectorLoader }

constructor TdxRibbonSkinSelectorLoader.Create(AChooser: TdxSkinChooserGalleryItem);
begin
  inherited Create;
  FChooser := AChooser;
end;

procedure TdxRibbonSkinSelectorLoader.AddSkinsFromFile(const AFileName: string);
begin
  FChooser.AddSkinsFromFile(AFileName);
end;

procedure TdxRibbonSkinSelectorLoader.AddSkinsFromResource(AInstance: HINST; const AResourceName: string);
begin
  FChooser.AddSkinsFromResource(AInstance, AResourceName);
end;

procedure TdxRibbonSkinSelectorLoader.AddSkinsFromResources(AInstance: HINST);
begin
  FChooser.AddSkinsFromResources(AInstance);
end;

procedure TdxRibbonSkinSelectorLoader.AddSkinsFromStream(AStream: TStream; const ASkinResName: string;
  ASkinResInstance: HINST);
begin
  FChooser.AddSkinsFromStream(AStream, ASkinResName, ASkinResInstance);
end;

{ TdxRibbonSkinSelectorSetSkinHelper }

constructor TdxRibbonSkinSelectorSetSkinHelper.Create(const AManager: IdxSkinManager);
begin
  inherited Create;
  FManager := AManager;
end;

procedure TdxRibbonSkinSelectorSetSkinHelper.SetSkinFromFile(const ASkinName, AFileName: string);
begin
  FManager.SetSkinFromFile(ASkinName, AFileName);
end;

procedure TdxRibbonSkinSelectorSetSkinHelper.SetSkin(AStyle: TcxLookAndFeelStyle; const ASkinName: string);
begin
  FManager.SetSkin(AStyle, ASkinName);
end;

procedure TdxRibbonSkinSelectorSetSkinHelper.SetSkinFromResource(AInstance: THandle; const AResourceName,
  ASkinName: string);
begin
  FManager.SetSkinFromResource(AInstance, AResourceName, ASkinName);
end;

procedure TdxRibbonSkinSelectorSetSkinHelper.SetSkinFromStream(const ASkinName: string; AStream: TStream);
begin
  FManager.SetSkinFromStream(ASkinName, AStream);
end;

{ TdxRibbonSkinSelectorSetSkinArgs }

constructor TdxRibbonSkinSelectorSetSkinArgs.Create(const ASkinName, AResName: string; AResInstance: NativeUInt;
  ALookAndFeelStyle: TcxLookAndFeelStyle);
begin
  inherited Create;
  FSkinName := ASkinName;
  FResName := AResName;
  FResInstance := AResInstance;
  FLookAndFeelStyle := ALookAndFeelStyle;
end;

{$ENDREGION}

{$REGION 'Controller'}

{ TdxRibbonSkinSelectorController }

constructor TdxRibbonSkinSelectorController.Create(ASkinSelector: TdxRibbonSkinSelector);
begin
  inherited Create;
  FSkinSelector := ASkinSelector;
  FUserSkinSource := TUserSkinSource.Create;
  FSkinManager := TSkinManager.Create(Self);
  FRibbonUpdater := TRibbonSkinUpdater.Create(Self);
  FSkinManager.SubscribeToNotifications;
end;

destructor TdxRibbonSkinSelectorController.Destroy;
begin
  FSkinManager.UnsubscribeFromNotifications;
  InternalClear;
  FreeAndNil(FRibbonUpdater);
  FreeAndNil(FSkinManager);
  FreeAndNil(FUserSkinSource);
  inherited Destroy;
end;

function TdxRibbonSkinSelectorController.DoPopulateWithSkins(const ALoader: TdxRibbonSkinSelectorLoader): Boolean;
begin
  Result := SkinSelector.DoPopulateWithSkins(ALoader) or UserSkinSource.Populate(ALoader);
end;

function TdxRibbonSkinSelectorController.IsReady: Boolean;
begin
  Result := (FChooserController <> nil) and FIsReady;
end;

procedure TdxRibbonSkinSelectorController.InternalClear;
begin
  FIsReady := False;
  FreeAndNil(FChooserController);
  if not SkinSelector.IsDestroying then
    SkinSelector.ChildrenList.FreeItems;
end;

procedure TdxRibbonSkinSelectorController.Build;

  procedure DoBuild;
  begin
    FChooserController := TChooserController.Create(Self);
    try
      FChooserController.Build;
      FIsReady := True;
    except
      InternalClear;
      raise;
    end;
  end;

begin
  InternalClear;
  if not  CanBuild then
    Exit;
  DoBuild;
  UpdateSkinVisibleGroups;
  RestoreSkinValues;
end;

procedure TdxRibbonSkinSelectorController.InternalClearUserSkinSource;
begin
  UserSkinSource.Clear;
end;

procedure TdxRibbonSkinSelectorController.Refresh;
begin
  if FLockCount > 0 then
    Exit;
  Inc(FLockCount);
  try
    SkinSelector.ChildrenList.BeginUpdate;
    try
      StoreSkinValues(False);
      try
        Build;
      except
        if UsesCustomSkinSource then
        begin
          InternalClearUserSkinSource;
          if not HasPopulateEvent then
            Build;
        end;
        raise;
      end;
    finally
      SkinSelector.ChildrenList.EndUpdate;
    end;
  finally
    Dec(FLockCount);
  end;
end;

procedure TdxRibbonSkinSelectorController.RefreshSkinSelector;
begin
  SkinSelector.Refresh;
end;

procedure TdxRibbonSkinSelectorController.UpdateChooserProperties(AChooserTypes: TdxRibbonSkinSelectorChooserTypes);
begin
  if IsReady then
    FChooserController.UpdateChooserProperties(AChooserTypes);
end;

procedure TdxRibbonSkinSelectorController.UserSkinSourceChanged;
begin
  if UserSkinSource.HasData then
    RefreshSkinSelector;
end;

procedure TdxRibbonSkinSelectorController.SetSkinValues(const ANewSkinName, ANewPaletteName: string);
begin
  FSkinValuesAssignedExternally := True;
  FStoredSkinName := ANewSkinName;
  FStoredPaletteName := ANewPaletteName;
  SkinSelector.SkinSelectorChanged([TdxRibbonSkinSelectorChange.SkinValues]); 
end;

procedure TdxRibbonSkinSelectorController.SynchronizeSelectedItems;
begin
  if not SkinManager.IsPostponedUpdate then
    Exit;
  StoreSkinValues(True);
  RestoreSkinValues;
end;

procedure TdxRibbonSkinSelectorController.StoreSkinValues(AForce: Boolean);
var
  ASkinName, APaletteName: string;
begin
  if (AForce or not FSkinValuesAssignedExternally) and SkinManager.GetActiveSkinValues(ASkinName, APaletteName) then
  begin
    FStoredSkinName := ASkinName;
    FStoredPaletteName := APaletteName;
  end;
end;

procedure TdxRibbonSkinSelectorController.RestoreSkinValues;
begin
  if not IsReady then
    Exit;
  try
    FSkinValuesAssignedExternally := False;
    FChooserController.SetSkinValues(FStoredSkinName, FStoredPaletteName);
  finally
    FStoredSkinName := '';
    FStoredPaletteName := '';
  end;
end;

procedure TdxRibbonSkinSelectorController.ApplySkinValues;
begin
  RestoreSkinValues;
end;

procedure TdxRibbonSkinSelectorController.UpdateEnabled;
begin
  if IsReady then
    FChooserController.UpdateEnabled;
end;

function TdxRibbonSkinSelectorController.UsesCustomSkinSource: Boolean;
begin
   Result := not dxIsDesignTime and (UserSkinSource.HasData or HasPopulateEvent);
end;

function TdxRibbonSkinSelectorController.HasPopulateEvent: Boolean;
begin
  Result := Assigned(SkinSelector.OnPopulate);
end;

function TdxRibbonSkinSelectorController.HasSetSkinEvent: Boolean;
begin
  Result := Assigned(SkinSelector.OnSetSkin);
end;

procedure TdxRibbonSkinSelectorController.UpdateSkinVisibleGroups;
begin
  if IsReady then
    ChooserController.VisibleGroupController.UpdateFromOptions;
end;

procedure TdxRibbonSkinSelectorController.UpdateRibbons(AForce: Boolean = True);
begin
  FRibbonUpdater.Update(AForce);
end;

function TdxRibbonSkinSelectorController.CanBuild: Boolean;
begin
  Result := (SkinSelector <> nil) and not SkinSelector.IsDestroying and SkinManager.IsValid;
end;

procedure TdxRibbonSkinSelectorController.ClearUserSkinSource;
begin
  InternalClearUserSkinSource;
  RefreshSkinSelector;
end;


procedure TdxRibbonSkinSelectorController.LoadSkinsFromFile(const AFileName: string);
begin
  UserSkinSource.SingleData.UpdateFileName(AFileName);
  UserSkinSourceChanged;
end;

procedure TdxRibbonSkinSelectorController.LoadSkinsFromStream(AStream: TStream);
begin
  UserSkinSource.SingleData.UpdateStream(AStream);
  UserSkinSourceChanged;
end;

procedure TdxRibbonSkinSelectorController.LoadSkinsFromResource(AInstance: HINST; const AResourceName: string);
begin
  UserSkinSource.SingleData.UpdateResourceInstance(AInstance, AResourceName);
  UserSkinSourceChanged;
end;

procedure TdxRibbonSkinSelectorController.LoadSkinsFromResources(AInstance: HINST);
begin
  UserSkinSource.SingleData.UpdateResourcesInstance(AInstance);
  UserSkinSourceChanged;
end;

procedure TdxRibbonSkinSelectorController.AddSkinsFromFile(const AFileName: string);
begin
  UserSkinSource.AddToFileNames(AFileName);
  UserSkinSourceChanged;
end;

procedure TdxRibbonSkinSelectorController.AddSkinsFromResource(AInstance: HINST; const AResourceName: string);
begin
  UserSkinSource.AddToResourceList(AInstance, AResourceName);
  UserSkinSourceChanged;
end;

procedure TdxRibbonSkinSelectorController.AddSkinsFromResources(AInstance: HINST);
begin
  UserSkinSource.AddToResourcesList(AInstance);
  UserSkinSourceChanged;
end;

{ TdxRibbonSkinSelectorController.TSkinManagerUpdater }

constructor TdxRibbonSkinSelectorController.TSkinManagerUpdater.Create;
begin
  inherited Create;
  FList := TdxFastList.Create;
end;

destructor TdxRibbonSkinSelectorController.TSkinManagerUpdater.Destroy;
begin
  dxThreading.TdxUIThreadSyncService.Unsubscribe(Self);
  FreeAndNil(FList);
  inherited Destroy;
end;

class function TdxRibbonSkinSelectorController.TSkinManagerUpdater.Add(
  AManager: TSkinManager): Boolean;
begin
  if FInstance = nil then
    FInstance := TSkinManagerUpdater.Create;
  Result := FInstance.InternalAdd(AManager);
end;

class procedure TdxRibbonSkinSelectorController.TSkinManagerUpdater.Remove(
  AManager: TSkinManager);
begin
  if FInstance <> nil then
    FInstance.InternalRemove(AManager);
end;

class function TdxRibbonSkinSelectorController.TSkinManagerUpdater.Updating: Boolean;
begin
  if FInstance <> nil then
    Result := FInstance.FUpdating
  else
    Result := False;
end;

class procedure TdxRibbonSkinSelectorController.TSkinManagerUpdater.Finalize;
begin
  FreeAndNil(FInstance);
end;

function TdxRibbonSkinSelectorController.TSkinManagerUpdater.InternalAdd(AManager: TSkinManager): Boolean;
begin
  Result := FList.IndexOf(AManager) < 0;
  if Result then
  begin
    FList.Add(AManager);
    Update;
  end;
end;

procedure TdxRibbonSkinSelectorController.TSkinManagerUpdater.InternalRemove(
  AManager: TSkinManager);
begin
  FList.Remove(AManager);
end;

procedure TdxRibbonSkinSelectorController.TSkinManagerUpdater.Update;
begin
  if FLock or FUpdating then
    Exit;
  FLock := True;
  dxThreading.TdxUIThreadSyncService.EnqueueInvokeInUIThread(Self,
    procedure
    begin
      FUpdating := True;
      try
        InternalUpdate;
      finally
        FUpdating := False;
        FLock := False;
      end;
    end);
end;

procedure TdxRibbonSkinSelectorController.TSkinManagerUpdater.InternalUpdate;
var
  I: Integer;
begin
  try
    for I := 0 to FList.Count - 1 do
      TSkinManager(FList.List[I]).PostponedUpdateHandler;
  finally
    FList.Clear;
  end;
end;

{ TdxSkinSelectorController.TSkinManager }


constructor TdxRibbonSkinSelectorController.TSkinManager.Create(AOwner: TdxRibbonSkinSelectorController);
begin
  inherited Create;
  FOwner := AOwner;
  FInfo := dxISkinManager;
  FUpdateTypes := [];
  FSkinValuesSetter := TSkinValueSetter.Create(Self);
end;

destructor TdxRibbonSkinSelectorController.TSkinManager.Destroy;
begin
  TSkinManagerUpdater.Remove(Self);
  FreeAndNil(FSkinValuesSetter);
  FInfo := nil;
  FOwner := nil;
  inherited Destroy;
end;

procedure TdxRibbonSkinSelectorController.TSkinManager.SubscribeToNotifications;
begin
  if Info = nil then
    Exit;
  Info.AddListenerOnSkinControllerListChanged(SkinControllersNotification);
  Info.AddListenerOnSkinValuesChanged(SkinValuesChanged);
  Info.AddListenerOnPaintersChanged(PaintersNotification);
end;

procedure TdxRibbonSkinSelectorController.TSkinManager.UnsubscribeFromNotifications;
begin
  if Info = nil then
    Exit;
  Info.RemoveListenerOnSkinControllerListChanged(SkinControllersNotification);
  Info.RemoveListenerOnSkinValuesChanged(SkinValuesChanged);
  Info.RemoveListenerOnPaintersChanged(PaintersNotification);
end;

function TdxRibbonSkinSelectorController.TSkinManager.GetPaletteName: string;
begin
  if not Info.GetActiveColorPaletteName(Result) then
    Result := '';
end;

function TdxRibbonSkinSelectorController.TSkinManager.GetSkinName: string;
begin
  if not Info.GetActiveSkinName(Result) then
    Result := '';
end;

function TdxRibbonSkinSelectorController.TSkinManager.GetColorSchemeName: string;
begin
  Result := FInfo.SkinName;
end;

function TdxRibbonSkinSelectorController.TSkinManager.GetStyle: TcxLookAndFeelStyle;
begin
  Result := FInfo.Style;
end;

function TdxRibbonSkinSelectorController.TSkinManager.GetActiveSkinValues(out ASkinName, APaletteName: string): Boolean;
var
  ASkin: TdxSkin;
begin
  if not IsValid then
    Exit(False);
  Result := Info.GetActiveSkinName(ASkinName);
  if Result and not Info.GetActiveColorPaletteName(APaletteName) then
  begin
    ASkin := Info.GetActiveSkin;
    Result := (ASkin = nil) or (ASkin.ColorPalettes = nil) or (ASkin.ColorPalettes.Count = 0);
  end;
end;

function TdxRibbonSkinSelectorController.TSkinManager.IsValid: Boolean;
begin
  Result := (FInfo <> nil) and FInfo.HasSkinController;
end;

procedure TdxRibbonSkinSelectorController.TSkinManager.SetPalette(
  AItem: TdxSkinPaletteChooserGalleryGroupItem);
begin
  if dxIsDesignTime or IsPostponedUpdate then
    Exit;
  Inc(FLockCount);
  Inc(FGlobalLockCount);
  try
    FSkinValuesSetter.SetPalette(AItem);
  finally
    Dec(FGlobalLockCount);
    Dec(FLockCount);
  end;
end;

procedure TdxRibbonSkinSelectorController.TSkinManager.SetSkin(AItem: TdxSkinChooserGalleryGroupItem);
begin
  if dxIsDesignTime or IsPostponedUpdate then
    Exit;
  Inc(FLockCount);
  Inc(FGlobalLockCount);
  try
    FSkinValuesSetter.SetSkin(AItem);
  finally
    Dec(FGlobalLockCount);
    Dec(FLockCount);
  end;
end;

procedure TdxRibbonSkinSelectorController.TSkinManager.SetSkinValues(ASkin: TdxSkinChooserGalleryGroupItem; const APaletteName: string);
begin
  if dxIsDesignTime or IsPostponedUpdate then
    Exit;
  Inc(FLockCount);
  Inc(FGlobalLockCount);
  try
    FSkinValuesSetter.SetSkinValues(ASkin, APaletteName);
  finally
    Dec(FGlobalLockCount);
    Dec(FLockCount);
  end;
end;

procedure TdxRibbonSkinSelectorController.TSkinManager.SkinControllersNotification(
  ASkinControllersCount: Integer; ASkinController: TComponent; AAction: TListNotification);
begin
  if not FOwner.SkinSelector.IsDestroying then
    if ((AAction = lnAdded) and not FOwner.IsReady and (ASkinControllersCount > 0)) or
      ((AAction in [lnExtracted, lnDeleted]) and FOwner.IsReady and (ASkinControllersCount = 0)) then
        FOwner.RefreshSkinSelector;
end;

function TdxRibbonSkinSelectorController.TSkinManager.CanPerformPostponedUpdate: Boolean;
begin
  Result := (FLockCount = 0) and not FOwner.SkinSelector.IsDestroying and FOwner.IsReady;
end;

procedure TdxRibbonSkinSelectorController.TSkinManager.SkinValuesChanged(
  ALookAndFeel: TcxLookAndFeel; AChangedValues: TcxLookAndFeelValues);
const
  LookAndFeelValueAll = [Low(TcxLookAndFeelValue)..High(TcxLookAndFeelValue)]; 
begin
  if (AChangedValues = LookAndFeelValueAll) or (AChangedValues * [lfvKind, lfvNativeStyle, lfvSkinName] <> []) then
    PostponedUpdate(TSkinManagerUpdateType.SelectedItems);
end;

procedure TdxRibbonSkinSelectorController.TSkinManager.PaintersNotification(
  APainter: TcxCustomLookAndFeelPainter; AOperation: TOperation);
begin
  if FGlobalLockCount = 0 then
    PostponedUpdate(TSkinManagerUpdateType.SkinSelector);
end;

procedure TdxRibbonSkinSelectorController.TSkinManager.PostponedUpdate(AType: TSkinManagerUpdateType);
begin
 if not CanPerformPostponedUpdate then
 begin
   TSkinManagerUpdater.Remove(Self);
   FUpdateTypes := [];
   Exit;
 end;
  Include(FUpdateTypes, AType);
  TSkinManagerUpdater.Add(Self);
end;

procedure TdxRibbonSkinSelectorController.TSkinManager.PostponedUpdateHandler;
begin
  try
    if not CanPerformPostponedUpdate then
      Exit;
    if IsPostponedUpdateOfSkinSelector then
    begin
      FOwner.RefreshSkinSelector;
    end
    else
      if IsPostponedUpdateOfSelectedItems then
      begin
        FOwner.SynchronizeSelectedItems;
      end;
  finally
    FUpdateTypes := [];
  end;
end;

function TdxRibbonSkinSelectorController.TSkinManager.IsPostponedUpdateOfSelectedItems: Boolean;
begin
  Result := TSkinManagerUpdater.Updating and ([TSkinManagerUpdateType.SelectedItems] = FUpdateTypes);
end;

function TdxRibbonSkinSelectorController.TSkinManager.IsPostponedUpdateOfSkinSelector: Boolean;
begin
  Result := TSkinManagerUpdater.Updating and (TSkinManagerUpdateType.SkinSelector in FUpdateTypes);
end;

function TdxRibbonSkinSelectorController.TSkinManager.IsPostponedUpdate: Boolean;
begin
  Result := TSkinManagerUpdater.Updating;
end;

{ TdxRibbonSkinSelectorController.TSkinValueSetter }

constructor TdxRibbonSkinSelectorController.TSkinValueSetter.Create(ASkinManager: TSkinManager);
begin
  inherited Create;
  FSkinManager := ASkinManager;
end;

procedure TdxRibbonSkinSelectorController.TSkinValueSetter.SetSkinValues(ASkin: TdxSkinChooserGalleryGroupItem; const APaletteName: string);
begin
  SkinManager.Info.RootLookAndFeelBeginUpdate;
  try
    SetSkin(ASkin);
    SetPaletteName(APaletteName);
    SkinManager.Owner.UpdateRibbons(True);
  finally
    SkinManager.Info.RootLookAndFeelEndUpdate;
  end;
end;

procedure TdxRibbonSkinSelectorController.TSkinValueSetter.SetPalette(AItem: TdxSkinPaletteChooserGalleryGroupItem);
begin
  if AItem = nil then
    SetPaletteName('')
  else
    SetPaletteName(AItem.PaletteName);
end;

procedure TdxRibbonSkinSelectorController.TSkinValueSetter.SetPaletteName(AValue: string);
begin
  if AValue = '' then
    AValue := SkinManager.Info.GetDefaultColorPaletteName;
  if not SameText(SkinManager.PaletteName, AValue) then
  begin
    SkinManager.Info.PaletteName := AValue;
  end;
end;

function TdxRibbonSkinSelectorController.TSkinValueSetter.CalculateActionType(
  AItem: TdxSkinChooserGalleryGroupItem): TSkinSetActionType;

  function CanSetNative: Boolean;
  begin
    Result := SkinManager.Style <> TcxLookAndFeelStyle.lfsNative;
  end;

  function CanSetFromData: Boolean;
  begin
    Result := not SameText(SkinManager.SkinName, AItem.SkinName);
  end;

  function CanSetDefault: Boolean;
  begin
    Result := (SkinManager.Style <> AItem.LookAndFeelStyle) or not SameText(SkinManager.SkinName, AItem.SkinName);
  end;

  function IsFileName(const AName: string): Boolean;
  begin
    Result := AName <> '';
  end;

  function IsResName(const AName: string): Boolean;
  begin
    Result := AName <> '';
  end;

begin
  Result := TSkinSetActionType.None;
  if (AItem = nil) or (AItem.SkinName = '') then
  begin
    if CanSetNative then
       Result := TSkinSetActionType.SetNative;
  end
  else
    if not SkinManager.Owner.UsesCustomSkinSource then
    begin
      if CanSetDefault then
         Result := TSkinSetActionType.SetDefault;
    end
    else
      if CanSetFromData then
      begin
        if (AItem.SkinResInstance <> 0) and IsResName(AItem.SkinResName) then
          Result := TSkinSetActionType.SetFromResource
        else
          if IsFileName(AItem.SkinResName) then
            Result := TSkinSetActionType.SetFromFileName
          else
            if not SkinManager.Owner.UserSkinSource.HasListData and
              SkinManager.Owner.UserSkinSource.HasSingleData and
              (SkinManager.Owner.UserSkinSource.SingleData.Stream <> nil) then
                Result := TSkinSetActionType.SetFromSingleStream
            else
              Result := TSkinSetActionType.SetFromCustomData;
      end;
end;

function TdxRibbonSkinSelectorController.TSkinValueSetter.DoSetSkin(AItem: TdxSkinChooserGalleryGroupItem): Boolean;
var
  AArgs: TdxRibbonSkinSelectorSetSkinArgs;
  AHelper: TdxRibbonSkinSelectorSetSkinHelper;
begin
  if not SkinManager.Owner.HasSetSkinEvent then
    Exit(False);
  AArgs := TdxRibbonSkinSelectorSetSkinArgs.Create(AItem.SkinName, AItem.SkinResName, AItem.SkinResInstance, AItem.LookAndFeelStyle);
  try
    AHelper := TdxRibbonSkinSelectorSetSkinHelper.Create(SkinManager.Info);
    try
      Result := SkinManager.Owner.SkinSelector.DoSetSkin(AHelper, AArgs);
    finally
      AHelper.Free;
    end;
  finally
    AArgs.Free;
  end;
end;

procedure TdxRibbonSkinSelectorController.TSkinValueSetter.SetSkin(AItem: TdxSkinChooserGalleryGroupItem);
var
  AActionType: TSkinSetActionType;
begin
  AActionType := CalculateActionType(AItem);
  if (AActionType = TSkinSetActionType.None) or DoSetSkin(AItem) then
    Exit;
  case AActionType of
      TSkinSetActionType.SetNative: SkinManager.Info.SetSkin(TcxLookAndFeelStyle.lfsNative, '');
      TSkinSetActionType.SetDefault: SkinManager.Info.SetSkin(AItem.LookAndFeelStyle, AItem.SkinName);
      TSkinSetActionType.SetFromFileName: SkinManager.Info.SetSkinFromFile(AItem.SkinName, AItem.SkinResName);
      TSkinSetActionType.SetFromResource: SkinManager.Info.SetSkinFromResource(AItem.SkinResInstance, AItem.SkinResName, AItem.SkinName);
      TSkinSetActionType.SetFromSingleStream: SkinManager.Info.SetSkinFromStream(AItem.SkinName, SkinManager.Owner.UserSkinSource.SingleData.Stream);
  end;
end;

{ TdxRibbonSkinSelectorController.TUseSkinDataSource.TSingleSkinData }

destructor TdxRibbonSkinSelectorController.TUserSkinSource.TSingleSkinData.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function TdxRibbonSkinSelectorController.TUserSkinSource.TSingleSkinData.GetHasData: Boolean;
begin
  Result := (Stream <> nil) or (ResourceInstance <> 0) or (ResourcesInstance <> 0) or (FileName <> '');
end;


procedure TdxRibbonSkinSelectorController.TUserSkinSource.TSingleSkinData.UpdateFileName(const AFileName: string);
begin
  Clear;
  FFileName := AFileName;
end;

procedure TdxRibbonSkinSelectorController.TUserSkinSource.TSingleSkinData.UpdateResourceInstance(ASource: HINST; const AResourceName: string);
begin
  Clear;
  if (ASource <> 0) and (AResourceName <> '') then
  begin
    FResourceInstance := ASource;
    FFileName := AResourceName;
  end;
end;

procedure TdxRibbonSkinSelectorController.TUserSkinSource.TSingleSkinData.UpdateResourcesInstance(ASource: HINST);
begin
  Clear;
  FResourcesInstance := ASource;
end;

procedure TdxRibbonSkinSelectorController.TUserSkinSource.TSingleSkinData.UpdateStream(ASource: TStream);
begin
  Clear;
  if (ASource <> nil) and (ASource.Size > 0) then
  begin
    FStream := TMemoryStream.Create;
    FStream.CopyFrom(ASource, -1);
  end;
end;

procedure TdxRibbonSkinSelectorController.TUserSkinSource.TSingleSkinData.Clear;
begin
  FreeAndNil(FStream);
  FFileName := '';
  FResourceInstance := 0;
  FResourcesInstance := 0;
end;

{ TdxRibbonSkinSelectorController.TUserSkinSource.TSkinResource }

constructor TdxRibbonSkinSelectorController.TUserSkinSource.TSkinResource.Create(AInstance: HINST; const AResourceName: string);
begin
  inherited Create;
  FInstance := AInstance;
  FResourceName := AResourceName;
end;

{ TdxRibbonSkinSelectorController.TUserSkinSource }


constructor TdxRibbonSkinSelectorController.TUserSkinSource.Create;
begin
  inherited Create;
  FSingleData := TSingleSkinData.Create;
  FResourceList := TdxList<TSkinResource>.Create(True);
  FResourcesList := TList<HINST>.Create;
  FFileNames := TStringList.Create;
end;

destructor TdxRibbonSkinSelectorController.TUserSkinSource.Destroy;
begin
  FSingleData.Free;
  FResourceList.Free;
  FResourcesList.Free;
  FFileNames.Free;
  inherited Destroy;
end;

function TdxRibbonSkinSelectorController.TUserSkinSource.GetHasData: Boolean;
begin
  Result := HasSingleData or HasListData;
end;

function TdxRibbonSkinSelectorController.TUserSkinSource.GetHasListData: Boolean;
begin
  Result := (ResourceList.Count > 0) or (ResourcesList.Count > 0) or (FileNames.Count > 0);
end;

function TdxRibbonSkinSelectorController.TUserSkinSource.GetHasSingleData: Boolean;
begin
  Result := SingleData.HasData;
end;


function TdxRibbonSkinSelectorController.TUserSkinSource.Populate(const ALoader: TdxRibbonSkinSelectorLoader): Boolean;
var
  I: Integer;
begin
  Result := HasData;
  if not Result then
    Exit;
  if HasListData then
  begin
    for I := 0 to ResourcesList.Count - 1 do
      ALoader.AddSkinsFromResources(ResourcesList[I]);
    for I := 0 to ResourceList.Count - 1 do
      ALoader.AddSkinsFromResource(ResourceList[I].Instance, ResourceList[I].ResourceName);
    for I := 0 to FileNames.Count - 1 do
      ALoader.AddSkinsFromFile(FileNames[I]);
  end
  else
    if HasSingleData then
    begin
      if SingleData.Stream <> nil then
      begin
        SingleData.Stream.Position := 0;
        ALoader.AddSkinsFromStream(SingleData.Stream, '', 0);
      end
      else
        if SingleData.ResourcesInstance <> 0 then
          ALoader.AddSkinsFromResources(SingleData.ResourcesInstance)
      else
        if SingleData.ResourceInstance <> 0 then
          ALoader.AddSkinsFromResource(SingleData.ResourceInstance, SingleData.FileName)
      else
        if SingleData.FileName <> '' then
          ALoader.AddSkinsFromFile(SingleData.FileName)
    end;
end;

procedure TdxRibbonSkinSelectorController.TUserSkinSource.Clear;
begin
  SingleData.Clear;
  ResourceList.Clear;
  ResourcesList.Clear;
  FileNames.Clear;
end;

procedure TdxRibbonSkinSelectorController.TUserSkinSource.AddToFileNames(const AFileName: string);
begin
  if (AFileName <> '') and (FileNames.IndexOf(AFileName) < 0) then
    FileNames.Add(AFileName);
end;

procedure TdxRibbonSkinSelectorController.TUserSkinSource.AddToResourceList(AInstance: HINST; const AResourceName: string);

  function IndexOf: Integer;
  begin
    for Result := 0 to ResourceList.Count - 1 do
      if (AInstance = ResourceList[Result].Instance) and SameText(AResourceName, ResourceList[Result].ResourceName) then
        Exit;
    Result := -1;
  end;

begin
  if (AInstance <> 0) and (AResourceName <> '') and (IndexOf < 0) then
    ResourceList.Add(TSkinResource.Create(AInstance, AResourceName));
end;

procedure TdxRibbonSkinSelectorController.TUserSkinSource.AddToResourcesList(AInstance: HINST);
begin
  if (AInstance <> 0) and (ResourcesList.IndexOf(AInstance) < 0) then
    ResourcesList.Add(AInstance);
end;

{ TdxSkinSelectorController.TRibbonSkinUpdater }

constructor TdxRibbonSkinSelectorController.TRibbonSkinUpdater.Create(AOwner: TdxRibbonSkinSelectorController);
begin
  inherited Create;
  FOwner := AOwner;
end;

destructor TdxRibbonSkinSelectorController.TRibbonSkinUpdater.Destroy;
begin
  dxThreading.TdxUIThreadSyncService.Unsubscribe(Self);
  inherited Destroy;
end;

procedure TdxRibbonSkinSelectorController.TRibbonSkinUpdater.Update(AForce: Boolean);
begin
  if not dxIsDesignTime and (AForce or not FIsUpdated) and FOwner.SkinManager.IsValid then
  begin
    DoUpdate;
    if not FIsUpdated then
      dxThreading.TdxUIThreadSyncService.EnqueueInvokeInUIThread(Self,
        procedure
        begin
          DoUpdate;
        end);
  end;
end;

procedure TdxRibbonSkinSelectorController.TRibbonSkinUpdater.DoUpdate;
var
  I: Integer;
begin
  FIsUpdated := True;
  for I := 0 to Screen.CustomFormCount - 1 do
    UpdateRibbonColorScheme(cxFindComponent(Screen.CustomForms[I], TdxCustomRibbon) as TdxCustomRibbon);
end;

function TdxRibbonSkinSelectorController.TRibbonSkinUpdater.UpdateRibbonColorScheme(ARibbon: TdxCustomRibbon): Boolean;
const
  Prefixes: array[TdxRibbonStyle] of string = (
    'Office2007', 'Office2010', 'Office2013', 'Office2016', 'Office2016Tablet', 'Office2019Colorful'
  );
var
  AName, AName2: string;
begin
  Result :=  ARibbon <> nil;
  if not Result then
    Exit;
  if FOwner.SkinManager.Style <> lfsSkin then
    ARibbon.ColorSchemeName := 'Blue'
  else
  begin
    AName2 := FOwner.SkinManager.ColorSchemeName;
    if Copy(AName2, 1, Length(Prefixes[ARibbon.Style])) = Prefixes[ARibbon.Style] then
    begin
      AName := Copy(AName2, Length(Prefixes[ARibbon.Style]) + 1, MaxInt);
      ARibbon.ColorSchemeName := AName;
      if ARibbon.ColorSchemeName = AName then
        Exit;
    end;
    ARibbon.ColorSchemeName := AName2;
  end;
end;


{ TdxRibbonSkinSelectorController.TSkinChooserVisibleGroupController }

constructor TdxRibbonSkinSelectorController.TSkinChooserVisibleGroupController.Create(AOwner: TChooserController);
begin
  inherited Create;
  FOwner := AOwner;
  FSkinChooser:= nil;
  FOptions := FOwner.SkinSelector.SkinChooserOptions;
  FList := TStringList.Create;
  FList.CaseSensitive := False;
  FList.OnChange := ListChanged;
end;

destructor TdxRibbonSkinSelectorController.TSkinChooserVisibleGroupController.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

procedure TdxRibbonSkinSelectorController.TSkinChooserVisibleGroupController.ListChanged(Sender: TObject);
begin
  UpdateToChooser;
end;

procedure TdxRibbonSkinSelectorController.TSkinChooserVisibleGroupController.UpdateFromChooser;
begin
  if (FLockCount > 0) or (FSkinChooser = nil) then
    Exit;
  Inc(FLockCount);
  try
    FSkinChooser.GetVisibleGroups(FList);
    UpdateToOptions;
  finally
    Dec(FLockCount);
  end;
end;

procedure TdxRibbonSkinSelectorController.TSkinChooserVisibleGroupController.UpdateToChooser;
begin
  if (FLockCount > 0) or (FSkinChooser = nil) then
    Exit;
  Inc(FLockCount);
  try
    FSkinChooser.SetGroupsVisible(FList);
  finally
    Dec(FLockCount);
  end;
end;

procedure TdxRibbonSkinSelectorController.TSkinChooserVisibleGroupController.UpdateFromOptions;
begin
  dxSkinGroupsToStrings(FOptions.VisibleGroups, FList);
end;

procedure TdxRibbonSkinSelectorController.TSkinChooserVisibleGroupController.UpdateToOptions;
begin
  FOptions.UpdateVisibleGroups(dxStringsToSkinGroups(FList));
end;

{ TdxSkinSelectorController.TChooserController }

constructor TdxRibbonSkinSelectorController.TChooserController.Create(AOwner: TdxRibbonSkinSelectorController);
begin
  inherited Create;
  FOwner := AOwner;
  FVisibleGroupController := TSkinChooserVisibleGroupController.Create(Self);
end;

destructor TdxRibbonSkinSelectorController.TChooserController.Destroy;
begin
  FVisibleGroupController.SkinChooser := nil;
  dxThreading.TdxUIThreadSyncService.Unsubscribe(Self);
  DestroySubItems;
  FreeAndNil(FVisibleGroupController);
  inherited Destroy;
end;

procedure TdxRibbonSkinSelectorController.TChooserController.CreateSubItems;
begin
  FSkinChooser := TSkinChooser(CreateBarItem(TSkinChooser, True));
  FSkinChooser.Internal := True;
  FSkinChooser.UseLocalizedNames := DefaultUseLocalizedNames;
  FSearchEdit := TSearchEdit(CreateBarItem(TSearchEdit, False));
  FPaletteChooser := TPaletteChooser(CreateBarItem(TPaletteChooser, True));
  FPaletteChooser.Internal := True;
  FPaletteChooser.UseLocalizedNames := DefaultUseLocalizedNames;
end;

procedure TdxRibbonSkinSelectorController.TChooserController.DestroySubItems;
begin
  FSkinChooser := nil;
  FPaletteChooser := nil;
  FSearchEdit := nil;
end;

function TdxRibbonSkinSelectorController.TChooserController.CreateBarItem(AClass: TdxBarItemClass; ALinked: Boolean): TdxBarItem;
begin
  Result := SkinSelector.ChildrenList.Add(AClass, ALinked);
end;

function TdxRibbonSkinSelectorController.TChooserController.GetScaleFactor: TdxScaleFactor;
begin
  Result := SkinSelector.ScaleFactor;
end;

function TdxRibbonSkinSelectorController.TChooserController.IsPaletteChooserPlacedInRibbon: Boolean;
begin
  Result := SkinSelector.ChildrenList.Contains(FPaletteChooser);
end;

procedure TdxRibbonSkinSelectorController.TChooserController.UpdatePaletteChooserPlacement(AInRibbon: Boolean);
var
  ARibbonItemLink: TdxRibbonGalleryItemBarItemLink;
begin
  if SkinSelector.IsDestroying or (IsPaletteChooserPlacedInRibbon = AInRibbon) then
    Exit;
  if not AInRibbon then
  begin
    SkinSelector.ChildrenList.Remove(FPaletteChooser);
    ARibbonItemLink := FSkinChooser.ItemLinks.Add as TdxRibbonGalleryItemBarItemLink;
    ARibbonItemLink.Visible := True;
    ARibbonItemLink.PositionInDropDown := ilpBeforeGallery;
    ARibbonItemLink.Item := FPaletteChooser;
  end
  else
  begin
    FSkinChooser.ItemLinks.FindByItem(FPaletteChooser).Free;
    SkinSelector.ChildrenList.AddItem(FPaletteChooser);
  end;
end;

procedure TdxRibbonSkinSelectorController.TChooserController.Build;

  procedure ChoosersBeginUpdate;
  begin
    FSkinChooser.GalleryBeginUpdate;
    FPaletteChooser.GalleryBeginUpdate;
  end;

  procedure ChoosersEndUpdate;
  begin
    try
      FSkinChooser.GalleryEndUpdate;
    finally
      FPaletteChooser.GalleryEndUpdate;
    end;
  end;

  procedure InitializeSearchEdit;
  var
    ARibbonItemLink: TdxRibbonGalleryItemBarItemLink;
  begin
    FSearchEdit.Setup(Self);
    ARibbonItemLink := FSkinChooser.ItemLinks.Add as TdxRibbonGalleryItemBarItemLink;
    ARibbonItemLink.UserDefine := [udWidth];
    ARibbonItemLink.Visible := True;
    ARibbonItemLink.PositionInDropDown := ilpBeforeGallery;
    ARibbonItemLink.Item := FSearchEdit;
  end;

begin
  CreateSubItems;
  ChoosersBeginUpdate;
  try
    FSkinChooser.Setup(Self);
    InitializeSearchEdit;
    FPaletteChooser.Setup(Self);
    if dxIsDesignTime then
      Exit;
    FSkinChooser.OnPopup := SkinChooserPopupHandler;
    if Owner.UsesCustomSkinSource then
      FSkinChooser.OnPopulate := SkinPopulateHandler;
    FSkinChooser.OnSkinChanged := SkinChooserSkinChangedHandler;
    FSkinChooser.OnAddSkin := SkinChooserAddSkinHandler;
    FPaletteChooser.OnPaletteChanged := PaletteChangedHandler;
    FPaletteChooser.OnAddPalette := PaletteChooserAddPaletteHandler;
    FSkinChooser.PopulateGallery;
    FSkinChooser.OnGroupVisibleChanged := SkinChooserGroupVisibleChanged;
    VisibleGroupController.SkinChooser := SkinChooser;
  finally
    ChoosersEndUpdate;
  end;
end;

procedure TdxRibbonSkinSelectorController.TChooserController.ValidatePaletteName(AUseDefaultPalette: Boolean;
  var APaletteName: string; out AChanged: Boolean);

  function GetDefaultPaletteName: string;
  var
    AItem: TdxSkinPaletteChooserGalleryGroupItem;
  begin
    Result := SkinManager.Info.GetDefaultColorPaletteName;
    if (Result = '') or not FPaletteChooser.FindPalette(Result, AItem) then
      Result := FPaletteChooser.GetFirstPaletteName;
  end;

  function GetActivePaletteName: string;
  var
    AItem: TdxSkinPaletteChooserGalleryGroupItem;
  begin
    Result := '';
    if SkinManager.Info.GetActiveColorPaletteName(Result) then
    begin
      if (Result = '') or not FPaletteChooser.FindPalette(Result, AItem) then
        Result := GetDefaultPaletteName;
    end
    else
      Result := GetDefaultPaletteName;
  end;

  function GetActualPaletteName: string;
  var
    AItem: TdxSkinPaletteChooserGalleryGroupItem;
  begin
    Result := Owner.SkinSelector.PreferredPaletteName;
    if (Result = '') or not FPaletteChooser.FindPalette(Result, AItem) then
      Result := GetActivePaletteName
  end;

var
  AItem: TdxSkinPaletteChooserGalleryGroupItem;
begin
  AChanged := AUseDefaultPalette;
  if AUseDefaultPalette then
    APaletteName := GetActualPaletteName
  else
    if (APaletteName = '') or not FPaletteChooser.FindPalette(APaletteName, AItem) then
    begin
      AChanged := True;
      APaletteName := GetActualPaletteName;
    end;
end;

procedure TdxRibbonSkinSelectorController.TChooserController.ValidateSkinName(var ASkinName: string;
  AChooser: TdxSkinChooserGalleryItem; out AChanged: Boolean);
var
  AItem: TdxSkinChooserGalleryGroupItem;
begin
  AChanged := False;
  if (ASkinName <> '') and AChooser.FindSkin(ASkinName, AItem) then
    Exit;
  AChanged := True;
  ASkinName := Owner.SkinSelector.PreferredSkinName;
  if (ASkinName <> '') and AChooser.FindSkin(ASkinName, AItem) then
    Exit;
  ASkinName := AChooser.GetFirstSkinName;
end;

procedure TdxRibbonSkinSelectorController.TChooserController.SetSkinValues(ASkinName, APaletteName: string);

  function GetPaletteName(AWasChangesInSkinName: Boolean; AName: string): string;
  var
    APaletteNameChanged: Boolean;
  begin
    Result := AName;
    ValidatePaletteName(AWasChangesInSkinName, Result, APaletteNameChanged);
  end;

  function GetSkinItemByName(const ASkinName: string): TdxSkinChooserGalleryGroupItem;
  begin
    Result := nil;
    FSkinChooser.FindSkin(ASkinName, Result);
  end;

var
  ASkinNameChanged: Boolean;
begin
  ValidateSkinName(ASkinName, FSkinChooser, ASkinNameChanged);
  if ASkinNameChanged and SkinManager.IsPostponedUpdateOfSelectedItems then  
    Exit;
  if ASkinNameChanged then
    APaletteName := '';
  PaletteNotificationBeginUpdate;
  try
    Owner.SkinManager.SetSkinValues(GetSkinItemByName(ASkinName), APaletteName);
    FSkinChooser.SelectedSkinName := ASkinName;
    FPaletteChooser.SelectedPaletteName := GetPaletteName(ASkinNameChanged, APaletteName);
  finally
    PaletteNotificationEndUpdate;
  end;
end;

function TdxRibbonSkinSelectorController.TChooserController.GetSkinManager: TSkinManager;
begin
  Result := Owner.SkinManager;
end;

function TdxRibbonSkinSelectorController.TChooserController.GetSkinSelector: TdxRibbonSkinSelector;
begin
  Result := Owner.SkinSelector;
end;

procedure TdxRibbonSkinSelectorController.TChooserController.UpdateSkinChooser;

  function GetLocalizedCaption(ASkinDetails: TdxSkinDetails): string;
  var
    ADisplayGroupName, AGroupName: string;
  begin
    if DefaultUseLocalizedNames then
    begin
      if not SkinManager.Info.GetLocalizedSkinInfo(ASkinDetails.Name, Result, ADisplayGroupName, AGroupName) then
        Result := ASkinDetails.DisplayName;
    end
    else
      Result := ASkinDetails.DisplayName;
  end;

var
  ASkinDetails: TdxSkinDetails;
begin
  if dxIsDesignTime then
    Exit;
  ASkinDetails := SkinManager.Info.GetActiveSkinDetails;
  if ASkinDetails <> nil then
  begin
    FSkinChooser.Caption := GetLocalizedCaption(ASkinDetails);
    FSkinChooser.Glyph.Assign(ASkinDetails.Icons[sis48]);
    if SkinSelector.Options.SkinChooser.InRibbon.CollapsedIconSize = sis48 then
    begin
      FSkinChooser.Glyph.SourceHeight := 32;
      FSkinChooser.Glyph.SourceWidth := 32;
    end
    else
    begin
      FSkinChooser.Glyph.SourceHeight := 16;
      FSkinChooser.Glyph.SourceWidth := 16;
    end;
  end
  else
  begin
    FSkinChooser.Caption := sdxNoneSkinName;
    FSkinChooser.Glyph.Clear;
  end;
end;

procedure TdxRibbonSkinSelectorController.TChooserController.GetScreenTip(Sender: TObject; var AScreenTip: TdxScreenTip);
begin
  if Sender = FSkinChooser then
    AScreenTip := SkinSelector.Options.SkinChooser.DoGetScreenTip
  else
    if Sender = FPaletteChooser then
      AScreenTip := SkinSelector.Options.PaletteChooser.DoGetScreenTip
end;

procedure TdxRibbonSkinSelectorController.TChooserController.UpdateChooserProperties(AChooserTypes: TdxRibbonSkinSelectorChooserTypes);
begin
  if TdxRibbonSkinSelectorChooserType.SkinChooser in AChooserTypes then
     UpdateSkinChooserProperties;
  if TdxRibbonSkinSelectorChooserType.PaletteChooser in AChooserTypes then
     UpdatePaletteChooserProperties;
end;

procedure TdxRibbonSkinSelectorController.TChooserController.UpdateSkinChooserProperties;
var
  AOptions: TdxRibbonSkinSelectorSkinChooserOptions;

  procedure UpdateItemSizeInMenu;
  var
    ASize: TSize;
  begin
    ASize := AOptions.InMenu.ItemSize.Value;
    if ASize.cx <= 0 then
      ASize.cx := ScaleFactor.Apply(sdxSkinChooserDefaultItemSizeInMenu.cx);
    if ASize.cy <= 0 then
      ASize.cy := 0; 
    FSkinChooser.GalleryInMenuOptions.ItemSize.Value := ASize;
  end;

  procedure Update;
  begin
    FSkinChooser.Hint := AOptions.Hint;
    FSkinChooser.KeyTip := AOptions.KeyTip;

    if AOptions.InMenu.ShowItemCaption then    
      FSkinChooser.GalleryInMenuOptions.ItemTextKind := TdxRibbonGalleryGroupItemTextKind.itkCaption
    else
      FSkinChooser.GalleryInMenuOptions.ItemTextKind := TdxRibbonGalleryGroupItemTextKind.itkNone;

    UpdateItemSizeInMenu;
    FSkinChooser.SkinIconSizeInDropDown := AOptions.InMenu.ItemIconSize;
    FSkinChooser.GalleryInRibbonOptions.AlwaysShowItemCaption := AOptions.InRibbon.ShowItemCaption;
    FSkinChooser.GalleryInRibbonOptions.CanCollapse := AOptions.InRibbon.CanCollapse;
    FSkinChooser.GalleryInRibbonOptions.Collapsed := AOptions.InRibbon.Collapsed;
    if FSkinChooser.GalleryInRibbonOptions.Collapsed then
    begin
      FSkinChooser.GalleryOptions.ColumnCount := 1;
      FSkinChooser.GalleryOptions.MinColumnCount := 1;
    end
    else
    begin
      FSkinChooser.GalleryOptions.ColumnCount := AOptions.InRibbon.ColumnCount;
      FSkinChooser.GalleryOptions.MinColumnCount := AOptions.InRibbon.MinColumnCount;
    end;
    FSkinChooser.GalleryInRibbonOptions.ItemSize := AOptions.InRibbon.ItemSize;
    FSkinChooser.SkinIconSize := AOptions.InRibbon.ItemIconSize;

    FSkinChooser.GalleryOptions.ItemImagePosition := AOptions.ItemIconPosition;
    FSkinChooser.GalleryOptions.ItemTextAlignVert := AOptions.ItemTextAlignVert;
    FSkinChooser.VisibleLookAndFeelStyles := AOptions.VisibleLookAndFeelStyles;
    FSkinChooser.Visible := AOptions.Visible;
    UpdateSkinChooser;
    FSearchEdit.Visible := VisibleTodxBarVisible(AOptions.InMenu.SearchBoxVisible);
  end;

begin
  AOptions := SkinSelector.Options.SkinChooser;
  FSkinChooser.PopulateGalleryBeginUpdate;
  try
    FSkinChooser.GalleryBeginUpdate;
    try
      Update;
    finally
      FSkinChooser.GalleryEndUpdate;
    end;
  finally
    FSkinChooser.PopulateGalleryEndUpdate(False);
  end;
end;

procedure TdxRibbonSkinSelectorController.TChooserController.UpdatePaletteChooserProperties;
var
  AOptions: TdxRibbonSkinSelectorPaletteChooserOptions;

  procedure Update;
  begin
    FPaletteChooser.Hint := AOptions.Hint;
    FPaletteChooser.KeyTip := AOptions.KeyTip;

    if AOptions.InMenu.ShowItemCaption then
      FPaletteChooser.GalleryInMenuOptions.ItemTextKind := TdxRibbonGalleryGroupItemTextKind.itkCaption
    else
      FPaletteChooser.GalleryInMenuOptions.ItemTextKind := TdxRibbonGalleryGroupItemTextKind.itkNone;

    FPaletteChooser.GalleryInMenuOptions.DropDownGalleryResizing := AOptions.InMenu.ResizeMode;
    FPaletteChooser.GalleryInMenuOptions.ItemSize := AOptions.InMenu.ItemSize;

    FPaletteChooser.GalleryInRibbonOptions.AlwaysShowItemCaption := AOptions.InRibbon.ShowItemCaption;
    FPaletteChooser.LargeGlyph := AOptions.InRibbon.CollapsedGlyph;
    FPaletteChooser.Glyph := AOptions.InRibbon.CollapsedGlyph;
    if FPaletteChooser.LargeGlyph.Empty then
      FPaletteChooser.LargeGlyph.LoadFromResource(HInstance, 'SKINSELECTORCONTROLLERIMAGECOLORMIXER', RT_RCDATA);
    if FPaletteChooser.Glyph.Empty then
      FPaletteChooser.Glyph.LoadFromResource(HInstance, 'SKINSELECTORCONTROLLERIMAGECOLORMIXER', RT_RCDATA);
    FPaletteChooser.Glyph.SourceHeight := 16;
    FPaletteChooser.Glyph.SourceWidth := 16;
    FPaletteChooser.GalleryInRibbonOptions.CanCollapse := AOptions.InRibbon.CanCollapse;
    FPaletteChooser.GalleryOptions.ColumnCount := AOptions.InRibbon.ColumnCount;
    FPaletteChooser.GalleryInRibbonOptions.Collapsed := AOptions.InRibbon.Collapsed;
    FPaletteChooser.GalleryInRibbonOptions.MinColumnCount := AOptions.InRibbon.MinColumnCount;
    FPaletteChooser.GalleryInRibbonOptions.ItemSize := AOptions.InRibbon.ItemSize;  
    FPaletteChooser.GalleryOptions.ItemImagePosition := AOptions.ItemIconPosition;
    FPaletteChooser.GalleryOptions.ItemTextAlignVert := AOptions.ItemTextAlignVert;
    FPaletteChooser.Visible := AOptions.Visible;    
    FPaletteChooser.SetPaletteImageParameters(AOptions.InRibbon.ItemIconSize.Value, AOptions.InMenu.ItemIconSize.Value,
      AOptions.InRibbon.ItemIconVisible, AOptions.InMenu.ItemIconVisible);
  end;

begin
  AOptions := SkinSelector.Options.PaletteChooser;
  FPaletteChooser.PopulateGalleryBeginUpdate;
  try
    FPaletteChooser.GalleryBeginUpdate;
    try
      Update;
    finally
      FPaletteChooser.GalleryEndUpdate;
    end;
  finally
    FPaletteChooser.PopulateGalleryEndUpdate(False);
  end;
end;

procedure TdxRibbonSkinSelectorController.TChooserController.UpdateRibbons;
begin
  FOwner.UpdateRibbons(True);
end;

procedure TdxRibbonSkinSelectorController.TChooserController.GetSelectedGroupNames(AList: TStrings);
begin
  if (FSkinChooser <> nil) and not (csDestroying in FSkinChooser.ComponentState) then
    FSkinChooser.GetVisibleGroups(AList)
  else
    AList.Clear;
end;

procedure TdxRibbonSkinSelectorController.TChooserController.SetSelectedGroupNames(AList: TStrings);
begin
  if (FSkinChooser <> nil) and not (csDestroying in FSkinChooser.ComponentState) then
    FSkinChooser.SetGroupsVisible(AList);
end;

procedure TdxRibbonSkinSelectorController.TChooserController.SkinChooserGroupVisibleChanged(Sender: TObject; AGroup: TdxCustomGalleryGroup);
begin
  if not FSkinChooser.IsGalleryPopulating then
    FVisibleGroupController.UpdateFromChooser;
end;

procedure TdxRibbonSkinSelectorController.TChooserController.SkinChooserAddSkinHandler(
  Sender: TObject; ASkinDetails: TdxSkinDetails; var AAccepted: Boolean);
begin
  SkinSelector.DoAddSkin(ASkinDetails, AAccepted);
end;

function TdxRibbonSkinSelectorController.TChooserController.GetSearchEditProperties: TcxButtonEditProperties;
begin
  Result := FSearchEdit.Properties as TcxButtonEditProperties;
end;

procedure TdxRibbonSkinSelectorController.TChooserController.PaletteChangedHandler(
  Sender: TObject; const ASkinName, APaletteName: string);
begin
  UpdatePalette;
end;

procedure TdxRibbonSkinSelectorController.TChooserController.SkinChooserSkinChangedHandler(
  Sender: TObject; const ASkinName: string);
begin
  UpdateSkin;
end;

procedure TdxRibbonSkinSelectorController.TChooserController.SkinPopulateHandler(Sender: TObject);
var
  ALoader: TdxRibbonSkinSelectorLoader;
begin
  ALoader := TdxRibbonSkinSelectorLoader.Create(SkinChooser);
  try
    SkinChooser.PopulateGalleryBeginUpdate;
    try
      SkinChooser.GalleryBeginUpdate;
      try
        Owner.DoPopulateWithSkins(ALoader);
      finally
        SkinChooser.GalleryEndUpdate;
      end;
    finally
      SkinChooser.PopulateGalleryEndUpdate(False);
    end;
  finally
    ALoader.Free;
  end;
end;

procedure TdxRibbonSkinSelectorController.TChooserController.SkinChooserPopupHandler(Sender: TObject);
begin
  FSkinChooser.PrepareOnShow;
  FSearchEdit.PrepareOnShow;
end;

procedure TdxRibbonSkinSelectorController.TChooserController.UpdateSkin;

  procedure UpdateActiveValues;
  var
    AName: string;
  begin
    if SkinManager.Info.GetActiveSkinName(AName) then
      FSkinChooser.SelectedSkinName := AName;
    AName := '';
    SkinManager.Info.GetActiveColorPaletteName(AName);
    Inc(FLockChangePaletteCount);
    try
      FPaletteChooser.PopulateGallery;
    finally
      Dec(FLockChangePaletteCount);
    end;
    if AName <> '' then
      FPaletteChooser.SelectedPaletteName := AName;
  end;

begin

    if FLockChangeSkinCount > 0 then
      Exit;
    Inc(FLockChangeSkinCount);
    try
      PaletteNotificationBeginUpdate;
      try
        SkinManager.SetSkin(FSkinChooser.SelectedGroupItem);
        UpdateActiveValues;
        UpdateRibbons;
        UpdateSkinChooser;
        SkinNotification;
        PaletteNotification; 
      finally
        PaletteNotificationEndUpdate;
      end;
    finally
      Dec(FLockChangeSkinCount);
    end;
end;

procedure TdxRibbonSkinSelectorController.TChooserController.SkinNotification;
begin
  SkinSelector.DoSkinChanged(FSkinChooser.SelectedSkinName);
end;

procedure TdxRibbonSkinSelectorController.TChooserController.UpdatePalette;
begin
    if FLockChangePaletteCount > 0 then
      Exit;
    Inc(FLockChangePaletteCount);
    try

      SkinManager.SetPalette(FPaletteChooser.SelectedGroupItem);
      FPaletteChooser.SelectedPaletteName := SkinManager.PaletteName;
      PaletteNotification;
    finally
      Dec(FLockChangePaletteCount);
    end;
end;

procedure TdxRibbonSkinSelectorController.TChooserController.PaletteNotification;
begin
  if FLockPaletteNotificationCount = 0 then
  begin
    FNeedPaletteNotification := False;
    SkinSelector.DoPaletteChanged(FSkinChooser.SelectedSkinName, FPaletteChooser.SelectedPaletteName);
  end
  else
    FNeedPaletteNotification := True;
end;

procedure TdxRibbonSkinSelectorController.TChooserController.PaletteNotificationBeginUpdate;
begin
  Inc(FLockPaletteNotificationCount);
end;

procedure TdxRibbonSkinSelectorController.TChooserController.PaletteNotificationEndUpdate;
begin
  Dec(FLockPaletteNotificationCount);
  if (FLockPaletteNotificationCount = 0) and FNeedPaletteNotification then
    PaletteNotification;
end;

procedure TdxRibbonSkinSelectorController.TChooserController.DoBeforePopulatePalettes;
var
  AOptions: TdxRibbonSkinSelectorPaletteChooserOptions;
begin
  AOptions := SkinSelector.Options.PaletteChooser;
  FPaletteChooser.GalleryBeginUpdate;
  try
    FPaletteChooser.Enabled := True;
    FPaletteChooser.GalleryOptions.ColumnCount := AOptions.InRibbon.ColumnCount;
    FPaletteChooser.GalleryInRibbonOptions.MinColumnCount := AOptions.InRibbon.MinColumnCount;
    FPaletteChooser.GalleryOptions.LongDescriptionDefaultRowCount := 2;
  finally
    FPaletteChooser.GalleryEndUpdate;
  end;
end;

procedure TdxRibbonSkinSelectorController.TChooserController.DoAfterPopulatePalettes;
begin
  FEmptyItemLoaded := FPaletteChooser.GalleryGroups.Count = 0;
  if FEmptyItemLoaded then
    FPaletteChooser.AddEmptyItem(cxGetResourceString(@dxSBAR_PALETTECHOOSEREMPTYITEMCAPTION),
      cxGetResourceString(@dxSBAR_PALETTECHOOSEREMPTYITEMDESCRIPTION));
  UpdateEnabled;
end;

procedure TdxRibbonSkinSelectorController.TChooserController.UpdateEnabled;
begin
  FPaletteChooser.Enabled := not FEmptyItemLoaded and SkinSelector.Enabled;
end;

procedure TdxRibbonSkinSelectorController.TChooserController.PaletteChooserAddPaletteHandler(Sender: TObject; const ASkinName: string; AColorPalette: TdxSkinColorPalette; var AAccepted: Boolean);
begin
  SkinSelector.DoAddPalette(ASkinName, AColorPalette, AAccepted);
end;

procedure TdxRibbonSkinSelectorController.TChooserController.SetFocusToSearchEdit;
begin
  SearchEdit.PostponedSetFocus;
end;

procedure TdxRibbonSkinSelectorController.TChooserController.SearchEditTextChanged;
begin
  SkinChooser.PostponedDisplaySelectedGroupItem;
end;

{ TdxRibbonSkinSelectorController.TBarSearchEdit }

destructor TdxRibbonSkinSelectorController.TSearchEdit.Destroy;
begin
  dxThreading.TdxUIThreadSyncService.Unsubscribe(Self);
  inherited Destroy;
end;

function TdxRibbonSkinSelectorController.TSearchEdit.GetSelectedControl: TcxBarEditItemControl;
begin
  if (LinkCount > 0) and (Links[0].Control <> nil) then
    Result := Links[0].Control as TcxBarEditItemControl
  else
    Result := nil;
  if (Result <> nil) and (BarNavigationController.SelectedObject <> Result.IAccessibilityHelper) then
    Result := nil;
end;

function TdxRibbonSkinSelectorController.TSearchEdit.GetControlClass(AIsVertical: Boolean): TdxBarItemControlClass;
begin
  if AIsVertical then
    Result := inherited GetControlClass(AIsVertical)
  else
    Result := TSearchEditControl;
end;

function TdxRibbonSkinSelectorController.TSearchEdit.GetProperties: TcxButtonEditProperties;
begin
  Result := inherited Properties as TcxButtonEditProperties;
end;

procedure TdxRibbonSkinSelectorController.TSearchEdit.ControlSelectionChanged(AControl: TdxBarItemControl);

  function GetKey: Integer;
  var
    AState : TKeyboardState;
  begin
    Result := 0;
    GetKeyboardState(AState);
    if AState[VK_ESCAPE] and 128 <> 0 then
      Result := VK_ESCAPE
    else
      if AState[VK_UP] and 128 <> 0 then
        Result := VK_UP
    else
      if AState[VK_DOWN] and 128 <> 0 then
        Result := VK_DOWN;
  end;

var
 AKey: Integer;
begin
  inherited ControlSelectionChanged(AControl);
  AKey := GetKey;
  if AControl.IsSelected and not AControl.Focused then
  begin
    if AKey in [VK_UP, VK_DOWN] then
      PostponedExecution(
        procedure
        var
          AControl: TcxBarEditItemControl;
        begin
          AControl := GetSelectedControl;
          if AControl <> nil then
            TcxBarEditItemControlAccess(AControl).Click(False);  
        end);
  end
  else
    if not AControl.IsSelected and (AKey = VK_ESCAPE) then
      PostponedExecution(
        procedure
        var
          AControl: TcxBarEditItemControl;
        begin
          AControl := GetSelectedControl;
          if (AControl <> nil) and (AControl.Parent <> nil) then
            PostMessage(AControl.Parent.Handle, WM_KEYDOWN, VK_ESCAPE, 0); 
        end)
    else
      PostponedExecution(nil);
end;

procedure TdxRibbonSkinSelectorController.TSearchEdit.PostponedExecution(const AProc: TProc);
begin
  if FPostponedExecutionLocked then
    Exit;
  FPostponedExecutionLocked := True;
  dxThreading.TdxUIThreadSyncService.EnqueueInvokeInUIThread(Self,
    procedure
    begin
      try
        if Assigned(AProc) then
          AProc();
      finally
        FPostponedExecutionLocked := False;
      end;
    end);
end;

procedure TdxRibbonSkinSelectorController.TSearchEdit.KeyDown(var AKey: Word; AShift: TShiftState);

  function GetDirection(AKey: Word): TDirection;
  begin
    case AKey of
        VK_UP: Result := TDirection.Up;
        VK_DOWN: Result := TDirection.Down;
    else
      Result := TDirection.None;
    end;
  end;

  function GetShift(AKey: Word): TShiftState;
  begin
    if AKey = VK_UP then
      Result := [ssShift]
    else
      Result := [];
  end;

  procedure NavigateToSkinChooser;
  begin
    try
      if (AKey = VK_UP) and (FController.SkinChooser.NavigatedToSelectItem or not FController.IsPaletteChooserPlacedInRibbon) then
        Exit;
      FController.SkinChooser.NavigationDirection := GetDirection(AKey);
      BarNavigationController.HandleKey(VK_TAB, GetShift(AKey));
    finally
      FController.SkinChooser.NavigationDirection := TDirection.None;
      FController.SkinChooser.NavigatedToSelectItem := True;
    end;
  end;

var
  AControl: TcxBarEditItemControl;
begin
  inherited KeyDown(AKey, AShift);
  if (AShift <> []) or (GetSelectedControl = nil) then
    Exit;
  case AKey of
      VK_DOWN, VK_UP:
        begin
          NavigateToSkinChooser;
          AKey := 0;
        end;
      VK_ESCAPE:
        begin
          AControl := GetSelectedControl;
          if TcxBarEditItemControlAccess(AControl).Edit <> nil then
            TcxBarEditItemControlAccess(AControl).StoreDisplayValue;
        end;
      VK_RETURN:
        begin
          AControl := GetSelectedControl;
          if TcxBarEditItemControlAccess(AControl).Edit <> nil then
            SettingButtonClick;
          AKey := 0;
        end;
  end;
end;

procedure TdxRibbonSkinSelectorController.TSearchEdit.PostponedSetFocus;
begin
  if FController.SkinSelector.IsDestroying or (Visible <> TdxBarItemVisible.ivAlways) then
    Exit;
  PostponedExecution(
    procedure
    begin
      InternalSetFocus;
    end);
end;

procedure TdxRibbonSkinSelectorController.TSearchEdit.PrepareOnShow;
begin
  PostponedSetFocus;
end;

procedure TdxRibbonSkinSelectorController.TSearchEdit.SettingButtonClick;
begin
  ButtonsClickHandler(GetActiveEditor, FSettingButton.Index);
end;

procedure TdxRibbonSkinSelectorController.TSearchEdit.InternalSetFocus;

  function LinksContainsControl(AControl: TdxBarItemControl): Boolean;
  var
    I: Integer;
  begin
    if AControl <> nil then
      for I := 0 to LinkCount - 1 do
        if Links[I].Control = AControl then
          Exit(True);
    Result := False;
  end;

  function GetEditControl(ABarControl: TCustomdxBarControl): TdxBarItemControl;
  var
    AViewInfo: TCustomdxBarControlViewInfo;
    AControl: TdxBarItemControl;
    I: Integer;
  begin
    Result := nil;
    try
      AViewInfo := ABarControl.ViewInfo;
      for I := 0 to AViewInfo.ItemControlCount - 1 do
      begin
        AControl := AViewInfo.ItemControlViewInfos[I].Control;
        if LinksContainsControl(AControl) then
          Exit(AControl);
      end;
    finally
    end;
  end;

var
  ABarDropDownWinControl: TCustomdxBarControl;
  AControl: TdxBarItemControl;
  AHelper: TdxBarWinControlAccessibilityHelperAccess;
begin
  if FController.SkinSelector.IsDestroying or (Visible <> TdxBarItemVisible.ivAlways) then
    Exit;
  ABarDropDownWinControl := FController.SkinChooser.ItemLinks.BarControl;
  if ABarDropDownWinControl <> nil then
  begin
    AControl := GetEditControl(ABarDropDownWinControl);
    if AControl <> nil then
    begin
      AHelper := TdxBarWinControlAccessibilityHelperAccess(AControl.IAccessibilityHelper.GetBarHelper as TdxBarWinControlAccessibilityHelper);
      AHelper.KeyTipHandler(nil);  
    end;

  end;
end;

procedure TdxRibbonSkinSelectorController.TSearchEdit.Setup(AController: TChooserController);
var
  AButton: TcxEditButton;
begin
  FController := AController;
  AlwaysSaveDisplayValue := True;
  WithoutLeftIndents := True;
  HasBorder := False;
  Caption := '';
  Hint := cxGetResourceString(@dxSBAR_DEFAULTSEARCHEDITHINT);
  PropertiesClass := TcxButtonEditProperties;
  Properties.BeginUpdate;
  try
    Properties.HideSelection := False;
    Properties.OnButtonClick := ButtonsClickHandler;
    Properties.OnChange := ChangedHandler;
    Properties.OnButtonGlyphDrawParameters := ButtonGlyphDrawParametersHandler;

    FSettingButton := Properties.Buttons[0];
    AButton := FSettingButton;
    AButton.Glyph.SourceHeight := 16;
    AButton.Glyph.SourceWidth := 16;
    AButton.Glyph.LoadFromResource(HInstance, 'SKINSELECTORCONTROLLERIMAGESEARCHSETTINGBUTTON', RT_RCDATA);
    AButton.Kind := bkGlyph;
    AButton.Width := MulDiv(32, dxGetMonitorDPI(Screen.PrimaryMonitor), dxDefaultDPI); 


    FCancelButtonPalette := TdxSimpleColorPalette.Create(TdxAlphaColors.Empty, TdxAlphaColors.Empty);
    FCancelButton := Properties.Buttons.Add;
    AButton := FCancelButton;
    AButton.Transparent := True;
    AButton.Index := 0;
    AButton.Glyph.SourceHeight := 16;
    AButton.Glyph.SourceWidth := 16;
    AButton.Glyph.LoadFromResource(HInstance, 'SKINSELECTORCONTROLLERIMAGESEARCHCANCEL', RT_RCDATA);
    AButton.Kind := bkGlyph;
    AButton.Width := MulDiv(32, dxGetMonitorDPI(Screen.PrimaryMonitor), dxDefaultDPI); 
    AButton.Visible := False;

    FIconButton := Properties.Buttons.Add;
    AButton := FIconButton;
    AButton.Transparent := True;
    AButton.Mode := TcxEditButtonMode.Glyph;
    AButton.HotTrackMode := TcxEditButtonHotTrackMode.None;
    AButton.Transparent := True;
    AButton.Glyph.SourceHeight := 16;
    AButton.Glyph.SourceWidth := 16;
    AButton.Glyph.LoadFromResource(HInstance, 'SKINSELECTORCONTROLLERIMAGESEARCH', RT_RCDATA);
    AButton.Kind := bkGlyph;
    AButton.Width := MulDiv(24, dxGetMonitorDPI(Screen.PrimaryMonitor), dxDefaultDPI); 
    AButton.LeftAlignment := True;
    AButton.Visible := True;
  finally
    Properties.EndUpdate(False);
  end;
end;

procedure TdxRibbonSkinSelectorController.TSearchEdit.ButtonsClickHandler(Sender: TObject; AButtonIndex: Integer);
var
  AEdit: TcxButtonEdit;

  function GetButtonViewInfo(ARealButtonIndex: Integer): TcxEditButtonViewInfo;
  var
    I: Integer;
  begin
    for I := 0 to Length(AEdit.ViewInfo.ButtonsInfo) - 1 do
     if AEdit.ViewInfo.ButtonsInfo[I].ButtonIndex = ARealButtonIndex then
       Exit(AEdit.ViewInfo.ButtonsInfo[I]);
    Result := nil;
  end;

  function GetFilterScreenPosition: TPoint;
  var
    AButtonViewInfo: TcxEditButtonViewInfo;
  begin
    AButtonViewInfo := GetButtonViewInfo(AButtonIndex);
    if AButtonViewInfo <> nil then
      Result := AEdit.ClientToScreen(TPoint.Create(AButtonViewInfo.Bounds.Left, AButtonViewInfo.Bounds.Bottom))
    else
      Result := cxInvisiblePoint;
  end;

  procedure ShowPopupGroupFilter;
  var
    AControl: TdxBarItemControl;
    I: Integer;
  begin
    FController.SkinChooser.ShowPopupGroupFilter(GetFilterScreenPosition);
    for I := 0 to LinkCount - 1 do
    begin
      AControl := Links[I].Control;
      if AControl <> nil then
      begin
        AControl.Focused := False;
        TCustomdxBarControlAccess(AControl.Parent).SelectedControl := nil;
      end;
    end;
  end;

begin
  if not Safe.Cast(Sender, TcxButtonEdit, AEdit) then
    Exit;
  if FSettingButton = Properties.Buttons[AButtonIndex] then
    ShowPopupGroupFilter
  else
    if FCancelButton = Properties.Buttons[AButtonIndex] then
    begin
      FController.SkinChooser.ItemsFilter('');
      EditValue := '';
      if AEdit <> nil  then
        AEdit.Text := ''
      else
        FCancelButton.Visible := False;
    end;
end;

procedure TdxRibbonSkinSelectorController.TSearchEdit.ButtonGlyphDrawParametersHandler(Sender: TObject; AButtonIndex: Integer; AState: TcxEditButtonState; var AGlyph: TGraphic; var APalette : IdxColorPalette);

  function GetColor(const AColorNameInPalette: string; ADefaultColor: TdxAlphaColor): TdxAlphaColor;
  begin
    if not FController.SkinManager.Info.FindColorByName(AColorNameInPalette, Result) then
      Result := ADefaultColor;
  end;

begin
  if FCancelButton = Properties.Buttons[AButtonIndex] then
  begin
    case AState of
       TcxEditButtonState.ebsSelected:
         begin
           TdxSimpleColorPalette(FCancelButtonPalette).FillColor := GetColor('Red', TdxAlphaColors.Red);
           TdxSimpleColorPalette(FCancelButtonPalette).StrokeColor := TdxAlphaColors.Empty;
           APalette := FCancelButtonPalette;
         end;
       TcxEditButtonState.ebsPressed:
         begin
           TdxSimpleColorPalette(FCancelButtonPalette).FillColor := GetColor('Yellow', TdxAlphaColors.Red);
           TdxSimpleColorPalette(FCancelButtonPalette).StrokeColor := TdxSimpleColorPalette(FCancelButtonPalette).FillColor;
           APalette := FCancelButtonPalette;
         end;
    end;
  end;
end;

procedure TdxRibbonSkinSelectorController.TSearchEdit.ChangedHandler(Sender: TObject);
begin
  UpdateState;
end;

procedure TdxRibbonSkinSelectorController.TSearchEdit.UpdateState;
var
  AText: string;
  AEdit: TcxButtonEdit;
begin
  AEdit := GetActiveEditor as TcxButtonEdit;
  if AEdit <> nil then
    AText := AnsiUpperCase(AEdit.Text)
  else
    AText := cxVariants.VarToStrEx(EditValue);
  FCancelButton.Visible := AText <> '';
  if AEdit <> nil then
    AEdit.Properties.Buttons[FCancelButton.Index].Visible := FCancelButton.Visible;
  FController.SkinChooser.ItemsFilter(AText);
  FController.SkinChooser.PostponedDisplaySelectedGroupItem;
end;

 { TdxRibbonSkinSelectorController.TSkinChooser }

destructor TdxRibbonSkinSelectorController.TSkinChooser.Destroy;
begin
  dxThreading.TdxUIThreadSyncService.Unsubscribe(Self);
  inherited Destroy;
end;

procedure TdxRibbonSkinSelectorController.TSkinChooser.Setup(AController: TChooserController);
begin
  FController := AController;
  GalleryBeginUpdate;
  try
    PopulateGalleryBeginUpdate;
    try
      Caption := cxGetResourceString(@dxSBAR_DEFAULTSKINCHOOSERCAPTION);
      GalleryOptions.SubmenuResizing := TdxRibbonGallerySubmenuResizing.gsrNone;
      TdxInMenuGalleryOptionsAccess(GalleryInMenuOptions).LoopVerticalNavigation := False;
      TdxInMenuGalleryOptionsAccess(GalleryInMenuOptions).UseAlternateNavigation := True;

      (GalleryOptions as TdxCustomChooserGalleryOptions).MinDropDownWidth  := FController.ScaleFactor.Apply(sdxSkinChooserDefaultItemSizeInMenu.cx);
      (GalleryOptions as TdxCustomChooserGalleryOptions).MinDropDownHeight := FController.ScaleFactor.Apply(sdxSkinChooserMinDropDownGalleryControlHeight);
      (GalleryOptions as TdxCustomChooserGalleryOptions).MaxDropDownHeight := FController.ScaleFactor.Apply(sdxSkinChooserMaxDropDownGalleryControlHeight);

      GalleryInMenuOptions.CollapsedInSubmenu := True;
      GalleryInMenuOptions.RowCount := 10;
      FController.UpdateSkinChooserProperties;
    finally
      PopulateGalleryEndUpdate(True);
    end;
  finally
    GalleryEndUpdate;
  end;
end;

function TdxRibbonSkinSelectorController.TSkinChooser.DoGetScreenTip: TdxScreenTip;
begin
  Result := inherited DoGetScreenTip;
  if Result = nil then
    FController.GetScreenTip(Self, Result);
end;

procedure TdxRibbonSkinSelectorController.TSkinChooser.DoPopup;
begin
  FDropDowned := True;
  inherited DoPopup;
end;

procedure TdxRibbonSkinSelectorController.TSkinChooser.DoAfterPopulate;
begin
  inherited DoAfterPopulate;
  if (FController <> nil) and FController.SkinSelector.SkinSelectorLoaded then
    FController.Owner.UpdateSkinVisibleGroups;
end;

procedure TdxRibbonSkinSelectorController.TSkinChooser.DoCloseUp;
begin
  inherited DoCloseUp;
  FDropDowned := False;
  NavigatedToSelectItem := False;
end;

procedure TdxRibbonSkinSelectorController.TSkinChooser.FilterMenuControlDestroying;
begin
  FController.SetFocusToSearchEdit;
end;

procedure TdxRibbonSkinSelectorController.TSkinChooser.PrepareOnShow;
begin
  PostponedDisplaySelectedGroupItem;
end;

procedure TdxRibbonSkinSelectorController.TSkinChooser.GroupVisibleChanged(AGroup: TdxCustomChooserGalleryGroup);
begin
  inherited GroupVisibleChanged(AGroup);
  PostponedDisplaySelectedGroupItem;
end;

procedure TdxRibbonSkinSelectorController.TSkinChooser.PostponedDisplaySelectedGroupItem;
begin
  if FDisplaySelectedGroupItemLocked or not DropDowned then
    Exit;
  FDisplaySelectedGroupItemLocked := True;
  dxThreading.TdxUIThreadSyncService.EnqueueInvokeInUIThread(Self,
    procedure
    begin
      try
        InternalDisplaySelectedGroupItem;
      finally
        FDisplaySelectedGroupItemLocked := False;
      end;
    end);
end;

procedure TdxRibbonSkinSelectorController.TSkinChooser.InternalDisplaySelectedGroupItem;

  function GetMenuGalleryControlViewInfo: TdxRibbonOnMenuGalleryControlViewInfoAccess;
  var
    I: Integer;
  begin
    Result := nil;
    for I := 0 to LinkCount - 1 do
      if (Links[I].Control <> nil) and (Links[I].Control.ViewInfo is TdxRibbonOnMenuGalleryControlViewInfo) then
      begin
        Result := TdxRibbonOnMenuGalleryControlViewInfoAccess(Links[I].Control.ViewInfo);
        Break;
      end;
  end;

var
  AViewInfo: TdxRibbonOnMenuGalleryControlViewInfoAccess;
begin
  if not DropDowned then
    Exit;
  AViewInfo := GetMenuGalleryControlViewInfo;
  if (AViewInfo <> nil) and (SelectedGroupItem <> nil) and SelectedGroupItem.Visible and IsGroupVisible(SelectedGroupItem.Group.Index) then
    AViewInfo.DisplayGroupItem(SelectedGroupItem);
end;

procedure TdxRibbonSkinSelectorController.TSkinChooser.FilterUpdateUnlocked;
begin
// nothing to do
end;

{ TdxRibbonSkinSelectorController.TSkinChooserControl }

function TdxRibbonSkinSelectorController.TSkinChooserControl.CreateController: TdxRibbonGalleryController;
begin
  if Parent.Kind <> bkSubMenu then
    Result := inherited CreateController
  else
    Result := TSkinChooserOnSubmenuController.Create(Self);
end;

procedure TdxRibbonSkinSelectorController.TSkinChooserControl.ControlClick(AByMouse: Boolean; AKey: Char = #0);
begin
  if ((Item.ItemLinks.BarControl <> nil) and Collapsed) or
    (FNextTimeForDisplayDropDown < GetTickCount) then
      inherited ControlClick(AByMouse, AKey);
end;

procedure TdxRibbonSkinSelectorController.TSkinChooserControl.DoCloseUp(AHadSubMenuControl: Boolean);
begin
  if SubmenuController <> nil then
    SubmenuController.DoCloseUp;
  inherited DoCloseUp(AHadSubMenuControl);
  FNextTimeForDisplayDropDown := GetTickCount + 50;
end;

procedure TdxRibbonSkinSelectorController.TSkinChooserControl.DoDropDown(AByMouse: Boolean);
begin
  inherited DoDropDown(AByMouse);
  if SubmenuController <> nil then
    SubmenuController.DoDropDown;
end;

function TdxRibbonSkinSelectorController.TSkinChooserControl.GetSubmenuController: TSkinChooserOnSubmenuController;
begin
  if Parent.Kind <> bkSubMenu then
  begin
    if Item.ItemLinks.BarControl <> nil then
     Result := (TdxRibbonDropDownGalleryControlAccess(Item.ItemLinks.BarControl as TdxRibbonDropDownGalleryControl).InternalGalleryItemControl as TSkinChooserControl).SubmenuController
    else
     Result := nil
  end
  else
    Result := TSkinChooserOnSubmenuController(inherited Controller);
end;

{ TdxRibbonSkinSelectorController.TSkinChooserOnSubmenuController }

function TdxRibbonSkinSelectorController.TSkinChooserOnSubmenuController.GetControl: TSkinChooserControl;
begin
  Result := TSkinChooserControl(inherited Owner);
end;

function TdxRibbonSkinSelectorController.TSkinChooserOnSubmenuController.GetItem: TSkinChooser;
begin
  Result := TSkinChooser(Owner.Item);
end;

procedure TdxRibbonSkinSelectorController.TSkinChooserOnSubmenuController.DoCloseUp;
begin
  FLockResizeCount := 0;
end;

procedure TdxRibbonSkinSelectorController.TSkinChooserOnSubmenuController.DoDropDown;

  function IsGroupVisible: Boolean;
  var
    I: Integer;
  begin
    for I := 0 to Item.GalleryGroups.Count - 1 do
      if Item.GalleryGroups[I].Visible then
        Exit(True);
    Result := False;
  end;

begin
  FLockResizeCount := -Integer(IsGroupVisible);
end;

function TdxRibbonSkinSelectorController.TSkinChooserOnSubmenuController.FilterDropDownAutoSize(AGroupIndex: Integer): Boolean;
begin
  Result := False;
  if FLockResizeCount < 0 then
    Exit;
  if not Item.GalleryInRibbonOptions.Collapsed then
    Exit(True);
  if AGroupIndex >= -1 then
  begin
    if AGroupIndex >= 0 then
      Result := Item.GalleryGroups[AGroupIndex].Visible
    else
      Result := True;
  end;
  Result := Result and Control.IsNeedScrollBar(0);
  if Result then
  begin
    Inc(FLockResizeCount);
    if (AGroupIndex = -1) or (FLockResizeCount > 3) then
      FLockResizeCount := -1;
  end
  else
    if FLockResizeCount > 0 then
      Dec(FLockResizeCount);
end;

procedure TdxRibbonSkinSelectorController.TSkinChooserOnSubmenuController.UpdateHotTrack(ADirection: TdxRibbonDropDownGalleryNavigationDirection);

  function GetDirection: TcxAccessibilityNavigationDirection;
  begin
    if Item.NavigationDirection = TDirection.Up then
      Result := andUp
    else
      Result := andDown;
  end;

  function GetHotTrackItem: TdxSkinChooserGalleryGroupItem;
  begin
    if not Item.NavigatedToSelectItem and Item.DropDowned then
    begin
      Item.NavigatedToSelectItem := True;
      Result := Item.SelectedGroupItem;
    end
    else
      Result := nil;
  end;

var
  AItem: TdxSkinChooserGalleryGroupItem;
begin
  if Item.NavigationDirection <> TDirection.None then
  begin
    AItem := GetHotTrackItem;
    if AItem <> nil then
    begin
      HotTrackItem(AItem);
      Navigation(GetDirection);
      Exit;
    end
  end;
  inherited UpdateHotTrack(ADirection);
end;

{ TdxRibbonSkinSelectorController.TPaletteChooser }

procedure TdxRibbonSkinSelectorController.TPaletteChooser.Setup(AController: TChooserController);
begin
  FController := AController;
  GalleryBeginUpdate;
  try
    PopulateGalleryBeginUpdate;
    try
      Caption := cxGetResourceString(@dxSBAR_DEFAULTPALETTECHOOSERCAPTION);
      GalleryOptions.ShowItemHint := True;
      GalleryOptions.SpaceBetweenItemsAndBorder := FController.ScaleFactor.Apply(2);
      TdxInMenuGalleryOptionsAccess(GalleryInMenuOptions).LoopVerticalNavigation := True;
      TdxInMenuGalleryOptionsAccess(GalleryInMenuOptions).UseAlternateNavigation := True;
      FController.UpdatePaletteChooserProperties;
    finally
      PopulateGalleryEndUpdate(True);
    end;
  finally
    GalleryEndUpdate;
  end;
end;

procedure TdxRibbonSkinSelectorController.TPaletteChooser.DoAfterPopulate;
begin
  FController.DoAfterPopulatePalettes;
end;

procedure TdxRibbonSkinSelectorController.TPaletteChooser.DoBeforePopulate;
begin
  FController.DoBeforePopulatePalettes;
end;

function TdxRibbonSkinSelectorController.TPaletteChooser.DoGetScreenTip: TdxScreenTip;
begin
  Result := inherited DoGetScreenTip;
  if Result = nil then
    FController.GetScreenTip(Self, Result);
end;

{$ENDREGION}

{$REGION 'BarItem'}

{ TdxRibbonSkinSelector }

constructor TdxRibbonSkinSelector.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOptions := TdxRibbonSkinSelectorRootOptions.Create(Self);
  FController := TdxRibbonSkinSelectorController.Create(Self);
  FPreferredSkinName := DefaultPreferredSkinName;
  FPreferredPaletteName := DefaultPreferredPaletteName;
end;

destructor TdxRibbonSkinSelector.Destroy;
begin
  dxThreading.TdxUIThreadSyncService.Unsubscribe(Self);
  FreeAndNil(FController);
  FreeAndNil(FOptions);
  inherited Destroy;
end;

procedure TdxRibbonSkinSelector.AfterConstruction;
begin
  inherited AfterConstruction;
  dxResourceStringsRepository.AddListener(Self);
end;

procedure TdxRibbonSkinSelector.BeforeDestruction;
begin
  dxResourceStringsRepository.RemoveListener(Self);
  inherited BeforeDestruction;
end;

class function TdxRibbonSkinSelector.CreateSkinSelector(ABar: TdxBar; const ASkinResFileName: string = ''): TdxRibbonSkinSelector;
begin
  ABar.BarManager.BeginUpdate;
  try
    Result := ABar.BarManager.AddItem(TdxRibbonSkinSelector) as TdxRibbonSkinSelector;
    Result.BeginUpdate;
    try
      if ASkinResFileName <> '' then
        Result.LoadFromFile(ASkinResFileName);
      ABar.ItemLinks.Add(Result);
    finally
      Result.EndUpdate;
    end;
  finally
    ABar.BarManager.EndUpdate(True);
  end;
end;

function TdxRibbonSkinSelector.GetPaletteChooserOptions: TdxRibbonSkinSelectorPaletteChooserOptions;
begin
  Result := Options.PaletteChooser as TdxRibbonSkinSelectorPaletteChooserOptions;
end;

function TdxRibbonSkinSelector.GetActivePaletteName: string;
begin
  if Controller.IsReady then
    Result := Controller.ChooserController.PaletteChooser.SelectedGroupItemName
  else
    Result := '';
end;

function TdxRibbonSkinSelector.GetActiveSkinName: string;
begin
  if Controller.IsReady then
    Result := Controller.ChooserController.SkinChooser.SelectedGroupItemName
  else
    Result := '';
end;

function TdxRibbonSkinSelector.GetSkinChooserOptions: TdxRibbonSkinSelectorSkinChooserOptions;
begin
  Result := Options.SkinChooser as TdxRibbonSkinSelectorSkinChooserOptions;
end;

procedure TdxRibbonSkinSelector.SetOptions(AValue: TdxRibbonSkinSelectorRootOptions);
begin
  FOptions.Assign(AValue);
end;

procedure TdxRibbonSkinSelector.SetPaletteChooserOptions(AValue: TdxRibbonSkinSelectorPaletteChooserOptions);
begin
  Options.PaletteChooser := AValue;
end;

procedure TdxRibbonSkinSelector.SetSkin(const ASkinName: string; const APaletteName: string = '');
begin
  Controller.SetSkinValues(ASkinName, APaletteName);
end;

procedure TdxRibbonSkinSelector.SetSkinIfNeeded(const ASkinName, APaletteName: string);
begin
  if (ASkinName <> '') or (APaletteName <> '') then
    SetSkin(ASkinName, APaletteName);
end;

procedure TdxRibbonSkinSelector.SetSkinChooserOptions(AValue: TdxRibbonSkinSelectorSkinChooserOptions);
begin
  Options.SkinChooser := AValue;
end;

procedure TdxRibbonSkinSelector.LinksChanged(AItemLink: TdxBarItemLink; AAction: TListNotification);
begin
  inherited LinksChanged(AItemLink, AAction);
  if (AAction = TListNotification.lnAdded) and not FLoaded and (LinkCount >= 1) and
    (BarManager <> nil) and not TdxBarManagerAccess(BarManager).IsAfterLoading and not IsDestroying then
      InternalInitialization;
end;

procedure TdxRibbonSkinSelector.ChildrenListNotification(AValue: TdxBarItem; AAction: TListNotification);
begin
  inherited ChildrenListNotification(AValue, AAction);
end;

procedure TdxRibbonSkinSelector.ChangeScale(M, D: Integer);
begin
  inherited ChangeScale(M, D);
  Options.ChangeScale(M, D);
end;

procedure TdxRibbonSkinSelector.ChildrenListChanged;
begin
  inherited ChildrenListChanged;
  UpdateChildrenEnabled;
end;

function TdxRibbonSkinSelector.GetErrorCanPlaceText: string;
begin
  Result := cxGetResourceString(@dxSBAR_CANTPLACERIBBONSKINSELECTOR);
end;

procedure TdxRibbonSkinSelector.AfterLoadedInitialize;
begin
  inherited AfterLoadedInitialize;
  InternalInitialization;
end;

procedure TdxRibbonSkinSelector.InternalInitialization;
begin
  if not FLoaded then
  begin
    Refresh;
    if FLoaded then
      FController.UpdateRibbons(False);  
  end;
end;

function TdxRibbonSkinSelector.IsPreferredSkinNameStored: Boolean;
begin
  Result := not SameText(FPreferredSkinName, DefaultPreferredSkinName);
end;

function TdxRibbonSkinSelector.IsPreferredPaletteNameStored: Boolean;
begin
  Result := not SameText(FPreferredPaletteName, DefaultPreferredPaletteName);
end;

procedure TdxRibbonSkinSelector.DoAddSkin(ASkinDetails: TdxSkinDetails; var AAccepted: Boolean);
begin
  if Assigned(FOnAddSkin) then
    FOnAddSkin(Self, ASkinDetails.GroupName, ASkinDetails.Name, AAccepted);
end;

procedure TdxRibbonSkinSelector.DoAddPalette(const ASkinName: string; AColorPalette: TdxSkinColorPalette; var AAccepted: Boolean);
begin
  if Assigned(FOnAddPalette) then
    FOnAddPalette(Self, ASkinName, AColorPalette.Name, AAccepted);
end;

procedure TdxRibbonSkinSelector.DoSkinChanged(const ASkinName: string);
begin
  if Assigned(FOnSkinChanged) then
    FOnSkinChanged(Self, ASkinName);
end;

procedure TdxRibbonSkinSelector.DoPaletteChanged(const ASkinName, APaletteName: string);
begin
  if Assigned(FOnPaletteChanged) then
    FOnPaletteChanged(Self, ASkinName, APaletteName);
end;

function TdxRibbonSkinSelector.DoPopulateWithSkins(const ALoader: TdxRibbonSkinSelectorLoader): Boolean;
begin
  Result := False;
  if not FPopulateLocked and Assigned(FOnPopulate) then
  begin
    FPopulateLocked := True;
    try
      FOnPopulate(Self, ALoader, Result);
    finally
      FPopulateLocked := False;
    end;
  end;
end;

function TdxRibbonSkinSelector.DoSetSkin(AHelper: TdxRibbonSkinSelectorSetSkinHelper; AArgs: TdxRibbonSkinSelectorSetSkinArgs): Boolean;
begin
  Result := False;
  if Assigned(FOnSetSkin) then
    FOnSetSkin(Self, AHelper, AArgs, Result);
end;

class function TdxRibbonSkinSelector.GetNewCaption: string;
begin
  Result := cxGetResourceString(@dxSBAR_NEWRIBBONSKINSELECTORCAPTION);
end;

procedure TdxRibbonSkinSelector.EnabledChanged;
begin
  inherited EnabledChanged;
  UpdateChildrenEnabled;
end;

procedure TdxRibbonSkinSelector.UpdateChildrenEnabled;
var
  I: Integer;
begin
  if not IsDestroying then
    for I := 0 to ChildCount - 1 do
      Children[I].Enabled := Enabled;
  FController.UpdateEnabled;
end;


procedure TdxRibbonSkinSelector.BeginUpdate;
begin
  Inc(FLockCount);
  Options.BeginUpdate;
end;

procedure TdxRibbonSkinSelector.EndUpdate;
begin
  try
    Options.EndUpdate;
  finally
    Dec(FLockCount);
    if (FLockCount = 0) and (FChanges <> []) then
      SkinSelectorChanged(FChanges);
  end;
end;

procedure TdxRibbonSkinSelector.SkinSelectorChanged(AChanges: TdxRibbonSkinSelectorChanges);
begin
  FChanges := FChanges + AChanges;
  if (FLockCount > 0) or IsDestroying or (BarManager = nil) or
    TdxBarManagerAccess(BarManager).IsLoading or (LinkCount = 0) then
      Exit;
  DoSkinSelectorChanged(FChanges);
end;

procedure TdxRibbonSkinSelector.TranslationChanged;
begin
  if FTranslationLocked then
    Exit;
  FTranslationLocked := True;
  dxThreading.TdxUIThreadSyncService.EnqueueInvokeInUIThread(Self,
    procedure
    begin
      FTranslationLocked := False;
      Refresh;
    end);
end;

procedure TdxRibbonSkinSelector.DoSkinSelectorChanged(AChanges: TdxRibbonSkinSelectorChanges);
const
  Choosers: TdxRibbonSkinSelectorChanges = [TdxRibbonSkinSelectorChange.SkinChooserProperties,
    TdxRibbonSkinSelectorChange.PaletteChooserProperties];

  function GetChooserTypes(AChanges: TdxRibbonSkinSelectorChanges): TdxRibbonSkinSelectorChooserTypes;
  begin
    Result := [];
    if TdxRibbonSkinSelectorChange.SkinChooserProperties in AChanges then
      Include(Result, TdxRibbonSkinSelectorChooserType.SkinChooser);
    if TdxRibbonSkinSelectorChange.PaletteChooserProperties in AChanges then
      Include(Result, TdxRibbonSkinSelectorChooserType.PaletteChooser);
  end;

  procedure RefreshController;
  begin
    FLoaded := True;
    FController.Refresh;
  end;

begin
  FChanges := [];
  if (TdxRibbonSkinSelectorChange.Build in AChanges) or ((AChanges <> []) and not FLoaded) then
  begin
    RefreshController;
    Exit;
  end;
  if Choosers * AChanges <> [] then
    FController.UpdateChooserProperties(GetChooserTypes(AChanges));
  if TdxRibbonSkinSelectorChange.SkinValues in AChanges then
    FController.ApplySkinValues;
end;

procedure TdxRibbonSkinSelector.Refresh;
begin
  SkinSelectorChanged([TdxRibbonSkinSelectorChange.Build]);
end;

procedure TdxRibbonSkinSelector.Reset;
begin
  FController.ClearUserSkinSource;
end;

procedure TdxRibbonSkinSelector.UpdateSkinValues;
begin
  FController.SynchronizeSelectedItems;
end;

procedure TdxRibbonSkinSelector.LoadFromFile(const AFileName: string; const ASkinName: string = ''; const APaletteName: string = '');
begin
  if FPopulateLocked then
    Exit;
  BarManager.BeginUpdate;
  try
    BeginUpdate;
    try
      FController.LoadSkinsFromFile(AFileName);
      SetSkinIfNeeded(ASkinName, APaletteName);
    finally
      EndUpdate;
    end;
  finally
    BarManager.EndUpdate;
  end;
end;

procedure TdxRibbonSkinSelector.LoadFromStream(AStream: TStream; const ASkinName: string = ''; const APaletteName: string = '');
begin
  if FPopulateLocked then
    Exit;
  BarManager.BeginUpdate;
  try
    BeginUpdate;
    try
      FController.LoadSkinsFromStream(AStream);
      SetSkinIfNeeded(ASkinName, APaletteName);
    finally
      EndUpdate;
    end;
  finally
    BarManager.EndUpdate;
  end;
end;

procedure TdxRibbonSkinSelector.LoadFromResource(AInstance: HINST; const AResourceName: string; const ASkinName: string = ''; const APaletteName: string = '');
begin
  if FPopulateLocked then
    Exit;
  BarManager.BeginUpdate;
  try
    BeginUpdate;
    try
      FController.LoadSkinsFromResource(AInstance, AResourceName);
      SetSkinIfNeeded(ASkinName, APaletteName);
    finally
      EndUpdate;
    end;
  finally
    BarManager.EndUpdate;
  end;
end;

procedure TdxRibbonSkinSelector.LoadFromResources(AInstance: HINST; const ASkinName : string = ''; const APaletteName: string = '');
begin
  if FPopulateLocked then
    Exit;
  BarManager.BeginUpdate;
  try
    BeginUpdate;
    try
      FController.LoadSkinsFromResources(AInstance);
      SetSkinIfNeeded(ASkinName, APaletteName);
    finally
      EndUpdate;
    end;
  finally
    BarManager.EndUpdate;
  end;
end;

procedure TdxRibbonSkinSelector.AddFromFile(const AFileName: string);
begin
  if FPopulateLocked then
    Exit;
  FController.AddSkinsFromFile(AFileName);
end;

procedure TdxRibbonSkinSelector.AddFromResource(AInstance: HINST; const AResourceName: string);
begin
  if FPopulateLocked then
    Exit;
  FController.AddSkinsFromResource(AInstance, AResourceName);
end;

procedure TdxRibbonSkinSelector.AddFromResources(AInstance: HINST);
begin
  if FPopulateLocked then
    Exit;
  FController.AddSkinsFromResources(AInstance);
end;

{ TdxRibbonSkinSelectorControl }

function TdxRibbonSkinSelectorControl.GetCompositeViewInfoClass: TdxBarItemControlViewInfoClass;
begin
  Result := TdxRibbonSkinSelectorControlViewInfo;
end;

function TdxRibbonSkinSelectorControl.GetErrorWhenEmbedIntoDropDownWindow: string;
begin
  Result := cxGetResourceString(@dxSBAR_CANTPLACERIBBONSKINSELECTORFORSUBMENU);
end;

{ TdxRibbonSkinSelectorControlViewInfo }

procedure TdxRibbonSkinSelectorControlViewInfo.DoPaint(ACanvas: TcxCanvas; ARect: TRect; APaintType: TdxBarPaintType);
begin
  if NeedStub then
    DrawStub(ACanvas, ARect)
  else
    inherited DoPaint(ACanvas, ARect, APaintType);
end;

function TdxRibbonSkinSelectorControlViewInfo.NeedStub: Boolean;
begin
  Result := ChildCount = 0;
end;

function TdxRibbonSkinSelectorControlViewInfo.GetDefaultWidth: Integer;
begin
  Result := inherited GetDefaultWidth;
  if NeedStub then
    Result := Result * 4;
end;

procedure TdxRibbonSkinSelectorControlViewInfo.DrawStub(ACanvas: TcxCanvas; ARect: TRect);

  procedure DrawHatch(ARect: TRect);
  var
    ABrush: HBRUSH;
    APrevBkColor: TColor;
    ADC: HDC;
  begin
    ADC := ACanvas.Handle;
    ABrush := CreateHatchBrush(HS_BDIAGONAL, GetSysColor(COLOR_BTNSHADOW));
    APrevBkColor := SetBkColor(ADC, cxGetBrushData(ACanvas.Brush.Handle).lbColor);
    FillRect(ADC, ARect, ABrush);
    SetBkColor(ADC, APrevBkColor);
    FrameRect(ADC, ARect, GetSysColorBrush(COLOR_BTNSHADOW));
    DeleteObject(ABrush);
  end;

  function GetStubCaption: string;
  const
    DesignTimeCaption = 'Add a TdxSkinController';
    RunTimeCaption = 'No skin source';
  begin
    if Control.BarManager.Designing then
      Result := DesignTimeCaption
    else
      Result := RunTimeCaption;
  end;

var
  AColor1, AColor2: TColor;
  AIndent: Integer;
begin
  AIndent := Control.ScaleFactor.Apply(DefaultWidthIndent);
  ARect.Inflate(-AIndent, -AIndent);
  Control.GetDefaultTextColors(True, False, True, AColor1, AColor2);

  DrawHatch(ARect);

  AColor2 := ACanvas.Font.Color;
  ACanvas.Font.Color := AColor1;
  ACanvas.DrawTexT(GetStubCaption, ARect, TAlignment.taCenter, TcxAlignmentVert.vaCenter, False, True);
  ACanvas.Font.Color := AColor2;
end;

{$ENDREGION}

{$ENDREGION}

initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxBarRegisterItem(TdxSkinChooserGalleryItem, TdxCustomChooserGalleryControl, True);
  dxBarRegisterItem(TdxSkinPaletteChooserGalleryItem, TdxCustomChooserGalleryControl, False);
  dxBarRegisterItem(TdxRibbonCompositeItem, TdxRibbonCompositeItemControl, False);
  dxBarRegisterItem(TdxRibbonSkinSelector, TdxRibbonSkinSelectorControl, True);
  dxBarRegisterItem(TdxRibbonSkinSelectorController.TSkinChooser, TdxRibbonSkinSelectorController.TSkinChooserControl, False);
  dxBarRegisterItem(TdxRibbonSkinSelectorController.TSearchEdit, TdxRibbonSkinSelectorController.TSearchEditControl, False);
  dxBarRegisterItem(TdxRibbonSkinSelectorController.TPaletteChooser, TdxCustomChooserGalleryControl, False);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxRibbonSkinSelectorController.TSkinManagerUpdater.Finalize;
  dxBarUnregisterItem(TdxRibbonSkinSelectorController.TPaletteChooser);
  dxBarUnregisterItem(TdxRibbonSkinSelectorController.TSearchEdit);
  dxBarUnregisterItem(TdxRibbonSkinSelectorController.TSkinChooser);
  dxBarUnregisterItem(TdxRibbonSkinSelector);
  dxBarUnregisterItem(TdxRibbonCompositeItem);
  dxBarUnregisterItem(TdxSkinPaletteChooserGalleryItem);
  dxBarUnregisterItem(TdxSkinChooserGalleryItem);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
