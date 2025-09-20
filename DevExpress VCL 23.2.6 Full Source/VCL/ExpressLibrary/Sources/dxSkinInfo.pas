{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           Express Cross Platform Library classes                   }
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

unit dxSkinInfo;

{$I cxVer.inc}

interface

uses
  UITypes,
  Types, Windows, Classes, Graphics, SysUtils, cxClasses, cxGraphics, cxLookAndFeels,
  cxGeometry, cxLookAndFeelPainters, dxSkinsCore, dxSkinsStrs, dxCoreClasses, dxCoreGraphics;

const
  dxSkinsSchedulerResourceColorsCount = 12;

type

  TdxSkinFormIcon = (sfiMenu, sfiHelp, sfiMinimize, sfiMaximize, sfiRestore, sfiClose);
  TdxSkinFormIcons = set of TdxSkinFormIcon;

  { TdxSkinScrollInfo }

  TdxSkinScrollInfo = class(TObject)
  private
    FElement: TdxSkinElement;
    FImageIndex: Integer;
  public
    constructor Create(AElement: TdxSkinElement; AImageIndex: Integer; APart: TcxScrollBarPart);
    function DrawScaled(DC: HDC; const R: TRect; AImageIndex: Integer; AState: TdxSkinElementState; AScaleFactor: TdxScaleFactor): Boolean; overload;
    function Draw(DC: HDC; const R: TRect; AImageIndex: Integer; AState: TdxSkinElementState): Boolean; overload; 
    function DrawScaled(DC: HDC; const R: TRect; AState: TdxSkinElementState; AScaleFactor: TdxScaleFactor): Boolean; overload;
    function Draw(DC: HDC; const R: TRect; AState: TdxSkinElementState): Boolean; overload; 

    property Element: TdxSkinElement read FElement;
    property ImageIndex: Integer read FImageIndex;
  end;

  { TdxSkinElementHelper }

  TdxSkinElementHelper = class
  public
    class function CalculateCaptionButtonSize(ACaptionHeight: Integer; AElement: TdxSkinElement): TSize;
    class function IsAlternateImageSetUsed(AElement: TdxSkinElement; AImageIndex: Integer; AState: TdxSkinElementState): Boolean;
  end;

  { TdxSkinInfo }

  TdxSkinInfo = class(TcxIUnknownObject, IdxSkinChangeListener, IdxSkinInfo)
  private
    FSkin: TdxSkin;
    function GetIsAdvanced: Boolean;
    procedure MarkObjectUsed(AObject: TdxSkinCustomObject);
    procedure SetSkin(ASkin: TdxSkin);
  protected
    GroupBars: TdxSkinControlGroup;
    GroupCommon: TdxSkinControlGroup;
    GroupDocking: TdxSkinControlGroup;
    GroupEditors: TdxSkinControlGroup;
    GroupForm: TdxSkinControlGroup;
    GroupGantt: TdxSkinControlGroup;
    GroupGrid: TdxSkinControlGroup;
    GroupHamburgerMenu: TdxSkinControlGroup;
    GroupListView: TdxSkinControlGroup;
    GroupMapControl: TdxSkinControlGroup;
    GroupNavBar: TdxSkinControlGroup;
    GroupNavPane: TdxSkinControlGroup;
    GroupPDFViewer: TdxSkinControlGroup;
    GroupPrintingSystem: TdxSkinControlGroup;
    GroupRibbon: TdxSkinControlGroup;
    GroupRichEdit: TdxSkinControlGroup;
    GroupScheduler: TdxSkinControlGroup;
    GroupTabs: TdxSkinControlGroup;
    GroupTileControl: TdxSkinControlGroup;
    GroupVGrid: TdxSkinControlGroup;
    //
    CardViewSeparator: TdxSkinElement;
    CheckboxElement: TdxSkinElement;
    ClockElements: array[Boolean] of TdxSkinElement;
    EditButtonElements: array [Boolean] of TdxSkinElement;
    EditButtonGlyphs: array [TcxEditBtnKind] of TdxSkinElement;
    EditButtonMergeBorders: Boolean;
    EditButtonSearchGlyph: TdxSkinElement;
    GridFixedColumnHighlightColor: TdxSkinAlphaColor;
    GridFixedLine: TdxSkinElement;
    GridGroupByBox: TdxSkinElement;
    GridGroupByBoxLineColor: TdxSkinColor;
    GridGroupRow: TdxSkinElement;
    GridGroupRowStyleOffice11ContentColor: TdxSkinColor;
    GridGroupRowStyleOffice11SeparatorColor: TdxSkinColor;
    GridGroupRowStyleOffice11TextColor: TdxSkinColor;
    GridCell: TdxSkinElement;
    GridLine: TdxSkinElement;
    GridWinExplorerViewGroup: TdxSkinElement;
    GridWinExplorerViewGroupCaptionLine: TdxSkinElement;
    GridWinExplorerViewGroupExpandButton: TdxSkinElement;
    GridWinExplorerViewRecord: TdxSkinElement;
    IndicatorImages: TdxSkinElement;
    NavigatorButton: TdxSkinElement;
    NavigatorGlyphs: TdxSkinElement;
    NavigatorGlyphsVert: TdxSkinElement;
    NavigatorInfoPanel: TdxSkinElement;
    RadioGroupButton: TdxSkinElement;
    RangeTrackBarThumbBoth: TdxSkinElement;
    RangeTrackBarThumbLeft: TdxSkinElement;
    RangeTrackBarThumbRight: TdxSkinElement;
    RatingIndicator: TdxSkinElement;
    Splitter: array[Boolean] of TdxSkinElement;
    TrackBarThumb: array[Boolean, TcxTrackBarTicksAlign] of TdxSkinElement;
    TrackBarTextColor: TdxSkinColor;
    TrackBarTickColor: TdxSkinColor;
    TrackBarTrack: array[Boolean] of TdxSkinElement;
    VGridCategory: TdxSkinElement;
    VGridContentColor: TdxSkinColor;
    VGridLine: array[Boolean] of TdxSkinElement;
    VGridRowHeader: TdxSkinElement;
    // Colors
    CalcEditButtonTextColors: array[TcxCalcButtonKind] of TdxSkinColor;
    ContentEvenColor: TdxSkinColor;
    ContentOddColor: TdxSkinColor;
    ContentTextColor: TdxSkinColor;
    HeaderBackgroundColor: TdxSkinColor;
    HeaderBackgroundTextColor: TdxSkinColor;
    SelectionColor: TdxSkinColor;
    SelectionTextColor: TdxSkinColor;
    SearchResultHighlightColor: TdxSkinColor;
    SearchResultHighlightTextColor: TdxSkinColor;
    TreeListGridLineColor: TdxSkinColor;
    TreeListTreeLineColor: TdxSkinColor;
    // ExpandButton
    ExpandButton: TdxSkinElement;
    // Footer
    FooterCell: TdxSkinElement;
    FooterPanel: TdxSkinElement;
    // header
    Header: TdxSkinElement;
    HeaderSpecial: TdxSkinElement;
    SortGlyphs: TdxSkinElement;
    // filter
    FilterButtons: array[Boolean] of TdxSkinElement;
    FilterPanel: TdxSkinElement;
    SmartFilterButton: TdxSkinElement;

    function CreateBlankElement(AGroup: TdxSkinControlGroup; const AName: string): TdxSkinElement;
    function CreateBlankGroup(const AName: string): TdxSkinControlGroup;
    function GetAlphaColorValueByName(AElement: TdxSkinPersistent; const AName: string): TdxAlphaColor;
    function GetBoolPropertyByName(AElement: TdxSkinPersistent; const AName: string): TdxSkinBooleanProperty;
    function GetColorByName(AElement: TdxSkinPersistent; const AName: string): TdxSkinColor; overload;
    function GetColorByName(const AName: string): TdxSkinColor; overload;
    function GetColorValueByName(AElement: TdxSkinPersistent; const AName: string): TColor;
    function GetElementByName(AGroup: TdxSkinControlGroup; const AName: string; ACreateIfAbsent: Boolean = True): TdxSkinElement;
    function GetFormFrameElementByName(AGroup: TdxSkinControlGroup; const AName: string; ACreateIfAbsent: Boolean = True): TdxSkinElement;
    function GetGroupByName(const AName: string): TdxSkinControlGroup;
    function GetIntegerPropertyByName(AElement: TdxSkinPersistent; const AName: string): TdxSkinIntegerProperty;
    function GetPropertyByName(AElement: TdxSkinPersistent; const AName: string): TdxSkinProperty;
    function GetRectPropertyByName(AElement: TdxSkinPersistent; const AName: string): TdxSkinRectProperty;

    procedure FinalizeScrollBarElements;
    procedure Initialize; virtual;
    procedure InitializeAlertWindowElements;
    procedure InitializeBarElements;
    procedure InitializeBreadcrumbEditElements;
    procedure InitializeButtonElements;
    procedure InitializeCalcEditColors;
    procedure InitializeCalendarElements;
    procedure InitializeCheckboxElements;
    procedure InitializeClockElements;
    procedure InitializeColors;
    procedure InitializeDataRowLayoutElements;
    procedure InitializeDockControlElements;
    procedure InitializeEditorsElements;
    procedure InitializeFilterElements;
    procedure InitializeFilterVisualCriteriaElements;
    procedure InitializeFooterElements;
    procedure InitializeFormElements;
    procedure InitializeGalleryElements;
    procedure InitializeGanttElements;
    procedure InitializeGaugeElements;
    procedure InitializeGridElements;
    procedure InitializeGroupBoxElements;
    procedure InitializeGroups;
    procedure InitializeHamburgerMenuElements;
    procedure InitializeHeaderElements;
    procedure InitializeIndicatorImages;
    procedure InitializeLayoutViewElements;
    procedure InitializeListBoxElements;
    procedure InitializeListViewElements;
    procedure InitializeMapControlElements;
    procedure InitializeNavBarElements;
    procedure InitializeNavigatorElements;
    procedure InitializePageControlElements;
    procedure InitializePDFViewerElements;
    procedure InitializePrintingSystemElements;
    procedure InitializeProgressBarElements;
    procedure InitializeRadioGroupElements;
    procedure InitializeRangeControlElements;
    procedure InitializeRibbonColors;
    procedure InitializeRibbonElements;
    procedure InitializeRibbonProperties;
    procedure InitializeRichEditElements;
    procedure InitializeSchedulerElements;
    procedure InitializeScrollBarElements;
    procedure InitializeSizeGripElements;
    procedure InitializeSplitterElements;
    procedure InitializeTileControlElements;
    procedure InitializeToggleSwitchElements;
    procedure InitializeToolTipElements;
    procedure InitializeTrackBarElements;

    procedure FinalizeSkinInfo; virtual;
    procedure InitializeSkinInfo; virtual;
    procedure InitializeSkinProperties;

    procedure SetUseCache(AElement: TdxSkinElement; ACapacity: Integer = -1);

    // IdxSkinInfo
    function GetSkin: TdxSkin;
    // IdxSkinChangeListener
    procedure SkinChanged(Sender: TdxSkin); virtual;
  public
    // for WXI
    Breadcrumb: TdxSkinElement;
    EditorBackground: TdxSkinElement;
    EditorComboButton: TdxSkinElement;
    DefaultGridIndicatorWidth: TdxSkinIntegerProperty;
    HighlightedItem: TdxSkinElement;
    ListBoxBackground: TdxSkinElement;
    PictureEditBackground: TdxSkinElement;
    TokenEdit: TdxSkinElement;
    TokenEditBackground: TdxSkinElement;
    TokenEditCloseButton: TdxSkinElement;
    TokenEditCloseButtonSelected: TdxSkinElement;
    PopupFormBorder: TdxSkinElement;
    FormDecoratorFrameBottom: TdxSkinElement;
    FormDecoratorFrameLeft: TdxSkinElement;
    FormDecoratorFrameRight: TdxSkinElement;
    FormDecoratorFrameTop: TdxSkinElement;
    ApplyEditorAdvancedMode: TdxSkinBooleanProperty;
    SupportsNativeFocusRect: TdxSkinBooleanProperty;

    // Button
    BackButton: TdxSkinElement;
    ButtonParts: array[TcxButtonPart] of TdxSkinElement;
    ClearButton: TdxSkinElement;
    // Colors
    ContainerBorderColor: TdxSkinColor;
    ContainerHighlightBorderColor: TdxSkinColor;
    ContentColor: TdxSkinColor;
    EditorBackgroundColors: array[TcxEditStateColorKind] of TdxSkinColor;
    EditorTextColors: array[TcxEditStateColorKind] of TdxSkinColor;
    HyperLinkTextColor: TdxSkinColor;
    InactiveColor: TdxSkinColor;
    InactiveTextColor: TdxSkinColor;
    SpreadSheetContentColor: TdxSkinColor;
    SpreadSheetContentTextColor: TdxSkinColor;
    SpreadSheetFrozenPaneSeparatorColor: TdxSkinColor;
    SpreadSheetGroupLineColor: TdxSkinColor;
    SpreadSheetSelectionColor: TdxSkinColor;
    GridLikeControlContentColor: TdxSkinColor;
    GridLikeControlContentEvenColor: TdxSkinColor;
    GridLikeControlContentOddColor: TdxSkinColor;
    GridLikeControlContentTextColor: TdxSkinColor;
    GridLikeControlBackgroundColor: TdxSkinColor;
    // Common colors
    CriticalColor: TdxSkinColor;
    HotTrackedColor: TdxSkinColor;
    HotTrackedTextColor: TdxSkinColor;
    InformationColor: TdxSkinColor;
    QuestionColor: TdxSkinColor;
    // ProgressBar
    ProgressBarParts: array[Boolean, TcxProgressBarPart] of TdxSkinElement;
    // ScrollBars
    ScrollBar_Elements: array[Boolean, TcxScrollBarPart] of TdxSkinScrollInfo;
    // Label
    LabelLine: array[Boolean] of TdxSkinElement;
    // Bevel
    BevelShapeColor1: TdxSkinColor;
    BevelShapeColor2: TdxSkinColor;
    // AlertWindow
    AlertWindow: TdxSkinElement;
    AlertWindowButton: TdxSkinElement;
    AlertWindowButtonGlyphs: TdxSkinElement;
    AlertWindowCaption: TdxSkinElement;
    AlertWindowCornerRadius: Integer;
    AlertWindowNavigationPanel: TdxSkinElement;
    AlertWindowNavigationPanelButton: TdxSkinElement;
    // BreadcrumbEdit
    BreadcrumbEditBackgroundColors: array[TdxBreadcrumbEditState] of TdxSkinColor;
    BreadcrumbEditBordersColors: array[TdxBreadcrumbEditState] of TdxSkinColor;
    BreadcrumbEditButton: TdxSkinElement;
    BreadcrumbEditButtonMergeBorders: Boolean;
    BreadcrumbEditButtonsAreaSeparator: TdxSkinElement;
    BreadcrumbEditDropDownButton: TdxSkinElement;
    BreadcrumbEditNodeButton: TdxSkinElement;
    BreadcrumbEditNodeSplitButtonLeft: TdxSkinElement;
    BreadcrumbEditNodeSplitButtonRight: TdxSkinElement;
    BreadcrumbEditProgressChunk: TdxSkinElement;
    BreadcrumbEditProgressChunkOverlay: TdxSkinElement;
    BreadcrumbEditProgressChunkPadding: TdxSkinRectProperty;
    // GroupBox
    GroupBoxCaptionElements: array[TcxGroupBoxCaptionPosition] of TdxSkinElement;
    GroupBoxCaptionTailSizes: array[TcxGroupBoxCaptionPosition] of TdxSkinIntegerProperty;
    GroupBoxCaptionTextPadding: array[TcxGroupBoxCaptionPosition] of TdxSkinIntegerProperty;
    GroupBoxClient: TdxSkinElement;
    GroupBoxElements: array[TcxGroupBoxCaptionPosition] of TdxSkinElement;
    GroupButton: TdxSkinElement;
    GroupButtonExpandGlyph: TdxSkinElement;
    GroupSearchButton: TdxSkinElement;

    // DockControl
    DockControlBorder: TdxSkinElement;
    DockControlCaption: TdxSkinElement;
    DockControlCaptionNonFocusedTextColor: TColor;
    DockControlHideBar: TdxSkinElement;
    DockControlHideBarLeft: TdxSkinElement;
    DockControlHideBarRight: TdxSkinElement;
    DockControlHideBarBottom: TdxSkinElement;
    DockControlHideBarButtons: TdxSkinElement;
    DockControlHideBarTextColor: array[Boolean] of TdxSkinColor;
    DockControlIndents: array[0..2] of Integer;
    DockControlTabHeader: TdxSkinElement;
    DockControlTabButtonHorz: TdxSkinElement;
    DockControlTabButtonVert: TdxSkinElement;
    DockControlTabHeaderBackground: TdxSkinElement;
    DockControlTabHeaderCloseButton: TdxSkinElement;
    DockControlTabHeaderLine: TdxSkinElement;
    DockControlTabTextColor: TdxSkinColor;
    DockControlTabTextColorHot: TdxSkinColor;
    DockControlTabTextColorActive: TdxSkinColor;
    DockControlTabTextColorActiveHot: TdxSkinColor;
    DockControlTabTextColorDisabled: TdxSkinColor;
    DockControlWindowButton: TdxSkinElement;
    DockControlWindowButtonGlyphs: TdxSkinElement;
    DockSiteContentColor: TdxSkinColor;
    // Layout
    LayoutControlColor: TdxSkinColor;

    // LayoutView
    LayoutViewElementPadding: array[TcxLayoutElement] of TdxSkinRectProperty;
    LayoutViewElementSpacing: array[TcxLayoutElement] of TdxSkinRectProperty;
    LayoutViewItem: TdxSkinElement;
    LayoutViewRecordCaptionElements: array[TcxGroupBoxCaptionPosition] of TdxSkinElement;
    LayoutViewRecordCaptionTailSizes: array[TcxGroupBoxCaptionPosition] of TdxSkinIntegerProperty;
    LayoutViewRecordCaptionTextPadding: array[TcxGroupBoxCaptionPosition] of TdxSkinIntegerProperty;
    LayoutViewRecordElements: array[TcxGroupBoxCaptionPosition] of TdxSkinElement;
    LayoutViewRecordExpandButton: TdxSkinElement;

    // PageControl
    PageControlButton: TdxSkinElement;
    PageControlButtonHorz: TdxSkinElement;
    PageControlButtonVert: TdxSkinElement;
    PageControlCloseButton: TdxSkinElement;
    PageControlHeader: TdxSkinElement;
    PageControlHeaderButton: TdxSkinElement;
    PageControlIndents: array[0..7] of Integer;
    PageControlPane: TdxSkinElement;
    TabTextColor: TdxSkinColor;
    TabTextColorActive: TdxSkinColor;
    TabTextColorActiveHot: TdxSkinColor;
    TabTextColorDisabled: TdxSkinColor;
    TabTextColorHot: TdxSkinColor;

    // NavBar
    NavBarBackgroundColor: TdxSkinElement;
    NavBarGroupButtons: array [Boolean] of TdxSkinElement;
    NavBarGroupClient: TdxSkinElement;
    NavBarGroupHeader: TdxSkinElement;
    NavBarItem: TdxSkinElement;

    // NavBar - Accordion Control
    NavBarAccordionControlBackground: TdxSkinElement;
    NavBarAccordionControlChildItemOffset: TdxSkinIntegerProperty;
    NavBarAccordionControlContentContainerPadding: TdxSkinRectProperty;
    NavBarAccordionControlDistanceBetweenRootGroups: TdxSkinIntegerProperty;
    NavBarAccordionControlGroup: TdxSkinElement;
    NavBarAccordionControlGroupCloseButton: TdxSkinElement;
    NavBarAccordionControlGroupOpenButton: TdxSkinElement;
    NavBarAccordionControlItem: TdxSkinElement;
    NavBarAccordionControlRootGroup: TdxSkinElement;
    NavBarAccordionControlRootGroupCloseButton: TdxSkinElement;
    NavBarAccordionControlRootGroupOpenButton: TdxSkinElement;
    NavBarAccordionControlSearchButton: TdxSkinElement;
    NavBarAccordionControlSearchButtonGlyphToTextIndent: TdxSkinIntegerProperty;

    // HamburgerMenu
    HamburgerMenuBackground: TdxSkinElement;
    HamburgerMenuHamburgerButton: TdxSkinElement;
    HamburgerMenuChildGroup: TdxSkinElement;
    HamburgerMenuChildGroupCloseButton: TdxSkinElement;
    HamburgerMenuChildGroupOpenButton: TdxSkinElement;
    HamburgerMenuChildItemOffset: TdxSkinIntegerProperty;
    HamburgerMenuDistanceBetweenGroups: TdxSkinIntegerProperty;
    HamburgerMenuGroup: TdxSkinElement;
    HamburgerMenuGroupCloseButton: TdxSkinElement;
    HamburgerMenuGroupOpenButton: TdxSkinElement;
    HamburgerMenuItem: TdxSkinElement;
    HamburgerMenuNavPaneBackground: TdxSkinElement;
    HamburgerMenuNavPaneExpandButton: TdxSkinElement;
    HamburgerMenuNavPaneItem: TdxSkinElement;
    HamburgerMenuScrollDownButton: TdxSkinElement;
    HamburgerMenuScrollUpButton: TdxSkinElement;

    // NavPane
    NavPaneCaptionFontSize: TdxSkinIntegerProperty;
    NavPaneCaptionHeight: TdxSkinIntegerProperty;
    NavPaneCollapseButton: TdxSkinElement;
    NavPaneCollapsedGroupClient: TdxSkinElement;
    NavPaneExpandButton: TdxSkinElement;
    NavPaneFormBorder: TdxSkinElement;
    NavPaneFormSizeGrip: TdxSkinElement;
    NavPaneGroupButton: array[Boolean] of TdxSkinElement;
    NavPaneGroupCaption: TdxSkinElement;
    NavPaneGroupClient: TdxSkinElement;
    NavPaneItem: TdxSkinElement;
    NavPaneOfficeNavigationBar: TdxSkinElement;
    NavPaneOfficeNavigationBarItem: TdxSkinElement;
    NavPaneOfficeNavigationBarItemFontDelta: Integer;
    NavPaneOfficeNavigationBarSkinningItem: TdxSkinElement;
    NavPaneOfficeNavigationBarSkinningItemFontDelta: Integer;
    NavPaneOffsetGroupBorders: TdxSkinBooleanProperty;
    NavPaneOverflowPanel: TdxSkinElement;
    NavPaneOverflowPanelExpandedItem: TdxSkinElement;
    NavPaneOverflowPanelItem: TdxSkinElement;
    NavPaneScrollButtons: array[Boolean] of TdxSkinElement;
    NavPaneSelectedItem: TdxSkinElement;
    NavPaneSplitter: TdxSkinElement;

    // Form
    FormCaptionFontDelta: Integer;
    FormCaptionFontIsBold: TdxSkinBooleanProperty;
    FormContent: TdxSkinElement;
    FormFrames: array[Boolean, TcxBorder] of TdxSkinElement;
    FormIcons: array[Boolean, TdxSkinFormIcon] of TdxSkinElement;
    FormInactiveColor: TdxSkinColor;
    FormStatusBar: TdxSkinElement;
    FormSupportsNavigationControlExtensionToFormCaption: TdxSkinBooleanProperty;
    FormTextShadowColor: TdxSkinColor;
    SizeGrip: TdxSkinElement;

    // Scheduler
    SchedulerAllDayArea: array[Boolean] of TdxSkinElement;
    SchedulerAppointment: array[Boolean] of TdxSkinElement;
    SchedulerAppointmentBorder: TdxSkinColor;
    SchedulerAppointmentBorderSize: TdxSkinIntegerProperty;
    SchedulerAppointmentMask: TdxSkinElement;
    SchedulerAppointmentShadow: array[Boolean] of TdxSkinElement;
    SchedulerCurrentTimeIndicator: TdxSkinElement;
    SchedulerGroup: TdxSkinElement;
    SchedulerMilestone: TdxSkinElement;
    SchedulerLabelCircle: TdxSkinElement;
    SchedulerMoreButton: TdxSkinElement;
    SchedulerNavigationButtons: array[Boolean] of TdxSkinElement;
    SchedulerNavigationButtonsArrow: array[Boolean] of TdxSkinElement;
    SchedulerNavigatorColor: TdxSkinColor;
    SchedulerResourceColors: array[0..dxSkinsSchedulerResourceColorsCount - 1] of TdxSkinColor;
    SchedulerTaskExpandButton: TdxSkinElement;
    SchedulerTimeGridCurrentTimeIndicator: TdxSkinElement;
    SchedulerTimeGridHeader: array[Boolean] of TdxSkinElement;
    SchedulerTimeLine: TdxSkinElement;
    SchedulerTimeRuler: TdxSkinElement;

    // Bars
    Bar: TdxSkinElement;
    BarCustomize: TdxSkinElement;
    BarCustomizeVertical: TdxSkinElement;
    BarDisabledTextColor: TdxSkinColor;
    BarDrag: TdxSkinElement;
    BarDragVertical: TdxSkinElement;
    BarMDIButtonClose: TdxSkinElement;
    BarMDIButtonMinimize: TdxSkinElement;
    BarMDIButtonRestore: TdxSkinElement;
    BarSeparator: TdxSkinElement;
    BarSubItemArrow: TdxSkinElement;
    BarVertical: TdxSkinElement;
    BarVerticalSeparator: TdxSkinElement;
    Dock: TdxSkinElement;
    FloatingBar: TdxSkinElement;
    ItemSeparator: TdxSkinElement;
    LinkBorderPainter: TdxSkinElement;
    LinkSelected: TdxSkinElement;
    MainMenu: TdxSkinElement;
    MainMenuCustomize: TdxSkinElement;
    MainMenuDrag: TdxSkinElement;
    MainMenuLinkSelected: TdxSkinElement;
    MainMenuVertical: TdxSkinElement;
    PopupMenu: TdxSkinElement;
    PopupMenuCheck: TdxSkinElement;
    PopupMenuExpandButton: TdxSkinElement;
    PopupMenuLinkArrow: TdxSkinElement;
    PopupMenuLinkSelected: TdxSkinElement;
    PopupMenuSeparator: TdxSkinElement;
    PopupMenuSideStrip: TdxSkinElement;
    PopupMenuSideStripNonRecent: TdxSkinElement;
    PopupMenuSplitButton: TdxSkinElement;
    PopupMenuSplitButton2: TdxSkinElement;
    ScreenTipItem: TdxSkinColor;
    ScreenTipTitleItem: TdxSkinColor;
    ScreenTipWindow: TdxSkinElement;
    ScreenTipSeparator: TdxSkinElement;

    // Ribbon
    RadialMenuBackgroundColor: TdxSkinColor;
    RadialMenuBaseColor: TdxSkinColor;
    RibbonApplicationBackground: TdxSkinElement;
    RibbonApplicationButton: TdxSkinElement;
    RibbonApplicationButton2010: TdxSkinElement;
    RibbonApplicationFooterBackground: TdxSkinElement;
    RibbonApplicationHeaderBackground: TdxSkinElement;
    RibbonBackstageView: TdxSkinElement;
    RibbonBackstageViewBackButton: TdxSkinElement;
    RibbonBackstageViewImage: TdxSkinElement;
    RibbonBackstageViewMenu: TdxSkinElement;
    RibbonBackstageViewMenuButton: TdxSkinElement;
    RibbonBackstageViewMenuHeader: TdxSkinElement;
    RibbonBackstageViewMenuSeparator: TdxSkinElement;
    RibbonBackstageViewTab: TdxSkinElement;
    RibbonBackstageViewTabArrow: TdxSkinElement;
    RibbonButtonArrow: TdxSkinElement;
    RibbonButtonGroup: TdxSkinElement;
    RibbonButtonGroupButton: TdxSkinElement;
    RibbonButtonGroupSeparator: TdxSkinElement;
    RibbonButtonGroupSplitButtonLeft: TdxSkinElement;
    RibbonButtonGroupSplitButtonRight: TdxSkinElement;
    RibbonButtonDisabledTextColor: TColor;
    RibbonCaptionFontDelta: TdxSkinIntegerProperty;
    RibbonCaptionText: array[Boolean] of TColor;
    RibbonCollapsedToolBarBackground: TdxSkinElement;
    RibbonCollapsedToolBarGlyphBackground: TdxSkinElement;
    RibbonContextualTabHeader: TdxSkinElement;
    RibbonContextualTabHeaderText: array[Boolean] of TColor;
    RibbonContextualTabHeaderTextHot: TColor;
    RibbonContextualTabLabel: TdxSkinElement;
    RibbonContextualTabLabelOnGlass: TdxSkinElement;
    RibbonContextualTabLabelOnGlassShadowColor: TdxSkinColor;
    RibbonContextualTabLabelShadowColor: TdxSkinColor;
    RibbonContextualTabPanel: TdxSkinElement;
    RibbonContextualTabPanelWithQATBelow: TdxSkinElement;
    RibbonContextualTabSeparator: TdxSkinElement;
    RibbonDocumentNameTextColor: array[Boolean] of TColor;
    RibbonEditorBackground: TdxSkinColor;
    RibbonExtraPaneButton: TdxSkinElement;
    RibbonExtraPaneColor: TdxSkinColor;
    RibbonExtraPaneHeaderSeparator: TdxSkinColor;
    RibbonExtraPanePinButtonGlyph: TdxSkinElement;
    RibbonFormBottom: array[Boolean] of TdxSkinElement;
    RibbonFormButtonAutoHideModeShowUI: TdxSkinElement;
    RibbonFormButtonClose: TdxSkinElement;
    RibbonFormButtonDisplayOptions: TdxSkinElement;
    RibbonFormButtonHelp: TdxSkinElement;
    RibbonFormButtonMaximize: TdxSkinElement;
    RibbonFormButtonMinimize: TdxSkinElement;
    RibbonFormButtonRestore: TdxSkinElement;
    RibbonFormCaption: TdxSkinElement;
    RibbonFormCaptionRibbonHidden: TdxSkinElement;
    RibbonFormContent: TdxSkinElement;
    RibbonFormLeft: array[Boolean] of TdxSkinElement;
    RibbonFormRight: array[Boolean] of TdxSkinElement;
    RibbonGroupScroll: array[Boolean] of TdxSkinElement;
    RibbonHeaderBackground: TdxSkinElement;
    RibbonHeaderBackgroundOnGlass: TdxSkinElement;
    RibbonKeyTip: TdxSkinElement;
    RibbonLargeButton: TdxSkinElement;
    RibbonLargeSplitButtonBottom: TdxSkinElement;
    RibbonLargeSplitButtonTop: TdxSkinElement;
    RibbonMinimizeButtonGlyph: TdxSkinElement;
    RibbonQATCustomizeButtonOutsizeQAT: array[TdxQATPosition] of TdxSkinBooleanProperty;
    RibbonQATIndentBeforeCustomizeButton: array[TdxQATPosition] of TdxSkinIntegerProperty;
    RibbonQuickToolbar: array[TdxQATPosition] of TdxSkinElement;
    RibbonQuickToolbarSingle: TdxSkinElement;
    RibbonQuickToolbarButton: array[TdxQATPosition] of TdxSkinElement;
    RibbonQuickToolbarButtonGlyph: array[TdxQATPosition] of TdxSkinElement;  
    RibbonQuickToolbarButtonGlyphDefault: TdxSkinElement;
    RibbonQuickToolbarButtonArrow: array[TdxQATPosition] of TdxSkinElement;  
    RibbonQuickToolbarDropDown: TdxSkinElement;
    RibbonQuickToolbarGlyph: array[TdxQATPosition] of TdxSkinElement;        
    RibbonQuickToolbarGlyphDefault: TdxSkinElement;
    RibbonSmallButton: TdxSkinElement;
    RibbonSpaceBetweenTabGroups: TdxSkinIntegerProperty;
    RibbonSplitButtonLeft: TdxSkinElement;
    RibbonSplitButtonRight: TdxSkinElement;
    RibbonStatusBarBackground: TdxSkinElement;
    RibbonStatusBarButton: TdxSkinElement;
    RibbonStatusBarSeparator: TdxSkinElement;
    RibbonStatusBarTextSelected: TColor;
    RibbonTab: TdxSkinElement;
    RibbonTabAeroSupport: TdxSkinBooleanProperty;
    RibbonTabGroup: TdxSkinElement;
    RibbonTabGroupHeader: TdxSkinElement;
    RibbonTabGroupItemsSeparator: TdxSkinElement;
    RibbonTabHeaderDownGrowIndent: TdxSkinIntegerProperty;
    RibbonTabPanel: TdxSkinElement;
    RibbonTabPanelWithQATBelow: TdxSkinElement;
    RibbonTabPanelBottomIndent: TdxSkinIntegerProperty;
    RibbonTabPanelGroupButton: TdxSkinElement;
    RibbonTabPanelHorizontalMargin: TdxSkinRectProperty;

    RibbonTabSeparatorLine: TdxSkinElement;
    RibbonTabText: array[Boolean] of TColor;
    RibbonTabTextHot: TColor;
    RibbonUseRoundedWindowCorners: TdxSkinBooleanProperty;

    // RichEdit
    RichEditCornerPanel: TdxSkinElement;
    RichEditRulerBackgroundHorz: TdxSkinElement;
    RichEditRulerBackgroundVert: TdxSkinElement;
    RichEditRulerColumnResizer: TdxSkinElement;
    RichEditRulerDefaultTabColor: TdxSkinColor;
    RichEditRulerIndent: TdxSkinElement;
    RichEditRulerIndentBottom: TdxSkinElement;
    RichEditRulerRightMargin: TdxSkinElement;
    RichEditRulerSection: TdxSkinElement;
    RichEditRulerTab: TdxSkinElement;
    RichEditRulerTabTypeBackground: TdxSkinElement;
    RichEditRulerTextColor: TdxSkinColor;

    // Calendar
    CalendarDayTextColor: TdxSkinColor;
    CalendarHolidayTextColor: TdxSkinColor;
    CalendarInactiveDayTextColor: TdxSkinColor;
    CalendarNavigationButton: TdxSkinElement;
    CalendarSelectedDayColor: TdxSkinColor;
    CalendarSelectedDayTextColor: TdxSkinColor;
    CalendarSeparatorColor: TdxSkinColor;
    CalendarTodayFrameColor: TdxSkinColor;
    CalendarTodayTextColor: TdxSkinColor;
    CalendarWeekendDayTextColor: TdxSkinColor;

    // Printing System
    PrintingPageBorder: TdxSkinElement;
    PrintingPreviewBackground: TdxSkinElement;

    // Gallery (Editors)
    StandaloneGalleryBackground: TdxSkinElement;
    StandaloneGalleryGroupHeader: TdxSkinElement;
    StandaloneGalleryItem: TdxSkinElement;
    StandaloneGalleryItemImage: TdxSkinElement;

    // Gallery (Ribbon - Tabs)
    RibbonGalleryBackground: TdxSkinElement;
    RibbonGalleryButtonDown: TdxSkinElement;
    RibbonGalleryButtonDropDown: TdxSkinElement;
    RibbonGalleryButtonUp: TdxSkinElement;
    RibbonGalleryItem: TdxSkinElement;
    RibbonGalleryItemImage: TdxSkinElement;

    // Gallery (Ribbon - Menu)
    DropDownGalleryBackground: TdxSkinElement;
    DropDownGalleryFilterPanel: TdxSkinElement;
    DropDownGalleryGroupHeader: TdxSkinElement;
    DropDownGalleryItem: TdxSkinElement;
    DropDownGalleryItemCaption: TdxSkinElement;
    DropDownGalleryItemDescription: TdxSkinElement;
    DropDownGalleryItemImage: TdxSkinElement;
    DropDownGallerySizeGrips: TdxSkinElement;
    DropDownGallerySizingPanel: TdxSkinElement;

    // Gauge
    GaugeBackground: TdxSkinElement;

    // ToggleSwitch
    ToggleSwitch: TdxSkinElement;
    ToggleSwitchTextMargin: TdxSkinIntegerProperty;
    ToggleSwitchThumb: TdxSkinElement;

    // Zoom
    ZoomInButton: TdxSkinElement;
    ZoomOutButton: TdxSkinElement;

    // Slider
    SliderArrow: array[TcxArrowDirection] of TdxSkinElement;

    // TileControl
    TileControlActionBar: TdxSkinElement;
    TileControlBackground: TdxSkinElement;
    TileControlItem: TdxSkinElement;
    TileControlItemCheck: TdxSkinElement;
    TileControlGroupCaption: TdxSkinElement;
    TileControlGroupCaptionFontDelta: Integer;
    TileControlSelectionFocusedColor: TColor;
    TileControlSelectionHotColor: TColor;
    TileControlTabHeader: TdxSkinElement;
    TileControlTabHeaderFontDelta: Integer;
    TileControlTitle: TdxSkinElement;
    TileControlTitleFontDelta: Integer;
    TileControlVirtualGroup: TdxSkinElement;

    // MapControl
    MapControlBackColor: TColor;
    MapControlCallout: TdxSkinElement;
    MapControlCalloutPointer: TPoint;
    MapControlCalloutPointerHeight: Integer;
    MapControlCalloutTextGlowColor: TdxAlphaColor;
    MapControlCustomElement: TdxSkinElement;
    MapControlCustomElementTextGlowColor: TdxAlphaColor;
    MapControlPanelBackColor: TdxAlphaColor;
    MapControlPanelHotTrackedTextColor: TdxAlphaColor;
    MapControlPanelPressedTextColor: TdxAlphaColor;
    MapControlPanelTextColor: TdxAlphaColor;
    MapControlPushpin: TdxSkinElement;
    MapControlPushpinTextOrigin: TPoint;
    MapControlPushpinTextGlowColor: TdxAlphaColor;
    MapControlSelectedRegionBackgroundColor: TdxAlphaColor;
    MapControlSelectedRegionBorderColor: TdxAlphaColor;
    MapControlShapeBorderColor: array [TcxButtonState] of TdxAlphaColor;
    MapControlShapeBorderWidth: array [TcxButtonState] of Integer;
    MapControlShapeColor: array [TcxButtonState] of TdxAlphaColor;

    // RangeControl
    RangeControlBackColor: TdxAlphaColor;
    RangeControlBorder: TdxSkinElement;
    RangeControlDefaultElementColor: TdxSkinColor;
    RangeControlElementBaseColor: TdxSkinColor;
    RangeControlElementFontSize: TdxSkinIntegerProperty;
    RangeControlElementForeColor: TdxSkinColor;
    RangeControlInnerBorderColor: TdxAlphaColor;
    RangeControlLabelColor: TdxSkinColor;
    RangeControlLeftThumb: TdxSkinElement;
    RangeControlOutOfRangeColorMask: TdxAlphaColor;
    RangeControlRangePreviewColor: TdxSkinColor;
    RangeControlRightThumb: TdxSkinElement;
    RangeControlRuleColor: TdxAlphaColor;
    RangeControlRulerHeader: TdxSkinElement;
    RangeControlScrollAreaColor: TdxSkinColor;
    RangeControlScrollAreaHeight: TdxSkinIntegerProperty;
    RangeControlSelectionBorderColor: TdxAlphaColor;
    RangeControlSelectionColor: TdxAlphaColor;
    RangeControlSizingGlyph: TdxSkinElement;
    RangeControlViewPortPreviewColor: TdxSkinColor;

    // PDF
    PDFViewerFindPanel: TdxSkinElement;
    PDFViewerSelectionColor: TdxSkinColor;
    PDFViewerNavigationPaneBackground: TdxSkinElement;
    PDFViewerNavigationPaneButton: TdxSkinElement;
    PDFViewerNavigationPaneButtonArrow: TdxSkinElement;
    PDFViewerNavigationPaneButtonMinimized: TdxSkinElement;
    PDFViewerNavigationPanePageBackground: TdxSkinElement;
    PDFViewerNavigationPanePageButton: TdxSkinElement;
    PDFViewerNavigationPanePageCaption: TdxSkinElement;
    PDFViewerNavigationPaneSelectedPageExpandValue: TdxSkinIntegerProperty;
    PDFViewerNavigationPaneSelectedPageOverlapValue: TdxSkinIntegerProperty;

    // Common
    LoadingBig: TdxSkinElement;

    // Gantt
    GanttDependencyEditPointLeft: TdxSkinElement;
    GanttDependencyEditPointRight: TdxSkinElement;
    GanttFocusedRow: TdxSkinElement;
    GanttMilestone: TdxSkinElement;
    GanttMilestoneBaseline: TdxSkinElement;
    GanttSummaryTask: TdxSkinElement;
    GanttSummaryTaskBaseline: TdxSkinElement;
    GanttSummaryTaskProgress: TdxSkinElement;
    GanttTask: TdxSkinElement;
    GanttTaskProgress: TdxSkinElement;
    GanttTaskBaseline: TdxSkinElement;
    GanttTaskTextLabel: TdxSkinElement;
    GanttTaskTextLabelHorizontalIndent: TdxSkinIntegerProperty;

    // Filter Panel
    FilterPanelCustomizeButton: TdxSkinElement;

    // Filter Visual Criteria
    FilterAddButton: TdxSkinElement;
    FilterBoolOperatorBackground: TdxSkinElement;
    FilterControlBackColor: TdxSkinColor;
    FilterItemCaptionBackground: TdxSkinElement;
    FilterOperatorBackground: TdxSkinElement;
    FilterPanelBrackets: TdxSkinElement;
    FilterRemoveButton: TdxSkinElement;
    FilterValueBackground: TdxSkinElement;

    // DataRowLayout
    DataRowLayoutElement: TdxSkinElement;
    DataRowLayoutItem: TdxSkinElement;

    // ListView
    ListViewItem: TdxSkinElement;
    ListViewIcon: TdxSkinElement;
    ListViewGroup: TdxSkinElement;
    ListViewGroupLine: TdxSkinElement;
    ListViewGroupExpandButton: TdxSkinElement;

    constructor Create(ASkin: TdxSkin); overload; virtual;
    destructor Destroy; override;
    function GetIntegerPropertyValue(AObject: TdxSkinPersistent; const APropertyName: string; ADefaultValue: Integer = 0): Integer;

    property Skin: TdxSkin read FSkin write SetSkin;
    property IsAdvanced: Boolean read GetIsAdvanced;
  end;

  TdxSkinInfoClass = class of TdxSkinInfo;

  { IdxSkinManager }

  TdxSkinManagerSkinControllerListChangeEvent = procedure (ASkinControllersCount: Integer; ASkinController: TComponent; AAction: TListNotification) of object;
  TdxSkinManagerSkinValuesChangeEvent = TcxLookAndFeelChangedEvent;
  TdxSkinManagerPaintersChangeEvent = procedure (APainter: TcxCustomLookAndFeelPainter; AOperation: TOperation) of object;

  IdxSkinManager = interface // for internal use
    ['{A46F65CF-2804-40C8-8061-248222FEF74B}']

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

    procedure AddListenerOnPaintersChanged(const AMethod: TdxSkinManagerPaintersChangeEvent);
    procedure RemoveListenerOnPaintersChanged(const AMethod: TdxSkinManagerPaintersChangeEvent);

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

    property SkinName: string read GetSkinName;
    property Style: TcxLookAndFeelStyle read GetStyle;
    property PaletteName: string read GetPaletteName write SetPaletteName;
  end;

  { IdxUserSkinLoader }

  IdxUserSkinLoader = interface // for internal use
    function LoadFromFile(const AFileName, ASkinName: string): Boolean;
    function LoadFromStream(AStream: TStream; const ASkinName: string): Boolean;
    function LoadFromResource(AInstance: THandle; const AResourceName, ASkinName: string): Boolean;
    function GetUserSkinName: string;
  end;

