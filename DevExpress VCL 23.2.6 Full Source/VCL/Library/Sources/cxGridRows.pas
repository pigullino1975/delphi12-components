{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressQuantumGrid                                       }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSQUANTUMGRID AND ALL            }
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

unit cxGridRows;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Types, Windows, Classes, Graphics, Controls, Forms, StdCtrls, Contnrs, ImgList,
  dxCore, cxClasses, cxControls, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  dxCoreClasses, cxCustomData, cxPC, cxGridCommon, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDetailsSite, cxScrollBar, cxImageComboBox,
  cxGridInplaceEditForm, cxFilterControlUtils, cxListBox, cxGeometry, dxTypeHelpers,
  cxGridViewLayoutContainer, cxGridRowLayout;

const
  htPreview = htGridBase + 31;
  htInplaceEditFormAreaScrollBar = htGridBase + 32;
  htInplaceEditFormButton = htGridBase + 33;
  htInplaceEditFormCancelButton = htGridBase + 34;
  htInplaceEditFormUpdateButton = htGridBase + 35;
  htInplaceEditFormButtonsPanel = htGridBase + 36;
  htInplaceEditFormArea = htGridBase + 37;
  htFilterRowOperator = htGridBase + 38;

  cxGridFixedGroupIndicatorRightIndent = 4;
  cxGridInplaceEditFormButtonsOffset = 15;
  cxGridInplaceEditFormButtonsTopOffset = 7;
  cxGridInplaceEditFormButtonsBottomOffset = 11;
  cxGridInplaceEditFormButtonMinHeight = 23;
  cxGridInplaceEditFormButtonMinWidth = 76;
  cxGridInplaceEditFormScrollBarSmallChange = 4;
  cxGridInplaceEditFormScrollBarLargeChange = 50;
  cxGridDataCellCheckBoxLeftMargin = 4;
  cxGridDataCellCheckBoxRightMargin = 2;

type
  TcxGridDataCellViewInfoClass = class of TcxGridDataCellViewInfo;
  TcxGridDataCellViewInfo = class;
  TcxGridDataRowCellsAreaViewInfo = class;
  TcxGridDataRowViewInfo = class;
  TcxGridNewItemRowViewInfo = class;
  TcxGridFilterRowViewInfo = class;
  TcxGridGroupCellViewInfo = class;
  TcxGridGroupSummaryCellViewInfo = class;
  TcxGridGroupRowViewInfo = class;
  TcxGridMasterDataRowDetailsSiteLeftTabsViewInfo = class;
  TcxGridDetailsSiteViewInfo = class;
  TcxGridExpandButtonCellViewInfo = class;
  TcxGridMasterDataRowViewInfo = class;
  TcxGridRowLayoutViewInfo = class;
  TcxGridInplaceEditFormAreaViewInfo = class;
  TcxGridInplaceEditFormAreaScrollBarViewInfo = class;
  TcxGridInplaceEditFormButtonsPanelViewInfo = class;
  TcxGridInplaceEditFormButtonViewInfo = class;
  TcxGridFilterRowCellViewInfo = class;
  TcxGridFilterRowOperatorViewInfo = class;
  TcxGridDataCellCheckBoxAreaViewInfo = class;
  TcxGridGroupCellImageViewInfo = class;
  TcxGridGroupRowGroupedColumnAreaViewInfo = class;
  TcxGridDataCellPinViewInfo = class;

  { hit tests }

  TcxGridPreviewHitTest = class(TcxGridRecordCellHitTest)
  protected
    class function GetHitTestCode: Integer; override;
  end;

  TcxGridInplaceEditFormButtonHitTest = class(TcxCustomGridViewHitTest)
  protected
    class function GetHitTestCode: Integer; override;
  end;

  TcxGridInplaceEditFormCancelButtonHitTest = class(TcxCustomGridViewHitTest)
  protected
    class function GetHitTestCode: Integer; override;
  end;

  TcxGridInplaceEditFormUpdateButtonHitTest = class(TcxCustomGridViewHitTest)
  protected
    class function GetHitTestCode: Integer; override;
  end;

  TcxGridInplaceEditFormButtonsPanelHitTest = class(TcxCustomGridViewHitTest)
  protected
    class function GetHitTestCode: Integer; override;
  end;

  TcxGridInplaceEditFormAreaHitTest = class(TcxCustomGridViewHitTest)
  protected
    class function GetHitTestCode: Integer; override;
  end;

  TcxGridFilterRowOperatorHitTest = class(TcxCustomGridViewHitTest)
  protected
    class function GetHitTestCode: Integer; override;
  end;

  TcxGridGroupCellHitTest = class(TcxGridRecordHitTest);

  { painters }

  { TcxGridDataCellCheckBoxAreaPainter }

  TcxGridDataCellCheckBoxAreaPainter = class(TcxCustomGridCellPainter)
  private
    function GetViewInfo: TcxGridDataCellCheckBoxAreaViewInfo;
  protected
    procedure DrawContent; override;

    property ViewInfo: TcxGridDataCellCheckBoxAreaViewInfo read GetViewInfo;
  end;

  { TcxGridDataCellPainter }

  TcxGridDataCellPainter = class(TcxGridTableDataCellPainter)
  private
    function GetViewInfo: TcxGridDataCellViewInfo;
  protected
    function CanDelayedDrawBorder: Boolean;
    procedure DrawBorder(ABorder: TcxBorder); override;
    procedure DrawContent; override;
    procedure DrawEditViewInfo; override;
    procedure DrawFixedHighlight; virtual;
    function ExcludeFromClipRect: Boolean; override;
    property ViewInfo: TcxGridDataCellViewInfo read GetViewInfo;
  end;

  { TcxGridFilterRowOperatorPainter }

  TcxGridFilterRowOperatorPainter = class(TcxCustomGridCellPainter)
  private
    function GetViewInfo: TcxGridFilterRowOperatorViewInfo;
  protected
    procedure DrawContent; override;
    function NeedDrawButton: Boolean; virtual;

    property ViewInfo: TcxGridFilterRowOperatorViewInfo read GetViewInfo;
  end;

  { TcxGridFilterRowCellPainter }

  TcxGridFilterRowCellPainter = class(TcxGridDataCellPainter)
  private
    function GetViewInfo: TcxGridFilterRowCellViewInfo;
  protected
    procedure DrawContent; override;

    property ViewInfo: TcxGridFilterRowCellViewInfo read GetViewInfo;
  end;

  { TcxGridRowLayoutPainter }

  TcxGridRowLayoutPainter = class(TcxCustomGridCellPainter)
  strict private
    function GetViewInfo: TcxGridRowLayoutViewInfo;
  protected
    procedure DrawBackground; override;
    procedure DrawContent; override;
    procedure DrawGroups; virtual;
    procedure DrawItems; virtual;

    property ViewInfo: TcxGridRowLayoutViewInfo read GetViewInfo;
  end;

  { TcxGridInplaceEditFormButtonPainter }

  TcxGridInplaceEditFormButtonPainter = class(TcxGridCustomButtonPainter)
  private
    function GetViewInfo: TcxGridInplaceEditFormButtonViewInfo;
  protected
    function CanDrawFocusRect: Boolean; override;
    procedure DrawButton; virtual;
    function ExcludeFromClipRect: Boolean; override;
    function GetGridViewInfo: TcxCustomGridViewInfo; override;
    procedure Paint; override;

    property ViewInfo: TcxGridInplaceEditFormButtonViewInfo read GetViewInfo;
  end;

  { TcxGridInplaceEditFormButtonsPanelPainter }

  TcxGridInplaceEditFormButtonsPanelPainter = class(TcxCustomGridCellPainter)
  private
    function GetViewInfo: TcxGridInplaceEditFormButtonsPanelViewInfo;
  protected
    procedure DrawBackground; override;
    procedure DrawButtons; virtual;
    procedure DrawContent; override;
    procedure DrawSeparator; virtual;

    property ViewInfo: TcxGridInplaceEditFormButtonsPanelViewInfo read GetViewInfo;
  end;

  { TcxGridInplaceEditFormAreaPainter }

  TcxGridInplaceEditFormAreaPainter = class(TcxCustomGridCellPainter)
  private
    function GetViewInfo: TcxGridInplaceEditFormAreaViewInfo;
  protected
    procedure DrawBackground; override;
    procedure DrawButtonsPanel; virtual;
    procedure DrawContent; override;
    procedure DrawGridViewItems; virtual;
    procedure DrawInplaceEditFormContainer; virtual;
    procedure DrawLayoutGroups;

    property ViewInfo: TcxGridInplaceEditFormAreaViewInfo read GetViewInfo;
  end;

  { TcxGridDataRowPainter }

  TcxGridDataRowPainter = class(TcxCustomGridRowPainter)
  private
    function GetViewInfo: TcxGridDataRowViewInfo;
  protected
    procedure DrawBackground; override;
    procedure DrawCells; virtual;
    procedure DrawFixedRowsSeparator; virtual;
    procedure DrawInplaceEditFormArea; virtual;
    procedure DrawLayout; virtual;
    procedure DrawLayoutBackground; virtual;
    procedure DrawTopRightEmptyArea; virtual;
    function ExcludeFromClipRect: Boolean; override;
    function GetShowCells: Boolean; virtual;
    procedure Paint; override;

    property ShowCells: Boolean read GetShowCells;
    property ViewInfo: TcxGridDataRowViewInfo read GetViewInfo;
  end;

  { TcxGridNewItemRowPainter }

  TcxGridNewItemRowPainter = class(TcxGridDataRowPainter)
  private
    function GetViewInfo: TcxGridNewItemRowViewInfo;
  protected
    procedure DrawBackground; override;
    procedure DrawSeparator; override;
    function ExcludeFromClipRect: Boolean; override;
    function GetShowCells: Boolean; override;
    procedure Paint; override;
    property ViewInfo: TcxGridNewItemRowViewInfo read GetViewInfo;
  end;

  { TcxGridMasterDataRowDetailsSiteTabsPainter }

  TcxGridMasterDataRowDetailsSiteTabsPainter = class(TcxGridDetailsSiteTabsPainter)
  private
    function GetViewInfo: TcxGridMasterDataRowDetailsSiteLeftTabsViewInfo;
  protected
    procedure DrawBottomGridLine; virtual;
    procedure Paint; override;

    property ViewInfo: TcxGridMasterDataRowDetailsSiteLeftTabsViewInfo read GetViewInfo;
  end;

  { TcxGridExpandButtonCellPainter }

  TcxGridExpandButtonCellPainter = class(TcxCustomGridCellPainter)
  private
    function GetViewInfo: TcxGridExpandButtonCellViewInfo;
  protected
    procedure DrawBackground(const R: TRect); override;
    procedure DrawBorder(ABorder: TcxBorder); override;
    property ViewInfo: TcxGridExpandButtonCellViewInfo read GetViewInfo;
  end;

  { TcxGridMasterDataRowPainter }

  TcxGridMasterDataRowPainter = class(TcxGridDataRowPainter)
  private
    function GetRealCellsBounds: TRect;
    function GetViewInfo: TcxGridMasterDataRowViewInfo;
  protected
    procedure DrawCells; override;
    procedure DrawDetailsSite; virtual;
    procedure DrawExpandButtonCell; virtual;
    procedure ExcludeFromBackground; override;
    function GetExpandButtonState: TcxExpandButtonState; override;
    function NeedsPainting: Boolean; override;
    procedure Paint; override;

    property ViewInfo: TcxGridMasterDataRowViewInfo read GetViewInfo;
  end;

  { TcxGridGroupCellImagePainter }

  TcxGridGroupCellImagePainter = class(TcxCustomGridCellPainter)
  private
    function GetViewInfo: TcxGridGroupCellImageViewInfo;
  protected
    procedure DrawContent; override;
    procedure DrawImage; virtual;

    property ViewInfo: TcxGridGroupCellImageViewInfo read GetViewInfo;
  end;

  { TcxGridGroupCellPainter }

  TcxGridGroupCellPainter = class(TcxCustomGridCellPainter)
  private
    function GetViewInfo: TcxGridGroupCellViewInfo;
  protected
    procedure DrawBackground(const R: TRect); override;
    procedure DrawBorder(ABorder: TcxBorder); override;
    procedure DrawContent; override;

    property ViewInfo: TcxGridGroupCellViewInfo read GetViewInfo;
  end;

  { TcxGridGroupSummaryCellPainter }

  TcxGridGroupSummaryCellPainter = class(TcxCustomGridCellPainter)
  private
    function GetViewInfo: TcxGridGroupSummaryCellViewInfo;
  protected
    procedure Paint; override;

    property ViewInfo: TcxGridGroupSummaryCellViewInfo read GetViewInfo;
  end;

  { TcxGridGroupRowGroupedColumnAreaPainter }

  TcxGridGroupRowGroupedColumnAreaPainter = class(TcxCustomGridCellPainter)
  private
    function GetViewInfo: TcxGridGroupRowGroupedColumnAreaViewInfo;
  protected
    procedure DrawCell; virtual;
    procedure DrawSeparator; virtual;
    procedure DrawSummary; virtual;
    procedure DrawSummaryBeginningSpacer; virtual;
    procedure DrawSummaryCells; virtual;
    procedure DrawSummaryEndingSpacer; virtual;
    procedure Paint; override;

    property ViewInfo: TcxGridGroupRowGroupedColumnAreaViewInfo read GetViewInfo;
  end;

  { TcxGridGroupRowPainter }

  TcxGridGroupRowPainter = class(TcxCustomGridRowPainter)
  private
    function GetViewInfo: TcxGridGroupRowViewInfo;
  protected
    procedure DrawBackground; override;
    procedure DrawFixedGroupIndicator; virtual;
    procedure DrawGroupedColumnAreas; virtual;
    procedure DrawSeparator; override;
    function ExcludeFromClipRect: Boolean; override;
    procedure Paint; override;

    property ViewInfo: TcxGridGroupRowViewInfo read GetViewInfo;
  end;

  { view infos }

  { TcxGridCellViewInfo }

  TcxGridCellViewInfo = class(TcxGridTableCellViewInfo)
  private
    function GetGridView: TcxGridTableView;
    function GetGridLines: TcxGridLines;
    function GetGridRecord: TcxCustomGridRow;
    function GetGridViewInfo: TcxGridTableViewInfo;
    function GetRecordViewInfo: TcxCustomGridRowViewInfo;
  protected
    function GetBorderColor(AIndex: TcxBorder): TColor; override;
    function GetBorderWidth(AIndex: TcxBorder): Integer; override;
    procedure GetViewParams(var AParams: TcxViewParams); override;

    property GridLines: TcxGridLines read GetGridLines;
  public
    property GridRecord: TcxCustomGridRow read GetGridRecord;
    property GridView: TcxGridTableView read GetGridView;
    property GridViewInfo: TcxGridTableViewInfo read GetGridViewInfo;
    property RecordViewInfo: TcxCustomGridRowViewInfo read GetRecordViewInfo;
  end;

  // data row

  { TcxGridPinViewInfo }

  TcxGridDataCellPinViewInfo = class(TcxGridPinViewInfo)
  private
    FCellViewInfo: TcxGridDataCellViewInfo;

    function GetGridView: TcxGridTableView;
    function GetOptions: TcxGridFixedDataRowsOptions;
    function GetRowViewInfo: TcxGridDataRowViewInfo;
  protected
    function CalculateHeight: Integer; override;
    function CalculatePinned: Boolean; override;
    function CanDrawImage: Boolean; override;
    function CanToggle: Boolean; override;
    function GetImageSize: TSize; override;
    procedure GetViewParams(var AParams: TcxViewParams); override;
    procedure Toggle; override;

    property CellViewInfo: TcxGridDataCellViewInfo read FCellViewInfo;
    property Options: TcxGridFixedDataRowsOptions read GetOptions;
    property RowViewInfo: TcxGridDataRowViewInfo read GetRowViewInfo;
  public
    constructor Create(ACellViewInfo: TcxGridDataCellViewInfo); reintroduce; virtual;

    function MouseDown(AHitTest: TcxCustomGridHitTest; AButton: TMouseButton; AShift: TShiftState): Boolean; override;

    property GridView: TcxGridTableView read GetGridView;
  end;

  { TcxGridDataCellCheckBoxAreaViewInfo }

  TcxGridDataCellCheckBoxAreaViewInfo = class(TcxCustomGridViewCellViewInfo)
  private
    FDataCell: TcxGridDataCellViewInfo;
    FCheckBox: TcxGridRowCheckBoxViewInfo;
  protected
    function CalculateHeight: Integer; override;
    function CalculateWidth: Integer; override;
    function CreateCheckBox: TcxGridRowCheckBoxViewInfo; virtual;
    function GetCheckBoxBounds: TRect; virtual;
    function GetHeight: Integer; override;
    function GetHitTestClass: TcxCustomGridHitTestClass; override;
    function GetMargins: TRect; virtual;
    function GetPainterClass: TcxCustomGridCellPainterClass; override;
    procedure GetViewParams(var AParams: TcxViewParams); override;
    function GetWidth: Integer; override;
    function IsChildrenHotTracked: Boolean; override;
    procedure Offset(DX, DY: Integer); override;
    procedure ResetChildrenState; override;

    property DataCell: TcxGridDataCellViewInfo read FDataCell;
    property CheckBox: TcxGridRowCheckBoxViewInfo read FCheckBox;
    property CheckBoxBounds: TRect read GetCheckBoxBounds;
  public
    constructor Create(ACellViewInfo: TcxGridDataCellViewInfo); reintroduce; virtual;
    destructor Destroy; override;

    procedure AfterRecalculation; override;
    procedure BeforeRecalculation; override;
    procedure Calculate(ALeftBound: Integer; ATopBound: Integer; AWidth: Integer = -1; AHeight: Integer = -1); override;
    procedure DoRightToLeftConversion(const ABounds: TRect); override;
    function GetHitTest(const P: TPoint): TcxCustomGridHitTest; override;
  end;

  { TcxGridDataCellViewInfo }

  TcxGridDataCellViewInfo = class(TcxGridTableDataCellViewInfo)
  private
    FCheckBoxArea: TcxGridDataCellCheckBoxAreaViewInfo;
    FIsMerged: Boolean;
    FIsMerging: Boolean;
    FMergedCells: TList;
    FMergingCell: TcxGridDataCellViewInfo;
    FOriginalHeight: Integer;
    FPin: TcxGridDataCellPinViewInfo;

    function GetCacheItem: TcxGridTableViewInfoCacheItem;
    function GetGridView: TcxGridTableView;
    function GetGridViewInfo: TcxGridTableViewInfo;
    function GetItem: TcxGridColumn;
    function GetMergedCell(Index: Integer): TcxGridDataCellViewInfo;
    function GetMergedCellCount: Integer;
    function GetMergedCellOfFocusedRow: TcxGridDataCellViewInfo;
    function GetRecordViewInfo: TcxGridDataRowViewInfo;
  protected
    OriginalBounds: TRect;
    procedure AfterRowsViewInfoCalculate; virtual;
    procedure AfterRowsViewInfoOffset; virtual;
    function CalculateSelected: Boolean; override;
    function CalculateWidth: Integer; override;
    function CanBeMergingCell: Boolean; virtual;
    function CanCellMerging: Boolean; virtual;
    function DrawHotTrackedWhenRecordHotTracked: Boolean; override;
    function GetAlwaysSelected: Boolean; override;
    function GetBorderColor(AIndex: TcxBorder): TColor; override;
    function GetBorders: TcxBorders; override;
    function GetBorderWidth(AIndex: TcxBorder): Integer; override;
    function GetEditViewDataBounds: TRect; override;
    function GetFixedKind: TcxGridColumnFixedKind; virtual;
    function GetFocused: Boolean; override;
    function GetMultiLine: Boolean; override;
    function GetPainterClass: TcxCustomGridCellPainterClass; override;
    function GetVisible: Boolean; override;
    function GetVisibleForHitTest: Boolean; override;
    function HasCheckBox: Boolean; virtual;
    function HasFocusRect: Boolean; override;
    function HasHitTestPoint(const P: TPoint): Boolean; override;
    function HasPin: Boolean; virtual;
    function IsChildrenHotTracked: Boolean; override;
    function IsFirst(AFixedKind: TcxGridColumnFixedKind): Boolean; virtual;
    function IsLast(AFixedKind: TcxGridColumnFixedKind): Boolean; virtual;
    function NeedFixedHighlight: Boolean; virtual;
    procedure Offset(DX, DY: Integer); override;
    procedure RemoveMergedCell(ACellViewInfo: TcxGridDataCellViewInfo);
    procedure ResetChildrenState; override;
    function ShowCheckBox: Boolean; virtual;
    function ShowPin: Boolean; virtual;
    function SupportsEditing: Boolean; override;

    property CacheItem: TcxGridTableViewInfoCacheItem read GetCacheItem;
    property FixedKind: TcxGridColumnFixedKind read GetFixedKind;
    property GridView: TcxGridTableView read GetGridView;
    property GridViewInfo: TcxGridTableViewInfo read GetGridViewInfo;
    property MergedCellOfFocusedRow: TcxGridDataCellViewInfo read GetMergedCellOfFocusedRow;
    property OriginalHeight: Integer read FOriginalHeight;
  public
    constructor Create(ARecordViewInfo: TcxCustomGridRecordViewInfo; AItem: TcxCustomGridTableItem); override;
    destructor Destroy; override;

    procedure AfterRecalculation; override;
    procedure BeforeRecalculation; override;
    function CanDrawSelected: Boolean; override;
    procedure Calculate(ALeftBound, ATopBound: Integer; AWidth: Integer = -1; AHeight: Integer = -1); override;
    procedure DoRightToLeftConversion(const ABounds: TRect); override;
    function GetHitTest(const P: TPoint): TcxCustomGridHitTest; override;
    function MouseMove(AHitTest: TcxCustomGridHitTest; AShift: TShiftState): Boolean; override;
    procedure Paint(ACanvas: TcxCanvas = nil); override;

    property CheckBoxArea: TcxGridDataCellCheckBoxAreaViewInfo read FCheckBoxArea;
    property IsMerged: Boolean read FIsMerged;
    property IsMerging: Boolean read FIsMerging;
    property Item: TcxGridColumn read GetItem;
    property MergedCellCount: Integer read GetMergedCellCount;
    property MergedCells[Index: Integer]: TcxGridDataCellViewInfo read GetMergedCell;
    property MergingCell: TcxGridDataCellViewInfo read FMergingCell;
    property Pin: TcxGridDataCellPinViewInfo read FPin;
    property RecordViewInfo: TcxGridDataRowViewInfo read GetRecordViewInfo;
  end;

  { TcxGridFilterRowOperator }

  TcxGridFilterRowOperatorViewInfo = class(TcxCustomGridViewCellViewInfo)
  private
    FCellViewInfo: TcxGridFilterRowCellViewInfo;

    function GetButtonBounds: TRect;
    function GetGridView: TcxGridTableView;
    function GetImageBounds: TRect;
    function GetImageSize: TSize;
    function GetOperator: TcxFilterControlOperator;
  protected
    function CalculateHeight: Integer; override;
    function CalculateWidth: Integer; override;
    function GetHeight: Integer; override;
    function GetHitTestClass: TcxCustomGridHitTestClass; override;
    function GetIsCheck: Boolean; override;
    function GetPainterClass: TcxCustomGridCellPainterClass; override;
    procedure GetViewParams(var AParams: TcxViewParams); override;
    function GetWidth: Integer; override;

    property ButtonBounds: TRect read GetButtonBounds;
    property CellViewInfo: TcxGridFilterRowCellViewInfo read FCellViewInfo;
    property FilterOperator: TcxFilterControlOperator read GetOperator;
    property GridView: TcxGridTableView read GetGridView;
    property ImageBounds: TRect read GetImageBounds;
    property ImageSize: TSize read GetImageSize;
  public
    constructor Create(ACellViewInfo: TcxGridFilterRowCellViewInfo); reintroduce; virtual;

    function MouseDown(AHitTest: TcxCustomGridHitTest; AButton: TMouseButton; AShift: TShiftState): Boolean; override;
  end;

  TcxGridFilterRowOperatorViewInfoClass = class of TcxGridFilterRowOperatorViewInfo;

  { TcxGridFilterRowCellViewInfo }

  TcxGridFilterRowCellViewInfo = class(TcxGridDataCellViewInfo)
  private
    FOperatorViewInfo: TcxGridFilterRowOperatorViewInfo;

    function GetController: TcxGridTableController;
    function GetGridRecord: TcxGridFilterRow;
    function GetOperator: TcxFilterControlOperator;
    function GetRecordViewInfo: TcxGridFilterRowViewInfo;
    function GetSupportedOperators: TcxFilterControlOperators;
    procedure SetOperator(AValue: TcxFilterControlOperator);

    procedure OperatorMenuHideHandler(Sender: TObject);
    procedure OperatorMenuSelectHandler(Sender: TObject; AItem: TdxCustomListBoxItem; ASelectedViaKeyboard: Boolean);
  protected
    function GetOperatorViewInfoClass: TcxGridFilterRowOperatorViewInfoClass; virtual;
    function HasOperatorViewInfo: Boolean; virtual;
    function GetEditViewDataBounds: TRect; override;
    function GetPainterClass: TcxCustomGridCellPainterClass; override;
    procedure Offset(DX, DY: Integer); override;
    function OperatorCustomization: Boolean; virtual;
    function OperatorCustomizationMenuForBounds: TRect; virtual;
    procedure ShowOperatorCustomizationMenu; virtual;

    property Controller: TcxGridTableController read GetController;
    property FilterOperator: TcxFilterControlOperator read GetOperator write SetOperator;
    property OperatorViewInfo: TcxGridFilterRowOperatorViewInfo read FOperatorViewInfo;
    property SupportedOperators: TcxFilterControlOperators read GetSupportedOperators;
  public
    constructor Create(ARecordViewInfo: TcxCustomGridRecordViewInfo; AItem: TcxCustomGridTableItem); override;
    destructor Destroy; override;

    procedure AfterRecalculation; override;
    procedure BeforeRecalculation; override;
    procedure Calculate(ALeftBound: Integer; ATopBound: Integer;
      AWidth: Integer = -1; AHeight: Integer = -1); override;
    procedure DoRightToLeftConversion(const ABounds: TRect); override;
    function GetHitTest(const P: TPoint): TcxCustomGridHitTest; override;

    property GridRecord: TcxGridFilterRow read GetGridRecord;
    property RecordViewInfo: TcxGridFilterRowViewInfo read GetRecordViewInfo;
  end;

  { TcxGridDataRowCellsAreaViewInfo }

  TcxGridDataRowCellsAreaViewInfoClass = class of TcxGridDataRowCellsAreaViewInfo;

  TcxGridDataRowCellsAreaViewInfo = class(TcxGridCellViewInfo)
  private
    function GetRecordViewInfo: TcxGridDataRowViewInfo;
  protected
    function CalculateHeight: Integer; override;
    function CalculateVisible: Boolean; virtual;
    function CalculateWidth: Integer; override;
    function DrawMergedCell(ACell: TcxGridDataCellViewInfo): Boolean; virtual;
    function GetBorders: TcxBorders; override;
    function GetIsBottom: Boolean; virtual;
  public
    constructor Create(ARecordViewInfo: TcxCustomGridRecordViewInfo); override;
    function CanDrawSelected: Boolean; override;

    property IsBottom: Boolean read GetIsBottom;
    property RecordViewInfo: TcxGridDataRowViewInfo read GetRecordViewInfo;
  end;

  { TcxGridPreviewCellViewInfo }

  TcxGridPreviewCellViewInfoClass = class of TcxGridPreviewCellViewInfo;

  TcxGridPreviewCellViewInfo = class(TcxGridDataCellViewInfo)
  private
    function GetPreview: TcxGridPreview;
  protected
    function CalculateHeight: Integer; override;
    function CalculateWidth: Integer; override;
    function GetAutoHeight: Boolean; override;
    function GetBackgroundBitmap: TBitmap; override;
    function GetBorders: TcxBorders; override;
    procedure GetEditViewDataContentOffsets(var R: TRect); override;
    function GetFixedKind: TcxGridColumnFixedKind; override;
    function GetHeight: Integer; override;
    function GetHitTestClass: TcxCustomGridHitTestClass; override;
    function GetIsMain: Boolean; override;
    function GetMaxLineCount: Integer; override;
    function GetMultiLine: Boolean; override;
    function GetTextAreaBounds: TRect; override;
    function NeedFixedHighlight: Boolean; override;
    function SupportsZeroHeight: Boolean; override;

    property Preview: TcxGridPreview read GetPreview;
  end;

  { TcxGridRowLayoutViewInfo }

  TcxGridRowLayoutViewInfo = class(TcxCustomGridViewCellViewInfo)
  strict private
    FContainerViewInfo: TcxGridTableRowLayoutContainerViewInfo;
    FIsAutoHeightCalculating: Boolean;
    FItemViewInfos: TcxGridRowLayoutGridItemViewInfos;
    FRecordViewInfo: TcxGridDataRowViewInfo;

    function GetGridView: TcxGridTableView;
    function GetGridViewInfo: TcxGridTableViewInfo;
    function GetRowLayoutController: TcxGridTableRowLayoutController;
  protected
    procedure AfterCustomDraw(ACanvas: TcxCanvas); override;
    procedure BeforeCustomDraw(ACanvas: TcxCanvas); override;
    function CalculateHeight: Integer; override;
    function CalculateWidth: Integer; override;
    function CreateContainerViewInfo: TcxGridTableRowLayoutContainerViewInfo; virtual;
    function CreateItemViewInfo(ARecordViewInfo: TcxCustomGridRecordViewInfo;
      AItem: TcxCustomGridTableItem): TcxGridTableRowLayoutDataCellViewInfo; virtual;
    function CreateItemViewInfos: TcxGridRowLayoutGridItemViewInfos; virtual;
    function CustomDrawBackground(ACanvas: TcxCanvas): Boolean; override;
    function GetActualState: TcxGridCellState; override;
    function GetBorderColor(AIndex: TcxBorder): TColor; override;
    function GetBorders: TcxBorders; override;
    function GetBorderWidth(AIndex: TcxBorder): Integer; override;
    function GetButtonState: TcxButtonState; override;
    function GetHeight: Integer; override;
    function GetHitTestClass: TcxCustomGridHitTestClass; override;
    function GetPainterClass: TcxCustomGridCellPainterClass; override;
    function GetWidth: Integer; override;
    function HasBackground: Boolean; override;
    function HasCustomDrawBackground: Boolean; override;
    function HasHotTrackBackground: Boolean; virtual;
    function HasSelectionBackground: Boolean; virtual;
    function IsChildrenHotTracked: Boolean; override;
    procedure Offset(DX: Integer; DY: Integer); override;
    procedure PopulateItemViewInfos; virtual;
    function PtInItems(const APoint: TPoint): Boolean; virtual;
    procedure ResetChildrenState; override;

    property ItemViewInfos: TcxGridRowLayoutGridItemViewInfos read FItemViewInfos;
    property RowLayoutController: TcxGridTableRowLayoutController read GetRowLayoutController;
  public
    constructor Create(ARecordViewInfo: TcxGridDataRowViewInfo); reintroduce; virtual;
    destructor Destroy; override;

    procedure BeforeRecalculation; override;
    procedure Calculate(ALeftBound, ATopBound: Integer; AWidth: Integer = -1; AHeight: Integer = -1); override;
    function FindCellViewInfo(AItem: TcxCustomGridColumn): TcxGridViewLayoutItemDataCellViewInfo;
    function FindLayoutItemViewInfo(AItem: TcxCustomGridColumn): TcxGridRowLayoutItemViewInfo;
    function GetHitTest(const P: TPoint): TcxCustomGridHitTest; override;
    function MouseDown(AHitTest: TcxCustomGridHitTest; AButton: TMouseButton; AShift: TShiftState): Boolean; override;

    property ContainerViewInfo: TcxGridTableRowLayoutContainerViewInfo read FContainerViewInfo;
    property GridView: TcxGridTableView read GetGridView;
    property GridViewInfo: TcxGridTableViewInfo read GetGridViewInfo;
    property RecordViewInfo: TcxGridDataRowViewInfo read FRecordViewInfo;
  end;

  { TcxGridInplaceEditFormAreaScrollBarViewInfo }

  TcxGridInplaceEditFormAreaScrollBarViewInfo = class(TcxCustomGridViewCellViewInfo, IcxScrollBarOwner)
  private
    FViewInfo: TcxGridInplaceEditFormAreaViewInfo;
    FScrollBar: TdxScrollBarWrapper;

    procedure CreateScrollBar;
    procedure DestroyScrollBar;

    function GetKind: TScrollBarKind;
    function GetMax: Integer;
    function GetMin: Integer;
    function GetPageSize: Integer;
    function GetPosition: Integer;
    procedure SetKind(Value: TScrollBarKind);
    procedure SetMax(Value: Integer);
    procedure SetMin(Value: Integer);
    procedure SetPageSize(Value: Integer);
    procedure SetPosition(Value: Integer);

    //IcxScrollBarOwner
    function IcxScrollBarOwner.GetControl = GetScrollBarOwner;
    function GetScrollBarOwner: TWinControl;
    function GetLookAndFeel: TcxLookAndFeel;
  protected
    function CalculateHeight: Integer; override;
    function CalculateWidth: Integer; override;
    function GetHeight: Integer; override;
    function GetWidth: Integer; override;
    procedure SetHeight(Value: Integer); override;
    procedure SetWidth(Value: Integer); override;

    function CaptureMouseOnPress: Boolean; override;
    procedure DoScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
    function GetHotTrack: Boolean; override;

    property ScrollBar: TdxScrollBarWrapper read FScrollBar;
  public
    constructor Create(AViewInfo: TcxGridInplaceEditFormAreaViewInfo); reintroduce; virtual;
    destructor Destroy; override;

    procedure Calculate(ALeftBound, ATopBound: Integer; AWidth: Integer = -1;
      AHeight: Integer = -1); override;
    procedure DoRightToLeftConversion(const ABounds: TRect); override;
    procedure SetScrollParams(AMin, AMax, APosition, APageSize: Integer; ARedraw: Boolean = True);

    property InplaceEditFormAreaViewInfo: TcxGridInplaceEditFormAreaViewInfo read FViewInfo;
    property Kind: TScrollBarKind read GetKind write SetKind;
    property Max: Integer read GetMax write SetMax;
    property Min: Integer read GetMin write SetMin;
    property PageSize: Integer read GetPageSize write SetPageSize;
    property Position: Integer read GetPosition write SetPosition;
  end;

  TcxGridInplaceEditFormAreaScrollBarViewInfoClass = class of TcxGridInplaceEditFormAreaScrollBarViewInfo;

  { TcxGridInplaceEditFormAreaScrollBars }

  TcxGridInplaceEditFormAreaScrollBars = class
  private
    FViewInfo: TcxGridInplaceEditFormAreaViewInfo;
    //scrollbars
    FHorizontalScrollBar: TcxGridInplaceEditFormAreaScrollBarViewInfo;
    FVerticalScrollBar: TcxGridInplaceEditFormAreaScrollBarViewInfo;
    procedure CreateScrollBars;
    procedure DestroyScrollBars;
    function GetContainerViewInfo: TcxGridInplaceEditFormContainerViewInfo;
  protected
    procedure CalculateHorizontalScrollBar; virtual;
    procedure CalculateScrollBarViewInfo(AScrollBarViewInfo: TcxGridInplaceEditFormAreaScrollBarViewInfo;
      ASize, ALeft, ATop: Integer);
    procedure CalculateVerticalScrollBar; virtual;
    procedure CheckHorizontalScrollPosition; virtual;
    procedure CheckHorizontalScrollVisibility; virtual;
    procedure CheckPosition; virtual;
    procedure CheckVerticalScrollPosition; virtual;
    procedure CheckVertiacalScrollVisibility; virtual;
    procedure CheckVisibility; virtual;
    function GetContainerOffsetFromScrollPosition(AScrollBarViewInfo: TcxGridInplaceEditFormAreaScrollBarViewInfo;
      AKind: TScrollBarKind): Integer;
    function GetHorizontalScrollBarHeight: Integer; virtual;
    function GetVerticalScrollBarWidth: Integer; virtual;
    function GetScrollBarClass: TcxGridInplaceEditFormAreaScrollBarViewInfoClass; virtual;
    function NeedRecheckHorizontalScrollVisibility: Boolean; virtual;
  public
    constructor Create(AInplaceEditFormAreaViewInfo: TcxGridInplaceEditFormAreaViewInfo); virtual;
    destructor Destroy; override;

    procedure Calculate; virtual;
    procedure RightToLeftConversion(const ABounds: TRect);
    function GetContainerOffset: TPoint; virtual;
    function GetHitTest(const P: TPoint): TcxCustomGridHitTest; virtual;

    property HorizontalScrollBar: TcxGridInplaceEditFormAreaScrollBarViewInfo read FHorizontalScrollBar;
    property VerticalScrollBar: TcxGridInplaceEditFormAreaScrollBarViewInfo read FVerticalScrollBar;

    property ContainerViewInfo: TcxGridInplaceEditFormContainerViewInfo read GetContainerViewInfo;
    property ViewInfo: TcxGridInplaceEditFormAreaViewInfo read FViewInfo;
  end;

  TcxGridInplaceEditFormAreaScrollBarsClass = class of TcxGridInplaceEditFormAreaScrollBars;

  { TcxGridInplaceEditFormButtonViewInfo }

  TcxGridInplaceEditFormButtonViewInfo = class(TcxGridPartCustomCellViewInfo)
  private
    FViewInfo: TcxGridInplaceEditFormButtonsPanelViewInfo;

    function GetGridView: TcxGridTableView;
    function GetInplaceEditFormAreaViewInfo: TcxGridInplaceEditFormAreaViewInfo;
  protected
    function DoCalculateHeight: Integer; override;
    function DoCalculateWidth: Integer; override;
    function GetHitTestClass: TcxCustomGridHitTestClass; override;
    function GetPainterClass: TcxCustomGridCellPainterClass; override;
    procedure GetViewParams(var AParams: TcxViewParams); override;
  public
    constructor Create(AButtonsPanelViewInfo: TcxGridInplaceEditFormButtonsPanelViewInfo); reintroduce; virtual;

    property ButtonsPanelViewInfo: TcxGridInplaceEditFormButtonsPanelViewInfo read FViewInfo;
    property GridView: TcxGridTableView read GetGridView;
    property ViewInfo: TcxGridInplaceEditFormAreaViewInfo read GetInplaceEditFormAreaViewInfo;
  end;

  TcxGridInplaceEditFormButtonViewInfoClass = class of TcxGridInplaceEditFormButtonViewInfo;

  { TcxGridInplaceEditFormCancelButtonViewInfo }

  TcxGridInplaceEditFormCancelButtonViewInfo = class(TcxGridInplaceEditFormButtonViewInfo)
  protected
    procedure Click; override;
    function GetHitTestClass: TcxCustomGridHitTestClass; override;
    function GetText: string; override;
    function GetFocused: Boolean; override;
  end;

  { TcxGridInplaceEditFormUpdateButtonViewInfo }

  TcxGridInplaceEditFormUpdateButtonViewInfo = class(TcxGridInplaceEditFormButtonViewInfo)
  protected
    procedure Click; override;
    function GetEnabled: Boolean; override;
    function GetFocused: Boolean; override;
    function GetHitTestClass: TcxCustomGridHitTestClass; override;
    function GetHotTrack: Boolean; override;
    function GetText: string; override;
    function GetVisible: Boolean; override;
  end;

  { TcxGridInplaceEditFormButtonsPanelViewInfo }

  TcxGridInplaceEditFormButtonsPanelViewInfo = class(TcxCustomGridViewCellViewInfo)
  private
    FItems: TdxFastObjectList;
    FViewInfo: TcxGridInplaceEditFormAreaViewInfo;
    function GetButtonCount: Integer; inline;
    function GetGridView: TcxGridTableView;
    function GetForm: TcxGridTableViewInplaceEditForm;
    function GetItem(Index: Integer): TcxGridInplaceEditFormButtonViewInfo;
    function GetMaxButtonWidth: Integer;
    procedure SetButtonsWidth(AValue: Integer);
  protected
    procedure CreateButtons; virtual;
    procedure DestroyButtons; virtual;

    function AddItem(AItemClass: TcxGridInplaceEditFormButtonViewInfoClass): TcxGridInplaceEditFormButtonViewInfo;
    function GetButtonRightIndent: Integer;
    procedure CalculateButtons; virtual;
    function CalculateHeight: Integer; override;
    function CalculateWidth: Integer; override;
    function GetHeight: Integer; override;
    function GetHitTestClass: TcxCustomGridHitTestClass; override;
    function GetPainterClass: TcxCustomGridCellPainterClass; override;
    function GetSeparatorBound: TRect; virtual;
    function GetSeparatorHeight: Integer;
    procedure GetViewParams(var AParams: TcxViewParams); override;
    function GetWidth: Integer; override;

    property ButtonCount: Integer read GetButtonCount;
    property Form: TcxGridTableViewInplaceEditForm read GetForm;
    property Items[Index: Integer]: TcxGridInplaceEditFormButtonViewInfo read GetItem; default;
  public
    constructor Create(AInplaceEditFormAreaViewInfo: TcxGridInplaceEditFormAreaViewInfo); reintroduce; virtual;
    destructor Destroy; override;

    procedure Calculate(ALeftBound, ATopBound: Integer; AWidth: Integer = -1;
      AHeight: Integer = -1); override;
    procedure DoRightToLeftConversion(const ABounds: TRect); override;
    function GetHitTest(const P: TPoint): TcxCustomGridHitTest; override;

    property GridView: TcxGridTableView read GetGridView;
    property ViewInfo: TcxGridInplaceEditFormAreaViewInfo read FViewInfo;
  end;

  TcxGridInplaceEditFormButtonsPanelViewInfoClass = class of TcxGridInplaceEditFormButtonsPanelViewInfo;

  TcxGridInplaceEditFormAreaViewInfoCacheInfo = class
  private
    FHeight: Integer;
    FIsHeightAssigned: Boolean;
    FIsRestHeightAssigned: Boolean;
    FRestHeight: Integer;
    procedure SetHeight(const Value: Integer);
    procedure SetRestHeight(const Value: Integer);
  public
    property Height: Integer read FHeight write SetHeight;
    property IsHeightAssigned: Boolean read FIsHeightAssigned write FIsHeightAssigned;
    property IsRestHeightAssigned: Boolean read FIsRestHeightAssigned write FIsRestHeightAssigned;
    property RestHeight: Integer read FRestHeight write SetRestHeight;
  end;

  { TcxGridInplaceEditFormAreaViewInfo }

  TcxGridInplaceEditFormAreaViewInfo = class(TcxCustomGridViewCellViewInfo,
    IcxScrollBarOwner, IdxTouchScrollUIOwner, IdxHybridScrollbarOwner)
  strict private
    FHybridScrollbarsManager: TdxHybridScrollbarsManager;
  private
    FButtonsPanelViewInfo: TcxGridInplaceEditFormButtonsPanelViewInfo;
    FCacheInfo: TcxGridInplaceEditFormAreaViewInfoCacheInfo;
    FGridItemViewInfos: TcxGridRowLayoutGridItemViewInfos;
    FRecordViewInfo: TcxGridDataRowViewInfo;
    FScrollBars: TcxGridInplaceEditFormAreaScrollBars;
    procedure CreateButtonsPanel;
    procedure CreateGridItemViewInfos;
    procedure CreateScrollBars;
    procedure DestroyButtonsPanel;
    procedure DestroyGridItemViewInfos;
    procedure DestroyScrollBars;
    function GetContainerViewInfo: TcxGridInplaceEditFormContainerViewInfo;
    function GetGridRecord: TcxGridDataRow;
    function GetGridView: TcxGridTableView;
    function GetGridViewInfo: TcxGridTableViewInfo;
    function GetInplaceEditForm: TcxGridTableViewInplaceEditForm;
  protected
    //IcxScrollBarOwner
    function IcxScrollBarOwner.GetControl = GetScrollBarOwner;
    function GetScrollBarOwner: TWinControl;
    function GetLookAndFeel: TcxLookAndFeel;
    //IdxTouchScrollUIOwner
    procedure CheckUIPosition;
    function GetOwnerControl: TcxControl;
    function HasVisibleUI: Boolean;
    procedure HideUI;
    // IdxHybridScrollbarOwner
    function GetBaseColor: TColor;
    function GetManager: TdxHybridScrollbarsManager;
    procedure IdxHybridScrollbarOwner.Invalidate = InvalidateHybridScrollbars;
    procedure InvalidateHybridScrollbars;

    function CalculateAvailableHeight: Integer; virtual;
    function CalculateHeight: Integer; override;
    procedure CalculateLayoutContainerViewInfo; virtual;
    function CalculateWidth: Integer; override;
    procedure CheckFocusedItem;
    function FocusedItemKind: TcxGridFocusedItemKind;
    function GetAvailableHeight: Integer; virtual;
    function GetBoundsForGridItem(AGridItem: TcxCustomGridTableItem): TRect; virtual;
    function GetDataHeight: Integer; virtual;
    function GetDataWidth: Integer; virtual;
    function GetGridItemHitTest(const P: TPoint): TcxCustomGridHitTest; virtual;
    function GetHeight: Integer; override;
    function GetInplaceEditFormClientBounds: TRect; virtual;
    procedure GetViewParams(var AParams: TcxViewParams); override;
    function GetWidth: Integer; override;
    function IsPointInLayoutContainer(const P: TPoint): Boolean;
    procedure Offset(DX, DY: Integer); override;
    procedure UpdateOnScroll;

    function GetGridItemViewInfoClass: TcxGridTableDataCellViewInfoClass; virtual;
    function GetHitTestClass: TcxCustomGridHitTestClass; override;
    function GetButtonsPanelViewInfoClass: TcxGridInplaceEditFormButtonsPanelViewInfoClass; virtual;
    function GetScrollBarsClass: TcxGridInplaceEditFormAreaScrollBarsClass; virtual;
    function GetPainterClass: TcxCustomGridCellPainterClass; override;

    property AvailableHeight: Integer read GetAvailableHeight;
    property CacheInfo: TcxGridInplaceEditFormAreaViewInfoCacheInfo read FCacheInfo;
    property DataHeight: Integer read GetDataHeight;
    property DataWidth: Integer read GetDataWidth;
    property GridItemViewInfos: TcxGridRowLayoutGridItemViewInfos read FGridItemViewInfos;
    property GridRecord: TcxGridDataRow read GetGridRecord;
    property InplaceEditForm: TcxGridTableViewInplaceEditForm read GetInplaceEditForm;
  public
    constructor Create(AGridViewInfo: TcxCustomGridViewInfo; ARecordViewInfo: TcxGridDataRowViewInfo); reintroduce; virtual;
    destructor Destroy; override;

    procedure BeforeRecalculation; override;
    procedure Calculate(ALeftBound, ATopBound: Integer; AWidth: Integer = -1; AHeight: Integer = -1); override;
    procedure DoRightToLeftConversion(const ABounds: TRect); override;
    function FindCellViewInfo(AGridItem: TcxCustomGridTableItem): TcxGridViewLayoutItemDataCellViewInfo;
    function GetBoundsForEdit(const ADataCellBounds: TRect): TRect; virtual;
    function GetHitTest(const P: TPoint): TcxCustomGridHitTest; override;
    procedure InvalidateUpdateButtonInfo;
    procedure MakeDataCellVisible(ACellViewInfo: TcxGridTableViewInplaceEditFormDataCellViewInfo); virtual;
    procedure MakeItemVisible(AItem: TcxCustomGridTableItem);

    //mouse
    function MouseDown(AHitTest: TcxCustomGridHitTest; AButton: TMouseButton;
      AShift: TShiftState): Boolean; override;
    function MouseMove(AHitTest: TcxCustomGridHitTest; AShift: TShiftState): Boolean; override;
    function MouseUp(AHitTest: TcxCustomGridHitTest; AButton: TMouseButton;
      AShift: TShiftState): Boolean; override;

    property ButtonsPanelViewInfo: TcxGridInplaceEditFormButtonsPanelViewInfo read FButtonsPanelViewInfo;
    property GridView: TcxGridTableView read GetGridView;
    property GridViewInfo: TcxGridTableViewInfo read GetGridViewInfo;
    property ContainerViewInfo: TcxGridInplaceEditFormContainerViewInfo read GetContainerViewInfo;
    property RecordViewInfo: TcxGridDataRowViewInfo read FRecordViewInfo;
    property ScrollBars: TcxGridInplaceEditFormAreaScrollBars read FScrollBars;
  end;

  TcxGridInplaceEditFormAreaViewInfoClass = class of TcxGridInplaceEditFormAreaViewInfo;

  { TcxGridDataRowViewInfo }

  TcxGridDataRowViewInfo = class(TcxCustomGridRowViewInfo)
  private
    FCellHeight: Integer;
    FCellsAreaBounds: TRect;
    FCellsAreaViewInfo: TcxGridDataRowCellsAreaViewInfo;
    FCellSeparatorsBounds: array[TcxGridColumnFixedKind] of TRect;
    FCellViewInfos: TList;
    FEmptyAreaBounds: TRect;
    FInplaceEditFormAreaViewInfo: TcxGridInplaceEditFormAreaViewInfo;
    FLayoutViewInfo: TcxGridRowLayoutViewInfo;
    FPreviewViewInfo: TcxGridPreviewCellViewInfo;

    function FindCellViewInfoInTableRow(AItem: TcxCustomGridColumn): TcxGridTableDataCellViewInfo;
    function GetCellSeparatorBounds(AFixedKind: TcxGridColumnFixedKind): TRect;
    function GetCellViewInfo(Index: Integer): TcxGridDataCellViewInfo;
    function GetCellViewInfoCount: Integer;
    function GetGridRecord: TcxGridDataRow;
    function GetHasPreview: Boolean;
    function GetInplaceEditForm: TcxGridTableViewInplaceEditForm;
    function GetInternalCellViewInfo(Index: Integer): TcxGridDataCellViewInfo;
    function GetRowLayoutController: TcxGridTableRowLayoutController;

    procedure CreateViewInfos;
    procedure DestroyViewInfos;
  protected
    procedure AddAdornerTargetElementsForColumn(AList: TStrings; AColumn: TcxCustomGridColumn; AName: string); override;
    function AdjustToIntegralBottomBound(var ABound: Integer): Boolean; override; 
    procedure AfterRowsViewInfoCalculate; override;
    procedure AfterRowsViewInfoOffset; override;
    function AllowDrawHotTracked: Boolean; override;
    function AllowDrawSelected: Boolean; override;
    procedure ApplyMergedCellsBounds(var R: TRect; AItem: TcxCustomGridTableItem);
    procedure ApplyMergingCellsBounds(var R: TRect);
    procedure CalculateCells; virtual;
    procedure CalculateCellSeparatorBounds(AFixedKind: TcxGridColumnFixedKind); virtual;
    procedure CalculateCellSeparators; virtual;
    procedure CalculateCellViewInfo(AIndex: Integer); virtual;
    function CalculateDataAutoHeight(ACheckEditingCell: Boolean = True): Integer;
    function CalculateHeight: Integer; override;
    procedure CalculateInPlace(ALeft, ATop: Integer); override;
    procedure CalculateInplaceEditForm; virtual;
    function CalculateMultilineEditMinHeight: Integer; override;
    procedure CalculatePreview(ATopBound: Integer); virtual;
    procedure CalculateTableRowEmptyAreaBounds;
    function CanDelayedDrawDataCellBorders: Boolean; virtual;
    function CanSize: Boolean; override;
    procedure CheckRowHeight(var AValue: Integer); override;
    function CreateLayoutViewInfo: TcxGridRowLayoutViewInfo; virtual;
    function CustomDrawRowLayoutBackground(ACanvas: TcxCanvas): Boolean; virtual;
    procedure DoCellSeparatorBoundsRightToLeftConversion(const ABounds: TRect); virtual;
    procedure DoToggleExpanded; override;
    function FindCellViewInfo(AItem: TcxCustomGridColumn): TcxGridTableDataCellViewInfo; virtual;
    function GetAutoHeight: Boolean; override;
    function GetBackgroundBitmapBounds: TRect; override;
    function GetBaseHeight: Integer; override;
    function GetBottomPartHeight: Integer; override;
    function GetCellsAreaHeight: Integer; virtual;
    function GetFixedRowsSeparatorBounds: TRect; virtual;
    function GetFixedRowsSeparatorWidth: Integer; virtual;
    function GetHotTrack: Boolean; override;
    function GetInplaceEditFormLeftPosition: Integer; virtual;
    function GetInplaceEditFormTopPosition: Integer; virtual;
    function GetPainterClass: TcxCustomGridCellPainterClass; override;
    function GetRowLayoutBackgroundRegion: TcxRegion; virtual;
    function GetSeparatorBounds: TRect; override;
    function GetTopPartHeight: Integer; override;
    procedure GetViewParams(var AParams: TcxViewParams); override;
    function GetVisualLevel: Integer; override;
    function HasRowLayoutBackground: Boolean; virtual;
    function IsCellIndexValid(AIndex: Integer): Boolean; virtual;
    function IsChildrenHotTracked: Boolean; override;
    function NeedToggleExpandRecord(AHitTest: TcxCustomGridHitTest; AButton: TMouseButton;
      AShift: TShiftState): Boolean; override;
    procedure Offset(DX, DY: Integer); override;
    procedure OffsetAreaSeapratorBounds(DX, DY: Integer); virtual;
    procedure ResetCellSeparatorBounds; virtual;
    procedure ResetChildrenState; override;
    procedure SetRowHeight(Value: Integer); override;
    function ShowDataCells: Boolean; virtual;
    function ShowFixedOnBottomRowsSeparator: Boolean; virtual;
    function ShowFixedOnTopRowsSeparator: Boolean; virtual;
    function ShowFixedRowsSeparator: Boolean;
    function ShowInplaceEditForm: Boolean; virtual;
    function ShowLayout: Boolean; virtual;
    function ShowPin: Boolean; virtual;
    function ShowPreview: Boolean; virtual;

    procedure CancelInplaceEditFormEditing; virtual;
    procedure UpdateInplaceEditFormEditing; virtual;

    function GetCellHeight(ACell: TcxGridDataCellViewInfo): Integer; reintroduce; virtual;
    function GetCellHeightValue: Integer; virtual;
    function GetCellLeftBound(ACell: TcxGridDataCellViewInfo): Integer; virtual;
    function GetCellTopBound(ACell: TcxGridDataCellViewInfo): Integer; virtual;
    function GetCellsAreaBounds: TRect; virtual;
    function GetCellsAreaViewInfoClass: TcxGridDataRowCellsAreaViewInfoClass; virtual;
    function GetCellViewInfoClass(AIndex: Integer): TcxGridDataCellViewInfoClass; virtual;
    function GetCellWidth(ACell: TcxGridDataCellViewInfo): Integer; virtual;
    function GetDataWidth: Integer; override;
    function GetInplaceEditFormAreaViewInfoClass: TcxGridInplaceEditFormAreaViewInfoClass; virtual;
    function GetPreviewViewInfoClass: TcxGridPreviewCellViewInfoClass; virtual;
    function GetWidth: Integer; override;
    function HasFocusRect: Boolean; override;
    function HasFooters: Boolean; override;
    function IsCellVisible(AIndex: Integer): Boolean; virtual;

    property CellHeight: Integer read GetCellHeightValue;
    property CellSeparatorBounds[AFixedKind: TcxGridColumnFixedKind]: TRect read GetCellSeparatorBounds;
    property EmptyAreaBounds: TRect read FEmptyAreaBounds;
    property InplaceEditForm: TcxGridTableViewInplaceEditForm read GetInplaceEditForm;
    property RowLayoutController: TcxGridTableRowLayoutController read GetRowLayoutController;
  public
    constructor Create(ARecordsViewInfo: TcxCustomGridRecordsViewInfo; ARecord: TcxCustomGridRecord); override;
    destructor Destroy; override;

    procedure BeforeCellRecalculation(ACell: TcxGridTableCellViewInfo); virtual;
    procedure BeforeRecalculation; override;
    procedure Calculate(ALeftBound, ATopBound: Integer; AWidth: Integer = -1;
      AHeight: Integer = -1); override;
    procedure DoRightToLeftConversion(const ABounds: TRect); override;
    function GetAreaBoundsForPainting: TRect; override;
    function GetBoundsForInvalidate(AItem: TcxCustomGridTableItem): TRect; override;
    function GetBoundsForItem(AItem: TcxCustomGridTableItem): TRect; override;
    function GetCellBorders(AIsRight, AIsBottom: Boolean): TcxBorders; virtual;
    function GetCellViewInfoByItem(AItem: TcxCustomGridTableItem): TcxGridTableDataCellViewInfo; override;
    function GetHitTest(const P: TPoint): TcxCustomGridHitTest; override;
    function GetInplaceEditFormClientBounds: TRect; virtual;
    function IsInplaceEditFormCellPartVisible(ACellViewInfo: TcxGridTableDataCellViewInfo): Boolean; virtual;

    property CellsAreaBounds: TRect read GetCellsAreaBounds;
    property CellsAreaViewInfo: TcxGridDataRowCellsAreaViewInfo read FCellsAreaViewInfo;
    property CellViewInfoCount: Integer read GetCellViewInfoCount;
    property CellViewInfos[Index: Integer]: TcxGridDataCellViewInfo read GetCellViewInfo;
    property GridRecord: TcxGridDataRow read GetGridRecord;
    property HasPreview: Boolean read GetHasPreview;
    property InternalCellViewInfos[Index: Integer]: TcxGridDataCellViewInfo read GetInternalCellViewInfo;
    property InplaceEditFormAreaViewInfo: TcxGridInplaceEditFormAreaViewInfo read FInplaceEditFormAreaViewInfo;
    property LayoutViewInfo: TcxGridRowLayoutViewInfo read FLayoutViewInfo;
    property PreviewViewInfo: TcxGridPreviewCellViewInfo read FPreviewViewInfo;
  end;

  // new item row

  { TcxGridNewItemRowViewInfo }

  TcxGridNewItemRowViewInfo = class(TcxGridDataRowViewInfo)
  private
    FHeight: Integer;
  protected
    function CalculateSelected: Boolean; override;
    function CanDelayedDrawDataCellBorders: Boolean; override;
    function CanShowDataCellHint: Boolean; override;
    function GetAlignmentHorz: TAlignment; override;
    function GetAlignmentVert: TcxAlignmentVert; override;
    function GetAutoHeight: Boolean; override;
    function GetCellHeightValue: Integer; override;
    function GetCellsAreaHeight: Integer; override;
    function GetHeight: Integer; override;
    function GetInfoText: string; virtual;
    function GetOptions: TcxGridSpecialRowOptions; virtual;
    function GetSeparatorColor: TColor; override;
    function GetSeparatorWidth: Integer; override;
    function GetShowInfoText: Boolean; virtual;
    function GetStyleIndex: Integer; virtual;
    function GetText: string; override;
    function GetTextAreaBounds: TRect; override;
    procedure GetViewParams(var AParams: TcxViewParams); override;
    function ShowFixedOnBottomRowsSeparator: Boolean; override;
    function ShowFixedOnTopRowsSeparator: Boolean; override;
    function HasFooters: Boolean; override;
    function HasLastHorzGridLine: Boolean; override;
    function ShowLayout: Boolean; override;
    function ShowPin: Boolean; override;
    function ShowPreview: Boolean; override;

    function GetPainterClass: TcxCustomGridCellPainterClass; override;
    function GetRealTextAreaBounds: TRect; override;

    property InfoText: string read GetInfoText;
    property Options: TcxGridSpecialRowOptions read GetOptions;
    property ShowInfoText: Boolean read GetShowInfoText;
  end;

  // filtering row

  { TcxGridFilterRowViewInfo }

  TcxGridFilterRowViewInfo = class(TcxGridNewItemRowViewInfo)
  private
    function GetGridRecord: TcxGridFilterRow;
    function GetFilterRowOptions: TcxGridFilterRowOptions;
  protected
    function GetCellViewInfoClass(AIndex: Integer): TcxGridDataCellViewInfoClass; override;
    function GetOptions: TcxGridSpecialRowOptions; override;
    function GetShowInfoText: Boolean; override;
    function GetStyleIndex: Integer; override;
    function OperatorCustomization: Boolean; virtual;
    function ShowInplaceEditForm: Boolean; override;

    property Options: TcxGridFilterRowOptions read GetFilterRowOptions;
  public
    property GridRecord: TcxGridFilterRow read GetGridRecord;
  end;

  // details site

  { TcxGridMasterDataRowDetailsSiteLeftTabsViewInfo }

  TcxGridMasterDataRowDetailsSiteLeftTabsViewInfo = class(TcxGridDetailsSiteLeftTabsViewInfo)
  private
    function GetBottomGridLineColor: TColor;
    function GetBottomGridLineWidth: Integer;
    function GetSiteViewInfo: TcxGridDetailsSiteViewInfo;
  protected
    function CalculateHeight: Integer; override;
    function GetBoundsRect: TRect; override;
    function GetPainterClass: TcxCustomGridCellPainterClass; override;
    function GetBottomGridLineBounds: TRect; virtual;
    property BottomGridLineWidth: Integer read GetBottomGridLineWidth;
  public
    function HasBottomGridLine: Boolean; virtual;
    property BottomGridLineBounds: TRect read GetBottomGridLineBounds;
    property BottomGridLineColor: TColor read GetBottomGridLineColor;
    property SiteViewInfo: TcxGridDetailsSiteViewInfo read GetSiteViewInfo;
  end;

  TcxGridDetailsSiteViewInfoClass = class of TcxGridDetailsSiteViewInfo;

  { TcxGridDetailsSiteViewInfo }

  TcxGridDetailsSiteViewInfo = class(TcxCustomGridDetailsSiteViewInfo)
  private
    FMasterDataRowViewInfo: TcxGridMasterDataRowViewInfo;
    function GetCacheItem: TcxGridMasterTableViewInfoCacheItem;
    function GetMasterGridView: TcxGridTableView;
    function GetMasterGridViewInfo: TcxGridTableViewInfo;
  protected
    procedure ControlFocusChanged; virtual;
    function GetActiveGridView: TcxCustomGridView; override;
    function GetActiveGridViewExists: Boolean; override;
    function GetActiveGridViewValue: TcxCustomGridView; override;
    function GetActiveLevel: TcxGridLevel; override;
    function GetCanvas: TcxCanvas; override;
    function GetContainer: TcxControl; override;
    function GetDesignController: TcxCustomGridDesignController; override;
    function GetFullyVisible: Boolean; override;
    function GetHeight: Integer; override;
    function GetMasterRecord: TObject; override;
    function GetMaxHeight: Integer; override;
    function GetMaxNormalHeight: Integer; override;
    function GetMaxWidth: Integer; override;
    function GetNormalHeight: Integer; override;
    function GetTabsViewInfoClass: TcxCustomGridDetailsSiteTabsViewInfoClass; override;
    function GetVisible: Boolean; override;
    function GetWidth: Integer; override;
    procedure InitTabHitTest(AHitTest: TcxGridDetailsSiteTabHitTest); override;
    function UseOptimalHeight: Boolean; virtual;

    property CacheItem: TcxGridMasterTableViewInfoCacheItem read GetCacheItem;
    property MasterGridView: TcxGridTableView read GetMasterGridView;
    property MasterGridViewInfo: TcxGridTableViewInfo read GetMasterGridViewInfo;
    property MasterDataRowViewInfo: TcxGridMasterDataRowViewInfo read FMasterDataRowViewInfo;
  public
    constructor Create(AMasterDataRowViewInfo: TcxGridMasterDataRowViewInfo); reintroduce; virtual;
    destructor Destroy; override;
    procedure ChangeActiveTab(ALevel: TcxGridLevel; AFocusView: Boolean = False); override;
    function DetailHasData(ALevel: TcxGridLevel): Boolean; override;
    function HasMaxHeight: Boolean;
    function SupportsTabAccelerators: Boolean; override;
  end;

  // master data row

  TcxGridMasterDataRowLayoutViewInfo = class(TcxGridRowLayoutViewInfo)
  protected
    function CalculateWidth: Integer; override;
  end;

  { TcxGridExpandButtonCellViewInfo }

  TcxGridExpandButtonCellViewInfoClass = class of TcxGridExpandButtonCellViewInfo;

  TcxGridExpandButtonCellViewInfo = class(TcxGridCellViewInfo)
  private
    function GetRecordViewInfo: TcxGridMasterDataRowViewInfo;
    function GetRightBorderRestSpaceBounds: TRect;
  protected
    function CalculateHeight: Integer; override;
    function CalculateWidth: Integer; override;
    function GetBackgroundBitmap: TBitmap; override;
    function GetBaseWidth: Integer; virtual;
    function GetBorderBounds(AIndex: TcxBorder): TRect; override;
    function GetBorders: TcxBorders; override;
    function GetPainterClass: TcxCustomGridCellPainterClass; override;

    property BaseWidth: Integer read GetBaseWidth;
    property RightBorderRestSpaceBounds: TRect read GetRightBorderRestSpaceBounds;
  public
    function CanDrawHotTracked: Boolean; override;

    property RecordViewInfo: TcxGridMasterDataRowViewInfo read GetRecordViewInfo;
  end;

  { TcxGridDetailsAreaViewInfo }

  TcxGridDetailsAreaViewInfoClass = class of TcxGridDetailsAreaViewInfo;

  TcxGridDetailsAreaViewInfo = class(TcxGridCellViewInfo)
  private
    function GetRecordViewInfo: TcxGridMasterDataRowViewInfo;
  protected
    function CalculateHeight: Integer; override;
    function CalculateWidth: Integer; override;
    function GetBorders: TcxBorders; override;
  public
    property RecordViewInfo: TcxGridMasterDataRowViewInfo read GetRecordViewInfo;
  end;

  { TcxGridMasterDataRowViewInfo }

  TcxGridMasterDataRowViewInfo = class(TcxGridDataRowViewInfo)
  strict private
    FDetailsAreaViewInfo: TcxGridDetailsAreaViewInfo;
    FDetailsSiteViewInfo: TcxGridDetailsSiteViewInfo;
    FDetailsSiteVisible: Boolean;
    FExpandButtonCellViewInfo: TcxGridExpandButtonCellViewInfo;
    FRestHeight: Integer;
    function GetCacheItem: TcxGridMasterTableViewInfoCacheItem;
    function GetDetailsAreaViewInfo: TcxGridDetailsAreaViewInfo;
    function GetDetailsSiteIndentBounds: TRect;
    function GetDetailsSiteViewInfo: TcxGridDetailsSiteViewInfo;
    function GetExpandButtonCellViewInfo: TcxGridExpandButtonCellViewInfo;
    function GetGridRecord: TcxGridMasterDataRow;
  protected
    procedure CalculateExpandButtonBounds(var ABounds: TRect); override;
    function CalculateHeight: Integer; override;
    function CalculateRestHeight(ARowHeight: Integer): Integer; virtual;
    procedure ControlFocusChanged; override;
    function CreateLayoutViewInfo: TcxGridRowLayoutViewInfo; override;
    function GetDataHeight: Integer; override;
    function GetDataIndent: Integer; override;
    function GetDataRelativeIndent: Integer; override;
    function GetDataWidth: Integer; override;
    function GetDetailsSiteOptimalHeight: Integer; virtual;
    function GetDetailsSiteVisible: Boolean; virtual;
    function GetExpandButtonAreaBounds: TRect; override;
    function GetLastHorzGridLineBounds: TRect; override;
    function GetMaxHeight: Integer; override;
    function GetPixelScrollSize: Integer; override;
    function GetRowLayoutBackgroundRegion: TcxRegion; override;
    function HasExpandButtonCell: Boolean; virtual;
    function IsDetailVisible(ADetail: TcxCustomGridView): Boolean; override;
    function IsFullyVisible: Boolean; override;
    procedure VisibilityChanged(AVisible: Boolean); override;
    function ShowExpandButtonCell: Boolean; virtual;

    function GetPainterClass: TcxCustomGridCellPainterClass; override;

    function GetDetailsAreaViewInfoClass: TcxGridDetailsAreaViewInfoClass; virtual;
    function GetDetailsSiteViewInfoClass: TcxGridDetailsSiteViewInfoClass; virtual;
    function GetExpandButtonCellViewInfoClass: TcxGridExpandButtonCellViewInfoClass; virtual;

    property CacheItem: TcxGridMasterTableViewInfoCacheItem read GetCacheItem;
    property DetailsAreaViewInfo: TcxGridDetailsAreaViewInfo read GetDetailsAreaViewInfo;
    property DetailsSiteIndentBounds: TRect read GetDetailsSiteIndentBounds;
    property DetailsSiteOptimalHeight: Integer read GetDetailsSiteOptimalHeight;
    property ExpandButtonCellViewInfo: TcxGridExpandButtonCellViewInfo read GetExpandButtonCellViewInfo;
    property RestHeight: Integer read FRestHeight write FRestHeight;
  public
    constructor Create(ARecordsViewInfo: TcxCustomGridRecordsViewInfo;
      ARecord: TcxCustomGridRecord); override;
    destructor Destroy; override;
    procedure BeforeRecalculation; override;
    procedure Calculate(ALeftBound, ATopBound: Integer; AWidth: Integer = -1;
      AHeight: Integer = -1); override;
    procedure DoRightToLeftConversion(const ABounds: TRect); override;
    function GetHitTest(const P: TPoint): TcxCustomGridHitTest; override;
    function ProcessDialogChar(ACharCode: Word): Boolean; override;
    function SupportsTabAccelerators: Boolean; virtual;
    property DetailsSiteViewInfo: TcxGridDetailsSiteViewInfo read GetDetailsSiteViewInfo;
    property DetailsSiteVisible: Boolean read GetDetailsSiteVisible write FDetailsSiteVisible;
    property GridRecord: TcxGridMasterDataRow read GetGridRecord;
  end;

  // group row

  TcxGridGroupCellImageViewInfo = class(TcxCustomGridViewCellViewInfo)
  private
    FGroupCell: TcxGridGroupCellViewInfo;

    function GetGridRecord: TcxGridGroupRow;
    function GetGroupedColumn: TcxGridColumn;
    function GetImageAlign: TcxImageAlign;
    function GetImageIndex: TcxImageIndex;
    function GetImageProperties: TcxImageComboBoxProperties;
    function GetImages: TCustomImageList;
  protected
    function CalculateHeight: Integer; override;
    function CalculateWidth: Integer; override;
    function GetHeight: Integer; override;
    function GetHitTestClass: TcxCustomGridHitTestClass; override;
    function GetImageBounds: TRect; virtual;
    function GetPainterClass: TcxCustomGridCellPainterClass; override;
    procedure GetViewParams(var AParams: TcxViewParams); override;
    function GetWidth: Integer; override;

    property GridRecord: TcxGridGroupRow read GetGridRecord;
    property GroupCell: TcxGridGroupCellViewInfo read FGroupCell;
    property GroupedColumn: TcxGridColumn read GetGroupedColumn;
    property ImageAlign: TcxImageAlign read GetImageAlign;
    property ImageIndex: TcxImageIndex read GetImageIndex;
    property ImageProperties: TcxImageComboBoxProperties read GetImageProperties;
    property Images: TCustomImageList read GetImages;
  public
    constructor Create(AGroupCell: TcxGridGroupCellViewInfo); reintroduce; virtual;
  end;

  { TcxGridGroupCellViewInfo }

  TcxGridGroupCellViewInfo = class(TcxGridCellViewInfo)
  private
    FCheckBox: TcxGridRowCheckBoxViewInfo;
    FGroupedColumnAreaViewInfo: TcxGridGroupRowGroupedColumnAreaViewInfo;
    FImage: TcxGridGroupCellImageViewInfo;

    function GetExpandedAreaBounds: TRect;
    function GetGridRecord: TcxGridGroupRow;
    function GetGroupedColumn: TcxGridColumn;
    function GetGroupedColumnIndex: Integer;
    function GetRecordViewInfo: TcxGridGroupRowViewInfo;
    function GetRowStyle: TcxGridGroupRowStyle;
  protected
    function CalculateHeight: Integer; override;
    function CalculateWidth: Integer; override;
    function CanHighlightFindText: Boolean; override;
    function CustomDraw(ACanvas: TcxCanvas): Boolean; override;
    function CreateCheckBox: TcxGridRowCheckBoxViewInfo; virtual;
    function CreateImage: TcxGridGroupCellImageViewInfo; virtual;
    function DrawHotTrackedWhenRecordHotTracked: Boolean; override;
    function GetActualState: TcxGridCellState; override;
    function GetAlignmentVert: TcxAlignmentVert; override;
    function GetAlwaysSelected: Boolean; override;
    function GetBackgroundBitmap: TBitmap; override;
    function GetBorderBounds(AIndex: TcxBorder): TRect; override;
    function GetBorderColor(AIndex: TcxBorder): TColor; override;
    function GetBorders: TcxBorders; override;
    function GetBorderWidth(AIndex: TcxBorder): Integer; override;
    function GetButtonState: TcxButtonState; override;
    function GetCheckBoxBounds: TRect; virtual;
    function GetCheckBoxMargins: TRect; virtual;
    function GetContentRealRightBound: Integer; virtual;
    procedure GetFindTextSelectionInfo(out ASelStart: Integer; out AHighlightedText: string); override;
    function GetHitTestClass: TcxCustomGridHitTestClass; override;
    function GetImageBounds: TRect; virtual;
    function GetImageMargins: TRect; virtual;
    function GetPainterClass: TcxCustomGridCellPainterClass; override;
    function GetText: string; override;
    function GetTextAreaBounds: TRect; override;
    procedure GetViewParams(var AParams: TcxViewParams); override;
    function HasCustomDraw: Boolean; override;
    function HasCheckBox: Boolean; virtual;
    function HasImage: Boolean; virtual;
    function IsChildrenHotTracked: Boolean; override;
    procedure Offset(DX: Integer; DY: Integer); override;
    procedure ResetChildrenState; override;
    function ShowCheckBox: Boolean; virtual;
    function ShowExpandButton: Boolean; virtual;
    function ShowImage: Boolean; virtual;

    property CheckBox: TcxGridRowCheckBoxViewInfo read FCheckBox;
    property ExpandedAreaBounds: TRect read GetExpandedAreaBounds;
    property GroupedColumn: TcxGridColumn read GetGroupedColumn;
    property GroupedColumnAreaViewInfo: TcxGridGroupRowGroupedColumnAreaViewInfo read FGroupedColumnAreaViewInfo;
    property GroupedColumnIndex: Integer read GetGroupedColumnIndex;
    property Image: TcxGridGroupCellImageViewInfo read FImage;
    property RowStyle: TcxGridGroupRowStyle read GetRowStyle;
  public
    constructor Create(AGroupedColumnAreaViewInfo: TcxGridGroupRowGroupedColumnAreaViewInfo); reintroduce; virtual;
    destructor Destroy; override;

    procedure BeforeRecalculation; override;
    procedure Calculate(ALeftBound: Integer; ATopBound: Integer; AWidth: Integer = -1; AHeight: Integer = -1); override;
    function CanDrawSelected: Boolean; override;
    procedure DoRightToLeftConversion(const ABounds: TRect); override;
    function GetHitTest(const P: TPoint): TcxCustomGridHitTest; override;

    property GridRecord: TcxGridGroupRow read GetGridRecord;
    property RecordViewInfo: TcxGridGroupRowViewInfo read GetRecordViewInfo;
  end;

  { TcxGridGroupRowSpacerViewInfo }

  TcxGridGroupRowSpacerViewInfoClass = class of TcxGridGroupRowSpacerViewInfo;

  TcxGridGroupRowSpacerViewInfo = class(TcxCustomGridViewCellViewInfo)
  private
    FRowViewInfo: TcxGridGroupRowViewInfo;
    function GetGridView: TcxGridTableView;
  protected
    function CalculateWidth: Integer; override;
    function GetAlignmentVert: TcxAlignmentVert; override;
    function GetText: string; override;
    function GetTextAreaBounds: TRect; override;
    procedure GetViewParams(var AParams: TcxViewParams); override;
    function GetWidth: Integer; override;
    function HasBackground: Boolean; override;
  public
    constructor Create(ARowViewInfo: TcxGridGroupRowViewInfo; const AText: string); reintroduce; virtual;
    property GridView: TcxGridTableView read GetGridView;
    property RowViewInfo: TcxGridGroupRowViewInfo read FRowViewInfo;
  end;

  { TcxGridGroupSummaryCellViewInfo }

  TcxGridGroupSummaryCellViewInfoClass = class of TcxGridGroupSummaryCellViewInfo;

  TcxGridGroupSummaryCellViewInfo = class(TcxCustomGridViewCellViewInfo)
  private
    FGroupedColumnAreaViewInfo: TcxGridGroupRowGroupedColumnAreaViewInfo;
    FIsLast: Boolean;
    FSeparatorViewInfo: TcxGridGroupRowSpacerViewInfo;
    FSummaryItem: TcxDataSummaryItem;
    FValue: Variant;
    function GetColumn: TcxGridColumn;
    function GetGridView: TcxGridTableView;
    function GetRowViewInfo: TcxGridGroupRowViewInfo;
    procedure SetIsLast(Value: Boolean);
  protected
    function CalculateWidth: Integer; override;
    function CanAlignWithColumn: Boolean;
    function CustomDraw(ACanvas: TcxCanvas): Boolean; override;
    function GetAlignmentHorz: TAlignment; override;
    function GetAlignmentVert: TcxAlignmentVert; override;
    function GetDesignSelectionBounds: TRect; override;
    function GetHitTestClass: TcxCustomGridHitTestClass; override;
    function GetIsDesignSelected: Boolean; override;
    function GetPainterClass: TcxCustomGridCellPainterClass; override;
    function GetSeparatorBounds: TRect; virtual;
    function GetSeparatorText: string; virtual;
    function GetShowEndEllipsis: Boolean; override;
    function GetText: string; override;
    function GetTextAreaBounds: TRect; override;
    procedure GetViewParams(var AParams: TcxViewParams); override;
    function HasBackground: Boolean; override;
    function HasCustomDraw: Boolean; override;
    procedure InitHitTest(AHitTest: TcxCustomGridHitTest); override;
    procedure Offset(DX, DY: Integer); override;

    property GroupedColumnAreaViewInfo: TcxGridGroupRowGroupedColumnAreaViewInfo read FGroupedColumnAreaViewInfo;
  public
    constructor Create(AGroupedColumnAreaViewInfo: TcxGridGroupRowGroupedColumnAreaViewInfo; ASummaryItem: TcxDataSummaryItem;
      const AValue: Variant); reintroduce; virtual;
    destructor Destroy; override;
    procedure BeforeRecalculation; override;
    procedure Calculate(ALeftBound, ATopBound: Integer; AWidth: Integer = -1;
      AHeight: Integer = -1); override;
    procedure DoRightToLeftConversion(const ABounds: TRect); override;
    function MouseDown(AHitTest: TcxCustomGridHitTest; AButton: TMouseButton;
      AShift: TShiftState): Boolean; override;
    property Column: TcxGridColumn read GetColumn;
    property GridView: TcxGridTableView read GetGridView;
    property IsLast: Boolean read FIsLast write SetIsLast;
    property RowViewInfo: TcxGridGroupRowViewInfo read GetRowViewInfo;
    property SeparatorViewInfo: TcxGridGroupRowSpacerViewInfo read FSeparatorViewInfo;
    property SummaryItem: TcxDataSummaryItem read FSummaryItem;
    property Value: Variant read FValue;
  end;

  { TcxGridGroupRowGroupedColumnAreaViewInfo }

  TcxGridGroupRowGroupedColumnAreaViewInfo = class(TcxGridCellViewInfo)
  private
    FCellViewInfo: TcxGridGroupCellViewInfo;
    FGroupedColumnIndex: Integer;
    FSeparatorViewInfo: TcxGridGroupRowSpacerViewInfo;
    FSummaryCellViewInfos: TObjectList;
    FSummaryCellsWithoutColumns: TList;
    FSummaryBeginningSpacerViewInfo: TcxGridGroupRowSpacerViewInfo;
    FSummaryEndingSpacerViewInfo: TcxGridGroupRowSpacerViewInfo;

    function GetGridRecord: TcxGridGroupRow;
    function GetIsLast: Boolean;
    function GetRecordViewInfo: TcxGridGroupRowViewInfo;
    function GetSummaryCellViewInfo(Index: Integer): TcxGridGroupSummaryCellViewInfo;
    function GetSummaryCellViewInfoCount: Integer;
  protected
    function CalculateHeight: Integer; override;
    function CalculateWidth: Integer; override;
    function GetPainterClass: TcxCustomGridCellPainterClass; override;
    procedure Offset(DX: Integer; DY: Integer); override;

    //summary
    procedure AddSummaryCellViewInfo(ASummaryItem: TcxDataSummaryItem; const AValue: Variant);
    procedure CalculateSummaryCells; overload; virtual;
    procedure CalculateSummaryCells(ACellViewInfos: TList; const AAreaBounds: TRect; AAlignment: TAlignment;
      AAutoWidth: Boolean); overload; virtual;
    function CalculateSummaryCellWidths(ACellViewInfos: TList; AAvailableWidth: Integer;
      AAutoWidth: Boolean): TcxAutoWidthObject; virtual;
    function CreateSummaryCellViewInfo(ASummaryItem: TcxDataSummaryItem; const AValue: Variant): TcxGridGroupSummaryCellViewInfo;
    procedure CreateSummaryCellViewInfos; virtual;
    procedure CreateSummaryCellsWithoutColumns; virtual;
    function GetColumnSummaryCellsAreaBounds(AColumnHeaderViewInfo: TcxGridColumnHeaderViewInfo): TRect; virtual;
    procedure PopulateColumnSummaryCellViewInfos(AList: TList; AColumn: TcxGridColumn); virtual;
    function GetSummaryCellAutoWidth: Boolean; virtual;
    function GetSummaryCellsAreaBounds(AForAlignableCells: Boolean): TRect; virtual;
    function GetSummaryCellsBounds(const AAreaBounds: TRect; AWidths: TcxAutoWidthObject; AAlignment: TAlignment;
      AAutoWidth: Boolean): TRect; virtual;
    function GetSummaryCellViewInfoClass: TcxGridGroupSummaryCellViewInfoClass; virtual;
    function GetUnalignableSummaryCells: TList; virtual;
    function HasUnalignableSummaryCells: Boolean; virtual;

    //separators and spacers
    procedure CreateSeparatorViewInfo; virtual;
    function CreateSpacerViewInfo(const AText: string): TcxGridGroupRowSpacerViewInfo;
    procedure CreateSummaryBeginningSpacerViewInfo; virtual;
    procedure CreateSummaryEndingSpacerViewInfo; virtual;
    procedure CreateSummarySpacerViewInfos; virtual;
    function GetSeparatorBounds: TRect; virtual;
    function GetSeparatorText: string; virtual;
    function GetSpacerViewInfoClass: TcxGridGroupRowSpacerViewInfoClass; virtual;
    function GetSummaryBeginningSpacerBounds: TRect; virtual;
    function GetSummaryBeginningSpacerText: string; virtual;
    function GetSummaryEndingSpacerBounds: TRect; virtual;
    function GetSummaryEndingSpacerText: string; virtual;
    function HasSeparator: Boolean; virtual;
    function HasSummary: Boolean; virtual;
    function HasSummaryBeginningSpacer: Boolean; virtual;
    function HasSummaryEndingSpacer: Boolean; virtual;
    function IsChildrenHotTracked: Boolean; override;
    function NeedSeparator: Boolean; virtual;
    function NeedSpacers: Boolean; virtual;
    procedure ResetChildrenState; override;

    property GroupedColumnIndex: Integer read FGroupedColumnIndex;
    property IsLast: Boolean read GetIsLast;
    property SeparatorViewInfo: TcxGridGroupRowSpacerViewInfo read FSeparatorViewInfo;
    property SummaryBeginningSpacerViewInfo: TcxGridGroupRowSpacerViewInfo read FSummaryBeginningSpacerViewInfo;
    property SummaryCellAutoWidth: Boolean read GetSummaryCellAutoWidth;
    property SummaryCells: TObjectList read FSummaryCellViewInfos;
    property SummaryCellsWithoutColumns: TList read FSummaryCellsWithoutColumns;
    property SummaryEndingSpacerViewInfo: TcxGridGroupRowSpacerViewInfo read FSummaryEndingSpacerViewInfo;
    property UnalignableSummaryCells: TList read GetUnalignableSummaryCells;
  public
    constructor Create(ARecordViewInfo: TcxCustomGridRecordViewInfo; AGroupedColumnIndex: Integer); reintroduce; virtual;
    destructor Destroy; override;

    procedure BeforeRecalculation; override;
    procedure Calculate(ALeftBound: Integer; ATopBound: Integer; AWidth: Integer = -1; AHeight: Integer = -1); override;
    procedure DoRightToLeftConversion(const ABounds: TRect); override;
    function GetHitTest(const P: TPoint): TcxCustomGridHitTest; override;

    property CellViewInfo: TcxGridGroupCellViewInfo read FCellViewInfo;
    property GridRecord: TcxGridGroupRow read GetGridRecord;
    property RecordViewInfo: TcxGridGroupRowViewInfo read GetRecordViewInfo;
    property SummaryCellViewInfoCount: Integer read GetSummaryCellViewInfoCount;
    property SummaryCellViewInfos[Index: Integer]: TcxGridGroupSummaryCellViewInfo read GetSummaryCellViewInfo;
  end;

  { TcxGridGroupRowViewInfo }

  TcxGridGroupRowViewInfo = class(TcxCustomGridRowViewInfo)
  private
    FBottomBorderLeftPosition: Integer;
    FGroupedColumnAreaViewInfos: TdxFastObjectList;
    FIsFixed: Boolean;

    function GetGridRecord: TcxGridGroupRow;
    function GetGroupedColumnAreaViewInfoCount: Integer;
    function GetGroupedColumnAreaViewInfo(AIndex: Integer): TcxGridGroupRowGroupedColumnAreaViewInfo;
    function GetMainGroupedColumnAreaViewInfo: TcxGridGroupRowGroupedColumnAreaViewInfo;
    function GetRowStyle: TcxGridGroupRowStyle;
    function GetSummaryCellLayout: TcxGridGroupSummaryLayout;
  protected
    procedure AddGroupedColumnAreaViewInfo(AGroupedColumnIndex: Integer); virtual;
    procedure CalculateBottomBorderLeftPosition; virtual;
    procedure CalculateExpandButtonBounds(var ABounds: TRect); override;
    procedure CalculateGroupedColumnAreaViewInfo(ALeftBound, ATopBound: Integer); virtual;
    function CalculateHeight: Integer; override;
    function CanSize: Boolean; override;
    procedure CheckRowHeight(var AValue: Integer); override;
    function CreateGroupedColumnAreaViewInfo(AGroupedColumnIndex: Integer): TcxGridGroupRowGroupedColumnAreaViewInfo; virtual;
    procedure CreateGroupedColumnAreaViewInfos; virtual;
    function GetAlignmentVert: TcxAlignmentVert; override;
    function GetAutoHeight: Boolean; override;
    function GetBackgroundBitmap: TBitmap; override;
    function GetExpandButtonAreaBounds: TRect; override;
    function GetFixedState: TcxDataControllerRowFixedState; override;
    function GetFixedGroupIndicatorBounds: TRect; virtual;
    function GetFocusRectBounds: TRect; override;
    function GetPainterClass: TcxCustomGridCellPainterClass; override;
    function GetRealFixedGroupIndicatorBounds: TRect;
    function GetSeparatorBounds: TRect; override;
    function GetSeparatorIndentBounds: TRect; virtual;
    function GetShowSeparator: Boolean; override;
    function HasElongateBottomBorder: Boolean; virtual;
    function HasFixedGroupIndicator: Boolean; virtual;
    function HasFocusRect: Boolean; override;
    function HasFooter(ALevel: Integer): Boolean; override;
    function IsChildrenHotTracked: Boolean; override;
    procedure Offset(DX, DY: Integer); override;
    procedure ResetChildrenState; override;
    procedure SetFixedState(AValue: TcxDataControllerRowFixedState); override;
    procedure SetRowHeight(Value: Integer); override;

    //borders
    function GetBorderBounds(AIndex: TcxBorder): TRect; override;
    function GetBorderColor(AIndex: TcxBorder): TColor; override;
    function GetBorders: TcxBorders; override;
    function GetBorderWidth(AIndex: TcxBorder): Integer; override;
    function GetExpandButtonOwnerCellBounds: TRect; override;

    property FixedGroupIndicatorBounds: TRect read GetRealFixedGroupIndicatorBounds;
    property GroupedColumnAreaViewInfoCount: Integer read GetGroupedColumnAreaViewInfoCount;
    property GroupedColumnAreaViewInfos[AIndex: Integer]: TcxGridGroupRowGroupedColumnAreaViewInfo read GetGroupedColumnAreaViewInfo;
    property MainGroupedColumnAreaViewInfo: TcxGridGroupRowGroupedColumnAreaViewInfo read GetMainGroupedColumnAreaViewInfo;
    property RowStyle: TcxGridGroupRowStyle read GetRowStyle;
    property SummaryCellLayout: TcxGridGroupSummaryLayout read GetSummaryCellLayout;
  public
    constructor Create(ARecordsViewInfo: TcxCustomGridRecordsViewInfo; ARecord: TcxCustomGridRecord); override;
    destructor Destroy; override;

    procedure BeforeRecalculation; override;
    procedure Calculate(ALeftBound, ATopBound: Integer; AWidth: Integer = -1; AHeight: Integer = -1); override;
    procedure DoRightToLeftConversion(const ABounds: TRect); override;
    function GetHitTest(const P: TPoint): TcxCustomGridHitTest; override;

    property GridRecord: TcxGridGroupRow read GetGridRecord;
    property SeparatorIndentBounds: TRect read GetSeparatorIndentBounds;
  end;

implementation

uses
  SysUtils, Math, RTLConsts, cxVariants, cxGrid, cxEdit, dxOffice11, cxGridStrs,
  dxLayoutContainer, dxLayoutLookAndFeels, cxFilter, cxFilterControl, dxDPIAwareUtils, dxCoreGraphics;

const
  dxThisUnitName = 'cxGridRows';

const
  cxFilterRowOperatorButtonIndent = 1;
  cxFilterRowOperatorButtonImageIndent = 3;

type
  TcxControlAccess = class(TcxControl);
  TcxGridSiteAccess = class(TcxGridSite);
  TcxGridColumnAccess = class(TcxGridColumn);
  TcxGridGroupRowAccess = class(TcxGridGroupRow);
  TcxGridTableViewAccess = class(TcxGridTableView);
  TcxCustomGridViewAccess = class(TcxCustomGridView);
  TcxGridRowsViewInfoAccess = class(TcxGridRowsViewInfo);
  TcxGridHeaderViewInfoAccess = class(TcxGridHeaderViewInfo);
  TcxGridTableControllerAccess = class(TcxGridTableController);
  TcxGridRowCheckBoxViewInfoAccess = class(TcxGridRowCheckBoxViewInfo);
  TcxGridColumnHeaderViewInfoAccess = class(TcxGridColumnHeaderViewInfo);

{ TcxGridPreviewHitTest }

class function TcxGridPreviewHitTest.GetHitTestCode: Integer;
begin
  Result := htPreview;
end;

{ TcxGridInplaceEditFormButtonHitTest }

class function TcxGridInplaceEditFormButtonHitTest.GetHitTestCode: Integer;
begin
  Result := htInplaceEditFormButton;
end;

{ TcxGridInplaceEditFormCancelButtonHitTest }

class function TcxGridInplaceEditFormCancelButtonHitTest.GetHitTestCode: Integer;
begin
  Result := htInplaceEditFormCancelButton;
end;

{ TcxGridInplaceEditFormUpdateButtonHitTest }

class function TcxGridInplaceEditFormUpdateButtonHitTest.GetHitTestCode: Integer;
begin
  Result := htInplaceEditFormUpdateButton;
end;

{ TcxGridInplaceEditFormButtonsPanelHitTest }

class function TcxGridInplaceEditFormButtonsPanelHitTest.GetHitTestCode: Integer;
begin
  Result := htInplaceEditFormButtonsPanel
end;

{ TcxGridInplaceEditFormAreaHitTest }

class function TcxGridInplaceEditFormAreaHitTest.GetHitTestCode: Integer;
begin
  Result := htInplaceEditFormArea;
end;

{ TcxGridFilterRowOperatorHitTest }

class function TcxGridFilterRowOperatorHitTest.GetHitTestCode: Integer;
begin
  Result := htFilterRowOperator;
end;

{ TcxGridDataCellCheckBoxAreaPainter }

procedure TcxGridDataCellCheckBoxAreaPainter.DrawContent;
begin
  inherited DrawContent;
  ViewInfo.CheckBox.Paint;
end;

function TcxGridDataCellCheckBoxAreaPainter.GetViewInfo: TcxGridDataCellCheckBoxAreaViewInfo;
begin
  Result := TcxGridDataCellCheckBoxAreaViewInfo(inherited ViewInfo);
end;

{ TcxGridDataCellPainter }

function TcxGridDataCellPainter.GetViewInfo: TcxGridDataCellViewInfo;
begin
  Result := TcxGridDataCellViewInfo(inherited ViewInfo);
end;

function TcxGridDataCellPainter.CanDelayedDrawBorder: Boolean;
begin
  Result := not ExcludeFromClipRect and ViewInfo.RecordViewInfo.CanDelayedDrawDataCellBorders;
end;

procedure TcxGridDataCellPainter.DrawBorder(ABorder: TcxBorder);
begin
  if CanDelayedDrawBorder then
    ViewInfo.GridViewInfo.Painter.AddGridLine(ViewInfo.BorderBounds[ABorder])
  else
    inherited DrawBorder(ABorder);
end;

procedure TcxGridDataCellPainter.DrawContent;
begin
  inherited DrawContent;
  if ViewInfo.HasCheckBox then
    ViewInfo.CheckBoxArea.Paint;
  if ViewInfo.HasPin then
    ViewInfo.Pin.Paint;
end;

procedure TcxGridDataCellPainter.DrawEditViewInfo;
begin
  inherited DrawEditViewInfo;
  if ViewInfo.NeedFixedHighlight then
    DrawFixedHighlight;
end;

procedure TcxGridDataCellPainter.DrawFixedHighlight;
begin
  ViewInfo.GridViewInfo.Painter.DrawFixedHighlight(ViewInfo.EditViewInfo.Bounds);
end;

function TcxGridDataCellPainter.ExcludeFromClipRect: Boolean;
begin
  Result := (ViewInfo.FixedKind <> fkNone) or (ViewInfo.RecordViewInfo.CellsAreaViewInfo <> nil) and
    ViewInfo.RecordViewInfo.CellsAreaViewInfo.Visible;
end;

{ TcxGridFilterRowOperatorPainter }

procedure TcxGridFilterRowOperatorPainter.DrawContent;
begin
  inherited DrawContent;
  if NeedDrawButton then
    ViewInfo.LookAndFeelPainter.DrawScaledButton(Canvas, ViewInfo.ButtonBounds, ViewInfo.Text, ViewInfo.ButtonState, ScaleFactor);
  TcxFilterControlImagesHelper.DrawOperatorImage(Canvas, ViewInfo.FilterOperator, ViewInfo.ImageBounds,
    ViewInfo.LookAndFeelPainter, TdxAlphaColors.FromColor(ViewInfo.LookAndFeelPainter.DefaultContentTextColor), ScaleFactor);
end;

function TcxGridFilterRowOperatorPainter.NeedDrawButton: Boolean;
begin
  Result := ViewInfo.ButtonState in [cxbsHot, cxbsPressed];
end;

function TcxGridFilterRowOperatorPainter.GetViewInfo: TcxGridFilterRowOperatorViewInfo;
begin
  Result := TcxGridFilterRowOperatorViewInfo(inherited ViewInfo);
end;

{ TcxGridFilterDataCellPainter }

procedure TcxGridFilterRowCellPainter.DrawContent;
begin
  inherited DrawContent;
  if ViewInfo.HasOperatorViewInfo then
    ViewInfo.OperatorViewInfo.Paint(Canvas);
end;

function TcxGridFilterRowCellPainter.GetViewInfo: TcxGridFilterRowCellViewInfo;
begin
  Result := TcxGridFilterRowCellViewInfo(inherited ViewInfo);
end;

{ TcxGridRowLayoutPainter }

procedure TcxGridRowLayoutPainter.DrawBackground;
begin
  ViewInfo.LookAndFeelPainter.DrawDataRowLayoutSelectionScaled(Canvas, ViewInfo.Bounds, ViewInfo.ButtonState, ViewInfo.ScaleFactor);
end;

procedure TcxGridRowLayoutPainter.DrawContent;
begin
  inherited DrawContent;
  DrawGroups;
  DrawItems;
end;

procedure TcxGridRowLayoutPainter.DrawGroups;
begin
  ViewInfo.ContainerViewInfo.Paint(Canvas);
end;

procedure TcxGridRowLayoutPainter.DrawItems;
var
  I: Integer;
begin
  for I := 0 to ViewInfo.ItemViewInfos.Count - 1 do
    ViewInfo.ItemViewInfos[I].Paint(Canvas);
end;

function TcxGridRowLayoutPainter.GetViewInfo: TcxGridRowLayoutViewInfo;
begin
  Result := TcxGridRowLayoutViewInfo(inherited ViewInfo);
end;

{ TcxGridInplaceEditFormButtonPainter }

function TcxGridInplaceEditFormButtonPainter.CanDrawFocusRect: Boolean;
begin
  Result := ViewInfo.Focused;
end;

procedure TcxGridInplaceEditFormButtonPainter.DrawButton;
begin
  Canvas.Font := ViewInfo.Params.Font;
  ViewInfo.LookAndFeelPainter.DrawScaledButton(Canvas, ViewInfo.Bounds, ViewInfo.Text, ViewInfo.ButtonState, ScaleFactor);
end;

function TcxGridInplaceEditFormButtonPainter.ExcludeFromClipRect: Boolean;
begin
  Result := False;
end;

function TcxGridInplaceEditFormButtonPainter.GetGridViewInfo: TcxCustomGridViewInfo;
begin
  Result := ViewInfo.GridViewInfo;
end;

procedure TcxGridInplaceEditFormButtonPainter.Paint;
begin
  DrawButton;
  DrawFocusRect;
end;

function TcxGridInplaceEditFormButtonPainter.GetViewInfo: TcxGridInplaceEditFormButtonViewInfo;
begin
  Result := TcxGridInplaceEditFormButtonViewInfo(inherited ViewInfo);
end;

{ TcxGridInplaceEditFormButtonsPanelPainter }

procedure TcxGridInplaceEditFormButtonsPanelPainter.DrawBackground;
begin
//do nothing
end;

procedure TcxGridInplaceEditFormButtonsPanelPainter.DrawButtons;
var
  I: Integer;
begin
  for I := 0 to ViewInfo.ButtonCount - 1 do
    ViewInfo.Items[I].Paint(Canvas);
end;

procedure TcxGridInplaceEditFormButtonsPanelPainter.DrawContent;
begin
  inherited DrawContent;
  DrawSeparator;
  DrawButtons;
end;

procedure TcxGridInplaceEditFormButtonsPanelPainter.DrawSeparator;
begin
  ViewInfo.LookAndFeelPainter.DrawSeparator(Canvas, ViewInfo.GetSeparatorBound, False);
end;

function TcxGridInplaceEditFormButtonsPanelPainter.GetViewInfo: TcxGridInplaceEditFormButtonsPanelViewInfo;
begin
  Result := TcxGridInplaceEditFormButtonsPanelViewInfo(inherited ViewInfo);
end;

{ TcxGridInplaceEditFormAreaPainter }

procedure TcxGridInplaceEditFormAreaPainter.DrawBackground;
var
  R: TRect;
begin
  R := cxRectInflate(ViewInfo.Bounds, 1, 0);
  Canvas.SaveClipRegion;
  try
    Canvas.ExcludeFrameRect(R, 1, [bLeft, bRight]);
    ViewInfo.LookAndFeelPainter.LayoutViewDrawScaledRecordContent(Canvas, R,
      cxgpCenter, cxbsNormal, ScaleFactor, [bTop, bBottom]);
  finally
    Canvas.RestoreClipRegion;
  end;
end;

procedure TcxGridInplaceEditFormAreaPainter.DrawButtonsPanel;
begin
  ViewInfo.ButtonsPanelViewInfo.Paint(Canvas);
end;

procedure TcxGridInplaceEditFormAreaPainter.DrawContent;
begin
  inherited DrawContent;
  DrawInplaceEditFormContainer;
  DrawButtonsPanel;
end;

procedure TcxGridInplaceEditFormAreaPainter.DrawGridViewItems;
var
  I: Integer;
begin
  for I := 0 to ViewInfo.GridItemViewInfos.Count - 1 do
    ViewInfo.GridItemViewInfos[I].Paint(Canvas);
end;

procedure TcxGridInplaceEditFormAreaPainter.DrawInplaceEditFormContainer;
var
  AClipRegion: TcxRegion;
  ATopBorderBounds: TRect;
begin
  ATopBorderBounds := ViewInfo.Bounds;
  ATopBorderBounds.Bottom := ATopBorderBounds.Top + 1;
  AClipRegion := Canvas.GetClipRegion;
  try
    Canvas.IntersectClipRect(ViewInfo.Bounds);
    Canvas.ExcludeClipRect(ViewInfo.ButtonsPanelViewInfo.Bounds);
    Canvas.ExcludeClipRect(ATopBorderBounds);
    DrawLayoutGroups;
    DrawGridViewItems;
  finally
    Canvas.SetClipRegion(AClipRegion, roSet);
  end;
end;

procedure TcxGridInplaceEditFormAreaPainter.DrawLayoutGroups;
begin
  ViewInfo.ContainerViewInfo.Paint(Canvas);
end;

function TcxGridInplaceEditFormAreaPainter.GetViewInfo: TcxGridInplaceEditFormAreaViewInfo;
begin
  Result := TcxGridInplaceEditFormAreaViewInfo(inherited ViewInfo);
end;

{ TcxGridDataRowPainter }

function TcxGridDataRowPainter.GetViewInfo: TcxGridDataRowViewInfo;
begin
  Result := TcxGridDataRowViewInfo(inherited ViewInfo);
end;

procedure TcxGridDataRowPainter.DrawBackground;
begin
  inherited DrawBackground;
  if ViewInfo.HasRowLayoutBackground then
    DrawLayoutBackground;
end;

procedure TcxGridDataRowPainter.DrawCells;
begin
  if ViewInfo.CellsAreaViewInfo <> nil then
    ViewInfo.RecordsViewInfo.PainterClass.DrawDataRowCells(ViewInfo);
  if ViewInfo.HasPreview and (ViewInfo.PreviewViewInfo.Height <> 0) then
    ViewInfo.PreviewViewInfo.Paint;
end;

procedure TcxGridDataRowPainter.DrawFixedRowsSeparator;
begin
  ViewInfo.LookAndFeelPainter.DrawFilterRowSeparator(Canvas, ViewInfo.GetFixedRowsSeparatorBounds,
    ViewInfo.GridView.FixedDataRows.GetSeparatorColor);
end;

procedure TcxGridDataRowPainter.DrawInplaceEditFormArea;
begin
  if (ViewInfo.InplaceEditFormAreaViewInfo <> nil) and
    (ViewInfo.InplaceEditFormAreaViewInfo.Height <> 0) then
    ViewInfo.InplaceEditFormAreaViewInfo.Paint;
end;

procedure TcxGridDataRowPainter.DrawLayout;
begin
  if ViewInfo.LayoutViewInfo <> nil then
    ViewInfo.LayoutViewInfo.Paint;
end;

procedure TcxGridDataRowPainter.DrawLayoutBackground;
begin
  Canvas.SaveClipRegion;
  try
    if not ViewInfo.CustomDrawRowLayoutBackground(Canvas) then
    begin
      Canvas.SetClipRegion(ViewInfo.GetRowLayoutBackgroundRegion, roIntersect);
      ViewInfo.LookAndFeelPainter.DrawDataRowLayoutContent(Canvas, ViewInfo.Bounds);
    end;
  finally
    Canvas.RestoreClipRegion;
  end;
end;

procedure TcxGridDataRowPainter.DrawTopRightEmptyArea;
begin
  Canvas.FillRect(ViewInfo.EmptyAreaBounds, ViewInfo.Params.Color);
end;

function TcxGridDataRowPainter.ExcludeFromClipRect: Boolean;
begin
  Result := ViewInfo.FixedState <> rfsNotFixed;
end;

function TcxGridDataRowPainter.GetShowCells: Boolean;
begin
  Result := True;
end;

procedure TcxGridDataRowPainter.Paint;
begin
  if ShowCells then
  begin
    Canvas.SaveClipRegion;
    try
      DrawLayout;
      DrawInplaceEditFormArea;
      DrawCells;
      DrawTopRightEmptyArea;
    finally
      Canvas.RestoreClipRegion;
    end;
  end;
  inherited Paint;
  if ViewInfo.ShowFixedRowsSeparator then
    DrawFixedRowsSeparator;
end;

{ TcxGridNewItemRowPainter }

function TcxGridNewItemRowPainter.GetViewInfo: TcxGridNewItemRowViewInfo;
begin
  Result := TcxGridNewItemRowViewInfo(inherited ViewInfo);
end;

procedure TcxGridNewItemRowPainter.DrawBackground;
begin
  if not ShowCells and not ViewInfo.Transparent then
    DrawBackground(ViewInfo.ContentBounds)
  else
    inherited DrawBackground;
end;

procedure TcxGridNewItemRowPainter.DrawSeparator;
begin
  ViewInfo.LookAndFeelPainter.DrawFilterRowSeparator(Canvas, ViewInfo.SeparatorBounds, ViewInfo.SeparatorColor);
end;

function TcxGridNewItemRowPainter.ExcludeFromClipRect: Boolean;
begin
  Result := True;
end;

function TcxGridNewItemRowPainter.GetShowCells: Boolean;
begin
  Result := ViewInfo.Text = '';
end;

procedure TcxGridNewItemRowPainter.Paint;
begin
  inherited Paint;
  DrawText;
end;

{ TcxGridMasterDataRowDetailsSiteTabsPainter }

function TcxGridMasterDataRowDetailsSiteTabsPainter.GetViewInfo: TcxGridMasterDataRowDetailsSiteLeftTabsViewInfo;
begin
  Result := TcxGridMasterDataRowDetailsSiteLeftTabsViewInfo(inherited ViewInfo);
end;

procedure TcxGridMasterDataRowDetailsSiteTabsPainter.DrawBottomGridLine;
begin
  Canvas.Brush.Color := ViewInfo.BottomGridLineColor;
  Canvas.FillRect(ViewInfo.BottomGridLineBounds);
end;

procedure TcxGridMasterDataRowDetailsSiteTabsPainter.Paint;
begin
  inherited;
  if ViewInfo.HasBottomGridLine then
    DrawBottomGridLine;
end;

{ TcxGridExpandButtonCellPainter }

function TcxGridExpandButtonCellPainter.GetViewInfo: TcxGridExpandButtonCellViewInfo;
begin
  Result := TcxGridExpandButtonCellViewInfo(inherited ViewInfo);
end;

procedure TcxGridExpandButtonCellPainter.DrawBackground(const R: TRect);
begin
  if ViewInfo.RecordViewInfo.HasRowLayoutBackground then
    Exit;
  inherited DrawBackground(R);
end;

procedure TcxGridExpandButtonCellPainter.DrawBorder(ABorder: TcxBorder);

  function IsFarBorder(ABorder: TcxBorder): Boolean;
  begin
    if ViewInfo.IsRightToLeftConverted then
      Result := ABorder = bLeft
    else
      Result := ABorder = bRight;
  end;

begin
  inherited;
  if IsFarBorder(ABorder) and not ViewInfo.Transparent then
    DrawBackground(ViewInfo.RightBorderRestSpaceBounds);
end;

{ TcxGridMasterDataRowPainter }

function TcxGridMasterDataRowPainter.GetViewInfo: TcxGridMasterDataRowViewInfo;
begin
  Result := TcxGridMasterDataRowViewInfo(inherited ViewInfo);
end;

procedure TcxGridMasterDataRowPainter.DrawCells;
begin
  inherited;
  if ViewInfo.HasExpandButtonCell then
    DrawExpandButtonCell;
end;

procedure TcxGridMasterDataRowPainter.DrawDetailsSite;
begin
  ViewInfo.DetailsSiteViewInfo.Paint(Canvas);
  ViewInfo.GridViewInfo.Painter.ExcludeFromBackground(ViewInfo.DetailsSiteViewInfo.Bounds);
end;

{procedure TcxGridMasterDataRowPainter.DrawDetailsArea;
begin
  ViewInfo.DetailsAreaViewInfo.Paint;
end;}

procedure TcxGridMasterDataRowPainter.DrawExpandButtonCell;

  procedure SetExcludeClipRect;
  begin
    Canvas.ExcludeClipRect(GetRealCellsBounds);
    if ViewInfo.HasPreview then
      Canvas.ExcludeClipRect(ViewInfo.PreviewViewInfo.Bounds);
    if ViewInfo.InplaceEditFormAreaViewInfo <> nil then
      Canvas.ExcludeClipRect(ViewInfo.InplaceEditFormAreaViewInfo.Bounds);
    if ViewInfo.LayoutViewInfo <> nil then
      Canvas.ExcludeClipRect(ViewInfo.LayoutViewInfo.Bounds);
  end;

var
  AClipRegion: TcxRegion;
begin
  AClipRegion := Canvas.GetClipRegion;
  try
    SetExcludeClipRect;
    ViewInfo.ExpandButtonCellViewInfo.Paint;
  finally
    Canvas.SetClipRegion(AClipRegion, roSet);
  end;
end;

procedure TcxGridMasterDataRowPainter.ExcludeFromBackground;
begin
  if ViewInfo.DetailsSiteVisible then
  begin
    if ViewInfo.HasPreview then
    ExcludeRectFromBackground(ViewInfo.PreviewViewInfo.Bounds);
    if ViewInfo.HasExpandButtonCell then
      ExcludeRectFromBackground(ViewInfo.ExpandButtonCellViewInfo.Bounds);
    if ViewInfo.InplaceEditFormAreaViewInfo <> nil then
      ExcludeRectFromBackground(ViewInfo.InplaceEditFormAreaViewInfo.Bounds);
    if ViewInfo.LayoutViewInfo <> nil then
      ExcludeRectFromBackground(ViewInfo.LayoutViewInfo.Bounds);
    ExcludeRectFromBackground(GetRealCellsBounds);
    if ViewInfo.HasLastHorzGridLine then
      ExcludeRectFromBackground(ViewInfo.LastHorzGridLineBounds);
  end
  else
    inherited ExcludeFromBackground;
end;

function TcxGridMasterDataRowPainter.GetExpandButtonState: TcxExpandButtonState;
begin
  Result := cebsNormal;
end;

function TcxGridMasterDataRowPainter.GetRealCellsBounds: TRect;
begin
  Result := ViewInfo.CellsAreaBounds;
  if ViewInfo.UseRightToLeftAlignment then
    Result := TdxRightToLeftLayoutConverter.ConvertRect(Result, ViewInfo.Bounds);
end;

function TcxGridMasterDataRowPainter.NeedsPainting: Boolean;
begin
  Result := inherited NeedsPainting or
    ViewInfo.DetailsSiteVisible and Canvas.RectVisible(ViewInfo.DetailsAreaViewInfo.GetAreaBoundsForPainting);
end;

procedure TcxGridMasterDataRowPainter.Paint;
begin
  if ViewInfo.DetailsSiteVisible then
  begin
    DrawDetailsSite;
    //DrawDetailsArea;
  end;
  inherited;
end;

{ TcxGridGroupCellImagePainter }

procedure TcxGridGroupCellImagePainter.DrawContent;
begin
  inherited DrawContent;
  DrawImage;
end;

procedure TcxGridGroupCellImagePainter.DrawImage;
begin
  TdxImageDrawer.DrawImage(Canvas, ViewInfo.GetImageBounds, nil, ViewInfo.Images, ViewInfo.ImageIndex, ifmProportionalStretch);
end;

function TcxGridGroupCellImagePainter.GetViewInfo: TcxGridGroupCellImageViewInfo;
begin
  Result := TcxGridGroupCellImageViewInfo(inherited ViewInfo);
end;

{ TcxGridGroupCellPainter }

function TcxGridGroupCellPainter.GetViewInfo: TcxGridGroupCellViewInfo;
begin
  Result := TcxGridGroupCellViewInfo(inherited ViewInfo);
end;

procedure TcxGridGroupCellPainter.DrawBackground(const R: TRect);
begin
  inherited DrawBackground(R);
  if ViewInfo.GridView.RowLayout.Active and (ViewInfo.Selected or ViewInfo.HotTracked) then
    ViewInfo.LookAndFeelPainter.DrawDataRowLayoutSelectionScaled(Canvas, R, ViewInfo.ButtonState, ViewInfo.ScaleFactor);
end;

procedure TcxGridGroupCellPainter.DrawBorder(ABorder: TcxBorder);
begin
  inherited;
  with Canvas, ViewInfo do
    if (ABorder = bBottom) and GridRecord.Expanded then
      if GridViewInfo.LevelIndentBackgroundBitmap = nil then
      begin
        Brush.Color := GridViewInfo.LevelIndentColors[GridRecord.Level];
        FillRect(ExpandedAreaBounds);
      end
      else
        FillRect(ExpandedAreaBounds, GridViewInfo.LevelIndentBackgroundBitmap);
end;

procedure TcxGridGroupCellPainter.DrawContent;
begin
  inherited DrawContent;
  if ViewInfo.HasCheckBox then
    ViewInfo.CheckBox.Paint;
  if ViewInfo.HasImage then
    ViewInfo.Image.Paint;
end;

{ TcxGridGroupSummaryCellPainter }

function TcxGridGroupSummaryCellPainter.GetViewInfo: TcxGridGroupSummaryCellViewInfo;
begin
  Result := TcxGridGroupSummaryCellViewInfo(inherited ViewInfo);
end;

procedure TcxGridGroupSummaryCellPainter.Paint;
begin
  inherited;
  ViewInfo.SeparatorViewInfo.Paint(Canvas);
end;

{ TcxGridGroupRowGroupedColumnAreaPainter }

procedure TcxGridGroupRowGroupedColumnAreaPainter.DrawCell;
begin
  ViewInfo.CellViewInfo.Paint;
end;

procedure TcxGridGroupRowGroupedColumnAreaPainter.DrawSeparator;
begin
  if ViewInfo.HasSeparator then
    ViewInfo.SeparatorViewInfo.Paint(Canvas);
end;

procedure TcxGridGroupRowGroupedColumnAreaPainter.DrawSummary;
begin
  DrawSummaryBeginningSpacer;
  DrawSummaryCells;
  DrawSummaryEndingSpacer;
end;

procedure TcxGridGroupRowGroupedColumnAreaPainter.DrawSummaryBeginningSpacer;
begin
  if ViewInfo.SummaryBeginningSpacerViewInfo <> nil then
    ViewInfo.SummaryBeginningSpacerViewInfo.Paint(Canvas);
end;

procedure TcxGridGroupRowGroupedColumnAreaPainter.DrawSummaryCells;
var
  I: Integer;
begin
  for I := 0 to ViewInfo.SummaryCellViewInfoCount - 1 do
    ViewInfo.SummaryCellViewInfos[I].Paint(Canvas);
end;

procedure TcxGridGroupRowGroupedColumnAreaPainter.DrawSummaryEndingSpacer;
begin
  if ViewInfo.SummaryEndingSpacerViewInfo <> nil then
    ViewInfo.SummaryEndingSpacerViewInfo.Paint(Canvas);
end;

procedure TcxGridGroupRowGroupedColumnAreaPainter.Paint;
begin
  DrawCell;
  DrawSummary;
  DrawSeparator;
end;

function TcxGridGroupRowGroupedColumnAreaPainter.GetViewInfo: TcxGridGroupRowGroupedColumnAreaViewInfo;
begin
  Result := TcxGridGroupRowGroupedColumnAreaViewInfo(inherited ViewInfo);
end;

{ TcxGridGroupRowPainter }

function TcxGridGroupRowPainter.GetViewInfo: TcxGridGroupRowViewInfo;
begin
  Result := TcxGridGroupRowViewInfo(inherited ViewInfo);
end;

procedure TcxGridGroupRowPainter.DrawBackground;
begin
end;

procedure TcxGridGroupRowPainter.DrawFixedGroupIndicator;
begin
  ViewInfo.LookAndFeelPainter.DrawScaledFixedGroupIndicator(Canvas, ViewInfo.FixedGroupIndicatorBounds, ScaleFactor);
end;

procedure TcxGridGroupRowPainter.DrawGroupedColumnAreas;
var
  I: Integer;
begin
  for I := 0 to ViewInfo.GroupedColumnAreaViewInfoCount - 1 do
    ViewInfo.GroupedColumnAreaViewInfos[I].Paint;
end;

procedure TcxGridGroupRowPainter.DrawSeparator;
var
  R: TRect;
begin
  R := ViewInfo.SeparatorIndentBounds;
  if not IsRectEmpty(R) then
    DrawIndentPart(ViewInfo.Level, R);
  inherited;
end;

function TcxGridGroupRowPainter.ExcludeFromClipRect: Boolean;
begin
  Result := ViewInfo.FixedState = rfsFixedToTop;
end;

procedure TcxGridGroupRowPainter.Paint;
begin
  DrawGroupedColumnAreas;
  inherited Paint;
  if ViewInfo.HasFixedGroupIndicator then
    DrawFixedGroupIndicator;
  DrawBorders;
end;

{ TcxGridCellViewInfo }

function TcxGridCellViewInfo.GetGridView: TcxGridTableView;
begin
  Result := TcxGridTableView(inherited GridView);
end;

function TcxGridCellViewInfo.GetGridLines: TcxGridLines;
begin
  Result := RecordViewInfo.GridLines;
end;

function TcxGridCellViewInfo.GetGridRecord: TcxCustomGridRow;
begin
  Result := TcxCustomGridRow(inherited GridRecord);
end;

function TcxGridCellViewInfo.GetGridViewInfo: TcxGridTableViewInfo;
begin
  Result := TcxGridTableViewInfo(inherited GridViewInfo);
end;

function TcxGridCellViewInfo.GetRecordViewInfo: TcxCustomGridRowViewInfo;
begin
  Result := TcxCustomGridRowViewInfo(inherited RecordViewInfo);
end;

function TcxGridCellViewInfo.GetBorderColor(AIndex: TcxBorder): TColor;
begin
  Result := GridViewInfo.GridLineColor;
end;

function TcxGridCellViewInfo.GetBorderWidth(AIndex: TcxBorder): Integer;
begin
  Result := GridViewInfo.GridLineWidth;
end;

procedure TcxGridCellViewInfo.GetViewParams(var AParams: TcxViewParams);
begin
  GridView.Styles.GetDataCellParams(GridRecord, nil, AParams, True, Self);
end;

{ TcxGridPinViewInfo }

constructor TcxGridDataCellPinViewInfo.Create(ACellViewInfo: TcxGridDataCellViewInfo);
begin
  FCellViewInfo := ACellViewInfo;
  inherited Create(CellViewInfo.GridViewInfo);
end;

function TcxGridDataCellPinViewInfo.MouseDown(AHitTest: TcxCustomGridHitTest; AButton: TMouseButton;
  AShift: TShiftState): Boolean;

  function FindSelf(AGridView: TcxGridTableView; ARowIndex: Integer; AColumn: TcxGridColumn): TcxGridDataCellPinViewInfo;
  var
    ARow: TcxCustomGridRow;
    ACellViewInfo: TcxGridTableDataCellViewInfo;
    ARecordViewInfo: TcxCustomGridRecordViewInfo;
    ADataRowViewInfo: TcxGridDataRowViewInfo absolute ARecordViewInfo;
    ADataCellViewInfo: TcxGridDataCellViewInfo absolute ACellViewInfo;
  begin
    ARow := AGridView.ViewData.Rows[ARowIndex];
    ARecordViewInfo := AGridView.ViewInfo.RecordsViewInfo.GetRealItem(ARow);
    ACellViewInfo := ADataRowViewInfo.FindCellViewInfoInTableRow(AColumn);
    Result := ADataCellViewInfo.Pin;
  end;

var
  ARowIndex: Integer;
  ALink: TcxObjectLink;
  AColumn: TcxGridColumn;
  AGridView: TcxGridTableView;
  ASelf: TcxGridDataCellPinViewInfo;
begin
  Result := inherited MouseDown(AHitTest, AButton, AShift);
  ALink := cxAddObjectLink(Self);
  try
    AGridView := GridView;
    AColumn := CellViewInfo.Item;
    ARowIndex := RowViewInfo.GridRecord.Index;
    RowViewInfo.GridRecord.Focused := True;
    AGridView.Controller.FocusedItem := AColumn;
    if ALink.Ref = nil then
      ASelf := FindSelf(AGridView, ARowIndex, AColumn)
    else
      ASelf := Self;
    if (AButton = mbLeft) and ASelf.CanToggle then
      ASelf.Toggle;
  finally
    cxRemoveObjectLink(ALink);
  end;
end;

function TcxGridDataCellPinViewInfo.CalculateHeight: Integer;
begin
  Result := CellViewInfo.Height;
end;

function TcxGridDataCellPinViewInfo.CalculatePinned: Boolean;
begin
  Result := RowViewInfo.FixedState <> rfsNotFixed;
end;

function TcxGridDataCellPinViewInfo.CanDrawImage: Boolean;
begin
  Result := Pinned or GridView.OptionsCustomize.DataRowFixing and (Options.PinClickAction <> rpcaNone) and
    ((State = gcsPressed) or IsHotTracked or (Options.PinVisibility = rpvAlways) or
    (Options.PinVisibility = rpvRowHotTrack) and TcxGridTableControllerAccess(Controller).IsRecordHot(RowViewInfo));
end;

function TcxGridDataCellPinViewInfo.CanToggle: Boolean;
begin
  Result := GridView.OptionsCustomize.DataRowFixing and (Options.PinClickAction <> rpcaNone);
end;

function TcxGridDataCellPinViewInfo.GetImageSize: TSize;
begin
  Result := inherited GetImageSize;
  if Options.PinSize.Width > 0 then
    Result.cx := Options.PinSize.Width;
  if Options.PinSize.Height > 0 then
    Result.cy := Options.PinSize.Height;
end;

procedure TcxGridDataCellPinViewInfo.GetViewParams(var AParams: TcxViewParams);
begin
  CellViewInfo.GetViewParams(AParams);
end;

procedure TcxGridDataCellPinViewInfo.Toggle;
begin
  RowViewInfo.ToggleFixedState(cxRectOffset(Bounds, -1, -1));
end;

function TcxGridDataCellPinViewInfo.GetGridView: TcxGridTableView;
begin
  Result := TcxGridTableView(inherited GridView);
end;

function TcxGridDataCellPinViewInfo.GetOptions: TcxGridFixedDataRowsOptions;
begin
  Result := GridView.FixedDataRows;
end;

function TcxGridDataCellPinViewInfo.GetRowViewInfo: TcxGridDataRowViewInfo;
begin
  Result := CellViewInfo.RecordViewInfo;
end;

{ TcxGridDataCellCheckBoxAreaViewInfo }

constructor TcxGridDataCellCheckBoxAreaViewInfo.Create(ACellViewInfo: TcxGridDataCellViewInfo);
begin
  FDataCell := ACellViewInfo;
  inherited Create(DataCell.GridViewInfo);
  FCheckBox := CreateCheckBox;
end;

destructor TcxGridDataCellCheckBoxAreaViewInfo.Destroy;
begin
  FreeAndNil(FCheckBox);
  inherited Destroy;
end;

procedure TcxGridDataCellCheckBoxAreaViewInfo.AfterRecalculation;
begin
  CheckBox.AfterRecalculation;
  inherited AfterRecalculation;
end;

procedure TcxGridDataCellCheckBoxAreaViewInfo.BeforeRecalculation;
begin
  inherited BeforeRecalculation;
  CheckBox.BeforeRecalculation;
end;

procedure TcxGridDataCellCheckBoxAreaViewInfo.Calculate(ALeftBound, ATopBound, AWidth, AHeight: Integer);
begin
  inherited Calculate(ALeftBound, ATopBound, AWidth, AHeight);
  CheckBox.Calculate(CheckBoxBounds);
end;

function TcxGridDataCellCheckBoxAreaViewInfo.GetHitTest(const P: TPoint): TcxCustomGridHitTest;
var
  AHitTest: TcxCustomGridHitTest;
begin
  Result := inherited GetHitTest(P);
  AHitTest := CheckBox.GetHitTest(P);
  if AHitTest <> nil then
    Result := AHitTest;
end;

function TcxGridDataCellCheckBoxAreaViewInfo.CalculateHeight: Integer;
begin
  Result := DataCell.Height;
end;

function TcxGridDataCellCheckBoxAreaViewInfo.CalculateWidth: Integer;
begin
  Result := GetMargins.Left + CheckBox.Width + GetMargins.Right;
end;

function TcxGridDataCellCheckBoxAreaViewInfo.CreateCheckBox: TcxGridRowCheckBoxViewInfo;
begin
  Result := TcxGridRowCheckBoxViewInfo.Create(DataCell.RecordViewInfo);
end;

procedure TcxGridDataCellCheckBoxAreaViewInfo.DoRightToLeftConversion(const ABounds: TRect);
begin
  inherited DoRightToLeftConversion(ABounds);
  CheckBox.RightToLeftConversion(ABounds);
end;

function TcxGridDataCellCheckBoxAreaViewInfo.GetCheckBoxBounds: TRect;
begin
  Result := cxRectCenterVertically(Bounds, CheckBox.Height);
  Result := cxRectSetLeft(Result, Result.Left + GetMargins.Left, CheckBox.Width);
  Inc(Result.Top, GetMargins.Top);
  Dec(Result.Bottom, GetMargins.Bottom);
end;

function TcxGridDataCellCheckBoxAreaViewInfo.GetHeight: Integer;
begin
  Result := CalculateHeight;
end;

function TcxGridDataCellCheckBoxAreaViewInfo.GetHitTestClass: TcxCustomGridHitTestClass;
begin
  Result := nil;
end;

function TcxGridDataCellCheckBoxAreaViewInfo.GetMargins: TRect;
begin
  Result := ScaleFactor.Apply(Rect(cxGridDataCellCheckBoxLeftMargin, 0, cxGridDataCellCheckBoxRightMargin, 0));
end;

function TcxGridDataCellCheckBoxAreaViewInfo.GetPainterClass: TcxCustomGridCellPainterClass;
begin
  Result := TcxGridDataCellCheckBoxAreaPainter;
end;

procedure TcxGridDataCellCheckBoxAreaViewInfo.GetViewParams(var AParams: TcxViewParams);
begin
  DataCell.GetViewParams(AParams);
end;

function TcxGridDataCellCheckBoxAreaViewInfo.GetWidth: Integer;
begin
  Result := CalculateWidth;
end;

function TcxGridDataCellCheckBoxAreaViewInfo.IsChildrenHotTracked: Boolean;
begin
  Result := inherited IsChildrenHotTracked or CheckBox.IsHotTracked;
end;

procedure TcxGridDataCellCheckBoxAreaViewInfo.Offset(DX, DY: Integer);
begin
  inherited Offset(DX, DY);
  CheckBox.DoOffset(DX, DY);
end;

procedure TcxGridDataCellCheckBoxAreaViewInfo.ResetChildrenState;
begin
  inherited ResetChildrenState;
  TcxGridRowCheckBoxViewInfoAccess(CheckBox).ResetState;
end;

{ TcxGridDataCellViewInfo }

constructor TcxGridDataCellViewInfo.Create(ARecordViewInfo: TcxCustomGridRecordViewInfo; AItem: TcxCustomGridTableItem);
begin
  inherited Create(ARecordViewInfo, AItem);
  if ShowCheckBox then
    FCheckBoxArea := TcxGridDataCellCheckBoxAreaViewInfo.Create(Self);
  if ShowPin then
    FPin := TcxGridDataCellPinViewInfo.Create(Self);
end;

destructor TcxGridDataCellViewInfo.Destroy;
var
  I: Integer;
begin
  FreeAndNil(FPin);
  FreeAndNil(FCheckBoxArea);
  if FIsMerging then
  begin
    for I := 0 to MergedCellCount - 1 do
      MergedCells[I].FMergingCell := nil;
    FMergedCells.Free;
  end  
  else
    if FIsMerged and (FMergingCell <> nil) then
      FMergingCell.RemoveMergedCell(Self);
  inherited;
end;

function TcxGridDataCellViewInfo.GetCacheItem: TcxGridTableViewInfoCacheItem;
begin
  Result := TcxGridTableViewInfoCacheItem(inherited CacheItem);
end;

function TcxGridDataCellViewInfo.GetGridView: TcxGridTableView;
begin
  Result := TcxGridTableView(inherited GridView);
end;

function TcxGridDataCellViewInfo.GetGridViewInfo: TcxGridTableViewInfo;
begin
  Result := TcxGridTableViewInfo(inherited GridViewInfo);
end;

function TcxGridDataCellViewInfo.GetItem: TcxGridColumn;
begin
  Result := TcxGridColumn(inherited Item);
end;

function TcxGridDataCellViewInfo.GetMergedCell(Index: Integer): TcxGridDataCellViewInfo;
begin
  Result := TcxGridDataCellViewInfo(FMergedCells[Index]);
end;

function TcxGridDataCellViewInfo.GetMergedCellCount: Integer;
begin
  Result := FMergedCells.Count;
end;

function TcxGridDataCellViewInfo.GetMergedCellOfFocusedRow: TcxGridDataCellViewInfo;
var
  I: Integer;
begin
  for I := 0 to MergedCellCount - 1 do
  begin
    Result := MergedCells[I];
    if Result.RecordViewInfo.Focused then Exit;
  end;
  Result := nil;
end;

function TcxGridDataCellViewInfo.GetRecordViewInfo: TcxGridDataRowViewInfo;
begin
  Result := TcxGridDataRowViewInfo(inherited RecordViewInfo);
end;

procedure TcxGridDataCellViewInfo.AfterRowsViewInfoCalculate;
var
  AProperties: TcxCustomEditProperties;
  AValue: TcxEditValue;
  I: Integer;
  ARowViewInfo: TcxCustomGridRowViewInfo;
  ACellViewInfo: TcxGridDataCellViewInfo;

  procedure UpdateBounds;
  begin
    if FIsMerging then
    begin
      Bounds.Bottom := MergedCells[MergedCellCount - 1].Bounds.Bottom;
      Recalculate;
    end
    else
      if Height <> FOriginalHeight then
      begin
        Bounds.Bottom := Bounds.Top + FOriginalHeight;
        Recalculate;
      end;
  end;

begin
  if FIsMerged then
  begin
    UpdateBounds;
    Exit;
  end;
  if not CanCellMerging or GridViewInfo.IsInternalUse then Exit;
  AProperties := Properties;
  AValue := DisplayValue;
  for I := RecordViewInfo.Index + 1 to RecordViewInfo.RecordsViewInfo.Count - 1 do
  begin
    ARowViewInfo := RecordViewInfo.RecordsViewInfo[I];
    if ARowViewInfo is TcxGridDataRowViewInfo then
    begin
      ACellViewInfo := TcxGridDataRowViewInfo(ARowViewInfo).InternalCellViewInfos[Item.VisibleIndex];
      if Item.DoCompareValuesForCellMerging(
        RecordViewInfo.GridRecord, AProperties, AValue,
        TcxGridDataRowViewInfo(ARowViewInfo).GridRecord, ACellViewInfo.Properties, ACellViewInfo.DisplayValue) then
      begin
        if not FIsMerging then
        begin
          FIsMerging := True;
          FMergedCells := TList.Create;
        end;
        FMergedCells.Add(ACellViewInfo);
        ACellViewInfo.FIsMerged := True;
        ACellViewInfo.FMergingCell := Self;
        if not ACellViewInfo.CanBeMergingCell then Break;
      end
      else
        Break;
    end
    else
      Break;
  end;
  UpdateBounds;
end;

procedure TcxGridDataCellViewInfo.AfterRowsViewInfoOffset;
begin
  FIsMerging := False;
  FIsMerged := False;
  FreeAndNil(FMergedCells);
  FMergingCell := nil;
end;

function TcxGridDataCellViewInfo.CalculateSelected: Boolean;
var
  AMergedCellOfFocusedRow: TcxGridDataCellViewInfo;

  procedure CheckMergedCells;
  var
    I: Integer;
  begin
    if not Result and GridView.OptionsSelection.MultiSelect then
      for I := 0 to MergedCellCount - 1 do
      begin
        Result := MergedCells[I].Selected;
        if Result then Break;
      end;
  end;

begin
  Result := inherited CalculateSelected;
  if FIsMerging then
    if not GridView.OptionsSelection.MultiSelect or
      GridView.OptionsSelection.InvertSelect or Item.Focused then
      if not RecordViewInfo.Focused then
      begin
        AMergedCellOfFocusedRow := MergedCellOfFocusedRow;
        if AMergedCellOfFocusedRow <> nil then
          Result := AMergedCellOfFocusedRow.Selected
        else
          CheckMergedCells;
      end
      else
    else
      CheckMergedCells;
end;

function TcxGridDataCellViewInfo.CalculateWidth: Integer;
begin
  Result := RecordViewInfo.GetCellWidth(Self);
end;

function TcxGridDataCellViewInfo.CanBeMergingCell: Boolean;
begin
  Result := not RecordViewInfo.Expanded;
end;

function TcxGridDataCellViewInfo.CanCellMerging: Boolean;
begin
  Result := CanBeMergingCell and TcxGridColumnAccess(Item).CanCellMerging;
end;

function TcxGridDataCellViewInfo.DrawHotTrackedWhenRecordHotTracked: Boolean;
begin
  Result := inherited DrawHotTrackedWhenRecordHotTracked and not GridView.OptionsSelection.CellMultiSelect;
end;

function TcxGridDataCellViewInfo.CanDrawSelected: Boolean;
begin
  Result := inherited CanDrawSelected and ((RecordViewInfo.InplaceEditFormAreaViewInfo = nil) or
    GridView.OptionsSelection.InvertSelect);
end;

function TcxGridDataCellViewInfo.GetAlwaysSelected: Boolean;
begin
  Result := inherited GetAlwaysSelected or (RecordViewInfo.InplaceEditFormAreaViewInfo <> nil) and
    GridView.OptionsSelection.InvertSelect;
end;

function TcxGridDataCellViewInfo.GetBorderColor(AIndex: TcxBorder): TColor;
begin
  Result := GridViewInfo.GridLineColor;
end;

function TcxGridDataCellViewInfo.GetBorders: TcxBorders;
var
  AHeader: TcxGridHeaderViewInfoAccess;
  AColumnHeaderViewInfo: TcxGridColumnHeaderViewInfoAccess;
begin
  AHeader := TcxGridHeaderViewInfoAccess(GridViewInfo.HeaderViewInfo);
  Result := RecordViewInfo.GetCellBorders(Item.IsMostRight, Item.IsMostBottom and RecordViewInfo.CellsAreaViewInfo.IsBottom);
  if IsLast(fkLeft) and not AHeader.SeparatorBounds[fkLeft].IsEmpty or
    IsLast(fkLeftDynamic) and not AHeader.SeparatorBounds[fkLeftDynamic].IsEmpty or
    IsLast(fkNone) and (GridView.VisibleColumnCountByFixedKind[fkRight] > 0) then
      Result := Result - [bRight];
  if UseLightBorders then
  begin
    AColumnHeaderViewInfo := TcxGridColumnHeaderViewInfoAccess(AHeader.FindItem(Item));
    if Assigned(AColumnHeaderViewInfo) then
    begin
      if AColumnHeaderViewInfo.ExcludeRightBorder then
      begin
        if not IsRightToLeftConverted then
          Result := Result - [bRight]
        else
          Result := Result - [bLeft]
      end;
    end;
  end;
  if IsFirst(fkRight) and AHeader.SeparatorBounds[fkRight].IsEmpty and
    (TcxGridTableViewAccess(GridView).VisibleScrollableColumnCount > 0) then
      Result := Result + [bLeft];
end;

function TcxGridDataCellViewInfo.GetBorderWidth(AIndex: TcxBorder): Integer;
begin
  Result := GridViewInfo.GridLineWidth;
end;

function TcxGridDataCellViewInfo.GetEditViewDataBounds: TRect;
begin
  Result := inherited GetEditViewDataBounds;
  if HasCheckBox then
    Inc(Result.Left, CheckBoxArea.Width);
  if HasPin then
    Inc(Result.Left, Pin.Width);
  if Result.Right < Result.Left then
    Result.Right := Result.Left;
end;

function TcxGridDataCellViewInfo.GetFixedKind: TcxGridColumnFixedKind;
begin
  Result := TcxGridColumnHeaderViewInfoAccess(GridViewInfo.HeaderViewInfo[Item.VisibleIndex]).FixedKind;
end;

function TcxGridDataCellViewInfo.GetFocused: Boolean;
var
  AMergedCellOfFocusedRow: TcxGridDataCellViewInfo;
begin
  Result := inherited GetFocused;
  if FIsMerging and not RecordViewInfo.Focused then
  begin
    AMergedCellOfFocusedRow := MergedCellOfFocusedRow;
    if AMergedCellOfFocusedRow <> nil then
      Result := AMergedCellOfFocusedRow.Focused;
  end;
end;

function TcxGridDataCellViewInfo.GetMultiLine: Boolean;
begin
  Result := inherited GetMultiLine or RecordViewInfo.AutoHeight;
end;

function TcxGridDataCellViewInfo.GetPainterClass: TcxCustomGridCellPainterClass;
begin
  Result := TcxGridDataCellPainter;
end;

function TcxGridDataCellViewInfo.GetVisible: Boolean;
begin
  Result := not FIsMerged and inherited GetVisible;
end;

function TcxGridDataCellViewInfo.GetVisibleForHitTest: Boolean;
begin
  Result := inherited GetVisible;
end;

function TcxGridDataCellViewInfo.HasCheckBox: Boolean;
begin
  Result := CheckBoxArea <> nil;
end;

function TcxGridDataCellViewInfo.HasFocusRect: Boolean;
begin
  Result := inherited HasFocusRect or (TcxGridTableControllerAccess(Controller).IsMultiSelectPersistent and
    not RecordViewInfo.IsSpecial);
end;

function TcxGridDataCellViewInfo.HasHitTestPoint(const P: TPoint): Boolean;
begin
  if IsMerging then
    Result := PtInRect(OriginalBounds, P)
  else
    Result := inherited HasHitTestPoint(P);
end;

function TcxGridDataCellViewInfo.HasPin: Boolean;
begin
  Result := Pin <> nil;
end;

function TcxGridDataCellViewInfo.IsChildrenHotTracked: Boolean;
begin
  Result := inherited IsChildrenHotTracked or HasCheckBox and CheckBoxArea.IsHotTracked or
    HasPin and Pin.IsHotTracked;
end;

function TcxGridDataCellViewInfo.IsFirst(AFixedKind: TcxGridColumnFixedKind): Boolean;
var
  AColumnHeader: TcxGridColumnHeaderViewInfo;
begin
  AColumnHeader := TcxGridHeaderViewInfoAccess(GridViewInfo.HeaderViewInfo).FirstItem[AFixedKind];
  Result := (AColumnHeader <> nil) and (Item = AColumnHeader.Column);
end;

function TcxGridDataCellViewInfo.IsLast(AFixedKind: TcxGridColumnFixedKind): Boolean;
var
  AColumnHeader: TcxGridColumnHeaderViewInfo;
begin
  AColumnHeader := TcxGridHeaderViewInfoAccess(GridViewInfo.HeaderViewInfo).LastItem[AFixedKind];
  Result := (AColumnHeader <> nil) and (Item = AColumnHeader.Column);
end;

function TcxGridDataCellViewInfo.NeedFixedHighlight: Boolean;
begin
  Result := TcxGridColumnAccess(Item).NeedFixedHighlight and not Selected and not Editing;
end;

procedure TcxGridDataCellViewInfo.Offset(DX, DY: Integer);
begin
  inherited;
  OffsetRect(OriginalBounds, DX, DY);
  if HasCheckBox then
    CheckBoxArea.DoOffset(DX, DY);
  if HasPin then
    Pin.DoOffset(DX, DY);
end;

procedure TcxGridDataCellViewInfo.RemoveMergedCell(ACellViewInfo: TcxGridDataCellViewInfo);
begin
  FMergedCells.Remove(ACellViewInfo);
end;

procedure TcxGridDataCellViewInfo.ResetChildrenState;
begin
  inherited ResetChildrenState;
  if HasCheckBox then
    CheckBoxArea.ResetState;
  if HasPin then
    Pin.ResetState;
end;

function TcxGridDataCellViewInfo.ShowCheckBox: Boolean;
begin
  Result := RecordViewInfo.ShowCheckBox and (Item.VisibleIndex = 0);
end;

function TcxGridDataCellViewInfo.ShowPin: Boolean;
begin
  Result := RecordViewInfo.ShowPin and (Item.VisibleIndex = 0);
end;

function TcxGridDataCellViewInfo.SupportsEditing: Boolean;
begin
  Result := (GridView.OptionsBehavior.EditMode = emInplace) or GridRecord.IsNewItemRecord;
end;

procedure TcxGridDataCellViewInfo.AfterRecalculation;
begin
  if HasCheckBox then
    CheckBoxArea.AfterRecalculation;
  if HasPin then
    Pin.AfterRecalculation;
  inherited AfterRecalculation;
end;

procedure TcxGridDataCellViewInfo.BeforeRecalculation;
begin
  inherited BeforeRecalculation;
  if HasCheckBox then
    CheckBoxArea.BeforeRecalculation;
  if HasPin then
    Pin.BeforeRecalculation;
  RecordViewInfo.BeforeCellRecalculation(Self);
end;

procedure TcxGridDataCellViewInfo.Calculate(ALeftBound, ATopBound: Integer;
  AWidth: Integer = -1; AHeight: Integer = -1);
begin
  inherited Calculate(ALeftBound, ATopBound, AWidth, AHeight);
  if HasCheckBox then
  begin
    CheckBoxArea.Calculate(ALeftBound, ATopBound);
    ALeftBound := CheckBoxArea.Bounds.Right;
  end;
  if HasPin then
    Pin.Calculate(ALeftBound, ATopBound);
  if not FIsMerging then
  begin
    OriginalBounds := Bounds;
    FOriginalHeight := Height;
  end;
  if FIsMerged and (FMergingCell <> nil) then
    FMergingCell.Recalculate;
end;

procedure TcxGridDataCellViewInfo.DoRightToLeftConversion(const ABounds: TRect);
begin
  inherited DoRightToLeftConversion(ABounds);
  OriginalBounds := TdxRightToLeftLayoutConverter.ConvertRect(OriginalBounds, ABounds);
  if HasCheckBox then
    CheckBoxArea.RightToLeftConversion(ABounds);
  if HasPin then
    Pin.RightToLeftConversion(ABounds);
  if FIsMerged and (FMergingCell <> nil) then
    FMergingCell.RightToLeftConversion(ABounds);
end;

function TcxGridDataCellViewInfo.GetHitTest(const P: TPoint): TcxCustomGridHitTest;
var
  AHitTest: TcxCustomGridHitTest;
begin
  Result := inherited GetHitTest(P);
  if (Result = nil) or (Result.ClassType <> GetHitTestClass) then
    Exit;
  if HasCheckBox then
  begin
    AHitTest := CheckBoxArea.GetHitTest(P);
    if AHitTest <> nil then
      Result := AHitTest;
  end;
  if HasPin then
  begin
    AHitTest := Pin.GetHitTest(P);
    if AHitTest <> nil then
      Result := AHitTest;
  end;
end;

function TcxGridDataCellViewInfo.MouseMove(AHitTest: TcxCustomGridHitTest;
  AShift: TShiftState): Boolean;
begin
  if IsMerged then
    Result := MergingCell.MouseMove(AHitTest, AShift)
  else
    Result := inherited MouseMove(AHitTest, AShift);
end;

procedure TcxGridDataCellViewInfo.Paint(ACanvas: TcxCanvas = nil);
begin
  inherited Paint(ACanvas);
  if FIsMerged and RecordViewInfo.CellsAreaViewInfo.DrawMergedCell(Self) then
    FMergingCell.Paint(ACanvas);
end;

{ TcxGridFilterRowOperatorViewInfo }

constructor TcxGridFilterRowOperatorViewInfo.Create(ACellViewInfo: TcxGridFilterRowCellViewInfo);
begin
  inherited Create(ACellViewInfo.GridViewInfo);
  FCellViewInfo := ACellViewInfo;
end;

function TcxGridFilterRowOperatorViewInfo.MouseDown(AHitTest: TcxCustomGridHitTest;
  AButton: TMouseButton; AShift: TShiftState): Boolean;
begin
  Result := inherited MouseDown(AHitTest, AButton, AShift);
  GridView.Controller.FocusedRow := CellViewInfo.GridRecord;
  CellViewInfo.Item.Focused := True;
  if (ssLeft in AShift) and (State = gcsPressed) then
    CellViewInfo.ShowOperatorCustomizationMenu;
end;

function TcxGridFilterRowOperatorViewInfo.CalculateHeight: Integer;
begin
  Result := CellViewInfo.Height;
end;

function TcxGridFilterRowOperatorViewInfo.CalculateWidth: Integer;
begin
  Result := Min(ImageSize.cx + 2 * ScaleFactor.Apply(cxFilterRowOperatorButtonImageIndent), CellViewInfo.Width);
end;

function TcxGridFilterRowOperatorViewInfo.GetHeight: Integer;
begin
  Result := CalculateHeight;
end;

function TcxGridFilterRowOperatorViewInfo.GetHitTestClass: TcxCustomGridHitTestClass;
begin
  Result := TcxGridFilterRowOperatorHitTest;
end;

function TcxGridFilterRowOperatorViewInfo.GetIsCheck: Boolean;
begin
  Result := True;
end;

function TcxGridFilterRowOperatorViewInfo.GetPainterClass: TcxCustomGridCellPainterClass;
begin
  Result := TcxGridFilterRowOperatorPainter;
end;

procedure TcxGridFilterRowOperatorViewInfo.GetViewParams(var AParams: TcxViewParams);
begin
  CellViewInfo.GetViewParams(AParams);
end;

function TcxGridFilterRowOperatorViewInfo.GetWidth: Integer;
begin
  Result := CalculateWidth;
end;

function TcxGridFilterRowOperatorViewInfo.GetButtonBounds: TRect;
begin
  Result := cxRectInflate(Bounds, -1);
end;

function TcxGridFilterRowOperatorViewInfo.GetGridView: TcxGridTableView;
begin
  Result := TcxGridTableView(inherited GridView);
end;

function TcxGridFilterRowOperatorViewInfo.GetImageBounds: TRect;
begin
  Result := cxRectCenter(ButtonBounds, ImageSize.cx, ImageSize.cy);
end;

function TcxGridFilterRowOperatorViewInfo.GetImageSize: TSize;
begin
  Result := TcxFilterControlImagesHelper.GetScaledSize(ScaleFactor);
end;

function TcxGridFilterRowOperatorViewInfo.GetOperator: TcxFilterControlOperator;
begin
  Result := CellViewInfo.FilterOperator;
end;

{ TcxGridFilterRowCellViewInfo }

constructor TcxGridFilterRowCellViewInfo.Create(ARecordViewInfo: TcxCustomGridRecordViewInfo; AItem: TcxCustomGridTableItem);
begin
  inherited Create(ARecordViewInfo, AItem);
  if OperatorCustomization then
    FOperatorViewInfo := GetOperatorViewInfoClass.Create(Self);
end;

destructor TcxGridFilterRowCellViewInfo.Destroy;
begin
  FreeAndNil(FOperatorViewInfo);
  inherited Destroy;
end;

procedure TcxGridFilterRowCellViewInfo.AfterRecalculation;
begin
  if HasOperatorViewInfo then
    OperatorViewInfo.AfterRecalculation;
  inherited AfterRecalculation;
end;

procedure TcxGridFilterRowCellViewInfo.BeforeRecalculation;
begin
  inherited BeforeRecalculation;
  if HasOperatorViewInfo then
    OperatorViewInfo.BeforeRecalculation;
end;

procedure TcxGridFilterRowCellViewInfo.Calculate(ALeftBound, ATopBound, AWidth,
  AHeight: Integer);
begin
  inherited Calculate(ALeftBound, ATopBound, AWidth, AHeight);
  if HasOperatorViewInfo then
    OperatorViewInfo.Calculate(ALeftBound, ATopBound);
end;

procedure TcxGridFilterRowCellViewInfo.DoRightToLeftConversion(const ABounds: TRect);
begin
  inherited DoRightToLeftConversion(ABounds);
  if HasOperatorViewInfo then
    OperatorViewInfo.RightToLeftConversion(ABounds);
end;

function TcxGridFilterRowCellViewInfo.GetHitTest(const P: TPoint): TcxCustomGridHitTest;
var
  AHitTest: TcxCustomGridHitTest;
begin
  Result := inherited GetHitTest(P);
  if (Result <> nil) and (Result.ClassType = GetHitTestClass) then
    if HasOperatorViewInfo then
    begin
      AHitTest := OperatorViewInfo.GetHitTest(P);
      if AHitTest <> nil then
      begin
        Result := AHitTest;
        Exit;
      end;
    end;
end;

function TcxGridFilterRowCellViewInfo.GetOperatorViewInfoClass: TcxGridFilterRowOperatorViewInfoClass;
begin
  Result := TcxGridFilterRowOperatorViewInfo;
end;

function TcxGridFilterRowCellViewInfo.HasOperatorViewInfo: Boolean;
begin
  Result := OperatorViewInfo <> nil;
end;

function TcxGridFilterRowCellViewInfo.GetEditViewDataBounds: TRect;
begin
  Result := inherited GetEditViewDataBounds;
  if HasOperatorViewInfo then
  begin
    Inc(Result.Left, OperatorViewInfo.Width);
    if Result.Right < Result.Left then
      Result.Right := Result.Left;
  end;
end;

function TcxGridFilterRowCellViewInfo.GetPainterClass: TcxCustomGridCellPainterClass;
begin
  Result := TcxGridFilterRowCellPainter;
end;

procedure TcxGridFilterRowCellViewInfo.Offset(DX, DY: Integer);
begin
  inherited Offset(DX, DY);
  if HasOperatorViewInfo then
    OperatorViewInfo.Offset(DX, DY);
end;

function TcxGridFilterRowCellViewInfo.OperatorCustomization: Boolean;
begin
  Result := RecordViewInfo.OperatorCustomization and TcxCustomGridTableItemAccess.CanFilter(Item, False);
end;

function TcxGridFilterRowCellViewInfo.OperatorCustomizationMenuForBounds: TRect;
begin
  Result := cxRectOffset(Bounds, -1, -1);
end;

procedure TcxGridFilterRowCellViewInfo.ShowOperatorCustomizationMenu;
var
  ADropDownMenu: TcxFilterDropDownMenu;
begin
  ADropDownMenu := TcxGridTableControllerAccess(Controller).FilterRowOperatorMenu;
  ADropDownMenu.OnSelect := OperatorMenuSelectHandler;
  ADropDownMenu.OnClosed := OperatorMenuHideHandler;
  ADropDownMenu.CreateConditionList(SupportedOperators);
  ADropDownMenu.BiDiMode := Control.BiDiMode;
  if UseRightToLeftAlignment then
    ADropDownMenu.AlignHorz := pahRight
  else
    ADropDownMenu.AlignHorz := pahLeft;
  ADropDownMenu.Popup(OperatorCustomizationMenuForBounds);
end;

function TcxGridFilterRowCellViewInfo.GetController: TcxGridTableController;
begin
  Result := TcxGridTableController(inherited Controller);
end;

function TcxGridFilterRowCellViewInfo.GetGridRecord: TcxGridFilterRow;
begin
  Result := TcxGridFilterRow(inherited GridRecord);
end;

function TcxGridFilterRowCellViewInfo.GetOperator: TcxFilterControlOperator;
var
  AFilterOperatorKind: TcxFilterOperatorKind;
begin
  AFilterOperatorKind := GridRecord.Operators[Item.Index];
  Result := GetFilterControlOperator(AFilterOperatorKind, False);
end;

function TcxGridFilterRowCellViewInfo.GetRecordViewInfo: TcxGridFilterRowViewInfo;
begin
  Result := TcxGridFilterRowViewInfo(inherited RecordViewInfo);
end;

function TcxGridFilterRowCellViewInfo.GetSupportedOperators: TcxFilterControlOperators;
var
  AFilterControlOperator: TcxFilterControlOperator;
  AOperator: TcxFilterOperatorKind;
begin
  Result := [];
  for AOperator := Low(TcxFilterOperatorKind) to High(TcxFilterOperatorKind) do
    if Controller.IsFilterRowOperatorSupported(Item.Index, AOperator) then
    begin
      AFilterControlOperator := GetFilterControlOperator(AOperator, False);
      Result := Result + [AFilterControlOperator];
    end;
end;

procedure TcxGridFilterRowCellViewInfo.SetOperator(AValue: TcxFilterControlOperator);
begin
  GridRecord.Operators[Item.Index] := GetFilterOperatorKind(AValue);
end;

procedure TcxGridFilterRowCellViewInfo.OperatorMenuHideHandler(Sender: TObject);
begin
  OperatorViewInfo.State := gcsNone;
end;

procedure TcxGridFilterRowCellViewInfo.OperatorMenuSelectHandler(Sender: TObject;
  AItem: TdxCustomListBoxItem; ASelectedViaKeyboard: Boolean);
begin
  TcxFilterDropDownMenu(Sender).OnClosed := nil;
  FilterOperator := TcxFilterControlOperator(AItem.Data);
end;

{ TcxGridDataRowCellsAreaViewInfo }

constructor TcxGridDataRowCellsAreaViewInfo.Create(ARecordViewInfo: TcxCustomGridRecordViewInfo);
begin
  inherited;
  Visible := CalculateVisible;
end;

function TcxGridDataRowCellsAreaViewInfo.GetRecordViewInfo: TcxGridDataRowViewInfo;
begin
  Result := TcxGridDataRowViewInfo(inherited RecordViewInfo);
end;

function TcxGridDataRowCellsAreaViewInfo.CalculateHeight: Integer;
begin
  Result := 0;
end;

function TcxGridDataRowCellsAreaViewInfo.CalculateVisible: Boolean;
begin
  Result := RecordViewInfo.GridViewInfo.HeaderViewInfo.Count = 0;
end;

function TcxGridDataRowCellsAreaViewInfo.CalculateWidth: Integer;
begin
  Result := 0;
end;

function TcxGridDataRowCellsAreaViewInfo.DrawMergedCell(ACell: TcxGridDataCellViewInfo): Boolean;
begin
  Result := (ACell.FixedKind <> fkNone) or RecordViewInfo.Transparent;
end;

function TcxGridDataRowCellsAreaViewInfo.GetBorders: TcxBorders;
begin
  Result := GridViewInfo.GetCellBorders(True, IsBottom);
end;

function TcxGridDataRowCellsAreaViewInfo.GetIsBottom: Boolean;
begin
  Result :=
    not RecordViewInfo.HasPreview or (GridView.Preview.Place = ppTop) or
    (RecordViewInfo.PreviewViewInfo.Height = 0);
end;

function TcxGridDataRowCellsAreaViewInfo.CanDrawSelected: Boolean;
begin
  Result := True;
end;

{ TcxGridPreviewCellViewInfo }

function TcxGridPreviewCellViewInfo.GetPreview: TcxGridPreview;
begin
  Result := GridView.Preview;
end;

function TcxGridPreviewCellViewInfo.CalculateHeight: Integer;

  function GetMaxValue: Integer;
  begin
    if Preview.MaxLineCount = 0 then
      Result := 0
    else
    begin
      Result := Preview.MaxLineCount * GridViewInfo.GetFontHeight(Params.Font);
      GetCellTextAreaSize(Result, ScaleFactor, False);
    end;
  end;

begin
  if CacheItem.IsPreviewHeightAssigned then
    Result := Height
  else
  begin
    if AutoHeight then
    begin
      Result := inherited CalculateHeight;
      if Result - ClientExtent.Top - ClientExtent.Bottom = 0 then
        Result := 0;
    end
    else
    begin
      CalculateParams;
      Result := GetMaxValue;
    end;
    if Result <> 0 then
      Result := RecordViewInfo.RecordsViewInfo.GetCellHeight(Result);
  end;
end;

function TcxGridPreviewCellViewInfo.CalculateWidth: Integer;
begin
  Result := RecordViewInfo.DataWidth;
end;

function TcxGridPreviewCellViewInfo.GetAutoHeight: Boolean;
begin
  Result := Preview.AutoHeight;
end;

function TcxGridPreviewCellViewInfo.GetBackgroundBitmap: TBitmap;
begin
  Result := GridView.BackgroundBitmaps.GetBitmap(bbPreview);
end;

function TcxGridPreviewCellViewInfo.GetBorders: TcxBorders;
begin
  Result := GridViewInfo.GetCellBorders(True,
    (Preview.Place = ppBottom) or (RecordViewInfo.CellViewInfoCount = 0));
end;

procedure TcxGridPreviewCellViewInfo.GetEditViewDataContentOffsets(var R: TRect);
begin
  inherited;
  R.Left := Preview.LeftIndent - (ScaleFactor.Apply(cxGridCellTextOffset) - cxGridEditOffset);
  R.Right := Preview.RightIndent - (ScaleFactor.Apply(cxGridCellTextOffset) - cxGridEditOffset);
end;

function TcxGridPreviewCellViewInfo.GetFixedKind: TcxGridColumnFixedKind;
begin
  Result := fkNone;
end;

function TcxGridPreviewCellViewInfo.GetHeight: Integer;
begin
  if CacheItem.IsPreviewHeightAssigned then
    Result := CacheItem.PreviewHeight
  else
  begin
    Result := CalculateHeight;
    CacheItem.PreviewHeight := Result;
  end;
end;

function TcxGridPreviewCellViewInfo.GetHitTestClass: TcxCustomGridHitTestClass;
begin
  Result := TcxGridPreviewHitTest;
end;

function TcxGridPreviewCellViewInfo.GetIsMain: Boolean;
begin
  Result := False;
end;

function TcxGridPreviewCellViewInfo.GetMaxLineCount: Integer;
begin
  Result := Preview.MaxLineCount;
end;

function TcxGridPreviewCellViewInfo.GetMultiLine: Boolean;
begin
  Result := True;
end;

function TcxGridPreviewCellViewInfo.GetTextAreaBounds: TRect;
begin
  Result := inherited GetTextAreaBounds;
  InflateRect(Result, ScaleFactor.Apply(cxGridCellTextOffset), 0);
  Inc(Result.Left, Preview.LeftIndent);
  Dec(Result.Right, Preview.RightIndent);
end;

function TcxGridPreviewCellViewInfo.NeedFixedHighlight: Boolean;
begin
  Result := False;
end;

function TcxGridPreviewCellViewInfo.SupportsZeroHeight: Boolean;
begin
  Result := True;
end;

{ TcxGridRowLayoutViewInfo }

constructor TcxGridRowLayoutViewInfo.Create(ARecordViewInfo: TcxGridDataRowViewInfo);
begin
  FRecordViewInfo := ARecordViewInfo;
  inherited Create(RecordViewInfo.GridViewInfo);
  FItemViewInfos := CreateItemViewInfos;
  PopulateItemViewInfos;
  FContainerViewInfo := CreateContainerViewInfo;
end;

destructor TcxGridRowLayoutViewInfo.Destroy;
begin
  FreeAndNil(FContainerViewInfo);
  FreeAndNil(FItemViewInfos);
  inherited Destroy;
end;

procedure TcxGridRowLayoutViewInfo.BeforeRecalculation;
var
  I: Integer;
begin
  inherited BeforeRecalculation;
  for I := 0 to ItemViewInfos.Count - 1 do
    ItemViewInfos[I].BeforeRecalculation;
end;

procedure TcxGridRowLayoutViewInfo.Calculate(ALeftBound, ATopBound: Integer; AWidth: Integer = -1; AHeight: Integer = -1);
var
  AContainerLeftPos: Integer;
begin
  inherited Calculate(ALeftBound, ATopBound, AWidth, AHeight);
  RowLayoutController.CalculateContainer(ContainerViewInfo, Bounds.Width, Bounds.Height);
  if GridViewInfo.IsRightToLeftConverted then
    AContainerLeftPos := GridViewInfo.Bounds.Right - Bounds.Right
  else
    AContainerLeftPos := Bounds.Left - GridViewInfo.Bounds.Left;
  ContainerViewInfo.Offset := Point(AContainerLeftPos, Bounds.Top);
end;

function TcxGridRowLayoutViewInfo.FindCellViewInfo(AItem: TcxCustomGridColumn): TcxGridViewLayoutItemDataCellViewInfo;
begin
  Result := ItemViewInfos.FindCellViewInfo(AItem);
end;

function TcxGridRowLayoutViewInfo.FindLayoutItemViewInfo(AItem: TcxCustomGridColumn): TcxGridRowLayoutItemViewInfo;
begin
  Result := TcxGridRowLayoutItemViewInfo(ContainerViewInfo.ItemsViewInfo.FindItemViewInfo(AItem.RowLayoutItem));
end;

function TcxGridRowLayoutViewInfo.GetHitTest(const P: TPoint): TcxCustomGridHitTest;
begin
  if PtInItems(P) then
    Result := ItemViewInfos.GetHitTest(P)
  else
    Result := inherited GetHitTest(P);
end;

function TcxGridRowLayoutViewInfo.MouseDown(AHitTest: TcxCustomGridHitTest;
  AButton: TMouseButton; AShift: TShiftState): Boolean;
begin
  Result := inherited MouseDown(AHitTest, AButton, AShift);
  if AButton <> mbMiddle then
    GridView.Controller.FocusedRecord := RecordViewInfo.GridRecord;
end;

procedure TcxGridRowLayoutViewInfo.AfterCustomDraw(ACanvas: TcxCanvas);
begin
//do nothing
end;

procedure TcxGridRowLayoutViewInfo.BeforeCustomDraw(ACanvas: TcxCanvas);
begin
//do nothing
end;

function TcxGridRowLayoutViewInfo.CalculateHeight: Integer;
begin
  if RecordViewInfo.AutoHeight and not FIsAutoHeightCalculating then
  begin
    FIsAutoHeightCalculating := True;
    try
      Result := RowLayoutController.CalculateContainerAutoHeight(ContainerViewInfo, Width);
    finally
      FIsAutoHeightCalculating := False;
    end;
  end
  else
    Result := RecordViewInfo.RecordsViewInfo.DataRowHeight;
end;

function TcxGridRowLayoutViewInfo.CalculateWidth: Integer;
begin
  if RecordViewInfo.Calculated then
    Result := RecordViewInfo.ContentBounds.Width 
  else
    Result := RecordViewInfo.Width - GridViewInfo.VisualLevelCount * GridViewInfo.LevelIndent; 
end;

function TcxGridRowLayoutViewInfo.CreateContainerViewInfo: TcxGridTableRowLayoutContainerViewInfo;
begin
  Result := TcxGridTableRowLayoutContainerViewInfo.Create(RowLayoutController.Container, RecordViewInfo);
end;

function TcxGridRowLayoutViewInfo.CreateItemViewInfo(ARecordViewInfo: TcxCustomGridRecordViewInfo;
  AItem: TcxCustomGridTableItem): TcxGridTableRowLayoutDataCellViewInfo;
begin
  Result := TcxGridTableRowLayoutDataCellViewInfo.Create(ARecordViewInfo, AItem);
end;

function TcxGridRowLayoutViewInfo.CreateItemViewInfos: TcxGridRowLayoutGridItemViewInfos;
begin
  Result := TcxGridRowLayoutGridItemViewInfos.Create;
end;

function TcxGridRowLayoutViewInfo.CustomDrawBackground(ACanvas: TcxCanvas): Boolean;
begin
  Result := inherited CustomDrawBackground(ACanvas);
  if Result then Exit;
  if ButtonState = cxbsPressed then
    TcxGridTableViewAccess(GridView).DoCustomDrawRowLayoutRowSelection(ACanvas, Self, Result);
  if Result then Exit;
  if ButtonState = cxbsHot then
    TcxGridTableViewAccess(GridView).DoCustomDrawRowLayoutRowHotTrack(ACanvas, Self, Result);
end;

function TcxGridRowLayoutViewInfo.GetActualState: TcxGridCellState;
begin
  if HasSelectionBackground then
    Result := gcsPressed
  else
    if HasHotTrackBackground then
      Result := gcsSelected
    else
      Result := gcsNone;
end;

function TcxGridRowLayoutViewInfo.GetBorderColor(AIndex: TcxBorder): TColor;
begin
  Result := GridViewInfo.GridLineColor;
end;

function TcxGridRowLayoutViewInfo.GetBorders: TcxBorders;
begin
  Result := RecordViewInfo.GetCellBorders(True, True);
end;

function TcxGridRowLayoutViewInfo.GetBorderWidth(AIndex: TcxBorder): Integer;
begin
  Result := GridViewInfo.GridLineWidth;
end;

function TcxGridRowLayoutViewInfo.GetButtonState: TcxButtonState;
begin
  Result := inherited GetButtonState;
  if (Result = cxbsPressed) and not GridView.IsControlFocused then
    Result := cxbsDisabled;
end;

function TcxGridRowLayoutViewInfo.GetHeight: Integer;
begin
  Result := CalculateHeight;
end;

function TcxGridRowLayoutViewInfo.GetHitTestClass: TcxCustomGridHitTestClass;
begin
  Result := nil;
end;

function TcxGridRowLayoutViewInfo.GetPainterClass: TcxCustomGridCellPainterClass;
begin
  Result := TcxGridRowLayoutPainter;
end;

function TcxGridRowLayoutViewInfo.GetWidth: Integer;
begin
  Result := CalculateWidth;
end;

function TcxGridRowLayoutViewInfo.HasBackground: Boolean;
begin
  Result := HasSelectionBackground or HasHotTrackBackground;
end;

function TcxGridRowLayoutViewInfo.HasCustomDrawBackground: Boolean;
begin
  Result := inherited HasCustomDrawBackground or
    TcxGridTableViewAccess(GridView).HasCustomDrawRowLayoutRowHotTrack or
    TcxGridTableViewAccess(GridView).HasCustomDrawRowLayoutRowSelection;
end;

function TcxGridRowLayoutViewInfo.HasHotTrackBackground: Boolean;
begin
  Result := RecordViewInfo.HotTracked and (GridView.OptionsSelection.InvertSelect or
    not GridView.OptionsSelection.CellSelect or GridView.OptionsSelection.MultiSelect);
end;

function TcxGridRowLayoutViewInfo.HasSelectionBackground: Boolean;
begin
  Result := RecordViewInfo.Selected and (GridView.OptionsSelection.InvertSelect or
    not GridView.OptionsSelection.CellSelect or GridView.OptionsSelection.MultiSelect);
end;

function TcxGridRowLayoutViewInfo.IsChildrenHotTracked: Boolean;
begin
  Result := inherited IsChildrenHotTracked or ItemViewInfos.IsHotTracked;
end;

procedure TcxGridRowLayoutViewInfo.Offset(DX: Integer; DY: Integer);
begin
  inherited Offset(DX, DY);
  ContainerViewInfo.Offset := cxPointOffset(ContainerViewInfo.Offset, IfThen(UseRightToLeftAlignment, -DX, DX), DY);
end;

procedure TcxGridRowLayoutViewInfo.PopulateItemViewInfos;
var
  I: Integer;
  AGridViewItem: TcxCustomGridTableItem;
  AGridItemViewInfo: TcxGridTableDataCellViewInfo;
begin
  for I := 0 to RowLayoutController.Container.AbsoluteItemCount - 1 do
  begin
    if not (RowLayoutController.Container.AbsoluteItems[I] is TcxGridTableRowLayoutItem) or
      (RowLayoutController.Container.AbsoluteItems[I].Parent = nil) then
      Continue;
    AGridViewItem := TcxGridTableRowLayoutItem(RowLayoutController.Container.AbsoluteItems[I]).GridViewItem;
    AGridItemViewInfo := CreateItemViewInfo(RecordViewInfo, AGridViewItem);
    ItemViewInfos.Add(AGridItemViewInfo);
  end;
end;

function TcxGridRowLayoutViewInfo.PtInItems(const APoint: TPoint): Boolean;
begin
  Result := PtInRect(Bounds, APoint) and PtInRect(ContainerViewInfo.ContentBounds, APoint);
end;

procedure TcxGridRowLayoutViewInfo.ResetChildrenState;
begin
  inherited ResetChildrenState;
  ItemViewInfos.ResetStates;
end;

function TcxGridRowLayoutViewInfo.GetGridView: TcxGridTableView;
begin
  Result := TcxGridTableView(inherited GridView);
end;

function TcxGridRowLayoutViewInfo.GetGridViewInfo: TcxGridTableViewInfo;
begin
  Result := TcxGridTableViewInfo(inherited GridViewInfo);
end;

function TcxGridRowLayoutViewInfo.GetRowLayoutController: TcxGridTableRowLayoutController;
begin
  Result := RecordViewInfo.RowLayoutController;
end;

{ TcxGridInplaceEditFormAreaScrollBarViewInfo }

constructor TcxGridInplaceEditFormAreaScrollBarViewInfo.Create(
  AViewInfo: TcxGridInplaceEditFormAreaViewInfo);
begin
  inherited Create(AViewInfo.GridViewInfo);
  FViewInfo := AViewInfo;
  Visible := False;
  CreateScrollBar;
end;

destructor TcxGridInplaceEditFormAreaScrollBarViewInfo.Destroy;
begin
  DestroyScrollBar;
  inherited Destroy;
end;

procedure TcxGridInplaceEditFormAreaScrollBarViewInfo.Calculate(ALeftBound, ATopBound: Integer;
  AWidth: Integer = -1; AHeight: Integer = -1);
begin
  inherited Calculate(ALeftBound, ATopBound, AWidth, AHeight);
  FScrollBar.BoundsRect := Bounds;
  ScrollBar.LargeChange := cxGridInplaceEditFormScrollBarLargeChange;
  ScrollBar.SmallChange := cxGridInplaceEditFormScrollBarSmallChange;
end;

procedure TcxGridInplaceEditFormAreaScrollBarViewInfo.SetScrollParams(
  AMin, AMax, APosition, APageSize: Integer; ARedraw: Boolean = True);
begin
  ScrollBar.SetScrollParams(AMin, AMax, APosition, APageSize, ARedraw);
end;

function TcxGridInplaceEditFormAreaScrollBarViewInfo.CalculateHeight: Integer;
begin
  Result := ScrollBar.Height;
end;

function TcxGridInplaceEditFormAreaScrollBarViewInfo.CalculateWidth: Integer;
begin
  Result := ScrollBar.Width;
end;

function TcxGridInplaceEditFormAreaScrollBarViewInfo.GetHeight: Integer;
begin
  Result := CalculateHeight;
end;

function TcxGridInplaceEditFormAreaScrollBarViewInfo.GetWidth: Integer;
begin
  Result := CalculateWidth;
end;

procedure TcxGridInplaceEditFormAreaScrollBarViewInfo.SetHeight(Value: Integer);
begin
  inherited SetHeight(Value);
  ScrollBar.Height := Value;
end;

procedure TcxGridInplaceEditFormAreaScrollBarViewInfo.SetWidth(Value: Integer);
begin
  inherited SetWidth(Value);
  ScrollBar.Width := Value;
end;

function TcxGridInplaceEditFormAreaScrollBarViewInfo.CaptureMouseOnPress: Boolean;
begin
  Result := True;
end;

function TcxGridInplaceEditFormAreaScrollBarViewInfo.GetHotTrack: Boolean;
begin
  Result := True;
end;

procedure TcxGridInplaceEditFormAreaScrollBarViewInfo.CreateScrollBar;
begin
  FScrollBar := TdxScrollBarWrapper.Create(InplaceEditFormAreaViewInfo);
  FScrollBar.OnScroll := DoScroll;
  FScrollBar.UnlimitedTracking := True;
  FScrollBar.InitControl;
end;

procedure TcxGridInplaceEditFormAreaScrollBarViewInfo.DestroyScrollBar;
begin
  FreeAndNil(FScrollBar);
end;

procedure TcxGridInplaceEditFormAreaScrollBarViewInfo.DoRightToLeftConversion(const ABounds: TRect);
begin
  inherited DoRightToLeftConversion(ABounds);
  FScrollBar.BoundsRect := Bounds;
end;

procedure TcxGridInplaceEditFormAreaScrollBarViewInfo.DoScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  if (ScrollPos + PageSize) > Max then
    ScrollPos := Max - PageSize;
  FViewInfo.UpdateOnScroll;
end;

function TcxGridInplaceEditFormAreaScrollBarViewInfo.GetKind: TScrollBarKind;
begin
  Result := ScrollBar.Kind;
end;

function TcxGridInplaceEditFormAreaScrollBarViewInfo.GetMax: Integer;
begin
  Result := ScrollBar.Max;
end;

function TcxGridInplaceEditFormAreaScrollBarViewInfo.GetMin: Integer;
begin
  Result := ScrollBar.Min;
end;

function TcxGridInplaceEditFormAreaScrollBarViewInfo.GetPageSize: Integer;
begin
  Result := ScrollBar.PageSize;
end;

function TcxGridInplaceEditFormAreaScrollBarViewInfo.GetPosition: Integer;
begin
  Result := ScrollBar.Position;
end;

procedure TcxGridInplaceEditFormAreaScrollBarViewInfo.SetKind(Value: TScrollBarKind);
var
  ASize: TSize;
begin
  if Kind <> Value then
  begin
    ASize := cxSize(ScrollBar.Width, ScrollBar.Height);
    ScrollBar.Kind := Value;
    ScrollBar.Width := ASize.cy;
    ScrollBar.Height := ASize.cx;
  end;
end;

procedure TcxGridInplaceEditFormAreaScrollBarViewInfo.SetMax(Value: Integer);
begin
  ScrollBar.Max := Value;
end;

procedure TcxGridInplaceEditFormAreaScrollBarViewInfo.SetMin(Value: Integer);
begin
  ScrollBar.Min := Value;
end;

procedure TcxGridInplaceEditFormAreaScrollBarViewInfo.SetPageSize(Value: Integer);
begin
  ScrollBar.PageSize := Value;
end;

procedure TcxGridInplaceEditFormAreaScrollBarViewInfo.SetPosition(Value: Integer);
begin
  ScrollBar.Position := Value;
end;

function TcxGridInplaceEditFormAreaScrollBarViewInfo.GetScrollBarOwner: TWinControl;
begin
  Result := Control;
end;

function TcxGridInplaceEditFormAreaScrollBarViewInfo.GetLookAndFeel: TcxLookAndFeel;
begin
  Result := GridView.LookAndFeel;
end;

{ TcxGridInplaceEditFormAreaScrollBars }

constructor TcxGridInplaceEditFormAreaScrollBars.Create(AInplaceEditFormAreaViewInfo: TcxGridInplaceEditFormAreaViewInfo);
begin
  inherited Create;
  FViewInfo := AInplaceEditFormAreaViewInfo;
  CreateScrollBars;
end;

destructor TcxGridInplaceEditFormAreaScrollBars.Destroy;
begin
  DestroyScrollBars;
  inherited Destroy;
end;

procedure TcxGridInplaceEditFormAreaScrollBars.Calculate;
begin
  CalculateHorizontalScrollBar;
  CalculateVerticalScrollBar;
end;

function TcxGridInplaceEditFormAreaScrollBars.GetContainerOffset: TPoint;
begin
  Result := Point(0, 0);
  Result.X := GetContainerOffsetFromScrollPosition(HorizontalScrollBar, sbHorizontal);
  Result.Y := GetContainerOffsetFromScrollPosition(VerticalScrollBar, sbVertical);
end;

function TcxGridInplaceEditFormAreaScrollBars.GetHitTest(const P: TPoint): TcxCustomGridHitTest;
begin
  Result := nil;
end;

procedure TcxGridInplaceEditFormAreaScrollBars.CalculateHorizontalScrollBar;
var
  ABounds: TRect;
  ATop: Integer;
begin
  if HorizontalScrollBar.Visible then
  begin
    ABounds := ViewInfo.Bounds;
    ATop := ABounds.Top + ViewInfo.DataHeight;
    if TcxControlAccess(ViewInfo.Control).IsPopupScrollBars then
      ATop := ATop - HorizontalScrollBar.Height;
    CalculateScrollBarViewInfo(HorizontalScrollBar, ViewInfo.Width, ABounds.Left, ATop);
  end;
  HorizontalScrollBar.ScrollBar.Visible := HorizontalScrollBar.Visible;
end;

procedure TcxGridInplaceEditFormAreaScrollBars.CalculateScrollBarViewInfo(
  AScrollBarViewInfo: TcxGridInplaceEditFormAreaScrollBarViewInfo; ASize, ALeft, ATop: Integer);
var
  APageSize, APosition: Integer;
begin
  if AScrollBarViewInfo.Kind = sbHorizontal then
  begin
    AScrollBarViewInfo.Width := ASize;
    APageSize := Round(ASize * ViewInfo.DataWidth / ContainerViewInfo.ContentWidth);
  end
  else
  begin
    AScrollBarViewInfo.Height := ASize;
    APageSize := Round(ASize * ViewInfo.DataHeight / ContainerViewInfo.ContentHeight);
  end;
  APosition := AScrollBarViewInfo.Position;
  AScrollBarViewInfo.SetScrollParams(0, ASize, APosition, APageSize, False);
  AScrollBarViewInfo.Calculate(ALeft, ATop);
end;

procedure TcxGridInplaceEditFormAreaScrollBars.CalculateVerticalScrollBar;
var
  ABounds: TRect;
  ALeft, ATop: Integer;
begin
  if VerticalScrollBar.Visible then
  begin
    ABounds := ViewInfo.Bounds;
    if ViewInfo.Control.UseRightToLeftScrollBar and not ViewInfo.Control.UseRightToLeftAlignment then
      ALeft := ABounds.Left
    else
      ALeft := ABounds.Right - VerticalScrollBar.Width;
    ATop := ABounds.Top;
    CalculateScrollBarViewInfo(VerticalScrollBar, ViewInfo.DataHeight, ALeft, ATop);
  end;
  VerticalScrollBar.ScrollBar.Visible := VerticalScrollBar.Visible;
end;

procedure TcxGridInplaceEditFormAreaScrollBars.CheckHorizontalScrollPosition;
begin
  if HorizontalScrollBar.Visible then
    HorizontalScrollBar.Position := Round((ViewInfo.Bounds.Left - ContainerViewInfo.Offset.X) *
      (HorizontalScrollBar.Max - HorizontalScrollBar.Min - HorizontalScrollBar.PageSize)/
      (ContainerViewInfo.ContentWidth - ViewInfo.DataWidth))
end;

procedure TcxGridInplaceEditFormAreaScrollBars.CheckHorizontalScrollVisibility;
begin
  HorizontalScrollBar.Visible := ContainerViewInfo.ContentWidth > ViewInfo.DataWidth;
end;

procedure TcxGridInplaceEditFormAreaScrollBars.CheckPosition;
begin
  CheckHorizontalScrollPosition;
  CheckVerticalScrollPosition;
end;

procedure TcxGridInplaceEditFormAreaScrollBars.CheckVerticalScrollPosition;
begin
  if VerticalScrollBar.Visible then
    VerticalScrollBar.Position := Round((ViewInfo.Bounds.Top - ContainerViewInfo.Offset.Y) *
      (VerticalScrollBar.Max - VerticalScrollBar.Min - VerticalScrollBar.PageSize)/
      (ContainerViewInfo.ContentHeight - ViewInfo.DataHeight))
end;

procedure TcxGridInplaceEditFormAreaScrollBars.CheckVertiacalScrollVisibility;
begin
  VerticalScrollBar.Visible := ContainerViewInfo.ContentHeight > ViewInfo.DataHeight;
end;

procedure TcxGridInplaceEditFormAreaScrollBars.CheckVisibility;
begin
  CheckHorizontalScrollVisibility;
  CheckVertiacalScrollVisibility;
  if NeedRecheckHorizontalScrollVisibility then
    CheckHorizontalScrollVisibility;
end;

function TcxGridInplaceEditFormAreaScrollBars.GetContainerOffsetFromScrollPosition(
  AScrollBarViewInfo: TcxGridInplaceEditFormAreaScrollBarViewInfo; AKind: TScrollBarKind): Integer;
var
  ADelta, AStartPosition: Integer;
begin
  if AKind = sbHorizontal then
    Result :=  ViewInfo.Bounds.Left
  else
    Result := ViewInfo.Bounds.Top;
  if AScrollBarViewInfo <> nil then
  begin
    if (AScrollBarViewInfo.Max - AScrollBarViewInfo.Min - AScrollBarViewInfo.PageSize) <= 0 then
      Result := 0
    else
    begin
      if AKind = sbHorizontal then
      begin
        ADelta := ContainerViewInfo.ContentWidth - ViewInfo.DataWidth;
        AStartPosition := ViewInfo.Bounds.Left
      end
      else
      begin
        ADelta := ContainerViewInfo.ContentHeight - ViewInfo.DataHeight;
        AStartPosition := ViewInfo.Bounds.Top;
      end;
      Result := AStartPosition - Round(AScrollBarViewInfo.Position * ADelta /
        (AScrollBarViewInfo.Max - AScrollBarViewInfo.Min - AScrollBarViewInfo.PageSize))
    end;
  end;
end;

function TcxGridInplaceEditFormAreaScrollBars.GetHorizontalScrollBarHeight: Integer;
begin
  if HorizontalScrollBar.Visible then
    Result := HorizontalScrollBar.Height
  else
    Result := 0;
end;

function TcxGridInplaceEditFormAreaScrollBars.GetVerticalScrollBarWidth: Integer;
begin
  if VerticalScrollBar.Visible then
    Result := VerticalScrollBar.Width
  else
    Result := 0;
end;

function TcxGridInplaceEditFormAreaScrollBars.GetScrollBarClass: TcxGridInplaceEditFormAreaScrollBarViewInfoClass;
begin
  Result := TcxGridInplaceEditFormAreaScrollBarViewInfo;
end;

function TcxGridInplaceEditFormAreaScrollBars.NeedRecheckHorizontalScrollVisibility: Boolean;
begin
  Result := VerticalScrollBar.Visible and not HorizontalScrollBar.Visible;
end;

procedure TcxGridInplaceEditFormAreaScrollBars.CreateScrollBars;
begin
  FHorizontalScrollBar := GetScrollBarClass.Create(ViewInfo);
  FVerticalScrollBar := GetScrollBarClass.Create(ViewInfo);
  FVerticalScrollBar.Kind := sbVertical;
end;

procedure TcxGridInplaceEditFormAreaScrollBars.DestroyScrollBars;
begin
  FreeAndNil(FVerticalScrollBar);
  FreeAndNil(FHorizontalScrollBar);
end;

procedure TcxGridInplaceEditFormAreaScrollBars.RightToLeftConversion(const ABounds: TRect);
begin
  if HorizontalScrollBar.Visible then
    HorizontalScrollBar.RightToLeftConversion(ABounds);
  if VerticalScrollBar.Visible then
    VerticalScrollBar.RightToLeftConversion(ABounds);
end;

function TcxGridInplaceEditFormAreaScrollBars.GetContainerViewInfo: TcxGridInplaceEditFormContainerViewInfo;
begin
  Result := ViewInfo.ContainerViewInfo;
end;

{ TcxGridInplaceEditFormButtonViewInfo }

constructor TcxGridInplaceEditFormButtonViewInfo.Create(AButtonsPanelViewInfo: TcxGridInplaceEditFormButtonsPanelViewInfo);
begin
  inherited Create(AButtonsPanelViewInfo.GridViewInfo);
  FViewInfo := AButtonsPanelViewInfo;
end;

function TcxGridInplaceEditFormButtonViewInfo.DoCalculateHeight: Integer;
begin
  Result := TextHeightWithOffset + 2 * LookAndFeelPainter.ScaledButtonTextOffset(ScaleFactor);
  Result := Max(Result, ScaleFactor.Apply(cxGridInplaceEditFormButtonMinHeight));
end;

function TcxGridInplaceEditFormButtonViewInfo.DoCalculateWidth: Integer;
begin
  Result := TextWidthWithOffset + 2 * LookAndFeelPainter.ScaledButtonTextOffset(ScaleFactor);
  Result := Max(Result, ScaleFactor.Apply(cxGridInplaceEditFormButtonMinWidth));
end;

function TcxGridInplaceEditFormButtonViewInfo.GetHitTestClass: TcxCustomGridHitTestClass;
begin
  Result := TcxGridInplaceEditFormButtonHitTest;
end;

function TcxGridInplaceEditFormButtonViewInfo.GetPainterClass: TcxCustomGridCellPainterClass;
begin
  Result := TcxGridInplaceEditFormButtonPainter;
end;

procedure TcxGridInplaceEditFormButtonViewInfo.GetViewParams(var AParams: TcxViewParams);
begin
  GridView.Styles.GetViewParams(0, nil, nil, AParams);
end;

function TcxGridInplaceEditFormButtonViewInfo.GetGridView: TcxGridTableView;
begin
  Result := TcxGridTableView(inherited GridView);
end;

function TcxGridInplaceEditFormButtonViewInfo.GetInplaceEditFormAreaViewInfo: TcxGridInplaceEditFormAreaViewInfo;
begin
  Result := ButtonsPanelViewInfo.ViewInfo;
end;

{ TcxGridInplaceEditFormCancelButtonViewInfo }

procedure TcxGridInplaceEditFormCancelButtonViewInfo.Click;
begin
  ViewInfo.RecordViewInfo.CancelInplaceEditFormEditing;
end;

function TcxGridInplaceEditFormCancelButtonViewInfo.GetHitTestClass: TcxCustomGridHitTestClass;
begin
  Result := TcxGridInplaceEditFormCancelButtonHitTest;
end;

function TcxGridInplaceEditFormCancelButtonViewInfo.GetText: string;
begin
  if ViewInfo.InplaceEditForm.IsUpdateButtonVisible then
    Result := cxGetResourceString(@scxGridInplaceEditFormButtonCancel)
  else
    Result := cxGetResourceString(@scxGridInplaceEditFormButtonClose);
end;

function TcxGridInplaceEditFormCancelButtonViewInfo.GetFocused: Boolean;
begin
  Result := (ViewInfo.FocusedItemKind = fikCancelButton) and GridView.IsControlFocused;
end;

{ TcxGridInplaceEditFormUpdateButtonViewInfo }

procedure TcxGridInplaceEditFormUpdateButtonViewInfo.Click;
begin
  try
    ViewInfo.RecordViewInfo.UpdateInplaceEditFormEditing;
  except
    MouseCapture := False;
    raise;
  end;
end;

function TcxGridInplaceEditFormUpdateButtonViewInfo.GetEnabled: Boolean;
begin
  Result := ViewInfo.InplaceEditForm.Modified;
end;

function TcxGridInplaceEditFormUpdateButtonViewInfo.GetFocused: Boolean;
begin
  Result := (ViewInfo.FocusedItemKind = fikUpdateButton) and GridView.IsControlFocused;
end;

function TcxGridInplaceEditFormUpdateButtonViewInfo.GetHitTestClass: TcxCustomGridHitTestClass;
begin
  Result := TcxGridInplaceEditFormUpdateButtonHitTest;
end;

function TcxGridInplaceEditFormUpdateButtonViewInfo.GetHotTrack: Boolean;
begin
  Result := Enabled;
end;

function TcxGridInplaceEditFormUpdateButtonViewInfo.GetText: string;
begin
  Result := cxGetResourceString(@scxGridInplaceEditFormButtonUpdate);
end;

function TcxGridInplaceEditFormUpdateButtonViewInfo.GetVisible: Boolean;
begin
  Result := ViewInfo.InplaceEditForm.IsUpdateButtonVisible;
end;

{ TcxGridInplaceEditFormButtonsPanelViewInfo }

constructor TcxGridInplaceEditFormButtonsPanelViewInfo.Create(AInplaceEditFormAreaViewInfo: TcxGridInplaceEditFormAreaViewInfo);
begin
  inherited Create(AInplaceEditFormAreaViewInfo.GridViewInfo);
  FViewInfo := AInplaceEditFormAreaViewInfo;
  FItems := TdxFastObjectList.Create;
  CreateButtons;
  Params.Color := ViewInfo.Params.Color;
end;

destructor TcxGridInplaceEditFormButtonsPanelViewInfo.Destroy;
begin
  DestroyButtons;
  FreeAndNil(FItems);
  inherited Destroy;
end;

procedure TcxGridInplaceEditFormButtonsPanelViewInfo.Calculate(ALeftBound, ATopBound: Integer;
  AWidth: Integer = -1; AHeight: Integer = -1);
begin
  inherited Calculate(ALeftBound, ATopBound, AWidth, AHeight);
  CalculateButtons;
end;

function TcxGridInplaceEditFormButtonsPanelViewInfo.GetHitTest(const P: TPoint): TcxCustomGridHitTest;
var
  AHitTest: TcxCustomGridHitTest;
  I: Integer;
begin
  Result := inherited GetHitTest(P);
  if (Result <> nil) and (Result.ClassType = GetHitTestClass) then
  begin
    for I := 0 to FItems.Count - 1 do
    begin
      AHitTest := Items[I].GetHitTest(P);
      if AHitTest <> nil then
      begin
        Result := AHitTest;
        Exit;
      end;
    end;
  end;
end;

function TcxGridInplaceEditFormButtonsPanelViewInfo.AddItem(
  AItemClass: TcxGridInplaceEditFormButtonViewInfoClass): TcxGridInplaceEditFormButtonViewInfo;
begin
  Result := AItemClass.Create(Self);
  FItems.Add(Result);
end;

function TcxGridInplaceEditFormButtonsPanelViewInfo.GetButtonRightIndent: Integer;
var
  AContainerRootOffset: TdxLayoutLookAndFeelOffsets;
begin
  AContainerRootOffset := ViewInfo.ContainerViewInfo.LayoutLookAndFeel.Offsets;
  Result := AContainerRootOffset.RootItemsAreaOffsetHorz + AContainerRootOffset.ItemOffset;
end;

procedure TcxGridInplaceEditFormButtonsPanelViewInfo.CalculateButtons;
var
  I: Integer;
  ALeft, ATop, AButtonWidth: Integer;
begin
  ALeft := Bounds.Right;
  AButtonWidth := GetMaxButtonWidth;
  SetButtonsWidth(AButtonWidth);
  for I := 0 to FItems.Count - 1 do
  begin
    if I = 0 then
      ALeft := ALeft - GetButtonRightIndent
    else
      ALeft := ALeft - ScaleFactor.Apply(cxGridInplaceEditFormButtonsOffset);
    ALeft := ALeft - Items[I].Width;
    ATop := Bounds.Top + ScaleFactor.Apply(cxGridInplaceEditFormButtonsTopOffset) + GetSeparatorHeight;
    Items[I].Calculate(ALeft, ATop, Items[I].Width);
  end;
end;

function TcxGridInplaceEditFormButtonsPanelViewInfo.CalculateHeight: Integer;
var
  I, AItemHeight: Integer;
begin
  Result := 0;
  for I := 0 to FItems.Count - 1 do
    if Items[I].Visible then
    begin
      AItemHeight := Items[I].CalculateHeight;
      Result := Max(Result, AItemHeight);
    end;
  if Result <> 0 then
  begin
    Inc(Result, ScaleFactor.Apply(cxGridInplaceEditFormButtonsTopOffset));
    Inc(Result, ScaleFactor.Apply(cxGridInplaceEditFormButtonsBottomOffset));
    Inc(Result, GetSeparatorHeight);
  end;
end;

function TcxGridInplaceEditFormButtonsPanelViewInfo.CalculateWidth: Integer;
begin
  Result := ViewInfo.Width;
end;

function TcxGridInplaceEditFormButtonsPanelViewInfo.GetHeight: Integer;
begin
  Result := CalculateHeight;
end;

function TcxGridInplaceEditFormButtonsPanelViewInfo.GetHitTestClass: TcxCustomGridHitTestClass;
begin
  Result := TcxGridInplaceEditFormButtonsPanelHitTest;
end;

function TcxGridInplaceEditFormButtonsPanelViewInfo.GetPainterClass: TcxCustomGridCellPainterClass;
begin
  Result := TcxGridInplaceEditFormButtonsPanelPainter;
end;

function TcxGridInplaceEditFormButtonsPanelViewInfo.GetSeparatorBound: TRect;
begin
  Result := Bounds;
  Result.Left := Result.Left + GetButtonRightIndent;
  Result.Right := Result.Right - GetButtonRightIndent;
  Result.Bottom := Result.Top + GetSeparatorHeight;
end;

function TcxGridInplaceEditFormButtonsPanelViewInfo.GetSeparatorHeight: Integer;
begin
  Result := Form.Container.LayoutLookAndFeel.GetSeparatorItemMinWidth;
end;

procedure TcxGridInplaceEditFormButtonsPanelViewInfo.GetViewParams(var AParams: TcxViewParams);
begin
  GridView.Styles.GetViewParams(0, nil, nil, AParams);
end;

function TcxGridInplaceEditFormButtonsPanelViewInfo.GetWidth: Integer;
begin
  Result := CalculateWidth;
end;

procedure TcxGridInplaceEditFormButtonsPanelViewInfo.CreateButtons;
begin
  AddItem(TcxGridInplaceEditFormCancelButtonViewInfo);
  AddItem(TcxGridInplaceEditFormUpdateButtonViewInfo);
end;

procedure TcxGridInplaceEditFormButtonsPanelViewInfo.DestroyButtons;
begin
  FItems.Clear;
end;

procedure TcxGridInplaceEditFormButtonsPanelViewInfo.DoRightToLeftConversion(const ABounds: TRect);
var
  I: Integer;
begin
  inherited DoRightToLeftConversion(ABounds);
  for I := 0 to ButtonCount - 1 do
    Items[I].RightToLeftConversion(ABounds);
end;

function TcxGridInplaceEditFormButtonsPanelViewInfo.GetButtonCount: Integer;
begin
  Result := FItems.Count;
end;

function TcxGridInplaceEditFormButtonsPanelViewInfo.GetGridView: TcxGridTableView;
begin
  Result := TcxGridTableView(inherited GridView);
end;

function TcxGridInplaceEditFormButtonsPanelViewInfo.GetForm: TcxGridTableViewInplaceEditForm;
begin
  Result := ViewInfo.InplaceEditForm;
end;

function TcxGridInplaceEditFormButtonsPanelViewInfo.GetItem(
  Index: Integer): TcxGridInplaceEditFormButtonViewInfo;
begin
  Result := TcxGridInplaceEditFormButtonViewInfo(FItems[Index]);
end;

function TcxGridInplaceEditFormButtonsPanelViewInfo.GetMaxButtonWidth: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to FItems.Count - 1 do
    Result := Max(Result, Items[I].CalculateWidth);
end;

procedure TcxGridInplaceEditFormButtonsPanelViewInfo.SetButtonsWidth(AValue: Integer);
var
  I: Integer;
begin
  for I := 0 to FItems.Count - 1 do
    Items[I].Width :=  AValue;
end;

{ TcxGridInplaceEditFormAreaViewInfoCacheInfo }

procedure TcxGridInplaceEditFormAreaViewInfoCacheInfo.SetHeight(
  const Value: Integer);
begin
  FHeight := Value;
  FIsHeightAssigned := True;
end;

procedure TcxGridInplaceEditFormAreaViewInfoCacheInfo.SetRestHeight(
  const Value: Integer);
begin
  FRestHeight := Value;
  FIsRestHeightAssigned := True;
end;

{ TcxGridInplaceEditFormAreaViewInfo }

constructor TcxGridInplaceEditFormAreaViewInfo.Create(
  AGridViewInfo: TcxCustomGridViewInfo; ARecordViewInfo: TcxGridDataRowViewInfo);
begin
  inherited Create(AGridViewInfo);
  FCacheInfo := TcxGridInplaceEditFormAreaViewInfoCacheInfo.Create;
  FRecordViewInfo := ARecordViewInfo;
  ContainerViewInfo.Calculate(True);
  CreateGridItemViewInfos;
  CreateButtonsPanel;
  FHybridScrollbarsManager := TdxHybridScrollbarsManager.Create(Self);
  CreateScrollBars;
  ScrollBars.CheckVisibility;
  CacheInfo.IsHeightAssigned := False;
  CacheInfo.IsRestHeightAssigned := False;
end;

destructor TcxGridInplaceEditFormAreaViewInfo.Destroy;
begin
  TcxControlAccess(Control).Deactivate(Self);
  DestroyScrollBars;
  FreeAndNil(FHybridScrollbarsManager);
  DestroyButtonsPanel;
  DestroyGridItemViewInfos;
  FreeAndNil(FCacheInfo);
  inherited Destroy;
end;

procedure TcxGridInplaceEditFormAreaViewInfo.BeforeRecalculation;
var
  I: Integer;
begin
  inherited BeforeRecalculation;
  for I := 0 to GridItemViewInfos.Count - 1 do
    GridItemViewInfos[I].BeforeRecalculation;
end;

procedure TcxGridInplaceEditFormAreaViewInfo.Calculate(ALeftBound, ATopBound: Integer; AWidth: Integer = -1;
  AHeight: Integer = -1);
var
  AOffsetX, AOffsetY: Integer;
  ADelta: Integer;
begin
  inherited Calculate(ALeftBound, ATopBound, AWidth, AHeight);
  ButtonsPanelViewInfo.Calculate(Bounds.Left,
    Bounds.Bottom - ButtonsPanelViewInfo.CalculateHeight);
  ScrollBars.Calculate;
  AOffsetX := ScrollBars.GetContainerOffset.X - GridViewInfo.Bounds.Left;
  if GridViewInfo.IsRightToLeftConverted then
  begin
    ADelta := RecordViewInfo.RecordsViewInfo.ContentBounds.Left - GridViewInfo.Bounds.Left;
    if ADelta > 0 then
      Dec(AOffsetX, Min(TcxGridTableViewAccess(GridView).GetVerticalScrollBarAreaWidth, ADelta));
    Inc(AOffsetX, GridViewInfo.Bounds.Right - Bounds.Right);
  end;
  AOffsetY := ScrollBars.GetContainerOffset.Y;
  ContainerViewInfo.Offset := Point(AOffsetX, AOffsetY);
  CalculateLayoutContainerViewInfo;
end;

procedure TcxGridInplaceEditFormAreaViewInfo.DoRightToLeftConversion(const ABounds: TRect);
begin
  inherited DoRightToLeftConversion(ABounds);
  ScrollBars.RightToLeftConversion(ABounds);
  ButtonsPanelViewInfo.RightToLeftConversion(ABounds);
end;

function TcxGridInplaceEditFormAreaViewInfo.FindCellViewInfo(
  AGridItem: TcxCustomGridTableItem): TcxGridViewLayoutItemDataCellViewInfo;
begin
  Result := GridItemViewInfos.FindCellViewInfo(AGridItem);
end;

function TcxGridInplaceEditFormAreaViewInfo.GetBoundsForEdit(const ADataCellBounds: TRect): TRect;
begin
  Result := ADataCellBounds;
  if Result.Right > (Bounds.Left + DataWidth) then
    Result.Right := Bounds.Left + DataWidth;
  if Result.Bottom > (Bounds.Top + DataHeight) then
    Result.Bottom := Bounds.Top + DataHeight;
end;

function TcxGridInplaceEditFormAreaViewInfo.GetHitTest(const P: TPoint): TcxCustomGridHitTest;
var
  AHitTest: TcxCustomGridHitTest;
begin
  Result := inherited GetHitTest(P);
  if (Result <> nil) and (Result.ClassType = GetHitTestClass) then
  begin
    AHitTest := ButtonsPanelViewInfo.GetHitTest(P);
    if AHitTest <> nil then
    begin
      Result := AHitTest;
      Exit;
    end;
    if IsPointInLayoutContainer(P) then
    begin
      AHitTest := GetGridItemHitTest(P);
      if AHitTest <> nil then
      begin
        Result := AHitTest;
        Exit;
      end;
    end;
  end;
end;

procedure TcxGridInplaceEditFormAreaViewInfo.InvalidateUpdateButtonInfo;
begin
  ButtonsPanelViewInfo.Items[1].Invalidate;
end;

procedure TcxGridInplaceEditFormAreaViewInfo.MakeDataCellVisible(
  ACellViewInfo: TcxGridTableViewInplaceEditFormDataCellViewInfo);

  function GetLeftOffset: Integer;
  var
    ALayoutItemBounds: TRect;
  begin
    Result := 0;
    ALayoutItemBounds := ACellViewInfo.LayoutItemViewInfoBounds;
    if ALayoutItemBounds.Left < Bounds.Left then
      Result := Bounds.Left - ALayoutItemBounds.Left
    else
      if ALayoutItemBounds.Right > (Bounds.Left + DataWidth) then
        if DataWidth > cxRectWidth(ALayoutItemBounds) then
          Result := Bounds.Left + DataWidth - ALayoutItemBounds.Right
        else
          Result := Bounds.Left - ALayoutItemBounds.Left;
  end;

  function GetTopOffset: Integer;
  var
    ALayoutItemBounds: TRect;
  begin
    Result := 0;
    ALayoutItemBounds := ACellViewInfo.LayoutItemViewInfoBounds;
    if ALayoutItemBounds.Top < Bounds.Top then
      Result := Bounds.Top - ALayoutItemBounds.Top
    else
      if ALayoutItemBounds.Bottom > (Bounds.Top + DataHeight) then
        if DataHeight > cxRectHeight(ALayoutItemBounds) then
          Result := Bounds.Top + DataHeight - ALayoutItemBounds.Bottom
        else
          Result := Bounds.Top - ALayoutItemBounds.Top;
  end;

var
  AOffsetX, AOffsetY: Integer;
begin
  AOffsetX := GetLeftOffset;
  if GridViewInfo.IsRightToLeftConverted then
    AOffsetX := -AOffsetX;
  AOffsetY := GetTopOffset;
  if (AOffsetX <> 0) or (AOffsetY <> 0) then
    DoOffset(AOffsetX, AOffsetY);
end;

procedure TcxGridInplaceEditFormAreaViewInfo.MakeItemVisible(AItem: TcxCustomGridTableItem);
var
  ADataCell: TcxGridTableDataCellViewInfo;
begin
  ADataCell := FindCellViewInfo(AItem);
  if ADataCell <> nil then
    MakeDataCellVisible(TcxGridTableViewInplaceEditFormDataCellViewInfo(ADataCell));
end;

function TcxGridInplaceEditFormAreaViewInfo.MouseDown(AHitTest: TcxCustomGridHitTest; AButton: TMouseButton;
  AShift: TShiftState): Boolean;
begin
  Result := inherited MouseDown(AHitTest, AButton, AShift);
  if IsPointInLayoutContainer(AHitTest.Pos) then
    ContainerViewInfo.MouseDown(AButton, AShift, AHitTest.Pos.X, AHitTest.Pos.Y);
end;

function TcxGridInplaceEditFormAreaViewInfo.MouseMove(AHitTest: TcxCustomGridHitTest; AShift: TShiftState): Boolean;
begin
  Result := inherited MouseMove(AHitTest, AShift);
  if IsPointInLayoutContainer(AHitTest.Pos) then
    ContainerViewInfo.MouseMove(AShift, AHitTest.Pos.X, AHitTest.Pos.Y);
end;

function TcxGridInplaceEditFormAreaViewInfo.MouseUp(AHitTest: TcxCustomGridHitTest; AButton: TMouseButton;
  AShift: TShiftState): Boolean;
begin
  Result := inherited MouseUp(AHitTest, AButton, AShift);
  if IsPointInLayoutContainer(AHitTest.Pos) then
  begin
    ContainerViewInfo.MouseUp(AButton, AShift, AHitTest.Pos.X, AHitTest.Pos.Y);
    CheckFocusedItem;
  end;
end;

function TcxGridInplaceEditFormAreaViewInfo.CalculateAvailableHeight: Integer;
begin
  Result := cxRectHeight(RecordViewInfo.RecordsViewInfo.ContentBounds);
  if GridView.OptionsBehavior.EditMode <> emInplaceEditFormHideCurrentRow then
  begin
    Dec(Result, RecordViewInfo.CellHeight);
    if RecordViewInfo.HasPreview then
      Dec(Result, RecordViewInfo.PreviewViewInfo.Height);
  end;
end;

function TcxGridInplaceEditFormAreaViewInfo.CalculateHeight: Integer;
var
  AAvailableHeight: Integer;
  ARequiredHeight: Integer;
begin
  AAvailableHeight := AvailableHeight;
  if ContainerViewInfo.ItemsViewInfo.AlignVert <> avClient then
  begin
    ARequiredHeight := ContainerViewInfo.ContentHeight;
    if not TcxControlAccess(Control).IsPopupScrollBars then
      Inc(ARequiredHeight, ScrollBars.GetHorizontalScrollBarHeight);
    Inc(ARequiredHeight, ButtonsPanelViewInfo.Height);
    Result := Min(ARequiredHeight, AAvailableHeight);
  end
  else
    Result := AAvailableHeight;
  if Result < 0 then Result := 0;
end;

procedure TcxGridInplaceEditFormAreaViewInfo.CalculateLayoutContainerViewInfo;
begin
  ContainerViewInfo.Calculate(True);
  CheckFocusedItem;
end;

function TcxGridInplaceEditFormAreaViewInfo.CalculateWidth: Integer;

  function GetEmptySpaceWidth: Integer;
  begin
    if GridViewInfo.IsRightToLeftConverted then
      Result := RecordViewInfo.RecordsViewInfo.ContentBounds.Left - GridViewInfo.Bounds.Left
    else
      Result := GridViewInfo.Bounds.Right - RecordViewInfo.RecordsViewInfo.ContentBounds.Right;
    Result := Max(Result, 0);
  end;

begin
  if GridViewInfo.IsRightToLeftConverted then
    Result := Min(RecordViewInfo.RecordsViewInfo.ContentBounds.Right - RecordViewInfo.DataRelativeIndent,
      GridViewInfo.Bounds.Right - GridViewInfo.IndicatorViewInfo.Width) - GridViewInfo.ClientBounds.Left
  else
    Result := GridViewInfo.ClientBounds.Right - RecordViewInfo.GetInplaceEditFormLeftPosition;
  Dec(Result, Min(TcxGridTableViewAccess(GridView).GetVerticalScrollBarAreaWidth, GetEmptySpaceWidth));
  Result := Max(Result, 0);
end;

procedure TcxGridInplaceEditFormAreaViewInfo.CheckFocusedItem;
var
  I: Integer;
  AGridItemViewInfo: TcxGridTableViewInplaceEditFormDataCellViewInfo;
begin
  if RecordViewInfo.GridViewInfo.CalculateDown then
    for I := 0 to GridItemViewInfos.Count - 1 do
    begin
      AGridItemViewInfo := TcxGridTableViewInplaceEditFormDataCellViewInfo(GridItemViewInfos.Items[I]);
      if AGridItemViewInfo.Focused then
      begin
        InplaceEditForm.CheckFocusedItem(AGridItemViewInfo);
        Break;
      end;
    end;
end;

function TcxGridInplaceEditFormAreaViewInfo.FocusedItemKind: TcxGridFocusedItemKind;
begin
  Result := RecordViewInfo.FocusedItemKind;
end;

function TcxGridInplaceEditFormAreaViewInfo.GetAvailableHeight: Integer;
begin
  if CacheInfo.IsRestHeightAssigned then
    Result := CacheInfo.RestHeight
  else
  begin
    Result := CalculateAvailableHeight;
    CacheInfo.RestHeight := Result;
  end;
end;

function TcxGridInplaceEditFormAreaViewInfo.GetBoundsForGridItem(AGridItem: TcxCustomGridTableItem): TRect;
var
  AItemViewInfo: TcxGridTableDataCellViewInfo;
begin
  AItemViewInfo := FindCellViewInfo(AGridItem);
  if AItemViewInfo <> nil then
    Result := AItemViewInfo.ContentBounds
  else
    Result := cxEmptyRect;
end;

function TcxGridInplaceEditFormAreaViewInfo.GetDataHeight: Integer;

  function GetHorizontalScrollBarHeight: Integer;
  begin
    if ScrollBars = nil then
      Result := GetScaledScrollBarSize(ScaleFactor).cx
    else
      Result := ScrollBars.GetHorizontalScrollBarHeight;
  end;

var
  AAvailableHeight: Integer;
  AContentHeight: Integer;
  AHScrollBarHeight: Integer;
  ARequiredHeight: Integer;
begin
  AAvailableHeight := AvailableHeight;
  if GridView.EditForm.DefaultStretch = fsNone then
    AContentHeight := ContainerViewInfo.ContentHeight
  else
    AContentHeight := ContainerViewInfo.ItemsViewInfo.MinHeight;
  if ScrollBars.HorizontalScrollBar.Visible and not TcxControlAccess(Control).IsPopupScrollBars then
    AHScrollBarHeight := GetHorizontalScrollBarHeight
  else
    AHScrollBarHeight := 0;
  ARequiredHeight := AContentHeight + ButtonsPanelViewInfo.Height + AHScrollBarHeight;
  if (GridView.EditForm.DefaultStretch in [fsVertical, fsClient]) or
    (ARequiredHeight > AAvailableHeight) then
  begin
    Result := AAvailableHeight;
    Dec(Result, ButtonsPanelViewInfo.Height);
    Dec(Result, AHScrollBarHeight);
  end
  else
    Result := AContentHeight;
  if Result < 0 then Result := 0;
end;

function TcxGridInplaceEditFormAreaViewInfo.GetDataWidth: Integer;

  function GetVerticalScrollBarWidth: Integer;
  begin
    if ScrollBars <> nil then
      Result := ScrollBars.GetVerticalScrollBarWidth
    else
      Result := GetScaledScrollBarSize(ScaleFactor).cy;
  end;

var
  AVScrollBarWidth: Integer;
begin
  Result := Width;
  AVScrollBarWidth := 0;
  if ScrollBars.VerticalScrollBar.Visible and not TcxControlAccess(Control).IsPopupScrollBars then
    AVScrollBarWidth := GetVerticalScrollBarWidth;
  Dec(Result, AVScrollBarWidth);
  if Result < 0 then Result := 0;
end;

function TcxGridInplaceEditFormAreaViewInfo.GetGridItemHitTest(
  const P: TPoint): TcxCustomGridHitTest;
begin
  Result := GridItemViewInfos.GetHitTest(P);
end;

function TcxGridInplaceEditFormAreaViewInfo.GetHeight: Integer;
begin
  if FCacheInfo.IsHeightAssigned then
    Result := FCacheInfo.Height
  else
  begin
    Result := CalculateHeight;
    FCacheInfo.Height := Result;
  end;
end;

function TcxGridInplaceEditFormAreaViewInfo.GetInplaceEditFormClientBounds: TRect;
begin
  Result := Rect(Bounds.Left, Bounds.Top, Bounds.Left + DataWidth, Bounds.Top + DataHeight);
end;

procedure TcxGridInplaceEditFormAreaViewInfo.GetViewParams(var AParams: TcxViewParams);
begin
  AParams.Color := ContainerViewInfo.ItemsViewInfo.Color;
end;

function TcxGridInplaceEditFormAreaViewInfo.GetWidth: Integer;
begin
  Result := CalculateWidth;
end;

function TcxGridInplaceEditFormAreaViewInfo.IsPointInLayoutContainer(const P: TPoint): Boolean;
var
  ARect: TRect;
  ARight, ABottom: Integer;
begin
  ARight := Min(Bounds.Left + DataWidth, ContainerViewInfo.ContentBounds.Right);
  ABottom := Min(Bounds.Top + DataHeight, ContainerViewInfo.ContentBounds.Bottom);
  ARect := Rect(Bounds.Left, Bounds.Top, ARight, ABottom);
  Result := PtInRect(ARect, P);
end;

procedure TcxGridInplaceEditFormAreaViewInfo.Offset(DX, DY: Integer);

  procedure CheckScrollBarsPosition;
  begin
    ScrollBars.CheckPosition;
  end;

begin
  ContainerViewInfo.Offset := Point(ContainerViewInfo.Offset.X + DX,
    ContainerViewInfo.Offset.Y + DY);
  CalculateLayoutContainerViewInfo;
  CheckScrollBarsPosition;
  Invalidate;
end;

procedure TcxGridInplaceEditFormAreaViewInfo.UpdateOnScroll;
begin
  Recalculate;
  InplaceEditForm.ValidateEditVisibility;
  Invalidate;
end;

function TcxGridInplaceEditFormAreaViewInfo.GetGridItemViewInfoClass: TcxGridTableDataCellViewInfoClass;
begin
  Result := TcxGridTableViewInplaceEditFormDataCellViewInfo;
end;

function TcxGridInplaceEditFormAreaViewInfo.GetHitTestClass: TcxCustomGridHitTestClass;
begin
  Result := TcxGridInplaceEditFormAreaHitTest;
end;

function TcxGridInplaceEditFormAreaViewInfo.GetButtonsPanelViewInfoClass: TcxGridInplaceEditFormButtonsPanelViewInfoClass;
begin
  Result := TcxGridInplaceEditFormButtonsPanelViewInfo;
end;

function TcxGridInplaceEditFormAreaViewInfo.GetScrollBarsClass: TcxGridInplaceEditFormAreaScrollBarsClass;
begin
  Result := TcxGridInplaceEditFormAreaScrollBars;
end;

function TcxGridInplaceEditFormAreaViewInfo.GetPainterClass: TcxCustomGridCellPainterClass;
begin
  Result := TcxGridInplaceEditFormAreaPainter;
end;

procedure TcxGridInplaceEditFormAreaViewInfo.CreateButtonsPanel;
begin
  FButtonsPanelViewInfo := GetButtonsPanelViewInfoClass.Create(Self);
end;

procedure TcxGridInplaceEditFormAreaViewInfo.CreateGridItemViewInfos;
var
  I: Integer;
  AGridItemViewInfo: TcxGridTableDataCellViewInfo;
  AGridViewItem: TcxCustomGridTableItem;
begin
  FGridItemViewInfos := TcxGridRowLayoutGridItemViewInfos.Create;
  for I := 0 to InplaceEditForm.Container.AbsoluteItemCount - 1 do
  begin
    if not (InplaceEditForm.Container.AbsoluteItems[I] is TcxGridInplaceEditFormLayoutItem) or
      (InplaceEditForm.Container.AbsoluteItems[I].Parent = nil) then
      Continue;
    AGridViewItem := TcxGridInplaceEditFormLayoutItem(InplaceEditForm.Container.AbsoluteItems[I]).GridViewItem;
    AGridItemViewInfo := GetGridItemViewInfoClass.Create(RecordViewInfo, AGridViewItem);
    FGridItemViewInfos.Add(AGridItemViewInfo);
  end;
end;

procedure TcxGridInplaceEditFormAreaViewInfo.CreateScrollBars;
begin
  FScrollBars := GetScrollBarsClass.Create(Self);
end;

procedure TcxGridInplaceEditFormAreaViewInfo.DestroyButtonsPanel;
begin
  FreeAndNil(FButtonsPanelViewInfo);
end;

procedure TcxGridInplaceEditFormAreaViewInfo.DestroyGridItemViewInfos;
begin
  FreeAndNil(FGridItemViewInfos);
end;

procedure TcxGridInplaceEditFormAreaViewInfo.DestroyScrollBars;
begin
  FreeAndNil(FScrollBars);
end;

function TcxGridInplaceEditFormAreaViewInfo.GetContainerViewInfo: TcxGridInplaceEditFormContainerViewInfo;
begin
  Result := InplaceEditForm.Container.ViewInfo;
end;

function TcxGridInplaceEditFormAreaViewInfo.GetGridRecord: TcxGridDataRow;
begin
  Result := RecordViewInfo.GridRecord;
end;

function TcxGridInplaceEditFormAreaViewInfo.GetGridView: TcxGridTableView;
begin
  Result := TcxGridTableView(inherited GridView);
end;

function TcxGridInplaceEditFormAreaViewInfo.GetGridViewInfo: TcxGridTableViewInfo;
begin
  Result := TcxGridTableViewInfo(inherited GridViewInfo);
end;

function TcxGridInplaceEditFormAreaViewInfo.GetInplaceEditForm: TcxGridTableViewInplaceEditForm;
begin
  Result := RecordViewInfo.InplaceEditForm;
end;

function TcxGridInplaceEditFormAreaViewInfo.GetScrollBarOwner: TWinControl;
begin
  Result := Control;
end;

function TcxGridInplaceEditFormAreaViewInfo.GetLookAndFeel: TcxLookAndFeel;
begin
  Result := GridView.LookAndFeel;
end;

procedure TcxGridInplaceEditFormAreaViewInfo.CheckUIPosition;
begin
  if not GridViewInfo.IsCalculating then
    ScrollBars.Calculate;
end;

function TcxGridInplaceEditFormAreaViewInfo.GetOwnerControl: TcxControl;
begin
  Result := Control;
end;

function TcxGridInplaceEditFormAreaViewInfo.HasVisibleUI: Boolean;
begin
  Result := (ScrollBars <> nil) and (ScrollBars.HorizontalScrollBar.ScrollBar.Visible or
    ScrollBars.VerticalScrollBar.ScrollBar.Visible);
end;

procedure TcxGridInplaceEditFormAreaViewInfo.HideUI;
begin
  if ScrollBars <> nil then
  begin
    if ScrollBars.HorizontalScrollBar.Visible then
      ScrollBars.HorizontalScrollBar.ScrollBar.Visible := False;
    if ScrollBars.VerticalScrollBar.Visible then
      ScrollBars.VerticalScrollBar.ScrollBar.Visible := False;
  end;
end;

// IdxHybridScrollbarOwner
function TcxGridInplaceEditFormAreaViewInfo.GetBaseColor: TColor;
begin
  Result := TcxControlAccess(Control).GetHybridScrollbarBaseColor;
end;

function TcxGridInplaceEditFormAreaViewInfo.GetManager: TdxHybridScrollbarsManager;
begin
  Result := FHybridScrollbarsManager;
end;

procedure TcxGridInplaceEditFormAreaViewInfo.InvalidateHybridScrollbars;
begin
  if FScrollBars <> nil then
  begin
    if ScrollBars.HorizontalScrollBar.ScrollBar.Visible then
      ScrollBars.HorizontalScrollBar.FScrollBar.Invalidate;
    if ScrollBars.VerticalScrollBar.ScrollBar.Visible then
      ScrollBars.VerticalScrollBar.FScrollBar.Invalidate;
  end;
end;

{ TcxGridDataRowViewInfo }

constructor TcxGridDataRowViewInfo.Create(ARecordsViewInfo: TcxCustomGridRecordsViewInfo;
  ARecord: TcxCustomGridRecord);
begin
  inherited;
  CreateViewInfos;
end;

destructor TcxGridDataRowViewInfo.Destroy;
begin
  DestroyViewInfos;
  inherited;
end;

function TcxGridDataRowViewInfo.FindCellViewInfoInTableRow(AItem: TcxCustomGridColumn): TcxGridTableDataCellViewInfo;
begin
  if AItem.VisibleIndex = -1 then
    Result := nil
  else
    if GridView.IsControlLocked and not (GridViewInfo.IsCalculating or GridView.InDataControlFocusing) then
      Result := nil
    else
      Result := InternalCellViewInfos[AItem.VisibleIndex];
end;

function TcxGridDataRowViewInfo.GetCellSeparatorBounds(AFixedKind: TcxGridColumnFixedKind): TRect;
begin
  Result := FCellSeparatorsBounds[AFixedKind];
end;

function TcxGridDataRowViewInfo.GetCellViewInfo(Index: Integer): TcxGridDataCellViewInfo;
begin
  Result := InternalCellViewInfos[Index];
  if Result = nil then
  begin
    Result := GetCellViewInfoClass(Index).Create(Self, GridView.VisibleColumns[Index]);
    FCellViewInfos[Index] := Result;
  end;
end;

function TcxGridDataRowViewInfo.GetCellViewInfoCount: Integer;
begin
  if FCellViewInfos <> nil then
    Result := FCellViewInfos.Count
  else
    Result := 0;
end;

function TcxGridDataRowViewInfo.GetGridRecord: TcxGridDataRow;
begin
  Result := TcxGridDataRow(inherited GridRecord);
end;

function TcxGridDataRowViewInfo.GetHasPreview: Boolean;
begin
  Result := FPreviewViewInfo <> nil;
end;

function TcxGridDataRowViewInfo.GetInplaceEditForm: TcxGridTableViewInplaceEditForm;
begin
  Result := TcxGridTableViewAccess(GridView).InplaceEditForm;
end;

function TcxGridDataRowViewInfo.GetInternalCellViewInfo(Index: Integer): TcxGridDataCellViewInfo;
begin
  if IsCellIndexValid(Index) then
    Result := TcxGridDataCellViewInfo(FCellViewInfos[Index])
  else
    Result := nil;
end;

function TcxGridDataRowViewInfo.GetRowLayoutController: TcxGridTableRowLayoutController;
begin
  Result := TcxGridTableViewAccess(GridView).RowLayoutController;
end;

procedure TcxGridDataRowViewInfo.CreateViewInfos;
begin
  if ShowDataCells then
  begin
    if ShowLayout then
      FLayoutViewInfo := CreateLayoutViewInfo
    else
    begin
      FCellViewInfos := TList.Create;
      FCellViewInfos.Count := GridViewInfo.HeaderViewInfo.Count;
      FCellsAreaViewInfo := GetCellsAreaViewInfoClass.Create(Self);
    end;
    if ShowPreview then
      FPreviewViewInfo := GetPreviewViewInfoClass.Create(Self, GridView.Preview.Column);
  end;
  if ShowInplaceEditForm then
  begin
    FInplaceEditFormAreaViewInfo := GetInplaceEditFormAreaViewInfoClass.Create(GridViewInfo, Self);
    CacheItem.IsHeightAssigned := False;
  end;
end;

procedure TcxGridDataRowViewInfo.DestroyViewInfos;
var
  I: Integer;
begin
  FreeAndNil(FLayoutViewInfo);
  FreeAndNil(FInplaceEditFormAreaViewInfo);
  FPreviewViewInfo.Free;
  FCellsAreaViewInfo.Free;
  for I := 0 to CellViewInfoCount - 1 do
    InternalCellViewInfos[I].Free;
  FCellViewInfos.Free;
end;

procedure TcxGridDataRowViewInfo.AfterRowsViewInfoCalculate;
var
  I: Integer;
  ACellViewInfo: TcxGridDataCellViewInfo;
begin
  inherited;
  for I := 0 to CellViewInfoCount - 1 do
  begin
    ACellViewInfo := InternalCellViewInfos[I];
    if (ACellViewInfo <> nil) and ACellViewInfo.Calculated then
      ACellViewInfo.AfterRowsViewInfoCalculate;
  end;
end;

procedure TcxGridDataRowViewInfo.AddAdornerTargetElementsForColumn(AList: TStrings; AColumn: TcxCustomGridColumn; AName: string);
begin
  inherited AddAdornerTargetElementsForColumn(AList, AColumn, AName);
  AList.AddObject(AName, FindCellViewInfoInTableRow(AColumn));
end;

function TcxGridDataRowViewInfo.AdjustToIntegralBottomBound(var ABound: Integer): Boolean;
var
  ABottomBound: Integer;
begin
  if HasPreview then
  begin
    if PreviewViewInfo.Preview.Place = ppTop then
    begin
      ABottomBound := PreviewViewInfo.ContentBounds.Bottom;
      Result := ABottomBound >= ABound;
      if not Result then
        ABottomBound := CellsAreaBounds.Bottom - 1;
      Result := ABottomBound >= ABound;
    end
    else
    begin
      ABottomBound := CellsAreaBounds.Bottom - 1;
      Result := ABottomBound >= ABound;
      if not Result then
        ABottomBound := PreviewViewInfo.ContentBounds.Bottom;
      Result := ABottomBound >= ABound;
    end;
    if Result then
      ABound := ABottomBound;
  end
  else
    Result := inherited AdjustToIntegralBottomBound(ABound);
end;

procedure TcxGridDataRowViewInfo.AfterRowsViewInfoOffset;
var
  I: Integer;
  ACellViewInfo: TcxGridDataCellViewInfo;
begin
  inherited;
  for I := 0 to CellViewInfoCount - 1 do
  begin
    ACellViewInfo := InternalCellViewInfos[I];
    if ACellViewInfo <> nil then
      ACellViewInfo.AfterRowsViewInfoOffset;
  end;
end;

function TcxGridDataRowViewInfo.AllowDrawHotTracked: Boolean;
begin
  Result := inherited AllowDrawHotTracked or GridView.OptionsSelection.CellMultiSelect;
end;

function TcxGridDataRowViewInfo.AllowDrawSelected: Boolean;
begin
  Result := inherited AllowDrawSelected or GridView.OptionsSelection.CellMultiSelect;
end;

procedure TcxGridDataRowViewInfo.ApplyMergedCellsBounds(var R: TRect;
  AItem: TcxCustomGridTableItem);
var
  I: Integer;

  procedure ProcessCell(ACellViewInfo: TcxGridDataCellViewInfo);
  begin
    if (ACellViewInfo <> nil) and ACellViewInfo.IsMerged then
      with ACellViewInfo.MergingCell do
      begin
        if Bounds.Top < R.Top then
          R.Top := Bounds.Top;
        if Bounds.Bottom > R.Bottom then
          R.Bottom := Bounds.Bottom;
      end;
  end;

begin
  if AItem = nil then
    for I := 0 to CellViewInfoCount - 1 do
      ProcessCell(InternalCellViewInfos[I])
  else
    ProcessCell(InternalCellViewInfos[AItem.VisibleIndex]);
end;

procedure TcxGridDataRowViewInfo.ApplyMergingCellsBounds(var R: TRect);
var
  I: Integer;
  ACellViewInfo: TcxGridDataCellViewInfo;
begin
  for I := 0 to CellViewInfoCount - 1 do
  begin
    ACellViewInfo := InternalCellViewInfos[I];
    if (ACellViewInfo <> nil) and
      ACellViewInfo.IsMerging and (ACellViewInfo.Bounds.Bottom > R.Bottom) then
      R.Bottom := ACellViewInfo.Bounds.Bottom;
  end;
end;

procedure TcxGridDataRowViewInfo.CalculateCells;
var
  I: Integer;
begin
  for I := 0 to CellViewInfoCount - 1 do
    if IsCellVisible(I) then
      CalculateCellViewInfo(I);
end;

procedure TcxGridDataRowViewInfo.CalculateCellSeparatorBounds(AFixedKind: TcxGridColumnFixedKind);
var
  ABounds, ACellBounds: TRect;
  AHeader: TcxGridHeaderViewInfoAccess;
begin
  AHeader := TcxGridHeaderViewInfoAccess(GridViewInfo.HeaderViewInfo);
  ABounds := AHeader.SeparatorBounds[AFixedKind];
  if not ABounds.IsEmpty then
  begin
    ACellBounds := CellViewInfos[AHeader.LastItem[AFixedKind].Index].Bounds;
    ABounds := Rect(ABounds.Left, ACellBounds.Top, ABounds.Right, ACellBounds.Bottom);
  end;
  FCellSeparatorsBounds[AFixedKind] := ABounds;
end;

procedure TcxGridDataRowViewInfo.CalculateCellSeparators;
var
  AFixedKind: TcxGridColumnFixedKind;
begin
  for AFixedKind := Low(FCellSeparatorsBounds) to High(FCellSeparatorsBounds) do
    CalculateCellSeparatorBounds(AFixedKind);
end;

procedure TcxGridDataRowViewInfo.CalculateCellViewInfo(AIndex: Integer);
var
  ACell: TcxGridDataCellViewInfo;
begin
  ACell := CellViewInfos[AIndex];
  ACell.Calculate(GetCellLeftBound(ACell), GetCellTopBound(ACell), -1, GetCellHeight(ACell));
  if GridViewInfo.IsRightToLeftConverted then
    ACell.RightToLeftConversion(ACell.Bounds);
end;

procedure TcxGridDataRowViewInfo.CalculateInplaceEditForm;
var
  ATopPos, ALeftPos: Integer;
begin
  ALeftPos := GetInplaceEditFormLeftPosition;
  ATopPos := GetInplaceEditFormTopPosition;
  InplaceEditFormAreaViewInfo.Calculate(ALeftPos, ATopPos);
end;

function TcxGridDataRowViewInfo.CalculateMultilineEditMinHeight: Integer;
begin
  if LayoutViewInfo <> nil then
    Result := 0
  else
  begin
    if AutoHeight then
      Result := CalculateDataAutoHeight(False)
    else
      Result := GetCellsAreaHeight;
    Dec(Result, RecordsViewInfo.GetCellHeight(Result) - Result);
    Dec(Result, 2 * cxGridEditOffset);
  end;
end;

procedure TcxGridDataRowViewInfo.CalculatePreview(ATopBound: Integer);
begin
  if PreviewViewInfo.Preview.Place = ppBottom then
    ATopBound := FCellsAreaBounds.Bottom;
  PreviewViewInfo.Calculate(FCellsAreaBounds.Left, ATopBound);
end;

procedure TcxGridDataRowViewInfo.CalculateTableRowEmptyAreaBounds;
var
  ACellsAreaBounds: TRect;
begin
  ACellsAreaBounds := CellsAreaBounds;
  FEmptyAreaBounds := Rect(ACellsAreaBounds.Right, ACellsAreaBounds.Top,
    InplaceEditFormAreaViewInfo.Bounds.Right, InplaceEditFormAreaViewInfo.Bounds.Top);
end;

function TcxGridDataRowViewInfo.CalculateDataAutoHeight(ACheckEditingCell: Boolean = True): Integer;
var
  I, AHeight: Integer;
  ADataCellViewInfo: TcxGridDataCellViewInfo;
begin
  Result := 0;
  for I := 0 to CellViewInfoCount - 1 do
  begin
    ADataCellViewInfo := CellViewInfos[I];
    if not ACheckEditingCell and (ADataCellViewInfo.Item = GridView.Controller.EditingItem) then
      Continue;
    AHeight := RecordsViewInfo.GetCellHeight(ADataCellViewInfo.CalculateHeight);
    if AHeight > Result then
      Result := AHeight;
  end;
end;

function TcxGridDataRowViewInfo.CalculateHeight: Integer;
begin
  if LayoutViewInfo <> nil then
    Result := LayoutViewInfo.Height
  else
    if CellsAreaViewInfo <> nil then
      if AutoHeight then
        Result := CalculateDataAutoHeight
      else
        Result := GetCellsAreaHeight
    else
      Result := 0;
  if HasPreview then
    Inc(Result, PreviewViewInfo.Height);
  if InplaceEditFormAreaViewInfo <> nil then
    Inc(Result, InplaceEditFormAreaViewInfo.Height);
  Inc(Result, inherited CalculateHeight);
end;

function TcxGridDataRowViewInfo.CanDelayedDrawDataCellBorders: Boolean;
begin
  Result := (FixedState = rfsNotFixed) and (GridView.VisibleColumnCountByFixedKind[fkLeft] = 0) and
  (GridView.VisibleColumnCountByFixedKind[fkRight] = 0) and (GridView.VisibleColumnCountByFixedKind[fkLeftDynamic] = 0);
end;

function TcxGridDataRowViewInfo.CanSize: Boolean;
begin
  Result := RecordsViewInfo.CanDataRowSize;
end;

procedure TcxGridDataRowViewInfo.CheckRowHeight(var AValue: Integer);
begin
  Dec(AValue, NonBaseHeight);
  inherited;
  GridView.OptionsView.CheckDataRowHeight(AValue);
  Inc(AValue, NonBaseHeight);
end;

function TcxGridDataRowViewInfo.CreateLayoutViewInfo: TcxGridRowLayoutViewInfo;
begin
  Result := TcxGridRowLayoutViewInfo.Create(Self);
end;

function TcxGridDataRowViewInfo.CustomDrawRowLayoutBackground(ACanvas: TcxCanvas): Boolean;
begin
  Result := False;
  TcxGridTableViewAccess(GridView).DoCustomDrawRowLayoutRowBackground(ACanvas, Self, Result);
end;

procedure TcxGridDataRowViewInfo.DoCellSeparatorBoundsRightToLeftConversion(const ABounds: TRect);
var
  AFixedKind: TcxGridColumnFixedKind;
begin
  for AFixedKind := Low(FCellSeparatorsBounds) to High(FCellSeparatorsBounds) do
    if not FCellSeparatorsBounds[AFixedKind].IsEmpty then
      FCellSeparatorsBounds[AFixedKind] := TdxRightToLeftLayoutConverter.ConvertRect(FCellSeparatorsBounds[AFixedKind], ABounds);
end;

procedure TcxGridDataRowViewInfo.DoToggleExpanded;
begin
  if (GridView.MasterRowDblClickAction = dcaSwitchExpandedState) and GridView.IsMaster then
    inherited DoToggleExpanded
  else
    GridRecord.ToggleEditFormVisibility;
end;

function TcxGridDataRowViewInfo.FindCellViewInfo(AItem: TcxCustomGridColumn): TcxGridTableDataCellViewInfo;
begin
  if InplaceEditFormAreaViewInfo <> nil then
    Result := InplaceEditFormAreaViewInfo.FindCellViewInfo(AItem)
  else
    if LayoutViewInfo <> nil then
      Result := LayoutViewInfo.FindCellViewInfo(AItem)
    else
      Result := FindCellViewInfoInTableRow(AItem);
end;

function TcxGridDataRowViewInfo.GetAutoHeight: Boolean;
begin
  Result := RecordsViewInfo.AutoDataRecordHeight and not ShowInplaceEditForm;
end;

function TcxGridDataRowViewInfo.GetBackgroundBitmapBounds: TRect;
begin
  Result := inherited GetBackgroundBitmapBounds;
  if HasPreview and (FPreviewViewInfo.BackgroundBitmap <> nil) then
    with CellsAreaBounds do
    begin
      Result.Top := Top;
      Result.Bottom := Bottom;
    end;
end;

function TcxGridDataRowViewInfo.GetBaseHeight: Integer;
begin
  Result := inherited GetBaseHeight;
  if HasPreview then
    Dec(Result, PreviewViewInfo.Height);
  if InplaceEditFormAreaViewInfo <> nil then
    Dec(Result, InplaceEditFormAreaViewInfo.Height);
end;

function TcxGridDataRowViewInfo.GetBottomPartHeight: Integer;
begin
  Result := inherited GetBottomPartHeight;
  if ShowFixedOnTopRowsSeparator then
    Inc(Result, GetFixedRowsSeparatorWidth);
end;

function TcxGridDataRowViewInfo.GetCellsAreaHeight: Integer;
begin
  Result := RecordsViewInfo.DataRowHeight;
end;

function TcxGridDataRowViewInfo.GetFixedRowsSeparatorBounds: TRect;
begin
  Result := Bounds;
  if ShowFixedOnTopRowsSeparator then
    Result.Top := Result.Bottom - GetFixedRowsSeparatorWidth
  else
    Result.Bottom := Result.Top + GetFixedRowsSeparatorWidth;
end;

function TcxGridDataRowViewInfo.GetFixedRowsSeparatorWidth: Integer;
begin
  Result := GridView.FixedDataRows.SeparatorWidth;
end;

function TcxGridDataRowViewInfo.GetHotTrack: Boolean;
begin
  Result := inherited GetHotTrack or (GridView.FixedDataRows.PinVisibility = rpvRowHotTrack);
end;

function TcxGridDataRowViewInfo.GetInplaceEditFormLeftPosition: Integer;
begin
  if GridViewInfo.IsRightToLeftConverted then
    if (GridViewInfo.Bounds.Right - GridViewInfo.IndicatorViewInfo.Width) < (RecordsViewInfo.ContentBounds.Right - DataRelativeIndent) then
      Result := Bounds.Left + Bounds.Right - GridViewInfo.Bounds.Right + GridViewInfo.IndicatorViewInfo.Width
    else
      Result := Bounds.Left + DataRelativeIndent
  else
  begin
    if Calculated then
      Result := DataIndent
    else
      Result := RecordsViewInfo.ContentBounds.Left + DataIndent;
    Result := Max(Result, GridViewInfo.Bounds.Left + GridViewInfo.IndicatorViewInfo.Width);
  end;
end;

function TcxGridDataRowViewInfo.GetInplaceEditFormTopPosition: Integer;
begin
  if HasPreview and (PreviewViewInfo.Preview.Place = ppBottom) then
    Result := PreviewViewInfo.Bounds.Bottom
  else
    Result := FCellsAreaBounds.Bottom;
end;

function TcxGridDataRowViewInfo.GetPainterClass: TcxCustomGridCellPainterClass;
begin
  Result := TcxGridDataRowPainter;
end;

function TcxGridDataRowViewInfo.GetRowLayoutBackgroundRegion: TcxRegion;
begin
  Result := TcxRegion.Create(LayoutViewInfo.Bounds);
end;

function TcxGridDataRowViewInfo.GetSeparatorBounds: TRect;
begin
  Result := inherited GetSeparatorBounds;
  if ShowFixedOnTopRowsSeparator then
    Result := cxRectOffset(Result, 0, GetFixedRowsSeparatorWidth, False);
end;

function TcxGridDataRowViewInfo.GetTopPartHeight: Integer;
begin
  Result := inherited GetTopPartHeight;
  if ShowFixedOnBottomRowsSeparator then
    Inc(Result, GetFixedRowsSeparatorWidth);
end;

procedure TcxGridDataRowViewInfo.GetViewParams(var AParams: TcxViewParams);
begin
  GridView.Styles.GetViewParams(0, nil, nil, AParams);
end;

function TcxGridDataRowViewInfo.GetVisualLevel: Integer;
begin
  if FixedState <> rfsNotFixed then
    Result := 0
  else
    Result := inherited GetVisualLevel;
end;

function TcxGridDataRowViewInfo.HasRowLayoutBackground: Boolean;
begin
  Result := (LayoutViewInfo <> nil) and not Transparent;
end;

function TcxGridDataRowViewInfo.IsCellIndexValid(AIndex: Integer): Boolean;
begin
  Result := (AIndex >= 0) and (AIndex < CellViewInfoCount)
end;

function TcxGridDataRowViewInfo.IsChildrenHotTracked: Boolean;
var
  I: Integer;
begin
  Result := inherited IsChildrenHotTracked or HasPreview and PreviewViewInfo.IsHotTracked;
  if Result then
    Exit;
  if LayoutViewInfo <> nil then
    Result := LayoutViewInfo.IsHotTracked
  else
    for I := 0 to CellViewInfoCount - 1 do
    begin
      Result := CellViewInfos[I].IsHotTracked;
      if Result then
        Exit;
    end;
end;

function TcxGridDataRowViewInfo.NeedToggleExpandRecord(AHitTest: TcxCustomGridHitTest;
  AButton: TMouseButton; AShift: TShiftState): Boolean;
begin
  Result := inherited NeedToggleExpandRecord(AHitTest, AButton, AShift) and
    ((InplaceEditFormAreaViewInfo = nil) or not (AHitTest.ViewInfo is TcxGridTableViewInplaceEditFormDataCellViewInfo));
end;

procedure TcxGridDataRowViewInfo.Offset(DX, DY: Integer);

  procedure OffsetCells;
  var
    I: Integer;
    ACellViewInfo: TcxGridDataCellViewInfo;
  begin
    for I := 0 to CellViewInfoCount - 1 do
    begin
      ACellViewInfo := InternalCellViewInfos[I];
      if IsCellVisible(I) then
        if (ACellViewInfo = nil) or not ACellViewInfo.Calculated then
          CalculateCellViewInfo(I)
        else
          ACellViewInfo.DoOffset(DX, DY)
      else
        if (DX <> 0) and (ACellViewInfo <> nil) then
        begin
          ACellViewInfo.Free;
          FCellViewInfos[I] := nil;
        end;
    end;
  end;

begin
  inherited;
  OffsetRect(FCellsAreaBounds, DX, DY);
  OffsetAreaSeapratorBounds(DX, DY);
  if LayoutViewInfo <> nil then
    LayoutViewInfo.Offset(DX, DY)
  else
    if CellsAreaViewInfo <> nil then
    begin
      OffsetCells;
      CellsAreaViewInfo.DoOffset(DX, DY);
    end;
  if FPreviewViewInfo <> nil then
    FPreviewViewInfo.DoOffset(DX, DY);
  if InplaceEditFormAreaViewInfo <> nil then
  begin
    CalculateInplaceEditForm;
    CalculateTableRowEmptyAreaBounds;
    if GridViewInfo.IsRightToLeftConverted then
    begin
      InplaceEditFormAreaViewInfo.RightToLeftConversion(Bounds);
      FEmptyAreaBounds := TdxRightToLeftLayoutConverter.ConvertRect(FEmptyAreaBounds, Bounds);
    end;
  end;
end;

procedure TcxGridDataRowViewInfo.OffsetAreaSeapratorBounds(DX, DY: Integer);
var
  AFixedKind: TcxGridColumnFixedKind;
begin
  for AFixedKind := Low(FCellSeparatorsBounds) to High(FCellSeparatorsBounds) do
    if not FCellSeparatorsBounds[AFixedKind].IsEmpty then
      OffsetRect(FCellSeparatorsBounds[AFixedKind], DX, DY);
end;

procedure TcxGridDataRowViewInfo.ResetCellSeparatorBounds;
var
  AFixedKind: TcxGridColumnFixedKind;
begin
  for AFixedKind := Low(FCellSeparatorsBounds) to High(FCellSeparatorsBounds) do
    FCellSeparatorsBounds[AFixedKind] := cxEmptyRect;
end;

procedure TcxGridDataRowViewInfo.ResetChildrenState;
var
  I: Integer;
begin
  inherited ResetChildrenState;
  if HasPreview then
    PreviewViewInfo.ResetState;
  if LayoutViewInfo <> nil then
    LayoutViewInfo.ResetState
  else
    for I := 0 to CellViewInfoCount - 1 do
      CellViewInfos[I].ResetState;
end;

procedure TcxGridDataRowViewInfo.SetRowHeight(Value: Integer);
begin
  if RowHeight <> Value then
    GridView.OptionsView.DataRowHeight := Value - NonBaseHeight;
end;

function TcxGridDataRowViewInfo.ShowFixedOnTopRowsSeparator: Boolean;
begin
  Result := (FixedState = rfsFixedToTop) and (GridRecord.Index = GridView.ViewData.FixedTopRowCount - 1);
end;

function TcxGridDataRowViewInfo.ShowDataCells: Boolean;
begin
  Result := not GridRecord.EditFormVisible or (GridView.OptionsBehavior.EditMode <> emInplaceEditFormHideCurrentRow);
end;

function TcxGridDataRowViewInfo.ShowFixedOnBottomRowsSeparator: Boolean;
begin
  Result := (FixedState = rfsFixedToBottom) and (GridRecord.Index = GridView.ViewData.RecordCount - GridView.ViewData.FixedBottomRowCount);
end;

function TcxGridDataRowViewInfo.ShowFixedRowsSeparator: Boolean;
begin
  Result := ShowFixedOnBottomRowsSeparator or ShowFixedOnTopRowsSeparator;
end;

function TcxGridDataRowViewInfo.ShowInplaceEditForm: Boolean;
begin
  Result := GridRecord.EditFormVisible and (GridView.OptionsBehavior.EditMode <> emModalEditForm);
end;

function TcxGridDataRowViewInfo.ShowLayout: Boolean;
begin
  Result := GridView.RowLayout.Active;
end;

function TcxGridDataRowViewInfo.ShowPin: Boolean;
begin
  Result := GridView.FixedDataRows.PinVisibility <> rpvNever;
end;

function TcxGridDataRowViewInfo.ShowPreview: Boolean;
begin
  Result := GridView.Preview.Active;
end;

function TcxGridDataRowViewInfo.GetCellHeight(ACell: TcxGridDataCellViewInfo): Integer;
var
  AIndex: Integer;
begin
  AIndex := ACell.Item.VisibleIndex;
  if CellViewInfos[AIndex].IsMerging then
    Result := InternalCellViewInfos[AIndex].Height
  else
    Result := GridViewInfo.GetCellHeight(AIndex, FCellHeight);
end;

function TcxGridDataRowViewInfo.GetCellHeightValue: Integer;
begin
  if AutoHeight then
  begin
    Result := DataHeight;
    if HasPreview then
      Dec(Result, PreviewViewInfo.Height);
    if InplaceEditFormAreaViewInfo <> nil then
      Dec(Result, InplaceEditFormAreaViewInfo.Height);
  end
  else
    Result := RecordsViewInfo.RowHeight;
end;

function TcxGridDataRowViewInfo.GetCellLeftBound(ACell: TcxGridDataCellViewInfo): Integer;
var
  AColumnHeader: TcxGridColumnHeaderViewInfoAccess;
begin
  AColumnHeader := TcxGridColumnHeaderViewInfoAccess(GridViewInfo.HeaderViewInfo[ACell.Item.VisibleIndex]);
  if IsSpecial or (FixedState <> rfsNotFixed) then
    Result := AColumnHeader.RealBounds.Left
  else
    Result := AColumnHeader.DataOffset;
  if (bLeft in ACell.GetBorders) and (bLeft in AColumnHeader.HiddenBorders) then
    Dec(Result, AColumnHeader.BorderSize[bLeft]);
end;

function TcxGridDataRowViewInfo.GetCellTopBound(ACell: TcxGridDataCellViewInfo): Integer;
begin
  Result := FCellsAreaBounds.Top + GridViewInfo.GetCellTopOffset(ACell.Item.VisibleIndex, FCellHeight);
end;

function TcxGridDataRowViewInfo.GetCellsAreaBounds: TRect;
begin
  Result.Left := DataIndent;
  Result.Right := Result.Left + DataWidth;
  Result.Top := ContentBounds.Top;
  Result.Bottom := ContentBounds.Bottom;
  if HasPreview then
    if PreviewViewInfo.Preview.Place = ppTop then
      Inc(Result.Top, PreviewViewInfo.Height)
    else
      Dec(Result.Bottom, PreviewViewInfo.Height);
  if InplaceEditFormAreaViewInfo <> nil then
    Dec(Result.Bottom, InplaceEditFormAreaViewInfo.Height);
end;

function TcxGridDataRowViewInfo.GetCellsAreaViewInfoClass: TcxGridDataRowCellsAreaViewInfoClass;
begin
  Result := TcxGridDataRowCellsAreaViewInfoClass(RecordsViewInfo.GetDataRowCellsAreaViewInfoClass);
end;

function TcxGridDataRowViewInfo.GetCellViewInfoClass(AIndex: Integer): TcxGridDataCellViewInfoClass;
begin
  Result := TcxGridDataCellViewInfo;
end;

function TcxGridDataRowViewInfo.GetCellWidth(ACell: TcxGridDataCellViewInfo): Integer;
var
  AColumnHeader: TcxGridColumnHeaderViewInfoAccess;
begin
  AColumnHeader := TcxGridColumnHeaderViewInfoAccess(GridViewInfo.HeaderViewInfo[ACell.Item.VisibleIndex]);
  if IsSpecial or (FixedState <> rfsNotFixed) then
    Result := AColumnHeader.Width
  else
    Result := AColumnHeader.RealWidth;
  if (bLeft in AColumnHeader.HiddenBorders) and (bLeft in ACell.GetBorders) then
    Inc(Result, AColumnHeader.BorderSize[bLeft]);
  if not UseLightBorders then
  begin
    if not (bRight in AColumnHeader.HiddenBorders) and not (bRight in ACell.GetBorders) and
      not (GridViewInfo.GridLines in [glNone, glHorizontal]) then
        Dec(Result, AColumnHeader.BorderSize[bRight]);
  end
  else
  begin
    if not (bRight in AColumnHeader.HiddenBorders) and not (bRight in ACell.GetBorders) and
      not (GridViewInfo.GridLines in [glNone, glHorizontal]) and not AColumnHeader.ExcludeRightBorder then
        Dec(Result, AColumnHeader.BorderSize[bRight]);
  end;
end;

function TcxGridDataRowViewInfo.GetDataWidth: Integer;
begin
  if InplaceEditFormAreaViewInfo <> nil then
    Result := RecordsViewInfo.RowWidth - LevelIndent
  else
    Result := inherited GetDataWidth;
end;

function TcxGridDataRowViewInfo.GetInplaceEditFormAreaViewInfoClass: TcxGridInplaceEditFormAreaViewInfoClass;
begin
  Result := TcxGridInplaceEditFormAreaViewInfo;
end;

function TcxGridDataRowViewInfo.GetPreviewViewInfoClass: TcxGridPreviewCellViewInfoClass;
begin
  Result := TcxGridPreviewCellViewInfo;
end;

function TcxGridDataRowViewInfo.GetWidth: Integer;

  function InternalGetWidth: Integer;
  var
    AIndicatorWidth, ADelta: Integer;
  begin
    AIndicatorWidth := 0;
    if GridViewInfo.IndicatorViewInfo.Visible then
      AIndicatorWidth := GridViewInfo.IndicatorViewInfo.IndicatorAreaWidth;
    Result := GridViewInfo.Bounds.Right;
    if GridViewInfo.IsRightToLeftConverted then
      Result := Result - GridViewInfo.Bounds.Left - AIndicatorWidth
    else
      if cxRectIsEmpty(Bounds) then
      begin
        Result := Result - GridViewInfo.Bounds.Left;
        Dec(Result, AIndicatorWidth);
      end
      else
        Result := Result - Bounds.Left;

    if GridViewInfo.IsRightToLeftConverted then
      ADelta := RecordsViewInfo.ContentBounds.Left - GridViewInfo.Bounds.Left
    else
      ADelta := GridViewInfo.Bounds.Right - RecordsViewInfo.ContentBounds.Right;

    if ADelta > 0 then
      Dec(Result, Min(TcxGridTableViewAccess(GridView).GetVerticalScrollBarAreaWidth, ADelta));
  end;

begin
  if InplaceEditFormAreaViewInfo <> nil then
    Result := Max(InternalGetWidth, RecordsViewInfo.RowWidth)
  else
    Result := inherited GetWidth;
end;

function TcxGridDataRowViewInfo.HasFocusRect: Boolean;
begin
  Result := inherited HasFocusRect and (InplaceEditFormAreaViewInfo = nil) and (LayoutViewInfo = nil) and
    not (TcxGridTableControllerAccess(Controller).IsMultiSelectPersistent and GridRecord.CanFocusCells and not IsSpecial);
end;

function TcxGridDataRowViewInfo.HasFooters: Boolean;
begin
  Result := inherited HasFooters and (FixedState = rfsNotFixed);
end;

function TcxGridDataRowViewInfo.IsCellVisible(AIndex: Integer): Boolean;
begin
  Result := GridViewInfo.HeaderViewInfo[AIndex].Visible;
end;

procedure TcxGridDataRowViewInfo.BeforeCellRecalculation(ACell: TcxGridTableCellViewInfo);
begin
//do nothing
end;

procedure TcxGridDataRowViewInfo.BeforeRecalculation;
var
  I: Integer;
begin
  inherited BeforeRecalculation;
  if LayoutViewInfo <> nil then
    LayoutViewInfo.BeforeRecalculation
  else
    if CellsAreaViewInfo <> nil then
    begin
      CellsAreaViewInfo.BeforeRecalculation;
      for I := 0 to CellViewInfoCount - 1 do
        if InternalCellViewInfos[I] <> nil then
          InternalCellViewInfos[I].BeforeRecalculation;
    end;
  if PreviewViewInfo <> nil then
    PreviewViewInfo.BeforeRecalculation;
  if InplaceEditFormAreaViewInfo <> nil then
    InplaceEditFormAreaViewInfo.BeforeRecalculation;
end;

procedure TcxGridDataRowViewInfo.Calculate(ALeftBound, ATopBound: Integer;
  AWidth: Integer = -1; AHeight: Integer = -1);
begin
  inherited Calculate(ALeftBound, ATopBound, AWidth, AHeight);
  ResetCellSeparatorBounds;
  FCellsAreaBounds := CellsAreaBounds;
  if HasPreview then
    CalculatePreview(ATopBound);
  if InplaceEditFormAreaViewInfo <> nil then
    CalculateInplaceEditForm;
  if LayoutViewInfo <> nil then
    LayoutViewInfo.Calculate(FCellsAreaBounds.Left, FCellsAreaBounds.Top)
  else
    if CellsAreaViewInfo <> nil then
    begin
      FCellHeight := CellHeight;
      CalculateCells;
      CalculateCellSeparators;
      if FCellsAreaViewInfo.Visible then
        FCellsAreaViewInfo.Calculate(FCellsAreaBounds);
      if InplaceEditFormAreaViewInfo <> nil then
        CalculateTableRowEmptyAreaBounds;
    end;
end;

procedure TcxGridDataRowViewInfo.CalculateInPlace(ALeft, ATop: Integer);
var
  AIndicatorWidth: Integer;
  X, ADelta: Integer;
begin
  if GridViewInfo.IsRightToLeftConverted and (InplaceEditFormAreaViewInfo <> nil) then
  begin
    ADelta := RecordsViewInfo.ContentBounds.Left - GridViewInfo.Bounds.Left;
    if ADelta > TcxGridTableViewAccess(GridView).GetVerticalScrollBarAreaWidth then
    begin
      AIndicatorWidth := 0;
      if GridViewInfo.IndicatorViewInfo.Visible then
        AIndicatorWidth := GridViewInfo.IndicatorViewInfo.IndicatorAreaWidth;

      X := GridViewinfo.Bounds.Right - RecordsViewInfo.ContentBounds.Right - AIndicatorWidth + GridViewinfo.Bounds.Left;

      Inc(X, Min(TcxGridTableViewAccess(GridView).GetVerticalScrollBarAreaWidth, ADelta));

      MainCalculate(X, ATop);
      RightToLeftConversion(Bounds);
    end
    else
      inherited CalculateInPlace(ALeft, ATop);
  end
  else
    inherited CalculateInPlace(ALeft, ATop);
end;

procedure TcxGridDataRowViewInfo.DoRightToLeftConversion(const ABounds: TRect);
var
  I: Integer;
begin
  inherited DoRightToLeftConversion(ABounds);
  if CellsAreaViewInfo <> nil then
    FCellsAreaBounds := TdxRightToLeftLayoutConverter.ConvertRect(FCellsAreaBounds, ABounds);
  if HasPreview then
    PreviewViewInfo.RightToLeftConversion(ABounds);
  if InplaceEditFormAreaViewInfo <> nil then
    InplaceEditFormAreaViewInfo.RightToLeftConversion(ABounds);
  if LayoutViewInfo <> nil then
    LayoutViewInfo.RightToLeftConversion(ABounds);
  for I := 0 to CellViewInfoCount - 1 do
    if IsCellVisible(I) then
      CellViewInfos[I].RightToLeftConversion(ABounds);
  if (FCellsAreaViewInfo <> nil) and FCellsAreaViewInfo.Visible then
    FCellsAreaViewInfo.RightToLeftConversion(ABounds);
  if (InplaceEditFormAreaViewInfo <> nil) and (CellsAreaViewInfo <> nil) then
    FEmptyAreaBounds := TdxRightToLeftLayoutConverter.ConvertRect(FEmptyAreaBounds, ABounds);
  if not GridViewInfo.IsRightToLeftConverted then
    DoCellSeparatorBoundsRightToLeftConversion(ABounds);
end;

function TcxGridDataRowViewInfo.GetAreaBoundsForPainting: TRect;
begin
  Result := inherited GetAreaBoundsForPainting;
  ApplyMergingCellsBounds(Result);
end;

function TcxGridDataRowViewInfo.GetBoundsForInvalidate(AItem: TcxCustomGridTableItem): TRect;
begin
  Result := inherited GetBoundsForInvalidate(AItem);
  if AItem = nil then
    ApplyMergingCellsBounds(Result);
  ApplyMergedCellsBounds(Result, AItem);
end;

function TcxGridDataRowViewInfo.GetBoundsForItem(AItem: TcxCustomGridTableItem): TRect;
var
  ACell: TcxGridTableDataCellViewInfo;
begin
  if InplaceEditFormAreaViewInfo <> nil then
    ACell := InplaceEditFormAreaViewInfo.GridItemViewInfos.FindCellViewInfo(AItem)
  else
    if LayoutViewInfo <> nil then
      ACell := LayoutViewInfo.ItemViewInfos.FindCellViewInfo(AItem)
    else
      ACell := InternalCellViewInfos[AItem.VisibleIndex];
  if ACell <> nil then
    Result := ACell.Bounds
  else
    Result := inherited GetBoundsForItem(AItem);
end;

function TcxGridDataRowViewInfo.GetCellBorders(AIsRight, AIsBottom: Boolean): TcxBorders;
begin
  Result := GridViewInfo.GetCellBorders(AIsRight, AIsBottom);
end;

function TcxGridDataRowViewInfo.GetCellViewInfoByItem(AItem: TcxCustomGridTableItem): TcxGridTableDataCellViewInfo;
var
  AColumn: TcxCustomGridColumn absolute AItem;
begin
  if AColumn.IsPreview then
    Result := FPreviewViewInfo
  else
    Result := FindCellViewInfo(AColumn);
end;

function TcxGridDataRowViewInfo.GetHitTest(const P: TPoint): TcxCustomGridHitTest;
var
  AHitTest: TcxCustomGridHitTest;
begin
  Result := inherited GetHitTest(P);
  if (Result = nil) or (Result.ClassType <> GetHitTestClass) then
    Exit;
  if LayoutViewInfo <> nil then
    AHitTest := LayoutViewInfo.GetHitTest(P)
  else
    AHitTest := RecordsViewInfo.GetDataRowCellsHitTest(P, Self);
  if AHitTest <> nil then
  begin
    Result := AHitTest;
    Exit;
  end;
  if HasPreview then
  begin
    AHitTest := FPreviewViewInfo.GetHitTest(P);
    if AHitTest <> nil then
    begin
      Result := AHitTest;
      Exit;
    end;
  end;
  if InplaceEditFormAreaViewInfo <> nil then
  begin
    AHitTest := InplaceEditFormAreaViewInfo.GetHitTest(P);
    if AHitTest <> nil then
    begin
      Result := AHitTest;
      Exit;
    end;
  end;
end;

function TcxGridDataRowViewInfo.GetInplaceEditFormClientBounds: TRect;
begin
  if InplaceEditFormAreaViewInfo <> nil then
    Result := InplaceEditFormAreaViewInfo.GetInplaceEditFormClientBounds
  else
    Result := cxEmptyRect;
end;

function TcxGridDataRowViewInfo.IsInplaceEditFormCellPartVisible(ACellViewInfo: TcxGridTableDataCellViewInfo): Boolean;
begin
  Result := not cxRectContain(cxRectInflate(InplaceEditFormAreaViewInfo.Bounds, 0, -1), ACellViewInfo.EditBounds);
end;

procedure TcxGridDataRowViewInfo.CancelInplaceEditFormEditing;
begin
  InplaceEditForm.CancelExecute;
end;

procedure TcxGridDataRowViewInfo.UpdateInplaceEditFormEditing;
begin
  InplaceEditForm.UpdateExecute;
end;

{ TcxGridNewItemRowViewInfo }

function TcxGridNewItemRowViewInfo.CalculateSelected: Boolean;
begin
  Result := GridRecord.Selected;
end;

function TcxGridNewItemRowViewInfo.CanDelayedDrawDataCellBorders: Boolean;
begin
  Result := False;
end;

function TcxGridNewItemRowViewInfo.CanShowDataCellHint: Boolean;
begin
  Result := inherited CanShowDataCellHint and Focused;
end;

function TcxGridNewItemRowViewInfo.GetAlignmentHorz: TAlignment;
begin
  Result := taCenter;
end;

function TcxGridNewItemRowViewInfo.GetAlignmentVert: TcxAlignmentVert;
begin
  Result := vaCenter;
end;

function TcxGridNewItemRowViewInfo.GetAutoHeight: Boolean;
begin
  Result := False;
end;

function TcxGridNewItemRowViewInfo.GetCellHeightValue: Integer;
begin
  Result := RecordsViewInfo.SpecialRowHeight;
end;

function TcxGridNewItemRowViewInfo.GetCellsAreaHeight: Integer;
begin
  Result := RecordsViewInfo.SpecialDataRowHeight;
end;

function TcxGridNewItemRowViewInfo.GetHeight: Integer;
begin
  if FHeight = 0 then
    FHeight := CalculateHeight;
  Result := FHeight;
end;

function TcxGridNewItemRowViewInfo.GetInfoText: string;
begin
  Result := Options.InfoText;
end;

function TcxGridNewItemRowViewInfo.GetOptions: TcxGridSpecialRowOptions;
begin
  Result := GridView.NewItemRow;
end;

function TcxGridNewItemRowViewInfo.GetSeparatorColor: TColor;
begin
  Result := Options.GetSeparatorColor;
end;

function TcxGridNewItemRowViewInfo.GetSeparatorWidth: Integer;
begin
  Result := Options.SeparatorWidth;
end;

function TcxGridNewItemRowViewInfo.GetShowInfoText: Boolean;
begin
  Result := not Focused;
end;

function TcxGridNewItemRowViewInfo.GetStyleIndex: Integer;
begin
  Result := vsNewItemRowInfoText;
end;

function TcxGridNewItemRowViewInfo.GetText: string;
begin
  if ShowInfoText then
    Result := InfoText
  else
    Result := inherited GetText;
end;

function TcxGridNewItemRowViewInfo.GetTextAreaBounds: TRect;
var
  AClientBounds: TRect;
begin
  Result := ContentBounds;
  AClientBounds := GridViewInfo.ClientBounds;
  if IsRightToLeftConverted then
  begin
    Result.Right := AClientBounds.Right;
    if Result.Left < AClientBounds.Left then
      Result.Left := AClientBounds.Left;
  end
  else
  begin
    Result.Left := AClientBounds.Left;
    if Result.Right > AClientBounds.Right then
      Result.Right := AClientBounds.Right;
  end;
end;

procedure TcxGridNewItemRowViewInfo.GetViewParams(var AParams: TcxViewParams);
begin
  GridView.Styles.GetViewParams(GetStyleIndex, GridRecord, nil, AParams);
end;

function TcxGridNewItemRowViewInfo.ShowFixedOnBottomRowsSeparator: Boolean;
begin
  Result := False;
end;

function TcxGridNewItemRowViewInfo.ShowFixedOnTopRowsSeparator: Boolean;
begin
  Result := False;
end;

function TcxGridNewItemRowViewInfo.HasFooters: Boolean;
begin
  Result := False;
end;

function TcxGridNewItemRowViewInfo.HasLastHorzGridLine: Boolean;
begin
  Result := False;
end;

function TcxGridNewItemRowViewInfo.ShowLayout: Boolean;
begin
  Result := False;
end;

function TcxGridNewItemRowViewInfo.ShowPin: Boolean;
begin
  Result := False;
end;

function TcxGridNewItemRowViewInfo.ShowPreview: Boolean;
begin
  Result := False;
end;

function TcxGridNewItemRowViewInfo.GetPainterClass: TcxCustomGridCellPainterClass;
begin
  Result := TcxGridNewItemRowPainter;
end;

function TcxGridNewItemRowViewInfo.GetRealTextAreaBounds: TRect;
begin
  Result := GetTextAreaBounds;
end;

{ TcxGridFilterRowViewInfo }

function TcxGridFilterRowViewInfo.GetCellViewInfoClass(AIndex: Integer): TcxGridDataCellViewInfoClass;
begin
  Result := TcxGridFilterRowCellViewInfo;
end;

function TcxGridFilterRowViewInfo.GetOptions: TcxGridSpecialRowOptions;
begin
  Result := GridView.FilterRow;
end;

function TcxGridFilterRowViewInfo.GetShowInfoText: Boolean;
begin
  Result := inherited GetShowInfoText and GridRecord.IsEmpty and not OperatorCustomization;
end;

function TcxGridFilterRowViewInfo.GetStyleIndex: Integer;
begin
  Result := vsFilterRowInfoText;
end;

function TcxGridFilterRowViewInfo.OperatorCustomization: Boolean;
begin
  Result := Options.OperatorCustomization;
end;

function TcxGridFilterRowViewInfo.ShowInplaceEditForm: Boolean;
begin
  Result := False;
end;

function TcxGridFilterRowViewInfo.GetGridRecord: TcxGridFilterRow;
begin
  Result := TcxGridFilterRow(inherited GridRecord);
end;

function TcxGridFilterRowViewInfo.GetFilterRowOptions: TcxGridFilterRowOptions;
begin
  Result := TcxGridFilterRowOptions(inherited Options);
end;

{ TcxGridMasterDataRowDetailsSiteLeftTabsViewInfo }

function TcxGridMasterDataRowDetailsSiteLeftTabsViewInfo.GetBottomGridLineColor: TColor;
begin
  Result := SiteViewInfo.MasterGridViewInfo.GridLineColor;
end;

function TcxGridMasterDataRowDetailsSiteLeftTabsViewInfo.GetBottomGridLineWidth: Integer;
begin
  Result := SiteViewInfo.MasterGridViewInfo.GridLineWidth;
end;

function TcxGridMasterDataRowDetailsSiteLeftTabsViewInfo.GetSiteViewInfo: TcxGridDetailsSiteViewInfo;
begin
  Result := TcxGridDetailsSiteViewInfo(inherited SiteViewInfo);
end;

function TcxGridMasterDataRowDetailsSiteLeftTabsViewInfo.CalculateHeight: Integer;
begin
  Result := inherited CalculateHeight;
  if HasBottomGridLine then
    Inc(Result, BottomGridLineWidth);
end;

function TcxGridMasterDataRowDetailsSiteLeftTabsViewInfo.GetBoundsRect: TRect;
begin
  Result := inherited GetBoundsRect;
  if HasBottomGridLine then
    Dec(Result.Bottom, BottomGridLineWidth);
end;

function TcxGridMasterDataRowDetailsSiteLeftTabsViewInfo.GetBottomGridLineBounds: TRect;
begin
  Result := Bounds;
  Result.Top := Result.Bottom - BottomGridLineWidth;
end;

function TcxGridMasterDataRowDetailsSiteLeftTabsViewInfo.GetPainterClass: TcxCustomGridCellPainterClass;
begin
  Result := TcxGridMasterDataRowDetailsSiteTabsPainter;
end;

function TcxGridMasterDataRowDetailsSiteLeftTabsViewInfo.HasBottomGridLine: Boolean;
begin
  Result := bBottom in SiteViewInfo.MasterGridViewInfo.GetCellBorders(False, True);
end;

{ TcxGridDetailsSiteViewInfo }

constructor TcxGridDetailsSiteViewInfo.Create(AMasterDataRowViewInfo: TcxGridMasterDataRowViewInfo);
begin
  FMasterDataRowViewInfo := AMasterDataRowViewInfo;
  inherited Create(TcxGridLevel(FMasterDataRowViewInfo.GridView.Level));
  if CacheItem.IsDetailsSiteCachedInfoAssigned then
    SetCachedInfo(CacheItem.DetailsSiteCachedInfo);
end;

destructor TcxGridDetailsSiteViewInfo.Destroy;
begin
  if not MasterGridViewInfo.IsInternalUse and (CacheItem <> nil) then
  begin
    if CacheItem.IsDetailsSiteCachedInfoAssigned then
      raise EdxException.Create('CacheItem.IsDetailsSiteCachedInfoAssigned');  //!!!
    GetCachedInfo(CacheItem.DetailsSiteCachedInfo);
  end;
  inherited;
end;

function TcxGridDetailsSiteViewInfo.GetCacheItem: TcxGridMasterTableViewInfoCacheItem;
begin
  Result := FMasterDataRowViewInfo.CacheItem;
end;

function TcxGridDetailsSiteViewInfo.GetMasterGridView: TcxGridTableView;
begin
  Result := FMasterDataRowViewInfo.GridView;
end;

function TcxGridDetailsSiteViewInfo.GetMasterGridViewInfo: TcxGridTableViewInfo;
begin
  Result := FMasterDataRowViewInfo.GridViewInfo;
end;

procedure TcxGridDetailsSiteViewInfo.ControlFocusChanged;
begin
  if ActiveGridViewExists then
    ActiveGridView.Controller.ControlFocusChanged;
end;

function TcxGridDetailsSiteViewInfo.GetActiveGridView: TcxCustomGridView;
begin
  Result := FMasterDataRowViewInfo.GridRecord.ActiveDetailGridView;
  if Result <> nil then
    Result.CheckSynchronizationAssignNeeded;
end;

function TcxGridDetailsSiteViewInfo.GetActiveGridViewExists: Boolean;
var
  AMasterGridRecord: TcxGridMasterDataRow;
begin
  Result := inherited GetActiveGridViewExists;
  if not Result and not IsActiveGridViewDestroying and not (csDestroying in ComponentState) then
  begin
    AMasterGridRecord := FMasterDataRowViewInfo.GridRecord;
    Result :=
      (AMasterGridRecord <> nil) and AMasterGridRecord.ActiveDetailGridViewExists and
      not AMasterGridRecord.ActiveDetailGridView.IsDestroying;
  end;
end;

function TcxGridDetailsSiteViewInfo.GetActiveGridViewValue: TcxCustomGridView;
begin
  Result := inherited GetActiveGridViewValue;
  if (Result <> nil) and (Result.ViewInfo <> nil) then
    Result.ViewInfo.IsInternalUse := MasterGridViewInfo.IsInternalUse;
end;

function TcxGridDetailsSiteViewInfo.GetActiveLevel: TcxGridLevel;
begin
  Result := FMasterDataRowViewInfo.GridRecord.ActiveDetailLevel;
end;

function TcxGridDetailsSiteViewInfo.GetCanvas: TcxCanvas;
begin
  Result := MasterGridViewInfo.Canvas;
end;

function TcxGridDetailsSiteViewInfo.GetContainer: TcxControl;
begin
  Result := MasterGridViewInfo.Site;
end;

function TcxGridDetailsSiteViewInfo.GetDesignController: TcxCustomGridDesignController;
begin
  Result := MasterGridView.Controller.DesignController;
end;

function TcxGridDetailsSiteViewInfo.GetFullyVisible: Boolean;
begin
  if CacheItem.IsDetailsSiteFullyVisibleAssigned then
    Result := CacheItem.DetailsSiteFullyVisible
  else
  begin
    Result := inherited GetFullyVisible;
    CacheItem.DetailsSiteFullyVisible := Result;
  end;  
end;

function TcxGridDetailsSiteViewInfo.GetHeight: Integer;
begin
  if CacheItem.IsDetailsSiteHeightAssigned then
    Result := CacheItem.DetailsSiteHeight
  else
  begin
    Result := inherited GetHeight;
    CacheItem.DetailsSiteHeight := Result;
  end;
end;

function TcxGridDetailsSiteViewInfo.GetMasterRecord: TObject;
begin
  Result := MasterDataRowViewInfo.GridRecord;
end;

function TcxGridDetailsSiteViewInfo.GetMaxHeight: Integer;
begin
  if UseOptimalHeight then
    Result := MasterDataRowViewInfo.DetailsSiteOptimalHeight
  else if MasterGridView.UseRestHeightForDetails then
    Result := MasterDataRowViewInfo.RestHeight
  else
    Result := cxMaxRectSize;
  TcxGridLevelAccess.CheckHeight(Level, Result);
end;

function TcxGridDetailsSiteViewInfo.GetMaxNormalHeight: Integer;
begin
  if UseOptimalHeight then
    Result := MaxHeight
  else
  begin
    Result := inherited GetMaxNormalHeight;
    TcxGridLevelAccess.CheckHeight(Level, Result);
  end;
end;

function TcxGridDetailsSiteViewInfo.GetMaxWidth: Integer;
begin
  Result := MasterGridViewInfo.ClientWidth -
    FMasterDataRowViewInfo.LevelIndent;
  if FMasterDataRowViewInfo.HasExpandButtonCell then
    Dec(Result, FMasterDataRowViewInfo.ExpandButtonCellViewInfo.BaseWidth);
  Dec(Result, TcxGridTableViewAccess(MasterGridView).GetVerticalScrollBarAreaWidth);
end;

function TcxGridDetailsSiteViewInfo.GetNormalHeight: Integer;
begin
  if CacheItem.IsDetailsSiteNormalHeightAssigned then
    Result := CacheItem.DetailsSiteNormalHeight
  else
  begin
    Result := inherited GetNormalHeight;
    CacheItem.DetailsSiteNormalHeight := Result;
  end;
end;

function TcxGridDetailsSiteViewInfo.GetTabsViewInfoClass: TcxCustomGridDetailsSiteTabsViewInfoClass;
begin
  if TabsPosition = dtpLeft then
    Result := TcxGridMasterDataRowDetailsSiteLeftTabsViewInfo
  else
    Result := inherited GetTabsViewInfoClass;
end;

function TcxGridDetailsSiteViewInfo.GetVisible: Boolean;
begin
  Result := FMasterDataRowViewInfo.DetailsSiteVisible;
end;

function TcxGridDetailsSiteViewInfo.GetWidth: Integer;
begin
  if CacheItem.IsDetailsSiteWidthAssigned then
    Result := CacheItem.DetailsSiteWidth
  else
  begin
    Result := inherited GetWidth;
    CacheItem.DetailsSiteWidth := Result;
  end;
end;

procedure TcxGridDetailsSiteViewInfo.InitTabHitTest(AHitTest: TcxGridDetailsSiteTabHitTest);
begin
  AHitTest.Owner := MasterDataRowViewInfo.GridRecord;
end;

function TcxGridDetailsSiteViewInfo.UseOptimalHeight: Boolean;
begin
  Result := ActiveGridViewExists and TcxCustomGridViewAccess(ActiveGridView).UseOptimalHeightWhenDetail;
end;

procedure TcxGridDetailsSiteViewInfo.ChangeActiveTab(ALevel: TcxGridLevel;
  AFocusView: Boolean = False);
var
  ARow: TcxGridMasterDataRow;
begin
  ARow := MasterDataRowViewInfo.GridRecord;
  ARow.ActiveDetailIndex := ALevel.Index;
  if AFocusView and (ARow.ActiveDetailGridView <> nil) then
    ARow.ActiveDetailGridView.Focused := True;
end;

function TcxGridDetailsSiteViewInfo.DetailHasData(ALevel: TcxGridLevel): Boolean;
begin
  Result := TcxGridMasterDataRow(MasterRecord).DetailGridViewHasData[ALevel.Index];
end;

function TcxGridDetailsSiteViewInfo.HasMaxHeight: Boolean;
begin
  Result := (Level.MaxDetailHeight <> 0) and (Height = Level.MaxDetailHeight);
end;

function TcxGridDetailsSiteViewInfo.SupportsTabAccelerators: Boolean;
begin
  Result := MasterDataRowViewInfo.SupportsTabAccelerators;
end;

{ TcxGridMasterDataRowLayoutViewInfo }

function TcxGridMasterDataRowLayoutViewInfo.CalculateWidth: Integer;
begin
  Result := inherited CalculateWidth;
  if RecordViewInfo.Calculated then
    Dec(Result, GridViewInfo.LevelIndent);
end;

{ TcxGridExpandButtonCellViewInfo }

function TcxGridExpandButtonCellViewInfo.CanDrawHotTracked: Boolean;
begin
  Result := False;
end;

function TcxGridExpandButtonCellViewInfo.GetRecordViewInfo: TcxGridMasterDataRowViewInfo;
begin
  Result := TcxGridMasterDataRowViewInfo(inherited RecordViewInfo);
end;

function TcxGridExpandButtonCellViewInfo.GetRightBorderRestSpaceBounds: TRect;
begin
  if IsRightToLeftConverted then
    Result := inherited GetBorderBounds(bLeft)
  else
    Result := inherited GetBorderBounds(bRight);
  Result.Bottom := BorderBounds[bRight].Top;
end;

function TcxGridExpandButtonCellViewInfo.CalculateHeight: Integer;
begin
  Result := RecordViewInfo.DataHeight;
  if RecordViewInfo.DetailsSiteVisible then
    Inc(Result, RecordViewInfo.DetailsAreaViewInfo.CalculateHeight);
end;

function TcxGridExpandButtonCellViewInfo.CalculateWidth: Integer;
begin
  if GridViewInfo.IsRightToLeftConverted then
    Result := RecordViewInfo.GetExpandButtonAreaBounds.Width
  else
    Result := GridViewInfo.ClientBounds.Left + RecordViewInfo.LevelIndent +
      BaseWidth - RecordViewInfo.ContentIndent;
end;

function TcxGridExpandButtonCellViewInfo.GetBackgroundBitmap: TBitmap;
begin
  Result := RecordViewInfo.BackgroundBitmap;
end;

function TcxGridExpandButtonCellViewInfo.GetBaseWidth: Integer;
begin
  Result := GridViewInfo.LevelIndent;
end;

function TcxGridExpandButtonCellViewInfo.GetBorderBounds(AIndex: TcxBorder): TRect;
begin
  Result := inherited GetBorderBounds(AIndex);
  if AIndex = bRight then
  begin
    Inc(Result.Top, RecordViewInfo.DataHeight);
    if bBottom in Borders then
      Dec(Result.Top, BorderWidth[bBottom]);
  end;
end;

function TcxGridExpandButtonCellViewInfo.GetBorders: TcxBorders;
begin
  Result := GridViewInfo.GetCellBorders(False, True);
  if RecordViewInfo.Expanded and (bBottom in Result) then
    Include(Result, bRight)
  else
    Exclude(Result, bRight);
end;

function TcxGridExpandButtonCellViewInfo.GetPainterClass: TcxCustomGridCellPainterClass;
begin
  Result := TcxGridExpandButtonCellPainter;
end;

{ TcxGridDetailsAreaViewInfo }

function TcxGridDetailsAreaViewInfo.GetRecordViewInfo: TcxGridMasterDataRowViewInfo;
begin
  Result := TcxGridMasterDataRowViewInfo(inherited RecordViewInfo);
end;

function TcxGridDetailsAreaViewInfo.CalculateHeight: Integer;
begin
  Result := RecordViewInfo.DetailsSiteViewInfo.Height;
end;

function TcxGridDetailsAreaViewInfo.CalculateWidth: Integer;
begin
  Result := RecordViewInfo.DetailsSiteViewInfo.MaxWidth;
end;

function TcxGridDetailsAreaViewInfo.GetBorders: TcxBorders;
begin
  if GridLines in [glBoth, glHorizontal] then
    Result := [bBottom]
  else
    Result := [];
end;

{ TcxGridMasterDataRowViewInfo }

constructor TcxGridMasterDataRowViewInfo.Create(ARecordsViewInfo: TcxCustomGridRecordsViewInfo;
  ARecord: TcxCustomGridRecord);
begin
  inherited;
  FDetailsSiteVisible := True;
end;

destructor TcxGridMasterDataRowViewInfo.Destroy;
begin
  FExpandButtonCellViewInfo.Free;
  FDetailsSiteViewInfo.Free;
  FDetailsAreaViewInfo.Free;
  inherited;
end;

function TcxGridMasterDataRowViewInfo.GetCacheItem: TcxGridMasterTableViewInfoCacheItem;
begin
  Result := TcxGridMasterTableViewInfoCacheItem(inherited CacheItem);
end;

function TcxGridMasterDataRowViewInfo.GetDetailsAreaViewInfo: TcxGridDetailsAreaViewInfo;
begin
  if (FDetailsAreaViewInfo = nil) and DetailsSiteVisible then
    FDetailsAreaViewInfo := GetDetailsAreaViewInfoClass.Create(Self);
  Result := FDetailsAreaViewInfo;
end;

function TcxGridMasterDataRowViewInfo.GetDetailsSiteIndentBounds: TRect;
begin
  with DetailsSiteViewInfo.Bounds do
    Result := Rect(ContentIndent, Top, Left, Bottom);
end;

function TcxGridMasterDataRowViewInfo.GetDetailsSiteViewInfo: TcxGridDetailsSiteViewInfo;
begin
  if (FDetailsSiteViewInfo = nil) and DetailsSiteVisible then
    FDetailsSiteViewInfo := GetDetailsSiteViewInfoClass.Create(Self);
  Result := FDetailsSiteViewInfo;
end;

function TcxGridMasterDataRowViewInfo.GetExpandButtonCellViewInfo: TcxGridExpandButtonCellViewInfo;
begin
  if (FExpandButtonCellViewInfo = nil) and ShowExpandButtonCell then
    FExpandButtonCellViewInfo := GetExpandButtonCellViewInfoClass.Create(Self);
  Result := FExpandButtonCellViewInfo;
end;

function TcxGridMasterDataRowViewInfo.GetGridRecord: TcxGridMasterDataRow;
begin
  Result := TcxGridMasterDataRow(inherited GridRecord);
end;

procedure TcxGridMasterDataRowViewInfo.CalculateExpandButtonBounds(var ABounds: TRect);
begin
  ABounds := ExpandButtonAreaBounds;
  inherited;
end;

function TcxGridMasterDataRowViewInfo.CalculateHeight: Integer;
begin
  Result := inherited CalculateHeight;
  if DetailsSiteVisible then
  begin
    FRestHeight := CalculateRestHeight(Result);
    Inc(Result, DetailsSiteViewInfo.Height);
  end;
end;

function TcxGridMasterDataRowViewInfo.CalculateRestHeight(ARowHeight: Integer): Integer;
begin
  Result := RecordsViewInfo.GetRestHeight(Bounds.Top) - ARowHeight;
end;

procedure TcxGridMasterDataRowViewInfo.ControlFocusChanged;
begin
  inherited ControlFocusChanged;
  if DetailsSiteVisible then
    DetailsSiteViewInfo.ControlFocusChanged;
end;

function TcxGridMasterDataRowViewInfo.CreateLayoutViewInfo: TcxGridRowLayoutViewInfo;
begin
  Result := TcxGridMasterDataRowLayoutViewInfo.Create(Self);
end;

function TcxGridMasterDataRowViewInfo.GetDataHeight: Integer;
begin
  Result := inherited GetDataHeight;
  if DetailsSiteVisible then
    Dec(Result, DetailsSiteViewInfo.Height);
end;

function TcxGridMasterDataRowViewInfo.GetDataIndent: Integer;
begin
  Result := inherited GetDataIndent + GridViewInfo.LevelIndent;
end;

function TcxGridMasterDataRowViewInfo.GetDataRelativeIndent: Integer;
begin
  Result := inherited GetDataRelativeIndent + GridViewInfo.LevelIndent;
end;

function TcxGridMasterDataRowViewInfo.GetDataWidth: Integer;
begin
  Result := inherited GetDataWidth - GridViewInfo.LevelIndent;
end;

function TcxGridMasterDataRowViewInfo.GetDetailsSiteOptimalHeight: Integer;
var
  AGridView: TcxCustomGridTableView;
begin
  FDetailsSiteVisible := False;
  try
    AGridView := GridView;
    while AGridView.IsDetail do
      AGridView := TcxCustomGridTableView(AGridView.MasterGridView);
    Result := AGridView.ViewInfo.RecordsViewInfo.ContentBounds.Height - DataHeight;
  finally
    FDetailsSiteVisible := True;
  end;
end;

function TcxGridMasterDataRowViewInfo.GetDetailsSiteVisible: Boolean;
begin
  Result := FDetailsSiteVisible and Expanded;
end;

function TcxGridMasterDataRowViewInfo.GetExpandButtonAreaBounds: TRect;
var
  AButtonHeight: Integer;
begin
  AButtonHeight := DataHeight;
  if InplaceEditFormAreaViewInfo <> nil then
    AButtonHeight := AButtonHeight -  cxRectHeight(InplaceEditFormAreaViewInfo.Bounds);
  Result := Rect(ContentIndent, Bounds.Top, DataIndent, Bounds.Top + AButtonHeight);
end;

function TcxGridMasterDataRowViewInfo.GetLastHorzGridLineBounds: TRect;
begin
  Result := inherited GetLastHorzGridLineBounds;
  if DetailsSiteVisible then
  begin
    Result.Right := DetailsSiteViewInfo.Bounds.Left;
    Result.Bottom := DetailsSiteViewInfo.Bounds.Bottom;
    Result.Top := Result.Bottom - GridViewInfo.GridLineWidth;
  end;
end;

function TcxGridMasterDataRowViewInfo.GetMaxHeight: Integer;
begin
  Result := inherited GetMaxHeight;
  if DetailsSiteVisible then
    if not DetailsSiteViewInfo.FullyVisible and not GridViewInfo.CalculateDown and
      (Index > 0) and not DetailsSiteViewInfo.HasMaxHeight then
      Result := cxMaxRectSize
    else
      Result := Result - DetailsSiteViewInfo.Height + DetailsSiteViewInfo.NormalHeight;
end;

function TcxGridMasterDataRowViewInfo.GetPixelScrollSize: Integer;
begin
  Result := MaxHeight;
end;

function TcxGridMasterDataRowViewInfo.GetRowLayoutBackgroundRegion: TcxRegion;
begin
  Result := inherited GetRowLayoutBackgroundRegion;
  if ExpandButtonCellViewInfo <> nil then
    Result.Combine(ExpandButtonCellViewInfo.Bounds, roAdd);
end;

function TcxGridMasterDataRowViewInfo.HasExpandButtonCell: Boolean;
begin
  Result := ExpandButtonCellViewInfo <> nil;
end;

function TcxGridMasterDataRowViewInfo.IsDetailVisible(ADetail: TcxCustomGridView): Boolean;
begin
  Result := DetailsSiteVisible and (DetailsSiteViewInfo <> nil) and
    (DetailsSiteViewInfo.ActiveLevel = ADetail.Level);
end;

function TcxGridMasterDataRowViewInfo.IsFullyVisible: Boolean;
begin
  Result := inherited IsFullyVisible and
    (not DetailsSiteVisible or DetailsSiteViewInfo.HasMaxHeight or DetailsSiteViewInfo.FullyVisible);
end;

procedure TcxGridMasterDataRowViewInfo.VisibilityChanged(AVisible: Boolean);
begin
  inherited VisibilityChanged(AVisible);
  if DetailsSiteVisible then
    DetailsSiteViewInfo.VisibilityChanged(AVisible);
end;

function TcxGridMasterDataRowViewInfo.ShowExpandButtonCell: Boolean;
begin
  Result := FixedState = rfsNotFixed;
end;

function TcxGridMasterDataRowViewInfo.GetPainterClass: TcxCustomGridCellPainterClass;
begin
  Result := TcxGridMasterDataRowPainter;
end;

function TcxGridMasterDataRowViewInfo.GetDetailsAreaViewInfoClass: TcxGridDetailsAreaViewInfoClass;
begin
  Result := TcxGridDetailsAreaViewInfo;
end;

function TcxGridMasterDataRowViewInfo.GetDetailsSiteViewInfoClass: TcxGridDetailsSiteViewInfoClass;
begin
  Result := TcxGridDetailsSiteViewInfo;
end;

function TcxGridMasterDataRowViewInfo.GetExpandButtonCellViewInfoClass: TcxGridExpandButtonCellViewInfoClass;
begin
  Result := TcxGridExpandButtonCellViewInfo;
end;

procedure TcxGridMasterDataRowViewInfo.BeforeRecalculation;
begin
  inherited;
  if DetailsSiteVisible then
  begin
    DetailsSiteViewInfo.BeforeRecalculation;
    DetailsAreaViewInfo.BeforeRecalculation;
  end;
  if HasExpandButtonCell then
    ExpandButtonCellViewInfo.BeforeRecalculation;
end;

procedure TcxGridMasterDataRowViewInfo.Calculate(ALeftBound, ATopBound: Integer;
  AWidth: Integer = -1; AHeight: Integer = -1);
var
  ADetailLeftBound, ADetailTopBound: Integer;

  function NeedCalculateDetail: Boolean;
  begin
    Result := DetailsSiteVisible and
      (GridViewInfo.IsCalculating or
        DetailsSiteViewInfo.ActiveGridViewExists and
          (DetailsSiteViewInfo.ActiveGridView.Site.Left = cxInvisibleCoordinate));
  end;

begin
  inherited;
  if HasExpandButtonCell then
  begin
    ExpandButtonCellViewInfo.Calculate(ContentIndent, ATopBound);
    if NeedCalculateDetail then
    begin
      ADetailLeftBound := ExpandButtonCellViewInfo.Bounds.Right;
      ADetailTopBound := ATopBound + DataHeight;
      DetailsSiteViewInfo.Calculate(ADetailLeftBound, ADetailTopBound);
      DetailsAreaViewInfo.Calculate(ADetailLeftBound, ADetailTopBound);
    end;
  end;
end;

procedure TcxGridMasterDataRowViewInfo.DoRightToLeftConversion(const ABounds: TRect);
begin
  inherited DoRightToLeftConversion(ABounds);
  if HasExpandButtonCell then
  begin
    ExpandButtonCellViewInfo.RightToLeftConversion(ABounds);
    if DetailsSiteVisible then
    begin
      DetailsSiteViewInfo.RightToLeftConversion(ABounds);
      DetailsAreaViewInfo.RightToLeftConversion(ABounds);
    end;
  end;
end;

function TcxGridMasterDataRowViewInfo.GetHitTest(const P: TPoint): TcxCustomGridHitTest;
begin
  if DetailsSiteVisible and PtInRect(DetailsSiteViewInfo.Bounds, P) then
    Result := DetailsSiteViewInfo.GetHitTest(P)
  else
    Result := inherited GetHitTest(P);
end;

function TcxGridMasterDataRowViewInfo.ProcessDialogChar(ACharCode: Word): Boolean;
begin
  Result := inherited ProcessDialogChar(ACharCode);
  if not Result and DetailsSiteVisible then
    Result := DetailsSiteViewInfo.ProcessDialogChar(ACharCode);
end;

function TcxGridMasterDataRowViewInfo.SupportsTabAccelerators: Boolean;
begin
  Result := GridView.Controller.SupportsTabAccelerators(GridRecord);
end;

{ TcxGridGroupCellImageViewInfo }

constructor TcxGridGroupCellImageViewInfo.Create(AGroupCell: TcxGridGroupCellViewInfo);
begin
  FGroupCell := AGroupCell;
  inherited Create(GroupCell.GridViewInfo);
end;

function TcxGridGroupCellImageViewInfo.CalculateHeight: Integer;
begin
  Result := GroupCell.Height;
end;

function TcxGridGroupCellImageViewInfo.CalculateWidth: Integer;
begin
  Result := ScaleFactor.Apply(Images.Width);
end;

function TcxGridGroupCellImageViewInfo.GetHeight: Integer;
begin
  Result := CalculateHeight;
end;

function TcxGridGroupCellImageViewInfo.GetHitTestClass: TcxCustomGridHitTestClass;
begin
  Result := nil;
end;

function TcxGridGroupCellImageViewInfo.GetImageBounds: TRect;
begin
  Result := Bounds;
  if GroupCell.RowStyle = grsOffice11 then
  begin
    Result.Bottom := GroupCell.ContentBounds.Bottom;
    Result.Top := Result.Bottom - ScaleFactor.Apply(Images.Height);
  end
end;

function TcxGridGroupCellImageViewInfo.GetPainterClass: TcxCustomGridCellPainterClass;
begin
  Result := TcxGridGroupCellImagePainter;
end;

procedure TcxGridGroupCellImageViewInfo.GetViewParams(var AParams: TcxViewParams);
begin
  GroupCell.GetViewParams(AParams);
end;

function TcxGridGroupCellImageViewInfo.GetWidth: Integer;
begin
  Result := CalculateWidth;
end;

function TcxGridGroupCellImageViewInfo.GetGridRecord: TcxGridGroupRow;
begin
  Result := GroupCell.GridRecord;
end;

function TcxGridGroupCellImageViewInfo.GetGroupedColumn: TcxGridColumn;
begin
  Result := GroupCell.GroupedColumn;
end;

function TcxGridGroupCellImageViewInfo.GetImageAlign: TcxImageAlign;
begin
  Result := ImageProperties.ImageAlign;
end;

function TcxGridGroupCellImageViewInfo.GetImageIndex: TcxImageIndex;
var
  AText: string;
  AEditValue: Variant;
begin
  AEditValue := GridRecord.GroupedColumnValue[GroupCell.GroupedColumnIndex];
  ImageProperties.GetImageComboBoxDisplayValue(AEditValue, AText, Result);
end;

function TcxGridGroupCellImageViewInfo.GetImageProperties: TcxImageComboBoxProperties;
begin
  Result := TcxGridColumnAccess(GroupedColumn).GetImageComboBoxProperties;
end;

function TcxGridGroupCellImageViewInfo.GetImages: TCustomImageList;
begin
  Result := ImageProperties.Images;
end;

{ TcxGridGroupCellViewInfo }

constructor TcxGridGroupCellViewInfo.Create(AGroupedColumnAreaViewInfo: TcxGridGroupRowGroupedColumnAreaViewInfo);
begin
  inherited Create(AGroupedColumnAreaViewInfo.RecordViewInfo);
  FGroupedColumnAreaViewInfo := AGroupedColumnAreaViewInfo;
  if ShowCheckBox then
    FCheckBox := CreateCheckBox;
  if ShowImage then
    FImage := CreateImage;
end;

destructor TcxGridGroupCellViewInfo.Destroy;
begin
  FreeAndNil(FImage);
  FreeAndNil(FCheckBox);
  inherited Destroy;
end;

procedure TcxGridGroupCellViewInfo.BeforeRecalculation;
begin
  inherited BeforeRecalculation;
  if HasCheckBox then
    CheckBox.BeforeRecalculation;
  if HasImage then
    Image.BeforeRecalculation;
end;

function TcxGridGroupCellViewInfo.GetExpandedAreaBounds: TRect;
begin
  Result := inherited GetBorderBounds(bBottom);
  if UseRightToLeftAlignment then
    Result.Left := BorderBounds[bBottom].Right
  else
    Result.Right := BorderBounds[bBottom].Left;
end;

function TcxGridGroupCellViewInfo.GetGridRecord: TcxGridGroupRow;
begin
  Result := TcxGridGroupRow(inherited GridRecord);
end;

function TcxGridGroupCellViewInfo.GetGroupedColumn: TcxGridColumn;
begin
  Result := GridRecord.GroupedColumns[GroupedColumnIndex];
end;

function TcxGridGroupCellViewInfo.GetGroupedColumnIndex: Integer;
begin
  Result := GroupedColumnAreaViewInfo.GroupedColumnIndex;
end;

function TcxGridGroupCellViewInfo.GetRecordViewInfo: TcxGridGroupRowViewInfo;
begin
  Result := TcxGridGroupRowViewInfo(inherited RecordViewInfo);
end;

function TcxGridGroupCellViewInfo.GetRowStyle: TcxGridGroupRowStyle;
begin
  Result := RecordViewInfo.RowStyle;
end;

function TcxGridGroupCellViewInfo.CalculateHeight: Integer;
begin
  Result := GroupedColumnAreaViewInfo.Height;
end;

function TcxGridGroupCellViewInfo.CalculateWidth: Integer;
begin
  Result := GroupedColumnAreaViewInfo.Width;
end;

function TcxGridGroupCellViewInfo.CanHighlightFindText: Boolean;
begin
  Result := TcxGridColumnAccess(GroupedColumn).CanSearchInGroupRows;
end;

function TcxGridGroupCellViewInfo.CustomDraw(ACanvas: TcxCanvas): Boolean;
begin
  Result := inherited CustomDraw(ACanvas);
  if not Result then
    TcxGridTableViewAccess(GridView).DoCustomDrawGroupCell(ACanvas, Self, Result);
end;

function TcxGridGroupCellViewInfo.CreateCheckBox: TcxGridRowCheckBoxViewInfo;
begin
  Result := TcxGridRowCheckBoxViewInfo.Create(RecordViewInfo);
end;

function TcxGridGroupCellViewInfo.CreateImage: TcxGridGroupCellImageViewInfo;
begin
  Result := TcxGridGroupCellImageViewInfo.Create(Self);
end;

function TcxGridGroupCellViewInfo.DrawHotTrackedWhenRecordHotTracked: Boolean;
begin
  Result := True;
end;

function TcxGridGroupCellViewInfo.GetActualState: TcxGridCellState;
begin
  if GridView.RowLayout.Active then
    if Selected then
      Result := gcsPressed
    else
      if HotTracked then
        Result := gcsSelected
      else
        Result := gcsNone
  else
    Result := inherited GetActualState
end;

function TcxGridGroupCellViewInfo.GetAlignmentVert: TcxAlignmentVert;
begin
  Result := RecordViewInfo.GetAlignmentVert;
end;

function TcxGridGroupCellViewInfo.GetAlwaysSelected: Boolean;
begin
  Result := True;
end;

function TcxGridGroupCellViewInfo.GetBackgroundBitmap: TBitmap;
begin
  Result := RecordViewInfo.BackgroundBitmap;
end;

function TcxGridGroupCellViewInfo.GetBorderBounds(AIndex: TcxBorder): TRect;
begin
  Result := inherited GetBorderBounds(AIndex);
  if (AIndex = bBottom) and (RowStyle = grsStandard) and GridRecord.Expanded then
    if UseRightToLeftAlignment then
      Result.Right := RecordViewInfo.LevelIndentVertLineBounds[GridRecord.Level].Right
    else
      Result.Left := RecordViewInfo.LevelIndentVertLineBounds[GridRecord.Level].Left;
end;

function TcxGridGroupCellViewInfo.GetBorderColor(AIndex: TcxBorder): TColor;
begin
  if (AIndex = bBottom) and (RowStyle = grsOffice11) then
    Result := GridView.LookAndFeelPainter.GridGroupRowStyleOffice11SeparatorColor
  else
    Result := GridViewInfo.GridLineColor;
end;

function TcxGridGroupCellViewInfo.GetBorders: TcxBorders;
begin
  Result := GridViewInfo.GetCellBorders(True, True);
  if RowStyle = grsOffice11 then
    Include(Result, bBottom);
end;

function TcxGridGroupCellViewInfo.GetBorderWidth(AIndex: TcxBorder): Integer;
begin
  if (AIndex = bBottom) and (RowStyle = grsOffice11) then
    Result := RecordViewInfo.RecordsViewInfo.GroupRowSeparatorWidth
  else
    Result := GridViewInfo.GridLineWidth;
end;

function TcxGridGroupCellViewInfo.GetButtonState: TcxButtonState;
begin
  Result := inherited GetButtonState;
  if GridView.RowLayout.Active and (Result = cxbsPressed) and not GridView.IsControlFocused then
    Result := cxbsDisabled;
end;

function TcxGridGroupCellViewInfo.GetCheckBoxBounds: TRect;
begin
  Result := cxRectSetLeft(Bounds, Bounds.Left + GetCheckBoxMargins.Left, CheckBox.Width);
  Inc(Result.Top, GetCheckBoxMargins.Top);
  Dec(Result.Bottom, GetCheckBoxMargins.Bottom);
  Result := cxRectCenterVertically(Result, CheckBox.Height);
  if ShowExpandButton then
    Result := cxRectOffsetHorz(Result, GridViewInfo.LevelIndent);
end;

function TcxGridGroupCellViewInfo.GetCheckBoxMargins: TRect;
begin
  Result := ScaleFactor.Apply(Rect(1, 0, 5, 0));
end;

function TcxGridGroupCellViewInfo.GetContentRealRightBound: Integer;
begin
  if HasImage and (Image.ImageAlign = iaRight) then
    Result := GetImageBounds.Right + GetImageMargins.Right
  else
    Result := GetTextBounds(True, False).Right;
end;

procedure TcxGridGroupCellViewInfo.GetFindTextSelectionInfo(out ASelStart: Integer; out AHighlightedText: string);
var
  APrefix: string;
begin
  ASelStart := GridView.DataController.FindCriteria.GetTextStartPositionByRowIndex(
    GridRecord.Index, GroupedColumn.Index, AHighlightedText);
  APrefix := TcxGridGroupRowAccess(GridRecord).CaptionPrefix[GroupedColumnIndex];
  Inc(ASelStart, Length(APrefix));
end;

function TcxGridGroupCellViewInfo.GetHitTestClass: TcxCustomGridHitTestClass;
begin
  Result := TcxGridGroupCellHitTest;
end;

function TcxGridGroupCellViewInfo.GetImageBounds: TRect;
var
  ALeft: Integer;
begin
  if Image.ImageAlign = iaRight then
    ALeft := GetTextBounds(True, False).Right + GetImageMargins.Left
  else
    if HasCheckBox then
      ALeft := GetCheckBoxBounds.Right + GetCheckBoxMargins.Right + GetImageMargins.Left
    else
    begin
      ALeft := Bounds.Left + GetImageMargins.Left;
      if ShowExpandButton then
        Inc(ALeft, GridViewInfo.LevelIndent);
    end;
  Result := cxRectSetLeft(Bounds, ALeft, Image.Width);
  Inc(Result.Top, GetImageMargins.Top);
  Dec(Result.Bottom, GetImageMargins.Bottom);
  Result := cxRectCenterVertically(Result, Image.Height);
end;

function TcxGridGroupCellViewInfo.GetImageMargins: TRect;
var
  ALeft, ARight: Integer;
begin
  ALeft := 0;
  ARight := 0;
  if Image.ImageAlign = iaLeft then
    ARight := 4
  else
    ALeft := 4;
  Result := ScaleFactor.Apply(Rect(ALeft, 0, ARight, 0));
end;

function TcxGridGroupCellViewInfo.GetPainterClass: TcxCustomGridCellPainterClass;
begin
  Result := TcxGridGroupCellPainter;
end;

function TcxGridGroupCellViewInfo.GetText: string;
begin
  Result := GridRecord.DisplayCaptions[GroupedColumnIndex];
  TcxCustomGridTableItemAccess.DoGetDisplayText(GroupedColumn, GridRecord, Result);
end;

function TcxGridGroupCellViewInfo.GetTextAreaBounds: TRect;
begin
  Result := inherited GetTextAreaBounds;
  if HasImage and (Image.ImageAlign = iaLeft) then
    Result.Left := GetImageBounds.Right + GetImageMargins.Right
  else
    if HasCheckBox then
      Result.Left := GetCheckBoxBounds.Right + GetCheckBoxMargins.Right
    else
      if ShowExpandButton then
        Inc(Result.Left, GridViewInfo.LevelIndent);
end;

procedure TcxGridGroupCellViewInfo.GetViewParams(var AParams: TcxViewParams);
var
  AIgnoreSelectionParams: TcxViewParams;
begin
  GridView.Styles.GetDataCellParams(GridRecord, nil, AParams, True, Self);
  if GridView.RowLayout.Active then
  begin
    GridView.Styles.GetDataCellParams(GridRecord, nil, AIgnoreSelectionParams, True, Self, True, True);
    AParams.Color := AIgnoreSelectionParams.Color;
  end;
end;

function TcxGridGroupCellViewInfo.HasCustomDraw: Boolean;
begin
  Result := TcxGridTableViewAccess(GridView).HasCustomDrawGroupCell;
end;

function TcxGridGroupCellViewInfo.HasCheckBox: Boolean;
begin
  Result := CheckBox <> nil;
end;

function TcxGridGroupCellViewInfo.HasImage: Boolean;
begin
  Result := Image <> nil;
end;

function TcxGridGroupCellViewInfo.IsChildrenHotTracked: Boolean;
begin
  Result := inherited IsChildrenHotTracked or HasCheckBox and CheckBox.IsHotTracked;
end;

procedure TcxGridGroupCellViewInfo.Offset(DX: Integer; DY: Integer);
begin
  inherited Offset(DX, DY);
  if HasCheckBox then
    CheckBox.DoOffset(DX, DY);
  if HasImage then
    Image.DoOffset(DX, DY);
end;

procedure TcxGridGroupCellViewInfo.ResetChildrenState;
begin
  inherited ResetChildrenState;
  if HasCheckBox then
    TcxGridRowCheckBoxViewInfoAccess(CheckBox).ResetState;
end;

function TcxGridGroupCellViewInfo.ShowCheckBox: Boolean;
begin
  Result := RecordViewInfo.ShowCheckBox and (GroupedColumnIndex = 0);
end;

function TcxGridGroupCellViewInfo.ShowExpandButton: Boolean;
begin
  Result := GridRecord.Expandable and (GroupedColumnIndex = 0);
end;

function TcxGridGroupCellViewInfo.ShowImage: Boolean;
begin
  Result := TcxGridColumnAccess(GroupedColumn).ShowGroupValuesWithImages;
end;

procedure TcxGridGroupCellViewInfo.Calculate(ALeftBound: Integer; ATopBound: Integer; AWidth: Integer = -1; AHeight: Integer = -1);
begin
  inherited Calculate(ALeftBound, ATopBound, AWidth, AHeight);
  if HasCheckBox then
    CheckBox.Calculate(GetCheckBoxBounds);
  if HasImage then
    Image.Calculate(GetImageBounds);
end;

function TcxGridGroupCellViewInfo.CanDrawSelected: Boolean;
begin
  Result := True;
end;

procedure TcxGridGroupCellViewInfo.DoRightToLeftConversion(const ABounds: TRect);
begin
  inherited DoRightToLeftConversion(ABounds);
  if HasCheckBox then
    CheckBox.RightToLeftConversion(ABounds);
  if HasImage then
    Image.RightToLeftConversion(ABounds);
end;

function TcxGridGroupCellViewInfo.GetHitTest(const P: TPoint): TcxCustomGridHitTest;
var
  AHitTest: TcxCustomGridHitTest;
begin
  Result := inherited GetHitTest(P);
  if (Result = nil) or (Result.ClassType <> GetHitTestClass) then
    Exit;
  if HasCheckBox then
  begin
    AHitTest := CheckBox.GetHitTest(P);
    if AHitTest <> nil then
      Result := AHitTest;
  end;
end;

{ TcxGridGroupRowSpacerViewInfo }

constructor TcxGridGroupRowSpacerViewInfo.Create(ARowViewInfo: TcxGridGroupRowViewInfo;
  const AText: string);
begin
  inherited Create(ARowViewInfo.GridViewInfo);
  FRowViewInfo := ARowViewInfo;
  Text := AText;
end;

function TcxGridGroupRowSpacerViewInfo.GetGridView: TcxGridTableView;
begin
  Result := TcxGridTableView(inherited GridView);
end;

function TcxGridGroupRowSpacerViewInfo.CalculateWidth: Integer;
begin
  Result := TextWidth;
end;

function TcxGridGroupRowSpacerViewInfo.GetAlignmentVert: TcxAlignmentVert;
begin
  Result := RowViewInfo.AlignmentVert;
end;

function TcxGridGroupRowSpacerViewInfo.GetText: string;
begin
  Result := Text;
end;

function TcxGridGroupRowSpacerViewInfo.GetTextAreaBounds: TRect;
begin
  Result := ContentBounds;
  InflateRect(Result, 0, -ScaleFactor.Apply(cxGridCellTextOffset));
end;

procedure TcxGridGroupRowSpacerViewInfo.GetViewParams(var AParams: TcxViewParams);
begin
  GridView.Styles.GetGroupSummaryCellParams(RowViewInfo.GridRecord, nil, AParams);
end;

function TcxGridGroupRowSpacerViewInfo.GetWidth: Integer;
begin
  CalculateParams;
  Result := CalculateWidth;
end;

function TcxGridGroupRowSpacerViewInfo.HasBackground: Boolean;
begin
  Result := False;
end;

{ TcxGridGroupSummaryCellViewInfo }

constructor TcxGridGroupSummaryCellViewInfo.Create(AGroupedColumnAreaViewInfo: TcxGridGroupRowGroupedColumnAreaViewInfo;
  ASummaryItem: TcxDataSummaryItem; const AValue: Variant);
begin
  inherited Create(AGroupedColumnAreaViewInfo.GridViewInfo);
  FGroupedColumnAreaViewInfo := AGroupedColumnAreaViewInfo;
  FSummaryItem := ASummaryItem;
  FValue := AValue;
  FSeparatorViewInfo := GroupedColumnAreaViewInfo.CreateSpacerViewInfo(GetSeparatorText);
end;

destructor TcxGridGroupSummaryCellViewInfo.Destroy;
begin
  FSeparatorViewInfo.Free;
  inherited;
end;

function TcxGridGroupSummaryCellViewInfo.GetColumn: TcxGridColumn;
begin
  Result := SummaryItem.ItemLink as TcxGridColumn;
end;

function TcxGridGroupSummaryCellViewInfo.GetGridView: TcxGridTableView;
begin
  Result := TcxGridTableView(inherited GridView);
end;

function TcxGridGroupSummaryCellViewInfo.GetRowViewInfo: TcxGridGroupRowViewInfo;
begin
  Result := GroupedColumnAreaViewInfo.RecordViewInfo;
end;

procedure TcxGridGroupSummaryCellViewInfo.SetIsLast(Value: Boolean);
begin
  if FIsLast <> Value then
  begin
    FIsLast := Value;
    SeparatorViewInfo.Text := GetSeparatorText;
  end;
end;

function TcxGridGroupSummaryCellViewInfo.CalculateWidth: Integer;
begin
  Result := TextWidth + SeparatorViewInfo.Width;
end;

function TcxGridGroupSummaryCellViewInfo.CanAlignWithColumn: Boolean;
begin
  Result := Column <> nil;
end;

function TcxGridGroupSummaryCellViewInfo.CustomDraw(ACanvas: TcxCanvas): Boolean;
begin
  Result := inherited CustomDraw(ACanvas);
  if not Result then
  begin
    if Column <> nil then
      TcxGridColumnAccess(Column).DoCustomDrawGroupSummaryCell(ACanvas, Self, Result);
    if not Result then
      TcxGridTableViewAccess(GridView).DoCustomDrawGroupSummaryCell(ACanvas, Self, Result);
  end;
end;

function TcxGridGroupSummaryCellViewInfo.GetAlignmentHorz: TAlignment;
begin
  if CanAlignWithColumn and GroupedColumnAreaViewInfo.SummaryCellAutoWidth then
    Result := Column.GroupSummaryAlignment
  else
    Result := taLeftJustify;
end;

function TcxGridGroupSummaryCellViewInfo.GetAlignmentVert: TcxAlignmentVert;
begin
  Result := RowViewInfo.AlignmentVert;
end;

function TcxGridGroupSummaryCellViewInfo.GetDesignSelectionBounds: TRect;
begin
  Result := Bounds;
  InflateRect(Result, 0, -1);
end;

function TcxGridGroupSummaryCellViewInfo.GetHitTestClass: TcxCustomGridHitTestClass;
begin
  Result := TcxGridGroupSummaryHitTest;
end;

function TcxGridGroupSummaryCellViewInfo.GetIsDesignSelected: Boolean;
begin
  Result := GridView.IsDesigning and
    GridView.Controller.DesignController.IsObjectSelected(SummaryItem);
end;

function TcxGridGroupSummaryCellViewInfo.GetPainterClass: TcxCustomGridCellPainterClass;
begin
  Result := TcxGridGroupSummaryCellPainter;
end;

function TcxGridGroupSummaryCellViewInfo.GetSeparatorBounds: TRect;
var
  ALeft: Integer;
begin
  Result := Bounds;
  ALeft := Min(GetTextBounds(True, False).Right, TextAreaBounds.Right);
  Result := cxRectSetLeft(Result, ALeft, SeparatorViewInfo.Width);
end;

function TcxGridGroupSummaryCellViewInfo.GetSeparatorText: string;
begin
  if IsLast then
    Result := ''
  else
    Result := (SummaryItem.SummaryItems as TcxDataGroupSummaryItems).Separator + ' ';
end;

function TcxGridGroupSummaryCellViewInfo.GetShowEndEllipsis: Boolean;
begin
  Result := True;
end;

function TcxGridGroupSummaryCellViewInfo.GetText: string;
begin
  try
    Result := SummaryItem.FormatValue(Value, False);
  except
    Application.HandleException(Self);
  end;
end;

function TcxGridGroupSummaryCellViewInfo.GetTextAreaBounds: TRect;
begin
  Result := ContentBounds;
  InflateRect(Result, 0, -ScaleFactor.Apply(cxGridCellTextOffset));
  Dec(Result.Right, SeparatorViewInfo.Width);
  if Result.Right < Result.Left then
    Result.Right := Result.Left;
end;

procedure TcxGridGroupSummaryCellViewInfo.GetViewParams(var AParams: TcxViewParams);
begin
  GridView.Styles.GetGroupSummaryCellParams(RowViewInfo.GridRecord, SummaryItem, AParams);
end;

function TcxGridGroupSummaryCellViewInfo.HasBackground: Boolean;
begin
  Result := False;
end;

function TcxGridGroupSummaryCellViewInfo.HasCustomDraw: Boolean;
begin
  Result := inherited HasCustomDraw or
    (Column <> nil) and TcxGridColumnAccess(Column).HasCustomDrawGroupSummaryCell or
    TcxGridTableViewAccess(GridView).HasCustomDrawGroupSummaryCell;
end;

procedure TcxGridGroupSummaryCellViewInfo.InitHitTest(AHitTest: TcxCustomGridHitTest);
begin
  inherited;
  with TcxGridGroupSummaryHitTest(AHitTest) do
  begin
    if not GridView.IsDesigning then
      ViewInfo := Self.RowViewInfo;
    GridRecord := Self.RowViewInfo.GridRecord;
    SummaryItem := Self.SummaryItem;
  end;
end;

procedure TcxGridGroupSummaryCellViewInfo.Offset(DX, DY: Integer);
begin
  inherited;
  SeparatorViewInfo.DoOffset(DX, DY);
end;

procedure TcxGridGroupSummaryCellViewInfo.BeforeRecalculation;
begin
  inherited;
  SeparatorViewInfo.BeforeRecalculation;
end;

procedure TcxGridGroupSummaryCellViewInfo.Calculate(ALeftBound, ATopBound: Integer;
  AWidth: Integer = -1; AHeight: Integer = -1);
begin
  inherited;
  SeparatorViewInfo.Calculate(GetSeparatorBounds);
end;

procedure TcxGridGroupSummaryCellViewInfo.DoRightToLeftConversion(const ABounds: TRect);
begin
  inherited DoRightToLeftConversion(ABounds);
  SeparatorViewInfo.RightToLeftConversion(ABounds);
end;

function TcxGridGroupSummaryCellViewInfo.MouseDown(AHitTest: TcxCustomGridHitTest;
  AButton: TMouseButton; AShift: TShiftState): Boolean;
begin
  Result := inherited MouseDown(AHitTest, AButton, AShift);
  if GridView.IsDesigning and (AButton = mbLeft) then
  begin
    GridView.Controller.DesignController.SelectObject(SummaryItem, not (ssShift in AShift));
    Result := True;
  end;
end;

{ TcxGridGroupRowGroupedColumnAreaViewInfo }

constructor TcxGridGroupRowGroupedColumnAreaViewInfo.Create(ARecordViewInfo: TcxCustomGridRecordViewInfo;
  AGroupedColumnIndex: Integer);
begin
  inherited Create(ARecordViewInfo);
  FGroupedColumnIndex := AGroupedColumnIndex;
  FCellViewInfo := TcxGridGroupCellViewInfo.Create(Self);
  CreateSummaryCellViewInfos;
  CreateSummaryCellsWithoutColumns;
  if NeedSpacers then
    CreateSummarySpacerViewInfos;
  if NeedSeparator then
    CreateSeparatorViewInfo;
end;

destructor TcxGridGroupRowGroupedColumnAreaViewInfo.Destroy;
begin
  FSeparatorViewInfo.Free;
  FSummaryEndingSpacerViewInfo.Free;
  FSummaryBeginningSpacerViewInfo.Free;
  FSummaryCellsWithoutColumns.Free;
  FSummaryCellViewInfos.Free;
  FCellViewInfo.Free;
  inherited Destroy;
end;

procedure TcxGridGroupRowGroupedColumnAreaViewInfo.BeforeRecalculation;
var
  I: Integer;
begin
  inherited BeforeRecalculation;
  CellViewInfo.BeforeRecalculation;
  if HasSummaryBeginningSpacer then
    SummaryBeginningSpacerViewInfo.BeforeRecalculation;
  for I := 0 to SummaryCellViewInfoCount - 1 do
    SummaryCellViewInfos[I].BeforeRecalculation;
  if HasSummaryEndingSpacer then
    SummaryEndingSpacerViewInfo.BeforeRecalculation;
  if HasSeparator then
    SeparatorViewInfo.BeforeRecalculation
end;

procedure TcxGridGroupRowGroupedColumnAreaViewInfo.Calculate(ALeftBound: Integer; ATopBound: Integer;
  AWidth: Integer = -1; AHeight: Integer = -1);
begin
  inherited Calculate(ALeftBound, ATopBound, AWidth, AHeight);
  CellViewInfo.Calculate(ALeftBound, ATopBound);
  CalculateSummaryCells;
  if HasSeparator then
    SeparatorViewInfo.Calculate(GetSeparatorBounds);
end;

function TcxGridGroupRowGroupedColumnAreaViewInfo.GetHitTest(const P: TPoint): TcxCustomGridHitTest;
var
  I: Integer;
  AHitTest: TcxCustomGridHitTest;
begin
  Result := nil;
  for I := 0 to SummaryCellViewInfoCount - 1 do
  begin
    AHitTest := SummaryCellViewInfos[I].GetHitTest(P);
    if AHitTest <> nil then
    begin
      Result := AHitTest;
      Exit;
    end;
  end;
  AHitTest := CellViewInfo.GetHitTest(P);
  if AHitTest <> nil then
  begin
    Result := AHitTest;
    Exit;
  end;
end;

function TcxGridGroupRowGroupedColumnAreaViewInfo.CalculateHeight: Integer;
begin
  Result := RecordViewInfo.DataHeight;
end;

function TcxGridGroupRowGroupedColumnAreaViewInfo.CalculateWidth: Integer;
begin
  Result := cxRectWidth(RecordViewInfo.Bounds) - RecordViewInfo.LevelIndent;
end;

function TcxGridGroupRowGroupedColumnAreaViewInfo.GetPainterClass: TcxCustomGridCellPainterClass;
begin
  Result := TcxGridGroupRowGroupedColumnAreaPainter;
end;

procedure TcxGridGroupRowGroupedColumnAreaViewInfo.Offset(DX: Integer; DY: Integer);
var
  I: Integer;
begin
  inherited Offset(DX, DY);
  CellViewInfo.Offset(DX, DY);
  if HasSummaryBeginningSpacer then
    SummaryBeginningSpacerViewInfo.DoOffset(DX, DY);
  for I := 0 to SummaryCellViewInfoCount - 1 do
    SummaryCellViewInfos[I].DoOffset(DX, DY);
  if HasSummaryEndingSpacer then
    SummaryEndingSpacerViewInfo.DoOffset(DX, DY);
  if HasSeparator then
    SeparatorViewInfo.DoOffset(DX, DY);
end;

procedure TcxGridGroupRowGroupedColumnAreaViewInfo.AddSummaryCellViewInfo(ASummaryItem: TcxDataSummaryItem; const AValue: Variant);
begin
  SummaryCells.Add(CreateSummaryCellViewInfo(ASummaryItem, AValue));
end;

procedure TcxGridGroupRowGroupedColumnAreaViewInfo.CalculateSummaryCells;
var
  I: Integer;
  AColumnHeaderViewInfo: TcxGridColumnHeaderViewInfo;
  ACellViewInfos: TList;
begin
  if not HasSummary then
    Exit;
  if HasUnalignableSummaryCells then
  begin
    SummaryBeginningSpacerViewInfo.Calculate(GetSummaryBeginningSpacerBounds);
    TcxGridGroupSummaryCellViewInfo(UnalignableSummaryCells.Last).IsLast := True;
    CalculateSummaryCells(UnalignableSummaryCells, GetSummaryCellsAreaBounds(False),
      taLeftJustify, False);
    SummaryEndingSpacerViewInfo.Calculate(GetSummaryEndingSpacerBounds);
  end;
  if RecordViewInfo.SummaryCellLayout <> gslStandard then
  begin
    ACellViewInfos := TList.Create;
    try
      for I := 0 to GridViewInfo.HeaderViewInfo.Count - 1 do
      begin
        AColumnHeaderViewInfo := GridViewInfo.HeaderViewInfo[I];
        PopulateColumnSummaryCellViewInfos(ACellViewInfos, AColumnHeaderViewInfo.Column);
        if ACellViewInfos.Count <> 0 then
        begin
          TcxGridGroupSummaryCellViewInfo(ACellViewInfos.Last).IsLast := True;
          CalculateSummaryCells(ACellViewInfos,
            GetColumnSummaryCellsAreaBounds(AColumnHeaderViewInfo),
            AColumnHeaderViewInfo.Column.GroupSummaryAlignment, SummaryCellAutoWidth);
        end;
      end;
    finally
      ACellViewInfos.Free;
    end;
  end;
end;

procedure TcxGridGroupRowGroupedColumnAreaViewInfo.CalculateSummaryCells(ACellViewInfos: TList; const AAreaBounds: TRect;
  AAlignment: TAlignment; AAutoWidth: Boolean);
var
  AWidths: TcxAutoWidthObject;
  ABounds: TRect;
  I: Integer;
begin
  AWidths := CalculateSummaryCellWidths(ACellViewInfos, AAreaBounds.Right - AAreaBounds.Left,
    AAutoWidth);
  try
    ABounds := GetSummaryCellsBounds(AAreaBounds, AWidths, AAlignment, AAutoWidth);
    for I := 0 to ACellViewInfos.Count - 1 do
    begin
      ABounds.Right := Min(ABounds.Left + AWidths[I].AutoWidth, AAreaBounds.Right);
      TcxGridGroupSummaryCellViewInfo(ACellViewInfos[I]).Calculate(ABounds);
      ABounds.Left := ABounds.Right;
    end;
  finally
    AWidths.Free;
  end;
end;

function TcxGridGroupRowGroupedColumnAreaViewInfo.CalculateSummaryCellWidths(ACellViewInfos: TList; AAvailableWidth: Integer;
  AAutoWidth: Boolean): TcxAutoWidthObject;
var
  I: Integer;
begin
  Result := TcxAutoWidthObject.Create(ACellViewInfos.Count);
  Result.AvailableWidth := AAvailableWidth;
  for I := 0 to ACellViewInfos.Count - 1 do
    with Result.AddItem do
    begin
      Width := TcxGridGroupSummaryCellViewInfo(ACellViewInfos[I]).CalculateWidth;
      MinWidth := Width;
      Fixed := False;
      if not AAutoWidth then
        AutoWidth := Width;
    end;
  if AAutoWidth then
    Result.Calculate;
end;

function TcxGridGroupRowGroupedColumnAreaViewInfo.CreateSummaryCellViewInfo(ASummaryItem: TcxDataSummaryItem;
  const AValue: Variant): TcxGridGroupSummaryCellViewInfo;
begin
  Result := GetSummaryCellViewInfoClass.Create(Self, ASummaryItem, AValue);
end;

procedure TcxGridGroupRowGroupedColumnAreaViewInfo.CreateSummaryCellViewInfos;
var
  ASummaryItems: TcxDataSummaryItems;
  ASummaryValues: PVariant;
  I: Integer;
begin
  FSummaryCellViewInfos := TObjectList.Create;
  if not GridRecord.GetGroupSummaryInfo(ASummaryItems, ASummaryValues, GroupedColumnIndex) then
    Exit;
  for I := 0 to ASummaryItems.Count - 1 do
    if ASummaryItems[I].Position = spGroup then
      AddSummaryCellViewInfo(ASummaryItems[I], ASummaryValues^[I]);
end;

procedure TcxGridGroupRowGroupedColumnAreaViewInfo.CreateSummaryCellsWithoutColumns;
begin
  FSummaryCellsWithoutColumns := TList.Create;
  PopulateColumnSummaryCellViewInfos(SummaryCellsWithoutColumns, nil);
end;

function TcxGridGroupRowGroupedColumnAreaViewInfo.GetColumnSummaryCellsAreaBounds(
  AColumnHeaderViewInfo: TcxGridColumnHeaderViewInfo): TRect;
var
  R: TRect;
begin
  Result := GetSummaryCellsAreaBounds(True);
  R := AColumnHeaderViewInfo.Bounds;
  if GridViewInfo.IsRightToLeftConverted then
    R := TdxRightToLeftLayoutConverter.ConvertRect(R, CellViewInfo.RecordViewInfo.Bounds)
  else
    R.Left := AColumnHeaderViewInfo.DataOffset;
  Result.Left := Max(Result.Left, R.Left + ScaleFactor.Apply(cxGridCellTextOffset));
  Result.Right := Min(Result.Right, R.Right - ScaleFactor.Apply(cxGridCellTextOffset));
end;

procedure TcxGridGroupRowGroupedColumnAreaViewInfo.PopulateColumnSummaryCellViewInfos(AList: TList; AColumn: TcxGridColumn);
var
  I: Integer;
begin
  AList.Clear;
  for I := 0 to SummaryCellViewInfoCount - 1 do
    if SummaryCellViewInfos[I].Column = AColumn then
      AList.Add(SummaryCellViewInfos[I]);
end;

function TcxGridGroupRowGroupedColumnAreaViewInfo.GetSummaryCellAutoWidth: Boolean;
begin
  Result := RecordViewInfo.SummaryCellLayout = gslAlignWithColumnsAndDistribute;
end;

function TcxGridGroupRowGroupedColumnAreaViewInfo.GetSummaryCellsAreaBounds(AForAlignableCells: Boolean): TRect;
begin
  Result := CellViewInfo.ContentBounds;
  Result.Right := CellViewInfo.TextAreaBounds.Right;
  Result.Left := Min(CellViewInfo.GetContentRealRightBound, Result.Right);
  if AForAlignableCells then
  begin
    if HasUnalignableSummaryCells then
      Result.Left := SummaryEndingSpacerViewInfo.Bounds.Right;
    Inc(Result.Left, 2 * ScaleFactor.Apply(cxGridCellTextOffset));
  end
  else
  begin
    Inc(Result.Left, SummaryBeginningSpacerViewInfo.Width);
    Dec(Result.Right, SummaryEndingSpacerViewInfo.Width);
    if Result.Right < Result.Left then
      Result.Right := Result.Left;
  end;
end;

function TcxGridGroupRowGroupedColumnAreaViewInfo.GetUnalignableSummaryCells: TList;
begin
  if RecordViewInfo.SummaryCellLayout = gslStandard then
    Result := SummaryCells
  else
    Result := SummaryCellsWithoutColumns;
end;

function TcxGridGroupRowGroupedColumnAreaViewInfo.HasUnalignableSummaryCells: Boolean;
begin
  Result := (RecordViewInfo.SummaryCellLayout = gslStandard) or (SummaryCellsWithoutColumns.Count <> 0);
end;

procedure TcxGridGroupRowGroupedColumnAreaViewInfo.CreateSeparatorViewInfo;
begin
  FSeparatorViewInfo := CreateSpacerViewInfo(GetSeparatorText);
end;

function TcxGridGroupRowGroupedColumnAreaViewInfo.CreateSpacerViewInfo(const AText: string): TcxGridGroupRowSpacerViewInfo;
begin
  Result := GetSpacerViewInfoClass.Create(RecordViewInfo, AText);
end;

procedure TcxGridGroupRowGroupedColumnAreaViewInfo.CreateSummaryBeginningSpacerViewInfo;
begin
  FSummaryBeginningSpacerViewInfo := CreateSpacerViewInfo(GetSummaryBeginningSpacerText);
end;

procedure TcxGridGroupRowGroupedColumnAreaViewInfo.CreateSummaryEndingSpacerViewInfo;
begin
  FSummaryEndingSpacerViewInfo := CreateSpacerViewInfo(GetSummaryEndingSpacerText);
end;

procedure TcxGridGroupRowGroupedColumnAreaViewInfo.CreateSummarySpacerViewInfos;
begin
  CreateSummaryBeginningSpacerViewInfo;
  CreateSummaryEndingSpacerViewInfo;
end;

procedure TcxGridGroupRowGroupedColumnAreaViewInfo.DoRightToLeftConversion(const ABounds: TRect);
var
  I: Integer;
begin
  inherited DoRightToLeftConversion(ABounds);
  CellViewInfo.RightToLeftConversion(ABounds);
  for I := 0 to SummaryCellViewInfoCount - 1 do
    SummaryCellViewInfos[I].RightToLeftConversion(ABounds);
  for I := 0 to SummaryCellsWithoutColumns.Count - 1 do
    TcxGridGroupSummaryCellViewInfo(SummaryCellsWithoutColumns[I]).RightToLeftConversion(ABounds);
  if NeedSpacers then
  begin
    SummaryBeginningSpacerViewInfo.RightToLeftConversion(ABounds);
    SummaryEndingSpacerViewInfo.RightToLeftConversion(ABounds);
  end;
  if HasSeparator then
    SeparatorViewInfo.RightToLeftConversion(ABounds);
end;

function TcxGridGroupRowGroupedColumnAreaViewInfo.GetSeparatorBounds: TRect;
var
  ALeftBound: Integer;
begin
  Result := CellViewInfo.ContentBounds;
  if HasSummary and HasUnalignableSummaryCells then
    ALeftBound := SummaryEndingSpacerViewInfo.Bounds.Right
  else
    ALeftBound := CellViewInfo.GetContentRealRightBound;
  Result := cxRectSetLeft(Result, ALeftBound, SeparatorViewInfo.Width);
end;

function TcxGridGroupRowGroupedColumnAreaViewInfo.GetSeparatorText: string;
begin
  Result := GridView.OptionsView.MergedGroupSeparator;
end;

function TcxGridGroupRowGroupedColumnAreaViewInfo.GetSpacerViewInfoClass: TcxGridGroupRowSpacerViewInfoClass;
begin
  Result := TcxGridGroupRowSpacerViewInfo;
end;

function TcxGridGroupRowGroupedColumnAreaViewInfo.GetSummaryBeginningSpacerBounds: TRect;
begin
  Result := GetSummaryCellsAreaBounds(False);
  Result.Right := Result.Left;
  Dec(Result.Left, SummaryBeginningSpacerViewInfo.Width);
  Result.Right := Min(Result.Right, CellViewInfo.TextAreaBounds.Right);
end;

function TcxGridGroupRowGroupedColumnAreaViewInfo.GetSummaryBeginningSpacerText: string;
begin
  Result := ' ' + GridRecord.GroupSummaryItems.BeginText;
end;

function TcxGridGroupRowGroupedColumnAreaViewInfo.GetSummaryEndingSpacerBounds: TRect;
begin
  Result := GetSummaryCellsAreaBounds(False);
  Result.Left := TcxGridGroupSummaryCellViewInfo(UnalignableSummaryCells.Last).Bounds.Right;
  Result.Right := Result.Left + SummaryEndingSpacerViewInfo.Width;
  Result.Right := Min(Result.Right, CellViewInfo.TextAreaBounds.Right);
end;

function TcxGridGroupRowGroupedColumnAreaViewInfo.GetSummaryEndingSpacerText: string;
begin
  Result := GridRecord.GroupSummaryItems.EndText;
end;

function TcxGridGroupRowGroupedColumnAreaViewInfo.HasSeparator: Boolean;
begin
  Result := SeparatorViewInfo <> nil;
end;

function TcxGridGroupRowGroupedColumnAreaViewInfo.HasSummary: Boolean;
begin
  Result := SummaryCellViewInfoCount > 0;
end;

function TcxGridGroupRowGroupedColumnAreaViewInfo.HasSummaryBeginningSpacer: Boolean;
begin
  Result := SummaryBeginningSpacerViewInfo <> nil;
end;

function TcxGridGroupRowGroupedColumnAreaViewInfo.HasSummaryEndingSpacer: Boolean;
begin
  Result := SummaryEndingSpacerViewInfo <> nil;
end;

function TcxGridGroupRowGroupedColumnAreaViewInfo.IsChildrenHotTracked: Boolean;
var
  I: Integer;
begin
  Result := inherited IsChildrenHotTracked or CellViewInfo.IsHotTracked;
  if Result then
    Exit;
  for I := 0 to SummaryCellViewInfoCount - 1 do
  begin
    Result := SummaryCellViewInfos[I].IsHotTracked;
    if Result then
      Exit;
  end;
end;

function TcxGridGroupRowGroupedColumnAreaViewInfo.NeedSeparator: Boolean;
begin
  Result := not IsLast;
end;

function TcxGridGroupRowGroupedColumnAreaViewInfo.NeedSpacers: Boolean;
begin
  Result := HasUnalignableSummaryCells;
end;

procedure TcxGridGroupRowGroupedColumnAreaViewInfo.ResetChildrenState;
var
  I: Integer;
begin
  inherited ResetChildrenState;
  CellViewInfo.ResetState;
  for I := 0 to SummaryCellViewInfoCount - 1 do
    SummaryCellViewInfos[I].ResetState;
end;

function TcxGridGroupRowGroupedColumnAreaViewInfo.GetSummaryCellsBounds(const AAreaBounds: TRect; AWidths: TcxAutoWidthObject;
  AAlignment: TAlignment; AAutoWidth: Boolean): TRect;
begin
  Result := AAreaBounds;
  if not AAutoWidth and (AWidths.Width < AWidths.AvailableWidth) then
    case AAlignment of
      taRightJustify:
        Result.Left := Result.Right - AWidths.Width;
      taCenter:
        Result.Left := (Result.Left + Result.Right - AWidths.Width) div 2;
    end;
end;

function TcxGridGroupRowGroupedColumnAreaViewInfo.GetSummaryCellViewInfoClass: TcxGridGroupSummaryCellViewInfoClass;
begin
  Result := TcxGridGroupSummaryCellViewInfo;
end;

function TcxGridGroupRowGroupedColumnAreaViewInfo.GetGridRecord: TcxGridGroupRow;
begin
  Result := TcxGridGroupRow(inherited GridRecord);
end;

function TcxGridGroupRowGroupedColumnAreaViewInfo.GetIsLast: Boolean;
begin
  Result := GroupedColumnIndex = RecordViewInfo.GridRecord.GroupedColumnCount - 1;
end;

function TcxGridGroupRowGroupedColumnAreaViewInfo.GetRecordViewInfo: TcxGridGroupRowViewInfo;
begin
  Result := TcxGridGroupRowViewInfo(inherited RecordViewInfo);
end;

function TcxGridGroupRowGroupedColumnAreaViewInfo.GetSummaryCellViewInfo(Index: Integer): TcxGridGroupSummaryCellViewInfo;
begin
  Result := TcxGridGroupSummaryCellViewInfo(SummaryCells[Index]);
end;

function TcxGridGroupRowGroupedColumnAreaViewInfo.GetSummaryCellViewInfoCount: Integer;
begin
  Result := SummaryCells.Count;
end;

{ TcxGridGroupRowViewInfo }

constructor TcxGridGroupRowViewInfo.Create(ARecordsViewInfo: TcxCustomGridRecordsViewInfo;
  ARecord: TcxCustomGridRecord);
begin
  inherited Create(ARecordsViewInfo, ARecord);
  CreateGroupedColumnAreaViewInfos;
end;

destructor TcxGridGroupRowViewInfo.Destroy;
begin
  FGroupedColumnAreaViewInfos.Free;
  inherited Destroy;
end;

procedure TcxGridGroupRowViewInfo.BeforeRecalculation;
var
  I: Integer;
begin
  inherited BeforeRecalculation;
  for I := 0 to GroupedColumnAreaViewInfoCount - 1 do
    GroupedColumnAreaViewInfos[I].BeforeRecalculation;
end;

procedure TcxGridGroupRowViewInfo.Calculate(ALeftBound, ATopBound: Integer; AWidth: Integer = -1; AHeight: Integer = -1);
begin
  CalculateBottomBorderLeftPosition;
  inherited Calculate(ALeftBound, ATopBound, AWidth, AHeight);
  CalculateGroupedColumnAreaViewInfo(ALeftBound + LevelIndent, ATopBound);
end;

function TcxGridGroupRowViewInfo.GetHitTest(const P: TPoint): TcxCustomGridHitTest;
var
  I: Integer;
  AHitTest: TcxCustomGridHitTest;
begin
  Result := inherited GetHitTest(P);
  if (Result = nil) or (Result.ClassType <> GetHitTestClass) then
    Exit;
  for I := 0 to GroupedColumnAreaViewInfoCount - 1 do
  begin
    AHitTest := GroupedColumnAreaViewInfos[I].GetHitTest(P);
    if AHitTest <> nil then
    begin
      Result := AHitTest;
      Break;
    end;
  end;
end;

procedure TcxGridGroupRowViewInfo.AddGroupedColumnAreaViewInfo(AGroupedColumnIndex: Integer);
begin
  FGroupedColumnAreaViewInfos.Add(CreateGroupedColumnAreaViewInfo(AGroupedColumnIndex));
end;

procedure TcxGridGroupRowViewInfo.CalculateBottomBorderLeftPosition;
var
  ALevel, ANextIndex: Integer;
  ARowViewInfo: TcxCustomGridRowViewInfo;
begin
  FBottomBorderLeftPosition := MinInt;
  if FixedState = rfsNotFixed then
    Exit;
  ANextIndex := TcxGridRowsViewInfoAccess(RecordsViewInfo).GetNextNonOverlappedIndex(Index);
  if ANextIndex = -1 then
    Exit;
  ARowViewInfo := RecordsViewInfo[ANextIndex];
  ALevel := ARowViewInfo.GridRecord.Level;
  if GridRecord.Level >= ALevel then
    FBottomBorderLeftPosition := ARowViewInfo.LevelIndentSpaceBounds[ALevel].Left;
end;

procedure TcxGridGroupRowViewInfo.CalculateExpandButtonBounds(var ABounds: TRect);
begin
  ABounds := MainGroupedColumnAreaViewInfo.CellViewInfo.ContentBounds;
  if RowStyle = grsOffice11 then
    ABounds.Top := ABounds.Bottom - MainGroupedColumnAreaViewInfo.CellViewInfo.TextHeightWithOffset;
  inherited CalculateExpandButtonBounds(ABounds);
end;

procedure TcxGridGroupRowViewInfo.CalculateGroupedColumnAreaViewInfo(ALeftBound, ATopBound: Integer);
var
  I, AWidth: Integer;
  AGroupedColumnAreaViewInfo: TcxGridGroupRowGroupedColumnAreaViewInfo;
begin
  AWidth := -1;
  for I := 0 to GroupedColumnAreaViewInfoCount - 1 do
  begin
    AGroupedColumnAreaViewInfo := GroupedColumnAreaViewInfos[I];
    AGroupedColumnAreaViewInfo.Calculate(ALeftBound, ATopBound, AWidth);
    if not AGroupedColumnAreaViewInfo.IsLast then
    begin
      ALeftBound := AGroupedColumnAreaViewInfo.SeparatorViewInfo.Bounds.Right;
      AWidth := Bounds.Right - ALeftBound;
      if AWidth <= 0 then
        Break;
    end;
  end;
end;

function TcxGridGroupRowViewInfo.CalculateHeight: Integer;
var
  AParams: TcxViewParams;
begin
  if AutoHeight then
  begin
    MainGroupedColumnAreaViewInfo.CellViewInfo.CalculateParams;
    AParams := MainGroupedColumnAreaViewInfo.CellViewInfo.Params;
    Result := RecordsViewInfo.CalculateCustomGroupRowHeight(False, AParams);
    dxAdjustToTouchableSize(Result, ScaleFactor);
  end
  else
    Result := RecordsViewInfo.GroupRowHeight;
  Inc(Result, inherited CalculateHeight);
end;

function TcxGridGroupRowViewInfo.CanSize: Boolean;
begin
  Result := GridView.OptionsCustomize.GroupRowSizing;
end;

procedure TcxGridGroupRowViewInfo.CheckRowHeight(var AValue: Integer);
begin
  Dec(AValue, NonBaseHeight);
  inherited;
  GridView.OptionsView.CheckGroupRowHeight(AValue);
  Inc(AValue, NonBaseHeight);
end;

function TcxGridGroupRowViewInfo.CreateGroupedColumnAreaViewInfo(
  AGroupedColumnIndex: Integer): TcxGridGroupRowGroupedColumnAreaViewInfo;
begin
  Result := TcxGridGroupRowGroupedColumnAreaViewInfo.Create(Self, AGroupedColumnIndex);
end;

procedure TcxGridGroupRowViewInfo.CreateGroupedColumnAreaViewInfos;
var
  AGroupedColumnIndex: Integer;
begin
  FGroupedColumnAreaViewInfos := TdxFastObjectList.Create;
  for AGroupedColumnIndex := 0 to GridRecord.GroupedColumnCount - 1 do
    AddGroupedColumnAreaViewInfo(AGroupedColumnIndex);
end;

procedure TcxGridGroupRowViewInfo.DoRightToLeftConversion(const ABounds: TRect);
var
  I: Integer;
begin
  inherited DoRightToLeftConversion(ABounds);
  if HasElongateBottomBorder then
    FBottomBorderLeftPosition := TdxRightToLeftLayoutConverter.ConvertXCoordinate(FBottomBorderLeftPosition, ABounds);
  for I := 0 to GroupedColumnAreaViewInfoCount - 1 do
    GroupedColumnAreaViewInfos[I].RightToLeftConversion(ABounds);
end;

function TcxGridGroupRowViewInfo.GetAlignmentVert: TcxAlignmentVert;
begin
  if RowStyle = grsStandard then
    Result := vaCenter
  else
    Result := vaBottom;
end;

function TcxGridGroupRowViewInfo.GetAutoHeight: Boolean;
begin
  Result := inherited GetAutoHeight and (GridView.OptionsView.GroupRowHeight = 0);
end;

function TcxGridGroupRowViewInfo.GetBackgroundBitmap: TBitmap;
begin
  Result := RecordsViewInfo.GroupBackgroundBitmap;
end;

function TcxGridGroupRowViewInfo.GetExpandButtonAreaBounds: TRect;
begin
  CalculateExpandButtonBounds(Result);
end;

function TcxGridGroupRowViewInfo.GetFixedState: TcxDataControllerRowFixedState;
begin
  if FIsFixed then
    Result := rfsFixedToTop
  else
    Result := rfsNotFixed;
end;

function TcxGridGroupRowViewInfo.GetFixedGroupIndicatorBounds: TRect;
var
  AIndicatorSize: TSize;
begin
  AIndicatorSize := LookAndFeelPainter.GetScaledFixedGroupIndicatorSize(ScaleFactor);
  Result := cxRectCenterVertically(ContentBounds, AIndicatorSize.cy);
  Result.Right := Min(ContentBounds.Right, GridViewInfo.ClientBounds.Right);
  Dec(Result.Right, cxGridFixedGroupIndicatorRightIndent);
  Result.Left := Result.Right - AIndicatorSize.cx;
end;

function TcxGridGroupRowViewInfo.GetFocusRectBounds: TRect;
begin
  Result := inherited GetFocusRectBounds;
  Result.Bottom := MainGroupedColumnAreaViewInfo.CellViewInfo.ContentBounds.Bottom;
end;

function TcxGridGroupRowViewInfo.GetPainterClass: TcxCustomGridCellPainterClass;
begin
  Result := TcxGridGroupRowPainter;
end;

function TcxGridGroupRowViewInfo.GetRealFixedGroupIndicatorBounds: TRect;
begin
  Result := GetFixedGroupIndicatorBounds;
  if IsRightToLeftConverted then
    Result := TdxRightToLeftLayoutConverter.ConvertRect(Result, Bounds);
end;

function TcxGridGroupRowViewInfo.GetSeparatorBounds: TRect;
begin
  Result := inherited GetSeparatorBounds;
  if Expanded then
    Inc(Result.Left, GridViewInfo.LevelIndent);
end;

function TcxGridGroupRowViewInfo.GetSeparatorIndentBounds: TRect;
begin
  Result := inherited GetSeparatorBounds;
  Result.Right := SeparatorBounds.Left;
end;

function TcxGridGroupRowViewInfo.GetShowSeparator: Boolean;
begin
  if RowStyle = grsStandard then
    Result := inherited GetShowSeparator
  else
    Result := False;
end;

function TcxGridGroupRowViewInfo.HasElongateBottomBorder: Boolean;
begin
  Result := FBottomBorderLeftPosition <> MinInt;
end;

function TcxGridGroupRowViewInfo.HasFixedGroupIndicator: Boolean;
var
  ANextIndex: Integer;
  ANextRowViewInfo: TcxCustomGridRowViewInfo;
begin
  Result := False;
  if FixedState = rfsNotFixed then
    Exit;
  ANextIndex := TcxGridRowsViewInfoAccess(RecordsViewInfo).GetNextNonOverlappedIndex(Index);
  if ANextIndex = -1 then
    Exit;
  ANextRowViewInfo := RecordsViewInfo.Items[ANextIndex];
  Result := (ANextRowViewInfo.GridRecord.Index > GridRecord.Index + 1) or
    (ANextRowViewInfo.ContentBounds.Top < ContentBounds.Bottom);
end;

function TcxGridGroupRowViewInfo.HasFocusRect: Boolean;
begin
  Result := True;
end;

function TcxGridGroupRowViewInfo.HasFooter(ALevel: Integer): Boolean;
begin
  Result := inherited HasFooter(ALevel) or
    (GridView.OptionsView.GroupFooters = gfAlwaysVisible) and
    (ALevel = 0) and not GridRecord.Expanded and
    Controller.CanShowGroupFooter(GridRecord.Level);
end;

function TcxGridGroupRowViewInfo.IsChildrenHotTracked: Boolean;
var
  I: Integer;
begin
  Result := inherited IsChildrenHotTracked;
  if Result then
    Exit;
  for I := 0 to GroupedColumnAreaViewInfoCount - 1 do
  begin
    Result := GroupedColumnAreaViewInfos[I].IsHotTracked;
    if Result then
      Break;
  end;
end;

procedure TcxGridGroupRowViewInfo.Offset(DX, DY: Integer);
var
  I: Integer;
begin
  inherited Offset(DX, DY);
  for I := 0 to GroupedColumnAreaViewInfoCount - 1 do
    GroupedColumnAreaViewInfos[I].DoOffset(DX, DY);
end;

procedure TcxGridGroupRowViewInfo.ResetChildrenState;
var
  I: Integer;
begin
  inherited ResetChildrenState;
  for I := 0 to GroupedColumnAreaViewInfoCount - 1 do
    GroupedColumnAreaViewInfos[I].ResetState;
end;

procedure TcxGridGroupRowViewInfo.SetFixedState(AValue: TcxDataControllerRowFixedState);
begin
  FIsFixed := AValue = rfsFixedToTop;
end;

procedure TcxGridGroupRowViewInfo.SetRowHeight(Value: Integer);
begin
  if RowHeight <> Value then
    GridView.OptionsView.GroupRowHeight := Value - NonBaseHeight;
end;

function TcxGridGroupRowViewInfo.GetBorderBounds(AIndex: TcxBorder): TRect;
begin
  Result := inherited GetBorderBounds(AIndex);
  if HasElongateBottomBorder then
    if UseRightToLeftAlignment then
      Result.Right := FBottomBorderLeftPosition
    else
      Result.Left := FBottomBorderLeftPosition;
end;

function TcxGridGroupRowViewInfo.GetBorderColor(AIndex: TcxBorder): TColor;
begin
  Result := GridViewInfo.GridLineColor;
end;

function TcxGridGroupRowViewInfo.GetBorders: TcxBorders;
begin
  Result := inherited GetBorders;
  if HasElongateBottomBorder then
    Result := [bBottom];
  if UseLightBorders then
    Exclude(Result, bRight);
end;

function TcxGridGroupRowViewInfo.GetBorderWidth(AIndex: TcxBorder): Integer;
begin
  Result := GridViewInfo.GridLineWidth;
end;

function TcxGridGroupRowViewInfo.GetExpandButtonOwnerCellBounds: TRect;
begin
  Result := MainGroupedColumnAreaViewInfo.CellViewInfo.ContentBounds;
end;

function TcxGridGroupRowViewInfo.GetGridRecord: TcxGridGroupRow;
begin
  Result := TcxGridGroupRow(inherited GridRecord);
end;

function TcxGridGroupRowViewInfo.GetGroupedColumnAreaViewInfoCount: Integer;
begin
  Result := FGroupedColumnAreaViewInfos.Count;
end;

function TcxGridGroupRowViewInfo.GetGroupedColumnAreaViewInfo(AIndex: Integer): TcxGridGroupRowGroupedColumnAreaViewInfo;
begin
  Result := TcxGridGroupRowGroupedColumnAreaViewInfo(FGroupedColumnAreaViewInfos[AIndex]);
end;

function TcxGridGroupRowViewInfo.GetMainGroupedColumnAreaViewInfo: TcxGridGroupRowGroupedColumnAreaViewInfo;
begin
  Result := GroupedColumnAreaViewInfos[0];
end;

function TcxGridGroupRowViewInfo.GetRowStyle: TcxGridGroupRowStyle;
begin
  Result := GridView.OptionsView.GroupRowStyle;
end;

function TcxGridGroupRowViewInfo.GetSummaryCellLayout: TcxGridGroupSummaryLayout;
begin
  if GridRecord.GroupedColumnCount = 1 then
    Result := GridView.OptionsView.GetGroupSummaryLayout
  else
    Result := gslStandard;
end;

end.
