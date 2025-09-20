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

unit dxSkinsStrs;

interface

uses
  cxGraphics, cxGeometry, cxLookAndFeelPainters;

resourcestring
  sdxOldFormat = 'The skin data version is older than the current ExpressSkins Library version.'  + #13#10 +
                 'Skins cannot be loaded due to a version mismatch.';
  sdxSkinInvalidStreamFormat = 'Invalid stream format';
  sdxSkinElementNotFound = 'Element "%s" not found';
  sdxSkinGroupNotFound = 'Group "%s" not found';
  sdxSkinParentNotFound = 'Parent skin "%s" not found';
  sdxSkinsRootFolder = 'My DX_VCL Skins';

const
  sdxSkinBinaryProjectExt = '.skinres';
  sdxSkinVerticalSuffix = 'Vert';

  // Skins Core
  sdxResourceType = 'DXSKINS';
  sdxNavBarResourceType = 'DXNAVBARSKINS';

  sdxAdditionProperties ='AdditionalProperties';
  sdxAlternateImage = 'AlternateImage';
  sdxColors = 'Colors';
  sdxDefaultColorPaletteName = 'Default';
  sdxDefaultColorPaletteGroupName = 'General';
  sdxDefaultSkinGroupName = 'Default';
  sdxColorPalette = 'ColorPalette';
  sdxColorPalettes = 'ColorPalettes';
  sdxDefaultGlyphColorPalettes = 'DefaultGlyphColorPalettes';
  sdxFontBold = 'FontBold';
  sdxFontSize = 'FontSize';
  sdxInteger = 'Int';
  sdxMinSize = 'MinSize';
  sdxMinSizeCompact = 'MinSizeCompact';
  sdxOffset = 'Offset';
  sdxOffsetX = 'OffsetX';
  sdxOffsetY = 'OffsetY';
  sdxProperties = 'Properties';
  sdxRotationAngle = 'RotationAngle';
  sdxStateImage = 'StateImage';
  sdxStateImages = 'StateImages';
  sdxValue = 'Value';
  sdxValueReferenceSuffix = 'Reference';
  sdxValueReference = 'Value' + sdxValueReferenceSuffix;

  // Skin Properties
  sdxApplyEditorAdvancedMode = 'ApplyEditorAdvancedMode';
  sdxDefaultGridIndicatorWidth = 'DefaultGridIndicatorWidth';
  sdxSupportsNativeFocusRect = 'SupportsNativeFocusRect';
  sdxSupportsNavigationControlExtensionToFormCaption = 'SupportsNavigationControlExtensionToFormCaption';

  // Groups
  sdxSkinGroupBars = 'Bars';
  sdxSkinGroupCommon = 'Common';
  sdxSkinGroupDetails = 'Details';
  sdxSkinGroupDocking = 'Docking';
  sdxSkinGroupEditors = 'Editors';
  sdxSkinGroupForm = 'Form';
  sdxSkinGroupGantt = 'GanttControl';
  sdxSkinGroupGrid = 'Grid';
  sdxSkinGroupHamburgerMenu = 'HamburgerMenu';
  sdxSkinGroupLayoutControl = 'LayoutControl';
  sdxSkinGroupListView = 'ListView';
  sdxSkinGroupMapControl = 'MapControl';
  sdxSkinGroupNavBar = 'NavBar';
  sdxSkinGroupNavPane = 'NavPane';
  sdxSkinGroupPDFViewer = 'PDFViewer';
  sdxSkinGroupPrintingSystem = 'PrintingSystem';
  sdxSkinGroupRibbon = 'Ribbon';
  sdxSkinGroupRichEdit = 'RichEdit';
  sdxSkinGroupScheduler = 'Scheduler';
  sdxSkinGroupTabs = 'PageControl';
  sdxSkinGroupTileControl = 'TileControl';
  sdxSkinGroupVGrid = 'VerticalGrid';

  // Colors
  sdxSchedulerSeparatorColor = 'SeparatorColor';
  sdxSkinsBarDisabledTextColor = 'DisabledTextColor';
  sdxSkinsContainerBorderColor = 'ContainerBorderColor';
  sdxSkinsContainerHighlightBorderColor = 'ContainerHighlightBorderColor';
  sdxSkinsContentColor = 'ContentColor';
  sdxSkinsContentEvenColor = 'ContentEvenColor';
  sdxSkinsContentOddColor = 'ContentOddColor';
  sdxSkinsContentTextColor = 'ContentTextColor';
  sdxSkinsHeaderBackgroundColor = 'HeaderBackgroundColor';
  sdxSkinsHeaderBackgroundTextColor = 'HeaderBackgroundTextColor';
  sdxSkinsSearchResultHighlightColor = 'SearchResultHighlightColor';
  sdxSkinsSearchResultHighlightTextColor = 'SearchResultHighlightTextColor';
  sdxSkinsInactiveColor = 'InactiveColor';
  sdxSkinsInactiveTextColor = 'InactiveTextColor';
  sdxSkinsLayoutControlColor = 'LayoutControlColor';
  sdxSkinsRadialMenuBackgroundColor = 'RadialMenuBackgroundColor';
  sdxSkinsRadialMenuBaseColor = 'RadialMenuBaseColor';
  sdxSkinsSchedulerNavigatorColor = 'NavigatorColor';
  sdxSkinsSelectionColor = 'SelectionColor';
  sdxSkinsSelectionTextColor = 'SelectionTextColor';
  sdxSkinsTabTextColor = 'TabHeaderTextColor';
  sdxSkinsTabTextColorActive = 'TabHeaderTextColorActive';
  sdxSkinsTabTextColorActiveHot = 'TabHeaderTextColorActiveHot';
  sdxSkinsTabTextColorDisabled = 'TabHeaderTextColorDisabled';
  sdxSkinsTabTextColorHot = 'TabHeaderTextColorHot';
  sdxSkinsLinearGradientColor = 'linearGradient'; 

  // PDFViewer Colors
  sdxSkinsPDFViewerFindPanel = 'FindPanel';
  sdxSkinsPDFViewerSelectionColor = 'SelectionColor';
  sdxSkinsPDFViewerNavigationPaneBackground = 'NavigationPaneBackground';
  sdxSkinsPDFViewerNavigationPaneButton = 'NavigationPaneButton';
  sdxSkinsPDFViewerNavigationPaneButtonArrow = 'NavigationPaneButtonArrow';
  sdxSkinsPDFViewerNavigationPaneButtonMinimized = 'NavigationPaneButtonMinimized';
  sdxSkinsPDFViewerNavigationPanePageBackground = 'NavigationPanePageBackground';
  sdxSkinsPDFViewerNavigationPanePageButton = 'NavigationPanePageButton';
  sdxSkinsPDFViewerNavigationPanePageCaption = 'NavigationPanePageCaption';
  sdxSkinsPDFViewerNavigationPaneSelectedPageExpandValue = 'NavigationPaneSelectedPageExpandValue';
  sdxSkinsPDFViewerNavigationPaneSelectedPageOverlapValue = 'NavigationPaneSelectedPageOverlapValue';

  // SpreadSheet Colors
  sdxSkinsSpreadSheetContentColor = 'SpreadSheetContentColor';
  sdxSkinsSpreadSheetContentTextColor = 'SpreadSheetContentTextColor';
  sdxSkinsSpreadSheetFrozenPaneSeparatorColor = 'SpreadSheetFrozenPaneSeparatorColor';
  sdxSkinsSpreadSheetGroupLineColor = 'SpreadSheetGroupLineColor';
  sdxSkinsSpreadSheetSelectionColor = 'SpreadSheetSelectionColor';

  // Grid Like Control Colors
  sdxSkinsGridLikeControlContentColor = 'GridLikeControlContentColor';
  sdxSkinsGridLikeControlContentEvenColor = 'GridLikeControlContentEvenColor';
  sdxSkinsGridLikeControlContentOddColor = 'GridLikeControlContentOddColor';
  sdxSkinsGridLikeControlContentTextColor = 'GridLikeControlContentTextColor';
  sdxSkinsGridLikeControlBackgroundColor = 'GridLikeControlBackgroundColor';

  // Edit Colors
  sdxSkinsEditorBackgroundColor = 'BackgroundColor';
  sdxSkinsEditorBackgroundDisabledColor = 'BackgroundDisabledColor';
  sdxSkinsEditorBackgroundInactiveColor = 'BackgroundInactiveColor';
  sdxSkinsEditorBackgroundReadOnlyColor = 'BackgroundReadOnlyColor';
  sdxSkinsEditorTextColor = 'TextColor';
  sdxSkinsEditorTextDisabledColor = 'TextDisabledColor';
  sdxSkinsEditorTextInactiveColor = 'TextInactiveColor';
  sdxSkinsEditorTextReadOnlyColor = 'TextReadOnlyColor';
  sdxSkinsEditorHyperLinkTextColor = 'HyperLinkTextColor';

  // Calendar Colors
  sdxSkinsCalendarDayTextColor = 'CalendarDayTextColor';
  sdxSkinsCalendarHolidayTextColor = 'CalendarHolidayTextColor';
  sdxSkinsCalendarInactiveDayTextColor = 'CalendarInactiveDayTextColor';
  sdxSkinsCalendarNavigationButton = 'CalendarNavigationButton';
  sdxSkinsCalendarSelectedDayColor = 'CalendarSelectedDayColor';
  sdxSkinsCalendarSelectedDayTextColor = 'CalendarSelectedDayTextColor';
  sdxSkinsCalendarSeparatorColor = 'CalendarSeparatorColor';
  sdxSkinsCalendarTodayFrameColor = 'CalendarTodayFrameColor';
  sdxSkinsCalendarTodayTextColor = 'CalendarTodayTextColor';
  sdxSkinsCalendarWeekendDayTextColor = 'CalendarWeekendDayTextColor';

  // CalcEdit Colors
  sdxSkinsCalcEditDigitTextColor = 'CalcEditDigitTextColor';
  sdxSkinsCalcEditArithmeticOperationTextColor = 'CalcEditArithmeticOperationTextColor';
  sdxSkinsCalcEditEditingOperationTextColor = 'CalcEditEditingOperationTextColor';
  sdxSkinsCalcEditMemoryOperationTextColor = 'CalcEditMemoryOperationTextColor';
  sdxSkinsCalcEditScientificOperationTextColor = 'CalcEditScientificOperationTextColor';

  // BreadcrumbEdit Colors
  sdxBreadcrumbEditBackgroundColor = 'BreadcrumbEditBackgroundColor';
  sdxBreadcrumbEditBackgroundDisabledColor = 'BreadcrumbEditBackgroundDisabledColor';
  sdxBreadcrumbEditBackgroundFocusedColor = 'BreadcrumbEditBackgroundFocusedColor';
  sdxBreadcrumbEditBackgroundHotColor = 'BreadcrumbEditBackgroundHotColor';
  sdxBreadcrumbEditBorderColor = 'BreadcrumbEditBorderColor';
  sdxBreadcrumbEditBorderDisabledColor = 'BreadcrumbEditBorderDisabledColor';
  sdxBreadcrumbEditBorderFocusedColor = 'BreadcrumbEditBorderFocusedColor';
  sdxBreadcrumbEditBorderHotColor = 'BreadcrumbEditBorderHotColor';

  // ListView
  sdxListViewGroup = 'Group';
  sdxListViewGroupExpandButton = 'GroupExpandButton';
  sdxListViewGroupLine = 'GroupLine';
  sdxListViewIcon = 'Icon';
  sdxListViewItem = 'Item';

  // Bevel Colors
  sdxBevelShapeColor1 = 'BevelShapeColor1';
  sdxBevelShapeColor2 = 'BevelShapeColor2';

  // Skin Group Elements
  sdxAllowCompact = 'AllowCompact';
  sdxComboButtonGlyph = 'ComboButtonGlyph';
  sdxCompactScaleFactor ='CompactScaleFactor';
  sdxPopupFormBorder = 'PopupFormBorder';
  sdxSearchButtonGlyph = 'SearchButtonGlyph';
  sdxSliderArrowBottom = 'SliderArrowBottom';
  sdxSliderArrowLeft = 'SliderArrowLeft';
  sdxSliderArrowRight = 'SliderArrowRight';
  sdxSliderArrowTop = 'SliderArrowTop';
  sdxSpinUpGlyph = 'SpinUpGlyph';
  sdxSpinDownGlyph = 'SpinDownGlyph';
  sdxSpinLeftGlyph = 'SpinLeftGlyph';
  sdxSpinRightGlyph = 'SpinRightGlyph';

  // Common
  sdxCaptionFontDelta = 'FontDelta';
  sdxCaptionFontDeltaCompact = 'FontDeltaCompact';
  sdxCaptionFontBold = 'FontBold';
  sdxLoadingBig = 'LoadingBig';

  // Editors
  sdxCloseButton = 'CloseButton';
  sdxEditorBackground = 'TextEdit';
  sdxEditorButton = 'EditorButton';
  sdxEditorButtonMergeBorders = 'MergeBorders';
  sdxPictureEdit = 'PictureEdit';
  sdxTokenEdit = 'TokenEdit';
  sdxTokenEditBackground = 'TokenEditBackground';
  sdxTokenEditCloseButton = 'TokenEditCloseButton';
  sdxTokenEditCloseButtonSelected = 'TokenEditCloseButtonSelected';
  sdxEditorItemsContentMargins = 'EditorItemsContentMargins';

  // Bars
  sdxBarsBar = 'Bar';
  sdxBarsBarCustomize = 'BarCustomize';
  sdxBarsBarCustomizeVertical = 'BarCustomizeVertical';
  sdxBarsBarFinger = 'BarDragGrip';
  sdxBarsBarFingerVertical = 'BarDragGripVertical';
  sdxBarsBarSeparator = 'BarSeparator';
  sdxBarsBarSubItemArrow = 'BarSubItemArrow';
  sdxBarsBarVertical = 'BarVertical';
  sdxBarsBarVerticalSeparator = 'BarSeparatorVertical';
  sdxBarsDock = 'Dock';
  sdxBarsFloatBar = 'FloatBar';
  sdxBarsItemSeparator = 'ItemSeparator';
  sdxBarsLinkSelected = 'LinkSelected';
  sdxBarsLinkStatic = 'LinkStatic';
  sdxBarsMainMenu = 'MainMenu';
  sdxBarsMainMenuCustomize = 'MainMenuCustomize';
  sdxBarsMainMenuDrag = 'MainMenuDrag';
  sdxBarsMainMenuLinkSelected = 'MainMenuLinkSelected';
  sdxBarsMainMenuVertical = 'MainMenuVertical';
  sdxBarsMDIButtonClose = 'MDIButtonClose';
  sdxBarsMDIButtonMinimize = 'MDIButtonMinimize';
  sdxBarsMDIButtonRestore = 'MDIButtonRestore';
  sdxBarsPopupMenu = 'PopupMenu';
  sdxBarsPopupMenuCheck = 'PopupMenuCheck';
  sdxBarsPopupMenuDropDownButtonArrow = 'PopupMenuDropDownButtonArrow';
  sdxBarsPopupMenuDropDownButtonLabel = 'PopupMenuDropDownButtonLabel';
  sdxBarsPopupMenuExpandButton = 'PopupMenuExpandButton';
  sdxBarsPopupMenuLinkArrow = 'PopupMenuLinkArrow';
  sdxBarsPopupMenuLinkSelected = 'PopupMenuLinkSelected';
  sdxBarsPopupMenuSeparator = 'PopupMenuSeparator';
  sdxBarsPopupMenuSideStrip = 'PopupMenuSideStrip';
  sdxBarsPopupMenuSideStripNonRecent = 'PopupMenuSideStripNonRecent';

  // Label
  sdxLabelLine = 'LabelLine';
  sdxLabelLineVert = 'LabelLineVert';

  // Gallery (Editors)
  sdxStandaloneGalleryBackground = 'GalleryBackground';
  sdxStandaloneGalleryGroupHeader = 'GalleryGroup';
  sdxStandaloneGalleryItem = 'GalleryItem';
  sdxStandaloneGalleryItemImage = 'GalleryItemGlyphFrame';

  // Gallery (Ribbon - Tabs)
  sdxRibbonGalleryBackground = 'InRibbonGalleryPane';
  sdxRibbonGalleryButtonDown = 'InRibbonGalleryButtonDown';
  sdxRibbonGalleryButtonDropDown = 'InRibbonGalleryButtonDropDown';
  sdxRibbonGalleryButtonUp = 'InRibbonGalleryButtonUp';
  sdxRibbonGalleryItem = 'InRibbonGalleryItem';
  sdxRibbonGalleryItemImage = 'InRibbonGalleryItemImage';

  // Gallery (Ribbon - Menu)
  sdxDropDownGalleryBackground = 'DropDownGalleryBackground';
  sdxDropDownGalleryFilterPanel = 'DropDownGalleryFilterPanel';
  sdxDropDownGalleryGroupHeader = 'DropDownGalleryGroupHeader';
  sdxDropDownGalleryItem = 'DropDownGalleryItem';
  sdxDropDownGalleryItemCaption = 'DropDownGalleryItemCaption';
  sdxDropDownGalleryItemDescription = 'DropDownGalleryItemDescription';
  sdxDropDownGalleryItemImage = 'DropDownGalleryItemImage';
  sdxDropDownGallerySizeGrips = 'DropDownGallerySizeGrip';
  sdxDropDownGallerySizingPanel = 'DropDownGallerySizePanel';

  // Text Colors
  sdxDescriptionTextColorPrefix = 'Description';
  sdxTextColorDisabled = 'TextColorDisabled';
  sdxTextColorDisabledLegacy = 'DisabledText';
  sdxTextColorHot = 'TextColorHot';
  sdxTextColorInactive = 'TextColorInactive';
  sdxTextColorNormal = 'TextColor';
  sdxTextColorPressed = 'TextColorPressed';
  sdxTextColorSelected = 'TextColorSelected';
  sdxTextColorSelectedHot = 'TextColorSelectedHot';
  sdxTextGlowColor = 'TextGlowColor';

  // Text Editor Properties
  sdxEditorButtonPaddings = 'EditorButtonPaddings';
  sdxEditorButtonPaddingsGrid = 'EditorButtonPaddingsGrid';
  sdxButtonEditTextToButtonPadding = 'ButtonEditTextToButtonPadding';
  sdxButtonEditCompactTextToButtonPadding = 'ButtonEditCompactTextToButtonPadding';

  // Common Colors
  sdxCommonCriticalColor = 'Critical';
  sdxCommonHotTrackedColor = 'HotTrackedColor';
  sdxCommonHotTrackedTextColor = 'HotTrackedTextColor';
  sdxCommonInformationColor = 'Information';
  sdxCommonQuestionColor = 'Question';

  // BreadcrumbEdit
  sdxBreadcrumb = 'Breadcrumb';
  sdxBreadcrumbContentPadding = 'BreadcrumbContentPadding';
  sdxBreadcrumbEditButton = 'BreadcrumbEditButton';
  sdxBreadcrumbEditButtonsAreaSeparator = 'BreadcrumbEditButtonsAreaSeparator';
  sdxBreadcrumbEditDropDownButton = 'BreadcrumbEditDropDownButton';
  sdxBreadcrumbEditNodeButton = 'BreadcrumbEditNodeButton';
  sdxBreadcrumbEditNodeSplitButtonLeft = 'BreadcrumbEditNodeSplitButtonLeft';
  sdxBreadcrumbEditNodeSplitButtonRight = 'BreadcrumbEditNodeSplitButtonRight';
  sdxBreadcrumbEditProgressChunk = 'BreadcrumbEditProgressChunk';
  sdxBreadcrumbEditProgressChunkOverlay = 'BreadcrumbEditProgressChunkOverlay';
  sdxBreadcrumbEditProgressChunkPadding = 'BreadcrumbEditProgressChunkPadding';

  // LayoutView
  sdxLayoutViewRecord = 'LayoutViewRecord';
  sdxLayoutViewRecordBottom = 'LayoutViewRecordBottom';
  sdxLayoutViewRecordLeft = 'LayoutViewRecordLeft';
  sdxLayoutViewRecordRight = 'LayoutViewRecordRight';
  sdxLayoutViewRecordTop = 'LayoutViewRecordTop';

  sdxLayoutViewRecordCaptionBottom = 'LayoutViewRecordCaptionBottom';
  sdxLayoutViewRecordCaptionLeft = 'LayoutViewRecordCaptionLeft';
  sdxLayoutViewRecordCaptionRight = 'LayoutViewRecordCaptionRight';
  sdxLayoutViewRecordCaptionTop = 'LayoutViewRecordCaptionTop';

  sdxLayoutViewRecordExpandButton = 'LayoutViewRecordExpandButton';

  sdxLayoutViewGroupPadding = 'LayoutViewGroupPadding';
  sdxLayoutViewGroupSpacing = 'LayoutViewGroupSpacing';
  sdxLayoutViewGroupWithoutBordersPadding = 'LayoutViewGroupWithoutBordersPadding';
  sdxLayoutViewGroupWithoutBordersSpacing = 'LayoutViewGroupWithoutBordersSpacing';
  sdxLayoutViewItem = 'LayoutViewItem';
  sdxLayoutViewItemPadding = 'LayoutViewItemPadding';
  sdxLayoutViewItemSpacing = 'LayoutViewItemSpacing';
  sdxLayoutViewRootGroupPadding = 'LayoutViewRootGroupPadding';
  sdxLayoutViewRootGroupSpacing = 'LayoutViewRootGroupSpacing';
  sdxLayoutViewRootGroupWithoutBordersPadding = 'LayoutViewRootGroupWithoutBordersPadding';
  sdxLayoutViewRootGroupWithoutBordersSpacing = 'LayoutViewRootGroupWithoutBordersSpacing';
  sdxLayoutViewTabbedGroupPadding = 'LayoutViewTabbedGroupPadding';
  sdxLayoutViewTabbedGroupSpacing = 'LayoutViewTabbedGroupSpacing';

  // ToggleSwitch
  sdxToggleSwitch = 'ToggleSwitch';
  sdxToggleSwitchThumb = 'ToggleSwitchThumb';
  sdxToggleSwitchTextMargin = 'TextMargin';

  // Gauge
  sdxGaugeBackground = 'GaugeBackground';

  // AlertWindow
  sdxAlertWindow = 'AlertWindow';
  sdxAlertWindowButton = 'AlertWindowButton';
  sdxAlertWindowButtonGlyphs = 'AlertWindowButtonGlyphs';
  sdxAlertWindowCaption = 'AlertWindowCaption';
  sdxAlertWindowCornerRadius = 'CornerRadius';
  sdxAlertWindowNavigationPanel = 'AlertWindowNavigationPanel';
  sdxAlertWindowNavigationPanelButton = 'AlertWindowNavigationPanelButton';

  // Rating
  sdxRatingIndicator = 'RatingIndicator';

  // Ribbon
  sdxRibbonAppButtonLeftIndent = 'LeftIndent';
  sdxRibbonAppButtonRightIndent = 'RightIndent';
  sdxRibbonApplicationButton = 'FormAppButton';
  sdxRibbonApplicationButton2010 = 'FormAppButton2010';
  sdxRibbonAppMenuBackground = 'AppMenuBackground';
  sdxRibbonAppMenuFooterBackground = 'AppMenuBackgroundBottom';
  sdxRibbonAppMenuHeaderBackground = 'AppMenuBackgroundTop';
  sdxRibbonBackstageViewBackButton = 'BackstageViewBackButton';
  sdxRibbonBackstageViewBackground = 'BackstageViewBackground';
  sdxRibbonBackstageViewImage = 'BackstageViewImage';
  sdxRibbonBackstageViewMenuBackground = 'BackstageViewMenuBackground';
  sdxRibbonBackstageViewMenuButton = 'BackstageViewMenuButton';
  sdxRibbonBackstageViewMenuHeader = 'BackstageViewMenuHeader';
  sdxRibbonBackstageViewMenuSeparator = 'BackstageViewMenuSeparator';
  sdxRibbonBackstageViewTabHeader = 'BackstageViewTabHeader';
  sdxRibbonBackstageViewTabHeaderArrow = 'BackstageViewTabHeaderArrow';
  sdxRibbonButtonArrow = 'ButtonArrow';
  sdxRibbonButtonDisabledText = 'ButtonDisabled';
  sdxRibbonButtonGroup = 'ButtonGroup';
  sdxRibbonButtonGroupButton = 'ButtonGroupButton';
  sdxRibbonButtonGroupSeparator = 'ButtonGroupSeparator';
  sdxRibbonButtonGroupSplitButtonLeft = 'ButtonGroupSplitButtonLeft';
  sdxRibbonButtonGroupSplitButtonRight = 'ButtonGroupSplitButtonRight';
  sdxRibbonCaptionFontDelta = 'FontDelta';
  sdxRibbonCollapsedToolBarBackground = 'TabGroupCollapsed';
  sdxRibbonCollapsedToolBarGlyphBackground = 'TabGroupCollapsedBox';
  sdxRibbonContextualTabHeader = 'ContextualTabHeader';
  sdxRibbonContextualTabLabel = 'ContextualTabLabel';
  sdxRibbonContextualTabLabelOnGlass = 'ContextualTabLabelOnGlass';
  sdxRibbonContextualTabPanel = 'ContextualTabPanel';
  sdxRibbonContextualTabPanelWithQATBelow = 'ContextualTabPanelWithQATBelow';
  sdxRibbonContextualTabSeparator = 'ContextualTabSeparator';
  sdxRibbonDialogFrameBottom = 'DialogFrameBottom';
  sdxRibbonDialogFrameLeft = 'DialogFrameLeft';
  sdxRibbonDialogFrameRight = 'DialogFrameRight';
  sdxRibbonDocumentNameTextColor = 'DocumentNameTextColor';
  sdxRibbonEditorBackground = 'EditorBackground';
  sdxRibbonExtraPaneButton = 'AppMenuExtraPaneButton';
  sdxRibbonExtraPaneColor = 'AppMenuExtraPaneColor';
  sdxRibbonExtraPaneHeaderSeparator = 'AppMenuExtraPaneHeaderSeparator';
  sdxRibbonExtraPanePinButtonGlyph = 'AppMenuExtraPanePinButtonGlyph';
  sdxRibbonFormBottom = 'FormFrameBottom';
  sdxRibbonFormButtonAutoHideModeShowUI = 'FormButtonAutoHideModeShowUI';
  sdxRibbonFormButtonDisplayOptions = 'FormButtonDisplayOptions';
  sdxRibbonFormCaption = 'FormCaption';
  sdxRibbonFormCaptionRibbonHidden = 'FormCaptionRibbonHidden';
  sdxRibbonFormContent = 'FormContent';
  sdxRibbonFormFrameLeft = 'FormFrameLeft';
  sdxRibbonFormFrameRight = 'FormFrameRight';
  sdxRibbonUseRoundedWindowCorners = 'UseRoundedWindowCorners';
  sdxRibbonHeaderBackground = 'TabBackground';
  sdxRibbonHeaderBackgroundOnGlass = 'TabBackgroundOnGlass';
  sdxRibbonKeyTip = 'KeyTip';
  sdxRibbonLargeButton = 'LargeButton';
  sdxRibbonLargeSplitButtonBottom = 'LargeSplitButtonBottom';
  sdxRibbonLargeSplitButtonTop = 'LargeSplitButtonTop';
  sdxRibbonMinimizeButtonGlyph = 'MinimizeButtonGlyph';
  sdxRibbonQATCustomizeButtonOutsideQAT = 'DisplayCustomizeButtonOutsideQAT';
  sdxRibbonQATIndentBeforeCustomizeItem = 'IndentBeforeCustomizeButton';
  sdxRibbonQuickAccessToolbarOffset = 'Offset';
  sdxRibbonQuickToolbarAbove = 'QATAboveBackground';
  sdxRibbonQuickToolbarAboveButton = 'QATAboveButton';
  sdxRibbonQuickToolbarBelow = 'QATBelowBackground';
  sdxRibbonQuickToolbarBelowButton = 'QATBelowButton';
  sdxRibbonQuickToolbarButtonGlyph = 'QATButtonGlyph';
  sdxRibbonQuickToolbarButtonGlyphInAbove = 'QATButtonGlyphInAbove';
  sdxRibbonQuickToolbarButtonGlyphInBelow = 'QATButtonGlyphInBelow';
  sdxRibbonQuickToolbarButtonGlyphInCaption = 'QATButtonGlyphInCaption';
  sdxRibbonQuickToolbarButtonArrowInAbove = 'QATButtonArrowInAbove';
  sdxRibbonQuickToolbarButtonArrowInBelow = 'QATButtonArrowInBelow';
  sdxRibbonQuickToolbarButtonArrowInCaption = 'QATButtonArrowInCaption';
  sdxRibbonQuickToolbarDropDown = 'QATOverflow';
  sdxRibbonQuickToolbarGlyph = 'QATCustomizeButton';
  sdxRibbonQuickToolbarGlyphInAbove = 'QATCustomizeButtonInAbove';
  sdxRibbonQuickToolbarGlyphInBelow = 'QATCustomizeButtonInBelow';
  sdxRibbonQuickToolbarGlyphInCaption = 'QATCustomizeButtonInCaption';
  sdxRibbonQuickToolbarInCaption = 'QATInRibbonBackground';
  sdxRibbonQuickToolbarInCaptionButton = 'QATInRibbonButton';
  sdxRibbonQuickToolbarSingle = 'QATSingleBackground';
  sdxRibbonSmallButton = 'Button';
  sdxRibbonSpaceBetweenTabGroups = 'SpaceBetweenTabGroups';
  sdxRibbonSplitButtonLeft = 'SplitButtonLeft';
  sdxRibbonSplitButtonRight = 'SplitButtonRight';
  sdxRibbonStatusBarBackground = 'StatusBarBackground';
  sdxRibbonStatusBarButton = 'StatusBarButton';
  sdxRibbonStatusBarSeparator = 'StatusBarSeparator';
  sdxRibbonTabAeroSupport = 'TabAeroSupport';
  sdxRibbonTabGroup = 'TabGroup';
  sdxRibbonTabGroupHeader = 'TabGroupCaption';
  sdxRibbonTabGroupItemsSeparator = 'TabGroupItemsSeparator';
  sdxRibbonTabGroupLeftScroll = 'TabGroupLeftScrollButton';
  sdxRibbonTabGroupRightScroll = 'TabGroupRightScrollButton';
  sdxRibbonTabHeaderDownGrowIndent = 'TabHeaderDownGrow';
  sdxRibbonTabHeaderPage = 'Tab';
  sdxRibbonTabPanel = 'TabPanel';
  sdxRibbonTabPanelWithQATBelow = 'TabPanelWithQATBelow';
  sdxRibbonTabPanelBottomIndent = 'BottomIndent';
  sdxRibbonTabPanelGroupButton = 'TabGroupButton';
  sdxRibbonTabPanelHorizontalMargin = 'HorizontalMargin';
  sdxRibbonTabSeparatorLine = 'TabSeparatorLine';

  // Navbar
  sdxNavBarAccordionControlBackground = 'AccordionControlBackground';
  sdxNavBarAccordionControlChildItemOffset = 'ChildItemOffset';
  sdxNavBarAccordionControlContentContainerPadding = 'ContentContainerPadding';
  sdxNavBarAccordionControlDistanceBetweenRootGroups = 'DistanceBetweenRootGroups';
  sdxNavBarAccordionControlGlyphToTextIndent = 'GlyphToTextIndent';
  sdxNavBarAccordionControlGroup = 'AccordionControlGroup';
  sdxNavBarAccordionControlGroupCloseButton = 'AccordionControlGroupCloseButton';
  sdxNavBarAccordionControlGroupOpenButton = 'AccordionControlGroupOpenButton';
  sdxNavBarAccordionControlItem = 'AccordionControlItem';
  sdxNavBarAccordionControlRootGroup = 'AccordionControlRootGroup';
  sdxNavBarAccordionControlRootGroupCloseButton = 'AccordionControlRootGroupCloseButton';
  sdxNavBarAccordionControlRootGroupOpenButton = 'AccordionControlRootGroupOpenButton';
  sdxNavBarAccordionControlSearchButton = 'AccordionControlSearchButton';
  sdxNavBarBackground = 'Background';
  sdxNavBarGroupClient = 'GroupClient';
  sdxNavBarGroupCloseButton = 'GroupCloseButton';
  sdxNavBarGroupFooter = 'GroupFooter';
  sdxNavBarGroupHeader = 'GroupHeader';
  sdxNavBarGroupOpenButton = 'GroupOpenButton';
  sdxNavBarItem = 'Item';

  sdxNavPaneCaptionHeight = 'Height';
  sdxNavPaneCollapseButton = 'CollapseButton';
  sdxNavPaneCollapsedGroupClient = 'CollapsedGroupClient';
  sdxNavPaneExpandButton = 'ExpandButton';
  sdxNavPaneFormBorder = 'PopupBorder';
  sdxNavPaneFormSizeGrip = 'PopupSizeGrip';
  sdxNavPaneGroupButton = 'GroupButton';
  sdxNavPaneGroupButtonSelected = 'GroupButtonSelected';
  sdxNavPaneGroupCaption = 'Caption';
  sdxNavPaneGroupClient = 'GroupClient';
  sdxNavPaneItem = 'Item';
  sdxNavPaneItemSelected = 'ItemSelected';
  sdxNavPaneOfficeNavigationBar = 'OfficeNavigationBar';
  sdxNavPaneOfficeNavigationBarItem = 'OfficeNavigationBarItem';
  sdxNavPaneOfficeNavigationBarSkinningItem = 'OfficeNavigationBarSkinningItem';
  sdxNavPaneOffsetGroupBorders = 'OverlapGroupBorders';
  sdxNavPaneOverflowPanel = 'OverflowPanel';
  sdxNavPaneOverflowPanelExpandItem = 'OverflowPanelExpandItem';
  sdxNavPaneOverflowPanelItem = 'OverflowPanelItem';
  sdxNavPaneScrollDownBtn = 'ScrollDownButton';
  sdxNavPaneScrollUpBtn = 'ScrollUpButton';
  sdxNavPaneSplitter = 'Splitter';

  // Scheduler
  sdxSchedulerAllDayArea = 'AllDayArea';
  sdxSchedulerAllDayAreaSelected = 'AllDayAreaSelected';
  sdxSchedulerAppointment = 'Appointment';
  sdxSchedulerAppointmentBorder = 'AppointmentBorder';
  sdxSchedulerAppointmentBorderColor = 'BorderColor';
  sdxSchedulerAppointmentBorderSize = 'BorderSize';
  sdxSchedulerAppointmentBottomShadow = 'AppointmentBottomShadow';
  sdxSchedulerAppointmentMask = 'AppointmentMask';
  sdxSchedulerAppointmentRight = 'AppointmentRightBorder';
  sdxSchedulerAppointmentRightShadow = 'AppointmentRightShadow';
  sdxSchedulerCurrentTimeIndicator = 'CurrentTimeIndicator';
  sdxSchedulerGroup = 'Group';
  sdxSchedulerLabelCircle = 'LabelCircle';
  sdxSchedulerTaskExpandButton = 'TaskExpandButton';
  sdxSchedulerMilestone = 'Milestone';
  sdxSchedulerMoreButton = 'MoreButton';
  sdxSchedulerNavButtonNext = 'NavButtonNext';
  sdxSchedulerNavButtonNextArrow = 'NavButtonNextArrow';
  sdxSchedulerNavButtonPrev = 'NavButtonPrev';
  sdxSchedulerNavButtonPrevArrow = 'NavButtonPrevArrow';
  sdxSchedulerResourceColor = 'ResourceColor%0.2d';
  sdxSchedulerTimeGridCurrentTimeIndicator = 'TimeGridCurrentTimeIndicator';
  sdxSchedulerTimeGridHeader = 'TimeGridHeader';
  sdxSchedulerTimeGridHeaderSelected = 'TimeGridHeaderSelected';
  sdxSchedulerTimeLine = 'DefaultTimeLine';
  sdxSchedulerTimeRuler = 'Ruler';

  // DockControl
  sdxDCActiveTabHeaderDownGrow = 'ActiveTabHeaderDownGrow';
  sdxDCActiveTabHeaderHGrow = 'ActiveTabHeaderHGrow';
  sdxDCActiveTabHeaderUpGrow = 'ActiveTabHeaderUpGrow';
  sdxDockCtrlAutoHideBar = 'AutoHideBar';
  sdxDockCtrlAutoHideBarBottom = 'AutoHideBarBottom';
  sdxDockCtrlAutoHideBarLeft = 'AutoHideBarLeft';
  sdxDockCtrlAutoHideBarRight = 'AutoHideBarRight';
  sdxDockCtrlBorder = 'DockWindowBorder';
  sdxDockCtrlCaption = 'DockWindowCaption';
  sdxDockCtrlInactiveCaptionTextColor = 'InactiveCaptionTextColor';
  sdxDockCtrlHiddenBarTextColor = 'HiddenBarTextColor';
  sdxDockCtrlHiddenBarTextHotColor = 'HiddenBarTextHotColor';
  sdxDockCtrlTabButtonHorz = 'TabButtonHorz';
  sdxDockCtrlTabButtonVert = 'TabButtonVert';
  sdxDockCtrlTabHeader = 'TabHeader';
  sdxDockCtrlTabHeaderAutoHideBar = 'TabHeaderAutoHideBar';
  sdxDockCtrlTabHeaderBackground = 'TabHeaderBackground';
  sdxDockCtrlTabHeaderCloseButton = 'TabHeaderCloseButton';
  sdxDockCtrlTabHeaderLine = 'TabHeaderLine';
  sdxDockCtrlWindowButton = 'DockWindowButton';
  sdxDockCtrlWindowGlyphs = 'DockWindowButtonGlyphs';
  sdxDockSiteContentColor = 'DockSiteContentColor';

  // Skin Group Panel
  sdxGroupButton = 'GroupButton';
  sdxGroupButtonExpandGlyph = 'GroupButtonExpandGlyph';
  sdxGroupPanel = 'GroupPanel';
  sdxGroupPanelBottom = 'GroupPanelBottom';
  sdxGroupPanelCaptionBottom = 'GroupPanelCaptionBottom';
  sdxGroupPanelCaptionLeft = 'GroupPanelCaptionLeft';
  sdxGroupPanelCaptionRight = 'GroupPanelCaptionRight';
  sdxGroupPanelCaptionTailSize = 'TailSize';
  sdxGroupPanelCaptionTextPadding = 'TextPadding';
  sdxGroupPanelCaptionTop = 'GroupPanelCaptionTop';
  sdxGroupPanelLeft = 'GroupPanelLeft';
  sdxGroupPanelNoBorder = 'GroupPanelNoBorder';
  sdxGroupPanelRight = 'GroupPanelRight';
  sdxGroupPanelTop = 'GroupPanelTop';

  sdxBackButton = 'BackButton';
  sdxButton = 'Button';
  sdxCheckbox = 'Checkbox';
  sdxClearButton = 'ClearButton';
  sdxClock = 'ClockFace';
  sdxClockGlass = 'ClockGlass';
  sdxDropDownButtonLeft = 'DropDownButtonLeft';
  sdxDropDownButtonRight = 'DropDownButtonRight';
  sdxListBox = 'ListBox';
  sdxListBoxCheckMarkIndent = 'ListBoxCheckMarkIndent';
  sdxListBoxCheckMarkToTextIndent = 'ListBoxCheckMarkToTextIndent';
  sdxListBoxInplacePaddings = 'ListBoxInplacePaddings';
  sdxListBoxEditorHScrollMargins = 'EditorHScrollMargins';
  sdxListBoxEditorHScrollMarginsInplace = 'EditorHScrollMarginsInplace';
  sdxListBoxEditorVScrollMargins = 'EditorVScrollMargins';
  sdxListBoxEditorVScrollMarginsInplace = 'EditorVScrollMarginsInplace';
  sdxHighlightedItem = 'HighlightedItem';
  sdxNavigatorButton = 'NavigatorButton';
  sdxNavigatorGlyphs = 'Navigator';
  sdxNavigatorGlyphsVert = 'NavigatorVert';
  sdxNavigatorInfoPanel = 'NavigatorInfoPanel';
  sdxRadioButton = 'RadioButton';
  sdxScreenTipItem = 'ScreenTipItem';
  sdxScreenTipSeparator = 'ScreenTipSeparator';
  sdxScreenTipTitleItem = 'ScreenTipTitleItem';
  sdxScreenTipWindow = 'ScreenTipWindow';
  sdxScrollButton = 'ScrollButton';
  sdxScrollContentHorz = 'ScrollContentHorz';
  sdxScrollContentVert = 'ScrollContentVert';
  sdxScrollThumbButtonHorz = 'ScrollThumbHorz';
  sdxScrollThumbButtonVert = 'ScrollThumbVert';
  sdxSizeGrip = 'SizeGrip';
  sdxSplitterHorz = 'SplitterHorz';
  sdxSplitterVert = 'Splitter';
  sdxZoomInButton = 'ZoomInButton';
  sdxZoomOutButton = 'ZoomOutButton';

  // Progress
  sdxProgressBorder = 'ProgressBorder';
  sdxProgressChunk = 'ProgressChunk';
  sdxProgressOverloadBar = 'ProgressOverloadBar';
  sdxProgressPeakBar = 'ProgressPeakBar';

  // TrackBar
  sdxTrackBarThumb = 'TrackBarThumb';
  sdxTrackBarThumbBoth = 'TrackBarThumbBoth';
  sdxTrackBarThumbUp = 'TrackBarThumbUp';
  sdxTrackBarThumbVert = 'TrackBarThumbVert';
  sdxTrackBarThumbVertBoth = 'TrackBarThumbVertBoth';
  sdxTrackBarThumbVertUp = 'TrackBarThumbVertUp';
  sdxTrackBarTextColor = 'TrackBarTextColor';
  sdxTrackBarTickColor = 'TrackBarTickColor';
  sdxTrackBarTrack = 'TrackBarTrack';
  sdxTrackBarTrackVert = 'TrackBarTrackVert';
  sdxRangeTrackBarThumbBoth = 'RangeTrackBarThumbBoth';
  sdxRangeTrackBarThumbLeft = 'RangeTrackBarThumbLeft';
  sdxRangeTrackBarThumbRight = 'RangeTrackBarThumbRight';

  // MapControl
  sdxMapControlBackColor = 'MapBackColor';
  sdxMapControlBorderColor = 'BorderColor';
  sdxMapControlBorderWidth = 'BorderWidth';
  sdxMapControlCallout = 'Callout';
  sdxMapControlCalloutPointerHeight = 'PointerHeight';
  sdxMapControlCalloutPointerX = 'PointerX';
  sdxMapControlCalloutPointerY = 'PointerY';
  sdxMapControlCustomElement = 'CustomElement';
  sdxMapControlPushpin = 'Pushpin';
  sdxMapControlPushpinTextOriginX = 'TextOriginX';
  sdxMapControlPushpinTextOriginY = 'TextOriginY';
  sdxMapControlSelectedRegion = 'SelectedRegion';
  sdxMapControlShape = 'Shape';
  sdxMapControlPanelBackColor = 'PanelBackColor';
  sdxMapControlPanelBackColorAlpha = 'PanelBackColorAlpha';
  sdxMapControlPanelHotTrackedTextColor = 'PanelHotTrackedTextColor';
  sdxMapControlPanelPressedTextColor = 'PanelPressedTextColor';
  sdxMapControlPanelPressedTextColorAlpha = 'PanelPressedTextColorAlpha';
  sdxMapControlPanelTextColor = 'PanelTextColor';

  // PageControl
  sdxPageControlButton = 'TabButton';
  sdxPageControlHeader = 'TabHeader';
  sdxPageControlHeaderButton = 'TabHeaderButton';
  sdxPageControlHeaderCloseButton = 'TabHeaderCloseButton';
  sdxPageControlHorz = 'TabButtonHorz';
  sdxPageControlPane = 'TabPane';
  sdxPageControlVert = 'TabButtonVert';

  // Header
  sdxHeaderDownGrow = 'HeaderDownGrow';
  sdxHeaderDownGrowBottomRight = 'HeaderDownGrowBottomRight';
  sdxRowIndentFar = 'RowIndentFar';
  sdxRowIndentNear = 'RowIndentNear';
  sdxSelectedHeaderDownGrow = 'SelectedHeaderDownGrow';
  sdxSelectedHeaderDownGrowBottomRight = 'SelectedHeaderDownGrowBottomRight';
  sdxSelectedHeaderHGrow = 'SelectedHeaderHGrow';
  sdxSelectedHeaderUpGrow = 'SelectedHeaderUpGrow';
  sdxSortGlyphs = 'SortShape';

  // TileControl
  sdxTileControlActionBar = 'ActionBar';
  sdxTileControlBackground = 'Background';
  sdxTileControlGroupCaption = 'GroupCaption';
  sdxTileControlItem = 'Item';
  sdxTileControlItemCheck = 'ItemCheck';
  sdxTileControlSelectionFocusedColor = 'SelectionFocusedColor';
  sdxTileControlSelectionHotColor = 'SelectionHotColor';
  sdxTileControlTabHeader = 'TabHeader';
  sdxTileControlTitle = 'Title';
  sdxTileControlVirtualGroup = 'VirtualGroup';

  // Grid
  sdxCardSeparator = 'CardSeparator';
  sdxFilterButton = 'FilterButton';
  sdxFilterButtonActive = 'FilterButtonActive';
  sdxFilterPanel = 'GridFilterPanel';
  sdxFooterCell = 'FooterCell';
  sdxFooterPanel = 'FooterPanel';
  sdxGridFixedColumnHighlightColor = 'FixedColumnHighlightColor';
  sdxGridFixedLine = 'GridFixedLine';
  sdxGridGroupRowStyleOffice11ContentColor = 'Office11ContentColor';
  sdxGridGroupRowStyleOffice11SeparatorColor = 'Office11SeparatorColor';
  sdxGridGroupRowStyleOffice11TextColor = 'Office11TextColor';
  sdxGridCell = 'GridCell';
  sdxGridLine = 'GridLine';
  sdxGridWinExplorerViewGroup = 'WinExplorerViewGroup';
  sdxGridWinExplorerViewGroupCaptionLine = 'WinExplorerViewGroupCaptionLine';
  sdxGridWinExplorerViewGroupExpandButton = 'WinExplorerViewGroupExpandButton';
  sdxGridWinExplorerViewRecord = 'WinExplorerViewRecord';
  sdxGroupByBox = 'GridGroupPanel';
  sdxGroupByBoxLineColor = 'LineColor';
  sdxGroupRow = 'GroupRow';
  sdxHeader = 'Header';
  sdxHeaderLeft = 'HeaderLeft';
  sdxHeaderRight = 'HeaderRight';
  sdxHeaderSpecial = 'HeaderSpecial';
  sdxIndicatorImages = 'IndicatorImages';
  sdxSmartFilterButton = 'SmartFilterButton';

  // TreeList
  sdxTreeListGridLineColor = 'TreeListGridLineColor';
  sdxTreeListTreeLineColor = 'TreeListTreeLineColor';
  sdxPlusMinus = 'PlusMinus';
  sdxPlusMinusEx = 'PlusMinusEx';

  // VGrid
  sdxVGridBandLine = 'BandBorder';
  sdxVGridLine = 'GridLine';
  sdxVGridRowHeader = 'RowHeader';
  sdxVGridCategory = 'Category';

  // Form
  sdxTextShadowColor = 'TextShadowColor';

  sdxFormCaption = 'FormCaption';
  sdxFormContent = 'FormContent';
  sdxFormDecoratorFrameBottom = 'FormDecoratorFrameBottom';
  sdxFormDecoratorFrameLeft = 'FormDecoratorFrameLeft';
  sdxFormDecoratorFrameRight = 'FormDecoratorFrameRight';
  sdxFormDecoratorFrameTop = 'FormDecoratorFrameTop';
  sdxFormFrameBottom = 'FormFrameBottom';
  sdxFormFrameLeft = 'FormFrameLeft';
  sdxFormFrameRight = 'FormFrameRight';

  sdxSmallFormFrameLeft = 'SmallFormFrameLeft';
  sdxSmallFormCaption = 'SmallFormCaption';
  sdxSmallFormFrameRight = 'SmallFormFrameRight';
  sdxSmallFormFrameBottom = 'SmallFormFrameBottom';

  sdxFormButtonClose = 'FormButtonClose';
  sdxFormButtonHelp = 'FormButtonHelp';
  sdxFormButtonMaximize = 'FormButtonMaximize';
  sdxFormButtonMinimize = 'FormButtonMinimize';
  sdxFormButtonRestore = 'FormButtonRestore';
  sdxSmallFormButtonClose = 'SmallFormButtonClose';
  sdxStatusBar = 'StatusBar';

  // PrintingSystem
  sdxPrintingSystemPageBorder = 'PageBorder';
  sdxPrintingSystemPreviewBackground = 'PreviewBackground';

  // RichEdit
  sdxRichEditCornerPanel = 'CornerPanel';
  sdxRichEditRulerBackgroundHorz = 'RulerBackgroundHorz';
  sdxRichEditRulerBackgroundVert = 'RulerBackgroundVert';
  sdxRichEditRulerColumnResizer = 'RulerColumnResizer';
  sdxRichEditRulerDefaultTabColor = 'RulerDefaultTabColor';
  sdxRichEditRulerIndent = 'RulerIndent';
  sdxRichEditRulerIndentBottom = 'RulerIndentBottom';
  sdxRichEditRulerLargeTick = 'RulerLargeTick';
  sdxRichEditRulerRightMargin = 'RulerRightMargin';
  sdxRichEditRulerSection = 'RulerSection';
  sdxRichEditRulerSmallTick = 'RulerSmallTick';
  sdxRichEditRulerTab = 'RulerTab';
  sdxRichEditRulerTabTypeBackground = 'RulerTabTypeBackground';
  sdxRichEditRulerTextColor = 'RulerTextColor';

  // RangeControl
  sdxRangeControlBorder = 'RangeControlBorder';
  sdxRangeControlLeftThumb = 'RangeControlLeftThumb';
  sdxRangeControlRightThumb = 'RangeControlRightThumb';
  sdxRangeControlRulerHeader = 'RangeControlRulerHeader';
  sdxRangeControlSizingGlyph = 'RangeControlSizingGlyph';
  sdxRangeControlDefaultElementColor = 'DefaultElementColor';
  sdxRangeControlBackColor = 'BackColor';
  sdxRangeControlInnerBorderColor = 'InnerBorderColor';
  sdxRangeControlElementBaseColor = 'ElementBaseColor';
  sdxRangeControlElementForeColor = 'ElementForeColor';
  sdxRangeControlElementFontSize = 'ElementFontSize';
  sdxRangeControlLabelColor = 'LabelColor';
  sdxRangeControlOutOfRangeColorMask = 'OutOfRangeColorMask';
  sdxRangeControlRangePreviewColor = 'RangePreviewColor';
  sdxRangeControlRuleColor = 'RuleColor';
  sdxRangeControlScrollAreaColor = 'ScrollAreaColor';
  sdxRangeControlScrollAreaHeight = 'ScrollAreaHeight';
  sdxRangeControlViewPortPreviewColor = 'ViewPortPreviewColor';
  sdxRangeControlSelectionBorderColor = 'SelectionBorderColor';
  sdxRangeControlSelectionColor = 'SelectionColor';

  // HamburgerMenu
  sdxHamburgerMenuBackground = 'Background';
  sdxHamburgerMenuChildGroup = 'ChildGroup';
  sdxHamburgerMenuChildGroupCloseButton = 'ChildGroupCloseButton';
  sdxHamburgerMenuChildGroupOpenButton = 'ChildGroupOpenButton';
  sdxHamburgerMenuChildItemOffset = 'ChildItemOffset';
  sdxHamburgerMenuDistanceBetweenGroups = 'DistanceBetweenGroups';
  sdxHamburgerMenuGroup = 'Group';
  sdxHamburgerMenuGroupCloseButton = 'GroupCloseButton';
  sdxHamburgerMenuGroupOpenButton = 'GroupOpenButton';
  sdxHamburgerMenuHamburgerButton = 'HamburgerButton';
  sdxHamburgerMenuItem = 'Item';
  sdxHamburgerMenuNavPaneBackground = 'NavPaneBackground';
  sdxHamburgerMenuNavPaneExpandButton = 'NavPaneExpandButton';
  sdxHamburgerMenuNavPaneItem = 'NavPaneItem';
  sdxHamburgerMenuNavPaneItemSelected = 'NavPaneItemSelected';
  sdxHamburgerMenuScrollDownButton = 'ScrollDownButton';
  sdxHamburgerMenuScrollUpButton = 'ScrollUpButton';

  // Gantt
  sdxGanttDependencyEditPointLeft = 'DependencyEditPointLeft';
  sdxGanttDependencyEditPointRight = 'DependencyEditPointRight';
  sdxGanttFocusedRow = 'FocusedRow';
  sdxGanttMilestone = 'Milestone';
  sdxGanttMilestoneBaseline = 'MilestoneBaseline';
  sdxGanttSummaryTask = 'SummaryTask';
  sdxGanttSummaryTaskBaseline = 'SummaryTaskBaseline';
  sdxGanttSummaryTaskProgress = 'SummaryTaskProgress';
  sdxGanttTask = 'Task';
  sdxGanttTaskProgress = 'TaskProgress';
  sdxGanttTaskBaseline = 'TaskBaseline';
  sdxGanttTaskTextLabel = 'TaskTextLabel';
  sdxGanttTaskTextLabelHorizontalIndent = 'HorizontalIndent';

  // Filter Panel
  sdxFilterPanelCustomizeButton = 'FilterPanelCustomizeButton';

  // Filter Visual Criteria
  sdxFilterAddButton = 'FilterPanelNodeActionButton';
  sdxFilterBoolOperatorBackground = 'FilterPanelGroupNode';
  sdxFilterControlBackColor = 'FilterControlBackColor';
  sdxFilterItemCaptionBackground = 'FilterPanelProperty';
  sdxFilterOperatorBackground = 'FilterPanelName';
  sdxFilterPanelBrackets = 'FilterPanelGroup';
  sdxFilterRemoveButton = 'FilterPanelButton';
  sdxFilterValueBackground = 'FilterPanelValue';

  // DataRowLayout
  sdxDataRowLayoutElement = 'DataRowLayoutElement';
  sdxDataRowLayoutItem = 'DataRowLayoutItem';

  // xml storage
  sdxItem = 'Item';
  sdxItems = 'Items';
  
  sdxAlpha = 'Alpha';
  sdxControlParts = 'ControlParts';
  sdxDisplayName = 'DisplayName';
  sdxGlyph = 'Glyph';
  sdxImage = 'Image';
  sdxName = 'Name';
  sdxParentName = 'Parent';
  sdxPart = 'Part';
  sdxVersion = 'Version';

  sdxSkinGroupName = 'SkinGroupName';
  sdxSkinIcon = 'SkinIcon';
  sdxSkinIconLarge = 'SkinIconLarge';
  sdxSkinDefaultGroupName = 'Custom Skins';
  sdxSkinDefaultSkinIcon = 'DEFAULTSKINICONSMALL';
  sdxSkinDefaultSkinIconLarge = 'DEFAULTSKINICONLARGE';

  // layout orientation
  sdxLayoutHorz = 'Horizontal';
  sdxLayoutVert = 'Vertical';

  // properties
  sdxAlphaColor = 'AlphaColor';
  sdxBoolean = 'Boolean';
  sdxColor = 'Color';
  sdxContent = 'Content';
  sdxContentCompact = 'ContentCompact';
  sdxContentOffsets = 'ContentOffsets';
  sdxImageCount = 'ImageCount';
  sdxInterpolationMode = 'InterpolationMode';
  sdxRect = 'Rect';
  sdxScaled = 'Scaled';
  sdxSingle = 'Single';
  sdxSize = 'Size';
  sdxString = 'String';
  sdxTextColor = 'TextColor';

  // stretch mode
  sdxStretch = 'Stretch';
  sdxTile = 'Tile';
  sdxNoResize = 'NoResize';

  // scaling mode
  sdxScalingMode = 'ScalingMode';
  sdxStepped = 'Stepped';
  sdxAccurate = 'Accurate';

  // bitmap
  sdxFile = 'File';
  sdxLayout = 'Layout';
  sdxStates = 'States';
  sdxMargins = 'Margins';

  // rect
  sdxBorders = 'Borders';
  sdxBordersInner = 'BordersInner';
  sdxThin = 'Thin';

  sdxLeft = 'Left';
  sdxTop  = 'Top';
  sdxRight = 'Right';
  sdxBottom = 'Bottom';
  
  // size
  sdxWidth = 'Width';
  sdxHeight  = 'Height';

  // Gradient
  sdxGradientBeginColor = 'GradientBeginColor';
  sdxGradientEndColor = 'GradientEndColor';
  sdxGradientMode = 'GradientMode';
  sdxGradientModeBackwardDiagonal = 'BackwardDiagonal';
  sdxGradientModeForwardDiagonal = 'ForwardDiagonal';
  sdxGradientModeHorizontal = 'Horizontal';
  sdxGradientModeVertical = 'Vertical';