var
  dxISkinManager: IdxSkinManager = nil; // for internal use
  dxIUserSkinLoader: IdxUserSkinLoader = nil; // for internal use
implementation

uses
  Math, dxGDIPlusClasses, StrUtils, dxDPIAwareUtils;

const
  dxThisUnitName = 'dxSkinInfo';

type
  TdxSkinElementAccess = class(TdxSkinElement);

{ TdxSkinElementHelper }

class function TdxSkinElementHelper.CalculateCaptionButtonSize(ACaptionHeight: Integer; AElement: TdxSkinElement): TSize;

  function CalculateScaleFactor(AElement: TdxSkinElement): Single;
  var
    ASize: TSize;
  begin
    if AElement <> nil then
      ASize := AElement.MinSize.Size
    else
      ASize := cxNullSize;

    if ASize.cy > 0 then
      Result := ASize.cx / ASize.cy
    else
      Result := 1;
  end;

begin
  Result.cy := ACaptionHeight;
  Result.cx := Round(Result.cy * CalculateScaleFactor(AElement));
  if Assigned(AElement) and (AElement.Image.Stretch = smNoResize) then
  begin
    Dec(Result.cx, Integer(Odd(Result.cx + AElement.Image.Size.cx)));
    Dec(Result.cy, Integer(Odd(Result.cy + AElement.Image.Size.cy)));
  end;
