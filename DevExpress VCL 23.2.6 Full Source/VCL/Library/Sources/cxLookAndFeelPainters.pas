{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressCommonLibrary                                     }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSCOMMONLIBRARY AND ALL          }
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

unit cxLookAndFeelPainters;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Types, Windows, dxCore, dxUxTheme, dxThemeManager, Classes, Graphics, Generics.Collections, Generics.Defaults,
  Controls, ImgList,
  dxCoreGraphics, dxOffice11, cxClasses, cxGraphics, cxGeometry, dxGDIPlusClasses, cxCustomCanvas, dxThemeConsts,
  dxGenerics, Forms;

const
  cxContainerMaxBorderWidth = 2;
  cxTextOffset = 2;
  cxTextOffsetHalf = 1;
  cxHeaderTextOffset = cxTextOffset;

  cxArrowLeftBasePointIndex = 0;
  cxArrowTopPointIndex = 1;
  cxArrowRightBasePointIndex = 2;

  cxStdThumbnailMinimalSize = 8;

  cxInplaceNavigatorDefaultOffset = 50;

  cxTouchElementMinSize = 27; // ~7mm on 96 dpi
  cxTouchCheckMarkMinSize = 23;

  cxGridDefaultIndicatorWidth = 12;

{$REGION 'internal'}
{$SCOPEDENUMS ON}
type
  TdxPaintPartID = (
    Unknown,
    Button,
    Calc,
    Chart,
    CheckBox,
    CheckComboBox,
    ColorComboBox,
    ColorEdit,
    ComboBox,
    Grid,
    GroupBox,
    Image,
    ImageComboBox,
    ListBox,
    Memo,
    Navigator,
    RadioButton,
    RadioGroup,
    RatingControl,
    Ribbon,
    RichEdit,
    SpreedSheet,
    TextEdit,
    ToggleSwitch,
    TreeList,
    VerticalGrid
  );                  
{$SCOPEDENUMS OFF}
{$ENDREGION}

type
  TcxCustomLookAndFeelPainter = class;
  TcxLookAndFeelStyle = (lfsFlat, lfsStandard, lfsUltraFlat, lfsNative, lfsOffice11, lfsSkin);
  TcxLookAndFeelStyles = set of TcxLookAndFeelStyle;

  TcxEditBtnPosition = (cxbpLeft, cxbpRight);
  TcxGroupBoxCaptionPosition = (cxgpTop, cxgpBottom, cxgpLeft, cxgpRight, cxgpCenter);
  TcxNeighbor = (nLeft, nTop, nRight, nBottom);
  TcxNeighbors = set of TcxNeighbor;
  TcxScrollBarPart = (sbpNone, sbpLineUp, sbpLineDown, sbpThumbnail, sbpPageUp, sbpPageDown);
  TcxTrackBarTicksAlign = (tbtaUp, tbtaDown, tbtaBoth);
  TcxLayoutElement = (leGroup, leGroupWithoutBorders, leTabbedGroup, leRootGroup, leRootGroupWithoutBorders, leItem);

  TdxBevelShape = (dxbsNone, dxbsBox, dxbsFrame, dxbsLineTop, dxbsLineBottom,
    dxbsLineLeft, dxbsLineRight, dxbsLineCenteredHorz, dxbsLineCenteredVert);
  TdxBevelStyle = (dxbsLowered, dxbsRaised);
  TdxBreadcrumbEditButtonState = (dxbcbsNormal, dxbcbsFocused, dxbcbsHot, dxbcbsPressed, dxbcbsDisabled);
  TdxBreadcrumbEditState = (dxbcsNormal, dxbcsFocused, dxbcsHot, dxbcsDisabled);
  TcxEditCheckState = (ecsNormal, ecsHot, ecsPressed, ecsDisabled);
  TcxButtonPart = (cxbpButton, cxbpDropDownLeftPart, cxbpDropDownRightPart);
  TcxButtonState = (cxbsDefault, cxbsNormal, cxbsHot, cxbsPressed, cxbsDisabled);
  TcxCheckBoxState = (cbsUnchecked, cbsChecked, cbsGrayed);
  TcxProgressBarPart = (pbpBackground, pbpProgressChunk, pbpOverloadBar, pbpPeakBar);
  TdxRatingControlIndicatorState = (rcisUnchecked, rcisChecked, rcisHover);

  TdxGalleryItemViewState = record
    Enabled: Boolean;
    Checked: Boolean;
    Hover: Boolean;
    Pressed: Boolean;
    Focused: Boolean;
  end;

  TdxFilterTokenParams = record //for internal use only
    BoolOperatorTextColor: TColor;
    BoolOperatorTextMargins: TRect;
    ElementsIndent: Integer;
    FilterControlBackgroundColor: TColor;
    FilterPanelItemMargins: TRect;
    ItemCaptionTextColor: TColor;
    ItemCaptionTextMargins: TRect;
    OperatorTextColor: TColor;
    OperatorTextMargins: TRect;
    ValueTextColor: TColor;
    ValueTextMargins: TRect;
  end;

  TdxListViewItemState = (dxlisFocused, dxlisHot, dxlisSelected, dxlisDisabled, dxlisInactive);
  TdxListViewItemStates = set of TdxListViewItemState;
  TdxListViewGroupHeaderState = (dxlgsFocused, dxlgsHot, dxlgsCollapsed, dxlgsInactive);
  TdxListViewGroupHeaderStates = set of TdxListViewGroupHeaderState;
  TdxListViewGroupTextKind = (dxlgtHeader, dxlgtSubtitle, dxlgtFooter);
  TcxEditBtnKind = (cxbkCloseBtn, cxbkComboBtn, cxbkEditorBtn, cxbkEllipsisBtn,
    cxbkSpinUpBtn, cxbkSpinDownBtn, cxbkSpinLeftBtn, cxbkSpinRightBtn);
  TcxEditStateColorKind = (esckNormal, esckDisabled, esckInactive, esckReadOnly);
  TcxCalcButtonKind = (cbBack, cbCancel, cbClear, cbMC, cbMR, cbMS, cbMP, cbNum0, cbNum1, cbNum2, cbNum3, cbNum4, cbNum5,
    cbNum6, cbNum7, cbNum8, cbNum9, cbSign, cbDecimal, cbDiv, cbMul, cbSub, cbAdd, cbSqrt, cbPercent, cbRev, cbEqual, cbNone);
  TcxIndicatorKind = (ikNone, ikArrow, ikEdit, ikInsert, ikMultiDot, ikMultiArrow, ikFilter, ikInplaceEdit);
  TdxAlertWindowButtonKind = (awbkClose, awbkPin, awbkDropdown, awbkPrevious, awbkNext, awbkCustom);
  TcxFilterSmartTagState = (fstsNormal, fstsHot, fstsPressed, fstsParentHot);
  TdxMapControlElementState = (mcesNormal, mcesHot, mcesPressed, mcesSelected, mcesDisabled);
  TdxMapControlElementStates = set of TdxMapControlElementState;
  TcxCalendarElementState = (cesNormal, cesHot, cesPressed, cesSelected, cesFocused, cesMarked, cesDisabled, cesHighlighted);
  TcxCalendarElementStates = set of TcxCalendarElementState;
  TcxExpandButtonState = (cebsNormal, cebsSelected, cebsInactive);
  TcxFilterButtonShowMode = (fbmButton, fbmSmartTag, fbmDefault);
  TcxShowFilterButtons = (sfbAlways, sfbWhenSelected, sfbDefault);
  TdxTreeViewNodeState = (dxtnsFocused, dxtnsHot, dxtnsSelected, dxtnsDisabled, dxtnsInactive);
  TdxTreeViewNodeStates = set of TdxTreeViewNodeState;

  TcxContainerBorderStyle = (cbsNone, cbsSingle, cbsThick, cbsFlat, cbs3D, cbsUltraFlat, cbsOffice11);
  TcxContainerBorderState = (cbsNormal, cbsFocused, cbsHovered, cbsFocusedAndHovered, cbsDisabled);
  TcxEditPopupBorderStyle = (epbsDefault, epbsSingle, epbsFrame3D, epbsFlat);
  TcxPopupBorderStyle = (pbsNone, pbsUltraFlat, pbsFlat, pbs3D);

  TcxDrawBackgroundEvent = function(ACanvas: TcxCanvas; const ABounds: TRect): Boolean of object;
  TdxDrawEvent = procedure(ACanvas: TcxCanvas; const ARect: TRect) of object;
  TdxDrawScaledRectEvent = procedure(ACanvas: TcxCanvas; const ARect: TRect; AScaleFactor: TdxScaleFactor) of object;

  IcxLookAndFeelPainterListener = interface
  ['{DCEDBEC6-2C4B-48B9-93E3-26760E7EA468}']
    procedure PainterAdded(APainter: TcxCustomLookAndFeelPainter);
    procedure PainterRemoved(APainter: TcxCustomLookAndFeelPainter);
  end;

  { TcxCustomLookAndFeelPainter }

  TcxCustomLookAndFeelPainter = class(TPersistent) //for internal use
  strict private
    FBackButton: TdxSmartImage;
    FCalendarButtonGlyph: TdxSmartImage;
    FClearButtonGlyph: TdxSmartImage;
    FClockFace: TdxSmartImage;
    FClockGlass: TdxSmartImage;
    FClockFace150: TdxSmartImage;
    FClockGlass150: TdxSmartImage;
    FFilterControlAddButtonGlyph: TdxSmartImage;
    FFilterControlRemoveButtonGlyph: TdxSmartImage;
    FFilterPanelRemoveButtonGlyph: TdxSmartImage;
    FFindPanelNextButtonGlyph: TdxSmartImage;
    FFindPanelPreviousButtonGlyph: TdxSmartImage;
    FFixedGroupIndicator: TdxSmartImage;
    FGroupByBoxSearchButtonGlyph: TdxSmartImage;
    FMapPushpin: TdxSmartImage;
    FNavigationBarCustomizationButton: TdxSmartImage;
    FPasswordRevealButtonGlyphs: array[Boolean] of TdxSmartImage;
    FPinGlyph: TdxSmartImage;
    FRatingControlIndicator: TdxSmartImage;
    FSearchButtonGlyph: TdxSmartImage;
    FSmartTagGlyph: TdxSmartImage;

    function GetBackButton: TdxSmartImage;
    function GetCalendarButtonGlyph: TdxSmartImage;
    function GetClearButtonGlyph: TdxSmartImage;
    function GetClockFace: TdxSmartImage;
    function GetClockGlass: TdxSmartImage;
    function GetFilterControlAddButtonGlyph: TdxSmartImage;
    function GetFilterControlRemoveButtonGlyph: TdxSmartImage;
    function GetFilterPanelRemoveButtonGlyph: TdxSmartImage;
    function GetFindPanelNextButtonGlyph: TdxSmartImage;
    function GetFindPanelPreviousButtonGlyph: TdxSmartImage;
    function GetFixedGroupIndicator: TdxSmartImage;
    function GetGroupByBoxSearchButtonGlyph: TdxSmartImage;
    function GetMapPushpin: TdxSmartImage;
    function GetNavigationBarCustomizationButton: TdxSmartImage;
    function GetPasswordRevealButtonGlyphs(Index: Boolean): TdxSmartImage;
    function GetPinGlyph: TdxSmartImage;
    function GetRangeTrackBarThumbDrawRect(const R: TRect; ATicks: TcxTrackBarTicksAlign; AHorizontal: Boolean): TRect;
    function GetRatingControlIndicator: TdxSmartImage;
    function GetSearchButtonGlyph: TdxSmartImage;
    function GetSmartTagGlyph: TdxSmartImage;
  private
    function GetClockFace150: TdxSmartImage;
    function GetClockGlass150: TdxSmartImage;
  protected
    FLookAndFeelPainterDetailsCache: TObject;

    function CreateLookAndFeelPainterDetails: TObject; virtual;
    function GetLookAndFeelPainterDetails: TObject; virtual;

    function DefaultDateNavigatorHeaderHighlightTextColor: TColor; virtual;
    procedure DoDrawDataRowLayoutContent(ACanvas: TcxCanvas; const ABounds: TRect); virtual;
    procedure DoDrawScaledButtonCaption(ACanvas: TcxCanvas; R: TRect; const ACaption: string;
      AState: TcxButtonState; ATextColor: TColor; ADrawBorder, AIsToolButton, AWordWrap: Boolean;
      AScaleFactor: TdxScaleFactor; APart: TcxButtonPart); virtual;
    procedure DoDrawScaledScrollBarPart(ACanvas: TcxCustomCanvas; AHorizontal: Boolean; R: TRect;
      APart: TcxScrollBarPart; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawBackground(ACanvas: TcxCanvas; const ARect: TRect;
      ATransparent: Boolean; ABackgroundColor: TColor; const ABackgroundBitmap: TBitmap); virtual;
    procedure DrawButtonArrow(ACanvas: TcxCanvas; const R: TRect; AColor: TColor); virtual;
    procedure DrawContent(ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect; AState: TcxButtonState;
      AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert; AMultiLine, AShowEndEllipsis: Boolean;
      const AText: string; AFont: TFont; ATextColor, ABkColor: TColor;
      AOnDrawBackground: TcxDrawBackgroundEvent = nil; AIsFooter: Boolean = False); virtual;
    procedure DrawContentBackground(ACanvas: TcxCustomCanvas; const R: TRect;
      AState: TcxButtonState; ABackgroundColor: TColor; AIsFooter: Boolean); virtual;
    procedure DrawExpandButtonCross(ACanvas: TcxCustomCanvas; const R: TRect;
      AExpanded: Boolean; AColor: TColor; AScaleFactor: TdxScaleFactor);
    procedure DrawListViewColumnHeaderSortingArrow(ACanvas: TcxCustomCanvas; const R: TRect;
      AColor1, AColor2: TColor; AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor);
    procedure DrawMonthHeaderArrows(ACanvas: TcxCanvas; const ABounds: TRect;
      AArrows: TcxArrowDirections; ASideWidth: Integer; AColor: TColor);
    procedure DrawMonthHeaderLeftArrow(ACanvas: TcxCanvas; const ABounds: TRect; AColor: TColor);
    procedure DrawMonthHeaderRightArrow(ACanvas: TcxCanvas; const ABounds: TRect; AColor: TColor);
    procedure DrawRangeControlThumb(ACanvas: TcxCanvas; const ARect: TRect;
      AColor: TColor; ABorderColor: TdxAlphaColor; AScaleFactor: TdxScaleFactor);
    procedure DrawSortingArrow(ACanvas: TcxCanvas; const R: TRect;
      AColor1, AColor2: TColor; AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor);
    procedure DrawSummarySortingArrow(ACanvas: TcxCanvas; const R: TRect;
      AColor1, AColor2: TColor; AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor);
    procedure DrawSchedulerNavigationButtonContent(ACanvas: TcxCanvas; const ARect: TRect; const AArrowRect: TRect;
      AIsNextButton: Boolean; AState: TcxButtonState; const AIsVertical: Boolean = True); virtual;
    function FooterCellOffset: Integer; virtual; // abstract;
    function FooterCellContentOffset: Integer; virtual;
    function FooterContentOffset: Integer; virtual; // abstract;
    function GetArrowDirection(AHorizontal: Boolean; APart: TcxScrollBarPart): TcxArrowDirection;
    function GetDataRowLayoutContentColor: TColor; virtual;
    function GetDataRowLayoutContentMargins: TRect; virtual;
    function GetDataRowLayoutItemMargins(AState: TcxButtonState): TRect; virtual;
    function GetDefaultFixedColumnHighlightAAlpha: Byte; virtual;
    function GetFilterAddButtonColor(AState: TcxButtonState): TdxAlphaColor; virtual;
    function GetFilterRemoveButtonColor(AState: TcxButtonState): TdxAlphaColor; virtual;
    function GetFilterSmartTagColor(AState: TcxFilterSmartTagState; AIsFilterActive: Boolean): TColor; virtual;
    function GetSeparatorBounds(const R: TRect; AWidth: Integer; AIsVertical: Boolean): TRect; virtual;

    procedure ReleaseImageResources; virtual;

    property BackButton: TdxSmartImage read GetBackButton;
    property CalendarButtonGlyph: TdxSmartImage read GetCalendarButtonGlyph;
    property ClearButtonGlyph: TdxSmartImage read GetClearButtonGlyph;
    property ClockFace: TdxSmartImage read GetClockFace;
    property ClockGlass: TdxSmartImage read GetClockGlass;
    property ClockFace150: TdxSmartImage read GetClockFace150;
    property ClockGlass150: TdxSmartImage read GetClockGlass150;
    property FilterControlAddButtonGlyph: TdxSmartImage read GetFilterControlAddButtonGlyph;
    property FilterControlRemoveButtonGlyph: TdxSmartImage read GetFilterControlRemoveButtonGlyph;
    property FilterPanelRemoveButtonGlyph: TdxSmartImage read GetFilterPanelRemoveButtonGlyph;
    property FindPanelNextButtonGlyph: TdxSmartImage read GetFindPanelNextButtonGlyph;
    property FindPanelPreviousButtonGlyph: TdxSmartImage read GetFindPanelPreviousButtonGlyph;
    property FixedGroupIndicator: TdxSmartImage read GetFixedGroupIndicator;
    property GroupByBoxSearchButtonGlyph: TdxSmartImage read GetGroupByBoxSearchButtonGlyph;
    property MapPushpin: TdxSmartImage read GetMapPushpin;
    property NavigationBarCustomizationButton: TdxSmartImage read GetNavigationBarCustomizationButton;
    property PasswordRevealButtonGlyphs[Index: Boolean]: TdxSmartImage read GetPasswordRevealButtonGlyphs;
    property PinGlyph: TdxSmartImage read GetPinGlyph;
    property RatingControlIndicator: TdxSmartImage read GetRatingControlIndicator;
    property SearchButtonGlyph: TdxSmartImage read GetSearchButtonGlyph;
    property SmartTagGlyph: TdxSmartImage read GetSmartTagGlyph;
  public
    destructor Destroy; override;

    function GetPainterData(var AData): Boolean; virtual;
    function GetPainterDetails(var ADetails): Boolean; virtual;
    function IsInternalPainter: Boolean; virtual;
    function LookAndFeelName: string; virtual;
    function LookAndFeelStyle: TcxLookAndFeelStyle; virtual;
    function NeedRedrawOnResize: Boolean; virtual;
    procedure ResetLookAndFeelSettings; virtual;

    procedure DrawScaledEditorBackground(ACanvas: TcxCanvas; const R: TRect; AIsInplace, AReadOnly: Boolean; AColor: TColor; AState: TcxContainerBorderState; AScaleFactor: TdxScaleFactor; const APalette: IdxColorPalette = nil); virtual;
    procedure DrawScaledImageEditorBackground(ACanvas: TcxCanvas; const R: TRect; AIsInplace, AReadOnly: Boolean; AColor: TColor; AState: TcxContainerBorderState; AScaleFactor: TdxScaleFactor; const APalette: IdxColorPalette = nil); virtual;
    procedure DrawScaledListBoxBackground(ACanvas: TcxCanvas; const R: TRect; AIsInplace: Boolean; AColor: TColor; AState: TcxContainerBorderState; AScaleFactor: TdxScaleFactor; const APalette: IdxColorPalette = nil); virtual;
    procedure DrawScaledListBoxItemBackground(ACanvas: TcxCanvas; const ARect: TRect; AState: TOwnerDrawState; AScaleFactor: TdxScaleFactor); virtual;
    function GetEditorGlyphIndent(ALeftMost, AIsInplace: Boolean; AScaleFactor: TdxScaleFactor; APaintPartID: TdxPaintPartID = TdxPaintPartID.Unknown): Integer; virtual;
    function GetEditorPadding(AIsInplace: Boolean; AScaleFactor: TdxScaleFactor): TRect; virtual; 
    function GetEditorButtonPadding(AScaleFactor: TdxScaleFactor): TRect; virtual;
    function GetEditorButtonsPadding(AScaleFactor: TdxScaleFactor): TRect; virtual;
    function GetEditorItemsPadding(AScaleFactor: TdxScaleFactor): TRect; virtual;
    function GetImageEditorPadding(AIsInplace: Boolean; AScaleFactor: TdxScaleFactor): TRect; virtual; 
    function GetListBoxBackgroundPadding(AIsInplace: Boolean; AScaleFactor: TdxScaleFactor): TRect; virtual; 
    function GetListBoxItemPadding(AScaleFactor: TdxScaleFactor): TRect; virtual; 
    function GetListBoxScrollBarPadding(AIsInplace: Boolean; AKind: TScrollBarKind; AScaleFactor: TdxScaleFactor): TRect; virtual;
    function SupportsEditorBorders: Boolean; virtual;
    function SupportsEditorPadding(const AIsInplace: Boolean): Boolean; virtual;
    function SupportsImageEditorPadding: Boolean; virtual;
    function SupportsListBoxPadding: Boolean; virtual;
    function SupportsEditorShadow: Boolean; virtual;
    function SupportsTransparentBorder: Boolean; virtual;

    function DefaultListBoxSelectionTextColor: TColor; virtual;
    function UseDefaultListBoxSelectionTextColor: Boolean; virtual;

    function ActiveColorPalette: IdxColorPalette; virtual;
    function DefaultContentColor: TColor; virtual;
    function DefaultContentEvenColor: TColor; virtual;
    function DefaultContentGlyphColorPalette(AState: TcxButtonState): IdxColorPalette; virtual;
    function DefaultContentOddColor: TColor; virtual;
    function DefaultContentTextColor: TColor; virtual;
    function DefaultControlColor: TColor; virtual;
    function DefaultControlTextColor: TColor; virtual;
    function DefaultCustomScrollbarAnnotationColor: TdxAlphaColor; virtual;
    function DefaultEditorBackgroundColor(AIsDisabled: Boolean): TColor; virtual;
    function DefaultEditorBackgroundColorEx(AKind: TcxEditStateColorKind): TColor; virtual;
    function DefaultEditorTextColor(AIsDisabled: Boolean): TColor; virtual;
    function DefaultEditorTextColorEx(AKind: TcxEditStateColorKind): TColor; virtual;
    function DefaultErrorScrollbarAnnotationColor: TdxAlphaColor; virtual;
    function DefaultFilterBoxColor: TColor; virtual;
    function DefaultFilterBoxTextColor: TColor; virtual;
    function DefaultFixedColumnHighlightColor: TdxAlphaColor; virtual;
    function DefaultFixedSeparatorColor: TColor; virtual;
    function DefaultFocusedScrollbarAnnotationColor: TdxAlphaColor; virtual;
    function DefaultFooterColor: TColor; virtual;
    function DefaultFooterTextColor: TColor; virtual;
    function DefaultGridExpandButtonIndent: Integer; virtual;
    function DefaultGridDetailsSiteColor: TColor; virtual;
    function DefaultGridLineColor: TColor; virtual;
    function DefaultGroupByBoxColor: TColor; virtual;
    function DefaultGroupByBoxLineColor: TColor; virtual;
    function DefaultGroupByBoxTextColor: TColor; virtual;
    function DefaultGroupColor: TColor; virtual;
    function DefaultGroupContentOffsets(AScaleFactor: TdxScaleFactor = nil): TRect; virtual;
    function DefaultGroupTextColor: TColor; virtual;
    function DefaultHeaderBackgroundColor: TColor; virtual;
    function DefaultHeaderBackgroundTextColor: TColor; virtual;
    function DefaultHeaderColor: TColor; virtual;
    function DefaultHeaderTextColor: TColor; virtual;
    function DefaultHyperlinkTextColor: TColor; virtual;
    function DefaultInactiveColor: TColor; virtual;
    function DefaultInactiveTextColor: TColor; virtual;
    function DefaultLabelTextColorEx(AKind: TcxEditStateColorKind): TColor; virtual;
    function DefaultPreviewTextColor: TColor; virtual;
    function DefaultRecordSeparatorColor: TColor; virtual;
    function DefaultSearchResultAnnotationColor: TdxAlphaColor; virtual;
    function DefaultSearchResultHighlightColor: TColor; virtual;
    function DefaultSearchResultHighlightTextColor: TColor; virtual;
    function DefaultSelectedScrollbarAnnotationColor: TdxAlphaColor; virtual;
    function DefaultSizeGripAreaColor: TColor; virtual;

    function DefaultTreeListGridLineColor: TColor; virtual;
    function DefaultTreeListTreeLineColor: TColor; virtual;

    function DefaultVGridBandLineColor: TColor; virtual;
    function DefaultVGridCategoryColor: TColor; virtual;
    function DefaultVGridCategoryTextColor: TColor; virtual;
    function DefaultVGridContentColor: TColor; virtual;
    function DefaultVGridContentEvenColor: TColor; virtual;
    function DefaultVGridContentOddColor: TColor; virtual;
    function DefaultVGridContentTextColor: TColor; virtual;
    function DefaultVGridHeaderColor: TColor; virtual;
    function DefaultVGridHeaderTextColor: TColor; virtual;
    function DefaultVGridLineColor: TColor; virtual;

    function DefaultDateNavigatorContentColor: TColor; virtual;
    function DefaultDateNavigatorHeaderColor: TColor; virtual;
    function DefaultDateNavigatorHeaderTextColor(AIsHighlight: Boolean): TColor; virtual;
    function DefaultDateNavigatorHolydayTextColor: TColor; virtual;
    function DefaultDateNavigatorInactiveTextColor: TColor; virtual;
    function DefaultDateNavigatorSelectionColor: TColor; virtual;
    function DefaultDateNavigatorSelectionTextColor: TColor; virtual;
    function DefaultDateNavigatorSeparator1Color: TColor; virtual;
    function DefaultDateNavigatorSeparator2Color: TColor; virtual;
    function DefaultDateNavigatorTextColor: TColor; virtual;
    function DefaultDateNavigatorTodayFrameColor: TColor; virtual;
    function DefaultDateNavigatorTodayTextColor(ASelected: Boolean = False): TColor; virtual;
    function DefaultDateNavigatorWeekendTextColor: TColor; virtual;

    function DefaultSchedulerBackgroundColor: TColor; virtual;
    function DefaultSchedulerBorderColor: TColor; virtual;
    function DefaultSchedulerContentColor(AResourceIndex: Integer): TColor; virtual;
    function DefaultSchedulerControlColor: TColor; virtual;
    function DefaultSchedulerDayHeaderColor: TColor; virtual;
    function DefaultSchedulerDayHeaderBorderColor: TColor; virtual;
    function DefaultSchedulerDayHeaderTextColor: TColor; virtual;
    function DefaultSchedulerDateNavigatorArrowColor(AIsHighlight: Boolean): TColor; virtual;
    function DefaultSchedulerHeaderContainerAlternateBackgroundColor: TColor; virtual;
    function DefaultSchedulerHeaderContainerBackgroundColor(ASelected: Boolean): TColor; virtual;
    function DefaultSchedulerHeaderContainerTextColor(ASelected: Boolean): TColor; virtual;
    function DefaultSchedulerHeaderContainerBorderColor: TColor; virtual;
    function DefaultSchedulerEventColor(AIsAllDayEvent: Boolean): TColor; virtual;
    function DefaultSchedulerEventColorClassic(AIsAllDayEvent: Boolean): TColor; virtual;
    function DefaultSchedulerNavigatorColor: TColor; virtual;
    function DefaultSchedulerSelectedEventBorderColor: TColor; virtual;
    function DefaultSchedulerTextColor: TColor; virtual;
    function DefaultSchedulerTimeRulerBorderColor: TColor; virtual;
    function DefaultSchedulerTimeRulerBorderColorClassic: TColor; virtual;
    function DefaultSchedulerTimeRulerColor: TColor; virtual;
    function DefaultSchedulerTimeRulerColorClassic: TColor; virtual;
    function DefaultSchedulerTimeRulerTextColor: TColor; virtual;
    function DefaultSchedulerTimeRulerTextColorClassic: TColor; virtual;
    function DefaultSchedulerViewContentColor: TColor; virtual;
    function DefaultSchedulerViewContentColorClassic: TColor; virtual;
    function DefaultSchedulerViewSelectedTextColor: TColor; virtual;
    function DefaultSchedulerViewTextColor: TColor; virtual;
    function DefaultSchedulerYearViewUnusedContentColor(AIsWorkTime: Boolean): TColor; virtual;

    function DefaultHotTrackColor: TColor; virtual;
    function DefaultHotTrackTextColor: TColor; virtual;
    function DefaultSelectionColor: TColor; virtual;
    function DefaultSelectionTextColor: TColor; virtual;
    function DefaultSeparatorColor: TColor; virtual;
    function DefaultTabColor: TColor; virtual;
    function DefaultTabTextColor: TColor; virtual;
    function DefaultTabsBackgroundColor: TColor; virtual;
    function DefaultRootTabsBackgroundColor: TColor; virtual;

    function DefaultTimeGridMajorScaleColor: TColor; virtual;
    function DefaultTimeGridMajorScaleTextColor: TColor; virtual;
    function DefaultTimeGridMinorScaleColor: TColor; virtual;
    function DefaultTimeGridMinorScaleTextColor: TColor; virtual;
    function DefaultTimeGridSelectionBarColor: TColor; virtual;

    function DefaultChartDiagramValueBorderColor: TColor; virtual;
    function DefaultChartDiagramValueCaptionTextColor: TColor; virtual;
    function DefaultChartHistogramAxisColor: TColor; virtual;
    function DefaultChartHistogramGridLineColor: TColor; virtual;
    function DefaultChartHistogramPlotColor: TColor; virtual;
    function DefaultChartPieDiagramSeriesSiteBorderColor: TColor; virtual;
    function DefaultChartPieDiagramSeriesSiteCaptionColor: TColor; virtual;
    function DefaultChartPieDiagramSeriesSiteCaptionTextColor: TColor; virtual;
    function DefaultChartToolBoxDataLevelInfoBorderColor: TColor; virtual;
    function DefaultChartToolBoxItemSeparatorColor: TColor; virtual;

    // LayoutView
    function DefaultLayoutViewCaptionColor(AState: TcxButtonState): TColor; virtual;
    function DefaultLayoutViewCaptionTextColor(ACaptionPosition: TcxGroupBoxCaptionPosition; AState: TcxButtonState): TColor; virtual;
    function DefaultLayoutViewContentColor: TColor; virtual;
    function DefaultLayoutViewContentTextColor(AState: TcxButtonState): TColor; virtual;

    function DefaultGridOptionsTreeViewCategoryColor(ASelected: Boolean): TColor; virtual;
    function DefaultGridOptionsTreeViewCategoryTextColor(ASelected: Boolean): TColor; virtual;

    // Arrow
    procedure CalculateArrowPoints(R: TRect; var P: TcxArrowPoints; AArrowDirection: TcxArrowDirection; AProportional: Boolean; AArrowSize: Integer = 0);
    procedure DrawArrow(ACanvas: TcxCustomCanvas; const R: TRect; AArrowDirection: TcxArrowDirection; AColor: TColor); overload; virtual;
    procedure DrawArrow(ACanvas: TcxCustomCanvas; const R: TRect; AState: TcxButtonState; AArrowDirection: TcxArrowDirection; ADrawBorder: Boolean = True); overload; 
    procedure DrawArrowBorder(ACanvas: TcxCustomCanvas; const R: TRect; AState: TcxButtonState); 
    procedure DrawCollapseArrow(ACanvas: TcxCanvas; R: TRect; AColor: TColor; ALineWidth: Integer = 1); virtual;
    procedure DrawScaledArrow(ACanvas: TcxCustomCanvas; const R: TRect; AState: TcxButtonState;
      AArrowDirection: TcxArrowDirection; AScaleFactor: TdxScaleFactor; ADrawBorder: Boolean = True); overload; virtual;
    procedure DrawScaledArrowBorder(ACanvas: TcxCustomCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawScaledScrollBarArrow(ACanvas: TcxCustomCanvas; R: TRect; AState: TcxButtonState; AArrowDirection: TcxArrowDirection; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawScrollBarArrow(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AArrowDirection: TcxArrowDirection); 

    // Border
    function BorderSize: Integer; virtual;
    function SeparatorSize: Integer; virtual;
    procedure DrawBorder(ACanvas: TcxCustomCanvas; R: TRect; AWidth: Integer = 1); virtual;
    procedure DrawContainerBorder(ACanvas: TcxCanvas; const R: TRect; AStyle: TcxContainerBorderStyle;
      AWidth: Integer; AColor: TColor; ABorders: TcxBorders); virtual;
    procedure DrawContainerBorderedBackground(ACanvas: TcxCanvas; const R: TRect; AStyle: TcxContainerBorderStyle;
      AWidth: Integer; AColor: TColor; ABorders: TcxBorders; AState: TcxContainerBorderState); virtual;
    procedure DoDrawSeparator(ACanvas: TcxCustomCanvas; R: TRect; AIsVertical: Boolean); virtual;
    procedure DrawSeparator(ACanvas: TcxCustomCanvas; const R: TRect; AIsVertical: Boolean);
    function IncludeTopBorderToSectionHeaderForLightBorders: Boolean; virtual; // for internal use
    function SupportsRoundedContainerBorders(AControlID: Integer; AIsInplace: Boolean): Boolean; virtual;

    // Pin
    procedure DrawPin(ACanvas: TcxCanvas; const ABounds: TRect; AColor: TColor; APinned: Boolean);
    procedure DrawShellQuickAccessPin(ACanvas: TcxCanvas; const R: TRect; AImageFitMode: TcxImageFitMode; APalette: IdxColorPalette);

    // Buttons
    function ButtonBorderSize(AState: TcxButtonState = cxbsNormal): Integer; virtual; // abstract;
    function ButtonColor(AState: TcxButtonState): TColor; virtual;
    function ButtonColorPalette(AState: TcxButtonState; APart: TcxButtonPart = cxbpButton): IdxColorPalette; virtual;
    function ButtonDescriptionTextColor(AState: TcxButtonState; ADefaultColor: TColor = clDefault; APart: TcxButtonPart = cxbpButton): TColor; virtual;
    function ButtonFocusRect(ACanvas: TcxCanvas; R: TRect): TRect; 
    function ButtonSymbolColor(AState: TcxButtonState; ADefaultColor: TColor = clDefault; APart: TcxButtonPart = cxbpButton): TColor; virtual;
    function ButtonSymbolState(AState: TcxButtonState): TcxButtonState; virtual;
    function ButtonTextOffset: Integer; 
    function ButtonTextShift: Integer; 
    function ScaledButtonFocusRect(ACanvas: TcxCanvas; R: TRect; AScaleFactor: TdxScaleFactor): TRect; virtual;
    function ScaledButtonTextOffset(AScaleFactor: TdxScaleFactor): Integer; virtual; // abstract;
    function ScaledButtonTextShift(AScaleFactor: TdxScaleFactor): Integer; virtual; // abstract;
    procedure DrawButton(ACanvas: TcxCanvas; R: TRect; const ACaption: string; AState: TcxButtonState;
      ADrawBorder: Boolean = True; AColor: TColor = clDefault; ATextColor: TColor = clDefault;
      AWordWrap: Boolean = False; AIsToolButton: Boolean = False; APart: TcxButtonPart = cxbpButton); 
    procedure DrawButtonBorder(ACanvas: TcxCustomCanvas; R: TRect; AState: TcxButtonState); virtual; // abstract;
    procedure DrawButtonCross(ACanvas: TcxCanvas; const R: TRect; AColor: TColor; AState: TcxButtonState); overload; 
    procedure DrawButtonCross(ACanvas: TcxCanvas; const R: TRect; AColor: TColor; AState: TcxButtonState; ASize: Integer); overload; 
    procedure DrawScaledButton(ACanvas: TcxCustomCanvas; R: TRect; AState: TcxButtonState;
      AScaleFactor: TdxScaleFactor; APart: TcxButtonPart; AColor: TColor = clDefault); overload;
    procedure DrawScaledButton(ACanvas: TcxCustomCanvas; R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor;
      ADrawBorder: Boolean = True; AIsToolButton: Boolean = False; APart: TcxButtonPart = cxbpButton; AColor: TColor = clDefault); overload; virtual;
    procedure DrawScaledButton(ACanvas: TcxCustomCanvas; R: TRect; AState: TcxButtonState; AFocused: Boolean; AScaleFactor: TdxScaleFactor;
      ADrawBorder: Boolean = True; AIsToolButton: Boolean = False; APart: TcxButtonPart = cxbpButton; AColor: TColor = clDefault); overload; virtual;
    procedure DrawScaledButton(ACanvas: TcxCanvas; R: TRect; const ACaption: string; AState: TcxButtonState;
      AScaleFactor: TdxScaleFactor; ADrawBorder: Boolean = True; AColor: TColor = clDefault;
      ATextColor: TColor = clDefault; AWordWrap: Boolean = False; AIsToolButton: Boolean = False;
      APart: TcxButtonPart = cxbpButton); overload;
    procedure DrawScaledButtonCross(ACanvas: TcxCanvas; const R: TRect; AColor: TColor; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
    procedure DrawScaledButtonCrossEx(ACanvas: TcxCanvas; const R: TRect; AColor: TColor; AState: TcxButtonState; ASize: Integer; AScaleFactor: TdxScaleFactor);
    procedure DrawScaledClearButtonGlyph(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawScaledDropDownButtonArrow(ACanvas: TcxCustomCanvas; R: TRect; AState: TcxButtonState;
      AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault); virtual;
    procedure DrawScaledSearchEditButtonGlyph(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawScaledPasswordRevealButton(ACanvas: TcxCanvas; const ARect: TRect; AButtonState: TcxButtonState; AColor: TColor;
      AScaleFactor: TdxScaleFactor);
    procedure DrawSearchEditButtonGlyph(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState); 
    function GetDropDownButtonRightPartSize: Integer; 
    function GetScaledClearButtonGlyphSize(AScaleFactor: TdxScaleFactor): TSize; virtual;
    function GetScaledDropDownButtonRightPartSize(AScaleFactor: TdxScaleFactor): Integer; virtual;
    function IsButtonHotTrack: Boolean; virtual; // abstract;
    function IsPointOverGroupExpandButton(const R: TRect; const P: TPoint): Boolean; virtual;
    function ScaledSearchButtonGlyphSize(AScaleFactor: TdxScaleFactor): TSize; virtual;

    // Expand Button
    procedure DrawExpandButton(ACanvas: TcxCanvas; const R: TRect; AExpanded: Boolean; AColor: TColor = clDefault); 
    procedure DrawExpandButtonEx(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AExpanded: Boolean; ARotationAngle: TcxRotationAngle = ra0); 
    function DrawExpandButtonFirst: Boolean; virtual;
    procedure DrawExpandMark(ACanvas: TcxCanvas; const R: TRect; AColor: TColor; AExpanded: Boolean); 
    procedure DrawGroupExpandButton(ACanvas: TcxCanvas; const R: TRect; AExpanded: Boolean; AState: TcxButtonState); 
    procedure DrawScaledExpandButton(ACanvas: TcxCustomCanvas; const R: TRect;
      AExpanded: Boolean; AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault;
      AState: TcxExpandButtonState = cebsNormal); overload; virtual; abstract;
    procedure DrawScaledExpandButton(ACanvas: TcxCanvas; const R: TRect;
      AExpanded: Boolean; AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault;
      AState: TcxExpandButtonState = cebsNormal); overload;
    procedure DrawScaledExpandButtonEx(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState;
      AExpanded: Boolean; AScaleFactor: TdxScaleFactor; ARotationAngle: TcxRotationAngle = ra0); overload; virtual;
    procedure DrawScaledExpandMark(ACanvas: TcxCustomCanvas; const R: TRect;
      AColor: TColor; AExpanded: Boolean; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawScaledGroupExpandButton(ACanvas: TcxCustomCanvas; const R: TRect;
      AExpanded: Boolean; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawScaledSmallExpandButton(ACanvas: TcxCanvas; R: TRect; AExpanded: Boolean;
      ABorderColor: TColor; AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault); virtual;
    procedure DrawSmallExpandButton(ACanvas: TcxCanvas; R: TRect; AExpanded: Boolean;
      ABorderColor: TColor; AColor: TColor = clDefault); 
    procedure DrawTreeViewExpandButton(ACanvas: TcxCanvas; const R: TRect;
      AExpanded: Boolean; AExplorerStyle: Boolean; AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault;
      AState: TcxExpandButtonState = cebsNormal); overload; virtual; //
    function ExpandButtonAreaSize: Integer; 
    function ExpandButtonSize: Integer; 
    function GroupExpandButtonSize: Integer; 
    function SmallExpandButtonSize: Integer; 
    function ScaledExpandButtonAreaSize(AScaleFactor: TdxScaleFactor): Integer; virtual;
    function ScaledExpandButtonSize(AScaleFactor: TdxScaleFactor): Integer; virtual; abstract;
    function ScaledGroupExpandButtonSize(AScaleFactor: TdxScaleFactor): Integer; virtual;
    function ScaledSmallExpandButtonSize(AScaleFactor: TdxScaleFactor): Integer; virtual;
    function TreeViewExpandButtonSize(AExplorerStyle: Boolean; AScaleFactor: TdxScaleFactor): TSize; virtual;

    // CommandLink
    function DefaultCommandLinkTextColor(AState: TcxButtonState; ADefaultColor: TColor = clDefault): TColor; virtual;
    procedure DrawCommandLinkBackground(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AColor: TColor = clDefault); 
    procedure DrawCommandLinkGlyph(ACanvas: TcxCanvas; const AGlyphPos: TPoint; AState: TcxButtonState); 
    procedure DrawScaledCommandLinkBackground(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault); virtual;
    procedure DrawScaledCommandLinkGlyph(ACanvas: TcxCanvas; const AGlyphPos: TPoint; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); virtual;
    function GetCommandLinkGlyphSize: TSize; 
    function GetCommandLinkMargins: TRect; 
    function GetScaledCommandLinkGlyphSize(AScaleFactor: TdxScaleFactor): TSize; virtual;
    function GetScaledCommandLinkMargins(AScaleFactor: TdxScaleFactor): TRect; virtual;

    // Header
    procedure DrawHeader(ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect; ANeighbors: TcxNeighbors;
      ABorders: TcxBorders; AState: TcxButtonState; AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert;
      AMultiLine, AShowEndEllipsis: Boolean; const AText: string; AFont: TFont; ATextColor, ABkColor: TColor;
      AOnDrawBackground: TcxDrawBackgroundEvent = nil; AIsLast: Boolean = False; AIsGroup: Boolean = False); 
    procedure DrawHeaderEx(ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect; ANeighbors: TcxNeighbors;
      ABorders: TcxBorders; AState: TcxButtonState; AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert;
      AMultiLine, AShowEndEllipsis: Boolean; const AText: string; AFont: TFont; ATextColor, ABkColor: TColor;
      AOnDrawBackground: TcxDrawBackgroundEvent = nil); 
    procedure DrawHeaderBorder(ACanvas: TcxCustomCanvas; const R: TRect; ANeighbors: TcxNeighbors; ABorders: TcxBorders); virtual;
    procedure DrawHeaderPressed(ACanvas: TcxCanvas; const ABounds: TRect); virtual;
    procedure DrawHeaderControlSection(ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect; ANeighbors: TcxNeighbors;
      ABorders: TcxBorders; AState: TcxButtonState; AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert;
      AMultiLine, AShowEndEllipsis: Boolean; const AText: string; AFont: TFont; ATextColor, ABkColor: TColor); 
    procedure DrawHeaderControlSectionBorder(ACanvas: TcxCanvas; const R: TRect; ABorders: TcxBorders; AState: TcxButtonState); virtual;
    procedure DrawHeaderControlSectionContent(ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect;
      AState: TcxButtonState; AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert; AMultiLine, AShowEndEllipsis: Boolean;
      const AText: string; AFont: TFont; ATextColor, ABkColor: TColor); virtual;
    procedure DrawHeaderControlSectionText(ACanvas: TcxCanvas; const ATextAreaBounds: TRect; AState: TcxButtonState;
      AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert; AMultiLine, AShowEndEllipsis: Boolean;
      const AText: string; AFont: TFont; ATextColor: TColor); virtual;
    procedure DrawHeaderSeparator(ACanvas: TcxCanvas; const ABounds: TRect;
      AIndentSize: Integer; AColor: TColor; AViewParams: TcxViewParams); virtual;
    procedure DrawScaledHeader(ACanvas: TcxCustomCanvas; const ABounds: TRect; AState: TcxButtonState; ANeighbors: TcxNeighbors;
      ABorders: TcxBorders; AScaleFactor: TdxScaleFactor; AIsLast: Boolean = False; AIsGroup: Boolean = False); overload; virtual;
    procedure DrawScaledHeader(ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect; ANeighbors: TcxNeighbors;
      ABorders: TcxBorders; AState: TcxButtonState; AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert;
      AMultiLine, AShowEndEllipsis: Boolean; const AText: string; AFont: TFont; ATextColor, ABkColor: TColor;
      AScaleFactor: TdxScaleFactor; AOnDrawBackground: TcxDrawBackgroundEvent = nil; AIsLast: Boolean = False;
      AIsGroup: Boolean = False; ABorderWidth: Integer = 1); overload; virtual;
    procedure DrawScaledHeaderEx(ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect; ANeighbors: TcxNeighbors;
      ABorders: TcxBorders; AState: TcxButtonState; AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert;
      AMultiLine, AShowEndEllipsis: Boolean; const AText: string; AFont: TFont; ATextColor, ABkColor: TColor;
      AScaleFactor: TdxScaleFactor; AOnDrawBackground: TcxDrawBackgroundEvent = nil); overload; virtual;
    procedure DrawScaledHeaderControlSection(ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect; ANeighbors: TcxNeighbors;
      ABorders: TcxBorders; AState: TcxButtonState; AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert;
      AMultiLine, AShowEndEllipsis: Boolean; const AText: string; AFont: TFont; ATextColor, ABkColor: TColor; AScaleFactor: TdxScaleFactor); overload; virtual;
    function HeaderBorders(ANeighbors: TcxNeighbors): TcxBorders; virtual;
    function HeaderBorderSize: Integer; virtual;
    function HeaderBounds(const ABounds: TRect; ANeighbors: TcxNeighbors; ABorders: TcxBorders = cxBordersAll): TRect; virtual;
    function HeaderContentBounds(const ABounds: TRect; ABorders: TcxBorders): TRect; 
    function HeaderContentOffsets(AScaleFactor: TdxScaleFactor): TRect; virtual;
    function HeaderControlSectionBorderSize(AState: TcxButtonState = cxbsNormal): Integer; virtual;
    function HeaderControlSectionContentBounds(const ABounds: TRect; AState: TcxButtonState): TRect; virtual;
    function HeaderControlSectionTextAreaBounds(ABounds: TRect; AState: TcxButtonState): TRect; virtual;
    function HeaderDrawCellsFirst: Boolean; virtual;
    function HeaderGlyphColorPalette(AState: TcxButtonState): IdxColorPalette; virtual;
    function HeaderHeight(AFontHeight: Integer): Integer; 
    function HeaderWidth(ACanvas: TcxCanvas; ABorders: TcxBorders; const AText: string; AFont: TFont): Integer; 
    function IsHeaderHotTrack: Boolean; virtual;
    function ScaledHeaderContentBounds(const ABounds: TRect; ABorders: TcxBorders; AScaleFactor: TdxScaleFactor): TRect; virtual;
    function ScaledHeaderHeight(AFontHeight: Integer; AScaleFactor: TdxScaleFactor): Integer; virtual;
    function ScaledHeaderWidth(ACanvas: TcxCanvas; ABorders: TcxBorders; const AText: string; AFont: TFont; AScaleFactor: TdxScaleFactor): Integer; virtual;

    // Sorting Marks
    procedure DrawScaledSortingMark(ACanvas: TcxCanvas; const R: TRect; AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor); virtual; abstract;
    procedure DrawScaledSummarySortingMark(ACanvas: TcxCanvas; const R: TRect; AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor); virtual; abstract;
    procedure DrawScaledSummaryValueSortingMark(ACanvas: TcxCanvas; const R: TRect; AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawSortingMark(ACanvas: TcxCanvas; const R: TRect; AAscendingSorting: Boolean); 
    procedure DrawSummarySortingMark(ACanvas: TcxCanvas; const R: TRect; AAscendingSorting: Boolean); 
    procedure DrawSummaryValueSortingMark(ACanvas: TcxCanvas; const R: TRect; AAscendingSorting: Boolean); 
    function SortingMarkAreaSize: TPoint; 
    function SortingMarkSize: TPoint; 
    function SummarySortingMarkSize: TPoint; 
    function SummaryValueSortingMarkSize: TPoint; 
    function ScaledSortingMarkAreaSize(AScaleFactor: TdxScaleFactor): TPoint; virtual;
    function ScaledSortingMarkSize(AScaleFactor: TdxScaleFactor): TPoint; virtual; abstract;
    function ScaledSummarySortingMarkSize(AScaleFactor: TdxScaleFactor): TPoint; virtual; abstract;
    function ScaledSummaryValueSortingMarkSize(AScaleFactor: TdxScaleFactor): TPoint; overload; virtual;

    // Grid
    procedure DrawFilterRowSeparator(ACanvas: TcxCanvas; const ARect: TRect; ABackgroundColor: TColor); virtual;
    procedure DrawGroupByBox(ACanvas: TcxCanvas; const ARect: TRect;
      ATransparent: Boolean; ABackgroundColor: TColor; const ABackgroundBitmap: TBitmap); virtual;
    procedure DrawScaledGroupByBox(ACanvas: TcxCanvas; const ARect: TRect;
      ATransparent: Boolean; ABackgroundColor: TColor; const ABackgroundBitmap: TBitmap;
      AScaleFactor, ABordersScaleFactor: TdxScaleFactor); virtual;
    procedure DrawScaledFindPanelNextButtonGlyph(ACanvas: TcxCanvas; const ARect: TRect;
      const AState: TcxButtonState; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawScaledFindPanelPreviousButtonGlyph(ACanvas: TcxCanvas; const ARect: TRect;
      const AState: TcxButtonState; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawScaledGroupByBoxSearchButtonGlyph(ACanvas: TcxCanvas; const ARect: TRect;
      const AState: TcxButtonState; AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault); virtual;
    function GridBordersOverlapSize: Integer; virtual;
    function GridDefaultIndicatorWidth: Integer; virtual;
    function GridGroupRowStyleOffice11ContentColor(AHasData: Boolean): TColor; virtual;
    function GridGroupRowStyleOffice11SeparatorColor: TColor; virtual;
    function GridGroupRowStyleOffice11TextColor: TColor; virtual;
    function GridDrawHeaderCellsFirst: Boolean; virtual;
    function GridScaleGridLines: Boolean; virtual; // for internal use
    function GridUseDiscreteScalingForGridLines: Boolean; virtual; // for internal use
    function PivotGridHeadersAreaColor: TColor; virtual;
    function PivotGridHeadersAreaTextColor: TColor; virtual;
    // Grid like common
    function GridLikeControlBackgroundColor: TColor; virtual;
    function GridLikeControlContentColor: TColor; virtual;
    function GridLikeControlContentEvenColor: TColor; virtual;
    function GridLikeControlContentOddColor: TColor; virtual;
    function GridLikeControlContentTextColor: TColor; virtual;
    function GridLikeControlDefaultUseOddEvenStyle: Boolean; virtual;
    // Layout View
    procedure LayoutViewDrawItem(ACanvas: TcxCanvas; const ABounds: TRect;
      AState: TcxButtonState; ABorders: TcxBorders = []); virtual;
    procedure LayoutViewDrawItemScaled(ACanvas: TcxCanvas; const ABounds: TRect;
      AState: TcxButtonState; AScaleFactor: TdxScaleFactor; ABorders: TcxBorders = []); virtual;
    procedure LayoutViewDrawRecordCaption(ACanvas: TcxCanvas; const ABounds, ATextRect: TRect;
      APosition: TcxGroupBoxCaptionPosition; AState: TcxButtonState; AColor: TColor = clDefault;
      const ABitmap: TBitmap = nil); virtual;
    procedure LayoutViewDrawScaledRecordCaption(ACanvas: TcxCanvas; const ABounds, ATextRect: TRect;
      APosition: TcxGroupBoxCaptionPosition; AState: TcxButtonState; AScaleFactor: TdxScaleFactor;
      AColor: TColor = clDefault; const ABitmap: TBitmap = nil); virtual;

    procedure LayoutViewDrawRecordBorder(ACanvas: TcxCanvas; const ABounds: TRect;
      AState: TcxButtonState; ABorders: TcxBorders = []); virtual;
    procedure LayoutViewDrawRecordContent(ACanvas: TcxCanvas; const ABounds: TRect;
      ACaptionPosition: TcxGroupBoxCaptionPosition; AState: TcxButtonState; ABorders: TcxBorders = cxBordersAll); virtual;
    procedure LayoutViewDrawScaledRecordContent(ACanvas: TcxCanvas; const ABounds: TRect;
      ACaptionPosition: TcxGroupBoxCaptionPosition; AState: TcxButtonState;
      AScaleFactor: TdxScaleFactor; ABorders: TcxBorders = cxBordersAll); virtual;
    procedure LayoutViewDrawScaledRecordExpandButton(ACanvas: TcxCanvas;
      const ABounds: TRect; AState: TcxButtonState; AExpanded: Boolean; AScaleFactor: TdxScaleFactor); virtual;
    procedure LayoutViewDrawRecordExpandButton(ACanvas: TcxCanvas;
      const ABounds: TRect; AState: TcxButtonState; AExpanded: Boolean); 
    function LayoutViewGetPadding(AElement: TcxLayoutElement): TRect; virtual;
    function LayoutViewGetSpacing(AElement: TcxLayoutElement): TRect; virtual;
    function LayoutViewRecordCaptionTailSize(ACaptionPosition: TcxGroupBoxCaptionPosition): Integer; virtual; 
    function LayoutViewRecordCaptionScaledTailSize(ACaptionPosition: TcxGroupBoxCaptionPosition; AScaleFactor: TdxScaleFactor): Integer; virtual;
    function LayoutViewRecordCaptionTextBold: Boolean; virtual;

    //WinExplorer View
    function WinExplorerViewDefaultRecordColor(AState: TcxButtonState): TColor; virtual;
    procedure WinExplorerViewDrawGroup(ACanvas: TcxCanvas; const ABounds: TRect; AState: TcxButtonState;
      AColor: TColor = clDefault; const ABitmap: TBitmap = nil); virtual;
    procedure WinExplorerViewDrawGroupCaptionLine(ACanvas: TcxCanvas; const ABounds: TRect); virtual;
    procedure WinExplorerViewDrawRecord(ACanvas: TcxCanvas; const ABounds: TRect; AState: TcxButtonState;
      AColor: TColor = clDefault; const ABitmap: TBitmap = nil); virtual;
    procedure WinExplorerViewDrawRecordExpandButton(ACanvas: TcxCanvas; const ABounds: TRect; AState: TcxButtonState; AExpanded: Boolean); 
    procedure WinExplorerViewDrawScaledRecordExpandButton(ACanvas: TcxCustomCanvas;
      const ABounds: TRect; AState: TcxButtonState; AExpanded: Boolean; AScaleFactor: TdxScaleFactor); virtual;
    function WinExplorerViewExpandButtonSize: Integer; 
    function WinExplorerViewGroupCaptionLineHeight: Integer; virtual;
    function WinExplorerViewGroupTextBold: Boolean; virtual;
    function WinExplorerViewGroupTextColor(AState: TcxButtonState): TColor; virtual;
    function WinExplorerViewRecordTextColor(AState: TcxButtonState): TColor; virtual;
    function WinExplorerViewScaledExpandButtonSize(AScaleFactor: TdxScaleFactor): Integer; overload; virtual;

    // Chart View
    function ChartToolBoxDataLevelInfoBorderSize: Integer; virtual;

    //Data Row Layout
    function DefaultDataRowLayoutContentTextColor(AState: TcxButtonState): TColor; virtual;
    procedure DrawDataRowLayoutContent(ACanvas: TcxCanvas; const ABounds: TRect);
    procedure DrawDataRowLayoutItem(ACanvas: TcxCanvas; const ABounds: TRect; AState: TcxButtonState); virtual;
    procedure DrawDataRowLayoutItemScaled(ACanvas: TcxCanvas; const ABounds: TRect;
      AState: TcxButtonState; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawDataRowLayoutSelection(ACanvas: TcxCanvas; const ABounds: TRect; AState: TcxButtonState);
    procedure DrawDataRowLayoutSelectionScaled(ACanvas: TcxCanvas; const ABounds: TRect;
      AState: TcxButtonState; AScaleFactor: TdxScaleFactor);

    // Footer
    function FooterBorders: TcxBorders; virtual;
    function FooterBorderSize: Integer; virtual; // abstract;
    function FooterCellBorderSize: Integer; virtual; // deprecated, use FooterCellBorderSizeRect instead
    function FooterCellBordersSizeRect(const ABorders: TcxBorders; AScaleFactor, ABordersScaleFactor: TdxScaleFactor): TRect; virtual;
    function FooterCellContentBounds(const ABounds: TRect): TRect; overload; virtual; // deprecated
    function FooterCellContentBounds(const ABounds: TRect; const ABorders: TcxBorders; AScaleFactor, ABordersScaleFactor: TdxScaleFactor): TRect; overload; virtual;
    function FooterCellContentOffsets(const ABorders: TcxBorders; AIncludeBorders: Boolean;
      AScaleFactor, ABordersScaleFactor: TdxScaleFactor): TRect; virtual;
    function FooterCellTextAreaBounds(const ABounds: TRect): TRect; overload; virtual; // deprecated
    function FooterCellTextAreaBounds(const ABounds: TRect; const ABorders: TcxBorders; APaddingsScaleFactor, ABordersScaleFactor: TdxScaleFactor): TRect; overload; virtual;
    function FooterCellTextOffsets(ACellBorders: TcxBorders; APaddingsScaleFactor, ABordersScaleFactor: TdxScaleFactor): TRect; virtual;
    function FooterDrawCellsFirst: Boolean; virtual;
    function FooterPanelBordersSizeRect(const ABorders: TcxBorders; AScaleFactor, ABordersScaleFactor: TdxScaleFactor): TRect; virtual;
    function FooterPanelContentOffsets(const ABorders: TcxBorders; AIncludeBorders: Boolean;
      AScaleFactor, ABordersScaleFactor: TdxScaleFactor): TRect; virtual; // from borders
    function FooterSeparatorColor: TColor; virtual;
    function FooterSeparatorSize: Integer; virtual;

    procedure DrawFooterPanel(ACanvas: TcxCanvas; const ABounds: TRect; const AViewParams: TcxViewParams;
      ABorders: TcxBorders); overload; // deprecated
    procedure DrawFooterPanel(ACanvas: TcxCanvas; const ABounds: TRect; const AViewParams: TcxViewParams;
      const ABorders: TcxBorders; AScaleFactor: TdxScaleFactor; ABordersScaleFactor: TdxScaleFactor); overload;
    procedure DrawFooterCell(ACanvas: TcxCanvas; const ABounds: TRect; AAlignmentHorz: TAlignment;
      AAlignmentVert: TcxAlignmentVert; AMultiLine: Boolean; const AText: string; AFont: TFont;
      ATextColor, ABkColor: TColor; AOnDrawBackground: TcxDrawBackgroundEvent = nil); overload; virtual; // deprecated
    procedure DrawFooterCell(ACanvas: TcxCanvas; const ABounds: TRect; AAlignmentHorz: TAlignment;
      AAlignmentVert: TcxAlignmentVert; AMultiLine: Boolean; const AText: string; AFont: TFont;
      ATextColor, ABkColor: TColor; AOnDrawBackground: TcxDrawBackgroundEvent; const ABorders: TcxBorders;
      APaddingsScaleFactor, ABordersScaleFactor: TdxScaleFactor); overload; virtual;
    procedure DrawFooterCellContent(ACanvas: TcxCanvas; const ABounds: TRect; AAlignmentHorz: TAlignment;
      AAlignmentVert: TcxAlignmentVert; AMultiLine: Boolean; const AText: string; AFont: TFont;
      ATextColor, ABkColor: TColor; AOnDrawBackground: TcxDrawBackgroundEvent = nil); overload; virtual; // deprecated
    procedure DrawFooterCellContent(ACanvas: TcxCanvas; const ABounds: TRect; AAlignmentHorz: TAlignment;
      AAlignmentVert: TcxAlignmentVert; AMultiLine: Boolean; const AText: string; AFont: TFont;
      ATextColor, ABkColor: TColor; AOnDrawBackground: TcxDrawBackgroundEvent;
      const ABorders: TcxBorders; APaddingsScaleFactor, ABordersScaleFactor: TdxScaleFactor); overload; virtual;
    procedure DrawFooterBorder(ACanvas: TcxCanvas; const R: TRect); overload; virtual; // deprecated
    procedure DrawFooterBorder(ACanvas: TcxCanvas; const R: TRect;
      const ABorders: TcxBorders; AScaleFactor, ABordersScaleFactor: TdxScaleFactor); overload; virtual;
    procedure DrawFooterBorderEx(ACanvas: TcxCanvas; const R: TRect; ABorders: TcxBorders; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawFooterCellBorder(ACanvas: TcxCanvas; const R: TRect); overload; virtual; // deprecated
    procedure DrawFooterCellBorder(ACanvas: TcxCanvas; const R: TRect;
      const ABorders: TcxBorders; AScaleFactor: TdxScaleFactor); overload; virtual; // abstract;
    procedure DrawFooterContent(ACanvas: TcxCanvas; const ARect: TRect; const AViewParams: TcxViewParams); overload; virtual; // deprecated
    procedure DrawFooterContent(ACanvas: TcxCanvas; const ARect: TRect; const AViewParams: TcxViewParams;
      const ABorders: TcxBorders; AScaleFactor, ABordersScaleFactor: TdxScaleFactor); overload; virtual;

    procedure DrawFooterSeparator(ACanvas: TcxCanvas; const R: TRect); virtual;

    // Filter
    function GetFilterCustomizeButtonContentOffsets(AScaleFactor: TdxScaleFactor): TdxPadding; virtual;
    procedure DrawFilterActivateButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AChecked: Boolean); 
    procedure DrawFilterCloseButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState); 
    procedure DrawFilterCustomizeButton(ACanvas: TcxCanvas; const ABounds: TRect; const ACaption: string; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawFilterDropDownButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AIsFilterActive: Boolean); 
    procedure DrawFilterPanel(ACanvas: TcxCanvas; const ARect: TRect; ATransparent: Boolean; ABackgroundColor: TColor;
      const ABackgroundBitmap: TGraphic); overload; virtual; // deprecated
    procedure DrawFilterPanel(ACanvas: TcxCanvas; const ARect: TRect;
      ATransparent: Boolean; ABackgroundColor: TColor; const ABackgroundBitmap: TGraphic;
      const ABorders: TcxBorders; AScaleFactor, ABordersScaleFactor: TdxScaleFactor); overload; virtual;
    procedure DrawFilterSmartTag(ACanvas: TcxCanvas; R: TRect; AState: TcxFilterSmartTagState; AIsFilterActive: Boolean); 
    procedure DrawScaledFilterActivateButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AChecked: Boolean; AScaleFactor: TdxScaleFactor); overload; virtual;
    procedure DrawScaledFilterCloseButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawScaledFilterDropDownButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AIsFilterActive: Boolean; AScaleFactor: TdxScaleFactor); virtual; abstract;
    procedure DrawScaledFilterSmartTag(ACanvas: TcxCanvas; R: TRect; AState: TcxFilterSmartTagState; AIsFilterActive: Boolean; AScaleFactor: TdxScaleFactor); overload; virtual;
    function FilterActivateButtonSize: TPoint; 
    function FilterCloseButtonSize: TPoint; 
    function FilterControlMenuGetColorPalette: IdxColorPalette; virtual;
    function FilterDropDownButtonSize: TPoint; 
    function FilterSmartTagSize: TSize; 
    function ScaledFilterActivateButtonSize(AScaleFactor: TdxScaleFactor): TPoint; virtual;
    function ScaledFilterCloseButtonSize(AScaleFactor: TdxScaleFactor): TPoint; virtual;
    function ScaledFilterDropDownButtonSize(AScaleFactor: TdxScaleFactor): TPoint; virtual;
    function ScaledFilterSmartTagSize(AScaleFactor: TdxScaleFactor): TSize; virtual;
    // Filter Tokens
    procedure DrawScaledFilterBoolOperatorBackground(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawScaledFilterControlAddButtonGlyph(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawScaledFilterControlRemoveButtonGlyph(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawScaledFilterItemCaptionBackground(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawScaledFilterOperatorBackground(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawScaledFilterPanelBrackets(ACanvas: TcxCanvas; const R: TRect; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawScaledFilterPanelRemoveButtonGlyph(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawScaledFilterPanelRemovingArea(ACanvas: TcxCanvas; const R: TRect; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawScaledFilterValueBackground(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); virtual;
    procedure GetScaledFilterTokenParams(out AParams: TdxFilterTokenParams; AScaleFactor: TdxScaleFactor); virtual; //for internal use only

    // Find Panel
    procedure DrawFindPanel(ACanvas: TcxCanvas; const ARect: TRect;
      ATransparent: Boolean; ABackgroundColor: TColor; const ABackgroundBitmap: TGraphic); overload; virtual; // deprecated
    procedure DrawFindPanel(ACanvas: TcxCanvas; const ARect: TRect;
      ATransparent: Boolean; ABackgroundColor: TColor; const ABackgroundBitmap: TGraphic;
      const ABorders: TcxBorders; AScaleFactor, ABordersScaleFactor: TdxScaleFactor); overload; virtual;
    procedure DrawFindPanelBorder(ACanvas: TcxCanvas; const R: TRect; ABorders: TcxBorders; AScaleFactor: TdxScaleFactor); overload; virtual; //deprecated;
    procedure DrawFindPanelBorder(ACanvas: TcxCanvas; const R: TRect;
      const ABorders: TcxBorders; AScaleFactor, ABordersScaleFactor: TdxScaleFactor); overload; virtual;

    // Window Content
    function GetWindowContentTextColor: TColor; virtual;
    procedure DrawWindowContent(ACanvas: TcxCanvas; const ARect: TRect); virtual;

    // Popup
    procedure DrawEditPopupWindowBorder(ACanvas: TcxCanvas; var R: TRect;
      ABorderStyle: TcxEditPopupBorderStyle; AClientEdge: Boolean); virtual;
    function GetEditPopupWindowBorderWidth(AStyle: TcxEditPopupBorderStyle): Integer; virtual;
    function GetEditPopupWindowClientEdgeWidth(AStyle: TcxEditPopupBorderStyle): Integer; virtual;
    function PopupBorderStyle: TcxPopupBorderStyle; virtual;
    // Hints
      // Attributes
    function GetHintBorderColor: TColor; virtual;
      // Draw
    procedure DrawHintBackground(ACanvas: TcxCanvas; const ARect: TRect; AColor: TColor = clDefault); virtual;

    // ScreenTips
    function ScreenTipGetColorPalette: IdxColorPalette; virtual;
    function ScreenTipGetDescriptionTextColor: TColor; virtual;
    function ScreenTipGetFooterLineSize: Integer; virtual;
    function ScreenTipGetTitleTextColor: TColor; virtual;
    function ScreenTipGetWindowPadding: TRect; virtual;
    function ScreenTipGetHeaderPadding: TRect; virtual;
    function ScreenTipGetDescriptionPadding: TRect; virtual;
    function ScreenTipGetSeparatorPadding: TRect; virtual;
    function ScreenTipGetFooterPadding: TRect; virtual;
    procedure ScreenTipDrawBackground(ACanvas: TcxCanvas; ARect: TRect); virtual;
    procedure ScreenTipDrawFooterLine(ACanvas: TcxCanvas; const ARect: TRect); virtual;

    // Tabs
    procedure DrawTab(ACanvas: TcxCanvas; R: TRect; ABorders: TcxBorders;
      const AText: string; AState: TcxButtonState; AVertical: Boolean; AFont: TFont;
      ATextColor, ABkColor: TColor; AShowPrefix: Boolean = False); virtual;
    procedure DrawTabBorder(ACanvas: TcxCanvas; R: TRect; ABorder: TcxBorder; ABorders: TcxBorders; AVertical: Boolean); virtual; // abstract;
    procedure DrawTabsRoot(ACanvas: TcxCanvas; const R: TRect; ABorders: TcxBorders; AVertical: Boolean); virtual; // abstract;
    function IsDrawTabImplemented(AVertical: Boolean): Boolean; virtual;
    function IsTabHotTrack(AVertical: Boolean): Boolean; virtual;
    function TabBorderSize(AVertical: Boolean): Integer; virtual;

    // Indicator
    procedure DrawIndicatorCustomizationMark(ACanvas: TcxCanvas; const R: TRect; AColor: TColor); 
    procedure DrawIndicatorImage(ACanvas: TcxCanvas; const R: TRect; AKind: TcxIndicatorKind); 
    procedure DrawIndicatorItem(ACanvas: TcxCanvas; const R, AImageAreaBounds: TRect;
      AKind: TcxIndicatorKind; AColor: TColor; AOnDrawBackground: TcxDrawBackgroundEvent = nil); overload; 
    procedure DrawIndicatorItem(ACanvas: TcxCanvas; const R: TRect;
      AKind: TcxIndicatorKind; AColor: TColor; AOnDrawBackground: TcxDrawBackgroundEvent = nil); overload; 
    procedure DrawIndicatorItemEx(ACanvas: TcxCanvas; const R: TRect;
      AKind: TcxIndicatorKind; AColor: TColor; AOnDrawBackground: TcxDrawBackgroundEvent = nil); 
    procedure DrawScaledIndicatorImage(ACanvas: TcxCanvas; const R: TRect; AKind: TcxIndicatorKind; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawScaledIndicatorItem(ACanvas: TcxCanvas; const R, AImageAreaBounds: TRect;
      AKind: TcxIndicatorKind; AColor: TColor; AScaleFactor: TdxScaleFactor; AOnDrawBackground: TcxDrawBackgroundEvent;
      ANeighbors: TcxNeighbors; APaintLeftSide: Boolean; AIsRightToLeft: Boolean; ABorderWidth: Integer = 1); overload; virtual; // for internal use
    procedure DrawScaledIndicatorItem(ACanvas: TcxCanvas; const R, AImageAreaBounds: TRect;
      AKind: TcxIndicatorKind; AColor: TColor; AScaleFactor: TdxScaleFactor; AIsRIghtToLeft: Boolean; AOnDrawBackground: TcxDrawBackgroundEvent = nil;
      ANeighbors: TcxNeighbors = [nTop, nBottom]; ABorderWidth: Integer = 1); overload; virtual; // for internal use
    procedure DrawScaledIndicatorItem(ACanvas: TcxCanvas; const R: TRect; AKind: TcxIndicatorKind;
      AColor: TColor; AScaleFactor: TdxScaleFactor; AIsRIghtToLeft: Boolean; AOnDrawBackground: TcxDrawBackgroundEvent = nil; ABorderWidth: Integer = 1); overload; virtual; // for internal use
    procedure DrawScaledIndicatorItemEx(ACanvas: TcxCanvas; const R: TRect; AKind: TcxIndicatorKind; // for internal use
      AColor: TColor; AScaleFactor: TdxScaleFactor; AIsRightToLeft: Boolean; AOnDrawBackground: TcxDrawBackgroundEvent = nil); virtual;
    procedure DrawScaledIndicatorCustomizationMark(ACanvas: TcxCustomCanvas; const R: TRect; AColor: TColor; AScaleFactor: TdxScaleFactor); virtual;
    function IndicatorDrawItemsFirst: Boolean; virtual;

    // ScrollBars
    procedure DrawScrollBarBackground(ACanvas: TcxCustomCanvas; const R: TRect; AHorizontal: Boolean); 
    procedure DrawScrollBarPart(ACanvas: TcxCustomCanvas; AHorizontal: Boolean; R: TRect; APart: TcxScrollBarPart; AState: TcxButtonState); 
    procedure DrawScrollBarSplitter(ACanvas: TcxCustomCanvas; const R: TRect; AState: TcxButtonState); 
    procedure DrawScaledScrollBarBackground(ACanvas: TcxCustomCanvas; const R: TRect; AHorizontal: Boolean; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawScaledScrollBarPart(ACanvas: TcxCustomCanvas; AHorizontal: Boolean; R: TRect; APart: TcxScrollBarPart; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawScaledScrollBarSplitter(ACanvas: TcxCustomCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); virtual;
    function ScaledScrollBarMinimalThumbSize(AVertical: Boolean; AScaleFactor: TdxScaleFactor): Integer; virtual;
    function ScrollBarMinimalThumbSize(AVertical: Boolean): Integer; 

    // PopupPanel
    function PopupPanelSize: Integer; 
    function ScaledPopupPanelSize(AScaleFactor: TdxScaleFactor): Integer;
    procedure CalculatePopupPanelClientRect(var AClientRect, APanelRect, AGripRect, ACloseButtonRect: TRect;
      ACorner: TdxCorner; const ABorders, APanelBorders: TRect; APanelHeight: Integer = 0;
      AShowCloseButton: Boolean = True; AShowGripSize: Boolean = True); 
    procedure CalculateScaledPopupPanelClientRect(var AClientRect, APanelRect, AGripRect, ACloseButtonRect: TRect;
      ACorner: TdxCorner; const ABorders, APanelBorders: TRect; AScaleFactor: TdxScaleFactor;
      APanelHeight: Integer = 0; AShowCloseButton: Boolean = True; AShowGripSize: Boolean = True); virtual;
    procedure DrawPopupNCPanel(AHandle: HWND; AMouseAboveCloseButton, ACloseButtonIsTracking: Boolean;
      ACorner: TdxCorner; ACloseButtonRect, AGripRect: TRect; ABorderColor: TColor); 
    procedure DrawPopupPanelBand(ACanvas: TcxCanvas; const ABounds, AGripRect, ACloseButtonRect: TRect;
      AGripCorner: TdxCorner; ACloseButtonState: TcxButtonState; ABorders: TRect; ABorderColor: TColor;
      AShowGripSize: Boolean = True; AShowCloseButton: Boolean = True); 
    procedure DrawScaledPopupPanelBand(ACanvas: TcxCanvas; const ABounds, AGripRect, ACloseButtonRect: TRect;
      AGripCorner: TdxCorner; ACloseButtonState: TcxButtonState; ABorders: TRect; ABorderColor: TColor; AScaleFactor: TdxScaleFactor;
      AShowGripSize: Boolean = True; AShowCloseButton: Boolean = True);
    procedure DrawScaledPopupNCPanel(AHandle: HWND; AMouseAboveCloseButton, ACloseButtonIsTracking: Boolean;
      ACorner: TdxCorner; ACloseButtonRect, AGripRect: TRect; ABorderColor: TColor; AScaleFactor: TdxScaleFactor); virtual;

    // SizeGrip
    procedure DoDrawSizeGrip(ACanvas: TcxCanvas; const ARect: TRect); overload;
    procedure DoDrawSizeGrip(ACanvas: TcxCanvas; const ARect: TRect; AScaleFactor: TdxScaleFactor); overload; virtual;
    procedure DrawSizeGrip(ACanvas: TcxCanvas; const ARect: TRect;
      ABackgroundColor: TColor = clDefault; ACorner: TdxCorner = coBottomRight); virtual; 
    procedure DrawScaledSizeGrip(ACanvas: TcxCanvas; const ARect: TRect; AScaleFactor: TdxScaleFactor;
      ABackgroundColor: TColor = clDefault; ACorner: TdxCorner = coBottomRight); virtual;
    function ScaledSizeGripSize(AScaleFactor: TdxScaleFactor): TSize; virtual;
    function SizeGripSize: TSize; 

    // Slider
    function ScaledSliderButtonSize(ADirection: TcxArrowDirection; AScaleFactor: TdxScaleFactor): TSize; virtual;
    function SliderButtonSize(ADirection: TcxArrowDirection): TSize; 
    procedure DrawSliderButton(ACanvas: TcxCustomCanvas; const ARect: TRect;
      ADirection: TcxArrowDirection; AState: TcxButtonState); 
    procedure DrawScaledSliderButton(ACanvas: TcxCustomCanvas; const ARect: TRect;
      ADirection: TcxArrowDirection; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); virtual;

    // SmallButton / SmallCloseButton
    function DoGetSmallCloseButtonSize: TSize; virtual;
    procedure DrawSmallButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState); 
    procedure DrawSmallCloseButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState); 
    procedure DrawScaledSmallButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawScaledSmallCloseButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); virtual;
    function GetSmallButtonColorPalette(AState: TcxButtonState): IdxColorPalette; virtual;
    function SmallCloseButtonSize: TSize; 
    function ScaledSmallCloseButtonSize(AScaleFactor: TdxScaleFactor): TSize; virtual;

    // Scheduler
    procedure CalculateSchedulerNavigationButtonRects(AIsNextButton: Boolean; ACollapsed: Boolean;
      APrevButtonTextSize: TSize; ANextButtonTextSize: TSize; var ABounds: TRect; out ATextRect: TRect;
      out AArrowRect: TRect; AScaleFactor: TdxScaleFactor; const AIsVertical: Boolean = True); overload; virtual;
    procedure CalculateSchedulerNavigationButtonRects(AIsNextButton: Boolean; ACollapsed: Boolean;
      APrevButtonTextSize: TSize; ANextButtonTextSize: TSize; var ABounds: TRect; out ATextRect: TRect;
      out AArrowRect: TRect; const AIsVertical: Boolean = True); overload; virtual;
    procedure DrawScaledMonthHeader(ACanvas: TcxCanvas; const ABounds: TRect; const AText: string; ANeighbors: TcxNeighbors;
      const AViewParams: TcxViewParams; AArrows: TcxArrowDirections; ASideWidth: Integer; AScaleFactor: TdxScaleFactor;
      AOnDrawBackground: TcxDrawBackgroundEvent = nil); virtual;
    procedure DrawMonthHeader(ACanvas: TcxCanvas; const ABounds: TRect; const AText: string; ANeighbors: TcxNeighbors;
      const AViewParams: TcxViewParams; AArrows: TcxArrowDirections; ASideWidth: Integer;
      AOnDrawBackground: TcxDrawBackgroundEvent = nil); 
    procedure DrawSchedulerBorder(ACanvas: TcxCanvas; R: TRect); virtual;
    procedure DrawSchedulerDayHeader(ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect; ANeighbors: TcxNeighbors;
      ABorders: TcxBorders; AState: TcxButtonState; AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert;
      AMultiLine, AShowEndEllipsis: Boolean; const AText: string; AFont: TFont; ATextColor, ABkColor: TColor;
      AScaleFactor: TdxScaleFactor; AOnDrawBackground: TcxDrawBackgroundEvent = nil; AIsLast: Boolean = False; AIsGroup: Boolean = False); virtual;
    procedure DrawSchedulerEventProgress(ACanvas: TcxCanvas; const ABounds, AProgress: TRect; AViewParams: TcxViewParams; ATransparent: Boolean);
    procedure DrawSchedulerScaledEventProgress(ACanvas: TcxCanvas; const ABounds, AProgress: TRect;
      AViewParams: TcxViewParams; ATransparent: Boolean; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawSchedulerGroup(ACanvas: TcxCanvas; const R: TRect; AColor: TColor = clDefault); virtual;
    procedure DrawSchedulerScaledGroupSeparator(ACanvas: TcxCanvas; const ABounds: TRect;
      ABackgroundColor: TColor; AScaleFactor: TdxScaleFactor; AOnDrawBackground: TcxDrawBackgroundEvent = nil); virtual;
    procedure DrawSchedulerGroupSeparator(ACanvas: TcxCanvas; const ABounds: TRect;
      ABackgroundColor: TColor; AOnDrawBackground: TcxDrawBackgroundEvent = nil); 
    procedure DrawSchedulerMilestone(ACanvas: TcxCanvas; const R: TRect); virtual;
    procedure DrawSchedulerNavigationButton(ACanvas: TcxCanvas;
      const ARect: TRect; AIsNextButton: Boolean; AState: TcxButtonState;
      const AText: string; const ATextRect: TRect; const AArrowRect: TRect; const AIsVertical: Boolean = True); virtual;
    procedure DrawSchedulerNavigationButtonArrow(ACanvas: TcxCanvas;
      const ARect: TRect; AIsNextButton: Boolean; AColor: TColor; const AForVertical: Boolean); virtual;
    procedure DrawSchedulerScaledNavigatorButton(ACanvas: TcxCanvas; R: TRect;
      AState: TcxButtonState; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawSchedulerNavigatorButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState); 
    procedure DrawSchedulerSplitterBorder(ACanvas: TcxCanvas; R: TRect; const AViewParams: TcxViewParams; AIsHorizontal: Boolean); virtual;
    procedure DrawSchedulerTaskExpandButton(ACanvas: TcxCanvas; R: TRect; AExpanded: Boolean; AScaleFactor: TdxScaleFactor); virtual;
    function SchedulerEventProgressOffsets: TRect; virtual;
    function SchedulerHeaderBorders(ANeighbors: TcxNeighbors): TcxBorders; // for internal use
    function SchedulerNavigationButtonTextColor(AIsNextButton: Boolean;
      AState: TcxButtonState; ADefaultColor: TColor = clDefault): TColor; virtual;
    procedure SchedulerNavigationButtonSizes(AIsNextButton: Boolean; var ABorders: TRect; var AArrowSize: TSize;
      var AHasTextArea: Boolean; AScaleFactor: TdxScaleFactor; const AIsVertical: Boolean = True); overload; virtual;
    procedure SchedulerNavigationButtonSizes(AIsNextButton: Boolean; var ABorders: TRect; var AArrowSize: TSize;
      var AHasTextArea: Boolean; const AIsVertical: Boolean = True); overload; virtual;
    function SchedulerTaskExpandButtonSize(AScaleFactor: TdxScaleFactor): TSize; virtual;

    // Editors
    procedure DrawEditorButton(ACanvas: TcxCanvas; const ARect: TRect; AButtonKind: TcxEditBtnKind;
      AState: TcxButtonState; APosition: TcxEditBtnPosition = cxbpRight); 
    procedure DrawEditorButtonGlyph(ACanvas: TcxCanvas; const ARect: TRect;
      AButtonKind: TcxEditBtnKind; AState: TcxButtonState; APosition: TcxEditBtnPosition = cxbpRight); 
    procedure DrawFocusRect(ACanvas: TcxCanvas; const ARect: TRect; AScaleFactor: TdxScaleFactor = nil); // for internal use //#lcm: reserved for future using
    procedure DrawScaledEditorButton(ACanvas: TcxCanvas; const ARect: TRect; AButtonKind: TcxEditBtnKind;
      AState: TcxButtonState; AScaleFactor: TdxScaleFactor; APosition: TcxEditBtnPosition = cxbpRight); virtual;
    procedure DrawScaledEditorButtonGlyph(ACanvas: TcxCanvas; const ARect: TRect; AButtonKind: TcxEditBtnKind;
      AState: TcxButtonState; AScaleFactor: TdxScaleFactor; APosition: TcxEditBtnPosition = cxbpRight); virtual;
    function EditButtonColorPalette(AState: TcxButtonState): IdxColorPalette; virtual;
    function EditButtonSize: TSize; virtual;
    function EditButtonTextColor(AState: TcxButtonState = cxbsNormal): TColor; virtual;
    function EditButtonTextOffset: Integer; virtual;
    function GetContainerBorderColor(AIsHighlightBorder: Boolean): TColor; virtual;
    function GetContainerBorderWidth(ABorderStyle: TcxContainerBorderStyle): Integer; virtual;

    // Clock
    function ClockSize: TSize; 
    procedure DrawClock(ACanvas: TcxCanvas; const ARect: TRect; ADateTime: TDateTime; ABackgroundColor: TColor); 
    procedure DrawScaledClock(ACanvas: TcxCanvas; const ARect: TRect; ADateTime: TDateTime; ABackgroundColor: TColor; AScaleFactor: TdxScaleFactor); overload; virtual;
    function ScaledClockSize(AScaleFactor: TdxScaleFactor): TSize; virtual;

    // ZoomButtons
    procedure DrawScaledZoomInButton(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawScaledZoomOutButton(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawZoomInButton(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState); 
    procedure DrawZoomOutButton(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState); 
    function GetScaledZoomInButtonSize(AScaleFactor: TdxScaleFactor): TSize; virtual;
    function GetScaledZoomOutButtonSize(AScaleFactor: TdxScaleFactor): TSize; virtual;
    function GetZoomInButtonSize: TSize; 
    function GetZoomOutButtonSize: TSize; 

    // BackButton
    function GetBackButtonSize: TSize; 
    function GetScaledBackButtonSize(AScaleFactor: TdxScaleFactor): TSize; virtual;
    procedure DrawBackButton(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState);
    procedure DrawScaledBackButton(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); virtual;

    // DateNavigator
    procedure DrawDateNavigatorCellSelection(ACanvas: TcxCanvas; const R: TRect; AColor: TColor); virtual;
    procedure DrawDateNavigatorDateHeader(ACanvas: TcxCanvas; var R: TRect); virtual;
    procedure DrawDateNavigatorTodayCellSelection(ACanvas: TcxCanvas; const R: TRect); virtual;

    // Navigator
    procedure DrawNavigatorBorder(ACanvas: TcxCustomCanvas; R: TRect; ASelected: Boolean); virtual;
    procedure DrawNavigatorScaledButton(ACanvas: TcxCustomCanvas; R: TRect;
      AState: TcxButtonState; ABackgroundColor: TColor; AScaleFactor: TdxScaleFactor); overload; virtual;
    procedure DrawNavigatorButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; ABackgroundColor: TColor); 
    procedure DrawNavigatorButtonGlyph(ACanvas: TcxCanvas; AImageList: TCustomImageList; AImageIndex: TcxImageIndex;
      const AGlyphRect: TRect; AEnabled: Boolean; AUserGlyphs: Boolean); 
    procedure DrawNavigatorScaledButtonGlyph(ACanvas: TcxCanvas; AImageList: TCustomImageList; AImageIndex: TcxImageIndex;
      const AGlyphRect: TRect; AEnabled: Boolean; AUserGlyphs: Boolean; AScaleFactor: TdxScaleFactor); overload; virtual;
    procedure DrawNavigatorInfoPanel(ACanvas: TcxCanvas; const R: TRect; const AViewParams: TcxViewParams); virtual;
    function NavigatorBorderOverlap: Boolean; virtual;
    function NavigatorBorderSize: Integer; virtual;
    function NavigatorButtonColorPalette(AEnabled: Boolean): IdxColorPalette; virtual;
    function NavigatorButtonGlyphPadding: TRect; 
    function NavigatorButtonGlyphSize: TSize; 
    function NavigatorButtonMinSize: TSize; 
    function NavigatorButtonPressedGlyphOffset: TPoint; virtual;
    function NavigatorButtonTextColor(AState: TcxButtonState): TColor; virtual;
    function NavigatorScaledButtonGlyphPadding(AScaleFactor: TdxScaleFactor): TRect; overload; virtual;
    function NavigatorScaledButtonGlyphSize(AScaleFactor: TdxScaleFactor): TSize; overload; virtual;
    function NavigatorScaledButtonMinSize(AScaleFactor: TdxScaleFactor): TSize; overload; virtual;
    function NavigatorInfoPanelContentOffsets(AScaleFactor: TdxScaleFactor): TRect; virtual;
    function NavigatorInfoPanelTextColor: TColor; virtual;

    // ProgressBar
    procedure DrawProgressBarPart(ACanvas: TcxCanvas; const ABounds, ABarBounds: TRect;
      AVertical: Boolean; AScaleFactor: TdxScaleFactor; APart: TcxProgressBarPart); virtual;
    procedure DrawProgressBarText(ACanvas: TcxCanvas; const AText: string;
      const ABounds, AProgressRect, AOverloadBarRect, APeakBarRect: TRect;
      const ATextColor: TColor = clDefault; AVertical: Boolean = False);
    function ProgressBarBorderSize(AVertical: Boolean): TRect; virtual;
    function ProgressBarTextColor(APart: TcxProgressBarPart = pbpBackground): TColor; virtual;

    // GroupBox
    procedure DrawGroupBoxBackground(ACanvas: TcxCanvas; ABounds: TRect; ARect: TRect); virtual;
    procedure DrawGroupBoxCaption(ACanvas: TcxCanvas; const ACaptionRect, ATextRect: TRect;
      ACaptionPosition: TcxGroupBoxCaptionPosition); virtual;
    procedure DrawGroupBoxScaledCaption(ACanvas: TcxCanvas; const ACaptionRect, ATextRect: TRect;
      ACaptionPosition: TcxGroupBoxCaptionPosition; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawGroupBoxContent(ACanvas: TcxCanvas; ABorderRect: TRect;
      ACaptionPosition: TcxGroupBoxCaptionPosition; ABorders: TcxBorders = cxBordersAll); virtual;
    procedure DrawGroupBoxScaledContent(ACanvas: TcxCanvas; ABorderRect: TRect;
      ACaptionPosition: TcxGroupBoxCaptionPosition; AScaleFactor: TdxScaleFactor;
      ABorders: TcxBorders = cxBordersAll); virtual;
    procedure DrawGroupBoxScaledExpandButton(ACanvas: TcxCanvas; const R: TRect;
      AState: TcxButtonState; AExpanded: Boolean; AScaleFactor: TdxScaleFactor; ARotationAngle: TcxRotationAngle = ra0); overload; virtual;
    procedure DrawGroupBoxExpandButton(ACanvas: TcxCanvas; const R: TRect;
      AState: TcxButtonState; AExpanded: Boolean; ARotationAngle: TcxRotationAngle = ra0); 
    procedure DrawGroupBoxScaledButton(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); overload; virtual;
    procedure DrawGroupBoxButton(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState); 
    procedure DrawGroupBoxScaledExpandGlyph(ACanvas: TcxCanvas; const R: TRect;
      AState: TcxButtonState; AExpanded: Boolean; AScaleFactor: TdxScaleFactor); overload; virtual;
    procedure DrawGroupBoxExpandGlyph(ACanvas: TcxCanvas; const R: TRect;
      AState: TcxButtonState; AExpanded: Boolean); 
    procedure DrawGroupBoxScaledFrame(ACanvas: TcxCanvas; R: TRect; AEnabled: Boolean;
      ACaptionPosition: TcxGroupBoxCaptionPosition; AScaleFactor: TdxScaleFactor; ABorders: TcxBorders = cxBordersAll); overload; virtual;
    procedure DrawGroupBoxFrame(ACanvas: TcxCanvas; R: TRect; AEnabled: Boolean;
      ACaptionPosition: TcxGroupBoxCaptionPosition; ABorders: TcxBorders = cxBordersAll); overload; virtual;
    procedure GroupBoxAdjustCaptionFont(ACaptionFont: TFont; ACaptionPosition: TcxGroupBoxCaptionPosition); virtual;
    function GroupBoxBorderSize(ACaption: Boolean;
      ACaptionPosition: TcxGroupBoxCaptionPosition): TRect; virtual;
    function GroupBoxCaptionTailSize(ACaptionPosition: TcxGroupBoxCaptionPosition): Integer; virtual;
    function GroupBoxTextColor(AEnabled: Boolean; ACaptionPosition: TcxGroupBoxCaptionPosition): TColor; virtual;
    function IsGroupBoxCaptionTextDrawnOverBorder(ACaptionPosition: TcxGroupBoxCaptionPosition): Boolean; virtual;
    function IsGroupBoxTransparent(ACaptionPosition: TcxGroupBoxCaptionPosition): Boolean; virtual;

    // CheckBox
    function CheckBorderSize: Integer; virtual;
    function CheckButtonAreaSize: TSize; 
    function CheckButtonColor(AState: TcxButtonState; ACheckState: TcxCheckBoxState): TColor; virtual;
    function CheckButtonSize: TSize; 
    function ScaledCheckButtonAreaSize(AScaleFactor: TdxScaleFactor): TSize; virtual;
    function ScaledCheckButtonSize(AScaleFactor: TdxScaleFactor): TSize; overload; virtual;
    procedure DrawCheck(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AChecked: Boolean; AColor: TColor); overload; 
    procedure DrawCheck(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; ACheckState: TcxCheckBoxState; AColor: TColor); overload; 
    procedure DrawCheckBorder(ACanvas: TcxCustomCanvas; R: TRect; AState: TcxButtonState); virtual; // abstract;
    procedure DrawCheckButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AChecked: Boolean); overload; 
    procedure DrawCheckButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; ACheckState: TcxCheckBoxState); overload;
    procedure DrawScaledCheck(ACanvas: TcxCustomCanvas; const R: TRect; AState: TcxButtonState;
      AChecked: Boolean; AColor: TColor; AScaleFactor: TdxScaleFactor; ADrawBackground: Boolean); overload; virtual;
    procedure DrawScaledCheck(ACanvas: TcxCustomCanvas; const R: TRect; AState: TcxButtonState;
      ACheckState: TcxCheckBoxState; AColor: TColor; AScaleFactor: TdxScaleFactor; ADrawBackground: Boolean); overload; virtual;
    procedure DrawScaledCheck(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState;
      ACheckState: TcxCheckBoxState; AColor: TColor; AScaleFactor: TdxScaleFactor); overload;
    procedure DrawScaledCheck(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState;
      AChecked: Boolean; AColor: TColor; AScaleFactor: TdxScaleFactor); overload;
    procedure DrawScaledCheckButton(ACanvas: TcxCustomCanvas; R: TRect; AState: TcxButtonState;
      AChecked: Boolean; AScaleFactor: TdxScaleFactor; ADrawBackground: Boolean); overload; virtual;
    procedure DrawScaledCheckButton(ACanvas: TcxCustomCanvas; R: TRect; AState: TcxButtonState;
      ACheckState: TcxCheckBoxState; AScaleFactor: TdxScaleFactor; ADrawBackground: Boolean); overload; virtual;
    procedure DrawScaledCheckButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState;
      AChecked: Boolean; AScaleFactor: TdxScaleFactor); overload;
    procedure DrawScaledCheckButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState;
      ACheckState: TcxCheckBoxState; AScaleFactor: TdxScaleFactor); overload;

    // ToggleSwitch
    procedure DrawScaledToggleSwitch(ACanvas: TcxCanvas; ABounds: TRect; AState: TcxButtonState; AThumbBounds: TRect; AScaleFactor: TdxScaleFactor); overload; virtual; 
    procedure DrawScaledToggleSwitch(ACanvas: TcxCanvas; ABounds: TRect; AState: TcxButtonState; AFocused: Boolean; AThumbBounds: TRect; AScaleFactor: TdxScaleFactor); overload; virtual;
    procedure DrawScaledToggleSwitchState(ACanvas: TcxCanvas; ABounds: TRect; AState: TcxButtonState; AChecked: Boolean; AScaleFactor: TdxScaleFactor); overload; virtual; 
    procedure DrawScaledToggleSwitchState(ACanvas: TcxCanvas; ABounds: TRect; AState: TcxButtonState; AChecked, AFocused: Boolean; AScaleFactor: TdxScaleFactor); overload; virtual;
    procedure DrawScaledToggleSwitchThumb(ACanvas: TcxCanvas; ABounds: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); overload; virtual; 
    procedure DrawScaledToggleSwitchThumb(ACanvas: TcxCanvas; ABounds: TRect; AState: TcxButtonState; AChecked, AFocused: Boolean; AScaleFactor: TdxScaleFactor); overload; virtual;
    procedure DrawToggleSwitch(ACanvas: TcxCanvas; ABounds: TRect; AState: TcxButtonState; AThumbBounds: TRect); 
    procedure DrawToggleSwitchState(ACanvas: TcxCanvas; ABounds: TRect; AState: TcxButtonState; AChecked: Boolean); 
    procedure DrawToggleSwitchStateIndicator(ACanvas: TcxCanvas; ABounds: TRect; AText: string; AFont: TFont); virtual;
    procedure DrawToggleSwitchThumb(ACanvas: TcxCanvas; ABounds: TRect; AState: TcxButtonState); 
    function GetToggleSwitchColorPalette: IdxColorPalette; virtual;
    function GetToggleSwitchTextColor: TColor; virtual;
    function GetToggleSwitchThumbPercentsWidth: Integer; virtual;
    function ToggleSwitchToggleColor(AChecked: Boolean): TColor; virtual;

    // RadioButton
    procedure DrawRadioButton(ACanvas: TcxCanvas; X, Y: Integer; AButtonState: TcxButtonState;
      AChecked, AFocused: Boolean; ABrushColor: TColor;  AIsDesigning: Boolean = False); 
    procedure DrawScaledRadioButton(ACanvas: TcxCanvas; X, Y: Integer; AButtonState: TcxButtonState;
      AChecked, AFocused: Boolean; ABrushColor: TColor; AScaleFactor: TdxScaleFactor; AIsDesigning: Boolean = False); overload; virtual;
    function RadioButtonBodyColor(AState: TcxButtonState): TColor; virtual;
    function RadioButtonSize: TSize; 
    function ScaledRadioButtonSize(AScaleFactor: TdxScaleFactor): TSize; overload; virtual;

    // Label
    procedure DrawLabelLine(ACanvas: TcxCanvas; const R: TRect; AOuterColor, AInnerColor: TColor; AIsVertical: Boolean); virtual;
    function LabelLineHeight: Integer; virtual;

    // GaugeControl
    function GaugeControlBackgroundColor: TColor; virtual;
    procedure DrawGaugeControlBackground(ACanvas: TcxCanvas; const ARect: TRect;
      ATransparent: Boolean; ABackgroundColor: TColor); virtual;

    // MapControl
    function MapControlBackgroundColor: TColor; virtual;
    function MapControlPanelBackColor: TdxAlphaColor; virtual;
    function MapControlPanelHotTrackedTextColor: TdxAlphaColor; virtual;
    function MapControlPanelPressedTextColor: TdxAlphaColor; virtual;
    function MapControlPanelTextColor: TdxAlphaColor; virtual;
    function MapControlGetMapPushpinSize(AScaleFactor: TdxScaleFactor): TSize; virtual;
    function MapControlGetMapPushpinTextOrigin(AScaleFactor: TdxScaleFactor): TPoint; virtual;
    function MapControlMapCustomElementSelectionOffset(AScaleFactor: TdxScaleFactor): TRect; virtual;
    function MapControlMapCustomElementTextColor: TdxAlphaColor; virtual;
    function MapControlMapCustomElementTextGlowColor: TdxAlphaColor; virtual;
    function MapControlMapPushpinTextColor: TdxAlphaColor; virtual;
    function MapControlMapPushpinTextGlowColor: TdxAlphaColor; virtual;
    function MapControlSelectedRegionBackgroundColor: TdxAlphaColor; virtual;
    function MapControlSelectedRegionBorderColor: TdxAlphaColor; virtual;
    function MapControlShapeColor: TdxAlphaColor; virtual;
    function MapControlShapeBorderColor: TdxAlphaColor; virtual;
    function MapControlShapeBorderWidth(AScaleFactor: TdxScaleFactor): Integer; virtual;
    function MapControlShapeHighlightedColor: TdxAlphaColor; virtual;
    function MapControlShapeBorderHighlightedColor: TdxAlphaColor; virtual;
    function MapControlShapeBorderHighlightedWidth(AScaleFactor: TdxScaleFactor): Integer; virtual;
    function MapControlShapeSelectedColor: TdxAlphaColor; virtual;
    function MapControlShapeBorderSelectedColor: TdxAlphaColor; virtual;
    function MapControlShapeBorderSelectedWidth(AScaleFactor: TdxScaleFactor): Integer; virtual;
    procedure DrawMapCustomElementBackground(ACanvas: TcxCanvas; const ARect: TRect; AState: TdxMapControlElementState); virtual;
    procedure DrawMapPushpin(ACanvas: TcxCanvas; const ARect: TRect; AState: TdxMapControlElementState; AScaleFactor: TdxScaleFactor); virtual;

    // OfficeNavigationBar
      //draw
    procedure OfficeNavigationBarDrawCustomizationButton(ACanvas: TcxCanvas;
      const ARect: TRect; AState: TcxCalendarElementState; AColor: TdxAlphaColor = dxacDefault); 
    procedure OfficeNavigationBarDrawBackground(ACanvas: TcxCanvas; const ARect: TRect); virtual;
    procedure OfficeNavigationBarDrawImageSelection(ACanvas: TcxCanvas;
      const ARect: TRect; AState: TcxCalendarElementState); 
    procedure OfficeNavigationBarButtonItemDrawBackground(ACanvas: TcxCanvas;
      const ARect: TRect; AState: TcxCalendarElementState); 
    procedure OfficeNavigationBarItemDrawBackground(ACanvas: TcxCanvas;
      const ARect: TRect; AState: TcxCalendarElementState); 
    procedure OfficeNavigationBarDrawScaledButtonItemBackground(ACanvas: TcxCanvas;
      const ARect: TRect; AState: TcxCalendarElementState; AScaleFactor: TdxScaleFactor); virtual;
    procedure OfficeNavigationBarDrawScaledCustomizationButton(ACanvas: TcxCanvas;
      const ARect: TRect; AState: TcxCalendarElementState; AScaleFactor: TdxScaleFactor; AColor: TdxAlphaColor = dxacDefault); virtual;
    procedure OfficeNavigationBarDrawScaledItemBackground(ACanvas: TcxCanvas;
      const ARect: TRect; AState: TcxCalendarElementState; AScaleFactor: TdxScaleFactor); virtual;
    procedure OfficeNavigationBarDrawScaledImageSelection(ACanvas: TcxCanvas;
      const ARect: TRect; AState: TcxCalendarElementState; AScaleFactor: TdxScaleFactor); virtual;
      //sizes
    function OfficeNavigationBarButtonItemContentOffsets: TRect; 
    function OfficeNavigationBarButtonItemFontSize: Integer; 
    function OfficeNavigationBarButtonItemTextColor(AState: TcxCalendarElementState): TColor; virtual;
    function OfficeNavigationBarContentOffsets: TRect; 
    function OfficeNavigationBarCustomizationButtonSize: TSize; 
    function OfficeNavigationBarItemContentOffsets: TRect; 
    function OfficeNavigationBarItemFontSize: Integer; 
    function OfficeNavigationBarItemTextColor(AState: TcxCalendarElementState): TColor; virtual;
    function OfficeNavigationBarScaledButtonItemContentOffsets(AScaleFactor: TdxScaleFactor): TRect; virtual;
    function OfficeNavigationBarScaledButtonItemFontSize(AScaleFactor: TdxScaleFactor): Integer; virtual;
    function OfficeNavigationBarScaledContentOffsets(AScaleFactor: TdxScaleFactor): TRect; virtual;
    function OfficeNavigationBarScaledCustomizationButtonSize(AScaleFactor: TdxScaleFactor): TSize; virtual;
    function OfficeNavigationBarScaledItemContentOffsets(AScaleFactor: TdxScaleFactor): TRect; virtual;
    function OfficeNavigationBarScaledItemFontSize(AScaleFactor: TdxScaleFactor): Integer; virtual;

    // PDFViewer
    function PDFViewerNavigationPaneButtonColorPalette(AState: TcxButtonState): IdxColorPalette; virtual;
    function PDFViewerNavigationPaneButtonContentOffsets(AScaleFactor: TdxScaleFactor): TRect; virtual;
    function PDFViewerNavigationPaneButtonOverlay(AScaleFactor: TdxScaleFactor): TPoint; virtual;
    function PDFViewerNavigationPaneButtonRect(const ARect: TRect; AState: TcxButtonState; ASelected: Boolean;
      AScaleFactor: TdxScaleFactor): TRect;
    function PDFViewerNavigationPaneButtonSize(AScaleFactor: TdxScaleFactor): TSize; virtual;
    function PDFViewerNavigationPaneContentOffsets(AScaleFactor: TdxScaleFactor): TRect; virtual;
    function PDFViewerNavigationPanePageCaptionContentOffsets(AScaleFactor: TdxScaleFactor): TRect; virtual;
    function PDFViewerNavigationPanePageCaptionTextColor: TColor; virtual;
    function PDFViewerNavigationPanePageContentOffsets(AScaleFactor: TdxScaleFactor): TRect; virtual;
    function PDFViewerNavigationPanePageToolbarContentOffsets(AScaleFactor: TdxScaleFactor): TRect; virtual;
    function PDFViewerSelectionColor: TColor; virtual;
    procedure PDFViewerDrawNavigationPaneBackground(ACanvas: TcxCanvas; const ARect: TRect; AScaleFactor: TdxScaleFactor); virtual;
    procedure PDFViewerDrawNavigationPaneButton(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState;
      AScaleFactor: TdxScaleFactor; AMinimized, ASelected, AIsFirst: Boolean); virtual;
    procedure PDFViewerDrawNavigationPanePageBackground(ACanvas: TcxCanvas; const ARect: TRect); virtual;
    procedure PDFViewerDrawNavigationPanePageButton(ACanvas: TcxCanvas; const ARect: TRect;
      AState: TcxButtonState; AScaleFactor: TdxScaleFactor); virtual;
    procedure PDFViewerDrawNavigationPanePageCaptionBackground(ACanvas: TcxCanvas; const ARect: TRect); virtual;
    procedure PDFViewerDrawNavigationPanePageToolbarBackground(ACanvas: TcxCanvas; const ARect: TRect); virtual;
    procedure PDFViewerDrawFindPanelBackground(ACanvas: TcxCanvas; const R: TRect; ABorders: TcxBorders); virtual;
    procedure PDFViewerDrawPageThumbnailPreviewBackground(ACanvas: TcxCanvas; const ARect: TRect); virtual;

    // SpreadSheet
    procedure DrawSpreadSheetGroupExpandButton(ACanvas: TcxCanvas;
      const R: TRect; AState: TcxButtonState); 
    procedure DrawSpreadSheetGroupExpandButtonGlyph(ACanvas: TcxCanvas; const R: TRect;
      AState: TcxButtonState; AExpanded: Boolean; ADefaultGlyphs: TCustomImageList = nil); 
    procedure DrawSpreadSheetScaledHeader(ACanvas: TcxCustomCanvas; const R: TRect; ANeighbors: TcxNeighbors;
      ABorders: TcxBorders; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawSpreadSheetScaledGroupExpandButton(ACanvas: TcxCanvas;
      const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); overload; virtual;
    procedure DrawSpreadSheetScaledGroupExpandButtonGlyph(ACanvas: TcxCanvas; const R: TRect;
      AState: TcxButtonState; AExpanded: Boolean; AScaleFactor: TdxScaleFactor; ADefaultGlyphs: TCustomImageList = nil); overload; virtual;
    function SpreadSheetContentColor: TColor; virtual;
    function SpreadSheetContentTextColor: TColor; virtual;
    function SpreadSheetFrozenPaneSeparatorColor: TColor; virtual;
    function SpreadSheetGroupExpandButtonContentOffsets: TRect; 
    function SpreadSheetGroupExpandButtonGlyphSize: TSize; 
    function SpreadSheetGroupExpandButtonTextColor(AState: TcxButtonState): TColor; virtual;
    function SpreadSheetGroupLevelMarkSize: TSize; 
    function SpreadSheetGroupLineColor: TColor; virtual;
    function SpreadSheetScaledGroupExpandButtonContentOffsets(AScaleFactor: TdxScaleFactor): TRect; virtual;
    function SpreadSheetScaledGroupExpandButtonGlyphSize(AScaleFactor: TdxScaleFactor): TSize; overload; virtual;
    function SpreadSheetScaledGroupLevelMarkSize(AScaleFactor: TdxScaleFactor): TSize; overload; virtual;
    function SpreadSheetSelectionColor: TColor; virtual;

    // SpreadSheetFormulaBar
    procedure DrawSpreadSheetFormulaBarScaledExpandButton(ACanvas: TcxCanvas; const R: TRect;
      AState: TcxButtonState; AExpanded: Boolean; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawSpreadSheetFormulaBarScaledSeparator(ACanvas: TcxCanvas; const R: TRect; AScaleFactor: TdxScaleFactor); virtual;
    function SpreadSheetFormulaBarGetScaledSeparatorSize(AScaleFactor: TdxScaleFactor): Integer; virtual;

    // Panel
    procedure DrawPanelBackground(ACanvas: TcxCanvas; AControl: TWinControl; ABounds: TRect;
      AColorFrom: TColor = clDefault; AColorTo: TColor = clDefault); virtual;
    procedure DrawPanelBorders(ACanvas: TcxCanvas; const ABorderRect: TRect); virtual;
    procedure DrawPanelScaledBorders(ACanvas: TcxCanvas; const ABorderRect: TRect; AScaleFactor: TdxScaleFactor); virtual;

    procedure DrawPanelCaption(ACanvas: TcxCanvas; const ACaptionRect: TRect; ACaptionPosition: TcxGroupBoxCaptionPosition); virtual;
    procedure DrawPanelContent(ACanvas: TcxCustomCanvas; const ARect: TRect; AIsRightToLeft: Boolean = False); virtual;
    procedure DrawPanelContentEx(ACanvas: TcxCanvas; const ARect: TRect; AScaleFactor: TdxScaleFactor); virtual; // for internal use
    function PanelBorderSize: TRect; virtual;
    function PanelTextColor: TColor; virtual;

    // TrackBar
    procedure CorrectThumbRect(ACanvas: TcxCanvas; var ARect: TRect;
      AHorizontal: Boolean; ATicks: TcxTrackBarTicksAlign; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawTrackBarScaledTrack(ACanvas: TcxCanvas; const ARect, ASelection: TRect;
      AShowSelection, AEnabled, AHorizontal: Boolean; ATrackColor: TColor; AScaleFactor: TdxScaleFactor); overload; virtual;
    procedure DrawTrackBarTrack(ACanvas: TcxCanvas; const ARect, ASelection: TRect;
      AShowSelection, AEnabled, AHorizontal: Boolean; ATrackColor: TColor); 
    procedure DrawTrackBarTrackBounds(ACanvas: TcxCanvas; const ARect: TRect); virtual;
    procedure DrawTrackBarScaledThumb(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState;
      AHorizontal: Boolean; ATicks: TcxTrackBarTicksAlign; AThumbColor: TColor; AScaleFactor: TdxScaleFactor); overload; virtual;
    procedure DrawTrackBarThumb(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState;
      AHorizontal: Boolean; ATicks: TcxTrackBarTicksAlign; AThumbColor: TColor); 
    procedure DrawTrackBarThumbBorderUpDown(ACanvas: TcxCanvas;
      const ALightPolyLine, AShadowPolyLine, ADarkPolyLine: TPoints); virtual;
    procedure DrawTrackBarThumbBorderBoth(ACanvas: TcxCanvas; const ARect: TRect); virtual;
    function TrackBarScaledThumbSize(AHorizontal: Boolean; AScaleFactor: TdxScaleFactor): TSize; overload; virtual;
    function TrackBarScaledTrackSize(AScaleFactor: TdxScaleFactor): Integer; overload; virtual;
    function TrackBarThumbSize(AHorizontal: Boolean): TSize; 
    function TrackBarTicksColor(AText: Boolean): TColor; virtual;
    function TrackBarTrackSize: Integer; 

    // RangeControl
    procedure DrawRangeControlScaledLeftThumb(ACanvas: TcxCanvas; const ARect: TRect;
      AColor: TColor; ABorderColor: TdxAlphaColor; AScaleFactor: TdxScaleFactor); overload; virtual;
    procedure DrawRangeControlLeftThumb(ACanvas: TcxCanvas; const ARect: TRect;
      AColor: TColor; ABorderColor: TdxAlphaColor); 
    procedure DrawRangeControlScaledRightThumb(ACanvas: TcxCanvas; const ARect: TRect;
      AColor: TColor; ABorderColor: TdxAlphaColor; AScaleFactor: TdxScaleFactor); overload; virtual;
    procedure DrawRangeControlRightThumb(ACanvas: TcxCanvas; const ARect: TRect;
      AColor: TColor; ABorderColor: TdxAlphaColor); 
    procedure DrawRangeControlScaledRulerHeader(ACanvas: TcxCanvas; const ARect: TRect; AIsHot: Boolean;
      AColor: TdxAlphaColor; ABorderColor: TdxAlphaColor; AScaleFactor: TdxScaleFactor); overload; virtual;
    procedure DrawRangeControlRulerHeader(ACanvas: TcxCanvas; const ARect: TRect; AIsHot: Boolean;
      AColor: TdxAlphaColor; ABorderColor: TdxAlphaColor); 
    procedure DrawRangeControlScaledSizingGlyph(ACanvas: TcxCanvas; const ARect: TRect;
      ABorderColor: TdxAlphaColor; AScaleFactor: TdxScaleFactor); overload; virtual;
    procedure DrawRangeControlSizingGlyph(ACanvas: TcxCanvas; const ARect: TRect;
      ABorderColor: TdxAlphaColor); 

    function GetRangeControlBackColor: TColor; virtual;
    function GetRangeControlBorderColor: TColor; virtual;
    function GetRangeControlDefaultElementColor: TColor; virtual;
    function GetRangeControlElementForeColor: TColor; virtual;
    function GetRangeControlElementsBorderColor: TdxAlphaColor; virtual;
    function GetRangeControlLabelColor: TColor; virtual;
    function GetRangeControlOutOfRangeColor: TdxAlphaColor; virtual;
    function GetRangeControlRangePreviewColor: TColor; virtual;
    function GetRangeControlRulerColor: TdxAlphaColor; virtual;
    function GetRangeControlScaledScrollAreaHeight(AScaleFactor: TdxScaleFactor): Integer; virtual;
    function GetRangeControlScaledSizingGlyphSize(AScaleFactor: TdxScaleFactor): TSize; overload; virtual;
    function GetRangeControlScaledThumbSize(AScaleFactor: TdxScaleFactor): TSize; overload; virtual;
    function GetRangeControlScrollAreaColor: TColor; virtual;
    function GetRangeControlScrollAreaHeight: Integer; 
    function GetRangeControlSelectedRegionBackgroundColor: TdxAlphaColor; virtual;
    function GetRangeControlSelectedRegionBorderColor: TdxAlphaColor; virtual;
    function GetRangeControlSizingGlyphSize: TSize; 
    function GetRangeControlThumbSize: TSize; 
    function GetRangeControlViewPortPreviewColor: TColor; virtual;

    // RangeTrackBar
    function RangeTrackBarLeftThumbSize(AHorizontal: Boolean; ATicks: TcxTrackBarTicksAlign): TSize; 
    function RangeTrackBarRightThumbSize(AHorizontal: Boolean; ATicks: TcxTrackBarTicksAlign): TSize; 
    function RangeTrackBarScaledLeftThumbSize(AHorizontal: Boolean; ATicks: TcxTrackBarTicksAlign; AScaleFactor: TdxScaleFactor): TSize; virtual;
    function RangeTrackBarScaledRightThumbSize(AHorizontal: Boolean; ATicks: TcxTrackBarTicksAlign; AScaleFactor: TdxScaleFactor): TSize; virtual;
    procedure DrawRangeTrackBarScaledLeftThumb(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState;
      AHorizontal: Boolean; ATicks: TcxTrackBarTicksAlign; AThumbColor: TColor; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawRangeTrackBarLeftThumb(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState;
      AHorizontal: Boolean; ATicks: TcxTrackBarTicksAlign; AThumbColor: TColor); 
    procedure DrawRangeTrackBarScaledRightThumb(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState;
      AHorizontal: Boolean; ATicks: TcxTrackBarTicksAlign; AThumbColor: TColor; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawRangeTrackBarRightThumb(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState;
      AHorizontal: Boolean; ATicks: TcxTrackBarTicksAlign; AThumbColor: TColor); 

    // Splitter
    function GetSplitterInnerColor(AHighlighted: Boolean): TColor; virtual;
    function GetSplitterOuterColor(AHighlighted: Boolean): TColor; virtual;
    procedure DrawScaledSplitter(ACanvas: TcxCustomCanvas; const ARect: TRect; AHighlighted, AClicked, AHorizontal: Boolean;
      AScaleFactor: TdxScaleFactor; AHasCloseMark: Boolean = False; AArrowDirection: TcxArrowDirection = adLeft); virtual;
    procedure DrawSplitter(ACanvas: TcxCustomCanvas; const ARect: TRect; AHighlighted, AClicked, AHorizontal: Boolean); 
    procedure DrawSplitterCloseMark(ACanvas: TcxCustomCanvas; const ARect: TRect; AHighlighted, AClicked, AHorizontal: Boolean; AScaleFactor: TdxScaleFactor; AArrowDirection: TcxArrowDirection);
    function GetScaledSplitterSize(AHorizontal: Boolean; AScaleFactor: TdxScaleFactor): TSize; virtual;
    function GetSplitterSize(AHorizontal: Boolean): TSize; 
    function HasSplitterInnerLine(AHorizontal: Boolean; AScaleFactor: TdxScaleFactor): Boolean;

    // LayoutControl
    function LayoutControlEmptyAreaColor: TColor; virtual;
    function LayoutControlGetColorPaletteForGroupButton(AState: TcxButtonState): IdxColorPalette; virtual;
    function LayoutControlGetColorPaletteForItemCaption: IdxColorPalette; virtual;
    function LayoutControlGetColorPaletteForTabbedGroupCaption(AIsActive: Boolean): IdxColorPalette; virtual;
    procedure DrawLayoutControlBackground(ACanvas: TcxCanvas; const R: TRect); virtual;

    // ScrollBox
    procedure DrawScrollBoxBackground(ACanvas: TcxCanvas; const R: TRect; AColor: TColor); virtual;

    // Printing System
    function PrintPreviewBackgroundTextColor: TColor; virtual;
    function PrintPreviewPageBordersWidth: TRect; 
    function PrintPreviewPageBordersScaledWidth(AScaleFactor: TdxScaleFactor): TRect; virtual;
    procedure DrawPrintPreviewBackground(ACanvas: TcxCanvas; const R: TRect); 
    procedure DrawPrintPreviewScaledBackground(ACanvas: TcxCanvas; const R: TRect; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawPrintPreviewPageBackground(ACanvas: TcxCanvas;
      const ABorderRect, AContentRect: TRect; ASelected, ADrawContent: Boolean); 
    procedure DrawPrintPreviewPageScaledBackground(ACanvas: TcxCanvas;
      const ABorderRect, AContentRect: TRect; ASelected, ADrawContent: Boolean; AScaleFactor: TdxScaleFactor); virtual;

    // CalcEdit
    function CalcEditButtonTextColor(AButtonKind: TcxCalcButtonKind): TColor; virtual;

    // Customization Form
    function GetCustomizationFormListBackgroundColor: TColor; virtual;

    // Message Box
    procedure DrawMessageBox(ACanvas: TcxCanvas; const ABounds: TRect;
      const AMessage: string; AFont: TFont = nil; AColor: TColor = clNone); virtual;

    // BreadcrumbEdit
    function BreadcrumbEditBackgroundColor(AState: TdxBreadcrumbEditState): TColor; virtual;
    function BreadcrumbEditBordersSize: TRect; virtual;
    function BreadcrumbEditButtonAreaSeparatorSize: Integer; 
    function BreadcrumbEditButtonColorPalette(AState: TdxBreadcrumbEditButtonState): IdxColorPalette; virtual;
    function BreadcrumbEditButtonContentOffsets(AIsFirst, AIsLast: Boolean): TRect; 
    function BreadcrumbEditDropDownButtonWidth: Integer; 
    function BreadcrumbEditIsFadingSupports: Boolean; virtual;
    function BreadcrumbEditNodeDelimiterSize: Integer; 
    function BreadcrumbEditNodeTextColor(AState: TdxBreadcrumbEditButtonState): TColor; virtual;
    function BreadcrumbEditNodeTextOffsets: TRect; 
    function BreadcrumbEditProgressChunkOverlaySize: TSize; 
    function BreadcrumbEditProgressChunkPadding: TRect; 
    function BreadcrumbEditProgressChunkTextColor: TColor; virtual;
    function BreadcrumbEditScaledButtonAreaSeparatorSize(AScaleFactor: TdxScaleFactor): Integer; virtual;
    function BreadcrumbEditScaledButtonContentOffsets(AIsFirst, AIsLast: Boolean; AScaleFactor: TdxScaleFactor): TRect; virtual;
    function BreadcrumbEditScaledDropDownButtonWidth(AScaleFactor: TdxScaleFactor): Integer;  virtual;
    function BreadcrumbEditScaledNodeDelimiterSize(AScaleFactor: TdxScaleFactor): Integer; virtual;
    function BreadcrumbEditScaledNodeTextOffsets(AScaleFactor: TdxScaleFactor): TRect; virtual;
    function BreadcrumbEditScaledProgressChunkOverlaySize(AScaleFactor: TdxScaleFactor): TSize; virtual;
    function BreadcrumbEditScaledProgressChunkPadding(AScaleFactor: TdxScaleFactor): TRect; virtual;
    procedure DrawBreadcrumbEditBorders(ACanvas: TcxCanvas; const ARect: TRect; ABorders: TcxBorders; AState: TdxBreadcrumbEditState); virtual;
    procedure DrawBreadcrumbEditButton(ACanvas: TcxCanvas; const ARect: TRect; AState: TdxBreadcrumbEditButtonState; AIsFirst, AIsLast: Boolean); 
    procedure DrawBreadcrumbEditButtonAreaSeparator( ACanvas: TcxCanvas; const ARect: TRect; AState: TdxBreadcrumbEditState); 
    procedure DrawBreadcrumbEditDropDownButton(ACanvas: TcxCanvas; const ARect: TRect; AState: TdxBreadcrumbEditButtonState; AIsInEditor: Boolean); 
    procedure DrawBreadcrumbEditDropDownButtonGlyph(ACanvas: TcxCanvas; const ARect: TRect; AState: TdxBreadcrumbEditButtonState; AIsInEditor: Boolean); 
    procedure DrawBreadcrumbEditNode(ACanvas: TcxCanvas; const R: TRect; AState: TdxBreadcrumbEditButtonState; AHasDelimiter: Boolean); 
    procedure DrawBreadcrumbEditNodeDelimiter(ACanvas: TcxCanvas; const R: TRect; AState: TdxBreadcrumbEditButtonState); 
    procedure DrawBreadcrumbEditNodeDelimiterGlyph(ACanvas: TcxCanvas; const R: TRect; AState: TdxBreadcrumbEditButtonState); 
    procedure DrawBreadcrumbEditNodeMoreButtonGlyph(ACanvas: TcxCanvas; const R: TRect; AState: TdxBreadcrumbEditButtonState); 
    procedure DrawBreadcrumbEditProgressChunk(ACanvas: TcxCanvas; const R: TRect); 
    procedure DrawBreadcrumbEditProgressChunkOverlay(ACanvas: TcxCanvas; const R: TRect); 
    procedure DrawBreadcrumbEditScaledButton(ACanvas: TcxCanvas; const ARect: TRect;
      AState: TdxBreadcrumbEditButtonState; AIsFirst, AIsLast: Boolean; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawBreadcrumbEditScaledButtonAreaSeparator(ACanvas: TcxCanvas; const ARect: TRect;
      AState: TdxBreadcrumbEditState; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawBreadcrumbEditScaledDropDownButton(ACanvas: TcxCanvas; const ARect: TRect;
      AState: TdxBreadcrumbEditButtonState; AIsInEditor: Boolean; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawBreadcrumbEditScaledDropDownButtonGlyph(ACanvas: TcxCanvas; const ARect: TRect;
      AState: TdxBreadcrumbEditButtonState; AIsInEditor: Boolean; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawBreadcrumbEditScaledNode(ACanvas: TcxCanvas; const R: TRect;
      AState: TdxBreadcrumbEditButtonState; AHasDelimiter: Boolean; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawBreadcrumbEditScaledNodeDelimiter(ACanvas: TcxCanvas; const R: TRect;
      AState: TdxBreadcrumbEditButtonState; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawBreadcrumbEditScaledNodeDelimiterGlyph(ACanvas: TcxCanvas; const R: TRect;
      AState: TdxBreadcrumbEditButtonState; AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault); virtual;
    procedure DrawBreadcrumbEditScaledNodeMoreButtonGlyph(ACanvas: TcxCanvas; const R: TRect;
      AState: TdxBreadcrumbEditButtonState; AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault); virtual;
    procedure DrawBreadcrumbEditScaledProgressChunk(ACanvas: TcxCanvas; const R: TRect; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawBreadcrumbEditScaledProgressChunkOverlay(ACanvas: TcxCanvas; const R: TRect; AScaleFactor: TdxScaleFactor); virtual;

    // CustomMenu
    procedure DrawDropDownListBoxBackground(ACanvas: TcxCanvas; const ARect: TRect; AHasBorders: Boolean); virtual;
    procedure DrawDropDownListBoxGutterBackground(ACanvas: TcxCanvas; const ARect: TRect); 
    procedure DrawDropDownListBoxScaledGutterBackground(ACanvas: TcxCanvas; const ARect: TRect; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawDropDownListBoxScaledSelection(ACanvas: TcxCanvas; const ARect, AGutterRect: TRect; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawDropDownListBoxScaledSeparator(ACanvas: TcxCanvas; const ARect, AGutterRect: TRect; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawDropDownListBoxSelection(ACanvas: TcxCanvas; const ARect, AGutterRect: TRect); 
    procedure DrawDropDownListBoxSeparator(ACanvas: TcxCanvas; const ARect, AGutterRect: TRect); 
    function DropDownListBoxBordersSize: Integer; virtual;
    function DropDownListBoxItemImageOffsets: TRect; 
    function DropDownListBoxItemTextColor(ASelected: Boolean): TColor; virtual;
    function DropDownListBoxItemTextOffsets: TRect; 
    function DropDownListBoxScaledItemImageOffsets(AScaleFactor: TdxScaleFactor): TRect; virtual;
    function DropDownListBoxScaledItemTextOffsets(AScaleFactor: TdxScaleFactor): TRect; virtual;
    function DropDownListBoxScaledSeparatorSize(AScaleFactor: TdxScaleFactor): Integer; virtual;
    function DropDownListBoxSeparatorSize: Integer; 

    // AlertWindow
    function AlertWindowButtonContentOffsets(AKind: TdxAlertWindowButtonKind): TRect; 
    function AlertWindowButtonGetColorPalette(AState: TcxButtonState): IdxColorPalette; virtual;
    function AlertWindowButtonGlyphSize(AKind: TdxAlertWindowButtonKind): TSize; 
    function AlertWindowContentOffsets: TRect; 
    function AlertWindowCornerRadius: Integer; virtual;
    function AlertWindowNavigationPanelTextColor: TColor; virtual;
    function AlertWindowScaledButtonContentOffsets(AKind: TdxAlertWindowButtonKind; AScaleFactor: TdxScaleFactor): TRect; virtual;
    function AlertWindowScaledButtonGlyphSize(AKind: TdxAlertWindowButtonKind; AScaleFactor: TdxScaleFactor): TSize; virtual;
    function AlertWindowScaledContentOffsets(AScaleFactor: TdxScaleFactor): TRect; virtual;
    function AlertWindowTextColor: TColor; virtual;
    procedure DrawAlertWindowBackground(ACanvas: TcxCanvas; const ABounds: TRect; AScaleFactor: TdxScaleFactor = nil); virtual;
    procedure DrawAlertWindowScaledButton(ACanvas: TcxCanvas; const ABounds: TRect;
      AState: TcxButtonState; AKind: TdxAlertWindowButtonKind; AScaleFactor: TdxScaleFactor; ADown: Boolean = False); virtual;
    procedure DrawAlertWindowButton(ACanvas: TcxCanvas; const ABounds: TRect;
      AState: TcxButtonState; AKind: TdxAlertWindowButtonKind; ADown: Boolean = False); 
    procedure DrawAlertWindowNavigationPanel(ACanvas: TcxCanvas; const ABounds: TRect); virtual;

    // Gallery
    function GetGalleryGroupHeaderContentOffsets: TRect; 
    function GetGalleryGroupTextColor: TColor; virtual;
    function GetGalleryDropTargetSelectionColor: TColor; virtual;
    function GetGalleryItemCaptionTextColor(const AState: TdxGalleryItemViewState): TColor; virtual;
    function GetGalleryItemColorPalette(const AState: TdxGalleryItemViewState): IdxColorPalette; virtual;
    function GetGalleryItemDescriptionTextColor(const AState: TdxGalleryItemViewState): TColor; virtual;
    function GetGalleryItemImageFrameColor: TColor; virtual;
    function GetGalleryScaledGroupHeaderContentOffsets(AScaleFactor: TdxScaleFactor): TRect; virtual;
    procedure DrawGalleryBackground(ACanvas: TcxCustomCanvas; const ABounds: TRect); virtual;
    procedure DrawGalleryBackgroundScaled(ACanvas: TcxCustomCanvas; const ABounds: TRect; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawGalleryGroupHeader(ACanvas: TcxCustomCanvas; const ABounds: TRect); virtual;
    procedure DrawGalleryGroupHeaderScaled(ACanvas: TcxCustomCanvas; const ABounds: TRect; AScaleFactor: TdxScaleFactor); virtual;
    function DrawGalleryItemSelectionFirst: Boolean; virtual;
    procedure DrawGalleryItemSelection(ACanvas: TcxCustomCanvas; const R: TRect; AViewState: TdxGalleryItemViewState); virtual;
    procedure DrawGalleryItemSelectionScaled(ACanvas: TcxCustomCanvas; const R: TRect; AViewState: TdxGalleryItemViewState; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawGalleryItemImageFrame(ACanvas: TcxCustomCanvas; const R: TRect); virtual;
    procedure DrawGalleryItemImageFrameScaled(ACanvas: TcxCustomCanvas; const R: TRect; AScaleFactor: TdxScaleFactor); virtual;
    function GetRibbonColorGalleryContentOffsets(AScaleFactor: TdxScaleFactor): TdxPadding; virtual;
    function GetRibbonGalleryContentOffsets(AScaleFactor: TdxScaleFactor): TdxPadding; virtual;
    function GetRibbonGalleryItemCaptionContentOffsets(AScaleFactor: TdxScaleFactor): TdxPadding; virtual;
    function GetRibbonGalleryItemContentOffsets(AScaleFactor: TdxScaleFactor): TdxPadding; virtual;
    function GetRibbonGalleryItemFixedIndentBetweenCaptionAndDescription(AScaleFactor: TdxScaleFactor): Integer; virtual;
    function GetRibbonGalleryItemFixedIndentBetweenImageAndText(AScaleFactor: TdxScaleFactor): Integer; virtual;
    function GetRibbonGalleryItemImageContentOffsets(AScaleFactor: TdxScaleFactor): TdxPadding; virtual;
    function GetDropdownGalleryContentOffsets(AScaleFactor: TdxScaleFactor): TdxPadding; virtual;
    function GetDropdownGalleryFilterContentOffsets(AScaleFactor: TdxScaleFactor): TdxPadding; virtual;
    function GetDropDownGalleryItemCaptionContentOffsets(AScaleFactor: TdxScaleFactor): TdxPadding; virtual;
    function GetDropDownGalleryItemContentOffsets(AScaleFactor: TdxScaleFactor): TdxPadding; virtual;
    function GetDropDownGalleryItemDescriptionContentOffsets(AScaleFactor: TdxScaleFactor): TdxPadding; virtual;
    function GetDropDownGalleryItemFixedIndentBetweenCaptionAndDescription(AScaleFactor: TdxScaleFactor): Integer; virtual;
    function GetDropDownGalleryItemFixedIndentBetweenImageAndText(AScaleFactor: TdxScaleFactor): Integer; virtual;
    function GetDropDownGalleryItemImageContentOffsets(AScaleFactor: TdxScaleFactor): TdxPadding; virtual;

    // ColorGallery
    function GetColorGalleryGlyphFrameColor: TColor; virtual;
    procedure DrawColorGalleryItemSelection(ACanvas: TcxCustomCanvas; const R: TRect; AViewState: TdxGalleryItemViewState); virtual;

    // Bevel
    procedure DrawBevelFrame(ACanvas: TcxCanvas; const R: TRect; AColor1, AColor2: TColor; ABoxStyle: Boolean); virtual;
    procedure DrawBevelLine(ACanvas: TcxCanvas; const R: TRect; AColor1, AColor2: TColor; AIsVertical: Boolean); virtual;
    procedure DrawBevelShape(ACanvas: TcxCanvas; const R: TRect; AShape: TdxBevelShape; AStyle: TdxBevelStyle); virtual;
    function GetBevelMinimalShapeSize(AShape: TdxBevelShape): TSize; virtual;
    procedure GetBevelShapeColors(out AColor1, AColor2: TColor); virtual;

    // Calendar
    procedure DrawCalendarDateCellSelection(ACanvas: TcxCanvas; const ARect: TRect; AStates: TcxCalendarElementStates); virtual;
    // ModernCalendar
    procedure DrawModernCalendarArrow(ACanvas: TcxCanvas; const ARect: TRect; ADirection: TcxArrowDirection; AState: TcxCalendarElementState); virtual;
    procedure DrawModernCalendarClock(ACanvas: TcxCanvas; const ARect: TRect;
      ADateTime: TDateTime; ABackgroundColor: TColor; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawModernCalendarDateCellSelection(ACanvas: TcxCanvas; const ARect: TRect; AStates: TcxCalendarElementStates); virtual;
    procedure DrawModernCalendarDateHeaderSelection(ACanvas: TcxCanvas; const ARect: TRect; AStates: TcxCalendarElementStates); virtual;
    procedure DrawModernCalendarHeaderSelection(ACanvas: TcxCanvas; const ARect: TRect; AStates: TcxCalendarElementStates); virtual;
    function GetModernCalendarCellTextColor(AStates: TcxCalendarElementStates): TColor; virtual;
    function GetModernCalendarDateHeaderTextColor(AStates: TcxCalendarElementStates): TColor; virtual;
    function GetModernCalendarHeaderTextColor(AStates: TcxCalendarElementStates): TColor; virtual;
    function GetModernCalendarHeaderTextOffsets: TRect; virtual;
    function GetModernCalendarMarkedCellBorderColor: TColor; virtual;
    function GetModernCalendarSelectedTextColor: TColor; virtual;
    procedure DrawModernClockHands(ACanvas: TcxCanvas; const ARect: TRect; ADateTime: TDateTime; AColor: TColor); 
    procedure DrawScaledModernCalendarArrow(ACanvas: TcxCanvas; const ARect: TRect;
      ADirection: TcxArrowDirection; AState: TcxCalendarElementState; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawScaledModernClockHands(ACanvas: TcxCanvas; const ARect: TRect; ADateTime: TDateTime; AColor: TColor; AScaleFactor: TdxScaleFactor); virtual;

    // RatingControl
    procedure DrawRatingControlIndicator(ACanvas: TcxCanvas; const ABounds: TRect; AState: TdxRatingControlIndicatorState); 
    procedure DrawRatingControlScaledIndicator(ACanvas: TcxCanvas; const ABounds: TRect;
      AState: TdxRatingControlIndicatorState; AScaleFactor: TdxScaleFactor); virtual;
    function GetRatingControlIndicatorColorPalette(AState: TdxRatingControlIndicatorState): IdxColorPalette; virtual;
    function GetRatingControlIndicatorSize: TSize; 
    function GetRatingControlScaledIndicatorSize(AScaleFactor: TdxScaleFactor): TSize; virtual;

    //Fixed Group Indicator
    procedure DrawFixedGroupIndicator(ACanvas: TcxCanvas; const ABounds: TRect);
    procedure DrawScaledFixedGroupIndicator(ACanvas: TcxCanvas; const ABounds: TRect; AScaleFactor: TdxScaleFactor); virtual;
    function GetFixedGroupIndicatorSize: TSize;
    function GetScaledFixedGroupIndicatorSize(AScaleFactor: TdxScaleFactor): TSize; virtual;

    // WheelPicker
    function GetWheelPickerBorderItemColor(AState: TcxButtonState): TColor; virtual;
    function GetWheelPickerColorPalette(AState: TcxButtonState): IdxColorPalette; virtual;
    function GetWheelPickerFillItemColor(AState: TcxButtonState): TColor; virtual;
    procedure DrawWheelPickerItem(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState); virtual;
    procedure DrawWheelPickerItemBackground(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState); virtual;
    procedure DrawWheelPickerItemBorder(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState); virtual;

    // RichEditControl
    function RichEditControlHeaderFooterLineColor: TColor; virtual;
    function RichEditControlHeaderFooterMarkBackColor: TColor; virtual;
    function RichEditControlHeaderFooterMarkTextColor: TColor; virtual;

    function RichEditRulerControlColor: TColor; virtual;
    function RichEditRulerActiveAreaColor: TColor; virtual;
    function RichEditRulerDefaultTabColor: TColor; virtual;
    function RichEditRulerInactiveAreaColor: TColor; virtual;
    function RichEditRulerTabTypeToggleBorderColor: TColor; virtual;
    function RichEditRulerTextColor: TColor; virtual;

	  // TokenEdit
    procedure DrawScaledTokenBackground(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawScaledTokenCloseGlyph(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawTokenBackground(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState); 
    procedure DrawTokenCloseGlyph(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState); 
    function GetScaledTokenCloseGlyphSize(AScaleFactor: TdxScaleFactor): TSize; virtual;
    function GetScaledTokenContentOffsets(AIsInplace: Boolean; AScaleFactor: TdxScaleFactor): TRect; virtual;
    function GetScaledTokenDefaultGlyphSize(AScaleFactor: TdxScaleFactor): TSize; virtual;
    function GetTokenCloseGlyphSize: TSize; 
    function GetTokenColorPalette(AState: TcxButtonState): IdxColorPalette; virtual;
    function GetTokenContentOffsets: TRect; 
    function GetTokenDefaultGlyphSize: TSize; 
    function GetTokenTextColor(AState: TcxButtonState): TColor; virtual;

    // Gantt
    function DefaultGanttCurrentDateGridLineColor: TColor; virtual;
    function DefaultGanttProjectStartGridLineColor: TColor; virtual;
    function DefaultGanttProjectFinishGridLineColor: TColor; virtual;
    procedure DoDrawGanttSummaryTaskProgress(ACanvas: TcxCustomCanvas; const R: TRect; AScaleFactor: TdxScaleFactor; const AColor: TColor = clDefault); virtual;
    procedure DoDrawGanttTaskProgress(ACanvas: TcxCustomCanvas; const R: TRect; const AColor: TColor = clDefault); virtual;
    procedure DrawGanttBaselineMilestone(ACanvas: TcxCustomCanvas; const R: TRect; AScaleFactor: TdxScaleFactor; const AColor: TColor = clDefault); virtual;
    procedure DrawGanttBaselineSummaryTask(ACanvas: TcxCustomCanvas; const R: TRect; AScaleFactor: TdxScaleFactor; const AColor: TColor = clDefault); virtual;
    procedure DrawGanttBaselineTask(ACanvas: TcxCustomCanvas; const R: TRect; const AColor: TColor = clDefault); virtual;
    procedure DrawGanttDependencyEditPoint(ACanvas: TcxCustomCanvas; const R: TRect; const AState: TcxButtonState; const AIsLeft: Boolean); virtual;
    procedure DrawGanttFocusedRow(ACanvas: TcxCustomCanvas; const R: TRect; const AIsActive: Boolean = True); virtual;
    procedure DrawGanttSheetHeader(ACanvas: TcxCustomCanvas; const ABounds: TRect; AState: TcxButtonState;
      ANeighbors: TcxNeighbors; ABorders: TcxBorders; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawGanttMilestone(ACanvas: TcxCustomCanvas; const R: TRect; AScaleFactor: TdxScaleFactor; const AColor: TColor = clDefault); virtual;
    procedure DrawGanttSummaryTask(ACanvas: TcxCustomCanvas; const R: TRect; AScaleFactor: TdxScaleFactor; const AColor: TColor = clDefault); virtual;
    procedure DrawGanttSummaryTaskProgress(ACanvas: TcxCustomCanvas; const ATaskRect, AProgressRect: TRect; AScaleFactor: TdxScaleFactor; const AColor: TColor = clDefault);
    procedure DrawGanttTask(ACanvas: TcxCustomCanvas; const R: TRect; const AColor: TColor = clDefault); virtual;
    procedure DrawGanttTaskProgress(ACanvas: TcxCustomCanvas; const ATaskRect, AProgressRect: TRect; const AColor: TColor = clDefault);
    procedure DrawGanttTaskTextLabel(ACanvas: TcxCustomCanvas; const R: TRect); virtual;
    function GetGanttDependencyEditPointSize(const AIsLeft: Boolean): TSize; virtual;
    function GetGanttBaselineMilestoneSize: TSize; virtual;
    function GetGanttBaselineSummaryTaskHeight: Integer; virtual;
    function GetGanttBaselineTaskHeight: Integer; virtual;
    function GetGanttMilestoneColor: TColor; virtual;
    function GetGanttMilestoneSize: TSize; virtual;
    function GetGanttSummaryTaskHeight: Integer; virtual;
    function GetGanttSummaryTaskColor: TColor; virtual;
    function GetGanttTaskColor(AManualSchedule: Boolean): TColor; virtual;
    function GetGanttTaskHeight: Integer; virtual;
    function GetGanttTaskTextLabelHeight: Integer; virtual;
    function GetGanttTaskTextLabelOffset: Integer; virtual;
    function GetGanttTaskTextLabelTextBold: Boolean; virtual;
    function GetGanttTaskTextLabelTextColor: TColor; virtual;

    // ListView
    procedure DrawListViewBackground(ACanvas: TcxCustomCanvas; ABounds: TRect; AExplorerStyle, AEnabled: Boolean); virtual;
    procedure DrawListViewCheckButton(ACanvas: TcxCustomCanvas;
      const ABounds: TRect; AState: TcxButtonState; AChecked: Boolean; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawListViewSortingMark(ACanvas: TcxCustomCanvas; const R: TRect; AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawListViewGroupExpandButton(ACanvas: TcxCustomCanvas;
      const ABounds: TRect; AState: TcxButtonState; AExpanded: Boolean; AExplorerStyle: Boolean; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawListViewGroupHeaderBackground(ACanvas: TcxCustomCanvas;
      const ABounds: TRect; AState: TdxListViewGroupHeaderStates; AExplorerStyle: Boolean; AScaleFactor: TdxScaleFactor); virtual;
    procedure DrawListViewGroupHeaderLine(ACanvas: TcxCustomCanvas; const ABounds: TRect); virtual;
    procedure DrawListViewItemBackground(ACanvas: TcxCustomCanvas; const ABounds: TRect; AState: TdxListViewItemStates; AExplorerStyle: Boolean); virtual;
    function GetListViewColumnHeaderColorPalette(AState: TcxButtonState): IdxColorPalette; virtual;
    function GetListViewColumnHeaderSortingMarkSize(AScaleFactor: TdxScaleFactor): TPoint; virtual;
    function GetListViewColumnHeaderContentOffsets(AExplorerStyle: Boolean; AScaleFactor: TdxScaleFactor): TRect; virtual;
    function GetListViewColumnHeaderTextColor(AState: TcxButtonState; AExplorerStyle: Boolean): TColor; virtual;
    function GetListViewExpandButtonSize(AScaleFactor: TdxScaleFactor): Integer; overload; virtual;
    function GetListViewGroupHeaderColorPalette(AState: TdxListViewGroupHeaderStates): IdxColorPalette; virtual;
    function GetListViewGroupTextColor(AKind: TdxListViewGroupTextKind; AState: TdxListViewGroupHeaderStates; AExplorerStyle: Boolean): TColor; virtual;
    function GetListViewItemColorPalette(AState: TdxListViewItemStates): IdxColorPalette; virtual;
    function GetListViewItemContentPadding: TRect; virtual;
    function GetListViewItemTextColor(AState: TdxListViewItemStates; AExplorerStyle: Boolean): TColor; virtual;

    // TreeView
    procedure DrawTreeViewNodeBackground(ACanvas: TcxCustomCanvas; const ABounds: TRect; AState: TdxTreeViewNodeStates); virtual;
    function GetTreeViewBackgroundColor(AEnabled: Boolean): TColor; virtual;
    function GetTreeViewNodeColorPalette(AState: TdxTreeViewNodeStates): IdxColorPalette; virtual;
    function GetTreeViewNodeTextColor(AState: TdxTreeViewNodeStates): TColor; virtual;

    //TreeList
    function TreeListScaleGridLines: Boolean; virtual; // for internal use
    function TreeListUseDiscreteScalingForGridLines: Boolean; virtual; // for internal use

    // Properties
    function ApplyEditorAdvancedMode: Boolean; virtual;
    function SupportsNativeFocusRect(APaintPartID: TdxPaintPartID = TdxPaintPartID.Unknown): Boolean; virtual;
  end;

  TcxCustomLookAndFeelPainterClass = class of TcxCustomLookAndFeelPainter;

  { TcxStandardLookAndFeelPainter }

  TcxStandardLookAndFeelPainter = class(TcxCustomLookAndFeelPainter) //for internal use
  protected
    procedure DoDrawScaledScrollBarPart(ACanvas: TcxCustomCanvas; AHorizontal: Boolean; R: TRect;
      APart: TcxScrollBarPart; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); override;
    // footer
    function FooterContentOffset: Integer; override;
  public
    function LookAndFeelName: string; override;
    function LookAndFeelStyle: TcxLookAndFeelStyle; override;
    // border
    function BorderSize: Integer; override;
    procedure DrawBorder(ACanvas: TcxCustomCanvas; R: TRect; AWidth: Integer = 1); override;
    // buttons
    function ButtonBorderSize(AState: TcxButtonState = cxbsNormal): Integer; override;
   function ScaledButtonTextOffset(AScaleFactor: TdxScaleFactor): Integer; override;
    function ScaledButtonTextShift(AScaleFactor: TdxScaleFactor): Integer; override;
    procedure DrawButtonBorder(ACanvas: TcxCustomCanvas; R: TRect; AState: TcxButtonState); override;
    procedure DrawScaledGroupExpandButton(ACanvas: TcxCustomCanvas; const R: TRect;
      AExpanded: Boolean; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); override;
    function ScaledExpandButtonSize(AScaleFactor: TdxScaleFactor): Integer; override;
    procedure DrawScaledExpandButton(ACanvas: TcxCustomCanvas; const R: TRect; AExpanded: Boolean;
      AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault; AState: TcxExpandButtonState = cebsNormal); override;
    function IsButtonHotTrack: Boolean; override;
    // checkbox
    procedure DrawCheckBorder(ACanvas: TcxCustomCanvas; R: TRect; AState: TcxButtonState); override;
    // colors
    function DefaultSchedulerTimeRulerBorderColor: TColor; override;
    function DefaultSchedulerTimeRulerTextColor: TColor; override;
    // header
    procedure DrawHeaderControlSectionBorder(ACanvas: TcxCanvas; const R: TRect; ABorders: TcxBorders; AState: TcxButtonState); override;
    procedure DrawScaledSortingMark(ACanvas: TcxCanvas; const R: TRect; AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor); override;
    procedure DrawScaledSummarySortingMark(ACanvas: TcxCanvas; const R: TRect; AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor); override;
    function HeaderBorderSize: Integer; override;
    function HeaderControlSectionBorderSize(AState: TcxButtonState = cxbsNormal): Integer; override;
    function ScaledSortingMarkSize(AScaleFactor: TdxScaleFactor): TPoint; override;
    function ScaledSummarySortingMarkSize(AScaleFactor: TdxScaleFactor): TPoint; override;
    // footer
    function FooterBorderSize: Integer; override;
    function FooterCellBorderSize: Integer; override;
    function FooterCellOffset: Integer; override;
    procedure DrawFooterBorder(ACanvas: TcxCanvas; const R: TRect;
      const ABorders: TcxBorders; AScaleFactor, ABordersScaleFactor: TdxScaleFactor); override;
    procedure DrawFooterCellBorder(ACanvas: TcxCanvas; const R: TRect; const ABorders: TcxBorders; AScaleFactor: TdxScaleFactor); override;
    // filter
    procedure DrawScaledFilterDropDownButton(ACanvas: TcxCanvas; R: TRect;
      AState: TcxButtonState; AIsFilterActive: Boolean; AScaleFactor: TdxScaleFactor); override;
    // tabs
    procedure DrawTabBorder(ACanvas: TcxCanvas; R: TRect; ABorder: TcxBorder; ABorders: TcxBorders; AVertical: Boolean); override;
    procedure DrawTabsRoot(ACanvas: TcxCanvas; const R: TRect; ABorders: TcxBorders; AVertical: Boolean); override;
    function TabBorderSize(AVertical: Boolean): Integer; override;
    // ms outlook
    function DefaultSchedulerViewContentColor: TColor; override;
    function DefaultSchedulerViewContentColorClassic: TColor; override;
    procedure DrawScaledMonthHeader(ACanvas: TcxCanvas; const ABounds: TRect; const AText: string; ANeighbors: TcxNeighbors;
      const AViewParams: TcxViewParams; AArrows: TcxArrowDirections; ASideWidth: Integer; AScaleFactor: TdxScaleFactor;
      AOnDrawBackground: TcxDrawBackgroundEvent = nil); override;
    procedure DrawSchedulerSplitterBorder(ACanvas: TcxCanvas; R: TRect; const AViewParams: TcxViewParams; AIsHorizontal: Boolean); override;
    // GroupBox
    procedure DrawGroupBoxScaledFrame(ACanvas: TcxCanvas; R: TRect; AEnabled: Boolean;
      ACaptionPosition: TcxGroupBoxCaptionPosition; AScaleFactor: TdxScaleFactor; ABorders: TcxBorders = cxBordersAll); override;
    // TrackBar
    procedure DrawTrackBarTrackBounds(ACanvas: TcxCanvas; const ARect: TRect); override;
    procedure DrawTrackBarThumbBorderUpDown(ACanvas: TcxCanvas;
      const ALightPolyLine, AShadowPolyLine, ADarkPolyLine: TPoints); override;
    procedure DrawTrackBarThumbBorderBoth(ACanvas: TcxCanvas; const ARect: TRect); override;
    // BreadcrumbEdit
    procedure DrawBreadcrumbEditScaledButton(ACanvas: TcxCanvas; const ARect: TRect;
      AState: TdxBreadcrumbEditButtonState; AIsFirst, AIsLast: Boolean; AScaleFactor: TdxScaleFactor); override;
    // ToggleSwitch
    procedure DrawScaledToggleSwitchState(ACanvas: TcxCanvas; ABounds: TRect;
      AState: TcxButtonState; AChecked, AFocused: Boolean; AScaleFactor: TdxScaleFactor); override;
    function ToggleSwitchToggleColor(AChecked: Boolean): TColor; override;
    // Find Panel
    procedure DrawFindPanelBorder(ACanvas: TcxCanvas; const R: TRect;
      const ABorders: TcxBorders; AScaleFactor, ABordersScaleFactor: TdxScaleFactor); override;
    // TokenEdit
    procedure DrawScaledTokenBackground(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); override;
  end;

  { TcxFlatLookAndFeelPainter }

  TcxFlatLookAndFeelPainter = class(TcxCustomLookAndFeelPainter) //for internal use
  protected
    procedure DoDrawScaledScrollBarPart(ACanvas: TcxCustomCanvas; AHorizontal: Boolean;
      R: TRect; APart: TcxScrollBarPart; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); override;
    // footer
    function FooterContentOffset: Integer; override;
  public
    function LookAndFeelName: string; override;
    function LookAndFeelStyle: TcxLookAndFeelStyle; override;
    // border
    function BorderSize: Integer; override;
    function SeparatorSize: Integer; override;
    procedure DrawBorder(ACanvas: TcxCustomCanvas; R: TRect; AWidth: Integer = 1); override;
    // buttons
    function ButtonBorderSize(AState: TcxButtonState = cxbsNormal): Integer; override;
    function ScaledButtonTextOffset(AScaleFactor: TdxScaleFactor): Integer; override;
    function ScaledButtonTextShift(AScaleFactor: TdxScaleFactor): Integer; override;
    procedure DrawButtonBorder(ACanvas: TcxCustomCanvas; R: TRect; AState: TcxButtonState); override;
    procedure DrawScaledExpandButton(ACanvas: TcxCustomCanvas; const R: TRect; AExpanded: Boolean;
      AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault; AState: TcxExpandButtonState = cebsNormal); override;
    function ScaledExpandButtonSize(AScaleFactor: TdxScaleFactor): Integer; override;
    function IsButtonHotTrack: Boolean; override;
    // checkbox
    procedure DrawCheckBorder(ACanvas: TcxCustomCanvas; R: TRect; AState: TcxButtonState); override;
    // colors
    function DefaultSchedulerTimeRulerBorderColor: TColor; override;
    function DefaultSchedulerTimeRulerTextColor: TColor; override;
    // header
    procedure DrawHeaderControlSectionBorder(ACanvas: TcxCanvas; const R: TRect; ABorders: TcxBorders; AState: TcxButtonState); override;
    procedure DrawScaledSortingMark(ACanvas: TcxCanvas; const R: TRect; AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor); override;
    procedure DrawScaledSummarySortingMark(ACanvas: TcxCanvas; const R: TRect; AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor); override;
    function HeaderBorderSize: Integer; override;
    function ScaledSortingMarkSize(AScaleFactor: TdxScaleFactor): TPoint; override;
    function ScaledSummarySortingMarkSize(AScaleFactor: TdxScaleFactor): TPoint; override;
    // footer
    function FooterBorderSize: Integer; override;
    function FooterCellBorderSize: Integer; override;
    function FooterCellOffset: Integer; override;
    procedure DrawFooterBorder(ACanvas: TcxCanvas; const R: TRect;
      const ABorders: TcxBorders; AScaleFactor, ABordersScaleFactor: TdxScaleFactor); override;
    procedure DrawFooterCellBorder(ACanvas: TcxCanvas; const R: TRect; const ABorders: TcxBorders; AScaleFactor: TdxScaleFactor); override;
    // filter
    procedure DrawScaledFilterDropDownButton(ACanvas: TcxCanvas; R: TRect;
      AState: TcxButtonState; AIsFilterActive: Boolean; AScaleFactor: TdxScaleFactor); override;
    // tabs
    procedure DrawTabBorder(ACanvas: TcxCanvas; R: TRect; ABorder: TcxBorder; ABorders: TcxBorders; AVertical: Boolean); override;
    procedure DrawTabsRoot(ACanvas: TcxCanvas; const R: TRect; ABorders: TcxBorders; AVertical: Boolean); override;
    function TabBorderSize(AVertical: Boolean): Integer; override;
    // ms outlook
    procedure DrawSchedulerSplitterBorder(ACanvas: TcxCanvas; R: TRect; const AViewParams: TcxViewParams; AIsHorizontal: Boolean); override;
    // GroupBox
    procedure DrawGroupBoxScaledFrame(ACanvas: TcxCanvas; R: TRect; AEnabled: Boolean;
      ACaptionPosition: TcxGroupBoxCaptionPosition; AScaleFactor: TdxScaleFactor; ABorders: TcxBorders = cxBordersAll); override;
    // TrackBar
    procedure DrawTrackBarTrackBounds(ACanvas: TcxCanvas; const ARect: TRect); override;
    procedure DrawTrackBarThumbBorderUpDown(ACanvas: TcxCanvas;
      const ALightPolyLine, AShadowPolyLine, ADarkPolyLine: TPoints); override;
    procedure DrawTrackBarThumbBorderBoth(ACanvas: TcxCanvas; const ARect: TRect); override;
    // DateNavigator
    procedure DrawDateNavigatorDateHeader(ACanvas: TcxCanvas; var R: TRect); override;
    // Splitter
    function GetSplitterOuterColor(AHighlighted: Boolean): TColor; override;
    // ToggleSwitch
    procedure DrawScaledToggleSwitchState(ACanvas: TcxCanvas; ABounds: TRect;
      AState: TcxButtonState; AChecked, AFocused: Boolean; AScaleFactor: TdxScaleFactor); override;
    function ToggleSwitchToggleColor(AChecked: Boolean): TColor; override;
    // Find Panel
    procedure DrawFindPanelBorder(ACanvas: TcxCanvas; const R: TRect;
      const ABorders: TcxBorders; AScaleFactor, ABordersScaleFactor: TdxScaleFactor); override;
  end;

  { TcxUltraFlatLookAndFeelPainter }

  TcxUltraFlatLookAndFeelPainter = class(TcxCustomLookAndFeelPainter) //for internal use
  protected
    // footer
    function FooterContentOffset: Integer; override;
    // scrollbar
    procedure DoDrawScaledScrollBarPart(ACanvas: TcxCustomCanvas; AHorizontal: Boolean;
      R: TRect; APart: TcxScrollBarPart; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); override;
    // filter
    function FilterDropDownButtonBorderColor(AState: TcxButtonState): TColor; virtual;
    // Scheduler
    procedure DrawSchedulerNavigationButtonContent(ACanvas: TcxCanvas;
      const ARect: TRect; const AArrowRect: TRect; AIsNextButton: Boolean;
      AState: TcxButtonState; const AIsVertical: Boolean = True); override;
    // BreadcrumbEdit
    procedure DrawBreadcrumbEditCustomButton(ACanvas: TcxCanvas; const R: TRect;
      AState: TdxBreadcrumbEditButtonState; ABorders: TcxBorders); virtual;
    // tabs
    function TabBorderHighlightColor: TColor; virtual;
    function TabBorderDarkColor: TColor; virtual;
  public
    function LookAndFeelName: string; override;
    function LookAndFeelStyle: TcxLookAndFeelStyle; override;
    // default
    function DefaultSchedulerBorderColor: TColor; override;
    // border
    function BorderHighlightColor: TColor; virtual;
    function BorderSize: Integer; override;
    procedure DrawBorder(ACanvas: TcxCustomCanvas; R: TRect; AWidth: Integer = 1); override;
    procedure DoDrawSeparator(ACanvas: TcxCustomCanvas; R: TRect; AIsVertical: Boolean); override;
    // buttons
    function ButtonBorderSize(AState: TcxButtonState = cxbsNormal): Integer; override;
    function ButtonColor(AState: TcxButtonState): TColor; override;
    function ScaledButtonFocusRect(ACanvas: TcxCanvas; R: TRect; AScaleFactor: TdxScaleFactor): TRect; override;
    function ButtonSymbolColor(AState: TcxButtonState; ADefaultColor: TColor = clDefault; APart: TcxButtonPart = cxbpButton): TColor; override;
    function ButtonSymbolState(AState: TcxButtonState): TcxButtonState; override;
    function ScaledButtonTextOffset(AScaleFactor: TdxScaleFactor): Integer; override;
    function ScaledButtonTextShift(AScaleFactor: TdxScaleFactor): Integer; override;
    procedure DrawButtonBorder(ACanvas: TcxCustomCanvas; R: TRect; AState: TcxButtonState); override;
    procedure DrawScaledExpandButton(ACanvas: TcxCustomCanvas; const R: TRect; AExpanded: Boolean;
      AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault; AState: TcxExpandButtonState = cebsNormal); override;
    procedure DrawHeaderControlSectionBorder(ACanvas: TcxCanvas; const R: TRect;
      ABorders: TcxBorders; AState: TcxButtonState); override;
    procedure DrawHeaderControlSectionContent(ACanvas: TcxCanvas; const ABounds,
      ATextAreaBounds: TRect; AState: TcxButtonState; AAlignmentHorz: TAlignment;
      AAlignmentVert: TcxAlignmentVert; AMultiLine, AShowEndEllipsis: Boolean;
      const AText: string; AFont: TFont; ATextColor, ABkColor: TColor); override;
    function ScaledExpandButtonSize(AScaleFactor: TdxScaleFactor): Integer; override;
    function IsButtonHotTrack: Boolean; override;
    // checkbox
    procedure DrawCheckBorder(ACanvas: TcxCustomCanvas; R: TRect; AState: TcxButtonState); override;
    // colors
    function DefaultFixedSeparatorColor: TColor; override;
    function DefaultSchedulerTimeRulerBorderColor: TColor; override;
    function DefaultSchedulerTimeRulerTextColor: TColor; override;
    // RadioButton
    function RadioButtonBodyColor(AState: TcxButtonState): TColor; override;
    // header
    procedure DrawHeaderBorder(ACanvas: TcxCustomCanvas; const R: TRect; ANeighbors: TcxNeighbors; ABorders: TcxBorders); override;
    procedure DrawScaledHeaderEx(ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect; ANeighbors: TcxNeighbors;
      ABorders: TcxBorders; AState: TcxButtonState; AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert;
      AMultiLine, AShowEndEllipsis: Boolean; const AText: string; AFont: TFont; ATextColor, ABkColor: TColor;
      AScaleFactor: TdxScaleFactor; AOnDrawBackground: TcxDrawBackgroundEvent = nil); override;
    procedure DrawScaledSortingMark(ACanvas: TcxCanvas; const R: TRect; AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor); override;
    procedure DrawScaledSummarySortingMark(ACanvas: TcxCanvas; const R: TRect; AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor); override;
    function HeaderBorders(ANeighbors: TcxNeighbors): TcxBorders; override;
    function HeaderBorderSize: Integer; override;
    function ScaledSortingMarkSize(AScaleFactor: TdxScaleFactor): TPoint; override;
    function ScaledSummarySortingMarkSize(AScaleFactor: TdxScaleFactor): TPoint; override;
    // indicator
    procedure DrawScaledIndicatorItem(ACanvas: TcxCanvas; const R, AImageAreaBounds: TRect;
      AKind: TcxIndicatorKind; AColor: TColor; AScaleFactor: TdxScaleFactor; AOnDrawBackground: TcxDrawBackgroundEvent;
      ANeighbors: TcxNeighbors; APaintLeftSide: Boolean; AIsRightToLeft: Boolean; ABorderWidth: Integer = 1); override;
    // footer
    procedure DrawFooterBorder(ACanvas: TcxCanvas; const R: TRect;
      const ABorders: TcxBorders; AScaleFactor, ABordersScaleFactor: TdxScaleFactor); override;
    procedure DrawFooterBorderEx(ACanvas: TcxCanvas; const R: TRect; ABorders: TcxBorders; AScaleFactor: TdxScaleFactor); override;
    procedure DrawFooterCellBorder(ACanvas: TcxCanvas; const R: TRect; const ABorders: TcxBorders; AScaleFactor: TdxScaleFactor); override;
    function FooterBorderSize: Integer; override;
    function FooterCellBorderSize: Integer; override;
    function FooterCellOffset: Integer; override;
    // filter
    procedure DrawScaledFilterDropDownButton(ACanvas: TcxCanvas; R: TRect;
      AState: TcxButtonState; AIsFilterActive: Boolean; AScaleFactor: TdxScaleFactor); override;
    function ScaledFilterCloseButtonSize(AScaleFactor: TdxScaleFactor): TPoint; override;
    // tabs
    procedure DrawTabBorder(ACanvas: TcxCanvas; R: TRect; ABorder: TcxBorder; ABorders: TcxBorders; AVertical: Boolean); override;
    procedure DrawTabsRoot(ACanvas: TcxCanvas; const R: TRect; ABorders: TcxBorders; AVertical: Boolean); override;
    function TabBorderSize(AVertical: Boolean): Integer; override;
    // ms outlook
    procedure DrawSchedulerScaledNavigatorButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); override;
    procedure DrawSchedulerSplitterBorder(ACanvas: TcxCanvas; R: TRect; const AViewParams: TcxViewParams; AIsHorizontal: Boolean); override;
    // GroupBox
    procedure DrawGroupBoxScaledFrame(ACanvas: TcxCanvas; R: TRect; AEnabled: Boolean;
      ACaptionPosition: TcxGroupBoxCaptionPosition; AScaleFactor: TdxScaleFactor; ABorders: TcxBorders = cxBordersAll); override;
    // TrackBar
    procedure DrawTrackBarTrackBounds(ACanvas: TcxCanvas; const ARect: TRect); override;
    procedure DrawTrackBarThumbBorderUpDown(ACanvas: TcxCanvas;
      const ALightPolyLine, AShadowPolyLine, ADarkPolyLine: TPoints); override;
    procedure DrawTrackBarThumbBorderBoth(ACanvas: TcxCanvas; const ARect: TRect); override;
    // Printing System
    procedure DrawPrintPreviewScaledBackground(ACanvas: TcxCanvas; const R: TRect; AScaleFactor: TdxScaleFactor); override;
    // Splitter
    function GetSplitterOuterColor(AHighlighted: Boolean): TColor; override;
    function GetScaledSplitterSize(AHorizontal: Boolean; AScaleFactor: TdxScaleFactor): TSize; override;
    // navigator
    procedure DrawNavigatorScaledButton(ACanvas: TcxCustomCanvas; R: TRect; AState: TcxButtonState;
      ABackgroundColor: TColor; AScaleFactor: TdxScaleFactor); override;
    procedure DrawNavigatorBorder(ACanvas: TcxCustomCanvas; R: TRect; ASelected: Boolean); override;
    function NavigatorBorderOverlap: Boolean; override;
    function NavigatorBorderSize: Integer; override;
    // CustomMenu
    procedure DrawDropDownListBoxBackground(ACanvas: TcxCanvas; const ARect: TRect; AHasBorders: Boolean); override;
    procedure DrawDropDownListBoxScaledGutterBackground(ACanvas: TcxCanvas; const ARect: TRect; AScaleFactor: TdxScaleFactor); override;
    procedure DrawDropDownListBoxScaledSelection(ACanvas: TcxCanvas; const ARect, AGutterRect: TRect; AScaleFactor: TdxScaleFactor); override;
    procedure DrawDropDownListBoxScaledSeparator(ACanvas: TcxCanvas; const ARect, AGutterRect: TRect; AScaleFactor: TdxScaleFactor); override;
    function DropDownListBoxItemTextColor(ASelected: Boolean): TColor; override;
    // BreadcrumbEdit
    function BreadcrumbEditScaledButtonAreaSeparatorSize(AScaleFactor: TdxScaleFactor): Integer; override;
    function BreadcrumbEditScaledButtonContentOffsets(AIsFirst, AIsLast: Boolean; AScaleFactor: TdxScaleFactor): TRect; override;
    procedure DrawBreadcrumbEditBorders(ACanvas: TcxCanvas; const ARect: TRect;
      ABorders: TcxBorders; AState: TdxBreadcrumbEditState); override;
    procedure DrawBreadcrumbEditScaledButtonAreaSeparator(ACanvas: TcxCanvas;
      const ARect: TRect; AState: TdxBreadcrumbEditState; AScaleFactor: TdxScaleFactor); override;
    procedure DrawBreadcrumbEditScaledButton(ACanvas: TcxCanvas; const ARect: TRect;
      AState: TdxBreadcrumbEditButtonState; AIsFirst, AIsLast: Boolean; AScaleFactor: TdxScaleFactor); override;
    procedure DrawBreadcrumbEditScaledDropDownButton(ACanvas: TcxCanvas; const ARect: TRect;
      AState: TdxBreadcrumbEditButtonState; AIsInEditor: Boolean; AScaleFactor: TdxScaleFactor); override;

    // Bevel
    function GetBevelMinimalShapeSize(AShape: TdxBevelShape): TSize; override;
    procedure GetBevelShapeColors(out AColor1, AColor2: TColor); override;

    // Grid
    function GridBordersOverlapSize: Integer; override;

    // ToggleSwitch
    procedure DrawScaledToggleSwitchState(ACanvas: TcxCanvas; ABounds: TRect;
      AState: TcxButtonState; AChecked, AFocused: Boolean; AScaleFactor: TdxScaleFactor); override;
    function ToggleSwitchToggleColor(AChecked: Boolean): TColor; override;
    procedure DrawScaledToggleSwitchThumb(ACanvas: TcxCanvas; ABounds: TRect; AState: TcxButtonState; AChecked, AFocused: Boolean; AScaleFactor: TdxScaleFactor); override;

    // TokenEdit
    procedure DrawScaledTokenBackground(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); override;
  end;

  { TcxOffice11LookAndFeelPainter }

  TcxOffice11LookAndFeelPainter = class(TcxUltraFlatLookAndFeelPainter) //for internal use
  protected
    function DefaultDateNavigatorHeaderHighlightTextColor: TColor; override;
    function GetDefaultFixedColumnHighlightAAlpha: Byte; override;
    function HeaderBottomColor: TColor; virtual;
    function HeaderDarkEdgeColor: TColor; virtual;
    function HeaderHighlightEdgeColor: TColor; virtual;
    function HeaderTopColor: TColor; virtual;
    // Content
    procedure DrawContentBackground(ACanvas: TcxCustomCanvas; const R: TRect;
      AState: TcxButtonState; ABackgroundColor: TColor; AIsFooter: Boolean); override;
    // scrollbar
    procedure DoDrawScaledScrollBarPart(ACanvas: TcxCustomCanvas; AHorizontal: Boolean;
      R: TRect; APart: TcxScrollBarPart; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); override;
    // filter
    function FilterDropDownButtonBorderColor(AState: TcxButtonState): TColor; override;
    // tabs
    function TabBorderHighlightColor: TColor; override;
    function TabBorderDarkColor: TColor; override;
    // scheduler3
    procedure DrawSchedulerNavigationButtonContent(ACanvas: TcxCanvas;
      const ARect: TRect; const AArrowRect: TRect; AIsNextButton: Boolean;
      AState: TcxButtonState; const AIsVertical: Boolean = True); override;
    // BreadcrumbEdit
    procedure DrawBreadcrumbEditCustomButton(ACanvas: TcxCanvas; const R: TRect;
      AState: TdxBreadcrumbEditButtonState; ABorders: TcxBorders); override;
    //Data Row Layout
    function GetDataRowLayoutContentColor: TColor; override;
  public
    function LookAndFeelName: string; override;
    function LookAndFeelStyle: TcxLookAndFeelStyle; override;
    function NeedRedrawOnResize: Boolean; override;

    // colors
    function DefaultControlColor: TColor; override;
    function DefaultControlTextColor: TColor; override;
    function DefaultDateNavigatorHeaderColor: TColor; override;
    function DefaultDateNavigatorSelectionColor: TColor; override;
    function DefaultDateNavigatorSelectionTextColor: TColor; override;
    function DefaultFilterBoxColor: TColor; override;
    function DefaultFilterBoxTextColor: TColor; override;
    function DefaultFooterColor: TColor; override;
    function DefaultFooterTextColor: TColor; override;
    function DefaultGroupColor: TColor; override;
    function DefaultGroupByBoxColor: TColor; override;
    function DefaultGroupByBoxTextColor: TColor; override;
    function DefaultHeaderColor: TColor; override;
    function DefaultHeaderBackgroundColor: TColor; override;
    function DefaultSchedulerBorderColor: TColor; override;
    function DefaultSchedulerControlColor: TColor; override;
    function DefaultSchedulerDayHeaderColor: TColor; override;
    function DefaultTabColor: TColor; override;
    function DefaultTabsBackgroundColor: TColor; override;
    function DefaultTimeGridMinorScaleColor: TColor; override;
    function DefaultTimeGridSelectionBarColor: TColor; override;
    // border
    function SeparatorSize: Integer; override;
    function BorderHighlightColor: TColor; override;
    procedure DrawBorder(ACanvas: TcxCustomCanvas; R: TRect; AWidth: Integer = 1); override;
    procedure DoDrawSeparator(ACanvas: TcxCustomCanvas; R: TRect; AIsVertical: Boolean); override;
    function IncludeTopBorderToSectionHeaderForLightBorders: Boolean; override;
    // buttons
    function ButtonColor(AState: TcxButtonState): TColor; override;
    function ButtonSymbolColor(AState: TcxButtonState; ADefaultColor: TColor = clDefault; APart: TcxButtonPart = cxbpButton): TColor; override;
    procedure DrawButtonBorder(ACanvas: TcxCustomCanvas; R: TRect; AState: TcxButtonState); override;
    procedure DrawScaledExpandButton(ACanvas: TcxCustomCanvas; const R: TRect; AExpanded: Boolean;
      AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault; AState: TcxExpandButtonState = cebsNormal); override;
    function DrawExpandButtonFirst: Boolean; override;
    procedure DrawScaledSmallExpandButton(ACanvas: TcxCanvas; R: TRect; AExpanded: Boolean;
      ABorderColor: TColor; AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault); override;
    function ScaledExpandButtonSize(AScaleFactor: TdxScaleFactor): Integer; override;
    function ScaledSmallExpandButtonSize(AScaleFactor: TdxScaleFactor): Integer; override;
    // checkbox
    function CheckButtonColor(AState: TcxButtonState; ACheckState: TcxCheckBoxState): TColor; override;
    // RadioButton
    function RadioButtonBodyColor(AState: TcxButtonState): TColor; override;
    // filter
    procedure DrawScaledFilterDropDownButton(ACanvas: TcxCanvas; R: TRect;
      AState: TcxButtonState; AIsFilterActive: Boolean; AScaleFactor: TdxScaleFactor); override;
    // header
    procedure DrawScaledHeader(ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect; ANeighbors: TcxNeighbors;
      ABorders: TcxBorders; AState: TcxButtonState; AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert;
      AMultiLine, AShowEndEllipsis: Boolean; const AText: string; AFont: TFont; ATextColor, ABkColor: TColor;
      AScaleFactor: TdxScaleFactor; AOnDrawBackground: TcxDrawBackgroundEvent = nil; AIsLast: Boolean = False;
      AInGroupByBox: Boolean = False; ABorderWidth: Integer = 1); override;
    procedure DrawHeaderBorder(ACanvas: TcxCustomCanvas; const R: TRect; ANeighbors: TcxNeighbors; ABorders: TcxBorders); override;
    procedure DrawScaledHeaderControlSection(ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect; ANeighbors: TcxNeighbors;
      ABorders: TcxBorders; AState: TcxButtonState; AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert; AMultiLine,
      AShowEndEllipsis: Boolean; const AText: string; AFont: TFont; ATextColor, ABkColor: TColor; AScaleFactor: TdxScaleFactor); override;
    procedure DrawScaledSortingMark(ACanvas: TcxCanvas; const R: TRect; AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor); override;
    procedure DrawScaledSummarySortingMark(ACanvas: TcxCanvas; const R: TRect; AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor); override;
    function HeaderBorders(ANeighbors: TcxNeighbors): TcxBorders; override;
    function HeaderBorderSize: Integer; override;
    function IsHeaderHotTrack: Boolean; override;
    // footer
    function FooterSeparatorColor: TColor; override;
    function FooterBorders: TcxBorders; override;
    // Grid
    function GridBordersOverlapSize: Integer; override;
    procedure LayoutViewDrawScaledRecordCaption(ACanvas: TcxCanvas; const ABounds, ATextRect: TRect;
      APosition: TcxGroupBoxCaptionPosition; AState: TcxButtonState; AScaleFactor: TdxScaleFactor;
      AColor: TColor = clDefault; const ABitmap: TBitmap = nil); override;
    // tabs
    // scrollbars
    function ScaledScrollBarMinimalThumbSize(AVertical: Boolean; AScaleFactor: TdxScaleFactor): Integer; override;
    // ms outlook
    procedure DrawScaledMonthHeader(ACanvas: TcxCanvas; const ABounds: TRect; const AText: string; ANeighbors: TcxNeighbors;
      const AViewParams: TcxViewParams; AArrows: TcxArrowDirections; ASideWidth: Integer; AScaleFactor: TdxScaleFactor;
      AOnDrawBackground: TcxDrawBackgroundEvent = nil); override;
    procedure DrawSchedulerScaledNavigatorButton(ACanvas: TcxCanvas; R: TRect;
      AState: TcxButtonState; AScaleFactor: TdxScaleFactor); override;
    procedure DrawSchedulerBorder(ACanvas: TcxCanvas; R: TRect); override;
    // SizeGrip
    procedure DoDrawSizeGrip(ACanvas: TcxCanvas; const ARect: TRect; AScaleFactor: TdxScaleFactor); override;
    // GroupBox
    procedure DrawGroupBoxScaledFrame(ACanvas: TcxCanvas; R: TRect;
      AEnabled: Boolean; ACaptionPosition: TcxGroupBoxCaptionPosition;
      AScaleFactor: TdxScaleFactor; ABorders: TcxBorders = cxBordersAll); override;
    function GroupBoxTextColor(AEnabled: Boolean; ACaptionPosition: TcxGroupBoxCaptionPosition): TColor; override;
    // TrackBar
    procedure DrawTrackBarTrackBounds(ACanvas: TcxCanvas; const ARect: TRect); override;
    procedure DrawTrackBarThumbBorderUpDown(ACanvas: TcxCanvas;
      const ALightPolyLine, AShadowPolyLine, ADarkPolyLine: TPoints); override;
    procedure DrawTrackBarThumbBorderBoth(ACanvas: TcxCanvas; const ARect: TRect); override;
    // Panel
    procedure DrawPanelBackground(ACanvas: TcxCanvas; AControl: TWinControl; ABounds: TRect;
      AColorFrom: TColor = clDefault; AColorTo: TColor = clDefault); override;
    // Layout Control
    procedure DrawLayoutControlBackground(ACanvas: TcxCanvas; const R: TRect); override;
    // DateNavigator
    procedure DrawDateNavigatorDateHeader(ACanvas: TcxCanvas; var R: TRect); override;
    // Splitter
    function GetSplitterInnerColor(AHighlighted: Boolean): TColor; override;
    function GetSplitterOuterColor(AHighlighted: Boolean): TColor; override;
    // navigator
    function NavigatorBorderSize: Integer; override;
    // BreadcrumbEdit
    function BreadcrumbEditBackgroundColor(AState: TdxBreadcrumbEditState): TColor; override;
    procedure DrawBreadcrumbEditBorders(ACanvas: TcxCanvas; const ARect: TRect;
      ABorders: TcxBorders; AState: TdxBreadcrumbEditState); override;
    // CustomMenu
    procedure DrawDropDownListBoxBackground(ACanvas: TcxCanvas; const ARect: TRect; AHasBorders: Boolean); override;
    procedure DrawDropDownListBoxScaledGutterBackground(ACanvas: TcxCanvas; const ARect: TRect; AScaleFactor: TdxScaleFactor); override;
    procedure DrawDropDownListBoxScaledSelection(ACanvas: TcxCanvas; const ARect: TRect; const AGutterRect: TRect; AScaleFactor: TdxScaleFactor); override;
    procedure DrawDropDownListBoxScaledSeparator(ACanvas: TcxCanvas; const ARect: TRect; const AGutterRect: TRect; AScaleFactor: TdxScaleFactor); override;
    //AlertWindow
    procedure DrawAlertWindowBackground(ACanvas: TcxCanvas; const ABounds: TRect; AScaleFactor: TdxScaleFactor = nil); override;

    // Bevel
    function GetBevelMinimalShapeSize(AShape: TdxBevelShape): TSize; override;
    procedure GetBevelShapeColors(out AColor1, AColor2: TColor); override;

    // Clock
    function ScaledClockSize(AScaleFactor: TdxScaleFactor): TSize; override;
    procedure DrawScaledClock(ACanvas: TcxCanvas; const ARect: TRect;
      ADateTime: TDateTime; ABackgroundColor: TColor; AScaleFactor: TdxScaleFactor); override;
    // RichEditControl
    function RichEditControlHeaderFooterLineColor: TColor; override;
    function RichEditControlHeaderFooterMarkBackColor: TColor; override;
    function RichEditRulerInactiveAreaColor: TColor; override;
    function RichEditRulerTabTypeToggleBorderColor: TColor; override;
	  // TokenEdit
    procedure DrawScaledTokenBackground(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); override;
    // SpreadSheet
    procedure DrawSpreadSheetScaledHeader(ACanvas: TcxCustomCanvas; const R: TRect; ANeighbors: TcxNeighbors;
      ABorders: TcxBorders; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); override;
  end;

  { TcxWinXPLookAndFeelPainter }

  TcxWinXPLookAndFeelPainter = class(TcxStandardLookAndFeelPainter) //for internal use
  strict private const
    ButtonStateToHeaderState: array[TcxButtonState] of Integer = (
      HIS_NORMAL, HIS_NORMAL, HIS_HOT, HIS_PRESSED, HIS_NORMAL
    );
  strict private
    FZoomInButtonGlyph: TcxBitmap32;
    FZoomOutButtonGlyph: TcxBitmap32;

    procedure DrawNativeRangeTrackBarThumb(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState;
      AHorizontal: Boolean; ATicks: TcxTrackBarTicksAlign; AThumbColor: TColor; AScaleFactor: TdxScaleFactor);
    function DoDrawThemeBackground(ACanvas: TcxCustomCanvas; AThemedObjectType: TdxThemedObjectType;
      AScaleFactor: TdxScaleFactor; const R: TRect; APartId, AStateId: Integer): Boolean;
    function DoDrawScaledThemeBackground(ACanvas: TcxCustomCanvas; AThemedObjectType: TdxThemedObjectType;
      AScaleFactor: TdxScaleFactor; const R: TRect; APartId, AStateId: Integer): Boolean;
  protected
    procedure DoDrawScaledButtonCaption(ACanvas: TcxCanvas; R: TRect; const ACaption: string;
      AState: TcxButtonState; ATextColor: TColor; ADrawBorder, AIsToolButton, AWordWrap: Boolean;
      AScaleFactor: TdxScaleFactor; APart: TcxButtonPart); override;
    procedure DoDrawScaledScrollBarPart(ACanvas: TcxCustomCanvas; AHorizontal: Boolean;
      R: TRect; APart: TcxScrollBarPart; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); override;
    procedure DrawBreadcrumbEditNodePart(ACanvas: TcxCanvas; const R: TRect;
      AState: TdxBreadcrumbEditButtonState; ABorders: TcxBorders; AScaleFactor: TdxScaleFactor);
    procedure DrawContent(ACanvas: TcxCanvas; ATheme: TdxTheme; APartId, AStateId: Integer;
      const ABounds, ATextAreaBounds: TRect; AAlignmentHorz: TAlignment;
      AAlignmentVert: TcxAlignmentVert; AMultiLine, AShowEndEllipsis, AShowPrefix: Boolean;
      const AText: string; AFont: TFont; ATextColor, ABkColor: TColor); reintroduce; virtual;
    procedure DrawSchedulerNavigationButtonContent(ACanvas: TcxCanvas;
      const ARect: TRect; const AArrowRect: TRect; AIsNextButton: Boolean;
      AState: TcxButtonState; const AIsVertical: Boolean = True); override;
    procedure DrawThemedTab(ACanvas: TcxCanvas; R: TRect; ABorders: TcxBorders;
      const AText: string; ATheme: TdxTheme; AState: Integer; AVertical: Boolean;
      AFont: TFont; ATextColor, ABkColor: TColor; AShowPrefix: Boolean = False);
    function NativeZoomButtonDraw(ACanvas: TcxCanvas; const R: TRect;
      AState: TcxButtonState; AScaleFactor: TdxScaleFactor; AGlyph: TBitmap): Boolean;
    function NativeZoomButtonGetMinSize(AGlyph: TBitmap; AScaleFactor: TdxScaleFactor; out ASize: TSize): Boolean;

    property ZoomInButtonGlyph: TcxBitmap32 read FZoomInButtonGlyph;
    property ZoomOutButtonGlyph: TcxBitmap32 read FZoomOutButtonGlyph;

    function FooterContentOffset: Integer; override;
  public
    destructor Destroy; override;
    procedure AfterConstruction; override;
    function LookAndFeelName: string; override;
    function LookAndFeelStyle: TcxLookAndFeelStyle; override;
    function NeedRedrawOnResize: Boolean; override;

    class procedure DrawScaledThemeBackground(ATheme: TdxTheme; DC: HDC; APartId, AStateId: Integer; const R: TRect;
      AScaleFactor: TdxScaleFactor; AForceScale: Boolean = False; AUseThemePartSize: Boolean = True);

    // colors
    function DefaultFilterBoxColor: TColor; override;
    function DefaultFilterBoxTextColor: TColor; override;
    function DefaultFooterColor: TColor; override;
    function DefaultFooterTextColor: TColor; override;
    function DefaultGridLineColor: TColor; override;
    function DefaultGroupByBoxColor: TColor; override;
    function DefaultGroupByBoxTextColor: TColor; override;
    function DefaultSchedulerBorderColor: TColor; override;

    // arrow
    procedure DrawScaledArrow(ACanvas: TcxCustomCanvas; const R: TRect; AState: TcxButtonState; AArrowDirection: TcxArrowDirection; AScaleFactor: TdxScaleFactor; ADrawBorder: Boolean = True); override;
    procedure DrawScaledArrowBorder(ACanvas: TcxCustomCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); override;
    // border
    function BorderSize: Integer; override;
    function SeparatorSize: Integer; override;
    procedure DrawBorder(ACanvas: TcxCustomCanvas; R: TRect; AWidth: Integer = 1); override;
    procedure DoDrawSeparator(ACanvas: TcxCustomCanvas; R: TRect; AIsVertical: Boolean); override;
    // buttons
    function ButtonBorderSize(AState: TcxButtonState = cxbsNormal): Integer; override;
    function ButtonColor(AState: TcxButtonState): TColor; override;
    function ButtonSymbolColor(AState: TcxButtonState; ADefaultColor: TColor = clDefault; APart: TcxButtonPart = cxbpButton): TColor; override;
    procedure DrawScaledButton(ACanvas: TcxCustomCanvas; R: TRect; AState: TcxButtonState;
      AFocused: Boolean; AScaleFactor: TdxScaleFactor; ADrawBorder: Boolean = True; AIsToolButton: Boolean = False;
      APart: TcxButtonPart = cxbpButton; AColor: TColor = clDefault); override;
    function ScaledButtonTextOffset(AScaleFactor: TdxScaleFactor): Integer; override;
    function ScaledButtonTextShift(AScaleFactor: TdxScaleFactor): Integer; override;
    function ScaledButtonFocusRect(ACanvas: TcxCanvas; R: TRect; AScaleFactor: TdxScaleFactor): TRect; override;

    //CommandLink
    function DefaultCommandLinkTextColor(AState: TcxButtonState; ADefaultColor: TColor = clDefault): TColor; override;
    procedure DrawScaledCommandLinkBackground(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState;
      AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault); override;
    procedure DrawScaledCommandLinkGlyph(ACanvas: TcxCanvas; const AGlyphPos: TPoint;
      AState: TcxButtonState; AScaleFactor: TdxScaleFactor); override;
    function GetScaledCommandLinkGlyphSize(AScaleFactor: TdxScaleFactor): TSize; override;
    function GetScaledCommandLinkMargins(AScaleFactor: TdxScaleFactor): TRect; override;

    procedure DrawScaledExpandButton(ACanvas: TcxCustomCanvas; const R: TRect; AExpanded: Boolean;
      AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault; AState: TcxExpandButtonState = cebsNormal); override;
    procedure DrawTreeViewExpandButton(ACanvas: TcxCanvas; const R: TRect;
      AExpanded: Boolean; AExplorerStyle: Boolean; AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault;
      AState: TcxExpandButtonState = cebsNormal); overload; override; //
    function DrawExpandButtonFirst: Boolean; override;
    procedure DrawScaledGroupExpandButton(ACanvas: TcxCustomCanvas; const R: TRect;
      AExpanded: Boolean; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); override;
    procedure DrawScaledSmallButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); override;
    procedure DrawScaledSmallExpandButton(ACanvas: TcxCanvas; R: TRect;
      AExpanded: Boolean; ABorderColor: TColor; AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault); override;
    function ScaledExpandButtonSize(AScaleFactor: TdxScaleFactor): Integer; override;
    function ScaledGroupExpandButtonSize(AScaleFactor: TdxScaleFactor): Integer; override;
    function ScaledSmallExpandButtonSize(AScaleFactor: TdxScaleFactor): Integer; override;
    function IsButtonHotTrack: Boolean; override;
    function IsPointOverGroupExpandButton(const R: TRect; const P: TPoint): Boolean; override;
    function TreeViewExpandButtonSize(AExplorerStyle: Boolean; AScaleFactor: TdxScaleFactor): TSize; override;
    // checkbox
    function CheckBorderSize: Integer; override;
    function ScaledCheckButtonSize(AScaleFactor: TdxScaleFactor): TSize; override;
    procedure DrawScaledCheck(ACanvas: TcxCustomCanvas; const R: TRect; AState: TcxButtonState;
      ACheckState: TcxCheckBoxState; AColor: TColor; AScaleFactor: TdxScaleFactor; ADrawBackground: Boolean); override;
    procedure DrawCheckBorder(ACanvas: TcxCustomCanvas; R: TRect; AState: TcxButtonState); override;
    // RadioGroup
    procedure DrawScaledRadioButton(ACanvas: TcxCanvas; X, Y: Integer; AButtonState: TcxButtonState;
      AChecked, AFocused: Boolean; ABrushColor: TColor; AScaleFactor: TdxScaleFactor; AIsDesigning: Boolean = False); override;
    function ScaledRadioButtonSize(AScaleFactor: TdxScaleFactor): TSize; override;
    // BackButton
    function GetScaledBackButtonSize(AScaleFactor: TdxScaleFactor): TSize; override;
    procedure DrawScaledBackButton(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); override;
    // ZoomButtons
    function GetScaledZoomInButtonSize(AScaleFactor: TdxScaleFactor): TSize; override;
    function GetScaledZoomOutButtonSize(AScaleFactor: TdxScaleFactor): TSize; override;
    procedure DrawScaledZoomInButton(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); override;
    procedure DrawScaledZoomOutButton(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); override;
    // header
    procedure DrawScaledHeader(ACanvas: TcxCustomCanvas; const ABounds: TRect; AState: TcxButtonState; ANeighbors: TcxNeighbors;
      ABorders: TcxBorders; AScaleFactor: TdxScaleFactor; AIsLast: Boolean = False; AIsGroup: Boolean = False); override;
    procedure DrawScaledHeader(ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect; ANeighbors: TcxNeighbors;
      ABorders: TcxBorders; AState: TcxButtonState; AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert;
      AMultiLine, AShowEndEllipsis: Boolean; const AText: string; AFont: TFont; ATextColor, ABkColor: TColor;
      AScaleFactor: TdxScaleFactor; AOnDrawBackground: TcxDrawBackgroundEvent = nil; AIsLast: Boolean = False;
      AInGroupByBox: Boolean = False; ABorderWidth: Integer = 1); override;
    procedure DrawHeaderPressed(ACanvas: TcxCanvas; const ABounds: TRect); override;
    procedure DrawScaledHeaderControlSection(ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect; ANeighbors: TcxNeighbors;
      ABorders: TcxBorders; AState: TcxButtonState; AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert;
      AMultiLine, AShowEndEllipsis: Boolean; const AText: string; AFont: TFont; ATextColor, ABkColor: TColor; AScaleFactor: TdxScaleFactor); override;
    procedure DrawScaledSortingMark(ACanvas: TcxCanvas; const R: TRect; AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor); override;
    procedure DrawScaledSummarySortingMark(ACanvas: TcxCanvas; const R: TRect; AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor); override;
    function HeaderBorderSize: Integer; override;
    function HeaderControlSectionBorderSize(AState: TcxButtonState = cxbsNormal): Integer; override;
    function HeaderControlSectionContentBounds(const ABounds: TRect; AState: TcxButtonState): TRect; override;
    function IsHeaderHotTrack: Boolean; override;
    function ScaledSortingMarkSize(AScaleFactor: TdxScaleFactor): TPoint; override;
    // filter row separator
    procedure DrawFilterRowSeparator(ACanvas: TcxCanvas; const ARect: TRect; ABackgroundColor: TColor); override;
    // footer
    procedure DrawFooterBorder(ACanvas: TcxCanvas; const R: TRect;
      const ABorders: TcxBorders; AScaleFactor, ABordersScaleFactor: TdxScaleFactor); override;
    procedure DrawFooterCell(ACanvas: TcxCanvas; const ABounds: TRect; AAlignmentHorz: TAlignment;
      AAlignmentVert: TcxAlignmentVert; AMultiLine: Boolean; const AText: string; AFont: TFont;
      ATextColor, ABkColor: TColor; AOnDrawBackground: TcxDrawBackgroundEvent; const ABorders: TcxBorders;
      APaddingsScaleFactor, ABordersScaleFactor: TdxScaleFactor); override;
    function FooterBorderSize: Integer; override;
    function FooterCellBorderSize: Integer; override;
    function FooterCellBordersSizeRect(const ABorders: TcxBorders; AScaleFactor, ABordersScaleFactor: TdxScaleFactor): TRect; override;
    function FooterDrawCellsFirst: Boolean; override;
    function FooterSeparatorColor: TColor; override;

    // filter
    procedure DrawScaledFilterCloseButton(ACanvas: TcxCanvas; R: TRect;
      AState: TcxButtonState; AScaleFactor: TdxScaleFactor); override;
    procedure DrawScaledFilterDropDownButton(ACanvas: TcxCanvas; R: TRect;
      AState: TcxButtonState; AIsFilterActive: Boolean; AScaleFactor: TdxScaleFactor); override;
    function ScaledFilterActivateButtonSize(AScaleFactor: TdxScaleFactor): TPoint; override;
    function ScaledFilterCloseButtonSize(AScaleFactor: TdxScaleFactor): TPoint; override;

    //LayoutView
    function DefaultLayoutViewCaptionTextColor(ACaptionPosition: TcxGroupBoxCaptionPosition; AState: TcxButtonState): TColor; override;
    function DefaultLayoutViewContentTextColor(AState: TcxButtonState): TColor; override;
    procedure LayoutViewDrawScaledRecordCaption(ACanvas: TcxCanvas; const ABounds, ATextRect: TRect;
      APosition: TcxGroupBoxCaptionPosition; AState: TcxButtonState; AScaleFactor: TdxScaleFactor;
      AColor: TColor = clDefault; const ABitmap: TBitmap = nil); override;

    procedure LayoutViewDrawItemScaled(ACanvas: TcxCanvas; const ABounds: TRect;
      AState: TcxButtonState; AScaleFactor: TdxScaleFactor; ABorders: TcxBorders = []); override;
    //WinExplorer View
    procedure WinExplorerViewDrawRecord(ACanvas: TcxCanvas; const ABounds: TRect; AState: TcxButtonState;
      AColor: TColor = clDefault; const ABitmap: TBitmap = nil); override;
    function WinExplorerViewRecordTextColor(AState: TcxButtonState): TColor; override;
    // tabs
    procedure DrawTab(ACanvas: TcxCanvas; R: TRect; ABorders: TcxBorders;
      const AText: string; AState: TcxButtonState; AVertical: Boolean; AFont: TFont;
      ATextColor, ABkColor: TColor; AShowPrefix: Boolean = False); override;
    procedure DrawTabBorder(ACanvas: TcxCanvas; R: TRect; ABorder: TcxBorder; ABorders: TcxBorders; AVertical: Boolean); override;
    procedure DrawTabsRoot(ACanvas: TcxCanvas; const R: TRect; ABorders: TcxBorders; AVertical: Boolean); override;
    function IsDrawTabImplemented(AVertical: Boolean): Boolean; override;
    function IsTabHotTrack(AVertical: Boolean): Boolean; override;
    function TabBorderSize(AVertical: Boolean): Integer; override;
    // Splitter
    procedure DrawScaledSplitter(ACanvas: TcxCustomCanvas; const ARect: TRect; AHighlighted, AClicked, AHorizontal: Boolean;
      AScaleFactor: TdxScaleFactor; AHasCloseMark: Boolean = False; AArrowDirection: TcxArrowDirection = adLeft); override;
    // indicator
    procedure DrawScaledIndicatorItem(ACanvas: TcxCanvas; const R, AImageAreaBounds: TRect;
      AKind: TcxIndicatorKind; AColor: TColor; AScaleFactor: TdxScaleFactor; AOnDrawBackground: TcxDrawBackgroundEvent;
      ANeighbors: TcxNeighbors; APaintLeftSide: Boolean; AIsRightToLeft: Boolean; ABorderWidth: Integer = 1); override;
    // scrollbars
    function ScaledScrollBarMinimalThumbSize(AVertical: Boolean; AScaleFactor: TdxScaleFactor): Integer; override;
    procedure DrawScaledScrollBarSplitter(ACanvas: TcxCustomCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); override;
    // ms outlook
    function DefaultSchedulerViewContentColor: TColor; override;
    function DefaultSchedulerViewContentColorClassic: TColor; override;
    procedure DrawScaledMonthHeader(ACanvas: TcxCanvas; const ABounds: TRect; const AText: string; ANeighbors: TcxNeighbors;
      const AViewParams: TcxViewParams; AArrows: TcxArrowDirections; ASideWidth: Integer; AScaleFactor: TdxScaleFactor;
      AOnDrawBackground: TcxDrawBackgroundEvent = nil); override;
    procedure DrawSchedulerScaledEventProgress(ACanvas: TcxCanvas; const ABounds, AProgress: TRect;
      AViewParams: TcxViewParams; ATransparent: Boolean; AScaleFactor: TdxScaleFactor); override;
    procedure DrawSchedulerScaledNavigatorButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); override;
    procedure DrawSchedulerSplitterBorder(ACanvas: TcxCanvas; R: TRect;
      const AViewParams: TcxViewParams; AIsHorizontal: Boolean); override;
    function SchedulerEventProgressOffsets: TRect; override;
    // SizeGrip
    function ScaledSizeGripSize(AScaleFactor: TdxScaleFactor): TSize; override;
    procedure DoDrawSizeGrip(ACanvas: TcxCanvas; const ARect: TRect; AScaleFactor: TdxScaleFactor); override;
    // CloseButton
    function DoGetSmallCloseButtonSize: TSize; override;
    // GroupBox
    procedure DrawGroupBoxScaledFrame(ACanvas: TcxCanvas; R: TRect; AEnabled: Boolean;
      ACaptionPosition: TcxGroupBoxCaptionPosition; AScaleFactor: TdxScaleFactor; ABorders: TcxBorders = cxBordersAll); override;
    function GroupBoxTextColor(AEnabled: Boolean; ACaptionPosition: TcxGroupBoxCaptionPosition): TColor; override;
    // Panel
    procedure DrawPanelBackground(ACanvas: TcxCanvas; AControl: TWinControl; ABounds: TRect;
      AColorFrom: TColor = clDefault; AColorTo: TColor = clDefault); override;
    // Popup
    procedure DrawEditPopupWindowBorder(ACanvas: TcxCanvas; var R: TRect;
      ABorderStyle: TcxEditPopupBorderStyle; AClientEdge: Boolean); override;
    function GetEditPopupWindowBorderWidth(AStyle: TcxEditPopupBorderStyle): Integer; override;
    function GetEditPopupWindowClientEdgeWidth(AStyle: TcxEditPopupBorderStyle): Integer; override;
    // Hints
      // Attributes
    function GetHintBorderColor: TColor; override;
      // Draw
    procedure DrawHintBackground(ACanvas: TcxCanvas; const ARect: TRect; AColor: TColor = clDefault); override;
    // ScreenTips
      // Attributes
    function ScreenTipGetDescriptionTextColor: TColor; override;
    function ScreenTipGetTitleTextColor: TColor; override;
    // TrackBar
    procedure CorrectThumbRect(ACanvas: TcxCanvas; var ARect: TRect;
      AHorizontal: Boolean; ATicks: TcxTrackBarTicksAlign; AScaleFactor: TdxScaleFactor); override;
    procedure DrawTrackBarScaledTrack(ACanvas: TcxCanvas; const ARect, ASelection: TRect;
      AShowSelection, AEnabled, AHorizontal: Boolean; ATrackColor: TColor; AScaleFactor: TdxScaleFactor); override;
    procedure DrawTrackBarScaledThumb(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState;
      AHorizontal: Boolean; ATicks: TcxTrackBarTicksAlign; AThumbColor: TColor; AScaleFactor: TdxScaleFactor); override;
    // RangeTrackBar
    procedure DrawRangeTrackBarScaledLeftThumb(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState;
      AHorizontal: Boolean; ATicks: TcxTrackBarTicksAlign; AThumbColor: TColor; AScaleFactor: TdxScaleFactor); override;
    procedure DrawRangeTrackBarScaledRightThumb(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState;
      AHorizontal: Boolean; ATicks: TcxTrackBarTicksAlign; AThumbColor: TColor; AScaleFactor: TdxScaleFactor); override;
    // DateNavigator
    procedure DrawDateNavigatorDateHeader(ACanvas: TcxCanvas; var R: TRect); override;
    // navigator
    function NavigatorButtonPressedGlyphOffset: TPoint; override;
    function NavigatorScaledButtonMinSize(AScaleFactor: TdxScaleFactor): TSize; override;
    // DropDownListBox
    function DropDownListBoxItemTextColor(ASelected: Boolean): TColor; override;
    function DropDownListBoxScaledSeparatorSize(AScaleFactor: TdxScaleFactor): Integer; override;
    procedure DrawDropDownListBoxBackground(ACanvas: TcxCanvas; const ARect: TRect; AHasBorders: Boolean); override;
    procedure DrawDropDownListBoxScaledGutterBackground(ACanvas: TcxCanvas; const ARect: TRect; AScaleFactor: TdxScaleFactor); override;
    procedure DrawDropDownListBoxScaledSelection(ACanvas: TcxCanvas; const ARect: TRect; const AGutterRect: TRect; AScaleFactor: TdxScaleFactor); override;
    procedure DrawDropDownListBoxScaledSeparator(ACanvas: TcxCanvas; const ARect: TRect; const AGutterRect: TRect; AScaleFactor: TdxScaleFactor); override;
    // ProgressBar
    function ProgressBarTextColor(APart: TcxProgressBarPart = pbpBackground): TColor; override;
    // BreadcrumbEdit
    function BreadcrumbEditBackgroundColor(AState: TdxBreadcrumbEditState): TColor; override;
    function BreadcrumbEditBordersSize: TRect; override;
    function BreadcrumbEditIsFadingSupports: Boolean; override;
    function BreadcrumbEditProgressChunkTextColor: TColor; override;
    function BreadcrumbEditScaledButtonContentOffsets(AIsFirst, AIsLast: Boolean; AScaleFactor: TdxScaleFactor): TRect; override;
    function BreadcrumbEditScaledProgressChunkOverlaySize(AScaleFactor: TdxScaleFactor): TSize; override;
    function BreadcrumbEditScaledProgressChunkPadding(AScaleFactor: TdxScaleFactor): TRect; override;
    procedure DrawBreadcrumbEditBorders(ACanvas: TcxCanvas;
      const ARect: TRect; ABorders: TcxBorders; AState: TdxBreadcrumbEditState); override;
    procedure DrawBreadcrumbEditScaledButtonAreaSeparator(ACanvas: TcxCanvas; const ARect: TRect;
      AState: TdxBreadcrumbEditState; AScaleFactor: TdxScaleFactor); override;
    procedure DrawBreadcrumbEditScaledButton(ACanvas: TcxCanvas; const ARect: TRect;
      AState: TdxBreadcrumbEditButtonState; AIsFirst, AIsLast: Boolean; AScaleFactor: TdxScaleFactor); override;
    procedure DrawBreadcrumbEditScaledDropDownButton(ACanvas: TcxCanvas; const ARect: TRect;
      AState: TdxBreadcrumbEditButtonState; AIsInEditor: Boolean; AScaleFactor: TdxScaleFactor); override;
    procedure DrawBreadcrumbEditScaledNode(ACanvas: TcxCanvas; const R: TRect;
      AState: TdxBreadcrumbEditButtonState; AHasDelimiter: Boolean; AScaleFactor: TdxScaleFactor); override;
    procedure DrawBreadcrumbEditScaledNodeDelimiter(ACanvas: TcxCanvas; const R: TRect;
      AState: TdxBreadcrumbEditButtonState; AScaleFactor: TdxScaleFactor); override;
    procedure DrawBreadcrumbEditScaledNodeDelimiterGlyph(ACanvas: TcxCanvas; const R: TRect;
      AState: TdxBreadcrumbEditButtonState; AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault); override;
    procedure DrawBreadcrumbEditScaledNodeMoreButtonGlyph(ACanvas: TcxCanvas; const R: TRect;
      AState: TdxBreadcrumbEditButtonState; AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault); override;
    procedure DrawBreadcrumbEditScaledProgressChunk(ACanvas: TcxCanvas; const R: TRect; AScaleFactor: TdxScaleFactor); override;
    procedure DrawBreadcrumbEditScaledProgressChunkOverlay(ACanvas: TcxCanvas; const R: TRect; AScaleFactor: TdxScaleFactor); override;
    //AlertWindow
    function AlertWindowCornerRadius: Integer; override;

    // Bevel
    procedure DrawBevelFrame(ACanvas: TcxCanvas; const R: TRect; AColor1, AColor2: TColor; ABoxStyle: Boolean); override;
    procedure DrawBevelLine(ACanvas: TcxCanvas; const R: TRect; AColor1, AColor2: TColor; AIsVertical: Boolean); override;
    function GetBevelMinimalShapeSize(AShape: TdxBevelShape): TSize; override;

    // Gallery
    procedure DrawGalleryGroupHeaderScaled(ACanvas: TcxCustomCanvas; const ABounds: TRect; AScaleFactor: TdxScaleFactor); override;
    function DrawGalleryItemSelectionFirst: Boolean; override;
    procedure DrawGalleryItemSelectionScaled(ACanvas: TcxCustomCanvas; const R: TRect;
       AViewState: TdxGalleryItemViewState; AScaleFactor: TdxScaleFactor); override;
    //ToggleSwitch
    procedure DrawScaledToggleSwitchState(ACanvas: TcxCanvas; ABounds: TRect;
      AState: TcxButtonState; AChecked, AFocused: Boolean; AScaleFactor: TdxScaleFactor); override;
    procedure DrawScaledToggleSwitchThumb(ACanvas: TcxCanvas; ABounds: TRect;
      AState: TcxButtonState; AChecked, AFocused: Boolean; AScaleFactor: TdxScaleFactor); override;
    function ToggleSwitchToggleColor(AChecked: Boolean): TColor; override;
    // Clock
    function ScaledClockSize(AScaleFactor: TdxScaleFactor): TSize; override;
    procedure DrawScaledClock(ACanvas: TcxCanvas; const ARect: TRect;
      ADateTime: TDateTime; ABackgroundColor: TColor; AScaleFactor: TdxScaleFactor); override;
    // modern calendar
    procedure DrawModernCalendarDateCellSelection(ACanvas: TcxCanvas; const ARect: TRect; AStates: TcxCalendarElementStates); override;
    function GetModernCalendarHeaderTextColor(AStates: TcxCalendarElementStates): TColor; override;
    // Find Panel
    procedure DrawFindPanelBorder(ACanvas: TcxCanvas; const R: TRect;
      const ABorders: TcxBorders; AScaleFactor, ABordersScaleFactor: TdxScaleFactor); override;
    //WheelPicker
    procedure DrawWheelPickerItemBackground(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState); override;
    procedure DrawWheelPickerItemBorder(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState); override;

    // TokenEdit
    procedure DrawScaledTokenBackground(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); override;

    // ListView
    procedure DrawListViewBackground(ACanvas: TcxCustomCanvas; ABounds: TRect; AExplorerStyle, AEnabled: Boolean); override;
    procedure DrawListViewFocusRect(ACanvas: TcxCustomCanvas; const ABounds: TRect; AExplorerStyle, AHot, AInactive: Boolean);
    procedure DrawListViewGroupExpandButton(ACanvas: TcxCustomCanvas; const ABounds: TRect;
      AState: TcxButtonState; AExpanded: Boolean; AExplorerStyle: Boolean; AScaleFactor: TdxScaleFactor); override;
    procedure DrawListViewGroupHeaderBackground(ACanvas: TcxCustomCanvas; const ABounds: TRect;
      AState: TdxListViewGroupHeaderStates; AExplorerStyle: Boolean; AScaleFactor: TdxScaleFactor); override;
    procedure DrawListViewGroupHeaderLine(ACanvas: TcxCustomCanvas; const ABounds: TRect); override;
    procedure DrawListViewItemBackground(ACanvas: TcxCustomCanvas; const ABounds: TRect; AState: TdxListViewItemStates; AExplorerStyle: Boolean); override;
    procedure DrawListViewSortingMark(ACanvas: TcxCustomCanvas; const R: TRect; AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor); override;
    function GetListViewColumnHeaderSortingMarkSize(AScaleFactor: TdxScaleFactor): TPoint; override;
    function GetListViewColumnHeaderTextColor(AState: TcxButtonState; AExplorerStyle: Boolean): TColor; override;
    function GetListViewItemTextColor(AState: TdxListViewItemStates; AExplorerStyle: Boolean): TColor; override;
    function GetListViewGroupTextColor(AKind: TdxListViewGroupTextKind; AState: TdxListViewGroupHeaderStates; AExplorerStyle: Boolean): TColor; override;

    // SpreadSheet
    procedure DrawSpreadSheetScaledHeader(ACanvas: TcxCustomCanvas; const R: TRect; ANeighbors: TcxNeighbors;
      ABorders: TcxBorders; AState: TcxButtonState; AScaleFactor: TdxScaleFactor); override;
  end;

  TcxCustomLookAndFeelPainterList = TdxObjectList<TcxCustomLookAndFeelPainter>; //for internal use

  { TcxLookAndFeelPaintersManager }

  TcxLookAndFeelPaintersManager = class //for internal use
  strict private
    FListeners: TInterfaceList;
    FLockCount: Integer;
    FPainters: TcxObjectList;
    FStandardPainters: array[TcxLookAndFeelStyle] of TcxCustomLookAndFeelPainter;

    function GetCount: Integer;
    function GetItem(AIndex: Integer): TcxCustomLookAndFeelPainter;
    class function CompareProc(AItem1, AItem2: TcxCustomLookAndFeelPainter): Integer; static;
  protected
    procedure DoPainterAdded(APainter: TcxCustomLookAndFeelPainter);
    procedure DoPainterRemoved(APainter: TcxCustomLookAndFeelPainter);
    procedure DoRootLookAndFeelChanged;
    procedure ReleaseImageResources;
    procedure SortPainters;
    //
    property Listeners: TInterfaceList read FListeners;
    property Painters: TcxObjectList read FPainters;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure AddListener(const AListener: IcxLookAndFeelPainterListener);
    procedure RemoveListener(const AListener: IcxLookAndFeelPainterListener);

    procedure BeginUpdate;
    procedure CancelUpdate;
    procedure EndUpdate;

    function GetPainter(AStyle: TcxLookAndFeelStyle): TcxCustomLookAndFeelPainter; overload;
    function GetPainter(AStyle: TcxLookAndFeelStyle; out APainter: TcxCustomLookAndFeelPainter): Boolean; overload;
    function GetPainter(const AName: string): TcxCustomLookAndFeelPainter; overload;
    function GetPainter(const AName: string; out APainter: TcxCustomLookAndFeelPainter): Boolean; overload;

    procedure PopulateSkinNames(AList: TStrings);

    function Register(APainter: TcxCustomLookAndFeelPainter): Boolean;
    function Unregister(const AName: string): Boolean;
    //
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TcxCustomLookAndFeelPainter read GetItem; default;
  end;

var
  cxContainerBorderWidths: array [TcxContainerBorderStyle] of Integer = (0, 1, 2, 2, 2, 1, 1);
  cxEditStateColorKindMap: array[Boolean] of TcxEditStateColorKind = (esckDisabled, esckNormal);

function cxDataRowFixingImages: TcxImageList;
function cxIndicatorImages: TCustomImageList;
function cxLookAndFeelPaintersManager: TcxLookAndFeelPaintersManager;

function BtnStateToXPBtnState(AState: TcxButtonState): Integer;

procedure PrepareRadioButtonImageList(AScaleFactor: TdxScaleFactor);
procedure UpdateScrollBarBitmaps;

procedure dxAdjustToTouchableSize(var AElementSizeDimension: Integer; AScaleFactor: TdxScaleFactor = nil); overload;
procedure dxAdjustToTouchableSize(var AElementSize: TSize; AScaleFactor: TdxScaleFactor = nil); overload;
function dxGetTouchableSize(AElementSizeDimension: Integer; AScaleFactor: TdxScaleFactor = nil): Integer; overload;
function dxGetTouchableSize(const AElementSize: TSize; AScaleFactor: TdxScaleFactor = nil): TSize; overload;
function cxGetSchedulerGroupPolygon(const R: TRect): TPoints;
function cxGetSchedulerMilestonePolygon(const R: TRect): TPoints;
function cxTextRect(const R: TRect): TRect;
function dxElementSizeFitsForTouch(AElementSizeDimension: Integer): Boolean; overload;
function dxElementSizeFitsForTouch(AElementSizeDimension: Integer; AScaleFactor: TdxScaleFactor): Boolean; overload;
procedure dxRotateSizeGrip(ACanvas: TcxCanvas; const ARect: TRect;
  ABackgroundColor: TColor; ACorner: TdxCorner; AOnDrawSizeGrip: TdxDrawEvent); overload;
procedure dxRotateSizeGrip(ACanvas: TcxCanvas; const ARect: TRect; AScaleFactor: TdxScaleFactor;
  ABackgroundColor: TColor; ACorner: TdxCorner; AOnDrawSizeGrip: TdxDrawScaledRectEvent); overload;
procedure dxInitBordersScaleFactor(AScaleFactor: TdxScaleFactor; var ABordersScaleFactor: TdxScaleFactor); // for internal use

implementation

{$R cxLookAndFeelPainters.res}
{$R cxLookAndFeelPainters_svg.res}

uses
  Messages,
  SysUtils, cxControls, cxLookAndFeels, Math, cxDrawTextUtils, dxSkinsCore, cxLibraryStrs,
  dxDPIAwareUtils, dxTypeHelpers, cxEditUtils;

const
  dxThisUnitName = 'cxLookAndFeelPainters';

const
  FilterDropDownButtonWidth = 15;

  SortingMarkAreaWidth = 16;
  SortingTouchableMarkAreaWidth = 20;

  FilterActiveButtonWidth = 13;
  FilterActiveButtonHeight = 13;
  FilterCloseButtonWidth = 16;
  FilterCloseButtonHeight = 14;
  ZoomButtonWidth = 15;
  ZoomButtonHeight = 15;

  ActiveFilterButtonArrowColor = clBlue;
  cxEditPopupClientEdgeWidthA: array[TcxEditPopupBorderStyle] of Integer =
    (0, 2, 2, 1);
  cxEditPopupWindowFrameWidthA: array[TcxEditPopupBorderStyle] of Integer =
    (0, 1, 4, 2);

  BreadcrumbButtonStateToButtonState: array[TdxBreadcrumbEditButtonState] of TcxButtonState =
    (cxbsNormal, cxbsNormal, cxbsHot, cxbsPressed, cxbsDisabled);

  TrackBarThumbThemeParts: array[TcxTrackBarTicksAlign, Boolean] of Byte = (
    (TKP_THUMBLEFT, TKP_THUMBTOP),
    (TKP_THUMBRIGHT, TKP_THUMBBOTTOM),
    (TKP_THUMBVERT, TKP_THUMB)
  );

type
  { TSystemPaletteChangedNotifier }

  TSystemPaletteChangedNotifier = class(TcxSystemPaletteChangedNotifier)
  protected
    procedure DoChanged; override;
  end;

  { TcxRadioButtonImageList }

  TcxRadioButtonImageList = class
  strict private
    FButtonMask: TBitmap;
    FList: TImageList;
    FRadioButtonCheckRect: TRect;
    FRadioButtonImageListIndexes: array of Integer;
    FRadioButtonPattern: array of array of Integer;
    FRadioButtonRect: TRect;
    FRadioButtonSize: TSize;
    FScaleFactor: TdxScaleFactor;

    procedure CalculateRadioButtonSize;
    function GetImageIndex(ALookAndFeelKind: TcxLookAndFeelKind;
      AButtonState: TcxButtonState; AChecked, AFocused, AIsDesigning: Boolean): Integer;
    function GetImageListIndexMapIndex(ALookAndFeelKind: TcxLookAndFeelKind;
      AButtonState: TcxButtonState; AChecked, AFocused, AIsDesigning: Boolean): Integer;
    procedure Initialize;
    procedure PrepareButtonMask;
    procedure PrepareRadioButtonPattern;
    procedure Reinitialize;

    procedure SetScaleFactor(AScaleFactor: TdxScaleFactor);
  public
    constructor Create(AScaleFactor: TdxScaleFactor);
    destructor Destroy; override;
    procedure Draw(ACanvas: TcxCanvas; X, Y: Integer; ABrushColor: TColor;
      ALookAndFeelKind: TcxLookAndFeelKind; AButtonState: TcxButtonState; AChecked, AFocused, AIsDesigning: Boolean);
    function GetSize: TSize;
    procedure Prepare;
    procedure Reset;

    property ScaleFactor: TdxScaleFactor read FScaleFactor write SetScaleFactor;
  end;

  { TcxRadioButtonImageListManager }

  TcxRadioButtonImageListManager = class
  strict private
    class var FCache: TDictionary<Integer, TcxRadioButtonImageList>;
  protected
    class procedure Finalize;
    class procedure Reset;
  public
    class function Get(AScaleFactor: TdxScaleFactor): TcxRadioButtonImageList;
  end;

var
  FCheckButtonSize: TSize;
  FDataRowFixingImages: TcxImageList;
  FIndicatorImages: TCustomImageList;
  FLookAndFeelPaintersManager: TcxLookAndFeelPaintersManager = nil;
  FSystemPaletteChangedNotifier: TSystemPaletteChangedNotifier;
  FUnitIsFinalized: Boolean = False;
  StdScrollBrushes: array[Boolean] of TBrush;
  StdScrollBrushBitmaps: array[Boolean] of TBitmap;


{ TcxLookAndFeelPaintersManager }

constructor TcxLookAndFeelPaintersManager.Create;
begin
  inherited Create;
  FPainters := TcxObjectList.Create;
  FListeners := TInterfaceList.Create;
end;

destructor TcxLookAndFeelPaintersManager.Destroy;
begin
  FreeAndNil(FListeners);
  FreeAndNil(FPainters);
  inherited Destroy;
end;

procedure TcxLookAndFeelPaintersManager.AddListener(const AListener: IcxLookAndFeelPainterListener);
begin
  if Listeners.IndexOf(AListener) < 0 then
    Listeners.Add(AListener);
end;

procedure TcxLookAndFeelPaintersManager.DoPainterAdded(APainter: TcxCustomLookAndFeelPainter);
var
  I: Integer;
begin
  FStandardPainters[APainter.LookAndFeelStyle] := APainter;
  if FLockCount = 0 then
    DoRootLookAndFeelChanged;
  for I := Listeners.Count - 1 downto 0 do
    IcxLookAndFeelPainterListener(Listeners[I]).PainterAdded(APainter);
end;

procedure TcxLookAndFeelPaintersManager.DoPainterRemoved(APainter: TcxCustomLookAndFeelPainter);
var
  I: Integer;
begin
  FStandardPainters[APainter.LookAndFeelStyle] := nil;
  if FLockCount = 0 then
    DoRootLookAndFeelChanged;
  for I := Listeners.Count - 1 downto 0 do
    IcxLookAndFeelPainterListener(Listeners[I]).PainterRemoved(APainter);
end;

procedure TcxLookAndFeelPaintersManager.DoRootLookAndFeelChanged;
begin
  if IsRootLookAndFeelAssigned then
    RootLookAndFeel.Refresh;
end;

procedure TcxLookAndFeelPaintersManager.PopulateSkinNames(AList: TStrings);
var
  APainter: TcxCustomLookAndFeelPainter;
  I: Integer;
begin
  AList.BeginUpdate;
  try
    if Assigned(GetSkinNamesProc) then
      GetSkinNamesProc(AList)
    else
      for I := 0 to Count - 1 do
      begin
        APainter := Items[I];
        if APainter.LookAndFeelStyle = lfsSkin then
          AList.Add(APainter.LookAndFeelName);
      end;
  finally
    AList.EndUpdate;
  end;
end;

function TcxLookAndFeelPaintersManager.GetPainter(AStyle: TcxLookAndFeelStyle): TcxCustomLookAndFeelPainter;
begin
  Result := FStandardPainters[AStyle];
end;

function TcxLookAndFeelPaintersManager.GetPainter(AStyle: TcxLookAndFeelStyle; out APainter: TcxCustomLookAndFeelPainter): Boolean;
begin
  APainter := FStandardPainters[AStyle];
  Result := APainter <> nil;
end;

function TcxLookAndFeelPaintersManager.GetPainter(const AName: string; out APainter: TcxCustomLookAndFeelPainter): Boolean;
var
  I: Integer;
begin
  Result := False;

  for I := 0 to Count - 1 do
    if SameText(Items[I].LookAndFeelName, AName) then
    begin
      APainter := Items[I];
      Result := True;
      Break;
    end;
end;

function TcxLookAndFeelPaintersManager.GetPainter(const AName: string): TcxCustomLookAndFeelPainter;
begin
  if not GetPainter(AName, Result) then
    Result := nil;
end;

function TcxLookAndFeelPaintersManager.Register(APainter: TcxCustomLookAndFeelPainter): Boolean;
begin
  Result := GetPainter(APainter.LookAndFeelName) = nil;
  if Result then
  begin
    FPainters.Add(APainter);
    SortPainters;
    DoPainterAdded(APainter);
  end
  else
    APainter.Free;
end;

procedure TcxLookAndFeelPaintersManager.RemoveListener(const AListener: IcxLookAndFeelPainterListener);
begin
  Listeners.Remove(AListener);
end;

procedure TcxLookAndFeelPaintersManager.BeginUpdate;
begin
  Inc(FLockCount);
end;

procedure TcxLookAndFeelPaintersManager.CancelUpdate;
begin
  Dec(FLockCount);
end;

procedure TcxLookAndFeelPaintersManager.EndUpdate;
begin
  Dec(FLockCount);
  if FLockCount = 0 then
    DoRootLookAndFeelChanged;
end;

procedure TcxLookAndFeelPaintersManager.ReleaseImageResources;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].ReleaseImageResources;
end;

procedure TcxLookAndFeelPaintersManager.SortPainters;
begin
  FPainters.Sort(TListSortCompare(@CompareProc));
end;

function TcxLookAndFeelPaintersManager.Unregister(const AName: string): Boolean;
var
  APainter: TcxCustomLookAndFeelPainter;
begin
  Result := GetPainter(AName, APainter);
  if Result then
  try
    FPainters.Remove(APainter);
    DoPainterRemoved(APainter);
  finally
    APainter.Free;
  end;
end;

function TcxLookAndFeelPaintersManager.GetCount: Integer;
begin
  Result := FPainters.Count;
end;

function TcxLookAndFeelPaintersManager.GetItem(AIndex: Integer): TcxCustomLookAndFeelPainter;
begin
  Result := TcxCustomLookAndFeelPainter(FPainters[AIndex]);
end;

class function TcxLookAndFeelPaintersManager.CompareProc(AItem1, AItem2: TcxCustomLookAndFeelPainter): Integer;
begin
  Result := AnsiCompareStr(AItem1.LookAndFeelName, AItem2.LookAndFeelName);
end;

{ TcxOffice11LookAndFeelPainter }

function TcxOffice11LookAndFeelPainter.LookAndFeelName: string;
begin
  Result := 'Office11';
end;

function TcxOffice11LookAndFeelPainter.LookAndFeelStyle: TcxLookAndFeelStyle;
begin
  Result := lfsOffice11;
end;

function TcxOffice11LookAndFeelPainter.NeedRedrawOnResize: Boolean;
begin
  Result := True;
end;

function TcxOffice11LookAndFeelPainter.DefaultControlColor: TColor;
begin
  Result := dxOffice11DockColor2;
end;

function TcxOffice11LookAndFeelPainter.DefaultControlTextColor: TColor;
begin
  Result := dxOffice11TextEnabledColor;
end;

function TcxOffice11LookAndFeelPainter.DefaultDateNavigatorHeaderColor: TColor;
begin
  Result := dxOffice11DockColor1;
end;

function TcxOffice11LookAndFeelPainter.DefaultDateNavigatorSelectionColor: TColor;
begin
  Result := dxOffice11DayNavigatorSelectedColor;
end;

function TcxOffice11LookAndFeelPainter.DefaultDateNavigatorSelectionTextColor: TColor;
begin
  Result := clWindowText;
end;

function TcxOffice11LookAndFeelPainter.DefaultFilterBoxColor: TColor;
begin
  Result := dxOffice11BarFloatingBorderColor1;
end;

function TcxOffice11LookAndFeelPainter.DefaultFilterBoxTextColor: TColor;
begin
  Result := dxOffice11BarFloatingCaptionTextColor1;
end;

function TcxOffice11LookAndFeelPainter.DefaultFooterColor: TColor;
begin
  Result := dxOffice11DockColor1;  //DefaultHeaderColor;
end;

function TcxOffice11LookAndFeelPainter.DefaultFooterTextColor: TColor;
begin
  Result := DefaultHeaderTextColor;
end;

function TcxOffice11LookAndFeelPainter.DefaultGroupColor: TColor;
begin
  Result := dxOffice11GroupColor;
end;

function TcxOffice11LookAndFeelPainter.DefaultGroupByBoxColor: TColor;
begin
  Result := dxOffice11InPlaceSubItemColor{dxOffice11DockColor2};
end;

function TcxOffice11LookAndFeelPainter.DefaultGroupByBoxTextColor: TColor;
begin
  Result := dxOffice11ToolbarsColor1{dxOffice11TextEnabledColor};
end;

function TcxOffice11LookAndFeelPainter.DefaultHeaderColor: TColor;
begin
  Result := HeaderTopColor;  //dxOffice11DockColor1;
end;

function TcxOffice11LookAndFeelPainter.DefaultHeaderBackgroundColor: TColor;
begin
  Result := DefaultGroupByBoxColor;
end;

function TcxOffice11LookAndFeelPainter.DefaultSchedulerBorderColor: TColor;
begin
  Result := dxOffice11OutlookBorderColor;
end;

function TcxOffice11LookAndFeelPainter.DefaultSchedulerControlColor: TColor;
begin
  Result := dxOffice11OutlookControlColor;
end;

function TcxOffice11LookAndFeelPainter.DefaultSchedulerDayHeaderColor: TColor;
begin
  Result := DefaultHeaderColor;
end;

function TcxOffice11LookAndFeelPainter.DefaultTabColor: TColor;
begin
  Result := dxOffice11DockColor2;
end;

function TcxOffice11LookAndFeelPainter.DefaultTabsBackgroundColor: TColor;
begin
  Result := DefaultTabColor;
end;

function TcxOffice11LookAndFeelPainter.DefaultTimeGridMinorScaleColor: TColor;
begin
  Result := dxOffice11DockColor1;
end;

function TcxOffice11LookAndFeelPainter.DefaultTimeGridSelectionBarColor: TColor;
begin
  Result := DefaultSchedulerControlColor;
end;

function TcxOffice11LookAndFeelPainter.SeparatorSize: Integer;
begin
  Result := 2;
end;

function TcxOffice11LookAndFeelPainter.BorderHighlightColor: TColor;
begin
  Result := dxOffice11SelectedBorderColor;
end;

procedure TcxOffice11LookAndFeelPainter.DrawBorder(ACanvas: TcxCustomCanvas; R: TRect; AWidth: Integer = 1);
begin
  ACanvas.FrameRect(R, dxOffice11ControlBorderColor);
end;

procedure TcxOffice11LookAndFeelPainter.DoDrawSeparator(ACanvas: TcxCustomCanvas; R: TRect; AIsVertical: Boolean);
begin
  Dec(R.Right);
  Dec(R.Bottom);
  ACanvas.FillRect(R, dxOffice11BarSeparatorColor1);
  OffsetRect(R, 1, 1);
  ACanvas.FillRect(R, dxOffice11BarSeparatorColor2);
end;

function TcxOffice11LookAndFeelPainter.GetBevelMinimalShapeSize(AShape: TdxBevelShape): TSize;
begin
  Result.Init(2);
end;

procedure TcxOffice11LookAndFeelPainter.GetBevelShapeColors(out AColor1, AColor2: TColor);
begin
  AColor1 := dxOffice11BarSeparatorColor1;
  AColor2 := dxOffice11BarSeparatorColor2;
end;

function TcxOffice11LookAndFeelPainter.ScaledClockSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  Result := AScaleFactor.Apply(ClockFace.Size);
end;

procedure TcxOffice11LookAndFeelPainter.DrawScaledClock(ACanvas: TcxCanvas; const ARect: TRect;
  ADateTime: TDateTime; ABackgroundColor: TColor; AScaleFactor: TdxScaleFactor);
begin
  DrawModernCalendarClock(ACanvas, ARect, ADateTime, ABackgroundColor, AScaleFactor);
end;

function TcxOffice11LookAndFeelPainter.RichEditControlHeaderFooterLineColor: TColor;
begin
  Result := dxOffice11DockColor1;
end;

function TcxOffice11LookAndFeelPainter.RichEditControlHeaderFooterMarkBackColor: TColor;
begin
  Result := dxOffice11DockColor2;
end;

function TcxOffice11LookAndFeelPainter.RichEditRulerInactiveAreaColor: TColor;
begin
  Result := dxOffice11DockColor1;
end;

function TcxOffice11LookAndFeelPainter.RichEditRulerTabTypeToggleBorderColor: TColor;
begin
  Result := dxOffice11DropDownBorderColor1;
end;

procedure TcxOffice11LookAndFeelPainter.DrawScaledTokenBackground(
  ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);

  procedure GetColors(out AColor1, AColor2: TColor);
  begin
    case AState of
      cxbsHot:
        begin
          AColor1 := dxOffice11SelectedColor1;
          AColor2 := dxOffice11SelectedColor2;
        end;
      cxbsPressed:
        begin
          AColor1 := dxOffice11DownedColor;
          AColor2 := dxOffice11SelectedColor1;
        end;
      else
      begin
        AColor1 := clNone;
        AColor2 := AColor1;
      end;
    end;
  end;

var
  AColor1, AColor2: TColor;
begin
  ACanvas.FrameRect(R, dxOffice11ControlBorderColor, 1);
  GetColors(AColor1, AColor2);
  if cxColorIsValid(AColor1) and cxColorIsValid(AColor2) then
    Office11FillTubeGradientRect(ACanvas.Handle, cxRectInflate(R, -1), AColor1, AColor2, False);
end;

procedure TcxOffice11LookAndFeelPainter.DrawSpreadSheetScaledHeader(ACanvas: TcxCustomCanvas; const R: TRect;
  ANeighbors: TcxNeighbors; ABorders: TcxBorders; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
var
  AColor: TColor;
begin
  DrawHeaderBorder(ACanvas, R, ANeighbors, ABorders);

  case AState of
    cxbsHot:
      AColor := dxOffice11SelectedColor1;
    cxbsPressed:
      AColor := dxOffice11SelectedColor2;
  else
    AColor := DefaultHeaderColor;
  end;

  ACanvas.FillRect(HeaderContentBounds(R, ABorders), AColor);
end;

function TcxOffice11LookAndFeelPainter.ButtonColor(AState: TcxButtonState): TColor;
begin
  case AState of
    cxbsHot:
      Result := dxOffice11SelectedColor1;
    cxbsPressed:
      Result := dxOffice11SelectedDownColor1;
    cxbsDisabled:
      Result := {dxOffice11ToolbarsColor2}clBtnFace;
  else
    Result := dxOffice11DockColor1{inherited ButtonColor(AState)};
  end;
end;

function TcxOffice11LookAndFeelPainter.ButtonSymbolColor(
  AState: TcxButtonState; ADefaultColor: TColor; APart: TcxButtonPart): TColor;
begin
  if (AState = cxbsPressed) and not IsXPStandardScheme then
    Result := clHighlightText
  else
    if AState = cxbsDisabled then
      Result := dxOffice11TextDisabledColor
    else
      Result := dxOffice11TextEnabledColor;
end;

procedure TcxOffice11LookAndFeelPainter.DrawButtonBorder(ACanvas: TcxCustomCanvas; R: TRect; AState: TcxButtonState);

  function GetBorderColor: TColor;
  begin
    case AState of
      cxbsNormal:
        Result := clBtnText;
      cxbsDisabled:
        Result := dxOffice11TextDisabledColor;
    else
      Result := dxOffice11SelectedBorderColor;
    end;
  end;

begin
  if AState = cxbsDefault then
    inherited
  else
    ACanvas.FrameRect(R, GetBorderColor);
end;

procedure TcxOffice11LookAndFeelPainter.DrawScaledExpandButton(
  ACanvas: TcxCustomCanvas; const R: TRect; AExpanded: Boolean;
  AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault; AState: TcxExpandButtonState = cebsNormal);
begin
  ACanvas.DrawNativeObject(R,
    TcxCanvasBasedResourceCacheKey.Create(Self, TSize.Create(R), Ord(AExpanded), 0, AScaleFactor.TargetDPI),
    procedure (ACanvas: TcxGdiBasedCanvas; const R: TRect)
    var
      ABitmap: TBitmap;
    begin
      if AExpanded then
        ABitmap := dxOffice11ExpandButtonBitmap1
      else
        ABitmap := dxOffice11ExpandButtonBitmap2;

      TdxImageDrawer.DrawImage(ACanvas, R, ABitmap, ifmProportionalStretch, nil, AScaleFactor);
    end);
end;

function TcxOffice11LookAndFeelPainter.DrawExpandButtonFirst: Boolean;
begin
  Result := False;
end;

procedure TcxOffice11LookAndFeelPainter.DrawScaledSmallExpandButton(ACanvas: TcxCanvas;
  R: TRect; AExpanded: Boolean; ABorderColor: TColor; AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault);
begin
  DrawScaledExpandButton(ACanvas, R, AExpanded, AScaleFactor, AColor);
end;

function TcxOffice11LookAndFeelPainter.ScaledExpandButtonSize(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := AScaleFactor.Apply(11);
end;

function TcxOffice11LookAndFeelPainter.ScaledSmallExpandButtonSize(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := ScaledExpandButtonSize(AScaleFactor);
end;

function TcxOffice11LookAndFeelPainter.CheckButtonColor(AState: TcxButtonState; ACheckState: TcxCheckBoxState): TColor;
begin
  case AState of
    cxbsHot, cxbsPressed, cxbsDisabled:
      Result := ButtonColor(AState);
  else
    Result := inherited CheckButtonColor(AState, ACheckState);
  end;
end;

function TcxOffice11LookAndFeelPainter.RadioButtonBodyColor(AState: TcxButtonState): TColor;
begin
  if AState = cxbsNormal then
    Result := clWindow
  else
    Result := ButtonColor(AState)
end;

procedure TcxOffice11LookAndFeelPainter.DrawScaledFilterDropDownButton(
  ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AIsFilterActive: Boolean; AScaleFactor: TdxScaleFactor);

  function GetArrowColor: TColor;
  begin
    if AIsFilterActive then
      Result := ActiveFilterButtonArrowColor
    else
      Result := ButtonSymbolColor(AState);
  end;

begin
//  inherited;
  ACanvas.FrameRect(R, FilterDropDownButtonBorderColor(AState));
  InflateRect(R, -1, -1);
  ACanvas.Brush.Color := ButtonColor(AState);
  ACanvas.FillRect(R);
  DrawButtonArrow(ACanvas, R, GetArrowColor);
end;

procedure TcxOffice11LookAndFeelPainter.DrawContentBackground(ACanvas: TcxCustomCanvas;
  const R: TRect; AState: TcxButtonState; ABackgroundColor: TColor; AIsFooter: Boolean);
var
  AColor1, AColor2: TColor;
begin
  if AState = cxbsHot then
  begin
    AColor1 := dxOffice11ToolbarsColor1;
    AColor2 := dxOffice11ToolbarsColor1;
  end
  else
  begin
    AColor1 := HeaderTopColor;
    AColor2 := HeaderBottomColor;
  end;

  if AIsFooter then
    ACanvas.FillRect(R, AColor1)
  else
  begin
    ACanvas.FillRect(Rect(R.Left, R.Top, R.Right, R.Bottom - 3), AColor1);
    ACanvas.FillRectByGradient(Rect(R.Left, R.Bottom - 4, R.Right, R.Bottom), AColor1, AColor2, False);
  end;

  if AState = cxbsHot then
    ACanvas.FillRectByGradient(Rect(R.Left - 1, R.Bottom - 2, R.Right, R.Bottom + 1),
      dxOffice11SelectedColor1, dxOffice11SelectedColor2, False);
end;

procedure TcxOffice11LookAndFeelPainter.DrawScaledHeader(ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect;
  ANeighbors: TcxNeighbors; ABorders: TcxBorders; AState: TcxButtonState; AAlignmentHorz: TAlignment;
  AAlignmentVert: TcxAlignmentVert; AMultiLine, AShowEndEllipsis: Boolean; const AText: string; AFont: TFont;
  ATextColor, ABkColor: TColor; AScaleFactor: TdxScaleFactor; AOnDrawBackground: TcxDrawBackgroundEvent = nil;
  AIsLast: Boolean = False; AInGroupByBox: Boolean = False; ABorderWidth: Integer = 1);
begin
  inherited DrawScaledHeader(ACanvas, ABounds, ATextAreaBounds, ANeighbors, ABorders,
    AState, AAlignmentHorz, AAlignmentVert, AMultiLine, AShowEndEllipsis, AText,
    AFont, ATextColor, ABkColor, dxDefaultScaleFactor, TcxDrawBackgroundEvent(nil), AIsLast, False, ABorderWidth);
end;

procedure TcxOffice11LookAndFeelPainter.DrawHeaderBorder(
  ACanvas: TcxCustomCanvas; const R: TRect; ANeighbors: TcxNeighbors; ABorders: TcxBorders);
var
  AColor1, AColor2: TColor;
  Y1, Y2: Integer;
begin
  AColor1 := HeaderTopColor;
  AColor2 := HeaderBottomColor;

  if bTop in ABorders then
    ACanvas.FillRect(Rect(R.Left, R.Top, R.Right, R.Top + 1), AColor1);

  if bBottom in ABorders then
    ACanvas.FillRect(Rect(R.Left, R.Bottom - 1, R.Right, R.Bottom), HeaderDarkEdgeColor);

  if bLeft in ABorders then
  begin
    ACanvas.FillPixel(R.Left, R.Top + 1, AColor1);
    if nLeft in ANeighbors then
    begin
      Y1 := R.Top + 2;
      Y2 := R.Bottom - 3;
      ACanvas.FillPixel(R.Left, Y1, AColor1);
      ACanvas.FillPixel(R.Left, Y2, dxGetMiddleRGB(AColor1, AColor2, 25));
      ACanvas.FillPixel(R.Left, R.Bottom - 2, AColor2);
    end
    else
    begin
      Y1 := R.Top + 1;
      Y2 := R.Bottom - 2;
      ACanvas.FillPixel(R.Left, R.Bottom - 2, AColor2);
    end;
    ACanvas.FillRect(Rect(R.Left, Y1, R.Left + 1, Y2), HeaderHighlightEdgeColor);
  end;

  if bRight in ABorders then
  begin
    if nRight in ANeighbors then
    begin
      Y1 := R.Top + 2;
      Y2 := R.Bottom - 3;
      ACanvas.FillPixel(R.Right - 1, R.Top + 1, AColor1);
      ACanvas.FillPixel(R.Right - 1, Y1, AColor1);
      ACanvas.FillPixel(R.Right - 1, Y2, dxGetMiddleRGB(AColor1, AColor2, 25));
      ACanvas.FillPixel(R.Right - 1, R.Bottom - 2, AColor2);
    end
    else
    begin
      Y1 := R.Top + 1;
      ACanvas.FillPixel(R.Right - 1, R.Top, dxGetMiddleRGB(AColor1, HeaderDarkEdgeColor, 50));
      Y2 := R.Bottom - 2;
      ACanvas.FillPixel(R.Right - 1, R.Bottom - 2, dxGetMiddleRGB(AColor2, HeaderDarkEdgeColor, 50));
    end;
    ACanvas.FillRect(Rect(R.Right - 1, Y1, R.Right, Y2), HeaderDarkEdgeColor);
  end;
end;

procedure TcxOffice11LookAndFeelPainter.DrawScaledHeaderControlSection(
  ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect;
  ANeighbors: TcxNeighbors; ABorders: TcxBorders; AState: TcxButtonState;
  AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert; AMultiLine,
  AShowEndEllipsis: Boolean; const AText: string; AFont: TFont; ATextColor,
  ABkColor: TColor; AScaleFactor: TdxScaleFactor);
begin
  DrawScaledHeader(ACanvas, ABounds, ATextAreaBounds, [nRight], ABorders, AState, AAlignmentHorz, AAlignmentVert, AMultiLine,
    AShowEndEllipsis, AText, AFont, ATextColor, ABkColor, AScaleFactor);
  if AState = cxbsPressed then
    DrawHeaderPressed(ACanvas, ABounds);
end;

procedure TcxOffice11LookAndFeelPainter.DrawScaledSortingMark(
  ACanvas: TcxCanvas; const R: TRect; AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor);
begin
  DrawSortingArrow(ACanvas, R, HeaderDarkEdgeColor, HeaderHighlightEdgeColor, AAscendingSorting, AScaleFactor);
end;

procedure TcxOffice11LookAndFeelPainter.DrawScaledSummarySortingMark(
  ACanvas: TcxCanvas; const R: TRect; AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor);
begin
  DrawSummarySortingArrow(ACanvas, R, HeaderDarkEdgeColor, HeaderHighlightEdgeColor, AAscendingSorting, AScaleFactor);
end;

function TcxOffice11LookAndFeelPainter.HeaderBorders(ANeighbors: TcxNeighbors): TcxBorders;
begin
  Result := cxBordersAll;
end;

function TcxOffice11LookAndFeelPainter.HeaderBorderSize: Integer;
begin
  Result := 1;
end;

function TcxOffice11LookAndFeelPainter.IncludeTopBorderToSectionHeaderForLightBorders: Boolean;
begin
  Result := True;
end;

function TcxOffice11LookAndFeelPainter.IsHeaderHotTrack: Boolean;
begin
  Result := True;
end;

function TcxOffice11LookAndFeelPainter.FooterBorders: TcxBorders;
begin
  Result := inherited;
end;

function TcxOffice11LookAndFeelPainter.FooterSeparatorColor: TColor;
begin
  Result := HeaderDarkEdgeColor;
end;

function TcxOffice11LookAndFeelPainter.GridBordersOverlapSize: Integer;
begin
  Result := 0;
end;

procedure TcxOffice11LookAndFeelPainter.LayoutViewDrawScaledRecordCaption(ACanvas: TcxCanvas; const ABounds, ATextRect: TRect;
  APosition: TcxGroupBoxCaptionPosition; AState: TcxButtonState; AScaleFactor: TdxScaleFactor;
  AColor: TColor = clDefault; const ABitmap: TBitmap = nil);
begin
  LayoutViewDrawRecordBorder(ACanvas, ABounds, AState, cxBordersAll);
  DrawContent(ACanvas, ABounds, cxEmptyRect, AState, taLeftJustify,
    vaTop, False, False, '', nil, clDefault, clDefault, nil, APosition = cxgpTop);
end;

function TcxOffice11LookAndFeelPainter.ScaledScrollBarMinimalThumbSize(AVertical: Boolean;
  AScaleFactor: TdxScaleFactor): Integer;
var
  APainter: TcxCustomLookAndFeelPainter;
begin
  if cxLookAndFeelPaintersManager.GetPainter(lfsNative, APainter) then
    Result := APainter.ScaledScrollBarMinimalThumbSize(AVertical, AScaleFactor)
  else
    Result := inherited ScaledScrollBarMinimalThumbSize(AVertical, AScaleFactor);
end;

procedure TcxOffice11LookAndFeelPainter.DoDrawSizeGrip(ACanvas: TcxCanvas; const ARect: TRect; AScaleFactor: TdxScaleFactor);
begin
  Office11DrawSizeGrip(ACanvas.Handle, ARect, clDefault, clDefault, AScaleFactor);
end;

procedure TcxOffice11LookAndFeelPainter.DrawScaledMonthHeader(ACanvas: TcxCanvas; const ABounds: TRect;
  const AText: string; ANeighbors: TcxNeighbors; const AViewParams: TcxViewParams; AArrows: TcxArrowDirections;
  ASideWidth: Integer; AScaleFactor: TdxScaleFactor; AOnDrawBackground: TcxDrawBackgroundEvent = nil);
var
  R: TRect;
begin
  R := ABounds;
  R.Inflate(-1, -1);
  with ACanvas do
  begin
    if not Assigned(AOnDrawBackground) or not AOnDrawBackground(ACanvas, R) then
      FillRect(R, AViewParams);
    if AText <> '' then
    begin
      Brush.Style := bsClear;
      Font := AViewParams.Font;
      Font.Color := AViewParams.TextColor;
      DrawText(AText, R, cxAlignCenter or cxSingleLine);
      Brush.Style := bsSolid;
    end;
  end;
  DrawMonthHeaderArrows(ACanvas, ABounds, AArrows, ASideWidth, clWindowText);
end;

procedure TcxOffice11LookAndFeelPainter.DrawSchedulerNavigationButtonContent(
  ACanvas: TcxCanvas; const ARect: TRect; const AArrowRect: TRect;
  AIsNextButton: Boolean; AState: TcxButtonState; const AIsVertical: Boolean = True);
const
  Borders: array[Boolean, Boolean] of TcxBorders = (
    ([bLeft, bRight, bBottom], [bLeft, bTop, bRight]),
    ([bRight, bTop, bBottom], [bLeft, bTop, bBottom]) );
var
  ABackgroundColor: TColor;
begin
  case AState of
    cxbsPressed:
      ABackgroundColor := dxOffice11SelectedDownColor1;
    cxbsHot:
      ABackgroundColor := dxOffice11SelectedColor1;
    else
      ABackgroundColor := dxOffice11DockColor1;
  end;
  ACanvas.FillRect(ARect, ABackgroundColor);
  ACanvas.DrawComplexFrame(ARect, dxOffice11OutlookBorderColor,
    dxOffice11OutlookBorderColor, Borders[AIsVertical, AIsNextButton]);
  DrawSchedulerNavigationButtonArrow(ACanvas, AArrowRect, AIsNextButton,
    ButtonSymbolColor(AState), AIsVertical);
end;

procedure TcxOffice11LookAndFeelPainter.DrawSchedulerScaledNavigatorButton(
  ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
var
  APainter: TcxCustomLookAndFeelPainter;
begin
  if cxLookAndFeelPaintersManager.GetPainter(lfsNative, APainter) then
    APainter.DrawSchedulerScaledNavigatorButton(ACanvas, R, AState, AScaleFactor)
  else
    inherited DrawSchedulerScaledNavigatorButton(ACanvas, R, AState, AScaleFactor);
end;

procedure TcxOffice11LookAndFeelPainter.DrawSchedulerBorder(
  ACanvas: TcxCanvas; R: TRect);
begin
  ACanvas.FrameRect(R, DefaultSchedulerBorderColor);
end;

function TcxOffice11LookAndFeelPainter.DefaultDateNavigatorHeaderHighlightTextColor: TColor;
begin
  Result := clHighlightText;
end;

function TcxOffice11LookAndFeelPainter.GetDefaultFixedColumnHighlightAAlpha: Byte;
begin
  Result := 30;
end;

function TcxOffice11LookAndFeelPainter.HeaderBottomColor: TColor;
begin
  Result := dxOffice11ToolbarsColor2;
end;

function TcxOffice11LookAndFeelPainter.HeaderDarkEdgeColor: TColor;
begin
  Result := dxOffice11BarSeparatorColor1;
end;

function TcxOffice11LookAndFeelPainter.HeaderHighlightEdgeColor: TColor;
begin
  Result := dxOffice11BarSeparatorColor2;
end;

function TcxOffice11LookAndFeelPainter.HeaderTopColor: TColor;
begin
  Result := dxGetMiddleRGB(dxOffice11ToolbarsColor1, dxOffice11ToolbarsColor2, 50);
end;

procedure TcxOffice11LookAndFeelPainter.DoDrawScaledScrollBarPart(ACanvas: TcxCustomCanvas;
  AHorizontal: Boolean; R: TRect; APart: TcxScrollBarPart; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
var
  APainter: TcxCustomLookAndFeelPainter;
begin
  if cxLookAndFeelPaintersManager.GetPainter(lfsNative, APainter) then
    APainter.DoDrawScaledScrollBarPart(ACanvas, AHorizontal, R, APart, AState, AScaleFactor)
  else
    inherited DoDrawScaledScrollBarPart(ACanvas, AHorizontal, R, APart, AState, AScaleFactor);
end;

function TcxOffice11LookAndFeelPainter.FilterDropDownButtonBorderColor(AState: TcxButtonState): TColor;
begin
  if AState = cxbsNormal then
    Result := HeaderDarkEdgeColor
  else
    Result := dxOffice11SelectedBorderColor;
end;

function TcxOffice11LookAndFeelPainter.TabBorderHighlightColor: TColor;
begin
  Result := HeaderDarkEdgeColor;
end;

function TcxOffice11LookAndFeelPainter.TabBorderDarkColor: TColor;
begin
  Result := inherited TabBorderDarkColor;
end;

function cxDataRowFixingImages: TcxImageList;

  procedure AddImage(ASmartImage: TdxSmartImage; const AResourceName: string);
  begin
    if dxUseVectorIcons then
      ASmartImage.LoadFromResource(HInstance, AResourceName, 'SVG')
    else
      ASmartImage.LoadFromResource(HInstance, AResourceName, 'PNG');
    FDataRowFixingImages.AddMasked(ASmartImage, clDefault);
  end;

var
  ASmartImage: TdxSmartImage;
begin
  if FDataRowFixingImages = nil then
  begin
    FDataRowFixingImages := TcxImageList.CreateSize(16, 16);
    FDataRowFixingImages.SourceDPI := dxDefaultDPI;
    ASmartImage := TdxSmartImage.Create;
    try
      AddImage(ASmartImage, 'CX_DATAROWFIXEDNONE');
      AddImage(ASmartImage, 'CX_DATAROWFIXEDONTOP');
      AddImage(ASmartImage, 'CX_DATAROWFIXEDONBOTTOM');
    finally
      ASmartImage.Free;
    end;
  end;
  Result := FDataRowFixingImages;
end;

function cxIndicatorImages: TCustomImageList;

  procedure AddImage(const AImage: TBitmap; const AResourceName: string);
  begin
    AImage.LoadFromResourceName(HInstance, AResourceName);
    FIndicatorImages.AddMasked(AImage, clWhite);
  end;

  procedure AddVectorImage(const AImage: TdxSmartImage; const AResourceName: string);
  begin
    AImage.LoadFromResource(HInstance, AResourceName, 'SVG');
    (FIndicatorImages as TcxImageList).Add(AImage);
  end;

var
  B: TBitmap;
  ASmartImage: TdxSmartImage;
begin
  if FIndicatorImages = nil then
  begin
    if dxUseVectorIcons then
      FIndicatorImages := TcxImageList.CreateSize(8, 9)
    else
      FIndicatorImages := TImageList.CreateSize(8, 9);
    if dxUseVectorIcons then
    begin
      ASmartImage := TdxSmartImage.Create;
      try
        AddVectorImage(ASmartImage, 'CX_ARROWBITMAP');
        AddVectorImage(ASmartImage, 'CX_EDITBITMAP');
        AddVectorImage(ASmartImage, 'CX_INSERTBITMAP');
        AddVectorImage(ASmartImage, 'CX_MULTIDOTBITMAP');
        AddVectorImage(ASmartImage, 'CX_MULTIARROWBITMAP');
        AddVectorImage(ASmartImage, 'CX_FILTERBITMAP');
        AddVectorImage(ASmartImage, 'CX_INPLACEEDITBITMAP');
        AddVectorImage(ASmartImage, 'CX_SORTBYSUMMARYVALUE');
      finally
        ASmartImage.Free;
      end;
    end
    else
    begin
      B := TBitmap.Create;
      try
        AddImage(B, 'CX_ARROWBITMAP');
        AddImage(B, 'CX_EDITBITMAP');
        AddImage(B, 'CX_INSERTBITMAP');
        AddImage(B, 'CX_MULTIDOTBITMAP');
        AddImage(B, 'CX_MULTIARROWBITMAP');
        AddImage(B, 'CX_FILTERBITMAP');
        AddImage(B, 'CX_INPLACEEDITBITMAP');
        AddImage(B, 'CX_SORTBYSUMMARYVALUE');
      finally
        B.Free;
      end;
    end;
  end;
  Result := FIndicatorImages;
end;

function cxLookAndFeelPaintersManager: TcxLookAndFeelPaintersManager;
begin
  if (FLookAndFeelPaintersManager = nil) and not FUnitIsFinalized then
  begin
    FLookAndFeelPaintersManager := TcxLookAndFeelPaintersManager.Create;
    FLookAndFeelPaintersManager.BeginUpdate;
    try
      FLookAndFeelPaintersManager.Register(TcxFlatLookAndFeelPainter.Create);
      FLookAndFeelPaintersManager.Register(TcxOffice11LookAndFeelPainter.Create);
      FLookAndFeelPaintersManager.Register(TcxStandardLookAndFeelPainter.Create);
      FLookAndFeelPaintersManager.Register(TcxUltraFlatLookAndFeelPainter.Create);
      FLookAndFeelPaintersManager.Register(TcxWinXPLookAndFeelPainter.Create);
    finally
      FLookAndFeelPaintersManager.CancelUpdate;
    end;
  end;
  Result := FLookAndFeelPaintersManager;
end;

function BtnStateToXPBtnState(AState: TcxButtonState): Integer;
const
  ButtonStates: array[TcxButtonState] of Integer =(PBS_DEFAULTED, PBS_NORMAL,  PBS_HOT, PBS_PRESSED, PBS_DISABLED);
begin
  Result := ButtonStates[AState];
end;

procedure TcxOffice11LookAndFeelPainter.DrawGroupBoxScaledFrame(ACanvas: TcxCanvas;
  R: TRect; AEnabled: Boolean; ACaptionPosition: TcxGroupBoxCaptionPosition;
  AScaleFactor: TdxScaleFactor; ABorders: TcxBorders = cxBordersAll);
var
  APainter: TcxCustomLookAndFeelPainter;
begin
  if AreVisualStylesAvailable([totButton]) and
    cxLookAndFeelPaintersManager.GetPainter(lfsNative, APainter)
  then
    APainter.DrawGroupBoxScaledFrame(ACanvas, R, AEnabled, ACaptionPosition, AScaleFactor, ABorders)
  else
    inherited DrawGroupBoxScaledFrame(ACanvas, R, AEnabled, ACaptionPosition, AScaleFactor, ABorders);
end;

function TcxOffice11LookAndFeelPainter.GroupBoxTextColor(
  AEnabled: Boolean; ACaptionPosition: TcxGroupBoxCaptionPosition): TColor;
var
  APainter: TcxCustomLookAndFeelPainter;
begin
  if AreVisualStylesAvailable([totButton]) and cxLookAndFeelPaintersManager.GetPainter(lfsNative, APainter) then
    Result := APainter.GroupBoxTextColor(AEnabled, ACaptionPosition)
  else
    Result := inherited GroupBoxTextColor(AEnabled, ACaptionPosition);
end;

procedure TcxOffice11LookAndFeelPainter.DrawTrackBarTrackBounds(ACanvas: TcxCanvas; const ARect: TRect);
begin
  ACanvas.FrameRect(ARect, clBtnText);
end;

procedure TcxOffice11LookAndFeelPainter.DrawTrackBarThumbBorderUpDown(ACanvas: TcxCanvas;
  const ALightPolyLine, AShadowPolyLine, ADarkPolyLine: TPoints);
begin
  ACanvas.Pen.Color := clBtnText;
  ACanvas.Polyline(ALightPolyLine);
  ACanvas.Polyline(ADarkPolyLine);
end;

procedure TcxOffice11LookAndFeelPainter.DrawTrackBarThumbBorderBoth(ACanvas: TcxCanvas; const ARect: TRect);
begin
  ACanvas.FrameRect(ARect, clBtnText);
end;

procedure TcxOffice11LookAndFeelPainter.DrawPanelBackground(
  ACanvas: TcxCanvas; AControl: TWinControl; ABounds: TRect; AColorFrom,
  AColorTo: TColor);
begin
  if AColorFrom = clDefault then
    cxDrawTransparentControlBackground(AControl, ACanvas, ABounds)
  else
    if AColorTo = clDefault then
      ACanvas.FillRect(ABounds, AColorFrom)
    else
      FillGradientRect(ACanvas.Handle, ABounds, AColorFrom, AColorTo, False);
end;

procedure TcxOffice11LookAndFeelPainter.DrawLayoutControlBackground(
  ACanvas: TcxCanvas; const R: TRect);
begin
  FillGradientRect(ACanvas.Handle, R,
    dxOffice11ToolbarsColor1, dxOffice11ToolbarsColor2, False);
end;

procedure TcxOffice11LookAndFeelPainter.DrawDateNavigatorDateHeader(
  ACanvas: TcxCanvas; var R: TRect);
begin
  ACanvas.FillRect(R, DefaultDateNavigatorHeaderColor);
end;

function TcxOffice11LookAndFeelPainter.GetSplitterInnerColor(AHighlighted: Boolean): TColor;
begin
  Result := dxOffice11BarSeparatorColor2;
end;

function TcxOffice11LookAndFeelPainter.GetSplitterOuterColor(AHighlighted: Boolean): TColor;
begin
  if AHighlighted then
    Result := dxOffice11SelectedBorderColor
  else
    Result := dxOffice11BarSeparatorColor1;
end;

function TcxOffice11LookAndFeelPainter.NavigatorBorderSize: Integer;
begin
  Result := 1;
end;

function TcxOffice11LookAndFeelPainter.BreadcrumbEditBackgroundColor(
  AState: TdxBreadcrumbEditState): TColor;
begin
  Result := HeaderTopColor;
end;

procedure TcxOffice11LookAndFeelPainter.DrawBreadcrumbEditBorders(ACanvas: TcxCanvas;
  const ARect: TRect; ABorders: TcxBorders; AState: TdxBreadcrumbEditState);
begin
  ACanvas.FrameRect(ARect, dxOffice11ControlBorderColor, 1, ABorders);
end;

procedure TcxOffice11LookAndFeelPainter.DrawBreadcrumbEditCustomButton(
  ACanvas: TcxCanvas; const R: TRect; AState: TdxBreadcrumbEditButtonState;
  ABorders: TcxBorders);

  procedure GetColors(out AColor1, AColor2: TColor);
  begin
    case AState of
      dxbcbsFocused:
        begin
          AColor1 := dxOffice11SelectedColor1;
          AColor2 := dxOffice11SelectedColor1;
        end;

      dxbcbsHot:
        begin
          AColor1 := dxOffice11SelectedColor1;
          AColor2 := dxOffice11SelectedColor2;
        end;

      dxbcbsPressed:
        begin
          AColor1 := dxOffice11DownedColor;
          AColor2 := dxOffice11SelectedColor1;
        end;

      else
      begin
        AColor1 := HeaderTopColor;
        AColor2 := AColor1;
      end;
    end;
  end;

var
  AColor1, AColor2: TColor;
begin
  if not R.IsEmpty then
  begin
    GetColors(AColor1, AColor2);
    Office11FillTubeGradientRect(ACanvas.Handle, R, AColor1, AColor2, False);
    ACanvas.FrameRect(R, dxOffice11DropDownBorderColor1, 1, ABorders);
  end;
end;

function TcxOffice11LookAndFeelPainter.GetDataRowLayoutContentColor: TColor;
begin
  Result := DefaultGroupColor;
end;

procedure TcxOffice11LookAndFeelPainter.DrawDropDownListBoxBackground(
  ACanvas: TcxCanvas; const ARect: TRect; AHasBorders: Boolean);
var
  R: TRect;
begin
  R := ARect;
  if AHasBorders then
  begin
    ACanvas.FrameRect(R, dxOffice11DropDownBorderColor1);
    R.Inflate(-1, -1);
    ACanvas.FrameRect(R, dxOffice11DropDownBorderColor2);
    R.Inflate(-1, -1);
  end;
  ACanvas.FillRect(R, dxOffice11MenuColor);
end;

procedure TcxOffice11LookAndFeelPainter.DrawDropDownListBoxScaledSelection(
  ACanvas: TcxCanvas; const ARect: TRect; const AGutterRect: TRect; AScaleFactor: TdxScaleFactor);
begin
  FillRectByColor(ACanvas.Handle, ARect, dxOffice11SelectedColor1);
  Office11FrameSelectedRect(ACanvas.Handle, ARect);
end;

procedure TcxOffice11LookAndFeelPainter.DrawDropDownListBoxScaledSeparator(
  ACanvas: TcxCanvas; const ARect: TRect; const AGutterRect: TRect; AScaleFactor: TdxScaleFactor);
var
  R: TRect;
begin
  R := ARect;
  R.Left := AGutterRect.Right + 8;
  FillRectByColor(ACanvas.Handle, cxRectCenterVertically(R, 1), dxOffice11BarSeparatorColor1);
end;

procedure TcxOffice11LookAndFeelPainter.DrawDropDownListBoxScaledGutterBackground(
  ACanvas: TcxCanvas; const ARect: TRect; AScaleFactor: TdxScaleFactor);
begin
  Office11FillTubeGradientRect(ACanvas.Handle, ARect, dxOffice11MenuIndentColor1, dxOffice11MenuIndentColor2, True);
end;

procedure TcxOffice11LookAndFeelPainter.DrawAlertWindowBackground(
  ACanvas: TcxCanvas; const ABounds: TRect; AScaleFactor: TdxScaleFactor = nil);
var
  R: TRect;
begin
  R := ABounds;
  ACanvas.FrameRect(R, dxOffice11ControlBorderColor);
  InflateRect(R, -1, -1);
  FillGradientRect(ACanvas.Handle, R, dxOffice11DockColor2, dxOffice11DockColor1, False);
end;


{ TcxUltraFlatLookAndFeelPainter }

function TcxUltraFlatLookAndFeelPainter.LookAndFeelName: string;
begin
  Result := 'UltraFlat';
end;

function TcxUltraFlatLookAndFeelPainter.LookAndFeelStyle: TcxLookAndFeelStyle;
begin
  Result := lfsUltraFlat;
end;

function TcxUltraFlatLookAndFeelPainter.DefaultFixedSeparatorColor: TColor;
begin
  if not TdxVisualRefinements.LightBorders then
    Result := inherited
  else
    Result := cl3DDkShadow;
end;

function TcxUltraFlatLookAndFeelPainter.DefaultSchedulerBorderColor: TColor;
begin
  Result := clBtnShadow;
end;

function TcxUltraFlatLookAndFeelPainter.BorderHighlightColor: TColor;
begin
  Result := clHighlight;
end;

function TcxUltraFlatLookAndFeelPainter.BorderSize: Integer;
begin
  Result := 1;
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawBorder(ACanvas: TcxCustomCanvas; R: TRect; AWidth: Integer = 1);
begin
  ACanvas.FrameRect(R, clBtnShadow);
end;

procedure TcxUltraFlatLookAndFeelPainter.DoDrawSeparator(ACanvas: TcxCustomCanvas; R: TRect; AIsVertical: Boolean);
begin
  ACanvas.FillRect(R, clBtnShadow);
end;

function TcxUltraFlatLookAndFeelPainter.ButtonBorderSize(AState: TcxButtonState = cxbsNormal): Integer;
begin
  if AState = cxbsDefault then
    Result := 2
  else
    Result := 1;
end;

function TcxUltraFlatLookAndFeelPainter.ButtonColor(AState: TcxButtonState): TColor;
begin
  case AState of
    cxbsHot:
      Result := GetLightSelColor;
    cxbsPressed:
      Result := GetLightDownedSelColor;
  else
    Result := inherited ButtonColor(AState);
  end;
end;

function TcxUltraFlatLookAndFeelPainter.ScaledButtonFocusRect(ACanvas: TcxCanvas; R: TRect; AScaleFactor: TdxScaleFactor): TRect;
begin
  Result := R;
  InflateRect(Result, AScaleFactor.Apply(-3), AScaleFactor.Apply(-3));
  if IsRectEmpty(Result) then
    Result := R;
end;

function TcxUltraFlatLookAndFeelPainter.ButtonSymbolColor(
  AState: TcxButtonState; ADefaultColor: TColor; APart: TcxButtonPart): TColor;
begin
  if AState = cxbsPressed then
    Result := clHighlightText
  else
    Result := inherited ButtonSymbolColor(AState, ADefaultColor);
end;

function TcxUltraFlatLookAndFeelPainter.ButtonSymbolState(AState: TcxButtonState): TcxButtonState;
begin
  Result := cxbsNormal;
end;

function TcxUltraFlatLookAndFeelPainter.ScaledButtonTextOffset(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := AScaleFactor.Apply(2);
end;

function TcxUltraFlatLookAndFeelPainter.ScaledButtonTextShift(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := 0;
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawButtonBorder(ACanvas: TcxCustomCanvas; R: TRect; AState: TcxButtonState);

  function GetBorderColor: TColor;
  begin
    case AState of
      cxbsDisabled:
        Result := clBtnShadow;
      cxbsNormal:
        if not TdxVisualRefinements.LightBorders then
          Result := clBtnText
        else
          Result := cl3DDkShadow;
    else
      Result := clHighlight;
    end;
  end;

begin
  if AState = cxbsDefault then
  begin
    ACanvas.FrameRect(R, clWindowFrame);
    InflateRect(R, -1, -1);
    ACanvas.FrameRect(R, clWindowFrame);
  end
  else
    ACanvas.FrameRect(R, GetBorderColor);
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawScaledExpandButton(
  ACanvas: TcxCustomCanvas; const R: TRect; AExpanded: Boolean;
  AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault; AState: TcxExpandButtonState = cebsNormal);
var
  ARect: TRect;
begin
  ACanvas.FrameRect(R, clBtnShadow);
  ARect := cxRectInflate(R, -1);
  ACanvas.FillRect(ARect, cxGetActualColor(AColor, clBtnFace));
  DrawExpandButtonCross(ACanvas, ARect, AExpanded, clBtnText, AScaleFactor);
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawHeaderControlSectionBorder(
  ACanvas: TcxCanvas; const R: TRect; ABorders: TcxBorders; AState: TcxButtonState);
begin
  if AState <> cxbsDisabled then
    ACanvas.DrawComplexFrame(R, clBlack, clBlack, ABorders)
  else
    ACanvas.DrawComplexFrame(R, clBtnShadow, clBtnShadow, ABorders);
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawHeaderControlSectionContent(
  ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect;
  AState: TcxButtonState; AAlignmentHorz: TAlignment;
  AAlignmentVert: TcxAlignmentVert; AMultiLine, AShowEndEllipsis: Boolean;
  const AText: string; AFont: TFont; ATextColor, ABkColor: TColor);
begin
  if AState in [cxbsDefault, cxbsNormal] then
    ACanvas.SetBrushColor(ABkColor)
  else
    ACanvas.SetBrushColor(ButtonColor(AState));
  ACanvas.FillRect(ABounds);
  ACanvas.Font.Color := ATextColor;
  DrawHeaderControlSectionText(ACanvas, ATextAreaBounds, AState, AAlignmentHorz,
    AAlignmentVert, AMultiLine, AShowEndEllipsis, AText, AFont, ATextColor);
end;

function TcxUltraFlatLookAndFeelPainter.ScaledExpandButtonSize(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := AScaleFactor.Apply(11);
end;

function TcxUltraFlatLookAndFeelPainter.IsButtonHotTrack: Boolean;
begin
  Result := True;
end;

function TcxUltraFlatLookAndFeelPainter.DefaultSchedulerTimeRulerBorderColor: TColor;
begin
  Result := DefaultSchedulerTimeRulerBorderColorClassic;
end;

function TcxUltraFlatLookAndFeelPainter.DefaultSchedulerTimeRulerTextColor: TColor;
begin
  Result := DefaultSchedulerTimeRulerTextColorClassic;
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawCheckBorder(ACanvas: TcxCustomCanvas; R: TRect;
  AState: TcxButtonState);
begin
  ACanvas.FrameRect(R, clBtnText);
  InflateRect(R, -1, -1);
  ACanvas.FrameRect(R, CheckButtonColor(AState, cbsChecked));
end;

function TcxUltraFlatLookAndFeelPainter.RadioButtonBodyColor(AState: TcxButtonState): TColor;
begin
  case AState of
    cxbsHot:
      Result := GetLightSelColor;
    cxbsNormal:
      Result := clWindow{clBtnFace};
    cxbsPressed:
      Result := GetLightDownedSelColor;
    else
      Result := clBtnFace;
  end;
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawHeaderBorder(
  ACanvas: TcxCustomCanvas; const R: TRect; ANeighbors: TcxNeighbors; ABorders: TcxBorders);
var
  AColor: TColor;
begin
  if not TdxVisualRefinements.LightBorders then
  begin
    AColor := clBtnText;
    ACanvas.FrameRect(R, AColor, 1, ABorders + [bRight, bBottom]);
  end
  else
  begin
    AColor := cl3DDkShadow;
    ACanvas.FrameRect(R, AColor, 1, ABorders + [bBottom]);
  end;
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawScaledHeaderEx(ACanvas: TcxCanvas;
  const ABounds, ATextAreaBounds: TRect; ANeighbors: TcxNeighbors; ABorders: TcxBorders;
  AState: TcxButtonState; AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert;
  AMultiLine, AShowEndEllipsis: Boolean; const AText: string; AFont: TFont;
  ATextColor, ABkColor: TColor; AScaleFactor: TdxScaleFactor; AOnDrawBackground: TcxDrawBackgroundEvent = nil);
var
  R: TRect;
begin
  R := ATextAreaBounds;
  InflateRect(R, -1, -1);
  DrawContent(ACanvas, ABounds, R, AState, AAlignmentHorz, AAlignmentVert,
    AMultiLine, AShowEndEllipsis, AText, AFont, ATextColor, ABkColor, AOnDrawBackground);
  R := ABounds;
  InflateRect(R, -1, -1);
  DrawHeaderBorder(ACanvas, R, ANeighbors, ABorders);
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawScaledIndicatorItem(
  ACanvas: TcxCanvas; const R, AImageAreaBounds: TRect;
  AKind: TcxIndicatorKind; AColor: TColor; AScaleFactor: TdxScaleFactor;
  AOnDrawBackground: TcxDrawBackgroundEvent; ANeighbors: TcxNeighbors; APaintLeftSide: Boolean; AIsRightToLeft: Boolean;
  ABorderWidth: Integer = 1);
var
  AActualNeighbors: TcxNeighbors;
  AActualBorders: TcxBorders;
begin
  if not TdxVisualRefinements.LightBorders then
    inherited
  else
  begin
    if APaintLeftSide then
    begin
      AActualNeighbors := [];
      AActualBorders := [bLeft, bBottom, bRight];
    end
    else
    begin
      AActualNeighbors := [nTop, nRight, nBottom];
      AActualBorders := [bBottom, bRight];
    end;

    if AIsRightToLeft then
    begin
      AActualNeighbors := TdxRightToLeftLayoutConverter.ConvertNeighbors(AActualNeighbors);
      AActualBorders := TdxRightToLeftLayoutConverter.ConvertBorders(AActualBorders);
    end;
    DrawScaledHeader(ACanvas, R, R, AActualNeighbors, AActualBorders, cxbsNormal,
      taLeftJustify, vaTop, False, False, '', nil, clNone, AColor, AScaleFactor, AOnDrawBackground, False, False, ABorderWidth);
    DrawScaledIndicatorImage(ACanvas, AImageAreaBounds, AKind, AScaleFactor);
  end;
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawScaledSortingMark(
  ACanvas: TcxCanvas; const R: TRect; AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor);
begin
  DrawSortingArrow(ACanvas, R, clBtnShadow, clBtnShadow, AAscendingSorting, AScaleFactor);
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawScaledSummarySortingMark(
  ACanvas: TcxCanvas; const R: TRect; AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor);
begin
  DrawSummarySortingArrow(ACanvas, R, clBtnShadow, clBtnShadow, AAscendingSorting, AScaleFactor);
end;

function TcxUltraFlatLookAndFeelPainter.HeaderBorders(ANeighbors: TcxNeighbors): TcxBorders;
begin
  Result := inherited HeaderBorders(ANeighbors);
  if nLeft in ANeighbors then Exclude(Result, bLeft);
  if nTop in ANeighbors then Exclude(Result, bTop);
end;

function TcxUltraFlatLookAndFeelPainter.HeaderBorderSize: Integer;
begin
  Result := 1;
end;

function TcxUltraFlatLookAndFeelPainter.ScaledSortingMarkSize(AScaleFactor: TdxScaleFactor): TPoint;
begin
  Result := AScaleFactor.Apply(Point(7, 8));
end;

function TcxUltraFlatLookAndFeelPainter.ScaledSummarySortingMarkSize(AScaleFactor: TdxScaleFactor): TPoint;
begin
  Result := AScaleFactor.Apply(Point(7, 9));
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawFooterBorder(ACanvas: TcxCanvas; const R: TRect;
  const ABorders: TcxBorders; AScaleFactor, ABordersScaleFactor: TdxScaleFactor);
begin
  ACanvas.FrameRect(R, FooterSeparatorColor, ABordersScaleFactor.Apply(1), ABorders);
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawFooterBorderEx(ACanvas: TcxCanvas;
  const R: TRect; ABorders: TcxBorders; AScaleFactor: TdxScaleFactor);
begin
  ACanvas.FrameRect(R, FooterSeparatorColor, FooterSeparatorSize, ABorders);
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawFooterCellBorder(ACanvas: TcxCanvas; const R: TRect;
  const ABorders: TcxBorders; AScaleFactor: TdxScaleFactor);
begin
  ACanvas.FrameRect(R, FooterSeparatorColor, AScaleFactor.Apply(1), ABorders);
end;

function TcxUltraFlatLookAndFeelPainter.FooterBorderSize: Integer;
begin
  Result := 1;
end;

function TcxUltraFlatLookAndFeelPainter.FooterCellBorderSize: Integer;
begin
  Result := 1;
end;

function TcxUltraFlatLookAndFeelPainter.FooterCellOffset: Integer;
begin
  Result := 2;
end;

function TcxUltraFlatLookAndFeelPainter.FooterContentOffset: Integer;
begin
  Result := 3;
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawScaledFilterDropDownButton(ACanvas: TcxCanvas;
  R: TRect; AState: TcxButtonState; AIsFilterActive: Boolean; AScaleFactor: TdxScaleFactor);

  function GetArrowColor: TColor;
  begin
    if AIsFilterActive then
      Result := ActiveFilterButtonArrowColor
    else
      Result := ButtonSymbolColor(AState);
  end;

begin
  ACanvas.FrameRect(R, FilterDropDownButtonBorderColor(AState));
  InflateRect(R, -1, -1);
  ACanvas.Brush.Color := ButtonColor(AState);
  ACanvas.FillRect(R);
  DrawButtonArrow(ACanvas, R, GetArrowColor);
end;

function TcxUltraFlatLookAndFeelPainter.ScaledFilterCloseButtonSize(AScaleFactor: TdxScaleFactor): TPoint;
begin
  Result := inherited ScaledFilterCloseButtonSize(AScaleFactor);
  Inc(Result.Y);
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawTabBorder(ACanvas: TcxCanvas; R: TRect;
  ABorder: TcxBorder; ABorders: TcxBorders; AVertical: Boolean);
begin
  if AVertical and (ABorder = bBottom) or not AVertical and (ABorder = bRight) then
  begin
    if not AVertical then
      Dec(R.Bottom, TabBorderSize(AVertical));
    ACanvas.Brush.Color := TabBorderDarkColor;
  end
  else
    ACanvas.Brush.Color := TabBorderHighlightColor;
  ACanvas.FillRect(R);
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawTabsRoot(ACanvas: TcxCanvas;
  const R: TRect; ABorders: TcxBorders; AVertical: Boolean);
begin
  ACanvas.DrawComplexFrame(R, TabBorderHighlightColor, TabBorderHighlightColor, ABorders, TabBorderSize(AVertical));
end;

function TcxUltraFlatLookAndFeelPainter.TabBorderSize(AVertical: Boolean): Integer;
begin
  Result := 1;
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawSchedulerNavigationButtonContent(
  ACanvas: TcxCanvas; const ARect: TRect; const AArrowRect: TRect; AIsNextButton: Boolean;
  AState: TcxButtonState; const AIsVertical: Boolean = True);
const
  Borders: array[Boolean, Boolean] of TcxBorders = (
    ([bLeft, bRight, bBottom], [bLeft, bTop, bRight]),
    ([bRight, bTop, bBottom], [bLeft, bTop, bBottom]) );
var
  AColor: TColor;
  R: TRect;
begin
  R := ARect;
  ACanvas.FillRect(R, clBtnFace);
  if AState = cxbsHot then
    AColor := TabBorderHighlightColor
  else
    AColor := TabBorderDarkColor;
  ACanvas.DrawComplexFrame(R, AColor, AColor, Borders[AIsVertical, AIsNextButton]);
  DrawSchedulerNavigationButtonArrow(ACanvas, AArrowRect, AIsNextButton, ButtonSymbolColor(AState), AIsVertical);
end;

function TcxUltraFlatLookAndFeelPainter.FilterDropDownButtonBorderColor(AState: TcxButtonState): TColor;
begin
  if AState = cxbsNormal then
    Result := clBtnShadow
  else
    Result := clHighlight;
end;

function TcxUltraFlatLookAndFeelPainter.TabBorderHighlightColor: TColor;
begin
  Result := clBtnShadow;
end;

function TcxUltraFlatLookAndFeelPainter.TabBorderDarkColor: TColor;
begin
  Result := clBtnText;
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawSchedulerScaledNavigatorButton(
  ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
begin
  DrawScaledButton(ACanvas, R, AState, AScaleFactor, AState in [cxbsHot, cxbsPressed]);
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawSchedulerSplitterBorder(
  ACanvas: TcxCanvas; R: TRect; const AViewParams: TcxViewParams;
  AIsHorizontal: Boolean);
begin
  ACanvas.SetBrushColor(DefaultSchedulerBorderColor);
  if AIsHorizontal then
  begin
    ACanvas.FillRect(Rect(R.Left, R.Top, R.Right, R.Top + 1));
    ACanvas.FillRect(Rect(R.Left, R.Bottom - 1, R.Right, R.Bottom));
    InflateRect(R, 1, -1);
  end
  else
  begin
    ACanvas.FillRect(Rect(R.Left, R.Top, R.Left + 1, R.Bottom));
    ACanvas.FillRect(Rect(R.Right - 1, R.Top, R.Right, R.Bottom));
    InflateRect(R, -1, 1);
  end;
  ACanvas.FillRect(R, AViewParams);
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawGroupBoxScaledFrame(ACanvas: TcxCanvas;
  R: TRect; AEnabled: Boolean; ACaptionPosition: TcxGroupBoxCaptionPosition;
  AScaleFactor: TdxScaleFactor; ABorders: TcxBorders = cxBordersAll);
const
  FrameColorMap: array[Boolean] of TColor = (clBtnShadow, clHighlight);
begin
  ACanvas.FrameRect(R, FrameColorMap[AEnabled], 1, ABorders, True);
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawTrackBarTrackBounds(ACanvas: TcxCanvas; const ARect: TRect);
begin
  ACanvas.FrameRect(ARect, clWindowText);
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawTrackBarThumbBorderUpDown(ACanvas: TcxCanvas;
  const ALightPolyLine, AShadowPolyLine, ADarkPolyLine: TPoints);
begin
  ACanvas.Pen.Color := clWindowText;
  ACanvas.Polyline(ALightPolyLine);
  ACanvas.Polyline(ADarkPolyLine);
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawTrackBarThumbBorderBoth(ACanvas: TcxCanvas; const ARect: TRect);
begin
  ACanvas.FrameRect(ARect, clWindowText);
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawPrintPreviewScaledBackground(
  ACanvas: TcxCanvas; const R: TRect; AScaleFactor: TdxScaleFactor);

  function GetUltraFlatValue(Value: Byte): Byte;
  begin
    Result := Value + (255 - Value) div 3;
  end;

var
  AColor: TColor;
begin
  AColor := ColorToRGB(clBtnShadow);
  AColor := RGB(
    GetUltraFlatValue(GetRValue(AColor)),
    GetUltraFlatValue(GetGValue(AColor)),
    GetUltraFlatValue(GetBValue(AColor)));
  ACanvas.FillRect(R, AColor);
end;

function TcxUltraFlatLookAndFeelPainter.GetSplitterOuterColor(AHighlighted: Boolean): TColor;
begin
  if AHighlighted then
    Result := clHighlight
  else
    Result := inherited GetSplitterOuterColor(AHighlighted);
end;

function TcxUltraFlatLookAndFeelPainter.GetScaledSplitterSize(AHorizontal: Boolean; AScaleFactor: TdxScaleFactor): TSize;
begin
  Result := inherited GetScaledSplitterSize(AHorizontal, AScaleFactor);
  if AHorizontal then
    Result.cy := 1
  else
    Result.cx := 1;
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawNavigatorScaledButton(ACanvas: TcxCustomCanvas; R: TRect;
  AState: TcxButtonState; ABackgroundColor: TColor; AScaleFactor: TdxScaleFactor);
begin
  if AState in [cxbsDisabled, cxbsNormal] then
  begin
    if cxColorIsValid(ABackgroundColor) then
      ACanvas.FrameRect(R, ABackgroundColor)
  end
  else
    ACanvas.FrameRect(R, BorderHighlightColor);

  ACanvas.FillRect(cxRectInflate(R, -1), ButtonColor(AState));
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawNavigatorBorder(ACanvas: TcxCustomCanvas; R: TRect; ASelected: Boolean);
var
  AColor: TColor;
begin
  if ASelected then
    AColor := BorderHighlightColor
  else
    AColor := clBtnShadow;

  ACanvas.FrameRect(R, AColor, 1, cxBordersAll);
end;

function TcxUltraFlatLookAndFeelPainter.NavigatorBorderOverlap: Boolean;
begin
  Result := True;
end;

function TcxUltraFlatLookAndFeelPainter.NavigatorBorderSize: Integer;
begin
  Result := BorderSize;
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawDropDownListBoxBackground(
  ACanvas: TcxCanvas; const ARect: TRect; AHasBorders: Boolean);
var
  R: TRect;
begin
  R := ARect;
  if AHasBorders then
  begin
    ACanvas.FrameRect(R, clBtnShadow);
    R.Inflate(-1, -1);
    ACanvas.FrameRect(R, clBtnHighlight);
    R.Inflate(-1, -1);
  end;
  ACanvas.FillRect(R, clWindow);
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawDropDownListBoxScaledSelection(
  ACanvas: TcxCanvas; const ARect, AGutterRect: TRect; AScaleFactor: TdxScaleFactor);
begin
  ACanvas.FillRect(ARect, GetLightColor(-2, 30, 72));
  ACanvas.FrameRect(ARect, clHighlight);
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawDropDownListBoxScaledSeparator(
  ACanvas: TcxCanvas; const ARect, AGutterRect: TRect; AScaleFactor: TdxScaleFactor);
var
  R: TRect;
begin
  R := ARect;
  R.Left := AGutterRect.Right + 4;
  ACanvas.FillRect(cxRectCenterVertically(R, 1), clBtnShadow);
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawDropDownListBoxScaledGutterBackground(
  ACanvas: TcxCanvas; const ARect: TRect; AScaleFactor: TdxScaleFactor);
begin
  ACanvas.FillRect(ARect, clBtnFace);
end;

function TcxUltraFlatLookAndFeelPainter.DropDownListBoxItemTextColor(ASelected: Boolean): TColor;
begin
  Result := clMenuText;
end;

function TcxUltraFlatLookAndFeelPainter.BreadcrumbEditScaledButtonAreaSeparatorSize(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := 1;
end;

function TcxUltraFlatLookAndFeelPainter.BreadcrumbEditScaledButtonContentOffsets(
  AIsFirst, AIsLast: Boolean; AScaleFactor: TdxScaleFactor): TRect;
begin
  Result := AScaleFactor.Apply(TRect.Create(3 - Ord(AIsFirst), 3, 3 - Ord(AIsLast), 3));
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawBreadcrumbEditBorders(
  ACanvas: TcxCanvas; const ARect: TRect; ABorders: TcxBorders;
  AState: TdxBreadcrumbEditState);
const
  ColorMap: array[TdxBreadcrumbEditState] of TColor =
    (clBtnShadow, clHighlight, clHighlight, clBtnShadow);
begin
  ACanvas.FrameRect(ARect, ColorMap[AState], 1, ABorders);
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawBreadcrumbEditScaledButtonAreaSeparator(
  ACanvas: TcxCanvas; const ARect: TRect; AState: TdxBreadcrumbEditState; AScaleFactor: TdxScaleFactor);
begin
  DrawBreadcrumbEditBorders(ACanvas, ARect, [bLeft], AState);
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawBreadcrumbEditCustomButton(
  ACanvas: TcxCanvas; const R: TRect; AState: TdxBreadcrumbEditButtonState;
  ABorders: TcxBorders);
const
  BorderColorsMap: array[TdxBreadcrumbEditButtonState] of TColor =
    (clNone, clBtnShadow, clHighlight, clHighlight, clNone);
begin
  ACanvas.FillRect(R, ButtonColor(BreadcrumbButtonStateToButtonState[AState]));
  ACanvas.FrameRect(R, BorderColorsMap[AState], 1, ABorders);
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawBreadcrumbEditScaledButton(
  ACanvas: TcxCanvas; const ARect: TRect; AState: TdxBreadcrumbEditButtonState;
  AIsFirst, AIsLast: Boolean; AScaleFactor: TdxScaleFactor);
var
  ABorders: TcxBorders;
begin
  if not (AState in [dxbcbsNormal, dxbcbsDisabled]) then
  begin
    ABorders := [bLeft, bRight];
    if AIsFirst then
      Exclude(ABorders, bLeft);
    if AIsLast then
      Exclude(ABorders, bRight);
    DrawBreadcrumbEditCustomButton(ACanvas, ARect, AState, ABorders);
  end;
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawBreadcrumbEditScaledDropDownButton(
  ACanvas: TcxCanvas; const ARect: TRect; AState: TdxBreadcrumbEditButtonState;
  AIsInEditor: Boolean; AScaleFactor: TdxScaleFactor);
begin
  if AIsInEditor or not (AState in [dxbcbsNormal, dxbcbsDisabled]) then
    DrawBreadcrumbEditCustomButton(ACanvas, ARect, AState, [bLeft]);
end;

function TcxUltraFlatLookAndFeelPainter.GetBevelMinimalShapeSize(AShape: TdxBevelShape): TSize;
begin
  Result.Init(1);
end;

procedure TcxUltraFlatLookAndFeelPainter.GetBevelShapeColors(out AColor1, AColor2: TColor);
begin
  AColor1 := clBtnShadow;
  AColor2 := clNone;
end;

function TcxUltraFlatLookAndFeelPainter.GridBordersOverlapSize: Integer;
begin
  Result := 1;
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawScaledToggleSwitchState(
  ACanvas: TcxCanvas; ABounds: TRect; AState: TcxButtonState; AChecked, AFocused: Boolean; AScaleFactor: TdxScaleFactor);
begin
  ACanvas.FillRect(ABounds, ToggleSwitchToggleColor(AChecked));
  if AChecked then
    ACanvas.Pen.Color := $000000
  else
    ACanvas.Pen.Color := $A0A0A0;

  ACanvas.Rectangle(ABounds);
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawScaledToggleSwitchThumb(
  ACanvas: TcxCanvas; ABounds: TRect; AState: TcxButtonState; AChecked, AFocused: Boolean; AScaleFactor: TdxScaleFactor);
begin
  inherited;
  ACanvas.FrameRect(cxRectInflate(ABounds, -2), $000000);
end;

procedure TcxUltraFlatLookAndFeelPainter.DrawScaledTokenBackground(
  ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
const
  ColorMap: array [TcxButtonState] of TColor = (clBtnShadow, clBtnShadow, clHighlight, clHighlight, clBtnShadow);
begin
  ACanvas.FrameRect(R, ColorMap[AState]);
  if not (AState in [cxbsNormal, cxbsDisabled]) then
    ACanvas.FillRect(cxRectInflate(R, -1), ButtonColor(AState));
end;

function TcxUltraFlatLookAndFeelPainter.ToggleSwitchToggleColor(AChecked: Boolean): TColor;
begin
  if AChecked then
    Result := $FF9933
  else
    Result := $C8C8C8;
end;

procedure TcxUltraFlatLookAndFeelPainter.DoDrawScaledScrollBarPart(ACanvas: TcxCustomCanvas;
  AHorizontal: Boolean; R: TRect; APart: TcxScrollBarPart; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
begin
  if IsRectEmpty(R) or ((APart = sbpThumbnail) and (AState = cxbsDisabled)) then
    Exit;

  case APart of
    sbpPageUp, sbpPageDown:
      inherited;

    sbpThumbnail, sbpLineUp, sbpLineDown:
      begin
        DrawScaledButton(ACanvas, R, AState, AScaleFactor);
        if APart <> sbpThumbnail then
          DrawScaledScrollBarArrow(ACanvas, R, AState, GetArrowDirection(AHorizontal, APart), AScaleFactor);
      end;
  end;
end;


const
//  FilledRadioButtonListSize = 48;
  cxPixelColorMask = $FFFFFF;

procedure InternalRoundRect(ACanvas: TCanvas; const R: TRect);
begin
  ACanvas.RoundRect(R.Left, R.Top, R.Right, R.Bottom, R.Width - 1, R.Height - 1);
end;

procedure dxInitBordersScaleFactor(AScaleFactor: TdxScaleFactor; var ABordersScaleFactor: TdxScaleFactor);
begin
  if ABordersScaleFactor = nil then
    ABordersScaleFactor := dxDefaultScaleFactor;
end;

constructor TcxRadioButtonImageList.Create(AScaleFactor: TdxScaleFactor);
begin
  inherited Create;
  FScaleFactor := TdxScaleFactor.Create;
  FScaleFactor.Assign(AScaleFactor);
  FList := TImageList.Create(nil);
  Initialize;
end;

destructor TcxRadioButtonImageList.Destroy;
begin
  FreeAndNil(FList);
  FreeAndNil(FButtonMask);
  FreeAndNil(FScaleFactor);
  inherited Destroy;
end;

procedure TcxRadioButtonImageList.Draw(ACanvas: TcxCanvas; X, Y: Integer; ABrushColor: TColor;
  ALookAndFeelKind: TcxLookAndFeelKind; AButtonState: TcxButtonState; AChecked, AFocused, AIsDesigning: Boolean);

  procedure DrawGlyph(ACanvas: TcxCanvas; AImageList: TCustomImageList; AImageIndex: TcxImageIndex;
    const AGlyphRect: TRect; ABrushColor: TColor; AEnabled: Boolean);
  var
    ABitmap: TcxBitmap;
  begin
    ABitmap := TcxBitmap.CreateSize(AImageList.Width, AImageList.Height);
    try
      ABitmap.cxCanvas.FillRect(ABitmap.ClientRect, ABrushColor);
      AImageList.Draw(ABitmap.Canvas, 0, 0, AImageIndex, AEnabled);
      TdxImageDrawer.DrawUncachedImage(ACanvas.Handle, AGlyphRect, AGlyphRect, ABitmap, nil, -1, idmNormal, True, 0, clDefault, False);
    finally
      ABitmap.Free;
    end;
  end;

var
  ARect: TRect;
  AImageIndex: Integer;
begin
  AImageIndex := GetImageIndex(ALookAndFeelKind, AButtonState, AChecked, AFocused, AIsDesigning);
  ARect.InitSize(X, Y, GetSize);
  if ABrushColor = clDefault then
    TdxImageDrawer.DrawUncachedImage(ACanvas.Handle, ARect, ARect, nil, FList, AImageIndex, idmNormal, True, 0, clDefault, False)
  else
    DrawGlyph(ACanvas, FList, AImageIndex, ARect, ABrushColor, True);
end;

function TcxRadioButtonImageList.GetSize: TSize;
begin
  Result := Size(FList.Width, FList.Height);
end;

procedure TcxRadioButtonImageList.Prepare;
var
  AColorMap: array[0..6] of TColor;

  function GetRadioButtonBodyColor(ALookAndFeelKind: TcxLookAndFeelKind; AButtonState: TcxButtonState): TColor;
  var
    APainter: TcxCustomLookAndFeelPainter;
  begin
    if cxLookAndFeelPaintersManager.GetPainter(cxLookAndFeelStyleMap[ALookAndFeelKind], APainter) then
      Result := APainter.RadioButtonBodyColor(AButtonState)
    else
      Result := clWindow;
  end;

  procedure PrepareColorMap(ALookAndFeelKind: TcxLookAndFeelKind;
    AButtonState: TcxButtonState; AChecked, AFocused, AIsDesigning: Boolean);
  begin
    AColorMap[0] := clBlack;
    AColorMap[5] := GetRadioButtonBodyColor(ALookAndFeelKind, AButtonState);
    case ALookAndFeelKind of
      lfStandard:
        begin
          AColorMap[1] := clBtnShadow;
          AColorMap[2] := clBtnHighlight;
          AColorMap[3] := cl3DDkShadow;
          AColorMap[4] := cl3DLight;
        end;
      lfFlat:
        begin
          AColorMap[1] := clBtnShadow;
          AColorMap[2] := clBtnHighlight;
          AColorMap[3] := cl3DLight;
          AColorMap[4] := cl3DLight;
        end;
      lfUltraFlat:
        begin
          if AFocused or (AButtonState in [cxbsHot, cxbsPressed]) or (AIsDesigning and
              (AButtonState <> cxbsDisabled)) then
            AColorMap[1] := clHighlight
          else
            AColorMap[1] := clBtnShadow;
          AColorMap[2] := AColorMap[1];
          AColorMap[3] := AColorMap[5];
          AColorMap[4] := AColorMap[5];
        end;
      lfOffice11: // TODO: to method
        begin
          if AButtonState = cxbsDisabled then
            AColorMap[1] := dxOffice11TextDisabledColor
          else
            if AFocused or (AButtonState in [cxbsHot, cxbsPressed]) or AIsDesigning then
              AColorMap[1] := dxOffice11SelectedBorderColor
            else
              AColorMap[1] := clBtnText;//dxOffice11BarFloatingBorderColor1; //clBtnShadow;
          AColorMap[2] := AColorMap[1];
          AColorMap[3] := AColorMap[5];
          AColorMap[4] := AColorMap[5];
        end;
    end;

    if not AChecked then
      AColorMap[6] := AColorMap[5]
    else
      if AButtonState <> cxbsDisabled then
        AColorMap[6] := clWindowText
      else
        if ALookAndFeelKind = lfOffice11 then
          AColorMap[6] := dxOffice11TextDisabledColor
        else
          AColorMap[6] :=  clBtnShadow;
  end;

var
  ABitmap: TcxBitmap32;
  AButtonState: TcxButtonState;
  AChecked, AFocused, AIsDesigning: Boolean;
  AImageListIndexMapIndex, I, J: Integer;
  ALookAndFeelKind: TcxLookAndFeelKind;
  AColors: TRGBColors;
begin
  if FList.Count > 0 then exit;
  ABitmap := TcxBitmap32.CreateSize(FRadioButtonSize.cx, FRadioButtonSize.cy);
  try
    SetLength(AColors, ABitmap.Width * ABitmap.Height);

    for AFocused := False to True do
      for AIsDesigning := False to True do
        for ALookAndFeelKind := Low(TcxLookAndFeelKind) to High(TcxLookAndFeelKind) do
          for AChecked := False to True do
            for AButtonState := Succ(Low(TcxButtonState)) to High(TcxButtonState) do
            begin
              PrepareColorMap(ALookAndFeelKind, AButtonState, AChecked, AFocused, AIsDesigning);

              for I := 0 to FRadioButtonSize.cy - 1 do
                for J := 0 to FRadioButtonSize.cx - 1 do
                  AColors[I * ABitmap.Width + J] := dxColorToRGBQuad(AColorMap[FRadioButtonPattern[I, J]]);

              SetBitmapBits(ABitmap, AColors, True);
              FList.Add(ABitmap, FButtonMask);
              AImageListIndexMapIndex := GetImageListIndexMapIndex(
                ALookAndFeelKind, AButtonState, AChecked, AFocused, AIsDesigning);
              if AImageListIndexMapIndex + 1 > Length(FRadioButtonImageListIndexes) then
                SetLength(FRadioButtonImageListIndexes, AImageListIndexMapIndex + 1);
              FRadioButtonImageListIndexes[AImageListIndexMapIndex] := FList.Count - 1;
            end;
  finally
    ABitmap.Free;
  end;
end;

procedure TcxRadioButtonImageList.Reset;
begin
  FList.Clear;
  Prepare;
end;

procedure TcxRadioButtonImageList.CalculateRadioButtonSize;
var
  B: Windows.TBitmap;
  HB: HBITMAP;
  ABitmap: TBitmap;
  I, J: Integer;
  FRadioButtonMaskSize: TSize;
begin
  HB := LoadBitmap(0, PChar(OBM_CHECKBOXES));
  try
    dxGetBitmapData(HB, B);
  finally
    DeleteObject(HB);
  end;
  FRadioButtonMaskSize.cx := ScaleFactor.Apply(B.bmWidth div 4, dxSystemScaleFactor);
  FRadioButtonMaskSize.cy := ScaleFactor.Apply(B.bmHeight div 3, dxSystemScaleFactor);
  ABitmap := cxCreateBitmap(FRadioButtonMaskSize);
  try
    ABitmap.Canvas.Brush.Color := 0;
    ABitmap.Canvas.FillRect(Rect(0, 0, FRadioButtonMaskSize.cx, FRadioButtonMaskSize.cy));
    DrawFrameControl(ABitmap.Canvas.Handle, Rect(0, 0, FRadioButtonMaskSize.cx,
      FRadioButtonMaskSize.cy), DFC_BUTTON, DFCS_BUTTONRADIOMASK + DFCS_FLAT);
    FRadioButtonSize.cX := 0;
    FRadioButtonSize.cY := 0;
    FRadioButtonRect.Left := -1;
    FRadioButtonRect.Top := -1;
    for J := 0 to FRadioButtonMaskSize.cx - 1 do
      for I := 0 to FRadioButtonMaskSize.cy - 1 do
        if ABitmap.Canvas.Pixels[J, I] = 0 then
        begin
          if FRadioButtonRect.Left = -1 then
            FRadioButtonRect.Left := J;
          Inc(FRadioButtonSize.cX);
          Break;
        end;
    for I := 0 to FRadioButtonMaskSize.cy - 1 do
      for J := 0 to FRadioButtonMaskSize.cx - 1 do
        if ABitmap.Canvas.Pixels[J, I] = 0 then
        begin
          if FRadioButtonRect.Top = -1 then
            FRadioButtonRect.Top := I;
          Inc(FRadioButtonSize.cY);
          Break;
        end;
    FRadioButtonRect.Right := FRadioButtonRect.Left + FRadioButtonSize.cx;
    FRadioButtonRect.Bottom := FRadioButtonRect.Top + FRadioButtonSize.cy;
    ABitmap.Canvas.Brush.Color := 0;
    ABitmap.Canvas.FillRect(Rect(0, 0, FRadioButtonMaskSize.cx, FRadioButtonMaskSize.cy));
    DrawFrameControl(ABitmap.Canvas.Handle, Rect(0, 0, FRadioButtonMaskSize.cx,
      FRadioButtonMaskSize.cy), DFC_BUTTON, DFCS_BUTTONRADIOIMAGE + DFCS_FLAT + DFCS_CHECKED);
    I := FRadioButtonRect.Top + (FRadioButtonSize.cy div 2) - 2;
    J := FRadioButtonRect.Left + (FRadioButtonSize.cx div 2) - 1;
    while ABitmap.Canvas.Pixels[J, I] = ColorToRGB(clWindowText) do
      Dec(I);
    Inc(I);
    FRadioButtonCheckRect.Top := I;
    repeat
      Inc(I);
    until ABitmap.Canvas.Pixels[J, I] <> ColorToRGB(clWindowText);
    FRadioButtonCheckRect.Bottom := I;

    I := FRadioButtonRect.Top + (FRadioButtonSize.cy div 2) - 1;
    J := FRadioButtonRect.Left + (FRadioButtonSize.cx div 2) - 2;
    while ABitmap.Canvas.Pixels[J, I] = ColorToRGB(clWindowText) do
      Dec(J);
    Inc(J);
    FRadioButtonCheckRect.Left := J;
    repeat
      Inc(J);
    until ABitmap.Canvas.Pixels[J, I] <> ColorToRGB(clWindowText);
    FRadioButtonCheckRect.Right := J;
  finally
    ABitmap.Free;
  end;
end;

function TcxRadioButtonImageList.GetImageIndex(ALookAndFeelKind: TcxLookAndFeelKind;
  AButtonState: TcxButtonState; AChecked, AFocused, AIsDesigning: Boolean): Integer;
begin
  Result := FRadioButtonImageListIndexes[GetImageListIndexMapIndex(
    ALookAndFeelKind, AButtonState, AChecked, AFocused, AIsDesigning)];
end;

function TcxRadioButtonImageList.GetImageListIndexMapIndex(ALookAndFeelKind: TcxLookAndFeelKind;
  AButtonState: TcxButtonState; AChecked, AFocused, AIsDesigning: Boolean): Integer;
var
  AButtonStateIndex: Integer;
  ALookAndFeelKindCount: Integer;
begin
  AButtonStateIndex := Integer(AButtonState) - 1;
  ALookAndFeelKindCount := Integer(High(TcxLookAndFeelKind)) - Integer(Low(TcxLookAndFeelKind)) + 1;

  Result := (Integer(AFocused) * 2 * ALookAndFeelKindCount + Integer(AIsDesigning) * ALookAndFeelKindCount +
    Integer(ALookAndFeelKind)) * 8 + Integer(AChecked) * 4 + AButtonStateIndex;
end;

procedure TcxRadioButtonImageList.Initialize;
begin
  CalculateRadioButtonSize;
  FList.Width := FRadioButtonSize.cx;
  FList.Height := FRadioButtonSize.cy;
  FList.Masked := True;
  FList.ImageType := itImage;

  PrepareButtonMask;
  PrepareRadioButtonPattern;
  Prepare;
end;

procedure TcxRadioButtonImageList.PrepareButtonMask;
var
  R: TRect;
  ACanvas: TCanvas;
begin
  if FButtonMask = nil then
    FButtonMask := TBitmap.Create;

  FButtonMask.Monochrome := True;
  FButtonMask.Width := FRadioButtonSize.cx;
  FButtonMask.Height := FRadioButtonSize.cy;

  ACanvas := FButtonMask.Canvas;
  ACanvas.Brush.Color := clWhite;
  R := Rect(0, 0, FRadioButtonSize.cx, FRadioButtonSize.cy);
  ACanvas.FillRect(R);
  ACanvas.Brush.Color := clBlack;
  ACanvas.Pen.Color := clBlack;
  InternalRoundRect(ACanvas, R);
end;

procedure TcxRadioButtonImageList.PrepareRadioButtonPattern;

  procedure PrepareOuterCircle;
  var
    ABitmap: TBitmap;
    I, J: Integer;
    R: TRect;
  begin
    ABitmap := cxCreateBitmap(FRadioButtonSize, pf32bit);
    try
      ABitmap.Canvas.Brush.Color := clWhite;
      R.InitSize(FRadioButtonSize);
      ABitmap.Canvas.FillRect(R);
      ABitmap.Canvas.Pen.Color := clBlack;
      InternalRoundRect(ABitmap.Canvas, R);
      SetLength(FRadioButtonPattern, FRadioButtonSize.cy, FRadioButtonSize.cx);
      for I := 0 to FRadioButtonSize.cy - 1 do
      begin
        for J := 0 to FRadioButtonSize.cx - 1 do
        begin
          if ABitmap.Canvas.Pixels[J, I] and cxPixelColorMask <> 0 then
            FRadioButtonPattern[I, J] := 0
          else
            if (FRadioButtonSize.cy - 1) * (FRadioButtonSize.cx - 1 - J) < I * (FRadioButtonSize.cx - 1) then
              FRadioButtonPattern[I, J] := 2
            else
              FRadioButtonPattern[I, J] := 1;
        end;
      end;
    finally
      ABitmap.Free;
    end;
  end;

  procedure PrepareInnerCircle;

    procedure FillPoint(I, J: Integer);
    var
      ASign: Integer;
    begin
      ASign := (FRadioButtonSize.cy - 1) * (FRadioButtonSize.cx - 1 - J) - I * (FRadioButtonSize.cx - 1);
      if ASign = 0 then
        if J <= FRadioButtonSize.cx div 2 - 1 then
          FRadioButtonPattern[I, J] := 3
        else
          FRadioButtonPattern[I, J] := 4
      else
        if ASign < 0 then
          FRadioButtonPattern[I, J] := 4
        else
          FRadioButtonPattern[I, J] := 3;
    end;

  var
    I, I1, J, J1: Integer;
    AFirstColumn, ALastColumn, AFirstRow, ALastRow: Integer;
  begin
    AFirstRow := 1;
    ALastRow := FRadioButtonSize.cy - 2;
    J1 := FRadioButtonSize.cx div 2 - 1;

    for I := AFirstRow to ALastRow do
    begin
      J := J1;
      while FRadioButtonPattern[I, J] = 0 do
      begin
        FRadioButtonPattern[I, J] := 5;
        Dec(J);
      end;
      J := J1 + 1;
      while FRadioButtonPattern[I, J] = 0 do
      begin
        FRadioButtonPattern[I, J] := 5;
        Inc(J);
      end;
    end;

    for I := AFirstRow to ALastRow do
    begin
      J := J1;
      while not(FRadioButtonPattern[I, J] in [1, 2]) do
      begin
        if (I = AFirstRow) or (I = ALastRow) then
          FillPoint(I, J);
        Dec(J);
      end;
      Inc(J);
      FillPoint(I, J);
      J := J1 + 1;
      while not(FRadioButtonPattern[I, J] in [1, 2]) do
      begin
        if (I = AFirstRow) or (I = ALastRow) then
          FillPoint(I, J);
        Inc(J);
      end;
      Dec(J);
      FillPoint(I, J);
    end;

    AFirstColumn := 1;
    ALastColumn := FRadioButtonSize.cx - 2;
    I1 := FRadioButtonSize.cy div 2 - 1;
    for J := AFirstColumn to ALastColumn do
    begin
      I := I1;
      while not(FRadioButtonPattern[I, J] in [1, 2]) do
      begin
        if (J = AFirstColumn) or (J = ALastColumn) then
          FillPoint(I, J);
        Dec(I);
      end;
      Inc(I);
      FillPoint(I, J);
      I := I1 + 1;
      while not(FRadioButtonPattern[I, J] in [1, 2]) do
      begin
        if (J = AFirstColumn) or (J = ALastColumn) then
          FillPoint(I, J);
        Inc(I);
      end;
      Dec(I);
      FillPoint(I, J);
    end;
  end;

  procedure PrepareCheck;
  var
    ABitmap: TBitmap;
    I, J: Integer;
    R: TRect;
  begin
    ABitmap := cxCreateBitmap(FRadioButtonSize, pf32Bit);
    try
      ABitmap.Canvas.Brush.Color := clWhite;
      ABitmap.Canvas.FillRect(TRect.CreateSize(FRadioButtonSize));
      ABitmap.Canvas.Pen.Color := clBlack;
      ABitmap.Canvas.Brush.Color := clBlack;
      R := FRadioButtonCheckRect;
      R.Offset(-FRadioButtonRect.Left, -FRadioButtonRect.Top);
      InternalRoundRect(ABitmap.Canvas, R);
      for I := 0 to FRadioButtonSize.cy - 1 do
      begin
        for J := 0 to FRadioButtonSize.cx - 1 do
        begin
          if ABitmap.Canvas.Pixels[J, I] and cxPixelColorMask = 0 then
            FRadioButtonPattern[I, J] := 6;
        end;
      end;
    finally
      ABitmap.Free;
    end;
  end;

begin
  PrepareOuterCircle;
  PrepareInnerCircle;
  PrepareCheck;
end;

procedure TcxRadioButtonImageList.Reinitialize;
begin
  FList.Clear;
  Initialize;
end;

procedure TcxRadioButtonImageList.SetScaleFactor(AScaleFactor: TdxScaleFactor);
begin
  if (ScaleFactor.Denominator <> AScaleFactor.Denominator) or (ScaleFactor.Numerator <> AScaleFactor.Numerator) then
  begin
    FScaleFactor.Assign(AScaleFactor);
    Reinitialize;
  end;
end;


{ TcxWinXPLookAndFeelPainter }

destructor TcxWinXPLookAndFeelPainter.Destroy;
begin
  FreeAndNil(FZoomOutButtonGlyph);
  FreeAndNil(FZoomInButtonGlyph);
  inherited Destroy;
end;

procedure TcxWinXPLookAndFeelPainter.AfterConstruction;
begin
  inherited AfterConstruction;
  FZoomInButtonGlyph := TcxBitmap32.Create;
  FZoomInButtonGlyph.LoadFromResourceName(HInstance, 'CX_ZOOMINBUTTONGLYPH');
  FZoomOutButtonGlyph := TcxBitmap32.Create;
  FZoomOutButtonGlyph.LoadFromResourceName(HInstance, 'CX_ZOOMOUTBUTTONGLYPH');
end;

procedure TcxWinXPLookAndFeelPainter.DrawContent(ACanvas: TcxCanvas;
  ATheme: TdxTheme; APartId, AStateId: Integer; const ABounds, ATextAreaBounds: TRect;
  AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert;
  AMultiLine, AShowEndEllipsis, AShowPrefix: Boolean;
  const AText: string; AFont: TFont; ATextColor, ABkColor: TColor);
const
  MultiLines: array[Boolean] of Integer = (DT_SINGLELINE, DT_WORDBREAK);
  ShowEndEllipses: array[Boolean] of Integer = (0, DT_END_ELLIPSIS);
  ShowPrefixes: array[Boolean] of Integer = (DT_NOPREFIX, 0);
var
  R: TRect;
begin
  if AText = '' then Exit;
  R := ATextAreaBounds;
  ACanvas.Font := AFont;
  ACanvas.Font.Color := ATextColor;
  if AMultiLine then
    ACanvas.AlignMultiLineTextRectVertically(R, AText, AAlignmentVert, True,
      AShowPrefix, True, False, AShowEndEllipsis);
  DrawThemeText(ATheme, ACanvas.Handle, APartId, AStateId, AText,
    -1, DT_EDITCONTROL or SystemAlignmentsHorz[AAlignmentHorz] or SystemAlignmentsVert[AAlignmentVert] or
    ShowEndEllipses[AShowEndEllipsis] or ShowPrefixes[AShowPrefix] or
    MultiLines[AMultiLine], 0, R);
end;

procedure TcxWinXPLookAndFeelPainter.DrawSchedulerNavigationButtonContent(
  ACanvas: TcxCanvas; const ARect: TRect; const AArrowRect: TRect;
  AIsNextButton: Boolean; AState: TcxButtonState; const AIsVertical: Boolean = True);
const
  RotationAngle: array[Boolean] of TcxRotationAngle = (raMinus90, raPlus90);
  States: array[TcxButtonState] of Integer = (TIS_NORMAL, TIS_NORMAL, TIS_HOT, TIS_SELECTED, TIS_DISABLED);
var
  ABitmap: TcxBitmap;
  ATheme: TdxTheme;
begin
  ATheme := OpenTheme(totTab);
  if ATheme <> 0 then
  begin
    ABitmap := TcxBitmap.CreateSize(ARect, pf32bit);
    try
      cxBitBlt(ABitmap.Canvas.Handle, ACanvas.Handle, ABitmap.ClientRect, ARect.TopLeft, SRCCOPY);
      if AIsVertical then
        ABitmap.Rotate(RotationAngle[not AIsNextButton]);
      DrawThemeBackground(ATheme, ABitmap.Canvas.Handle, TABP_TABITEM, States[AState], cxGetImageClientRect(ABitmap));

      if AIsVertical then
        ABitmap.Rotate(RotationAngle[AIsNextButton])
      else
        if not AIsNextButton then
          ABitmap.Rotate(ra180);

      cxBitBlt(ACanvas.Handle, ABitmap.Canvas.Handle, ARect, cxNullPoint, SRCCOPY);
      DrawSchedulerNavigationButtonArrow(ACanvas, AArrowRect, AIsNextButton, ButtonSymbolColor(AState), AIsVertical);
    finally
      ABitmap.Free;
    end;
  end
  else
    inherited DrawSchedulerNavigationButtonContent(ACanvas, ARect, AArrowRect, AIsNextButton, AState, AIsVertical);
end;

function TcxWinXPLookAndFeelPainter.LookAndFeelName: string;
begin
  Result := 'Native';
end;

function TcxWinXPLookAndFeelPainter.LookAndFeelStyle: TcxLookAndFeelStyle;
begin
  Result := lfsNative;
end;

function TcxWinXPLookAndFeelPainter.NeedRedrawOnResize: Boolean;
begin
  Result := AreVisualStylesAvailable;
end;

function TcxWinXPLookAndFeelPainter.DefaultFilterBoxColor: TColor;
begin
  if IsWin10OrLater then
    Result := clBtnFace
  else
    Result := inherited DefaultFilterBoxColor;
end;

function TcxWinXPLookAndFeelPainter.DefaultFilterBoxTextColor: TColor;
begin
  if IsWin10OrLater then
    Result := clBtnText
  else
    Result := inherited DefaultFilterBoxTextColor;
end;

function TcxWinXPLookAndFeelPainter.DefaultFooterColor: TColor;
begin
//  if IsWin10OrLater then
//    Result := DefaultContentColor
//  else
    Result := inherited DefaultFooterColor;
end;

function TcxWinXPLookAndFeelPainter.DefaultFooterTextColor: TColor;
begin
//  if IsWin10OrLater then
//    Result := DefaultContentTextColor
//  else
    Result := inherited DefaultFooterTextColor;
end;

function TcxWinXPLookAndFeelPainter.DefaultGridLineColor: TColor;
begin
  if not (IsWin10OrLater and cxGetThemeColor(totHeader, HP_HEADERITEM, CBXS_NORMAL, TMT_EDGEFILLCOLOR, Result)) then
    Result := inherited DefaultGridLineColor;
end;

function TcxWinXPLookAndFeelPainter.DefaultGroupByBoxColor: TColor;
begin
  if IsWin10OrLater then
    Result := DefaultFooterColor
  else
    Result := inherited;
end;

function TcxWinXPLookAndFeelPainter.DefaultGroupByBoxTextColor: TColor;
begin
  if IsWin10OrLater then
    Result := DefaultFooterTextColor
  else
    Result := inherited;
end;

function TcxWinXPLookAndFeelPainter.DefaultSchedulerBorderColor: TColor;
begin
  if not cxGetThemeColor(totComboBox, CP_DROPDOWNBUTTON, CBXS_NORMAL, TMT_BORDERCOLOR, Result) then
    Result := inherited DefaultSchedulerBorderColor;
end;

procedure TcxWinXPLookAndFeelPainter.DrawScaledArrow(ACanvas: TcxCustomCanvas;
  const R: TRect; AState: TcxButtonState; AArrowDirection: TcxArrowDirection;
  AScaleFactor: TdxScaleFactor; ADrawBorder: Boolean = True);
const
  States: array[TcxArrowDirection, TcxButtonState] of Integer = (
    (ABS_UPNORMAL, ABS_UPNORMAL, ABS_UPHOT, ABS_UPPRESSED, ABS_UPDISABLED),
    (ABS_DOWNNORMAL, ABS_DOWNNORMAL, ABS_DOWNHOT, ABS_DOWNPRESSED, ABS_DOWNDISABLED),
    (ABS_LEFTNORMAL, ABS_LEFTNORMAL, ABS_LEFTHOT, ABS_LEFTPRESSED, ABS_LEFTDISABLED),
    (ABS_RIGHTNORMAL, ABS_RIGHTNORMAL, ABS_RIGHTHOT, ABS_RIGHTPRESSED, ABS_RIGHTDISABLED)
  );
begin
  if not DoDrawThemeBackground(ACanvas, totScrollBar, AScaleFactor, R, SBP_ARROWBTN, States[AArrowDirection, AState]) then
    inherited
end;

procedure TcxWinXPLookAndFeelPainter.DrawScaledArrowBorder(ACanvas: TcxCustomCanvas;
  const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
begin
  if not DoDrawThemeBackground(ACanvas, totButton, AScaleFactor, R, BP_PUSHBUTTON, BtnStateToXPBtnState(AState)) then
    inherited;
end;

function TcxWinXPLookAndFeelPainter.BorderSize: Integer;
begin
  if OpenTheme(totListView) <> 0 then
    Result := 1 //!!! lcm corrected
  else
    Result := inherited BorderSize;
end;

function TcxWinXPLookAndFeelPainter.SeparatorSize: Integer;
begin
  Result := 6;
end;

procedure TcxWinXPLookAndFeelPainter.DrawBorder(ACanvas: TcxCustomCanvas; R: TRect; AWidth: Integer = 1);
var
  ATheme: TdxTheme;
begin
  ATheme := OpenTheme(totListView);
  if ATheme <> 0 then
  begin
    ACanvas.DrawNativeObject(R,
      TcxCanvasBasedResourceCacheKey.Create(Pointer(ATheme), TSize.Create(R), 0, LVP_EMPTYTEXT),
      procedure (ACanvas: TcxGdiBasedCanvas; const R: TRect)
      begin
        ACanvas.SaveClipRegion;
        try
          ACanvas.ExcludeClipRect(cxRectInflate(R, -1));
          DrawThemeBackground(ATheme, ACanvas.Handle, LVP_EMPTYTEXT, 0, @R);
        finally
          ACanvas.RestoreClipRegion;
        end;
      end);
  end
  else
    inherited;
end;

procedure TcxWinXPLookAndFeelPainter.DoDrawSeparator(ACanvas: TcxCustomCanvas; R: TRect; AIsVertical: Boolean);
const
  PartMap: array[Boolean] of Cardinal = (TP_SEPARATORVERT, TP_SEPARATOR);
begin
  if not DoDrawThemeBackground(ACanvas, totToolBar, nil, R, PartMap[AIsVertical], TS_NORMAL) then
    inherited;
end;

function TcxWinXPLookAndFeelPainter.ButtonBorderSize(AState: TcxButtonState = cxbsNormal): Integer;
var
  ATheme: TdxTheme;
  R: TRect;
begin
  ATheme := OpenTheme(totButton);
  if ATheme <> 0 then
  begin
    R := Rect(0, 0, 100, 100);
    GetThemeBackgroundContentRect(ATheme, 0, BP_PUSHBUTTON, BtnStateToXPBtnState(AState), R, R);
    Result := R.Left;
  end
  else
    Result := inherited ButtonBorderSize;
end;

function TcxWinXPLookAndFeelPainter.ButtonColor(AState: TcxButtonState): TColor;
begin
  if not cxGetThemeColor(totButton, BP_PUSHBUTTON, BtnStateToXPBtnState(AState), TMT_COLOR, Result) then
    Result := inherited ButtonColor(AState);
end;

function TcxWinXPLookAndFeelPainter.ScaledButtonFocusRect(ACanvas: TcxCanvas; R: TRect; AScaleFactor: TdxScaleFactor): TRect;
var
  ATheme: TdxTheme;
begin
  ATheme := OpenTheme(totButton, AScaleFactor);
  if (ATheme <> 0) and (GetThemeBackgroundContentRect(ATheme, ACanvas.Handle, BP_PUSHBUTTON, PBS_NORMAL, R, R) = S_OK) then
    Result := R
  else
    Result := inherited ScaledButtonFocusRect(ACanvas, R, AScaleFactor);
end;

function TcxWinXPLookAndFeelPainter.ButtonSymbolColor(
  AState: TcxButtonState; ADefaultColor: TColor; APart: TcxButtonPart): TColor;
begin
  if not cxGetThemeColor(totButton, BP_PUSHBUTTON, BtnStateToXPBtnState(AState), TMT_TEXTCOLOR, Result) then
    Result := inherited ButtonSymbolColor(AState, ADefaultColor);
end;

function TcxWinXPLookAndFeelPainter.ScaledButtonTextOffset(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := AScaleFactor.Apply(cxTextOffset);
end;

function TcxWinXPLookAndFeelPainter.ScaledButtonTextShift(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := 0;
end;

procedure TcxWinXPLookAndFeelPainter.DrawScaledButton(ACanvas: TcxCustomCanvas; R: TRect;
  AState: TcxButtonState; AFocused: Boolean; AScaleFactor: TdxScaleFactor;
  ADrawBorder: Boolean = True; AIsToolButton: Boolean = False;
  APart: TcxButtonPart = cxbpButton; AColor: TColor = clDefault);
const
  ButtonObjectType: array[Boolean] of TdxThemedObjectType = (totButton, totToolBar);
begin
  if not DoDrawThemeBackground(ACanvas, ButtonObjectType[AIsToolButton], AScaleFactor, R, BP_PUSHBUTTON, BtnStateToXPBtnState(AState)) then
    inherited;
end;

function TcxWinXPLookAndFeelPainter.DefaultCommandLinkTextColor(AState: TcxButtonState; ADefaultColor: TColor): TColor;
begin
  if IsWinVistaOrLater then
  begin
    if cxGetThemeColor(totButton, BP_COMMANDLINK, BtnStateToXPBtnState(AState), TMT_TEXTCOLOR, Result) then
      Exit;
  end;
  Result := inherited DefaultCommandLinkTextColor(AState, ADefaultColor);
end;

procedure TcxWinXPLookAndFeelPainter.DrawScaledCommandLinkBackground(ACanvas: TcxCanvas; R: TRect;
  AState: TcxButtonState; AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault);
begin
  if not (IsWinVistaOrLater and dxDrawThemeBackground(ACanvas.Handle,
    totButton, AScaleFactor, R, BP_COMMANDLINK, BtnStateToXPBtnState(AState)))
  then
    cxLookAndFeelPaintersManager.GetPainter(lfsFlat).DrawScaledButton(ACanvas, R, AState, AScaleFactor,
      (AState = cxbsHot) or (AState = cxbsPressed), False, cxbpButton, AColor);
end;

procedure TcxWinXPLookAndFeelPainter.DrawScaledCommandLinkGlyph(ACanvas: TcxCanvas;
  const AGlyphPos: TPoint; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
var
  ARect: TRect;
  ATheme: TdxTheme;
begin
  ATheme := OpenTheme(totButton, AScaleFactor);
  if (ATheme <> 0) and IsWinVistaOrLater then
  begin
    ARect.InitSize(AGlyphPos.X, AGlyphPos.Y, GetScaledCommandLinkGlyphSize(AScaleFactor));
    cxRightToLeftDependentDraw(ACanvas, ARect,
      procedure
      begin
        DrawThemeBackground(ATheme, ACanvas.Handle, BP_COMMANDLINKGLYPH, BtnStateToXPBtnState(AState), ARect);
      end);
  end
  else
    inherited DrawScaledCommandLinkGlyph(ACanvas, AGlyphPos, AState, AScaleFactor);
end;

function TcxWinXPLookAndFeelPainter.GetScaledCommandLinkGlyphSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  if not (IsWinVistaOrLater and GetThemeScaledPartSize(totButton, AScaleFactor, BP_COMMANDLINKGLYPH, Result)) then
    Result := inherited GetScaledCommandLinkGlyphSize(AScaleFactor);
end;

function TcxWinXPLookAndFeelPainter.GetScaledCommandLinkMargins(AScaleFactor: TdxScaleFactor): TRect;
var
  ATheme: TdxTheme;
begin
  ATheme := OpenTheme(totButton, AScaleFactor);
  if (ATheme <> 0) and IsWinVistaOrLater then
    Result := AScaleFactor.Apply(GetThemeMargins(ATheme, BP_COMMANDLINK, 0, TMT_CONTENTMARGINS))
  else
    Result := inherited GetScaledCommandLinkMargins(AScaleFactor);
end;

procedure TcxWinXPLookAndFeelPainter.DrawScaledExpandButton(
  ACanvas: TcxCustomCanvas; const R: TRect; AExpanded: Boolean;
  AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault; AState: TcxExpandButtonState = cebsNormal);
const
  States: array[Boolean] of Integer = (GLPS_CLOSED, GLPS_OPENED);
begin
  if not DoDrawScaledThemeBackground(ACanvas, totTreeView, AScaleFactor, R, TVP_GLYPH, States[AExpanded]) then
    inherited;
end;

procedure TcxWinXPLookAndFeelPainter.DrawTreeViewExpandButton(ACanvas: TcxCanvas; const R: TRect;
  AExpanded: Boolean; AExplorerStyle: Boolean; AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault;
  AState: TcxExpandButtonState = cebsNormal);
const
  States: array[Boolean] of Integer = (GLPS_CLOSED, GLPS_OPENED);
  Classes: array[Boolean] of TdxThemedObjectType = (totTreeView, totExplorerTreeView);
begin
  if not DoDrawScaledThemeBackground(ACanvas, Classes[AExplorerStyle], AScaleFactor, R, TVP_GLYPH, States[AExpanded]) then
    inherited;
end;

function TcxWinXPLookAndFeelPainter.DrawExpandButtonFirst: Boolean;
begin
  Result := False;
end;

procedure TcxWinXPLookAndFeelPainter.DrawScaledGroupExpandButton(ACanvas: TcxCustomCanvas;
  const R: TRect; AExpanded: Boolean; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
const
  Buttons: array[Boolean] of Integer = (EBP_NORMALGROUPEXPAND, EBP_NORMALGROUPCOLLAPSE);
  States: array[cxbsNormal..cxbsPressed] of Integer = (EBNGE_NORMAL, EBNGE_HOT, EBNGE_PRESSED);
begin
  if not DoDrawThemeBackground(ACanvas, totExplorerBar, AScaleFactor, R, Buttons[AExpanded], States[AState]) then
    inherited;
end;

procedure TcxWinXPLookAndFeelPainter.DrawScaledSmallButton(
  ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
begin
  DrawScaledButton(ACanvas, R, AState, AScaleFactor);
end;

procedure TcxWinXPLookAndFeelPainter.DrawScaledSmallExpandButton(ACanvas: TcxCanvas; R: TRect;
  AExpanded: Boolean; ABorderColor: TColor; AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault);
begin
  if OpenTheme(totTreeView, AScaleFactor) <> 0 then
    DrawScaledExpandButton(ACanvas, R, AExpanded, AScaleFactor)
  else
    inherited DrawScaledSmallExpandButton(ACanvas, R, AExpanded, ABorderColor, AScaleFactor, AColor);
end;

function TcxWinXPLookAndFeelPainter.ScaledExpandButtonSize(AScaleFactor: TdxScaleFactor): Integer;
var
  ASize: TSize;
begin
  if GetThemeScaledPartSize(totTreeView, AScaleFactor, TVP_GLYPH, ASize, GLPS_OPENED) then
    Result := ASize.cx
  else
    Result := inherited ScaledExpandButtonSize(AScaleFactor);
end;

function TcxWinXPLookAndFeelPainter.ScaledGroupExpandButtonSize(AScaleFactor: TdxScaleFactor): Integer;
var
  ASize: TSize;
begin
  if GetThemeScaledPartSize(totExplorerBar, AScaleFactor, EBP_NORMALGROUPEXPAND, ASize, EBNGE_NORMAL, tssNoScaling) then
    Result := ASize.cx
  else
    Result := inherited ScaledGroupExpandButtonSize(AScaleFactor);
end;

function TcxWinXPLookAndFeelPainter.ScaledSmallExpandButtonSize(AScaleFactor: TdxScaleFactor): Integer;
begin
  if OpenTheme(totTreeView) <> 0 then
    Result := ScaledExpandButtonSize(AScaleFactor)
  else
    Result := inherited ScaledSmallExpandButtonSize(AScaleFactor);
end;

function TcxWinXPLookAndFeelPainter.IsButtonHotTrack: Boolean;
begin
  Result := True;
end;

function TcxWinXPLookAndFeelPainter.IsPointOverGroupExpandButton(const R: TRect; const P: TPoint): Boolean;
var
  ATheme: TdxTheme;
  ARegion: HRGN;
begin
  ATheme := OpenTheme(totExplorerBar);
  if ATheme <> 0 then
  begin
    GetThemeBackgroundRegion(ATheme, 0, EBP_NORMALGROUPEXPAND, EBNGE_HOT, @R, ARegion);
    Result := cxPtInRegion(ARegion, P);
    DeleteObject(ARegion);
  end
  else
    Result := inherited IsPointOverGroupExpandButton(R, P);
end;

function TcxWinXPLookAndFeelPainter.TreeViewExpandButtonSize(AExplorerStyle: Boolean; AScaleFactor: TdxScaleFactor): TSize;
const
  Classes: array[Boolean] of TdxThemedObjectType = (totTreeView, totExplorerTreeView);
begin
  if not GetThemeScaledPartSize(Classes[AExplorerStyle], AScaleFactor, TVP_GLYPH, Result, GLPS_OPENED) then
    Result := inherited TreeViewExpandButtonSize(False, AScaleFactor);
end;

function TcxWinXPLookAndFeelPainter.CheckBorderSize: Integer;
var
  ATheme: TdxTheme;
begin
  ATheme := OpenTheme(totButton);
  if ATheme <> 0 then
    Result := 0
  else
    Result := inherited CheckBorderSize;
end;

function TcxWinXPLookAndFeelPainter.ScaledCheckButtonSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  if not GetThemeScaledPartSize(totButton, AScaleFactor, BP_CHECKBOX, Result, CBS_CHECKEDNORMAL) then
    Result := inherited ScaledCheckButtonSize(AScaleFactor);
end;

procedure TcxWinXPLookAndFeelPainter.DrawScaledCheck(ACanvas: TcxCustomCanvas; const R: TRect;
  AState: TcxButtonState; ACheckState: TcxCheckBoxState; AColor: TColor; AScaleFactor: TdxScaleFactor; ADrawBackground: Boolean);
const
  NativeCheckStateMap: array[TcxCheckBoxState, TcxButtonState] of Integer = (
    (CBS_UNCHECKEDNORMAL, CBS_UNCHECKEDNORMAL, CBS_UNCHECKEDHOT, CBS_UNCHECKEDPRESSED, CBS_UNCHECKEDDISABLED),
    (CBS_CHECKEDNORMAL, CBS_CHECKEDNORMAL, CBS_CHECKEDHOT, CBS_CHECKEDPRESSED, CBS_CHECKEDDISABLED),
    (CBS_MIXEDNORMAL, CBS_MIXEDNORMAL, CBS_MIXEDHOT, CBS_MIXEDPRESSED, CBS_MIXEDDISABLED)
  );
begin
  if not DoDrawScaledThemeBackground(ACanvas, totButton, AScaleFactor, R, BP_CHECKBOX, NativeCheckStateMap[ACheckState, AState]) then
    inherited;
end;

procedure TcxWinXPLookAndFeelPainter.DrawCheckBorder(ACanvas: TcxCustomCanvas; R: TRect; AState: TcxButtonState);
begin
  if OpenTheme(totButton) = 0 then
    inherited;
end;

procedure TcxWinXPLookAndFeelPainter.DrawScaledRadioButton(ACanvas: TcxCanvas; X, Y: Integer; AButtonState: TcxButtonState;
  AChecked: Boolean; AFocused: Boolean; ABrushColor: TColor; AScaleFactor: TdxScaleFactor; AIsDesigning: Boolean = False);

  function GetNativeState: Integer;
  const
    NativeStateMap: array [Boolean, TcxButtonState] of Integer = (
      (RBS_UNCHECKEDNORMAL, RBS_UNCHECKEDNORMAL, RBS_UNCHECKEDHOT, RBS_UNCHECKEDPRESSED, RBS_UNCHECKEDDISABLED),
      (RBS_CHECKEDNORMAL,RBS_CHECKEDNORMAL, RBS_CHECKEDHOT, RBS_CHECKEDPRESSED, RBS_CHECKEDDISABLED)
    );
  begin
    Result := NativeStateMap[AChecked, AButtonState];
  end;

begin
  DrawScaledThemeBackground(OpenTheme(totButton, AScaleFactor), ACanvas.Handle, BP_RADIOBUTTON,
    GetNativeState, cxRectBounds(X, Y, ScaledRadioButtonSize(AScaleFactor)), AScaleFactor);
end;

function TcxWinXPLookAndFeelPainter.ScaledRadioButtonSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  if not GetThemeScaledPartSize(totButton, AScaleFactor, BP_RADIOBUTTON, Result, RBS_UNCHECKEDNORMAL) then
    Result := inherited;
end;

procedure TcxWinXPLookAndFeelPainter.DrawScaledHeader(ACanvas: TcxCustomCanvas; const ABounds: TRect;
  AState: TcxButtonState; ANeighbors: TcxNeighbors; ABorders: TcxBorders; AScaleFactor: TdxScaleFactor;
  AIsLast: Boolean = False; AIsGroup: Boolean = False);

  function GetHeaderItem(ANativeState: Integer): Integer;
  begin
    if AIsLast and (ANativeState = HIS_NORMAL) and (GetOffice11Scheme in [schNormalColor, schHomestead]) then
      Result := HP_HEADERITEMRIGHT
    else
      Result := HP_HEADERITEM;
  end;

var
  ANativeState: Integer;
begin
  ANativeState := ButtonStateToHeaderState[AState];
  if IsWin10OrLater then
    ACanvas.FillRect(ABounds, clWindow);
  if not DoDrawThemeBackground(ACanvas, totHeader, AScaleFactor, ABounds, GetHeaderItem(ANativeState), ANativeState) then
    inherited;
end;

procedure TcxWinXPLookAndFeelPainter.DrawScaledHeader(ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect;
  ANeighbors: TcxNeighbors; ABorders: TcxBorders; AState: TcxButtonState; AAlignmentHorz: TAlignment;
  AAlignmentVert: TcxAlignmentVert; AMultiLine, AShowEndEllipsis: Boolean; const AText: string; AFont: TFont;
  ATextColor, ABkColor: TColor; AScaleFactor: TdxScaleFactor; AOnDrawBackground: TcxDrawBackgroundEvent = nil;
  AIsLast: Boolean = False; AInGroupByBox: Boolean = False; ABorderWidth: Integer = 1);
var
  ATheme: TdxTheme;
  R: TRect;
begin
  ATheme := OpenTheme(totHeader, AScaleFactor);
  if ATheme <> 0 then
  begin
    DrawScaledHeader(ACanvas, ABounds, AState, ANeighbors, ABorders, AScaleFactor, AIsLast, AInGroupByBox);
    R := ATextAreaBounds;
    if AState = cxbsPressed then
      OffsetRect(R, 1, 1);
    DrawContent(ACanvas, ATheme, HP_HEADERITEM, ButtonStateToHeaderState[AState], ABounds, R,
      AAlignmentHorz, AAlignmentVert, AMultiLine, AShowEndEllipsis, False, AText, AFont, ATextColor, ABkColor);
  end
  else
    inherited;
end;

procedure TcxWinXPLookAndFeelPainter.DrawHeaderPressed(ACanvas: TcxCanvas; const ABounds: TRect);
begin
end;

procedure TcxWinXPLookAndFeelPainter.DrawScaledHeaderControlSection(
  ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect;
  ANeighbors: TcxNeighbors; ABorders: TcxBorders; AState: TcxButtonState;
  AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert; AMultiLine,
  AShowEndEllipsis: Boolean; const AText: string; AFont: TFont; ATextColor,
  ABkColor: TColor; AScaleFactor: TdxScaleFactor);
begin
  ACanvas.Brush.Color := clBtnFace;
  ACanvas.FillRect(ABounds);
  DrawScaledHeader(ACanvas, ABounds, ATextAreaBounds, [nRight], ABorders, AState, AAlignmentHorz,
    AAlignmentVert, AMultiLine, AShowEndEllipsis, AText, AFont, ATextColor, ABkColor, AScaleFactor);
end;

procedure TcxWinXPLookAndFeelPainter.DrawScaledSortingMark(
  ACanvas: TcxCanvas; const R: TRect; AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor);
begin
  DrawSortingArrow(ACanvas, R, clBtnShadow, clBtnShadow, AAscendingSorting, AScaleFactor);
end;

procedure TcxWinXPLookAndFeelPainter.DrawScaledSummarySortingMark(ACanvas: TcxCanvas;
  const R: TRect; AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor);
begin
  DrawSummarySortingArrow(ACanvas, R, clBtnShadow, clBtnShadow, AAscendingSorting, AScaleFactor);
end;

function TcxWinXPLookAndFeelPainter.HeaderBorderSize: Integer;
var
  ATheme: TdxTheme;
  R: TRect;
begin
  ATheme := OpenTheme(totHeader);
  if ATheme <> 0 then
  begin
    R := Rect(0, 0, 100, 100);
    GetThemeBackgroundContentRect(ATheme, 0, HP_HEADERITEM, HIS_NORMAL, R, R);
    Result := Max((R.Left + R.Top) div 2, 1);
  end
  else
    Result := inherited HeaderBorderSize;
end;

function TcxWinXPLookAndFeelPainter.HeaderControlSectionBorderSize(AState: TcxButtonState = cxbsNormal): Integer;
begin
  Result := HeaderBorderSize;
end;

function TcxWinXPLookAndFeelPainter.HeaderControlSectionContentBounds(const ABounds: TRect; AState: TcxButtonState): TRect;
begin
  if OpenTheme(totHeader) <> 0 then
    Result := cxRectInflate(ABounds, -HeaderBorderSize)
  else
    Result := inherited HeaderControlSectionContentBounds(ABounds, AState);
end;

function TcxWinXPLookAndFeelPainter.IsHeaderHotTrack: Boolean;
begin
  Result := True;
end;

function TcxWinXPLookAndFeelPainter.ScaledSortingMarkSize(AScaleFactor: TdxScaleFactor): TPoint;
begin
  Result := AScaleFactor.Apply(Point(7, 8));
end;

procedure TcxWinXPLookAndFeelPainter.DrawFilterRowSeparator(ACanvas: TcxCanvas; const ARect: TRect; ABackgroundColor: TColor);
begin
  inherited DrawFilterRowSeparator(ACanvas, ARect, ABackgroundColor);
  if IsWin10OrLater then
    ACanvas.FrameRect(ARect, DefaultGridLineColor, 1, [bTop, bRight, bBottom]);
end;

procedure TcxWinXPLookAndFeelPainter.DrawFooterBorder(ACanvas: TcxCanvas; const R: TRect;
  const ABorders: TcxBorders; AScaleFactor, ABordersScaleFactor: TdxScaleFactor);
var
  ATheme: TdxTheme;
begin
  ATheme := OpenTheme(totEdit);
  if ATheme <> 0 then
    DrawThemeEdge(ATheme, ACanvas.Handle, 0, 0, @R, BDR_RAISEDINNER, BF_RECT, nil)
  else
    inherited;
end;

procedure TcxWinXPLookAndFeelPainter.DrawFooterCell(ACanvas: TcxCanvas; const ABounds: TRect;
  AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert; AMultiLine: Boolean; const AText: string;
  AFont: TFont; ATextColor, ABkColor: TColor; AOnDrawBackground: TcxDrawBackgroundEvent;
  const ABorders: TcxBorders; APaddingsScaleFactor, ABordersScaleFactor: TdxScaleFactor);
var
  ATheme: TdxTheme;
begin
  ATheme := OpenTheme(totTrackBar);
  if ATheme <> 0 then
  begin
    DrawThemeBackground(ATheme, ACanvas.Handle, TKP_TRACK, TRS_NORMAL, @ABounds);
    DrawContent(ACanvas, ATheme, TKP_TRACK, TRS_NORMAL, ABounds,
      FooterCellTextAreaBounds(ABounds, ABorders, APaddingsScaleFactor, ABordersScaleFactor),
      AAlignmentHorz, AAlignmentVert, AMultiLine, False, False, AText, AFont, ATextColor, ABkColor);
  end
  else
    inherited;
end;

function TcxWinXPLookAndFeelPainter.FooterBorderSize: Integer;
begin
  if OpenTheme(totEdit) <> 0 then
    Result := 1 //!!!
  else
    Result := inherited FooterBorderSize;
end;

function TcxWinXPLookAndFeelPainter.FooterCellBorderSize: Integer;
var
  ATheme: TdxTheme;
  R: TRect;
begin
  ATheme := OpenTheme(totTrackBar);
  if ATheme <> 0 then
    Result := R.Left
  else
    Result := inherited;
end;

function TcxWinXPLookAndFeelPainter.FooterCellBordersSizeRect(
  const ABorders: TcxBorders; AScaleFactor, ABordersScaleFactor: TdxScaleFactor): TRect;
var
  ATheme: TdxTheme;
  R: TRect;
begin
  ATheme := OpenTheme(totTrackBar);
  if ATheme <> 0 then
  begin
    R := Rect(0, 0, 100, 100);
    GetThemeBackgroundContentRect(ATheme, 0, TKP_TRACK, TRS_NORMAL, R, R);
    Result := ABordersScaleFactor.Apply(TRect.Create(
      Byte(bLeft in ABorders) * R.Left,
      Byte(bTop in ABorders) * R.Top,
      Byte(bRight in ABorders) * R.Left,
      Byte(bBottom in ABorders) * R.Top
    ));
  end
  else
    Result := inherited;
end;

function TcxWinXPLookAndFeelPainter.FooterContentOffset: Integer;
begin
  if OpenTheme(totTrackBar) <> 0 then
    Result := 1
  else
    Result := inherited FooterContentOffset;
end;

function TcxWinXPLookAndFeelPainter.FooterDrawCellsFirst: Boolean;
begin
  Result := False;
end;

function TcxWinXPLookAndFeelPainter.FooterSeparatorColor: TColor;
begin
  Result := DefaultGridLineColor;
end;

procedure TcxWinXPLookAndFeelPainter.DrawScaledFilterCloseButton(
  ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
const
  States: array[TcxButtonState] of Integer = (CBS_NORMAL, CBS_NORMAL, CBS_HOT, CBS_PUSHED, CBS_DISABLED);
var
  ATheme: TdxTheme;
begin
  ATheme := OpenTheme(totWindow, AScaleFactor);
  if ATheme <> 0 then
  begin
    DrawScaledThemeBackground(ATheme, ACanvas.Handle, WP_SMALLCLOSEBUTTON, States[AState], R, AScaleFactor,
      not (IsThemeScalingSupported or AScaleFactor.Equals(dxDefaultScaleFactor)));
  end
  else
    inherited;
end;

procedure TcxWinXPLookAndFeelPainter.DrawScaledFilterDropDownButton(
  ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AIsFilterActive: Boolean; AScaleFactor: TdxScaleFactor);
const
  States: array[TcxButtonState] of Integer =(CBXS_NORMAL, CBXS_NORMAL, CBXS_HOT, CBXS_PRESSED, CBXS_DISABLED);
begin
  if not dxDrawThemeBackground(ACanvas.Handle, totComboBox, AScaleFactor, R, CP_DROPDOWNBUTTON, States[AState]) then
    inherited;
end;

function TcxWinXPLookAndFeelPainter.ScaledFilterActivateButtonSize(AScaleFactor: TdxScaleFactor): TPoint;
var
  ASize: TSize;
begin
  if GetThemeScaledPartSize(totButton, AScaleFactor, BP_CHECKBOX, ASize, CBS_CHECKEDNORMAL) then
  begin
    Result.X := ASize.cx;
    Result.Y := ASize.cy;
  end
  else
    Result := inherited ScaledFilterActivateButtonSize(AScaleFactor);
end;

function TcxWinXPLookAndFeelPainter.ScaledFilterCloseButtonSize(AScaleFactor: TdxScaleFactor): TPoint;
var
  ADelta: Integer;
  ASize: TSize;
begin
  if OpenTheme(totWindow, AScaleFactor) <> 0 then
  begin
    ASize := ScaledSmallCloseButtonSize(AScaleFactor);
    ADelta := AScaleFactor.Apply(4);
    Result := Point(ASize.cx + ADelta, ASize.cy + ADelta);
  end
  else
    Result := inherited ScaledFilterCloseButtonSize(AScaleFactor)
end;

function TcxWinXPLookAndFeelPainter.DefaultLayoutViewContentTextColor(AState: TcxButtonState): TColor;
begin
  if OpenTheme(totTab) <> 0 then
    Result := clMenuText
  else
    Result := inherited DefaultLayoutViewContentTextColor(AState);
end;

function TcxWinXPLookAndFeelPainter.DefaultLayoutViewCaptionTextColor(
  ACaptionPosition: TcxGroupBoxCaptionPosition; AState: TcxButtonState): TColor;
begin
  if OpenTheme(totTab) <> 0 then
    Result := DefaultTabTextColor
  else
    Result := inherited DefaultLayoutViewCaptionTextColor(ACaptionPosition, AState);
end;

procedure TcxWinXPLookAndFeelPainter.LayoutViewDrawScaledRecordCaption(ACanvas: TcxCanvas; const ABounds, ATextRect: TRect;
  APosition: TcxGroupBoxCaptionPosition; AState: TcxButtonState; AScaleFactor: TdxScaleFactor;
  AColor: TColor = clDefault; const ABitmap: TBitmap = nil);
const
  States: array[TcxButtonState] of Integer = (TIS_NORMAL, TIS_NORMAL, TIS_HOT, TIS_SELECTED, TIS_FOCUSED);
var
  ATheme: TdxTheme;
begin
  LayoutViewDrawRecordBorder(ACanvas, ABounds, AState, cxBordersAll);
  ATheme := OpenTheme(totTab);
  if ATheme <> 0 then
    DrawThemedTab(ACanvas, ABounds, [], '', ATheme, States[AState], APosition <> cxgpTop, nil, clDefault, clDefault)
  else
    inherited DrawTab(ACanvas, ABounds, [], '', AState, APosition <> cxgpTop, nil, clDefault, clDefault);
end;

procedure TcxWinXPLookAndFeelPainter.LayoutViewDrawItemScaled(ACanvas: TcxCanvas;
  const ABounds: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor; ABorders: TcxBorders = []);
begin
  if AState in [cxbsHot, cxbsPressed, cxbsDisabled] then
  begin
    if dxDrawThemeBackground(ACanvas.Handle, totMenu, ABounds, MENU_POPUPITEM, IfThen(AState <> cxbsDisabled, 2, 4)) then
      Exit;
  end;
  inherited;
end;

procedure TcxWinXPLookAndFeelPainter.WinExplorerViewDrawRecord(ACanvas: TcxCanvas; const ABounds: TRect;
  AState: TcxButtonState; AColor: TColor = clDefault; const ABitmap: TBitmap = nil);
begin
  if AState in [cxbsHot, cxbsPressed, cxbsDisabled] then
  begin
    if dxDrawThemeBackground(ACanvas.Handle, totMenu, ABounds, MENU_POPUPITEM, IfThen(AState <> cxbsDisabled, 2, 4)) then
      Exit;
  end;
  inherited;
end;

function TcxWinXPLookAndFeelPainter.WinExplorerViewRecordTextColor(AState: TcxButtonState): TColor;
begin
  if OpenTheme(totTab) <> 0 then
    Result := DefaultTabTextColor
  else
    Result := inherited WinExplorerViewRecordTextColor(AState);
end;

procedure TcxWinXPLookAndFeelPainter.DrawThemedTab(ACanvas: TcxCanvas; R: TRect;
  ABorders: TcxBorders; const AText: string; ATheme: TdxTheme; AState: Integer;
  AVertical: Boolean; AFont: TFont; ATextColor, ABkColor: TColor; AShowPrefix: Boolean = False);
var
  AOriginalR, ADrawR: TRect;
  B: TBitmap;
  DC: HDC;

  procedure RotateRect(var R: TRect);
  var
    ATemp: Integer;
  begin
    ATemp := R.Right;
    R.Right := R.Bottom;
    R.Bottom := ATemp;
  end;

  procedure PrepareRects;
  begin
    ADrawR := R;
    if AVertical then
    begin
      if not (bTop in ABorders) then Dec(ADrawR.Left, 2);
      if not (bBottom in ABorders) then Inc(ADrawR.Right, 2);
    end
    else
    begin
      if not (bLeft in ABorders) then Dec(ADrawR.Left, 2);
      if not (bRight in ABorders) then Inc(ADrawR.Right, 2);
    end;
    if AState = TIS_SELECTED then
      Inc(ADrawR.Bottom)
    else
      Dec(R.Bottom);
  end;

begin
  if AVertical then
  begin
    AOriginalR := R;
    OffsetRect(R, -R.Left, -R.Top);
    RotateRect(R);
    B := TBitmap.Create;
    B.PixelFormat := pf32bit;
    B.HandleType := bmDDB;
    B.Width := R.Right;
    B.Height := R.Bottom;
    DC := B.Canvas.Handle;
  end
  else
  begin
    B := nil;
    DC := ACanvas.Handle;
  end;

  PrepareRects;
  DrawThemeBackground(ATheme, DC, TABP_TABITEM, AState, @ADrawR, @R);

  if AVertical then
  begin
    ACanvas.RotateBitmap(B, raPlus90, True);
    RotateRect(R);
    RotateRect(ADrawR);
    ACanvas.CopyRect(Bounds(AOriginalR.Left, AOriginalR.Top, R.Right, R.Bottom), B.Canvas, R);
    B.Free;
    OffsetRect(R, AOriginalR.Left, AOriginalR.Top);
    OffsetRect(ADrawR, AOriginalR.Left, AOriginalR.Top);
  end;

  if AState = TIS_SELECTED then
  begin
    if AVertical then
      Dec(ADrawR.Right, 2)
    else
      Dec(ADrawR.Bottom, 2);
  end;

  DrawContent(ACanvas, ATheme, TABP_TABITEM, AState, R, ADrawR,
    taCenter, vaCenter, False, False, AShowPrefix, AText, AFont, ATextColor, ABkColor);
end;

procedure TcxWinXPLookAndFeelPainter.DrawTab(ACanvas: TcxCanvas; R: TRect;
  ABorders: TcxBorders; const AText: string; AState: TcxButtonState; AVertical: Boolean;
  AFont: TFont; ATextColor, ABkColor: TColor; AShowPrefix: Boolean = False);
const
  States: array[TcxButtonState] of Integer = (TIS_NORMAL, TIS_NORMAL, TIS_HOT, TIS_SELECTED, TIS_DISABLED);
var
  ATheme: TdxTheme;
begin
  ATheme := OpenTheme(totTab);
  if ATheme <> 0 then
    DrawThemedTab(ACanvas, R, ABorders, AText, ATheme, States[AState], AVertical, AFont, ATextColor, ABkColor, AShowPrefix)
  else
    inherited;
end;

procedure TcxWinXPLookAndFeelPainter.DrawTabBorder(ACanvas: TcxCanvas; R: TRect;
  ABorder: TcxBorder; ABorders: TcxBorders; AVertical: Boolean);
begin
  if OpenTheme(totTab) = 0 then
    inherited;
end;

procedure TcxWinXPLookAndFeelPainter.DrawTabsRoot(ACanvas: TcxCanvas;
  const R: TRect; ABorders: TcxBorders; AVertical: Boolean);
var
  ATheme: TdxTheme;
  AContentR, AFullR: TRect;
begin
  ATheme := OpenTheme(totTab);
  if ATheme <> 0 then
  begin
    //DrawThemeParentBackground(0, ACanvas.Handle, @R);
    GetThemeBackgroundContentRect(ATheme, 0, TABP_PANE, 0, R, AContentR);
    AFullR := R;
    if AVertical then
    begin
      Inc(AFullR.Bottom, (R.Bottom - AContentR.Bottom) - (AContentR.Top - R.Top));
      Inc(AFullR.Right, 10);
    end
    else
    begin
      Inc(AFullR.Right, (R.Right - AContentR.Right) - (AContentR.Left - R.Left));
      Inc(AFullR.Bottom, 10);
    end;
    DrawThemeBackground(ATheme, ACanvas.Handle, TABP_PANE, 0, @AFullR, @R);
  end
  else
    inherited;
end;

function TcxWinXPLookAndFeelPainter.IsDrawTabImplemented(AVertical: Boolean): Boolean;
begin
  Result := (OpenTheme(totTab) <> 0) or inherited IsDrawTabImplemented(AVertical);
end;

function TcxWinXPLookAndFeelPainter.IsTabHotTrack(AVertical: Boolean): Boolean;
begin
  Result := (OpenTheme(totTab) <> 0) or inherited IsTabHotTrack(AVertical);
end;

function TcxWinXPLookAndFeelPainter.TabBorderSize(AVertical: Boolean): Integer;
begin
  if OpenTheme(totTab) <> 0 then
  begin
    {R := Rect(0, 0, 100, 100);
    GetThemeBackgroundContentRect(ATheme, 0, TABP_TABITEM, TIS_NORMAL, @R, R);}
    Result := 1;//R.Left;
  end
  else
    Result := inherited TabBorderSize(AVertical);
end;

procedure TcxWinXPLookAndFeelPainter.DrawScaledSplitter(ACanvas: TcxCustomCanvas; const ARect: TRect;
  AHighlighted, AClicked, AHorizontal: Boolean; AScaleFactor: TdxScaleFactor; AHasCloseMark: Boolean = False;
  AArrowDirection: TcxArrowDirection = adLeft);
begin
  if AHasCloseMark then
    DrawSplitterCloseMark(ACanvas, ARect, AHighlighted, AClicked, AHorizontal, AScaleFactor, AArrowDirection);
end;

procedure TcxWinXPLookAndFeelPainter.DrawScaledIndicatorItem(
  ACanvas: TcxCanvas; const R, AImageAreaBounds: TRect; AKind: TcxIndicatorKind; AColor: TColor;
  AScaleFactor: TdxScaleFactor; AOnDrawBackground: TcxDrawBackgroundEvent; ANeighbors: TcxNeighbors;
  APaintLeftSide: Boolean; AIsRightToLeft: Boolean; ABorderWidth: Integer = 1);
var
  APainter: TcxCustomLookAndFeelPainter;
begin
  if not IsWin10OrLater and cxLookAndFeelPaintersManager.GetPainter(lfsFlat, APainter) then
    APainter.DrawScaledIndicatorItem(ACanvas, R, AImageAreaBounds, AKind, AColor, AScaleFactor, AOnDrawBackground, ANeighbors, APaintLeftSide, AIsRightToLeft, ABorderWidth)
  else
    inherited DrawScaledIndicatorItem(ACanvas, R, AImageAreaBounds, AKind, AColor, AScaleFactor, AOnDrawBackground, ANeighbors, APaintLeftSide, AIsRightToLeft, ABorderWidth);
end;

function TcxWinXPLookAndFeelPainter.ScaledScrollBarMinimalThumbSize(AVertical: Boolean; AScaleFactor: TdxScaleFactor): Integer;
const
  ThumbnailKind: array[Boolean] of Integer = (SBP_THUMBBTNHORZ, SBP_THUMBBTNVERT);

  function GetThumbSize(ATheme: TdxTheme; out ASize: TSize): Boolean;
  begin
    Result := GetThemePartSize(ATheme, 0, ThumbnailKind[AVertical], SCRBS_NORMAL, TS_MIN, ASize) = S_OK;
  end;

var
  ATheme: TdxTheme;
  AThumbSize: TSize;
  AMargins: TdxPadding;
begin
  ATheme := OpenTheme(totScrollBar);
  if (ATheme <> 0) and GetThumbSize(ATheme, AThumbSize) then
  begin
    if IsWinVistaOrLater then
      AMargins := GetThemeMargins(ATheme, ThumbnailKind[AVertical], SCRBS_NORMAL, TMT_CONTENTMARGINS)
    else
      AMargins.Empty;

    if AVertical then
    begin
      Result := AThumbSize.cy;
      if IsWinVistaOrLater then
        Inc(Result, AMargins.Height);
    end
    else
    begin
      Result := AThumbSize.cx;
      if IsWinVistaOrLater then
        Inc(Result, AMargins.Width);
    end;
    Result := AScaleFactor.Apply(Result);
  end
  else
    Result := inherited ScaledScrollBarMinimalThumbSize(AVertical, AScaleFactor);
end;

procedure TcxWinXPLookAndFeelPainter.DrawScaledScrollBarSplitter(
  ACanvas: TcxCustomCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
begin
  inherited DrawScaledSplitter(ACanvas, cxTextRect(R), AState = cxbsHot, AState = cxbsPressed, False, AScaleFactor);
end;

function TcxWinXPLookAndFeelPainter.DefaultSchedulerViewContentColor: TColor;
begin
  Result := $FFFFFF;
end;

function TcxWinXPLookAndFeelPainter.DefaultSchedulerViewContentColorClassic: TColor;
begin
  Result := $D5FFFF;
end;

procedure TcxWinXPLookAndFeelPainter.DrawScaledMonthHeader(ACanvas: TcxCanvas; const ABounds: TRect; const AText: string;
  ANeighbors: TcxNeighbors; const AViewParams: TcxViewParams; AArrows: TcxArrowDirections; ASideWidth: Integer;
  AScaleFactor: TdxScaleFactor; AOnDrawBackground: TcxDrawBackgroundEvent = nil);
begin
  DrawScaledHeader(ACanvas, ABounds, ABounds, ANeighbors, cxBordersAll, cxbsNormal, taCenter,
    vaCenter, False, False, AText, AViewParams.Font, AViewParams.TextColor,
    AViewParams.Color, AScaleFactor, AOnDrawBackground, not (nRight in ANeighbors));
  DrawMonthHeaderArrows(ACanvas, ABounds, AArrows, ASideWidth, clWindowText);
end;

procedure TcxWinXPLookAndFeelPainter.DrawSchedulerScaledEventProgress(ACanvas: TcxCanvas;
  const ABounds, AProgress: TRect; AViewParams: TcxViewParams; ATransparent: Boolean; AScaleFactor: TdxScaleFactor);
var
  ATheme: TdxTheme;
begin
  ATheme := OpenTheme(totProgress, AScaleFactor);
  if ATheme <> 0 then
  begin
    DrawThemeBackground(ATheme, ACanvas.Handle, PP_BAR, 0, ABounds);
    DrawThemeBackground(ATheme, ACanvas.Handle, PP_CHUNK, 0, AProgress);
  end
  else
    inherited DrawSchedulerScaledEventProgress(ACanvas, ABounds, AProgress, AViewParams, ATransparent, AScaleFactor);
end;

function TcxWinXPLookAndFeelPainter.SchedulerEventProgressOffsets: TRect;
begin
  Result := Rect(3, 3, 3, 3);
end;

procedure TcxWinXPLookAndFeelPainter.DrawSchedulerScaledNavigatorButton(
  ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
const
  ButtonStates: array[TcxButtonState] of Integer = (TS_HOT, TS_HOT, TS_CHECKED, TS_PRESSED, TS_DISABLED);
begin
  if not dxDrawThemeBackground(ACanvas.Handle, totToolBar, AScaleFactor, R, TP_BUTTON, ButtonStates[AState]) then
    inherited;
end;

procedure TcxWinXPLookAndFeelPainter.DrawSchedulerSplitterBorder(
  ACanvas: TcxCanvas; R: TRect; const AViewParams: TcxViewParams; AIsHorizontal: Boolean);
var
  AColor: TColor;
begin
  if (OpenTheme(totListView) <> 0) and cxGetThemeColor(totComboBox, CP_DROPDOWNBUTTON, CBXS_NORMAL, TMT_BORDERCOLOR, AColor) then
  begin
    ACanvas.SetBrushColor(AColor);
    if AIsHorizontal then
    begin
      ACanvas.FillRect(Rect(R.Left, R.Top, R.Right, R.Top + 1));
      ACanvas.FillRect(Rect(R.Left, R.Bottom - 1, R.Right, R.Bottom));
      InflateRect(R, 1, -1);
    end
    else
    begin
      ACanvas.FillRect(Rect(R.Left, R.Top, R.Left + 1, R.Bottom));
      ACanvas.FillRect(Rect(R.Right - 1, R.Top, R.Right, R.Bottom));
      InflateRect(R, -1, 1);
    end;
    ACanvas.FillRect(R, AViewParams);
  end
  else
    inherited DrawSchedulerSplitterBorder(ACanvas, R, AViewParams, AIsHorizontal);
end;

function TcxWinXPLookAndFeelPainter.ScaledSizeGripSize(AScaleFactor: TdxScaleFactor): TSize;
var
  AScaleSource: TdxThemeSizeScaleSource;
begin
  if IsWin8OrLater then
    AScaleSource := tssThemeDpi
  else if IsWinVistaOrLater then
    AScaleSource := tssSystemDpi
  else
    AScaleSource := tssNoScaling;

  if not GetThemeScaledPartSize(totScrollBar, AScaleFactor, SBP_SIZEBOX, Result, SZB_RIGHTALIGN, AScaleSource) then
    Result := inherited ScaledSizeGripSize(AScaleFactor);
end;

procedure TcxWinXPLookAndFeelPainter.DoDrawSizeGrip(ACanvas: TcxCanvas; const ARect: TRect; AScaleFactor: TdxScaleFactor);
begin
  if not dxDrawThemeBackground(ACanvas.Handle, totScrollBar, AScaleFactor, ARect, SBP_SIZEBOX, SZB_RIGHTALIGN) then
    inherited;
end;

function TcxWinXPLookAndFeelPainter.DoGetSmallCloseButtonSize: TSize;
var
  ATheme: TdxTheme;
begin
  ATheme := OpenTheme(totWindow);
  if ATheme <> 0 then
  begin
    GetThemePartSize(ATheme, 0, WP_SMALLCLOSEBUTTON, CBXS_NORMAL, TS_TRUE, Result);
    if IsWin8OrLater and ((Result.cx < 10) or (Result.cy < 10)) then
      Result := Size(13, 13);
  end
  else
    Result := inherited DoGetSmallCloseButtonSize;
end;

procedure TcxWinXPLookAndFeelPainter.DrawGroupBoxScaledFrame(ACanvas: TcxCanvas; R: TRect; AEnabled: Boolean;
  ACaptionPosition: TcxGroupBoxCaptionPosition; AScaleFactor: TdxScaleFactor; ABorders: TcxBorders = cxBordersAll);
const
  StateMap: array[Boolean] of Integer = (GBS_DISABLED, GBS_NORMAL);
begin
  if not dxDrawThemeBackground(ACanvas.Handle, totButton, R, BP_GROUPBOX, StateMap[AEnabled]) then
    inherited DrawGroupBoxScaledFrame(ACanvas, R, AEnabled, ACaptionPosition, AScaleFactor, ABorders);
end;

function TcxWinXPLookAndFeelPainter.GroupBoxTextColor(AEnabled: Boolean; ACaptionPosition: TcxGroupBoxCaptionPosition): TColor;
const
  GroupBoxStateMap: array[Boolean] of Integer = (GBS_DISABLED, GBS_NORMAL);
begin
  if not cxGetThemeColor(totButton, BP_GROUPBOX, GroupBoxStateMap[AEnabled], TMT_TEXTCOLOR, Result) then
    Result := inherited GroupBoxTextColor(AEnabled, ACaptionPosition);
end;

procedure TcxWinXPLookAndFeelPainter.DrawPanelBackground(
  ACanvas: TcxCanvas; AControl: TWinControl; ABounds: TRect; AColorFrom, AColorTo: TColor);
begin
  if AColorFrom <> clDefault then
    ACanvas.FillRect(ABounds, AColorFrom)
  else
    cxDrawTransparentControlBackground(AControl, ACanvas, ABounds);
end;

procedure TcxWinXPLookAndFeelPainter.DrawEditPopupWindowBorder(
  ACanvas: TcxCanvas; var R: TRect; ABorderStyle: TcxEditPopupBorderStyle; AClientEdge: Boolean);
begin
  if IsWinVistaOrLater then
    dxDrawThemeBackground(ACanvas.Handle, totListBox, R, LBCP_BORDER_NOSCROLL, LBPSN_HOT)
  else
    ACanvas.FrameRect(R, clBtnText);

  InflateRect(R, -1, -1);
end;

function TcxWinXPLookAndFeelPainter.GetEditPopupWindowBorderWidth(AStyle: TcxEditPopupBorderStyle): Integer;
begin
  Result := 1;
end;

function TcxWinXPLookAndFeelPainter.GetEditPopupWindowClientEdgeWidth(AStyle: TcxEditPopupBorderStyle): Integer;
begin
  Result := 2;
end;

function TcxWinXPLookAndFeelPainter.GetHintBorderColor: TColor;
begin
  if OpenTheme(totToolTip) <> 0 then
    Result := clWindowFrame
  else
    Result := inherited GetHintBorderColor;
end;

function TcxWinXPLookAndFeelPainter.GetScaledZoomInButtonSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  if not NativeZoomButtonGetMinSize(ZoomInButtonGlyph, AScaleFactor, Result) then
    Result := inherited GetScaledZoomInButtonSize(AScaleFactor);
end;

function TcxWinXPLookAndFeelPainter.GetScaledZoomOutButtonSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  if not NativeZoomButtonGetMinSize(ZoomOutButtonGlyph, AScaleFactor, Result) then
    Result := inherited GetScaledZoomOutButtonSize(AScaleFactor);
end;

procedure TcxWinXPLookAndFeelPainter.DrawScaledZoomInButton(
  ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
begin
  if not NativeZoomButtonDraw(ACanvas, R, AState, AScaleFactor, ZoomInButtonGlyph) then
    inherited DrawScaledZoomInButton(ACanvas, R, AState, AScaleFactor);
end;

procedure TcxWinXPLookAndFeelPainter.DrawScaledZoomOutButton(
  ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
begin
  if not NativeZoomButtonDraw(ACanvas, R, AState, AScaleFactor, ZoomOutButtonGlyph) then
    inherited DrawScaledZoomOutButton(ACanvas, R, AState, AScaleFactor);
end;

procedure TcxWinXPLookAndFeelPainter.DrawHintBackground(ACanvas: TcxCanvas; const ARect: TRect; AColor: TColor);
begin
  if not dxDrawThemeBackground(ACanvas.Handle, totToolTip, cxRectInflate(ARect, 4), TTP_STANDARD, 1) then
    inherited DrawHintBackground(ACanvas, ARect, AColor);
end;

function TcxWinXPLookAndFeelPainter.ScreenTipGetDescriptionTextColor: TColor;
begin
  if not cxGetThemeColor(totToolTip, TTP_STANDARD, 1, TMT_TEXTCOLOR, Result) then
    Result := inherited ScreenTipGetDescriptionTextColor;
end;

function TcxWinXPLookAndFeelPainter.ScreenTipGetTitleTextColor: TColor;
begin
  Result := ScreenTipGetDescriptionTextColor;
end;

procedure TcxWinXPLookAndFeelPainter.CorrectThumbRect(ACanvas: TcxCanvas; var ARect: TRect;
  AHorizontal: Boolean; ATicks: TcxTrackBarTicksAlign; AScaleFactor: TdxScaleFactor);
var
  ATheme: TdxTheme;
  AThumbSize: TSize;
begin
  ATheme := OpenTheme(totTrackBar, AScaleFactor);
  if ATheme <> 0 then
  begin
    GetThemePartSize(ATheme, ACanvas.Handle, TrackBarThumbThemeParts[ATicks, AHorizontal], TUS_NORMAL, ARect, TS_DRAW, AThumbSize);
    ARect := cxRectCenter(ARect, AThumbSize);
  end
  else
    inherited;
end;

procedure TcxWinXPLookAndFeelPainter.DrawTrackBarScaledTrack(ACanvas: TcxCanvas; const ARect, ASelection: TRect;
  AShowSelection, AEnabled, AHorizontal: Boolean; ATrackColor: TColor; AScaleFactor: TdxScaleFactor);
const
  TrackTypeMap: array[Boolean] of Byte = (TKP_TRACKVERT, TKP_TRACK);
begin
  if not dxDrawThemeBackground(ACanvas.Handle, totTrackBar, AScaleFactor, ARect, TrackTypeMap[AHorizontal], TUS_NORMAL) then
    inherited;
end;

procedure TcxWinXPLookAndFeelPainter.DrawTrackBarScaledThumb(ACanvas: TcxCanvas; const ARect: TRect;
  AState: TcxButtonState; AHorizontal: Boolean; ATicks: TcxTrackBarTicksAlign; AThumbColor: TColor;
  AScaleFactor: TdxScaleFactor);
const
  StateMap: array[TcxButtonState] of Byte = (
    TUS_HOT, TUS_NORMAL, TUS_HOT, TUS_PRESSED, TUS_DISABLED
  );
var
  ATheme: TdxTheme;
begin
  ATheme := OpenTheme(totTrackBar, AScaleFactor);
  if ATheme <> 0 then
    DrawScaledThemeBackground(ATheme, ACanvas.Handle,
      TrackBarThumbThemeParts[ATicks, AHorizontal],
      StateMap[AState], ARect, AScaleFactor)
  else
    inherited DrawTrackBarScaledThumb(ACanvas, ARect, AState, AHorizontal, ATicks, AThumbColor, AScaleFactor);
end;

procedure TcxWinXPLookAndFeelPainter.DrawRangeTrackBarScaledLeftThumb(ACanvas: TcxCanvas; const ARect: TRect;
  AState: TcxButtonState; AHorizontal: Boolean; ATicks: TcxTrackBarTicksAlign; AThumbColor: TColor;
  AScaleFactor: TdxScaleFactor);
begin
  DrawNativeRangeTrackBarThumb(ACanvas, ARect, AState, AHorizontal, ATicks, AThumbColor, AScaleFactor);
end;

procedure TcxWinXPLookAndFeelPainter.DrawRangeTrackBarScaledRightThumb(ACanvas: TcxCanvas;
  const ARect: TRect; AState: TcxButtonState; AHorizontal: Boolean; ATicks: TcxTrackBarTicksAlign;
  AThumbColor: TColor; AScaleFactor: TdxScaleFactor);
begin
  DrawNativeRangeTrackBarThumb(ACanvas, ARect, AState, AHorizontal, ATicks, AThumbColor, AScaleFactor);
end;

procedure TcxWinXPLookAndFeelPainter.DrawDateNavigatorDateHeader(ACanvas: TcxCanvas; var R: TRect);
begin
  DrawThemeBackground(OpenTheme(totHeader), ACanvas.Handle, HP_HEADERITEMLEFT, HIS_NORMAL, R);
end;

function TcxWinXPLookAndFeelPainter.NavigatorButtonPressedGlyphOffset: TPoint;
begin
  Result := cxNullPoint;
end;

function TcxWinXPLookAndFeelPainter.NativeZoomButtonDraw(ACanvas: TcxCanvas;
  const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor; AGlyph: TBitmap): Boolean;
var
  ATheme: TdxTheme;
  ADrawMode: TcxImageDrawMode;
begin
  ATheme := OpenTheme(totButton, AScaleFactor);
  Result := ATheme <> 0;
  if Result then
  begin
    DrawThemeBackground(ATheme, ACanvas.Handle, BP_PUSHBUTTON, BtnStateToXPBtnState(AState), R);
    if AState = cxbsDisabled then
      ADrawMode := idmFaded
    else
      ADrawMode := idmNormal;
    TdxImageDrawer.DrawImage(ACanvas, R, AGlyph, nil, -1, ifmNormal, ADrawMode, True, nil, AScaleFactor);
  end;
end;

function TcxWinXPLookAndFeelPainter.NativeZoomButtonGetMinSize(
  AGlyph: TBitmap; AScaleFactor: TdxScaleFactor; out ASize: TSize): Boolean;
var
  AMargins: TdxPadding;
  ATheme: TdxTheme;
begin
  ATheme := OpenTheme(totButton, AScaleFactor);
  Result := ATheme <> 0;
  if Result then
  begin
    AMargins := GetThemeMargins(ATheme, BP_PUSHBUTTON, 0, TMT_CONTENTMARGINS);
    ASize.Init(AGlyph.Width + AMargins.Width, AGlyph.Height + AMargins.Height);
    ASize := AScaleFactor.Apply(ASize);
  end;
end;

function TcxWinXPLookAndFeelPainter.NavigatorScaledButtonMinSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  Result := AScaleFactor.Apply(Size(18, 19));
end;

function TcxWinXPLookAndFeelPainter.DropDownListBoxItemTextColor(ASelected: Boolean): TColor;
begin
  if not cxGetThemeColor(totMenu, MENU_POPUPITEM, MPI_NORMAL, TMT_TEXTCOLOR, Result) then
    Result := inherited DropDownListBoxItemTextColor(ASelected);
end;

function TcxWinXPLookAndFeelPainter.DropDownListBoxScaledSeparatorSize(AScaleFactor: TdxScaleFactor): Integer;
var
  ASize: TSize;
begin
  if GetThemeScaledPartSize(totMenu, AScaleFactor, MENU_POPUPSEPARATOR, ASize, 0, tssNoScaling) then
    Result := ASize.cy
  else
    Result := inherited DropDownListBoxScaledSeparatorSize(AScaleFactor);
end;

procedure TcxWinXPLookAndFeelPainter.DrawDropDownListBoxBackground(
  ACanvas: TcxCanvas; const ARect: TRect; AHasBorders: Boolean);

  function GetMenuEdgeColor(ATheme: TdxTheme; APropID: Integer; ADefaultColor: TColor): TColor;
  var
    AColor: TColor;
  begin
    if cxGetThemeColor(totMenu, MENU_POPUPBACKGROUND, 0, APropID, AColor) then
      Result := AColor
    else
      Result := ADefaultColor;
  end;

var
  ATheme: TdxTheme;
  R: TRect;
begin
  if AreVisualStylesAvailable then
  begin
    R := ARect;
    ATheme := OpenTheme(totMenu);
    if AHasBorders then
    begin
      ACanvas.FrameRect(R, GetMenuEdgeColor(ATheme, TMT_EDGELIGHTCOLOR, clBtnShadow));
      R.Inflate(-1, -1);
      ACanvas.FrameRect(R, GetMenuEdgeColor(ATheme, TMT_EDGEHIGHLIGHTCOLOR, clBtnHighlight));
      R.Inflate(-1, -1);
    end;
    if ATheme <> 0 then
      DrawThemeBackground(ATheme, ACanvas.Handle, MENU_POPUPBACKGROUND, 0, R, nil)
    else
      ACanvas.FillRect(R, clWindow);
  end
  else
    inherited DrawDropDownListBoxBackground(ACanvas, ARect, AHasBorders);
end;

procedure TcxWinXPLookAndFeelPainter.DrawDropDownListBoxScaledGutterBackground(
  ACanvas: TcxCanvas; const ARect: TRect; AScaleFactor: TdxScaleFactor);
begin
  if not dxDrawThemeBackground(ACanvas.Handle, totMenu, AScaleFactor, ARect, MENU_POPUPGUTTER, 0) then
    inherited DrawDropDownListBoxScaledGutterBackground(ACanvas, ARect, AScaleFactor);
end;

procedure TcxWinXPLookAndFeelPainter.DrawDropDownListBoxScaledSelection(
  ACanvas: TcxCanvas; const ARect, AGutterRect: TRect; AScaleFactor: TdxScaleFactor);
begin
  if not dxDrawThemeBackground(ACanvas.Handle, totMenu, AScaleFactor, ARect, MENU_POPUPITEM, MPI_HOT) then
    inherited DrawDropDownListBoxScaledSelection(ACanvas, ARect, AGutterRect, AScaleFactor);
end;

procedure TcxWinXPLookAndFeelPainter.DrawDropDownListBoxScaledSeparator(
  ACanvas: TcxCanvas; const ARect, AGutterRect: TRect; AScaleFactor: TdxScaleFactor);
var
  ASize: TSize;
  ATheme: TdxTheme;
  R: TRect;
begin
  ATheme := OpenTheme(totMenu, AScaleFactor);
  if ATheme <> 0 then
  begin
    GetThemePartSize(ATheme, ACanvas.Handle, MENU_POPUPSEPARATOR, 0, nil, TS_TRUE, @ASize);
    R := cxRectCenterVertically(ARect, ASize.cy);
    R.Left := AGutterRect.Right + 2;
    DrawThemeBackground(ATheme, ACanvas.Handle, MENU_POPUPSEPARATOR, 0, R, nil);
  end
  else
    inherited DrawDropDownListBoxScaledSeparator(ACanvas, ARect, AGutterRect, AScaleFactor);
end;

function TcxWinXPLookAndFeelPainter.ProgressBarTextColor(APart: TcxProgressBarPart = pbpBackground): TColor;
begin
  if AreVisualStylesAvailable(totProgress) then
  begin
    if APart = pbpBackground then
      Result := clWindowText
    else
      Result := clHighlightText;
  end
  else
    Result := inherited ProgressBarTextColor(APart);
end;

function TcxWinXPLookAndFeelPainter.BreadcrumbEditBackgroundColor(AState: TdxBreadcrumbEditState): TColor;
begin
  Result := DefaultContentColor;
end;

function TcxWinXPLookAndFeelPainter.BreadcrumbEditIsFadingSupports: Boolean;
begin
  Result := True;
end;

function TcxWinXPLookAndFeelPainter.BreadcrumbEditProgressChunkTextColor: TColor;
begin
  Result := clHighlightText;
end;

function TcxWinXPLookAndFeelPainter.BreadcrumbEditScaledProgressChunkPadding(AScaleFactor: TdxScaleFactor): TRect;
begin
  Result := cxNullRect;
end;

function TcxWinXPLookAndFeelPainter.BreadcrumbEditScaledProgressChunkOverlaySize(AScaleFactor: TdxScaleFactor): TSize;
begin
  if not (IsWinVistaOrLater and GetThemeScaledPartSize(totProgress, AScaleFactor, PP_MOVEOVERLAY, Result, 0, tssSystemDpi)) then
    Result := inherited BreadcrumbEditScaledProgressChunkOverlaySize(AScaleFactor);
end;

function TcxWinXPLookAndFeelPainter.BreadcrumbEditBordersSize: TRect;
begin
  Result := cxSimpleRect;
end;

function TcxWinXPLookAndFeelPainter.BreadcrumbEditScaledButtonContentOffsets(
  AIsFirst, AIsLast: Boolean; AScaleFactor: TdxScaleFactor): TRect;
var
  ATheme: TdxTheme;
begin
  ATheme := OpenTheme(totButton);
  if ATheme <> 0 then
    Result := AScaleFactor.Apply(GetThemeMargins(ATheme, BP_PUSHBUTTON, 0, TMT_CONTENTMARGINS), dxSystemScaleFactor)
  else
    Result := inherited BreadcrumbEditScaledButtonContentOffsets(AIsFirst, AIsLast, AScaleFactor);
end;

procedure TcxWinXPLookAndFeelPainter.DrawBreadcrumbEditBorders(
  ACanvas: TcxCanvas; const ARect: TRect; ABorders: TcxBorders; AState: TdxBreadcrumbEditState);
const
  PartsMap: array[Boolean] of Integer = (EP_EDITTEXT, EP_EDITBORDER_NOSCROLL);
  StatesMap: array[TdxBreadcrumbEditState] of Integer =
    (ETS_NORMAL, ETS_FOCUSED, ETS_HOT, ETS_DISABLED);

  function ExcludeBorders(const R: TRect; const ASizingMargins: TdxMargins): TRect;
  begin
    Result := R;
    if not (bLeft in ABorders) then
      Dec(Result.Left, ASizingMargins.cxLeftWidth);
    if not (bTop in ABorders) then
      Dec(Result.Top, ASizingMargins.cyTopHeight);
    if not (bRight in ABorders) then
      Inc(Result.Right, ASizingMargins.cxRightWidth);
    if not (bBottom in ABorders) then
      Inc(Result.Bottom, ASizingMargins.cyBottomHeight);
  end;

  procedure DoDrawBorders(ATheme: TdxTheme; const R: TRect);
  begin
    DrawThemeBackground(ATheme, ACanvas.Handle, PartsMap[IsWinVistaOrLater], StatesMap[AState], R);
  end;

var
  AMargins: TdxMargins;
  ATheme: TdxTheme;
begin
  ATheme := OpenTheme(totEdit);
  if ATheme = 0 then
    inherited DrawBreadcrumbEditBorders(ACanvas, ARect, ABorders, AState)
  else
    if ABorders <> cxBordersAll then
    begin
      ACanvas.SaveClipRegion;
      try
        ACanvas.IntersectClipRect(ARect);
        GetThemeMargins(ATheme, 0, PartsMap[IsWinVistaOrLater], 0, TMT_SIZINGMARGINS, nil, AMargins);
        DoDrawBorders(ATheme, ExcludeBorders(ARect, AMargins));
      finally
        ACanvas.RestoreClipRegion;
      end;
    end
    else
      DoDrawBorders(ATheme, ARect);
end;

procedure TcxWinXPLookAndFeelPainter.DrawBreadcrumbEditScaledButtonAreaSeparator(
  ACanvas: TcxCanvas; const ARect: TRect; AState: TdxBreadcrumbEditState; AScaleFactor: TdxScaleFactor);
begin
end;

procedure TcxWinXPLookAndFeelPainter.DrawBreadcrumbEditScaledButton(
  ACanvas: TcxCanvas; const ARect: TRect; AState: TdxBreadcrumbEditButtonState;
  AIsFirst, AIsLast: Boolean; AScaleFactor: TdxScaleFactor);

  function GetContentMargins: TRect;
  begin
    Result := BreadcrumbEditScaledButtonContentOffsets(AIsFirst, AIsLast, AScaleFactor);
    Result.Left := 1;
    Result.Right := 1;
  end;

const
  StateMap: array[TdxBreadcrumbEditButtonState] of Integer = (-1, PBS_NORMAL, PBS_HOT, PBS_PRESSED, -1);
var
  ATheme: TdxTheme;
begin
  ATheme := OpenTheme(totButton, AScaleFactor);
  if ATheme = 0 then
    inherited DrawBreadcrumbEditScaledButton(ACanvas, ARect, AState, AIsFirst, AIsLast, AScaleFactor)
  else
    if StateMap[AState] >= 0 then
    begin
      ACanvas.SaveClipRegion;
      try
        ACanvas.IntersectClipRect(ARect);
        DrawThemeBackground(ATheme, ACanvas.Handle, BP_PUSHBUTTON, StateMap[AState], cxRectInflate(ARect, GetContentMargins));
      finally
        ACanvas.RestoreClipRegion;
      end;
    end;
end;

procedure TcxWinXPLookAndFeelPainter.DrawBreadcrumbEditScaledDropDownButton(
  ACanvas: TcxCanvas; const ARect: TRect; AState: TdxBreadcrumbEditButtonState;
  AIsInEditor: Boolean; AScaleFactor: TdxScaleFactor);
begin
  DrawBreadcrumbEditScaledButton(ACanvas, ARect, AState, True, True, AScaleFactor);
end;

procedure TcxWinXPLookAndFeelPainter.DrawBreadcrumbEditScaledNode(ACanvas: TcxCanvas; const R: TRect;
  AState: TdxBreadcrumbEditButtonState; AHasDelimiter: Boolean; AScaleFactor: TdxScaleFactor);
const
  BordersMap: array[Boolean] of TcxBorders = ([bLeft, bRight], [bLeft]);
begin
  if OpenTheme(totButton) <> 0 then
    DrawBreadcrumbEditNodePart(ACanvas, R, AState, BordersMap[AHasDelimiter], AScaleFactor)
  else
    inherited DrawBreadcrumbEditScaledNode(ACanvas, R, AState, AHasDelimiter, AScaleFactor);
end;

procedure TcxWinXPLookAndFeelPainter.DrawBreadcrumbEditScaledNodeDelimiter(
  ACanvas: TcxCanvas; const R: TRect; AState: TdxBreadcrumbEditButtonState; AScaleFactor: TdxScaleFactor);
begin
  if OpenTheme(totButton) <> 0 then
    DrawBreadcrumbEditNodePart(ACanvas, R, AState, [bLeft, bRight], AScaleFactor)
  else
    inherited DrawBreadcrumbEditScaledNodeDelimiter(ACanvas, R, AState, AScaleFactor);
end;

class procedure TcxWinXPLookAndFeelPainter.DrawScaledThemeBackground(ATheme: TdxTheme; DC: HDC; APartId, AStateId: Integer;
  const R: TRect; AScaleFactor: TdxScaleFactor; AForceScale: Boolean = False; AUseThemePartSize: Boolean = True);
var
  ABitmap: TcxBitmap32;
  APartSize: TSize;
  AThemeScaleFactor: TdxScaleFactor;
begin
  AThemeScaleFactor := GetThemeScaleFactor(ATheme);
  if AForceScale or not AScaleFactor.Equals(AThemeScaleFactor) then
  begin
    if AUseThemePartSize then
      GetThemePartSize(ATheme, 0, APartId, AStateId, TS_TRUE, APartSize)
    else
      APartSize := AThemeScaleFactor.Apply(R.Size, AScaleFactor);

    ABitmap := TcxBitmap32.CreateSize(APartSize.cx, APartSize.cy, True);
    try
      DrawThemeBackground(ATheme, ABitmap.Canvas.Handle, APartId, AStateId, ABitmap.ClientRect);
      ABitmap.RecoverTransparency(ABitmap.Canvas.Pixels[0, ABitmap.Height]);
      cxAlphaBlend(DC, ABitmap, R, ABitmap.ClientRect, True);
    finally
      ABitmap.Free;
    end;
  end
  else
    DrawThemeBackground(ATheme, DC, APartId, AStateId, R);
end;

procedure TcxWinXPLookAndFeelPainter.DoDrawScaledButtonCaption(
  ACanvas: TcxCanvas; R: TRect; const ACaption: string; AState: TcxButtonState; ATextColor: TColor;
  ADrawBorder, AIsToolButton, AWordWrap: Boolean; AScaleFactor: TdxScaleFactor; APart: TcxButtonPart);
const
  ButtonObjectType: array[Boolean] of TdxThemedObjectType = (totButton, totToolBar);
var
  ATheme: TdxTheme;
begin
  ATheme := OpenTheme(ButtonObjectType[AIsToolButton], AScaleFactor);
  if ATheme <> 0 then
    DrawThemeText(ATheme, ACanvas.Handle, BP_PUSHBUTTON,
      BtnStateToXPBtnState(AState), ACaption, -1, DT_CENTER or DT_VCENTER or DT_SINGLELINE, 0, R)
  else
    inherited;
end;

procedure TcxWinXPLookAndFeelPainter.DoDrawScaledScrollBarPart(ACanvas: TcxCustomCanvas;
  AHorizontal: Boolean; R: TRect; APart: TcxScrollBarPart; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
const
  ThumbnailKind: array[Boolean] of Integer = (SBP_THUMBBTNVERT, SBP_THUMBBTNHORZ);
  ThumbnailGripperKind: array[Boolean] of Integer = (SBP_GRIPPERVERT, SBP_GRIPPERHORZ);
  ThumbnailPage: array[Boolean, Boolean] of Integer =
    ((SBP_UPPERTRACKVERT, SBP_LOWERTRACKVERT), (SBP_UPPERTRACKHORZ, SBP_LOWERTRACKHORZ));

  function GetThumbnailState: Integer;
  begin
    case AState of
      cxbsHot:
        Result := SCRBS_HOT;
      cxbsPressed:
        Result := SCRBS_PRESSED;
      cxbsDisabled:
        Result := SCRBS_DISABLED;
      else
        Result := SCRBS_NORMAL;
    end;
  end;

  function CanDrawThumbnailGripper(ATheme: TdxTheme; AElement: Integer): Boolean;
  var
    ASize: TSize;
  begin
    Result := True;
    if GetThemePartSize(ATheme, 0, AElement, SCRBS_NORMAL, TS_TRUE, ASize) = S_OK then
      if AHorizontal then
        Result := AScaleFactor.Apply(ASize.cy) < R.Width
      else
        Result := AScaleFactor.Apply(ASize.cx) < R.Height;
  end;

  procedure DrawPageArea(ATheme: TdxTheme; const R: TRect; AState, APart: Integer);
  begin
    ACanvas.DrawNativeObject(R,
      TcxCanvasBasedResourceCacheKey.Create(Pointer(ATheme), R.Size, AState, APart),
      procedure (ACanvas: TcxGdiBasedCanvas; const R: TRect)
      begin
        DrawThemeBackground(ATheme, ACanvas.Handle, APart, AState, @R);
      end);
  end;

  procedure DrawThumbnail(ATheme: TdxTheme; const R: TRect; AState, APart: Integer);
  var
    ADrawThumbnailGripper: Boolean;
  begin
    ADrawThumbnailGripper := CanDrawThumbnailGripper(ATheme, APart);
    ACanvas.DrawNativeObject(R,
      TcxCanvasBasedResourceCacheKey.Create(Pointer(ATheme), R.Size, AState, APart),
      procedure (ACanvas: TcxGdiBasedCanvas; const R: TRect)
      begin
        DrawThemeBackground(ATheme, ACanvas.Handle, APart, AState, R);
        if ADrawThumbnailGripper then
          DrawThemeBackground(ATheme, ACanvas.Handle, ThumbnailGripperKind[AHorizontal], AState, R);
      end);
  end;

var
  ATheme: TdxTheme;
begin
  if IsRectEmpty(R) then
    Exit;

  ATheme := OpenTheme(totScrollBar, AScaleFactor);
  if ATheme = TC_NONE then
    inherited DoDrawScaledScrollBarPart(ACanvas, AHorizontal, R, APart, AState, AScaleFactor)
  else
    case APart of
      sbpLineUp, sbpLineDown:
        DrawScaledArrow(ACanvas, R, AState, GetArrowDirection(AHorizontal, APart), AScaleFactor);
      sbpPageUp, sbpPageDown:
        DrawPageArea(ATheme, R, GetThumbnailState, ThumbnailPage[AHorizontal, APart = sbpPageUp]);
      sbpThumbnail:
        DrawThumbnail(ATheme, R, GetThumbnailState, ThumbnailKind[AHorizontal]);
    end;
end;

procedure TcxWinXPLookAndFeelPainter.DrawBreadcrumbEditNodePart(
  ACanvas: TcxCanvas; const R: TRect; AState: TdxBreadcrumbEditButtonState;
  ABorders: TcxBorders; AScaleFactor: TdxScaleFactor);
const
  StateMap: array[TdxBreadcrumbEditButtonState] of Integer =
    (-1, PBS_NORMAL, PBS_HOT, PBS_PRESSED, -1);
var
  AContentExtends: TRect;
begin
  if (StateMap[AState] >= 0) and not cxRectIsEmpty(R) then
  begin
    ACanvas.SaveClipRegion;
    try
      ACanvas.IntersectClipRect(R);
      AContentExtends := BreadcrumbEditScaledButtonContentOffsets(True, True, AScaleFactor);
      if bLeft in ABorders then
        AContentExtends.Left := 1;
      if bBottom in ABorders then
        AContentExtends.Bottom := 1;
      if bRight in ABorders then
        AContentExtends.Right := 1;
      if bTop in ABorders then
        AContentExtends.Top := 1;
      DrawThemeBackground(OpenTheme(totButton, AScaleFactor), ACanvas.Handle,
        BP_PUSHBUTTON, StateMap[AState], cxRectInflate(R, AContentExtends));
    finally
      ACanvas.RestoreClipRegion;
    end;
  end;
end;

procedure TcxWinXPLookAndFeelPainter.DrawBreadcrumbEditScaledNodeDelimiterGlyph(
  ACanvas: TcxCanvas; const R: TRect; AState: TdxBreadcrumbEditButtonState;
  AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault);
var
  ADirection: TcxArrowDirection;
begin
  if AColor = clDefault then
    AColor := BreadcrumbEditNodeTextColor(AState);

  if AState = dxbcbsPressed then
    ADirection := adDown
  else if ACanvas.UseRightToLeftAlignment then
    ADirection := adLeft
  else
    ADirection := adRight;

  DrawArrow(ACanvas, cxRectInflate(R, -1, -1), ADirection, AColor);
end;

procedure TcxWinXPLookAndFeelPainter.DrawBreadcrumbEditScaledNodeMoreButtonGlyph(
  ACanvas: TcxCanvas; const R: TRect; AState: TdxBreadcrumbEditButtonState;
  AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault);
begin
  if AColor = clDefault then
    AColor := BreadcrumbEditNodeTextColor(AState);
  DrawCollapseArrow(ACanvas, R, AColor, AScaleFactor.Apply(2));
end;

procedure TcxWinXPLookAndFeelPainter.DrawBreadcrumbEditScaledProgressChunk(
  ACanvas: TcxCanvas; const R: TRect; AScaleFactor: TdxScaleFactor);
begin
  if not dxDrawThemeBackground(ACanvas.Handle, totProgress, AScaleFactor, R, PP_CHUNK, 1) then
    inherited DrawBreadcrumbEditScaledProgressChunk(ACanvas, R, AScaleFactor);
end;

procedure TcxWinXPLookAndFeelPainter.DrawBreadcrumbEditScaledProgressChunkOverlay(
  ACanvas: TcxCanvas; const R: TRect; AScaleFactor: TdxScaleFactor);
begin
  if IsWinVistaOrLater then
    dxDrawThemeBackground(ACanvas.Handle, totProgress, AScaleFactor, R, PP_MOVEOVERLAY, 0);
end;

function TcxWinXPLookAndFeelPainter.AlertWindowCornerRadius: Integer;
begin
  Result := 5;
end;

function TcxWinXPLookAndFeelPainter.GetScaledBackButtonSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  if not GetThemeScaledPartSize(totNavigation, AScaleFactor, NAV_BACKBUTTON, Result) then
    Result := inherited GetScaledBackButtonSize(AScaleFactor);
end;

procedure TcxWinXPLookAndFeelPainter.DrawScaledBackButton(
  ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
const
  StatesMap: array[TcxButtonState] of Integer = (
    NAV_BB_NORMAL, NAV_BB_NORMAL, NAV_BB_HOT, NAV_BB_PRESSED, NAV_BB_DISABLED
  );
var
  ATheme: TdxTheme;
begin
  ATheme := OpenTheme(totNavigation, AScaleFactor);
  if ATheme <> 0 then
    DrawScaledThemeBackground(ATheme, ACanvas.Handle, NAV_BACKBUTTON, StatesMap[AState], R, AScaleFactor)
  else
    inherited DrawBackButton(ACanvas, R, AState);
end;

procedure TcxWinXPLookAndFeelPainter.DrawBevelFrame(
  ACanvas: TcxCanvas; const R: TRect; AColor1, AColor2: TColor; ABoxStyle: Boolean);
begin
  if not dxDrawThemeBackground(ACanvas.Handle, totButton, R, BP_GROUPBOX, GBS_NORMAL) then
    inherited DrawBevelFrame(ACanvas, R, AColor1, AColor2, ABoxStyle);
end;

procedure TcxWinXPLookAndFeelPainter.DrawBevelLine(
  ACanvas: TcxCanvas; const R: TRect; AColor1, AColor2: TColor; AIsVertical: Boolean);
const
  PartMap: array[Boolean] of Cardinal = (TP_SEPARATORVERT, TP_SEPARATOR);
begin
  if not dxDrawThemeBackground(ACanvas.Handle, totToolBar, R, PartMap[AIsVertical], TS_NORMAL) then
    inherited DrawBevelLine(ACanvas, R, AColor1, AColor2, AIsVertical);
end;

function TcxWinXPLookAndFeelPainter.GetBevelMinimalShapeSize(AShape: TdxBevelShape): TSize;
begin
  Result.Init(6);
end;

procedure TcxWinXPLookAndFeelPainter.DrawGalleryGroupHeaderScaled(
  ACanvas: TcxCustomCanvas; const ABounds: TRect; AScaleFactor: TdxScaleFactor);
begin
  if not IsWin10OrLater then
    inherited DrawGalleryGroupHeaderScaled(ACanvas, ABounds, AScaleFactor);
end;

function TcxWinXPLookAndFeelPainter.DrawGalleryItemSelectionFirst: Boolean;
begin
  Result := (OpenTheme(totExplorerListView) <> 0) or inherited DrawGalleryItemSelectionFirst;
end;

procedure TcxWinXPLookAndFeelPainter.DrawGalleryItemSelectionScaled(ACanvas: TcxCustomCanvas;
  const R: TRect; AViewState: TdxGalleryItemViewState; AScaleFactor: TdxScaleFactor);

  function GetState: Integer;
  begin
    if AViewState.Pressed then
      Result := LIS_SELECTED
    else
      if AViewState.Checked then
      begin
        if (AViewState.Hover or AViewState.Focused) and IsWinVistaOrLater then
          Result := LIS_HOTSELECTED
        else
          Result := LIS_SELECTED
      end
      else
        if AViewState.Focused then
          Result := LIS_SELECTEDNOTFOCUS
        else
          if AViewState.Hover then
            Result := LIS_HOT
          else
            Result := LIS_NORMAL;
  end;

var
  AState: Integer;
begin
  AState := GetState;
  if AState <> LIS_NORMAL then
  begin
    if not DoDrawThemeBackground(ACanvas, totExplorerListView, nil,R, LVP_LISTITEM, AState) then
      inherited;
  end;
end;

procedure TcxWinXPLookAndFeelPainter.DrawScaledToggleSwitchState(ACanvas: TcxCanvas;
  ABounds: TRect; AState: TcxButtonState; AChecked, AFocused: Boolean; AScaleFactor: TdxScaleFactor);
begin
  dxGPPaintCanvas.BeginPaint(ACanvas.Handle, ABounds);
  try
    dxGPPaintCanvas.Rectangle(ABounds, $707070, ToggleSwitchToggleColor(AChecked), 1, psSolid, 255, 255);
  finally
    dxGPPaintCanvas.EndPaint;
  end;
end;

procedure TcxWinXPLookAndFeelPainter.DrawScaledToggleSwitchThumb(
  ACanvas: TcxCanvas; ABounds: TRect; AState: TcxButtonState; AChecked, AFocused: Boolean; AScaleFactor: TdxScaleFactor);
begin
  DrawScaledButton(ACanvas, cxRectInflate(ABounds, -1), AState, AScaleFactor);
end;

function TcxWinXPLookAndFeelPainter.ToggleSwitchToggleColor(AChecked: Boolean): TColor;
begin
  if AChecked then
    Result := $A0A0A0
  else
    Result := $C8C8C8;
end;

function TcxWinXPLookAndFeelPainter.ScaledClockSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  Result := AScaleFactor.Apply(ClockFace.Size);
end;

procedure TcxWinXPLookAndFeelPainter.DrawScaledClock(ACanvas: TcxCanvas;
  const ARect: TRect; ADateTime: TDateTime; ABackgroundColor: TColor; AScaleFactor: TdxScaleFactor);
begin
  DrawModernCalendarClock(ACanvas, ARect, ADateTime, ABackgroundColor, AScaleFactor);
end;

procedure TcxWinXPLookAndFeelPainter.DrawModernCalendarDateCellSelection(
  ACanvas: TcxCanvas; const ARect: TRect; AStates: TcxCalendarElementStates);

  function GetThemePartState(AStates: TcxCalendarElementStates): Integer;
  begin
    if cesSelected in AStates then
      if cesHot in AStates then
        Result := LIS_HOTSELECTED
      else
        if cesFocused in AStates then
          Result := LIS_SELECTED
        else
          Result := LIS_SELECTEDNOTFOCUS
    else
      if cesHot in AStates then
        Result := LIS_HOT
      else
        Result := LIS_NORMAL;
  end;

var
  ATheme: TdxTheme;
begin
  ATheme := OpenTheme(totExplorerListView);
  if ATheme <> 0 then
  begin
    if AStates * [cesHot, cesSelected] <> [] then
      DrawThemeBackground(ATheme, ACanvas.Handle, LVP_LISTITEM, GetThemePartState(AStates), ARect, nil);

    if cesMarked in AStates then
      ACanvas.FrameRect(ARect, GetModernCalendarMarkedCellBorderColor);

    if (cesFocused in AStates) and SupportsNativeFocusRect then
      ACanvas.DrawFocusRect(cxRectInflate(ARect, -1, -1));
  end
  else
    inherited;
end;

function TcxWinXPLookAndFeelPainter.GetModernCalendarHeaderTextColor(AStates: TcxCalendarElementStates): TColor;
begin
  if not cxGetThemeColor(totTextStyle, TEXT_HYPERLINKTEXT, TS_HYPERLINK_NORMAL, TMT_TEXTCOLOR, Result) then
    Result := inherited GetModernCalendarHeaderTextColor(AStates);
end;

procedure TcxWinXPLookAndFeelPainter.DrawFindPanelBorder(ACanvas: TcxCanvas; const R: TRect;
  const ABorders: TcxBorders; AScaleFactor, ABordersScaleFactor: TdxScaleFactor);
begin
end;

procedure TcxWinXPLookAndFeelPainter.DrawWheelPickerItemBackground(
  ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState);

  function GetThemePartState: Integer;
  begin
    if AState = cxbsPressed then
      Result := LIS_SELECTED
    else
      Result := LIS_SELECTEDNOTFOCUS;
  end;

begin
  if AState in [cxbsPressed, cxbsHot] then
  begin
    if dxDrawThemeBackground(ACanvas.Handle, totExplorerListView, ARect, LVP_LISTITEM, GetThemePartState) then
      Exit;
  end;
  inherited;
end;

procedure TcxWinXPLookAndFeelPainter.DrawWheelPickerItemBorder(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState);
begin
  if (OpenTheme(totExplorerListView) = 0) or not (AState in [cxbsPressed, cxbsHot]) then
    inherited;
end;

procedure TcxWinXPLookAndFeelPainter.DrawScaledTokenBackground(
  ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
const
  ButtonStateMap: array [TcxButtonState] of Integer = (-1, -1, PBS_HOT, PBS_PRESSED, -1);
var
  ATheme: TdxTheme;
begin
  ATheme := OpenTheme(totButton, AScaleFactor);
  if ATheme = 0 then
    inherited DrawScaledTokenBackground(ACanvas, R, AState, AScaleFactor)
  else
    if (ButtonStateMap[AState] >= 0) and not cxRectIsEmpty(R) then
    begin
      ACanvas.SaveClipRegion;
      try
        DrawThemeBackground(ATheme, ACanvas.Handle, BP_PUSHBUTTON, ButtonStateMap[AState],
          cxRectInflate(R, GetThemeMargins(ATheme, BP_PUSHBUTTON, 0, TMT_CONTENTMARGINS)));
      finally
        ACanvas.RestoreClipRegion;
      end;
    end;
end;

// ListView
procedure TcxWinXPLookAndFeelPainter.DrawListViewBackground(
  ACanvas: TcxCustomCanvas; ABounds: TRect; AExplorerStyle, AEnabled: Boolean);
const
  ObjectTypeMap: array[Boolean] of TdxThemedObjectType = (totListView, totItemsViewListView);
var
  AColor: TColor;
begin
  if cxGetThemeColor(ObjectTypeMap[AExplorerStyle], 0, 0, TMT_FILLCOLOR, AColor) then
    ACanvas.FillRect(ABounds, AColor)
  else
    inherited DrawListViewBackground(ACanvas, ABounds, AExplorerStyle, AEnabled);
end;

procedure TcxWinXPLookAndFeelPainter.DrawListViewFocusRect(
  ACanvas: TcxCustomCanvas; const ABounds: TRect; AExplorerStyle, AHot, AInactive: Boolean);
const
  FrameColor = $FFD199;
begin
  if AInactive then
    Exit;
  if AExplorerStyle then
  begin
    if not AHot then
      ACanvas.Rectangle(ABounds, clNone, FrameColor, psSolid);
  end
  else
    ACanvas.FocusRectangle(cxRectInflate(ABounds, -1));
end;

procedure TcxWinXPLookAndFeelPainter.DrawListViewGroupExpandButton(ACanvas: TcxCustomCanvas;
  const ABounds: TRect; AState: TcxButtonState; AExpanded: Boolean; AExplorerStyle: Boolean; AScaleFactor: TdxScaleFactor);
const
  ObjectTypeMap: array[Boolean] of TdxThemedObjectType = (totListView, totItemsViewListView);
  PartMap: array[Boolean] of Integer = (LVP_EXPANDBUTTON, LVP_COLLAPSEBUTTON);
  StateMap: array[TcxButtonState] of Integer = (1, 1, 2, 3, 1);
begin
  if not (IsWinVistaOrLater and DoDrawThemeBackground(ACanvas, ObjectTypeMap[AExplorerStyle], AScaleFactor, ABounds, PartMap[AExpanded], StateMap[AState])) then
    inherited
end;

procedure TcxWinXPLookAndFeelPainter.DrawListViewGroupHeaderBackground(ACanvas: TcxCustomCanvas;
  const ABounds: TRect; AState: TdxListViewGroupHeaderStates; AExplorerStyle: Boolean; AScaleFactor: TdxScaleFactor);

  procedure ThemedDraw(APartState: Integer);
  begin
    if not (IsWinVistaOrLater and DoDrawThemeBackground(ACanvas, totExplorerListView, nil, ABounds, LVP_GROUPHEADER, APartState)) then
      inherited DrawListViewGroupHeaderBackground(ACanvas, ABounds, AState, AExplorerStyle, AScaleFactor);
  end;

begin
  if dxlgsHot in AState then
  begin
    if dxlgsCollapsed in AState then
      ThemedDraw(LVGH_CLOSEHOT)
    else
      ThemedDraw(LVGH_OPENHOT);
  end
  else
  begin
    DrawListViewBackground(ACanvas, ABounds, AExplorerStyle, True);
    if dxlgsCollapsed in AState then
      ThemedDraw(LVGH_CLOSE)
    else
      ThemedDraw(LVGH_OPEN);
  end;
  if dxlgsFocused in AState then
    DrawListViewFocusRect(ACanvas, ABounds, AExplorerStyle, dxlgsHot in AState, dxlgsInactive in AState);
end;

procedure TcxWinXPLookAndFeelPainter.DrawListViewItemBackground(ACanvas: TcxCustomCanvas;
  const ABounds: TRect; AState: TdxListViewItemStates; AExplorerStyle: Boolean);

  procedure ThemedDraw(APartState: Integer);
  begin
    if not (IsWinVistaOrLater and DoDrawThemeBackground(ACanvas, totItemsViewListView, nil, ABounds, LVP_LISTITEM, APartState)) then
      inherited DrawListViewItemBackground(ACanvas, ABounds, AState, AExplorerStyle);
  end;

begin
  if dxlisHot in AState then
  begin
    if dxlisSelected in AState then
      ThemedDraw(LIS_HOTSELECTED)
    else
      ThemedDraw(LIS_HOT);
  end
  else
    if dxlisSelected in AState then
    begin
      if dxlisInactive in AState then
        ThemedDraw(LIS_SELECTEDNOTFOCUS)
      else
        ThemedDraw(LIS_SELECTED)
    end
    else
      DrawListViewBackground(ACanvas, ABounds, AExplorerStyle, True);

  if dxlisFocused in AState then
    DrawListViewFocusRect(ACanvas, ABounds, AExplorerStyle, dxlisHot in AState, dxlisInactive in AState);
end;

procedure TcxWinXPLookAndFeelPainter.DrawListViewSortingMark(ACanvas: TcxCustomCanvas; const R: TRect;
  AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor);
const
  States: array[Boolean] of Integer = (HSAS_SORTEDDOWN, HSAS_SORTEDUP);
begin
  if not IsWinSevenOrLater then
    inherited
  else if not DoDrawThemeBackground(ACanvas, totHeader, AScaleFactor, R, HP_HEADERSORTARROW, States[AAscendingSorting]) then
    inherited;
end;

procedure TcxWinXPLookAndFeelPainter.DrawListViewGroupHeaderLine(ACanvas: TcxCustomCanvas; const ABounds: TRect);
const
  LineColor = $E0C1B2;
begin
  ACanvas.FillRect(ABounds, LineColor);
end;

function TcxWinXPLookAndFeelPainter.GetListViewColumnHeaderTextColor(AState: TcxButtonState; AExplorerStyle: Boolean): TColor;
const
  ObjectTypeMap: array[Boolean] of TdxThemedObjectType = (totHeader, totItemsViewHeader);
  PartStateMap: array[TcxButtonState] of Integer = (HIS_NORMAL, HIS_NORMAL, HIS_HOT, HIS_PRESSED, HIS_NORMAL);
begin
  if not cxGetThemeColor(ObjectTypeMap[AExplorerStyle], HP_HEADERITEM, PartStateMap[AState], TMT_TEXTCOLOR, Result) then
    Result := inherited GetListViewColumnHeaderTextColor(AState, AExplorerStyle);
end;

function TcxWinXPLookAndFeelPainter.GetListViewColumnHeaderSortingMarkSize(AScaleFactor: TdxScaleFactor): TPoint;
var
  ASize: TSize;
begin
  if not IsWinSevenOrLater then
    Exit(inherited GetListViewColumnHeaderSortingMarkSize(AScaleFactor));
  ASize := GetThemeScaledPartSize(totHeader, AScaleFactor, HP_HEADERSORTARROW, HSAS_SORTEDDOWN);
  if ASize.IsZero then
    Result := inherited GetListViewColumnHeaderSortingMarkSize(AScaleFactor)
  else
    Result.Init(ASize);
end;

function TcxWinXPLookAndFeelPainter.GetListViewItemTextColor(AState: TdxListViewItemStates; AExplorerStyle: Boolean): TColor;
const
  ItemStates: array[Boolean] of Cardinal = (MPI_NORMAL, MPI_DISABLED);
begin
  if not cxGetThemeColor(totMenu, MENU_POPUPITEM, ItemStates[dxlisDisabled in AState], TMT_TEXTCOLOR, Result) then
    Result := inherited GetListViewItemTextColor(AState, AExplorerStyle);
end;

function TcxWinXPLookAndFeelPainter.GetListViewGroupTextColor(AKind: TdxListViewGroupTextKind;
  AState: TdxListViewGroupHeaderStates; AExplorerStyle: Boolean): TColor;
const
  PartMap: array[TdxListViewGroupTextKind] of Integer =
    (TMT_HEADING1TEXTCOLOR, TMT_HEADING2TEXTCOLOR, TMT_BODYTEXTCOLOR);

  function GetPartState: Integer;
  begin
    if dxlgsHot in AState then
      Result := LVGH_OPENHOT
    else if dxlgsFocused in AState then
      Result := LVGH_OPENSELECTED
    else
      Result := LVGH_OPEN;
  end;

const
  ObjectTypeMap: array[Boolean] of TdxThemedObjectType = (totListView, totItemsViewListView);
begin
  if not cxGetThemeColor(ObjectTypeMap[AExplorerStyle], LVP_GROUPHEADER, GetPartState, PartMap[AKind], Result) then
    Result := inherited GetListViewGroupTextColor(AKind, AState, AExplorerStyle);
end;

procedure TcxWinXPLookAndFeelPainter.DrawSpreadSheetScaledHeader(ACanvas: TcxCustomCanvas; const R: TRect;
  ANeighbors: TcxNeighbors; ABorders: TcxBorders; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
begin
  DrawScaledHeader(ACanvas, R, AState, ANeighbors, ABorders, AScaleFactor, False, False);
end;

procedure TcxWinXPLookAndFeelPainter.DrawNativeRangeTrackBarThumb(
  ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState; AHorizontal: Boolean;
  ATicks: TcxTrackBarTicksAlign; AThumbColor: TColor; AScaleFactor: TdxScaleFactor);
var
  R: TRect;
begin
  R := ARect;
  if IsWinVistaOrLater then
  begin
    if AHorizontal then
      Inc(R.Right)
    else
      Inc(R.Bottom);
  end;
  DrawTrackBarScaledThumb(ACanvas, R, AState, AHorizontal, tbtaBoth, AThumbColor, AScaleFactor);
end;

function TcxWinXPLookAndFeelPainter.DoDrawThemeBackground(ACanvas: TcxCustomCanvas;
  AThemedObjectType: TdxThemedObjectType; AScaleFactor: TdxScaleFactor; const R: TRect;
  APartId, AStateId: Integer): Boolean;
var
  AResult: HRESULT;
  ATheme: TdxTheme;
begin
  Result := False;
  ATheme := OpenTheme(AThemedObjectType, AScaleFactor);
  if ATheme <> 0 then
  begin
    ACanvas.DrawNativeObject(R,
      TcxCanvasBasedResourceCacheKey.Create(Pointer(ATheme), TSize.Create(R), AStateId, APartId),
      procedure (ACanvas: TcxGdiBasedCanvas; const R: TRect)
      begin
        AResult := DrawThemeBackground(ATheme, ACanvas.Handle, APartId, AStateId, R);
      end);
    Result := Succeeded(AResult);
  end;
end;

function TcxWinXPLookAndFeelPainter.DoDrawScaledThemeBackground(
  ACanvas: TcxCustomCanvas; AThemedObjectType: TdxThemedObjectType;
  AScaleFactor: TdxScaleFactor; const R: TRect; APartId, AStateId: Integer): Boolean;
var
  ATheme: TdxTheme;
begin
  ATheme := OpenTheme(AThemedObjectType, AScaleFactor);
  Result := ATheme <> 0;
  if Result then
  begin
    ACanvas.DrawNativeObject(R,
      TcxCanvasBasedResourceCacheKey.Create(Pointer(ATheme), TSize.Create(R), AStateId, APartId, AScaleFactor.TargetDPI),
      procedure (ACanvas: TcxGdiBasedCanvas; const R: TRect)
      begin
        DrawScaledThemeBackground(ATheme, ACanvas.Handle, APartId, AStateId, R, AScaleFactor);
      end);
  end;
end;


procedure dxAdjustToTouchableSize(var AElementSizeDimension: Integer; AScaleFactor: TdxScaleFactor = nil);
begin
  if AScaleFactor = nil then
    AScaleFactor := dxSystemScaleFactor;
  if cxIsTouchModeEnabled and (AElementSizeDimension > 0) then
    AElementSizeDimension := Max(AElementSizeDimension, AScaleFactor.Apply(cxTouchElementMinSize));
end;

procedure dxAdjustToTouchableSize(var AElementSize: TSize; AScaleFactor: TdxScaleFactor = nil);
begin
  dxAdjustToTouchableSize(AElementSize.cx, AScaleFactor);
  dxAdjustToTouchableSize(AElementSize.cy, AScaleFactor);
end;

function dxGetTouchableSize(AElementSizeDimension: Integer; AScaleFactor: TdxScaleFactor = nil): Integer;
begin
  Result := AElementSizeDimension;
  dxAdjustToTouchableSize(Result, AScaleFactor);
end;

function dxGetTouchableSize(const AElementSize: TSize; AScaleFactor: TdxScaleFactor = nil): TSize;
begin
  Result := AElementSize;
  dxAdjustToTouchableSize(Result, AScaleFactor);
end;

function dxElementSizeFitsForTouch(AElementSizeDimension: Integer): Boolean;
begin
  Result := dxElementSizeFitsForTouch(AElementSizeDimension, dxSystemScaleFactor)
end;

function dxElementSizeFitsForTouch(AElementSizeDimension: Integer; AScaleFactor: TdxScaleFactor): Boolean;
begin
  Result := AElementSizeDimension >= AScaleFactor.Apply(cxTouchElementMinSize);
end;

function cxTextRect(const R: TRect): TRect;
begin
  Result := R;
  InflateRect(Result, -cxTextOffset, -cxTextOffset);
end;

function cxGetSchedulerGroupPolygon(const R: TRect): TPoints;
var
  ARect: TRect;
  ADelta: Integer;
begin
  SetLength(Result, 6);
  ARect := cxRectInflate(R, 0, -cxTextOffset);
  Dec(ARect.Right);
  Result[0] := ARect.TopLeft;
  Result[1] := cxPoint(ARect.Right, ARect.Top);
  Result[2] := ARect.BottomRight;
  ADelta := ARect.Height div 2;
  Result[3] := cxPoint(ARect.Right - ADelta, ARect.Bottom - ADelta);
  Result[4] := cxPoint(ARect.Left + ADelta, ARect.Bottom - ADelta);
  Result[5] := cxPoint(ARect.Left, ARect.Bottom);
end;

function cxGetSchedulerMilestonePolygon(const R: TRect): TPoints;
var
  ARect: TRect;
  ASize: Integer;
  AMin: Integer;
begin
  SetLength(Result, 4);
  AMin := Min(R.Width, R.Height);
  ARect := cxRectCenter(R, AMin, AMin);
  ASize := ARect.Width;
  ASize := ASize - Integer(Odd(ASize));

  Result[0].X := ARect.Left;
  Result[0].Y := ARect.Top + ASize div 2;

  Result[1].X := ARect.Left + ASize div 2;
  Result[1].Y := ARect.Top;

  Result[2].X := ARect.Left + ASize;
  Result[2].Y := Result[0].Y;

  Result[3].X := Result[1].X;
  Result[3].Y := ARect.Top + ASize;
end;

{ TcxCustomLookAndFeelPainter }

destructor TcxCustomLookAndFeelPainter.Destroy;
begin
  ReleaseImageResources;
  inherited Destroy;
end;

function TcxCustomLookAndFeelPainter.CreateLookAndFeelPainterDetails: TObject;

  procedure LoadIcon(ADetails: TdxSkinDetails; AIcon: TdxSkinIconSize);
  const
    SuffixMap: array[TdxSkinIconSize] of string = ('16', '48');
  var
    AResName: string;
  begin
    AResName := 'CX_LOOKANDFEELSTYLEICON_' + UpperCase(LookAndFeelName) + SuffixMap[AIcon];
    if FindResource(HInstance, PChar(AResName), 'PNG') <> 0 then
      ADetails.Icons[AIcon].LoadFromResource(HInstance, AResName, 'PNG')
    else
      ADetails.ResetIcon(AIcon);
  end;

var
  ADetails: TdxSkinDetails;
begin
  ADetails := TdxSkinDetails.Create;
  ADetails.Name := LookAndFeelName;
  ADetails.DisplayName := LookAndFeelName;
  ADetails.GroupName := cxGetResourceString(@scxBuiltInLookAndFeelStyles);
  LoadIcon(ADetails, sis16);
  LoadIcon(ADetails, sis48);
  Result := ADetails;
end;

function TcxCustomLookAndFeelPainter.GetLookAndFeelPainterDetails: TObject;
begin
  if FLookAndFeelPainterDetailsCache = nil then
    FLookAndFeelPainterDetailsCache := CreateLookAndFeelPainterDetails;
  Result := FLookAndFeelPainterDetailsCache;
end;

function TcxCustomLookAndFeelPainter.DefaultDateNavigatorHeaderHighlightTextColor: TColor;
begin
  if IsWinVistaOrLater then
    Result := clHotLight
  else
    Result := clHighlightText;
end;

procedure TcxCustomLookAndFeelPainter.DoDrawDataRowLayoutContent(ACanvas: TcxCanvas; const ABounds: TRect);
begin
  ACanvas.FillRect(ABounds, GetDataRowLayoutContentColor);
end;

procedure TcxCustomLookAndFeelPainter.DoDrawScaledButtonCaption(
  ACanvas: TcxCanvas; R: TRect; const ACaption: string; AState: TcxButtonState; ATextColor: TColor;
  ADrawBorder, AIsToolButton, AWordWrap: Boolean; AScaleFactor: TdxScaleFactor; APart: TcxButtonPart);
var
  AFlags: Integer;
begin
  if ADrawBorder then
    R := cxRectInflate(R, -ButtonBorderSize(AState));

  if ATextColor = clDefault then
    ACanvas.Font.Color := ButtonSymbolColor(AState)
  else
    ACanvas.Font.Color := ATextColor;

  // for backward compatibility
  Dec(R.Bottom, Ord(Odd(R.Bottom - R.Top)));
  if R.Bottom - R.Top < 18 then
    Dec(R.Top);

  if AState = cxbsPressed then
    OffsetRect(R, ScaledButtonTextShift(AScaleFactor), ScaledButtonTextShift(AScaleFactor));

  if ACaption <> '' then
  begin
    AFlags := cxAlignVCenter or cxShowPrefix or cxAlignHCenter;
    if AWordWrap then
      AFlags := AFlags or cxWordBreak
    else
      AFlags := AFlags or cxSingleLine;

    ACanvas.Brush.Style := bsClear;
    ACanvas.DrawText(ACaption, R, AFlags, AState <> cxbsDisabled);
    ACanvas.Brush.Style := bsSolid;
  end;
end;

procedure TcxCustomLookAndFeelPainter.DoDrawScaledScrollBarPart(ACanvas: TcxCustomCanvas;
  AHorizontal: Boolean; R: TRect; APart: TcxScrollBarPart; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
begin
  case APart of
    sbpPageUp, sbpPageDown:
      ACanvas.DrawNativeObject(R,
        TcxCanvasBasedResourceCacheKey.Create(Self, TSize.Create(R), Ord(AState), Ord(APart), AScaleFactor.TargetDPI),
        procedure (ACanvas: TcxGdiBasedCanvas; const R: TRect)
        begin
          FillRect(ACanvas.Handle, R, StdScrollBrushes[AState = cxbsPressed].Handle);
        end);
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawBackground(ACanvas: TcxCanvas; const ARect: TRect;
  ATransparent: Boolean; ABackgroundColor: TColor; const ABackgroundBitmap: TBitmap);
begin
  if not ATransparent then
    ACanvas.FillRect(ARect, ABackgroundColor)
  else
    if ABackgroundBitmap <> nil then
      ACanvas.FillRect(ARect, ABackgroundBitmap);
end;

procedure TcxCustomLookAndFeelPainter.DrawButtonArrow(ACanvas: TcxCanvas; const R: TRect; AColor: TColor);
var
  P: array[0..2] of TPoint;

  procedure CalculatePoints;
  var
    ASize: TPoint;

    function _GetSize: TPoint;
    begin
      Result.X := R.Width div 2;
      if not Odd(Result.X) then Inc(Result.X);
      Result.Y := Result.X div 2 + 1;
    end;

  begin
    ASize := _GetSize;
    P[0] := Point((R.Left + R.Right - ASize.X) div 2, MulDiv(R.Top + R.Bottom - ASize.Y, 1, 2));
    P[1] := Point(P[0].X + ASize.X - 1, P[0].Y);
    P[2] := Point(P[0].X + ASize.X div 2, P[0].Y + ASize.Y - 1);
  end;

begin
  CalculatePoints;
  ACanvas.Brush.Color := AColor;
  ACanvas.Pen.Color := AColor;
  ACanvas.Polygon(P);
end;

procedure TcxCustomLookAndFeelPainter.DrawContent(ACanvas: TcxCanvas;
  const ABounds, ATextAreaBounds: TRect; AState: TcxButtonState; AAlignmentHorz: TAlignment;
  AAlignmentVert: TcxAlignmentVert; AMultiLine, AShowEndEllipsis: Boolean;
  const AText: string; AFont: TFont; ATextColor, ABkColor: TColor;
  AOnDrawBackground: TcxDrawBackgroundEvent = nil; AIsFooter: Boolean = False);
const
  MultiLines: array[Boolean] of Integer = (cxSingleLine, cxWordBreak);
  ShowEndEllipses: array[Boolean] of Integer = (0, cxShowEndEllipsis);
begin
  if not (Assigned(AOnDrawBackground) and AOnDrawBackground(ACanvas, ABounds)) then
    DrawContentBackground(ACanvas, ABounds, AState, ABkColor, AIsFooter);

  if AText <> '' then
  begin
    ACanvas.Font := AFont;
    ACanvas.Font.Color := ATextColor;
    ACanvas.Brush.Style := bsClear;
    ACanvas.DrawText(AText, ATextAreaBounds,
      cxAlignmentsHorz[AAlignmentHorz] or cxAlignmentsVert[AAlignmentVert] or
      MultiLines[AMultiLine] or ShowEndEllipses[AShowEndEllipsis]);
    ACanvas.Brush.Style := bsSolid;
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawContentBackground(ACanvas: TcxCustomCanvas;
  const R: TRect; AState: TcxButtonState; ABackgroundColor: TColor; AIsFooter: Boolean);
begin
  ACanvas.FillRect(R, ABackgroundColor);
end;

procedure TcxCustomLookAndFeelPainter.DrawExpandButtonCross(ACanvas: TcxCustomCanvas;
  const R: TRect; AExpanded: Boolean; AColor: TColor; AScaleFactor: TdxScaleFactor);
var
  ASize, X, Y: Integer;
begin
  ASize := R.Width - AScaleFactor.Apply(2) * 2;
  X := GetRangeCenter(R.Left, R.Right);
  Y := GetRangeCenter(R.Top, R.Bottom);

  ACanvas.FillRect(Rect(X - ASize div 2, Y, X + ASize div 2 + 1, Y + 1), AColor);
  if not AExpanded then
    ACanvas.FillRect(Rect(X, Y - ASize div 2, X + 1, Y + ASize div 2 + 1), AColor);
end;

procedure TcxCustomLookAndFeelPainter.DrawListViewColumnHeaderSortingArrow(ACanvas: TcxCustomCanvas; const R: TRect;
  AColor1, AColor2: TColor; AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor);
var
  Sign, AWidth, AHeight, X, Y, ALeftSide, ARightSide: Integer;
  Points: array[0..5] of TPoint;
  AColor: TColor;
begin
  Sign := 2 * Byte(AAscendingSorting) - 1;
  with GetListViewColumnHeaderSortingMarkSize(AScaleFactor) do
  begin
    AWidth := X;
    AHeight := Y;
  end;

  X := (R.Left + R.Right) div 2;
  if not Odd(AWidth) then Dec(X);
  if AAscendingSorting then
    Y := (R.Top + R.Bottom - AHeight) div 2
  else
    Y := (R.Top + R.Bottom + AHeight) div 2 - 1;

  ALeftSide := AWidth div 2;
  if not Odd(AWidth) then Dec(ALeftSide);
  ARightSide := AWidth div 2;

  Points[0].X := X + ARightSide;
  Points[0].Y := Y + Sign * (AHeight - 2);
  Points[1].X := X + ARightSide - ALeftSide;
  Points[1].Y := Y;
  Points[2].X := X + ARightSide;
  Points[2].Y := Y + Sign * (AHeight - 1);
  Points[3].X := X - ALeftSide;
  Points[3].Y := Y + Sign * (AHeight - 1);
  Points[4].X := X;
  Points[4].Y := Y;
  Points[5].X := X - ALeftSide;
  Points[5].Y := Y + Sign * (AHeight - Ord(Odd(AWidth)));

  AColor := AColor2;
  ACanvas.Line(Points[0], Points[1], AColor);
  ACanvas.Line(Points[1], Points[2], AColor);
  if not AAscendingSorting then
    AColor := AColor1;
  ACanvas.Line(Points[2], Points[3], AColor);
  if AAscendingSorting then
    AColor := AColor1;
  ACanvas.Line(Points[3], Points[4], AColor);
  ACanvas.Line(Points[4], Points[5], AColor);
end;

procedure TcxCustomLookAndFeelPainter.DrawIndicatorCustomizationMark(
  ACanvas: TcxCanvas; const R: TRect; AColor: TColor);
begin
  DrawScaledIndicatorCustomizationMark(ACanvas, R, AColor, dxDefaultScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawIndicatorImage(ACanvas: TcxCanvas; const R: TRect; AKind: TcxIndicatorKind);
begin
  DrawScaledIndicatorImage(ACanvas, R, AKind, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledIndicatorImage(
  ACanvas: TcxCanvas; const R: TRect; AKind: TcxIndicatorKind; AScaleFactor: TdxScaleFactor);
var
  ADestRect: TRect;
begin
  if AKind <> ikNone then
  begin
    ADestRect := R;
    cxRightToLeftDependentDraw(ACanvas.Handle, ADestRect, ACanvas.UseRightToLeftAlignment and (AKind in [ikArrow, ikMultiArrow]),
      procedure
      begin
        TdxImageDrawer.DrawImage(ACanvas, ADestRect, nil, cxIndicatorImages, Ord(AKind) - 1, ifmNormal, idmNormal, False, nil, AScaleFactor, True);
      end);
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawMonthHeaderLeftArrow(ACanvas: TcxCanvas; const ABounds: TRect; AColor: TColor);
var
  R: TRect;
begin
  R := ABounds;
  R.Right := R.Left + R.Height;
  DrawArrow(ACanvas, R, adLeft, AColor);
end;

procedure TcxCustomLookAndFeelPainter.DrawMonthHeaderRightArrow(ACanvas: TcxCanvas; const ABounds: TRect; AColor: TColor);
var
  R: TRect;
begin
  R := ABounds;
  R.Left := R.Right - R.Height;
  DrawArrow(ACanvas, R, adRight, AColor);
end;

procedure TcxCustomLookAndFeelPainter.DrawMonthHeaderArrows(ACanvas: TcxCanvas; const ABounds: TRect;
  AArrows: TcxArrowDirections; ASideWidth: Integer; AColor: TColor);
begin
  if adLeft in AArrows then
    DrawMonthHeaderLeftArrow(ACanvas, ABounds, AColor);
  if adRight in AArrows then
    DrawMonthHeaderRightArrow(ACanvas, ABounds, AColor);
end;

procedure TcxCustomLookAndFeelPainter.DrawSortingArrow(ACanvas: TcxCanvas; const R: TRect;
  AColor1, AColor2: TColor; AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor);
var
  Sign, AWidth, AHeight, X, Y, ALeftSide, ARightSide: Integer;
begin
  Sign := 2 * Byte(AAscendingSorting) - 1;
  with ScaledSortingMarkSize(AScaleFactor) do
  begin
    AWidth := X;
    AHeight := Y;
  end;

  X := (R.Left + R.Right) div 2;
  if not Odd(AWidth) then Dec(X);
  if AAscendingSorting then
    Y := (R.Top + R.Bottom - AHeight) div 2
  else
    Y := (R.Top + R.Bottom + AHeight) div 2 - 1;

  ALeftSide := AWidth div 2;
  if not Odd(AWidth) then Dec(ALeftSide);
  ARightSide := AWidth div 2;

  ACanvas.Pen.Color := AColor2;
  ACanvas.MoveTo(X + ARightSide, Y + Sign * (AHeight - 2));
  ACanvas.LineTo(X + ARightSide - ALeftSide, Y);
  ACanvas.LineTo(X + ARightSide, Y + Sign * (AHeight - 1));
  if not AAscendingSorting then
    ACanvas.Pen.Color := AColor1;
  ACanvas.LineTo(X - ALeftSide, Y + Sign * (AHeight - 1));
  if AAscendingSorting then
    ACanvas.Pen.Color := AColor1;
  ACanvas.LineTo(X, Y);
  ACanvas.LineTo(X - ALeftSide, Y + Sign * (AHeight - Ord(Odd(AWidth))));
end;

procedure TcxCustomLookAndFeelPainter.DrawSummarySortingArrow(ACanvas: TcxCanvas;
  const R: TRect; AColor1, AColor2: TColor; AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor);
var
  Sign, AWidth, AHeight, X, Y, ALeftSide, ARightSide: Integer;
begin
  Sign := 2 * Byte(AAscendingSorting) - 1;
  with ScaledSummarySortingMarkSize(AScaleFactor) do
  begin
    AWidth := X;
    AHeight := Y;
  end;

  X := (R.Left + R.Right) div 2;
  if not Odd(AWidth) then Dec(X);
  ALeftSide := AWidth div 2;
  if not Odd(AWidth) then Dec(ALeftSide);
  ARightSide := AWidth div 2;

  Y := R.Top;
  ACanvas.Pen.Color := AColor1;
  ACanvas.MoveTo(X - ALeftSide, Y);
  ACanvas.LineTo(X + ARightSide + 1, Y);
  if AColor1 <> AColor2 then
  begin
    Inc(Y);
    ACanvas.Pen.Color := AColor2;
    ACanvas.MoveTo(X - ALeftSide, Y);
    ACanvas.LineTo(X + ARightSide + 1, Y);
  end;

  Dec(AHeight, 2);
  if AAscendingSorting then
    Y := (R.Top + R.Bottom - AHeight) div 2 + 2
  else
    Y := (R.Top + R.Bottom + AHeight) div 2 + 1;

  ACanvas.Pen.Color := AColor2;
  ACanvas.MoveTo(X + ARightSide, Y + Sign * (AHeight - 2));
  ACanvas.LineTo(X + ARightSide - ALeftSide, Y);
  ACanvas.LineTo(X + ARightSide, Y + Sign * (AHeight - 1));
  if not AAscendingSorting then
    ACanvas.Pen.Color := AColor1;
  ACanvas.LineTo(X - ALeftSide, Y + Sign * (AHeight - 1));
  if AAscendingSorting then
    ACanvas.Pen.Color := AColor1;
  ACanvas.LineTo(X, Y);
  ACanvas.LineTo(X - ALeftSide, Y + Sign * (AHeight - Ord(Odd(AWidth))));
end;

function TcxCustomLookAndFeelPainter.FooterCellContentBounds(
  const ABounds: TRect; const ABorders: TcxBorders; AScaleFactor, ABordersScaleFactor: TdxScaleFactor): TRect;
begin
  Result := ABounds;
  Result.Deflate(FooterCellBordersSizeRect(ABorders, AScaleFactor, ABordersScaleFactor));
end;

function TcxCustomLookAndFeelPainter.FooterCellTextAreaBounds(const ABounds: TRect; const ABorders: TcxBorders;
  APaddingsScaleFactor, ABordersScaleFactor: TdxScaleFactor): TRect;
begin
  Result := ABounds;
  Result.Deflate(FooterCellTextOffsets(ABorders, APaddingsScaleFactor, ABordersScaleFactor));
end;

function TcxCustomLookAndFeelPainter.FooterCellTextAreaBounds(
  const ABounds: TRect): TRect;
var
  ABordersScaleFactor: TdxScaleFactor;
begin
  ABordersScaleFactor := nil;
  dxInitBordersScaleFactor(dxDefaultScaleFactor, ABordersScaleFactor);
  Result := FooterCellTextAreaBounds(ABounds, cxBordersAll, dxDefaultScaleFactor, ABordersScaleFactor);
end;

function TcxCustomLookAndFeelPainter.FooterCellTextOffsets(
  ACellBorders: TcxBorders; APaddingsScaleFactor, ABordersScaleFactor: TdxScaleFactor): TRect;
begin
  Result := FooterCellContentOffsets(ACellBorders, True, APaddingsScaleFactor, ABordersScaleFactor);
  if (not ApplyEditorAdvancedMode) then
    Result.Offset(APaddingsScaleFactor.Apply(TdxVisualRefinements.Padding));
end;

function TcxCustomLookAndFeelPainter.FooterContentOffset: Integer;
begin
  Result := 1;
end;

function TcxCustomLookAndFeelPainter.FooterCellContentBounds(
  const ABounds: TRect): TRect;
var
  ABordersScaleFactor: TdxScaleFactor;
begin
  ABordersScaleFactor := nil;
  dxInitBordersScaleFactor(dxDefaultScaleFactor, ABordersScaleFactor);
  Result := FooterCellContentBounds(ABounds, cxBordersAll, dxDefaultScaleFactor, ABordersScaleFactor);
end;

function TcxCustomLookAndFeelPainter.FooterCellContentOffset: Integer;
begin
  Result := cxTextOffset;
end;

function TcxCustomLookAndFeelPainter.FooterCellContentOffsets(const ABorders: TcxBorders; AIncludeBorders: Boolean;
  AScaleFactor, ABordersScaleFactor: TdxScaleFactor): TRect;
begin
  Result.Init(AScaleFactor.Apply(FooterCellContentOffset));
  if AIncludeBorders then
    Result.Offset(FooterCellBordersSizeRect(ABorders, AScaleFactor, ABordersScaleFactor));
end;

function TcxCustomLookAndFeelPainter.GetArrowDirection(AHorizontal: Boolean;
  APart: TcxScrollBarPart): TcxArrowDirection;
const
  ArrowKind: array[Boolean, Boolean] of TcxArrowDirection = ((adUp, adDown), (adLeft, adRight));
begin
  Result := ArrowKind[AHorizontal, APart <> sbpLineUp];
end;

function TcxCustomLookAndFeelPainter.GetDataRowLayoutContentColor: TColor;
begin
  Result := DefaultContentColor;
end;

function TcxCustomLookAndFeelPainter.GetDataRowLayoutContentMargins: TRect;
begin
  Result := cxEmptyRect;
end;

function TcxCustomLookAndFeelPainter.GetDataRowLayoutItemMargins(AState: TcxButtonState): TRect;
begin
  if AState = cxbsHot then
    Result.Init(1)
  else
    Result.Empty;
end;

function TcxCustomLookAndFeelPainter.GetDefaultFixedColumnHighlightAAlpha: Byte;
begin
  Result := 15;
end;

function TcxCustomLookAndFeelPainter.GetFilterAddButtonColor(AState: TcxButtonState): TdxAlphaColor;
begin
  case AState of
    cxbsHot, cxbsDefault:
      Result := $FF222137;
    cxbsPressed:
      Result := $FF545454
    else
      Result := $FF848484;
  end;
end;

function TcxCustomLookAndFeelPainter.GetFilterRemoveButtonColor(AState: TcxButtonState): TdxAlphaColor;
begin
  case AState of
    cxbsHot, cxbsDefault:
      Result := $FFD50808;
    cxbsPressed:
      Result := $FF545454
    else
      Result := $FF848484;
  end;
end;

function TcxCustomLookAndFeelPainter.GetFilterSmartTagColor(
  AState: TcxFilterSmartTagState; AIsFilterActive: Boolean): TColor;
begin
  case AState of
    fstsNormal, fstsParentHot:
      if AIsFilterActive then
        Result := $FF2600
      else
        Result := $606060;

    fstsHot:
      Result := $4848484;
    fstsPressed:
      Result := $303030;
  else
    Result := $606060;
  end;
end;

function TcxCustomLookAndFeelPainter.GetSeparatorBounds(
  const R: TRect; AWidth: Integer; AIsVertical: Boolean): TRect;
var
  P: TPoint;
begin
  P := cxRectCenter(R);
  Result := R;
  if AIsVertical then
  begin
    Result.Left := P.X - AWidth div 2;
    Result.Right := Result.Left + AWidth;
  end
  else
  begin
    Result.Top := P.Y - AWidth div 2;
    Result.Bottom := Result.Top + AWidth;
  end;
end;

procedure TcxCustomLookAndFeelPainter.ReleaseImageResources;
begin
  FreeAndNil(FPasswordRevealButtonGlyphs[False]);
  FreeAndNil(FPasswordRevealButtonGlyphs[True]);
  FreeAndNil(FPinGlyph);
  FreeAndNil(FLookAndFeelPainterDetailsCache);
  FreeAndNil(FSmartTagGlyph);
  FreeAndNil(FClockFace);
  FreeAndNil(FClockGlass);
  FreeAndNil(FClockFace150);
  FreeAndNil(FClockGlass150);
  FreeAndNil(FNavigationBarCustomizationButton);
  FreeAndNil(FBackButton);
  FreeAndNil(FMapPushpin);
  FreeAndNil(FRatingControlIndicator);
  FreeAndNil(FFixedGroupIndicator);
  FreeAndNil(FSearchButtonGlyph);
  FreeAndNil(FCalendarButtonGlyph);
  FreeAndNil(FGroupByBoxSearchButtonGlyph);
  FreeAndNil(FFindPanelNextButtonGlyph);
  FreeAndNil(FFindPanelPreviousButtonGlyph);
  FreeAndNil(FFilterControlAddButtonGlyph);
  FreeAndNil(FFilterControlRemoveButtonGlyph);
  FreeAndNil(FFilterPanelRemoveButtonGlyph);
  FreeAndNil(FClearButtonGlyph);
end;

function TcxCustomLookAndFeelPainter.GetPainterData(var AData): Boolean;
begin
  Result := False;
end;

function TcxCustomLookAndFeelPainter.GetPainterDetails(var ADetails): Boolean;
begin
  Result := GetLookAndFeelPainterDetails <> nil;
  if Result then
    TObject(ADetails) := GetLookAndFeelPainterDetails;
end;

function TcxCustomLookAndFeelPainter.IsInternalPainter: Boolean;
begin
  Result := False;
end;

function TcxCustomLookAndFeelPainter.LookAndFeelName: string;
begin
  Result := '';
end;

function TcxCustomLookAndFeelPainter.LookAndFeelStyle: TcxLookAndFeelStyle;
begin
  Result := lfsStandard;
end;

function TcxCustomLookAndFeelPainter.NeedRedrawOnResize: Boolean;
begin
  Result := False;
end;

procedure TcxCustomLookAndFeelPainter.ResetLookAndFeelSettings;
begin
  // do nothing
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledEditorBackground(ACanvas: TcxCanvas; const R: TRect;
  AIsInplace, AReadOnly: Boolean; AColor: TColor; AState: TcxContainerBorderState; AScaleFactor: TdxScaleFactor; const APalette: IdxColorPalette = nil);
begin
  ACanvas.FillRect(R, AColor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledImageEditorBackground(ACanvas: TcxCanvas; const R: TRect;
  AIsInplace, AReadOnly: Boolean; AColor: TColor; AState: TcxContainerBorderState; AScaleFactor: TdxScaleFactor; const APalette: IdxColorPalette = nil);
begin
  ACanvas.FillRect(R, AColor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledListBoxBackground(ACanvas: TcxCanvas; const R: TRect; AIsInplace: Boolean; AColor: TColor;
  AState: TcxContainerBorderState; AScaleFactor: TdxScaleFactor; const APalette: IdxColorPalette = nil);
begin
  ACanvas.FillRect(R, AColor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledListBoxItemBackground(ACanvas: TcxCanvas; const ARect: TRect; AState: TOwnerDrawState; AScaleFactor: TdxScaleFactor);
begin
  ACanvas.FillRect(ARect);
end;

function TcxCustomLookAndFeelPainter.GetEditorGlyphIndent(ALeftMost, AIsInplace: Boolean;
  AScaleFactor: TdxScaleFactor; APaintPartID: TdxPaintPartID = TdxPaintPartID.Unknown): Integer;
begin
  if ALeftMost then
  begin
    case APaintPartID of
      TdxPaintPartID.CheckComboBox:
        Result := AScaleFactor.Apply(2);
      else
        Result := AScaleFactor.Apply(4);
    end;
  end
  else
  begin
    case APaintPartID of
      TdxPaintPartID.ImageComboBox:
        Result := AScaleFactor.Apply(2);
      else
        Result := AScaleFactor.Apply(4);
    end;
  end;
end;

function TcxCustomLookAndFeelPainter.GetEditorPadding(AIsInplace: Boolean; AScaleFactor: TdxScaleFactor): TRect;
begin
  Result.Empty;
end;

function TcxCustomLookAndFeelPainter.GetEditorButtonPadding(AScaleFactor: TdxScaleFactor): TRect;
var
  W: Integer;
begin
  W := AScaleFactor.Apply(2) + 1;
  Result.Init(W div 2, 0, W - W div 2, 0);
end;

function TcxCustomLookAndFeelPainter.GetEditorButtonsPadding(AScaleFactor: TdxScaleFactor): TRect;
begin
  Result.Init(cxEditButtonMaxBorderWidth, 0, cxEditButtonMaxBorderWidth, 0);
end;

function TcxCustomLookAndFeelPainter.GetEditorItemsPadding(AScaleFactor: TdxScaleFactor): TRect;
begin
  Result.Empty;
end;

function TcxCustomLookAndFeelPainter.GetImageEditorPadding(AIsInplace: Boolean; AScaleFactor: TdxScaleFactor): TRect;
begin
  Result.Empty;
end;

function TcxCustomLookAndFeelPainter.GetListBoxBackgroundPadding(AIsInplace: Boolean; AScaleFactor: TdxScaleFactor): TRect;
begin
  Result.Empty;
end;

function TcxCustomLookAndFeelPainter.GetListBoxItemPadding(AScaleFactor: TdxScaleFactor): TRect;
begin
  Result.Init(2, 0, 2, 0);
end;

function TcxCustomLookAndFeelPainter.GetListBoxScrollBarPadding(AIsInplace: Boolean; AKind: TScrollBarKind; AScaleFactor: TdxScaleFactor): TRect;
begin
  Result.Empty;
end;

function TcxCustomLookAndFeelPainter.SupportsEditorBorders: Boolean;
begin
  Result := True;
end;

function TcxCustomLookAndFeelPainter.SupportsEditorPadding(const AIsInplace: Boolean): Boolean;
begin
  Result := False;
end;

function TcxCustomLookAndFeelPainter.SupportsEditorShadow: Boolean;
begin
  Result := True;
end;

function TcxCustomLookAndFeelPainter.SupportsImageEditorPadding: Boolean;
begin
  Result := False;
end;

function TcxCustomLookAndFeelPainter.SupportsListBoxPadding: Boolean;
begin
  Result := False;
end;

function TcxCustomLookAndFeelPainter.SupportsTransparentBorder: Boolean;
begin
  Result := True;
end;

function TcxCustomLookAndFeelPainter.DefaultContentColor: TColor;
begin
  Result := clWindow;
end;

function TcxCustomLookAndFeelPainter.DefaultContentOddColor: TColor;
begin
  Result := DefaultContentColor;
end;

function TcxCustomLookAndFeelPainter.DefaultContentEvenColor: TColor;
begin
  Result := DefaultContentColor;
end;

function TcxCustomLookAndFeelPainter.DefaultContentGlyphColorPalette(AState: TcxButtonState): IdxColorPalette;
begin
  Result := nil;
end;

function TcxCustomLookAndFeelPainter.DefaultContentTextColor: TColor;
begin
  Result := clWindowText;
end;

function TcxCustomLookAndFeelPainter.DefaultControlColor: TColor;
begin
  Result := clBtnFace;
end;

function TcxCustomLookAndFeelPainter.DefaultControlTextColor: TColor;
begin
  Result := clBtnText;
end;

function TcxCustomLookAndFeelPainter.DefaultCustomScrollbarAnnotationColor: TdxAlphaColor;
begin
  Result := $FFA9A9A9;
end;

function TcxCustomLookAndFeelPainter.DefaultSchedulerBackgroundColor: TColor;
begin
  Result := clWindow;
end;

function TcxCustomLookAndFeelPainter.DefaultSchedulerTextColor: TColor;
begin
  Result := clWindowText;
end;

function TcxCustomLookAndFeelPainter.DefaultDateNavigatorTextColor: TColor;
begin
   Result := clWindowText;
end;

function TcxCustomLookAndFeelPainter.DefaultDateNavigatorHolydayTextColor: TColor;
begin
  Result := clRed;
end;

function TcxCustomLookAndFeelPainter.DefaultDateNavigatorInactiveTextColor: TColor;
begin
  Result := clGrayText;
end;

function TcxCustomLookAndFeelPainter.DefaultDateNavigatorSeparator1Color: TColor;
begin
  Result := clBtnShadow;
end;

function TcxCustomLookAndFeelPainter.DefaultDateNavigatorSeparator2Color: TColor;
begin
  Result := clWindow;
end;

function TcxCustomLookAndFeelPainter.DefaultDateNavigatorTodayFrameColor: TColor;
begin
  Result := clMaroon;
end;

function TcxCustomLookAndFeelPainter.DefaultDateNavigatorTodayTextColor(ASelected: Boolean): TColor;
begin
  if ASelected then
    Result := clDefault
  else
    Result := clNavy;
end;

function TcxCustomLookAndFeelPainter.DefaultDateNavigatorWeekendTextColor: TColor;
begin
  Result := DefaultDateNavigatorTextColor;
end;

function TcxCustomLookAndFeelPainter.DefaultDateNavigatorContentColor: TColor;
begin
  Result := DefaultEditorBackgroundColor(False);
  if Result = clDefault then
    Result := DefaultContentColor;
end;

function TcxCustomLookAndFeelPainter.DefaultDateNavigatorHeaderColor: TColor;
begin
  Result := clBtnFace;
end;

function TcxCustomLookAndFeelPainter.DefaultDateNavigatorHeaderTextColor(
  AIsHighlight: Boolean): TColor;
begin
  if AIsHighlight then
    Result := DefaultDateNavigatorHeaderHighlightTextColor
  else
    Result := DefaultHeaderTextColor;
end;

function TcxCustomLookAndFeelPainter.DefaultDateNavigatorSelectionColor: TColor;
begin
  Result := clHighlight;
end;

function TcxCustomLookAndFeelPainter.DefaultDateNavigatorSelectionTextColor: TColor;
begin
  Result := clHighlightText;
end;

function TcxCustomLookAndFeelPainter.DefaultEditorBackgroundColor(AIsDisabled: Boolean): TColor;
begin
  Result := DefaultEditorBackgroundColorEx(cxEditStateColorKindMap[not AIsDisabled]);
end;

function TcxCustomLookAndFeelPainter.DefaultEditorTextColor(AIsDisabled: Boolean): TColor;
begin
  Result := DefaultEditorTextColorEx(cxEditStateColorKindMap[not AIsDisabled]);
end;

function TcxCustomLookAndFeelPainter.DefaultEditorBackgroundColorEx(AKind: TcxEditStateColorKind): TColor;
begin
  Result := clDefault;
end;

function TcxCustomLookAndFeelPainter.DefaultEditorTextColorEx(AKind: TcxEditStateColorKind): TColor;
begin
  Result := clDefault;
end;

function TcxCustomLookAndFeelPainter.DefaultErrorScrollbarAnnotationColor: TdxAlphaColor;
begin
  Result := dxColorToAlphaColor(clRed, $96);
end;

function TcxCustomLookAndFeelPainter.DefaultFilterBoxColor: TColor;
begin
  Result := clBtnShadow;
end;

function TcxCustomLookAndFeelPainter.DefaultFilterBoxTextColor: TColor;
begin
  Result := clBtnHighlight;
end;

function TcxCustomLookAndFeelPainter.DefaultFixedColumnHighlightColor: TdxAlphaColor;
begin
  Result := dxColorToAlphaColor(DefaultSelectionColor, GetDefaultFixedColumnHighlightAAlpha);
end;

function TcxCustomLookAndFeelPainter.DefaultFixedSeparatorColor: TColor;
begin
  Result := clBtnText;
end;

function TcxCustomLookAndFeelPainter.DefaultFocusedScrollbarAnnotationColor: TdxAlphaColor;
begin
  Result := dxColorToAlphaColor(clGreen);
end;

function TcxCustomLookAndFeelPainter.DefaultFooterColor: TColor;
begin
  Result := clBtnFace;
end;

function TcxCustomLookAndFeelPainter.DefaultFooterTextColor: TColor;
begin
  Result := clBtnText;
end;

function TcxCustomLookAndFeelPainter.DefaultGridDetailsSiteColor: TColor;
begin
  Result := clBtnFace;
end;

function TcxCustomLookAndFeelPainter.DefaultGridExpandButtonIndent: Integer;
begin
  Result := 3;
end;

function TcxCustomLookAndFeelPainter.DefaultGridLineColor: TColor;
begin
  Result := clBtnShadow;
end;

function TcxCustomLookAndFeelPainter.DefaultGroupColor: TColor;
begin
  Result := clBtnFace;
end;

function TcxCustomLookAndFeelPainter.DefaultGroupContentOffsets(AScaleFactor: TdxScaleFactor = nil): TRect;
begin
  Result := cxNullRect;
end;

function TcxCustomLookAndFeelPainter.DefaultGroupTextColor: TColor;
begin
  Result := clBtnText;
end;

function TcxCustomLookAndFeelPainter.DefaultGroupByBoxColor: TColor;
begin
  Result := clBtnShadow;
end;

function TcxCustomLookAndFeelPainter.DefaultGroupByBoxLineColor: TColor;
begin
  Result := clBtnText;
end;

function TcxCustomLookAndFeelPainter.DefaultGroupByBoxTextColor: TColor;
begin
  Result := clBtnFace;
end;

function TcxCustomLookAndFeelPainter.DefaultHeaderColor: TColor;
begin
  Result := clBtnFace;
end;

function TcxCustomLookAndFeelPainter.DefaultHeaderTextColor: TColor;
begin
  Result := clBtnText;
end;

function TcxCustomLookAndFeelPainter.DefaultHeaderBackgroundColor: TColor;
begin
  Result := clBtnShadow;
end;

function TcxCustomLookAndFeelPainter.DefaultHeaderBackgroundTextColor: TColor;
begin
  Result := clBtnFace;
end;

function TcxCustomLookAndFeelPainter.DefaultHyperlinkTextColor: TColor;
begin
  Result := clBlue;
end;

function TcxCustomLookAndFeelPainter.DefaultInactiveColor: TColor;
begin
  Result := clBtnFace;
end;

function TcxCustomLookAndFeelPainter.DefaultInactiveTextColor: TColor;
begin
  Result := clBtnText;
end;

function TcxCustomLookAndFeelPainter.DefaultPreviewTextColor: TColor;
begin
  Result := clBlue;
end;

function TcxCustomLookAndFeelPainter.DefaultRecordSeparatorColor: TColor;
begin
  Result := DefaultGridLineColor;
end;

function TcxCustomLookAndFeelPainter.DefaultSearchResultAnnotationColor: TdxAlphaColor;
begin
  Result := $96FFA500;
end;

function TcxCustomLookAndFeelPainter.DefaultSearchResultHighlightColor: TColor;
begin
  Result := clDefault; 
end;

function TcxCustomLookAndFeelPainter.DefaultSearchResultHighlightTextColor: TColor;
begin
  Result := clDefault; 
end;

function TcxCustomLookAndFeelPainter.DefaultSelectedScrollbarAnnotationColor: TdxAlphaColor;
begin
  Result := dxColorToAlphaColor(clDkGray);
end;

function TcxCustomLookAndFeelPainter.DefaultSizeGripAreaColor: TColor;
begin
  Result := clBtnFace;
end;

function TcxCustomLookAndFeelPainter.DefaultTreeListGridLineColor: TColor;
begin
  Result := DefaultGridLineColor;
end;

function TcxCustomLookAndFeelPainter.DefaultTreeListTreeLineColor: TColor;
begin
  Result := DefaultGridLineColor;
end;

function TcxCustomLookAndFeelPainter.DefaultVGridCategoryColor: TColor;
begin
  Result := DefaultHeaderColor;
end;

function TcxCustomLookAndFeelPainter.DefaultVGridCategoryTextColor: TColor;
begin
  Result := clDefault;
end;

function TcxCustomLookAndFeelPainter.DefaultVGridContentColor: TColor;
begin
  Result := GridLikeControlContentColor;
end;

function TcxCustomLookAndFeelPainter.DefaultVGridContentEvenColor: TColor;
begin
  Result := GridLikeControlContentEvenColor;
end;

function TcxCustomLookAndFeelPainter.DefaultVGridContentOddColor: TColor;
begin
  Result := GridLikeControlContentOddColor;
end;

function TcxCustomLookAndFeelPainter.DefaultVGridContentTextColor: TColor;
begin
  Result := DefaultContentTextColor;
end;

function TcxCustomLookAndFeelPainter.DefaultVGridHeaderColor: TColor;
begin
  Result := DefaultHeaderColor;
end;

function TcxCustomLookAndFeelPainter.DefaultVGridHeaderTextColor: TColor;
begin
  Result := DefaultHeaderTextColor;
end;

function TcxCustomLookAndFeelPainter.DefaultVGridLineColor: TColor;
begin
  Result := clBlack; //todo
end;

function TcxCustomLookAndFeelPainter.DefaultVGridBandLineColor: TColor;
begin
  Result := DefaultVGridLineColor;
end;

function TcxCustomLookAndFeelPainter.DefaultSchedulerBorderColor: TColor;
begin
  Result := $9D9DA1;
end;

function TcxCustomLookAndFeelPainter.DefaultSchedulerContentColor(
  AResourceIndex: Integer): TColor;
begin
  Result := clDefault;
end;

function TcxCustomLookAndFeelPainter.DefaultSchedulerControlColor: TColor;
begin
  Result := clBtnFace;
end;

function TcxCustomLookAndFeelPainter.DefaultSchedulerDayHeaderColor: TColor;
begin
  Result := $F0F0F0;
end;

function TcxCustomLookAndFeelPainter.DefaultSchedulerDayHeaderBorderColor: TColor;
begin
  Result := $E1E1E1;
end;

function TcxCustomLookAndFeelPainter.DefaultSchedulerDayHeaderTextColor: TColor;
begin
  Result := $444444;
end;

function TcxCustomLookAndFeelPainter.DefaultSchedulerDateNavigatorArrowColor(AIsHighlight: Boolean): TColor;
begin
  if AIsHighlight then
    Result := DefaultDateNavigatorHeaderHighlightTextColor
  else
    Result := $5F5F5F;
end;

function TcxCustomLookAndFeelPainter.DefaultSchedulerTimeRulerBorderColor: TColor;
begin
  Result := DefaultSchedulerHeaderContainerBorderColor;
end;

function TcxCustomLookAndFeelPainter.DefaultSchedulerTimeRulerBorderColorClassic: TColor;
begin
  Result := clBtnShadow;
end;

function TcxCustomLookAndFeelPainter.DefaultSchedulerTimeRulerColor: TColor;
begin
  Result := DefaultSchedulerHeaderContainerBackgroundColor(False);
end;

function TcxCustomLookAndFeelPainter.DefaultSchedulerTimeRulerColorClassic: TColor;
begin
  Result := DefaultHeaderColor;
end;

function TcxCustomLookAndFeelPainter.DefaultSchedulerTimeRulerTextColor: TColor;
begin
  Result := $666666;
end;

function TcxCustomLookAndFeelPainter.DefaultSchedulerTimeRulerTextColorClassic: TColor;
begin
  Result := DefaultHeaderTextColor;
end;

function TcxCustomLookAndFeelPainter.DefaultSchedulerViewContentColor: TColor;
begin
  Result := $FFFFFF;
end;

function TcxCustomLookAndFeelPainter.DefaultSchedulerViewContentColorClassic: TColor;
begin
  Result := $D5FFFF;
end;

function TcxCustomLookAndFeelPainter.DefaultSchedulerEventColor(AIsAllDayEvent: Boolean): TColor;
const
  Map: array[Boolean] of TColor = ($D7D7D7, $D7D7D7);
begin
  Result := Map[AIsAllDayEvent];
end;

function TcxCustomLookAndFeelPainter.DefaultSchedulerEventColorClassic(AIsAllDayEvent: Boolean): TColor;
const
  Map: array[Boolean] of TColor = (clWindow, clWhite);
begin
  Result := Map[AIsAllDayEvent];
end;

function TcxCustomLookAndFeelPainter.DefaultSchedulerHeaderContainerAlternateBackgroundColor: TColor;
begin
  Result := dxOffice11SelectedDownColor1;
end;

function TcxCustomLookAndFeelPainter.DefaultSchedulerHeaderContainerBackgroundColor(ASelected: Boolean): TColor;
begin
  if ASelected then
    Result := DefaultSelectionColor
  else
    Result := $FFFFFF;
end;

function TcxCustomLookAndFeelPainter.DefaultSchedulerHeaderContainerTextColor(ASelected: Boolean): TColor;
begin
  if ASelected then
    Result := DefaultSelectionTextColor
  else
    Result := DefaultSchedulerDayHeaderTextColor;
end;

function TcxCustomLookAndFeelPainter.DefaultSchedulerHeaderContainerBorderColor: TColor;
begin
  Result := $E1E1E1;
end;

function TcxCustomLookAndFeelPainter.DefaultSchedulerNavigatorColor: TColor;
begin
  Result := clBtnFace;
end;

function TcxCustomLookAndFeelPainter.DefaultSchedulerSelectedEventBorderColor: TColor;
begin
  Result := clBlack;
end;

function TcxCustomLookAndFeelPainter.DefaultSchedulerViewSelectedTextColor: TColor;
begin
  Result := DefaultSelectionTextColor;
end;

function TcxCustomLookAndFeelPainter.DefaultSchedulerViewTextColor: TColor;
begin
  Result := clWindowText;
end;

function TcxCustomLookAndFeelPainter.DefaultSchedulerYearViewUnusedContentColor(
  AIsWorkTime: Boolean): TColor;
begin
  Result := clDefault;
end;

function TcxCustomLookAndFeelPainter.DefaultHotTrackColor: TColor;
begin
  Result := clGradientInactiveCaption;
end;

function TcxCustomLookAndFeelPainter.DefaultHotTrackTextColor: TColor;
begin
  Result := DefaultContentTextColor;
end;

function TcxCustomLookAndFeelPainter.DefaultSelectionColor: TColor;
begin
  Result := clHighlight;
end;

function TcxCustomLookAndFeelPainter.UseDefaultListBoxSelectionTextColor: Boolean;
begin
  Result := True;
end;

function TcxCustomLookAndFeelPainter.DefaultSelectionTextColor: TColor;
begin
  Result := clHighlightText;
end;

function TcxCustomLookAndFeelPainter.DefaultListBoxSelectionTextColor: TColor;
begin
  Result := DefaultSelectionTextColor;
end;

function TcxCustomLookAndFeelPainter.DefaultSeparatorColor: TColor;
begin
  Result := clBtnFace;
end;

function TcxCustomLookAndFeelPainter.DefaultTabColor: TColor;
begin
  Result := clBtnFace;
end;

function TcxCustomLookAndFeelPainter.DefaultTabTextColor: TColor;
begin
  Result := clBtnText;
end;

function TcxCustomLookAndFeelPainter.DefaultTabsBackgroundColor: TColor;
begin
  Result := clWindow;
end;

function TcxCustomLookAndFeelPainter.DefaultRootTabsBackgroundColor: TColor;
begin
  Result := clBtnFace;
end;

function TcxCustomLookAndFeelPainter.DefaultTimeGridMajorScaleColor: TColor;
begin
  Result := clWhite;
end;

function TcxCustomLookAndFeelPainter.DefaultTimeGridMajorScaleTextColor: TColor;
begin
  Result := clBlack;
end;

function TcxCustomLookAndFeelPainter.DefaultTimeGridMinorScaleColor: TColor;
begin
  Result := clBtnFace;
end;

function TcxCustomLookAndFeelPainter.DefaultTimeGridMinorScaleTextColor: TColor;
begin
  Result := clBtnText;
end;

function TcxCustomLookAndFeelPainter.DefaultTimeGridSelectionBarColor: TColor;
begin
  Result := clWhite;
end;

function TcxCustomLookAndFeelPainter.DefaultChartDiagramValueBorderColor: TColor;
begin
  Result := clBlack;
end;

function TcxCustomLookAndFeelPainter.DefaultChartDiagramValueCaptionTextColor: TColor;
begin
  Result := clBlack;
end;

function TcxCustomLookAndFeelPainter.DefaultChartHistogramAxisColor: TColor;
begin
  Result := clBlack;
end;

function TcxCustomLookAndFeelPainter.DefaultChartHistogramGridLineColor: TColor;
begin
  Result := clcxLightGray;
end;

function TcxCustomLookAndFeelPainter.DefaultChartHistogramPlotColor: TColor;
begin
  Result := clWhite;
end;

function TcxCustomLookAndFeelPainter.DefaultChartPieDiagramSeriesSiteBorderColor: TColor;
begin
  Result := clBtnShadow;
end;

function TcxCustomLookAndFeelPainter.DefaultChartPieDiagramSeriesSiteCaptionColor: TColor;
begin
  Result := clSkyBlue;
end;

function TcxCustomLookAndFeelPainter.DefaultChartPieDiagramSeriesSiteCaptionTextColor: TColor;
begin
  Result := clNavy;
end;

function TcxCustomLookAndFeelPainter.DefaultChartToolBoxDataLevelInfoBorderColor: TColor;
begin
  Result := clBtnShadow;
end;

function TcxCustomLookAndFeelPainter.DefaultChartToolBoxItemSeparatorColor: TColor;
begin
  Result := clBtnShadow;
end;

function TcxCustomLookAndFeelPainter.DefaultLabelTextColorEx(AKind: TcxEditStateColorKind): TColor;
begin
  Result := DefaultEditorTextColorEx(AKind);
end;

function TcxCustomLookAndFeelPainter.DefaultLayoutViewCaptionColor(AState: TcxButtonState): TColor;
begin
  case AState of
    cxbsHot:
      Result := DefaultSelectionColor;
    cxbsDisabled:
      Result := clInactiveCaption;
  else
    Result := DefaultGroupColor;
  end;
end;

function TcxCustomLookAndFeelPainter.DefaultLayoutViewCaptionTextColor(ACaptionPosition: TcxGroupBoxCaptionPosition; AState: TcxButtonState): TColor;
begin
  Result := DefaultLayoutViewContentTextColor(AState);
end;

function TcxCustomLookAndFeelPainter.DefaultLayoutViewContentColor: TColor;
begin
  Result := DefaultContentColor;
end;

function TcxCustomLookAndFeelPainter.DefaultLayoutViewContentTextColor(AState: TcxButtonState): TColor;
begin
  case AState of
    cxbsPressed:
      Result := DefaultSelectionTextColor;
    cxbsDisabled:
      Result := clInactiveCaptionText;
  else
    Result := DefaultContentTextColor;
  end;
end;

function TcxCustomLookAndFeelPainter.DefaultGridOptionsTreeViewCategoryColor(ASelected: Boolean): TColor;
begin
  if ASelected then
    Result := clHighlight
  else
    Result := clBtnShadow;
end;

function TcxCustomLookAndFeelPainter.DefaultGridOptionsTreeViewCategoryTextColor(ASelected: Boolean): TColor;
begin
  if ASelected then
    Result := clHighlightText
  else
    Result := clBtnText;
end;

function TcxCustomLookAndFeelPainter.GetColorGalleryGlyphFrameColor: TColor;
begin
  Result := $E2E4E6;
end;

procedure TcxCustomLookAndFeelPainter.DrawColorGalleryItemSelection(
  ACanvas: TcxCustomCanvas; const R: TRect; AViewState: TdxGalleryItemViewState);
const
  AColor1 = $3694F2;
  AColor2 = $94E2FF;
  AColor3 = $1048Ef;
  AColor4 = $0022Ef;
begin
  if AViewState.Checked then
    ACanvas.FrameRect(R, AColor3)
  else if AViewState.Pressed then
    ACanvas.FrameRect(R, AColor4)
  else if AViewState.Hover or AViewState.Focused then
    ACanvas.FrameRect(R, AColor1)
  else
    Exit;

  ACanvas.FrameRect(cxRectInflate(R, -1), AColor2);
end;

function TcxCustomLookAndFeelPainter.GetGalleryScaledGroupHeaderContentOffsets(AScaleFactor: TdxScaleFactor): TRect;
begin
  Result := AScaleFactor.Apply(TRect.Create(7, 3, 7, 4));
end;

function TcxCustomLookAndFeelPainter.GetGalleryGroupHeaderContentOffsets: TRect;
begin
  Result := GetGalleryScaledGroupHeaderContentOffsets(dxDefaultScaleFactor);
end;

function TcxCustomLookAndFeelPainter.GetGalleryGroupTextColor: TColor;
begin
  Result := clDefault;
end;

function TcxCustomLookAndFeelPainter.GetGalleryItemImageFrameColor: TColor;
begin
  Result := clBtnShadow;
end;

function TcxCustomLookAndFeelPainter.GetGalleryDropTargetSelectionColor: TColor;
begin
  Result := clWindowText;
end;

function TcxCustomLookAndFeelPainter.GetGalleryItemCaptionTextColor(const AState: TdxGalleryItemViewState): TColor;
begin
  if AState.Enabled then
    Result := clWindowText
  else
    Result := clGrayText;
end;

function TcxCustomLookAndFeelPainter.GetGalleryItemColorPalette(const AState: TdxGalleryItemViewState): IdxColorPalette;
begin
  Result := nil;
end;

function TcxCustomLookAndFeelPainter.GetGalleryItemDescriptionTextColor(const AState: TdxGalleryItemViewState): TColor;
begin
  Result := clGrayText;
end;

procedure TcxCustomLookAndFeelPainter.DrawGalleryBackground(ACanvas: TcxCustomCanvas; const ABounds: TRect);
begin
  DrawGalleryBackgroundScaled(ACanvas, ABounds, dxDefaultScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawGalleryBackgroundScaled(
  ACanvas: TcxCustomCanvas; const ABounds: TRect; AScaleFactor: TdxScaleFactor);
begin
  ACanvas.FillRect(ABounds, clWhite);
end;

procedure TcxCustomLookAndFeelPainter.DrawGalleryGroupHeader(ACanvas: TcxCustomCanvas; const ABounds: TRect);
begin
  DrawGalleryGroupHeaderScaled(ACanvas, ABounds, dxDefaultScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawGalleryGroupHeaderScaled(
  ACanvas: TcxCustomCanvas; const ABounds: TRect; AScaleFactor: TdxScaleFactor);
begin
  DrawScaledHeader(ACanvas, ABounds, cxbsNormal, [], cxBordersAll, AScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawGalleryItemSelection(
  ACanvas: TcxCustomCanvas; const R: TRect; AViewState: TdxGalleryItemViewState);
begin
  DrawGalleryItemSelectionScaled(ACanvas, R, AViewState, dxDefaultScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawGalleryItemSelectionScaled(ACanvas: TcxCustomCanvas;
  const R: TRect; AViewState: TdxGalleryItemViewState; AScaleFactor: TdxScaleFactor);
const
  dxGalleryBasicBackgroundColor: TColor = $582801;
  dxGalleryFocusRectColor: TColor = $CEA27D;
  dxGalleryMouseHoverFrameRectColor: TColor = $FBD6B8;

  function GetAlphaValue: Byte;
  begin
    Result := 0;
    if AViewState.Checked then
    begin
      if AViewState.Pressed then
        Result := $80
      else
        if AViewState.Hover then
          Result := $60
        else
          Result := $10
    end
    else
    begin
      if AViewState.Pressed then
        Result := $40
      else
        if AViewState.Hover then
          Result := $20
    end;
  end;

  function GetFrameColor: TColor;
  begin
    Result := clNone;
    if AViewState.Focused then
      Result := dxGalleryFocusRectColor
    else
      if AViewState.Checked then
      begin
        if AViewState.Pressed then
          Result := dxGetColorTint(dxGalleryFocusRectColor, -20)
        else
          if AViewState.Hover then
            Result := dxGetColorTint(dxGalleryFocusRectColor, 10)
          else
            Result := dxGetColorTint(dxGalleryFocusRectColor, 80);
      end
      else
      begin
        if AViewState.Pressed then
          Result := dxGetColorTint(dxGalleryFocusRectColor, 20)
        else
          if AViewState.Hover then
            Result := dxGalleryMouseHoverFrameRectColor;
      end;
  end;

var
  AAlphaValue: Byte;
  AFrameColor: TColor;
begin
  AAlphaValue := GetAlphaValue;
  if AAlphaValue <> 0 then
    ACanvas.FillRect(R, dxGalleryBasicBackgroundColor, AAlphaValue);

  AFrameColor := GetFrameColor;
  if cxColorIsValid(AFrameColor) then
    ACanvas.FrameRect(R, AFrameColor, 2);
end;

function TcxCustomLookAndFeelPainter.DrawGalleryItemSelectionFirst: Boolean;
begin
  Result := False;
end;

procedure TcxCustomLookAndFeelPainter.DrawGalleryItemImageFrame(ACanvas: TcxCustomCanvas; const R: TRect);
begin
  DrawGalleryItemImageFrameScaled(ACanvas, R, dxDefaultScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawGalleryItemImageFrameScaled(
  ACanvas: TcxCustomCanvas; const R: TRect; AScaleFactor: TdxScaleFactor);
begin
  ACanvas.FrameRect(R, GetGalleryItemImageFrameColor);
end;

function TcxCustomLookAndFeelPainter.GetBackButton: TdxSmartImage;
begin
  if FBackButton = nil then
  begin
    FBackButton := TdxSmartImage.Create;
    FBackButton.LoadFromResource(HInstance, 'CX_BACKBUTTON', 'PNG');
  end;
  Result := FBackButton;
end;

function TcxCustomLookAndFeelPainter.GetCalendarButtonGlyph: TdxSmartImage;
begin
  if FCalendarButtonGlyph = nil then
  begin
    FCalendarButtonGlyph := TdxSmartImage.Create;
    FCalendarButtonGlyph.LoadFromResource(HInstance, 'CX_CALENDARBUTTON', 'SVG');
  end;
  Result := FCalendarButtonGlyph;
end;

function TcxCustomLookAndFeelPainter.GetClearButtonGlyph: TdxSmartImage;
begin
  if FClearButtonGlyph = nil then
  begin
    FClearButtonGlyph := TdxSmartImage.Create;
    FClearButtonGlyph.LoadFromResource(HInstance, 'CX_CLEARBUTTON', 'SVG');
  end;
  Result := FClearButtonGlyph;
end;

function TcxCustomLookAndFeelPainter.GetClockFace: TdxSmartImage;
begin
  if FClockFace = nil then
  begin
    FClockFace := TdxSmartImage.Create;
    FClockFace.LoadFromResource(HInstance, 'CX_CLOCKFACE', 'PNG');
  end;
  Result := FClockFace;
end;

function TcxCustomLookAndFeelPainter.GetClockFace150: TdxSmartImage;
begin
  if FClockFace150 = nil then
  begin
    FClockFace150 := TdxSmartImage.Create;
    FClockFace150.LoadFromResource(HInstance, 'CX_CLOCKFACE150', 'PNG');
  end;
  Result := FClockFace150;
end;

function TcxCustomLookAndFeelPainter.GetClockGlass: TdxSmartImage;
begin
  if FClockGlass = nil then
  begin
    FClockGlass := TdxSmartImage.Create;
    FClockGlass.LoadFromResource(HInstance, 'CX_CLOCKGLASS', 'PNG');
  end;
  Result := FClockGlass;
end;

function TcxCustomLookAndFeelPainter.GetClockGlass150: TdxSmartImage;
begin
  if FClockGlass150 = nil then
  begin
    FClockGlass150 := TdxSmartImage.Create;
    FClockGlass150.LoadFromResource(HInstance, 'CX_CLOCKGLASS', 'PNG');
  end;
  Result := FClockGlass150;
end;

function TcxCustomLookAndFeelPainter.GetFilterControlAddButtonGlyph: TdxSmartImage;
begin
  if FFilterControlAddButtonGlyph = nil then
  begin
    FFilterControlAddButtonGlyph := TdxSmartImage.Create;
    FFilterControlAddButtonGlyph.LoadFromResource(HInstance, 'DX_FILTERCONTROLADDBUTTON', 'SVG');
  end;
  Result := FFilterControlAddButtonGlyph;
end;

function TcxCustomLookAndFeelPainter.GetFilterControlRemoveButtonGlyph: TdxSmartImage;
begin
  if FFilterControlRemoveButtonGlyph = nil then
  begin
    FFilterControlRemoveButtonGlyph := TdxSmartImage.Create;
    FFilterControlRemoveButtonGlyph.LoadFromResource(HInstance, 'DX_FILTERCONTROLREMOVEBUTTON', 'SVG');
  end;
  Result := FFilterControlRemoveButtonGlyph;
end;

function TcxCustomLookAndFeelPainter.GetFilterCustomizeButtonContentOffsets(
  AScaleFactor: TdxScaleFactor): TdxPadding;
begin
  Result := TdxPadding.Create(cxTextOffset + ButtonBorderSize + ScaledButtonTextOffset(dxDefaultScaleFactor))
    .GetInflated(TdxVisualRefinements.Padding).GetScaled(AScaleFactor);
end;

function TcxCustomLookAndFeelPainter.GetFilterPanelRemoveButtonGlyph: TdxSmartImage;
begin
  if FFilterPanelRemoveButtonGlyph = nil then
  begin
    FFilterPanelRemoveButtonGlyph := TdxSmartImage.Create;
    FFilterPanelRemoveButtonGlyph.LoadFromResource(HInstance, 'DX_FILTERPANELREMOVEBUTTON', 'SVG');
  end;
  Result := FFilterPanelRemoveButtonGlyph;
end;

function TcxCustomLookAndFeelPainter.GetFindPanelNextButtonGlyph: TdxSmartImage;
begin
  if FFindPanelNextButtonGlyph = nil then
  begin
    FFindPanelNextButtonGlyph := TdxSmartImage.Create;
    FFindPanelNextButtonGlyph.LoadFromResource(HInstance, 'CX_DOWN', 'SVG');
  end;
  Result := FFindPanelNextButtonGlyph;
end;

function TcxCustomLookAndFeelPainter.GetFindPanelPreviousButtonGlyph: TdxSmartImage;
begin
  if FFindPanelPreviousButtonGlyph = nil then
  begin
    FFindPanelPreviousButtonGlyph := TdxSmartImage.Create;
    FFindPanelPreviousButtonGlyph.LoadFromResource(HInstance, 'CX_UP', 'SVG');
  end;
  Result := FFindPanelPreviousButtonGlyph;
end;

function TcxCustomLookAndFeelPainter.GetFixedGroupIndicator: TdxSmartImage;
begin
  if FFixedGroupIndicator = nil then
  begin
    FFixedGroupIndicator := TdxSmartImage.Create;
    FFixedGroupIndicator.LoadFromResource(HInstance, 'CX_FIXEDGROUPINDICATOR', 'PNG');
  end;
  Result := FFixedGroupIndicator;
end;

function TcxCustomLookAndFeelPainter.GetGroupByBoxSearchButtonGlyph: TdxSmartImage;
begin
  if FGroupByBoxSearchButtonGlyph = nil then
  begin
    FGroupByBoxSearchButtonGlyph := TdxSmartImage.Create;
    FGroupByBoxSearchButtonGlyph.LoadFromResource(HInstance, 'CX_GROUPBYBOXSEARCHBUTTON', 'SVG');
  end;
  Result := FGroupByBoxSearchButtonGlyph;
end;

function TcxCustomLookAndFeelPainter.GetMapPushpin: TdxSmartImage;
begin
  if FMapPushpin = nil then
  begin
    FMapPushpin := TdxSmartImage.Create;
    FMapPushpin.LoadFromResource(HInstance, 'DX_MAPPUSHPIN', 'PNG');
  end;
  Result := FMapPushpin;
end;

function TcxCustomLookAndFeelPainter.GetNavigationBarCustomizationButton: TdxSmartImage;
begin
  if FNavigationBarCustomizationButton = nil then
  begin
    FNavigationBarCustomizationButton := TdxSmartImage.Create;
    FNavigationBarCustomizationButton.LoadFromResource(HInstance, 'DX_NAVIGATIONBARCUSTOMIZATIONBUTTON', 'PNG');
  end;
  Result := FNavigationBarCustomizationButton;
end;

function TcxCustomLookAndFeelPainter.GetPasswordRevealButtonGlyphs(Index: Boolean): TdxSmartImage;

  function LoadGlyph(const AResourceName: string): TdxSmartGlyph;
  begin
    Result := TdxSmartGlyph.Create;
    Result.LoadFromResource(HInstance, AResourceName, 'SVG');
  end;

begin
  if FPasswordRevealButtonGlyphs[Index] = nil then
  begin
    FPasswordRevealButtonGlyphs[True] := LoadGlyph('DX_PASSWORDREVEALVISIBLEBUTTON');
    FPasswordRevealButtonGlyphs[False] := LoadGlyph('DX_PASSWORDREVEALINVISIBLEBUTTON');
  end;
  Result := FPasswordRevealButtonGlyphs[Index];
end;

function TcxCustomLookAndFeelPainter.GetPinGlyph: TdxSmartImage;
begin
  if FPinGlyph = nil then
  begin
    FPinGlyph := TdxSmartGlyph.Create;
    FPinGlyph.LoadFromResource(HInstance, 'DX_PIN', 'SVG');
  end;
  Result := FPinGlyph;
end;

function TcxCustomLookAndFeelPainter.GetRangeTrackBarThumbDrawRect(const R: TRect; ATicks: TcxTrackBarTicksAlign;
  AHorizontal: Boolean): TRect;
begin
  Result := R;
  if ATicks in [tbtaUp, tbtaDown] then
    if AHorizontal then
      Dec(Result.Right)
    else
      Dec(Result.Bottom);
end;

function TcxCustomLookAndFeelPainter.GetRatingControlIndicator: TdxSmartImage;
begin
  if FRatingControlIndicator = nil then
  begin
    FRatingControlIndicator := TdxSmartImage.Create;
    if dxUseVectorIcons then
      FRatingControlIndicator.LoadFromResource(HInstance, 'CX_RATINGCONTROLINDICATOR', 'SVG')
    else
      FRatingControlIndicator.LoadFromResource(HInstance, 'CX_RATINGCONTROLINDICATOR', 'PNG');
  end;
  Result := FRatingControlIndicator;
end;

function TcxCustomLookAndFeelPainter.GetSearchButtonGlyph: TdxSmartImage;
begin
  if FSearchButtonGlyph = nil then
  begin
    FSearchButtonGlyph := TdxSmartImage.Create;
    FSearchButtonGlyph.LoadFromResource(HInstance, 'DX_SEARCHBUTTONGLYPH', 'PNG');
  end;
  Result := FSearchButtonGlyph;
end;

function TcxCustomLookAndFeelPainter.GetBackButtonSize: TSize;
begin
  Result := GetScaledBackButtonSize(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.GetScaledBackButtonSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  Result := AScaleFactor.Apply(TSize.Create(BackButton.Width, BackButton.Height div 4));
end;

procedure TcxCustomLookAndFeelPainter.DrawBackButton(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState);
begin
  DrawScaledBackButton(ACanvas, R, AState, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledBackButton(
  ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
const
  OffsetMap: array[TcxButtonState] of Integer = (0, 0, 1, 2, 3);
var
  ASourceRect: TRect;
begin
  ASourceRect := cxRectSetHeight(BackButton.ClientRect, GetScaledBackButtonSize(dxDefaultScaleFactor).cy);
  ASourceRect := cxRectOffset(ASourceRect, 0, OffsetMap[AState] * GetScaledBackButtonSize(dxDefaultScaleFactor).cy);
  BackButton.StretchDraw(ACanvas.Handle, R, ASourceRect);
end;

procedure TcxCustomLookAndFeelPainter.DrawBevelFrame(
  ACanvas: TcxCanvas; const R: TRect; AColor1, AColor2: TColor; ABoxStyle: Boolean);
var
  ABorderWidth: Integer;
  ARect: TRect;
begin
  ABorderWidth := 1;{AScaleFactor.Apply(1);}
  if AColor2 = clNone then
    ACanvas.FrameRect(R, AColor1, ABorderWidth)
  else
    if ABoxStyle then
      ACanvas.DrawComplexFrame(R, AColor1, AColor2, cxBordersAll, ABorderWidth)
    else
    begin
      ARect := R;
      ARect.Inflate(-ABorderWidth, -ABorderWidth, 0, 0);
      ACanvas.FrameRect(ARect, AColor2, ABorderWidth);
      ARect.Offset(-ABorderWidth, -ABorderWidth);
      ACanvas.FrameRect(ARect, AColor1, ABorderWidth);
    end;
end;

procedure TcxCustomLookAndFeelPainter.DrawBevelLine(ACanvas: TcxCanvas;
  const R: TRect; AColor1, AColor2: TColor; AIsVertical: Boolean);
const
  BordersMap: array[Boolean] of TcxBorders = ([bTop, bBottom], [bLeft, bRight]);
begin
  if AColor2 <> clNone then
    ACanvas.DrawComplexFrame(R, AColor1, AColor2, BordersMap[AIsVertical])
  else
    ACanvas.FillRect(R, AColor1);
end;

procedure TcxCustomLookAndFeelPainter.DrawBevelShape(
  ACanvas: TcxCanvas; const R: TRect; AShape: TdxBevelShape; AStyle: TdxBevelStyle);

  procedure PrepareShapeColors(out AColor1, AColor2: TColor);
  begin
    GetBevelShapeColors(AColor1, AColor2);
    if AStyle = dxbsRaised then
      cxExchangeColors(AColor1, AColor2);
    if AColor1 = clNone then
      cxExchangeColors(AColor1, AColor2);
  end;

var
  AColor1, AColor2: TColor;
  AMinSize: TSize;
begin
  AMinSize := GetBevelMinimalShapeSize(AShape);
  PrepareShapeColors(AColor1, AColor2);
  case AShape of
    dxbsLineTop:
      DrawBevelLine(ACanvas, cxRectSetHeight(R, AMinSize.cy), AColor1, AColor2, False);
    dxbsLineBottom:
      DrawBevelLine(ACanvas, cxRectSetBottom(R, R.Bottom, AMinSize.cy), AColor1, AColor2, False);
    dxbsLineLeft:
      DrawBevelLine(ACanvas, cxRectSetWidth(R, AMinSize.cx), AColor1, AColor2, True);
    dxbsLineRight:
      DrawBevelLine(ACanvas, cxRectSetRight(R, R.Right, AMinSize.cx), AColor1, AColor2, True);
    dxbsLineCenteredHorz:
      DrawBevelLine(ACanvas, cxRectCenterHorizontally(R, AMinSize.cx), AColor1, AColor2, True);
    dxbsLineCenteredVert:
      DrawBevelLine(ACanvas, cxRectCenterVertically(R, AMinSize.cy), AColor1, AColor2, False);
    dxbsBox, dxbsFrame:
      DrawBevelFrame(ACanvas, R, AColor1, AColor2, AShape = dxbsBox);
  end;
end;

function TcxCustomLookAndFeelPainter.GetBevelMinimalShapeSize(AShape: TdxBevelShape): TSize;
begin
  Result.Init(2);
end;

procedure TcxCustomLookAndFeelPainter.GetBevelShapeColors(out AColor1, AColor2: TColor);
begin
  AColor1 := clBtnShadow;
  AColor2 := clBtnHighlight;
end;

procedure TcxCustomLookAndFeelPainter.DrawCalendarDateCellSelection(
  ACanvas: TcxCanvas; const ARect: TRect; AStates: TcxCalendarElementStates);
begin
  if cesMarked in AStates then
    DrawDateNavigatorTodayCellSelection(ACanvas, ARect);
end;

procedure TcxCustomLookAndFeelPainter.DrawModernCalendarArrow(ACanvas: TcxCanvas;
  const ARect: TRect; ADirection: TcxArrowDirection; AState: TcxCalendarElementState);
begin
  DrawScaledModernCalendarArrow(ACanvas, ARect, ADirection, AState, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledModernCalendarArrow(ACanvas: TcxCanvas;
  const ARect: TRect; ADirection: TcxArrowDirection; AState: TcxCalendarElementState; AScaleFactor: TdxScaleFactor);
var
  P: TcxArrowPoints;
  R: TRect;
  AColor: TColor;
begin
  R := ARect;
  Dec(R.Bottom);
  CalculateArrowPoints(R, P, ADirection, False);
  if AState in [cesHot, cesPressed] then
    AColor := GetModernCalendarSelectedTextColor
  else
    if AState = cesDisabled then
      AColor := clGrayText
    else
      AColor := clBtnText;
  ACanvas.Brush.Color := AColor;
  ACanvas.Pen.Color := AColor;
  ACanvas.Polygon(P);
end;

procedure TcxCustomLookAndFeelPainter.DrawModernCalendarClock(ACanvas: TcxCanvas;
  const ARect: TRect; ADateTime: TDateTime; ABackgroundColor: TColor; AScaleFactor: TdxScaleFactor);
var
  ABitmap: TcxBitmap;
  ARectImage150: TRect;
begin
  ABitmap := TcxBitmap.CreateSize(ARect);
  try
    if ABackgroundColor = clNone then
      cxBitBlt(ABitmap.cxCanvas.Handle, ACanvas.Handle, ARect, cxNullPoint, SRCCOPY)
    else
      ABitmap.cxCanvas.FillRect(ARect, ABackgroundColor);
    ARectImage150 := ARect;
    ARectImage150.Deflate(MulDiv(4, AScaleFactor.TargetDPI, 144), MulDiv(4, AScaleFactor.TargetDPI, 144), 0, 0);
    if AScaleFactor.Apply(100) >= 150 then
      ABitmap.cxCanvas.StretchDraw(ARectImage150, ClockFace150)
    else
      ABitmap.cxCanvas.StretchDraw(ARect, ClockFace);
    DrawScaledModernClockHands(ABitmap.cxCanvas, ARect, ADateTime, $464646, AScaleFactor);
    if AScaleFactor.Apply(100) >= 150 then
      ABitmap.cxCanvas.StretchDraw(ARectImage150, ClockGlass150)
    else
      ABitmap.cxCanvas.StretchDraw(ARect, ClockGlass);
    cxBitBlt(ACanvas.Handle, ABitmap.cxCanvas.Handle, ARect, cxNullPoint, SRCCOPY)
  finally
    ABitmap.Free;
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawModernCalendarDateCellSelection(
  ACanvas: TcxCanvas; const ARect: TRect; AStates: TcxCalendarElementStates);

  procedure GetColors(out ABorderColor, ABackgroundColor: TColor);
  begin
    if cesSelected in AStates then
      if cesHot in AStates then
      begin
        ABorderColor := $E8A766;
        ABackgroundColor := $FFE8D1;
      end
      else
        if cesFocused in AStates then
        begin
          ABorderColor := $DAA026;
          ABackgroundColor := $F6E8CB;
        end
        else
        begin
          ABackgroundColor := $F7F7F7;
          ABorderColor := $DEDEDE;
        end
    else
      if cesHot in AStates then
      begin
        ABorderColor := $E7C070;
        ABackgroundColor := $FBF3E5;
      end
      else
      begin
        ABorderColor := clNone;
        ABackgroundColor := clNone;
      end;
  end;

var
  AInnerBounds: TRect;
  ABorderColor, ABackgroundColor: TColor;
begin
  AInnerBounds := ARect;
  AInnerBounds.Inflate(-1, -1);
  if AStates * [cesHot, cesSelected] <> [] then
  begin
    GetColors(ABorderColor, ABackgroundColor);
    if ABorderColor <> clNone then
      ACanvas.FrameRect(ARect, ABorderColor);
    if ABackgroundColor <> clNone then
      ACanvas.FillRect(AInnerBounds, ABackgroundColor);
  end;

  if cesMarked in AStates then
    ACanvas.FrameRect(ARect, GetModernCalendarMarkedCellBorderColor);

  if (cesFocused in AStates) and SupportsNativeFocusRect then
    ACanvas.DrawFocusRect(AInnerBounds);
end;

procedure TcxCustomLookAndFeelPainter.DrawModernCalendarDateHeaderSelection(
  ACanvas: TcxCanvas; const ARect: TRect; AStates: TcxCalendarElementStates);
begin
end;

procedure TcxCustomLookAndFeelPainter.DrawModernCalendarHeaderSelection(
  ACanvas: TcxCanvas; const ARect: TRect; AStates: TcxCalendarElementStates);
begin
  if AStates * [cesHot, cesPressed] <> [] then
    ACanvas.Font.Style := ACanvas.Font.Style + [fsUnderline];
end;

function TcxCustomLookAndFeelPainter.GetModernCalendarCellTextColor(AStates: TcxCalendarElementStates): TColor;
begin
  if cesDisabled in AStates then
    Result := clGrayText
  else if (cesHot in AStates) or (AStates * [cesMarked, cesSelected] = [cesMarked]) then
    Result := GetModernCalendarSelectedTextColor
  else if (cesHighlighted in AStates) then
    Result := DefaultDateNavigatorWeekendTextColor
  else
    Result := clBtnText;
end;

function TcxCustomLookAndFeelPainter.GetModernCalendarDateHeaderTextColor(
  AStates: TcxCalendarElementStates): TColor;
var
  AIsHighlighted: Boolean;
begin
  AIsHighlighted := AStates = [cesHot];
  if AIsHighlighted then
    Result := GetModernCalendarSelectedTextColor
  else
    Result := DefaultDateNavigatorHeaderTextColor(False);
end;

function TcxCustomLookAndFeelPainter.GetModernCalendarHeaderTextColor(AStates: TcxCalendarElementStates): TColor;
begin
  Result := clHotLight;
end;

function TcxCustomLookAndFeelPainter.GetModernCalendarHeaderTextOffsets: TRect;
begin
  Result := cxNullRect;
end;

function TcxCustomLookAndFeelPainter.GetModernCalendarMarkedCellBorderColor: TColor;
begin
  Result := clHotLight;
end;

function TcxCustomLookAndFeelPainter.GetModernCalendarSelectedTextColor: TColor;
begin
  Result := clHotLight;
end;

procedure TcxCustomLookAndFeelPainter.DrawModernClockHands(
  ACanvas: TcxCanvas; const ARect: TRect; ADateTime: TDateTime; AColor: TColor);
begin
  DrawScaledModernClockHands(ACanvas, ARect, ADateTime, AColor, dxDefaultScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledModernClockHands(ACanvas: TcxCanvas;
  const ARect: TRect; ADateTime: TDateTime; AColor: TColor; AScaleFactor: TdxScaleFactor);

    procedure DrawHand(AGPGraphics: TdxGPGraphics; const R: TRect;
      AAngle: Single; AStartOffset, AEndOffset: Single; AWidth: Single; AHandColor: TColor);
    var
      ACenter, ARadius: TdxPointF;
    begin
      ACenter := cxRectCenter(dxRectF(R));
      ARadius.X := R.Width / 2;
      ARadius.Y := R.Height / 2;
      AGPGraphics.Line(
        ACenter.X - ARadius.X * AStartOffset * Cos(AAngle), ACenter.Y - ARadius.Y * AStartOffset * Sin(AAngle),
        ACenter.X + ARadius.X * AEndOffset * Cos(AAngle), ACenter.Y + ARadius.Y * AEndOffset * Sin(AAngle),
        dxColorToAlphaColor(AHandColor), AWidth * AScaleFactor.Numerator / AScaleFactor.Denominator);
    end;

var
  AAngle: Single;
  AHour, AMin, AMSec, ASec: Word;
  AGPGraphics: TdxGPGraphics;
begin
  DecodeTime(ADateTime, AHour, AMin, ASec, AMSec);
  AGPGraphics := dxGpBeginPaint(ACanvas.Handle, ARect);
  try
    AGPGraphics.SmoothingMode := smAntiAlias;

    AAngle := Pi * 2 * ((AHour mod 12) * 60 * 60 + AMin * 60 + ASec - 3 * 60 * 60) / 12 / 60 / 60;
    DrawHand(AGPGraphics, ARect, AAngle, 0.05, 0.55, 1.8, AColor);

    AAngle := Pi * 2 * (AMin * 60 + ASec - 15 * 60) / 60 / 60;
    DrawHand(AGPGraphics, ARect, AAngle, 0.05, 0.7, 1.8, AColor);

    AAngle := Pi * 2 * (ASec - 15) / 60;
    DrawHand(AGPGraphics, ARect, AAngle, 0.1, 0.745, 1, AColor);
  finally
    dxGpEndPaint(AGPGraphics);
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawRatingControlScaledIndicator(
  ACanvas: TcxCanvas; const ABounds: TRect; AState: TdxRatingControlIndicatorState; AScaleFactor: TdxScaleFactor);
const
  OffsetMap: array[TdxRatingControlIndicatorState] of Integer = (0, 2, 1);
var
  ASourceRect: TRect;
  AHeight: Integer;
begin
  if dxUseVectorIcons then
    TdxImageDrawer.DrawImage(ACanvas, ABounds, RatingControlIndicator, nil, -1, AState <> rcisUnchecked, nil, AScaleFactor)
  else
  begin
    AHeight := RatingControlIndicator.Height div 3;
    ASourceRect := cxRectSetHeight(RatingControlIndicator.ClientRect, AHeight);
    ASourceRect.Offset(0, OffsetMap[AState] * AHeight);
    RatingControlIndicator.StretchDraw(ACanvas.Handle, ABounds, ASourceRect);
  end;

end;

procedure TcxCustomLookAndFeelPainter.DrawRatingControlIndicator(
  ACanvas: TcxCanvas; const ABounds: TRect; AState: TdxRatingControlIndicatorState);
begin
  DrawRatingControlScaledIndicator(ACanvas, ABounds, AState, dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.GetRatingControlIndicatorSize: TSize;
begin
  Result := GetRatingControlScaledIndicatorSize(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.GetRatingControlIndicatorColorPalette(
  AState: TdxRatingControlIndicatorState): IdxColorPalette;
begin
  Result := nil;
end;

function TcxCustomLookAndFeelPainter.GetRatingControlScaledIndicatorSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  if dxUseVectorIcons then
    Result := AScaleFactor.Apply(TSize.Create(RatingControlIndicator.Width, RatingControlIndicator.Height))
  else
    Result := AScaleFactor.Apply(TSize.Create(RatingControlIndicator.Width, RatingControlIndicator.Height div 3));
end;

function TcxCustomLookAndFeelPainter.GetRibbonColorGalleryContentOffsets(AScaleFactor: TdxScaleFactor): TdxPadding;
begin
  Result := AScaleFactor.Apply(TdxPadding.Create(5));
end;

function TcxCustomLookAndFeelPainter.GetRibbonGalleryContentOffsets(AScaleFactor: TdxScaleFactor): TdxPadding;
begin
  Result.Empty;
end;

function TcxCustomLookAndFeelPainter.GetRibbonGalleryItemCaptionContentOffsets(AScaleFactor: TdxScaleFactor): TdxPadding;
begin
  Result.Empty;
end;

function TcxCustomLookAndFeelPainter.GetRibbonGalleryItemFixedIndentBetweenCaptionAndDescription(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := 0;
end;

function TcxCustomLookAndFeelPainter.GetRibbonGalleryItemFixedIndentBetweenImageAndText(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := AScaleFactor.Apply(3); 
end;

function TcxCustomLookAndFeelPainter.GetRibbonGalleryItemContentOffsets(AScaleFactor: TdxScaleFactor): TdxPadding;
begin
  Result.Init(AScaleFactor.Apply(3));
end;

function TcxCustomLookAndFeelPainter.GetRibbonGalleryItemImageContentOffsets(AScaleFactor: TdxScaleFactor): TdxPadding;
begin
  Result.Empty;
end;

function TcxCustomLookAndFeelPainter.GetDropdownGalleryContentOffsets(AScaleFactor: TdxScaleFactor): TdxPadding;
begin
  Result.Empty;
end;

function TcxCustomLookAndFeelPainter.GetDropdownGalleryFilterContentOffsets(AScaleFactor: TdxScaleFactor): TdxPadding;
begin
  Result := AScaleFactor.Apply(TRect.Create(7, 2, 7, 2));
end;

function TcxCustomLookAndFeelPainter.GetDropDownGalleryItemCaptionContentOffsets(AScaleFactor: TdxScaleFactor): TdxPadding;
begin
  Result.Empty;
end;

function TcxCustomLookAndFeelPainter.GetDropDownGalleryItemContentOffsets(AScaleFactor: TdxScaleFactor): TdxPadding;
begin
  Result.Init(AScaleFactor.Apply(3));
end;

function TcxCustomLookAndFeelPainter.GetDropDownGalleryItemDescriptionContentOffsets(AScaleFactor: TdxScaleFactor): TdxPadding;
begin
  Result.Empty;
end;

function TcxCustomLookAndFeelPainter.GetDropDownGalleryItemFixedIndentBetweenCaptionAndDescription(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := AScaleFactor.Apply(3); 
end;

function TcxCustomLookAndFeelPainter.GetDropDownGalleryItemFixedIndentBetweenImageAndText(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := AScaleFactor.Apply(3); 
end;

function TcxCustomLookAndFeelPainter.GetDropDownGalleryItemImageContentOffsets(AScaleFactor: TdxScaleFactor): TdxPadding;
begin
  Result.Empty;
end;

procedure TcxCustomLookAndFeelPainter.DrawFixedGroupIndicator(ACanvas: TcxCanvas; const ABounds: TRect);
begin
  DrawScaledFixedGroupIndicator(ACanvas, ABounds, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledFixedGroupIndicator(
  ACanvas: TcxCanvas; const ABounds: TRect; AScaleFactor: TdxScaleFactor);
begin
  FixedGroupIndicator.StretchDraw(ACanvas.Handle, ABounds);
end;

function TcxCustomLookAndFeelPainter.GetFixedGroupIndicatorSize: TSize;
begin
  Result := GetScaledFixedGroupIndicatorSize(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.GetScaledFixedGroupIndicatorSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  Result := AScaleFactor.Apply(FixedGroupIndicator.Size)
end;

function TcxCustomLookAndFeelPainter.GetWheelPickerBorderItemColor(AState: TcxButtonState): TColor;
begin
  case AState of
    cxbsHot:
      Result := RGB(217, 217, 217);
    cxbsPressed:
      Result := RGB(188, 201, 231);
  else
    Result := clDefault;
  end;
end;

function TcxCustomLookAndFeelPainter.GetWheelPickerColorPalette(AState: TcxButtonState): IdxColorPalette;
begin
  Result := nil;
end;

function TcxCustomLookAndFeelPainter.GetWheelPickerFillItemColor(AState: TcxButtonState): TColor;
begin
  case AState of
    cxbsHot:
      Result := RGB(239, 240, 242);
    cxbsPressed:
      Result := RGB(226, 234, 253);
  else
    Result := clDefault;
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawWheelPickerItem(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState);
begin
  DrawWheelPickerItemBackground(ACanvas, ARect, AState);
  DrawWheelPickerItemBorder(ACanvas, ARect, AState);
end;

procedure TcxCustomLookAndFeelPainter.DrawWheelPickerItemBackground(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState);
begin
  ACanvas.FillRect(ARect, GetWheelPickerFillItemColor(AState));
end;

procedure TcxCustomLookAndFeelPainter.DrawWheelPickerItemBorder(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState);
begin
  ACanvas.FrameRect(ARect, GetWheelPickerBorderItemColor(AState));
end;

function TcxCustomLookAndFeelPainter.RichEditControlHeaderFooterLineColor: TColor;
begin
  Result := clBtnShadow;
end;

function TcxCustomLookAndFeelPainter.RichEditControlHeaderFooterMarkBackColor: TColor;
begin
  Result := DefaultControlColor;
end;

function TcxCustomLookAndFeelPainter.RichEditControlHeaderFooterMarkTextColor: TColor;
begin
  Result := DefaultControlTextColor;
end;

function TcxCustomLookAndFeelPainter.RichEditRulerControlColor: TColor;
begin
  Result := DefaultControlColor;
end;

function TcxCustomLookAndFeelPainter.RichEditRulerActiveAreaColor: TColor;
begin
  Result := DefaultContentColor;
end;

function TcxCustomLookAndFeelPainter.RichEditRulerInactiveAreaColor: TColor;
begin
  Result := clBtnShadow;
end;

function TcxCustomLookAndFeelPainter.RichEditRulerDefaultTabColor: TColor;
begin
  Result := clBtnShadow;
end;

function TcxCustomLookAndFeelPainter.RichEditRulerTabTypeToggleBorderColor: TColor;
begin
  Result := cl3DDkShadow;
end;

function TcxCustomLookAndFeelPainter.RichEditRulerTextColor: TColor;
begin
  Result := DefaultControlTextColor;
end;

procedure TcxCustomLookAndFeelPainter.DrawTokenBackground(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState);
begin
  DrawScaledTokenBackground(ACanvas, R, AState, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledTokenBackground(
  ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
begin
  ACanvas.SaveClipRegion;
  try
    ACanvas.FrameRect(R, clBtnShadow);
    if not (AState in [cxbsNormal, cxbsDisabled]) then
    begin
      ACanvas.IntersectClipRect(cxRectInflate(R, -1));
      DrawScaledButton(ACanvas, R, AState, AScaleFactor);
    end;
  finally
    ACanvas.RestoreClipRegion;
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledTokenCloseGlyph(
  ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
begin
  DrawScaledButtonCrossEx(ACanvas, R, GetTokenTextColor(AState), AState, 7, AScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawTokenCloseGlyph(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState);
begin
  DrawScaledTokenCloseGlyph(ACanvas, R, AState, dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.GetTokenCloseGlyphSize: TSize;
begin
  Result := GetScaledTokenCloseGlyphSize(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.GetScaledTokenCloseGlyphSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  Result := AScaleFactor.Apply(TSize.Create(12, 11));
  dxAdjustToTouchableSize(Result.cx);
end;

function TcxCustomLookAndFeelPainter.GetTokenColorPalette(AState: TcxButtonState): IdxColorPalette;
begin
  Result := nil;
end;

function TcxCustomLookAndFeelPainter.GetScaledTokenContentOffsets(AIsInplace: Boolean; AScaleFactor: TdxScaleFactor): TRect;
begin
  Result.Init(AScaleFactor.Apply(3));
end;

function TcxCustomLookAndFeelPainter.GetTokenContentOffsets: TRect;
begin
  Result := GetScaledTokenContentOffsets(False, dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.GetScaledTokenDefaultGlyphSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  Result.Init(AScaleFactor.Apply(12));
end;

function TcxCustomLookAndFeelPainter.GetTokenDefaultGlyphSize: TSize;
begin
  Result := GetScaledTokenDefaultGlyphSize(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.GetTokenTextColor(AState: TcxButtonState): TColor;
begin
  Result := ButtonSymbolColor(AState);
end;

procedure TcxCustomLookAndFeelPainter.CalculateArrowPoints(R: TRect;
  var P: TcxArrowPoints; AArrowDirection: TcxArrowDirection; AProportional: Boolean; AArrowSize: Integer = 0);

  function _GetSize: TSize;
  begin
    if AArrowDirection in [adUp, adDown] then
    begin
      if AArrowSize = 0 then
        AArrowSize := (R.Width - 1) div 4 + 1;
      Result.cy := AArrowSize;
      Result.cx := AArrowSize * 2 - 1;
    end
    else
    begin
      if AArrowSize = 0 then
        AArrowSize := (R.Height - 1) div 4 + 1;
      Result.cx := AArrowSize;
      Result.cy := AArrowSize * 2 - 1;
    end
  end;

var
  ASize: TSize;
  ADelta: Integer;
begin
  if AProportional then
  begin
    ADelta := R.Width - R.Height;
    if ADelta > 0 then
      InflateRect(R, -ADelta div 2, 0)
    else
      InflateRect(R, 0, ADelta div 2);
  end;
  ASize := _GetSize;
  case AArrowDirection of
    adUp:
      begin
        P[cxArrowTopPointIndex] := Point((R.Left + R.Right - 1) div 2, MulDiv(R.Top + R.Bottom - ASize.cy, 1, 2){ - 1});
        P[cxArrowLeftBasePointIndex] := Point((R.Left + R.Right - ASize.cx) div 2, P[cxArrowTopPointIndex].Y + ASize.cy - 1);
        P[cxArrowRightBasePointIndex] := Point(P[cxArrowLeftBasePointIndex].X + ASize.cx - 1, P[cxArrowLeftBasePointIndex].Y);
      end;
    adDown:
      begin
        P[cxArrowRightBasePointIndex] := Point((R.Left + R.Right - ASize.cx) div 2, MulDiv(R.Top + R.Bottom - ASize.cy, 1, 2));
        P[cxArrowLeftBasePointIndex] := Point(P[cxArrowRightBasePointIndex].X + ASize.cx - 1, P[cxArrowRightBasePointIndex].Y);
        P[cxArrowTopPointIndex] := Point((R.Left + R.Right - 1) div 2, P[cxArrowRightBasePointIndex].Y + ASize.cy - 1);
      end;
    adLeft:
      begin
        P[cxArrowTopPointIndex] := Point((R.Left + R.Right - ASize.cx) div 2, (R.Top + R.Bottom (**)) div 2);
        P[cxArrowRightBasePointIndex] := Point(P[cxArrowTopPointIndex].X + ASize.cx - 1, MulDiv(R.Top + R.Bottom - ASize.cy, 1, 2));
        P[cxArrowLeftBasePointIndex] := Point(P[cxArrowRightBasePointIndex].X, P[cxArrowRightBasePointIndex].Y + ASize.cy - 1);
      end;
    adRight:
      begin
        P[cxArrowLeftBasePointIndex] := Point((R.Left + R.Right - ASize.cx) div 2, MulDiv(R.Top + R.Bottom - ASize.cy, 1, 2));
        P[cxArrowTopPointIndex] := Point(P[cxArrowLeftBasePointIndex].X + ASize.cx - 1, (R.Top + R.Bottom (**)) div 2);
        P[cxArrowRightBasePointIndex] := Point(P[cxArrowLeftBasePointIndex].X, P[cxArrowLeftBasePointIndex].Y + ASize.cy - 1);
      end;
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawArrow(ACanvas: TcxCustomCanvas;
  const R: TRect; AArrowDirection: TcxArrowDirection; AColor: TColor);
var
  P: TcxArrowPoints;
begin
  CalculateArrowPoints(R, P, AArrowDirection, True);
  ACanvas.FillPolygon(P, AColor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledArrow(ACanvas: TcxCustomCanvas;
  const R: TRect; AState: TcxButtonState; AArrowDirection: TcxArrowDirection;
  AScaleFactor: TdxScaleFactor; ADrawBorder: Boolean = True);
var
  P: TcxArrowPoints;
begin
  if ADrawBorder then
    DrawScaledArrowBorder(ACanvas, R, AState, AScaleFactor)
  else
    ACanvas.FillRect(R, ButtonColor(AState));

  CalculateArrowPoints(R, P, AArrowDirection, False);
  ACanvas.FillPolygon(P, ButtonSymbolColor(AState));
end;

procedure TcxCustomLookAndFeelPainter.DrawArrow(ACanvas: TcxCustomCanvas; const R: TRect;
  AState: TcxButtonState; AArrowDirection: TcxArrowDirection; ADrawBorder: Boolean = True);
begin
  DrawScaledArrow(ACanvas, R, AState, AArrowDirection, dxSystemScaleFactor, ADrawBorder);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledArrowBorder(
  ACanvas: TcxCustomCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
begin
  ACanvas.FillRect(R, ButtonColor(AState));
  DrawButtonBorder(ACanvas, R, AState);
end;

procedure TcxCustomLookAndFeelPainter.DrawArrowBorder(ACanvas: TcxCustomCanvas; const R: TRect; AState: TcxButtonState);
begin
  DrawScaledArrowBorder(ACanvas, R, AState, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawCollapseArrow(
  ACanvas: TcxCanvas; R: TRect; AColor: TColor; ALineWidth: Integer = 1);

  function CalculateArrowSize: Integer;
  begin
    Result := (Min(R.Width, R.Height) - 1) div 4;
  end;

  procedure PrepareRect(var R: TRect);
  var
    ADelta: Integer;
  begin
    ADelta := R.Width - R.Height;
    if ADelta > 0 then
      R.Inflate(-ADelta div 2, 0)
    else
      R.Inflate(0, ADelta div 2);
  end;

  procedure DoDrawArrow(X, Y, ASize: Integer);
  var
    I: Integer;
    R: TRect;
  begin
    R.Init(X, Y, X + ALineWidth, Y + 1);
    for I := 0 to ASize - 1 do
    begin
      ACanvas.FillRect(cxRectOffset(R, I, -I));
      ACanvas.FillRect(cxRectOffset(R, I,  I));
    end;
  end;

var
  ASize: Integer;
begin
  ASize := CalculateArrowSize;
  ACanvas.Brush.Color := AColor;
  R := cxRectCenterHorizontally(R, 3 * ALineWidth + ASize - 1);
  DoDrawArrow(R.Left, cxRectCenter(R).Y, ASize);
  DoDrawArrow(R.Left + 2 * ALineWidth, cxRectCenter(R).Y, ASize);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledScrollBarArrow(ACanvas: TcxCustomCanvas;
  R: TRect; AState: TcxButtonState; AArrowDirection: TcxArrowDirection; AScaleFactor: TdxScaleFactor);
var
  P: TcxArrowPoints;

  procedure OffsetPoints(ADelta: Integer);
  var
    I: Integer;
  begin
    for I := 0 to 2 do
    begin
      Inc(P[I].X, ADelta);
      Inc(P[I].Y, ADelta);
    end;
  end;

begin
  if AState = cxbsPressed then
    OffsetRect(R, ScaledButtonTextShift(AScaleFactor), ScaledButtonTextShift(AScaleFactor));
  CalculateArrowPoints(R, P, AArrowDirection, True);
  if AState = cxbsDisabled then
  begin
    OffsetPoints(AScaleFactor.Apply(1));
    ACanvas.FillPolygon(P, clBtnHighlight);
    OffsetPoints(AScaleFactor.Apply(-1));
    ACanvas.FillPolygon(P, clBtnShadow);
  end
  else
    ACanvas.FillPolygon(P, ButtonSymbolColor(AState));
end;

procedure TcxCustomLookAndFeelPainter.DrawScrollBarArrow(ACanvas: TcxCanvas;
  R: TRect; AState: TcxButtonState; AArrowDirection: TcxArrowDirection);
begin
  DrawScaledScrollBarArrow(ACanvas, R, AState, AArrowDirection, dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.BorderSize: Integer;
begin
  Result := 0;
end;

function TcxCustomLookAndFeelPainter.SeparatorSize: Integer;
begin
  Result := BorderSize;
end;

procedure TcxCustomLookAndFeelPainter.DrawBorder(ACanvas: TcxCustomCanvas; R: TRect; AWidth: Integer = 1);
begin
  // do nothing
end;

procedure TcxCustomLookAndFeelPainter.DrawContainerBorder(ACanvas: TcxCanvas; const R: TRect; AStyle: TcxContainerBorderStyle;
  AWidth: Integer; AColor: TColor; ABorders: TcxBorders);
begin
  case AStyle of
    cbsSingle, cbsThick:
      ACanvas.FrameRect(R, AColor, AWidth);
    cbsFlat:
      begin
        ACanvas.DrawEdge(R, True, True, ABorders);
        ACanvas.FrameRect(cxRectInflate(R, -1, -1), clBtnFace);
      end;
    cbs3D:
      begin
        ACanvas.DrawEdge(R, True, True, ABorders);
        ACanvas.DrawComplexFrame(cxRectInflate(R, -1, -1), cl3DDkShadow, cl3DLight, ABorders);
      end;
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawContainerBorderedBackground(ACanvas: TcxCanvas; const R: TRect; AStyle: TcxContainerBorderStyle;
  AWidth: Integer; AColor: TColor; ABorders: TcxBorders; AState: TcxContainerBorderState);
begin
  DrawContainerBorder(ACanvas, R, AStyle, AWidth, AColor, ABorders);
end;

procedure TcxCustomLookAndFeelPainter.DoDrawSeparator(ACanvas: TcxCustomCanvas; R: TRect; AIsVertical: Boolean);
begin
  Dec(R.Right);
  Dec(R.Bottom);
  ACanvas.FillRect(R, clBtnShadow);
  R.Offset(1, 1);
  ACanvas.FillRect(R, clBtnHighlight);
end;

procedure TcxCustomLookAndFeelPainter.DrawSeparator(ACanvas: TcxCustomCanvas; const R: TRect; AIsVertical: Boolean);
begin
  DoDrawSeparator(ACanvas, GetSeparatorBounds(R, SeparatorSize, AIsVertical), AIsVertical);
end;

function TcxCustomLookAndFeelPainter.SupportsRoundedContainerBorders(AControlID: Integer; AIsInplace: Boolean): Boolean;
begin
  Result := False;
end;

function TcxCustomLookAndFeelPainter.ButtonBorderSize(AState: TcxButtonState = cxbsNormal): Integer;
begin
  Result := 0;
end;

function TcxCustomLookAndFeelPainter.ButtonColor(AState: TcxButtonState): TColor;
begin
  Result := clBtnFace;
end;

function TcxCustomLookAndFeelPainter.ButtonColorPalette(AState: TcxButtonState; APart: TcxButtonPart): IdxColorPalette;
begin
  Result := nil;
end;

function TcxCustomLookAndFeelPainter.ButtonDescriptionTextColor(
  AState: TcxButtonState; ADefaultColor: TColor; APart: TcxButtonPart): TColor;
begin
  Result := ADefaultColor;
end;

function TcxCustomLookAndFeelPainter.ScaledButtonFocusRect(ACanvas: TcxCanvas; R: TRect; AScaleFactor: TdxScaleFactor): TRect;
begin
  Result := R;
  InflateRect(Result, AScaleFactor.Apply(-4), AScaleFactor.Apply(-4));
  if IsRectEmpty(Result) then
    Result := R;
end;

function TcxCustomLookAndFeelPainter.ButtonFocusRect(ACanvas: TcxCanvas; R: TRect): TRect;
begin
  Result := ScaledButtonFocusRect(ACanvas, R, dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.ScaledButtonTextOffset(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := 0;
end;

function TcxCustomLookAndFeelPainter.ButtonTextOffset: Integer;
begin
  Result := ScaledButtonTextOffset(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.ButtonTextShift: Integer;
begin
  Result := 0;
end;

function TcxCustomLookAndFeelPainter.ScaledButtonTextShift(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := ScaledButtonTextShift(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.ButtonSymbolColor(
  AState: TcxButtonState; ADefaultColor: TColor = clDefault; APart: TcxButtonPart = cxbpButton): TColor;
begin
  if AState = cxbsDisabled then
    Result := clBtnShadow
  else
    Result := cxGetActualColor(ADefaultColor, clBtnText);
end;

function TcxCustomLookAndFeelPainter.ButtonSymbolState(AState: TcxButtonState): TcxButtonState;
begin
  Result := AState;
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledButton(ACanvas: TcxCustomCanvas;
  R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor; APart: TcxButtonPart; AColor: TColor);
begin
  DrawScaledButton(ACanvas, R, AState, AScaleFactor, True, False, APart, AColor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledButton(ACanvas: TcxCustomCanvas;
  R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor; ADrawBorder: Boolean = True;
  AIsToolButton: Boolean = False; APart: TcxButtonPart = cxbpButton; AColor: TColor = clDefault);
begin
  DrawScaledButton(ACanvas, R, AState, False, AScaleFactor, ADrawBorder, AIsToolButton, APart, AColor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledButton(ACanvas: TcxCustomCanvas;
  R: TRect; AState: TcxButtonState; AFocused: Boolean; AScaleFactor: TdxScaleFactor; ADrawBorder: Boolean = True;
  AIsToolButton: Boolean = False; APart: TcxButtonPart = cxbpButton; AColor: TColor = clDefault);
begin
  if ADrawBorder then
  begin
    DrawButtonBorder(ACanvas, R, AState);
    R := cxRectInflate(R, -ButtonBorderSize(AState));
  end;
  if AColor = clDefault then
    AColor := ButtonColor(AState);
  ACanvas.FillRect(R, AColor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledButton(ACanvas: TcxCanvas; R: TRect; const ACaption: string;
  AState: TcxButtonState; AScaleFactor: TdxScaleFactor; ADrawBorder: Boolean = True; AColor: TColor = clDefault;
  ATextColor: TColor = clDefault; AWordWrap: Boolean = False; AIsToolButton: Boolean = False;
  APart: TcxButtonPart = cxbpButton);
begin
  DrawScaledButton(ACanvas, R, AState, False, AScaleFactor, ADrawBorder, AIsToolButton, APart, AColor);
  if ACaption <> '' then
    DoDrawScaledButtonCaption(ACanvas, R, ACaption, AState, ATextColor, ADrawBorder, AIsToolButton, AWordWrap, AScaleFactor, APart);
end;

procedure TcxCustomLookAndFeelPainter.DrawButton(ACanvas: TcxCanvas; R: TRect; const ACaption: string;
  AState: TcxButtonState; ADrawBorder: Boolean = True; AColor: TColor = clDefault; ATextColor: TColor = clDefault;
  AWordWrap: Boolean = False; AIsToolButton: Boolean = False; APart: TcxButtonPart = cxbpButton);
begin
  DrawScaledButton(ACanvas, R, ACaption, AState, dxSystemScaleFactor,
    ADrawBorder, AColor, ATextColor, AWordWrap, AIsToolButton, APart);
end;

function TcxCustomLookAndFeelPainter.GetDropDownButtonRightPartSize: Integer;
begin
  Result := GetScaledDropDownButtonRightPartSize(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.GetScaledClearButtonGlyphSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  Result := AScaleFactor.Apply(ClearButtonGlyph.Size);
end;

function TcxCustomLookAndFeelPainter.GetScaledDropDownButtonRightPartSize(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := AScaleFactor.Apply(15);
end;

function TcxCustomLookAndFeelPainter.DefaultCommandLinkTextColor(AState: TcxButtonState; ADefaultColor: TColor): TColor;
begin
  Result := ButtonSymbolColor(AState, ADefaultColor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledCommandLinkBackground(ACanvas: TcxCanvas;
  R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault);
begin
  DrawScaledButton(ACanvas, R, AState, AScaleFactor, cxbpButton, AColor);
end;

procedure TcxCustomLookAndFeelPainter.DrawCommandLinkBackground(
  ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AColor: TColor = clDefault);
begin
  DrawScaledCommandLinkBackground(ACanvas, R, AState, dxSystemScaleFactor, AColor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledCommandLinkGlyph(ACanvas: TcxCanvas;
  const AGlyphPos: TPoint; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
var
  ADestRect: TRect;
  ASrcRect: TRect;
  ACommandLinkGlyphs: TdxGPImage;
begin
  ACommandLinkGlyphs := TdxGPImage.Create;
  try
    ACommandLinkGlyphs.LoadFromResource(HInstance, 'CX_COMMANDLINKGLYPH', 'PNG');
    ASrcRect.InitSize(GetScaledCommandLinkGlyphSize(dxDefaultScaleFactor));
    ADestRect := cxRectSetOrigin(AScaleFactor.Apply(ASrcRect), AGlyphPos);
    if AState = cxbsHot then
      ASrcRect := cxRectSetOrigin(ASrcRect, Point(0, GetScaledCommandLinkGlyphSize(dxDefaultScaleFactor).cy));
    cxRightToLeftDependentDraw(ACanvas, ADestRect,
      procedure
      begin
        ACommandLinkGlyphs.StretchDraw(ACanvas.Handle, ADestRect, ASrcRect);
      end);
  finally
    ACommandLinkGlyphs.Free;
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawCommandLinkGlyph(
  ACanvas: TcxCanvas; const AGlyphPos: TPoint; AState: TcxButtonState);
begin
  DrawScaledCommandLinkGlyph(ACanvas, AGlyphPos, AState, dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.GetScaledCommandLinkGlyphSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  Result := AScaleFactor.Apply(Size(20, 20));
end;

function TcxCustomLookAndFeelPainter.GetCommandLinkGlyphSize: TSize;
begin
  Result := GetScaledCommandLinkGlyphSize(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.GetScaledCommandLinkMargins(AScaleFactor: TdxScaleFactor): TRect;
begin
  Result := AScaleFactor.Apply(Rect(7, 10, 7, 10));
end;

function TcxCustomLookAndFeelPainter.GetCommandLinkMargins: TRect;
begin
  Result := GetScaledCommandLinkMargins(dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledButtonCross(ACanvas: TcxCanvas;
  const R: TRect; AColor: TColor; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
var
  ASize: Integer;
begin
  ASize := ScaledFilterCloseButtonSize(AScaleFactor).X div 2;
  if not Odd(ASize) then
    Dec(ASize);
  DrawScaledButtonCrossEx(ACanvas, R, AColor, AState, ASize, dxDefaultScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawButtonCross(
  ACanvas: TcxCanvas; const R: TRect; AColor: TColor; AState: TcxButtonState);
begin
  DrawScaledButtonCross(ACanvas, R, AColor, AState, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledButtonCrossEx(ACanvas: TcxCanvas;
  const R: TRect; AColor: TColor; AState: TcxButtonState; ASize: Integer; AScaleFactor: TdxScaleFactor);

  procedure DrawOneMark(ADelta: Integer);
  var
    P: TPoint;
  begin
    P := Point((R.Left + R.Right - ASize) div 2 + ADelta, (R.Top + R.Bottom - ASize) div 2);
    if AState = cxbsPressed then
    begin
      Inc(P.X);
      Inc(P.Y);
    end;
    ACanvas.MoveTo(P.X, P.Y);
    ACanvas.LineTo(P.X + ASize, P.Y + ASize);
    ACanvas.MoveTo(P.X, P.Y + ASize - 1);
    ACanvas.LineTo(P.X + ASize, P.Y - 1);
  end;

var
  I: Integer;
begin
  ACanvas.Pen.Color := AColor;
  ASize := AScaleFactor.Apply(ASize);
  for I := 0 to 1 do
    DrawOneMark(I);
end;

procedure TcxCustomLookAndFeelPainter.DrawButtonCross(ACanvas: TcxCanvas;
  const R: TRect; AColor: TColor; AState: TcxButtonState; ASize: Integer);
begin
  DrawScaledButtonCrossEx(ACanvas, R, AColor, AState, ASize, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawButtonBorder(ACanvas: TcxCustomCanvas; R: TRect; AState: TcxButtonState);
begin
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledClearButtonGlyph(ACanvas: TcxCanvas; const R: TRect;
  AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
var
  AColor: TdxAlphaColor;
  APalette: TdxSimpleColorPalette;
begin
  if AState in [cxbsHot, cxbsPressed] then
    AColor := $FFED3D3B
  else
    AColor := $10203;
  APalette := TdxSimpleColorPalette.Create(AColor, TdxAlphaColors.Empty);
  ClearButtonGlyph.StretchDraw(ACanvas.Handle, R, MaxByte, APalette);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledDropDownButtonArrow(ACanvas: TcxCustomCanvas; R: TRect;
  AState: TcxButtonState; AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault);
begin
  DrawScaledButton(ACanvas, R, AState, AScaleFactor, False, False, cxbpDropDownRightPart, AColor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledSearchEditButtonGlyph(
  ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
var
  AGlyphRect: TRect;
begin
  AGlyphRect := SearchButtonGlyph.ClientRect;
  AGlyphRect.Bottom := AGlyphRect.Height div 4;
  SearchButtonGlyph.StretchDraw(ACanvas.Handle,
    cxRectCenter(R, ScaledSearchButtonGlyphSize(AScaleFactor)),
    cxRectOffset(AGlyphRect, 0, AGlyphRect.Height * (Ord(AState) - 1)));
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledPasswordRevealButton(ACanvas: TcxCanvas; const ARect: TRect;
  AButtonState: TcxButtonState; AColor: TColor; AScaleFactor: TdxScaleFactor);
var
  AFillColor: TdxAlphaColor;
  APalette: TdxSimpleColorPalette;
begin
  AFillColor := dxColorToAlphaColor(AColor);
  if AButtonState = cxbsPressed then
  begin
    ACanvas.FillRect(ARect, clHighlight);
    AFillColor := dxColorToAlphaColor(clHighlightText);
  end;
  if AButtonState = cxbsHot then
    AFillColor := dxColorToAlphaColor(clHighlight);
  APalette := TdxSimpleColorPalette.Create(AFillColor, TdxAlphaColors.Empty);
  PasswordRevealButtonGlyphs[AButtonState = cxbsPressed].StretchDraw(ACanvas.Handle, ARect, MaxByte, APalette);
end;

procedure TcxCustomLookAndFeelPainter.DrawSearchEditButtonGlyph(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState);
begin
  DrawScaledSearchEditButtonGlyph(ACanvas, R, AState, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawExpandButton(
  ACanvas: TcxCanvas; const R: TRect; AExpanded: Boolean; AColor: TColor = clDefault);
begin
  DrawScaledExpandButton(ACanvas, R, AExpanded, dxSystemScaleFactor, AColor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledExpandButton(ACanvas: TcxCanvas; const R: TRect;
  AExpanded: Boolean; AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault;
  AState: TcxExpandButtonState = cebsNormal);
begin
  DrawScaledExpandButton(TcxCustomCanvas(ACanvas), R, AExpanded, AScaleFactor, AColor, AState);
  ACanvas.ExcludeClipRect(R);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledExpandButtonEx(ACanvas: TcxCanvas; const R: TRect;
  AState: TcxButtonState; AExpanded: Boolean; AScaleFactor: TdxScaleFactor; ARotationAngle: TcxRotationAngle = ra0);
var
  ABitmap: TcxBitmap;
  ARect: TRect;
begin
  DrawScaledButton(ACanvas, R, AState, AScaleFactor);
  if ARotationAngle in [raMinus90, raPlus90] then
    ARect := cxRectRotate(R)
  else
    ARect := R;

  ABitmap := TcxBitmap.CreateSize(ARect);
  try
    ABitmap.cxCanvas.FillRect(ABitmap.ClientRect, ButtonColor(AState));
    DrawScaledExpandMark(ABitmap.cxCanvas, ABitmap.ClientRect, ButtonSymbolColor(AState), AExpanded, AScaleFactor);
    ACanvas.RotateBitmap(ABitmap, ARotationAngle);
    TdxImageDrawer.DrawUncachedImage(ACanvas.Handle, R, R, ABitmap, nil, -1, idmNormal);
  finally
    ABitmap.Free;
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawExpandButtonEx(ACanvas: TcxCanvas; const R: TRect;
  AState: TcxButtonState; AExpanded: Boolean; ARotationAngle: TcxRotationAngle = ra0);
begin
  DrawScaledExpandButtonEx(ACanvas, R, AState, AExpanded, dxSystemScaleFactor, ARotationAngle);
end;

function TcxCustomLookAndFeelPainter.DrawExpandButtonFirst: Boolean;
begin
  Result := True;
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledGroupExpandButton(ACanvas: TcxCustomCanvas;
  const R: TRect; AExpanded: Boolean; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
begin
  DrawScaledButton(ACanvas, R, AState, AScaleFactor);
  DrawScaledExpandMark(ACanvas, R, ButtonSymbolColor(AState), AExpanded, AScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawGroupExpandButton(
  ACanvas: TcxCanvas; const R: TRect; AExpanded: Boolean; AState: TcxButtonState);
begin
  DrawScaledGroupExpandButton(ACanvas, R, AExpanded, AState, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawSmallExpandButton(ACanvas: TcxCanvas;
  R: TRect; AExpanded: Boolean; ABorderColor: TColor; AColor: TColor = clDefault);
begin
  DrawScaledSmallExpandButton(ACanvas, R, AExpanded, ABorderColor, dxSystemScaleFactor, AColor);
end;

procedure TcxCustomLookAndFeelPainter.DrawTreeViewExpandButton(ACanvas: TcxCanvas; const R: TRect;
  AExpanded: Boolean; AExplorerStyle: Boolean; AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault;
  AState: TcxExpandButtonState = cebsNormal);
begin
  DrawScaledExpandButton(ACanvas, R, AExpanded, AScaleFactor, AColor, AState);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledSmallExpandButton(ACanvas: TcxCanvas; R: TRect;
  AExpanded: Boolean; ABorderColor: TColor; AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault);
begin
  ACanvas.Brush.Color := ABorderColor;
  ACanvas.FrameRect(R);
  if AColor <> clDefault then
  begin
    InflateRect(R, -1, -1);
    ACanvas.Brush.Color := AColor;
    ACanvas.FillRect(R);
    InflateRect(R, 1, 1);
  end;
  DrawExpandButtonCross(ACanvas, R, AExpanded, clBtnText, AScaleFactor);
end;

function TcxCustomLookAndFeelPainter.ScaledExpandButtonAreaSize(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := ScaledExpandButtonSize(AScaleFactor);
  dxAdjustToTouchableSize(Result);
end;

function TcxCustomLookAndFeelPainter.ExpandButtonAreaSize: Integer;
begin
  Result := ScaledExpandButtonAreaSize(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.ExpandButtonSize: Integer;
begin
  Result := ScaledExpandButtonSize(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.ScaledGroupExpandButtonSize(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := AScaleFactor.Apply(15);
end;

function TcxCustomLookAndFeelPainter.GroupExpandButtonSize: Integer;
begin
  Result := ScaledGroupExpandButtonSize(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.IsButtonHotTrack: Boolean;
begin
  Result := False;
end;

function TcxCustomLookAndFeelPainter.IsPointOverGroupExpandButton(const R: TRect; const P: TPoint): Boolean;
begin
  Result := PtInRect(R, P);
end;

function TcxCustomLookAndFeelPainter.ScaledSearchButtonGlyphSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  Result.cx := SearchButtonGlyph.Width;
  Result.cy := SearchButtonGlyph.Height div 4;
  Result := AScaleFactor.Apply(Result);
end;

function TcxCustomLookAndFeelPainter.ScaledSmallExpandButtonSize(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := AScaleFactor.Apply(9);
end;

function TcxCustomLookAndFeelPainter.TreeListScaleGridLines: Boolean;
begin
  Result := GridScaleGridLines;
end;

function TcxCustomLookAndFeelPainter.TreeListUseDiscreteScalingForGridLines: Boolean;
begin
  Result := GridUseDiscreteScalingForGridLines;
end;

function TcxCustomLookAndFeelPainter.TreeViewExpandButtonSize(AExplorerStyle: Boolean; AScaleFactor: TdxScaleFactor): TSize;
begin
  Result.cx := ScaledExpandButtonSize(AScaleFactor);
  Result.cy := Result.cx;
end;

function TcxCustomLookAndFeelPainter.SmallExpandButtonSize: Integer;
begin
  Result := ScaledSmallExpandButtonSize(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.ScaledCheckButtonAreaSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  Result := ScaledCheckButtonSize(AScaleFactor);
  dxAdjustToTouchableSize(Result, AScaleFactor);
end;

function TcxCustomLookAndFeelPainter.CheckButtonAreaSize: TSize;
begin
  Result := ScaledCheckButtonAreaSize(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.CheckBorderSize: Integer;
begin
  Result := 2;
end;

function TcxCustomLookAndFeelPainter.CheckButtonColor(AState: TcxButtonState; ACheckState: TcxCheckBoxState): TColor;
const
  Colors1: array[TcxCheckBoxState] of TColor = (clWindow, clWindow, clBtnFace);
  Colors2: array[TcxButtonState] of TColor = (clWindow, clWindow, clWindow, clBtnFace, clBtnFace);
begin
  if AState = cxbsNormal then
    Result := Colors1[ACheckState]
  else
    Result := Colors2[AState];
end;

function TcxCustomLookAndFeelPainter.ScaledCheckButtonSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  Result := AScaleFactor.Apply(FCheckButtonSize, dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.CheckButtonSize: TSize;
begin
  Result := ScaledCheckButtonSize(dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledCheck(ACanvas: TcxCustomCanvas; const R: TRect; AState: TcxButtonState;
  ACheckState: TcxCheckBoxState; AColor: TColor; AScaleFactor: TdxScaleFactor; ADrawBackground: Boolean);

  function GetCheckTemplate(ASize: TSize): TPoints;
  var
    I: Integer;
    ATemplate, AFix: TPoints;
  begin 
    SetLength(ATemplate, 3);
    SetLength(AFix, 3);
    SetLength(Result, 3);
    ATemplate[0] := Point(0, 0);
    ATemplate[1] := Point(500, 500);
    ATemplate[2] := Point(1500, -499);
    for I := Low(ATemplate) to High(ATemplate) do
    begin
      Result[I].X := MulDiv(ATemplate[I].X, ASize.cx, 1000) - (Trunc(ASize.cx * 0.15) + 1);
      Result[I].Y := MulDiv(ATemplate[I].Y, ASize.cx, 1000) + ASize.cy div 3;
    end;
  end;

  procedure DoDrawCheck;
  var
    I: Integer;
    ARect: TRect;
    APoints: TPoints;
  begin
    ARect := R;
    InflateRect(ARect, -AScaleFactor.Apply(1), -AScaleFactor.Apply(1));
    if cxIsTouchModeEnabled and (R.Width >= cxTouchCheckMarkMinSize) then
      InflateRect(ARect, -AScaleFactor.Apply(1), -AScaleFactor.Apply(1));
    ACanvas.SaveClipRegion;
    try
      ACanvas.IntersectClipRect(ARect);
      APoints := GetCheckTemplate(ARect.Size);
      for I := Low(APoints) to High(APoints) do
      begin
        APoints[I].X := APoints[I].X + ARect.Left;
        APoints[I].Y := APoints[I].Y + ARect.Top;
      end;

      for I := 0 downto -2 do
      begin
        ACanvas.Polyline(APoints, AColor);
        APoints[0] := cxPointOffset(APoints[0], 0, -1);
        APoints[1] := cxPointOffset(APoints[1], 0, -1);
        APoints[2] := cxPointOffset(APoints[2], 0, -1);
      end;
    finally
      ACanvas.RestoreClipRegion;
    end;
  end;

begin
  if ADrawBackground then
    ACanvas.FillRect(R, CheckButtonColor(AState, ACheckState));
  if ACheckState in [cbsChecked, cbsGrayed] then
    DoDrawCheck;
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledCheck(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState;
  ACheckState: TcxCheckBoxState; AColor: TColor; AScaleFactor: TdxScaleFactor);
begin
  DrawScaledCheck(ACanvas, R, AState, ACheckState, AColor, AScaleFactor, ACanvas.Brush.Style = bsSolid);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledCheck(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState;
  AChecked: Boolean; AColor: TColor; AScaleFactor: TdxScaleFactor);
begin
  DrawScaledCheck(ACanvas, R, AState, AChecked, AColor, AScaleFactor, ACanvas.Brush.Style = bsSolid);
end;

procedure TcxCustomLookAndFeelPainter.DrawCheck(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState;
  ACheckState: TcxCheckBoxState; AColor: TColor);
begin
  DrawScaledCheck(ACanvas, R, AState, ACheckState, AColor, dxSystemScaleFactor, ACanvas.Brush.Style = bsSolid);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledCheck(ACanvas: TcxCustomCanvas; const R: TRect; AState: TcxButtonState;
  AChecked: Boolean; AColor: TColor; AScaleFactor: TdxScaleFactor; ADrawBackground: Boolean);
const
  CheckStatesMap: array[Boolean] of TcxCheckBoxState = (cbsUnchecked, cbsChecked);
begin
  DrawScaledCheck(ACanvas, R, AState, CheckStatesMap[AChecked], AColor, AScaleFactor, ADrawBackground);
end;

procedure TcxCustomLookAndFeelPainter.DrawCheck(ACanvas: TcxCanvas; const R: TRect;
  AState: TcxButtonState; AChecked: Boolean; AColor: TColor);
begin
  DrawScaledCheck(ACanvas, R, AState, AChecked, AColor, dxSystemScaleFactor, ACanvas.Brush.Style = bsSolid);
end;

procedure TcxCustomLookAndFeelPainter.DrawCheckBorder(ACanvas: TcxCustomCanvas;
  R: TRect; AState: TcxButtonState);
begin
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledCheckButton(ACanvas: TcxCustomCanvas;
  R: TRect; AState: TcxButtonState; ACheckState: TcxCheckBoxState; AScaleFactor: TdxScaleFactor; ADrawBackground: Boolean);
const
  ColorMap: array[Boolean] of TColor = (clBtnText, clGrayText);
begin
  DrawCheckBorder(ACanvas, R, AState);
  InflateRect(R, -CheckBorderSize, -CheckBorderSize);
  DrawScaledCheck(ACanvas, R, AState, ACheckState,
    ColorMap[(AState = cxbsDisabled) or (ACheckState = cbsGrayed)], AScaleFactor, True);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledCheckButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState;
  AChecked: Boolean; AScaleFactor: TdxScaleFactor);
begin
  DrawScaledCheckButton(ACanvas, R, AState, AChecked, AScaleFactor, ACanvas.Brush.Style = bsSolid);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledCheckButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState;
  ACheckState: TcxCheckBoxState; AScaleFactor: TdxScaleFactor);
begin
  DrawScaledCheckButton(ACanvas, R, AState, ACheckState, AScaleFactor, ACanvas.Brush.Style = bsSolid);
end;

procedure TcxCustomLookAndFeelPainter.DrawCheckButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState;
  ACheckState: TcxCheckBoxState);
begin
  DrawScaledCheckButton(ACanvas, R, AState, ACheckState, dxSystemScaleFactor, ACanvas.Brush.Style = bsSolid);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledCheckButton(ACanvas: TcxCustomCanvas; R: TRect; AState: TcxButtonState;
  AChecked: Boolean; AScaleFactor: TdxScaleFactor; ADrawBackground: Boolean);
const
  CheckStates: array[Boolean] of TcxCheckBoxState = (cbsUnchecked, cbsChecked);
begin
  DrawScaledCheckButton(ACanvas, R, AState, CheckStates[AChecked], AScaleFactor, ADrawBackground);
end;

procedure TcxCustomLookAndFeelPainter.DrawCheckButton(ACanvas: TcxCanvas;
  R: TRect; AState: TcxButtonState; AChecked: Boolean);
begin
  DrawScaledCheckButton(ACanvas, R, AState, AChecked, dxSystemScaleFactor, ACanvas.Brush.Style = bsSolid);
end;

function TcxCustomLookAndFeelPainter.ToggleSwitchToggleColor(AChecked: Boolean): TColor;
begin
  Result := 0;
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledToggleSwitch(ACanvas: TcxCanvas;
  ABounds: TRect; AState: TcxButtonState; AThumbBounds: TRect; AScaleFactor: TdxScaleFactor);
begin
  DrawScaledToggleSwitch(ACanvas, ABounds, AState, False, AThumbBounds, AScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledToggleSwitch(
  ACanvas: TcxCanvas; ABounds: TRect; AState: TcxButtonState; AFocused: Boolean; AThumbBounds: TRect; AScaleFactor: TdxScaleFactor);

  procedure InternalDrawPart(const AExcludeRect: TRect; AChecked: Boolean);
  begin
    ACanvas.SaveState;
    try
      ACanvas.ExcludeClipRect(AExcludeRect);
      DrawScaledToggleSwitchState(ACanvas, ABounds, AState, AChecked, AFocused, AScaleFactor);
    finally
      ACanvas.RestoreState;
    end;
  end;

var
  ACenterThumb: Integer;
  AExcludeRect: TRect;
begin
  if ABounds.Left = AThumbBounds.Left then
    DrawScaledToggleSwitchState(ACanvas, ABounds, AState, ACanvas.UseRightToLeftAlignment, AFocused, AScaleFactor)
  else
    if ABounds.Right = AThumbBounds.Right then
      DrawScaledToggleSwitchState(ACanvas, ABounds, AState, not ACanvas.UseRightToLeftAlignment, AFocused, AScaleFactor)
    else
    begin
      ACenterThumb := AThumbBounds.Left + AThumbBounds.Width div 2;
      AExcludeRect := ABounds;
      AExcludeRect.Left := ACenterThumb;
      InternalDrawPart(AExcludeRect, not ACanvas.UseRightToLeftAlignment);
      AExcludeRect := ABounds;
      AExcludeRect.Right := ACenterThumb;
      InternalDrawPart(AExcludeRect,  ACanvas.UseRightToLeftAlignment);
    end;
end;

procedure TcxCustomLookAndFeelPainter.DrawToggleSwitch(
  ACanvas: TcxCanvas; ABounds: TRect; AState: TcxButtonState; AThumbBounds: TRect);
begin
  DrawScaledToggleSwitch(ACanvas, ABounds, AState, False, AThumbBounds, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawToggleSwitchState(
  ACanvas: TcxCanvas; ABounds: TRect; AState: TcxButtonState; AChecked: Boolean);
begin
  DrawScaledToggleSwitchState(ACanvas, ABounds, AState, AChecked, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledToggleSwitchState(ACanvas: TcxCanvas;
  ABounds: TRect; AState: TcxButtonState; AChecked: Boolean; AScaleFactor: TdxScaleFactor);
begin
  DrawScaledToggleSwitchState(ACanvas, ABounds, AState, AChecked, False, AScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledToggleSwitchState(ACanvas: TcxCanvas;
  ABounds: TRect; AState: TcxButtonState; AChecked, AFocused: Boolean; AScaleFactor: TdxScaleFactor);
begin
  // do nothing
end;

procedure TcxCustomLookAndFeelPainter.DrawToggleSwitchStateIndicator(
  ACanvas: TcxCanvas; ABounds: TRect; AText: string; AFont: TFont);
begin
  ACanvas.SaveState;
  try
    ACanvas.Font := AFont;
    cxDrawText(ACanvas, AText, ABounds, DT_SINGLELINE or DT_CENTER or DT_VCENTER, GetToggleSwitchTextColor);
  finally
    ACanvas.RestoreState;
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledToggleSwitchThumb(
  ACanvas: TcxCanvas; ABounds: TRect; AState: TcxButtonState; AChecked, AFocused: Boolean;
  AScaleFactor: TdxScaleFactor);
begin
  DrawScaledButton(ACanvas, cxRectInflate(ABounds, -2), AState, AScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledToggleSwitchThumb(
  ACanvas: TcxCanvas; ABounds: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
begin
  DrawScaledToggleSwitchThumb(ACanvas, ABounds, AState, False, False, AScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawToggleSwitchThumb(ACanvas: TcxCanvas; ABounds: TRect; AState: TcxButtonState);
begin
  DrawScaledToggleSwitchThumb(ACanvas, ABounds, AState, False, False, dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.GetToggleSwitchColorPalette: IdxColorPalette;
begin
  Result := nil;
end;

function TcxCustomLookAndFeelPainter.GetToggleSwitchTextColor: TColor;
begin
  Result := DefaultContentTextColor;
end;

function TcxCustomLookAndFeelPainter.GetToggleSwitchThumbPercentsWidth: Integer;
begin
  Result := 50;
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledRadioButton(ACanvas: TcxCanvas; X, Y: Integer; AButtonState: TcxButtonState;
  AChecked, AFocused: Boolean; ABrushColor: TColor; AScaleFactor: TdxScaleFactor; AIsDesigning: Boolean = False);
begin
  TcxRadioButtonImageListManager.Get(AScaleFactor).Draw(
    ACanvas, X, Y, ABrushColor, cxLookAndFeelKindMap[LookAndFeelStyle], AButtonState, AChecked, AFocused, AIsDesigning);
end;

procedure TcxCustomLookAndFeelPainter.DrawRadioButton(ACanvas: TcxCanvas;
  X, Y: Integer; AButtonState: TcxButtonState; AChecked, AFocused: Boolean;
  ABrushColor: TColor; AIsDesigning: Boolean = False);
begin
  DrawScaledRadioButton(ACanvas, X, Y, AButtonState, AChecked, AFocused, ABrushColor, dxSystemScaleFactor, AIsDesigning);
end;

function TcxCustomLookAndFeelPainter.RadioButtonBodyColor(AState: TcxButtonState): TColor;
begin
  case AState of
    cxbsDisabled, cxbsPressed:
      Result := clBtnFace;
    else
      Result := clWindow;
  end;
end;

function TcxCustomLookAndFeelPainter.ScaledRadioButtonSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  Result := TcxRadioButtonImageListManager.Get(AScaleFactor).GetSize;
end;

function TcxCustomLookAndFeelPainter.RadioButtonSize: TSize;
begin
  Result := ScaledRadioButtonSize(dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawLabelLine(ACanvas: TcxCanvas;
  const R: TRect; AOuterColor, AInnerColor: TColor; AIsVertical: Boolean);
const
  BordersMap: array[Boolean] of TcxBorders = ([bTop, bBottom], [bLeft, bRight]);
begin
  AOuterColor := cxGetActualColor(AOuterColor, clBtnShadow);
  AInnerColor := cxGetActualColor(AInnerColor, clBtnHighlight);
  ACanvas.DrawComplexFrame(R, AOuterColor, AInnerColor, BordersMap[AIsVertical]);
end;

function TcxCustomLookAndFeelPainter.LabelLineHeight: Integer;
begin
  Result := 2;
end;

function TcxCustomLookAndFeelPainter.GaugeControlBackgroundColor: TColor;
begin
  Result := clWindow;
end;

procedure TcxCustomLookAndFeelPainter.DrawGaugeControlBackground(ACanvas: TcxCanvas; const ARect: TRect;
  ATransparent: Boolean; ABackgroundColor: TColor);
begin
  DrawBackground(ACanvas, ARect, ATransparent, ABackgroundColor, nil);
end;

function TcxCustomLookAndFeelPainter.MapControlBackgroundColor: TColor;
begin
  Result := $958B5F;
end;

function TcxCustomLookAndFeelPainter.MapControlPanelBackColor: TdxAlphaColor;
begin
  Result := $C8000000;
end;

function TcxCustomLookAndFeelPainter.MapControlPanelHotTrackedTextColor: TdxAlphaColor;
begin
  Result := $FFFFFFFF;
end;

function TcxCustomLookAndFeelPainter.MapControlPanelPressedTextColor: TdxAlphaColor;
begin
  Result := $FF7E8383;
end;

function TcxCustomLookAndFeelPainter.MapControlPanelTextColor: TdxAlphaColor;
begin
  Result := $FFADDFFF;
end;

function TcxCustomLookAndFeelPainter.MapControlGetMapPushpinSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  Result := AScaleFactor.Apply(MapPushpin.Size);
end;

function TcxCustomLookAndFeelPainter.MapControlGetMapPushpinTextOrigin(AScaleFactor: TdxScaleFactor): TPoint;
begin
  Result := AScaleFactor.Apply(Point(17, 17));
end;

function TcxCustomLookAndFeelPainter.MapControlMapCustomElementSelectionOffset(AScaleFactor: TdxScaleFactor): TRect;
begin
  Result.Init(AScaleFactor.Apply(14));
end;

function TcxCustomLookAndFeelPainter.MapControlMapCustomElementTextColor: TdxAlphaColor;
begin
  Result := $FF000000;
end;

function TcxCustomLookAndFeelPainter.MapControlMapCustomElementTextGlowColor: TdxAlphaColor;
begin
  Result := $FFFFFFFF;
end;

function TcxCustomLookAndFeelPainter.MapControlMapPushpinTextColor: TdxAlphaColor;
begin
  Result := $FF000000;
end;

function TcxCustomLookAndFeelPainter.MapControlMapPushpinTextGlowColor: TdxAlphaColor;
begin
  Result := $FFFFFFFF;
end;

function TcxCustomLookAndFeelPainter.MapControlShapeColor: TdxAlphaColor;
begin
  Result := $FFD7D7D7;
end;

function TcxCustomLookAndFeelPainter.MapControlSelectedRegionBackgroundColor: TdxAlphaColor;
begin
  Result := $800072AE;
end;

function TcxCustomLookAndFeelPainter.MapControlSelectedRegionBorderColor: TdxAlphaColor;
begin
  Result := $FF3399FF;
end;

function TcxCustomLookAndFeelPainter.MapControlShapeBorderColor: TdxAlphaColor;
begin
  Result := $FFFFFFFF;
end;

function TcxCustomLookAndFeelPainter.MapControlShapeBorderWidth(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := AScaleFactor.Apply(1);
end;

function TcxCustomLookAndFeelPainter.MapControlShapeHighlightedColor: TdxAlphaColor;
begin
  Result := $FFD7D7D7;
end;

function TcxCustomLookAndFeelPainter.MapControlShapeBorderHighlightedColor: TdxAlphaColor;
begin
  Result := $FFFFFFFF;
end;

function TcxCustomLookAndFeelPainter.MapControlShapeBorderHighlightedWidth(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := AScaleFactor.Apply(1);
end;

function TcxCustomLookAndFeelPainter.MapControlShapeSelectedColor: TdxAlphaColor;
begin
  Result := $FFD7D7D7;
end;

function TcxCustomLookAndFeelPainter.MapControlShapeBorderSelectedColor: TdxAlphaColor;
begin
  Result := $FFFFFFFF;
end;

function TcxCustomLookAndFeelPainter.MapControlShapeBorderSelectedWidth(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := AScaleFactor.Apply(1);
end;

procedure TcxCustomLookAndFeelPainter.DrawMapCustomElementBackground(ACanvas: TcxCanvas;
  const ARect: TRect; AState: TdxMapControlElementState);

  function GetBorderColor: TdxAlphaColor;
  begin
    case AState of
      mcesHot, mcesPressed:
        Result := $5A000000;
      mcesSelected:
        Result := $80000000
    else // mcesNormal
      Result := 0
    end;
  end;

  function GetBackgroundColor: TdxAlphaColor;
  begin
    case AState of
      mcesHot, mcesPressed:
        Result := $5AFFFFFF;
      mcesSelected:
        Result := $80FFFFFF
    else // mcesNormal
      Result := 0
    end;
  end;

  function GetBorderWidth: Integer;
  begin
    Result := 1;
  end;

var
  AGpGraphics: TdxGPGraphics;
begin
  AGpGraphics := dxGpBeginPaint(ACanvas.Handle, ARect);
  try
    AGpGraphics.SmoothingMode := smAntiAlias;
    AGpGraphics.RoundRect(cxRectInflate(ARect, -GetBorderWidth, -GetBorderWidth), GetBorderColor, GetBackgroundColor, 4, 4, GetBorderWidth);
  finally
    dxGpEndPaint(AGpGraphics);
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawMapPushpin(ACanvas: TcxCanvas; const ARect: TRect;
  AState: TdxMapControlElementState; AScaleFactor: TdxScaleFactor);
begin
  MapPushpin.StretchDraw(ACanvas.Handle, ARect);
end;

procedure TcxCustomLookAndFeelPainter.OfficeNavigationBarDrawCustomizationButton(
  ACanvas: TcxCanvas; const ARect: TRect; AState: TcxCalendarElementState; AColor: TdxAlphaColor);
begin
  OfficeNavigationBarDrawScaledCustomizationButton(ACanvas, ARect, AState, dxSystemScaleFactor, AColor);
end;

procedure TcxCustomLookAndFeelPainter.OfficeNavigationBarDrawBackground(ACanvas: TcxCanvas; const ARect: TRect);
begin
  ACanvas.FillRect(ARect, $E4E4E4);
end;

procedure TcxCustomLookAndFeelPainter.OfficeNavigationBarDrawImageSelection(
  ACanvas: TcxCanvas; const ARect: TRect; AState: TcxCalendarElementState);
begin
  OfficeNavigationBarDrawScaledImageSelection(ACanvas, ARect, AState, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.OfficeNavigationBarButtonItemDrawBackground(
  ACanvas: TcxCanvas; const ARect: TRect; AState: TcxCalendarElementState);
begin
  OfficeNavigationBarDrawScaledButtonItemBackground(ACanvas, ARect, AState, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.OfficeNavigationBarDrawScaledButtonItemBackground(
  ACanvas: TcxCanvas; const ARect: TRect; AState: TcxCalendarElementState; AScaleFactor: TdxScaleFactor);
begin
  if AState = cesHot then
    DrawScaledButton(ACanvas, ARect, cxbsHot, AScaleFactor)
  else
    DrawScaledButton(ACanvas, ARect, cxbsNormal, AScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.OfficeNavigationBarItemDrawBackground(
  ACanvas: TcxCanvas; const ARect: TRect; AState: TcxCalendarElementState);
begin
  OfficeNavigationBarDrawScaledItemBackground(ACanvas, ARect, AState, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.OfficeNavigationBarDrawScaledCustomizationButton(ACanvas: TcxCanvas;
  const ARect: TRect; AState: TcxCalendarElementState; AScaleFactor: TdxScaleFactor; AColor: TdxAlphaColor = dxacDefault);
var
  AImage: TdxGPImage;
begin
  if AColor <> dxacDefault then
  begin
    AImage := NavigationBarCustomizationButton.Clone;
    try
      AImage.ChangeColor(dxAlphaColorToColor(AColor));
      AImage.StretchDraw(ACanvas.Handle, ARect, dxGetAlpha(AColor));
    finally
      AImage.Free;
    end;
  end
  else
    NavigationBarCustomizationButton.StretchDraw(ACanvas.Handle, ARect);
end;

procedure TcxCustomLookAndFeelPainter.OfficeNavigationBarDrawScaledItemBackground(
  ACanvas: TcxCanvas; const ARect: TRect; AState: TcxCalendarElementState; AScaleFactor: TdxScaleFactor);
begin
  // do nothing
end;

procedure TcxCustomLookAndFeelPainter.OfficeNavigationBarDrawScaledImageSelection(
  ACanvas: TcxCanvas; const ARect: TRect; AState: TcxCalendarElementState; AScaleFactor: TdxScaleFactor);
begin
  case AState of
    cesPressed:
      ACanvas.FillRect(ARect, $E0C092);
    cesHot, cesSelected:
      ACanvas.FillRect(ARect, $F7E6CD);
  end;
end;

function TcxCustomLookAndFeelPainter.OfficeNavigationBarContentOffsets: TRect;
begin
  Result := OfficeNavigationBarScaledContentOffsets(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.OfficeNavigationBarCustomizationButtonSize: TSize;
begin
  Result := OfficeNavigationBarScaledCustomizationButtonSize(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.OfficeNavigationBarButtonItemContentOffsets: TRect;
begin
  Result := OfficeNavigationBarScaledButtonItemContentOffsets(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.OfficeNavigationBarButtonItemFontSize: Integer;
begin
  Result := OfficeNavigationBarScaledButtonItemFontSize(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.OfficeNavigationBarButtonItemTextColor(AState: TcxCalendarElementState): TColor;
begin
  case AState of
    cesNormal:
      Result := $565656;
    cesHot:
      Result := $C67200;
    cesPressed:
      Result := $C67200;
    cesSelected:
      Result := $C67200;
  else
    Result := $565656;
  end;
end;

function TcxCustomLookAndFeelPainter.OfficeNavigationBarItemContentOffsets: TRect;
begin
  Result := OfficeNavigationBarScaledItemContentOffsets(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.OfficeNavigationBarItemTextColor(AState: TcxCalendarElementState): TColor;
begin
  case AState of
    cesNormal:
      Result := $565656;
    cesHot:
      Result := $C67200;
    cesPressed:
      Result := $C67200;
    cesSelected:
      Result := $C67200;
  else
    Result := $565656;
  end;
end;

function TcxCustomLookAndFeelPainter.OfficeNavigationBarItemFontSize: Integer;
begin
  Result := OfficeNavigationBarScaledItemFontSize(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.OfficeNavigationBarScaledButtonItemContentOffsets(AScaleFactor: TdxScaleFactor): TRect;
begin
  Result.Init(AScaleFactor.Apply(4));
end;

function TcxCustomLookAndFeelPainter.OfficeNavigationBarScaledButtonItemFontSize(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := AScaleFactor.Apply(9);
end;

function TcxCustomLookAndFeelPainter.OfficeNavigationBarScaledContentOffsets(AScaleFactor: TdxScaleFactor): TRect;
begin
  Result.Init(AScaleFactor.Apply(2));
end;

function TcxCustomLookAndFeelPainter.OfficeNavigationBarScaledCustomizationButtonSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  Result := AScaleFactor.Apply(NavigationBarCustomizationButton.Size);
end;

function TcxCustomLookAndFeelPainter.OfficeNavigationBarScaledItemContentOffsets(AScaleFactor: TdxScaleFactor): TRect;
begin
  Result.Init(AScaleFactor.Apply(2));
end;

function TcxCustomLookAndFeelPainter.OfficeNavigationBarScaledItemFontSize(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := AScaleFactor.Apply(19);
end;

function TcxCustomLookAndFeelPainter.PDFViewerNavigationPaneButtonColorPalette(AState: TcxButtonState): IdxColorPalette;
begin
  Result := nil;
end;

function TcxCustomLookAndFeelPainter.PDFViewerNavigationPaneButtonContentOffsets(AScaleFactor: TdxScaleFactor): TRect;
begin
  Result.Init(AScaleFactor.Apply(2));
end;

function TcxCustomLookAndFeelPainter.PDFViewerNavigationPaneButtonOverlay(AScaleFactor: TdxScaleFactor): TPoint;
begin
  Result.X := PDFViewerNavigationPaneContentOffsets(AScaleFactor).Left;
  Result.Y := PDFViewerNavigationPaneContentOffsets(AScaleFactor).Top + BorderSize;
end;

function TcxCustomLookAndFeelPainter.PDFViewerNavigationPaneButtonRect(const ARect: TRect; AState: TcxButtonState;
  ASelected: Boolean; AScaleFactor: TdxScaleFactor): TRect;
var
  ADelta: TPoint;
begin
  Result := ARect;
  if ASelected or (AState = cxbsPressed) then
  begin
    ADelta := PDFViewerNavigationPaneButtonOverlay(AScaleFactor);
    Result := cxRectInflate(Result, ADelta.X, ADelta.Y);
  end;
end;

function TcxCustomLookAndFeelPainter.PDFViewerNavigationPaneButtonSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  Result.Init(AScaleFactor.Apply(42));
end;

function TcxCustomLookAndFeelPainter.PDFViewerNavigationPaneContentOffsets(AScaleFactor: TdxScaleFactor): TRect;
begin
  Result.Init(AScaleFactor.Apply(4));
end;

function TcxCustomLookAndFeelPainter.PDFViewerNavigationPanePageCaptionContentOffsets(AScaleFactor: TdxScaleFactor): TRect;
begin
  Result := PDFViewerNavigationPanePageContentOffsets(AScaleFactor);
end;

function TcxCustomLookAndFeelPainter.PDFViewerNavigationPanePageCaptionTextColor: TColor;
begin
  Result := DefaultContentTextColor;
end;

function TcxCustomLookAndFeelPainter.PDFViewerNavigationPanePageContentOffsets(AScaleFactor: TdxScaleFactor): TRect;
begin
  Result := PDFViewerNavigationPaneContentOffsets(AScaleFactor);
end;

function TcxCustomLookAndFeelPainter.PDFViewerNavigationPanePageToolbarContentOffsets(AScaleFactor: TdxScaleFactor): TRect;
begin
  Result := PDFViewerNavigationPaneContentOffsets(AScaleFactor);
end;

function TcxCustomLookAndFeelPainter.PDFViewerSelectionColor: TColor;
begin
  Result := DefaultSelectionColor;
end;

procedure TcxCustomLookAndFeelPainter.PDFViewerDrawNavigationPaneBackground(ACanvas: TcxCanvas; const ARect: TRect;
  AScaleFactor: TdxScaleFactor);
begin
  PDFViewerDrawFindPanelBackground(ACanvas, ARect, [bRight]);
end;

procedure TcxCustomLookAndFeelPainter.PDFViewerDrawNavigationPaneButton(ACanvas: TcxCanvas; const ARect: TRect;
  AState: TcxButtonState; AScaleFactor: TdxScaleFactor; AMinimized, ASelected, AIsFirst: Boolean);
var
  AButtonRect: TRect;
begin
  AButtonRect := PDFViewerNavigationPaneButtonRect(ARect, cxbsPressed, ASelected, AScaleFactor);

  if AMinimized or not ASelected then
  begin
    PDFViewerDrawFindPanelBackground(ACanvas, AButtonRect, [bRight]);
    InflateRect(AButtonRect, -ButtonBorderSize, -ButtonBorderSize);
    ACanvas.Brush.Color := ButtonColor(AState);
    ACanvas.FillRect(AButtonRect);
  end
  else
  begin
    DrawBorder(ACanvas, AButtonRect);
    ACanvas.FillRect(cxRectContent(AButtonRect, TRect.Create(0, BorderSize, 0, BorderSize)), DefaultControlColor);
  end;
end;

procedure TcxCustomLookAndFeelPainter.PDFViewerDrawNavigationPanePageBackground(ACanvas: TcxCanvas; const ARect: TRect);
begin
  PDFViewerDrawFindPanelBackground(ACanvas, ARect, [bRight]);
end;

procedure TcxCustomLookAndFeelPainter.PDFViewerDrawNavigationPanePageButton(ACanvas: TcxCanvas; const ARect: TRect;
  AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
begin
  if AState in [cxbsHot, cxbsPressed] then
    ACanvas.FillRect(ARect, clBtnShadow);
end;

procedure TcxCustomLookAndFeelPainter.PDFViewerDrawNavigationPanePageCaptionBackground(ACanvas: TcxCanvas;
  const ARect: TRect);
begin
  PDFViewerDrawFindPanelBackground(ACanvas, ARect, [bRight]);
end;

procedure TcxCustomLookAndFeelPainter.PDFViewerDrawNavigationPanePageToolbarBackground(ACanvas: TcxCanvas;
  const ARect: TRect);
begin
  PDFViewerDrawFindPanelBackground(ACanvas, ARect, []);
end;

procedure TcxCustomLookAndFeelPainter.PDFViewerDrawFindPanelBackground(ACanvas: TcxCanvas; const R: TRect;
  ABorders: TcxBorders);
var
  ARect: TRect;
begin
  DrawBorder(ACanvas, R);
  ARect := R;
  if bLeft in ABorders then
    Inc(ARect.Left, BorderSize);
  if bBottom in ABorders then
    Dec(ARect.Bottom, BorderSize);
  if bTop in ABorders then
    Inc(ARect.Top, BorderSize);
  if bRight in ABorders then
    Dec(ARect.Right, BorderSize);
  ACanvas.FillRect(ARect, DefaultControlColor);
end;

procedure TcxCustomLookAndFeelPainter.PDFViewerDrawPageThumbnailPreviewBackground(ACanvas: TcxCanvas; const ARect: TRect);
begin
  DrawPrintPreviewBackground(ACanvas, ARect);
end;

procedure TcxCustomLookAndFeelPainter.DrawSpreadSheetScaledGroupExpandButton(
  ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
begin
  DrawScaledButton(ACanvas, R, AState, AScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawSpreadSheetGroupExpandButton(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState);
begin
  DrawSpreadSheetScaledGroupExpandButton(ACanvas, R, AState, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawSpreadSheetGroupExpandButtonGlyph(ACanvas: TcxCanvas;
  const R: TRect; AState: TcxButtonState; AExpanded: Boolean; ADefaultGlyphs: TCustomImageList = nil);
begin
  DrawSpreadSheetScaledGroupExpandButtonGlyph(ACanvas, R, AState, AExpanded, dxSystemScaleFactor, ADefaultGlyphs);
end;

procedure TcxCustomLookAndFeelPainter.DrawSpreadSheetScaledGroupExpandButtonGlyph(ACanvas: TcxCanvas; const R: TRect;
  AState: TcxButtonState; AExpanded: Boolean; AScaleFactor: TdxScaleFactor; ADefaultGlyphs: TCustomImageList = nil);
begin
  DrawNavigatorScaledButtonGlyph(ACanvas, ADefaultGlyphs, IfThen(AExpanded, 8, 6),
    cxRectCenter(R, NavigatorScaledButtonGlyphSize(AScaleFactor)), True, False, AScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawSpreadSheetScaledHeader(ACanvas: TcxCustomCanvas; const R: TRect;
  ANeighbors: TcxNeighbors; ABorders: TcxBorders; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
var
  AColor: TColor;
begin
  DrawHeaderBorder(ACanvas, R, ANeighbors, ABorders);

  case AState of
    cxbsHot:
      AColor := dxGetMiddleRGB(clBtnHighlight, clHighlight, 85);
    cxbsPressed:
      AColor := dxGetMiddleRGB(clBtnFace, clHighlight, 70);
  else
    AColor := DefaultHeaderColor;
  end;

  ACanvas.FillRect(HeaderContentBounds(R, ABorders), AColor);
end;

function TcxCustomLookAndFeelPainter.SpreadSheetContentColor: TColor;
begin
  Result := clWindow;
end;

function TcxCustomLookAndFeelPainter.SpreadSheetContentTextColor: TColor;
begin
  Result := clWindowText;
end;

function TcxCustomLookAndFeelPainter.SpreadSheetFrozenPaneSeparatorColor: TColor;
begin
  Result := clBlack;
end;

function TcxCustomLookAndFeelPainter.SpreadSheetScaledGroupExpandButtonContentOffsets(AScaleFactor: TdxScaleFactor): TRect;
begin
  Result.Init(AScaleFactor.Apply(3));
end;

function TcxCustomLookAndFeelPainter.SpreadSheetGroupExpandButtonContentOffsets: TRect;
begin
  Result := SpreadSheetScaledGroupExpandButtonContentOffsets(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.SpreadSheetScaledGroupExpandButtonGlyphSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  Result := NavigatorScaledButtonGlyphSize(AScaleFactor);
end;

function TcxCustomLookAndFeelPainter.SpreadSheetGroupExpandButtonGlyphSize: TSize;
begin
  Result := SpreadSheetScaledGroupExpandButtonGlyphSize(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.SpreadSheetGroupExpandButtonTextColor(AState: TcxButtonState): TColor;
begin
  Result := ButtonSymbolColor(AState);
end;

function TcxCustomLookAndFeelPainter.SpreadSheetScaledGroupLevelMarkSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  Result.Init(AScaleFactor.Apply(2));
end;

function TcxCustomLookAndFeelPainter.SpreadSheetGroupLevelMarkSize: TSize;
begin
  Result := SpreadSheetScaledGroupLevelMarkSize(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.SpreadSheetGroupLineColor: TColor;
begin
  Result := clGray;
end;

function TcxCustomLookAndFeelPainter.SpreadSheetSelectionColor: TColor;
begin
  Result := DefaultSelectionColor;
end;

procedure TcxCustomLookAndFeelPainter.DrawSpreadSheetFormulaBarScaledSeparator(
  ACanvas: TcxCanvas; const R: TRect; AScaleFactor: TdxScaleFactor);
begin
  DrawScaledSplitter(ACanvas, R, False, False, False, AScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawSpreadSheetFormulaBarScaledExpandButton(
  ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AExpanded: Boolean; AScaleFactor: TdxScaleFactor);
const
  StateMap: array[Boolean] of TcxScrollBarPart = (sbpLineDown, sbpLineUp);
begin
  DrawScrollBarPart(ACanvas, False, R, StateMap[AExpanded], AState);
end;

function TcxCustomLookAndFeelPainter.SpreadSheetFormulaBarGetScaledSeparatorSize(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := GetScaledSplitterSize(False, AScaleFactor).cx;
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledHeader(ACanvas: TcxCustomCanvas; const ABounds: TRect;
  AState: TcxButtonState; ANeighbors: TcxNeighbors; ABorders: TcxBorders; AScaleFactor: TdxScaleFactor;
  AIsLast, AIsGroup: Boolean);
begin
  DrawHeaderBorder(ACanvas, ABounds, ANeighbors, ABorders);
  DrawContentBackground(ACanvas, HeaderContentBounds(ABounds, ABorders), AState, DefaultHeaderColor, False);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledHeader(ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect;
  ANeighbors: TcxNeighbors; ABorders: TcxBorders; AState: TcxButtonState; AAlignmentHorz: TAlignment;
  AAlignmentVert: TcxAlignmentVert; AMultiLine, AShowEndEllipsis: Boolean; const AText: string; AFont: TFont;
  ATextColor, ABkColor: TColor; AScaleFactor: TdxScaleFactor; AOnDrawBackground: TcxDrawBackgroundEvent = nil;
  AIsLast: Boolean = False; AIsGroup: Boolean = False; ABorderWidth: Integer = 1);
begin
  DrawHeaderBorder(ACanvas, ABounds, ANeighbors, ABorders);
  DrawContent(ACanvas, ScaledHeaderContentBounds(ABounds, ABorders, AScaleFactor), ATextAreaBounds, AState,
    AAlignmentHorz, AAlignmentVert, AMultiLine, AShowEndEllipsis, AText,
    AFont, ATextColor, ABkColor, AOnDrawBackground);
end;

procedure TcxCustomLookAndFeelPainter.DrawHeader(ACanvas: TcxCanvas;
  const ABounds, ATextAreaBounds: TRect; ANeighbors: TcxNeighbors; ABorders: TcxBorders;
  AState: TcxButtonState; AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert;
  AMultiLine, AShowEndEllipsis: Boolean; const AText: string; AFont: TFont;
  ATextColor, ABkColor: TColor; AOnDrawBackground: TcxDrawBackgroundEvent = nil;
  AIsLast: Boolean = False; AIsGroup: Boolean = False);
begin
  DrawScaledHeader(ACanvas, ABounds, ATextAreaBounds, ANeighbors, ABorders, AState, AAlignmentHorz, AAlignmentVert,
    AMultiLine, AShowEndEllipsis, AText, AFont, ATextColor, ABkColor, dxDefaultScaleFactor, AOnDrawBackground, AIsLast, AIsGroup);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledHeaderEx(ACanvas: TcxCanvas;
  const ABounds, ATextAreaBounds: TRect; ANeighbors: TcxNeighbors; ABorders: TcxBorders; AState: TcxButtonState;
  AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert; AMultiLine, AShowEndEllipsis: Boolean; const AText: string;
  AFont: TFont; ATextColor, ABkColor: TColor; AScaleFactor: TdxScaleFactor; AOnDrawBackground: TcxDrawBackgroundEvent = nil);
begin
  DrawScaledHeader(ACanvas, ABounds, ATextAreaBounds, ANeighbors, ABorders, AState, AAlignmentHorz,
    AAlignmentVert, AMultiLine, AShowEndEllipsis, AText, AFont, ATextColor, ABkColor, AScaleFactor,
    AOnDrawBackground);
end;

procedure TcxCustomLookAndFeelPainter.DrawHeaderEx(ACanvas: TcxCanvas;
  const ABounds, ATextAreaBounds: TRect; ANeighbors: TcxNeighbors; ABorders: TcxBorders;
  AState: TcxButtonState; AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert;
  AMultiLine, AShowEndEllipsis: Boolean; const AText: string; AFont: TFont;
  ATextColor, ABkColor: TColor; AOnDrawBackground: TcxDrawBackgroundEvent = nil);
begin
  DrawScaledHeaderEx(ACanvas, ABounds, ATextAreaBounds, ANeighbors, ABorders, AState, AAlignmentHorz,
    AAlignmentVert, AMultiLine, AShowEndEllipsis, AText, AFont, ATextColor, ABkColor, dxDefaultScaleFactor,
    AOnDrawBackground);
end;

procedure TcxCustomLookAndFeelPainter.DrawHeaderBorder(
  ACanvas: TcxCustomCanvas; const R: TRect; ANeighbors: TcxNeighbors; ABorders: TcxBorders);
var
  ANeighbor: TcxNeighbor;
begin
  ACanvas.DrawEdge(R, False, False);
  for ANeighbor := Low(ANeighbor) to High(ANeighbor) do
  begin
    if ANeighbor in ANeighbors then
      case ANeighbor of
        nLeft:
          begin
            ACanvas.FillPixel(R.Left, R.Top + 1, clBtnFace);
            ACanvas.FillPixel(R.Left, R.Bottom - 2, clBtnFace);
          end;

        nRight:
          begin
            ACanvas.FillPixel(R.Right - 1, R.Top, clBtnHighlight);
            ACanvas.FillPixel(R.Right - 1, R.Top + 1, clBtnFace);
            ACanvas.FillPixel(R.Right - 1, R.Bottom - 2, clBtnFace);
          end;
      end;
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawHeaderPressed(ACanvas: TcxCanvas; const ABounds: TRect);
begin
  ACanvas.InvertRect(ABounds);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledHeaderControlSection(ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect;
  ANeighbors: TcxNeighbors; ABorders: TcxBorders; AState: TcxButtonState; AAlignmentHorz: TAlignment;
  AAlignmentVert: TcxAlignmentVert; AMultiLine, AShowEndEllipsis: Boolean; const AText: string; AFont: TFont;
  ATextColor, ABkColor: TColor; AScaleFactor: TdxScaleFactor);
var
  AHeaderControlSectionContentBounds: TRect;
begin
  DrawHeaderControlSectionBorder(ACanvas, ABounds, ABorders, AState);
  if not TdxVisualRefinements.LightBorders then
    AHeaderControlSectionContentBounds := HeaderControlSectionContentBounds(ABounds, AState)
  else
  begin
    AHeaderControlSectionContentBounds := ABounds;
    if bLeft in ABorders then
      Inc(AHeaderControlSectionContentBounds.Left);
    if bTop in ABorders then
      Inc(AHeaderControlSectionContentBounds.Top);
    if bRight in ABorders then
      Dec(AHeaderControlSectionContentBounds.Right);
    if bBottom in ABorders then
      Dec(AHeaderControlSectionContentBounds.Bottom);
  end;
  DrawHeaderControlSectionContent(ACanvas,
    AHeaderControlSectionContentBounds, ATextAreaBounds, AState,
    AAlignmentHorz, AAlignmentVert, AMultiLine, AShowEndEllipsis, AText,
    AFont, ATextColor, ABkColor);
end;

procedure TcxCustomLookAndFeelPainter.DrawHeaderControlSection(ACanvas: TcxCanvas;
  const ABounds, ATextAreaBounds: TRect; ANeighbors: TcxNeighbors; ABorders: TcxBorders; AState: TcxButtonState;
  AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert; AMultiLine, AShowEndEllipsis: Boolean;
  const AText: string; AFont: TFont; ATextColor, ABkColor: TColor);
begin
  DrawScaledHeaderControlSection(ACanvas, ABounds, ATextAreaBounds, ANeighbors, ABorders, AState, AAlignmentHorz,
    AAlignmentVert, AMultiLine, AShowEndEllipsis, AText, AFont, ATextColor, ABkColor, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawHeaderControlSectionBorder(
  ACanvas: TcxCanvas; const R: TRect; ABorders: TcxBorders; AState: TcxButtonState);
begin
end;

procedure TcxCustomLookAndFeelPainter.DrawHeaderControlSectionContent(
  ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect;
  AState: TcxButtonState; AAlignmentHorz: TAlignment;
  AAlignmentVert: TcxAlignmentVert; AMultiLine, AShowEndEllipsis: Boolean;
  const AText: string; AFont: TFont; ATextColor, ABkColor: TColor);
begin
  ACanvas.SetBrushColor(ABkColor);
  ACanvas.FillRect(ABounds);
  DrawHeaderControlSectionText(ACanvas,
    HeaderControlSectionTextAreaBounds(ATextAreaBounds, AState), AState, AAlignmentHorz,
    AAlignmentVert, AMultiLine, AShowEndEllipsis, AText, AFont, ATextColor);
end;

procedure TcxCustomLookAndFeelPainter.DrawHeaderControlSectionText(
  ACanvas: TcxCanvas; const ATextAreaBounds: TRect; AState: TcxButtonState;
  AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert; AMultiLine,
  AShowEndEllipsis: Boolean; const AText: string; AFont: TFont; ATextColor: TColor);

  procedure DoDrawText(ATextRect: TRect; ATextColor: TColor);
  const
    MultiLines: array[Boolean] of Integer = (cxSingleLine, cxWordBreak);
    ShowEndEllipses: array[Boolean] of Integer = (0, cxShowEndEllipsis);
  begin
    if AText <> '' then
    begin
      ACanvas.Font := AFont;
      ACanvas.Font.Color := ATextColor;
      ACanvas.DrawText(AText, ATextRect, cxAlignmentsHorz[AAlignmentHorz] or
        cxAlignmentsVert[AAlignmentVert] or MultiLines[AMultiLine] or
        ShowEndEllipses[AShowEndEllipsis]);
    end;
  end;
var
  R: TRect;
  AColor: TColor;
begin
  R := ATextAreaBounds;
  ACanvas.Brush.Style := bsClear;
  AColor := ATextColor;
  if AState = cxbsDisabled then
  begin
    OffsetRect(R, 1, 1);
    DoDrawText(R, clBtnHighlight);
    OffsetRect(R, -1, -1);
    AColor := clBtnShadow;
  end;
  DoDrawText(R, AColor);
  ACanvas.Brush.Style := bsSolid;
end;

procedure TcxCustomLookAndFeelPainter.DrawHeaderSeparator(ACanvas: TcxCanvas;
  const ABounds: TRect; AIndentSize: Integer; AColor: TColor; AViewParams: TcxViewParams);
begin
  ACanvas.FillRect(cxRectSetWidth(ABounds, AIndentSize), AViewParams);
  ACanvas.Brush.Color := AColor;
  ACanvas.FillRect(cxRectInflate(ABounds, -AIndentSize, 0));
  ACanvas.FillRect(cxRectSetLeft(ABounds, ABounds.Right - AIndentSize), AViewParams);
end;

procedure TcxCustomLookAndFeelPainter.DrawSortingMark(ACanvas: TcxCanvas; const R: TRect; AAscendingSorting: Boolean);
begin
  DrawScaledSortingMark(ACanvas, R, AAscendingSorting, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawSummarySortingMark(
  ACanvas: TcxCanvas; const R: TRect; AAscendingSorting: Boolean);
begin
end;

procedure TcxCustomLookAndFeelPainter.DrawSummaryValueSortingMark(
  ACanvas: TcxCanvas; const R: TRect; AAscendingSorting: Boolean);
begin
  DrawScaledSummaryValueSortingMark(ACanvas, R, AAscendingSorting, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledSummaryValueSortingMark(
  ACanvas: TcxCanvas; const R: TRect; AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor);
begin
  TdxImageDrawer.DrawImage(ACanvas, R, nil, cxIndicatorImages, Integer(High(TcxIndicatorKind)), ifmNormal, idmNormal, False, nil, AScaleFactor);
end;

function TcxCustomLookAndFeelPainter.HeaderBorders(ANeighbors: TcxNeighbors): TcxBorders;
begin
  Result := cxBordersAll;
end;

function TcxCustomLookAndFeelPainter.HeaderBorderSize: Integer;
begin
  Result := 0;
end;

function TcxCustomLookAndFeelPainter.HeaderBounds(const ABounds: TRect;
  ANeighbors: TcxNeighbors; ABorders: TcxBorders = cxBordersAll): TRect;
begin
  Result := ABounds;
  ABorders := ABorders - HeaderBorders(ANeighbors);
  if bLeft in ABorders then
    Dec(Result.Left, HeaderBorderSize);
  if bTop in ABorders then
    Dec(Result.Top, HeaderBorderSize);
  if bRight in ABorders then
    Inc(Result.Right, HeaderBorderSize);
  if bBottom in ABorders then
    Inc(Result.Bottom, HeaderBorderSize);
end;

function TcxCustomLookAndFeelPainter.HeaderContentBounds(const ABounds: TRect; ABorders: TcxBorders): TRect;
begin
  Result := ScaledHeaderContentBounds(ABounds, ABorders, dxDefaultScaleFactor);
end;

function TcxCustomLookAndFeelPainter.HeaderContentOffsets(AScaleFactor: TdxScaleFactor): TRect;
begin
  Result.Init(cxHeaderTextOffset, cxHeaderTextOffset, cxHeaderTextOffset, cxHeaderTextOffset);
  Result := AScaleFactor.Apply(Result);
  TdxVisualRefinements.HeaderPadding.InflatePadding(Result, AScaleFactor);
end;

function TcxCustomLookAndFeelPainter.ScaledHeaderContentBounds(const ABounds: TRect; ABorders: TcxBorders; AScaleFactor: TdxScaleFactor): TRect;
begin
  Result := ABounds;
  if bLeft in ABorders then
    Inc(Result.Left, HeaderBorderSize);
  if bTop in ABorders then
    Inc(Result.Top, HeaderBorderSize);
  if bRight in ABorders then
    Dec(Result.Right, HeaderBorderSize);
  if bBottom in ABorders then
    Dec(Result.Bottom, HeaderBorderSize);
end;

function TcxCustomLookAndFeelPainter.HeaderDrawCellsFirst: Boolean;
begin
  Result := True;
end;

function TcxCustomLookAndFeelPainter.HeaderGlyphColorPalette(AState: TcxButtonState): IdxColorPalette;
begin
  Result := nil;
end;

function TcxCustomLookAndFeelPainter.ScaledHeaderHeight(AFontHeight: Integer; AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := AFontHeight + 2 * HeaderBorderSize + cxMarginsHeight(HeaderContentOffsets(AScaleFactor));
  dxAdjustToTouchableSize(Result, AScaleFactor);
end;

function TcxCustomLookAndFeelPainter.HeaderHeight(AFontHeight: Integer): Integer;
begin
  Result := ScaledHeaderHeight(AFontHeight, dxDefaultScaleFactor);
end;

function TcxCustomLookAndFeelPainter.HeaderControlSectionBorderSize(AState: TcxButtonState = cxbsNormal): Integer;
begin
  Result := 1;
end;

function TcxCustomLookAndFeelPainter.HeaderControlSectionTextAreaBounds(ABounds: TRect; AState: TcxButtonState): TRect;
begin
  Result := ABounds;
  if AState = cxbsPressed then
    OffsetRect(Result, 1, 1);
end;

function TcxCustomLookAndFeelPainter.HeaderControlSectionContentBounds(const ABounds: TRect; AState: TcxButtonState): TRect;
begin
  Result := cxRectInflate(ABounds, -HeaderControlSectionBorderSize(AState));
end;

function TcxCustomLookAndFeelPainter.HeaderWidth(ACanvas: TcxCanvas; ABorders: TcxBorders; const AText: string; AFont: TFont): Integer;
begin
  Result := ScaledHeaderWidth(ACanvas, ABorders, AText, AFont, dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.ScaledHeaderWidth(ACanvas: TcxCanvas;
  ABorders: TcxBorders; const AText: string; AFont: TFont; AScaleFactor: TdxScaleFactor): Integer;
begin
  ACanvas.Font := AFont;
  Result := ACanvas.TextWidth(AText) + cxMarginsWidth(HeaderContentOffsets(AScaleFactor));
  if bLeft in ABorders then
    Inc(Result, HeaderBorderSize);
  if bRight in ABorders then
    Dec(Result, HeaderBorderSize);
end;

function TcxCustomLookAndFeelPainter.IsHeaderHotTrack: Boolean;
begin
  Result := False;
end;

function TcxCustomLookAndFeelPainter.SortingMarkAreaSize: TPoint;
begin
  Result := ScaledSortingMarkAreaSize(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.ScaledSortingMarkAreaSize(AScaleFactor: TdxScaleFactor): TPoint;
begin
  if cxIsTouchModeEnabled then
    Result := Point(AScaleFactor.Apply(SortingTouchableMarkAreaWidth), ScaledSortingMarkSize(AScaleFactor).Y)
  else
    Result := Point(AScaleFactor.Apply(SortingMarkAreaWidth), ScaledSortingMarkSize(AScaleFactor).Y);
end;

function TcxCustomLookAndFeelPainter.SortingMarkSize: TPoint;
begin
  Result := ScaledSortingMarkSize(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.SummarySortingMarkSize: TPoint;
begin
  Result := ScaledSummarySortingMarkSize(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.SummaryValueSortingMarkSize: TPoint;
begin
  Result := ScaledSummaryValueSortingMarkSize(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.ScaledSummaryValueSortingMarkSize(AScaleFactor: TdxScaleFactor): TPoint;
begin
  Result := cxPoint(dxGetImageSize(cxIndicatorImages, AScaleFactor));
end;

procedure TcxCustomLookAndFeelPainter.DrawFooterCell(ACanvas: TcxCanvas;
  const ABounds: TRect; AAlignmentHorz: TAlignment;
  AAlignmentVert: TcxAlignmentVert; AMultiLine: Boolean;
  const AText: string; AFont: TFont; ATextColor, ABkColor: TColor;
  AOnDrawBackground: TcxDrawBackgroundEvent);
var
  ABordersScaleFactor: TdxScaleFactor;
begin
  ABordersScaleFactor := nil;
  dxInitBordersScaleFactor(dxDefaultScaleFactor, ABordersScaleFactor);
  DrawFooterCell(ACanvas, ABounds, AAlignmentHorz, AAlignmentVert, AMultiLine,
    AText, AFont, ATextColor, ABkColor, AOnDrawBackground, cxBordersAll, dxDefaultScaleFactor, ABordersScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawFooterCell(ACanvas: TcxCanvas;
  const ABounds: TRect; AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert;
  AMultiLine: Boolean; const AText: string; AFont: TFont; ATextColor, ABkColor: TColor;
  AOnDrawBackground: TcxDrawBackgroundEvent;
  const ABorders: TcxBorders; APaddingsScaleFactor, ABordersScaleFactor: TdxScaleFactor);
begin
  DrawFooterCellBorder(ACanvas, ABounds, ABorders, ABordersScaleFactor);
  DrawFooterCellContent(ACanvas, ABounds, AAlignmentHorz, AAlignmentVert,
    AMultiLine, AText, AFont, ATextColor, ABkColor, AOnDrawBackground, ABorders, APaddingsScaleFactor, ABordersScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawFooterCellBorder(
  ACanvas: TcxCanvas; const R: TRect);
var
  ABordersScaleFactor: TdxScaleFactor;
begin
  ABordersScaleFactor := nil;
  dxInitBordersScaleFactor(dxDefaultScaleFactor, ABordersScaleFactor);
  DrawFooterCellBorder(ACanvas, R, cxBordersAll, ABordersScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawFooterCellBorder(ACanvas: TcxCanvas; const R: TRect; const ABorders: TcxBorders;
  AScaleFactor: TdxScaleFactor);
begin
end;

procedure TcxCustomLookAndFeelPainter.DrawFooterCellContent(
  ACanvas: TcxCanvas; const ABounds: TRect; AAlignmentHorz: TAlignment;
  AAlignmentVert: TcxAlignmentVert; AMultiLine: Boolean;
  const AText: string; AFont: TFont; ATextColor, ABkColor: TColor;
  AOnDrawBackground: TcxDrawBackgroundEvent);
var
  ABordersScaleFactor: TdxScaleFactor;
begin
  ABordersScaleFactor := nil;
  dxInitBordersScaleFactor(dxDefaultScaleFactor, ABordersScaleFactor);
  DrawFooterCellContent(ACanvas, ABounds, AAlignmentHorz, AAlignmentVert, AMultiLine,
    AText, AFont, ATextColor, ABkColor, AOnDrawBackground, cxBordersAll, dxDefaultScaleFactor, ABordersScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawFooterCellContent(ACanvas: TcxCanvas;
  const ABounds: TRect; AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert;
  AMultiLine: Boolean; const AText: string; AFont: TFont; ATextColor, ABkColor: TColor;
  AOnDrawBackground: TcxDrawBackgroundEvent;
  const ABorders: TcxBorders; APaddingsScaleFactor, ABordersScaleFactor: TdxScaleFactor);
begin
  DrawContent(ACanvas, FooterCellContentBounds(ABounds, ABorders, APaddingsScaleFactor, ABordersScaleFactor),
    FooterCellTextAreaBounds(ABounds, ABorders, APaddingsScaleFactor, ABordersScaleFactor), cxbsNormal,
    AAlignmentHorz, AAlignmentVert, AMultiLine, False, AText, AFont, ATextColor, ABkColor,
    AOnDrawBackground, True);
end;

function TcxCustomLookAndFeelPainter.GridDefaultIndicatorWidth: Integer;
begin
  Result := cxGridDefaultIndicatorWidth;
end;

procedure TcxCustomLookAndFeelPainter.DrawFilterRowSeparator(
  ACanvas: TcxCanvas; const ARect: TRect; ABackgroundColor: TColor);
begin
  DrawScaledHeader(ACanvas, ARect, ARect, [], cxBordersAll, cxbsNormal, taLeftJustify,
    vaTop, False, False, '', nil, clWindowText, ABackgroundColor, dxDefaultScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawGroupByBox(ACanvas: TcxCanvas;
  const ARect: TRect; ATransparent: Boolean; ABackgroundColor: TColor; const ABackgroundBitmap: TBitmap);
begin
  DrawBackground(ACanvas, ARect, ATransparent, ABackgroundColor, ABackgroundBitmap);
end;

function TcxCustomLookAndFeelPainter.GridGroupRowStyleOffice11ContentColor(AHasData: Boolean): TColor;
begin
  if AHasData then
    Result := clWindow
  else
    Result := dxOffice11GroupIndentColor;
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledFindPanelNextButtonGlyph(ACanvas: TcxCanvas;
  const ARect: TRect; const AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
var
  AColor: TColor;
  APalette: TdxSimpleColorPalette;
begin
  AColor := ButtonSymbolColor(AState);
  APalette := TdxSimpleColorPalette.Create(dxColorToAlphaColor(AColor), TdxAlphaColors.Empty);
  FindPanelNextButtonGlyph.StretchDraw(ACanvas.Handle, ARect, MaxByte, APalette);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledFindPanelPreviousButtonGlyph(ACanvas: TcxCanvas;
  const ARect: TRect; const AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
var
  AColor: TColor;
  APalette: TdxSimpleColorPalette;
begin
  AColor := ButtonSymbolColor(AState);
  APalette := TdxSimpleColorPalette.Create(dxColorToAlphaColor(AColor), TdxAlphaColors.Empty);
  FindPanelPreviousButtonGlyph.StretchDraw(ACanvas.Handle, ARect, MaxByte, APalette);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledGroupByBox(
  ACanvas: TcxCanvas; const ARect: TRect; ATransparent: Boolean;
  ABackgroundColor: TColor; const ABackgroundBitmap: TBitmap; AScaleFactor,
  ABordersScaleFactor: TdxScaleFactor);
begin
  DrawBackground(ACanvas, ARect, ATransparent, ABackgroundColor, ABackgroundBitmap);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledGroupByBoxSearchButtonGlyph(ACanvas: TcxCanvas;
  const ARect: TRect; const AState: TcxButtonState; AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault);

  function GetDefaultAlphaColor: TdxAlphaColor;
  var
    AColor: TColor;
  begin
    if AState in [cxbsHot, cxbsPressed] then
      AColor := DefaultContentTextColor
    else
      AColor := DefaultGroupByBoxTextColor;
    Result := dxColorToAlphaColor(AColor);
  end;

  function GetAlphaColor(AColor: TColor): TdxAlphaColor;
  begin
    Result := dxColorToAlphaColor(AColor, IfThen(AState in [cxbsHot, cxbsPressed], 150, 255));
  end;

var
  AAlphaColor: TdxAlphaColor;
  APalette: TdxSimpleColorPalette;
begin
  if AColor = clDefault then
    AAlphaColor := GetDefaultAlphaColor
  else
    AAlphaColor := GetAlphaColor(AColor);
  APalette := TdxSimpleColorPalette.Create(AAlphaColor, TdxAlphaColors.Empty);
  GroupByBoxSearchButtonGlyph.StretchDraw(ACanvas.Handle, ARect, MaxByte, APalette);
end;

function TcxCustomLookAndFeelPainter.GridBordersOverlapSize: Integer;
begin
  Result := 0;
end;

function TcxCustomLookAndFeelPainter.GridGroupRowStyleOffice11SeparatorColor: TColor;
begin
  Result := dxOffice11GroupRowSeparatorColor;
end;

function TcxCustomLookAndFeelPainter.GridGroupRowStyleOffice11TextColor: TColor;
begin
  Result := dxOffice11GroupRowTextColor;
end;

function TcxCustomLookAndFeelPainter.GridDrawHeaderCellsFirst: Boolean;
begin
  Result := HeaderDrawCellsFirst;
end;

function TcxCustomLookAndFeelPainter.GridLikeControlBackgroundColor: TColor;
begin
  Result := DefaultContentColor;
end;

function TcxCustomLookAndFeelPainter.GridLikeControlContentColor: TColor;
begin
  Result := DefaultContentColor;
end;

function TcxCustomLookAndFeelPainter.GridLikeControlContentEvenColor: TColor;
begin
  Result := DefaultContentEvenColor;
end;

function TcxCustomLookAndFeelPainter.GridLikeControlContentOddColor: TColor;
begin
  Result := DefaultContentOddColor;
end;

function TcxCustomLookAndFeelPainter.GridLikeControlContentTextColor: TColor;
begin
  Result := DefaultContentTextColor;
end;

function TcxCustomLookAndFeelPainter.GridLikeControlDefaultUseOddEvenStyle: Boolean;
begin
  Result := (GridLikeControlContentColor <> GridLikeControlContentOddColor) or
    (GridLikeControlContentOddColor <> GridLikeControlContentEvenColor);
end;

function TcxCustomLookAndFeelPainter.GridScaleGridLines: Boolean;
begin
  Result := False;
end;

function TcxCustomLookAndFeelPainter.GridUseDiscreteScalingForGridLines: Boolean;
begin
  Result := False;
end;

function TcxCustomLookAndFeelPainter.PivotGridHeadersAreaColor: TColor;
begin
  Result := DefaultHeaderBackgroundColor;
end;

function TcxCustomLookAndFeelPainter.PivotGridHeadersAreaTextColor: TColor;
begin
  Result := DefaultHeaderBackgroundTextColor;
end;

function TcxCustomLookAndFeelPainter.LayoutViewGetPadding(AElement: TcxLayoutElement): TRect;
begin
  Result := cxNullRect;
end;

function TcxCustomLookAndFeelPainter.LayoutViewGetSpacing(AElement: TcxLayoutElement): TRect;
begin
  Result := cxNullRect;
end;

procedure TcxCustomLookAndFeelPainter.LayoutViewDrawItem(ACanvas: TcxCanvas;
  const ABounds: TRect; AState: TcxButtonState; ABorders: TcxBorders = []);
begin
  LayoutViewDrawItemScaled(ACanvas, ABounds, AState, dxDefaultScaleFactor, ABorders);
end;

procedure TcxCustomLookAndFeelPainter.LayoutViewDrawItemScaled(ACanvas: TcxCanvas; const ABounds: TRect;
  AState: TcxButtonState; AScaleFactor: TdxScaleFactor; ABorders: TcxBorders = []);
var
  AColor: TColor;
begin
  case AState of
    cxbsHot:
      begin
        ACanvas.FrameRect(ABounds, clBtnShadow, 1, cxBordersAll, True);
        AColor := clGradientInactiveCaption;
      end;
    cxbsPressed:
      AColor := DefaultSelectionColor;
    cxbsDisabled:
      AColor := clInactiveCaption;
  else
    AColor := DefaultGroupColor;
  end;
  ACanvas.FillRect(ABounds, AColor);
end;

procedure TcxCustomLookAndFeelPainter.LayoutViewDrawRecordCaption(ACanvas: TcxCanvas; const ABounds, ATextRect: TRect;
  APosition: TcxGroupBoxCaptionPosition; AState: TcxButtonState; AColor: TColor = clDefault; const ABitmap: TBitmap = nil);
begin
  LayoutViewDrawScaledRecordCaption(ACanvas, ABounds, ATextRect, APosition, AState, dxDefaultScaleFactor, AColor, ABitmap);
end;

procedure TcxCustomLookAndFeelPainter.LayoutViewDrawScaledRecordCaption(ACanvas: TcxCanvas; const ABounds, ATextRect: TRect;
  APosition: TcxGroupBoxCaptionPosition; AState: TcxButtonState; AScaleFactor: TdxScaleFactor;
  AColor: TColor = clDefault; const ABitmap: TBitmap = nil);
begin
  LayoutViewDrawRecordBorder(ACanvas, ABounds, AState, cxBordersAll);
  if (AColor = clDefault) and (ABitmap = nil) then
    AColor := DefaultLayoutViewCaptionColor(AState);
  DrawBackground(ACanvas, ABounds, ABitmap <> nil, AColor, ABitmap);
end;

procedure TcxCustomLookAndFeelPainter.LayoutViewDrawRecordBorder(
  ACanvas: TcxCanvas; const ABounds: TRect; AState: TcxButtonState; ABorders: TcxBorders = []);
var
  ABorderColor: TColor;
begin
  if AState = cxbsHot then
    ABorderColor := DefaultSelectionColor
  else
    ABorderColor := clBtnShadow;
  ACanvas.FrameRect(ABounds, ABorderColor, 1, ABorders, True);
end;

procedure TcxCustomLookAndFeelPainter.LayoutViewDrawRecordContent(ACanvas: TcxCanvas;
  const ABounds: TRect; ACaptionPosition: TcxGroupBoxCaptionPosition; AState: TcxButtonState;
  ABorders: TcxBorders = cxBordersAll);
begin
  LayoutViewDrawScaledRecordContent(ACanvas, ABounds, ACaptionPosition, AState, dxDefaultScaleFactor, ABorders);
end;

procedure TcxCustomLookAndFeelPainter.LayoutViewDrawScaledRecordContent(ACanvas: TcxCanvas;
  const ABounds: TRect; ACaptionPosition: TcxGroupBoxCaptionPosition; AState: TcxButtonState;
  AScaleFactor: TdxScaleFactor; ABorders: TcxBorders = cxBordersAll);
begin
  LayoutViewDrawRecordBorder(ACanvas, ABounds, AState, ABorders);
  ACanvas.FillRect(ABounds, DefaultGroupColor);
end;

procedure TcxCustomLookAndFeelPainter.LayoutViewDrawScaledRecordExpandButton(ACanvas: TcxCanvas;
  const ABounds: TRect; AState: TcxButtonState; AExpanded: Boolean; AScaleFactor: TdxScaleFactor);
begin
  DrawScaledGroupExpandButton(ACanvas, ABounds, AExpanded, AState, AScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.LayoutViewDrawRecordExpandButton(
  ACanvas: TcxCanvas; const ABounds: TRect; AState: TcxButtonState; AExpanded: Boolean);
begin
  LayoutViewDrawScaledRecordExpandButton(ACanvas, ABounds, AState, AExpanded, dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.LayoutViewRecordCaptionTailSize(
  ACaptionPosition: TcxGroupBoxCaptionPosition): Integer;
begin
  Result := 0;
end;

function TcxCustomLookAndFeelPainter.LayoutViewRecordCaptionScaledTailSize(
  ACaptionPosition: TcxGroupBoxCaptionPosition; AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := 0;
end;

function TcxCustomLookAndFeelPainter.LayoutViewRecordCaptionTextBold: Boolean;
begin
  Result := False;
end;

function TcxCustomLookAndFeelPainter.WinExplorerViewDefaultRecordColor(AState: TcxButtonState): TColor;
begin
  case AState of
    cxbsHot:
      begin
        Result := clGradientInactiveCaption;
      end;
    cxbsPressed:
        Result := DefaultSelectionColor;
    cxbsDisabled:
      Result := clInactiveCaption;
  else
    Result := DefaultContentColor;
  end;
end;

procedure TcxCustomLookAndFeelPainter.WinExplorerViewDrawGroup(ACanvas: TcxCanvas; const ABounds: TRect; AState: TcxButtonState;
  AColor: TColor = clDefault; const ABitmap: TBitmap = nil);
begin
  WinExplorerViewDrawRecord(ACanvas, ABounds, AState, AColor, ABitmap);
end;

procedure TcxCustomLookAndFeelPainter.WinExplorerViewDrawGroupCaptionLine(ACanvas: TcxCanvas; const ABounds: TRect);
begin
  DrawSeparator(ACanvas, ABounds, False);
end;

procedure TcxCustomLookAndFeelPainter.WinExplorerViewDrawRecord(ACanvas: TcxCanvas; const ABounds: TRect;
  AState: TcxButtonState; AColor: TColor = clDefault; const ABitmap: TBitmap = nil);
begin
  if AState in [cxbsHot, cxbsPressed, cxbsDisabled] then
    ACanvas.FrameRect(ABounds, clBtnShadow, 1, cxBordersAll, True);
  if (AColor = clDefault) and (ABitmap = nil) then
    AColor := WinExplorerViewDefaultRecordColor(AState);
  DrawBackground(ACanvas, ABounds, ABitmap <> nil, AColor, ABitmap);
end;

procedure TcxCustomLookAndFeelPainter.WinExplorerViewDrawRecordExpandButton(
  ACanvas: TcxCanvas; const ABounds: TRect; AState: TcxButtonState; AExpanded: Boolean);
begin
  WinExplorerViewDrawScaledRecordExpandButton(ACanvas, ABounds, AState, AExpanded, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.WinExplorerViewDrawScaledRecordExpandButton(ACanvas: TcxCustomCanvas;
  const ABounds: TRect; AState: TcxButtonState; AExpanded: Boolean; AScaleFactor: TdxScaleFactor);
begin
  DrawScaledGroupExpandButton(ACanvas, ABounds, AExpanded, AState, AScaleFactor);
end;

function TcxCustomLookAndFeelPainter.WinExplorerViewScaledExpandButtonSize(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := ScaledGroupExpandButtonSize(AScaleFactor);
end;

function TcxCustomLookAndFeelPainter.WinExplorerViewExpandButtonSize: Integer;
begin
  Result := WinExplorerViewScaledExpandButtonSize(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.WinExplorerViewGroupCaptionLineHeight: Integer;
begin
  Result := SeparatorSize;
end;

function TcxCustomLookAndFeelPainter.WinExplorerViewGroupTextColor(AState: TcxButtonState): TColor;
begin
  Result := WinExplorerViewRecordTextColor(AState);
end;

function TcxCustomLookAndFeelPainter.WinExplorerViewGroupTextBold: Boolean;
begin
  Result := False;
end;

function TcxCustomLookAndFeelPainter.WinExplorerViewRecordTextColor(AState: TcxButtonState): TColor;
begin
  case AState of
    cxbsPressed:
      Result := DefaultSelectionTextColor;
    cxbsDisabled:
      Result := DefaultInactiveTextColor;
  else
    Result := DefaultContentTextColor;
  end;
end;

function TcxCustomLookAndFeelPainter.FooterBorders: TcxBorders;
begin
  Result := cxBordersAll;
end;

function TcxCustomLookAndFeelPainter.FooterBorderSize: Integer;
begin
  Result := 0;
end;

function TcxCustomLookAndFeelPainter.FooterCellBorderSize: Integer;
begin
  Result := 0;
end;

function TcxCustomLookAndFeelPainter.FooterCellBordersSizeRect(
  const ABorders: TcxBorders; AScaleFactor, ABordersScaleFactor: TdxScaleFactor): TRect;
begin
  Result := ABordersScaleFactor.Apply(cxBordersSizeRect(ABorders, FooterCellBorderSize));
end;

function TcxCustomLookAndFeelPainter.FooterCellOffset: Integer;
begin
  Result := 0;
end;

function TcxCustomLookAndFeelPainter.FooterDrawCellsFirst: Boolean;
begin
  Result := True;
end;

function TcxCustomLookAndFeelPainter.FooterPanelBordersSizeRect(
  const ABorders: TcxBorders; AScaleFactor, ABordersScaleFactor: TdxScaleFactor): TRect;
begin
  Result := cxBordersSizeRect(ABorders, ABordersScaleFactor.Apply(FooterBorderSize));
end;

function TcxCustomLookAndFeelPainter.FooterPanelContentOffsets(const ABorders: TcxBorders;
  AIncludeBorders: Boolean; AScaleFactor, ABordersScaleFactor: TdxScaleFactor): TRect;
begin
  Result.Init(AScaleFactor.Apply(FooterContentOffset));
  if AIncludeBorders then
    Result.Offset(FooterPanelBordersSizeRect(ABorders, AScaleFactor, ABordersScaleFactor));
end;

function TcxCustomLookAndFeelPainter.FooterSeparatorColor: TColor;
begin
  Result := clBtnShadow;
end;

function TcxCustomLookAndFeelPainter.FooterSeparatorSize: Integer;
begin
  Result := 1;
end;

procedure TcxCustomLookAndFeelPainter.DrawFooterBorder(ACanvas: TcxCanvas;
  const R: TRect);
var
  ABordersScaleFactor: TdxScaleFactor;
begin
  ABordersScaleFactor := nil;
  dxInitBordersScaleFactor(dxDefaultScaleFactor, ABordersScaleFactor);
  DrawFooterBorder(ACanvas, R, cxBordersAll, dxDefaultScaleFactor, ABordersScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawFooterBorder(ACanvas: TcxCanvas; const R: TRect;
  const ABorders: TcxBorders; AScaleFactor, ABordersScaleFactor: TdxScaleFactor);
begin
end;

procedure TcxCustomLookAndFeelPainter.DrawFooterBorderEx(ACanvas: TcxCanvas;
  const R: TRect; ABorders: TcxBorders; AScaleFactor: TdxScaleFactor);
var
  ABordersScaleFactor: TdxScaleFactor;
begin
  ABordersScaleFactor := nil;
  dxInitBordersScaleFactor(AScaleFactor, ABordersScaleFactor);
  DrawFooterBorder(ACanvas, R, ABorders, AScaleFactor, ABordersScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawFooterContent(ACanvas: TcxCanvas;
  const ARect: TRect; const AViewParams: TcxViewParams);
var
  ABordersScaleFactor: TdxScaleFactor;
begin
  ABordersScaleFactor := nil;
  dxInitBordersScaleFactor(dxDefaultScaleFactor, ABordersScaleFactor);
  DrawFooterContent(ACanvas, ARect, AViewParams, cxBordersAll, dxDefaultScaleFactor, ABordersScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawFooterContent(
  ACanvas: TcxCanvas; const ARect: TRect; const AViewParams: TcxViewParams;
  const ABorders: TcxBorders; AScaleFactor, ABordersScaleFactor: TdxScaleFactor);
begin
  ACanvas.FillRect(ARect, AViewParams);
  DrawFooterBorder(ACanvas, ARect, ABorders, AScaleFactor, ABordersScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawFooterPanel(ACanvas: TcxCanvas;
  const ABounds: TRect; const AViewParams: TcxViewParams;
  ABorders: TcxBorders);
var
  ABordersScaleFactor: TdxScaleFactor;
begin
  ABordersScaleFactor := nil;
  dxInitBordersScaleFactor(dxDefaultScaleFactor, ABordersScaleFactor);
  DrawFooterPanel(ACanvas, ABounds, AViewParams, ABorders, dxDefaultScaleFactor, ABordersScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawFooterPanel(ACanvas: TcxCanvas;
  const ABounds: TRect; const AViewParams: TcxViewParams;
  const ABorders: TcxBorders; AScaleFactor, ABordersScaleFactor: TdxScaleFactor);
begin
  ACanvas.SaveClipRegion;
  try
    ACanvas.IntersectClipRect(ABounds);
    DrawFooterContent(ACanvas, ABounds, AViewParams, ABorders, AScaleFactor, ABordersScaleFactor);
  finally
    ACanvas.RestoreClipRegion;
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawFooterSeparator(ACanvas: TcxCanvas; const R: TRect);
begin
  ACanvas.FillRect(R, FooterSeparatorColor);
end;

procedure TcxCustomLookAndFeelPainter.DrawFilterActivateButton(
  ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AChecked: Boolean);
begin
  DrawScaledFilterActivateButton(ACanvas, R, AState, AChecked, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledFilterActivateButton(
  ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AChecked: Boolean; AScaleFactor: TdxScaleFactor);
begin
  DrawScaledCheckButton(ACanvas, R, AState, AChecked, AScaleFactor, ACanvas.Brush.Style = bsSolid);
end;

procedure TcxCustomLookAndFeelPainter.DrawFilterCloseButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState);
begin
  DrawScaledFilterCloseButton(ACanvas, R, AState, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawFilterCustomizeButton(
  ACanvas: TcxCanvas; const ABounds: TRect; const ACaption: string;
  AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
begin
  DrawScaledButton(ACanvas, ABounds, AState, False, AScaleFactor);
  if ACaption <> '' then
    DoDrawScaledButtonCaption(ACanvas, ABounds, ACaption, AState, clDefault, True, False, False, AScaleFactor, cxbpButton);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledFilterCloseButton(
  ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
begin
  DrawScaledSmallButton(ACanvas, R, AState, AScaleFactor);
  DrawScaledButtonCross(ACanvas, R, ButtonSymbolColor(AState), ButtonSymbolState(AState), AScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawFilterDropDownButton(
  ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AIsFilterActive: Boolean);
begin
  DrawScaledFilterDropDownButton(ACanvas, R, AState, AIsFilterActive, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawFilterPanel(ACanvas: TcxCanvas;
  const ARect: TRect; ATransparent: Boolean; ABackgroundColor: TColor;
  const ABackgroundBitmap: TGraphic; const ABorders: TcxBorders;
  AScaleFactor, ABordersScaleFactor: TdxScaleFactor);
var
  ABitmap: TBitmap;
begin
  ABitmap := cxGetAsBitmap(ABackgroundBitmap);
  try
    DrawBackground(ACanvas, ARect, ATransparent, ABackgroundColor, ABitmap);
  finally
    ABitmap.Free;
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawFilterPanel(ACanvas: TcxCanvas;
  const ARect: TRect; ATransparent: Boolean; ABackgroundColor: TColor;
  const ABackgroundBitmap: TGraphic);
var
  ABordersScaleFactor: TdxScaleFactor;
begin
  ABordersScaleFactor := nil;
  dxInitBordersScaleFactor(dxDefaultScaleFactor, ABordersScaleFactor);
  DrawFilterPanel(ACanvas, ARect, ATransparent, ABackgroundColor, ABackgroundBitmap, cxBordersAll,
    dxDefaultScaleFactor, ABordersScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawFilterSmartTag(ACanvas: TcxCanvas;
  R: TRect; AState: TcxFilterSmartTagState; AIsFilterActive: Boolean);
begin
  DrawScaledFilterSmartTag(ACanvas, R, AState, AIsFilterActive, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledFilterSmartTag(ACanvas: TcxCanvas;
  R: TRect; AState: TcxFilterSmartTagState; AIsFilterActive: Boolean; AScaleFactor: TdxScaleFactor);
begin
  SmartTagGlyph.StretchDraw(ACanvas.Handle, R, MaxByte, TdxSimpleColorPalette.Create(
    TdxAlphaColors.Empty, dxColorToAlphaColor(GetFilterSmartTagColor(AState, AIsFilterActive))));
end;

function TcxCustomLookAndFeelPainter.ScaledFilterActivateButtonSize(AScaleFactor: TdxScaleFactor): TPoint;
begin
  Result := AScaleFactor.Apply(Point(FilterActiveButtonWidth, FilterActiveButtonHeight));
end;

function TcxCustomLookAndFeelPainter.FilterActivateButtonSize: TPoint;
begin
  Result := ScaledFilterActivateButtonSize(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.FilterCloseButtonSize: TPoint;
begin
  Result := ScaledFilterCloseButtonSize(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.ScaledFilterCloseButtonSize(AScaleFactor: TdxScaleFactor): TPoint;
begin
  Result := AScaleFactor.Apply(Point(FilterCloseButtonWidth, FilterCloseButtonHeight));
end;

function TcxCustomLookAndFeelPainter.FilterControlMenuGetColorPalette: IdxColorPalette;
begin
  Result := nil;
end;

function TcxCustomLookAndFeelPainter.FilterDropDownButtonSize: TPoint;
begin
  Result := ScaledFilterDropDownButtonSize(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.ScaledFilterDropDownButtonSize(AScaleFactor: TdxScaleFactor): TPoint;
begin
  Result := AScaleFactor.Apply(Point(FilterDropDownButtonWidth, 0));
  dxAdjustToTouchableSize(Result.X);
end;

function TcxCustomLookAndFeelPainter.FilterSmartTagSize: TSize;
begin
  Result := ScaledFilterSmartTagSize(dxSystemScaleFactor)
end;

function TcxCustomLookAndFeelPainter.ScaledFilterSmartTagSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  Result.Init(AScaleFactor.Apply(10));
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledFilterBoolOperatorBackground(ACanvas: TcxCanvas;
  const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
var
  AColor: TColor;
begin
  ACanvas.SaveState;
  try
    if AState in [cxbsHot, cxbsDefault] then
      AColor := $B4B4F3
    else
      AColor := $CDCDF7;
    ACanvas.FillRect(R, AColor);
  finally
    ACanvas.RestoreState;
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledFilterControlAddButtonGlyph(ACanvas: TcxCanvas; const R: TRect;
  AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
var
  APalette: TdxSimpleColorPalette;
begin
  APalette := TdxSimpleColorPalette.Create(GetFilterAddButtonColor(AState), TdxAlphaColors.Empty);
  FilterControlAddButtonGlyph.StretchDraw(ACanvas.Handle, R, MaxByte, APalette);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledFilterControlRemoveButtonGlyph(ACanvas: TcxCanvas; const R: TRect;
  AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
var
  APalette: TdxSimpleColorPalette;
begin
  APalette := TdxSimpleColorPalette.Create(GetFilterRemoveButtonColor(AState), TdxAlphaColors.Empty);
  FilterControlRemoveButtonGlyph.StretchDraw(ACanvas.Handle, R, MaxByte, APalette);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledFilterItemCaptionBackground(ACanvas: TcxCanvas;
  const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
var
  AColor: TColor;
begin
  ACanvas.SaveState;
  try
    if AState in [cxbsHot, cxbsDefault] then
      AColor := $9ACBF4
    else
      AColor := $A8CAE9;
    ACanvas.FillRect(R, AColor);
  finally
    ACanvas.RestoreState;
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledFilterOperatorBackground(ACanvas: TcxCanvas;
  const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
var
  AColor: TColor;
begin
  ACanvas.SaveState;
  try
    if AState in [cxbsHot, cxbsDefault] then
      AColor := $E4C8BA
    else
      AColor := $E0CCC1;
    ACanvas.FillRect(R, AColor);
  finally
    ACanvas.RestoreState;
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledFilterPanelBrackets(ACanvas: TcxCanvas; const R: TRect; AScaleFactor: TdxScaleFactor);

  procedure DrawOpenBracket(ACanvas: TcxCanvas; const R: TRect; AColor: TColor);
  var
    APoints: array[0..3] of TPoint;
  begin
    APoints[0] := Point(R.Right - 1, R.Bottom - 1);
    APoints[1] := Point(R.Left, R.Bottom - 1);
    APoints[2] := Point(R.Left, R.Top);
    APoints[3] := Point(R.Right, R.Top);
    ACanvas.Polyline(APoints, AColor);
  end;

  procedure DrawCloseBracket(ACanvas: TcxCanvas; const R: TRect; AColor: TColor);
  var
    APoints: array[0..3] of TPoint;
  begin
    APoints[0] := Point(R.Left, R.Bottom - 1);
    APoints[1] := Point(R.Right - 1, R.Bottom - 1);
    APoints[2] := Point(R.Right - 1, R.Top);
    APoints[3] := Point(R.Left - 1, R.Top);
    ACanvas.Polyline(APoints, AColor);
  end;

var
  ARect: TRect;
  AColor: TColor;
  ABracketWidth: Integer;
begin
  ACanvas.SaveState;
  try
    AColor := $C3C3C3;
    ABracketWidth := 4;
    ARect := cxRectSetWidth(R, ABracketWidth);
    DrawOpenBracket(ACanvas, ARect, AColor);
    ARect := R;
    ARect.Left := ARect.Right - ABracketWidth;
    DrawCloseBracket(ACanvas, ARect, AColor);
  finally
    ACanvas.RestoreState;
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledFilterPanelRemoveButtonGlyph(ACanvas: TcxCanvas; const R: TRect;
  AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
var
  APalette: TdxSimpleColorPalette;
begin
  APalette := TdxSimpleColorPalette.Create(GetFilterRemoveButtonColor(AState), TdxAlphaColors.Empty);
  FilterPanelRemoveButtonGlyph.StretchDraw(ACanvas.Handle, R, MaxByte, APalette);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledFilterPanelRemovingArea(ACanvas: TcxCanvas; const R: TRect; AScaleFactor: TdxScaleFactor);
var
  AColor: TColor;
begin
  ACanvas.SaveState;
  try
    AColor := TdxAlphaColors.ToColor(GetFilterRemoveButtonColor(cxbsHot));
    ACanvas.Rectangle(R, clNone, AColor, psDot);
  finally
    ACanvas.RestoreState;
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledFilterValueBackground(ACanvas: TcxCanvas; const R: TRect;
  AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
var
  AColor: TColor;
begin
  ACanvas.SaveState;
  try
    if AState in [cxbsHot, cxbsDefault] then
      AColor := $B7D5BC
    else
      AColor := $BFD3C0;
    ACanvas.FillRect(R, AColor);
  finally
    ACanvas.RestoreState;
  end;
end;

procedure TcxCustomLookAndFeelPainter.GetScaledFilterTokenParams(out AParams: TdxFilterTokenParams;
  AScaleFactor: TdxScaleFactor);
begin
  AParams.BoolOperatorTextColor := DefaultContentTextColor;
  AParams.ItemCaptionTextColor := AParams.BoolOperatorTextColor;
  AParams.OperatorTextColor := AParams.BoolOperatorTextColor;
  AParams.ValueTextColor := AParams.BoolOperatorTextColor;
  AParams.BoolOperatorTextMargins := AScaleFactor.Apply(Rect(5, 3, 5, 3));
  AParams.ItemCaptionTextMargins := AParams.BoolOperatorTextMargins;
  AParams.OperatorTextMargins := AParams.BoolOperatorTextMargins;
  AParams.ValueTextMargins := AParams.BoolOperatorTextMargins;
  AParams.FilterPanelItemMargins := Rect(4, 3, 4, 3); 
  AParams.ElementsIndent := AScaleFactor.Apply(2);
  AParams.FilterControlBackgroundColor := clDefault;
end;

procedure TcxCustomLookAndFeelPainter.DrawFindPanel(ACanvas: TcxCanvas; const ARect: TRect; ATransparent: Boolean; ABackgroundColor: TColor; const ABackgroundBitmap: TGraphic);
var
  ABordersScaleFactor: TdxScaleFactor;
begin
  ABordersScaleFactor := nil;
  dxInitBordersScaleFactor(dxDefaultScaleFactor, ABordersScaleFactor);
  DrawFindPanel(ACanvas, ARect, ATransparent, ABackgroundColor, ABackgroundBitmap, cxBordersAll, dxDefaultScaleFactor, ABordersScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawFindPanel(ACanvas: TcxCanvas;
  const ARect: TRect; ATransparent: Boolean; ABackgroundColor: TColor;
  const ABackgroundBitmap: TGraphic; const ABorders: TcxBorders;
  AScaleFactor, ABordersScaleFactor: TdxScaleFactor);
begin
  DrawFilterPanel(ACanvas, ARect, ATransparent, ABackgroundColor, ABackgroundBitmap, ABorders, AScaleFactor, ABordersScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawFindPanelBorder(
  ACanvas: TcxCanvas; const R: TRect; const ABorders: TcxBorders;
  AScaleFactor, ABordersScaleFactor: TdxScaleFactor);
begin
  DrawFooterBorder(ACanvas, R, ABorders, AScaleFactor, ABordersScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawFindPanelBorder(ACanvas: TcxCanvas; const R: TRect; ABorders: TcxBorders; AScaleFactor: TdxScaleFactor);
var
  ABordersScaleFactor: TdxScaleFactor;
begin
  ABordersScaleFactor := nil;
  dxInitBordersScaleFactor(dxDefaultScaleFactor, ABordersScaleFactor);
  DrawFindPanelBorder(ACanvas, R, ABorders, dxDefaultScaleFactor, ABordersScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawEditPopupWindowBorder(ACanvas: TcxCanvas; var R: TRect;
  ABorderStyle: TcxEditPopupBorderStyle; AClientEdge: Boolean);
begin
  case ABorderStyle of
    epbsSingle:
      ACanvas.FrameRect(R, clBtnText);
    epbsFrame3D, epbsFlat:
      begin
        ACanvas.DrawEdge(R, False, True);
        InflateRect(R, -1, -1);
        ACanvas.DrawEdge(R, False, False);
        if ABorderStyle = epbsFrame3D then
        begin
          InflateRect(R, -1, -1);
          if AClientEdge then
            ACanvas.FrameRect(R, clInactiveBorder)
          else
            ACanvas.FrameRect(R, clBtnFace);
          InflateRect(R, -1, -1);
          if AClientEdge then
            ACanvas.FrameRect(R, clBtnFace)
          else
            ACanvas.DrawEdge(R, True, True);
        end;
      end;
  end;
  InflateRect(R, -1, -1);
end;

procedure TcxCustomLookAndFeelPainter.DrawWindowContent(ACanvas: TcxCanvas;
  const ARect: TRect);
begin
  ACanvas.FillRect(ARect, clBtnFace);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledZoomInButton(
  ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
const
  PlusSignIndent = 3;
begin
  DrawScaledZoomOutButton(ACanvas, R, AState, AScaleFactor);
  ACanvas.MoveTo((R.Left + R.Right) div 2, R.Top + AScaleFactor.Apply(PlusSignIndent));
  ACanvas.LineTo((R.Left + R.Right) div 2, R.Bottom - AScaleFactor.Apply(PlusSignIndent));
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledZoomOutButton(
  ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
const
  MinusSignIndent = 3;
var
  ARect: TRect;
begin
  ARect := R;
  DrawButtonBorder(ACanvas, ARect, AState);
  InflateRect(ARect, -1, -1);
  ACanvas.Brush.Color := ButtonColor(AState);
  ACanvas.FillRect(ARect);
  if AState <> cxbsDisabled then
    ACanvas.Pen.Color := ButtonSymbolColor(AState)
  else
    ACanvas.Pen.Color := clBtnShadow;

  ACanvas.MoveTo(R.Left + AScaleFactor.Apply(MinusSignIndent), (R.Top + R.Bottom) div 2);
  ACanvas.LineTo(R.Right - AScaleFactor.Apply(MinusSignIndent), (R.Top + R.Bottom) div 2);
end;

function TcxCustomLookAndFeelPainter.GetEditPopupWindowBorderWidth(AStyle: TcxEditPopupBorderStyle): Integer;
begin
  Result := cxEditPopupWindowFrameWidthA[AStyle];
end;

function TcxCustomLookAndFeelPainter.GetEditPopupWindowClientEdgeWidth(AStyle: TcxEditPopupBorderStyle): Integer;
begin
  Result := cxEditPopupClientEdgeWidthA[AStyle]
end;

function TcxCustomLookAndFeelPainter.PopupBorderStyle: TcxPopupBorderStyle;
begin
  Result := pbsUltraFlat;
end;

function TcxCustomLookAndFeelPainter.GetHintBorderColor: TColor;
begin
  Result := clDefault;
end;

procedure TcxCustomLookAndFeelPainter.DrawHintBackground(ACanvas: TcxCanvas; const ARect: TRect; AColor: TColor);
begin
  ACanvas.FillRect(ARect, cxGetActualColor(AColor, clInfoBk));
end;

function TcxCustomLookAndFeelPainter.ScreenTipGetColorPalette: IdxColorPalette;
begin
  Result := nil;
end;

function TcxCustomLookAndFeelPainter.ScreenTipGetDescriptionPadding: TRect;
begin
  Result.Init(8, 8, 0, 4);
end;

function TcxCustomLookAndFeelPainter.ScreenTipGetDescriptionTextColor: TColor;
begin
  Result := clDefault;
end;

function TcxCustomLookAndFeelPainter.ScreenTipGetFooterPadding: TRect;
begin
  Result.Init(0, 0, 0, 0);
end;

function TcxCustomLookAndFeelPainter.ScreenTipGetHeaderPadding: TRect;
begin
  Result.Init(0, 0, 0, 0);
end;

function TcxCustomLookAndFeelPainter.ScreenTipGetFooterLineSize: Integer;
begin
  Result := 3;
end;

function TcxCustomLookAndFeelPainter.ScreenTipGetSeparatorPadding: TRect;
begin
  Result.Init(0, 6, 0, 6);
end;

function TcxCustomLookAndFeelPainter.ScreenTipGetTitleTextColor: TColor;
begin
  Result := clDefault;
end;

function TcxCustomLookAndFeelPainter.ScreenTipGetWindowPadding: TRect;
begin
  Result.Init(10, 8, 10, 8);
end;

procedure TcxCustomLookAndFeelPainter.ScreenTipDrawBackground(ACanvas: TcxCanvas; ARect: TRect);

  procedure ScreenTipDrawBorder(ACanvas: TcxCanvas; ARect: TRect);
  begin
    ACanvas.Pen.Color := clWindowFrame;
    ACanvas.Brush.Style := bsClear;
    ACanvas.Canvas.RoundRect(ARect.Left, ARect.Top, ARect.Right, ARect.Bottom, 2, 2);
    ACanvas.Brush.Style := bsSolid;
  end;

begin
  DrawHintBackground(ACanvas, cxRectInflate(ARect, -1, -1));
  ScreenTipDrawBorder(ACanvas, ARect);
end;

procedure TcxCustomLookAndFeelPainter.ScreenTipDrawFooterLine(ACanvas: TcxCanvas; const ARect: TRect);
begin
  ACanvas.DrawComplexFrame(ARect, clWindowFrame, clWindowFrame, [bTop]);
  ACanvas.DrawComplexFrame(cxRectOffset(ARect, 0, 1), clWhite, clWhite, [bTop]);
end;

procedure TcxCustomLookAndFeelPainter.DrawTab(ACanvas: TcxCanvas; R: TRect;
  ABorders: TcxBorders; const AText: string; AState: TcxButtonState;
  AVertical: Boolean; AFont: TFont; ATextColor, ABkColor: TColor; AShowPrefix: Boolean = False);
begin
end;

procedure TcxCustomLookAndFeelPainter.DrawTabBorder(ACanvas: TcxCanvas;
  R: TRect; ABorder: TcxBorder; ABorders: TcxBorders; AVertical: Boolean);
begin
end;

procedure TcxCustomLookAndFeelPainter.DrawTabsRoot(ACanvas: TcxCanvas;
  const R: TRect; ABorders: TcxBorders; AVertical: Boolean);
begin
end;

function TcxCustomLookAndFeelPainter.IsDrawTabImplemented(AVertical: Boolean): Boolean;
begin
  Result := False;
end;

function TcxCustomLookAndFeelPainter.IsTabHotTrack(AVertical: Boolean): Boolean;
begin
  Result := False;
end;

function TcxCustomLookAndFeelPainter.TabBorderSize(AVertical: Boolean): Integer;
begin
  Result := 0;
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledIndicatorItem(ACanvas: TcxCanvas; const R: TRect;
  AKind: TcxIndicatorKind; AColor: TColor; AScaleFactor: TdxScaleFactor; AIsRIghtToLeft: Boolean; AOnDrawBackground: TcxDrawBackgroundEvent = nil;
  ABorderWidth: Integer = 1);
begin
  DrawScaledIndicatorItem(ACanvas, R, R, AKind, AColor, AScaleFactor, AIsRIghtToLeft, AOnDrawBackground, [nTop, nBottom], ABorderWidth);
end;

procedure TcxCustomLookAndFeelPainter.DrawIndicatorItem(ACanvas: TcxCanvas;
  const R: TRect; AKind: TcxIndicatorKind; AColor: TColor; AOnDrawBackground: TcxDrawBackgroundEvent = nil);
begin
  DrawScaledIndicatorItem(ACanvas, R, AKind, AColor, dxSystemScaleFactor, False, AOnDrawBackground);
end;

procedure TcxCustomLookAndFeelPainter.DrawIndicatorItem(ACanvas: TcxCanvas; const R, AImageAreaBounds: TRect;
  AKind: TcxIndicatorKind; AColor: TColor; AOnDrawBackground: TcxDrawBackgroundEvent = nil);
begin
  DrawScaledIndicatorItem(ACanvas, R, AImageAreaBounds, AKind, AColor, dxSystemScaleFactor, False, AOnDrawBackground);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledIndicatorItem(ACanvas: TcxCanvas; const R, AImageAreaBounds: TRect;
  AKind: TcxIndicatorKind; AColor: TColor; AScaleFactor: TdxScaleFactor; AIsRIghtToLeft: Boolean; AOnDrawBackground: TcxDrawBackgroundEvent = nil;
  ANeighbors: TcxNeighbors = [nTop, nBottom]; ABorderWidth: Integer = 1);
begin
  if not TdxVisualRefinements.LightBorders then
    DrawScaledIndicatorItem(ACanvas, R, AImageAreaBounds, AKind, AColor, AScaleFactor, AOnDrawBackground, ANeighbors, True, AIsRightToLeft, ABorderWidth)
  else
    DrawScaledIndicatorItem(ACanvas, R, AImageAreaBounds, AKind, AColor, AScaleFactor, AOnDrawBackground, ANeighbors, False, AIsRightToLeft, ABorderWidth);
end;

procedure TcxCustomLookAndFeelPainter.DrawIndicatorItemEx(
  ACanvas: TcxCanvas; const R: TRect; AKind: TcxIndicatorKind;
  AColor: TColor; AOnDrawBackground: TcxDrawBackgroundEvent = nil);
begin
  DrawScaledIndicatorItemEx(ACanvas, R, AKind, AColor, dxSystemScaleFactor, False, AOnDrawBackground);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledIndicatorItem(
  ACanvas: TcxCanvas; const R, AImageAreaBounds: TRect;
  AKind: TcxIndicatorKind; AColor: TColor; AScaleFactor: TdxScaleFactor;
  AOnDrawBackground: TcxDrawBackgroundEvent; ANeighbors: TcxNeighbors;
  APaintLeftSide: Boolean; AIsRightToLeft: Boolean; ABorderWidth: Integer = 1);
begin
  DrawScaledHeader(ACanvas, R, R, [], HeaderBorders(ANeighbors), cxbsNormal,
    taLeftJustify, vaTop, False, False, '', nil, clNone, AColor, AScaleFactor, AOnDrawBackground, False, False, ABorderWidth);
  DrawScaledIndicatorImage(ACanvas, AImageAreaBounds, AKind, AScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledIndicatorItemEx(ACanvas: TcxCanvas; const R: TRect;
  AKind: TcxIndicatorKind; AColor: TColor; AScaleFactor: TdxScaleFactor; AIsRightToLeft: Boolean; AOnDrawBackground: TcxDrawBackgroundEvent = nil);
begin
  DrawScaledHeaderEx(ACanvas, R, R, [], cxBordersAll, cxbsNormal,
    taLeftJustify, vaTop, False, False, '', nil, clNone, AColor, AScaleFactor, AOnDrawBackground);
  DrawScaledIndicatorImage(ACanvas, R, AKind, AScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledIndicatorCustomizationMark(
  ACanvas: TcxCustomCanvas; const R: TRect; AColor: TColor; AScaleFactor: TdxScaleFactor);
const
  LineCount = 5;
  LineHeight = 1;
  LineOffset = 3;

  procedure DrawLine(X, Y, ALineWidth: Integer; AChecked: Boolean);
  var
    ASize: Integer;
  begin
    ASize := AScaleFactor.Apply(LineHeight);
    if AChecked then
      ACanvas.FillRect(cxRectBounds(X, Y, ASize, ASize), AColor);
    ACanvas.FillRect(cxRectBounds(X + ASize + AScaleFactor.Apply(1), Y, ALineWidth - ASize - AScaleFactor.Apply(1), ASize), AColor);
  end;

var
  ALineWidth: Integer;
  X, Y, I: Integer;
begin
  ALineWidth := R.Width - 2 * AScaleFactor.Apply(LineOffset);
  X := (R.Left + AScaleFactor.Apply(LineOffset));
  Y := (R.Top + R.Bottom - ((AScaleFactor.Apply(LineHeight) + 1) * LineCount - 1)) div 2;

  for I := 0 to LineCount - 1 do
  begin
    DrawLine(X, Y, ALineWidth, not Odd(I));
    Inc(Y, AScaleFactor.Apply(2));
  end;
end;

function TcxCustomLookAndFeelPainter.IncludeTopBorderToSectionHeaderForLightBorders: Boolean;
begin
  Result := False;
end;

function TcxCustomLookAndFeelPainter.IndicatorDrawItemsFirst: Boolean;
begin
  Result := True;
end;

function TcxCustomLookAndFeelPainter.ScaledScrollBarMinimalThumbSize(
  AVertical: Boolean; AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := AScaleFactor.Apply(cxStdThumbnailMinimalSize);
end;

function TcxCustomLookAndFeelPainter.ScrollBarMinimalThumbSize(AVertical: Boolean): Integer;
begin
  Result := ScaledScrollBarMinimalThumbSize(AVertical, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledScrollBarBackground(
  ACanvas: TcxCustomCanvas; const R: TRect; AHorizontal: Boolean; AScaleFactor: TdxScaleFactor);
begin
  DrawScaledScrollBarPart(ACanvas, AHorizontal, R, sbpPageUp, cxbsNormal, AScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScrollBarBackground(
  ACanvas: TcxCustomCanvas; const R: TRect; AHorizontal: Boolean);
begin
  DrawScaledScrollBarBackground(ACanvas, R, AHorizontal, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledScrollBarPart(ACanvas: TcxCustomCanvas; AHorizontal: Boolean;
  R: TRect; APart: TcxScrollBarPart; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
var
  ARealPart: TcxScrollBarPart;
begin
  ARealPart := APart;
  if AHorizontal and ACanvas.UseRightToLeftAlignment then
    case APart of
      sbpLineUp:
        ARealPart := sbpLineDown;
      sbpLineDown:
        ARealPart := sbpLineUp;
    end;
  DoDrawScaledScrollBarPart(ACanvas, AHorizontal, R, ARealPart, AState, AScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScrollBarPart(ACanvas: TcxCustomCanvas;
  AHorizontal: Boolean; R: TRect; APart: TcxScrollBarPart; AState: TcxButtonState);
begin
  DrawScaledScrollBarPart(ACanvas, AHorizontal, R, APart, AState, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScrollBarSplitter(ACanvas: TcxCustomCanvas; const R: TRect; AState: TcxButtonState);
begin
  DrawScaledScrollBarSplitter(ACanvas, R, AState, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledScrollBarSplitter(
  ACanvas: TcxCustomCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
begin
  DrawNavigatorScaledButton(ACanvas, R, AState, clDefault, AScaleFactor);
  DrawNavigatorBorder(ACanvas, R, False);
  DrawScaledSplitter(ACanvas, cxTextRect(R), AState = cxbsHot, AState = cxbsPressed, False, AScaleFactor);
end;

function TcxCustomLookAndFeelPainter.ScaledPopupPanelSize(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := 2 + dxGetSystemMetrics(SM_CYHSCROLL, AScaleFactor);
  Inc(Result);
  Result := Max(Max(Result, ScaledSizeGripSize(AScaleFactor).cy + 2 * 2), ScaledSmallCloseButtonSize(AScaleFactor).cy + 2 * 3);
end;

function TcxCustomLookAndFeelPainter.PopupPanelSize: Integer;
begin
  Result := ScaledPopupPanelSize(dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.CalculatePopupPanelClientRect(
  var AClientRect, APanelRect, AGripRect, ACloseButtonRect: TRect;
  ACorner: TdxCorner; const ABorders, APanelBorders: TRect;
  APanelHeight: Integer = 0; AShowCloseButton: Boolean = True; AShowGripSize: Boolean = True);
begin
  CalculateScaledPopupPanelClientRect(AClientRect, APanelRect, AGripRect, ACloseButtonRect, ACorner, ABorders,
    APanelBorders, dxSystemScaleFactor, APanelHeight, AShowCloseButton, AShowGripSize);
end;

procedure TcxCustomLookAndFeelPainter.CalculateScaledPopupPanelClientRect(
  var AClientRect, APanelRect, AGripRect, ACloseButtonRect: TRect;
  ACorner: TdxCorner; const ABorders, APanelBorders: TRect; AScaleFactor: TdxScaleFactor;
  APanelHeight: Integer = 0; AShowCloseButton: Boolean = True; AShowGripSize: Boolean = True);

  procedure CalculateClientRect;
  begin
    AClientRect := cxRectContent(AClientRect, ABorders);
    APanelRect := AClientRect;
    if ACorner in [coBottomLeft, coBottomRight] then
    begin
      APanelRect.Top := APanelRect.Bottom - APanelHeight;
      AClientRect.Bottom := APanelRect.Top;
    end
    else
    begin
      APanelRect.Bottom := APanelRect.Top + APanelHeight;
      AClientRect.Top := APanelRect.Bottom;
    end;
  end;

  procedure CalculateSizeGripRect;
  const
    AOffset = 2;
  var
    AGripSize: TSize;
  begin
    if AShowGripSize then
    begin
      AGripRect := APanelRect;
      AGripSize := ScaledSizeGripSize(AScaleFactor);
      if ACorner in [coTopRight, coBottomRight] then
      begin
        AGripRect.Right := AGripRect.Right - AOffset;
        AGripRect.Left := AGripRect.Right - AGripSize.cx;
      end
      else
      begin
        AGripRect.Left := AGripRect.Left + AOffset;
        AGripRect.Right := AGripRect.Left + AGripSize.cx;
      end;
      if ACorner in [coBottomLeft, coBottomRight] then
      begin
        AGripRect.Bottom := AGripRect.Bottom - AOffset;
        AGripRect.Top := AGripRect.Bottom - AGripSize.cy;
      end
      else
      begin
        AGripRect.Top := AGripRect.Top + AOffset;
        AGripRect.Bottom := AGripRect.Top + AGripSize.cy;
      end;
    end
    else
      AGripRect := cxNullRect;
  end;

  procedure CalculateCloseButtonRect;
  begin
    if AShowCloseButton then
    begin
      ACloseButtonRect := cxRectContent(APanelRect, APanelBorders);
        if ACorner in [coTopRight, coBottomRight] then
          ACloseButtonRect.Right := ACloseButtonRect.Left + ACloseButtonRect.Height
        else
          ACloseButtonRect.Left := ACloseButtonRect.Right - ACloseButtonRect.Height;
      ACloseButtonRect := cxRectCenter(ACloseButtonRect, ScaledSmallCloseButtonSize(AScaleFactor));
    end
    else
      ACloseButtonRect := cxNullRect;
  end;

begin
  if APanelHeight = 0 then
    APanelHeight := ScaledPopupPanelSize(AScaleFactor);
  CalculateClientRect;
  CalculateSizeGripRect;
  CalculateCloseButtonRect;
end;

procedure TcxCustomLookAndFeelPainter.DrawPopupNCPanel(AHandle: HWND;
  AMouseAboveCloseButton, ACloseButtonIsTracking: Boolean; ACorner: TdxCorner;
  ACloseButtonRect, AGripRect: TRect; ABorderColor: TColor);
begin
  DrawScaledPopupNCPanel(AHandle, AMouseAboveCloseButton, ACloseButtonIsTracking,
    ACorner, ACloseButtonRect, AGripRect, ABorderColor, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledPopupNCPanel(
  AHandle: HWND; AMouseAboveCloseButton, ACloseButtonIsTracking: Boolean;
  ACorner: TdxCorner; ACloseButtonRect, AGripRect: TRect; ABorderColor: TColor; AScaleFactor: TdxScaleFactor);
var
  AWindowRect, AWindowBounds, ABandBounds: TRect;
  ABorderSize: Integer;
  ADC: HDC;

  procedure CalculateBounds;
  var
    AClientRect, AClientBounds: TRect;
  begin
    AWindowRect := cxGetWindowRect(AHandle);
    AClientRect := cxGetClientRect(AHandle);

    AWindowBounds := AWindowRect;
    OffsetRect(AWindowBounds, -AWindowRect.Left, -AWindowRect.Top);

    AClientBounds := AClientRect;
    MapWindowPoints(AHandle, 0, AClientBounds, 2);
    OffsetRect(AClientBounds, -AWindowRect.Left, -AWindowRect.Top);

    ABorderSize := AClientBounds.Left;

    ABandBounds := cxRectInflate(AWindowBounds, -ABorderSize, -ABorderSize);
    if ACorner in [coBottomLeft, coBottomRight] then
      ABandBounds.Top := AClientBounds.Bottom
    else
      ABandBounds.Bottom := AClientBounds.Top;

    OffsetRect(ACloseButtonRect, -AWindowRect.Left, -AWindowRect.Top);
    OffsetRect(AGripRect, -AWindowRect.Left, -AWindowRect.Top);
  end;

  function GetBorders: TRect;
  begin
    Result := cxEmptyRect;
    if ACorner in [coBottomLeft, coBottomRight] then
      Result.Top := 1
    else
      Result.Bottom := 1;
  end;

  function GetButtonState: TcxButtonState;
  begin
    if AMouseAboveCloseButton and ACloseButtonIsTracking then
      Result := cxbsPressed
    else
      if AMouseAboveCloseButton or ACloseButtonIsTracking then
        Result := cxbsHot
      else
        Result := cxbsNormal;
  end;

begin
  ADC := GetWindowDC(AHandle);
  cxPaintCanvas.BeginPaint(ADC);
  try
    CalculateBounds;
    cxPaintCanvas.FrameRect(AWindowBounds, ABorderColor, ABorderSize);
    DrawScaledPopupPanelBand(cxPaintCanvas, ABandBounds, AGripRect, ACloseButtonRect,
      ACorner, GetButtonState, GetBorders, ABorderColor, AScaleFactor);
  finally
    cxPaintCanvas.EndPaint;
    ReleaseDC(AHandle, ADC);
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawPopupPanelBand(
  ACanvas: TcxCanvas; const ABounds, AGripRect, ACloseButtonRect: TRect; AGripCorner: TdxCorner;
  ACloseButtonState: TcxButtonState; ABorders: TRect; ABorderColor: TColor; AShowGripSize: Boolean; AShowCloseButton: Boolean);
begin
  DrawScaledPopupPanelBand(ACanvas, ABounds, AGripRect, ACloseButtonRect, AGripCorner,
    ACloseButtonState, ABorders, ABorderColor, dxSystemScaleFactor, AShowGripSize, AShowCloseButton);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledPopupPanelBand(
  ACanvas: TcxCanvas; const ABounds, AGripRect, ACloseButtonRect: TRect; AGripCorner: TdxCorner;
  ACloseButtonState: TcxButtonState; ABorders: TRect; ABorderColor: TColor; AScaleFactor: TdxScaleFactor;
  AShowGripSize: Boolean = True; AShowCloseButton: Boolean = True);
var
  ABitmap: TcxBitmap;
begin
  ACanvas.SaveClipRegion;
  ACanvas.ExcludeClipRect(cxRectContent(ABounds, ABorders));
  ACanvas.FillRect(ABounds, ABorderColor);
  ACanvas.RestoreClipRegion;

  if AShowGripSize then
  begin
    ABitmap := TcxBitmap.CreateSize(AGripRect);
    try
      DrawWindowContent(ABitmap.cxCanvas, ABitmap.ClientRect);
      DrawScaledSizeGrip(ABitmap.cxCanvas, ABitmap.ClientRect, AScaleFactor, clNone, AGripCorner);
      TdxImageDrawer.DrawBitmap(ACanvas.Handle, ABitmap, AGripRect, cxNullPoint);
    finally
      ABitmap.Free;
    end;
    ACanvas.ExcludeClipRect(AGripRect);
  end;

  if AShowCloseButton then
  begin
    DrawWindowContent(ACanvas, ACloseButtonRect);
    DrawScaledSmallCloseButton(ACanvas, ACloseButtonRect, ACloseButtonState, AScaleFactor);
    ACanvas.ExcludeClipRect(ACloseButtonRect);
  end;

  DrawWindowContent(ACanvas, cxRectContent(ABounds, ABorders));
  ACanvas.ExcludeClipRect(ABounds);
end;

function TcxCustomLookAndFeelPainter.ScaledSizeGripSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  Result := Size(dxGetSystemMetrics(SM_CXVSCROLL, AScaleFactor), dxGetSystemMetrics(SM_CYHSCROLL, AScaleFactor));
end;

function TcxCustomLookAndFeelPainter.SizeGripSize: TSize;
begin
  Result := ScaledSizeGripSize(dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DoDrawSizeGrip(ACanvas: TcxCanvas; const ARect: TRect);
begin
  DoDrawSizeGrip(ACanvas, ARect, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DoDrawSizeGrip(ACanvas: TcxCanvas; const ARect: TRect; AScaleFactor: TdxScaleFactor);
begin
  DrawFrameControl(ACanvas.Handle, ARect, DFC_SCROLL, DFCS_SCROLLSIZEGRIP);
end;

procedure TcxCustomLookAndFeelPainter.DrawSizeGrip(ACanvas: TcxCanvas;
  const ARect: TRect; ABackgroundColor: TColor; ACorner: TdxCorner);
begin
  DrawScaledSizeGrip(ACanvas, ARect, dxSystemScaleFactor, ABackgroundColor, ACorner);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledSizeGrip(ACanvas: TcxCanvas; const ARect: TRect;
  AScaleFactor: TdxScaleFactor; ABackgroundColor: TColor = clDefault; ACorner: TdxCorner = coBottomRight);
begin
  dxRotateSizeGrip(ACanvas, ARect, AScaleFactor, ABackgroundColor, ACorner, DoDrawSizeGrip);
end;

function TcxCustomLookAndFeelPainter.SliderButtonSize(ADirection: TcxArrowDirection): TSize;
begin
  Result := ScaledSliderButtonSize(ADirection, dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.ScaledSliderButtonSize(ADirection: TcxArrowDirection; AScaleFactor: TdxScaleFactor): TSize;
begin
  Result := ScaledSizeGripSize(AScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledSliderButton(ACanvas: TcxCustomCanvas; const ARect: TRect;
  ADirection: TcxArrowDirection; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
const
  APart: array[Boolean] of TcxScrollBarPart = (sbpLineUp, sbpLineDown);
begin
  DrawScaledScrollBarPart(ACanvas, ADirection in [adLeft, adRight], ARect, APart[ADirection in [adRight, adDown]], AState, AScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawSliderButton(ACanvas: TcxCustomCanvas;
  const ARect: TRect; ADirection: TcxArrowDirection; AState: TcxButtonState);
begin
  DrawScaledSliderButton(ACanvas, ARect, ADirection, AState, dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.GetSmallButtonColorPalette(AState: TcxButtonState): IdxColorPalette;
begin
  Result := nil;
end;

function TcxCustomLookAndFeelPainter.GetSmartTagGlyph: TdxSmartImage;
begin
  if FSmartTagGlyph = nil then
  begin
    FSmartTagGlyph := TdxSmartImage.Create;
    FSmartTagGlyph.LoadFromResource(HInstance, 'CX_SMARTTAG', 'SVG');
  end;
  Result := FSmartTagGlyph;
end;

function TcxCustomLookAndFeelPainter.ScaledSmallCloseButtonSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  Result := AScaleFactor.Apply(DoGetSmallCloseButtonSize);
  dxAdjustToTouchableSize(Result);
end;

function TcxCustomLookAndFeelPainter.SmallCloseButtonSize: TSize;
begin
  Result := ScaledSmallCloseButtonSize(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.DoGetSmallCloseButtonSize: TSize;
begin
  Result.Init(FilterCloseButtonHeight, FilterCloseButtonHeight + 1);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledSmallButton(
  ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
begin
  DrawButtonBorder(ACanvas, R, AState);
  InflateRect(R, -ButtonBorderSize, -ButtonBorderSize);
  ACanvas.Brush.Color := ButtonColor(AState);
  ACanvas.FillRect(R);
end;

procedure TcxCustomLookAndFeelPainter.DrawSmallButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState);
begin
  DrawScaledSmallButton(ACanvas, R, AState, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledSmallCloseButton(
  ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
begin
  DrawScaledFilterCloseButton(ACanvas, R, AState, AScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawSmallCloseButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState);
begin
  DrawScaledSmallCloseButton(ACanvas, R, AState, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledMonthHeader(ACanvas: TcxCanvas; const ABounds: TRect;
  const AText: string; ANeighbors: TcxNeighbors; const AViewParams: TcxViewParams; AArrows: TcxArrowDirections;
  ASideWidth: Integer; AScaleFactor: TdxScaleFactor; AOnDrawBackground: TcxDrawBackgroundEvent = nil);
begin
  DrawScaledHeader(ACanvas, ABounds, ABounds, ANeighbors, SchedulerHeaderBorders(ANeighbors),
    cxbsNormal, taCenter, vaCenter, False, False, AText, AViewParams.Font,
    AViewParams.TextColor, AViewParams.Color, AScaleFactor, AOnDrawBackground);
  DrawMonthHeaderArrows(ACanvas, ABounds, AArrows, ASideWidth, clWindowText);
end;

procedure TcxCustomLookAndFeelPainter.DrawMonthHeader(ACanvas: TcxCanvas;
  const ABounds: TRect; const AText: string; ANeighbors: TcxNeighbors;
  const AViewParams: TcxViewParams; AArrows: TcxArrowDirections;
  ASideWidth: Integer; AOnDrawBackground: TcxDrawBackgroundEvent = nil);
begin
  DrawScaledMonthHeader(ACanvas, ABounds, AText, ANeighbors, AViewParams, AArrows, ASideWidth, dxSystemScaleFactor, AOnDrawBackground);
end;

procedure TcxCustomLookAndFeelPainter.CalculateSchedulerNavigationButtonRects(AIsNextButton: Boolean;
  ACollapsed: Boolean; APrevButtonTextSize: TSize; ANextButtonTextSize: TSize; var ABounds: TRect;
  out ATextRect: TRect; out AArrowRect: TRect; AScaleFactor: TdxScaleFactor; const AIsVertical: Boolean = True);
const
  cxTextOffset = 5;
var
  AArrowSize: TSize;
  AArrowZoneLength: Integer;
  ABorders: TRect;
  AContent: TRect;
  ADelta: Integer;
  AHasTextArea: Boolean;
  R: TRect;
begin
  SchedulerNavigationButtonSizes(AIsNextButton, ABorders, AArrowSize, AHasTextArea, AScaleFactor, AIsVertical);
  if AIsVertical then
  begin
    AArrowZoneLength := 3 * AArrowSize.Height;
    if ACollapsed or not AHasTextArea then
    begin
      ATextRect := cxNullRect;
      ABounds.Top := (cxMarginsHeight(ABounds) - cxMarginsHeight(ABorders) - AArrowZoneLength) div 2;
      ABounds.Bottom := ABounds.Top + AArrowZoneLength + cxMarginsHeight(ABorders);
      AArrowRect := cxRectCenter(ABounds, AArrowSize);
    end
    else
    begin
      AContent := cxRectContent(ABounds, ABorders);
      AArrowRect := cxRectCenter(cxRectSetHeight(AContent, AArrowZoneLength), AArrowSize);
      ATextRect := AContent;
      Inc(ATextRect.Top, AArrowZoneLength + AScaleFactor.Apply(cxTextOffset));
      Dec(ATextRect.Bottom, 2 * AArrowSize.Height);
      ADelta := Max(ANextButtonTextSize.Width, APrevButtonTextSize.Width) - ATextRect.Height;
      if ADelta > 0 then
      begin
        OffsetRect(AArrowRect, 0, -ADelta);
        InflateRect(ATextRect, 0, ADelta);
        InflateRect(ABounds, 0, ADelta);
      end;
    end;
  end
  else
  begin
    AArrowZoneLength := 3 * AArrowSize.Width;
    if ACollapsed or not AHasTextArea then
    begin
      ATextRect := cxNullRect;
      ABounds.Left := (cxMarginsWidth(ABounds) - cxMarginsWidth(ABorders) - AArrowZoneLength) div 2;
      ABounds.Right := ABounds.Left + AArrowZoneLength + cxMarginsWidth(ABorders);
      AArrowRect := cxRectCenter(ABounds, AArrowSize);
    end
    else
    begin
      AContent := cxRectContent(ABounds, ABorders);
      R := cxRectSetWidth(AContent, AArrowZoneLength);
      AArrowRect := cxRectCenter(cxRectOffsetHorz(R, AContent.Right - R.Right), AArrowSize);
      ATextRect := AContent;
      if AIsNextButton then
      begin
        if ATextRect.Height < ANextButtonTextSize.Height then
          ATextRect := cxRectCenter(ATextRect, ATextRect.Width, ANextButtonTextSize.Height);
      end
      else
        if ATextRect.Height < APrevButtonTextSize.Height then
          ATextRect := cxRectCenter(ATextRect, ATextRect.Width, APrevButtonTextSize.Height);
      Inc(ATextRect.Left, 2 * AArrowSize.Width);
      Dec(ATextRect.Right, AArrowZoneLength + AScaleFactor.Apply(cxTextOffset));
      ADelta := Max(ANextButtonTextSize.Width, APrevButtonTextSize.Width) - ATextRect.Width;
      if ADelta > 0 then
      begin
        OffsetRect(AArrowRect, ADelta, 0);
        InflateRect(ATextRect, ADelta, 0);
        InflateRect(ABounds, ADelta, 0);
      end;
    end;
  end
end;

procedure TcxCustomLookAndFeelPainter.CalculateSchedulerNavigationButtonRects(AIsNextButton, ACollapsed: Boolean;
  APrevButtonTextSize, ANextButtonTextSize: TSize; var ABounds: TRect; out ATextRect, AArrowRect: TRect;
  const AIsVertical: Boolean = True);
begin
  CalculateSchedulerNavigationButtonRects(AIsNextButton, ACollapsed, APrevButtonTextSize, ANextButtonTextSize,
    ABounds, ATextRect, AArrowRect, dxSystemScaleFactor, AIsVertical);
end;

procedure TcxCustomLookAndFeelPainter.DrawSchedulerBorder(ACanvas: TcxCanvas; R: TRect);
begin
  DrawBorder(ACanvas, R);
end;

procedure TcxCustomLookAndFeelPainter.DrawSchedulerDayHeader(ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect;
  ANeighbors: TcxNeighbors; ABorders: TcxBorders; AState: TcxButtonState;
  AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert; AMultiLine, AShowEndEllipsis: Boolean;
  const AText: string; AFont: TFont; ATextColor, ABkColor: TColor;
  AScaleFactor: TdxScaleFactor; AOnDrawBackground: TcxDrawBackgroundEvent = nil;
  AIsLast: Boolean = False; AIsGroup: Boolean = False);
begin
  AOnDrawBackground(ACanvas, ABounds);
end;

procedure TcxCustomLookAndFeelPainter.DrawSchedulerEventProgress(
  ACanvas: TcxCanvas; const ABounds, AProgress: TRect; AViewParams: TcxViewParams; ATransparent: Boolean);
begin
  DrawSchedulerScaledEventProgress(ACanvas, ABounds, AProgress, AViewParams, ATransparent, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawSchedulerScaledEventProgress(ACanvas: TcxCanvas;
  const ABounds, AProgress: TRect; AViewParams: TcxViewParams; ATransparent: Boolean; AScaleFactor: TdxScaleFactor);
begin
  if ATransparent then
    ACanvas.FrameRect(ABounds, clGray)
  else
    ACanvas.Rectangle(ABounds, AViewParams, cxBordersAll, clGray);

  ACanvas.FillRect(AProgress, clNavy);
end;

procedure TcxCustomLookAndFeelPainter.DrawSchedulerGroup(
  ACanvas: TcxCanvas; const R: TRect; AColor: TColor = clDefault);
var
  APoints: TPoints;
begin
  APoints := cxGetSchedulerGroupPolygon(R);
  try
    ACanvas.Pen.Color := clBlack;
    ACanvas.SetBrushColor(AColor);
    ACanvas.Polygon(APoints);
  finally
    SetLength(APoints, 0);
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawSchedulerGroupSeparator(
  ACanvas: TcxCanvas; const ABounds: TRect; ABackgroundColor: TColor; AOnDrawBackground: TcxDrawBackgroundEvent);
begin
  DrawSchedulerScaledGroupSeparator(ACanvas, ABounds, ABackgroundColor, dxSystemScaleFactor, AOnDrawBackground);
end;

procedure TcxCustomLookAndFeelPainter.DrawSchedulerScaledGroupSeparator(ACanvas: TcxCanvas; const ABounds: TRect;
  ABackgroundColor: TColor; AScaleFactor: TdxScaleFactor; AOnDrawBackground: TcxDrawBackgroundEvent = nil);
begin
  DrawScaledHeader(ACanvas, ABounds, ABounds, [nRight, nLeft], cxBordersAll, cxbsNormal,
    taLeftJustify, vaCenter, False, False, '', nil, clNone, ABackgroundColor, AScaleFactor, AOnDrawBackground);
end;

procedure TcxCustomLookAndFeelPainter.DrawSchedulerMilestone(ACanvas: TcxCanvas; const R: TRect);
var
  APoints: TPoints;
begin
  APoints := cxGetSchedulerMilestonePolygon(R);
  try
    ACanvas.Pen.Color := clBlack;
    ACanvas.SetBrushColor(clGray);
    ACanvas.Polygon(APoints);
  finally
    SetLength(APoints, 0);
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawSchedulerNavigationButton(
  ACanvas: TcxCanvas; const ARect: TRect; AIsNextButton: Boolean;
  AState: TcxButtonState; const AText: string; const ATextRect: TRect;
  const AArrowRect: TRect; const AIsVertical: Boolean = True);
const
  AAngle: array[Boolean] of TcxRotationAngle = (ra0, raPlus90);
begin
  DrawSchedulerNavigationButtonContent(ACanvas, ARect, AArrowRect, AIsNextButton, AState, AIsVertical);
  if not IsRectEmpty(ATextRect) and (SchedulerNavigationButtonTextColor(AIsNextButton, AState, clDefault) <> clNone) then
    cxDrawText(ACanvas, AText, ATextRect, DT_CENTER or DT_VCENTER or DT_SINGLELINE,
      SchedulerNavigationButtonTextColor(AIsNextButton, AState, ACanvas.Font.Color), AAngle[AIsVertical]);
end;

procedure TcxCustomLookAndFeelPainter.DrawSchedulerNavigationButtonArrow(ACanvas: TcxCanvas; const ARect: TRect;
  AIsNextButton: Boolean; AColor: TColor; const AForVertical: Boolean);
const
  ASigns: array[Boolean] of Integer = (-1, 1);
var
  ACount: Integer;
  I: Integer;
  R1, R2: TRect;
begin
  ACanvas.Brush.Color := AColor;
  if AForVertical then
  begin
    ACount := ARect.Height div 2 + Integer(Odd(ARect.Height));
    if AIsNextButton then
    begin
      R1.Init(ARect.Left, ARect.Top, ARect.Left + 2, ARect.Top + 1);
      R2.Init(ARect.Left, ARect.Bottom - 1, ARect.Left + 2, ARect.Bottom);
    end
    else
    begin
      R1.Init(ARect.Right - 2, ARect.Top, ARect.Right, ARect.Top + 1);
      R2.Init(ARect.Right - 2, ARect.Bottom - 1, ARect.Right, ARect.Bottom);
    end;

    for I := 0 to ACount - 1 do
    begin
      ACanvas.FillRect(R1);
      R1.Offset(ASigns[AIsNextButton], 1);
      ACanvas.FillRect(R2);
      R2.Offset(ASigns[AIsNextButton], -1);
    end;

    if AIsNextButton then
      ACanvas.FillRect(cxRectSetLeft(ARect, ARect.Right - 1, 1))
    else
      ACanvas.FillRect(cxRectSetRight(ARect, ARect.Left + 1, 1));
  end
  else
  begin
    ACount := ARect.Width div 2 + Integer(Odd(ARect.Width));
    if AIsNextButton then
    begin
      R1.Init(ARect.Left, ARect.Top, ARect.Left + 1, ARect.Top + 2);
      R2.Init(ARect.Right - 1, ARect.Top, ARect.Right, ARect.Top + 2);
    end
    else
    begin
      R1.Init(ARect.Left, ARect.Bottom - 2, ARect.Left + 1, ARect.Bottom);
      R2.Init(ARect.Right - 1, ARect.Bottom - 2, ARect.Right, ARect.Bottom);
    end;

    for I := 0 to ACount - 1 do
    begin
      ACanvas.FillRect(R1);
      R1.Offset(1, ASigns[AIsNextButton]);
      ACanvas.FillRect(R2);
      R2.Offset(-1, ASigns[AIsNextButton]);
    end;

    if AIsNextButton then
      ACanvas.FillRect(cxRectSetBottom(ARect, ARect.Bottom, 1))
    else
      ACanvas.FillRect(cxRectSetTop(ARect, ARect.Top, 1));
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawSchedulerNavigationButtonContent(
  ACanvas: TcxCanvas; const ARect: TRect; const AArrowRect: TRect;
  AIsNextButton: Boolean; AState: TcxButtonState; const AIsVertical: Boolean = True);
const
  Borders: array[Boolean, Boolean] of TcxBorders = (
    ([bLeft, bRight, bBottom], [bLeft, bTop, bRight]),
    ([bRight, bTop, bBottom], [bLeft, bTop, bBottom]) );
  BottomRightColors: array[Boolean] of TColor =
    (clBtnFace, clBtnHighlight);
  TopLeftColors: array[Boolean] of TColor =
    (clBtnHighlight, clBtnShadow);
var
  R: TRect;
begin
  R := ARect;
  ACanvas.FillRect(R, clBtnFace);
  ACanvas.DrawComplexFrame(R, clBtnShadow, clBtnShadow, Borders[AIsVertical, AIsNextButton]);
  if AIsVertical then
  begin
    R.Inflate(0, -1);
    if AIsNextButton then
      Inc(R.Left)
    else
      Dec(R.Right);
  end
  else
  begin
    R.Inflate(-1, 0);
    if AIsNextButton then
      Inc(R.Top)
    else
      Dec(R.Bottom);
  end;
  ACanvas.DrawComplexFrame(R, TopLeftColors[AState = cxbsPressed],
    BottomRightColors[AState = cxbsPressed], Borders[AIsVertical, AIsNextButton]);
  DrawSchedulerNavigationButtonArrow(ACanvas, AArrowRect, AIsNextButton,
    ButtonSymbolColor(AState), AIsVertical);
end;

procedure TcxCustomLookAndFeelPainter.DrawSchedulerNavigatorButton(
  ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState);
begin
  DrawSchedulerScaledNavigatorButton(ACanvas, R, AState, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawSchedulerScaledNavigatorButton(
  ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
begin
  DrawScaledButton(ACanvas, R, AState, AScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawSchedulerSplitterBorder(
  ACanvas: TcxCanvas; R: TRect; const AViewParams: TcxViewParams; AIsHorizontal: Boolean);
begin
end;

procedure TcxCustomLookAndFeelPainter.DrawSchedulerTaskExpandButton(
  ACanvas: TcxCanvas; R: TRect; AExpanded: Boolean; AScaleFactor: TdxScaleFactor);
begin
  DrawScaledExpandButton(ACanvas, R, AExpanded, AScaleFactor);
end;

function TcxCustomLookAndFeelPainter.SchedulerNavigationButtonTextColor(
  AIsNextButton: Boolean; AState: TcxButtonState; ADefaultColor: TColor = clDefault): TColor;
begin
  Result := ButtonSymbolColor(AState, ADefaultColor);
end;

procedure TcxCustomLookAndFeelPainter.SchedulerNavigationButtonSizes(
  AIsNextButton: Boolean; var ABorders: TRect; var AArrowSize: TSize;
  var AHasTextArea: Boolean; AScaleFactor: TdxScaleFactor; const AIsVertical: Boolean = True);
const
  AButtonBorders: array[Boolean, Boolean] of TRect = (
    ((Left: 6; Top: 0; Right: 6; Bottom: 2), (Left: 6; Top: 2; Right: 6; Bottom: 0)),
    ((Left: 0; Top: 6; Right: 2; Bottom: 6), (Left: 2; Top: 6; Right: 0; Bottom: 6)) );
begin
  ABorders := AButtonBorders[AIsVertical, AIsNextButton];
  AHasTextArea := True;
  AArrowSize.cx := AScaleFactor.Apply(7);
  AArrowSize.cy := AScaleFactor.Apply(7);
end;

procedure TcxCustomLookAndFeelPainter.SchedulerNavigationButtonSizes(AIsNextButton: Boolean; var ABorders: TRect;
  var AArrowSize: TSize; var AHasTextArea: Boolean; const AIsVertical: Boolean = True);
begin
  SchedulerNavigationButtonSizes(AIsNextButton, ABorders, AArrowSize, AHasTextArea, dxSystemScaleFactor, AIsVertical);
end;

function TcxCustomLookAndFeelPainter.SchedulerTaskExpandButtonSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  Result.cx := ScaledExpandButtonSize(AScaleFactor);
  Result.cy := Result.cx;
end;

function TcxCustomLookAndFeelPainter.SchedulerEventProgressOffsets: TRect;
begin
  Result := Rect(2, 2, 2, 2);
end;

function TcxCustomLookAndFeelPainter.SchedulerHeaderBorders(
  ANeighbors: TcxNeighbors): TcxBorders;
begin
  if TdxVisualRefinements.LightBorders then
  begin
    Result := cxBordersAll;
    if nLeft in ANeighbors then
      Exclude(Result, bLeft);
    if nTop in ANeighbors then
      Exclude(Result, bTop);
    if nRight in ANeighbors then
      Exclude(Result, bRight);
    if nBottom in ANeighbors then
      Exclude(Result, bBottom);
  end
  else
    Result := HeaderBorders(ANeighbors);
end;

function TcxCustomLookAndFeelPainter.ChartToolBoxDataLevelInfoBorderSize: Integer;
begin
  Result := 1;
end;

function TcxCustomLookAndFeelPainter.DefaultDataRowLayoutContentTextColor(AState: TcxButtonState): TColor;
begin
  Result := DefaultLayoutViewContentTextColor(AState);
end;

procedure TcxCustomLookAndFeelPainter.DrawDataRowLayoutContent(ACanvas: TcxCanvas; const ABounds: TRect);
var
  ARect: TRect;
begin
  ACanvas.SaveClipRegion;
  try
    ACanvas.IntersectClipRect(ABounds);
    ARect := cxRectInflate(ABounds, GetDataRowLayoutContentMargins);
    DoDrawDataRowLayoutContent(ACanvas, ARect);
  finally
    ACanvas.RestoreClipRegion;
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawDataRowLayoutItem(ACanvas: TcxCanvas; const ABounds: TRect; AState: TcxButtonState);
begin
  DrawDataRowLayoutItemScaled(ACanvas, ABounds, AState, dxDefaultScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawDataRowLayoutItemScaled(ACanvas: TcxCanvas;
  const ABounds: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
begin
  LayoutViewDrawItemScaled(ACanvas, ABounds, AState, AScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawDataRowLayoutSelection(ACanvas: TcxCanvas; const ABounds: TRect; AState: TcxButtonState);
begin
  DrawDataRowLayoutSelectionScaled(ACanvas, ABounds, AState, dxDefaultScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawDataRowLayoutSelectionScaled(ACanvas: TcxCanvas; const ABounds: TRect;
  AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
var
  ARect: TRect;
begin
  ACanvas.SaveClipRegion;
  try
    ACanvas.IntersectClipRect(ABounds);
    ARect := cxRectInflate(ABounds, GetDataRowLayoutItemMargins(AState));
    DrawDataRowLayoutItemScaled(ACanvas, ARect, AState, AScaleFactor);
  finally
    ACanvas.RestoreClipRegion;
  end;
end;

function TcxCustomLookAndFeelPainter.ScaledClockSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  Result.Init(AScaleFactor.Apply(130));
end;

function TcxCustomLookAndFeelPainter.ClockSize: TSize;
begin
  Result := ScaledClockSize(dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawClock(ACanvas: TcxCanvas;
  const ARect: TRect; ADateTime: TDateTime; ABackgroundColor: TColor);
begin
  DrawScaledClock(ACanvas, ARect, ADateTime, ABackgroundColor, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledClock(ACanvas: TcxCanvas; const ARect: TRect;
  ADateTime: TDateTime; ABackgroundColor: TColor; AScaleFactor: TdxScaleFactor);

  procedure DrawDot(X, Y: Integer; AHourDot: Boolean);
  var
    R: TRect;
  begin
    if AHourDot then
    begin
      R := cxRectCenter(cxRectBounds(X, Y, 0, 0), TSize.Create(AScaleFactor.Apply(2)));
      ACanvas.FillRect(R, clAqua);
      ACanvas.ExcludeClipRect(R);
      R.Offset(1, 1);
      ACanvas.FillRect(R, clBtnText);
      ACanvas.ExcludeClipRect(R);
    end;
  end;

  procedure DrawHand(ACenter: TPoint; AAngle, L1X, L1Y, L2X, L2Y, L3: Extended);
  begin
    with ACanvas.Canvas do
    begin
      Brush.Color := clTeal;
      BeginPath(Handle);
      Pixels[Round(ACenter.X + L1X * Cos(AAngle)), Round(ACenter.Y + L1Y * Sin(AAngle))] := clTeal;
      Pen.Color := clTeal;
      MoveTo(Round(ACenter.X + L1X * Cos(AAngle)), Round(ACenter.Y + L1Y * Sin(AAngle)));
      LineTo(Round(ACenter.X + L3 / 2 * cos(AAngle + Pi / 2)), Round(ACenter.Y + L3 / 2 * sin(AAngle + Pi / 2)));
      LineTo(Round(ACenter.X + L2X * cos(AAngle + Pi)), Round(ACenter.Y + L2Y * sin(AAngle + Pi)));
      LineTo(Round(ACenter.X + L3 / 2 * cos(AAngle + Pi * 3 / 2)), Round(ACenter.Y + L3 / 2 * sin(AAngle + Pi * 3 / 2)));
      LineTo(Round(ACenter.X + L1X * cos(AAngle)), Round(ACenter.Y + L1Y * sin(AAngle)));
      EndPath(Handle);
      FillPath(Handle);
    end;
  end;

  procedure DrawHands;
  var
    AAngle: Extended;
    ACenter: TPoint;
    AHandRadiusX, AHandRadiusY: Extended;
    AHour, AMin, AMSec, ASec: Word;
  begin
    DecodeTime(ADateTime, AHour, AMin, ASec, AMSec);
    ACenter.X := (ARect.Right + ARect.Left) div 2;
    ACenter.Y := (ARect.Bottom + ARect.Top) div 2;
    AHandRadiusX := ARect.Width / 2 - 2;
    AHandRadiusY := ARect.Height / 2 - 2;
    with ACanvas.Canvas do
    begin
      AAngle := Pi * 2 * ((AHour mod 12) * 60 * 60 + AMin * 60 + ASec - 3 * 60 * 60) / 12 / 60 / 60;
      DrawHand(ACenter, AAngle, AHandRadiusX * 0.75, AHandRadiusY * 0.75, AHandRadiusX * 0.15, AHandRadiusY * 0.15, 9);

      AAngle := Pi * 2 * (AMin * 60 + ASec - 15 * 60) / 60 / 60;
      DrawHand(ACenter, AAngle, AHandRadiusX * 0.85, AHandRadiusY * 0.85, AHandRadiusX * 0.2, AHandRadiusY * 0.2, 7);

      Pen.Color := clRed;
      MoveTo(ACenter.X, ACenter.Y);
      AAngle := Pi * 2 * (ASec - 15) / 60;
      LineTo(Round(ACenter.X + AHandRadiusX * 0.9 * cos(AAngle)), Round(ACenter.Y + AHandRadiusY * 0.9 * sin(AAngle)));
    end;
  end;

var
  AAngle: Extended;
  ACenter: TPoint;
  I: Integer;
  RX, RY: Extended;
begin
  ACenter.X := (ARect.Right + ARect.Left) div 2;
  ACenter.Y := (ARect.Bottom + ARect.Top) div 2;
  RX := ARect.Width / 2 - 2;
  RY := ARect.Height / 2 - 2;
  for I := 0 to 59 do
  begin
    AAngle := 2 * Pi * I / 60;
    DrawDot(Round(ACenter.X + RX * cos(AAngle)), Round(ACenter.Y + RY * sin(AAngle)), I mod 5 = 0);
  end;
  ACanvas.FillRect(ARect, ABackgroundColor);
  DrawHands;
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledEditorButton(ACanvas: TcxCanvas; const ARect: TRect;
  AButtonKind: TcxEditBtnKind; AState: TcxButtonState; AScaleFactor: TdxScaleFactor; APosition: TcxEditBtnPosition);
begin
  // do nothing
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledEditorButtonGlyph(ACanvas: TcxCanvas; const ARect: TRect;
  AButtonKind: TcxEditBtnKind; AState: TcxButtonState; AScaleFactor: TdxScaleFactor; APosition: TcxEditBtnPosition);
begin
  // do nothing
end;

procedure TcxCustomLookAndFeelPainter.DrawEditorButton(
  ACanvas: TcxCanvas; const ARect: TRect; AButtonKind: TcxEditBtnKind;
  AState: TcxButtonState; APosition: TcxEditBtnPosition = cxbpRight);
begin
  DrawScaledEditorButton(ACanvas, ARect, AButtonKind, AState, dxSystemScaleFactor, APosition);
end;

procedure TcxCustomLookAndFeelPainter.DrawEditorButtonGlyph(
  ACanvas: TcxCanvas; const ARect: TRect; AButtonKind: TcxEditBtnKind;
  AState: TcxButtonState; APosition: TcxEditBtnPosition = cxbpRight);
begin
  DrawScaledEditorButtonGlyph(ACanvas, ARect, AButtonKind, AState, dxSystemScaleFactor, APosition);
end;

procedure TcxCustomLookAndFeelPainter.DrawFocusRect(ACanvas: TcxCanvas; const ARect: TRect; AScaleFactor: TdxScaleFactor = nil);
var
  ASaveBkColor, ASaveTextColor: COLORREF;
  ADC: HDC;
begin
  if ARect.IsEmpty then
    Exit;
  ADC := ACanvas.Handle;
  ASaveTextColor := SetTextColor(ADC, clBlack);
  ASaveBkColor := SetBkColor(ADC, clWhite);
  Windows.DrawFocusRect(ADC, ARect);
  SetTextColor(ADC, ASaveTextColor);
  SetBkColor(ADC, ASaveBkColor);
end;

function TcxCustomLookAndFeelPainter.EditButtonTextOffset: Integer;
begin
  Result := 0;
end;

function TcxCustomLookAndFeelPainter.EditButtonColorPalette(AState: TcxButtonState): IdxColorPalette;
begin
  Result := nil;
end;

function TcxCustomLookAndFeelPainter.EditButtonSize: TSize;
begin
  Result := cxNullSize;
end;

function TcxCustomLookAndFeelPainter.EditButtonTextColor(AState: TcxButtonState): TColor;
begin
  Result := clDefault;
end;

function TcxCustomLookAndFeelPainter.GetContainerBorderColor(AIsHighlightBorder: Boolean): TColor;
begin
  Result := clBtnText;
end;

function TcxCustomLookAndFeelPainter.GetContainerBorderWidth(ABorderStyle: TcxContainerBorderStyle): Integer;
begin
  Result := cxContainerBorderWidths[ABorderStyle];
end;

procedure TcxCustomLookAndFeelPainter.DrawDateNavigatorCellSelection(ACanvas: TcxCanvas; const R: TRect; AColor: TColor);
begin
  ACanvas.FillRect(R, AColor);
end;

procedure TcxCustomLookAndFeelPainter.DrawDateNavigatorDateHeader(ACanvas: TcxCanvas; var R: TRect);
begin
  ACanvas.FillRect(R, DefaultDateNavigatorHeaderColor);
  ACanvas.DrawEdge(R, False, False, cxBordersAll);
  R.Inflate(-1, -1);
end;

procedure TcxCustomLookAndFeelPainter.DrawDateNavigatorTodayCellSelection(ACanvas: TcxCanvas; const R: TRect);
begin
  ACanvas.FrameRect(R, DefaultDateNavigatorTodayFrameColor);
end;

procedure TcxCustomLookAndFeelPainter.DrawNavigatorBorder(ACanvas: TcxCustomCanvas; R: TRect; ASelected: Boolean);
begin
  // do nothing
end;

procedure TcxCustomLookAndFeelPainter.DrawNavigatorScaledButton(ACanvas: TcxCustomCanvas;
  R: TRect; AState: TcxButtonState; ABackgroundColor: TColor; AScaleFactor: TdxScaleFactor);
begin
  DrawScaledButton(ACanvas, R, AState, AScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawNavigatorButton(ACanvas: TcxCanvas;
  R: TRect; AState: TcxButtonState; ABackgroundColor: TColor);
begin
  DrawScaledButton(ACanvas, R, AState, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawNavigatorScaledButtonGlyph(ACanvas: TcxCanvas;
  AImageList: TCustomImageList; AImageIndex: TcxImageIndex; const AGlyphRect: TRect; AEnabled, AUserGlyphs: Boolean;
  AScaleFactor: TdxScaleFactor);
begin
  TdxImageDrawer.DrawUncachedImage(ACanvas.Handle, AGlyphRect, AGlyphRect, nil, AImageList, AImageIndex,
    EnabledImageDrawModeMap[AEnabled], False, 0, clDefault, True, NavigatorButtonColorPalette(AEnabled));
end;

procedure TcxCustomLookAndFeelPainter.DrawNavigatorInfoPanel(ACanvas: TcxCanvas; const R: TRect; const AViewParams: TcxViewParams);
begin
  if cxColorIsValid(AViewParams.Color) or (AViewParams.Bitmap <> nil) then
    ACanvas.FillRect(R, AViewParams)
  else
    ACanvas.FillRect(R, DefaultGridDetailsSiteColor);
end;

procedure TcxCustomLookAndFeelPainter.DrawNavigatorButtonGlyph(ACanvas: TcxCanvas; AImageList: TCustomImageList;
  AImageIndex: TcxImageIndex; const AGlyphRect: TRect; AEnabled: Boolean; AUserGlyphs: Boolean);
begin
  DrawNavigatorScaledButtonGlyph(ACanvas, AImageList, AImageIndex, AGlyphRect, AEnabled, AUserGlyphs, dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.NavigatorBorderOverlap: Boolean;
begin
  Result := False;
end;

function TcxCustomLookAndFeelPainter.NavigatorBorderSize: Integer;
begin
  Result := 0;
end;

function TcxCustomLookAndFeelPainter.NavigatorButtonColorPalette(AEnabled: Boolean): IdxColorPalette;
begin
  Result := nil;
end;

function TcxCustomLookAndFeelPainter.NavigatorScaledButtonGlyphPadding(AScaleFactor: TdxScaleFactor): TRect;
begin
  Result := AScaleFactor.Apply(TRect.Create(3, 4, 3, 4));
end;

function TcxCustomLookAndFeelPainter.NavigatorButtonGlyphPadding: TRect;
begin
  Result := NavigatorScaledButtonGlyphPadding(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.NavigatorScaledButtonGlyphSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  Result.Init(AScaleFactor.Apply(11));
end;

function TcxCustomLookAndFeelPainter.NavigatorButtonGlyphSize: TSize;
begin
  Result := NavigatorScaledButtonGlyphSize(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.NavigatorButtonPressedGlyphOffset: TPoint;
begin
  Result := cxSimplePoint;
end;

function TcxCustomLookAndFeelPainter.NavigatorButtonTextColor(AState: TcxButtonState): TColor;
begin
  Result := clBtnText;
end;

function TcxCustomLookAndFeelPainter.NavigatorScaledButtonMinSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  Result := AScaleFactor.Apply(TSize.Create(17, 19));
end;

function TcxCustomLookAndFeelPainter.NavigatorInfoPanelContentOffsets(AScaleFactor: TdxScaleFactor): TRect;
begin
  Result := cxNullRect;
end;

function TcxCustomLookAndFeelPainter.NavigatorInfoPanelTextColor: TColor;
begin
  Result := DefaultContentTextColor;
end;

function TcxCustomLookAndFeelPainter.NavigatorButtonMinSize: TSize;
begin
  Result := NavigatorScaledButtonMinSize(dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawProgressBarPart(ACanvas: TcxCanvas;
  const ABounds, ABarBounds: TRect; AVertical: Boolean; AScaleFactor: TdxScaleFactor; APart: TcxProgressBarPart);
begin
  if APart = pbpOverloadBar then
    ACanvas.InvertRect(ABounds);
end;

procedure TcxCustomLookAndFeelPainter.DrawProgressBarText(ACanvas: TcxCanvas;
  const AText: string; const ABounds, AProgressRect, AOverloadBarRect, APeakBarRect: TRect;
  const ATextColor: TColor = clDefault; AVertical: Boolean = False);

  procedure DrawTextCore(ACanvas: TcxCanvas; ATextRect: TRect; ATextColor: TColor);
  var
    APrevTextColor: TColor;
  begin
    APrevTextColor := ACanvas.Font.Color;
    try
      ACanvas.Font.Color := ATextColor;
      if AVertical then
      begin
        OffsetRect(ATextRect, 2, 2); 
        cxRotatedTextOut(ACanvas.Handle, ATextRect, AText, ACanvas.Font, taLeft, taTop, False, True, True, vtdTopToBottom);
      end
      else
        cxTextOut(ACanvas.Handle, AText, ATextRect, CXTO_DEFAULT_FORMAT or IfThen(ACanvas.UseRightToLeftAlignment, CXTO_RTLREADING));
    finally
      ACanvas.Font.Color := APrevTextColor;
    end;
  end;

  procedure DrawTextInverted(ACanvas: TcxCanvas; const ATextRect: TRect);
  var
    APrevCopyMode: Integer;
    ATextBuffer: TcxBitmap;
  begin
    ATextBuffer := TcxBitmap.CreateSize(ATextRect);
    try
      ATextBuffer.cxCanvas.Font := ACanvas.Font;
      ATextBuffer.cxCanvas.UseRightToLeftAlignment := ACanvas.UseRightToLeftAlignment;
      dxSetFontAsNonAntialiased(ATextBuffer.cxCanvas.Font);
      ATextBuffer.cxCanvas.FillRect(ATextBuffer.ClientRect, clBlack);
      DrawTextCore(ATextBuffer.cxCanvas, ATextBuffer.ClientRect, clWhite);

      APrevCopyMode := ACanvas.CopyMode;
      try
        ACanvas.CopyMode := cmSrcInvert;
        ACanvas.Draw(ATextRect.Left, ATextRect.Top, ATextBuffer);
      finally
        ACanvas.CopyMode := APrevCopyMode;
      end;
    finally
      ATextBuffer.Free;
    end;
  end;

  procedure DrawTextPart(ACanvas: TcxCanvas; const ATextRect, ABarRect: TRect; APart: TcxProgressBarPart);
  var
    AClipRect: TRect;
    ATextColor: TColor;
  begin
    if cxRectIntersect(AClipRect, ABarRect, ATextRect) then
    begin
      ATextColor := ProgressBarTextColor(APart);
      if cxColorIsValid(ATextColor) then
      begin
        ACanvas.SaveClipRegion;
        try
          ACanvas.IntersectClipRect(AClipRect);
          DrawTextCore(ACanvas, ATextRect, ATextColor);
        finally
          ACanvas.RestoreClipRegion;
        end;
      end;
    end;
    ACanvas.ExcludeClipRect(ABarRect);
  end;

var
  ATextRect: TRect;
  ATextSize: TSize;
begin
  ATextSize := ACanvas.TextExtent(AText);
  if AVertical then
    ExchangeIntegers(ATextSize.cx, ATextSize.cy);
  ATextRect := cxRectCenter(ABounds, ATextSize);

  if ATextColor <> clDefault then
    DrawTextCore(ACanvas, ATextRect, ATextColor)
  else
    if ProgressBarTextColor(pbpProgressChunk) = clDefault then
      DrawTextInverted(ACanvas, ATextRect)
    else
    begin
      ACanvas.SaveClipRegion;
      try
        DrawTextPart(ACanvas, ATextRect, AProgressRect, pbpProgressChunk);
        DrawTextPart(ACanvas, ATextRect, AOverloadBarRect, pbpOverloadBar);
        DrawTextPart(ACanvas, ATextRect, APeakBarRect, pbpPeakBar);
        DrawTextPart(ACanvas, ATextRect, ABounds, pbpBackground);
      finally
        ACanvas.RestoreClipRegion;
      end;
    end;
end;

function TcxCustomLookAndFeelPainter.ProgressBarBorderSize(AVertical: Boolean): TRect;
begin
  Result := cxEmptyRect;
end;

function TcxCustomLookAndFeelPainter.ProgressBarTextColor(APart: TcxProgressBarPart = pbpBackground): TColor;
begin
  if APart = pbpBackground then
    Result := clWindowText
  else
    Result := clDefault;
end;

procedure TcxCustomLookAndFeelPainter.DrawGroupBoxBackground(ACanvas: TcxCanvas;
  ABounds: TRect; ARect: TRect);
begin
end;

procedure TcxCustomLookAndFeelPainter.DrawGroupBoxCaption(ACanvas: TcxCanvas;
  const ACaptionRect, ATextRect: TRect; ACaptionPosition: TcxGroupBoxCaptionPosition);
begin
end;

procedure TcxCustomLookAndFeelPainter.DrawGroupBoxScaledCaption(ACanvas: TcxCanvas;
  const ACaptionRect, ATextRect: TRect; ACaptionPosition: TcxGroupBoxCaptionPosition;
  AScaleFactor: TdxScaleFactor);
begin
end;

procedure TcxCustomLookAndFeelPainter.DrawGroupBoxContent(ACanvas: TcxCanvas;
  ABorderRect: TRect; ACaptionPosition: TcxGroupBoxCaptionPosition; ABorders: TcxBorders = cxBordersAll);
begin
end;

procedure TcxCustomLookAndFeelPainter.DrawGroupBoxScaledContent(ACanvas: TcxCanvas;
  ABorderRect: TRect; ACaptionPosition: TcxGroupBoxCaptionPosition; AScaleFactor: TdxScaleFactor;
  ABorders: TcxBorders = cxBordersAll);
begin
end;

procedure TcxCustomLookAndFeelPainter.DrawGroupBoxExpandButton(ACanvas: TcxCanvas;
  const R: TRect; AState: TcxButtonState; AExpanded: Boolean; ARotationAngle: TcxRotationAngle = ra0);
begin
  DrawGroupBoxScaledExpandButton(ACanvas, R, AState, AExpanded, dxSystemScaleFactor, ARotationAngle);
end;

procedure TcxCustomLookAndFeelPainter.DrawGroupBoxScaledExpandButton(ACanvas: TcxCanvas; const R: TRect;
  AState: TcxButtonState; AExpanded: Boolean; AScaleFactor: TdxScaleFactor; ARotationAngle: TcxRotationAngle = ra0);
begin
  DrawScaledExpandButtonEx(ACanvas, R, AState, AExpanded, AScaleFactor, ARotationAngle);
end;

procedure TcxCustomLookAndFeelPainter.DrawGroupBoxButton(
  ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState);
begin
  DrawGroupBoxScaledButton(ACanvas, R, AState, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawGroupBoxScaledButton(
  ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
begin
  DrawScaledButton(ACanvas, R, AState, AScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawGroupBoxExpandGlyph(
  ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AExpanded: Boolean);
begin
  DrawGroupBoxScaledExpandGlyph(ACanvas, R, AState, AExpanded, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawGroupBoxScaledExpandGlyph(ACanvas: TcxCanvas;
  const R: TRect; AState: TcxButtonState; AExpanded: Boolean; AScaleFactor: TdxScaleFactor);
begin
  DrawScaledExpandMark(ACanvas, R, ButtonSymbolColor(AState), AExpanded, AScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawGroupBoxScaledFrame(
  ACanvas: TcxCanvas; R: TRect; AEnabled: Boolean;
  ACaptionPosition: TcxGroupBoxCaptionPosition; AScaleFactor: TdxScaleFactor;
  ABorders: TcxBorders);
begin
end;

procedure TcxCustomLookAndFeelPainter.DrawGroupBoxFrame(ACanvas: TcxCanvas;
  R: TRect; AEnabled: Boolean; ACaptionPosition: TcxGroupBoxCaptionPosition;
  ABorders: TcxBorders = cxBordersAll);
begin
  DrawGroupBoxScaledFrame(ACanvas, R, AEnabled, ACaptionPosition, dxDefaultScaleFactor, ABorders);
end;

procedure TcxCustomLookAndFeelPainter.GroupBoxAdjustCaptionFont(
  ACaptionFont: TFont; ACaptionPosition: TcxGroupBoxCaptionPosition);
begin
  // do nothing
end;

function TcxCustomLookAndFeelPainter.GroupBoxBorderSize(
  ACaption: Boolean; ACaptionPosition: TcxGroupBoxCaptionPosition): TRect;
begin
  Result := cxEmptyRect;
end;

function TcxCustomLookAndFeelPainter.GroupBoxCaptionTailSize(ACaptionPosition: TcxGroupBoxCaptionPosition): Integer;
begin
  Result := 0;
end;

function TcxCustomLookAndFeelPainter.GroupBoxTextColor(
  AEnabled: Boolean; ACaptionPosition: TcxGroupBoxCaptionPosition): TColor;
begin
  if AEnabled then
    Result := clWindowText
  else
    Result := clBtnShadow;
end;

function TcxCustomLookAndFeelPainter.IsGroupBoxCaptionTextDrawnOverBorder(
  ACaptionPosition: TcxGroupBoxCaptionPosition): Boolean;
begin
  Result := True;
end;

function TcxCustomLookAndFeelPainter.IsGroupBoxTransparent(ACaptionPosition: TcxGroupBoxCaptionPosition): Boolean;
begin
  Result := False;
end;

procedure TcxCustomLookAndFeelPainter.DrawPanelBorders(ACanvas: TcxCanvas;
  const ABorderRect: TRect);
begin
  // do nothing
end;

procedure TcxCustomLookAndFeelPainter.DrawPanelScaledBorders(ACanvas: TcxCanvas; const ABorderRect: TRect; AScaleFactor: TdxScaleFactor);
begin
  // do nothing
end;

procedure TcxCustomLookAndFeelPainter.DrawPanelCaption(ACanvas: TcxCanvas;
  const ACaptionRect: TRect; ACaptionPosition: TcxGroupBoxCaptionPosition);
begin
  DrawGroupBoxCaption(ACanvas, ACaptionRect, cxNullRect, ACaptionPosition);
end;

procedure TcxCustomLookAndFeelPainter.DrawPanelContentEx(ACanvas: TcxCanvas;
  const ARect: TRect; AScaleFactor: TdxScaleFactor);
begin
  ACanvas.FillRect(ARect, clBtnFace);
end;

procedure TcxCustomLookAndFeelPainter.DrawPanelBackground(
  ACanvas: TcxCanvas; AControl: TWinControl; ABounds: TRect;
  AColorFrom: TColor = clDefault; AColorTo: TColor = clDefault);
begin
  DrawGroupBoxBackground(ACanvas, ABounds, ABounds);
end;

procedure TcxCustomLookAndFeelPainter.DrawPanelContent(ACanvas: TcxCustomCanvas; const ARect: TRect; AIsRightToLeft: Boolean = False);
begin
  ACanvas.FillRect(ARect, clBtnFace);
end;

function TcxCustomLookAndFeelPainter.PanelBorderSize: TRect;
begin
  Result := cxEmptyRect;
end;

function TcxCustomLookAndFeelPainter.PanelTextColor: TColor;
begin
  Result := GroupBoxTextColor(True, cxgpTop);
end;

procedure TcxCustomLookAndFeelPainter.CorrectThumbRect(ACanvas: TcxCanvas; var ARect: TRect;
  AHorizontal: Boolean; ATicks: TcxTrackBarTicksAlign; AScaleFactor: TdxScaleFactor);
begin
  ARect := cxRectContent(ARect, Rect(0, 0, -1, -1));
end;

procedure TcxCustomLookAndFeelPainter.DrawTrackBarTrack(ACanvas: TcxCanvas;
  const ARect, ASelection: TRect; AShowSelection, AEnabled, AHorizontal: Boolean; ATrackColor: TColor);
begin
  DrawTrackBarScaledTrack(ACanvas, ARect, ASelection, AShowSelection, AEnabled, AHorizontal, ATrackColor, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawTrackBarScaledTrack(ACanvas: TcxCanvas; const ARect, ASelection: TRect;
  AShowSelection, AEnabled, AHorizontal: Boolean; ATrackColor: TColor; AScaleFactor: TdxScaleFactor);
begin
  ACanvas.FillRect(ARect, ATrackColor);
  DrawTrackBarTrackBounds(ACanvas, ARect);
end;

procedure TcxCustomLookAndFeelPainter.DrawTrackBarTrackBounds(ACanvas: TcxCanvas; const ARect: TRect);
begin
  // do nothing
end;

procedure TcxCustomLookAndFeelPainter.DrawTrackBarThumb(ACanvas: TcxCanvas;
  const ARect: TRect; AState: TcxButtonState; AHorizontal: Boolean;
  ATicks: TcxTrackBarTicksAlign; AThumbColor: TColor);
begin
  DrawTrackBarScaledThumb(ACanvas, ARect, AState, AHorizontal, ATicks, AThumbColor, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawTrackBarScaledThumb(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState;
  AHorizontal: Boolean; ATicks: TcxTrackBarTicksAlign; AThumbColor: TColor; AScaleFactor: TdxScaleFactor);

  procedure GetBottomRightThumbShape(const AThumbRect: TRect; AHorizontal: Boolean;
    var ALightPolyLine, AShadowPolyLine, ADarkPolyLine, APolygon: TPoints);
  var
    AThumbSize: Integer;
    AMiddle: TPoint;
  begin
    SetLength(ALightPolyLine, 4);
    SetLength(AShadowPolyLine, 3);
    SetLength(ADarkPolyLine, 3);
    SetLength(APolygon, 5);

    if AHorizontal then // Bottom
    begin
      AThumbSize := AThumbRect.Width;
      AMiddle.X := AThumbRect.Left + (AThumbSize div 2);
      AMiddle.Y := AThumbRect.Bottom - (AThumbSize div 2);

      ALightPolyLine[0] := Point(AThumbRect.Right, AThumbRect.Top);
      ALightPolyLine[1] := Point(AThumbRect.Left, AThumbRect.Top);
      ALightPolyLine[2] := Point(AThumbRect.Left, AMiddle.Y);
      ALightPolyLine[3] := Point(AMiddle.X, AThumbRect.Bottom);

      ADarkPolyLine[0] := Point(AMiddle.X, AThumbRect.Bottom);
      ADarkPolyLine[1] := Point(AThumbRect.Right, AMiddle.Y);
      ADarkPolyLine[2] := Point(AThumbRect.Right, AThumbRect.Top);

      AShadowPolyLine[0] := Point(AMiddle.X, AThumbRect.Bottom - 1);
      AShadowPolyLine[1] := Point(AThumbRect.Right - 1, AMiddle.Y);
      AShadowPolyLine[2] := Point(AThumbRect.Right - 1, AThumbRect.Top);

      APolygon[0] := Point(AThumbRect.Right - 1, AThumbRect.Top + 1);
      APolygon[1] := Point(AThumbRect.Left + 1, AThumbRect.Top + 1);
      APolygon[2] := Point(AThumbRect.Left + 1, AMiddle.Y);
      APolygon[3] := Point(AMiddle.X, AThumbRect.Bottom - 1);
      APolygon[4] := Point(AThumbRect.Right - 1, AMiddle.Y);
    end
    else // Right
    begin
      AThumbSize := AThumbRect.Height;
      AMiddle.X := AThumbRect.Right - (AThumbSize div 2);
      AMiddle.Y := AThumbRect.Top + (AThumbSize div 2);

      ALightPolyLine[0] := Point(AThumbRect.Left, AThumbRect.Bottom);
      ALightPolyLine[1] := Point(AThumbRect.Left, AThumbRect.Top);
      ALightPolyLine[2] := Point(AMiddle.X, AThumbRect.Top);
      ALightPolyLine[3] := Point(AThumbRect.Right, AMiddle.Y);

      ADarkPolyLine[0] := Point(AThumbRect.Right, AMiddle.Y);
      ADarkPolyLine[1] := Point(AMiddle.X, AThumbRect.Bottom);
      ADarkPolyLine[2] := Point(AThumbRect.Left, AThumbRect.Bottom);

      AShadowPolyLine[0] := Point(AThumbRect.Right - 1, AMiddle.Y);
      AShadowPolyLine[1] := Point(AMiddle.X, AThumbRect.Bottom - 1);
      AShadowPolyLine[2] := Point(AThumbRect.Left, AThumbRect.Bottom - 1);

      APolygon[0] := Point(AThumbRect.Left + 1, AThumbRect.Bottom - 1);
      APolygon[1] := Point(AThumbRect.Left + 1, AThumbRect.Top + 1);
      APolygon[2] := Point(AMiddle.X, AThumbRect.Top + 1);
      APolygon[3] := Point(AThumbRect.Right - 1, AMiddle.Y);
      APolygon[4] := Point(AMiddle.X, AThumbRect.Bottom - 1);
    end;
  end;

  procedure GetTopLeftThumbShape(const AThumbRect: TRect;
    AHorizontal: Boolean;
    var ALightPolyLine, AShadowPolyLine, ADarkPolyLine, APolygon: TPoints);
  var
    AThumbSize: Integer;
    AMiddle: TPoint;
  begin
    SetLength(ALightPolyLine, 3);
    SetLength(AShadowPolyLine, 4);
    SetLength(ADarkPolyLine, 4);
    SetLength(APolygon, 5);

    if AHorizontal then // Top
    begin
      AThumbSize := AThumbRect.Width;
      AMiddle.X :=  AThumbRect.Left + (AThumbSize div 2);
      AMiddle.Y := AThumbRect.Top + (AThumbSize div 2);

      ALightPolyLine[0] := Point(AThumbRect.Left, AThumbRect.Bottom - 1);
      ALightPolyLine[1] := Point(AThumbRect.Left, AMiddle.Y - 1);
      ALightPolyLine[2] := Point(AMiddle.X, AThumbRect.Top - 1);

      AShadowPolyLine[0] := Point(AMiddle.X, AThumbRect.Top);
      AShadowPolyLine[1] := Point(AThumbRect.Right - 1, AMiddle.Y - 1);
      AShadowPolyLine[2] := Point(AThumbRect.Right - 1, AThumbRect.Bottom - 2);
      AShadowPolyLine[3] := Point(AThumbRect.Left, AThumbRect.Bottom - 2);

      ADarkPolyLine[0] := Point(AMiddle.X, AThumbRect.Top - 1);
      ADarkPolyLine[1] := Point(AThumbRect.Right, AMiddle.Y - 1);
      ADarkPolyLine[2] := Point(AThumbRect.Right, AThumbRect.Bottom - 1);
      ADarkPolyLine[3] := Point(AThumbRect.Left, AThumbRect.Bottom - 1);

      APolygon[0] := Point(AThumbRect.Right - 1, AThumbRect.Bottom - 2);
      APolygon[1] := Point(AThumbRect.Left + 1, AThumbRect.Bottom - 2);
      APolygon[2] := Point(AThumbRect.Left + 1, AMiddle.Y - 1);
      APolygon[3] := Point(AMiddle.X, AThumbRect.Top);
      APolygon[4] := Point(AThumbRect.Right - 1, AMiddle.Y - 1);
    end
    else // Left
    begin
      AThumbSize := AThumbRect.Height;
      AMiddle.X := AThumbRect.Left + (AThumbSize div 2);
      AMiddle.Y := AThumbRect.Top + (AThumbSize div 2);

      ALightPolyLine[0] := Point(AThumbRect.Right - 1, AThumbRect.Top);
      ALightPolyLine[1] := Point(AMiddle.X - 1, AThumbRect.Top);
      ALightPolyLine[2] := Point(AThumbRect.Left - 1, AMiddle.Y);

      ADarkPolyLine[0] := Point(AThumbRect.Left - 1, AMiddle.Y);
      ADarkPolyLine[1] := Point(AMiddle.X - 1, AThumbRect.Bottom);
      ADarkPolyLine[2] := Point(AThumbRect.Right - 1, AThumbRect.Bottom);
      ADarkPolyLine[3] := Point(AThumbRect.Right - 1, AThumbRect.Top);

      AShadowPolyLine[0] := Point(AThumbRect.Left, AMiddle.Y);
      AShadowPolyLine[1] := Point(AMiddle.X - 1, AThumbRect.Bottom - 1);
      AShadowPolyLine[2] := Point(AThumbRect.Right - 2, AThumbRect.Bottom - 1);
      AShadowPolyLine[3] := Point(AThumbRect.Right - 2, AThumbRect.Top);

      APolygon[0] := Point(AThumbRect.Right - 2, AThumbRect.Bottom - 1);
      APolygon[1] := Point(AThumbRect.Right - 2, AThumbRect.Top + 1);
      APolygon[2] := Point(AMiddle.X - 1, AThumbRect.Top + 1);
      APolygon[3] := Point(AThumbRect.Left, AMiddle.Y);
      APolygon[4] := Point(AMiddle.X - 1, AThumbRect.Bottom - 1);
    end;
  end;

var
  ALightPolyLine, AShadowPolyLine, ADarkPolyLine, APolygon: TPoints;
begin
  ACanvas.Pen.Color := AThumbColor;
  ACanvas.Brush.Color := AThumbColor;
  case ATicks of
    tbtaUp:
      begin
        GetTopLeftThumbShape(ARect, AHorizontal, ALightPolyLine, AShadowPolyLine, ADarkPolyLine, APolygon);
        ACanvas.Polygon(APolygon);
        DrawTrackBarThumbBorderUpDown(ACanvas, ALightPolyLine, AShadowPolyLine, ADarkPolyLine);
      end;
    tbtaDown:
      begin
        GetBottomRightThumbShape(ARect, AHorizontal, ALightPolyLine, AShadowPolyLine, ADarkPolyLine, APolygon);
        ACanvas.Polygon(APolygon);
        DrawTrackBarThumbBorderUpDown(ACanvas, ALightPolyLine, AShadowPolyLine, ADarkPolyLine);
      end;
    tbtaBoth:
    begin
      ACanvas.Canvas.FillRect(ARect);
      DrawTrackBarThumbBorderBoth(ACanvas, ARect);
    end;
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawTrackBarThumbBorderUpDown(ACanvas: TcxCanvas;
  const ALightPolyLine, AShadowPolyLine, ADarkPolyLine: TPoints);
begin
//
end;

procedure TcxCustomLookAndFeelPainter.DrawTrackBarThumbBorderBoth(ACanvas: TcxCanvas; const ARect: TRect);
begin

end;

function TcxCustomLookAndFeelPainter.TrackBarScaledThumbSize(AHorizontal: Boolean; AScaleFactor: TdxScaleFactor): TSize;
begin
  Result := cxNullSize;
end;

function TcxCustomLookAndFeelPainter.TrackBarThumbSize(AHorizontal: Boolean): TSize;
begin
  Result := TrackBarScaledThumbSize(AHorizontal, dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.TrackBarTicksColor(AText: Boolean): TColor;
begin
  Result := clDefault;
end;

function TcxCustomLookAndFeelPainter.TrackBarTrackSize: Integer;
begin
  Result := TrackBarScaledTrackSize(dxSystemScaleFactor)
end;

function TcxCustomLookAndFeelPainter.TrackBarScaledTrackSize(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := 0;
end;

procedure TcxCustomLookAndFeelPainter.DrawRangeControlLeftThumb(
  ACanvas: TcxCanvas; const ARect: TRect; AColor: TColor; ABorderColor: TdxAlphaColor);
begin
  DrawRangeControlScaledLeftThumb(ACanvas, ARect, AColor, ABorderColor, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawRangeControlScaledLeftThumb(ACanvas: TcxCanvas;
  const ARect: TRect; AColor: TColor; ABorderColor: TdxAlphaColor; AScaleFactor: TdxScaleFactor);
begin
  DrawRangeControlThumb(ACanvas, ARect, AColor, ABorderColor, AScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawRangeControlRightThumb(
  ACanvas: TcxCanvas; const ARect: TRect; AColor: TColor; ABorderColor: TdxAlphaColor);
begin
  DrawRangeControlScaledRightThumb(ACanvas, ARect, AColor, ABorderColor, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawRangeControlScaledRightThumb(
  ACanvas: TcxCanvas; const ARect: TRect; AColor: TColor; ABorderColor: TdxAlphaColor; AScaleFactor: TdxScaleFactor);
begin
  DrawRangeControlThumb(ACanvas, ARect, AColor, ABorderColor, AScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawRangeControlRulerHeader(ACanvas: TcxCanvas;
  const ARect: TRect; AIsHot: Boolean; AColor, ABorderColor: TdxAlphaColor);
begin
  DrawRangeControlScaledRulerHeader(ACanvas, ARect, AIsHot, AColor, ABorderColor, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawRangeControlScaledRulerHeader(ACanvas: TcxCanvas;
  const ARect: TRect; AIsHot: Boolean; AColor, ABorderColor: TdxAlphaColor; AScaleFactor: TdxScaleFactor);
const
  BackColor = $FFFFFFFF;
  BackHotColor = $FFE2EAFD;
var
  APoint1: TPoint;
  APoint2: TPoint;
begin
  if AColor = dxacDefault then
  begin
    if AIsHot then
      AColor := BackHotColor
    else
      AColor := BackColor;
  end;

  dxGPPaintCanvas.BeginPaint(ACanvas.Handle, ARect);
  try
    dxGPPaintCanvas.FillRectangle(ARect, AColor);
    APoint1 := ARect.TopLeft;
    APoint2 := Point(ARect.Left, ARect.Bottom - 1);
    dxGPPaintCanvas.Line(APoint1.X, APoint1.Y, APoint2.X, APoint2.Y, ABorderColor);
    APoint1 := APoint2;
    APoint2 := Point(ARect.Right - 1, APoint1.Y);
    dxGPPaintCanvas.Line(APoint1.X, APoint1.Y, APoint2.X, APoint2.Y, ABorderColor);
  finally
    dxGPPaintCanvas.EndPaint;
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawRangeControlSizingGlyph(
  ACanvas: TcxCanvas; const ARect: TRect; ABorderColor: TdxAlphaColor);
begin
  DrawRangeControlScaledSizingGlyph(ACanvas, ARect, ABorderColor, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawRangeControlScaledSizingGlyph(
  ACanvas: TcxCanvas; const ARect: TRect; ABorderColor: TdxAlphaColor; AScaleFactor: TdxScaleFactor);
var
  R: TRect;
  APoint1: TPoint;
  APoint2: TPoint;
begin
  dxGPPaintCanvas.BeginPaint(ACanvas.Handle, ARect);
  try
    R := cxRectCenter(ARect, Size(AScaleFactor.Apply(1), ARect.Height - AScaleFactor.Apply(4)));
    APoint1 := R.TopLeft;
    APoint2 := Point(R.Left, R.Bottom - 1);
    dxGPPaintCanvas.Line(APoint1.X, APoint1.Y, APoint2.X, APoint2.Y, ABorderColor, AScaleFactor.ApplyF(1));
  finally
    dxGPPaintCanvas.EndPaint;
  end;
end;

function TcxCustomLookAndFeelPainter.GetRangeControlBackColor: TColor;
begin
  Result := clWindow;
end;

function TcxCustomLookAndFeelPainter.GetRangeControlBorderColor: TColor;
begin
  Result := $AAA09D;
end;

function TcxCustomLookAndFeelPainter.GetRangeControlDefaultElementColor: TColor;
begin
  Result := $A69A9A;
end;

function TcxCustomLookAndFeelPainter.GetRangeControlElementForeColor: TColor;
begin
  Result := $E1DEDD;
end;

function TcxCustomLookAndFeelPainter.GetRangeControlElementsBorderColor: TdxAlphaColor;
begin
  Result := $FFB6B8BF;
end;

function TcxCustomLookAndFeelPainter.GetRangeControlLabelColor: TColor;
begin
  Result := $BAAEAE;
end;

function TcxCustomLookAndFeelPainter.GetRangeControlOutOfRangeColor: TdxAlphaColor;
begin
  Result := $1E9DA0AA;
end;

function TcxCustomLookAndFeelPainter.GetRangeControlRangePreviewColor: TColor;
begin
  Result := clWindow;
end;

function TcxCustomLookAndFeelPainter.GetRangeControlRulerColor: TdxAlphaColor;
begin
  Result := $14000000;
end;

function TcxCustomLookAndFeelPainter.GetRangeControlScrollAreaColor: TColor;
begin
  Result := $E1DEDD;
end;

function TcxCustomLookAndFeelPainter.GetRangeControlSelectedRegionBackgroundColor: TdxAlphaColor;
begin
  Result := $64A8C3F1;
end;

function TcxCustomLookAndFeelPainter.GetRangeControlSelectedRegionBorderColor: TdxAlphaColor;
begin
  Result :=  $644571BA;
end;

function TcxCustomLookAndFeelPainter.GetRangeControlViewPortPreviewColor: TColor;
begin
  Result := $F2F1F0;
end;

function TcxCustomLookAndFeelPainter.GetRangeControlScrollAreaHeight: Integer;
begin
  Result := GetRangeControlScaledScrollAreaHeight(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.GetRangeControlScaledScrollAreaHeight(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := AScaleFactor.Apply(11);
end;

function TcxCustomLookAndFeelPainter.GetRangeControlSizingGlyphSize: TSize;
begin
  Result := GetRangeControlScaledSizingGlyphSize(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.GetRangeControlScaledSizingGlyphSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  Result := AScaleFactor.Apply(Size(5, 9));
end;

function TcxCustomLookAndFeelPainter.GetRangeControlThumbSize: TSize;
begin
  Result := GetRangeControlScaledThumbSize(dxSystemScaleFactor)
end;

function TcxCustomLookAndFeelPainter.GetRangeControlScaledThumbSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  Result := AScaleFactor.Apply(Size(11, 19));
end;

function TcxCustomLookAndFeelPainter.RangeTrackBarScaledLeftThumbSize(
  AHorizontal: Boolean; ATicks: TcxTrackBarTicksAlign; AScaleFactor: TdxScaleFactor): TSize;
begin
  Result := cxNullSize;
end;

function TcxCustomLookAndFeelPainter.RangeTrackBarLeftThumbSize(AHorizontal: Boolean; ATicks: TcxTrackBarTicksAlign): TSize;
begin
  Result := RangeTrackBarScaledLeftThumbSize(AHorizontal, ATicks, dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.RangeTrackBarRightThumbSize(AHorizontal: Boolean; ATicks: TcxTrackBarTicksAlign): TSize;
begin
  Result := RangeTrackBarScaledRightThumbSize(AHorizontal, ATicks, dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.RangeTrackBarScaledRightThumbSize(
  AHorizontal: Boolean; ATicks: TcxTrackBarTicksAlign; AScaleFactor: TdxScaleFactor): TSize;
begin
  Result := cxNullSize;
end;

procedure TcxCustomLookAndFeelPainter.DrawRangeTrackBarScaledLeftThumb(ACanvas: TcxCanvas;
  const ARect: TRect; AState: TcxButtonState; AHorizontal: Boolean;
  ATicks: TcxTrackBarTicksAlign; AThumbColor: TColor; AScaleFactor: TdxScaleFactor);

  procedure GetBottomRightThumbShape(const AThumbRect: TRect;
    AHorizontal: Boolean;
    var ALightPolyLine, AShadowPolyLine, ADarkPolyLine, APolygon: TPoints);
  var
    AThumbSize: Integer;
    AMiddle: Integer;
  begin
    if AHorizontal then // Bottom
    begin
      AThumbSize := AThumbRect.Width;
      AMiddle := AThumbRect.Bottom - AThumbSize;

      SetLength(ALightPolyLine, 4);
      SetLength(AShadowPolyLine, 3);
      SetLength(ADarkPolyLine, 2);
      SetLength(APolygon, 4);

      ALightPolyLine[0] := Point(AThumbRect.Right, AThumbRect.Top);
      ALightPolyLine[1] := Point(AThumbRect.Left, AThumbRect.Top);
      ALightPolyLine[2] := Point(AThumbRect.Left, AMiddle);
      ALightPolyLine[3] := Point(AThumbRect.Right, AThumbRect.Bottom);

      ADarkPolyLine[0] := Point(AThumbRect.Right, AThumbRect.Bottom);
      ADarkPolyLine[1] := Point(AThumbRect.Right, AThumbRect.Top);

      AShadowPolyLine[0] := Point(AThumbRect.Right - 1, AThumbRect.Bottom - 1);
      AShadowPolyLine[1] := Point(AThumbRect.Right - 1, AMiddle);
      AShadowPolyLine[2] := Point(AThumbRect.Right - 1, AThumbRect.Top);

      APolygon[0] := Point(AThumbRect.Right - 1, AThumbRect.Top + 1);
      APolygon[1] := Point(AThumbRect.Left + 1, AThumbRect.Top + 1);
      APolygon[2] := Point(AThumbRect.Left + 1, AMiddle);
      APolygon[3] := Point(AThumbRect.Right - 1, AThumbRect.Bottom - 1);
    end
    else // Right
    begin
      AThumbSize := AThumbRect.Height;
      AMiddle := AThumbRect.Right - AThumbSize;

      SetLength(ALightPolyLine, 4);
      SetLength(AShadowPolyLine, 2);
      SetLength(ADarkPolyLine, 2);
      SetLength(APolygon, 4);

      ALightPolyLine[0] := Point(AThumbRect.Left, AThumbRect.Bottom);
      ALightPolyLine[1] := Point(AThumbRect.Left, AThumbRect.Top);
      ALightPolyLine[2] := Point(AMiddle, AThumbRect.Top);
      ALightPolyLine[3] := Point(AThumbRect.Right, AThumbRect.Bottom);

      ADarkPolyLine[0] := Point(AThumbRect.Right, AThumbRect.Bottom);
      ADarkPolyLine[1] := Point(AThumbRect.Left, AThumbRect.Bottom);

      AShadowPolyLine[0] := Point(AThumbRect.Right - 1, AThumbRect.Bottom - 1);
      AShadowPolyLine[1] := Point(AThumbRect.Left, AThumbRect.Bottom - 1);

      APolygon[0] := Point(AThumbRect.Left + 1, AThumbRect.Bottom - 1);
      APolygon[1] := Point(AThumbRect.Left + 1, AThumbRect.Top + 1);
      APolygon[2] := Point(AMiddle, AThumbRect.Top + 1);
      APolygon[3] := Point(AThumbRect.Right - 1, AThumbRect.Bottom - 1);
    end;
  end;

  procedure GetTopLeftThumbShape(const AThumbRect: TRect;
    AHorizontal: Boolean; var ALightPolyLine, AShadowPolyLine, ADarkPolyLine, APolygon: TPoints);
  var
    AThumbSize: Integer;
    AMiddle: Integer;
  begin
    if AHorizontal then // Top
    begin
      AThumbSize := AThumbRect.Width;
      AMiddle := AThumbRect.Top + AThumbSize;

      SetLength(ALightPolyLine, 3);
      SetLength(AShadowPolyLine, 3);
      SetLength(ADarkPolyLine, 3);
      SetLength(APolygon, 4);

      ALightPolyLine[0] := Point(AThumbRect.Left, AThumbRect.Bottom - 1);
      ALightPolyLine[1] := Point(AThumbRect.Left, AMiddle - 1);
      ALightPolyLine[2] := Point(AThumbRect.Right, AThumbRect.Top - 1);

      AShadowPolyLine[0] := Point(AThumbRect.Right - 1, AThumbRect.Top);
      AShadowPolyLine[1] := Point(AThumbRect.Right - 1, AThumbRect.Bottom - 2);
      AShadowPolyLine[2] := Point(AThumbRect.Left, AThumbRect.Bottom - 2);

      ADarkPolyLine[0] := Point(AThumbRect.Right, AThumbRect.Top - 1);
      ADarkPolyLine[1] := Point(AThumbRect.Right, AThumbRect.Bottom - 1);
      ADarkPolyLine[2] := Point(AThumbRect.Left, AThumbRect.Bottom - 1);

      APolygon[0] := Point(AThumbRect.Right - 1, AThumbRect.Bottom - 2);
      APolygon[1] := Point(AThumbRect.Left + 1, AThumbRect.Bottom - 2);
      APolygon[2] := Point(AThumbRect.Left + 1, AMiddle - 1);
      APolygon[3] := Point(AThumbRect.Right - 1, AThumbRect.Top);
    end
    else // Left
    begin
      AThumbSize := AThumbRect.Height;
      AMiddle := AThumbRect.Left + AThumbSize;

      SetLength(ALightPolyLine, 3);
      SetLength(AShadowPolyLine, 3);
      SetLength(ADarkPolyLine, 3);
      SetLength(APolygon, 4);

      ALightPolyLine[0] := Point(AThumbRect.Right - 1, AThumbRect.Top);
      ALightPolyLine[1] := Point(AMiddle - 1, AThumbRect.Top);
      ALightPolyLine[2] := Point(AThumbRect.Left - 1, AThumbRect.Bottom);

      ADarkPolyLine[0] := Point(AThumbRect.Left - 1, AThumbRect.Bottom);
      ADarkPolyLine[1] := Point(AThumbRect.Right - 1, AThumbRect.Bottom);
      ADarkPolyLine[2] := Point(AThumbRect.Right - 1, AThumbRect.Top);

      AShadowPolyLine[0] := Point(AThumbRect.Left, AThumbRect.Bottom - 1);
      AShadowPolyLine[1] := Point(AThumbRect.Right - 2, AThumbRect.Bottom - 1);
      AShadowPolyLine[2] := Point(AThumbRect.Right - 2, AThumbRect.Top);

      APolygon[0] := Point(AThumbRect.Right - 2, AThumbRect.Bottom - 1);
      APolygon[1] := Point(AThumbRect.Right - 2, AThumbRect.Top + 1);
      APolygon[2] := Point(AMiddle - 1, AThumbRect.Top + 1);
      APolygon[3] := Point(AThumbRect.Left, AThumbRect.Bottom - 1);
    end;
  end;

var
  ALightPolyLine, AShadowPolyLine, ADarkPolyLine, APolygon: TPoints;
  R: TRect;
begin
  ACanvas.Pen.Color := AThumbColor;
  ACanvas.Brush.Color := AThumbColor;
  R := GetRangeTrackBarThumbDrawRect(ARect, ATicks, AHorizontal);
  case ATicks of
    tbtaUp:
      begin
        GetTopLeftThumbShape(R, AHorizontal, ALightPolyLine, AShadowPolyLine, ADarkPolyLine, APolygon);
        ACanvas.Polygon(APolygon);
        DrawTrackBarThumbBorderUpDown(ACanvas, ALightPolyLine, AShadowPolyLine, ADarkPolyLine);
      end;
    tbtaDown:
      begin
        GetBottomRightThumbShape(R, AHorizontal, ALightPolyLine, AShadowPolyLine, ADarkPolyLine, APolygon);
        ACanvas.Polygon(APolygon);
        DrawTrackBarThumbBorderUpDown(ACanvas, ALightPolyLine, AShadowPolyLine, ADarkPolyLine);
      end;
    tbtaBoth:
    begin
      ACanvas.Canvas.FillRect(R);
      DrawTrackBarThumbBorderBoth(ACanvas, R);
    end;
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawRangeTrackBarLeftThumb(ACanvas: TcxCanvas; const ARect: TRect;
  AState: TcxButtonState; AHorizontal: Boolean; ATicks: TcxTrackBarTicksAlign; AThumbColor: TColor);
begin
  DrawRangeTrackBarScaledLeftThumb(ACanvas, ARect, AState, AHorizontal, ATicks, AThumbColor, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawRangeTrackBarRightThumb(ACanvas: TcxCanvas; const ARect: TRect;
  AState: TcxButtonState; AHorizontal: Boolean; ATicks: TcxTrackBarTicksAlign; AThumbColor: TColor);
begin
  DrawRangeTrackBarScaledRightThumb(ACanvas, ARect, AState, AHorizontal, ATicks, AThumbColor, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawRangeTrackBarScaledRightThumb(ACanvas: TcxCanvas;
  const ARect: TRect; AState: TcxButtonState; AHorizontal: Boolean;
  ATicks: TcxTrackBarTicksAlign; AThumbColor: TColor; AScaleFactor: TdxScaleFactor);

  procedure GetBottomRightThumbShape(const AThumbRect: TRect;
    AHorizontal: Boolean;
    var ALightPolyLine, AShadowPolyLine, ADarkPolyLine, APolygon: TPoints);
  var
    AThumbSize: Integer;
    AMiddle: Integer;
  begin
    if AHorizontal then // Bottom
    begin
      AThumbSize := AThumbRect.Width;
      AMiddle := AThumbRect.Bottom - AThumbSize;

      SetLength(ALightPolyLine, 3);
      SetLength(AShadowPolyLine, 3);
      SetLength(ADarkPolyLine, 3);
      SetLength(APolygon, 4);

      ALightPolyLine[0] := Point(AThumbRect.Right, AThumbRect.Top);
      ALightPolyLine[1] := Point(AThumbRect.Left, AThumbRect.Top);
      ALightPolyLine[2] := Point(AThumbRect.Left, AThumbRect.Bottom);

      ADarkPolyLine[0] := Point(AThumbRect.Left, AThumbRect.Bottom);
      ADarkPolyLine[1] := Point(AThumbRect.Right, AMiddle);
      ADarkPolyLine[2] := Point(AThumbRect.Right, AThumbRect.Top);

      AShadowPolyLine[0] := Point(AThumbRect.Left, AThumbRect.Bottom - 1);
      AShadowPolyLine[1] := Point(AThumbRect.Right - 1, AMiddle);
      AShadowPolyLine[2] := Point(AThumbRect.Right - 1, AThumbRect.Top);

      APolygon[0] := Point(AThumbRect.Right - 1, AThumbRect.Top + 1);
      APolygon[1] := Point(AThumbRect.Left + 1, AThumbRect.Top + 1);
      APolygon[2] := Point(AThumbRect.Left + 1, AThumbRect.Bottom - 1);
      APolygon[3] := Point(AThumbRect.Right - 1, AMiddle);
    end
    else // Right
    begin
      AThumbSize := AThumbRect.Height;
      AMiddle := AThumbRect.Right - AThumbSize;

      SetLength(ALightPolyLine, 3);
      SetLength(AShadowPolyLine, 3);
      SetLength(ADarkPolyLine, 3);
      SetLength(APolygon, 4);

      ALightPolyLine[0] := Point(AThumbRect.Left, AThumbRect.Bottom);
      ALightPolyLine[1] := Point(AThumbRect.Left, AThumbRect.Top);
      ALightPolyLine[2] := Point(AThumbRect.Right, AThumbRect.Top);

      ADarkPolyLine[0] := Point(AThumbRect.Right, AThumbRect.Top);
      ADarkPolyLine[1] := Point(AMiddle, AThumbRect.Bottom);
      ADarkPolyLine[2] := Point(AThumbRect.Left, AThumbRect.Bottom);

      AShadowPolyLine[0] := Point(AThumbRect.Right - 1, AThumbRect.Top);
      AShadowPolyLine[1] := Point(AMiddle, AThumbRect.Bottom - 1);
      AShadowPolyLine[2] := Point(AThumbRect.Left, AThumbRect.Bottom - 1);

      APolygon[0] := Point(AThumbRect.Left + 1, AThumbRect.Bottom - 1);
      APolygon[1] := Point(AThumbRect.Left + 1, AThumbRect.Top + 1);
      APolygon[2] := Point(AThumbRect.Right - 1, AThumbRect.Top + 1);
      APolygon[3] := Point(AMiddle, AThumbRect.Bottom - 1);
    end;
  end;

  procedure GetTopLeftThumbShape(const AThumbRect: TRect;
    AHorizontal: Boolean;
    var ALightPolyLine, AShadowPolyLine, ADarkPolyLine, APolygon: TPoints);
  var
    AThumbSize: Integer;
    AMiddle: Integer;
  begin
    if AHorizontal then // Top
    begin
      AThumbSize := AThumbRect.Width;
      AMiddle := AThumbRect.Top + AThumbSize;

      SetLength(ALightPolyLine, 2);
      SetLength(AShadowPolyLine, 4);
      SetLength(ADarkPolyLine, 4);
      SetLength(APolygon, 4);

      ALightPolyLine[0] := Point(AThumbRect.Left, AThumbRect.Bottom - 1);
      ALightPolyLine[1] := Point(AThumbRect.Left, AThumbRect.Top - 1);

      AShadowPolyLine[0] := Point(AThumbRect.Left, AThumbRect.Top);
      AShadowPolyLine[1] := Point(AThumbRect.Right - 1, AMiddle - 1);
      AShadowPolyLine[2] := Point(AThumbRect.Right - 1, AThumbRect.Bottom - 2);
      AShadowPolyLine[3] := Point(AThumbRect.Left, AThumbRect.Bottom - 2);

      ADarkPolyLine[0] := Point(AThumbRect.Left, AThumbRect.Top - 1);
      ADarkPolyLine[1] := Point(AThumbRect.Right, AMiddle - 1);
      ADarkPolyLine[2] := Point(AThumbRect.Right, AThumbRect.Bottom - 1);
      ADarkPolyLine[3] := Point(AThumbRect.Left, AThumbRect.Bottom - 1);

      APolygon[0] := Point(AThumbRect.Right - 1, AThumbRect.Bottom - 2);
      APolygon[1] := Point(AThumbRect.Left + 1, AThumbRect.Bottom - 2);
      APolygon[2] := Point(AThumbRect.Left + 1, AThumbRect.Top);
      APolygon[3] := Point(AThumbRect.Right - 1, AMiddle - 1);
    end
    else // Left
    begin
      AThumbSize := AThumbRect.Height;
      AMiddle := AThumbRect.Left + AThumbSize;

      SetLength(ALightPolyLine, 2);
      SetLength(AShadowPolyLine, 4);
      SetLength(ADarkPolyLine, 4);
      SetLength(APolygon, 4);

      ALightPolyLine[0] := Point(AThumbRect.Right - 1, AThumbRect.Top);
      ALightPolyLine[1] := Point(AThumbRect.Left - 1, AThumbRect.Top);

      ADarkPolyLine[0] := Point(AThumbRect.Left - 1, AThumbRect.Top);
      ADarkPolyLine[1] := Point(AMiddle - 1, AThumbRect.Bottom);
      ADarkPolyLine[2] := Point(AThumbRect.Right - 1, AThumbRect.Bottom);
      ADarkPolyLine[3] := Point(AThumbRect.Right - 1, AThumbRect.Top);

      AShadowPolyLine[0] := Point(AThumbRect.Left, AThumbRect.Top);
      AShadowPolyLine[1] := Point(AMiddle - 1, AThumbRect.Bottom - 1);
      AShadowPolyLine[2] := Point(AThumbRect.Right - 2, AThumbRect.Bottom - 1);
      AShadowPolyLine[3] := Point(AThumbRect.Right - 2, AThumbRect.Top);

      APolygon[0] := Point(AThumbRect.Right - 2, AThumbRect.Bottom - 1);
      APolygon[1] := Point(AThumbRect.Right - 2, AThumbRect.Top + 1);
      APolygon[2] := Point(AThumbRect.Left, AThumbRect.Top + 1);
      APolygon[3] := Point(AMiddle - 1, AThumbRect.Bottom - 1);
    end;
  end;

var
  ALightPolyLine, AShadowPolyLine, ADarkPolyLine, APolygon: TPoints;
  R: TRect;
begin
  ACanvas.Pen.Color := AThumbColor;
  ACanvas.Brush.Color := AThumbColor;
  R := GetRangeTrackBarThumbDrawRect(ARect, ATicks, AHorizontal);
  case ATicks of
    tbtaUp:
      begin
        GetTopLeftThumbShape(R, AHorizontal, ALightPolyLine, AShadowPolyLine, ADarkPolyLine, APolygon);
        ACanvas.Polygon(APolygon);
        DrawTrackBarThumbBorderUpDown(ACanvas, ALightPolyLine, AShadowPolyLine, ADarkPolyLine);
      end;
    tbtaDown:
      begin
        GetBottomRightThumbShape(R, AHorizontal, ALightPolyLine, AShadowPolyLine, ADarkPolyLine, APolygon);
        ACanvas.Polygon(APolygon);
        DrawTrackBarThumbBorderUpDown(ACanvas, ALightPolyLine, AShadowPolyLine, ADarkPolyLine);
      end;
    tbtaBoth:
    begin
      ACanvas.Canvas.FillRect(R);
      DrawTrackBarThumbBorderBoth(ACanvas, R);
    end;
  end;
end;

function TcxCustomLookAndFeelPainter.GetSplitterInnerColor(AHighlighted: Boolean): TColor;
begin
  Result := clWhite;
end;

function TcxCustomLookAndFeelPainter.GetSplitterOuterColor(AHighlighted: Boolean): TColor;
begin
  Result := clBtnShadow;
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledSplitter(
  ACanvas: TcxCustomCanvas; const ARect: TRect; AHighlighted, AClicked, AHorizontal: Boolean;
  AScaleFactor: TdxScaleFactor; AHasCloseMark: Boolean = False; AArrowDirection: TcxArrowDirection = adLeft);

  procedure InternalDrawSplitter(AColor: TColor; const R: TRect; AHasInnerLine: Boolean);

    procedure SetFirst(var P1, P2: TPoint);
    begin
      P1 := R.TopLeft;
      P2 := P1;
      if AHorizontal then
        P2.X := (R.Right + R.Left) div 2 - 5
      else
        P2.Y := (R.Top + R.Bottom) div 2 - 5;
    end;

    procedure SetNext(var P1, P2: TPoint);
    begin
      if AHorizontal then
      begin
        P1.X := P2.X + 1;
        P2.X := P1.X + 2;
      end
      else
      begin
        P1.Y := P2.Y + 1;
        P2.Y := P1.Y + 2;
      end;
    end;

    procedure SetLast(var P1, P2: TPoint);
    begin
      SetNext(P1, P2);
      if AHorizontal then
        P2.X := R.Right
      else
        P2.Y := R.Bottom;
    end;

  var
    I: Integer;
    P1, P2: TPoint;
  begin
    SetFirst(P1, P2);
    ACanvas.Line(P1, P2, AColor);
    for I := 0 to 2 do
    begin
      SetNext(P1, P2);
      if not AHasCloseMark then
        ACanvas.Line(P1, P2, AColor);
    end;
    SetLast(P1, P2);
    if AHasCloseMark then
    begin
      P1 := Point(
        P1.X + Ord(AHorizontal) + 2 * Ord(AHorizontal and AHasInnerLine),
        P1.Y + Ord(not AHorizontal) + 2 * Ord(not AHorizontal and AHasInnerLine));
    end;
    ACanvas.Line(P1, P2, AColor);
  end;

var
  R: TRect;
  AHasInnerLine: Boolean;
begin
  AHasInnerLine := HasSplitterInnerLine(AHorizontal, AScaleFactor);
  R := cxRectCenter(ARect, IfThen(AHorizontal, ARect.Width, 1), IfThen(AHorizontal, 1, ARect.Height));
  R := Rect(R.Left, R.Top, R.Right - IfThen(AHorizontal and AHasInnerLine, 1, 0), R.Bottom - IfThen(not AHorizontal and AHasInnerLine, 1, 0));
  InternalDrawSplitter(GetSplitterOuterColor(AHighlighted), R, AHasInnerLine);
  if AHasInnerLine then
  begin
    R.Offset(1, 1);
    InternalDrawSplitter(GetSplitterInnerColor(AHighlighted), R, AHasInnerLine);
  end;

  if AHasCloseMark then
    DrawSplitterCloseMark(ACanvas, ARect, AHighlighted, AClicked, AHorizontal, AScaleFactor, AArrowDirection);
end;

procedure TcxCustomLookAndFeelPainter.DrawSplitter(ACanvas: TcxCustomCanvas;
  const ARect: TRect; AHighlighted: Boolean; AClicked: Boolean; AHorizontal: Boolean);
begin
  DrawScaledSplitter(ACanvas, ARect, AHighlighted, AClicked, AHorizontal, dxSystemScaleFactor)
end;

procedure TcxCustomLookAndFeelPainter.DrawSplitterCloseMark(ACanvas: TcxCustomCanvas; const ARect: TRect;
  AHighlighted, AClicked, AHorizontal: Boolean; AScaleFactor: TdxScaleFactor; AArrowDirection: TcxArrowDirection);
var
  ACenter: TPoint;
  AColor: TColor;
  I: Integer;
begin
  AColor := GetSplitterOuterColor(False);
  ACenter := cxRectCenter(ARect);
  ACenter.X := ACenter.X +
    Ord(AHorizontal and HasSplitterInnerLine(AHorizontal, AScaleFactor) and (((ARect.Right - ARect.Left) mod 2) <> 0));

  ACenter.Y := ACenter.Y + Ord(not AHorizontal and HasSplitterInnerLine(AHorizontal, AScaleFactor) and (((ARect.Bottom - ARect.Top) mod 2) <> 0));
  case AArrowDirection of
    adUp:
      for I := 0 to AScaleFactor.Apply(3) do
      begin
        ACanvas.Line(Point(ACenter.X - I, ACenter.Y - AScaleFactor.Apply(3) + I),
          Point(ACenter.X - I, ACenter.Y - AScaleFactor.Apply(5) + I), AColor);
        ACanvas.Line(Point(ACenter.X + I, ACenter.Y - AScaleFactor.Apply(3) + I),
          Point(ACenter.X + I, ACenter.Y - AScaleFactor.Apply(5) + I), AColor);
      end;
    adDown:
      for I := 0 to AScaleFactor.Apply(3) do
      begin
        ACanvas.Line(Point(ACenter.X - I, ACenter.Y + AScaleFactor.Apply(2) - I ),
          Point(ACenter.X - I, ACenter.Y + AScaleFactor.Apply(4) - I), AColor);
        ACanvas.Line(Point(ACenter.X + I, ACenter.Y + AScaleFactor.Apply(2) - I),
          Point(ACenter.X + I, ACenter.Y + AScaleFactor.Apply(4) - I), AColor);
      end;
    adLeft:
      for I := 0 to AScaleFactor.Apply(3) do
      begin
        ACanvas.Line(Point(ACenter.X - AScaleFactor.Apply(3) + I, ACenter.Y - I),
          Point(ACenter.X - AScaleFactor.Apply(5) + I, ACenter.Y - I), AColor);
        ACanvas.Line(Point(ACenter.X - AScaleFactor.Apply(3) + I, ACenter.Y + I),
          Point(ACenter.X - AScaleFactor.Apply(5) + I, ACenter.Y + I), AColor);
      end;
  else {adRight}
    for I := 0 to AScaleFactor.Apply(3) do
    begin
      ACanvas.Line(Point(ACenter.X + AScaleFactor.Apply(2) - I, ACenter.Y - I),
        Point(ACenter.X + AScaleFactor.Apply(4) - I, ACenter.Y - I), AColor);
      ACanvas.Line(Point(ACenter.X + AScaleFactor.Apply(2) - I, ACenter.Y + I),
        Point(ACenter.X + AScaleFactor.Apply(4) - I, ACenter.Y + I), AColor);
    end;
  end;
end;

function TcxCustomLookAndFeelPainter.GetScaledSplitterSize(AHorizontal: Boolean; AScaleFactor: TdxScaleFactor): TSize;
begin
  if AHorizontal then
    Result := Size(17, 2)
  else
    Result := Size(2, 17);

  Result := AScaleFactor.Apply(Result);
end;

function TcxCustomLookAndFeelPainter.GetSplitterSize(AHorizontal: Boolean): TSize;
begin
  Result := GetScaledSplitterSize(AHorizontal, dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.HasSplitterInnerLine(AHorizontal: Boolean; AScaleFactor: TdxScaleFactor): Boolean;
var
  ASplitterSize: TSize;
begin
  ASplitterSize := GetScaledSplitterSize(AHorizontal, AScaleFactor);
  Result := (AHorizontal and (ASplitterSize.cy > 1)) or (not AHorizontal and (ASplitterSize.cx > 1));
end;

function TcxCustomLookAndFeelPainter.GetWindowContentTextColor: TColor;
begin
  Result := clBtnText;
end;

function TcxCustomLookAndFeelPainter.GetScaledZoomInButtonSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  Result := AScaleFactor.Apply(Size(ZoomButtonWidth, ZoomButtonHeight));
end;

function TcxCustomLookAndFeelPainter.GetScaledZoomOutButtonSize(AScaleFactor: TdxScaleFactor): TSize;
begin
  Result := AScaleFactor.Apply(Size(ZoomButtonWidth, ZoomButtonHeight));
end;

function TcxCustomLookAndFeelPainter.GetZoomInButtonSize: TSize;
begin
  Result := GetScaledZoomInButtonSize(dxSystemScaleFactor)
end;

function TcxCustomLookAndFeelPainter.GetZoomOutButtonSize: TSize;
begin
  Result := GetScaledZoomOutButtonSize(dxSystemScaleFactor)
end;

procedure TcxCustomLookAndFeelPainter.DrawZoomInButton(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState);
begin
  DrawScaledZoomInButton(ACanvas, R, AState, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawZoomOutButton(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState);
begin
  DrawScaledZoomOutButton(ACanvas, R, AState, dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.LayoutControlEmptyAreaColor: TColor;
begin
  Result := clBtnFace;
end;

function TcxCustomLookAndFeelPainter.LayoutControlGetColorPaletteForGroupButton(AState: TcxButtonState): IdxColorPalette;
begin
  Result := nil;
end;

function TcxCustomLookAndFeelPainter.LayoutControlGetColorPaletteForItemCaption: IdxColorPalette;
begin
  Result := nil;
end;

function TcxCustomLookAndFeelPainter.LayoutControlGetColorPaletteForTabbedGroupCaption(AIsActive: Boolean): IdxColorPalette;
begin
  Result := nil;
end;

procedure TcxCustomLookAndFeelPainter.DrawLayoutControlBackground(ACanvas: TcxCanvas; const R: TRect);
begin
  ACanvas.FillRect(R, LayoutControlEmptyAreaColor);
end;

procedure TcxCustomLookAndFeelPainter.DrawScrollBoxBackground(ACanvas: TcxCanvas; const R: TRect; AColor: TColor);
begin
  ACanvas.FillRect(R, AColor);
end;

function TcxCustomLookAndFeelPainter.PrintPreviewBackgroundTextColor: TColor;
begin
  Result := clWindowText;
end;

function TcxCustomLookAndFeelPainter.PrintPreviewPageBordersWidth: TRect;
begin
  Result := PrintPreviewPageBordersScaledWidth(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.PrintPreviewPageBordersScaledWidth(AScaleFactor: TdxScaleFactor): TRect;
begin
  Result := Rect(2, 2, 4, 4);
end;

procedure TcxCustomLookAndFeelPainter.DrawPrintPreviewBackground(
  ACanvas: TcxCanvas; const R: TRect);
begin
  DrawPrintPreviewScaledBackground(ACanvas, R, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawPrintPreviewScaledBackground(ACanvas: TcxCanvas; const R: TRect;
  AScaleFactor: TdxScaleFactor);
begin
  ACanvas.FillRect(R, clBtnShadow);
end;

procedure TcxCustomLookAndFeelPainter.DrawPrintPreviewPageBackground(
  ACanvas: TcxCanvas; const ABorderRect, AContentRect: TRect;
  ASelected, ADrawContent: Boolean);
begin
  DrawPrintPreviewPageScaledBackground(ACanvas, ABorderRect, AContentRect, ASelected, ADrawContent, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawPrintPreviewPageScaledBackground(ACanvas: TcxCanvas;
  const ABorderRect, AContentRect: TRect; ASelected, ADrawContent: Boolean; AScaleFactor: TdxScaleFactor);
const
  FrameColorMap: array[Boolean] of TColor = (clWindowText, clHighlight);
var
  R: TRect;
begin
  ACanvas.SaveClipRegion;
  try
    R := cxRectInflate(ABorderRect, TRect.Create(0, 0, -2, -2));
    if ADrawContent then
      ACanvas.FillRect(AContentRect, clWindow);
    if not ASelected then
      InflateRect(R, -1, -1);
    ACanvas.ExcludeClipRect(AContentRect);
    ACanvas.FillRect(R, FrameColorMap[ASelected]);
    ACanvas.ExcludeClipRect(R);
    R.Offset(2, 2);
    ACanvas.FillRect(R, clWindowText);
  finally
    ACanvas.RestoreClipRegion;
  end;
end;

function TcxCustomLookAndFeelPainter.CalcEditButtonTextColor(
  AButtonKind: TcxCalcButtonKind): TColor;
const
  BtnColors : array [TcxCalcButtonKind] of TColor = (
    clMaroon, clMaroon, clMaroon, clRed, clRed, clRed, clRed, clBlue, clBlue,
    clBlue, clBlue, clBlue, clBlue, clBlue, clBlue, clBlue, clBlue, clBlue,
    clBlue, clRed, clRed, clRed, clRed, clNavy, clNavy, clNavy, clRed, clBlue);
begin
  Result := BtnColors[AButtonKind];
end;

function TcxCustomLookAndFeelPainter.GetCustomizationFormListBackgroundColor: TColor;
begin
  Result := clBtnFace;
end;

procedure TcxCustomLookAndFeelPainter.DrawMessageBox(ACanvas: TcxCanvas;
  const ABounds: TRect; const AMessage: string; AFont: TFont = nil; AColor: TColor = clNone);
begin
  ACanvas.FrameRect(ABounds, DefaultGridLineColor, 1, cxBordersAll, True);
  if AColor = clNone then
    AColor := DefaultGroupColor;
  ACanvas.FillRect(ABounds, AColor);
  if AFont <> nil then
    ACanvas.Font := AFont;
  ACanvas.Brush.Style := bsClear;
  ACanvas.DrawTexT(AMessage, ABounds, cxAlignCenter or cxSingleLine);
  ACanvas.Brush.Style := bsSolid;
end;

function TcxCustomLookAndFeelPainter.BreadcrumbEditBackgroundColor(
  AState: TdxBreadcrumbEditState): TColor;
begin
  Result := clBtnFace;
end;

function TcxCustomLookAndFeelPainter.BreadcrumbEditBordersSize: TRect;
begin
  Result := cxSimpleRect;
end;

function TcxCustomLookAndFeelPainter.BreadcrumbEditScaledButtonAreaSeparatorSize(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := 2;
end;

function TcxCustomLookAndFeelPainter.BreadcrumbEditButtonAreaSeparatorSize: Integer;
begin
  Result := BreadcrumbEditScaledButtonAreaSeparatorSize(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.BreadcrumbEditButtonContentOffsets(AIsFirst, AIsLast: Boolean): TRect;
begin
  Result := BreadcrumbEditScaledButtonContentOffsets(AIsFirst, AIsLast, dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.BreadcrumbEditButtonColorPalette(AState: TdxBreadcrumbEditButtonState): IdxColorPalette;
begin
  Result := nil;
end;

function TcxCustomLookAndFeelPainter.BreadcrumbEditScaledButtonContentOffsets(
  AIsFirst, AIsLast: Boolean; AScaleFactor: TdxScaleFactor): TRect;
begin
  Result.Init(AScaleFactor.Apply(3));
end;

function TcxCustomLookAndFeelPainter.BreadcrumbEditScaledDropDownButtonWidth(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := dxGetSystemMetrics(SM_CXHSCROLL, AScaleFactor);
end;

function TcxCustomLookAndFeelPainter.BreadcrumbEditDropDownButtonWidth: Integer;
begin
  Result := BreadcrumbEditScaledDropDownButtonWidth(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.BreadcrumbEditIsFadingSupports: Boolean;
begin
  Result := False;
end;

function TcxCustomLookAndFeelPainter.BreadcrumbEditScaledNodeDelimiterSize(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := AScaleFactor.Apply(16);
end;

function TcxCustomLookAndFeelPainter.BreadcrumbEditNodeDelimiterSize: Integer;
begin
  Result := BreadcrumbEditScaledNodeDelimiterSize(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.BreadcrumbEditNodeTextColor(
  AState: TdxBreadcrumbEditButtonState): TColor;
begin
  if AState = dxbcbsDisabled then
    Result := ButtonSymbolColor(cxbsDisabled)
  else
    Result := ButtonSymbolColor(cxbsNormal);
end;

function TcxCustomLookAndFeelPainter.BreadcrumbEditScaledNodeTextOffsets(AScaleFactor: TdxScaleFactor): TRect;
begin
  Result.Init(AScaleFactor.Apply(4));
end;

function TcxCustomLookAndFeelPainter.BreadcrumbEditNodeTextOffsets: TRect;
begin
  Result := BreadcrumbEditScaledNodeTextOffsets(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.BreadcrumbEditScaledProgressChunkPadding(AScaleFactor: TdxScaleFactor): TRect;
begin
  Result := cxSimpleRect;
end;

function TcxCustomLookAndFeelPainter.BreadcrumbEditProgressChunkPadding: TRect;
begin
  Result := BreadcrumbEditScaledProgressChunkPadding(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.BreadcrumbEditProgressChunkTextColor: TColor;
begin
  Result := clDefault;
end;

function TcxCustomLookAndFeelPainter.BreadcrumbEditScaledProgressChunkOverlaySize(AScaleFactor: TdxScaleFactor): TSize;
begin
  Result := cxNullSize;
end;

function TcxCustomLookAndFeelPainter.BreadcrumbEditProgressChunkOverlaySize: TSize;
begin
  Result := BreadcrumbEditScaledProgressChunkOverlaySize(dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawBreadcrumbEditBorders(ACanvas: TcxCanvas;
  const ARect: TRect; ABorders: TcxBorders; AState: TdxBreadcrumbEditState);
begin
  ACanvas.DrawComplexFrame(ARect, clBtnShadow, clBtnHighlight, ABorders);
end;

procedure TcxCustomLookAndFeelPainter.DrawBreadcrumbEditScaledButtonAreaSeparator(
  ACanvas: TcxCanvas; const ARect: TRect; AState: TdxBreadcrumbEditState; AScaleFactor: TdxScaleFactor);
begin
  // do nothing
end;

procedure TcxCustomLookAndFeelPainter.DrawBreadcrumbEditButtonAreaSeparator(
  ACanvas: TcxCanvas; const ARect: TRect; AState: TdxBreadcrumbEditState);
begin
  DrawBreadcrumbEditScaledButtonAreaSeparator(ACanvas, ARect, AState, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawBreadcrumbEditButton(
  ACanvas: TcxCanvas; const ARect: TRect; AState: TdxBreadcrumbEditButtonState; AIsFirst, AIsLast: Boolean);
begin
  DrawBreadcrumbEditScaledButton(ACanvas, ARect, AState, AIsFirst, AIsLast, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawBreadcrumbEditScaledButton(ACanvas: TcxCanvas; const ARect: TRect;
  AState: TdxBreadcrumbEditButtonState; AIsFirst, AIsLast: Boolean; AScaleFactor: TdxScaleFactor);
begin
  if not (AState in [dxbcbsNormal, dxbcbsDisabled]) then
    DrawScaledButton(ACanvas, ARect, BreadcrumbButtonStateToButtonState[AState], AScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawBreadcrumbEditScaledDropDownButton(ACanvas: TcxCanvas;
  const ARect: TRect; AState: TdxBreadcrumbEditButtonState; AIsInEditor: Boolean; AScaleFactor: TdxScaleFactor);
begin
  if AIsInEditor then
    DrawScaledButton(ACanvas, ARect, BreadcrumbButtonStateToButtonState[AState], AScaleFactor)
  else
    DrawBreadcrumbEditScaledButton(ACanvas, ARect, AState, True, True, AScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawBreadcrumbEditDropDownButton(
  ACanvas: TcxCanvas; const ARect: TRect; AState: TdxBreadcrumbEditButtonState; AIsInEditor: Boolean);
begin
  DrawBreadcrumbEditScaledDropDownButton(ACanvas, ARect, AState, AIsInEditor, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawBreadcrumbEditScaledDropDownButtonGlyph(ACanvas: TcxCanvas;
  const ARect: TRect; AState: TdxBreadcrumbEditButtonState; AIsInEditor: Boolean; AScaleFactor: TdxScaleFactor);
begin
  DrawButtonArrow(ACanvas, cxRectInflate(ARect, -AScaleFactor.Apply(cxTextOffset)),
    ButtonSymbolColor(BreadcrumbButtonStateToButtonState[AState]));
end;

procedure TcxCustomLookAndFeelPainter.DrawBreadcrumbEditDropDownButtonGlyph(
  ACanvas: TcxCanvas; const ARect: TRect; AState: TdxBreadcrumbEditButtonState; AIsInEditor: Boolean);
begin
  DrawBreadcrumbEditScaledDropDownButtonGlyph(ACanvas, ARect, AState, AIsInEditor, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawBreadcrumbEditScaledNode(ACanvas: TcxCanvas; const R: TRect;
  AState: TdxBreadcrumbEditButtonState; AHasDelimiter: Boolean; AScaleFactor: TdxScaleFactor);
begin
  DrawBreadcrumbEditScaledButton(ACanvas, R, AState, False, AHasDelimiter, AScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawBreadcrumbEditNode(ACanvas: TcxCanvas;
  const R: TRect; AState: TdxBreadcrumbEditButtonState; AHasDelimiter: Boolean);
begin
  DrawBreadcrumbEditScaledNode(ACanvas, R, AState, AHasDelimiter, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawBreadcrumbEditScaledNodeDelimiter(
  ACanvas: TcxCanvas; const R: TRect; AState: TdxBreadcrumbEditButtonState; AScaleFactor: TdxScaleFactor);
begin
  DrawBreadcrumbEditScaledButton(ACanvas, R, AState, False, False, AScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawBreadcrumbEditNodeDelimiter(
  ACanvas: TcxCanvas; const R: TRect; AState: TdxBreadcrumbEditButtonState);
begin
  DrawBreadcrumbEditScaledNodeDelimiter(ACanvas, R, AState, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawBreadcrumbEditScaledNodeDelimiterGlyph(
  ACanvas: TcxCanvas; const R: TRect; AState: TdxBreadcrumbEditButtonState;
  AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault);
begin
  if AColor = clDefault then
    AColor := BreadcrumbEditNodeTextColor(AState);
  DrawArrow(ACanvas, R, adDown, AColor);
end;

procedure TcxCustomLookAndFeelPainter.DrawBreadcrumbEditNodeDelimiterGlyph(
  ACanvas: TcxCanvas; const R: TRect; AState: TdxBreadcrumbEditButtonState);
begin
  DrawBreadcrumbEditScaledNodeDelimiterGlyph(ACanvas, R, AState, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawBreadcrumbEditNodeMoreButtonGlyph(
  ACanvas: TcxCanvas; const R: TRect; AState: TdxBreadcrumbEditButtonState);
begin
  DrawBreadcrumbEditScaledNodeMoreButtonGlyph(ACanvas, R, AState, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawBreadcrumbEditScaledNodeMoreButtonGlyph(
  ACanvas: TcxCanvas; const R: TRect; AState: TdxBreadcrumbEditButtonState;
  AScaleFactor: TdxScaleFactor; AColor: TColor = clDefault);
begin
  DrawBreadcrumbEditScaledNodeDelimiterGlyph(ACanvas, R, AState, AScaleFactor, AColor);
end;

procedure TcxCustomLookAndFeelPainter.DrawBreadcrumbEditScaledProgressChunk(
  ACanvas: TcxCanvas; const R: TRect; AScaleFactor: TdxScaleFactor);
begin
  ACanvas.FillRect(R, $AAA8A4);
end;

procedure TcxCustomLookAndFeelPainter.DrawBreadcrumbEditProgressChunk(ACanvas: TcxCanvas; const R: TRect);
begin
  DrawBreadcrumbEditScaledProgressChunk(ACanvas, R, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawBreadcrumbEditScaledProgressChunkOverlay(
  ACanvas: TcxCanvas; const R: TRect; AScaleFactor: TdxScaleFactor);
begin
  // do nothing
end;

procedure TcxCustomLookAndFeelPainter.DrawBreadcrumbEditProgressChunkOverlay(ACanvas: TcxCanvas; const R: TRect);
begin
  DrawBreadcrumbEditScaledProgressChunkOverlay(ACanvas, R, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawDropDownListBoxBackground(
  ACanvas: TcxCanvas; const ARect: TRect; AHasBorders: Boolean);
var
  R: TRect;
begin
  R := ARect;
  if AHasBorders then
  begin
    ACanvas.DrawComplexFrame(R, cl3DLight, cl3DDkShadow);
    R.Inflate(-1, -1);
    ACanvas.DrawComplexFrame(R, clBtnHighlight, clBtnShadow);
    R.Inflate(-1, -1);
  end;
  ACanvas.FillRect(R, clMenu);
end;

procedure TcxCustomLookAndFeelPainter.DrawDropDownListBoxScaledGutterBackground(
  ACanvas: TcxCanvas; const ARect: TRect; AScaleFactor: TdxScaleFactor);
begin
  // do nothing
end;

procedure TcxCustomLookAndFeelPainter.DrawDropDownListBoxGutterBackground(ACanvas: TcxCanvas; const ARect: TRect);
begin
  DrawDropDownListBoxScaledGutterBackground(ACanvas, ARect, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawDropDownListBoxScaledSelection(
  ACanvas: TcxCanvas; const ARect, AGutterRect: TRect; AScaleFactor: TdxScaleFactor);
begin
  ACanvas.FillRect(ARect, clMenuHighlight);
end;

procedure TcxCustomLookAndFeelPainter.DrawDropDownListBoxSelection(ACanvas: TcxCanvas; const ARect, AGutterRect: TRect);
begin
  DrawDropDownListBoxScaledSelection(ACanvas, ARect, AGutterRect, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawDropDownListBoxSeparator(ACanvas: TcxCanvas; const ARect, AGutterRect: TRect);
begin
  DrawDropDownListBoxScaledSeparator(ACanvas, ARect, AGutterRect, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawDropDownListBoxScaledSeparator(
  ACanvas: TcxCanvas; const ARect, AGutterRect: TRect; AScaleFactor: TdxScaleFactor);
begin
  ACanvas.DrawComplexFrame(cxRectCenterVertically(ARect, 2), clBtnShadow, clBtnHighlight, [bTop, bBottom]);
end;

function TcxCustomLookAndFeelPainter.DropDownListBoxItemImageOffsets: TRect;
begin
  Result := DropDownListBoxScaledItemImageOffsets(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.DropDownListBoxScaledItemImageOffsets(AScaleFactor: TdxScaleFactor): TRect;
begin
  Result := AScaleFactor.Apply(TRect.Create(5, 3, 5, 3));
end;

function TcxCustomLookAndFeelPainter.DropDownListBoxItemTextColor(ASelected: Boolean): TColor;
begin
  if ASelected then
    Result := clHighlightText
  else
    Result := clMenuText;
end;

function TcxCustomLookAndFeelPainter.DropDownListBoxScaledItemTextOffsets(AScaleFactor: TdxScaleFactor): TRect;
begin
  Result := AScaleFactor.Apply(TRect.Create(5, cxTextOffset, 5, cxTextOffset));
end;

function TcxCustomLookAndFeelPainter.DropDownListBoxItemTextOffsets: TRect;
begin
  Result := DropDownListBoxScaledItemTextOffsets(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.DropDownListBoxScaledSeparatorSize(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := AScaleFactor.Apply(8);
end;

function TcxCustomLookAndFeelPainter.DropDownListBoxSeparatorSize: Integer;
begin
  Result := DropDownListBoxScaledSeparatorSize(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.DropDownListBoxBordersSize: Integer;
begin
  Result := 3;
end;

function TcxCustomLookAndFeelPainter.ActiveColorPalette: IdxColorPalette;
begin
  Result := nil;
end;

function TcxCustomLookAndFeelPainter.AlertWindowButtonContentOffsets(AKind: TdxAlertWindowButtonKind): TRect;
begin
  Result := AlertWindowScaledButtonContentOffsets(AKind, dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.AlertWindowScaledButtonContentOffsets(
  AKind: TdxAlertWindowButtonKind; AScaleFactor: TdxScaleFactor): TRect;
begin
  Result.Init(AScaleFactor.Apply(3));
end;

function TcxCustomLookAndFeelPainter.AlertWindowButtonGlyphSize(AKind: TdxAlertWindowButtonKind): TSize;
begin
  Result := AlertWindowScaledButtonGlyphSize(AKind, dxSystemScaleFactor)
end;

function TcxCustomLookAndFeelPainter.AlertWindowButtonGetColorPalette(AState: TcxButtonState): IdxColorPalette;
begin
  Result := ButtonColorPalette(AState);
end;

function TcxCustomLookAndFeelPainter.AlertWindowScaledButtonGlyphSize(
  AKind: TdxAlertWindowButtonKind; AScaleFactor: TdxScaleFactor): TSize;
begin
  if AKind <> awbkCustom then
    Result.Init(AScaleFactor.Apply(10))
  else
    Result := cxNullSize;
end;

function TcxCustomLookAndFeelPainter.AlertWindowScaledContentOffsets(AScaleFactor: TdxScaleFactor): TRect;
begin
  Result.Init(AScaleFactor.Apply(4));
end;

function TcxCustomLookAndFeelPainter.AlertWindowContentOffsets: TRect;
begin
  Result := AlertWindowScaledContentOffsets(dxSystemScaleFactor);
end;

function TcxCustomLookAndFeelPainter.AlertWindowCornerRadius: Integer;
begin
  Result := 0;
end;

function TcxCustomLookAndFeelPainter.AlertWindowNavigationPanelTextColor: TColor;
begin
  Result := AlertWindowTextColor;
end;

function TcxCustomLookAndFeelPainter.AlertWindowTextColor: TColor;
begin
  Result := clBtnText;
end;

procedure TcxCustomLookAndFeelPainter.DrawAlertWindowBackground(
  ACanvas: TcxCanvas; const ABounds: TRect; AScaleFactor: TdxScaleFactor = nil);
begin
  ACanvas.FillRect(ABounds, clBtnFace);
  ACanvas.Canvas.RoundRect(ABounds.Left, ABounds.Top, ABounds.Right, ABounds.Bottom,
    AlertWindowCornerRadius, AlertWindowCornerRadius);
end;

procedure TcxCustomLookAndFeelPainter.DrawAlertWindowButton(ACanvas: TcxCanvas; const ABounds: TRect;
  AState: TcxButtonState; AKind: TdxAlertWindowButtonKind; ADown: Boolean = False);
begin
  DrawAlertWindowScaledButton(ACanvas, ABounds, AState, AKind, dxSystemScaleFactor, ADown);
end;

procedure TcxCustomLookAndFeelPainter.DrawAlertWindowScaledButton(ACanvas: TcxCanvas; const ABounds: TRect;
  AState: TcxButtonState; AKind: TdxAlertWindowButtonKind; AScaleFactor: TdxScaleFactor; ADown: Boolean = False);
var
  R: TRect;
begin
  if ADown then
    AState := cxbsPressed;
  DrawScaledButton(ACanvas, ABounds, AState, AScaleFactor);
  R := cxRectContent(ABounds, AlertWindowScaledButtonContentOffsets(AKind, AScaleFactor));
  case AKind of
    awbkClose:
      DrawScaledButtonCross(ACanvas, R, ButtonSymbolColor(AState), AState, AScaleFactor);
    awbkPin:
      DrawPin(ACanvas, R, ButtonSymbolColor(AState), ADown);
    awbkDropdown:
      DrawArrow(ACanvas, R, adDown, ButtonSymbolColor(AState));
    awbkPrevious:
      DrawArrow(ACanvas, R, adLeft, ButtonSymbolColor(AState));
    awbkNext:
      DrawArrow(ACanvas, R, adRight, ButtonSymbolColor(AState));
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawAlertWindowNavigationPanel(ACanvas: TcxCanvas; const ABounds: TRect);
begin
  ACanvas.FrameRect(ABounds, clBtnShadow, 1, cxBordersAll);
end;

procedure TcxCustomLookAndFeelPainter.DrawPin(ACanvas: TcxCanvas; const ABounds: TRect; AColor: TColor; APinned: Boolean);

  function GetElementSize(AElementIndex: Integer): TSize;
  const
    SizeMap: array[0..2, 0..1] of Single = ((0.5, 0.5), (0.9, 0.1), (0.1, 0.5));
  begin
    Result.cx := 2 * Trunc((SizeMap[AElementIndex, 0] * ABounds.Width) / 2) + 1;
    Result.cy := Round(SizeMap[AElementIndex, 1] * ABounds.Height);
  end;

var
  R: TRect;
  S: TSize;
  I: Integer;
begin
  R := Rect(ABounds.Right - 1, 0, 0, ABounds.Top + 1);
  for I := 0 to 2 do
  begin
    S := GetElementSize(I);
    if APinned then
      R := cxRectCenterHorizontally(cxRectSetTop(ABounds, R.Bottom - 1, S.cy), S.cx)
    else
      R := cxRectCenterVertically(cxRectSetRight(ABounds, R.Left + 1, S.cy), S.cx);
    if I = 0 then
    begin
      ACanvas.FrameRect(R, AColor);
      if APinned then
        ACanvas.FillRect(cxRectSetRight(R, R.Right, R.Width div 2), AColor)
      else
        ACanvas.FillRect(cxRectSetBottom(R, R.Bottom, R.Height div 2), AColor);
    end
    else
      ACanvas.FillRect(R, AColor);
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawShellQuickAccessPin(ACanvas: TcxCanvas; const R: TRect; AImageFitMode: TcxImageFitMode;
  APalette: IdxColorPalette);
begin
  TdxImageDrawer.DrawImage(ACanvas, R, PinGlyph, ifmFit, APalette);
end;

procedure TcxCustomLookAndFeelPainter.DrawScaledExpandMark(ACanvas: TcxCustomCanvas;
  const R: TRect; AColor: TColor; AExpanded: Boolean; AScaleFactor: TdxScaleFactor);
var
  ASize, X, MainY, I: Integer;

  procedure DrawOneMark(Y: Integer);
  var
    APoints: array[0..2] of TPoint;
    ADelta: Integer;
    ASign: Integer;
  begin
    if AExpanded then Inc(Y, ASize);
    ASign := 2 * Ord(AExpanded) - 1;
    ADelta := Ord(Odd(I - MainY));
    if not AExpanded then
      ADelta := Ord(not Boolean(ADelta));
    APoints[0] := Point(X + ADelta, Y - ASign * ADelta);
    APoints[1] := Point(X + ASize, Y - ASign * ASize);
    APoints[2] := Point(X + 2 * ASize + 1 - ADelta, Y + ASign * (1 - ADelta));
    ACanvas.Polyline(APoints, AColor);
  end;

begin
  ASize := AScaleFactor.Apply(3);
  X := (R.Left + R.Right - (2 * ASize + 1)) div 2;
  MainY := (R.Top + R.Bottom - 2 * (ASize + 1)) div 2;
  for I := MainY to MainY + 4 - 1 do
    DrawOneMark(I + Ord(I >= MainY + 2) * (ASize - 1));
end;

procedure TcxCustomLookAndFeelPainter.DrawExpandMark(ACanvas: TcxCanvas; const R: TRect; AColor: TColor; AExpanded: Boolean);
begin
  DrawScaledExpandMark(ACanvas, R, AColor, AExpanded, dxSystemScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawRangeControlThumb(ACanvas: TcxCanvas;
  const ARect: TRect; AColor: TColor; ABorderColor: TdxAlphaColor; AScaleFactor: TdxScaleFactor);
const
  ThumbBackColor = $FFFFFF;
var
  R: TRect;
  APoint1: TPoint;
  APoint2: TPoint;
begin
  if AColor = clDefault then
    AColor := ThumbBackColor;
  dxGPPaintCanvas.BeginPaint(ACanvas.Handle, ARect);
  try
    dxGPPaintCanvas.Rectangle(ARect, ABorderColor, dxColorToAlphaColor(AColor));
    R := cxRectCenter(ARect, Size(AScaleFactor.Apply(2) * 2 + 1, ARect.Height - AScaleFactor.Apply(8)));

    APoint1 := R.TopLeft;
    APoint2 := Point(R.Left, R.Bottom - 1);
    dxGPPaintCanvas.Line(APoint1.X, APoint1.Y, APoint2.X, APoint2.Y, ABorderColor, AScaleFactor.ApplyF(1));

    APoint1 := cxPointOffset(APoint1, AScaleFactor.Apply(2), 0);
    APoint2 := cxPointOffset(APoint2, AScaleFactor.Apply(2), 0);
    dxGPPaintCanvas.Line(APoint1.X, APoint1.Y, APoint2.X, APoint2.Y, ABorderColor, AScaleFactor.ApplyF(1));

    APoint1 := cxPointOffset(APoint1, AScaleFactor.Apply(2), 0);
    APoint2 := cxPointOffset(APoint2, AScaleFactor.Apply(2), 0);
    dxGPPaintCanvas.Line(APoint1.X, APoint1.Y, APoint2.X, APoint2.Y, ABorderColor, AScaleFactor.ApplyF(1));
  finally
    dxGPPaintCanvas.EndPaint;
  end;
end;

function TcxCustomLookAndFeelPainter.DefaultGanttCurrentDateGridLineColor: TColor;
begin
  Result := $32CD32;
end;

function TcxCustomLookAndFeelPainter.DefaultGanttProjectStartGridLineColor: TColor;
var
  AColor: TColor;
begin
  AColor := ColorToRgb(DefaultContentTextColor);
  Result := RGB(
    MulDiv(GetRValue(AColor), 80, 100),
    MulDiv(GetGValue(AColor), 80, 100),
    MulDiv(GetBValue(AColor), 80, 100));
end;

function TcxCustomLookAndFeelPainter.DefaultGanttProjectFinishGridLineColor: TColor;
begin
  Result := DefaultGanttProjectStartGridLineColor;
end;

procedure TcxCustomLookAndFeelPainter.DoDrawGanttSummaryTaskProgress(ACanvas: TcxCustomCanvas; const R: TRect;
  AScaleFactor: TdxScaleFactor;
  const AColor: TColor = clDefault);
var
  AActualColor: TColor;
  AWidth: Integer;
  ARect: TRect;
begin
  AActualColor := cxGetActualColor(AColor, clBtnHighlight);
  AWidth := AScaleFactor.Apply(3);
  ACanvas.FillRect(cxRectSetHeight(R, AWidth), AActualColor, 128);
  ARect := cxRectInflate(R, 0, -AWidth, 0, 0);
  ACanvas.FillRect(cxRectSetLeft(ARect, ARect.Left, AWidth), AActualColor, 128);
  ACanvas.FillRect(cxRectSetRight(ARect, ARect.Right, AWidth), AActualColor, 128);
end;

procedure TcxCustomLookAndFeelPainter.DoDrawGanttTaskProgress(ACanvas: TcxCustomCanvas; const R: TRect;
  const AColor: TColor = clDefault);
begin
  ACanvas.FillRect(R, cxGetActualColor(AColor, clBtnHighlight), 128);
end;

procedure TcxCustomLookAndFeelPainter.DrawGanttBaselineMilestone(ACanvas: TcxCustomCanvas; const R: TRect; AScaleFactor: TdxScaleFactor; const AColor: TColor = clDefault);
var
  AActualColor: TColor;
  APoints: TPoints;
begin
  APoints := cxGetSchedulerMilestonePolygon(cxRectCenter(R, AScaleFactor.Apply(GetGanttBaselineMilestoneSize)));
  try
    SetLength(APoints, 5);
    APoints[4] := APoints[0];
    AActualColor := cxGetActualColor(AColor, clBtnShadow);
    ACanvas.Polyline(APoints, AActualColor);
  finally
    SetLength(APoints, 0);
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawGanttBaselineSummaryTask(ACanvas: TcxCustomCanvas; const R: TRect; AScaleFactor: TdxScaleFactor; const AColor: TColor = clDefault);
var
  AActualColor: TColor;
  AWidth: Integer;
  ARect: TRect;
begin
  AActualColor := cxGetActualColor(AColor, clBtnShadow);
  AWidth := AScaleFactor.Apply(3);
  ACanvas.FillRect(cxRectSetBottom(cxRectSetHeight(R, AWidth), R.Bottom), AActualColor, 128);
  ARect := cxRectInflate(R, 0, 0, 0, -AWidth);
  ACanvas.FillRect(cxRectSetLeft(ARect, ARect.Left, AWidth), AActualColor, 128);
  ACanvas.FillRect(cxRectSetRight(ARect, ARect.Right, AWidth), AActualColor, 128);
end;

procedure TcxCustomLookAndFeelPainter.DrawGanttBaselineTask(ACanvas: TcxCustomCanvas; const R: TRect; const AColor: TColor = clDefault);
begin
  ACanvas.FillRect(R, cxGetActualColor(AColor, clBtnShadow), 128);
end;

procedure TcxCustomLookAndFeelPainter.DrawGanttDependencyEditPoint(ACanvas: TcxCustomCanvas; const R: TRect;
  const AState: TcxButtonState; const AIsLeft: Boolean);
begin
  case AState of
    cxbsNormal:
      ACanvas.FillRect(R, clBtnFace);
    cxbsHot:
      ACanvas.FillRect(R, clBtnHighlight, 128);
    cxbsPressed:
      ACanvas.FillRect(R, clBtnHighlight);
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawGanttFocusedRow(ACanvas: TcxCustomCanvas; const R: TRect;
  const AIsActive: Boolean = True);
begin
  ACanvas.FillRect(R, clBtnShadow, 32);
end;

procedure TcxCustomLookAndFeelPainter.DrawGanttSheetHeader(ACanvas: TcxCustomCanvas; const ABounds: TRect;
  AState: TcxButtonState; ANeighbors: TcxNeighbors; ABorders: TcxBorders; AScaleFactor: TdxScaleFactor);
begin
  DrawSpreadSheetScaledHeader(ACanvas, ABounds, ANeighbors, ABorders, AState, AScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawGanttMilestone(ACanvas: TcxCustomCanvas; const R: TRect;
  AScaleFactor: TdxScaleFactor;
  const AColor: TColor = clDefault);
var
  AActualColor: TColor;
  APoints: TPoints;
begin
  APoints := cxGetSchedulerMilestonePolygon(cxRectCenter(R, AScaleFactor.Apply(GetGanttMilestoneSize)));
  try
    AActualColor := cxGetActualColor(AColor, clBtnFace);
    ACanvas.Polygon(APoints, AActualColor, AActualColor);
  finally
    SetLength(APoints, 0);
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawGanttSummaryTask(ACanvas: TcxCustomCanvas; const R: TRect;
  AScaleFactor: TdxScaleFactor;
  const AColor: TColor = clDefault);
var
  AActualColor: TColor;
  AWidth: Integer;
  ARect: TRect;
begin
  AActualColor := cxGetActualColor(AColor, clBtnFace);
  AWidth := AScaleFactor.Apply(3);
  ACanvas.FillRect(cxRectSetHeight(R, AWidth), AActualColor, 128);
  ARect := cxRectInflate(R, 0, -AWidth, 0, 0);
  ACanvas.FillRect(cxRectSetLeft(ARect, ARect.Left, AWidth), AActualColor, 128);
  ACanvas.FillRect(cxRectSetRight(ARect, ARect.Right, AWidth), AActualColor, 128);
end;

procedure TcxCustomLookAndFeelPainter.DrawGanttSummaryTaskProgress(ACanvas: TcxCustomCanvas;
  const ATaskRect, AProgressRect: TRect; AScaleFactor: TdxScaleFactor; const AColor: TColor = clDefault);
begin
  ACanvas.SaveClipRegion;
  try
    ACanvas.IntersectClipRect(AProgressRect);
    DoDrawGanttSummaryTaskProgress(ACanvas, ATaskRect, AScaleFactor, AColor);
  finally
    ACanvas.RestoreClipRegion;
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawGanttTask(ACanvas: TcxCustomCanvas; const R: TRect;
  const AColor: TColor = clDefault);
begin
  ACanvas.FillRect(R, cxGetActualColor(AColor, clBtnFace), 128);
end;

procedure TcxCustomLookAndFeelPainter.DrawGanttTaskProgress(ACanvas: TcxCustomCanvas;
  const ATaskRect, AProgressRect: TRect; const AColor: TColor = clDefault);
begin
  ACanvas.SaveClipRegion;
  try
    ACanvas.IntersectClipRect(AProgressRect);
    DoDrawGanttTaskProgress(ACanvas, ATaskRect, AColor);
  finally
    ACanvas.RestoreClipRegion;
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawGanttTaskTextLabel(ACanvas: TcxCustomCanvas; const R: TRect);
begin
  ACanvas.FrameRect(R, clBtnShadow);
end;

function TcxCustomLookAndFeelPainter.GetGanttDependencyEditPointSize(const AIsLeft: Boolean): TSize;
begin
  Result := Size(8, 8);
end;

function TcxCustomLookAndFeelPainter.GetGanttBaselineMilestoneSize: TSize;
begin
  Result := Size(10, 10);
end;

function TcxCustomLookAndFeelPainter.GetGanttBaselineSummaryTaskHeight: Integer;
begin
  Result := 10;
end;

function TcxCustomLookAndFeelPainter.GetGanttBaselineTaskHeight: Integer;
begin
  Result := 5;
end;

function TcxCustomLookAndFeelPainter.GetGanttMilestoneColor: TColor;
begin
  Result := $636363;
end;

function TcxCustomLookAndFeelPainter.GetGanttMilestoneSize: TSize;
begin
  Result := Size(10, 10);
end;

function TcxCustomLookAndFeelPainter.GetGanttSummaryTaskColor: TColor;
begin
  Result := $54545;
end;

function TcxCustomLookAndFeelPainter.GetGanttSummaryTaskHeight: Integer;
begin
  Result := 10;
end;

function TcxCustomLookAndFeelPainter.GetGanttTaskColor(AManualSchedule: Boolean): TColor;
begin
  if AManualSchedule then
    Result := $ADA32B
  else
    Result := $D7843B;
end;

function TcxCustomLookAndFeelPainter.GetGanttTaskHeight: Integer;
begin
  Result := 10;
end;

function TcxCustomLookAndFeelPainter.GetGanttTaskTextLabelOffset: Integer;
begin
  Result := 10;
end;

function TcxCustomLookAndFeelPainter.GetGanttTaskTextLabelHeight: Integer;
begin
  Result := 10;
end;

function TcxCustomLookAndFeelPainter.GetGanttTaskTextLabelTextBold: Boolean;
begin
  Result := False;
end;

function TcxCustomLookAndFeelPainter.GetGanttTaskTextLabelTextColor: TColor;
begin
  Result := clBtnText;
end;

procedure TcxCustomLookAndFeelPainter.DrawListViewItemBackground(ACanvas: TcxCustomCanvas;
   const ABounds: TRect; AState: TdxListViewItemStates; AExplorerStyle: Boolean);
const
  FrameColor = $CC0000;
  HotColor = $F6E1C7;
begin
  if dxlisHot in AState then
  begin
    if dxlisSelected in AState then
      ACanvas.Rectangle(ABounds, DefaultSelectionColor, FrameColor, psSolid)
    else
      ACanvas.FillRect(ABounds, HotColor);
  end
  else
    if dxlisSelected in AState then
      if dxlisInactive in AState then
        ACanvas.FillRect(ABounds, DefaultInactiveColor)
      else
        ACanvas.FillRect(ABounds, DefaultSelectionColor)
   else
     ACanvas.FillRect(ABounds, GridLikeControlContentColor);

  if (dxlisFocused in AState) and not (dxlisInactive in AState) then
  begin
    if AExplorerStyle then
    begin
      if not (dxlisHot in AState) then
        ACanvas.Rectangle(ABounds, clNone, FrameColor, psSolid);
    end
    else
      ACanvas.FocusRectangle(cxRectInflate(ABounds, -1));
  end;
end;

function TcxCustomLookAndFeelPainter.GetListViewExpandButtonSize(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := ScaledGroupExpandButtonSize(AScaleFactor);
end;

function TcxCustomLookAndFeelPainter.GetListViewColumnHeaderSortingMarkSize(AScaleFactor: TdxScaleFactor): TPoint;
begin
  Result := ScaledSortingMarkSize(AScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawListViewBackground(
  ACanvas: TcxCustomCanvas; ABounds: TRect; AExplorerStyle, AEnabled: Boolean);
var
  AColor: TColor;
begin
  if AExplorerStyle then
    AColor := GridLikeControlContentColor
  else
    AColor := DefaultEditorBackgroundColor(not AEnabled);

  ACanvas.FillRect(ABounds, cxGetActualColor(AColor, clWindow));
end;

procedure TcxCustomLookAndFeelPainter.DrawListViewCheckButton(ACanvas: TcxCustomCanvas;
  const ABounds: TRect; AState: TcxButtonState; AChecked: Boolean; AScaleFactor: TdxScaleFactor);
begin
  DrawScaledCheckButton(ACanvas, ABounds, AState, AChecked, AScaleFactor, False);
end;

procedure TcxCustomLookAndFeelPainter.DrawListViewSortingMark(ACanvas: TcxCustomCanvas;
  const R: TRect; AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor);
begin
  DrawListViewColumnHeaderSortingArrow(ACanvas, R, clBtnShadow, clBtnShadow, AAscendingSorting, AScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawListViewGroupExpandButton(ACanvas: TcxCustomCanvas;
  const ABounds: TRect; AState: TcxButtonState; AExpanded: Boolean; AExplorerStyle: Boolean; AScaleFactor: TdxScaleFactor);
begin
  WinExplorerViewDrawScaledRecordExpandButton(ACanvas, ABounds, AState, AExpanded, AScaleFactor);
end;

procedure TcxCustomLookAndFeelPainter.DrawListViewGroupHeaderBackground(ACanvas: TcxCustomCanvas;
  const ABounds: TRect; AState: TdxListViewGroupHeaderStates; AExplorerStyle: Boolean; AScaleFactor: TdxScaleFactor);
const
  FrameColor = $CC0000;
begin
  if dxlgsHot in AState then
    ACanvas.FillRect(ABounds, DefaultSelectionColor)
  else
    ACanvas.FillRect(ABounds, GridLikeControlContentColor);

  if dxlgsFocused in AState then
  begin
    if dxlgsInactive in AState then
      ACanvas.FocusRectangle(cxRectInflate(ABounds, -1))
    else
      if not (dxlgsHot in AState) then
        ACanvas.Rectangle(ABounds, clNone, FrameColor, psSolid);
  end;
end;

procedure TcxCustomLookAndFeelPainter.DrawListViewGroupHeaderLine(ACanvas: TcxCustomCanvas; const ABounds: TRect);
const
  LineColor = $FF953D;
begin
  ACanvas.FillRect(ABounds, LineColor);
end;

function TcxCustomLookAndFeelPainter.GetListViewItemColorPalette(AState: TdxListViewItemStates): IdxColorPalette;
begin
  Result := nil;
end;

function TcxCustomLookAndFeelPainter.GetListViewItemContentPadding: TRect;
var
  ABorderSize: Integer;
begin
  ABorderSize := BorderSize;
  Result.Init(ABorderSize, ABorderSize, ABorderSize, ABorderSize);
end;

function TcxCustomLookAndFeelPainter.GetListViewItemTextColor(AState: TdxListViewItemStates; AExplorerStyle: Boolean): TColor;
begin
  if dxlisSelected in AState then
    if  AState * [dxlisInactive, dxlisHot] = [dxlisInactive] then
      Result := DefaultInactiveTextColor
    else
      Result := DefaultSelectionTextColor
  else
    if dxlisHot in AState then
      Result := DefaultHotTrackTextColor
    else
      Result := cxGetActualColor(DefaultEditorTextColor(dxlisDisabled in AState), GridLikeControlContentTextColor);
end;

function TcxCustomLookAndFeelPainter.GetListViewColumnHeaderTextColor(AState: TcxButtonState; AExplorerStyle: Boolean): TColor;
begin
  Result := DefaultHeaderTextColor;
end;

function TcxCustomLookAndFeelPainter.GetListViewColumnHeaderColorPalette(AState: TcxButtonState): IdxColorPalette;
begin
  Result := nil;
end;

function TcxCustomLookAndFeelPainter.GetListViewColumnHeaderContentOffsets(AExplorerStyle: Boolean; AScaleFactor: TdxScaleFactor): TRect;
begin
  if AExplorerStyle then
  begin
    Result.Init(cxHeaderTextOffset * 2, cxHeaderTextOffset * 2, cxHeaderTextOffset * 2, cxHeaderTextOffset * 2);
    Result := AScaleFactor.Apply(Result);
  end
  else
    Result := HeaderContentOffsets(AScaleFactor);
end;

function TcxCustomLookAndFeelPainter.GetListViewGroupHeaderColorPalette(AState: TdxListViewGroupHeaderStates): IdxColorPalette;
begin
  Result := nil;
end;

function TcxCustomLookAndFeelPainter.GetListViewGroupTextColor(AKind: TdxListViewGroupTextKind;
  AState: TdxListViewGroupHeaderStates; AExplorerStyle: Boolean): TColor;
begin
  if (AKind <> dxlgtFooter) and (dxlgsHot in AState) then
    Result := DefaultSelectionTextColor
  else
    Result := GridLikeControlContentTextColor;
end;

procedure TcxCustomLookAndFeelPainter.DrawTreeViewNodeBackground(
  ACanvas: TcxCustomCanvas; const ABounds: TRect; AState: TdxTreeViewNodeStates);
begin
  DrawListViewItemBackground(ACanvas, ABounds, TdxListViewItemStates(AState), False);
end;

function TcxCustomLookAndFeelPainter.GetTreeViewBackgroundColor(AEnabled: Boolean): TColor;
begin
  Result := cxGetActualColor(DefaultEditorBackgroundColor(not AEnabled), clWindow);
end;

function TcxCustomLookAndFeelPainter.GetTreeViewNodeColorPalette(AState: TdxTreeViewNodeStates): IdxColorPalette;
begin
  Result := GetListViewItemColorPalette(TdxListViewItemStates(AState));
end;

function TcxCustomLookAndFeelPainter.GetTreeViewNodeTextColor(AState: TdxTreeViewNodeStates): TColor;
begin
  Result := GetListViewItemTextColor(TdxListViewItemStates(AState), False)
end;

function TcxCustomLookAndFeelPainter.ApplyEditorAdvancedMode: Boolean;
begin
  Result := False;
end;

function TcxCustomLookAndFeelPainter.SupportsNativeFocusRect(APaintPartID: TdxPaintPartID = TdxPaintPartID.Unknown): Boolean;
begin
  Result := True;
end;

procedure CreateStdScrollBarBrushes;
begin
  StdScrollBrushes[False] := TBrush.Create;
  StdScrollBrushes[True] := TBrush.Create;
  StdScrollBrushBitmaps[False] := TBitmap.Create;
  StdScrollBrushBitmaps[False].SetSize(8, 8);
  StdScrollBrushBitmaps[True] := TBitmap.Create;
  StdScrollBrushBitmaps[True].SetSize(8, 8);
  UpdateScrollBarBitmaps;
end;

procedure UpdateScrollBarBitmaps;
var
  X, Y: Integer;
begin
  if StdScrollBrushes[False] = nil then
    CreateStdScrollBarBrushes;

  for X := 0 to 7 do
    for Y := 0 to 7 do
      if (Y mod 2) = (X mod 2) then
      begin
        StdScrollBrushBitmaps[False].Canvas.Pixels[X, Y] := clBtnFace;
        StdScrollBrushBitmaps[True].Canvas.Pixels[X, Y] := clBlack;
      end
      else
      begin
        StdScrollBrushBitmaps[False].Canvas.Pixels[X, Y] := clBtnHighlight;
        StdScrollBrushBitmaps[True].Canvas.Pixels[X, Y] := cl3DDkShadow;
      end;

  StdScrollBrushes[False].Bitmap := StdScrollBrushBitmaps[False];
  StdScrollBrushes[True].Bitmap := StdScrollBrushBitmaps[True];
end;

procedure DestroyStdScrollBarBrushes;
begin
  FreeAndNil(StdScrollBrushes[False]);
  FreeAndNil(StdScrollBrushes[True]);
  FreeAndNil(StdScrollBrushBitmaps[False]);
  FreeAndNil(StdScrollBrushBitmaps[True]);
end;

procedure PrepareRadioButtonImageList(AScaleFactor: TdxScaleFactor);
begin
  TcxRadioButtonImageListManager.Get(AScaleFactor);
end;

{ TcxRadioButtonImageListManager }

class procedure TcxRadioButtonImageListManager.Finalize;
begin
  FreeAndNil(FCache);
end;

class procedure TcxRadioButtonImageListManager.Reset;
var
  AList: TcxRadioButtonImageList;
begin
  if FCache <> nil then
  begin
    for AList in FCache.Values do
      AList.Reset;
  end;
end;

class function TcxRadioButtonImageListManager.Get(AScaleFactor: TdxScaleFactor): TcxRadioButtonImageList;
begin
  if FCache = nil then
    FCache := TObjectDictionary<Integer, TcxRadioButtonImageList>.Create([doOwnsValues]);
  if not FCache.TryGetValue(AScaleFactor.TargetDPI, Result) then
  begin
    Result := TcxRadioButtonImageList.Create(AScaleFactor);
    FCache.Add(AScaleFactor.TargetDPI, Result);
  end;
end;


{ TcxStandardLookAndFeelPainter }

function TcxStandardLookAndFeelPainter.LookAndFeelName: string;
begin
  Result := 'Standard';
end;

function TcxStandardLookAndFeelPainter.LookAndFeelStyle: TcxLookAndFeelStyle;
begin
  Result := lfsStandard;
end;

function TcxStandardLookAndFeelPainter.BorderSize: Integer;
begin
  Result := 2;
end;

procedure TcxStandardLookAndFeelPainter.DrawBorder(ACanvas: TcxCustomCanvas; R: TRect; AWidth: Integer = 1);
begin
  ACanvas.DrawComplexFrame(R, clBtnShadow, clBtnHighlight);
  InflateRect(R, -1, -1);
  ACanvas.DrawComplexFrame(R, cl3DDkShadow, cl3DLight);
end;

function TcxStandardLookAndFeelPainter.ButtonBorderSize(AState: TcxButtonState = cxbsNormal): Integer;
begin
  if AState = cxbsDefault then
    Result := 3
  else
    Result := 2;
end;

function TcxStandardLookAndFeelPainter.ScaledButtonTextOffset(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := AScaleFactor.Apply(1);
end;

function TcxStandardLookAndFeelPainter.ScaledButtonTextShift(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := AScaleFactor.Apply(1);
end;

procedure TcxStandardLookAndFeelPainter.DrawButtonBorder(ACanvas: TcxCustomCanvas; R: TRect; AState: TcxButtonState);
begin
  if AState = cxbsPressed then
  begin
    ACanvas.FrameRect(R, clBlack);
    R.Inflate(-1, -1);
    ACanvas.DrawComplexFrame(R, clBtnShadow, clBtnShadow);
  end
  else
  begin
    if AState = cxbsDefault then
    begin
      ACanvas.FrameRect(R, clBlack);
      R.Inflate(-1, -1);
    end;
    ACanvas.DrawComplexFrame(R, clBtnHighlight, cl3DDkShadow);
    R.Inflate(-1, -1);
    ACanvas.DrawComplexFrame(R, cl3DLight, clBtnShadow);
  end;
end;

procedure TcxStandardLookAndFeelPainter.DrawScaledGroupExpandButton(ACanvas: TcxCustomCanvas;
  const R: TRect; AExpanded: Boolean; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
var
  APainter: TcxCustomLookAndFeelPainter;
begin
  if cxLookAndFeelPaintersManager.GetPainter(lfsFlat, APainter) then
    APainter.DrawScaledGroupExpandButton(ACanvas, R, AExpanded, AState, AScaleFactor)
  else
    inherited DrawScaledGroupExpandButton(ACanvas, R, AExpanded, AState, AScaleFactor);
end;

function TcxStandardLookAndFeelPainter.ScaledExpandButtonSize(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := AScaleFactor.Apply(12);
end;

procedure TcxStandardLookAndFeelPainter.DrawScaledExpandButton(
  ACanvas: TcxCustomCanvas; const R: TRect; AExpanded: Boolean; AScaleFactor: TdxScaleFactor;
  AColor: TColor = clDefault; AState: TcxExpandButtonState = cebsNormal);

  procedure DrawButton(var ARect: TRect);
  begin
    ACanvas.DrawEdge(ARect, False, False, [bLeft, bTop]);
    ACanvas.DrawEdge(ARect, False, True, [bRight, bBottom]);
    ARect.Inflate(-1, -1);
    ACanvas.DrawEdge(ARect, False, False, [bRight, bBottom]);
    Dec(ARect.Right);
    Dec(ARect.Bottom);
    ACanvas.FillRect(ARect, cxGetActualColor(AColor, clBtnFace));
  end;

var
  ARect: TRect;
begin
  ARect := R;
  DrawButton(ARect);
  DrawExpandButtonCross(ACanvas, ARect, AExpanded, clBtnText, AScaleFactor);
end;

function TcxStandardLookAndFeelPainter.IsButtonHotTrack: Boolean;
begin
  Result := False;
end;

function TcxStandardLookAndFeelPainter.DefaultSchedulerTimeRulerBorderColor: TColor;
begin
  Result := DefaultSchedulerTimeRulerBorderColorClassic;
end;

function TcxStandardLookAndFeelPainter.DefaultSchedulerTimeRulerTextColor: TColor;
begin
  Result := DefaultSchedulerTimeRulerBorderColorClassic;
end;

procedure TcxStandardLookAndFeelPainter.DrawCheckBorder(ACanvas: TcxCustomCanvas; R: TRect;
  AState: TcxButtonState);
begin
  ACanvas.DrawEdge(R, True, False{True});
  InflateRect(R, -1, -1);
  ACanvas.DrawEdge(R, True, True{False});
end;

procedure TcxStandardLookAndFeelPainter.DrawHeaderControlSectionBorder(
  ACanvas: TcxCanvas; const R: TRect;
  ABorders: TcxBorders; AState: TcxButtonState);
var
  ARect: TRect;
begin
  ARect := R;
  if AState <> cxbsPressed then
  begin
    ACanvas.DrawComplexFrame(ARect, clBtnHighlight, cl3DDkShadow, ABorders);
    InflateRect(ARect, -1, -1);
    ACanvas.DrawComplexFrame(ARect, cl3DLight, clBtnShadow, ABorders);
  end
  else
    ACanvas.DrawComplexFrame(ARect, clBtnShadow, clBtnShadow, ABorders);
end;

procedure TcxStandardLookAndFeelPainter.DrawScaledSortingMark(
  ACanvas: TcxCanvas; const R: TRect; AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor);
begin
  DrawSortingArrow(ACanvas, R, clBtnShadow, clBtnHighlight, AAscendingSorting, AScaleFactor);
end;

procedure TcxStandardLookAndFeelPainter.DrawScaledSummarySortingMark(
  ACanvas: TcxCanvas; const R: TRect; AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor);
begin
  DrawSummarySortingArrow(ACanvas, R, clBtnShadow, clBtnHighlight, AAscendingSorting, AScaleFactor);
end;

function TcxStandardLookAndFeelPainter.HeaderBorderSize: Integer;
begin
  Result := 1;
end;

function TcxStandardLookAndFeelPainter.HeaderControlSectionBorderSize(
  AState: TcxButtonState = cxbsNormal): Integer;
begin
  if AState = cxbsPressed then
    Result := 1
  else
    Result := 2;
end;

function TcxStandardLookAndFeelPainter.ScaledSortingMarkSize(AScaleFactor: TdxScaleFactor): TPoint;
begin
  Result := AScaleFactor.Apply(Point(8, 7));
end;

function TcxStandardLookAndFeelPainter.ScaledSummarySortingMarkSize(AScaleFactor: TdxScaleFactor): TPoint;
begin
  Result := AScaleFactor.Apply(Point(8, 8));
end;

function TcxStandardLookAndFeelPainter.FooterBorderSize: Integer;
begin
  Result := 1;
end;

function TcxStandardLookAndFeelPainter.FooterCellBorderSize: Integer;
begin
  Result := 1;
end;

function TcxStandardLookAndFeelPainter.FooterCellOffset: Integer;
begin
  Result := 1;
end;

function TcxStandardLookAndFeelPainter.FooterContentOffset: Integer;
begin
  Result := 1;
end;

procedure TcxStandardLookAndFeelPainter.DrawFooterBorder(ACanvas: TcxCanvas; const R: TRect;
  const ABorders: TcxBorders; AScaleFactor: TdxScaleFactor; ABordersScaleFactor: TdxScaleFactor);
begin
  ACanvas.DrawEdge(R, False, False, ABorders);
end;

procedure TcxStandardLookAndFeelPainter.DrawFooterCellBorder(ACanvas: TcxCanvas; const R: TRect; const ABorders: TcxBorders;
  AScaleFactor: TdxScaleFactor);
begin
  ACanvas.DrawEdge(R, True, True, ABorders);
end;

procedure TcxStandardLookAndFeelPainter.DrawScaledFilterDropDownButton(ACanvas: TcxCanvas;
  R: TRect; AState: TcxButtonState; AIsFilterActive: Boolean; AScaleFactor: TdxScaleFactor);

  function GetArrowColor: TColor;
  begin
    if AIsFilterActive then
      Result := ActiveFilterButtonArrowColor
    else
      Result := clBtnText;
  end;

begin
  if AState <> cxbsPressed then
    ACanvas.DrawEdge(R, False, False)
  else
    ACanvas.DrawEdge(R, True, True);
  InflateRect(R, -1, -1);
  ACanvas.Brush.Color := clBtnFace;
  ACanvas.FillRect(R);
  DrawButtonArrow(ACanvas, R, GetArrowColor);
end;

procedure TcxStandardLookAndFeelPainter.DrawTabBorder(ACanvas: TcxCanvas; R: TRect;
  ABorder: TcxBorder; ABorders: TcxBorders; AVertical: Boolean);
const
  Colors: array[Boolean] of TColor = (clBtnShadow, clBtnHighlight);

  procedure ProcessVerticalTabBorder;
  begin
    case ABorder of
       bLeft:
         begin
           Inc(R.Top);
           if bTop in ABorders then Inc(R.Top);
           Dec(R.Bottom);
           if bBottom in ABorders then Dec(R.Bottom);
         end;
       bTop, bBottom:
         if bLeft in ABorders then Inc(R.Left);
    end;
    if ABorder = bLeft then
    begin
      ACanvas.Pixels[R.Left + 1, R.Top - 1] := Colors[True];
      ACanvas.Pixels[R.Left + 1, R.Bottom] := Colors[True];
    end;
    ACanvas.Brush.Color := Colors[ABorder <> bBottom];
  end;

  procedure ProcessHorizontalTabBorder;
  begin
    case ABorder of
       bTop:
         begin
           Inc(R.Left);
           Dec(R.Right);
         end;
       bLeft, bRight:
         begin
           if bTop in ABorders then Inc(R.Top, 2);
           if bBottom in ABorders then Dec(R.Bottom);
         end;
    end;
    if ABorder = bTop then
    begin
      ACanvas.Pixels[R.Left - 1, R.Top + 1] := Colors[True];
      ACanvas.Pixels[R.Right, R.Top + 1] := Colors[True];
    end;
    ACanvas.Brush.Color := Colors[ABorder <> bRight];
  end;

begin
  if AVertical then
    ProcessVerticalTabBorder
  else
    ProcessHorizontalTabBorder;
  ACanvas.FillRect(R);
end;

procedure TcxStandardLookAndFeelPainter.DrawTabsRoot(ACanvas: TcxCanvas; const R: TRect;
  ABorders: TcxBorders; AVertical: Boolean);
begin
  ACanvas.DrawEdge(R, False, False, ABorders);
end;

function TcxStandardLookAndFeelPainter.TabBorderSize(AVertical: Boolean): Integer;
begin
  Result := 1;
end;

procedure TcxStandardLookAndFeelPainter.DrawScaledMonthHeader(ACanvas: TcxCanvas;
  const ABounds: TRect; const AText: string; ANeighbors: TcxNeighbors;
  const AViewParams: TcxViewParams; AArrows: TcxArrowDirections;
  ASideWidth: Integer; AScaleFactor: TdxScaleFactor; AOnDrawBackground: TcxDrawBackgroundEvent = nil);
const
  Borders: array[Boolean, Boolean] of TcxBorders =
  ((cxBordersAll, [bTop, bBottom, bLeft]), ([bTop, bBottom, bRight], [bTop, bBottom]));
var
  ABorders: TcxBorders;
  R: TRect;
begin
  ABorders := Borders[nLeft in ANeighbors, nRight in ANeighbors];
  ACanvas.FrameRect(ABounds, clBlack, 1, ABorders);
  R := ScaledHeaderContentBounds(ABounds, ABorders, AScaleFactor);
  DrawScaledHeader(ACanvas, R, R, ANeighbors, cxBordersAll, cxbsNormal, taCenter,
    vaCenter, False, False, AText, AViewParams.Font, AViewParams.TextColor,
    AViewParams.Color, AScaleFactor, AOnDrawBackground);
  DrawMonthHeaderArrows(ACanvas, ABounds, AArrows, ASideWidth, clWindowText);
end;

function TcxStandardLookAndFeelPainter.DefaultSchedulerViewContentColor: TColor;
begin
  Result := DefaultSchedulerViewContentColorClassic;
end;

function TcxStandardLookAndFeelPainter.DefaultSchedulerViewContentColorClassic: TColor;
begin
  Result := clWindow;
end;

procedure TcxStandardLookAndFeelPainter.DrawSchedulerSplitterBorder(
  ACanvas: TcxCanvas; R: TRect; const AViewParams: TcxViewParams;
  AIsHorizontal: Boolean);

  procedure DrawHorzBorders(const R: TRect; ATopColor, ABottomColor: TColor);
  begin
    ACanvas.SetBrushColor(ATopColor);
    ACanvas.FillRect(Rect(R.Left, R.Top, R.Right, R.Top + 1));
    ACanvas.SetBrushColor(ABottomColor);
    ACanvas.FillRect(Rect(R.Left, R.Bottom - 1, R.Right, R.Bottom));
  end;

  procedure DrawVertBorders(const R: TRect; ALeftColor, ARightColor: TColor);
  begin
    ACanvas.SetBrushColor(ALeftColor);
    ACanvas.FillRect(Rect(R.Left, R.Top, R.Left + 1, R.Bottom));
    ACanvas.SetBrushColor(ARightColor);
    ACanvas.FillRect(Rect(R.Right - 1, R.Top, R.Right, R.Bottom));
  end;

begin
  if AIsHorizontal then
  begin
    DrawHorzBorders(R, clBtnFace, cl3DDkShadow);
    InflateRect(R, 1, -1);
    DrawHorzBorders(R, clBtnHighlight, clBtnShadow);
    InflateRect(R, 1, -1);
  end
  else
  begin
    DrawVertBorders(R, clBtnFace, cl3DDkShadow);
    InflateRect(R, -1, 1);
    DrawVertBorders(R, clBtnHighlight, clBtnShadow);
    InflateRect(R, -1, 1);
  end;
  ACanvas.FillRect(R, AViewParams);
end;

procedure TcxStandardLookAndFeelPainter.DrawGroupBoxScaledFrame(ACanvas: TcxCanvas;
  R: TRect; AEnabled: Boolean; ACaptionPosition: TcxGroupBoxCaptionPosition;
  AScaleFactor: TdxScaleFactor; ABorders: TcxBorders = cxBordersAll);
begin
  Dec(R.Right);
  Dec(R.Bottom);
  ACanvas.FrameRect(R, clBtnShadow, 1, ABorders, True);
  OffsetRect(R, 1, 1);
  ACanvas.FrameRect(R, clBtnHighlight, 1, ABorders, True);
end;

procedure TcxStandardLookAndFeelPainter.DrawTrackBarTrackBounds(ACanvas: TcxCanvas; const ARect: TRect);
var
  R: TRect;
begin
  R := ARect;
  ACanvas.DrawComplexFrame(R, clBtnShadow, clBtnHighlight);
  InflateRect(R, -1, -1);
  ACanvas.DrawComplexFrame(R, cl3DDkShadow, cl3DLight);
end;

procedure TcxStandardLookAndFeelPainter.DrawTrackBarThumbBorderUpDown(ACanvas: TcxCanvas;
  const ALightPolyLine, AShadowPolyLine, ADarkPolyLine: TPoints);
begin
  ACanvas.Pen.Color := clBtnHighlight;
  ACanvas.Polyline(ALightPolyLine);
  ACanvas.Pen.Color := clBtnShadow;
  ACanvas.Polyline(AShadowPolyLine);
  ACanvas.Pen.Color := cl3DDkShadow;
  ACanvas.Polyline(ADarkPolyLine);
end;

procedure TcxStandardLookAndFeelPainter.DrawTrackBarThumbBorderBoth(ACanvas: TcxCanvas; const ARect: TRect);
var
  R: TRect;
begin
  R := ARect;
  ACanvas.DrawComplexFrame(R, clBtnHighlight, cl3DDkShadow);
  InflateRect(R, -1, -1);
  ACanvas.DrawComplexFrame(R, cl3DLight, clBtnShadow);
end;

procedure TcxStandardLookAndFeelPainter.DrawBreadcrumbEditScaledButton(
  ACanvas: TcxCanvas; const ARect: TRect; AState: TdxBreadcrumbEditButtonState;
  AIsFirst, AIsLast: Boolean; AScaleFactor: TdxScaleFactor);
begin
  if not cxRectIsEmpty(ARect) then
  begin
    if AState = dxbcbsPressed then
      ACanvas.DrawComplexFrame(ARect, clBtnShadow, clBtnHighlight)
    else
      if AState in [dxbcbsFocused, dxbcbsHot] then
        ACanvas.DrawComplexFrame(ARect, clBtnHighlight, clBtnShadow);
  end;
end;

procedure TcxStandardLookAndFeelPainter.DrawScaledToggleSwitchState(
  ACanvas: TcxCanvas; ABounds: TRect; AState: TcxButtonState; AChecked, AFocused: Boolean; AScaleFactor: TdxScaleFactor);
begin
  ACanvas.FillRect(ABounds, ToggleSwitchToggleColor(AChecked));
  DrawContainerBorder(ACanvas, ABounds, cbs3D, 2, $696969, [bLeft, bTop, bRight, bBottom]);
end;

function TcxStandardLookAndFeelPainter.ToggleSwitchToggleColor(AChecked: Boolean): TColor;
begin
  if AChecked then
    Result := $219921
  else
    Result := $E3E3E3;
end;

procedure TcxStandardLookAndFeelPainter.DrawFindPanelBorder(ACanvas: TcxCanvas; const R: TRect;
  const ABorders: TcxBorders; AScaleFactor, ABordersScaleFactor: TdxScaleFactor);
begin
end;

procedure TcxStandardLookAndFeelPainter.DrawScaledTokenBackground(
  ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
begin
  ACanvas.DrawComplexFrame(R, clBtnShadow, clBtnHighlight);
  case AState of
    cxbsHot:
      ACanvas.DrawComplexFrame(cxRectInflate(R, -1), clBtnHighlight, clBtnShadow);
    cxbsPressed:
      ACanvas.DrawComplexFrame(cxRectInflate(R, -1), clBtnShadow, clBtnHighlight);
  end;
end;

procedure TcxStandardLookAndFeelPainter.DoDrawScaledScrollBarPart(ACanvas: TcxCustomCanvas;
  AHorizontal: Boolean; R: TRect; APart: TcxScrollBarPart; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);

  function GetArrowState: Integer;
  const
    States: array[Boolean, Boolean] of Integer = (
      (DFCS_SCROLLUP, DFCS_SCROLLDOWN), (DFCS_SCROLLLEFT, DFCS_SCROLLRIGHT)
    );
  begin
    Result := States[AHorizontal, APart = sbpLineDown];
    if AState = cxbsDisabled then
      Result := Result or DFCS_INACTIVE
    else
      if AState = cxbsPressed then
        Result := Result or DFCS_FLAT;
  end;

  procedure DrawScrollBarButtonBorder(R: TRect);
  begin
    if (AState <> cxbsPressed) or (APart = sbpThumbnail) then
    begin
      ACanvas.DrawComplexFrame(R, clBtnFace, cl3DDkShadow);
      InflateRect(R, -1, -1);
      ACanvas.DrawComplexFrame(R, clBtnHighlight, clBtnShadow);
    end
    else
    begin
      ACanvas.DrawComplexFrame(R, clBtnShadow, clBtnShadow);
      InflateRect(R, -1, -1);
      ACanvas.DrawComplexFrame(R, clBtnFace, clBtnFace);
    end;
  end;

  procedure DrawScrollBarContent(R: TRect; AArrowState: Integer);
  begin
    if AState = cxbsPressed then
      OffsetRect(R, 1, 1);

    ACanvas.DrawNativeObject(R,
      TcxCanvasBasedResourceCacheKey.Create(Self, TSize.Create(R), AArrowState, DFC_SCROLL),
      procedure (ACanvas: TcxGdiBasedCanvas; const R: TRect)
      begin
        DrawFrameControl(ACanvas.Handle, R, DFC_SCROLL, AArrowState);
      end);
  end;

begin
  if IsRectEmpty(R) or (APart = sbpThumbnail) and (AState = cxbsDisabled) then
    Exit;

  if AState = cxbsHot then
    AState := cxbsNormal;

  case APart of
    sbpPageUp, sbpPageDown:
      inherited;

    sbpThumbnail, sbpLineUp, sbpLineDown:
      // for compatibility with standard painting
      if APart <> sbpThumbnail then
      begin
        DrawScrollBarContent(R, GetArrowState);
        DrawScrollBarButtonBorder(R);
      end
      else
      begin
        DrawScrollBarButtonBorder(R);
        ACanvas.FillRect(cxRectInflate(R, -ButtonBorderSize), clBtnFace);
      end;
  end;
end;

procedure CalculateCheckButtonSize;
var
  AButtonsBitmap: HBITMAP;
  B: Windows.TBitmap;
begin
  AButtonsBitmap := LoadBitmap(0, PChar(OBM_CHECKBOXES));
  try
    dxGetBitmapData(AButtonsBitmap, B);
    FCheckButtonSize := Size(B.bmWidth div 4, B.bmHeight div 3);
  finally
    DeleteObject(AButtonsBitmap);
  end;
end;

{ TcxFlatLookAndFeelPainter }

function TcxFlatLookAndFeelPainter.LookAndFeelName: string;
begin
  Result := 'Flat';
end;

function TcxFlatLookAndFeelPainter.LookAndFeelStyle: TcxLookAndFeelStyle;
begin
  Result := lfsFlat;
end;

function TcxFlatLookAndFeelPainter.BorderSize: Integer;
begin
  Result := 1;
end;

function TcxFlatLookAndFeelPainter.SeparatorSize: Integer;
begin
  Result := 2;
end;

procedure TcxFlatLookAndFeelPainter.DrawBorder(ACanvas: TcxCustomCanvas; R: TRect; AWidth: Integer = 1);
begin
  ACanvas.DrawEdge(R, True, True);
end;

function TcxFlatLookAndFeelPainter.ButtonBorderSize(AState: TcxButtonState = cxbsNormal): Integer;
begin
  if AState = cxbsDefault then
    Result := 2
  else
    Result := 1;
end;

function TcxFlatLookAndFeelPainter.ScaledButtonTextOffset(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := AScaleFactor.Apply(1);
end;

function TcxFlatLookAndFeelPainter.ScaledButtonTextShift(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := AScaleFactor.Apply(1);
end;

procedure TcxFlatLookAndFeelPainter.DrawButtonBorder(ACanvas: TcxCustomCanvas; R: TRect; AState: TcxButtonState);
begin
  if AState = cxbsPressed then
    ACanvas.DrawComplexFrame(R, clBtnShadow, clBtnHighlight)
  else
  begin
    if AState = cxbsDefault then
    begin
      ACanvas.FrameRect(R, clBlack);
      InflateRect(R, -1, -1);
    end;
    ACanvas.DrawComplexFrame(R, clBtnHighlight, clBtnShadow)
  end;
end;

procedure TcxFlatLookAndFeelPainter.DrawScaledExpandButton(
  ACanvas: TcxCustomCanvas; const R: TRect; AExpanded: Boolean; AScaleFactor: TdxScaleFactor;
  AColor: TColor = clDefault; AState: TcxExpandButtonState = cebsNormal);
begin
  DrawScaledButton(ACanvas, R, cxbsNormal, AScaleFactor, cxbpButton, AColor);
  DrawExpandButtonCross(ACanvas, cxRectInflate(R, -1), AExpanded, clBtnText, AScaleFactor);
end;

function TcxFlatLookAndFeelPainter.ScaledExpandButtonSize(AScaleFactor: TdxScaleFactor): Integer;
begin
  Result := AScaleFactor.Apply(11);
end;

function TcxFlatLookAndFeelPainter.IsButtonHotTrack: Boolean;
begin
  Result := False;
end;

function TcxFlatLookAndFeelPainter.DefaultSchedulerTimeRulerBorderColor: TColor;
begin
  Result := DefaultSchedulerTimeRulerBorderColorClassic;
end;

function TcxFlatLookAndFeelPainter.DefaultSchedulerTimeRulerTextColor: TColor;
begin
  Result := DefaultSchedulerTimeRulerBorderColorClassic;
end;

procedure TcxFlatLookAndFeelPainter.DrawCheckBorder(ACanvas: TcxCustomCanvas; R: TRect; AState: TcxButtonState);
begin
  ACanvas.DrawEdge(R, True, True);
  InflateRect(R, -1, -1);
  ACanvas.FrameRect(R, CheckButtonColor(AState, cbsChecked));
end;

procedure TcxFlatLookAndFeelPainter.DrawHeaderControlSectionBorder(
  ACanvas: TcxCanvas; const R: TRect; ABorders: TcxBorders; AState: TcxButtonState);
begin
  if AState <> cxbsPressed then
    ACanvas.DrawComplexFrame(R, clBtnHighlight, clBtnShadow, ABorders)
  else
    ACanvas.DrawComplexFrame(R, clBtnShadow, clBtnHighlight, ABorders);
end;

procedure TcxFlatLookAndFeelPainter.DrawScaledSortingMark(
  ACanvas: TcxCanvas; const R: TRect; AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor);
begin
  DrawSortingArrow(ACanvas, R, clBtnShadow, clBtnHighlight, AAscendingSorting, AScaleFactor);
end;

procedure TcxFlatLookAndFeelPainter.DrawScaledSummarySortingMark(ACanvas: TcxCanvas;
  const R: TRect; AAscendingSorting: Boolean; AScaleFactor: TdxScaleFactor);
begin
  DrawSummarySortingArrow(ACanvas, R, clBtnShadow, clBtnHighlight, AAscendingSorting, AScaleFactor);
end;

function TcxFlatLookAndFeelPainter.HeaderBorderSize: Integer;
begin
  Result := 1;
end;

function TcxFlatLookAndFeelPainter.ScaledSortingMarkSize(AScaleFactor: TdxScaleFactor): TPoint;
begin
  Result := AScaleFactor.Apply(Point(8, 7));
end;

function TcxFlatLookAndFeelPainter.ScaledSummarySortingMarkSize(AScaleFactor: TdxScaleFactor): TPoint;
begin
  Result := AScaleFactor.Apply(Point(8, 8));
end;

function TcxFlatLookAndFeelPainter.FooterBorderSize: Integer;
begin
  Result := 1;
end;

function TcxFlatLookAndFeelPainter.FooterCellBorderSize: Integer;
begin
  Result := 1;
end;

function TcxFlatLookAndFeelPainter.FooterCellOffset: Integer;
begin
  Result := 1;
end;

function TcxFlatLookAndFeelPainter.FooterContentOffset: Integer;
begin
  Result := 1;
end;

procedure TcxFlatLookAndFeelPainter.DrawFooterBorder(ACanvas: TcxCanvas; const R: TRect;
  const ABorders: TcxBorders; AScaleFactor, ABordersScaleFactor: TdxScaleFactor);
begin
  ACanvas.DrawEdge(R, False, False, ABorders);
end;

procedure TcxFlatLookAndFeelPainter.DrawFooterCellBorder(ACanvas: TcxCanvas; const R: TRect;
  const ABorders: TcxBorders; AScaleFactor: TdxScaleFactor);
begin
  ACanvas.DrawEdge(R, True, True, ABorders);
end;

procedure TcxFlatLookAndFeelPainter.DrawScaledFilterDropDownButton(ACanvas: TcxCanvas;
  R: TRect; AState: TcxButtonState; AIsFilterActive: Boolean; AScaleFactor: TdxScaleFactor);

  function GetArrowColor: TColor;
  begin
    if AIsFilterActive then
      Result := ActiveFilterButtonArrowColor
    else
      Result := clBtnText;
  end;

begin
  if AState <> cxbsPressed then
    ACanvas.DrawEdge(R, False, False)
  else
    ACanvas.DrawEdge(R, True, True);
  InflateRect(R, -1, -1);
  ACanvas.Brush.Color := clBtnFace;
  ACanvas.FillRect(R);
  DrawButtonArrow(ACanvas, R, GetArrowColor);
end;

procedure TcxFlatLookAndFeelPainter.DrawTabBorder(ACanvas: TcxCanvas; R: TRect;
  ABorder: TcxBorder; ABorders: TcxBorders; AVertical: Boolean);
const
  Colors: array[Boolean] of TColor = (clBtnShadow, clBtnHighlight);

  procedure ProcessVerticalTabBorder;
  begin
    case ABorder of
       bLeft:
         begin
           Inc(R.Top);
           if bTop in ABorders then Inc(R.Top);
           Dec(R.Bottom);
           if bBottom in ABorders then Dec(R.Bottom);
         end;
       bTop, bBottom:
         if bLeft in ABorders then Inc(R.Left);
    end;
    if ABorder = bLeft then
    begin
      ACanvas.Pixels[R.Left + 1, R.Top - 1] := Colors[True];
      ACanvas.Pixels[R.Left + 1, R.Bottom] := Colors[True];
    end;
    ACanvas.Brush.Color := Colors[ABorder <> bBottom];
  end;

  procedure ProcessHorizontalTabBorder;
  begin
    case ABorder of
       bTop:
         begin
           Inc(R.Left);
           Dec(R.Right);
         end;
       bLeft, bRight:
         begin
           if bTop in ABorders then Inc(R.Top, 2);
           if bBottom in ABorders then Dec(R.Bottom);
         end;
    end;
    if ABorder = bTop then
    begin
      ACanvas.Pixels[R.Left - 1, R.Top + 1] := Colors[True];
      ACanvas.Pixels[R.Right, R.Top + 1] := Colors[True];
    end;
    ACanvas.Brush.Color := Colors[ABorder <> bRight];
  end;

begin
  if AVertical then
    ProcessVerticalTabBorder
  else
    ProcessHorizontalTabBorder;
  ACanvas.FillRect(R);
end;

procedure TcxFlatLookAndFeelPainter.DrawTabsRoot(ACanvas: TcxCanvas; const R: TRect;
  ABorders: TcxBorders; AVertical: Boolean);
begin
  ACanvas.DrawEdge(R, False, False, ABorders);
end;

function TcxFlatLookAndFeelPainter.TabBorderSize(AVertical: Boolean): Integer;
begin
  Result := 1;
end;

procedure TcxFlatLookAndFeelPainter.DrawSchedulerSplitterBorder(
  ACanvas: TcxCanvas; R: TRect; const AViewParams: TcxViewParams;
  AIsHorizontal: Boolean);
begin
  if AIsHorizontal then
  begin
    ACanvas.SetBrushColor(clBtnHighlight);
    ACanvas.FillRect(Rect(R.Left, R.Top, R.Right, R.Top + 1));
    ACanvas.SetBrushColor(clBtnShadow);
    ACanvas.FillRect(Rect(R.Left, R.Bottom - 1, R.Right, R.Bottom));
    InflateRect(R, 1, -1);
  end
  else
  begin
    ACanvas.SetBrushColor(clBtnHighlight);
    ACanvas.FillRect(Rect(R.Left, R.Top, R.Left + 1, R.Bottom));
    ACanvas.SetBrushColor(clBtnShadow);
    ACanvas.FillRect(Rect(R.Right - 1, R.Top, R.Right, R.Bottom));
    InflateRect(R, -1, 1);
  end;
  ACanvas.FillRect(R, AViewParams);
end;

procedure TcxFlatLookAndFeelPainter.DrawGroupBoxScaledFrame(ACanvas: TcxCanvas;
  R: TRect; AEnabled: Boolean; ACaptionPosition: TcxGroupBoxCaptionPosition;
  AScaleFactor: TdxScaleFactor; ABorders: TcxBorders = cxBordersAll);
begin
  ACanvas.FrameRect(R, clBtnShadow, 1, ABorders, True);
  InflateRect(R, -1, -1);
  ACanvas.FrameRect(R, clBtnHighlight, 1, ABorders, True);
end;

procedure TcxFlatLookAndFeelPainter.DrawTrackBarTrackBounds(ACanvas: TcxCanvas; const ARect: TRect);
var
  R: TRect;
begin
  R := ARect;
  ACanvas.DrawComplexFrame(R, clBtnShadow, clBtnHighlight);
  InflateRect(R, -1, -1);
  ACanvas.DrawComplexFrame(R, clBtnFace, clBtnFace);
end;

procedure TcxFlatLookAndFeelPainter.DrawTrackBarThumbBorderUpDown(ACanvas: TcxCanvas;
  const ALightPolyLine, AShadowPolyLine, ADarkPolyLine: TPoints);
begin
  ACanvas.Pen.Color := clBtnHighlight;
  ACanvas.Polyline(ALightPolyLine);
  ACanvas.Pen.Color := clBtnShadow;
  ACanvas.Polyline(ADarkPolyLine);
end;

procedure TcxFlatLookAndFeelPainter.DrawTrackBarThumbBorderBoth(ACanvas: TcxCanvas; const ARect: TRect);
begin
  ACanvas.DrawComplexFrame(ARect, clBtnHighlight, clBtnShadow)
end;

procedure TcxFlatLookAndFeelPainter.DrawDateNavigatorDateHeader(
  ACanvas: TcxCanvas; var R: TRect);
begin
  ACanvas.FillRect(R, DefaultDateNavigatorHeaderColor);
  ACanvas.FrameRect(R, clBtnFace, 1, [bBottom]);
  Dec(R.Bottom);
end;

function TcxFlatLookAndFeelPainter.GetSplitterOuterColor(AHighlighted: Boolean): TColor;
begin
  Result := inherited GetSplitterOuterColor(AHighlighted);
  if AHighlighted then
    Result := cl3DDkShadow;
end;

procedure TcxFlatLookAndFeelPainter.DrawScaledToggleSwitchState(ACanvas: TcxCanvas; ABounds: TRect;
  AState: TcxButtonState; AChecked, AFocused: Boolean; AScaleFactor: TdxScaleFactor);
begin
  ACanvas.FillRect(ABounds, ToggleSwitchToggleColor(AChecked));
  ACanvas.Pen.Color := $A0A0A0;
  ACanvas.MoveTo(ABounds.Left, ABounds.Bottom);
  ACanvas.LineTo(ABounds.Left, ABounds.Top);
  ACanvas.LineTo(ABounds.Right, ABounds.Top);
  ACanvas.Pen.Color := $FFFFFF;
  ACanvas.LineTo(ABounds.Right, ABounds.Bottom);
  ACanvas.LineTo(ABounds.Left, ABounds.Bottom);
end;

function TcxFlatLookAndFeelPainter.ToggleSwitchToggleColor(AChecked: Boolean): TColor;
begin
  if AChecked then
    Result := $A0A0A0
  else
    Result := $C8C8C8;
end;

procedure TcxFlatLookAndFeelPainter.DrawFindPanelBorder(ACanvas: TcxCanvas; const R: TRect;
  const ABorders: TcxBorders; AScaleFactor, ABordersScaleFactor: TdxScaleFactor);
begin
end;

procedure TcxFlatLookAndFeelPainter.DoDrawScaledScrollBarPart(ACanvas: TcxCustomCanvas;
  AHorizontal: Boolean; R: TRect; APart: TcxScrollBarPart; AState: TcxButtonState; AScaleFactor: TdxScaleFactor);
begin
  if IsRectEmpty(R) or ((APart = sbpThumbnail) and (AState = cxbsDisabled)) then
    Exit;
  if AState = cxbsHot then
    AState := cxbsNormal;
  case APart of
    sbpPageUp, sbpPageDown:
      inherited;

    sbpThumbnail, sbpLineUp, sbpLineDown:
      begin
        DrawScaledButton(ACanvas, R, AState, AScaleFactor);
        R := cxRectInflate(R, -ButtonBorderSize);
        if APart <> sbpThumbnail then
          DrawScaledScrollBarArrow(ACanvas, R, AState, GetArrowDirection(AHorizontal, APart), AScaleFactor);
      end;
  end;
end;


{ TSystemPaletteChangedNotifier }

procedure TSystemPaletteChangedNotifier.DoChanged;
begin
  TcxRadioButtonImageListManager.Reset;
end;

procedure dxRotateSizeGrip(ACanvas: TcxCanvas; const ARect: TRect;
  ABackgroundColor: TColor; ACorner: TdxCorner; AOnDrawSizeGrip: TdxDrawEvent);
const
  ARotationMap: array[Boolean] of TcxRotationAngle = (ra0, ra180);
var
  ABitmap: TcxBitmap;
begin
  ABitmap := TcxBitmap.CreateSize(ARect);
  try
    ABitmap.cxCanvas.Brush := ACanvas.Brush;
    if ABackgroundColor = clNone then
      cxBitBlt(ABitmap.Canvas.Handle, ACanvas.Handle, ABitmap.ClientRect, ARect.TopLeft, SRCCOPY)
    else
      ABitmap.cxCanvas.FillRect(ABitmap.ClientRect, ABackgroundColor);
    ABitmap.Rotate(ARotationMap[(ACorner in [coTopLeft, coBottomLeft])], (ACorner in [coTopRight, coBottomLeft]));
    if Assigned(AOnDrawSizeGrip) then
      AOnDrawSizeGrip(ABitmap.cxCanvas, ABitmap.ClientRect);
    ABitmap.Rotate(ARotationMap[ACorner in [coTopLeft, coBottomLeft]], ACorner in [coTopRight, coBottomLeft]);
    TdxImageDrawer.DrawBitmap(ACanvas.Handle, ABitmap, ARect, cxNullPoint);
  finally
    ABitmap.Free;
  end;
end;

procedure dxRotateSizeGrip(ACanvas: TcxCanvas; const ARect: TRect; AScaleFactor: TdxScaleFactor;
  ABackgroundColor: TColor; ACorner: TdxCorner; AOnDrawSizeGrip: TdxDrawScaledRectEvent);
const
  ARotationMap: array[Boolean] of TcxRotationAngle = (ra0, ra180);
var
  ABitmap: TcxBitmap;
  APoint: TPoint;
begin
  ABitmap := TcxBitmap.CreateSize(ARect);
  try
    ABitmap.cxCanvas.Brush := ACanvas.Brush;
    if ABackgroundColor = clNone then
      cxBitBlt(ABitmap.Canvas.Handle, ACanvas.Handle, ABitmap.ClientRect, ARect.TopLeft, SRCCOPY)
    else
      ABitmap.cxCanvas.FillRect(ABitmap.ClientRect, ABackgroundColor);
    ABitmap.Rotate(ARotationMap[(ACorner in [coTopLeft, coBottomLeft])], (ACorner in [coTopRight, coBottomLeft]));
    if Assigned(AOnDrawSizeGrip) then
      AOnDrawSizeGrip(ABitmap.cxCanvas, ABitmap.ClientRect, AScaleFactor);
    ABitmap.Rotate(ARotationMap[ACorner in [coTopLeft, coBottomLeft]], ACorner in [coTopRight, coBottomLeft]);
    if (ABackgroundColor <> clNone) and (ABackgroundColor <> clDefault) then
    begin
      case ACorner of
        coTopLeft: APoint.Init(ABitmap.Width - 1, ABitmap.Height - 1);
        coTopRight: APoint.Init(0, ABitmap.Height - 1);
        coBottomLeft: APoint.Init(ABitmap.Width - 1, 0);
        coBottomRight: APoint.Init(0, 0);
      end;
      ABitmap.cxCanvas.Brush.Color := ABackgroundColor;
      ABitmap.cxCanvas.Brush.Style := bsSolid;
      ABitmap.cxCanvas.FloodFill(APoint.X, APoint.Y, ABitmap.Canvas.Pixels[APoint.X, APoint.Y], fsSurface);
    end;
    TdxImageDrawer.DrawBitmap(ACanvas.Handle, ABitmap, ARect, cxNullPoint);
  finally
    ABitmap.Free;
  end;
end;


procedure RegisterAssistants;
begin
  CreateStdScrollBarBrushes;
  CalculateCheckButtonSize;
  if IsLibrary then
    RefreshOffice11Colors;
end;

procedure UnregisterAssistants;
begin
  FUnitIsFinalized := True;
  if FLookAndFeelPaintersManager <> nil then
    FLookAndFeelPaintersManager.ReleaseImageResources;
  TcxRadioButtonImageListManager.Finalize;
  DestroyStdScrollBarBrushes;
  FreeAndNil(FIndicatorImages);
  FreeAndNil(FDataRowFixingImages);
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  FUnitIsFinalized := False; // D10 bug
  FSystemPaletteChangedNotifier := TSystemPaletteChangedNotifier.Create(True);
  dxUnitsLoader.AddUnit(SysInit.HInstance, dxThisUnitName, RegisterAssistants, UnregisterAssistants);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxUnitsLoader.RemoveUnit(SysInit.HInstance, dxThisUnitName, UnregisterAssistants);
  FreeAndNil(FSystemPaletteChangedNotifier);
  dxFreeGlobalObject(FLookAndFeelPaintersManager);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