const
  dxDefaultColorPaletteItems: array[0..21] of string = (
    'Paint',
    'Paint High',
    'Paint Shadow',
    'Brush',
    'Brush Light',
    'Brush High',
    'Brush Minor',
    'Brush Major',
    'Accent Paint',
    'Accent Paint Light',
    'Accent Brush',
    'Accent Brush Light',
    'Key Paint',
    'Key Brush',
    'Key Brush Light',
    'Black',
    'Blue',
    'Gray',
    'Green',
    'Red',
    'White',
    'Yellow'
  );

  dxDefaultGlyphColorPaletteItems: array[0..5] of string = (
    'Yellow',
    'White',
    'Red',
    'Green',
    'Blue',
    'Black'
  );

const
  CalcEditTextColorsMap: array[TcxCalcButtonKind] of string = (
    sdxSkinsCalcEditEditingOperationTextColor,
    sdxSkinsCalcEditEditingOperationTextColor,
    sdxSkinsCalcEditEditingOperationTextColor,

    sdxSkinsCalcEditMemoryOperationTextColor,
    sdxSkinsCalcEditMemoryOperationTextColor,
    sdxSkinsCalcEditMemoryOperationTextColor,
    sdxSkinsCalcEditMemoryOperationTextColor,    

    sdxSkinsCalcEditDigitTextColor, sdxSkinsCalcEditDigitTextColor,
    sdxSkinsCalcEditDigitTextColor, sdxSkinsCalcEditDigitTextColor,
    sdxSkinsCalcEditDigitTextColor, sdxSkinsCalcEditDigitTextColor,
    sdxSkinsCalcEditDigitTextColor, sdxSkinsCalcEditDigitTextColor,
    sdxSkinsCalcEditDigitTextColor, sdxSkinsCalcEditDigitTextColor,
    sdxSkinsCalcEditDigitTextColor, sdxSkinsCalcEditDigitTextColor,

    sdxSkinsCalcEditArithmeticOperationTextColor,
    sdxSkinsCalcEditArithmeticOperationTextColor,
    sdxSkinsCalcEditArithmeticOperationTextColor,
    sdxSkinsCalcEditArithmeticOperationTextColor,

    sdxSkinsCalcEditScientificOperationTextColor,
    sdxSkinsCalcEditScientificOperationTextColor,
    sdxSkinsCalcEditScientificOperationTextColor,
    sdxSkinsCalcEditScientificOperationTextColor,
    sdxSkinsCalcEditScientificOperationTextColor
  );

  BreadcrumbEditBackgroundColorsMap: array[TdxBreadcrumbEditState] of string = (
    sdxBreadcrumbEditBackgroundColor, sdxBreadcrumbEditBackgroundFocusedColor,
    sdxBreadcrumbEditBackgroundHotColor, sdxBreadcrumbEditBackgroundDisabledColor
  );

  BreadcrumbEditBordersColorsMap: array[TdxBreadcrumbEditState] of string = (
    sdxBreadcrumbEditBorderColor, sdxBreadcrumbEditBorderFocusedColor,
    sdxBreadcrumbEditBorderHotColor, sdxBreadcrumbEditBorderDisabledColor
  );

  CommonGroup: array[0..25] of string =
   (sdxSkinGroupCommon,
    sdxButton, sdxGroupPanel, sdxGroupPanelBottom, sdxGroupPanelCaptionBottom,
    sdxGroupPanelCaptionLeft, sdxGroupPanelCaptionRight, sdxGroupPanelCaptionTop,
    sdxGroupPanelLeft, sdxGroupPanelRight, sdxGroupPanelTop, sdxFilterBoolOperatorBackground,
    sdxFilterItemCaptionBackground, sdxFilterOperatorBackground, sdxFilterPanelBrackets,
    sdxFilterAddButton, sdxFilterRemoveButton, sdxFilterValueBackground,
    sdxScrollButton, sdxScrollContentHorz, sdxScrollContentVert, sdxScrollThumbButtonHorz,
    sdxScrollThumbButtonVert, sdxSizeGrip, sdxSplitterHorz, sdxSplitterVert);

  GanttGroup: array[0..10] of string =
   (sdxSkinGroupGantt,
    sdxGanttDependencyEditPointLeft, sdxGanttDependencyEditPointRight, sdxGanttFocusedRow, sdxGanttMilestone,
    sdxGanttSummaryTask, sdxGanttSummaryTaskProgress, sdxGanttTask, sdxGanttTaskProgress, sdxGanttTaskTextLabel,
    sdxGanttTaskTextLabelHorizontalIndent);

  GridGroup: array[0..14] of string =
   (sdxSkinGroupGrid,
    sdxFilterButton, sdxFilterButtonActive, sdxFilterPanel, sdxFooterCell, sdxFooterPanel,
    sdxGroupByBox, sdxGroupRow, sdxHeader, sdxHeaderLeft, sdxHeaderRight, sdxHeaderSpecial,
    sdxIndicatorImages, sdxPlusMinus, sdxPlusMinusEx);

  VGridGroup: array[0..4] of string =
    (sdxSkinGroupVGrid,
     sdxVGridBandLine, sdxVGridLine, sdxVGridRowHeader, sdxVGridCategory);

  FormGroup: array[0..13] of string =
    (sdxFormFrameLeft, sdxFormCaption, sdxFormFrameRight, sdxFormFrameBottom,
     sdxSmallFormFrameLeft, sdxSmallFormCaption, sdxSmallFormFrameRight,
     sdxSmallFormFrameBottom, sdxSmallFormButtonClose, sdxFormButtonClose,
     sdxFormButtonMinimize, sdxFormButtonMaximize, sdxFormButtonRestore, sdxFormButtonHelp);

  EditButtonsMap: array[TcxEditBtnKind] of string = (sdxCloseButton, sdxComboButtonGlyph,
    sdxEditorButton, sdxEditorButton, sdxSpinUpGlyph, sdxSpinDownGlyph,
    sdxSpinLeftGlyph, sdxSpinRightGlyph);

  FormFrameMap: array[Boolean, TcxBorder] of string =
    ((sdxFormFrameLeft, sdxSmallFormCaption, sdxFormFrameRight, sdxFormFrameBottom),
     (sdxFormFrameLeft, sdxFormCaption, sdxFormFrameRight, sdxFormFrameBottom));

  EditBackgroundColorsMap: array[TcxEditStateColorKind] of string = (
    sdxSkinsEditorBackgroundColor, sdxSkinsEditorBackgroundDisabledColor,
    sdxSkinsEditorBackgroundInactiveColor, sdxSkinsEditorBackgroundReadOnlyColor
  );

  EditTextColorsMap: array[TcxEditStateColorKind] of string = (
    sdxSkinsEditorTextColor, sdxSkinsEditorTextDisabledColor,
    sdxSkinsEditorTextInactiveColor, sdxSkinsEditorTextReadOnlyColor
  );

  LayoutViewElementPaddingMap: array[TcxLayoutElement] of string = (
    sdxLayoutViewGroupPadding, sdxLayoutViewGroupWithoutBordersPadding,
    sdxLayoutViewTabbedGroupPadding, sdxLayoutViewRootGroupPadding,
    sdxLayoutViewRootGroupWithoutBordersPadding, sdxLayoutViewItemPadding
  );

  LayoutViewElementSpacingMap: array[TcxLayoutElement] of string = (
    sdxLayoutViewGroupSpacing, sdxLayoutViewGroupWithoutBordersSpacing,
    sdxLayoutViewTabbedGroupSpacing, sdxLayoutViewRootGroupSpacing,
    sdxLayoutViewRootGroupWithoutBordersSpacing, sdxLayoutViewItemSpacing
  );

  ProgressBarPartNameMap: array[TcxProgressBarPart] of string = (
    sdxProgressBorder, sdxProgressChunk, sdxProgressOverloadBar, sdxProgressPeakBar
  );

implementation

const
  dxThisUnitName = 'dxSkinsStrs';

end.