end;

class function TdxSkinElementHelper.IsAlternateImageSetUsed(
  AElement: TdxSkinElement; AImageIndex: Integer; AState: TdxSkinElementState): Boolean;
var
  AAttributes: TdxSkinAlternateImageAttributes;
begin
  Result := TdxSkinElementAccess(AElement).CanUseAlternateImageSet(
    AImageIndex, AState, dxGpIsDoubleBufferedNeeded(cxScreenCanvas.Handle), AAttributes);
  cxScreenCanvas.Dormant;
end;

{ TdxSkinInfo }

constructor TdxSkinInfo.Create(ASkin: TdxSkin);
begin
  Create;
  Skin := ASkin;
end;

destructor TdxSkinInfo.Destroy;
var
  ASkin: TdxSkin;
begin
  ASkin := Skin; 
  Skin := nil;
  FreeAndNil(ASkin);
  inherited Destroy;
end;

function TdxSkinInfo.CreateBlankElement(AGroup: TdxSkinControlGroup; const AName: string): TdxSkinElement;
var
  ABitmap: TcxBitmap32;
begin
  Result := AGroup.AddElement(AName);
  if Result <> nil then
  begin
    Result.Image.States := [esNormal];
    Result.Image.Stretch := smStretch;
    Result.State := [sosUnassigned, sosUnused];
    ABitmap := TcxBitmap32.Create;
    try
      ABitmap.Width := 32;
      ABitmap.Height := 32;
      with ABitmap.Canvas do
      begin
        Pen.Color := clRed;
        Pen.Width := 2;
        MoveTo(0, 0);
        LineTo(ABitmap.Width, ABitmap.Height);
        MoveTo(0, ABitmap.Height);
        LineTo(ABitmap.Width, 0);
      end;
      ABitmap.MakeOpaque;
      Result.Image.Texture.SetBitmap(ABitmap);
    finally
      ABitmap.Free;
    end;
  end;
end;

function TdxSkinInfo.CreateBlankGroup(const AName: string): TdxSkinControlGroup;
begin
  Result := Skin.AddGroup(AName);
  Result.State := [sosUnassigned, sosUnused];
end;

function TdxSkinInfo.GetPropertyByName(
  AElement: TdxSkinPersistent; const AName: string): TdxSkinProperty;
begin
  if Assigned(AElement) then
  begin
    Result := AElement.GetPropertyByName(AName);
    MarkObjectUsed(Result);
  end
  else
    Result := nil;
end;

function TdxSkinInfo.GetRectPropertyByName(AElement: TdxSkinPersistent; const AName: string): TdxSkinRectProperty;
begin
  Result := GetPropertyByName(AElement, AName) as TdxSkinRectProperty;
end;

function TdxSkinInfo.GetColorByName(AElement: TdxSkinPersistent; const AName: string): TdxSkinColor;
begin
  Result := GetPropertyByName(AElement, AName) as TdxSkinColor;
end;

function TdxSkinInfo.GetColorByName(const AName: string): TdxSkinColor;
begin
  if Skin <> nil then
    Result := Skin.GetColorByName(AName)
  else
    Result := nil;
end;

function TdxSkinInfo.GetColorValueByName(AElement: TdxSkinPersistent; const AName: string): TColor;
var
  AColor: TdxSkinColor;
begin
  AColor := GetColorByName(AElement, AName);
  if AColor <> nil then
    Result := AColor.Value
  else
    Result := clDefault;
end;

function TdxSkinInfo.GetAlphaColorValueByName(AElement: TdxSkinPersistent; const AName: string): TdxAlphaColor;
begin
  Result := dxColorToAlphaColor(GetColorValueByName(AElement, AName),
    GetIntegerPropertyValue(AElement, AName + sdxAlpha, MaxByte));
end;

function TdxSkinInfo.GetBoolPropertyByName(AElement: TdxSkinPersistent; const AName: string): TdxSkinBooleanProperty;
begin
  Result := GetPropertyByName(AElement, AName) as TdxSkinBooleanProperty;
end;

function TdxSkinInfo.GetIntegerPropertyByName(AElement: TdxSkinPersistent; const AName: string): TdxSkinIntegerProperty;
begin
  Result := GetPropertyByName(AElement, AName) as TdxSkinIntegerProperty;
end;

function TdxSkinInfo.GetIntegerPropertyValue(AObject: TdxSkinPersistent; const APropertyName: string; ADefaultValue: Integer = 0): Integer;
var
  AProperty: TdxSkinIntegerProperty;
begin
  Result := ADefaultValue;
  if AObject <> nil then
  begin
    AProperty := AObject.GetPropertyByName(APropertyName) as TdxSkinIntegerProperty;
    if AProperty <> nil then
    begin
      MarkObjectUsed(AProperty);
      Result := AProperty.Value;
    end;
  end;
end;

function TdxSkinInfo.GetGroupByName(const AName: string): TdxSkinControlGroup;
begin
  if Assigned(Skin) then
  begin
    Result := Skin.GetGroupByName(AName);
    if Result = nil then
      Result := CreateBlankGroup(AName);
    MarkObjectUsed(Result);
  end
  else
    Result := nil;
end;

function TdxSkinInfo.GetElementByName(AGroup: TdxSkinControlGroup;
  const AName: string; ACreateIfAbsent: Boolean = True): TdxSkinElement;
begin
  if Assigned(AGroup) then
  begin
    Result := AGroup.GetElementByName(AName);
    if (Result = nil) and ACreateIfAbsent then
      Result := CreateBlankElement(AGroup, AName);
    MarkObjectUsed(Result);
  end
  else
    Result := nil;
end;

function TdxSkinInfo.GetFormFrameElementByName(AGroup: TdxSkinControlGroup;
  const AName: string; ACreateIfAbsent: Boolean = True): TdxSkinElement;
begin
  if Assigned(AGroup) then
  begin
    Result := AGroup.GetElementByName(AName);
    if (Result = nil) and ACreateIfAbsent then
      Result := CreateBlankElement(AGroup, AName);
    MarkObjectUsed(Result);
  end
  else
    Result := nil;
  if Result <> nil then
    Result.ScaleBordersEx := True;
end;

procedure TdxSkinInfo.InitializeGroups;
begin
  GroupBars := GetGroupByName(sdxSkinGroupBars);
  GroupCommon := GetGroupByName(sdxSkinGroupCommon);
  GroupDocking := GetGroupByName(sdxSkinGroupDocking);
  GroupEditors := GetGroupByName(sdxSkinGroupEditors);
  GroupForm := GetGroupByName(sdxSkinGroupForm);
  GroupGantt := GetGroupByName(sdxSkinGroupGantt);
  GroupGrid := GetGroupByName(sdxSkinGroupGrid);
  GroupMapControl := GetGroupByName(sdxSkinGroupMapControl);
  GroupHamburgerMenu := GetGroupByName(sdxSkinGroupHamburgerMenu);
  GroupListView := GetGroupByName(sdxSkinGroupListView);
  GroupNavBar := GetGroupByName(sdxSkinGroupNavBar);
  GroupNavPane := GetGroupByName(sdxSkinGroupNavPane);
  GroupPDFViewer := GetGroupByName(sdxSkinGroupPDFViewer);
  GroupPrintingSystem := GetGroupByName(sdxSkinGroupPrintingSystem);
  GroupRibbon := GetGroupByName(sdxSkinGroupRibbon);
  GroupRichEdit := GetGroupByName(sdxSkinGroupRichEdit);
  GroupScheduler := GetGroupByName(sdxSkinGroupScheduler);
  GroupTabs := GetGroupByName(sdxSkinGroupTabs);
  GroupTileControl := GetGroupByName(sdxSkinGroupTileControl);
  GroupVGrid := GetGroupByName(sdxSkinGroupVGrid);
