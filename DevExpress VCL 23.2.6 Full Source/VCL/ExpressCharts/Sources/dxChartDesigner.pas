{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressCharts                                            }
{                                                                    }
{           Copyright (c) 2020-2024 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSCHARTS AND ALL ACCOMPANYING    }
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

unit dxChartDesigner;

{$I cxVer.inc}
{$SCOPEDENUMS ON}

interface

uses
  System.UITypes,
{$IFDEF DELPHI101BERLIN}
  System.ImageList,
{$ENDIF}
  Types, Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, Menus, StdCtrls, Actions,
  Generics.Collections, ImgList, cxImageList, ActnList, ExtCtrls,
  cxClasses, dxCore, dxCoreClasses, dxForms, cxGraphics, cxLookAndFeels,
  cxControls, cxButtons, dxTreeView, cxGeometry, dxBuiltInPopupMenu, dxCoreGraphics,
  cxContainer, cxEdit, cxCheckBox, cxTextEdit, cxDropDownEdit, cxMaskEdit, cxSpinEdit,
  cxFontNameComboBox, dxColorEdit, cxColorComboBox, cxImageComboBox, cxImage,
  cxCurrencyEdit, cxCalendar, dxMessages,

  cxLookAndFeelPainters,
  dxLayoutContainer, dxLayoutControl, dxLayoutcxEditAdapters,
  dxLayoutLookAndFeels, dxLayoutControlAdapters,

  dxChartCore,
  dxChartControl;

