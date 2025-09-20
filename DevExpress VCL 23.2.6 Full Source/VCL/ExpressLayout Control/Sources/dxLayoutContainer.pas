{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressLayoutControl main components                     }
{                                                                    }
{           Copyright (c) 2001-2024 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSLAYOUTCONTROL AND ALL          }
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

unit dxLayoutContainer;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Messages, Windows, SysUtils, Classes, Menus, Graphics, MultiMon,
  Forms, Controls {after Forms for D12},
  Generics.Defaults, Generics.Collections,
  StdCtrls, ExtCtrls, IniFiles, Contnrs, ImgList, ActnList,
  dxCore, dxCoreGraphics, dxCoreClasses, dxMessages, dxGDIPlusClasses,
  cxClasses, cxGeometry, cxGraphics, cxControls, dxForms,
  cxLookAndFeels, cxLibraryConsts, cxLookAndFeelPainters, cxStorage,
  dxLayoutLookAndFeels, dxLayoutCommon, dxLayoutSelection, cxPC, cxScrollbar, dxFormattedText, dxCheckGroupBox;

const
  htError = -1;
  htNone = 0;
  htCustomizeForm = 1;
  htItem = 10;
  htGroup = 20;
  htClientArea = 30;
  htAvailableItems = 40;
  htTreeViewItems = 50;
  htBasicItem = 60;
  htSizeHandle = 70;

  dxLayoutItemControlDefaultMinSize = 20;
  dxLayoutItemControlDefaultMinHeight = dxLayoutItemControlDefaultMinSize;
  dxLayoutItemControlDefaultMinWidth = dxLayoutItemControlDefaultMinSize;

  dxLayoutItemMinSize = 5;
  dxLayoutVersion = 3;

  dxLayoutCorrectionForDisabling = 1;

  dxLayoutThinPartWidth = 2;
  dxLayoutThickPartWidth = 8;

type
  //Base
  TdxCustomLayoutItem = class;
  TdxCustomLayoutItemClass = class of TdxCustomLayoutItem;
  TdxLayoutItem = class;
  TdxCustomLayoutGroup = class;
  TdxCustomLayoutGroupClass = class of TdxCustomLayoutGroup;
  TdxLayoutAutoCreatedGroup = class;
  TdxLayoutAutoCreatedGroupClass = class of TdxLayoutAutoCreatedGroup;
  TdxLayoutGroup = class;
  TdxLayoutGroupClass = class of TdxLayoutGroup;
  TdxLayoutEmptySpaceItem = class;
  TdxLayoutEmptySpaceItemClass = class of TdxLayoutEmptySpaceItem;
  TdxLayoutLabeledItem = class;
  TdxLayoutLabeledItemClass = class of TdxLayoutLabeledItem;
  TdxLayoutSeparatorItem = class;
  TdxLayoutSeparatorItemClass = class of TdxLayoutSeparatorItem;
  TdxLayoutSplitterItem = class;
  TdxCustomLayoutCheckableItem = class;
  TdxLayoutCheckBoxItem = class;
  TdxLayoutRadioButtonItem = class;

  //Secondary
  TdxLayoutContainer = class;
  TdxLayoutAlignmentConstraint = class;
  TdxCustomLayoutHitTest = class;
  TdxLayoutGroupHelper = class;
  TdxLayoutGroupHelperClass = class of TdxLayoutGroupHelper;
  TdxLayoutItemViewDataList = class;

  //Painter
  TdxLayoutContainerPainter = class;
  TdxLayoutContainerPainterClass = class of TdxLayoutContainerPainter;
  TdxCustomLayoutItemPainter = class;
  TdxCustomLayoutItemPainterClass = class of TdxCustomLayoutItemPainter;
  TdxLayoutBasicItemPainter = class;
  TdxLayoutBasicItemPainterClass = class of TdxLayoutBasicItemPainter;
  TdxLayoutItemPainter = class;
  TdxLayoutItemPainterClass = class of TdxLayoutItemPainter;
  TdxLayoutGroupPainter = class;
  TdxLayoutGroupPainterClass = class of TdxLayoutGroupPainter;
  TdxLayoutControlItemControlPainter = class;
  TdxLayoutControlItemControlPainterClass = class of TdxLayoutControlItemControlPainter;
  TdxLayoutItemControlPainter = class;
  TdxLayoutItemControlPainterClass = class of TdxLayoutItemControlPainter;
  TdxCustomLayoutItemCaptionPainter = class;
  TdxCustomLayoutItemCaptionPainterClass = class of TdxCustomLayoutItemCaptionPainter;
  TdxLayoutGroupButtonPainter = class;
  TdxLayoutGroupButtonPainterClass = class of TdxLayoutGroupButtonPainter;
  TdxLayoutEmptySpaceItemPainter = class;
  TdxLayoutEmptySpaceItemPainterClass = class of TdxLayoutEmptySpaceItemPainter;
  TdxLayoutDirectionalItemPainter = class;
  TdxLayoutDirectionalItemPainterClass = class of TdxLayoutDirectionalItemPainter;
  TdxLayoutSeparatorItemPainter = class;
  TdxLayoutSeparatorItemPainterClass = class of TdxLayoutSeparatorItemPainter;
  TdxLayoutSplitterItemPainter = class;
  TdxLayoutSplitterItemPainterClass = class of TdxLayoutSplitterItemPainter;

  // ViewInfo
  TdxLayoutContainerViewInfo = class;
  TdxLayoutContainerViewInfoClass = class of TdxLayoutContainerViewInfo;
  TdxCustomLayoutElementViewInfo = class;
  TdxCustomLayoutItemElementViewInfo = class;
  TdxCustomLayoutItemCaptionViewInfo = class;
  TdxCustomLayoutItemViewInfo = class;
  TdxCustomLayoutItemViewInfoClass = class of TdxCustomLayoutItemViewInfo;
  TdxLayoutItemCaptionViewInfo = class;
  TdxLayoutCellItemCellViewInfo = class;
  TdxLayoutCellItemCellViewInfoClass = class of TdxLayoutCellItemCellViewInfo;
  TdxLayoutControlItemControlViewInfo = class;
  TdxLayoutItemControlViewInfo = class;
  TdxLayoutItemControlViewInfoClass = class of TdxLayoutItemControlViewInfo;
  TdxLayoutLabeledItemViewInfo = class;
  TdxLayoutImageItemViewInfo = class;
  TdxLayoutCheckBoxItemViewInfo = class;
  TdxLayoutRadioButtonItemViewInfo = class;
  TdxLayoutControlItemViewInfo = class;
  TdxLayoutItemViewInfo = class;
  TdxLayoutItemViewInfoClass = class of TdxLayoutItemViewInfo;
  TdxLayoutGroupViewInfo = class;
  TdxLayoutGroupViewInfoClass = class of TdxLayoutGroupViewInfo;
  TdxLayoutRootViewInfo = class;
  TdxLayoutRootViewInfoClass = class of TdxLayoutRootViewInfo;
  TdxLayoutGroupButtonViewInfo = class;
  TdxLayoutGroupButtonViewInfoClass = class of TdxLayoutGroupButtonViewInfo;
  TdxLayoutEmptySpaceItemViewInfo = class;
  TdxLayoutEmptySpaceItemViewInfoClass = class of TdxLayoutEmptySpaceItemViewInfo;
  TdxLayoutSeparatorItemViewInfo = class;
  TdxLayoutSeparatorItemViewInfoClass = class of TdxLayoutSeparatorItemViewInfo;
  TdxLayoutSplitterItemViewInfo = class;
  TdxLayoutSplitterItemViewInfoClass = class of TdxLayoutSplitterItemViewInfo;

  TdxLayoutGroupViewInfoSpecific = class;
  TdxLayoutGroupViewInfoSpecificClass = class of TdxLayoutGroupViewInfoSpecific;
  TdxLayoutGroupViewInfoTabbedSpecific = class;

  // custom item

  TdxLayoutAlignAbs = (aaNear, aaCenter, aaFar, aaClient);
  TdxLayoutAlignHorz = (ahLeft, ahCenter, ahRight, ahClient, ahParentManaged);
  TdxLayoutAlignVert = (avTop, avCenter, avBottom, avClient, avParentManaged);
  TdxLayoutRealAlignHorz = ahLeft..ahClient;
  TdxLayoutRealAlignVert = avTop..avClient;
  TdxLayoutItemControlAlignHorz = TdxLayoutRealAlignHorz;
  TdxLayoutItemControlAlignVert = TdxLayoutRealAlignVert;
  TdxLayoutItemControlAreaAlignment = (catDefault, catNone, catAuto, catOwn);
  TdxLayoutAutoAlign = (aaHorizontal, aaVertical);
  TdxLayoutAutoAligns = set of TdxLayoutAutoAlign;
  TdxLayoutDirection = (ldHorizontal, ldVertical, ldTabbed);
  TdxLayoutDragDropMode = (ddmDefault, ddmMultiChoice);
  TdxLayoutDropAreaPart = (apNone, apLeft, apTop, apRight, apBottom,
    apBefore, apAfter, apBetween, apNewLayout, apLastChild);
  TdxLayoutActionType = (atNone, atInsert, atCreateGroup, atContentInsert);
  TdxLayoutCustomizeFormUpdateType = (cfutCaption, cfutAvailableItems, cfutVisibleItems, cfutSelection, cfutView, cfutDragAndDropState);
  TdxLayoutCustomizeFormUpdateTypes = set of TdxLayoutCustomizeFormUpdateType;
  TdxLayoutCustomizeFormMenuItem = (cfmiAlignHorz, cfmiAlignVert, cfmiDirection, cfmiCaptionLayout, cfmiCaptionAlignHorz,
    cfmiCaptionAlignVert, cfmiCaption, cfmiBorder, cfmiExpandButton, cfmiGrouping, cfmiRename);
  TdxLayoutCustomizeFormMenuItems = set of TdxLayoutCustomizeFormMenuItem;
  TdxLayoutAvailableItemsViewKind = (aivkList, aivkTree);
  TdxLayoutItemChangedEvent = procedure(AItem: TdxCustomLayoutItem) of object;
  TdxLayoutItemCanResizeEvent = procedure(Sender: TObject; AItem: TdxCustomLayoutItem; var ANewSize: Integer; var AAccept: Boolean) of object;

  TdxLayoutAlign = record
    Horz: TdxLayoutAlignHorz;
    Vert: TdxLayoutAlignVert;
  end;

  TdxLayoutRealAlign = record
    Horz: TdxLayoutRealAlignHorz;
    Vert: TdxLayoutRealAlignVert;
  end;

  TdxAbsPoint = record
    Major: Integer;
    Minor: Integer;
  end;

  TdxAbsSize = TdxAbsPoint;

  TdxAbsRect = record
    NearMajor: Integer;
    NearMinor: Integer;
    FarMajor: Integer;
    FarMinor: Integer;
  private
    function GetSize: TdxAbsSize;
    function GetNearPoint: TdxAbsPoint;
    procedure SetNearPoint(const AValue: TdxAbsPoint);
    function GetFarPoint: TdxAbsPoint;
    procedure SetFarPoint(const AValue: TdxAbsPoint);
  public
    property Size: TdxAbsSize read GetSize;
    property NearPoint: TdxAbsPoint read GetNearPoint write SetNearPoint;
    property FarPoint: TdxAbsPoint read GetFarPoint write SetFarPoint;
  end;

  TdxLayoutDragDropInfo = record
    SourceItem: TdxCustomLayoutItem;
    DragScreenPoint: TPoint;

    HitContainer: TdxLayoutContainer;
    HitTest: TdxCustomLayoutHitTest;
    HitItem: TdxCustomLayoutItem;

    DestinationContainer: TdxLayoutContainer;
    DestinationGroup: TdxCustomLayoutGroup;
    DestinationItem: TdxCustomLayoutItem;

    DropClientPoint: TPoint;
    DropAreaPart: TdxLayoutDropAreaPart;
    DropPartSize: Integer;
    ExpectedAlign: TdxLayoutAlign;

    SourceItemSize: TSize;
  end;

  IdxLayoutContainerOwner = interface
  ['{85310BD8-3D7A-454F-A54B-9898C0AA55A2}']
    function GetContainer: TdxLayoutContainer;
  end;

  { TdxUndoRedoManager }

  TdxUndoRedoManager = class(TPersistent)
  private
    FContainer: TdxLayoutContainer;
    FIndex: Integer;
    FRestorePoints: TObjectList;

    function IsCurrentLayoutStored: Boolean;
    procedure RestoreLayout(AIndex: Integer);
    function GetRedoCount: Integer;
    function GetUndoCount: Integer;
  protected
    procedure AddRestorePoint;
    procedure DeleteRestorePoint;
    procedure RollBack;

    property RedoCount: Integer read GetRedoCount; 
    property UndoCount: Integer read GetUndoCount; 
  public
    constructor Create(AContainer: TdxLayoutContainer); virtual;
    destructor Destroy; override;

    function CanRedo: Boolean;
    function CanUndo: Boolean;
    procedure Clear;
    procedure Redo;
    procedure Undo;

    property Container: TdxLayoutContainer read FContainer;
  end;

  { TdxCustomLayoutItemOptions }

  TdxCustomLayoutItemOptions = class(TInterfacedPersistent)
  strict private
    FItem: TdxCustomLayoutItem;

    function GetIsRestoring: Boolean;
  protected
    procedure BeginUpdate;
    procedure Changed; virtual;
    procedure ChangeScale(M, D: Integer);
    procedure DoChangeScale(M, D: Integer); virtual;
    procedure DoAssign(Source: TPersistent); virtual;
    procedure EndUpdate;

    property Item: TdxCustomLayoutItem read FItem;
    property IsRestoring: Boolean read GetIsRestoring;
  public
    constructor Create(AItem: TdxCustomLayoutItem); virtual;
    procedure Assign(Source: TPersistent); override;
  end;

  { CustomizeForm }

  TdxLayoutControlCustomCustomizeFormClass = class of TdxLayoutControlCustomCustomizeForm;
  TdxLayoutControlCustomCustomizeForm = class(TdxForm)
  strict private
    FContainer: TdxLayoutContainer;
    FLayoutLookAndFeel: TdxCustomLayoutLookAndFeel;
    FLockCount: Integer;

    function GetIsLocked: Boolean;
    procedure SetContainer(AValue: TdxLayoutContainer);
  protected
    procedure AssignFont(ASourceFont: TFont; ASourceScaleFactor: TdxScaleFactor);
    procedure CreateParams(var Params: TCreateParams); override;

    function CanAddItem: Boolean; virtual;
    function CanModify: Boolean; virtual;
    function CanShowItem(AItem: TdxCustomLayoutItem): Boolean; virtual;
    function DoGetMenuItems(AList: TList): TdxLayoutCustomizeFormMenuItems;
    procedure DoInitializeControl; virtual;
    function GetWndParent: THandle; virtual;
    procedure ItemChanged(AItem: TdxCustomLayoutItem); virtual;
    function GetLayoutPopupMenu: TPopupMenu; virtual;
    procedure InitializeControl; virtual;
    procedure RefreshLayoutLookAndFeel; virtual;
    procedure ResetDragAndDropObjects; virtual;

    function GetCustomizationCaption(AItem: TdxCustomLayoutItem): string; virtual;
    procedure SetCustomizationCaption(AItem: TdxCustomLayoutItem; const ACaption: string); virtual;

    procedure Changed; virtual;

    property IsLocked: Boolean read GetIsLocked;
    property LayoutLookAndFeel: TdxCustomLayoutLookAndFeel read FLayoutLookAndFeel;
    property LockCount: Integer read FLockCount;
  public
    destructor Destroy; override;

    procedure Initialize; virtual;
    // Updates
    procedure BeginUpdate;
    procedure CancelUpdate;
    procedure EndUpdate;

    function GetHitTest(const P: TPoint): TdxCustomLayoutHitTest; virtual;
    procedure ToggleHotTrackState(AItem: TdxCustomLayoutItem); virtual;

    procedure UpdateAvailableItems; virtual;
    procedure UpdateCaption; virtual;
    procedure UpdateContent; virtual;
    procedure UpdateDragAndDropState; virtual;
    procedure UpdateSelection; virtual;
    procedure UpdateView; virtual;
    procedure UpdateVisibleItems; virtual;

    property Container: TdxLayoutContainer read FContainer write SetContainer;
    property LayoutPopupMenu: TPopupMenu read GetLayoutPopupMenu;
  end;

  { TdxLayoutItemImageOptions }

  TdxCustomLayoutItemImageOptions = class(TdxCustomLayoutItemOptions)
  strict private
    FGlyph: TdxSmartGlyph;
    FImageIndex: Integer;

    procedure SetGlyph(AValue: TdxSmartGlyph);
    procedure SetImageIndex(AValue: Integer);

    procedure GlyphChanged(Sender: TObject);
  protected
    function GetCurrentImage(out AGlyph: TdxSmartGlyph; out AImages: TCustomImageList; out AImageIndex: Integer): Boolean;
    function GetImageList(AEnabled: Boolean): TCustomImageList;
    function GetImageSize: TSize;
    function IsImageAssigned: Boolean;

    procedure DoAssign(Source: TPersistent); override;
  public
    constructor Create(AItem: TdxCustomLayoutItem); override;
    destructor Destroy; override;
  published
    property Glyph: TdxSmartGlyph read FGlyph write SetGlyph;
    property ImageIndex: Integer read FImageIndex write SetImageIndex default -1;
  end;

  TdxCaptionLayout = (clLeft, clTop, clRight, clBottom);
  TdxLayoutItemCaptionVisibleElement = (cveImage, cveText);
  TdxLayoutItemCaptionVisibleElements = set of TdxLayoutItemCaptionVisibleElement;

  TdxCustomLayoutItemCaptionOptions = class(TdxCustomLayoutItemOptions, IdxFormattedTextOwner)
  private
    FAlignHorz: TAlignment;
    FAlignVert: TdxAlignmentVert;
    FEllipsisPosition: TEllipsisPosition;
    FExpandTabs: Boolean;
    FFormattedText: TdxFormattedText;
    FHint: string;
    FImageOptions: TdxCustomLayoutItemImageOptions;
    FLayout: TdxCaptionLayout;
    FDefaultCaption: string;
    FUserCaption: string;
    FIsCaptionAssigned: Boolean;
    FVisibleElements: TdxLayoutItemCaptionVisibleElements;
    FVisible: Boolean;

    function GetGlyph: TdxSmartGlyph;
    function GetImageIndex: Integer;
    function GetShowAccelChar: Boolean;
    procedure SetAlignHorz(Value: TAlignment);
    procedure SetAlignVert(Value: TdxAlignmentVert);
    procedure SetEllipsisPosition(Value: TEllipsisPosition);
    procedure SetGlyph(AValue: TdxSmartGlyph);
    procedure SetImageIndex(AValue: Integer);
    procedure SetImageOptions(Value: TdxCustomLayoutItemImageOptions);
    procedure SetLayout(Value: TdxCaptionLayout);
    procedure SetShowAccelChar(Value: Boolean);
    procedure SetVisibleElements(Value: TdxLayoutItemCaptionVisibleElements);
    procedure SetVisible(Value: Boolean);
  protected
    function IsTextStored: Boolean; virtual;
    function IsTextVisible: Boolean; inline;
    function GetText: string; virtual;
    procedure RecoverUserCaption;
    procedure ResetUserCaption(AFull: Boolean);

    procedure SetDefaultCaption(const Value: string);
    procedure SetText(const Value: string); virtual;
    procedure SetUserCaption(const Value: string);
    // storing
    procedure GetStoredPropertyValue(const AName: string; var AValue: Variant); virtual;
    procedure GetStoredProperties(AProperties: TStrings); virtual;
    procedure SetStoredPropertyValue(const AName: string; const AValue: Variant); virtual;

    procedure DoAssign(Source: TPersistent); override;

    // IdxFormattedTextOwner
    function GetFormattedTextFont: TFont;
    function IdxFormattedTextOwner.GetFormattedText = GetText;
    function GetUseFormattedText: Boolean;
    procedure IdxFormattedTextOwner.SetFormattedText = SetText;

    property EllipsisPosition: TEllipsisPosition read FEllipsisPosition write SetEllipsisPosition default epNone;
    property ExpandTabs: Boolean read FExpandTabs write FExpandTabs;
    property FormattedText: TdxFormattedText read FFormattedText;
    property Glyph: TdxSmartGlyph read GetGlyph write SetGlyph;
    property IsCaptionAssigned: Boolean read FIsCaptionAssigned;
    property Hint: string read FHint write FHint;
    property ImageIndex: Integer read GetImageIndex write SetImageIndex default -1;
    property ImageOptions: TdxCustomLayoutItemImageOptions read FImageOptions write SetImageOptions;
    property Layout: TdxCaptionLayout read FLayout write SetLayout;
    property ShowAccelChar: Boolean read GetShowAccelChar write SetShowAccelChar default True;
    property VisibleElements: TdxLayoutItemCaptionVisibleElements read FVisibleElements write SetVisibleElements default [cveImage, cveText];
    property UserCaption: string read FUserCaption write SetUserCaption;
    property DefaultCaption: string read FDefaultCaption write SetDefaultCaption;
  public
    constructor Create(AItem: TdxCustomLayoutItem); override;
    destructor Destroy; override;

    property AlignHorz: TAlignment read FAlignHorz write SetAlignHorz default taLeftJustify;
    property AlignVert: TdxAlignmentVert read FAlignVert write SetAlignVert;
    property Text: string read GetText write SetText stored IsTextStored;
    property Visible: Boolean read FVisible write SetVisible default True;
  end;
  TdxCustomLayoutItemCaptionOptionsClass = class of TdxCustomLayoutItemCaptionOptions;

  TdxLayoutSizeOptionsValue = (sovSizableHorz, sovSizableVert);
  TdxLayoutSizeOptionsValues = set of TdxLayoutSizeOptionsValue;

  TdxLayoutSizeOptions = class(TdxCustomLayoutItemOptions)
  private
    FAssignedValues: TdxLayoutSizeOptionsValues;
    FSizableHorz: Boolean;
    FSizableVert: Boolean;
    FWidth: Integer;
    FHeight: Integer;
    FMaxWidth: Integer;
    FMaxHeight: Integer;

    function GetSizableHorz: Boolean;
    function GetSizableVert: Boolean;
    procedure SetAssignedValues(Value: TdxLayoutSizeOptionsValues);
    procedure SetSizableHorz(Value: Boolean);
    procedure SetSizableVert(Value: Boolean);
    procedure SetHeight(Value: Integer);
    procedure SetWidth(Value: Integer);
    procedure SetMaxHeight(Value: Integer);
    procedure SetMaxWidth(Value: Integer);

    function IsSizableHorzStored: Boolean;
    function IsSizableVertStored: Boolean;
  protected
    procedure DoAssign(Source: TPersistent); override;
    procedure DoChangeScale(M: Integer; D: Integer); override;
    procedure Changed; override;
  published
    property AssignedValues: TdxLayoutSizeOptionsValues read FAssignedValues write SetAssignedValues default [];
    property SizableHorz: Boolean read GetSizableHorz write SetSizableHorz stored IsSizableHorzStored;
    property SizableVert: Boolean read GetSizableVert write SetSizableVert stored IsSizableVertStored;
    property Height: Integer read FHeight write SetHeight default 0;
    property Width: Integer read FWidth write SetWidth default 0;
    property MaxHeight: Integer read FMaxHeight write SetMaxHeight default 0;
    property MaxWidth: Integer read FMaxWidth write SetMaxWidth default 0;
  end;

  { TdxLayoutOffsets }

  TdxLayoutOffsets = class(TdxCustomLayoutItemOptions)
  strict private
    FBottom: Integer;
    FLeft: Integer;
    FRight: Integer;
    FTop: Integer;
  protected
    function GetValue(Index: Integer): Integer; virtual;
    procedure SetValue(Index: Integer; Value: Integer); virtual;
    procedure DoAssign(Source: TPersistent); override;
    procedure DoChangeScale(M, D: Integer); override;
  published
    property Bottom: Integer index 1 read GetValue write SetValue default 0;
    property Left: Integer index 2 read GetValue write SetValue default 0;
    property Right: Integer index 3 read GetValue write SetValue default 0;
    property Top: Integer index 4 read GetValue write SetValue default 0;
  end;

  { TdxLayoutPadding }

  TdxLayoutPadding = class(TdxLayoutOffsets)
  strict private
    FAssignedValues: TdxLayoutPaddingAssignedValues;

    function IsValueStored(Index: Integer): Boolean;
    procedure SetAssignedValues(Value: TdxLayoutPaddingAssignedValues);
  protected
    procedure DoAssign(Source: TPersistent); override;
    function GetValue(Index: Integer): Integer; override;
    procedure SetValue(Index: Integer; Value: Integer); override;
  public
    function GetValues: TRect;
  published
    property AssignedValues: TdxLayoutPaddingAssignedValues read FAssignedValues write SetAssignedValues default [];
    property Bottom stored IsValueStored;
    property Left stored IsValueStored;
    property Right stored IsValueStored;
    property Top stored IsValueStored;
  end;

  { TdxLayoutCustomFloatForm }

  TdxLayoutCustomFloatForm = class(TdxCustomFloatForm, IdxSkinSupport2)
  protected
    FIsFloat: Boolean;
    procedure ShowFloat(const APosition: TPoint; ANeedActivate: Boolean; AHidden: Boolean = False);
    // IdxSkinSupport2
    function IsSkinnable: Boolean;
  end;

  { TdxCustomLayoutItem }

  TdxLayoutItemChangeType = (ictHard, ictMedium, ictLight, ictComplex, ictSimple);

  TdxCustomLayoutItem = class(TcxCustomComponent,
    IdxLayoutLookAndFeelUser,
    IdxLayoutSelectableItem,
    IdxScaleFactor,
    IcxStoredObject)
  private
    // Align
    FAlign: TdxLayoutAlign;
    FRealAlign: TdxLayoutAlign;
    FAlignmentConstraint: TdxLayoutAlignmentConstraint;

    // Allow
    FAllowRemove: Boolean;
    FAllowQuickCustomize: Boolean;
    FAllowFloating: Boolean;
    FInternalCanQuickCustomized: Boolean;

    FContainer: TdxLayoutContainer;
    FCustomization: Boolean;
    FData: Pointer;
    FEnabled: Boolean;
    FRealEnabled: TdxDefaultBoolean;
    FIsDestroying: Boolean;
    FIsUserDefined: Boolean;
    FLayoutLookAndFeel: TdxCustomLayoutLookAndFeel;
    // storing
    FLoadedIndex: Integer;
    FLoadedParentName: string;
    FLoadedFloat: Boolean;
    FLoadedTakeoffParentName: string;
    FSuperfluous: Boolean;

    FOffsets: TdxLayoutOffsets;
    FPadding: TdxLayoutPadding;
    FParent: TdxCustomLayoutGroup;
    FVisible: Boolean;

    FCaptionOptions: TdxCustomLayoutItemCaptionOptions;
    FSizeOptions: TdxLayoutSizeOptions;

    procedure ApplyLoadedPosition;

    function GetAlignHorz: TdxLayoutAlignHorz;
    function GetAlignVert: TdxLayoutAlignVert;
    function GetRealAlign: TdxLayoutRealAlign;
    procedure SetAlign(Value: TdxLayoutAlign);
    procedure SetAlignHorz(Value: TdxLayoutAlignHorz);
    procedure SetAlignVert(Value: TdxLayoutAlignVert);
    procedure SetRealAlign(Value: TdxLayoutRealAlign);

    function GetAbsoluteIndex: Integer;
    function GetActuallyVisible: Boolean;
    function GetAutoAligns: TdxLayoutAutoAligns;
    function GetCaption: string; inline;
    function GetCaptionForCustomizeForm: string;
    function GetDefaultCaption: string;
    function GetEnabled: Boolean; inline;
    function GetIndex: Integer;
    function GetIsUserRenamed: Boolean;
    function GetRealContainer: TdxLayoutContainer;
    function GetScaleFactor: TdxScaleFactor;
    function GetViewInfo: TdxCustomLayoutItemViewInfo;
    function GetVisibleIndex: Integer;

    procedure SetAlignmentConstraint(Value: TdxLayoutAlignmentConstraint);
    procedure SetAutoAligns(Value: TdxLayoutAutoAligns);
    procedure SetCaption(const Value: string);
    procedure SetCaptionOptions(const Value: TdxCustomLayoutItemCaptionOptions);
    procedure SetContainer(Value: TdxLayoutContainer);
    procedure SetCustomization(Value: Boolean);
    procedure SetDefaultCaption(const Value: string);
    procedure SetEnabled(Value: Boolean);
    procedure SetLayoutLookAndFeel(Value: TdxCustomLayoutLookAndFeel);
    procedure SetIndex(Value: Integer);
    procedure SetIsUserDefined(Value: Boolean);
    procedure SetOffsets(const Value: TdxLayoutOffsets);
    procedure SetPadding(const Value: TdxLayoutPadding);
    procedure SetParent(Value: TdxCustomLayoutGroup);
    procedure SetShowCaption(Value: Boolean);
    procedure SetSizeOptions(Value: TdxLayoutSizeOptions);
    procedure SetTakeoffParent(Value: TdxCustomLayoutGroup);
    procedure SetVisible(Value: Boolean);
    procedure SetVisibleIndex(Value: Integer);

    function GetHeight: Integer;
    function GetWidth: Integer;
    procedure SetHeight(Value: Integer);
    procedure SetWidth(Value: Integer);

    procedure ReadIndex(Reader: TReader);
    procedure WriteIndex(Writer: TWriter);

    function IsAlignHorzStored: Boolean;
    function IsAlignVertStored: Boolean;
    function IsClosedBySplitter: Boolean;
  protected
    FLockEvents: Boolean;
    // Float
    FIsFloat: Boolean;
    FFloatForm: TdxLayoutCustomFloatForm;
    FFloatPos: TPoint;
    //
    FTakeoffParent: TdxCustomLayoutGroup;
    FTakeoffIndex: Integer;
    FParentBeforeDrag: TdxCustomLayoutGroup;
    FIndexBeforeDrag: Integer;

    FOnCaptionClick: TNotifyEvent;
    FOnStartFloat: TNotifyEvent;
    FOnEndFloat: TNotifyEvent;

    // IdxLayoutLookAndFeelUser
    procedure IdxLayoutLookAndFeelUser.BeginLookAndFeelDestroying = BeginLayoutLookAndFeelUserDestroying;
    procedure IdxLayoutLookAndFeelUser.EndLookAndFeelDestroying = EndLayoutLookAndFeelUserDestroying;
    procedure IdxLayoutLookAndFeelUser.LookAndFeelChanged = LayoutLookAndFeelUserChanged;
    procedure IdxLayoutLookAndFeelUser.LookAndFeelDestroyed = LayoutLookAndFeelUserDestroyed;
    procedure BeginLayoutLookAndFeelUserDestroying; stdcall;
    procedure EndLayoutLookAndFeelUserDestroying; stdcall;
    procedure LayoutLookAndFeelUserChanged; stdcall;
    procedure LayoutLookAndFeelUserDestroyed; stdcall;
    // IdxLayoutSelectableItem
    function CanDelete: Boolean; virtual;
    function IsOwner(AOwner: TComponent): Boolean; virtual;
    procedure SelectComponent(AShift: TShiftState = []); virtual;
    procedure SelectParent; virtual;
    procedure SelectionChanged; virtual;
    function IdxLayoutSelectableItem.IsVisible = IsSelectableItemVisible;
    function IsSelectableItemVisible: Boolean; virtual;
    procedure IdxLayoutSelectableItem.MakeVisible = SelectableItemMakeVisible;
    procedure SelectableItemMakeVisible; virtual;
    function GetSelectionBounds: TRect;
    // IcxStoredObject
    function IcxStoredObject.GetObjectName = GetStoredObjectName;
    function IcxStoredObject.GetProperties = GetStoredProperties;
    procedure IcxStoredObject.GetPropertyValue = GetStoredPropertyValue;
    procedure IcxStoredObject.SetPropertyValue = SetStoredPropertyValue;
    function GetStoredObjectName: string; virtual;
    function GetStoredProperties(AProperties: TStrings): Boolean; virtual;
    procedure GetStoredPropertyValue(const AName: string; var AValue: Variant); virtual;
    procedure SetStoredPropertyValue(const AName: string; const AValue: Variant); virtual;

    procedure DefineProperties(Filer: TFiler); override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetName(const Value: TComponentName); override;
    procedure SetParentComponent(Value: TComponent); override;

    procedure LayoutLookAndFeelChanged; virtual;
    procedure SetInitialSettings; virtual;

    procedure DoGetTabOrderList(List: TList); virtual;
    procedure GetTabOrderList(List: TList);

    function GetInplaceRenameCaption: string; virtual;
    procedure SetInplaceRenameCaption(const ACaption: string); virtual;
    procedure Rename(const ACaption: string);

    procedure DoCaptionDown; dynamic;
    procedure DoCaptionClick; dynamic;
    procedure DoPack; virtual;
    function DoProcessAccel: Boolean; dynamic;
    procedure InitiateAction; virtual;
    function InternalMove(AParent: TdxCustomLayoutGroup; AIndex: Integer; APack, AKeepAlign: Boolean): Boolean;
    procedure CheckAutoSize(ADropOnly: Boolean); virtual;

    procedure StopFloat;
    procedure LandingFloat;
    procedure MakeFloat(const APosition: TPoint; ANeedActivate: Boolean = False);
    procedure MoveFloat(const APosition: TPoint);
    procedure ShowFloat(ANeedActivate: Boolean);
    procedure HideFloat;

    function GetParentManagedAlignHorz: TdxLayoutAlignHorz; virtual;
    function GetParentManagedAlignVert: TdxLayoutAlignVert; virtual;
    function GetRealAlignHorz: TdxLayoutRealAlignHorz; virtual;
    function GetRealAlignVert: TdxLayoutRealAlignVert; virtual;
    function GetBaseName: string; virtual;
    function GetCursor(X, Y: Integer): TCursor; virtual;
    function GetIsRoot: Boolean; virtual;
    function GetIsVertical: Boolean; virtual;
    function GetLayoutLookAndFeel: TdxCustomLayoutLookAndFeel; virtual;
    function GetShowCaption: Boolean;
    function GetVisible: Boolean; virtual;
    function GetOptions: TdxCustomLayoutLookAndFeelOptions; virtual;

    procedure BeforeCalculateViewInfo; virtual;
    procedure AfterCalculateViewInfo; virtual;
    procedure ApplyCalculatedChanges; virtual;
    procedure ResetRealAlign; virtual;
    procedure ResetEnabled; virtual;

    procedure AfterRestoring; virtual;
    procedure BeforeRestoring; virtual;
    procedure CheckIndex; virtual;
    function IsEnabledStored: Boolean; virtual;
    function NeedDeleteAfterLoading: Boolean; virtual;
    procedure OptimizeAlignForStoring;
    procedure PopulateItems(AList: TList); virtual;
    procedure SetLoadedInfo(const AParentName: string; AIndex: Integer);

    function CanInit: Boolean; virtual;
    procedure DoInit; virtual;
    procedure Init;

    function AllowFloatingDragImage: Boolean; virtual;
    function IsAvailable: Boolean;
    function IsDesigning: Boolean;
    function IsDestroying: Boolean;
    function IsGrabbed: Boolean;
    function IsDragged: Boolean;
    function IsImageVisible: Boolean;
    function IsLoading: Boolean;
    function IsLocked: Boolean; virtual;
    function IsParentLocked: Boolean; virtual;
    function IsRestoring: Boolean;
    function IsSelected: Boolean;
    function IsStable: Boolean; virtual;
    function IsTextVisible: Boolean; inline;
    function IsVisibleForCustomization: Boolean; virtual;
    function IsViewInfoValid: Boolean;
    function IsHeightFixed: Boolean;
    function IsWidthFixed: Boolean;
    function IsWidthLimited: Boolean;
    function AsGroup: TdxCustomLayoutGroup; inline;
    function IsWrapItemsAllowed: Boolean; virtual;
    function IsGroup: Boolean; virtual;
    function IsFloatingRoot: Boolean; virtual;
    function IsParentGroup(AParentGroup: TdxCustomLayoutGroup): Boolean;
    function IsChildItem(AChildItem: TdxCustomLayoutItem): Boolean;
    function CanAcceptItem(AItem: TdxCustomLayoutItem): Boolean; virtual;
    function CanQuickDragAndDrop: Boolean; virtual;
    function CanQuickCustomized: Boolean; virtual;
    function CanFloat: Boolean; virtual;
    function CanBeActuallyVisible: Boolean;
    function CanBeAlone: Boolean; virtual;
    function CanDragAndDrop(const P: TPoint): Boolean; virtual;
    function CanProcessAccel: Boolean; virtual;
    function CanRemove: Boolean; virtual;
    function CanResizeHorz: Boolean; virtual;
    function CanResizeVert: Boolean; virtual;
    function HasControl: Boolean; virtual;
    function HasCaption: Boolean;
    function IsHorzLocalPositionStable: Boolean;
    function IsHorzPositionStable: Boolean;
    function IsVertLocalPositionStable: Boolean;
    function IsVertPositionStable: Boolean;

    procedure KeyDown(var Key: Word; Shift: TShiftState); virtual;
    procedure ProcessAccel; dynamic;
    function ProcessDialogChar(ACharCode: Word): Boolean; virtual;
    function ProcessDialogKey(ACharCode: Word; AKeyData: Integer; AFocusedItem: TdxCustomLayoutItem): Boolean; virtual;

    procedure RestoreItemControlBounds; virtual;

    class function GetCaptionOptionsClass: TdxCustomLayoutItemCaptionOptionsClass; virtual;
    class function GetItemClassKind: Integer; virtual;
    function GetParentHelperClass: TdxLayoutGroupHelperClass;
    function GetViewInfoClass: TdxCustomLayoutItemViewInfoClass; virtual; abstract;

    procedure LoadFromIni(AIniFile: TCustomIniFile; const ASection: string; AVersion: Integer); virtual;
    procedure SaveToIni(AIniFile: TCustomIniFile; const ASection: string); virtual;

    procedure ChangeScale(M, D: Integer); virtual;

    function FocusFirst(ACheckTabStop: Boolean): Boolean; virtual;
    function CanFocus(AByMouse: Boolean): Boolean; virtual; 
    function IsFocused: Boolean; virtual;
    function NeedMakeVisibleAfterFocusing: Boolean; virtual;

    procedure DoItemChanged;

    procedure BeginUpdate;
    procedure CancelUpdate;
    procedure EndUpdate(ANeedPack: Boolean = True);
    //
    procedure Changed(AType: TdxLayoutItemChangeType = ictHard);
    procedure DoChanged(AType: TdxLayoutItemChangeType); virtual;
    //
    procedure AlignChanged; virtual;
    procedure BiDiModeChanged; virtual;
    procedure ContainerChanged; virtual;
    procedure CustomizationChanged; virtual;
    procedure EnabledChanged; virtual;
    procedure ParentChanged(AType: TdxLayoutItemChangeType);

    procedure CreateOptions; virtual;
    procedure DestroyOptions; virtual;

    function GetNearestClosedSplitter: TdxLayoutSplitterItem;

    property AbsoluteIndex: Integer read GetAbsoluteIndex;
    property Align: TdxLayoutAlign read FAlign write SetAlign;
    property AllowQuickCustomize: Boolean read FAllowQuickCustomize write FAllowQuickCustomize default False;
    property AllowFloating: Boolean read FAllowFloating write FAllowFloating default False;
    property Customization: Boolean read FCustomization write SetCustomization;
    property InternalEnabled: Boolean read FEnabled write FEnabled;
    property IsVertical: Boolean read GetIsVertical;
    property LoadedIndex: Integer read FLoadedIndex write FLoadedIndex;
    property Padding: TdxLayoutPadding read FPadding write SetPadding;
    property RealAlign: TdxLayoutRealAlign read GetRealAlign write SetRealAlign;
    property RealContainer: TdxLayoutContainer read GetRealContainer;
    property ScaleFactor: TdxScaleFactor read GetScaleFactor;
    property Superfluous: Boolean read FSuperfluous write FSuperfluous;
    property TakeoffParent: TdxCustomLayoutGroup read FTakeoffParent write SetTakeoffParent;

    property OnCaptionClick: TNotifyEvent read FOnCaptionClick write FOnCaptionClick;
    property OnStartFloat: TNotifyEvent read FOnStartFloat write FOnStartFloat;
    property OnEndFloat: TNotifyEvent read FOnEndFloat write FOnEndFloat;
  public
    constructor Create(AOwner: TComponent); override;
    procedure BeforeDestruction; override;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
    function GetParentComponent: TComponent; override;
    function HasParent: Boolean; override;

    function CanMoveTo(AParent: TdxCustomLayoutItem): Boolean; virtual;
    procedure MakeVisible; 
    function Move(AParent: TdxCustomLayoutGroup; AIndex: Integer; APack: Boolean = False): Boolean;
    function MoveTo(AParent: TdxCustomLayoutGroup; AVisibleIndex: Integer; APack: Boolean = False): Boolean;
    procedure Pack;
    function PutIntoHiddenGroup(ALayoutDirection: TdxLayoutDirection): TdxLayoutAutoCreatedGroup;

    procedure ToggleHotTrackState; // for internal use

    property ActuallyVisible: Boolean read GetActuallyVisible;
    property AllowRemove: Boolean read FAllowRemove write FAllowRemove default True;
    property CaptionForCustomizeForm: string read GetCaptionForCustomizeForm;
    property Container: TdxLayoutContainer read FContainer write SetContainer;
    property Data: Pointer read FData write FData;
    property DefaultCaption: string read GetDefaultCaption write SetDefaultCaption; // for localization
    property Enabled: Boolean read GetEnabled write SetEnabled stored IsEnabledStored;
    property Height: Integer read GetHeight write SetHeight;
    property Index: Integer read GetIndex write SetIndex;
    property IsRoot: Boolean read GetIsRoot;
    property IsUserDefined: Boolean read FIsUserDefined write SetIsUserDefined;
    property IsUserRenamed: Boolean read GetIsUserRenamed;
    property ViewInfo: TdxCustomLayoutItemViewInfo read GetViewInfo; // for internal use
    property VisibleIndex: Integer read GetVisibleIndex write SetVisibleIndex;
    property Width: Integer read GetWidth write SetWidth;

//  published
    property AlignHorz: TdxLayoutAlignHorz read GetAlignHorz write SetAlignHorz stored IsAlignHorzStored;
    property AlignVert: TdxLayoutAlignVert read GetAlignVert write SetAlignVert stored IsAlignVertStored;
    property AlignmentConstraint: TdxLayoutAlignmentConstraint read FAlignmentConstraint write SetAlignmentConstraint;
    property CaptionOptions: TdxCustomLayoutItemCaptionOptions read FCaptionOptions write SetCaptionOptions;
    property LayoutLookAndFeel: TdxCustomLayoutLookAndFeel read FLayoutLookAndFeel write SetLayoutLookAndFeel;
    property Offsets: TdxLayoutOffsets read FOffsets write SetOffsets;
    property SizeOptions: TdxLayoutSizeOptions read FSizeOptions write SetSizeOptions;
    property Visible: Boolean read FVisible write SetVisible default True;
  published
    property AutoAligns: TdxLayoutAutoAligns read GetAutoAligns write SetAutoAligns stored False; // obsolete
    property Caption: string read GetCaption write SetCaption stored False;
    property LookAndFeel: TdxCustomLayoutLookAndFeel read FLayoutLookAndFeel write SetLayoutLookAndFeel stored False; // obsolete
    property ShowCaption: Boolean read GetShowCaption write SetShowCaption stored False;
    property Parent: TdxCustomLayoutGroup read FParent write SetParent;
  end;

  TdxLayoutBasicItem = class(TdxCustomLayoutItem)
  protected
    function GetViewInfoClass: TdxCustomLayoutItemViewInfoClass; override;
  published
    property AlignHorz;
    property AlignVert;
    property AlignmentConstraint;
    property LayoutLookAndFeel;
    property Offsets;
    property Visible;
    property SizeOptions;
  end;

  // Auxiliary Items

  TdxLayoutNonLabeledItemCaptionOptions = class(TdxCustomLayoutItemCaptionOptions)
  published
    property Text;
  end;

  TdxLayoutNonLabeledItem = class(TdxLayoutBasicItem)
  private
    function GetCaptionOptions: TdxLayoutNonLabeledItemCaptionOptions; inline;
    procedure SetCaptionOptions(Value: TdxLayoutNonLabeledItemCaptionOptions); inline;
  protected
    class function GetCaptionOptionsClass: TdxCustomLayoutItemCaptionOptionsClass; override;
  published
    property Enabled;
    property CaptionOptions: TdxLayoutNonLabeledItemCaptionOptions read GetCaptionOptions write SetCaptionOptions;
  end;

  TdxLayoutEmptySpaceItem = class(TdxLayoutNonLabeledItem)
  protected
    function GetBaseName: string; override;
    class function GetItemClassKind: Integer; override;
    function GetViewInfoClass: TdxCustomLayoutItemViewInfoClass; override;

    function CanBeAlone: Boolean; override;
  end;

  TdxLayoutDirectionalItem = class(TdxLayoutNonLabeledItem)
  protected
    function GetViewInfoClass: TdxCustomLayoutItemViewInfoClass; override;

    function CanBeAlone: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;

    property IsVertical;
  end;

  TdxLayoutSplitterItem = class(TdxLayoutDirectionalItem)
  private
    FAllowCloseOnClick: Boolean;
    FDirectAccess: Boolean;
    FIsClosed: Boolean;
    FOnCanResize: TdxLayoutItemCanResizeEvent;

    procedure SetAllowCloseOnClick(AValue: Boolean);
    procedure SetIsClosed(AValue: Boolean);
  protected
    // storing
    function GetStoredProperties(AProperties: TStrings): Boolean; override;
    procedure GetStoredPropertyValue(const AName: string; var AValue: Variant); override;
    procedure SetStoredPropertyValue(const AName: string; const AValue: Variant); override;

    function CanQuickDragAndDrop: Boolean; override;

    class function GetItemClassKind: Integer; override;
    function GetBaseName: string; override;
    function GetViewInfoClass: TdxCustomLayoutItemViewInfoClass; override;

    function DoCanResize(AItem: TdxCustomLayoutItem; var ANewSize: Integer): Boolean;

    procedure Close;
    procedure Open;

    property DirectAccess: Boolean read FDirectAccess write FDirectAccess;
    property IsClosed: Boolean read FIsClosed write SetIsClosed;
  published
    property AllowCloseOnClick: Boolean read FAllowCloseOnClick write SetAllowCloseOnClick default False;

    property OnCanResize: TdxLayoutItemCanResizeEvent read FOnCanResize write FOnCanResize;
  end;

  TdxCustomLayoutItemStorableCaptionOptions = class(TdxCustomLayoutItemCaptionOptions)
  protected
    procedure GetStoredPropertyValue(const AName: string; var AValue: Variant); override;
    procedure GetStoredProperties(AProperties: TStrings); override;
    procedure SetStoredPropertyValue(const AName: string; const AValue: Variant); override;
  end;

  TdxLayoutLabeledItemCustomCaptionOptions = class(TdxCustomLayoutItemStorableCaptionOptions)
  private
    FCursor: TCursor;
    FWidth: Integer;
    FWordWrap: Boolean;
    procedure SetWidth(Value: Integer);
    procedure SetWordWrap(Value: Boolean);
  protected
    procedure DoAssign(Source: TPersistent); override;
    procedure DoChangeScale(M, D: Integer); override;
    //
    property Cursor: TCursor read FCursor write FCursor default crDefault;
    property WordWrap: Boolean read FWordWrap write SetWordWrap default False;
  public
    constructor Create(AItem: TdxCustomLayoutItem); override;

    property AlignHorz;
    property AlignVert default tavCenter;
    property Glyph;
    property ImageIndex;
    property VisibleElements;
    property Width: Integer read FWidth write SetWidth default 0;
  end;

  TdxCustomLayoutLabeledItem = class(TdxLayoutBasicItem)
  private
    function GetCaptionOptions: TdxLayoutLabeledItemCustomCaptionOptions; inline;
    procedure SetCaptionOptions(Value: TdxLayoutLabeledItemCustomCaptionOptions); inline;
  protected
    function GetParentManagedAlignVert: TdxLayoutAlignVert; override;
    class function GetCaptionOptionsClass: TdxCustomLayoutItemCaptionOptionsClass; override;
    function GetViewInfoClass: TdxCustomLayoutItemViewInfoClass; override;
  public
    property CaptionOptions: TdxLayoutLabeledItemCustomCaptionOptions read GetCaptionOptions write SetCaptionOptions;
  published
    property Padding;
  end;

  { TdxLayoutSeparatorItemCaptionOptions }

  TdxLayoutSeparatorItemCaptionOptions = class(TdxLayoutLabeledItemCustomCaptionOptions)
  public
    constructor Create(AItem: TdxCustomLayoutItem); override;
  published
    property AlignHorz;
    property AlignVert default tavBottom;
    property Cursor;
    property Glyph;
    property ImageIndex;
    property Text;
    property Visible default False;
    property VisibleElements;
    property Width;
  end;

  { TdxLayoutSeparatorItem }

  TdxLayoutSeparatorItem = class(TdxCustomLayoutLabeledItem)
  private
    function GetCaptionOptions: TdxLayoutSeparatorItemCaptionOptions; inline;
    procedure SetCaptionOptions(Value: TdxLayoutSeparatorItemCaptionOptions); inline;
  protected
    function GetBaseName: string; override;
    class function GetCaptionOptionsClass: TdxCustomLayoutItemCaptionOptionsClass; override;
    class function GetItemClassKind: Integer; override;
    function GetIsVertical: Boolean; override;
    function GetParentManagedAlignVert: TdxLayoutAlignVert; override;
    function GetViewInfoClass: TdxCustomLayoutItemViewInfoClass; override;
  public
    property IsVertical;
  published
    property AllowRemove;
    property CaptionOptions: TdxLayoutSeparatorItemCaptionOptions read GetCaptionOptions write SetCaptionOptions;
  end;

  TdxLayoutLabeledItemCaptionOptions = class(TdxLayoutLabeledItemCustomCaptionOptions)
  published
    property AlignHorz;
    property AlignVert;
    property Cursor;
    property EllipsisPosition;
    property Glyph;
    property Hint;
    property ImageIndex;
    property ShowAccelChar;
    property Text;
    property Visible;
    property VisibleElements;
    property Width;
    property WordWrap;
  end;

  TdxLayoutLabeledItem = class(TdxCustomLayoutLabeledItem)
  private
    function GetCaptionOptions: TdxLayoutLabeledItemCaptionOptions; inline;
    procedure SetCaptionOptions(Value: TdxLayoutLabeledItemCaptionOptions); inline;
  protected
    function GetBaseName: string; override;
    class function GetCaptionOptionsClass: TdxCustomLayoutItemCaptionOptionsClass; override;
    class function GetItemClassKind: Integer; override;
  published
    property AllowRemove;
    property CaptionOptions: TdxLayoutLabeledItemCaptionOptions read GetCaptionOptions write SetCaptionOptions;
    property Enabled;
    property OnCaptionClick;
  end;

  { TdxLayoutImageItem }

  TdxLayoutItemCaptionOptions = class(TdxLayoutLabeledItemCaptionOptions)
  published
    property Layout default clLeft;
  end;

  TdxLayoutImageItem = class(TdxCustomLayoutLabeledItem)
  private
    FImage: TdxSmartGlyph;
    FImageFitMode: TcxImageFitMode;

    function GetCaptionOptions: TdxLayoutItemCaptionOptions; inline;
    procedure SetCaptionOptions(Value: TdxLayoutItemCaptionOptions); inline;

    procedure SetImage(AValue: TdxSmartGlyph);
    procedure SetImageFitMode(AValue: TcxImageFitMode);
    procedure ImageChanged(Sender: TObject);
  protected
    function GetBaseName: string; override;
    class function GetCaptionOptionsClass: TdxCustomLayoutItemCaptionOptionsClass; override;
    class function GetItemClassKind: Integer; override;
    function GetViewInfoClass: TdxCustomLayoutItemViewInfoClass; override;

    property ImageFitMode: TcxImageFitMode read FImageFitMode write SetImageFitMode default ifmFit;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property AllowRemove;
    property CaptionOptions: TdxLayoutItemCaptionOptions read GetCaptionOptions write SetCaptionOptions;
    property Enabled;
    property Image: TdxSmartGlyph read FImage write SetImage;
  end;

  { TdxCustomLayoutCheckableItemCaptionOptions }

  TdxCustomLayoutCheckableItemCaptionOptions = class(TdxLayoutLabeledItemCaptionOptions)
  strict private
    function GetItem: TdxCustomLayoutCheckableItem;
  protected
    function IsHintStored: Boolean;
    function IsTextStored: Boolean; override;

    property Item: TdxCustomLayoutCheckableItem read GetItem;
  public
    constructor Create(AItem: TdxCustomLayoutItem); override;
  published
    property Hint stored IsHintStored;
    property Layout default clRight;
  end;

  TdxLayoutCheckBoxItemCaptionOptions = class(TdxCustomLayoutCheckableItemCaptionOptions);

  TdxLayoutRadioButtonItemCaptionOptions = class(TdxCustomLayoutCheckableItemCaptionOptions);

  { TdxLayoutCheckBoxItemCheckBoxOptions }

  TdxLayoutCheckBoxItemCheckBoxOptions = class(TdxCustomLayoutItemOptions, IdxMultiPartGlyphSupport)
  strict private
    FAllowGrayed: Boolean;
    FGlyph: TdxSmartGlyph;
    FGlyphCount: Integer;
    FOnChange: TNotifyEvent;
    FReadOnly: Boolean;

    function GetItem: TdxLayoutCheckBoxItem;
    procedure SetGlyph(AValue: TdxSmartGlyph);
    procedure SetGlyphCount(AValue: Integer);
    procedure SetReadOnly(AValue: Boolean);
  protected
    procedure DoAssign(Source: TPersistent); override;
    procedure GlyphChangeHandler(Sender: TObject);
    // IdxMultiPartGlyphSupport
    function GetStateCaption(AIndex: Integer): string;
    function GetGlyphCount: Integer;

    property Item: TdxLayoutCheckBoxItem read GetItem;
  public
    constructor Create(AItem: TdxCustomLayoutItem); override;
    destructor Destroy; override;
  published
    property AllowGrayed: Boolean read FAllowGrayed write FAllowGrayed default False;
    property Glyph: TdxSmartGlyph read FGlyph write SetGlyph;
    property GlyphCount: Integer read FGlyphCount write SetGlyphCount default 6;
    property ReadOnly: Boolean read FReadOnly write SetReadOnly default False;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TdxLayoutCheckBoxItemCheckBoxOptionsClass = class of TdxLayoutCheckBoxItemCheckBoxOptions;

  { TdxCustomLayoutCheckableItemActionLink }

  TdxCustomLayoutCheckableItemActionLink = class(TActionLink)
  protected
    FClient: TdxCustomLayoutCheckableItem;

    procedure AssignClient(AClient: TObject); override;
    function IsCaptionLinked: Boolean; override;
    function IsCheckedLinked: Boolean; override;
    function IsEnabledLinked: Boolean; override;
    function IsHintLinked: Boolean; override;
    function IsOnExecuteLinked: Boolean; override;
    function IsVisibleLinked: Boolean; override;
    procedure SetCaption(const Value: string); override;
    procedure SetChecked(Value: Boolean); override;
    procedure SetEnabled(Value: Boolean); override;
    procedure SetHint(const Value: string); override;
    procedure SetOnExecute(Value: TNotifyEvent); override;
    procedure SetVisible(Value: Boolean); override;
  end;

  TdxCustomLayoutCheckableItemActionLinkClass = class of TdxCustomLayoutCheckableItemActionLink;

  { TdxLayoutCheckBoxItemActionLink }

  TdxLayoutCheckBoxItemActionLink = class(TdxCustomLayoutCheckableItemActionLink);

  { TdxLayoutRadioButtonItemActionLink }

  TdxLayoutRadioButtonItemActionLink = class(TdxCustomLayoutCheckableItemActionLink)
  strict private
    function GetClient: TdxLayoutRadioButtonItem; inline;
  protected
    function IsGroupIndexLinked: Boolean; override;
    procedure SetGroupIndex(Value: Integer); override;

    property Client: TdxLayoutRadioButtonItem read GetClient;
  end;

  { TdxCustomLayoutCheckableItem }

  TdxCustomLayoutCheckableItem = class(TdxCustomLayoutLabeledItem)
  strict private
    FActionLink: TdxCustomLayoutCheckableItemActionLink;
    FIsClickLocked: Boolean;
    FTabStop: Boolean;
    FShowFocusRect: Boolean;

    FOnClick: TNotifyEvent;

    procedure DoActionChange(Sender: TObject);
    function GetAction: TBasicAction;
    procedure SetAction(AValue: TBasicAction);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function CanFocus(AByMouse: Boolean): Boolean; override;
    function CanProcessAccel: Boolean; override;
    procedure DoGetTabOrderList(List: TList); override;
    procedure InitiateAction; override;
    function IsEnabledStored: Boolean; override;
    function NeedMakeVisibleAfterFocusing: Boolean; override;

    procedure ActionChange(Sender: TObject; const ACheckDefaults: Boolean); virtual;
    procedure Click;
    class function GetActionLinkClass: TdxCustomLayoutCheckableItemActionLinkClass; virtual;
    function GetChecked: Boolean; virtual; abstract;
    function GetTabStop: Boolean; virtual;
    function IsOnClickStored: Boolean;
    function IsVisibleStored: Boolean;
    procedure ProcessAccel; override;
    procedure SetChecked(const AValue: Boolean); virtual; abstract;
    procedure SetTabStop(const AValue: Boolean); virtual;
    procedure Toggle; virtual;

    property ActionLink: TdxCustomLayoutCheckableItemActionLink read FActionLink write FActionLink;
    property TabStop: Boolean read GetTabStop write SetTabStop;
    property ShowFocusRect: Boolean read FShowFocusRect write FShowFocusRect;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    property Action: TBasicAction read GetAction write SetAction;
    property Checked: Boolean read GetChecked write SetChecked;

    property OnClick: TNotifyEvent read FOnClick write FOnClick stored IsOnClickStored;
  published
    property Visible stored IsVisibleStored;
  end;

  { TdxLayoutCheckBoxItem }

  TdxLayoutCheckBoxItem = class(TdxCustomLayoutCheckableItem)
  strict private
    FCheckBoxOptions: TdxLayoutCheckBoxItemCheckBoxOptions;
    FState: TcxCheckBoxState;

    function GetCaptionOptions: TdxLayoutCheckBoxItemCaptionOptions; inline;
    procedure SetCaptionOptions(AValue: TdxLayoutCheckBoxItemCaptionOptions); inline;
    procedure SetCheckBoxOptions(AValue: TdxLayoutCheckBoxItemCheckBoxOptions); inline;
    procedure SetState(const AValue: TcxCheckBoxState);
  protected
    procedure CreateOptions; override;
    procedure DestroyOptions; override;
    procedure DoChanged(AType: TdxLayoutItemChangeType); override;
    class function GetActionLinkClass: TdxCustomLayoutCheckableItemActionLinkClass; override;
    function GetBaseName: string; override;
    class function GetCaptionOptionsClass: TdxCustomLayoutItemCaptionOptionsClass; override;
    class function GetCheckBoxOptionsClass: TdxLayoutCheckBoxItemCheckBoxOptionsClass; virtual;
    function GetChecked: Boolean; override;
    class function GetItemClassKind: Integer; override;
    function GetViewInfoClass: TdxCustomLayoutItemViewInfoClass; override;
    function IsStateStored: Boolean;
    procedure SetChecked(const AValue: Boolean); override;
    procedure Toggle; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
  published
    property Action;
    property AllowRemove;
    property CaptionOptions: TdxLayoutCheckBoxItemCaptionOptions read GetCaptionOptions write SetCaptionOptions;
    property CheckBoxOptions: TdxLayoutCheckBoxItemCheckBoxOptions read FCheckBoxOptions write SetCheckBoxOptions;
    property Checked stored False;
    property Enabled;
    property State: TcxCheckBoxState read FState write SetState stored IsStateStored default cbsUnchecked;
    property TabStop default True;

    property OnClick;
  end;

  { TdxLayoutRadioButtonItem }

  TdxLayoutRadioButtonItem = class(TdxCustomLayoutCheckableItem)
  strict private
    FChecked: Boolean;
    FGroupIndex: Integer;

    function GetCaptionOptions: TdxLayoutRadioButtonItemCaptionOptions; inline;
    procedure SetCaptionOptions(AValue: TdxLayoutRadioButtonItemCaptionOptions); inline;
    procedure TurnLayoutSiblingsOff(AGroup: TdxCustomLayoutGroup);
  protected
    procedure ActionChange(Sender: TObject; const ACheckDefaults: Boolean); override;
    class function GetActionLinkClass: TdxCustomLayoutCheckableItemActionLinkClass; override;
    function GetBaseName: string; override;
    class function GetCaptionOptionsClass: TdxCustomLayoutItemCaptionOptionsClass; override;
    function GetChecked: Boolean; override;
    class function GetItemClassKind: Integer; override;
    function GetTabStop: Boolean; override;
    function GetViewInfoClass: TdxCustomLayoutItemViewInfoClass; override;
    function IsCheckedStored: Boolean;
    function IsGroupIndexStored: Boolean;
    procedure SetChecked(const AValue: Boolean); override;
    procedure Toggle; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
  published
    property Action;
    property AllowRemove;
    property CaptionOptions: TdxLayoutRadioButtonItemCaptionOptions read GetCaptionOptions write SetCaptionOptions;
    property Checked stored IsCheckedStored default False;
    property Enabled;
    property GroupIndex: Integer read FGroupIndex write FGroupIndex stored IsGroupIndexStored default 0;
    property TabStop default False;

    property OnClick;
  end;

  // item
  TdxCustomLayoutControlAdapter = class(TPersistent)
  private
    FItem: TdxLayoutItem;
    FNeedSetRegion: Boolean;
    FIsRegionUsed: Boolean;
    function GetControl: TControl;
    function GetLayoutLookAndFeel: TdxCustomLayoutLookAndFeel;
  protected
    procedure HideControlBorder; virtual;
    procedure Init; virtual;

    procedure AfterCalculateViewInfo; virtual;
    procedure CombineRegion(const ARect: TRect); virtual;
    procedure InternalSetInitialSettings; virtual;
    function NeedBorder: Boolean; virtual;
    function HasBorderProperty: Boolean;
    function ShowItemCaption: Boolean; virtual;
    function UseItemColor: Boolean; virtual;
    // AutoSize
    function AllowCheckAutoSize: Boolean; virtual;
    function AllowCheckSize: Boolean; virtual;
    function GetControlAutoWidth: Boolean; virtual;
    function GetControlAutoHeight: Boolean; virtual;
    procedure SetControlAutoWidth(AValue: Boolean); virtual;
    procedure SetControlAutoHeight(AValue: Boolean); virtual;
    // Customization
    procedure BeginCustomization; virtual;
    procedure EndCustomization; virtual;

    property Control: TControl read GetControl;
    property ControlAutoWidth: Boolean read GetControlAutoWidth write SetControlAutoWidth;
    property ControlAutoHeight: Boolean read GetControlAutoHeight write SetControlAutoHeight;
    property Item: TdxLayoutItem read FItem;
    property LayoutLookAndFeel: TdxCustomLayoutLookAndFeel read GetLayoutLookAndFeel;
  public
    constructor Create(AItem: TdxLayoutItem); virtual;
    destructor Destroy; override;

    procedure Initialize;

    procedure AfterInitialization; virtual;
    procedure BeforeInitialization; virtual;
    procedure SetInitialSettings; virtual;
    class procedure Register(AControlClass: TControlClass);
    class procedure Unregister(AControlClass: TControlClass);
  end;
  TdxCustomLayoutControlAdapterClass = class of TdxCustomLayoutControlAdapter;

  { TdxLayoutItemControlOptions }

  TdxLayoutItemControlOptionsClass = class of TdxLayoutItemControlOptions;
  TdxLayoutItemControlOptions = class(TdxCustomLayoutItemOptions)
  private
    FAlignHorz: TdxLayoutItemControlAlignHorz;
    FAlignVert: TdxLayoutItemControlAlignVert;
    FAutoControlAreaAlignment: Boolean;
    FAutoColor: Boolean;
    FMinHeight: Integer;
    FMinWidth: Integer;
    FOpaque: Boolean;
    FOriginalHeight: Integer;
    FOriginalWidth: Integer;
    FScalingFlags: TScalingFlags;
    FShowBorder: Boolean;

    function GetFixedSize: Boolean;
    procedure SetAlignHorz(Value: TdxLayoutItemControlAlignHorz);
    procedure SetAlignVert(Value: TdxLayoutItemControlAlignVert);
    procedure SetAutoControlAreaAlignment(Value: Boolean);
    procedure SetAutoColor(Value: Boolean);
    procedure SetFixedSize(Value: Boolean);
    procedure SetMinHeight(Value: Integer);
    procedure SetMinWidth(Value: Integer);
    procedure SetOpaque(Value: Boolean);
    procedure SetShowBorder(Value: Boolean);
    procedure SetOriginalHeight(Value: Integer);
    procedure SetOriginalWidth(Value: Integer);
  protected
    procedure DoAssign(Source: TPersistent); override;
    procedure DoChangeScale(M: Integer; D: Integer); override;
  public
    constructor Create(AItem: TdxCustomLayoutItem); override;

    function IsHeightUsual: Boolean;
    function IsWidthUsual: Boolean;
  published
    property AlignHorz: TdxLayoutItemControlAlignHorz read FAlignHorz write SetAlignHorz default ahClient;
    property AlignVert: TdxLayoutItemControlAlignVert read FAlignVert write SetAlignVert default avClient;
    property AutoAlignment: Boolean read FAutoControlAreaAlignment write SetAutoControlAreaAlignment stored False; // obsolete
    property AutoControlAreaAlignment: Boolean read FAutoControlAreaAlignment write SetAutoControlAreaAlignment default True;
    property AutoColor: Boolean read FAutoColor write SetAutoColor default False;
    property FixedSize: Boolean read GetFixedSize write SetFixedSize stored False; // deprecated 'Use AlignHorz and AlignVert';
    property MinHeight: Integer read FMinHeight write SetMinHeight default dxLayoutItemControlDefaultMinHeight;
    property MinWidth: Integer read FMinWidth write SetMinWidth default dxLayoutItemControlDefaultMinWidth;
    property Opaque: Boolean read FOpaque write SetOpaque default False;
    property OriginalHeight: Integer read FOriginalHeight write SetOriginalHeight default 0;
    property OriginalWidth: Integer read FOriginalWidth write SetOriginalWidth default 0;
    property ShowBorder: Boolean read FShowBorder write SetShowBorder default True;
  end;

  { TdxLayoutControlItem }

  TdxLayoutControlItem = class(TdxCustomLayoutLabeledItem)
  private
    FControl: TControl; 
    FControlAdapter: TdxCustomLayoutControlAdapter;
    FControlOptions: TdxLayoutItemControlOptions;

    function GetViewInfo: TdxLayoutControlItemViewInfo;
    procedure SetControlOptions(Value: TdxLayoutItemControlOptions);
    function GetOriginalControlSize: TPoint;
    procedure SetOriginalControlSize(const Value: TPoint);
  protected
    procedure ChangeScale(M: Integer; D: Integer); override;
    procedure DoInit; override;

    class function GetCaptionOptionsClass: TdxCustomLayoutItemCaptionOptionsClass; override;
    function GetViewInfoClass: TdxCustomLayoutItemViewInfoClass; override;

    procedure CreateOptions; override;
    procedure DestroyOptions; override;

    function CanFocusControl(ACheckTabStop: Boolean = False): Boolean; virtual;
    function GetControlOptionsClass: TdxLayoutItemControlOptionsClass; virtual;

    procedure SetControl(AValue: TControl); virtual;

    property Control: TControl read FControl write SetControl;
    property ControlOptions: TdxLayoutItemControlOptions read FControlOptions write SetControlOptions;
    property ControlAdapter: TdxCustomLayoutControlAdapter read FControlAdapter;
  public
    procedure Assign(Source: TPersistent); override;

    property OriginalControlSize: TPoint read GetOriginalControlSize write SetOriginalControlSize;
    property ViewInfo: TdxLayoutControlItemViewInfo read GetViewInfo; // for internal use
  end;

  { TdxLayoutItem }

  TdxLayoutItem = class(TdxLayoutControlItem)
  private
    FControlLockCount: Integer;

    FIsInternalHandleCreating: Boolean;
    FIsReseting: Boolean;
    FNewControlSize: TPoint;

    FSelectorHelper: TdxControlsDesignSelectorHelper;
    FWindowProcObject: TcxWindowProcLinkedObject;

    function GetCaptionOptions: TdxLayoutItemCaptionOptions; inline;
    function GetDesignSelectorRect: TRect;
    function GetViewInfo: TdxLayoutItemViewInfo;
    function GetWinControl: TWinControl;
    procedure SetCaptionOptions(Value: TdxLayoutItemCaptionOptions); inline;

    function CanFocusControlOnCaptionClick: Boolean;
    procedure CreateControlAdapter;
  protected
    class function GetItemClassKind: Integer; override;

    // CustomItem
    function CanDelete: Boolean; override;
    function CanProcessAccel: Boolean; override;
    procedure ContainerChanged; override;
    procedure CustomizationChanged; override;
    procedure DoCaptionDown; override;
    procedure DoGetTabOrderList(List: TList); override;
    function FocusFirst(ACheckTabStop: Boolean): Boolean; override;
    function GetBaseName: string; override;
    procedure MakeControlVisible(AFully: Boolean);
    procedure ProcessAccel; override;
    procedure RestoreItemControlBounds; override;
    procedure SetControl(Value: TControl); override;

    procedure AfterCalculateViewInfo; override;
    procedure BeforeCalculateViewInfo; override;
    procedure ApplyCalculatedChanges; override;
    procedure SetInitialSettings; override;

    class function GetCaptionOptionsClass: TdxCustomLayoutItemCaptionOptionsClass; override;
    function GetViewInfoClass: TdxCustomLayoutItemViewInfoClass; override;

    function CanDragAndDrop(const P: TPoint): Boolean; override;
    function CanFocusControl(ACheckTabStop: Boolean = False): Boolean; override;
    function ControlLocked: Boolean;
    procedure CheckAutoSize(ADropOnly: Boolean); override;
    procedure ControlWndProc(var Message: TMessage); virtual;
    function IsDesignSelectorVisible: Boolean;
    function HasControl: Boolean; override;
    function HasWinControl: Boolean;
    procedure SaveOriginalControlSize(ASaveAnyway, ANeedChanges: Boolean);
    procedure SetControlEnablement;
    procedure SetControlFocus;
    procedure SetControlVisibility;
    procedure UpdateDesignSelector;

    procedure DropControl;
    procedure PrepareControl;
    procedure UnprepareControl(AFull: Boolean);

    property DesignSelectorRect: TRect read GetDesignSelectorRect;
    property WinControl: TWinControl read GetWinControl;
  public
    destructor Destroy; override;

    property ViewInfo: TdxLayoutItemViewInfo read GetViewInfo; // for internal use
  published
    property AllowRemove;
    property CaptionOptions: TdxLayoutItemCaptionOptions read GetCaptionOptions write SetCaptionOptions;
    property Control; 
    property ControlOptions;
    property Enabled;
    property OnCaptionClick;
  end;

  TdxLayoutItemClass = class of TdxLayoutItem;

  // group

  TdxLayoutGroupHelper = class
  public
    class function GetChildItemsAlignHorz: TdxLayoutRealAlignHorz; virtual;
    class function GetChildItemsAlignVert: TdxLayoutRealAlignVert; virtual;
    class function GetOrthogonalDirection: TdxLayoutDirection; virtual;
    class function GetSpecificClass: TdxLayoutGroupViewInfoSpecificClass; virtual;
  end;

  TdxLayoutHorizontalGroupHelper = class(TdxLayoutGroupHelper)
  public
    class function GetChildItemsAlignHorz: TdxLayoutRealAlignHorz; override;
    class function GetChildItemsAlignVert: TdxLayoutRealAlignVert; override;
    class function GetOrthogonalDirection: TdxLayoutDirection; override;
    class function GetSpecificClass: TdxLayoutGroupViewInfoSpecificClass; override;
  end;

  TdxLayoutVerticalGroupHelper = class(TdxLayoutGroupHelper)
  public
    class function GetChildItemsAlignHorz: TdxLayoutRealAlignHorz; override;
    class function GetChildItemsAlignVert: TdxLayoutRealAlignVert; override;
    class function GetOrthogonalDirection: TdxLayoutDirection; override;
    class function GetSpecificClass: TdxLayoutGroupViewInfoSpecificClass; override;
  end;

  TdxLayoutTabbedGroupHelper = class(TdxLayoutHorizontalGroupHelper)
  public
    class function GetChildItemsAlignHorz: TdxLayoutRealAlignHorz; override;
    class function GetChildItemsAlignVert: TdxLayoutRealAlignVert; override;
    class function GetOrthogonalDirection: TdxLayoutDirection; override;
    class function GetSpecificClass: TdxLayoutGroupViewInfoSpecificClass; override;
  end;

  { TdxLayoutTabbedOptions }

  TdxLayoutTabbedOptions = class(TcxCustomTabControlProperties)
  strict private
    FInternalImages: TcxImageList;

    function GetGroup: TdxCustomLayoutGroup;
    function GetInternalImages: TcxImageList;
    function GetItemCaption(AItem: TdxCustomLayoutItem): string;
  protected
    procedure DoChanged(AType: TcxCustomTabControlPropertiesChangedType = pctHard); override;
    procedure DoChanging(ANewTabIndex: Integer; var AAllowChange: Boolean); override;
    procedure CheckTabs;
    procedure DeleteTab(AItem: TdxCustomLayoutItem);
    procedure DoSetTabIndex(Value: Integer); override;
    function GetItem(AIndex: Integer): TdxCustomLayoutItem;
    function GetTabControl: IcxTabControl; override;
    function GetTabIndex: Integer; override;
    procedure InsertTab(AItem: TdxCustomLayoutItem);
    procedure RefreshImages;
    procedure RefreshTabsCaption;
    procedure RefreshTabsEnabled;
    procedure RefreshTabsVisible;

    property Group: TdxCustomLayoutGroup read GetGroup;
    property InternalImages: TcxImageList read GetInternalImages;
  public
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;
  published
    property CloseButtonMode;
    property CloseTabWithMiddleClick;
    property HideTabs;
    property HotTrack;
    property ImageBorder;
    property MultiLine;
    property MultiLineTabCaptions;
    property NavigatorPosition;
    property Options;
    property RaggedRight;
    property Rotate;
    property RotatedTabsMaxWidth;
    property ScrollOpposite;
    property ShowFrame;
    property TabCaptionAlignment;
    property TabHeight;
    property TabPosition;
    property TabWidth;
  end;

  { TdxCustomLayoutGroupButton }

  TdxCustomLayoutGroupButtons = class;
  TdxLayoutGroupButtonOptions = class;

  TdxGetTextEvent = procedure(Sender: TObject; var AText: string) of object; 

  TdxCustomLayoutGroupButton = class(TCollectionItem)
  private
    FEnabled: Boolean;
    FGlyph: TdxSmartGlyph;
    FHeight: Cardinal;
    FHint: string;
    FTag: TcxTag;
    FVisible: Boolean;
    FWidth: Cardinal;
    FOnClick: TNotifyEvent;
    FOnGetHint: TdxGetTextEvent;

    function GetHint: string;
    function GetButtons: TdxCustomLayoutGroupButtons;
    procedure GlyphChangedHandler(Sender: TObject);
    procedure SetEnabled(AValue: Boolean);
    procedure SetGlyph(AValue: TdxSmartGlyph);
    procedure SetHeight(AValue: Cardinal);
    procedure SetVisible(AValue: Boolean);
    procedure SetWidth(AValue: Cardinal);

    property OnGetHint: TdxGetTextEvent read FOnGetHint write FOnGetHint;
  protected
    procedure ChangeScale(M, D: Integer); virtual;
    function GetHeight: Integer;
    function GetViewInfoClass: TdxLayoutGroupButtonViewInfoClass; virtual;
    function GetWidth: Integer;
    procedure DoClick; virtual;
    function IsExpandButton: Boolean;
    function IsHomeButton: Boolean;

    property Buttons: TdxCustomLayoutGroupButtons read GetButtons;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function GetNamePath: string; override;

    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property Glyph: TdxSmartGlyph read FGlyph write SetGlyph;
    property Height: Cardinal read FHeight write SetHeight default 0;
    property Hint: string read GetHint write FHint;
    property Tag: TcxTag read FTag write FTag default 0;
    property Visible: Boolean read FVisible write SetVisible default True;
    property Width: Cardinal read FWidth write SetWidth default 0;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
  end;

  TdxCustomLayoutGroupButtonClass = class of TdxCustomLayoutGroupButton;

  { TdxLayoutGroupButton }

  TdxLayoutGroupButton = class(TdxCustomLayoutGroupButton)
  published
    property Enabled;
    property Glyph;
    property Height;
    property Hint;
    property Tag;
    property Visible;
    property Width;
    property OnClick;
  end;

  { TdxLayoutGroupCheckBoxButton }

  TdxLayoutGroupCheckBoxButton = class(TdxCustomLayoutGroupButton)
  private
    FCheckAction: TdxCheckGroupBoxCheckBoxAction;
    FState: TcxCheckBoxState;

    procedure ToggleChildrenEnabledState(AGroup: TdxCustomLayoutGroup; const AEnabled: Boolean);

    function GetChecked: Boolean;
    procedure SetChecked(AValue: Boolean);
    procedure SetState(AValue: TcxCheckBoxState);
  protected
    procedure DoClick; override;
    function GetViewInfoClass: TdxLayoutGroupButtonViewInfoClass; override;
    procedure Toggle;

    property State: TcxCheckBoxState read FState write SetState default cbsChecked;
  public
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
  published
    property CheckAction: TdxCheckGroupBoxCheckBoxAction read FCheckAction write FCheckAction default cbaToggleChildrenEnabledState;
    property Checked: Boolean read GetChecked write SetChecked default True;
    property Visible default False;
  end;

  { TdxCustomLayoutGroupButtons }

  TdxCustomLayoutGroupButtons = class(TCollection)
  strict private
    FOptions: TdxLayoutGroupButtonOptions;
    FOnChange: TNotifyEvent;

    function GetItem(Index: Integer): TdxCustomLayoutGroupButton;
    function GetOptions: TdxLayoutGroupButtonOptions;
    procedure SetItem(Index: Integer; const AValue: TdxCustomLayoutGroupButton);
  protected
    procedure ChangeScale(M, D: Integer); virtual;
    function GetItemClass: TdxCustomLayoutGroupButtonClass; virtual;
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;

    property Options: TdxLayoutGroupButtonOptions read GetOptions;
  public
    constructor Create(AOptions: TdxLayoutGroupButtonOptions);

    property Items[Index: Integer]: TdxCustomLayoutGroupButton read GetItem write SetItem; default;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  { TdxLayoutGroupButtons }

  TdxLayoutGroupButtons = class(TdxCustomLayoutGroupButtons)
  strict private
    function GetItem(Index: Integer): TdxLayoutGroupButton;
    procedure SetItem(Index: Integer; const AValue: TdxLayoutGroupButton);
  protected
    function GetItemClass: TdxCustomLayoutGroupButtonClass; override;
  public
    property Items[Index: Integer]: TdxLayoutGroupButton read GetItem write SetItem; default;
  end;

  { TdxLayoutGroupButtonOptions }

  TdxLayoutGroupButtonsAlignment = (gbaLeft, gbaRight);

  TdxLayoutGroupButtonOptions = class(TPersistent)
  private
    FAlignment: TdxLayoutGroupButtonsAlignment;
    FDefaultHeight: Cardinal;
    FDefaultWidth: Cardinal;
    FGroup: TdxCustomLayoutGroup;
    FVisible: Boolean;

    FCheckBox: TdxLayoutGroupCheckBoxButton;
    FExpandButton: TdxLayoutGroupButton;
    FHomeButton: TdxLayoutGroupButton;

    FButtons: TdxLayoutGroupButtons;
    FInternalButtons: TdxCustomLayoutGroupButtons;
    FVisibleButtons: TList;

    procedure ChangeCollectionHandler(Sender: TObject);
    procedure HomeButtonClickHandler(Sender: TObject);
    function GetShowExpandButton: Boolean;
    procedure GetExpandButtonHintHandler(Sender: TObject; var AText: string);
    procedure SetAlignment(AValue: TdxLayoutGroupButtonsAlignment);
    procedure SetButtons(AValue: TdxLayoutGroupButtons);
    procedure SetCheckBox(AValue: TdxLayoutGroupCheckBoxButton);
    procedure SetDefaultHeight(AValue: Cardinal);
    procedure SetDefaultWidth(AValue: Cardinal);
    procedure SetShowExpandButton(AValue: Boolean);
    procedure SetVisible(AValue: Boolean);
  protected
    function GetOwner: TPersistent; override;
    procedure Changed;
    procedure ChangeScale(M, D: Integer); virtual;

    procedure CreateCheckBox;
    procedure CreateExpandButton;
    procedure CreateHomeButton;
    function GetVisibleButton(AIndex: Integer): TdxCustomLayoutGroupButton;
    function IsAnyButtonVisible: Boolean;
    function RefreshVisibleButtons: Boolean;
    procedure UpdateInternalButtons;

    // Storing
    procedure GetStoredPropertyValue(const AName: string; var AValue: Variant);
    procedure GetStoredProperties(AProperties: TStrings);
    procedure SetStoredPropertyValue(const AName: string; const AValue: Variant);

    property HomeButton: TdxLayoutGroupButton read FHomeButton;
  public
    constructor Create(AGroup: TdxCustomLayoutGroup);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    property ExpandButton: TdxLayoutGroupButton read FExpandButton;
    property Group: TdxCustomLayoutGroup read FGroup;
  published
    property Alignment: TdxLayoutGroupButtonsAlignment read FAlignment write SetAlignment default gbaRight;
    property Buttons: TdxLayoutGroupButtons read FButtons write SetButtons stored False;
    property CheckBox: TdxLayoutGroupCheckBoxButton read FCheckBox write SetCheckBox;
    property DefaultHeight: Cardinal read FDefaultHeight write SetDefaultHeight default 16;
    property DefaultWidth: Cardinal read FDefaultWidth write SetDefaultWidth default 16;
    property ShowExpandButton: Boolean read GetShowExpandButton write SetShowExpandButton default False;
    property Visible: Boolean read FVisible write SetVisible default True;
  end;

  TdxLayoutGroupCaptionOptions = class(TdxCustomLayoutItemStorableCaptionOptions)
  public
    constructor Create(AItem: TdxCustomLayoutItem); override;
  published
    property AlignHorz;
    property AlignVert default tavTop;
    property EllipsisPosition;
    property Glyph;
    property Hint;
    property ImageIndex;
    property Layout default clTop;
    property ShowAccelChar;
    property Text;
    property Visible;
    property VisibleElements;
  end;

  TdxLayoutGroupWrappingState = (wsNone, wsSqueezed, wsPopulated);
  TdxLayoutGroupScrollMode = (smNone, smAuto, smIndependent);

  TdxLayoutGroupScrollOptions = class(TdxCustomLayoutItemOptions)
  private
    FHorizontal: TdxLayoutGroupScrollMode;
    FVertical: TdxLayoutGroupScrollMode;
    procedure SetHorizontalScroll(Value: TdxLayoutGroupScrollMode);
    procedure SetVerticalScroll(Value: TdxLayoutGroupScrollMode);
    function GetMajorScroll: TdxLayoutGroupScrollMode;
    function GetMinorScroll: TdxLayoutGroupScrollMode;
  protected
    procedure DoAssign(Source: TPersistent); override;
    procedure Changed; override;
    property MajorScroll: TdxLayoutGroupScrollMode read GetMajorScroll;
    property MinorScroll: TdxLayoutGroupScrollMode read GetMinorScroll;
  published
    property Horizontal: TdxLayoutGroupScrollMode read FHorizontal write SetHorizontalScroll default smNone;
    property Vertical: TdxLayoutGroupScrollMode read FVertical write SetVerticalScroll default smNone;
  end;

  TdxLayoutGroupExpandingEvent = procedure(Sender: TObject; var Allow: Boolean) of object;
  TdxLayoutGroupCheckBoxStateChangingEvent = procedure(Sender: TObject; const ANewState: TcxCheckBoxState; var Allow: Boolean) of object;
  TdxLayoutGroupTabChangingEvent = procedure(Sender: TObject; ANewTabIndex: Integer; var Allow: Boolean) of object;

  TdxLayoutGroupWrapItemsMode = (wmNone, wmParentManaged, wmImmediateChildren, wmAllChildren);

  TdxCustomLayoutGroup = class(TdxCustomLayoutItem, IcxControlComponentState)
  private
    FButtonOptions: TdxLayoutGroupButtonOptions;
    FExpanded: Boolean;
    FHidden: Boolean;
    FAutoCreated: Boolean;
    FAutoCreatedForWrap: Boolean;
    FItems: TcxComponentList;
    FItemIndex: Integer;
    FVisibleItems: TcxComponentList;
    FLayoutDirection: TdxLayoutDirection;
    FItemControlAreaAlignment: TdxLayoutItemControlAreaAlignment;
    FLocked: Boolean;
    FLayoutLookAndFeelException: Boolean;
    FShowBorder: Boolean;
    FScrollOptions: TdxLayoutGroupScrollOptions;
    FTabbedOptions: TdxLayoutTabbedOptions;
    FUseIndent: Boolean;
    FWrappingState: TdxLayoutGroupWrappingState;
    FWrapItemsMode: TdxLayoutGroupWrapItemsMode;

    FOnCheckBoxStateChanged: TNotifyEvent;
    FOnCheckBoxStateChanging: TdxLayoutGroupCheckBoxStateChangingEvent;
    FOnCollapsed: TNotifyEvent;
    FOnCollapsing: TdxLayoutGroupExpandingEvent;
    FOnExpanded: TNotifyEvent;
    FOnExpanding: TdxLayoutGroupExpandingEvent;
    FOnTabChanged: TNotifyEvent;
    FOnTabChanging: TdxLayoutGroupTabChangingEvent;

    procedure TabChangedHandler(Sender: TObject; AType: TcxCustomTabControlPropertiesChangedType);
    procedure TabChangeHandler(Sender: TObject);
    procedure TabCanCloseHandler(Sender: TObject; ATabIndex: Integer; var ACanClose: Boolean);
    procedure TabClickHandler(Sender: TObject; ATabVisibleIndex: Integer; AShift: TShiftState);
    procedure TabCloseHandler(Sender: TObject; ATabIndex: Integer);

    function GetAllowScroll: Boolean;
    function GetAllowWrapItems: Boolean;
    function GetAutoCreatedForDirection: Boolean;
    function GetCaptionOptions: TdxLayoutGroupCaptionOptions; inline;
    function GetCount: Integer;
    function GetItem(Index: Integer): TdxCustomLayoutItem;
    function GetShowBorder: Boolean;
    function GetViewInfo: TdxLayoutGroupViewInfo;
    function GetVisibleCount: Integer;
    function GetVisibleItem(Index: Integer): TdxCustomLayoutItem;
    procedure SetAllowScroll(Value: Boolean);
    procedure SetAllowWrapItems(Value: Boolean);
    procedure SetButtonOptions(Value: TdxLayoutGroupButtonOptions);
    procedure SetCaptionOptions(Value: TdxLayoutGroupCaptionOptions); inline;
    procedure SetExpanded(Value: Boolean);
    procedure SetHidden(Value: Boolean);
    procedure SetItemIndex(Value: Integer);
    procedure SetItemControlAreaAlignment(Value: TdxLayoutItemControlAreaAlignment);
    procedure SetLayoutDirection(Value: TdxLayoutDirection);
    procedure SetLocked(Value: Boolean);
    procedure SetLayoutLookAndFeelException(Value: Boolean);
    procedure SetScrollOptions(Value: TdxLayoutGroupScrollOptions);
    procedure SetShowBorder(Value: Boolean);
    procedure SetTabbedOptions(Value: TdxLayoutTabbedOptions);
    procedure SetTabIndex(Value: Integer);
    procedure SetUseIndent(Value: Boolean);
    procedure SetWrapItemsMode(Value: TdxLayoutGroupWrapItemsMode);

    procedure AddItem(AItem: TdxCustomLayoutItem);
    procedure ExtractItem(AItem: TdxCustomLayoutItem);
    procedure ItemListChanged(Sender: TObject; AComponent: TComponent; AAction: TcxComponentCollectionNotification);

    procedure ReadSpecial(Reader: TReader);
    procedure WriteSpecial(Writer: TWriter);
    procedure ReadAutoCreated(Reader: TReader);

    function IsItemIndexStored: Boolean;
    function GetChildLayoutLookAndFeel: TdxCustomLayoutLookAndFeel;

    procedure ReadButtons(Reader: TReader);
    procedure WriteButtons(Writer: TWriter);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure Loaded; override;
    procedure SetParentComponent(Value: TComponent); override;
    function GetStoredProperties(AProperties: TStrings): Boolean; override;
    procedure GetStoredPropertyValue(const AName: string; var AValue: Variant); override;
    procedure SetStoredPropertyValue(const AName: string; const AValue: Variant); override;

    procedure BiDiModeChanged; override;
    function CanAcceptItem(AItem: TdxCustomLayoutItem): Boolean; override;
    function CanDelete: Boolean; override;
    function CanDragAndDrop(const P: TPoint): Boolean; override;
    function CanRemove: Boolean; override;
    procedure ChangeScale(M: Integer; D: Integer); override;
    procedure CheckIndex; override;
    procedure ContainerChanged; override;
    procedure DoCaptionClick; override;
    procedure DoGetTabOrderList(List: TList); override;
    procedure DoChildPack;
    procedure DoPack; override;
    function DoProcessAccel: Boolean; override;
    class function GetCaptionOptionsClass: TdxCustomLayoutItemCaptionOptionsClass; override;
    function GetIsRoot: Boolean; override;
    function GetOptions: TdxCustomLayoutLookAndFeelOptions; override;
    function GetRealAlignHorz: TdxLayoutRealAlignHorz; override;
    function GetRealAlignVert: TdxLayoutRealAlignVert; override;
    function GetVisible: Boolean; override;
    function GetViewInfoClass: TdxCustomLayoutItemViewInfoClass; override;
    procedure InitiateAction; override;
    procedure LoadFromIni(AIniFile: TCustomIniFile; const ASection: string; AVersion: Integer); override;
    function NeedDeleteAfterLoading: Boolean; override;
    procedure SaveToIni(AIniFile: TCustomIniFile; const ASection: string); override;
    procedure PopulateItems(AList: TList); override;
    function ProcessDialogChar(ACharCode: Word): Boolean; override;
    function ProcessDialogKey(ACharCode: Word; AKeyData: Integer; AFocusedItem: TdxCustomLayoutItem): Boolean; override;
    procedure RestoreItemControlBounds; override;

    procedure LayoutLookAndFeelChanged; override;
    procedure SetInitialSettings; override;
    procedure BeforeCalculateViewInfo; override;
    procedure AfterCalculateViewInfo; override;
    procedure ApplyCalculatedChanges; override;
    procedure ResetRealAlign; override;
    procedure ResetEnabled; override;

    function IsWrapItemsAllowed: Boolean; override;
    function CanWrapItems: Boolean; virtual;
    function CanWrapImmediateChildItems: Boolean;
    function CanWrapAllChildItems: Boolean;
    function GetWrapRowCount: Integer;
    function GetWrapColumnCount: Integer;

    function AllowFloatingDragImage: Boolean; override;
    function AllowShowChild(AChild: TdxCustomLayoutItem): Boolean; virtual;
    function IsAnyButtonVisible: Boolean;
    function IsCheckBoxVisible: Boolean;
    function IsGroup: Boolean; override;
    function IsFloatingRoot: Boolean; override;
    function IsLocked: Boolean; override;
    function IsSuperfluous(AForDestroy: Boolean): Boolean; virtual;

    procedure CreateOptions; override;
    procedure DestroyOptions; override;

    procedure DoCheckBoxStateChanged;
    function DoCheckBoxStateChanging(ANewState: TcxCheckBoxState): Boolean;
    procedure DoCollapsed; virtual;
    function DoCollapsing: Boolean; virtual;
    procedure DoExpanded; virtual;
    function DoExpanding: Boolean; virtual;
    procedure DoTabChanged; virtual;
    function DoTabChanging(ANewTabIndex: Integer): Boolean; virtual;

    function GetMaxChildImageSize: TSize;
    function GetHelperClass: TdxLayoutGroupHelperClass;
    function GetChildItemsAlignHorz: TdxLayoutRealAlignHorz; virtual;
    function GetChildItemsAlignVert: TdxLayoutRealAlignVert; virtual;

    function CanFocus(AByMouse: Boolean): Boolean; override;
    function FocusFirst(ACheckTabStop: Boolean): Boolean; override;

    procedure BuildVisibleItemsList(ARecursive: Boolean = False);
    procedure ChangeItemIndex(AItem: TdxCustomLayoutItem; Value: Integer);
    procedure ChangeItemVisibleIndex(AItem: TdxCustomLayoutItem; Value: Integer);
    function GetItemIndex(AItemVisibleIndex: Integer): Integer;
    function IndexOf(AItem: TdxCustomLayoutItem): Integer;
    function VisibleIndexOf(AItem: TdxCustomLayoutItem): Integer;

    property AllowScroll: Boolean read GetAllowScroll write SetAllowScroll stored False; 
    property AllowWrapItems: Boolean read GetAllowWrapItems write SetAllowWrapItems stored False; // obsolete
    property AutoCreated: Boolean read FAutoCreated;
    property AutoCreatedForDirection: Boolean read GetAutoCreatedForDirection;
    property AutoCreatedForWrap: Boolean read FAutoCreatedForWrap;
    property ScrollOptions: TdxLayoutGroupScrollOptions read FScrollOptions write SetScrollOptions;
    property WrapItemsMode: TdxLayoutGroupWrapItemsMode read FWrapItemsMode write SetWrapItemsMode default wmParentManaged;
    property OnCheckBoxStateChanging: TdxLayoutGroupCheckBoxStateChangingEvent read FOnCheckBoxStateChanging write FOnCheckBoxStateChanging;
    property TabIndex: Integer read FItemIndex write SetTabIndex;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    function CreateGroup: TdxLayoutGroup; overload;
    function CreateGroup(AGroupClass: TdxCustomLayoutGroupClass): TdxCustomLayoutGroup; overload;
    function CreateItem(AItemClass: TdxCustomLayoutItemClass = nil): TdxCustomLayoutItem;
    function CreateItemForControl(AControl: TControl): TdxLayoutItem;

    function CanMoveTo(AParent: TdxCustomLayoutItem): Boolean; override;
    procedure Dismiss;
    procedure MoveChildrenToParent(AKeepAlign: Boolean = True);
    procedure MoveChildrenIntoHiddenGroup(AGroup: TdxCustomLayoutGroup);
    function PutChildrenIntoHiddenGroup: TdxLayoutAutoCreatedGroup;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TdxCustomLayoutItem read GetItem; default;
    property ViewInfo: TdxLayoutGroupViewInfo read GetViewInfo; // for internal use
    property VisibleCount: Integer read GetVisibleCount;
    property VisibleItems[Index: Integer]: TdxCustomLayoutItem read GetVisibleItem;

    property AllowQuickCustomize;
    property AllowRemove;
    property ButtonOptions: TdxLayoutGroupButtonOptions read FButtonOptions write SetButtonOptions;
    property CaptionOptions: TdxLayoutGroupCaptionOptions read GetCaptionOptions write SetCaptionOptions;
    property Enabled;
    property Expanded: Boolean read FExpanded write SetExpanded default True;
    property Hidden: Boolean read FHidden write SetHidden default False;
    property ItemControlAreaAlignment: TdxLayoutItemControlAreaAlignment read FItemControlAreaAlignment write SetItemControlAreaAlignment default catDefault;
    property ItemIndex: Integer read FItemIndex write SetItemIndex stored IsItemIndexStored;
    property LayoutDirection: TdxLayoutDirection read FLayoutDirection write SetLayoutDirection default ldVertical;
    property Locked: Boolean read FLocked write SetLocked default False;
    property LookAndFeelException: Boolean read FLayoutLookAndFeelException write SetLayoutLookAndFeelException stored False; // obsolete
    property LayoutLookAndFeelException: Boolean read FLayoutLookAndFeelException write SetLayoutLookAndFeelException default False;
    property Padding;
    property ShowBorder: Boolean read GetShowBorder write SetShowBorder default True;
    property TabbedOptions: TdxLayoutTabbedOptions read FTabbedOptions write SetTabbedOptions;
    property UseIndent: Boolean read FUseIndent write SetUseIndent default True;
    property OnCaptionClick;
    property OnCheckBoxStateChanged: TNotifyEvent read FOnCheckBoxStateChanged write FOnCheckBoxStateChanged;
    property OnCollapsed: TNotifyEvent read FOnCollapsed write FOnCollapsed;
    property OnCollapsing: TdxLayoutGroupExpandingEvent read FOnCollapsing write FOnCollapsing;
    property OnExpanded: TNotifyEvent read FOnExpanded write FOnExpanded;
    property OnExpanding: TdxLayoutGroupExpandingEvent read FOnExpanding write FOnExpanding;
    property OnTabChanged: TNotifyEvent read FOnTabChanged write FOnTabChanged;
    property OnTabChanging: TdxLayoutGroupTabChangingEvent read FOnTabChanging write FOnTabChanging;
  end;

  TdxCustomLayoutAutoCreatedGroup = class(TdxCustomLayoutGroup)
  protected
    function IsStable: Boolean; override;
    procedure DoPack; override;
    procedure DoPackAsSuperfluous; virtual; abstract;
    class function GetItemClassKind: Integer; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TdxLayoutAutoCreatedGroup = class(TdxCustomLayoutAutoCreatedGroup)
  protected
    procedure Loaded; override;
    function GetBaseName: string; override;
    function IsSuperfluous(AForDestroy: Boolean): Boolean; override;
    procedure DoPackAsSuperfluous; override;
  public
    destructor Destroy; override;
  published
    property AlignHorz;
    property AlignVert;
    property Caption stored False;
    property LayoutDirection;
  end;

  TdxLayoutAutoCreatedWrappingGroup = class(TdxCustomLayoutAutoCreatedGroup)
  protected
    function CanWrapItems: Boolean; override;
    function GetBaseName: string; override;
    function GetChildItemsAlignHorz: TdxLayoutRealAlignHorz; override;
    function GetChildItemsAlignVert: TdxLayoutRealAlignVert; override;
    function IsSuperfluous(AForDestroy: Boolean): Boolean; override;
    procedure DoPackAsSuperfluous; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TdxLayoutGroup = class(TdxCustomLayoutGroup)
  protected
    function CanFloat: Boolean; override;
    function GetBaseName: string; override;
    class function GetItemClassKind: Integer; override;
  published
    property AlignHorz;
    property AlignVert;
    property AlignmentConstraint;
    property CaptionOptions;
    property LayoutLookAndFeel;
    property Offsets;
    property Visible;
    property SizeOptions;
    property AllowFloating;
    property AllowQuickCustomize;
    property AllowRemove;
    property AllowWrapItems; // obsolete
    property ButtonOptions;
    property Enabled;
    property Expanded;
    property Hidden;
    property ItemControlAreaAlignment;
    property ItemIndex;
    property LayoutDirection;
    property Locked;
    property LookAndFeelException; // obsolete
    property LayoutLookAndFeelException;
    property Padding;
    property ScrollOptions; 
    property ShowBorder;
    property TabbedOptions;
    property UseIndent;
    property WrapItemsMode;
    property OnCaptionClick;
    property OnCheckBoxStateChanged;
    property OnCollapsed;
    property OnCollapsing;
    property OnExpanded;
    property OnExpanding;
    property OnTabChanged;
    property OnTabChanging;
    property OnStartFloat;
    property OnEndFloat;
  end;

  // alignment constraint

  TdxLayoutAlignmentConstraintKind = (ackLeft, ackTop, ackRight, ackBottom);

  TdxLayoutAlignmentConstraint = class(TComponent)
  private
    FContainer: TdxLayoutContainer;
    FItems: TList;
    FKind: TdxLayoutAlignmentConstraintKind;
    function GetCount: Integer;
    function GetItem(Index: Integer): TdxCustomLayoutItem;
    procedure SetKind(Value: TdxLayoutAlignmentConstraintKind);
    procedure CreateItems;
    procedure DestroyItems;

    procedure InternalAddItem(AItem: TdxCustomLayoutItem);
    procedure InternalRemoveItem(AItem: TdxCustomLayoutItem);

    function AreItemViewInfosAligned(ACount: Integer): Boolean;
    procedure AlignItemViewInfos(ACount: Integer);
    procedure ChangeOffset(AIndex, ADelta: Integer);
    procedure ResetOffsets;
  protected
    procedure SetParentComponent(Value: TComponent); override;

    procedure BeginUpdate;
    function CanAddItem(AItem: TdxCustomLayoutItem): Boolean; virtual;
    procedure Changed; virtual;
    procedure EndUpdate;

    function GetBorderValue(AIndex: Integer): Integer;
    function GetMostBorderValue(ACount: Integer = 0): Integer;
    function GetOffsetSide: TdxLayoutSide;

    property Container: TdxLayoutContainer read FContainer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetParentComponent: TComponent; override;
    function HasParent: Boolean; override;

    procedure AddItem(AItem: TdxCustomLayoutItem);
    procedure RemoveItem(AItem: TdxCustomLayoutItem);

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TdxCustomLayoutItem read GetItem;
  published
    property Kind: TdxLayoutAlignmentConstraintKind read FKind write SetKind default ackLeft;
  end;
  TdxLayoutAlignmentConstraintClass = class of TdxLayoutAlignmentConstraint;

  { TdxLayoutContainerPersistent }

  TdxLayoutContainerPersistent = class(TPersistent)
  private
    FContainer: TdxLayoutContainer;
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AContainer: TdxLayoutContainer); virtual;
    property Container: TdxLayoutContainer read FContainer;
  end;

  { TdxLayoutContainerFocusController }

  TdxLayoutContainerFocusController = class(TdxLayoutContainerPersistent)
  private
    FFocusedItem: TdxCustomLayoutItem;

    function GetCurrentTabOrder: Integer;
    procedure SetCurrentTabOrder(const Value: Integer);
    procedure SetFocusedItem(Value: TdxCustomLayoutItem);
  protected
    function GetMaxTabOrder: Integer;
    function FindItem(ATabOrder: Integer): TdxCustomLayoutItem;
    function FindNextControl(ACurrentControl: TWinControl; AGoForward: Boolean): TWinControl;
    function IsFocused(AItem: TdxCustomLayoutItem): Boolean; virtual;

    procedure SetFocus;
    procedure KillFocus;
    procedure CheckFocus;

    procedure SetItemFocus(AItem: TdxCustomLayoutItem);

    property CurrentTabOrder: Integer read GetCurrentTabOrder write SetCurrentTabOrder;
    property FocusedItem: TdxCustomLayoutItem read FFocusedItem write SetFocusedItem;
  public
    function SelectNext(AFocusedControl: TWinControl; const ACharCode: Word = VK_TAB): Boolean;
  end;
  TdxLayoutContainerFocusControllerClass = class of TdxLayoutContainerFocusController;

  { TdxLayoutContainerCustomizationHelper }

  TdxLayoutContainerCustomizationHelper = class
  private
    FContainer: TdxLayoutContainer;
  public
    constructor Create(AContainer: TdxLayoutContainer);
    procedure CopyStructure(AContainer: TdxLayoutContainer); virtual;

    property Container: TdxLayoutContainer read FContainer;
  end;
  TdxLayoutContainerCustomizationHelperClass = class of TdxLayoutContainerCustomizationHelper;

  { TdxLayoutImageOptions }

  TdxLayoutImageOptions = class(TdxLayoutContainerPersistent)
  private
    FDisabledImages: TCustomImageList;
    FDisabledImagesChangeLink: TChangeLink;
    FImages: TCustomImageList;
    FImagesChangeLink: TChangeLink;
    procedure FreeNotification(AComponent: TComponent);
    procedure ImagesChange(Sender: TObject);
    procedure SetImages(AValue: TCustomImageList);
    procedure SetDisabledImages(AValue: TCustomImageList);
    procedure SetImageList(var ANewValue, AOldValue: TCustomImageList; const AChangeLink: TChangeLink);
  protected
    procedure Changed;
    procedure BeginUpdate;
    procedure EndUpdate;
  public
    constructor Create(AContainer: TdxLayoutContainer); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property DisabledImages: TCustomImageList read FDisabledImages write SetDisabledImages;
    property Images: TCustomImageList read FImages write SetImages;
  end;

  { TdxLayoutContainer }

  TdxLayoutContainer = class(TcxCustomComponent,
    IdxLayoutContainerOwner,
    IdxLayoutDesignerHelper,
    IdxLayoutLookAndFeelUser,
    IcxScalableComponent,
    IcxStoredObject,
    IcxStoredParent,
    IdxScaleFactor,
    IdxSelectionChanged
  )
  private
    FAlignmentConstraints: TComponentList;
    FDragDropMode: TdxLayoutDragDropMode;
    FFocusController: TdxLayoutContainerFocusController;
    FImageOptions: TdxLayoutImageOptions;
    FLayoutLookAndFeel: TdxCustomLayoutLookAndFeel;
    FMenuItems: TdxLayoutCustomizeFormMenuItems;
    FPainter: TdxLayoutContainerPainter;
    FScaleFactor: TdxScaleFactor;
    FSelectionHelper: IdxLayoutDesignerHelper;
    FViewInfo: TdxLayoutContainerViewInfo;

    // Internal flags
    FPlaceControlsLockCount: Integer;
    FIsPlaceControlsNeeded: Boolean;
    FIsPlacingControls: Boolean;
    FIsProcessingControls: Integer;
    FIsScalingControls: Integer;
    FUpdateLockCount: Integer;
    FTranslationLockCount: Integer;
    FSelectionLayerPainting: Boolean;

    // Items
    FAbsoluteItems: TcxComponentList; 
    FAvailableItems: TcxComponentList;
    FFloatContainers: TcxComponentList;
    FManagedItems: TcxComponentList; 
    FRoot: TdxLayoutGroup;
    FGarbageCollector: TcxComponentList; 
    // Storing
    FIsRestoring: Boolean;
    FStoredVersion: Integer;
    FStoringName: string;
    // UndoRedo
    FUndoRedoManager: TdxUndoRedoManager;
    // Customize
    FCustomization: Boolean;
    FCustomizationHelper: TdxLayoutContainerCustomizationHelper;
    FCustomizeAvailableItemsViewKind: TdxLayoutAvailableItemsViewKind;
    FCustomizeForm: TdxLayoutControlCustomCustomizeForm;
    FCustomizeFormBounds: TRect;
    FCustomizeFormClass: TdxLayoutControlCustomCustomizeFormClass;
    FCustomizeFormTabbedView: Boolean;
    FCustomizeFormUpdateTypes: TdxLayoutCustomizeFormUpdateTypes;
    FQuickCustomization: Boolean;
    FRenamingItem: TdxCustomLayoutItem;

    FAllowGroupWrapItems: Boolean;
    FAllowOptimizeWrappedItems: Boolean;
    FAllowRename: Boolean;
    FHighlightRoot: Boolean;
    FShowDesignSelectors: Boolean;
    FShowQuickCustomizationToolbar: Boolean;
    FMasterContainer: TdxLayoutContainer;

    FOnChanged: TNotifyEvent;
    FOnItemChanged: TdxLayoutItemChangedEvent;
    FOnSelectionChanged: TNotifyEvent;

    procedure AbsoluteItemListChanged(Sender: TObject; AComponent: TComponent; AAction: TcxComponentCollectionNotification);
    procedure AvailableItemListChanged(Sender: TObject; AComponent: TComponent; AAction: TcxComponentCollectionNotification);
    procedure FloatContainersListChanged(Sender: TObject; AComponent: TComponent; AAction: TcxComponentCollectionNotification);
    function GetAlignmentConstraint(Index: Integer): TdxLayoutAlignmentConstraint;
    function GetAlignmentConstraintCount: Integer;
    function GetCustomization: Boolean;
    function GetIsDesignSelectorsVisible: Boolean;
    function GetIsOnGlass: Boolean;
    function GetIsStoringNameMode: Boolean;
    function GetDragDropMode: TdxLayoutDragDropMode;
    function GetRealContainer: TdxLayoutContainer;
    function GetSelectionHelper: IdxLayoutDesignerHelper;

    //Items
    function GetAbsoluteItem(AIndex: Integer): TdxCustomLayoutItem;
    function GetAbsoluteItemCount: Integer;
    function GetAvailableItem(AIndex: Integer): TdxCustomLayoutItem;
    function GetAvailableItemCount: Integer;
    function GetManagedItem(AIndex: Integer): TdxCustomLayoutItem;
    function GetManagedItemCount: Integer;
    function GetManagedItemList: TcxComponentList;

    procedure SetAllowGroupWrapItems(AValue: Boolean);
    procedure SetCustomization(AValue: Boolean);
    procedure SetCustomizeAvailableItemsViewKind(Value: TdxLayoutAvailableItemsViewKind);
    procedure SetCustomizeFormTabbedView(AValue: Boolean);
    procedure SetHighlightRoot(AValue: Boolean);
    procedure SetImageOptions(AValue: TdxLayoutImageOptions);
    procedure SetIsRestoring(AValue: Boolean);
    procedure SetLayoutLookAndFeel(Value: TdxCustomLayoutLookAndFeel);
    procedure SetQuickCustomization(Value: Boolean);
    procedure SetRenamingItem(AValue: TdxCustomLayoutItem);
    procedure SetShowDesignSelectors(Value: Boolean);
    procedure SetOnItemChanged(AValue: TdxLayoutItemChangedEvent);
  protected
    FCalculationDireNeeded: Boolean;

    // IcxScalableComponent
    procedure ChangeScale(M, D: Integer); virtual;
    procedure ScaleForPPI(ATargetPPI: Integer); virtual;
    // IdxScaleFactor
    function GetScaleFactor: TdxScaleFactor; virtual;

    //IdxLayoutLookAndFeelUser
    procedure IdxLayoutLookAndFeelUser.BeginLookAndFeelDestroying = BeginLayoutLookAndFeelUserDestroying;
    procedure IdxLayoutLookAndFeelUser.EndLookAndFeelDestroying = EndLayoutLookAndFeelUserDestroying;
    procedure IdxLayoutLookAndFeelUser.LookAndFeelChanged = LayoutLookAndFeelUserChanged;
    procedure IdxLayoutLookAndFeelUser.LookAndFeelDestroyed = LayoutLookAndFeelUserDestroyed;
    procedure BeginLayoutLookAndFeelUserDestroying; stdcall;
    procedure EndLayoutLookAndFeelUserDestroying; stdcall;
    procedure LayoutLookAndFeelUserChanged; virtual; stdcall;
    procedure LayoutLookAndFeelUserDestroyed; stdcall;
    // IdxSelectionChanged
    procedure SelectionChanged(ASelection: TList; AAction: TdxSelectionAction);
    // IdxLayoutDesignerHelper
    procedure AddSelectionChangedListener(AListener: TPersistent);
    function IsActive: Boolean;
    function CanDeleteComponent(AComponent: TComponent): Boolean;
    function CanModify: Boolean;
    function CanProcessKeyboard: Boolean; virtual;
    procedure ClearSelection;
    procedure DeleteComponent(AComponent: TComponent);
    procedure DeleteComponents(AList: TComponentList);
    procedure DeleteSelection;
    procedure GetSelection(AList: TList);
    function IsComponentSelected(AComponent: TPersistent): Boolean;
    procedure RemoveSelectionChangedListener(AListener: TPersistent);
    procedure SelectComponent(AComponent: TPersistent; AShift: TShiftState = []);
    procedure SetSelection(AList: TList);
    function UniqueName(const BaseName: string): string;
    // IdxLayoutContainerOwner
    function GetContainer: TdxLayoutContainer;
    // IcxStoredObject
    function IcxStoredObject.GetObjectName = GetStoredObjectName;
    function IcxStoredObject.GetProperties = GetStoredProperties;
    procedure IcxStoredObject.GetPropertyValue = GetStoredPropertyValue;
    procedure IcxStoredObject.SetPropertyValue = SetStoredPropertyValue;
    procedure DoGetStoredPropertyValue(const AName: string; var AValue: Variant); virtual;
    procedure DoSetStoredPropertyValue(const AName: string; const AValue: Variant); virtual;
    function GetStoredObjectName: string; virtual;
    function GetStoredProperties(AProperties: TStrings): Boolean; virtual;
    procedure GetStoredPropertyValue(const AName: string; var AValue: Variant); virtual;
    procedure SetStoredPropertyValue(const AName: string; const AValue: Variant); virtual;
    // IcxStoredParent
    function CreateChild(const AObjectName, AClassName: string): TObject; virtual;
    procedure DeleteChild(const AObjectName: string; AObject: TObject); virtual;
    procedure IcxStoredParent.GetChildren = GetStoredChildren;
    procedure GetStoredChildren(AChildren: TStringList); virtual;

    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    procedure AddAvailableItem(AItem: TdxCustomLayoutItem);
    procedure DisposeGroup(AGroup: TdxCustomLayoutGroup);
    function GetLayoutLookAndFeel: TdxCustomLayoutLookAndFeel;
    function GetAutoCreatedGroup: TdxLayoutAutoCreatedGroup;
    procedure TryDestroySuperfluousGroup(AGroup: TdxCustomLayoutGroup);
    procedure CreateRootGroup; virtual;
    procedure DestroyRootGroup;
    procedure ExtractAvailableItem(AItem: TdxCustomLayoutItem);
    function GetRoot: TdxLayoutGroup;
    procedure InsertItem(AItem: TdxCustomLayoutItem); virtual;
    procedure RemoveItem(AItem: TdxCustomLayoutItem); virtual;
    procedure SetRootGroup(Value: TdxLayoutGroup);
    procedure UpdateItemDesignSelectors;
    procedure UpdateRootName; virtual;

    // Mouse
    function CanFocusOnClick(X, Y: Integer): Boolean; virtual;
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; virtual;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure MouseLeave(AControl: TControl); virtual;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); virtual;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    function IsChildKey(Message: TCMChildKey): Boolean; virtual;
    function IsMouseWheelHandleNeeded(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState); virtual;

    // CustomizeForm
    function CalculateCustomizeFormBounds(const AFormBounds: TRect): TRect; virtual;
    procedure CreateCustomizeForm; virtual;
    function GetCustomizeForm: TdxLayoutControlCustomCustomizeForm; virtual;
    procedure DestroyCustomizeForm; virtual;
    procedure ShowCustomizeForm; virtual;
    procedure UpdateItemsCustomization;

    // Classes
    function GetAlignmentConstraintClass: TdxLayoutAlignmentConstraintClass; virtual;
    function GetCustomizationHelperClass: TdxLayoutContainerCustomizationHelperClass; virtual;
    function GetDefaultGroupClass: TdxLayoutGroupClass; virtual;
    function GetDefaultItemClass: TdxLayoutItemClass; virtual;
    function GetDefaultLabelClass: TdxLayoutLabeledItemClass; virtual;
    function GetDefaultRootGroupClass: TdxLayoutGroupClass; virtual;
    function GetFocusControllerClass: TdxLayoutContainerFocusControllerClass; virtual;
    function GetPainterClass: TdxLayoutContainerPainterClass; virtual;
    function GetSelectionHelperClass: TdxLayoutRunTimeSelectionHelperClass; virtual;
    function GetViewInfoClass: TdxLayoutContainerViewInfoClass; virtual;

    procedure CreateHandlers; virtual;
    procedure DestroyHandlers; virtual;

    procedure CreateItems;
    procedure DestroyItems;

    function CanGetHitTest(const P: TPoint): Boolean; virtual;
    function GetStatusHint(const APoint: TPoint; const AOriginalHint: string): string;
    procedure ToggleHotTrackState(AItem: TdxCustomLayoutItem);
    function ShowHint(var AHintInfo: THintInfo; X, Y: Integer): Boolean;

    // Change&Calculate
    procedure ApplyCalculatedChanges;
    function IsContainerReady: Boolean; virtual;
    function CanUpdate: Boolean; virtual;
    procedure DoCalculateRoot(ARecreateViewData: Boolean); virtual;
    procedure DoChanged; virtual;
    procedure DoSelectionChanged; virtual;
    procedure InitializeSubControlsCxLookAndFeel; virtual;
    procedure InvalidateWithChildren;
    procedure LayoutChanged(ANeedPack: Boolean = True); virtual;
    procedure PostLayoutChanged(AType: TdxChangeType = ctHard); virtual;

    // Wrap functions
    function AddWrapLevel(AGroup: TdxCustomLayoutGroup; ALayoutDirection: TdxLayoutDirection): TdxLayoutAutoCreatedWrappingGroup;
    function SimpleWrap(AGroup: TdxCustomLayoutGroup; AMaxWidth: Integer): Boolean;
    procedure SqueezeWrappingGroup(AGroup: TdxCustomLayoutGroup);
    procedure PopulateWrappingGroups;
    procedure UnclenchWrappingGroup(AGroup: TdxCustomLayoutGroup);

    function GetDisabledImages: TCustomImageList; virtual;
    function GetImages: TCustomImageList; virtual;

    // Customize
    // Float
    function IsFloatingSupported: Boolean; virtual;
    function AllowFloatingDragImage: Boolean; virtual;
    function AllowFloatingGroups: Boolean; virtual;
    function CreateFloatForm: TdxLayoutCustomFloatForm; virtual;
    procedure InitializeFloatForm(AItem: TdxCustomLayoutItem); virtual;
    function GetFloatDock(AItem: TdxCustomLayoutItem): TdxLayoutGroup; virtual;

    procedure BuildSelectionLayer;
    procedure CustomizationChanged; virtual;
    procedure CustomizeFormPostUpdate(AUpdateTypes: TdxLayoutCustomizeFormUpdateTypes); virtual;
    procedure CustomizeFormUpdateList(AItem: TdxCustomLayoutItem);
    function DoGetCustomizationMenuItems(const ASelectedItems: TList): TdxLayoutCustomizeFormMenuItems; virtual;
    procedure InvalidateSelectionLayer(const R: TRect);
    function IsCustomization: Boolean; virtual;
    function IsQuickCustomization: Boolean;
    function IsStandardCustomization: Boolean;
    procedure PostBuildSelectionLayer; virtual;
    procedure PostInvalidateSelectionLayer(const R: TRect); virtual;
    procedure SelectItemParent;
    procedure ResetDragAndDropObjects;
    // Customize/Rename
    procedure BeginRename(AItem: TdxCustomLayoutItem; const ABounds: TRect; const AFont: TFont); virtual;
    procedure CancelRename; virtual;
    procedure EndRename(const AText: string); virtual;

    // PlaceControls
    procedure BeginPlaceControls;
    procedure CancelPlaceControls;
    procedure EndPlaceControls;
    procedure PlaceControls(AItemViewInfo: TdxCustomLayoutItemViewInfo = nil; AProcessWinControls: Boolean = True; AAdditionalFlags: Integer = 0);
    procedure PostPlaceControls; virtual;
    procedure PrepareControl(AControl: TControl);
    procedure UnprepareControl(AControl: TControl);
    // PlacingControls/Begin+End
    function IsPlacingControls: Boolean;
    procedure BeginPlacingControls;
    procedure EndPlacingControls;
    // ProcessControls/Begin+End
    function IsProcessingControls: Boolean;
    procedure BeginProcessControls;
    procedure EndProcessControls;
    // ScaleControls
    function IsScalingControls: Boolean;
    procedure BeginScaleControls;
    procedure EndScaleControls;

    // Load&Save
    procedure AfterRestoring; virtual;
    procedure BeforeRestoring; virtual;
    procedure CheckIndexes;
    function GetRootSectionName(AIniFile: TCustomIniFile): string;
    function LoadPreviousVersions(AIniFile: TCustomIniFile): Boolean; virtual;
    procedure StoreChildren(Proc: TGetChildProc);
    // Load&Save/Store+Restore
    function CanRestore: Boolean; virtual;
    function StoringSupports: Boolean; virtual;
    procedure Restore; virtual;
    procedure Store; virtual;
    procedure RestoreFrom(const AStorageName: string; AStream: TStream;
      AReaderClass: TcxCustomReaderClass; const ARestoreName: string); virtual;
    procedure StoreTo(const AStorageName: string; AStream: TStream;
      AWriterClass: TcxCustomWriterClass; AReCreate: Boolean; const ASaveName: string);
    // storing custom properties
    procedure GetItemStoredProperties(AItem: TdxCustomLayoutItem; AProperties: TStrings); virtual;
    procedure DoGetItemStoredPropertyValue(AItem: TdxCustomLayoutItem; const AName: string; var AValue: Variant); virtual;
    procedure DoSetItemStoredPropertyValue(AItem: TdxCustomLayoutItem; const AName: string; const AValue: Variant); virtual;

    // Constraints
    procedure AddAlignmentConstraint(AConstraint: TdxLayoutAlignmentConstraint);
    procedure CreateConstraints;
    procedure DestroyConstraints;
    procedure RemoveAlignmentConstraint(AConstraint: TdxLayoutAlignmentConstraint);

    procedure AddAbsoluteItem(AItem: TdxCustomLayoutItem);
    function CanSetItemName(AItem: TdxCustomLayoutItem): Boolean; virtual;
    procedure DoItemChanged(AItem: TdxCustomLayoutItem); virtual;
    procedure ExtractAbsoluteItem(AItem: TdxCustomLayoutItem);
    function IsRoot(AItem: TdxCustomLayoutItem): Boolean;
    function IsRootStored: Boolean; virtual;
    function IsSizableHorz: Boolean; virtual;
    function IsSizableVert: Boolean; virtual;
    procedure SetDefaultItemName(AItem: TdxCustomLayoutItem); virtual;

    procedure DoInitialize; virtual;
    function IsAutoControlAlignment: Boolean; virtual;
    function IsAutoControlTabOrders: Boolean; virtual;
    function IsFocusControlOnItemCaptionClick: Boolean; virtual;
    procedure Initialize;

    // focus/keyboard
    procedure SetFocus;
    function GetMaxTabOrder: Integer;
    procedure KillFocus;
    // focus/keyboard
    function FindFocusedItem: TdxCustomLayoutItem;
    function ProcessDialogChar(ACharCode: Word): Boolean; virtual;
    function ProcessDialogKey(ACharCode: Word; AKeyData: Integer): Boolean; virtual;
    procedure CalculateTabOrders;

    procedure BiDiModeChanged; virtual;
    function CreateItemSelectorHelper(AItem: TdxLayoutItem): TdxControlsDesignSelectorHelper; virtual;
    function GetCanvas: TcxCanvas; virtual;
    function GetClientBounds: TRect; virtual;
    function GetClientRect: TRect; virtual;
    function GetItemsOwner: TComponent; virtual;
    function GetItemsParentComponent: TComponent; virtual;
    function GetItemsParentControl: TcxControl; virtual;
    function GetOccupiedClientHeight: Integer;
    function GetOccupiedClientWidth: Integer;
    function GetScrollOffset: TPoint; virtual;
    function IsTransparent: Boolean; virtual;
    function IsTransparentBackground: Boolean; virtual;
    procedure MakeVisible(const ARect: TRect; AFully: Boolean); virtual;
    procedure SizeAdjustment; virtual;
    procedure DoGroupScroll(Sender: TObject); virtual;

    procedure DoEnter; virtual;
    procedure DoExit; virtual;

    // conditions
    function AllowWrapItems: Boolean; virtual;
    function IsEditorMode: Boolean;
    function IsShowLockedGroupChildren: Boolean; virtual;
    function IsViewInfoValid: Boolean;
    function UseRightToLeftAlignment: Boolean; virtual;

    // font
    function GetBoldFont: TFont; virtual;
    function GetDefaultFont: TFont; virtual; abstract;
    procedure UnregisterFonts; virtual;

    property AbsoluteItemList: TcxComponentList read FAbsoluteItems;
    property AllowGroupWrapItems: Boolean read FAllowGroupWrapItems write SetAllowGroupWrapItems;
    property AllowOptimizeWrappedItems: Boolean read FAllowOptimizeWrappedItems write FAllowOptimizeWrappedItems;
    property AllowRename: Boolean read FAllowRename write FAllowRename;
    property CustomizationHelper: TdxLayoutContainerCustomizationHelper read FCustomizationHelper;
    property FloatContainers: TcxComponentList read FFloatContainers;
    property FocusController: TdxLayoutContainerFocusController read FFocusController;
    property IsDesignSelectorsVisible: Boolean read GetIsDesignSelectorsVisible;
    property IsOnGlass: Boolean read GetIsOnGlass;
    property IsRestoring: Boolean read FIsRestoring write SetIsRestoring;
    property IsStoringNameMode: Boolean read GetIsStoringNameMode;
    property ItemsOwner: TComponent read GetItemsOwner;
    property ItemsParentComponent: TComponent read GetItemsParentComponent; 
    property ItemsParentControl: TcxControl read GetItemsParentControl; 
    property ManagedItemCount: Integer read GetManagedItemCount;
    property ManagedItemList: TcxComponentList read GetManagedItemList;
    property ManagedItems[Index: Integer]: TdxCustomLayoutItem read GetManagedItem;
    property MasterContainer: TdxLayoutContainer read FMasterContainer write FMasterContainer;
    property MenuItems: TdxLayoutCustomizeFormMenuItems read FMenuItems write FMenuItems;
    property Painter: TdxLayoutContainerPainter read FPainter;
    property QuickCustomization: Boolean read FQuickCustomization write SetQuickCustomization;
    property RenamingItem: TdxCustomLayoutItem read FRenamingItem write SetRenamingItem;
    property RealContainer: TdxLayoutContainer read GetRealContainer;
    property ScaleFactor: TdxScaleFactor read GetScaleFactor;
    property SelectionHelper: IdxLayoutDesignerHelper read GetSelectionHelper;
    property ShowQuickCustomizationToolbar: Boolean read FShowQuickCustomizationToolbar write FShowQuickCustomizationToolbar;
    property StoredVersion: Integer read FStoredVersion;
    property OnItemChanged: TdxLayoutItemChangedEvent read FOnItemChanged write SetOnItemChanged;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure GetTabOrderList(List: TList);
    procedure Modified; virtual;

    procedure BeginUpdate;
    procedure CancelUpdate;
    procedure EndUpdate(ANeedPack: Boolean = True);
    procedure BeginTranslation;
    procedure EndTranslation;
    procedure BeginDragAndDrop; virtual;
    function CanDragAndDrop: Boolean; virtual;
    procedure FinishDragAndDrop(Accepted: Boolean); virtual;

    function GetHitTest: TdxCustomLayoutHitTest; overload;
    function GetHitTest(const P: TPoint): TdxCustomLayoutHitTest; overload;
    function GetHitTest(X, Y: Integer): TdxCustomLayoutHitTest; overload;

    function ClientToScreen(const Point: TPoint): TPoint;
    function ScreenToClient(const Point: TPoint): TPoint;

    procedure CancelLastUndo;
    procedure SaveToUndo;

    function IsDesigning: Boolean;
    function IsDestroying: Boolean;
    function IsGlobalLoading: Boolean;
    function IsGlobalDestroying: Boolean;
    function IsLoading: Boolean;
    function IsUpdateLocked: Boolean;
    function IsTranslating: Boolean;

    procedure CustomizeFormUpdate(AUpdateTypes: TdxLayoutCustomizeFormUpdateTypes);
    procedure InvalidateRect(const R: TRect; EraseBackground: Boolean);
    procedure Redraw(const R: TRect; AFlags: Integer = 0);
    procedure Update;

    procedure CheckItemNames(const AOldName, ANewName: string); virtual;
    procedure Clear;
    function CloneItem(AItem: TdxCustomLayoutItem; AParent: TdxCustomLayoutGroup = nil): TdxCustomLayoutItem; virtual;
    function CreateAlignmentConstraint: TdxLayoutAlignmentConstraint;
    function CreateGroup: TdxLayoutGroup; overload;
    function CreateGroup(AGroupClass: TdxCustomLayoutGroupClass; AParent: TdxCustomLayoutGroup = nil): TdxCustomLayoutGroup; overload;
    function CreateItem(AItemClass: TdxCustomLayoutItemClass = nil; AParent: TdxCustomLayoutGroup = nil): TdxCustomLayoutItem;
    function CreateItemForControl(AControl: TControl; AParent: TdxCustomLayoutGroup = nil): TdxLayoutItem;
    function FindItem(AControl: TControl): TdxLayoutItem; overload;
    function FindItem(AControlHandle: THandle): TdxLayoutItem; overload;
    function FindItem(const AName: string): TdxCustomLayoutItem; overload;

    procedure RestoreFromIniFile(const AStorageName: string; const ARestoreName: string = '');
    procedure RestoreFromRegistry(const AStorageName: string; const ARestoreName: string = '');
    procedure RestoreFromStream(AStream: TStream; const ARestoreName: string = '');
    procedure RestoreFromStorage(const AStorageName: string; AReaderClass: TcxCustomReaderClass;
      const ARestoreName: string = '');
    procedure StoreToIniFile(const AStorageName: string; AReCreate: Boolean = True; const ASaveName: string = '');
    procedure StoreToRegistry(const AStorageName: string; AReCreate: Boolean = True; const ASaveName: string = '');
    procedure StoreToStream(AStream: TStream; const ASaveName: string = '');
    procedure StoreToStorage(const AStorageName: string; AWriterClass: TcxCustomWriterClass;
      AReCreate: Boolean = True; const ASaveName: string = '');

    property Customization: Boolean read GetCustomization write SetCustomization;
    property CustomizeAvailableItemsViewKind: TdxLayoutAvailableItemsViewKind read FCustomizeAvailableItemsViewKind write SetCustomizeAvailableItemsViewKind;
    property CustomizeForm: TdxLayoutControlCustomCustomizeForm read GetCustomizeForm;
    property CustomizeFormBounds: TRect read FCustomizeFormBounds write FCustomizeFormBounds;
    property CustomizeFormClass: TdxLayoutControlCustomCustomizeFormClass read FCustomizeFormClass write FCustomizeFormClass;
    property CustomizeFormTabbedView: Boolean read FCustomizeFormTabbedView write SetCustomizeFormTabbedView;
    property DragDropMode: TdxLayoutDragDropMode read GetDragDropMode write FDragDropMode;
    property HighlightRoot: Boolean read FHighlightRoot write SetHighlightRoot;
    property ImageOptions: TdxLayoutImageOptions read FImageOptions write SetImageOptions;
    property LayoutLookAndFeel: TdxCustomLayoutLookAndFeel read FLayoutLookAndFeel write SetLayoutLookAndFeel;
    property ShowDesignSelectors: Boolean read FShowDesignSelectors write SetShowDesignSelectors;

    property ClientBounds: TRect read GetClientBounds;
    property ClientRect: TRect read GetClientRect;
    property ItemsParent: TcxControl read GetItemsParentControl; 
    property UndoRedoManager: TdxUndoRedoManager read FUndoRedoManager;
    property ViewInfo: TdxLayoutContainerViewInfo read FViewInfo;

    property AlignmentConstraintCount: Integer read GetAlignmentConstraintCount;
    property AlignmentConstraints[Index: Integer]: TdxLayoutAlignmentConstraint read GetAlignmentConstraint;
    property AbsoluteItemCount: Integer read GetAbsoluteItemCount;
    property AbsoluteItems[Index: Integer]: TdxCustomLayoutItem read GetAbsoluteItem;
    property AvailableItemCount: Integer read GetAvailableItemCount;
    property AvailableItems[Index: Integer]: TdxCustomLayoutItem read GetAvailableItem;
    property Root: TdxLayoutGroup read FRoot;
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
    property OnSelectionChanged: TNotifyEvent read FOnSelectionChanged write FOnSelectionChanged;
  end;
  TdxLayoutContainerClass = class of TdxLayoutContainer;

  { hit tests }

  TdxCustomLayoutHitTestClass = class of TdxCustomLayoutHitTest;

  TdxCustomLayoutHitTest = class
  private
    FItem: TdxCustomLayoutItem;
    FViewInfo: TdxCustomLayoutItemViewInfo;
    FPos: TPoint;
  public
    function CanDragAndDrop(AItem: TdxCustomLayoutItem; const P: TPoint): Boolean; virtual;
    function GetCursor: TCursor; dynamic;
    function GetDropCursor: TCursor; dynamic;
    function GetDragAndDropObjectClass: TcxDragAndDropObjectClass; virtual;
    function HitTestCode: Integer; virtual;
    class function Instance: TdxCustomLayoutHitTest;
    function IsDropAreaPartDetermined: Boolean; virtual;
    function GetDropAreaPart: TdxLayoutDropAreaPart; virtual;
    function GetGroupForInsert: TdxCustomLayoutGroup; virtual;

    function GetDestinationItem: TdxCustomLayoutItem; virtual;
    function GetSourceItem: TdxCustomLayoutItem; virtual;

    property Item: TdxCustomLayoutItem read FItem write FItem;
    property ViewInfo: TdxCustomLayoutItemViewInfo read FViewInfo write FViewInfo; // for internal use
    property Pos: TPoint read FPos write FPos;
  end;

  TdxCustomLayoutItemHitTest = class(TdxCustomLayoutHitTest);

  TdxLayoutNoneHitTest = class(TdxCustomLayoutHitTest)
  public
    function HitTestCode: Integer; override; 
  end;

  TdxCustomLayoutItemHitTestClass = class of TdxCustomLayoutItemHitTest;

  TdxLayoutBasicItemHitTest = class(TdxCustomLayoutItemHitTest)
  private
    function GetItem: TdxLayoutBasicItem;
  public
    function HitTestCode: Integer; override; 
    function GetGroupForInsert: TdxCustomLayoutGroup; override; 

    property Item: TdxLayoutBasicItem read GetItem;
  end;

  TdxLayoutItemHitTest = class(TdxLayoutBasicItemHitTest)
  private
    function GetItem: TdxLayoutItem;
  public
    function HitTestCode: Integer; override; 

    property Item: TdxLayoutItem read GetItem;
  end;

  TdxLayoutGroupHitTest = class(TdxCustomLayoutItemHitTest)
  private
    function GetItem: TdxCustomLayoutGroup;
    function GetViewInfo: TdxLayoutGroupViewInfo;
  public
    function HitTestCode: Integer; override; 
    function GetGroupForInsert: TdxCustomLayoutGroup; override; 

    property Item: TdxCustomLayoutGroup read GetItem;
    property ViewInfo: TdxLayoutGroupViewInfo read GetViewInfo; // for internal use
  end;

  TdxLayoutTabbedGroupHitTest = class(TdxLayoutGroupHitTest)
  private
    function GetSpecific: TdxLayoutGroupViewInfoTabbedSpecific;
  protected
    property Specific: TdxLayoutGroupViewInfoTabbedSpecific read GetSpecific;
  public
    function GetDestinationItem: TdxCustomLayoutItem; override;
    function GetSourceItem: TdxCustomLayoutItem; override;
  end;

  TdxLayoutFloatingRootHitTest = class(TdxLayoutGroupHitTest)
  public
    function GetSourceItem: TdxCustomLayoutItem; override;
  end;

  TdxLayoutClientAreaHitTest = class(TdxCustomLayoutHitTest)
  private
    FContainer: TdxLayoutContainer;
  public
    function HitTestCode: Integer; override; 
    function GetGroupForInsert: TdxCustomLayoutGroup; override; 
    function GetDestinationItem: TdxCustomLayoutItem; override;

    property Container: TdxLayoutContainer read FContainer write FContainer;
  end;

  TdxLayoutSizeHitTest = class(TdxCustomLayoutItemHitTest)
  private
    FCursor: TCursor;
  protected
    property Cursor: TCursor read FCursor write FCursor;
  public
    function HitTestCode: Integer; override; 
    function GetCursor: TCursor; override;
    function GetDragAndDropObjectClass: TcxDragAndDropObjectClass; override;
  end;

  TdxLayoutSplitterHitTest = class(TdxCustomLayoutItemHitTest)
  public
    function CanDragAndDrop(AItem: TdxCustomLayoutItem; const P: TPoint): Boolean; override;
    function HitTestCode: Integer; override; 
    function GetCursor: TCursor; override;
    function GetDragAndDropObjectClass: TcxDragAndDropObjectClass; override;
  end;

  TdxLayoutCustomizeFormHitTest = class(TdxCustomLayoutHitTest)
  private
    FDropAreaPart: TdxLayoutDropAreaPart;
    FContainer: TdxLayoutContainer;
  protected
    FHitTestArea: Integer;
  public
    function GetDropCursor: TCursor; override;

    function HitTestCode: Integer; override; 
    function IsDropAreaPartDetermined: Boolean; override;
    function GetDropAreaPart: TdxLayoutDropAreaPart; override;
    function GetDestinationItem: TdxCustomLayoutItem; override;

    property DropAreaPart: TdxLayoutDropAreaPart read FDropAreaPart write FDropAreaPart;
    property Container: TdxLayoutContainer read FContainer write FContainer;
  end;

  TdxLayoutCustomizeFormAvailableItemsHitTest = class(TdxLayoutCustomizeFormHitTest)
  public
    function HitTestCode: Integer; override; 
  end;

  TdxLayoutCustomizeFormTreeViewItemsHitTest = class(TdxLayoutCustomizeFormHitTest)
  public
    function HitTestCode: Integer; override; 
  end;

  { Painters }

  { TdxCustomLayoutElementPainter }

  TdxCustomLayoutElementPainter = class
  private
    FViewInfo: TdxCustomLayoutElementViewInfo;
  protected
    property ViewInfo: TdxCustomLayoutElementViewInfo read FViewInfo;
  public
    constructor Create(AViewInfo: TdxCustomLayoutElementViewInfo); virtual;
    destructor Destroy; override;
    procedure Paint(ACanvas: TcxCanvas); virtual;
  end;

  { TdxCustomLayoutItemElementPainter }

  TdxCustomLayoutItemElementPainter = class(TdxCustomLayoutElementPainter)
  private
    function GetLayoutLookAndFeel: TdxCustomLayoutLookAndFeel;
    function GetLookAndFeel: TcxLookAndFeel;
    function GetViewInfo: TdxCustomLayoutItemElementViewInfo;
  protected
    property LayoutLookAndFeel: TdxCustomLayoutLookAndFeel read GetLayoutLookAndFeel;
    property LookAndFeel: TcxLookAndFeel read GetLookAndFeel;
    property ViewInfo: TdxCustomLayoutItemElementViewInfo read GetViewInfo;
  end;

  TdxCustomLayoutItemCaptionPainter = class(TdxCustomLayoutItemElementPainter)
  private
    function GetViewInfo: TdxCustomLayoutItemCaptionViewInfo;
  protected
    function DrawEnabled: Boolean; virtual;
    function GetTextRect: TRect; virtual;

    procedure DoDrawFormattedText(ACanvas: TcxCanvas; ARect: TRect);
    procedure DoDrawText(ACanvas: TcxCanvas); virtual;
    procedure DoDrawGlyph(ACanvas: TcxCanvas); virtual;

    procedure DoPaint(ACanvas: TcxCanvas); virtual;

    procedure DrawBackground(ACanvas: TcxCanvas); virtual;
    procedure DrawGlyph(ACanvas: TcxCanvas);
    procedure DrawText(ACanvas: TcxCanvas);
    property ViewInfo: TdxCustomLayoutItemCaptionViewInfo read GetViewInfo;
  public
    procedure Paint(ACanvas: TcxCanvas); override;
  end;

  TdxLayoutGroupCaptionPainter = class(TdxCustomLayoutItemCaptionPainter);
  TdxLayoutControlItemCaptionPainter = class(TdxCustomLayoutItemCaptionPainter);
  TdxLayoutItemCaptionPainter = class(TdxLayoutControlItemCaptionPainter);

  TdxCustomLayoutCheckableItemCaptionPainter = class(TdxLayoutItemCaptionPainter)
  protected
    function GetTextRect: TRect; override;
  end;

  TdxCustomLayoutItemPainter = class(TdxCustomLayoutElementPainter)
  private
    function GetLayoutLookAndFeel: TdxCustomLayoutLookAndFeel;
    function GetLookAndFeel: TcxLookAndFeel;
    function GetViewInfo: TdxCustomLayoutItemViewInfo;
  protected
    function GetCaptionPainterClass: TdxCustomLayoutItemCaptionPainterClass; virtual; abstract;

    procedure DoDrawBackground(ACanvas: TcxCanvas); virtual;
    procedure DoDrawCaption(ACanvas: TcxCanvas); virtual;
    procedure DoDrawSpecificPart(ACanvas: TcxCanvas); virtual;

    procedure DrawBackground(ACanvas: TcxCanvas); virtual;
    procedure DrawCaption(ACanvas: TcxCanvas); virtual;
    procedure DrawContent(ACanvas: TcxCanvas); virtual;
    procedure DrawItem(ACanvas: TcxCanvas);

    procedure DrawDragImageFrame(ACanvas: TcxCanvas); virtual;
    procedure DrawSpecificPart(ACanvas: TcxCanvas); virtual;
    procedure DrawDesignFeatures(ACanvas: TcxCanvas); virtual;

    function CanDrawBackground: Boolean; virtual;
    function CanDrawCaption: Boolean; virtual;
    function CanDrawSpecificPart: Boolean; virtual;

    function CanPaint: Boolean; virtual;

    property LayoutLookAndFeel: TdxCustomLayoutLookAndFeel read GetLayoutLookAndFeel;
    property LookAndFeel: TcxLookAndFeel read GetLookAndFeel;
    property ViewInfo: TdxCustomLayoutItemViewInfo read GetViewInfo;
  public
    procedure Paint(ACanvas: TcxCanvas); override;
    procedure PaintDragImage(ACanvas: TcxCanvas);
  end;

  { TdxLayoutControlItemControlPainter }

  TdxLayoutControlItemControlPainter = class(TdxCustomLayoutItemElementPainter)
  private
    function GetViewInfo: TdxLayoutControlItemControlViewInfo;
  protected
    procedure DrawBorders(ACanvas: TcxCanvas); virtual;
    property ViewInfo: TdxLayoutControlItemControlViewInfo read GetViewInfo;
  public
    procedure Paint(ACanvas: TcxCanvas); override;
  end;

  TdxLayoutItemControlPainter = class(TdxLayoutControlItemControlPainter);

  TdxLayoutBasicItemPainter = class(TdxCustomLayoutItemPainter);

  TdxLayoutEmptySpaceItemPainter = class(TdxLayoutBasicItemPainter)
  protected
    procedure DrawContent(ACanvas: TcxCanvas); override;
  end;

  TdxLayoutDirectionalItemPainter = class(TdxLayoutBasicItemPainter)
  protected
    procedure DrawContent(ACanvas: TcxCanvas); override;
    procedure DoDrawContent(ACanvas: TcxCanvas); virtual;
  end;

  TdxLayoutSplitterItemPainter = class(TdxLayoutDirectionalItemPainter)
  private
    function GetViewInfo: TdxLayoutSplitterItemViewInfo;
  protected
    procedure DoDrawContent(ACanvas: TcxCanvas); override;
    property ViewInfo: TdxLayoutSplitterItemViewInfo read GetViewInfo;
  end;

  TdxLayoutLabeledItemPainter = class(TdxLayoutBasicItemPainter)
  protected
    function CanDrawCaption: Boolean; override;

    function GetCaptionPainterClass: TdxCustomLayoutItemCaptionPainterClass; override;
  end;

  { TdxLayoutSeparatorItemPainter }

  TdxLayoutSeparatorItemPainter = class(TdxLayoutLabeledItemPainter)
  private
    function GetViewInfo: TdxLayoutSeparatorItemViewInfo;
  protected
    procedure DoDrawContent(ACanvas: TcxCanvas); virtual;
    procedure DrawContent(ACanvas: TcxCanvas); override;

    property ViewInfo: TdxLayoutSeparatorItemViewInfo read GetViewInfo;
  end;

  TdxLayoutImageItemPainter = class(TdxLayoutLabeledItemPainter)
  private
    function GetViewInfo: TdxLayoutImageItemViewInfo;
  protected
    procedure DrawContent(ACanvas: TcxCanvas); override;
    procedure DrawContentImage(ACanvas: TcxCanvas);

    property ViewInfo: TdxLayoutImageItemViewInfo read GetViewInfo;
  end;

  TdxCustomLayoutCheckableItemPainter = class(TdxLayoutLabeledItemPainter)
    function GetCaptionPainterClass: TdxCustomLayoutItemCaptionPainterClass; override;
  end;

  { TdxLayoutCheckBoxItemPainter }

  TdxLayoutCheckBoxItemPainter = class(TdxCustomLayoutCheckableItemPainter)
  strict private
    function GetEditCheckState: TcxEditCheckState;
    function GetViewInfo: TdxLayoutCheckBoxItemViewInfo;
  protected
    procedure DrawContent(ACanvas: TcxCanvas); override;

    property ViewInfo: TdxLayoutCheckBoxItemViewInfo read GetViewInfo;
  end;

  { TdxLayoutRadioButtonItemPainter }

  TdxLayoutRadioButtonItemPainter = class(TdxCustomLayoutCheckableItemPainter)
  strict private
    function GetButtonState: TcxButtonState;
    function GetViewInfo: TdxLayoutRadioButtonItemViewInfo;
  protected
    procedure DrawContent(ACanvas: TcxCanvas); override;

    property ViewInfo: TdxLayoutRadioButtonItemViewInfo read GetViewInfo;
  end;

  TdxLayoutControlItemPainter = class(TdxLayoutLabeledItemPainter)
  private
    function GetViewInfo: TdxLayoutControlItemViewInfo;
  protected
    function CanDrawSpecificPart: Boolean; override;

    function GetCaptionPainterClass: TdxCustomLayoutItemCaptionPainterClass; override;
    function GetControlPainterClass: TdxLayoutControlItemControlPainterClass; virtual;

    procedure DoDrawControlBorder(ACanvas: TcxCanvas); virtual;

    procedure DrawContent(ACanvas: TcxCanvas); override;
    procedure DrawControlBorder(ACanvas: TcxCanvas); virtual;

    property ViewInfo: TdxLayoutControlItemViewInfo read GetViewInfo;
  end;

  TdxLayoutItemPainter = class(TdxLayoutControlItemPainter)
  private
    function GetViewInfo: TdxLayoutItemViewInfo;
  protected
    function GetCaptionPainterClass: TdxCustomLayoutItemCaptionPainterClass; override;
    function GetControlPainterClass: TdxLayoutControlItemControlPainterClass; override;

    procedure DoDrawSpecificPart(ACanvas: TcxCanvas); override;

    property ViewInfo: TdxLayoutItemViewInfo read GetViewInfo;
  end;

  { TdxLayoutGroupButtonPainter }

  TdxLayoutGroupButtonPainter = class(TdxCustomLayoutItemElementPainter)
  strict private
    function GetScaleFactor: TdxScaleFactor;
    function GetViewInfo: TdxLayoutGroupButtonViewInfo;
  protected
    function CreateInternalGlyph(APainter: TcxCustomLookAndFeelPainter): TcxBitmap32;
    procedure DrawButton(ACanvas: TcxCanvas; APainter: TcxCustomLookAndFeelPainter; AGlyph: TGraphic);

    property ScaleFactor: TdxScaleFactor read GetScaleFactor;
    property ViewInfo: TdxLayoutGroupButtonViewInfo read GetViewInfo;
  public
    procedure Paint(ACanvas: TcxCanvas); override;
  end;

  { TdxLayoutGroupCheckBoxButtonPainter }

  TdxLayoutGroupCheckBoxButtonPainter = class(TdxLayoutGroupButtonPainter)
  public
    procedure Paint(ACanvas: TcxCanvas); override;
  end;

  { TdxLayoutGroupPainter }

  TdxLayoutGroupPainter = class(TdxCustomLayoutItemPainter)
  private
    function GetViewInfo: TdxLayoutGroupViewInfo;
  protected
    function GetCaptionPainterClass: TdxCustomLayoutItemCaptionPainterClass; override;

    procedure DrawContent(ACanvas: TcxCanvas); override;

    function CanDrawBorders: Boolean; virtual;
    function CanDrawSpecificControls: Boolean; virtual;
    function HasCaptionBackground: Boolean; virtual;

    procedure DoDrawBorders(ACanvas: TcxCanvas); virtual;
    procedure DoDrawButtons(ACanvas: TcxCanvas); virtual;
    procedure DoDrawSpecificControls(ACanvas: TcxCanvas); virtual;

    procedure DrawBorders(ACanvas: TcxCanvas); virtual;
    procedure DrawButtons(ACanvas: TcxCanvas); virtual;
    procedure DrawItems(ACanvas: TcxCanvas); virtual;
    procedure DrawItemsArea(ACanvas: TcxCanvas); virtual;
    procedure DrawSpecificControls(ACanvas: TcxCanvas);
    procedure DrawSpecificPart(ACanvas: TcxCanvas); override;
    procedure DrawDesignFeatures(ACanvas: TcxCanvas); override;

    property ViewInfo: TdxLayoutGroupViewInfo read GetViewInfo;
  end;

  { TdxLayoutContainerPainter }

  TdxLayoutContainerPainter = class
  private
    FViewInfo: TdxLayoutContainerViewInfo;
    FPlaceControlsCounter: Integer;
    function GetContainer: TdxLayoutContainer;
  protected
    procedure DrawDesignFeatures(ACanvas: TcxCanvas); virtual;
    procedure DrawItems(ACanvas: TcxCanvas); virtual;
    procedure PlaceControls(AItemViewInfo: TdxCustomLayoutItemViewInfo; AProcessWinControls: Boolean = True; AAdditionalFlags: Integer = 0);

    property Container: TdxLayoutContainer read GetContainer;
  public
    constructor Create(AViewInfo: TdxLayoutContainerViewInfo); virtual;
    procedure Paint(ACanvas: TcxCanvas); virtual;

    property ViewInfo: TdxLayoutContainerViewInfo read FViewInfo;
  end;

  { ViewInfos }

  { TdxCustomLayoutElementViewInfo }

  TdxLayoutElementViewInfoState = (levsHot, levsPressed);
  TdxLayoutElementViewInfoStates = set of TdxLayoutElementViewInfoState;

  TdxCustomLayoutElementViewInfo = class(TcxIUnknownObject)
  strict private
    FBounds: TRect;
  private
    FIsOnGlass: Boolean;
    FOffset: TPoint;
    FOriginalBounds: TRect;
    FPadding: TRect;
    FIsPaddingCalculated: Boolean;
    FState: TdxLayoutElementViewInfoStates;
    function GetLookAndFeel: TcxLookAndFeel;
    function GetPadding: TRect;
    procedure SetOffset(const Value: TPoint);
    procedure SetState(AValue: TdxLayoutElementViewInfoStates);
  protected
    function GetLayoutLookAndFeel: TdxCustomLayoutLookAndFeel; virtual; abstract;
    function UseRightToLeftAlignment: Boolean; virtual; abstract;

    function CalculatePadding: TRect; virtual;
    function GetEnabled: Boolean; virtual;
    function GetIsCustomization: Boolean; virtual;
    function IsHotTrackable: Boolean; virtual;
    procedure StateChanged; virtual;

    procedure AssignBounds(ASource: TdxCustomLayoutElementViewInfo);
    function CanAssignBounds(ASource: TdxCustomLayoutElementViewInfo): Boolean; virtual;
    procedure DoRightToLeftConversion(const AClientBounds: TRect); virtual;
    procedure DoAssignBounds(ASource: TdxCustomLayoutElementViewInfo); virtual;
    procedure DoSetOffset(const AValue, ADiff: TPoint); virtual;
    procedure Reset; virtual;
    procedure SetBounds(const ARect: TRect; AOriginal: Boolean = True);

    procedure KeyDown(var Key: Word; Shift: TShiftState); virtual;
    function CanFocusOnClick(X, Y: Integer): Boolean; virtual;
    procedure MouseEnter; virtual;
    procedure MouseLeave; virtual;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); virtual;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;

    property IsCustomization: Boolean read GetIsCustomization;
    property IsOnGlass: Boolean read FIsOnGlass write FIsOnGlass;
    property LookAndFeel: TcxLookAndFeel read GetLookAndFeel;
    property OriginalBounds: TRect read FOriginalBounds;
    property Offset: TPoint read FOffset write SetOffset;
    property Padding: TRect read GetPadding;
    property State: TdxLayoutElementViewInfoStates read FState write SetState;
  public
    procedure Calculate(const ABounds: TRect); virtual;

    property Bounds: TRect read FBounds;
    property Enabled: Boolean read GetEnabled;
    property LayoutLookAndFeel: TdxCustomLayoutLookAndFeel read GetLayoutLookAndFeel;
  end;

  { TdxCustomLayoutItemElementViewInfo }

  TdxCustomLayoutItemElementViewInfo = class(TdxCustomLayoutElementViewInfo)
  private
    FItemViewInfo: TdxCustomLayoutItemViewInfo;
    FHeight: Integer;
    FWidth: Integer;

    function GetItem: TdxCustomLayoutItem;
    function GetHeight: Integer;
    function GetWidth: Integer;
    procedure SetHeight(Value: Integer);
    procedure SetWidth(Value: Integer);
  protected
    procedure DoAssignBounds(ASource: TdxCustomLayoutElementViewInfo); override;
    function GetEnabled: Boolean; override;
    function GetIsCustomization: Boolean; override;
    function GetLayoutLookAndFeel: TdxCustomLayoutLookAndFeel; override;
    function UseRightToLeftAlignment: Boolean; override;
    procedure Reset; override;

    procedure CalculateExactBounds(const AAvailableBounds: TRect); virtual;
    function GetLayoutAlignHorz: TdxLayoutRealAlignHorz; virtual;
    function GetLayoutAlignVert: TdxLayoutRealAlignVert; virtual;
    function GetCursor(X, Y: Integer): TCursor; virtual;
    function GetVisible: Boolean; virtual;
    procedure Invalidate(const ABounds: TRect); virtual;

    function AllowDragDrop: Boolean; virtual;
    function WantsMouse(X, Y: Integer): Boolean; virtual;

    function ShowHint(var AHintInfo: THintInfo): Boolean; virtual;

    property Item: TdxCustomLayoutItem read GetItem;
    property ItemViewInfo: TdxCustomLayoutItemViewInfo read FItemViewInfo;
    property Visible: Boolean read GetVisible;
  public
    constructor Create(AItemViewInfo: TdxCustomLayoutItemViewInfo); virtual;
    destructor Destroy; override;

    function CalculateMinHeight: Integer; virtual;
    function CalculateMinWidth: Integer; virtual;
    function CalculateHeight: Integer; virtual;
    function CalculateWidth: Integer; virtual;

    property LayoutAlignHorz: TdxLayoutRealAlignHorz read GetLayoutAlignHorz;
    property LayoutAlignVert: TdxLayoutRealAlignVert read GetLayoutAlignVert;
    property Height: Integer read GetHeight write SetHeight;
    property Width: Integer read GetWidth write SetWidth;
  end;

  TdxTextSizeCache = record
    TextAreaWidth: Integer;
    TextSize: TSize;
    OptimalTextSize: TSize;
  end;

  TdxCustomLayoutItemCaptionViewInfo = class(TdxCustomLayoutItemElementViewInfo)
  private
    FEllipsisPosition: TEllipsisPosition;
    FIsImageVisible: TdxDefaultBoolean;
    FIsTextVisible: TdxDefaultBoolean;
    FHotTracked: Boolean;
    FTextLayout: TdxCaptionLayout;
    FTextSizeCache: TdxTextSizeCache;
    FWordWrap: Boolean;

    function GetCanvas: TcxCanvas;
    function GetFormattedText: TdxFormattedText;
    function GetVisibleText: string;
    procedure SetHotTracked(Value: Boolean);
  protected type
    TdxPreparedCanvasTextPlaceSizeFunc = function (ACanvas: TcxCanvas): TSize of object;
  protected
    FTextAreaBounds: TRect;
    FImageAreaBounds: TRect;

    function GetCursor(X, Y: Integer): TCursor; override;
    function GetVisible: Boolean; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseLeave; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    function ShowHint(var AHintInfo: THintInfo): Boolean; override;

    procedure StateChanged; override;
    function IsHotTrackable: Boolean; override;
    procedure DoRightToLeftConversion(const AClientBounds: TRect); override;

    function CalculateTextFlags(ACanvas: TcxCanvas; AForDrawing: Boolean = True): Integer; virtual;
    procedure PrepareCanvas(ACanvas: TcxCanvas; AForDrawing: Boolean); virtual;

    function GetLayoutAlignHorz: TdxLayoutRealAlignHorz; override;
    function GetLayoutAlignVert: TdxLayoutRealAlignVert; override;
    function GetContentOffsetSize: TSize; virtual;
    function GetImageSize: TSize;
    function GetImageHeight: Integer;
    function GetImageWidth: Integer;
    procedure AdjustTextAreaBounds(var R: TRect);
    procedure CalculateFormattedText(AFormattedText: TdxFormattedText; const AFlags: Integer; const ARect: TRect;
      ACanvas: TCanvas; const AForDrawing: Boolean);
    procedure CalculateImageTextAreaBounds; virtual;
    function GetColor: TColor; virtual;
    function GetFont: TFont; virtual;
    function GetFormattedTextSize(ACanvas: TcxCanvas; const AFlags: Integer; const ARect: TRect): TSize;
    function GetHotTrackBounds: TRect; virtual;
    function GetHotTrackStyles: TdxLayoutHotTrackStyles; virtual;
    function GetText: string; virtual;
    function GetTextColor: TColor; virtual;
    function GetTextDisabledColor: TColor; virtual;
    function GetTextHotColor: TColor; virtual;
    function GetTextNormalColor: TColor; virtual;
    // Text size
    function GetOptimalTextSize(ACanvas: TcxCanvas): TSize;
    function GetOptimalTextPlaceSize: TSize;
    function GetTextAreaWidth: Integer; virtual;
    function GetTextPadding: TdxPadding; virtual;
    function GetTextPlaceSize: TSize;
    function GetTextPlaceSizeFromTextSize(ASizeFunc: TdxPreparedCanvasTextPlaceSizeFunc): TSize;
    function GetTextSize(ACanvas: TcxCanvas): TSize; virtual;
    // Common
    function GetTextAlignHorz: TAlignment; virtual;
    function GetTextAlignVert: TdxAlignmentVert; virtual;
    function GetOptions: TdxLayoutLookAndFeelCaptionOptions; virtual;
    function GetRotationAngle: TcxRotationAngle; virtual;
    function GetSpaceBetweenImageText: Integer; virtual;

    procedure DoSetOffset(const AValue, ADiff: TPoint); override;
    function GetContentOffsets: TRect; virtual;

    procedure DoAssignBounds(ASource: TdxCustomLayoutElementViewInfo); override;

    function CanDoCaptionClick(X, Y: Integer): Boolean; virtual;
    function IsEllipsisAllowed(AForDrawing: Boolean = False): Boolean; virtual;
    function IsWidthFixed: Boolean; virtual;
    function IsMultiLine: Boolean; virtual;
    function IsNeedSpaceBetweenImageText: Boolean;
    function IsPointInHotTrackBounds(const P: TPoint): Boolean; virtual;
    function IsTextFormatted: Boolean;
    function IsTextUnderlined: Boolean; virtual;

    property Canvas: TcxCanvas read GetCanvas;
    property FormattedText: TdxFormattedText read GetFormattedText;
    property HotTrackBounds: TRect read GetHotTrackBounds;
    property HotTrackStyles: TdxLayoutHotTrackStyles read GetHotTrackStyles;
  public
    constructor Create(AItemViewInfo: TdxCustomLayoutItemViewInfo); override;
    procedure Calculate(const ABounds: TRect); override;

    function CalculateHeight: Integer; override;
    function CalculateWidth: Integer; override;

    function IsImageVisible: Boolean;
    function IsTextVisible: Boolean;

    property AlignHorz: TAlignment read GetTextAlignHorz;
    property AlignVert: TdxAlignmentVert read GetTextAlignVert;
    property Color: TColor read GetColor;
    property EllipsisPosition: TEllipsisPosition read FEllipsisPosition;
    property Font: TFont read GetFont;
    property HotTracked: Boolean read FHotTracked write SetHotTracked;
    property ImageAreaBounds: TRect read FImageAreaBounds;
    property ImageHeight: Integer read GetImageHeight;
    property ImageWidth: Integer read GetImageWidth;
    property Options: TdxLayoutLookAndFeelCaptionOptions read GetOptions;
    property Text: string read GetText;
    property TextAreaBounds: TRect read FTextAreaBounds;
    property TextColor: TColor read GetTextColor;
    property TextLayout: TdxCaptionLayout read FTextLayout;
    property VisibleText: string read GetVisibleText;
    property WordWrap: Boolean read FWordWrap;
  end;
  TdxCustomLayoutItemCaptionViewInfoClass = class of TdxCustomLayoutItemCaptionViewInfo;

  TdxCustomLayoutItemViewData = class
  private
    FItem: TdxCustomLayoutItem;
    FNotifyComponent: TcxFreeNotificator;
    FOwner: TdxLayoutItemViewDataList;
    FViewInfo: TdxCustomLayoutItemViewInfo;

    procedure FreeNotification(AComponent: TComponent);
  protected
    procedure Changed; virtual;
    function GetSize: Integer; virtual;
    function ReadBoolean(AStream: TStream): Boolean;
    procedure WriteBoolean(AStream: TStream; AValue: Boolean);

    property ViewInfo: TdxCustomLayoutItemViewInfo read FViewInfo write FViewInfo;
  public
    constructor Create(AOwner: TdxLayoutItemViewDataList; AItem: TdxCustomLayoutItem); virtual;
    destructor Destroy; override;
    procedure Assign(Source: TdxCustomLayoutItemViewData); virtual;

    procedure Calculate; virtual;

    procedure Load(AStream: TStream); virtual;
    procedure Save(AStream: TStream); virtual;

    property Item: TdxCustomLayoutItem read FItem;
    property Owner: TdxLayoutItemViewDataList read FOwner; // for internal use
    property Size: Integer read GetSize;
  end;
  TdxCustomLayoutItemViewDataClass = class of TdxCustomLayoutItemViewData;

  { TdxLayoutItemViewDataList }

  TdxLayoutItemViewDataList = class(TObjectList)
  private
    FOnChanged: TNotifyEvent;
    function GetItem(Index: TdxListIndex): TdxCustomLayoutItemViewData;
    procedure SetItem(Index: TdxListIndex; Value: TdxCustomLayoutItemViewData);
  protected
    procedure Changed;
  public
    property Items[Index: TdxListIndex]: TdxCustomLayoutItemViewData read GetItem write SetItem; default; // for internal use
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
  end;

  TdxLayoutCalcSizeType = (cstMin, cstSufficient, cstOriginal);

  TdxCustomLayoutItemViewInfo = class(TdxCustomLayoutElementViewInfo)
  private
    FCaptionViewInfo: TdxCustomLayoutItemCaptionViewInfo;
    FDestroyForbidden: Boolean;
    FHasCaption: TdxDefaultBoolean;
    FIsMaxWidth: Boolean;
    FOffsets: array[TdxLayoutSide] of Integer;
    FViewData: TdxCustomLayoutItemViewData;
    FContainerViewInfo: TdxLayoutContainerViewInfo;
    FParentViewInfo: TdxLayoutGroupViewInfo;
    FElementWithMouse: TdxCustomLayoutItemElementViewInfo;
    FTabOrder: Integer;
    FPainter: TdxCustomLayoutItemPainter;
    FWidth: Integer;
    FHeight: Integer;
    FMinWidth: Integer;
    FMinHeight: Integer;
    FLayoutLookAndFeel: TdxCustomLayoutLookAndFeel;

    function GetMaxHeight: Integer;
    function GetMaxWidth: Integer;
    function GetMinHeight: Integer;
    function GetMinWidth: Integer;
    function GetUsualHeight: Integer;
    function GetUsualWidth: Integer;
    function GetSufficientWidth: Integer;
    function GetSufficientHeight: Integer;

    function GetAlign: TdxLayoutRealAlign;
    function GetAlignHorz: TdxLayoutRealAlignHorz; inline;
    function GetAlignVert: TdxLayoutRealAlignVert; inline;
    function GetBackgroundBounds: TRect;
    function GetCanPaint: Boolean;
    function GetHasMouse: Boolean;
    function GetItem: TdxCustomLayoutItem; inline;
    function GetOffset(ASide: TdxLayoutSide): Integer;
    function GetOffsetsHeight: Integer;
    function GetOffsetsWidth: Integer;
    function GetSelected: Boolean;
    function GetSelectionArea: TRect;
    function GetSelectionBorderRect: TRect;
    function GetSelectableMarkers: TRects;
    procedure SetElementWithMouse(Value: TdxCustomLayoutItemElementViewInfo);
    procedure SetHasMouse(Value: Boolean);
    procedure SetOffset(ASide: TdxLayoutSide; Value: Integer);

    function CreateHitTest(AHitTestClass: TdxCustomLayoutItemHitTestClass; const P: TPoint): TdxCustomLayoutItemHitTest;
  protected
    FIsValid: Boolean;
    function CanAssignBounds(ASource: TdxCustomLayoutElementViewInfo): Boolean; override;
    procedure DoAssignBounds(ASource: TdxCustomLayoutElementViewInfo); override;
    procedure DoRightToLeftConversion(const AClientBounds: TRect); override;
    procedure DoSetOffset(const AValue, ADiff: TPoint); override;
    function GetIsCustomization: Boolean; override;
    function GetLayoutLookAndFeel: TdxCustomLayoutLookAndFeel; override;
    function UseRightToLeftAlignment: Boolean; override;
    procedure Reset; override;

    function AsGroupViewInfo: TdxLayoutGroupViewInfo;
    function AutoAlignControls: Boolean; virtual;
    procedure FreeNotification(AComponent: TComponent); virtual;
    procedure CreateViewInfos; virtual;
    procedure DestroyViewInfos; virtual;
    procedure GetElements(AElements: TList); virtual;
    procedure MakeVisible(const ARect: TRect; AFully: Boolean); virtual;
    procedure MakeFullyVisible;
    procedure PopulateAutoAlignControlList(AList: TList); virtual;
    procedure PopulateControlViewInfoList(AControls, AWinControls: TList); virtual;

    function CanDrawBackground: Boolean; virtual;
    function GetBackgroundColor: TColor; virtual;

    function GetCaptionViewInfoClass: TdxCustomLayoutItemCaptionViewInfoClass; virtual; abstract;
    function GetHitTestClass: TdxCustomLayoutItemHitTestClass; virtual; abstract;
    function GetPainterClass: TdxCustomLayoutItemPainterClass; virtual; abstract;

    function GetPainter: TdxCustomLayoutItemPainter;

    function CalculateOffset(ASide: TdxLayoutSide): Integer; virtual;
    function InternalCalculateHeight: Integer; virtual;
    function InternalCalculateWidth: Integer; virtual;
    function CalculateMinHeight: Integer;
    function CalculateMinWidth: Integer;
    function CalculateHeight: Integer;
    function CalculateWidth: Integer;
    function DoCalculateHeight(ACalcSizeType: TdxLayoutCalcSizeType): Integer; virtual;
    function DoCalculateWidth(ACalcSizeType: TdxLayoutCalcSizeType): Integer; virtual;
    function GetAvailableTextAreaWidth: Integer; virtual;
    function GetAvailableTextAreaWidthCorrection: Integer; virtual;
    procedure SetItemHeight(AHeight: Integer; ADirectAccess: Boolean); virtual;
    procedure SetItemWidth(AWidth: Integer; ADirectAccess: Boolean); virtual;

    function GetActuallyVisible: Boolean; virtual;
    function GetColor: TColor; virtual; abstract;
    function GetContentBounds: TRect;
    function GetCursor(X, Y: Integer): TCursor; virtual;
    function GetEnabled: Boolean; override;
    function GetFocusRect(ACanvas: TcxCanvas): TRect; virtual;
    function GetHitTestBounds: TRect; virtual;
    function GetOptions: TdxCustomLayoutLookAndFeelOptions;
    function GetMarkerIndex(AMarkers: TRects; const P: TPoint): Integer; overload;
    function GetMarkerIndex(const P: TPoint): Integer; overload;
    function GetSelectionBoundsOffset: Integer; virtual;
    procedure GetSelectionMarkers(out ASelectable, ANonSelectable: TRects);
    function GetVisibleBounds: TRect;
    function GetVisiblePart(const ARect: TRect): TRect;

    function GetDropAreaPart(var P: TPoint): TdxLayoutDropAreaPart; virtual;
    procedure CustomizationMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; virtual;
    function IsMouseWheelHandleNeeded(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; virtual;
    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure Invalidate(const ABounds: TRect); virtual;

    procedure PaintContent(ADestImage: TcxAlphaBitmap; ANeedDrawFrame, AExtractLayer: Boolean);
    procedure PaintSelection(ABitmap: TcxAlphaBitmap);
    procedure PaintLockedState(ABitmap: TcxAlphaBitmap);
    procedure PaintInvisibleState(ABitmap: TcxAlphaBitmap);
    procedure PaintSelectionLayer(ABitmap: TcxAlphaBitmap; var ADrawingRect: TRect); virtual;

    function ShowHint(var AHintInfo: THintInfo): Boolean; virtual;

    function GetMaxTabOrder: Integer; virtual;

    function CanInplaceRename: Boolean; virtual;
    procedure DoInplaceRename; virtual;
    procedure InplaceRename;
    function GetInplaceRenameBounds: TRect; virtual;

    function IsTransparentBackground: Boolean;
    function HasCaption: Boolean; virtual;  
    function HasBorder: Boolean; virtual;
    function IsAvailable: Boolean;
    function IsExpanded: Boolean; virtual;
    function IsFocused: Boolean; virtual;
    function IsParentExpanded: Boolean;
    function IsParentLocked: Boolean;
    function IsParentSelected: Boolean;
    function IsTransparent: Boolean; virtual;
    function IsDragged: Boolean;
    function IsDraggedWithParent: Boolean;
    function IsDragImagePainting: Boolean;
    function IsGrabbed: Boolean;
    function IsValid: Boolean;
    function IsVertical: Boolean;

    function IsEllipsisAllowed(AForDrawing: Boolean = False): Boolean; virtual;
    function IsHeightLimited: Boolean;
    function IsWidthLimited: Boolean; virtual;
    function IsWordWrapAllowed: Boolean; virtual;

    property ActuallyVisible: Boolean read GetActuallyVisible;
    property BackgroundBounds: TRect read GetBackgroundBounds;
    property CanPaint: Boolean read GetCanPaint; // todo: rename
    property ContentBounds: TRect read GetContentBounds;
    property HasMouse: Boolean read GetHasMouse write SetHasMouse;
    property ElementWithMouse: TdxCustomLayoutItemElementViewInfo read FElementWithMouse write SetElementWithMouse;
    property Item: TdxCustomLayoutItem read GetItem;
    property OffsetsHeight: Integer read GetOffsetsHeight;
    property OffsetsWidth: Integer read GetOffsetsWidth;
    property Options: TdxCustomLayoutLookAndFeelOptions read GetOptions;
    property TabOrder: Integer read FTabOrder write FTabOrder;
    property ViewData: TdxCustomLayoutItemViewData read FViewData;
  public
    constructor Create(AContainerViewInfo: TdxLayoutContainerViewInfo; AParentViewInfo: TdxLayoutGroupViewInfo;
      AViewData: TdxCustomLayoutItemViewData); virtual;
    destructor Destroy; override;
    procedure Calculate(const ABounds: TRect); override;
    procedure Recalculate;

    procedure CalculateInternalTabOrders(var AAvailableTabOrder: Integer); virtual;
    procedure CalculateTabOrders(var AAvailableTabOrder: Integer); virtual;
    function GetHitTest(const P: TPoint): TdxCustomLayoutHitTest; virtual;
    function GetItemWithMouse(const P: TPoint): TdxCustomLayoutItem; virtual;
    function GetMinWidthWithWrapItems: Integer;
    procedure ResetOffset(ASide: TdxLayoutSide);

    property Align: TdxLayoutRealAlign read GetAlign; // for internal use
    property AlignHorz: TdxLayoutRealAlignHorz read GetAlignHorz;
    property AlignVert: TdxLayoutRealAlignVert read GetAlignVert;
    property CaptionViewInfo: TdxCustomLayoutItemCaptionViewInfo read FCaptionViewInfo; // for internal use
    property Color: TColor read GetColor;
    property ContainerViewInfo: TdxLayoutContainerViewInfo read FContainerViewInfo; // for internal use
    property ParentViewInfo: TdxLayoutGroupViewInfo read FParentViewInfo; // for internal use

    property MaxWidth: Integer read GetMaxWidth;
    property MaxHeight: Integer read GetMaxHeight;
    property MinWidth: Integer read GetMinWidth;
    property MinHeight: Integer read GetMinHeight;
    property UsualWidth: Integer read GetUsualWidth;
    property UsualHeight: Integer read GetUsualHeight;
    property SufficientWidth: Integer read GetSufficientWidth;
    property SufficientHeight: Integer read GetSufficientHeight;

    property Offsets[ASide: TdxLayoutSide]: Integer read GetOffset write SetOffset;
    property Selected: Boolean read GetSelected;
    property SelectionBorderRect: TRect read GetSelectionBorderRect;
    property SelectionArea: TRect read GetSelectionArea;
  end;

  { ItemViewInfos }

  TdxLayoutBasicItemCaptionViewInfo = class(TdxCustomLayoutItemCaptionViewInfo);

  TdxLayoutEmptySpaceItemCaptionViewInfo = class(TdxLayoutBasicItemCaptionViewInfo)
  protected
    function CanDoCaptionClick(X, Y: Integer): Boolean; override;
    procedure PrepareCanvas(ACanvas: TcxCanvas; AForDrawing: Boolean); override;
    function IsHotTrackable: Boolean; override;
  end;

  { TdxLayoutLabeledItemCaptionViewInfo }

  TdxLayoutLabeledItemCaptionViewInfo = class(TdxLayoutBasicItemCaptionViewInfo)
  private
    function GetItem: TdxCustomLayoutLabeledItem;
    function GetItemViewInfo: TdxLayoutLabeledItemViewInfo;
  protected
    function GetTextSize(ACanvas: TcxCanvas): TSize; override;
    function GetCursor(X, Y: Integer): TCursor; override;
    function GetSpaceBetweenImageText: Integer; override;
    function GetTextAreaWidth: Integer; override;

    function IsWidthFixed: Boolean; override;
    function IsMultiLine: Boolean; override;

    property Item: TdxCustomLayoutLabeledItem read GetItem;
    property ItemViewInfo: TdxLayoutLabeledItemViewInfo read GetItemViewInfo;
  public
    constructor Create(AItemViewInfo: TdxCustomLayoutItemViewInfo); override;

    function CalculateMinWidth: Integer; override;
  end;

  { TdxLayoutControlItemCaptionViewInfo }

  TdxLayoutControlItemCaptionViewInfo = class(TdxLayoutLabeledItemCaptionViewInfo)
  private
    function GetItem: TdxLayoutControlItem;
    function GetItemViewInfo: TdxLayoutControlItemViewInfo;
  protected
    function GetTextAreaWidth: Integer; override;

    property Item: TdxLayoutControlItem read GetItem;
    property ItemViewInfo: TdxLayoutControlItemViewInfo read GetItemViewInfo;
  end;

  { TdxLayoutItemCaptionViewInfo }

  TdxLayoutItemCaptionViewInfo = class(TdxLayoutControlItemCaptionViewInfo)
  private
    function GetItem: TdxLayoutItem;
    function GetItemViewInfo: TdxLayoutItemViewInfo;
  protected
    property Item: TdxLayoutItem read GetItem;
    property ItemViewInfo: TdxLayoutItemViewInfo read GetItemViewInfo;
  end;

  TdxLayoutCellItemCellViewInfo = class(TdxCustomLayoutItemElementViewInfo)
  protected
    function GetVisible: Boolean; override;
  public
    function CalculateMinHeight: Integer; override;
    function CalculateMinWidth: Integer; override;
    function CalculateHeight: Integer; override;
    function CalculateWidth: Integer; override;
  end;

  TdxLayoutControlItemControlViewInfo = class(TdxLayoutCellItemCellViewInfo)
  private
    FControlBounds: TRect;
    FControlWindowRect: TRect;
    FPrevControlSize: TSize;

    function GetBorderColor: TColor;
    function GetBorderStyle: TdxLayoutBorderStyle;
    function GetItem: TdxLayoutControlItem;
    function GetItemViewInfo: TdxLayoutControlItemViewInfo;
    function GetOpaqueControl: Boolean;
  protected
    procedure DoSetOffset(const AValue, ADiff: TPoint); override;
    procedure DoRightToLeftConversion(const AClientBounds: TRect); override;
    function GetLayoutAlignHorz: TdxLayoutRealAlignHorz; override;
    function GetLayoutAlignVert: TdxLayoutRealAlignVert; override;
    function GetVisible: Boolean; override;
    procedure CalculateControlBounds(const AAvailableBounds: TRect);
    procedure CalculateExactBounds(const AAvailableBounds: TRect); override;
    function GetBorderWidth(ASide: TdxLayoutSide): Integer; virtual;
    function GetControlAreaHeight(AControlHeight: Integer): Integer; virtual;
    function GetControlAreaWidth(AControlWidth: Integer): Integer; virtual;
    function GetOriginalControlSize: TSize; virtual;
    function HasBorder: Boolean; virtual;

    property BorderWidths[ASide: TdxLayoutSide]: Integer read GetBorderWidth;
    property Item: TdxLayoutControlItem read GetItem;
    property ItemViewInfo: TdxLayoutControlItemViewInfo read GetItemViewInfo;
  public
    procedure CalculateInternalTabOrder(var AAvailableTabOrder: Integer); virtual;
    procedure CalculateTabOrder(var AAvailableTabOrder: Integer); virtual;

    function CalculateMinHeight: Integer; override;
    function CalculateMinWidth: Integer; override;
    function CalculateHeight: Integer; override;
    function CalculateWidth: Integer; override;

    property BorderColor: TColor read GetBorderColor;
    property BorderStyle: TdxLayoutBorderStyle read GetBorderStyle;
    property ControlBounds: TRect read FControlBounds;
    property OpaqueControl: Boolean read GetOpaqueControl;
  end;
  TdxLayoutControlItemControlViewInfoClass = class of TdxLayoutControlItemControlViewInfo;

  { TdxLayoutItemControlViewInfo }

  TdxLayoutItemControlViewInfo = class(TdxLayoutControlItemControlViewInfo)
  private
    function GetControl: TControl;
    function GetItem: TdxLayoutItem;
  protected
    property Item: TdxLayoutItem read GetItem;
  public
    procedure CalculateTabOrder(var AAvailableTabOrder: Integer); override;
    property Control: TControl read GetControl;
  end;

  TdxLayoutBasicItemViewInfo = class(TdxCustomLayoutItemViewInfo)
  protected
    function GetCaptionViewInfoClass: TdxCustomLayoutItemCaptionViewInfoClass; override;
    function GetHitTestClass: TdxCustomLayoutItemHitTestClass; override;
    function GetPainterClass: TdxCustomLayoutItemPainterClass; override;

    function GetColor: TColor; override;
    function IsTransparent: Boolean; override;
  end;

  TdxLayoutEmptySpaceItemViewInfo = class(TdxLayoutBasicItemViewInfo)
  protected
    function GetCaptionViewInfoClass: TdxCustomLayoutItemCaptionViewInfoClass; override;
    function GetPainterClass: TdxCustomLayoutItemPainterClass; override;

    function DoCalculateHeight(ACalcSizeType: TdxLayoutCalcSizeType): Integer; override;
    function DoCalculateWidth(ACalcSizeType: TdxLayoutCalcSizeType): Integer; override;
  public
    procedure Calculate(const ABounds: TRect); override;
  end;

  TdxLayoutDirectionalItemViewInfo = class(TdxLayoutBasicItemViewInfo)
  private
    function GetItem: TdxLayoutDirectionalItem;
  protected
    function DoCalculateHeight(ACalcSizeType: TdxLayoutCalcSizeType): Integer; override;
    function DoCalculateWidth(ACalcSizeType: TdxLayoutCalcSizeType): Integer; override;

    function GetItemMinHeight: Integer; virtual;
    function GetItemMinWidth: Integer; virtual;
  public
    procedure Calculate(const ABounds: TRect); override;

    property Item: TdxLayoutDirectionalItem read GetItem;
  end;

  TdxLayoutSplitterItemViewInfo = class(TdxLayoutDirectionalItemViewInfo)
  private
    function GetSplitter: TdxLayoutSplitterItem;
  protected
    function GetHitTestBounds: TRect; override;
    function GetHitTestClass: TdxCustomLayoutItemHitTestClass; override;
    function GetPainterClass: TdxCustomLayoutItemPainterClass; override;
    function GetItemMinHeight: Integer; override;
    function GetItemMinWidth: Integer; override;
    procedure StateChanged; override;
    function IsHotTrackable: Boolean; override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer); override;
  public
    property Splitter: TdxLayoutSplitterItem read GetSplitter;
  end;

  TdxLayoutLabeledItemViewInfo = class(TdxLayoutBasicItemViewInfo)
  private
    function GetCaptionLayout: TdxCaptionLayout;
  protected
    FCaptionAreaBounds: TRect;

    function GetCaptionViewInfoClass: TdxCustomLayoutItemCaptionViewInfoClass; override;
    function GetPainterClass: TdxCustomLayoutItemPainterClass; override;

    procedure InitViewInfoBounds(AElementViewInfo: TdxCustomLayoutItemElementViewInfo;
      out ABounds: TRect; out ASize: TSize; out AVisible: Boolean);
    procedure CalculateCaptionAreaBounds;
    procedure CalculateViewInfoAreaBounds; virtual;
    procedure CalculateViewInfoExactBounds; virtual;
    function GetContentHeight(ACalcSizeType: TdxLayoutCalcSizeType): Integer; virtual;
    function GetContentWidth(ACalcSizeType: TdxLayoutCalcSizeType): Integer; virtual;
    function GetElementOffsetHorz: Integer; virtual;
    function GetElementOffsetVert: Integer; virtual;

    function CalculatePadding: TRect; override;
    function GetAvailableTextAreaWidthCorrection: Integer; override;
    function DoCalculateHeight(ACalcSizeType: TdxLayoutCalcSizeType): Integer; override;
    function DoCalculateWidth(ACalcSizeType: TdxLayoutCalcSizeType): Integer; override;
    function IsWordWrapAllowed: Boolean; override;

    procedure DoAssignBounds(ASource: TdxCustomLayoutElementViewInfo); override;
    procedure DoRightToLeftConversion(const AClientBounds: TRect); override;
    procedure DoSetOffset(const AValue, ADiff: TPoint); override;

    property CaptionAreaBounds: TRect read FCaptionAreaBounds;
    property ElementOffsetHorz: Integer read GetElementOffsetHorz;
    property ElementOffsetVert: Integer read GetElementOffsetVert;
  public
    procedure Calculate(const ABounds: TRect); override;

    property CaptionLayout: TdxCaptionLayout read GetCaptionLayout;
    property ContentBounds;
  end;

  { TdxLayoutCellItemViewInfo }

  TdxLayoutCellItemViewInfo = class(TdxLayoutLabeledItemViewInfo)
  protected
    FCellAreaBounds: TRect;
    FCellViewInfo: TdxCustomLayoutItemElementViewInfo;

    procedure CalculateViewInfoAreaBounds; override;
    procedure CalculateViewInfoExactBounds; override;
    procedure CreateViewInfos; override;
    procedure DestroyViewInfos; override;
    procedure DoAssignBounds(ASource: TdxCustomLayoutElementViewInfo); override;
    procedure DoRightToLeftConversion(const AClientBounds: TRect); override;
    procedure DoSetOffset(const AValue, ADiff: TPoint); override;
    function GetAvailableTextAreaWidthCorrection: Integer; override;
    function GetContentHeight(ACalcSizeType: TdxLayoutCalcSizeType): Integer; override;
    function GetContentWidth(ACalcSizeType: TdxLayoutCalcSizeType): Integer; override;
    procedure GetElements(AElements: TList); override;
    procedure PopulateAutoAlignControlList(AList: TList); override;
    function AutoAlignmentCellArea: Boolean; virtual;
    procedure CalculateCellAreaBounds; virtual;
    function GetCellViewInfoClass: TdxLayoutCellItemCellViewInfoClass; virtual;
    function GetCellAlignHorz: TdxLayoutRealAlignHorz; virtual;
    function GetCellSize(ACalcSizeType: TdxLayoutCalcSizeType): TSize; virtual;
    function GetCellHeight(ACalcSizeType: TdxLayoutCalcSizeType): Integer; virtual;
    function GetCellWidth(ACalcSizeType: TdxLayoutCalcSizeType): Integer; virtual;
    function GetCellOffset: TRect; virtual;
    function GetStandardCellWidth: Integer; virtual;
    function GetTextHeight(ACalcSizeType: TdxLayoutCalcSizeType): Integer; virtual;
    function GetTextWidth(ACalcSizeType: TdxLayoutCalcSizeType): Integer; virtual;
    function IsCellVisible: Boolean; virtual;

    property CellAreaBounds: TRect read FCellAreaBounds;
    property CellViewInfo: TdxCustomLayoutItemElementViewInfo read FCellViewInfo;
  end;

  { TdxLayoutSeparatorItemCaptionViewInfo }

  TdxLayoutSeparatorItemCaptionViewInfo = class(TdxLayoutLabeledItemCaptionViewInfo)
  protected
    procedure CalculateImageTextAreaBounds; override;
    function GetRotationAngle: TcxRotationAngle; override;
    function GetTextAlignHorz: TAlignment; override;
    function GetTextAlignVert: TdxAlignmentVert; override;
    function IsVerticalCaption: Boolean;
  public
    function CalculateHeight: Integer; override;
    function CalculateWidth: Integer; override;
  end;

  { TdxLayoutSeparatorItemViewInfo }

  TdxLayoutSeparatorItemViewInfo = class(TdxLayoutCellItemViewInfo)
  private
    function GetSeparator: TdxLayoutSeparatorItem;
  protected
    function GetCaptionViewInfoClass: TdxCustomLayoutItemCaptionViewInfoClass; override;
    function GetPainterClass: TdxCustomLayoutItemPainterClass; override;

    procedure CalculateViewInfoAreaBounds; override;
    procedure CalculateViewInfoExactBounds; override;
    function GetCellHeight(ACalcSizeType: TdxLayoutCalcSizeType): Integer; override;
    function GetCellWidth(ACalcSizeType: TdxLayoutCalcSizeType): Integer; override;
    function GetContentHeight(ACalcSizeType: TdxLayoutCalcSizeType): Integer; override;
    function GetContentWidth(ACalcSizeType: TdxLayoutCalcSizeType): Integer; override;

    property SeparatorBounds: TRect read FCellAreaBounds;
  public
    property Separator: TdxLayoutSeparatorItem read GetSeparator;
  end;

  { TdxLayoutImageItemViewInfo }

  TdxLayoutImageItemViewInfo = class(TdxLayoutCellItemViewInfo)
  private
    function GetItem: TdxLayoutImageItem;
  protected
    function GetPainterClass: TdxCustomLayoutItemPainterClass; override;
    function GetCellSize(ACalcSizeType: TdxLayoutCalcSizeType): TSize; override;
    function IsCellVisible: Boolean; override;
  public
    procedure Calculate(const ABounds: TRect); override;
    property ImageAreaBounds: TRect read FCellAreaBounds;
    property Item: TdxLayoutImageItem read GetItem;
  end;

  { TdxCustomLayoutCheckableItemCaptionViewInfo }

  TdxCustomLayoutCheckableItemCaptionViewInfo = class(TdxLayoutLabeledItemCaptionViewInfo)
  protected
    function GetTextPadding: TdxPadding; override;
    function IsPointInHotTrackBounds(const P: TPoint): Boolean; override;
    function WantsMouse(X, Y: Integer): Boolean; override;
  end;

  { TdxCustomLayoutCheckableItemViewInfo }

  TdxCustomLayoutCheckableItemViewInfo = class(TdxLayoutCellItemViewInfo)
  strict private
    function GetItem: TdxCustomLayoutCheckableItem; inline;
  protected
    function AutoAlignmentCellArea: Boolean; override;
    function GetCaptionViewInfoClass: TdxCustomLayoutItemCaptionViewInfoClass; override;
    function GetCellSize(ACalcSizeType: TdxLayoutCalcSizeType): TSize; override;
    function GetElementOffsetHorz: Integer; override;
    function GetElementOffsetVert: Integer; override;
    function GetPainterClass: TdxCustomLayoutItemPainterClass; override;
    function IsHotTrackable: Boolean; override;
    function IsFocused: Boolean; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer); override;
    function ShowHint(var AHintInfo: THintInfo): Boolean; override;
    procedure StateChanged; override;

    function GetCellAlignHorz: TdxLayoutRealAlignHorz; override;
    function GetCheckAreaSize: TSize; virtual; abstract;
    function GetFocusRect(ACanvas: TcxCanvas): TRect; override;

    property CheckAreaSize: TSize read GetCheckAreaSize;
    property Item: TdxCustomLayoutCheckableItem read GetItem;
  public
    procedure CalculateInternalTabOrders(var AAvailableTabOrder: Integer); override;

    property CheckAreaBounds: TRect read FCellAreaBounds;
  end;

  { TdxLayoutCheckBoxItemViewInfo }

  TdxLayoutCheckBoxItemViewInfo = class(TdxCustomLayoutCheckableItemViewInfo)
  strict private
    function GetItem: TdxLayoutCheckBoxItem;
  protected
    function GetCellOffset: TRect; override;
    function GetCheckAreaSize: TSize; override;
    function GetPainterClass: TdxCustomLayoutItemPainterClass; override;
  public
    property Item: TdxLayoutCheckBoxItem read GetItem;
  end;

  { TdxLayoutRadioButtonItemViewInfo }

  TdxLayoutRadioButtonItemViewInfo = class(TdxCustomLayoutCheckableItemViewInfo)
  strict private
    function GetItem: TdxLayoutRadioButtonItem;
  protected
    function GetCellOffset: TRect; override;
    function GetCheckAreaSize: TSize; override;
    function GetPainterClass: TdxCustomLayoutItemPainterClass; override;
  public
    property Item: TdxLayoutRadioButtonItem read GetItem;
  end;

  { TdxLayoutControlItemViewInfo }

  TdxLayoutControlItemViewInfo = class(TdxLayoutCellItemViewInfo)
  private
    function GetCaptionViewInfo: TdxLayoutControlItemCaptionViewInfo;
    function GetControlViewInfo: TdxLayoutControlItemControlViewInfo;
    function GetItem: TdxLayoutControlItem;
    function GetOptions: TdxLayoutLookAndFeelItemOptions;
  protected
    function GetCaptionViewInfoClass: TdxCustomLayoutItemCaptionViewInfoClass; override;
    function GetCellViewInfoClass: TdxLayoutCellItemCellViewInfoClass; override;
    function GetControlViewInfoClass: TdxLayoutControlItemControlViewInfoClass; virtual;
    function GetPainterClass: TdxCustomLayoutItemPainterClass; override;
    function AutoAlignmentCellArea: Boolean; override;
    function GetAvailableTextAreaWidth: Integer; override;
    function GetStandardCellWidth: Integer; override;
    function GetCellAlignHorz: TdxLayoutRealAlignHorz; override;
    function GetCellSize(ACalcSizeType: TdxLayoutCalcSizeType): TSize; override;
    function GetCellWidth(ACalcSizeType: TdxLayoutCalcSizeType): Integer; override;
    function GetCellHeight(ACalcSizeType: TdxLayoutCalcSizeType): Integer; override;
    function IsCellVisible: Boolean; override;

    function HasControl: Boolean; virtual;

    property ControlAreaBounds: TRect read FCellAreaBounds;
    property Item: TdxLayoutControlItem read GetItem;
    property Options: TdxLayoutLookAndFeelItemOptions read GetOptions;
  public
    procedure CalculateInternalTabOrders(var AAvailableTabOrder: Integer); override;
    procedure CalculateTabOrders(var AAvailableTabOrder: Integer); override;

    property AutoControlAreaAlignment: Boolean read AutoAlignmentCellArea;
    property CaptionViewInfo: TdxLayoutControlItemCaptionViewInfo read GetCaptionViewInfo; // for internal use
    property ControlViewInfo: TdxLayoutControlItemControlViewInfo read GetControlViewInfo; // for internal use
  end;

  { TdxLayoutItemViewInfo }

  TdxLayoutItemViewInfo = class(TdxLayoutControlItemViewInfo)
  private
    function GetCaptionViewInfo: TdxLayoutItemCaptionViewInfo;
    function GetControlViewInfo: TdxLayoutItemControlViewInfo;
    function GetItem: TdxLayoutItem;
  protected
    function CanFocusOnClick(X, Y: Integer): Boolean; override;
    function GetCaptionViewInfoClass: TdxCustomLayoutItemCaptionViewInfoClass; override;
    function GetControlViewInfoClass: TdxLayoutControlItemControlViewInfoClass; override;
    function GetHitTestClass: TdxCustomLayoutItemHitTestClass; override;
    function GetPainterClass: TdxCustomLayoutItemPainterClass; override;
    procedure PopulateControlViewInfoList(AControls, AWinControls: TList); override;
    procedure SetItemHeight(AHeight: Integer; ADirectAccess: Boolean); override;
    procedure SetItemWidth(AWidth: Integer; ADirectAccess: Boolean); override;

    procedure CustomizationMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    function PtInDesignSelectorRect(const P: TPoint): Boolean;
    property Item: TdxLayoutItem read GetItem;
  public
    property CaptionViewInfo: TdxLayoutItemCaptionViewInfo read GetCaptionViewInfo; // for internal use
    property ControlViewInfo: TdxLayoutItemControlViewInfo read GetControlViewInfo; // for internal use
  end;

  { GroupViewInfos }

  { TdxLayoutGroupCaptionViewInfo }

  TdxLayoutGroupCaptionViewInfo = class(TdxCustomLayoutItemCaptionViewInfo)
  private
    FAvailableTextSizeCache: TSize;
    FCanClickOnCaption: Boolean;
    function GetCaptionSide: TdxLayoutSide;
    function GetGroupViewInfo: TdxLayoutGroupViewInfo;
  protected
    function GetAvailableHeight: Integer;
    function GetAvailableWidth: Integer;
    function GetAvailableHorzTextHeight: Integer;
    function GetAvailableHorzTextWidth: Integer;
    function GetAvailableTextHeight: Integer;
    function GetAvailableTextWidth: Integer;

    procedure CalculateImageTextAreaBounds; override;
    function CalculateTextFlags(ACanvas: TcxCanvas; AForDrawing: Boolean = True): Integer; override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure MouseMove(Shift: TShiftState; X: Integer; Y: Integer); override;
    procedure PrepareCanvas(ACanvas: TcxCanvas; AForDrawing: Boolean); override;
    procedure StateChanged; override;

    function GetTextAlignHorz: TAlignment; override;
    function GetTextAlignVert: TdxAlignmentVert; override;
    function GetColor: TColor; override;
    function GetContentOffsetSize: TSize; override;
    function GetContentOffsets: TRect; override;
    function GetTextSize(ACanvas: TcxCanvas): TSize; override;
    function GetRotationAngle: TcxRotationAngle; override;
    function IsVerticalCaption: Boolean;

    property CanClickOnCaption: Boolean read FCanClickOnCaption;
    property CaptionSide: TdxLayoutSide read GetCaptionSide;
    property GroupViewInfo: TdxLayoutGroupViewInfo read GetGroupViewInfo;
  public
    function CalculateMinHeight: Integer; override;
    function CalculateMinWidth: Integer; override;
    function CalculateHeight: Integer; override;
    function CalculateWidth: Integer; override;
  end;

  TItemInfo = record
    ViewInfo: TdxCustomLayoutItemViewInfo;
    MajorAlign: TdxLayoutAlignAbs;
    MinorAlign: TdxLayoutAlignAbs;
    OriginalMajorSize: Integer;
    SufficientMajorSize: Integer;
    CalculatedMajorSize: Integer;
    MinMajorSize: Integer;
    MaxMajorSize: Integer;
    SufficientMinorSize: Integer;
    OriginalMinorSize: Integer;
    AbsBounds: TdxAbsRect;
    PrevBounds: TRect;
    Calculated: Boolean;
  end;
  TItemInfos = array of TItemInfo;

  TdxLayoutGroupViewInfoSpecific = class(TcxIUnknownObject, IdxScaleFactor)
  private
    FGroupViewInfo: TdxLayoutGroupViewInfo;
    FItemInfos: TItemInfos;
    FOffset: TPoint;

    procedure CalculateItemViewInfos;

    function GetContainer: TdxLayoutContainer;
    function GetGroup: TdxCustomLayoutGroup;
    function GetItemOffset: Integer;
    function GetItemViewInfo(Index: Integer): TdxCustomLayoutItemViewInfo;
    function GetItemViewInfoCount: Integer;
    function GetLayoutDirection: TdxLayoutDirection;
  protected
    // Work Parameters
    function AllowMajorScroll: Boolean; virtual;
    function AllowMinorScroll: Boolean; virtual;
    function GetAbsRect(const R: TRect): TdxAbsRect;
    function GetAbsPoint(const P: TPoint): TdxAbsPoint;
    function GetAbsSize(const ASize: TSize): TdxAbsSize;
    function GetRectFromAbsRect(const R: TdxAbsRect): TRect; virtual;

    function GetMajorValue(const P: TPoint): Integer; overload; virtual;
    function GetMinorValue(const P: TPoint): Integer; overload; virtual;
    function GetMajorValue(const ASize: TSize): Integer; overload; virtual;
    function GetMinorValue(const ASize: TSize): Integer; overload; virtual;
    function GetMajorAlign(const AAlign: TdxLayoutRealAlign): TdxLayoutAlignAbs; virtual;
    function GetMinorAlign(const AAlign: TdxLayoutRealAlign): TdxLayoutAlignAbs; virtual;

    procedure SetMajorNear(var R: TRect; AValue: Integer); virtual;
    procedure SetMajorFar(var R: TRect; AValue: Integer); virtual;
    procedure SetMajorAlign(var AAlign: TdxLayoutRealAlign; AValue: TdxLayoutAlignAbs); virtual;
    procedure SetMinorAlign(var AAlign: TdxLayoutRealAlign; AValue: TdxLayoutAlignAbs); virtual;
    procedure CorrectMajorAlignForLocale(var AAlign: TdxLayoutRealAlign); virtual;
    procedure CorrectMinorAlignForLocale(var AAlign: TdxLayoutRealAlign); virtual;

    // Drawing
    function CanDrawSpecificControls: Boolean; virtual;
    procedure DrawSpecificControls(ACanvas: TcxCanvas); virtual;

    // Calculating
    procedure CalculateItemsAreaBounds(var AItemsAreaBounds: TRect); virtual;
    procedure CalculateItemsBounds(AItemsAreaBounds: TRect); virtual;
    procedure CalculateItemsMajorBounds(const AItemsAreaBounds: TdxAbsRect); virtual;
    procedure CalculateItemsMinorBounds(const AItemsAreaBounds: TdxAbsRect); virtual;
    procedure CalculateInternalTabOrders(var ATabOrder: Integer); virtual;
    procedure CalculateOffsets; virtual;
    procedure CorrectItemsAreaBounds(var AItemsAreaBounds: TRect); virtual;

    // Dragging
    procedure CorrectDropAreaPart(const P: TPoint; var AAreaPart: TdxLayoutDropAreaPart); virtual;
    function GetDropExactItem(const P: TPoint): TdxCustomLayoutItem;
    function GetDropExactItemInRow(const P: TPoint): TdxCustomLayoutItem;
    function GetDropNearestItem(const P: TPoint): TdxCustomLayoutItem;
      // Dragging1
    function CutItemRect(AItem: TdxCustomLayoutItem; const R: TRect): TRect; virtual; abstract;
    function GetDropActionType(AAreaPart: TdxLayoutDropAreaPart): TdxLayoutActionType; virtual; abstract;
      // Dragging2
    function GetDropAlignOutsideArea(const ADefaultAlign: TdxLayoutRealAlign; const ABounds: TRect; const ADropAreaInfo: TdxLayoutDragDropInfo): TdxLayoutRealAlign;
    function GetDropAlignOutsideItem(const ADropAreaInfo: TdxLayoutDragDropInfo): TdxLayoutRealAlign;
    function GetDropAlignInsideArea(const ADefaultAlign: TdxLayoutRealAlign; const ABounds: TRect; const ADropAreaInfo: TdxLayoutDragDropInfo): TdxLayoutRealAlign;
      // Dragging3
    function GetDropAreaPart(var P: TPoint): TdxLayoutDropAreaPart; virtual;
    function GetDropExpectedBounds(const ADropAreaInfo: TdxLayoutDragDropInfo): TRect; virtual;
    function GetDropExpectedAlign(const ADropAreaInfo: TdxLayoutDragDropInfo): TdxLayoutRealAlign; virtual;
    function GetDropRectOutsideItem(const ADropAreaInfo: TdxLayoutDragDropInfo): TRect; virtual;
    function GetDropRectInsideRect(const ARect: TRect; const ADropAreaInfo: TdxLayoutDragDropInfo): TRect;
    function IsDropPositionHasProperAlign(const ADropAreaInfo: TdxLayoutDragDropInfo): Boolean; virtual;
    function IsDropPositionHasOppositeAlign(const ADropAreaInfo: TdxLayoutDragDropInfo): Boolean; virtual;
      // Dragging4
    function GetBetweenItemsDropArea(const P: TPoint): TRect; virtual;
    function GetLastChildDropArea: TRect; virtual;
    function GetNewLayoutDropArea(AItem: TdxCustomLayoutItem): TRect;
    function GetNewLayoutExtendedDropArea(AItem: TdxCustomLayoutItem): TRect;
      // Dragging5
    function GetDropNearestPoint(const P: TPoint): TPoint;
    function GetItemEnlargedBounds(AItem: TdxCustomLayoutItem): TRect;
    function GetItemExtendedBounds(AItem: TdxCustomLayoutItem): TRect;

    // Sizes
    function GetMaxItemsMajorSize(AIsMinWidth: Boolean): Integer;
    function GetMaxItemsMinorSize(AIsMinSize: Boolean): Integer;
    function GetMinorSize(ACalcSizeType: TdxLayoutCalcSizeType): Integer; virtual;
    function GetMajorSize(ACalcSizeType: TdxLayoutCalcSizeType): Integer; virtual;
    function GetItemOriginalMinorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer; virtual; abstract;
    function GetItemOriginalMajorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer; virtual; abstract;
    function GetItemSufficientMinorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer; virtual; abstract;
    function GetItemSufficientMajorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer; virtual; abstract;
    function GetItemMinMinorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer; virtual; abstract;
    function GetItemMinMajorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer; virtual; abstract;
    function GetItemMaxMinorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer; virtual; abstract;
    function GetItemMaxMajorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer; virtual; abstract;
    function GetItemsAreaOffset(ASide: TdxLayoutSide): Integer; virtual;

    function IsItemMajorSizeUsual(AViewInfo: TdxCustomLayoutItemViewInfo): Boolean;
    function IsItemMinorSizeUsual(AViewInfo: TdxCustomLayoutItemViewInfo): Boolean;
    function IsMajorSizeFixed: Boolean; virtual;
    function IsMeasureMinWidthWithWrapItems: Boolean;
    function IsMinorSizeFixed: Boolean; virtual;
    function IsPopupScrollBars: Boolean;
    function IsTouchScrollUIMode: Boolean;

    // Selection
    procedure AddSelectionControls; virtual;
    procedure RemoveSelectionControls; virtual;

    function CanFocus: Boolean; virtual;
    function CanFocusOnClick(X, Y: Integer): Boolean; virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState); virtual;

    // IdxScaleFactor
    function GetScaleFactor: TdxScaleFactor;

    // Specific Objects
    procedure InitializeMajorScrollBar(AContentSize, AClientSize: Integer); virtual;
    procedure InitializeMinorScrollBar(AContentSize, AClientSize: Integer); virtual;
    procedure CreateSpecificControls; virtual;
    procedure DestroySpecificControls; virtual;
    procedure CreateViewInfos; virtual;
    procedure DestroyViewInfos; virtual;
    procedure GetElements(AElements: TList); virtual;

    procedure AssignBounds(ASource: TdxLayoutGroupViewInfoSpecific);
    function CanAssignBounds(ASource: TdxLayoutGroupViewInfoSpecific): Boolean; virtual;
    procedure DoAssignBounds(ASource: TdxLayoutGroupViewInfoSpecific); virtual;
    procedure DoRightToLeftConversion(const AClientBounds: TRect); virtual;
    procedure MakeVisible(const ARect: TRect; AFully: Boolean); virtual;
    function GetNewScrollPosMajor(const ARect: TRect; AFully: Boolean; AScrollPos: Integer): Integer;
    function GetNewScrollPosMinor(const ARect: TRect; AFully: Boolean; AScrollPos: Integer): Integer;
    procedure SetOffset(const Value: TPoint); virtual;
    procedure Reset; virtual;

    property Container: TdxLayoutContainer read GetContainer;
    property Group: TdxCustomLayoutGroup read GetGroup;
    property GroupViewInfo: TdxLayoutGroupViewInfo read FGroupViewInfo;
    property ItemOffset: Integer read GetItemOffset;
    property ItemViewInfoCount: Integer read GetItemViewInfoCount;
    property ItemViewInfos[Index: Integer]: TdxCustomLayoutItemViewInfo read GetItemViewInfo;
    property LayoutDirection: TdxLayoutDirection read GetLayoutDirection;
    property Offset: TPoint read FOffset write SetOffset;
  public
    constructor Create(AGroupViewInfo: TdxLayoutGroupViewInfo); virtual;
    destructor Destroy; override;

    procedure Calculate(const AItemsAreaBounds: TRect); virtual;
    function GetItemsAreaHeight(ACalcSizeType: TdxLayoutCalcSizeType): Integer; virtual;
    function GetItemsAreaWidth(ACalcSizeType: TdxLayoutCalcSizeType): Integer; virtual;
    function IsAtInsertionPos(const R: TRect; const P: TPoint): Boolean; virtual; abstract;

    function AllowDrawChild(AChildViewInfo: TdxCustomLayoutItemViewInfo): Boolean; virtual;
    function AllowChildHasBorder: Boolean; virtual;
    function GetChildInplaceRenameBounds(AChildViewInfo: TdxCustomLayoutItemViewInfo): TRect; virtual;
    function GetDefaultItemControlAreaAlignment: TdxLayoutItemControlAreaAlignment; virtual;
    function ProcessDialogChar(ACharCode: Word): Boolean; virtual;
    function ProcessDialogKey(ACharCode: Word; AKeyData: Integer; AFocusedItem: TdxCustomLayoutItem): Boolean; virtual;
  end;

  TdxLayoutGroupViewInfoHorizontalSpecific = class(TdxLayoutGroupViewInfoSpecific)
  protected
    procedure CalculateItemsBounds(AItemsAreaBounds: TRect); override;
    // Scroll
    function AllowMajorScroll: Boolean; override;
    function AllowMinorScroll: Boolean; override;
    procedure InitializeMajorScrollBar(AContentSize, AClientSize: Integer); override;
    procedure InitializeMinorScrollBar(AContentSize, AClientSize: Integer); override;

    // Dragging
    function CutItemRect(AItem: TdxCustomLayoutItem; const R: TRect): TRect; override;
    function GetLastChildDropArea: TRect; override;
    function GetDropActionType(AAreaPart: TdxLayoutDropAreaPart): TdxLayoutActionType; override;

    // Sizes
    function GetItemOriginalMajorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer; override;
    function GetItemOriginalMinorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer; override;
    function GetItemSufficientMinorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer; override;
    function GetItemSufficientMajorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer; override;
    function GetItemMinMinorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer; override;
    function GetItemMinMajorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer; override;
    function GetItemMaxMinorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer; override;
    function GetItemMaxMajorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer; override;
    function GetItemsAreaOffset(ASide: TdxLayoutSide): Integer; override;
    function IsMajorSizeFixed: Boolean; override;
    function IsMinorSizeFixed: Boolean; override;
  public
    function IsAtInsertionPos(const R: TRect; const P: TPoint): Boolean; override;
  end;

  TdxLayoutGroupViewInfoVerticalSpecific = class(TdxLayoutGroupViewInfoSpecific)
  protected
    function AllowMajorScroll: Boolean; override;
    function AllowMinorScroll: Boolean; override;
    procedure InitializeMajorScrollBar(AContentSize, AClientSize: Integer); override;
    procedure InitializeMinorScrollBar(AContentSize, AClientSize: Integer); override;

    // Work Parameters
    function GetRectFromAbsRect(const R: TdxAbsRect): TRect; override;
    function GetMajorValue(const P: TPoint): Integer; overload; override;
    function GetMinorValue(const P: TPoint): Integer; overload; override;
    function GetMajorValue(const ASize: TSize): Integer; overload; override;
    function GetMinorValue(const ASize: TSize): Integer; overload; override;
    function GetMajorAlign(const AAlign: TdxLayoutRealAlign): TdxLayoutAlignAbs; override;
    function GetMinorAlign(const AAlign: TdxLayoutRealAlign): TdxLayoutAlignAbs; override;
    procedure SetMajorNear(var R: TRect; AValue: Integer); override;
    procedure SetMajorFar(var R: TRect; AValue: Integer); override;
    procedure SetMajorAlign(var AAlign: TdxLayoutRealAlign; AValue: TdxLayoutAlignAbs); override;
    procedure SetMinorAlign(var AAlign: TdxLayoutRealAlign; AValue: TdxLayoutAlignAbs); override;
    procedure CorrectMajorAlignForLocale(var AAlign: TdxLayoutRealAlign); override;
    procedure CorrectMinorAlignForLocale(var AAlign: TdxLayoutRealAlign); override;

    // Dragging
    function CutItemRect(AItem: TdxCustomLayoutItem; const R: TRect): TRect; override;
    function GetLastChildDropArea: TRect; override;
    function GetDropActionType(AAreaPart: TdxLayoutDropAreaPart): TdxLayoutActionType; override;
    function IsDropPositionHasProperAlign(const ADropAreaInfo: TdxLayoutDragDropInfo): Boolean; override;
    function IsDropPositionHasOppositeAlign(const ADropAreaInfo: TdxLayoutDragDropInfo): Boolean; override;

    // Sizes
    function GetItemOriginalMajorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer; override;
    function GetItemOriginalMinorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer; override;
    function GetItemSufficientMinorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer; override;
    function GetItemSufficientMajorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer; override;
    function GetItemMinMinorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer; override;
    function GetItemMinMajorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer; override;
    function GetItemMaxMinorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer; override;
    function GetItemMaxMajorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer; override;
    function GetItemsAreaOffset(ASide: TdxLayoutSide): Integer; override;
    function IsMajorSizeFixed: Boolean; override;
    function IsMinorSizeFixed: Boolean; override;
  public
    function GetItemsAreaHeight(ACalcSizeType: TdxLayoutCalcSizeType): Integer; override;
    function GetItemsAreaWidth(ACalcSizeType: TdxLayoutCalcSizeType): Integer; override;
    function IsAtInsertionPos(const R: TRect; const P: TPoint): Boolean; override;
  end;

  { TdxLayoutTabbedController }

  TdxLayoutTabbedController = class(TcxCustomTabControlController)
  protected
    function GetClientToScreen(const APoint: TPoint): TPoint; override;
    function GetScreenToClient(const APoint: TPoint): TPoint; override;
  end;

  { TdxLayoutTabbedViewInfo }

  TdxLayoutTabbedViewInfo = class(TcxCustomTabControlViewInfo)
  private
    FIsRightToLeftConsider: Boolean;
    function GetGroupViewInfo: TdxLayoutGroupViewInfo;
  protected
    function ArrowButtonClick(ANavigatorButton: TcxPCNavigatorButton): Boolean; override;
    function DoGetTabIndex: Integer; override;
    procedure DoSetTabIndex(Value: Integer); override;

    property GroupViewInfo: TdxLayoutGroupViewInfo read GetGroupViewInfo;
  public
    function IsTransparent: Boolean; override;
    function UseRightToLeftAlignment: Boolean; override;
  end;

  TdxTabControlElementViewInfo = class(TdxCustomLayoutItemElementViewInfo)
  private
    FTabController: TdxLayoutTabbedController;
    FTabViewInfo: TdxLayoutTabbedViewInfo;
    function GetGroup: TdxCustomLayoutGroup;
  protected
    function GetVisible: Boolean; override;
    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    property Group: TdxCustomLayoutGroup read GetGroup;
  end;

  TdxLayoutGroupViewInfoTabbedSpecific = class(TdxLayoutGroupViewInfoHorizontalSpecific, IcxTabControl, IcxControlComponentState)
  private
    FTabControlBounds: TRect;
    FTabControlElementViewInfo: TdxTabControlElementViewInfo;
    FTabControlElementViewInfoOpposite: TdxTabControlElementViewInfo;

    FTabController: TdxLayoutTabbedController;
    FTabPainter: TcxPCCustomPainter;
    FTabSheetContentOffset: TPoint;
    FTabViewInfo: TdxLayoutTabbedViewInfo;
    FTabViewInfoCalculated: Boolean;
    FMinContentSize: Integer;

    procedure DoCalculateTabControl(const ATabBounds: TRect; AIsRightToLeftConsider: Boolean);
    procedure DrawTabControl(ACanvas: TcxCanvas);
    function GetTabbedOptions: TdxLayoutTabbedOptions;
  protected
    // Drawing
    function CanDrawSpecificControls: Boolean; override;
    procedure DrawSpecificControls(ACanvas: TcxCanvas); override;

    // Calculating
    procedure CalculateItemsAreaBounds(var AItemsAreaBounds: TRect); override;
    procedure CalculateItemsMajorBounds(const AItemsAreaBounds: TdxAbsRect); override;
    procedure CalculateInternalTabOrders(var ATabOrder: Integer); override;
    procedure CalculateOffsets; override;
    procedure CalculateTabControl; virtual;

    // Dragging
    procedure CorrectDropAreaPart(const P: TPoint; var AAreaPart: TdxLayoutDropAreaPart); override;
    function GetDropActionType(AAreaPart: TdxLayoutDropAreaPart): TdxLayoutActionType; override;
    function GetDropAreaPart(var P: TPoint): TdxLayoutDropAreaPart; override;
    function GetDropExpectedAlign(const ADropAreaInfo: TdxLayoutDragDropInfo): TdxLayoutRealAlign; override;
    function GetDropExpectedBounds(const ADropAreaInfo: TdxLayoutDragDropInfo): TRect; override;

    // Sizes
    function GetMinorSize(ACalcSizeType: TdxLayoutCalcSizeType): Integer; override;
    function GetMajorSize(ACalcSizeType: TdxLayoutCalcSizeType): Integer; override;

    procedure DoAssignBounds(ASource: TdxLayoutGroupViewInfoSpecific); override;
    procedure DoSetOffset(const AValue, ADiff: TPoint);
    procedure SetOffset(const Value: TPoint); override;
    procedure Reset; override;

    function GetItemsAreaOffset(ASide: TdxLayoutSide): Integer; override;
    function GetHitTabIndex(const P: TPoint): Integer;

    function CanFocus: Boolean; override;
    function CanFocusOnClick(X, Y: Integer): Boolean; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;

    // Specific Objects
    procedure CreateSpecificControls; override;
    procedure DestroySpecificControls; override;
    procedure CreateViewInfos; override;
    procedure DestroyViewInfos; override;
    procedure GetElements(AElements: TList); override;

    procedure CreateTabControl;
    procedure DestroyTabControl;
    function HasTabControl: Boolean;

    // IcxTabControl
    function IcxTabControl.GetController = GetTabController;
    function GetTabController: TcxCustomTabControlController;
    function IcxTabControl.GetPainter = GetTabPainter;
    function GetTabPainter: TcxPCCustomPainter;
    function IcxTabControl.GetProperties = GetTabProperties;
    function GetTabProperties: TcxCustomTabControlProperties;
    function IcxTabControl.GetViewInfo = GetTabViewInfo;
    function GetTabViewInfo: TcxCustomTabControlViewInfo;
    function IcxTabControl.CanDrawParentBackground = CanDrawTabParentBackground;
    function CanDrawTabParentBackground: Boolean;
    function IcxTabControl.GetBoundsRect = GetTabBoundsRect;
    function GetTabBoundsRect: TRect;
    function GetCanvas: TcxCanvas;
    function GetControl: TWinControl;
    function IcxTabControl.GetColor = GetTabColor;
    function GetTabColor: TColor;
    function GetDragAndDropObject: TcxDragAndDropObject;
    function GetDragAndDropState: TcxDragAndDropState;
    function GetFont: TFont;
    function GetLookAndFeel: TcxLookAndFeel;

    procedure IcxTabControl.InvalidateRect = InvalidateTabRect;
    procedure DoRightToLeftConversion(const AClientBounds: TRect); override;
    procedure InvalidateTabRect(const R: TRect; AEraseBackground: Boolean);
    procedure SetModified;
    function IsEnabled: Boolean;
    function IsDesigning: Boolean;
    function IsDestroying: Boolean;
    function IsFocused: Boolean;
    function IsLoading: Boolean;
    function IsParentBackground: Boolean;
    procedure RequestLayout;

    property TabbedOptions: TdxLayoutTabbedOptions read GetTabbedOptions;
  public
    function AllowDrawChild(AChildViewInfo: TdxCustomLayoutItemViewInfo): Boolean; override;
    function AllowChildHasBorder: Boolean; override;
    function GetChildInplaceRenameBounds(AChildViewInfo: TdxCustomLayoutItemViewInfo): TRect; override;
    function GetDefaultItemControlAreaAlignment: TdxLayoutItemControlAreaAlignment; override;
    function ProcessDialogChar(ACharCode: Word): Boolean; override;
    function ProcessDialogKey(ACharCode: Word; AKeyData: Integer; AFocusedItem: TdxCustomLayoutItem): Boolean; override;
  end;

  TdxLayoutGroupButtonsViewInfo = class;

  TdxLayoutGroupButtonViewInfo = class(TdxCustomLayoutItemElementViewInfo)
  private
    FButton: TdxCustomLayoutGroupButton;
    FButtonsViewInfo: TdxLayoutGroupButtonsViewInfo;
    function GetGlyph: TdxSmartGlyph;
    function GetIsEnabled: Boolean;
    function GetVisibleIndex: Integer;
    function GetRotationAngle: TcxRotationAngle;
  protected
    // Mouse
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure DoClick; virtual;

    procedure StateChanged; override;
    function IsHotTrackable: Boolean; override;

    // Allow
    function AllowDragDrop: Boolean; override;

    // Hint
    function ShowHint(var AHintInfo: THintInfo): Boolean; override;

    function GetVisible: Boolean; override;
    function GetPainterClass: TdxLayoutGroupButtonPainterClass; virtual;
    function GetState: TcxButtonState; virtual;

    function IsGroupExpanded: Boolean;
    function IsExpandButton: Boolean;
    function IsHomeButton: Boolean;

    property Glyph: TdxSmartGlyph read GetGlyph;
    property IsEnabled: Boolean read GetIsEnabled;
  public
    constructor Create(AButtonsViewInfo: TdxLayoutGroupButtonsViewInfo; AButton: TdxCustomLayoutGroupButton); reintroduce; virtual;

    function CalculateHeight: Integer; override;
    function CalculateWidth: Integer; override;

    property Button: TdxCustomLayoutGroupButton read FButton;
    property ButtonsViewInfo: TdxLayoutGroupButtonsViewInfo read FButtonsViewInfo; // for internal use
    property VisibleIndex: Integer read GetVisibleIndex;
  end;

  TdxLayoutGroupCheckBoxButtonViewInfo = class(TdxLayoutGroupButtonViewInfo)
  protected
    function GetCheckBoxSize(ACanvas: TcxCanvas): TSize;
    function GetEditCheckState: TcxEditCheckState;
    function GetPainterClass: TdxLayoutGroupButtonPainterClass; override;
  end;

  TdxLayoutGroupButtonsViewInfo = class(TdxCustomLayoutItemElementViewInfo)
  private
    FButtonViewInfos: TcxObjectList;
    function GetButtonViewInfos(Index: Integer): TdxLayoutGroupButtonViewInfo;
    function GetButtonViewInfoCount: Integer;
    function GetExpandButton: TdxLayoutGroupButton;
    function GetGroupViewInfo: TdxLayoutGroupViewInfo;
    function GetOptions: TdxLayoutGroupButtonOptions;
  protected
    function GetVisible: Boolean; override;

    procedure CalculateHorizontalLayout;
    procedure CalculateVerticalLayout;

    procedure CalculateButtonViewInfos;
    procedure CreateButtonViewInfos;
    procedure RecreateButtonViewInfos;
    procedure DestroyButtonViewInfos;
    procedure GetElements(AElements: TList);

    function InternalCalculateHeight: Integer; virtual;
    function InternalCalculateWidth: Integer; virtual;

    procedure DoAssignBounds(ASource: TdxCustomLayoutElementViewInfo); override;
    procedure DoRightToLeftConversion(const AClientBounds: TRect); override;
    procedure DoSetOffset(const AValue, ADiff: TPoint); override;
    procedure StateChanged; override;

    function IsLeftAlignment: Boolean; virtual;

    property ExpandButton: TdxLayoutGroupButton read GetExpandButton;
    property Options: TdxLayoutGroupButtonOptions read GetOptions;
  public
    constructor Create(AItemViewInfo: TdxCustomLayoutItemViewInfo); override;
    destructor Destroy; override;

    procedure Calculate(const ABounds: TRect); override;
    function CalculateHeight: Integer; override;
    function CalculateMinHeight: Integer; override;
    function CalculateMinWidth: Integer; override;
    function CalculateWidth: Integer; override;

    property ButtonViewInfoCount: Integer read GetButtonViewInfoCount;
    property ButtonViewInfos[Index: Integer]: TdxLayoutGroupButtonViewInfo read GetButtonViewInfos; // for internal use
    property GroupViewInfo: TdxLayoutGroupViewInfo read GetGroupViewInfo; // for internal use
  end;

  TdxLayoutGroupViewData = class(TdxCustomLayoutItemViewData)
  private
    FScrollPos: TdxAbsPoint;

    procedure DoButtonClick(AViewInfo: TdxLayoutGroupButtonViewInfo);
    function GetGroup: TdxCustomLayoutGroup;
  protected
    procedure Changed; override;
    function GetSize: Integer; override;

    function GetExpanded: Boolean; virtual;
    function GetItemIndex: Integer; virtual;
    function GetTabIndex: Integer; virtual;
    procedure SetExpanded(Value: Boolean); virtual;
    procedure SetItemIndex(Value: Integer); virtual;
    procedure SetScrollPos(const Value: TdxAbsPoint);
    procedure SetTabIndex(Value: Integer); virtual;
  public
    constructor Create(AOwner: TdxLayoutItemViewDataList; AItem: TdxCustomLayoutItem); override;
    destructor Destroy; override;
    procedure Assign(Source: TdxCustomLayoutItemViewData); override;
    procedure Calculate; override;
    procedure Load(AStream: TStream); override;
    procedure Save(AStream: TStream); override;

    property Group: TdxCustomLayoutGroup read GetGroup;
    property Expanded: Boolean read GetExpanded write SetExpanded;
    property ItemIndex: Integer read GetItemIndex write SetItemIndex;
    property ScrollPos: TdxAbsPoint read FScrollPos write SetScrollPos;
    property TabIndex: Integer read GetTabIndex write SetTabIndex;
  end;

  TdxLayoutGroupViewInfo = class(TdxCustomLayoutItemViewInfo, IdxTouchScrollUIOwner, IdxHybridScrollbarOwner,
    IcxScrollBarOwner, IcxScrollBarOwner2Provider)
  private
    FButtonsViewInfo: TdxLayoutGroupButtonsViewInfo;
    FOffsetsCalculated: Boolean;
    FHybridScrollbarsManager: TdxHybridScrollbarsManager;
    FItemOffset: Integer;
    FItemsAreaOffsetHorz: Integer;
    FItemsAreaOffsetVert: Integer;
    FItemViewInfos: TObjectList;
    FMajorScrollBar: TdxScrollBarWrapper;
    FMajorScrollBarBounds: TRect;
    FMinorScrollBar: TdxScrollBarWrapper;
    FMinorScrollBarBounds: TRect;
    FSpecific: TdxLayoutGroupViewInfoSpecific;

    function GetBorderBounds(ASide: TdxLayoutSide): TRect;
    function GetBorderRestSpaceBounds(ASide: TdxLayoutSide): TRect;
    function GetBordersHeight: Integer;
    function GetBordersWidth: Integer;
    function GetCaptionSide: TdxLayoutSide;
    function GetCaptionViewInfo: TdxLayoutGroupCaptionViewInfo;
    function GetGroup: TdxCustomLayoutGroup;
    function GetItemViewInfo(Index: Integer): TdxCustomLayoutItemViewInfo; inline;
    function GetItemViewInfoCount: Integer;
    function GetLayoutDirection: TdxLayoutDirection;
    function GetOptions: TdxLayoutLookAndFeelGroupOptions;
    function GetScrollPos: TdxAbsPoint;
    function GetRealItemControlAreaAlignment: TdxLayoutItemControlAreaAlignment;
    function GetViewData: TdxLayoutGroupViewData;

    function GetItemIndex: Integer;
    function GetOffset(Index: Integer): Integer;

    function CreateScrollBar: TdxScrollBarWrapper;
    procedure DestroyScrollBar(var AScrollBar: TdxScrollBarWrapper);
    procedure InitializeMajorScrollBar(AContentSize, AClientSize: Integer);
    procedure InitializeMinorScrollBar(AContentSize, AClientSize: Integer);
    procedure CheckScrollPos(AScrollBar: TdxScrollBarWrapper; var AScrollPos: Integer);
    procedure SetScrollBounds(AScrollBar: TdxScrollBarWrapper; const ABounds: TRect);

    procedure CreateItemViewInfos;
    procedure CreateSpecific;
    procedure DestroyItemViewInfos;
    procedure DestroySpecific;
  protected
    FCaptionAreaBounds: TRect;
    FButtonsAreaBounds: TRect;
    FClientAreaBounds: TRect;
    FItemsAreaBounds: TRect;
    FFrameBounds: TRect;

    procedure CreateViewInfos; override;
    procedure DestroyViewInfos; override;
    procedure FreeNotification(AComponent: TComponent); override;
    procedure GetElements(AElements: TList); override;
    procedure PopulateAutoAlignControlList(AList: TList); override;
    procedure PopulateControlViewInfoList(AControls, AWinControls: TList); override;

    // IdxTouchScrollUIOwner
    procedure CheckUIPosition;
    function GetOwnerControl: TcxControl;
    function HasVisibleUI: Boolean;
    procedure HideUI;
    // IdxHybridScrollbarOwner
    function GetManager: TdxHybridScrollbarsManager;
    procedure IdxHybridScrollbarOwner.Invalidate=InvalidateScrollbars;
    function IdxHybridScrollbarOwner.GetBaseColor=GetHybridScrollbarBaseColor;
    function GetHybridScrollbarBaseColor: TColor;
    procedure InvalidateScrollbars;
    // IcxScrollBarOwner
    function GetControl: TWinControl;
    function GetLookAndFeel: TcxLookAndFeel;
    function GetScaleFactor: TdxScaleFactor;
    // IcxScrollBarOwner2Provider
    function GetOwner2: IcxScrollbarOwner2;
    // Classes
    function GetCaptionViewInfoClass: TdxCustomLayoutItemCaptionViewInfoClass; override;
    function GetHitTestClass: TdxCustomLayoutItemHitTestClass; override;
    function GetPainterClass: TdxCustomLayoutItemPainterClass; override;

    // Drawing attributes
    function CanDrawSpecificControls: Boolean; virtual;
    function GetColor: TColor; override;

    // Calculating
    function AutoAlignControls: Boolean; override;
    function CalculatePadding: TRect; override;
    procedure DoRightToLeftConversion(const AClientBounds: TRect); override;
    function GetAvailableTextAreaWidth: Integer; override;
    function InternalCalculateHeight: Integer; override;
    function InternalCalculateWidth: Integer; override;
    function DoCalculateHeight(ACalcSizeType: TdxLayoutCalcSizeType): Integer; override;
    function DoCalculateWidth(ACalcSizeType: TdxLayoutCalcSizeType): Integer; override;
    procedure Reset; override;

    // Dragging
    procedure CorrectDropAreaPart(const P: TPoint; var AAreaPart: TdxLayoutDropAreaPart);
    function GetDestinationItem(const ADropAreaInfo: TdxLayoutDragDropInfo): TdxCustomLayoutItem;
    function GetDropActionType(AAreaPart: TdxLayoutDropAreaPart): TdxLayoutActionType;
    function GetDropAreaPart(var P: TPoint): TdxLayoutDropAreaPart; override;
    function GetDropExpectedBounds(const ADropAreaInfo: TdxLayoutDragDropInfo): TRect;
    function GetDropExpectedAlign(const ADropAreaInfo: TdxLayoutDragDropInfo): TdxLayoutAlign; //override;
    function GetDropHorzAlignForLocale(const AHorzAlign: TdxLayoutAlignHorz): TdxLayoutAlignHorz;

    function CanFocusOnClick(X, Y: Integer): Boolean; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;

    // Conditions
    function HasCaption: Boolean; override;
    function HasBorder: Boolean; override;
    function HasButtons: Boolean;
    function HasExpandButton: Boolean;
    function IsDefaultColor: Boolean;
    function IsSkinPainterUsed: Boolean;
    function IsTransparent: Boolean; override;

    function IsEllipsisAllowed(AForDrawing: Boolean = False): Boolean; override;
    function IsWordWrapAllowed: Boolean; override;

    // TdxLayoutGroupViewInfo methods
    // Calculating
    procedure CalculateButtonsAreaBounds;// virtual;
    procedure CalculateCaptionAreaBounds;// virtual;
    procedure CalculateClientBounds; virtual;
    procedure CalculateItemsAreaBounds; virtual;
    procedure CalculateOffsets;
    procedure CalculateViewInfoBounds;
    procedure CalculateInternalViewInfos;
    function GetButtonsOffset: Integer; virtual;
    function GetButtonsSpace: Integer; virtual;
    function GetCaptionOffset: Integer; virtual;
    function GetSpaceBetweenButtons: Integer;
    function GetInscribedRect(const AInscribeRect: TRect): TRect;

    // Sizes
    function GetClientAreaBounds(const ABounds: TRect): TRect;
    function GetItemsAreaBounds(const AClientRect: TRect): TRect;
    function GetBorderWidth(ASide: TdxLayoutSide): Integer; virtual;
    function GetHeight(AItemsAreaHeight: Integer): Integer; virtual;
    function GetWidth(AItemsAreaWidth: Integer): Integer; virtual;
    function GetLevelingItemCaptionWidth(AItemViewInfo: TdxLayoutCellItemViewInfo; AMaxCaptionSize: Integer): Integer; virtual;
    function GetMinVisibleHeight: Integer; virtual;
    function GetMinVisibleWidth: Integer; virtual;
    function GetRestSpaceBounds: TRect;

    function CanAssignBounds(ASource: TdxCustomLayoutElementViewInfo): Boolean; override;
    procedure DoAssignBounds(ASource: TdxCustomLayoutElementViewInfo); override;
    procedure DoSetOffset(const AValue, ADiff: TPoint); override;

    function CanHandleMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean;
    procedure DoMajorScroll(Sender: TObject; AScrollCode: TScrollCode; var AScrollPos: Integer);
    procedure DoMinorScroll(Sender: TObject; AScrollCode: TScrollCode; var AScrollPos: Integer);
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; override;
    function IsMouseWheelHandleNeeded(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; override;
    function IsScrollBarsVisible: Boolean; virtual;
    procedure UpdateScrollPos(AMajor: Boolean);
    procedure MakeVisible(const ARect: TRect; AFully: Boolean); override;

    // Conditions
    function AllowChildHasBorder: Boolean;
    function AllowCollapsedHeight: Boolean; virtual;
    function AllowCollapsedWidth: Boolean; virtual;
    function AllowDrawChild(AChildViewInfo: TdxCustomLayoutItemViewInfo): Boolean; virtual;
    function AllowMajorScroll: Boolean;
    function AllowMinorScroll: Boolean;
    function GetChildInplaceRenameBounds(AChildViewInfo: TdxCustomLayoutItemViewInfo): TRect; virtual;
    function GetRotationAngle: TcxRotationAngle;
    function IsChildActuallyVisible(AChildViewInfo: TdxCustomLayoutItemViewInfo): Boolean;
    function IsExpanded: Boolean; override;
    function IsVerticalCaption: Boolean;
    function UseItemOffset: Boolean; virtual;
    function UseItemsAreaOffsets: Boolean; virtual;

    // Classes
    function GetSpecificClass: TdxLayoutGroupViewInfoSpecificClass; virtual;

    // Selections
    procedure PaintSelectionLayer(ABitmap: TcxAlphaBitmap; var ADrawingRect: TRect); override;

    // TabOrders
    function GetMaxTabOrder: Integer; override;

    property ButtonsOffset: Integer read GetButtonsOffset;
    property CaptionOffset: Integer read GetCaptionOffset;
    property ItemIndex: Integer read GetItemIndex;
    property ItemOffset: Integer index 0 read GetOffset write FItemOffset;
    property ItemsAreaOffsetHorz: Integer index 1 read GetOffset write FItemsAreaOffsetHorz;
    property ItemsAreaOffsetVert: Integer index 2 read GetOffset write FItemsAreaOffsetVert;
    property MinVisibleHeight: Integer read GetMinVisibleHeight;
    property MinVisibleWidth: Integer read GetMinVisibleWidth;
    property RestSpaceBounds: TRect read GetRestSpaceBounds;

    property CaptionSide: TdxLayoutSide read GetCaptionSide;
    property Group: TdxCustomLayoutGroup read GetGroup;
    property LayoutDirection: TdxLayoutDirection read GetLayoutDirection;
    property Options: TdxLayoutLookAndFeelGroupOptions read GetOptions;
    property Specific: TdxLayoutGroupViewInfoSpecific read FSpecific;
    property ViewData: TdxLayoutGroupViewData read GetViewData;
  public
    constructor Create(AContainerViewInfo: TdxLayoutContainerViewInfo; AParentViewInfo: TdxLayoutGroupViewInfo; AViewData: TdxCustomLayoutItemViewData); override;
    destructor Destroy; override;

    procedure Calculate(const ABounds: TRect); override;
    procedure CalculateInternalTabOrders(var AAvailableTabOrder: Integer); override;
    procedure CalculateTabOrders(var AAvailableTabOrder: Integer); override;

    function FindItemViewInfo(AItem: TdxCustomLayoutItem): TdxCustomLayoutItemViewInfo;
    function GetHitTest(const P: TPoint): TdxCustomLayoutHitTest; override;
    function GetItemWithMouse(const P: TPoint): TdxCustomLayoutItem; override;
    function GetInsertionPos(const P: TPoint): Integer; virtual;
    function HasScrollBars: Boolean;

    property BorderBounds[ASide: TdxLayoutSide]: TRect read GetBorderBounds;
    property BorderRestSpaceBounds[ASide: TdxLayoutSide]: TRect read GetBorderRestSpaceBounds;
    property BorderWidths[ASide: TdxLayoutSide]: Integer read GetBorderWidth;
    property BordersHeight: Integer read GetBordersHeight;
    property BordersWidth: Integer read GetBordersWidth;
    property ButtonsViewInfo: TdxLayoutGroupButtonsViewInfo read FButtonsViewInfo; // for internal use
    property CaptionViewInfo: TdxLayoutGroupCaptionViewInfo read GetCaptionViewInfo; // for internal use
    property ClientBounds: TRect read FClientAreaBounds;
    property ItemsAreaBounds: TRect read FItemsAreaBounds;
    property ItemViewInfoCount: Integer read GetItemViewInfoCount;
    property ItemViewInfos[Index: Integer]: TdxCustomLayoutItemViewInfo read GetItemViewInfo; // for internal use
  end;

  { TdxLayoutRootViewInfo }

  TdxLayoutRootViewInfo = class(TdxLayoutGroupViewInfo)
  protected
    function GetBackgroundColor: TColor; override;
  end;

  // control

  { TdxLayoutContainerViewInfo }

  TdxLayoutContainerViewInfo = class
  private
    FIsOnGlass: Boolean;
    FContainer: TdxLayoutContainer;
    FContentBounds: TRect;
    FIsOccupiedSizeCalculating: Boolean;
    FIsDragImagePainting: Boolean;
    FItemViewDataList: TdxLayoutItemViewDataList;
    FRootViewInfo: TdxLayoutRootViewInfo;
    FItemWithMouse: TdxCustomLayoutItem;
    FOffset: TPoint;
    FSelectionLayer: TdxSelectionLayer;

    procedure BuildSelectionLayer;
    procedure CreateSelectionLayer;
    function GetCanvas: TcxCanvas;
    function GetClientBounds: TRect;
    function GetContentBounds: TRect;
    function GetContentHeight: Integer;
    function GetContentWidth: Integer;
    function GetItemsViewInfo: TdxLayoutGroupViewInfo;
    function GetNormalContentWidth: Integer;
    procedure SelectionLayerHitTest(ASender: TObject; var AIsTransparent: Boolean);
    procedure SelectionLayerUpdate(Sender: TObject);
    procedure SelectionLayerEndRename(ASender: TObject; const AText: string; AAccept: Boolean);
    procedure SetItemWithMouse(Value: TdxCustomLayoutItem);
    procedure SetOffset(const Value: TPoint);
  protected
    FIsValid: Boolean;
    FNeedRecalculate: Boolean;
    FItemViewInfoDictionary: TDictionary<TdxCustomLayoutItem, TdxCustomLayoutItemViewInfo>;

    function CanShowGroupScrollBars: Boolean; virtual;
    procedure CreateViewInfos; virtual;
    function CreateItemViewInfo(AParentViewInfo: TdxLayoutGroupViewInfo; AItem: TdxCustomLayoutItem): TdxCustomLayoutItemViewInfo;
    procedure DestroyViewInfos; virtual;
    function GetRootViewInfoClass: TdxLayoutRootViewInfoClass; virtual;
    function GetLayoutLookAndFeel: TdxCustomLayoutLookAndFeel; virtual;
    function GetItemLayoutLookAndFeel(AViewInfo: TdxCustomLayoutItemViewInfo): TdxCustomLayoutLookAndFeel; virtual;
    function GetItemOptions(AViewInfo: TdxCustomLayoutItemViewInfo): TdxCustomLayoutLookAndFeelOptions; virtual;
    procedure MakeVisible(const ARect: TRect; AFully: Boolean);
    procedure PrepareData(ARecreateViewData: Boolean); virtual;
    procedure RecreateViewData; virtual;
    procedure RecreateViewInfos(ARecreateViewData: Boolean = False);

    function AlignItemsByConstraint: Boolean; virtual;
    function AutoAlignControls: Boolean; virtual;
    procedure CalculateItemsViewInfo; virtual;
    procedure CalculateContentBounds;
    procedure DoCalculate(AHard: Boolean = True);
    procedure DoCalculateInternalTabOrders; virtual;
    procedure DoCalculateTabOrders; virtual;
    function GetItemsParentBounds: TRect; virtual;
    function GetOwner2: IcxScrollbarOwner2; virtual;
    procedure ResetContentBounds;

    procedure InvalidateSelectionLayer(const R: TRect);
    function ShowHint(var AHintInfo: THintInfo; X, Y: Integer): Boolean;

    function CanUseCachedInfo: Boolean; virtual;
    function IsTransparent: Boolean;
    function IsTransparentBackground: Boolean;
    function IsActuallyVisible: Boolean; virtual;
    function IsDragImagePainting: Boolean; virtual;
    function NeedHighlightRoot: Boolean;

    procedure AssignBounds(ASource: TdxLayoutContainerViewInfo);
    function CanAssignBounds(ASource: TdxLayoutContainerViewInfo): Boolean; virtual;
    procedure DoAssignBounds(ASource: TdxLayoutContainerViewInfo); virtual;

    function GetViewData(AItem: TdxCustomLayoutItem): TdxCustomLayoutItemViewData;
    function GetViewDataClass(AItem: TdxCustomLayoutItem): TdxCustomLayoutItemViewDataClass; virtual;
    function FindCloneData(AItem: TdxCustomLayoutItem; out ACloneData: TdxCustomLayoutItemViewData): Boolean;

    function IsMouseWheelHandleNeeded(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; virtual;
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; virtual;
    function GetTouchScrollUIOwner(const APoint: TPoint): IdxTouchScrollUIOwner; virtual;

    property Canvas: TcxCanvas read GetCanvas;
    property IsOnGlass: Boolean read FIsOnGlass write FIsOnGlass;
    property ItemWithMouse: TdxCustomLayoutItem read FItemWithMouse write SetItemWithMouse;
    property ItemViewDataList: TdxLayoutItemViewDataList read FItemViewDataList;
    property SelectionLayer: TdxSelectionLayer read FSelectionLayer;

    property NormalContentWidth: Integer read GetNormalContentWidth;
  public
    constructor Create(AContainer: TdxLayoutContainer); virtual;
    destructor Destroy; override;

    procedure Calculate(ARecreateViewData: Boolean); virtual;
    procedure CalculateTabOrders; virtual;
    function FindItemViewInfo(AItem: TdxCustomLayoutItem; out AViewInfo: TdxCustomLayoutItemViewInfo): Boolean;
    function GetHitTest(const P: TPoint): TdxCustomLayoutHitTest; virtual;
    function GetItemViewInfo(AItem: TdxCustomLayoutItem): TdxCustomLayoutItemViewInfo; virtual;
    function GetItemWithMouse(const P: TPoint): TdxCustomLayoutItem;

    procedure AssignItemWithMouse(X, Y: Integer);
    function CanFocusOnClick(X, Y: Integer): Boolean; virtual;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure MouseLeave(AControl: TControl); virtual;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); virtual;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;

    procedure FinishDragImagePainting;
    procedure StartDragImagePainting;

    function GetScrollOffset: TPoint;

    property ClientBounds: TRect read GetClientBounds;
    property Container: TdxLayoutContainer read FContainer;
    property ContentBounds: TRect read GetContentBounds;
    property ContentHeight: Integer read GetContentHeight;
    property ContentWidth: Integer read GetContentWidth;
    property ItemsViewInfo: TdxLayoutGroupViewInfo read GetItemsViewInfo; // obsolete // for internal use
    property LayoutLookAndFeel: TdxCustomLayoutLookAndFeel read GetLayoutLookAndFeel;
    property Offset: TPoint read FOffset write SetOffset;
    property RootViewInfo: TdxLayoutRootViewInfo read FRootViewInfo; // for internal use
  end;

procedure dxDrawItemGlyph(ACanvas: TcxCanvas; AItem: TdxCustomLayoutItem;
  R: TRect; ARotationAngle: TcxRotationAngle; AColorPalette: IdxColorPalette = nil);

procedure dxLayoutSetItemStates(AContainer: TdxLayoutContainer; AUnwrapTabs, AActiveTabToTop, ASkipEmptyGroups, AExpandGroups: Boolean);
procedure dxLayoutStoreItemStates(AList: TList; AContainer: TdxLayoutContainer);
procedure dxLayoutRestoreItemStates(AList: TList; AContainer: TdxLayoutContainer);

function dxLayoutIsSameAlign(AAlign1, AAlign2: TdxLayoutAlign): Boolean;
function dxLayoutAlign(AHorz: TdxLayoutAlignHorz; AVert: TdxLayoutAlignVert): TdxLayoutAlign;

const
  dxDefaultLayoutCustomizeFormMenuItems = [cfmiAlignHorz..cfmiRename];

var
  dxLayoutRunTimeSelectionHelperClass: TdxLayoutRunTimeSelectionHelperClass;

implementation

uses
  Types, TypInfo, Registry, Math, Variants, UxTheme, Themes,
  cxContainer, dxOffice11, cxButtons, dxDPIAwareUtils, cxCheckBox, dxThemeManager, cxPCPaintersFactory,
  dxLayoutControlAdapters, dxLayoutCustomizeForm, dxLayoutStrs, dxLayoutDragAndDrop, cxDrawTextUtils, cxEditUtils,
  dxLayoutControl, dxFormattedTextConverterBBCode, dxFormattedTextConverterRTF, dxStringHelper, dxTypeHelpers;

const
  dxThisUnitName = 'dxLayoutContainer';

type
  TControlAccess = class(TControl);
  TWinControlAccess = class(TWinControl);
  TcxControlAccess = class(TcxControl);
//  TcxContainerAccess = class(TcxContainer);
  TdxCustomLayoutLookAndFeelAccess = class(TdxCustomLayoutLookAndFeel);
  TcxTabAccess = class(TcxTab);
  TdxScrollBarWrapperAccess = class(TdxScrollBarWrapper);
  TdxSmartGlyphAccess = class(TdxSmartGlyph);
  TcxCustomCheckBoxViewInfoAccess = class(TcxCustomCheckBoxViewInfo);

  TdxLayoutItemCacheState = class
  public
    Expanded: Boolean;
    Direction: TdxLayoutDirection;
    Index: Integer;
    Item: TdxCustomLayoutItem;
    ItemIndex: Integer;
    Visible: Boolean;
    HorizontalScrolling: TdxLayoutGroupScrollMode;
    VerticalScrolling: TdxLayoutGroupScrollMode;
  end;

const
  dxLayoutHiddenGroupBackgroundDefaultColor: TColor = $F0E3D1;
  dxLayoutSelectionOffset = 2;
  dxLayoutGlyphSpace = 4;
  dxLayoutSelectionMarkerWidth = 5;
  dxLayoutEmptySpaceMinimumSize = 2;

  dxLayoutNoActiveItem = -1;
  dxLayoutPseudoActiveItem = -2;

  dxLayoutInitialLoadedItemIndex = -2;

  dxLoadingFlags = [csReading, csLoading, csUpdating];

  lcStoredProperties: array[0..11] of string = (
    'IsUserDefined', 'ParentName', 'Index', 'AlignHorz', 'AlignVert',
    'Width', 'Height', 'IsFloat', 'FloatPosX', 'FloatPosY', 'TakeoffParent', 'TakeoffIndex');

  dxFocusRectReservedThickness = 1;

type
  { TdxLayoutBasicItemReader }

  TdxLayoutBasicItemReaderClass = class of TdxLayoutBasicItemReader;
  TdxLayoutBasicItemReader = class
  protected
    class procedure LoadCaption(AItem: TdxCustomLayoutItem; AIniFile: TCustomIniFile; const ASection: string); virtual;
  public
    class procedure LoadFromIni(AItem: TdxCustomLayoutItem; AIniFile: TCustomIniFile; const ASection: string); virtual;
  end;

  { TdxLayoutBasicItemReader2 }

  TdxLayoutBasicItemReader2 = class(TdxLayoutBasicItemReader)
  public
    class procedure LoadFromIni(AItem: TdxCustomLayoutItem; AIniFile: TCustomIniFile; const ASection: string); override;
  end;

  { TdxLayoutBasicItemReader3 }

  TdxLayoutBasicItemReader3 = class(TdxLayoutBasicItemReader2)
  protected
    class procedure LoadCaption(AItem: TdxCustomLayoutItem; AIniFile: TCustomIniFile; const ASection: string); override;
  public
    class procedure LoadFromIni(AItem: TdxCustomLayoutItem; AIniFile: TCustomIniFile; const ASection: string); override;
  end;

  { TdxLayoutGroupReader }

  TdxLayoutGroupReaderClass = class of TdxLayoutGroupReader;
  TdxLayoutGroupReader = class
  public
    class procedure LoadFromIni(AGroup: TdxCustomLayoutGroup; AIniFile: TCustomIniFile; const ASection: string); virtual;
  end;

  { TdxLayoutGroupReader2 }

  TdxLayoutGroupReader2 = class(TdxLayoutGroupReader)
  public
    class procedure LoadFromIni(AGroup: TdxCustomLayoutGroup; AIniFile: TCustomIniFile; const ASection: string); override;
  end;

  { TdxLayoutGroupReader3 }

  TdxLayoutGroupReader3 = class(TdxLayoutGroupReader2)
  public
    class procedure LoadFromIni(AGroup: TdxCustomLayoutGroup; AIniFile: TCustomIniFile; const ASection: string); override;
  end;

  { TdxLayoutBasicItemWriter }

  TdxLayoutBasicItemWriter = class
  protected
    class procedure SaveCaption(AItem: TdxCustomLayoutItem; AIniFile: TCustomIniFile; const ASection: string); virtual;
  public
    class procedure SaveToIni(AItem: TdxCustomLayoutItem; AIniFile: TCustomIniFile; const ASection: string);
  end;

  { TdxLayoutGroupWriter }

  TdxLayoutGroupWriter = class
  public
    class procedure SaveToIni(AGroup: TdxCustomLayoutGroup; AIniFile: TCustomIniFile; const ASection: string);
  end;

function TdxAbsRect.GetSize: TdxAbsSize;
begin
  Result.Major := FarMajor - NearMajor;
  Result.Minor := FarMinor - NearMinor;
end;

function TdxAbsRect.GetNearPoint: TdxAbsPoint;
begin
  Result.Major := NearMajor;
  Result.Minor := NearMinor;
end;

procedure TdxAbsRect.SetNearPoint(const AValue: TdxAbsPoint);
begin
  NearMajor := AValue.Major;
  NearMinor := AValue.Minor;
end;

function TdxAbsRect.GetFarPoint: TdxAbsPoint;
begin
  Result.Major := FarMajor;
  Result.Minor := FarMinor;
end;

procedure TdxAbsRect.SetFarPoint(const AValue: TdxAbsPoint);
begin
  FarMajor := AValue.Major;
  FarMinor := AValue.Minor;
end;

function GetPropertyIndex(const APropertyName: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Length(lcStoredProperties) - 1 do
    if lcStoredProperties[I] = APropertyName then
    begin
      Result := I;
      Break;
    end;
end;

function GetGroupWidth(AGroup: TdxCustomLayoutGroup): Integer; forward;
function GetGroupHeight(AGroup: TdxCustomLayoutGroup): Integer; forward;

function GetItemOffset(AGroup: TdxCustomLayoutGroup): Integer;
begin
  while AGroup.ViewInfo = nil do
    AGroup := AGroup.Parent;
  Result := AGroup.ViewInfo.ItemOffset;
end;

function GetMinHeight(AItem: TdxCustomLayoutItem): Integer;

  function GetGroupMinHeight(AGroup: TdxCustomLayoutGroup): Integer;
  var
    I: Integer;
  begin
    Result := 0;
    for I := 0 to AGroup.Count - 1 do
      Result := Max(Result, GetMinHeight(AGroup[I]));
    if not AGroup.Hidden then
      Result := AGroup.ViewInfo.GetHeight(Result);
  end;

begin
  if not AItem.Visible or AItem.IsClosedBySplitter then
    Result := 0
  else
    if AItem.IsGroup then
      Result := GetGroupMinHeight(AItem.AsGroup)
    else
      if AItem.ViewInfo <> nil then
        Result := AItem.ViewInfo.CalculateHeight
      else
        Result := 0
end;

function GetMaxWidth(AItem: TdxCustomLayoutItem): Integer;

  function GetGroupMaxContentWidth(AGroup: TdxCustomLayoutGroup): Integer;
  var
    I: Integer;
    AWidth, AOffset: Integer;
  begin
    Result := 0;
    AOffset := GetItemOffset(AGroup);
    for I := 0 to AGroup.Count - 1 do
    begin
      AWidth := GetMaxWidth(AGroup[I]);
      if AWidth > 0 then
      begin
        Result := Result + AWidth;
        if I > 0 then
          Result := Result + AOffset;
      end;
    end;
  end;

  function GetGroupMaxWidth(AGroup: TdxCustomLayoutGroup): Integer;
  begin
    Result := GetGroupMaxContentWidth(AGroup);
    if not AGroup.Hidden then
      Result := AGroup.ViewInfo.GetWidth(Result);
  end;

begin
  if not AItem.Visible or AItem.IsClosedBySplitter then
    Result := 0
  else
    if AItem.IsGroup then
      Result := GetGroupMaxWidth(AItem.AsGroup)
    else
      if AItem.ViewInfo <> nil then    
        Result := AItem.ViewInfo.CalculateWidth
      else
        Result := 0;
end;

function GetWidth(AItem: TdxCustomLayoutItem): Integer;
begin
  if not AItem.Visible or AItem.IsClosedBySplitter then
    Result := 0
  else
    if AItem.IsGroup then
      Result := GetGroupWidth(AItem.AsGroup)
    else
      if AItem.ViewInfo <> nil then    
        Result := AItem.ViewInfo.CalculateWidth
      else
        Result := 0;
end;

function GetHeight(AItem: TdxCustomLayoutItem): Integer;
begin
  if not AItem.Visible or AItem.IsClosedBySplitter then
    Result := 0
  else
    if AItem.IsGroup then
      Result := GetGroupHeight(AItem.AsGroup)
    else
      if AItem.ViewInfo <> nil then    
        Result := AItem.ViewInfo.CalculateHeight
      else
        Result := 0;
end;

function GetGroupContentWidth(AGroup: TdxCustomLayoutGroup): Integer;
var
  I: Integer;
  AWidth, AOffset: Integer;
begin
  Result := 0;
  if AGroup.LayoutDirection = ldHorizontal then
  begin
    AOffset := GetItemOffset(AGroup);
    for I := 0 to AGroup.Count - 1 do
    begin
      AWidth := GetWidth(AGroup[I]);
      if AWidth > 0 then
      begin
        Result := Result + AWidth;
        if I > 0 then
          Result := Result + AOffset;
      end;
    end;
  end
  else
    for I := 0 to AGroup.Count - 1 do
      Result := Max(Result, GetWidth(AGroup[I]));
end;

function GetGroupFreeSpace(AGroup: TdxCustomLayoutGroup): Integer;
begin
  Result := AGroup.ViewInfo.ItemsAreaBounds.Width - GetGroupContentWidth(AGroup);
end;

function GetFreeSpaceForItem(AItem: TdxCustomLayoutItem): Integer;

  function FindNearestVerticalParent(AGroup: TdxCustomLayoutGroup): TdxCustomLayoutGroup;
  begin
//    if AGroup.IsRoot or (AGroup = nil) then
//      Result := Group.Container.Root
//    else
    if AGroup.IsRoot or (AGroup.LayoutDirection <> ldHorizontal) then
      Result := AGroup
    else
      Result := FindNearestVerticalParent(AGroup.Parent);
  end;

  function GetNearestFreeSpace(AItem: TdxCustomLayoutItem): Integer;
  begin
    if AItem.Parent.LayoutDirection = ldVertical then
      Result := AItem.Parent.ViewInfo.ItemsAreaBounds.Width - AItem.ViewInfo.MinWidth
    else
      Result := AItem.Parent.ViewInfo.ItemsAreaBounds.Width - GetGroupContentWidth(AItem.Parent) + (AItem.ViewInfo.UsualWidth - AItem.ViewInfo.MinWidth);
  end;

var
  ANearestVerticalParent: TdxCustomLayoutGroup;
begin
  ANearestVerticalParent := AItem.Container.Root;

  Result := 0;
  repeat
    Inc(Result, GetNearestFreeSpace(AItem));
    AItem := AItem.Parent;
  until AItem = ANearestVerticalParent;
end;

function GetGroupWidth(AGroup: TdxCustomLayoutGroup): Integer;
begin
  Result := AGroup.SizeOptions.Width;
  if Result = 0 then
  begin
    Result := GetGroupContentWidth(AGroup);
    if not AGroup.Hidden then
      Result := AGroup.ViewInfo.GetWidth(Result);
  end;
end;

function GetGroupHeight(AGroup: TdxCustomLayoutGroup): Integer;
var
  I: Integer;
  AHeight, AOffset: Integer;
begin
  Result := 0;
  if AGroup.LayoutDirection = ldVertical then
  begin
    AOffset := GetItemOffset(AGroup);
    for I := 0 to AGroup.Count - 1 do
      begin
        AHeight := GetHeight(AGroup[I]);
        if AHeight > 0 then
        begin
          Result := Result + AHeight;
          if I > 0 then
            Result := Result + AOffset;
        end;
      end;
  end
  else
    for I := 0 to AGroup.Count - 1 do
      Result := Max(Result, GetHeight(AGroup[I]));

  if not AGroup.Hidden then
    Result := AGroup.ViewInfo.GetHeight(Result);
end;

function dxLayoutIsSameAlign(AAlign1, AAlign2: TdxLayoutAlign): Boolean;
begin
  Result := (AAlign1.Horz = AAlign2.Horz) and (AAlign1.Vert = AAlign2.Vert);
end;

function dxLayoutAlign(AHorz: TdxLayoutAlignHorz; AVert: TdxLayoutAlignVert): TdxLayoutAlign;
begin
  Result.Horz := AHorz;
  Result.Vert := AVert;
end;

function dxGetSelectionMarker(const P: TPoint; AMarkerWidth: Integer): TRect;
begin
  Result := cxRectInflate(cxRect(P, P), (AMarkerWidth - 1) div 2, (AMarkerWidth - 1) div 2);
  Inc(Result.Bottom);
  Inc(Result.Right);
end;

function dxGetSelectionMarkers(const ABorderBounds: TRect; AMarkerWidth: Integer): TRects;
var
  AMiddleX, AMiddleY: Integer;
begin
  SetLength(Result, 8);
  with ABorderBounds do
  begin
    AMiddleX := (Left + Right - 1) div 2;
    AMiddleY := (Top + Bottom - 1) div 2;
    Result[0] := dxGetSelectionMarker(TopLeft, AMarkerWidth);
    Result[1] := dxGetSelectionMarker(Point(AMiddleX, Top), AMarkerWidth);
    Result[2] := dxGetSelectionMarker(Point(Right - 1, Top), AMarkerWidth);
    Result[3] := dxGetSelectionMarker(Point(Right - 1, AMiddleY), AMarkerWidth);
    Result[4] := dxGetSelectionMarker(Point(Right - 1, Bottom - 1), AMarkerWidth);
    Result[5] := dxGetSelectionMarker(Point(AMiddleX, Bottom - 1), AMarkerWidth);
    Result[6] := dxGetSelectionMarker(Point(Left, Bottom - 1), AMarkerWidth);
    Result[7] := dxGetSelectionMarker(Point(Left, AMiddleY), AMarkerWidth);
  end;
end;

procedure dxDrawItemGlyph(ACanvas: TcxCanvas; AItem: TdxCustomLayoutItem;
  R: TRect; ARotationAngle: TcxRotationAngle; AColorPalette: IdxColorPalette = nil);

  function GetDrawMode(AGlyph: TdxSmartGlyph; AImages: TCustomImageList): TcxImageDrawMode;
  var
    ADrawEnabled: Boolean;
  begin
    ADrawEnabled := AItem.Enabled or (not IsGlyphAssigned(AGlyph) and (AImages = AItem.Container.GetDisabledImages));
    Result := EnabledImageDrawModeMap[ADrawEnabled];
  end;

var
  ABitmap: TcxAlphaBitmap;
  AGlyph: TdxSmartGlyph;
  AImageIndex: Integer;
  AImages: TCustomImageList;
begin
  if AItem.CaptionOptions.ImageOptions.GetCurrentImage(AGlyph, AImages, AImageIndex) then
  begin
    if ARotationAngle = ra0 then
      TdxImageDrawer.DrawUncachedImage(ACanvas.Handle, R, R, AGlyph, AImages, AImageIndex,
        GetDrawMode(AGlyph, AImages), True, 0, clNone, True, AColorPalette)
    else
    begin
      ABitmap := TcxAlphaBitmap.CreateSize(R, True);
      try
        TdxImageDrawer.DrawUncachedImage(ABitmap.cxCanvas.Handle, ABitmap.ClientRect, ABitmap.ClientRect, AGlyph,
          AImages, AImageIndex, GetDrawMode(AGlyph, AImages), True, 0, clNone, True, AColorPalette);
        ABitmap.Rotate(ARotationAngle);
        TdxImageDrawer.DrawUncachedImage(ACanvas.Handle, R, R, ABitmap, nil, -1, idmNormal);
      finally
        ABitmap.Free;
      end;
    end;
  end;
end;

procedure dxLayoutSetItemStates(AContainer: TdxLayoutContainer; AUnwrapTabs, AActiveTabToTop, ASkipEmptyGroups, AExpandGroups: Boolean);

  procedure SetItemState(AItem: TdxCustomLayoutItem);
  var
    AGroup: TdxCustomLayoutGroup;
    I: Integer;
  begin
    if AItem.IsGroup then
    begin
      AGroup := AItem.AsGroup;
      if AExpandGroups then
        AGroup.Expanded := True;
      AGroup.ScrollOptions.Horizontal := smNone;
      AGroup.ScrollOptions.Vertical := smNone;
      if AGroup.LayoutDirection = ldTabbed then
      begin
        AGroup.LayoutDirection := ldVertical;
        if not AUnwrapTabs then
          for I := 0 to AGroup.Count - 1 do
            if AGroup[I].Visible and (AGroup.ItemIndex <> AGroup[I].Index) then
              AGroup[I].Visible := False;
        if AActiveTabToTop then
          AGroup.Items[AGroup.ItemIndex].Index := 0;
      end;
      if ASkipEmptyGroups then
        for I := 0 to AGroup.VisibleCount - 1 do
          if AGroup.VisibleItems[I].IsGroup and (AGroup.VisibleItems[I].AsGroup.VisibleCount = 0) then
            AGroup.VisibleItems[I].Visible := False;
      for I := 0 to AGroup.VisibleCount - 1 do
        SetItemState(AGroup.VisibleItems[I]);
    end;
  end;

begin
  AContainer.BeginUpdate;
  try
    AContainer.Root.BuildVisibleItemsList(True);
    SetItemState(AContainer.Root);
  finally
    AContainer.CancelUpdate;
    AContainer.DoCalculateRoot(False);
    AContainer.ApplyCalculatedChanges;
  end;
end;

procedure dxLayoutStoreItemStates(AList: TList; AContainer: TdxLayoutContainer);

  procedure StoreItemState(AItem: TdxCustomLayoutItem);
  var
    ACacheItem: TdxLayoutItemCacheState;
    I: Integer;
    AGroup: TdxCustomLayoutGroup;
  begin
    ACacheItem := TdxLayoutItemCacheState.Create;
    AList.Add(ACacheItem);
    ACacheItem.Item := AItem;
    if (AItem.Parent <> nil) and (AItem.Parent.LayoutDirection = ldTabbed) then
      ACacheItem.Index := AItem.Index
    else
      ACacheItem.Index := -1;
    ACacheItem.Visible := AItem.Visible;
    if AItem.IsGroup then
    begin
      AGroup := AItem.AsGroup;
      ACacheItem.Direction := AGroup.LayoutDirection;
      ACacheItem.Expanded := AGroup.Expanded;
      ACacheItem.ItemIndex := AGroup.ItemIndex;
      ACacheItem.HorizontalScrolling := AGroup.ScrollOptions.Horizontal;
      ACacheItem.VerticalScrolling := AGroup.ScrollOptions.Vertical;
      for I := 0 to AGroup.Count - 1 do
        StoreItemState(AGroup[I]);
    end;
  end;

begin
  AContainer.UnclenchWrappingGroup(AContainer.Root);
  StoreItemState(AContainer.Root);
end;

procedure dxLayoutRestoreItemStates(AList: TList; AContainer: TdxLayoutContainer);
var
  I: Integer;
  ACacheItem: TdxLayoutItemCacheState;
  AItem: TdxCustomLayoutItem;
  AGroup: TdxCustomLayoutGroup;
begin
  AContainer.UnclenchWrappingGroup(AContainer.Root);
  for I := 0 to AList.Count - 1 do
  begin
    ACacheItem := TdxLayoutItemCacheState(AList.List[I]);
    AItem := ACacheItem.Item;
    if ACacheItem.Index <> -1 then
      AItem.Index := ACacheItem.Index;
    AItem.Visible := ACacheItem.Visible;
    if AItem.IsGroup then
    begin
      AGroup := AItem.AsGroup;
      AGroup.LayoutDirection := ACacheItem.Direction;
      AGroup.Expanded := ACacheItem.Expanded;
      AGroup.ItemIndex := ACacheItem.ItemIndex;
      AGroup.ScrollOptions.Horizontal := ACacheItem.HorizontalScrolling;
      AGroup.ScrollOptions.Vertical := ACacheItem.VerticalScrolling;
    end;
  end;
end;

function dxIsValueInDiapason(AValue, ABound1, ABound2: Integer; AIncludeBounds: Boolean = True): Boolean;
begin
  if AIncludeBounds then
    Result := (AValue >= ABound1) and (AValue <= ABound2)
  else
    Result := (AValue > ABound1) and (AValue < ABound2)
end;

type
  { TdxLayoutControlAdapterDefs }

  PControlAdapterRecord = ^TControlAdapterRecord;
  TControlAdapterRecord = record
    ControlClass: TControlClass;
    AdapterClass: TdxCustomLayoutControlAdapterClass;
  end;

  TdxLayoutControlAdapterDefs = class
  private
    FItems: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TControlAdapterRecord;
    procedure ClearItems;
  protected
    procedure Delete(AIndex: Integer);
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TControlAdapterRecord read GetItem;
  public
    constructor Create;
    destructor Destroy; override;
    function GetAdapterClass(AControl: TControl): TdxCustomLayoutControlAdapterClass;
    procedure Register(AControlClass: TControlClass; AAdapterClass: TdxCustomLayoutControlAdapterClass);
    procedure Unregister(AControlClass: TControlClass; AAdapterClass: TdxCustomLayoutControlAdapterClass);
  end;

var
  FdxLayoutControlAdapterDefs: TdxLayoutControlAdapterDefs;

function dxLayoutControlAdapterDefs: TdxLayoutControlAdapterDefs;
begin
  if FdxLayoutControlAdapterDefs = nil then
    FdxLayoutControlAdapterDefs := TdxLayoutControlAdapterDefs.Create;
  Result := FdxLayoutControlAdapterDefs;
end;

function dxLayoutGetCenterAreaBounds(const AItemBounds: TRect; APart: Integer = 4): TRect;
begin
  Result := AItemBounds;
  with Result do
    InflateRect(Result, -(Right - Left) div APart, -(Bottom - Top) div APart);
end;

{ TdxLayoutControlAdapterDefs }

constructor TdxLayoutControlAdapterDefs.Create;
begin
  inherited;
  FItems := TList.Create;
end;

destructor TdxLayoutControlAdapterDefs.Destroy;
begin
  ClearItems;
  FItems.Free;
  inherited;
end;

function TdxLayoutControlAdapterDefs.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TdxLayoutControlAdapterDefs.GetItem(Index: Integer): TControlAdapterRecord;
begin
  Result := PControlAdapterRecord(FItems.List[Index])^;
end;

procedure TdxLayoutControlAdapterDefs.ClearItems;
var
  I: Integer;
begin
  for I := Count - 1 downto 0 do
    Delete(I);
end;

procedure TdxLayoutControlAdapterDefs.Delete(AIndex: Integer);
begin
  Dispose(PControlAdapterRecord(FItems[AIndex]));
  FItems.Delete(AIndex);
end;

function TdxLayoutControlAdapterDefs.GetAdapterClass(AControl: TControl): TdxCustomLayoutControlAdapterClass;
var
  I: Integer;
  AControlAdapterRecord: TControlAdapterRecord;
begin
  for I := Count - 1 downto 0 do
  begin
    AControlAdapterRecord := Items[I];
    if AControl.InheritsFrom(AControlAdapterRecord.ControlClass) then
    begin
      Result := AControlAdapterRecord.AdapterClass;
      Exit;
    end;
  end;
  Result := TdxCustomLayoutControlAdapter;
end;

procedure TdxLayoutControlAdapterDefs.Register(AControlClass: TControlClass;
  AAdapterClass: TdxCustomLayoutControlAdapterClass);
var
  AControlAdapterRecord: PControlAdapterRecord;
begin
  New(AControlAdapterRecord);
  with AControlAdapterRecord^ do
  begin
    ControlClass := AControlClass;
    AdapterClass := AAdapterClass;
  end;
  FItems.Add(AControlAdapterRecord);
end;

procedure TdxLayoutControlAdapterDefs.Unregister(AControlClass: TControlClass;
  AAdapterClass: TdxCustomLayoutControlAdapterClass);
var
  I: Integer;
  AControlAdapterRecord: TControlAdapterRecord;
begin
  for I := 0 to Count - 1 do
  begin
    AControlAdapterRecord := Items[I];
    with AControlAdapterRecord do
      if (ControlClass = AControlClass) and (AdapterClass = AAdapterClass) then
      begin
        Delete(I);
        Break;
      end;
  end;
  if Count = 0 then
    FreeAndNil(FdxLayoutControlAdapterDefs);
end;

{ TdxLayoutBasicItemReader }

class procedure TdxLayoutBasicItemReader.LoadCaption(AItem: TdxCustomLayoutItem; AIniFile: TCustomIniFile; const ASection: string);
begin
  AItem.Caption := AIniFile.ReadString(ASection, 'Caption', AItem.Caption);
end;

class procedure TdxLayoutBasicItemReader.LoadFromIni(AItem: TdxCustomLayoutItem; AIniFile: TCustomIniFile; const ASection: string);
begin
  LoadCaption(AItem, AIniFile, ASection);
end;

{ TdxLayoutBasicItemReader2 }

class procedure TdxLayoutBasicItemReader2.LoadFromIni(AItem: TdxCustomLayoutItem; AIniFile: TCustomIniFile; const ASection: string);

  function ReadScaledValue(const ASection, AIdent: string; ADefaultValue: Integer): Integer;
  begin
    if AIniFile.ValueExists(ASection, AIdent) then
      Result := AItem.ScaleFactor.Apply(AIniFile.ReadInteger(ASection, AIdent, AItem.ScaleFactor.Revert(ADefaultValue)))
    else
      Result := ADefaultValue;
  end;

begin
  inherited;
  AItem.AlignHorz := TdxLayoutAlignHorz(AIniFile.ReadInteger(ASection, 'AlignHorz', Integer(AItem.AlignHorz)));
  AItem.AlignVert := TdxLayoutAlignVert(AIniFile.ReadInteger(ASection, 'AlignVert', Integer(AItem.AlignVert)));

  AItem.Width := ReadScaledValue(ASection, 'Width', AItem.Width);
  AItem.Height := ReadScaledValue(ASection, 'Height', AItem.Height);

  AItem.CaptionOptions.AlignHorz := TAlignment(AIniFile.ReadInteger(ASection, 'CaptionAlignHorz', Integer(AItem.CaptionOptions.AlignHorz)));
  AItem.CaptionOptions.AlignVert := TdxAlignmentVert(AIniFile.ReadInteger(ASection, 'CaptionAlignVert', Integer(AItem.CaptionOptions.AlignVert)));
  AItem.CaptionOptions.Layout := TdxCaptionLayout(AIniFile.ReadInteger(ASection, 'CaptionLayout', Integer(AItem.CaptionOptions.Layout)));
end;

{ TdxLayoutBasicItemReader3 }

class procedure TdxLayoutBasicItemReader3.LoadCaption(AItem: TdxCustomLayoutItem; AIniFile: TCustomIniFile; const ASection: string);
var
  ACaption: string;
begin
  ACaption := AIniFile.ReadString(ASection, 'Caption', AItem.Caption);
  if cxIsQuotedStr(ACaption) then
    AItem.Caption := cxDequotedStr(ACaption)
  else
    AItem.Caption := ACaption;
end;

class procedure TdxLayoutBasicItemReader3.LoadFromIni(AItem: TdxCustomLayoutItem; AIniFile: TCustomIniFile; const ASection: string);
begin
  inherited;
  AItem.CaptionOptions.Visible := AIniFile.ReadBool(ASection, 'ShowCaption', AItem.CaptionOptions.Visible);
end;

{ TdxLayoutGroupReader }

class procedure TdxLayoutGroupReader.LoadFromIni(AGroup: TdxCustomLayoutGroup; AIniFile: TCustomIniFile; const ASection: string);
begin
  AGroup.Hidden := AIniFile.ReadBool(ASection, 'Hidden', AGroup.Hidden);
  AGroup.LayoutDirection := TdxLayoutDirection(AIniFile.ReadInteger(ASection, 'LayoutDirection', Integer(AGroup.LayoutDirection)));
end;

{ TdxLayoutGroupReader2 }

class procedure TdxLayoutGroupReader2.LoadFromIni(AGroup: TdxCustomLayoutGroup; AIniFile: TCustomIniFile; const ASection: string);
begin
  inherited;
  AGroup.ItemIndex := AIniFile.ReadInteger(ASection, 'ItemIndex', AGroup.ItemIndex);
  AGroup.Expanded := AIniFile.ReadBool(ASection, 'Expanded', AGroup.Expanded);
  AGroup.ShowBorder := AIniFile.ReadBool(ASection, 'ShowBorder', AGroup.ShowBorder);
end;

{ TdxLayoutGroupReader3 }

class procedure TdxLayoutGroupReader3.LoadFromIni(AGroup: TdxCustomLayoutGroup; AIniFile: TCustomIniFile; const ASection: string);
begin
  inherited;
  AGroup.ButtonOptions.ShowExpandButton := AIniFile.ReadBool(ASection, 'ShowExpandButton', False);
  AGroup.ButtonOptions.CheckBox.Checked := AIniFile.ReadBool(ASection, 'CheckBoxChecked', True);
end;

{ TdxLayoutBasicItemWriter }

class procedure TdxLayoutBasicItemWriter.SaveCaption(AItem: TdxCustomLayoutItem; AIniFile: TCustomIniFile; const ASection: string);
begin
  AIniFile.WriteString(ASection, 'Caption', cxQuotedStr(AItem.Caption));
end;

class procedure TdxLayoutBasicItemWriter.SaveToIni(AItem: TdxCustomLayoutItem; AIniFile: TCustomIniFile; const ASection: string);

  function GetParentName: string;
  begin
    if AItem.Parent <> nil then
      Result := AItem.Parent.Name
    else
      Result := '';
  end;

begin
  SaveCaption(AItem, AIniFile, ASection);

  AIniFile.WriteString(ASection, 'Name', AItem.Name);
  AIniFile.WriteBool(ASection, 'IsUserDefined', AItem.IsUserDefined);
  AIniFile.WriteString(ASection, 'ParentName', GetParentName);
  AIniFile.WriteInteger(ASection, 'Index', AItem.Index);
  AIniFile.WriteInteger(ASection, 'AlignHorz', Integer(AItem.AlignHorz));
  AIniFile.WriteInteger(ASection, 'AlignVert', Integer(AItem.AlignVert));
  AIniFile.WriteInteger(ASection, 'Width', AItem.ScaleFactor.Revert(AItem.Width));
  AIniFile.WriteInteger(ASection, 'Height', AItem.ScaleFactor.Revert(AItem.Height));
  AIniFile.WriteInteger(ASection, 'ItemClassKind', AItem.GetItemClassKind);

  if (AItem.CaptionOptions is TdxLayoutLabeledItemCaptionOptions) or (AItem.CaptionOptions is TdxLayoutGroupCaptionOptions) then
  begin
    AIniFile.WriteBool(ASection, 'ShowCaption', AItem.CaptionOptions.Visible);
    AIniFile.WriteInteger(ASection, 'CaptionAlignHorz', Integer(AItem.CaptionOptions.AlignHorz));
    AIniFile.WriteInteger(ASection, 'CaptionAlignVert', Integer(AItem.CaptionOptions.AlignVert));
    AIniFile.WriteInteger(ASection, 'CaptionLayout', Integer(AItem.CaptionOptions.Layout));
  end;
end;

{ TdxLayoutGroupWriter }

class procedure TdxLayoutGroupWriter.SaveToIni(AGroup: TdxCustomLayoutGroup; AIniFile: TCustomIniFile; const ASection: string);
begin
  AIniFile.WriteBool(ASection, 'Hidden', AGroup.Hidden);
  AIniFile.WriteInteger(ASection, 'LayoutDirection', Integer(AGroup.LayoutDirection));
  AIniFile.WriteInteger(ASection, 'ItemIndex', AGroup.ItemIndex);
  AIniFile.WriteBool(ASection, 'Expanded', AGroup.Expanded);
  AIniFile.WriteBool(ASection, 'ShowBorder', AGroup.ShowBorder);
  AIniFile.WriteBool(ASection, 'ShowExpandButton', AGroup.ButtonOptions.ShowExpandButton);
  AIniFile.WriteBool(ASection, 'CheckBoxChecked', AGroup.ButtonOptions.CheckBox.Checked);
end;

{ TdxLayoutAlignmentConstraint }

constructor TdxLayoutAlignmentConstraint.Create(AOwner: TComponent);
begin
  inherited;
  CreateItems;
end;

destructor TdxLayoutAlignmentConstraint.Destroy;
begin
  DestroyItems;
  inherited;
end;

function TdxLayoutAlignmentConstraint.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TdxLayoutAlignmentConstraint.GetItem(Index: Integer): TdxCustomLayoutItem;
begin
  Result := TdxCustomLayoutItem(FItems.List[Index]);
end;

procedure TdxLayoutAlignmentConstraint.SetKind(Value: TdxLayoutAlignmentConstraintKind);
begin
  if FKind <> Value then
  begin
    FKind := Value;
    Changed;
  end;
end;

procedure TdxLayoutAlignmentConstraint.CreateItems;
begin
  FItems := TList.Create;
end;

procedure TdxLayoutAlignmentConstraint.DestroyItems;
var
  I: Integer;
begin
  BeginUpdate;
  try
    for I := Count - 1 downto 0 do
      RemoveItem(Items[I]);
  finally
    EndUpdate;
  end;
  FreeAndNil(FItems);
end;

procedure TdxLayoutAlignmentConstraint.InternalAddItem(AItem: TdxCustomLayoutItem);
begin
  FItems.Add(AItem);
end;

procedure TdxLayoutAlignmentConstraint.InternalRemoveItem(AItem: TdxCustomLayoutItem);
begin
  FItems.Remove(AItem);
  if not (csDestroying in ComponentState) and (Count < 2) then
    Free;
end;

function TdxLayoutAlignmentConstraint.AreItemViewInfosAligned(ACount: Integer): Boolean;
var
  I, ABorderValue: Integer;
begin
  ABorderValue := 0;

  for I := 0 to ACount - 1 do
    if Items[I].IsViewInfoValid then
    begin
      ABorderValue := GetBorderValue(I);
      Break;
    end;

  Result := True;
  for I := 0 to ACount - 1 do
    Result := Result and ((Items[I].ViewInfo = nil) or (GetBorderValue(I) = ABorderValue));
end;

procedure TdxLayoutAlignmentConstraint.AlignItemViewInfos(ACount: Integer);
var
  AMostBorderValue, I: Integer;
begin
  AMostBorderValue := GetMostBorderValue(ACount);
  for I := 0 to ACount - 1 do
    ChangeOffset(I, AMostBorderValue - GetBorderValue(I));
end;

procedure TdxLayoutAlignmentConstraint.ChangeOffset(AIndex, ADelta: Integer);
var
  AViewInfo: TdxCustomLayoutItemViewInfo;
begin
  AViewInfo := Items[AIndex].ViewInfo;
  if (AViewInfo <> nil) and AViewInfo.IsValid then
    AViewInfo.Offsets[GetOffsetSide] := AViewInfo.Offsets[GetOffsetSide] + ADelta;
end;

procedure TdxLayoutAlignmentConstraint.ResetOffsets;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if Items[I].IsViewInfoValid then
      Items[I].ViewInfo.ResetOffset(GetOffsetSide);
end;

procedure TdxLayoutAlignmentConstraint.SetParentComponent(Value: TComponent);
var
  AContainer: IdxLayoutContainerOwner;
begin
  inherited;
  if Supports(Value, IdxLayoutContainerOwner, AContainer) then
    AContainer.GetContainer.AddAlignmentConstraint(Self);
end;

procedure TdxLayoutAlignmentConstraint.BeginUpdate;
begin
  Container.BeginUpdate;
end;

function TdxLayoutAlignmentConstraint.CanAddItem(AItem: TdxCustomLayoutItem): Boolean;
begin
  Result := (AItem <> nil) and (AItem.Container = Container);
end;

procedure TdxLayoutAlignmentConstraint.Changed;
begin
  Container.LayoutChanged;
end;

procedure TdxLayoutAlignmentConstraint.EndUpdate;
begin
  Container.EndUpdate;
end;

function TdxLayoutAlignmentConstraint.GetBorderValue(AIndex: Integer): Integer;
var
  AViewInfo: TdxCustomLayoutItemViewInfo;
begin
  AViewInfo := Items[AIndex].ViewInfo;
  if AViewInfo = nil then
    Result := -cxMaxRectSize
  else
    case Kind of
      ackLeft:
        Result := AViewInfo.Bounds.Left - AViewInfo.CalculateOffset(sdLeft);
      ackTop:
        Result := AViewInfo.Bounds.Top - AViewInfo.CalculateOffset(sdTop);
      ackRight:
        Result := AViewInfo.Bounds.Right + AViewInfo.CalculateOffset(sdRight);
      ackBottom:
        Result := AViewInfo.Bounds.Bottom + AViewInfo.CalculateOffset(sdBottom);
    else
      raise EdxException.Create('TdxLayoutAlignmentConstraint.GetBorderValue fails');
    end;
end;

function TdxLayoutAlignmentConstraint.GetMostBorderValue(ACount: Integer): Integer;
var
  I: Integer;
begin
  if ACount = 0 then
    ACount := Count;
  Result := -cxMaxRectSize;
  for I := 0 to ACount - 1 do
    Result := Max(Result, GetBorderValue(I));
end;

function TdxLayoutAlignmentConstraint.GetOffsetSide: TdxLayoutSide;
begin
  if Kind in [ackLeft, ackRight] then
    Result := sdLeft
  else
    Result := sdTop;
end;

function TdxLayoutAlignmentConstraint.GetParentComponent: TComponent;
begin
  Result := Container.ItemsParentComponent;
end;

function TdxLayoutAlignmentConstraint.HasParent: Boolean;
begin
  Result := Container.ItemsParentControl <> nil;
end;

procedure TdxLayoutAlignmentConstraint.AddItem(AItem: TdxCustomLayoutItem);
begin
  if CanAddItem(AItem) then
    AItem.AlignmentConstraint := Self;
end;

procedure TdxLayoutAlignmentConstraint.RemoveItem(AItem: TdxCustomLayoutItem);
begin
  if FItems.IndexOf(AItem) <> -1 then
    AItem.AlignmentConstraint := nil;
end;

{ TdxLayoutContainerPersistent }

constructor TdxLayoutContainerPersistent.Create(AContainer: TdxLayoutContainer);
begin
  inherited Create;
  FContainer := AContainer;
end;

function TdxLayoutContainerPersistent.GetOwner: TPersistent;
begin
  Result := Container;
end;

{ TdxLayoutContainerFocusController }

function TdxLayoutContainerFocusController.SelectNext(AFocusedControl: TWinControl; const ACharCode: Word = VK_TAB): Boolean;

  function CheckCurrentTabOrder(AGoForward: Boolean): Boolean;
  var
    AParentForm: TCustomForm;
    AList: TList;
    ACurrentTabOrder: Integer;
    I: Integer;
    AFirstIndex, ALastIndex: Integer;
    AControlIndex: Integer;
  begin
    AParentForm := GetParentForm(Container.ItemsParentControl);
    if TWinControlAccess(AParentForm).FindNextControl(AFocusedControl, AGoForward, True, False) = Container.ItemsParentControl then
    begin
      AList := TList.Create;
      try
        AParentForm.GetTabOrderList(AList);
        AFirstIndex := AList.IndexOf(Container.ItemsParentControl);
        ALastIndex := AList.IndexOfItem(Container.ItemsParentControl, FromEnd);
        AControlIndex := AList.IndexOf(AFocusedControl);
        if AGoForward and ((AFirstIndex > AControlIndex) or (ALastIndex < AControlIndex)) then
          CurrentTabOrder := 0
        else
        begin
          I := AFirstIndex;
          ACurrentTabOrder := -1;
          while (I < AList.Count) and (AList[I] <> AFocusedControl) do
          begin
            if AList[I] = Container.ItemsParentControl then
              Inc(ACurrentTabOrder);
            Inc(I);
          end;
          if AGoForward then
            Inc(ACurrentTabOrder);
          CurrentTabOrder := ACurrentTabOrder;
        end;
      finally
        AList.Free;
      end;
    end;
    Result := CurrentTabOrder <> -1;
    if Result then
      Container.ItemsParentControl.SetFocus;
  end;

var
  AGoForward: Boolean;
  ACurrentTabOrder: Integer;
  ANextControl: TWinControl;
begin
  AGoForward := ((ACharCode = VK_TAB) and (GetKeyState(VK_SHIFT) >= 0)) or (ACharCode in [VK_RIGHT, VK_DOWN]);
  if AFocusedControl = Container.ItemsParentControl then
  begin
    Result := (GetMaxTabOrder > -1) and (AGoForward or (CurrentTabOrder > -1));
    if Result then
    begin
      ANextControl := FindNextControl(AFocusedControl, AGoForward);
      Result := ANextControl <> nil;
      if Result then
        if ANextControl = Container.ItemsParentControl then
        begin
          if AGoForward then
            ACurrentTabOrder := CurrentTabOrder + 1
          else
            ACurrentTabOrder := CurrentTabOrder - 1;
          if ACurrentTabOrder < 0 then
            ACurrentTabOrder := GetMaxTabOrder;
          if ACurrentTabOrder > GetMaxTabOrder then
            ACurrentTabOrder := 0;
          CurrentTabOrder := ACurrentTabOrder;
          Result := CurrentTabOrder <> -1;
        end
        else
        begin
          CurrentTabOrder := -1;
          ANextControl.SetFocus;
        end;
    end;
  end
  else
    Result := CheckCurrentTabOrder(AGoForward);
end;

function TdxLayoutContainerFocusController.GetMaxTabOrder: Integer;
begin
  Result := Container.GetMaxTabOrder;
end;

function TdxLayoutContainerFocusController.FindItem(ATabOrder: Integer): TdxCustomLayoutItem;

  function CheckTabOrder(AItem: TdxCustomLayoutItem): Boolean;
  begin
    Result := AItem.IsViewInfoValid and AItem.CanFocus(False) and (AItem.ViewInfo.TabOrder = ATabOrder);
  end;

var
  I: Integer;
begin
  Result := nil;
  if ATabOrder = -1 then
    Exit;
  if CheckTabOrder(Container.Root) then
    Result := Container.Root
  else
    for I := 0 to Container.AbsoluteItemCount - 1 do
      if CheckTabOrder(Container.AbsoluteItems[I]) then
      begin
        Result := Container.AbsoluteItems[I];
        Break;
      end;
end;

function TdxLayoutContainerFocusController.FindNextControl(ACurrentControl: TWinControl; AGoForward: Boolean): TWinControl;

  function GetStartIndexByCurrentTabOrder(AList: TList): Integer;
  var
    I: Integer;
    AStartIndex: Integer;
  begin
    AStartIndex := AList.IndexOf(Container.ItemsParentControl);
    I := 0;
    for Result := AStartIndex to AList.Count - 1 do
      if AList[Result] = Container.ItemsParentControl then
      begin
        if I = CurrentTabOrder then
          Break;
        Inc(I);
      end;
  end;

  function GetStartIndex(AList: TList): Integer;
  var
    AChildren: TList;
  begin
    Result := -1;
    if ACurrentControl <> Container.ItemsParentControl then
      Result := AList.IndexOf(ACurrentControl);
    if Result = -1 then
    begin
      if CurrentTabOrder <> -1 then
        Result := GetStartIndexByCurrentTabOrder(AList)
      else
      begin
        AChildren := TList.Create;
        try
          Container.ItemsParentControl.GetTabOrderList(AChildren);
          if AChildren.Count > 0 then
          begin
            Result := AList.IndexOf(AChildren[0]);
            if Result >= 0 then
              Dec(Result);
          end
          else
            Result := -1;
        finally
          AChildren.Free;
        end;
      end;
    end;
  end;

var
  I, AStartIndex: Integer;
  AList: TList;
  AParentForm: TCustomForm;
begin
  Result := nil;
  AList := TList.Create;
  try
    AParentForm := GetParentForm(Container.ItemsParentControl);
    AParentForm.GetTabOrderList(AList);
    if AList.Count > 0 then
    begin
      AStartIndex := GetStartIndex(AList);
      if AStartIndex = -1 then
        if AGoForward then
          AStartIndex := AList.Count - 1
        else
          AStartIndex := 0;

      I := AStartIndex;
      repeat
        if AGoForward then
        begin
          Inc(I);
          if I = AList.Count then I := 0;
        end
        else
        begin
          if I = 0 then I := AList.Count;
          Dec(I);
        end;
        Result := AList[I];
        if not (Result.CanFocus and Result.TabStop) then
          Result := nil;
      until (Result <> nil) or (I = AStartIndex);
    end;
  finally
    AList.Free;
  end;
end;

function TdxLayoutContainerFocusController.IsFocused(AItem: TdxCustomLayoutItem): Boolean;
begin
  Result := Container.ItemsParentControl.Focused and not Container.IsCustomization and
    AItem.IsViewInfoValid and (AItem.ViewInfo.TabOrder = CurrentTabOrder);
end;

procedure TdxLayoutContainerFocusController.SetFocus;
var
  AGoForward: Boolean;
  APrevCurrentTabOrder: Integer;
begin
  APrevCurrentTabOrder := CurrentTabOrder;
  if (APrevCurrentTabOrder = -1) and (GetMaxTabOrder > -1) and
    (GetCaptureControl <> Container.ItemsParentControl) then
  begin
    AGoForward := GetKeyState(VK_SHIFT) >= 0;
    if AGoForward then
      CurrentTabOrder := 0
    else
      CurrentTabOrder := GetMaxTabOrder;
  end;
  if (APrevCurrentTabOrder = CurrentTabOrder) and (APrevCurrentTabOrder <> -1) then
    Container.ItemsParentControl.Invalidate;
end;

procedure TdxLayoutContainerFocusController.KillFocus;
begin
  CurrentTabOrder := -1
end;

procedure TdxLayoutContainerFocusController.CheckFocus;
begin
  if (FocusedItem <> nil) and (not FocusedItem.IsViewInfoValid or not FocusedItem.ViewInfo.ActuallyVisible) then
    FocusedItem := nil;
end;

procedure TdxLayoutContainerFocusController.SetItemFocus(AItem: TdxCustomLayoutItem);
begin
  Container.ItemsParentControl.SetFocus;
  FocusedItem := AItem;
end;

function TdxLayoutContainerFocusController.GetCurrentTabOrder: Integer;

  function GetItemTabOrder(AItem: TdxCustomLayoutItem): Integer;
  begin
    if AItem = nil then
      Result := -1
    else
    begin
      if AItem.CanFocus(False) then
        Result := AItem.ViewInfo.TabOrder
      else
        Result := GetItemTabOrder(AItem.Parent);
    end;
  end;

begin
  Result := GetItemTabOrder(FocusedItem);
end;

procedure TdxLayoutContainerFocusController.SetCurrentTabOrder(const Value: Integer);
begin
  FocusedItem := FindItem(Value);
end;

procedure TdxLayoutContainerFocusController.SetFocusedItem(Value: TdxCustomLayoutItem);

  procedure FocusedItemChanged(AItem: TdxCustomLayoutItem);
  begin
    if AItem.Parent <> nil then
      AItem.Parent.Changed(ictLight)
    else
      AItem.Changed(ictLight);
  end;

var
  APrevFocusedItem: TdxCustomLayoutItem;
begin
  if FocusedItem <> Value then
  begin
    APrevFocusedItem := FocusedItem;
    FFocusedItem := Value;
    if APrevFocusedItem <> nil then
      FocusedItemChanged(APrevFocusedItem);
    if FocusedItem <> nil then
    begin
      if FocusedItem.NeedMakeVisibleAfterFocusing then
        FocusedItem.MakeVisible;
      FocusedItemChanged(FocusedItem);
    end;
  end;
end;

constructor TdxLayoutContainerCustomizationHelper.Create(AContainer: TdxLayoutContainer);
begin
  inherited Create;
  FContainer := AContainer;
end;

procedure TdxLayoutContainerCustomizationHelper.CopyStructure(AContainer: TdxLayoutContainer);
begin
// do nothing
end;

{ TdxLayoutImageOptions }

constructor TdxLayoutImageOptions.Create(AContainer: TdxLayoutContainer);
begin
  inherited;
  FDisabledImagesChangeLink := TChangeLink.Create;
  FDisabledImagesChangeLink.OnChange := ImagesChange;
  FImagesChangeLink := TChangeLink.Create;
  FImagesChangeLink.OnChange := ImagesChange;
end;

destructor TdxLayoutImageOptions.Destroy;
begin
  FreeAndNil(FImagesChangeLink);
  FreeAndNil(FDisabledImagesChangeLink);
  inherited Destroy;
end;

procedure TdxLayoutImageOptions.Assign(Source: TPersistent);
begin
  if Source is TdxLayoutImageOptions then
  begin
    BeginUpdate;
    try
      DisabledImages := TdxLayoutImageOptions(Source).DisabledImages;
      Images := TdxLayoutImageOptions(Source).Images;
    finally
      EndUpdate;
    end;
  end
  else
    inherited Assign(Source);
end;

procedure TdxLayoutImageOptions.Changed;
begin
  Container.LayoutChanged(False);
end;

procedure TdxLayoutImageOptions.BeginUpdate;
begin
  Container.BeginUpdate;
end;

procedure TdxLayoutImageOptions.EndUpdate;
begin
  Container.CancelUpdate;
  Changed;
end;

procedure TdxLayoutImageOptions.SetImages(AValue: TCustomImageList);
begin
  SetImageList(AValue, FImages, FImagesChangeLink);
end;

procedure TdxLayoutImageOptions.SetDisabledImages(AValue: TCustomImageList);
begin
  SetImageList(AValue, FDisabledImages, FDisabledImagesChangeLink);
end;

procedure TdxLayoutImageOptions.ImagesChange(Sender: TObject);
begin
  Changed;
end;

procedure TdxLayoutImageOptions.SetImageList(var ANewValue, AOldValue: TCustomImageList; const AChangeLink: TChangeLink);
begin
  cxSetImageList(ANewValue, AOldValue, AChangeLink, FContainer);
end;

procedure TdxLayoutImageOptions.FreeNotification(AComponent: TComponent);
begin
  if AComponent = DisabledImages then DisabledImages := nil;
  if AComponent = Images then Images := nil;
end;

{ TdxCustomLayoutGroupButton }

constructor TdxCustomLayoutGroupButton.Create(Collection: TCollection);
begin
  Collection.BeginUpdate;
  try
    inherited Create(Collection);
    FGlyph := TdxSmartGlyph.Create;
    FGlyph.OnChange := GlyphChangedHandler;
    FVisible := True;
    FEnabled := True;
  finally
    Collection.EndUpdate;
  end;
end;

destructor TdxCustomLayoutGroupButton.Destroy;
begin
  FreeAndNil(FGlyph);
  inherited Destroy;
end;

procedure TdxCustomLayoutGroupButton.Assign(Source: TPersistent);
var
  AButton: TdxCustomLayoutGroupButton;
begin
  if Source is TdxCustomLayoutGroupButton then
  begin
    AButton := TdxCustomLayoutGroupButton(Source);
    Glyph := AButton.Glyph;
    Height := AButton.Height;
    Hint := AButton.Hint;
    Tag := AButton.Tag;
    Width := AButton.Width;
    Visible := AButton.Visible;
  end
  else
    inherited Assign(Source);
end;

function TdxCustomLayoutGroupButton.GetNamePath: string;
begin
  Result := Buttons.Options.Group.GetNamePath + '.' + Format('Button[%d]',[Index]);
end;

procedure TdxCustomLayoutGroupButton.ChangeScale(M, D: Integer);
begin
  FHeight := MulDiv(FHeight, M, D);
  FWidth := MulDiv(FWidth, M, D);
end;

function TdxCustomLayoutGroupButton.GetHeight: Integer;
begin
  if Height = 0 then
    Result := Buttons.Options.DefaultHeight
  else
    Result := Height;
end;

function TdxCustomLayoutGroupButton.GetViewInfoClass: TdxLayoutGroupButtonViewInfoClass;
begin
  Result := TdxLayoutGroupButtonViewInfo;
end;

function TdxCustomLayoutGroupButton.GetWidth: Integer;
begin
  if Width = 0 then
  begin
    Result := Buttons.Options.DefaultWidth;
    dxAdjustToTouchableSize(Result);
  end
  else
    Result := Width;
end;

procedure TdxCustomLayoutGroupButton.DoClick;
begin
  CallNotify(FOnClick, Self);
end;

function TdxCustomLayoutGroupButton.IsExpandButton: Boolean;
begin
  Result := Self = Buttons.Options.ExpandButton;
end;

function TdxCustomLayoutGroupButton.IsHomeButton: Boolean;
begin
  Result := Self = Buttons.Options.FHomeButton;
end;

function TdxCustomLayoutGroupButton.GetHint: string;
begin
  Result := FHint;
  if Assigned(OnGetHint) then
    OnGetHint(Self, Result);
end;

function TdxCustomLayoutGroupButton.GetButtons: TdxCustomLayoutGroupButtons;
begin
  Result := TdxLayoutGroupButtons(Collection);
end;

procedure TdxCustomLayoutGroupButton.GlyphChangedHandler(Sender: TObject);
begin
  Changed(False);
end;

procedure TdxCustomLayoutGroupButton.SetEnabled(AValue: Boolean);
begin
  if FEnabled <> AValue then
  begin
    FEnabled := AValue;
    Changed(False);
  end;
end;

procedure TdxCustomLayoutGroupButton.SetGlyph(AValue: TdxSmartGlyph);
begin
  FGlyph.Assign(AValue);
end;

procedure TdxCustomLayoutGroupButton.SetHeight(AValue: Cardinal);
begin
  if FHeight <> AValue then
  begin
    FHeight := AValue;
    Changed(False);
  end;
end;

procedure TdxCustomLayoutGroupButton.SetVisible(AValue: Boolean);
begin
  if FVisible <> AValue then
  begin
    FVisible := AValue;
    Changed(False);
  end;
end;

procedure TdxCustomLayoutGroupButton.SetWidth(AValue: Cardinal);
begin
  if FWidth <> AValue then
  begin
    FWidth := AValue;
    Changed(False);
  end;
end;

{ TdxLayoutGroupCheckBoxButton }

constructor TdxLayoutGroupCheckBoxButton.Create(Collection: TCollection);
begin
  inherited;
  FCheckAction := cbaToggleChildrenEnabledState;
  FState := cbsChecked;
  FVisible := False;
end;

procedure TdxLayoutGroupCheckBoxButton.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TdxLayoutGroupCheckBoxButton then
  begin
    CheckAction := TdxLayoutGroupCheckBoxButton(Source).CheckAction;
    State := TdxLayoutGroupCheckBoxButton(Source).State;
  end;
end;

procedure TdxLayoutGroupCheckBoxButton.DoClick;
begin
  Toggle;
  CallNotify(OnClick, Self)
end;

function TdxLayoutGroupCheckBoxButton.GetViewInfoClass: TdxLayoutGroupButtonViewInfoClass;
begin
  Result := TdxLayoutGroupCheckBoxButtonViewInfo;
end;

procedure TdxLayoutGroupCheckBoxButton.Toggle;
begin
  if State = cbsChecked then
    State := cbsUnchecked
  else
    State := cbsChecked;
end;

procedure TdxLayoutGroupCheckBoxButton.ToggleChildrenEnabledState(AGroup: TdxCustomLayoutGroup; const AEnabled: Boolean);
var
  I: Integer;
begin 
  AGroup.BeginUpdate;
  try
    for I := 0 to AGroup.Count - 1 do
    begin
      AGroup[I].Enabled := AEnabled;
      if AGroup[I].IsGroup and (not AEnabled or AGroup[I].AsGroup.ButtonOptions.CheckBox.Checked) then
        ToggleChildrenEnabledState(AGroup[I].AsGroup, AEnabled);
    end;
  finally
    AGroup.EndUpdate;
  end;
end;

function TdxLayoutGroupCheckBoxButton.GetChecked: Boolean;
begin
  Result := State = cbsChecked;
end;

procedure TdxLayoutGroupCheckBoxButton.SetChecked(AValue: Boolean);
begin
  if AValue then
    State := cbsChecked
  else
    State := cbsUnchecked;
end;

procedure TdxLayoutGroupCheckBoxButton.SetState(AValue: TcxCheckBoxState);
begin
  if (FState <> AValue) and Buttons.Options.Group.DoCheckBoxStateChanging(AValue) then
  begin
    FState := AValue;
    if not Buttons.Options.Group.IsDesigning and (CheckAction = cbaToggleChildrenEnabledState) then 
      ToggleChildrenEnabledState(Buttons.Options.Group, Checked)
    else
      Buttons.Options.Group.Changed(ictLight);
    Buttons.Options.Group.DoCheckBoxStateChanged;
  end;
end;

{ TdxCustomLayoutGroupButtons }

constructor TdxCustomLayoutGroupButtons.Create(AOptions: TdxLayoutGroupButtonOptions);
begin
  inherited Create(GetItemClass);
  FOptions := AOptions;
end;

procedure TdxCustomLayoutGroupButtons.ChangeScale(M, D: Integer);
var
  I: Integer;
begin
  BeginUpdate;
  try
    for I := 0 to Count - 1 do
      Items[I].ChangeScale(M, D);
  finally
    EndUpdate;
  end;
end;

function TdxCustomLayoutGroupButtons.GetItemClass: TdxCustomLayoutGroupButtonClass;
begin
  Result := TdxCustomLayoutGroupButton;
end;

function TdxCustomLayoutGroupButtons.GetOwner: TPersistent;
begin
  Result := FOptions;
end;

procedure TdxCustomLayoutGroupButtons.Update(Item: TCollectionItem);
begin
  CallNotify(FOnChange, Self);
end;

function TdxCustomLayoutGroupButtons.GetItem(Index: Integer): TdxCustomLayoutGroupButton;
begin
  Result := TdxCustomLayoutGroupButton(inherited Items[Index]);
end;

function TdxCustomLayoutGroupButtons.GetOptions: TdxLayoutGroupButtonOptions;
begin
  Result := FOptions;
end;

procedure TdxCustomLayoutGroupButtons.SetItem(Index: Integer; const AValue: TdxCustomLayoutGroupButton);
begin
  inherited Items[Index] := AValue;
end;

{ TdxLayoutGroupButtons }

function TdxLayoutGroupButtons.GetItemClass: TdxCustomLayoutGroupButtonClass;
begin
  Result := TdxLayoutGroupButton;
end;

function TdxLayoutGroupButtons.GetItem(Index: Integer): TdxLayoutGroupButton;
begin
  Result := TdxLayoutGroupButton(inherited Items[Index]);
end;

procedure TdxLayoutGroupButtons.SetItem(Index: Integer; const AValue: TdxLayoutGroupButton);
begin
  inherited Items[Index] := AValue;
end;

{ TdxLayoutGroupButtonOptions }

constructor TdxLayoutGroupButtonOptions.Create(AGroup: TdxCustomLayoutGroup);
begin
  inherited Create;
  FGroup := AGroup;

  FInternalButtons := TdxCustomLayoutGroupButtons.Create(Self);
  FInternalButtons.OnChange := ChangeCollectionHandler;
  CreateCheckBox;
  CreateExpandButton;
  FButtons := TdxLayoutGroupButtons.Create(Self);
  FButtons.OnChange := ChangeCollectionHandler;
  FVisibleButtons := TList.Create;

  FVisible := True;
  FDefaultHeight := 16;
  FDefaultWidth := 16;
  FAlignment := gbaRight;
end;

destructor TdxLayoutGroupButtonOptions.Destroy;
begin
  FreeAndNil(FVisibleButtons);
  FreeAndNil(FButtons);
  FreeAndNil(FInternalButtons);
  inherited Destroy;
end;

procedure TdxLayoutGroupButtonOptions.Assign(Source: TPersistent);
var
  AOptions: TdxLayoutGroupButtonOptions;
begin
  if Source is TdxLayoutGroupButtonOptions then
  begin
    AOptions := TdxLayoutGroupButtonOptions(Source);
    Alignment := AOptions.Alignment;
    Buttons := AOptions.Buttons;
    CheckBox := AOptions.CheckBox;
    DefaultHeight := AOptions.DefaultHeight;
    DefaultWidth := AOptions.DefaultWidth;
    ShowExpandButton := AOptions.ShowExpandButton;
    Visible := AOptions.Visible;
  end
  else
    inherited Assign(Source);
end;

function TdxLayoutGroupButtonOptions.GetOwner: TPersistent;
begin
  Result := FGroup;
end;

procedure TdxLayoutGroupButtonOptions.Changed;
begin
  Group.Changed(ictComplex);
end;

procedure TdxLayoutGroupButtonOptions.ChangeScale(M, D: Integer);
begin
  DefaultHeight := MulDiv(DefaultHeight, M, D);
  DefaultWidth := MulDiv(DefaultWidth, M, D);
  Buttons.ChangeScale(M, D);
end;

function TdxLayoutGroupButtonOptions.IsAnyButtonVisible: Boolean;
begin
  Result := Visible and RefreshVisibleButtons;
end;

procedure TdxLayoutGroupButtonOptions.CreateCheckBox;
begin
  FCheckBox := TdxLayoutGroupCheckBoxButton.Create(FInternalButtons);
  FCheckBox.Visible := False;
end;

procedure TdxLayoutGroupButtonOptions.CreateExpandButton;
begin
  FExpandButton := TdxLayoutGroupButton.Create(FInternalButtons);
  FExpandButton.Visible := False;
  FExpandButton.OnGetHint := GetExpandButtonHintHandler;
end;

procedure TdxLayoutGroupButtonOptions.CreateHomeButton;
begin
  FHomeButton := TdxLayoutGroupButton.Create(FInternalButtons);
  FHomeButton.OnClick := HomeButtonClickHandler;
  FHomeButton.Hint := cxGetResourceString(@sdxLayoutControlHomeButtonHint);
end;

function TdxLayoutGroupButtonOptions.GetVisibleButton(AIndex: Integer): TdxCustomLayoutGroupButton;
begin
  Result := TdxCustomLayoutGroupButton(FVisibleButtons[AIndex]);
end;

function TdxLayoutGroupButtonOptions.RefreshVisibleButtons: Boolean;
var
  I: Integer;
begin
  FVisibleButtons.Clear;

  for I := 0 to FInternalButtons.Count - 1 do
    if FInternalButtons[I].Visible then
      FVisibleButtons.Add(FInternalButtons[I]);
  for I := 0 to Buttons.Count - 1 do
    if Buttons[I].Visible then
      FVisibleButtons.Add(Buttons[I]);
  Result := FVisibleButtons.Count > 0;
end;

procedure TdxLayoutGroupButtonOptions.UpdateInternalButtons;
begin
  if FHomeButton <> nil then
    FHomeButton.Enabled := (Group.TakeoffParent <> nil) and Group.CanMoveTo(Group.TakeoffParent);
end;

procedure TdxLayoutGroupButtonOptions.GetStoredPropertyValue(const AName: string; var AValue: Variant);
begin
  if AName = 'ShowExpandButton' then
    AValue := ShowExpandButton
  else
    if AName = 'CheckBoxChecked' then
      AValue := CheckBox.Checked;
end;

procedure TdxLayoutGroupButtonOptions.GetStoredProperties(AProperties: TStrings);
begin
  AProperties.Add('ShowExpandButton');
  AProperties.Add('CheckBoxChecked');
end;

procedure TdxLayoutGroupButtonOptions.SetStoredPropertyValue(const AName: string; const AValue: Variant);
begin
  if AName = 'ShowExpandButton' then
    ShowExpandButton := AValue
  else
    if AName = 'CheckBoxChecked' then
      CheckBox.Checked := AValue;
end;

procedure TdxLayoutGroupButtonOptions.ChangeCollectionHandler(Sender: TObject);
begin
  Changed;
end;

procedure TdxLayoutGroupButtonOptions.HomeButtonClickHandler(Sender: TObject);
begin
  Group.LandingFloat;
end;

function TdxLayoutGroupButtonOptions.GetShowExpandButton: Boolean;
begin
  Result := ExpandButton.Visible;
end;

procedure TdxLayoutGroupButtonOptions.GetExpandButtonHintHandler(Sender: TObject; var AText: string);
begin
  if Group.Expanded then
    AText := cxGetResourceString(@sdxLayoutControlExpandButtonHint)
  else
    AText := cxGetResourceString(@sdxLayoutControlCollapseButtonHint);
end;

procedure TdxLayoutGroupButtonOptions.SetButtons(AValue: TdxLayoutGroupButtons);
begin
  Buttons.Assign(AValue);
end;

procedure TdxLayoutGroupButtonOptions.SetCheckBox(AValue: TdxLayoutGroupCheckBoxButton);
begin
  CheckBox.Assign(AValue);
end;

procedure TdxLayoutGroupButtonOptions.SetDefaultHeight(AValue: Cardinal);
begin
  if FDefaultHeight <> AValue then
  begin
    FDefaultHeight := AValue;
    Changed;
  end;
end;

procedure TdxLayoutGroupButtonOptions.SetDefaultWidth(AValue: Cardinal);
begin
  if FDefaultWidth <> AValue then
  begin
    FDefaultWidth := AValue;
    Changed;
  end;
end;

procedure TdxLayoutGroupButtonOptions.SetAlignment(AValue: TdxLayoutGroupButtonsAlignment);
begin
  if FAlignment <> AValue then
  begin
    FAlignment := AValue;
    Changed;
  end;
end;

procedure TdxLayoutGroupButtonOptions.SetShowExpandButton(AValue: Boolean);
begin
  FExpandButton.Visible := AValue
end;

procedure TdxLayoutGroupButtonOptions.SetVisible(AValue: Boolean);
begin
  if FVisible <> AValue then
  begin
    FVisible := AValue;
    Changed;
  end;
end;

{ TdxLayoutGroupCaptionOptions }

constructor TdxLayoutGroupCaptionOptions.Create(AItem: TdxCustomLayoutItem);
begin
  inherited;
  FLayout := clTop;
end;

{ TdxLayoutGroupScrollOptions }

procedure TdxLayoutGroupScrollOptions.DoAssign(Source: TPersistent);
begin
  inherited;
  if Source is TdxLayoutGroupScrollOptions then
  begin
    Horizontal := TdxLayoutGroupScrollOptions(Source).Horizontal;
    Vertical := TdxLayoutGroupScrollOptions(Source).Vertical;
  end;
end;

procedure TdxLayoutGroupScrollOptions.Changed;
begin
  Item.Changed(ictHard);
end;

procedure TdxLayoutGroupScrollOptions.SetHorizontalScroll(Value: TdxLayoutGroupScrollMode);
begin
  if FHorizontal <> Value then
  begin
    FHorizontal := Value;
    Changed;
  end;
end;

procedure TdxLayoutGroupScrollOptions.SetVerticalScroll(Value: TdxLayoutGroupScrollMode);
begin
  if FVertical <> Value then
  begin
    FVertical := Value;
    Changed;
  end;
end;

function TdxLayoutGroupScrollOptions.GetMajorScroll: TdxLayoutGroupScrollMode;
begin
  case Item.AsGroup.LayoutDirection of
    ldHorizontal:
      Result := Horizontal;
    ldVertical:
      Result := Vertical;
  else //  ldTabbed:
    Result := smNone;
  end;
end;

function TdxLayoutGroupScrollOptions.GetMinorScroll: TdxLayoutGroupScrollMode;
begin
  case Item.AsGroup.LayoutDirection of
    ldHorizontal:
      Result := Vertical;
    ldVertical:
      Result := Horizontal;
  else //  ldTabbed:
    Result := smNone;
  end;
end;

{ TdxCustomLayoutGroup }

constructor TdxCustomLayoutGroup.Create(AOwner: TComponent);
begin
  inherited;
  FItems := TcxComponentList.Create(True);
  FItems.OnComponentListChanged := ItemListChanged;
  FVisibleItems := TcxComponentList.Create;
  FLayoutDirection := ldVertical;
  FShowBorder := True;
  FUseIndent := True;
  FExpanded := True;
  FItemIndex := dxLayoutPseudoActiveItem;
  FScrollOptions := TdxLayoutGroupScrollOptions.Create(Self);
  FWrapItemsMode := wmParentManaged;
end;

destructor TdxCustomLayoutGroup.Destroy;
begin
  FreeAndNil(FScrollOptions);
  FreeAndNil(FVisibleItems);
  FreeAndNil(FItems);

  inherited;
end;

procedure TdxCustomLayoutGroup.Assign(Source: TPersistent);
var
  ASourceGroup: TdxCustomLayoutGroup;
begin
  inherited;
  if Source is TdxCustomLayoutGroup then
  begin
    ASourceGroup := TdxCustomLayoutGroup(Source);
    ButtonOptions := ASourceGroup.ButtonOptions;
    Expanded := ASourceGroup.Expanded;
    Hidden := ASourceGroup.Hidden;
    ItemControlAreaAlignment := ASourceGroup.ItemControlAreaAlignment;
    ItemIndex := ASourceGroup.ItemIndex;
    LayoutDirection := ASourceGroup.LayoutDirection;
    Locked := ASourceGroup.Locked;
    LayoutLookAndFeelException := ASourceGroup.LayoutLookAndFeelException;
    ShowBorder := ASourceGroup.ShowBorder;
    TabbedOptions := ASourceGroup.TabbedOptions;
    UseIndent := ASourceGroup.UseIndent;
    ScrollOptions := ASourceGroup.ScrollOptions;
  end;
end;

function TdxCustomLayoutGroup.GetCaptionOptions: TdxLayoutGroupCaptionOptions;
begin
  Result := TdxLayoutGroupCaptionOptions(inherited CaptionOptions);
end;

function TdxCustomLayoutGroup.GetCount: Integer;
begin
  Result := FItems.Count;
end;

procedure TdxCustomLayoutGroup.TabChangedHandler(Sender: TObject; AType: TcxCustomTabControlPropertiesChangedType);
begin
  if IsDestroying or IsLoading or Container.IsUpdateLocked then
    Exit;
  case AType of
    pctLight:
      Changed(ictLight);
    pctSimple:
      Changed(ictSimple);
    pctMedium:
      Changed(ictMedium);
  else
    Changed(ictComplex);
  end;
end;

procedure TdxCustomLayoutGroup.TabChangeHandler(Sender: TObject);
begin
  if IsDestroying then
    Exit;
  Container.Modified;
  DoTabChanged;
end;

procedure TdxCustomLayoutGroup.TabCanCloseHandler(Sender: TObject; ATabIndex: Integer; var ACanClose: Boolean);
begin
  ACanClose := not Container.IsCustomization;
end;

procedure TdxCustomLayoutGroup.TabClickHandler(Sender: TObject; ATabVisibleIndex: Integer; AShift: TShiftState);
begin
  VisibleItems[ATabVisibleIndex].DoCaptionClick;
end;

procedure TdxCustomLayoutGroup.TabCloseHandler(Sender: TObject; ATabIndex: Integer);
begin
  Items[ATabIndex].Parent := nil;
end;

function TdxCustomLayoutGroup.GetItem(Index: Integer): TdxCustomLayoutItem;
begin
  Result := TdxCustomLayoutItem(FItems.List[Index]);
end;

function TdxCustomLayoutGroup.GetShowBorder: Boolean;
begin
  Result := not FHidden and FShowBorder or IsDragged;
end;

function TdxCustomLayoutGroup.GetViewInfo: TdxLayoutGroupViewInfo;
begin
  Result := (inherited ViewInfo).AsGroupViewInfo;
end;

function TdxCustomLayoutGroup.GetVisibleCount: Integer;
begin
  Result := FVisibleItems.Count;
end;

function TdxCustomLayoutGroup.GetVisibleItem(Index: Integer): TdxCustomLayoutItem;
begin
  if (Index >=0) and (Index < VisibleCount) then
    Result := TdxCustomLayoutItem(FVisibleItems.List[Index])
  else
    Result := nil;
end;

procedure TdxCustomLayoutGroup.SetScrollOptions(Value: TdxLayoutGroupScrollOptions);
begin
  ScrollOptions.Assign(Value);
end;

procedure TdxCustomLayoutGroup.SetAllowScroll(Value: Boolean);
begin
  Container.BeginUpdate;
  if Value then
  begin
    ScrollOptions.Horizontal := smAuto;
    ScrollOptions.Vertical := smAuto;
  end
  else
  begin
    ScrollOptions.Horizontal := smNone;
    ScrollOptions.Vertical := smNone;
  end;
  Container.EndUpdate;
end;

procedure TdxCustomLayoutGroup.SetAllowWrapItems(Value: Boolean);
begin
  if Value then
    WrapItemsMode := wmAllChildren
  else
    WrapItemsMode := wmParentManaged;
end;

procedure TdxCustomLayoutGroup.SetButtonOptions(Value: TdxLayoutGroupButtonOptions);
begin
  FButtonOptions.Assign(Value);
end;

procedure TdxCustomLayoutGroup.SetCaptionOptions(Value: TdxLayoutGroupCaptionOptions);
begin
  inherited CaptionOptions := Value;
end;

procedure TdxCustomLayoutGroup.SetExpanded(Value: Boolean);

  procedure ExpandedChanged;
  begin
    if FExpanded then
      DoExpanded
    else
      DoCollapsed;
  end;

  function CanExpandedChanged: Boolean;
  begin
    if FExpanded then
      Result := DoCollapsing
    else
      Result := DoExpanding;
  end;

begin
  if (FExpanded <> Value) and CanExpandedChanged then
  begin
    FExpanded := Value;
    ExpandedChanged;
    Changed;
  end;
end;

procedure TdxCustomLayoutGroup.SetHidden(Value: Boolean);
begin
  if FHidden <> Value then
  begin
    FHidden := Value;
    if not IsRoot then
    begin
      if Value and (Caption = '') then
        DefaultCaption := cxGetResourceString(@sdxLayoutControlNewHiddenGroup);
      Changed;
    end;
  end;
end;

procedure TdxCustomLayoutGroup.SetItemIndex(Value: Integer);
begin
  if FItemIndex <> Value then
    if LayoutDirection = ldTabbed then
    begin
      TabIndex := Value;
      DoTabChanged;
    end
    else
      FItemIndex := Value;
end;

procedure TdxCustomLayoutGroup.SetItemControlAreaAlignment(Value: TdxLayoutItemControlAreaAlignment);
begin
  if FItemControlAreaAlignment <> Value then
  begin
    FItemControlAreaAlignment := Value;
    Changed;
  end;
end;

procedure TdxCustomLayoutGroup.SetLayoutDirection(Value: TdxLayoutDirection);
begin
  if FLayoutDirection <> Value then
  begin
    FLayoutDirection := Value;
    if ViewInfo <> nil then
      ViewInfo.ViewData.FScrollPos := TdxAbsPoint(cxNullPoint); 
    Changed;
  end;
end;

procedure TdxCustomLayoutGroup.SetLocked(Value: Boolean);
begin
  if FLocked <> Value then
  begin
    FLocked := Value;
    Container.CustomizeFormUpdateList(Self);
  end;
end;

procedure TdxCustomLayoutGroup.SetLayoutLookAndFeelException(Value: Boolean);
begin
  if FLayoutLookAndFeelException <> Value then
  begin
    FLayoutLookAndFeelException := Value;
    LayoutLookAndFeelUserChanged;
  end;
end;

procedure TdxCustomLayoutGroup.SetShowBorder(Value: Boolean);
begin
  if FShowBorder <> Value then
  begin
    FShowBorder := Value;
    Changed;
  end;
end;

procedure TdxCustomLayoutGroup.SetTabbedOptions(Value: TdxLayoutTabbedOptions);
begin
  FTabbedOptions.Assign(Value);
end;

procedure TdxCustomLayoutGroup.SetTabIndex(Value: Integer);
var
  AFocusedItem: TdxCustomLayoutItem;
  ANeedFocusItem: Boolean;
begin
  ANeedFocusItem := not (Container.IsCustomization or IsLoading or IsRestoring) and
    (FItemIndex >= 0) and (Value >= 0);
  if ANeedFocusItem then
  begin
    AFocusedItem := Container.FindFocusedItem;
    ANeedFocusItem := (AFocusedItem <> nil) and (AFocusedItem <> Self) and
      ((AFocusedItem = Items[FItemIndex]) or IsChildItem(AFocusedItem));
  end;
  FItemIndex := Value;
  Changed(ictMedium);
  if ANeedFocusItem and not Items[ItemIndex].FocusFirst(True) then
    Container.FocusController.SetItemFocus(Items[ItemIndex]);
end;

procedure TdxCustomLayoutGroup.SetUseIndent(Value: Boolean);
begin
  if FUseIndent <> Value then
  begin
    FUseIndent := Value;
    Changed;
  end;
end;

procedure TdxCustomLayoutGroup.SetWrapItemsMode(Value: TdxLayoutGroupWrapItemsMode);
begin
  if FWrapItemsMode <> Value then
  begin
    FWrapItemsMode := Value;
    Changed;
  end;
end;

procedure TdxCustomLayoutGroup.AddItem(AItem: TdxCustomLayoutItem);
begin
  AItem.Container := FContainer;
  FItems.Add(AItem);
  AItem.FParent := Self;
  if Container.FPlaceControlsLockCount = 0 then 
    AItem.Init;
  TabbedOptions.InsertTab(AItem);
end;

procedure TdxCustomLayoutGroup.ExtractItem(AItem: TdxCustomLayoutItem);
begin
  if FItems <> nil then
  begin
    TabbedOptions.DeleteTab(AItem);
    FItems.Extract(AItem);
  end;
  AItem.FParent := nil;
end;

procedure TdxCustomLayoutGroup.ItemListChanged(Sender: TObject; AComponent: TComponent; AAction: TcxComponentCollectionNotification);
begin
  Container.CustomizeFormUpdateList(Self);
end;

procedure TdxCustomLayoutGroup.ReadSpecial(Reader: TReader);
begin
  Reader.ReadBoolean;
  Container.DisposeGroup(Self);
end;

procedure TdxCustomLayoutGroup.WriteSpecial(Writer: TWriter);
begin
  Writer.WriteBoolean(True);
end;

procedure TdxCustomLayoutGroup.ReadAutoCreated(Reader: TReader);
begin
  Reader.ReadBoolean;
//  FAutoCreated := Reader.ReadBoolean;
end;

function TdxCustomLayoutGroup.IsItemIndexStored: Boolean;
begin
  Result := (VisibleCount > 0) and (ItemIndex <> 0);
end;

function TdxCustomLayoutGroup.GetChildLayoutLookAndFeel: TdxCustomLayoutLookAndFeel;
begin
  if LayoutLookAndFeelException and (Parent <> nil) then
    Result := Parent.GetChildLayoutLookAndFeel
  else
    Result := GetLayoutLookAndFeel;
end;

procedure TdxCustomLayoutGroup.ReadButtons(Reader: TReader);
begin
  ButtonOptions.Buttons.Clear;
  Reader.ReadValue;
  Reader.ReadCollection(ButtonOptions.Buttons);
end;

procedure TdxCustomLayoutGroup.WriteButtons(Writer: TWriter);
begin
  Writer.WriteCollection(ButtonOptions.Buttons)
end;

function TdxCustomLayoutGroup.CanAcceptItem(AItem: TdxCustomLayoutItem): Boolean;
begin
  if IsFloatingRoot then
    Result := False
  else
    Result := ((AItem.Parent <> Self) or (VisibleCount > 1));
end;

function TdxCustomLayoutGroup.CanDelete: Boolean;
var
  I: Integer;
begin
  Result := IsDesigning and inherited CanDelete or (not IsRoot and not Locked and IsUserDefined);
  if Result then
    for I := 0 to Count - 1 do
    begin
      Result := Items[I].CanDelete;
      if not Result then
        Break;
    end;
end;

function TdxCustomLayoutGroup.CanDragAndDrop(const P: TPoint): Boolean;
begin
  Result := inherited CanDragAndDrop(P) and
    (not IsViewInfoValid or (ViewInfo.ElementWithMouse = nil) or ViewInfo.ElementWithMouse.AllowDragDrop);
end;

function TdxCustomLayoutGroup.CanRemove: Boolean;
var
  I: Integer;
begin
  Result := inherited CanRemove;
  if Result then
    for I := 0 to Count - 1 do
    begin
      Result := Items[I].CanRemove;
      if not Result then Break;
    end;
end;

procedure TdxCustomLayoutGroup.ContainerChanged;
var
  I: Integer;
begin
  if FItems <> nil then 
  begin
    for I := 0 to Count - 1 do
      Items[I].Container := Container;
    inherited;
  end;
end;

procedure TdxCustomLayoutGroup.DoCaptionClick;
begin
  if IsCheckBoxVisible and ButtonOptions.CheckBox.Enabled and ((Parent = nil) or (Parent.LayoutDirection <> ldTabbed)) then
    ButtonOptions.CheckBox.DoClick;
  inherited;
end;

procedure TdxCustomLayoutGroup.DoGetTabOrderList(List: TList);

  function IsNearItem(AItem: TdxCustomLayoutItem): Boolean;
  begin
    Result :=
     (LayoutDirection = ldHorizontal) and (AItem.AlignHorz <> ahRight) or
     (LayoutDirection = ldVertical) and (AItem.AlignVert <> avBottom);
  end;

var
  I: Integer;
  AItem: TdxCustomLayoutItem;
  AResidualList: TdxFastList;
begin
  inherited DoGetTabOrderList(List);
  if CanFocus(False) then
    List.Add(Container.ItemsParentControl);

  AResidualList := TdxFastList.Create(VisibleCount);
  try
    for I := 0 to VisibleCount - 1 do
    begin
      AItem := VisibleItems[I];
      if (LayoutDirection = ldTabbed) or IsNearItem(AItem) then
        AItem.GetTabOrderList(List)
      else
        AResidualList.Add(AItem);
    end;

    for I := 0 to AResidualList.Count - 1 do
      TdxCustomLayoutItem(AResidualList.List[I]).GetTabOrderList(List);
  finally
    AResidualList.Free;
  end;
end;

procedure TdxCustomLayoutGroup.DoChildPack;
var
  I: Integer;
  AItem: TdxCustomLayoutItem;
  AHasChanges: Boolean;
begin
  AHasChanges := False;
  for I := Count - 1 downto 0 do
  begin
    AItem := Items[I];
    AItem.DoPack;
    AHasChanges := AHasChanges or (I >= Count) or (AItem <> Items[I]);
  end;
  if AHasChanges then
    DoChildPack;
end;

procedure TdxCustomLayoutGroup.DoPack;
begin
  DoChildPack;
end;

function TdxCustomLayoutGroup.DoProcessAccel: Boolean;
var
  AItem: TdxCustomLayoutItem;
  I: Integer;
begin
  Result := False;
  if not Expanded then
  begin
    Expanded := True;
    Result := Expanded;
  end;

  for I := 0 to VisibleCount - 1 do
  begin
    AItem := VisibleItems[I];
    if AItem.DoProcessAccel then
    begin
      Result := True;
      Break;
    end;
  end;
end;

class function TdxCustomLayoutGroup.GetCaptionOptionsClass: TdxCustomLayoutItemCaptionOptionsClass;
begin
  Result := TdxLayoutGroupCaptionOptions;
end;

function TdxCustomLayoutGroup.IsLocked: Boolean;
begin
  Result := inherited IsLocked or (not IsDesigning and Locked);
end;

procedure TdxCustomLayoutGroup.CreateOptions;
begin
  inherited;
  FButtonOptions := TdxLayoutGroupButtonOptions.Create(Self);
  FTabbedOptions := TdxLayoutTabbedOptions.Create(Self);
  FTabbedOptions.OnChanged := TabChangedHandler;
  FTabbedOptions.OnChange := TabChangeHandler;
  FTabbedOptions.OnClose := TabCloseHandler;
  FTabbedOptions.OnCanClose := TabCanCloseHandler;
  FTabbedOptions.OnTabClick := TabClickHandler;
end;

procedure TdxCustomLayoutGroup.DestroyOptions;
begin
  FreeAndNil(FTabbedOptions);
  FreeAndNil(FButtonOptions);
  inherited;
end;

procedure TdxCustomLayoutGroup.DefineProperties(Filer: TFiler);

  function IsSpecialStored: Boolean;
  begin
    Result := Container.FGarbageCollector.IndexOf(Self) >= 0;
  end;

var
  AHasData: Boolean;
begin
  inherited;
  Filer.DefineProperty('Special', ReadSpecial, WriteSpecial, IsSpecialStored);
  Filer.DefineProperty('AutoCreated', ReadAutoCreated, nil, False);

  if Filer.Ancestor = nil then
    AHasData := ButtonOptions.Buttons.Count > 0
  else
    AHasData := not CollectionsEqual(ButtonOptions.Buttons, (Filer.Ancestor as TdxCustomLayoutGroup).ButtonOptions.Buttons, TComponent(Self), TComponent(Filer.Ancestor));

  Filer.DefineProperty('Buttons', ReadButtons, WriteButtons, AHasData);
end;

procedure TdxCustomLayoutGroup.Loaded;
begin
  inherited;
  if (Count > 0) and (ButtonOptions.CheckBox.CheckAction = cbaToggleChildrenEnabledState) and
    not ButtonOptions.CheckBox.Checked then
    ButtonOptions.CheckBox.ToggleChildrenEnabledState(Self, False);
end;

function TdxCustomLayoutGroup.GetIsRoot: Boolean;
begin
  Result := (Container <> nil) and Container.IsRoot(Self);
end;

function TdxCustomLayoutGroup.GetRealAlignHorz: TdxLayoutRealAlignHorz;
begin
  if (Parent <> nil) and (Parent.LayoutDirection = ldTabbed) then
    Result := ahClient
  else
    Result := inherited GetRealAlignHorz;
end;

function TdxCustomLayoutGroup.GetRealAlignVert: TdxLayoutRealAlignVert;
begin
  if (Parent <> nil) and (Parent.LayoutDirection = ldTabbed) then
    Result := avClient
  else
    Result := inherited GetRealAlignVert;
end;

function TdxCustomLayoutGroup.GetVisible: Boolean;
begin
  Result := inherited GetVisible and (IsRoot or not Hidden or (VisibleCount > 0) or IsDragged);
end;

function TdxCustomLayoutGroup.GetViewInfoClass: TdxCustomLayoutItemViewInfoClass;
begin
  if IsRoot then
    Result := Container.ViewInfo.GetRootViewInfoClass
  else
    Result := TdxLayoutGroupViewInfo;
end;

procedure TdxCustomLayoutGroup.InitiateAction;
var
  I: Integer;
begin
  inherited InitiateAction;
  for I := 0 to VisibleCount - 1 do
    VisibleItems[I].InitiateAction;
end;

procedure TdxCustomLayoutGroup.LoadFromIni(AIniFile: TCustomIniFile; const ASection: string; AVersion: Integer);
var
  AReader: TdxLayoutGroupReaderClass;
begin
  inherited;
  case AVersion of
    3: AReader := TdxLayoutGroupReader3;
    2: AReader := TdxLayoutGroupReader2;
  else
    AReader := TdxLayoutGroupReader;
  end;

  AReader.LoadFromIni(Self, AIniFile, ASection);
end;

procedure TdxCustomLayoutGroup.SaveToIni(AIniFile: TCustomIniFile; const ASection: string);
begin
  inherited;
  TdxLayoutGroupWriter.SaveToIni(Self, AIniFile, ASection);
end;

procedure TdxCustomLayoutGroup.LayoutLookAndFeelChanged;
var
  I: Integer;
begin
  inherited;
  for I := 0 to Count - 1 do
    Items[I].LayoutLookAndFeelChanged;
end;

procedure TdxCustomLayoutGroup.SetInitialSettings;
var
  I: Integer;
begin
  inherited;
  for I := 0 to Count - 1 do
    Items[I].SetInitialSettings;
end;

function TdxCustomLayoutGroup.ProcessDialogChar(ACharCode: Word): Boolean;
var
  I: Integer;
begin
  Result := inherited ProcessDialogChar(ACharCode) or ViewInfo.Specific.ProcessDialogChar(ACharCode);
  if not Result then
    for I := 0 to VisibleCount - 1 do
    begin
      Result := VisibleItems[I].ProcessDialogChar(ACharCode);
      if Result then Break;
    end;
end;

function TdxCustomLayoutGroup.ProcessDialogKey(ACharCode: Word; AKeyData: Integer;
  AFocusedItem: TdxCustomLayoutItem): Boolean;
var
  I: Integer;
begin
  Result := (AFocusedItem <> Self) and ViewInfo.Specific.ProcessDialogKey(ACharCode, AKeyData, AFocusedItem);
  if not Result then
    for I := 0 to VisibleCount - 1 do
    begin
      Result := VisibleItems[I].ProcessDialogKey(ACharCode, AKeyData, AFocusedItem);
      if Result then Break;
    end;
end;

procedure TdxCustomLayoutGroup.RestoreItemControlBounds;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].RestoreItemControlBounds;
end;

procedure TdxCustomLayoutGroup.SetParentComponent(Value: TComponent);
var
  AIntf: IdxLayoutContainerOwner;
begin
  if not (csAncestor in ComponentState) and
    Supports(Value, IdxLayoutContainerOwner, AIntf) and
    ((AIntf.GetContainer.Root = nil) or not AIntf.GetContainer.Root.IsLoading) then
      AIntf.GetContainer.SetRootGroup(Self as TdxLayoutGroup)
  else
    inherited;
end;

function TdxCustomLayoutGroup.GetStoredProperties(AProperties: TStrings): Boolean;
begin
  Result := inherited GetStoredProperties(AProperties);
  AProperties.Add('Hidden');
  AProperties.Add('LayoutDirection');
  AProperties.Add('ItemIndex');
  AProperties.Add('Expanded');
  AProperties.Add('ShowBorder');
  ButtonOptions.GetStoredProperties(AProperties);
end;

procedure TdxCustomLayoutGroup.GetStoredPropertyValue(const AName: string; var AValue: Variant);
begin
  if AName = 'Hidden' then
    AValue := Hidden
  else
    if AName = 'LayoutDirection' then
      AValue := Variant(LayoutDirection)
    else
      if AName = 'ItemIndex' then
        AValue := ItemIndex
      else
        if AName = 'Expanded' then
          AValue := Expanded
        else
          if AName = 'ShowBorder' then
            AValue := ShowBorder
          else
          begin
            inherited GetStoredPropertyValue(AName, AValue);
            ButtonOptions.GetStoredPropertyValue(AName, AValue);
          end;
end;

procedure TdxCustomLayoutGroup.SetStoredPropertyValue(const AName: string; const AValue: Variant);
begin
  if AName = 'Hidden' then
    Hidden := AValue
  else
    if AName = 'LayoutDirection' then
      LayoutDirection := AValue
    else
      if AName = 'ItemIndex' then
        ItemIndex := AValue
      else
        if AName = 'Expanded' then
          Expanded := AValue
        else
          if AName = 'ShowBorder' then
            ShowBorder := AValue
          else
          begin
            inherited SetStoredPropertyValue(AName, AValue);
            ButtonOptions.SetStoredPropertyValue(AName, AValue);
          end;
end;

function CompareItemsByLoadedIndex(AItem1, AItem2: Pointer): Integer;
begin
  Result := TdxCustomLayoutItem(AItem1).FLoadedIndex - TdxCustomLayoutItem(AItem2).FLoadedIndex;
  if Result = 0 then
    Result := TdxCustomLayoutItem(AItem1).Index - TdxCustomLayoutItem(AItem2).Index;
end;

procedure TdxCustomLayoutGroup.ChangeScale(M: Integer; D: Integer);
begin
  inherited ChangeScale(M, D);
  ButtonOptions.ChangeScale(M, D);
  TabbedOptions.ChangeScale(M, D);
end;

procedure TdxCustomLayoutGroup.CheckIndex;
var
  I: Integer;
begin
  inherited;
  FItems.Sort(CompareItemsByLoadedIndex);
  TabbedOptions.CheckTabs;
  for I := 0 to Count - 1 do
    Items[I].CheckIndex;
end;

function TdxCustomLayoutGroup.NeedDeleteAfterLoading: Boolean;
begin
  Result := (Count = 0) and inherited NeedDeleteAfterLoading;
end;

procedure TdxCustomLayoutGroup.PopulateItems(AList: TList);
var
  I: Integer;
begin
  inherited;
  for I := 0 to Count - 1 do
    Items[I].PopulateItems(AList);
end;

procedure TdxCustomLayoutGroup.BeforeCalculateViewInfo;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].BeforeCalculateViewInfo;
  BuildVisibleItemsList;
end;

procedure TdxCustomLayoutGroup.AfterCalculateViewInfo;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].AfterCalculateViewInfo;
  inherited;
end;

procedure TdxCustomLayoutGroup.ApplyCalculatedChanges;

  procedure UpdateInternalControls;
  var
    AViewInfo: TdxLayoutGroupViewInfo;
  begin
    ButtonOptions.UpdateInternalButtons;

    AViewInfo := ViewInfo;
    if (AViewInfo <> nil) and (AViewInfo.FMajorScrollBar <> nil) then
      AViewInfo.FMajorScrollBar.Visible := ActuallyVisible and AViewInfo.IsScrollBarsVisible;
    if (AViewInfo <> nil) and (AViewInfo.FMinorScrollBar <> nil) then
      AViewInfo.FMinorScrollBar.Visible := ActuallyVisible and AViewInfo.IsScrollBarsVisible;
  end;

var
  I: Integer;
begin
  UpdateInternalControls;

  for I := 0 to Count - 1 do
    if (LayoutDirection <> ldTabbed) or (I <> ItemIndex) then
      Items[I].ApplyCalculatedChanges;
  if (LayoutDirection = ldTabbed) and (ItemIndex >= 0) then
    Items[ItemIndex].ApplyCalculatedChanges;
  inherited;
end;

procedure TdxCustomLayoutGroup.ResetRealAlign;
var
  I: Integer;
begin
  inherited;
  if not IsDestroying and not IsLoading then
    for I := 0 to Count - 1 do
      Items[I].ResetRealAlign;
end;

procedure TdxCustomLayoutGroup.ResetEnabled;
var
  I: Integer;
begin
  inherited;
  if not IsDestroying and not IsLoading then
    for I := 0 to Count - 1 do
      Items[I].ResetEnabled;
end;

function TdxCustomLayoutGroup.GetOptions: TdxCustomLayoutLookAndFeelOptions;
begin
  Result := GetLayoutLookAndFeel.GroupOptions;
end;

function TdxCustomLayoutGroup.GetAllowScroll: Boolean;
begin
  Result := (ScrollOptions.Horizontal <> smNone) or (ScrollOptions.Vertical <> smNone);
end;

function TdxCustomLayoutGroup.GetAllowWrapItems: Boolean;
begin
  Result := WrapItemsMode <> wmNone;
end;

function TdxCustomLayoutGroup.GetAutoCreatedForDirection: Boolean;
begin
  Result := AutoCreated and not AutoCreatedForWrap;
end;

function TdxCustomLayoutGroup.IsGroup: Boolean;
begin
  Result := True;
end;

function TdxCustomLayoutGroup.IsFloatingRoot: Boolean;
begin
  Result := IsRoot and (Count = 1) and Items[0].FIsFloat;
end;

procedure TdxCustomLayoutGroup.DoCheckBoxStateChanged;
begin
  CallNotify(FOnCheckBoxStateChanged, Self);
end;

function TdxCustomLayoutGroup.DoCheckBoxStateChanging(ANewState: TcxCheckBoxState): Boolean;
begin
  Result := True;
  if Assigned(FOnCheckBoxStateChanging) then
    FOnCheckBoxStateChanging(Self, ANewState, Result);
end;

procedure TdxCustomLayoutGroup.DoCollapsed;
begin
  CallNotify(FOnCollapsed, Self);
end;

function TdxCustomLayoutGroup.DoCollapsing: Boolean;
begin
  Result := True;
  if Assigned(FOnCollapsing) then
    FOnCollapsing(Self, Result);
end;

procedure TdxCustomLayoutGroup.DoExpanded;
begin
  CallNotify(FOnExpanded, Self);
end;

function TdxCustomLayoutGroup.DoExpanding: Boolean;
begin
  Result := True;
  if Assigned(FOnExpanding) then
    FOnExpanding(Self, Result);
end;

procedure TdxCustomLayoutGroup.DoTabChanged;
begin
  if not Container.IsCustomization and (LayoutDirection = ldTabbed) then
    CallNotify(FOnTabChanged, Self);
end;

function TdxCustomLayoutGroup.DoTabChanging(ANewTabIndex: Integer): Boolean;
begin
  Result := True;
  if not Container.IsCustomization and Assigned(FOnTabChanging) then
    FOnTabChanging(Self, ANewTabIndex, Result);
end;

procedure TdxCustomLayoutGroup.BuildVisibleItemsList(ARecursive: Boolean = False);
var
  I: Integer;
  AItem: TdxCustomLayoutItem;
begin
  FVisibleItems.Clear;
  for I := 0 to Count - 1 do
  begin
    AItem := Items[I];
    if ARecursive and AItem.IsGroup then
      AItem.AsGroup.BuildVisibleItemsList(ARecursive);
    if AItem.GetVisible then
      FVisibleItems.Add(AItem);
  end;

  TabbedOptions.RefreshTabsVisible;

  if (ItemIndex = dxLayoutPseudoActiveItem) and (VisibleCount > 0) then
    FItemIndex := VisibleItems[0].Index
  else
    if (VisibleCount = 0) and (ItemIndex >= 0) then
      FItemIndex := dxLayoutPseudoActiveItem
    else
      if VisibleCount > 0 then
      begin
        FItemIndex := Max(0, FItemIndex);
        if (ItemIndex > Count - 1) then
          FItemIndex := VisibleItems[VisibleCount - 1].Index;
        while (FItemIndex > 0) and not Items[ItemIndex].GetVisible do
          Dec(FItemIndex);
        while (ItemIndex < Count - 1) and not Items[ItemIndex].GetVisible do
          Inc(FItemIndex);
      end;
end;

function TdxCustomLayoutGroup.GetMaxChildImageSize: TSize;
var
  I: Integer;
  AImageSize: TSize;
begin
  Result := cxNullSize;
  for I := 0 to VisibleCount - 1 do
  begin
    AImageSize := VisibleItems[I].CaptionOptions.ImageOptions.GetImageSize;
    Result.Width := Max(Result.Width, AImageSize.Width);
    Result.Height := Max(Result.Height, AImageSize.Height);
  end;
end;

function TdxCustomLayoutGroup.GetHelperClass: TdxLayoutGroupHelperClass;
begin
  case LayoutDirection of
    ldHorizontal: Result := TdxLayoutHorizontalGroupHelper;
    ldVertical: Result := TdxLayoutVerticalGroupHelper;
    ldTabbed: Result := TdxLayoutTabbedGroupHelper;
  else
    raise EdxException.Create('TdxCustomLayoutGroup.GetHelperClass fails');
  end;
end;

function TdxCustomLayoutGroup.GetChildItemsAlignHorz: TdxLayoutRealAlignHorz;
begin
  Result := GetHelperClass.GetChildItemsAlignHorz;
end;

function TdxCustomLayoutGroup.GetChildItemsAlignVert: TdxLayoutRealAlignVert;
begin
  Result := GetHelperClass.GetChildItemsAlignVert;
end;

function TdxCustomLayoutGroup.CanFocus(AByMouse: Boolean): Boolean;
begin
  Result := GetEnabled and ActuallyVisible and ViewInfo.Specific.CanFocus;
end;

function TdxCustomLayoutGroup.FocusFirst(ACheckTabStop: Boolean): Boolean;
var
  I: Integer;
begin
  Result := CanFocus(False);
  if Result then
    Container.FocusController.SetItemFocus(Self)
  else
    for I := 0 to VisibleCount - 1 do
    begin
      Result := VisibleItems[I].FocusFirst(ACheckTabStop);
      if Result then
        Break;
    end;
end;

function GetStraightItemCount(AGroup: TdxCustomLayoutGroup): Integer;
var
  I, ACounter: Integer;
begin
  Result := 0;
  ACounter := 0;
  for I := 0 to AGroup.Count - 1 do
    if AGroup[I].IsGroup and not AGroup[I].AsGroup.AutoCreatedForWrap then
      ACounter := 0
    else
    begin
      Inc(ACounter);
      Result := Max(Result, ACounter);
    end;
end;

function TdxCustomLayoutGroup.CanWrapItems: Boolean;

  function GetStableGroup(AGroup: TdxCustomLayoutGroup): TdxCustomLayoutGroup;
  begin


    if AGroup.IsRoot then
      Result := AGroup
    else
    begin
      Result := AGroup.Parent;
      if not Result.IsStable then
        Result := GetStableGroup(Result);
    end;
  end;

begin
  Result := (LayoutDirection <> ldTabbed) and not IsFloatingRoot and (WrapItemsMode <> wmNone) and
    (Count > 1) and
    (CanWrapImmediateChildItems or (Parent <> nil) and Parent.CanWrapAllChildItems) and
      not IsAvailable;
end;

function TdxCustomLayoutGroup.CanWrapImmediateChildItems: Boolean;
begin
  Result := 
    ((WrapItemsMode in [wmImmediateChildren, wmAllChildren]) or
    (WrapItemsMode = wmParentManaged) and (IsRoot and Container.AllowGroupWrapItems or (Parent <> nil) and Parent.CanWrapAllChildItems));
end;

function TdxCustomLayoutGroup.CanWrapAllChildItems: Boolean;
begin
  Result := (WrapItemsMode in [wmAllChildren]) or
    (WrapItemsMode = wmParentManaged) and (IsRoot and Container.AllowGroupWrapItems or (Parent <> nil) and Parent.CanWrapAllChildItems);
end;

function TdxCustomLayoutGroup.GetWrapRowCount: Integer;
var
  I: Integer;
begin
  if (LayoutDirection = ldVertical) then
    Result := GetStraightItemCount(Self)
  else
    Result := 1;
  for I := 0 to Count - 1 do
    if Items[I].IsGroup then
      Result := Max(Result, Items[I].AsGroup.GetWrapRowCount);
end;

function TdxCustomLayoutGroup.GetWrapColumnCount: Integer;
var
  I: Integer;
begin
  if LayoutDirection = ldHorizontal then
    Result := GetStraightItemCount(Self)
  else
    Result := 1;
  for I := 0 to Count - 1 do
    if Items[I].IsGroup then
      Result := Max(Result, Items[I].AsGroup.GetWrapColumnCount);
end;

function TdxCustomLayoutGroup.IsWrapItemsAllowed: Boolean;
var
  I: Integer;
begin
  Result := not Container.IsCustomization and CanWrapItems;
  for I := 0 to Count - 1 do
    Result := Result or Items[I].IsWrapItemsAllowed;
end;

function TdxCustomLayoutGroup.AllowFloatingDragImage: Boolean;
const
  ACountLimit = 100;
var
  AVisibleCount: Integer;

  procedure CalculateVisibleCount(AGroup: TdxCustomLayoutGroup);
  var
    I: Integer;
  begin
    Inc(AVisibleCount, AGroup.VisibleCount);
    for I := 0 to AGroup.VisibleCount - 1 do
    begin
      if AVisibleCount >= ACountLimit then
        Break;
      if AGroup.VisibleItems[I].IsGroup then
        CalculateVisibleCount(AGroup.VisibleItems[I].AsGroup);
    end;

  end;

begin
  AVisibleCount := 0;
  CalculateVisibleCount(Self);
  Result := Container.AllowFloatingDragImage and (AVisibleCount < ACountLimit);
end;

function TdxCustomLayoutGroup.AllowShowChild(AChild: TdxCustomLayoutItem): Boolean;
begin
  Result := (LayoutDirection <> ldTabbed) or AChild.CanBeAlone;
end;

procedure TdxCustomLayoutGroup.BiDiModeChanged;
var
  I: Integer;
begin
  inherited BiDiModeChanged;
  for I := 0 to Count - 1 do
    Items[I].BiDiModeChanged;
end;

function TdxCustomLayoutGroup.IsAnyButtonVisible: Boolean;
begin
  Result := ButtonOptions.IsAnyButtonVisible;
end;

function TdxCustomLayoutGroup.IsCheckBoxVisible: Boolean;
begin
  Result := ButtonOptions.Visible and ButtonOptions.CheckBox.Visible;
end;

procedure TdxCustomLayoutGroup.ChangeItemIndex(AItem: TdxCustomLayoutItem; Value: Integer);
begin
  if AItem.Index <> Value then
  begin
    FItems.Move(AItem.Index, Value);
    TabbedOptions.CheckTabs;
    Container.CustomizeFormUpdateList(Self);
    if AItem.GetVisible then
      Changed;
  end;
end;

procedure TdxCustomLayoutGroup.ChangeItemVisibleIndex(AItem: TdxCustomLayoutItem;
  Value: Integer);
begin
  ChangeItemIndex(AItem, GetItemIndex(Value));
end;

function TdxCustomLayoutGroup.GetItemIndex(AItemVisibleIndex: Integer): Integer;
begin
  if (0 <= AItemVisibleIndex) and (AItemVisibleIndex < VisibleCount) then
    Result := VisibleItems[AItemVisibleIndex].Index
  else
    Result := Count;
end;

function TdxCustomLayoutGroup.IndexOf(AItem: TdxCustomLayoutItem): Integer;
begin
  Result := FItems.IndexOf(AItem);
end;

function TdxCustomLayoutGroup.IsSuperfluous(AForDestroy: Boolean): Boolean;
begin
  Result := False;
end;

function TdxCustomLayoutGroup.VisibleIndexOf(AItem: TdxCustomLayoutItem): Integer;
begin
  Result := FVisibleItems.IndexOf(AItem);
end;

function TdxCustomLayoutGroup.CreateGroup: TdxLayoutGroup;
begin
  Result := TdxLayoutGroup(Container.CreateGroup(TdxLayoutGroup, Self));
end;

function TdxCustomLayoutGroup.CreateGroup(AGroupClass: TdxCustomLayoutGroupClass): TdxCustomLayoutGroup;
begin
  Result := Container.CreateGroup(AGroupClass, Self);
end;

function TdxCustomLayoutGroup.CreateItem(AItemClass: TdxCustomLayoutItemClass = nil): TdxCustomLayoutItem;
begin
  Result := Container.CreateItem(AItemClass, Self);
end;

function TdxCustomLayoutGroup.CreateItemForControl(AControl: TControl): TdxLayoutItem;
begin
  Result := Container.CreateItemForControl(AControl, Self);
end;

function TdxCustomLayoutGroup.CanMoveTo(AParent: TdxCustomLayoutItem): Boolean;
begin
  Result := (AParent = nil) or inherited CanMoveTo(AParent) and not IsChildItem(AParent);
end;

procedure TdxCustomLayoutGroup.Dismiss;
begin
  MoveChildrenToParent(False);
  Free;
end;

procedure TdxCustomLayoutGroup.MoveChildrenToParent(AKeepAlign: Boolean);
var
  AInsertionIndex, I: Integer;
begin
  AInsertionIndex := Index;
  for I := Count - 1 downto 0 do
    Items[I].InternalMove(Parent, AInsertionIndex, False, AKeepAlign);
end;

procedure TdxCustomLayoutGroup.MoveChildrenIntoHiddenGroup(AGroup: TdxCustomLayoutGroup);
var
  I: Integer;
begin
  for I := Count - 2 downto 0 do
    Items[I].Move(AGroup, 0);
end;

function TdxCustomLayoutGroup.PutChildrenIntoHiddenGroup: TdxLayoutAutoCreatedGroup;
begin
  Result := Container.GetAutoCreatedGroup;
  Result.Parent := Self;
  Result.LayoutDirection := LayoutDirection;
  MoveChildrenIntoHiddenGroup(Result);
end;

constructor TdxCustomLayoutAutoCreatedGroup.Create(AOwner: TComponent);
begin
  inherited;
  FHidden := True;
  FAutoCreated := True;
  DefaultCaption := cxGetResourceString(@sdxLayoutControlNewAutoCreatedGroup);
end;

function TdxCustomLayoutAutoCreatedGroup.IsStable: Boolean;
begin
  Result := False;
end;

procedure TdxCustomLayoutAutoCreatedGroup.DoPack;
begin
  inherited;
  if IsSuperfluous(True) then
    DoPackAsSuperfluous;
end;

class function TdxCustomLayoutAutoCreatedGroup.GetItemClassKind: Integer;
begin
  Result := ickAutoCreatedGroup
end;

{ TdxLayoutAutoCreatedGroup }

destructor TdxLayoutAutoCreatedGroup.Destroy;
begin
  inherited; 
end;

procedure TdxLayoutAutoCreatedGroup.Loaded;
begin
  inherited Loaded;
  if (csAncestor in ComponentState) and not Container.IsLoading then
  begin
    Container.Modified;
    Container.PostLayoutChanged;
  end;
end;

function TdxLayoutAutoCreatedGroup.GetBaseName: string;
begin
  Result := inherited GetBaseName + 'AutoCreatedGroup';
end;

function TdxLayoutAutoCreatedGroup.IsSuperfluous(AForDestroy: Boolean): Boolean;

  function IsChildAlignSuperfluous(AChild: TdxCustomLayoutItem): Boolean;
  begin
    Result := (LayoutDirection <> ldTabbed) and
     ((AChild.GetRealAlignVert = GetRealAlignVert) or (GetRealAlignVert = avClient) and (Parent.LayoutDirection = ldHorizontal)) and
      ((AChild.GetRealAlignHorz = GetRealAlignHorz) or (GetRealAlignHorz = ahClient) and (Parent.LayoutDirection = ldVertical));
  end;

  function IsAlignSuperfluous: Boolean;
  var
    I: Integer;
  begin
    Result := True;
    for I := 0 to Count - 1 do
      Result := Result and IsChildAlignSuperfluous(Items[I]);
  end;

  function IsAlignPushInside: Boolean;
  begin
    Result := (Parent.Count = 1) and
      (Parent.GetRealAlignHorz in [ahLeft, ahCenter, ahRight]) and
      (Parent.GetRealAlignVert in [avTop, avCenter, avBottom]);
  end;

  function IsTakeoffParent: Boolean;
  var
    I: Integer;
    AItem: TdxCustomLayoutItem;
  begin
    Result := False;
    for I := 0 to Container.ManagedItemCount - 1 do
    begin
      AItem := Container.ManagedItems[I];
      if (AItem.FTakeoffParent = Self) or (AItem.FParentBeforeDrag = Self) then
      begin
        Result := True;
        Break;
      end;
    end;
  end;

  function IsSignificantOptionAssigned: Boolean;
  begin
    Result := AllowQuickCustomize or AllowScroll or (LayoutLookAndFeel <> nil);
  end;

begin
  if AForDestroy and IsTakeoffParent or FIsFloat or IsDragged or IsLoading or Container.IsLoading or (Count > 1) and (WrapItemsMode <> wmParentManaged) then
    Result := False
  else
  begin
    Result := not IsRoot and not Locked and not IsSignificantOptionAssigned and
      ((Count = 0) or
       (Parent <> nil) and
         ((Count = 1) and (not Items[0].IsGroup or not Items[0].AsGroup.AutoCreatedForWrap) and (IsChildAlignSuperfluous(Items[0]) or IsAlignPushInside or IsAlignSuperfluous) or
           not Parent.AutoCreated and
             ((Parent.Count = 1) and dxLayoutIsSameAlign(TdxLayoutAlign(RealAlign), TdxLayoutAlign(Parent.RealAlign)) or
             ((Parent.LayoutDirection = LayoutDirection) or (Parent.Count = 1)) and (IsAlignPushInside or IsAlignSuperfluous))
         )
      );
  end;
end;

procedure TdxLayoutAutoCreatedGroup.DoPackAsSuperfluous;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].Align := TdxLayoutAlign(Items[I].RealAlign);
  if (Parent <> nil) and (Count > 0) and (Parent.Count = 1) then
    Parent.LayoutDirection := LayoutDirection;
  MoveChildrenToParent(True);
  Container.TryDestroySuperfluousGroup(Self)
end;

{ TdxLayoutAutoCreatedWrappingGroup }

constructor TdxLayoutAutoCreatedWrappingGroup.Create(AOwner: TComponent);
begin
  inherited;
  FAutoCreatedForWrap := True;
  Align := dxLayoutAlign(ahParentManaged, avTop);
end;

destructor TdxLayoutAutoCreatedWrappingGroup.Destroy;
begin
  inherited; 
end;

function TdxLayoutAutoCreatedWrappingGroup.CanWrapItems: Boolean;
begin
  Result := Count > 1;
end;

function TdxLayoutAutoCreatedWrappingGroup.GetBaseName: string;
begin
  Result := inherited GetBaseName + 'AutoCreatedWrappingGroup';
end;

function TdxLayoutAutoCreatedWrappingGroup.GetChildItemsAlignHorz: TdxLayoutRealAlignHorz;
begin
  if Parent <> nil then
    Result := Parent.GetChildItemsAlignHorz
  else
    Result := inherited GetChildItemsAlignHorz;
end;

function TdxLayoutAutoCreatedWrappingGroup.GetChildItemsAlignVert: TdxLayoutRealAlignVert;
begin
  if Parent <> nil then
    Result := Parent.GetChildItemsAlignVert
  else
    Result := inherited GetChildItemsAlignVert;
end;

function TdxLayoutAutoCreatedWrappingGroup.IsSuperfluous(AForDestroy: Boolean): Boolean;
begin
  if {AForDestroy and IsTakeoffParent or} FIsFloat or IsDragged or IsLoading or Container.IsLoading then
    Result := False
  else
    Result :=
      (Parent = nil) or
      (Count = 0) or
      (Parent.LayoutDirection = LayoutDirection) or
      (Count = 1) and (LayoutDirection = ldVertical) or
      (Count = 1) and (LayoutDirection = ldHorizontal) and (Align.Horz in [ahClient, ahParentManaged]) and (Items[0].Align.Vert in [avTop, avClient, avParentManaged]);
end;

procedure TdxLayoutAutoCreatedWrappingGroup.DoPackAsSuperfluous;
begin
  MoveChildrenToParent(False);
  Container.TryDestroySuperfluousGroup(Self)
end;

{ TdxLayoutGroup }

function TdxLayoutGroup.CanFloat: Boolean;
begin
  Result := not Hidden and not IsParentLocked and (AllowFloating or Container.AllowFloatingGroups);
end;

function TdxLayoutGroup.GetBaseName: string;
begin
  Result := inherited GetBaseName + 'Group';
end;

class function TdxLayoutGroup.GetItemClassKind: Integer;
begin
  Result := ickGroup;
end;

{ TdxCustomLayoutElementPainter }

constructor TdxCustomLayoutElementPainter.Create(AViewInfo: TdxCustomLayoutElementViewInfo);
begin
  inherited Create;
  FViewInfo := AViewInfo;
end;

destructor TdxCustomLayoutElementPainter.Destroy;
begin
  FViewInfo := nil;
  inherited;
end;

procedure TdxCustomLayoutElementPainter.Paint(ACanvas: TcxCanvas);
begin
end;

{ TdxCustomLayoutItemElementPainter }

function TdxCustomLayoutItemElementPainter.GetLayoutLookAndFeel: TdxCustomLayoutLookAndFeel;
begin
  Result := ViewInfo.LayoutLookAndFeel;
end;

function TdxCustomLayoutItemElementPainter.GetLookAndFeel: TcxLookAndFeel;
begin
  Result := ViewInfo.LookAndFeel;
end;

function TdxCustomLayoutItemElementPainter.GetViewInfo: TdxCustomLayoutItemElementViewInfo;
begin
  Result := TdxCustomLayoutItemElementViewInfo(inherited ViewInfo);
end;

{ TdxCustomLayoutItemCaptionPainter }

function TdxCustomLayoutItemCaptionPainter.GetViewInfo: TdxCustomLayoutItemCaptionViewInfo;
begin
  Result := TdxCustomLayoutItemCaptionViewInfo(inherited ViewInfo);
end;

procedure TdxCustomLayoutItemCaptionPainter.DoPaint(ACanvas: TcxCanvas);
begin
  DrawBackground(ACanvas);
  DrawText(ACanvas);
  DrawGlyph(ACanvas);
end;

procedure TdxCustomLayoutItemCaptionPainter.DrawBackground(ACanvas: TcxCanvas);
begin
end;

procedure TdxCustomLayoutItemCaptionPainter.DrawGlyph(ACanvas: TcxCanvas);
begin
  if ViewInfo.IsImageVisible then
    DoDrawGlyph(ACanvas);
end;

procedure TdxCustomLayoutItemCaptionPainter.DrawText(ACanvas: TcxCanvas);
begin
  if ViewInfo.IsTextVisible then
  begin
    ACanvas.SaveState;
    try
      ACanvas.Brush.Style := bsClear;
      ViewInfo.PrepareCanvas(ACanvas, True);
      DoDrawText(ACanvas);
    finally
      ACanvas.RestoreState;
    end;
  end;
end;

function TdxCustomLayoutItemCaptionPainter.DrawEnabled: Boolean;
begin
  Result := ViewInfo.Enabled or (ViewInfo.TextColor <> clDefault);
end;

function TdxCustomLayoutItemCaptionPainter.GetTextRect: TRect;
begin
  Result := ViewInfo.TextAreaBounds;
  if DrawEnabled then
    ViewInfo.AdjustTextAreaBounds(Result);
end;

procedure TdxCustomLayoutItemCaptionPainter.DoDrawFormattedText(ACanvas: TcxCanvas; ARect: TRect);

  procedure DoActuallyDrawFormattedText;
  begin
    ViewInfo.CalculateFormattedText(ViewInfo.FormattedText, ViewInfo.CalculateTextFlags(ACanvas), ARect, ACanvas.Canvas, True);
    ViewInfo.FormattedText.Draw(ACanvas.Canvas, ARect.TopLeft);
  end;

begin
  if ViewInfo.Enabled or (ViewInfo.TextColor <> clDefault) then
    DoActuallyDrawFormattedText
  else
  begin 
    Inc(ARect.Left);
    Inc(ARect.Top);
    ACanvas.Font.Color := clBtnHighlight;
    DoActuallyDrawFormattedText;

    ARect := cxRectOffset(ARect, -1, -1);
    ACanvas.Font.Color := clBtnShadow;
    DoActuallyDrawFormattedText;
  end;
end;

procedure TdxCustomLayoutItemCaptionPainter.DoDrawText(ACanvas: TcxCanvas);
var
  ABitmap: TcxAlphaBitmap;
  ARect: TRect;
begin
  ARect := GetTextRect;
  if ViewInfo.IsTextFormatted then
  begin
    if ViewInfo.GetRotationAngle = ra0 then
      DoDrawFormattedText(ACanvas, ARect)
    else
    begin
      ABitmap := TcxAlphaBitmap.CreateSize(cxRectRotate(ARect), True);
      try
        ABitmap.cxCanvas.FillRect(ABitmap.ClientRect, ViewInfo.ItemViewInfo.GetBackgroundColor);
        ViewInfo.PrepareCanvas(ABitmap.cxCanvas, True);
        DoDrawFormattedText(ABitmap.cxCanvas, ABitmap.ClientRect);
        ABitmap.Rotate(ViewInfo.GetRotationAngle);
        TdxImageDrawer.DrawUncachedImage(ACanvas.Handle, ARect, ARect, ABitmap, nil, -1, idmNormal);
      finally
        ABitmap.Free;
      end;
    end;
  end
  else
    if ViewInfo.IsOnGlass then
      dxDrawTextOnGlass(ACanvas, ViewInfo.Text, ARect, ViewInfo.CalculateTextFlags(ACanvas), True, ViewInfo.GetRotationAngle)
    else
      ACanvas.DrawText(ViewInfo.Text, ARect, ViewInfo.CalculateTextFlags(ACanvas), DrawEnabled, ViewInfo.GetRotationAngle);
end;

procedure TdxCustomLayoutItemCaptionPainter.DoDrawGlyph(ACanvas: TcxCanvas);
begin
  dxDrawItemGlyph(ACanvas, ViewInfo.Item, ViewInfo.ImageAreaBounds,
    ViewInfo.GetRotationAngle, LayoutLookAndFeel.GetItemCaptionColorPalette);
end;

procedure TdxCustomLayoutItemCaptionPainter.Paint(ACanvas: TcxCanvas);
begin
  inherited;
  if RectVisible(ACanvas.Handle, ViewInfo.Bounds) then
    DoPaint(ACanvas);
end;

{ TdxCustomLayoutCheckableItemCaptionPainter }

function TdxCustomLayoutCheckableItemCaptionPainter.GetTextRect: TRect;
begin
  Result := cxRectInflate(inherited GetTextRect, -dxFocusRectReservedThickness);
end;


{ TdxCustomLayoutItemPainter }

function TdxCustomLayoutItemPainter.GetLayoutLookAndFeel: TdxCustomLayoutLookAndFeel;
begin
  Result := ViewInfo.LayoutLookAndFeel;
end;

function TdxCustomLayoutItemPainter.GetLookAndFeel: TcxLookAndFeel;
begin
  Result := ViewInfo.LookAndFeel;
end;

function TdxCustomLayoutItemPainter.GetViewInfo: TdxCustomLayoutItemViewInfo;
begin
  Result := TdxCustomLayoutItemViewInfo(inherited ViewInfo);
end;

procedure TdxCustomLayoutItemPainter.DoDrawBackground(ACanvas: TcxCanvas);
begin
  ACanvas.FillRect(ViewInfo.BackgroundBounds, ViewInfo.GetBackgroundColor);
end;

procedure TdxCustomLayoutItemPainter.DoDrawCaption(ACanvas: TcxCanvas);
begin
  with GetCaptionPainterClass.Create(ViewInfo.CaptionViewInfo) do
    try
      Paint(ACanvas);
    finally
      Free;
    end;
end;

procedure TdxCustomLayoutItemPainter.DoDrawSpecificPart(ACanvas: TcxCanvas);
begin
// do nothing
end;

procedure TdxCustomLayoutItemPainter.DrawDragImageFrame(ACanvas: TcxCanvas);
begin
  FrameRectByColor(ACanvas.Handle, ViewInfo.SelectionBorderRect, TdxLayoutDragAndDropState.GetDragImageFrameColor(ViewInfo));
end;

procedure TdxCustomLayoutItemPainter.DrawBackground(ACanvas: TcxCanvas);
begin
  if CanDrawBackground then
    DoDrawBackground(ACanvas);
end;

procedure TdxCustomLayoutItemPainter.DrawCaption(ACanvas: TcxCanvas);
begin
  if CanDrawCaption then
    DoDrawCaption(ACanvas);
end;

procedure TdxCustomLayoutItemPainter.DrawItem(ACanvas: TcxCanvas);
begin
  DrawBackground(ACanvas);
  DrawContent(ACanvas);
end;

procedure TdxCustomLayoutItemPainter.DrawContent(ACanvas: TcxCanvas);
begin
  DrawCaption(ACanvas);
end;

function TdxCustomLayoutItemPainter.CanDrawBackground: Boolean;
begin
  Result := ViewInfo.CanDrawBackground;
end;

function TdxCustomLayoutItemPainter.CanDrawCaption: Boolean;
begin
  Result := ViewInfo.HasCaption;
end;

function TdxCustomLayoutItemPainter.CanPaint: Boolean;
begin
  Result := ViewInfo.CanPaint;
end;

function TdxCustomLayoutItemPainter.CanDrawSpecificPart: Boolean;
begin
  Result := CanPaint and ViewInfo.IsDragImagePainting;
end;

procedure TdxCustomLayoutItemPainter.DrawSpecificPart(ACanvas: TcxCanvas);
begin
  if CanDrawSpecificPart then
    DoDrawSpecificPart(ACanvas);
end;

procedure TdxCustomLayoutItemPainter.DrawDesignFeatures(ACanvas: TcxCanvas);
begin
// do nothing
end;

procedure TdxCustomLayoutItemPainter.Paint(ACanvas: TcxCanvas);
begin
  inherited;
  if CanPaint and RectVisible(ACanvas.Handle, ViewInfo.Bounds) then
  begin
    DrawItem(ACanvas);
  end;
end;

procedure TdxCustomLayoutItemPainter.PaintDragImage(ACanvas: TcxCanvas);
begin
  Paint(ACanvas);
  DrawDragImageFrame(ACanvas);
  DrawSpecificPart(ACanvas);
end;

{ TdxLayoutItemControlPainter }

function TdxLayoutControlItemControlPainter.GetViewInfo: TdxLayoutControlItemControlViewInfo;
begin
  Result := TdxLayoutControlItemControlViewInfo(inherited ViewInfo);
end;

procedure TdxLayoutControlItemControlPainter.DrawBorders(ACanvas: TcxCanvas);
begin
  LayoutLookAndFeel.DrawItemControlBorder(ACanvas, ViewInfo.ItemViewInfo.Options, ViewInfo.Bounds);
end;

procedure TdxLayoutControlItemControlPainter.Paint(ACanvas: TcxCanvas);
begin
  inherited;
  if ViewInfo.HasBorder and RectVisible(ACanvas.Handle, ViewInfo.Bounds) then
    DrawBorders(ACanvas);
end;

{ TdxLayoutEmptySpaceItemPainter }

procedure TdxLayoutEmptySpaceItemPainter.DrawContent(ACanvas: TcxCanvas);
begin
  if ViewInfo.IsDragged and ViewInfo.IsAvailable then
    with ViewInfo.CaptionViewInfo do
      ACanvas.DrawText(Text, TextAreaBounds, 0, True)
  else
    {do nothing};
end;

{ TdxLayoutDirectionalItemPainter }

procedure TdxLayoutDirectionalItemPainter.DrawContent(ACanvas: TcxCanvas);
begin
  if ViewInfo.IsDragged and ViewInfo.IsAvailable then
    with ViewInfo.CaptionViewInfo do
      ACanvas.DrawText(Text, TextAreaBounds, 0, True)
  else
    DoDrawContent(ACanvas);
end;

procedure TdxLayoutDirectionalItemPainter.DoDrawContent(ACanvas: TcxCanvas);
begin
end;

{ TdxLayoutSeparatorItemPainter }

procedure TdxLayoutSeparatorItemPainter.DoDrawContent(ACanvas: TcxCanvas);
begin
  LookAndFeel.Painter.DrawSeparator(ACanvas, ViewInfo.SeparatorBounds, ViewInfo.IsVertical);
end;

procedure TdxLayoutSeparatorItemPainter.DrawContent(ACanvas: TcxCanvas);
begin
  if CanDrawCaption then
  begin
    ACanvas.SaveClipRegion;
    try
      ACanvas.ExcludeClipRect(cxRectInflate(ViewInfo.CaptionViewInfo.Bounds, cxTextOffset, cxTextOffset));
      DoDrawContent(ACanvas);
    finally
      ACanvas.RestoreClipRegion;
    end;
  end
  else
    DoDrawContent(ACanvas);

  DrawCaption(ACanvas);
end;

function TdxLayoutSeparatorItemPainter.GetViewInfo: TdxLayoutSeparatorItemViewInfo;
begin
  Result := TdxLayoutSeparatorItemViewInfo(inherited ViewInfo);
end;

procedure TdxLayoutSplitterItemPainter.DoDrawContent(ACanvas: TcxCanvas);

  function GetArrowDirection: TcxArrowDirection;
  const
    ArrowDirectionHorizontal: array[Boolean, ahLeft..ahRight] of TcxArrowDirection =
      ((adLeft, adLeft, adRight), (adRight, adRight, adLeft));
    ArrowDirectionVertical: array[Boolean, avTop..avBottom] of TcxArrowDirection =
      ((adUp, adUp, adDown), (adDown, adDown, adUp));
  begin
    case ViewInfo.Splitter.Parent.LayoutDirection of
      ldHorizontal:
        Result := ArrowDirectionHorizontal[ViewInfo.Splitter.IsClosed xor
          ViewInfo.Splitter.Container.UseRightToLeftAlignment, ViewInfo.AlignHorz];
    else {ldVertical:}
      Result := ArrowDirectionVertical[ViewInfo.Splitter.IsClosed, ViewInfo.AlignVert];
    end;
  end;

  function NeedDrawCloseMark: Boolean;
  begin
    Result := ViewInfo.Splitter.AllowCloseOnClick and ((not ViewInfo.IsVertical and (ViewInfo.AlignVert in [avTop, avBottom])) or
      (ViewInfo.IsVertical and (ViewInfo.AlignHorz in [ahLeft, ahRight])));
  end;

var
  APrevClipRgn: TcxRegion;
begin
  if NeedDrawCloseMark then
  begin
    if (LookAndFeel.Painter.LookAndFeelStyle <> lfsSkin) and
      (((ViewInfo.IsVertical) and ((ViewInfo.Bounds.Width < 10)) or
      (not ViewInfo.IsVertical and (ViewInfo.Bounds.Height < 10)))) then
    begin
      APrevClipRgn := ACanvas.GetClipRegion;
      try
        if ViewInfo.IsVertical then
          ACanvas.SetClipRegion(TcxRegion.Create(cxRectInflate(ViewInfo.Bounds, ViewInfo.Splitter.ScaleFactor.Apply(4), 0)), roSet)
        else
          ACanvas.SetClipRegion(TcxRegion.Create(cxRectInflate(ViewInfo.Bounds, 0, ViewInfo.Splitter.ScaleFactor.Apply(4))), roSet);

        LookAndFeel.Painter.DrawScaledSplitter(ACanvas, ViewInfo.Bounds, levsHot in ViewInfo.State,
          levsPressed in ViewInfo.State, not ViewInfo.IsVertical, ViewInfo.Splitter.ScaleFactor, True, GetArrowDirection);
      finally
        ACanvas.SetClipRegion(APrevClipRgn, roSet);
      end;
    end
    else
      LookAndFeel.Painter.DrawScaledSplitter(ACanvas, ViewInfo.Bounds, levsHot in ViewInfo.State,
        levsPressed in ViewInfo.State, not ViewInfo.IsVertical, ViewInfo.Splitter.ScaleFactor, True, GetArrowDirection);
  end
  else
    LookAndFeel.Painter.DrawScaledSplitter(ACanvas, ViewInfo.Bounds, levsHot in ViewInfo.State,
      levsPressed in ViewInfo.State, not ViewInfo.IsVertical, ViewInfo.Splitter.ScaleFactor);
end;

function TdxLayoutSplitterItemPainter.GetViewInfo: TdxLayoutSplitterItemViewInfo;
begin
  Result := TdxLayoutSplitterItemViewInfo(inherited ViewInfo);
end;

{ TdxLayoutLabeledItemPainter }

function TdxLayoutLabeledItemPainter.CanDrawCaption: Boolean;
begin
  Result := inherited CanDrawCaption or (ViewInfo.IsDragImagePainting and not ViewInfo.ActuallyVisible);
end;

function TdxLayoutLabeledItemPainter.GetCaptionPainterClass: TdxCustomLayoutItemCaptionPainterClass;
begin
  Result := TdxLayoutItemCaptionPainter;
end;

{ TdxCustomLayoutCheckableItemPainter }

function TdxCustomLayoutCheckableItemPainter.GetCaptionPainterClass: TdxCustomLayoutItemCaptionPainterClass;
begin
  Result := TdxCustomLayoutCheckableItemCaptionPainter;
end;

{ TdxLayoutImageItemPainter }

procedure TdxLayoutImageItemPainter.DrawContent(ACanvas: TcxCanvas);
begin
  DrawContentImage(ACanvas);
  inherited;
end;

procedure TdxLayoutImageItemPainter.DrawContentImage(ACanvas: TcxCanvas);
var
  AItem: TdxLayoutImageItem;
  AImageSize: TSize;
  ARect: TRect;
begin
  AItem := ViewInfo.Item;
  AImageSize := dxGetImageSize(AItem.Image, AItem.ScaleFactor);
  ARect := cxGetImageRect(ViewInfo.ImageAreaBounds, AImageSize, AItem.ImageFitMode);
  AItem.Image.StretchDraw(ACanvas.Handle, ARect);
end;

function TdxLayoutImageItemPainter.GetViewInfo: TdxLayoutImageItemViewInfo;
begin
  Result := TdxLayoutImageItemViewInfo(inherited ViewInfo);
end;

{ TdxLayoutCheckBoxItemPainter }

procedure TdxLayoutCheckBoxItemPainter.DrawContent(ACanvas: TcxCanvas);
const
  AStyleBorderStyles: array [TcxLookAndFeelStyle] of TcxEditCheckBoxBorderStyle =
    (TcxEditCheckBoxBorderStyle.ebsFlat, TcxEditCheckBoxBorderStyle.ebs3D,
    TcxEditCheckBoxBorderStyle.ebsUltraFlat, TcxEditCheckBoxBorderStyle.ebsNone,
    TcxEditCheckBoxBorderStyle.ebsOffice11, TcxEditCheckBoxBorderStyle.ebsNone);
var
  APainter: TcxCustomLookAndFeelPainter;
  ABorderStyle: TcxEditCheckBoxBorderStyle;
begin
  inherited DrawContent(ACanvas);

  ABorderStyle := TcxEditCheckBoxBorderStyle.ebsNone;
  if TdxCustomLayoutLookAndFeelAccess(LayoutLookAndFeel).DoesCxLookAndFeelHavePriority then
  begin
    APainter := LookAndFeel.Painter;
    if APainter.LookAndFeelStyle in [lfsFlat, lfsStandard, lfsUltraFlat, lfsOffice11] then
    begin
      ABorderStyle := AStyleBorderStyles[APainter.LookAndFeelStyle];
      APainter := nil;
    end;
  end
  else
    APainter := nil;

  DrawScaledEditCheck(ACanvas, ViewInfo.CellViewInfo.Bounds, ViewInfo.Item.State, GetEditCheckState,
    ViewInfo.Item.CheckBoxOptions.Glyph, ViewInfo.Item.CheckBoxOptions.GlyphCount, ABorderStyle,
    LookAndFeel.NativeStyle, clNone, clNone, False, ViewInfo.Item.IsDesigning, ViewInfo.IsFocused,
    ViewInfo.Item.CheckBoxOptions.AllowGrayed, APainter, ViewInfo.Item.ScaleFactor);
end;

function TdxLayoutCheckBoxItemPainter.GetEditCheckState: TcxEditCheckState;
begin
  Result := ecsNormal;
  if not ViewInfo.Enabled then
    Result := ecsDisabled
  else
    if levsPressed in ViewInfo.State then
      Result := ecsPressed
    else
      if levsHot in ViewInfo.State then
        Result := ecsHot;
end;

function TdxLayoutCheckBoxItemPainter.GetViewInfo: TdxLayoutCheckBoxItemViewInfo;
begin
  Result := TdxLayoutCheckBoxItemViewInfo(inherited ViewInfo);
end;

{ TdxLayoutRadioButtonItemPainter }

procedure TdxLayoutRadioButtonItemPainter.DrawContent(ACanvas: TcxCanvas);
const
  CBrushColorMap: array [Boolean] of TColor = (clDefault, clNone);
var
  ACheckBounds: TRect;
begin
  inherited DrawContent(ACanvas);

  ACheckBounds := ViewInfo.CellViewInfo.Bounds;
  LookAndFeel.GetAvailablePainter(totButton).DrawScaledRadioButton(ACanvas, ACheckBounds.Left,
    ACheckBounds.Top, GetButtonState, ViewInfo.Item.Checked, ViewInfo.IsFocused,
    CBrushColorMap[Assigned(LookAndFeel.SkinPainter)], ViewInfo.Item.ScaleFactor, ViewInfo.Item.IsDesigning);
end;

function TdxLayoutRadioButtonItemPainter.GetButtonState: TcxButtonState;
begin
  Result := cxbsNormal;
  if not ViewInfo.Enabled then
    Result := cxbsDisabled
  else
    if levsPressed in ViewInfo.State then
      Result := cxbsPressed
    else
      if levsHot in ViewInfo.State then
        Result := cxbsHot;
end;

function TdxLayoutRadioButtonItemPainter.GetViewInfo: TdxLayoutRadioButtonItemViewInfo;
begin
  Result := TdxLayoutRadioButtonItemViewInfo(inherited ViewInfo);
end;

{ TdxLayoutControlItemPainter }

function TdxLayoutControlItemPainter.GetViewInfo: TdxLayoutControlItemViewInfo;
begin
  Result := TdxLayoutControlItemViewInfo(inherited ViewInfo);
end;

function TdxLayoutControlItemPainter.CanDrawSpecificPart: Boolean;
begin
  Result := CanPaint and ViewInfo.ActuallyVisible and ViewInfo.HasControl;
end;

function TdxLayoutControlItemPainter.GetCaptionPainterClass: TdxCustomLayoutItemCaptionPainterClass;
begin
  Result := TdxLayoutControlItemCaptionPainter;
end;

function TdxLayoutControlItemPainter.GetControlPainterClass: TdxLayoutControlItemControlPainterClass;
begin
  Result := TdxLayoutControlItemControlPainter;
end;

procedure TdxLayoutControlItemPainter.DoDrawControlBorder(ACanvas: TcxCanvas);
begin
  with GetControlPainterClass.Create(ViewInfo.ControlViewInfo) do
    try
      Paint(ACanvas);
    finally
      Free;
    end;
end;

procedure TdxLayoutControlItemPainter.DrawContent(ACanvas: TcxCanvas);
begin
  DrawControlBorder(ACanvas);
  inherited;
end;

procedure TdxLayoutControlItemPainter.DrawControlBorder(ACanvas: TcxCanvas);
begin
  if ViewInfo.HasControl then
    DoDrawControlBorder(ACanvas);
end;

{ TdxLayoutItemPainter }

function TdxLayoutItemPainter.GetCaptionPainterClass: TdxCustomLayoutItemCaptionPainterClass;
begin
  Result := TdxLayoutItemCaptionPainter;
end;

function TdxLayoutItemPainter.GetControlPainterClass: TdxLayoutControlItemControlPainterClass;
begin
  Result := TdxLayoutItemControlPainter;
end;

procedure TdxLayoutItemPainter.DoDrawSpecificPart(ACanvas: TcxCanvas);

  function GetControlRect(AControl: TControl): TRect; // copy from cxPC
  begin
    Result := Rect(0, 0, AControl.Width, AControl.Height);
  end;

begin
  ACanvas.SaveState;
  try
    if ViewInfo.Item.HasWinControl then
    begin
      with ViewInfo.Item.Control.BoundsRect.TopLeft do
        ViewInfo.Item.WinControl.PaintTo(ACanvas.Canvas, X, Y);
    end
    else
    begin
      with ViewInfo.Item.Control.BoundsRect.TopLeft do
        MoveWindowOrg(ACanvas.Handle, X, Y);
      ACanvas.IntersectClipRect(GetControlRect(ViewInfo.Item.Control));
      ViewInfo.Item.Control.Perform(WM_ERASEBKGND, ACanvas.Handle, ACanvas.Handle);
      ViewInfo.Item.Control.Perform(WM_PAINT, ACanvas.Handle, 0);
    end;
  finally
    ACanvas.RestoreState;
  end;
end;

function TdxLayoutItemPainter.GetViewInfo: TdxLayoutItemViewInfo;
begin
  Result := TdxLayoutItemViewInfo(inherited ViewInfo);
end;

{ TdxLayoutGroupButtonPainter }

procedure TdxLayoutGroupButtonPainter.Paint(ACanvas: TcxCanvas);
var
  AInternalGlyph: TBitmap;
  APainter: TcxCustomLookAndFeelPainter;
begin
  inherited;

  APainter := GetButtonPainter(LookAndFeel);

  if (ViewInfo.IsExpandButton or ViewInfo.IsHomeButton) or IsGlyphAssigned(ViewInfo.Glyph) then
  begin
    AInternalGlyph := CreateInternalGlyph(APainter);
    try
      DrawButton(ACanvas, APainter, AInternalGlyph);
    finally
      AInternalGlyph.Free;
    end;
  end
  else
    DrawButton(ACanvas, APainter, nil);
end;

function TdxLayoutGroupButtonPainter.CreateInternalGlyph(APainter: TcxCustomLookAndFeelPainter): TcxBitmap32;

  procedure DrawGroupHomeButtonMark(ACanvas: TcxCanvas; APainter: TcxCustomLookAndFeelPainter; R: TRect);
  begin
    R := cxRectContent(R, Rect(5, 6, 5, 4));

    ACanvas.Pen.Color := APainter.ButtonSymbolColor(ViewInfo.GetState);
    if ColorToRGB(ACanvas.Pen.Color) = 0 then
      ACanvas.Brush.Color := clWhite
    else
      ACanvas.Brush.Color := APainter.ButtonColor(ViewInfo.GetState);

    ACanvas.Rectangle(R);
    ACanvas.MoveTo(R.Left - 1, R.Top);
    ACanvas.LineTo(cxRectCenter(R).X, R.Top - 4);
    ACanvas.MoveTo(cxRectCenter(R).X, R.Top - 4 + 1);
    ACanvas.LineTo(R.Right + 1, R.Top + 1);
  end;

  function CreateInternalGlyphCore: TcxBitmap32;
  var
    AIsAlphaSupported: Boolean;
  begin
    AIsAlphaSupported := (APainter.LookAndFeelStyle = lfsSkin) and ViewInfo.IsExpandButton;
    Result := TcxBitmap32.CreateSize(16, 16, AIsAlphaSupported);
    if not AIsAlphaSupported then
      Result.cxCanvas.FillRect(Result.ClientRect, clFuchsia);

    if ViewInfo.IsExpandButton then
      APainter.DrawGroupBoxScaledExpandGlyph(Result.cxCanvas, Result.ClientRect, ViewInfo.GetState, ViewInfo.IsGroupExpanded, dxDefaultScaleFactor)
    else // ViewInfo.IsHomeButton
      DrawGroupHomeButtonMark(Result.cxCanvas, APainter, Result.ClientRect);

    if not AIsAlphaSupported then
      Result.RecoverTransparency(clFuchsia);
  end;

var
  ATempBitmap: TcxBitmap32;
begin
  if IsGlyphAssigned(ViewInfo.Glyph) then
  begin
    Result := TcxBitmap32.CreateSize(ScaleFactor.Apply(ViewInfo.Glyph.ClientRect), True);
    TdxImageDrawer.DrawImage(Result.cxCanvas, Result.ClientRect, ViewInfo.Glyph, ifmNormal,
      GetLayoutLookAndFeel.GetGroupButtonColorPalette(ViewInfo.GetState), ScaleFactor)
  end
  else
    if ViewInfo.IsExpandButton or ViewInfo.IsHomeButton then
    begin
      if ScaleFactor.Assigned then
      begin
        ATempBitmap := CreateInternalGlyphCore;
        try
          Result := TcxBitmap32.CreateSize(ScaleFactor.Apply(ATempBitmap.ClientRect));
          cxSmoothResizeBitmap(ATempBitmap, Result, True);
        finally
          ATempBitmap.Free;
        end;
      end
      else
        Result := CreateInternalGlyphCore;
    end
    else
      Result := nil;
end;

procedure TdxLayoutGroupButtonPainter.DrawButton(ACanvas: TcxCanvas; APainter: TcxCustomLookAndFeelPainter; AGlyph: TGraphic);
var
  ABitmap: TcxBitmap;
begin
  APainter.DrawGroupBoxScaledButton(ACanvas, ViewInfo.Bounds, ViewInfo.GetState, ScaleFactor);
  if AGlyph <> nil then
  begin
    ABitmap := TcxAlphaBitmap.CreateSize(AGlyph.Width, AGlyph.Height, True);
    try
      TdxImageDrawer.DrawUncachedImage(ABitmap.Canvas.Handle, ABitmap.ClientRect, ABitmap.ClientRect, AGlyph, nil, -1,
        idmNormal, False, 0, clNone, True, GetLayoutLookAndFeel.GetGroupButtonColorPalette(ViewInfo.GetState));
      ACanvas.RotateBitmap(ABitmap, ViewInfo.GetRotationAngle);
      TdxImageDrawer.DrawImage(ACanvas, cxRectCenter(ViewInfo.Bounds, ABitmap.Width, ABitmap.Height), ABitmap, nil, -1, ViewInfo.IsEnabled);
    finally
      ABitmap.Free;
    end;
  end;
end;

function TdxLayoutGroupButtonPainter.GetScaleFactor: TdxScaleFactor;
begin
  Result := ViewInfo.Item.ScaleFactor;
end;

function TdxLayoutGroupButtonPainter.GetViewInfo: TdxLayoutGroupButtonViewInfo;
begin
  Result := TdxLayoutGroupButtonViewInfo(inherited ViewInfo);
end;

{ TdxLayoutGroupCheckBoxButtonPainter }

procedure TdxLayoutGroupCheckBoxButtonPainter.Paint(ACanvas: TcxCanvas);
var
  APainter: TcxCustomLookAndFeelPainter;
  ASize: TSize;
  AViewInfo: TdxLayoutGroupCheckBoxButtonViewInfo;
begin
  AViewInfo := TdxLayoutGroupCheckBoxButtonViewInfo(ViewInfo);
  ASize := AViewInfo.GetCheckBoxSize(ACanvas);
  if TdxCustomLayoutLookAndFeelAccess(LayoutLookAndFeel).DoesCxLookAndFeelHavePriority then
    APainter := LookAndFeel.Painter
  else
    APainter := nil;
  DrawScaledEditCheck(ACanvas, cxRectCenter(ViewInfo.Bounds, ASize), TdxLayoutGroupCheckBoxButton(ViewInfo.Button).State,
    AViewInfo.GetEditCheckState, nil, 0, TcxEditCheckBoxBorderStyle.ebsNone, LookAndFeel.NativeStyle, clNone, clNone,
    False, ViewInfo.Item.IsDesigning, ViewInfo.Item.IsFocused, False, APainter, ViewInfo.Item.ScaleFactor);
end;

{ TdxLayoutGroupPainter }

procedure TdxLayoutGroupPainter.DrawSpecificPart(ACanvas: TcxCanvas);
var
  I: Integer;
begin
  inherited;
  for I := 0 to ViewInfo.ItemViewInfoCount - 1 do
    ViewInfo.ItemViewInfos[I].GetPainter.DrawSpecificPart(ACanvas);
end;

procedure TdxLayoutGroupPainter.DrawDesignFeatures(ACanvas: TcxCanvas);
var
  I: Integer;
begin
  inherited;
  for I := 0 to ViewInfo.ItemViewInfoCount - 1 do
    ViewInfo.ItemViewInfos[I].GetPainter.DrawDesignFeatures(ACanvas);
end;

function TdxLayoutGroupPainter.GetViewInfo: TdxLayoutGroupViewInfo;
begin
  Result := (inherited ViewInfo).AsGroupViewInfo;
end;

function TdxLayoutGroupPainter.GetCaptionPainterClass: TdxCustomLayoutItemCaptionPainterClass;
begin
  Result := TdxLayoutGroupCaptionPainter;
end;

procedure TdxLayoutGroupPainter.DrawContent(ACanvas: TcxCanvas);
begin
  DrawBorders(ACanvas);
  DrawSpecificControls(ACanvas);
  DrawItemsArea(ACanvas);
  inherited;
  DrawButtons(ACanvas);
end;

function TdxLayoutGroupPainter.CanDrawBorders: Boolean;
begin
  Result := ViewInfo.HasBorder;
end;

function TdxLayoutGroupPainter.CanDrawSpecificControls: Boolean;
begin
  Result := ViewInfo.CanDrawSpecificControls;
end;

function TdxLayoutGroupPainter.HasCaptionBackground: Boolean;
begin
  Result := True;
end;

procedure TdxLayoutGroupPainter.DoDrawBorders(ACanvas: TcxCanvas);
begin
end;

procedure TdxLayoutGroupPainter.DoDrawButtons(ACanvas: TcxCanvas);
var
  I: Integer;
  AButtonViewInfo: TdxLayoutGroupButtonViewInfo;
begin
  for I := 0 to ViewInfo.ButtonsViewInfo.ButtonViewInfoCount - 1 do
  begin
    AButtonViewInfo := ViewInfo.ButtonsViewInfo.ButtonViewInfos[I];
    if AButtonViewInfo.Visible then
      with AButtonViewInfo.GetPainterClass.Create(AButtonViewInfo) do
      try
        Paint(ACanvas);
      finally
        Free;
      end;
  end;
end;

procedure TdxLayoutGroupPainter.DoDrawSpecificControls(ACanvas: TcxCanvas);
begin
  ViewInfo.Specific.DrawSpecificControls(ACanvas);
end;

procedure TdxLayoutGroupPainter.DrawBorders(ACanvas: TcxCanvas);
begin
  if CanDrawBorders then
  begin
    ACanvas.SaveClipRegion;
    try
      if HasCaptionBackground then
      begin
        ACanvas.ExcludeClipRect(ViewInfo.CaptionViewInfo.Bounds);
        ACanvas.ExcludeClipRect(ViewInfo.ButtonsViewInfo.Bounds);
      end;
      DoDrawBorders(ACanvas);
    finally
      ACanvas.RestoreClipRegion;
    end;
  end;
end;

procedure TdxLayoutGroupPainter.DrawButtons(ACanvas: TcxCanvas);
begin
  if ViewInfo.ButtonsViewInfo.Visible then
    DoDrawButtons(ACanvas);
end;

procedure TdxLayoutGroupPainter.DrawItems(ACanvas: TcxCanvas);
var
  I: Integer;
  AItemViewInfo: TdxCustomLayoutItemViewInfo;
begin
  ACanvas.SaveClipRegion;
  try
    ACanvas.IntersectClipRect(ViewInfo.ItemsAreaBounds); 
    for I := 0 to ViewInfo.ItemViewInfoCount - 1 do
    begin
      AItemViewInfo := ViewInfo.ItemViewInfos[I];
      if AItemViewInfo.CanPaint then
        AItemViewInfo.GetPainter.Paint(ACanvas);
    end;
  finally
    ACanvas.RestoreClipRegion;
  end;
end;

procedure TdxLayoutGroupPainter.DrawItemsArea(ACanvas: TcxCanvas);
begin
  DrawItems(ACanvas);
end;

procedure TdxLayoutGroupPainter.DrawSpecificControls(ACanvas: TcxCanvas);
begin
  if CanDrawSpecificControls then
    DoDrawSpecificControls(ACanvas);
end;

{ TdxLayoutItem }

destructor TdxLayoutItem.Destroy;
begin
  Control := nil;
  inherited Destroy;
end;

function TdxLayoutItem.GetCaptionOptions: TdxLayoutItemCaptionOptions;
begin
  Result := TdxLayoutItemCaptionOptions(inherited CaptionOptions);
end;

class function TdxLayoutItem.GetCaptionOptionsClass: TdxCustomLayoutItemCaptionOptionsClass;
begin
  Result := TdxLayoutItemCaptionOptions;
end;

function TdxLayoutItem.GetDesignSelectorRect: TRect;
const
  SelectorRectOffset = 3;
  SelectorRectWidth = 10;
var
  ASelectorRectOffsetX: Integer;
  ASelectorRectOffsetY: Integer;
begin
  Result := TdxControlsDesignSelectorHelper.CalculateBounds(Control.ClientRect, 0, SelectorRectWidth, ScaleFactor);

  ASelectorRectOffsetX := ScaleFactor.Apply(SelectorRectOffset);
  ASelectorRectOffsetY := ScaleFactor.Apply(SelectorRectOffset);
  if IsViewInfoValid then
  begin
    Dec(ASelectorRectOffsetX, ViewInfo.ControlViewInfo.BorderWidths[sdRight]);
    Dec(ASelectorRectOffsetY, ViewInfo.ControlViewInfo.BorderWidths[sdBottom]);
  end;
  OffsetRect(Result, -ASelectorRectOffsetX, -ASelectorRectOffsetY);
end;

function TdxLayoutItem.GetViewInfo: TdxLayoutItemViewInfo;
begin
  Result := TdxLayoutItemViewInfo(inherited ViewInfo);
end;

function TdxLayoutItem.GetWinControl: TWinControl;
begin
  Result := Control as TWinControl;
end;

procedure TdxLayoutItem.SetCaptionOptions(Value: TdxLayoutItemCaptionOptions);
begin
  inherited CaptionOptions := Value;
end;

procedure TdxLayoutItem.SetControl(Value: TControl);

  procedure CheckValue;
  var
    AItem: TdxLayoutItem;
  begin
    if Value <> nil then
    begin
      if Value = Container.ItemsParentControl then
        raise EdxException.Create(sdxLayoutControlContainerCannotBeControl);
      AItem := Container.FindItem(Value);
      if AItem <> nil then
        raise EdxException.Create(Format(sdxLayoutControlControlIsUsed, [Value.Name, AItem.Name]))
    end;
  end;

begin
  if FControl <> Value then
  begin
    CheckValue;
    BeginUpdate;
    Inc(FControlLockCount);
    try
      if ViewInfo <> nil then
        ViewInfo.FIsValid := False;
      if FControl <> nil then
        UnprepareControl(True);
      inherited; 
      if Value <> nil then
        PrepareControl;
    finally
      Dec(FControlLockCount);
      EndUpdate;
    end;
  end;
end;

function TdxLayoutItem.CanFocusControlOnCaptionClick: Boolean;
begin
  Result := not Container.IsCustomization and Container.IsFocusControlOnItemCaptionClick and CanFocusControl;
end;

procedure TdxLayoutItem.CreateControlAdapter;
begin
  FControlAdapter := dxLayoutControlAdapterDefs.GetAdapterClass(FControl).Create(Self);
end;

function TdxLayoutItem.CanDelete: Boolean;
begin
  Result := IsDesigning and inherited CanDelete;
end;

function TdxLayoutItem.CanProcessAccel: Boolean;
begin
  Result := CanFocusControl;
end;

procedure TdxLayoutItem.ContainerChanged;

  procedure ResetControlParent;
  var
    ASavedControl: TControl;
  begin
    if Control.Parent <> Container.ItemsParentControl then
    begin
      FIsReseting := True;
      try
        RestoreItemControlBounds;
        ASavedControl := Control;
        Control := nil;
        Control := ASavedControl;
      finally
        FIsReseting := False;
      end;
    end;
  end;

begin
  if not IsDestroying and (Container <> nil) then
  begin
    if HasControl then
      ResetControlParent
    else
      inherited;
  end;
end;

procedure TdxLayoutItem.CustomizationChanged;
begin
  if FControlAdapter <> nil then
  begin
    if Customization then
      FControlAdapter.BeginCustomization
    else
      if not (csDestroying in FControlAdapter.Control.ComponentState) then
        FControlAdapter.EndCustomization;
  end;
end;

procedure TdxLayoutItem.DoCaptionDown;
begin
  if CanFocusControlOnCaptionClick then
    SetControlFocus;
end;

procedure TdxLayoutItem.DoGetTabOrderList(List: TList);
begin
  inherited DoGetTabOrderList(List);
  if Container.IsAutoControlTabOrders then
  begin
    if CanFocusControl then
      List.Add(Control);
    if HasWinControl then
      WinControl.GetTabOrderList(List);
  end;
end;

function TdxLayoutItem.FocusFirst(ACheckTabStop: Boolean): Boolean;
begin
  Result := CanFocusControl(ACheckTabStop);
  if Result then
  begin
    SetControlFocus;
    Result := WinControl.Focused;
  end;
end;

function TdxLayoutItem.GetBaseName: string;
begin
  Result := inherited GetBaseName + 'Item';
end;

procedure TdxLayoutItem.MakeControlVisible(AFully: Boolean);
var
  AViewInfo: TdxLayoutItemViewInfo;
begin
  AViewInfo := ViewInfo;
  if AViewInfo <> nil then
    AViewInfo.MakeVisible(AViewInfo.ControlViewInfo.Bounds, AFully);
end;

class function TdxLayoutItem.GetItemClassKind: Integer;
begin
  Result := ickControlItem;
end;

function TdxLayoutItem.GetViewInfoClass: TdxCustomLayoutItemViewInfoClass;
begin
  Result := TdxLayoutItemViewInfo;
end;

procedure TdxLayoutItem.UpdateDesignSelector;
begin
  if IsDesigning then
  begin
    if Container.IsDesignSelectorsVisible and HasControl and not (csDestroying in Control.ComponentState) and
        (not HasWinControl or Control.Parent.HandleAllocated) then
    begin
      if FSelectorHelper = nil then
        FSelectorHelper := Container.CreateItemSelectorHelper(Self);
      FSelectorHelper.SelectorBounds := DesignSelectorRect
    end
    else
      FreeAndNil(FSelectorHelper);
  end;
end;

procedure TdxLayoutItem.DropControl;
begin
  UnprepareControl(False);
  FControl := nil;
end;

procedure TdxLayoutItem.PrepareControl;
begin
  CreateControlAdapter;
  FControlAdapter.BeforeInitialization;
  try
    Control.Enabled := Enabled;
    Control.Align := alNone;
    FWindowProcObject := cxWindowProcController.Add(Control, ControlWndProc);
    if IsDesigning then
      with FControl do
        ControlStyle := ControlStyle + [csNoDesignVisible];
    Container.PrepareControl(Control);
    FControlAdapter.Initialize;
  finally
    FControlAdapter.AfterInitialization;
  end;
  if not IsLoading or cxPointIsNull(Point(ControlOptions.OriginalWidth, ControlOptions.OriginalHeight)) then
    SaveOriginalControlSize(True, False);


  UpdateDesignSelector;
end;

procedure TdxLayoutItem.UnprepareControl(AFull: Boolean);
begin
  if IsDesigning then
    with Control do
      ControlStyle := ControlStyle - [csNoDesignVisible];

  FreeAndNil(FSelectorHelper);
  cxWindowProcController.Remove(FWindowProcObject);

  FreeAndNil(FControlAdapter);
  if AFull then
    Container.UnprepareControl(Control);
end;

procedure TdxLayoutItem.ProcessAccel;
begin
  SetControlFocus;
end;

procedure TdxLayoutItem.RestoreItemControlBounds;
begin
  if HasControl then
  begin
    Container.BeginPlacingControls;
    try
      if ActuallyVisible then
        Control.SetBounds(Control.Left, Control.Top, ControlOptions.OriginalWidth, ControlOptions.OriginalHeight)
      else
        Control.SetBounds(10000, 10000, ControlOptions.OriginalWidth, ControlOptions.OriginalHeight);
    finally
      Container.EndPlacingControls;
    end;
  end;
end;

procedure TdxLayoutItem.AfterCalculateViewInfo;
begin
  inherited;
  if FControlAdapter <> nil then
    FControlAdapter.AfterCalculateViewInfo;
end;

procedure TdxLayoutItem.BeforeCalculateViewInfo;
begin
  if HasWinControl and not WinControl.HandleAllocated and CanAllocateHandle(WinControl) then
    WinControl.HandleNeeded;
  inherited;
end;

procedure TdxLayoutItem.ApplyCalculatedChanges;
begin
  SetControlVisibility;
  SetControlEnablement;
  inherited;
end;

procedure TdxLayoutItem.SetInitialSettings;
begin
  inherited;
  if FControlAdapter <> nil then
    FControlAdapter.SetInitialSettings;
end;

function TdxLayoutItem.CanDragAndDrop(const P: TPoint): Boolean;
begin
  Result := inherited CanDragAndDrop(P) and not (HasControl and IsViewInfoValid and IsDesignSelectorVisible and
    Container.Customization and ViewInfo.PtInDesignSelectorRect(P));
end;

function TdxLayoutItem.CanFocusControl(ACheckTabStop: Boolean): Boolean;
begin
  Result := HasWinControl and WinControl.CanFocus and (not ACheckTabStop or WinControl.TabStop);
end;

function TdxLayoutItem.ControlLocked: Boolean;
begin
  Result := FControlLockCount > 0;
end;

procedure TdxLayoutItem.CheckAutoSize(ADropOnly: Boolean);
begin
  if (FControlAdapter <> nil) and FControlAdapter.AllowCheckAutoSize then
  begin
    FControlAdapter.SetControlAutoWidth(FControlAdapter.ControlAutoWidth and ((GetRealAlignHorz <> ahClient) or (ControlOptions.AlignHorz <> ahClient)));
    FControlAdapter.SetControlAutoHeight(FControlAdapter.ControlAutoHeight and ((GetRealAlignVert <> avClient) or (ControlOptions.AlignVert <> avClient)));
  end;
end;

procedure TdxLayoutItem.ControlWndProc(var Message: TMessage);

  function IsControlMoved: Boolean;
  begin
    Result := (Message.LParam = 0) or (PWindowPos(Message.LParam)^.flags and SWP_NOMOVE = 0);
  end;

  function IsControlResized: Boolean;
  begin
    Result := (Message.LParam = 0) or (PWindowPos(Message.LParam)^.flags and SWP_NOSIZE = 0);
  end;

  function ControlSizeChanged: Boolean;
  begin
    Result := not cxPointIsEqual(Point(Control.Width, Control.Height), OriginalControlSize);
  end;

  function NeedSaveOriginalControlSize: Boolean;
  begin
    Result := IsControlResized and FControlAdapter.AllowCheckSize and ControlSizeChanged;
  end;

begin
  if (Message.Msg = DXM_UPDATEWINDOWREGION) and IsViewInfoValid and
    (ControlAdapter <> nil) and (ControlAdapter.FNeedSetRegion or ControlAdapter.FIsRegionUsed) then
  begin
    FControlAdapter.CombineRegion(ViewInfo.ControlViewInfo.FControlWindowRect);
    ControlAdapter.FIsRegionUsed := ControlAdapter.FNeedSetRegion;
  end;

  case Message.Msg of
    WM_SIZE:
    begin
      Inc(FControlLockCount);
      FWindowProcObject.DefaultProc(Message);
      Dec(FControlLockCount);
    end
  else
    FWindowProcObject.DefaultProc(Message);
  end;

  if not ControlLocked then
    case Message.Msg of
      WM_CREATE:
        if not FIsInternalHandleCreating then
        begin
          SaveOriginalControlSize(False, True);
          UpdateDesignSelector;
        end;
      WM_SETTEXT, DXM_UPDATEWINDOWREGION:
        if (Container.ViewInfo.FSelectionLayer <> nil) and not Container.FSelectionLayerPainting then
          Container.PostBuildSelectionLayer;
      WM_SETFOCUS, DXM_CONTAINERSETFOCUS:
        MakeControlVisible(False);
      WM_WINDOWPOSCHANGING:
        if not FIsInternalHandleCreating then
        begin
          if not Container.IsPlacingControls and not Container.IsScalingControls and IsControlResized then
          begin
            FNewControlSize := Point(PWindowPos(Message.LParam)^.cx, PWindowPos(Message.LParam)^.cy);
            if FNewControlSize.X = Control.Width then
              FNewControlSize.X := -1;
            if FNewControlSize.Y = Control.Height then
              FNewControlSize.Y := -1;
          end;
        end;
      WM_WINDOWPOSCHANGED:
        if not FIsInternalHandleCreating then
        begin
          if not Container.IsPlacingControls and not Container.IsScalingControls and (IsControlResized and FControlAdapter.AllowCheckSize or IsControlMoved) then
          begin
            SaveOriginalControlSize(False, False);
            if (FNewControlSize.Y <> -1) or (FNewControlSize.X <> -1) or IsControlMoved then
              Changed;
          end;
//          if (ViewInfo <> nil) and (Control is TcxContainer) then
//            TcxContainerAccess(Control).UpdateWindowRegion(CreateRectRgnIndirect(ViewInfo.ControlViewInfo.FControlWindowRect), roIntersect);
          UpdateDesignSelector;
        end;
      CM_TABSTOPCHANGED:
        Container.CalculateTabOrders;
      CM_ENABLEDCHANGED:
        Enabled := Control.Enabled;
    end;
end;

function TdxLayoutItem.IsDesignSelectorVisible: Boolean;
var
  ARect, ARectInParent: TRect;
begin
  Result := HasControl and Container.IsDesignSelectorsVisible and IsViewInfoValid;
  if Result then
  begin
    ARect := DesignSelectorRect;
    ARectInParent.TopLeft := Control.ClientToParent(ARect.TopLeft);
    ARectInParent.BottomRight := Control.ClientToParent(ARect.BottomRight);
    ARectInParent := ViewInfo.GetVisiblePart(ARectInParent);
    Result := cxSizeIsEqual(ARectInParent, ARect) and not cxRectIsInvalid(ARect) and cxRectContain(Control.ClientRect, ARect);
  end;
end;

function TdxLayoutItem.HasControl: Boolean;
begin
  Result := FControl <> nil;
end;

function TdxLayoutItem.HasWinControl: Boolean;
begin
  Result := HasControl and (FControl is TWinControl);
end;

{
#Q477217
procedure TdxLayoutItem.SaveControlSizeBeforeDestruction;
begin
  FControlSizeBeforeDestruction := Point(Control.Width, Control.Height);
end;
}

procedure TdxLayoutItem.SaveOriginalControlSize(ASaveAnyWay, ANeedChanges: Boolean);
var
  ASize: TPoint;
begin
  if HasControl then
  begin
    if HasWinControl and Control.Parent.HandleAllocated and CanAllocateHandle(WinControl) then
    begin
      FIsInternalHandleCreating := True;
      try
        WinControl.HandleNeeded;  // for cxEditors
      finally
        FIsInternalHandleCreating := False;
      end;
    end;

    if ASaveAnyWay then
      ASize := Point(FControl.Width, FControl.Height)
    else
    begin
      ASize.X := IfThen((GetRealAlignHorz = ahClient) and (ControlOptions.AlignHorz = ahClient) and (ControlOptions.FOriginalWidth > 0), ControlOptions.FOriginalWidth, FControl.Width);
      ASize.Y := IfThen((GetRealAlignVert = avClient) and (ControlOptions.AlignVert = avClient) and (ControlOptions.FOriginalHeight > 0), ControlOptions.FOriginalHeight, FControl.Height);
    end;

    if ANeedChanges then
      OriginalControlSize := ASize
    else
    begin
      ControlOptions.FOriginalWidth := ASize.X;
      ControlOptions.FOriginalHeight := ASize.Y;
    end
  end;
end;

procedure TdxLayoutItem.SetControlEnablement;
begin
  if HasControl then
    Control.Enabled := Enabled;
end;

procedure TdxLayoutItem.SetControlFocus;
begin
  WinControl.SetFocus;
end;

procedure TdxLayoutItem.SetControlVisibility;

  procedure InternalSetControlVisibility(AValue: Boolean);
  var
    AHeight, AWidth: Integer;
  begin
    if Control.Visible <> AValue then
    begin
      Container.BeginPlacingControls;
      try
        Control.Visible := AValue;
        // to make the control invisible on showing
        if not AValue then
        begin
          if IsAvailable then
          begin
            AHeight := OriginalControlSize.Y;
            AWidth := OriginalControlSize.X;
          end
          else
          begin
            AHeight := Control.Height;
            AWidth := Control.Width;
          end;
          Control.SetBounds(10000, 10000, AWidth, AHeight);
        end
        else
        begin
          Control.BoundsRect := ViewInfo.ControlViewInfo.ControlBounds;
          if not cxSizeIsEqual(Control.BoundsRect, ViewInfo.ControlViewInfo.ControlBounds) then
          begin
            SaveOriginalControlSize(False, False);
            Container.PostLayoutChanged;
          end;
        end;
      finally
        Container.EndPlacingControls;
      end;
    end;
  end;

begin
  if HasControl then
     InternalSetControlVisibility(ActuallyVisible);
end;

{ TdxLayoutContainerPainter }

constructor TdxLayoutContainerPainter.Create(AViewInfo: TdxLayoutContainerViewInfo);
begin
  inherited Create;
  FViewInfo := AViewInfo;
end;

procedure TdxLayoutContainerPainter.DrawDesignFeatures(ACanvas: TcxCanvas);
begin
  ViewInfo.ItemsViewInfo.GetPainter.DrawDesignFeatures(ACanvas);
end;

procedure TdxLayoutContainerPainter.DrawItems(ACanvas: TcxCanvas);
var
  AFocusRect: TRect;
begin
  ViewInfo.ItemsViewInfo.GetPainter.Paint(ACanvas);
  if Container.ItemsParentControl.Focused and not Container.IsCustomization and
    (Container.FocusController.FocusedItem <> nil) and Container.FocusController.FocusedItem.IsViewInfoValid then
  begin
    AFocusRect := Container.FocusController.FocusedItem.ViewInfo.GetFocusRect(ACanvas);
    if not cxRectIsEmpty(AFocusRect) then
    begin
      ACanvas.SaveClipRegion;
      try
        ACanvas.IntersectClipRect(Container.FocusController.FocusedItem.ViewInfo.GetVisiblePart(AFocusRect));
        if Container.FocusController.FocusedItem.ViewInfo.LookAndFeel.Painter.SupportsNativeFocusRect then
          ACanvas.DrawFocusRect(AFocusRect);
      finally
        ACanvas.RestoreClipRegion;
      end;
    end;
  end;
end;

procedure TdxLayoutContainerPainter.Paint(ACanvas: TcxCanvas);
begin
  if ViewInfo.FIsValid then
    DrawItems(ACanvas);
end;

procedure TdxLayoutContainerPainter.PlaceControls(AItemViewInfo: TdxCustomLayoutItemViewInfo; AProcessWinControls: Boolean; AAdditionalFlags: Integer);
var
  AControlViewInfos, AWinControlViewInfos: TList;

  function CheckControlSize(AControlViewInfo: TdxLayoutItemControlViewInfo): Boolean;
  begin
    Result := True;
    if not cxSizeIsEqual(AControlViewInfo.ControlBounds, AControlViewInfo.Control.BoundsRect) then
    begin
      if cxSizeIsEqual(AControlViewInfo.FPrevControlSize, cxSize(AControlViewInfo.Control.BoundsRect)) then
        AControlViewInfo.FControlBounds := AControlViewInfo.Control.BoundsRect
      else
      begin
        AControlViewInfo.Item.SaveOriginalControlSize(False, False);
        Result := False;
      end;
    end;
  end;

  function CheckControlSizes(AControlViewInfos: TList): Boolean;
  var
    I: Integer;
    AControlViewInfo: TdxLayoutItemControlViewInfo;
  begin
    Result := True;
    for I := 0 to AControlViewInfos.Count - 1 do
    begin
      AControlViewInfo := TdxLayoutItemControlViewInfo(AControlViewInfos.List[I]);
      Result := CheckControlSize(AControlViewInfo) and Result; 
    end;
  end;

  procedure ProcessControls;
  var
    I: Integer;
    AControlViewInfo: TdxLayoutItemControlViewInfo;
  begin
    for I := 0 to AControlViewInfos.Count - 1 do
    begin
      AControlViewInfo := TdxLayoutItemControlViewInfo(AControlViewInfos.List[I]);
      AControlViewInfo.FPrevControlSize := cxSize(AControlViewInfo.Control.BoundsRect);
      AControlViewInfo.Control.BoundsRect := AControlViewInfo.ControlBounds;
    end;
  end;

  procedure ProcessWinControls;
  var
    AWindowsStruct: HDWP;
    I: Integer;
    AControlViewInfo: TdxLayoutItemControlViewInfo;
    R: TRect;
  begin
    AWindowsStruct := BeginDeferWindowPos(AWinControlViewInfos.Count);
    try
      for I := 0 to AWinControlViewInfos.Count - 1 do
      begin
        AControlViewInfo := TdxLayoutItemControlViewInfo(AWinControlViewInfos.List[I]);
        AControlViewInfo.FPrevControlSize := cxSize(AControlViewInfo.Control.BoundsRect);
        R := AControlViewInfo.ControlBounds;
        DeferWindowPos(AWindowsStruct, (AControlViewInfo.Control as TWinControl).Handle, 0,
          R.Left, R.Top, R.Width, R.Height, SWP_NOZORDER or SWP_NOACTIVATE or AAdditionalFlags);

        if (AControlViewInfo.Item.ControlAdapter <> nil) and
          (AControlViewInfo.Item.ControlAdapter.FNeedSetRegion or AControlViewInfo.Item.ControlAdapter.FIsRegionUsed) then
        begin
          if AControlViewInfo.Item.ControlAdapter.FIsRegionUsed and not AControlViewInfo.Item.ControlAdapter.FNeedSetRegion then
            SetWindowRgn((AControlViewInfo.Control as TWinControl).Handle, 0, True)
          else
            SetWindowRegion(AControlViewInfo.Control as TWinControl, AControlViewInfo.FControlWindowRect);
          AControlViewInfo.Item.ControlAdapter.FIsRegionUsed := AControlViewInfo.Item.ControlAdapter.FNeedSetRegion;
        end;
      end;
    finally
      EndDeferWindowPos(AWindowsStruct);
    end;

//    for I := 0 to AWinControlViewInfos.Count - 1 do
//    begin
//      AControlViewInfo := TObject(AWinControlViewInfos[I]) as TdxLayoutItemControlViewInfo;
//      if not (AControlViewInfo.Control is TcxContainer) then
//        SetWindowRegion(AControlViewInfo.Control as TWinControl, AControlViewInfo.FControlWindowRect);
//      PostMessage(TWinControl(AControlViewInfo.Control).Handle, DXM_UPDATEWINDOWREGION, 0, 0);
//    end;
  end;

var
  AHasChanges: Boolean;
begin
  if FPlaceControlsCounter = 3 then Exit;
  Inc(FPlaceControlsCounter);
  try
    Container.FIsPlaceControlsNeeded := False;

    AControlViewInfos := TList.Create;
    AWinControlViewInfos := TList.Create;
    try
      Container.BeginProcessControls;
      try
        AItemViewInfo.PopulateControlViewInfoList(AControlViewInfos, AWinControlViewInfos);
        ProcessControls;
        if AProcessWinControls then
          ProcessWinControls;
        AHasChanges := not CheckControlSizes(AControlViewInfos) or not CheckControlSizes(AWinControlViewInfos);
      finally
        Container.EndProcessControls;
      end;
      if AHasChanges then
        Container.PostLayoutChanged(ctMedium);
    finally
      AWinControlViewInfos.Free;
      AControlViewInfos.Free;
    end;
  finally
    Dec(FPlaceControlsCounter);
  end;
end;

function TdxLayoutContainerPainter.GetContainer: TdxLayoutContainer;
begin
  Result := ViewInfo.Container;
end;

{ TdxLayoutOffsets }

procedure TdxLayoutOffsets.DoAssign(Source: TPersistent);
begin
  inherited;
  if Source is TdxLayoutOffsets then
  begin
    FLeft := TdxLayoutOffsets(Source).Left;
    FTop := TdxLayoutOffsets(Source).Top;
    FRight := TdxLayoutOffsets(Source).Right;
    FBottom := TdxLayoutOffsets(Source).Bottom;
  end;
end;

procedure TdxLayoutOffsets.DoChangeScale(M, D: Integer);
begin
  inherited DoChangeScale(M, D);
  FBottom := MulDiv(FBottom, M, D);
  FLeft := MulDiv(FLeft, M, D);
  FRight := MulDiv(FRight, M, D);
  FTop := MulDiv(FTop, M, D);
end;

function TdxLayoutOffsets.GetValue(Index: Integer): Integer;
begin
  case Index of
    1: Result := FBottom;
    2: Result := FLeft;
    3: Result := FRight;
    4: Result := FTop;
  else
    Result := 0;
  end;
end;

procedure TdxLayoutOffsets.SetValue(Index: Integer; Value: Integer);
begin
  if GetValue(Index) <> Value then
  begin
    case Index of
      1: FBottom := Value;
      2: FLeft := Value;
      3: FRight := Value;
      4: FTop := Value;
    end;
    Changed;
  end;
end;

{ TdxLayoutPadding }

procedure TdxLayoutPadding.DoAssign(Source: TPersistent);
begin
  inherited;
  if Source is TdxLayoutPadding then
    AssignedValues := TdxLayoutPadding(Source).AssignedValues;
end;

function TdxLayoutPadding.GetValues: TRect;
begin
  Result := Rect(Left, Top, Right, Bottom);
end;

function TdxLayoutPadding.GetValue(Index: Integer): Integer;
var
  APadding: TRect;
begin
  if TdxLayoutPaddingAssignedValue(Index - 1) in AssignedValues then
    Exit(inherited GetValue(Index));

  APadding := Item.GetOptions.Padding.GetPaddingRect(Item.ScaleFactor);
  case Index of
    1: Result := APadding.Bottom;
    2: Result := APadding.Left;
    3: Result := APadding.Right;
    4: Result := APadding.Top;
  else
    Result := 0;
  end;
end;

procedure TdxLayoutPadding.SetValue(Index: Integer; Value: Integer);
begin
  Include(FAssignedValues, TdxLayoutPaddingAssignedValue(Index - 1));
  inherited;
end;

function TdxLayoutPadding.IsValueStored(Index: Integer): Boolean;
begin
  Result := TdxLayoutPaddingAssignedValue(Index - 1) in AssignedValues;
end;

procedure TdxLayoutPadding.SetAssignedValues(Value: TdxLayoutPaddingAssignedValues);
begin
  if FAssignedValues <> Value then
  begin
    FAssignedValues := Value;
    Changed;
  end;
end;

{ TdxLayoutCustomFloatForm }

procedure TdxLayoutCustomFloatForm.ShowFloat(const APosition: TPoint; ANeedActivate: Boolean; AHidden: Boolean = False);
begin
  if not AHidden then 
    FormStyle := fsStayOnTop
  else
    FormStyle := fsNormal;

//  Show; //# Delphi7 bug
  FIsFloat := True;
  SetBounds(APosition.X, APosition.Y, Width, Height);
//  ShowWindow(FFloatForm.Handle, SW_SHOWNOACTIVATE); //# S173377
  ShowWindow(Handle, IfThen(ANeedActivate, SW_SHOW, SW_SHOWNOACTIVATE)); 
  Visible := True; 
  DoShow;
end;

function TdxLayoutCustomFloatForm.IsSkinnable: Boolean;
begin
  Result := False;
end;


{ TdxUndoRedoManager }

constructor TdxUndoRedoManager.Create(AContainer: TdxLayoutContainer);
begin
  inherited Create;
  FContainer := AContainer;
  FRestorePoints := TObjectList.Create;
end;

destructor TdxUndoRedoManager.Destroy;
begin
  FreeAndNil(FRestorePoints);
  inherited Destroy;
end;

function TdxUndoRedoManager.CanRedo: Boolean;
begin
  Result := RedoCount > 0;
end;

function TdxUndoRedoManager.CanUndo: Boolean;
begin
  Result := UndoCount > 0;
end;

procedure TdxUndoRedoManager.Redo;
begin
  if CanRedo then
    RestoreLayout(FIndex + 1);
end;

procedure TdxUndoRedoManager.Undo;
begin
  if CanUndo then
  begin
    if not IsCurrentLayoutStored then
    begin
      AddRestorePoint;
      Dec(FIndex);
    end;
    RestoreLayout(FIndex - 1);
  end;
end;

procedure TdxUndoRedoManager.AddRestorePoint;
var
  AStream: TMemoryStream;
begin
  AStream := TMemoryStream.Create;
  Container.StoreToStream(AStream);

  while FIndex < FRestorePoints.Count do
    FRestorePoints.Delete(FIndex);
  FRestorePoints.Add(AStream);
  Inc(FIndex);
  dxTestCheck(FIndex = FRestorePoints.Count, 'TdxUndoRedoManager.AddAction fails');
end;

procedure TdxUndoRedoManager.DeleteRestorePoint;
begin
  FRestorePoints.Delete(FRestorePoints.Count - 1);
end;

procedure TdxUndoRedoManager.RollBack;
begin
  RestoreLayout(FRestorePoints.Count - 1);
end;

procedure TdxUndoRedoManager.Clear;
begin
  FRestorePoints.Clear;
  FIndex := 0;
end;

function TdxUndoRedoManager.IsCurrentLayoutStored: Boolean;
begin
  Result := FRestorePoints.Count > FIndex;
end;

procedure TdxUndoRedoManager.RestoreLayout(AIndex: Integer);
var
  AStream: TMemoryStream;
begin
  FIndex := AIndex;
  AStream := TMemoryStream(FRestorePoints[FIndex]);
  AStream.Position := 0;
  Container.RestoreFromStream(AStream);
end;

function TdxUndoRedoManager.GetRedoCount: Integer;
begin
  Result := FRestorePoints.Count - FIndex;
  if IsCurrentLayoutStored then
    Dec(Result);
end;

function TdxUndoRedoManager.GetUndoCount: Integer;
begin
  Result := FIndex;
end;

{ TdxLayoutControlCustomCustomizeForm }

destructor TdxLayoutControlCustomCustomizeForm.Destroy;
begin
  Container := nil;
  FreeAndNil(FLayoutLookAndFeel);
  inherited Destroy;
end;

procedure TdxLayoutControlCustomCustomizeForm.Initialize;
begin
  UpdateCaption;
  UpdateDragAndDropState;
  UpdateContent;
  UpdateSelection;
  UpdateView;
end;

procedure TdxLayoutControlCustomCustomizeForm.BeginUpdate;
begin
  Inc(FLockCount);
end;

procedure TdxLayoutControlCustomCustomizeForm.CancelUpdate;
begin
  Dec(FLockCount);
end;

procedure TdxLayoutControlCustomCustomizeForm.EndUpdate;
begin
  Dec(FLockCount);
  if LockCount = 0 then
    Changed;
end;

function TdxLayoutControlCustomCustomizeForm.GetHitTest(const P: TPoint): TdxCustomLayoutHitTest;
begin
  Result := TdxLayoutCustomizeFormHitTest.Instance;
  TdxLayoutCustomizeFormHitTest(Result).Item := nil;
end;

procedure TdxLayoutControlCustomCustomizeForm.ToggleHotTrackState(AItem: TdxCustomLayoutItem);
begin
end;

procedure TdxLayoutControlCustomCustomizeForm.UpdateAvailableItems;
begin
end;

procedure TdxLayoutControlCustomCustomizeForm.UpdateCaption;
begin
end;

procedure TdxLayoutControlCustomCustomizeForm.UpdateContent;
begin
end;

procedure TdxLayoutControlCustomCustomizeForm.UpdateDragAndDropState;
begin
end;

procedure TdxLayoutControlCustomCustomizeForm.UpdateSelection;
begin
end;

procedure TdxLayoutControlCustomCustomizeForm.UpdateView;
begin
end;

procedure TdxLayoutControlCustomCustomizeForm.UpdateVisibleItems;
begin
end;

procedure TdxLayoutControlCustomCustomizeForm.AssignFont(ASourceFont: TFont; ASourceScaleFactor: TdxScaleFactor);
begin
  dxAssignFont(Font, ASourceFont, ScaleFactor, ASourceScaleFactor);
end;

procedure TdxLayoutControlCustomCustomizeForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WndParent := GetWndParent;
end;

function TdxLayoutControlCustomCustomizeForm.CanAddItem: Boolean;
var
  AItemsOwner: TComponent;
begin
  AItemsOwner := Container.ItemsOwner;
  Result := (Container <> nil) and ((AItemsOwner = nil) or
    not (Container.IsDesigning and (csInline in AItemsOwner.ComponentState)));
end;

function TdxLayoutControlCustomCustomizeForm.CanModify: Boolean;
begin
  Result := (Container <> nil) and Container.CanModify;
end;

function TdxLayoutControlCustomCustomizeForm.CanShowItem(AItem: TdxCustomLayoutItem): Boolean;
begin
  Result := AItem.IsVisibleForCustomization;
end;

function TdxLayoutControlCustomCustomizeForm.DoGetMenuItems(AList: TList): TdxLayoutCustomizeFormMenuItems;
begin
  Result := Container.DoGetCustomizationMenuItems(AList);
end;

procedure TdxLayoutControlCustomCustomizeForm.DoInitializeControl;
begin
  Container.OnItemChanged := ItemChanged;
end;

function TdxLayoutControlCustomCustomizeForm.GetWndParent: THandle;
begin
  if (Container <> nil) and (Container.ItemsParentControl <> nil) and Container.ItemsParentControl.HandleAllocated then
    Result := Container.ItemsParentControl.Handle
  else
    Result := 0;
end;

function TdxLayoutControlCustomCustomizeForm.GetLayoutPopupMenu: TPopupMenu;
begin
  Result := nil;
end;

procedure TdxLayoutControlCustomCustomizeForm.InitializeControl;
begin
  DoInitializeControl;
end;

procedure TdxLayoutControlCustomCustomizeForm.RefreshLayoutLookAndFeel;
var
  ALookAndFeel: TdxCustomLayoutLookAndFeel;
begin
  if (Container <> nil) and (Container.LayoutLookAndFeel <> nil) then
  begin
    ALookAndFeel := Container.LayoutLookAndFeel;
    if FLayoutLookAndFeel = nil then
      FLayoutLookAndFeel := TdxCustomLayoutLookAndFeelClass(ALookAndFeel.ClassType).Create(Self);
    ALookAndFeel.AssignTo(FLayoutLookAndFeel, PixelsPerInch);
  end
  else
    FreeAndNil(FLayoutLookAndFeel);
end;

procedure TdxLayoutControlCustomCustomizeForm.ResetDragAndDropObjects;
begin
// do nothing
end;

procedure TdxLayoutControlCustomCustomizeForm.SetCustomizationCaption(AItem: TdxCustomLayoutItem; const ACaption: string);
begin
  if AItem.IsDesigning then
    AItem.Name := ACaption
  else
    AItem.SetInplaceRenameCaption(ACaption);
end;

function TdxLayoutControlCustomCustomizeForm.GetCustomizationCaption(AItem: TdxCustomLayoutItem): string;
begin
  if AItem.IsDesigning or (AItem.Caption = '') then
    Result := AItem.Name
  else
    if (AItem.ViewInfo <> nil) and AItem.ViewInfo.CaptionViewInfo.IsTextFormatted then
      Result := AItem.Caption
    else
      Result := RemoveAccelChars(AItem.Caption);
end;

procedure TdxLayoutControlCustomCustomizeForm.Changed;
begin
  //
end;

procedure TdxLayoutControlCustomCustomizeForm.ItemChanged(AItem: TdxCustomLayoutItem);
begin
end;

function TdxLayoutControlCustomCustomizeForm.GetIsLocked: Boolean;
begin
  Result := (LockCount > 0) or Container.IsUpdateLocked;
end;

procedure TdxLayoutControlCustomCustomizeForm.SetContainer(AValue: TdxLayoutContainer);

  procedure StoreMetrics;
  begin
    cxDialogsMetricsStore.StoreMetrics(Self);
  end;

  procedure RestoreMetrics;
  begin
    if Container <> nil then
    begin
      if EqualRect(Container.CustomizeFormBounds, cxNullRect) then
        BoundsRect := Container.CalculateCustomizeFormBounds(BoundsRect)
      else
        BoundsRect := Container.CustomizeFormBounds;
    end;
    cxDialogsMetricsStore.InitDialog(Self);
    Position := poDesigned;
  end;

begin
  if Container <> AValue then
  begin
    if Container <> nil then
    begin
      Container.Customization := False;
      Container.OnItemChanged := nil;
      StoreMetrics;
    end;
    FContainer := AValue;
    if Container <> nil then
    begin
      RecreateWnd;
      RestoreMetrics;
      InitializeControl;
    end;
  end;
end;

{ TdxCustomLayoutItemOptions }

constructor TdxCustomLayoutItemOptions.Create(AItem: TdxCustomLayoutItem);
begin
  inherited Create;
  FItem := AItem;
end;

procedure TdxCustomLayoutItemOptions.Assign(Source: TPersistent);
begin
  BeginUpdate;
  try
    DoAssign(Source);
  finally
    EndUpdate;
  end;
end;

procedure TdxCustomLayoutItemOptions.BeginUpdate;
begin
  Item.BeginUpdate;
end;

procedure TdxCustomLayoutItemOptions.EndUpdate;
begin
  Item.CancelUpdate;
  Changed;
end;

procedure TdxCustomLayoutItemOptions.Changed;
begin
  FItem.Changed;
end;

procedure TdxCustomLayoutItemOptions.ChangeScale(M, D: Integer);
begin
  BeginUpdate;
  try
    DoChangeScale(M, D);
  finally
    EndUpdate;
  end;
end;

procedure TdxCustomLayoutItemOptions.DoAssign(Source: TPersistent);
begin
// do nothing
end;

procedure TdxCustomLayoutItemOptions.DoChangeScale(M, D: Integer);
begin
// do nothing
end;

function TdxCustomLayoutItemOptions.GetIsRestoring: Boolean;
begin
  Result := FItem.IsRestoring;
end;

{ TdxCustomLayoutItemImageOptions }

constructor TdxCustomLayoutItemImageOptions.Create(AItem: TdxCustomLayoutItem);
begin
  inherited Create(AItem);
  FGlyph := TdxSmartGlyph.Create;
  FGlyph.OnChange := GlyphChanged;
  FImageIndex := -1;
end;

destructor TdxCustomLayoutItemImageOptions.Destroy;
begin
  FreeAndNil(FGlyph);
  inherited Destroy;
end;

procedure TdxCustomLayoutItemImageOptions.DoAssign(Source: TPersistent);
begin
  inherited;
  if Source is TdxCustomLayoutItemImageOptions then
  begin
    Glyph := TdxCustomLayoutItemImageOptions(Source).Glyph;
    ImageIndex := TdxCustomLayoutItemImageOptions(Source).ImageIndex;
  end;
end;

function TdxCustomLayoutItemImageOptions.GetCurrentImage(out AGlyph: TdxSmartGlyph; out AImages: TCustomImageList; out AImageIndex: Integer): Boolean;
begin
  AGlyph := nil;
  AImages := nil;
  AImageIndex := -1;

  Result := not Glyph.Empty;
  if Result then
    AGlyph := Glyph
  else
  begin
    Result := cxGraphics.IsImageAssigned(GetImageList(Item.Enabled), ImageIndex);
    if Result then
    begin
      AImages := GetImageList(Item.Enabled);
      AImageIndex := ImageIndex;
    end;
  end;
end;

function TdxCustomLayoutItemImageOptions.GetImageList(AEnabled: Boolean): TCustomImageList;
begin
  if AEnabled then
    Result := Item.Container.GetImages
  else
  begin
    Result := Item.Container.GetDisabledImages;
    if Result = nil then
      Result := Item.Container.GetImages
  end;
end;

function TdxCustomLayoutItemImageOptions.GetImageSize: TSize;
var
  AGlyph: TdxSmartGlyph;
  AImages: TCustomImageList;
  AImageIndex: Integer;
begin
  if GetCurrentImage(AGlyph, AImages, AImageIndex) then
    Result := dxGetImageSize(AGlyph, AImages, AImageIndex, Item.ScaleFactor)
  else
    Result := cxNullSize;
end;

function TdxCustomLayoutItemImageOptions.IsImageAssigned: Boolean;
var
  AImage: TdxSmartGlyph;
  AImages: TCustomImageList;
  AImageIndex: Integer;
begin
  Result := GetCurrentImage(AImage, AImages, AImageIndex);
end;

procedure TdxCustomLayoutItemImageOptions.SetGlyph(AValue: TdxSmartGlyph);
begin
  FGlyph.Assign(AValue);
end;

procedure TdxCustomLayoutItemImageOptions.SetImageIndex(AValue: Integer);
begin
  if FImageIndex <> AValue then
  begin
    FImageIndex := AValue;
    Changed;
  end;
end;

procedure TdxCustomLayoutItemImageOptions.GlyphChanged(Sender: TObject);
begin
  Changed;
end;

{ TdxCustomLayoutItemCaptionOptions }

constructor TdxCustomLayoutItemCaptionOptions.Create(AItem: TdxCustomLayoutItem);
begin
  inherited Create(AItem);
  FImageOptions := TdxCustomLayoutItemImageOptions.Create(AItem);
  FVisibleElements := [cveImage, cveText];
  FVisible := True;
  FFormattedText := TdxFormattedText.Create;
  FormattedText.MeasureTrailingSpaces := True;
  FormattedText.ShowAccelChar := True;
end;

destructor TdxCustomLayoutItemCaptionOptions.Destroy;
begin
  FreeAndNil(FFormattedText);
  FreeAndNil(FImageOptions);
  inherited Destroy;
end;

function TdxCustomLayoutItemCaptionOptions.GetGlyph: TdxSmartGlyph;
begin
  Result := ImageOptions.Glyph;
end;

function TdxCustomLayoutItemCaptionOptions.GetImageIndex: Integer;
begin
  Result := ImageOptions.ImageIndex;
end;

function TdxCustomLayoutItemCaptionOptions.GetShowAccelChar: Boolean;
begin
  Result := FormattedText.ShowAccelChar;
end;

function TdxCustomLayoutItemCaptionOptions.GetText: string;
begin
  if FIsCaptionAssigned then
    Result := FUserCaption
  else
    Result := FDefaultCaption;
end;

procedure TdxCustomLayoutItemCaptionOptions.RecoverUserCaption;
begin
  if not IsCaptionAssigned and (UserCaption <> '') then  
  begin
    FIsCaptionAssigned := UserCaption <> '';
    FormattedText.Import(Text);
  end
  else
    if IsCaptionAssigned and (UserCaption = DefaultCaption) then 
    begin
      ResetUserCaption(True);
      FormattedText.Import(Text);
    end;
end;

procedure TdxCustomLayoutItemCaptionOptions.ResetUserCaption(AFull: Boolean);
begin
  FIsCaptionAssigned := False;
  if AFull then
    FUserCaption := '';
  FormattedText.Import(Text);
end;

procedure TdxCustomLayoutItemCaptionOptions.GetStoredPropertyValue(const AName: string; var AValue: Variant);
begin
  if AName = 'Caption' then
    AValue := Text
  else
    Item.Container.DoGetItemStoredPropertyValue(Item, AName, AValue);
end;

procedure TdxCustomLayoutItemCaptionOptions.GetStoredProperties(AProperties: TStrings);
begin
  if FIsCaptionAssigned then
    AProperties.Add('Caption');
end;

procedure TdxCustomLayoutItemCaptionOptions.SetStoredPropertyValue(const AName: string; const AValue: Variant);
begin
  if AName = 'Caption' then
    UserCaption := AValue
  else
    Item.Container.DoSetItemStoredPropertyValue(Item, AName, AValue);
end;

function TdxCustomLayoutItemCaptionOptions.IsTextStored: Boolean;
begin
  Result := Text <> '';
end;

function TdxCustomLayoutItemCaptionOptions.IsTextVisible: Boolean;
begin
  Result := (cveText in VisibleElements) and (Text <> '');
end;

procedure TdxCustomLayoutItemCaptionOptions.SetAlignHorz(Value: TAlignment);
begin
  if FAlignHorz <> Value then
  begin
    FAlignHorz := Value;
    Changed;
  end;
end;

procedure TdxCustomLayoutItemCaptionOptions.SetAlignVert(Value: TdxAlignmentVert);
begin
  if FAlignVert <> Value then
  begin
    FAlignVert := Value;
    Changed;
  end;
end;

procedure TdxCustomLayoutItemCaptionOptions.SetEllipsisPosition(Value: TEllipsisPosition);
begin
  if FEllipsisPosition <> Value then
  begin
    FEllipsisPosition := Value;
    Changed;
  end;
end;

procedure TdxCustomLayoutItemCaptionOptions.SetGlyph(AValue: TdxSmartGlyph);
begin
  ImageOptions.Glyph := AValue;
end;

procedure TdxCustomLayoutItemCaptionOptions.SetImageIndex(AValue: Integer);
begin
  ImageOptions.ImageIndex := AValue;
end;

procedure TdxCustomLayoutItemCaptionOptions.SetImageOptions(Value: TdxCustomLayoutItemImageOptions);
begin
  FImageOptions.Assign(Value);
end;

procedure TdxCustomLayoutItemCaptionOptions.SetLayout(Value: TdxCaptionLayout);
begin
  if FLayout <> Value then
  begin
    FLayout := Value;
    Changed;
  end;
end;

procedure TdxCustomLayoutItemCaptionOptions.DoAssign(Source: TPersistent);
begin
  inherited;
  if Source is TdxCustomLayoutItemCaptionOptions then
  begin
    ImageOptions := TdxCustomLayoutItemCaptionOptions(Source).ImageOptions;
    VisibleElements := TdxCustomLayoutItemCaptionOptions(Source).VisibleElements;
    AlignHorz := TdxCustomLayoutItemCaptionOptions(Source).AlignHorz;
    AlignVert := TdxLayoutLabeledItemCaptionOptions(Source).AlignVert;
    Layout := TdxLayoutLabeledItemCaptionOptions(Source).Layout;
    ShowAccelChar := TdxCustomLayoutItemCaptionOptions(Source).ShowAccelChar;
    Text := TdxCustomLayoutItemCaptionOptions(Source).Text;
    Visible := TdxCustomLayoutItemCaptionOptions(Source).Visible;
  end;
end;

function TdxCustomLayoutItemCaptionOptions.GetFormattedTextFont: TFont;
begin
  Result := (Item.Container.ItemsParent as TdxLayoutControl).Font;
end;

function TdxCustomLayoutItemCaptionOptions.GetUseFormattedText: Boolean;
begin
  Result := True;
end;

procedure TdxCustomLayoutItemCaptionOptions.SetShowAccelChar(Value: Boolean);
begin
  if ShowAccelChar <> Value then
  begin
    FormattedText.ShowAccelChar := Value;
    FormattedText.Import(Text);
    Changed;
  end;
end;

procedure TdxCustomLayoutItemCaptionOptions.SetDefaultCaption(const Value: string);
begin
  if FDefaultCaption <> Value then
  begin
    FDefaultCaption := Value;
    FormattedText.Import(Text);
    Changed;
  end;
end;

procedure TdxCustomLayoutItemCaptionOptions.SetText(const Value: string);
begin
  if Item.IsLoading or Item.Container.IsTranslating then
    DefaultCaption := Value
  else
    UserCaption := Value;
end;

procedure TdxCustomLayoutItemCaptionOptions.SetUserCaption(const Value: string);
begin
  if (Value <> FUserCaption) and FIsCaptionAssigned or (Value <> FDefaultCaption) or IsRestoring then
  begin
    FIsCaptionAssigned := True;
    FUserCaption := Value;
    FormattedText.Import(Text);
    Changed;
  end;
end;

procedure TdxCustomLayoutItemCaptionOptions.SetVisibleElements(Value: TdxLayoutItemCaptionVisibleElements);
begin
  if FVisibleElements <> Value then
  begin
    FVisibleElements := Value;
    Changed;
  end;
end;

procedure TdxCustomLayoutItemCaptionOptions.SetVisible(Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Changed;
  end;
end;

{ TdxLayoutSizeOptions }

procedure TdxLayoutSizeOptions.DoAssign(Source: TPersistent);
begin
  inherited;
  if Source is TdxLayoutSizeOptions then
  begin
    Height := TdxLayoutSizeOptions(Source).Height;
    Width := TdxLayoutSizeOptions(Source).Width;
    SizableHorz := TdxLayoutSizeOptions(Source).SizableHorz;
    SizableVert := TdxLayoutSizeOptions(Source).SizableVert;
    MaxHeight := TdxLayoutSizeOptions(Source).MaxHeight;
    MaxWidth := TdxLayoutSizeOptions(Source).MaxWidth;
    AssignedValues := TdxLayoutSizeOptions(Source).AssignedValues;
  end;
end;

procedure TdxLayoutSizeOptions.DoChangeScale(M: Integer; D: Integer);
begin
  inherited DoChangeScale(M, D);
  FHeight := MulDiv(FHeight, M, D);
  FMaxHeight := MulDiv(FMaxHeight, M, D);
  FMaxWidth := MulDiv(FMaxWidth, M, D);
  FWidth := MulDiv(FWidth, M, D);
end;

procedure TdxLayoutSizeOptions.Changed;
begin
  Item.Changed(ictComplex);
end;

function TdxLayoutSizeOptions.GetSizableHorz: Boolean;
begin
  if (sovSizableHorz in AssignedValues) then
    Result := FSizableHorz
  else
    if Item.Container <> nil then
      Result := Item.Container.IsSizableHorz
    else
      Result := False;
end;

function TdxLayoutSizeOptions.GetSizableVert: Boolean;
begin
  if (sovSizableVert in AssignedValues) then
    Result := FSizableVert
  else
    if Item.Container <> nil then
      Result := Item.Container.IsSizableVert
    else
      Result := False;
end;

procedure TdxLayoutSizeOptions.SetAssignedValues(Value: TdxLayoutSizeOptionsValues);
var
  FPrevValues: TdxLayoutSizeOptionsValues;
begin
  if FAssignedValues <> Value then
  begin
    FPrevValues := FAssignedValues;
    FAssignedValues := Value;
    BeginUpdate;
    try
      FHeight := Height;
      FWidth := Width;
      FSizableHorz := SizableHorz;
      FSizableVert := SizableVert;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TdxLayoutSizeOptions.SetSizableHorz(Value: Boolean);
begin
  if FSizableHorz <> Value then
  begin
    FSizableHorz := Value;
    Include(FAssignedValues, sovSizableHorz);
    Changed;
  end;
end;

procedure TdxLayoutSizeOptions.SetSizableVert(Value: Boolean);
begin
  if FSizableVert <> Value then
  begin
    FSizableVert := Value;
    Include(FAssignedValues, sovSizableVert);
    Changed;
  end;
end;

procedure TdxLayoutSizeOptions.SetHeight(Value: Integer);
begin
  if MaxHeight > 0 then
    Value := Min(Value, MaxHeight);
  if (FHeight <> Value) and (Value >= 0) then
  begin
    FHeight := Value;
    Changed;
  end;
end;

procedure TdxLayoutSizeOptions.SetWidth(Value: Integer);
begin
  if MaxWidth > 0 then
    Value := Min(Value, MaxWidth);
  if (FWidth <> Value) and (Value >= 0) then
  begin
    FWidth := Value;
    Changed;
  end;
end;

procedure TdxLayoutSizeOptions.SetMaxHeight(Value: Integer);
begin
  FMaxHeight := Max(0, Value);
  if Height = 0 then
    Changed
  else
    Height := Height;
end;

procedure TdxLayoutSizeOptions.SetMaxWidth(Value: Integer);
begin
  FMaxWidth := Max(0, Value);
  if Width = 0 then
    Changed
  else
    Width := Width;
end;

function TdxLayoutSizeOptions.IsSizableHorzStored: Boolean;
begin
  Result := sovSizableHorz in FAssignedValues;
end;

function TdxLayoutSizeOptions.IsSizableVertStored: Boolean;
begin
  Result := sovSizableVert in FAssignedValues;
end;

{ TdxLayoutItemControlOptions }

constructor TdxLayoutItemControlOptions.Create(AItem: TdxCustomLayoutItem);
begin
  inherited;
  FAutoControlAreaAlignment := True;
  FMinHeight := dxLayoutItemControlDefaultMinHeight;
  FMinWidth := dxLayoutItemControlDefaultMinWidth;
  FShowBorder := True;
  FAlignHorz := ahClient;
  FAlignVert := avClient;
  FScalingFlags := [sfWidth, sfHeight];
end;

procedure TdxLayoutItemControlOptions.DoAssign(Source: TPersistent);
begin
  inherited;
  if Source is TdxLayoutItemControlOptions then
  begin
    AlignHorz := TdxLayoutItemControlOptions(Source).AlignHorz;
    AlignVert := TdxLayoutItemControlOptions(Source).AlignVert;
    AutoAlignment := TdxLayoutItemControlOptions(Source).AutoAlignment;
    AutoControlAreaAlignment := TdxLayoutItemControlOptions(Source).AutoControlAreaAlignment;
    AutoColor := TdxLayoutItemControlOptions(Source).AutoColor;
    FixedSize := TdxLayoutItemControlOptions(Source).FixedSize;
    MinHeight := TdxLayoutItemControlOptions(Source).MinHeight;
    MinWidth := TdxLayoutItemControlOptions(Source).MinWidth;
    Opaque := TdxLayoutItemControlOptions(Source).Opaque;
    ShowBorder := TdxLayoutItemControlOptions(Source).ShowBorder;
  end;
end;

procedure TdxLayoutItemControlOptions.DoChangeScale(M: Integer; D: Integer);
begin
  inherited DoChangeScale(M, D);

  FMinWidth := MulDiv(FMinWidth, M, D);
  FMinHeight := MulDiv(FMinHeight, M, D);
  if not (csLoading in Item.ComponentState) or (sfWidth in FScalingFlags) then
    FOriginalWidth := MulDiv(FOriginalWidth, M, D);
  if not (csLoading in Item.ComponentState) or (sfHeight in FScalingFlags) then
    FOriginalHeight := MulDiv(FOriginalHeight, M, D);
  if TdxFormHelper.CanResetScalingFlags(Item, M, D) then
    FScalingFlags := [];
end;

function TdxLayoutItemControlOptions.IsHeightUsual: Boolean;
begin
  Result := AlignVert <> avClient;
end;

function TdxLayoutItemControlOptions.IsWidthUsual: Boolean;
begin
  Result := AlignHorz <> ahClient;
end;

function TdxLayoutItemControlOptions.GetFixedSize: Boolean;
begin
  Result := ((Item.CaptionOptions.Layout in [clLeft, clRight]) and IsWidthUsual) or
    ((Item.CaptionOptions.Layout in [clTop, clBottom]) and IsHeightUsual);
end;

procedure TdxLayoutItemControlOptions.SetAlignHorz(Value: TdxLayoutItemControlAlignHorz);
begin
  if FAlignHorz <> Value then
  begin
    FAlignHorz := Value;
    Changed;
  end;
end;

procedure TdxLayoutItemControlOptions.SetAlignVert(Value: TdxLayoutItemControlAlignVert);
begin
  if FAlignVert <> Value then
  begin
    FAlignVert := Value;
    Changed;
  end;
end;

procedure TdxLayoutItemControlOptions.SetAutoControlAreaAlignment(Value: Boolean);
begin
  if FAutoControlAreaAlignment <> Value then
  begin
    FAutoControlAreaAlignment := Value;
    Changed;
  end;
end;

procedure TdxLayoutItemControlOptions.SetAutoColor(Value: Boolean);
begin
  if FAutoColor <> Value then
  begin
    FAutoColor := Value;
    Item.LayoutLookAndFeelUserChanged;
  end;
end;

procedure TdxLayoutItemControlOptions.SetFixedSize(Value: Boolean);
begin
  if FixedSize <> Value then
    if Value then
      case Item.CaptionOptions.Layout of
        clLeft:
          AlignHorz := ahRight;
        clTop:
          AlignVert := avBottom;
        clRight:
          AlignHorz := ahLeft;
        clBottom:
          AlignVert := avTop;
      end
    else
    begin
      AlignHorz := ahClient;
      AlignVert := avClient;
    end;
end;

procedure TdxLayoutItemControlOptions.SetMinHeight(Value: Integer);
begin
  if Value < 0 then
    Value := 0;
  if FMinHeight <> Value then
  begin
    FMinHeight := Value;
    Changed;
  end;
end;

procedure TdxLayoutItemControlOptions.SetMinWidth(Value: Integer);
begin
  if Value < 0 then
    Value := 0;
  if FMinWidth <> Value then
  begin
    FMinWidth := Value;
    Changed;
  end;
end;

procedure TdxLayoutItemControlOptions.SetOpaque(Value: Boolean);
begin
  if FOpaque <> Value then
  begin
    FOpaque := Value;
    Changed;
  end;
end;

procedure TdxLayoutItemControlOptions.SetShowBorder(Value: Boolean);
begin
  if FShowBorder <> Value then
  begin
    FShowBorder := Value;
    Changed;
  end;
end;

procedure TdxLayoutItemControlOptions.SetOriginalHeight(Value: Integer);
begin
  if FOriginalHeight <> Value then
  begin
    FOriginalHeight := Value;
    Include(FScalingFlags, sfHeight);
    Changed;
  end;
end;

procedure TdxLayoutItemControlOptions.SetOriginalWidth(Value: Integer);
begin
  if FOriginalWidth <> Value then
  begin
    FOriginalWidth := Value;
    Include(FScalingFlags, sfWidth);
    Changed;
  end;
end;

{ TdxLayoutControlItem }

class function TdxLayoutControlItem.GetCaptionOptionsClass: TdxCustomLayoutItemCaptionOptionsClass;
begin
  Result := TdxLayoutItemCaptionOptions;
end;

function TdxLayoutControlItem.GetViewInfoClass: TdxCustomLayoutItemViewInfoClass;
begin
  Result := TdxLayoutControlItemViewInfo;
end;

procedure TdxLayoutControlItem.CreateOptions;
begin
  inherited;
  FControlOptions := GetControlOptionsClass.Create(Self);
end;

procedure TdxLayoutControlItem.DestroyOptions;
begin
  FreeAndNil(FControlOptions);
  inherited;
end;

function TdxLayoutControlItem.GetControlOptionsClass: TdxLayoutItemControlOptionsClass;
begin
  Result := TdxLayoutItemControlOptions;
end;

procedure TdxLayoutControlItem.SetControl(AValue: TControl);
begin
  FControl := AValue;
end;

procedure TdxLayoutControlItem.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
  if Source is TdxLayoutControlItem then
    ControlOptions := TdxLayoutControlItem(Source).ControlOptions;
end;

function TdxLayoutControlItem.CanFocusControl(ACheckTabStop: Boolean): Boolean;
begin
  Result := HasControl and Enabled;
end;

procedure TdxLayoutControlItem.ChangeScale(M: Integer; D: Integer);
begin
  inherited ChangeScale(M, D);
  ControlOptions.ChangeScale(M, D);
end;

procedure TdxLayoutControlItem.DoInit;
var
  ACommonValue: Variant;

  function IsCommonValue(AValueIndex: Integer; var ACommonValue: Variant): Boolean;
  var
    I: Integer;
    AValue: Variant;

    function CheckValue(AItem: TdxCustomLayoutItem): Boolean;
    begin
      if AItem <> Self then
        case AValueIndex of
          0..2: Result := AItem is TdxLayoutItem;
        else
          Result := False;
        end
      else
        Result := False;
    end;

    function GetValue(AItem: TdxCustomLayoutItem): Variant;
    begin
      case AValueIndex of
        0: Result := TdxLayoutItem(AItem).CaptionOptions.Layout;
        1: Result := TdxLayoutItem(AItem).CaptionOptions.AlignHorz;
        2: Result := TdxLayoutItem(AItem).CaptionOptions.AlignVert;
      else
        Result := Null;
      end;
    end;

  begin
    Result := (Parent <> nil) and not Parent.Hidden;
    if not Result then
      Exit;
    Result := False;
    ACommonValue := Unassigned;
    for I := 0 to Parent.VisibleCount - 1 do
      if CheckValue(Parent.VisibleItems[I]) then
      begin
        AValue := GetValue(Parent.VisibleItems[I]);
        if VarIsEmpty(ACommonValue) then
          ACommonValue := AValue;
        Result := AValue = ACommonValue;
        if not Result then
          Break;
      end;
  end;

begin
  inherited;
  if IsCommonValue(0, ACommonValue) then
    CaptionOptions.FLayout := ACommonValue;
  if IsCommonValue(1, ACommonValue) then
    CaptionOptions.FAlignHorz := ACommonValue;
  if IsCommonValue(2, ACommonValue) then
    CaptionOptions.FAlignVert := ACommonValue;
end;

function TdxLayoutControlItem.GetViewInfo: TdxLayoutControlItemViewInfo;
begin
  Result := TdxLayoutControlItemViewInfo(inherited ViewInfo);
end;

procedure TdxLayoutControlItem.SetControlOptions(Value: TdxLayoutItemControlOptions);
begin
  FControlOptions.Assign(Value);
end;

function TdxLayoutControlItem.GetOriginalControlSize: TPoint;
begin
  Result := Point(ControlOptions.OriginalWidth, ControlOptions.OriginalHeight);
  if (FControl <> nil) and (ControlAdapter <> nil) then
  begin
    if ControlAdapter.ControlAutoWidth then
      Result.X := Control.Width;
    if ControlAdapter.ControlAutoHeight then
      Result.Y := Control.Height;
  end;
end;

procedure TdxLayoutControlItem.SetOriginalControlSize(const Value: TPoint);
var
  AHasChanges: Boolean;
begin
  AHasChanges := not cxPointIsEqual(Point(ControlOptions.OriginalWidth, ControlOptions.OriginalHeight), Value);
  if AHasChanges then
  begin
    ControlOptions.FOriginalWidth := Value.X;
    ControlOptions.FOriginalHeight := Value.Y;
    Changed;
  end;
end;

{ TdxCustomLayoutItem }

constructor TdxCustomLayoutItem.Create(AOwner: TComponent);
begin
  inherited;
  CreateOptions;
  FIsUserDefined := (AOwner = nil) or not (csDesigning in AOwner.ComponentState);
  FAllowRemove := True;
  FAlign := dxLayoutAlign(ahParentManaged, avParentManaged);
  FRealAlign := FAlign;
  FEnabled := True;
  FRealEnabled := bDefault;
  FOffsets := TdxLayoutOffsets.Create(Self);
  FPadding := TdxLayoutPadding.Create(Self);
  FVisible := True;
  FLoadedIndex := dxLayoutInitialLoadedItemIndex;
end;

procedure TdxCustomLayoutItem.BeforeDestruction;
begin
  FIsDestroying := True;
  RealContainer.BeginUpdate;
  Customization := False;

  inherited BeforeDestruction;
  AlignmentConstraint := nil;
end;

destructor TdxCustomLayoutItem.Destroy;
var
  AContainer: TdxLayoutContainer;
begin
  LayoutLookAndFeel := nil;

  FreeAndNil(FPadding);
  FreeAndNil(FOffsets);
  DestroyOptions;
  Parent := nil;
  FreeAndNil(FFloatForm);
  AContainer := RealContainer;
  inherited Destroy;
  AContainer.EndUpdate;
end;

procedure TdxCustomLayoutItem.Assign(Source: TPersistent);
begin
  if Source is TdxCustomLayoutItem then
  begin
    Align := TdxCustomLayoutItem(Source).Align;
    AlignmentConstraint := TdxCustomLayoutItem(Source).AlignmentConstraint;
    AllowRemove := TdxCustomLayoutItem(Source).AllowRemove;
    CaptionOptions := TdxCustomLayoutItem(Source).CaptionOptions;
    Enabled := TdxCustomLayoutItem(Source).Enabled;
    LayoutLookAndFeel := TdxCustomLayoutItem(Source).LayoutLookAndFeel;
    Offsets := TdxCustomLayoutItem(Source).Offsets;
    Visible := TdxCustomLayoutItem(Source).Visible;
    SizeOptions := TdxCustomLayoutItem(Source).SizeOptions;
    Index := TdxCustomLayoutItem(Source).Index;
    FIsUserDefined := (IsDesigning xor TdxCustomLayoutItem(Source).IsDesigning) or TdxCustomLayoutItem(Source).IsUserDefined;
  end
  else
    inherited;
end;

procedure TdxCustomLayoutItem.ApplyLoadedPosition;
begin
  if FLoadedFloat <> FIsFloat then
  begin
    if FLoadedFloat then
    begin
      TakeoffParent := Container.FindItem(FLoadedTakeoffParentName) as TdxCustomLayoutGroup;
      MakeFloat(FFloatPos, False);
    end
    else
    begin
      StopFloat;
      Parent := Container.FindItem(FLoadedParentName) as TdxCustomLayoutGroup;
    end;
  end
  else
    if FIsFloat then
      MoveFloat(FFloatPos)
    else
      Parent := Container.FindItem(FLoadedParentName) as TdxCustomLayoutGroup;
end;

function TdxCustomLayoutItem.GetAbsoluteIndex: Integer;
begin
  Result := Container.FAbsoluteItems.IndexOf(Self);
end;

function TdxCustomLayoutItem.GetActuallyVisible: Boolean;
begin
  Result := IsViewInfoValid and ViewInfo.ActuallyVisible;
end;

function TdxCustomLayoutItem.GetAlignHorz: TdxLayoutAlignHorz;
begin
  Result := FAlign.Horz;
end;

function TdxCustomLayoutItem.GetAlignVert: TdxLayoutAlignVert;
begin
  Result := FAlign.Vert;
end;

function TdxCustomLayoutItem.GetRealAlign: TdxLayoutRealAlign;
begin
  Result.Horz := GetRealAlignHorz;
  Result.Vert := GetRealAlignVert;
end;

function TdxCustomLayoutItem.GetRealAlignHorz: TdxLayoutRealAlignHorz;
var
  AParentAlignHorz: TdxLayoutRealAlignHorz;
begin
  if FRealAlign.Horz <> ahParentManaged then
    Result := FRealAlign.Horz
  else
  begin
    if AlignHorz = ahParentManaged then
      Result := GetParentManagedAlignHorz
    else
      Result := AlignHorz;

    if {#Q477217 not IsLoading and} (Parent <> nil) and Parent.Hidden and (Parent.Width = 0) then
    begin
      AParentAlignHorz := Parent.GetRealAlignHorz;
      if ((Parent.Count = 1) and (AParentAlignHorz in [ahLeft, ahCenter, ahRight]) or
       (Result = ahClient) and (Parent.LayoutDirection = ldHorizontal) and (AParentAlignHorz = ahLeft)) then
          Result := AParentAlignHorz;
    end;

    if not IsLoading then
      FRealAlign.Horz := Result;
  end;
end;

function TdxCustomLayoutItem.GetRealAlignVert: TdxLayoutRealAlignVert;
var
  AParentAlignVert: TdxLayoutRealAlignVert;
begin
  if FRealAlign.Vert <> avParentManaged then
    Result := FRealAlign.Vert
  else
  begin
    if AlignVert = avParentManaged then
      Result := GetParentManagedAlignVert
    else
      Result := AlignVert;

    if {#Q477217 not IsLoading and} (Parent <> nil) and Parent.Hidden and (Parent.Height = 0) then
    begin
      AParentAlignVert := Parent.GetRealAlignVert;
      if ((Parent.Count = 1) and (AParentAlignVert in [avTop, avCenter, avBottom]) or
       (Result = avClient) and (Parent.LayoutDirection = ldVertical) and (AParentAlignVert = avTop)) then
           Result := AParentAlignVert;
    end;

    FRealAlign.Vert := Result;
  end;
end;

procedure TdxCustomLayoutItem.SetAlign(Value: TdxLayoutAlign);
begin
  if (AlignHorz <> Value.Horz) or (AlignVert <> Value.Vert) then
  begin
    FAlign := Value;
    AlignChanged;
  end;
end;

procedure TdxCustomLayoutItem.SetAlignHorz(Value: TdxLayoutAlignHorz);
begin
  if AlignHorz <> Value then
  begin
    FAlign.Horz := Value;
    AlignChanged;
  end;
end;

procedure TdxCustomLayoutItem.SetAlignVert(Value: TdxLayoutAlignVert);
begin
  if AlignVert <> Value then
  begin
    FAlign.Vert := Value;
    AlignChanged;
  end;
end;

procedure TdxCustomLayoutItem.SetRealAlign(Value: TdxLayoutRealAlign);
begin
  if GetRealAlignHorz <> Value.Horz then
    AlignHorz := Value.Horz;
  if GetRealAlignVert <> Value.Vert then
    AlignVert := Value.Vert;
end;

function TdxCustomLayoutItem.GetCaption: string;
begin
  Result := CaptionOptions.Text;
end;

function TdxCustomLayoutItem.GetAutoAligns: TdxLayoutAutoAligns;
begin
  Result := [];
  if AlignHorz = ahParentManaged then
    Include(Result, aaHorizontal);
  if AlignVert = avParentManaged then
    Include(Result, aaVertical);
end;

function TdxCustomLayoutItem.GetCaptionForCustomizeForm: string;
begin
  Result := RealContainer.CustomizeForm.GetCustomizationCaption(Self);
end;

function TdxCustomLayoutItem.GetDefaultCaption: string;
begin
  Result := CaptionOptions.DefaultCaption;
end;

function TdxCustomLayoutItem.GetEnabled: Boolean;
begin
  if FRealEnabled <> bDefault then
    Result := Boolean(FRealEnabled)
  else
  begin
    Result := FEnabled and ((Parent = nil) or Parent.Enabled);
    if not IsLoading then
      FRealEnabled := TdxDefaultBoolean(Result);
  end;
end;

function TdxCustomLayoutItem.GetIndex: Integer;
begin
  if FParent = nil then
    Result := -1
  else
    Result := FParent.IndexOf(Self);
end;

function TdxCustomLayoutItem.GetIsUserRenamed: Boolean;
begin
  Result := CaptionOptions.UserCaption <> CaptionOptions.DefaultCaption;
end;

function TdxCustomLayoutItem.GetRealContainer: TdxLayoutContainer;
begin
  Result := Container.RealContainer;
end;

function TdxCustomLayoutItem.GetScaleFactor: TdxScaleFactor;
begin
  Result := Container.ScaleFactor;
end;

function TdxCustomLayoutItem.AllowFloatingDragImage: Boolean;
begin
  Result := True;
end;

function TdxCustomLayoutItem.IsAvailable: Boolean;
begin
  Result := not IsRoot and ((Parent = nil) or Parent.IsAvailable);
end;

function TdxCustomLayoutItem.IsDesigning: Boolean;
begin
  Result := csDesigning in ComponentState;
end;

function TdxCustomLayoutItem.IsDestroying: Boolean;
begin
  Result := csDestroying in ComponentState;
end;

function TdxCustomLayoutItem.IsGrabbed: Boolean;
begin
  Result := TdxLayoutDragAndDropState.SourceItemIs(Self);
end;

function TdxCustomLayoutItem.IsDragged: Boolean;
begin
  Result := IsGrabbed and TdxLayoutDragAndDropState.StateIn([ddsInProcess]);
end;

function TdxCustomLayoutItem.IsImageVisible: Boolean;
begin
  Result := (cveImage in CaptionOptions.VisibleElements) and CaptionOptions.ImageOptions.IsImageAssigned;
end;

function TdxCustomLayoutItem.IsLoading: Boolean;
begin
  Result := dxLoadingFlags * ComponentState <> [];
end;

function TdxCustomLayoutItem.IsSelected: Boolean;
begin
  Result := Container.IsComponentSelected(Self);
end;

function TdxCustomLayoutItem.IsStable: Boolean;
begin
  Result := True;
end;

function TdxCustomLayoutItem.IsTextVisible: Boolean;
begin
  Result := CaptionOptions.IsTextVisible;
end;

function TdxCustomLayoutItem.IsVisibleForCustomization: Boolean;
begin
  Result := IsDesigning or Visible and ((Parent = nil) or not IsParentLocked or Container.IsShowLockedGroupChildren);
end;

function TdxCustomLayoutItem.IsViewInfoValid: Boolean;
begin
  Result := (ViewInfo <> nil) and ViewInfo.IsValid;
end;

function TdxCustomLayoutItem.IsHeightFixed: Boolean;
begin
  Result := (Height > 0) and (GetRealAlignVert <> avClient);
end;

function TdxCustomLayoutItem.IsWidthFixed: Boolean;
begin
  Result := (Width > 0) and (GetRealAlignHorz <> ahClient);
end;

function TdxCustomLayoutItem.IsWidthLimited: Boolean;
begin
  Result := IsWidthFixed or (SizeOptions.Width > 0) and (GetRealAlignHorz = ahClient);
end;

function TdxCustomLayoutItem.GetIsRoot: Boolean;
begin
  Result := False;
end;

function TdxCustomLayoutItem.GetIsVertical: Boolean;
begin
  Result := (Parent = nil) or
    (Parent.LayoutDirection = ldHorizontal) and (GetRealAlignHorz in [ahLeft, ahCenter, ahRight]) or
    (Parent.LayoutDirection = ldVertical) and (GetRealAlignVert = avClient);
end;

function TdxCustomLayoutItem.GetViewInfo: TdxCustomLayoutItemViewInfo;
begin
  if (Container <> nil) and (Container.ViewInfo <> nil) then
    Result := Container.ViewInfo.GetItemViewInfo(Self)
  else
    Result := nil;
end;

function TdxCustomLayoutItem.GetVisibleIndex: Integer;
begin
  if FParent = nil then
    Result := -1
  else
    Result := FParent.VisibleIndexOf(Self);
end;

procedure TdxCustomLayoutItem.SetAlignmentConstraint(Value: TdxLayoutAlignmentConstraint);
begin
  if FAlignmentConstraint <> Value then
  begin
    BeginUpdate;
    try
      if FAlignmentConstraint <> nil then
        FAlignmentConstraint.InternalRemoveItem(Self);
      FAlignmentConstraint := Value;
      if FAlignmentConstraint <> nil then
        FAlignmentConstraint.InternalAddItem(Self);
    finally
      EndUpdate;
    end;
  end;
end;

procedure TdxCustomLayoutItem.SetAutoAligns(Value: TdxLayoutAutoAligns);

  function GetLoadedAlignHorz: TdxLayoutAlignHorz;
  begin
    if AlignHorz = ahParentManaged then
      Result := ahLeft
    else
      Result := AlignHorz;
  end;

  function GetLoadedAlignVert: TdxLayoutAlignVert;
  begin
    if AlignVert = avParentManaged then
      Result := avTop
    else
      Result := AlignVert;
  end;

begin
  if AutoAligns <> Value then
  begin
    BeginUpdate;
    try
      if aaHorizontal in Value then
        AlignHorz := ahParentManaged
      else
        AlignHorz := GetLoadedAlignHorz;
      if aaVertical in Value then
        AlignVert := avParentManaged
      else
        AlignVert := GetLoadedAlignVert;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TdxCustomLayoutItem.SetCaption(const Value: string);
begin
  CaptionOptions.Text := Value;
end;

procedure TdxCustomLayoutItem.SetCaptionOptions(const Value: TdxCustomLayoutItemCaptionOptions);
begin
  FCaptionOptions.Assign(Value);
end;

procedure TdxCustomLayoutItem.SetContainer(Value: TdxLayoutContainer);

  procedure CheckName;
  begin
    if (Name = '') and Container.CanSetItemName(Self) then
      Container.SetDefaultItemName(Self);
  end;

var
  APrevScaleFactor: TdxScaleFactor;
begin
  if Container <> Value then
  begin
    APrevScaleFactor := TdxScaleFactor.Create;
    try
      dxTestCheck(not IsRoot and ((Container = nil) or not Container.IsRoot(Self)) and ((Value = nil) or not Value.IsRoot(Self)), 'SetContainer for Root fails');
      if (Parent <> nil) and (Parent.Container <> Value) then
        Parent := nil; 
      if Container <> nil then
      begin
        if (Value <> nil) and (RealContainer <> Value.RealContainer) then 
        begin
          FreeAndNil(FFloatForm);
          FContainer.FManagedItems.Extract(Self);
        end;
        APrevScaleFactor.Assign(ScaleFactor);
        FContainer.RemoveItem(Self);
        FContainer := nil;
      end;
      if Value <> nil then
      begin
        FContainer := Value;
        FContainer.InsertItem(Self);
        if not ((csLoading in ComponentState) or APrevScaleFactor.Equals(ScaleFactor)) then
        begin
          ChangeScale(
            ScaleFactor.Numerator * APrevScaleFactor.Denominator,
            ScaleFactor.Denominator * APrevScaleFactor.Numerator);
        end;
      end;
    finally
      APrevScaleFactor.Free;
    end;
    CheckName;
    BeginUpdate;
    try
      ContainerChanged;
    finally
      EndUpdate(False);
    end;
  end;
end;

procedure TdxCustomLayoutItem.SetCustomization(Value: Boolean);
begin
  if FCustomization <> Value then
  begin
    FCustomization := Value;
    CustomizationChanged;
  end;
end;

procedure TdxCustomLayoutItem.SetDefaultCaption(const Value: string);
begin
  CaptionOptions.DefaultCaption := Value;
end;

procedure TdxCustomLayoutItem.SetEnabled(Value: Boolean);
begin
  if Enabled <> Value then
  begin
    FEnabled := Value;
    EnabledChanged;
  end;
end;

procedure TdxCustomLayoutItem.SetLayoutLookAndFeel(Value: TdxCustomLayoutLookAndFeel);
begin
  if FLayoutLookAndFeel <> Value then
  begin
    if FLayoutLookAndFeel <> nil then
      FLayoutLookAndFeel.RemoveUser(Self);
    FLayoutLookAndFeel := Value;
    if FLayoutLookAndFeel <> nil then
      FLayoutLookAndFeel.AddUser(Self);
    LayoutLookAndFeelUserChanged;
  end;
end;

procedure TdxCustomLayoutItem.SetIndex(Value: Integer);
begin
  if FParent <> nil then
    FParent.ChangeItemIndex(Self, Value);
end;

procedure TdxCustomLayoutItem.SetIsUserDefined(Value: Boolean);
begin
  FIsUserDefined := Value;
  if IsRestoring and not CaptionOptions.IsCaptionAssigned then 
    CaptionOptions.ResetUserCaption(True);
end;

procedure TdxCustomLayoutItem.SetParent(Value: TdxCustomLayoutGroup);
begin
  if (FParent <> Value) and CanMoveTo(Value) then
  begin
    if Value = nil then
      FInternalCanQuickCustomized := CanQuickCustomized;
    if FIsFloat then
      StopFloat;

    if FParent <> nil then
    begin
      FParent.ResetRealAlign;
      Container.AddAvailableItem(Self);
      FParent.ExtractItem(Self);
    end;

    if Value <> nil then
    begin
      Value.ResetRealAlign;
      Value.AddItem(Self);
      Container.ExtractAvailableItem(Self);
    end;
    ResetEnabled;
    Changed;
  end;
end;

procedure TdxCustomLayoutItem.SetShowCaption(Value: Boolean);
begin
  CaptionOptions.Visible := Value;
end;

procedure TdxCustomLayoutItem.SetVisible(Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Changed;
  end;
end;

procedure TdxCustomLayoutItem.SetVisibleIndex(Value: Integer);
begin
  if FParent <> nil then
    FParent.ChangeItemVisibleIndex(Self, Value);
end;

procedure TdxCustomLayoutItem.SetSizeOptions(Value: TdxLayoutSizeOptions);
begin
  FSizeOptions.Assign(Value);
end;

procedure TdxCustomLayoutItem.SetTakeoffParent(Value: TdxCustomLayoutGroup);
begin
  if FTakeoffParent <> Value then
  begin
    cxRemoveFreeNotification(Self, FTakeoffParent);
    FTakeoffParent := Value;
    cxAddFreeNotification(Self, FTakeoffParent);
  end;
end;

function TdxCustomLayoutItem.GetHeight: Integer;
begin
  Result := SizeOptions.Height;
end;

function TdxCustomLayoutItem.GetWidth: Integer;
begin
  Result := SizeOptions.Width;
end;

procedure TdxCustomLayoutItem.SetHeight(Value: Integer);
begin
  SizeOptions.Height := Value;
end;

procedure TdxCustomLayoutItem.SetWidth(Value: Integer);
begin
  SizeOptions.Width := Value;
end;

procedure TdxCustomLayoutItem.ReadIndex(Reader: TReader);
begin
  FLoadedIndex := Reader.ReadInteger;
end;

procedure TdxCustomLayoutItem.WriteIndex(Writer: TWriter);
begin
  Writer.WriteInteger(Index);
end;

function TdxCustomLayoutItem.IsAlignHorzStored: Boolean;
begin
  Result := IsRoot or (AlignHorz <> ahParentManaged);
end;

function TdxCustomLayoutItem.IsAlignVertStored: Boolean;
begin
  Result := IsRoot or (AlignVert <> avParentManaged);
end;

function TdxCustomLayoutItem.IsClosedBySplitter: Boolean;
begin
  Result := GetNearestClosedSplitter <> nil;
end;

function TdxCustomLayoutItem.IsEnabledStored: Boolean;
begin
  Result := not FEnabled;
end;

procedure TdxCustomLayoutItem.DefineProperties(Filer: TFiler);

  function IsIndexStored: Boolean;
  begin
    Result := (Filer.Ancestor = nil) or (TdxCustomLayoutItem(Filer.Ancestor).Index <> Index);
  end;

begin
  inherited;
  Filer.DefineProperty('Index', ReadIndex, WriteIndex, IsIndexStored);
end;

procedure TdxCustomLayoutItem.Loaded;
begin
  inherited Loaded;
  FIsUserDefined := False;
  CheckAutoSize(True);
end;

procedure TdxCustomLayoutItem.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FTakeoffParent) then
    FTakeoffParent := nil;
  if (Operation = opRemove) and (AComponent = FParentBeforeDrag) then
    FParentBeforeDrag := nil;
end;

procedure TdxCustomLayoutItem.SetName(const Value: TComponentName);
begin
  inherited;
  if IsDesigning then
    DoItemChanged;
end;

procedure TdxCustomLayoutItem.SetOffsets(const Value: TdxLayoutOffsets);
begin
  FOffsets.Assign(Value);
end;

procedure TdxCustomLayoutItem.SetPadding(const Value: TdxLayoutPadding);
begin
  FPadding.Assign(Value);
end;

procedure TdxCustomLayoutItem.SetParentComponent(Value: TComponent);
var
  AIntf: IdxLayoutContainerOwner;
begin
  inherited;
  if Value is TdxCustomLayoutGroup then
    Parent := TdxCustomLayoutGroup(Value)
  else
    if Supports(Value, IdxLayoutContainerOwner, AIntf) then
      Container := AIntf.GetContainer;
end;

procedure TdxCustomLayoutItem.CustomizationChanged;
begin
// do nothing
end;

procedure TdxCustomLayoutItem.LayoutLookAndFeelChanged;
begin
// do nothing
end;

procedure TdxCustomLayoutItem.SetInitialSettings;
begin
// do nothing
end;

procedure TdxCustomLayoutItem.BeginLayoutLookAndFeelUserDestroying;
begin
  BeginUpdate;
end;

procedure TdxCustomLayoutItem.EndLayoutLookAndFeelUserDestroying;
begin
  EndUpdate;
end;

procedure TdxCustomLayoutItem.LayoutLookAndFeelUserChanged;
begin
  if IsDestroying or IsLoading then Exit;
  SetInitialSettings;
  Changed;
  LayoutLookAndFeelChanged;
end;

procedure TdxCustomLayoutItem.LayoutLookAndFeelUserDestroyed;
begin
  LayoutLookAndFeel := nil;
end;

function TdxCustomLayoutItem.CanAcceptItem(AItem: TdxCustomLayoutItem): Boolean;
begin
  Result := False;
end;

function TdxCustomLayoutItem.CanQuickDragAndDrop: Boolean;
begin
  Result := (Parent <> nil) and Parent.CanQuickCustomized or IsRoot and CanQuickCustomized or CanFloat;
end;

function TdxCustomLayoutItem.CanQuickCustomized: Boolean;
begin
  Result := not IsLocked and (AllowQuickCustomize or (Parent <> nil) and Parent.CanQuickCustomized or (Parent = nil) and FInternalCanQuickCustomized);
end;

function TdxCustomLayoutItem.CanFloat: Boolean;
begin
  Result := False;
end;

function TdxCustomLayoutItem.CanBeActuallyVisible: Boolean;
begin
  Result := (GetVisible or IsDesigning) and IsViewInfoValid and
    (IsRoot or (Parent <> nil) and Parent.AllowShowChild(Self) and Parent.CanBeActuallyVisible);
end;

function TdxCustomLayoutItem.CanBeAlone: Boolean;
begin
  Result := True;
end;

function TdxCustomLayoutItem.CanDragAndDrop(const P: TPoint): Boolean;
begin
  Result := not IsParentLocked and (not IsRoot or IsFloatingRoot);
end;

function TdxCustomLayoutItem.CanProcessAccel: Boolean;
begin
  Result := False;
end;

function TdxCustomLayoutItem.CanRemove: Boolean;
begin
  Result := FAllowRemove;
end;

function TdxCustomLayoutItem.CanResizeHorz: Boolean;
begin
  Result := not IsRoot and not IsParentLocked and SizeOptions.SizableHorz;
end;

function TdxCustomLayoutItem.CanResizeVert: Boolean;
begin
  Result := not IsRoot and not IsParentLocked and SizeOptions.SizableVert;
end;

procedure TdxCustomLayoutItem.AlignChanged;
begin
  if not IsLoading then
    CheckAutoSize(False);
  Changed;
end;

procedure TdxCustomLayoutItem.ContainerChanged;
begin
  Changed;
end;

procedure TdxCustomLayoutItem.DoCaptionDown;
begin
// do nothing
end;

procedure TdxCustomLayoutItem.DoCaptionClick;
begin
  CallNotify(FOnCaptionClick, Self);
end;

procedure TdxCustomLayoutItem.DoPack;
begin
// do nothing
end;

function TdxCustomLayoutItem.DoProcessAccel: Boolean;
begin
  Result := CanProcessAccel;
  if Result then
    ProcessAccel;
end;

procedure TdxCustomLayoutItem.InitiateAction;
begin
// do nothing
end;

function TdxCustomLayoutItem.InternalMove(AParent: TdxCustomLayoutGroup; AIndex: Integer; APack, AKeepAlign: Boolean): Boolean;
var
  ASourceContainer, ADestinationContainer: TdxLayoutContainer;
  ARealAlign: TdxLayoutRealAlign;
begin
  Result := CanMoveTo(AParent) and (APack or (AParent <> Parent) or (Index <> AIndex));
  if not Result then Exit;

  ASourceContainer := Container;
  if AParent = nil then
    ADestinationContainer := Container
  else
    ADestinationContainer := AParent.Container;
  ADestinationContainer.BeginUpdate;
  ASourceContainer.BeginUpdate;
  try
    ARealAlign := RealAlign;
    Parent := AParent;
    Index := AIndex;
    if AKeepAlign then
      RealAlign := ARealAlign;
  finally
    ASourceContainer.EndUpdate(APack);
    ADestinationContainer.EndUpdate(APack);
  end;
end;

procedure TdxCustomLayoutItem.CheckAutoSize(ADropOnly: Boolean);
begin
// do nothing
end;

procedure TdxCustomLayoutItem.StopFloat;
begin
  if not IsDestroying and IsGroup then
    FreeAndNil(AsGroup.ButtonOptions.FHomeButton);

  FIsFloat := False;
  HideFloat;
  RealContainer.FFloatContainers.Remove(Container);
  Container := RealContainer;
  if not FLockEvents then
    dxCallNotify(OnEndFloat, Self);
end;

procedure TdxCustomLayoutItem.LandingFloat;
begin
  if FTakeoffParent <> nil then
    Move(FTakeoffParent, Min(FTakeoffParent.Count,  FTakeoffIndex));
end;

procedure TdxCustomLayoutItem.MakeFloat(const APosition: TPoint; ANeedActivate: Boolean);
var
  ATakeoffParent: TdxCustomLayoutGroup;
  ATakeoffIndex: Integer;
begin
  if not IsRoot then
  begin
    if not IsDragged then 
    begin
      if Parent <> nil then
      begin
        ATakeoffParent := Parent;
        ATakeoffIndex := Index;
      end
      else
      begin
        ATakeoffParent := FParentBeforeDrag;
        ATakeoffIndex := FIndexBeforeDrag;
      end;
      if (ATakeoffParent <> nil) and (not ATakeoffParent.IsRoot or (RealContainer.Root = ATakeoffParent)) then
      begin
        TakeoffParent := ATakeoffParent;
        FTakeoffIndex := ATakeoffIndex;
      end;
      (Self as TdxCustomLayoutGroup).ButtonOptions.CreateHomeButton;
    end;

    if FFloatForm = nil then
      FFloatForm := RealContainer.CreateFloatForm;

    RealContainer.InitializeFloatForm(Self);
    FFloatPos := APosition;
    Parent := RealContainer.GetFloatDock(Self); 
    if not Container.IsContainerReady then
    begin
      Container.FCalculationDireNeeded := True;
      Container.LayoutChanged;
    end;

    FIsFloat := True;
    RealContainer.FFloatContainers.Add(Container);

    ShowFloat(ANeedActivate);
    if not FLockEvents then
      dxCallNotify(OnStartFloat, Self);
  end;
end;

procedure TdxCustomLayoutItem.MoveFloat(const APosition: TPoint);
begin
  FFloatPos := APosition;
  Parent := Container.GetFloatDock(Self);
  ShowFloat(False);
end;

procedure TdxCustomLayoutItem.ShowFloat(ANeedActivate: Boolean);
begin
  FFloatForm.ShowFloat(FFloatPos, ANeedActivate, IsDragged);
end;

procedure TdxCustomLayoutItem.HideFloat;
begin
  FFloatForm.FIsFloat := False;
  FFloatForm.Visible := False;
end;

procedure TdxCustomLayoutItem.EnabledChanged;
begin
  ResetEnabled;
  ParentChanged(ictSimple);
end;

procedure TdxCustomLayoutItem.CreateOptions;
begin
  FCaptionOptions := GetCaptionOptionsClass.Create(Self);
  FSizeOptions := TdxLayoutSizeOptions.Create(Self);
end;

procedure TdxCustomLayoutItem.DestroyOptions;
begin
  FreeAndNil(FSizeOptions);
  FreeAndNil(FCaptionOptions);
end;

function TdxCustomLayoutItem.GetNearestClosedSplitter: TdxLayoutSplitterItem;
var
  I: Integer;
begin
  Result := nil;
  if Parent = nil then
    Exit;
  case Parent.LayoutDirection of
    ldHorizontal:
      begin
        if (GetRealAlignHorz in [ahLeft, ahClient]) and (Index < Parent.Count - 1) then
          for I := Index + 1 to FParent.Count - 1 do
            if Parent.Items[I].Visible and (Parent.Items[I].GetRealAlignHorz in [ahLeft, ahClient]) then
            begin
              if (Parent.Items[I] is TdxLayoutSplitterItem) and TdxLayoutSplitterItem(Parent.Items[I]).IsClosed then
                Result := TdxLayoutSplitterItem(Parent.Items[I]);
              Break;
            end;
        if (Result = nil) and (GetRealAlignHorz in [ahRight, ahClient]) and (Index > 0) then
          for I := Index - 1 downto 0 do
            if Parent.Items[I].Visible and (Parent.Items[I].GetRealAlignHorz in [ahRight, ahClient]) then
            begin
              if (Parent.Items[I] is TdxLayoutSplitterItem) and TdxLayoutSplitterItem(Parent.Items[I]).IsClosed then
                Result := TdxLayoutSplitterItem(Parent.Items[I]);
              Break;
            end;
      end;
    ldVertical:
      begin
        if (GetRealAlignVert in [avTop, avClient]) and (Index < FParent.Count - 1) then
          for I := Index + 1 to Parent.Count - 1 do
            if Parent.Items[I].Visible and (Parent.Items[I].GetRealAlignVert in [avTop, avClient]) then
            begin
              if (Parent.Items[I] is TdxLayoutSplitterItem) and TdxLayoutSplitterItem(Parent.Items[I]).IsClosed then
                Result := TdxLayoutSplitterItem(Parent.Items[I]);
              Break;
            end;
        if (Result = nil) and (GetRealAlignVert in [avBottom, avClient]) and (Index > 0) then
          for I := Index - 1 downto 0 do
            if Parent.Items[I].Visible and (Parent.Items[I].GetRealAlignVert in [avBottom, avClient]) then
            begin
              if (Parent.Items[I] is TdxLayoutSplitterItem) and TdxLayoutSplitterItem(Parent.Items[I]).IsClosed then
                Result := TdxLayoutSplitterItem(Parent.Items[I]);
              Break;
            end;
      end;
  end;
end;

function TdxCustomLayoutItem.GetParentManagedAlignHorz: TdxLayoutAlignHorz;
begin
  if Parent <> nil then
    Result := Parent.GetChildItemsAlignHorz
  else
    Result := ahClient;
end;

function TdxCustomLayoutItem.GetParentManagedAlignVert: TdxLayoutAlignVert;
begin
  if Parent <> nil then
    Result := Parent.GetChildItemsAlignVert
  else
    Result := avClient;
end;

function TdxCustomLayoutItem.GetBaseName: string;
begin
  Result := Container.ItemsParentComponent.Name;
end;

function TdxCustomLayoutItem.GetCursor(X, Y: Integer): TCursor;
begin
  if IsViewInfoValid then
    Result := ViewInfo.GetCursor(X, Y)
  else
    Result := crDefault;
end;

function TdxCustomLayoutItem.IsLocked: Boolean;
begin
  Result := (Parent <> nil) and Parent.IsLocked;
end;

function TdxCustomLayoutItem.NeedDeleteAfterLoading: Boolean;
begin
  Result := Superfluous or ((LoadedIndex = dxLayoutInitialLoadedItemIndex) and CanDelete);
end;

procedure TdxCustomLayoutItem.OptimizeAlignForStoring;
begin
  if GetRealAlignHorz = GetParentManagedAlignHorz then
    AlignHorz := ahParentManaged;
  if GetRealAlignVert = GetParentManagedAlignVert then
    AlignVert := avParentManaged;
end;

function TdxCustomLayoutItem.IsParentLocked: Boolean;
begin
  Result := not IsDesigning and Container.IsCustomization and
    (Parent <> nil) and (Parent.Locked or Parent.IsParentLocked);
end;

function TdxCustomLayoutItem.IsRestoring: Boolean;
begin
  Result := (Container <> nil) and Container.IsRestoring;
end;

class function TdxCustomLayoutItem.GetItemClassKind: Integer;
begin
  Result := ickUnknown;
end;

function TdxCustomLayoutItem.GetLayoutLookAndFeel: TdxCustomLayoutLookAndFeel;
begin
  Result := FLayoutLookAndFeel;
  if Result = nil then
    if FParent <> nil then
      Result := FParent.GetChildLayoutLookAndFeel
    else
      Result := Container.GetLayoutLookAndFeel;
end;

function TdxCustomLayoutItem.GetParentHelperClass: TdxLayoutGroupHelperClass;
begin
  if Parent <> nil then
    Result := Parent.GetHelperClass
  else
    Result := TdxLayoutGroupHelper;
end;

procedure TdxCustomLayoutItem.LoadFromIni(AIniFile: TCustomIniFile; const ASection: string; AVersion: Integer);
var
  AReader: TdxLayoutBasicItemReaderClass;
begin
  case AVersion of
    3: AReader := TdxLayoutBasicItemReader3;
    2: AReader := TdxLayoutBasicItemReader2;
  else
    AReader := TdxLayoutBasicItemReader;
  end;

  AReader.LoadFromIni(Self, AIniFile, ASection);
end;

procedure TdxCustomLayoutItem.SaveToIni(AIniFile: TCustomIniFile; const ASection: string);
begin
  TdxLayoutBasicItemWriter.SaveToIni(Self, AIniFile, ASection);
end;

procedure TdxCustomLayoutItem.ChangeScale(M, D: Integer);
begin
  Offsets.ChangeScale(M, D);
  Padding.ChangeScale(M, D);
  CaptionOptions.ChangeScale(M, D);
  SizeOptions.ChangeScale(M, D);
end;

function TdxCustomLayoutItem.FocusFirst(ACheckTabStop: Boolean): Boolean;
begin
  Result := False;
end;

procedure TdxCustomLayoutItem.DoItemChanged;
begin
  Container.DoItemChanged(Self);
end;

function TdxCustomLayoutItem.GetShowCaption: Boolean;
begin
  Result := CaptionOptions.Visible;
end;

function TdxCustomLayoutItem.GetVisible: Boolean;
begin
  Result := (FVisible and not IsClosedBySplitter or IsDesigning or IsDragged) and ((Parent = nil) or Parent.AllowShowChild(Self))
end;

function TdxCustomLayoutItem.GetOptions: TdxCustomLayoutLookAndFeelOptions;
begin
  Result := GetLayoutLookAndFeel.ItemOptions
end;

function TdxCustomLayoutItem.HasControl: Boolean;
begin
  Result := False;
end;

procedure TdxCustomLayoutItem.BeforeCalculateViewInfo;
begin
// do nothing
end;

procedure TdxCustomLayoutItem.AfterCalculateViewInfo;
begin
// do nothing
end;

procedure TdxCustomLayoutItem.ApplyCalculatedChanges;
begin
// do nothing
end;

procedure TdxCustomLayoutItem.ResetRealAlign;
begin
  FRealAlign.Horz := ahParentManaged;
  FRealAlign.Vert := avParentManaged;
end;

procedure TdxCustomLayoutItem.ResetEnabled;
begin
  FRealEnabled := bDefault;
end;

procedure TdxCustomLayoutItem.AfterRestoring;
begin
  CaptionOptions.RecoverUserCaption;
  ApplyLoadedPosition;
end;

procedure TdxCustomLayoutItem.BeforeRestoring;
begin
  FSuperfluous := False;
  CaptionOptions.ResetUserCaption(False); 
  SetLoadedInfo('',  dxLayoutInitialLoadedItemIndex);
  Parent := nil;
end;

procedure TdxCustomLayoutItem.CheckIndex;
begin
// do nothing
end;

procedure TdxCustomLayoutItem.PopulateItems(AList: TList);
begin
  AList.Add(Self);
end;

procedure TdxCustomLayoutItem.SetLoadedInfo(const AParentName: string; AIndex: Integer);
begin
  FLoadedParentName := AParentName;
  FLoadedIndex := AIndex;
end;

function TdxCustomLayoutItem.AsGroup: TdxCustomLayoutGroup;
begin
  Result := TdxCustomLayoutGroup(Self);
end;

function TdxCustomLayoutItem.IsWrapItemsAllowed: Boolean;
begin
  Result := False;
end;

function TdxCustomLayoutItem.IsGroup: Boolean;
begin
  Result := False;
end;

function TdxCustomLayoutItem.IsFloatingRoot: Boolean;
begin
  Result := False;
end;

function TdxCustomLayoutItem.IsParentGroup(AParentGroup: TdxCustomLayoutGroup): Boolean;
begin
  Result := AParentGroup.IsChildItem(Self);
end;

function TdxCustomLayoutItem.IsChildItem(AChildItem: TdxCustomLayoutItem): Boolean;
begin
  while (AChildItem <> nil) and (AChildItem <> Self) do
    AChildItem := AChildItem.Parent;
  Result := AChildItem = Self;
end;

function TdxCustomLayoutItem.HasCaption: Boolean;
begin
  Result := ShowCaption and (IsTextVisible or IsImageVisible);
end;

function TdxCustomLayoutItem.IsHorzLocalPositionStable: Boolean;
begin
  Result :=
    (Parent.LayoutDirection in [ldVertical, ldTabbed]) or
    (VisibleIndex < 1) or
    (Parent.VisibleItems[VisibleIndex-1].GetRealAlignHorz in [ahLeft, ahRight]) and Parent.VisibleItems[VisibleIndex-1].IsHorzPositionStable;
end;

function TdxCustomLayoutItem.IsVertLocalPositionStable: Boolean;
begin
  Result :=
    (Parent.LayoutDirection in [ldHorizontal, ldTabbed]) or
    (VisibleIndex < 1) or
    (Parent.VisibleItems[VisibleIndex-1].GetRealAlignVert in [avTop, avBottom]) and Parent.VisibleItems[VisibleIndex-1].IsVertPositionStable;
end;

function TdxCustomLayoutItem.IsHorzPositionStable: Boolean;
begin
  Result := IsRoot or IsHorzLocalPositionStable and (Parent.IsHorzPositionStable or (Parent.ViewInfo.GetRealItemControlAreaAlignment = catOwn));
end;

function TdxCustomLayoutItem.IsVertPositionStable: Boolean;
begin
  Result := IsRoot or IsVertLocalPositionStable and (Parent.IsVertPositionStable or (Parent.ViewInfo.GetRealItemControlAreaAlignment = catOwn));
end;

procedure TdxCustomLayoutItem.DoGetTabOrderList(List: TList);
begin
// do nothing
end;

procedure TdxCustomLayoutItem.GetTabOrderList(List: TList);
begin
  if ActuallyVisible then
    DoGetTabOrderList(List);
end;

function TdxCustomLayoutItem.GetInplaceRenameCaption: string;
begin
  Result := Caption;
end;

procedure TdxCustomLayoutItem.SetInplaceRenameCaption(const ACaption: string);
begin
  if Caption <> ACaption then
  begin
    Container.SaveToUndo;
    Rename(ACaption);
  end;
end;

procedure TdxCustomLayoutItem.Rename(const ACaption: string);
begin
  CaptionOptions.UserCaption := ACaption;
end;

function TdxCustomLayoutItem.CanInit: Boolean;
begin
  Result := not (IsLoading or IsRestoring);
end;

procedure TdxCustomLayoutItem.DoInit;
begin
  SetInitialSettings;
end;

procedure TdxCustomLayoutItem.Init;
begin
  if CanInit then
    DoInit;
end;

procedure TdxCustomLayoutItem.KeyDown(var Key: Word; Shift: TShiftState);
begin
  ViewInfo.KeyDown(Key, Shift);
end;

procedure TdxCustomLayoutItem.ProcessAccel;
begin
end;

function TdxCustomLayoutItem.ProcessDialogChar(ACharCode: Word): Boolean;
begin
  Result := HasCaption and FCaptionOptions.ShowAccelChar and IsAccel(ACharCode, Caption) and DoProcessAccel;
end;

function TdxCustomLayoutItem.ProcessDialogKey(ACharCode: Word; AKeyData: Integer; AFocusedItem: TdxCustomLayoutItem): Boolean;
begin
  Result := False;
end;

procedure TdxCustomLayoutItem.RestoreItemControlBounds;
begin
// do nothing
end;

class function TdxCustomLayoutItem.GetCaptionOptionsClass: TdxCustomLayoutItemCaptionOptionsClass;
begin
  Result := TdxCustomLayoutItemCaptionOptions;
end;

//IdxLayoutSelectableItem
function TdxCustomLayoutItem.CanDelete: Boolean;
begin
  Result := (IsDesigning and not (csAncestor in ComponentState)) or IsUserDefined;
end;

function TdxCustomLayoutItem.IsOwner(AOwner: TComponent): Boolean;
begin
  Result := AOwner = Container;
end;

procedure TdxCustomLayoutItem.SelectComponent(AShift: TShiftState = []);
begin
  Container.SelectComponent(Self, AShift);
end;

procedure TdxCustomLayoutItem.SelectParent;
begin
  Container.SelectComponent(GetParentComponent);
end;

procedure TdxCustomLayoutItem.SelectionChanged;
begin
// do nothing
end;

function TdxCustomLayoutItem.IsSelectableItemVisible: Boolean;
begin
  Result := ActuallyVisible;
end;

procedure TdxCustomLayoutItem.SelectableItemMakeVisible;
var
  AViewInfo: TdxCustomLayoutItemViewInfo;
begin
  AViewInfo := ViewInfo;
  if AViewInfo <> nil then
    AViewInfo.MakeVisible(AViewInfo.Bounds, False);
end;

function TdxCustomLayoutItem.GetSelectionBounds: TRect;
var
  AViewInfo: TdxCustomLayoutItemViewInfo;
begin
  AViewInfo := ViewInfo;
  if AViewInfo <> nil then
    Result := cxRectInflate(AViewInfo.SelectionBorderRect, (dxLayoutSelectionMarkerWidth - 1) div 2, (dxLayoutSelectionMarkerWidth - 1) div 2)
  else
    Result := cxNullRect;
end;

function TdxCustomLayoutItem.GetStoredObjectName: string;
begin
  Result := Name;
end;

function TdxCustomLayoutItem.GetStoredProperties(AProperties: TStrings): Boolean;
begin
  Result := True;
  AProperties.Add('IsUserDefined');
  AProperties.Add('ParentName');
  AProperties.Add('Index');
  AProperties.Add('AlignHorz');
  AProperties.Add('AlignVert');
  AProperties.Add('Width');
  AProperties.Add('Height');
  AProperties.Add('IsFloat');
  if FIsFloat then
  begin
    AProperties.Add('FloatPosX');
    AProperties.Add('FloatPosY');
    AProperties.Add('TakeoffParent');
    AProperties.Add('TakeoffIndex');
  end;
  CaptionOptions.GetStoredProperties(AProperties);
  Container.GetItemStoredProperties(Self, AProperties);
end;

procedure TdxCustomLayoutItem.GetStoredPropertyValue(const AName: string; var AValue: Variant);

  function GetParentName(AParent: TdxCustomLayoutGroup): string;
  begin
    if AParent <> nil then
      Result := AParent.Name
    else
      Result := '';
  end;

begin
  case GetPropertyIndex(AName) of
    0 {IsUserDefined}: AValue := IsUserDefined;
    1 {ParentName}: AValue := GetParentName(Parent);
    2 {Index}: AValue := Index;
    3 {AlignHorz}: AValue := Variant(AlignHorz);
    4 {AlignVert}: AValue := Variant(AlignVert);
    5 {Width}: AValue := Width;
    6 {Height}: AValue := Height;
    7 {IsFloat}: AValue := FIsFloat;
    8 {FloatPosX}: AValue := FFloatPos.X;
    9 {FloatPosY}: AValue := FFloatPos.Y;
    10 {TakeoffParent}: AValue := GetParentName(TakeoffParent);
    11 {TakeoffIndex}: AValue := FTakeoffIndex;
  else
    CaptionOptions.GetStoredPropertyValue(AName, AValue);
 end;
end;

procedure TdxCustomLayoutItem.SetStoredPropertyValue(const AName: string; const AValue: Variant);
begin
  case GetPropertyIndex(AName) of
    0 {IsUserDefined}:
      begin
        IsUserDefined := AValue;
        FSuperfluous := FSuperfluous and not FIsUserDefined;
      end;
    1 {ParentName}: FLoadedParentName := AValue;
    2 {Index}: FLoadedIndex := AValue;
    3 {AlignHorz}: AlignHorz := AValue;
    4 {AlignVert}: AlignVert := AValue;
    5 {Width}: Width := AValue;
    6 {Height}: Height := AValue;
    7 {IsFloat}: FLoadedFloat := AValue;
    8 {FloatPosX}: FFloatPos.X := AValue;
    9 {FloatPosY}: FFloatPos.Y := AValue;
    10 {TakeoffParent}: FLoadedTakeoffParentName := AValue;
    11 {TakeoffIndex}: FTakeoffIndex := AValue;
  else
    CaptionOptions.SetStoredPropertyValue(AName, AValue);
  end;
end;

function TdxCustomLayoutItem.GetParentComponent: TComponent;
begin
  if FParent = nil then
    Result := Container.ItemsParentComponent
  else
    Result := FParent;
end;

function TdxCustomLayoutItem.HasParent: Boolean;
begin
  Result := True;
end;

procedure TdxCustomLayoutItem.BeginUpdate;
begin
  Container.BeginUpdate;
end;

procedure TdxCustomLayoutItem.BiDiModeChanged;
begin
  if FFloatForm <> nil then
    FFloatForm.BiDiMode := RealContainer.ItemsParentControl.BiDiMode;
end;

procedure TdxCustomLayoutItem.CancelUpdate;
begin
  Container.CancelUpdate;
end;

procedure TdxCustomLayoutItem.EndUpdate(ANeedPack: Boolean = True);
begin
  Container.EndUpdate(ANeedPack);
end;

procedure TdxCustomLayoutItem.Changed(AType: TdxLayoutItemChangeType);
begin
  if IsDestroying then
    Exit;
  if AType = ictHard then
    ResetRealAlign;
  if (Container <> nil) and Container.IsContainerReady then
    DoChanged(AType);
end;

procedure TdxCustomLayoutItem.DoChanged(AType: TdxLayoutItemChangeType);

  procedure ComplexLayoutChanged(AItem: TdxCustomLayoutItem);

    function GetPrevBounds(AItem: TdxCustomLayoutItem): TRects;
    var
      ALength: Integer;
    begin
      ALength := 0;
      while AItem <> nil do
      begin
        Inc(ALength);
        SetLength(Result, ALength);
        Result[ALength-1] := AItem.ViewInfo.Bounds;
        AItem := AItem.Parent;
      end;
    end;

    function GetMostChangedItem(AItem: TdxCustomLayoutItem; APrevBounds: TRects): TdxCustomLayoutItem;
    var
      I: Integer;
    begin
      I := 0;
      repeat
        Result := AItem;
        if cxRectIsEqual(APrevBounds[I], AItem.ViewInfo.Bounds) then
          Break;
        Inc(I);
        AItem := AItem.Parent;
      until AItem = nil;
    end;

  var
    APrevBounds: TRects;
    AMostChangedItem: TdxCustomLayoutItem;
  begin
    APrevBounds := nil;
    if AItem.IsViewInfoValid then
    begin
      APrevBounds := GetPrevBounds(AItem);
      BeginUpdate;
      Container.BeginPlaceControls;
      try
        Container.DoCalculateRoot(False);
        Container.ApplyCalculatedChanges;
      finally
        Container.CancelPlaceControls;
        CancelUpdate;
      end;

      AMostChangedItem := GetMostChangedItem(AItem, APrevBounds);
      if AMostChangedItem.IsRoot then
        Container.LayoutChanged(False)
      else
      begin
        Container.PlaceControls(AMostChangedItem.ViewInfo);
        Container.Redraw(AMostChangedItem.ViewInfo.Bounds, RDW_ALLCHILDREN or RDW_INVALIDATE); 
//        Container.InvalidateRect(AMostChangedItem.ViewInfo.Bounds, False); //# dxBehaviorTest109 not passed when call InvalidateRect
        Container.PostBuildSelectionLayer;
      end;
    end;
  end;

  procedure SimpleLayoutChanged(AItem: TdxCustomLayoutItem);
  var
    AViewInfo: TdxCustomLayoutItemViewInfo;
  begin
    if AItem.IsViewInfoValid then
    begin
      AViewInfo := AItem.ViewInfo;
      AItem.BeginUpdate;
      try
        AItem.BeforeCalculateViewInfo;
        AViewInfo.Recalculate;
        AItem.AfterCalculateViewInfo;
      finally
        AItem.CancelUpdate;
      end;
      Container.ViewInfo.DoCalculateInternalTabOrders; 
      AItem.ApplyCalculatedChanges;
      Container.InvalidateRect(AViewInfo.OriginalBounds, False);
      Container.PostBuildSelectionLayer;
    end;
  end;

  procedure MediumLayoutChanged(AItem: TdxCustomLayoutItem);
  var
    AViewInfo: TdxCustomLayoutItemViewInfo;
  begin
    if AItem.IsViewInfoValid then
    begin
      AViewInfo := AItem.ViewInfo;
      AItem.BeginUpdate;
      try
        AItem.BeforeCalculateViewInfo;
        AViewInfo.Recalculate;
        AItem.AfterCalculateViewInfo;
      finally
        AItem.CancelUpdate;
      end;
      Container.ViewInfo.DoCalculateInternalTabOrders;
      Container.PlaceControls(AViewInfo);
      AItem.ApplyCalculatedChanges; 
      Container.InvalidateRect(AViewInfo.OriginalBounds, False);
      Container.PostBuildSelectionLayer;
      Container.Update; 
    end;
  end;

  procedure LightLayoutChanged(AItem: TdxCustomLayoutItem);
  begin
    if AItem.IsViewInfoValid then
      Container.InvalidateRect(AItem.ViewInfo.Bounds, False);
  end;

begin
  case AType of
    ictHard:
      Container.LayoutChanged(False);
    ictMedium:
      MediumLayoutChanged(Self);
    ictLight:
      LightLayoutChanged(Self);
    ictComplex:
      ComplexLayoutChanged(Self);
    ictSimple:
      SimpleLayoutChanged(Self);
  end;
  DoItemChanged;
end;

procedure TdxCustomLayoutItem.ParentChanged(AType: TdxLayoutItemChangeType);
begin
  if Parent <> nil then
    Parent.Changed(AType)
  else
    Changed(AType);
end;

function TdxCustomLayoutItem.CanFocus(AByMouse: Boolean): Boolean;
begin
  Result := False;
end;

function TdxCustomLayoutItem.IsFocused: Boolean;
begin
  Result := Container.FocusController.IsFocused(Self);
end;

function TdxCustomLayoutItem.NeedMakeVisibleAfterFocusing: Boolean;
begin
  Result := IsViewInfoValid and not cxRectIntersect(Container.ViewInfo.ClientBounds, ViewInfo.Bounds);
end;

function TdxCustomLayoutItem.CanMoveTo(AParent: TdxCustomLayoutItem): Boolean;
begin
  Result := (AParent <> Self) and ((AParent = nil) or AParent.CanAcceptItem(Self));
end;

procedure TdxCustomLayoutItem.MakeVisible;
var
  AViewInfo: TdxCustomLayoutItemViewInfo;
begin
  AViewInfo := ViewInfo;
  if AViewInfo <> nil then
    AViewInfo.MakeVisible(AViewInfo.Bounds, True);
end;

function TdxCustomLayoutItem.Move(AParent: TdxCustomLayoutGroup; AIndex: Integer; APack: Boolean = False): Boolean;
begin
  Result := InternalMove(AParent, AIndex, APack, False);
end;

function TdxCustomLayoutItem.MoveTo(AParent: TdxCustomLayoutGroup; AVisibleIndex: Integer;
  APack: Boolean = False): Boolean;
var
  AIndex: Integer;
begin
  if AParent = nil then
    AIndex := -1
  else
    AIndex := AParent.GetItemIndex(AVisibleIndex);
  Result := Move(AParent, AIndex, APack);
end;

procedure TdxCustomLayoutItem.Pack;
var
  AContainer: TdxLayoutContainer;
begin
  AContainer := Container;
  AContainer.BeginUpdate;
  try
    DoPack;
  finally
    AContainer.EndUpdate(False);
  end;
end;

function TdxCustomLayoutItem.PutIntoHiddenGroup(ALayoutDirection: TdxLayoutDirection): TdxLayoutAutoCreatedGroup;
var
  AIndex: Integer;
begin
  if FParent = nil then
    Result := nil
  else
  begin
    AIndex := Index;
    Result := Container.GetAutoCreatedGroup;
    Result.Parent := Parent;
    Result.LayoutDirection := ALayoutDirection;
    case ALayoutDirection of
      ldHorizontal: Result.AlignVert := AlignVert;
      ldVertical: Result.AlignHorz := AlignHorz;
    end;
    Result.Index := AIndex;

    InternalMove(Result, 0, False, True);
  end;
end;

procedure TdxCustomLayoutItem.ToggleHotTrackState;
begin
  Container.ToggleHotTrackState(Self);
end;

{ TdxLayoutBasicItem }

function TdxLayoutBasicItem.GetViewInfoClass: TdxCustomLayoutItemViewInfoClass;
begin
  Result := TdxLayoutBasicItemViewInfo;
end;

// Auxiliary Items

{ TdxLayoutAuxiliaryItem }

function TdxLayoutNonLabeledItem.GetCaptionOptions: TdxLayoutNonLabeledItemCaptionOptions;
begin
  Result := TdxLayoutNonLabeledItemCaptionOptions(inherited CaptionOptions);
end;

class function TdxLayoutNonLabeledItem.GetCaptionOptionsClass: TdxCustomLayoutItemCaptionOptionsClass;
begin
  Result := TdxLayoutNonLabeledItemCaptionOptions;
end;

procedure TdxLayoutNonLabeledItem.SetCaptionOptions(Value: TdxLayoutNonLabeledItemCaptionOptions);
begin
  inherited CaptionOptions := Value;
end;

{ TdxLayoutEmptySpaceItem }

function TdxLayoutEmptySpaceItem.GetBaseName: string;
begin
  Result := inherited GetBaseName + 'SpaceItem';
end;

class function TdxLayoutEmptySpaceItem.GetItemClassKind: Integer;
begin
  Result := ickEmptySpace;
end;

function TdxLayoutEmptySpaceItem.GetViewInfoClass: TdxCustomLayoutItemViewInfoClass;
begin
  Result := TdxLayoutEmptySpaceItemViewInfo;
end;

function TdxLayoutEmptySpaceItem.CanBeAlone: Boolean;
begin
  Result := False;
end;

{ TdxLayoutNonResizeItem }

constructor TdxLayoutDirectionalItem.Create(AOwner: TComponent);
begin
  inherited;
  SizeOptions.FAssignedValues := [sovSizableHorz, sovSizableVert];
end;

function TdxLayoutDirectionalItem.GetViewInfoClass: TdxCustomLayoutItemViewInfoClass;
begin
  Result := TdxLayoutDirectionalItemViewInfo;
end;

function TdxLayoutDirectionalItem.CanBeAlone: Boolean;
begin
  Result := False;
end;

{ TdxLayoutSeparatorItemCaptionOptions }

constructor TdxLayoutSeparatorItemCaptionOptions.Create(AItem: TdxCustomLayoutItem);
begin
  inherited Create(AItem);
  FVisible := False;
  FAlignVert := tavBottom;
end;

{ TdxLayoutSeparatorItem }

function TdxLayoutSeparatorItem.GetBaseName: string;
begin
  Result := inherited GetBaseName + 'SeparatorItem';
end;

class function TdxLayoutSeparatorItem.GetCaptionOptionsClass: TdxCustomLayoutItemCaptionOptionsClass;
begin
  Result := TdxLayoutSeparatorItemCaptionOptions;
end;

class function TdxLayoutSeparatorItem.GetItemClassKind: Integer;
begin
  Result := ickSeparator;
end;

function TdxLayoutSeparatorItem.GetParentManagedAlignVert: TdxLayoutAlignVert;
begin
  Result := GetParentHelperClass.GetChildItemsAlignVert;
end;

function TdxLayoutSeparatorItem.GetViewInfoClass: TdxCustomLayoutItemViewInfoClass;
begin
  Result := TdxLayoutSeparatorItemViewInfo;
end;

function TdxLayoutSeparatorItem.GetCaptionOptions: TdxLayoutSeparatorItemCaptionOptions;
begin
  Result := TdxLayoutSeparatorItemCaptionOptions(inherited CaptionOptions);
end;

function TdxLayoutSeparatorItem.GetIsVertical: Boolean;
begin
  if IsViewInfoValid and not cxRectIsEmpty(ViewInfo.Bounds) then
    Result := ViewInfo.ContentBounds.Width < ViewInfo.ContentBounds.Height
  else
    Result := inherited;
end;

procedure TdxLayoutSeparatorItem.SetCaptionOptions(Value: TdxLayoutSeparatorItemCaptionOptions);
begin
  inherited CaptionOptions := Value;
end;

{ TdxLayoutSplitterItem }

function TdxLayoutSplitterItem.GetBaseName: string;
begin
  Result := inherited GetBaseName + 'SplitterItem';
end;

function TdxLayoutSplitterItem.GetStoredProperties(AProperties: TStrings): Boolean;
begin
  Result := inherited GetStoredProperties(AProperties);
  AProperties.Add('AllowCloseOnClick');
  AProperties.Add('IsClosed');
end;

procedure TdxLayoutSplitterItem.GetStoredPropertyValue(const AName: string; var AValue: Variant);
begin
  if AName = 'AllowCloseOnClick' then
    AValue := AllowCloseOnClick
  else
    if AName = 'IsClosed' then
      AValue := IsClosed
    else
      inherited;
end;

procedure TdxLayoutSplitterItem.SetStoredPropertyValue(const AName: string; const AValue: Variant);
begin
  if AName = 'AllowCloseOnClick' then
    AllowCloseOnClick := AValue
  else
    if AName = 'IsClosed' then
      IsClosed := AValue
    else
      inherited;
end;

function TdxLayoutSplitterItem.CanQuickDragAndDrop: Boolean;
begin
  Result := False;
end;

class function TdxLayoutSplitterItem.GetItemClassKind: Integer;
begin
  Result := ickSplitter;
end;

function TdxLayoutSplitterItem.GetViewInfoClass: TdxCustomLayoutItemViewInfoClass;
begin
  Result := TdxLayoutSplitterItemViewInfo;
end;

function TdxLayoutSplitterItem.DoCanResize(AItem: TdxCustomLayoutItem; var ANewSize: Integer): Boolean;
begin
  Result := True;
  if Assigned(FOnCanResize) then
    FOnCanResize(Self, AItem, ANewSize, Result);
end;

procedure TdxLayoutSplitterItem.Close;
begin
  if not FIsClosed then
  begin
    FIsClosed := True;
    Changed;
  end;
end;

procedure TdxLayoutSplitterItem.Open;
begin
  if FIsClosed then
  begin
    FIsClosed := False;
    Changed;
  end;
end;

procedure TdxLayoutSplitterItem.SetAllowCloseOnClick(AValue: Boolean);
begin
  if FAllowCloseOnClick <> AValue then
  begin
    FAllowCloseOnClick := AValue;
    BeginUpdate;
    try
      IsClosed := FIsClosed and FAllowCloseOnClick;
    finally
      CancelUpdate;
    end;
    Changed;
  end;
end;

procedure TdxLayoutSplitterItem.SetIsClosed(AValue: Boolean);
begin
  if AValue then
    Close
  else
    Open;
end;

{ TdxLayoutItemStorableCaptionOptions }

procedure TdxCustomLayoutItemStorableCaptionOptions.GetStoredPropertyValue(
  const AName: string; var AValue: Variant);
begin
  if AName = 'ShowCaption' then
    AValue := Visible
  else
    if AName = 'CaptionAlignHorz' then
      AValue := Variant(AlignHorz)
    else
      if AName = 'CaptionAlignVert' then
        AValue := Variant(AlignVert)
      else
        if AName = 'CaptionLayout' then
          AValue := Variant(Layout)
        else
          inherited;
end;

procedure TdxCustomLayoutItemStorableCaptionOptions.GetStoredProperties(AProperties: TStrings);
begin
  inherited GetStoredProperties(AProperties);
  AProperties.Add('ShowCaption');
  AProperties.Add('CaptionAlignHorz');
  AProperties.Add('CaptionAlignVert');
  AProperties.Add('CaptionLayout');
end;

procedure TdxCustomLayoutItemStorableCaptionOptions.SetStoredPropertyValue(const AName: string; const AValue: Variant);
begin
  if AName = 'ShowCaption' then
    Visible := AValue
  else
    if AName = 'CaptionAlignHorz' then
      AlignHorz := TAlignment(AValue)
    else
      if AName = 'CaptionAlignVert' then
        AlignVert := TdxAlignmentVert(AValue)
      else
        if AName = 'CaptionLayout' then
          Layout := TdxCaptionLayout(AValue)
        else
          inherited;
end;

{ TdxLayoutLabeledItemCustomCaptionOptions }

constructor TdxLayoutLabeledItemCustomCaptionOptions.Create(AItem: TdxCustomLayoutItem);
begin
  inherited Create(AItem);
  AlignVert := tavCenter;
  FCursor := crDefault;
  FWidth := 0;
end;

procedure TdxLayoutLabeledItemCustomCaptionOptions.DoAssign(Source: TPersistent);
begin
  inherited;
  if Source is TdxLayoutLabeledItemCustomCaptionOptions then
  begin
    Cursor := TdxLayoutLabeledItemCaptionOptions(Source).Cursor;
    Width := TdxLayoutLabeledItemCaptionOptions(Source).Width;
  end;
end;

procedure TdxLayoutLabeledItemCustomCaptionOptions.DoChangeScale(M, D: Integer);
begin
  inherited DoChangeScale(M, D);
  Width := MulDiv(Width, M, D);
end;

procedure TdxLayoutLabeledItemCustomCaptionOptions.SetWidth(Value: Integer);
begin
  Value := Max(0, Value);
  if FWidth <> Value then
  begin
    FWidth := Value;
    Changed;
  end;
end;

procedure TdxLayoutLabeledItemCustomCaptionOptions.SetWordWrap(Value: Boolean);
begin
  if FWordWrap <> Value then
  begin
    FWordWrap := Value;
    Changed;
  end;
end;

{ TdxCustomLayoutLabeledItem }

function TdxCustomLayoutLabeledItem.GetParentManagedAlignVert: TdxLayoutAlignVert;
begin
  Result := avTop;
end;

class function TdxCustomLayoutLabeledItem.GetCaptionOptionsClass: TdxCustomLayoutItemCaptionOptionsClass;
begin
  Result := TdxLayoutLabeledItemCustomCaptionOptions;
end;

function TdxCustomLayoutLabeledItem.GetViewInfoClass: TdxCustomLayoutItemViewInfoClass;
begin
  Result := TdxLayoutLabeledItemViewInfo;
end;

function TdxCustomLayoutLabeledItem.GetCaptionOptions: TdxLayoutLabeledItemCustomCaptionOptions;
begin
  Result := TdxLayoutLabeledItemCustomCaptionOptions(inherited CaptionOptions);
end;

procedure TdxCustomLayoutLabeledItem.SetCaptionOptions(Value: TdxLayoutLabeledItemCustomCaptionOptions);
begin
  inherited CaptionOptions := Value;
end;

{ TdxLayoutLabeledItem }

function TdxLayoutLabeledItem.GetBaseName: string;
begin
  Result := inherited GetBaseName + 'LabeledItem';
end;

function TdxLayoutLabeledItem.GetCaptionOptions: TdxLayoutLabeledItemCaptionOptions;
begin
  Result := TdxLayoutLabeledItemCaptionOptions(inherited CaptionOptions);
end;

class function TdxLayoutLabeledItem.GetCaptionOptionsClass: TdxCustomLayoutItemCaptionOptionsClass;
begin
  Result := TdxLayoutLabeledItemCaptionOptions;
end;

class function TdxLayoutLabeledItem.GetItemClassKind: Integer;
begin
  Result := ickLabeled;
end;

procedure TdxLayoutLabeledItem.SetCaptionOptions(Value: TdxLayoutLabeledItemCaptionOptions);
begin
  inherited CaptionOptions := Value;
end;

{ TdxLayoutImageItem }

constructor TdxLayoutImageItem.Create(AOwner: TComponent);
begin
  inherited;
  FImage := TdxSmartGlyph.Create;
  FImage.OnChange := ImageChanged;
  FImageFitMode := ifmFit;
end;

destructor TdxLayoutImageItem.Destroy;
begin
  FreeAndNil(FImage);
  inherited;
end;

procedure TdxLayoutImageItem.Assign(Source: TPersistent);
begin
  if Source is TdxLayoutImageItem then
    Image := TdxLayoutImageItem(Source).Image;
  inherited;
end;

function TdxLayoutImageItem.GetBaseName: string;
begin
  Result := inherited GetBaseName + 'ImageItem';
end;

class function TdxLayoutImageItem.GetCaptionOptionsClass: TdxCustomLayoutItemCaptionOptionsClass;
begin
  Result := TdxLayoutItemCaptionOptions;
end;

class function TdxLayoutImageItem.GetItemClassKind: Integer;
begin
  Result := ickImage;
end;

function TdxLayoutImageItem.GetViewInfoClass: TdxCustomLayoutItemViewInfoClass;
begin
  Result := TdxLayoutImageItemViewInfo;
end;

function TdxLayoutImageItem.GetCaptionOptions: TdxLayoutItemCaptionOptions;
begin
  Result := TdxLayoutItemCaptionOptions(inherited CaptionOptions);
end;

procedure TdxLayoutImageItem.SetCaptionOptions(Value: TdxLayoutItemCaptionOptions);
begin
  inherited CaptionOptions := Value;
end;

procedure TdxLayoutImageItem.SetImage(AValue: TdxSmartGlyph);
begin
  FImage.Assign(AValue);
end;

procedure TdxLayoutImageItem.SetImageFitMode(AValue: TcxImageFitMode);
begin
  if FImageFitMode <> AValue then
  begin
    FImageFitMode := AValue;
    Changed(ictLight);
  end;
end;

procedure TdxLayoutImageItem.ImageChanged(Sender: TObject);
begin
  Changed(ictComplex);
end;

{ TdxCustomLayoutCheckableItemCaptionOptions }

constructor TdxCustomLayoutCheckableItemCaptionOptions.Create(AItem: TdxCustomLayoutItem);
begin
  inherited Create(AItem);
  Layout := clRight;
end;

function TdxCustomLayoutCheckableItemCaptionOptions.IsHintStored: Boolean;
begin
  Result := (Item.ActionLink = nil) or not Item.ActionLink.IsHintLinked;
end;

function TdxCustomLayoutCheckableItemCaptionOptions.IsTextStored: Boolean;
begin
  Result := inherited IsTextStored and ((Item.ActionLink = nil) or not Item.ActionLink.IsCaptionLinked);
end;

function TdxCustomLayoutCheckableItemCaptionOptions.GetItem: TdxCustomLayoutCheckableItem;
begin
  Result := inherited Item as TdxCustomLayoutCheckableItem;
end;

{ TdxLayoutCheckBoxItemCheckBoxOptions }

constructor TdxLayoutCheckBoxItemCheckBoxOptions.Create(AItem: TdxCustomLayoutItem);
begin
  inherited Create(AItem);
  FAllowGrayed := False;
  FGlyph := TdxSmartGlyph.Create;
  TdxSmartGlyphAccess(FGlyph).FTransparent := False;
  FGlyph.OnChange := GlyphChangeHandler;
  FGlyphCount := 6;
  FReadOnly := False;
end;

destructor TdxLayoutCheckBoxItemCheckBoxOptions.Destroy;
begin
  FreeAndNil(FGlyph);
  inherited Destroy;
end;

procedure TdxLayoutCheckBoxItemCheckBoxOptions.DoAssign(Source: TPersistent);
begin
  inherited DoAssign(Source);
  if Source is TdxLayoutCheckBoxItemCheckBoxOptions then
  begin
    AllowGrayed := TdxLayoutCheckBoxItemCheckBoxOptions(Source).AllowGrayed;
    Glyph := TdxLayoutCheckBoxItemCheckBoxOptions(Source).Glyph;
    GlyphCount := TdxLayoutCheckBoxItemCheckBoxOptions(Source).GlyphCount;
    ReadOnly := TdxLayoutCheckBoxItemCheckBoxOptions(Source).ReadOnly;
  end;
end;

procedure TdxLayoutCheckBoxItemCheckBoxOptions.GlyphChangeHandler(Sender: TObject);
begin
  Changed;
end;

function TdxLayoutCheckBoxItemCheckBoxOptions.GetStateCaption(AIndex: Integer): string;
begin
  Result := GetCheckBoxStateCaptionByGlyphIndex(AIndex);
end;

function TdxLayoutCheckBoxItemCheckBoxOptions.GetGlyphCount: Integer;
begin
  Result := GlyphCount;
end;

function TdxLayoutCheckBoxItemCheckBoxOptions.GetItem: TdxLayoutCheckBoxItem;
begin
  Result := inherited Item as TdxLayoutCheckBoxItem;
end;

procedure TdxLayoutCheckBoxItemCheckBoxOptions.SetGlyph(AValue: TdxSmartGlyph);
begin
  FGlyph.Assign(AValue);
end;

procedure TdxLayoutCheckBoxItemCheckBoxOptions.SetGlyphCount(AValue: Integer);
begin
  if FGlyphCount <> AValue then
  begin
    FGlyphCount := AValue;
    if FGlyph <> nil then
      Changed;
  end;
end;

procedure TdxLayoutCheckBoxItemCheckBoxOptions.SetReadOnly(AValue: Boolean);
begin
  if FReadOnly <> AValue then
  begin
    FReadOnly := AValue;
    Item.Changed(ictMedium);
  end;
end;

{ TdxCustomLayoutCheckableItemActionLink }

procedure TdxCustomLayoutCheckableItemActionLink.AssignClient(AClient: TObject);
begin
  FClient := AClient as TdxCustomLayoutCheckableItem;
end;

function TdxCustomLayoutCheckableItemActionLink.IsCaptionLinked: Boolean;
begin
  Result := inherited IsCaptionLinked and (FClient.Caption = TCustomAction(Action).Caption);
end;

function TdxCustomLayoutCheckableItemActionLink.IsCheckedLinked: Boolean;
begin
  Result := inherited IsCaptionLinked and (FClient.Checked = TCustomAction(Action).Checked);
end;

function TdxCustomLayoutCheckableItemActionLink.IsEnabledLinked: Boolean;
begin
  Result := inherited IsEnabledLinked and (FClient.Enabled = TCustomAction(Action).Enabled);
end;

function TdxCustomLayoutCheckableItemActionLink.IsHintLinked: Boolean;
begin
  Result := inherited IsHintLinked and (FClient.CaptionOptions.Hint = TCustomAction(Action).Hint);
end;

function TdxCustomLayoutCheckableItemActionLink.IsOnExecuteLinked: Boolean;
begin
  Result := inherited IsOnExecuteLinked and (@FClient.OnClick = @Action.OnExecute);
end;

function TdxCustomLayoutCheckableItemActionLink.IsVisibleLinked: Boolean;
begin
  Result := inherited IsVisibleLinked and (FClient.Visible = TCustomAction(Action).Visible);
end;

procedure TdxCustomLayoutCheckableItemActionLink.SetCaption(const Value: string);
begin
  if IsCaptionLinked then
    FClient.Caption := Value;
end;

procedure TdxCustomLayoutCheckableItemActionLink.SetChecked(Value: Boolean);
begin
  if IsCheckedLinked then
    FClient.Checked := Value;
end;

procedure TdxCustomLayoutCheckableItemActionLink.SetEnabled(Value: Boolean);
begin
  if IsEnabledLinked then
    FClient.Enabled := Value;
end;

procedure TdxCustomLayoutCheckableItemActionLink.SetHint(const Value: string);
begin
  if IsHintLinked then
    FClient.CaptionOptions.Hint := Value;
end;

procedure TdxCustomLayoutCheckableItemActionLink.SetOnExecute(Value: TNotifyEvent);
begin
  if IsOnExecuteLinked then
    FClient.OnClick := Value;
end;

procedure TdxCustomLayoutCheckableItemActionLink.SetVisible(Value: Boolean);
begin
  if IsVisibleLinked then
    FClient.Visible := Value;
end;

{ TdxLayoutRadioButtonItemActionLink }

function TdxLayoutRadioButtonItemActionLink.IsGroupIndexLinked: Boolean;
begin
  Result := inherited IsGroupIndexLinked and (Client.GroupIndex = (Action as TCustomAction).GroupIndex);
end;

procedure TdxLayoutRadioButtonItemActionLink.SetGroupIndex(Value: Integer);
begin
  if IsGroupIndexLinked then
    Client.GroupIndex := Value;
end;

function TdxLayoutRadioButtonItemActionLink.GetClient: TdxLayoutRadioButtonItem;
begin
  Result := FClient as TdxLayoutRadioButtonItem;
end;

{ TdxCustomLayoutCheckableItem }

constructor TdxCustomLayoutCheckableItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ShowFocusRect := True;
end;

destructor TdxCustomLayoutCheckableItem.Destroy;
begin
  FreeAndNil(FActionLink);
  inherited Destroy;
end;

procedure TdxCustomLayoutCheckableItem.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
  if Source is TdxCustomLayoutCheckableItem then
    TabStop := TdxCustomLayoutCheckableItem(Source).TabStop;
end;

procedure TdxCustomLayoutCheckableItem.ActionChange(Sender: TObject; const ACheckDefaults: Boolean);
begin
  if Sender is TCustomAction then
  begin
    if not ACheckDefaults or (Caption = '') then
      Caption := TCustomAction(Sender).Caption;
    if not ACheckDefaults or not Checked then
    begin
      FIsClickLocked := True;
      try
        Checked := TCustomAction(Sender).Checked;
      finally
        FIsClickLocked := False;
      end;
    end;
    if not ACheckDefaults or Enabled then
      Enabled := TCustomAction(Sender).Enabled;
    if not ACheckDefaults or (CaptionOptions.Hint = '') then
      CaptionOptions.Hint := TCustomAction(Sender).Hint;
    if not ACheckDefaults or Visible then
      Visible := TCustomAction(Sender).Visible;
    if not ACheckDefaults or not Assigned(OnClick) then
      OnClick := TCustomAction(Sender).OnExecute;
  end;
end;

procedure TdxCustomLayoutCheckableItem.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = Action) then
    Action := nil;
end;

function TdxCustomLayoutCheckableItem.CanFocus(AByMouse: Boolean): Boolean;
begin
  Result := ActuallyVisible and Enabled and (AByMouse or TabStop);
end;

function TdxCustomLayoutCheckableItem.CanProcessAccel: Boolean;
begin
  Result := ActuallyVisible and Enabled;
end;

procedure TdxCustomLayoutCheckableItem.Click;
begin 
  if not FIsClickLocked then
  begin
    if Assigned(FOnClick) and (Action <> nil) and not DelegatesEqual(@FOnClick, @Action.OnExecute) then
      FOnClick(Self)
    else
      if not IsDesigning and (ActionLink <> nil) then
        ActionLink.Execute(Self)
      else
        if Assigned(FOnClick) then
          FOnClick(Self);
  end;
end;

procedure TdxCustomLayoutCheckableItem.DoGetTabOrderList(List: TList);
begin
  inherited DoGetTabOrderList(List);
  if CanFocus(False) then
    List.Add(Container.ItemsParentControl);
end;

procedure TdxCustomLayoutCheckableItem.InitiateAction;
begin
  inherited InitiateAction;
  if ActionLink <> nil then
    ActionLink.Update;
end;

class function TdxCustomLayoutCheckableItem.GetActionLinkClass: TdxCustomLayoutCheckableItemActionLinkClass;
begin
  Result := TdxCustomLayoutCheckableItemActionLink;
end;

function TdxCustomLayoutCheckableItem.GetTabStop: Boolean;
begin
  Result := FTabStop;
end;

function TdxCustomLayoutCheckableItem.IsEnabledStored: Boolean;
begin
  Result := (ActionLink = nil) and inherited IsEnabledStored or (ActionLink <> nil) and not ActionLink.IsEnabledLinked;
end;

function TdxCustomLayoutCheckableItem.NeedMakeVisibleAfterFocusing: Boolean;
begin
  Result := IsViewInfoValid;
end;

function TdxCustomLayoutCheckableItem.IsOnClickStored: Boolean;
begin
  Result := (ActionLink = nil) or not ActionLink.IsOnExecuteLinked;
end;

function TdxCustomLayoutCheckableItem.IsVisibleStored: Boolean;
begin
  Result := (ActionLink = nil) or not ActionLink.IsVisibleLinked;
end;

procedure TdxCustomLayoutCheckableItem.ProcessAccel;
begin
  if CanFocus(False) then
    Container.FocusController.SetItemFocus(Self);
  Toggle;
end;

procedure TdxCustomLayoutCheckableItem.SetTabStop(const AValue: Boolean);
begin
  if FTabStop <> AValue then
  begin
    FTabStop := AValue;
    Changed(ictMedium);
  end;
end;

procedure TdxCustomLayoutCheckableItem.Toggle;
begin
// do nothing
end;

procedure TdxCustomLayoutCheckableItem.DoActionChange(Sender: TObject);
begin
  if Sender = Action then
    ActionChange(Sender, False);
end;

function TdxCustomLayoutCheckableItem.GetAction: TBasicAction;
begin
  if ActionLink <> nil then
    Result := ActionLink.Action
  else
    Result := nil;
end;

procedure TdxCustomLayoutCheckableItem.SetAction(AValue: TBasicAction);
begin
  if Action <> AValue then
  begin
    if AValue = nil then
      FreeAndNil(FActionLink)
    else
    begin
      if ActionLink = nil then
        ActionLink := GetActionLinkClass.Create(Self);
      ActionLink.Action := AValue;
      ActionLink.OnChange := DoActionChange;
      ActionChange(AValue, csLoading in AValue.ComponentState);
      AValue.FreeNotification(Self);
    end;
  end;
end;

{ TdxLayoutCheckBoxItem }

constructor TdxLayoutCheckBoxItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FState := cbsUnchecked;
  TabStop := True;
end;

procedure TdxLayoutCheckBoxItem.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
  if Source is TdxLayoutCheckBoxItem then
  begin
    CheckBoxOptions := TdxLayoutCheckBoxItem(Source).CheckBoxOptions;
    State := TdxLayoutCheckBoxItem(Source).State;
  end;
end;

procedure TdxLayoutCheckBoxItem.CreateOptions;
begin
  inherited CreateOptions;
  FCheckBoxOptions := GetCheckBoxOptionsClass.Create(Self);
end;

procedure TdxLayoutCheckBoxItem.DestroyOptions;
begin
  FreeAndNil(FCheckBoxOptions);
  inherited DestroyOptions;
end;

procedure TdxLayoutCheckBoxItem.DoChanged(AType: TdxLayoutItemChangeType);
begin
  inherited DoChanged(AType);
  CallNotify(CheckBoxOptions.OnChange, Self);
end;

class function TdxLayoutCheckBoxItem.GetActionLinkClass: TdxCustomLayoutCheckableItemActionLinkClass;
begin
  Result := TdxLayoutCheckBoxItemActionLink;
end;

function TdxLayoutCheckBoxItem.GetBaseName: string;
begin
  Result := inherited GetBaseName + 'CheckBoxItem';
end;

class function TdxLayoutCheckBoxItem.GetCaptionOptionsClass: TdxCustomLayoutItemCaptionOptionsClass;
begin
  Result := TdxLayoutCheckBoxItemCaptionOptions;
end;

class function TdxLayoutCheckBoxItem.GetCheckBoxOptionsClass: TdxLayoutCheckBoxItemCheckBoxOptionsClass;
begin
  Result := TdxLayoutCheckBoxItemCheckBoxOptions;
end;

function TdxLayoutCheckBoxItem.GetChecked: Boolean;
begin
  Result := State = cbsChecked;
end;

class function TdxLayoutCheckBoxItem.GetItemClassKind: Integer;
begin
  Result := ickCheckBox;
end;

function TdxLayoutCheckBoxItem.GetViewInfoClass: TdxCustomLayoutItemViewInfoClass;
begin
  Result := TdxLayoutCheckBoxItemViewInfo;
end;

function TdxLayoutCheckBoxItem.IsStateStored: Boolean;
begin
  Result := (ActionLink = nil) or not ActionLink.IsCheckedLinked;
end;

procedure TdxLayoutCheckBoxItem.SetChecked(const AValue: Boolean);
begin
  if AValue then
    State := cbsChecked
  else
    State := cbsUnchecked;
end;

procedure TdxLayoutCheckBoxItem.Toggle;
begin
  if not CheckBoxOptions.ReadOnly then
    case State of
      cbsUnchecked:
        if CheckBoxOptions.AllowGrayed then
          State := cbsGrayed
        else
          State := cbsChecked;
      cbsChecked:
        State := cbsUnchecked;
      cbsGrayed:
        State := cbsChecked;
    end;
end;

function TdxLayoutCheckBoxItem.GetCaptionOptions: TdxLayoutCheckBoxItemCaptionOptions;
begin
  Result := TdxLayoutCheckBoxItemCaptionOptions(inherited CaptionOptions);
end;

procedure TdxLayoutCheckBoxItem.SetCaptionOptions(AValue: TdxLayoutCheckBoxItemCaptionOptions);
begin
  inherited CaptionOptions := AValue;
end;

procedure TdxLayoutCheckBoxItem.SetCheckBoxOptions(AValue: TdxLayoutCheckBoxItemCheckBoxOptions);
begin
  FCheckBoxOptions.Assign(AValue);
end;

procedure TdxLayoutCheckBoxItem.SetState(const AValue: TcxCheckBoxState);
begin
  if FState <> AValue then
  begin
    FState := AValue;
    Click;
    Changed(ictMedium);
  end;
end;

{ TdxLayoutRadioButtonItem }

constructor TdxLayoutRadioButtonItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FChecked := False;
  FGroupIndex := 0;
  TabStop := False;
end;

procedure TdxLayoutRadioButtonItem.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
  if Source is TdxLayoutRadioButtonItem then
  begin
    Checked := TdxLayoutRadioButtonItem(Source).Checked;
    GroupIndex := TdxLayoutRadioButtonItem(Source).GroupIndex;
  end;
end;

procedure TdxLayoutRadioButtonItem.ActionChange(Sender: TObject; const ACheckDefaults: Boolean);
begin
  inherited ActionChange(Sender, ACheckDefaults);
  if Sender is TCustomAction then
    if not ACheckDefaults or (GroupIndex = 0) then
      GroupIndex := TCustomAction(Sender).GroupIndex;
end;

class function TdxLayoutRadioButtonItem.GetActionLinkClass: TdxCustomLayoutCheckableItemActionLinkClass;
begin
  Result := TdxLayoutRadioButtonItemActionLink;
end;

function TdxLayoutRadioButtonItem.GetBaseName: string;
begin
  Result := inherited GetBaseName + 'RadioButtonItem';
end;

class function TdxLayoutRadioButtonItem.GetCaptionOptionsClass: TdxCustomLayoutItemCaptionOptionsClass;
begin
  Result := TdxLayoutRadioButtonItemCaptionOptions;
end;

function TdxLayoutRadioButtonItem.GetChecked: Boolean;
begin
  Result := FChecked;
end;

class function TdxLayoutRadioButtonItem.GetItemClassKind: Integer;
begin
  Result := ickRadioButton;
end;

function TdxLayoutRadioButtonItem.GetTabStop: Boolean;
begin 
  Result := inherited GetTabStop or Checked;
end;

function TdxLayoutRadioButtonItem.GetViewInfoClass: TdxCustomLayoutItemViewInfoClass;
begin
  Result := TdxLayoutRadioButtonItemViewInfo;
end;

function TdxLayoutRadioButtonItem.IsCheckedStored: Boolean;
begin
  Result := (ActionLink = nil) or not ActionLink.IsCheckedLinked;
end;

function TdxLayoutRadioButtonItem.IsGroupIndexStored: Boolean;
begin
  Result := (ActionLink = nil) or not ActionLink.IsGroupIndexLinked;
end;

procedure TdxLayoutRadioButtonItem.SetChecked(const AValue: Boolean);
begin
  if FChecked <> AValue then
  begin
    FChecked := AValue;
    if AValue then
    begin
      TurnLayoutSiblingsOff(Container.Root);
      Click;
    end;
    Changed(ictMedium);
  end;
end;

procedure TdxLayoutRadioButtonItem.Toggle;
begin
  if not Checked then
  begin
    Checked := True;
    Container.FocusController.SetItemFocus(Self); 
  end;
end;

function TdxLayoutRadioButtonItem.GetCaptionOptions: TdxLayoutRadioButtonItemCaptionOptions;
begin
  Result := TdxLayoutRadioButtonItemCaptionOptions(inherited CaptionOptions);
end;

procedure TdxLayoutRadioButtonItem.SetCaptionOptions(AValue: TdxLayoutRadioButtonItemCaptionOptions);
begin
  inherited CaptionOptions := AValue;
end;

procedure TdxLayoutRadioButtonItem.TurnLayoutSiblingsOff(AGroup: TdxCustomLayoutGroup);
var
  AAction: TCustomAction;
  ARadioButtonItem: TdxLayoutRadioButtonItem;
  I: Integer;
begin
  if AGroup <> nil then
    for I := 0 to AGroup.Count - 1 do
    begin
      if AGroup[I] is TdxLayoutRadioButtonItem then
      begin
        ARadioButtonItem := TdxLayoutRadioButtonItem(AGroup[I]);
        if (ARadioButtonItem <> Self) and (ARadioButtonItem.GroupIndex = GroupIndex) then
        begin
          if Assigned(ARadioButtonItem.Action) and (ARadioButtonItem.Action is TCustomAction) then
          begin
            AAction := TCustomAction(ARadioButtonItem.Action);
            if AAction.AutoCheck then
              AAction.Checked := False;
          end;
          ARadioButtonItem.Checked := False;
        end;
      end
      else
        if AGroup[I].IsGroup then
          TurnLayoutSiblingsOff(AGroup[I].AsGroup);
    end;
end;

{ TdxCustomLayoutElementViewInfo }

procedure TdxCustomLayoutElementViewInfo.Calculate(const ABounds: TRect);
begin
  FBounds := ABounds;
  FOriginalBounds := ABounds;
end;

function TdxCustomLayoutElementViewInfo.CalculatePadding: TRect;
begin
  Result := cxNullRect;
end;

function TdxCustomLayoutElementViewInfo.GetEnabled: Boolean;
begin
  Result := False;
end;

function TdxCustomLayoutElementViewInfo.GetIsCustomization: Boolean;
begin
  Result := False;
end;


function TdxCustomLayoutElementViewInfo.CanFocusOnClick(X, Y: Integer): Boolean;
begin
  Result := True;
end;

procedure TdxCustomLayoutElementViewInfo.MouseEnter;
begin
  if IsHotTrackable then
    State := State + [levsHot];
end;

procedure TdxCustomLayoutElementViewInfo.MouseLeave;
begin
  State := State - [levsHot, levsPressed];
end;

procedure TdxCustomLayoutElementViewInfo.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  State := State + [levsPressed];
end;

procedure TdxCustomLayoutElementViewInfo.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TdxCustomLayoutElementViewInfo.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  State := State - [levsPressed];
end;

procedure TdxCustomLayoutElementViewInfo.KeyDown(var Key: Word; Shift: TShiftState);
begin
// do nothing
end;

procedure TdxCustomLayoutElementViewInfo.AssignBounds(ASource: TdxCustomLayoutElementViewInfo);
begin
  if CanAssignBounds(ASource) then
    DoAssignBounds(ASource);
end;

function TdxCustomLayoutElementViewInfo.CanAssignBounds(ASource: TdxCustomLayoutElementViewInfo): Boolean;
begin
  Result := ASource is ClassType;
end;

procedure TdxCustomLayoutElementViewInfo.DoRightToLeftConversion(const AClientBounds: TRect);
begin
  FBounds := TdxRightToLeftLayoutConverter.ConvertRect(FBounds, AClientBounds);
  FOriginalBounds := TdxRightToLeftLayoutConverter.ConvertRect(FOriginalBounds, AClientBounds);
end;

procedure TdxCustomLayoutElementViewInfo.DoAssignBounds(ASource: TdxCustomLayoutElementViewInfo);
begin
  FBounds := ASource.Bounds;
  FOriginalBounds := ASource.FOriginalBounds;
  FOffset := ASource.Offset;
end;

procedure TdxCustomLayoutElementViewInfo.DoSetOffset(const AValue, ADiff: TPoint);
begin
  FOriginalBounds := cxRectOffset(FOriginalBounds, ADiff);
  FBounds := cxRectOffset(FBounds, ADiff);
end;

function TdxCustomLayoutElementViewInfo.GetLookAndFeel: TcxLookAndFeel;
begin
  Result := TdxCustomLayoutLookAndFeelAccess(LayoutLookAndFeel).LookAndFeel;
end;

function TdxCustomLayoutElementViewInfo.GetPadding: TRect;
begin
  if not FIsPaddingCalculated then
  begin
    FPadding := CalculatePadding;
    FIsPaddingCalculated := True;
  end;
  Result := FPadding;
end;

procedure TdxCustomLayoutElementViewInfo.SetOffset(const Value: TPoint);
var
  ADiff: TPoint;
begin
  if not cxPointIsEqual(Offset, Value) then
  begin
    ADiff := cxPointOffset(Value, Offset, False);
    FOffset := Value;
    if UseRightToLeftAlignment then
      ADiff.X := - ADiff.X;
    DoSetOffset(Value, ADiff);
  end;
end;

procedure TdxCustomLayoutElementViewInfo.StateChanged;
begin
end;

function TdxCustomLayoutElementViewInfo.IsHotTrackable: Boolean;
begin
  Result := False;
end;

procedure TdxCustomLayoutElementViewInfo.Reset;
begin
// do nothing
end;

procedure TdxCustomLayoutElementViewInfo.SetBounds(const ARect: TRect; AOriginal: Boolean);
begin
  FBounds := ARect;
  if AOriginal then
    FOriginalBounds := ARect;
end;

procedure TdxCustomLayoutElementViewInfo.SetState(AValue: TdxLayoutElementViewInfoStates);
begin
  if not Enabled or IsCustomization then
    AValue := [];
  if FState <> AValue then
  begin
    FState := AValue;
    StateChanged;
  end;
end;

{ TdxCustomLayoutItemElementViewInfo }

constructor TdxCustomLayoutItemElementViewInfo.Create(AItemViewInfo: TdxCustomLayoutItemViewInfo);
begin
  inherited Create;
  FItemViewInfo := AItemViewInfo;
  FOffset := FItemViewInfo.Offset;
  FIsOnGlass := FItemViewInfo.IsOnGlass;
end;

destructor TdxCustomLayoutItemElementViewInfo.Destroy;
begin
  if Self = ItemViewInfo.ElementWithMouse then
    ItemViewInfo.FElementWithMouse := nil;
  inherited;
end;

function TdxCustomLayoutItemElementViewInfo.CalculateMinHeight: Integer;
begin
  Result := 0;
end;

function TdxCustomLayoutItemElementViewInfo.CalculateMinWidth: Integer;
begin
  Result := 0;
end;

function TdxCustomLayoutItemElementViewInfo.CalculateHeight: Integer;
begin
  Result := 0;
end;

function TdxCustomLayoutItemElementViewInfo.CalculateWidth: Integer;
begin
  Result := 0;
end;

procedure TdxCustomLayoutItemElementViewInfo.CalculateExactBounds(const AAvailableBounds: TRect);
var
  ABounds: TRect;
begin
  if Visible then
  begin
    ABounds := AAvailableBounds;
    case LayoutAlignHorz of
      ahLeft:
        ABounds.Right := ABounds.Left + Width;
      ahCenter:
        begin
          ABounds.Left := ABounds.Left + (ABounds.Width - Width) div 2;
          ABounds.Right := ABounds.Left + Width;
        end;
      ahRight:
        ABounds.Left := ABounds.Right - Width;
    else // ahClient
      // do nothing
    end;

    case LayoutAlignVert of
      avTop:
        ABounds.Bottom := ABounds.Top + Height;
      avCenter:
        begin
           ABounds.Top := ABounds.Top + (ABounds.Height - Height) div 2;
          ABounds.Bottom := ABounds.Top + Height;
        end;
      avBottom:
        ABounds.Top := ABounds.Bottom - Height;
    else // avClient
      // do nothing
    end;
  end
  else
    ABounds := cxNullRect;
  Calculate(ABounds);
end;

function TdxCustomLayoutItemElementViewInfo.GetHeight: Integer;
begin
  Result := FHeight;
  if Result = 0 then
  begin
    Result := Max(0, Bounds.Height);
    if Result = 0 then
      Result := CalculateHeight;
  end;
end;

function TdxCustomLayoutItemElementViewInfo.GetItem: TdxCustomLayoutItem;
begin
  Result := FItemViewInfo.Item;
end;

function TdxCustomLayoutItemElementViewInfo.GetLayoutLookAndFeel: TdxCustomLayoutLookAndFeel;
begin
  Result := FItemViewInfo.LayoutLookAndFeel;
end;

function TdxCustomLayoutItemElementViewInfo.UseRightToLeftAlignment: Boolean;
begin
  Result := Item.Container.UseRightToLeftAlignment;
end;

function TdxCustomLayoutItemElementViewInfo.GetWidth: Integer;
begin
  Result := FWidth;
  if Result = 0 then
  begin
    Result := Max(0, Bounds.Width);
    if Result = 0 then
      Result := CalculateWidth;
  end;
end;

procedure TdxCustomLayoutItemElementViewInfo.SetHeight(Value: Integer);
begin
  FHeight := Value;
  dxTestCheck(FHeight >= 0, 'TdxCustomLayoutItemElementViewInfo.SetHeight fails');
end;

procedure TdxCustomLayoutItemElementViewInfo.SetWidth(Value: Integer);
begin
  FWidth := Value;
  dxTestCheck(FWidth >= 0, 'TdxCustomLayoutItemElementViewInfo.SetWidth fails');
end;

function TdxCustomLayoutItemElementViewInfo.GetEnabled: Boolean;
begin
  Result := FItemViewInfo.Enabled;
end;

function TdxCustomLayoutItemElementViewInfo.GetIsCustomization: Boolean;
begin
  Result := ItemViewInfo.IsCustomization;
end;

function TdxCustomLayoutItemElementViewInfo.GetCursor(X, Y: Integer): TCursor;
begin
  Result := crDefault;
end;

function TdxCustomLayoutItemElementViewInfo.GetVisible: Boolean;
begin
  Result := False;
end;

procedure TdxCustomLayoutItemElementViewInfo.Invalidate(const ABounds: TRect);
begin
  ItemViewInfo.Invalidate(ABounds);
end;

procedure TdxCustomLayoutItemElementViewInfo.Reset;
begin
//  FWidth := 0;
//  FHeight := 0;
  SetBounds(cxNullRect);
end;

function TdxCustomLayoutItemElementViewInfo.GetLayoutAlignHorz: TdxLayoutRealAlignHorz;
begin
  Result := ahLeft;
end;

function TdxCustomLayoutItemElementViewInfo.GetLayoutAlignVert: TdxLayoutRealAlignVert;
begin
  Result := avCenter;
end;

function TdxCustomLayoutItemElementViewInfo.AllowDragDrop: Boolean;
begin
  Result := True;
end;

function TdxCustomLayoutItemElementViewInfo.WantsMouse(X, Y: Integer): Boolean;
begin
  Result := Visible and PtInRect(Bounds, Point(X, Y));
end;

procedure TdxCustomLayoutItemElementViewInfo.DoAssignBounds(ASource: TdxCustomLayoutElementViewInfo);
begin
  inherited;
  FHeight := TdxCustomLayoutItemElementViewInfo(ASource).FHeight;
  FWidth := TdxCustomLayoutItemElementViewInfo(ASource).FWidth;
end;

function TdxCustomLayoutItemElementViewInfo.ShowHint(var AHintInfo: THintInfo): Boolean;
begin
  Result := False;
end;

{ TdxCustomLayoutItemCaptionViewInfo }

function TdxCustomLayoutItemCaptionViewInfo.GetCanvas: TcxCanvas;
begin
  Result := ItemViewInfo.ContainerViewInfo.GetCanvas;
end;

function TdxCustomLayoutItemCaptionViewInfo.GetFormattedText: TdxFormattedText;
begin
  Result := Item.CaptionOptions.FormattedText;
end;

function TdxCustomLayoutItemCaptionViewInfo.GetVisibleText: string;
begin
  Result := FormattedText.GetDisplayText;
end;

procedure TdxCustomLayoutItemCaptionViewInfo.SetHotTracked(Value: Boolean);
begin
  if FHotTracked <> Value then
  begin
    FHotTracked := Value;
    Invalidate(HotTrackBounds);
  end;
end;

function TdxCustomLayoutItemCaptionViewInfo.GetCursor(X, Y: Integer): TCursor;
begin
  if HotTracked and (htsHandPoint in HotTrackStyles) then
    Result := crcxHandPoint
  else
    Result := inherited GetCursor(X, Y);
end;

function TdxCustomLayoutItemCaptionViewInfo.GetVisible: Boolean;
begin
  Result := ItemViewInfo.HasCaption or (ItemViewInfo.IsDragImagePainting and not ItemViewInfo.ActuallyVisible);
end;

procedure TdxCustomLayoutItemCaptionViewInfo.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if CanDoCaptionClick(X, Y) then
    Item.DoCaptionDown;
end;

procedure TdxCustomLayoutItemCaptionViewInfo.MouseLeave;
begin
  inherited;
  HotTracked := False;
end;

procedure TdxCustomLayoutItemCaptionViewInfo.MouseMove(Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  if IsHotTrackable then
    HotTracked := IsPointInHotTrackBounds(Point(X, Y));
end;

procedure TdxCustomLayoutItemCaptionViewInfo.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  APressed: Boolean;
begin
  APressed := levsPressed in State;
  inherited;
  if CanDoCaptionClick(X, Y) and APressed then
    Item.DoCaptionClick;
end;

function TdxCustomLayoutItemCaptionViewInfo.ShowHint(var AHintInfo: THintInfo): Boolean;
begin
  if Item.CaptionOptions.Hint <> '' then
  begin
    AHintInfo.HintData := @AHintInfo;
    AHintInfo.CursorRect := Bounds;
    AHintInfo.HintStr := GetShortHint(Item.CaptionOptions.Hint);
    Result := AHintInfo.HintStr <> '';
  end
  else
    Result := inherited ShowHint(AHintInfo);
end;

procedure TdxCustomLayoutItemCaptionViewInfo.StateChanged;
begin
  inherited;
  if IsHotTrackable then
    Invalidate(HotTrackBounds);
end;

procedure TdxCustomLayoutItemCaptionViewInfo.AdjustTextAreaBounds(var R: TRect);
begin
  case GetRotationAngle of
    ra0:
      begin
        Dec(R.Right);
        Dec(R.Bottom);
      end;
    raPlus90:
      begin
        Inc(R.Top);
        Dec(R.Right);
      end;
    raMinus90:
      begin
        Inc(R.Left);
        Dec(R.Bottom);
      end;
  end;
end;

function TdxCustomLayoutItemCaptionViewInfo.GetColor: TColor;
begin
  Result := ItemViewInfo.Color;
end;

function TdxCustomLayoutItemCaptionViewInfo.GetFont: TFont;
begin
  Result := Options.GetFont(Item.Container);
end;

function TdxCustomLayoutItemCaptionViewInfo.GetFormattedTextSize(ACanvas: TcxCanvas; const AFlags: Integer;
  const ARect: TRect): TSize;
begin
  CalculateFormattedText(FormattedText, AFlags, ARect, ACanvas.Canvas, False);
  Result := FormattedText.TextSize;
end;

function TdxCustomLayoutItemCaptionViewInfo.GetHotTrackBounds: TRect;
begin
  Result := TextAreaBounds;
end;

function TdxCustomLayoutItemCaptionViewInfo.GetHotTrackStyles: TdxLayoutHotTrackStyles;
begin
  Result := Options.HotTrackStyles;
end;

function TdxCustomLayoutItemCaptionViewInfo.CalculateTextFlags(ACanvas: TcxCanvas; AForDrawing: Boolean): Integer;
const
  AlignsVert: array[TdxAlignmentVert] of Integer = (cxAlignTop, cxAlignVCenter, cxAlignBottom);
  MultiLinesMap: array[Boolean] of Integer = (0, cxWordBreak);
  EllipsisMap: array[TEllipsisPosition] of Integer = (0, cxShowPathEllipsis, cxShowEndEllipsis, cxShowWordEllipsis);
  ExpandTabsMap: array[Boolean] of Integer = (0, cxExpandTabs);

  function GetRealAlignHorz: TAlignment;
  const
    ra180AlignHorzMap: array[TAlignment] of TAlignment = (taRightJustify, taLeftJustify, taCenter);
    raMinus90AlignHorzMap: array[TdxAlignmentVert] of TAlignment = (taRightJustify, taCenter, taLeftJustify);
    raPlus90AlignHorzMap: array[TdxAlignmentVert] of TAlignment = (taLeftJustify, taCenter, taRightJustify);
  begin
    case GetRotationAngle of
      ra180:
        Result := ra180AlignHorzMap[AlignHorz];
      raPlus90:
        Result := raPlus90AlignHorzMap[AlignVert];
      raMinus90:
        Result := raMinus90AlignHorzMap[AlignVert]
    else
      Result := AlignHorz;
    end;
    if Item.Container.UseRightToLeftAlignment then
      Result := ra180AlignHorzMap[Result];
  end;

  function GetRealAlignVert: TdxAlignmentVert;
  const
    ra180AlignVertMap: array[TdxAlignmentVert] of TdxAlignmentVert = (tavBottom, tavCenter, tavTop);
    raPlus90AlignVertMap: array[TAlignment] of TdxAlignmentVert = (tavBottom, tavTop, tavCenter);
    raMinus90AlignVertMap: array[TAlignment] of TdxAlignmentVert = (tavTop, tavBottom, tavCenter);
  begin
    case GetRotationAngle of
      ra180:
        Result := ra180AlignVertMap[AlignVert];
      raPlus90:
        Result := raPlus90AlignVertMap[AlignHorz];
      raMinus90:
        Result := raMinus90AlignVertMap[AlignHorz]
    else
      Result := AlignVert;
    end;
  end;

  function GetEllipsisPosition(AForDrawing: Boolean): TEllipsisPosition;
  begin
    if IsEllipsisAllowed(AForDrawing) then
      Result := Item.CaptionOptions.EllipsisPosition
    else
      Result := epNone;
  end;

begin
  Result := EllipsisMap[GetEllipsisPosition(AForDrawing)] or MultiLinesMap[IsMultiLine] or
    cxAlignmentsHorz[GetRealAlignHorz] or ExpandTabsMap[Item.CaptionOptions.ExpandTabs];
  if AForDrawing then
    Result := (Result or AlignsVert[GetRealAlignVert])
  else
    Result := (Result or cxDontPrint) and not cxAlignRight;

  if Item.CaptionOptions.ShowAccelChar then
    Result := Result or cxShowPrefix;

  if ACanvas.TextFlags and ETO_RTLREADING <> 0 then
    Result := Result or cxRtlReading;
end;

procedure TdxCustomLayoutItemCaptionViewInfo.PrepareCanvas(ACanvas: TcxCanvas; AForDrawing: Boolean);
var
  ATextColor: TColor;
begin
  ACanvas.Font := Font;
  if AForDrawing then
  begin
    ATextColor := TextColor;
    if ATextColor <> clDefault then
      ACanvas.Font.Color := ATextColor;
    if IsTextUnderlined then
      ACanvas.Font.Style := ACanvas.Font.Style + [fsUnderline];
  end;
end;

function TdxCustomLayoutItemCaptionViewInfo.CanDoCaptionClick(X, Y: Integer): Boolean;
begin
  Result := Enabled and IsPointInHotTrackBounds(Point(X, Y));
end;

function TdxCustomLayoutItemCaptionViewInfo.GetTextAlignHorz: TAlignment;
begin
  Result := Item.CaptionOptions.AlignHorz;
end;

function TdxCustomLayoutItemCaptionViewInfo.GetTextAlignVert: TdxAlignmentVert;
begin
  Result := Item.CaptionOptions.AlignVert;
end;

function TdxCustomLayoutItemCaptionViewInfo.GetOptions: TdxLayoutLookAndFeelCaptionOptions;
begin
  Result := ItemViewInfo.Options.CaptionOptions;
end;

function TdxCustomLayoutItemCaptionViewInfo.GetRotationAngle: TcxRotationAngle;
begin
  Result := ra0;
end;

function TdxCustomLayoutItemCaptionViewInfo.GetSpaceBetweenImageText: Integer;
begin
  if IsNeedSpaceBetweenImageText then
    Result := dxLayoutGlyphSpace
  else
    Result := 0;
end;

procedure TdxCustomLayoutItemCaptionViewInfo.DoSetOffset(const AValue, ADiff: TPoint);
begin
  inherited;
  FTextAreaBounds := cxRectOffset(FTextAreaBounds, ADiff);
  FImageAreaBounds := cxRectOffset(FImageAreaBounds, ADiff);
end;

function TdxCustomLayoutItemCaptionViewInfo.GetContentOffsets: TRect;
begin
  Result := Padding;
end;

procedure TdxCustomLayoutItemCaptionViewInfo.DoAssignBounds(ASource: TdxCustomLayoutElementViewInfo);
begin
  inherited DoAssignBounds(ASource);
  FTextAreaBounds := TdxCustomLayoutItemCaptionViewInfo(ASource).TextAreaBounds;
  FImageAreaBounds := TdxCustomLayoutItemCaptionViewInfo(ASource).ImageAreaBounds;
end;

function TdxCustomLayoutItemCaptionViewInfo.GetText: string;
begin
  Result := Item.Caption;
end;

procedure TdxCustomLayoutItemCaptionViewInfo.CalculateFormattedText(AFormattedText: TdxFormattedText;
  const AFlags: Integer; const ARect: TRect; ACanvas: TCanvas; const AForDrawing: Boolean);
var
  AFormat: Cardinal;
begin
  AFormat := DrawTextFlagsTocxTextOutFlags(AFlags);
  if not AForDrawing then
    AFormat := AFormat or CXTO_NOCLIP;
  if IsMultiLine then
    AFormat := AFormat or CXTO_WORDBREAK or CXTO_CHARBREAK;
  if Item.CaptionOptions.ExpandTabs then
    AFormat := AFormat or CXTO_EXPANDTABS;
  AFormattedText.CalculateLayout(ACanvas, ACanvas.Font, ARect, AFormat, Item.ScaleFactor);
end;

procedure TdxCustomLayoutItemCaptionViewInfo.CalculateImageTextAreaBounds;
var
  AContentBounds: TRect;
  AImageSize, ATextPlaceSize: TSize;
  AHeaderWidth, AHeaderHeight: Integer;
begin
  AContentBounds := cxRectContent(Bounds, GetContentOffsets);

  AImageSize := GetImageSize;
  FTextAreaBounds := AContentBounds;
  FTextAreaBounds.Left := FTextAreaBounds.Left + AImageSize.Width + GetSpaceBetweenImageText;
  ATextPlaceSize := GetTextPlaceSize;
  ATextPlaceSize.Width := Min(ATextPlaceSize.Width, FTextAreaBounds.Width);

  case AlignHorz of
    taLeftJustify:
      begin
        FImageAreaBounds.Left := AContentBounds.Left;
        FImageAreaBounds.Right := FImageAreaBounds.Left + AImageSize.Width;
        FTextAreaBounds.Left := FImageAreaBounds.Right + GetSpaceBetweenImageText;
        FTextAreaBounds.Right := FTextAreaBounds.Left + ATextPlaceSize.Width;
      end;
    taRightJustify:
      begin
        FImageAreaBounds.Right := AContentBounds.Right;
        FImageAreaBounds.Left := FImageAreaBounds.Right - AImageSize.Width;
        FTextAreaBounds.Right := FImageAreaBounds.Left - GetSpaceBetweenImageText;
        FTextAreaBounds.Left := FTextAreaBounds.Right - ATextPlaceSize.Width;
      end;
    taCenter:
      begin
        AHeaderWidth := Min(AImageSize.Width + GetSpaceBetweenImageText + ATextPlaceSize.Width, AContentBounds.Width);
        FImageAreaBounds.Left := AContentBounds.Left + (AContentBounds.Width - AHeaderWidth) div 2;
        FImageAreaBounds.Right := FImageAreaBounds.Left + AImageSize.Width;
        FTextAreaBounds.Left := FImageAreaBounds.Right + GetSpaceBetweenImageText;
        FTextAreaBounds.Right := FTextAreaBounds.Left + ATextPlaceSize.Width;
      end;
  end;
  case AlignVert of
    tavTop:
      begin
        AHeaderHeight := Min(AContentBounds.Height, Max(AImageSize.Height, ATextPlaceSize.Height));
        FImageAreaBounds.Top := AContentBounds.Top + (AHeaderHeight - AImageSize.Height) div 2;
        FImageAreaBounds.Bottom := FImageAreaBounds.Top + AImageSize.Height;
        FTextAreaBounds.Top := AContentBounds.Top + (AHeaderHeight - ATextPlaceSize.Height) div 2;
        FTextAreaBounds.Bottom := FTextAreaBounds.Top + ATextPlaceSize.Height;
      end;
    tavBottom:
      begin
        AHeaderHeight := Min(AContentBounds.Height, Max(AImageSize.Height, ATextPlaceSize.Height));
        FImageAreaBounds.Bottom := AContentBounds.Bottom - (AHeaderHeight - AImageSize.Height) div 2;
        FImageAreaBounds.Top := FImageAreaBounds.Bottom - AImageSize.Height;
        FTextAreaBounds.Bottom := AContentBounds.Bottom - (AHeaderHeight - ATextPlaceSize.Height) div 2;
        FTextAreaBounds.Top := FTextAreaBounds.Bottom - ATextPlaceSize.Height;
      end;
  tavCenter:
      begin
        FImageAreaBounds.Top := AContentBounds.Top + (AContentBounds.Height - AImageSize.Height) div 2;
        FImageAreaBounds.Bottom := FImageAreaBounds.Top + AImageSize.Height;
        FTextAreaBounds.Top := AContentBounds.Top + (AContentBounds.Height - ATextPlaceSize.Height) div 2;
        FTextAreaBounds.Bottom := FTextAreaBounds.Top + ATextPlaceSize.Height;
      end;
  end;
end;

function TdxCustomLayoutItemCaptionViewInfo.GetTextColor: TColor;
begin
  if not Enabled then
    Result := GetTextDisabledColor
  else
    if HotTracked then
      Result := GetTextHotColor
    else
      Result := GetTextNormalColor;
end;

function TdxCustomLayoutItemCaptionViewInfo.GetTextDisabledColor: TColor;
begin
  Result := Options.GetTextDisabledColor;
end;

function TdxCustomLayoutItemCaptionViewInfo.GetTextHotColor: TColor;
begin
  Result := Options.GetTextHotColor;
end;

function TdxCustomLayoutItemCaptionViewInfo.GetTextNormalColor: TColor;
begin
  Result := Options.GetTextColor;
end;

function TdxCustomLayoutItemCaptionViewInfo.GetOptimalTextSize(ACanvas: TcxCanvas): TSize;
  function GetVisibleText: string;
  begin
    if Item.CaptionOptions.ShowAccelChar then
      Result := RemoveAccelChars(Text)
    else
      Result := Text;
  end;

var
  R: TRect;
begin
  if (FTextSizeCache.OptimalTextSize.Width = 0) then
  begin
    R := Rect(0, 0, 1, 1);
    if IsTextFormatted then
      FTextSizeCache.OptimalTextSize := GetFormattedTextSize(ACanvas, CalculateTextFlags(ACanvas, False), R)
    else
      if (Pos(#13, Text) > 0) or Item.CaptionOptions.ExpandTabs and (Pos(#9, Text) > 0) then
      begin
        ACanvas.TextExtent(Text, R, CalculateTextFlags(ACanvas, False) or cxDontBreakChars);
        FTextSizeCache.OptimalTextSize := cxRectSize(R);
      end
      else
        FTextSizeCache.OptimalTextSize := ACanvas.TextExtent(GetVisibleText);
  end;
  Result := FTextSizeCache.OptimalTextSize;
end;

function TdxCustomLayoutItemCaptionViewInfo.GetOptimalTextPlaceSize: TSize;
begin
  Result := GetTextPlaceSizeFromTextSize(GetOptimalTextSize);
end;

function TdxCustomLayoutItemCaptionViewInfo.GetTextPadding: TdxPadding;
begin
  Result := Rect(0, 0, dxLayoutCorrectionForDisabling, dxLayoutCorrectionForDisabling);
end;

function TdxCustomLayoutItemCaptionViewInfo.GetTextAreaWidth: Integer;
begin
  Result := GetTextPlaceSize.Width;
end;

function TdxCustomLayoutItemCaptionViewInfo.GetTextPlaceSize: TSize;
begin
  Result := GetTextPlaceSizeFromTextSize(GetTextSize);
end;

function TdxCustomLayoutItemCaptionViewInfo.GetTextPlaceSizeFromTextSize(ASizeFunc: TdxPreparedCanvasTextPlaceSizeFunc): TSize;
begin
  if IsTextVisible then
  begin
    PrepareCanvas(Canvas, False);
    Result := ASizeFunc(Canvas);
    GetTextPadding.Inflate(Result);
  end
  else
    Result := cxNullSize;
end;

function TdxCustomLayoutItemCaptionViewInfo.GetTextSize(ACanvas: TcxCanvas): TSize;
begin
  if FTextSizeCache.TextSize.Width = 0 then
    FTextSizeCache.TextSize := GetOptimalTextSize(ACanvas);
  Result := FTextSizeCache.TextSize;
end;

function TdxCustomLayoutItemCaptionViewInfo.IsEllipsisAllowed(AForDrawing: Boolean = False): Boolean;
begin
  if AForDrawing then
    Result := EllipsisPosition <> epNone
  else
    Result := ItemViewInfo.IsEllipsisAllowed;
end;

function TdxCustomLayoutItemCaptionViewInfo.IsWidthFixed: Boolean;
begin
  Result := False;
end;

function TdxCustomLayoutItemCaptionViewInfo.IsMultiLine: Boolean;
begin
  Result := False;
end;

function TdxCustomLayoutItemCaptionViewInfo.IsNeedSpaceBetweenImageText: Boolean;
begin
  Result := IsTextVisible and IsImageVisible;
end;

function TdxCustomLayoutItemCaptionViewInfo.IsPointInHotTrackBounds(const P: TPoint): Boolean;
begin
  Result := IsImageVisible and PtInRect(ImageAreaBounds, P);
  Result := Result or (IsTextVisible  and PtInRect(TextAreaBounds, P));
  Result := Result or (IsImageVisible and IsTextVisible and PtInRect(cxRectUnion(ImageAreaBounds, TextAreaBounds), P));

end;

function TdxCustomLayoutItemCaptionViewInfo.IsImageVisible: Boolean;
begin
  if FIsImageVisible = bDefault then
    FIsImageVisible := TdxDefaultBoolean(Item.IsImageVisible);
  Result := Boolean(FIsImageVisible);
end;

function TdxCustomLayoutItemCaptionViewInfo.IsTextVisible: Boolean;
begin
  if FIsTextVisible = bDefault then
    FIsTextVisible := TdxDefaultBoolean(Item.IsTextVisible);
  Result := Boolean(FIsTextVisible);
end;

function TdxCustomLayoutItemCaptionViewInfo.IsHotTrackable: Boolean;
begin
  Result := not IsCustomization and Enabled and Options.HotTrack;
end;

function TdxCustomLayoutItemCaptionViewInfo.IsTextFormatted: Boolean;
begin
  Result := FormattedText.HasFormatting;
end;

function TdxCustomLayoutItemCaptionViewInfo.IsTextUnderlined: Boolean;
begin
  Result :=
    IsHotTrackable and not HotTracked and (htsUnderlineCold in HotTrackStyles) or
    HotTracked and (htsUnderlineHot in HotTrackStyles);
end;

function TdxCustomLayoutItemCaptionViewInfo.GetLayoutAlignHorz: TdxLayoutRealAlignHorz;
const
//  AlignHorzMap: array [TdxLayoutItemControlAlignHorz] of TAlignment = (taLeftJustify, taCenter, taRightJustify, taCenter);
  AlignHorzMap: array [TAlignment] of TdxLayoutRealAlignHorz = (ahLeft, ahRight, ahCenter);
begin
  Result := AlignHorzMap[AlignHorz];
end;

function TdxCustomLayoutItemCaptionViewInfo.GetLayoutAlignVert: TdxLayoutRealAlignVert;
const
//  AlignVertMap: array [TdxLayoutItemControlAlignVert] of TdxAlignmentVert = (tavTop, tavCenter, tavBottom, tavCenter);
  AlignVertMap: array [TdxAlignmentVert] of TdxLayoutItemControlAlignVert = (avTop, avCenter, avBottom);
begin
  Result := AlignVertMap[AlignVert];
end;

function TdxCustomLayoutItemCaptionViewInfo.GetContentOffsetSize: TSize;
begin
  with GetContentOffsets do
    Result := cxSize(Left + Right, Top + Bottom);
end;

function TdxCustomLayoutItemCaptionViewInfo.GetImageSize: TSize;
begin
  if IsImageVisible then
    Result := Item.CaptionOptions.ImageOptions.GetImageSize
  else
    Result := cxNullSize;
end;

function TdxCustomLayoutItemCaptionViewInfo.GetImageHeight: Integer;
begin
  Result := GetImageSize.Height;
end;

function TdxCustomLayoutItemCaptionViewInfo.GetImageWidth: Integer;
begin
  Result := GetImageSize.Width;
end;

constructor TdxCustomLayoutItemCaptionViewInfo.Create(AItemViewInfo: TdxCustomLayoutItemViewInfo);
begin
  inherited;
  FTextLayout := Item.CaptionOptions.Layout;
  FEllipsisPosition := Item.CaptionOptions.EllipsisPosition;
  FIsImageVisible := bDefault;
  FIsTextVisible := bDefault;
end;

procedure TdxCustomLayoutItemCaptionViewInfo.Calculate(const ABounds: TRect);
begin
  inherited;
  if Visible then
    CalculateImageTextAreaBounds;
end;

function TdxCustomLayoutItemCaptionViewInfo.CalculateHeight: Integer;
begin
  if Visible then
  begin
    Result := Max(GetTextPlaceSize.Height, ImageHeight);
    Inc(Result, GetContentOffsetSize.Height);
  end
  else
    Result := 0;
end;

function TdxCustomLayoutItemCaptionViewInfo.CalculateWidth: Integer;
begin
  if Visible then
  begin
    Result := GetTextAreaWidth + GetSpaceBetweenImageText + ImageWidth;
    Inc(Result, GetContentOffsetSize.Width);
  end
  else
    Result := 0;
end;

procedure TdxCustomLayoutItemCaptionViewInfo.DoRightToLeftConversion(const AClientBounds: TRect);
begin
  inherited;
  FTextAreaBounds := TdxRightToLeftLayoutConverter.ConvertRect(FTextAreaBounds, AClientBounds);
  FImageAreaBounds := TdxRightToLeftLayoutConverter.ConvertRect(FImageAreaBounds, AClientBounds);
end;

{ TdxCustomLayoutItemViewData }

constructor TdxCustomLayoutItemViewData.Create(AOwner: TdxLayoutItemViewDataList; AItem: TdxCustomLayoutItem);
begin
  inherited Create;
  FItem := AItem;
  FNotifyComponent := TcxFreeNotificator.Create(nil);
  FNotifyComponent.OnFreeNotification := FreeNotification;
  FItem.FreeNotification(FNotifyComponent);
  FOwner := AOwner;
end;

destructor TdxCustomLayoutItemViewData.Destroy;
begin
  dxTestCheck(ViewInfo = nil, 'TdxCustomLayoutItemViewData.Destroy fails');
  FreeAndNil(FNotifyComponent);
  inherited;
end;

procedure TdxCustomLayoutItemViewData.Assign(Source: TdxCustomLayoutItemViewData);
begin
end;

procedure TdxCustomLayoutItemViewData.Calculate;
begin
end;

procedure TdxCustomLayoutItemViewData.Load(AStream: TStream);
begin
end;

procedure TdxCustomLayoutItemViewData.Save(AStream: TStream);
begin
end;

procedure TdxCustomLayoutItemViewData.Changed;
begin
// do nothing
end;

function TdxCustomLayoutItemViewData.GetSize: Integer;
begin
  Result := 0;
end;

function TdxCustomLayoutItemViewData.ReadBoolean(AStream: TStream): Boolean;
begin
  AStream.Read(Result, 1);
end;

procedure TdxCustomLayoutItemViewData.WriteBoolean(AStream: TStream; AValue: Boolean);
begin
  AStream.Write(AValue, 1);
end;

procedure TdxCustomLayoutItemViewData.FreeNotification(AComponent: TComponent);
begin
  FItem := nil;
  if ViewInfo <> nil then
    ViewInfo.FreeNotification(AComponent);
end;

{ TdxLayoutCloneDataList }

procedure TdxLayoutItemViewDataList.Changed;
begin
  CallNotify(FOnChanged, Self);
end;

function TdxLayoutItemViewDataList.GetItem(Index: TdxListIndex): TdxCustomLayoutItemViewData;
begin
  Result := TdxCustomLayoutItemViewData(List[Index]);
end;

procedure TdxLayoutItemViewDataList.SetItem(Index: TdxListIndex; Value: TdxCustomLayoutItemViewData);
begin
  inherited Items[Index] := Value;
end;

{ TdxCustomLayoutItemViewInfo }

constructor TdxCustomLayoutItemViewInfo.Create(AContainerViewInfo: TdxLayoutContainerViewInfo; AParentViewInfo: TdxLayoutGroupViewInfo;
  AViewData: TdxCustomLayoutItemViewData);
begin
  inherited Create;
  FIsOnGlass := AContainerViewInfo.IsOnGlass;
  FIsValid := True;
  FHasCaption := bDefault;
  FParentViewInfo := AParentViewInfo;
  FContainerViewInfo := AContainerViewInfo;
  FViewData := AViewData;
  FTabOrder := -1;
  FOffset := ContainerViewInfo.Offset;
  CreateViewInfos;
end;

destructor TdxCustomLayoutItemViewInfo.Destroy;
begin
  dxTestCheck((ViewData <> nil) and not FDestroyForbidden, 'TdxCustomLayoutItemViewInfo.Destroy fails');

  ContainerViewInfo.FItemViewInfoDictionary.Remove(Item);
  ViewData.ViewInfo := nil;
  FreeAndNil(FPainter);
  DestroyViewInfos;
  inherited;
end;

function TdxCustomLayoutItemViewInfo.GetAlign: TdxLayoutRealAlign;
begin
  Result := Item.RealAlign;
end;

function TdxCustomLayoutItemViewInfo.GetAlignHorz: TdxLayoutRealAlignHorz;
begin
  Result := Align.Horz;
end;

function TdxCustomLayoutItemViewInfo.GetAlignVert: TdxLayoutRealAlignVert;
begin
  Result := Align.Vert;
end;

function TdxCustomLayoutItemViewInfo.GetBackgroundBounds: TRect;
begin
  if IsDragImagePainting then
    Result := SelectionBorderRect
  else
    Result := Bounds;
end;

function TdxCustomLayoutItemViewInfo.GetCanPaint: Boolean;
begin
  Result := ActuallyVisible or
    IsDragImagePainting and (IsDragged or IsDraggedWithParent and ParentViewInfo.CanPaint and
    ParentViewInfo.Specific.AllowDrawChild(Self));
end;

function TdxCustomLayoutItemViewInfo.GetHasMouse: Boolean;
begin
  Result := ContainerViewInfo.ItemWithMouse = Item;
end;

function TdxCustomLayoutItemViewInfo.GetItem: TdxCustomLayoutItem;
begin
  Result := ViewData.Item;
end;

function TdxCustomLayoutItemViewInfo.AsGroupViewInfo: TdxLayoutGroupViewInfo;
begin
  Result := TdxLayoutGroupViewInfo(Self);
end;

function TdxCustomLayoutItemViewInfo.IsAvailable: Boolean;
begin
  Result := Item.IsAvailable;
end;

function TdxCustomLayoutItemViewInfo.IsExpanded: Boolean;
begin
  Result := True;
end;

function TdxCustomLayoutItemViewInfo.IsFocused: Boolean;
begin
  Result := Item.IsFocused;
end;

function TdxCustomLayoutItemViewInfo.IsParentExpanded: Boolean;
begin
  Result := (ParentViewInfo = nil) or (ParentViewInfo.IsExpanded and ParentViewInfo.IsParentExpanded);
end;

function TdxCustomLayoutItemViewInfo.IsDragged: Boolean;
begin
  Result := Item.IsDragged;
end;

function TdxCustomLayoutItemViewInfo.IsDraggedWithParent: Boolean;
begin
  Result := (ParentViewInfo <> nil) and (ParentViewInfo.IsDragged or ParentViewInfo.IsDraggedWithParent);
end;

function TdxCustomLayoutItemViewInfo.IsDragImagePainting: Boolean;
begin
  Result := ContainerViewInfo.IsDragImagePainting;
end;

function TdxCustomLayoutItemViewInfo.IsGrabbed: Boolean;
begin
  Result := Item.IsGrabbed;
end;

function TdxCustomLayoutItemViewInfo.IsValid: Boolean;
begin
  Result := FIsValid and ((Item <> nil) and
    ((Item.Parent = nil) and (ParentViewInfo = nil) or
      (ContainerViewInfo.GetItemViewInfo(Item.Parent) = ParentViewInfo) and ParentViewInfo.IsValid));
end;

function TdxCustomLayoutItemViewInfo.IsVertical: Boolean;
begin
  Result := Item.IsVertical;
end;

function TdxCustomLayoutItemViewInfo.IsEllipsisAllowed(AForDrawing: Boolean = False): Boolean;
begin
  Result := (CaptionViewInfo.EllipsisPosition <> epNone) and (CaptionViewInfo.IsWidthFixed or IsWidthLimited and not Item.Parent.CanWrapItems or (CaptionViewInfo.TextLayout in [clTop, clBottom]));
end;

function TdxCustomLayoutItemViewInfo.IsHeightLimited: Boolean;
begin
  Result := Item.IsHeightFixed or (GetAlignVert = avClient) and ((ParentViewInfo = nil) or ParentViewInfo.IsHeightLimited);
end;

function TdxCustomLayoutItemViewInfo.IsWidthLimited: Boolean;
begin
  Result := FIsMaxWidth or Item.IsWidthLimited or (GetAlignHorz = ahClient) and ((ParentViewInfo = nil) or ParentViewInfo.IsWidthLimited);
end;

function TdxCustomLayoutItemViewInfo.IsWordWrapAllowed: Boolean;
begin
  Result := False;
end;

function TdxCustomLayoutItemViewInfo.GetLayoutLookAndFeel: TdxCustomLayoutLookAndFeel;
begin
  if FLayoutLookAndFeel = nil then
    FLayoutLookAndFeel := ContainerViewInfo.GetItemLayoutLookAndFeel(Self);
  Result := FLayoutLookAndFeel;
end;

function TdxCustomLayoutItemViewInfo.CanAssignBounds(ASource: TdxCustomLayoutElementViewInfo): Boolean;
begin
  Result := inherited CanAssignBounds(ASource) and (TdxCustomLayoutItemViewInfo(ASource).Item = Item);
  dxTestCheck(Result, 'AssignBounds fails');
end;

function GetElement(AElements: TList; AIndex: Integer): TdxCustomLayoutItemElementViewInfo;
begin
  Result := TdxCustomLayoutItemElementViewInfo(AElements.List[AIndex]);
end;

procedure TdxCustomLayoutItemViewInfo.DoAssignBounds(ASource: TdxCustomLayoutElementViewInfo);
var
  I: Integer;
  AElements1, AElements2: TList;
begin
  inherited;

  AElements1 := TList.Create;
  AElements2 := TList.Create;
  try
    GetElements(AElements1);
    TdxCustomLayoutItemViewInfo(ASource).GetElements(AElements2);
    for I := 0 to AElements1.Count - 1 do
      GetElement(AElements1, I).AssignBounds(GetElement(AElements2, I));
  finally
    AElements2.Free;
    AElements1.Free;
  end;
end;

procedure TdxCustomLayoutItemViewInfo.DoSetOffset(const AValue, ADiff: TPoint);
var
  I: Integer;
  AElements: TList;
begin
  inherited;

  AElements := TList.Create;
  try
    GetElements(AElements);
    for I := 0 to AElements.Count - 1 do
      GetElement(AElements, I).Offset := AValue;
  finally
    AElements.Free;
  end;
end;

procedure TdxCustomLayoutItemViewInfo.Invalidate(const ABounds: TRect);
begin
  Item.Container.InvalidateRect(ABounds, False);
end;

procedure TdxCustomLayoutItemViewInfo.PaintSelection(ABitmap: TcxAlphaBitmap);

  procedure dxDrawSelectionMarkers(ACanvas: TdxGPCanvas; AMarkers: TRects;
    ABorderColor, ABorderMarkerInnerColor: TColor);

    procedure DrawSelectionBorderMarker(const R: TRect);
    begin
      ACanvas.Rectangle(R, dxColorToAlphaColor(ABorderColor, 255), dxColorToAlphaColor(ABorderMarkerInnerColor, 255));
    end;

  var
    I: Integer;
  begin
    for I := Low(AMarkers) to High(AMarkers) do
      DrawSelectionBorderMarker(AMarkers[I]);
  end;

var
  ABackgroundBitmap: TcxAlphaBitmap;
  ASizableMarkers, ANonSizableMarkers: TRects;
  ASelectionBorderRect: TRect;
  AGP: TdxGPCanvas;
begin
  ASelectionBorderRect := SelectionBorderRect;
  if not IsRectEmpty(ASelectionBorderRect) then
  begin
    ABackgroundBitmap := TcxAlphaBitmap.CreateSize(SelectionBorderRect);
    try
      ABackgroundBitmap.cxCanvas.FillRect(ABackgroundBitmap.ClientRect, dxLayoutSelectionBackgroundColor);
      ABackgroundBitmap.SetAlphaChannel(dxLayoutSelectionAlphaChannel);
      ABitmap.CopyBitmap(ABackgroundBitmap, SelectionBorderRect, cxNullPoint);
    finally
      ABackgroundBitmap.Free;
    end;

    AGP := TdxGPCanvas.Create(ABitmap.Canvas.Handle);
    try
      AGP.Rectangle(SelectionBorderRect, dxColorToAlphaColor(dxLayoutSelectionBorderColor, 255), TdxAlphaColors.Empty);

      GetSelectionMarkers(ASizableMarkers, ANonSizableMarkers);
      dxDrawSelectionMarkers(AGP, ASizableMarkers, dxLayoutSelectionBorderColor, dxLayoutSelectionBorderColor);
      dxDrawSelectionMarkers(AGP, ANonSizableMarkers, dxLayoutSelectionBorderColor, dxLayoutSelectionBorderMarkerBackgroundColor);
    finally
      AGP.Free;
    end;
  end;
end;

var
  HatchBitmap: TcxAlphaBitmap;

procedure cxLayoutDrawHatch(ABitmap: TcxAlphaBitmap; const ARect: TRect);
begin
  if HatchBitmap = nil then
    HatchBitmap := TcxAlphaBitmap.Create;

  if (HatchBitmap.Width < ARect.Width) or (HatchBitmap.Height < ARect.Height) then
  begin
    HatchBitmap.SetSize(ARect.Width, ARect.Height);
    HatchBitmap.Clear;
    HatchBitmap.DrawHatch(clBlack, clBtnFace, 2, 20, 170);
  end;

  if CanApplySystemAlphaBlending then
    SystemAlphaBlend(ABitmap.Canvas.Handle, HatchBitmap.Canvas.Handle, ARect, cxRect(0, HatchBitmap.Height - ARect.Height, ARect.Width, HatchBitmap.Height));
end;

procedure TdxCustomLayoutItemViewInfo.PaintLockedState(ABitmap: TcxAlphaBitmap);
begin
  cxLayoutDrawHatch(ABitmap, SelectionBorderRect);
end;

procedure TdxCustomLayoutItemViewInfo.PaintInvisibleState(ABitmap: TcxAlphaBitmap);
begin
  cxDrawHatch(ABitmap.cxCanvas.Handle, SelectionBorderRect, clBlack, clred, 8, 20, 20);
end;

procedure TdxCustomLayoutItemViewInfo.PaintSelectionLayer(ABitmap: TcxAlphaBitmap; var ADrawingRect: TRect);
{
type
  TdxCornerLayout = (clTopLeft, clTopCenter, clTopRight,
    clCenterLeft, clCenterCenter, clCenterRight,
    clBottomLeft, clBottomCenter, clBottomRight);

  procedure DrawAnchors;
  var
    A: set of TdxCornerLayout;
    B: TdxCornerLayout;
    R: TRect;
    ACanvas: TcxCanvas;
  begin
    case Align.Horz of
      ahLeft:
        A := [clTopLeft, clCenterLeft, clBottomLeft];
      ahCenter:
        A := [clTopCenter, clCenterCenter, clBottomCenter];
      ahRight:
        A := [clTopRight, clCenterRight, clBottomRight];
      ahClient:
        A := [clTopLeft, clTopRight, clCenterLeft, clCenterRight, clBottomLeft, clBottomRight];
    end;
    case Align.Vert of
      avTop:
        A := A - [clCenterLeft, clCenterCenter, clCenterRight, clBottomLeft, clBottomCenter, clBottomRight];
      avCenter:
        A := A  - [clTopLeft, clTopCenter, clTopRight, clBottomLeft, clBottomCenter, clBottomRight];
      avBottom:
        A := A - [clTopLeft, clTopCenter, clTopRight, clCenterLeft, clCenterCenter, clCenterRight];
      avClient:
        A := A - [clCenterLeft, clCenterCenter, clCenterRight];
    end;

    R := Bounds;
    ACanvas := ABitmap.cxCanvas;
    ACanvas.Pen.Color := clred;
    for B := Low(TdxCornerLayout) to High(TdxCornerLayout) do
      if B in A then
      case B of
       clTopLeft:
         begin
           ACanvas.MoveTo(R.Left, R.Top);
           ACanvas.LineTo(R.Left + 2, R.Top);
           ACanvas.LineTo(R.Left, R.Top + 2);
           ACanvas.LineTo(R.Left, R.Top);
         end;
       clTopCenter: ;
       clTopRight: ;
       clCenterLeft: ;
       clCenterCenter: ;
       clCenterRight: ;
       clBottomLeft: ;
       clBottomCenter: ;
       clBottomRight: ;
      end;
      ABitmap.RecoverAlphaChannel(Bounds, 0);
  end;
}

  procedure AddRect(var AResultRect: TRect; const AAddedRect: TRect);
  begin
    if cxRectIsEmpty(AResultRect) then
      AResultRect := AAddedRect
    else
      AResultRect.Union(AAddedRect);
  end;

begin
  dxTestCheck(IsValid, 'TdxCustomLayoutItemViewInfo.PaintSelectionLayer fails');

  if Item.IsLocked and not Item.Parent.IsLocked then
  begin
    PaintLockedState(ABitmap);
    AddRect(ADrawingRect, GetSelectionArea);
  end;

  if Selected then
  begin
    if IsDragged then
      TdxLayoutDragAndDropState.PaintDraggedItem(ABitmap, Self)
    else
      PaintSelection(ABitmap);
    AddRect(ADrawingRect, GetSelectionArea);
  end;
  if not Item.Visible and (Item.IsRoot or Item.Parent.Visible) then
  begin
    PaintInvisibleState(ABitmap);
    AddRect(ADrawingRect, GetSelectionArea);
  end;

end;

procedure TdxCustomLayoutItemViewInfo.PaintContent(ADestImage: TcxAlphaBitmap; ANeedDrawFrame, AExtractLayer: Boolean);
begin
  if ANeedDrawFrame then
    ADestImage.cxCanvas.WindowOrg := SelectionBorderRect.TopLeft
  else
    ADestImage.cxCanvas.WindowOrg := Bounds.TopLeft;
  try
    GetPainter.Paint(ADestImage.cxCanvas);
    if ANeedDrawFrame then
      FPainter.DrawDragImageFrame(ADestImage.cxCanvas);
    FPainter.DrawSpecificPart(ADestImage.cxCanvas);
  finally
    ADestImage.cxCanvas.WindowOrg := cxNullPoint;
  end;
  if AExtractLayer then
  begin
    ADestImage.MakeOpaque;
    ADestImage.ExtractLayer(GetBackgroundColor);
  end;
end;

function TdxCustomLayoutItemViewInfo.ShowHint(var AHintInfo: THintInfo): Boolean;
begin
  Result := (ElementWithMouse <> nil) and ElementWithMouse.ShowHint(AHintInfo);
end;

function TdxCustomLayoutItemViewInfo.GetMaxTabOrder: Integer;
begin
  Result := TabOrder;
end;

function TdxCustomLayoutItemViewInfo.CanInplaceRename: Boolean;
begin
  Result := not Item.IsDesigning and not Item.IsRoot and (CaptionViewInfo <> nil) and CaptionViewInfo.IsTextVisible and
    Item.Container.AllowRename;
end;

procedure TdxCustomLayoutItemViewInfo.DoInplaceRename;
var
  R: TRect;
begin
  R := GetInplaceRenameBounds;
  if not cxRectIsEmpty(R) then
    ContainerViewInfo.Container.BeginRename(Item, R, CaptionViewInfo.Font);
end;

procedure TdxCustomLayoutItemViewInfo.InplaceRename;
begin
  if CanInplaceRename then
    DoInplaceRename;
end;

function TdxCustomLayoutItemViewInfo.GetInplaceRenameBounds: TRect;
begin
  if not HasCaption and (ParentViewInfo <> nil) and not ParentViewInfo.AllowChildHasBorder then
    Result := ParentViewInfo.GetChildInplaceRenameBounds(Self)
  else
  begin
    Result := CaptionViewInfo.TextAreaBounds;
    if not cxRectIsEmpty(Result) then
    begin
      CaptionViewInfo.AdjustTextAreaBounds(Result);
      InflateRect(Result, 1, 1);
    end;
  end;
end;

function TdxCustomLayoutItemViewInfo.IsParentLocked: Boolean;
begin
  Result := Item.IsParentLocked;
end;

function TdxCustomLayoutItemViewInfo.IsParentSelected: Boolean;
begin
  Result := (ParentViewInfo <> nil) and (ParentViewInfo.Selected or ParentViewInfo.IsParentSelected);
end;

function TdxCustomLayoutItemViewInfo.GetMaxHeight: Integer;
begin
  if Item.SizeOptions.MaxHeight > 0 then
    Result := Item.SizeOptions.MaxHeight
  else
    Result := cxMaxRectSize;
end;

function TdxCustomLayoutItemViewInfo.GetMaxWidth: Integer;
begin
  if Item.SizeOptions.MaxWidth > 0 then
    Result := Item.SizeOptions.MaxWidth
  else
    Result := cxMaxRectSize;
end;

function TdxCustomLayoutItemViewInfo.GetMinHeight: Integer;
begin
  if AlignVert = avClient then
    Result := CalculateMinHeight
  else
    Result := CalculateHeight;
end;

function TdxCustomLayoutItemViewInfo.GetMinWidth: Integer;
begin
  if AlignHorz = ahClient then
    Result := CalculateMinWidth
  else
    Result := CalculateWidth;
end;

function TdxCustomLayoutItemViewInfo.GetMinWidthWithWrapItems: Integer;
begin
  Result := DoCalculateWidth(cstMin);
end;

function TdxCustomLayoutItemViewInfo.GetUsualHeight: Integer;
begin
  Result := CalculateHeight;
end;

function TdxCustomLayoutItemViewInfo.GetUsualWidth: Integer;
begin
  Result := CalculateWidth;
end;

function TdxCustomLayoutItemViewInfo.GetSufficientWidth: Integer;
begin
  if Item.Width <> 0 then
    Result := GetUsualWidth
  else
    Result := DoCalculateWidth(cstSufficient);
end;

function TdxCustomLayoutItemViewInfo.GetSufficientHeight: Integer;
begin
  if Item.Height <> 0 then
    Result := GetUsualHeight
  else
    Result := DoCalculateHeight(cstSufficient);
end;

function TdxCustomLayoutItemViewInfo.GetOffset(ASide: TdxLayoutSide): Integer;
begin
  Result := FOffsets[ASide];
  if Result = 0 then
    Result := CalculateOffset(ASide);
end;

function TdxCustomLayoutItemViewInfo.GetOffsetsHeight: Integer;
begin
  Result := Offsets[sdTop] + Offsets[sdBottom];
end;

function TdxCustomLayoutItemViewInfo.GetOffsetsWidth: Integer;
begin
  Result := Offsets[sdLeft] + Offsets[sdRight];
end;

function TdxCustomLayoutItemViewInfo.GetMarkerIndex(AMarkers: TRects; const P: TPoint): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := Low(AMarkers) to High(AMarkers) do
    if PtInRect(AMarkers[I], P) then
    begin
      Result := I;
      Break;
    end;
end;

function TdxCustomLayoutItemViewInfo.GetMarkerIndex(const P: TPoint): Integer;
begin
  Result := GetMarkerIndex(dxGetSelectionMarkers(SelectionBorderRect, dxLayoutSelectionMarkerWidth), P);
end;

function TdxCustomLayoutItemViewInfo.GetSelectionBoundsOffset: Integer;
const
  SelectionGab = dxLayoutSelectionOffset / 2;

  function CanUseSelectionOffset: Boolean;
  var
    ARootViewInfo: TdxLayoutGroupViewInfo;
  begin
    ARootViewInfo := ContainerViewInfo.ItemsViewInfo;
    Result := ((ParentViewInfo = nil) and (not Item.IsRoot or
      ((ARootViewInfo.ItemsAreaOffsetHorz > SelectionGab) and (ARootViewInfo.ItemsAreaOffsetVert > SelectionGab)))) or
      ((ParentViewInfo <> nil) and (ParentViewInfo.UseItemOffset and (ParentViewInfo.ItemOffset > SelectionGab)));
  end;

begin
  if CanUseSelectionOffset then
    Result := dxLayoutSelectionOffset
  else
    Result := 0;
  if Item.IsRoot then
    Result := -Result;
end;

function TdxCustomLayoutItemViewInfo.GetSelected: Boolean;
begin
  Result := Item.IsSelected;
end;

function TdxCustomLayoutItemViewInfo.GetSelectionBorderRect: TRect;
var
  ABoundsOffset: Integer;
begin
  Result := GetVisibleBounds;
  if not cxRectIsEmpty(Result) then
  begin
    ABoundsOffset := GetSelectionBoundsOffset;
    InflateRect(Result, ABoundsOffset, ABoundsOffset);
  end;
end;

function TdxCustomLayoutItemViewInfo.GetSelectableMarkers: TRects;
var
  ANonSizableMarkers: TRects;
begin
  GetSelectionMarkers(Result, ANonSizableMarkers);
end;

procedure TdxCustomLayoutItemViewInfo.GetSelectionMarkers(out ASelectable, ANonSelectable: TRects);

  function GetWorkAlignHorz(AItem: TdxCustomLayoutItem): TdxLayoutAlignHorz;
  begin
    Result := AItem.GetRealAlignHorz;
    if (Result = ahClient) and (AItem.Parent <> nil) and (AItem.Parent.Width = 0) then
      Result := GetWorkAlignHorz(AItem.Parent);
  end;

  function GetWorkAlignVert(AItem: TdxCustomLayoutItem): TdxLayoutAlignVert;
  begin
    Result := AItem.GetRealAlignVert;
    if (Result = avClient) and (AItem.Parent <> nil) and (AItem.Parent.Height = 0) then
      Result := GetWorkAlignVert(AItem.Parent);
  end;

  procedure MoveRect(AIndex: Integer);
  begin
    if not cxRectIsEmpty(ASelectable[AIndex]) then
    begin
      ANonSelectable[AIndex] := ASelectable[AIndex];
      ASelectable[AIndex] := cxEmptyRect;
    end;
  end;

begin
  if Item.CanResizeHorz or Item.CanResizeVert then
  begin
    ASelectable := dxGetSelectionMarkers(SelectionBorderRect, dxLayoutSelectionMarkerWidth);
    SetLength(ANonSelectable, Length(ASelectable));

    if (GetWorkAlignHorz(Item) in [ahLeft, ahClient]) or not Item.CanResizeHorz then
    begin
      MoveRect(0);
      MoveRect(6);
      MoveRect(7);
    end;

    if (GetWorkAlignHorz(Item) in [ahRight, ahClient]) or not Item.CanResizeHorz then
    begin
      MoveRect(2);
      MoveRect(3);
      MoveRect(4);
    end;

    if (GetWorkAlignVert(Item) in [avTop, avClient]) or not Item.CanResizeVert then
    begin
      MoveRect(0);
      MoveRect(1);
      MoveRect(2);
    end;

    if (GetWorkAlignVert(Item) in [avBottom, avClient]) or not Item.CanResizeVert then
    begin
      MoveRect(4);
      MoveRect(5);
      MoveRect(6);
    end;
  end
  else
  begin
    ANonSelectable := dxGetSelectionMarkers(SelectionBorderRect, dxLayoutSelectionMarkerWidth);
    SetLength(ASelectable, Length(ANonSelectable));
  end;
end;

function TdxCustomLayoutItemViewInfo.GetVisibleBounds: TRect;
begin
  Result := GetVisiblePart(Bounds);
end;

function TdxCustomLayoutItemViewInfo.GetVisiblePart(const ARect: TRect): TRect;
begin
  if ParentViewInfo <> nil then
    Result := ParentViewInfo.GetInscribedRect(ARect)
  else
    Result := ARect;
end;

function TdxCustomLayoutItemViewInfo.GetSelectionArea: TRect;
begin
  Result := SelectionBorderRect;
  InflateRect(Result, dxLayoutSelectionMarkerWidth div 2, dxLayoutSelectionMarkerWidth div 2);
end;

procedure TdxCustomLayoutItemViewInfo.SetElementWithMouse(Value: TdxCustomLayoutItemElementViewInfo);
begin
  if FElementWithMouse <> Value then
  begin
    if FElementWithMouse <> nil then
      FElementWithMouse.MouseLeave;
    FElementWithMouse := Value;
    if FElementWithMouse <> nil then
      FElementWithMouse.MouseEnter;
  end;
end;

procedure TdxCustomLayoutItemViewInfo.SetHasMouse(Value: Boolean);
begin
  if HasMouse <> Value then
    if Value then
      ContainerViewInfo.ItemWithMouse := Item
    else
      ContainerViewInfo.ItemWithMouse := nil;
end;

procedure TdxCustomLayoutItemViewInfo.SetOffset(ASide: TdxLayoutSide; Value: Integer);
begin
  FOffsets[ASide] := Value;
end;

function TdxCustomLayoutItemViewInfo.CreateHitTest(AHitTestClass: TdxCustomLayoutItemHitTestClass; const P: TPoint): TdxCustomLayoutItemHitTest;
begin
  Result := AHitTestClass.Instance as TdxCustomLayoutItemHitTest;
  Result.Item := Item;
  Result.ViewInfo := Self;
  Result.Pos := P;
end;

{
procedure TdxCustomLayoutItemViewInfo.ItemChanged(AType: TdxLayoutItemChangeType);
begin
  if AType = ictHard then
  begin
    Item := nil;
    ContainerViewInfo.FIsValid := False;
  end;
end;
}

procedure TdxCustomLayoutItemViewInfo.PopulateAutoAlignControlList(AList: TList);
begin
// do nothing
end;

procedure TdxCustomLayoutItemViewInfo.PopulateControlViewInfoList(AControls, AWinControls: TList);
begin
// do nothing
end;

function TdxCustomLayoutItemViewInfo.GetIsCustomization: Boolean;
begin
  Result := Item.Container.IsCustomization;
end;

function TdxCustomLayoutItemViewInfo.UseRightToLeftAlignment: Boolean;
begin
  Result := Item.Container.UseRightToLeftAlignment;
end;

function TdxCustomLayoutItemViewInfo.AutoAlignControls: Boolean;
begin
  Result := False;
end;

procedure TdxCustomLayoutItemViewInfo.FreeNotification(AComponent: TComponent);
begin
  HasMouse := False;
end;

procedure TdxCustomLayoutItemViewInfo.CreateViewInfos;
begin
  FCaptionViewInfo := GetCaptionViewInfoClass.Create(Self);
end;

procedure TdxCustomLayoutItemViewInfo.DestroyViewInfos;
begin
  FreeAndNil(FCaptionViewInfo);
end;

procedure TdxCustomLayoutItemViewInfo.GetElements(AElements: TList);
begin
  AElements.Add(FCaptionViewInfo);
end;

procedure TdxCustomLayoutItemViewInfo.MakeVisible(const ARect: TRect; AFully: Boolean);
var
  AParentViewInfo: TdxLayoutGroupViewInfo;
begin
  if Item.IsRoot then
    ContainerViewInfo.MakeVisible(ARect, AFully)
  else
  begin
    AParentViewInfo := ParentViewInfo;
    AParentViewInfo.ViewData.ItemIndex := Item.Index;
    AParentViewInfo.MakeVisible(ARect, AFully);
  end;
end;

procedure TdxCustomLayoutItemViewInfo.MakeFullyVisible;
begin
  MakeVisible(Bounds, True);
end;

function TdxCustomLayoutItemViewInfo.CanDrawBackground: Boolean;
begin
  Result := IsTransparentBackground;
end;

function TdxCustomLayoutItemViewInfo.GetBackgroundColor: TColor;
begin
  if IsDragImagePainting then
    Result := TdxLayoutDragAndDropState.GetDragImageBackgroundColor(Self)
  else
    Result := Color;
end;

function TdxCustomLayoutItemViewInfo.GetPainter: TdxCustomLayoutItemPainter;
begin
  if FPainter = nil then
    FPainter := GetPainterClass.Create(Self);
  Result := FPainter;
end;

function TdxCustomLayoutItemViewInfo.InternalCalculateHeight: Integer;
begin
  if Item.Height <> 0 then
    Result := Max(Item.Height + OffsetsHeight, DoCalculateHeight(cstMin))
  else
  begin
    Result := DoCalculateHeight(cstOriginal);
  end;
  if Item.SizeOptions.MaxHeight > 0 then
    Result := Min(Result, Item.SizeOptions.MaxHeight);
end;

function TdxCustomLayoutItemViewInfo.InternalCalculateWidth: Integer;
begin
  if Item.Width <> 0 then
    Result := Max(Item.Width + OffsetsWidth, DoCalculateWidth(cstMin))
  else
  begin
    Result := DoCalculateWidth(cstOriginal);
  end;
  FIsMaxWidth := FIsMaxWidth or (Item.SizeOptions.MaxWidth > 0) and (Result >= Item.SizeOptions.MaxWidth);
  if FIsMaxWidth then
    Result := Item.SizeOptions.MaxWidth;
end;

function TdxCustomLayoutItemViewInfo.CalculateOffset(ASide: TdxLayoutSide): Integer;
begin
  case ASide of
    sdLeft:
      Result := Item.Offsets.Left;
    sdRight:
      Result := Item.Offsets.Right;
    sdTop:
      Result := Item.Offsets.Top;
    sdBottom:
      Result := Item.Offsets.Bottom;
  else
    Result := 0;
  end;
end;

function TdxCustomLayoutItemViewInfo.GetDropAreaPart(var P: TPoint): TdxLayoutDropAreaPart;
const
  Parts: array[Boolean, Boolean] of TdxLayoutDropAreaPart = ((apBottom, apRight), (apLeft, apTop));

  function GetSign(const P1, P2, P: TPoint): Integer;
  begin
    Result := (P.X - P1.X) * (P2.Y - P1.Y) - (P.Y - P1.Y) * (P2.X - P1.X);
  end;

  procedure CorrectDropAreaPart(var AAreaPart: TdxLayoutDropAreaPart);
  begin
    TdxLayoutDragAndDropState.CorrectDropAreaPart(Item, Result);
    if ParentViewInfo <> nil then
      ParentViewInfo.CorrectDropAreaPart(P, Result);
  end;

var
  ASign1, ASign2: Integer;
begin
  with Bounds do
  begin
    ASign1 := GetSign(Point(Left, Bottom), Point(Right, Top), P);
    ASign2 := GetSign(TopLeft, BottomRight, P);
  end;
  Result := Parts[ASign1 >= 0, ASign2 >= 0];

  CorrectDropAreaPart(Result);
end;

function TdxCustomLayoutItemViewInfo.GetActuallyVisible: Boolean;
begin
  Result := ContainerViewInfo.IsActuallyVisible and Item.GetVisible and
    (Item.IsRoot or (FParentViewInfo <> nil) and FParentViewInfo.IsChildActuallyVisible(Self)) and IsParentExpanded;
end;

function TdxCustomLayoutItemViewInfo.GetContentBounds: TRect;
begin
  Result := cxRectContent(Bounds, Padding);
end;

function TdxCustomLayoutItemViewInfo.DoCalculateHeight(ACalcSizeType: TdxLayoutCalcSizeType): Integer;
begin
  Result := OffsetsHeight;
end;

function TdxCustomLayoutItemViewInfo.DoCalculateWidth(ACalcSizeType: TdxLayoutCalcSizeType): Integer;
begin
  Result := OffsetsWidth;
end;

function TdxCustomLayoutItemViewInfo.GetAvailableTextAreaWidth: Integer;
begin
  Result := Max(0, OriginalBounds.Width - OffsetsWidth - GetAvailableTextAreaWidthCorrection);
end;

function TdxCustomLayoutItemViewInfo.GetAvailableTextAreaWidthCorrection: Integer;
begin
  Result := 0;
end;

procedure TdxCustomLayoutItemViewInfo.Reset;
begin
  FWidth := 0;
  FHeight := 0;
  FMinWidth := 0;
  FMinHeight := 0;
  FCaptionViewInfo.Reset;
end;

procedure TdxCustomLayoutItemViewInfo.SetItemHeight(AHeight: Integer; ADirectAccess: Boolean);
begin
  Item.Height := AHeight;
end;

procedure TdxCustomLayoutItemViewInfo.SetItemWidth(AWidth: Integer; ADirectAccess: Boolean);
begin
  Item.Width := AWidth;
end;

function TdxCustomLayoutItemViewInfo.GetCursor(X, Y: Integer): TCursor;
var
  I: Integer;
  AElements: TList;
begin
  AElements := TList.Create;
  try
    GetElements(AElements);
    for I := 0 to AElements.Count - 1 do
      if GetElement(AElements, I).WantsMouse(X, Y) then
      begin
        Result := GetElement(AElements, I).GetCursor(X, Y);
        Exit;
      end;
    Result := crDefault;
  finally
    AElements.Free;
  end;
end;

function TdxCustomLayoutItemViewInfo.GetEnabled: Boolean;
begin
  Result := Item.Enabled;
end;

function TdxCustomLayoutItemViewInfo.GetFocusRect(ACanvas: TcxCanvas): TRect;
begin
  Result := cxNullRect;
end;

function TdxCustomLayoutItemViewInfo.GetHitTestBounds: TRect;
begin
  if TdxLayoutDragAndDropState.StateIn([ddsNone, ddsInProcess]) then
    Result := SelectionArea
  else
    Result := GetVisibleBounds;
end;

function TdxCustomLayoutItemViewInfo.GetOptions: TdxCustomLayoutLookAndFeelOptions;
begin
  Result := ContainerViewInfo.GetItemOptions(Self);
end;

function TdxCustomLayoutItemViewInfo.IsTransparent: Boolean;
begin
  Result := False;
end;

function TdxCustomLayoutItemViewInfo.IsTransparentBackground: Boolean;
begin
  Result := (IsDragImagePainting and IsGrabbed) or
   (ParentViewInfo = nil) {IsRoot} and (not IsTransparent or Item.IsDesigning and Item.Container.HighlightRoot) or
    not IsTransparent and (ParentViewInfo <> nil) and (LayoutLookAndFeel <> ParentViewInfo.LayoutLookAndFeel);
end;

function TdxCustomLayoutItemViewInfo.HasCaption: Boolean;
begin
  if FHasCaption = bDefault then
    FHasCaption := TdxDefaultBoolean(Item.HasCaption);
  Result := Boolean(FHasCaption);
end;

function TdxCustomLayoutItemViewInfo.HasBorder: Boolean;
begin
  Result := False;
end;

procedure TdxCustomLayoutItemViewInfo.CustomizationMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  AShift: TShiftState;
begin
  AShift := Shift;
  if not Item.IsDesigning and (ssRight in Shift) and Item.IsSelected and
      ([ssShift, ssCtrl] * Shift = []) then
    Include(AShift, ssShift);
  Item.SelectComponent(AShift);
  if Shift * [ssLeft, ssRight, ssMiddle, ssDouble] = [ssLeft, ssDouble] then
    InplaceRename;
end;

function TdxCustomLayoutItemViewInfo.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean;
begin
  Result := False;
end;

function TdxCustomLayoutItemViewInfo.IsMouseWheelHandleNeeded(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean;
begin
  Result := False;
end;

procedure TdxCustomLayoutItemViewInfo.MouseLeave;
begin
  inherited;
  ElementWithMouse := nil;
end;

procedure TdxCustomLayoutItemViewInfo.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if ElementWithMouse <> nil then
    ElementWithMouse.MouseDown(Button, Shift, X, Y);
end;

procedure TdxCustomLayoutItemViewInfo.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  I: Integer;
  AElements: TList;
begin
  inherited;

  AElements := TList.Create;
  try
    GetElements(AElements);
    for I := 0 to AElements.Count - 1 do
      if GetElement(AElements, I).WantsMouse(X, Y) then
      begin
        ElementWithMouse := GetElement(AElements, I);
        ElementWithMouse.MouseMove(Shift, X, Y);
        Exit;
      end;
    ElementWithMouse := nil;
  finally
    AElements.Free;
  end;
end;

procedure TdxCustomLayoutItemViewInfo.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if ElementWithMouse <> nil then
    ElementWithMouse.MouseUp(Button, Shift, X, Y);
end;

procedure TdxCustomLayoutItemViewInfo.Calculate(const ABounds: TRect);
begin
  inherited;
  SetBounds(cxRectContent(Bounds, Rect(Offsets[sdLeft], Offsets[sdTop], Offsets[sdRight], Offsets[sdBottom])), False);
end;

procedure TdxCustomLayoutItemViewInfo.Recalculate;
begin
  Calculate(OriginalBounds);
  if UseRightToLeftAlignment then
    DoRightToLeftConversion(OriginalBounds);
end;

function TdxCustomLayoutItemViewInfo.CalculateMinHeight: Integer;
begin
  if FMinHeight = 0 then
    FMinHeight := DoCalculateHeight(cstMin);
  Result := FMinHeight;
end;

function TdxCustomLayoutItemViewInfo.CalculateMinWidth: Integer;
begin
  if FMinWidth = 0 then
    FMinWidth := DoCalculateWidth(cstMin);
  Result := FMinWidth;
end;

function TdxCustomLayoutItemViewInfo.CalculateHeight: Integer;
begin
  if ContainerViewInfo.FIsOccupiedSizeCalculating then
    Result := InternalCalculateHeight
  else
  begin
    if FHeight = 0 then
      FHeight := InternalCalculateHeight;
    Result := FHeight;
  end;
end;

function TdxCustomLayoutItemViewInfo.CalculateWidth: Integer;
begin
  if ContainerViewInfo.FIsOccupiedSizeCalculating then
    Result := InternalCalculateWidth
  else
  begin
    if FWidth = 0 then
      FWidth := InternalCalculateWidth;
    Result := FWidth;
  end;
end;

procedure TdxCustomLayoutItemViewInfo.CalculateInternalTabOrders(var AAvailableTabOrder: Integer);
begin
// do nothing
end;

procedure TdxCustomLayoutItemViewInfo.CalculateTabOrders(var AAvailableTabOrder: Integer);
begin
// do nothing
end;

procedure TdxCustomLayoutItemViewInfo.DoRightToLeftConversion(const AClientBounds: TRect);
begin
  inherited DoRightToLeftConversion(AClientBounds);
  FCaptionViewInfo.DoRightToLeftConversion(AClientBounds);
end;

function TdxCustomLayoutItemViewInfo.GetHitTest(const P: TPoint): TdxCustomLayoutHitTest;
var
  AMarkerIndex: Integer;
  ACursor: TCursor;
begin
  Result := nil;
  if IsValid and (not IsParentLocked or Item.IsDesigning) and ActuallyVisible then
  begin
    if IsCustomization and Item.IsSelected then
    begin
      AMarkerIndex := GetMarkerIndex(GetSelectableMarkers, P);
      if AMarkerIndex <> -1 then
      begin
        Result := CreateHitTest(TdxLayoutSizeHitTest, P);
        case AMarkerIndex of
          0, 4: ACursor := crSizeNWSE;
          1, 5: ACursor := crSizeNS;
          2, 6: ACursor := crSizeNESW;
          3, 7: ACursor := crSizeWE;
        else
          ACursor := crSize;
        end;
        TdxLayoutSizeHitTest(Result).Cursor := ACursor;
        Exit;
      end;
    end;
    if PtInRect(GetHitTestBounds, P) then
      Result := CreateHitTest(GetHitTestClass, P)
  end;
end;

function TdxCustomLayoutItemViewInfo.GetItemWithMouse(const P: TPoint): TdxCustomLayoutItem;
begin
  if IsValid and not IsParentLocked and PtInRect(GetVisibleBounds, P) and ActuallyVisible then
    Result := Item
  else
    Result := nil;
end;

procedure TdxCustomLayoutItemViewInfo.ResetOffset(ASide: TdxLayoutSide);
begin
  FOffsets[ASide] := 0;
end;

function TdxLayoutEmptySpaceItemCaptionViewInfo.CanDoCaptionClick(X, Y: Integer): Boolean;
begin
  Result := False;
end;

procedure TdxLayoutEmptySpaceItemCaptionViewInfo.PrepareCanvas(ACanvas: TcxCanvas; AForDrawing: Boolean);
begin
// do nothing
end;

function TdxLayoutEmptySpaceItemCaptionViewInfo.IsHotTrackable: Boolean;
begin
  Result := False;
end;

{ TdxLayoutLabeledItemCaptionViewInfo }

constructor TdxLayoutLabeledItemCaptionViewInfo.Create(AItemViewInfo: TdxCustomLayoutItemViewInfo);
begin
  inherited;
  FWordWrap := Item.CaptionOptions.WordWrap;
end;

function TdxLayoutLabeledItemCaptionViewInfo.GetItem: TdxCustomLayoutLabeledItem;
begin
  Result := TdxCustomLayoutLabeledItem(inherited GetItem);
end;

function TdxLayoutLabeledItemCaptionViewInfo.GetItemViewInfo: TdxLayoutLabeledItemViewInfo;
begin
  Result := TdxLayoutLabeledItemViewInfo(inherited ItemViewInfo);
end;

function TdxLayoutLabeledItemCaptionViewInfo.GetTextSize(ACanvas: TcxCanvas): TSize;
var
  R: TRect;
  AFlags: Integer;
  AIsWidthFixed: Boolean;
begin
  if IsMultiLine or IsEllipsisAllowed then
  begin
    AIsWidthFixed := IsWidthFixed;
    if AIsWidthFixed then
      R := Rect(0, 0, GetTextAreaWidth - GetTextPadding.Width, 1)
    else
      R := Rect(0, 0, Max(1, ItemViewInfo.GetAvailableTextAreaWidth - GetTextPadding.Width), 1);
    if R.Right <> FTextSizeCache.TextAreaWidth then
    begin
      if AIsWidthFixed then
        AFlags := CalculateTextFlags(ACanvas, False)
      else
        AFlags := CalculateTextFlags(ACanvas, False) or cxDontBreakChars;
      FTextSizeCache.TextAreaWidth := R.Right;
      if IsTextFormatted then
        Result := GetFormattedTextSize(ACanvas, AFlags, R)
      else
      begin
        ACanvas.TextExtent(FormattedText.Text, R, AFlags);
        Result := cxRectSize(R);
      end;
      FTextSizeCache.TextSize := Result;
    end
    else
      Result := FTextSizeCache.TextSize;
  end
  else
    Result := inherited GetTextSize(ACanvas);
end;

function TdxLayoutLabeledItemCaptionViewInfo.GetCursor(X, Y: Integer): TCursor;
var
  ACursor: TCursor;
begin
  ACursor := Item.CaptionOptions.Cursor;
  if Item.Container.IsCustomization or (ACursor = crDefault) then
    Result := inherited GetCursor(X, Y)
  else
    Result := ACursor;
end;

function TdxLayoutLabeledItemCaptionViewInfo.IsWidthFixed: Boolean;
begin
  Result := (Item.CaptionOptions.Width <> 0) or ItemViewInfo.FIsMaxWidth;
end;

function TdxLayoutLabeledItemCaptionViewInfo.IsMultiLine: Boolean;
begin
  Result := IsWidthFixed and not IsEllipsisAllowed or ItemViewInfo.IsWordWrapAllowed;
end;

function TdxLayoutLabeledItemCaptionViewInfo.GetSpaceBetweenImageText: Integer;
begin
  if IsNeedSpaceBetweenImageText then
    Result := ItemViewInfo.ElementOffsetHorz
  else
    Result := 0;
end;

function TdxLayoutLabeledItemCaptionViewInfo.GetTextAreaWidth: Integer;
var
  AAvailableTextAreaWidth, AUsedCaptionWidth: Integer;
begin
  if Visible and IsWidthFixed then
    if ItemViewInfo.FIsMaxWidth then
    begin
      AAvailableTextAreaWidth := Item.SizeOptions.MaxWidth - ItemViewInfo.GetAvailableTextAreaWidthCorrection;

      if Item.CaptionOptions.Width > 0 then
        AUsedCaptionWidth := Item.CaptionOptions.Width
      else
        AUsedCaptionWidth := GetOptimalTextPlaceSize.Width;

      Result := Min(AAvailableTextAreaWidth, AUsedCaptionWidth);
    end
    else
      Result := Item.CaptionOptions.Width
  else
    Result := inherited GetTextAreaWidth;
end;

function TdxLayoutLabeledItemCaptionViewInfo.CalculateMinWidth: Integer;
begin
  if Visible then
  begin
      Result := Width; 
  end
  else
    Result := 0;
end;

{ TdxLayoutControlItemCaptionViewInfo }

function TdxLayoutControlItemCaptionViewInfo.GetTextAreaWidth: Integer;
begin
  Result := inherited GetTextAreaWidth;
end;

function TdxLayoutControlItemCaptionViewInfo.GetItem: TdxLayoutControlItem;
begin
  Result := TdxLayoutControlItem(inherited Item);
end;

function TdxLayoutControlItemCaptionViewInfo.GetItemViewInfo: TdxLayoutControlItemViewInfo;
begin
  Result := TdxLayoutControlItemViewInfo(inherited ItemViewInfo);
end;

{ TdxLayoutItemCaptionViewInfo }

function TdxLayoutItemCaptionViewInfo.GetItem: TdxLayoutItem;
begin
  Result := inherited GetItem as TdxLayoutItem;
end;

function TdxLayoutItemCaptionViewInfo.GetItemViewInfo: TdxLayoutItemViewInfo;
begin
  Result := TdxLayoutItemViewInfo(inherited ItemViewInfo);
end;

{ TdxLayoutCellItemCellViewInfo }

function TdxLayoutCellItemCellViewInfo.GetVisible: Boolean;
begin
  Result := TdxLayoutCellItemViewInfo(ItemViewInfo).IsCellVisible;
end;

function TdxLayoutCellItemCellViewInfo.CalculateMinHeight: Integer;
begin
  Result := TdxLayoutCellItemViewInfo(ItemViewInfo).GetCellHeight(cstMin);
end;

function TdxLayoutCellItemCellViewInfo.CalculateMinWidth: Integer;
begin
  Result := TdxLayoutCellItemViewInfo(ItemViewInfo).GetCellWidth(cstMin);
end;

function TdxLayoutCellItemCellViewInfo.CalculateHeight: Integer;
begin
  Result := TdxLayoutCellItemViewInfo(ItemViewInfo).GetCellHeight(cstOriginal);
end;

function TdxLayoutCellItemCellViewInfo.CalculateWidth: Integer;
begin
  Result := TdxLayoutCellItemViewInfo(ItemViewInfo).GetCellWidth(cstOriginal);
end;

{ TdxLayoutItemControlViewInfo }

function TdxLayoutControlItemControlViewInfo.GetBorderColor: TColor;
begin
  Result := ItemViewInfo.Options.GetControlBorderColor;
end;

function TdxLayoutControlItemControlViewInfo.GetBorderStyle: TdxLayoutBorderStyle;
begin
  Result := ItemViewInfo.Options.ControlBorderStyle;
end;

function TdxLayoutControlItemControlViewInfo.GetItem: TdxLayoutControlItem;
begin
  Result := TdxLayoutControlItem(inherited Item);
end;

function TdxLayoutControlItemControlViewInfo.GetItemViewInfo: TdxLayoutControlItemViewInfo;
begin
  Result := TdxLayoutControlItemViewInfo(inherited ItemViewInfo);
end;

function TdxLayoutControlItemControlViewInfo.GetOpaqueControl: Boolean;
begin
  Result := Item.ControlOptions.Opaque;
end;

procedure TdxLayoutControlItemControlViewInfo.DoSetOffset(const AValue, ADiff: TPoint);
begin
  inherited;
  FControlBounds := cxRectOffset(FControlBounds, ADiff);
end;

function TdxLayoutControlItemControlViewInfo.GetVisible: Boolean;
begin
  Result := ItemViewInfo.HasControl and not ItemViewInfo.IsAvailable and
    (not ItemViewInfo.IsDragImagePainting or ItemViewInfo.ActuallyVisible);
end;

procedure TdxLayoutControlItemControlViewInfo.CalculateControlBounds(const AAvailableBounds: TRect);
begin
  if Visible then
  begin
    FControlBounds := AAvailableBounds;
    Inc(FControlBounds.Left, BorderWidths[sdLeft]);
    Dec(FControlBounds.Right, BorderWidths[sdRight]);
    Inc(FControlBounds.Top, BorderWidths[sdTop]);
    Dec(FControlBounds.Bottom, BorderWidths[sdBottom]);

    if Item.ControlAdapter <> nil then
    begin
      FControlWindowRect := ItemViewInfo.GetVisiblePart(FControlBounds);
      Item.ControlAdapter.FNeedSetRegion := not cxRectIsEqual(FControlBounds, FControlWindowRect);
      FControlWindowRect := cxRectOffset(FControlWindowRect, FControlBounds.TopLeft, False);
    end;
  end
  else
  begin
    FControlBounds := cxNullRect;
    FControlWindowRect := cxNullRect;
  end;
end;

function TdxLayoutControlItemControlViewInfo.GetLayoutAlignHorz: TdxLayoutRealAlignHorz;
begin
  Result := Item.ControlOptions.AlignHorz;
end;

function TdxLayoutControlItemControlViewInfo.GetLayoutAlignVert: TdxLayoutRealAlignVert;
begin
  Result := Item.ControlOptions.AlignVert;
end;

procedure TdxLayoutControlItemControlViewInfo.CalculateExactBounds(const AAvailableBounds: TRect);
begin
  inherited;
  CalculateControlBounds(Bounds);
end;

function TdxLayoutControlItemControlViewInfo.GetBorderWidth(ASide: TdxLayoutSide): Integer;
begin
  if HasBorder then
    Result := LayoutLookAndFeel.ItemControlBorderWidths[ASide]
  else
    Result := 0
end;

function TdxLayoutControlItemControlViewInfo.GetControlAreaHeight(AControlHeight: Integer): Integer;
begin
  Result := BorderWidths[sdTop] + AControlHeight + BorderWidths[sdBottom];
end;

function TdxLayoutControlItemControlViewInfo.GetControlAreaWidth(AControlWidth: Integer): Integer;
begin
  Result := BorderWidths[sdLeft] + AControlWidth + BorderWidths[sdRight];
end;

function TdxLayoutControlItemControlViewInfo.GetOriginalControlSize: TSize;
begin
  with Item.OriginalControlSize do
    Result := cxSize(X, Y);
end;

function TdxLayoutControlItemControlViewInfo.HasBorder: Boolean;
begin
  Result := Item.ControlOptions.ShowBorder and not ItemViewInfo.IsAvailable;
end;

procedure TdxLayoutControlItemControlViewInfo.CalculateInternalTabOrder(var AAvailableTabOrder: Integer);
begin
// do nothing
end;

procedure TdxLayoutControlItemControlViewInfo.CalculateTabOrder(var AAvailableTabOrder: Integer);
begin
// do nothing
end;

function TdxLayoutControlItemControlViewInfo.CalculateMinHeight: Integer;
begin
  if Item.ControlOptions.IsHeightUsual then
    Result := CalculateHeight
  else
    if Visible then
      Result := GetControlAreaHeight(Item.ControlOptions.MinHeight)
    else
      Result := 0;
end;

function TdxLayoutControlItemControlViewInfo.CalculateMinWidth: Integer;
begin
  if Item.ControlOptions.IsWidthUsual then
    Result := CalculateWidth
  else
    if Visible then
      Result := GetControlAreaWidth(Item.ControlOptions.MinWidth)
    else
      Result := 0;
end;

function TdxLayoutControlItemControlViewInfo.CalculateHeight: Integer;
begin
  if Visible then
    Result := GetControlAreaHeight(GetOriginalControlSize.Height)
  else
    Result := 0;
end;

function TdxLayoutControlItemControlViewInfo.CalculateWidth: Integer;
begin
  if Visible then
    Result := GetControlAreaWidth(GetOriginalControlSize.Width)
  else
    Result := 0;
end;

procedure TdxLayoutControlItemControlViewInfo.DoRightToLeftConversion(const AClientBounds: TRect);
begin
  inherited DoRightToLeftConversion(AClientBounds);
  CalculateControlBounds(Bounds);
end;

{ TdxLayoutItemControlViewInfo }

procedure TdxLayoutItemControlViewInfo.CalculateTabOrder(var AAvailableTabOrder: Integer);
begin
  if Item.HasWinControl then
  begin
    Item.WinControl.TabOrder := AAvailableTabOrder;
    Inc(AAvailableTabOrder);
  end;
end;

function TdxLayoutItemControlViewInfo.GetControl: TControl;
begin
  Result := Item.Control;
end;

function TdxLayoutItemControlViewInfo.GetItem: TdxLayoutItem;
begin
  Result := TdxLayoutItem(inherited Item);
end;

{ TdxLayoutBasicItemViewInfo }

function TdxLayoutBasicItemViewInfo.GetCaptionViewInfoClass: TdxCustomLayoutItemCaptionViewInfoClass;
begin
  Result := TdxLayoutBasicItemCaptionViewInfo;
end;

function TdxLayoutBasicItemViewInfo.GetHitTestClass: TdxCustomLayoutItemHitTestClass;
begin
  Result := TdxLayoutBasicItemHitTest;
end;

function TdxLayoutBasicItemViewInfo.GetPainterClass: TdxCustomLayoutItemPainterClass;
begin
  Result := TdxCustomLayoutItemPainterClass(LayoutLookAndFeel.GetBasicItemPainterClass);
end;

function TdxLayoutBasicItemViewInfo.GetColor: TColor;
begin
  if ParentViewInfo <> nil then // for dragging
    Result := ParentViewInfo.GetColor
  else
    Result := ContainerViewInfo.ItemsViewInfo.GetColor;
end;

function TdxLayoutBasicItemViewInfo.IsTransparent: Boolean;
begin
  Result := True;
end;

{ TdxLayoutEmptySpaceItemViewInfo }

procedure TdxLayoutEmptySpaceItemViewInfo.Calculate(const ABounds: TRect);
begin
  inherited;
  if IsDragged then
    CaptionViewInfo.Calculate(ABounds);
end;

function TdxLayoutEmptySpaceItemViewInfo.GetCaptionViewInfoClass: TdxCustomLayoutItemCaptionViewInfoClass;
begin
  Result := TdxLayoutEmptySpaceItemCaptionViewInfo;
end;

function TdxLayoutEmptySpaceItemViewInfo.GetPainterClass: TdxCustomLayoutItemPainterClass;
begin
  Result := TdxCustomLayoutItemPainterClass(LayoutLookAndFeel.GetEmptySpaceItemPainterClass);
end;

function TdxLayoutEmptySpaceItemViewInfo.DoCalculateHeight(ACalcSizeType: TdxLayoutCalcSizeType): Integer;
begin
  if IsDragged and HasCaption then
    Result := CaptionViewInfo.GetTextPlaceSize.Height
  else
    Result := inherited DoCalculateHeight(ACalcSizeType) + dxLayoutEmptySpaceMinimumSize;
end;

function TdxLayoutEmptySpaceItemViewInfo.DoCalculateWidth(ACalcSizeType: TdxLayoutCalcSizeType): Integer;
begin
  if IsDragged and HasCaption then
    Result := CaptionViewInfo.GetTextPlaceSize.Width
  else
    Result := inherited DoCalculateWidth(ACalcSizeType) + dxLayoutEmptySpaceMinimumSize;
end;

{ TdxLayoutDirectionalItemViewInfo }

procedure TdxLayoutDirectionalItemViewInfo.Calculate(const ABounds: TRect);
begin
  inherited;
  if IsDragged and Item.IsAvailable then
    CaptionViewInfo.Calculate(ABounds);
end;

function TdxLayoutDirectionalItemViewInfo.DoCalculateHeight(ACalcSizeType: TdxLayoutCalcSizeType): Integer;
begin
  if IsDragged and HasCaption then
    Result := CaptionViewInfo.GetTextPlaceSize.Height
  else
    Result := inherited DoCalculateHeight(ACalcSizeType) + GetItemMinHeight;
end;

function TdxLayoutDirectionalItemViewInfo.DoCalculateWidth(ACalcSizeType: TdxLayoutCalcSizeType): Integer;
begin
  if IsDragged and HasCaption then
    Result := CaptionViewInfo.GetTextPlaceSize.Width
  else
    Result := inherited DoCalculateWidth(ACalcSizeType) + GetItemMinWidth;
end;

function TdxLayoutDirectionalItemViewInfo.GetItemMinHeight: Integer;
begin
  Result := 0;
end;

function TdxLayoutDirectionalItemViewInfo.GetItemMinWidth: Integer;
begin
  Result := 0;
end;

function TdxLayoutDirectionalItemViewInfo.GetItem: TdxLayoutDirectionalItem;
begin
  Result := TdxLayoutDirectionalItem(inherited Item);
end;

{ TdxLayoutSeparatorItemCaptionViewInfo }

function TdxLayoutSeparatorItemCaptionViewInfo.CalculateHeight: Integer;
begin
  if IsVerticalCaption then
    Result := inherited CalculateWidth
  else
    Result := inherited CalculateHeight;
end;

function TdxLayoutSeparatorItemCaptionViewInfo.CalculateWidth: Integer;
begin
  if IsVerticalCaption then
    Result := inherited CalculateHeight
  else
    Result := inherited CalculateWidth;
end;

function TdxLayoutSeparatorItemCaptionViewInfo.GetTextAlignHorz: TAlignment;
begin
  if not TdxLayoutSeparatorItemViewInfo(ItemViewInfo).IsVertical then
    Result := inherited
  else
    Result := taCenter;
end;

function TdxLayoutSeparatorItemCaptionViewInfo.GetTextAlignVert: TdxAlignmentVert;
begin
  if TdxLayoutSeparatorItemViewInfo(ItemViewInfo).IsVertical then
    Result := inherited
  else
    Result := tavCenter;
end;

function TdxLayoutSeparatorItemCaptionViewInfo.GetRotationAngle: TcxRotationAngle;
begin
  if TdxLayoutSeparatorItemViewInfo(ItemViewInfo).IsVertical then
    Result := raPlus90
  else
    Result := ra0;
end;

procedure TdxLayoutSeparatorItemCaptionViewInfo.CalculateImageTextAreaBounds;
var
  AContentBounds: TRect;
  ATextSize: TSize;
  AImageAreaWidth, AImageAreaHeight, ATextAreaWidth, ATextAreaHeight: Integer;
  AHeaderWidth, AHeaderHeight: Integer;
begin
  if IsVerticalCaption then
  begin
    AContentBounds := cxRectContent(Bounds, GetContentOffsets);

    AImageAreaWidth := GetImageHeight;
    AImageAreaHeight := GetImageWidth;
    ATextSize := GetTextPlaceSize;
    ATextAreaHeight := ATextSize.Width;
    ATextAreaWidth := ATextSize.Height;
    AHeaderHeight := AImageAreaHeight + GetSpaceBetweenImageText + ATextAreaHeight;

    // AlignHorz ignored
    FImageAreaBounds.Left := AContentBounds.Left + (AContentBounds.Width - AImageAreaWidth) div 2;
    FImageAreaBounds.Right := FImageAreaBounds.Left + AImageAreaWidth;
    FTextAreaBounds.Left := AContentBounds.Left + (AContentBounds.Width - ATextAreaWidth) div 2;
    FTextAreaBounds.Right := FTextAreaBounds.Left + ATextAreaWidth;

    case AlignVert of
      tavTop:
        FImageAreaBounds.Bottom := AContentBounds.Top + AHeaderHeight;
      tavBottom:
        FImageAreaBounds.Bottom := AContentBounds.Bottom;
      tavCenter:
        FImageAreaBounds.Bottom := AContentBounds.Bottom - (AContentBounds.Height - AHeaderHeight) div 2;
    end;
    FImageAreaBounds.Top := FImageAreaBounds.Bottom - AImageAreaHeight;
    FTextAreaBounds.Bottom := FImageAreaBounds.Top - GetSpaceBetweenImageText;
    FTextAreaBounds.Top := FTextAreaBounds.Bottom - ATextAreaHeight;
  end
  else
  begin
    AContentBounds := cxRectContent(Bounds, GetContentOffsets);

    AImageAreaWidth := GetImageWidth;
    AImageAreaHeight := GetImageHeight;
    ATextSize := GetTextPlaceSize;
    ATextAreaHeight := ATextSize.Height;
    ATextAreaWidth := ATextSize.Width;
    AHeaderWidth := AImageAreaWidth + GetSpaceBetweenImageText + ATextAreaWidth;

    case AlignHorz of
      taLeftJustify:
        begin
          FImageAreaBounds.Left := AContentBounds.Left;
          FImageAreaBounds.Right := FImageAreaBounds.Left + AImageAreaWidth;
          FTextAreaBounds.Left := FImageAreaBounds.Right + GetSpaceBetweenImageText;
          FTextAreaBounds.Right := FTextAreaBounds.Left + ATextAreaWidth;
        end;
      taRightJustify:
        begin
          FImageAreaBounds.Right := AContentBounds.Right;
          FImageAreaBounds.Left := FImageAreaBounds.Right - AImageAreaWidth;
          FTextAreaBounds.Right := FImageAreaBounds.Left - GetSpaceBetweenImageText;
          FTextAreaBounds.Left := FTextAreaBounds.Right - ATextAreaWidth;
        end;
      taCenter:
        begin
          FImageAreaBounds.Left := AContentBounds.Left + (AContentBounds.Width - AHeaderWidth) div 2;
          FImageAreaBounds.Right := FImageAreaBounds.Left + AImageAreaWidth;
          FTextAreaBounds.Left := FImageAreaBounds.Right + GetSpaceBetweenImageText;
          FTextAreaBounds.Right := FTextAreaBounds.Left + ATextSize.Width;
        end;
    end;

    // AlignVert ignored
    FImageAreaBounds.Top := AContentBounds.Top + (AContentBounds.Height - AImageAreaHeight) div 2;
    FImageAreaBounds.Bottom := FImageAreaBounds.Top + AImageAreaHeight;
    FTextAreaBounds.Top := AContentBounds.Top + (AContentBounds.Height - ATextAreaHeight) div 2;
    FTextAreaBounds.Bottom := FTextAreaBounds.Top + ATextAreaHeight;
  end;
end;

function TdxLayoutSeparatorItemCaptionViewInfo.IsVerticalCaption: Boolean;
begin
  Result := GetRotationAngle = raPlus90;
end;

{ TdxLayoutSeparatorItemViewInfo }

procedure TdxLayoutSeparatorItemViewInfo.CalculateViewInfoAreaBounds;
var
  ACaptionSize: TSize;
  ACaptionVisible: Boolean;
  ASeparatorBounds: TRect;
begin
  InitViewInfoBounds(CaptionViewInfo, FCaptionAreaBounds, ACaptionSize, ACaptionVisible);
  ASeparatorBounds := ContentBounds;
  if ACaptionVisible then
    if IsVertical then
      case Separator.CaptionOptions.AlignVert of
        tavTop:
          begin
            FCaptionAreaBounds.Bottom := CaptionAreaBounds.Top + ACaptionSize.Height;
            ASeparatorBounds.Top := CaptionAreaBounds.Bottom + 1;
          end;
        tavBottom:
          begin
            FCaptionAreaBounds.Top := CaptionAreaBounds.Bottom - ACaptionSize.Height;
            ASeparatorBounds.Bottom := CaptionAreaBounds.Top - 1;
          end;
        tavCenter:
          FCaptionAreaBounds := cxRectCenterVertically(CaptionAreaBounds, ACaptionSize.Height);
      end
    else
      case Separator.CaptionOptions.AlignHorz of
        taLeftJustify:
          begin
            FCaptionAreaBounds.Right := CaptionAreaBounds.Left + ACaptionSize.Width;
            ASeparatorBounds.Left := CaptionAreaBounds.Right + 1;
          end;
        taRightJustify:
          begin
            FCaptionAreaBounds.Left := CaptionAreaBounds.Right - ACaptionSize.Width;
            ASeparatorBounds.Right := CaptionAreaBounds.Left - 1;
          end;
        taCenter:
          FCaptionAreaBounds := cxRectCenterHorizontally(CaptionAreaBounds, ACaptionSize.Width);
      end;
  FCellAreaBounds := ASeparatorBounds;
end;

procedure TdxLayoutSeparatorItemViewInfo.CalculateViewInfoExactBounds;
begin
  CaptionViewInfo.Calculate(CaptionAreaBounds);
end;

function TdxLayoutSeparatorItemViewInfo.GetCaptionViewInfoClass: TdxCustomLayoutItemCaptionViewInfoClass;
begin
  Result := TdxLayoutSeparatorItemCaptionViewInfo;
end;

function TdxLayoutSeparatorItemViewInfo.GetCellHeight(ACalcSizeType: TdxLayoutCalcSizeType): Integer;
begin
  Result := LayoutLookAndFeel.GetSeparatorItemMinWidth;
end;

function TdxLayoutSeparatorItemViewInfo.GetCellWidth(ACalcSizeType: TdxLayoutCalcSizeType): Integer;
begin
  Result := LayoutLookAndFeel.GetSeparatorItemMinWidth;
end;

function TdxLayoutSeparatorItemViewInfo.GetContentHeight(ACalcSizeType: TdxLayoutCalcSizeType): Integer;
var
  ACellHeight, ATextHeight: Integer;
begin
  ATextHeight := GetTextHeight(ACalcSizeType);
  ACellHeight := GetCellHeight(ACalcSizeType);

  Result := Max(ATextHeight + Padding.Top + Padding.Bottom, ACellHeight); 
end;

function TdxLayoutSeparatorItemViewInfo.GetContentWidth(ACalcSizeType: TdxLayoutCalcSizeType): Integer;
var
  ACellWidth, ATextWidth: Integer;
begin
  ATextWidth := GetTextWidth(ACalcSizeType);
  ACellWidth := GetCellWidth(ACalcSizeType);

  Result := Max(ATextWidth + Padding.Left + Padding.Right, ACellWidth);  
end;

function TdxLayoutSeparatorItemViewInfo.GetPainterClass: TdxCustomLayoutItemPainterClass;
begin
  Result := TdxCustomLayoutItemPainterClass(LayoutLookAndFeel.GetSeparatorItemPainterClass);
end;

function TdxLayoutSeparatorItemViewInfo.GetSeparator: TdxLayoutSeparatorItem;
begin
  Result := TdxLayoutSeparatorItem(Item);
end;

function TdxLayoutSplitterItemViewInfo.GetHitTestBounds: TRect;
const
  MinHitTestSize = 3;
begin
  Result := inherited GetHitTestBounds;
  if IsVertical then
  begin
    if Result.Width < MinHitTestSize then
      InflateRect(Result, 1, 0);
  end
  else
    if Result.Height < MinHitTestSize then
      InflateRect(Result, 0, 1);
end;

function TdxLayoutSplitterItemViewInfo.GetHitTestClass: TdxCustomLayoutItemHitTestClass;
begin
  if not IsCustomization then
    Result := TdxLayoutSplitterHitTest
  else
    Result := inherited GetHitTestClass;
end;

function TdxLayoutSplitterItemViewInfo.GetPainterClass: TdxCustomLayoutItemPainterClass;
begin
  Result := TdxCustomLayoutItemPainterClass(LayoutLookAndFeel.GetSplitterItemPainterClass);
end;

function TdxLayoutSplitterItemViewInfo.GetItemMinHeight: Integer;
var
  ASize: TSize;
begin
  ASize := LayoutLookAndFeel.GetSplitterItemMinSize;
  Result := IfThen(IsVertical, ASize.Width, ASize.Height);
end;

function TdxLayoutSplitterItemViewInfo.GetItemMinWidth: Integer;
var
  ASize: TSize;
begin
  ASize := LayoutLookAndFeel.GetSplitterItemMinSize;
  Result := IfThen(IsVertical, ASize.Height, ASize.Width);
end;

procedure TdxLayoutSplitterItemViewInfo.StateChanged;
begin
  inherited;
  Invalidate(OriginalBounds);
end;

procedure TdxLayoutSplitterItemViewInfo.MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
var
  APressed: Boolean;
begin
  if Splitter.AllowCloseOnClick and (Button = mbLeft) then
  begin
    APressed := levsPressed in State;
    inherited;
    if APressed then
      Splitter.IsClosed := not Splitter.IsClosed;
  end
  else
    inherited;
end;

function TdxLayoutSplitterItemViewInfo.IsHotTrackable: Boolean;
begin
  Result := True;
end;

function TdxLayoutSplitterItemViewInfo.GetSplitter: TdxLayoutSplitterItem;
begin
  Result := TdxLayoutSplitterItem(inherited Item);
end;

{ TdxLayoutLabeledItemViewInfo }

procedure TdxLayoutLabeledItemViewInfo.Calculate(const ABounds: TRect);
begin
  inherited;
  CalculateViewInfoAreaBounds;
  CalculateViewInfoExactBounds;
end;

function TdxLayoutLabeledItemViewInfo.GetCaptionLayout: TdxCaptionLayout;
begin
  Result := Item.CaptionOptions.Layout;
end;

function TdxLayoutLabeledItemViewInfo.GetCaptionViewInfoClass: TdxCustomLayoutItemCaptionViewInfoClass;
begin
  Result := TdxLayoutLabeledItemCaptionViewInfo;
end;

function TdxLayoutLabeledItemViewInfo.GetPainterClass: TdxCustomLayoutItemPainterClass;
begin
  Result := TdxCustomLayoutItemPainterClass(LayoutLookAndFeel.GetLabeledItemPainterClass);
end;

procedure TdxLayoutLabeledItemViewInfo.InitViewInfoBounds(AElementViewInfo: TdxCustomLayoutItemElementViewInfo;
  out ABounds: TRect; out ASize: TSize; out AVisible: Boolean);

  procedure CalculateElementViewInfoSize(AElementViewInfo: TdxCustomLayoutItemElementViewInfo;
    out ASize: TSize; out AVisible: Boolean);
  begin
    AVisible := AElementViewInfo.Visible;
    if AVisible then
      ASize := cxSize(AElementViewInfo.Width, AElementViewInfo.Height)
    else
      ASize := cxNullSize;
  end;

begin
  CalculateElementViewInfoSize(AElementViewInfo, ASize, AVisible);
  if AVisible then
    ABounds := ContentBounds
  else
    SetRectEmpty(ABounds);
end;

procedure TdxLayoutLabeledItemViewInfo.CalculateViewInfoAreaBounds;
begin
  CalculateCaptionAreaBounds;
end;

procedure TdxLayoutLabeledItemViewInfo.CalculateViewInfoExactBounds;
begin
  CaptionViewInfo.CalculateExactBounds(CaptionAreaBounds);
end;

procedure TdxLayoutLabeledItemViewInfo.CalculateCaptionAreaBounds;
var
  ACaptionSize: TSize;
  ACaptionVisible: Boolean;
begin
  InitViewInfoBounds(CaptionViewInfo, FCaptionAreaBounds, ACaptionSize, ACaptionVisible);
end;

function TdxLayoutLabeledItemViewInfo.IsWordWrapAllowed: Boolean;
begin
  Result := CaptionViewInfo.WordWrap and (IsWidthLimited and not Item.Parent.CanWrapItems or (CaptionViewInfo.TextLayout in [clTop, clBottom]));
end;

function TdxLayoutLabeledItemViewInfo.CalculatePadding: TRect;
begin
  Result := Item.Padding.GetValues;
end;

function TdxLayoutLabeledItemViewInfo.GetAvailableTextAreaWidthCorrection: Integer;
begin
  Result := inherited GetAvailableTextAreaWidthCorrection + CaptionViewInfo.ImageWidth + CaptionViewInfo.GetSpaceBetweenImageText;
end;

function TdxLayoutLabeledItemViewInfo.GetContentHeight(ACalcSizeType: TdxLayoutCalcSizeType): Integer;
begin
  Result := CaptionViewInfo.Height + Padding.Top + Padding.Bottom;
end;

function TdxLayoutLabeledItemViewInfo.GetContentWidth(ACalcSizeType: TdxLayoutCalcSizeType): Integer;
begin
  if ACalcSizeType = cstMin then
    Result := CaptionViewInfo.CalculateMinWidth
  else
    Result := CaptionViewInfo.CalculateWidth; 
  Result := Result + Padding.Left + Padding.Right;
end;

function TdxLayoutLabeledItemViewInfo.DoCalculateHeight(ACalcSizeType: TdxLayoutCalcSizeType): Integer;
begin
  Result := inherited DoCalculateHeight(ACalcSizeType) + GetContentHeight(ACalcSizeType);
end;

function TdxLayoutLabeledItemViewInfo.DoCalculateWidth(ACalcSizeType: TdxLayoutCalcSizeType): Integer;
begin
  Result := inherited DoCalculateWidth(ACalcSizeType) + GetContentWidth(ACalcSizeType);
end;

procedure TdxLayoutLabeledItemViewInfo.DoAssignBounds(ASource: TdxCustomLayoutElementViewInfo);
begin
  inherited;
  FCaptionAreaBounds := TdxLayoutLabeledItemViewInfo(ASource).FCaptionAreaBounds;
end;

procedure TdxLayoutLabeledItemViewInfo.DoRightToLeftConversion(const AClientBounds: TRect);
begin
  inherited;
  FCaptionAreaBounds := TdxRightToLeftLayoutConverter.ConvertRect(FCaptionAreaBounds, AClientBounds);
end;

procedure TdxLayoutLabeledItemViewInfo.DoSetOffset(const AValue, ADiff: TPoint);
begin
  inherited;
  FCaptionAreaBounds := cxRectOffset(FCaptionAreaBounds, ADiff);
end;

function TdxLayoutLabeledItemViewInfo.GetElementOffsetHorz: Integer;
begin
  Result := LayoutLookAndFeel.GetElementOffsetHorz(Item.Container);
end;

function TdxLayoutLabeledItemViewInfo.GetElementOffsetVert: Integer;
begin
  Result := LayoutLookAndFeel.GetElementOffsetVert(Item.Container);
end;

{ TdxLayoutCellItemViewInfo }

procedure TdxLayoutCellItemViewInfo.CalculateViewInfoAreaBounds;
begin
  inherited CalculateViewInfoAreaBounds;
  CalculateCellAreaBounds;

  if CaptionViewInfo.Visible and IsCellVisible then
  begin
    if (CaptionLayout = clLeft) and (GetCellAlignHorz = ahRight) then  
    begin
      FCellAreaBounds.Left := FCellAreaBounds.Right - GetStandardCellWidth;
      FCaptionAreaBounds.Right := FCellAreaBounds.Left - ElementOffsetHorz;
    end
    else
      if (CaptionLayout = clRight) and (GetCellAlignHorz = ahLeft) then 
      begin
        FCellAreaBounds.Right := FCellAreaBounds.Left + GetStandardCellWidth;
        FCaptionAreaBounds.Left := FCellAreaBounds.Right + ElementOffsetHorz;
      end
      else 
        case CaptionLayout of
          clLeft:
            begin
              FCaptionAreaBounds.Right := CaptionAreaBounds.Left + CaptionViewInfo.Width;
              FCellAreaBounds.Left := CaptionAreaBounds.Right + ElementOffsetHorz;
            end;
          clRight:
            begin
              FCaptionAreaBounds.Left := CaptionAreaBounds.Right - CaptionViewInfo.Width;
              FCellAreaBounds.Right := CaptionAreaBounds.Left - ElementOffsetHorz;
            end;
          clTop:
            begin
              FCaptionAreaBounds.Bottom := CaptionAreaBounds.Top + CaptionViewInfo.Height;
              FCellAreaBounds.Top := CaptionAreaBounds.Bottom + ElementOffsetVert;
            end;
          clBottom:
            begin
              FCaptionAreaBounds.Top := CaptionAreaBounds.Bottom - CaptionViewInfo.Height;
              FCellAreaBounds.Bottom := CaptionAreaBounds.Top - ElementOffsetVert;
            end;
        end;
  end;
end;

procedure TdxLayoutCellItemViewInfo.CalculateViewInfoExactBounds;
begin
  inherited CalculateViewInfoExactBounds;
  CellViewInfo.CalculateExactBounds(cxRectContent(CellAreaBounds, GetCellOffset));
end;

procedure TdxLayoutCellItemViewInfo.CreateViewInfos;
begin
  inherited;
  FCellViewInfo := GetCellViewInfoClass.Create(Self);
end;

procedure TdxLayoutCellItemViewInfo.DestroyViewInfos;
begin
  FreeAndNil(FCellViewInfo);
  inherited;
end;

procedure TdxLayoutCellItemViewInfo.DoAssignBounds(ASource: TdxCustomLayoutElementViewInfo);
begin
  inherited;
  FCellAreaBounds := TdxLayoutCellItemViewInfo(ASource).CellAreaBounds;
end;

procedure TdxLayoutCellItemViewInfo.DoRightToLeftConversion(const AClientBounds: TRect);
begin
  inherited;
  FCellAreaBounds := TdxRightToLeftLayoutConverter.ConvertRect(CellAreaBounds, AClientBounds);
  CellViewInfo.DoRightToLeftConversion(AClientBounds);
end;

procedure TdxLayoutCellItemViewInfo.DoSetOffset(const AValue, ADiff: TPoint);
begin
  inherited;
  FCellAreaBounds := cxRectOffset(CellAreaBounds, ADiff);
end;

function TdxLayoutCellItemViewInfo.GetAvailableTextAreaWidthCorrection: Integer;
begin
  Result := inherited GetAvailableTextAreaWidthCorrection;
  if Item.CaptionOptions.Layout in [clLeft, clRight] then
    Result := Result + ElementOffsetHorz + GetStandardCellWidth;
end;

function TdxLayoutCellItemViewInfo.GetContentHeight(ACalcSizeType: TdxLayoutCalcSizeType): Integer;
var
  ACellHeight, ATextHeight: Integer;
begin
  ATextHeight := GetTextHeight(ACalcSizeType);
  ACellHeight := GetCellHeight(ACalcSizeType) + cxMarginsHeight(GetCellOffset);

  case CaptionLayout of
    clLeft, clRight:
      Result := Max(ATextHeight, ACellHeight);
    clTop, clBottom:
      if (ATextHeight > 0) and (ACellHeight > 0) then
        Result := ATextHeight + ElementOffsetVert + ACellHeight
      else
        Result := ATextHeight + ACellHeight;
  else
    Result := 0;
  end;
  Result := Result + Padding.Top + Padding.Bottom;
end;

function TdxLayoutCellItemViewInfo.GetContentWidth(ACalcSizeType: TdxLayoutCalcSizeType): Integer;
var
  ACellWidth, ATextWidth: Integer;
begin
  ATextWidth := GetTextWidth(ACalcSizeType);
  ACellWidth := GetCellWidth(ACalcSizeType) + cxMarginsWidth(GetCellOffset);

  case CaptionLayout of
    clLeft, clRight:
      if (ATextWidth > 0) and (ACellWidth > 0) then
        Result := ATextWidth + ElementOffsetHorz + ACellWidth
      else
        Result := ATextWidth + ACellWidth;
    clTop, clBottom:
      Result := Max(ATextWidth, ACellWidth);
  else
    Result := 0;
  end;
  Result := Result + Padding.Left + Padding.Right;
end;

procedure TdxLayoutCellItemViewInfo.GetElements(AElements: TList);
begin
  inherited;
  AElements.Add(FCellViewInfo);
end;

procedure TdxLayoutCellItemViewInfo.PopulateAutoAlignControlList(AList: TList);
begin
  if AutoAlignmentCellArea then
    AList.Add(Self);
end;

function TdxLayoutCellItemViewInfo.AutoAlignmentCellArea: Boolean;
begin
  Result := False;
end;

procedure TdxLayoutCellItemViewInfo.CalculateCellAreaBounds;
var
  ACellSize: TSize;
  ACellVisible: Boolean;
begin
  InitViewInfoBounds(CellViewInfo, FCellAreaBounds, ACellSize, ACellVisible);
end;

function TdxLayoutCellItemViewInfo.GetCellViewInfoClass: TdxLayoutCellItemCellViewInfoClass;
begin
  Result := TdxLayoutCellItemCellViewInfo;
end;

function TdxLayoutCellItemViewInfo.GetCellAlignHorz: TdxLayoutRealAlignHorz;
begin
  Result := ahClient;
end;

function TdxLayoutCellItemViewInfo.GetCellSize(ACalcSizeType: TdxLayoutCalcSizeType): TSize;
begin
  Result := cxNullSize;
end;

function TdxLayoutCellItemViewInfo.GetCellHeight(ACalcSizeType: TdxLayoutCalcSizeType): Integer;
begin
  Result := GetCellSize(ACalcSizeType).Height;
end;

function TdxLayoutCellItemViewInfo.GetCellWidth(ACalcSizeType: TdxLayoutCalcSizeType): Integer;
begin
  Result := GetCellSize(ACalcSizeType).Width;
end;

function TdxLayoutCellItemViewInfo.GetCellOffset: TRect;
begin
  Result := cxNullRect;
end;

function TdxLayoutCellItemViewInfo.GetStandardCellWidth: Integer;
begin
  Result := GetCellWidth(cstOriginal) + cxMarginsWidth(GetCellOffset);
end;

function TdxLayoutCellItemViewInfo.GetTextHeight(ACalcSizeType: TdxLayoutCalcSizeType): Integer;
begin
  Result := CaptionViewInfo.Height;
end;

function TdxLayoutCellItemViewInfo.GetTextWidth(ACalcSizeType: TdxLayoutCalcSizeType): Integer;
begin
  if ACalcSizeType = cstMin then
    Result := CaptionViewInfo.CalculateMinWidth
  else
    Result := CaptionViewInfo.Width; 
end;

function TdxLayoutCellItemViewInfo.IsCellVisible: Boolean;
begin
  Result := True;
end;

{ TdxLayoutImageItemViewInfo }

procedure TdxLayoutImageItemViewInfo.Calculate(const ABounds: TRect);
begin
  inherited;
end;

function TdxLayoutImageItemViewInfo.GetPainterClass: TdxCustomLayoutItemPainterClass;
begin
  Result := TdxLayoutImageItemPainter;
end;

function TdxLayoutImageItemViewInfo.GetCellSize(ACalcSizeType: TdxLayoutCalcSizeType): TSize;
begin
  if not IsCellVisible then
    Result := cxNullSize
  else
    if ACalcSizeType = cstMin then
      Result := cxSize(dxLayoutItemControlDefaultMinHeight, dxLayoutItemControlDefaultMinWidth)
    else
      Result := dxGetImageSize(Item.Image, Item.ScaleFactor);
end;

function TdxLayoutImageItemViewInfo.IsCellVisible: Boolean;
begin
  Result := IsImageAssigned(Item.Image);
end;

function TdxLayoutImageItemViewInfo.GetItem: TdxLayoutImageItem;
begin
  Result := TdxLayoutImageItem(inherited Item);
end;

{ TdxCustomLayoutCheckableItemViewInfo }

procedure TdxCustomLayoutCheckableItemViewInfo.CalculateInternalTabOrders(var AAvailableTabOrder: Integer);
begin
  inherited CalculateInternalTabOrders(AAvailableTabOrder);
  if Item.CanFocus(False) then
  begin
    FTabOrder := AAvailableTabOrder;
    Inc(AAvailableTabOrder);
  end;
end;

function TdxCustomLayoutCheckableItemViewInfo.AutoAlignmentCellArea: Boolean;
begin
  Result := CaptionLayout = clLeft;
end;

function TdxCustomLayoutCheckableItemViewInfo.GetCaptionViewInfoClass: TdxCustomLayoutItemCaptionViewInfoClass;
begin
  Result := TdxCustomLayoutCheckableItemCaptionViewInfo;
end;

function TdxCustomLayoutCheckableItemViewInfo.GetCellSize(ACalcSizeType: TdxLayoutCalcSizeType): TSize;
begin
  Result := CheckAreaSize;
end;

function TdxCustomLayoutCheckableItemViewInfo.GetElementOffsetHorz: Integer;
begin
  Result := inherited GetElementOffsetHorz - dxFocusRectReservedThickness;
end;

function TdxCustomLayoutCheckableItemViewInfo.GetElementOffsetVert: Integer;
begin
  Result := inherited GetElementOffsetVert - dxFocusRectReservedThickness;
end;

function TdxCustomLayoutCheckableItemViewInfo.GetPainterClass: TdxCustomLayoutItemPainterClass;
begin
  Result := TdxCustomLayoutCheckableItemPainter;
end;


function TdxCustomLayoutCheckableItemViewInfo.GetCellAlignHorz: TdxLayoutRealAlignHorz;
begin
  Result := ahLeft;
end;

function TdxCustomLayoutCheckableItemViewInfo.GetFocusRect(ACanvas: TcxCanvas): TRect;
begin
  if IsFocused then
    Result := CaptionViewInfo.TextAreaBounds
  else
    Result := cxNullRect;
end;

function TdxCustomLayoutCheckableItemViewInfo.GetItem: TdxCustomLayoutCheckableItem;
begin
  Result := TdxCustomLayoutCheckableItem(inherited Item);
end;

function TdxCustomLayoutCheckableItemViewInfo.IsHotTrackable: Boolean;
begin
  Result := not IsCustomization and Enabled;
end;

function TdxCustomLayoutCheckableItemViewInfo.IsFocused: Boolean;
begin
  Result := inherited IsFocused and Item.ShowFocusRect;
end;

procedure TdxCustomLayoutCheckableItemViewInfo.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if (Key = VK_SPACE) and Item.IsFocused then
    TdxCustomLayoutCheckableItem(Item).Toggle;
end;

procedure TdxCustomLayoutCheckableItemViewInfo.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  APressed: Boolean;
begin
  APressed := levsPressed in State;
  inherited MouseUp(Button, Shift, X, Y);
  if Enabled and PtInRect(OriginalBounds, Point(X, Y)) and APressed then
  begin
    if Item.CanFocus(True) then
      ContainerViewInfo.Container.FocusController.SetItemFocus(Item);
    Item.Toggle;
  end;
end;

function TdxCustomLayoutCheckableItemViewInfo.ShowHint(var AHintInfo: THintInfo): Boolean;
begin
  if Item.CaptionOptions.Hint <> '' then
  begin
    AHintInfo.HintData := @AHintInfo;
    AHintInfo.CursorRect := Bounds;
    AHintInfo.HintStr := GetShortHint(Item.CaptionOptions.Hint);
    Result := AHintInfo.HintStr <> '';
  end
  else
    Result := inherited ShowHint(AHintInfo);
end;

procedure TdxCustomLayoutCheckableItemViewInfo.StateChanged;
begin
  inherited StateChanged;
  Invalidate(OriginalBounds);
end;

{ TdxCustomLayoutCheckableItemCaptionViewInfo }

function TdxCustomLayoutCheckableItemCaptionViewInfo.GetTextPadding: TdxPadding;
var
  R: TRect;
begin
  R := Rect(dxFocusRectReservedThickness, dxFocusRectReservedThickness, dxFocusRectReservedThickness, dxFocusRectReservedThickness);;
  inherited GetTextPadding.InflatePadding(R);
  Result := R;
end;

function TdxCustomLayoutCheckableItemCaptionViewInfo.IsPointInHotTrackBounds(const P: TPoint): Boolean;
begin
  Result := inherited IsPointInHotTrackBounds(P) or
    PtInRect(TdxLayoutCheckBoxItemViewInfo(ItemViewInfo).CheckAreaBounds, P);
end;

function TdxCustomLayoutCheckableItemCaptionViewInfo.WantsMouse(X, Y: Integer): Boolean;
begin
  Result := inherited WantsMouse(X, Y) or
    (Visible and PtInRect(TdxLayoutCheckBoxItemViewInfo(ItemViewInfo).CheckAreaBounds, Point(X, Y)));
end;

{ TdxLayoutCheckBoxItemViewInfo }

function TdxLayoutCheckBoxItemViewInfo.GetCellOffset: TRect;
begin
  Result := TcxCustomCheckBoxViewInfoAccess.GetContentOffset(False, False, taLeftJustify, Item.ScaleFactor);
end;

function TdxLayoutCheckBoxItemViewInfo.GetCheckAreaSize: TSize;
begin 
  Result := GetScaledEditCheckSize(ContainerViewInfo.Canvas, LookAndFeel.NativeStyle, Item.CheckBoxOptions.Glyph,
    Item.CheckBoxOptions.GlyphCount, LookAndFeel.Painter, Item.ScaleFactor);
end;

function TdxLayoutCheckBoxItemViewInfo.GetPainterClass: TdxCustomLayoutItemPainterClass;
begin
  Result := TdxLayoutCheckBoxItemPainter;
end;

function TdxLayoutCheckBoxItemViewInfo.GetItem: TdxLayoutCheckBoxItem;
begin
  Result := TdxLayoutCheckBoxItem(inherited Item);
end;

{ TdxLayoutRadioButtonItemViewInfo }

function TdxLayoutRadioButtonItemViewInfo.GetCellOffset: TRect;
begin
  if CaptionLayout = clRight then
    Result := Rect(1, 0, 0, 0)
  else
    Result := inherited;
end;

function TdxLayoutRadioButtonItemViewInfo.GetCheckAreaSize: TSize;
begin 
  Result := LookAndFeel.GetAvailablePainter(totButton).ScaledRadioButtonSize(Item.ScaleFactor);
end;

function TdxLayoutRadioButtonItemViewInfo.GetPainterClass: TdxCustomLayoutItemPainterClass;
begin
  Result := TdxLayoutRadioButtonItemPainter;
end;

function TdxLayoutRadioButtonItemViewInfo.GetItem: TdxLayoutRadioButtonItem;
begin
  Result := TdxLayoutRadioButtonItem(inherited Item);
end;

{ TdxLayoutControlItemViewInfo }

function TdxLayoutControlItemViewInfo.GetCaptionViewInfo: TdxLayoutControlItemCaptionViewInfo;
begin
  Result := TdxLayoutControlItemCaptionViewInfo(inherited CaptionViewInfo);
end;

function TdxLayoutControlItemViewInfo.GetControlViewInfo: TdxLayoutControlItemControlViewInfo;
begin
  Result := TdxLayoutControlItemControlViewInfo(inherited CellViewInfo);
end;

function TdxLayoutControlItemViewInfo.GetItem: TdxLayoutControlItem;
begin
  Result := TdxLayoutControlItem(inherited Item);
end;

function TdxLayoutControlItemViewInfo.GetOptions: TdxLayoutLookAndFeelItemOptions;
begin
  Result := inherited Options as TdxLayoutLookAndFeelItemOptions;
end;

function TdxLayoutControlItemViewInfo.GetCaptionViewInfoClass: TdxCustomLayoutItemCaptionViewInfoClass;
begin
  Result := TdxLayoutControlItemCaptionViewInfo;
end;

function TdxLayoutControlItemViewInfo.GetCellViewInfoClass: TdxLayoutCellItemCellViewInfoClass;
begin
  Result := GetControlViewInfoClass;
end;

function TdxLayoutControlItemViewInfo.GetControlViewInfoClass: TdxLayoutControlItemControlViewInfoClass;
begin
  Result := TdxLayoutControlItemControlViewInfo;
end;

function TdxLayoutControlItemViewInfo.GetPainterClass: TdxCustomLayoutItemPainterClass;
begin
  Result := TdxLayoutControlItemPainter;
end;

function TdxLayoutControlItemViewInfo.AutoAlignmentCellArea: Boolean;

  function IsAlignmentAndCaptionLayoutLinked: Boolean;
  begin
    case CaptionLayout of
      clLeft:
        Result := AlignHorz in [ahLeft, ahClient];
      clTop:
        Result := AlignVert in [avTop, avClient];
      clRight:
        Result := AlignHorz in [ahRight, ahClient];
      clBottom:
        Result := AlignVert in [avBottom, avClient];
    else
      Result := False;
    end;
  end;

  function IsConstraintAndCaptionLayoutLinked: Boolean;
  begin
    Result := (Item.AlignmentConstraint = nil) or
       (Item.AlignmentConstraint.Kind in [ackTop, ackBottom]) and (CaptionLayout in [clLeft, clRight]) or
       (Item.AlignmentConstraint.Kind in [ackLeft, ackRight]) and (CaptionLayout in [clTop, clBottom]);
  end;

begin
  Result :=
    Item.ControlOptions.AutoControlAreaAlignment and HasCaption and HasControl and
    IsAlignmentAndCaptionLayoutLinked and IsConstraintAndCaptionLayoutLinked;
end;

function TdxLayoutControlItemViewInfo.GetAvailableTextAreaWidth: Integer;
begin
  Result := inherited GetAvailableTextAreaWidth;
end;

function TdxLayoutControlItemViewInfo.GetStandardCellWidth: Integer;
begin
  Result := ControlViewInfo.CalculateMinWidth;
end;

function TdxLayoutControlItemViewInfo.GetCellAlignHorz: TdxLayoutRealAlignHorz;
begin
  Result := ControlViewInfo.LayoutAlignHorz;
end;

function TdxLayoutControlItemViewInfo.GetCellSize(ACalcSizeType: TdxLayoutCalcSizeType): TSize;
begin
  Result := cxNullSize; 
end;

function TdxLayoutControlItemViewInfo.GetCellHeight(ACalcSizeType: TdxLayoutCalcSizeType): Integer;
begin
  if ACalcSizeType = cstMin then
    Result := ControlViewInfo.CalculateMinHeight
  else
    Result := ControlViewInfo.CalculateHeight;
end;

function TdxLayoutControlItemViewInfo.IsCellVisible: Boolean;
begin
  Result := HasControl;
end;

function TdxLayoutControlItemViewInfo.GetCellWidth(ACalcSizeType: TdxLayoutCalcSizeType): Integer;
begin
  if ACalcSizeType = cstMin then
    Result := ControlViewInfo.CalculateMinWidth
  else
    Result := ControlViewInfo.CalculateWidth;
end;

function TdxLayoutControlItemViewInfo.HasControl: Boolean;
begin
  Result := Item.HasControl;
end;

procedure TdxLayoutControlItemViewInfo.CalculateInternalTabOrders(var AAvailableTabOrder: Integer);
begin
  ControlViewInfo.CalculateInternalTabOrder(AAvailableTabOrder);
end;

procedure TdxLayoutControlItemViewInfo.CalculateTabOrders(var AAvailableTabOrder: Integer);
begin
  ControlViewInfo.CalculateTabOrder(AAvailableTabOrder);
end;

{ TdxLayoutItemViewInfo }

function TdxLayoutItemViewInfo.CanFocusOnClick(X, Y: Integer): Boolean;
begin
  Result := not (Item.CanFocusControlOnCaptionClick and CaptionViewInfo.CanDoCaptionClick(X, Y));
end;

function TdxLayoutItemViewInfo.GetCaptionViewInfoClass: TdxCustomLayoutItemCaptionViewInfoClass;
begin
  Result := TdxLayoutItemCaptionViewInfo;
end;

function TdxLayoutItemViewInfo.GetControlViewInfoClass: TdxLayoutControlItemControlViewInfoClass;
begin
  Result := TdxLayoutItemControlViewInfo;
end;

function TdxLayoutItemViewInfo.GetHitTestClass: TdxCustomLayoutItemHitTestClass;
begin
  Result := TdxLayoutItemHitTest;
end;

function TdxLayoutItemViewInfo.GetPainterClass: TdxCustomLayoutItemPainterClass;
begin
  Result := TdxCustomLayoutItemPainterClass(LayoutLookAndFeel.GetItemPainterClass);
end;

procedure TdxLayoutItemViewInfo.PopulateControlViewInfoList(AControls, AWinControls: TList);
var
  AControlViewInfo: TdxLayoutItemControlViewInfo;
begin
  AControlViewInfo := ControlViewInfo;
  if (AControlViewInfo.Control <> nil) and ActuallyVisible then
    if AControlViewInfo.Control is TWinControl then
      AWinControls.Add(AControlViewInfo)
    else
      AControls.Add(AControlViewInfo);
end;

procedure TdxLayoutItemViewInfo.SetItemHeight(AHeight: Integer; ADirectAccess: Boolean);
begin
  if ADirectAccess and HasControl then
    Item.Control.Height := Item.Control.Height + AHeight - Bounds.Height
  else
    inherited;
end;

procedure TdxLayoutItemViewInfo.SetItemWidth(AWidth: Integer; ADirectAccess: Boolean);
begin
  if ADirectAccess and HasControl then
    Item.Control.Width := Item.Control.Width + AWidth - Bounds.Width
  else
    inherited;
end;

procedure TdxLayoutItemViewInfo.CustomizationMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

  function NeedSelectControl: Boolean;
  begin
    Result := HasControl and ContainerViewInfo.Container.Customization and Item.IsDesignSelectorVisible and
      PtInDesignSelectorRect(Point(X, Y));
  end;

begin
  if NeedSelectControl then
    ContainerViewInfo.Container.SelectComponent(ControlViewInfo.Control, Shift)
  else
    inherited;
end;

function TdxLayoutItemViewInfo.PtInDesignSelectorRect(const P: TPoint): Boolean;
var
  R: TRect;
begin
  R := Item.DesignSelectorRect;
  R := cxRectOffset(R, ControlViewInfo.Bounds.TopLeft);
  Result := PtInRect(R, P);
end;

function TdxLayoutItemViewInfo.GetCaptionViewInfo: TdxLayoutItemCaptionViewInfo;
begin
  Result := TdxLayoutItemCaptionViewInfo(inherited CaptionViewInfo);
end;

function TdxLayoutItemViewInfo.GetControlViewInfo: TdxLayoutItemControlViewInfo;
begin
  Result := TdxLayoutItemControlViewInfo(inherited ControlViewInfo);
end;

function TdxLayoutItemViewInfo.GetItem: TdxLayoutItem;
begin
  Result := TdxLayoutItem(inherited Item);
end;

{ TdxLayoutGroupCaptionViewInfo }

function TdxLayoutGroupCaptionViewInfo.GetAvailableHeight: Integer;
begin
  Result := CalculateHeight;
  if not Visible and not IsVerticalCaption then
    Inc(Result, Max(GetAvailableTextHeight, ImageHeight));
end;

function TdxLayoutGroupCaptionViewInfo.GetAvailableWidth: Integer;
begin
  Result := CalculateWidth;
  if not Visible and IsVerticalCaption then
    Inc(Result, Max(GetAvailableTextWidth, ImageWidth));
end;

function TdxLayoutGroupCaptionViewInfo.GetAvailableHorzTextHeight: Integer;
begin
  if FAvailableTextSizeCache.Height = 0 then
  begin
    PrepareCanvas(Canvas, False);
    FAvailableTextSizeCache := Canvas.TextExtent(dxMeasurePattern);
    Inc(FAvailableTextSizeCache.cx, dxLayoutCorrectionForDisabling);
    Inc(FAvailableTextSizeCache.cy, dxLayoutCorrectionForDisabling);
  end;
  Result := FAvailableTextSizeCache.Height;
end;

function TdxLayoutGroupCaptionViewInfo.GetAvailableHorzTextWidth: Integer;
begin
  if FAvailableTextSizeCache.Width = 0 then
  begin
    PrepareCanvas(Canvas, False);
    FAvailableTextSizeCache := Canvas.TextExtent(dxMeasurePattern);
    Inc(FAvailableTextSizeCache.cx, dxLayoutCorrectionForDisabling);
    Inc(FAvailableTextSizeCache.cy, dxLayoutCorrectionForDisabling);
  end;
  Result := FAvailableTextSizeCache.Width;
end;

function TdxLayoutGroupCaptionViewInfo.GetAvailableTextHeight: Integer;
begin
  if IsVerticalCaption then
    Result := GetAvailableHorzTextWidth
  else
    Result := GetAvailableHorzTextHeight;
end;

function TdxLayoutGroupCaptionViewInfo.GetAvailableTextWidth: Integer;
begin
  if IsVerticalCaption then
    Result := GetAvailableHorzTextHeight
  else
    Result := GetAvailableHorzTextWidth;
end;

procedure TdxLayoutGroupCaptionViewInfo.CalculateImageTextAreaBounds;
var
  AContentBounds: TRect;
  ATextSize: TSize;
  AImageAreaWidth, AImageAreaHeight, ATextAreaWidth, ATextAreaHeight: Integer;
  AHeaderHeight: Integer;
begin
  if IsVerticalCaption then
  begin
    AContentBounds := cxRectContent(Bounds, GetContentOffsets);

    AImageAreaWidth := GetImageHeight;
    AImageAreaHeight := GetImageWidth;
    ATextSize := GetTextPlaceSize;
    ATextAreaHeight := ATextSize.Width;
    ATextAreaWidth := ATextSize.Height;
    AHeaderHeight := AImageAreaHeight + GetSpaceBetweenImageText + ATextAreaHeight;

    // AlignHorz ignored
    FImageAreaBounds.Left := AContentBounds.Left + (AContentBounds.Width - AImageAreaWidth) div 2;
    FImageAreaBounds.Right := FImageAreaBounds.Left + AImageAreaWidth;
    FTextAreaBounds.Left := AContentBounds.Left + (AContentBounds.Width - ATextAreaWidth) div 2;
    FTextAreaBounds.Right := FTextAreaBounds.Left + ATextAreaWidth;

    if CaptionSide = sdLeft then
    begin
      case AlignVert of
        tavTop:
          FImageAreaBounds.Bottom := AContentBounds.Top + AHeaderHeight;
        tavBottom:
          FImageAreaBounds.Bottom := AContentBounds.Bottom;
        tavCenter:
          FImageAreaBounds.Bottom := AContentBounds.Bottom - (AContentBounds.Height - AHeaderHeight) div 2;
      end;
      FImageAreaBounds.Top := FImageAreaBounds.Bottom - AImageAreaHeight;
      FTextAreaBounds.Bottom := FImageAreaBounds.Top - GetSpaceBetweenImageText;
      FTextAreaBounds.Top := FTextAreaBounds.Bottom - ATextAreaHeight;
    end
    else
    begin
      case AlignVert of
        tavTop:
          FImageAreaBounds.Top := AContentBounds.Top;
        tavBottom:
          FImageAreaBounds.Top := AContentBounds.Bottom - AHeaderHeight;
        tavCenter:
          FImageAreaBounds.Top := AContentBounds.Top + (AContentBounds.Height - AHeaderHeight) div 2;
      end;
      FImageAreaBounds.Bottom := FImageAreaBounds.Top + AImageAreaHeight;
      FTextAreaBounds.Top := FImageAreaBounds.Bottom + GetSpaceBetweenImageText;
      FTextAreaBounds.Bottom := FTextAreaBounds.Top + ATextAreaHeight;
    end;
  end
  else
    inherited CalculateImageTextAreaBounds;
end;

function TdxLayoutGroupCaptionViewInfo.CalculateTextFlags(ACanvas: TcxCanvas; AForDrawing: Boolean): Integer;
begin
  Result := inherited or cxSingleLine;
end;

procedure TdxLayoutGroupCaptionViewInfo.MouseEnter;
begin 
  FCanClickOnCaption := False;
  if GroupViewInfo.Group.IsCheckBoxVisible and not IsCustomization and Enabled then
    State := State + [levsHot]
  else
    inherited;
end;

procedure TdxLayoutGroupCaptionViewInfo.MouseLeave;
begin
  inherited;
  FCanClickOnCaption := False;
end;

procedure TdxLayoutGroupCaptionViewInfo.MouseMove(Shift: TShiftState; X: Integer; Y: Integer);
var
  AButtonsViewInfo: TdxLayoutGroupButtonsViewInfo;
  I: Integer;
begin
  inherited;
  FCanClickOnCaption := CanDoCaptionClick(X, Y);
  if GroupViewInfo.Group.IsCheckBoxVisible then
  begin
    AButtonsViewInfo := GroupViewInfo.ButtonsViewInfo;
    for I := 0 to AButtonsViewInfo.ButtonViewInfoCount - 1 do
      if AButtonsViewInfo.ButtonViewInfos[I].Button = AButtonsViewInfo.Options.CheckBox then
      begin
        AButtonsViewInfo.ButtonViewInfos[I].StateChanged;
        Break;
      end;
  end;
end;

procedure TdxLayoutGroupCaptionViewInfo.PrepareCanvas(ACanvas: TcxCanvas; AForDrawing: Boolean);
begin
  inherited;
  LayoutLookAndFeel.CorrectGroupCaptionFont(GroupViewInfo, ACanvas.Font);
end;

procedure TdxLayoutGroupCaptionViewInfo.StateChanged;
begin
  inherited;
  if GroupViewInfo.Group.IsCheckBoxVisible then
    GroupViewInfo.ButtonsViewInfo.StateChanged;
end;

function TdxLayoutGroupCaptionViewInfo.GetTextAlignHorz: TAlignment;
begin
  Result := LayoutLookAndFeel.GetGroupCaptionAlignHorz(GroupViewInfo);
end;

function TdxLayoutGroupCaptionViewInfo.GetTextAlignVert: TdxAlignmentVert;
begin
  Result := LayoutLookAndFeel.GetGroupCaptionAlignVert(GroupViewInfo);
end;

function TdxLayoutGroupCaptionViewInfo.GetColor: TColor;
begin
  Result := LayoutLookAndFeel.GetGroupCaptionColor(GroupViewInfo);
end;

function TdxLayoutGroupCaptionViewInfo.GetContentOffsetSize: TSize;
begin
  Result := inherited GetContentOffsetSize;
  if IsVerticalCaption then
    Result := cxSize(Result.Height, Result.Width);
end;

function TdxLayoutGroupCaptionViewInfo.GetContentOffsets: TRect;
begin
  Result := LayoutLookAndFeel.GetGroupCaptionContentOffsets(GroupViewInfo);
end;

function TdxLayoutGroupCaptionViewInfo.GetTextSize(ACanvas: TcxCanvas): TSize;
var
  R: TRect;
  AFlags: Integer;
begin
  if IsEllipsisAllowed and not IsTextFormatted then
  begin
    R := Rect(0, 0, Max(1, ItemViewInfo.GetAvailableTextAreaWidth), 1);
    AFlags := CalculateTextFlags(ACanvas, False) or cxDontBreakChars;
    if R.Right <> FTextSizeCache.TextAreaWidth then
    begin
      FTextSizeCache.TextAreaWidth := R.Right;
      ACanvas.TextExtent(Text, R, AFlags);
      Result := cxRectSize(R);
      FTextSizeCache.TextSize := Result;
    end
    else
      Result := FTextSizeCache.TextSize;
  end
  else
    Result := inherited GetTextSize(ACanvas);
end;

function TdxLayoutGroupCaptionViewInfo.GetRotationAngle: TcxRotationAngle;
begin
  Result := GroupViewInfo.GetRotationAngle;
end;

function TdxLayoutGroupCaptionViewInfo.IsVerticalCaption: Boolean;
begin
  Result := GroupViewInfo.IsVerticalCaption;
end;

function TdxLayoutGroupCaptionViewInfo.CalculateHeight: Integer;
begin
  if IsVerticalCaption then
    Result := inherited CalculateWidth
  else
    Result := inherited CalculateHeight;
  if Visible then
    LayoutLookAndFeel.CorrectGroupCaptionHeight(GroupViewInfo, Result);
end;

function TdxLayoutGroupCaptionViewInfo.CalculateWidth: Integer;
begin
  if IsVerticalCaption then
    Result := inherited CalculateHeight
  else
    Result := inherited CalculateWidth;
  if Visible then
    LayoutLookAndFeel.CorrectGroupCaptionWidth(GroupViewInfo, Result);
end;

function TdxLayoutGroupCaptionViewInfo.CalculateMinHeight: Integer;
begin
  Result := CalculateHeight;
end;

function TdxLayoutGroupCaptionViewInfo.CalculateMinWidth: Integer;
begin
  Result := CalculateWidth;
end;

function TdxLayoutGroupCaptionViewInfo.GetCaptionSide: TdxLayoutSide;
begin
  Result := GroupViewInfo.CaptionSide;
end;

function TdxLayoutGroupCaptionViewInfo.GetGroupViewInfo: TdxLayoutGroupViewInfo;
begin
  Result := ItemViewInfo.AsGroupViewInfo;
end;

{ TdxLayoutGroupViewInfoSpecific }

constructor TdxLayoutGroupViewInfoSpecific.Create(AGroupViewInfo: TdxLayoutGroupViewInfo);
begin
  inherited Create;
  FGroupViewInfo := AGroupViewInfo;
  FOffset := AGroupViewInfo.Offset;
  CreateSpecificControls;
end;

destructor TdxLayoutGroupViewInfoSpecific.Destroy;
begin
  DestroySpecificControls;
  inherited Destroy;
end;

procedure TdxLayoutGroupViewInfoSpecific.Calculate(const AItemsAreaBounds: TRect);
begin
  CalculateItemsBounds(AItemsAreaBounds);
end;

procedure TdxLayoutGroupViewInfoSpecific.CorrectItemsAreaBounds(var AItemsAreaBounds: TRect);
begin
  Inc(AItemsAreaBounds.Left, GetItemsAreaOffset(sdLeft));
  Dec(AItemsAreaBounds.Right, GetItemsAreaOffset(sdRight));
  Inc(AItemsAreaBounds.Top, GetItemsAreaOffset(sdTop));
  Dec(AItemsAreaBounds.Bottom, GetItemsAreaOffset(sdBottom));
end;

procedure TdxLayoutGroupViewInfoSpecific.CalculateItemsAreaBounds(var AItemsAreaBounds: TRect);
begin
  CorrectItemsAreaBounds(AItemsAreaBounds);
end;

procedure TdxLayoutGroupViewInfoSpecific.CalculateItemsBounds(AItemsAreaBounds: TRect);

  procedure CalculateItemsSizes;
  var
    I: Integer;
  begin
    SetLength(FItemInfos, ItemViewInfoCount);

    for I := 0 to ItemViewInfoCount - 1 do
    begin
      ZeroMemory(@FItemInfos[I], SizeOf(TItemInfo));
      FItemInfos[I].ViewInfo := ItemViewInfos[I];
      FItemInfos[I].PrevBounds := FItemInfos[I].ViewInfo.Bounds;
      FItemInfos[I].Calculated := False;

      FItemInfos[I].MajorAlign := GetMajorAlign(FItemInfos[I].ViewInfo.Align);
      FItemInfos[I].OriginalMajorSize := GetItemOriginalMajorSize(FItemInfos[I].ViewInfo);
      FItemInfos[I].MinMajorSize := GetItemMinMajorSize(FItemInfos[I].ViewInfo);
      FItemInfos[I].MaxMajorSize := GetItemMaxMajorSize(FItemInfos[I].ViewInfo);
      FItemInfos[I].SufficientMajorSize := GetItemSufficientMajorSize(FItemInfos[I].ViewInfo);

      FItemInfos[I].MinorAlign := GetMinorAlign(FItemInfos[I].ViewInfo.Align);
      FItemInfos[I].OriginalMinorSize := GetItemOriginalMinorSize(FItemInfos[I].ViewInfo);
      FItemInfos[I].SufficientMinorSize := GetItemSufficientMinorSize(FItemInfos[I].ViewInfo);
    end;
  end;

var
  AAbsRect: TdxAbsRect;
begin
  AAbsRect := GetAbsRect(AItemsAreaBounds);

  CalculateItemsSizes;
  CalculateItemsMajorBounds(AAbsRect);
  CalculateItemsMinorBounds(AAbsRect);
  CalculateItemViewInfos;
end;

procedure TdxLayoutGroupViewInfoSpecific.CalculateItemsMajorBounds(const AItemsAreaBounds: TdxAbsRect);
var
  AUsualSpace, AContentSpace, ANecessarySpace, AAvailableSpace: Integer;

  procedure CalculateSpaces;
  var
    AItemOffsets, I: Integer;
    AIsFirstItem: Boolean;
  begin
    AItemOffsets := 0;
    AUsualSpace := 0;
    AContentSpace := 0;
    AIsFirstItem := True;

    for I := 0 to ItemViewInfoCount - 1 do
      if FItemInfos[I].MajorAlign <> aaCenter then
      begin
        if not AIsFirstItem then
          Inc(AItemOffsets, ItemOffset);
        Inc(AUsualSpace, FItemInfos[I].SufficientMajorSize);
        if IsItemMajorSizeUsual(FItemInfos[I].ViewInfo) then
          Inc(AContentSpace, FItemInfos[I].SufficientMajorSize)
        else
          Inc(AContentSpace, FItemInfos[I].MinMajorSize);

        AIsFirstItem := False;
      end;
    AAvailableSpace := AItemsAreaBounds.Size.Major - AItemOffsets;
    ANecessarySpace := AContentSpace + AItemOffsets;

    if (AAvailableSpace < AContentSpace) and GroupViewInfo.AllowMajorScroll and GroupViewInfo.IsExpanded then
    begin
      if GroupViewInfo.FMajorScrollBar = nil then
      begin
        GroupViewInfo.ContainerViewInfo.FNeedRecalculate := True;
        GroupViewInfo.FMajorScrollBar := GroupViewInfo.CreateScrollBar;
      end;
      GroupViewInfo.InitializeMajorScrollBar(AContentSpace, AAvailableSpace);
      AAvailableSpace := AContentSpace;
    end
    else
    begin
      if GroupViewInfo.FMajorScrollBar <> nil then 
      begin
        GroupViewInfo.ContainerViewInfo.FNeedRecalculate := True;
        GroupViewInfo.DestroyScrollBar(GroupViewInfo.FMajorScrollBar); 
      end;
    end;
  end;

  procedure InternalCalculateItemsVisibleSizes;

    procedure CalculateNonClientAlignedItemsVisibleSizes;
    var
      I: Integer;
    begin
      for I := 0 to ItemViewInfoCount - 1 do
        if IsItemMajorSizeUsual(FItemInfos[I].ViewInfo) then
        begin
          FItemInfos[I].CalculatedMajorSize := FItemInfos[I].SufficientMajorSize;
          if FItemInfos[I].MajorAlign <> aaCenter then
          begin
            Dec(AUsualSpace, FItemInfos[I].CalculatedMajorSize);
            Dec(AAvailableSpace, FItemInfos[I].CalculatedMajorSize);
          end;
          FItemInfos[I].Calculated := True;
        end;
    end;

    procedure CalculateClientAlignedItemsVisibleSizes;
    var
      ANeedRecalculating: Boolean;
      ANextSpace, ANextAvailableSpace, AOffset, I: Integer;
    begin
      repeat
        ANeedRecalculating := False;
        ANextSpace := AUsualSpace;
        ANextAvailableSpace := AAvailableSpace;
        AOffset := 0;

        for I := 0 to ItemViewInfoCount - 1 do
          if not FItemInfos[I].Calculated then
          begin
            FItemInfos[I].CalculatedMajorSize :=
              MulDiv(AAvailableSpace, AOffset + FItemInfos[I].SufficientMajorSize, AUsualSpace) -
              MulDiv(AAvailableSpace, AOffset, AUsualSpace);

            if (FItemInfos[I].CalculatedMajorSize < FItemInfos[I].MinMajorSize) or (FItemInfos[I].CalculatedMajorSize > FItemInfos[I].MaxMajorSize) then
            begin
              if FItemInfos[I].CalculatedMajorSize < FItemInfos[I].MinMajorSize then
                FItemInfos[I].CalculatedMajorSize := FItemInfos[I].MinMajorSize
              else
                FItemInfos[I].CalculatedMajorSize := FItemInfos[I].MaxMajorSize;

              Dec(ANextSpace, FItemInfos[I].SufficientMajorSize);
              Dec(ANextAvailableSpace, FItemInfos[I].CalculatedMajorSize);
              FItemInfos[I].Calculated := True;
              ANeedRecalculating := True;
            end;
            Inc(AOffset, FItemInfos[I].SufficientMajorSize);
          end;
        AUsualSpace := ANextSpace;
        AAvailableSpace := ANextAvailableSpace;
      until not ANeedRecalculating;
    end;

  begin
    CalculateNonClientAlignedItemsVisibleSizes;
    CalculateClientAlignedItemsVisibleSizes;
  end;

  procedure InternalCalculateItemsBounds;

    procedure CalculateNearAlignedItemsBounds;
    var
      AOffset, I: Integer;
    begin
      AOffset := AItemsAreaBounds.NearMajor - GroupViewInfo.GetScrollPos.Major;
      for I := 0 to ItemViewInfoCount - 1 do
        case FItemInfos[I].MajorAlign of
          aaNear, aaClient:
            begin
              FItemInfos[I].AbsBounds.NearMajor := AOffset;
              FItemInfos[I].AbsBounds.FarMajor := AOffset + FItemInfos[I].CalculatedMajorSize;
              Inc(AOffset, FItemInfos[I].CalculatedMajorSize + ItemOffset);
            end;
          aaCenter:
            begin
              FItemInfos[I].AbsBounds.NearMajor := (AItemsAreaBounds.NearMajor + AItemsAreaBounds.FarMajor - FItemInfos[I].CalculatedMajorSize) div 2;
              FItemInfos[I].AbsBounds.FarMajor := FItemInfos[I].AbsBounds.NearMajor + FItemInfos[I].CalculatedMajorSize;
            end;
        end;
    end;

    procedure CalculateFarAlignedItemsBounds;
    var
      AOffset, I: Integer;
    begin
      if GroupViewInfo.FMajorScrollBar <> nil then
        AOffset := AItemsAreaBounds.NearMajor + ANecessarySpace - GroupViewInfo.GetScrollPos.Major
      else
        AOffset := AItemsAreaBounds.FarMajor;
      for I := ItemViewInfoCount - 1 downto 0 do
        if FItemInfos[I].MajorAlign = aaFar then
        begin
          FItemInfos[I].AbsBounds.FarMajor := AOffset;
          FItemInfos[I].AbsBounds.NearMajor := AOffset - FItemInfos[I].CalculatedMajorSize;
          Dec(AOffset, FItemInfos[I].CalculatedMajorSize + ItemOffset);
        end;
    end;

  begin
    CalculateNearAlignedItemsBounds;
    CalculateFarAlignedItemsBounds;
  end;

begin
  CalculateSpaces;
  InternalCalculateItemsVisibleSizes;
  InternalCalculateItemsBounds;
end;

procedure TdxLayoutGroupViewInfoSpecific.CalculateItemsMinorBounds(const AItemsAreaBounds: TdxAbsRect);
var
  I: Integer;
  AMinorSize, AMaxMinorSize: Integer;
  R: TdxAbsRect;
begin
  AMaxMinorSize := 0;
  for I := 0 to ItemViewInfoCount - 1 do
    if FItemInfos[I].MinorAlign <> aaCenter then
      AMaxMinorSize := Max(AMaxMinorSize, FItemInfos[I].OriginalMinorSize);

  for I := 0 to ItemViewInfoCount - 1 do
  begin
    AMinorSize := FItemInfos[I].OriginalMinorSize;
    R := FItemInfos[I].AbsBounds;
    case FItemInfos[I].MinorAlign of
      aaNear:
        begin
          R.NearMinor := AItemsAreaBounds.NearMinor - GroupViewInfo.GetScrollPos.Minor;
          R.FarMinor := R.NearMinor + AMinorSize;
        end;
      aaCenter:
        begin
          R.NearMinor := (AItemsAreaBounds.NearMinor + AItemsAreaBounds.FarMinor - AMinorSize) div 2;
          R.FarMinor := R.NearMinor + AMinorSize;
        end;
      aaFar:
        begin
          R.FarMinor := AItemsAreaBounds.FarMinor;
          R.NearMinor := R.FarMinor - AMinorSize;
        end;
      aaClient:
        if not GroupViewInfo.AllowMinorScroll or (AMinorSize < AItemsAreaBounds.Size.Minor) then
        begin
          R.NearMinor := AItemsAreaBounds.NearMinor;
          R.FarMinor := AItemsAreaBounds.FarMinor;
        end
        else
        begin
          R.NearMinor := AItemsAreaBounds.NearMinor - GroupViewInfo.GetScrollPos.Minor;
          R.FarMinor := R.NearMinor + AMaxMinorSize;
        end;
      end;
    FItemInfos[I].AbsBounds := R;
  end;

  if (AMaxMinorSize > AItemsAreaBounds.Size.Minor) and GroupViewInfo.AllowMinorScroll and GroupViewInfo.IsExpanded then
  begin
    if GroupViewInfo.FMinorScrollBar = nil then
    begin
      GroupViewInfo.ContainerViewInfo.FNeedRecalculate := True;
      GroupViewInfo.FMinorScrollBar := GroupViewInfo.CreateScrollBar;
    end;
    GroupViewInfo.InitializeMinorScrollBar(AMaxMinorSize, AItemsAreaBounds.Size.Minor);
  end
  else
  begin
    if GroupViewInfo.FMinorScrollBar <> nil then 
    begin
      GroupViewInfo.ContainerViewInfo.FNeedRecalculate := True;
      GroupViewInfo.DestroyScrollBar(GroupViewInfo.FMinorScrollBar); 
    end;
  end;
end;

procedure TdxLayoutGroupViewInfoSpecific.CalculateInternalTabOrders(var ATabOrder: Integer);
begin
// do nothing
end;

procedure TdxLayoutGroupViewInfoSpecific.CalculateOffsets;
begin
// do nothing
end;

procedure TdxLayoutGroupViewInfoSpecific.CalculateItemViewInfos;
var
  AViewInfo: TItemInfo;
begin
  for AViewInfo in FItemInfos do
  begin
    AViewInfo.ViewInfo.Calculate(GetRectFromAbsRect(AViewInfo.AbsBounds));
    GroupViewInfo.ContainerViewInfo.FNeedRecalculate := GroupViewInfo.ContainerViewInfo.FNeedRecalculate or
      AViewInfo.ViewInfo.IsWordWrapAllowed and not cxRectCompare(AViewInfo.PrevBounds, AViewInfo.ViewInfo.Bounds);
  end;
end;

function TdxLayoutGroupViewInfoSpecific.GetContainer: TdxLayoutContainer;
begin
  Result := Group.Container;
end;

function TdxLayoutGroupViewInfoSpecific.GetGroup: TdxCustomLayoutGroup;
begin
  Result := GroupViewInfo.Group;
end;

function TdxLayoutGroupViewInfoSpecific.GetItemOffset: Integer;
begin
  Result := FGroupViewInfo.ItemOffset;
end;

function TdxLayoutGroupViewInfoSpecific.GetItemViewInfo(Index: Integer): TdxCustomLayoutItemViewInfo;
begin
  Result := FGroupViewInfo.ItemViewInfos[Index];
end;

function TdxLayoutGroupViewInfoSpecific.GetItemViewInfoCount: Integer;
begin
  Result := FGroupViewInfo.ItemViewInfoCount;
end;

function TdxLayoutGroupViewInfoSpecific.GetLayoutDirection: TdxLayoutDirection;
begin
  Result := FGroupViewInfo.LayoutDirection;
end;

procedure TdxLayoutGroupViewInfoSpecific.InitializeMajorScrollBar(AContentSize, AClientSize: Integer);
begin
// do nothing
end;

procedure TdxLayoutGroupViewInfoSpecific.InitializeMinorScrollBar(AContentSize, AClientSize: Integer);
begin
// do nothing
end;

procedure TdxLayoutGroupViewInfoSpecific.CreateSpecificControls;
begin
// do nothing
end;

procedure TdxLayoutGroupViewInfoSpecific.DestroySpecificControls;
begin
// do nothing
end;

procedure TdxLayoutGroupViewInfoSpecific.CreateViewInfos;
begin
// do nothing
end;

procedure TdxLayoutGroupViewInfoSpecific.DestroyViewInfos;
begin
// do nothing
end;

procedure TdxLayoutGroupViewInfoSpecific.GetElements(AElements: TList);
begin
// do nothing
end;

procedure TdxLayoutGroupViewInfoSpecific.AssignBounds(ASource: TdxLayoutGroupViewInfoSpecific);
begin
  if CanAssignBounds(ASource) then
    DoAssignBounds(ASource);
end;

function TdxLayoutGroupViewInfoSpecific.CanAssignBounds(ASource: TdxLayoutGroupViewInfoSpecific): Boolean;
begin
  Result := ASource is ClassType;
end;

procedure TdxLayoutGroupViewInfoSpecific.DoAssignBounds(ASource: TdxLayoutGroupViewInfoSpecific);
begin
  FOffset := ASource.FOffset;
end;

procedure TdxLayoutGroupViewInfoSpecific.SetOffset(const Value: TPoint);
begin
  FOffset := Value;
end;

procedure TdxLayoutGroupViewInfoSpecific.AddSelectionControls;
begin
// do nothing
end;

procedure TdxLayoutGroupViewInfoSpecific.RemoveSelectionControls;
begin
// do nothing
end;

function TdxLayoutGroupViewInfoSpecific.CanFocus: Boolean;
begin
  Result := False;
end;

function TdxLayoutGroupViewInfoSpecific.CanFocusOnClick(X, Y: Integer): Boolean;
begin
  Result := True;
end;

procedure TdxLayoutGroupViewInfoSpecific.KeyDown(var Key: Word; Shift: TShiftState);
begin
// do nothing
end;

function TdxLayoutGroupViewInfoSpecific.GetScaleFactor: TdxScaleFactor;
begin
  Result := Container.ScaleFactor;
end;

function TdxLayoutGroupViewInfoSpecific.AllowMajorScroll: Boolean;
begin
  Result := False;
end;

function TdxLayoutGroupViewInfoSpecific.AllowMinorScroll: Boolean;
begin
  Result := False;
end;

function TdxLayoutGroupViewInfoSpecific.GetAbsRect(const R: TRect): TdxAbsRect;
begin
  Result.NearPoint := GetAbsPoint(R.TopLeft);
  Result.FarPoint := GetAbsPoint(R.BottomRight);
end;

function TdxLayoutGroupViewInfoSpecific.GetAbsPoint(const P: TPoint): TdxAbsPoint;
begin
  Result.Major := GetMajorValue(P);
  Result.Minor := GetMinorValue(P);
end;

function TdxLayoutGroupViewInfoSpecific.GetAbsSize(const ASize: TSize): TdxAbsSize;
begin
  Result.Major := GetMajorValue(ASize);
  Result.Minor := GetMinorValue(ASize);
end;

function TdxLayoutGroupViewInfoSpecific.GetRectFromAbsRect(const R: TdxAbsRect): TRect;
begin
  Result.TopLeft := TPoint(R.NearPoint);
  Result.BottomRight := TPoint(R.FarPoint);
end;

function TdxLayoutGroupViewInfoSpecific.GetMajorValue(const P: TPoint): Integer;
begin
  Result := P.X;
end;

function TdxLayoutGroupViewInfoSpecific.GetMinorValue(const P: TPoint): Integer;
begin
  Result := P.Y;
end;

function TdxLayoutGroupViewInfoSpecific.GetMajorValue(const ASize: TSize): Integer;
begin
  Result := ASize.Width;
end;

function TdxLayoutGroupViewInfoSpecific.GetMinorValue(const ASize: TSize): Integer;
begin
  Result := ASize.Height;
end;

function TdxLayoutGroupViewInfoSpecific.GetMajorAlign(const AAlign: TdxLayoutRealAlign): TdxLayoutAlignAbs;
begin
  Result := TdxLayoutAlignAbs(AAlign.Horz);
end;

function TdxLayoutGroupViewInfoSpecific.GetMinorAlign(const AAlign: TdxLayoutRealAlign): TdxLayoutAlignAbs;
begin
  Result := TdxLayoutAlignAbs(AAlign.Vert);
end;

procedure TdxLayoutGroupViewInfoSpecific.SetMajorNear(var R: TRect; AValue: Integer);
begin
  R.Left := AValue;
end;

procedure TdxLayoutGroupViewInfoSpecific.SetMajorFar(var R: TRect; AValue: Integer);
begin
  R.Right := AValue;
end;

procedure TdxLayoutGroupViewInfoSpecific.SetMajorAlign(var AAlign: TdxLayoutRealAlign; AValue: TdxLayoutAlignAbs);
begin
  AAlign.Horz := TdxLayoutRealAlignHorz(AValue);
end;

procedure TdxLayoutGroupViewInfoSpecific.SetMinorAlign(var AAlign: TdxLayoutRealAlign; AValue: TdxLayoutAlignAbs);
begin
  AAlign.Vert := TdxLayoutRealAlignVert(AValue);
end;

procedure TdxLayoutGroupViewInfoSpecific.CorrectMajorAlignForLocale(var AAlign: TdxLayoutRealAlign);
begin
  AAlign.Horz := GroupViewInfo.GetDropHorzAlignForLocale(AAlign.Horz);
end;

procedure TdxLayoutGroupViewInfoSpecific.CorrectMinorAlignForLocale(var AAlign: TdxLayoutRealAlign);
begin
// do nothing
end;

function TdxLayoutGroupViewInfoSpecific.CanDrawSpecificControls: Boolean;
begin
  Result := False;
end;

procedure TdxLayoutGroupViewInfoSpecific.DrawSpecificControls(ACanvas: TcxCanvas);
begin
// do nothing
end;

function TdxLayoutGroupViewInfoSpecific.GetMaxItemsMajorSize(AIsMinWidth: Boolean): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to ItemViewInfoCount - 1 do
    if AIsMinWidth then
      Result := Max(Result, GetItemMinMajorSize(ItemViewInfos[I]))
    else
      Result := Max(Result, GetItemOriginalMajorSize(ItemViewInfos[I]));
end;


function TdxLayoutGroupViewInfoSpecific.GetMaxItemsMinorSize(AIsMinSize: Boolean): Integer;
var
  I: Integer;
begin
  Result := 0;

  for I := 0 to ItemViewInfoCount - 1 do
    if AIsMinSize then
      Result := Max(Result, GetItemMinMinorSize(ItemViewInfos[I]))
    else
      Result := Max(Result, GetItemOriginalMinorSize(ItemViewInfos[I]));
end;


function TdxLayoutGroupViewInfoSpecific.GetMinorSize(ACalcSizeType: TdxLayoutCalcSizeType): Integer;
begin
  if not GroupViewInfo.ContainerViewInfo.FIsOccupiedSizeCalculating and GroupViewInfo.AllowMinorScroll and
    (ACalcSizeType in [cstMin, cstOriginal]) then
//  ((ACalcSizeType = cstMin) or (Group.ScrollOptions.MinorScroll = smIndependent)) then
    Result := dxLayoutItemControlDefaultMinSize
  else
    Result := GetMaxItemsMinorSize(ACalcSizeType = cstMin);
end;

function TdxLayoutGroupViewInfoSpecific.GetMajorSize(ACalcSizeType: TdxLayoutCalcSizeType): Integer;
var
  AIsFirstItem: Boolean;
  I: Integer;
  AItemViewInfo: TdxCustomLayoutItemViewInfo;
begin
  if not GroupViewInfo.ContainerViewInfo.FIsOccupiedSizeCalculating and GroupViewInfo.AllowMajorScroll and
    (ACalcSizeType in [cstMin, cstOriginal]) then
//    ((ACalcSizeType = cstMin) or (Group.ScrollOptions.MajorScroll = smIndependent)) then
    Result := dxLayoutItemControlDefaultMinSize
  else
  begin
    Result := 0;
    AIsFirstItem := True;
    for I := 0 to ItemViewInfoCount - 1 do
    begin
      AItemViewInfo := ItemViewInfos[I];
      if GetMajorAlign(AItemViewInfo.Align) <> aaCenter then
      begin
        if not AIsFirstItem and not ((ACalcSizeType = cstMin) and IsMeasureMinWidthWithWrapItems) then
          Inc(Result, ItemOffset);
        if ACalcSizeType = cstMin then
        begin
          if IsMeasureMinWidthWithWrapItems then
            Result := Max(Result, GetItemMinMajorSize(AItemViewInfo))
          else
            Inc(Result, GetItemMinMajorSize(AItemViewInfo))
        end  
        else
          if GetMajorAlign(AItemViewInfo.Align) = aaClient then
            Inc(Result, Max(GetItemMinMajorSize(AItemViewInfo), GetItemOriginalMajorSize(AItemViewInfo)))
          else
            Inc(Result, GetItemOriginalMajorSize(AItemViewInfo));
        AIsFirstItem := False;
      end;
    end;
    for I := 0 to ItemViewInfoCount - 1 do
    begin
      AItemViewInfo := ItemViewInfos[I];
      if GetMajorAlign(AItemViewInfo.Align) = aaCenter then
        if ACalcSizeType = cstMin then
          Result := Max(Result, GetItemMinMajorSize(AItemViewInfo))
        else
          Result := Max(Result, GetItemOriginalMajorSize(AItemViewInfo))
    end;
  end;
end;

procedure TdxLayoutGroupViewInfoSpecific.CorrectDropAreaPart(const P: TPoint; var AAreaPart: TdxLayoutDropAreaPart);
begin
// do nothing
end;

function TdxLayoutGroupViewInfoSpecific.GetDropExactItem(const P: TPoint): TdxCustomLayoutItem;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to GroupViewInfo.ItemViewInfoCount - 1 do
  begin
    if PtInRect(GroupViewInfo.ItemViewInfos[I].Bounds, P) then
    begin
      Result := GroupViewInfo.ItemViewInfos[I].Item;
      Break;
    end
  end;
end;

function TdxLayoutGroupViewInfoSpecific.GetDropNearestItem(const P: TPoint): TdxCustomLayoutItem;
var
  I: Integer;
  R: TRect;
  AItem: TdxCustomLayoutItem;
  AMinDistance, ADistance: Integer;
begin
  Result := nil;
  AMinDistance := MaxInt;
  for I := 0 to GroupViewInfo.ItemViewInfoCount - 1 do
  begin
    AItem := GroupViewInfo.ItemViewInfos[I].Item;
    R := GetItemEnlargedBounds(AItem);
    if PtInRect(R, P) then
    begin
      Result := AItem;
      Break;
    end
    else
    begin
      ADistance := Min(Abs(GetMajorValue(R.TopLeft) - GetMajorValue(P)), Abs(GetMajorValue(R.BottomRight) - GetMajorValue(P)));
      if ADistance < AMinDistance then
      begin
        AMinDistance := ADistance;
        Result := AItem;
      end;
    end;
  end;
end;

procedure TdxLayoutGroupViewInfoSpecific.MakeVisible(const ARect: TRect; AFully: Boolean);
var
  ANewScrollPos: Integer;
begin
  ANewScrollPos := GetNewScrollPosMajor(ARect, AFully, GroupViewInfo.GetScrollPos.Major);
  GroupViewInfo.DoMajorScroll(nil, scPosition, ANewScrollPos);

  ANewScrollPos := GetNewScrollPosMinor(ARect, AFully, GroupViewInfo.GetScrollPos.Minor);
  GroupViewInfo.DoMinorScroll(nil, scPosition, ANewScrollPos);
end;

function TdxLayoutGroupViewInfoSpecific.GetNewScrollPosMajor(const ARect: TRect; AFully: Boolean; AScrollPos: Integer): Integer;
var
  AAbsRect, AAbsItemsAreaBounds: TdxAbsRect;
  AOffset: Integer;
begin
  Result := AScrollPos;
  AOffset := 0;
  AAbsRect := GetAbsRect(ARect);
  AAbsItemsAreaBounds := GetAbsRect(GroupViewInfo.ItemsAreaBounds);
  if AFully then
  begin
    if AAbsRect.NearMajor < AAbsItemsAreaBounds.NearMajor then
      AOffset := AAbsRect.NearMajor - AAbsItemsAreaBounds.NearMajor
    else
      if AAbsRect.FarMajor > AAbsItemsAreaBounds.FarMajor then
        AOffset := Min(AAbsRect.FarMajor - AAbsItemsAreaBounds.FarMajor, AAbsRect.NearMajor - AAbsItemsAreaBounds.NearMajor);
  end
  else
    if AAbsRect.NearMajor > AAbsItemsAreaBounds.FarMajor then
      AOffset := AAbsRect.FarMajor - AAbsItemsAreaBounds.FarMajor
    else
      if AAbsRect.FarMajor < AAbsItemsAreaBounds.FarMajor then
        AOffset := AAbsRect.FarMajor - AAbsItemsAreaBounds.FarMajor;
  if GroupViewInfo.UseRightToLeftAlignment then
    AOffset := - AOffset;
  Result := Result + AOffset;
end;

function TdxLayoutGroupViewInfoSpecific.GetNewScrollPosMinor(const ARect: TRect; AFully: Boolean; AScrollPos: Integer): Integer;
var
  AAbsRect, AAbsItemsAreaBounds: TdxAbsRect;
  AOffset: Integer;
begin
  Result := AScrollPos;
  AOffset := 0;
  AAbsRect := GetAbsRect(ARect);
  AAbsItemsAreaBounds := GetAbsRect(GroupViewInfo.ItemsAreaBounds);
  if AFully then
  begin
    if AAbsRect.NearMinor < AAbsItemsAreaBounds.NearMinor then
        AOffset := AAbsRect.NearMinor - AAbsItemsAreaBounds.NearMinor
    else
      if AAbsRect.FarMinor > AAbsItemsAreaBounds.FarMinor then
        AOffset := Min(AAbsRect.FarMinor - AAbsItemsAreaBounds.FarMinor, AAbsRect.NearMinor - AAbsItemsAreaBounds.NearMinor);
  end
  else
    if AAbsRect.NearMinor > AAbsItemsAreaBounds.FarMinor then
      AOffset := AAbsRect.FarMinor - AAbsItemsAreaBounds.FarMinor
    else
      if AAbsRect.FarMinor < AAbsItemsAreaBounds.NearMinor then
        AOffset := AAbsRect.NearMinor - AAbsItemsAreaBounds.NearMinor;
  if GroupViewInfo.UseRightToLeftAlignment then
    AOffset := - AOffset;
  Result := Result + AOffset;
end;

procedure TdxLayoutGroupViewInfoSpecific.Reset;
begin
// do nothing
end;

function TdxLayoutGroupViewInfoSpecific.GetDropExactItemInRow(const P: TPoint): TdxCustomLayoutItem;
var
  I: Integer;
  AItem: TdxCustomLayoutItem;
  R: TRect;
begin
  Result := nil;
  for I := 0 to GroupViewInfo.ItemViewInfoCount - 1 do
  begin
    AItem := GroupViewInfo.ItemViewInfos[I].Item;
    R := GetItemEnlargedBounds(AItem);
    if PtInRect(R, P) then
    begin
      Result := AItem;
      Break;
    end
  end;
end;

function TdxLayoutGroupViewInfoSpecific.GetDropAlignOutsideArea(const ADefaultAlign: TdxLayoutRealAlign; const ABounds: TRect; const ADropAreaInfo: TdxLayoutDragDropInfo): TdxLayoutRealAlign;
var
  ACenter: TRect;
begin
  Result := ADefaultAlign;
  ACenter := dxLayoutGetCenterAreaBounds(ABounds);

  if (Result.Horz = ahClient) or (LayoutDirection = ldHorizontal) and (ADropAreaInfo.DropAreaPart in [apTop, apBottom]) then
  begin
    if (ADropAreaInfo.DropClientPoint.X < ACenter.Left) {or (ADropAreaInfo.DropClientPoint.X > ACenter.Right) and (LayoutDirection = ldHorizontal)} then
      Result.Horz := ahLeft
    else
      if ADropAreaInfo.DropClientPoint.X > ACenter.Right then
        Result.Horz := ahRight
      else
        Result.Horz := ADefaultAlign.Horz;
  end;

  if Result.Vert = avClient then
  begin
    if (ADropAreaInfo.DropClientPoint.Y < ACenter.Top) or (ADropAreaInfo.DropClientPoint.Y > ACenter.Bottom) and (LayoutDirection = ldVertical) then
      Result.Vert := avTop
    else
      if ADropAreaInfo.DropClientPoint.Y > ACenter.Bottom then
        Result.Vert := avBottom
      else
        Result.Vert := ADefaultAlign.Vert;
  end;
end;

function TdxLayoutGroupViewInfoSpecific.GetDropAlignOutsideItem(const ADropAreaInfo: TdxLayoutDragDropInfo): TdxLayoutRealAlign;
var
  AItemBounds: TRect;
  AAbsItemBounds, AAbsCenter: TdxAbsRect;
begin
  if ADropAreaInfo.DestinationItem.IsRoot then
    AItemBounds := ADropAreaInfo.DestinationItem.AsGroup.ViewInfo.ItemsAreaBounds
  else
    AItemBounds := ADropAreaInfo.DestinationItem.ViewInfo.Bounds;
  AAbsItemBounds := GetAbsRect(AItemBounds);
  AAbsCenter := GetAbsRect(dxLayoutGetCenterAreaBounds(AItemBounds));

  // Proper Align
  if IsDropPositionHasProperAlign(ADropAreaInfo) and (AAbsItemBounds.Size.Major > dxLayoutItemControlDefaultMinSize) then
  begin
    if GetMajorValue(ADropAreaInfo.DropClientPoint) < AAbsCenter.NearMajor then
    begin
      SetMajorAlign(Result, aaNear);
      CorrectMajorAlignForLocale(Result);
    end
    else
      if GetMajorValue(ADropAreaInfo.DropClientPoint) > AAbsCenter.FarMajor then
      begin
        SetMajorAlign(Result, aaFar);
        CorrectMajorAlignForLocale(Result);
      end
      else
        SetMajorAlign(Result, aaClient)
  end
  else
    if (GetMajorAlign(ADropAreaInfo.DestinationItem.RealAlign) = aaClient) and
       (AAbsItemBounds.Size.Major > dxLayoutItemControlDefaultMinSize) and
       (dxIsValueInDiapason(GetMajorValue(ADropAreaInfo.DropClientPoint), AAbsCenter.NearMajor, AAbsCenter.FarMajor)) then
      SetMajorAlign(Result, aaClient)
    else
      if GetMajorAlign(ADropAreaInfo.DestinationItem.RealAlign) <> aaClient then
        SetMajorAlign(Result, GetMajorAlign(ADropAreaInfo.DestinationItem.RealAlign))
      else
        SetMajorAlign(Result, aaNear);

  // Opposite Align
  if IsDropPositionHasOppositeAlign(ADropAreaInfo) and (GetAbsRect(GroupViewInfo.ItemsAreaBounds).Size.Minor = AAbsItemBounds.Size.Minor) then
  begin
    if GetMinorValue(ADropAreaInfo.DropClientPoint) < AAbsCenter.NearMinor then
    begin
      SetMinorAlign(Result, aaNear);
      CorrectMinorAlignForLocale(Result);
    end
    else
      if GetMinorValue(ADropAreaInfo.DropClientPoint) > AAbsCenter.FarMinor then
      begin
        SetMinorAlign(Result, aaFar);
        CorrectMinorAlignForLocale(Result);
      end
      else
        SetMinorAlign(Result, aaClient);
  end
  else
    if (GetMinorAlign(ADropAreaInfo.DestinationItem.RealAlign) = aaClient) and
       (AAbsItemBounds.Size.Minor > dxLayoutItemControlDefaultMinSize) and
       dxIsValueInDiapason(GetMinorValue(ADropAreaInfo.DropClientPoint), AAbsCenter.NearMinor, AAbsCenter.FarMinor) then
      SetMinorAlign(Result, aaClient)
    else
      if GetMinorAlign(ADropAreaInfo.DestinationItem.RealAlign) <> aaClient then
        SetMinorAlign(Result, GetMinorAlign(ADropAreaInfo.DestinationItem.RealAlign))
      else
        SetMinorAlign(Result, aaNear);
end;

{
function TdxLayoutGroupViewInfoSpecific.GetDropAlignOutsideRoot(const ADropAreaInfo: TdxLayoutDragDropInfo): TdxLayoutAlign;
begin
  raise EdxException.Create('TdxLayoutGroupViewInfoSpecific.GetDropAlignOutsideRoot fails');
end;
}

function TdxLayoutGroupViewInfoSpecific.GetDropAlignInsideARea(const ADefaultAlign: TdxLayoutRealAlign; const ABounds: TRect; const ADropAreaInfo: TdxLayoutDragDropInfo): TdxLayoutRealAlign;
var
  ACenter: TRect;
begin
  ACenter := dxLayoutGetCenterAreaBounds(ABounds);

  if ABounds.Width < ADropAreaInfo.SourceItemSize.Width then
    Result.Horz := ADefaultAlign.Horz
  else
    if ADropAreaInfo.DropClientPoint.X < ACenter.Left then
      Result.Horz := GroupViewInfo.GetDropHorzAlignForLocale(ahLeft)
    else
      if ADropAreaInfo.DropClientPoint.X > ACenter.Right then
        Result.Horz := GroupViewInfo.GetDropHorzAlignForLocale(ahRight)
      else
        Result.Horz := ahClient;

  if ABounds.Height < ADropAreaInfo.SourceItemSize.Height then
    Result.Vert := ADefaultAlign.Vert
  else
    if ADropAreaInfo.DropClientPoint.Y < ACenter.Top then
      Result.Vert := avTop
    else
      if ADropAreaInfo.DropClientPoint.Y > ACenter.Bottom then
        Result.Vert := avBottom
      else
        Result.Vert := avClient;
end;

function TdxLayoutGroupViewInfoSpecific.GetDropAreaPart(var P: TPoint): TdxLayoutDropAreaPart;

  function IsPointInArea: Boolean;
  begin
    Result := PtInRect(GroupViewInfo.ItemsAreaBounds, P);
    if not Result and GroupViewInfo.Group.IsRoot then
    begin
       Result := GetDropExactItem(GetDropNearestPoint(P)) = nil;
       if Result then
         P := GetDropNearestPoint(P);
    end;
  end;

begin
  if IsPointInArea then
  begin
    if PtInRect(GetLastChildDropArea, P) then
      Result := apLastChild
    else
      if GetDropExactItemInRow(P) <> nil then
        Result := apNewLayout
      else
        Result := apBetween;
  end
  else
    Result := apNone;
end;

function TdxLayoutGroupViewInfoSpecific.GetDropExpectedBounds(const ADropAreaInfo: TdxLayoutDragDropInfo): TRect;
var
  R: TRect;
begin
  case ADropAreaInfo.DropAreaPart of
    apNone:
      Result := cxNullRect;
    apLeft..apBottom:
      Result := GetDropRectOutsideItem(ADropAreaInfo);
    apBetween:
      Result := GetDropRectInsideRect(GetBetweenItemsDropArea(ADropAreaInfo.DropClientPoint), ADropAreaInfo);
    apNewLayout:
    begin
      R := GetNewLayoutDropArea(ADropAreaInfo.DestinationItem);
      if GetMajorValue(ADropAreaInfo.SourceItemSize) > GetAbsRect(R).Size.Major then
        R := GetNewLayoutExtendedDropArea(ADropAreaInfo.DestinationItem);
      Result := GetDropRectInsideRect(R, ADropAreaInfo);
    end;
    apLastChild:
      Result := GetDropRectInsideRect(GetLastChildDropArea, ADropAreaInfo);
  else
    raise Exception.Create('GetDropExpectedBounds fails');
  end;
end;

function TdxLayoutGroupViewInfoSpecific.GetDropExpectedAlign(const ADropAreaInfo: TdxLayoutDragDropInfo): TdxLayoutRealAlign;
var
  AItem: TdxCustomLayoutItem;
begin
  Result.Horz := GroupViewInfo.Group.GetHelperClass.GetChildItemsAlignHorz;
  Result.Vert := GroupViewInfo.Group.GetHelperClass.GetChildItemsAlignVert;
  AItem := ADropAreaInfo.DestinationItem;
  case ADropAreaInfo.DropAreaPart of
    apLeft, apTop, apRight, apBottom:
      Result := GetDropAlignOutsideItem(ADropAreaInfo);
    apBetween:
      Result := GetDropAlignOutsideArea(AItem.RealAlign, AItem.ViewInfo.Bounds, ADropAreaInfo);
    apLastChild:
      Result := GetDropAlignInsideArea(Result, GetLastChildDropArea, ADropAreaInfo);
    apNewLayout:
      Result := GetDropAlignInsideArea(AItem.RealAlign, GetNewLayoutDropArea(AItem), ADropAreaInfo);
  end;
end;

function TdxLayoutGroupViewInfoSpecific.GetDropRectOutsideItem(const ADropAreaInfo: TdxLayoutDragDropInfo): TRect;
var
  AItemBounds, AItemExtendedBounds, AWorkRect: TRect;
  AMinSize: Integer;
begin
  if ADropAreaInfo.DestinationItem.IsRoot then
    AItemBounds := GroupViewInfo.ItemsAreaBounds
  else
    AItemBounds := ADropAreaInfo.DestinationItem.ViewInfo.Bounds;
  AItemExtendedBounds := GetItemExtendedBounds(ADropAreaInfo.DestinationItem);
  AMinSize := ADropAreaInfo.DropPartSize * 2;

  if (ADropAreaInfo.ExpectedAlign.Horz = ahClient) and (ADropAreaInfo.DropAreaPart in [apLeft, apRight]) or
    (ADropAreaInfo.ExpectedAlign.Vert = avClient) and (ADropAreaInfo.DropAreaPart in [apTop, apBottom]) then
  begin
    AWorkRect := AItemBounds;
    case ADropAreaInfo.DropAreaPart of
      apLeft:
        AWorkRect.Right := AWorkRect.Right - AWorkRect.Width div 2;
      apRight:
        AWorkRect.Left := AWorkRect.Left + AWorkRect.Width div 2;
      apTop:
        AWorkRect.Bottom := AWorkRect.Bottom - AWorkRect.Height div 2;
      apBottom:
        AWorkRect.Top := AWorkRect.Top + AWorkRect.Height div 2;
    end;
  end
  else
  begin
    if ADropAreaInfo.DestinationItem.IsRoot or
      (ADropAreaInfo.DropAreaPart in [apLeft, apRight]) and (LayoutDirection = ldHorizontal) or
      (ADropAreaInfo.DropAreaPart in [apTop, apBottom]) and (LayoutDirection = ldVertical) then
      AWorkRect := AItemExtendedBounds
    else
      AWorkRect := GetItemEnlargedBounds(ADropAreaInfo.DestinationItem);
    case ADropAreaInfo.DropAreaPart of
      apLeft:
        AWorkRect.Right := Max(AItemBounds.Left, AItemExtendedBounds.Left + AMinSize);
      apRight:
        AWorkRect.Left := Min(AItemBounds.Right, AItemExtendedBounds.Right - AMinSize);
      apTop:
        AWorkRect.Bottom := Max(AItemBounds.Top, AItemExtendedBounds.Top + AMinSize);
      apBottom:
        AWorkRect.Top := Min(AItemBounds.Bottom, AItemExtendedBounds.Bottom - AMinSize);
    end;
  end;
  Result := GetDropRectInsideRect(AWorkRect, ADropAreaInfo);
end;

function TdxLayoutGroupViewInfoSpecific.GetDropRectInsideRect(const ARect: TRect; const ADropAreaInfo: TdxLayoutDragDropInfo): TRect;

  function GetRectVertPart(const ARect: TRect; const ADropAreaInfo: TdxLayoutDragDropInfo): TRect;
  var
    AHeight: Integer;
  begin
    AHeight := Max(Min(ARect.Height, ADropAreaInfo.SourceItemSize.Height), ADropAreaInfo.DropPartSize * 2);

    case ADropAreaInfo.ExpectedAlign.Vert of
      avTop: Result := Rect(ARect.Left, ARect.Top, ARect.Right, ARect.Top + AHeight);
      avBottom: Result := Rect(ARect.Left, ARect.Bottom - AHeight, ARect.Right, ARect.Bottom);
    else
      Result := ARect;
    end;
  end;

  function GetRectHorzPart(const ARect: TRect; const ADropAreaInfo: TdxLayoutDragDropInfo): TRect;
  var
    AWidth: Integer;
  begin
    AWidth := Max(Min(ARect.Width, ADropAreaInfo.SourceItemSize.Width), ADropAreaInfo.DropPartSize * 2);
    case GroupViewInfo.GetDropHorzAlignForLocale(ADropAreaInfo.ExpectedAlign.Horz) of
      ahLeft: Result := Rect(ARect.Left, ARect.Top, ARect.Left + AWidth, ARect.Bottom);
      ahRight: Result := Rect(ARect.Right - AWidth, ARect.Top, ARect.Right, ARect.Bottom);
    else
      Result := ARect;
    end;
  end;

begin
  Result := GetRectHorzPart(GetRectVertPart(ARect, ADropAreaInfo), ADropAreaInfo);
end;

function TdxLayoutGroupViewInfoSpecific.IsDropPositionHasProperAlign(const ADropAreaInfo: TdxLayoutDragDropInfo): Boolean;
begin
  Result := ADropAreaInfo.DropAreaPart in [apTop, apBottom];
end;

function TdxLayoutGroupViewInfoSpecific.IsDropPositionHasOppositeAlign(const ADropAreaInfo: TdxLayoutDragDropInfo): Boolean;
begin
  Result := ADropAreaInfo.DropAreaPart in [apLeft, apRight];
end;

function TdxLayoutGroupViewInfoSpecific.GetDropNearestPoint(const P: TPoint): TPoint;
begin
  Result.X := Max(Min(P.X, GroupViewInfo.ItemsAreaBounds.Right - 1), GroupViewInfo.ItemsAreaBounds.Left + 1);
  Result.Y := Max(Min(P.Y, GroupViewInfo.ItemsAreaBounds.Bottom - 1), GroupViewInfo.ItemsAreaBounds.Top + 1);
end;

function TdxLayoutGroupViewInfoSpecific.GetBetweenItemsDropArea(const P: TPoint): TRect;
var
  I: Integer;
  AItem: TdxCustomLayoutItem;
  R: TRect;
begin
  Result := GroupViewInfo.ItemsAreaBounds;
  for I := 0 to GroupViewInfo.ItemViewInfoCount - 1 do
  begin
    AItem := GroupViewInfo.ItemViewInfos[I].Item;
    R := GetItemEnlargedBounds(AItem);
    if GetMajorValue(P) < GetMajorValue(R.TopLeft) then
      SetMajorFar(Result, Min(GetMajorValue(Result.BottomRight), GetMajorValue(R.TopLeft)));
    if GetMajorValue(P) >= GetMajorValue(R.BottomRight) then
      SetMajorNear(Result, Max(GetMajorValue(Result.TopLeft), GetMajorValue(R.BottomRight)));
  end;
end;

function TdxLayoutGroupViewInfoSpecific.GetLastChildDropArea: TRect;
var
  W, H: Integer;
begin
  Result := GroupViewInfo.ItemsAreaBounds;
  if Result.Width = 0 then
  begin
    W := Min(Result.Left - GroupViewInfo.Bounds.Left, GroupViewInfo.Bounds.Right - Result.Right) div 2;
    Result := Rect(Result.Left - W, Result.Top, Result.Right + W, Result.Bottom)
  end;
  if Result.Height = 0 then
  begin
    H := Min(Result.Top - GroupViewInfo.Bounds.Top, GroupViewInfo.Bounds.Bottom - Result.Bottom) div 2;
    Result := Rect(Result.Left, Result.Top - H, Result.Right, Result.Bottom + H);
  end;
end;

function TdxLayoutGroupViewInfoSpecific.GetNewLayoutDropArea(AItem: TdxCustomLayoutItem): TRect;
begin
  Result := CutItemRect(AItem, GetItemEnlargedBounds(AItem));
end;

function TdxLayoutGroupViewInfoSpecific.GetNewLayoutExtendedDropArea(AItem: TdxCustomLayoutItem): TRect;
begin
  Result := CutItemRect(AItem, GetItemExtendedBounds(AItem));
end;

function TdxLayoutGroupViewInfoSpecific.GetItemEnlargedBounds(AItem: TdxCustomLayoutItem): TRect;
var
  AItemBounds: TdxAbsRect;
begin
  Result := GroupViewInfo.ItemsAreaBounds;
  AItemBounds := GetAbsRect(AItem.ViewInfo.Bounds);
  SetMajorNear(Result, AItemBounds.NearMajor);
  SetMajorFar(Result, AItemBounds.FarMajor);
end;

function TdxLayoutGroupViewInfoSpecific.GetItemExtendedBounds(AItem: TdxCustomLayoutItem): TRect;
var
  I: Integer;
  AItemBounds: TRect;
begin
  Result := GroupViewInfo.ItemsAreaBounds;
  AItemBounds := AItem.ViewInfo.Bounds;
  for I := 0 to GroupViewInfo.ItemViewInfoCount - 1 do
  begin
    if GroupViewInfo.ItemViewInfos[I].Item <> AItem then
    begin
      if GetMajorValue(GroupViewInfo.ItemViewInfos[I].Bounds.BottomRight) <= GetMajorValue(AItemBounds.TopLeft) then
        SetMajorNear(Result, Max(GetMajorValue(Result.TopLeft), GetMajorValue(GroupViewInfo.ItemViewInfos[I].Bounds.BottomRight)));
      if GetMajorValue(GroupViewInfo.ItemViewInfos[I].Bounds.TopLeft) >= GetMajorValue(AItemBounds.BottomRight) then
        SetMajorFar(Result, Min(GetMajorValue(Result.BottomRight), GetMajorValue(GroupViewInfo.ItemViewInfos[I].Bounds.TopLeft)));
    end;
  end;
end;

function TdxLayoutGroupViewInfoSpecific.GetItemsAreaOffset(ASide: TdxLayoutSide): Integer;
begin
  Result := 0;
end;

function TdxLayoutGroupViewInfoSpecific.IsItemMajorSizeUsual(AViewInfo: TdxCustomLayoutItemViewInfo): Boolean;
begin
  Result := (GetMajorAlign(AViewInfo.Align) <> aaClient) or not AViewInfo.IsExpanded;
end;

function TdxLayoutGroupViewInfoSpecific.IsItemMinorSizeUsual(AViewInfo: TdxCustomLayoutItemViewInfo): Boolean;
begin
  Result := (GetMinorAlign(AViewInfo.Align) <> aaClient) or not AViewInfo.IsExpanded;
end;

function TdxLayoutGroupViewInfoSpecific.IsMajorSizeFixed: Boolean;
begin
  Result := False;
end;

function TdxLayoutGroupViewInfoSpecific.IsMeasureMinWidthWithWrapItems: Boolean;
begin
  Result := TdxLayoutDragAndDropState.UseWrapItemsOnMeasureMinWidth and Group.CanWrapItems;
end;

function TdxLayoutGroupViewInfoSpecific.IsMinorSizeFixed: Boolean;
begin
  Result := False;
end;

function TdxLayoutGroupViewInfoSpecific.IsPopupScrollBars: Boolean;
begin
  Result := TcxControlAccess(Group.Container.ItemsParent).IsPopupScrollBars;
end;

function TdxLayoutGroupViewInfoSpecific.IsTouchScrollUIMode: Boolean;
begin
  Result := TcxControlAccess(Group.Container.ItemsParent).IsTouchScrollUIMode;
end;

function TdxLayoutGroupViewInfoSpecific.GetItemsAreaHeight(ACalcSizeType: TdxLayoutCalcSizeType): Integer;
begin
  Result := GetMinorSize(ACalcSizeType);
end;

function TdxLayoutGroupViewInfoSpecific.GetItemsAreaWidth(ACalcSizeType: TdxLayoutCalcSizeType): Integer;
begin
  Result := GetMajorSize(ACalcSizeType);
end;

function TdxLayoutGroupViewInfoSpecific.AllowDrawChild(AChildViewInfo: TdxCustomLayoutItemViewInfo): Boolean;
begin
  Result := True;
end;

function TdxLayoutGroupViewInfoSpecific.AllowChildHasBorder: Boolean;
begin
  Result := True;
end;

procedure TdxLayoutGroupViewInfoSpecific.DoRightToLeftConversion(const AClientBounds: TRect);
var
  I: Integer;
begin
  for I := 0 to ItemViewInfoCount - 1 do
    ItemViewInfos[I].DoRightToLeftConversion(AClientBounds);
end;

function TdxLayoutGroupViewInfoSpecific.GetChildInplaceRenameBounds(AChildViewInfo: TdxCustomLayoutItemViewInfo): TRect;
begin
  Result := cxNullRect;
end;

function TdxLayoutGroupViewInfoSpecific.GetDefaultItemControlAreaAlignment: TdxLayoutItemControlAreaAlignment;
begin
  if Container.IsAutoControlAlignment then
    Result := catAuto
  else
    Result := catNone;
end;

function TdxLayoutGroupViewInfoSpecific.ProcessDialogChar(ACharCode: Word): Boolean;
begin
  Result := False;
end;

function TdxLayoutGroupViewInfoSpecific.ProcessDialogKey(ACharCode: Word; AKeyData: Integer; AFocusedItem: TdxCustomLayoutItem): Boolean;
begin
  Result := False;
end;

{ TdxLayoutGroupHorizontalSpecific }

procedure TdxLayoutGroupViewInfoHorizontalSpecific.CalculateItemsBounds(AItemsAreaBounds: TRect);

  procedure AssignItemsBounds;
  var
    AViewInfo: TItemInfo;
  begin
    for AViewInfo in FItemInfos do
      AViewInfo.ViewInfo.SetBounds(GetRectFromAbsRect(AViewInfo.AbsBounds));
  end;

  procedure CalculateItemsMajorSizes;
  var
    I: Integer;
  begin
    for I := 0 to ItemViewInfoCount - 1 do
    begin
      FItemInfos[I].MajorAlign := GetMajorAlign(FItemInfos[I].ViewInfo.Align);
      FItemInfos[I].MinMajorSize := GetItemMinMajorSize(FItemInfos[I].ViewInfo);
      FItemInfos[I].MaxMajorSize := GetItemMaxMajorSize(FItemInfos[I].ViewInfo);
      FItemInfos[I].OriginalMajorSize := GetItemOriginalMajorSize(FItemInfos[I].ViewInfo);
      FItemInfos[I].SufficientMajorSize := GetItemSufficientMajorSize(FItemInfos[I].ViewInfo);
      FItemInfos[I].Calculated := False;
    end;
  end;

  procedure CalculateItemsMinorSizes;
  var
    I: Integer;
  begin
    for I := 0 to ItemViewInfoCount - 1 do
    begin
      FItemInfos[I].MinorAlign := GetMinorAlign(FItemInfos[I].ViewInfo.Align);
      FItemInfos[I].OriginalMinorSize := GetItemOriginalMinorSize(FItemInfos[I].ViewInfo);
      FItemInfos[I].SufficientMinorSize := GetItemSufficientMinorSize(FItemInfos[I].ViewInfo);
    end;
  end;

var
  AAbsRect: TdxAbsRect;
  I: Integer;
begin
  AAbsRect := GetAbsRect(AItemsAreaBounds);

  SetLength(FItemInfos, ItemViewInfoCount);
  for I := 0 to ItemViewInfoCount - 1 do
  begin
    FItemInfos[I].ViewInfo := ItemViewInfos[I];
    FItemInfos[I].PrevBounds := FItemInfos[I].ViewInfo.Bounds;
    ZeroMemory(@FItemInfos[I].AbsBounds, SizeOf(TdxAbsRect));
    FItemInfos[I].ViewInfo.Reset;
    if FItemInfos[I].ViewInfo.Item.Width > 0 then
      FItemInfos[I].ViewInfo.SetBounds(cxNullRect)
    else
      FItemInfos[I].ViewInfo.SetBounds(Rect(FItemInfos[I].ViewInfo.Bounds.Left, 0, FItemInfos[I].ViewInfo.Bounds.Right, 0));
  end;

  CalculateItemsMajorSizes;
  CalculateItemsMajorBounds(AAbsRect);
  AssignItemsBounds;
  CalculateItemsMinorSizes;
  CalculateItemsMinorBounds(AAbsRect);
  CalculateItemViewInfos;
end;

function TdxLayoutGroupViewInfoHorizontalSpecific.AllowMajorScroll: Boolean;
begin
  Result := GroupViewInfo.IsWidthLimited;
end;

function TdxLayoutGroupViewInfoHorizontalSpecific.AllowMinorScroll: Boolean;
begin
  Result := GroupViewInfo.IsHeightLimited;
end;

procedure TdxLayoutGroupViewInfoHorizontalSpecific.InitializeMajorScrollBar(AContentSize, AClientSize: Integer);
var
  R: TRect;
  AScrollBarSize: Size;
begin
  GroupViewInfo.FMajorScrollBar.Kind := sbHorizontal;
  AScrollBarSize := GroupViewInfo.FMajorScrollBar.GetDefaultSize;
  R := GroupViewInfo.ItemsAreaBounds;
  R.Top := R.Bottom;
  if IsPopupScrollBars then
    R.Top := R.Top - AScrollBarSize.Height;
  if not IsTouchScrollUIMode then
    R.Top := R.Top + GroupViewInfo.LayoutLookAndFeel.GetGroupBorderOffset(GroupViewInfo.Item.Container, sdBottom, GroupViewInfo.CaptionSide);
  R.Bottom := R.Top + AScrollBarSize.Height;
  GroupViewInfo.FMajorScrollBarBounds := R;
end;

procedure TdxLayoutGroupViewInfoHorizontalSpecific.InitializeMinorScrollBar(AContentSize, AClientSize: Integer);
var
  R: TRect;
  AScrollBarSize: Size;
begin
  GroupViewInfo.FMinorScrollBar.Kind := sbVertical;
  AScrollBarSize := GroupViewInfo.FMinorScrollBar.GetDefaultSize;
  R := GroupViewInfo.ItemsAreaBounds;
  R.Left := R.Right;
  if IsPopupScrollBars then
    R.Left := R.Left - AScrollBarSize.Width;
  if not IsTouchScrollUIMode then
    R.Left := R.Left + GroupViewInfo.LayoutLookAndFeel.GetGroupBorderOffset(GroupViewInfo.Item.Container, sdRight, GroupViewInfo.CaptionSide);
  R.Right := R.Left + AScrollBarSize.Width;
  GroupViewInfo.FMinorScrollBarBounds := R;
end;

function TdxLayoutGroupViewInfoHorizontalSpecific.CutItemRect(AItem: TdxCustomLayoutItem; const R: TRect): TRect;
begin
  case AItem.GetRealAlignVert of
    avTop:
      Result := Rect(R.Left, AItem.ViewInfo.Bounds.Bottom, R.Right, R.Bottom);
    avBottom:
      Result := Rect(R.Left, R.Top, R.Right, AItem.ViewInfo.Bounds.Top);
  else
    Result := R;
  end;
end;

function TdxLayoutGroupViewInfoHorizontalSpecific.GetLastChildDropArea: TRect;
var
  I: Integer;
begin
  Result := inherited GetLastChildDropArea;
  for I := 0 to GroupViewInfo.ItemViewInfoCount - 1 do
  begin
    case GroupViewInfo.GetDropHorzAlignForLocale(GroupViewInfo.ItemViewInfos[I].Item.GetRealAlignHorz) of
      ahLeft: Result.Left := Max(GroupViewInfo.ItemViewInfos[I].Bounds.Right, Result.Left);
      ahRight: Result.Right := Min(GroupViewInfo.ItemViewInfos[I].Bounds.Left, Result.Right);
    end;
  end;
end;

function TdxLayoutGroupViewInfoHorizontalSpecific.GetDropActionType(AAreaPart: TdxLayoutDropAreaPart): TdxLayoutActionType;
begin
  if AAreaPart in [apLeft, apRight, apAfter, apBefore] then
    Result := atInsert
  else
    Result := atCreateGroup;
end;

function TdxLayoutGroupViewInfoHorizontalSpecific.GetItemOriginalMajorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer;
begin
  Result := AViewInfo.UsualWidth;
end;

function TdxLayoutGroupViewInfoHorizontalSpecific.GetItemOriginalMinorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer;
begin
  Result := AViewInfo.UsualHeight;
end;

function TdxLayoutGroupViewInfoHorizontalSpecific.GetItemSufficientMinorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer;
begin
  Result := AViewInfo.SufficientHeight;
end;

function TdxLayoutGroupViewInfoHorizontalSpecific.GetItemSufficientMajorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer;
begin
  Result := AViewInfo.SufficientWidth;
end;

function TdxLayoutGroupViewInfoHorizontalSpecific.GetItemMinMinorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer;
begin
  Result := AViewInfo.MinHeight;
end;

function TdxLayoutGroupViewInfoHorizontalSpecific.GetItemMinMajorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer;
begin
  if TdxLayoutDragAndDropState.UseWrapItemsOnMeasureMinWidth then
    Result := AViewInfo.GetMinWidthWithWrapItems
  else
    Result := AViewInfo.MinWidth;
end;

function TdxLayoutGroupViewInfoHorizontalSpecific.GetItemMaxMinorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer;
begin
  Result := AViewInfo.MaxHeight;
end;

function TdxLayoutGroupViewInfoHorizontalSpecific.GetItemMaxMajorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer;
begin
  Result := AViewInfo.MaxWidth;
end;

function TdxLayoutGroupViewInfoHorizontalSpecific.GetItemsAreaOffset(ASide: TdxLayoutSide): Integer;
begin
  Result := 0;
  if (GroupViewInfo.FMajorScrollBar <> nil) and (ASide = sdBottom) then
  begin
    if not IsTouchScrollUIMode then
    begin
      if not IsPopupScrollBars then
        Inc(Result, GroupViewInfo.FMajorScrollBarBounds.Height);
      Inc(Result, GroupViewInfo.LayoutLookAndFeel.GetGroupBorderOffset(Container, sdBottom, GroupViewInfo.CaptionSide));
    end;
  end;
  if (GroupViewInfo.FMinorScrollBar <> nil) and (ASide = sdRight) then
  begin
    if not IsTouchScrollUIMode then
    begin
      if not IsPopupScrollBars then
        Inc(Result, GroupViewInfo.FMinorScrollBarBounds.Width);
      Inc(Result, GroupViewInfo.LayoutLookAndFeel.GetGroupBorderOffset(Container, sdRight, GroupViewInfo.CaptionSide));
    end
  end;
end;

function TdxLayoutGroupViewInfoHorizontalSpecific.IsMajorSizeFixed: Boolean;
begin
  Result := Group.IsWidthFixed;
end;

function TdxLayoutGroupViewInfoHorizontalSpecific.IsMinorSizeFixed: Boolean;
begin
  Result := Group.IsHeightFixed;
end;

function TdxLayoutGroupViewInfoHorizontalSpecific.IsAtInsertionPos(const R: TRect;
  const P: TPoint): Boolean;
begin
  Result := P.X < (R.Left + R.Right) div 2;
end;

{ TdxLayoutGroupViewInfoVerticalSpecific }

function TdxLayoutGroupViewInfoVerticalSpecific.AllowMajorScroll: Boolean;
begin
  Result := GroupViewInfo.IsHeightLimited;
end;

function TdxLayoutGroupViewInfoVerticalSpecific.AllowMinorScroll: Boolean;
begin
  Result := GroupViewInfo.IsWidthLimited;
end;

procedure TdxLayoutGroupViewInfoVerticalSpecific.InitializeMajorScrollBar(AContentSize, AClientSize: Integer);
var
  R: TRect;
  AScrollBarSize: Size;
begin
  GroupViewInfo.FMajorScrollBar.Kind := sbVertical;
  AScrollBarSize := GroupViewInfo.FMajorScrollBar.GetDefaultSize;
  R := GroupViewInfo.ItemsAreaBounds;
  R.Left := R.Right;
  if IsPopupScrollBars then
    R.Left := R.Left - AScrollBarSize.Width;
  if not IsTouchScrollUIMode then
    R.Left := R.Left + GroupViewInfo.LayoutLookAndFeel.GetGroupBorderOffset(GroupViewInfo.Item.Container, sdRight, GroupViewInfo.CaptionSide);
  R.Right := R.Left + AScrollBarSize.Width;
  GroupViewInfo.FMajorScrollBarBounds := R;
end;

procedure TdxLayoutGroupViewInfoVerticalSpecific.InitializeMinorScrollBar(AContentSize, AClientSize: Integer);
var
  R: TRect;
  AScrollBarSize: Size;
begin
  GroupViewInfo.FMinorScrollBar.Kind := sbHorizontal;
  AScrollBarSize := GroupViewInfo.FMinorScrollBar.GetDefaultSize;
  R := GroupViewInfo.ItemsAreaBounds;
  R.Top := R.Bottom;
  if IsPopupScrollBars then
    R.Top := R.Top - AScrollBarSize.Height;
  if not IsTouchScrollUIMode then
    R.Top := R.Top + GroupViewInfo.LayoutLookAndFeel.GetGroupBorderOffset(GroupViewInfo.Item.Container, sdBottom, GroupViewInfo.CaptionSide);
  R.Bottom := R.Top + AScrollBarSize.Height;
  GroupViewInfo.FMinorScrollBarBounds := R;
end;

function TdxLayoutGroupViewInfoVerticalSpecific.GetRectFromAbsRect(const R: TdxAbsRect): TRect;
begin
  Result := Rect(R.NearMinor, R.NearMajor, R.FarMinor, R.FarMajor);
end;

function TdxLayoutGroupViewInfoVerticalSpecific.GetMajorValue(const P: TPoint): Integer;
begin
  Result := P.Y
end;

function TdxLayoutGroupViewInfoVerticalSpecific.GetMinorValue(const P: TPoint): Integer;
begin
  Result := P.X
end;

function TdxLayoutGroupViewInfoVerticalSpecific.GetMajorValue(const ASize: TSize): Integer;
begin
  Result := ASize.Height;
end;

function TdxLayoutGroupViewInfoVerticalSpecific.GetMinorValue(const ASize: TSize): Integer;
begin
  Result := ASize.Width;
end;

function TdxLayoutGroupViewInfoVerticalSpecific.GetMajorAlign(const AAlign: TdxLayoutRealAlign): TdxLayoutAlignAbs;
begin
  Result := TdxLayoutAlignAbs(AAlign.Vert);
end;

function TdxLayoutGroupViewInfoVerticalSpecific.GetMinorAlign(const AAlign: TdxLayoutRealAlign): TdxLayoutAlignAbs;
begin
  Result := TdxLayoutAlignAbs(AAlign.Horz);
end;

procedure TdxLayoutGroupViewInfoVerticalSpecific.SetMajorNear(var R: TRect; AValue: Integer);
begin
  R.Top := AValue;
end;

procedure TdxLayoutGroupViewInfoVerticalSpecific.SetMajorFar(var R: TRect; AValue: Integer);
begin
  R.Bottom := AValue;
end;

procedure TdxLayoutGroupViewInfoVerticalSpecific.SetMajorAlign(var AAlign: TdxLayoutRealAlign; AValue: TdxLayoutAlignAbs);
begin
  AAlign.Vert := TdxLayoutRealAlignVert(AValue);
end;

procedure TdxLayoutGroupViewInfoVerticalSpecific.SetMinorAlign(var AAlign: TdxLayoutRealAlign; AValue: TdxLayoutAlignAbs);
begin
  AAlign.Horz := TdxLayoutRealAlignHorz(AValue);
end;

procedure TdxLayoutGroupViewInfoVerticalSpecific.CorrectMajorAlignForLocale(var AAlign: TdxLayoutRealAlign);
begin
// do nothing
end;

procedure TdxLayoutGroupViewInfoVerticalSpecific.CorrectMinorAlignForLocale(var AAlign: TdxLayoutRealAlign);
begin
  AAlign.Horz := GroupViewInfo.GetDropHorzAlignForLocale(AAlign.Horz);
end;

function TdxLayoutGroupViewInfoVerticalSpecific.CutItemRect(AItem: TdxCustomLayoutItem; const R: TRect): TRect;
begin
  case AItem.GetRealAlignHorz of
    ahLeft:
      Result := Rect(AItem.ViewInfo.Bounds.Right, R.Top, R.Right, R.Bottom);
    ahRight:
      Result := Rect(R.Left, R.Top, AItem.ViewInfo.Bounds.Left, R.Bottom);
  else
    Result := R;
  end;
end;

function TdxLayoutGroupViewInfoVerticalSpecific.GetLastChildDropArea: TRect;
var
  I: Integer;
begin
  Result := inherited GetLastChildDropArea;
  for I := 0 to GroupViewInfo.ItemViewInfoCount - 1 do
  begin
    if GroupViewInfo.ItemViewInfos[I].Item.GetRealAlignVert = avTop then
      Result.Top := Max(GroupViewInfo.ItemViewInfos[I].Bounds.Bottom, Result.Top);
    if GroupViewInfo.ItemViewInfos[I].Item.GetRealAlignVert = avBottom then
      Result.Bottom := Min(GroupViewInfo.ItemViewInfos[I].Bounds.Top, Result.Bottom);
  end;
end;

function TdxLayoutGroupViewInfoVerticalSpecific.GetDropActionType(AAreaPart: TdxLayoutDropAreaPart): TdxLayoutActionType;
begin
  if AAreaPart in [apTop, apBottom, apAfter, apBefore] then
    Result := atInsert
  else
    Result := atCreateGroup;
end;

function TdxLayoutGroupViewInfoVerticalSpecific.IsDropPositionHasProperAlign(const ADropAreaInfo: TdxLayoutDragDropInfo): Boolean;
begin
  Result := ADropAreaInfo.DropAreaPart in [apLeft, apRight];
end;

function TdxLayoutGroupViewInfoVerticalSpecific.IsDropPositionHasOppositeAlign(const ADropAreaInfo: TdxLayoutDragDropInfo): Boolean;
begin
  Result := ADropAreaInfo.DropAreaPart in [apTop, apBottom];
end;

function TdxLayoutGroupViewInfoVerticalSpecific.GetItemOriginalMinorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer;
begin
  Result := AViewInfo.UsualWidth;
end;

function TdxLayoutGroupViewInfoVerticalSpecific.GetItemSufficientMinorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer;
begin
  Result := AViewInfo.SufficientWidth;
end;

function TdxLayoutGroupViewInfoVerticalSpecific.GetItemSufficientMajorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer;
begin
  Result := AViewInfo.SufficientHeight;
end;

function TdxLayoutGroupViewInfoVerticalSpecific.GetItemOriginalMajorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer;
begin
  Result := AViewInfo.UsualHeight;
end;

function TdxLayoutGroupViewInfoVerticalSpecific.GetItemMinMinorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer;
begin
  if TdxLayoutDragAndDropState.UseWrapItemsOnMeasureMinWidth then
    Result := AViewInfo.GetMinWidthWithWrapItems
  else
    Result := AViewInfo.MinWidth;
end;

function TdxLayoutGroupViewInfoVerticalSpecific.GetItemMinMajorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer;
begin
  Result := AViewInfo.MinHeight;
end;

function TdxLayoutGroupViewInfoVerticalSpecific.GetItemMaxMinorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer;
begin
  Result := AViewInfo.MaxWidth;
end;

function TdxLayoutGroupViewInfoVerticalSpecific.GetItemMaxMajorSize(AViewInfo: TdxCustomLayoutItemViewInfo): Integer;
begin
  Result := AViewInfo.MaxHeight;
end;

function TdxLayoutGroupViewInfoVerticalSpecific.GetItemsAreaOffset(ASide: TdxLayoutSide): Integer;
begin
  Result := 0;
  if (GroupViewInfo.FMajorScrollBar <> nil) and (ASide = sdRight) then
  begin
    if not IsTouchScrollUIMode then
    begin
      if not IsPopupScrollBars then
        Inc(Result, GroupViewInfo.FMajorScrollBarBounds.Width);
      Inc(Result, GroupViewInfo.LayoutLookAndFeel.GetGroupBorderOffset(Container, sdRight, GroupViewInfo.CaptionSide));
    end;
  end;
  if (GroupViewInfo.FMinorScrollBar <> nil) and (ASide = sdBottom) then
  begin
    if not IsTouchScrollUIMode then
    begin
      if not IsPopupScrollBars then
        Inc(Result, GroupViewInfo.FMinorScrollBarBounds.Height);
      Inc(Result, GroupViewInfo.LayoutLookAndFeel.GetGroupBorderOffset(Container, sdBottom, GroupViewInfo.CaptionSide));
    end;
  end;
end;

function TdxLayoutGroupViewInfoVerticalSpecific.IsMajorSizeFixed: Boolean;
begin
  Result := Group.IsHeightFixed;
end;

function TdxLayoutGroupViewInfoVerticalSpecific.IsMinorSizeFixed: Boolean;
begin
  Result := Group.IsWidthFixed;
end;

function TdxLayoutGroupViewInfoVerticalSpecific.GetItemsAreaHeight(ACalcSizeType: TdxLayoutCalcSizeType): Integer;
begin
  Result := GetMajorSize(ACalcSizeType);
end;

function TdxLayoutGroupViewInfoVerticalSpecific.GetItemsAreaWidth(ACalcSizeType: TdxLayoutCalcSizeType): Integer;
begin
  Result := GetMinorSize(ACalcSizeType);
end;

function TdxLayoutGroupViewInfoVerticalSpecific.IsAtInsertionPos(const R: TRect; const P: TPoint): Boolean;
begin
  Result := P.Y < (R.Top + R.Bottom) div 2;
end;

{ TdxLayoutTabbedController }

function TdxLayoutTabbedController.GetClientToScreen(const APoint: TPoint): TPoint;
begin
  Result := inherited GetClientToScreen(APoint);
  Result := cxPointOffset(Result, ViewInfo.BoundsRect.TopLeft);
end;

function TdxLayoutTabbedController.GetScreenToClient(const APoint: TPoint): TPoint;
begin
  Result := inherited GetScreenToClient(APoint);
  Result := cxPointOffset(Result, ViewInfo.BoundsRect.TopLeft, False);
end;

{ TdxLayoutTabbedViewInfo }

function TdxLayoutTabbedViewInfo.ArrowButtonClick(ANavigatorButton: TcxPCNavigatorButton): Boolean;
begin
  Result := inherited;
  GroupViewInfo.ContainerViewInfo.Container.PostBuildSelectionLayer;
end;

function TdxLayoutTabbedViewInfo.DoGetTabIndex: Integer;
begin
  Result := GroupViewInfo.ViewData.ItemIndex;
end;

procedure TdxLayoutTabbedViewInfo.DoSetTabIndex(Value: Integer);
begin
  GroupViewInfo.ViewData.TabIndex := Value;
end;

function TdxLayoutTabbedViewInfo.IsTransparent: Boolean;
begin
  Result := GroupViewInfo.ContainerViewInfo.IsTransparentBackground;
end;

function TdxLayoutTabbedViewInfo.GetGroupViewInfo: TdxLayoutGroupViewInfo;
begin
  Result := TdxLayoutGroupViewInfoTabbedSpecific(Owner).GroupViewInfo;
end;

function TdxLayoutTabbedViewInfo.UseRightToLeftAlignment: Boolean;
begin
  Result := ((TdxLayoutTabbedOptions(Properties).TabPosition in [tpTop, tpBottom]) or FIsRightToLeftConsider) and
    inherited UseRightToLeftAlignment;
end;

{ TdxTabControlElementViewInfo }

function TdxTabControlElementViewInfo.GetVisible: Boolean;
begin
  Result := not cxRectIsEmpty(Bounds);
end;

procedure TdxTabControlElementViewInfo.MouseLeave;
begin
  FTabController.MouseLeave;
end;

procedure TdxTabControlElementViewInfo.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  P: TPoint;
begin
  P := cxPointOffset(Point(X, Y), FTabViewInfo.BoundsRect.TopLeft, False);
  if FTabViewInfo.CanFocusOnClick(P.X, P.Y) then
    ItemViewInfo.ContainerViewInfo.Container.FocusController.CurrentTabOrder := ItemViewInfo.FTabOrder;
  FTabController.MouseDown(Button, Shift, P.X, P.Y);
end;

procedure TdxTabControlElementViewInfo.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  ATabIndex: Integer;
  AClientPoint: TPoint;
begin
  FTabController.MouseMove(Shift, X - FTabViewInfo.BoundsRect.Left, Y - FTabViewInfo.BoundsRect.Top);
  if TdxLayoutDragAndDropState.CanDrop then
  begin
    AClientPoint := cxPointOffset(Point(X, Y), FTabViewInfo.BoundsRect.TopLeft, False);
    ATabIndex := FTabViewInfo.IndexOfTabAt(AClientPoint.X, AClientPoint.Y);
    if ATabIndex <> -1 then
      Group.ItemIndex := ATabIndex;
  end;
end;

procedure TdxTabControlElementViewInfo.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  AContainer: TdxLayoutContainer;
begin
  AContainer := ItemViewInfo.ContainerViewInfo.Container;
  FTabController.MouseUp(Button, Shift, X - FTabViewInfo.BoundsRect.Left, Y - FTabViewInfo.BoundsRect.Top);
  AContainer.PostBuildSelectionLayer;
end;

function TdxTabControlElementViewInfo.GetGroup: TdxCustomLayoutGroup;
begin
  Result := Item.AsGroup;
end;

{ TdxLayoutGroupViewInfoTabbedSpecific }

function TdxLayoutGroupViewInfoTabbedSpecific.AllowDrawChild(AChildViewInfo: TdxCustomLayoutItemViewInfo): Boolean;
begin
  Result := inherited AllowDrawChild(AChildViewInfo) and (AChildViewInfo.Item.Index = GroupViewInfo.ItemIndex);
end;

function TdxLayoutGroupViewInfoTabbedSpecific.AllowChildHasBorder: Boolean;
begin
  Result := False;
end;

function TdxLayoutGroupViewInfoTabbedSpecific.GetChildInplaceRenameBounds(AChildViewInfo: TdxCustomLayoutItemViewInfo): TRect;
begin
  if HasTabControl then
    Result := cxRectOffset(FTabViewInfo.TabsViewInfo[AChildViewInfo.Item.VisibleIndex].VisibleRect, FTabControlBounds.TopLeft)
  else
    Result := cxNullRect;
end;

function TdxLayoutGroupViewInfoTabbedSpecific.GetDefaultItemControlAreaAlignment: TdxLayoutItemControlAreaAlignment;
begin
  Result := catNone;
end;

function TdxLayoutGroupViewInfoTabbedSpecific.ProcessDialogChar(ACharCode: Word): Boolean;
begin
  Result := HasTabControl and FTabController.HandleDialogChar(ACharCode);
end;

function TdxLayoutGroupViewInfoTabbedSpecific.ProcessDialogKey(ACharCode: Word; AKeyData: Integer; AFocusedItem: TdxCustomLayoutItem): Boolean;
var
  AGroup: TdxCustomLayoutGroup;
begin
  AGroup := GroupViewInfo.Group;
  Result := AGroup.IsChildItem(AFocusedItem) and FTabController.KeyDown(ACharCode, KeyDataToShiftState(AKeyData));
end;

procedure TdxLayoutGroupViewInfoTabbedSpecific.CalculateItemsAreaBounds(var AItemsAreaBounds: TRect);
begin
  DoCalculateTabControl(AItemsAreaBounds, False);
  inherited;
end;

procedure TdxLayoutGroupViewInfoTabbedSpecific.CalculateItemsMajorBounds(const AItemsAreaBounds: TdxAbsRect);
var
  I: Integer;
begin
  for I := 0 to ItemViewInfoCount - 1 do
    with FItemInfos[I] do
    begin
      CalculatedMajorSize := OriginalMajorSize;

      case GetMajorAlign(ViewInfo.Align) of
        aaNear:
          begin
            AbsBounds.NearMajor := AItemsAreaBounds.NearMajor;
            AbsBounds.FarMajor := AbsBounds.NearMajor + CalculatedMajorSize;
          end;
        aaCenter:
          begin
            AbsBounds.NearMajor := (AItemsAreaBounds.NearMajor + AItemsAreaBounds.FarMajor - CalculatedMajorSize) div 2;
            AbsBounds.FarMajor := AbsBounds.NearMajor + CalculatedMajorSize;
          end;
        aaFar:
          begin
            AbsBounds.FarMajor := AItemsAreaBounds.FarMajor;
            AbsBounds.NearMajor := AbsBounds.FarMajor - CalculatedMajorSize;
          end;
        aaClient:
          begin
            AbsBounds.NearMajor := AItemsAreaBounds.NearMajor;
            AbsBounds.FarMajor := AItemsAreaBounds.FarMajor;
          end;
      end;
    end;
end;

procedure TdxLayoutGroupViewInfoTabbedSpecific.CalculateInternalTabOrders(var ATabOrder: Integer);
begin
  if CanFocus then
  begin
    GroupViewInfo.FTabOrder := ATabOrder;
    Inc(ATabOrder);
  end;
end;

procedure TdxLayoutGroupViewInfoTabbedSpecific.CalculateOffsets;
begin
  inherited;
  FTabSheetContentOffset.X := GroupViewInfo.LayoutLookAndFeel.GetTabSheetContentOffsetHorz(Container);
  FTabSheetContentOffset.Y := GroupViewInfo.LayoutLookAndFeel.GetTabSheetContentOffsetVert(Container);
end;

procedure TdxLayoutGroupViewInfoTabbedSpecific.CalculateTabControl;

  function GetTabsRect(AIsOpposite: Boolean): TRect;
  const
    ATabPositionMap: array[Boolean, TcxTabPosition] of TcxTabPosition =
      ((tpTop, tpBottom, tpLeft, tpRight),
      (tpBottom, tpTop, tpRight, tpLeft));
  begin
    Result := FTabViewInfo.BoundsRect;
    case ATabPositionMap[AIsOpposite, FTabViewInfo.TabPosition] of
      tpTop:
        Result.Bottom := Result.Top + FTabViewInfo.PageClientRectOffset.Top;
      tpBottom:
        Result.Top := Result.Bottom - FTabViewInfo.PageClientRectOffset.Bottom;
      tpLeft:
        Result.Right := Result.Left + FTabViewInfo.PageClientRectOffset.Left;
      tpRight:
        Result.Left := Result.Right - FTabViewInfo.PageClientRectOffset.Right;
    end;
  end;

  procedure CalculateElementViewInfo(AElementViewInfo: TdxTabControlElementViewInfo; const ABounds: TRect);
  begin
    AElementViewInfo.Calculate(ABounds);
    AElementViewInfo.FTabController := FTabController;
    AElementViewInfo.FTabViewInfo := FTabViewInfo;
  end;

begin
  if HasTabControl then
  begin
    TabbedOptions.BeginUpdate;
    try
      TabbedOptions.RefreshTabsEnabled;
    finally
      TabbedOptions.CancelUpdate;
    end;
    FTabViewInfo.Calculate;
    CalculateElementViewInfo(FTabControlElementViewInfo, GetTabsRect(False));
    if TabbedOptions.ScrollOpposite and TabbedOptions.MultiLine and (FTabViewInfo.RowCount > 1) then
      CalculateElementViewInfo(FTabControlElementViewInfoOpposite, GetTabsRect(True))
    else
      CalculateElementViewInfo(FTabControlElementViewInfoOpposite, cxEmptyRect);
  end
  else
  begin
    CalculateElementViewInfo(FTabControlElementViewInfo, cxEmptyRect);
    CalculateElementViewInfo(FTabControlElementViewInfoOpposite, cxEmptyRect);
  end;
end;

function TdxLayoutGroupViewInfoTabbedSpecific.GetDropActionType(AAreaPart: TdxLayoutDropAreaPart): TdxLayoutActionType;
begin
  Result := atInsert;
end;

procedure TdxLayoutGroupViewInfoTabbedSpecific.CorrectDropAreaPart(const P: TPoint; var AAreaPart: TdxLayoutDropAreaPart);
var
  AIndex: Integer;
  AClientPoint, C: TPoint;
begin
  AClientPoint := cxPointOffset(P, Point(FTabControlBounds.Left, FTabControlBounds.Top), False);
  AIndex := FTabViewInfo.VisibleIndexOfTabAt(AClientPoint.X, AClientPoint.Y);
  if AIndex > -1 then
  begin
    C := cxRectCenter(FTabViewInfo.TabsViewInfo[AIndex].VisibleRect);
    if (TabbedOptions.TabPosition in [tpTop, tpBottom]) and (AClientPoint.X > C.X) or
       (TabbedOptions.TabPosition in [tpLeft, tpRight]) and (TabbedOptions.Rotate xor (AClientPoint.Y < C.Y)) then
      AAreaPart := apAfter
    else
      AAreaPart := apBefore;
    if FTabViewInfo.UseRightToLeftAlignment and (TabbedOptions.TabPosition in [tpTop, tpBottom]) then
        case AAreaPart of
          apAfter:
            AAreaPart := apBefore;
          apBefore:
            AAreaPart := apAfter;
        end;
  end
  else
    case AAreaPart of
      apLeft, apTop:
        AAreaPart := apBefore;
      apRight, apBottom:
        AAreaPart := apAfter;
    end;
end;

function TdxLayoutGroupViewInfoTabbedSpecific.GetDropAreaPart(var P: TPoint): TdxLayoutDropAreaPart;
begin
  if HasTabControl and PtInRect(FTabControlBounds, P) then
    Result := apLastChild
  else
    Result := inherited GetDropAreaPart(P);
end;

function TdxLayoutGroupViewInfoTabbedSpecific.GetDropExpectedAlign(const ADropAreaInfo: TdxLayoutDragDropInfo): TdxLayoutRealAlign;
begin
  Result.Horz := ahClient;
  Result.Vert  := avClient;
end;

function TdxLayoutGroupViewInfoTabbedSpecific.GetDropExpectedBounds(const ADropAreaInfo: TdxLayoutDragDropInfo): TRect;

  function GetBorder: TcxBorder;
  const
    ResultMap: array[Boolean, TcxTabPosition] of TcxBorder = ((bLeft, bLeft, bTop, bTop), (bRight, bRight, bBottom, bBottom));
  begin
    Result := ResultMap[not HasTabControl or
      ((ADropAreaInfo.DropAreaPart = apBefore) xor not (FTabViewInfo.IsRightToLeftAlignment or FTabViewInfo.IsBottomToTopAlignment)),
      FTabViewInfo.TabPosition];
    if FTabViewInfo.UseRightToLeftAlignment and (TabbedOptions.TabPosition in [tpTop, tpBottom]) then
      case Result of
        bLeft:
          Result := bRight;
        bRight:
          Result := bLeft;
      end;
  end;

  function ProcessTabRect(const ARect: TRect): TRect;
  begin
    Result := ARect;
    case GetBorder of
      bLeft:
        Result.Right := Result.Left + ADropAreaInfo.DropPartSize;
      bTop:
        Result.Bottom := Result.Top + ADropAreaInfo.DropPartSize;
      bRight:
        Result.Left := Result.Right - ADropAreaInfo.DropPartSize;
      bBottom:
        Result.Top := Result.Bottom - ADropAreaInfo.DropPartSize;
    end;
    OffsetRect(Result, FTabControlBounds.Left, FTabControlBounds.Top);
  end;

begin
  case ADropAreaInfo.DropAreaPart of
    apBefore, apAfter:
      Result := ProcessTabRect(FTabViewInfo.GetTabViewInfo(TabbedOptions.Tabs[GroupViewInfo.ItemIndex]).VisibleRect);
    apLastChild:
      if ItemViewInfoCount = 0 then
        Result := inherited GetDropExpectedBounds(ADropAreaInfo)
      else
        Result := ProcessTabRect(FTabViewInfo.TabsViewInfo[FTabViewInfo.TabsViewInfo.ViewInfoCount - 1].VisibleRect);
  else
    Result := inherited GetDropExpectedBounds(ADropAreaInfo);
  end;
end;

function TdxLayoutGroupViewInfoTabbedSpecific.CanDrawSpecificControls: Boolean;
begin
  Result := HasTabControl and GroupViewInfo.IsExpanded;
end;

procedure TdxLayoutGroupViewInfoTabbedSpecific.DrawSpecificControls(ACanvas: TcxCanvas);
begin
  if not HasTabControl then
    inherited
  else
    DrawTabControl(ACanvas);
end;

function TdxLayoutGroupViewInfoTabbedSpecific.GetMinorSize(ACalcSizeType: TdxLayoutCalcSizeType): Integer;
begin
  Result := GetMaxItemsMinorSize(ACalcSizeType = cstMin);

  if (TabbedOptions.TabPosition in [tpLeft, tpRight]) and (ItemViewInfoCount > 0) then
  begin
    dxTestCheck(FTabViewInfoCalculated, 'GetCustomHeight fails');
    Result := Max(Result, FMinContentSize);
  end;
end;

function TdxLayoutGroupViewInfoTabbedSpecific.GetMajorSize(ACalcSizeType: TdxLayoutCalcSizeType): Integer;

  procedure CalculateHorzTabs(ADeficit: Integer);
  var
    ATabControlSize: Integer;
  begin
    if ADeficit < 0 then
      Exit;
    FMinContentSize := FMinContentSize + ADeficit;
    ATabControlSize := FMinContentSize + GetItemsAreaOffset(sdLeft) + GetItemsAreaOffset(sdRight);
    FTabControlBounds := Rect(0, 0, ATabControlSize, 10000);
    FTabViewInfo.FIsRightToLeftConsider := False;
    FTabViewInfo.Calculate;
    FTabViewInfo.FirstTabVisibleIndex := -1;
    FTabViewInfo.MainTabVisibleIndex := -1;
    FTabViewInfo.LastTabVisibleIndex := -1;
  end;

  procedure CalculateVertTabs(ADeficit: Integer);
  var
    ATabControlSize: Integer;
  begin
    if ADeficit < 0 then
      Exit;
    FMinContentSize := FMinContentSize + ADeficit;
    ATabControlSize := FMinContentSize + GetItemsAreaOffset(sdTop) + GetItemsAreaOffset(sdBottom);
    FTabControlBounds := Rect(0, 0, 10000, ATabControlSize);
    FTabViewInfo.FIsRightToLeftConsider := False;
    FTabViewInfo.Calculate;
    FTabViewInfo.FirstTabVisibleIndex := -1;
    FTabViewInfo.MainTabVisibleIndex := -1;
    FTabViewInfo.LastTabVisibleIndex := -1;
  end;

  procedure CalculateTabArea;
  begin
    if FMinContentSize = 0 then
      if (TabbedOptions.TabPosition in [tpTop, tpBottom]) then
        FMinContentSize := GetMaxItemsMajorSize(True)
      else
        FMinContentSize := GetMaxItemsMinorSize(True);

    if not FTabViewInfoCalculated then
    begin
      if (TabbedOptions.TabPosition in [tpTop, tpBottom]) then
      begin
        CalculateHorzTabs(0);
        if FTabViewInfo.IsTooSmallControlSize then
          CalculateHorzTabs(FTabViewInfo.GetSizeDeficit);
        CalculateHorzTabs(FTabViewInfo.TabsViewInfo[0].FullRect.Width + 4 - FTabViewInfo.TabsAreaRect.Width); 
      end
      else
      begin
        CalculateVertTabs(0);
        if FTabViewInfo.IsTooSmallControlSize then
          CalculateVertTabs(FTabViewInfo.GetSizeDeficit);
        CalculateVertTabs(FTabViewInfo.TabsViewInfo[0].FullRect.Height + 4 - FTabViewInfo.TabsAreaRect.Height); 
      end;
      FTabViewInfoCalculated := True;
    end;
  end;

begin
  Result := GetMaxItemsMajorSize(ACalcSizeType = cstMin);

  if ItemViewInfoCount > 0 then
  begin
    CalculateTabArea;
    if (TabbedOptions.TabPosition in [tpTop, tpBottom]) then
      Result := Max(Result, FMinContentSize);
  end;
end;

procedure TdxLayoutGroupViewInfoTabbedSpecific.DoAssignBounds(ASource: TdxLayoutGroupViewInfoSpecific);
begin
  inherited;
  DoCalculateTabControl(TdxLayoutGroupViewInfoTabbedSpecific(ASource).FTabControlBounds, False);
end;

procedure TdxLayoutGroupViewInfoTabbedSpecific.DoSetOffset(const AValue, ADiff: TPoint);
var
  ATabBounds: TRect;
begin
  if Container.UseRightToLeftAlignment then
    ATabBounds := cxRectOffset(FTabControlBounds, -ADiff.X, ADiff.Y)
  else
    ATabBounds := cxRectOffset(FTabControlBounds, ADiff);
  DoCalculateTabControl(ATabBounds, True);
end;

procedure TdxLayoutGroupViewInfoTabbedSpecific.SetOffset(const Value: TPoint);
var
  ADiff: TPoint;
begin
  if not cxPointIsEqual(Offset, Value) then
  begin
    ADiff := cxPointOffset(Value, Offset, False);
    inherited;
    DoSetOffset(Value, ADiff);
  end;
end;

procedure TdxLayoutGroupViewInfoTabbedSpecific.Reset;
begin
  inherited;
  FMinContentSize := 0;
end;

function TdxLayoutGroupViewInfoTabbedSpecific.GetItemsAreaOffset(ASide: TdxLayoutSide): Integer;
begin
  Result := inherited GetItemsAreaOffset(ASide);
  if HasTabControl then
  begin
    Inc(Result, GroupViewInfo.LayoutLookAndFeel.GetTabControlBorderOffset(Container, ASide, GroupViewInfo.CaptionSide));
    case ASide of
      sdLeft, sdRight:
        Inc(Result, FTabSheetContentOffset.X); 
      sdTop, sdBottom:
        Inc(Result, FTabSheetContentOffset.Y); 
    end;
    case ASide of
      sdLeft:
        Inc(Result, FTabViewInfo.PageClientRectOffset.Left);
      sdRight:
        Inc(Result, FTabViewInfo.PageClientRectOffset.Right);
      sdTop:
        Inc(Result, FTabViewInfo.PageClientRectOffset.Top);
      sdBottom:
        Inc(Result, FTabViewInfo.PageClientRectOffset.Bottom);
    end;
  end;
end;

function TdxLayoutGroupViewInfoTabbedSpecific.GetHitTabIndex(const P: TPoint): Integer;
var
  AClientPoint: TPoint;
begin
  if HasTabControl then
  begin
    AClientPoint := cxPointOffset(P, Point(FTabControlBounds.Left, FTabControlBounds.Top), False);
    Result := FTabViewInfo.VisibleIndexOfTabAt(AClientPoint.X, AClientPoint.Y);
  end
  else
    Result := -1;
end;

function TdxLayoutGroupViewInfoTabbedSpecific.CanFocus: Boolean;
begin
  Result := HasTabControl and FTabViewInfo.IsTabsVisible and (FTabViewInfo.TabsViewInfo.ViewInfoCount > 0);
end;

function TdxLayoutGroupViewInfoTabbedSpecific.CanFocusOnClick(X, Y: Integer): Boolean;
var
  P: TPoint;
begin
  P := cxPointOffset(Point(X, Y), FTabControlBounds.TopLeft, False);
  Result := CanFocus and FTabViewInfo.CanFocusOnClick(P.X, P.Y);
end;

procedure TdxLayoutGroupViewInfoTabbedSpecific.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if HasTabControl then
    FTabController.KeyDown(Key, Shift);
end;

procedure TdxLayoutGroupViewInfoTabbedSpecific.CreateSpecificControls;
begin
  inherited CreateSpecificControls;
  CreateTabControl;
end;

procedure TdxLayoutGroupViewInfoTabbedSpecific.DestroySpecificControls;
begin
  DestroyTabControl;
  inherited DestroySpecificControls;
end;

procedure TdxLayoutGroupViewInfoTabbedSpecific.CreateViewInfos;
begin
  inherited;
  FTabControlElementViewInfo := TdxTabControlElementViewInfo.Create(GroupViewInfo);
  FTabControlElementViewInfoOpposite := TdxTabControlElementViewInfo.Create(GroupViewInfo);
end;

procedure TdxLayoutGroupViewInfoTabbedSpecific.DestroyViewInfos;
begin
  FreeAndNil(FTabControlElementViewInfoOpposite);
  FreeAndNil(FTabControlElementViewInfo);
  inherited;
end;

procedure TdxLayoutGroupViewInfoTabbedSpecific.GetElements(AElements: TList);
begin
  inherited;
  AElements.Add(FTabControlElementViewInfo);
  AElements.Add(FTabControlElementViewInfoOpposite);
end;

procedure TdxLayoutGroupViewInfoTabbedSpecific.CreateTabControl;
begin
  if GroupViewInfo.Group.VisibleCount = 0 then
    Exit;

  FTabViewInfo := TdxLayoutTabbedViewInfo.Create(Self);
  FTabController := TdxLayoutTabbedController.Create(Self);
  FTabPainter := FTabViewInfo.GetPainterClass.Create(FTabViewInfo);
  TabbedOptions.RefreshTabsCaption;
  TabbedOptions.RefreshImages;
end;

procedure TdxLayoutGroupViewInfoTabbedSpecific.DestroyTabControl;
begin
  FreeAndNil(FTabPainter);
  FreeAndNil(FTabViewInfo);
  FreeAndNil(FTabController);
end;

function TdxLayoutGroupViewInfoTabbedSpecific.HasTabControl: Boolean;
begin
  Result := FTabViewInfo <> nil;
end;

function TdxLayoutGroupViewInfoTabbedSpecific.GetTabController: TcxCustomTabControlController;
begin
  Result := FTabController;
end;

function TdxLayoutGroupViewInfoTabbedSpecific.GetTabPainter: TcxPCCustomPainter;
begin
  Result := FTabPainter;
end;

function TdxLayoutGroupViewInfoTabbedSpecific.GetTabProperties: TcxCustomTabControlProperties;
begin
  Result := TabbedOptions;
end;

function TdxLayoutGroupViewInfoTabbedSpecific.GetTabViewInfo: TcxCustomTabControlViewInfo;
begin
  Result := FTabViewInfo;
end;

function TdxLayoutGroupViewInfoTabbedSpecific.CanDrawTabParentBackground: Boolean;
begin
  Result := False;
end;

procedure TdxLayoutGroupViewInfoTabbedSpecific.DoRightToLeftConversion(const AClientBounds: TRect);
begin
  inherited DoRightToLeftConversion(AClientBounds);
  DoCalculateTabControl(TdxRightToLeftLayoutConverter.ConvertRect(FTabControlBounds, AClientBounds), True);
end;

function TdxLayoutGroupViewInfoTabbedSpecific.GetTabBoundsRect: TRect;
begin
  Result := FTabControlBounds;
end;

function TdxLayoutGroupViewInfoTabbedSpecific.GetCanvas: TcxCanvas;
begin
  Result := GroupViewInfo.ContainerViewInfo.Canvas;
end;

function TdxLayoutGroupViewInfoTabbedSpecific.GetControl: TWinControl;
begin
  Result := Container.ItemsParentControl;
end;

function TdxLayoutGroupViewInfoTabbedSpecific.GetTabColor: TColor;
begin
  Result := GroupViewInfo.Color;
end;

function TdxLayoutGroupViewInfoTabbedSpecific.GetDragAndDropObject: TcxDragAndDropObject;
begin
  Result := nil;
end;

function TdxLayoutGroupViewInfoTabbedSpecific.GetDragAndDropState: TcxDragAndDropState;
begin
  Result := ddsNone;
end;

function TdxLayoutGroupViewInfoTabbedSpecific.GetFont: TFont;
begin
  Result := GroupViewInfo.CaptionViewInfo.Font;
end;

function TdxLayoutGroupViewInfoTabbedSpecific.GetLookAndFeel: TcxLookAndFeel;
begin
  Result := TdxCustomLayoutLookAndFeelAccess(GroupViewInfo.GetLayoutLookAndFeel).LookAndFeel;
end;

procedure TdxLayoutGroupViewInfoTabbedSpecific.InvalidateTabRect(const R: TRect; AEraseBackground: Boolean);
var
  ABounds: TRect;
begin
  ABounds := cxRectOffset(R, FTabControlBounds.TopLeft);
  Container.InvalidateRect(ABounds, AEraseBackground);
  Container.PostInvalidateSelectionLayer(ABounds);
end;

procedure TdxLayoutGroupViewInfoTabbedSpecific.SetModified;
begin
  Container.Modified;
end;

function TdxLayoutGroupViewInfoTabbedSpecific.IsEnabled: Boolean;
begin
  Result := GroupViewInfo.Enabled;
end;

function TdxLayoutGroupViewInfoTabbedSpecific.IsDesigning: Boolean;
begin
  Result := GroupViewInfo.Group.IsDesigning;
end;

function TdxLayoutGroupViewInfoTabbedSpecific.IsDestroying: Boolean;
begin
  Result := GroupViewInfo.Group.IsDestroying;
end;

function TdxLayoutGroupViewInfoTabbedSpecific.IsFocused: Boolean;
begin
  Result := CanFocus and GroupViewInfo.Group.IsFocused;
end;

function TdxLayoutGroupViewInfoTabbedSpecific.IsLoading: Boolean;
begin
  Result := GroupViewInfo.Group.IsLoading;
end;

function TdxLayoutGroupViewInfoTabbedSpecific.IsParentBackground: Boolean;
begin
  Result := True;
end;

procedure TdxLayoutGroupViewInfoTabbedSpecific.RequestLayout;
begin
  if HasTabControl then
  begin
    FTabViewInfo.FIsRightToLeftConsider := False;
    FTabViewInfo.Calculate;
    InvalidateTabRect(FTabViewInfo.ControlBounds, True);
  end;
end;

procedure TdxLayoutGroupViewInfoTabbedSpecific.DoCalculateTabControl(const ATabBounds: TRect;
  AIsRightToLeftConsider: Boolean);
begin
  if HasTabControl then
    FTabViewInfo.FIsRightToLeftConsider := AIsRightToLeftConsider;
  FTabControlBounds := ATabBounds;
  CalculateTabControl;
end;

procedure TdxLayoutGroupViewInfoTabbedSpecific.DrawTabControl(ACanvas: TcxCanvas);
var
  P: TPoint;
begin
  ACanvas.SaveState;
  try
    P := ACanvas.WindowOrg;
    P := cxPointOffset(FTabControlBounds.TopLeft, P, False);
    ACanvas.WindowOrg := cxPointInvert(P);
    ACanvas.SetClipRegion(TcxRegion.Create(FTabViewInfo.ClientRect), roIntersect); 
    if not TdxCustomLayoutLookAndFeelAccess(GroupViewInfo.LayoutLookAndFeel).CanDrawSpecificBackground then
      ACanvas.SetClipRegion(TcxRegion.Create(FTabViewInfo.PageClientRect), roSubtract);
    FTabPainter.Paint(ACanvas);
  finally
    ACanvas.RestoreState;
  end;
end;

function TdxLayoutGroupViewInfoTabbedSpecific.GetTabbedOptions: TdxLayoutTabbedOptions;
begin
  Result := GroupViewInfo.Group.TabbedOptions;
end;

{ TdxLayoutGroupButtonViewInfo }

constructor TdxLayoutGroupButtonViewInfo.Create(AButtonsViewInfo: TdxLayoutGroupButtonsViewInfo; AButton: TdxCustomLayoutGroupButton);
begin
  inherited Create(AButtonsViewInfo.ItemViewInfo);
  FButton := AButton;
  FButtonsViewInfo := AButtonsViewInfo;
end;

function TdxLayoutGroupButtonViewInfo.CalculateHeight: Integer;
begin
  Result := Button.GetHeight;
end;

function TdxLayoutGroupButtonViewInfo.CalculateWidth: Integer;
begin
  Result := Button.GetWidth;
end;

procedure TdxLayoutGroupButtonViewInfo.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  AExecuteClick: Boolean;
begin
  AExecuteClick := (levsPressed in State) and IsEnabled and not ItemViewInfo.Item.Container.IsCustomization;
  inherited;
  if AExecuteClick then
    DoClick;
end;

procedure TdxLayoutGroupButtonViewInfo.DoClick;
begin
  ButtonsViewInfo.GroupViewInfo.ViewData.DoButtonClick(Self);
end;

procedure TdxLayoutGroupButtonViewInfo.StateChanged;
begin
  Invalidate(OriginalBounds);
end;

function TdxLayoutGroupButtonViewInfo.IsHotTrackable: Boolean;
begin
  Result := LayoutLookAndFeel.IsButtonHotTrack;
end;

function TdxLayoutGroupButtonViewInfo.AllowDragDrop: Boolean;
begin
  Result := False;
end;

function TdxLayoutGroupButtonViewInfo.ShowHint(var AHintInfo: THintInfo): Boolean;
begin
  if IsEnabled then
  begin
    AHintInfo.HintData := @AHintInfo;
    AHintInfo.CursorRect := Bounds;
    AHintInfo.HintStr := GetShortHint(Button.Hint);
    Result := AHintInfo.HintStr <> '';
  end
  else
    Result := inherited ShowHint(AHintInfo);
end;

function TdxLayoutGroupButtonViewInfo.GetVisible: Boolean;
begin
  Result := Button.Visible;
end;

function TdxLayoutGroupButtonViewInfo.GetPainterClass: TdxLayoutGroupButtonPainterClass;
begin
  Result := TdxLayoutGroupButtonPainter;
end;

function TdxLayoutGroupButtonViewInfo.GetState: TcxButtonState;
begin
  Result := cxbsNormal;
  if not IsEnabled then
    Result := cxbsDisabled
  else
    if levsPressed in State then
      Result := cxbsPressed
    else
      if levsHot in State then
        Result := cxbsHot;
end;

function TdxLayoutGroupButtonViewInfo.IsGroupExpanded: Boolean;
begin
  Result := ButtonsViewInfo.GroupViewInfo.IsExpanded;
end;

function TdxLayoutGroupButtonViewInfo.IsExpandButton: Boolean;
begin
  Result := Button.IsExpandButton;
end;

function TdxLayoutGroupButtonViewInfo.IsHomeButton: Boolean;
begin
  Result := Button.IsHomeButton;
end;

function TdxLayoutGroupButtonViewInfo.GetGlyph: TdxSmartGlyph;
begin
  Result := Button.Glyph;
end;

function TdxLayoutGroupButtonViewInfo.GetIsEnabled: Boolean;
begin
  Result := Button.Enabled and ButtonsViewInfo.GroupViewInfo.Enabled;
end;

function TdxLayoutGroupButtonViewInfo.GetVisibleIndex: Integer;
var
  I: Integer;
begin
  Result := -1;
  if Visible then
    for I := 0 to ButtonsViewInfo.ButtonViewInfoCount - 1 do
    begin
      if ButtonsViewInfo.ButtonViewInfos[I].Visible then
        Inc(Result);
      if ButtonsViewInfo.ButtonViewInfos[I] = Self then
        Break;
    end;
end;

function TdxLayoutGroupButtonViewInfo.GetRotationAngle: TcxRotationAngle;
begin
  if IsExpandButton and (ButtonsViewInfo.GroupViewInfo.Group.Parent <> nil) then
  begin
    if ButtonsViewInfo.GroupViewInfo.Group.Parent.LayoutDirection = ldHorizontal then
      if Item.Container.UseRightToLeftAlignment then
        Result := raMinus90
      else
        Result := raPlus90
    else
      Result := ra0
  end
  else
    Result := ButtonsViewInfo.GroupViewInfo.GetRotationAngle;
end;

{ TdxLayoutGroupCheckBoxButtonViewInfo }

function TdxLayoutGroupCheckBoxButtonViewInfo.GetCheckBoxSize(ACanvas: TcxCanvas): TSize;
begin
  Result := GetScaledEditCheckSize(ACanvas, LookAndFeel.NativeStyle, nil, 0, LookAndFeel.Painter, Item.ScaleFactor);
end;

function TdxLayoutGroupCheckBoxButtonViewInfo.GetEditCheckState: TcxEditCheckState;

  function IsState(AState: TdxLayoutElementViewInfoState): Boolean;
  begin
    Result := (AState in State) or (TdxLayoutGroupCaptionViewInfo(ItemViewInfo.CaptionViewInfo).CanClickOnCaption and
      (AState in ItemViewInfo.CaptionViewInfo.State));
  end;

begin
  Result := ecsNormal;
  if not IsEnabled then
    Result := ecsDisabled
  else
    if IsState(levsPressed) then
      Result := ecsPressed
    else
      if IsState(levsHot) then
        Result := ecsHot;
end;

function TdxLayoutGroupCheckBoxButtonViewInfo.GetPainterClass: TdxLayoutGroupButtonPainterClass;
begin
  Result := TdxLayoutGroupCheckBoxButtonPainter;
end;

{ TdxLayoutGroupButtonsViewInfo }

constructor TdxLayoutGroupButtonsViewInfo.Create(AItemViewInfo: TdxCustomLayoutItemViewInfo);
begin
  inherited Create(AItemViewInfo);
  CreateButtonViewInfos;
end;

destructor TdxLayoutGroupButtonsViewInfo.Destroy;
begin
  DestroyButtonViewInfos;
  inherited Destroy;
end;

procedure TdxLayoutGroupButtonsViewInfo.Calculate(const ABounds: TRect);
begin
  inherited;
  RecreateButtonViewInfos;
  CalculateButtonViewInfos;
end;

function TdxLayoutGroupButtonsViewInfo.CalculateHeight: Integer;
begin
  if GroupViewInfo.IsVerticalCaption then
    Result := InternalCalculateWidth
  else
    Result := InternalCalculateHeight;
end;

function TdxLayoutGroupButtonsViewInfo.CalculateMinHeight: Integer;
begin
  Result := CalculateHeight;
end;

function TdxLayoutGroupButtonsViewInfo.CalculateMinWidth: Integer;
begin
  Result := CalculateWidth;
end;

function TdxLayoutGroupButtonsViewInfo.CalculateWidth: Integer;
begin
  if GroupViewInfo.IsVerticalCaption then
    Result := InternalCalculateHeight
  else
    Result := InternalCalculateWidth;
end;

function TdxLayoutGroupButtonsViewInfo.GetVisible: Boolean;
begin
  Result := GroupViewInfo.HasButtons;
end;

procedure TdxLayoutGroupButtonsViewInfo.CalculateHorizontalLayout;
var
  AOffsetX, AOffsetY: Integer;
  I: Integer;
  R: TRect;
begin
  if Visible then
  begin
    AOffsetX := GroupViewInfo.GetButtonsSpace;
    for I := 0 to ButtonViewInfoCount - 1 do
    begin
      AOffsetY := (Bounds.Height - ButtonViewInfos[I].Height) div 2;
      if GroupViewInfo.CaptionSide = sdTop then
      begin
        R.Top := Bounds.Top + AOffsetY;
        R.Bottom := R.Top + ButtonViewInfos[I].Button.GetHeight;
      end
      else
      begin
        R.Bottom := Bounds.Bottom - AOffsetY;
        R.Top := R.Bottom - ButtonViewInfos[I].Button.GetHeight;
      end;
      R.Left := Bounds.Left + AOffsetX;
      R.Right := R.Left + ButtonViewInfos[I].Button.GetWidth;
      ButtonViewInfos[I].Calculate(R);
      Inc(AOffsetX, ButtonViewInfos[I].Width + GroupViewInfo.GetSpaceBetweenButtons);
    end;
  end;
end;

procedure TdxLayoutGroupButtonsViewInfo.CalculateVerticalLayout;
var
  AOffsetX, AOffsetY: Integer;
  I: Integer;
  R: TRect;
begin
  if Visible then
  begin
    AOffsetY := GroupViewInfo.GetButtonsSpace;
    for I := 0 to ButtonViewInfoCount - 1 do
    begin
      AOffsetX := (Bounds.Width - ButtonViewInfos[I].Height) div 2;

      if GroupViewInfo.CaptionSide = sdLeft then
      begin
        R.Left := Bounds.Left + AOffsetX;
        R.Bottom := Bounds.Bottom - AOffsetY;
        R.Right := R.Left + ButtonViewInfos[I].Button.GetHeight;
        R.Top := R.Bottom - ButtonViewInfos[I].Button.GetWidth;
      end
      else
      begin
        R.Right := Bounds.Right - AOffsetX;
        R.Top := Bounds.Top + AOffsetY;
        R.Left := R.Right - ButtonViewInfos[I].Button.GetHeight;
        R.Bottom := R.Top + ButtonViewInfos[I].Button.GetWidth;
      end;

      ButtonViewInfos[I].Calculate(R);
      Inc(AOffsetY, ButtonViewInfos[I].Height + GroupViewInfo.GetSpaceBetweenButtons);
    end;
  end;
end;

procedure TdxLayoutGroupButtonsViewInfo.CalculateButtonViewInfos;
begin
  if GroupViewInfo.IsVerticalCaption then
    CalculateVerticalLayout
  else
    CalculateHorizontalLayout;
end;

procedure TdxLayoutGroupButtonsViewInfo.CreateButtonViewInfos;

  procedure CreateButtonViewInfo(AButton: TdxCustomLayoutGroupButton);
  begin
    FButtonViewInfos.Add(AButton.GetViewInfoClass.Create(Self, AButton));
  end;

var
  I: Integer;
begin
  FButtonViewInfos := TcxObjectList.Create;
  if Options.Visible then
  begin
    Options.RefreshVisibleButtons;
    for I := 0 to Options.FVisibleButtons.Count - 1 do
      CreateButtonViewInfo(Options.GetVisibleButton(I));
  end;
end;

procedure TdxLayoutGroupButtonsViewInfo.RecreateButtonViewInfos;
begin
  DestroyButtonViewInfos;
  CreateButtonViewInfos;
end;

procedure TdxLayoutGroupButtonsViewInfo.DestroyButtonViewInfos;
begin
  FreeAndNil(FButtonViewInfos);
end;

procedure TdxLayoutGroupButtonsViewInfo.GetElements(AElements: TList);
var
  I: Integer;
begin
  for I := 0 to FButtonViewInfos.Count - 1 do
    AElements.Add(FButtonViewInfos[I]);
end;

function TdxLayoutGroupButtonsViewInfo.InternalCalculateHeight: Integer;

  function GetMaxButtonHeight: Integer;
  var
    I: Integer;
  begin
    Result := 0;
    if Options.Visible then
    begin
      Options.RefreshVisibleButtons;
      for I := 0 to Options.FVisibleButtons.Count - 1 do
        Result := Max(Result, Options.GetVisibleButton(I).GetHeight);
    end;
  end;

begin
  if GetVisible then
    Result := GetMaxButtonHeight
  else
    Result := 0;
end;

function TdxLayoutGroupButtonsViewInfo.InternalCalculateWidth: Integer;
var
  I: Integer;
begin
  if GetVisible then
  begin
    Result := 0;
    if Options.Visible then
    begin
      Options.RefreshVisibleButtons;
      for I := 0 to Options.FVisibleButtons.Count - 1 do
        Inc(Result, Options.GetVisibleButton(I).GetWidth + IfThen(I > 0, GroupViewInfo.GetSpaceBetweenButtons));
    end;
    Result := Result + GroupViewInfo.GetButtonsSpace * 2;
  end
  else
    Result := 0;
end;

procedure TdxLayoutGroupButtonsViewInfo.DoAssignBounds(ASource: TdxCustomLayoutElementViewInfo);
var
  I: Integer;
begin
  inherited;
  for I := 0 to ButtonViewInfoCount - 1 do
    ButtonViewInfos[I].AssignBounds(TdxLayoutGroupButtonsViewInfo(ASource).ButtonViewInfos[I]);
end;

procedure TdxLayoutGroupButtonsViewInfo.DoRightToLeftConversion(const AClientBounds: TRect);
var
  I: Integer;
begin
  inherited DoRightToLeftConversion(AClientBounds);
  for I := 0 to ButtonViewInfoCount - 1 do
    ButtonViewInfos[I].DoRightToLeftConversion(AClientBounds);
end;

procedure TdxLayoutGroupButtonsViewInfo.DoSetOffset(const AValue, ADiff: TPoint);
var
  I: Integer;
begin
  inherited;
  for I := 0 to ButtonViewInfoCount - 1 do
    ButtonViewInfos[I].Offset := AValue;
end;

procedure TdxLayoutGroupButtonsViewInfo.StateChanged;
var
  I: Integer;
begin
  inherited;
  for I := 0 to ButtonViewInfoCount - 1 do
    ButtonViewInfos[I].StateChanged;
end;

function TdxLayoutGroupButtonsViewInfo.IsLeftAlignment: Boolean;
begin
  Result := Options.Alignment = gbaLeft;
end;

function TdxLayoutGroupButtonsViewInfo.GetButtonViewInfos(Index: Integer): TdxLayoutGroupButtonViewInfo;
begin
  Result := TdxLayoutGroupButtonViewInfo(FButtonViewInfos[Index]);
end;

function TdxLayoutGroupButtonsViewInfo.GetButtonViewInfoCount: Integer;
begin
  Result := FButtonViewInfos.Count;
end;

function TdxLayoutGroupButtonsViewInfo.GetExpandButton: TdxLayoutGroupButton;
begin
  Result := GroupViewInfo.Group.ButtonOptions.ExpandButton;
end;

function TdxLayoutGroupButtonsViewInfo.GetGroupViewInfo: TdxLayoutGroupViewInfo;
begin
  Result := ItemViewInfo.AsGroupViewInfo;
end;

function TdxLayoutGroupButtonsViewInfo.GetOptions: TdxLayoutGroupButtonOptions;
begin
  Result := GroupViewInfo.Group.ButtonOptions;
end;

{ TdxLayoutGroupViewInfoCloneData }

constructor TdxLayoutGroupViewData.Create(AOwner: TdxLayoutItemViewDataList; AItem: TdxCustomLayoutItem);
begin
  inherited Create(AOwner, AItem);
end;

destructor TdxLayoutGroupViewData.Destroy;
begin
  inherited Destroy;
end;

procedure TdxLayoutGroupViewData.Assign(Source: TdxCustomLayoutItemViewData);
begin
  if Source is TdxLayoutGroupViewData then
  begin
    FScrollPos := TdxLayoutGroupViewData(Source).ScrollPos;
  end;
  inherited;
end;

procedure TdxLayoutGroupViewData.Calculate;
begin
  inherited;
  FScrollPos := TdxAbsPoint(cxNullPoint);
end;

procedure TdxLayoutGroupViewData.Load(AStream: TStream);
begin
  inherited;
  AStream.Read(FScrollPos, SizeOf(FScrollPos));
end;

procedure TdxLayoutGroupViewData.Save(AStream: TStream);
begin
  inherited;
  AStream.Write(FScrollPos, SizeOf(FScrollPos));
end;

procedure TdxLayoutGroupViewData.Changed;
begin
  Item.Changed(ictMedium);
end;

function TdxLayoutGroupViewData.GetSize: Integer;
begin
  Result := inherited GetSize + SizeOf(FScrollPos);
end;

procedure TdxLayoutGroupViewData.DoButtonClick(AViewInfo: TdxLayoutGroupButtonViewInfo);
begin
  if AViewInfo.IsExpandButton then
    Expanded := not Expanded
  else
    AViewInfo.Button.DoClick;
end;

function TdxLayoutGroupViewData.GetGroup: TdxCustomLayoutGroup;
begin
  Result := TdxCustomLayoutGroup(Item);
end;

function TdxLayoutGroupViewData.GetExpanded: Boolean;
begin
  Result := Group.Expanded;
end;

function TdxLayoutGroupViewData.GetItemIndex: Integer;
begin
  Result := Group.ItemIndex;
end;

function TdxLayoutGroupViewData.GetTabIndex: Integer;
begin
  Result := ItemIndex;
end;

procedure TdxLayoutGroupViewData.SetExpanded(Value: Boolean);
begin
  Group.Expanded := Value;
end;

procedure TdxLayoutGroupViewData.SetItemIndex(Value: Integer);
begin
  Group.ItemIndex := Value;
end;

procedure TdxLayoutGroupViewData.SetScrollPos(const Value: TdxAbsPoint);
begin
  if (FScrollPos.Major <> Value.Major) or (FScrollPos.Minor <> Value.Minor) then
  begin
    FScrollPos := Value;
    Changed;
  end;
end;

procedure TdxLayoutGroupViewData.SetTabIndex(Value: Integer);
begin
  Group.TabbedOptions.TabIndex := Value;
end;

{ TdxLayoutGroupViewInfo }

function TdxLayoutGroupViewInfo.GetBorderBounds(ASide: TdxLayoutSide): TRect;
begin
  Result := Bounds;
  case ASide of
    sdLeft:
      Result.Right := ClientBounds.Left;
    sdTop:
      Result.Bottom := ClientBounds.Top;
    sdRight:
      Result.Left := ClientBounds.Right;
    sdBottom:
      Result.Top := ClientBounds.Bottom;
  end;
end;

function TdxLayoutGroupViewInfo.GetBorderRestSpaceBounds(ASide: TdxLayoutSide): TRect;
begin
  Result := RestSpaceBounds;
  with ClientBounds do
    case ASide of
      sdLeft:
        Result.Right := Left;
      sdTop:
        Result.Bottom := Top;
      sdRight:
        Result.Left := Right;
      sdBottom:
        Result.Top := Bottom;
    end;
end;

function TdxLayoutGroupViewInfo.GetBordersHeight: Integer;
begin
  Result := BorderWidths[sdLeft] + BorderWidths[sdRight];
end;

function TdxLayoutGroupViewInfo.GetBordersWidth: Integer;
begin
  Result := BorderWidths[sdTop] + BorderWidths[sdBottom];
end;

function TdxLayoutGroupViewInfo.GetCaptionSide: TdxLayoutSide;
const
  ResultMap: array[TdxCaptionLayout] of TdxLayoutSide = (sdLeft, sdTop, sdRight, sdBottom);
begin
  Result := ResultMap[Group.CaptionOptions.Layout];
end;

function TdxLayoutGroupViewInfo.GetCaptionViewInfo: TdxLayoutGroupCaptionViewInfo;
begin
  Result := TdxLayoutGroupCaptionViewInfo(inherited CaptionViewInfo);
end;

function TdxLayoutGroupViewInfo.GetViewData: TdxLayoutGroupViewData;
begin
  Result := TdxLayoutGroupViewData(inherited ViewData);
end;

function TdxLayoutGroupViewInfo.GetGroup: TdxCustomLayoutGroup;
begin
  Result := Item.AsGroup;
end;

function TdxLayoutGroupViewInfo.GetItemViewInfo(Index: Integer): TdxCustomLayoutItemViewInfo;
begin
  Result := TdxCustomLayoutItemViewInfo(FItemViewInfos.List[Index]);
end;

function TdxLayoutGroupViewInfo.GetItemViewInfoCount: Integer;
begin
  Result := FItemViewInfos.Count;
end;

function TdxLayoutGroupViewInfo.GetLayoutDirection: TdxLayoutDirection;
begin
  Result := Group.LayoutDirection;
end;

function TdxLayoutGroupViewInfo.GetOptions: TdxLayoutLookAndFeelGroupOptions;
begin
  Result := GetLayoutLookAndFeel.GroupOptions;
end;

function TdxLayoutGroupViewInfo.GetScrollPos: TdxAbsPoint;
begin
  Result := TdxAbsPoint(cxNullPoint);
  if FMajorScrollBar <> nil then
    Result.Major := ViewData.ScrollPos.Major;
  if FMinorScrollBar <> nil then
    Result.Minor := ViewData.ScrollPos.Minor;
end;

function TdxLayoutGroupViewInfo.GetRealItemControlAreaAlignment: TdxLayoutItemControlAreaAlignment;
begin
  if Group.FItemControlAreaAlignment = catDefault then
    Result := Specific.GetDefaultItemControlAreaAlignment
  else
    Result := Group.FItemControlAreaAlignment;

  if (Group.FWrappingState = wsNone) and (Result = catAuto) and ((ParentViewInfo = nil) or (ParentViewInfo.GetRealItemControlAreaAlignment = catNone) or not Group.IsHorzLocalPositionStable) then
    Result := catOwn
  else
    if Group.AutoCreated then
      Result := catAuto
    else
      case Group.FWrappingState of
        wsSqueezed:
          Result := catNone;
        wsPopulated:
          Result := catOwn;
      end;

  if (Result = catAuto) and
     ((FMajorScrollBar <> nil) or (FMinorScrollBar <> nil) or
       (Group.ScrollOptions.Horizontal <> smNone) and (LayoutDirection = ldHorizontal)) then
    Result := catOwn;
end;

function TdxLayoutGroupViewInfo.GetItemIndex: Integer;
begin
  Result := ViewData.ItemIndex;
end;

function TdxLayoutGroupViewInfo.GetOffset(Index: Integer): Integer;
begin
  if not FOffsetsCalculated then
  begin
    CalculateOffsets;
    FOffsetsCalculated := True;
  end;
  case Index of
    0: Result := FItemOffset;
    1: Result := FItemsAreaOffsetHorz;
    2: Result := FItemsAreaOffsetVert;
  else
    Result := -1;
  end;
end;

constructor TdxLayoutGroupViewInfo.Create(AContainerViewInfo: TdxLayoutContainerViewInfo; AParentViewInfo: TdxLayoutGroupViewInfo;
  AViewData: TdxCustomLayoutItemViewData);
begin
  inherited;
  FHybridScrollbarsManager := TdxHybridScrollbarsManager.Create(Self);
end;

procedure TdxLayoutGroupViewInfo.CreateItemViewInfos;
var
  I: Integer;
  AItem: TdxCustomLayoutItem;
  AItemViewInfo: TdxCustomLayoutItemViewInfo;
begin
  FItemViewInfos := TObjectList.Create;
  for I := 0 to Group.Count - 1 do
  begin
    AItem := Group.Items[I];
    if AItem.GetVisible or (IsDragImagePainting and IsAvailable) then
    begin
      AItemViewInfo := ContainerViewInfo.CreateItemViewInfo(Self, AItem);
      FItemViewInfos.Add(AItemViewInfo);
    end;
  end;
end;

function TdxLayoutGroupViewInfo.CreateScrollBar: TdxScrollBarWrapper;
begin
  Result := TdxScrollBarWrapper.Create(Self);
end;

procedure TdxLayoutGroupViewInfo.InitializeMajorScrollBar(AContentSize, AClientSize: Integer);
begin
  FMajorScrollBar.Min := 0;
  FMajorScrollBar.Max := AContentSize - 1;
  FMajorScrollBar.PageSize := AClientSize;
  FMajorScrollBar.Enabled := True;
  FMajorScrollBar.SmallChange := 10;
  FMajorScrollBar.LargeChange := AClientSize;
  FMajorScrollBar.OnScroll := DoMajorScroll;
  if ContainerViewInfo.Container.ItemsParentControl.HandleAllocated then
    PostMessage(ContainerViewInfo.Container.ItemsParentControl.Handle, DXM_LAYOUT_UPDATESCROLLPOS, TdxNativeInt(ViewData), 0);
//  CheckScrollPos(FMajorScrollBar, Group.FScrollPos.X);
  FMajorScrollBar.Position := ViewData.FScrollPos.Major;
  Specific.InitializeMajorScrollBar(AContentSize, AClientSize);
  if not UseRightToLeftAlignment then
    SetScrollBounds(FMajorScrollBar, FMajorScrollBarBounds);
//  FMajorScrollBar.Visible := True;
end;

procedure TdxLayoutGroupViewInfo.InitializeMinorScrollBar(AContentSize, AClientSize: Integer);
begin
  FMinorScrollBar.Min := 0;
  FMinorScrollBar.Max := AContentSize - 1;
  FMinorScrollBar.PageSize := AClientSize;
  FMinorScrollBar.Enabled := True;
  FMinorScrollBar.SmallChange := 10;
  FMinorScrollBar.LargeChange := AClientSize;
  FMinorScrollBar.OnScroll := DoMinorScroll;
  if ContainerViewInfo.Container.ItemsParentControl.HandleAllocated then
    PostMessage(ContainerViewInfo.Container.ItemsParentControl.Handle, DXM_LAYOUT_UPDATESCROLLPOS, TdxNativeInt(ViewData), 1);
//  CheckScrollPos(FMinorScrollBar, Group.FScrollPos.Y);
  FMinorScrollBar.Position := ViewData.FScrollPos.Minor;
  Specific.InitializeMinorScrollBar(AContentSize, AClientSize);
  if not UseRightToLeftAlignment then
    SetScrollBounds(FMinorScrollBar, FMinorScrollBarBounds);
//  FMinorScrollBar.Visible := True;
end;

procedure TdxLayoutGroupViewInfo.CheckScrollPos(AScrollBar: TdxScrollBarWrapper; var AScrollPos: Integer);
begin
  if AScrollBar = nil then
    AScrollPos := 0
  else
    AScrollPos := Max(Min(AScrollPos, AScrollBar.Max + 1 - AScrollBar.PageSize), 0);
end;

procedure TdxLayoutGroupViewInfo.SetScrollBounds(AScrollBar: TdxScrollBarWrapper; const ABounds: TRect);
begin
  AScrollBar.InitControl;
  TdxScrollBarWrapperAccess(AScrollBar).UpdateBounds(ABounds, GetVisiblePart(ABounds));
end;

procedure TdxLayoutGroupViewInfo.UpdateScrollPos(AMajor: Boolean);
var
  ANewScrollPos: Integer;
begin
  if AMajor then
  begin
    ANewScrollPos := ViewData.FScrollPos.Major;
    DoMajorScroll(nil, scPosition, ANewScrollPos);
  end
  else
  begin
    ANewScrollPos := ViewData.FScrollPos.Minor;
    DoMinorScroll(nil, scPosition, ANewScrollPos);
  end;
end;

procedure TdxLayoutGroupViewInfo.CreateSpecific;
begin
  FSpecific := GetSpecificClass.Create(Self);
end;

destructor TdxLayoutGroupViewInfo.Destroy;
begin
  FreeAndNil(FHybridScrollbarsManager);
  TdxTouchScrollUIModeManager.Deactivate(Self);
  inherited;
end;

procedure TdxLayoutGroupViewInfo.DestroyItemViewInfos;
begin
  FreeAndNil(FItemViewInfos);
end;

procedure TdxLayoutGroupViewInfo.DestroyScrollBar(var AScrollBar: TdxScrollBarWrapper);
begin
  FreeAndNil(AScrollBar);
end;

procedure TdxLayoutGroupViewInfo.DestroySpecific;
begin
  FreeAndNil(FSpecific);
end;

function TdxLayoutGroupViewInfo.GetClientAreaBounds(const ABounds: TRect): TRect;
var
  AMargins: TRect;
begin
  AMargins := Rect(GetBorderWidth(sdLeft), GetBorderWidth(sdTop), GetBorderWidth(sdRight), GetBorderWidth(sdBottom));
  Result := cxRectContent(ABounds, AMargins);
end;

function TdxLayoutGroupViewInfo.GetItemsAreaBounds(const AClientRect: TRect): TRect;
var
  AMargins: TRect;
begin
  with LayoutLookAndFeel do
    AMargins := Rect(GetBorderWidth(sdLeft), GetBorderWidth(sdTop), GetBorderWidth(sdRight), GetBorderWidth(sdBottom));
  Result := cxRectInflate(AClientRect, AMargins);
end;

function TdxLayoutGroupViewInfo.CanDrawSpecificControls: Boolean;
begin
  Result := Specific.CanDrawSpecificControls;
end;

procedure TdxLayoutGroupViewInfo.CreateViewInfos;
begin
  inherited;
  FButtonsViewInfo := TdxLayoutGroupButtonsViewInfo.Create(Self);
  CreateItemViewInfos;
  CreateSpecific;
  Specific.CreateViewInfos;
end;

procedure TdxLayoutGroupViewInfo.DestroyViewInfos;
begin
  DestroyScrollBar(FMajorScrollBar);
  DestroyScrollBar(FMinorScrollBar);
  Specific.DestroyViewInfos;
  DestroySpecific;
  DestroyItemViewInfos;
  FreeAndNil(FButtonsViewInfo);
  inherited;
end;

procedure TdxLayoutGroupViewInfo.FreeNotification(AComponent: TComponent);
begin
  inherited;
  DestroyScrollBar(FMajorScrollBar);
  DestroyScrollBar(FMinorScrollBar);
end;

procedure TdxLayoutGroupViewInfo.GetElements(AElements: TList);
begin
  inherited;
  Specific.GetElements(AElements);
  ButtonsViewInfo.GetElements(AElements);
end;

{
procedure TdxLayoutGroupViewInfo.ItemChanged(AType: TdxLayoutItemChangeType);
var
  I: Integer;
begin
  inherited;
  for I := 0 to ItemViewInfoCount - 1 do
    ItemViewInfos[I].ItemChanged(AType);
end;
}

procedure TdxLayoutGroupViewInfo.PopulateAutoAlignControlList(AList: TList);
var
  I: Integer;
begin
  if GetRealItemControlAreaAlignment = catAuto then
    for I := 0 to ItemViewInfoCount - 1 do
      ItemViewInfos[I].PopulateAutoAlignControlList(AList);
end;

procedure TdxLayoutGroupViewInfo.PopulateControlViewInfoList(AControls, AWinControls: TList);
var
  I: Integer;
begin
  for I := 0 to ItemViewInfoCount - 1 do
    ItemViewInfos[I].PopulateControlViewInfoList(AControls, AWinControls);
end;

procedure TdxLayoutGroupViewInfo.CheckUIPosition;
begin
 if FMajorScrollBar <> nil then
 begin
    SetScrollBounds(FMajorScrollBar, FMajorScrollBarBounds);
    FMajorScrollBar.Visible := IsScrollBarsVisible;
 end;
 if FMinorScrollBar <> nil then
 begin
   SetScrollBounds(FMinorScrollBar, FMinorScrollBarBounds);
   FMinorScrollBar.Visible := IsScrollBarsVisible;
 end;
end;

function TdxLayoutGroupViewInfo.GetOwnerControl: TcxControl;
begin
  Result := ContainerViewInfo.Container.ItemsParentControl;
end;

function TdxLayoutGroupViewInfo.HasVisibleUI: Boolean;
begin
  Result :=  (FMajorScrollBar <> nil) and FMajorScrollBar.Visible or
    (FMinorScrollBar <> nil) and FMinorScrollBar.Visible;
end;

procedure TdxLayoutGroupViewInfo.HideUI;
begin
  if FMajorScrollBar <> nil then
    FMajorScrollBar.Visible := False;
  if FMinorScrollBar <> nil then
    FMinorScrollBar.Visible := False;
end;

function TdxLayoutGroupViewInfo.GetManager: TdxHybridScrollbarsManager;
begin
  Result := FHybridScrollbarsManager;
end;

function TdxLayoutGroupViewInfo.GetHybridScrollbarBaseColor: TColor;
begin
  Result := LayoutLookAndFeel.ItemOptions.CaptionOptions.TextColor;
  if Result = clDefault then
    Result := clBlack;
end;

procedure TdxLayoutGroupViewInfo.InvalidateScrollbars;
begin
  if FMajorScrollBar <> nil then
    FMajorScrollBar.Invalidate;
  if FMinorScrollBar <> nil then
    FMinorScrollBar.Invalidate;
end;

function TdxLayoutGroupViewInfo.GetControl: TWinControl;
begin
  Result := GetOwnerControl;
end;

function TdxLayoutGroupViewInfo.GetLookAndFeel: TcxLookAndFeel;
begin
  Result := (GetOwnerControl as IcxScrollBarOwner).GetLookAndFeel;
end;

function TdxLayoutGroupViewInfo.GetScaleFactor: TdxScaleFactor;
begin
  Result := (GetOwnerControl as IcxScrollBarOwner).GetScaleFactor;
end;

function TdxLayoutGroupViewInfo.GetOwner2: IcxScrollbarOwner2;
begin
  Result := ContainerViewInfo.GetOwner2;
end;

function TdxLayoutGroupViewInfo.GetCaptionViewInfoClass: TdxCustomLayoutItemCaptionViewInfoClass;
begin
  Result := TdxLayoutGroupCaptionViewInfo;
end;

function TdxLayoutGroupViewInfo.GetHitTestClass: TdxCustomLayoutItemHitTestClass;
begin
  if Group.IsFloatingRoot then
    Result := TdxLayoutFloatingRootHitTest
  else
    if Group.LayoutDirection = ldTabbed then
      Result := TdxLayoutTabbedGroupHitTest
    else
      Result := TdxLayoutGroupHitTest;
end;

function TdxLayoutGroupViewInfo.GetPainterClass: TdxCustomLayoutItemPainterClass;
begin
  Result := TdxCustomLayoutItemPainterClass(LayoutLookAndFeel.GetGroupPainterClass);
end;

function TdxLayoutGroupViewInfo.CalculatePadding: TRect;
begin
  if UseItemsAreaOffsets then
    Result := Group.Padding.GetValues
  else
    Result := inherited CalculatePadding;
end;

procedure TdxLayoutGroupViewInfo.DoRightToLeftConversion(const AClientBounds: TRect);
begin
  inherited DoRightToLeftConversion(AClientBounds);
  FButtonsViewInfo.DoRightToLeftConversion(AClientBounds);
  if (FMajorScrollBar <> nil) and not cxRectIsNull(FMajorScrollBarBounds) then
  begin
    FMajorScrollBarBounds := TdxRightToLeftLayoutConverter.ConvertRect(FMajorScrollBarBounds, AClientBounds);
    SetScrollBounds(FMajorScrollBar, FMajorScrollBarBounds);
  end;
  if (FMinorScrollBar <> nil) and not cxRectIsNull(FMinorScrollBarBounds) then
  begin
    FMinorScrollBarBounds := TdxRightToLeftLayoutConverter.ConvertRect(FMinorScrollBarBounds, AClientBounds);
    SetScrollBounds(FMinorScrollBar, FMinorScrollBarBounds);
  end;
  FCaptionAreaBounds := TdxRightToLeftLayoutConverter.ConvertRect(FCaptionAreaBounds, AClientBounds);
  FButtonsAreaBounds := TdxRightToLeftLayoutConverter.ConvertRect(FButtonsAreaBounds, AClientBounds);
  FClientAreaBounds := TdxRightToLeftLayoutConverter.ConvertRect(FClientAreaBounds, AClientBounds);
  FItemsAreaBounds := TdxRightToLeftLayoutConverter.ConvertRect(FItemsAreaBounds, AClientBounds);
  Specific.DoRightToLeftConversion(AClientBounds);
end;

function TdxLayoutGroupViewInfo.GetAvailableTextAreaWidth: Integer;
var
  AOffset: Integer;
begin
  if IsVerticalCaption then
    Result := Max(0, Bounds.Height)
  else
    Result := inherited;

  if Result > 0 then
  begin
    AOffset := 0;

    if IsVerticalCaption then
      LayoutLookAndFeel.CorrectGroupMinVisibleHeight(Self, AOffset)
    else
      LayoutLookAndFeel.CorrectGroupMinVisibleWidth(Self, AOffset);
    Result := Result - CaptionViewInfo.GetContentOffsetSize.Width - cxMarginsWidth(Padding) - ButtonsViewInfo.CalculateWidth - AOffset;
  end;
end;

function TdxLayoutGroupViewInfo.InternalCalculateHeight: Integer;
begin
  if AllowCollapsedHeight then
    Result := DoCalculateHeight(cstOriginal)
  else
    Result := inherited InternalCalculateHeight;
end;

function TdxLayoutGroupViewInfo.InternalCalculateWidth: Integer;
begin
  if AllowCollapsedWidth then
    Result := DoCalculateWidth(cstOriginal)
  else
    Result := inherited InternalCalculateWidth;
end;

function TdxLayoutGroupViewInfo.DoCalculateHeight(ACalcSizeType: TdxLayoutCalcSizeType): Integer;
begin
  Result := inherited DoCalculateHeight(ACalcSizeType) + GetHeight(Specific.GetItemsAreaHeight(ACalcSizeType));
end;

function TdxLayoutGroupViewInfo.DoCalculateWidth(ACalcSizeType: TdxLayoutCalcSizeType): Integer;
begin
  Result := inherited DoCalculateWidth(ACalcSizeType) + GetWidth(Specific.GetItemsAreaWidth(ACalcSizeType));
end;

procedure TdxLayoutGroupViewInfo.Reset;
var
  I: Integer;
begin
  inherited;
  for I := 0 to ItemViewInfoCount - 1 do
    ItemViewInfos[I].Reset;
  Specific.Reset;
end;

procedure TdxLayoutGroupViewInfo.CorrectDropAreaPart(const P: TPoint; var AAreaPart: TdxLayoutDropAreaPart);
begin
  Specific.CorrectDropAreaPart(P, AAreaPart);
end;

function TdxLayoutGroupViewInfo.GetDestinationItem(const ADropAreaInfo: TdxLayoutDragDropInfo): TdxCustomLayoutItem;
begin
  case ADropAreaInfo.DropAreaPart of
    apNewLayout:
      Result := Specific.GetDropExactItemInRow(ADropAreaInfo.DropClientPoint);
    apBetween:
      Result := Specific.GetDropNearestItem(ADropAreaInfo.DropClientPoint);
  else
    if Group.IsRoot and not cxRectPtIn(ItemsAreaBounds, ADropAreaInfo.DropClientPoint) and
      ((ADropAreaInfo.DropAreaPart in [apLeft, apRight]) and (LayoutDirection = ldHorizontal) or
       (ADropAreaInfo.DropAreaPart in [apTop, apBottom]) and (LayoutDirection = ldVertical)) then
    begin
      Result := Specific.GetDropExactItem(Specific.GetDropNearestPoint(ADropAreaInfo.DropClientPoint));
      if Result = nil then
        Result := Group;
    end
    else
      Result := Group;
  end;
end;

function TdxLayoutGroupViewInfo.GetDropActionType(AAreaPart: TdxLayoutDropAreaPart): TdxLayoutActionType;
begin
  if AAreaPart = apNone then
    Result := atNone
  else
    if (AAreaPart in [apBefore, apAfter, apBetween, apLastChild]) then
      Result := atInsert
    else
      Result := Specific.GetDropActionType(AAreaPart);
end;

function TdxLayoutGroupViewInfo.GetDropAreaPart(var P: TPoint): TdxLayoutDropAreaPart;
begin
  if cxRectIsEmpty(ItemsAreaBounds) then
  begin
    if PtInRect(dxLayoutGetCenterAreaBounds(Bounds), P) and IsExpanded or Group.IsRoot then
      Result := apLastChild
    else
      Result := inherited GetDropAreaPart(P)
  end
  else
  begin
    if not Group.IsLocked then
      Result := Specific.GetDropAreaPart(P)
    else
      Result := apNone;

    if Result = apNone then
      Result := inherited GetDropAreaPart(P)
  end;
end;

function TdxLayoutGroupViewInfo.GetDropExpectedBounds(const ADropAreaInfo: TdxLayoutDragDropInfo): TRect;
begin
  if (ADropAreaInfo.DropAreaPart in [apLeft..apBottom]) and not ADropAreaInfo.DestinationItem.IsRoot and (ADropAreaInfo.DestinationItem = ADropAreaInfo.DestinationGroup) then
    raise Exception.Create('GetDropExpectedBounds fails');

  Result := Specific.GetDropExpectedBounds(ADropAreaInfo);
end;

function TdxLayoutGroupViewInfo.GetDropExpectedAlign(const ADropAreaInfo: TdxLayoutDragDropInfo): TdxLayoutAlign;
begin
  Result := TdxLayoutAlign(Specific.GetDropExpectedAlign(ADropAreaInfo));
end;

function TdxLayoutGroupViewInfo.GetDropHorzAlignForLocale(const AHorzAlign: TdxLayoutAlignHorz): TdxLayoutAlignHorz;

  function GetRightToLeftAlignHorz(const AHorzAlign: TdxLayoutAlignHorz): TdxLayoutAlignHorz;
  begin
    case AHorzAlign of
      ahLeft:
        Result := ahRight;
      ahRight:
        Result := ahLeft
    else
      Result := AHorzAlign;
    end;
  end;

begin
  if ContainerViewInfo.Container.UseRightToLeftAlignment then
    Result := GetRightToLeftAlignHorz(AHorzAlign)
  else
    Result := AHorzAlign;
end;

function TdxLayoutGroupViewInfo.CanFocusOnClick(X, Y: Integer): Boolean;
begin
  Result := Specific.CanFocusOnClick(X, Y);
end;

procedure TdxLayoutGroupViewInfo.KeyDown(var Key: Word; Shift: TShiftState);
begin
  Specific.KeyDown(Key, Shift);
end;

function TdxLayoutGroupViewInfo.HasCaption: Boolean;
begin
  Result := inherited HasCaption and HasBorder;
end;

function TdxLayoutGroupViewInfo.HasBorder: Boolean;
begin
  Result := Group.ShowBorder and ((ParentViewInfo = nil) or
    ParentViewInfo.AllowChildHasBorder or IsDragImagePainting and IsDragged);
end;

function TdxLayoutGroupViewInfo.HasButtons: Boolean;
begin
  Result := HasBorder and Group.IsAnyButtonVisible;
end;

function TdxLayoutGroupViewInfo.HasExpandButton: Boolean;
begin
  Result := Group.ButtonOptions.ShowExpandButton;
end;

function CompareLayoutItemViewInfos(Item1, Item2: TdxLayoutLabeledItemViewInfo): Integer;
begin
  Result := Ord(Item2.CaptionLayout) - Ord(Item1.CaptionLayout);
end;

function IsCaptionLayoutHorizontal(AItemViewInfo: TdxLayoutCellItemViewInfo): Boolean;
begin
  Result := AItemViewInfo.CaptionLayout in [clLeft, clRight];
end;

function IsCaptionLayoutVertical(AItemViewInfo: TdxLayoutCellItemViewInfo): Boolean;
begin
  Result := AItemViewInfo.CaptionLayout in [clTop, clBottom];
end;

function ComparePositionItemViewInfos(Item1, Item2: TdxLayoutCellItemViewInfo): Integer;
begin
  if Item1 = Item2 then
    Result := 0
  else
  begin
    if IsCaptionLayoutHorizontal(Item1) and Item1.Item.IsHorzPositionStable and Item2.Item.IsHorzPositionStable or
       IsCaptionLayoutVertical(Item1) and Item1.Item.IsVertPositionStable and Item2.Item.IsVertPositionStable then
      case Item1.CaptionLayout of
        clLeft:
          Result := Item1.Bounds.Left - Item2.Bounds.Left;
        clTop:
          Result := Item1.Bounds.Top - Item2.Bounds.Top;
        clRight:
          Result := Item1.Bounds.Right - Item2.Bounds.Right;
        clBottom:
          Result := Item1.Bounds.Bottom - Item2.Bounds.Bottom;
      else
        Result := 0;
      end
    else
      Result := -1;
  end;
end;

type
  TdxList = class(TList)
  public
    procedure MoveFrom(AList: TList; ACurIndex, ANewIndex: Integer);
  end;

procedure TdxList.MoveFrom(AList: TList; ACurIndex, ANewIndex: Integer);
var
  AItem: Pointer;
begin
  AItem := AList[ACurIndex];
  AList[ACurIndex] := nil;
  AList.Delete(ACurIndex);
  Insert(ANewIndex, nil);
  Items[ANewIndex] := AItem;
end;

function TdxLayoutGroupViewInfo.AutoAlignControls: Boolean;

  function GetViewInfo(AList: TList; AIndex: Integer): TdxLayoutCellItemViewInfo;
  begin
    Result := TdxLayoutCellItemViewInfo(AList.List[AIndex]);
  end;

  procedure ExtractSameLayoutItemViewInfos(AOriginalList, AList: TdxList; AItemViewInfo: TdxLayoutItemViewInfo);
  var
    I: Integer;
  begin
    AList.Clear;
    for I := AOriginalList.Count - 1 downto 0 do
      if CompareLayoutItemViewInfos(AOriginalList[I], AItemViewInfo) = 0 then
        AList.MoveFrom(AOriginalList, I, 0);
  end;

  procedure ExtractSamePositionItemViewInfos(AOriginalList, AList: TdxList; AItemViewInfo: TdxLayoutCellItemViewInfo);
  var
    I: Integer;
  begin
    AList.Clear;
    for I := AOriginalList.Count - 1 downto 0 do
    begin
      if ComparePositionItemViewInfos(AOriginalList[I], AItemViewInfo) = 0 then
        AList.MoveFrom(AOriginalList, I, 0);
    end;
  end;

  procedure AlignControls(AList: TdxList);

    function GetMaxCaptionSize: Integer;
    var
      I, ACaptionSize: Integer;
      AItemViewInfo: TdxLayoutCellItemViewInfo;
    begin
      Result := 0;
      for I := 0 to AList.Count - 1 do
      begin
        AItemViewInfo := GetViewInfo(AList, I);
        if IsCaptionLayoutHorizontal(AItemViewInfo) then
          ACaptionSize := AItemViewInfo.CaptionViewInfo.Width + AItemViewInfo.ElementOffsetHorz
        else
          ACaptionSize := AItemViewInfo.CaptionViewInfo.Height + AItemViewInfo.ElementOffsetVert;
        Result := Max(Result, ACaptionSize);
      end;
    end;

    procedure AssignCaptionSizes(AMaxCaptionSize: Integer);
    var
      I: Integer;
      AItemViewInfo: TdxLayoutCellItemViewInfo;
    begin
      for I := 0 to AList.Count - 1 do
      begin
        AItemViewInfo := GetViewInfo(AList, I);
        if IsCaptionLayoutHorizontal(AItemViewInfo) then
          AItemViewInfo.CaptionViewInfo.Width :=
            AItemViewInfo.ParentViewInfo.GetLevelingItemCaptionWidth(AItemViewInfo, AMaxCaptionSize - AItemViewInfo.ElementOffsetHorz)
        else
          AItemViewInfo.CaptionViewInfo.Height := AMaxCaptionSize - AItemViewInfo.ElementOffsetVert;
      end;
    end;

  begin
    if AList.Count < 2 then Exit;
    AssignCaptionSizes(GetMaxCaptionSize);
    Reset;
    Calculate(Bounds);
  end;

  procedure PopulateOwnAlignControlList(AList: TList);
  var
    I: Integer;
  begin
    for I := 0 to ItemViewInfoCount - 1 do
      ItemViewInfos[I].PopulateAutoAlignControlList(AList);
  end;

var
  AAllItemViewInfos, ASameLayoutItemViewInfos, ASamePositionItemViewInfos: TdxList;
  I: Integer;
begin
  Result := False;
  for I := 0 to ItemViewInfoCount - 1 do
    Result := ItemViewInfos[I].AutoAlignControls or Result;

  if GetRealItemControlAreaAlignment = catOwn then
  begin
    AAllItemViewInfos := TdxList.Create;
    ASameLayoutItemViewInfos := TdxList.Create;
    ASamePositionItemViewInfos := TdxList.Create;
    try
      PopulateOwnAlignControlList(AAllItemViewInfos);
      while AAllItemViewInfos.Count > 0 do
      begin
        Result := True;
        ExtractSameLayoutItemViewInfos(AAllItemViewInfos, ASameLayoutItemViewInfos, AAllItemViewInfos[0]);
        while ASameLayoutItemViewInfos.Count > 0 do
        begin
          ExtractSamePositionItemViewInfos(ASameLayoutItemViewInfos, ASamePositionItemViewInfos, ASameLayoutItemViewInfos[0]);
          AlignControls(ASamePositionItemViewInfos);
        end;
      end;
    finally
      ASamePositionItemViewInfos.Free;
      ASameLayoutItemViewInfos.Free;
      AAllItemViewInfos.Free;
    end;
  end;
end;

procedure TdxLayoutGroupViewInfo.CalculateButtonsAreaBounds;
begin
  FButtonsAreaBounds := BorderBounds[CaptionSide];
  case CaptionSide of
    sdLeft, sdRight:
      begin
        if CaptionSide = sdLeft then
          FButtonsAreaBounds.Right := FButtonsAreaBounds.Left + ButtonsViewInfo.CalculateWidth
        else
          FButtonsAreaBounds.Left := FButtonsAreaBounds.Right - ButtonsViewInfo.CalculateWidth;
        if (CaptionSide = sdLeft) xor ButtonsViewInfo.IsLeftAlignment then
        begin
          FButtonsAreaBounds.Top := FButtonsAreaBounds.Top + ButtonsOffset;
          FButtonsAreaBounds.Bottom := FButtonsAreaBounds.Top + ButtonsViewInfo.CalculateHeight;
        end
        else
        begin
          FButtonsAreaBounds.Bottom := FButtonsAreaBounds.Bottom - ButtonsOffset;
          FButtonsAreaBounds.Top := FButtonsAreaBounds.Bottom - ButtonsViewInfo.CalculateHeight;
        end;
      end;
    sdTop, sdBottom:
      begin
        if CaptionSide = sdTop then
          FButtonsAreaBounds.Bottom := FButtonsAreaBounds.Top + ButtonsViewInfo.CalculateHeight
        else
          FButtonsAreaBounds.Top := FButtonsAreaBounds.Bottom - ButtonsViewInfo.CalculateHeight;
        if ButtonsViewInfo.IsLeftAlignment then
        begin
          FButtonsAreaBounds.Left := FButtonsAreaBounds.Left + ButtonsOffset;
          FButtonsAreaBounds.Right := FButtonsAreaBounds.Left + ButtonsViewInfo.CalculateWidth;
        end
        else
        begin
          FButtonsAreaBounds.Right := FButtonsAreaBounds.Right - ButtonsOffset;
          FButtonsAreaBounds.Left := FButtonsAreaBounds.Right - ButtonsViewInfo.CalculateWidth;
        end;
      end;
  end;
  LayoutLookAndFeel.CorrectGroupButtonsAreaBounds(Self, FButtonsAreaBounds);
end;

procedure TdxLayoutGroupViewInfo.CalculateCaptionAreaBounds;

  procedure CalculateHorizontalPosition;
  var
    ACaptionWidth: Integer;
  begin
    ACaptionWidth := CaptionViewInfo.CalculateWidth;
    with FCaptionAreaBounds do
      case CaptionViewInfo.AlignHorz of
        taLeftJustify:
          begin
            Inc(Left, CaptionOffset);
            Right := Left + ACaptionWidth;
          end;
        taRightJustify:
          begin
            Dec(Right, CaptionOffset);
            Left := Right - ACaptionWidth;
          end;
        taCenter:
          begin
            Left := (Left + Right - ACaptionWidth) div 2;
            Right := Left + ACaptionWidth;
          end;
      end;
  end;

  procedure CalculateVerticalPosition;
  var
    ACaptionHeight: Integer;
  begin
    ACaptionHeight := CaptionViewInfo.CalculateHeight;
    with FCaptionAreaBounds do
      case CaptionViewInfo.AlignVert of
        tavTop:
          begin
            Inc(Top, CaptionOffset);
            Bottom := Top + ACaptionHeight;
          end;
        tavBottom:
          begin
            Dec(Bottom, CaptionOffset);
            Top := Bottom - ACaptionHeight;
          end;
        tavCenter:
          begin
            Top := (Top + Bottom - ACaptionHeight) div 2;
            Bottom := Top + ACaptionHeight;
          end
      end;
  end;

begin
  FCaptionAreaBounds := Bounds;

  with FCaptionAreaBounds do
  begin
    case CaptionSide of
      sdTop, sdBottom:
        begin
          CalculateHorizontalPosition;
          if CaptionSide = sdTop then
            Bottom := Top + CaptionViewInfo.GetAvailableHeight
          else
            Top := Bottom - CaptionViewInfo.GetAvailableHeight;
        end;
      sdLeft, sdRight:
        begin
          CalculateVerticalPosition;
          if CaptionSide = sdLeft then
            Right := Left + CaptionViewInfo.GetAvailableWidth
          else
            Left := Right - CaptionViewInfo.GetAvailableWidth;
        end;
    end;
  end;
  LayoutLookAndFeel.CorrectGroupCaptionAreaBounds(Self, FCaptionAreaBounds);
end;

procedure TdxLayoutGroupViewInfo.CalculateClientBounds;
begin
  FClientAreaBounds := GetClientAreaBounds(Bounds);
end;

procedure TdxLayoutGroupViewInfo.CalculateItemsAreaBounds;
begin
  FItemsAreaBounds := cxRectInflate(ClientBounds, -ItemsAreaOffsetHorz, -ItemsAreaOffsetVert);
  FItemsAreaBounds := cxRectContent(FItemsAreaBounds, Padding);
  Specific.CalculateItemsAreaBounds(FItemsAreaBounds);
end;

procedure TdxLayoutGroupViewInfo.CalculateOffsets;
begin
  if UseItemsAreaOffsets then
    if Group.IsRoot then
    begin
      ItemsAreaOffsetHorz := LayoutLookAndFeel.GetRootItemsAreaOffsetHorz(Item.Container);
      ItemsAreaOffsetVert := LayoutLookAndFeel.GetRootItemsAreaOffsetVert(Item.Container);
    end
    else
    begin
      ItemsAreaOffsetHorz := LayoutLookAndFeel.GetItemsAreaOffsetHorz(Item.Container);
      ItemsAreaOffsetVert := LayoutLookAndFeel.GetItemsAreaOffsetVert(Item.Container);
    end
  else
  begin
    ItemsAreaOffsetHorz := 0;
    ItemsAreaOffsetVert := 0;
  end;

  if UseItemOffset then
    ItemOffset := LayoutLookAndFeel.GetItemOffset(Item.Container)
  else
    ItemOffset := 0;

  Specific.CalculateOffsets;
end;

procedure TdxLayoutGroupViewInfo.CalculateViewInfoBounds;
var
  ACaptionArea: TRect;
  AOffsetY, AOffsetX: Integer;
begin
  CalculateCaptionAreaBounds;
  CalculateButtonsAreaBounds;
  if HasButtons then
  begin
    if IsVerticalCaption then
    begin
      AOffsetX := (FButtonsAreaBounds.Width - FCaptionAreaBounds.Width) div 2;
      if AOffsetX > 0 then
        FCaptionAreaBounds := cxRectOffset(FCaptionAreaBounds, AOffsetX, 0, CaptionSide = sdLeft)
      else
        FButtonsAreaBounds := cxRectOffset(FButtonsAreaBounds, -AOffsetX, 0, CaptionSide = sdLeft);

      if HasCaption and HasButtons then
      begin
        if ((CaptionSide = sdLeft) xor ButtonsViewInfo.IsLeftAlignment) and (FCaptionAreaBounds.Top < FButtonsAreaBounds.Bottom) then
          FCaptionAreaBounds := cxRectOffset(FCaptionAreaBounds, 0, FCaptionAreaBounds.Top - FButtonsAreaBounds.Bottom, False);
        if ((CaptionSide = sdRight) xor ButtonsViewInfo.IsLeftAlignment) and (FCaptionAreaBounds.Bottom > FButtonsAreaBounds.Top) then
          FCaptionAreaBounds := cxRectOffset(FCaptionAreaBounds, 0, FCaptionAreaBounds.Bottom - FButtonsAreaBounds.Top, False);
      end;
    end
    else
    begin
      AOffsetY := (FButtonsAreaBounds.Height - FCaptionAreaBounds.Height) div 2;
      if AOffsetY > 0 then
        FCaptionAreaBounds := cxRectOffset(FCaptionAreaBounds, 0, AOffsetY, CaptionSide = sdTop)
      else
        FButtonsAreaBounds := cxRectOffset(FButtonsAreaBounds, 0, -AOffsetY, CaptionSide = sdTop);

      if HasCaption and HasButtons then
      begin
        if not ButtonsViewInfo.IsLeftAlignment and (FCaptionAreaBounds.Right > FButtonsAreaBounds.Left) then
          FCaptionAreaBounds := cxRectOffset(FCaptionAreaBounds, FCaptionAreaBounds.Right - FButtonsAreaBounds.Left, 0, False);
        if ButtonsViewInfo.IsLeftAlignment and (FButtonsAreaBounds.Right > FCaptionAreaBounds.Left) then
          FCaptionAreaBounds := cxRectOffset(FCaptionAreaBounds, FButtonsAreaBounds.Right - FCaptionAreaBounds.Left, 0);
      end;
    end;
  end;

  if FIsMaxWidth then
  begin
    if IsVerticalCaption then
      ACaptionArea := cxRectInflate(Bounds, 0, -CaptionOffset)
    else
      ACaptionArea := cxRectInflate(Bounds, -CaptionOffset, 0);
    cxRectIntersect(FCaptionAreaBounds, FCaptionAreaBounds, ACaptionArea);
  end;
end;

procedure TdxLayoutGroupViewInfo.CalculateInternalViewInfos;
begin
  CaptionViewInfo.Calculate(FCaptionAreaBounds);
  ButtonsViewInfo.Calculate(FButtonsAreaBounds);
end;

function TdxLayoutGroupViewInfo.GetButtonsOffset: Integer;
begin
  Result := LayoutLookAndFeel.GetGroupButtonsOffset(Self);
end;

function TdxLayoutGroupViewInfo.GetButtonsSpace: Integer;
begin
  Result := 2;
end;

function TdxLayoutGroupViewInfo.GetCaptionOffset: Integer;
begin
  Result := LayoutLookAndFeel.GetGroupCaptionOffset(Self);
end;

function TdxLayoutGroupViewInfo.GetSpaceBetweenButtons: Integer;
begin
  Result := Group.ScaleFactor.Apply(
    LayoutLookAndFeel.GroupOptions.SpaceBetweenButtons,
    TdxCustomLayoutLookAndFeelAccess(LayoutLookAndFeel).ScaleFactor);
end;

function TdxLayoutGroupViewInfo.GetInscribedRect(const AInscribeRect: TRect): TRect;
begin
  if cxRectIntersect(Result, AInscribeRect, ItemsAreaBounds) then
    Result := GetVisiblePart(Result);
end;

function TdxLayoutGroupViewInfo.GetBorderWidth(ASide: TdxLayoutSide): Integer;
var
  ACaptionHeight: Integer;
  ACaptionWidth: Integer;
  ATextHeight: Integer;
  ATextWidth: Integer;
begin
  Result := 0;
  if HasBorder then
  begin
    Result := LayoutLookAndFeel.GetGroupBorderWidth(Item.Container, ASide, CaptionSide, HasCaption or HasButtons, IsExpanded);
    if (ASide = CaptionSide) and (HasCaption or HasButtons) then
    begin
      if CaptionViewInfo.IsVerticalCaption then
      begin
        ATextWidth := CaptionViewInfo.GetAvailableTextWidth;
        Inc(Result, Max(ATextWidth, CaptionViewInfo.ImageWidth) - ATextWidth);
        ACaptionWidth := CaptionViewInfo.GetAvailableWidth;
        Inc(Result, Max(ACaptionWidth, ButtonsViewInfo.CalculateWidth) - ACaptionWidth);
      end
      else
      begin
        ATextHeight := CaptionViewInfo.GetAvailableTextHeight;
        Inc(Result, Max(ATextHeight, CaptionViewInfo.ImageHeight) - ATextHeight);
        ACaptionHeight := CaptionViewInfo.GetAvailableHeight;
        Inc(Result, Max(ACaptionHeight, ButtonsViewInfo.CalculateHeight) - ACaptionHeight);
      end;
    end;
  end;
end;

function TdxLayoutGroupViewInfo.GetColor: TColor;
begin
  Result := Options.GetColor;
end;

function TdxLayoutGroupViewInfo.IsDefaultColor: Boolean;
begin
  Result := Options.Color = clDefault;
end;

function TdxLayoutGroupViewInfo.IsSkinPainterUsed: Boolean;
begin
  Result := TdxCustomLayoutLookAndFeelAccess(LayoutLookAndFeel).IsSkinPainterUsed;
end;

function TdxLayoutGroupViewInfo.IsTransparent: Boolean;
begin
  Result := TdxCustomLayoutLookAndFeelAccess(LayoutLookAndFeel).IsGroupTransparent(Self);
end;

function TdxLayoutGroupViewInfo.IsEllipsisAllowed(AForDrawing: Boolean = False): Boolean;
begin
  Result := CaptionViewInfo.EllipsisPosition <> epNone;
end;

function TdxLayoutGroupViewInfo.IsWordWrapAllowed: Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to ItemViewInfoCount - 1 do
  begin
    Result := ItemViewInfos[I].IsWordWrapAllowed;
    if Result then
      Break;
  end;
end;

function TdxLayoutGroupViewInfo.GetMinVisibleHeight: Integer;
begin
  if HasCaption then
    Result := CaptionViewInfo.CalculateMinHeight
  else
    Result := 0;
  if HasButtons then
    if IsVerticalCaption then
      Inc(Result, ButtonsViewInfo.CalculateMinHeight)
    else
      Result := Max(Result, ButtonsViewInfo.CalculateMinHeight);

  LayoutLookAndFeel.CorrectGroupMinVisibleHeight(Self, Result);

  Result := Max(Result, dxLayoutItemMinSize);
end;

function TdxLayoutGroupViewInfo.GetMinVisibleWidth: Integer;
begin
  if HasCaption then
    Result := CaptionViewInfo.CalculateMinWidth
  else
    Result := 0;
  if HasButtons then
    if IsVerticalCaption then
      Result := Max(Result, ButtonsViewInfo.CalculateMinWidth)
    else
      Inc(Result, ButtonsViewInfo.CalculateMinWidth);

  LayoutLookAndFeel.CorrectGroupMinVisibleWidth(Self, Result);

  Result := Max(Result, dxLayoutItemMinSize);
end;

function TdxLayoutGroupViewInfo.GetRestSpaceBounds: TRect;
begin
  Result := LayoutLookAndFeel.GetGroupRestSpaceBounds(Self);
end;

function TdxLayoutGroupViewInfo.CanAssignBounds(ASource: TdxCustomLayoutElementViewInfo): Boolean;
begin
  Result := inherited CanAssignBounds(ASource) and (ItemViewInfoCount = TdxLayoutGroupViewInfo(ASource).ItemViewInfoCount);
end;

procedure TdxLayoutGroupViewInfo.DoAssignBounds(ASource: TdxCustomLayoutElementViewInfo);
var
  I: Integer;
  AGroupViewInfo: TdxLayoutGroupViewInfo;
begin
  inherited;
  AGroupViewInfo := TdxLayoutGroupViewInfo(ASource);
  FCaptionAreaBounds := AGroupViewInfo.FCaptionAreaBounds;
  FButtonsAreaBounds := AGroupViewInfo.FButtonsAreaBounds;
  FClientAreaBounds := AGroupViewInfo.FClientAreaBounds;
  FItemsAreaBounds := AGroupViewInfo.FItemsAreaBounds;
  FFrameBounds := AGroupViewInfo.FFrameBounds;
  FButtonsViewInfo.AssignBounds(AGroupViewInfo.FButtonsViewInfo);

  for I := 0 to ItemViewInfoCount - 1 do
    ItemViewInfos[I].AssignBounds(AGroupViewInfo.ItemViewInfos[I]);
  Specific.AssignBounds(AGroupViewInfo.Specific);

  if AGroupViewInfo.FMajorScrollBar <> nil then
  begin
    if FMajorScrollBar = nil then
      FMajorScrollBar := CreateScrollBar;
    InitializeMajorScrollBar(AGroupViewInfo.FMajorScrollBar.Max + 1, AGroupViewInfo.FMajorScrollBar.PageSize);
    if UseRightToLeftAlignment then
    begin
      FMajorScrollBarBounds := TdxRightToLeftLayoutConverter.ConvertRect(FMajorScrollBarBounds, ItemsAreaBounds);
      SetScrollBounds(FMajorScrollBar, FMajorScrollBarBounds);
    end;
    FMajorScrollBar.Visible := IsScrollBarsVisible;
  end;

  if AGroupViewInfo.FMinorScrollBar <> nil then
  begin
    if FMinorScrollBar = nil then
      FMinorScrollBar := CreateScrollBar;
    InitializeMinorScrollBar(AGroupViewInfo.FMinorScrollBar.Max + 1, AGroupViewInfo.FMinorScrollBar.PageSize);
    if UseRightToLeftAlignment then
    begin
      FMinorScrollBarBounds := TdxRightToLeftLayoutConverter.ConvertRect(FMinorScrollBarBounds, ItemsAreaBounds);
      SetScrollBounds(FMinorScrollBar, FMinorScrollBarBounds);
    end;
    FMinorScrollBar.Visible := IsScrollBarsVisible;
  end;
end;

procedure TdxLayoutGroupViewInfo.DoSetOffset(const AValue, ADiff: TPoint);
var
  I: Integer;
begin
  inherited;
  FCaptionAreaBounds := cxRectOffset(FCaptionAreaBounds, ADiff);
  FButtonsAreaBounds := cxRectOffset(FButtonsAreaBounds, ADiff);
  FClientAreaBounds := cxRectOffset(FClientAreaBounds, ADiff);
  FItemsAreaBounds := cxRectOffset(FItemsAreaBounds, ADiff);
  if not cxRectIsNull(FFrameBounds) then
    FFrameBounds := cxRectOffset(FFrameBounds, ADiff);
  FButtonsViewInfo.Offset := AValue;
  for I := 0 to ItemViewInfoCount - 1 do
    ItemViewInfos[I].Offset := AValue;
  Specific.Offset := AValue;

  if FMajorScrollBar <> nil then
  begin
    SetScrollBounds(FMajorScrollBar, cxRectOffset(FMajorScrollBarBounds, ADiff));
    FMajorScrollBarBounds := FMajorScrollBar.BoundsRect;
    FMajorScrollBar.Visible := IsScrollBarsVisible;
  end;

  if FMinorScrollBar <> nil then
  begin
    SetScrollBounds(FMinorScrollBar, cxRectOffset(FMinorScrollBarBounds, ADiff));
    FMinorScrollBarBounds := FMinorScrollBar.BoundsRect;
    FMinorScrollBar.Visible := IsScrollBarsVisible;
  end;
end;

function TdxLayoutGroupViewInfo.CanHandleMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean;
begin
  Result := PtInRect(Bounds, MousePos) and ActuallyVisible and
    ((LayoutDirection = ldHorizontal) and (FMinorScrollBar <> nil) or ((LayoutDirection = ldVertical) and (FMajorScrollBar <> nil)));
end;

procedure TdxLayoutGroupViewInfo.DoMajorScroll(Sender: TObject; AScrollCode: TScrollCode; var AScrollPos: Integer);

  procedure InternalScroll(var APosition: Integer);
  var
    APos: Integer;
  begin
    APos := ViewData.ScrollPos.Major;
    case AScrollCode of
      scLineUp:
        Dec(APos, FMajorScrollBar.SmallChange);
      scLineDown:
        Inc(APos, FMajorScrollBar.SmallChange);
      scPageUp:
        Dec(APos, FMajorScrollBar.LargeChange);
      scPageDown:
        Inc(APos, FMajorScrollBar.LargeChange);
    else
      APos := APosition;
    end;
    APosition := APos;
  end;

begin
  if FMajorScrollBar <> nil then
  begin
    InternalScroll(AScrollPos);
    CheckScrollPos(FMajorScrollBar, AScrollPos);
    ViewData.ScrollPos := TdxAbsPoint(Point(AScrollPos, ViewData.FScrollPos.Minor));
    ContainerViewInfo.Container.DoGroupScroll(Self); 
  end;
end;

procedure TdxLayoutGroupViewInfo.DoMinorScroll(Sender: TObject; AScrollCode: TScrollCode; var AScrollPos: Integer);

  procedure InternalScroll(var APosition: Integer);
  var
    APos: Integer;
  begin
    APos := ViewData.ScrollPos.Minor;
    case AScrollCode of
      scLineUp:
        Dec(APos, FMinorScrollBar.SmallChange);
      scLineDown:
        Inc(APos, FMinorScrollBar.SmallChange);
      scPageUp:
        Dec(APos, FMinorScrollBar.LargeChange);
      scPageDown:
        Inc(APos, FMinorScrollBar.LargeChange);
    else
      APos := APosition;
    end;
    APosition := APos;
  end;

begin
  if FMinorScrollBar <> nil then
  begin
    InternalScroll(AScrollPos);
    CheckScrollPos(FMinorScrollBar, AScrollPos);
    ViewData.ScrollPos := TdxAbsPoint(Point(ViewData.FScrollPos.Major, AScrollPos));
    ContainerViewInfo.Container.DoGroupScroll(Self); 
  end;
end;

function TdxLayoutGroupViewInfo.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean;

  function GetScrollCode(AWheelDelta: Integer): TScrollCode;
  begin
    case Sign(AWheelDelta) of
      1: Result := scLineUp;
    else // -1
      Result := scLineDown;
    end;
  end;

var
  I: Integer;
  APosition: Integer;
begin
  Result := False;

  for I := 0 to ItemViewInfoCount - 1 do
    Result := Result or ItemViewInfos[I].DoMouseWheel(Shift, WheelDelta, MousePos);

  if not Result and CanHandleMouseWheel(Shift, WheelDelta, MousePos) then
  begin
    Result := True;
    for I := 0 to Mouse.WheelScrollLines - 1 do
    begin
       if LayoutDirection <> ldHorizontal then
       begin
         APosition := FMajorScrollBar.Position;
         DoMajorScroll(FMajorScrollBar, GetScrollCode(WheelDelta), APosition);
       end
       else
       begin
         APosition := FMinorScrollBar.Position;
         DoMinorScroll(FMinorScrollBar, GetScrollCode(WheelDelta), APosition);
       end;
    end;
  end;
end;

function TdxLayoutGroupViewInfo.IsMouseWheelHandleNeeded(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean;
var
  I: Integer;
begin
  Result := False;

  for I := 0 to ItemViewInfoCount - 1 do
    Result := Result or ItemViewInfos[I].IsMouseWheelHandleNeeded(Shift, WheelDelta, MousePos);

  Result := Result or CanHandleMouseWheel(Shift, WheelDelta, MousePos);
end;

function TdxLayoutGroupViewInfo.IsScrollBarsVisible: Boolean;
begin
  Result := ContainerViewInfo.CanShowGroupScrollBars and ActuallyVisible;
end;

function TdxLayoutGroupViewInfo.AllowChildHasBorder: Boolean;
begin
  Result := Specific.AllowChildHasBorder;
end;

function TdxLayoutGroupViewInfo.AllowCollapsedHeight: Boolean;
begin
  Result := not IsExpanded and ((ParentViewInfo = nil) or (ParentViewInfo.LayoutDirection = ldVertical));
end;

function TdxLayoutGroupViewInfo.AllowCollapsedWidth: Boolean;
begin
  Result := not IsExpanded and ((ParentViewInfo = nil) or (ParentViewInfo.LayoutDirection = ldHorizontal));
end;

function TdxLayoutGroupViewInfo.AllowDrawChild(AChildViewInfo: TdxCustomLayoutItemViewInfo): Boolean;
begin
  Result := Group.AllowShowChild(AChildViewInfo.Item) and Specific.AllowDrawChild(AChildViewInfo) and IsExpanded;
end;

function TdxLayoutGroupViewInfo.AllowMajorScroll: Boolean;
begin
  Result := Specific.AllowMajorScroll and
    ((Group.ScrollOptions.MajorScroll = smIndependent) or
      (Group.ScrollOptions.MajorScroll = smAuto) and
      (Specific.IsMajorSizeFixed or
        ((ParentViewInfo = nil) or
          ((ParentViewInfo.LayoutDirection = LayoutDirection) and not ParentViewInfo.AllowMajorScroll or
           (ParentViewInfo.LayoutDirection <> LayoutDirection) and not ParentViewInfo.AllowMinorScroll))));
end;

function TdxLayoutGroupViewInfo.AllowMinorScroll: Boolean;
begin
  Result := Specific.AllowMinorScroll and
    ((Group.ScrollOptions.MinorScroll = smIndependent) or
      (Group.ScrollOptions.MinorScroll = smAuto) and
      (Specific.IsMinorSizeFixed or
      ((ParentViewInfo = nil) or
        ((ParentViewInfo.LayoutDirection = LayoutDirection) and not ParentViewInfo.AllowMinorScroll or
         (ParentViewInfo.LayoutDirection <> LayoutDirection) and not ParentViewInfo.AllowMajorScroll))));
end;

function TdxLayoutGroupViewInfo.GetChildInplaceRenameBounds(AChildViewInfo: TdxCustomLayoutItemViewInfo): TRect;
begin
  Result := Specific.GetChildInplaceRenameBounds(AChildViewInfo);
end;

function TdxLayoutGroupViewInfo.GetRotationAngle: TcxRotationAngle;
const
  ResultMap: array[TdxLayoutSide] of TcxRotationAngle = (raPlus90, raMinus90, ra0, ra0);
begin
  Result := ResultMap[CaptionSide];
end;

function TdxLayoutGroupViewInfo.IsChildActuallyVisible(AChildViewInfo: TdxCustomLayoutItemViewInfo): Boolean;
begin
  Result := ActuallyVisible and AllowDrawChild(AChildViewInfo);
end;

function TdxLayoutGroupViewInfo.IsExpanded: Boolean;
begin
  Result := ViewData.Expanded;
end;

function TdxLayoutGroupViewInfo.IsVerticalCaption: Boolean;
begin
  Result := CaptionSide in [sdLeft, sdRight];
end;

function TdxLayoutGroupViewInfo.GetSpecificClass: TdxLayoutGroupViewInfoSpecificClass;
begin
  Result := Group.GetHelperClass.GetSpecificClass;
end;

procedure TdxLayoutGroupViewInfo.PaintSelectionLayer(ABitmap: TcxAlphaBitmap; var ADrawingRect: TRect);
var
  I: Integer;
begin
  inherited;
  for I := 0 to ItemViewInfoCount - 1 do
    if ItemViewInfos[I].ActuallyVisible then
      ItemViewInfos[I].PaintSelectionLayer(ABitmap, ADrawingRect);
end;

function TdxLayoutGroupViewInfo.GetMaxTabOrder: Integer;
var
  I: Integer;
begin
  Result := inherited GetMaxTabOrder;
  for I := 0 to ItemViewInfoCount - 1 do
    if ItemViewInfos[I].ActuallyVisible then
      Result := Max(Result, ItemViewInfos[I].GetMaxTabOrder);
end;

function TdxLayoutGroupViewInfo.GetHeight(AItemsAreaHeight: Integer): Integer;
begin
  Result := Max(MinVisibleHeight, BorderWidths[sdTop] + BorderWidths[sdBottom] +
    IfThen(AllowCollapsedHeight, 0, ItemsAreaOffsetVert + Specific.GetItemsAreaOffset(sdTop) + AItemsAreaHeight +
    ItemsAreaOffsetVert + Specific.GetItemsAreaOffset(sdBottom) + Padding.Top + Padding.Bottom));
end;

function TdxLayoutGroupViewInfo.GetWidth(AItemsAreaWidth: Integer): Integer;
begin
  Result := Max(MinVisibleWidth, BorderWidths[sdLeft] + BorderWidths[sdRight] +
    IfThen(AllowCollapsedWidth, 0, ItemsAreaOffsetHorz + Specific.GetItemsAreaOffset(sdLeft) +
    AItemsAreaWidth + ItemsAreaOffsetHorz + Specific.GetItemsAreaOffset(sdRight) + Padding.Left + Padding.Right));
end;

function TdxLayoutGroupViewInfo.GetLevelingItemCaptionWidth(AItemViewInfo: TdxLayoutCellItemViewInfo; AMaxCaptionSize: Integer): Integer;

  function GetSimpleLevelingItemCaptionWidth: Integer;
  var
    AMinWidth, AMaxWidth, AGroupDelta, ACaptionDelta: Integer;
  begin
    AMinWidth := GetGroupWidth(Group);
    if ParentViewInfo <> nil then
      AMaxWidth := ParentViewInfo.ItemsAreaBounds.Width
    else
      AMaxWidth := Bounds.Width;
    AGroupDelta := AMaxWidth - AMinWidth;
    ACaptionDelta := AMaxCaptionSize - AItemViewInfo.CaptionViewInfo.Width;
    if (AGroupDelta < 0) or (AGroupDelta >= ACaptionDelta) then
      Result := AMaxCaptionSize
    else
      Result := AMaxCaptionSize - (ACaptionDelta - AGroupDelta);
  end;

  function GetComplexLevelingItemCaptionWidth: Integer;
  var
    ACaptionDelta, AFreeSpace: Integer;
  begin
    AFreeSpace := GetFreeSpaceForItem(AItemViewInfo.Item);
    ACaptionDelta := AMaxCaptionSize - AItemViewInfo.CaptionViewInfo.Width;
    if (AFreeSpace >= 0) and (AFreeSpace < ACaptionDelta) then
      Result := AItemViewInfo.CaptionViewInfo.Width + AFreeSpace
    else
      Result := AMaxCaptionSize;
  end;

begin
  if Group.FWrappingState = wsPopulated then
    if Group.LayoutDirection = ldVertical then
      Result := GetComplexLevelingItemCaptionWidth
    else
      Result := Min(GetComplexLevelingItemCaptionWidth, GetSimpleLevelingItemCaptionWidth)
  else
    Result := AMaxCaptionSize;
end;

function TdxLayoutGroupViewInfo.UseItemOffset: Boolean;
begin
  Result := Group.UseIndent;
end;

function TdxLayoutGroupViewInfo.UseItemsAreaOffsets: Boolean;
begin
  Result := Group.ShowBorder or Group.IsRoot;
end;

procedure TdxLayoutGroupViewInfo.Calculate(const ABounds: TRect);
begin
  FFrameBounds := cxNullRect; 

  inherited;

  CalculateViewInfoBounds;
  CalculateInternalViewInfos;
  CalculateClientBounds;
  CalculateItemsAreaBounds;
  Specific.Calculate(ItemsAreaBounds);
end;

procedure TdxLayoutGroupViewInfo.CalculateInternalTabOrders(var AAvailableTabOrder: Integer);

  function IsNearItem(AItem: TdxCustomLayoutItemViewInfo): Boolean;
  begin
    Result :=
     (LayoutDirection = ldHorizontal) and (AItem.AlignHorz <> ahRight) or
     (LayoutDirection = ldVertical) and (AItem.AlignVert <> avBottom);
  end;

var
  I: Integer;
  AResidualList: TdxFastList;
  AItem: TdxCustomLayoutItemViewInfo;
  AIsDisabledAutoControlTabOrders: Boolean;
begin
  Specific.CalculateInternalTabOrders(AAvailableTabOrder);
  AIsDisabledAutoControlTabOrders := not Group.Container.IsAutoControlTabOrders;
  AResidualList := TdxFastList.Create(ItemViewInfoCount);
  try
    for I := 0 to ItemViewInfoCount - 1 do
    begin
      AItem := ItemViewInfos[I];
      if AItem.ActuallyVisible then
        if AIsDisabledAutoControlTabOrders or
          (LayoutDirection = ldTabbed) or IsNearItem(AItem) then
          AItem.CalculateInternalTabOrders(AAvailableTabOrder)
        else
          AResidualList.Add(AItem);
    end;
    for I := 0 to AResidualList.Count - 1 do
      TdxCustomLayoutItemViewInfo(AResidualList.List[I]).CalculateInternalTabOrders(AAvailableTabOrder);
  finally
    AResidualList.Free;
  end;
end;

procedure TdxLayoutGroupViewInfo.CalculateTabOrders(var AAvailableTabOrder: Integer);
var
  I: Integer;
begin
  for I := 0 to ItemViewInfoCount - 1 do
    ItemViewInfos[I].CalculateTabOrders(AAvailableTabOrder);
end;

function TdxLayoutGroupViewInfo.FindItemViewInfo(AItem: TdxCustomLayoutItem): TdxCustomLayoutItemViewInfo;
var
  I: Integer;
  AViewInfo: TdxCustomLayoutItemViewInfo;
begin
  if Item = AItem then
    Result := Self
  else
  begin
    Result := nil;
    for I := 0 to ItemViewInfoCount - 1 do
    begin
      AViewInfo := ItemViewInfos[I];
      if AViewInfo is TdxLayoutGroupViewInfo then
        Result := AViewInfo.AsGroupViewInfo.FindItemViewInfo(AItem)
      else
        if AViewInfo.Item = AItem then
          Result := AViewInfo;
      if Result <> nil then
        Break;
    end;
  end;
end;

function TdxLayoutGroupViewInfo.GetHitTest(const P: TPoint): TdxCustomLayoutHitTest;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to ItemViewInfoCount - 1 do
  begin
    Result := ItemViewInfos[I].GetHitTest(P);
    if Result <> nil then
      Break;
  end;
  if Result = nil then
    Result := inherited GetHitTest(P);
end;

function TdxLayoutGroupViewInfo.GetItemWithMouse(const P: TPoint): TdxCustomLayoutItem;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to ItemViewInfoCount - 1 do
  begin
    Result := ItemViewInfos[I].GetItemWithMouse(P);
    if Result <> nil then
      Break;
  end;
  if Result = nil then
    Result := inherited GetItemWithMouse(P);
end;

function TdxLayoutGroupViewInfo.GetInsertionPos(const P: TPoint): Integer;
var
  R: TRect;
begin
  if PtInRect(Bounds, P) then
    for Result := 0 to ItemViewInfoCount - 1 do
    begin
      R := ItemViewInfos[Result].Bounds;
      if Specific.IsAtInsertionPos(R, P) then Exit;
    end;
  Result := ItemViewInfoCount;
end;

function TdxLayoutGroupViewInfo.HasScrollBars: Boolean;
begin
  Result := (FMajorScrollBar <> nil) or (FMinorScrollBar <> nil);
end;

procedure TdxLayoutGroupViewInfo.MakeVisible(const ARect: TRect; AFully: Boolean);
begin
  if not cxRectContain(ItemsAreaBounds, ARect) then
    Specific.MakeVisible(ARect, AFully);
  inherited;
end;

{ TdxLayoutRootViewInfo }

function TdxLayoutRootViewInfo.GetBackgroundColor: TColor;
begin
  if ContainerViewInfo.NeedHighlightRoot then
    Result := dxLayoutHiddenGroupBackgroundDefaultColor
  else
    Result := inherited GetBackgroundColor;
end;

{ TdxLayoutContainerViewInfo }

constructor TdxLayoutContainerViewInfo.Create(AContainer: TdxLayoutContainer);
begin
  inherited Create;
  FContainer := AContainer;
  FItemViewInfoDictionary := TDictionary<TdxCustomLayoutItem, TdxCustomLayoutItemViewInfo>.Create;
  FItemViewDataList := TdxLayoutItemViewDataList.Create(True);
end;

destructor TdxLayoutContainerViewInfo.Destroy;
begin
  FItemWithMouse := nil;
  DestroyViewInfos;
  FreeAndNil(FItemViewInfoDictionary);
  FreeAndNil(FItemViewDataList);
  FreeAndNil(FSelectionLayer);
  inherited;
end;

procedure TdxLayoutContainerViewInfo.Calculate(ARecreateViewData: Boolean);
begin
  PrepareData(ARecreateViewData);
  DoCalculate(False);
  Container.PlaceControls(ItemsViewInfo);
end;

procedure TdxLayoutContainerViewInfo.CalculateTabOrders;
begin
  if Container.IsAutoControlTabOrders then
    DoCalculateTabOrders;
end;

function TdxLayoutContainerViewInfo.FindItemViewInfo(AItem: TdxCustomLayoutItem; out AViewInfo: TdxCustomLayoutItemViewInfo): Boolean;
begin
  Result := FItemViewInfoDictionary.TryGetValue(AItem, AViewInfo);
end;

function TdxLayoutContainerViewInfo.GetHitTest(const P: TPoint): TdxCustomLayoutHitTest;
begin
  Result := nil;
  if Container.CanGetHitTest(P) then
  begin
    if PtInRect(ItemsViewInfo.Bounds, P) then
      Result := ItemsViewInfo.GetHitTest(P);
    if Result = nil then
    begin
      Result := TdxLayoutClientAreaHitTest.Instance;
      TdxLayoutClientAreaHitTest(Result).Container := Container;
    end;
  end;
  if Result = nil then
    Result := TdxLayoutNoneHitTest.Instance;
end;

function TdxLayoutContainerViewInfo.GetItemViewInfo(AItem: TdxCustomLayoutItem): TdxCustomLayoutItemViewInfo;
begin
  FindItemViewInfo(AItem, Result);
end;

function TdxLayoutContainerViewInfo.GetItemWithMouse(const P: TPoint): TdxCustomLayoutItem;
begin
  if FIsValid and (ItemsViewInfo <> nil) then
    Result := ItemsViewInfo.GetItemWithMouse(P)
  else
    Result := nil;
end;

procedure TdxLayoutContainerViewInfo.AssignItemWithMouse(X, Y: Integer);
var
  AHitTest: TdxCustomLayoutHitTest;
begin
  if Container.IsCustomization then
    ItemWithMouse := GetItemWithMouse(Point(X, Y))
  else
  begin
    AHitTest := GetHitTest(Point(X, Y));
    if AHitTest.Item <> nil then
      ItemWithMouse := AHitTest.Item
    else
      ItemWithMouse := nil;
  end;
end;

function TdxLayoutContainerViewInfo.CanFocusOnClick(X, Y: Integer): Boolean;
var
  AViewInfo: TdxCustomLayoutItemViewInfo;
  AItem: TdxCustomLayoutItem;
begin
  AItem := GetItemWithMouse(Point(X, Y));
  Result := AItem = nil;
  if not Result then
  begin
    AViewInfo := AItem.ViewInfo;
    Result := (AViewInfo <> nil) and AViewInfo.CanFocusOnClick(X, Y);
  end;
end;

procedure TdxLayoutContainerViewInfo.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  AViewInfo: TdxCustomLayoutItemViewInfo;
  AHitItemViewInfo: TdxCustomLayoutItemViewInfo;
  AHitTest: TdxCustomLayoutHitTest;
begin
  AssignItemWithMouse(X, Y);
  if (ItemWithMouse <> nil) and FindItemViewInfo(ItemWithMouse, AViewInfo) then
  begin
    AHitTest := GetHitTest(Point(X, Y));
    if not (AHitTest is TdxCustomLayoutItemHitTest) or
      not FindItemViewInfo(TdxCustomLayoutItemHitTest(AHitTest).GetSourceItem, AHitItemViewInfo) or
      AHitItemViewInfo.IsParentLocked then
        AHitItemViewInfo := AViewInfo;
    AViewInfo.MouseDown(Button, Shift, X, Y);
    if Container.IsCustomization then
      AHitItemViewInfo.CustomizationMouseDown(Button, Shift, X, Y);
  end;
end;

procedure TdxLayoutContainerViewInfo.MouseLeave(AControl: TControl);
begin
  ItemWithMouse := nil;
end;

procedure TdxLayoutContainerViewInfo.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  AViewInfo: TdxCustomLayoutItemViewInfo;
begin
  AssignItemWithMouse(X, Y);
  if (ItemWithMouse <> nil) and FindItemViewInfo(ItemWithMouse, AViewInfo) then
    AViewInfo.MouseMove(Shift, X, Y);
end;

procedure TdxLayoutContainerViewInfo.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  AViewInfo: TdxCustomLayoutItemViewInfo;
begin
  AssignItemWithMouse(X, Y);
  if (ItemWithMouse <> nil) and FindItemViewInfo(ItemWithMouse, AViewInfo) then
    AViewInfo.MouseUp(Button, Shift, X, Y);
end;

function TdxLayoutContainerViewInfo.CanShowGroupScrollBars: Boolean;
begin
  Result := IsActuallyVisible;
end;

procedure TdxLayoutContainerViewInfo.CreateViewInfos;
begin
  if LayoutLookAndFeel <> nil then
    FRootViewInfo := CreateItemViewInfo(nil, FContainer.Root) as TdxLayoutRootViewInfo;
end;

function TdxLayoutContainerViewInfo.CreateItemViewInfo(AParentViewInfo: TdxLayoutGroupViewInfo; AItem: TdxCustomLayoutItem): TdxCustomLayoutItemViewInfo;
var
  AViewData: TdxCustomLayoutItemViewData;
begin
  AViewData := GetViewData(AItem);
  Result := AItem.GetViewInfoClass.Create(Self, AParentViewInfo, AViewData);
  AViewData.ViewInfo := Result;
  FItemViewInfoDictionary.Add(AItem, Result);
end;

procedure TdxLayoutContainerViewInfo.DestroyViewInfos;
begin
  FreeAndNil(FRootViewInfo);
  FItemViewInfoDictionary.Clear;
end;

function TdxLayoutContainerViewInfo.GetRootViewInfoClass: TdxLayoutRootViewInfoClass;
begin
  Result := TdxLayoutRootViewInfo;
end;

procedure TdxLayoutContainerViewInfo.PrepareData(ARecreateViewData: Boolean);
begin
  RecreateViewInfos(ARecreateViewData);
end;

procedure TdxLayoutContainerViewInfo.RecreateViewData;
var
  I: Integer;
begin
  for I := ItemViewDataList.Count - 1 downto 0  do
    if ItemViewDataList[I].Item = nil then
      ItemViewDataList.Delete(I);
end;

procedure TdxLayoutContainerViewInfo.RecreateViewInfos(ARecreateViewData: Boolean = False);
begin
  DestroyViewInfos;
  if ARecreateViewData then
    RecreateViewData;
  CreateViewInfos;
end;

function ConstraintCompare(AItem1, AItem2: Pointer): Integer;
var
  AConstraint1, AConstraint2: TdxLayoutAlignmentConstraint;
  AValue1, AValue2: Integer;
begin
  AConstraint1 := TdxLayoutAlignmentConstraint(AItem1);
  AConstraint2 := TdxLayoutAlignmentConstraint(AItem2);
//  Result := Ord(AConstraint1.Kind) - Ord(AConstraint2.Kind);
//  if Result = 0 then
   AValue1 := AConstraint1.GetMostBorderValue;
   AValue2 := AConstraint2.GetMostBorderValue;
   if AValue1 < AValue2 then
     Result := -1
   else
     if AValue1 > AValue2 then
       Result := 1
     else
       Result := 0;
end;

function TdxLayoutContainerViewInfo.AlignItemsByConstraint: Boolean;

  procedure ProcessConstraint(AConstraint: TdxLayoutAlignmentConstraint);
  var
    ACount: Integer;
    AAreAligned: Boolean;
  begin
    ACount := AConstraint.Count;
    repeat
      AConstraint.AlignItemViewInfos(ACount);
      CalculateItemsViewInfo;
      AAreAligned := AConstraint.AreItemViewInfosAligned(ACount);
      if not AAreAligned then
      begin
        AConstraint.ResetOffsets;
        CalculateItemsViewInfo;
      end;
      Dec(ACount);
    until (ACount < 2) or AAreAligned;
  end;

var
  I: Integer;
begin
  Container.FAlignmentConstraints.Sort(ConstraintCompare);
  Result := Container.AlignmentConstraintCount > 0;
  for I := 0 to Container.AlignmentConstraintCount - 1 do
    ProcessConstraint(Container.AlignmentConstraints[I]);
end;

function TdxLayoutContainerViewInfo.AutoAlignControls: Boolean;
begin
  Result := ItemsViewInfo.AutoAlignControls;
end;

procedure TdxLayoutContainerViewInfo.CalculateItemsViewInfo;
begin
  FNeedRecalculate := False;
  ResetContentBounds;
  ItemsViewInfo.Calculate(ContentBounds);
end;

procedure TdxLayoutContainerViewInfo.CalculateContentBounds;

  function CalculateContentWidth: Integer;
  begin
    if ItemsViewInfo.AlignHorz = ahClient then
      Result := Max(ClientBounds.Width, ItemsViewInfo.MinWidth)
    else
      Result := ItemsViewInfo.CalculateWidth;
  end;

  function CalculateContentHeight: Integer;
  begin
    if ItemsViewInfo.AlignVert = avClient then
      Result := Max(ClientBounds.Height, ItemsViewInfo.MinHeight)
    else
      Result := ItemsViewInfo.CalculateHeight;
  end;

var
  AContentWidth, AContentHeight: Integer;
begin
  AContentWidth := CalculateContentWidth;
  AContentHeight := CalculateContentHeight;
  FContentBounds := cxRectBounds(FOffset.X, FOffset.Y, AContentWidth, AContentHeight);
end;

procedure TdxLayoutContainerViewInfo.DoCalculate(AHard: Boolean = True);

  procedure InternalCalculate;
  begin
    FNeedRecalculate := True;
    CalculateItemsViewInfo;
    FNeedRecalculate := AutoAlignControls or FNeedRecalculate;  
    FNeedRecalculate := AlignItemsByConstraint or FNeedRecalculate;
    while FNeedRecalculate do
      CalculateItemsViewInfo;
  end;

  procedure DoRightToLeftConversion;
  var
    R: TRect;
  begin
    R := GetItemsParentBounds;
    FContentBounds := TdxRightToLeftLayoutConverter.ConvertRect(FContentBounds, R);
    FRootViewInfo.DoRightToLeftConversion(R);
  end;

begin
  if AHard then
    PrepareData(False);

  InternalCalculate;

  if Container.AllowWrapItems then
  begin
    Container.PopulateWrappingGroups;
    PrepareData(False);
    InternalCalculate;
  end;


  if Container.UseRightToLeftAlignment then
    DoRightToLeftConversion;

  DoCalculateInternalTabOrders;
  CalculateTabOrders;
end;

procedure TdxLayoutContainerViewInfo.DoCalculateInternalTabOrders;
var
  AAvailableTabOrder: Integer;
begin
  AAvailableTabOrder := 0;
  ItemsViewInfo.CalculateInternalTabOrders(AAvailableTabOrder);
end;

procedure TdxLayoutContainerViewInfo.DoCalculateTabOrders;
var
  AAvailableTabOrder: Integer;
begin
  AAvailableTabOrder := 0;
  ItemsViewInfo.CalculateTabOrders(AAvailableTabOrder);
end;

function TdxLayoutContainerViewInfo.GetItemsParentBounds: TRect;
begin
  Result := Container.ItemsParentControl.Bounds;
end;

function TdxLayoutContainerViewInfo.GetOwner2: IcxScrollbarOwner2;
begin
  Result := nil;
end;

procedure TdxLayoutContainerViewInfo.InvalidateSelectionLayer(const R: TRect);
begin
  if FSelectionLayer <> nil then
    FSelectionLayer.InvalidateRect(R);
end;

function TdxLayoutContainerViewInfo.ShowHint(var AHintInfo: THintInfo; X, Y: Integer): Boolean;
var
  AViewInfo: TdxCustomLayoutItemViewInfo;
begin
  AssignItemWithMouse(X, Y);
  Result := (ItemWithMouse <> nil) and FindItemViewInfo(ItemWithMouse, AViewInfo) and AViewInfo.ShowHint(AHintInfo);
end;

function TdxLayoutContainerViewInfo.CanUseCachedInfo: Boolean;
begin
  Result := True;
end;

function TdxLayoutContainerViewInfo.IsTransparent: Boolean;
begin
  Result := Container.IsTransparent;
end;

function TdxLayoutContainerViewInfo.IsTransparentBackground: Boolean;
begin
  Result := Container.IsTransparentBackground;
end;

function TdxLayoutContainerViewInfo.IsActuallyVisible: Boolean;
begin
  Result := True;
end;

function TdxLayoutContainerViewInfo.NeedHighlightRoot: Boolean;
begin
  Result := Container.HighlightRoot and Container.IsDesigning;
end;

function TdxLayoutContainerViewInfo.GetScrollOffset: TPoint;
begin
  Result := Container.GetScrollOffset;
end;

function TdxLayoutContainerViewInfo.IsMouseWheelHandleNeeded(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean;
begin
  Result := RootViewInfo.IsMouseWheelHandleNeeded(Shift, WheelDelta, MousePos);
end;

function TdxLayoutContainerViewInfo.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean;
begin
  Result := RootViewInfo.DoMouseWheel(Shift, WheelDelta, MousePos);
end;

function TdxLayoutContainerViewInfo.GetTouchScrollUIOwner(const APoint: TPoint): IdxTouchScrollUIOwner;

  function FindScrollBarOwner(AGroupViewInfo: TdxLayoutGroupViewInfo): TdxLayoutGroupViewInfo;
  begin
    Result := AGroupViewInfo;
    while (Result <> nil) and not Result.HasScrollBars do
      Result := Result.ParentViewInfo;
  end;

var
  AHitTest: TdxCustomLayoutHitTest;
begin
  AHitTest := GetHitTest(APoint);
  if AHitTest is TdxLayoutGroupHitTest then
    Result := FindScrollBarOwner(TdxLayoutGroupHitTest(AHitTest).ViewInfo)
  else
    if AHitTest is TdxCustomLayoutItemHitTest then
      Result := FindScrollBarOwner(AHitTest.ViewInfo.ParentViewInfo)
    else
      Result := nil;
end;

procedure TdxLayoutContainerViewInfo.AssignBounds(ASource: TdxLayoutContainerViewInfo);
begin
  if CanAssignBounds(ASource) then
    DoAssignBounds(ASource);
end;

function TdxLayoutContainerViewInfo.CanAssignBounds(ASource: TdxLayoutContainerViewInfo): Boolean;
begin
  Result := ASource is ClassType;
end;

procedure TdxLayoutContainerViewInfo.DoAssignBounds(ASource: TdxLayoutContainerViewInfo);
begin
  FOffset := ASource.FOffset;
  FContentBounds := ASource.FContentBounds;
  RootViewInfo.AssignBounds(ASource.RootViewInfo);
end;

function TdxLayoutContainerViewInfo.GetViewData(AItem: TdxCustomLayoutItem): TdxCustomLayoutItemViewData;
begin
  if not FindCloneData(AItem, Result) then
  begin
    Result := GetViewDataClass(AItem).Create(FItemViewDataList, AItem);
    FItemViewDataList.Add(Result);
    Result.Calculate;
  end;
end;

function TdxLayoutContainerViewInfo.GetViewDataClass(AItem: TdxCustomLayoutItem): TdxCustomLayoutItemViewDataClass;
begin
  case AItem.GetItemClassKind of
    ickGroup, ickAutoCreatedGroup:
      Result := TdxLayoutGroupViewData;
  else
    Result := TdxCustomLayoutItemViewData;
  end;
end;

function TdxLayoutContainerViewInfo.FindCloneData(AItem: TdxCustomLayoutItem; out ACloneData: TdxCustomLayoutItemViewData): Boolean;
var
  I: Integer;
begin
  ACloneData := nil;
  for I := 0 to FItemViewDataList.Count - 1 do
    if FItemViewDataList[I].Item = AItem then
    begin
      ACloneData := FItemViewDataList[I];
      Break;
    end;
  Result := ACloneData <> nil;
end;

function TdxLayoutContainerViewInfo.IsDragImagePainting: Boolean;
begin
  Result := FIsDragImagePainting;
end;

procedure TdxLayoutContainerViewInfo.FinishDragImagePainting;
begin
  FIsDragImagePainting := False;
end;

procedure TdxLayoutContainerViewInfo.StartDragImagePainting;
begin
  FIsDragImagePainting := True;
end;

procedure TdxLayoutContainerViewInfo.ResetContentBounds;
begin
  SetRectEmpty(FContentBounds);
  ItemsViewInfo.Reset;
end;

procedure TdxLayoutContainerViewInfo.BuildSelectionLayer;

  function NeedSelectionLayer(ASelection: TList): Boolean;
  var
    I: Integer;
    AIntf: IdxLayoutSelectableItem;
  begin
    Result := Container.IsCustomization and not Container.IsUpdateLocked;
    if Result and Container.IsDesigning then
    begin
      Result := False;
      for I := 0 to ASelection.Count - 1 do
      begin
        if Supports(TObject(ASelection.List[I]), IdxLayoutSelectableItem, AIntf) and AIntf.IsOwner(Container) then
        begin
          Result := True;
          AIntf := nil;
          Break;
        end;
      end;
    end;
  end;

  procedure DrawParentControl(AParent: TWinControl; ABitmap: TcxBitmap32; ASelection: TList);
  var
    AList: TList;
    I: Integer;
    ARect: TRect;
  begin
    AList := TList.Create;
    try
      AList.Add(Pointer(SelectionLayer.Handle));
      cxPaintTo(AParent, ABitmap.cxCanvas, cxNullPoint, SelectionLayer.BoundsRect, AList);
      for I := 0 to ASelection.Count - 1 do
        if not Supports(TObject(ASelection[I]), IdxLayoutSelectableItem) and (TObject(ASelection[I]) is TWinControl) and (IsParent(AParent, TWinControl(ASelection[I])) or (ASelection[I] = AParent)) then
        begin
          ARect := cxGetWindowBounds(TWinControl(ASelection[I]));
          if ASelection[I] <> AParent then
            ARect := cxRectOffset(ARect, TWinControl(ASelection[I]).ClientToParent(Point(0, 0), AParent));
          ABitmap.cxCanvas.FillRect(cxRectBounds(ARect.Left, ARect.Top, 4, 4), clBlack);
          ABitmap.cxCanvas.FillRect(cxRectBounds(ARect.Right - 4, ARect.Top, 4, 4), clBlack);
          ABitmap.cxCanvas.FillRect(cxRectBounds(ARect.Left, ARect.Bottom - 4, 4, 4), clBlack);
          ABitmap.cxCanvas.FillRect(cxRectBounds(ARect.Right - 4, ARect.Bottom - 4, 4, 4), clBlack);
        end;
    finally
      AList.Free;
    end;
  end;

var
  ASelection: TList;
  ASelectionBounds, ALayerDrawingBounds: TRect;
  ASelectionBitmap: TcxAlphaBitmap;
begin
  ASelection := TList.Create;
  try
    Container.GetSelection(ASelection);
    if NeedSelectionLayer(ASelection) then
    begin
      if not Container.FSelectionLayerPainting then
      begin
        Container.FSelectionLayerPainting := True;
        try
          if SelectionLayer = nil then
            CreateSelectionLayer;
          SendMessage(SelectionLayer.Handle, WM_SETREDRAW, 0, 0);
          try
            SelectionLayer.BoundsRect := ClientBounds;
            SelectionLayer.SelectionImage.Clear;
            ASelectionBounds := cxInvalidRect;
            DrawParentControl(Container.ItemsParentControl, SelectionLayer.DrawBitmap, ASelection);

            MoveWindowOrg(SelectionLayer.SelectionImage.Canvas.Handle, -ClientBounds.Left, -ClientBounds.Top);
            ItemsViewInfo.PaintSelectionLayer(SelectionLayer.SelectionImage, ASelectionBounds);

            if TdxLayoutDragAndDropState.StateIn([ddsInProcess]) and (TdxLayoutDragAndDropState.DestinationContainer = Container) then
              TdxLayoutDragAndDropState.PaintDestinationArea(SelectionLayer.SelectionImage, ASelectionBounds);

            cxRectIntersect(ALayerDrawingBounds, ASelectionBounds, SelectionLayer.DrawBitmap.ClientRect);
            SelectionLayer.HasIntersection := not cxRectIsEqual(ALayerDrawingBounds, ASelectionBounds);
            if not cxRectIsEmpty(ALayerDrawingBounds) then
            begin
              ASelectionBitmap := TcxAlphaBitmap.CreateSize(ALayerDrawingBounds);
              try
                ASelectionBitmap.CopyBitmap(SelectionLayer.SelectionImage, ASelectionBitmap.ClientRect, ALayerDrawingBounds.TopLeft);
                cxAlphaBlend(SelectionLayer.DrawBitmap.cxCanvas.Handle, ASelectionBitmap.cxCanvas.Handle, ALayerDrawingBounds, ASelectionBitmap.ClientRect);
              finally
                ASelectionBitmap.Free;
              end;
            end;
          finally
            SendMessage(SelectionLayer.Handle, WM_SETREDRAW, 1, 0);
          end;
        finally
          Container.FSelectionLayerPainting := False;
        end;
        SelectionLayer.UpdateContent;
      end;
    end
    else
      FreeAndNil(FSelectionLayer);
  finally
    ASelection.Free;
  end;
end;

procedure TdxLayoutContainerViewInfo.CreateSelectionLayer;
begin
  FSelectionLayer := TdxSelectionLayer.Create(Container);
  FSelectionLayer.ParentControl := Container.ItemsParentControl;
  FSelectionLayer.OnHitTest := SelectionLayerHitTest;
  FSelectionLayer.OnUpdate := SelectionLayerUpdate;
  FSelectionLayer.OnEndRename := SelectionLayerEndRename;
end;

function TdxLayoutContainerViewInfo.GetCanvas: TcxCanvas;
begin
  Result := Container.GetCanvas;
end;

function TdxLayoutContainerViewInfo.GetClientBounds: TRect;
begin
  Result := Container.GetClientBounds;
end;

function TdxLayoutContainerViewInfo.GetContentBounds: TRect;
begin
  if IsRectEmpty(FContentBounds) then
    CalculateContentBounds;
  Result := FContentBounds;
end;

function TdxLayoutContainerViewInfo.GetContentHeight: Integer;
begin
  Result := ContentBounds.Height;
end;

function TdxLayoutContainerViewInfo.GetContentWidth: Integer;
begin
  Result := ContentBounds.Width;
end;

function TdxLayoutContainerViewInfo.GetItemsViewInfo: TdxLayoutGroupViewInfo;
begin
  Result := FRootViewInfo;
end;

function TdxLayoutContainerViewInfo.GetNormalContentWidth: Integer;
begin
  Result := ItemsViewInfo.CalculateWidth - (-GetScrollOffset.X + FOffset.X);
end;

function TdxLayoutContainerViewInfo.GetLayoutLookAndFeel: TdxCustomLayoutLookAndFeel;
begin
  Result := Container.GetLayoutLookAndFeel;
end;

function TdxLayoutContainerViewInfo.GetItemLayoutLookAndFeel(AViewInfo: TdxCustomLayoutItemViewInfo): TdxCustomLayoutLookAndFeel;
begin
  Result := AViewInfo.Item.GetLayoutLookAndFeel;
end;

function TdxLayoutContainerViewInfo.GetItemOptions(AViewInfo: TdxCustomLayoutItemViewInfo): TdxCustomLayoutLookAndFeelOptions;
begin
  if AViewInfo.Item.IsGroup then
    Result := AViewInfo.LayoutLookAndFeel.GroupOptions
  else
    Result := AViewInfo.LayoutLookAndFeel.ItemOptions;
end;

procedure TdxLayoutContainerViewInfo.MakeVisible(const ARect: TRect; AFully: Boolean);
begin
  Container.MakeVisible(ARect, AFully);
end;

procedure TdxLayoutContainerViewInfo.SelectionLayerHitTest(ASender: TObject; var AIsTransparent: Boolean);
begin
  AIsTransparent := not Container.Customization;
end;

procedure TdxLayoutContainerViewInfo.SelectionLayerUpdate(Sender: TObject);
begin
  SelectionLayer.BringToFront;
end;

procedure TdxLayoutContainerViewInfo.SelectionLayerEndRename(ASender: TObject; const AText: string; AAccept: Boolean);
begin
  if AAccept then
    Container.EndRename(AText)
  else
    Container.CancelRename;
end;

procedure TdxLayoutContainerViewInfo.SetItemWithMouse(Value: TdxCustomLayoutItem);
var
  AViewInfo: TdxCustomLayoutItemViewInfo;
begin
  if FItemWithMouse <> Value then
  begin
    if (FItemWithMouse <> nil) and FindItemViewInfo(FItemWithMouse, AViewInfo) and (AViewInfo.Item <> nil) then
      AViewInfo.MouseLeave;
    FItemWithMouse := Value;
    if (FItemWithMouse <> nil) and FindItemViewInfo(FItemWithMouse, AViewInfo) then
      AViewInfo.MouseEnter;
  end;
end;

procedure TdxLayoutContainerViewInfo.SetOffset(const Value: TPoint);
var
  AOffset: TPoint;
begin
  if not cxPointIsEqual(FOffset, Value) then
  begin
    AOffset := cxPointOffset(Value, Offset, False);
    FOffset := Value;
    if Container.UseRightToLeftAlignment then
      AOffset.X := -AOffset.X;
    FContentBounds := cxRectOffset(FContentBounds, AOffset);
    ItemsViewInfo.Offset := FOffset;
  end;
end;

{ TdxCustomLayoutGroupHelper }

class function TdxLayoutGroupHelper.GetChildItemsAlignHorz: TdxLayoutRealAlignHorz;
begin
  Result := ahClient;
end;

class function TdxLayoutGroupHelper.GetChildItemsAlignVert: TdxLayoutRealAlignVert;
begin
  Result := avClient;
end;

class function TdxLayoutGroupHelper.GetOrthogonalDirection: TdxLayoutDirection;
begin
  Result := ldVertical;
end;

class function TdxLayoutGroupHelper.GetSpecificClass: TdxLayoutGroupViewInfoSpecificClass;
begin
  Result := TdxLayoutGroupViewInfoSpecific;
end;

{ TdxLayoutHorizontalGroupHelper }

class function TdxLayoutHorizontalGroupHelper.GetChildItemsAlignHorz: TdxLayoutRealAlignHorz;
begin
  Result := ahLeft;
end;

class function TdxLayoutHorizontalGroupHelper.GetChildItemsAlignVert: TdxLayoutRealAlignVert;
begin
  Result := avClient;
end;

class function TdxLayoutHorizontalGroupHelper.GetOrthogonalDirection: TdxLayoutDirection;
begin
  Result := ldVertical;
end;

class function TdxLayoutHorizontalGroupHelper.GetSpecificClass: TdxLayoutGroupViewInfoSpecificClass;
begin
  Result := TdxLayoutGroupViewInfoHorizontalSpecific;
end;

{ TdxLayoutVerticalGroupHelper }

class function TdxLayoutVerticalGroupHelper.GetChildItemsAlignHorz: TdxLayoutRealAlignHorz;
begin
  Result := ahClient;
end;

class function TdxLayoutVerticalGroupHelper.GetChildItemsAlignVert: TdxLayoutRealAlignVert;
begin
  Result := avTop;
end;

class function TdxLayoutVerticalGroupHelper.GetOrthogonalDirection: TdxLayoutDirection;
begin
  Result := ldHorizontal;
end;

class function TdxLayoutVerticalGroupHelper.GetSpecificClass: TdxLayoutGroupViewInfoSpecificClass;
begin
  Result := TdxLayoutGroupViewInfoVerticalSpecific;
end;

{ TdxLayoutTabbedGroupHelper }

class function TdxLayoutTabbedGroupHelper.GetChildItemsAlignHorz: TdxLayoutRealAlignHorz;
begin
  Result := ahClient;
end;

class function TdxLayoutTabbedGroupHelper.GetChildItemsAlignVert: TdxLayoutRealAlignVert;
begin
  Result := avClient;
end;

class function TdxLayoutTabbedGroupHelper.GetOrthogonalDirection: TdxLayoutDirection;
begin
  Result := ldTabbed;
end;

class function TdxLayoutTabbedGroupHelper.GetSpecificClass: TdxLayoutGroupViewInfoSpecificClass;
begin
  Result := TdxLayoutGroupViewInfoTabbedSpecific;
end;

{ TdxLayoutTabbedOptions }

constructor TdxLayoutTabbedOptions.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
end;

destructor TdxLayoutTabbedOptions.Destroy;
begin
  FreeAndNil(FInternalImages);
  inherited Destroy;
end;

procedure TdxLayoutTabbedOptions.InsertTab(AItem: TdxCustomLayoutItem);
begin
  BeginUpdate;
  try
    Tabs.InsertObject(AItem.Index, GetItemCaption(AItem), AItem);
  finally
    CancelUpdate;
  end;
end;

procedure TdxLayoutTabbedOptions.DoChanged(AType: TcxCustomTabControlPropertiesChangedType = pctHard);
begin
  inherited DoChanged(AType);
  if AType = pctHard then
    RefreshImages;
end;

procedure TdxLayoutTabbedOptions.DoChanging(ANewTabIndex: Integer; var AAllowChange: Boolean);
begin
  inherited;
  AAllowChange := AAllowChange and Group.DoTabChanging(ANewTabIndex);
end;

procedure TdxLayoutTabbedOptions.CheckTabs;
var
  I: Integer;
begin
  BeginUpdate;
  try
    for I := 0 to Group.Count - 1 do
      Tabs.Move(Tabs.IndexOfObject(Group[I]), I);
  finally
    CancelUpdate;
  end;
end;

procedure TdxLayoutTabbedOptions.DeleteTab(AItem: TdxCustomLayoutItem);
var
  AIndex: Integer;
begin
  BeginUpdate;
  try
    AIndex := Tabs.IndexOfObject(AItem);
    if AIndex >= 0 then
      Tabs.Delete(AIndex);
  finally
    CancelUpdate;
  end;
end;

procedure TdxLayoutTabbedOptions.DoSetTabIndex(Value: Integer);
begin
  Group.TabIndex := Value;
end;

function TdxLayoutTabbedOptions.GetItem(AIndex: Integer): TdxCustomLayoutItem;
begin
  Result := TdxCustomLayoutItem(Tabs.Objects[AIndex]);
end;

function TdxLayoutTabbedOptions.GetTabControl: IcxTabControl;
begin
  Result := Group.ViewInfo.Specific as IcxTabControl;
end;

function TdxLayoutTabbedOptions.GetTabIndex: Integer;
begin
  Result := Group.ItemIndex;
end;

procedure TdxLayoutTabbedOptions.RefreshImages;

  function AddImage(AItem: TdxCustomLayoutItem; AIndex: Integer): Integer;
  var
    AGlyph: TdxSmartGlyph;
    AImageIndex: Integer;
    AImages: TCustomImageList;
    AIsAlphaUsed: Boolean;
    AMask: TcxAlphaBitmap;
  begin
    AItem.CaptionOptions.ImageOptions.GetCurrentImage(AGlyph, AImages, AImageIndex);
    Result := InternalImages.Add(cxPrepareBitmapForDrawing(AGlyph, AImages, AImageIndex, True, clNone,
      Group.GetLayoutLookAndFeel.GetTabbedGroupCaptionColorPalette(TabIndex = AIndex),
      InternalImages.Width, InternalImages.Height, False, AMask, AIsAlphaUsed), nil);
  end;

var
  AIndex: Integer;
  AItem: TdxCustomLayoutItem;
begin
  if IsDestroying then
    Exit;

  BeginUpdate;
  try
    InternalImages.Clear;
    InternalImages.SourceDPI := Group.ScaleFactor.Apply(dxDefaultDPI);
    InternalImages.SetSize(Group.GetMaxChildImageSize);

    for AIndex := 0 to Tabs.Count - 1 do
    begin
      AItem := GetItem(AIndex);
      if AItem.IsImageVisible and AItem.CaptionOptions.ImageOptions.IsImageAssigned then
        Tabs[AIndex].ImageIndex := AddImage(AItem, AIndex)
      else
        Tabs[AIndex].ImageIndex := -1;
    end;
    if InternalImages.Count = 0 then
      Images := nil
    else
      Images := InternalImages;
  finally
    CancelUpdate;
  end;
end;

procedure TdxLayoutTabbedOptions.RefreshTabsCaption;
var
  I: Integer;
begin
  BeginUpdate;
  try
    for I := 0 to Tabs.Count - 1 do
    begin
      Tabs[I].Caption := GetItemCaption(GetItem(I));
      TcxTabAccess(Tabs[I]).ShowAccelChar := GetItem(I).CaptionOptions.ShowAccelChar;
    end;
  finally
    CancelUpdate;
  end;
end;

procedure TdxLayoutTabbedOptions.RefreshTabsEnabled;
var
  I: Integer;
begin
  BeginUpdate;
  try
    for I := 0 to Tabs.Count - 1 do
      Tabs[I].Enabled := GetItem(I).GetEnabled;
  finally
    CancelUpdate;
  end;
end;

procedure TdxLayoutTabbedOptions.RefreshTabsVisible;
var
  I: Integer;
begin
  BeginUpdate;
  try
    for I := 0 to Tabs.Count - 1 do
      Tabs[I].Visible := GetItem(I).GetVisible;
  finally
    CancelUpdate;
  end;
end;

function TdxLayoutTabbedOptions.GetGroup: TdxCustomLayoutGroup;
begin
  Result := TdxCustomLayoutGroup(GetOwner);
end;

function TdxLayoutTabbedOptions.GetInternalImages: TcxImageList;
begin
  if FInternalImages = nil then
    FInternalImages := TcxImageList.Create(nil);
  Result := FInternalImages;
end;

function TdxLayoutTabbedOptions.GetItemCaption(AItem: TdxCustomLayoutItem): string;
begin
  if AItem.IsTextVisible then
  begin
    if AItem.CaptionOptions.FormattedText.HasFormatting then
    begin 
      if AItem.CaptionOptions.ShowAccelChar and TdxStringHelper.Contains(AItem.Caption, '&') then
      begin
        AItem.BeginUpdate;
        try 
          AItem.CaptionOptions.FormattedText.ShowAccelChar := False; 
          AItem.CaptionOptions.FormattedText.Import(AItem.CaptionOptions.FormattedText.Text); 
          Result := AItem.CaptionOptions.FormattedText.GetDisplayText; 
          AItem.CaptionOptions.FormattedText.ShowAccelChar := True; 
          AItem.CaptionOptions.FormattedText.Import(AItem.CaptionOptions.FormattedText.Text); 
        finally
          AItem.CancelUpdate;
        end;
      end
      else
        Result := AItem.CaptionOptions.FormattedText.GetDisplayText;
    end
    else
      Result := AItem.Caption;
  end
  else
    Result := '';
end;

{ TdxLayoutContainer }

constructor TdxLayoutContainer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Include(FComponentStyle, csSubComponent);
  FScaleFactor := TdxScaleFactor.Create;
  FCustomizationHelper := GetCustomizationHelperClass.Create(Self);
  FImageOptions := TdxLayoutImageOptions.Create(Self);
  FShowQuickCustomizationToolbar := True;
  AllowOptimizeWrappedItems := True;
  AllowRename := True;
end;

destructor TdxLayoutContainer.Destroy;
begin
  Customization := False;
  if MasterContainer = nil then
    BeginUpdate; 
  LayoutLookAndFeel := nil;
  GetLayoutLookAndFeel.RemoveUser(Self);
  UnregisterFonts;
  FreeAndNil(FFocusController);
  FreeAndNil(FUndoRedoManager);
  FSelectionHelper.RemoveSelectionChangedListener(Self);
  DestroyRootGroup;
  DestroyItems;
  FSelectionHelper := nil;
  FreeAndNil(FImageOptions);
  FreeAndNil(FCustomizationHelper);
  FreeAndNil(FScaleFactor);
  inherited Destroy;
end;

procedure TdxLayoutContainer.Assign(Source: TPersistent);
begin
  if Source is TdxLayoutContainer then
  begin
    BeginUpdate;
    try
      HighlightRoot := TdxLayoutContainer(Source).HighlightRoot;
      ShowDesignSelectors := TdxLayoutContainer(Source).ShowDesignSelectors;
      MenuItems := TdxLayoutContainer(Source).MenuItems;
      ImageOptions := TdxLayoutContainer(Source).ImageOptions;
    finally
      EndUpdate;
    end;
  end
  else
    inherited;
end;

function TdxLayoutContainer.CloneItem(AItem: TdxCustomLayoutItem; AParent: TdxCustomLayoutGroup = nil): TdxCustomLayoutItem;
begin
  if AItem = nil then
    Result := nil
  else
  begin
    Result := CreateItem(TdxCustomLayoutItemClass(AItem.ClassType), AParent);
    Result.Assign(AItem);
  end;
end;

function TdxLayoutContainer.CreateAlignmentConstraint: TdxLayoutAlignmentConstraint;
begin
  Result := GetAlignmentConstraintClass.Create(ItemsOwner);
  AddAlignmentConstraint(Result);
end;

procedure TdxLayoutContainer.BeginUpdate;
begin
  if MasterContainer <> nil then
    MasterContainer.BeginUpdate
  else
  begin
//    if (FUpdateLockCount = 0) and ItemsParent.HandleAllocated then
//      SendMessage(ItemsParent.Handle, WM_SETREDRAW, 0, 0);
    Inc(FUpdateLockCount);
  end;
end;

procedure TdxLayoutContainer.CancelUpdate;
begin
  if MasterContainer <> nil then
    MasterContainer.CancelUpdate
  else
  begin
    Dec(FUpdateLockCount);
//    if (FUpdateLockCount = 0) and ItemsParent.HandleAllocated then
//      SendMessage(ItemsParent.Handle, WM_SETREDRAW, 1, 0);
  end;
end;

procedure TdxLayoutContainer.EndUpdate(ANeedPack: Boolean = True);
var
  I: Integer;
begin
  if MasterContainer <> nil then
    MasterContainer.EndUpdate(ANeedPack)
  else
  begin
    Dec(FUpdateLockCount);
    for I := 0 to FFloatContainers.Count - 1 do
      TdxLayoutContainer(FFloatContainers[I]).LayoutChanged(ANeedPack);
    LayoutChanged(ANeedPack);

//    if (FUpdateLockCount = 0) and ItemsParent.HandleAllocated then
//    begin
//      SendMessage(ItemsParent.Handle, WM_SETREDRAW, 1, 0);
//      cxRedrawWindow(ItemsParent.Handle, RDW_INVALIDATE or RDW_ALLCHILDREN);
//    end;
  end;
end;

procedure TdxLayoutContainer.BeginTranslation;
begin
  BeginUpdate;
  Inc(FTranslationLockCount);
end;

procedure TdxLayoutContainer.EndTranslation;
begin
  Dec(FTranslationLockCount);
  EndUpdate;
end;

procedure TdxLayoutContainer.BeginDragAndDrop;
begin
// do nothing
end;

function TdxLayoutContainer.CanDragAndDrop: Boolean;
begin
  Result := False;
end;

procedure TdxLayoutContainer.FinishDragAndDrop(Accepted: Boolean);
begin
// do nothing
end;

function TdxLayoutContainer.CanGetHitTest(const P: TPoint): Boolean;
begin
  Result := IsContainerReady;
end;

function TdxLayoutContainer.GetStatusHint(const APoint: TPoint; const AOriginalHint: string): string;
var
  AHintInfo: THintInfo;
begin
  if ShowHint(AHintInfo, APoint.X, APoint.Y) then
    Result := AHintInfo.HintStr
  else
    Result := AOriginalHint;
end;

function TdxLayoutContainer.GetHitTest: TdxCustomLayoutHitTest;
begin
  if ItemsParentControl = nil then
    Result := TdxLayoutNoneHitTest.Instance
  else
    Result := GetHitTest(ScreenToClient(GetMouseCursorPos));
end;

function TdxLayoutContainer.GetHitTest(const P: TPoint): TdxCustomLayoutHitTest;

  function IsCustomizeFormHitTest(const AScreenPos: TPoint;
    var AHitCustomizeForm: TdxLayoutControlCustomCustomizeForm; out AClientPos: TPoint): Boolean;

    function Check(AControl: TWinControl): Boolean;
    begin
      Result := AControl is TdxLayoutControlCustomCustomizeForm;
      if Result then
      begin
        AHitCustomizeForm := TdxLayoutControlCustomCustomizeForm(AControl);
        if not IsDesigning then
          Result := (AHitCustomizeForm.Container = Self) or (AHitCustomizeForm.Container = MasterContainer);
      end;
      if Result then
        AClientPos := AControl.ScreenToClient(AScreenPos);
    end;

  var
    AWnd: HWND;
    AControl: TWinControl;
  begin
    AWnd := cxWindowFromPoint(AScreenPos);
    AControl := FindControl(AWnd);
    AClientPos := cxInvalidPoint;
    Result := Check(AControl) or ((AControl <> nil) and Check(GetParentForm(AControl)));
  end;

var
  ACustomizeForm: TdxLayoutControlCustomCustomizeForm;
  AClientPos: TPoint;
begin
  Result := nil;
  if IsCustomizeFormHitTest(ClientToScreen(P), ACustomizeForm, AClientPos) then
    Result := ACustomizeForm.GetHitTest(AClientPos);
  if Result = nil then
    Result := ViewInfo.GetHitTest(P);
end;

function TdxLayoutContainer.GetHitTest(X, Y: Integer): TdxCustomLayoutHitTest;
begin
  Result := GetHitTest(Point(X, Y));
end;

function TdxLayoutContainer.ClientToScreen(const Point: TPoint): TPoint;
begin
  if ItemsParentControl = nil then
    Result := Point
  else
    Result := ItemsParentControl.ClientToScreen(Point);
end;

function TdxLayoutContainer.ScreenToClient(const Point: TPoint): TPoint;
begin
  if ItemsParentControl = nil then
    Result := Point
  else
    Result := ItemsParentControl.ScreenToClient(Point);
end;

procedure TdxLayoutContainer.GetTabOrderList(List: TList);
var
  AList: TList;
  I: Integer;
begin
  if IsCustomization or IsDestroying then
    Exit;
  AList := TList.Create;
  try
    Root.GetTabOrderList(AList);
    for I := 0 to AList.Count - 1 do
      List.Add(AList[I]);
  finally
    AList.Free;
  end;
end;

procedure TdxLayoutContainer.CancelLastUndo;
begin
  if ([csLoading, csReading, csDestroying] * ComponentState = []) and not IsUpdateLocked then
  begin
    UndoRedoManager.RollBack;
    UndoRedoManager.DeleteRestorePoint;
    CustomizeFormPostUpdate([cfutView]);
  end;
end;

procedure TdxLayoutContainer.SaveToUndo;
begin
  if ([csLoading, csReading, csDestroying] * ComponentState = []) and not IsUpdateLocked then
  begin
    UndoRedoManager.AddRestorePoint;
    CustomizeFormPostUpdate([cfutView]);
  end;
end;

procedure TdxLayoutContainer.DoEnter;
begin
// do nothing
end;

procedure TdxLayoutContainer.DoExit;
begin
  RenamingItem := nil;
end;

procedure TdxLayoutContainer.CustomizeFormUpdate(AUpdateTypes: TdxLayoutCustomizeFormUpdateTypes);
begin
  if not Customization or (csDestroying in CustomizeForm.ComponentState) then
    Exit;

  FCustomizeFormUpdateTypes := FCustomizeFormUpdateTypes + AUpdateTypes;
  if IsUpdateLocked or not CustomizeForm.Visible then
    Exit;

 SendMessage(CustomizeForm.Handle, WM_SETREDRAW, 0, 0);
 try
    if cfutCaption in FCustomizeFormUpdateTypes then
      CustomizeForm.UpdateCaption;

    if [cfutAvailableItems, cfutVisibleItems] * FCustomizeFormUpdateTypes = [cfutAvailableItems, cfutVisibleItems] then
      CustomizeForm.UpdateContent
    else
    begin
      if cfutAvailableItems in FCustomizeFormUpdateTypes then
        CustomizeForm.UpdateAvailableItems;
      if cfutVisibleItems in FCustomizeFormUpdateTypes then
        CustomizeForm.UpdateVisibleItems;
    end;
    if FCustomizeFormUpdateTypes * [cfutSelection, cfutAvailableItems, cfutVisibleItems] <> [] then
      CustomizeForm.UpdateSelection;
    if cfutView in FCustomizeFormUpdateTypes then
      CustomizeForm.UpdateView;
    if cfutDragAndDropState in FCustomizeFormUpdateTypes then
      CustomizeForm.UpdateDragAndDropState;
  finally
    SendMessage(CustomizeForm.Handle, WM_SETREDRAW, 1, 0);
    cxRedrawWindow(CustomizeForm.Handle, RDW_INVALIDATE or RDW_UPDATENOW or RDW_ERASE or RDW_ALLCHILDREN);
  end;
  FCustomizeFormUpdateTypes := [];
end;

function GetItem(ACaller: TComponent; Index: Integer): TComponent;
begin
  if Index = 0 then
    Result := TdxLayoutContainer(ACaller).Root
  else
    Result := TdxLayoutContainer(ACaller).AbsoluteItems[Index - 1];
end;

function GetAlignmentConstraints(ACaller: TComponent; Index: Integer): TComponent;
begin
  Result := TdxLayoutContainer(ACaller).AlignmentConstraints[Index];
end;

procedure TdxLayoutContainer.CheckItemNames(const AOldName, ANewName: string);
begin
  if CanSetItemName(Root) then
  begin
    RenameComponents(Self, ItemsParentComponent.Owner, ANewName, AOldName, 1 + AbsoluteItemCount, @GetItem);
    RenameComponents(Self, ItemsParentComponent.Owner, ANewName, AOldName,  AlignmentConstraintCount, @GetAlignmentConstraints);
    CustomizeFormPostUpdate([cfutCaption]);
  end;
end;

procedure TdxLayoutContainer.RestoreFromIniFile(const AStorageName: string; const ARestoreName: string = '');
begin
  RestoreFrom(AStorageName, nil, TcxIniFileReader, ARestoreName);
end;

procedure TdxLayoutContainer.RestoreFromRegistry(const AStorageName: string; const ARestoreName: string = '');
begin
  RestoreFrom(AStorageName, nil, TcxRegistryReader, ARestoreName);
end;

procedure TdxLayoutContainer.RestoreFromStream(AStream: TStream; const ARestoreName: string = '');
begin
  RestoreFrom('', AStream, TcxStreamReader, ARestoreName);
end;

procedure TdxLayoutContainer.RestoreFromStorage(const AStorageName: string;
  AReaderClass: TcxCustomReaderClass; const ARestoreName: string = '');
begin
  RestoreFrom(AStorageName, nil, AReaderClass, ARestoreName);
end;

procedure TdxLayoutContainer.StoreToIniFile(const AStorageName: string;
  AReCreate: Boolean = True; const ASaveName: string = '');
begin
  StoreTo(AStorageName, nil, TcxIniFileWriter, AReCreate, ASaveName);
end;

procedure TdxLayoutContainer.StoreToRegistry(const AStorageName: string;
  AReCreate: Boolean = True; const ASaveName: string = '');
begin
  StoreTo(AStorageName, nil, TcxRegistryWriter, AReCreate, ASaveName);
end;

procedure TdxLayoutContainer.StoreToStream(AStream: TStream; const ASaveName: string = '');
begin
  StoreTo('', AStream, TcxStreamWriter, True, ASaveName);
end;

function TdxLayoutContainer.GetBoldFont: TFont;
begin
  Result := GetDefaultFont;
end;

procedure TdxLayoutContainer.UnregisterFonts;
begin
  dxLayoutTextMetrics.Unregister(GetBoldFont);
  dxLayoutTextMetrics.Unregister(GetDefaultFont);
end;

procedure TdxLayoutContainer.StoreToStorage(const AStorageName: string; AWriterClass: TcxCustomWriterClass;
  AReCreate: Boolean = True; const ASaveName: string = '');
begin
  StoreTo(AStorageName, nil, AWriterClass, AReCreate, ASaveName);
end;

procedure TdxLayoutContainer.InvalidateRect(const R: TRect; EraseBackground: Boolean);
begin
  if ItemsParentControl <> nil then
    ItemsParentControl.InvalidateRect(R, EraseBackground);
end;

procedure TdxLayoutContainer.Redraw(const R: TRect; AFlags: Integer = 0);
begin
  if ItemsParentControl <> nil then
    cxRedrawWindow(ItemsParentControl.Handle, R, AFlags);
end;

procedure TdxLayoutContainer.Loaded;
begin
  inherited;
  CheckIndexes;
  LayoutLookAndFeelUserChanged;
end;

procedure TdxLayoutContainer.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (ImageOptions <> nil) then
    ImageOptions.FreeNotification(AComponent);
  if (Operation = opRemove) and (AComponent = Root) then
  begin
    DestroyHandlers;
    FRoot := nil;
    if not IsDestroying then
    begin
      CreateRootGroup;
      CustomizeFormPostUpdate([cfutVisibleItems]);
    end;
  end;
end;

procedure TdxLayoutContainer.ToggleHotTrackState(AItem: TdxCustomLayoutItem);
begin
  if CustomizeForm <> nil then
    CustomizeForm.ToggleHotTrackState(AItem);
end;

function TdxLayoutContainer.ShowHint(var AHintInfo: THintInfo; X, Y: Integer): Boolean;
begin
  Result := ViewInfo.ShowHint(AHintInfo, X, Y);
end;

procedure TdxLayoutContainer.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ViewInfo.MouseDown(Button, Shift, X, Y);
end;

procedure TdxLayoutContainer.MouseLeave(AControl: TControl);
begin
  ViewInfo.MouseLeave(AControl);
end;

procedure TdxLayoutContainer.MouseMove(Shift: TShiftState; X, Y: Integer);

  procedure InternalMouseMove(AContainer: TdxLayoutContainer; AScreenPoint: TPoint);
  var
    AClientPoint: TPoint;
  begin
    AClientPoint := AContainer.ScreenToClient(AScreenPoint);
    if PtInRect(AContainer.ClientBounds, AClientPoint) then
      AContainer.ViewInfo.MouseMove(Shift, AClientPoint.X, AClientPoint.Y);
  end;

var
  I: Integer;
  AScreenPoint, AClientPoint: TPoint;
begin
  if GetCaptureControl = nil then
    ViewInfo.MouseMove(Shift, X, Y)
  else
  begin
    AScreenPoint := ClientToScreen(Point(X, Y));
    if MasterContainer <> nil then
    begin
      AClientPoint := MasterContainer.ScreenToClient(AScreenPoint);
      MasterContainer.MouseMove(Shift, AClientPoint.X, AClientPoint.Y);
    end
    else
    begin
      InternalMouseMove(Self, AScreenPoint);
      for I := 0 to FFloatContainers.Count - 1 do
        InternalMouseMove(TdxLayoutContainer(FFloatContainers[I]), AScreenPoint);
    end;
  end;
end;

procedure TdxLayoutContainer.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ViewInfo.MouseUp(Button, Shift, X, Y);
end;

function TdxLayoutContainer.GetViewInfoClass: TdxLayoutContainerViewInfoClass;
begin
  Result := TdxLayoutContainerViewInfo;
end;

function TdxLayoutContainer.CalculateCustomizeFormBounds(const AFormBounds: TRect): TRect;
var
  AControlBounds, ADesktopBounds: TRect;
begin
  AControlBounds := dxMapWindowRect(ItemsParentControl.Parent.Handle, 0, ItemsParentControl.BoundsRect);
  ADesktopBounds := GetDesktopWorkArea(AControlBounds);
  Result := AFormBounds;
  with AControlBounds do
  begin
    if (ADesktopBounds.Right - Right >= Result.Right - Result.Left) or
      (ADesktopBounds.Right - Right >= Left - ADesktopBounds.Left)
    then
      OffsetRect(Result, Right - Result.Left, 0)
    else
      OffsetRect(Result, Left - Result.Right, 0);
    OffsetRect(Result, 0, (Top + Bottom - (Result.Bottom - Result.Top)) div 2 - Result.Top);
  end;
  with ADesktopBounds do
  begin
    if Result.Left < Left then
      OffsetRect(Result, Left - Result.Left, 0);
    if Result.Right > Right then
      OffsetRect(Result, Right - Result.Right, 0);
    if Result.Top < Top then
      OffsetRect(Result, 0, Top - Result.Top);
  end;
end;

procedure TdxLayoutContainer.CreateCustomizeForm;
begin
  if IsQuickCustomization then
    FCustomizeForm := TdxLayoutControlCustomCustomizeForm.CreateNew(nil)
  else
    FCustomizeForm := CustomizeFormClass.Create(nil);

  FCustomizeForm.AssignFont(TcxControlAccess(ItemsParentControl).Font, TcxControlAccess(ItemsParentControl).ScaleFactor);
  FCustomizeForm.Container := RealContainer;
end;

function TdxLayoutContainer.GetCustomizeForm: TdxLayoutControlCustomCustomizeForm;
begin
  Result := RealContainer.FCustomizeForm;
end;

procedure TdxLayoutContainer.DestroyCustomizeForm;
begin
  if not (csDestroying in FCustomizeForm.ComponentState) then
    FCustomizeForm.Free;
  FCustomizeForm := nil;
end;

procedure TdxLayoutContainer.ShowCustomizeForm;
begin
  CustomizeForm.Initialize;
  CustomizeForm.Show;
end;

function TdxLayoutContainer.CanFocusOnClick(X, Y: Integer): Boolean;
begin
  Result := ViewInfo.CanFocusOnClick(X, Y);
end;

function TdxLayoutContainer.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean;
begin
  Result := ViewInfo.DoMouseWheel(Shift, WheelDelta, MousePos);
end;

function TdxLayoutContainer.IsChildKey(Message: TCMChildKey): Boolean;
begin
  Result := (Message.CharCode = VK_TAB) and (GetKeyState(VK_CONTROL) >= 0);
  Result := Result or ((Message.CharCode in [VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT]) and
    ((FocusController.FocusedItem is TdxCustomLayoutCheckableItem) or ((FocusController.FocusedItem = nil) and
    ((Message.Sender is TCustomCheckBox) or (Message.Sender is TcxCustomCheckBox) or (Message.Sender is TRadioButton)))));
end;

function TdxLayoutContainer.IsMouseWheelHandleNeeded(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean;
begin
  Result := not IsUpdateLocked and ViewInfo.IsMouseWheelHandleNeeded(Shift, WheelDelta, MousePos);
end;

procedure TdxLayoutContainer.KeyDown(var Key: Word; Shift: TShiftState);
var
  AItem: TdxCustomLayoutItem;
begin
  if not IsCustomization and (FocusController.CurrentTabOrder <> - 1) then
  begin
    AItem := FocusController.FocusedItem;
    if AItem <> nil then
      AItem.KeyDown(Key, Shift);
  end;
  if (Key = VK_ESCAPE) and (Shift * [ssCtrl, ssAlt, ssShift] = []) then
    SelectItemParent;
end;

function TdxLayoutContainer.GetAlignmentConstraintClass: TdxLayoutAlignmentConstraintClass;
begin
  Result := TdxLayoutAlignmentConstraint;
end;

function TdxLayoutContainer.GetCustomizationHelperClass: TdxLayoutContainerCustomizationHelperClass;
begin
  Result := TdxLayoutContainerCustomizationHelper;
end;

function TdxLayoutContainer.GetDefaultGroupClass: TdxLayoutGroupClass;
begin
  Result := TdxLayoutGroup;
end;

function TdxLayoutContainer.GetDefaultItemClass: TdxLayoutItemClass;
begin
  Result := TdxLayoutItem;
end;

function TdxLayoutContainer.GetDefaultLabelClass: TdxLayoutLabeledItemClass;
begin
  Result := TdxLayoutLabeledItem;
end;

function TdxLayoutContainer.GetDefaultRootGroupClass: TdxLayoutGroupClass;
begin
  Result := GetDefaultGroupClass;
end;

function TdxLayoutContainer.GetFocusControllerClass: TdxLayoutContainerFocusControllerClass;
begin
  Result := TdxLayoutContainerFocusController;
end;

function TdxLayoutContainer.GetPainterClass: TdxLayoutContainerPainterClass;
begin
  Result := TdxLayoutContainerPainter;
end;

function TdxLayoutContainer.GetSelectionHelperClass: TdxLayoutRunTimeSelectionHelperClass;
begin
  Result := TdxLayoutRunTimeSelectionHelper;
end;

procedure TdxLayoutContainer.CreateHandlers;
begin
  FViewInfo := GetViewInfoClass.Create(Self);
  FPainter := GetPainterClass.Create(FViewInfo);
end;

procedure TdxLayoutContainer.DestroyHandlers;
begin
  FreeAndNil(FPainter);
  FreeAndNil(FViewInfo);
end;

procedure TdxLayoutContainer.CreateItems;
begin
  FFloatContainers := TcxComponentList.Create;

  FAbsoluteItems := TcxComponentList.Create;
  FAbsoluteItems.OwnsObjects := True;
  FAvailableItems := TcxComponentList.Create;
  FManagedItems := TcxComponentList.Create;

  FGarbageCollector := TcxComponentList.Create;
  FGarbageCollector.OwnsObjects := True;

  CreateConstraints;

  FFloatContainers.OnComponentListChanged := FloatContainersListChanged;
  FAbsoluteItems.OnComponentListChanged := AbsoluteItemListChanged;
  FAvailableItems.OnComponentListChanged := AvailableItemListChanged;
end;

procedure TdxLayoutContainer.DestroyItems;

  procedure DestroyFloatItems;
  var
    I: Integer;
  begin
    for I := FFloatContainers.Count - 1 downto 0 do
      TdxLayoutContainer(FFloatContainers[I]).Root.Items[0].Free;
  end;

begin
  FFloatContainers.OnComponentListChanged := nil;
  FAbsoluteItems.OnComponentListChanged := nil;
  FAvailableItems.OnComponentListChanged := nil;

  DestroyConstraints;
  DestroyFloatItems;
  FreeAndNil(FGarbageCollector);
  FreeAndNil(FAbsoluteItems);
  FreeAndNil(FManagedItems);
  FreeAndNil(FAvailableItems);
  FreeAndNil(FFloatContainers);
end;

procedure TdxLayoutContainer.ApplyCalculatedChanges;
var
  I: Integer;
begin
  Root.ApplyCalculatedChanges;
  for I := 0 to AvailableItemCount - 1 do
    AvailableItems[I].ApplyCalculatedChanges;
//    if ItemsParent.HandleAllocated then
//      cxRedrawWindow(ItemsParent.Handle, RDW_INVALIDATE or RDW_ALLCHILDREN);
end;

function TdxLayoutContainer.IsContainerReady: Boolean;
begin
  Result := not IsGlobalDestroying and not IsLoading and not IsUpdateLocked and CanUpdate and (GetLayoutLookAndFeel <> nil) and (ItemsParentControl <> nil);
end;

function TdxLayoutContainer.CanUpdate: Boolean;
begin
  Result := True;
end;

procedure TdxLayoutContainer.DoCalculateRoot(ARecreateViewData: Boolean);

  procedure BeforeCalculateViewInfo;
  var
    I: Integer;
  begin
    if not IsCustomization then
    begin
      UnclenchWrappingGroup(Root);
      if AllowWrapItems then
        SqueezeWrappingGroup(Root); 
    end;

    Root.BeforeCalculateViewInfo;
    for I := 0 to AvailableItemCount - 1 do
      AvailableItems[I].BeforeCalculateViewInfo;
  end;

  procedure AfterCalculateViewInfo;
  var
    I: Integer;
  begin
    Root.AfterCalculateViewInfo;
    for I := 0 to AvailableItemCount - 1 do
      AvailableItems[I].AfterCalculateViewInfo;
  end;

begin
  BeginUpdate;
  try
    ViewInfo.IsOnGlass := IsOnGlass;
    BeforeCalculateViewInfo;
    ViewInfo.Calculate(ARecreateViewData);
    AfterCalculateViewInfo;
    ViewInfo.FIsValid := True;
  finally
    CancelUpdate;
  end;
end;

procedure TdxLayoutContainer.DoChanged;
begin
  CallNotify(FOnChanged, Self);
end;

procedure TdxLayoutContainer.DoSelectionChanged;
begin
  CallNotify(FOnSelectionChanged, Self);
end;

procedure TdxLayoutContainer.InitializeSubControlsCxLookAndFeel;
begin
// do nothing
end;

procedure TdxLayoutContainer.InvalidateWithChildren;
begin
  if ItemsParentControl <> nil then
    ItemsParentControl.InvalidateWithChildren;
end;

procedure TdxLayoutContainer.LayoutChanged(ANeedPack: Boolean = True);

  procedure PackAvailableItems;
  var
    I: Integer;
  begin
    for I := AvailableItemCount - 1 downto 0 do
      AvailableItems[I].DoPack;
  end;

begin
  if (IsContainerReady or FCalculationDireNeeded) and not IsProcessingControls then
  begin
    FCalculationDireNeeded := False;
    BeginPlaceControls;
    try
      BeginUpdate;
      try
        if ANeedPack then
        begin
          Root.DoPack;
          PackAvailableItems;
        end;
        DoCalculateRoot(ANeedPack);
      finally
        CancelUpdate;
      end;
      FocusController.CheckFocus;
      ApplyCalculatedChanges; 
      SizeAdjustment;
    finally
      EndPlaceControls;
    end;
    DoChanged;
  end;
end;

procedure TdxLayoutContainer.PostLayoutChanged(AType: TdxChangeType = ctHard);
begin
// do nothing
end;

function ItemHeightCompare(AItem1, AItem2: Pointer): Integer;
begin
  Result := GetHeight(TdxCustomLayoutItem(AItem1)) - GetHeight(TdxCustomLayoutItem(AItem2));
end;

function GetLevelAlign(ALevel: TdxCustomLayoutGroup): TdxLayoutAlignHorz;
var
  I: Integer;
begin
  Result := ahLeft;
  for I := 0 to ALevel.Count - 1 do
  begin
    if ALevel.Items[I].AlignHorz in [ahClient, ahRight] then
    begin
      Result := ahClient;
      Break;
    end;
    if (Result = ahLeft) and (ALevel.Items[I].AlignHorz = ahParentManaged) then
      Result := ahParentManaged;
  end;
end;

function IsItemHighest(AItem: TdxCustomLayoutItem): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := 0 to AItem.Parent.Count - 1 do
    if (AItem <> AItem.Parent[I]) and (GetHeight(AItem) < GetHeight(AItem.Parent[I])) then
    begin
      Result := False;
      Break;
    end;
end;

function TdxLayoutContainer.AddWrapLevel(AGroup: TdxCustomLayoutGroup; ALayoutDirection: TdxLayoutDirection): TdxLayoutAutoCreatedWrappingGroup;
begin
  Result := TdxLayoutAutoCreatedWrappingGroup(CreateGroup(TdxLayoutAutoCreatedWrappingGroup, AGroup));
  Result.LayoutDirection := ALayoutDirection;
end;

function TdxLayoutContainer.SimpleWrap(AGroup: TdxCustomLayoutGroup; AMaxWidth: Integer): Boolean;

  function GetWidthForItem(AGroup: TdxCustomLayoutGroup; AItem: TdxCustomLayoutItem): Integer;
  begin
    Result := GetWidth(AItem);
    if (AItem.Index > 0) and (Result > 0) then
      Result := Result + GetItemOffset(AGroup);
  end;

  function GetItemsWidth(AGroup: TdxCustomLayoutGroup; AItemCount: Integer): Integer;
  var
    I: Integer;
  begin
    Result := 0;
    for I := 0 to AItemCount - 1 do
      Result := Result + GetWidthForItem(AGroup, AGroup[I]);
  end;

  function IsItemMostHighest(AItem: TdxCustomLayoutItem): Boolean;
  var
    I: Integer;
  begin
    Result := True;
    for I := 0 to AItem.Parent.Count - 1 do
      if (AItem <> AItem.Parent[I]) and (GetHeight(AItem) <= GetHeight(AItem.Parent[I])) then
      begin
        Result := False;
        Break;
      end;
  end;

  function SimpleOptimize(AGroup: TdxCustomLayoutGroup; AMaxWidth: Integer; AHeightInc: Integer): Boolean;
  var
    I: Integer;
    AGroupHeight: Integer;
    ANewWidth: Integer;
    ALevel: TdxCustomLayoutGroup;
  begin
    Result := False;
    if AGroup.Count < 3 then
      Exit;
    AGroupHeight := GetHeight(AGroup) + AHeightInc;
    I := 1;
    while I < AGroup.Count do
    begin
      ANewWidth := GetItemsWidth(AGroup, I - 1) + Max(GetWidth(AGroup[I - 1]), GetWidth(AGroup[I]));
      if I > 1 then
        Inc(ANewWidth, GetItemOffset(AGroup));
      if ANewWidth > AMaxWidth then
        Break;
      if not IsItemHighest(AGroup[I - 1]) and (GetHeight(AGroup[I - 1]) + GetHeight(AGroup[I]) < AGroupHeight) then
      begin
        ALevel := AddWrapLevel(AGroup, ldVertical);
        ALevel.FWrappingState := wsPopulated; 
        ALevel.Index := I + 1;
        AGroup[I-1].Move(ALevel, ALevel.Count);
        AGroup[I-1].Move(ALevel, ALevel.Count);
        Result := True;
        Break;
      end
      else
        Inc(I);
    end;
  end;

  procedure OptimizeWrapY(AGroup: TdxCustomLayoutGroup; AMaxWidth: Integer; AHeightInc: Integer);
  begin
    while (GetWidth(AGroup) > AMaxWidth) and SimpleOptimize(AGroup, AMaxWidth, AHeightInc) do
      {loop};
  end;

  procedure OptimizeWrap(AGroup1, AGroup2: TdxCustomLayoutGroup; AMaxWidth: Integer);
  var
    AHeight1, AHeight2: Integer;
    AWidth: Integer;
    I, AIndex: Integer;
    AList1, AList2: TList;
  begin
    if AGroup1.Count + AGroup2.Count < 3 then
      Exit;
    AHeight1 := GetHeight(AGroup1) + GetHeight(AGroup2);
    AList1 := TList.Create;
    AList2 := TList.Create;
    try
      for I := 0 to AGroup1.Count - 1 do
        AList1.Add(AGroup1[I]);
      for I := 0 to AGroup2.Count - 1 do
        AList2.Add(AGroup2[I]);
      for I := AGroup2.Count - 1 downto 0 do
        AGroup2[0].Parent := AGroup1;
      OptimizeWrapY(AGroup1, AMaxWidth, 0);
      AWidth := 0;
      AIndex := -1;
      for I := 0 to AGroup1.Count - 1 do
      begin
        AWidth := AWidth + GetWidthForItem(AGroup1, AGroup1[I]);
        if AWidth > AMaxWidth then
        begin
          AIndex := Max(1, I);
          Break;
        end;
      end;
      if AIndex > -1 then
        for I := AGroup1.Count - 1 downto AIndex do
          AGroup1[AIndex].Parent := AGroup2;
      AHeight2 := GetHeight(AGroup1) + GetHeight(AGroup2);
      if AHeight2 > AHeight1 then // rollback
      begin
        for I := 0 to AList1.Count - 1 do
          TdxCustomLayoutItem(AList1[I]).Parent := nil;
        for I := 0 to AList2.Count - 1 do
          TdxCustomLayoutItem(AList2[I]).Parent := nil;
        for I := AGroup1.Count - 1 downto 0 do
          AGroup1[I].Free;
        for I := AGroup2.Count - 1 downto 0 do
          AGroup2[I].Free;
        for I := 0 to AList1.Count - 1 do
          TdxCustomLayoutItem(AList1[I]).Parent := AGroup1;
        for I := 0 to AList2.Count - 1 do
          TdxCustomLayoutItem(AList2[I]).Parent := AGroup2;
      end;
    finally
      AList1.Free;
      AList2.Free;
    end;
  end;

var
  ACurrentLevel, ANewLevel: TdxCustomLayoutGroup;
  ACurrentItem: TdxCustomLayoutItem;
  I: Integer;
begin
  Result := False;

  if AGroup.Count > 1 then
  begin
    if AGroup.LayoutDirection = ldVertical then
    begin
      Result := True;
      ACurrentLevel := AddWrapLevel(AGroup, ldHorizontal);
      ACurrentLevel.Index := 0;

      while ACurrentLevel.Index < AGroup.Count - 1 do
      begin
        ACurrentItem := AGroup[ACurrentLevel.Index + 1];
        ACurrentItem.Move(ACurrentLevel, ACurrentLevel.Count);
        if AllowOptimizeWrappedItems and IsItemMostHighest(ACurrentItem) and (ACurrentLevel.Index > 0) and (GetHeight(AGroup[ACurrentLevel.Index-1]) * 1.5 < GetHeight(ACurrentItem)) then
        begin
          OptimizeWrap(AGroup[ACurrentLevel.Index-1] as TdxCustomLayoutGroup, ACurrentLevel, AMaxWidth);
          if ACurrentLevel.Count = 0 then
          begin
            ANewLevel := AGroup[ACurrentLevel.Index-1] as TdxCustomLayoutGroup;
            ACurrentLevel.Free;
            ACurrentLevel := ANewLevel;
          end;
        end;

        if GetWidth(ACurrentLevel) > AMaxWidth then
        begin
          if AllowOptimizeWrappedItems then
          begin
            if ACurrentLevel.Index = AGroup.Count - 1 then
              OptimizeWrapY(ACurrentLevel, AMaxWidth, GetHeight(ACurrentItem) div 2)
            else
              OptimizeWrapY(ACurrentLevel, AMaxWidth, 0);

            if (GetWidth(ACurrentLevel) > AMaxWidth) and (IsItemHighest(ACurrentLevel[ACurrentLevel.Count - 1])) then  // rollback
            begin
              I := 0;
              while I < ACurrentLevel.Count do
              begin
                if ACurrentLevel.Items[0].IsGroup and ACurrentLevel.Items[0].AsGroup.AutoCreatedForWrap and (ACurrentLevel.Items[0].AsGroup.FWrappingState = wsPopulated) then
                  ACurrentLevel.Items[0].AsGroup.Dismiss;
                Inc(I);
              end;
            end;
          end;

          if (GetWidth(ACurrentLevel) > AMaxWidth) and (ACurrentLevel.Count > 1) then
          begin
            ANewLevel := AddWrapLevel(AGroup, ldHorizontal);
            ANewLevel.Index := ACurrentLevel.Index + 1;
            ACurrentLevel[ACurrentLevel.Count - 1].Move(ANewLevel, 0);
            ACurrentLevel := ANewLevel;
          end;
        end;
      end;
    end;
  end;
end;

procedure TdxLayoutContainer.SqueezeWrappingGroup(AGroup: TdxCustomLayoutGroup);
var
  I: Integer;
  ALevel: TdxLayoutAutoCreatedWrappingGroup;
  ACurrentItem: TdxCustomLayoutItem;
begin
  if AGroup.IsWrapItemsAllowed then
  begin
    for I := 0 to AGroup.Count - 1 do
      if AGroup[I].IsGroup then
        SqueezeWrappingGroup(AGroup[I].AsGroup);

    if AGroup.CanWrapItems then
    begin
      AGroup.FWrappingState := wsSqueezed;
      ALevel := AddWrapLevel(AGroup, ldVertical);
      ALevel.FWrappingState := wsSqueezed;
      ALevel.Index := 0;

      while ALevel.Index < AGroup.Count - 1 do
      begin
        ACurrentItem := AGroup[ALevel.Index + 1];
        if ACurrentItem.IsGroup and ACurrentItem.AsGroup.IsWrapItemsAllowed then
        begin
          if ALevel.Count <> 0 then
          begin
            ALevel := AddWrapLevel(AGroup, ldVertical);
            ALevel.FWrappingState := wsSqueezed;
          end;
          if ACurrentItem.Index < AGroup.Count - 1 then
            ALevel.Index := ACurrentItem.Index + 1
          else
            Break;
        end
        else
          ACurrentItem.Move(ALevel, ALevel.Count);
      end;
      if ALevel.Count = 0 then
        ALevel.Free;
      if (AGroup.LayoutDirection = ldHorizontal) and (AGroup.Count > 1) then
      begin
        ALevel := AddWrapLevel(AGroup, ldVertical);
        ALevel.FWrappingState := wsSqueezed;
        AGroup.MoveChildrenIntoHiddenGroup(ALevel);
      end;
    end
    else
      AGroup.FWrappingState := wsNone;
  end;
end;


procedure TdxLayoutContainer.PopulateWrappingGroups;

  procedure MediumChanged(AItem: TdxCustomLayoutItem);
  var
    AViewInfo: TdxCustomLayoutItemViewInfo;
  begin
    AViewInfo := AItem.ViewInfo;
    if (AViewInfo <> nil) and AViewInfo.IsValid then
    begin
      AItem.BeginUpdate;
      try
        AItem.BeforeCalculateViewInfo;

      // recreate ViewInfos
        AViewInfo.DestroyViewInfos;
        AViewInfo.CreateViewInfos;

        AViewInfo.Recalculate;
        AItem.AfterCalculateViewInfo;
      finally
        AItem.CancelUpdate;
      end;
      AItem.ApplyCalculatedChanges;
    end;
  end;

  function GetCorrectedMaxWidth(AGroup: TdxCustomLayoutGroup; AMaxWidth: Integer): Integer;
  var
    I, AVisibleIndex: Integer;
    AItemMaxWidth, AGroupCurrentWidth, AGroupMaxWidth, AGroupSpace: Integer;
    AUsedWidth, ARequiredMaxWidth, ARequiredSpace, AFreeSpace, ARequiredMinWidth: Integer;
    AItem: TdxCustomLayoutItem;
  begin
    Result := AMaxWidth;
    if (AGroup.Parent <> nil) and (AGroup.Parent.LayoutDirection = ldHorizontal) and (AGroup.Parent.VisibleCount > 1) then
    begin
      AGroupCurrentWidth := GetWidth(AGroup);
      AGroupMaxWidth := GetMaxWidth(AGroup);
      AGroupSpace := AGroupMaxWidth * GetMinHeight(AGroup);
      AVisibleIndex := AGroup.Parent.VisibleIndexOf(AGroup);
      AUsedWidth := 0;

      for I := 0 to AVisibleIndex - 1 do
        Inc(AUsedWidth, GetWidth(AGroup.Parent.VisibleItems[I]));

      AFreeSpace := AMaxWidth - AUsedWidth - GetItemOffset(AGroup.Parent) * (AGroup.Parent.VisibleCount - 1);

      ARequiredMinWidth := AGroupCurrentWidth;
      for I := AVisibleIndex + 1 to AGroup.Parent.VisibleCount - 1 do
        Inc(ARequiredMinWidth, GetWidth(AGroup.Parent.VisibleItems[I]));

      ARequiredMaxWidth := AGroupMaxWidth;
      ARequiredSpace := AGroupSpace;
      for I := AVisibleIndex + 1 to AGroup.Parent.VisibleCount - 1 do
      begin
        AItem := AGroup.Parent.VisibleItems[I];
        if AItem.IsGroup and AItem.AsGroup.IsWrapItemsAllowed then
        begin
          AItemMaxWidth := GetMaxWidth(AItem);
          Inc(ARequiredMaxWidth, AItemMaxWidth);
          Inc(ARequiredSpace, AItemMaxWidth * GetMinHeight(AItem));
        end
        else
        begin
          AItemMaxWidth := GetWidth(AItem);
          Dec(ARequiredMinWidth, AItemMaxWidth);
          Dec(AFreeSpace, GetWidth(AItem));
        end;
      end;

      if ARequiredMaxWidth > AFreeSpace then
      begin
        Result := Trunc(AFreeSpace / ARequiredSpace * AGroupSpace);
        if AFreeSpace - Result < ARequiredMinWidth - AGroupCurrentWidth then
          Result := AGroupCurrentWidth + AFreeSpace - ARequiredMinWidth;
      end
      else
        Result := AMaxWidth;
    end;
    if not AGroup.Hidden then
      Result := Result - (AGroup.ViewInfo.Bounds.Width - AGroup.ViewInfo.ItemsAreaBounds.Width);
  end;

  function FindChangedGroup(AGroup: TdxCustomLayoutGroup): TdxCustomLayoutGroup;
  begin
    if Root.GetRealAlignHorz = ahClient then
      repeat
        Result := AGroup;
        AGroup := AGroup.Parent;
      until (AGroup = nil) or (Result.GetRealAlignHorz = ahClient)
    else
      Result := Root;
  end;

  procedure MarkPopulated(AGroup: TdxCustomLayoutGroup);
  var
    I: Integer;
    AItem: TdxCustomLayoutItem;
  begin
    AGroup.FWrappingState := wsPopulated;
    for I := 0 to AGroup.VisibleCount - 1 do
    begin
      AItem := AGroup.VisibleItems[I];
      if AItem.IsGroup then
        MarkPopulated(AItem.AsGroup);
    end;
  end;

  procedure PopulateWrappingGroup(AGroup: TdxCustomLayoutGroup; AMaxWidth: Integer);
  var
    I: Integer;
    AItem: TdxCustomLayoutItem;
  begin

    if AGroup.FWrappingState <> wsPopulated then
    begin
      if AGroup.Width > 0 then     
        AMaxWidth := AGroup.Width; 

      if AGroup.FWrappingState = wsSqueezed then
        if SimpleWrap(AGroup, AMaxWidth) then
          MediumChanged(FindChangedGroup(AGroup));

      for I := 0 to AGroup.VisibleCount - 1 do
      begin
        AItem := AGroup.VisibleItems[I];
        if AItem.IsGroup then
          PopulateWrappingGroup(AItem.AsGroup, GetCorrectedMaxWidth(AItem.AsGroup, AMaxWidth));
      end;
      if (AGroup.FWrappingState = wsSqueezed) or AGroup.AutoCreatedForWrap then
        AGroup.FWrappingState := wsPopulated;
    end
    else
      MarkPopulated(AGroup);
  end;

  procedure CheckLevelsAlign(AGroup: TdxCustomLayoutGroup);
  var
    I: Integer;
  begin
    for I := 0 to AGroup.Count - 1 do
      if AGroup[I].IsGroup then
      begin
        CheckLevelsAlign(AGroup[I].AsGroup);
        if AGroup[I].AsGroup.AutoCreatedForWrap then
          AGroup[I].AsGroup.AlignHorz := GetLevelAlign(AGroup[I].AsGroup);
      end;
  end;

begin
  PopulateWrappingGroup(Root, ClientBounds.Width - (Root.ViewInfo.Bounds.Width - Root.ViewInfo.ItemsAreaBounds.Width));
  Root.DoChildPack;
  CheckLevelsAlign(Root);
  Root.BuildVisibleItemsList(True);

end;

procedure TdxLayoutContainer.UnclenchWrappingGroup(AGroup: TdxCustomLayoutGroup);
var
  I: Integer;
  AItem: TdxCustomLayoutItem;
begin
  I := 0;
  while I < AGroup.Count do
  begin
    AItem := AGroup[I];
    if AItem.IsGroup then
      UnclenchWrappingGroup(AItem.AsGroup);
    if AItem.IsGroup and AItem.AsGroup.AutoCreatedForWrap {and not AGroup[I].IsDragged} then
      AItem.AsGroup.Dismiss
    else
      Inc(I);
  end;
end;

function TdxLayoutContainer.GetDisabledImages: TCustomImageList;
begin
  Result := ImageOptions.DisabledImages;
end;

function TdxLayoutContainer.GetImages: TCustomImageList;
begin
  Result := ImageOptions.Images;
end;

procedure TdxLayoutContainer.Modified;
begin
// do nothing
end;

function TdxLayoutContainer.AllowFloatingGroups: Boolean;
begin
  Result := False;
end;

function TdxLayoutContainer.IsFloatingSupported: Boolean;
begin
  Result := False;
end;

function TdxLayoutContainer.AllowFloatingDragImage: Boolean;
begin
  Result := IsFloatingSupported;
end;

function TdxLayoutContainer.CreateFloatForm: TdxLayoutCustomFloatForm;
begin
  Result := nil;
end;

procedure TdxLayoutContainer.InitializeFloatForm(AItem: TdxCustomLayoutItem);
begin
// do nothing
end;

function TdxLayoutContainer.GetFloatDock(AItem: TdxCustomLayoutItem): TdxLayoutGroup;
begin
  Result := nil;
end;

procedure TdxLayoutContainer.BuildSelectionLayer;
var
  I: Integer;
begin
  if not IsUpdateLocked and IsViewInfoValid then
  begin
    ViewInfo.BuildSelectionLayer;
    for I := 0 to FFloatContainers.Count - 1 do
      TdxLayoutContainer(FFloatContainers[I]).BuildSelectionLayer;
  end;
end;

procedure TdxLayoutContainer.CustomizationChanged;
begin
// do nothing
end;

procedure TdxLayoutContainer.CustomizeFormPostUpdate(AUpdateTypes: TdxLayoutCustomizeFormUpdateTypes);
begin
// do nothing
end;

procedure TdxLayoutContainer.CustomizeFormUpdateList(AItem: TdxCustomLayoutItem);
const
  UpdateTypeMap: array[Boolean] of TdxLayoutCustomizeFormUpdateType = (cfutVisibleItems, cfutAvailableItems);
begin
  RealContainer.CustomizeFormPostUpdate([UpdateTypeMap[AItem.IsAvailable]]);
end;

function TdxLayoutContainer.DoGetCustomizationMenuItems(const ASelectedItems: TList): TdxLayoutCustomizeFormMenuItems;
begin
  if IsDesigning then
    Result := dxDefaultLayoutCustomizeFormMenuItems
  else
    Result := MenuItems;
end;

procedure TdxLayoutContainer.InvalidateSelectionLayer(const R: TRect);
begin
  if IsViewInfoValid then
    ViewInfo.InvalidateSelectionLayer(R);
end;

function TdxLayoutContainer.IsCustomization: Boolean;
begin
  Result := Customization or IsDesigning;
end;

function TdxLayoutContainer.IsQuickCustomization: Boolean;
begin
  Result := FQuickCustomization or (MasterContainer <> nil) and MasterContainer.IsQuickCustomization;
end;

function TdxLayoutContainer.IsStandardCustomization: Boolean;
begin
  Result := IsCustomization and not IsQuickCustomization;
end;

procedure TdxLayoutContainer.PostBuildSelectionLayer;
begin
// do nothing
end;

procedure TdxLayoutContainer.PostInvalidateSelectionLayer(const R: TRect);
begin
// do nothing
end;

procedure TdxLayoutContainer.SelectItemParent;
var
  AList: TcxComponentList;
  AIntf: IdxLayoutSelectableItem;
begin
  AList := TcxComponentList.Create;
  try
    GetSelection(AList);
    if (AList.Count > 0) and Supports(AList[0], IdxLayoutSelectableItem, AIntf) then
      AIntf.SelectParent;
  finally
    AList.Free;
  end;
end;

procedure TdxLayoutContainer.ResetDragAndDropObjects;
begin
  if CustomizeForm <> nil then
    CustomizeForm.ResetDragAndDropObjects;
  CustomizeFormPostUpdate([cfutDragAndDropState]);
end;

procedure TdxLayoutContainer.BeginRename(AItem: TdxCustomLayoutItem; const ABounds: TRect; const AFont: TFont);
begin
  RenamingItem := AItem;
  ViewInfo.SelectionLayer.BeginRename(ABounds, FRenamingItem.GetInplaceRenameCaption, AFont);
end;

procedure TdxLayoutContainer.CancelRename;
begin
  RenamingItem := nil;
end;

procedure TdxLayoutContainer.EndRename(const AText: string);
begin
  if RenamingItem <> nil then
    RenamingItem.SetInplaceRenameCaption(AText);
  RenamingItem := nil;
end;

procedure TdxLayoutContainer.UpdateItemsCustomization;
var
  I: Integer;
begin
  for I := 0 to AbsoluteItemCount - 1 do
    AbsoluteItems[I].Customization := Customization;
end;

procedure TdxLayoutContainer.PostPlaceControls;
begin
// do nothing
end;

procedure TdxLayoutContainer.PlaceControls(AItemViewInfo: TdxCustomLayoutItemViewInfo; AProcessWinControls: Boolean; AAdditionalFlags: Integer);
begin
  if FPlaceControlsLockCount > 0 then
    FIsPlaceControlsNeeded := True
  else
  begin
    if AItemViewInfo <> nil then
      Painter.PlaceControls(AItemViewInfo, AProcessWinControls, AAdditionalFlags)
    else
      if IsDesigning then
        PostPlaceControls
      else
        Painter.PlaceControls(ViewInfo.ItemsViewInfo, AProcessWinControls, AAdditionalFlags);
  end;
end;

procedure TdxLayoutContainer.BeginPlaceControls;
begin
  Inc(FPlaceControlsLockCount);
end;

procedure TdxLayoutContainer.CancelPlaceControls;
begin
  Dec(FPlaceControlsLockCount);
  FIsPlaceControlsNeeded := False;
end;

procedure TdxLayoutContainer.EndPlaceControls;
begin
  Dec(FPlaceControlsLockCount);
  if (FPlaceControlsLockCount = 0) and FIsPlaceControlsNeeded then
    PlaceControls;
end;

function TdxLayoutContainer.IsPlacingControls: Boolean;
begin
  Result := FIsPlacingControls;
end;

procedure TdxLayoutContainer.PrepareControl(AControl: TControl);
begin
  AControl.Parent := ItemsParentControl;
end;

procedure TdxLayoutContainer.UnprepareControl(AControl: TControl);

    function GetControlWithTopPos(AWinControl: TWinControl; APos: Integer): Integer;
    var
      I: Integer;
    begin
      Result := -1;
      for I := 0 to AWinControl.ControlCount - 1 do
        if AWinControl.Controls[I].Top = APos then
        begin
          Result := I;
          Break
        end;
    end;

    function GetFreeTopPos(AWinControl: TWinControl): Integer;
    var
      AIndex: Integer;
    begin
      Result := 0;
      repeat
        AIndex := GetControlWithTopPos(AWinControl, Result);
        if AIndex > -1 then
          Result := AWinControl.Controls[AIndex].Top + ScaleFactor.Apply(21) + 1;
      until AIndex = -1
    end;

    function GetAllowedParent(var AParent: TWinControl): Boolean;
    begin
      Result := (AParent <> nil);
      if Result then
      begin
        if csDestroying in AParent.ComponentState then
        begin
          AParent := AParent.Parent;
          Result := GetAllowedParent(AParent);
        end;
      end;
    end;

var
  AParent: TWinControl;
begin
  if AControl.Parent = ItemsParentControl then
  begin
    AParent := ItemsParentControl.Parent;
    if IsDesigning and not (csDestroying in AControl.ComponentState) and GetAllowedParent(AParent) then
    begin
      AControl.Parent := AParent;
      AControl.Left := 0;
      AControl.Top := GetFreeTopPos(AParent);
    end;
  end;
end;

procedure TdxLayoutContainer.BeginPlacingControls;
begin
  FIsPlacingControls := True;
end;

procedure TdxLayoutContainer.EndPlacingControls;
begin
  FIsPlacingControls := False;
end;

function TdxLayoutContainer.IsProcessingControls: Boolean;
begin
  Result := FIsProcessingControls > 0;
end;

procedure TdxLayoutContainer.BeginProcessControls;
begin
  BeginPlacingControls;
  Inc(FIsProcessingControls);
end;

procedure TdxLayoutContainer.EndProcessControls;
begin
  Dec(FIsProcessingControls);
  EndPlacingControls;
end;

function TdxLayoutContainer.IsScalingControls: Boolean;
begin
  Result := FIsScalingControls > 0;
end;

procedure TdxLayoutContainer.BeginScaleControls;
begin
  Inc(FIsScalingControls);
end;

procedure TdxLayoutContainer.EndScaleControls;
begin
  Dec(FIsScalingControls);
  if not IsScalingControls then
    LayoutChanged(false);
end;

function TdxLayoutContainer.IsDesigning: Boolean;
begin
  Result := csDesigning in ComponentState;
end;

function TdxLayoutContainer.IsDestroying: Boolean;
begin
  Result := csDestroying in ComponentState;
end;

function TdxLayoutContainer.IsGlobalLoading: Boolean;
begin
  Result := dxLoadingFlags * dxGetGlobalComponentState(Self) <> [];
end;

function TdxLayoutContainer.IsGlobalDestroying: Boolean;
begin
  Result := csDestroying in dxGetGlobalComponentState(Self);
end;

function TdxLayoutContainer.IsLoading: Boolean;
begin
  Result := dxLoadingFlags * ComponentState <> [];
end;

function TdxLayoutContainer.IsUpdateLocked: Boolean;
begin
  if MasterContainer <> nil then
    Result := MasterContainer.IsUpdateLocked
  else
    Result := FUpdateLockCount > 0;
end;

function TdxLayoutContainer.IsTranslating: Boolean;
begin
  Result := FTranslationLockCount > 0;
end;

procedure TdxLayoutContainer.Update;
begin
  if ItemsParentControl <> nil then
    ItemsParentControl.Update;
end;

procedure TdxLayoutContainer.AfterRestoring;

  procedure DeleteSuperfluousItems;
  var
    I: Integer;
  begin
    for I := ManagedItemCount - 1 downto 0 do
      if ManagedItems[I].NeedDeleteAfterLoading then
        ManagedItems[I].Free;
  end;

var
  I: Integer;
begin
  for I := 0 to ManagedItemCount - 1 do
    ManagedItems[I].AfterRestoring;
  CheckIndexes;
  DeleteSuperfluousItems;
end;

procedure TdxLayoutContainer.BeforeRestoring;

  procedure DeleteUserDefinedItems;
  var
    I: Integer;
  begin
    for I := ManagedItemCount - 1 downto 0 do
      if ManagedItems[I].IsUserDefined and ManagedItems[I].IsGroup then
      begin
        dxTestCheck(ManagedItems[I].AsGroup.Count = 0, 'TdxLayoutContainer.BeforeRestoring fails');
        ManagedItems[I].Free;
      end;
  end;

var
  I: Integer;
begin
  for I := 0 to ManagedItemCount - 1 do
    ManagedItems[I].BeforeRestoring;

  DeleteUserDefinedItems; 
end;

procedure TdxLayoutContainer.CheckIndexes;
var
  I: Integer;
begin
  if MasterContainer <> nil then
    MasterContainer.CheckIndexes
  else
  begin
    Root.CheckIndex;

    for I := 0 to AvailableItemCount - 1 do
      AvailableItems[I].CheckIndex;

    for I := 0 to FFloatContainers.Count - 1 do
      TdxLayoutContainer(FFloatContainers[I]).Root.CheckIndex;
    if (csAncestor in ComponentState) and not IsContainerReady then
    begin
      FCalculationDireNeeded := True;
      LayoutChanged;
    end;
  end;
end;

function TdxLayoutContainer.GetRootSectionName(AIniFile: TCustomIniFile): string;
begin
  if AIniFile.SectionExists(Owner.Name) then
    Result := Owner.Name
  else
    Result := '';
end;

function TdxLayoutContainer.LoadPreviousVersions(AIniFile: TCustomIniFile): Boolean;
var
  AItemCount, I: Integer;
  ARootSection: string;
  AVersion: Integer;

  function GetItemSection(AIndex: Integer): string;
  begin
    Result := 'Item' + IntToStr(AIndex);
    if ARootSection <> '' then
      Result := ARootSection + '\' + Result;
  end;

  procedure LoadItem(const ASection: string);

    function GetItemClass(AItemClassKind: Integer): TdxCustomLayoutItemClass;
    const
      AClasses: array[0..ickItemClassCount-1] of TdxCustomLayoutItemClass = (TdxLayoutItem, TdxLayoutGroup,
        TdxLayoutEmptySpaceItem, TdxLayoutSeparatorItem, TdxLayoutSplitterItem, TdxLayoutLabeledItem,
        TdxLayoutImageItem, TdxLayoutAutoCreatedGroup, TdxLayoutCheckBoxItem, TdxLayoutRadioButtonItem);
    var
      I: Integer;
    begin
      Result := TdxCustomLayoutGroup;
      for I := Low(AClasses) to High(AClasses) do
        if AClasses[I].GetItemClassKind = AItemClassKind then
        begin
          Result := AClasses[I];
          Break;
        end;
    end;

  var
    AName, AParentName: string;
    AItem: TdxCustomLayoutItem;
    AItemClassKind, AIndex: Integer;
  begin
    AName := AIniFile.ReadString(ASection, 'Name', '');
    if AName = '' then Exit;

    AItem := FindItem(AName);
    if AItem = nil then
    begin
      AItemClassKind := AIniFile.ReadInteger(ASection, 'ItemClassKind', TdxLayoutGroup.GetItemClassKind);
      AItem := CreateItem(GetItemClass(AItemClassKind));
      AItem.Name := AName;
      AItem.IsUserDefined := AIniFile.ReadBool(ASection, 'IsUserDefined', True);
      AItem.Superfluous := not AItem.IsUserDefined or ((AVersion < 3) and (AItemClassKind = ickControlItem));
    end
    else
      AItem.Superfluous := False;
    AParentName := AIniFile.ReadString(ASection, 'ParentName', '');
    AIndex := AIniFile.ReadInteger(ASection, 'Index', -1);
    AItem.SetLoadedInfo(AParentName, AIndex);
    AItem.LoadFromIni(AIniFile, ASection, AVersion);
  end;

begin
  ARootSection := GetRootSectionName(AIniFile);
  AVersion := AIniFile.ReadInteger(ARootSection, 'Version', 1);
  AItemCount := AIniFile.ReadInteger(ARootSection, 'ItemCount', -1);
  Result := not ((AItemCount = -1) or (AVersion > 2));
  if not Result then
    Exit;
  BeginUpdate;
  try
    IsRestoring := True;
    try
      for I := 0 to AItemCount - 1 do
        LoadItem(GetItemSection(I));
    finally
      IsRestoring := False;
    end;
  finally
    EndUpdate;
  end;
end;

procedure TdxLayoutContainer.StoreChildren(Proc: TGetChildProc);
var
  I: Integer;
begin
  Proc(Root);
  for I := 0 to ManagedItemCount - 1 do
    Proc(ManagedItems[I]);
  for I := 0 to AlignmentConstraintCount - 1 do
    Proc(AlignmentConstraints[I]);
end;

function TdxLayoutContainer.CanRestore: Boolean;
begin
  Result := False;
end;

function TdxLayoutContainer.StoringSupports: Boolean;
begin
  Result := False;
end;

procedure TdxLayoutContainer.Restore;
begin
// do nothing
end;

procedure TdxLayoutContainer.Store;
begin
// do nothing
end;

procedure TdxLayoutContainer.AddAbsoluteItem(AItem: TdxCustomLayoutItem);
begin
  if not AItem.FIsDestroying then
    FAbsoluteItems.Add(AItem);
end;

function TdxLayoutContainer.CanSetItemName(AItem: TdxCustomLayoutItem): Boolean;
begin
  Result := (ItemsParentComponent <> nil) and not IsLoading and not (csAncestor in AItem.ComponentState) and SelectionHelper.CanModify;
end;

procedure TdxLayoutContainer.ChangeScale(M, D: Integer);
var
  I: Integer;
begin
  BeginUpdate;
  try
    FScaleFactor.Change(M, D);
    for I := 0 to AbsoluteItemList.Count - 1 do
      TdxCustomLayoutItem(AbsoluteItemList[I]).ChangeScale(M, D);
  finally
    EndUpdate(False);
  end;
end;

procedure TdxLayoutContainer.ScaleForPPI(ATargetPPI: Integer);
begin
  if ScaleFactor.TargetDPI <> ATargetPPI then
    ChangeScale(ATargetPPI, ScaleFactor.TargetDPI);
end;

function TdxLayoutContainer.GetScaleFactor: TdxScaleFactor;
begin
  Result := FScaleFactor;
end;

procedure TdxLayoutContainer.BeginLayoutLookAndFeelUserDestroying;
begin
  BeginUpdate;
end;

procedure TdxLayoutContainer.EndLayoutLookAndFeelUserDestroying;
begin
  EndUpdate;
end;

procedure TdxLayoutContainer.LayoutLookAndFeelUserChanged;
begin
  if IsDestroying or IsLoading or (Root = nil) then
    Exit;
  BeginUpdate;
  try
    InitializeSubControlsCxLookAndFeel;
    if GetLayoutLookAndFeel <> nil then
      Root.LayoutLookAndFeelUserChanged;
  finally
    EndUpdate(False);
  end;
  CustomizeFormPostUpdate([cfutView]);
end;

procedure TdxLayoutContainer.LayoutLookAndFeelUserDestroyed;
begin
  LayoutLookAndFeel := nil;
end;

function TdxLayoutContainer.GetLayoutLookAndFeel: TdxCustomLayoutLookAndFeel;
begin
  Result := FLayoutLookAndFeel;
  if Result = nil then
    Result := dxLayoutDefaultLookAndFeel;
end;

procedure TdxLayoutContainer.AddAvailableItem(AItem: TdxCustomLayoutItem);
begin
  if not AItem.FIsDestroying then
    FAvailableItems.Add(AItem);
end;

procedure TdxLayoutContainer.DisposeGroup(AGroup: TdxCustomLayoutGroup);
begin
  AGroup.Parent := nil;
  FGarbageCollector.Add(AGroup);
  ExtractAvailableItem(AGroup);
  Modified;
end;

procedure TdxLayoutContainer.DoItemChanged(AItem: TdxCustomLayoutItem);
begin
  if MasterContainer <> nil then
    MasterContainer.DoItemChanged(AItem)
  else
    if Assigned(FOnItemChanged) then
      FOnItemChanged(AItem);
end;

procedure TdxLayoutContainer.ExtractAbsoluteItem(AItem: TdxCustomLayoutItem);
begin
  FAbsoluteItems.Extract(AItem);
end;

procedure TdxLayoutContainer.ExtractAvailableItem(AItem: TdxCustomLayoutItem);
begin
  FAvailableItems.Extract(AItem);
end;

function TdxLayoutContainer.IsRoot(AItem: TdxCustomLayoutItem): Boolean;
begin
  Result := AItem = Root;
end;

function TdxLayoutContainer.IsRootStored: Boolean;
begin
  Result := True;
end;

function TdxLayoutContainer.IsSizableHorz: Boolean;
begin
  Result := True;
end;

function TdxLayoutContainer.IsSizableVert: Boolean;
begin
  Result := True;
end;

procedure TdxLayoutContainer.SetDefaultItemName(AItem: TdxCustomLayoutItem);
begin
  SetComponentName(AItem, AItem.GetBaseName, AItem.IsDesigning, AItem.IsLoading);
end;

function TdxLayoutContainer.FindItem(AControl: TControl): TdxLayoutItem;
var
  I: Integer;
  AItem: TdxCustomLayoutItem;
begin
  Result := nil;
  for I := 0 to ManagedItemCount - 1 do
  begin
    AItem := ManagedItems[I];
    if (AItem is TdxLayoutItem) and (TdxLayoutItem(AItem).Control = AControl) then
    begin
      Result := TdxLayoutItem(AItem);
      Break;
    end;
  end;
end;

function TdxLayoutContainer.FindItem(AControlHandle: THandle): TdxLayoutItem;
var
  I: Integer;
  AItem: TdxCustomLayoutItem;
begin
  Result := nil;
  for I := 0 to ManagedItemCount - 1 do
  begin
    AItem := ManagedItems[I];
    if (AItem is TdxLayoutItem) and TdxLayoutItem(AItem).HasWinControl and
      TdxLayoutItem(AItem).WinControl.HandleAllocated and
      (TdxLayoutItem(AItem).WinControl.Handle = AControlHandle) then
    begin
      Result := TdxLayoutItem(AItem);
      Break;
    end;
  end;
end;

function TdxLayoutContainer.FindItem(const AName: string): TdxCustomLayoutItem;
var
  I: Integer;
begin
  if AName <> '' then
  begin
    Result := Root;
    if SameText(Result.Name, AName) then Exit;
    for I := 0 to ManagedItemCount - 1 do
    begin
      Result := ManagedItems[I];
      if SameText(Result.Name, AName) then Exit;
    end;
  end;
  Result := nil;
end;

procedure TdxLayoutContainer.DoInitialize;
begin
  FSelectionHelper := GetSelectionHelperClass.Create(Self);
  FSelectionHelper.AddSelectionChangedListener(Self);
  CreateItems;
  CreateRootGroup;
  FUndoRedoManager := TdxUndoRedoManager.Create(Self);
  FFocusController := GetFocusControllerClass.Create(Self);

  FCustomizeAvailableItemsViewKind := aivkTree;
  FCustomizeFormClass := TdxLayoutControlCustomizeForm;
  FShowDesignSelectors := True;
  FHighlightRoot := True;
  FMenuItems := dxDefaultLayoutCustomizeFormMenuItems;

  GetLayoutLookAndFeel.AddUser(Self);
end;

function TdxLayoutContainer.IsAutoControlAlignment: Boolean;
begin
  Result := True;
end;

function TdxLayoutContainer.IsAutoControlTabOrders: Boolean;
begin
  Result := True;
end;

function TdxLayoutContainer.IsFocusControlOnItemCaptionClick: Boolean;
begin
  Result := True;
end;

procedure TdxLayoutContainer.Initialize;
begin
  BeginUpdate;
  try
    DoInitialize;
  finally
    CancelUpdate;
  end;
end;

procedure TdxLayoutContainer.CreateRootGroup;
begin
  if not IsGlobalLoading or not IsRootStored then
  begin
    SetRootGroup(GetDefaultRootGroupClass.Create(ItemsOwner));
    if CanSetItemName(Root) then
      UpdateRootName;
  end;
end;

procedure TdxLayoutContainer.DestroyRootGroup;
begin
  SetRootGroup(nil);
end;

procedure TdxLayoutContainer.SelectionChanged(ASelection: TList; AAction: TdxSelectionAction);

  procedure TryMakeVisibleSelection;
  var
    AList: TList;
    AIntf: IdxLayoutSelectableItem;
  begin
    AList := TList.Create;
    try
      GetSelection(AList);
      if (AList.Count > 0) and Supports(TObject(AList.Last), IdxLayoutSelectableItem, AIntf) then
      begin
        AIntf.MakeVisible;
        AIntf := nil;
      end;
    finally
      AList.Free;
    end;
  end;

begin
  RenamingItem := nil;

  if not IsDestroying and (AAction in [saAdded, saChanged]) and not IsUpdateLocked then
  begin
    if AAction = saAdded then
      TryMakeVisibleSelection;
    BuildSelectionLayer;
    CustomizeFormPostUpdate([cfutSelection]);
  end;
  DoSelectionChanged;
end;

procedure TdxLayoutContainer.AddSelectionChangedListener(AListener: TPersistent);
begin
  if (SelectionHelper <> nil) then
    SelectionHelper.AddSelectionChangedListener(AListener);
end;

function TdxLayoutContainer.IsActive: Boolean;
begin
  Result := (SelectionHelper <> nil) and SelectionHelper.IsActive;
end;

function TdxLayoutContainer.CanDeleteComponent(AComponent: TComponent): Boolean;
begin
  Result := (SelectionHelper <> nil) and SelectionHelper.CanDeleteComponent(AComponent);
end;

function TdxLayoutContainer.CanModify: Boolean;
begin
  Result := (SelectionHelper <> nil) and SelectionHelper.CanModify;
end;

function TdxLayoutContainer.CanProcessKeyboard: Boolean;
begin
  Result := False;
end;

procedure TdxLayoutContainer.ClearSelection;
begin
  if SelectionHelper <> nil then
    SelectionHelper.ClearSelection;
end;

procedure TdxLayoutContainer.DeleteComponent(AComponent: TComponent);
begin
  if SelectionHelper <> nil then
    SelectionHelper.DeleteComponent(AComponent);
end;

procedure TdxLayoutContainer.DeleteComponents(AList: TComponentList);
begin
  if SelectionHelper <> nil then
    SelectionHelper.DeleteComponents(AList);
end;

procedure TdxLayoutContainer.DeleteSelection;
begin
  if SelectionHelper <> nil then
    SelectionHelper.DeleteSelection;
end;

procedure TdxLayoutContainer.GetSelection(AList: TList);
begin
  if SelectionHelper <> nil then
    SelectionHelper.GetSelection(AList);
end;

function TdxLayoutContainer.IsComponentSelected(AComponent: TPersistent): Boolean;
begin
  Result := (SelectionHelper <> nil) and SelectionHelper.IsComponentSelected(AComponent);
end;

procedure TdxLayoutContainer.RemoveSelectionChangedListener(AListener: TPersistent);
begin
  if SelectionHelper <> nil then
    SelectionHelper.RemoveSelectionChangedListener(AListener);
end;

procedure TdxLayoutContainer.SelectComponent(AComponent: TPersistent; AShift: TShiftState = []);
begin
  if SelectionHelper <> nil then
    SelectionHelper.SelectComponent(AComponent, AShift);
end;

procedure TdxLayoutContainer.SetSelection(AList: TList);
begin
  if SelectionHelper <> nil then
    SelectionHelper.SetSelection(AList);
end;

function TdxLayoutContainer.AllowWrapItems: Boolean;
begin
  Result := False;
end;

function TdxLayoutContainer.IsEditorMode: Boolean;
begin
  Result := ViewInfo.SelectionLayer.EditorMode;
end;

function TdxLayoutContainer.IsViewInfoValid: Boolean;
begin
  Result := (ViewInfo <> nil) and ViewInfo.FIsValid;
end;

function TdxLayoutContainer.UseRightToLeftAlignment: Boolean;
begin
  Result := ItemsParentControl.UseRightToLeftAlignment;
end;

function TdxLayoutContainer.UniqueName(const BaseName: string): string;
begin
  if SelectionHelper <> nil then
    Result := SelectionHelper.UniqueName(BaseName)
  else
    Result := '';
end;

function TdxLayoutContainer.GetContainer: TdxLayoutContainer;
begin
  Result := Self;
end;

procedure TdxLayoutContainer.DoGetStoredPropertyValue(const AName: string; var AValue: Variant);
begin
// do nothing
end;

procedure TdxLayoutContainer.DoSetStoredPropertyValue(const AName: string; const AValue: Variant);
begin
// do nothing
end;

function TdxLayoutContainer.GetStoredObjectName: string;
begin
  if FStoringName <> '' then
    Result := FStoringName
  else
    Result := ItemsParentComponent.Name;
end;

function TdxLayoutContainer.GetStoredProperties(AProperties: TStrings): Boolean;
begin
  Result := True;
  AProperties.Add('Version');
end;

procedure TdxLayoutContainer.GetStoredPropertyValue(const AName: string; var AValue: Variant);
begin
  if AName = 'Version' then
    AValue := dxLayoutVersion
  else
    DoGetStoredPropertyValue(AName, AValue);
end;

procedure TdxLayoutContainer.SetStoredPropertyValue(const AName: string; const AValue: Variant);
begin
  if AName = 'Version' then
    FStoredVersion := AValue
  else
    DoSetStoredPropertyValue(AName, AValue);
end;

function TdxLayoutContainer.CreateChild(const AObjectName, AClassName: string): TObject;
var
  AClass: TdxCustomLayoutItemClass;
  AItem: TdxCustomLayoutItem;
begin
  Result := nil;
  AClass := TdxCustomLayoutItemClass(FindClass(AClassName));
  if AClass <> nil then
  begin
    AItem := CreateItem(AClass);
    if AItem <> nil then
    begin
      AItem.Name := AObjectName;
      AItem.Superfluous := True;
      Result := AItem;
    end;
  end;
end;

procedure TdxLayoutContainer.DeleteChild(const AObjectName: string; AObject: TObject);
begin
end;

procedure TdxLayoutContainer.GetStoredChildren(AChildren: TStringList);

  procedure StoreContainer(AContainer: TdxLayoutContainer);
  var
    I: Integer;
  begin
    for I := 0 to AContainer.ManagedItemCount - 1 do
      AChildren.AddObject(AContainer.ManagedItems[I].Name, AContainer.ManagedItems[I])
  end;

begin
  AChildren.AddObject(Root.Name, Root);
  StoreContainer(Self);
end;

procedure TdxLayoutContainer.GetItemStoredProperties(AItem: TdxCustomLayoutItem; AProperties: TStrings);
begin
// do nothing
end;

procedure TdxLayoutContainer.DoGetItemStoredPropertyValue(
  AItem: TdxCustomLayoutItem; const AName: string; var AValue: Variant);
begin
// do nothing
end;

procedure TdxLayoutContainer.DoSetItemStoredPropertyValue(
  AItem: TdxCustomLayoutItem; const AName: string; const AValue: Variant);
begin
// do nothing
end;


procedure TdxLayoutContainer.RestoreFrom(const AStorageName: string; AStream: TStream;
  AReaderClass: TcxCustomReaderClass; const ARestoreName: string);
var
  AStorage: TcxStorage;
begin
  FStoringName := ARestoreName;
  AStorage := TcxStorage.Create(AStorageName, AStream);
  try
    if not IsStoringNameMode then
      AStorage.NamePrefix := ItemsOwner.Name;
    AStorage.Modes := [smChildrenCreating];
    FStoredVersion := 0;
    BeginUpdate;
    try
      IsRestoring := True;
      try
        AStorage.RestoreFrom(Self, AReaderClass);
      finally
        IsRestoring := False;
      end;
    finally
      EndUpdate;
    end;
  finally
    AStorage.Free;
  end;
end;

procedure TdxLayoutContainer.StoreTo(const AStorageName: string; AStream: TStream;
  AWriterClass: TcxCustomWriterClass; AReCreate: Boolean; const ASaveName: string);
var
  AStorage: TcxStorage;
begin
  FStoringName := ASaveName;
  AStorage := TcxStorage.Create(AStorageName, AStream);
  try
    if ASaveName = '' then
      AStorage.NamePrefix := ItemsOwner.Name;
    AStorage.ReCreate := AReCreate;
    AStorage.StoreTo(Self, AWriterClass);
  finally
    AStorage.Free;
  end;
end;

procedure TdxLayoutContainer.SetFocus;
begin
  if IsContainerReady then
    FocusController.SetFocus;
end;

function TdxLayoutContainer.GetMaxTabOrder: Integer;
begin
  Result := ViewInfo.ItemsViewInfo.GetMaxTabOrder;
end;

procedure TdxLayoutContainer.KillFocus;
begin
  FocusController.KillFocus;
end;

function TdxLayoutContainer.FindFocusedItem: TdxCustomLayoutItem;
var
  AWnd: THandle;
begin
  AWnd := GetFocus;
  if ItemsParentControl.HandleAllocated and (AWnd = ItemsParentControl.Handle) then
    Result := FocusController.FocusedItem
  else
    repeat
      Result := FindItem(AWnd);
      AWnd := GetAncestor(AWnd, GA_PARENT);
    until (Result <> nil) or (AWnd = 0);
end;

function TdxLayoutContainer.ProcessDialogChar(ACharCode: Word): Boolean;
begin
  Result := not IsUpdateLocked and Root.ProcessDialogChar(ACharCode);
end;

function TdxLayoutContainer.ProcessDialogKey(ACharCode: Word; AKeyData: Integer): Boolean;
var
  AFocusedItem: TdxCustomLayoutItem;
begin
  AFocusedItem := FindFocusedItem;
  Result := not IsUpdateLocked and (AFocusedItem <> nil) and Root.ProcessDialogKey(ACharCode, AKeyData, AFocusedItem);
end;

procedure TdxLayoutContainer.CalculateTabOrders;
begin
  if not IsUpdateLocked and IsViewInfoValid then
    ViewInfo.CalculateTabOrders;
end;

procedure TdxLayoutContainer.BiDiModeChanged;
var
  I: Integer;
begin
  if MasterContainer = nil then
  begin
    for I := 0 to FFloatContainers.Count - 1 do
      TdxLayoutContainer(FFloatContainers[I]).BiDiModeChanged;
  end
  else
    for I := 0 to Root.Count - 1 do
      Root.Items[I].BiDiModeChanged;
end;

function TdxLayoutContainer.CreateItemSelectorHelper(AItem: TdxLayoutItem): TdxControlsDesignSelectorHelper;
begin
  Result := nil;
end;

function TdxLayoutContainer.GetCanvas: TcxCanvas;
begin
  Result := nil;
end;

function TdxLayoutContainer.GetClientBounds: TRect;
begin
  Result := cxNullRect;
end;

function TdxLayoutContainer.GetItemsOwner: TComponent;
begin
  Result := Self;
end;

function TdxLayoutContainer.GetItemsParentControl: TcxControl;
begin
  Result := nil;
end;

function TdxLayoutContainer.GetOccupiedClientHeight: Integer;
begin
  if (ViewInfo.RootViewInfo <> nil) and ViewInfo.RootViewInfo.IsValid then
  begin
    ViewInfo.FIsOccupiedSizeCalculating := True;
    try
      Result := ViewInfo.RootViewInfo.CalculateHeight;
    finally
      ViewInfo.FIsOccupiedSizeCalculating := False;
    end;
  end
  else
    Result := -1;
end;

function TdxLayoutContainer.GetOccupiedClientWidth: Integer;
begin
  if (ViewInfo.RootViewInfo <> nil) and ViewInfo.RootViewInfo.IsValid then
  begin
    ViewInfo.FIsOccupiedSizeCalculating := True;
    try
      Result := ViewInfo.RootViewInfo.CalculateWidth;
    finally
      ViewInfo.FIsOccupiedSizeCalculating := False;
    end;
  end
  else
    Result := -1;
end;

function TdxLayoutContainer.GetItemsParentComponent: TComponent;
begin
  Result := nil;
end;

function TdxLayoutContainer.GetScrollOffset: TPoint;
begin
  Result := cxNullPoint;
end;

function TdxLayoutContainer.IsTransparent: Boolean;
begin
  Result := False;
end;

function TdxLayoutContainer.IsTransparentBackground: Boolean;
begin
  Result := True;
end;

function TdxLayoutContainer.IsShowLockedGroupChildren: Boolean;
begin
  Result := True;
end;

procedure TdxLayoutContainer.SizeAdjustment;
begin
// do nothing
end;

procedure TdxLayoutContainer.DoGroupScroll(Sender: TObject);
begin
// do nothing
end;

procedure TdxLayoutContainer.MakeVisible(const ARect: TRect; AFully: Boolean);
begin
// do nothing
end;

procedure TdxLayoutContainer.Clear;
var
  I: Integer;
  AItem: TdxCustomLayoutItem;
begin
  BeginUpdate;
  try
    for I := AbsoluteItemCount - 1 downto 0 do
    begin
      AItem := AbsoluteItems[I];
      if (AItem is TdxLayoutItem) and (TdxLayoutItem(AItem).Control <> nil) then
        TdxLayoutItem(AItem).Control.Free;
    end;
    while AbsoluteItemCount <> 0 do
      AbsoluteItems[0].Free;
  finally
    EndUpdate;
  end;
end;

function TdxLayoutContainer.CreateGroup: TdxLayoutGroup;
begin
  Result := TdxLayoutGroup(CreateGroup(TdxLayoutGroup));
end;

function TdxLayoutContainer.CreateGroup(AGroupClass: TdxCustomLayoutGroupClass; AParent: TdxCustomLayoutGroup = nil): TdxCustomLayoutGroup;
begin
  if AGroupClass = nil then
    AGroupClass := GetDefaultGroupClass;
  Result := CreateItem(AGroupClass, AParent).AsGroup;
end;

function TdxLayoutContainer.CreateItem(AItemClass: TdxCustomLayoutItemClass = nil; AParent: TdxCustomLayoutGroup = nil): TdxCustomLayoutItem;
begin
  if AItemClass = nil then
    AItemClass := GetDefaultItemClass;
  Result := AItemClass.Create(ItemsOwner);
  Result.Container := Self;
  Result.Parent := AParent;
  Modified;
end;

function TdxLayoutContainer.CreateItemForControl(AControl: TControl; AParent: TdxCustomLayoutGroup = nil): TdxLayoutItem;
begin
  Result := TdxLayoutItem(CreateItem(GetDefaultItemClass, AParent));
  Result.Control := AControl;
end;

function TdxLayoutContainer.GetRoot: TdxLayoutGroup;
begin
  Result := FRoot;
end;

procedure TdxLayoutContainer.InsertItem(AItem: TdxCustomLayoutItem);
begin
  if ManagedItemList.IndexOf(AItem) = -1 then
    ManagedItemList.Add(AItem);
  AddAbsoluteItem(AItem);
  if AItem.Parent = nil then
    AddAvailableItem(AItem);
end;

procedure TdxLayoutContainer.RemoveItem(AItem: TdxCustomLayoutItem);
begin
  ExtractAbsoluteItem(AItem);
  if AItem.Parent = nil then
    ExtractAvailableItem(AItem);
end;

procedure TdxLayoutContainer.SetRootGroup(Value: TdxLayoutGroup);
begin
  BeginUpdate;
  try
    if Value <> nil then
    begin
      if FRoot <> nil then
        Value.FAlign := FRoot.Align
      else
        Value.FAlign := dxLayoutAlign(ahLeft, avTop);
    end;

    if FRoot <> nil then
    begin
      DestroyHandlers;
      FRoot.RemoveFreeNotification(Self);
      FreeAndNil(FRoot);
    end;
    FRoot := Value;
    if FRoot <> nil then
    begin
      FRoot.FreeNotification(Self);
      FRoot.FContainer := Self;
      FRoot.Hidden := True;
      CreateHandlers;
    end;
  finally
    EndUpdate(not IsDestroying);
  end;
end;

procedure TdxLayoutContainer.UpdateItemDesignSelectors;
var
  I: Integer;
begin
  for I := 0 to ManagedItemCount - 1 do
    if ManagedItems[I] is TdxLayoutItem then
      TdxLayoutItem(ManagedItems[I]).UpdateDesignSelector;
end;

procedure TdxLayoutContainer.UpdateRootName;
begin
  Root.Name := GetValidName(Root, Root.GetBaseName + '_Root');
end;

procedure TdxLayoutContainer.TryDestroySuperfluousGroup(AGroup: TdxCustomLayoutGroup);
begin
  if csAncestor in AGroup.ComponentState then
    DisposeGroup(AGroup)
  else
    DeleteComponent(AGroup);
end;

function TdxLayoutContainer.GetAutoCreatedGroup: TdxLayoutAutoCreatedGroup;
begin
  Result := TdxLayoutAutoCreatedGroup(CreateGroup(TdxLayoutAutoCreatedGroup));
end;

procedure TdxLayoutContainer.AbsoluteItemListChanged(Sender: TObject; AComponent: TComponent; AAction: TcxComponentCollectionNotification);
var
  AGroup: TdxCustomLayoutGroup;
begin
//  FIsManagedItemsValid := False;
  if (AAction in [ccnExtracting, ccnExtracted, ccnDeleting]) and (ViewInfo <> nil) and
      (ViewInfo.ItemWithMouse = AComponent) then
    ViewInfo.ItemWithMouse := nil;
  if IsDesigning and not IsDestroying and
    (AComponent.ComponentState * [csAncestor, csDestroying] = [csAncestor, csDestroying]) then
  begin
    if AComponent is TdxCustomLayoutGroup then
    begin
      AGroup := TdxCustomLayoutGroup(AComponent);
      BeginUpdate;
      try
        while AGroup.Count > 0 do
          AGroup.Items[0].Parent := nil;
      finally
        EndUpdate;
      end;
    end;
  end;
end;

procedure TdxLayoutContainer.AvailableItemListChanged(
  Sender: TObject; AComponent: TComponent; AAction: TcxComponentCollectionNotification);
begin
  CustomizeFormPostUpdate([cfutAvailableItems]);
end;

procedure TdxLayoutContainer.FloatContainersListChanged(Sender: TObject; AComponent: TComponent; AAction: TcxComponentCollectionNotification);
begin
  CustomizeFormPostUpdate([cfutVisibleItems]);
end;

function TdxLayoutContainer.GetClientRect: TRect;
begin
  Result := cxNullRect;
end;

function TdxLayoutContainer.GetIsDesignSelectorsVisible: Boolean;
begin
  Result := IsDesigning and ShowDesignSelectors;
end;

function TdxLayoutContainer.GetIsOnGlass: Boolean;
begin
  Result := csGlassPaint in ItemsParent.ControlState;
end;

function TdxLayoutContainer.GetIsStoringNameMode: Boolean;
begin
  Result := FStoringName <> '';
end;

function TdxLayoutContainer.GetDragDropMode: TdxLayoutDragDropMode;
begin
  Result := RealContainer.FDragDropMode;
end;

function TdxLayoutContainer.GetRealContainer: TdxLayoutContainer;
begin
  if MasterContainer <> nil then
    Result := MasterContainer
  else
    Result := Self;
end;

function TdxLayoutContainer.GetSelectionHelper: IdxLayoutDesignerHelper;
begin
  Result := RealContainer.FSelectionHelper;
end;

procedure TdxLayoutContainer.CreateConstraints;
begin
  FAlignmentConstraints := TComponentList.Create;
end;

procedure TdxLayoutContainer.DestroyConstraints;
begin
  FAlignmentConstraints.OwnsObjects := True;
  FreeAndNil(FAlignmentConstraints);
end;

function TdxLayoutContainer.GetAlignmentConstraint(Index: Integer): TdxLayoutAlignmentConstraint;
begin
  Result := TdxLayoutAlignmentConstraint(FAlignmentConstraints[Index]);
end;

function TdxLayoutContainer.GetAlignmentConstraintCount: Integer;
begin
  Result := FAlignmentConstraints.Count;
end;

function TdxLayoutContainer.GetCustomization: Boolean;
begin
  Result := RealContainer.FCustomization
end;

procedure TdxLayoutContainer.AddAlignmentConstraint(AConstraint: TdxLayoutAlignmentConstraint);
begin
  FAlignmentConstraints.Add(AConstraint);
  AConstraint.FContainer := Self;
  SetComponentName(AConstraint, Name + 'AlignmentConstraint', IsDesigning, IsLoading);
end;

procedure TdxLayoutContainer.RemoveAlignmentConstraint(AConstraint: TdxLayoutAlignmentConstraint);
begin
  FAlignmentConstraints.Remove(AConstraint);
  AConstraint.FContainer := nil;
end;

function TdxLayoutContainer.GetAbsoluteItem(AIndex: Integer): TdxCustomLayoutItem;
begin
  Result := TdxCustomLayoutItem(FAbsoluteItems.List[AIndex]);
end;

function TdxLayoutContainer.GetAbsoluteItemCount: Integer;
begin
  Result := FAbsoluteItems.Count;
end;

function TdxLayoutContainer.GetAvailableItem(AIndex: Integer): TdxCustomLayoutItem;
begin
  Result := TdxCustomLayoutItem(FAvailableItems.List[AIndex]);
end;

function TdxLayoutContainer.GetAvailableItemCount: Integer;
begin
  Result := FAvailableItems.Count;
end;

function TdxLayoutContainer.GetManagedItem(AIndex: Integer): TdxCustomLayoutItem;
begin
  Result := TdxCustomLayoutItem(GetManagedItemList.List[AIndex]);
end;

function TdxLayoutContainer.GetManagedItemCount: Integer;
begin
  Result := GetManagedItemList.Count;
end;

function TdxLayoutContainer.GetManagedItemList: TcxComponentList;
begin
  Result := RealContainer.FManagedItems;
end;

procedure TdxLayoutContainer.SetAllowGroupWrapItems(AValue: Boolean);
begin
  if FAllowGroupWrapItems <> AValue then
  begin
    FAllowGroupWrapItems := AValue;
    LayoutChanged(False);
  end;
end;

procedure TdxLayoutContainer.SetCustomization(AValue: Boolean);
var
  AParentForm: TCustomForm;
begin
  if MasterContainer <> nil then
    Exit;
  if (FCustomization <> AValue) and (not AValue or CanAllocateHandle(ItemsParentControl)) then
  begin
    if AValue then
    begin
      ItemsParentControl.HandleNeeded;
      if not (IsDestroying or IsDesigning) and IsChildWindow(ItemsParentControl, GetFocus) then
      begin
        AParentForm := GetParentForm(ItemsParentControl);
        if (AParentForm <> nil) and ItemsParentControl.Visible then
          AParentForm.ActiveControl := ItemsParentControl;
      end;
      FCustomization := True;
      CreateCustomizeForm;
      if IsStandardCustomization then
        ShowCustomizeForm;
    end
    else
    begin
      FCustomization := False;
      DestroyCustomizeForm;
      if not IsDesigning then
        ClearSelection;
    end;
    CustomizationChanged;
    UpdateItemsCustomization;
  end
  else
    if FCustomization then
      CustomizeForm.BringToFront;
end;

procedure TdxLayoutContainer.SetCustomizeAvailableItemsViewKind(
  Value: TdxLayoutAvailableItemsViewKind);
begin
  if FCustomizeAvailableItemsViewKind <> Value then
  begin
    FCustomizeAvailableItemsViewKind := Value;
    CustomizeFormPostUpdate([cfutAvailableItems, cfutSelection, cfutView]);
  end;
end;

procedure TdxLayoutContainer.SetCustomizeFormTabbedView(AValue: Boolean);
begin
  if FCustomizeFormTabbedView <> AValue then
  begin
    FCustomizeFormTabbedView := AValue;
    CustomizeFormPostUpdate([cfutView]);
    Modified;
  end;
end;

procedure TdxLayoutContainer.SetHighlightRoot(AValue: Boolean);
begin
  if FHighlightRoot <> AValue then
  begin
    FHighlightRoot := AValue;
    LayoutChanged(False);
    CustomizeFormPostUpdate([cfutView]);
    Modified;
  end;
end;

procedure TdxLayoutContainer.SetIsRestoring(AValue: Boolean);
begin
  if AValue then
  begin
    FIsRestoring := True;
    BeforeRestoring;
  end
  else
  begin
    AfterRestoring;
    FIsRestoring := False;
  end;
end;

procedure TdxLayoutContainer.SetLayoutLookAndFeel(Value: TdxCustomLayoutLookAndFeel);
begin
  if FLayoutLookAndFeel <> Value then
  begin
    GetLayoutLookAndFeel.RemoveUser(Self);
    FLayoutLookAndFeel := Value;
    GetLayoutLookAndFeel.AddUser(Self);
    LayoutLookAndFeelUserChanged;
  end;
end;

procedure TdxLayoutContainer.SetQuickCustomization(Value: Boolean);
begin
  if MasterContainer <> nil then
    MasterContainer.QuickCustomization := Value
  else
    if (FQuickCustomization <> Value) and (QuickCustomization = Customization) then
    begin
      FQuickCustomization := Value;
      Customization := Value;
    end;
end;

procedure TdxLayoutContainer.SetImageOptions(AValue: TdxLayoutImageOptions);
begin
  FImageOptions.Assign(AValue);
end;

procedure TdxLayoutContainer.SetRenamingItem(AValue: TdxCustomLayoutItem);
begin
  if FRenamingItem <> AValue then
  begin
    if (FRenamingItem <> nil) and ViewInfo.SelectionLayer.EditorMode then
      ViewInfo.SelectionLayer.EndRename(not IsDestroying);
    FRenamingItem := AValue;
  end;
end;

procedure TdxLayoutContainer.SetShowDesignSelectors(Value: Boolean);
begin
  if FShowDesignSelectors <> Value then
  begin
    FShowDesignSelectors := Value;
    UpdateItemDesignSelectors;
    InvalidateWithChildren;
    CustomizeFormPostUpdate([cfutView]);
    Modified;
    PostBuildSelectionLayer;
  end;
end;

procedure TdxLayoutContainer.SetOnItemChanged(AValue: TdxLayoutItemChangedEvent);
var
  I: Integer;
begin
  FOnItemChanged := AValue;
  for I := 0 to FloatContainers.Count - 1 do
    TdxLayoutContainer(FloatContainers[I]).OnItemChanged := AValue;
end;


{ TdxCustomLayoutControlAdapter }

constructor TdxCustomLayoutControlAdapter.Create(AItem: TdxLayoutItem);
begin
  inherited Create;
  FItem := AItem;
end;

destructor TdxCustomLayoutControlAdapter.Destroy;
var
  ATouchModeSupport: IdxTouchModeSupport;
begin
  if not Item.IsDesigning and Supports(Control, IdxTouchModeSupport, ATouchModeSupport) then
    ATouchModeSupport.Disable;
  inherited;
end;

procedure TdxCustomLayoutControlAdapter.Initialize;
var
  ATouchModeSupport: IdxTouchModeSupport;
begin
  if not FItem.IsLoading and not FItem.IsDragged and not FItem.FIsReseting then
  begin
    Init;
    SetInitialSettings;
  end;
  if not Item.IsDesigning and Supports(Control, IdxTouchModeSupport, ATouchModeSupport) then
    ATouchModeSupport.Enable;
end;

procedure TdxCustomLayoutControlAdapter.BeginCustomization;
begin
end;

procedure TdxCustomLayoutControlAdapter.EndCustomization;
begin
end;

function TdxCustomLayoutControlAdapter.GetControl: TControl;
begin
  Result := FItem.Control;
end;

function TdxCustomLayoutControlAdapter.GetLayoutLookAndFeel: TdxCustomLayoutLookAndFeel;
begin
  Result := FItem.GetLayoutLookAndFeel;
end;

function TdxCustomLayoutControlAdapter.AllowCheckAutoSize: Boolean;
begin
  Result := False;
end;

function TdxCustomLayoutControlAdapter.AllowCheckSize: Boolean;
begin
  Result := True;
end;

function TdxCustomLayoutControlAdapter.GetControlAutoWidth: Boolean;
begin
  Result := False;
end;

function TdxCustomLayoutControlAdapter.GetControlAutoHeight: Boolean;
begin
  Result := False;
end;

procedure TdxCustomLayoutControlAdapter.HideControlBorder;
begin
  SetEnumProp(Control, 'BorderStyle', 'bsNone');
  if IsPublishedProp(Control, 'BevelInner') and IsPublishedProp(Control, 'BevelKind') and IsPublishedProp(Control, 'BevelOuter') then
  begin
    SetEnumProp(Control, 'BevelInner', 'bvNone');
    SetEnumProp(Control, 'BevelKind', 'bkFlat');
    SetEnumProp(Control, 'BevelOuter', 'bvSpace');
  end;
end;

procedure TdxCustomLayoutControlAdapter.Init;
var
  AHeight: Integer;
begin
  FItem.ControlOptions.AutoColor := UseItemColor;
  if FItem.IsDesigning and (FItem.Caption = '') then
    FItem.Caption := Control.Name;//GetPlainString(TControlAccess(Control).Caption);
  if FItem.IsDesigning then
    FItem.ShowCaption := ShowItemCaption;
  FItem.ControlOptions.ShowBorder := NeedBorder;
  if NeedBorder then
  begin
    if (Control is TWinControl) and (TWinControl(Control).HandleAllocated) then
    begin
      AHeight := Control.ClientHeight;
      HideControlBorder;
      Control.Height := AHeight;
    end
    else
      HideControlBorder;
  end;
end;

procedure TdxCustomLayoutControlAdapter.AfterCalculateViewInfo;
begin
  if Item.ControlOptions.AutoColor and Item.IsViewInfoValid then
    TControlAccess(Control).Color := Item.ViewInfo.Color;
end;

procedure TdxCustomLayoutControlAdapter.CombineRegion(const ARect: TRect);
begin
// do nothing
end;

procedure TdxCustomLayoutControlAdapter.SetControlAutoWidth(AValue: Boolean);
begin
// do nothing
end;

procedure TdxCustomLayoutControlAdapter.SetControlAutoHeight(AValue: Boolean);
begin
// do nothing
end;

procedure TdxCustomLayoutControlAdapter.InternalSetInitialSettings;
begin
// do nothing
end;

function TdxCustomLayoutControlAdapter.NeedBorder: Boolean;
begin
  Result := HasBorderProperty;
end;

function TdxCustomLayoutControlAdapter.HasBorderProperty: Boolean;
begin
  Result :=
    IsPublishedProp(Control, 'BorderStyle') and (GetPropInfo(Control, 'BorderStyle').PropType^ = TypeInfo(Forms.TBorderStyle));
end;

function TdxCustomLayoutControlAdapter.ShowItemCaption: Boolean;
begin
  Result := not IsPublishedProp(Control, 'Caption');
end;

function TdxCustomLayoutControlAdapter.UseItemColor: Boolean;
begin
  Result := TControlAccess(Control).ParentColor and IsPublishedProp(Control, 'Color');
end;

procedure TdxCustomLayoutControlAdapter.AfterInitialization;
begin
// do nothing
end;

procedure TdxCustomLayoutControlAdapter.BeforeInitialization;
begin
// do nothing
end;

procedure TdxCustomLayoutControlAdapter.SetInitialSettings;
var
  ALookAndFeelContainer: IcxLookAndFeelContainer;
begin
  InternalSetInitialSettings;
  if Supports(Control, IcxLookAndFeelContainer, ALookAndFeelContainer) then
  begin
    LayoutLookAndFeel.InitializeSubControlCxLookAndFeel(ALookAndFeelContainer.GetLookAndFeel);
  end;
end;

class procedure TdxCustomLayoutControlAdapter.Register(AControlClass: TControlClass);
begin
  dxLayoutControlAdapterDefs.Register(AControlClass, Self);
end;

class procedure TdxCustomLayoutControlAdapter.Unregister(AControlClass: TControlClass);
begin
  dxLayoutControlAdapterDefs.Unregister(AControlClass, Self);
end;

{ THitTests }

type
  THitTests = class
  private
    FItems: TList;
    function GetCount: Integer;
    function GetInstance(AClass: TdxCustomLayoutHitTestClass): TdxCustomLayoutHitTest;
    function GetItem(Index: Integer): TdxCustomLayoutHitTest;
  protected
    function GetObjectByClass(AClass: TdxCustomLayoutHitTestClass): TdxCustomLayoutHitTest;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TdxCustomLayoutHitTest read GetItem;
  public
    constructor Create;
    destructor Destroy; override;
    property Instances[AClass: TdxCustomLayoutHitTestClass]: TdxCustomLayoutHitTest read GetInstance; default;
  end;

var
  HitTests: THitTests;

constructor THitTests.Create;
begin
  inherited;
  FItems := TList.Create;
end;

destructor THitTests.Destroy;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].Free;
  FItems.Free;
  inherited;
end;

function THitTests.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function THitTests.GetInstance(AClass: TdxCustomLayoutHitTestClass): TdxCustomLayoutHitTest;
begin
  Result := GetObjectByClass(AClass);
  if Result = nil then
  begin
    Result := AClass.Create;
    FItems.Add(Result);
  end;
end;

function THitTests.GetItem(Index: Integer): TdxCustomLayoutHitTest;
begin
  Result := FItems.List[Index];
end;

function THitTests.GetObjectByClass(AClass: TdxCustomLayoutHitTestClass): TdxCustomLayoutHitTest;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    Result := Items[I];
    if Result.ClassType = AClass then Exit;
  end;
  Result := nil;
end;

{ TdxCustomLayoutHitTest }

function TdxCustomLayoutHitTest.CanDragAndDrop(AItem: TdxCustomLayoutItem; const P: TPoint): Boolean;
begin
  Result := (AItem <> nil) and (AItem.Container.IsCustomization or AItem.CanQuickDragAndDrop) and AItem.CanDragAndDrop(P);
end;

function TdxCustomLayoutHitTest.GetCursor: TCursor;
begin
  Result := crDefault;
end;

function TdxCustomLayoutHitTest.GetDropCursor: TCursor;
begin
  Result := crDefault;
end;

function TdxCustomLayoutHitTest.GetDragAndDropObjectClass: TcxDragAndDropObjectClass;
begin
  Result := TdxLayoutDragAndDropObject;
end;

function TdxCustomLayoutHitTest.HitTestCode: Integer;
begin
  Result := htError;
end;

class function TdxCustomLayoutHitTest.Instance: TdxCustomLayoutHitTest;
begin
  Result := HitTests.Instances[Self];
end;

function TdxCustomLayoutHitTest.IsDropAreaPartDetermined: Boolean;
begin
  Result := False;
end;

function TdxCustomLayoutHitTest.GetDropAreaPart: TdxLayoutDropAreaPart;
begin
  Result := apNone;
end;

function TdxCustomLayoutHitTest.GetGroupForInsert: TdxCustomLayoutGroup;
begin
  Result := nil;
end;

function TdxCustomLayoutHitTest.GetDestinationItem: TdxCustomLayoutItem;
begin
  Result := Item;
end;

function TdxCustomLayoutHitTest.GetSourceItem: TdxCustomLayoutItem;
begin
  Result := Item;
end;

{ TdxLayoutNoneHitTest }

function TdxLayoutNoneHitTest.HitTestCode: Integer;
begin
  Result := htNone;
end;

{ TdxLayoutBasicItemHitTest }

function TdxLayoutBasicItemHitTest.GetGroupForInsert: TdxCustomLayoutGroup;
begin
  Result := Item.Parent;
end;

function TdxLayoutBasicItemHitTest.GetItem: TdxLayoutBasicItem;
begin
  Result := TdxLayoutBasicItem(inherited Item);
end;

function TdxLayoutBasicItemHitTest.HitTestCode: Integer;
begin
  Result := htBasicItem;
end;

{ TdxLayoutItemHitTest }

function TdxLayoutItemHitTest.GetItem: TdxLayoutItem;
begin
  Result := TdxLayoutItem(inherited Item);
end;

function TdxLayoutItemHitTest.HitTestCode: Integer;
begin
  Result := htItem;
end;

{ TdxCustomLayoutGroupHitTest }

function TdxLayoutGroupHitTest.GetItem: TdxCustomLayoutGroup;
begin
  Result := (inherited Item).AsGroup;
end;

function TdxLayoutGroupHitTest.GetViewInfo: TdxLayoutGroupViewInfo;
begin
  Result := (inherited ViewInfo).AsGroupViewInfo;
end;

function TdxLayoutGroupHitTest.HitTestCode: Integer;
begin
  Result := htGroup;
end;

function TdxLayoutGroupHitTest.GetGroupForInsert: TdxCustomLayoutGroup;
begin
  Result := Item;
end;

{ TdxLayoutTabbedGroupHitTest }

function TdxLayoutTabbedGroupHitTest.GetDestinationItem: TdxCustomLayoutItem;
var
  AVisibleTabIndex: Integer;
begin
  if Specific.HasTabControl then
  begin
    AVisibleTabIndex := Specific.GetHitTabIndex(FPos);
    if AVisibleTabIndex <> -1 then
      Result := ViewInfo.ItemViewInfos[AVisibleTabIndex].Item
    else
      Result := inherited GetDestinationItem;
  end
  else
    Result := inherited GetDestinationItem;
end;

function TdxLayoutTabbedGroupHitTest.GetSourceItem: TdxCustomLayoutItem;
var
  AVisibleTabIndex: Integer;
begin
  if Specific.HasTabControl then
  begin
    AVisibleTabIndex := Specific.GetHitTabIndex(FPos);
    if AVisibleTabIndex <> -1 then
      Result := ViewInfo.ItemViewInfos[AVisibleTabIndex].Item
    else
      Result := inherited GetSourceItem;
  end
  else
    Result := inherited GetSourceItem;
end;

function TdxLayoutTabbedGroupHitTest.GetSpecific: TdxLayoutGroupViewInfoTabbedSpecific;
begin
  Result := TdxLayoutGroupViewInfoTabbedSpecific(ViewInfo.Specific);
end;

{ TdxLayoutFloatingRootHitTest }

function TdxLayoutFloatingRootHitTest.GetSourceItem: TdxCustomLayoutItem;
begin
  Result := (Item as TdxLayoutGroup).Items[0];
end;

{ TdxLayoutClientAreaHitTest }

function TdxLayoutClientAreaHitTest.HitTestCode: Integer;
begin
  Result := htClientArea;
end;

function TdxLayoutClientAreaHitTest.GetGroupForInsert: TdxCustomLayoutGroup;
begin
  Result := Container.Root;
end;

function TdxLayoutClientAreaHitTest.GetDestinationItem: TdxCustomLayoutItem;
begin
  Result := Container.Root;
end;

{ TdxLayoutSizeHitTest }

function TdxLayoutSizeHitTest.HitTestCode: Integer;
begin
  Result := htSizeHandle;
end;

function TdxLayoutSizeHitTest.GetCursor: TCursor;
begin
  Result := Cursor;
end;

function TdxLayoutSizeHitTest.GetDragAndDropObjectClass: TcxDragAndDropObjectClass;
begin
  Result := TdxLayoutSizingDragAndDropObject;
end;

{ TdxLayoutSplitterHitTest }

function TdxLayoutSplitterHitTest.CanDragAndDrop(AItem: TdxCustomLayoutItem; const P: TPoint): Boolean;
begin
  Result := not AItem.Container.IsCustomization;
end;

function TdxLayoutSplitterHitTest.HitTestCode: Integer;
begin
  Result := htBasicItem;
end;

function TdxLayoutSplitterHitTest.GetCursor: TCursor;
begin
  if (Item as TdxLayoutSplitterItem).IsVertical then
    Result := crHSplit
  else
    Result := crVSplit;
end;

function TdxLayoutSplitterHitTest.GetDragAndDropObjectClass: TcxDragAndDropObjectClass;
begin
  if (Item as TdxLayoutSplitterItem).IsVertical then
    Result := TdxLayoutHSplitterDragAndDropObject
  else
    Result := TdxLayoutVSplitterDragAndDropObject;
end;

{ TdxLayoutCustomizeFormHitTest }

function TdxLayoutCustomizeFormHitTest.GetDropCursor: TCursor;
begin
  case FHitTestArea of
    -1:
       Result :=  crdxLayoutControlDropBefore;
    0:
       Result := crdxLayoutControlDropInside;
    1:
      Result := crdxLayoutControlDropAfter;
  else
    Result := crDefault;
  end;
end;

function TdxLayoutCustomizeFormHitTest.HitTestCode: Integer;
begin
  Result := htCustomizeForm;
end;

function TdxLayoutCustomizeFormHitTest.IsDropAreaPartDetermined: Boolean;
begin
  Result := True;
end;

function TdxLayoutCustomizeFormHitTest.GetDropAreaPart: TdxLayoutDropAreaPart;
begin
  Result := DropAreaPart;
end;

function TdxLayoutCustomizeFormHitTest.GetDestinationItem: TdxCustomLayoutItem;
begin
  Result := Item;
end;

{ TdxLayoutCustomizeFormAvailableItemsHitTest }

function TdxLayoutCustomizeFormAvailableItemsHitTest.HitTestCode: Integer;
begin
  Result := htAvailableItems;
end;

{ TdxLayoutCustomizeFormTreeViewItemsHitTest }

function TdxLayoutCustomizeFormTreeViewItemsHitTest.HitTestCode: Integer;
begin
  Result := htTreeViewItems;
end;



initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  RegisterClasses([
    TdxLayoutContainer, TdxLayoutItem, TdxLayoutEmptySpaceItem, TdxLayoutLabeledItem, TdxLayoutSeparatorItem,
    TdxLayoutSplitterItem, TdxLayoutImageItem, TdxLayoutCheckBoxItem, TdxLayoutRadioButtonItem, TdxLayoutGroup,
    TdxLayoutAutoCreatedGroup, TdxLayoutAutoCreatedWrappingGroup, TdxLayoutAlignmentConstraint, TdxLayoutCheckBoxItem]);

  HitTests := THitTests.Create;

  dxLayoutRunTimeSelectionHelperClass := TdxLayoutRunTimeSelectionHelper;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  FreeAndNil(HatchBitmap);
  FreeAndNil(HitTests);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