end;

procedure TdxSkinInfo.Initialize;
begin
  InitializeSkinInfo;
  Skin.CalculateCachedValues;
end;

procedure TdxSkinInfo.InitializeAlertWindowElements;
begin
  AlertWindow := GetElementByName(GroupCommon, sdxAlertWindow);
  AlertWindowButton := GetElementByName(GroupCommon, sdxAlertWindowButton);
  AlertWindowButtonGlyphs := GetElementByName(GroupCommon, sdxAlertWindowButtonGlyphs);
  AlertWindowCaption := GetElementByName(GroupCommon, sdxAlertWindowCaption);
  AlertWindowCornerRadius := GetIntegerPropertyValue(AlertWindow, sdxAlertWindowCornerRadius);
  AlertWindowNavigationPanel := GetElementByName(GroupCommon, sdxAlertWindowNavigationPanel);
  AlertWindowNavigationPanelButton := GetElementByName(GroupCommon, sdxAlertWindowNavigationPanelButton);
end;

procedure TdxSkinInfo.InitializeBarElements;
begin
  Bar := GetElementByName(GroupBars, sdxBarsBar);
  BarCustomize := GetElementByName(GroupBars, sdxBarsBarCustomize);
  BarCustomizeVertical := GetElementByName(GroupBars, sdxBarsBarCustomizeVertical);
  BarDrag := GetElementByName(GroupBars, sdxBarsBarFinger);
  BarDragVertical := GetElementByName(GroupBars, sdxBarsBarFingerVertical);
  BarMDIButtonClose := GetElementByName(GroupBars, sdxBarsMDIButtonClose);
  BarMDIButtonMinimize := GetElementByName(GroupBars, sdxBarsMDIButtonMinimize);
  BarMDIButtonRestore := GetElementByName(GroupBars, sdxBarsMDIButtonRestore);
  BarSeparator := GetElementByName(GroupBars, sdxBarsBarSeparator);
  BarSubItemArrow := GetElementByName(GroupBars, sdxBarsBarSubItemArrow, False);
  BarVertical := GetElementByName(GroupBars, sdxBarsBarVertical);
  BarVerticalSeparator := GetElementByName(GroupBars, sdxBarsBarVerticalSeparator);
  Dock := GetElementByName(GroupBars, sdxBarsDock);
  FloatingBar := GetElementByName(GroupBars, sdxBarsFloatBar);
  ItemSeparator := GetElementByName(GroupBars, sdxBarsItemSeparator);
  LinkBorderPainter := GetElementByName(GroupBars, sdxBarsLinkStatic);
  LinkSelected := GetElementByName(GroupBars, sdxBarsLinkSelected);
  MainMenu := GetElementByName(GroupBars, sdxBarsMainMenu);
  MainMenuCustomize := GetElementByName(GroupBars, sdxBarsMainMenuCustomize, False);
  MainMenuDrag := GetElementByName(GroupBars, sdxBarsMainMenuDrag, False);
  MainMenuLinkSelected := GetElementByName(GroupBars, sdxBarsMainMenuLinkSelected);
  MainMenuVertical := GetElementByName(GroupBars, sdxBarsMainMenuVertical);
  PopupMenu := GetElementByName(GroupBars, sdxBarsPopupMenu);
  PopupMenuCheck := GetElementByName(GroupBars, sdxBarsPopupMenuCheck);
  PopupMenuExpandButton := GetElementByName(GroupBars, sdxBarsPopupMenuExpandButton);
  PopupMenuLinkArrow := GetElementByName(GroupBars, sdxBarsPopupMenuLinkArrow, False);
  PopupMenuLinkSelected := GetElementByName(GroupBars, sdxBarsPopupMenuLinkSelected);
  PopupMenuSeparator := GetElementByName(GroupBars, sdxBarsPopupMenuSeparator);
  PopupMenuSideStrip := GetElementByName(GroupBars, sdxBarsPopupMenuSideStrip);
  PopupMenuSideStripNonRecent := GetElementByName(GroupBars, sdxBarsPopupMenuSideStripNonRecent);
  PopupMenuSplitButton := GetElementByName(GroupBars, sdxBarsPopupMenuDropDownButtonLabel);
  PopupMenuSplitButton2 := GetElementByName(GroupBars, sdxBarsPopupMenuDropDownButtonArrow);
end;

procedure TdxSkinInfo.InitializeBreadcrumbEditElements;
var
  AIndex: TdxBreadcrumbEditState;
  AProperty: TdxSkinBooleanProperty;
begin
  BreadcrumbEditButton := GetElementByName(GroupEditors, sdxBreadcrumbEditButton);
  BreadcrumbEditButtonsAreaSeparator := GetElementByName(GroupEditors, sdxBreadcrumbEditButtonsAreaSeparator);
  BreadcrumbEditDropDownButton := GetElementByName(GroupEditors, sdxBreadcrumbEditDropDownButton);
  BreadcrumbEditNodeButton := GetElementByName(GroupEditors, sdxBreadcrumbEditNodeButton);
  BreadcrumbEditNodeSplitButtonLeft := GetElementByName(GroupEditors, sdxBreadcrumbEditNodeSplitButtonLeft);
  BreadcrumbEditNodeSplitButtonRight := GetElementByName(GroupEditors, sdxBreadcrumbEditNodeSplitButtonRight);
  BreadcrumbEditProgressChunk := GetElementByName(GroupEditors, sdxBreadcrumbEditProgressChunk);
  BreadcrumbEditProgressChunkOverlay := GetElementByName(GroupEditors, sdxBreadcrumbEditProgressChunkOverlay);
  BreadcrumbEditProgressChunkPadding := GetPropertyByName(GroupEditors, sdxBreadcrumbEditProgressChunkPadding) as TdxSkinRectProperty;
  for AIndex := Low(TdxBreadcrumbEditState) to High(TdxBreadcrumbEditState) do
  begin
    BreadcrumbEditBackgroundColors[AIndex] := GetColorByName(GroupEditors, BreadcrumbEditBackgroundColorsMap[AIndex]);
    BreadcrumbEditBordersColors[AIndex] := GetColorByName(GroupEditors, BreadcrumbEditBordersColorsMap[AIndex]);
  end;
  AProperty := GetBoolPropertyByName(BreadcrumbEditButton, sdxEditorButtonMergeBorders);
  BreadcrumbEditButtonMergeBorders := Assigned(AProperty) and AProperty.Value;
end;

procedure TdxSkinInfo.InitializeButtonElements;
begin
  BackButton := GetElementByName(GroupCommon, sdxBackButton);
  ButtonParts[cxbpButton] := GetElementByName(GroupCommon, sdxButton);
  ButtonParts[cxbpDropDownLeftPart] := GetElementByName(GroupCommon, sdxDropDownButtonLeft);
  ButtonParts[cxbpDropDownRightPart] := GetElementByName(GroupCommon, sdxDropDownButtonRight);
  ClearButton := GetElementByName(GroupEditors, sdxClearButton);
  ExpandButton := GetElementByName(GroupGrid, sdxPlusMinus);
end;

procedure TdxSkinInfo.InitializeCalcEditColors;
var
  AType: TcxCalcButtonKind;
begin
  for AType := Low(TcxCalcButtonKind) to High(TcxCalcButtonKind) do
    CalcEditButtonTextColors[AType] := GetColorByName(GroupEditors, CalcEditTextColorsMap[AType]);
end;

procedure TdxSkinInfo.InitializeCalendarElements;
begin
  CalendarNavigationButton := GetElementByName(GroupEditors, sdxSkinsCalendarNavigationButton);
  CalendarDayTextColor := GetColorByName(GroupEditors, sdxSkinsCalendarDayTextColor);
  CalendarHolidayTextColor := GetColorByName(GroupEditors, sdxSkinsCalendarHolidayTextColor);
  CalendarInactiveDayTextColor := GetColorByName(GroupEditors, sdxSkinsCalendarInactiveDayTextColor);
  CalendarSelectedDayTextColor := GetColorByName(GroupEditors, sdxSkinsCalendarSelectedDayTextColor);
  CalendarSelectedDayColor := GetColorByName(GroupEditors, sdxSkinsCalendarSelectedDayColor);
  CalendarSeparatorColor := GetColorByName(GroupEditors, sdxSkinsCalendarSeparatorColor);
  CalendarTodayFrameColor := GetColorByName(GroupEditors, sdxSkinsCalendarTodayFrameColor);
  CalendarTodayTextColor := GetColorByName(GroupEditors, sdxSkinsCalendarTodayTextColor);
  CalendarWeekendDayTextColor := GetColorByName(GroupEditors, sdxSkinsCalendarWeekendDayTextColor);
end;

procedure TdxSkinInfo.InitializeCheckboxElements;
begin
  CheckboxElement := GetElementByName(GroupEditors, sdxCheckbox);
end;

procedure TdxSkinInfo.InitializeClockElements;
begin
  ClockElements[False] := GetElementByName(GroupEditors, sdxClock);
  ClockElements[True] := GetElementByName(GroupEditors, sdxClockGlass);
end;

procedure TdxSkinInfo.InitializeColors;
var
  AKind: TcxEditStateColorKind; 
begin
  BarDisabledTextColor := GetColorByName(GroupBars, sdxSkinsBarDisabledTextColor);
  SchedulerNavigatorColor := GetColorByName(GroupScheduler, sdxSkinsSchedulerNavigatorColor);

  TabTextColor := GetColorByName(PageControlHeader, sdxTextColorNormal);
  TabTextColorActive := GetColorByName(PageControlHeader, sdxTextColorSelected);
  TabTextColorActiveHot := GetColorByName(PageControlHeader, sdxTextColorSelectedHot);
  TabTextColorDisabled := GetColorByName(PageControlHeader, sdxTextColorDisabled);
  TabTextColorHot := GetColorByName(PageControlHeader, sdxTextColorHot);

  HyperLinkTextColor := GetColorByName(GroupEditors, sdxSkinsEditorHyperLinkTextColor);
  for AKind := Low(TcxEditStateColorKind) to High(TcxEditStateColorKind) do
  begin
    EditorTextColors[AKind] := GetColorByName(GroupEditors, EditTextColorsMap[AKind]);
    EditorBackgroundColors[AKind] := GetColorByName(GroupEditors, EditBackgroundColorsMap[AKind]);
  end;

  ContainerBorderColor := GetColorByName(sdxSkinsContainerBorderColor);
  ContainerHighlightBorderColor := GetColorByName(sdxSkinsContainerHighlightBorderColor);
  ContentColor := GetColorByName(sdxSkinsContentColor);
  ContentEvenColor := GetColorByName(sdxSkinsContentEvenColor);
  ContentOddColor := GetColorByName(sdxSkinsContentOddColor);
  ContentTextColor := GetColorByName(sdxSkinsContentTextColor);
  HeaderBackgroundColor := GetColorByName(sdxSkinsHeaderBackgroundColor);
  HeaderBackgroundTextColor := GetColorByName(sdxSkinsHeaderBackgroundTextColor);
  InactiveColor := GetColorByName(sdxSkinsInactiveColor);
  InactiveTextColor := GetColorByName(sdxSkinsInactiveTextColor);
  LayoutControlColor := GetColorByName(sdxSkinsLayoutControlColor);
  SelectionColor := GetColorByName(sdxSkinsSelectionColor);
  SelectionTextColor := GetColorByName(sdxSkinsSelectionTextColor);
  SearchResultHighlightColor := GetColorByName(sdxSkinsSearchResultHighlightColor);
  SearchResultHighlightTextColor := GetColorByName(sdxSkinsSearchResultHighlightTextColor);

  TreeListGridLineColor := GetColorByName(sdxTreeListGridLineColor);
  TreeListTreeLineColor := GetColorByName(sdxTreeListTreeLineColor);

  SpreadSheetContentColor := GetColorByName(sdxSkinsSpreadSheetContentColor);
  SpreadSheetContentTextColor := GetColorByName(sdxSkinsSpreadSheetContentTextColor);
  SpreadSheetFrozenPaneSeparatorColor := GetColorByName(sdxSkinsSpreadSheetFrozenPaneSeparatorColor);
  SpreadSheetSelectionColor := GetColorByName(sdxSkinsSpreadSheetSelectionColor);
  SpreadSheetGroupLineColor := GetColorByName(sdxSkinsSpreadSheetGroupLineColor);

  GridLikeControlContentColor := GetColorByName(sdxSkinsGridLikeControlContentColor);
  GridLikeControlContentEvenColor := GetColorByName(sdxSkinsGridLikeControlContentEvenColor);
  GridLikeControlContentOddColor := GetColorByName(sdxSkinsGridLikeControlContentOddColor);
  GridLikeControlContentTextColor := GetColorByName(sdxSkinsGridLikeControlContentTextColor);
  GridLikeControlBackgroundColor := GetColorByName(sdxSkinsGridLikeControlBackgroundColor);

  CriticalColor := GetColorByName(GroupCommon, sdxCommonCriticalColor);
  HotTrackedColor := GetColorByName(GroupCommon, sdxCommonHotTrackedColor);
  HotTrackedTextColor := GetColorByName(GroupCommon, sdxCommonHotTrackedTextColor);
  InformationColor := GetColorByName(GroupCommon, sdxCommonInformationColor);
  QuestionColor := GetColorByName(GroupCommon, sdxCommonQuestionColor);

  FilterControlBackColor := GetColorByName(GroupCommon, sdxFilterControlBackColor);
end;

procedure TdxSkinInfo.InitializeDataRowLayoutElements;
begin
  DataRowLayoutElement := GetElementByName(GroupGrid, sdxDataRowLayoutElement);
  DataRowLayoutItem := GetElementByName(GroupGrid, sdxDataRowLayoutItem);
end;

procedure TdxSkinInfo.InitializeDockControlElements;
begin
  DockControlHideBarTextColor[False] := GetColorByName(GroupDocking, sdxDockCtrlHiddenBarTextColor);
  DockControlHideBarTextColor[True] := GetColorByName(GroupDocking, sdxDockCtrlHiddenBarTextHotColor);

  DockControlTabTextColor := GetColorByName(GroupDocking, sdxSkinsTabTextColor);
  DockControlTabTextColorHot := GetColorByName(GroupDocking, sdxSkinsTabTextColorHot);
  DockControlTabTextColorActive := GetColorByName(GroupDocking, sdxSkinsTabTextColorActive);
  DockControlTabTextColorActiveHot := GetColorByName(GroupDocking, sdxSkinsTabTextColorActiveHot);
  DockControlTabTextColorDisabled := GetColorByName(GroupDocking, sdxSkinsTabTextColorDisabled);

  DockControlHideBarButtons := GetElementByName(GroupDocking, sdxDockCtrlTabHeaderAutoHideBar);
  DockControlTabButtonHorz := GetElementByName(GroupDocking, sdxDockCtrlTabButtonHorz);
  DockControlTabButtonVert := GetElementByName(GroupDocking, sdxDockCtrlTabButtonVert);
  DockControlTabHeader := GetElementByName(GroupDocking, sdxDockCtrlTabHeader);
  DockControlTabHeaderBackground := GetElementByName(GroupDocking, sdxDockCtrlTabHeaderBackground);
  DockControlTabHeaderCloseButton := GetElementByName(GroupDocking, sdxDockCtrlTabHeaderCloseButton);
  DockControlTabHeaderLine := GetElementByName(GroupDocking, sdxDockCtrlTabHeaderLine);
  DockControlWindowButton := GetElementByName(GroupDocking, sdxDockCtrlWindowButton);
  DockControlWindowButtonGlyphs := GetElementByName(GroupDocking, sdxDockCtrlWindowGlyphs);
  DockSiteContentColor := GetColorByName(GroupDocking, sdxDockSiteContentColor);

  DockControlHideBar := GetElementByName(GroupDocking, sdxDockCtrlAutoHideBar);
  DockControlHideBarLeft := GetElementByName(GroupDocking, sdxDockCtrlAutoHideBarLeft);
  DockControlHideBarRight := GetElementByName(GroupDocking, sdxDockCtrlAutoHideBarRight);
  DockControlHideBarBottom := GetElementByName(GroupDocking, sdxDockCtrlAutoHideBarBottom);

  DockControlCaption := GetElementByName(GroupDocking, sdxDockCtrlCaption);
  DockControlBorder := GetElementByName(GroupDocking, sdxDockCtrlBorder);
  DockControlCaptionNonFocusedTextColor := GetColorValueByName(DockControlCaption, sdxDockCtrlInactiveCaptionTextColor);
    
  DockControlIndents[0] := GetIntegerPropertyValue(GroupDocking, sdxDCActiveTabHeaderDownGrow);
  DockControlIndents[1] := GetIntegerPropertyValue(GroupDocking, sdxDCActiveTabHeaderHGrow);
  DockControlIndents[2] := GetIntegerPropertyValue(GroupDocking, sdxDCActiveTabHeaderUpGrow);
end;

procedure TdxSkinInfo.InitializeEditorsElements;
const
  SliderArrowNames: array[TcxArrowDirection] of string = (
    sdxSliderArrowTop, sdxSliderArrowBottom, sdxSliderArrowLeft, sdxSliderArrowRight
  );
var
  AArrowDirection: TcxArrowDirection;
  AKind: TcxEditBtnKind;
  AProperty: TdxSkinBooleanProperty;