type
  TfrmChartDesigner = class;

  TdxChartDesignerTreeViewViewInfo = class;
  TdxChartDesignerTreeView = class;

  { TdxChartDesignerTreeViewNodeData }

  TdxChartDesignerTreeViewNodeData = class
  strict private
    FObject: TPersistent;
  protected
    procedure CommandIconClick(AIndex: Integer); virtual;
    function GetCommandIconImageIndex(AIndex: Integer): Integer; virtual;
    function GetCommandIconHint(AIndex: Integer): string; virtual;
    function GetCommandIconCount: Integer; virtual;

    function IsValid: Boolean;
    procedure SetDirty;

    function CanDrag: Boolean; virtual;
    function CanDrop(const P: TPoint; AHitNodeObject: TdxChartDesignerTreeViewNodeData; var AAfter: Boolean): Boolean; virtual;
    procedure Drop(const P: TPoint; AHitNodeObject: TdxChartDesignerTreeViewNodeData); virtual;
  public
    constructor Create(AObject: TPersistent);

    property &Object: TPersistent read FObject;
  end;

  { TdxChartDesignerTreeViewNode }

  TdxChartDesignerTreeViewNode = class(TdxTreeViewNode)
  strict private
    function GetData: TdxChartDesignerTreeViewNodeData;
    procedure SetData(const Value: TdxChartDesignerTreeViewNodeData);
  protected
    function IsValid: Boolean;
  public
    property Data: TdxChartDesignerTreeViewNodeData read GetData write SetData;
  end;

  { TdxChartDesignerTreeViewHitTest }

  TdxChartDesignerTreeViewHitTest = class(TdxTreeViewHitTest)
  strict private
    FHitAtCommandIcon: Boolean;
    FHitCommandIconBounds: TRect;
    FHitCommandIconIndex: Integer;
    function GetHitData: TdxChartDesignerTreeViewNodeData; inline;
  public
    procedure Reset; override;

    property HitAtCommandIcon: Boolean read FHitAtCommandIcon write FHitAtCommandIcon;
    property HitCommandIconBounds: TRect read FHitCommandIconBounds write FHitCommandIconBounds;
    property HitCommandIconIndex: Integer read FHitCommandIconIndex write FHitCommandIconIndex;
    property HitData: TdxChartDesignerTreeViewNodeData read GetHitData;
  end;

  { TdxChartDesignerDragHelper }

  TdxChartDesignerDragHelper = class
  public const
    AutoExpandInterval = 500;
  strict private
    FArrowLeft: TcxDragAndDropArrow;
    FArrowRight: TcxDragAndDropArrow;
    FAutoExpandingTimer: TcxTimer;
    FAutoScrollHelper: TdxAutoScrollHelper;
    FIsDragging: Boolean;
    FNode: TdxChartDesignerTreeViewNode;
    FStartPoint: TPoint;
    FTreeView: TdxChartDesignerTreeView;
    procedure AutoExpandingTimerHandler(Sender: TObject);
    procedure CalculateArrows;
    procedure RecreateAutoScrollHelper;
  protected
    function CanDrop: Boolean; overload;
    function CanDrop(var AAfter: Boolean): Boolean; overload;
    procedure DoCancelDrag; virtual;
    procedure DoDragDrop(const P: TPoint); virtual;
    procedure DoDrop(const P: TPoint); virtual;
    procedure HideArrows;
    function IsStarting: Boolean;
    property TreeView: TdxChartDesignerTreeView read FTreeView;
  public
    constructor Create(ATreeView: TdxChartDesignerTreeView); virtual;
    destructor Destroy; override;

    procedure CancelDrag;
    procedure DragDrop(const P: TPoint);
    procedure EndDrag(const P: TPoint);
    procedure StartDrag;

    property IsDragging: Boolean read FIsDragging;
  end;

  { TdxChartDesignerTreeViewHintHelper }

  TdxChartDesignerTreeViewHintHelper = class(TdxCustomTreeViewHintHelper)
  strict private
    FLockCount: Integer;
    function GetTreeView: TdxChartDesignerTreeView; inline;
  protected
    function CanShowHint: Boolean; override;
    function UseHintHidePause: Boolean; override;
  public
    procedure CheckHint; override;

    procedure BeginUpdate;
    procedure EndUpdate;

    property TreeView: TdxChartDesignerTreeView read GetTreeView;
  end;

  { TdxChartDesignerTreeView }

  TdxChartDesignerTreeViewCommandButtonClickEvent = procedure(Sender: TObject; AIndex: Integer) of object;

  TdxChartDesignerTreeView = class(TdxTreeViewControl)
  strict private
    FCommandIcons: TCustomImageList;
    FCommandIconsChangeLink: TChangeLink;
    FDragHelper: TdxChartDesignerDragHelper;
    procedure CalculateItemHeight;
    function GetHintHelper: TdxChartDesignerTreeViewHintHelper; inline;
    function GetHitTest: TdxChartDesignerTreeViewHitTest; inline;
    function GetViewInfo: TdxChartDesignerTreeViewViewInfo; inline;
    procedure SetCommandIcons(const Value: TCustomImageList);
  protected
    procedure ChangeScaleEx(M, D: Integer; isDpiChange: Boolean); override;
    procedure Click; override;
    function CreateHintHelper: TdxCustomTreeViewHintHelper; override;
    function CreateHitTest: TdxTreeViewHitTest; override;
    function CreateViewInfo: TdxTreeViewViewInfo; override;
    function GetNodeClass: TdxTreeViewNodeClass; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X: Integer; Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer); override;

    function CreateDragHelper: TdxChartDesignerDragHelper; virtual;

    property HintHelper: TdxChartDesignerTreeViewHintHelper read GetHintHelper;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property DragHelper: TdxChartDesignerDragHelper read FDragHelper;
    property HitTest: TdxChartDesignerTreeViewHitTest read GetHitTest;
    property ViewInfo: TdxChartDesignerTreeViewViewInfo read GetViewInfo;
  published
    property CommandIcons: TCustomImageList read FCommandIcons write SetCommandIcons;
  end;

  { TdxChartDesignerTreeViewNodeViewInfo }

  TdxChartDesignerTreeViewNodeViewInfo = class(TdxTreeViewNodeViewInfo)
  strict private
    FCommandIcons: TList<TRect>;
    function CanShowCommandIcons: Boolean;
    procedure CalculateCommandIcons;
    procedure DrawCommandIcons(ACanvas: TcxCanvas);
    function GetNode: TdxChartDesignerTreeViewNode;
    function GetTreeView: TdxChartDesignerTreeView;
  protected
    procedure AdjustTextRect(AFont: TFont = nil); override;

    property TreeView: TdxChartDesignerTreeView read GetTreeView;
  public
    constructor Create(ATreeView: TdxCustomTreeView); override;
    destructor Destroy; override;

    procedure CalculateHitTest(AHitTest: TdxTreeViewHitTest); override;
    function CalculateSelectionRect: TRect; override;
    procedure DefaultDraw(ACanvas: TcxCanvas); override;

    property Node: TdxChartDesignerTreeViewNode read GetNode;
  end;

  { TdxChartDesignerTreeViewViewInfo }

  TdxChartDesignerTreeViewViewInfo = class(TdxTreeViewViewInfo)
  protected
    function CreateNodeViewInfo: TdxTreeViewNodeViewInfo; override;
  end;

  { TdxChartDesignerPopupMenu }

  TdxChartDesignerPopupMenu = class(TComponent)
  strict private
    FAdapter: TdxCustomBuiltInPopupMenuAdapter;
    FImages: TcxImageList;
    procedure PopupMenuItemClickHandler(Sender: TObject);
  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    function Popup(AControl: TWinControl; APopupMenu: TPopupMenu; const P: TPoint): Boolean;
  end;

  { TfrmChartDesigner }

  TfrmChartDesignerClass = class of TfrmChartDesigner;
  TfrmChartDesigner = class(TdxForm,
      IcxDialogMetricsInfoData,
      IcxLookAndFeelNotificationListener,
      IcxLookAndFeelNotificationListener2)
    lcMainGroup_Root: TdxLayoutGroup;
    lcMain: TdxLayoutControl;
    dxLayoutGroup1: TdxLayoutGroup;
    lgAllOptions: TdxLayoutGroup;
    lbButtons: TdxLayoutGroup;
    lgMain: TdxLayoutGroup;
    dxLayoutGroup7: TdxLayoutGroup;
    dxLayoutGroup8: TdxLayoutGroup;
    lsiTreeView: TdxLayoutSplitterItem;
    lsiOptions: TdxLayoutSplitterItem;
    liTreeView: TdxLayoutItem;
    lfMain: TdxLayoutLookAndFeelList;
    llfMain: TdxLayoutCxLookAndFeel;
    lgOptions: TdxLayoutGroup;
    btnOk: TcxButton;
    liOk: TdxLayoutItem;
    btnCancel: TcxButton;
    liCancel: TdxLayoutItem;
    ilTreeView: TcxImageList;
    ilTreeViewCommands: TcxImageList;
    liChartControl: TdxLayoutItem;
    pmChart: TPopupMenu;
    ilPopupMenu: TcxImageList;
    alMain: TActionList;
    aAddXYDiagram: TAction;
    aAddSimpleDiagram: TAction;
    XYDiagram1: TMenuItem;
    SimpleDiagram1: TMenuItem;
    pmSeries: TPopupMenu;
    aAddPieSeries: TAction;
    aAddDoughnutSeries: TAction;
    aAddLineSeries: TAction;
    aAddBarSeries: TAction;
    aAddStackedBarSeries: TAction;
    aAddStackedBarSideBySideSeries: TAction;
    aAddFullStackedBarSeries: TAction;
    aAddFullStackedBarSideBySideSeries: TAction;
    miAddPieSeries: TMenuItem;
    miAddDoughnutSeries: TMenuItem;
    miAddLineSeries: TMenuItem;
    miAddBarSeries: TMenuItem;
    miAddStackedBarSeries: TMenuItem;
    miAddFullStackedBarSeries: TMenuItem;
    miAddStackedBarSideBySideSeries: TMenuItem;
    miAddFullStackedBarSideBySideSeries: TMenuItem;
    btnClose: TcxButton;
    liClose: TdxLayoutItem;
    aClose: TAction;
    aCancel: TAction;
    lgDiagramOptions: TdxLayoutGroup;
    lgSeriesOptions: TdxLayoutGroup;
    lliOptionsGeneral: TdxLayoutLabeledItem;
    lsiOptionsGeneral: TdxLayoutSeparatorItem;
    lgAppearance: TdxLayoutGroup;
    lgLegend: TdxLayoutGroup;
    lgTitle: TdxLayoutGroup;
    lgTitles: TdxLayoutGroup;
    liTitleVisible: TdxLayoutItem;
    liTitleWordWrap: TdxLayoutItem;
    seTitleMaxLineCount: TcxSpinEdit;
    liTitleMaxLineCount: TdxLayoutItem;
    cbTitleVisibility: TcxCheckBox;
    cbTitleWordWrap: TcxCheckBox;
    cbTitleDock: TcxComboBox;
    liTitleDock: TdxLayoutItem;
    cbTitleAlignment: TcxComboBox;
    liTitleAlignment: TdxLayoutItem;
    lgOptionsGeneral: TdxLayoutGroup;
    teTitleText: TcxTextEdit;
    liTitleText: TdxLayoutItem;
    lliFont: TdxLayoutLabeledItem;
    lsiFont: TdxLayoutSeparatorItem;
    dxLayoutGroup2: TdxLayoutGroup;
    fncbAppearance: TcxFontNameComboBox;
    liFontName: TdxLayoutItem;
    seFontSize: TcxSpinEdit;
    liFontSize: TdxLayoutItem;
    lcbiFontBold: TdxLayoutCheckBoxItem;
    lcbiFontItalic: TdxLayoutCheckBoxItem;
    lcbiFontUnderline: TdxLayoutCheckBoxItem;
    lcbiFontStrikeout: TdxLayoutCheckBoxItem;
    liFontColor: TdxLayoutItem;
    lgAppearanceFont: TdxLayoutGroup;
    ceFontColor: TdxColorEdit;
    lgAppearanceMargins: TdxLayoutGroup;
    lliMargins: TdxLayoutLabeledItem;
    dxLayoutGroup3: TdxLayoutGroup;
    dxLayoutSeparatorItem1: TdxLayoutSeparatorItem;
    liMarginTop: TdxLayoutItem;
    liMarginBottom: TdxLayoutItem;
    liMarginLeft: TdxLayoutItem;
    liMarginRight: TdxLayoutItem;
    seMarginTop: TcxSpinEdit;
    seMarginBottom: TcxSpinEdit;
    seMarginLeft: TcxSpinEdit;
    seMarginRight: TcxSpinEdit;
    lgAppearanceBorder: TdxLayoutGroup;
    lgTitleGeneral: TdxLayoutGroup;
    lliBorder: TdxLayoutLabeledItem;
    dxLayoutSeparatorItem2: TdxLayoutSeparatorItem;
    dxLayoutGroup4: TdxLayoutGroup;
    liBorderColor: TdxLayoutItem;
    liBorderWidth: TdxLayoutItem;
    seBorderWidth: TcxSpinEdit;
    ceBorderColor: TdxColorEdit;
    lgAppearanceOther: TdxLayoutGroup;
    lliAppearanceOther: TdxLayoutLabeledItem;
    dxLayoutSeparatorItem3: TdxLayoutSeparatorItem;
    dxLayoutGroup5: TdxLayoutGroup;
    lgFontStyle: TdxLayoutGroup;
    lcbiTitlesVisible: TdxLayoutCheckBoxItem;
    lcbiLegendVisible: TdxLayoutCheckBoxItem;
    liLegendDirection: TdxLayoutItem;
    lcbiLegendCaptions: TdxLayoutCheckBoxItem;
    lcbiLegendButtons: TdxLayoutCheckBoxItem;
    lcbiLegendImages: TdxLayoutCheckBoxItem;
    lgLegendGeneral: TdxLayoutGroup;
    lgLegendLayout: TdxLayoutGroup;
    lgOptionsLayout: TdxLayoutGroup;
    dxLayoutSeparatorItem4: TdxLayoutSeparatorItem;
    lliOptionsLayout: TdxLayoutLabeledItem;
    liLegendAlignmentHorizontal: TdxLayoutItem;
    liLegendAlignmentVertical: TdxLayoutItem;
    cbLegendAlignmentHorizontal: TcxComboBox;
    cbLegendAlignmentVertical: TcxComboBox;
    tPostEditValueUpdate: TTimer;
    lcbiFont: TdxLayoutCheckBoxItem;
    cbLegendDirection: TcxComboBox;
    lcbiBorder: TdxLayoutCheckBoxItem;
    lgAppearancePadding: TdxLayoutGroup;
    lliPadding: TdxLayoutLabeledItem;
    dxLayoutSeparatorItem5: TdxLayoutSeparatorItem;
    dxLayoutGroup11: TdxLayoutGroup;
    liPaddingTop: TdxLayoutItem;
    liPaddingBottom: TdxLayoutItem;
    liPaddingLeft: TdxLayoutItem;
    liPaddingRight: TdxLayoutItem;
    sePaddingTop: TcxSpinEdit;
    sePaddingLeft: TcxSpinEdit;
    sePaddingRight: TcxSpinEdit;
    sePaddingBottom: TcxSpinEdit;
    lgAppearanceBackground: TdxLayoutGroup;
    lliBackground: TdxLayoutLabeledItem;
    dxLayoutSeparatorItem6: TdxLayoutSeparatorItem;
    liBackgroundColor: TdxLayoutItem;
    liBackgroundGradientEndColor: TdxLayoutItem;
    liBackgroundMode: TdxLayoutItem;
    liBackgroundHatchStyle: TdxLayoutItem;
    liBackgroundGradientMode: TdxLayoutItem;
    dxLayoutGroup12: TdxLayoutGroup;
    ceBackgroundColor: TdxColorEdit;
    ceBackgroundGradientEndColor: TdxColorEdit;
    cbBackgroundMode: TcxComboBox;
    cbBackgroundGradientMode: TcxComboBox;
    lcbiParentBackground: TdxLayoutCheckBoxItem;
    liBackgroundPatternColor: TdxLayoutItem;
    ceBackgroundPatternColor: TdxColorEdit;
    ilHatch: TcxImageList;
    icbBackgroundHatchStyle: TcxImageComboBox;
    iBackgroundTexture: TcxImage;
    liBackgroundTexture: TdxLayoutItem;
    lgSeriesGeneral: TdxLayoutGroup;
    lcbiSeriesVisible: TdxLayoutCheckBoxItem;
    liSeriesSortBy: TdxLayoutItem;
    liSeriesSortOrder: TdxLayoutItem;
    cbSeriesSortBy: TcxComboBox;
    cbSeriesSortOrder: TcxComboBox;
    liSeriesShowInLegend: TdxLayoutItem;
    cbSeriesShowInLegend: TcxComboBox;
    lgSeriesTopNOptions: TdxLayoutGroup;
    dxLayoutGroup13: TdxLayoutGroup;
    dxLayoutSeparatorItem7: TdxLayoutSeparatorItem;
    lliSeriesTopN: TdxLayoutLabeledItem;
    lcbiSeriesTopNEnabled: TdxLayoutCheckBoxItem;
    liTopNMode: TdxLayoutItem;
    lcbiTopNShowOthers: TdxLayoutCheckBoxItem;
    liTopNThresholdPercent: TdxLayoutItem;
    liTopNCount: TdxLayoutItem;
    cbTopNMode: TcxComboBox;
    seTopNCount: TcxSpinEdit;
    liTopNThresholdValue: TdxLayoutItem;
    seTopNThresholdValue: TcxSpinEdit;
    seTopNThresholdPercent: TcxSpinEdit;
    liLegendMaxCaptionWidth: TdxLayoutItem;
    seLegendMaxCaptionWidth: TcxSpinEdit;
    btnDown: TcxButton;
    btnUp: TcxButton;
    dxLayoutItem9: TdxLayoutItem;
    dxLayoutItem10: TdxLayoutItem;
    dxLayoutGroup15: TdxLayoutGroup;
    aUp: TAction;
    aDown: TAction;
    lgValueLabels: TdxLayoutGroup;
    lgValueLabelsGeneral: TdxLayoutGroup;
    lgValueLabelsText: TdxLayoutGroup;
    lcbiValueLabelsVisible: TdxLayoutCheckBoxItem;
    lcbiValueLabelsLineVisible: TdxLayoutCheckBoxItem;
    liValueLabelsLineLength: TdxLayoutItem;
    liValueLabelsAlignment: TdxLayoutItem;
    liValueLabelsFormat: TdxLayoutItem;
    liValueLabelsMaxWidth: TdxLayoutItem;
    liValueLabelsMaxLineCount: TdxLayoutItem;
    lliTextOptions: TdxLayoutLabeledItem;
    dxLayoutSeparatorItem8: TdxLayoutSeparatorItem;
    lgValueLabelsTextCaption: TdxLayoutGroup;
    seValueLabelsLineLength: TcxSpinEdit;
    seValueLabelsMaxWidth: TcxSpinEdit;
    seValueLabelsMaxLineCount: TcxSpinEdit;
    cbValueLabelsTextAlignment: TcxComboBox;
    teValueLabelsTextFormat: TcxTextEdit;
    lgMarkers: TdxLayoutGroup;
    lcbiMarkerVisible: TdxLayoutCheckBoxItem;
    liMarkerType: TdxLayoutItem;
    liMarkerSize: TdxLayoutItem;
    seMarkerSize: TcxSpinEdit;
    cbMarkerType: TcxComboBox;
    lgAxis: TdxLayoutGroup;
    lgAxisGeneral: TdxLayoutGroup;
    lgAxisVisualRange: TdxLayoutGroup;
    lgAxisWholeRange: TdxLayoutGroup;
    lcbiAxisVisible: TdxLayoutCheckBoxItem;
    liAxisVisualRangeMinValue: TdxLayoutItem;
    liAxisVisualRangeMaxValue: TdxLayoutItem;
    liAxisWholeRangeMinValue: TdxLayoutItem;
    liAxisWholeRangeMaxValue: TdxLayoutItem;
    lcbiAxisVisualRangeAuto: TdxLayoutCheckBoxItem;
    lcbiAxisWholeRangeAuto: TdxLayoutCheckBoxItem;
    dxLayoutSeparatorItem9: TdxLayoutSeparatorItem;
    dxLayoutSeparatorItem10: TdxLayoutSeparatorItem;
    lliAxisVisualRange: TdxLayoutLabeledItem;
    lliAxisWholeRange: TdxLayoutLabeledItem;
    dxLayoutGroup18: TdxLayoutGroup;
    dxLayoutGroup19: TdxLayoutGroup;
    seWholeRangeMaxValue: TcxSpinEdit;
    seWholeRangeMinValue: TcxSpinEdit;
    seVisualRangeMaxValue: TcxSpinEdit;
    seVisualRangeMinValue: TcxSpinEdit;
    lgMarkersGeneral: TdxLayoutGroup;
    liAxisSideMargin: TdxLayoutItem;
    seAxisSideMargin: TcxSpinEdit;
    lgAppearanceAxis: TdxLayoutGroup;
    liAppearanceAxisGridlinesColor: TdxLayoutItem;
    liAppearanceAxisGridlinesMinorColor: TdxLayoutItem;
    liAppearanceAxisThickness: TdxLayoutItem;
    liAppearanceAxisTicksThickness: TdxLayoutItem;
    liAppearanceAxisTicksLength: TdxLayoutItem;
    lliAppearanceAxis: TdxLayoutLabeledItem;
    dxLayoutSeparatorItem11: TdxLayoutSeparatorItem;
    dxLayoutGroup20: TdxLayoutGroup;
    ceAppearanceAxisGridlinesColor: TdxColorEdit;
    ceAppearanceAxisGridlinesMinorColor: TdxColorEdit;
    seAppearanceAxisThickness: TcxSpinEdit;
    seAppearanceAxisTicksThickness: TcxSpinEdit;
    seAppearanceAxisTicksLength: TcxSpinEdit;
    liTitleAxisPosition: TdxLayoutItem;
    cbTitleAxisPosition: TcxComboBox;
    liDiagramLayoutDirection: TdxLayoutItem;
    liDiagramDimension: TdxLayoutItem;
    seDiagramDimension: TcxSpinEdit;
    cbDiagramLayoutDirection: TcxComboBox;
    lgDiagramGeneral: TdxLayoutGroup;
    lcbiDiagramVisible: TdxLayoutCheckBoxItem;
    lgSeriesViewOptions: TdxLayoutGroup;
    lliSeriesView: TdxLayoutLabeledItem;
    dxLayoutSeparatorItem12: TdxLayoutSeparatorItem;
    liSeriesViewHoleRadius: TdxLayoutItem;
    liSeriesViewStartAngle: TdxLayoutItem;
    liSeriesViewSweepDirection: TdxLayoutItem;
    liSeriesViewExplodedValueMode: TdxLayoutItem;
    dxLayoutGroup22: TdxLayoutGroup;
    seSeriesViewHoleRadius: TcxSpinEdit;
    seSeriesViewStartAngle: TcxSpinEdit;
    cbSeriesViewExplodedValueMode: TcxComboBox;
    cbSeriesViewSweepDirection: TcxComboBox;
    lgTitlesGeneral: TdxLayoutGroup;
    liAxisAlignment: TdxLayoutItem;
    lcbiAxisReverse: TdxLayoutCheckBoxItem;
    cbAxisAlignment: TcxComboBox;
    liValueLabelsPosition: TdxLayoutItem;
    cbValueLabelsPosition: TcxComboBox;
    liPaddingAll: TdxLayoutItem;
    sePaddingAll: TcxSpinEdit;
    liMarginAll: TdxLayoutItem;
    seMarginAll: TcxSpinEdit;
    llfGroupCaptions: TdxLayoutCxLookAndFeel;
    lcbiAxisGridlines: TdxLayoutCheckBoxItem;
    lcbiAxisInterlaced: TdxLayoutCheckBoxItem;
    lcbiDiagramRotated: TdxLayoutCheckBoxItem;
    seAxisMinorCount: TcxSpinEdit;
    liAxisMinorCount: TdxLayoutItem;
    lgAxisGridlines: TdxLayoutGroup;
    lcbiAxisGridlinesMinorVisible: TdxLayoutCheckBoxItem;
    lgAxisGridlinesGeneral: TdxLayoutGroup;
    lgAppearanceAxisGridlines: TdxLayoutGroup;
    lliAppearanceAxisGridlines: TdxLayoutLabeledItem;
    dxLayoutSeparatorItem13: TdxLayoutSeparatorItem;
    dxLayoutGroup6: TdxLayoutGroup;
    liAppearanceAxisGridlinesMinorStyle: TdxLayoutItem;
    liAppearanceAxisGridlinesStyle: TdxLayoutItem;
    liAppearanceAxisGridlinesThickness: TdxLayoutItem;
    liAppearanceAxisGridlinesMinorThickness: TdxLayoutItem;
    seAppearanceAxisGridlinesThickness: TcxSpinEdit;
    seAppearanceAxisGridlinesMinorThickness: TcxSpinEdit;
    cbAppearanceAxisGridlinesStyle: TcxComboBox;
    cbAppearanceAxisGridlinesMinorStyle: TcxComboBox;
    lgAxisValueLabels: TdxLayoutGroup;
    lgAxisValueLabelsGeneral: TdxLayoutGroup;
    liAxisValueLabelsAlignment: TdxLayoutItem;
    liAxisValueLabelsMaxLineCount: TdxLayoutItem;
    liAxisValueLabelsAngle: TdxLayoutItem;
    liAxisValueLabelsPosition: TdxLayoutItem;
    liAxisValueLabelsMaxWidth: TdxLayoutItem;
    lcbiAxisValueLabelsVisible: TdxLayoutCheckBoxItem;
    liAxisValueLabelsResolveOverlappingIndent: TdxLayoutItem;
    lgAxisValueLabelsResolveOverlapping: TdxLayoutGroup;
    lliAxisValueLabelsResolveOverlapping: TdxLayoutLabeledItem;
    dxLayoutSeparatorItem14: TdxLayoutSeparatorItem;
    dxLayoutGroup10: TdxLayoutGroup;
    cbAxisValueLabelsAlignment: TcxComboBox;
    cbAxisValueLabelsPosition: TcxComboBox;
    seAxisValueLabelsMaxLineCount: TcxSpinEdit;
    seAxisValueLabelsMaxWidth: TcxSpinEdit;
    seAxisValueLabelsAngle: TcxSpinEdit;
    seAxisValueLabelsResolveOverlappingIndent: TcxSpinEdit;
    aAddAreaSeries: TAction;
    miAddAreaSeries: TMenuItem;
    lgAxisTicks: TdxLayoutGroup;
    lliAxisTicks: TdxLayoutLabeledItem;
    dxLayoutSeparatorItem15: TdxLayoutSeparatorItem;
    dxLayoutGroup9: TdxLayoutGroup;
    lcbiAxisTicksVisible: TdxLayoutCheckBoxItem;
    lcbiAxisTicksMinorVisible: TdxLayoutCheckBoxItem;
    liAxisTicksCrossKind: TdxLayoutItem;
    liAxisTicksMinorCrossKind: TdxLayoutItem;
    cbAxisTicksCrossKind: TcxComboBox;
    cbAxisTicksMinorCrossKind: TcxComboBox;
    lgAppearanceAxisTicks: TdxLayoutGroup;
    lliAppearanceAxisTicks: TdxLayoutLabeledItem;
    dxLayoutSeparatorItem16: TdxLayoutSeparatorItem;
    dxLayoutGroup14: TdxLayoutGroup;
    liAppearanceAxisTicksMinorLength: TdxLayoutItem;
    liAppearanceAxisTicksMinorThickness: TdxLayoutItem;
    liAppearanceAxisColor: TdxLayoutItem;
    lgAppearanceAxisInterlaced: TdxLayoutGroup;
    lliAppearanceAxisInterlaced: TdxLayoutLabeledItem;
    dxLayoutSeparatorItem17: TdxLayoutSeparatorItem;
    dxLayoutGroup21: TdxLayoutGroup;
    seAppearanceAxisTicksMinorThickness: TcxSpinEdit;
    seAppearanceAxisTicksMinorLength: TcxSpinEdit;
    cbAppearanceAxisInterlacedMode: TcxComboBox;
    ceAppearanceAxisInterlacedColor: TdxColorEdit;
    ceAppearanceAxisInterlacedGradientEndColor: TdxColorEdit;
    ceAppearanceAxisInterlacedPattern: TdxColorEdit;
    icbAppearanceAxisInterlacedStyle: TcxImageComboBox;
    cbAppearanceAxisInterlacedGradient: TcxComboBox;
    iAppearanceAxisInterlacedTexture: TcxImage;
    liAppearanceAxisInterlacedMode: TdxLayoutItem;
    liAppearanceAxisInterlacedGradientEndColor: TdxLayoutItem;
    liAppearanceAxisInterlacedPattern: TdxLayoutItem;
    liAppearanceAxisInterlacedStyle: TdxLayoutItem;
    liAppearanceAxisInterlacedGradient: TdxLayoutItem;
    liAppearanceAxisInterlacedTexture: TdxLayoutItem;
    liAppearanceAxisInterlacedColor: TdxLayoutItem;
    ceAppearanceAxisColor: TdxColorEdit;
    liAppearanceStrokeColor: TdxLayoutItem;
    lgAppearanceStroke: TdxLayoutGroup;
    liAppearanceStrokeStyle: TdxLayoutItem;
    liAppearanceStrokeThickness: TdxLayoutItem;
    lliAppearanceStroke: TdxLayoutLabeledItem;
    dxLayoutSeparatorItem18: TdxLayoutSeparatorItem;
    dxLayoutGroup23: TdxLayoutGroup;
    ceAppearanceStrokeColor: TdxColorEdit;
    seAppearanceStrokeThickness: TcxSpinEdit;
    cbAppearanceStrokeStyle: TcxComboBox;
    liSeriesBarWidth: TdxLayoutItem;
    seSeriesBarWidth: TcxSpinEdit;
    lgChartOptions: TdxLayoutGroup;
    aAddStackedAreaSeries: TAction;
    aAddFullStackedAreaSeries: TAction;
    aAddStackedLineSeries: TAction;
    aAddFullStackedLineSeries: TAction;
    miAddStackedAreaSeries: TMenuItem;
    miAddFullStackedAreaSeries: TMenuItem;
    miAddStackedLineSeries: TMenuItem;
    miAddFullStackedLineSeries: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    liAppearanceAxisInterlacedGradientBeginColor: TdxLayoutItem;
    ceAppearanceAxisInterlacedGradientBeginColor: TdxColorEdit;
    liBackgroundGradientBeginColor: TdxLayoutItem;
    ceBackgroundGradientBeginColor: TdxColorEdit;
    lgAxisMinorTicks: TdxLayoutGroup;
    lliAxisMinorTicks: TdxLayoutLabeledItem;
    dxLayoutSeparatorItem19: TdxLayoutSeparatorItem;
    dxLayoutGroup25: TdxLayoutGroup;
    lgAppearanceAxisMinorTicks: TdxLayoutGroup;
    dxLayoutSeparatorItem20: TdxLayoutSeparatorItem;
    lliAppearanceAxisMinorTicks: TdxLayoutLabeledItem;
    dxLayoutGroup24: TdxLayoutGroup;
    lgAppearanceAxisMinorGridlines: TdxLayoutGroup;
    lliAppearanceAxisMinorGridlines: TdxLayoutLabeledItem;
    dxLayoutSeparatorItem21: TdxLayoutSeparatorItem;
    dxLayoutGroup27: TdxLayoutGroup;
    liSeriesCaption: TdxLayoutItem;
    teSeriesCaption: TcxTextEdit;
    lgValueLabelsResolveOverlapping: TdxLayoutGroup;
    lgValueLabelsResolveOverlappingCaption: TdxLayoutGroup;
    lliValueLabelsResolveOverlapping: TdxLayoutLabeledItem;
    dxLayoutSeparatorItem22: TdxLayoutSeparatorItem;
    liValueLabelsResolveOverlappingIndent: TdxLayoutItem;
    liValueLabelsResolveOverlappingMode: TdxLayoutItem;
    seValueLabelsResolveOverlappingIndent: TcxSpinEdit;
    cbValueLabelsResolveOverlappingMode: TcxComboBox;
    tUpdateOptionsFromChart: TTimer;
    liAxisTicksLabelAlignment: TdxLayoutItem;
    cbAxisTicksLabelAlignment: TcxComboBox;
    tPopulateTreeView: TTimer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lsiOptionsCanResize(Sender: TObject; AItem: TdxCustomLayoutItem;
      var ANewSize: Integer; var AAccept: Boolean);
    procedure lsiTreeViewCanResize(Sender: TObject; AItem: TdxCustomLayoutItem;
      var ANewSize: Integer; var AAccept: Boolean);
    procedure FormResize(Sender: TObject);
    procedure aAddDiagramExecute(Sender: TObject);
    procedure aAddSeriesExecute(Sender: TObject);
    procedure aAddSeriesUpdate(Sender: TObject);
    procedure aCancelExecute(Sender: TObject);
    procedure aCloseExecute(Sender: TObject);
    procedure OptionEditValueChanged(Sender: TObject);
    procedure OptionDisplayValueChange(Sender: TObject);
    procedure tPostEditValueUpdateTimer(Sender: TObject);
    procedure aUpAndDownUpdate(Sender: TObject);
    procedure aUpAndDownExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure tUpdateOptionsFromChartTimer(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure tPopulateTreeViewTimer(Sender: TObject);
  protected const
    TreeViewMinWidth = 220;
    ChartMinWidth = 100;
    OptionsMinWidth = 220;
  strict private
    FInitialized: Boolean;
    FIsClosing: Boolean;
    FLookAndFeel: TcxLookAndFeel;
    FModified: Boolean;
    FOriginalChartControl: TdxCustomChartControl;
    FPostUpdateEditor: TcxCustomEdit;
    FTreeView: TdxChartDesignerTreeView;
    FInnerChartControl: TdxChartControl;
    FLockUpdateOptionsFromChart: Boolean;
    FLockRefreshTreeView: Boolean;

    FLockCount: Integer;
    FPopupMenu: TdxChartDesignerPopupMenu;

    function GetCustomizedChartControl: TdxCustomChartControl;
    procedure ChartChangedHandler(Sender: TObject);

    procedure ColorEditButtonClickHandler(Sender: TObject; AButtonIndex: Integer);
    procedure PostUpdateEditValue(AEditor: TcxCustomEdit);

    procedure StartUpdateOptionsFromChartTimer;
    procedure TreeViewDeletionHandler(Sender: TdxCustomTreeView; Node: TdxTreeViewNode);
    procedure TreeViewSelectionChangedHandler(Sender: TObject);
    procedure DXMScaleChanging(var Message: TMessage); message DXM_SCALECHANGING;
    procedure DXMScaleChanged(var Message: TMessage); message DXM_SCALECHANGED;
  {$REGION 'IcxLookAndFeelNotificationListener'}
    function GetObject: TObject;
    procedure MasterLookAndFeelChanged(Sender: TcxLookAndFeel; AChangedValues: TcxLookAndFeelValues);
    procedure MasterLookAndFeelDestroying(Sender: TcxLookAndFeel);
  {$ENDREGION}
  {$REGION 'IcxLookAndFeelNotificationListener2'}
    procedure MasterLookAndFeelBeginChange;
    procedure MasterLookAndFeelEndChange;
  {$ENDREGION}
  {$REGION 'IcxDialogMetricsInfoData'}
    function GetInfoData: Pointer;
    function GetInfoDataSize: Integer;
    procedure SetInfoData(AData: Pointer);
  {$ENDREGION}
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    procedure ApplyLocalization;
    procedure LocalizeItems(AItems: TStrings; AResourceStrings: TArray<TcxResourceStringID>); overload;
    procedure LocalizeItems(AItems: TcxImageComboBoxItems; AResourceStrings: TArray<TcxResourceStringID>); overload;

    procedure ClearTreeView;
    function CreateNode(AParentNode: TdxTreeViewNode; AObject: TPersistent; ANodeObjectClass: TClass): TdxTreeViewNode;
    procedure DoUpdateOptionsFromChart;
    function GetCustomizedScaleFactor: TdxScaleFactor; virtual;
    procedure FirstTimePopulateTreeView;
    procedure Initialize; virtual;
    procedure InitializeColorEdits; virtual;
    procedure InitializeHatchStyles(AImageComboBox: TcxImageComboBox; ABackColor, AForeColor: TdxAlphaColor);
    procedure InitializeLayoutControl; virtual;
    procedure InitializeTreeView; virtual;
    procedure PopulateTreeView; virtual;
    procedure PostPopulateTreeView;
    procedure UpdateLayoutLookAndFeel;
    procedure UpdateOptionsFromChart;

    function CanResizeOptions(ANewSize: Integer): Boolean; virtual;

    procedure AddChartTitle;
    procedure AddDiagram(AIndex: Integer);
    procedure AddSeries(ADiagram: TdxChartCustomDiagram; AViewClass: TdxChartSeriesViewClass);
    procedure Delete(AObject: TObject);
    procedure DeleteDiagram(ADiagram: TdxChartCustomDiagram);
    procedure DeleteSeries(ASeries: TdxChartCustomSeries);
    function GetNodeByData(AData: TObject): TdxTreeViewNode;
    procedure LocalizeSeriesMenu(AIsAdd: Boolean);

    procedure PopupTreeViewMenu(APopupMenu: TPopupMenu; const P: TPoint);
    procedure SelectNode(ANode: TdxTreeViewNode);
    procedure SelectObject(AObject: TPersistent); virtual;

    procedure BeginUpdate;
    procedure EndUpdate;
    function IsLocked: Boolean;

    procedure ApplyChanges; virtual;
    function CanAddDiagram: Boolean; virtual;
    function CanAddSeries: Boolean; virtual;
    function CanDelete(AComponent: TComponent): Boolean; virtual;
    function GetNodeByObject(AObject: TObject): TdxTreeViewNode;
    procedure GetSelectedNodeObjects(AList: TList);
    function IsDesigning: Boolean; virtual;
    function IsValid: Boolean;
    procedure Modified;
    procedure SetTreeViewSelection(ASelection: TList);
    procedure SyncSelection; virtual;

    property CustomizedChartControl: TdxCustomChartControl read GetCustomizedChartControl;
    property CustomizedScaleFactor: TdxScaleFactor read GetCustomizedScaleFactor;
    property OriginalChartControl: TdxCustomChartControl read FOriginalChartControl;
    property TreeView: TdxChartDesignerTreeView read FTreeView;
  public
    constructor Create(AChartControl: TdxCustomChartControl); reintroduce; virtual;
    destructor Destroy; override;

    procedure LocalizeValueLabelsResolveOverlappingMode(ASetIndex: Integer);
  end;

var
  dxChartDesignerClass: TfrmChartDesignerClass = TfrmChartDesigner;

procedure dxShowChartDesigner(AChartControl: TdxCustomChartControl);

implementation

{$R *.dfm}

uses
  Math, TypInfo, RTLConsts,
  dxTypeHelpers, dxStringHelper, cxCustomCanvas, dxGDIPlusClasses, dxGDIPlusAPI,
  dxColorDialog, dxCustomTree, cxDateUtils, cxVariants,
  cxLibraryConsts, dxMessageDialog, dxDPIAwareUtils,
  dxChartLegend,
  dxChartData,
  dxChartSimpleDiagram,
  dxChartXYDiagram,
  dxChartXYSeriesAreaView,
  dxChartXYSeriesLineView,
  dxChartXYSeriesBarView,
  dxChartStrs, cxFormats;

const
  dxThisUnitName = 'dxChartDesigner';

type
  TDesignerSessionData = record
    TreeViewWidth: Integer;
    OptionsWidth: Integer;
  end;
  TdxChartCustomItemViewInfoAccess = class(TdxChartCustomItemViewInfo);

var
  FDesignerSessionData: TDesignerSessionData;

const
  FSeriesMap: array[0..12] of TdxChartSeriesViewClass = (
    TdxChartSimpleSeriesPieView,                  
    TdxChartSimpleSeriesDoughnutView,             
    TdxChartXYSeriesLineView,                     
    TdxChartXYSeriesBarView,                      
    TdxChartXYSeriesStackedBarView,               
    TdxChartXYSeriesStackedBarSideBySideView,     
    TdxChartXYSeriesFullStackedBarView,           
    TdxChartXYSeriesFullStackedBarSideBySideView, 
    TdxChartXYSeriesAreaView,                     
    TdxChartXYSeriesStackedAreaView,              
    TdxChartXYSeriesFullStackedAreaView,          
    TdxChartXYSeriesStackedLineView,              
    TdxChartXYSeriesFullStackedLineView);         

  FDefaultBooleanToCheckBoxState: array[TdxDefaultBoolean] of TcxCheckBoxState = (cbsUnchecked, cbsChecked, cbsGrayed);
  FCheckBoxStateToDefaultBoolean: array[TcxCheckBoxState] of TdxDefaultBoolean = (bFalse, bTrue, bDefault);
type
  TdxCustomChartControlAccess = class(TdxCustomChartControl);
  TdxChartCustomDiagramAccess = class(TdxChartCustomDiagram);
  TdxChartCustomSeriesAccess = class(TdxChartCustomSeries);
  TdxTreeViewNodeViewInfoAccess = class(TdxTreeViewNodeViewInfo);
  TdxChartCustomAppearanceAccess = class(TdxChartVisualElementAppearance);
  TdxChartCustomLegendAccess = class(TdxChartCustomLegend);
  TdxChartSeriesValueLabelsAccess = class(TdxChartSeriesValueLabels);
  TdxChartSeriesCustomViewAccess = class(TdxChartSeriesCustomView);
  TdxChartCustomAxisAccess = class(TdxChartCustomAxis);
  TdxChartAxisAppearanceAccess = class(TdxChartAxisAppearance);
  TdxChartVisualElementTitleAccess = class(TdxChartVisualElementTitle);
  TdxChartSimpleSeriesCustomPieViewAccess = class(TdxChartSimpleSeriesCustomPieView);
  TdxLayoutControlViewInfoAccess = class(TdxLayoutControlViewInfo);
  TdxLayoutCheckBoxItemAccess = class(TdxLayoutCheckBoxItem);
  TdxLayoutGroupAccess = class(TdxLayoutGroup);
  TdxChartRangeAccess = class(TdxChartRange);
  TdxChartElementTitleAccess = class(TdxChartVisualElementTitle);
  TdxChartAxisXViewDataAccess = class(TdxChartAxisXViewData);
  TdxChartTitleCollectionItemAccess = class(TdxChartTitleCollectionItem);
  TdxChartTitleAccess = class(TdxChartTitle);
  TdxChartAccess = class(TdxChart);

  TDiagramSeriesNodeObject = class;
  TDiagramSeriesNodeObjectClass = class of TDiagramSeriesNodeObject;

  { TdxChartVisualElementAppearanceHelper }
  
  TdxChartVisualElementAppearanceHelper = class helper for TdxChartVisualElementAppearance
  private
    function GetActualBorderValue: Boolean;
    function GetPaintBorderColor: TdxAlphaColor;
    function GetPaintBorderThickness: Single;
  public
    property ActualBorderValue: Boolean read GetActualBorderValue;
    property PaintBorderColor: TdxAlphaColor read GetPaintBorderColor;
    property PaintBorderThickness: Single read GetPaintBorderThickness;
  end;

  { TdxChartAxisGridlinesHelper }

  TdxChartAxisGridlinesHelper = class helper for TdxChartAxisGridlines
  private
    function GetPaintColor: TdxAlphaColor;
    function GetPaintMinorColor: TdxAlphaColor;
  public
    property PaintColor: TdxAlphaColor read GetPaintColor;
    property PaintMinorColor: TdxAlphaColor read GetPaintMinorColor;    
  end;

  { TcxCustomEditHelper }

  TcxCustomEditHelper = class helper for TcxCustomEdit
  strict private
    procedure InternalPostValue;
  public
    function NeedUpdateChartValue: Boolean;
    procedure PostValue;
  end;

  { TcxSpinEditHelper }

  TcxSpinEditHelper = class helper for TcxSpinEdit
  strict private
    function GetIsCustomText: Boolean;
    procedure SetIsCustomText(const AValue: Boolean);
  public
    procedure InitializeFormats;
    property IsCustomText: Boolean read GetIsCustomText write SetIsCustomText;
  end;

  { TNodeObject }

  TNodeObjectClass = class of TNodeObject;
  TNodeObject = class(TdxChartDesignerTreeViewNodeData)
  public const
    AddCommandIconIndex = 1;
    AddDiagramCommandIconIndex = 0;
    ChangeSeriesTypeCommandIconIndex = 5;
    RemoveCommandIconIndex = 4;
    VisibilityCommandIconIndex: array[Boolean] of Integer = (3, 2);
  strict private
    FDesigner: TfrmChartDesigner;
    FFreeNotificator: TcxFreeNotificator;
    procedure FreeNotificatorHandler(Sender: TComponent);
    function GetCaption: string;
    function GetNode: TdxTreeViewNode;
  protected
    function CanChangeIndex(ADelta: Integer): Boolean; virtual;
    procedure ChangeIndex(ADelta: Integer); virtual;
    procedure CreateSubNodes; virtual;
    procedure ApplyChangedValueToChart(Sender: TObject); virtual;
    function DoGetCaption: string; virtual;
    procedure DoUpdateAppearanceOptions(AAppearance: TdxChartCustomAppearanceAccess); virtual;
    procedure DoUpdateOptionsFromChart; virtual;
    procedure DoUpdateOptionStates; virtual;
    function GetAppearance: TdxChartCustomAppearanceAccess; virtual;
    function GetImageIndex: Integer; virtual;
    function GetNodeDisplayRect: TRect;
    function GetOptionsGroup: TdxLayoutGroup; virtual;
    procedure InvalidateNode;
    function IsAppearanceEnabled: Boolean; virtual;
    function IsAppearanceVisible: Boolean; virtual;
    function IsEnabled: Boolean; virtual;
    procedure Popup(APopupMenu: TPopupMenu; const P: TPoint); overload;
    procedure Popup(APopupMenu: TPopupMenu; const ACommandIconIndex: Integer); overload;

    procedure DoToggleVisibility; virtual;
    procedure ToggleVisibility;
  public
    constructor Create(ADesigner: TfrmChartDesigner; AObject: TPersistent); reintroduce; virtual;
    destructor Destroy; override;

    property Caption: string read GetCaption;
    property Designer: TfrmChartDesigner read FDesigner;
    property ImageIndex: Integer read GetImageIndex;
    property Node: TdxTreeViewNode read GetNode;
  end;

  { TChartControlNodeObject }

  TChartControlNodeObject = class(TNodeObject)
  strict private
    function GetChartControl: TdxCustomChartControl; inline;
  protected
    procedure ApplyChangedValueToChart(Sender: TObject); override;
    procedure CommandIconClick(AIndex: Integer); override;
    function DoGetCaption: string; override;
    procedure DoUpdateAppearanceOptions(AAppearance: TdxChartCustomAppearanceAccess); override;
    procedure DoUpdateOptionsFromChart; override;
    procedure CreateSubNodes; override;
    function GetAppearance: TdxChartCustomAppearanceAccess; override;
    function GetCommandIconHint(AIndex: Integer): string; override;
    function GetCommandIconImageIndex(AIndex: Integer): Integer; override;
    function GetCommandIconCount: Integer; override;
    function GetImageIndex: Integer; override;
    function GetOptionsGroup: TdxLayoutGroup; override;
    function IsEnabled: Boolean; override;
  public
    property ChartControl: TdxCustomChartControl read GetChartControl;
  end;

  { TChartTitlesNodeObject }

  TChartTitlesNodeObject = class(TNodeObject)
  strict private
    function GetActualVisible: Boolean;
    function GetTitles: TdxChartTitles;
    procedure SetActualVisible(const Value: Boolean);
  protected
    procedure CommandIconClick(AIndex: Integer); override;
    procedure CreateSubNodes; override;
    procedure ApplyChangedValueToChart(Sender: TObject); override;
    function DoGetCaption: string; override;
    procedure DoToggleVisibility; override;
    procedure DoUpdateOptionsFromChart; override;
    function GetCommandIconHint(AIndex: Integer): string; override;
    function GetCommandIconImageIndex(AIndex: Integer): Integer; override;
    function GetCommandIconCount: Integer; override;
    function GetImageIndex: Integer; override;
    function GetOptionsGroup: TdxLayoutGroup; override;
    function IsEnabled: Boolean; override;

    property ActualVisible: Boolean read GetActualVisible write SetActualVisible;
    property Titles: TdxChartTitles read GetTitles;
  end;

  { TChartTitleNodeObject }

  TChartTitleNodeObject = class(TNodeObject)
  strict private
    function GetActualVisible: Boolean;
    function GetTitle: TdxChartTitleCollectionItem;
    procedure SetActualVisible(const Value: Boolean);
  protected
    function CanChangeIndex(ADelta: Integer): Boolean; override;
    procedure ChangeIndex(ADelta: Integer); override;
    procedure CommandIconClick(AIndex: Integer); override;
    procedure ApplyChangedValueToChart(Sender: TObject); override;
    function DoGetCaption: string; override;
    procedure DoToggleVisibility; override;
    procedure DoUpdateOptionsFromChart; override;
    procedure DoUpdateOptionStates; override;
    function GetAppearance: TdxChartCustomAppearanceAccess; override;
    function GetCommandIconHint(AIndex: Integer): string; override;
    function GetCommandIconImageIndex(AIndex: Integer): Integer; override;
    function GetCommandIconCount: Integer; override;
    function GetImageIndex: Integer; override;
    function GetOptionsGroup: TdxLayoutGroup; override;
    function IsAppearanceEnabled: Boolean; override;
    function IsEnabled: Boolean; override;

    function CanDrag: Boolean; override;
    function CanDrop(const P: TPoint; AHitNodeObject: TdxChartDesignerTreeViewNodeData; var AAfter: Boolean): Boolean; override;
    procedure Drop(const P: TPoint; AHitNodeObject: TdxChartDesignerTreeViewNodeData); override;

    property ActualVisible: Boolean read GetActualVisible write SetActualVisible;
    property Title: TdxChartTitleCollectionItem read GetTitle;
  end;

  { TLegendNodeObject }

  TLegendNodeObject = class(TNodeObject)
  strict private
    function GetActualVisible: Boolean;
    function GetLegend: TdxChartCustomLegend;
    procedure SetActualVisible(const Value: Boolean);
  protected
    procedure CommandIconClick(AIndex: Integer); override;
    procedure CreateSubNodes; override;
    procedure ApplyChangedValueToChart(Sender: TObject); override;
    function DoGetCaption: string; override;
    procedure DoToggleVisibility; override;
    procedure DoUpdateOptionStates; override;
    procedure DoUpdateOptionsFromChart; override;
    function GetCommandIconHint(AIndex: Integer): string; override;
    function GetCommandIconImageIndex(AIndex: Integer): Integer; override;
    function GetCommandIconCount: Integer; override;
    function GetImageIndex: Integer; override;
    function GetOptionsGroup: TdxLayoutGroup; override;
    function IsAppearanceEnabled: Boolean; override;
    function IsEnabled: Boolean; override;

    property ActualVisible: Boolean read GetActualVisible write SetActualVisible;
    property Legend: TdxChartCustomLegend read GetLegend;
  end;

  { TTitleNodeObject }

  TTitleNodeObject = class(TNodeObject)
  strict private
    function GetActualVisible: Boolean;
    function GetTitle: TdxChartVisualElementTitle;
    procedure SetActualVisible(const Value: Boolean);
  protected
    procedure CommandIconClick(AIndex: Integer); override;
    procedure ApplyChangedValueToChart(Sender: TObject); override;
    function DoGetCaption: string; override;
    procedure DoToggleVisibility; override;
    procedure DoUpdateOptionsFromChart; override;
    procedure DoUpdateOptionStates; override;
    function GetCommandIconHint(AIndex: Integer): string; override;
    function GetCommandIconImageIndex(AIndex: Integer): Integer; override;
    function GetCommandIconCount: Integer; override;
    function GetImageIndex: Integer; override;
    function GetOptionsGroup: TdxLayoutGroup; override;
    function IsAppearanceEnabled: Boolean; override;
    function IsEnabled: Boolean; override;

    property ActualVisible: Boolean read GetActualVisible write SetActualVisible;
    property Title: TdxChartVisualElementTitle read GetTitle;
  end;

  { TDiagramNodeObject }

  TDiagramNodeObject = class abstract(TNodeObject)
  strict private class var
    FDiagramImageIndexes: TDictionary<TClass, Integer>;

    class function GetDiagramImageIndex(ADiagram: TObject): Integer; static;
  private
    class procedure Initialize;
    class procedure Finalize;
  strict private
    function GetDiagram: TdxChartCustomDiagram; inline;
  protected
    function CanChangeIndex(ADelta: Integer): Boolean; override;
    procedure ChangeIndex(ADelta: Integer); override;
    procedure CommandIconClick(AIndex: Integer); override;
    procedure CreateSubNodes; override;
    procedure ApplyChangedValueToChart(Sender: TObject); override;
    procedure DoCreateSubNodes; virtual;
    function DoGetCaption: string; override;
    procedure DoToggleVisibility; override;
    procedure DoUpdateOptionsFromChart; override;
    procedure DoUpdateOptionStates; override;
    function GetCommandIconHint(AIndex: Integer): string; override;
    function GetCommandIconImageIndex(AIndex: Integer): Integer; override;
    function GetCommandIconCount: Integer; override;
    function GetImageIndex: Integer; override;
    function GetOptionsGroup: TdxLayoutGroup; override;
    function GetSeriesNodeObjectClass: TDiagramSeriesNodeObjectClass; virtual; abstract;
    function IsAppearanceEnabled: Boolean; override;
    function IsEnabled: Boolean; override;

    function CanDrag: Boolean; override;
    function CanDrop(const P: TPoint; AHitNodeObject: TdxChartDesignerTreeViewNodeData; var AAfter: Boolean): Boolean; override;
    procedure Drop(const P: TPoint; AHitNodeObject: TdxChartDesignerTreeViewNodeData); override;

    property Diagram: TdxChartCustomDiagram read GetDiagram;
  end;

  { TXYDiagramNodeObject }

  TXYDiagramNodeObject = class(TDiagramNodeObject)
  strict private
    function GetDiagram: TdxChartXYDiagram; inline;
  protected
    procedure CreateSubNodes; override;
    procedure ApplyChangedValueToChart(Sender: TObject); override;
    procedure DoCreateSubNodes; override;
    procedure DoUpdateOptionsFromChart; override;
    function GetSeriesNodeObjectClass: TDiagramSeriesNodeObjectClass; override;
  public
    property Diagram: TdxChartXYDiagram read GetDiagram;
  end;

  { TXYDiagramNodeObject }

  TSimpleDiagramNodeObject = class(TDiagramNodeObject)
  strict private
    function GetDiagram: TdxChartSimpleDiagram; inline;
  protected
    procedure CreateSubNodes; override;
    procedure ApplyChangedValueToChart(Sender: TObject); override;
    procedure DoUpdateOptionsFromChart; override;
    function GetSeriesNodeObjectClass: TDiagramSeriesNodeObjectClass; override;
  public
    property Diagram: TdxChartSimpleDiagram read GetDiagram;
  end;

  { TDiagramSeriesNodeObject }

  TDiagramSeriesNodeObject = class abstract(TNodeObject)
  strict private class var
    FSeriesImageIndexes: TDictionary<TClass, Integer>;

    class function GetSeriesImageIndex(ASeries: TdxChartCustomSeries): Integer; static;
  private
    class procedure Initialize;
    class procedure Finalize;
  strict private
    function GetSeries: TdxChartCustomSeries; inline;
  protected
    function CanChangeIndex(ADelta: Integer): Boolean; override;

    function CanDrag: Boolean; override;
    function CanDrop(const P: TPoint; AHitNodeObject: TdxChartDesignerTreeViewNodeData; var AAfter: Boolean): Boolean; override;
    procedure Drop(const P: TPoint; AHitNodeObject: TdxChartDesignerTreeViewNodeData); override;

    procedure ChangeIndex(ADelta: Integer); override;
    procedure CommandIconClick(AIndex: Integer); override;
    procedure CreateSubNodes; override;
    procedure ApplyChangedValueToChart(Sender: TObject); override;
    procedure DoCreateSubNodes; virtual;
    function DoGetCaption: string; override;
    procedure DoToggleVisibility; override;
    procedure DoUpdateOptionsFromChart; override;
    procedure DoUpdateOptionStates; override;
    function GetAppearance: TdxChartCustomAppearanceAccess; override;
    function GetCommandIconHint(AIndex: Integer): string; override;
    function GetCommandIconImageIndex(AIndex: Integer): Integer; override;
    function GetCommandIconCount: Integer; override;
    function GetImageIndex: Integer; override;
    function GetOptionsGroup: TdxLayoutGroup; override;
    function IsAppearanceEnabled: Boolean; override;
    function IsEnabled: Boolean; override;
    procedure UpdateNodeCaption;

    property Series: TdxChartCustomSeries read GetSeries;
  end;

  { TXYDiagramSeriesNodeObject }

  TXYDiagramSeriesNodeObject = class(TDiagramSeriesNodeObject)
  protected
    procedure ApplyChangedValueToChart(Sender: TObject); override;
    procedure DoCreateSubNodes; override;
    procedure DoUpdateOptionsFromChart; override;
    procedure DoUpdateOptionStates; override;
  end;

  { TSimpleDiagramSeriesNodeObject }

  TSimpleDiagramSeriesNodeObject = class(TDiagramSeriesNodeObject)
  protected
    procedure DoUpdateOptionsFromChart; override;
  end;

  { TDiagramSeriesValueLabelsNodeObject }

  TDiagramSeriesValueLabelsNodeObject = class(TNodeObject)
  strict private
    function GetActualVisible: Boolean;
    function GetValueLabels: TdxChartSeriesValueLabels; inline;
    procedure SetActualVisible(const Value: Boolean);
  protected
    procedure CommandIconClick(AIndex: Integer); override;
    procedure ApplyChangedValueToChart(Sender: TObject); override;
    function DoGetCaption: string; override;
    procedure DoToggleVisibility; override;
    procedure DoUpdateOptionsFromChart; override;
    procedure DoUpdateOptionStates; override;
    function GetCommandIconHint(AIndex: Integer): string; override;
    function GetCommandIconCount: Integer; override;
    function GetCommandIconImageIndex(AIndex: Integer): Integer; override;
    function GetOptionsGroup: TdxLayoutGroup; override;
    function IsAppearanceEnabled: Boolean; override;
    function IsEnabled: Boolean; override;
  public
    property ActualVisible: Boolean read GetActualVisible write SetActualVisible;
    property ValueLabels: TdxChartSeriesValueLabels read GetValueLabels;
  end;

  { TMarkersNodeObject }

  TMarkersNodeObject = class(TNodeObject)
  strict private
    function GetActualVisible: Boolean;
    function GetMarkers: TdxChartXYSeriesLineMarkers; inline;
    procedure SetActualVisible(const Value: Boolean);
  protected
    procedure CommandIconClick(AIndex: Integer); override;
    procedure ApplyChangedValueToChart(Sender: TObject); override;
    function DoGetCaption: string; override;
    procedure DoToggleVisibility; override;
    procedure DoUpdateOptionsFromChart; override;
    procedure DoUpdateOptionStates; override;
    function GetCommandIconHint(AIndex: Integer): string; override;
    function GetCommandIconCount: Integer; override;
    function GetCommandIconImageIndex(AIndex: Integer): Integer; override;
    function GetOptionsGroup: TdxLayoutGroup; override;
    function IsAppearanceEnabled: Boolean; override;
    function IsEnabled: Boolean; override;
  public
    property ActualVisible: Boolean read GetActualVisible write SetActualVisible;
    property Markers: TdxChartXYSeriesLineMarkers read GetMarkers;
  end;

  { TAxisNodeObject }

  TAxisNodeObject = class abstract(TNodeObject)
  strict private
    FVarType: TVarType;
    procedure UpdateRangeEditors;
    procedure UpdateRangeValues;

    function GetActualVisible: Boolean;
    function GetAxis: TdxChartCustomAxis; inline;
    procedure SetActualVisible(const Value: Boolean);
    procedure SetVarType(const Value: TVarType);
  protected
    procedure CommandIconClick(AIndex: Integer); override;
    procedure CreateSubNodes; override;
    procedure ApplyChangedValueToChart(Sender: TObject); override;
    procedure DoToggleVisibility; override;
    procedure DoUpdateAppearanceOptions(AAppearance: TdxChartCustomAppearanceAccess); override;
    procedure DoUpdateOptionsFromChart; override;
    procedure DoUpdateOptionStates; override;
    function GetCommandIconHint(AIndex: Integer): string; override;
    function GetCommandIconCount: Integer; override;
    function GetCommandIconImageIndex(AIndex: Integer): Integer; override;
    function GetOptionsGroup: TdxLayoutGroup; override;
    function GetRangeMaxValue: Variant;
    function GetRangeMinValue: Variant;
    function IsAppearanceEnabled: Boolean; override;
    function IsEnabled: Boolean; override;

    property VarType: TVarType read FVarType write SetVarType;
  public
    constructor Create(ADesigner: TfrmChartDesigner; AObject: TPersistent); override;
    property ActualVisible: Boolean read GetActualVisible write SetActualVisible;
    property Axis: TdxChartCustomAxis read GetAxis;
  end;

  { TAxisTitleNodeObject }

  TAxisTitleNodeObject = class(TTitleNodeObject)
  strict private
    function GetTitle: TdxChartAxisTitle; inline;
  protected
    procedure ApplyChangedValueToChart(Sender: TObject); override;
    procedure DoUpdateOptionsFromChart; override;
  public
    property Title: TdxChartAxisTitle read GetTitle;
  end;

  { TAxisXNodeObject }

  TAxisXNodeObject = class(TAxisNodeObject)
  protected
    function DoGetCaption: string; override;
  end;

  { TAxisYNodeObject }

  TAxisYNodeObject = class(TAxisNodeObject)
  protected
    function DoGetCaption: string; override;
  end;

  { TAxisValueLabelsNodeObject }

  TAxisValueLabelsNodeObject = class(TNodeObject)
  strict private
    function GetActualVisible: Boolean;
    function GetValueLabels: TdxChartAxisValueLabels; inline;
    procedure SetActualVisible(const Value: Boolean);
  protected
    procedure CommandIconClick(AIndex: Integer); override;
    procedure ApplyChangedValueToChart(Sender: TObject); override;
    procedure DoToggleVisibility; override;
    procedure DoUpdateOptionsFromChart; override;
    procedure DoUpdateOptionStates; override;
    function DoGetCaption: string; override;
    function GetCommandIconHint(AIndex: Integer): string; override;
    function GetCommandIconCount: Integer; override;
    function GetCommandIconImageIndex(AIndex: Integer): Integer; override;
    function GetImageIndex: Integer; override;
    function GetOptionsGroup: TdxLayoutGroup; override;
    function IsAppearanceEnabled: Boolean; override;
    function IsEnabled: Boolean; override;
  public
    property ActualVisible: Boolean read GetActualVisible write SetActualVisible;
    property ValueLabels: TdxChartAxisValueLabels read GetValueLabels;
  end;

  { TAxisGridlinesNodeObject }

  TAxisGridlinesNodeObject = class(TNodeObject)
  strict private
    function GetActualVisible: Boolean;
    function GetGridlines: TdxChartAxisGridlines; inline;
    procedure SetActualVisible(const Value: Boolean);
  protected
    procedure CommandIconClick(AIndex: Integer); override;
    procedure ApplyChangedValueToChart(Sender: TObject); override;
    procedure DoUpdateAppearanceOptions(AAppearance: TdxChartCustomAppearanceAccess); override;
    procedure DoUpdateOptionsFromChart; override;
    procedure DoUpdateOptionStates; override;
    function DoGetCaption: string; override;
    function GetCommandIconHint(AIndex: Integer): string; override;
    function GetCommandIconCount: Integer; override;
    function GetCommandIconImageIndex(AIndex: Integer): Integer; override;
    function GetImageIndex: Integer; override;
    function GetOptionsGroup: TdxLayoutGroup; override;
    function IsAppearanceVisible: Boolean; override;
    function IsEnabled: Boolean; override;
    procedure DoToggleVisibility; override;
  public
    property ActualVisible: Boolean read GetActualVisible write SetActualVisible;
    property Gridlines: TdxChartAxisGridlines read GetGridlines;
  end;

procedure dxShowChartDesigner(AChartControl: TdxCustomChartControl);
var
  AForm: TfrmChartDesigner;
begin
  AForm := dxChartDesignerClass.Create(AChartControl);
  try
    if AForm.ShowModal = mrOk then
      AForm.ApplyChanges;
  finally
    AForm.Free;
  end;
end;

{ TdxChartVisualElementAppearanceHelper }

function TdxChartVisualElementAppearanceHelper.GetActualBorderValue: Boolean;
begin
  Result := GetActualBorder;
end;

function TdxChartVisualElementAppearanceHelper.GetPaintBorderColor: TdxAlphaColor;
begin
  Result:= GetColorValue(BorderColorIndex);
  if Result = TdxAlphaColors.Default then
    Result := GetActualColor(BorderColorIndex); 
end;

function TdxChartVisualElementAppearanceHelper.GetPaintBorderThickness: Single;
begin
  if ActualBorderValue then
    Result := ActualBorderThickness
  else 
    Result := BorderThickness;
end;

{ TcxSpinEditHelper }

function TcxSpinEditHelper.GetIsCustomText: Boolean;
begin
  Result := inherited IsCustomText;
end;

procedure TcxSpinEditHelper.SetIsCustomText(const AValue: Boolean);
begin
  inherited IsCustomText := AValue;
end;

procedure TcxSpinEditHelper.InitializeFormats;
begin
  if Properties.ValueType <> TcxSpinEditValueType.vtFloat then
    Exit;
  Properties.EditFormat := '0.#######';
  Properties.DisplayFormat := '0.#######';
end;

{ TcxCustomEditHelper }

procedure TcxCustomEditHelper.PostValue;
begin
  if not VarEquals(EditValue, EditingValue) and NeedUpdateChartValue then
    InternalPostValue;
end;

procedure TcxCustomEditHelper.InternalPostValue;
var
  AIsCustomText: Boolean;
  ASpinEdit: TcxSpinEdit;
begin
  ASpinEdit := Safe<TcxSpinEdit>.Cast(Self);
  if ASpinEdit <> nil then
  begin
    AIsCustomText := ASpinEdit.IsCustomText;
    ASpinEdit.IsCustomText := True;
  end
  else
    AIsCustomText := False;
  try
    PostEditValue;
  finally
    if ASpinEdit <> nil then
      ASpinEdit.IsCustomText := AIsCustomText;
  end;
end;

function TcxCustomEditHelper.NeedUpdateChartValue: Boolean;
begin
  Result := not ClassType.InheritsFrom(TcxSpinEdit) or not TcxSpinEdit(Self).IsCustomText;
end;



{ TdxChartAxisGridlinesHelper }

function TdxChartAxisGridlinesHelper.GetPaintColor: TdxAlphaColor;
begin
   Result := StrokeOptions.ActualColor;
end;

function TdxChartAxisGridlinesHelper.GetPaintMinorColor: TdxAlphaColor;
begin
   Result := MinorGridlineStrokeOptions.ActualColor;
end;

{ TNodeObject }

constructor TNodeObject.Create(ADesigner: TfrmChartDesigner; AObject: TPersistent);
begin
  inherited Create(AObject);
  FDesigner := ADesigner;
  FFreeNotificator := TcxFreeNotificator.Create(nil);
  FFreeNotificator.OnFreeNotification := FreeNotificatorHandler;
  if &Object is TComponent then
    TComponent(&Object).FreeNotification(FFreeNotificator);
end;

destructor TNodeObject.Destroy;
begin
  if &Object is TComponent then
    TComponent(&Object).RemoveFreeNotification(FFreeNotificator);
  FreeAndNil(FFreeNotificator);
  inherited Destroy;
end;

function TNodeObject.CanChangeIndex(ADelta: Integer): Boolean;
begin
  Result := False;
end;

procedure TNodeObject.ChangeIndex(ADelta: Integer);
begin
// do nothing
end;

procedure TNodeObject.CreateSubNodes;
begin
// do nothing
end;

procedure TNodeObject.FreeNotificatorHandler(Sender: TComponent);
begin
  Designer.PostPopulateTreeView;
end;

procedure TNodeObject.ApplyChangedValueToChart(Sender: TObject);
var
  AAppearance: TdxChartCustomAppearanceAccess;
begin
  AAppearance := GetAppearance;
  if AAppearance <> nil then
  begin
    if Sender = Designer.fncbAppearance then
      AAppearance.FontOptions.Name := Designer.fncbAppearance.EditValue;
    if Sender = Designer.seFontSize then
      AAppearance.FontOptions.Height := - MulDiv(Designer.CustomizedScaleFactor.Apply(Designer.seFontSize.EditValue),  dxDefaultDPI, 72);
    if Sender = Designer.lcbiFontBold then
      AAppearance.FontOptions.Bold := Designer.lcbiFontBold.Checked;
    if Sender = Designer.lcbiFontItalic then
      AAppearance.FontOptions.Italic := Designer.lcbiFontItalic.Checked;
    if Sender = Designer.lcbiFontUnderline then
      AAppearance.FontOptions.Underline := Designer.lcbiFontUnderline.Checked;
    if Sender = Designer.lcbiFontStrikeout then
      AAppearance.FontOptions.StrikeOut := Designer.lcbiFontStrikeout.Checked;
    if Sender = Designer.ceFontColor then
      AAppearance.TextColor := TdxAlphaColors.FromColor(Designer.ceFontColor.ColorValue);

    if Sender = Designer.seMarginAll then
      AAppearance.Padding.All := Designer.CustomizedScaleFactor.Apply(Designer.seMarginAll.Value);
    if Sender = Designer.seMarginTop then
      AAppearance.Padding.Top := Designer.CustomizedScaleFactor.Apply(Designer.seMarginTop.Value);
    if Sender = Designer.seMarginLeft then
      AAppearance.Padding.Left := Designer.CustomizedScaleFactor.Apply(Designer.seMarginLeft.Value);
    if Sender = Designer.seMarginRight then
      AAppearance.Padding.Right := Designer.CustomizedScaleFactor.Apply(Designer.seMarginRight.Value);
    if Sender = Designer.seMarginBottom then
      AAppearance.Padding.Bottom := Designer.CustomizedScaleFactor.Apply(Designer.seMarginBottom.Value);

    if Sender = Designer.sePaddingAll then
      AAppearance.Margins.All := Designer.CustomizedScaleFactor.Apply(Designer.sePaddingAll.Value);
    if Sender = Designer.sePaddingTop then
      AAppearance.Margins.Top := Designer.CustomizedScaleFactor.Apply(Designer.sePaddingTop.Value);
    if Sender = Designer.sePaddingLeft then
      AAppearance.Margins.Left := Designer.CustomizedScaleFactor.Apply(Designer.sePaddingLeft.Value);
    if Sender = Designer.sePaddingRight then
      AAppearance.Margins.Right := Designer.CustomizedScaleFactor.Apply(Designer.sePaddingRight.Value);
    if Sender = Designer.sePaddingBottom then
      AAppearance.Margins.Bottom := Designer.CustomizedScaleFactor.Apply(Designer.sePaddingBottom.Value);

    if Sender = Designer.lcbiBorder then
      AAppearance.Border := FCheckBoxStateToDefaultBoolean[Designer.lcbiBorder.State];
    if Sender = Designer.seBorderWidth then
      AAppearance.BorderThickness := Designer.seBorderWidth.Value;
    if Sender = Designer.ceBorderColor then
      AAppearance.BorderColor := TdxAlphaColors.FromColor(Designer.ceBorderColor.ColorValue);

    if Sender = Designer.lcbiParentBackground then
    begin
      if IsPublishedProp(AAppearance, 'ParentBackground') then
        AAppearance.ParentBackground := not Designer.lcbiParentBackground.Checked
      else 
        if Designer.lcbiParentBackground.Checked then
          AAppearance.FillOptions.Color := AAppearance.FillOptions.ActualColor
        else
        begin    
          AAppearance.FillOptions.BeginUpdate;
          try      
            AAppearance.FillOptions.Color := TdxAlphaColors.Default;
            AAppearance.FillOptions.Color2 := TdxAlphaColors.Default;
            AAppearance.FillOptions.GradientMode := TdxFillOptionsGradientMode.Horizontal;
            AAppearance.FillOptions.HatchStyle := TdxFillOptionsHatchStyle.Horizontal;
            AAppearance.FillOptions.Texture := nil;
            AAppearance.FillOptions.Mode := TdxFillOptionsMode.Solid;    
          finally
            AAppearance.FillOptions.EndUpdate;
          end;
        end;
    end;
      
    if Sender = Designer.ceBackgroundColor then
    begin
      AAppearance.FillOptions.Color := TdxAlphaColors.FromColor(Designer.ceBackgroundColor.ColorValue);
      Designer.InitializeHatchStyles(Designer.icbBackgroundHatchStyle, AAppearance.FillOptions.ActualColor, AAppearance.FillOptions.ActualColor2);
    end;
    if Sender = Designer.ceBackgroundGradientEndColor then
      AAppearance.FillOptions.Color2 := TdxAlphaColors.FromColor(Designer.ceBackgroundGradientEndColor.ColorValue);
    if Sender = Designer.ceBackgroundGradientBeginColor then
      AAppearance.FillOptions.Color := TdxAlphaColors.FromColor(Designer.ceBackgroundGradientBeginColor.ColorValue);
    if Sender = Designer.ceBackgroundPatternColor then
    begin
      AAppearance.FillOptions.Color2 := TdxAlphaColors.FromColor(Designer.ceBackgroundPatternColor.ColorValue);
      Designer.InitializeHatchStyles(Designer.icbBackgroundHatchStyle, AAppearance.FillOptions.ActualColor, AAppearance.FillOptions.ActualColor2);
    end;
    if Sender = Designer.cbBackgroundMode then
      AAppearance.FillOptions.Mode := TdxFillOptionsMode(Designer.cbBackgroundMode.ItemIndex);
    if Sender = Designer.cbBackgroundGradientMode then
      AAppearance.FillOptions.GradientMode := TdxFillOptionsGradientMode(Designer.cbBackgroundGradientMode.ItemIndex);
    if Sender = Designer.icbBackgroundHatchStyle then
      AAppearance.FillOptions.HatchStyle := TdxFillOptionsHatchStyle(Designer.icbBackgroundHatchStyle.ItemIndex);
    if Sender = Designer.iBackgroundTexture then
      if Designer.iBackgroundTexture.Picture = nil then
        AAppearance.FillOptions.Texture.Assign(nil)
      else
        AAppearance.FillOptions.Texture.Assign(Designer.iBackgroundTexture.Picture.Graphic);

    if Sender = Designer.ceAppearanceStrokeColor then
      AAppearance.StrokeOptions.Color := TdxAlphaColors.FromColor(Designer.ceAppearanceStrokeColor.ColorValue);
    if Sender = Designer.cbAppearanceStrokeStyle then
      AAppearance.StrokeOptions.Style := TdxStrokeStyle(Designer.cbAppearanceStrokeStyle.ItemIndex);
    if Sender = Designer.seAppearanceStrokeThickness then
      AAppearance.StrokeOptions.Width := Designer.CustomizedScaleFactor.ApplyF(Designer.seAppearanceStrokeThickness.EditValue);
  end;
  DoUpdateOptionStates;
  InvalidateNode;
end;

function TNodeObject.DoGetCaption: string;
begin
  Result := '';
end;

procedure TNodeObject.DoUpdateAppearanceOptions(AAppearance: TdxChartCustomAppearanceAccess);
begin
  Designer.lgAppearanceFont.Visible := (AAppearance <> nil) and IsPublishedProp(AAppearance, 'FontOptions') and (AAppearance.FontOptions <> nil);
  if Designer.lgAppearanceFont.Visible then
  begin
    Designer.lcbiFont.Visible := False;
    Designer.lcbiFont.Checked := True;
    Designer.fncbAppearance.EditValue := AAppearance.FontOptions.Name;
    Designer.seFontSize.EditValue := Abs(MulDiv(Designer.CustomizedScaleFactor.Revert(AAppearance.FontOptions.Height),  72, dxDefaultDPI));
    Designer.lcbiFontBold.Checked := AAppearance.FontOptions.Bold;
    Designer.lcbiFontItalic.Checked := AAppearance.FontOptions.Italic;
    Designer.lcbiFontStrikeout.Checked := AAppearance.FontOptions.StrikeOut;
    Designer.lcbiFontUnderline.Checked := AAppearance.FontOptions.Underline;
    Designer.ceFontColor.ColorValue := TdxAlphaColors.ToColor(AAppearance.ActualTextColor);
  end;

  Designer.lgAppearanceMargins.Visible := (AAppearance <> nil) and IsPublishedProp(AAppearance, 'Padding');
  if Designer.lgAppearanceMargins.Visible then
  begin
    if AAppearance.Padding.All < 0 then
      Designer.seMarginAll.EditValue := Null
    else
      Designer.seMarginAll.Value := Designer.CustomizedScaleFactor.Revert(AAppearance.Padding.All);
    Designer.seMarginTop.Value := Designer.CustomizedScaleFactor.Revert(AAppearance.Padding.Top);
    Designer.seMarginLeft.Value := Designer.CustomizedScaleFactor.Revert(AAppearance.Padding.Left);
    Designer.seMarginRight.Value := Designer.CustomizedScaleFactor.Revert(AAppearance.Padding.Right);
    Designer.seMarginBottom.Value := Designer.CustomizedScaleFactor.Revert(AAppearance.Padding.Bottom);
  end;

  Designer.lgAppearancePadding.Visible := (AAppearance <> nil) and IsPublishedProp(AAppearance, 'Margins');
  if Designer.lgAppearancePadding.Visible then
  begin
    if AAppearance.Margins.All < 0 then
      Designer.sePaddingAll.EditValue := Null
    else
      Designer.sePaddingAll.Value := Designer.CustomizedScaleFactor.Revert(AAppearance.Margins.All);
    Designer.sePaddingTop.Value := Designer.CustomizedScaleFactor.Revert(AAppearance.Margins.Top);
    Designer.sePaddingLeft.Value := Designer.CustomizedScaleFactor.Revert(AAppearance.Margins.Left);
    Designer.sePaddingRight.Value := Designer.CustomizedScaleFactor.Revert(AAppearance.Margins.Right);
    Designer.sePaddingBottom.Value := Designer.CustomizedScaleFactor.Revert(AAppearance.Margins.Bottom);
  end;

  Designer.lgAppearanceBorder.Visible := (AAppearance <> nil) and IsPublishedProp(AAppearance, 'Border');
  if Designer.lgAppearanceBorder.Visible then
  begin     
    Designer.lcbiBorder.State := FDefaultBooleanToCheckBoxState[AAppearance.Border];
    Designer.liBorderWidth.Visible := IsPublishedProp(AAppearance, 'BorderThickness');
    Designer.seBorderWidth.Value := AAppearance.PaintBorderThickness;
    Designer.ceBorderColor.ColorValue := TdxAlphaColors.ToColor(AAppearance.PaintBorderColor);
  end;

  Designer.lgAppearanceBackground.Visible := (AAppearance <> nil) and IsPublishedProp(AAppearance, 'FillOptions') and (AAppearance.FillOptions <> nil);
  if Designer.lgAppearanceBackground.Visible then
  begin
    Designer.ceBackgroundColor.ColorValue := TdxAlphaColors.ToColor(AAppearance.FillOptions.ActualColor);
    Designer.ceBackgroundGradientBeginColor.ColorValue := TdxAlphaColors.ToColor(AAppearance.FillOptions.ActualColor);
    Designer.ceBackgroundGradientEndColor.ColorValue := TdxAlphaColors.ToColor(AAppearance.FillOptions.ActualColor2);
    Designer.ceBackgroundPatternColor.ColorValue := TdxAlphaColors.ToColor(AAppearance.FillOptions.ActualColor2);
    Designer.cbBackgroundMode.ItemIndex := Ord(AAppearance.FillOptions.Mode);
    Designer.cbBackgroundGradientMode.ItemIndex := Ord(AAppearance.FillOptions.GradientMode);
    Designer.icbBackgroundHatchStyle.ItemIndex := Ord(AAppearance.FillOptions.HatchStyle);
    Designer.iBackgroundTexture.Picture.Assign(AAppearance.FillOptions.Texture);
    if not Designer.icbBackgroundHatchStyle.DroppedDown then
      Designer.InitializeHatchStyles(Designer.icbBackgroundHatchStyle, AAppearance.FillOptions.ActualColor, AAppearance.FillOptions.ActualColor2);

    if IsPublishedProp(AAppearance, 'ParentBackground') then
      Designer.lcbiParentBackground.Checked := not AAppearance.ParentBackground
    else 
    begin
        Designer.lcbiParentBackground.Checked := AAppearance.FillOptions.Color  <> TdxAlphaColors.Default;     
        if not Designer.lcbiParentBackground.Checked then
          Designer.cbBackgroundMode.ItemIndex := Ord(TdxFillOptionsMode.Solid); 
    end;
  end;

  Designer.lgAppearanceStroke.Visible := (AAppearance <> nil) and IsPublishedProp(AAppearance, 'StrokeOptions') and (AAppearance.StrokeOptions <> nil);
  if Designer.lgAppearanceStroke.Visible then
  begin
    Designer.ceAppearanceStrokeColor.ColorValue := TdxAlphaColors.ToColor(AAppearance.StrokeOptions.ActualColor);
    Designer.cbAppearanceStrokeStyle.ItemIndex := Ord(AAppearance.StrokeOptions.Style);
    Designer.seAppearanceStrokeThickness.EditValue := Designer.CustomizedScaleFactor.RevertF(AAppearance.StrokeOptions.Width);
  end;
end;

procedure TNodeObject.DoUpdateOptionsFromChart;
var
  I: Integer;
  AAppearance: TdxChartCustomAppearanceAccess;
  AVisible: Boolean;
begin
  AAppearance := GetAppearance;
  Designer.lgAppearance.Visible := IsAppearanceVisible;
  AVisible := Designer.lgOptions.Visible;
  Designer.lgOptions.Visible := GetOptionsGroup <> nil;
  if not AVisible and Designer.lgOptions.Visible then
    Designer.lgOptions.Parent.ItemIndex := Designer.lgOptions.Index;
  if Designer.lgAppearance.Visible then
  begin
    for I := 0 to Designer.lgAppearance.Count - 1 do
      Designer.lgAppearance[I].Visible := Designer.lgAppearance[I].Tag >= 0;
    DoUpdateAppearanceOptions(AAppearance);
    AVisible := False;
    for I := 0 to Designer.lgAppearance.Count - 1 do
      if Designer.lgAppearance.Items[I].Visible then
      begin
        AVisible := True;
        Break;
      end;
    Designer.lgAppearance.Visible := AVisible;
  end;
  DoUpdateOptionStates;
end;

procedure TNodeObject.DoUpdateOptionStates;

  procedure SetGroupBottomOffset(AGroup: TdxLayoutGroup);
  var
    I: Integer;
    ABottomOffset: Integer;
  begin
    if AGroup <> nil then
    begin
      ABottomOffset := Designer.ScaleFactor.Apply(12);
      TdxLayoutGroupAccess(AGroup).BuildVisibleItemsList;
      for I := 0 to AGroup.VisibleCount - 2 do
        AGroup.VisibleItems[I].Offsets.Bottom := ABottomOffset;
    end;
  end;

var
  AEnabled: Boolean;
  I: Integer;
  AAppearance: TdxChartCustomAppearanceAccess;
begin
  if Designer.lgAppearance.Visible then
  begin
    for I := 0 to Designer.lgAppearance.Count - 1 do
      Designer.lgAppearance[I].Enabled := IsAppearanceEnabled;
 
    AAppearance := GetAppearance;
    AEnabled := (AAppearance <> nil) and AAppearance.ActualBorderValue and IsAppearanceEnabled;
    Designer.liBorderWidth.Enabled := AEnabled;
    Designer.liBorderColor.Enabled := AEnabled;

    AEnabled := IsAppearanceEnabled and Designer.lcbiFont.Checked;
    Designer.liFontName.Enabled := AEnabled;
    Designer.liFontSize.Enabled := AEnabled;
    Designer.liFontColor.Enabled := AEnabled;
    Designer.lgFontStyle.Enabled := AEnabled;

    AEnabled := IsAppearanceEnabled and (Designer.lcbiParentBackground.State <> cbsUnchecked);
    Designer.liBackgroundMode.Enabled := AEnabled;
    Designer.liBackgroundColor.Enabled := AEnabled;
    Designer.liBackgroundGradientBeginColor.Enabled := AEnabled;
    Designer.liBackgroundGradientEndColor.Enabled := AEnabled;
    Designer.liBackgroundGradientMode.Enabled := AEnabled;
    Designer.liBackgroundHatchStyle.Enabled := AEnabled;
    Designer.liBackgroundTexture.Enabled := AEnabled; 
    
    if Designer.lgAppearanceBackground.Visible and (AAppearance <> nil) then
    begin
      Designer.liBackgroundColor.Visible := AAppearance.FillOptions.Mode in [TdxFillOptionsMode.Solid, TdxFillOptionsMode.Hatch];
      Designer.liBackgroundGradientBeginColor.Visible := AAppearance.FillOptions.Mode = TdxFillOptionsMode.Gradient;
      Designer.liBackgroundGradientEndColor.Visible := AAppearance.FillOptions.Mode = TdxFillOptionsMode.Gradient;
      Designer.liBackgroundPatternColor.Visible := AAppearance.FillOptions.Mode = TdxFillOptionsMode.Hatch;
      Designer.liBackgroundGradientMode.Visible := AAppearance.FillOptions.Mode = TdxFillOptionsMode.Gradient;
      Designer.liBackgroundHatchStyle.Visible := AAppearance.FillOptions.Mode = TdxFillOptionsMode.Hatch;
      Designer.liBackgroundTexture.Visible := AAppearance.FillOptions.Mode = TdxFillOptionsMode.Texture;
    end;
  end;
  SetGroupBottomOffset(GetOptionsGroup);
  SetGroupBottomOffset(Designer.lgAppearance);
end;

function TNodeObject.GetAppearance: TdxChartCustomAppearanceAccess;
var
  AIntf: IdxChartVisualElement;
begin
  if Supports(&Object, IdxChartVisualElement, AIntf) then
    Result := TdxChartCustomAppearanceAccess(AIntf.GetAppearance)
  else
    Result := nil;
end;

function TNodeObject.GetCaption: string;
begin
  if Designer.IsDesigning and (&Object is TComponent) then
    Result := TComponent(&Object).Name
  else
    Result := DoGetCaption;
end;

function TNodeObject.GetImageIndex: Integer;
begin
  Result := -1;
end;

function TNodeObject.GetNode: TdxTreeViewNode;
begin
  Result := Designer.GetNodeByData(Self);
end;

function TNodeObject.GetNodeDisplayRect: TRect;
begin
  Result := Node.DisplayRect(False);
end;

function TNodeObject.GetOptionsGroup: TdxLayoutGroup;
begin
  Result := nil;
end;

procedure TNodeObject.Popup(APopupMenu: TPopupMenu;
  const ACommandIconIndex: Integer);
var
  P: TPoint;
  R: TRect;
  AHitTest: TdxChartDesignerTreeViewHitTest;
begin
  AHitTest := Designer.TreeView.HitTest;
  R := AHitTest.HitCommandIconBounds;
  if Designer.UseRightToLeftAlignment then
    P := R.BottomRight
  else
    P := TPoint.Create(R.Left, R.Bottom);
  Popup(APopupMenu, P);
end;

procedure TNodeObject.DoToggleVisibility;
begin
// do nothing
end;

procedure TNodeObject.ToggleVisibility;
begin
  Designer.BeginUpdate;
  Designer.lcMain.BeginUpdate;
  try
    DoToggleVisibility;
    DoUpdateOptionsFromChart;
    InvalidateNode;
    Designer.Modified;
  finally
    Designer.lcMain.EndUpdate;
    Designer.EndUpdate;
  end;
end;

procedure TNodeObject.Popup(APopupMenu: TPopupMenu; const P: TPoint);
begin
  Designer.PopupTreeViewMenu(APopupMenu, P);
end;

procedure TNodeObject.InvalidateNode;
begin
  Node.Enabled := IsEnabled;
  Node.Invalidate;
end;

function TNodeObject.IsAppearanceEnabled: Boolean;
begin
  Result := True;
end;

function TNodeObject.IsAppearanceVisible: Boolean;
begin
  Result := GetAppearance <> nil;
end;

function TNodeObject.IsEnabled: Boolean;
begin
  Result := True;
end;

{ TChartControlNodeObject }

procedure TChartControlNodeObject.ApplyChangedValueToChart(Sender: TObject);
begin
  if Sender = Designer.lcbiFont then
  begin
    if IsPublishedProp(Designer.CustomizedChartControl, 'ParentFont') then
      TdxCustomChartControlAccess(ChartControl).ParentFont := not Designer.lcbiFont.Checked;
  end;
  inherited ApplyChangedValueToChart(Sender);
end;

procedure TChartControlNodeObject.CommandIconClick(AIndex: Integer);
begin
  Popup(Designer.pmChart, AIndex);
end;

function TChartControlNodeObject.DoGetCaption: string;
begin
  Result := cxGetResourceString(@sdxChartDesignerChartCaption);
end;

procedure TChartControlNodeObject.DoUpdateAppearanceOptions(
  AAppearance: TdxChartCustomAppearanceAccess);
begin
  inherited DoUpdateAppearanceOptions(AAppearance);
  Designer.lcbiFont.Visible := IsPublishedProp(Designer.CustomizedChartControl, 'ParentFont');
  if not Designer.lcbiFont.Visible then
    Designer.lcbiFont.Checked := True
  else
    Designer.lcbiFont.Checked := not TdxCustomChartControlAccess(ChartControl).ParentFont;
end;

procedure TChartControlNodeObject.DoUpdateOptionsFromChart;
begin
  inherited DoUpdateOptionsFromChart;
end;

procedure TChartControlNodeObject.CreateSubNodes;

  procedure AddDiagramNode(ADiagram: TdxChartCustomDiagram);
  var
    ADiagramNodeObjectClass: TClass;
  begin
    if ADiagram.InheritsFrom(TdxChartXYDiagram) then
      ADiagramNodeObjectClass := TXYDiagramNodeObject
    else
      ADiagramNodeObjectClass := TSimpleDiagramNodeObject;
    Designer.CreateNode(Node, ADiagram, ADiagramNodeObjectClass);
  end;

var
  I: Integer;
begin
  inherited CreateSubNodes;
  Designer.CreateNode(Node, ChartControl.Titles, TChartTitlesNodeObject);
  Designer.CreateNode(Node, ChartControl.Legend, TLegendNodeObject);
  for I := 0 to ChartControl.DiagramCount - 1 do
    AddDiagramNode(ChartControl.Diagrams[I]);
end;

function TChartControlNodeObject.GetCommandIconHint(AIndex: Integer): string;
begin
  Result := cxGetResourceString(@sdxChartDesignerAddDiagramHint);
end;

function TChartControlNodeObject.GetCommandIconImageIndex(
  AIndex: Integer): Integer;
begin
  Result := AddDiagramCommandIconIndex;
end;

function TChartControlNodeObject.GetAppearance: TdxChartCustomAppearanceAccess;
begin
  Result := TdxChartCustomAppearanceAccess(ChartControl.Appearance);
end;

function TChartControlNodeObject.GetChartControl: TdxCustomChartControl;
begin
  Result := TdxCustomChartControl(inherited &Object);
end;

function TChartControlNodeObject.GetCommandIconCount: Integer;
begin
  Result := 1;
  if not Designer.CanAddDiagram then
    Dec(Result);
end;

function TChartControlNodeObject.GetImageIndex: Integer;
begin
  Result := 0;
end;

function TChartControlNodeObject.GetOptionsGroup: TdxLayoutGroup;
begin
  Result := nil;
end;

function TChartControlNodeObject.IsEnabled: Boolean;
begin
  Result := True;
end;

{ TChartTitlesNodeObject }

procedure TChartTitlesNodeObject.CommandIconClick(AIndex: Integer);
begin
  case AIndex of
    0: Designer.AddChartTitle;
    1: ToggleVisibility;
  else
    inherited CommandIconClick(AIndex);
  end;
end;

procedure TChartTitlesNodeObject.CreateSubNodes;
var
  I: Integer;
begin
  inherited CreateSubNodes;
  for I := 0 to Titles.Count - 1 do
    Designer.CreateNode(Node, Titles[I], TChartTitleNodeObject);
end;

procedure TChartTitlesNodeObject.ApplyChangedValueToChart(Sender: TObject);
begin
  if Sender = Designer.lcbiTitlesVisible then
    Titles.Visible := Designer.lcbiTitlesVisible.Checked;
  inherited ApplyChangedValueToChart(Sender);
end;

function TChartTitlesNodeObject.DoGetCaption: string;
begin
  Result := cxGetResourceString(@sdxChartDesignerTitlesCaption);
end;

procedure TChartTitlesNodeObject.DoToggleVisibility;
begin
  ActualVisible := not ActualVisible;
end;

procedure TChartTitlesNodeObject.DoUpdateOptionsFromChart;
begin
  inherited DoUpdateOptionsFromChart;
  Designer.lgOptionsGeneral.Parent := Designer.lgTitlesGeneral;
  Designer.lgOptionsGeneral.Index := 0;

  Designer.lcbiTitlesVisible.Checked := Titles.Visible;
end;

function TChartTitlesNodeObject.GetActualVisible: Boolean;
begin
  Result := Titles.Visible;
end;

function TChartTitlesNodeObject.GetCommandIconHint(AIndex: Integer): string;
begin
  if AIndex = 0 then
    Result := cxGetResourceString(@sdxChartDesignerAddTitleHint)
  else
    Result := cxGetResourceString(@sdxChartDesignerChangeVisibilityHint);
end;

function TChartTitlesNodeObject.GetCommandIconImageIndex(AIndex: Integer): Integer;
begin
  case AIndex of
    0: Result := AddCommandIconIndex;
    1: Result := VisibilityCommandIconIndex[ActualVisible];
  else
    Result := inherited GetCommandIconImageIndex(AIndex);
  end;
end;

function TChartTitlesNodeObject.GetCommandIconCount: Integer;
begin
  Result := 2;
end;

function TChartTitlesNodeObject.GetImageIndex: Integer;
begin
  Result := 2;
end;

function TChartTitlesNodeObject.GetOptionsGroup: TdxLayoutGroup;
begin
  Result := Designer.lgTitles;
end;

function TChartTitlesNodeObject.GetTitles: TdxChartTitles;
begin
  Result := TdxChartTitles(&Object);
end;

function TChartTitlesNodeObject.IsEnabled: Boolean;
begin
  Result := ActualVisible;
end;

procedure TChartTitlesNodeObject.SetActualVisible(const Value: Boolean);
begin
  if ActualVisible <> Value then
    Titles.Visible := Value;
end;

{ TChartTitleNodeObject }

function TChartTitleNodeObject.CanChangeIndex(ADelta: Integer): Boolean;
var
  ANewIndex: Integer;
begin
  ANewIndex := Title.Index + ADelta;
  Result := (ANewIndex >= 0) and (ANewIndex <= Title.Collection.Count - 1);
end;

function TChartTitleNodeObject.CanDrag: Boolean;
begin
  Result := True;
end;

function TChartTitleNodeObject.CanDrop(const P: TPoint; AHitNodeObject: TdxChartDesignerTreeViewNodeData; var AAfter: Boolean): Boolean;
var
  AHitTitleNodeObject: TChartTitleNodeObject;
  ANewIndex: Integer;
  R: TRect;
begin
  Result := AHitNodeObject is TChartTitleNodeObject;
  if Result then
  begin
    AHitTitleNodeObject := TChartTitleNodeObject(AHitNodeObject);
    R := AHitTitleNodeObject.GetNodeDisplayRect;
    AAfter := (R.Top + R.Bottom) div 2 <= P.Y;
    ANewIndex := AHitTitleNodeObject.Title.Index;
    if ANewIndex < Title.Index then
      Inc(ANewIndex);
    if not AAfter then
      Dec(ANewIndex);
    Result := ANewIndex <> Title.Index;
  end;
end;

procedure TChartTitleNodeObject.Drop(const P: TPoint; AHitNodeObject: TdxChartDesignerTreeViewNodeData);
var
  AAfter: Boolean;
  AIndex: Integer;
  AHitTitleNodeObject: TChartTitleNodeObject;
begin
  if not CanDrop(P, AHitNodeObject, AAfter) then
    Exit;
  if AHitNodeObject is TChartTitleNodeObject then
  begin
    AHitTitleNodeObject := TChartTitleNodeObject(AHitNodeObject);
    AIndex := AHitTitleNodeObject.Title.Index;
    if AAfter then
      Inc(AIndex);
    if AIndex > Title.Index then
      Dec(AIndex);
    Title.Index := AIndex;
  end;
end;

procedure TChartTitleNodeObject.ChangeIndex(ADelta: Integer);
begin
  Title.Index := Title.Index + ADelta;
end;

procedure TChartTitleNodeObject.CommandIconClick(AIndex: Integer);
begin
  case AIndex of
    0: ToggleVisibility;
    1: Designer.Delete(Title);
  else
    inherited CommandIconClick(AIndex);
  end;
end;

procedure TChartTitleNodeObject.ApplyChangedValueToChart(Sender: TObject);
begin
  if Sender = Designer.teTitleText then
  begin
    Title.Text := Designer.teTitleText.Text;
    Node.Caption := DoGetCaption;
  end;
  if Sender = Designer.cbTitleVisibility then
    Title.Visible := Designer.cbTitleVisibility.Checked;
  if Sender = Designer.cbTitleWordWrap then
    Title.WordWrap := Designer.cbTitleWordWrap.EditValue;
  if Sender = Designer.cbTitleDock then
    Title.Position := TdxChartTitlePosition(Designer.cbTitleDock.ItemIndex);
  if Sender = Designer.seTitleMaxLineCount then
    Title.MaxLineCount := Designer.seTitleMaxLineCount.EditValue;
  if Sender = Designer.cbTitleAlignment then
    Title.Alignment := TdxAlignment(Designer.cbTitleAlignment.ItemIndex);
  inherited ApplyChangedValueToChart(Sender);
end;

function TChartTitleNodeObject.DoGetCaption: string;
begin
  Result := Title.Text;
  if Trim(Result) = '' then
    Result := cxGetResourceString(@sdxChartDesignerTitleCaption);
end;

procedure TChartTitleNodeObject.DoToggleVisibility;
begin
  ActualVisible := not ActualVisible;
end;

procedure TChartTitleNodeObject.DoUpdateOptionsFromChart;
begin
  inherited DoUpdateOptionsFromChart;
  Designer.lgOptionsGeneral.Parent := Designer.lgTitleGeneral;
  Designer.lgOptionsGeneral.Index := 0;
  Designer.liTitleDock.Visible := IsPublishedProp(Title, 'Position');
  Designer.liTitleMaxLineCount.Visible := IsPublishedProp(Title, 'MaxLineCount');

  Designer.teTitleText.Text := Title.Text;
  Designer.cbTitleVisibility.Checked := Title.Visible;
  Designer.cbTitleWordWrap.EditValue := Title.WordWrap;
  Designer.cbTitleDock.ItemIndex := Ord(Title.Position);
  Designer.seTitleMaxLineCount.EditValue := Title.MaxLineCount;
  Designer.cbTitleAlignment.ItemIndex := Ord(Title.Alignment);
  Designer.liTitleAxisPosition.Visible := False;
end;

procedure TChartTitleNodeObject.DoUpdateOptionStates;
begin
  inherited DoUpdateOptionStates;
  Designer.liTitleWordWrap.Enabled := ActualVisible;
  Designer.liTitleDock.Enabled := ActualVisible;
  Designer.liTitleMaxLineCount.Enabled := ActualVisible;
  Designer.liTitleAlignment.Enabled := ActualVisible;
end;

function TChartTitleNodeObject.GetActualVisible: Boolean;
begin
  Result := TdxChartTitleAccess(TdxChartTitleCollectionItemAccess(Title).Title).ActuallyVisible;
end;

function TChartTitleNodeObject.GetAppearance: TdxChartCustomAppearanceAccess;
begin
  Result := TdxChartCustomAppearanceAccess(Title.Appearance);
end;

function TChartTitleNodeObject.GetCommandIconHint(AIndex: Integer): string;
begin
  if AIndex = 0 then
    Result := cxGetResourceString(@sdxChartDesignerChangeVisibilityHint)
  else
    Result := cxGetResourceString(@sdxChartDesignerDeleteHint);
end;

function TChartTitleNodeObject.GetCommandIconImageIndex(
  AIndex: Integer): Integer;
begin
  case AIndex of
    0: Result := VisibilityCommandIconIndex[ActualVisible];
    1: Result := RemoveCommandIconIndex;
  else
    Result := inherited GetCommandIconImageIndex(AIndex);
  end;
end;

function TChartTitleNodeObject.GetCommandIconCount: Integer;
begin
  Result := 2;
end;

function TChartTitleNodeObject.GetImageIndex: Integer;
begin
  Result := -1;
end;

function TChartTitleNodeObject.GetOptionsGroup: TdxLayoutGroup;
begin
  Result := Designer.lgTitle;
end;

function TChartTitleNodeObject.GetTitle: TdxChartTitleCollectionItem;
begin
  Result := TdxChartTitleCollectionItem(&Object);
end;

function TChartTitleNodeObject.IsAppearanceEnabled: Boolean;
begin
  Result := ActualVisible;
end;

function TChartTitleNodeObject.IsEnabled: Boolean;
begin
  Result := ActualVisible;
end;

procedure TChartTitleNodeObject.SetActualVisible(const Value: Boolean);
begin
  if ActualVisible <> Value then
    Title.Visible := Value;
end;

{ TLegendNodeObject }

procedure TLegendNodeObject.CommandIconClick(AIndex: Integer);
begin
  ToggleVisibility;
end;

procedure TLegendNodeObject.CreateSubNodes;
begin
  inherited CreateSubNodes;;
  Designer.CreateNode(Node, Legend.Title, TTitleNodeObject);
end;

procedure TLegendNodeObject.ApplyChangedValueToChart(Sender: TObject);
begin
  if Sender = Designer.cbLegendAlignmentHorizontal then
    Legend.AlignmentHorz := TdxChartLegendAlignment(Designer.cbLegendAlignmentHorizontal.ItemIndex);
  if Sender = Designer.cbLegendAlignmentVertical then
    Legend.AlignmentVert := TdxChartLegendAlignment(Designer.cbLegendAlignmentVertical.ItemIndex);
  if Sender = Designer.seLegendMaxCaptionWidth then
    Legend.MaxCaptionWidth := Designer.CustomizedScaleFactor.Apply(Designer.seLegendMaxCaptionWidth.Value);
  if Sender = Designer.lcbiLegendVisible then
    Legend.Visible := Designer.lcbiLegendVisible.Checked;
  if Sender = Designer.lcbiLegendCaptions then
    Legend.ShowCaptions := Designer.lcbiLegendCaptions.Checked;
  if Sender = Designer.lcbiLegendButtons then
    Legend.ShowCheckBoxes := Designer.lcbiLegendButtons.Checked;
  if Sender = Designer.lcbiLegendImages then
    Legend.ShowImages := Designer.lcbiLegendImages.Checked;
  if Sender = Designer.cbLegendDirection then
    Legend.Direction := TdxChartLegendDirection(Designer.cbLegendDirection.ItemIndex);
  inherited ApplyChangedValueToChart(Sender);
end;

function TLegendNodeObject.DoGetCaption: string;
begin
  Result := cxGetResourceString(@sdxChartDesignerLegendCaption);
end;

procedure TLegendNodeObject.DoToggleVisibility;
begin
  ActualVisible := not ActualVisible;
end;

procedure TLegendNodeObject.DoUpdateOptionsFromChart;
begin
  Designer.lgOptionsLayout.Parent := Designer.lgLegendLayout;
  Designer.lgOptionsLayout.Index := 0;
  Designer.lgOptionsGeneral.Parent := Designer.lgLegendGeneral;
  Designer.lgOptionsGeneral.Index := 0;

  Designer.lcbiLegendVisible.Checked := Legend.Visible;
  Designer.lcbiLegendCaptions.Checked := Legend.ShowCaptions;
  Designer.lcbiLegendButtons.Checked := Legend.ShowCheckBoxes;
  Designer.lcbiLegendImages.Checked := Legend.ShowImages;
  Designer.seLegendMaxCaptionWidth.Value := Designer.CustomizedScaleFactor.RevertF(Legend.MaxCaptionWidth);
  Designer.cbLegendAlignmentHorizontal.ItemIndex := Ord(Legend.AlignmentHorz);
  Designer.cbLegendAlignmentVertical.ItemIndex := Ord(Legend.AlignmentVert);
  Designer.cbLegendDirection.ItemIndex := Ord(Legend.Direction);

  inherited DoUpdateOptionsFromChart;
end;

procedure TLegendNodeObject.DoUpdateOptionStates;
var
  AEnabled: Boolean;
begin
  inherited DoUpdateOptionStates;
  AEnabled := ActualVisible;
  Designer.lcbiLegendCaptions.Enabled := AEnabled;
  Designer.lcbiLegendButtons.Enabled := AEnabled;
  Designer.lcbiLegendImages.Enabled := AEnabled;
  Designer.liLegendAlignmentHorizontal.Enabled := AEnabled;
  Designer.liLegendAlignmentVertical.Enabled := AEnabled;
  Designer.liLegendDirection.Enabled := AEnabled;
  Designer.liLegendMaxCaptionWidth.Enabled := AEnabled and (Designer.lcbiLegendCaptions.State <> cbsUnchecked);
end;

function TLegendNodeObject.GetActualVisible: Boolean;
begin
  Result := TdxChartCustomLegendAccess(Legend).ActuallyVisible;
end;

function TLegendNodeObject.GetCommandIconHint(AIndex: Integer): string;
begin
  Result := cxGetResourceString(@sdxChartDesignerChangeVisibilityHint);
end;

function TLegendNodeObject.GetCommandIconImageIndex(AIndex: Integer): Integer;
begin
  Result := VisibilityCommandIconIndex[ActualVisible];
end;

function TLegendNodeObject.GetCommandIconCount: Integer;
begin
  Result := 1;
end;

function TLegendNodeObject.GetImageIndex: Integer;
begin
  Result := 3;
end;

function TLegendNodeObject.GetLegend: TdxChartCustomLegend;
begin
  Result := TdxChartCustomLegend(&Object);
end;

function TLegendNodeObject.GetOptionsGroup: TdxLayoutGroup;
begin
  Result := Designer.lgLegend;
end;

function TLegendNodeObject.IsAppearanceEnabled: Boolean;
begin
  Result := inherited IsAppearanceEnabled and ActualVisible;
end;

function TLegendNodeObject.IsEnabled: Boolean;
begin
  Result := ActualVisible;
end;

procedure TLegendNodeObject.SetActualVisible(const Value: Boolean);
begin
  if ActualVisible <> Value then
    Legend.Visible := Value;
end;

{ TLegendTitleNodeObject }

procedure TTitleNodeObject.CommandIconClick(AIndex: Integer);
begin
  case AIndex of
    0: ToggleVisibility;
  else
    inherited CommandIconClick(AIndex);
  end;
end;

procedure TTitleNodeObject.ApplyChangedValueToChart(Sender: TObject);
begin
  if Sender = Designer.teTitleText then
  begin
    TdxChartElementTitleAccess(Title).Text := Designer.teTitleText.Text;
    Node.Caption := DoGetCaption;
    if (Node.Parent <> nil) and (TObject(Node.Parent.Data) is TDiagramSeriesNodeObject) then
      TDiagramSeriesNodeObject(Node.Parent.Data).UpdateNodeCaption;
  end;
  if Sender = Designer.cbTitleVisibility then
    Title.Visible := Designer.cbTitleVisibility.Checked;
  if Sender = Designer.cbTitleWordWrap then
    Title.WordWrap := Designer.cbTitleWordWrap.EditValue;
  if Sender = Designer.seTitleMaxLineCount then
    Title.MaxLineCount := Designer.seTitleMaxLineCount.EditValue;
  if Sender = Designer.cbTitleAlignment then
    Title.Alignment := TdxAlignment(Designer.cbTitleAlignment.ItemIndex);
  if Sender = Designer.cbTitleDock then
    TdxChartVisualElementTitleAccess(Title).Position := TdxChartTitlePosition(Designer.cbTitleDock.ItemIndex);
  inherited ApplyChangedValueToChart(Sender);
end;

function TTitleNodeObject.DoGetCaption: string;
begin
  Result := cxGetResourceString(@sdxChartDesignerTitleCaption)
end;

procedure TTitleNodeObject.DoToggleVisibility;
begin
  ActualVisible := not ActualVisible
end;

procedure TTitleNodeObject.DoUpdateOptionsFromChart;
begin
  inherited DoUpdateOptionsFromChart;
  Designer.lgOptionsGeneral.Parent := Designer.lgTitleGeneral;
  Designer.lgOptionsGeneral.Index := 0;
  Designer.liTitleDock.Visible := IsPublishedProp(Title, 'Position') and
    (GetPropInfo(PTypeInfo(Title.ClassInfo), 'Position', [tkEnumeration]).PropType^.Name = 'TdxChartTitlePosition');
  Designer.liTitleAxisPosition.Visible := IsPublishedProp(Title, 'Position') and
    (GetPropInfo(PTypeInfo(Title.ClassInfo), 'Position', [tkEnumeration]).PropType^.Name = 'TdxChartAxisTitlePosition');

  Designer.teTitleText.Text := TdxChartElementTitleAccess(Title).Text;
  Designer.cbTitleVisibility.Checked := Title.Visible;
  Designer.cbTitleWordWrap.EditValue := Title.WordWrap;
  Designer.liTitleMaxLineCount.Visible := IsPublishedProp(Title, 'MaxLineCount');
  Designer.seTitleMaxLineCount.EditValue := Title.MaxLineCount;
  Designer.cbTitleAlignment.ItemIndex := Ord(Title.Alignment);
  Designer.cbTitleDock.ItemIndex := Ord(TdxChartVisualElementTitleAccess(Title).Position);
end;

procedure TTitleNodeObject.DoUpdateOptionStates;
begin
  inherited DoUpdateOptionStates;
  Designer.liTitleWordWrap.Enabled := ActualVisible;
  Designer.liTitleMaxLineCount.Enabled := ActualVisible;
  Designer.liTitleAlignment.Enabled := ActualVisible;
  Designer.liTitleDock.Enabled := ActualVisible;
  Designer.liTitleAxisPosition.Enabled := ActualVisible;
end;

function TTitleNodeObject.GetActualVisible: Boolean;
begin
  Result := Title.Visible;
end;

function TTitleNodeObject.GetCommandIconHint(AIndex: Integer): string;
begin
  Result := cxGetResourceString(@sdxChartDesignerChangeVisibilityHint)
end;

function TTitleNodeObject.GetCommandIconImageIndex(
  AIndex: Integer): Integer;
begin
  case AIndex of
    0: Result := VisibilityCommandIconIndex[ActualVisible];
  else
    Result := inherited GetCommandIconImageIndex(AIndex);
  end;
end;

function TTitleNodeObject.GetCommandIconCount: Integer;
begin
  Result := 1;
end;

function TTitleNodeObject.GetImageIndex: Integer;
begin
  Result := 2;
end;

function TTitleNodeObject.GetOptionsGroup: TdxLayoutGroup;
begin
  Result := Designer.lgTitle;
end;

function TTitleNodeObject.GetTitle: TdxChartVisualElementTitle;
begin
  Result := TdxChartVisualElementTitle(&Object);
end;

function TTitleNodeObject.IsAppearanceEnabled: Boolean;
begin
  Result := ActualVisible;
end;

function TTitleNodeObject.IsEnabled: Boolean;
begin
  Result := ActualVisible;
end;

procedure TTitleNodeObject.SetActualVisible(const Value: Boolean);
begin
  if ActualVisible <> Value then
    Title.Visible := Value;
end;

{ TDiagramNodeObject }

class procedure TDiagramNodeObject.Initialize;
begin
  FDiagramImageIndexes := TDictionary<TClass, Integer>.Create;
  FDiagramImageIndexes.Add(TdxChartXYDiagram, 4);
  FDiagramImageIndexes.Add(TdxChartSimpleDiagram, 5);
end;

class procedure TDiagramNodeObject.Finalize;
begin
  FreeAndNil(FDiagramImageIndexes);
end;

function TDiagramNodeObject.CanChangeIndex(ADelta: Integer): Boolean;
var
  ANewIndex: Integer;
begin
  ANewIndex := Diagram.Index + ADelta;
  Result := (ANewIndex >= 0) and (ANewIndex <= TdxChartCustomDiagramAccess(Diagram).Chart.DiagramCount - 1);
end;

procedure TDiagramNodeObject.ChangeIndex(ADelta: Integer);
begin
  Diagram.Index := Diagram.Index + ADelta;
end;

procedure TDiagramNodeObject.CommandIconClick(AIndex: Integer);
begin
  if not Designer.CanAddSeries then
    Inc(AIndex);
  case AIndex of
    0:
    begin
      Designer.LocalizeSeriesMenu(True);
      Popup(Designer.pmSeries, 0);
    end;
    1: ToggleVisibility;
    2: Designer.DeleteDiagram(Diagram);
  else
    inherited CommandIconClick(AIndex);
  end;
end;

procedure TDiagramNodeObject.CreateSubNodes;
var
  I: Integer;
  ASeries: TdxChartCustomSeries;
begin
  inherited CreateSubNodes;
  Designer.CreateNode(Node, Diagram.Title, TTitleNodeObject);
  DoCreateSubNodes;
  Designer.CreateNode(Node, Diagram.Legend, TLegendNodeObject);
  for I := 0 to Diagram.SeriesCount - 1 do
  begin
    ASeries := Diagram.Series[I];
    Designer.CreateNode(Node, ASeries, GetSeriesNodeObjectClass);
  end;
end;

procedure TDiagramNodeObject.ApplyChangedValueToChart(Sender: TObject);
begin
  if Sender = Designer.lcbiDiagramVisible then
    Diagram.Visible := Designer.lcbiDiagramVisible.Checked;
  inherited ApplyChangedValueToChart(Sender);
end;

procedure TDiagramNodeObject.DoCreateSubNodes;
begin
// do nothing
end;

function TDiagramNodeObject.DoGetCaption: string;
begin
  if Diagram is TdxChartXYDiagram then
    Result := cxGetResourceString(@sdxChartControlXYDiagramDisplayName)
  else if Diagram is TdxChartSimpleDiagram then
    Result := cxGetResourceString(@sdxChartControlSimpleDiagramDisplayName)
  else
    Result := &Object.ClassName;
end;

procedure TDiagramNodeObject.DoToggleVisibility;
begin
  Diagram.Visible := not Diagram.Visible;
end;

procedure TDiagramNodeObject.DoUpdateOptionsFromChart;
begin
  Designer.lgOptionsGeneral.Parent := Designer.lgDiagramGeneral;
  Designer.lgOptionsGeneral.Index := 0;
  Designer.lcbiDiagramVisible.Checked := Diagram.Visible;
  inherited DoUpdateOptionsFromChart;
end;

procedure TDiagramNodeObject.DoUpdateOptionStates;
var
  AEnabled: Boolean;
begin
  AEnabled := Diagram.Visible;
  Designer.liDiagramLayoutDirection.Enabled := AEnabled;
  Designer.liDiagramDimension.Enabled := AEnabled;
  Designer.lcbiDiagramRotated.Enabled := AEnabled;

  inherited DoUpdateOptionStates;
end;

function TDiagramNodeObject.GetCommandIconHint(AIndex: Integer): string;
begin
  if not Designer.CanAddSeries then
    Inc(AIndex);
  case AIndex of
    0: Result := cxGetResourceString(@sdxChartDesignerAddSeriesHint);
    1: Result := cxGetResourceString(@sdxChartDesignerChangeVisibilityHint);
    2: Result := cxGetResourceString(@sdxChartDesignerDeleteHint);
  else
    Result := inherited GetCommandIconHint(AIndex);
  end;
end;

function TDiagramNodeObject.GetCommandIconImageIndex(AIndex: Integer): Integer;
begin
  if not Designer.CanAddSeries then
    Inc(AIndex);
  case AIndex of
    0: Result := AddCommandIconIndex;
    1: Result := VisibilityCommandIconIndex[Diagram.Visible];
    2: Result := RemoveCommandIconIndex;
  else
    Result := -1;
  end;
end;

function TDiagramNodeObject.GetCommandIconCount: Integer;
begin
  Result := 3;
  if not Designer.CanAddSeries then
    Dec(Result);
  if not Designer.CanDelete(Diagram) then
    Dec(Result);
end;

function TDiagramNodeObject.GetDiagram: TdxChartCustomDiagram;
begin
  Result := TdxChartCustomDiagram(&Object);
end;

class function TDiagramNodeObject.GetDiagramImageIndex(
  ADiagram: TObject): Integer;
begin
  if not FDiagramImageIndexes.TryGetValue(ADiagram.ClassType, Result) then
    Result := 4;
end;

function TDiagramNodeObject.GetImageIndex: Integer;
begin
  Result := GetDiagramImageIndex(&Object);
end;

function TDiagramNodeObject.GetOptionsGroup: TdxLayoutGroup;
begin
  Result := Designer.lgDiagramOptions;
end;

function TDiagramNodeObject.IsAppearanceEnabled: Boolean;
begin
  Result := inherited IsAppearanceEnabled and Diagram.Visible;
end;

function TDiagramNodeObject.IsEnabled: Boolean;
begin
  Result := Diagram.Visible;
end;

function TDiagramNodeObject.CanDrag: Boolean;
begin
  Result := True;
end;

function TDiagramNodeObject.CanDrop(const P: TPoint; AHitNodeObject: TdxChartDesignerTreeViewNodeData; var AAfter: Boolean): Boolean;
var
  AHitObject: TDiagramNodeObject;
  ANewIndex: Integer;
  R: TRect;
begin
  Result := AHitNodeObject is TDiagramNodeObject;
  if Result then
  begin
    AHitObject := TDiagramNodeObject(AHitNodeObject);
    R := AHitObject.GetNodeDisplayRect;
    AAfter := (R.Top + R.Bottom) div 2 <= P.Y;
    ANewIndex := AHitObject.Diagram.Index;
    if ANewIndex < Diagram.Index then
      Inc(ANewIndex);
    if not AAfter then
      Dec(ANewIndex);
    Result := ANewIndex <> Diagram.Index;
  end;
end;

procedure TDiagramNodeObject.Drop(const P: TPoint; AHitNodeObject: TdxChartDesignerTreeViewNodeData);
var
  AAfter: Boolean;
  AIndex: Integer;
  AHitObject: TDiagramNodeObject;
begin
  if not CanDrop(P, AHitNodeObject, AAfter) then
    Exit;
  if AHitNodeObject is TDiagramNodeObject then
  begin
    AHitObject := TDiagramNodeObject(AHitNodeObject);
    AIndex := AHitObject.Diagram.Index;
    if AAfter then
      Inc(AIndex);
    if AIndex > Diagram.Index then
      Dec(AIndex);
    Diagram.Index := AIndex;
  end;
end;

{ TXYDiagramNodeObject }

procedure TXYDiagramNodeObject.CreateSubNodes;
begin
  inherited CreateSubNodes;

end;

procedure TXYDiagramNodeObject.ApplyChangedValueToChart(Sender: TObject);
begin
  if Sender = Designer.lcbiDiagramRotated then
    Diagram.Rotated := Designer.lcbiDiagramRotated.Checked;
  inherited ApplyChangedValueToChart(Sender);
end;

procedure TXYDiagramNodeObject.DoCreateSubNodes;
begin
  inherited DoCreateSubNodes;
  Designer.CreateNode(Node, Diagram.Axes.AxisX, TAxisXNodeObject);
  Designer.CreateNode(Node, Diagram.Axes.AxisY, TAxisYNodeObject);
end;

procedure TXYDiagramNodeObject.DoUpdateOptionsFromChart;
begin
  Designer.liDiagramLayoutDirection.Visible := False;
  Designer.liDiagramDimension.Visible := False;
  Designer.lcbiDiagramRotated.Visible := True;
  Designer.lcbiDiagramRotated.Checked := Diagram.Rotated;
  inherited DoUpdateOptionsFromChart;
end;

function TXYDiagramNodeObject.GetDiagram: TdxChartXYDiagram;
begin
  Result := TdxChartXYDiagram(inherited Diagram);
end;

function TXYDiagramNodeObject.GetSeriesNodeObjectClass: TDiagramSeriesNodeObjectClass;
begin
  Result := TXYDiagramSeriesNodeObject;
end;

{ TSimpleDiagramNodeObject }

procedure TSimpleDiagramNodeObject.CreateSubNodes;
begin
  inherited CreateSubNodes;
end;

procedure TSimpleDiagramNodeObject.ApplyChangedValueToChart(Sender: TObject);
begin
  if Sender = Designer.cbDiagramLayoutDirection then
    Diagram.Layout := TdxSimpleDiagramLayout(Designer.cbDiagramLayoutDirection.ItemIndex);
  if Sender = Designer.seDiagramDimension then
    Diagram.Dimension := Designer.seDiagramDimension.Value;
  inherited ApplyChangedValueToChart(Sender);
end;

procedure TSimpleDiagramNodeObject.DoUpdateOptionsFromChart;
begin
  Designer.liDiagramLayoutDirection.Visible := True;
  Designer.liDiagramDimension.Visible := True;
  Designer.lcbiDiagramRotated.Visible := False;
  Designer.cbDiagramLayoutDirection.ItemIndex := Ord(Diagram.Layout);
  Designer.seDiagramDimension.Value := Diagram.Dimension;
  inherited DoUpdateOptionsFromChart;
end;

function TSimpleDiagramNodeObject.GetDiagram: TdxChartSimpleDiagram;
begin
  Result := TdxChartSimpleDiagram(inherited Diagram);
end;

function TSimpleDiagramNodeObject.GetSeriesNodeObjectClass: TDiagramSeriesNodeObjectClass;
begin
  Result := TSimpleDiagramSeriesNodeObject;
end;

{ TDiagramSeriesNodeObject }

class procedure TDiagramSeriesNodeObject.Initialize;
begin
  FSeriesImageIndexes := TDictionary<TClass, Integer>.Create;
  FSeriesImageIndexes.Add(TdxChartSimpleSeriesPieView, 6);
  FSeriesImageIndexes.Add(TdxChartSimpleSeriesDoughnutView, 7);
  FSeriesImageIndexes.Add(TdxChartXYSeriesLineView, 8);
  FSeriesImageIndexes.Add(TdxChartXYSeriesBarView, 9);
  FSeriesImageIndexes.Add(TdxChartXYSeriesStackedBarView, 10);
  FSeriesImageIndexes.Add(TdxChartXYSeriesStackedBarSideBySideView, 11);
  FSeriesImageIndexes.Add(TdxChartXYSeriesFullStackedBarView, 12);
  FSeriesImageIndexes.Add(TdxChartXYSeriesFullStackedBarSideBySideView, 13);
  FSeriesImageIndexes.Add(TdxChartXYSeriesAreaView, 16);
  FSeriesImageIndexes.Add(TdxChartXYSeriesStackedAreaView, 17);
  FSeriesImageIndexes.Add(TdxChartXYSeriesFullStackedAreaView, 18);
  FSeriesImageIndexes.Add(TdxChartXYSeriesStackedLineView, 19);
  FSeriesImageIndexes.Add(TdxChartXYSeriesFullStackedLineView, 20);
end;

class procedure TDiagramSeriesNodeObject.Finalize;
begin
  FreeAndNil(FSeriesImageIndexes);
end;

function TDiagramSeriesNodeObject.IsAppearanceEnabled: Boolean;
begin
  Result := inherited IsAppearanceEnabled and Series.Visible;
end;

function TDiagramSeriesNodeObject.IsEnabled: Boolean;
begin
  Result := Series.Visible;
end;

procedure TDiagramSeriesNodeObject.UpdateNodeCaption;
begin
  Node.Caption := DoGetCaption;
end;

function TDiagramSeriesNodeObject.CanChangeIndex(ADelta: Integer): Boolean;
var
  ANewIndex: Integer;
begin
  ANewIndex := Series.Index + ADelta;
  Result := (ANewIndex >= 0) and (ANewIndex <= Series.Diagram.SeriesCount - 1);
end;

function TDiagramSeriesNodeObject.CanDrag: Boolean;
begin
  Result := True;
end;

function TDiagramSeriesNodeObject.CanDrop(const P: TPoint; AHitNodeObject: TdxChartDesignerTreeViewNodeData; var AAfter: Boolean): Boolean;
var
  AHitSeriesNodeObject: TDiagramSeriesNodeObject;
  AHitDiagramNodeObject: TDiagramNodeObject;
  ANewIndex: Integer;
  R: TRect;
begin
  Result := AHitNodeObject is TDiagramSeriesNodeObject;
  if Result then
  begin
    AHitSeriesNodeObject := TDiagramSeriesNodeObject(AHitNodeObject);
    R := AHitSeriesNodeObject.GetNodeDisplayRect;
    AAfter := (R.Top + R.Bottom) div 2 <= P.Y;
    if AHitSeriesNodeObject.Series.Diagram <> Series.Diagram then
      Result := Series.View.IsCompatibleWith(TdxChartSeriesClass(AHitSeriesNodeObject.Series.ClassType))
    else
    begin
      ANewIndex := AHitSeriesNodeObject.Series.Index;
      if ANewIndex < Series.Index then
        Inc(ANewIndex);
      if not AAfter then
        Dec(ANewIndex);
      Result := ANewIndex <> Series.Index;
    end;
    Exit;
  end;
  Result := AHitNodeObject is TDiagramNodeObject;
  if Result then
  begin
    AHitDiagramNodeObject := TDiagramNodeObject(AHitNodeObject);
    AAfter := True;
    Result := (AHitDiagramNodeObject.Diagram <> Series.Diagram) and
      Series.View.IsCompatibleWith(TdxChartCustomDiagramAccess(AHitDiagramNodeObject.Diagram).GetSeriesClass);
  end;
end;

procedure TDiagramSeriesNodeObject.ChangeIndex(ADelta: Integer);
var 
  AIndex: Integer;
begin  
  AIndex := Series.Index;
  Series.Index := AIndex + ADelta;
  if AIndex <> Series.Index then
    Designer.Modified;
end;

procedure TDiagramSeriesNodeObject.CommandIconClick(AIndex: Integer);
begin
  case AIndex of
    0:
    begin
      Designer.LocalizeSeriesMenu(False);
      Popup(Designer.pmSeries, 0);
    end;
    1: ToggleVisibility;
    2: Designer.DeleteSeries(Series);
  else
    inherited CommandIconClick(AIndex);
  end;
end;

procedure TDiagramSeriesNodeObject.CreateSubNodes;
begin
  inherited CreateSubNodes;
  if Series.View <> nil then
  begin
    if IsPublishedProp(Series, 'Title') then
      Designer.CreateNode(Node, TdxChartCustomSeriesAccess(Series).Title, TTitleNodeObject);
    DoCreateSubNodes;
    if IsPublishedProp(Series.View, 'ValueLabels') then
      Designer.CreateNode(Node, TdxChartSeriesCustomViewAccess(Series.View).ValueLabels, TDiagramSeriesValueLabelsNodeObject);
  end;
end;

procedure TDiagramSeriesNodeObject.ApplyChangedValueToChart(Sender: TObject);
var
  ASeries: TdxChartCustomSeriesAccess;
  APieView: TdxChartSimpleSeriesCustomPieViewAccess;
  ADoughnutView: TdxChartSimpleSeriesDoughnutView;
begin
  ASeries := TdxChartCustomSeriesAccess(Series);
  if Sender = Designer.lcbiSeriesVisible then
    ASeries.Visible := Designer.lcbiSeriesVisible.Checked;
  if Sender = Designer.teSeriesCaption then
  begin
    ASeries.Caption := Designer.teSeriesCaption.Text;
    Node.Caption := DoGetCaption;
  end;
  if Sender = Designer.cbSeriesShowInLegend then
    ASeries.ShowInLegend := TdxChartSeriesShowInLegend(Designer.cbSeriesShowInLegend.ItemIndex);
  if Sender = Designer.cbSeriesSortBy then
    ASeries.SortBy := TdxChartSeriesSortBy(Designer.cbSeriesSortBy.ItemIndex);
  if Sender = Designer.cbSeriesSortOrder then
    ASeries.SortOrder := TdxSortOrder(Designer.cbSeriesSortOrder.ItemIndex);

  if Sender = Designer.lcbiSeriesTopNEnabled then
    ASeries.TopNOptions.Enabled := Designer.lcbiSeriesTopNEnabled.Checked;
  if Sender = Designer.cbTopNMode then
    ASeries.TopNOptions.Mode := TdxChartSeriesTopNOptionsMode(Designer.cbTopNMode.ItemIndex);
  if Sender = Designer.lcbiTopNShowOthers then
    ASeries.TopNOptions.ShowOthers := Designer.lcbiTopNShowOthers.Checked;
  if Sender = Designer.seTopNCount then
    ASeries.TopNOptions.Value := Designer.seTopNCount.Value;
  if Sender = Designer.seTopNThresholdValue then
    ASeries.TopNOptions.Value := Designer.seTopNThresholdValue.Value;
  if Sender = Designer.seTopNThresholdPercent then
    ASeries.TopNOptions.Value := Designer.seTopNThresholdPercent.Value;

  if ASeries.View is TdxChartSimpleSeriesCustomPieView then
  begin
    APieView := TdxChartSimpleSeriesCustomPieViewAccess(Series.View);
    if Sender = Designer.cbSeriesViewSweepDirection then
      APieView.SweepDirection := TdxChartPieSweepDirection(Designer.cbSeriesViewSweepDirection.ItemIndex);
    if Sender = Designer.seSeriesViewStartAngle then
      APieView.StartAngle := Designer.seSeriesViewStartAngle.Value;
    if Sender = Designer.cbSeriesViewExplodedValueMode then
      APieView.ExplodedValueOptions.Mode := TdxChartExplodedValueMode(Designer.cbSeriesViewExplodedValueMode.ItemIndex);

    if ASeries.View is TdxChartSimpleSeriesDoughnutView then
    begin
      ADoughnutView := TdxChartSimpleSeriesDoughnutView(APieView);
      if Sender = Designer.seSeriesViewHoleRadius then
        ADoughnutView.HoleRadius := Designer.CustomizedScaleFactor.Apply(Designer.seSeriesViewHoleRadius.Value);
    end;
  end;
  inherited ApplyChangedValueToChart(Sender);
end;

procedure TDiagramSeriesNodeObject.DoCreateSubNodes;
begin
// do nothing
end;

function TDiagramSeriesNodeObject.DoGetCaption: string;
begin
  Result := Series.Caption;
  if Trim(Result) = '' then
    Result := Format(cxGetResourceString(@sdxChartDesignerSeriesNameCaption), [Series.Index + 1])
  else
    Result := Format(cxGetResourceString(@sdxChartDesignerSeriesNodeCaption), [Result])
end;

procedure TDiagramSeriesNodeObject.DoToggleVisibility;
begin
  Series.Visible := not Series.Visible;
end;

procedure TDiagramSeriesNodeObject.DoUpdateOptionsFromChart;
var
  ASeries: TdxChartCustomSeriesAccess;
  APieView: TdxChartSimpleSeriesCustomPieViewAccess;
begin
  ASeries := TdxChartCustomSeriesAccess(Series);
  Designer.lgOptionsGeneral.Parent := Designer.lgSeriesGeneral;
  Designer.lgOptionsGeneral.Index := 0;

  Designer.lcbiSeriesVisible.Checked := ASeries.Visible;
  Designer.liSeriesShowInLegend.Visible := IsPublishedProp(Series, 'ShowInLegend');
  Designer.cbSeriesShowInLegend.ItemIndex := Ord(ASeries.ShowInLegend);
  Designer.teSeriesCaption.Text := ASeries.Caption;
  Designer.liSeriesSortBy.Visible := IsPublishedProp(Series, 'SortBy');
  Designer.cbSeriesSortBy.ItemIndex := Ord(ASeries.SortBy);
  Designer.liSeriesSortOrder.Visible := IsPublishedProp(Series, 'SortOrder');
  Designer.cbSeriesSortOrder.ItemIndex := Ord(ASeries.SortOrder);

  Designer.lgSeriesTopNOptions.Visible := IsPublishedProp(Series, 'TopNOptions');
  Designer.lcbiSeriesTopNEnabled.Checked := ASeries.TopNOptions.Enabled;
  Designer.lcbiTopNShowOthers.Checked := ASeries.TopNOptions.ShowOthers;
  Designer.seTopNCount.Value := ASeries.TopNOptions.Value;
  Designer.seTopNThresholdValue.Value := ASeries.TopNOptions.Value;
  Designer.seTopNThresholdPercent.Value := ASeries.TopNOptions.Value;
  Designer.cbTopNMode.ItemIndex := Ord(ASeries.TopNOptions.Mode);

  if ASeries.View is TdxChartSimpleSeriesCustomPieView then
  begin
    Designer.lgSeriesViewOptions.Visible := True;
    APieView := TdxChartSimpleSeriesCustomPieViewAccess(Series.View);

    Designer.cbSeriesViewSweepDirection.ItemIndex := Ord(APieView.SweepDirection);
    Designer.seSeriesViewStartAngle.Value := APieView.StartAngle;
    Designer.cbSeriesViewExplodedValueMode.ItemIndex := Ord(APieView.ExplodedValueOptions.Mode);
    if ASeries.View is TdxChartSimpleSeriesDoughnutView then
    begin
      Designer.liSeriesViewHoleRadius.Visible := True;
      Designer.seSeriesViewHoleRadius.Value := TdxChartSimpleSeriesDoughnutView(ASeries.View).HoleRadius;
    end
    else
      Designer.liSeriesViewHoleRadius.Visible := False;
  end
  else
    Designer.lgSeriesViewOptions.Visible := False;

  inherited DoUpdateOptionsFromChart;
end;

procedure TDiagramSeriesNodeObject.DoUpdateOptionStates;
var
  AEnabled: Boolean;
var
  ASeries: TdxChartCustomSeriesAccess;
begin
  ASeries := TdxChartCustomSeriesAccess(Series);
  AEnabled := ASeries.Visible;
  Designer.liSeriesCaption.Enabled := AEnabled;
  Designer.liSeriesShowInLegend.Enabled := AEnabled;
  Designer.liSeriesSortBy.Enabled := AEnabled;
  Designer.liSeriesSortOrder.Enabled := AEnabled;
  Designer.lgSeriesTopNOptions.Enabled := AEnabled;
  Designer.lgSeriesViewOptions.Enabled := AEnabled;
  AEnabled := AEnabled and ASeries.TopNOptions.Enabled;
  Designer.lcbiTopNShowOthers.Enabled := AEnabled;
  Designer.liTopNCount.Enabled := AEnabled;
  Designer.liTopNThresholdValue.Enabled := AEnabled;
  Designer.liTopNThresholdPercent.Enabled := AEnabled;
  Designer.liTopNMode.Enabled := AEnabled;
  Designer.liTopNCount.Visible := ASeries.TopNOptions.Mode = TdxChartSeriesTopNOptionsMode.Count;
  Designer.liTopNThresholdPercent.Visible := ASeries.TopNOptions.Mode = TdxChartSeriesTopNOptionsMode.ThresholdPercent;
  Designer.liTopNThresholdValue.Visible := ASeries.TopNOptions.Mode = TdxChartSeriesTopNOptionsMode.ThresholdValue;

  inherited DoUpdateOptionStates;
end;

procedure TDiagramSeriesNodeObject.Drop(const P: TPoint;
  AHitNodeObject: TdxChartDesignerTreeViewNodeData);
var
  AAfter: Boolean;
  AIndex: Integer;
  AHitSeriesNodeObject: TDiagramSeriesNodeObject;
  ADiagram: TdxChartCustomDiagram;
begin
  if not CanDrop(P, AHitNodeObject, AAfter) then
    Exit;
  AIndex := Series.Index;
  ADiagram := Series.Diagram;
  if AHitNodeObject is TDiagramSeriesNodeObject then
  begin
    AHitSeriesNodeObject := TDiagramSeriesNodeObject(AHitNodeObject);
    AIndex := AHitSeriesNodeObject.Series.Index;
    if AAfter then
      Inc(AIndex);
    ADiagram := AHitSeriesNodeObject.Series.Diagram;
    if ADiagram = Series.Diagram then
    begin
      if AIndex > Series.Index then
        Dec(AIndex);
    end;
  end
  else if AHitNodeObject is TDiagramNodeObject then
  begin
    ADiagram := TDiagramNodeObject(AHitNodeObject).Diagram;
    AIndex := ADiagram.SeriesCount;
  end;
  Designer.CustomizedChartControl.BeginUpdate;
  try
    Designer.GetNodeByObject(ADiagram).Expanded := True;
    Series.Diagram := ADiagram;
    Series.Index := AIndex;
  finally
    Designer.CustomizedChartControl.EndUpdate;
  end;
end;

function TDiagramSeriesNodeObject.GetAppearance: TdxChartCustomAppearanceAccess;
var
  AIntf: IdxChartVisualElement;
begin
  Result := inherited GetAppearance;
  if Result = nil then
    if Supports(Series.View, IdxChartVisualElement, AIntf) then
      Result := TdxChartCustomAppearanceAccess(AIntf.GetAppearance);
end;

function TDiagramSeriesNodeObject.GetCommandIconHint(AIndex: Integer): string;
begin
  case AIndex of
    0: Result := cxGetResourceString(@sdxChartDesignerChangeViewHint);
    1: Result := cxGetResourceString(@sdxChartDesignerChangeVisibilityHint);
    2: Result := cxGetResourceString(@sdxChartDesignerDeleteHint);
  else
    Result := inherited GetCommandIconHint(AIndex);
  end;
end;

function TDiagramSeriesNodeObject.GetCommandIconImageIndex(
  AIndex: Integer): Integer;
begin
  case AIndex of
    0: Result := ChangeSeriesTypeCommandIconIndex;
    1: Result := VisibilityCommandIconIndex[Series.Visible];
    2: Result := RemoveCommandIconIndex;
  else
    Result := -1;
  end;
end;

function TDiagramSeriesNodeObject.GetCommandIconCount: Integer;
begin
  Result := 3;
  if not Designer.CanDelete(Series) then
    Dec(Result);
end;

function TDiagramSeriesNodeObject.GetImageIndex: Integer;
begin
  Result := GetSeriesImageIndex(Series);
end;

function TDiagramSeriesNodeObject.GetOptionsGroup: TdxLayoutGroup;
begin
  Result := Designer.lgSeriesOptions;
end;

function TDiagramSeriesNodeObject.GetSeries: TdxChartCustomSeries;
begin
  Result := TdxChartCustomSeries(&Object);
end;

class function TDiagramSeriesNodeObject.GetSeriesImageIndex(
  ASeries: TdxChartCustomSeries): Integer;
begin
  if not FSeriesImageIndexes.TryGetValue(ASeries.ViewClass, Result) then
    Result := -1;
end;

{ TXYDiagramSeriesNodeObject }

procedure TXYDiagramSeriesNodeObject.ApplyChangedValueToChart(Sender: TObject);
begin
  if Sender = Designer.seSeriesBarWidth then
    TdxChartXYSeriesBarView(Series.View).BarWidth := Designer.seSeriesBarWidth.EditValue;
  inherited ApplyChangedValueToChart(Sender);
end;

procedure TXYDiagramSeriesNodeObject.DoCreateSubNodes;
begin
  inherited DoCreateSubNodes;
  if Series.View <> nil then
  begin
    if (Series.View is TdxChartXYSeriesLineView) and IsPublishedProp(Series.View, 'Markers') then
      Designer.CreateNode(Node, TdxChartXYSeriesLineView(Series.View).Markers, TMarkersNodeObject);
  end;
end;

procedure TXYDiagramSeriesNodeObject.DoUpdateOptionsFromChart;
begin
  Designer.liSeriesBarWidth.Visible := (Series.View <> nil) and IsPublishedProp(Series.View, 'BarWidth');
  if Designer.liSeriesBarWidth.Visible and (Series.View is TdxChartXYSeriesBarView) then
    Designer.seSeriesBarWidth.EditValue := TdxChartXYSeriesBarView(Series.View).BarWidth;
  inherited DoUpdateOptionsFromChart;
end;

procedure TXYDiagramSeriesNodeObject.DoUpdateOptionStates;
begin
  Designer.liSeriesBarWidth.Enabled := IsEnabled;
  inherited DoUpdateOptionStates;
end;

{ TSimpleDiagramSeriesNodeObject }

procedure TSimpleDiagramSeriesNodeObject.DoUpdateOptionsFromChart;
begin
  Designer.liSeriesBarWidth.Visible := False;
  inherited DoUpdateOptionsFromChart;
end;

{ TDiagramSeriesValueLabelsNodeObject }

procedure TDiagramSeriesValueLabelsNodeObject.CommandIconClick(AIndex: Integer);
begin
  ToggleVisibility;
end;

procedure TDiagramSeriesValueLabelsNodeObject.ApplyChangedValueToChart(Sender: TObject);
begin
  if Sender = Designer.lcbiValueLabelsVisible then
    ValueLabels.Visible := Designer.lcbiValueLabelsVisible.Checked;
  if Sender = Designer.lcbiValueLabelsLineVisible then
    ValueLabels.LineVisible := FCheckBoxStateToDefaultBoolean[Designer.lcbiValueLabelsLineVisible.State];
  if Sender = Designer.seValueLabelsLineLength then
    ValueLabels.LineLength := Designer.CustomizedScaleFactor.ApplyF(Designer.seValueLabelsLineLength.Value);
  if Sender = Designer.seValueLabelsMaxWidth then
    ValueLabels.MaxWidth := Designer.CustomizedScaleFactor.ApplyF(Designer.seValueLabelsMaxWidth.Value);
  if Sender = Designer.seValueLabelsMaxLineCount then
    ValueLabels.MaxLineCount := Designer.seValueLabelsMaxLineCount.Value;
  if Sender = Designer.teValueLabelsTextFormat then
    ValueLabels.TextFormat := Designer.teValueLabelsTextFormat.Text;
  if Sender = Designer.cbValueLabelsTextAlignment then
    ValueLabels.TextAlignment := TdxAlignment(Designer.cbValueLabelsTextAlignment.ItemIndex);
  if Sender = Designer.cbValueLabelsPosition then
    TdxChartPieValueLabels(ValueLabels).Position := TdxChartPieValueLabelPosition(Designer.cbValueLabelsPosition.ItemIndex);
  if Sender = Designer.seValueLabelsResolveOverlappingIndent then
    ValueLabels.ResolveOverlappingIndent := Designer.CustomizedScaleFactor.ApplyF(Designer.seValueLabelsResolveOverlappingIndent.Value);
  if Sender = Designer.cbValueLabelsResolveOverlappingMode then
    if ValueLabels is TdxChartXYSeriesLineValueLabels then
      TdxChartXYSeriesLineValueLabels(ValueLabels).ResolveOverlappingMode :=
        TdxChartSeriesLineValueLabelsResolveOverlappingMode(Designer.cbValueLabelsResolveOverlappingMode.ItemIndex)
    else
      if ValueLabels is TdxChartXYSeriesBarValueLabels then
        TdxChartXYSeriesBarValueLabels(ValueLabels).ResolveOverlappingMode :=
          TdxChartSeriesBarValueLabelsResolveOverlappingMode(Designer.cbValueLabelsResolveOverlappingMode.ItemIndex)
      else
        if ValueLabels is TdxChartPieValueLabels then
          TdxChartPieValueLabels(ValueLabels).ResolveOverlappingMode :=
            TdxChartPieValueLabelsResolveOverlappingMode(Designer.cbValueLabelsResolveOverlappingMode.ItemIndex);

  inherited ApplyChangedValueToChart(Sender);
end;

function TDiagramSeriesValueLabelsNodeObject.DoGetCaption: string;
begin
  Result := cxGetResourceString(@sdxChartDesignerValueLabelsCaption);
end;

procedure TDiagramSeriesValueLabelsNodeObject.DoToggleVisibility;
begin
  ActualVisible := not ActualVisible;
end;

procedure TDiagramSeriesValueLabelsNodeObject.DoUpdateOptionsFromChart;
begin
  Designer.lgOptionsGeneral.Parent := Designer.lgValueLabelsGeneral;
  Designer.lgOptionsGeneral.Index := 0;

  Designer.lcbiValueLabelsVisible.Checked := ValueLabels.Visible;
  Designer.lcbiValueLabelsLineVisible.State := FDefaultBooleanToCheckBoxState[ValueLabels.LineVisible];
  Designer.seValueLabelsLineLength.Value := Designer.CustomizedScaleFactor.RevertF(ValueLabels.LineLength);
  Designer.seValueLabelsMaxWidth.Value := Designer.CustomizedScaleFactor.RevertF(ValueLabels.MaxWidth);
  Designer.liValueLabelsMaxLineCount.Visible := IsPublishedProp(ValueLabels, 'MaxLineCount');
  Designer.seValueLabelsMaxLineCount.Value := ValueLabels.MaxLineCount;
  Designer.teValueLabelsTextFormat.Text := ValueLabels.TextFormat;
  Designer.cbValueLabelsTextAlignment.ItemIndex := Ord(ValueLabels.TextAlignment);

  Designer.liValueLabelsPosition.Visible := IsPublishedProp(ValueLabels, 'Position');
  if ValueLabels is TdxChartPieValueLabels then
    Designer.cbValueLabelsPosition.ItemIndex := Ord(TdxChartPieValueLabels(ValueLabels).Position);
  Designer.liValueLabelsResolveOverlappingIndent.Visible := IsPublishedProp(ValueLabels, 'ResolveOverlappingIndent');
  Designer.liValueLabelsResolveOverlappingMode.Visible := IsPublishedProp(ValueLabels, 'ResolveOverlappingMode');
  Designer.lgValueLabelsResolveOverlapping.Visible := Designer.liValueLabelsResolveOverlappingMode.Visible;
  Designer.seValueLabelsResolveOverlappingIndent.Value := Round(Designer.CustomizedScaleFactor.RevertF(ValueLabels.ResolveOverlappingIndent));
  if ValueLabels is TdxChartXYSeriesLineValueLabels then
  begin
    Designer.LocalizeValueLabelsResolveOverlappingMode(0);
    Designer.cbValueLabelsResolveOverlappingMode.ItemIndex := Ord(TdxChartXYSeriesLineValueLabels(ValueLabels).ResolveOverlappingMode);
  end
  else
    if ValueLabels is TdxChartXYSeriesBarValueLabels then
    begin
      Designer.LocalizeValueLabelsResolveOverlappingMode(1);
      Designer.cbValueLabelsResolveOverlappingMode.ItemIndex := Ord(TdxChartXYSeriesBarValueLabels(ValueLabels).ResolveOverlappingMode);
    end
    else
      if ValueLabels is TdxChartPieValueLabels then
      begin
        Designer.LocalizeValueLabelsResolveOverlappingMode(2);
        Designer.cbValueLabelsResolveOverlappingMode.ItemIndex := Ord(TdxChartPieValueLabels(ValueLabels).ResolveOverlappingMode)
      end;

  inherited DoUpdateOptionsFromChart;
end;

procedure TDiagramSeriesValueLabelsNodeObject.DoUpdateOptionStates;
var
  AEnabled: Boolean;
begin
  AEnabled := ActualVisible;
  Designer.lcbiValueLabelsLineVisible.Enabled := AEnabled;
  Designer.seValueLabelsMaxWidth.Enabled := AEnabled;
  Designer.seValueLabelsMaxLineCount.Enabled := AEnabled;
  Designer.teValueLabelsTextFormat.Enabled := AEnabled;
  Designer.cbValueLabelsTextAlignment.Enabled := AEnabled;
  Designer.cbValueLabelsPosition.Enabled := AEnabled;
  Designer.seValueLabelsLineLength.Enabled := AEnabled;
  Designer.seValueLabelsResolveOverlappingIndent.Enabled := AEnabled;
  Designer.cbValueLabelsResolveOverlappingMode.Enabled := AEnabled;
  inherited DoUpdateOptionStates;
end;

function TDiagramSeriesValueLabelsNodeObject.GetActualVisible: Boolean;
begin
  Result := ValueLabels.Visible;
end;

function TDiagramSeriesValueLabelsNodeObject.GetCommandIconHint(AIndex: Integer): string;
begin
  Result := cxGetResourceString(@sdxChartDesignerChangeVisibilityHint);
end;

function TDiagramSeriesValueLabelsNodeObject.GetCommandIconImageIndex(AIndex: Integer): Integer;
begin
  Result := VisibilityCommandIconIndex[ActualVisible];
end;

function TDiagramSeriesValueLabelsNodeObject.GetCommandIconCount: Integer;
begin
  Result := 1;
end;

function TDiagramSeriesValueLabelsNodeObject.GetOptionsGroup: TdxLayoutGroup;
begin
  Result := Designer.lgValueLabels;
end;

function TDiagramSeriesValueLabelsNodeObject.GetValueLabels: TdxChartSeriesValueLabels;
begin
  Result := TdxChartSeriesValueLabels(&Object);
end;

function TDiagramSeriesValueLabelsNodeObject.IsAppearanceEnabled: Boolean;
begin
  Result := ActualVisible;
end;

function TDiagramSeriesValueLabelsNodeObject.IsEnabled: Boolean;
begin
  Result := ActualVisible;
end;

procedure TDiagramSeriesValueLabelsNodeObject.SetActualVisible(const Value: Boolean);
begin
  if ActualVisible <> Value then
    ValueLabels.Visible := Value;
end;

{ TMarkersNodeObject }

procedure TMarkersNodeObject.CommandIconClick(AIndex: Integer);
begin
  ToggleVisibility;
end;

procedure TMarkersNodeObject.ApplyChangedValueToChart(Sender: TObject);
begin
  if Sender = Designer.lcbiMarkerVisible then
    Markers.Visible := Designer.lcbiMarkerVisible.Checked;
  if Sender = Designer.seMarkerSize then
    Markers.Size := Designer.CustomizedScaleFactor.ApplyF(Designer.seMarkerSize.Value);
  if Sender = Designer.cbMarkerType then
    Markers.Kind := TdxChartXYMarkerKind(Designer.cbMarkerType.ItemIndex);
  inherited ApplyChangedValueToChart(Sender);
end;

function TMarkersNodeObject.DoGetCaption: string;
begin
  Result := cxGetResourceString(@sdxChartDesignerMarkersCaption);
end;

procedure TMarkersNodeObject.DoToggleVisibility;
begin
  ActualVisible := not ActualVisible;
end;

procedure TMarkersNodeObject.DoUpdateOptionsFromChart;
begin
  Designer.lgOptionsGeneral.Parent := Designer.lgMarkersGeneral;
  Designer.lgOptionsGeneral.Index := 0;

  Designer.lcbiMarkerVisible.Checked := Markers.Visible;
  Designer.seMarkerSize.Value := Designer.CustomizedScaleFactor.RevertF(Markers.Size);
  Designer.cbMarkerType.ItemIndex := Ord(Markers.Kind);

  inherited DoUpdateOptionsFromChart;
end;

procedure TMarkersNodeObject.DoUpdateOptionStates;
begin
  Designer.liMarkerSize.Enabled := ActualVisible;
  Designer.liMarkerType.Enabled := ActualVisible;
  inherited DoUpdateOptionStates;
end;

function TMarkersNodeObject.GetActualVisible: Boolean;
begin
  Result := Markers.Visible;
end;

function TMarkersNodeObject.GetCommandIconHint(AIndex: Integer): string;
begin
  Result := cxGetResourceString(@sdxChartDesignerChangeVisibilityHint);
end;

function TMarkersNodeObject.GetCommandIconImageIndex(
  AIndex: Integer): Integer;
begin
  Result := VisibilityCommandIconIndex[ActualVisible]
end;

function TMarkersNodeObject.GetCommandIconCount: Integer;
begin
  Result := 1;
end;

function TMarkersNodeObject.GetMarkers: TdxChartXYSeriesLineMarkers;
begin
  Result := TdxChartXYSeriesLineMarkers(&Object);
end;

function TMarkersNodeObject.GetOptionsGroup: TdxLayoutGroup;
begin
  Result := Designer.lgMarkers;
end;

function TMarkersNodeObject.IsAppearanceEnabled: Boolean;
begin
  Result := ActualVisible;
end;

function TMarkersNodeObject.IsEnabled: Boolean;
begin
  Result := ActualVisible;
end;

procedure TMarkersNodeObject.SetActualVisible(const Value: Boolean);
begin
  if ActualVisible <> Value then
    Markers.Visible := Value;
end;

{ TAxisNodeObject }

constructor TAxisNodeObject.Create(ADesigner: TfrmChartDesigner;
  AObject: TPersistent);
begin
  inherited Create(ADesigner, AObject);
  FVarType := varEmpty;
  UpdateRangeEditors;
end;

procedure TAxisNodeObject.CommandIconClick(AIndex: Integer);
begin
  ToggleVisibility;
end;

procedure TAxisNodeObject.CreateSubNodes;
var
  AAxis: TdxChartCustomAxisAccess;
begin
  inherited CreateSubNodes;
  AAxis := TdxChartCustomAxisAccess(Axis);
  Designer.CreateNode(Node, AAxis.Gridlines, TAxisGridlinesNodeObject);
  Designer.CreateNode(Node, AAxis.ValueLabels, TAxisValueLabelsNodeObject);
  Designer.CreateNode(Node, AAxis.Title, TAxisTitleNodeObject);
end;

procedure TAxisNodeObject.ApplyChangedValueToChart(Sender: TObject);
var
  ARange: TdxChartRange;
  AAxisAppearance: TdxChartAxisAppearance;
  AAxis: TdxChartCustomAxisAccess;
begin
  AAxis := TdxChartCustomAxisAccess(Axis);
  ARange := AAxis.Range;

  if Sender = Designer.lcbiAxisVisible then
    ActualVisible := Designer.lcbiAxisVisible.Checked;
  if Sender = Designer.seAxisSideMargin then
    ARange.SideMarginMax := Designer.seAxisSideMargin.Value;
  if Sender = Designer.lcbiAxisVisualRangeAuto then
  begin
    if Designer.lcbiAxisVisualRangeAuto.Checked then
    begin
      ARange.VisibleMax := Unassigned;
      ARange.VisibleMin := Unassigned;
    end
    else
    begin
      ARange.VisibleMax := GetRangeMaxValue;
      ARange.VisibleMin := GetRangeMinValue;
    end;
  end;
  if Sender = Designer.liAxisVisualRangeMinValue.Control then
    ARange.VisibleMin := TcxCustomEdit(Designer.liAxisVisualRangeMinValue.Control).EditValue;
  if Sender = Designer.liAxisVisualRangeMaxValue.Control then
    ARange.VisibleMax := TcxCustomEdit(Designer.liAxisVisualRangeMaxValue.Control).EditValue;
  if Sender = Designer.lcbiAxisWholeRangeAuto then
  begin
    if Designer.lcbiAxisWholeRangeAuto.Checked then
    begin
      ARange.WholeMax := Unassigned;
      ARange.WholeMin := Unassigned;
    end
    else
    begin
      ARange.WholeMax := GetRangeMaxValue;
      ARange.WholeMin := GetRangeMinValue;
    end;
  end;
  if Sender = Designer.liAxisWholeRangeMinValue.Control then
    ARange.WholeMin := TcxCustomEdit(Designer.liAxisWholeRangeMinValue.Control).EditValue;
  if Sender = Designer.liAxisWholeRangeMaxValue.Control then
    ARange.WholeMax := TcxCustomEdit(Designer.liAxisWholeRangeMaxValue.Control).EditValue;

  AAxisAppearance := TdxChartAxisAppearance(GetAppearance);
  if Sender = Designer.seAppearanceAxisThickness then
    AAxisAppearance.Thickness := Designer.CustomizedScaleFactor.Apply(Designer.seAppearanceAxisThickness.Value);
  if Sender = Designer.ceAppearanceAxisColor then
    AAxisAppearance.Color := TdxAlphaColors.FromColor(Designer.ceAppearanceAxisColor.EditValue);

  if Sender = Designer.lcbiAxisReverse then
    AAxis.Reverse := Designer.lcbiAxisReverse.Checked;
  if Sender = Designer.cbAxisAlignment then
    AAxis.Alignment := TdxChartAxisAlignment(Designer.cbAxisAlignment.ItemIndex);
  if Sender = Designer.lcbiAxisInterlaced then
    AAxis.Interlaced := Designer.lcbiAxisInterlaced.Checked;
  if Sender = Designer.seAxisMinorCount then
    AAxis.MinorCount := Designer.seAxisMinorCount.EditValue;

  if Sender = Designer.lcbiAxisInterlaced then
    AAxis.Interlaced := Designer.lcbiAxisInterlaced.Checked;
  if Sender = Designer.ceAppearanceAxisInterlacedColor then
  begin
    AAxisAppearance.InterlacedFillOptions.Color := TdxAlphaColors.FromColor(Designer.ceAppearanceAxisInterlacedColor.ColorValue);
    Designer.InitializeHatchStyles(Designer.icbAppearanceAxisInterlacedStyle, AAxisAppearance.InterlacedFillOptions.ActualColor, AAxisAppearance.InterlacedFillOptions.ActualColor2);
  end;
  if Sender = Designer.ceAppearanceAxisInterlacedGradientBeginColor then
    AAxisAppearance.InterlacedFillOptions.Color := TdxAlphaColors.FromColor(Designer.ceAppearanceAxisInterlacedGradientBeginColor.ColorValue);
  if Sender = Designer.ceAppearanceAxisInterlacedGradientEndColor then
    AAxisAppearance.InterlacedFillOptions.Color2 := TdxAlphaColors.FromColor(Designer.ceAppearanceAxisInterlacedGradientEndColor.ColorValue);
  if Sender = Designer.ceAppearanceAxisInterlacedPattern then
  begin
    AAxisAppearance.InterlacedFillOptions.Color2 := TdxAlphaColors.FromColor(Designer.ceAppearanceAxisInterlacedPattern.ColorValue);
    Designer.InitializeHatchStyles(Designer.icbAppearanceAxisInterlacedStyle, AAxisAppearance.InterlacedFillOptions.ActualColor, AAxisAppearance.InterlacedFillOptions.ActualColor2);
  end;
  if Sender = Designer.cbAppearanceAxisInterlacedMode then
    AAxisAppearance.InterlacedFillOptions.Mode := TdxFillOptionsMode(Designer.cbAppearanceAxisInterlacedMode.ItemIndex);
  if Sender = Designer.cbAppearanceAxisInterlacedGradient then
    AAxisAppearance.InterlacedFillOptions.GradientMode := TdxFillOptionsGradientMode(Designer.cbAppearanceAxisInterlacedGradient.ItemIndex);
  if Sender = Designer.icbAppearanceAxisInterlacedStyle then
    AAxisAppearance.InterlacedFillOptions.HatchStyle := TdxFillOptionsHatchStyle(Designer.icbAppearanceAxisInterlacedStyle.ItemIndex);
  if Sender = Designer.iAppearanceAxisInterlacedTexture then
    if Designer.iAppearanceAxisInterlacedTexture.Picture = nil then
      AAxisAppearance.InterlacedFillOptions.Texture.Assign(nil)
    else
      AAxisAppearance.InterlacedFillOptions.Texture.Assign(Designer.iAppearanceAxisInterlacedTexture.Picture.Graphic);

  if Sender = Designer.seAppearanceAxisTicksThickness then
    AAxis.Ticks.Thickness := Designer.CustomizedScaleFactor.ApplyF(Designer.seAppearanceAxisTicksThickness.Value);
  if Sender = Designer.seAppearanceAxisTicksMinorThickness then
    AAxis.Ticks.MinorThickness := Designer.CustomizedScaleFactor.ApplyF(Designer.seAppearanceAxisTicksMinorThickness.Value);
  if Sender = Designer.seAppearanceAxisTicksLength then
    AAxis.Ticks.Length := Designer.CustomizedScaleFactor.Apply(Designer.seAppearanceAxisTicksLength.Value);
  if Sender = Designer.seAppearanceAxisTicksMinorLength then
    AAxis.Ticks.MinorLength := Designer.CustomizedScaleFactor.Apply(Designer.seAppearanceAxisTicksMinorLength.Value);

  if Sender = Designer.lcbiAxisTicksVisible then
    AAxis.Ticks.Visible := Designer.lcbiAxisTicksVisible.Checked;
  if Sender = Designer.lcbiAxisTicksMinorVisible then
    AAxis.Ticks.MinorVisible := Designer.lcbiAxisTicksMinorVisible.Checked;
  if Sender = Designer.cbAxisTicksCrossKind then
    AAxis.Ticks.CrossKind := TdxChartAxisTicksCrossKind(Designer.cbAxisTicksCrossKind.ItemIndex);
  if Sender = Designer.cbAxisTicksLabelAlignment then
    AAxis.Ticks.LabelAlignment := TdxAlignment(Designer.cbAxisTicksLabelAlignment.ItemIndex);
  if Sender = Designer.cbAxisTicksMinorCrossKind then
    AAxis.Ticks.MinorCrossKind := TdxChartAxisTicksCrossKind(Designer.cbAxisTicksMinorCrossKind.ItemIndex);

  inherited ApplyChangedValueToChart(Sender);
end;

procedure TAxisNodeObject.DoToggleVisibility;
begin
  ActualVisible := not ActualVisible;
end;

procedure TAxisNodeObject.DoUpdateAppearanceOptions(
  AAppearance: TdxChartCustomAppearanceAccess);
var
  AAxisAppearance: TdxChartAxisAppearanceAccess;
  AAxis: TdxChartCustomAxisAccess;
begin
  inherited DoUpdateAppearanceOptions(AAppearance);
  AAxisAppearance := TdxChartAxisAppearanceAccess(AAppearance);
  AAxis := TdxChartCustomAxisAccess(Axis);
  Designer.lgAppearanceAxis.Visible := True;
  Designer.lgAppearanceAxisTicks.Visible := True;
  Designer.lgAppearanceAxisMinorTicks.Visible := True;
  Designer.lgAppearanceAxisInterlaced.Visible := True;

  Designer.ceAppearanceAxisColor.EditValue := TdxAlphaColors.ToColor(AAxisAppearance.ActualPenColor);
  Designer.seAppearanceAxisThickness.Value := Designer.CustomizedScaleFactor.RevertF(AAxisAppearance.Thickness);

  AAxis.Interlaced := Designer.lcbiAxisInterlaced.Checked;
  Designer.ceAppearanceAxisInterlacedColor.ColorValue := TdxAlphaColors.ToColor(AAxisAppearance.InterlacedFillOptions.ActualColor);
  Designer.ceAppearanceAxisInterlacedGradientBeginColor.ColorValue := TdxAlphaColors.ToColor(AAxisAppearance.InterlacedFillOptions.ActualColor);
  Designer.ceAppearanceAxisInterlacedGradientEndColor.ColorValue := TdxAlphaColors.ToColor(AAxisAppearance.InterlacedFillOptions.ActualColor2);
  Designer.ceAppearanceAxisInterlacedPattern.ColorValue := TdxAlphaColors.ToColor(AAxisAppearance.InterlacedFillOptions.ActualColor2);
  Designer.cbAppearanceAxisInterlacedMode.ItemIndex := Ord(AAxisAppearance.InterlacedFillOptions.Mode);
  Designer.cbAppearanceAxisInterlacedGradient.ItemIndex := Ord(AAxisAppearance.InterlacedFillOptions.GradientMode);
  Designer.icbAppearanceAxisInterlacedStyle.ItemIndex := Ord(AAxisAppearance.InterlacedFillOptions.HatchStyle);
  Designer.iAppearanceAxisInterlacedTexture.Picture.Assign(AAxisAppearance.InterlacedFillOptions.Texture);

  Designer.InitializeHatchStyles(Designer.icbAppearanceAxisInterlacedStyle,
    AAxisAppearance.InterlacedFillOptions.ActualColor, AAxisAppearance.InterlacedFillOptions.ActualColor2);

  Designer.seAppearanceAxisTicksThickness.Value := Designer.CustomizedScaleFactor.RevertF(AAxis.Ticks.Thickness);
  Designer.seAppearanceAxisTicksMinorThickness.Value := Designer.CustomizedScaleFactor.RevertF(AAxis.Ticks.MinorThickness);
  Designer.seAppearanceAxisTicksLength.Value := Designer.CustomizedScaleFactor.RevertF(AAxis.Ticks.Length);
  Designer.seAppearanceAxisTicksMinorLength.Value := Designer.CustomizedScaleFactor.RevertF(AAxis.Ticks.MinorLength);
end;

procedure TAxisNodeObject.DoUpdateOptionsFromChart;
var
  AAxis: TdxChartCustomAxisAccess;
begin
  AAxis := TdxChartCustomAxisAccess(Axis);
  VarType := AAxis.GetValueType;
  Designer.lgOptionsGeneral.Parent := Designer.lgAxisGeneral;
  Designer.lgOptionsGeneral.Index := 0;

  Designer.lcbiAxisVisible.Checked := ActualVisible;
  Designer.lcbiAxisInterlaced.Checked := AAxis.Interlaced;
  Designer.lcbiAxisReverse.Checked := AAxis.Reverse;
  Designer.cbAxisAlignment.ItemIndex := Ord(AAxis.Alignment);
  Designer.seAxisMinorCount.EditValue := AAxis.MinorCount;

  Designer.lcbiAxisTicksVisible.Checked := AAxis.Ticks.Visible;
  Designer.lcbiAxisTicksMinorVisible.Checked := AAxis.Ticks.MinorVisible;
  Designer.cbAxisTicksCrossKind.ItemIndex:= Ord(AAxis.Ticks.CrossKind);
  Designer.cbAxisTicksLabelAlignment.ItemIndex:= Ord(AAxis.Ticks.LabelAlignment);
  Designer.cbAxisTicksMinorCrossKind.ItemIndex:= Ord(AAxis.Ticks.MinorCrossKind);

  UpdateRangeValues;

  inherited DoUpdateOptionsFromChart;
end;

procedure TAxisNodeObject.DoUpdateOptionStates;
var
  AAppearance: TdxChartAxisAppearance;
  AIsInterlacedEnabled: Boolean;
  AAxis: TdxChartCustomAxisAccess;
begin
  AAxis := TdxChartCustomAxisAccess(Axis);

  Designer.lgAxisVisualRange.Enabled := ActualVisible and (VarType <> varEmpty);
  Designer.lgAxisWholeRange.Enabled := ActualVisible and (VarType <> varEmpty);
  Designer.liAxisSideMargin.Enabled := ActualVisible;
  Designer.lcbiAxisReverse.Enabled := ActualVisible;
  Designer.liAxisAlignment.Enabled := ActualVisible;
  Designer.liAxisMinorCount.Enabled := ActualVisible;
  Designer.lcbiAxisInterlaced.Enabled := ActualVisible;
  Designer.lgAxisTicks.Enabled := ActualVisible;

  Designer.liAxisVisualRangeMinValue.Enabled := not Designer.lcbiAxisVisualRangeAuto.Checked;
  Designer.liAxisVisualRangeMaxValue.Enabled := not Designer.lcbiAxisVisualRangeAuto.Checked;
  Designer.liAxisWholeRangeMinValue.Enabled := not Designer.lcbiAxisWholeRangeAuto.Checked;
  Designer.liAxisWholeRangeMaxValue.Enabled := not Designer.lcbiAxisWholeRangeAuto.Checked;

  AAppearance := TdxChartCustomAxisAccess(Axis).Appearance;
  Designer.liAppearanceAxisInterlacedColor.Visible := AAppearance.InterlacedFillOptions.Mode in [TdxFillOptionsMode.Solid, TdxFillOptionsMode.Hatch];
  Designer.liAppearanceAxisInterlacedGradientEndColor.Visible := AAppearance.InterlacedFillOptions.Mode = TdxFillOptionsMode.Gradient;
  Designer.liAppearanceAxisInterlacedGradientBeginColor.Visible := AAppearance.InterlacedFillOptions.Mode = TdxFillOptionsMode.Gradient;
  Designer.liAppearanceAxisInterlacedPattern.Visible := AAppearance.InterlacedFillOptions.Mode = TdxFillOptionsMode.Hatch;
  Designer.liAppearanceAxisInterlacedGradient.Visible := AAppearance.InterlacedFillOptions.Mode = TdxFillOptionsMode.Gradient;
  Designer.liAppearanceAxisInterlacedStyle.Visible := AAppearance.InterlacedFillOptions.Mode = TdxFillOptionsMode.Hatch;
  Designer.liAppearanceAxisInterlacedTexture.Visible := AAppearance.InterlacedFillOptions.Mode = TdxFillOptionsMode.Texture;

  AIsInterlacedEnabled := TdxChartCustomAxisAccess(Axis).Interlaced;
  Designer.liAppearanceAxisInterlacedMode.Enabled := AIsInterlacedEnabled;
  Designer.liAppearanceAxisInterlacedColor.Enabled := AIsInterlacedEnabled;
  Designer.liAppearanceAxisInterlacedGradientEndColor.Enabled := AIsInterlacedEnabled;
  Designer.liAppearanceAxisInterlacedGradientBeginColor.Enabled := AIsInterlacedEnabled;
  Designer.liAppearanceAxisInterlacedPattern.Enabled := AIsInterlacedEnabled;
  Designer.liAppearanceAxisInterlacedGradient.Enabled := AIsInterlacedEnabled;
  Designer.liAppearanceAxisInterlacedStyle.Enabled := AIsInterlacedEnabled;
  Designer.liAppearanceAxisInterlacedTexture.Enabled := AIsInterlacedEnabled;

  Designer.liAxisTicksCrossKind.Enabled := AAxis.Ticks.Visible;
  Designer.liAxisTicksLabelAlignment.Enabled := AAxis.Ticks.Visible;
  Designer.liAxisTicksMinorCrossKind.Enabled := AAxis.Ticks.MinorVisible;
  Designer.liAppearanceAxisTicksThickness.Enabled := AAxis.Ticks.Visible;
  Designer.liAppearanceAxisTicksLength.Enabled := AAxis.Ticks.Visible;
  Designer.liAppearanceAxisTicksMinorThickness.Enabled := AAxis.Ticks.MinorVisible;
  Designer.liAppearanceAxisTicksMinorLength.Enabled := AAxis.Ticks.MinorVisible;

  inherited DoUpdateOptionStates;
end;

function TAxisNodeObject.GetActualVisible: Boolean;
begin
  Result := TdxChartCustomAxisAccess(Axis).ActuallyVisible;
end;

function TAxisNodeObject.GetAxis: TdxChartCustomAxis;
begin
  Result := TdxChartCustomAxis(&Object);
end;

function TAxisNodeObject.GetCommandIconHint(AIndex: Integer): string;
begin
  Result := cxGetResourceString(@sdxChartDesignerChangeVisibilityHint);
end;

function TAxisNodeObject.GetCommandIconImageIndex(AIndex: Integer): Integer;
begin
  Result := VisibilityCommandIconIndex[ActualVisible];
end;

function TAxisNodeObject.GetCommandIconCount: Integer;
begin
  Result := 1;
end;

function TAxisNodeObject.GetOptionsGroup: TdxLayoutGroup;
begin
  Result := Designer.lgAxis;
end;

function TAxisNodeObject.GetRangeMaxValue: Variant;
var
  AViewData: TdxChartAxisXViewDataAccess;
begin
  if TdxChartCustomAxisAccess(Axis).IsNumeric then
    Result := TdxChartRangeAccess(TdxChartCustomAxisAccess(Axis).Range).RealWholeRange.Max
  else
    if TdxChartCustomAxisAccess(Axis).ViewData is TdxChartAxisXViewData then
    begin
      AViewData := TdxChartAxisXViewDataAccess(TdxChartCustomAxisAccess(Axis).ViewData);
      Result := AViewData.GetValueAsText(AViewData.GetMax);
    end
    else
     raise EdxChartException.Create(Format('%s: Invalid of Axis %s ViewData class !!!',
       [TdxChartCustomAxisAccess(Axis).ViewData.ClassName, Axis.ClassName]));
end;

function TAxisNodeObject.GetRangeMinValue: Variant;
var
  AViewData: TdxChartAxisXViewDataAccess;
begin
  if TdxChartCustomAxisAccess(Axis).IsNumeric then
    Result := TdxChartRangeAccess(TdxChartCustomAxisAccess(Axis).Range).RealWholeRange.Min
  else
    if TdxChartCustomAxisAccess(Axis).ViewData is TdxChartAxisXViewData then
    begin
      AViewData := TdxChartAxisXViewDataAccess(TdxChartCustomAxisAccess(Axis).ViewData);
      Result := AViewData.GetValueAsText(AViewData.GetMin);
    end
    else
     raise EdxChartException.Create(Format('%s: Invalid of Axis %s ViewData class !!!',
       [TdxChartCustomAxisAccess(Axis).ViewData.ClassName, Axis.ClassName]));
end;

function TAxisNodeObject.IsAppearanceEnabled: Boolean;
begin
  Result := inherited IsAppearanceEnabled and ActualVisible;
end;

function TAxisNodeObject.IsEnabled: Boolean;
begin
  Result := ActualVisible;
end;

procedure TAxisNodeObject.SetActualVisible(const Value: Boolean);
begin
  if ActualVisible <> Value then
    TdxChartCustomAxisAccess(Axis).Visible := Value;
end;

procedure TAxisNodeObject.SetVarType(const Value: TVarType);
begin
  if VarType <> Value then
  begin
    FVarType := Value;
    UpdateRangeEditors;
  end;
end;

procedure TAxisNodeObject.UpdateRangeEditors;

  function CreateSpinEdit: TcxSpinEdit;
  begin
    Result := TcxSpinEdit.Create(Designer);
    Result.Properties.ValueType := vtFloat;
    Result.InitializeFormats;
    Result.Properties.OnChange := Designer.OptionDisplayValueChange;
    Result.Properties.OnEditValueChanged := Designer.OptionEditValueChanged;
    case VarType of
      varSmallint:
        begin
          Result.Properties.MinValue := Low(SmallInt);
          Result.Properties.MaxValue := High(SmallInt);
        end;
      varInteger:
        begin
          Result.Properties.MinValue := MinInt;
          Result.Properties.MaxValue := MaxInt;
        end;
      varShortInt:
        begin
          Result.Properties.MinValue := Low(ShortInt);
          Result.Properties.MaxValue := High(ShortInt);
        end;
      varByte:
        begin
          Result.Properties.MinValue := Low(Byte);
          Result.Properties.MaxValue := High(Byte);
        end;
      varWord:
        begin
          Result.Properties.MinValue := Low(Word);
          Result.Properties.MaxValue := High(Word);
        end;
      varLongWord:
        begin
          Result.Properties.MinValue := Low(LongWord);
          Result.Properties.MaxValue := High(LongWord);
        end;
      varInt64:
        begin
          Result.Properties.MinValue := Low(Int64);
          Result.Properties.MaxValue := High(Int64);
        end;
      varUInt64:
        begin
          Result.Properties.MinValue := Low(UInt64);
          Result.Properties.MaxValue := High(UInt64);
        end;
    end;
  end;

  function CreateCurrencyEdit: TcxCurrencyEdit;
  begin
    Result := TcxCurrencyEdit.Create(Designer);
    Result.Properties.OnEditValueChanged := Designer.OptionEditValueChanged;
  end;

  function CreateDateEdit: TcxDateEdit;
  begin
    Result := TcxDateEdit.Create(Designer);
    Result.Properties.OnEditValueChanged := Designer.OptionEditValueChanged;
  end;

  function CreateComboBox: TcxComboBox;
  var
    AAxis: TdxChartCustomAxisAccess;
  begin
    Result := TcxComboBox.Create(Designer);
    AAxis := TdxChartCustomAxisAccess(Axis);
    TdxChartCustomDiagramAccess(AAxis.Diagram).ViewData.Calculate;
    AAxis.PopulateValues(Result.Properties.Items);
    Result.Properties.OnEditValueChanged := Designer.OptionEditValueChanged;
  end;

  function CreateTextEdit: TcxTextEdit;
  begin
    Result := TcxTextEdit.Create(Designer);
  end;

  function CreateEditor: TcxCustomEdit;
  begin
    case VarType of
      varSmallint, varInteger, varSingle, varDouble,
      varShortInt, varByte, varWord, varLongWord,
      varInt64, varUInt64:
        Result := CreateSpinEdit;
      varCurrency:
        Result := CreateCurrencyEdit;
      varDate:
        Result := CreateDateEdit;
      varOleStr, varString, varUString:
        Result := CreateComboBox;
    else
      Result := CreateTextEdit;
    end;
  end;

  procedure UpdateEditor(ALayoutItem: TdxLayoutItem);
  var
    AOldEdit: TControl;
    AEdit: TcxCustomEdit;
  begin
    AOldEdit := ALayoutItem.Control;
    AEdit := CreateEditor;
    ALayoutItem.Control := AEdit;
    AOldEdit.Free;
  end;

begin
  UpdateEditor(Designer.liAxisVisualRangeMinValue);
  UpdateEditor(Designer.liAxisVisualRangeMaxValue);
  UpdateEditor(Designer.liAxisWholeRangeMinValue);
  UpdateEditor(Designer.liAxisWholeRangeMaxValue);
end;

procedure TAxisNodeObject.UpdateRangeValues;

  function GetValue(const Value: Variant): Variant;
  begin
    if VarIsSoftEmpty(Value) or VarIsSoftNull(Value) then
      Result := Null
    else
      Result := Value;
  end;

  procedure UpdateEditValue(AEdit:TcxCustomEdit; const AValue: Variant; const ARange: TdxChartDataRange);
  begin
    if AEdit is TcxSpinEdit then
    begin
      TcxSpinEdit(AEdit).Properties.MinValue := ARange.Min;
      TcxSpinEdit(AEdit).Properties.MaxValue := ARange.Max;
    end;
    AEdit.EditValue := AValue;
  end;

var
  ARange: TdxChartRangeAccess;
begin
  ARange := TdxChartRangeAccess(TdxChartCustomAxisAccess(Axis).Range);
  Designer.seAxisSideMargin.Value := ARange.SideMarginMax;

  Designer.lcbiAxisVisualRangeAuto.Checked := ARange.IsAutoVisibleRange;
  Designer.lcbiAxisWholeRangeAuto.Checked := ARange.IsAutoWholeRange;

  UpdateEditValue(TcxCustomEdit(Designer.liAxisVisualRangeMinValue.Control),GetValue(ARange.VisibleMin), ARange.RealWholeRange);
  UpdateEditValue(TcxCustomEdit(Designer.liAxisVisualRangeMaxValue.Control),GetValue(ARange.VisibleMax), ARange.RealWholeRange);
  TcxCustomEdit(Designer.liAxisWholeRangeMinValue.Control).EditValue := GetValue(ARange.WholeMin);
  TcxCustomEdit(Designer.liAxisWholeRangeMaxValue.Control).EditValue := GetValue(ARange.WholeMax);
end;

{ TAxisTitleNodeObject }

procedure TAxisTitleNodeObject.ApplyChangedValueToChart(Sender: TObject);
begin
  if Sender = Designer.cbTitleAxisPosition then
    Title.Position := TdxChartAxisTitlePosition(Designer.cbTitleAxisPosition.ItemIndex);
  inherited ApplyChangedValueToChart(Sender);
end;

procedure TAxisTitleNodeObject.DoUpdateOptionsFromChart;
begin
  Designer.cbTitleAxisPosition.ItemIndex := Ord(Title.Position);
  inherited DoUpdateOptionsFromChart;
end;

function TAxisTitleNodeObject.GetTitle: TdxChartAxisTitle;
begin
  Result := TdxChartAxisTitle(inherited Title);
end;

{ TAxisXNodeObject }

function TAxisXNodeObject.DoGetCaption: string;
begin
  Result := cxGetResourceString(@sdxChartDesignerPrimaryAxisXCaption);
end;

{ TAxisYNodeObject }

function TAxisYNodeObject.DoGetCaption: string;
begin
  Result := cxGetResourceString(@sdxChartDesignerPrimaryAxisYCaption);
end;

{ TAxisValueLabelsNodeObject }

procedure TAxisValueLabelsNodeObject.CommandIconClick(AIndex: Integer);
begin
  ToggleVisibility;
end;

procedure TAxisValueLabelsNodeObject.ApplyChangedValueToChart(Sender: TObject);
begin
  if Sender = Designer.lcbiAxisValueLabelsVisible then
    ActualVisible := Designer.lcbiAxisValueLabelsVisible.Checked;
  if Sender = Designer.cbAxisValueLabelsAlignment then
    ValueLabels.TextAlignment := TdxAlignment(Designer.cbAxisValueLabelsAlignment.ItemIndex);
  if Sender = Designer.cbAxisValueLabelsPosition then
    ValueLabels.Position := TdxChartAxisValueLabelPosition(Designer.cbAxisValueLabelsPosition.ItemIndex);
  if Sender = Designer.seAxisValueLabelsMaxLineCount then
    ValueLabels.MaxLineCount := Designer.seAxisValueLabelsMaxLineCount.EditValue;
  if Sender = Designer.seAxisValueLabelsMaxWidth then
    ValueLabels.MaxWidth := Designer.CustomizedScaleFactor.ApplyF(Designer.seAxisValueLabelsMaxWidth.EditValue);
  if Sender = Designer.seAxisValueLabelsAngle then
    ValueLabels.Angle := Designer.seAxisValueLabelsAngle.EditValue;
  if Sender = Designer.seAxisValueLabelsResolveOverlappingIndent then
    ValueLabels.ResolveOverlappingIndent := Designer.CustomizedScaleFactor.ApplyF(Designer.seAxisValueLabelsResolveOverlappingIndent.EditValue);
  inherited ApplyChangedValueToChart(Sender);
end;

function TAxisValueLabelsNodeObject.DoGetCaption: string;
begin
  Result := cxGetResourceString(@sdxChartDesignerValueLabelsCaption);
end;

procedure TAxisValueLabelsNodeObject.DoToggleVisibility;
begin
  ActualVisible := not ActualVisible;
end;

procedure TAxisValueLabelsNodeObject.DoUpdateOptionsFromChart;
begin
  Designer.lgOptionsGeneral.Parent := Designer.lgAxisValueLabelsGeneral;
  Designer.lgOptionsGeneral.Index := 0;

  Designer.lcbiAxisValueLabelsVisible.Checked := ValueLabels.Visible;
  Designer.cbAxisValueLabelsAlignment.ItemIndex := Ord(ValueLabels.TextAlignment);
  Designer.cbAxisValueLabelsPosition.ItemIndex := Ord(ValueLabels.Position);
  Designer.seAxisValueLabelsMaxLineCount.EditValue := ValueLabels.MaxLineCount;
  Designer.seAxisValueLabelsMaxWidth.EditValue := Designer.CustomizedScaleFactor.RevertF(ValueLabels.MaxWidth);
  Designer.seAxisValueLabelsAngle.EditValue := ValueLabels.Angle;
  Designer.seAxisValueLabelsResolveOverlappingIndent.EditValue := Designer.CustomizedScaleFactor.RevertF(ValueLabels.ResolveOverlappingIndent);
  inherited DoUpdateOptionsFromChart;
end;

procedure TAxisValueLabelsNodeObject.DoUpdateOptionStates;
begin
  Designer.liAxisValueLabelsAlignment.Enabled := IsEnabled;
  Designer.liAxisValueLabelsPosition.Enabled := IsEnabled;
  Designer.liAxisValueLabelsMaxLineCount.Enabled := IsEnabled;
  Designer.liAxisValueLabelsMaxWidth.Enabled := IsEnabled;
  Designer.liAxisValueLabelsAngle.Enabled := IsEnabled;
  Designer.lgAxisValueLabelsResolveOverlapping.Enabled := IsEnabled;

  inherited DoUpdateOptionStates;
end;

function TAxisValueLabelsNodeObject.GetActualVisible: Boolean;
begin
  Result := ValueLabels.Visible;
end;

function TAxisValueLabelsNodeObject.GetValueLabels: TdxChartAxisValueLabels;
begin
  Result := TdxChartAxisValueLabels(inherited &Object);
end;

function TAxisValueLabelsNodeObject.GetCommandIconCount: Integer;
begin
  Result := 1;
end;

function TAxisValueLabelsNodeObject.GetCommandIconHint(AIndex: Integer): string;
begin
  Result := cxGetResourceString(@sdxChartDesignerChangeVisibilityHint);
end;

function TAxisValueLabelsNodeObject.GetCommandIconImageIndex(
  AIndex: Integer): Integer;
begin
  if AIndex = 0 then
    Result := VisibilityCommandIconIndex[ActualVisible]
  else
    Result := inherited GetCommandIconImageIndex(AIndex);
end;

function TAxisValueLabelsNodeObject.GetImageIndex: Integer;
begin
  Result := 15;
end;

function TAxisValueLabelsNodeObject.GetOptionsGroup: TdxLayoutGroup;
begin
  Result := Designer.lgAxisValueLabels;
end;

function TAxisValueLabelsNodeObject.IsAppearanceEnabled: Boolean;
begin
  Result := inherited IsAppearanceEnabled and IsEnabled;
end;

function TAxisValueLabelsNodeObject.IsEnabled: Boolean;
begin
  Result := ActualVisible;
end;

procedure TAxisValueLabelsNodeObject.SetActualVisible(const Value: Boolean);
begin
  ValueLabels.Visible := Value;
end;

{ TAxisGridlinesNodeObject }

procedure TAxisGridlinesNodeObject.CommandIconClick(AIndex: Integer);
begin
  ToggleVisibility;
end;

procedure TAxisGridlinesNodeObject.ApplyChangedValueToChart(Sender: TObject);
begin
  if Sender = Designer.lcbiAxisGridlines then
    ActualVisible := Designer.lcbiAxisGridlines.Checked;
  if Sender = Designer.lcbiAxisGridlinesMinorVisible then
    Gridlines.MinorVisible := Designer.lcbiAxisGridlinesMinorVisible.Checked;
  if Sender = Designer.ceAppearanceAxisGridlinesColor then
    Gridlines.Color := TdxAlphaColors.FromColor(Designer.ceAppearanceAxisGridlinesColor.ColorValue);
  if Sender = Designer.ceAppearanceAxisGridlinesMinorColor then
    Gridlines.MinorColor := TdxAlphaColors.FromColor(Designer.ceAppearanceAxisGridlinesMinorColor.ColorValue);
  if Sender = Designer.cbAppearanceAxisGridlinesStyle then
    Gridlines.Style := TdxStrokeStyle(Designer.cbAppearanceAxisGridlinesStyle.ItemIndex);
  if Sender = Designer.cbAppearanceAxisGridlinesMinorStyle then
    Gridlines.MinorStyle := TdxStrokeStyle(Designer.cbAppearanceAxisGridlinesMinorStyle.ItemIndex);
  if Sender = Designer.seAppearanceAxisGridlinesThickness then
    Gridlines.Thickness := Designer.CustomizedScaleFactor.ApplyF(Designer.seAppearanceAxisGridlinesThickness.EditValue);
  if Sender = Designer.seAppearanceAxisGridlinesMinorThickness then
    Gridlines.MinorThickness := Designer.CustomizedScaleFactor.ApplyF(Designer.seAppearanceAxisGridlinesMinorThickness.EditValue);

  inherited ApplyChangedValueToChart(Sender);
end;

function TAxisGridlinesNodeObject.DoGetCaption: string;
begin
  Result := cxGetResourceString(@sdxChartControlDesignerGridlinesCaption);
end;

procedure TAxisGridlinesNodeObject.DoToggleVisibility;
begin
  ActualVisible := not ActualVisible;
end;

procedure TAxisGridlinesNodeObject.DoUpdateAppearanceOptions(
  AAppearance: TdxChartCustomAppearanceAccess);
begin
  inherited DoUpdateAppearanceOptions(AAppearance);
  Designer.lgAppearanceAxisGridlines.Visible := True;
  Designer.lgAppearanceAxisMinorGridlines.Visible := True;

  Designer.ceAppearanceAxisGridlinesColor.ColorValue := TdxAlphaColors.ToColor(Gridlines.PaintColor);
  Designer.ceAppearanceAxisGridlinesMinorColor.ColorValue := TdxAlphaColors.ToColor(Gridlines.PaintMinorColor);
  Designer.cbAppearanceAxisGridlinesStyle.ItemIndex := Ord(Gridlines.Style);
  Designer.cbAppearanceAxisGridlinesMinorStyle.ItemIndex := Ord(Gridlines.MinorStyle);
  Designer.seAppearanceAxisGridlinesThickness.EditValue := Designer.CustomizedScaleFactor.RevertF(Gridlines.Thickness);
  Designer.seAppearanceAxisGridlinesMinorThickness.EditValue := Designer.CustomizedScaleFactor.RevertF(Gridlines.MinorThickness);
end;

procedure TAxisGridlinesNodeObject.DoUpdateOptionsFromChart;
begin
  Designer.lgOptionsGeneral.Parent := Designer.lgAxisGridlinesGeneral;
  Designer.lgOptionsGeneral.Index := 0;
  Designer.lcbiAxisGridlines.Checked := Gridlines.Visible;
  Designer.lcbiAxisGridlinesMinorVisible.Checked := Gridlines.MinorVisible;
  inherited DoUpdateOptionsFromChart;
end;

procedure TAxisGridlinesNodeObject.DoUpdateOptionStates;
begin
  Designer.lcbiAxisGridlines.Enabled := True;
  Designer.lcbiAxisGridlinesMinorVisible.Enabled := True;
  Designer.liAppearanceAxisGridlinesColor.Enabled := Gridlines.Visible;
  Designer.liAppearanceAxisGridlinesStyle.Enabled := Gridlines.Visible;
  Designer.liAppearanceAxisGridlinesThickness.Enabled := Gridlines.Visible;
  Designer.liAppearanceAxisGridlinesMinorColor.Enabled := Gridlines.MinorVisible;
  Designer.liAppearanceAxisGridlinesMinorStyle.Enabled := Gridlines.MinorVisible;
  Designer.liAppearanceAxisGridlinesMinorThickness.Enabled := Gridlines.MinorVisible;
  inherited DoUpdateOptionStates;
end;

function TAxisGridlinesNodeObject.GetActualVisible: Boolean;
begin
  Result := Gridlines.Visible;
end;

function TAxisGridlinesNodeObject.GetGridlines: TdxChartAxisGridlines;
begin
  Result := TdxChartAxisGridlines(inherited &Object);
end;

function TAxisGridlinesNodeObject.GetCommandIconCount: Integer;
begin
  Result := 1;
end;

function TAxisGridlinesNodeObject.GetCommandIconHint(AIndex: Integer): string;
begin
  Result := cxGetResourceString(@sdxChartDesignerChangeVisibilityHint);
end;

function TAxisGridlinesNodeObject.GetCommandIconImageIndex(
  AIndex: Integer): Integer;
begin
  if AIndex = 0 then
    Result := VisibilityCommandIconIndex[ActualVisible]
  else
    Result := inherited GetCommandIconImageIndex(AIndex);
end;

function TAxisGridlinesNodeObject.GetImageIndex: Integer;
begin
  Result := 14;
end;

function TAxisGridlinesNodeObject.GetOptionsGroup: TdxLayoutGroup;
begin
  Result := Designer.lgAxisGridlines;
end;

function TAxisGridlinesNodeObject.IsAppearanceVisible: Boolean;
begin
  Result := True;
end;

function TAxisGridlinesNodeObject.IsEnabled: Boolean;
begin
  Result := ActualVisible;
end;

procedure TAxisGridlinesNodeObject.SetActualVisible(const Value: Boolean);
begin
  Gridlines.Visible := Value;
end;

{ TdxChartDesignerTreeViewNodeData }

constructor TdxChartDesignerTreeViewNodeData.Create(AObject: TPersistent);
begin
  inherited Create;
  FObject := AObject;
end;

function TdxChartDesignerTreeViewNodeData.GetCommandIconHint(
  AIndex: Integer): string;
begin
  Result := '';
end;

function TdxChartDesignerTreeViewNodeData.GetCommandIconImageIndex(
  AIndex: Integer): Integer;
begin
  Result := -1;
end;

procedure TdxChartDesignerTreeViewNodeData.CommandIconClick(AIndex: Integer);
begin
// do nothing
end;

function TdxChartDesignerTreeViewNodeData.GetCommandIconCount: Integer;
begin
  Result := 0;
end;

function TdxChartDesignerTreeViewNodeData.IsValid: Boolean;
begin
  Result := FObject <> nil;
end;

procedure TdxChartDesignerTreeViewNodeData.SetDirty;
begin
  FObject := nil;
end;

function TdxChartDesignerTreeViewNodeData.CanDrag: Boolean;
begin
  Result := False;
end;

function TdxChartDesignerTreeViewNodeData.CanDrop(const P: TPoint; AHitNodeObject: TdxChartDesignerTreeViewNodeData; var AAfter: Boolean): Boolean;
begin
  Result := False;
end;

procedure TdxChartDesignerTreeViewNodeData.Drop(const P: TPoint; AHitNodeObject: TdxChartDesignerTreeViewNodeData);
begin
// do nothing
end;

{ TdxChartDesignerTreeViewNode }

function TdxChartDesignerTreeViewNode.GetData: TdxChartDesignerTreeViewNodeData;
begin
  Result := TdxChartDesignerTreeViewNodeData(inherited Data);
end;

procedure TdxChartDesignerTreeViewNode.SetData(
  const Value: TdxChartDesignerTreeViewNodeData);
begin
  inherited Data := Value;
end;

function TdxChartDesignerTreeViewNode.IsValid: Boolean;
begin
  Result := (Data <> nil) and Data.IsValid;
end;

{ TdxChartDesignerTreeViewHitTest }

procedure TdxChartDesignerTreeViewHitTest.Reset;
begin
  inherited Reset;
  FHitAtCommandIcon := False;
  FHitCommandIconIndex := -1;
  FHitCommandIconBounds := cxNullRect;
end;

function TdxChartDesignerTreeViewHitTest.GetHitData: TdxChartDesignerTreeViewNodeData;
begin
  Result := TdxChartDesignerTreeViewNode(HitObject).Data;
end;

{ TdxChartDesignerDragHelper }

constructor TdxChartDesignerDragHelper.Create(
  ATreeView: TdxChartDesignerTreeView);
begin
  inherited Create;
  FTreeView := ATreeView;
  FArrowLeft := TcxDragAndDropArrow.Create(True);
  FArrowRight := TcxDragAndDropArrow.Create(True);
  FAutoExpandingTimer := TcxTimer.Create(nil);
  FAutoExpandingTimer.Enabled := False;
  FAutoExpandingTimer.Interval := AutoExpandInterval;
  FAutoExpandingTimer.OnTimer := AutoExpandingTimerHandler;
end;

destructor TdxChartDesignerDragHelper.Destroy;
begin
  FreeAndNil(FAutoExpandingTimer);
  FreeAndNil(FAutoScrollHelper);
  FreeAndNil(FArrowLeft);
  FreeAndNil(FArrowRight);
  inherited Destroy;
end;

procedure TdxChartDesignerDragHelper.StartDrag;
begin
  if TreeView.HitTest.HitAtText and TreeView.HitTest.HitData.CanDrag then
  begin
    RecreateAutoScrollHelper;
    CalculateArrows;
    FNode := TdxChartDesignerTreeViewNode(TreeView.HitTest.HitObjectAsNode);
    FStartPoint := TreeView.HitTest.HitPoint;
  end;
end;

procedure TdxChartDesignerDragHelper.AutoExpandingTimerHandler(Sender: TObject);
var
  AHitTest: TdxTreeViewHitTest;
  P: TPoint;
begin
  FAutoExpandingTimer.Enabled := False;
  P := GetMouseCursorPos;
  P := TreeView.ScreenToClient(P);
  AHitTest := TreeView.GetHitTestAt(P.X, P.Y);
  if AHitTest.HitAtExpandButton and (NativeInt(AHitTest.HitObjectAsNode) = FAutoExpandingTimer.Tag) and not AHitTest.HitObjectAsNode.Expanded then
    AHitTest.HitObjectAsNode.Expanded := True;
end;

procedure TdxChartDesignerDragHelper.CalculateArrows;
begin
  FArrowLeft.Init(TreeView, TreeView.ClientRect, TreeView.ClientRect, TcxArrowPlace.apLeft);
  FArrowRight.Init(TreeView, TreeView.ClientRect, TreeView.ClientRect, TcxArrowPlace.apRight);
end;

procedure TdxChartDesignerDragHelper.RecreateAutoScrollHelper;
var
  AStep: Integer;
  ASize: TSize;
begin
  FAutoScrollHelper.Free;
  AStep := TreeView.OptionsView.ItemHeight;
  ASize.Init(AStep);
  FAutoScrollHelper := TdxAutoScrollHelper.CreateScroller(TreeView, TreeView.ClientBounds, TreeView.ScaleFactor.Apply(20), 250, ASize, [TdxScrollAxis.Vertical]);
end;

procedure TdxChartDesignerDragHelper.CancelDrag;
begin
  HideArrows;
  DoCancelDrag;
  FIsDragging := False;
end;

procedure TdxChartDesignerDragHelper.DoCancelDrag;
begin
  Screen.Cursor := crDefault;
  FStartPoint := cxInvalidPoint;
  FNode := nil;
end;

procedure TdxChartDesignerDragHelper.DoDragDrop(const P: TPoint);
const
  ACursorMap: array[Boolean] of TCursor = (crNoDrop, crDrag);

  procedure ShowArrows(AAfter: Boolean);
  var
    Y: Integer;
    R: TRect;
    ADisplayRect: TRect;
    AHitNode: TdxTreeViewNode;
    ANodeViewInfo: TdxTreeViewNodeViewInfo;
  begin
    TreeView.GetNodeAtPos(P, AHitNode);
    ANodeViewInfo := TreeView.ViewInfo.NodeViewInfo;
    ANodeViewInfo.SetData(AHitNode);
    try
      R := ANodeViewInfo.SelectionRect;
      ADisplayRect := AHitNode.DisplayRect(False);
      R.MoveToTop(ADisplayRect.Top);
      R.Offset(IfThen(TreeView.UseRightToLeftAlignment, -1, 1) * (ANodeViewInfo.LevelOffset - TreeView.ViewInfo.ViewPort.X), 0);
      R.Intersect(TreeView.ClientBounds);
    finally
      ANodeViewInfo.SetData(nil);
    end;
    R.Offset(TreeView.ClientToScreen(cxNullPoint));
    if AAfter then
      Y := R.Bottom
    else
      Y := R.Top;
    Y := Y - FArrowLeft.Height div 2;
    FArrowLeft.MoveTo(TPoint.Create(R.Left, Y));
    FArrowRight.MoveTo(TPoint.Create(R.Right - FArrowRight.Width, Y));
    FArrowLeft.Show;
    FArrowRight.Show;
  end;

  procedure CheckExpanding;
  var
    AHitTest: TdxTreeViewHitTest;
    AEnabled: Boolean;
  begin
    AHitTest := TreeView.GetHitTestAt(P.X, P.Y);
    AEnabled := False;
    if AHitTest.HitAtExpandButton and not AHitTest.HitObjectAsNode.Expanded then
    begin
      FAutoExpandingTimer.Tag := NativeInt(AHitTest.HitObjectAsNode);
      AEnabled := True;
    end;
    FAutoExpandingTimer.Enabled := AEnabled;
  end;

var
  Accepted, AAfter: Boolean;
begin
  CheckExpanding;
  Accepted := CanDrop(AAfter);
  Screen.Cursor := ACursorMap[Accepted];
  if Accepted then
    ShowArrows(AAfter)
  else
    HideArrows;
end;

procedure TdxChartDesignerDragHelper.DoDrop(const P: TPoint);
var
  AHitNode: TdxTreeViewNode;
begin
  if TreeView.GetNodeAtPos(P, AHitNode) and (AHitNode <> FNode) then
    FNode.Data.Drop(P, TdxChartDesignerTreeViewNodeData(AHitNode.Data));
end;

function TdxChartDesignerDragHelper.CanDrop: Boolean;
var
  AAfter: Boolean;
begin
  Result := CanDrop(AAfter);
end;

function TdxChartDesignerDragHelper.CanDrop(var AAfter: Boolean): Boolean;
begin
  Result := TreeView.HitTest.HitAtNode and (TreeView.HitTest.HitObjectAsNode <> FNode) and
    FNode.Data.CanDrop(TreeView.HitTest.HitPoint, TreeView.HitTest.HitData, AAfter);
end;

procedure TdxChartDesignerDragHelper.DragDrop(const P: TPoint);
begin
  if IsStarting then
    FIsDragging := not IsPointInDragDetectArea(FStartPoint, P.X, P.Y);
  if FIsDragging then
  begin
    FAutoScrollHelper.CheckMousePosition(P);
    DoDragDrop(P);
  end;
end;

procedure TdxChartDesignerDragHelper.EndDrag(const P: TPoint);
begin
  if FIsDragging and CanDrop then
    DoDrop(P);
  CancelDrag;
end;

procedure TdxChartDesignerDragHelper.HideArrows;
begin
  FArrowLeft.Hide;
  FArrowRight.Hide;
end;

function TdxChartDesignerDragHelper.IsStarting: Boolean;
begin
  Result := not FIsDragging and (FNode <> nil) and not FStartPoint.IsEqual(cxInvalidPoint);
end;

{ TdxChartDesignerTreeViewHintHelper }

procedure TdxChartDesignerTreeViewHintHelper.BeginUpdate;
begin
  Inc(FLockCount);
end;

procedure TdxChartDesignerTreeViewHintHelper.EndUpdate;
begin
  Dec(FLockCount);
end;

function TdxChartDesignerTreeViewHintHelper.CanShowHint: Boolean;
begin
  Result := inherited CanShowHint and not TreeView.IsUpdateLocked and (FLockCount = 0);
end;

procedure TdxChartDesignerTreeViewHintHelper.CheckHint;
var
  AHitTest: TdxChartDesignerTreeViewHitTest;
  AHintRect: TRect;
  ATextRect: TRect;
  AText: string;
begin
  AHitTest := TreeView.HitTest;
  if AHitTest.HitAtCommandIcon then
  begin
    AText := AHitTest.HitData.GetCommandIconHint(AHitTest.HitCommandIconIndex);
    if AText <> '' then
    begin
      AHintRect := AHitTest.HitCommandIconBounds;
      if not HintAreaBounds.IsEqual(AHintRect) then
      begin
        ATextRect := TRect.Create(AHintRect.Left, AHintRect.Bottom, 200, 200);
        if TreeView.UseRightToLeftAlignment then
          ATextRect.MoveToRight(AHintRect.Right);
        DoShowHint(AHintRect, ATextRect, AText);
      end;
    end;
  end
  else
    inherited CheckHint;
end;

function TdxChartDesignerTreeViewHintHelper.GetTreeView: TdxChartDesignerTreeView;
begin
  Result := TdxChartDesignerTreeView(inherited TreeView);
end;

function TdxChartDesignerTreeViewHintHelper.UseHintHidePause: Boolean;
begin
  Result := inherited UseHintHidePause or TreeView.HitTest.HitAtCommandIcon;
end;

{ TdxChartDesignerTreeView }

constructor TdxChartDesignerTreeView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CalculateItemHeight;
  FDragHelper := CreateDragHelper;
end;

destructor TdxChartDesignerTreeView.Destroy;
begin
  FreeAndNil(FDragHelper);
  FreeAndNil(FCommandIconsChangeLink);
  inherited Destroy;
end;

procedure TdxChartDesignerTreeView.ChangeScaleEx(M, D: Integer; isDpiChange: Boolean);
begin
  inherited ChangeScaleEx(M, D, isDpiChange);
  CalculateItemHeight;
end;

procedure TdxChartDesignerTreeView.Click;
begin
  inherited Click;
  if HitTest.HitAtCommandIcon and not DragHelper.IsDragging then
  begin
    BeginUpdate;
    try
      HintHelper.CancelHint;
      HitTest.HitData.CommandIconClick(HitTest.HitCommandIconIndex);
    finally
      EndUpdate;
    end;
  end;
end;

function TdxChartDesignerTreeView.CreateHintHelper: TdxCustomTreeViewHintHelper;
begin
  Result := TdxChartDesignerTreeViewHintHelper.Create(Self);
end;

function TdxChartDesignerTreeView.CreateHitTest: TdxTreeViewHitTest;
begin
  Result := TdxChartDesignerTreeViewHitTest.Create(Self);
end;

function TdxChartDesignerTreeView.CreateViewInfo: TdxTreeViewViewInfo;
begin
  Result := TdxChartDesignerTreeViewViewInfo.Create(Self);
end;

procedure TdxChartDesignerTreeView.CalculateItemHeight;
begin
  if cxIsTouchModeEnabled then
    OptionsView.ItemHeight := dxGetTouchableSize(ScaleFactor.Apply(22), ScaleFactor);
end;

function TdxChartDesignerTreeView.GetHintHelper: TdxChartDesignerTreeViewHintHelper;
begin
  Result := TdxChartDesignerTreeViewHintHelper(inherited HintHelper);
end;

function TdxChartDesignerTreeView.GetHitTest: TdxChartDesignerTreeViewHitTest;
begin
  Result := TdxChartDesignerTreeViewHitTest(inherited HitTest);
end;

function TdxChartDesignerTreeView.GetViewInfo: TdxChartDesignerTreeViewViewInfo;
begin
  Result := TdxChartDesignerTreeViewViewInfo(inherited ViewInfo);
end;

function TdxChartDesignerTreeView.GetNodeClass: TdxTreeViewNodeClass;
begin
  Result := TdxChartDesignerTreeViewNode;
end;

procedure TdxChartDesignerTreeView.KeyDown(var Key: Word; Shift: TShiftState);
begin
  DragHelper.CancelDrag;
  inherited KeyDown(Key, Shift);
end;

procedure TdxChartDesignerTreeView.MouseDown(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
begin
  HintHelper.CancelHint;
  HintHelper.BeginUpdate;
  inherited MouseDown(Button, Shift, X, Y);
  DragHelper.CancelDrag;
  CalculateHitTest(X, Y);
  if (Button = mbLeft) and (Shift * [ssShift, ssAlt, ssCtrl] = []) and HitTest.HitAtText then
     DragHelper.StartDrag;
end;

procedure TdxChartDesignerTreeView.MouseMove(Shift: TShiftState; X: Integer; Y: Integer);
var
  APreHitAtCommandIcon: Boolean;
  APreHitCommandIconBounds: TRect;
begin
  APreHitAtCommandIcon := HitTest.HitAtCommandIcon;
  APreHitCommandIconBounds := HitTest.HitCommandIconBounds;
  inherited MouseMove(Shift, X, Y);
  DragHelper.DragDrop(TPoint.Create(X, Y));
  if not DragHelper.IsDragging then
  begin
    if APreHitAtCommandIcon <> HitTest.HitAtCommandIcon then
    begin
      if APreHitAtCommandIcon then
        InvalidateRect(APreHitCommandIconBounds, True)
      else
        InvalidateRect(HitTest.HitCommandIconBounds, True);
    end
    else if HitTest.HitAtCommandIcon and not APreHitCommandIconBounds.IsEqual(HitTest.HitCommandIconBounds) then
    begin
      if APreHitAtCommandIcon then
        InvalidateRect(APreHitCommandIconBounds, True);
      InvalidateRect(HitTest.HitCommandIconBounds, True);
    end;
  end;
end;

procedure TdxChartDesignerTreeView.MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  DragHelper.EndDrag(TPoint.Create(X, Y));
  HintHelper.EndUpdate;
end;

function TdxChartDesignerTreeView.CreateDragHelper: TdxChartDesignerDragHelper;
begin
  Result := TdxChartDesignerDragHelper.Create(Self);
end;

procedure TdxChartDesignerTreeView.SetCommandIcons(
  const Value: TCustomImageList);
begin
  cxSetImageList(Value, FCommandIcons, FCommandIconsChangeLink, Self);
  Changed([tvcLayout]);
end;

{ TdxChartDesignerTreeViewNodeViewInfo }

constructor TdxChartDesignerTreeViewNodeViewInfo.Create(
  ATreeView: TdxCustomTreeView);
begin
  inherited Create(ATreeView);
  FCommandIcons := TList<TRect>.Create;
end;

destructor TdxChartDesignerTreeViewNodeViewInfo.Destroy;
begin
  FreeAndNil(FCommandIcons);
  inherited Destroy;
end;

procedure TdxChartDesignerTreeViewNodeViewInfo.AdjustTextRect(AFont: TFont = nil);
var
  I: Integer;
  AIconRect, R: TRect;
begin
  inherited AdjustTextRect(AFont);
  CalculateCommandIcons;
  if (Node = nil) or not CanShowCommandIcons then
    Exit;
  R := FTextRect;
  for I := 0 to FCommandIcons.Count - 1 do
  begin
    AIconRect := FCommandIcons[I];
    if TreeView.UseRightToLeftAlignment then
      R.Left := Max(R.Left, AIconRect.Right + ScaleFactor.Apply(cxTextOffset))
    else
      R.Right := Min(R.Right, AIconRect.Left - ScaleFactor.Apply(cxTextOffset))
  end;
  FTextRect := R;
end;

procedure TdxChartDesignerTreeViewNodeViewInfo.CalculateCommandIcons;
var
  R: TRect;
  X: Integer;
  I: Integer;

  function GetIconRect: TRect;
  begin
    Result := R;
    if TreeView.UseRightToLeftAlignment then
    begin
      Result.MoveToLeft(X);
      X := X + R.Width + ScaleFactor.Apply(cxTextOffset);
    end
    else
    begin
      Result.MoveToRight(X);
      X := X - R.Width - ScaleFactor.Apply(cxTextOffset);
    end;
  end;

begin
  FCommandIcons.Clear;
  if (TreeView.CommandIcons = nil) or (Node = nil) or not Node.IsValid then
    Exit;
  if TreeView.UseRightToLeftAlignment then
    X := TreeView.ViewInfo.ContentRect.Left - TreeView.ViewInfo.ViewPort.X + ScaleFactor.Apply(cxTextOffset) + LevelOffset
  else
    X := TreeView.ViewInfo.ContentRect.Right + TreeView.ViewInfo.ViewPort.X - ScaleFactor.Apply(cxTextOffset) - LevelOffset;
  R := cxRectCenterVertically(Bounds, TreeView.ScaleFactor.Apply(TreeView.CommandIcons.Height));
  R.Width := R.Height;

  for I := 0 to Node.Data.GetCommandIconCount - 1 do
    FCommandIcons.Insert(0, GetIconRect);
end;

procedure TdxChartDesignerTreeViewNodeViewInfo.CalculateHitTest(
  AHitTest: TdxTreeViewHitTest);
var
  AChartDesignerHitTest: TdxChartDesignerTreeViewHitTest absolute AHitTest;
  I: Integer;
  R: TRect;
begin
  inherited CalculateHitTest(AHitTest);
  if AHitTest.HitObject <> Node then
    Exit;
  if (AChartDesignerHitTest.HitData = nil) or (AChartDesignerHitTest.HitData.&Object = nil) then
    Exit;
  for I := 0 to FCommandIcons.Count - 1 do
  begin
    if FCommandIcons[I].Contains(AHitTest.HitPoint) then
    begin
      AChartDesignerHitTest.HitAtCommandIcon := True;
      AChartDesignerHitTest.HitCommandIconIndex := I;
      R := cxRectOffset(FCommandIcons[I], LevelOffset, Node.DisplayRect(False).Top);
      R.Offset(TreeView.ViewInfo.GetContentOffset.X, 0);
      AChartDesignerHitTest.HitCommandIconBounds := R;
      Break;
    end;
  end;
end;

function TdxChartDesignerTreeViewNodeViewInfo.CalculateSelectionRect: TRect;
var
  R: TRect;
begin
  R := TextRect;
  Result := Bounds;
  if TreeView.UseRightToLeftAlignment then
    Result.Right := R.Right
  else
    Result.Left := R.Left;
  Result.Inflate(ScaleFactor.Apply(cxTextOffset), 0);
  Result.IntersectsWith(Bounds);
end;

function TdxChartDesignerTreeViewNodeViewInfo.CanShowCommandIcons: Boolean;
begin
  Result := (Node <> nil) and Node.IsValid and not TreeView.DragHelper.IsDragging and
    (HasHottrack or HasFocus or HasSelection);
end;

procedure TdxChartDesignerTreeViewNodeViewInfo.DefaultDraw(ACanvas: TcxCanvas);
begin
  if (Node <> nil) and not Node.Enabled and not HasHottrack and not HasSelection then
    FTextColor := LookAndFeelPainter.DefaultEditorTextColor(True);
  inherited DefaultDraw(ACanvas);
  DrawCommandIcons(ACanvas);
end;

procedure TdxChartDesignerTreeViewNodeViewInfo.DrawCommandIcons(
  ACanvas: TcxCanvas);
const
  AlphaDisabled = $5A;
  AlphaHot = $FF;
  AlphaNormal = $A5;

  function GetAlpha(AIndex: Integer): Byte;
  begin
    if TreeView.HitTest.HitAtCommandIcon and (TreeView.HitTest.HitCommandIconIndex = AIndex) and (TreeView.HitTest.HitObjectAsNode = Node) then
      Result := AlphaHot
    else
      Result := AlphaNormal;
  end;

var
  I: Integer;
  R: TRect;
  APalette: IdxColorPalette;
  AStates: TdxTreeViewNodeStates;
  AColor: TColor;
  AIconColor: TdxAlphaColor;
begin
  if not CanShowCommandIcons then
    Exit;
  AStates := [];
  if HasHottrack then
    Include(AStates, dxtnsHot);
  if HasSelection then
    Include(AStates, dxtnsSelected);
  if not TreeView.Focused then
    Include(AStates, dxtnsInactive);
  AColor := LookAndFeelPainter.GetTreeViewNodeTextColor(AStates);
  for I := 0 to FCommandIcons.Count - 1 do
  begin
    AIconColor := dxColorToAlphaColor(AColor, GetAlpha(I));
    APalette := TdxSimpleColorPalette.Create(AIconColor, TdxAlphaColors.Empty);
    R := FCommandIcons[I];
    TdxImageDrawer.DrawImage(ACanvas, R, nil, TreeView.CommandIcons, Node.Data.GetCommandIconImageIndex(I),
      ifmNormal, idmNormal, True, APalette, TreeView.ScaleFactor);
  end;
end;

function TdxChartDesignerTreeViewNodeViewInfo.GetNode: TdxChartDesignerTreeViewNode;
begin
  Result := TdxChartDesignerTreeViewNode(inherited Node);
end;

function TdxChartDesignerTreeViewNodeViewInfo.GetTreeView: TdxChartDesignerTreeView;
begin
  Result := TdxChartDesignerTreeView(inherited TreeView);
end;

{ TdxChartDesignerTreeViewViewInfo }

function TdxChartDesignerTreeViewViewInfo.CreateNodeViewInfo: TdxTreeViewNodeViewInfo;
begin
  Result := TdxChartDesignerTreeViewNodeViewInfo.Create(TreeView);
end;

{ TdxChartDesignerPopupMenu }

constructor TdxChartDesignerPopupMenu.Create;
begin
  inherited Create(nil);
  FImages := TcxImageList.Create(Self);
  FAdapter := TdxBuiltInPopupMenuAdapterManager.GetActualAdapterClass.Create(Self);
  FAdapter.SetImages(FImages);
end;

destructor TdxChartDesignerPopupMenu.Destroy;
begin
  FreeAndNil(FAdapter);
  FreeAndNil(FImages);
  inherited Destroy;
end;

function TdxChartDesignerPopupMenu.Popup(AControl: TWinControl; APopupMenu: TPopupMenu; const P: TPoint): Boolean;
var
  APopupPoint: TPoint;
begin
  APopupPoint := AControl.ClientToScreen(P);
  FAdapter.BiDiMode := AControl.BiDiMode;
  FImages.Clear;
  FAdapter.Clear;
  TdxBuiltInPopupMenuAdapterHelper.AddMenu(FAdapter, APopupMenu, PopupMenuItemClickHandler);
  Result := FAdapter.Popup(APopupPoint);
end;

procedure TdxChartDesignerPopupMenu.PopupMenuItemClickHandler(Sender: TObject);
begin
  TMenuItem(Sender).Click;
end;

{ TfrmChartDesigner }

constructor TfrmChartDesigner.Create(AChartControl: TdxCustomChartControl);
var
  AOriginalNumerator: Integer;
  AOriginalDenominator: Integer;
begin
  FOriginalChartControl := AChartControl;
  inherited Create(nil);
  cxAddFreeNotification(Self, FOriginalChartControl);
  FPopupMenu := TdxChartDesignerPopupMenu.Create;
  FTreeView := TdxChartDesignerTreeView.Create(Owner);
  FLookAndFeel := TcxLookAndFeel.Create(Self);
  FLookAndFeel.AddChangeListener(Self);
  FLookAndFeel.MasterLookAndFeel := TdxCustomChartControlAccess(FOriginalChartControl).LookAndFeel;
  if not IsDesigning then
  begin
    FInnerChartControl := TdxChartControl.Create(nil);
    AOriginalNumerator := TdxCustomChartControlAccess(OriginalChartControl).ScaleFactor.Numerator;
    AOriginalDenominator := TdxCustomChartControlAccess(OriginalChartControl).ScaleFactor.Denominator;
    FInnerChartControl.ScaleBy(AOriginalNumerator, AOriginalDenominator);
    FInnerChartControl.Assign(OriginalChartControl);
    FInnerChartControl.ScaleBy(AOriginalDenominator, AOriginalNumerator);
    liChartControl.Control := FInnerChartControl;
  end;
  TdxCustomChartControlAccess(CustomizedChartControl).OnChartChanged.Add(ChartChangedHandler);

  liTreeView.Control := FTreeView;
  liTreeView.CaptionOptions.Visible := False;
  liChartControl.CaptionOptions.Visible := False;
  Initialize;
  FInitialized := True;
  FirstTimePopulateTreeView;
end;

destructor TfrmChartDesigner.Destroy;
begin
  BeginUpdate;
  cxDialogsMetricsStore.StoreMetrics(Self);
  if CustomizedChartControl <> nil then
    TdxCustomChartControlAccess(CustomizedChartControl).OnChartChanged.Remove(ChartChangedHandler);
  FreeAndNil(FPopupMenu);
  FreeAndNil(FLookAndFeel);
  inherited Destroy;
end;

function TfrmChartDesigner.CanResizeOptions(ANewSize: Integer): Boolean;
begin
  if ANewSize > lgAllOptions.Width then
    Result := CustomizedChartControl.Width + lgAllOptions.Width - ANewSize > ScaleFactor.Apply(ChartMinWidth)
  else
    Result := ANewSize > ScaleFactor.Apply(OptionsMinWidth);
end;

procedure TfrmChartDesigner.aAddDiagramExecute(Sender: TObject);
begin
  AddDiagram(TComponent(Sender).Tag);
end;

procedure TfrmChartDesigner.aAddSeriesUpdate(Sender: TObject);
var
  ADiagram: TdxChartCustomDiagramAccess;
  ASeries: TdxChartCustomSeries;
  AAction: TAction absolute Sender;
begin
  AAction.Visible := True;
  AAction.Checked := False;
  if (TreeView.FocusedNode <> nil) and (TreeView.FocusedNode.Data <> nil) then
  begin
    if AAction.Tag in [5, 7] then 
    begin
      AAction.Visible := False;
      Exit;
    end;
    if TObject(TreeView.FocusedNode.Data) is TDiagramNodeObject then
    begin
      ADiagram := TdxChartCustomDiagramAccess(TDiagramNodeObject(TreeView.FocusedNode.Data).Diagram);
      AAction.Visible := FSeriesMap[AAction.Tag].IsCompatibleWith(ADiagram.GetSeriesClass);
    end
    else if TObject(TreeView.FocusedNode.Data) is TDiagramSeriesNodeObject then
    begin
      ASeries := TDiagramSeriesNodeObject(TreeView.FocusedNode.Data).Series;
      AAction.Visible := ASeries.IsCompatibleWithView(FSeriesMap[AAction.Tag]);
      AAction.Checked := ASeries.ViewClass = FSeriesMap[AAction.Tag];
    end;
  end;
end;

procedure TfrmChartDesigner.aCancelExecute(Sender: TObject);
begin
  FIsClosing := True;
  Close;
end;

procedure TfrmChartDesigner.aCloseExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmChartDesigner.aAddSeriesExecute(Sender: TObject);
var
  ASeries: TdxChartCustomSeries;
begin
  if TObject(TreeView.FocusedNode.Data) is TDiagramNodeObject then
    AddSeries(TDiagramNodeObject(TreeView.FocusedNode.Data).Diagram, FSeriesMap[TComponent(Sender).Tag])
  else if TObject(TreeView.FocusedNode.Data) is TDiagramSeriesNodeObject then
  begin
    ASeries := TDiagramSeriesNodeObject(TreeView.FocusedNode.Data).Series;
    ASeries.ViewClass := FSeriesMap[TComponent(Sender).Tag];
    Modified;
    TreeView.FocusedNode.StateImageIndex := TDiagramSeriesNodeObject(TreeView.FocusedNode.Data).ImageIndex;
  end;
end;

procedure TfrmChartDesigner.AddChartTitle;
var
  ATitle: TdxChartTitleCollectionItem;
begin
  if TObject(TreeView.FocusedNode.Data) is TChartTitlesNodeObject then
  begin
    BeginUpdate;
    try
      ATitle := CustomizedChartControl.Titles.Add;
    finally
      EndUpdate;
      PopulateTreeView;
    end;
    SelectObject(ATitle);
  end;
end;

procedure TfrmChartDesigner.AddDiagram(AIndex: Integer);
var
  ADiagram: TdxChartCustomDiagram;
begin
  TreeView.Root.BeginUpdate;
  try
    if AIndex = 0 then
      ADiagram := CustomizedChartControl.AddDiagram<TdxChartXYDiagram>
    else
      ADiagram := CustomizedChartControl.AddDiagram<TdxChartSimpleDiagram>;

    SelectObject(ADiagram);
    TreeView.FocusedNode.Collapse(True);
  finally
    TreeView.Root.EndUpdate;
  end;
end;

procedure TfrmChartDesigner.AddSeries(ADiagram: TdxChartCustomDiagram;
  AViewClass: TdxChartSeriesViewClass);
var
  ASeries: TdxChartCustomSeries;
begin
  TreeView.Root.BeginUpdate;
  try
    BeginUpdate;
    try
      ASeries := TdxChartCustomDiagramAccess(ADiagram).AddSeries;
      ASeries.ViewClass := AViewClass;
    finally
      EndUpdate;
    end;
    PopulateTreeView;
    SelectObject(ASeries);
    TreeView.FocusedNode.Collapse(True);
    TreeView.FocusedNode.StateImageIndex := TNodeObject(TreeView.FocusedNode.Data).ImageIndex;
  finally
    TreeView.Root.EndUpdate;
  end;
end;

procedure TfrmChartDesigner.LocalizeSeriesMenu(AIsAdd: Boolean);
var
  AFormatStr: string;
begin
  AFormatStr := cxGetResourceString(@sdxChartDesignerAddSeriesTemplate);
  if not AIsAdd then
    AFormatStr := cxGetResourceString(@sdxChartDesignerChangeViewSeriesTemplate);
  aAddAreaSeries.Caption := Format(AFormatStr, [cxGetResourceString(@sdxChartControlAreaDisplayName)]);
  aAddPieSeries.Caption := Format(AFormatStr, [cxGetResourceString(@sdxChartControlPieDisplayName)]);
  aAddDoughnutSeries.Caption := Format(AFormatStr, [cxGetResourceString(@sdxChartControlDoughnutDisplayName)]);
  aAddLineSeries.Caption := Format(AFormatStr, [cxGetResourceString(@sdxChartControlLineDisplayName)]);
  aAddBarSeries.Caption := Format(AFormatStr, [cxGetResourceString(@sdxChartControlBarDisplayName)]);
  aAddStackedBarSeries.Caption := Format(AFormatStr, [cxGetResourceString(@sdxChartControlStackedBarDisplayName)]);
  aAddStackedBarSideBySideSeries.Caption := Format(AFormatStr, [cxGetResourceString(@sdxChartControlStackedBarSideBySideDisplayName)]);
  aAddFullStackedBarSeries.Caption := Format(AFormatStr, [cxGetResourceString(@sdxChartControlFullStackedBarDisplayName)]);
  aAddFullStackedBarSideBySideSeries.Caption := Format(AFormatStr, [cxGetResourceString(@sdxChartControlFullStackedBarSideBySideDisplayName)]);
  aAddStackedAreaSeries.Caption := Format(AFormatStr, [cxGetResourceString(@sdxChartControlStackedAreaDisplayName)]);
  aAddFullStackedAreaSeries.Caption := Format(AFormatStr, [cxGetResourceString(@sdxChartControlFullStackedAreaDisplayName)]);
  aAddStackedLineSeries.Caption := Format(AFormatStr, [cxGetResourceString(@sdxChartControlStackedLineDisplayName)]);
  aAddFullStackedLineSeries.Caption := Format(AFormatStr, [cxGetResourceString(@sdxChartControlFullStackedLineDisplayName)]);
end;

procedure TfrmChartDesigner.LocalizeValueLabelsResolveOverlappingMode(ASetIndex: Integer);
begin
  case ASetIndex of
    0: // Line Series
      LocalizeItems(cbValueLabelsResolveOverlappingMode.Properties.Items,
        TArray<TcxResourceStringID>.Create(
          @sdxChartDesignerValueLabelsResolveOverlappingNone,
          @sdxChartDesignerValueLabelsResolveOverlappingDefault,
          @sdxChartDesignerValueLabelsResolveOverlappingHideOverlapped,
          @sdxChartDesignerValueLabelsResolveOverlappingJustifyAroundPoint,
          @sdxChartDesignerValueLabelsResolveOverlappingJustifyAllAroundPoint));
    1: // Bar Series
      LocalizeItems(cbValueLabelsResolveOverlappingMode.Properties.Items,
        TArray<TcxResourceStringID>.Create(
          @sdxChartDesignerValueLabelsResolveOverlappingNone,
          @sdxChartDesignerValueLabelsResolveOverlappingDefault,
          @sdxChartDesignerValueLabelsResolveOverlappingHideOverlapped));
    2: // Pie Series
      LocalizeItems(cbValueLabelsResolveOverlappingMode.Properties.Items,
        TArray<TcxResourceStringID>.Create(
          @sdxChartDesignerValueLabelsResolveOverlappingNone,
          @sdxChartDesignerValueLabelsResolveOverlappingDefault));
  end;
end;

procedure TfrmChartDesigner.LocalizeItems(AItems: TStrings; AResourceStrings: TArray<TcxResourceStringID>);
var
  AString: TcxResourceStringID;
begin
  AItems.BeginUpdate;
  try
    AItems.Clear;
    for AString in AResourceStrings do
      AItems.Add(cxGetResourceString(AString));
  finally
    AItems.EndUpdate;
  end;
end;

procedure TfrmChartDesigner.LocalizeItems(AItems: TcxImageComboBoxItems; AResourceStrings: TArray<TcxResourceStringID>);
var
  AString: TcxResourceStringID;
begin
  AItems.BeginUpdate;
  try
    AItems.Clear;
    for AString in AResourceStrings do
    begin
      with AItems.Add do
      begin
        Description := cxGetResourceString(AString);
        Value := Description;
      end;
    end;
  finally
    AItems.EndUpdate;
  end;
end;

procedure TfrmChartDesigner.ApplyLocalization;

  procedure LocalizeEditors;
  begin
    LocalizeItems(cbTitleDock.Properties.Items,
      TArray<TcxResourceStringID>.Create(
        @sdxChartDesignerDefaultCaption,
        @sdxChartDesignerTitlePositionLeftCaption,
        @sdxChartDesignerTitlePositionTopCaption,
        @sdxChartDesignerTitlePositionRightCaption,
        @sdxChartDesignerTitlePositionBottomCaption));
    LocalizeItems(cbTitleAxisPosition.Properties.Items,
      TArray<TcxResourceStringID>.Create(
        @sdxChartDesignerOutsideCaption,
        @sdxChartDesignerInsideCaption));
    LocalizeItems(cbTitleAlignment.Properties.Items,
      TArray<TcxResourceStringID>.Create(
        @sdxChartDesignerDefaultCaption,
        @sdxChartDesignerNearCaption,
        @sdxChartDesignerCenterCaption,
        @sdxChartDesignerFarCaption));
    LocalizeItems(cbLegendAlignmentHorizontal.Properties.Items,
      TArray<TcxResourceStringID>.Create(
        @sdxChartDesignerDefaultCaption,
        @sdxChartDesignerLegendAlignmentNearOutsideCaption,
        @sdxChartDesignerNearCaption,
        @sdxChartDesignerCenterCaption,
        @sdxChartDesignerFarCaption,
        @sdxChartDesignerLegendAlignmentFarOutsideCaption));
    LocalizeItems(cbLegendAlignmentVertical.Properties.Items,
      TArray<TcxResourceStringID>.Create(
        @sdxChartDesignerDefaultCaption,
        @sdxChartDesignerLegendAlignmentNearOutsideCaption,
        @sdxChartDesignerNearCaption,
        @sdxChartDesignerCenterCaption,
        @sdxChartDesignerFarCaption,
        @sdxChartDesignerLegendAlignmentFarOutsideCaption));
    LocalizeItems(cbLegendDirection.Properties.Items,
      TArray<TcxResourceStringID>.Create(
        @sdxChartDesignerLegendDirectionTopToBottomCaption,
        @sdxChartDesignerLegendDirectionBottomToTopCaption,
        @sdxChartDesignerLegendDirectionLeftToRightCaption,
        @sdxChartDesignerLegendDirectionRightToLeftCaption));
    LocalizeItems(cbBackgroundMode.Properties.Items,
      TArray<TcxResourceStringID>.Create(
        @sdxChartDesignerBackgroundModeClearCaption,
        @sdxChartDesignerBackgroundModeSolidCaption,
        @sdxChartDesignerBackgroundModeGradientCaption,
        @sdxChartDesignerBackgroundModeTextureCaption,
        @sdxChartDesignerBackgroundModeHatchCaption));
    LocalizeItems(cbBackgroundGradientMode.Properties.Items,
      TArray<TcxResourceStringID>.Create(
        @sdxChartDesignerBackgroundGradientModeHorizontalCaption,
        @sdxChartDesignerBackgroundGradientModeVerticalCaption,
        @sdxChartDesignerBackgroundGradientModeForwardDiagonalCaption,
        @sdxChartDesignerBackgroundGradientModeBackwardDiagonalCaption));
    LocalizeItems(icbBackgroundHatchStyle.Properties.Items,
      TArray<TcxResourceStringID>.Create(
        @sdxChartDesignerBackgroundHatchStyleHorizontalCaption,
        @sdxChartDesignerBackgroundHatchStyleVerticalCaption,
        @sdxChartDesignerBackgroundHatchStyleForwardDiagonalCaption,
        @sdxChartDesignerBackgroundHatchStyleBackwardDiagonalCaption,
        @sdxChartDesignerCrossCaption,
        @sdxChartDesignerBackgroundHatchStyleDiagonalCrossCaption,
        @sdxChartDesignerBackgroundHatchStylePercent05Caption,
        @sdxChartDesignerBackgroundHatchStylePercent10Caption,
        @sdxChartDesignerBackgroundHatchStylePercent20Caption,
        @sdxChartDesignerBackgroundHatchStylePercent25Caption,
        @sdxChartDesignerBackgroundHatchStylePercent30Caption,
        @sdxChartDesignerBackgroundHatchStylePercent40Caption,
        @sdxChartDesignerBackgroundHatchStylePercent50Caption,
        @sdxChartDesignerBackgroundHatchStylePercent60Caption,
        @sdxChartDesignerBackgroundHatchStylePercent70Caption,
        @sdxChartDesignerBackgroundHatchStylePercent75Caption,
        @sdxChartDesignerBackgroundHatchStylePercent80Caption,
        @sdxChartDesignerBackgroundHatchStylePercent90Caption,
        @sdxChartDesignerBackgroundHatchStyleLightDownwardDiagonalCaption,
        @sdxChartDesignerBackgroundHatchStyleLightUpwardDiagonalCaption,
        @sdxChartDesignerBackgroundHatchStyleDarkDownwardDiagonalCaption,
        @sdxChartDesignerBackgroundHatchStyleDarkUpwardDiagonalCaption,
        @sdxChartDesignerBackgroundHatchStyleWideDownwardDiagonalCaption,
        @sdxChartDesignerBackgroundHatchStyleWideUpwardDiagonalCaption,
        @sdxChartDesignerBackgroundHatchStyleLightVerticalCaption,
        @sdxChartDesignerBackgroundHatchStyleLightHorizontalCaption,
        @sdxChartDesignerBackgroundHatchStyleNarrowVerticalCaption,
        @sdxChartDesignerBackgroundHatchStyleNarrowHorizontalCaption,
        @sdxChartDesignerBackgroundHatchStyleDarkVerticalCaption,
        @sdxChartDesignerBackgroundHatchStyleDarkHorizontalCaption,
        @sdxChartDesignerBackgroundHatchStyleDashedDownwardDiagonalCaption,
        @sdxChartDesignerBackgroundHatchStyleDashedUpwardDiagonalCaption,
        @sdxChartDesignerBackgroundHatchStyleDashedHorizontalCaption,
        @sdxChartDesignerBackgroundHatchStyleDashedVerticalCaption,
        @sdxChartDesignerBackgroundHatchStyleSmallConfettiCaption,
        @sdxChartDesignerBackgroundHatchStyleLargeConfettiCaption,
        @sdxChartDesignerBackgroundHatchStyleZigZagCaption,
        @sdxChartDesignerBackgroundHatchStyleWaveCaption,
        @sdxChartDesignerBackgroundHatchStyleDiagonalBrickCaption,
        @sdxChartDesignerBackgroundHatchStyleHorizontalBrickCaption,
        @sdxChartDesignerBackgroundHatchStyleWeaveCaption,
        @sdxChartDesignerBackgroundHatchStylePlaidCaption,
        @sdxChartDesignerBackgroundHatchStyleDivotCaption,
        @sdxChartDesignerBackgroundHatchStyleDottedGridCaption,
        @sdxChartDesignerBackgroundHatchStyleDottedDiamondCaption,
        @sdxChartDesignerBackgroundHatchStyleShingleCaption,
        @sdxChartDesignerBackgroundHatchStyleTrellisCaption,
        @sdxChartDesignerBackgroundHatchStyleSphereCaption,
        @sdxChartDesignerBackgroundHatchStyleSmallGridCaption,
        @sdxChartDesignerBackgroundHatchStyleSmallCheckerBoardCaption,
        @sdxChartDesignerBackgroundHatchStyleLargeCheckerBoardCaption,
        @sdxChartDesignerBackgroundHatchStyleOutlinedDiamondCaption,
        @sdxChartDesignerBackgroundHatchStyleSolidDiamondCaption));
    LocalizeItems(cbSeriesSortOrder.Properties.Items,
      TArray<TcxResourceStringID>.Create(
        @sdxChartDesignerNoneCaption,
        @sdxChartDesignerSortOrderAscendingCaption,
        @sdxChartDesignerSortOrderDescendingCaption));
    LocalizeItems(cbSeriesSortBy.Properties.Items,
      TArray<TcxResourceStringID>.Create(
        @sdxChartDesignerSortByArgumentCaption,
        @sdxChartDesignerSortByValueCaption));
    LocalizeItems(cbSeriesShowInLegend.Properties.Items,
      TArray<TcxResourceStringID>.Create(
        @sdxChartDesignerShowInLegendDiagramCaption,
        @sdxChartDesignerShowInLegendChartCaption,
        @sdxChartDesignerNoneCaption));
    LocalizeItems(cbTopNMode.Properties.Items,
      TArray<TcxResourceStringID>.Create(
        @sdxChartDesignerTopNModeCountCaption,
        @sdxChartDesignerTopNModeThresholdValueCaption,
        @sdxChartDesignerTopNModeThresholdPercentCaption));
    LocalizeItems(cbValueLabelsTextAlignment.Properties.Items,
      TArray<TcxResourceStringID>.Create(
        @sdxChartDesignerDefaultCaption,
        @sdxChartDesignerNearCaption,
        @sdxChartDesignerCenterCaption,
        @sdxChartDesignerFarCaption));
    LocalizeItems(cbMarkerType.Properties.Items,
      TArray<TcxResourceStringID>.Create(
        @sdxChartDesignerMarkerTypeCircleCaption,
        @sdxChartDesignerMarkerTypeSquareCaption,
        @sdxChartDesignerMarkerTypeDiamondCaption,
        @sdxChartDesignerMarkerTypeTriangleCaption,
        @sdxChartDesignerMarkerTypeInvertedTriangleCaption,
        @sdxChartDesignerMarkerTypePlusCaption,
        @sdxChartDesignerCrossCaption,
        @sdxChartDesignerMarkerTypeStartCaption,
        @sdxChartDesignerMarkerTypePentagonCaption,
        @sdxChartDesignerMarkerTypeHexagonCaption));
    LocalizeItems(cbDiagramLayoutDirection.Properties.Items,
      TArray<TcxResourceStringID>.Create(
        @sdxChartDesignerLayoutDirectionAutoCaption,
        @sdxChartDesignerLayoutDirectionHorizontalCaption,
        @sdxChartDesignerLayoutDirectionVerticalCaption));
    LocalizeItems(cbSeriesViewExplodedValueMode.Properties.Items,
      TArray<TcxResourceStringID>.Create(
        @sdxChartDesignerNoneCaption,
        @sdxChartDesignerSeriesViewExplodedValueModeAllCaption,
        @sdxChartDesignerSeriesViewExplodedValueModeMinCaption,
        @sdxChartDesignerSeriesViewExplodedValueModeMaxCaption,
        @sdxChartDesignerSeriesViewExplodedValueModeCustomCaption));
    LocalizeItems(cbSeriesViewSweepDirection.Properties.Items,
      TArray<TcxResourceStringID>.Create(
        @sdxChartDesignerSeriesViewSweepDirectionCounterClockwiseCaption,
        @sdxChartDesignerSeriesViewSweepDirectionClockwiseCaption));
    LocalizeItems(cbAxisAlignment.Properties.Items,
      TArray<TcxResourceStringID>.Create(
        @sdxChartDesignerNearCaption,
        @sdxChartDesignerFarCaption,
        @sdxChartDesignerZeroCaption,
        @sdxChartDesignerCenterCaption));
    LocalizeItems(cbValueLabelsPosition.Properties.Items,
      TArray<TcxResourceStringID>.Create(
        @sdxChartDesignerInsideCaption,
        @sdxChartDesignerOutsideCaption,
        @sdxChartDesignerValueLabelsPositionTwoColumnsCaption,
        @sdxChartDesignerValueLabelsPositionRadialCaption,
        @sdxChartDesignerValueLabelsPositionTangentCaption));
    LocalizeItems(cbAppearanceAxisGridlinesStyle.Properties.Items,
      TArray<TcxResourceStringID>.Create(
        @sdxChartDesignerStrokeStyleSolidCaption,
        @sdxChartDesignerStrokeStyleDashCaption,
        @sdxChartDesignerStrokeStyleDotCaption,
        @sdxChartDesignerStrokeStyleDashDotCaption,
        @sdxChartDesignerStrokeStyleDashDotDotCaption));
    LocalizeItems(cbAxisValueLabelsPosition.Properties.Items,
      TArray<TcxResourceStringID>.Create(
        @sdxChartDesignerOutsideCaption,
        @sdxChartDesignerInsideCaption));
    LocalizeItems(cbAxisValueLabelsAlignment.Properties.Items,
      TArray<TcxResourceStringID>.Create(
        @sdxChartDesignerDefaultCaption,
        @sdxChartDesignerNearCaption,
        @sdxChartDesignerCenterCaption,
        @sdxChartDesignerFarCaption));
    LocalizeItems(cbAxisTicksCrossKind.Properties.Items,
      TArray<TcxResourceStringID>.Create(
        @sdxChartDesignerOutsideCaption,
        @sdxChartDesignerCrossCaption,
        @sdxChartDesignerInsideCaption));
    LocalizeItems(cbAxisTicksLabelAlignment.Properties.Items,
      TArray<TcxResourceStringID>.Create(
        @sdxChartDesignerDefaultCaption,
        @sdxChartDesignerNearCaption,
        @sdxChartDesignerCenterCaption,
        @sdxChartDesignerFarCaption));

    cbAppearanceAxisInterlacedMode.ActiveProperties.Items.Assign(cbBackgroundMode.ActiveProperties.Items);
    cbAppearanceAxisInterlacedGradient.ActiveProperties.Items.Assign(cbBackgroundGradientMode.ActiveProperties.Items);
    icbAppearanceAxisInterlacedStyle.ActiveProperties.Items.Assign(icbBackgroundHatchStyle.ActiveProperties.Items);
    cbAxisTicksMinorCrossKind.ActiveProperties.Items.Assign(cbAxisTicksCrossKind.Properties.Items);
    cbAppearanceAxisGridlinesMinorStyle.Properties.Items.Assign(cbAppearanceAxisGridlinesStyle.Properties.Items);
    cbAppearanceStrokeStyle.Properties.Items.Assign(cbAppearanceAxisGridlinesStyle.Properties.Items);
  end;

begin
  Caption := cxGetResourceString(@sdxChartControlDesignerCaption);
  btnOk.Caption := cxGetResourceString(@sdxChartDialogOk);
  aCancel.Caption := cxGetResourceString(@sdxChartDialogCancel);
  aClose.Caption := cxGetResourceString(@sdxChartDialogClose);

  aAddXYDiagram.Caption := cxGetResourceString(@sdxChartControlXYDiagramDisplayName);
  aAddSimpleDiagram.Caption := cxGetResourceString(@sdxChartControlSimpleDiagramDisplayName);
  LocalizeSeriesMenu(True);

  lgOptions.Caption := cxGetResourceString(@sdxChartDesignerOptionsCaption);
  lliOptionsGeneral.Caption := cxGetResourceString(@sdxChartDesignerGeneralCaption);
  liTitleVisible.Caption := cxGetResourceString(@sdxChartDesignerVisibleCaption);
  liTitleWordWrap.Caption := cxGetResourceString(@sdxChartDesignerWordWrapCaption);
  liTitleMaxLineCount.Caption := cxGetResourceString(@sdxChartDesignerMaxLineCountCaption);
  liTitleDock.Caption := cxGetResourceString(@sdxChartDesignerPositionCaption);
  liTitleAlignment.Caption := cxGetResourceString(@sdxChartDesignerAlignmentCaption);
  liTitleText.Caption := cxGetResourceString(@sdxChartDesignerTextCaption);
  liTitleAxisPosition.Caption := cxGetResourceString(@sdxChartDesignerPositionCaption);

  lliFont.Caption := cxGetResourceString(@sdxChartDesignerFontCaption);
  liFontName.Caption := cxGetResourceString(@sdxChartDesignerFontNameCaption);
  liFontSize.Caption := cxGetResourceString(@sdxChartDesignerFontSizeCaption);
  lcbiFontBold.Caption := cxGetResourceString(@sdxChartDesignerFontBoldCaption);
  lcbiFontItalic.Caption := cxGetResourceString(@sdxChartDesignerFontItalicCaption);
  lcbiFontUnderline.Caption := cxGetResourceString(@sdxChartDesignerFontUnderlineCaption);
  lcbiFontStrikeout.Caption := cxGetResourceString(@sdxChartDesignerFontStrikeoutCaption);
  liFontColor.Caption := cxGetResourceString(@sdxChartDesignerColorCaption);

  lliMargins.Caption := cxGetResourceString(@sdxChartDesignerPaddingCaption);
  lgAppearance.Caption := cxGetResourceString(@sdxChartDesignerAppearanceCaption);

  lliBorder.Caption := cxGetResourceString(@sdxChartDesignerBorderCaption);
  liBorderWidth.Caption := cxGetResourceString(@sdxChartDesignerThicknessCaption);
  liBorderColor.Caption := cxGetResourceString(@sdxChartDesignerColorCaption);

  lliAppearanceOther.Caption := cxGetResourceString(@sdxChartDesignerOtherCaption);

  lcbiTitlesVisible.Caption := cxGetResourceString(@sdxChartDesignerVisibleCaption);

  lcbiLegendVisible.Caption := cxGetResourceString(@sdxChartDesignerVisibleCaption);
  lcbiLegendCaptions.Caption := cxGetResourceString(@sdxChartDesignerLegendShowCaptionsCaption);
  lcbiLegendButtons.Caption := cxGetResourceString(@sdxChartDesignerLegendShowCheckBoxesCaption);
  lcbiLegendImages.Caption := cxGetResourceString(@sdxChartDesignerLegendShowImagesCaption);
  liLegendAlignmentHorizontal.Caption := cxGetResourceString(@sdxChartDesignerLegendAlignmentHorizontalCaption);
  liLegendAlignmentVertical.Caption := cxGetResourceString(@sdxChartDesignerLegendAlignmentVerticalCaption);
  liLegendDirection.Caption := cxGetResourceString(@sdxChartDesignerLegendDirectionCaption);
  liLegendMaxCaptionWidth.Caption := cxGetResourceString(@sdxChartDesignerLegendMaxCaptionWidthCaption);

  lliPadding.Caption := cxGetResourceString(@sdxChartDesignerMarginsCaption);

  lliBackground.Caption := cxGetResourceString(@sdxChartDesignerBackgroundCaption);
  liBackgroundColor.Caption := cxGetResourceString(@sdxChartDesignerColorCaption);
  liBackgroundGradientBeginColor.Caption := cxGetResourceString(@sdxChartDesignerGradientBeginColorCaption);
  liBackgroundGradientEndColor.Caption := cxGetResourceString(@sdxChartDesignerGradientEndColorCaption);
  liBackgroundPatternColor.Caption := cxGetResourceString(@sdxChartDesignerPatternColorCaption);
  liBackgroundMode.Caption := cxGetResourceString(@sdxChartDesignerModeCaption);
  liBackgroundHatchStyle.Caption := cxGetResourceString(@sdxChartDesignerHatchStyleCaption);
  liBackgroundGradientMode.Caption := cxGetResourceString(@sdxChartDesignerGradientCaption);
  liBackgroundTexture.Caption := cxGetResourceString(@sdxChartDesignerTextureCaption);

  lcbiSeriesVisible.Caption := cxGetResourceString(@sdxChartDesignerVisibleCaption);
  liSeriesBarWidth.Caption := cxGetResourceString(@sdxChartDesignerSeriesBarWidthCaption);
  liSeriesShowInLegend.Caption := cxGetResourceString(@sdxChartDesignerSeriesShowInLegendCaption);
  liSeriesSortBy.Caption := cxGetResourceString(@sdxChartDesignerSeriesSortByCaption);
  liSeriesSortOrder.Caption := cxGetResourceString(@sdxChartDesignerSeriesSortOrderCaption);

  lliSeriesTopN.Caption := cxGetResourceString(@sdxChartDesignerTopNCaption);
  liTopNMode.Caption := cxGetResourceString(@sdxChartDesignerModeCaption);
  liTopNThresholdPercent.Caption := cxGetResourceString(@sdxChartDesignerTopNThresholdPercentCaption);
  liTopNCount.Caption := cxGetResourceString(@sdxChartDesignerTopNCountCaption);
  liTopNThresholdValue.Caption := cxGetResourceString(@sdxChartDesignerTopNThresholdValueCaption);
  lcbiTopNShowOthers.Caption := cxGetResourceString(@sdxChartDesignerTopNShowOthersCaption);

  aUp.Hint := cxGetResourceString(@sdxChartDesignerMoveUpHint);
  aDown.Hint := cxGetResourceString(@sdxChartDesignerMoveDownHint);

  lliTextOptions.Caption := cxGetResourceString(@sdxChartDesignerTextOptionsCaption);
  lcbiValueLabelsVisible.Caption := cxGetResourceString(@sdxChartDesignerVisibleCaption);
  lcbiValueLabelsLineVisible.Caption := cxGetResourceString(@sdxChartDesignerShowLinesCaption);
  liValueLabelsLineLength.Caption := cxGetResourceString(@sdxChartDesignerLineLengthCaption);
  liValueLabelsAlignment.Caption := cxGetResourceString(@sdxChartDesignerAlignmentCaption);
  liValueLabelsMaxWidth.Caption := cxGetResourceString(@sdxChartDesignerMaxWidthCaption);
  liValueLabelsMaxLineCount.Caption := cxGetResourceString(@sdxChartDesignerMaxLineCountCaption);
  liValueLabelsFormat.Caption := cxGetResourceString(@sdxChartDesignerFormatCaption);
  liValueLabelsPosition.Caption := cxGetResourceString(@sdxChartDesignerPositionCaption);
  lliValueLabelsResolveOverlapping.Caption := cxGetResourceString(@sdxChartDesignerValueLabelsResolveOverlapsCaption);
  liValueLabelsResolveOverlappingIndent.Caption := cxGetResourceString(@sdxChartDesignerValueLabelsResolveOverlappingIndentCaption);
  liValueLabelsResolveOverlappingMode.Caption := cxGetResourceString(@sdxChartDesignerValueLabelsResolveOverlappingModeCaption);

  lcbiMarkerVisible.Caption := cxGetResourceString(@sdxChartDesignerVisibleCaption);
  liMarkerType.Caption := cxGetResourceString(@sdxChartDesignerMarkerTypeCaption);
  liMarkerSize.Caption := cxGetResourceString(@sdxChartDesignerMarkerSizeCaption);

  lcbiAxisVisible.Caption := cxGetResourceString(@sdxChartDesignerVisibleCaption);
  liAppearanceAxisColor.Caption := cxGetResourceString(@sdxChartDesignerColorCaption);
  liAxisMinorCount.Caption := cxGetResourceString(@sdxChartDesignerAxisMinorCountCaption);
  lcbiAxisInterlaced.Caption := cxGetResourceString(@sdxChartDesignerEnabledCaption);
  liAxisSideMargin.Caption := cxGetResourceString(@sdxChartDesignerAxisSideMarginCaption);
  lliAxisVisualRange.Caption := cxGetResourceString(@sdxChartDesignerVisibleRangeCaption);
  lliAxisWholeRange.Caption := cxGetResourceString(@sdxChartDesignerEntireRangeCaption);
  lcbiAxisVisualRangeAuto.Caption := cxGetResourceString(@sdxChartDesignerAxisRangeAutoCaption);
  lcbiAxisWholeRangeAuto.Caption := cxGetResourceString(@sdxChartDesignerAxisRangeAutoCaption);
  liAxisVisualRangeMinValue.Caption := cxGetResourceString(@sdxChartDesignerAxisRangeMinValueCaption);
  liAxisVisualRangeMaxValue.Caption := cxGetResourceString(@sdxChartDesignerAxisRangeMaxValueCaption);
  liAxisWholeRangeMinValue.Caption := cxGetResourceString(@sdxChartDesignerAxisRangeMinValueCaption);
  liAxisWholeRangeMaxValue.Caption := cxGetResourceString(@sdxChartDesignerAxisRangeMaxValueCaption);
  lcbiAxisReverse.Caption := cxGetResourceString(@sdxChartDesignerAxisInvertedCaption);
  liAxisAlignment.Caption := cxGetResourceString(@sdxChartDesignerAlignmentCaption);
  lliAppearanceAxis.Caption := cxGetResourceString(@sdxChartDesignerAxisCaption);

  lliAppearanceAxisInterlaced.Caption := cxGetResourceString(@sdxChartDesignerInterlacedCaption);
  liAppearanceAxisInterlacedMode.Caption := cxGetResourceString(@sdxChartDesignerModeCaption);
  liAppearanceAxisInterlacedColor.Caption := cxGetResourceString(@sdxChartDesignerColorCaption);
  liAppearanceAxisInterlacedGradientBeginColor.Caption := cxGetResourceString(@sdxChartDesignerGradientBeginColorCaption);
  liAppearanceAxisInterlacedGradientEndColor.Caption := cxGetResourceString(@sdxChartDesignerGradientEndColorCaption);
  liAppearanceAxisInterlacedPattern.Caption := cxGetResourceString(@sdxChartDesignerPatternColorCaption);
  liAppearanceAxisInterlacedStyle.Caption := cxGetResourceString(@sdxChartDesignerHatchStyleCaption);
  liAppearanceAxisInterlacedGradient.Caption := cxGetResourceString(@sdxChartDesignerGradientCaption);
  liAppearanceAxisInterlacedTexture.Caption := cxGetResourceString(@sdxChartDesignerTextureCaption);

  lliAppearanceAxisTicks.Caption := cxGetResourceString(@sdxChartDesignerTicksCaption);
  lliAxisTicks.Caption := cxGetResourceString(@sdxChartDesignerTicksCaption);
  lcbiAxisTicksVisible.Caption  := cxGetResourceString(@sdxChartDesignerVisibleCaption);
  lliAppearanceAxisMinorTicks.Caption := cxGetResourceString(@sdxChartDesignerMinorTicksCaption);
  lliAxisMinorTicks.Caption := cxGetResourceString(@sdxChartDesignerMinorTicksCaption);
  lcbiAxisTicksMinorVisible.Caption  := cxGetResourceString(@sdxChartDesignerVisibleCaption);
  liAxisTicksCrossKind.Caption  := cxGetResourceString(@sdxChartDesignerAxisTicksCrossKindCaption);
  liAxisTicksLabelAlignment.Caption  := cxGetResourceString(@sdxChartDesignerAxisTicksLabelAlignmentCaption);
  liAxisTicksMinorCrossKind.Caption  := cxGetResourceString(@sdxChartDesignerAxisTicksCrossKindCaption);
  liAppearanceAxisThickness.Caption := cxGetResourceString(@sdxChartDesignerThicknessCaption);
  liAppearanceAxisTicksThickness.Caption := cxGetResourceString(@sdxChartDesignerThicknessCaption);
  liAppearanceAxisTicksLength.Caption := cxGetResourceString(@sdxChartDesignerAxisTicksLengthCaption);
  liAppearanceAxisTicksMinorThickness.Caption := cxGetResourceString(@sdxChartDesignerThicknessCaption);
  liAppearanceAxisTicksMinorLength.Caption := cxGetResourceString(@sdxChartDesignerAxisTicksLengthCaption);

  lliAppearanceAxisGridlines.Caption := cxGetResourceString(@sdxChartDesignerAxisGridlinesCaption);
  lliAppearanceAxisMinorGridlines.Caption := cxGetResourceString(@sdxChartDesignerAxisMinorGridlinesCaption);
  lcbiAxisGridlines.Caption := cxGetResourceString(@sdxChartDesignerVisibleCaption);
  lcbiAxisGridlinesMinorVisible.Caption := cxGetResourceString(@sdxChartDesignerGridlinesShowMinorCaption);
  liAppearanceAxisGridlinesColor.Caption := cxGetResourceString(@sdxChartDesignerColorCaption);
  liAppearanceAxisGridlinesMinorColor.Caption := cxGetResourceString(@sdxChartDesignerColorCaption);
  liAppearanceAxisGridlinesThickness.Caption := cxGetResourceString(@sdxChartDesignerThicknessCaption);
  liAppearanceAxisGridlinesMinorThickness.Caption := cxGetResourceString(@sdxChartDesignerThicknessCaption);
  liAppearanceAxisGridlinesStyle.Caption := cxGetResourceString(@sdxChartDesignerStyleCaption);
  liAppearanceAxisGridlinesMinorStyle.Caption := cxGetResourceString(@sdxChartDesignerStyleCaption);

  liAxisValueLabelsAlignment.Caption := cxGetResourceString(@sdxChartDesignerAlignmentCaption);
  liAxisValueLabelsMaxLineCount.Caption := cxGetResourceString(@sdxChartDesignerMaxLineCountCaption);
  liAxisValueLabelsAngle.Caption := cxGetResourceString(@sdxChartDesignerAxisValueLabelsAngleCaption);
  liAxisValueLabelsPosition.Caption := cxGetResourceString(@sdxChartDesignerPositionCaption);
  liAxisValueLabelsMaxWidth.Caption := cxGetResourceString(@sdxChartDesignerMaxWidthCaption);
  lcbiAxisValueLabelsVisible.Caption := cxGetResourceString(@sdxChartDesignerVisibleCaption);
  lliAxisValueLabelsResolveOverlapping.Caption := cxGetResourceString(@sdxChartDesignerAxisValueLabelsResolveOverlapsCaption);
  liAxisValueLabelsResolveOverlappingIndent.Caption := cxGetResourceString(@sdxChartDesignerAxisValueLabelsResolveOverlappingIndentCaption);

  lcbiDiagramVisible.Caption := cxGetResourceString(@sdxChartDesignerVisibleCaption);
  liDiagramLayoutDirection.Caption := cxGetResourceString(@sdxChartDesignerLayoutDirectionCaption);
  liDiagramDimension.Caption := cxGetResourceString(@sdxChartDesignerDimensionCaption);
  lcbiDiagramRotated.Caption := cxGetResourceString(@sdxChartDesignerRotatedCaption);

  lliSeriesView.Caption := cxGetResourceString(@sdxChartDesignerViewCaption);
  liSeriesCaption.Caption := cxGetResourceString(@sdxChartDesignerCaptionCaption);
  liSeriesViewHoleRadius.Caption := cxGetResourceString(@sdxChartDesignerSeriesViewHoleRadiusCaption);
  liSeriesViewStartAngle.Caption := cxGetResourceString(@sdxChartDesignerSeriesViewStartAngleCaption);
  liSeriesViewSweepDirection.Caption := cxGetResourceString(@sdxChartDesignerSeriesViewSweepDirectionCaption);
  liSeriesViewExplodedValueMode.Caption := cxGetResourceString(@sdxChartDesignerSeriesViewExplodedValueModeCaption);

  lcbiFont.Caption := cxGetResourceString(@sdxChartDesignerEnabledCaption);
  lcbiBorder.Caption := cxGetResourceString(@sdxChartDesignerEnabledCaption);
  lcbiParentBackground.Caption := cxGetResourceString(@sdxChartDesignerEnabledCaption);
  lcbiSeriesTopNEnabled.Caption := cxGetResourceString(@sdxChartDesignerEnabledCaption);

  liPaddingAll.Caption := cxGetResourceString(@sdxChartDesignerOffsetAllCaption);
  liPaddingTop.Caption := cxGetResourceString(@sdxChartDesignerOffsetTopCaption);
  liPaddingLeft.Caption := cxGetResourceString(@sdxChartDesignerOffsetLeftCaption);
  liPaddingRight.Caption := cxGetResourceString(@sdxChartDesignerOffsetRightCaption);


  liPaddingBottom.Caption := cxGetResourceString(@sdxChartDesignerOffsetBottomCaption);

  liMarginAll.Caption := cxGetResourceString(@sdxChartDesignerOffsetAllCaption);
  liMarginTop.Caption := cxGetResourceString(@sdxChartDesignerOffsetTopCaption);
  liMarginLeft.Caption := cxGetResourceString(@sdxChartDesignerOffsetLeftCaption);
  liMarginRight.Caption := cxGetResourceString(@sdxChartDesignerOffsetRightCaption);
  liMarginBottom.Caption := cxGetResourceString(@sdxChartDesignerOffsetBottomCaption);

  lliAppearanceStroke.Caption := cxGetResourceString(@sdxChartDesignerStrokeCaption);
  liAppearanceStrokeColor.Caption := cxGetResourceString(@sdxChartDesignerColorCaption);
  liAppearanceStrokeStyle.Caption := cxGetResourceString(@sdxChartDesignerStyleCaption);
  liAppearanceStrokeThickness.Caption := cxGetResourceString(@sdxChartDesignerThicknessCaption);

  LocalizeEditors;
end;

procedure TfrmChartDesigner.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    Key := #0; // kp: mute when the enter is clamped for editors
end;

procedure TfrmChartDesigner.aUpAndDownExecute(Sender: TObject);
begin
  if not IsLocked and (TreeView.FocusedNode <> nil) then
    TNodeObject(TreeView.FocusedNode.Data).ChangeIndex(TAction(Sender).Tag);
end;

procedure TfrmChartDesigner.aUpAndDownUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := not IsLocked and (TreeView.FocusedNode <> nil) and
    TNodeObject(TreeView.FocusedNode.Data).CanChangeIndex(TAction(Sender).Tag);
end;

procedure TfrmChartDesigner.Delete(AObject: TObject);
var
  ANode: TdxTreeViewNode;
begin
  TreeView.BeginUpdate;
  try
    ANode := GetNodeByObject(AObject);
    ANode.Free;
  finally
    TreeView.EndUpdate;
  end;
  CustomizedChartControl.BeginUpdate;
  try
    AObject.Free;
  finally
    CustomizedChartControl.EndUpdate;
  end;
  Modified;
end;

procedure TfrmChartDesigner.DeleteDiagram(ADiagram: TdxChartCustomDiagram);
begin
  Delete(ADiagram);
end;

procedure TfrmChartDesigner.DeleteSeries(ASeries: TdxChartCustomSeries);
begin
  Delete(ASeries);
end;

procedure TfrmChartDesigner.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmChartDesigner.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := True;
  if IsDesigning or not FModified or FIsClosing then
    Exit;
  if ModalResult = mrOk then
    Exit;
  case dxMessageDlg(cxGetResourceString(@sdxChartDialogCloseConfirmation), mtConfirmation, mbYesNoCancel, 0) of
    mrYes:
      ModalResult := mrOk;
    mrNo:
      ModalResult := mrCancel;
  else
    CanClose := False;
  end;
end;

procedure TfrmChartDesigner.FormResize(Sender: TObject);
var
  ADelta: Integer;
  ATreeViewDelta: Integer;
  AOptionsDelta: Integer;
begin
  if IsLocked then
    Exit;
  if not TdxLayoutControlViewInfoAccess(lcMain.ViewInfo).IsValid then
    Exit;
  ADelta := ScaleFactor.Apply(ChartMinWidth) - CustomizedChartControl.Width + lcMain.ViewInfo.ContentWidth - lcMain.Width;
  if ADelta <= 0 then
    Exit;
  AOptionsDelta := lgAllOptions.Width - ScaleFactor.Apply(OptionsMinWidth);
  ATreeViewDelta := liTreeView.Width - ScaleFactor.Apply(TreeViewMinWidth);

  if AOptionsDelta + ATreeViewDelta = 0 then
    Exit;

  ATreeViewDelta := ADelta * ATreeViewDelta div (AOptionsDelta + ATreeViewDelta);
  lcMain.BeginUpdate;
  try
    liTreeView.Width := liTreeView.Width - ATreeViewDelta;
    lgAllOptions.Width := lgAllOptions.Width - ADelta + ATreeViewDelta;
  finally
    lcMain.EndUpdate;
  end;
end;

procedure TfrmChartDesigner.FormShow(Sender: TObject);
begin
  if ScaleFactor.TargetDPI <> dxGetMonitorDPI(Self.Handle) then
    Self.ScaleForCurrentDPI;

  lcMain.BeginUpdate;
  try
    if liTreeView.Width < ScaleFactor.Apply(TreeViewMinWidth) then
      liTreeView.Width := ScaleFactor.Apply(TreeViewMinWidth);
    if lgAllOptions.Width < ScaleFactor.Apply(OptionsMinWidth) then
      lgAllOptions.Width := ScaleFactor.Apply(OptionsMinWidth);
  finally
    lcMain.EndUpdate;
  end;
end;

procedure TfrmChartDesigner.SelectNode(ANode: TdxTreeViewNode);
var
  AParent: TdxTreeViewNode;
begin
  if ANode = nil then
    Exit;
  TreeView.BeginUpdate;
  try
    ANode.Focused := True;
    ANode.Selected := True;
    AParent := ANode.Parent;
    while AParent <> nil do
    begin
      AParent.Expanded := True;
      AParent := AParent.Parent;
    end;
  finally
    TreeView.EndUpdate;
    UpdateOptionsFromChart;
  end;
end;

procedure TfrmChartDesigner.SelectObject(AObject: TPersistent);
begin
  SelectNode(GetNodeByObject(AObject));
end;

procedure TfrmChartDesigner.ColorEditButtonClickHandler(Sender: TObject; AButtonIndex: Integer);
var
  AColor: TColor;
  AEdit: TdxColorEdit absolute Sender;
begin
  if AButtonIndex = 1 then
  begin
    AColor := AEdit.ColorValue;
    if TdxGlobalColorDialog.Execute(AColor, Handle) then
      AEdit.ColorValue := AColor;
  end;
end;

function TfrmChartDesigner.GetCustomizedChartControl: TdxCustomChartControl;
begin
  if FInnerChartControl <> nil then 
    Result := FInnerChartControl
  else
    Result := OriginalChartControl;
end;

procedure TfrmChartDesigner.ChartChangedHandler(Sender: TObject);
begin
  PostPopulateTreeView;
end;

function TfrmChartDesigner.GetNodeByData(AData: TObject): TdxTreeViewNode;

  function InnerGetNodeByData(ANode: TdxTreeViewNode): TdxTreeViewNode;
  begin
    if ANode.Data = AData then
      Exit(ANode);
    ANode := ANode.First;
    while ANode <> nil do
    begin
      Result := InnerGetNodeByData(ANode);
      if Result <> nil then
        Exit;
      ANode := ANode.Next;
    end;
    Result := nil;
  end;

begin
  Result := InnerGetNodeByData(TreeView.Root);
end;

procedure TfrmChartDesigner.Initialize;
begin
  llfMain.LookAndFeel.MasterLookAndFeel := FLookAndFeel;
  llfGroupCaptions.LookAndFeel.MasterLookAndFeel := FLookAndFeel;
  BiDiMode := FOriginalChartControl.BiDiMode;
  liOk.Visible := not IsDesigning;
  liCancel.Visible := not IsDesigning;
  aCancel.Visible := not IsDesigning;
  liClose.Visible := IsDesigning;
  aClose.Visible := IsDesigning;
  InitializeLayoutControl;
  InitializeColorEdits;
  ApplyLocalization;
  InitializeTreeView;
  cxDialogsMetricsStore.InitDialog(Self);
end;

procedure TfrmChartDesigner.InitializeColorEdits;

  procedure InitializeColorEdit(AEdit: TdxColorEdit);
  var
    AButton: TcxEditButton;
  begin
    AButton := AEdit.Properties.Buttons.Add;
    AButton.Kind := bkEllipsis;
    AButton.Visible := True;
    AButton.Hint := cxGetResourceString(@sdxChartDialogMoreColors);
    AEdit.Properties.OnButtonClick := ColorEditButtonClickHandler;
  end;

var
  I: Integer;
begin
  for I := 0 to lcMain.ControlCount - 1 do
    if lcMain.Controls[I] is TdxColorEdit then
      InitializeColorEdit(TdxColorEdit(lcMain.Controls[I]));
end;

procedure TfrmChartDesigner.InitializeHatchStyles(AImageComboBox: TcxImageComboBox;
  ABackColor, AForeColor: TdxAlphaColor);
var
  ABitmap: TcxBitmap;
  AFillStyle: TdxFillOptionsHatchStyle;
  ABrush: TcxCanvasBasedBrush;
begin
  if AImageComboBox.DroppedDown then
    Exit;
  AImageComboBox.ActiveProperties.BeginUpdate;
  ilHatch.BeginUpdate;
  try
    ilHatch.Clear;
    for AFillStyle := Low(AFillStyle) to High(AFillStyle) do
    begin
      ABitmap := TcxBitmap.CreateSize(ilHatch.Width, ilHatch.Height);
      try
        ABrush := ABitmap.cxCanvas.CreateBrush(TdxGPHatchBrush.Create(ABackColor, AForeColor, TdxGpHatchStyle(AFillStyle)), ooOwned);
        try
          ABitmap.cxCanvas.FillRect(ABitmap.ClientRect, ABrush);
        finally
          ABrush.Free;
        end;
        ilHatch.Add(ABitmap, nil);
        AImageComboBox.ActiveProperties.Items[Ord(AFillStyle)].ImageIndex := Ord(AFillStyle);
      finally
        ABitmap.Free;
      end;
    end;
  finally
    AImageComboBox.ActiveProperties.EndUpdate;
    ilHatch.EndUpdate;
  end;
end;

procedure TfrmChartDesigner.InitializeLayoutControl;
var
  I: Integer;
begin
  lgAllOptions.SizeOptions.Width := OptionsMinWidth;
  liTreeView.SizeOptions.Width := TreeViewMinWidth;
  for I := 0 to lcMain.AbsoluteItemCount - 1 do
    if lcMain.AbsoluteItems[I] is TdxLayoutCheckBoxItem then
      TdxLayoutCheckBoxItemAccess(lcMain.AbsoluteItems[I]).ShowFocusRect := False;
  UpdateLayoutLookAndFeel;
end;

procedure TfrmChartDesigner.InitializeTreeView;
begin
  TreeView.OptionsSelection.MultiSelect := IsDesigning;
  TreeView.CommandIcons := ilTreeViewCommands;
  TreeView.OptionsBehavior.CaptionEditing := False;
  TreeView.OptionsBehavior.HotTrack := True;
  TreeView.OptionsSelection.HideSelection := False;
  TreeView.OptionsSelection.RightClickSelect := True;
  TreeView.OptionsView.ShowEndEllipsis := True;
  TreeView.OptionsView.ShowLines := False;
  TreeView.StateImages := ilTreeView;
  TreeView.OnDeletion := TreeViewDeletionHandler;
  TreeView.OnSelectionChanged := TreeViewSelectionChangedHandler;
end;

procedure TfrmChartDesigner.lsiOptionsCanResize(Sender: TObject;
  AItem: TdxCustomLayoutItem; var ANewSize: Integer; var AAccept: Boolean);
begin
  AAccept := CanResizeOptions(ANewSize);
  if not AAccept then
    ANewSize := lgAllOptions.Width;
end;

procedure TfrmChartDesigner.lsiTreeViewCanResize(Sender: TObject;
  AItem: TdxCustomLayoutItem; var ANewSize: Integer; var AAccept: Boolean);
begin
  if ANewSize > liTreeView.Width then
    AAccept := CustomizedChartControl.Width + liTreeView.Width - ANewSize > ScaleFactor.Apply(ChartMinWidth)
  else
    AAccept := ANewSize > ScaleFactor.Apply(TreeViewMinWidth);
  if not AAccept then
    ANewSize := liTreeView.Width;
end;

procedure TfrmChartDesigner.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  if OriginalChartControl.HandleAllocated then
    Params.WndParent := OriginalChartControl.Handle;
end;

procedure TfrmChartDesigner.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if AComponent = FOriginalChartControl then
    begin
      FIsClosing := True;
      FOriginalChartControl := nil;
      BeginUpdate;
      ClearTreeView;
      Close;
    end;
  end;
end;

procedure TfrmChartDesigner.PostPopulateTreeView;
begin
  tPopulateTreeView.Enabled := False;
  tPopulateTreeView.Enabled := not tUpdateOptionsFromChart.Enabled and
    not tPostEditValueUpdate.Enabled and not FLockRefreshTreeView;
end;

procedure TfrmChartDesigner.tPopulateTreeViewTimer(Sender: TObject);
begin
  tPopulateTreeView.Enabled := False;
  if GetCaptureControl = nil then
    PopulateTreeView
  else
    PostPopulateTreeView;
end;

procedure TfrmChartDesigner.PopulateTreeView;

  procedure GetCollapsedNodeObjects(AList: TList; AParent: TdxTreeViewNode);
  var
    I: Integer;
  begin
    if AParent.Count > 0 then
    begin
      if not AParent.Expanded then
        AList.Add(TNodeObject(AParent.Data).&Object);
      for I := 0 to AParent.Count - 1 do
        GetCollapsedNodeObjects(AList, AParent.Items[I]);
    end;
  end;

  procedure CollapseNodes(AList: TList);
  var
    I: Integer;
    ANode: TdxTreeViewNode;
  begin
    TreeView.Root.Expand(True);
    for I := 0 to AList.Count - 1 do
    begin
      ANode := GetNodeByObject(AList[I]);
      if ANode <> nil then
        ANode.Expanded := False;
    end;
  end;

var
  ASelection: TList;
  ACollapsed: TList;
begin
  if IsLocked or (csDestroying in ComponentState) then
    Exit;
  if not IsValid then
  begin
    ClearTreeView;
    Exit;
  end;

  TreeView.Root.BeginUpdate;
  try
    BeginUpdate;
    try
      ACollapsed := TList.Create;
      ASelection := TList.Create;
      try
        GetCollapsedNodeObjects(ACollapsed, TreeView.Root);
        GetSelectedNodeObjects(ASelection);
        TreeView.Root.Clear;
        CreateNode(TreeView.Root, CustomizedChartControl, TChartControlNodeObject);
        CollapseNodes(ACollapsed);
        SetTreeViewSelection(ASelection);
      finally
        ASelection.Free;
        ACollapsed.Free;
      end;
    finally
      EndUpdate;
    end;
    UpdateOptionsFromChart;
  finally
    TreeView.Root.EndUpdate;
  end;
end;

procedure TfrmChartDesigner.PopupTreeViewMenu(APopupMenu: TPopupMenu; const P: TPoint);

  procedure UpdateMenu(AMenu: TMenuItem);
  var
    I: Integer;
  begin
    if AMenu.Action <> nil then
      AMenu.Action.Update;
    for I := 0 to AMenu.Count - 1 do
      UpdateMenu(AMenu.Items[I]);
  end;

begin
  UpdateMenu(APopupMenu.Items);
  Application.ProcessMessages;
  FPopupMenu.Popup(TreeView, APopupMenu, P);
end;

procedure TfrmChartDesigner.PostUpdateEditValue(AEditor: TcxCustomEdit);
var AEnabled: Boolean;
begin
  AEnabled := tPostEditValueUpdate.Enabled;
  if FPostUpdateEditor <> AEditor then
  begin
    if AEnabled and (FPostUpdateEditor <> nil) then
      FPostUpdateEditor.PostValue;
    if (AEditor <> nil) and not (AEditor is TcxSpinEdit) then
      AEditor.PostValue;
  end;
  FPostUpdateEditor := AEditor;
  tPostEditValueUpdate.Enabled := AEnabled or (FPostUpdateEditor <> nil);
  StartUpdateOptionsFromChartTimer;
end;

procedure TfrmChartDesigner.OptionDisplayValueChange(Sender: TObject);
begin
  if not IsLocked and (Sender is TcxCustomEdit) and TcxCustomEdit(Sender).NeedUpdateChartValue then
    PostUpdateEditValue(TcxCustomEdit(Sender));
end;

procedure TfrmChartDesigner.BeginUpdate;
begin
  Inc(FLockCount);
end;

procedure TfrmChartDesigner.EndUpdate;
begin
  Dec(FLockCount);
end;

function TfrmChartDesigner.IsLocked: Boolean;
begin
  Result := (FLockCount > 0) or (OriginalChartControl = nil) or
    (csDestroying in OriginalChartControl.ComponentState) or not FInitialized;
end;

procedure TfrmChartDesigner.ApplyChanges;
begin
  if OriginalChartControl <> CustomizedChartControl then 
  begin
    CustomizedChartControl.ScaleBy(ScaleFactor.Denominator, ScaleFactor.Numerator);
    CustomizedChartControl.ScaleBy(TdxCustomChartControlAccess(OriginalChartControl).ScaleFactor.Numerator,
      TdxCustomChartControlAccess(OriginalChartControl).ScaleFactor.Denominator);
    OriginalChartControl.Assign(CustomizedChartControl);
  end;
end;

function TfrmChartDesigner.CanAddDiagram: Boolean;
begin
  Result := IsDesigning;
end;

function TfrmChartDesigner.CanAddSeries: Boolean;
begin
  Result := IsDesigning;
end;

function TfrmChartDesigner.IsDesigning: Boolean;
begin
  Result := False;
end;

function TfrmChartDesigner.IsValid: Boolean;
begin
  Result := FOriginalChartControl <> nil;
end;

function TfrmChartDesigner.CanDelete(AComponent: TComponent): Boolean;
begin
  Result := IsDesigning;
end;

function TfrmChartDesigner.GetNodeByObject(AObject: TObject): TdxTreeViewNode;

  function InnerGetNodeByObject(ANode: TdxTreeViewNode): TdxTreeViewNode;
  begin
    if (ANode.Data <> nil) and (TNodeObject(ANode.Data).&Object = AObject) then
      Exit(ANode);
    ANode := ANode.First;
    while ANode <> nil do
    begin
      Result := InnerGetNodeByObject(ANode);
      if Result <> nil then
        Exit;
      ANode := ANode.Next;
    end;
    Result := nil;
  end;

begin
  Result := InnerGetNodeByObject(TreeView.Root);
end;

procedure TfrmChartDesigner.GetSelectedNodeObjects(AList: TList);
var
  I: Integer;
begin
  for I := 0 to TreeView.SelectionCount - 1 do
    if (TreeView.Selections[I].Data <> nil) and (TNodeObject(TreeView.Selections[I].Data).&Object <> nil) then
      AList.Add(TNodeObject(TreeView.Selections[I].Data).&Object);
end;

procedure TfrmChartDesigner.Modified;
begin
  FModified := True;
  SetDesignerModified(OriginalChartControl);
end;

procedure TfrmChartDesigner.SetTreeViewSelection(ASelection: TList);
var
  I: Integer;
  ANode: TdxTreeViewNode;
begin
  TreeView.BeginUpdate;
  try
    TreeView.FocusedNode := nil;
    TreeView.ClearSelection;
    for I := 0 to ASelection.Count - 1 do
    begin
      ANode := GetNodeByObject(ASelection[I]);
      if ANode <> nil then
        ANode.Selected := True;
    end;
    if TreeView.SelectionCount > 0 then
      SelectNode(TreeView.Selections[0])
    else
      SelectNode(GetNodeByObject(CustomizedChartControl));
  finally
    TreeView.EndUpdate;
  end;
end;

procedure TfrmChartDesigner.SyncSelection;
begin
// do nothing
end;

procedure TfrmChartDesigner.OptionEditValueChanged(Sender: TObject);
var
  I: Integer;
begin
  if IsLocked or (TreeView.FocusedNode = nil) then
    Exit;
  FLockRefreshTreeView := True;
  try
    BeginUpdate;
    try
      for I := 0 to TreeView.SelectionCount - 1 do
        TNodeObject(TreeView.Selections[I].Data).ApplyChangedValueToChart(Sender);
      Modified;
    finally
      EndUpdate;
    end;
  finally
    FLockRefreshTreeView := False;
  end;
  PostUpdateEditValue(nil);
end;


procedure TfrmChartDesigner.tPostEditValueUpdateTimer(Sender: TObject);
var
  APostUpdateEditor: TcxCustomEdit;
begin
  tPostEditValueUpdate.Enabled := False;
  if FPostUpdateEditor <> nil then
  begin
    APostUpdateEditor := FPostUpdateEditor;
    FPostUpdateEditor := nil;
    APostUpdateEditor.PostValue;
  end;
  StartUpdateOptionsFromChartTimer;
end;

procedure TfrmChartDesigner.StartUpdateOptionsFromChartTimer;
begin
  tUpdateOptionsFromChart.Enabled:= False;
  tUpdateOptionsFromChart.Enabled:= not tPostEditValueUpdate.Enabled and
    not tPopulateTreeView.Enabled and not FLockUpdateOptionsFromChart;
end;

procedure TfrmChartDesigner.tUpdateOptionsFromChartTimer(Sender: TObject);
begin
  tUpdateOptionsFromChart.Enabled:= False;
  UpdateOptionsFromChart;
  if IsLocked or TdxChartCustomItemViewInfoAccess(TdxChartAccess(TdxCustomChartControlAccess(CustomizedChartControl).Chart).ViewInfo).Dirty then
    StartUpdateOptionsFromChartTimer;
end;

procedure TfrmChartDesigner.TreeViewDeletionHandler(Sender: TdxCustomTreeView;
  Node: TdxTreeViewNode);
var
  ANextNode: TdxTreeViewNode;
  AData: TdxChartDesignerTreeViewNodeData;
begin
  AData := TdxChartDesignerTreeViewNodeData(Node.Data);
  AData.SetDirty;
  Node.Data := nil;
  AData.Free;
  if not IsLocked and (Node.Selected or Node.Focused) then
  begin
    ANextNode := Node.Next;
    if ANextNode = nil then
      ANextNode := Node.Prev;
    if ANextNode = nil then
      ANextNode := Node.Parent;
    if ANextNode <> nil then
      SelectNode(ANextNode);
  end;
end;

procedure TfrmChartDesigner.TreeViewSelectionChangedHandler(Sender: TObject);
begin
  if not IsLocked then
  begin
    FLockUpdateOptionsFromChart := True;
    try
      PostUpdateEditValue(nil);
    finally
      FLockUpdateOptionsFromChart := False;
    end;
    UpdateOptionsFromChart;
  end;
  SyncSelection;
end;

procedure TfrmChartDesigner.DXMScaleChanging(var Message: TMessage);
begin
  BeginUpdate;
  lcMain.BeginUpdate;
  inherited;
end;

procedure TfrmChartDesigner.DXMScaleChanged(var Message: TMessage);
begin
  inherited;
  lcMain.EndUpdate(False);
  EndUpdate;
  UpdateOptionsFromChart;
end;

function TfrmChartDesigner.GetObject: TObject;
begin
  Result := Self;
end;

procedure TfrmChartDesigner.MasterLookAndFeelChanged(Sender: TcxLookAndFeel; AChangedValues: TcxLookAndFeelValues);
begin
  UpdateLayoutLookAndFeel;
end;

procedure TfrmChartDesigner.MasterLookAndFeelDestroying(Sender: TcxLookAndFeel);
begin
  llfMain.LookAndFeel.MasterLookAndFeel := nil;
  llfGroupCaptions.LookAndFeel.MasterLookAndFeel := nil;
end;

procedure TfrmChartDesigner.MasterLookAndFeelBeginChange;
begin
  BeginUpdate;
  lcMain.BeginUpdate;
end;

procedure TfrmChartDesigner.MasterLookAndFeelEndChange;
begin
  lcMain.EndUpdate(False);
  EndUpdate;
  UpdateOptionsFromChart;
end;

function TfrmChartDesigner.GetInfoData: Pointer;
begin
  FDesignerSessionData.TreeViewWidth := ScaleFactor.Revert(liTreeView.Width);
  FDesignerSessionData.OptionsWidth := ScaleFactor.Revert(lgAllOptions.Width);
  Result := @FDesignerSessionData;
end;

function TfrmChartDesigner.GetInfoDataSize: Integer;
begin
  Result := SizeOf(TDesignerSessionData);
end;

procedure TfrmChartDesigner.SetInfoData(AData: Pointer);
begin
  Move(AData^, FDesignerSessionData, GetInfoDataSize);
  liTreeView.Width := FDesignerSessionData.TreeViewWidth;
  lgAllOptions.Width := FDesignerSessionData.OptionsWidth;
end;

procedure TfrmChartDesigner.UpdateLayoutLookAndFeel;
begin
end;

procedure TfrmChartDesigner.UpdateOptionsFromChart;
begin
  if IsLocked then
    Exit;
  DoUpdateOptionsFromChart;
end;

procedure TfrmChartDesigner.ClearTreeView;
begin
  TreeView.Root.BeginUpdate;
  try
    BeginUpdate;
    try
      TreeView.Root.Clear;
    finally
      EndUpdate;
    end;
    UpdateOptionsFromChart;
  finally
    TreeView.Root.EndUpdate;
  end;
end;

function TfrmChartDesigner.CreateNode(AParentNode: TdxTreeViewNode; AObject: TPersistent; ANodeObjectClass: TClass): TdxTreeViewNode;
var
  ANodeObject: TNodeObject;
begin
  if (AObject is TComponent) and (csDestroying in TComponent(AObject).ComponentState) then
    Exit(nil);
  ANodeObject := TNodeObjectClass(ANodeObjectClass).Create(Self, AObject);
  Result := AParentNode.AddChild(ANodeObject.Caption, ANodeObject);
  Result.StateImageIndex := ANodeObject.ImageIndex;
  Result.Enabled := ANodeObject.IsEnabled;
  ANodeObject.CreateSubNodes;
end;

procedure TfrmChartDesigner.DoUpdateOptionsFromChart;
var
  ANodeObject: TNodeObject;
  AGroup: TdxLayoutGroup;
begin

  BeginUpdate;
  lcMain.BeginUpdate;
  try
    while lgOptions.Count > 0 do
      lgOptions.Items[0].Parent := nil;
    if TreeView.SelectionCount > 0 then
    begin
      ANodeObject := TNodeObject(TreeView.Selections[0].Data);
      AGroup := ANodeObject.GetOptionsGroup;
      if AGroup <> nil then
        AGroup.Parent := lgOptions;
      ANodeObject.DoUpdateOptionsFromChart;
    end;
  finally
    lcMain.EndUpdate;
    EndUpdate;
  end;
end;

function TfrmChartDesigner.GetCustomizedScaleFactor: TdxScaleFactor;
begin
  Result := TdxCustomChartControlAccess(CustomizedChartControl).ScaleFactor;
end;

procedure TfrmChartDesigner.FirstTimePopulateTreeView;

  procedure ExpandTreeView(ANode: TdxTreeViewNode);
  var
    I: Integer;
  begin
    if ANode.Level >= 2 then
      Exit;
    ANode.Expand(False);
    for I := 0 to ANode.Count - 1 do
      ExpandTreeView(ANode.Items[I]);
  end;

  procedure InitializeSpinEditFormats;
  var
    I: Integer;
    ASpinEdit: TcxSpinEdit;
  begin
    for I := 0 to lcMain.ControlCount - 1 do
    begin
      ASpinEdit :=  Safe<TcxSpinEdit>.Cast(lcMain.Controls[I]);
      if ASpinEdit <> nil then
        ASpinEdit.InitializeFormats;
    end;
  end;

begin
  InitializeSpinEditFormats;
  PopulateTreeView;
  TreeView.Root.Collapse(True);
  ExpandTreeView(TreeView.Root);
  StartUpdateOptionsFromChartTimer;
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TDiagramNodeObject.Initialize;
  TDiagramSeriesNodeObject.Initialize;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TDiagramSeriesNodeObject.Finalize;
  TDiagramNodeObject.Finalize;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