begin
  LoadingBig := GetElementByName(GroupCommon, sdxLoadingBig);

  Breadcrumb := GetElementByName(GroupEditors, sdxBreadcrumb, False);
  EditorBackground := GetElementByName(GroupEditors, sdxEditorBackground, False);
  EditorComboButton := GetElementByName(GroupEditors, sdxComboButtonGlyph, False);
  PictureEditBackground := GetElementByName(GroupEditors, sdxPictureEdit, False);
  PopupFormBorder := GetElementByName(GroupEditors, sdxPopupFormBorder, False);
  TokenEdit := GetElementByName(GroupEditors, sdxTokenEdit, False);
  TokenEditBackground := GetElementByName(GroupEditors, sdxTokenEditBackground, False);
  TokenEditCloseButton := GetElementByName(GroupEditors, sdxTokenEditCloseButton, False);
  TokenEditCloseButtonSelected := GetElementByName(GroupEditors, sdxTokenEditCloseButtonSelected, False);

  LabelLine[False] := GetElementByName(GroupEditors, sdxLabelLine);
  LabelLine[True] := GetElementByName(GroupEditors, sdxLabelLineVert);
  BevelShapeColor1 := GetColorByName(GroupEditors, sdxBevelShapeColor1);
  BevelShapeColor2 := GetColorByName(GroupEditors, sdxBevelShapeColor2);
  ZoomInButton := GetElementByName(GroupEditors, sdxZoomInButton);
  ZoomOutButton := GetElementByName(GroupEditors, sdxZoomOutButton);

  EditButtonElements[False] := GetElementByName(GroupEditors, sdxEditorButton);
  EditButtonElements[True] := GetElementByName(GroupEditors, sdxCloseButton);
  for AKind := Low(TcxEditBtnKind) to High(TcxEditBtnKind) do
    EditButtonGlyphs[AKind] := GetElementByName(GroupEditors, EditButtonsMap[AKind]);
  EditButtonSearchGlyph := GetElementByName(GroupEditors, sdxSearchButtonGlyph);
  AProperty := GetBoolPropertyByName(EditButtonElements[False], sdxEditorButtonMergeBorders);
  EditButtonMergeBorders := Assigned(AProperty) and AProperty.Value;

  for AArrowDirection := Low(TcxArrowDirection) to High(TcxArrowDirection) do
    SliderArrow[AArrowDirection] := GetElementByName(GroupEditors, SliderArrowNames[AArrowDirection]);

  SetUseCache(EditButtonElements[False]);
end;

procedure TdxSkinInfo.InitializeFilterElements;
begin
  FilterButtons[False] := GetElementByName(GroupGrid, sdxFilterButton);
  FilterButtons[True] := GetElementByName(GroupGrid, sdxFilterButtonActive);
  SmartFilterButton := GetElementByName(GroupGrid, sdxSmartFilterButton);
  FilterPanel := GetElementByName(GroupGrid, sdxFilterPanel);
  FilterPanelCustomizeButton := GetElementByName(GroupCommon, sdxFilterPanelCustomizeButton, False);
end;

procedure TdxSkinInfo.InitializeFilterVisualCriteriaElements;
begin
  FilterBoolOperatorBackground := GetElementByName(GroupCommon, sdxFilterBoolOperatorBackground);
  FilterItemCaptionBackground := GetElementByName(GroupCommon, sdxFilterItemCaptionBackground);
  FilterOperatorBackground := GetElementByName(GroupCommon, sdxFilterOperatorBackground);
  FilterPanelBrackets := GetElementByName(GroupCommon, sdxFilterPanelBrackets);
  FilterAddButton := GetElementByName(GroupCommon, sdxFilterAddButton);
  FilterRemoveButton := GetElementByName(GroupCommon, sdxFilterRemoveButton);
  FilterValueBackground := GetElementByName(GroupCommon, sdxFilterValueBackground);
end;

procedure TdxSkinInfo.InitializeFooterElements;
begin
  FooterCell := GetElementByName(GroupGrid, sdxFooterCell);
  FooterPanel := GetElementByName(GroupGrid, sdxFooterPanel);
end;

procedure TdxSkinInfo.InitializeFormElements;

  procedure InitializeFormIcons;
  begin
    FillChar(FormIcons, SizeOf(FormIcons), 0);
    FormIcons[False, sfiClose] := GetElementByName(GroupForm, sdxSmallFormButtonClose);
    FormIcons[True, sfiClose] := GetElementByName(GroupForm, sdxFormButtonClose);
    FormIcons[True, sfiHelp] := GetElementByName(GroupForm, sdxFormButtonHelp);
    FormIcons[True, sfiMaximize] := GetElementByName(GroupForm, sdxFormButtonMaximize);
    FormIcons[True, sfiMinimize] := GetElementByName(GroupForm, sdxFormButtonMinimize);
    FormIcons[True, sfiRestore] := GetElementByName(GroupForm, sdxFormButtonRestore);
  end;

  procedure InitializeFormFrames;
  var
    ASide: TcxBorder;
    AStandard: Boolean;
  begin
    for AStandard := False to True do
      for ASide := Low(TcxBorder) to High(TcxBorder) do
      begin
        FormFrames[AStandard, ASide] := GetFormFrameElementByName(GroupForm, FormFrameMap[AStandard, ASide]);
      end;
  end;

begin
  InitializeFormIcons;
  InitializeFormFrames;
  FormStatusBar := GetElementByName(GroupBars, sdxStatusBar);
  FormContent := GetElementByName(GroupForm, sdxFormContent);
  FormDecoratorFrameBottom := GetElementByName(GroupForm, sdxFormDecoratorFrameBottom, False);
  FormDecoratorFrameLeft := GetElementByName(GroupForm, sdxFormDecoratorFrameLeft, False);
  FormDecoratorFrameRight := GetElementByName(GroupForm, sdxFormDecoratorFrameRight, False);
  FormDecoratorFrameTop := GetElementByName(GroupForm, sdxFormDecoratorFrameTop, False);
  FormInactiveColor := GetColorByName(GroupForm, sdxTextColorInactive);
  FormTextShadowColor := GetColorByName(GroupForm, sdxTextShadowColor);
  FormCaptionFontDelta := Max(1, GetIntegerPropertyValue(FormFrames[True, bTop], sdxCaptionFontDelta));
  FormCaptionFontIsBold := GetBoolPropertyByName(FormFrames[True, bTop], sdxCaptionFontBold);
  FormSupportsNavigationControlExtensionToFormCaption := GetBoolPropertyByName(Skin, sdxSupportsNavigationControlExtensionToFormCaption);
end;

procedure TdxSkinInfo.InitializeGroupBoxElements;
const
  GroupBoxNamesMap: array[TcxGroupBoxCaptionPosition] of string = (
    sdxGroupPanelTop, sdxGroupPanelBottom, sdxGroupPanelLeft,
    sdxGroupPanelRight, sdxGroupPanel
  );
  GroupBoxCaptionNamesMap: array[TcxGroupBoxCaptionPosition] of string = (
    sdxGroupPanelCaptionTop, sdxGroupPanelCaptionBottom,
    sdxGroupPanelCaptionLeft, sdxGroupPanelCaptionRight, ''
  );
var
  APosition: TcxGroupBoxCaptionPosition;
begin
  GroupBoxClient := GetElementByName(GroupCommon, sdxGroupPanelNoBorder);
  GroupButton := GetElementByName(GroupCommon, sdxGroupButton);
  GroupButtonExpandGlyph := GetElementByName(GroupCommon, sdxGroupButtonExpandGlyph);
  for APosition := Low(TcxGroupBoxCaptionPosition) to High(TcxGroupBoxCaptionPosition) do
  begin
    GroupBoxElements[APosition] := GetElementByName(GroupCommon, GroupBoxNamesMap[APosition]);
    GroupBoxCaptionElements[APosition] := GetElementByName(GroupCommon, GroupBoxCaptionNamesMap[APosition], APosition <> cxgpCenter);
    GroupBoxCaptionTailSizes[APosition] := GetIntegerPropertyByName(GroupBoxCaptionElements[APosition], sdxGroupPanelCaptionTailSize);
    GroupBoxCaptionTextPadding[APosition] := GetIntegerPropertyByName(GroupBoxCaptionElements[APosition], sdxGroupPanelCaptionTextPadding);
  end;
end;

procedure TdxSkinInfo.InitializeGalleryElements;
begin
  StandaloneGalleryBackground := GetElementByName(GroupEditors, sdxStandaloneGalleryBackground);
  StandaloneGalleryGroupHeader := GetElementByName(GroupEditors, sdxStandaloneGalleryGroupHeader);
  StandaloneGalleryItem := GetElementByName(GroupEditors, sdxStandaloneGalleryItem);
  StandaloneGalleryItemImage := GetElementByName(GroupEditors, sdxStandaloneGalleryItemImage);
end;

procedure TdxSkinInfo.InitializeGanttElements;
begin
  GanttDependencyEditPointLeft := GetElementByName(GroupGantt, sdxGanttDependencyEditPointLeft);
  GanttDependencyEditPointRight := GetElementByName(GroupGantt, sdxGanttDependencyEditPointRight);
  GanttFocusedRow := GetElementByName(GroupGantt, sdxGanttFocusedRow);
  GanttMilestone := GetElementByName(GroupGantt, sdxGanttMilestone);
  GanttMilestoneBaseline := GetElementByName(GroupGantt, sdxGanttMilestoneBaseline);
  GanttSummaryTask := GetElementByName(GroupGantt, sdxGanttSummaryTask);
  GanttSummaryTaskBaseline := GetElementByName(GroupGantt, sdxGanttSummaryTaskBaseline);
  GanttSummaryTaskProgress := GetElementByName(GroupGantt, sdxGanttSummaryTaskProgress);
  GanttTask := GetElementByName(GroupGantt, sdxGanttTask);
  GanttTaskProgress := GetElementByName(GroupGantt, sdxGanttTaskProgress);
  GanttTaskBaseline := GetElementByName(GroupGantt, sdxGanttTaskBaseline);
  GanttTaskTextLabel := GetElementByName(GroupGantt, sdxGanttTaskTextLabel);
  GanttTaskTextLabelHorizontalIndent := GetIntegerPropertyByName(GanttTaskTextLabel, sdxGanttTaskTextLabelHorizontalIndent);
end;

procedure TdxSkinInfo.InitializeGaugeElements;
begin
  GaugeBackground := GetElementByName(GroupCommon, sdxGaugeBackground);
end;

procedure TdxSkinInfo.InitializeGridElements;
var
  AGroupRow: TdxSkinElement;
begin
  GridFixedColumnHighlightColor := GetPropertyByName(GroupGrid, sdxGridFixedColumnHighlightColor) as TdxSkinAlphaColor;
  GridFixedLine := GetElementByName(GroupGrid, sdxGridFixedLine);
  CardViewSeparator := GetElementByName(GroupGrid, sdxCardSeparator);
  GridGroupByBox := GetElementByName(GroupGrid, sdxGroupByBox);
  GridGroupByBoxLineColor := GetColorByName(GridGroupByBox, sdxGroupByBoxLineColor);
  GridGroupRow := GetElementByName(GroupGrid, sdxGroupRow);
  GridCell := GetElementByName(GroupGrid, sdxGridCell, False);
  GridLine := GetElementByName(GroupGrid, sdxGridLine);

  VGridContentColor := GetColorByName(GroupVGrid, sdxSkinsContentColor);
  VGridCategory := GetElementByName(GroupVGrid, sdxVGridCategory);
  VGridLine[False] := GetElementByName(GroupVGrid, sdxVGridLine);
  VGridLine[True] := GetElementByName(GroupVGrid, sdxVGridBandLine);
  VGridRowHeader := GetElementByName(GroupVGrid, sdxVGridRowHeader);

  AGroupRow := GetElementByName(GroupGrid, sdxGroupRow);
  GridGroupRowStyleOffice11ContentColor := GetColorByName(AGroupRow, sdxGridGroupRowStyleOffice11ContentColor);
  GridGroupRowStyleOffice11SeparatorColor := GetColorByName(AGroupRow, sdxGridGroupRowStyleOffice11SeparatorColor);
  GridGroupRowStyleOffice11TextColor := GetColorByName(AGroupRow, sdxGridGroupRowStyleOffice11TextColor);

  GridWinExplorerViewGroup := GetElementByName(GroupGrid, sdxGridWinExplorerViewGroup);
  GridWinExplorerViewGroupCaptionLine := GetElementByName(GroupGrid, sdxGridWinExplorerViewGroupCaptionLine);
  GridWinExplorerViewGroupExpandButton := GetElementByName(GroupGrid, sdxGridWinExplorerViewGroupExpandButton);
  GridWinExplorerViewRecord := GetElementByName(GroupGrid, sdxGridWinExplorerViewRecord);
end;

procedure TdxSkinInfo.InitializeHamburgerMenuElements;
begin
  HamburgerMenuHamburgerButton := GetElementByName(GroupHamburgerMenu, sdxHamburgerMenuHamburgerButton);
  HamburgerMenuBackground := GetElementByName(GroupHamburgerMenu, sdxHamburgerMenuBackground);
  HamburgerMenuChildGroup := GetElementByName(GroupHamburgerMenu, sdxHamburgerMenuChildGroup);
  HamburgerMenuChildGroupCloseButton := GetElementByName(GroupHamburgerMenu, sdxHamburgerMenuChildGroupCloseButton);
  HamburgerMenuChildGroupOpenButton := GetElementByName(GroupHamburgerMenu, sdxHamburgerMenuChildGroupOpenButton);
  HamburgerMenuChildItemOffset := GetIntegerPropertyByName(GroupHamburgerMenu, sdxHamburgerMenuChildItemOffset);
  HamburgerMenuDistanceBetweenGroups := GetIntegerPropertyByName(GroupHamburgerMenu, sdxHamburgerMenuDistanceBetweenGroups);
  HamburgerMenuGroup := GetElementByName(GroupHamburgerMenu, sdxHamburgerMenuGroup);
  HamburgerMenuGroupCloseButton := GetElementByName(GroupHamburgerMenu, sdxHamburgerMenuGroupCloseButton);
  HamburgerMenuGroupOpenButton := GetElementByName(GroupHamburgerMenu, sdxHamburgerMenuGroupOpenButton);
  HamburgerMenuItem := GetElementByName(GroupHamburgerMenu, sdxHamburgerMenuItem);
  HamburgerMenuNavPaneBackground := GetElementByName(GroupHamburgerMenu, sdxHamburgerMenuNavPaneBackground);
  HamburgerMenuNavPaneItem := GetElementByName(GroupHamburgerMenu, sdxHamburgerMenuNavPaneItem);
  HamburgerMenuNavPaneExpandButton := GetElementByName(GroupHamburgerMenu, sdxHamburgerMenuNavPaneExpandButton);
  HamburgerMenuScrollDownButton := GetElementByName(GroupHamburgerMenu, sdxHamburgerMenuScrollDownButton);
  HamburgerMenuScrollUpButton := GetElementByName(GroupHamburgerMenu, sdxHamburgerMenuScrollUpButton);
end;

procedure TdxSkinInfo.InitializeHeaderElements;
begin
  Header := GetElementByName(GroupCommon, sdxHeader);
  HeaderSpecial := GetElementByName(GroupCommon, sdxHeaderSpecial);
  SortGlyphs := GetElementByName(GroupCommon, sdxSortGlyphs);
end;

procedure TdxSkinInfo.InitializeIndicatorImages;
begin
  IndicatorImages := GetElementByName(GroupGrid, sdxIndicatorImages);
  RatingIndicator := GetElementByName(GroupEditors, sdxRatingIndicator);
end;

procedure TdxSkinInfo.InitializeNavBarElements;
begin
  NavBarAccordionControlBackground := GetElementByName(GroupNavBar, sdxNavBarAccordionControlBackground);
  NavBarAccordionControlChildItemOffset := GetIntegerPropertyByName(GroupNavBar, sdxNavBarAccordionControlChildItemOffset);
  NavBarAccordionControlContentContainerPadding := GetPropertyByName(GroupNavBar, sdxNavBarAccordionControlContentContainerPadding) as TdxSkinRectProperty;
  NavBarAccordionControlDistanceBetweenRootGroups := GetIntegerPropertyByName(GroupNavBar, sdxNavBarAccordionControlDistanceBetweenRootGroups);
  NavBarAccordionControlGroup := GetElementByName(GroupNavBar, sdxNavBarAccordionControlGroup);
  NavBarAccordionControlGroupCloseButton := GetElementByName(GroupNavBar, sdxNavBarAccordionControlGroupCloseButton);
  NavBarAccordionControlGroupOpenButton := GetElementByName(GroupNavBar, sdxNavBarAccordionControlGroupOpenButton);
  NavBarAccordionControlItem := GetElementByName(GroupNavBar, sdxNavBarAccordionControlItem);
  NavBarAccordionControlRootGroup := GetElementByName(GroupNavBar, sdxNavBarAccordionControlRootGroup);
  NavBarAccordionControlRootGroupCloseButton := GetElementByName(GroupNavBar, sdxNavBarAccordionControlRootGroupCloseButton);
  NavBarAccordionControlRootGroupOpenButton := GetElementByName(GroupNavBar, sdxNavBarAccordionControlRootGroupOpenButton);
  NavBarAccordionControlSearchButton := GetElementByName(GroupNavBar, sdxNavBarAccordionControlSearchButton);
  NavBarAccordionControlSearchButtonGlyphToTextIndent := GetIntegerPropertyByName(
    NavBarAccordionControlSearchButton, sdxNavBarAccordionControlGlyphToTextIndent);

  NavBarBackgroundColor := GetElementByName(GroupNavBar, sdxNavBarBackground);
  NavBarGroupClient := GetElementByName(GroupNavBar, sdxNavBarGroupClient);
  NavBarItem := GetElementByName(GroupNavBar, sdxNavBarItem);
  NavBarGroupHeader := GetElementByName(GroupNavBar, sdxNavBarGroupHeader);
  NavBarGroupButtons[True] := GetElementByName(GroupNavBar, sdxNavBarGroupCloseButton);
  NavBarGroupButtons[False] := GetElementByName(GroupNavBar, sdxNavBarGroupOpenButton);

  NavPaneCollapseButton := GetElementByName(GroupNavPane, sdxNavPaneCollapseButton);
  NavPaneCollapsedGroupClient := GetElementByName(GroupNavPane, sdxNavPaneCollapsedGroupClient);
  NavPaneExpandButton := GetElementByName(GroupNavPane, sdxNavPaneExpandButton);
  NavPaneFormBorder := GetElementByName(GroupNavPane, sdxNavPaneFormBorder);
  NavPaneFormSizeGrip := GetElementByName(GroupNavPane, sdxNavPaneFormSizeGrip);
  NavPaneGroupButton[False] := GetElementByName(GroupNavPane, sdxNavPaneGroupButton);
  NavPaneGroupButton[True] := GetElementByName(GroupNavPane, sdxNavPaneGroupButtonSelected);
  NavPaneGroupCaption := GetElementByName(GroupNavPane, sdxNavPaneGroupCaption);
  NavPaneSplitter := GetElementByName(GroupNavPane, sdxNavPaneSplitter);
  NavPaneScrollButtons[False] := GetElementByName(GroupNavPane, sdxNavPaneScrollUpBtn);
  NavPaneScrollButtons[True] := GetElementByName(GroupNavPane, sdxNavPaneScrollDownBtn);
  NavPaneOverflowPanel := GetElementByName(GroupNavPane, sdxNavPaneOverflowPanel);
  NavPaneOverflowPanelItem := GetElementByName(GroupNavPane, sdxNavPaneOverflowPanelItem);
  NavPaneOverflowPanelExpandedItem := GetElementByName(GroupNavPane, sdxNavPaneOverflowPanelExpandItem);
  NavPaneGroupClient := GetElementByName(GroupNavPane, sdxNavPaneGroupClient);
  NavPaneItem := GetElementByName(GroupNavPane, sdxNavPaneItem);
  NavPaneSelectedItem := GetElementByName(GroupNavPane, sdxNavPaneItemSelected);
  NavPaneCaptionHeight := GetIntegerPropertyByName(NavPaneGroupCaption, sdxNavPaneCaptionHeight);
  NavPaneCaptionFontSize := GetIntegerPropertyByName(NavPaneGroupCaption, sdxFontSize);

  NavPaneOfficeNavigationBar := GetElementByName(GroupNavPane, sdxNavPaneOfficeNavigationBar);
  NavPaneOfficeNavigationBarItem := GetElementByName(GroupNavPane, sdxNavPaneOfficeNavigationBarItem);
  NavPaneOfficeNavigationBarItemFontDelta := GetIntegerPropertyValue(NavPaneOfficeNavigationBarItem, sdxCaptionFontDelta);
  NavPaneOfficeNavigationBarSkinningItem := GetElementByName(GroupNavPane, sdxNavPaneOfficeNavigationBarSkinningItem);
  NavPaneOfficeNavigationBarSkinningItemFontDelta := GetIntegerPropertyValue(NavPaneOfficeNavigationBarSkinningItem, sdxCaptionFontDelta);

  if Assigned(GroupNavPane) then
    NavPaneOffsetGroupBorders := GroupNavPane.GetPropertyByName(sdxNavPaneOffsetGroupBorders) as TdxSkinBooleanProperty
  else
    NavPaneOffsetGroupBorders := nil;
end;

procedure TdxSkinInfo.InitializeNavigatorElements;
begin
  NavigatorButton := GetElementByName(GroupEditors, sdxNavigatorButton);
  NavigatorGlyphs := GetElementByName(GroupEditors, sdxNavigatorGlyphs);
  NavigatorGlyphsVert := GetElementByName(GroupEditors, sdxNavigatorGlyphsVert);
  NavigatorInfoPanel := GetElementByName(GroupEditors, sdxNavigatorInfoPanel, False);
end;

procedure TdxSkinInfo.InitializePageControlElements;
begin
  PageControlHeader := GetElementByName(GroupTabs, sdxPageControlHeader);
  PageControlButton := GetElementByName(GroupTabs, sdxPageControlButton);
  PageControlButtonHorz := GetElementByName(GroupTabs, sdxPageControlHorz);
  PageControlButtonVert := GetElementByName(GroupTabs, sdxPageControlVert);
  PageControlHeaderButton := GetElementByName(GroupTabs, sdxPageControlHeaderButton);
  PageControlCloseButton := GetElementByName(GroupTabs, sdxPageControlHeaderCloseButton);
  PageControlPane := GetElementByName(GroupTabs, sdxPageControlPane);

  PageControlIndents[0] := GetIntegerPropertyValue(GroupTabs, sdxRowIndentFar);
  PageControlIndents[1] := GetIntegerPropertyValue(GroupTabs, sdxRowIndentNear);
  PageControlIndents[2] := GetIntegerPropertyValue(GroupTabs, sdxSelectedHeaderDownGrow);
  PageControlIndents[3] := GetIntegerPropertyValue(GroupTabs, sdxSelectedHeaderHGrow);
  PageControlIndents[4] := GetIntegerPropertyValue(GroupTabs, sdxSelectedHeaderUpGrow);
  PageControlIndents[5] := GetIntegerPropertyValue(GroupTabs, sdxHeaderDownGrow);
  PageControlIndents[6] := GetIntegerPropertyValue(GroupTabs, sdxHeaderDownGrowBottomRight);
  PageControlIndents[7] := GetIntegerPropertyValue(GroupTabs, sdxSelectedHeaderDownGrowBottomRight);
end;

procedure TdxSkinInfo.InitializePDFViewerElements;
begin
  PDFViewerFindPanel := GetElementByName(GroupPDFViewer, sdxSkinsPDFViewerFindPanel);
  PDFViewerSelectionColor := GetColorByName(GroupPDFViewer, sdxSkinsPDFViewerSelectionColor);

  PDFViewerNavigationPaneBackground := GetElementByName(GroupPDFViewer, sdxSkinsPDFViewerNavigationPaneBackground);
  PDFViewerNavigationPaneButton := GetElementByName(GroupPDFViewer, sdxSkinsPDFViewerNavigationPaneButton);
  PDFViewerNavigationPaneButtonArrow := GetElementByName(GroupPDFViewer, sdxSkinsPDFViewerNavigationPaneButtonArrow);
  PDFViewerNavigationPaneButtonMinimized := GetElementByName(GroupPDFViewer, sdxSkinsPDFViewerNavigationPaneButtonMinimized);
  PDFViewerNavigationPanePageBackground := GetElementByName(GroupPDFViewer, sdxSkinsPDFViewerNavigationPanePageBackground);
  PDFViewerNavigationPanePageButton := GetElementByName(GroupPDFViewer, sdxSkinsPDFViewerNavigationPanePageButton);
  PDFViewerNavigationPanePageCaption := GetElementByName(GroupPDFViewer, sdxSkinsPDFViewerNavigationPanePageCaption);

  PDFViewerNavigationPaneSelectedPageExpandValue := GetIntegerPropertyByName(GroupPDFViewer, sdxSkinsPDFViewerNavigationPaneSelectedPageExpandValue);
  PDFViewerNavigationPaneSelectedPageOverlapValue := GetIntegerPropertyByName(GroupPDFViewer, sdxSkinsPDFViewerNavigationPaneSelectedPageOverlapValue);
end;

procedure TdxSkinInfo.InitializeProgressBarElements;

  procedure InitializeLegacyTextColor(AElement: TdxSkinElement; const APropertyName: string);
  begin
    if (AElement <> nil) and not cxColorIsValid(AElement.TextColor) then
      AElement.TextColor := GetColorValueByName(GroupEditors, APropertyName);
  end;

var
  APart: TcxProgressBarPart;
  AVertical: Boolean;
begin
  for AVertical := False to True do
    for APart := Low(TcxProgressBarPart) to High(TcxProgressBarPart) do
    begin
      ProgressBarParts[AVertical, APart] := GetElementByName(GroupEditors,
        ProgressBarPartNameMap[APart] + IfThen(AVertical, sdxSkinVerticalSuffix, ''), False);
    end;

  InitializeLegacyTextColor(ProgressBarParts[False, pbpProgressChunk], 'ProgressBarFilledTextColor');
  InitializeLegacyTextColor(ProgressBarParts[False, pbpBackground], 'ProgressBarEmptyTextColor');
end;

procedure TdxSkinInfo.InitializeRadioGroupElements;
begin
  RadioGroupButton := GetElementByName(GroupEditors, sdxRadioButton);
end;

procedure TdxSkinInfo.InitializeRangeControlElements;
begin
  RangeControlBorder := GetElementByName(GroupEditors, sdxRangeControlBorder);
  RangeControlLeftThumb := GetElementByName(GroupEditors, sdxRangeControlLeftThumb);
  RangeControlRightThumb := GetElementByName(GroupEditors, sdxRangeControlRightThumb);
  RangeControlRulerHeader := GetElementByName(GroupEditors, sdxRangeControlRulerHeader);
  RangeControlSizingGlyph := GetElementByName(GroupEditors, sdxRangeControlSizingGlyph);

  RangeControlDefaultElementColor := GetColorByName(RangeControlBorder, sdxRangeControlDefaultElementColor);
  RangeControlElementBaseColor := GetColorByName(RangeControlBorder, sdxRangeControlElementBaseColor);
  RangeControlElementFontSize := GetIntegerPropertyByName(RangeControlBorder, sdxRangeControlElementFontSize);
  RangeControlElementForeColor := GetColorByName(RangeControlBorder, sdxRangeControlElementForeColor);
  RangeControlLabelColor := GetColorByName(RangeControlBorder, sdxRangeControlLabelColor);
  RangeControlOutOfRangeColorMask := GetAlphaColorValueByName(RangeControlBorder, sdxRangeControlOutOfRangeColorMask);
  RangeControlRangePreviewColor := GetColorByName(RangeControlBorder, sdxRangeControlRangePreviewColor);
  RangeControlRuleColor := GetAlphaColorValueByName(RangeControlBorder, sdxRangeControlRuleColor);
  RangeControlScrollAreaColor := GetColorByName(RangeControlBorder, sdxRangeControlScrollAreaColor);
  RangeControlScrollAreaHeight := GetIntegerPropertyByName(RangeControlBorder, sdxRangeControlScrollAreaHeight);
  RangeControlSelectionBorderColor := GetAlphaColorValueByName(RangeControlBorder, sdxRangeControlSelectionBorderColor);
  RangeControlSelectionColor := GetAlphaColorValueByName(RangeControlBorder, sdxRangeControlSelectionColor);
  RangeControlViewPortPreviewColor := GetColorByName(RangeControlBorder, sdxRangeControlViewPortPreviewColor);
  RangeControlBackColor := GetAlphaColorValueByName(RangeControlBorder, sdxRangeControlBackColor);
  RangeControlInnerBorderColor := GetAlphaColorValueByName(RangeControlBorder, sdxRangeControlInnerBorderColor);
end;

procedure TdxSkinInfo.InitializeRibbonColors;

  function GetElementTextColor(AElement: TdxSkinElement): TColor;
  begin
    if AElement = nil then
      Result := clDefault
    else
      Result := AElement.TextColor;
  end;

begin
  RibbonEditorBackground := GetColorByName(GroupRibbon, sdxRibbonEditorBackground);
  RibbonExtraPaneColor := GetColorByName(GroupRibbon, sdxRibbonExtraPaneColor);
  RibbonExtraPaneHeaderSeparator := GetColorByName(GroupRibbon, sdxRibbonExtraPaneHeaderSeparator);

  RibbonCaptionText[False] := GetColorValueByName(RibbonFormCaption, sdxTextColorInactive);
  RibbonCaptionText[True] := GetElementTextColor(RibbonFormCaption);
  RibbonTabTextHot := GetColorValueByName(RibbonTab, sdxTextColorHot);
  RibbonTabText[True] := GetColorValueByName(RibbonTab, sdxTextColorSelected);
  RibbonTabText[False] := GetElementTextColor(RibbonTab);
  RibbonContextualTabHeaderText[True] :=  GetColorValueByName(RibbonContextualTabHeader, sdxTextColorSelected);
  RibbonContextualTabHeaderText[False] := GetElementTextColor(RibbonContextualTabHeader);
  RibbonContextualTabHeaderTextHot := GetColorValueByName(RibbonContextualTabHeader, sdxTextColorHot);
  RibbonDocumentNameTextColor[True] := GetColorValueByName(RibbonFormCaption, sdxRibbonDocumentNameTextColor);
  RibbonDocumentNameTextColor[False] := RibbonCaptionText[False];
  RibbonStatusBarTextSelected := GetColorValueByName(RibbonStatusBarButton, sdxTextColorSelected);
  RibbonButtonDisabledTextColor := GetColorValueByName(GroupRibbon, sdxRibbonButtonDisabledText);
end;

procedure TdxSkinInfo.InitializeRichEditElements;
begin
  RichEditCornerPanel := GetElementByName(GroupRichEdit, sdxRichEditCornerPanel);
  RichEditRulerBackgroundHorz := GetElementByName(GroupRichEdit, sdxRichEditRulerBackgroundHorz);
  RichEditRulerBackgroundVert := GetElementByName(GroupRichEdit, sdxRichEditRulerBackgroundVert);
  RichEditRulerColumnResizer := GetElementByName(GroupRichEdit, sdxRichEditRulerColumnResizer);
  RichEditRulerDefaultTabColor := GetColorByName(GroupRichEdit, sdxRichEditRulerDefaultTabColor);
  RichEditRulerIndent := GetElementByName(GroupRichEdit, sdxRichEditRulerIndent);
  RichEditRulerIndentBottom := GetElementByName(GroupRichEdit, sdxRichEditRulerIndentBottom);
  RichEditRulerRightMargin := GetElementByName(GroupRichEdit, sdxRichEditRulerRightMargin);
  RichEditRulerSection := GetElementByName(GroupRichEdit, sdxRichEditRulerSection);
  RichEditRulerTab := GetElementByName(GroupRichEdit, sdxRichEditRulerTab);
  RichEditRulerTabTypeBackground := GetElementByName(GroupRichEdit, sdxRichEditRulerTabTypeBackground);
  RichEditRulerTextColor := GetColorByName(GroupRichEdit, sdxRichEditRulerTextColor);
end;

procedure TdxSkinInfo.InitializeRibbonElements;
begin
  RadialMenuBackgroundColor := GetColorByName(GroupRibbon, sdxSkinsRadialMenuBackgroundColor);
  RadialMenuBaseColor := GetColorByName(GroupRibbon, sdxSkinsRadialMenuBaseColor);

  RibbonApplicationBackground := GetElementByName(GroupRibbon, sdxRibbonAppMenuBackground);
  RibbonApplicationButton := GetElementByName(GroupRibbon, sdxRibbonApplicationButton);
  RibbonApplicationButton2010 := GetElementByName(GroupRibbon, sdxRibbonApplicationButton2010);
  RibbonApplicationFooterBackground := GetElementByName(GroupRibbon, sdxRibbonAppMenuFooterBackground);
  RibbonApplicationHeaderBackground := GetElementByName(GroupRibbon, sdxRibbonAppMenuHeaderBackground);
  RibbonExtraPanePinButtonGlyph := GetElementByName(GroupRibbon, sdxRibbonExtraPanePinButtonGlyph, False);
  RibbonExtraPaneButton := GetElementByName(GroupRibbon, sdxRibbonExtraPaneButton);

  RibbonBackstageView := GetElementByName(GroupRibbon, sdxRibbonBackstageViewBackground);
  RibbonBackstageViewBackButton := GetElementByName(GroupRibbon, sdxRibbonBackstageViewBackButton);
  RibbonBackstageViewImage := GetElementByName(GroupRibbon, sdxRibbonBackstageViewImage);
  RibbonBackstageViewMenu := GetElementByName(GroupRibbon, sdxRibbonBackstageViewMenuBackground);
  RibbonBackstageViewMenuHeader := GetElementByName(GroupRibbon, sdxRibbonBackstageViewMenuHeader);
  RibbonBackstageViewMenuButton := GetElementByName(GroupRibbon, sdxRibbonBackstageViewMenuButton);
  RibbonBackstageViewMenuSeparator := GetElementByName(GroupRibbon, sdxRibbonBackstageViewMenuSeparator);
  RibbonBackstageViewTab := GetElementByName(GroupRibbon, sdxRibbonBackstageViewTabHeader);
  RibbonBackstageViewTabArrow := GetElementByName(GroupRibbon, sdxRibbonBackstageViewTabHeaderArrow, False);

  RibbonCollapsedToolBarBackground := GetElementByName(GroupRibbon, sdxRibbonCollapsedToolBarBackground);
  RibbonCollapsedToolBarGlyphBackground := GetElementByName(GroupRibbon, sdxRibbonCollapsedToolBarGlyphBackground);

  RibbonFormButtonAutoHideModeShowUI := GetElementByName(GroupRibbon, sdxRibbonFormButtonAutoHideModeShowUI);
  RibbonFormButtonDisplayOptions := GetElementByName(GroupRibbon, sdxRibbonFormButtonDisplayOptions);
  RibbonFormButtonClose := GetElementByName(GroupRibbon, sdxFormButtonClose);
  RibbonFormButtonHelp := GetElementByName(GroupRibbon, sdxFormButtonHelp);
  RibbonFormButtonMaximize := GetElementByName(GroupRibbon, sdxFormButtonMaximize);
  RibbonFormButtonMinimize := GetElementByName(GroupRibbon, sdxFormButtonMinimize);
  RibbonFormButtonRestore := GetElementByName(GroupRibbon, sdxFormButtonRestore);

  RibbonFormCaption := GetFormFrameElementByName(GroupRibbon, sdxRibbonFormCaption);
  RibbonFormCaptionRibbonHidden := GetFormFrameElementByName(GroupRibbon, sdxRibbonFormCaptionRibbonHidden, False);
  RibbonFormContent := GetFormFrameElementByName(GroupRibbon, sdxRibbonFormContent);
  RibbonFormBottom[False] := GetFormFrameElementByName(GroupRibbon, sdxRibbonFormBottom);
  RibbonFormBottom[True] := GetFormFrameElementByName(GroupRibbon, sdxRibbonDialogFrameBottom);
  RibbonFormLeft[False] := GetFormFrameElementByName(GroupRibbon, sdxRibbonFormFrameLeft);
  RibbonFormLeft[True] := GetFormFrameElementByName(GroupRibbon, sdxRibbonDialogFrameLeft);
  RibbonFormRight[False] := GetFormFrameElementByName(GroupRibbon, sdxRibbonFormFrameRight);
  RibbonFormRight[True] := GetFormFrameElementByName(GroupRibbon, sdxRibbonDialogFrameRight);

  RibbonUseRoundedWindowCorners := GetBoolPropertyByName(GroupRibbon, sdxRibbonUseRoundedWindowCorners);
  RibbonMinimizeButtonGlyph := GetElementByName(GroupRibbon, sdxRibbonMinimizeButtonGlyph);
  RibbonTab := GetElementByName(GroupRibbon, sdxRibbonTabHeaderPage);
  RibbonTabPanel := GetElementByName(GroupRibbon, sdxRibbonTabPanel);
  RibbonTabPanelWithQATBelow := GetElementByName(GroupRibbon, sdxRibbonTabPanelWithQATBelow, False);
  RibbonTabPanelBottomIndent := GetIntegerPropertyByName(RibbonTabPanel, sdxRibbonTabPanelBottomIndent);
  RibbonTabPanelGroupButton := GetElementByName(GroupRibbon, sdxRibbonTabPanelGroupButton);
  RibbonTabPanelHorizontalMargin := GetRectPropertyByName(RibbonTabPanel, sdxRibbonTabPanelHorizontalMargin);
  RibbonTabSeparatorLine := GetElementByName(GroupRibbon, sdxRibbonTabSeparatorLine);
  RibbonTabGroup := GetElementByName(GroupRibbon, sdxRibbonTabGroup);
  RibbonTabGroupHeader := GetElementByName(GroupRibbon, sdxRibbonTabGroupHeader);
  RibbonTabGroupItemsSeparator := GetElementByName(GroupRibbon, sdxRibbonTabGroupItemsSeparator);

  RibbonGalleryBackground := GetElementByName(GroupRibbon, sdxRibbonGalleryBackground);
  RibbonGalleryButtonDown := GetElementByName(GroupRibbon, sdxRibbonGalleryButtonDown);
  RibbonGalleryButtonDropDown := GetElementByName(GroupRibbon, sdxRibbonGalleryButtonDropDown);
  RibbonGalleryButtonUp := GetElementByName(GroupRibbon, sdxRibbonGalleryButtonUp);
  RibbonGalleryItem := GetElementByName(GroupRibbon, sdxRibbonGalleryItem, False);
  RibbonGalleryItemImage := GetElementByName(GroupRibbon, sdxRibbonGalleryItemImage, False);

  DropDownGalleryBackground := GetElementByName(GroupRibbon, sdxDropDownGalleryBackground);
  DropDownGalleryFilterPanel := GetElementByName(GroupRibbon, sdxDropDownGalleryFilterPanel, False);
  DropDownGalleryGroupHeader := GetElementByName(GroupRibbon, sdxDropDownGalleryGroupHeader);
  DropDownGalleryItem := GetElementByName(GroupRibbon, sdxDropDownGalleryItem, False);
  DropDownGalleryItemCaption := GetElementByName(GroupRibbon, sdxDropDownGalleryItemCaption, False);
  DropDownGalleryItemDescription := GetElementByName(GroupRibbon, sdxDropDownGalleryItemDescription, False);
  DropDownGalleryItemImage := GetElementByName(GroupRibbon, sdxDropDownGalleryItemImage, False);
  DropDownGallerySizeGrips := GetElementByName(GroupRibbon, sdxDropDownGallerySizeGrips);
  DropDownGallerySizingPanel := GetElementByName(GroupRibbon, sdxDropDownGallerySizingPanel);

  RibbonHeaderBackground := GetElementByName(GroupRibbon, sdxRibbonHeaderBackground);
  RibbonHeaderBackgroundOnGlass := GetElementByName(GroupRibbon, sdxRibbonHeaderBackgroundOnGlass);
  RibbonSmallButton := GetElementByName(GroupRibbon, sdxRibbonSmallButton);
  RibbonSplitButtonLeft := GetElementByName(GroupRibbon, sdxRibbonSplitButtonLeft);
  RibbonSplitButtonRight := GetElementByName(GroupRibbon, sdxRibbonSplitButtonRight);
  RibbonKeyTip := GetElementByName(GroupRibbon, sdxRibbonKeyTip);
  RibbonLargeButton := GetElementByName(GroupRibbon, sdxRibbonLargeButton);
  RibbonLargeSplitButtonTop := GetElementByName(GroupRibbon, sdxRibbonLargeSplitButtonTop);
  RibbonLargeSplitButtonBottom := GetElementByName(GroupRibbon, sdxRibbonLargeSplitButtonBottom);
  RibbonButtonArrow := GetElementByName(GroupRibbon, sdxRibbonButtonArrow);
  RibbonButtonGroup := GetElementByName(GroupRibbon, sdxRibbonButtonGroup);
  RibbonStatusBarBackground := GetElementByName(GroupRibbon, sdxRibbonStatusBarBackground);
  RibbonStatusBarButton := GetElementByName(GroupRibbon, sdxRibbonStatusBarButton);
  RibbonStatusBarSeparator := GetElementByName(GroupRibbon, sdxRibbonStatusBarSeparator);
  RibbonQuickToolbar[qatpAbove] := GetElementByName(GroupRibbon, sdxRibbonQuickToolbarAbove);
  RibbonQuickToolbar[qatpBelow] := GetElementByName(GroupRibbon, sdxRibbonQuickToolbarBelow);
  RibbonQuickToolbar[qatpInRibbon] := GetElementByName(GroupRibbon, sdxRibbonQuickToolbarBelow);
  RibbonQuickToolbar[qatpInCaption] := GetElementByName(GroupRibbon, sdxRibbonQuickToolbarInCaption);
  RibbonQuickToolbarSingle := GetElementByName(GroupRibbon, sdxRibbonQuickToolbarSingle, False);
  RibbonQuickToolbarButton[qatpAbove] := GetElementByName(GroupRibbon, sdxRibbonQuickToolbarAboveButton, False);
  RibbonQuickToolbarButton[qatpBelow] := GetElementByName(GroupRibbon, sdxRibbonQuickToolbarBelowButton, False);
  RibbonQuickToolbarButton[qatpInRibbon] := GetElementByName(GroupRibbon, sdxRibbonQuickToolbarBelowButton, False);
  RibbonQuickToolbarButton[qatpInCaption] := GetElementByName(GroupRibbon, sdxRibbonQuickToolbarInCaptionButton, False);
  RibbonQuickToolbarButtonArrow[qatpAbove] := GetElementByName(GroupRibbon, sdxRibbonQuickToolbarButtonArrowInAbove, False);
  RibbonQuickToolbarButtonArrow[qatpBelow] := GetElementByName(GroupRibbon, sdxRibbonQuickToolbarButtonArrowInBelow, False);
  RibbonQuickToolbarButtonArrow[qatpInRibbon] := GetElementByName(GroupRibbon, sdxRibbonQuickToolbarButtonArrowInBelow, False);
  RibbonQuickToolbarButtonArrow[qatpInCaption] := GetElementByName(GroupRibbon, sdxRibbonQuickToolbarButtonArrowInCaption, False);
  RibbonQuickToolbarButtonGlyph[qatpAbove] := GetElementByName(GroupRibbon, sdxRibbonQuickToolbarButtonGlyphInAbove, False);
  RibbonQuickToolbarButtonGlyph[qatpBelow] := GetElementByName(GroupRibbon, sdxRibbonQuickToolbarButtonGlyphInBelow, False);
  RibbonQuickToolbarButtonGlyph[qatpInRibbon] := GetElementByName(GroupRibbon, sdxRibbonQuickToolbarButtonGlyphInBelow, False);
  RibbonQuickToolbarButtonGlyph[qatpInCaption] := GetElementByName(GroupRibbon, sdxRibbonQuickToolbarButtonGlyphInCaption, False);
  RibbonQuickToolbarButtonGlyphDefault := GetElementByName(GroupRibbon, sdxRibbonQuickToolbarButtonGlyph);
  RibbonQuickToolbarDropDown := GetElementByName(GroupRibbon, sdxRibbonQuickToolbarDropDown);
  RibbonQuickToolbarGlyph[qatpAbove] := GetElementByName(GroupRibbon, sdxRibbonQuickToolbarGlyphInAbove, False);
  RibbonQuickToolbarGlyph[qatpBelow] := GetElementByName(GroupRibbon, sdxRibbonQuickToolbarGlyphInBelow, False);
  RibbonQuickToolbarGlyph[qatpInRibbon] := GetElementByName(GroupRibbon, sdxRibbonQuickToolbarGlyphInBelow, False);
  RibbonQuickToolbarGlyph[qatpInCaption] := GetElementByName(GroupRibbon, sdxRibbonQuickToolbarGlyphInCaption, False);
  RibbonQuickToolbarGlyphDefault := GetElementByName(GroupRibbon, sdxRibbonQuickToolbarGlyph);
  RibbonButtonGroupButton := GetElementByName(GroupRibbon, sdxRibbonButtonGroupButton);
  RibbonButtonGroupSeparator := GetElementByName(GroupRibbon, sdxRibbonButtonGroupSeparator);
  RibbonButtonGroupSplitButtonLeft := GetElementByName(GroupRibbon, sdxRibbonButtonGroupSplitButtonLeft);
  RibbonButtonGroupSplitButtonRight := GetElementByName(GroupRibbon, sdxRibbonButtonGroupSplitButtonRight);
  RibbonGroupScroll[True] := GetElementByName(GroupRibbon, sdxRibbonTabGroupLeftScroll);
  RibbonGroupScroll[False] := GetElementByName(GroupRibbon, sdxRibbonTabGroupRightScroll);
  RibbonContextualTabLabel := GetElementByName(GroupRibbon, sdxRibbonContextualTabLabel);
  RibbonContextualTabLabelShadowColor := GetColorByName(RibbonContextualTabLabel, sdxTextShadowColor);
  RibbonContextualTabLabelOnGlass := GetElementByName(GroupRibbon, sdxRibbonContextualTabLabelOnGlass);
  RibbonContextualTabLabelOnGlassShadowColor := GetColorByName(RibbonContextualTabLabelOnGlass, sdxTextShadowColor);
  RibbonContextualTabSeparator := GetElementByName(GroupRibbon, sdxRibbonContextualTabSeparator);
  RibbonContextualTabHeader := GetElementByName(GroupRibbon, sdxRibbonContextualTabHeader);
  RibbonContextualTabPanel := GetElementByName(GroupRibbon, sdxRibbonContextualTabPanel);
  RibbonContextualTabPanelWithQATBelow := GetElementByName(GroupRibbon, sdxRibbonContextualTabPanelWithQATBelow, False);
  InitializeRibbonProperties;
  InitializeRibbonColors;

  SetUseCache(RibbonLargeButton);
  SetUseCache(RibbonSmallButton);
end;

procedure TdxSkinInfo.InitializeRibbonProperties;
var
  AIndex: TdxQATPosition;
begin
  for AIndex := Low(TdxQATPosition) to High(TdxQATPosition) do
  begin
    RibbonQATCustomizeButtonOutsizeQAT[AIndex] :=
      GetBoolPropertyByName(RibbonQuickToolbar[AIndex], sdxRibbonQATCustomizeButtonOutsideQAT);
    RibbonQATIndentBeforeCustomizeButton[AIndex] :=
      GetIntegerPropertyByName(RibbonQuickToolbar[AIndex], sdxRibbonQATIndentBeforeCustomizeItem);
  end;
  RibbonCaptionFontDelta := GetIntegerPropertyByName(RibbonFormCaption, sdxCaptionFontDelta);
  RibbonSpaceBetweenTabGroups := GetIntegerPropertyByName(GroupRibbon, sdxRibbonSpaceBetweenTabGroups);
  RibbonTabHeaderDownGrowIndent := GetIntegerPropertyByName(GroupRibbon, sdxRibbonTabHeaderDownGrowIndent);
  RibbonTabAeroSupport := GetBoolPropertyByName(GroupRibbon, sdxRibbonTabAeroSupport);
end;

procedure TdxSkinInfo.InitializeScrollBarElements;

  procedure SetInfo(AHorz: Boolean; APart: TcxScrollBarPart;
    AElement: TdxSkinElement; AImageIndex: Integer = 0);
  begin
    FreeAndNil(ScrollBar_Elements[AHorz, APart]);
    if Skin <> nil then
      ScrollBar_Elements[AHorz, APart] :=
        TdxSkinScrollInfo.Create(AElement, AImageIndex, APart);
  end;

var
  AElement: TdxSkinElement;
begin
  // buttons
  AElement := GetElementByName(GroupCommon, sdxScrollButton);
  SetInfo(False, sbpLineUp, AElement);
  SetInfo(False, sbpLineDown, AElement, 1);
  SetInfo(True, sbpLineUp, AElement, 2);
  SetInfo(True, sbpLineDown, AElement, 3);
  // Thumbnail
  SetInfo(False, sbpThumbnail, GetElementByName(GroupCommon, sdxScrollThumbButtonVert));
  SetInfo(True, sbpThumbnail, GetElementByName(GroupCommon, sdxScrollThumbButtonHorz));
  // Page
  AElement := GetElementByName(GroupCommon, sdxScrollContentVert);
  SetInfo(False, sbpPageUp, AElement);
  SetInfo(False, sbpPageDown, AElement);
  AElement := GetElementByName(GroupCommon, sdxScrollContentHorz);
  SetInfo(True, sbpPageUp, AElement);
  SetInfo(True, sbpPageDown, AElement);
end;

procedure TdxSkinInfo.InitializeSchedulerElements;
var
  I: Integer;
begin
  for I := 0 to dxSkinsSchedulerResourceColorsCount - 1 do
    SchedulerResourceColors[I] := GetColorByName(GroupScheduler, Format(sdxSchedulerResourceColor, [I + 1]));
  SchedulerTimeGridHeader[False] := GetElementByName(GroupScheduler, sdxSchedulerTimeGridHeader);
  SchedulerTimeGridHeader[True] := GetElementByName(GroupScheduler, sdxSchedulerTimeGridHeaderSelected);
  SchedulerTimeLine := GetElementByName(GroupScheduler, sdxSchedulerTimeLine);
  SchedulerTimeRuler := GetElementByName(GroupScheduler, sdxSchedulerTimeRuler);
  SchedulerMoreButton := GetElementByName(GroupScheduler, sdxSchedulerMoreButton);
  SchedulerAppointment[False] := GetElementByName(GroupScheduler, sdxSchedulerAppointmentRight);
  SchedulerAppointment[True] := GetElementByName(GroupScheduler, sdxSchedulerAppointment);
  SchedulerAllDayArea[False] := GetElementByName(GroupScheduler, sdxSchedulerAllDayArea);
  SchedulerAllDayArea[True] := GetElementByName(GroupScheduler, sdxSchedulerAllDayAreaSelected);
  SchedulerCurrentTimeIndicator := GetElementByName(GroupScheduler, sdxSchedulerCurrentTimeIndicator);
  SchedulerAppointmentShadow[False] := GetElementByName(GroupScheduler, sdxSchedulerAppointmentBottomShadow);
  SchedulerAppointmentShadow[True] := GetElementByName(GroupScheduler, sdxSchedulerAppointmentRightShadow);
  SchedulerAppointmentBorderSize := GetIntegerPropertyByName(SchedulerAppointment[True], sdxSchedulerAppointmentBorderSize);
  SchedulerAppointmentMask := GetElementByName(GroupScheduler, sdxSchedulerAppointmentMask);
  SchedulerAppointmentBorder := GetColorByName(SchedulerAppointment[True], sdxSchedulerSeparatorColor);
  SchedulerGroup := GetElementByName(GroupScheduler, sdxSchedulerGroup);
  SchedulerMilestone := GetElementByName(GroupScheduler, sdxSchedulerMilestone);
  SchedulerNavigationButtons[False] := GetElementByName(GroupScheduler, sdxSchedulerNavButtonPrev);
  SchedulerNavigationButtons[True] := GetElementByName(GroupScheduler, sdxSchedulerNavButtonNext);
  SchedulerNavigationButtonsArrow[False] := GetElementByName(GroupScheduler, sdxSchedulerNavButtonPrevArrow);
  SchedulerNavigationButtonsArrow[True] := GetElementByName(GroupScheduler, sdxSchedulerNavButtonNextArrow);
  SchedulerTimeGridCurrentTimeIndicator := GetElementByName(GroupScheduler, sdxSchedulerTimeGridCurrentTimeIndicator);
  SchedulerLabelCircle := GetElementByName(GroupScheduler, sdxSchedulerLabelCircle);
  SchedulerTaskExpandButton := GetElementByName(GroupScheduler, sdxSchedulerTaskExpandButton, False);

  SetUseCache(SchedulerAppointment[False], 64);
  SetUseCache(SchedulerAppointment[True], 64);
  SetUseCache(SchedulerAllDayArea[False]);
  SetUseCache(SchedulerAllDayArea[True]);
  SetUseCache(SchedulerTimeRuler);
end;

procedure TdxSkinInfo.InitializeSizeGripElements;
begin
  SizeGrip := GetElementByName(GroupCommon, sdxSizeGrip);
end;

procedure TdxSkinInfo.InitializeSplitterElements;
begin
  Splitter[False] := GetElementByName(GroupCommon, sdxSplitterVert);
  Splitter[True] := GetElementByName(GroupCommon, sdxSplitterHorz);
end;

procedure TdxSkinInfo.InitializeTileControlElements;
begin
  TileControlActionBar := GetElementByName(GroupTileControl, sdxTileControlActionBar);
  TileControlBackground := GetElementByName(GroupTileControl, sdxTileControlBackground);
  TileControlItem := GetElementByName(GroupTileControl, sdxTileControlItem);
  TileControlItemCheck := GetElementByName(GroupTileControl, sdxTileControlItemCheck);
  TileControlGroupCaption := GetElementByName(GroupTileControl, sdxTileControlGroupCaption);
  TileControlGroupCaptionFontDelta := GetIntegerPropertyValue(TileControlGroupCaption, sdxCaptionFontDelta);
  TileControlVirtualGroup := GetElementByName(GroupTileControl, sdxTileControlVirtualGroup);
  TileControlTitle := GetElementByName(GroupTileControl, sdxTileControlTitle);
  TileControlTitleFontDelta := GetIntegerPropertyValue(TileControlTitle, sdxCaptionFontDelta);
  TileControlTabHeader := GetElementByName(GroupTileControl, sdxTileControlTabHeader);
  TileControlTabHeaderFontDelta := GetIntegerPropertyValue(TileControlTabHeader, sdxCaptionFontDelta);
  TileControlSelectionFocusedColor := GetColorValueByName(GroupTileControl, sdxTileControlSelectionFocusedColor);
  TileControlSelectionHotColor := GetColorValueByName(GroupTileControl, sdxTileControlSelectionHotColor);
end;

procedure TdxSkinInfo.InitializeToggleSwitchElements;
begin
  ToggleSwitch := GetElementByName(GroupEditors, sdxToggleSwitch);
  ToggleSwitchThumb := GetElementByName(GroupEditors, sdxToggleSwitchThumb);
  ToggleSwitchTextMargin := GetIntegerPropertyByName(ToggleSwitch, sdxToggleSwitchTextMargin);
end;

procedure TdxSkinInfo.InitializeToolTipElements;
begin
  ScreenTipWindow := GetElementByName(GroupBars, sdxScreenTipWindow);
  ScreenTipItem := GetColorByName(ScreenTipWindow, sdxScreenTipItem);
  ScreenTipTitleItem := GetColorByName(ScreenTipWindow, sdxScreenTipTitleItem);
  ScreenTipSeparator := GetElementByName(GroupBars, sdxScreenTipSeparator);
end;

procedure TdxSkinInfo.InitializeLayoutViewElements;
const
  LayoutViewRecordElementNameMap: array[TcxGroupBoxCaptionPosition] of string =
   (sdxLayoutViewRecordTop, sdxLayoutViewRecordBottom, sdxLayoutViewRecordLeft,
    sdxLayoutViewRecordRight, sdxLayoutViewRecord);
  LayoutViewRecordElementCaptionNameMap: array[TcxGroupBoxCaptionPosition] of string =
   (sdxLayoutViewRecordCaptionTop, sdxLayoutViewRecordCaptionBottom,
    sdxLayoutViewRecordCaptionLeft, sdxLayoutViewRecordCaptionRight, '');
var
  ACaptionPosition: TcxGroupBoxCaptionPosition;
  AElement: TcxLayoutElement;
begin
  LayoutViewItem := GetElementByName(GroupGrid, sdxLayoutViewItem);
  for AElement := Low(TcxLayoutElement) to High(TcxLayoutElement) do
  begin
    LayoutViewElementPadding[AElement] := GetPropertyByName(
      GroupGrid, LayoutViewElementPaddingMap[AElement]) as TdxSkinRectProperty;
    LayoutViewElementSpacing[AElement] := GetPropertyByName(
      GroupGrid, LayoutViewElementSpacingMap[AElement]) as TdxSkinRectProperty;
  end;

  LayoutViewRecordExpandButton := GetElementByName(GroupGrid, sdxLayoutViewRecordExpandButton);
  for ACaptionPosition := Low(ACaptionPosition) to High(ACaptionPosition) do
  begin
    LayoutViewRecordElements[ACaptionPosition] :=
      GetElementByName(GroupGrid, LayoutViewRecordElementNameMap[ACaptionPosition]);
    LayoutViewRecordCaptionElements[ACaptionPosition] := GetElementByName(
      GroupGrid, LayoutViewRecordElementCaptionNameMap[ACaptionPosition], ACaptionPosition <> cxgpCenter);
    LayoutViewRecordCaptionTailSizes[ACaptionPosition] := GetIntegerPropertyByName(
      LayoutViewRecordCaptionElements[ACaptionPosition], sdxGroupPanelCaptionTailSize);
    LayoutViewRecordCaptionTextPadding[ACaptionPosition] :=
      GetIntegerPropertyByName(GroupBoxCaptionElements[ACaptionPosition], sdxGroupPanelCaptionTextPadding);
  end;
end;

procedure TdxSkinInfo.InitializeListBoxElements;
begin
  HighlightedItem := GetElementByName(GroupCommon, sdxHighlightedItem);
  ListBoxBackground := GetElementByName(GroupCommon, sdxListBox, False);

  SetUseCache(HighlightedItem);
end;

procedure TdxSkinInfo.InitializeListViewElements;
begin
  ListViewItem := GetElementByName(GroupListView, sdxListViewItem);
  ListViewIcon := GetElementByName(GroupListView, sdxListViewIcon);
  ListViewGroup := GetElementByName(GroupListView, sdxListViewGroup);
  ListViewGroupLine := GetElementByName(GroupListView, sdxListViewGroupLine);
  ListViewGroupExpandButton := GetElementByName(GroupListView, sdxListViewGroupExpandButton);
end;

procedure TdxSkinInfo.InitializeMapControlElements;
const
  NamesMap: array[TcxButtonState] of string = ('', '', 'Highlighted', 'Selected', '');
var
  AElement: TdxSkinElement;
  AState: TcxButtonState;
begin
  MapControlBackColor := GetColorValueByName(GroupMapControl, sdxMapControlBackColor);

  MapControlCustomElement := GetElementByName(GroupMapControl, sdxMapControlCustomElement);
  MapControlCustomElementTextGlowColor := GetAlphaColorValueByName(MapControlCustomElement, sdxTextGlowColor);

  MapControlCallout := GetElementByName(GroupMapControl, sdxMapControlCallout);
  MapControlCalloutTextGlowColor := GetAlphaColorValueByName(MapControlCallout, sdxTextGlowColor);
  MapControlCalloutPointerHeight := GetIntegerPropertyValue(MapControlCallout, sdxMapControlCalloutPointerHeight);
  MapControlCalloutPointer := cxPoint(
    GetIntegerPropertyValue(MapControlCallout, sdxMapControlCalloutPointerX),
    GetIntegerPropertyValue(MapControlCallout, sdxMapControlCalloutPointerY));

  MapControlPushpin := GetElementByName(GroupMapControl, sdxMapControlPushpin);
  MapControlPushpinTextOrigin := cxPoint(
    GetIntegerPropertyValue(MapControlPushpin, sdxMapControlPushpinTextOriginX),
    GetIntegerPropertyValue(MapControlPushpin, sdxMapControlPushpinTextOriginY));
  MapControlPushpinTextGlowColor := GetAlphaColorValueByName(MapControlPushpin, sdxTextGlowColor);

  AElement := GetElementByName(GroupMapControl, sdxMapControlSelectedRegion);
  MapControlSelectedRegionBackgroundColor := GetAlphaColorValueByName(AElement, 'BackColor');
  MapControlSelectedRegionBorderColor := GetAlphaColorValueByName(AElement, sdxMapControlBorderColor);

  MapControlPanelBackColor := GetAlphaColorValueByName(GroupMapControl, sdxMapControlPanelBackColor);
  MapControlPanelHotTrackedTextColor := GetAlphaColorValueByName(GroupMapControl, sdxMapControlPanelHotTrackedTextColor);
  MapControlPanelPressedTextColor := GetAlphaColorValueByName(GroupMapControl, sdxMapControlPanelPressedTextColor);
  MapControlPanelTextColor := GetAlphaColorValueByName(GroupMapControl, sdxMapControlPanelTextColor);

  AElement := GetElementByName(GroupMapControl, sdxMapControlShape);
  for AState := Low(TcxButtonState) to High(TcxButtonState) do
  begin
    MapControlShapeBorderColor[AState] := GetAlphaColorValueByName(AElement, NamesMap[AState] + sdxMapControlBorderColor);
    MapControlShapeBorderWidth[AState] := GetIntegerPropertyValue(AElement, NamesMap[AState] + sdxMapControlBorderWidth);
    MapControlShapeColor[AState] := GetAlphaColorValueByName(AElement, IfThen(NamesMap[AState] <> '', NamesMap[AState], 'Back') + sdxColor);
  end;
end;

procedure TdxSkinInfo.InitializePrintingSystemElements;
begin
  PrintingPageBorder := GetElementByName(GroupPrintingSystem, sdxPrintingSystemPageBorder);
  if PrintingPageBorder <> nil then
    PrintingPageBorder.UseCache := True;
  PrintingPreviewBackground := GetElementByName(GroupPrintingSystem, sdxPrintingSystemPreviewBackground);
  if PrintingPreviewBackground <> nil then
    PrintingPreviewBackground.UseCache := True;
end;

procedure TdxSkinInfo.InitializeTrackBarElements;
begin
  RangeTrackBarThumbLeft := GetElementByName(GroupEditors, sdxRangeTrackBarThumbLeft);
  RangeTrackBarThumbRight := GetElementByName(GroupEditors, sdxRangeTrackBarThumbRight);
  RangeTrackBarThumbBoth := GetElementByName(GroupEditors, sdxRangeTrackBarThumbBoth);

  TrackBarTextColor := GetColorByName(GroupEditors, sdxTrackBarTextColor);
  TrackBarTickColor := GetColorByName(GroupEditors, sdxTrackBarTickColor);

  TrackBarTrack[True] := GetElementByName(GroupEditors, sdxTrackBarTrack);
  TrackBarTrack[False] := GetElementByName(GroupEditors, sdxTrackBarTrackVert);

  TrackBarThumb[True, tbtaDown] := GetElementByName(GroupEditors, sdxTrackBarThumb);
  TrackBarThumb[True, tbtaUp] := GetElementByName(GroupEditors, sdxTrackBarThumbUp);
  TrackBarThumb[True, tbtaBoth] := GetElementByName(GroupEditors, sdxTrackBarThumbBoth);

  TrackBarThumb[False, tbtaDown] := GetElementByName(GroupEditors, sdxTrackBarThumbVert);
  TrackBarThumb[False, tbtaUp] := GetElementByName(GroupEditors, sdxTrackBarThumbVertUp);
  TrackBarThumb[False, tbtaBoth] := GetElementByName(GroupEditors, sdxTrackBarThumbVertBoth);
end;

procedure TdxSkinInfo.InitializeSkinInfo;
begin
  InitializeSkinProperties;
  InitializeGroups;
  InitializeAlertWindowElements;
  InitializeBarElements;
  InitializeFormElements;
  InitializeDockControlElements;
  InitializeBreadcrumbEditElements;
  InitializeButtonElements;
  InitializeFooterElements;
  InitializeCalcEditColors;
  InitializeCalendarElements;
  InitializeCheckboxElements;
  InitializeClockElements;
  InitializeEditorsElements;
  InitializeGroupBoxElements;
  InitializeGridElements;
  InitializeGanttElements;
  InitializeGalleryElements;
  InitializeGaugeElements;
  InitializeIndicatorImages;
  InitializeListBoxElements;
  InitializeNavBarElements;
  InitializeNavigatorElements;
  InitializeHamburgerMenuElements;
  InitializeSchedulerElements;
  InitializeHeaderElements;
  InitializeFilterElements;
  InitializeFilterVisualCriteriaElements;
  InitializePageControlElements;
  InitializeProgressBarElements;
  InitializeRadioGroupElements;
  InitializeRangeControlElements;
  InitializeScrollBarElements;
  InitializeRibbonElements;
  InitializeRichEditElements;
  InitializeSizeGripElements;
  InitializeSplitterElements;
  InitializeTrackBarElements;
  InitializeToolTipElements;
  InitializeToggleSwitchElements;
  InitializeTileControlElements;
  InitializePrintingSystemElements;
  InitializePDFViewerElements;
  InitializeMapControlElements;
  InitializeLayoutViewElements;
  InitializeListViewElements;
  InitializeDataRowLayoutElements;
  InitializeColors;
end;

procedure TdxSkinInfo.InitializeSkinProperties;
begin
  ApplyEditorAdvancedMode := GetBoolPropertyByName(Skin, sdxApplyEditorAdvancedMode);
  DefaultGridIndicatorWidth := GetIntegerPropertyByName(Skin, sdxDefaultGridIndicatorWidth);
  SupportsNativeFocusRect := GetBoolPropertyByName(Skin, sdxSupportsNativeFocusRect);
  FormSupportsNavigationControlExtensionToFormCaption := GetBoolPropertyByName(Skin, sdxSupportsNavigationControlExtensionToFormCaption);
end;

procedure TdxSkinInfo.FinalizeScrollBarElements;
var
  AHorz: Boolean;
  APart: TcxScrollBarPart;
begin
  for AHorz := False to True do
    for APart := Low(TcxScrollBarPart) to High(TcxScrollBarPart) do
      FreeAndNil(ScrollBar_Elements[AHorz, APart]);
end;

procedure TdxSkinInfo.FinalizeSkinInfo;
begin
  FinalizeScrollBarElements;
end;

procedure TdxSkinInfo.SetUseCache(AElement: TdxSkinElement; ACapacity: Integer = -1);
begin
  if AElement <> nil then
  begin
    AElement.UseCache := True;
    if ACapacity > 0 then
      AElement.CacheCapacity := ACapacity;
  end;
end;

function TdxSkinInfo.GetSkin: TdxSkin;
begin
  Result := Skin;
end;

procedure TdxSkinInfo.SkinChanged(Sender: TdxSkin);
begin
  FinalizeSkinInfo;
  Initialize;
end;

function TdxSkinInfo.GetIsAdvanced: Boolean;
begin
  Result := Assigned(ApplyEditorAdvancedMode) and ApplyEditorAdvancedMode.Value;
end;

procedure TdxSkinInfo.MarkObjectUsed(AObject: TdxSkinCustomObject);
begin
  if Assigned(AObject) then
    AObject.State := AObject.State - [sosUnused];
end;

procedure TdxSkinInfo.SetSkin(ASkin: TdxSkin);
begin
  if ASkin <> Skin then
  begin
    if FSkin <> nil then
    begin
      FinalizeSkinInfo;
      FSkin.RemoveListener(Self);
      FSkin := nil;
    end;
    if ASkin <> nil then
    begin
      FSkin := ASkin;
      Initialize; 
      FSkin.AddListener(Self);
    end;
  end;
end;

{ TdxSkinScrollInfo }

constructor TdxSkinScrollInfo.Create(AElement: TdxSkinElement;
  AImageIndex: Integer; APart: TcxScrollBarPart);
begin
  FElement := AElement;
  FImageIndex := AImageIndex;
end;

function TdxSkinScrollInfo.DrawScaled(DC: HDC; const R: TRect; AImageIndex: Integer; AState: TdxSkinElementState;
  AScaleFactor: TdxScaleFactor): Boolean;
begin
  Result := Element <> nil;
  if Result then
    Element.Draw(DC, R, AScaleFactor, AImageIndex, AState, AScaleFactor);
end;

function TdxSkinScrollInfo.Draw(DC: HDC; const R: TRect;
  AImageIndex: Integer; AState: TdxSkinElementState): Boolean;
begin
  Result := DrawScaled(DC, R, AImageIndex, AState, dxSystemScaleFactor);
end;

function TdxSkinScrollInfo.DrawScaled(DC: HDC; const R: TRect; AState: TdxSkinElementState;
  AScaleFactor: TdxScaleFactor): Boolean;
begin
  Result := DrawScaled(DC, R, ImageIndex, AState, AScaleFactor);
end;

function TdxSkinScrollInfo.Draw(DC: HDC; const R: TRect; AState: TdxSkinElementState): Boolean;
begin
  Result := DrawScaled(DC, R, ImageIndex, AState, dxSystemScaleFactor);
end;

end.
