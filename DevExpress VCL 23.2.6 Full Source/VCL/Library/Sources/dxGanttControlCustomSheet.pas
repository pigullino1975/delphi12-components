{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressGanttControl                                      }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSGANTTCONTROL AND ALL           }
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

unit dxGanttControlCustomSheet;

{$I cxVer.inc}
{$I dxGanttControl.inc}

interface

uses
  System.UITypes, System.Contnrs,
  Types, SysUtils, Classes, Graphics, ImgList, Windows, Controls,
  Generics.Defaults, Generics.Collections, Forms, StdCtrls, Variants,
  dxCore, dxCoreClasses, dxCoreGraphics, dxGenerics, cxGraphics, cxCustomCanvas, cxGeometry, cxClasses, cxListBox,
  dxGDIPlusClasses, cxControls, cxVariants, cxEdit, cxDropDownEdit, dxUIElementPopupWindow, cxTextEdit,
  cxDrawTextUtils, cxLookAndFeels, cxLookAndFeelPainters, dxTouch, cxStorage,
  dxGanttControlCustomClasses,
  dxGanttControlCommands;

type
  TdxGanttControlSheetCustomViewInfo = class;
  TdxGanttControlSheetHeaderViewInfo = class;
  TdxGanttControlSheetColumnHeaderViewInfo = class;
  TdxGanttControlSheetRowHeaderViewInfo = class;
  TdxGanttControlSheetDataRowViewInfo = class;
  TdxGanttControlSheetColumns = class;
  TdxGanttControlSheetOptions = class;
  TdxGanttControlSheetColumn = class;
  TdxGanttControlSheetDragHelper = class;
  TdxGanttSheetColumnQuickCustomizationPopup = class;
  TdxGanttControlSheetController = class;
  TdxGanttControlSheetCustomDataProvider = class;

  TdxGanttControlSheetColumnClass = class of TdxGanttControlSheetColumn;

  { TdxGanttControlSheetControllerHistoryItem }

  TdxGanttControlSheetControllerHistoryItem = class(TdxGanttControlHistoryItem)
  strict private
    FController: TdxGanttControlSheetController;
  public
    constructor Create(AController: TdxGanttControlSheetController); reintroduce; virtual;
    property Controller: TdxGanttControlSheetController read FController;
  end;

  { TdxGanttControlSheetResizeHistoryItem }

  TdxGanttControlSheetResizeHistoryItem = class(TdxGanttControlSheetControllerHistoryItem)
  strict private
    FOldWidth: Integer;
  protected
    FColumn: TdxGanttControlSheetColumn;
    FNewWidth: Integer;
    procedure DoRedo; override;
    procedure DoUndo; override;
  end;

  { TdxGanttControlSheetChangeRowHeaderWidthHistoryItem }

  TdxGanttControlSheetChangeRowHeaderWidthHistoryItem = class(TdxGanttControlSheetControllerHistoryItem)
  strict private
    FOldWidth: Integer;
  protected
    FNewWidth: Integer;
    procedure DoRedo; override;
    procedure DoUndo; override;
  end;

  { TdxGanttControlSheetToggleItemExpandStateHistoryItem }

  TdxGanttControlSheetToggleItemExpandStateHistoryItem = class(TdxGanttControlSheetControllerHistoryItem)
  protected
    FData: TObject;
    FIsExpanded: Boolean;

    procedure DoRedo; override;
    procedure DoUndo; override;
  end;

  { TdxGanttControlSheetChangeValueHistoryItem }

  TdxGanttControlSheetChangeValueHistoryItem = class abstract(TdxGanttControlSheetControllerHistoryItem)
  protected
    FData: TObject;
    FNewValue: Variant;
    FOldValue: Variant;

    function GetEditValue: Variant; virtual; abstract;
    procedure SetEditValue(const Value: Variant); virtual; abstract;

    procedure DoRedo; override;
    procedure DoUndo; override;
  end;

  { TdxGanttControlSheetFocusedCellChangeHistoryItem }

  TdxGanttControlSheetFocusedCellChangeHistoryItem = class(TdxGanttControlSheetControllerHistoryItem)
  protected
    FFirstVisibleCell: TPoint;
    FFocusedCell: TPoint;
    procedure DoRedo; override;
    procedure DoUndo; override;
  end;

  { TdxGanttControlDataItemHistoryItem }

  TdxGanttControlDataItemHistoryItem = class abstract(TdxGanttControlSheetControllerHistoryItem)
  protected
    FDataItem: TObject;
    FIndex: Integer;
  public
    destructor Destroy; override;
    property Index: Integer read FIndex write FIndex;
  end;

  { TdxGanttControlAppendDataItemHistoryItem }

  TdxGanttControlAppendDataItemHistoryItem = class(TdxGanttControlDataItemHistoryItem)
  protected
    procedure DoRedo; override;
    procedure DoUndo; override;
  end;

  { TdxGanttControlDeleteDataItemHistoryItem }

  TdxGanttControlDeleteDataItemHistoryItem = class(TdxGanttControlDataItemHistoryItem)
  protected
    procedure DoRedo; override;
    procedure DoUndo; override;
  end;

  { TdxGanttControlInsertDataItemHistoryItem }

  TdxGanttControlInsertDataItemHistoryItem = class(TdxGanttControlDataItemHistoryItem)
  protected
    procedure DoRedo; override;
    procedure DoUndo; override;
  end;

  { TdxGanttControlSheetMoveColumnHistoryItem }

  TdxGanttControlSheetMoveColumnHistoryItem = class(TdxGanttControlSheetControllerHistoryItem)
  protected
    FCurrentIndex: Integer;
    FNewIndex: Integer;
    FFirstVisibleColumnIndex: Integer;
    FNewFirstVisibleColumnIndex: Integer;
    procedure DoRedo; override;
    procedure DoUndo; override;
  end;

  { TdxGanttControlSheetHideColumnHistoryItem }

  TdxGanttControlSheetHideColumnHistoryItem = class(TdxGanttControlSheetControllerHistoryItem)
  protected
    FColumnIndex: Integer;
    FFirstVisibleColumnIndex: Integer;
    FNewFirstVisibleColumnIndex: Integer;
    procedure DoRedo; override;
    procedure DoUndo; override;
  end;

  { TdxGanttControlSheetRenameColumnHistoryItem }

  TdxGanttControlSheetRenameColumnHistoryItem = class(TdxGanttControlSheetControllerHistoryItem)
  strict private
    FOldValue: string;
  protected
    FColumnIndex: Integer;
    FNewValue: string;
    procedure DoRedo; override;
    procedure DoUndo; override;
  end;

  { TdxGanttControlSheetShowColumnHistoryItem }

  TdxGanttControlSheetShowColumnHistoryItem = class(TdxGanttControlSheetControllerHistoryItem)
  protected
    FColumnIndex: Integer;
    procedure DoRedo; override;
    procedure DoUndo; override;
  end;

  { TdxGanttControlSheetCommand }

  TdxGanttControlSheetCommand = class(TdxGanttControlCommand)
  strict private
    FController: TdxGanttControlSheetController;
  protected
    property Controller: TdxGanttControlSheetController read FController;
  public
    constructor Create(AController: TdxGanttControlSheetController); reintroduce; virtual;
  end;

  { TdxGanttControlSheetColumnCommand }

  TdxGanttControlSheetColumnCommand = class(TdxGanttControlSheetCommand)
  strict private
    FColumn: TdxGanttControlSheetColumn;
  protected
    property Column: TdxGanttControlSheetColumn read FColumn;
  public
    constructor Create(AController: TdxGanttControlSheetController;
      AColumn: TdxGanttControlSheetColumn); reintroduce;
  end;

  { TdxGanttControlSheetResizeColumnCommand }

  TdxGanttControlSheetResizeColumnCommand = class(TdxGanttControlSheetColumnCommand)
  strict private
    FNewWidth: Integer;
  protected
    procedure DoExecute; override;
  public
    constructor Create(AController: TdxGanttControlSheetController;
      AColumn: TdxGanttControlSheetColumn; ANewWidth: Integer); reintroduce; virtual;
    function Enabled: Boolean; override;
  end;

  { TdxGanttControlSheetRenameColumnCommand }

  TdxGanttControlSheetRenameColumnCommand = class(TdxGanttControlSheetColumnCommand)
  strict private
    FNewValue: string;
  protected
    procedure DoExecute; override;
  public
    constructor Create(AController: TdxGanttControlSheetController;
      AColumn: TdxGanttControlSheetColumn; const ANewValue: string); reintroduce;
    function Enabled: Boolean; override;
  end;

  { TdxGanttControlSheetChangeRowHeaderWidthCommand }

  TdxGanttControlSheetChangeRowHeaderWidthCommand = class(TdxGanttControlSheetCommand)
  strict private
    FNewWidth: Integer;
  protected
    procedure DoExecute; override;
  public
    constructor Create(AController: TdxGanttControlSheetController; ANewWidth: Integer); reintroduce;
    function Enabled: Boolean; override;
  end;

  { TdxGanttControlSheetChangeCellCommand }

  TdxGanttControlSheetChangeCellCommand = class(TdxGanttControlSheetCommand)
  strict private
    function GetController: TdxGanttControlSheetController; inline;
  protected
    FColumn: TdxGanttControlSheetColumn;
    FData: TObject;
    procedure AppendItems(ACount: Integer);
    procedure SaveCellPosition;
    property Controller: TdxGanttControlSheetController read GetController;
  public
    constructor Create(AController: TdxGanttControlSheetController); reintroduce;
    function Enabled: Boolean; override;
  end;

  { TdxGanttControlSheetDeleteFocusedItemCommand }

  TdxGanttControlSheetDeleteFocusedItemCommand = class abstract(TdxGanttControlSheetChangeCellCommand)
  protected
    procedure BeforeExecute; override;
  public
    function Enabled: Boolean; override;
  end;

  { TdxGanttControlSheetMoveFocusedItemCommand }

  TdxGanttControlSheetMoveFocusedItemCommand = class(TdxGanttControlSheetChangeCellCommand)
  strict private
    FDataItem: TObject;
    FNewFocusedRowIndex: Integer;
    FNewIndex: Integer;
  protected
    procedure AfterExecute; override;
    procedure BeforeExecute; override;
    procedure DoExecute; override;

    procedure DeleteItem;

    property DataItem: TObject read FDataItem;
  public
    constructor Create(AController: TdxGanttControlSheetController; ANewIndex, ANewFocusedRowIndex: Integer); reintroduce;
    function Enabled: Boolean; override;
  end;

  { TdxGanttControlSheetInsertNewItemCommand }

  TdxGanttControlSheetInsertNewItemCommand = class(TdxGanttControlSheetChangeCellCommand)
  protected
    procedure BeforeExecute; override;
    procedure DoExecute; override;
  end;

  { TdxGanttControlSheetChangeCellValueCommand }

  TdxGanttControlSheetChangeCellValueCommand = class(TdxGanttControlSheetChangeCellCommand)
  strict private
    function CreateDataItem: TObject;
  protected
    FNewValue: Variant;
    function CreateChangeValueCommand: TdxGanttControlCommand; virtual;
    procedure DoExecute; override;
  public
    constructor Create(AController: TdxGanttControlSheetController; const ANewValue: Variant); reintroduce;
    function Enabled: Boolean; override;
  end;

  { TdxGanttControlSheetToggleItemExpandStateCommand }

  TdxGanttControlSheetToggleItemExpandStateCommand = class(TdxGanttControlSheetChangeCellCommand)
  protected
    procedure DoExecute; override;
  public
    function Enabled: Boolean; override;
  end;

  { TdxGanttControlSheetExpandItemCommand }

  TdxGanttControlSheetExpandItemCommand = class(TdxGanttControlSheetToggleItemExpandStateCommand)
  public
    function Enabled: Boolean; override;
  end;

  { TdxGanttControlSheetCollapseItemCommand }

  TdxGanttControlSheetCollapseItemCommand = class(TdxGanttControlSheetToggleItemExpandStateCommand)
  public
    function Enabled: Boolean; override;
  end;

  { TdxGanttControlSheetMoveColumnCommand }

  TdxGanttControlSheetMoveColumnCommand = class(TdxGanttControlSheetCommand)
  strict private
    FCurrentIndex: Integer;
    FNewIndex: Integer;
    FFirstVisibleColumnIndex: Integer;
    FNewFirstVisibleColumnIndex: Integer;
    procedure SaveCellPosition;
  protected
    procedure BeforeExecute; override;
    procedure DoExecute; override;
  public
    constructor Create(AController: TdxGanttControlSheetController; ACurrentIndex, ANewIndex: Integer; AFirstVisibleColumnIndex: Integer = -1); reintroduce;
    function Enabled: Boolean; override;
  end;

  { TdxGanttControlSheetHideColumnCommand }

  TdxGanttControlSheetHideColumnCommand = class(TdxGanttControlSheetCommand)
  strict private
    FColumnIndex: Integer;
    FFirstVisibleColumnIndex: Integer;
    FNewFirstVisibleColumnIndex: Integer;
  protected
    procedure DoExecute; override;
  public
    constructor Create(AController: TdxGanttControlSheetController; AColumnIndex: Integer; AFirstVisibleColumnIndex: Integer = -1); reintroduce;
    function Enabled: Boolean; override;
  end;

  { TdxGanttControlSheetShowColumnCommand }

  TdxGanttControlSheetShowColumnCommand = class(TdxGanttControlSheetCommand)
  strict private
    FColumnIndex: Integer;
  protected
    procedure DoExecute; override;
  public
    constructor Create(AController: TdxGanttControlSheetController; AColumnIndex: Integer); reintroduce;
    function Enabled: Boolean; override;
  end;

  { TdxGanttControlSheetAddColumnCommand }

  TdxGanttControlSheetAddColumnCommand = class(TdxGanttControlSheetCommand)
  strict private
    FColumnClass: TdxGanttControlSheetColumnClass;
  protected
    procedure DoExecute; override;
  public
    constructor Create(AController: TdxGanttControlSheetController; AColumnClass: TdxGanttControlSheetColumnClass); reintroduce;
    function Enabled: Boolean; override;
  end;

  { TdxGanttControlSheetCellCustomViewInfo }

  TdxGanttControlSheetCellCustomViewInfo = class abstract(TdxGanttControlCustomParentViewInfo)
  strict private
    FColumn: TdxGanttControlSheetColumn;
    FColumnViewInfo: TdxGanttControlSheetHeaderViewInfo;
    function GetOwner: TdxGanttControlSheetDataRowViewInfo; inline;
  protected
    function CalculateBestFit: Integer; virtual;
    function IsFocused: Boolean; virtual;
    function GetFont: TFont; virtual;

    procedure UpdateColumnViewInfo(AColumnViewInfo: TdxGanttControlSheetHeaderViewInfo);

    property ColumnViewInfo: TdxGanttControlSheetHeaderViewInfo read FColumnViewInfo;
  public
    constructor Create(AOwner: TdxGanttControlSheetDataRowViewInfo;
      AColumnViewInfo: TdxGanttControlSheetColumnHeaderViewInfo;
      AColumn: TdxGanttControlSheetColumn); reintroduce; virtual;

    function MeasureHeight(AWidth: Integer): Integer; virtual;

    property Column: TdxGanttControlSheetColumn read FColumn;
    property Owner: TdxGanttControlSheetDataRowViewInfo read GetOwner;
  end;

  { TdxGanttControlSheetCellViewInfo }

  TdxGanttControlSheetCellViewInfo = class(TdxGanttControlSheetCellCustomViewInfo)
  strict private
    function GetEditValue: Variant;
  protected
    function GetCurrentCursor(const P: TPoint; const ADefaultCursor: TCursor): TCursor; override;
    property EditValue: Variant read GetEditValue;
  end;
  TdxGanttControlSheetCellViewInfoClass = class of TdxGanttControlSheetCellViewInfo;

  { TdxGanttControlSheetEmptyCellViewInfo }

  TdxGanttControlSheetEmptyCellViewInfo = class(TdxGanttControlSheetCellViewInfo)
  protected
    function IsFocused: Boolean; override;
  end;

  { TdxGanttControlSheetDataRowViewInfo }

  TdxGanttControlSheetDataRowViewInfo = class(TdxGanttControlCustomParentViewInfo)
  strict private
    FCells: TObjectList<TdxGanttControlSheetCellCustomViewInfo>;
    FData: TObject;
    FHeaderViewInfo: TdxGanttControlSheetRowHeaderViewInfo;
    FIndex: Integer;
    FLineBounds: TRect;
    function GetOwner: TdxGanttControlSheetCustomViewInfo; inline;
  protected
    function CalculateHitTest(const AHitTest: TdxGanttControlHitTest): Boolean; override;
    procedure DoDraw; override;
    procedure DoScroll(const DX: Integer; const DY: Integer); override;
    function IsFocused: Boolean;
    function IsFullyVisible: Boolean;
    function IsOdd: Boolean;
    function IsSelected: Boolean;

    procedure UpdateIndex(const Value: Integer);

    property Cells: TObjectList<TdxGanttControlSheetCellCustomViewInfo> read FCells;
    property Index: Integer read FIndex;
    property LineBounds: TRect read FLineBounds;
  public
    constructor Create(AOwner: TdxGanttControlSheetCustomViewInfo; AIndex: Integer; AData: TObject); reintroduce;
    destructor Destroy; override;

    procedure Calculate(const R: TRect); override;
    procedure CalculateLayout; override;
    procedure ViewChanged; override;

    function MeasureHeight: Integer;

    property Data: TObject read FData;
    property HeaderViewInfo: TdxGanttControlSheetRowHeaderViewInfo read FHeaderViewInfo;
    property Owner: TdxGanttControlSheetCustomViewInfo read GetOwner;
  end;

  { TdxGanttControlSheetCellStringValueViewInfo }

  TdxGanttControlSheetCellStringValueViewInfo = class(TdxGanttControlSheetCellViewInfo)
  strict private
    FDisplayText: string;
    FTextBounds: TRect;
    FTextLayout: TcxCanvasBasedTextLayout;
  protected
    function CalculateBestFit: Integer; override;
    function CalculateTextBounds: TRect; virtual;
    function CalculateDisplayText: string;
    function DoCalculateDisplayText: string; virtual;
    procedure DoDraw; override;
    procedure DoScroll(const DX: Integer; const DY: Integer); override;
    function GetDrawTextFlags: Integer; virtual;
    function GetEditBounds: TRect; override;
    function GetHintPoint: TPoint; override;
    function GetHintText: string; override;
    function HasDisplayText: Boolean; virtual;
    function HasHint: Boolean; override;
    function MultilineSupports: Boolean; virtual;
  public
    constructor Create(AOwner: TdxGanttControlSheetDataRowViewInfo;
      AColumnViewInfo: TdxGanttControlSheetColumnHeaderViewInfo;
      AColumn: TdxGanttControlSheetColumn); override;
    destructor Destroy; override;
    procedure Calculate(const R: TRect); override;
    procedure CalculateLayout; override;
    function MeasureHeight(AWidth: Integer): Integer; override;

    property TextBounds: TRect read FTextBounds;
  end;

  { TdxGanttControlSheetHeaderViewInfo }

  TdxGanttControlSheetHeaderViewInfo = class(TdxGanttControlCustomParentViewInfo)
  strict private
    function GetOwner: TdxGanttControlSheetCustomViewInfo; inline;
  protected
    FCaption: string;
    FTextBounds: TRect;
    FTextLayout: TcxCanvasBasedTextLayout;
    FSelectedRect: TRect;

    procedure DrawBackground(AViewInfo: TdxGanttControlCustomOwnedItemViewInfo;
      ABorders: TcxBorders; ANeighbors: TcxNeighbors);
    function IsHotState(AViewInfo: TdxGanttControlCustomOwnedItemViewInfo): Boolean;

    procedure DoDraw; override;
    procedure DoScroll(const DX: Integer; const DY: Integer); override;

    function CalculateSelectedRect: TRect; virtual;
    procedure CalculateTextBounds(const R: TRect); virtual;
    function GetBorders: TcxBorders; virtual;
    function GetCurrentCursor(const P: TPoint; const ADefaultCursor: TCursor): TCursor; override;
    function GetDrawTextFlags: Integer; virtual;
    function GetMinWidth: Integer; virtual;
    function GetNeighbors: TcxNeighbors; virtual;
    function GetTextColor: TColor; overload;
    function GetTextColor(AState: TcxButtonState): TColor; overload;
    function GetTextHorizontalAlignment: TcxTextAlignX; virtual;
    function GetTextVerticalAlignment: TcxTextAlignY; virtual;
    function HasHotTrackState: Boolean; override;
    function HasPressedState: Boolean; override;
    function IsMovingZone(const P: TPoint): Boolean; virtual;
    function IsSizingZone(const P: TPoint): Boolean; virtual;
  public
    constructor Create(AOwner: TdxGanttControlCustomItemViewInfo); override;
    destructor Destroy; override;
    procedure Calculate(const R: TRect); override;

    property Owner: TdxGanttControlSheetCustomViewInfo read GetOwner;
  end;

  { TdxGanttControlSheetColumnHeaderViewInfo }

  TdxGanttControlSheetColumnHeaderViewInfo = class(TdxGanttControlSheetHeaderViewInfo)
  strict private
    FColumn: TdxGanttControlSheetColumn;
  protected
    FButtonBounds: TRect;
    function CalculateBestFit: Integer; virtual;
    function CalculateItemBounds(AItem: TdxGanttControlCustomItemViewInfo): TRect; override;
    function CalculateSelectedRect: TRect; override;
    procedure CalculateTextBounds(const R: TRect); override;
    function GetBorders: TcxBorders; override;
    function GetCaption: string; virtual;
    function GetCurrentCursor(const P: TPoint; const ADefaultCursor: TCursor): TCursor; override;
    function GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass; virtual;
    function GetHintText: string; override; final;
    function GetMinWidth: Integer; override;
    function GetNeighbors: TcxNeighbors; override;
    function GetTextHorizontalAlignment: TcxTextAlignX; override;
    function GetTextVerticalAlignment: TcxTextAlignY; override;
    function HasHint: Boolean; override;
    function HasHotTrackState: Boolean; override;
    function HasPressedState: Boolean; override;
    function IsMovingZone(const P: TPoint): Boolean; override;
    function IsPressed: Boolean; override;
    function IsSizingZone(const P: TPoint): Boolean; override;
  public
    constructor Create(AOwner: TdxGanttControlSheetCustomViewInfo; AColumn: TdxGanttControlSheetColumn); reintroduce;
    procedure Calculate(const R: TRect); override;

    property Column: TdxGanttControlSheetColumn read FColumn;
  end;

  { TdxGanttControlSheetColumnHeaderImageViewInfo }

  TdxGanttControlSheetColumnHeaderImageViewInfo = class abstract(TdxGanttControlSheetColumnHeaderViewInfo)
  strict private
    FImage: TdxGPImage;
    FImageRect: TRect;
  protected
    function CalculateBestFit: Integer; override;
    function CalculateImage: TdxGPImage; virtual; abstract;
    function CalculateImageBounds: TRect; virtual;
    procedure CalculateTextBounds(const R: TRect); override;
    procedure DoDraw; override;
  public
    procedure Calculate(const R: TRect); override;
  end;

  { TdxGanttControlSheetColumnHeaderFilterButtonViewInfo }

  TdxGanttControlSheetColumnHeaderFilterButtonViewInfo = class(TdxGanttControlCustomOwnedItemViewInfo)
  strict private
    function GetOwner: TdxGanttControlSheetColumnHeaderViewInfo; inline;
  protected
    procedure DoDraw; override;
    function GetCurrentCursor(const P: TPoint; const ADefaultCursor: TCursor): TCursor; override;
    function HasHotTrackState: Boolean; override;
  public
    property Owner: TdxGanttControlSheetColumnHeaderViewInfo read GetOwner;
  end;

  { TdxGanttControlSheetColumnEmptyHeaderViewInfo }

  TdxGanttControlSheetColumnEmptyHeaderViewInfo = class(TdxGanttControlSheetHeaderViewInfo)
  protected
    function GetBorders: TcxBorders; override;
    function GetCurrentCursor(const P: TPoint; const ADefaultCursor: TCursor): TCursor; override;
    function GetNeighbors: TcxNeighbors; override;
    function HasHotTrackState: Boolean; override;
  end;

  { TdxGanttControlSheetColumnInsertHeaderViewInfo }

  TdxGanttControlSheetColumnInsertHeaderViewInfo = class(TdxGanttControlSheetColumnHeaderViewInfo)
  protected
    function GetBorders: TcxBorders; override;
    function GetCaption: string; override;
    function GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass; override;
    function GetNeighbors: TcxNeighbors; override;
    function HasHint: Boolean; override;
    function HasHotTrackState: Boolean; override;
    function HasPressedState: Boolean; override;
    function IsMovingZone(const P: TPoint): Boolean; override;
    function IsSizingZone(const P: TPoint): Boolean; override;
  public
    constructor Create(AOwner: TdxGanttControlSheetCustomViewInfo); reintroduce;
  end;

  { TdxGanttControlSheetRowHeaderViewInfo }

  TdxGanttControlSheetRowHeaderViewInfo = class(TdxGanttControlSheetHeaderViewInfo)
  strict private
    FDataRow: TdxGanttControlSheetDataRowViewInfo;
    function GetData: TObject; inline;
  protected
    function GetCurrentCursor(const P: TPoint; const ADefaultCursor: TCursor): TCursor; override;
    function GetBorders: TcxBorders; override;
    function GetDrawTextFlags: Integer; override;
    function GetHeaderPadding: TdxPadding; override;
    function GetMinWidth: Integer; override;
    function GetNeighbors: TcxNeighbors; override;
    function HasPressedState: Boolean; override;
    function IsMovingZone(const P: TPoint): Boolean; override;
    function IsPressed: Boolean; override;
  public
    constructor Create(AOwner: TdxGanttControlSheetCustomViewInfo; ADataRow: TdxGanttControlSheetDataRowViewInfo); reintroduce;

    property Data: TObject read GetData;
    property DataRow: TdxGanttControlSheetDataRowViewInfo read FDataRow;
  end;

  { TdxGanttControlSheetHeaderGripViewInfo }

  TdxGanttControlSheetHeaderGripViewInfo = class(TdxGanttControlSheetHeaderViewInfo)
  protected
    function CalculateItemBounds(AItem: TdxGanttControlCustomItemViewInfo): TRect; override;
    function GetBorders: TcxBorders; override;
    function GetMinWidth: Integer; override;
    function GetNeighbors: TcxNeighbors; override;
    function HasHotTrackState: Boolean; override;
  public
    procedure Calculate(const R: TRect); override;
  end;

  { TdxGanttControlSheetColumnQuickCustomizationButtonViewInfo }

  TdxGanttControlSheetColumnQuickCustomizationButtonViewInfo = class(TdxGanttControlCustomOwnedItemViewInfo)
  strict private
    function GetOwner: TdxGanttControlSheetHeaderGripViewInfo; inline;
  protected
    procedure DoDraw; override;
    function GetCurrentCursor(const P: TPoint; const ADefaultCursor: TCursor): TCursor; override;
    function HasHotTrackState: Boolean; override;
    function HasPressedState: Boolean; override;
    function IsPressed: Boolean; override;
  public
    property Owner: TdxGanttControlSheetHeaderGripViewInfo read GetOwner;
  end;

  { TdxGanttControlSheetCustomViewInfo }

  TdxGanttControlSheetCustomViewInfo = class abstract(TdxGanttControlCustomParentViewInfo)
  strict private
    FCachedImageHeight: Integer;
    FCachedDataRowHeight: TdxObjectIntegerDictionary;
    FClientRect: TRect;
    FDataRows: TObjectList<TdxGanttControlSheetDataRowViewInfo>;
    FFocusedCellViewInfo: TdxGanttControlSheetCellCustomViewInfo;
    FGridlines: TdxRectList;
    FHeaders: TObjectList<TdxGanttControlSheetHeaderViewInfo>;
    FOptions: TdxGanttControlSheetOptions;
    FVisibleColumnCount: Integer;
    procedure AppendDataRow(ARowIndex: Integer);
    procedure AppendDataRows;
    procedure CalculateDataRows;
    function CalculateFocusedCellViewInfo: TdxGanttControlSheetCellCustomViewInfo;
    procedure CalculateGridlines;
    procedure CalculateHeaders;
    procedure DrawSelection;
    function GetController: TdxGanttControlSheetController; inline;
    function GetImageHeight: Integer;
    function GetFocusedCellViewInfo: TdxGanttControlSheetCellCustomViewInfo;
    function GetVisibleRowCount: Integer;
  protected
    FDataProvider: TdxGanttControlSheetCustomDataProvider;
    FFirstVisibleColumnIndex: Integer;
    FFirstVisibleRowIndex: Integer;

    function CalculateClientRect: TRect; virtual;
    function CalculateHitTest(const AHitTest: TdxGanttControlHitTest): Boolean; override;
    procedure CalculateScrollBars; virtual;
    procedure Clear; override;
    procedure DoDraw; override;
    procedure DrawSizeGrip; virtual;
    function GetColumnHeaderHeight: Integer; virtual;
    function GetFocusedCell: TPoint; virtual;
    procedure ResetFocusedCellViewInfo;

    procedure Reset; override;

    function GetQuickCustomizationPopupOwnerBounds: TRect;

    function GetCellViewInfo(const P: TPoint): TdxGanttControlSheetCellCustomViewInfo;

    function AreExpandButtonsVisible: Boolean; virtual;
    function IsTouchModeEnabled: Boolean; virtual;
    procedure UpdateCachedValues; virtual;

    property CachedDataRowHeight: TdxObjectIntegerDictionary read FCachedDataRowHeight;
    property Controller: TdxGanttControlSheetController read GetController;
    property DataProvider: TdxGanttControlSheetCustomDataProvider read FDataProvider;
    property DataRows: TObjectList<TdxGanttControlSheetDataRowViewInfo> read FDataRows;
    property FocusedCell: TPoint read GetFocusedCell;
    property FocusedCellViewInfo: TdxGanttControlSheetCellCustomViewInfo read GetFocusedCellViewInfo;
    property ImageHeight: Integer read GetImageHeight;
    property Headers: TObjectList<TdxGanttControlSheetHeaderViewInfo> read FHeaders;
    property VisibleColumnCount: Integer read FVisibleColumnCount;
    property VisibleRowCount: Integer read GetVisibleRowCount;
  public
    constructor Create(AOwner: TdxGanttControlCustomItemViewInfo;
      AOptions: TdxGanttControlSheetOptions); reintroduce;
    destructor Destroy; override;

    procedure Calculate(const R: TRect); override;
    procedure ViewChanged; override;

    property ClientRect: TRect read FClientRect;
    property ColumnHeaderHeight: Integer read GetColumnHeaderHeight;
    property Options: TdxGanttControlSheetOptions read FOptions;
  end;

  { TdxGanttControlSheetColumn }

  TdxGanttControlSheetColumn = class(TcxInterfacedPersistent, IcxStoredObject)
  public const
    DefaultWidth = 100;
    MinWidth = 25;
  strict private
    FAllowHide: TdxDefaultBoolean;
    FAllowInsert: TdxDefaultBoolean;
    FAllowMove: TdxDefaultBoolean;
    FAllowRename: TdxDefaultBoolean;
    FAllowSize: TdxDefaultBoolean;
    FAllowWordWrap: TdxDefaultBoolean;
    FCaption: string;
    FIsCaptionAssigned: Boolean;
    FProperties: TcxCustomEditProperties;
    FShowFilterButton: Boolean;
    FStoringIndex: Integer;
    FStoringUID: Integer;
    FVisible: Boolean;
    FWidth: Integer;
    FWordWrap: Boolean;

    // IcxStoredObject events
    FOnGetStoredProperties: TcxGetStoredPropertiesEvent;
    FOnGetStoredPropertyValue: TcxGetStoredPropertyValueEvent;
    FOnSetStoredPropertyValue: TcxSetStoredPropertyValueEvent;

    function IsAllowRenameStored: Boolean;
    function IsAllowWordWrapStored: Boolean;
    function IsCaptionStored: Boolean;
    function IsShowFilterButtonStored: Boolean;
    function IsVisibleStored: Boolean;
    function IsWidthStored: Boolean;
    function IsWordWrapStored: Boolean;
    function GetCaption: string; inline;
    function GetCollection: TdxGanttControlSheetColumns; inline;
    function GetIndex: Integer;
    function GetScaleFactor: TdxScaleFactor; inline;
    function GetVisibleIndex: Integer;
    procedure SetCaption(const Value: string);
    procedure SetIndex(const Value: Integer);
    procedure SetShowFilterButton(const Value: Boolean);
    procedure SetVisible(const Value: Boolean);
    procedure SetWidth(const Value: Integer);
    procedure SetWordWrap(const Value: Boolean);
  protected
    procedure Changed; virtual;
    procedure DoReset; virtual;

    procedure DefineProperties(Filer: TFiler); override;
    procedure ReadUID(Reader: TReader);
    procedure WriteProperties(Writer: TWriter); virtual;

    function CanShowFilterButton: Boolean; virtual;
    function CreateProperties: TcxCustomEditProperties; virtual;
    function CreateViewInfo(ASheetViewInfo: TdxGanttControlSheetCustomViewInfo): TdxGanttControlSheetColumnHeaderViewInfo; virtual;
    function CreateChangeValueCommand(AControl: TdxGanttControlBase; ADataItem: TObject; const ANewValue: Variant): TdxGanttControlCommand; virtual;
    function IsEditable: Boolean; virtual;
    function GetAlignment: TAlignment; virtual;
    function GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass; virtual;
    function GetDefaultAllowRename: TdxDefaultBoolean; virtual;
    function GetDefaultAllowWordWrap: TdxDefaultBoolean; virtual;
    function GetDefaultCaption: string; virtual;
    function GetDefaultShowFilterButton: Boolean; virtual;
    function GetDefaultImageIndex: Integer; virtual;
    function GetDefaultVisible: Boolean; virtual;
    function GetDefaultWidth: Integer; virtual;
    function GetDefaultWordWrap: Boolean; virtual;
    class function GetDesignCaption: string; virtual;
    function GetHintText: string; virtual;
    function GetPropertiesClass: TcxCustomEditPropertiesClass; virtual;
    procedure PrepareEditProperties(AProperties: TcxCustomEditProperties; AData: TObject); virtual;
    function ShowEditorImmediately: Boolean; virtual;

    procedure DoCaptionChanged(const ANewCaption: string); virtual;

    function GetEditValue(AData: TObject): Variant; virtual;
    procedure RecreateProperties;

    function RealAllowHide: Boolean;
    function RealAllowInsert: Boolean;
    function RealAllowMove: Boolean;
    function RealAllowRename: Boolean;
    function RealAllowSize: Boolean;
    function RealAllowWordWrap: Boolean;

    // IcxStoredObject
    function GetObjectName: string;
    function GetProperties(AProperties: TStrings): Boolean; virtual;
    procedure GetPropertyValue(const AName: string; var AValue: Variant); virtual;
    procedure SetPropertyValue(const AName: string; const AValue: Variant); virtual;

    property Properties: TcxCustomEditProperties read FProperties;
    property ScaleFactor: TdxScaleFactor read GetScaleFactor;
    property ShowFilterButton: Boolean read FShowFilterButton write SetShowFilterButton stored IsShowFilterButtonStored;
    property StoringIndex: Integer read FStoringIndex;
    property StoringUID: Integer read FStoringUID;
    property VisibleIndex: Integer read GetVisibleIndex;
  public
    constructor Create(AOwner: TdxGanttControlSheetColumns); reintroduce; virtual;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure Reset;

    property Index: Integer read GetIndex write SetIndex;
    property Owner: TdxGanttControlSheetColumns read GetCollection;
  published
    property AllowHide: TdxDefaultBoolean read FAllowHide write FAllowHide default bDefault;
    property AllowInsert: TdxDefaultBoolean read FAllowInsert write FAllowInsert default bDefault;
    property AllowMove: TdxDefaultBoolean read FAllowMove write FAllowMove default bDefault;
    property AllowRename: TdxDefaultBoolean read FAllowRename write FAllowRename stored IsAllowRenameStored;
    property AllowSize: TdxDefaultBoolean read FAllowSize write FAllowSize default bDefault;
    property AllowWordWrap: TdxDefaultBoolean read FAllowWordWrap write FAllowWordWrap stored IsAllowWordWrapStored;
    property Caption: string read GetCaption write SetCaption stored IsCaptionStored;
    property Visible: Boolean read FVisible write SetVisible stored IsVisibleStored;
    property Width: Integer read FWidth write SetWidth stored IsWidthStored;
    property WordWrap: Boolean read FWordWrap write SetWordWrap stored IsWordWrapStored;
    // IcxStoredObject events
    property OnGetStoredProperties: TcxGetStoredPropertiesEvent read FOnGetStoredProperties write FOnGetStoredProperties;
    property OnGetStoredPropertyValue: TcxGetStoredPropertyValueEvent read FOnGetStoredPropertyValue write FOnGetStoredPropertyValue;
    property OnSetStoredPropertyValue: TcxSetStoredPropertyValueEvent read FOnSetStoredPropertyValue write FOnSetStoredPropertyValue;
  end;

  { TdxGanttControlSheetColumns }

  TdxGanttControlSheetColumns = class(TcxInterfacedPersistent, IcxStoredObject, IcxStoredParent)
  strict private
    FList: TObjectList<TdxGanttControlSheetColumn>;
    FLockCount: Integer;
    FRegisteredColumnClasses: TList<TdxGanttControlSheetColumnClass>;

    // IcxStoredObject events
    FOnInitStoredObject: TcxInitStoredObjectEvent;

    procedure DataReaderHandler(Reader: TReader);
    procedure DataWriterHandler(Writer: TWriter);

    function GetCount: Integer;
    function GetItem(Index: Integer): TdxGanttControlSheetColumn;
    function GetScaleFactor: TdxScaleFactor; inline;
    function InternalGetOwner: TdxGanttControlSheetOptions;
    function GetVisibleCount: Integer;
    function GetVisibleItem(Index: Integer): TdxGanttControlSheetColumn;
    procedure SetItem(Index: Integer; const Value: TdxGanttControlSheetColumn);
    // IcxStoredParent
    function IcxStoredParent.CreateChild = StoredCreateChild;
    procedure IcxStoredParent.DeleteChild = StoredDeleteChild;
    procedure IcxStoredParent.GetChildren = StoredChildren;
  protected
    procedure DefineProperties(Filer: TFiler); override;

    procedure Changed;
    procedure Clear;
    procedure DoReset;
    function GetStoringUID(AColumn: TdxGanttControlSheetColumn): Integer;
    function GetVisibleIndex(AItem: TdxGanttControlSheetColumn): Integer;
    procedure Extract(AItem: TdxGanttControlSheetColumn);
    function IndexOf(AItem: TdxGanttControlSheetColumn): Integer;
    procedure Move(ACurrentIndex, ANewIndex: Integer);

    procedure RegisterColumnClass(AClass: TdxGanttControlSheetColumnClass);
    procedure RegisterColumnClasses; virtual;

    // IcxStoredObject }
    function GetObjectName: string; virtual;
    function GetProperties(AProperties: TStrings): Boolean; virtual;
    procedure GetPropertyValue(const AName: string; var AValue: Variant); virtual;
    procedure Restored; virtual;
    procedure SetPropertyValue(const AName: string; const AValue: Variant); virtual;
    // IcxStoredParent implementation
    procedure DoInitStoredObject(AObject: TObject); virtual;
    function StoredCreateChild(const AObjectName, AClassName: string): TObject; virtual;
    procedure StoredDeleteChild(const AObjectName: string; AObject: TObject); virtual;
    procedure StoredChildren(AChildren: TStringList); virtual;

    property List: TObjectList<TdxGanttControlSheetColumn> read FList;
    property RegisteredColumnClasses: TList<TdxGanttControlSheetColumnClass> read FRegisteredColumnClasses;
    property ScaleFactor: TdxScaleFactor read GetScaleFactor;
    property VisibleCount: Integer read GetVisibleCount;
    property VisibleItems[Index: Integer]: TdxGanttControlSheetColumn read GetVisibleItem;
  public
    constructor Create(AOwner: TdxGanttControlSheetOptions); reintroduce; virtual;
    destructor Destroy; override;
    procedure AfterConstruction; override;

    function Add(AClass: TdxGanttControlSheetColumnClass): TdxGanttControlSheetColumn;
    procedure Delete(AIndex: Integer);
    function Insert(AIndex: Integer; AClass: TdxGanttControlSheetColumnClass): TdxGanttControlSheetColumn;
    procedure Remove(AItem: TdxGanttControlSheetColumn);
    procedure Reset;

    procedure BeginUpdate;
    procedure EndUpdate;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TdxGanttControlSheetColumn read GetItem write SetItem; default;
    property Owner: TdxGanttControlSheetOptions read InternalGetOwner;
  published
    // IcxStoredObject events
    property OnInitStoredObject: TcxInitStoredObjectEvent read FOnInitStoredObject write FOnInitStoredObject;
  end;

  { TdxGanttControlSheetCustomDataProvider }

  TdxGanttControlSheetCustomDataProvider = class abstract(TdxGanttControlCustomDataProvider)
  protected
    procedure InternalAppendItem; virtual; abstract;
    procedure InternalInsertNewItem(AIndex: Integer); virtual; abstract;
    procedure InternalExtractLastItem; virtual; abstract;
    procedure InternalExtractItem(AIndex: Integer); virtual; abstract;
    procedure InternalInsertItem(AIndex: Integer; ADataItem: TObject); virtual; abstract;
    function InternalIndexOf(AItem: TObject): Integer; override;

    function CanMove(ACurrentIndex, ANewIndex: Integer): Boolean; virtual;
    function GetDataItemIndex(ADataItem: TObject): Integer; virtual; abstract;
    function GetRowHeaderCaption(AData: TObject): string; virtual;
    function IsBlank(ADataItem: TObject): Boolean; virtual;
    procedure MoveDataItem(AData: TObject; ANewIndex: Integer); virtual;
  end;

  { TdxGanttControlSheetEditingController }

  TdxGanttControlSheetEditingController = class(TcxCustomEditingController) // for internal use
  strict private type
    TActivateEditProc = reference to procedure;
  strict private
    FController: TdxGanttControlSheetController;
    FEditData: TcxCustomEditData;
    procedure AssignEditStyle;
    function GetFocusedCellViewInfo: TdxGanttControlSheetCellViewInfo;
    function GetEditBounds: TRect;
    procedure PrepareCanvas;
  protected
    function CanInitEditing: Boolean; override;
    procedure ClearEditingItem; override;
    procedure DoHideEdit(Accept: Boolean); override;
    procedure DoUpdateEdit; override;
    function GetCancelEditingOnExit: Boolean; override;
    function GetEditParent: TWinControl; override;
    function GetHideEditOnExit: Boolean; override;
    function GetHideEditOnFocusedRecordChange: Boolean; override;
    function GetFocusedCellBounds: TRect; override;
    function GetIsEditing: Boolean; override;
    function GetValue: Variant; override;
    procedure SetValue(const AValue: Variant); override;
    procedure StartEditingByTimer; override;
    procedure UpdateInplaceParamsPosition; override;

    procedure EditAfterKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); override;
    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); override;
    procedure EditKeyPress(Sender: TObject; var Key: Char); override;
    procedure EditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState); override;

    function PrepareEdit(AIsMouseEvent: Boolean): Boolean;
    procedure UpdateEditPosition;

    procedure DoShowEdit(AProc: TActivateEditProc);

    property FocusedCellViewInfo: TdxGanttControlSheetCellViewInfo read GetFocusedCellViewInfo;
    property Controller: TdxGanttControlSheetController read FController;
  public
    constructor Create(AController: TdxGanttControlSheetController); reintroduce;
    destructor Destroy; override;

    procedure ShowEdit; override;
    procedure ShowEditByKey(const AChar: Char);
    procedure ShowEditByMouse;
  end;

  { TdxGanttControlSheetResizingObject }

  TdxGanttControlSheetResizingObject = class abstract(TdxGanttControlResizingObject) // for internal use
  public const
    Width = 1;
  strict private
    FViewInfo: TdxGanttControlSheetHeaderViewInfo;
    function GetController: TdxGanttControlSheetController; inline;
    function GetHelper: TdxGanttControlSheetDragHelper; inline;
  protected
    procedure ApplyChanges(const P: TPoint); override;
    function CanDrop(const P: TPoint): Boolean; override;
    procedure DragAndDrop(const P: TPoint; var Accepted: Boolean); override;
    function GetDragImageHeight: Integer; override;
    function GetDragImageWidth: Integer; override;
    procedure SetWidth(const Value: Integer); virtual; abstract;
    property ViewInfo: TdxGanttControlSheetHeaderViewInfo read FViewInfo;
  public
    constructor Create(AController: TdxGanttControlCustomController; AViewInfo: TdxGanttControlSheetHeaderViewInfo); reintroduce;

    property Controller: TdxGanttControlSheetController read GetController;
    property Helper: TdxGanttControlSheetDragHelper read GetHelper;
  end;

  { TdxGanttControlSheetColumnResizingObject }

  TdxGanttControlSheetColumnResizingObject = class(TdxGanttControlSheetResizingObject) // for internal use
  strict private
    function GetViewInfo: TdxGanttControlSheetColumnHeaderViewInfo; inline;
  protected
    procedure SetWidth(const Value: Integer); override;
    property ViewInfo: TdxGanttControlSheetColumnHeaderViewInfo read GetViewInfo;
  end;

  { TdxGanttControlSheetRowHeaderWidthResizingObject }

  TdxGanttControlSheetRowHeaderWidthResizingObject = class(TdxGanttControlSheetResizingObject) // for internal use
  protected
    procedure SetWidth(const Value: Integer); override;
  end;

  { TdxGanttControlSheetMovingObject }

  TdxGanttControlSheetMovingObject = class(TdxGanttControlMovingObject) // for internal use
  strict private
    function GetController: TdxGanttControlSheetController; inline;
  protected
    procedure AfterDragAndDrop(Accepted: Boolean); override;
  public
    constructor Create(AController: TdxGanttControlCustomController); reintroduce;
    property Controller: TdxGanttControlSheetController read GetController;
  end;

  { TdxGanttControlSheetColumnMovingObject }

  TdxGanttControlSheetColumnMovingObject = class(TdxGanttControlSheetMovingObject) // for internal use
  strict private
    FColumn: TdxGanttControlSheetColumn;
    FFirstVisibleColumnIndex: Integer;
    FTopArrowLocation: TPoint;
    function GetHitViewInfo(const P: TPoint): TdxGanttControlSheetHeaderViewInfo;
    function GetNewIndex(AHitViewInfo: TdxGanttControlSheetHeaderViewInfo; const P: TPoint): Integer;
  protected
    procedure ApplyChanges(const P: TPoint); override;
    function CanDrop(const P: TPoint): Boolean; override;
    function CreateDragImage: TcxDragImage; override;
    procedure DragAndDrop(const P: TPoint; var Accepted: Boolean); override;
    function GetDragAndDropCursor(Accepted: Boolean): TCursor; override;
    function VerticalScrollingSupports: Boolean; override;
  public
    constructor Create(AController: TdxGanttControlCustomController; AColumn: TdxGanttControlSheetColumn); reintroduce;
    property Column: TdxGanttControlSheetColumn read FColumn;
  end;

  { TdxGanttControlSheetRowMovingObject }

  TdxGanttControlSheetRowMovingObject = class(TdxGanttControlSheetMovingObject) // for internal use
  strict private
    FDataItem: TObject;
    FIndex: Integer;
    FLeftArrowLocation: TPoint;
    FRowIndex: Integer;
    function GetNewIndex(AHitViewInfo: TdxGanttControlSheetRowHeaderViewInfo; const P: TPoint): Integer;
    function GetFocusedNewIndex(AHitViewInfo: TdxGanttControlSheetRowHeaderViewInfo; const P: TPoint): Integer;
  protected
    procedure ApplyChanges(const P: TPoint); override;
    function CanDrop(const P: TPoint): Boolean; override;
    function CreateDragImage: TcxDragImage; override;
    procedure DragAndDrop(const P: TPoint; var Accepted: Boolean); override;
    function HorizontalScrollingSupports: Boolean; override;
  public
    constructor Create(AController: TdxGanttControlCustomController; ARowIndex: Integer); reintroduce;
    property Index: Integer read FIndex;
    property RowIndex: Integer read FRowIndex;
  end;

  { TdxGanttControlSheetDragHelper }

  TdxGanttControlSheetDragHelper = class(TdxGanttControlDragHelper) // for internal use
  strict private
    FHitPoint: TPoint;
    function GetController: TdxGanttControlSheetController; inline;
    function CreateColumnMovingObject(AViewInfo: TdxGanttControlSheetColumnHeaderViewInfo): TdxGanttControlSheetColumnMovingObject;
    function CreateColumnResizingObject(AViewInfo: TdxGanttControlSheetColumnHeaderViewInfo): TdxGanttControlSheetColumnResizingObject;
    function CreateRowHeaderWidthResizingObject(AViewInfo: TdxGanttControlSheetHeaderViewInfo): TdxGanttControlSheetRowHeaderWidthResizingObject;
    function CreateRowMovingObject(AViewInfo: TdxGanttControlSheetRowHeaderViewInfo): TdxGanttControlSheetRowMovingObject;
  protected
    function CreateDragAndDropObject: TdxGanttControlDragAndDropObject; override;
    procedure EndDragAndDrop(Accepted: Boolean); override;
    function StartDragAndDrop(const P: TPoint): Boolean; override;

    function CalculateResizePoint(AViewInfo: TdxGanttControlSheetHeaderViewInfo; const P: TPoint): TPoint;
    function CreateDragAndDropObjectByPoint(const P: TPoint): TdxGanttControlDragAndDropObject; virtual;
    procedure DoScroll; override;
    function GetScrollableArea: TRect; override;
  public
    property Controller: TdxGanttControlSheetController read GetController;
  end;

  { TdxGanttSheetScrollBars }

  TdxGanttSheetScrollBars = class(TdxGanttControlCustomScrollBars) // for internal use
  strict private
    function GetController: TdxGanttControlSheetController; inline;
  protected
    procedure DoHScroll(ScrollCode: TScrollCode; var ScrollPos: Integer); override;
    procedure DoVScroll(ScrollCode: TScrollCode; var ScrollPos: Integer); override;
    procedure DoInitHScrollBarParameters; override;
    procedure DoInitVScrollBarParameters; override;
    function IsUnlimitedScrolling(AScrollKind: TScrollBarKind; ADeltaX, ADeltaY: Integer): Boolean; override;
  public
    property Controller: TdxGanttControlSheetController read GetController;
  end;

  { TdxGanttSheetQuickCustomizationControl }

  TdxGanttSheetQuickCustomizationControl = class(TdxQuickCustomizationCustomControl) // for internal use
  strict private
    procedure CheckSortItems;

    procedure ShowAllClickHandler(Sender: TObject);
    procedure SortItemsClickHandler(Sender: TObject);

    function GetCheckingAllState: TcxCheckBoxState;
    function GetPopup: TdxGanttSheetColumnQuickCustomizationPopup; inline;
  protected
    procedure CheckShowAll;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure PopulateCheckListBox; override;
    procedure PopulateCommandListBox; override;
  public
    property Popup: TdxGanttSheetColumnQuickCustomizationPopup read GetPopup;
  end;

  { TdxGanttSheetColumnQuickCustomizationPopup }

  TdxGanttSheetColumnQuickCustomizationPopup = class(TdxUIElementPopupWindow) // for internal use
  private
    FController: TdxGanttControlSheetController;
    FCustomizationControl: TdxGanttSheetQuickCustomizationControl;
    procedure ChangeColumnVisible(AItemIndex: Integer);
    procedure CheckListBoxActionHandler(Sender: TdxCustomListBox; AItemIndex: Integer);
    procedure CheckListBoxDragDropHandler(Sender, Source: TObject; X, Y: Integer);
    procedure CheckListBoxItemDragOverHandler(AItem: Pointer; var AAccept: Boolean);
    procedure CheckListSelectedItemCheckedStateChangedHandler(Sender: TObject);
  protected
    procedure InitPopup; override;
    procedure Paint; override;
  public
    constructor Create(AController: TdxGanttControlSheetController); reintroduce; virtual;
    destructor Destroy; override;
    procedure CloseUp; override;
    procedure CorrectBoundsWithDesktopWorkArea(var APosition: TPoint; var ASize: TSize); override;

    property Controller: TdxGanttControlSheetController read FController;
    property CustomizationControl: TdxGanttSheetQuickCustomizationControl read FCustomizationControl;
  end;

  { TdxGanttControlSheetController }

  TdxGanttControlSheetController = class(TdxGanttControlCustomController,
    IdxUIElementPopupWindowOwner)
  strict private
    FCaptureColumn: TdxGanttControlSheetColumn;
    FColumnQuickCustomizationPopup: TdxGanttSheetColumnQuickCustomizationPopup;
    FEditingController: TdxGanttControlSheetEditingController;
    FFirstVisibleColumnIndex: Integer;
    FFirstVisibleRowIndex: Integer;
    FFocusedCell: TPoint;
    FColumnRenameEdit: TcxCustomTextEdit;
    FColumnInsertEdit: TcxCustomComboBox;
    FColumnInsertEditIndex: Integer;
    FIsColumnQuickCustomizationPopupVisible: Boolean;
    FOptions: TdxGanttControlSheetOptions;
    FScrollBars: TdxGanttSheetScrollBars;

    procedure ColumnRenameEditExitHandler(Sender: TObject);
    procedure ColumnRenameEditKeyDownHandler(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure HideColumnRenameEdit(Accept, ASetControlFocus: Boolean);

    procedure ColumnInsertEditExitHandler(Sender: TObject);
    procedure ColumnInsertEditKeyDownHandler(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ColumnInsertEditValueChanged(Sender: TObject);
    procedure HideColumnInsertEdit(Accept, ASetControlFocus: Boolean);

    function GetColumnQuickCustomizationPopup: TdxGanttSheetColumnQuickCustomizationPopup; inline;
    function GetDataProvider: TdxGanttControlSheetCustomDataProvider; inline;
    function GetFocusedCellViewInfo: TdxGanttControlSheetCellCustomViewInfo;
    function GetFocusedColumnIndex: Integer;
    function GetFocusedDataItem: TObject;
    function GetFocusedRowIndex: Integer;
    function GetRealVisibleColumnCount: Integer; inline;
    function InternalGetViewInfo: TdxGanttControlSheetCustomViewInfo; inline;
    procedure SetFirstVisibleColumnIndex(const Value: Integer);
    procedure SetFirstVisibleRowIndex(const Value: Integer);
    procedure InternalSetFocusedCell(const Value: TPoint);
    procedure SetFocusedColumnIndex(const Value: Integer);
    procedure SetFocusedRowIndex(const Value: Integer);
  protected
    function CreateScrollBars: TdxGanttSheetScrollBars; virtual;
    procedure DeleteFocusedItem; virtual; abstract;
    procedure DoCreateScrollBars; override;
    procedure DoDestroyScrollBars; override;
    function GetTouchScrollUIOwner(const APoint: TPoint): IdxTouchScrollUIOwner; override;
    function GetDesignHitTest(X: Integer; Y: Integer; Shift: TShiftState): Boolean; override;
    function ProcessNCSizeChanged: Boolean; override;

    procedure CalculateBestFit(AColumn: TdxGanttControlSheetColumn);

    function CanShowColumnHint(AColumn: TdxGanttControlSheetColumn): Boolean;

    function CreateColumnRenameEdit: TcxCustomTextEdit;
    function GetColumnEditBounds(AColumnViewInfo: TdxGanttControlSheetColumnHeaderViewInfo): TRect;
    procedure ShowColumnEdit(AEdit: TcxCustomEdit; AColumnViewInfo: TdxGanttControlSheetColumnHeaderViewInfo);
    procedure ShowColumnRenameEdit(AColumn: TdxGanttControlSheetColumn);

    function CreateColumnInsertEdit: TcxCustomComboBox;
    procedure ShowColumnInsertEdit(AColumn: TdxGanttControlSheetColumn);
    procedure ShowChooseColumnDetailsDialog;

    procedure InitScrollbars; override;
    procedure InsertNewDataItem; virtual;
    function IsPanArea(const APoint: TPoint): Boolean; override;
    procedure UnInitScrollbars; override;

    procedure ResetFirstVisibleColumnIndex;

    function CanAutoScroll(ADirection: TcxDirection): Boolean; override;
    function CreateDragHelper: TdxGanttControlDragHelper; override;
    function GetGestureClient(const APoint: TPoint): IdxGestureClient; override;

    function CreateEditingController: TdxGanttControlSheetEditingController; virtual;

    function IsActive: Boolean;
    function IsEditing: Boolean;

    procedure DoClick; override;
    procedure DoDblClick; override;
    procedure DoMouseDown(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer); override;
    procedure DoMouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer); override;
    function DoMouseWheel(Shift: TShiftState; AIsIncrement: Boolean; const AMousePos: TPoint): Boolean; override;

    procedure DoKeyDown(var Key: Word; Shift: TShiftState); override;
    procedure DoKeyPress(var Key: Char); override;

    function CreateChangeCellValueCommand(const AValue: Variant): TdxGanttControlSheetChangeCellValueCommand;

    procedure HideEditing; override;

    function CalculateFirstVisibleColumnIndex(AVisibleColumnIndex: Integer): Integer;
    function CalculateFirstVisibleRowIndex(AVisibleRowIndex: Integer): Integer;
    procedure MakeCellVisible(const P: TPoint);
    procedure MakeColumnVisible(AColumn: TdxGanttControlSheetColumn); overload;
    procedure MakeColumnVisible(AColumnIndex: Integer); overload;
    procedure MakeFocusedCellVisible;
    procedure SetFocusedCell(ACell: TdxGanttControlSheetCellViewInfo);
    procedure ValidateFocusedCell;

    procedure CollapseItem;
    procedure ExpandItem;
    function HasItemExpandState(AItem: TObject): Boolean; virtual;
    procedure ToggleExpandState(AItem: TObject);

    procedure ShowColumnQuickCustomizationPopup;

    function GetVisibleRowCount: Integer; virtual;

  {$REGION 'IdxUIElementPopupWindowOwner'}
    function ClosePopupWhenSetNil: Boolean;
    procedure InitPopup(APopup: TdxUIElementPopupWindow);
    procedure PopupClosed;
  {$ENDREGION 'IdxUIElementPopupWindowOwner'}

    property CaptureColumn: TdxGanttControlSheetColumn read FCaptureColumn;
    property ColumnQuickCustomizationPopup: TdxGanttSheetColumnQuickCustomizationPopup read GetColumnQuickCustomizationPopup;
    property ColumnInsertEditIndex: Integer read FColumnInsertEditIndex;
    property DataProvider: TdxGanttControlSheetCustomDataProvider read GetDataProvider;
    property EditingController: TdxGanttControlSheetEditingController read FEditingController;
    property FocusedCell: TPoint read FFocusedCell write InternalSetFocusedCell;
    property FocusedCellViewInfo: TdxGanttControlSheetCellCustomViewInfo read GetFocusedCellViewInfo;
    property FocusedDataItem: TObject read GetFocusedDataItem;
    property Options: TdxGanttControlSheetOptions read FOptions;
    property RealVisibleColumnCount: Integer read GetRealVisibleColumnCount;
    property ScrollBars: TdxGanttSheetScrollBars read FScrollBars;
    property ViewInfo: TdxGanttControlSheetCustomViewInfo read InternalGetViewInfo;
  public
    constructor Create(AControl: TdxGanttControlBase; AOptions: TdxGanttControlSheetOptions); reintroduce;
    destructor Destroy; override;

    property FirstVisibleColumnIndex: Integer read FFirstVisibleColumnIndex write SetFirstVisibleColumnIndex;
    property FirstVisibleRowIndex: Integer read FFirstVisibleRowIndex write SetFirstVisibleRowIndex;
    property FocusedColumnIndex: Integer read GetFocusedColumnIndex write SetFocusedColumnIndex;
    property FocusedRowIndex: Integer read GetFocusedRowIndex write SetFocusedRowIndex;
  end;

  { TdxGanttControlSheetOptions }

  TdxGanttControlSheetInitEditEvent = procedure(Sender: TObject;
    AColumn: TdxGanttControlSheetColumn; AEdit: TcxCustomEdit) of object;
  TdxGanttControlSheetEditingEvent = procedure(Sender: TObject;
    AColumn: TdxGanttControlSheetColumn; var AAllow: Boolean) of object;
  TdxGanttControlSheetColumnEvent = procedure(Sender: TObject; AColumn: TdxGanttControlSheetColumn) of object;

  TdxGanttControlSheetOptions = class abstract(TdxGanttControlCustomOptions, IcxStoredObject, IcxStoredParent)
  protected const
    DefaultRowHeaderWidth = 35;
    DefaultFilterButtonWidth = 19;
    RowHeaderMinWidth = 25;
  strict private
    FAlwaysShowEditor: TdxDefaultBoolean;
    FCellAutoHeight: Boolean;
    FAllowColumnDetailCustomization: Boolean;
    FAllowColumnHide: Boolean;
    FAllowColumnInsert: Boolean;
    FAllowColumnMove: Boolean;
    FAllowColumnRename: Boolean;
    FAllowColumnSize: Boolean;
    FAllowRowMove: Boolean;
    FColumnQuickCustomization: Boolean;
    FColumnQuickCustomizationSorted: Boolean;
    FColumns: TdxGanttControlSheetColumns;
    FRowHeaderWidth: Integer;
    FRowHeight: Integer;

    FOnBeforeEdit: TdxGanttControlSheetEditingEvent;
    FOnEditValueChanged: TdxGanttControlSheetColumnEvent;
    FOnInitEdit: TdxGanttControlSheetInitEditEvent;

    FOnFirstVisibleColumnIndexChanged: TNotifyEvent;
    FOnFirstVisibleRowIndexChanged: TNotifyEvent;
    FOnFocusedColumnIndexChanged: TNotifyEvent;
    FOnFocusedRowIndexChanged: TNotifyEvent;

    FOnColumnCaptionChanged: TdxGanttControlSheetColumnEvent;
    FOnColumnPositionChanged: TdxGanttControlSheetColumnEvent;
    FOnColumnSizeChanged: TdxGanttControlSheetColumnEvent;
    FOnColumnVisibilityChanged: TdxGanttControlSheetColumnEvent;
    FOnColumnWordWrapChanged: TdxGanttControlSheetColumnEvent;

    // IcxStoredObject events
    FOnGetStoredProperties: TcxGetStoredPropertiesEvent;
    FOnGetStoredPropertyValue: TcxGetStoredPropertyValueEvent;
    FOnSetStoredPropertyValue: TcxSetStoredPropertyValueEvent;

    function GetControl: TdxGanttControlBase; inline;
    procedure SetCellAutoHeight(const Value: Boolean);
    procedure SetColumnQuickCustomization(const Value: Boolean);
    procedure SetColumns(const Value: TdxGanttControlSheetColumns);
    procedure SetRowHeaderWidth(const Value: Integer);
    procedure SetRowHeight(const Value: Integer);
    // IcxStoredParent
    function IcxStoredParent.CreateChild = StoredCreateChild;
    procedure IcxStoredParent.DeleteChild = StoredDeleteChild;
    procedure IcxStoredParent.GetChildren = StoredChildren;
  protected
    procedure DoAssign(Source: TPersistent); override;
    procedure DoChanged(AChanges: TdxGanttControlOptionsChangedTypes); override;
    procedure DoReset; override;

    function CreateColumns: TdxGanttControlSheetColumns; virtual;
    function GetDataProvider: TdxGanttControlSheetCustomDataProvider; virtual; abstract;
    function GetOwnerComponent: TComponent; virtual; abstract;
    function GetController: TdxGanttControlSheetController; virtual; abstract;
    function GetRealAlwaysShowEditor: Boolean; virtual;

    function DoBeforeEdit(AColumn: TdxGanttControlSheetColumn): Boolean; virtual;
    procedure DoEditValueChanged(AColumn: TdxGanttControlSheetColumn); virtual;
    procedure DoInitEdit(AColumn: TdxGanttControlSheetColumn; AEdit: TcxCustomEdit); virtual;
    procedure DoFirstVisibleColumnIndexChanged; virtual;
    procedure DoFirstVisibleRowIndexChanged; virtual;
    procedure DoFocusedColumnIndexChanged; virtual;
    procedure DoFocusedRowIndexChanged; virtual;

    function CanRowDrag(ADataItem: TObject): Boolean;
    function DoRowStartDrag(ADataItem: TObject): Boolean; virtual;
    function DoRowDragAndDrop(ADataItem: TObject; ANewIndex: Integer): Boolean; virtual;
    procedure DoRowEndDrag(ADataItem: TObject); virtual;

    procedure ClearCachedDataRowHeight;

    procedure DoColumnCaptionChanged(AColumn: TdxGanttControlSheetColumn);
    procedure DoColumnPositionChanged(AColumn: TdxGanttControlSheetColumn);
    procedure DoColumnSizeChanged(AColumn: TdxGanttControlSheetColumn);
    procedure DoColumnVisibilityChanged(AColumn: TdxGanttControlSheetColumn);
    procedure DoColumnWordWrapChanged(AColumn: TdxGanttControlSheetColumn);

    function IsReadOnly: Boolean; virtual;

    // IcxStoredObject }
    function GetObjectName: string; virtual;
    function GetProperties(AProperties: TStrings): Boolean; virtual;
    procedure GetPropertyValue(const AName: string; var AValue: Variant); virtual;
    procedure SetPropertyValue(const AName: string; const AValue: Variant); virtual;
    // IcxStoredParent implementation
    function StoredCreateChild(const AObjectName, AClassName: string): TObject; virtual;
    procedure StoredDeleteChild(const AObjectName: string; AObject: TObject); virtual;
    procedure StoredChildren(AChildren: TStringList); virtual;

    property AllowRowMove: Boolean read FAllowRowMove write FAllowRowMove default True;
    property ColumnQuickCustomizationSorted: Boolean read FColumnQuickCustomizationSorted write FColumnQuickCustomizationSorted;
    property RealAlwaysShowEditor: Boolean read GetRealAlwaysShowEditor;
  public
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;

    property Columns: TdxGanttControlSheetColumns read FColumns write SetColumns;
    property Control: TdxGanttControlBase read GetControl; // for internal use
    property Controller: TdxGanttControlSheetController read GetController; // for internal use
    property DataProvider: TdxGanttControlSheetCustomDataProvider read GetDataProvider; // for internal use
    property RowHeight: Integer read FRowHeight write SetRowHeight default 0;
  published
    property AllowColumnDetailCustomization: Boolean read FAllowColumnDetailCustomization write FAllowColumnDetailCustomization default True;
    property AllowColumnHide: Boolean read FAllowColumnHide write FAllowColumnHide default True;
    property AllowColumnInsert: Boolean read FAllowColumnInsert write FAllowColumnInsert default True;
    property AllowColumnMove: Boolean read FAllowColumnMove write FAllowColumnMove default True;
    property AllowColumnRename: Boolean read FAllowColumnRename write FAllowColumnRename default True;
    property AllowColumnSize: Boolean read FAllowColumnSize write FAllowColumnSize default True;
    property AlwaysShowEditor: TdxDefaultBoolean read FAlwaysShowEditor write FAlwaysShowEditor default bDefault;
    property CellAutoHeight: Boolean read FCellAutoHeight write SetCellAutoHeight default True;
    property ColumnQuickCustomization: Boolean read FColumnQuickCustomization write SetColumnQuickCustomization default False;
    property RowHeaderWidth: Integer read FRowHeaderWidth write SetRowHeaderWidth default DefaultRowHeaderWidth;

    property OnBeforeEdit: TdxGanttControlSheetEditingEvent read FOnBeforeEdit write FOnBeforeEdit;
    property OnEditValueChanged: TdxGanttControlSheetColumnEvent read FOnEditValueChanged write FOnEditValueChanged;
    property OnInitEdit: TdxGanttControlSheetInitEditEvent read FOnInitEdit write FOnInitEdit;
    property OnFirstVisibleColumnIndexChanged: TNotifyEvent read FOnFirstVisibleColumnIndexChanged write FOnFirstVisibleColumnIndexChanged;
    property OnFirstVisibleRowIndexChanged: TNotifyEvent read FOnFirstVisibleRowIndexChanged write FOnFirstVisibleRowIndexChanged;
    property OnFocusedColumnIndexChanged: TNotifyEvent read FOnFocusedColumnIndexChanged write FOnFocusedColumnIndexChanged;
    property OnFocusedRowIndexChanged: TNotifyEvent read FOnFocusedRowIndexChanged write FOnFocusedRowIndexChanged;
    property OnColumnCaptionChanged: TdxGanttControlSheetColumnEvent read FOnColumnCaptionChanged write FOnColumnCaptionChanged;
    property OnColumnPositionChanged: TdxGanttControlSheetColumnEvent read FOnColumnPositionChanged write FOnColumnPositionChanged;
    property OnColumnSizeChanged: TdxGanttControlSheetColumnEvent read FOnColumnSizeChanged write FOnColumnSizeChanged;
    property OnColumnVisibilityChanged: TdxGanttControlSheetColumnEvent read FOnColumnVisibilityChanged write FOnColumnVisibilityChanged;
    property OnColumnWordWrapChanged: TdxGanttControlSheetColumnEvent read FOnColumnWordWrapChanged write FOnColumnWordWrapChanged;
    // IcxStoredObject events
    property OnGetStoredProperties: TcxGetStoredPropertiesEvent read FOnGetStoredProperties write FOnGetStoredProperties;
    property OnGetStoredPropertyValue: TcxGetStoredPropertyValueEvent read FOnGetStoredPropertyValue write FOnGetStoredPropertyValue;
    property OnSetStoredPropertyValue: TcxSetStoredPropertyValueEvent read FOnSetStoredPropertyValue write FOnSetStoredPropertyValue;
  end;

implementation

uses
  Math, TypInfo, RTLConsts,
  dxTypeHelpers, cxLibraryStrs,
  dxGanttControlUtils,
  dxGanttControlStrs,
  dxGanttControlCursors,
  dxGanttControl,
  dxGanttControlSheetChooseDetailsDialog;

const
  dxThisUnitName = 'dxGanttControlCustomSheet';

type
  TcxCustomDragImageAccess = class(TcxCustomDragImage);
  TWriterAccess = class(TWriter);
  TReaderAccess = class(TReader);
  TcxCustomLookAndFeelPainterAccess = class(TcxCustomLookAndFeelPainter);
  TcxCustomEditAccess = class(TcxCustomEdit);
  TcxCustomEditStyleAccess = class(TcxCustomEditStyle);
  TdxGanttControlBaseAccess = class(TdxGanttControlBase);
  TdxGanttControlCustomOwnedItemViewInfoAccess = class(TdxGanttControlCustomOwnedItemViewInfo);
  TdxCustomCheckListBoxAccess = class(TdxCustomCheckListBox);
  TdxGanttControlCustomItemViewInfoAccess = class(TdxGanttControlCustomItemViewInfo);

  { TdxGanttControlSheetColumnsComparer }

  TdxGanttControlSheetColumnsComparer = class(TInterfacedObject, IComparer<TdxGanttControlSheetColumn>)
  protected
    function Compare(const Left, Right: TdxGanttControlSheetColumn): Integer;
  end;

function TdxGanttControlSheetColumnsComparer.Compare(const Left, Right: TdxGanttControlSheetColumn): Integer;
begin
  Result := Left.StoringIndex - Right.StoringIndex;
end;

{ TdxGanttControlSheetControllerHistoryItem }

constructor TdxGanttControlSheetControllerHistoryItem.Create(AController: TdxGanttControlSheetController);
begin
  inherited Create(AController.Control.History);
  FController := AController;
end;

{ TdxGanttControlSheetResizeHistoryItem }

procedure TdxGanttControlSheetResizeHistoryItem.DoRedo;
begin
  FOldWidth := FColumn.Width;
  FColumn.Width := FNewWidth;
end;

procedure TdxGanttControlSheetResizeHistoryItem.DoUndo;
begin
  FColumn.Width := FOldWidth;
end;

{ TdxGanttControlSheetChangeRowHeaderWidthHistoryItem }

procedure TdxGanttControlSheetChangeRowHeaderWidthHistoryItem.DoRedo;
begin
  FOldWidth := Controller.Options.RowHeaderWidth;
  Controller.Options.RowHeaderWidth := FNewWidth;
end;

procedure TdxGanttControlSheetChangeRowHeaderWidthHistoryItem.DoUndo;
begin
  Controller.Options.RowHeaderWidth := FOldWidth;
end;

{ TdxGanttControlSheetToggleItemExpandStateHistoryItem }

procedure TdxGanttControlSheetToggleItemExpandStateHistoryItem.DoRedo;
begin
  inherited DoRedo;
  if FIsExpanded then
    Controller.DataProvider.Collapse(FData)
  else
    Controller.DataProvider.Expand(FData);
end;

procedure TdxGanttControlSheetToggleItemExpandStateHistoryItem.DoUndo;
begin
  if not FIsExpanded then
    Controller.DataProvider.Collapse(FData)
  else
    Controller.DataProvider.Expand(FData);
  inherited DoUndo;
end;

{ TdxGanttControlSheetChangeValueHistoryItem }

procedure TdxGanttControlSheetChangeValueHistoryItem.DoRedo;
begin
  inherited DoRedo;
  FOldValue := GetEditValue;
  SetEditValue(FNewValue);
end;

procedure TdxGanttControlSheetChangeValueHistoryItem.DoUndo;
begin
  SetEditValue(FOldValue);
  inherited DoUndo;
end;

{ TdxGanttControlSheetFocusedCellChangeHistoryItem }

procedure TdxGanttControlSheetFocusedCellChangeHistoryItem.DoRedo;
begin
  inherited DoRedo;
  Controller.FocusedCell := FFocusedCell;
  Controller.FirstVisibleColumnIndex := FFirstVisibleCell.X;
  Controller.FirstVisibleRowIndex := FFirstVisibleCell.Y;
end;

procedure TdxGanttControlSheetFocusedCellChangeHistoryItem.DoUndo;
begin
  Controller.FocusedCell := FFocusedCell;
  Controller.FirstVisibleColumnIndex := FFirstVisibleCell.X;
  Controller.FirstVisibleRowIndex := FFirstVisibleCell.Y;
  inherited DoUndo;
end;

{ TdxGanttControlDataItemHistoryItem }

destructor TdxGanttControlDataItemHistoryItem.Destroy;
begin
  FreeAndNil(FDataItem);
  inherited Destroy;
end;

{ TdxGanttControlAppendDataItemHistoryItem }

procedure TdxGanttControlAppendDataItemHistoryItem.DoRedo;
begin
  inherited DoRedo;
  if FDataItem = nil then
    Controller.DataProvider.InternalAppendItem
  else
    Controller.DataProvider.InternalInsertItem(FIndex, FDataItem);
  FDataItem := nil;
end;

procedure TdxGanttControlAppendDataItemHistoryItem.DoUndo;
begin
  FDataItem := Controller.DataProvider.LastDataItem;
  FIndex := Controller.DataProvider.DataItemCount - 1;
  Controller.DataProvider.InternalExtractLastItem;
  inherited DoUndo;
end;

{ TdxGanttControlDeleteDataItemHistoryItem }

procedure TdxGanttControlDeleteDataItemHistoryItem.DoRedo;
begin
  FDataItem := Controller.DataProvider.DataItems[FIndex];
  Controller.DataProvider.InternalExtractItem(FIndex);
  inherited DoRedo;
end;

procedure TdxGanttControlDeleteDataItemHistoryItem.DoUndo;
begin
  Controller.DataProvider.InternalInsertItem(FIndex, FDataItem);
  FDataItem := nil;
  inherited DoUndo;
end;

{ TdxGanttControlInsertDataItemHistoryItem }

procedure TdxGanttControlInsertDataItemHistoryItem.DoRedo;
begin
  inherited DoRedo;
  if FDataItem = nil then
    Controller.DataProvider.InternalInsertNewItem(FIndex)
  else
    Controller.DataProvider.InternalInsertItem(FIndex, FDataItem);
  FDataItem := nil;
end;

procedure TdxGanttControlInsertDataItemHistoryItem.DoUndo;
begin
  inherited DoUndo;
  FDataItem := Controller.DataProvider.DataItems[FIndex];
  Controller.DataProvider.InternalExtractItem(FIndex);
end;

{ TdxGanttControlSheetMoveColumnHistoryItem }

procedure TdxGanttControlSheetMoveColumnHistoryItem.DoRedo;
begin
  inherited DoRedo;
  Controller.Options.Columns.Move(FCurrentIndex, FNewIndex);
  Controller.FirstVisibleColumnIndex := FNewFirstVisibleColumnIndex;
  Controller.FocusedColumnIndex := Controller.Options.Columns[FNewIndex].VisibleIndex;
end;

procedure TdxGanttControlSheetMoveColumnHistoryItem.DoUndo;
begin
  inherited DoUndo;
  Controller.Options.Columns.Move(FNewIndex, FCurrentIndex);
  Controller.FirstVisibleColumnIndex := FFirstVisibleColumnIndex;
end;

{ TdxGanttControlSheetHideColumnHistoryItem }

procedure TdxGanttControlSheetHideColumnHistoryItem.DoRedo;
begin
  inherited DoRedo;
  Controller.Options.Columns[FColumnIndex].Visible := False;
  Controller.FirstVisibleColumnIndex := FNewFirstVisibleColumnIndex;
end;

procedure TdxGanttControlSheetHideColumnHistoryItem.DoUndo;
begin
  inherited DoUndo;
  Controller.Options.Columns[FColumnIndex].Visible := True;
  Controller.FirstVisibleColumnIndex := FFirstVisibleColumnIndex;
end;

{ TdxGanttControlSheetRenameColumnHistoryItem }

procedure TdxGanttControlSheetRenameColumnHistoryItem.DoRedo;
begin
  FOldValue := Controller.Options.Columns[FColumnIndex].Caption;
  Controller.Options.Columns[FColumnIndex].Caption := FNewValue;
  inherited DoRedo;
end;

procedure TdxGanttControlSheetRenameColumnHistoryItem.DoUndo;
begin
  inherited DoUndo;
  Controller.Options.Columns[FColumnIndex].Caption := FOldValue;
end;

{ TdxGanttControlSheetShowColumnHistoryItem }

procedure TdxGanttControlSheetShowColumnHistoryItem.DoRedo;
begin
  inherited DoRedo;
  Controller.Options.Columns[FColumnIndex].Visible := True;
end;

procedure TdxGanttControlSheetShowColumnHistoryItem.DoUndo;
begin
  inherited DoUndo;
  Controller.Options.Columns[FColumnIndex].Visible := False;
end;

{ TdxGanttControlSheetCommand }

constructor TdxGanttControlSheetCommand.Create(
  AController: TdxGanttControlSheetController);
begin
  inherited Create(AController.Control);
  FController := AController;
end;

{ TdxGanttControlSheetColumnCommand }

constructor TdxGanttControlSheetColumnCommand.Create(
  AController: TdxGanttControlSheetController;
  AColumn: TdxGanttControlSheetColumn);
begin
  inherited Create(AController);
  FColumn := AColumn;
end;

{ TdxGanttControlSheetResizeColumnCommand }

constructor TdxGanttControlSheetResizeColumnCommand.Create(
  AController: TdxGanttControlSheetController;
  AColumn: TdxGanttControlSheetColumn; ANewWidth: Integer);
begin
  inherited Create(AController, AColumn);
  FNewWidth := ANewWidth;
end;

procedure TdxGanttControlSheetResizeColumnCommand.DoExecute;
var
  AHistoryItem: TdxGanttControlSheetResizeHistoryItem;
begin
  AHistoryItem := TdxGanttControlSheetResizeHistoryItem.Create(Controller);
  AHistoryItem.FColumn := Column;
  AHistoryItem.FNewWidth := FNewWidth;
  Control.History.AddItem(AHistoryItem);
  AHistoryItem.Execute;
end;

function TdxGanttControlSheetResizeColumnCommand.Enabled: Boolean;
begin
  Result := Column.RealAllowSize and (Column.Width <> FNewWidth);
end;

{ TdxGanttControlSheetRenameColumnCommand }

constructor TdxGanttControlSheetRenameColumnCommand.Create(
  AController: TdxGanttControlSheetController;
  AColumn: TdxGanttControlSheetColumn; const ANewValue: string);
begin
  inherited Create(AController, AColumn);
  FNewValue := ANewValue;
end;

procedure TdxGanttControlSheetRenameColumnCommand.DoExecute;
var
  AHistoryItem: TdxGanttControlSheetRenameColumnHistoryItem;
begin
  inherited DoExecute;
  AHistoryItem := TdxGanttControlSheetRenameColumnHistoryItem.Create(Controller);
  AHistoryItem.FColumnIndex := Column.Index;
  AHistoryItem.FNewValue := FNewValue;
  Controller.Control.History.AddItem(AHistoryItem);
  AHistoryItem.Execute;
end;

function TdxGanttControlSheetRenameColumnCommand.Enabled: Boolean;
begin
  Result := (Column.Caption <> FNewValue);
end;

{ TdxGanttControlSheetChangeRowHeaderWidthCommand }

constructor TdxGanttControlSheetChangeRowHeaderWidthCommand.Create(
  AController: TdxGanttControlSheetController; ANewWidth: Integer);
begin
  inherited Create(AController);
  FNewWidth := ANewWidth;
end;

procedure TdxGanttControlSheetChangeRowHeaderWidthCommand.DoExecute;
var
  AHistoryItem: TdxGanttControlSheetChangeRowHeaderWidthHistoryItem;
begin
  AHistoryItem := TdxGanttControlSheetChangeRowHeaderWidthHistoryItem.Create(Controller);
  AHistoryItem.FNewWidth := FNewWidth;
  Control.History.AddItem(AHistoryItem);
  AHistoryItem.Execute;
end;

function TdxGanttControlSheetChangeRowHeaderWidthCommand.Enabled: Boolean;
begin
  Result := (Controller.Options.RowHeaderWidth <> FNewWidth);
end;

{ TdxGanttControlSheetChangeCellCommand }

procedure TdxGanttControlSheetChangeCellCommand.AppendItems(ACount: Integer);
var
  I: Integer;
  AHistoryItem: TdxGanttControlDataItemHistoryItem;
begin
  if ACount <= 0 then
    Exit;
  for I := 0 to ACount - 1 do
  begin
    AHistoryItem := TdxGanttControlAppendDataItemHistoryItem.Create(Controller);
    Control.History.AddItem(AHistoryItem);
    AHistoryItem.Execute;
  end;
end;

constructor TdxGanttControlSheetChangeCellCommand.Create(
  AController: TdxGanttControlSheetController);
begin
  inherited Create(AController);
  FData := Controller.FocusedDataItem;
  if Controller.EditingController.FocusedCellViewInfo <> nil then
    FColumn := Controller.EditingController.FocusedCellViewInfo.Column;
end;

function TdxGanttControlSheetChangeCellCommand.Enabled: Boolean;
begin
  Result := inherited Enabled and not Controller.Options.IsReadOnly;
end;

function TdxGanttControlSheetChangeCellCommand.GetController: TdxGanttControlSheetController;
begin
  Result := TdxGanttControlSheetController(inherited Controller);
end;

procedure TdxGanttControlSheetChangeCellCommand.SaveCellPosition;
var
  AHistoryItem: TdxGanttControlSheetFocusedCellChangeHistoryItem;
begin
  AHistoryItem := TdxGanttControlSheetFocusedCellChangeHistoryItem.Create(Controller);
  AHistoryItem.FFocusedCell := Controller.FocusedCell;
  AHistoryItem.FFirstVisibleCell := TPoint.Create(Controller.FirstVisibleColumnIndex, Controller.FirstVisibleRowIndex);
  Control.History.AddItem(AHistoryItem);
end;

{ TdxGanttControlSheetDeleteFocusedItemCommand }

procedure TdxGanttControlSheetDeleteFocusedItemCommand.BeforeExecute;
begin
  SaveCellPosition;
  inherited BeforeExecute;
end;

function TdxGanttControlSheetDeleteFocusedItemCommand.Enabled: Boolean;
begin
  Result := inherited Enabled and (Controller.FocusedDataItem <> nil);
end;

{ TdxGanttControlSheetMoveFocusedItemCommand }

constructor TdxGanttControlSheetMoveFocusedItemCommand.Create(
  AController: TdxGanttControlSheetController; ANewIndex, ANewFocusedRowIndex: Integer);
begin
  inherited Create(AController);
  FNewIndex := ANewIndex;
  FNewFocusedRowIndex := ANewFocusedRowIndex;
end;

procedure TdxGanttControlSheetMoveFocusedItemCommand.AfterExecute;
begin
  inherited AfterExecute;
  Controller.FocusedRowIndex := FNewFocusedRowIndex;
  SaveCellPosition;
end;

procedure TdxGanttControlSheetMoveFocusedItemCommand.BeforeExecute;
begin
  FDataItem := Controller.FocusedDataItem;
  SaveCellPosition;
  inherited BeforeExecute;
end;

procedure TdxGanttControlSheetMoveFocusedItemCommand.DoExecute;
begin
  inherited DoExecute;
  if (FNewIndex >= Controller.DataProvider.DataItemCount) and Controller.DataProvider.IsBlank(FDataItem) then
    DeleteItem
  else
  begin
    AppendItems(FNewIndex - Controller.DataProvider.DataItemCount + 1);
    Controller.DataProvider.MoveDataItem(FDataItem, FNewIndex);
  end;
end;

procedure TdxGanttControlSheetMoveFocusedItemCommand.DeleteItem;
var
  AHistoryItem: TdxGanttControlDeleteDataItemHistoryItem;
begin
  AHistoryItem := TdxGanttControlDeleteDataItemHistoryItem.Create(Controller);
  AHistoryItem.FIndex := Controller.DataProvider.GetDataItemIndex(FDataItem);
  Control.History.AddItem(AHistoryItem);
  AHistoryItem.Execute;
end;

function TdxGanttControlSheetMoveFocusedItemCommand.Enabled: Boolean;
begin
  Result := inherited Enabled and (Controller.FocusedDataItem <> nil);
end;

{ TdxGanttControlSheetInsertNewItemCommand }

procedure TdxGanttControlSheetInsertNewItemCommand.BeforeExecute;
begin
  SaveCellPosition;
  inherited BeforeExecute;
end;

procedure TdxGanttControlSheetInsertNewItemCommand.DoExecute;
var
  AHistoryItem: TdxGanttControlDataItemHistoryItem;
begin
  inherited DoExecute;
  if Controller.DataProvider.Count <= Controller.FocusedRowIndex then
    AppendItems(Controller.FocusedRowIndex - Controller.DataProvider.Count + 1)
  else
  begin
    AHistoryItem := TdxGanttControlInsertDataItemHistoryItem.Create(Controller);
    AHistoryItem.FIndex := Controller.DataProvider.GetDataItemIndex(Controller.FocusedDataItem);
    Control.History.AddItem(AHistoryItem);
    AHistoryItem.Execute;
  end;
end;

{ TdxGanttControlSheetToggleItemExpandStateCommand }

procedure TdxGanttControlSheetToggleItemExpandStateCommand.DoExecute;
var
  AHistoryItem: TdxGanttControlSheetToggleItemExpandStateHistoryItem;
begin
  SaveCellPosition;
  AHistoryItem := TdxGanttControlSheetToggleItemExpandStateHistoryItem.Create(Controller);
  AHistoryItem.FData := FData;
  AHistoryItem.FIsExpanded := Controller.DataProvider.IsExpanded(FData);
  Controller.Control.History.AddItem(AHistoryItem);
  AHistoryItem.Execute;
end;

function TdxGanttControlSheetToggleItemExpandStateCommand.Enabled: Boolean;
begin
  Result := Controller.HasItemExpandState(FData);
end;

{ TdxGanttControlSheetExpandItemCommand }

function TdxGanttControlSheetExpandItemCommand.Enabled: Boolean;
begin
  Result := not Controller.DataProvider.IsExpanded(FData);
end;

{ TdxGanttControlSheetCollapseItemCommand }

function TdxGanttControlSheetCollapseItemCommand.Enabled: Boolean;
begin
  Result := Controller.DataProvider.IsExpanded(FData);
end;

{ TdxGanttControlSheetMoveColumnCommand }

constructor TdxGanttControlSheetMoveColumnCommand.Create(
  AController: TdxGanttControlSheetController;
  ACurrentIndex, ANewIndex: Integer;
  AFirstVisibleColumnIndex: Integer = -1);
begin
  inherited Create(AController);
  FCurrentIndex := ACurrentIndex;
  FNewIndex := ANewIndex;
  if AFirstVisibleColumnIndex = -1 then
    FFirstVisibleColumnIndex := Controller.FirstVisibleColumnIndex
  else
    FFirstVisibleColumnIndex := AFirstVisibleColumnIndex;
  FNewFirstVisibleColumnIndex := Controller.FirstVisibleColumnIndex;
end;

procedure TdxGanttControlSheetMoveColumnCommand.SaveCellPosition;
var
  AHistoryItem: TdxGanttControlSheetFocusedCellChangeHistoryItem;
begin
  AHistoryItem := TdxGanttControlSheetFocusedCellChangeHistoryItem.Create(Controller);
  AHistoryItem.FFocusedCell := Controller.FocusedCell;
  AHistoryItem.FFirstVisibleCell := TPoint.Create(Controller.FirstVisibleColumnIndex, Controller.FirstVisibleRowIndex);
  Control.History.AddItem(AHistoryItem);
end;

procedure TdxGanttControlSheetMoveColumnCommand.BeforeExecute;
begin
  inherited BeforeExecute;
  SaveCellPosition;
end;

procedure TdxGanttControlSheetMoveColumnCommand.DoExecute;
var
  AHistoryItem: TdxGanttControlSheetMoveColumnHistoryItem;
begin
  inherited DoExecute;
  AHistoryItem := TdxGanttControlSheetMoveColumnHistoryItem.Create(Controller);
  AHistoryItem.FCurrentIndex := FCurrentIndex;
  AHistoryItem.FNewIndex := FNewIndex;
  AHistoryItem.FFirstVisibleColumnIndex := FFirstVisibleColumnIndex;
  AHistoryItem.FNewFirstVisibleColumnIndex := FNewFirstVisibleColumnIndex;
  Controller.Control.History.AddItem(AHistoryItem);
  AHistoryItem.Execute;
end;

function TdxGanttControlSheetMoveColumnCommand.Enabled: Boolean;
begin
  Result := FCurrentIndex <> FNewIndex;
end;

{ TdxGanttControlSheetHideColumnCommand }

constructor TdxGanttControlSheetHideColumnCommand.Create(
  AController: TdxGanttControlSheetController;
  AColumnIndex: Integer; AFirstVisibleColumnIndex: Integer = -1);
begin
  inherited Create(AController);
  FColumnIndex := AColumnIndex;
  if AFirstVisibleColumnIndex = -1 then
    FFirstVisibleColumnIndex := AController.FirstVisibleColumnIndex
  else
    FFirstVisibleColumnIndex := AFirstVisibleColumnIndex;
  FNewFirstVisibleColumnIndex := Controller.FirstVisibleColumnIndex;
end;

procedure TdxGanttControlSheetHideColumnCommand.DoExecute;
var
  AHistoryItem: TdxGanttControlSheetHideColumnHistoryItem;
begin
  inherited DoExecute;
  AHistoryItem := TdxGanttControlSheetHideColumnHistoryItem.Create(Controller);
  AHistoryItem.FColumnIndex := FColumnIndex;
  AHistoryItem.FFirstVisibleColumnIndex := FFirstVisibleColumnIndex;
  AHistoryItem.FNewFirstVisibleColumnIndex := FNewFirstVisibleColumnIndex;
  Controller.Control.History.AddItem(AHistoryItem);
  AHistoryItem.Execute;
end;

function TdxGanttControlSheetHideColumnCommand.Enabled: Boolean;
begin
  Result := Controller.Options.Columns[FColumnIndex].RealAllowHide and Controller.Options.Columns[FColumnIndex].Visible;
end;

{ TdxGanttControlSheetShowColumnCommand }

constructor TdxGanttControlSheetShowColumnCommand.Create(
  AController: TdxGanttControlSheetController; AColumnIndex: Integer);
begin
  inherited Create(AController);
  FColumnIndex := AColumnIndex
end;

procedure TdxGanttControlSheetShowColumnCommand.DoExecute;
var
  AHistoryItem: TdxGanttControlSheetShowColumnHistoryItem;
begin
  inherited DoExecute;
  AHistoryItem := TdxGanttControlSheetShowColumnHistoryItem.Create(Controller);
  AHistoryItem.FColumnIndex := FColumnIndex;
  Controller.Control.History.AddItem(AHistoryItem);
  AHistoryItem.Execute;
end;

function TdxGanttControlSheetShowColumnCommand.Enabled: Boolean;
begin
  Result := Controller.Options.Columns[FColumnIndex].RealAllowInsert and not Controller.Options.Columns[FColumnIndex].Visible;
end;

{ TdxGanttControlSheetAddColumnCommand }

constructor TdxGanttControlSheetAddColumnCommand.Create(
  AController: TdxGanttControlSheetController;
  AColumnClass: TdxGanttControlSheetColumnClass);
begin
  inherited Create(AController);
  FColumnClass := AColumnClass;
end;

procedure TdxGanttControlSheetAddColumnCommand.DoExecute;

  function GetInvisibleColumn: TdxGanttControlSheetColumn;
  var
    I: Integer;
  begin
    for I := 0 to Controller.Options.Columns.Count - 1 do
      if not Controller.Options.Columns[I].Visible and (Controller.Options.Columns[I] is FColumnClass) then
        Exit(Controller.Options.Columns[I]);
    Result := nil;
  end;

var
  AColumn: TdxGanttControlSheetColumn;
begin
  inherited DoExecute;
  AColumn := GetInvisibleColumn;
  if AColumn = nil then
  begin
    AColumn := Controller.Options.Columns.Add(FColumnClass);
    AColumn.Visible := False;
  end
  else
  begin
  end;
  with TdxGanttControlSheetShowColumnCommand.Create(Controller, AColumn.Index) do
  try
    Execute;
  finally
    Free;
  end;
end;

function TdxGanttControlSheetAddColumnCommand.Enabled: Boolean;
begin
  Result := FColumnClass <> nil;
end;

{ TdxGanttControlSheetChangeCellValueCommand }

constructor TdxGanttControlSheetChangeCellValueCommand.Create(AController: TdxGanttControlSheetController; const ANewValue: Variant);
begin
  inherited Create(AController);
  FNewValue := ANewValue;
end;

procedure TdxGanttControlSheetChangeCellValueCommand.DoExecute;
begin
  if FData = nil then
    FData := CreateDataItem;
  SaveCellPosition;
  with CreateChangeValueCommand do
  try
    Execute;
  finally
    Free;
  end;
  SaveCellPosition;
end;

function TdxGanttControlSheetChangeCellValueCommand.Enabled: Boolean;
begin
  Result := inherited Enabled and FColumn.IsEditable;
end;

function TdxGanttControlSheetChangeCellValueCommand.CreateChangeValueCommand: TdxGanttControlCommand;
begin
  Result := FColumn.CreateChangeValueCommand(Control, FData, FNewValue)
end;

function TdxGanttControlSheetChangeCellValueCommand.CreateDataItem: TObject;
var
  AHistoryItem: TdxGanttControlAppendDataItemHistoryItem;
  I: Integer;
begin
  for I := Controller.DataProvider.Count to Controller.FocusedRowIndex do
  begin
    AHistoryItem := TdxGanttControlAppendDataItemHistoryItem.Create(Controller);
    Control.History.AddItem(AHistoryItem);
    AHistoryItem.Execute;
  end;
  Result := Controller.DataProvider.LastDataItem;
end;

{ TdxGanttControlSheetCellCustomViewInfo }

constructor TdxGanttControlSheetCellCustomViewInfo.Create(
  AOwner: TdxGanttControlSheetDataRowViewInfo;
  AColumnViewInfo: TdxGanttControlSheetColumnHeaderViewInfo;
  AColumn: TdxGanttControlSheetColumn);
begin
  inherited Create(AOwner);
  FColumnViewInfo := AColumnViewInfo;
  FColumn := AColumn;
end;

function TdxGanttControlSheetCellCustomViewInfo.GetFont: TFont;
begin
  Result := CanvasCache.GetBaseFont;
end;

procedure TdxGanttControlSheetCellCustomViewInfo.UpdateColumnViewInfo(AColumnViewInfo: TdxGanttControlSheetHeaderViewInfo);
begin
  FColumnViewInfo := AColumnViewInfo;
end;

function TdxGanttControlSheetCellCustomViewInfo.GetOwner: TdxGanttControlSheetDataRowViewInfo;
begin
  Result := TdxGanttControlSheetDataRowViewInfo(inherited Owner);
end;

function TdxGanttControlSheetCellCustomViewInfo.CalculateBestFit: Integer;
begin
  Result := 0;
end;

function TdxGanttControlSheetCellCustomViewInfo.IsFocused: Boolean;
begin
  Result := Owner.IsFocused and (Owner.Cells.IndexOf(Self) = Owner.Owner.FocusedCell.X - Owner.Owner.FFirstVisibleColumnIndex);
end;

function TdxGanttControlSheetCellCustomViewInfo.MeasureHeight(AWidth: Integer): Integer;
begin
  Result := 0;
end;

{ TdxGanttControlSheetCellViewInfo }

function TdxGanttControlSheetCellViewInfo.GetCurrentCursor(const P: TPoint;
  const ADefaultCursor: TCursor): TCursor;
begin
  if IsFocused and Column.IsEditable and not Owner.Owner.Controller.Control.IsDesigning then
    Result := crIBeam
  else
    Result := ADefaultCursor;
end;

function TdxGanttControlSheetCellViewInfo.GetEditValue: Variant;
begin
  if Owner.Data = nil then
    Result := Null
  else
    Result := Column.GetEditValue(Owner.Data);
end;

{ TdxGanttControlSheetEmptyCellViewInfo }

function TdxGanttControlSheetEmptyCellViewInfo.IsFocused: Boolean;
begin
  Result := False;
end;

{ TdxGanttControlSheetDataRowViewInfo }

constructor TdxGanttControlSheetDataRowViewInfo.Create(
  AOwner: TdxGanttControlSheetCustomViewInfo; AIndex: Integer; AData: TObject);
begin
  inherited Create(AOwner);
  FCells := TObjectList<TdxGanttControlSheetCellCustomViewInfo>.Create;
  FData := AData;
  FIndex := AIndex;
  FHeaderViewInfo := TdxGanttControlSheetRowHeaderViewInfo.Create(Owner, Self);
end;

destructor TdxGanttControlSheetDataRowViewInfo.Destroy;
begin
  FreeAndNil(FHeaderViewInfo);
  FreeAndNil(FCells);
  inherited Destroy;
end;

function TdxGanttControlSheetDataRowViewInfo.CalculateHitTest(const AHitTest: TdxGanttControlHitTest): Boolean;
var
  I: Integer;
begin
  Result := inherited CalculateHitTest(AHitTest);
  if Result then
  begin
    if FHeaderViewInfo.CalculateHitTest(AHitTest) then
      Exit(True);
    for I := 0 to FCells.Count - 1 do
      if FCells[I].CalculateHitTest(AHitTest) then
        Exit(True);
  end;
end;

procedure TdxGanttControlSheetDataRowViewInfo.DoDraw;

  function GetBackgroundColor: TColor;
  begin
    if IsOdd then
      Result := LookAndFeelPainter.GridLikeControlContentOddColor
    else
      Result := LookAndFeelPainter.GridLikeControlContentEvenColor;
  end;

var
  I: Integer;
begin
  if IsFocused then
  begin
    if not LookAndFeelPainter.ApplyEditorAdvancedMode then
      Canvas.FillRect(Bounds, LookAndFeelPainter.DefaultContentColor);
    LookAndFeelPainter.DrawGanttFocusedRow(Canvas, cxRectInflate(Bounds, 2, 2), not IsSelected);
  end
  else
    Canvas.FillRect(Bounds, GetBackgroundColor);
  inherited DoDraw;
  FHeaderViewInfo.Draw;
  for I := 0 to Cells.Count - 1 do
    Cells[I].Draw;
  Canvas.FillRect(FLineBounds, LookAndFeelPainter.DefaultGridlineColor);
end;

procedure TdxGanttControlSheetDataRowViewInfo.DoScroll(const DX, DY: Integer);
var
  I: Integer;
begin
  inherited DoScroll(DX, DY);
  HeaderViewInfo.DoScroll(0, DY);
  FLineBounds.Offset(0, DY);
  for I := 0 to Cells.Count - 1 do
    Cells[I].DoScroll(DX, DY);
end;

function TdxGanttControlSheetDataRowViewInfo.GetOwner: TdxGanttControlSheetCustomViewInfo;
begin
  Result := TdxGanttControlSheetCustomViewInfo(inherited Owner);
end;

function TdxGanttControlSheetDataRowViewInfo.IsFocused: Boolean;
begin
  Result := Index = Owner.FocusedCell.Y - Owner.FFirstVisibleRowIndex;
end;

function TdxGanttControlSheetDataRowViewInfo.IsFullyVisible: Boolean;
begin
  Result := Bounds.Bottom <= Owner.ClientRect.Bottom;
end;

function TdxGanttControlSheetDataRowViewInfo.IsOdd: Boolean;
begin
  Result := (Owner.Controller.FirstVisibleRowIndex + Index) mod 2 = 1;
end;

function TdxGanttControlSheetDataRowViewInfo.IsSelected: Boolean;
begin
  Result := IsFocused and (Owner.FocusedCell.X = -1);
end;

function TdxGanttControlSheetDataRowViewInfo.MeasureHeight: Integer;
var
  I: Integer;
  ACellViewInfo: TdxGanttControlSheetCellCustomViewInfo;
  AResult: Integer;
begin
  Result := GetItemDefaultHeight(Owner.Options.RowHeight);
  if Owner.IsTouchModeEnabled then
    Result := dxGetTouchableSize(Result, ScaleFactor);
  if (Data <> nil) and Owner.Options.CellAutoHeight then
  begin
    if not Owner.CachedDataRowHeight.TryGetValue(Data, AResult) then
    begin
      for I := 0 to Owner.Options.Columns.Count - 1 do
        if Owner.Options.Columns[I].Visible then
        begin
          ACellViewInfo := Owner.Options.Columns[I].GetDataCellViewInfoClass.Create(Self, nil, Owner.Options.Columns[I]);
          try
            ACellViewInfo.CalculateLayout;
            Result := Max(Result, ACellViewInfo.MeasureHeight(ScaleFactor.Apply(Owner.Options.Columns[I].Width)));
          finally
            ACellViewInfo.Free;
          end;
        end;
      Owner.CachedDataRowHeight.Add(Data, Result);
    end
    else
      Result := AResult;
  end;
end;

procedure TdxGanttControlSheetDataRowViewInfo.UpdateIndex(const Value: Integer);
begin
  FIndex := Value;
end;

procedure TdxGanttControlSheetDataRowViewInfo.ViewChanged;
var
  I: Integer;
  AColumnViewInfo: TdxGanttControlSheetColumnHeaderViewInfo;
  AIndex: Integer;
begin
  inherited ViewChanged;
  for I := 1 to Owner.Headers.Count - 1 do
    if Owner.Headers[I] is TdxGanttControlSheetColumnHeaderViewInfo then
    begin
      AIndex := I - 1;
      AColumnViewInfo := TdxGanttControlSheetColumnHeaderViewInfo(Owner.Headers[I]);
      if (FCells.Count > AIndex) and (FCells[AIndex].Column.Index < AColumnViewInfo.Column.Index) then
      begin
        while (FCells.Count > AIndex) and (FCells[AIndex].Column <> AColumnViewInfo.Column) do
          FCells.Delete(AIndex);
      end;
      if FCells.Count <= AIndex then
      begin
        FCells.Add(AColumnViewInfo.Column.GetDataCellViewInfoClass.Create(Self, AColumnViewInfo, AColumnViewInfo.Column));
        FCells.Last.CalculateLayout;
      end;
      if FCells[AIndex].Column.Index > AColumnViewInfo.Column.Index then
      begin
        FCells.Insert(AIndex, AColumnViewInfo.Column.GetDataCellViewInfoClass.Create(Self, AColumnViewInfo, AColumnViewInfo.Column));
        FCells[AIndex].CalculateLayout;
      end;
      FCells[AIndex].UpdateColumnViewInfo(AColumnViewInfo);
    end;
  while FCells.Count > Owner.Headers.Count - 1 do
    FCells.Delete(FCells.Count - 1);
  Recalculate;
end;

procedure TdxGanttControlSheetDataRowViewInfo.CalculateLayout;
var
  I: Integer;
  AColumnHeaderViewInfo: TdxGanttControlSheetColumnHeaderViewInfo;
begin
  inherited CalculateLayout;
  FCells.Clear;
  for I := 1 to Owner.Headers.Count - 1 do
  begin
    if Owner.Headers[I] is TdxGanttControlSheetColumnHeaderViewInfo then
    begin
      AColumnHeaderViewInfo := TdxGanttControlSheetColumnHeaderViewInfo(Owner.Headers[I]);
      FCells.Add(AColumnHeaderViewInfo.GetDataCellViewInfoClass.Create(Self, AColumnHeaderViewInfo, AColumnHeaderViewInfo.Column));
      FCells.Last.CalculateLayout;
    end;
  end;
end;

procedure TdxGanttControlSheetDataRowViewInfo.Calculate(const R: TRect);
var
  AHeaderBounds: TRect;
  ACellBounds: TRect;
  I: Integer;
begin
  AHeaderBounds := R;
  AHeaderBounds.Left := Owner.Headers[0].Bounds.Left;
  AHeaderBounds.Right := Owner.Headers[0].Bounds.Right;
  for I := 0 to FCells.Count - 1 do
  begin
    ACellBounds := TRect.Create(FCells[I].ColumnViewInfo.Bounds.Left, AHeaderBounds.Top, FCells[I].ColumnViewInfo.Bounds.Right, AHeaderBounds.Bottom);
    FCells[I].Calculate(ACellBounds);
  end;
  FHeaderViewInfo.Calculate(AHeaderBounds);
  inherited Calculate(R);
  if UseRightToLeftAlignment then
    FLineBounds := TRect.Create(Bounds.Left, AHeaderBounds.Bottom - GridLineThickness, AHeaderBounds.Left, AHeaderBounds.Bottom)
  else
    FLineBounds := TRect.Create(AHeaderBounds.Right, AHeaderBounds.Bottom - GridLineThickness, Bounds.Right, AHeaderBounds.Bottom);
end;

{ TdxGanttControlSheetCellStringValueViewInfo }

constructor TdxGanttControlSheetCellStringValueViewInfo.Create(AOwner: TdxGanttControlSheetDataRowViewInfo;
  AColumnViewInfo: TdxGanttControlSheetColumnHeaderViewInfo;
  AColumn: TdxGanttControlSheetColumn);
begin
  inherited Create(AOwner, AColumnViewInfo, AColumn);
  FTextLayout := Canvas.CreateTextLayout;
end;

destructor TdxGanttControlSheetCellStringValueViewInfo.Destroy;
begin
  FreeAndNil(FTextLayout);
  inherited Destroy;
end;

procedure TdxGanttControlSheetCellStringValueViewInfo.Calculate(const R: TRect);
begin
  inherited Calculate(R);
  FTextBounds := CalculateTextBounds;
  if not Bounds.IsEmpty and (FDisplayText <> '') then
  begin
    FTextLayout.SetColor(LookAndFeelPainter.GridLikeControlContentTextColor);
    FTextLayout.SetFlags(GetDrawTextFlags);
    FTextLayout.SetFont(CanvasCache.GetFont(GetFont));
    FTextLayout.SetText(FDisplayText);
    FTextLayout.SetLayoutConstraints(FTextBounds);
    FTextLayout.MeasureSize;
  end;
end;

procedure TdxGanttControlSheetCellStringValueViewInfo.CalculateLayout;
begin
  inherited CalculateLayout;
  FDisplayText := CalculateDisplayText;
end;

function TdxGanttControlSheetCellStringValueViewInfo.HasDisplayText: Boolean;
begin
  Result := Owner.Data <> nil;
end;

function TdxGanttControlSheetCellStringValueViewInfo.HasHint: Boolean;
begin
  Result := (FDisplayText <> '') and FTextLayout.IsTruncated and
    (not Owner.Owner.Controller.EditingController.IsEditing or
    (Owner.Owner.Controller.EditingController.FocusedCellViewInfo <> Self));
end;

function TdxGanttControlSheetCellStringValueViewInfo.CalculateTextBounds: TRect;
begin
  Result := ContentBounds;
  TextPadding.Deflate(Result);
  if UseRightToLeftAlignment then
    Result.Offset(cxTextOffsetHalf, 0);
end;

function TdxGanttControlSheetCellStringValueViewInfo.CalculateBestFit: Integer;
begin
  Result := TdxGanttControlUtils.MeasureTextWidth(FTextLayout,
    FDisplayText, CanvasCache.GetFont(GetFont));
  Result := Result + GridLineThickness + 2 * FocusRectThickness + TextPadding.Width;
end;

function TdxGanttControlSheetCellStringValueViewInfo.CalculateDisplayText: string;
begin
  if HasDisplayText then
    Result := DoCalculateDisplayText
  else
    Result := '';
end;

function TdxGanttControlSheetCellStringValueViewInfo.DoCalculateDisplayText: string;
var
  AProperties: TcxCustomEditProperties;
  ADisplayValue: Variant;
begin
  AProperties := Column.Properties;
  AProperties.PrepareDisplayValue(Column.GetEditValue(Owner.Data), ADisplayValue, False);
  Result := VarToStr(ADisplayValue);
end;

procedure TdxGanttControlSheetCellStringValueViewInfo.DoDraw;
begin
  inherited DoDraw;
  if not Bounds.IsEmpty and (FDisplayText <> '') then
    FTextLayout.Draw(FTextBounds);
end;

procedure TdxGanttControlSheetCellStringValueViewInfo.DoScroll(const DX,
  DY: Integer);
begin
  inherited DoScroll(DX, DY);
  FTextBounds.Offset(DX, DY);
end;

function TdxGanttControlSheetCellStringValueViewInfo.GetDrawTextFlags: Integer;
const
  ASingleLineFlagsMap: array[Boolean] of Integer = (CXTO_WORDBREAK, CXTO_SINGLELINE);
  AAlignmentFlagsMap: array[Boolean, TAlignment] of Integer = (
    (CXTO_LEFT, CXTO_RIGHT, CXTO_CENTER_HORIZONTALLY),
    (CXTO_RIGHT, CXTO_LEFT, CXTO_CENTER_HORIZONTALLY));
begin
  Result := ASingleLineFlagsMap[not (Column.Owner.Owner.CellAutoHeight and MultilineSupports)] or CXTO_END_ELLIPSIS or
    AAlignmentFlagsMap[UseRightToLeftAlignment, Column.GetAlignment];
end;

function TdxGanttControlSheetCellStringValueViewInfo.GetEditBounds: TRect;
begin
  Result := TextBounds;
  TextPadding.Inflate(Result);
end;

function TdxGanttControlSheetCellStringValueViewInfo.GetHintPoint: TPoint;
begin
  Result := Bounds.TopLeft;
  if UseRightToLeftAlignment then
    Result.X := Bounds.Right;
end;

function TdxGanttControlSheetCellStringValueViewInfo.GetHintText: string;
begin
  Result := FDisplayText;
end;

function TdxGanttControlSheetCellStringValueViewInfo.MeasureHeight(
  AWidth: Integer): Integer;
begin
  if Trim(FDisplayText) = '' then
    Result := 0
  else
  begin
    Result := TdxGanttControlUtils.MeasureTextHeight(FTextLayout,
      AWidth - (GridLineThickness + 2 * FocusRectThickness + TextPadding.Width),
      FDisplayText, CanvasCache.GetFont(GetFont), not (Column.Owner.Owner.CellAutoHeight and MultilineSupports));
  end;
  Result := Result + GridLineThickness + 2 * FocusRectThickness + TextPadding.Height;
end;

function TdxGanttControlSheetCellStringValueViewInfo.MultilineSupports: Boolean;
begin
  Result := Column.WordWrap;
end;

{ TdxGanttControlSheetHeaderViewInfo }

constructor TdxGanttControlSheetHeaderViewInfo.Create(
  AOwner: TdxGanttControlCustomItemViewInfo);
begin
  inherited Create(AOwner);
  FTextLayout := Canvas.CreateTextLayout;
end;

destructor TdxGanttControlSheetHeaderViewInfo.Destroy;
begin
  FreeAndNil(FTextLayout);
  inherited Destroy;
end;

procedure TdxGanttControlSheetHeaderViewInfo.Calculate(const R: TRect);
begin
  inherited Calculate(R);
  FSelectedRect := CalculateSelectedRect;
  if FCaption = '' then
    FTextBounds := cxNullRect
  else
    CalculateTextBounds(R);
end;

procedure TdxGanttControlSheetHeaderViewInfo.DoDraw;
begin
  UpdateState;
  DrawBackground(Self, GetBorders, GetNeighbors);
  if not FTextBounds.IsEmpty and (FCaption <> '') then
    FTextLayout.Draw(FTextBounds);
  inherited DoDraw;
end;

procedure TdxGanttControlSheetHeaderViewInfo.DoScroll(const DX, DY: Integer);
begin
  inherited DoScroll(DX, DY);
  FTextBounds.Offset(DX, DY);
  FSelectedRect.Offset(DX, DY);
end;

procedure TdxGanttControlSheetHeaderViewInfo.DrawBackground(
  AViewInfo: TdxGanttControlCustomOwnedItemViewInfo; ABorders: TcxBorders; ANeighbors: TcxNeighbors);
begin
  LookAndFeelPainter.DrawGanttSheetHeader(Canvas, AViewInfo.Bounds, AViewInfo.State, ANeighbors,
    ABorders, ScaleFactor);
end;

function TdxGanttControlSheetHeaderViewInfo.CalculateSelectedRect: TRect;
begin
  Result := cxNullRect;
end;

procedure TdxGanttControlSheetHeaderViewInfo.CalculateTextBounds(const R: TRect);
begin
  FTextBounds := R;
  HeaderPadding.Deflate(FTextBounds);
  FTextBounds.Deflate(GridLineThickness + FocusRectThickness);
  if FCaption <> '' then
  begin
    FTextLayout.SetFlags(GetDrawTextFlags);
    FTextLayout.SetFont(CanvasCache.GetControlFont);
    FTextLayout.SetColor(GetTextColor);
    FTextLayout.SetText(FCaption);
    FTextLayout.SetLayoutConstraints(FTextBounds);
    FTextLayout.MeasureSize;
  end;
end;

function TdxGanttControlSheetHeaderViewInfo.GetBorders: TcxBorders;
begin
  Result := [];
end;

function TdxGanttControlSheetHeaderViewInfo.GetCurrentCursor(const P: TPoint;
  const ADefaultCursor: TCursor): TCursor;
begin
  if IsSizingZone(P) then
    Result := TdxGanttControlCursors.ColumnResize
  else
    Result := inherited GetCurrentCursor(P, ADefaultCursor);
end;

function TdxGanttControlSheetHeaderViewInfo.GetMinWidth: Integer;
begin
  Result := 0;
end;

function TdxGanttControlSheetHeaderViewInfo.GetNeighbors: TcxNeighbors;
begin
  Result := [];
end;

function TdxGanttControlSheetHeaderViewInfo.GetOwner: TdxGanttControlSheetCustomViewInfo;
begin
  Result := TdxGanttControlSheetCustomViewInfo(inherited Owner);
end;

function TdxGanttControlSheetHeaderViewInfo.GetDrawTextFlags: Integer;
begin
  Result := CXTO_WORDBREAK or CXTO_END_ELLIPSIS or
    cxMakeFormat(GetTextHorizontalAlignment, GetTextVerticalAlignment);
  if UseRightToLeftAlignment then
    Result := Result or CXTO_RTLREADING;
end;

function TdxGanttControlSheetHeaderViewInfo.GetTextColor: TColor;
begin
  Result := GetTextColor(State);
end;

function TdxGanttControlSheetHeaderViewInfo.GetTextColor(AState: TcxButtonState): TColor;
begin
  case AState of
    cxbsHot, cxbsPressed:
      Result := LookAndFeelPainter.ButtonSymbolColor(AState);
  else
    Result := LookAndFeelPainter.DefaultHeaderTextColor;
  end;
end;

function TdxGanttControlSheetHeaderViewInfo.GetTextHorizontalAlignment: TcxTextAlignX;
begin
  Result := taCenterX;
end;

function TdxGanttControlSheetHeaderViewInfo.GetTextVerticalAlignment: TcxTextAlignY;
begin
  Result := taCenterY;
end;

function TdxGanttControlSheetHeaderViewInfo.HasHotTrackState: Boolean;
begin
  Result := not Owner.Controller.Control.IsDesigning;
end;

function TdxGanttControlSheetHeaderViewInfo.HasPressedState: Boolean;
begin
  Result := not Owner.Controller.Control.IsDesigning;
end;

function TdxGanttControlSheetHeaderViewInfo.IsHotState(
  AViewInfo: TdxGanttControlCustomOwnedItemViewInfo): Boolean;
begin
  Result := not Owner.Controller.DragHelper.IsDragging;
  if Result then
  begin
    Result := TdxGanttControlCustomOwnedItemViewInfoAccess(AViewInfo).HasHotTrackState and (AViewInfo.State = cxbsHot);
    Result := Result or TdxGanttControlCustomOwnedItemViewInfoAccess(AViewInfo).HasPressedState and (AViewInfo.State = cxbsPressed);
  end;
end;

function TdxGanttControlSheetHeaderViewInfo.IsMovingZone(const P: TPoint): Boolean;
begin
  Result := False;
end;

function TdxGanttControlSheetHeaderViewInfo.IsSizingZone(
  const P: TPoint): Boolean;
var
  X: Integer;
begin
  if UseRightToLeftAlignment then
    X := Bounds.Left
  else
    X := Bounds.Right;
  Result := (P.X >= X - GetResizeHitZoneWidth div 2) and (P.X <= X + GetResizeHitZoneWidth div 2);
end;

{ TdxGanttControlSheetRowHeaderViewInfo }

constructor TdxGanttControlSheetRowHeaderViewInfo.Create(
  AOwner: TdxGanttControlSheetCustomViewInfo; ADataRow: TdxGanttControlSheetDataRowViewInfo);
begin
  inherited Create(AOwner);
  FDataRow := ADataRow;
  FCaption := Owner.Options.DataProvider.GetRowHeaderCaption(Data);
end;

function TdxGanttControlSheetRowHeaderViewInfo.GetBorders: TcxBorders;
begin
  Result := [bBottom, bLeft, bRight];
  if UseRightToLeftAlignment then
    Exclude(Result, bRight)
  else
    Exclude(Result, bLeft);
end;

function TdxGanttControlSheetRowHeaderViewInfo.GetCurrentCursor(const P: TPoint;
  const ADefaultCursor: TCursor): TCursor;
begin
  if IsSizingZone(P) then
    Result := TdxGanttControlCursors.ColumnResize
  else if not Owner.Controller.Control.IsDesigning and not FDataRow.IsSelected then
  begin
    if UseRightToLeftAlignment then
      Result := TdxGanttControlCursors.ArrowRight
    else
      Result := TdxGanttControlCursors.ArrowLeft;
  end
  else
    Result := inherited GetCurrentCursor(P, ADefaultCursor);
end;

function TdxGanttControlSheetRowHeaderViewInfo.GetNeighbors: TcxNeighbors;
begin
  Result := [nTop, nBottom];
end;

function TdxGanttControlSheetRowHeaderViewInfo.HasPressedState: Boolean;
begin
  Result := True;
end;

function TdxGanttControlSheetRowHeaderViewInfo.IsMovingZone(
  const P: TPoint): Boolean;
begin
  Result := Bounds.Contains(P);
end;

function TdxGanttControlSheetRowHeaderViewInfo.IsPressed: Boolean;
var
  ADragAndDropObject: TcxDragAndDropObject;
begin
  ADragAndDropObject := Owner.Controller.DragHelper.DragAndDropObject;
  Result := (ADragAndDropObject is TdxGanttControlSheetRowMovingObject) and
    (TdxGanttControlSheetRowMovingObject(ADragAndDropObject).RowIndex = DataRow.Index + Owner.Controller.FirstVisibleRowIndex);
  Result := Result or DataRow.IsFocused;
end;

function TdxGanttControlSheetRowHeaderViewInfo.GetData: TObject;
begin
  Result := DataRow.Data;
end;

function TdxGanttControlSheetRowHeaderViewInfo.GetHeaderPadding: TdxPadding;
begin
  Result := inherited GetHeaderPadding;
  Result.Top := 0;
  Result.Bottom := 0;
end;

function TdxGanttControlSheetRowHeaderViewInfo.GetDrawTextFlags: Integer;
begin
  Result := inherited GetDrawTextFlags and not CXTO_END_ELLIPSIS;
end;

function TdxGanttControlSheetRowHeaderViewInfo.GetMinWidth: Integer;
begin
  Result := ScaleFactor.Apply(TdxGanttControlSheetOptions.RowHeaderMinWidth);
end;

{ TdxGanttControlSheetHeaderGripViewInfo }

procedure TdxGanttControlSheetHeaderGripViewInfo.Calculate(const R: TRect);
begin
  Clear;
  if Owner.Options.ColumnQuickCustomization then
    AddChild(TdxGanttControlSheetColumnQuickCustomizationButtonViewInfo.Create(Self));
  inherited Calculate(R);
end;

function TdxGanttControlSheetHeaderGripViewInfo.CalculateItemBounds(
  AItem: TdxGanttControlCustomItemViewInfo): TRect;
var
  AOffset: Integer;
begin
  Result := Bounds;
  AOffset := LookAndFeelPainter.HeaderBorderSize;
  Result.Height := Result.Height -AOffset;
  Result.Width := Result.Width -AOffset;
  if UseRightToLeftAlignment then
    Result.MoveToRight(Bounds.Right);
end;

function TdxGanttControlSheetHeaderGripViewInfo.GetBorders: TcxBorders;
begin
  Result := [bBottom, bLeft, bRight];
  if Owner.UseRightToLeftAlignment then
    Exclude(Result, bRight)
  else
    Exclude(Result, bLeft);
end;

function TdxGanttControlSheetHeaderGripViewInfo.GetMinWidth: Integer;
begin
  Result := ScaleFactor.Apply(TdxGanttControlSheetOptions.RowHeaderMinWidth);
end;

function TdxGanttControlSheetHeaderGripViewInfo.GetNeighbors: TcxNeighbors;
begin
  Result := [nBottom, nLeft, nRight];
  if Owner.UseRightToLeftAlignment then
    Exclude(Result, nRight)
  else
    Exclude(Result, nLeft)
end;

function TdxGanttControlSheetHeaderGripViewInfo.HasHotTrackState: Boolean;
begin
  Result := False;
end;

{ TdxGanttControlSheetColumnQuickCustomizationButtonViewInfo }

procedure TdxGanttControlSheetColumnQuickCustomizationButtonViewInfo.DoDraw;
const
  ASize = 12;
var
  R: TRect;
begin
  UpdateState;
  if Owner.IsHotState(Self) or cxIsTouchModeEnabled then
    Owner.DrawBackground(Self, [], []);
  R := cxRectCenter(Bounds, ScaleFactor.Apply(TSize.Create(ASize, ASize)));
  R.MoveToBottom(Bounds.Bottom - cxTextOffset - GridLineThickness);
  LookAndFeelPainter.DrawScaledIndicatorCustomizationMark(Canvas, R, Owner.GetTextColor(State), ScaleFactor);
end;

function TdxGanttControlSheetColumnQuickCustomizationButtonViewInfo.GetCurrentCursor(
  const P: TPoint; const ADefaultCursor: TCursor): TCursor;
begin
  if Owner.IsSizingZone(P) then
    Result := Owner.GetCurrentCursor(P, ADefaultCursor)
  else
    Result := ADefaultCursor;
end;

function TdxGanttControlSheetColumnQuickCustomizationButtonViewInfo.GetOwner: TdxGanttControlSheetHeaderGripViewInfo;
begin
  Result := TdxGanttControlSheetHeaderGripViewInfo(inherited Owner);
end;

function TdxGanttControlSheetColumnQuickCustomizationButtonViewInfo.HasHotTrackState: Boolean;
begin
  Result := True;
end;

function TdxGanttControlSheetColumnQuickCustomizationButtonViewInfo.HasPressedState: Boolean;
begin
  Result := True;
end;

function TdxGanttControlSheetColumnQuickCustomizationButtonViewInfo.IsPressed: Boolean;
begin
  Result := Owner.Owner.Controller.ColumnQuickCustomizationPopup.Visible;
end;

{ TdxGanttControlSheetColumnHeaderViewInfo }

constructor TdxGanttControlSheetColumnHeaderViewInfo.Create(
  AOwner: TdxGanttControlSheetCustomViewInfo; AColumn: TdxGanttControlSheetColumn);
begin
  inherited Create(AOwner);
  FColumn := AColumn;
  FCaption := GetCaption;
end;

procedure TdxGanttControlSheetColumnHeaderViewInfo.CalculateTextBounds(const R: TRect);
var
  ARect: TRect;
begin
  ARect := R;
  if (FColumn <> nil) and FColumn.ShowFilterButton then
    if UseRightToLeftAlignment then
      ARect.Left := ARect.Left + ScaleFactor.Apply(Owner.Options.DefaultFilterButtonWidth)
    else
      ARect.Right := ARect.Right - ScaleFactor.Apply(Owner.Options.DefaultFilterButtonWidth);
  inherited CalculateTextBounds(ARect);
end;

procedure TdxGanttControlSheetColumnHeaderViewInfo.Calculate(const R: TRect);
begin
  Clear;
  if (FColumn <> nil) and FColumn.ShowFilterButton then
    AddChild(TdxGanttControlSheetColumnHeaderFilterButtonViewInfo.Create(Self));
  inherited Calculate(R);
end;

function TdxGanttControlSheetColumnHeaderViewInfo.GetBorders: TcxBorders;
begin
  Result := [bBottom];
  if Owner.UseRightToLeftAlignment then
    Include(Result, bLeft)
  else
    Include(Result, bRight)
end;

function TdxGanttControlSheetColumnHeaderViewInfo.GetCaption: string;
begin
  Result := Column.Caption;
end;

function TdxGanttControlSheetColumnHeaderViewInfo.GetCurrentCursor(const P: TPoint; const ADefaultCursor: TCursor): TCursor;
var
  AIndex: Integer;
begin
  if IsSizingZone(P) then
    Result := TdxGanttControlCursors.ColumnResize
  else
  begin
    AIndex := Owner.Headers.IndexOf(Self);
    if (AIndex >= 1) and Owner.Headers[AIndex - 1].IsSizingZone(P) then
      Result := TdxGanttControlCursors.ColumnResize
    else
      Result := inherited GetCurrentCursor(P, ADefaultCursor);
  end;
end;

function TdxGanttControlSheetColumnHeaderViewInfo.GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass;
begin
  Result := FColumn.GetDataCellViewInfoClass;
end;

function TdxGanttControlSheetColumnHeaderViewInfo.GetHintText: string;
begin
  Result := Format('[B]%s[/B]'#13#10#13#10'%s', [Column.Caption, Column.GetHintText]);
end;

function TdxGanttControlSheetColumnHeaderViewInfo.GetMinWidth: Integer;
begin
  Result := ScaleFactor.Apply(TdxGanttControlSheetColumn.MinWidth);
end;

function TdxGanttControlSheetColumnHeaderViewInfo.CalculateBestFit: Integer;
begin
  Result := TdxGanttControlUtils.MeasureTextWidth(FTextLayout, FCaption, CanvasCache.GetControlFont);
  Result := Bounds.Width - FTextBounds.Width + Result;
end;

function TdxGanttControlSheetColumnHeaderViewInfo.CalculateItemBounds(AItem: TdxGanttControlCustomItemViewInfo): TRect;
begin
  Result := Bounds;
  Result.Bottom := Result.Bottom - GridLineThickness;
  if UseRightToLeftAlignment then
    Result.Right := Result.Left + ScaleFactor.Apply(Owner.Options.DefaultFilterButtonWidth)
  else
    Result.Left := Result.Right - ScaleFactor.Apply(Owner.Options.DefaultFilterButtonWidth);
end;

function TdxGanttControlSheetColumnHeaderViewInfo.CalculateSelectedRect: TRect;
begin
  Result := Bounds;
  Result.Height := ScaleFactor.Apply(4);
  Result.MoveToBottom(Bounds.Bottom);
end;

function TdxGanttControlSheetColumnHeaderViewInfo.GetNeighbors: TcxNeighbors;
begin
  Result := [nLeft, nRight];
end;

function TdxGanttControlSheetColumnHeaderViewInfo.GetTextHorizontalAlignment: TcxTextAlignX;
begin
  if Owner.UseRightToLeftAlignment then
    Result := taRight
  else
    Result := taLeft;
end;

function TdxGanttControlSheetColumnHeaderViewInfo.GetTextVerticalAlignment: TcxTextAlignY;
begin
  Result := taBottom;
end;

function TdxGanttControlSheetColumnHeaderViewInfo.HasHint: Boolean;
begin
  Result := Owner.Controller.CanShowColumnHint(Column);
end;

function TdxGanttControlSheetColumnHeaderViewInfo.HasHotTrackState: Boolean;
begin
  Result := True;
end;

function TdxGanttControlSheetColumnHeaderViewInfo.HasPressedState: Boolean;
begin
  Result := True;
end;

function TdxGanttControlSheetColumnHeaderViewInfo.IsMovingZone(const P: TPoint): Boolean;
var
  R: TRect;
  I: Integer;
begin
  if not Column.RealAllowMove then
    Exit(False);
  R := Bounds;
  Result := R.Contains(P);
  if Result then
    for I := 0 to ViewInfoCount - 1 do
      if ViewInfos[I].Bounds.Contains(P) then
        Exit(False);
end;

function TdxGanttControlSheetColumnHeaderViewInfo.IsSizingZone(
  const P: TPoint): Boolean;
begin
  Result := Column.RealAllowSize and inherited IsSizingZone(P) and
    (P.Y >= Bounds.Top) and (P.Y < Bounds.Bottom);
end;

function TdxGanttControlSheetColumnHeaderViewInfo.IsPressed: Boolean;
var
  ADragAndDropObject: TcxDragAndDropObject;
begin
  ADragAndDropObject := Owner.Controller.DragHelper.DragAndDropObject;
  Result := (ADragAndDropObject is TdxGanttControlSheetColumnMovingObject) and
    (TdxGanttControlSheetColumnMovingObject(ADragAndDropObject).Column = Column);
  Result := Result or ((Owner.FocusedCell.X >= 0) and (Owner.FocusedCell.X < Owner.Options.Columns.VisibleCount) and
    (Owner.Options.Columns.VisibleItems[Owner.FocusedCell.X] = Column));
end;

{ TdxGanttControlSheetColumnHeaderImageViewInfo }

procedure TdxGanttControlSheetColumnHeaderImageViewInfo.Calculate(
  const R: TRect);
begin
  inherited Calculate(R);
  FImage := CalculateImage;
  FImageRect := CalculateImageBounds;
end;

function TdxGanttControlSheetColumnHeaderImageViewInfo.CalculateBestFit: Integer;
begin
  Result := HeaderPadding.Width;
  if FImage <> nil then
    Inc(Result, ScaleFactor.Apply(FImageRect.Width));
end;

function TdxGanttControlSheetColumnHeaderImageViewInfo.CalculateImageBounds: TRect;
begin
  if FImage = nil then
    Exit(TRect.Null);
  Result.Height := Bounds.Height div 2;
  Result.Width := Ceil(FImage.Width * Result.Height / FImage.Height);
  Result := cxRectCenter(Bounds, Result.Size);
  Result.MoveToBottom(Bounds.Bottom - HeaderPadding.Bottom);
end;

procedure TdxGanttControlSheetColumnHeaderImageViewInfo.CalculateTextBounds(
  const R: TRect);
begin
// do nothing
end;

procedure TdxGanttControlSheetColumnHeaderImageViewInfo.DoDraw;
begin
  inherited DoDraw;
  if FImage <> nil then
    CanvasCache.GetImage(FImage).Draw(FImageRect);
end;

{ TdxGanttControlSheetColumnHeaderFilterButtonViewInfo }

procedure TdxGanttControlSheetColumnHeaderFilterButtonViewInfo.DoDraw;
var
  ABorders: TcxBorders;
begin
  if Owner.IsHotState(Self) then
  begin
    ABorders := [bLeft, bRight];
    Owner.DrawBackground(Self, ABorders, []);
  end;
end;

function TdxGanttControlSheetColumnHeaderFilterButtonViewInfo.HasHotTrackState: Boolean;
begin
  Result := True;
end;

function TdxGanttControlSheetColumnHeaderFilterButtonViewInfo.GetCurrentCursor(
  const P: TPoint; const ADefaultCursor: TCursor): TCursor;
begin
  if Owner.IsSizingZone(P) then
    Result := Owner.GetCurrentCursor(P, ADefaultCursor)
  else
    Result := ADefaultCursor;
end;

function TdxGanttControlSheetColumnHeaderFilterButtonViewInfo.GetOwner: TdxGanttControlSheetColumnHeaderViewInfo;
begin
  Result := TdxGanttControlSheetColumnHeaderViewInfo(inherited Owner);
end;

{ TdxGanttControlSheetColumnEmptyHeaderViewInfo }

function TdxGanttControlSheetColumnEmptyHeaderViewInfo.GetBorders: TcxBorders;
begin
  Result := [bBottom];
end;

function TdxGanttControlSheetColumnEmptyHeaderViewInfo.GetCurrentCursor(
  const P: TPoint; const ADefaultCursor: TCursor): TCursor;
begin
  if Owner.Options.AllowColumnSize and ((not UseRightToLeftAlignment and (P.X >= Bounds.Left) and (P.X <= Bounds.Left + GetResizeHitZoneWidth)) or
      (UseRightToLeftAlignment and (P.X >= Bounds.Right - GetResizeHitZoneWidth) and (P.X <= Bounds.Right))) then
    Result := TdxGanttControlCursors.ColumnResize
  else
    Result := inherited GetCurrentCursor(P, ADefaultCursor);
end;

function TdxGanttControlSheetColumnEmptyHeaderViewInfo.GetNeighbors: TcxNeighbors;
begin
  if Owner.UseRightToLeftAlignment then
    Result := [nRight]
  else
    Result := [nLeft];
end;

function TdxGanttControlSheetColumnEmptyHeaderViewInfo.HasHotTrackState: Boolean;
begin
  Result := False;
end;

{ TdxGanttControlSheetColumnInsertHeaderViewInfo }

constructor TdxGanttControlSheetColumnInsertHeaderViewInfo.Create(
  AOwner: TdxGanttControlSheetCustomViewInfo);
begin
  inherited Create(AOwner, nil);
end;

function TdxGanttControlSheetColumnInsertHeaderViewInfo.GetBorders: TcxBorders;
begin
  Result := [bBottom];
  if Owner.UseRightToLeftAlignment then
    Include(Result, bLeft)
  else
    Include(Result, bRight)
end;

function TdxGanttControlSheetColumnInsertHeaderViewInfo.GetCaption: string;
begin
  Result := '';
end;

function TdxGanttControlSheetColumnInsertHeaderViewInfo.GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass;
begin
  Result := TdxGanttControlSheetEmptyCellViewInfo;
end;

function TdxGanttControlSheetColumnInsertHeaderViewInfo.GetNeighbors: TcxNeighbors;
begin
  Result := [nLeft, nRight];
end;

function TdxGanttControlSheetColumnInsertHeaderViewInfo.HasHint: Boolean;
begin
  Result := False;
end;

function TdxGanttControlSheetColumnInsertHeaderViewInfo.HasHotTrackState: Boolean;
begin
  Result := False;
end;

function TdxGanttControlSheetColumnInsertHeaderViewInfo.HasPressedState: Boolean;
begin
  Result := False;
end;

function TdxGanttControlSheetColumnInsertHeaderViewInfo.IsMovingZone(
  const P: TPoint): Boolean;
begin
  Result := False;
end;

function TdxGanttControlSheetColumnInsertHeaderViewInfo.IsSizingZone(
  const P: TPoint): Boolean;
begin
  Result := False;
end;

{ TdxGanttControlSheetCustomViewInfo }

constructor TdxGanttControlSheetCustomViewInfo.Create(AOwner: TdxGanttControlCustomItemViewInfo;
  AOptions: TdxGanttControlSheetOptions);
begin
  inherited Create(AOwner);
  FOptions := AOptions;
  FHeaders := TObjectList<TdxGanttControlSheetHeaderViewInfo>.Create;
  FGridlines := TdxRectList.Create;
  FDataRows := TObjectList<TdxGanttControlSheetDataRowViewInfo>.Create;
  FCachedDataRowHeight := TdxObjectIntegerDictionary.Create;
end;

destructor TdxGanttControlSheetCustomViewInfo.Destroy;
begin
  FreeAndNil(FCachedDataRowHeight);
  FreeAndNil(FDataRows);
  FreeAndNil(FGridlines);
  FreeAndNil(FHeaders);
  inherited Destroy;
end;

procedure TdxGanttControlSheetCustomViewInfo.Reset;
begin
  inherited Reset;
  FCachedDataRowHeight.Clear;
  FCachedImageHeight := 0;
end;

procedure TdxGanttControlSheetCustomViewInfo.AppendDataRow(ARowIndex: Integer);
var
  AHeight: Integer;
  AData: TObject;
  R: TRect;
begin
  if FDataRows.Count = 0 then
    AHeight := FHeaders[0].Bounds.Bottom
  else
    AHeight := FDataRows.Last.Bounds.Bottom;

  if ARowIndex < DataProvider.Count then
    AData := DataProvider.Items[ARowIndex]
  else
    AData := nil;
  FDataRows.Add(TdxGanttControlSheetDataRowViewInfo.Create(Self, FDataRows.Count, AData));
  FDataRows.Last.CalculateLayout;
  R := Bounds;
  R.Top := AHeight;
  R.Bottom := R.Top + FDataRows.Last.MeasureHeight;
  FDataRows.Last.Calculate(R);
end;

procedure TdxGanttControlSheetCustomViewInfo.AppendDataRows;
var
  I: Integer;
  ABottom: Integer;
begin
  I := FFirstVisibleRowIndex + DataRows.Count;
  ABottom := ClientRect.Bottom;
  repeat
    AppendDataRow(I);
    Inc(I);
  until FDataRows.Last.Bounds.Bottom > ABottom;
end;

procedure TdxGanttControlSheetCustomViewInfo.CalculateDataRows;
begin
  FDataRows.Clear;
  AppendDataRows;
end;

function TdxGanttControlSheetCustomViewInfo.CalculateFocusedCellViewInfo: TdxGanttControlSheetCellCustomViewInfo;
begin
  Result := GetCellViewInfo(FocusedCell);
end;

procedure TdxGanttControlSheetCustomViewInfo.CalculateGridlines;
var
  I: Integer;
begin
  FGridlines.Clear;
  for I := 0 to FHeaders.Count - 1 do
  begin
    if FHeaders[I] is TdxGanttControlSheetColumnHeaderViewInfo then
    begin
      if UseRightToLeftAlignment then
        FGridlines.Add(TRect.Create(FHeaders[I].Bounds.Left, FHeaders[I].Bounds.Bottom, FHeaders[I].Bounds.Left + GridLineThickness, ClientRect.Bottom))
      else
        FGridlines.Add(TRect.Create(FHeaders[I].Bounds.Right - GridLineThickness, FHeaders[I].Bounds.Bottom, FHeaders[I].Bounds.Right, ClientRect.Bottom));
    end;
  end;
end;

procedure TdxGanttControlSheetCustomViewInfo.CalculateHeaders;
var
  I: Integer;
  AWidth, AMaxWidth: Integer;
  AHeaderRowWidth: Integer;
  R: TRect;
  AColumn: TdxGanttControlSheetColumn;
  AColumnBounds: TRect;
  AColumnHeight: Integer;
  AVisibleColumnCount: Integer;
begin
  FHeaders.Clear;
  AHeaderRowWidth := ScaleFactor.Apply(Options.RowHeaderWidth);
  if IsTouchModeEnabled then
    AHeaderRowWidth := dxGetTouchableSize(AHeaderRowWidth, ScaleFactor);
  R.Top := Bounds.Top;
  R.Bottom := Bounds.Top + GetColumnHeaderHeight;
  if UseRightToLeftAlignment then
  begin
    R.Left := Bounds.Right - AHeaderRowWidth;
    R.Right := Bounds.Right;
  end
  else
  begin
    R.Left := Bounds.Left;
    R.Right := Bounds.Left + AHeaderRowWidth;
  end;
  FHeaders.Add(TdxGanttControlSheetHeaderGripViewInfo.Create(Self));
  FHeaders.Last.Calculate(R);
  AMaxWidth := Bounds.Width - R.Width;
  FVisibleColumnCount := 0;
  AColumnHeight := R.Height;
  AWidth := 0;
  AVisibleColumnCount := Options.Columns.VisibleCount + IfThen(Controller.ColumnInsertEditIndex >= 0, 1, 0);
  if (AVisibleColumnCount > 0) and (AVisibleColumnCount > FFirstVisibleColumnIndex) then
  begin
    I := FFirstVisibleColumnIndex;
    repeat
      if Controller.ColumnInsertEditIndex <> I then
      begin
        if (Controller.ColumnInsertEditIndex <> -1) and (Controller.ColumnInsertEditIndex < I) then
          AColumn := Options.Columns.VisibleItems[I - 1]
        else
          AColumn := Options.Columns.VisibleItems[I];
        FHeaders.Add(AColumn.CreateViewInfo(Self));
        AColumnBounds := TRect.Create(0, 0, ScaleFactor.Apply(AColumn.Width), AColumnHeight);
      end
      else
      begin
        FHeaders.Add(TdxGanttControlSheetColumnInsertHeaderViewInfo.Create(Self));
        AColumnBounds := TRect.Create(0, 0, ScaleFactor.Apply(TdxGanttControlSheetColumn.DefaultWidth), AColumnHeight);
      end;
      if UseRightToLeftAlignment then
        AColumnBounds.Offset(R.Left - AWidth - AColumnBounds.Width, R.Top)
      else
        AColumnBounds.Offset(R.Right + AWidth, R.Top);
      FHeaders.Last.Calculate(AColumnBounds);
      AWidth := AWidth + FHeaders.Last.Bounds.Width;
      Inc(FVisibleColumnCount);
      Inc(I);
    until (AWidth > AMaxWidth) or (I >= AVisibleColumnCount);
  end;

  if AWidth < AMaxWidth then
  begin
    FHeaders.Add(TdxGanttControlSheetColumnEmptyHeaderViewInfo.Create(Self));
    AColumnBounds := TRect.Create(0, 0, AMaxWidth - AWidth + 1, AColumnHeight);
    if UseRightToLeftAlignment then
      AColumnBounds.Offset(Bounds.Left - 1, R.Top)
    else
      AColumnBounds.Offset(R.Right + AWidth, R.Top);
    FHeaders.Last.Calculate(AColumnBounds);
  end
  else
    Dec(FVisibleColumnCount);
end;

function TdxGanttControlSheetCustomViewInfo.CalculateClientRect: TRect;
begin
  Result := Controller.ScrollBars.GetClientRect(Bounds);
end;

procedure TdxGanttControlSheetCustomViewInfo.DrawSelection;
var
  R: TRect;
  I: Integer;
begin
  if not LookAndFeelPainter.ApplyEditorAdvancedMode then
    for I := 0 to FDataRows.Count - 1 do
    begin
      if not FDataRows[I].IsFocused then
        Continue;
      R := FDataRows[I].LineBounds;
      Canvas.FillRect(R, LookAndFeelPainter.SpreadSheetSelectionColor);
      R.MoveToTop(FDataRows[I].Bounds.Top - GridLineThickness);
      Canvas.FillRect(R, LookAndFeelPainter.SpreadSheetSelectionColor);
    end;
  if FocusedCellViewInfo <> nil then
  begin
    R := FocusedCellViewInfo.Bounds;
    R.Bottom := R.Bottom - GridLineThickness;
    R.Right := R.Right - GridLineThickness;
    if UseRightToLeftAlignment then
      R.Offset(cxTextOffsetHalf, 0);
    Canvas.FrameRect(R, LookAndFeelPainter.SpreadSheetSelectionColor, FocusRectThickness);
  end;
end;

procedure TdxGanttControlSheetCustomViewInfo.Clear;
begin
  inherited Clear;
  FCachedImageHeight := 0;
end;

function TdxGanttControlSheetCustomViewInfo.CalculateHitTest(
  const AHitTest: TdxGanttControlHitTest): Boolean;
var
  I: Integer;
begin
  Result := ClientRect.Contains(AHitTest.HitPoint) and inherited CalculateHitTest(AHitTest);
  if Result then
  begin
    for I := 0 to FHeaders.Count - 1 do
      if FHeaders[I].CalculateHitTest(AHitTest) then
        Exit(True);
    for I := 0 to DataRows.Count - 1 do
      if DataRows[I].CalculateHitTest(AHitTest) then
        Exit(True);
  end;
end;

procedure TdxGanttControlSheetCustomViewInfo.CalculateScrollBars;
begin
  Controller.ScrollBars.CalculateScrollBars;
end;

procedure TdxGanttControlSheetCustomViewInfo.Calculate(const R: TRect);
begin
  ResetFocusedCellViewInfo;
  UpdateCachedValues;
  inherited Calculate(R);
  CalculateHeaders;
  FClientRect := CalculateClientRect;
  CalculateDataRows;
  CalculateGridlines;
  CalculateScrollBars;
end;

procedure TdxGanttControlSheetCustomViewInfo.ViewChanged;

  procedure MoveDown;
  var
    ATop: Integer;
    I: Integer;
  begin
    for I := FFirstVisibleRowIndex - 1 downto Controller.FirstVisibleRowIndex do
    begin
      AppendDataRow(I);
      DataRows.Move(DataRows.Count - 1, 0);
    end;
    FFirstVisibleRowIndex := Controller.FirstVisibleRowIndex;
    ATop := Headers[0].Bounds.Bottom;
    for I := 0 to DataRows.Count - 1 do
    begin
      DataRows[I].DoScroll(0, ATop - DataRows[I].Bounds.Top);
      ATop := DataRows[I].Bounds.Bottom;
    end;
    for I := DataRows.Count - 1 downto 0 do
      if DataRows[I].Bounds.Top > ClientRect.Bottom then
        DataRows.Delete(I)
      else
        DataRows[I].UpdateIndex(I);
    end;

  procedure MoveUp;
  var
    AOffset: Integer;
    I: Integer;
  begin
    AOffset := 0;
    for I := FFirstVisibleRowIndex to Controller.FirstVisibleRowIndex - 1 do
    begin
      AOffset := AOffset + DataRows.First.Bounds.Height;
      DataRows.Delete(0);
    end;
    FFirstVisibleRowIndex := Controller.FirstVisibleRowIndex;
    for I := 0 to DataRows.Count - 1 do
    begin
      DataRows[I].UpdateIndex(I);
      DataRows[I].DoScroll(0, -AOffset);
    end;
    AppendDataRows;
    for I := DataRows.Count - 1 downto 0 do
      if DataRows[I].Bounds.Top > ClientRect.Bottom then
        DataRows.Delete(I)
      else
        Break;
  end;

var
  ARecalculateNeeded: Boolean;
  I: Integer;
begin
  if (FFirstVisibleColumnIndex <> Controller.FirstVisibleColumnIndex) or
    (FFirstVisibleRowIndex <> Controller.FirstVisibleRowIndex) then
  begin
    ARecalculateNeeded := True;
    if (FFirstVisibleColumnIndex = Controller.FirstVisibleColumnIndex) and
      (DataRows.Count > Abs(FFirstVisibleRowIndex - Controller.FirstVisibleRowIndex)) then
    begin
      if FFirstVisibleRowIndex < Controller.FirstVisibleRowIndex then
        MoveUp
      else
        MoveDown;
      ARecalculateNeeded := False;
    end;
    if FFirstVisibleRowIndex = Controller.FirstVisibleRowIndex then
    begin
      FFirstVisibleColumnIndex := Controller.FirstVisibleColumnIndex;
      CalculateHeaders;
      CalculateGridlines;
      for I := 0 to DataRows.Count - 1 do
        DataRows[I].ViewChanged;
      Controller.ScrollBars.CalculateScrollBars;
      ARecalculateNeeded := False;
    end;
    if ARecalculateNeeded then
      Recalculate
    else
      ResetFocusedCellViewInfo;
  end;
end;

procedure TdxGanttControlSheetCustomViewInfo.DoDraw;
var
  I: Integer;
begin
  Canvas.FillRect(Bounds, LookAndFeelPainter.DefaultContentColor);
  DrawSizeGrip;
  for I := 0 to FHeaders.Count - 1 do
    FHeaders[I].Draw;
  for I := 0 to FDataRows.Count - 1 do
    FDataRows[I].Draw;
  for I := 0 to FGridlines.Count - 1 do
    Canvas.FillRect(FGridlines[I], LookAndFeelPainter.DefaultGridLineColor);
  DrawSelection;
end;

procedure TdxGanttControlSheetCustomViewInfo.DrawSizeGrip;
begin
  Controller.ScrollBars.DrawSizeGrip(Canvas);
end;

function TdxGanttControlSheetCustomViewInfo.GetColumnHeaderHeight: Integer;
begin
  Result := GetHeaderDefaultHeight;
  if IsTouchModeEnabled then
    Result := dxGetTouchableSize(Result, ScaleFactor);
end;

function TdxGanttControlSheetCustomViewInfo.GetFocusedCell: TPoint;
begin
  Result := Controller.FocusedCell;
end;

procedure TdxGanttControlSheetCustomViewInfo.ResetFocusedCellViewInfo;
begin
  FFocusedCellViewInfo := nil;
end;

function TdxGanttControlSheetCustomViewInfo.GetFocusedCellViewInfo: TdxGanttControlSheetCellCustomViewInfo;
begin
  if FFocusedCellViewInfo = nil then
    FFocusedCellViewInfo := CalculateFocusedCellViewInfo;
  Result := FFocusedCellViewInfo;
end;

function TdxGanttControlSheetCustomViewInfo.GetVisibleRowCount: Integer;
begin
  Result := DataRows.Count;
  if (Result > 0) and (ClientRect.Bottom < DataRows.Last.Bounds.Bottom) then
    Dec(Result);
end;

function TdxGanttControlSheetCustomViewInfo.GetController: TdxGanttControlSheetController;
begin
  Result := Options.Controller;
end;

function TdxGanttControlSheetCustomViewInfo.GetImageHeight: Integer;
begin
  if FCachedImageHeight = 0 then
    FCachedImageHeight := GetItemDefaultHeight(Options.RowHeight) - GridLineThickness - TextPadding.Height;
  Result := FCachedImageHeight;
end;

function TdxGanttControlSheetCustomViewInfo.GetQuickCustomizationPopupOwnerBounds: TRect;
begin
  if (Headers.Count > 0) and (Headers[0].ViewInfoCount > 0) then
    Result := Headers[0].ViewInfos[0].Bounds
  else
    Result := TRect.Null;
end;

function TdxGanttControlSheetCustomViewInfo.GetCellViewInfo(const P: TPoint): TdxGanttControlSheetCellCustomViewInfo;
var
  X, Y: Integer;
begin
  Result := nil;
  Y := P.Y - Controller.FirstVisibleRowIndex;
  if (Y >= 0) and (Y < DataRows.Count) then
  begin
    X := P.X - Controller.FirstVisibleColumnIndex;
    if (X >= 0) and (X < DataRows[Y].Cells.Count) then
      Result := DataRows[Y].Cells[X];
  end;
end;

function TdxGanttControlSheetCustomViewInfo.AreExpandButtonsVisible: Boolean;
begin
  Result := True;
end;

function TdxGanttControlSheetCustomViewInfo.IsTouchModeEnabled: Boolean;
begin
  Result := cxIsTouchModeEnabled;
end;

procedure TdxGanttControlSheetCustomViewInfo.UpdateCachedValues;
begin
  FDataProvider := Controller.DataProvider;
  FFirstVisibleColumnIndex := Controller.FirstVisibleColumnIndex;
  FFirstVisibleRowIndex := Controller.FirstVisibleRowIndex;
end;

{ TdxGanttControlSheetColumn }

constructor TdxGanttControlSheetColumn.Create(AOwner: TdxGanttControlSheetColumns);
begin
  inherited Create(AOwner);
  FStoringUID := Owner.GetStoringUID(Self);
  FProperties := CreateProperties;
  DoReset;
end;

function TdxGanttControlSheetColumn.CreateChangeValueCommand(
  AControl: TdxGanttControlBase; ADataItem: TObject;
  const ANewValue: Variant): TdxGanttControlCommand;
begin
  Result := nil;
end;

destructor TdxGanttControlSheetColumn.Destroy;
begin
  FreeAndNil(FProperties);
  inherited Destroy;
end;

procedure TdxGanttControlSheetColumn.Assign(Source: TPersistent);
var
  ASource: TdxGanttControlSheetColumn;
begin
  if Source is TdxGanttControlSheetColumn then
  begin
    ASource := TdxGanttControlSheetColumn(Source);
    Caption := ASource.Caption;
    ShowFilterButton := ASource.ShowFilterButton;
    Visible := ASource.Visible;
    AllowHide := ASource.AllowHide;
    AllowRename := ASource.AllowRename;
    AllowInsert := ASource.AllowInsert;
    AllowMove := ASource.AllowMove;
    AllowSize := ASource.AllowSize;
    AllowWordWrap := ASource.AllowWordWrap;
    Width := ASource.Width;
    WordWrap := ASource.WordWrap;
  end
  else
    inherited Assign(Source);
end;

function TdxGanttControlSheetColumn.RealAllowHide: Boolean;
begin
  Result := dxDefaultBooleanToBoolean(AllowHide, Owner.Owner.AllowColumnHide);
end;

function TdxGanttControlSheetColumn.RealAllowInsert: Boolean;
begin
  Result := dxDefaultBooleanToBoolean(AllowInsert, Owner.Owner.AllowColumnInsert);
end;

function TdxGanttControlSheetColumn.RealAllowMove: Boolean;
begin
  Result := dxDefaultBooleanToBoolean(AllowMove, Owner.Owner.AllowColumnMove);
end;

function TdxGanttControlSheetColumn.RealAllowRename: Boolean;
begin
  Result := dxDefaultBooleanToBoolean(AllowRename, Owner.Owner.AllowColumnRename);
end;

function TdxGanttControlSheetColumn.RealAllowSize: Boolean;
begin
  Result := dxDefaultBooleanToBoolean(AllowSize, Owner.Owner.AllowColumnSize);
end;

function TdxGanttControlSheetColumn.RealAllowWordWrap: Boolean;
begin
  Result := dxDefaultBooleanToBoolean(AllowWordWrap, Owner.Owner.CellAutoHeight);
end;

procedure TdxGanttControlSheetColumn.RecreateProperties;
begin
  FProperties.Free;
  FProperties := CreateProperties;
end;

procedure TdxGanttControlSheetColumn.Changed;
begin
  Owner.Changed;
end;

procedure TdxGanttControlSheetColumn.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('UID', ReadUID, nil, True);
end;

procedure TdxGanttControlSheetColumn.ReadUID(Reader: TReader);
begin
  FStoringUID := Reader.ReadInteger;
end;

procedure TdxGanttControlSheetColumn.WriteProperties(Writer: TWriter);
var
  APropInfo: PPropInfo;
begin
  Writer.WriteUTF8Str('ItemClass');
  Writer.WriteString(ClassName);

  Writer.WriteUTF8Str('UID');
  Writer.WriteInteger(FStoringUID);

  APropInfo := GetPropInfo(ClassInfo, 'AllowHide');

  if AllowHide <> bDefault then
  begin
    Writer.WriteUTF8Str('AllowHide');
    TWriterAccess(Writer).WriteIdent(GetEnumName(APropInfo^.PropType^, Ord(AllowHide)));
  end;

  if AllowInsert <> bDefault then
  begin
    Writer.WriteUTF8Str('AllowInsert');
    TWriterAccess(Writer).WriteIdent(GetEnumName(APropInfo^.PropType^, Ord(AllowInsert)));
  end;

  if AllowMove <> bDefault then
  begin
    Writer.WriteUTF8Str('AllowMove');
    TWriterAccess(Writer).WriteIdent(GetEnumName(APropInfo^.PropType^, Ord(AllowMove)));
  end;

  if IsAllowRenameStored then
  begin
    Writer.WriteUTF8Str('AllowRename');
    TWriterAccess(Writer).WriteIdent(GetEnumName(APropInfo^.PropType^, Ord(AllowRename)));
  end;

  if AllowSize <> bDefault then
  begin
    Writer.WriteUTF8Str('AllowSize');
    TWriterAccess(Writer).WriteIdent(GetEnumName(APropInfo^.PropType^, Ord(AllowSize)));
  end;

  if IsAllowWordWrapStored then
  begin
    Writer.WriteUTF8Str('AllowWordWrap');
    TWriterAccess(Writer).WriteIdent(GetEnumName(APropInfo^.PropType^, Ord(AllowWordWrap)));
  end;

  if IsCaptionStored then
  begin
    Writer.WriteUTF8Str('Caption');
    Writer.WriteString(Caption);
  end;

  if IsShowFilterButtonStored then
  begin
    Writer.WriteUTF8Str('ShowFilterButton');
    Writer.WriteBoolean(ShowFilterButton);
  end;

  if IsVisibleStored then
  begin
    Writer.WriteUTF8Str('Visible');
    Writer.WriteBoolean(Visible);
  end;

  if IsWidthStored then
  begin
    Writer.WriteUTF8Str('Width');
    Writer.WriteInteger(Width);
  end;

  if IsWordWrapStored then
  begin
    Writer.WriteUTF8Str('WordWrap');
    Writer.WriteBoolean(WordWrap);
  end;
end;

procedure TdxGanttControlSheetColumn.DoCaptionChanged(const ANewCaption: string);
begin
  FIsCaptionAssigned := ANewCaption <> GetDefaultCaption;
  Owner.Owner.DoColumnCaptionChanged(Self);
end;

procedure TdxGanttControlSheetColumn.DoReset;
begin
  FWidth := GetDefaultWidth;
  FVisible := GetDefaultVisible;
  FCaption := GetDefaultCaption;
  FIsCaptionAssigned := False;
  FAllowHide := bDefault;
  FAllowInsert := bDefault;
  FAllowRename := GetDefaultAllowRename;
  FAllowMove := bDefault;
  FAllowSize := bDefault;
  FAllowWordWrap := GetDefaultAllowWordWrap;
  FShowFilterButton := GetDefaultShowFilterButton;
  FWordWrap := GetDefaultWordWrap;
end;

function TdxGanttControlSheetColumn.GetAlignment: TAlignment;
begin
  Result := taLeftJustify;
end;

function TdxGanttControlSheetColumn.GetCaption: string;
begin
  if FIsCaptionAssigned then
    Result := FCaption
  else
    Result := GetDefaultCaption;
end;

function TdxGanttControlSheetColumn.GetCollection: TdxGanttControlSheetColumns;
begin
  Result := TdxGanttControlSheetColumns(inherited Owner);
end;

function TdxGanttControlSheetColumn.CanShowFilterButton: Boolean;
begin
  Result := True;
end;

function TdxGanttControlSheetColumn.CreateProperties: TcxCustomEditProperties;
begin
  if GetPropertiesClass <> nil then
    Result := GetPropertiesClass.Create(Self)
  else
    Result := nil;
end;

function TdxGanttControlSheetColumn.CreateViewInfo(ASheetViewInfo: TdxGanttControlSheetCustomViewInfo): TdxGanttControlSheetColumnHeaderViewInfo;
begin
  Result := TdxGanttControlSheetColumnHeaderViewInfo.Create(ASheetViewInfo, Self);
end;

function TdxGanttControlSheetColumn.IsEditable: Boolean;
begin
  Result := GetPropertiesClass <> nil;
end;

function TdxGanttControlSheetColumn.GetDataCellViewInfoClass: TdxGanttControlSheetCellViewInfoClass;
begin
  Result := TdxGanttControlSheetCellViewInfo;
end;

function TdxGanttControlSheetColumn.GetDefaultAllowRename: TdxDefaultBoolean;
begin
  Result := bDefault;
end;

function TdxGanttControlSheetColumn.GetDefaultAllowWordWrap: TdxDefaultBoolean;
begin
  Result := bDefault;
end;

function TdxGanttControlSheetColumn.GetDefaultCaption: string;
begin
  Result := '';
end;

function TdxGanttControlSheetColumn.GetDefaultShowFilterButton: Boolean;
begin
  Result := False;
end;

function TdxGanttControlSheetColumn.GetDefaultImageIndex: Integer;
begin
  Result := -1;
end;

function TdxGanttControlSheetColumn.GetDefaultVisible: Boolean;
begin
  Result := True;
end;

function TdxGanttControlSheetColumn.GetDefaultWidth: Integer;
begin
  Result := DefaultWidth;
end;

function TdxGanttControlSheetColumn.GetDefaultWordWrap: Boolean;
begin
  Result := False;
end;

class function TdxGanttControlSheetColumn.GetDesignCaption: string;
begin
  Result := '';
end;

function TdxGanttControlSheetColumn.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := nil;
end;

procedure TdxGanttControlSheetColumn.PrepareEditProperties(AProperties: TcxCustomEditProperties; AData: TObject);
begin
// do nothing
end;

function TdxGanttControlSheetColumn.ShowEditorImmediately: Boolean;
begin
  Result := False;
end;

function TdxGanttControlSheetColumn.GetEditValue(AData: TObject): Variant;
begin
  Result := Null;
end;

function TdxGanttControlSheetColumn.GetHintText: string;
begin
  Result := '';
end;

function TdxGanttControlSheetColumn.GetIndex: Integer;
begin
  Result := Owner.IndexOf(Self);
end;

function TdxGanttControlSheetColumn.GetScaleFactor: TdxScaleFactor;
begin
  Result := Owner.ScaleFactor;
end;

function TdxGanttControlSheetColumn.GetVisibleIndex: Integer;
var
  I: Integer;
begin
  Result := -1;
  if not Visible then
    Exit;
  for I := 0 to Owner.Count - 1 do
  begin
    if not Owner.Items[I].Visible then
      Continue;
    Inc(Result);
    if Owner.Items[I] = Self then
      Break;
  end;
end;

function TdxGanttControlSheetColumn.IsAllowRenameStored: Boolean;
begin
  Result := AllowRename <> GetDefaultAllowRename;
end;

function TdxGanttControlSheetColumn.IsAllowWordWrapStored: Boolean;
begin
  Result := AllowWordWrap <> GetDefaultAllowWordWrap;
end;

function TdxGanttControlSheetColumn.IsCaptionStored: Boolean;
begin
  Result := FIsCaptionAssigned;
end;

function TdxGanttControlSheetColumn.IsShowFilterButtonStored: Boolean;
begin
  Result := ShowFilterButton <> GetDefaultShowFilterButton;
end;

function TdxGanttControlSheetColumn.IsVisibleStored: Boolean;
begin
  Result := Visible <> GetDefaultVisible;
end;

function TdxGanttControlSheetColumn.IsWidthStored: Boolean;
begin
  Result := Width <> GetDefaultWidth;
end;

function TdxGanttControlSheetColumn.IsWordWrapStored: Boolean;
begin
  Result := WordWrap <> GetDefaultWordWrap;
end;

procedure TdxGanttControlSheetColumn.Reset;
begin
  Owner.BeginUpdate;
  try
    DoReset;
  finally
    Owner.EndUpdate;
  end;
end;

procedure TdxGanttControlSheetColumn.SetCaption(const Value: string);
begin
  if Caption <> Value then
  begin
    FCaption := Value;
    DoCaptionChanged(FCaption);
    Changed;
  end;
end;

procedure TdxGanttControlSheetColumn.SetShowFilterButton(const Value: Boolean);
begin
  if (ShowFilterButton = Value) and (not Value or CanShowFilterButton) then
  begin
    FShowFilterButton := Value;
    Changed;
  end;
end;

procedure TdxGanttControlSheetColumn.SetIndex(const Value: Integer);
begin
  Owner.Move(Index, Value);
end;

procedure TdxGanttControlSheetColumn.SetVisible(const Value: Boolean);
begin
  if Visible <> Value then
  begin
    FVisible := Value;
    Owner.Owner.DoColumnVisibilityChanged(Self);
    Changed;
  end;
end;

procedure TdxGanttControlSheetColumn.SetWidth(const Value: Integer);
begin
  if (Width <> Value) and (Value >= MinWidth) then
  begin
    FWidth := Value;
    Owner.Owner.DoColumnSizeChanged(Self);
    Changed;
    SetDesignerModified(Owner.Owner.Control);
  end;
end;

procedure TdxGanttControlSheetColumn.SetWordWrap(const Value: Boolean);
begin
  if FWordWrap <> Value then
  begin
    FWordWrap := Value;
    Owner.Owner.DoColumnWordWrapChanged(Self);
    Changed;
    SetDesignerModified(Owner.Owner.Control);
  end;
end;

// IcxStoredObject

function TdxGanttControlSheetColumn.GetObjectName: string;
begin
  Result := Format('%s%d', [ClassName, FStoringUID]);
  FStoringIndex := Index + 10000;  
end;

function TdxGanttControlSheetColumn.GetProperties(AProperties: TStrings): Boolean;
begin
  AProperties.Add('Caption');
  AProperties.Add('IndexInColumns');
  AProperties.Add('Visible');
  AProperties.Add('Width');
  AProperties.Add('WordWrap');
  if Assigned(OnGetStoredProperties) then
    OnGetStoredProperties(Self, AProperties);
  Result := True;
end;

procedure TdxGanttControlSheetColumn.GetPropertyValue(const AName: string; var AValue: Variant);
begin
  if AName = 'IndexInColumns' then
    AValue := Index;
  if Assigned(OnGetStoredPropertyValue) then
    OnGetStoredPropertyValue(Self, AName, AValue);
end;

procedure TdxGanttControlSheetColumn.SetPropertyValue(const AName: string; const AValue: Variant);
begin
  if AName = 'IndexInColumns' then
    FStoringIndex := AValue;
  if Assigned(OnSetStoredPropertyValue) then
    OnSetStoredPropertyValue(Self, AName, AValue);
end;

{ TdxGanttControlSheetColumns }

constructor TdxGanttControlSheetColumns.Create(AOwner: TdxGanttControlSheetOptions);
begin
  inherited Create(AOwner);
  FRegisteredColumnClasses := TList<TdxGanttControlSheetColumnClass>.Create;
  RegisterColumnClasses;
  FList := TObjectList<TdxGanttControlSheetColumn>.Create;
end;

destructor TdxGanttControlSheetColumns.Destroy;
begin
  FreeAndNil(FList);
  FreeAndNil(FRegisteredColumnClasses);
  inherited Destroy;
end;

procedure TdxGanttControlSheetColumns.AfterConstruction;
begin
  inherited AfterConstruction;
  DoReset;
end;

procedure TdxGanttControlSheetColumns.BeginUpdate;
begin
  Inc(FLockCount);
end;

procedure TdxGanttControlSheetColumns.Changed;
begin
  if FLockCount = 0 then
    Owner.Changed([TdxGanttControlOptionsChangedType.Size]);
end;

procedure TdxGanttControlSheetColumns.Clear;
begin
  FList.Clear;
  Changed;
end;

procedure TdxGanttControlSheetColumns.DoReset;
var
  I: Integer;
begin
  Clear;
  for I := 0 to RegisteredColumnClasses.Count - 1 do
    Add(RegisteredColumnClasses[I]);
end;

procedure TdxGanttControlSheetColumns.EndUpdate;
begin
  Dec(FLockCount);
  Changed;
end;

procedure TdxGanttControlSheetColumns.Extract(
  AItem: TdxGanttControlSheetColumn);
begin
  FList.Extract(AItem);
end;

function TdxGanttControlSheetColumns.GetStoringUID(AColumn: TdxGanttControlSheetColumn): Integer;
var
  AIsPresent: Boolean;
  I: Integer;
begin
  Result := 1;
  repeat
    AIsPresent := False;
    for I := 0 to Count - 1 do
    begin
      AIsPresent := (AColumn.ClassType = Items[I].ClassType) and (Result = Items[I].StoringUID);
      if AIsPresent then
      begin
        Inc(Result);
        Break;
      end;
    end;
  until not AIsPresent;
end;

procedure TdxGanttControlSheetColumns.DataReaderHandler(Reader: TReader);
var
  AClass: string;
  AItem: TdxGanttControlSheetColumn;
  AItemClass: TClass;
begin
  if Reader.NextValue = vaCollection then
    Reader.ReadValue;
  BeginUpdate;
  try
    Clear;
    while not Reader.EndOfList do
    begin
      if Reader.NextValue in [vaInt8, vaInt16, vaInt32] then Reader.ReadInteger;
      Reader.ReadListBegin;
      AItem := nil;
      if Reader.ReadStr = 'ItemClass' then
      begin
        AClass := Reader.ReadString;
        AItemClass := FindClass(AClass);
        if AItemClass <> nil then
          AItem := Add(TdxGanttControlSheetColumnClass(AItemClass));
      end;
      while not Reader.EndOfList do
        if AItem <> nil then
          TReaderAccess(Reader).ReadProperty(AItem)
        else
        begin
          Reader.ReadStr;
          Reader.ReadValue;
        end;
      Reader.ReadListEnd;
    end;
    Reader.ReadListEnd;
  finally
    EndUpdate;
  end;
end;

procedure TdxGanttControlSheetColumns.DataWriterHandler(Writer: TWriter);
var
  I: Integer;
begin
  TWriterAccess(Writer).WriteValue(vaCollection);
  for I := 0 to Count - 1 do
  begin
    Writer.WriteListBegin;
    Items[I].WriteProperties(Writer);
    Writer.WriteListEnd;
  end;
  Writer.WriteListEnd;
end;

function TdxGanttControlSheetColumns.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TdxGanttControlSheetColumns.GetItem(
  Index: Integer): TdxGanttControlSheetColumn;
begin
  Result := FList[Index];
end;

function TdxGanttControlSheetColumns.GetScaleFactor: TdxScaleFactor;
begin
  Result := Owner.ScaleFactor;
end;

function TdxGanttControlSheetColumns.IndexOf(
  AItem: TdxGanttControlSheetColumn): Integer;
begin
  Result := FList.IndexOf(AItem);
end;

procedure TdxGanttControlSheetColumns.Move(ACurrentIndex, ANewIndex: Integer);
begin
  FList.Move(ACurrentIndex, ANewIndex);
  Owner.DoColumnPositionChanged(Items[ANewIndex]);
  Changed;
  SetDesignerModified(Owner.Control);
end;

procedure TdxGanttControlSheetColumns.RegisterColumnClass(AClass: TdxGanttControlSheetColumnClass);
begin
  FRegisteredColumnClasses.Add(AClass);
end;

procedure TdxGanttControlSheetColumns.RegisterColumnClasses;
begin
//do nothing
end;

function TdxGanttControlSheetColumns.InternalGetOwner: TdxGanttControlSheetOptions;
begin
  Result := TdxGanttControlSheetOptions(inherited Owner);
end;

function TdxGanttControlSheetColumns.GetVisibleCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Count - 1 do
    if Items[I].Visible then
      Inc(Result);
end;

function TdxGanttControlSheetColumns.GetVisibleIndex(
  AItem: TdxGanttControlSheetColumn): Integer;
var
  I: Integer;
begin
  Result := -1;
  if AItem = nil then
    Exit;
  if not AItem.Visible then
    Exit;
  for I := 0 to Count - 1 do
  begin
    if not Items[I].Visible then
      Continue;
    Inc(Result);
    if Items[I] = AItem then
      Exit;
  end;
  Result := -1;
end;

function TdxGanttControlSheetColumns.GetVisibleItem(
  Index: Integer): TdxGanttControlSheetColumn;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if Items[I].Visible then
    begin
      if Index = 0 then
        Exit(Items[I]);
      Dec(Index);
    end;
  Result := nil;
end;

procedure TdxGanttControlSheetColumns.Reset;
begin
  BeginUpdate;
  try
    DoReset;
  finally
    EndUpdate;
  end;
end;

procedure TdxGanttControlSheetColumns.SetItem(Index: Integer;
  const Value: TdxGanttControlSheetColumn);
begin
  Items[Index].Assign(Value);
end;

procedure TdxGanttControlSheetColumns.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('Items', DataReaderHandler, DataWriterHandler, True);
end;

function TdxGanttControlSheetColumns.Add(AClass: TdxGanttControlSheetColumnClass): TdxGanttControlSheetColumn;
begin
  Result := AClass.Create(Self);
  FList.Add(Result);
  Changed;
end;

procedure TdxGanttControlSheetColumns.Delete(AIndex: Integer);
begin
  FList.Delete(AIndex);
  Changed;
end;

function TdxGanttControlSheetColumns.Insert(AIndex: Integer; AClass: TdxGanttControlSheetColumnClass): TdxGanttControlSheetColumn;
begin
  Result := AClass.Create(Self);
  FList.Insert(AIndex, Result);
  Changed;
end;

procedure TdxGanttControlSheetColumns.Remove(AItem: TdxGanttControlSheetColumn);
begin
  FList.Remove(AItem);
  Changed;
end;

// IcxStoredObject }

function TdxGanttControlSheetColumns.GetObjectName: string;
begin
  Result := 'Columns';
end;

function TdxGanttControlSheetColumns.GetProperties(AProperties: TStrings): Boolean;
begin
  Result := True;
end;

procedure TdxGanttControlSheetColumns.GetPropertyValue(const AName: string; var AValue: Variant);
begin
end;

procedure TdxGanttControlSheetColumns.Restored;
var
  AComparer: TdxGanttControlSheetColumnsComparer;
begin
  AComparer := TdxGanttControlSheetColumnsComparer.Create;
  try
    FList.Sort(AComparer);
  finally
    AComparer.Free;
  end;
  Changed;
end;

procedure TdxGanttControlSheetColumns.SetPropertyValue(const AName: string; const AValue: Variant);
begin
end;

// IcxStoredParent
procedure TdxGanttControlSheetColumns.DoInitStoredObject(AObject: TObject);
begin
  if (AObject <> nil) and Assigned(OnInitStoredObject) then
    FOnInitStoredObject(Self, AObject);
end;

function TdxGanttControlSheetColumns.StoredCreateChild(const AObjectName, AClassName: string): TObject;
begin
  Result := nil;
end;

procedure TdxGanttControlSheetColumns.StoredDeleteChild(const AObjectName: string; AObject: TObject);
begin
  Remove(AObject as TdxGanttControlSheetColumn);
end;

procedure TdxGanttControlSheetColumns.StoredChildren(AChildren: TStringList);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    AChildren.AddObject('', Items[I]);
end;

{ TdxGanttControlSheetCustomDataProvider }

function TdxGanttControlSheetCustomDataProvider.CanMove(ACurrentIndex,
  ANewIndex: Integer): Boolean;
begin
  Result := True;
end;

function TdxGanttControlSheetCustomDataProvider.GetRowHeaderCaption(
  AData: TObject): string;
begin
  Result := '';
end;

procedure TdxGanttControlSheetCustomDataProvider.MoveDataItem(AData: TObject; ANewIndex: Integer);
begin
// do nothing
end;

function TdxGanttControlSheetCustomDataProvider.InternalIndexOf(
  AItem: TObject): Integer;
var
  L, H: Integer;
  mid, cmp: Integer;
  AResult: Boolean;
begin
  if Count = 0 then
    Exit(-1);
  L := 0;
  H := Count - 1;
  AResult := False;
  while L <= H do
  begin
    mid := L + (H - L) shr 1;
    cmp := GetDataItemIndex(Items[mid]) - GetDataItemIndex(AItem);
    if cmp < 0 then
      L := mid + 1
    else
    begin
      H := mid - 1;
      if cmp = 0 then
      begin
        L := mid;
        AResult := True;
        Break;
      end;
    end;
  end;
  if AResult then
    Result := L
  else
    Result := -1;
end;

function TdxGanttControlSheetCustomDataProvider.IsBlank(
  ADataItem: TObject): Boolean;
begin
  Result := False;
end;

{ TdxGanttControlSheetEditingController }

constructor TdxGanttControlSheetEditingController.Create(AController: TdxGanttControlSheetController);
begin
  inherited Create(AController.Control);
  FController := AController;
end;

destructor TdxGanttControlSheetEditingController.Destroy;
begin
  FreeAndNil(FEditData);
  inherited Destroy;
end;

procedure TdxGanttControlSheetEditingController.DoUpdateEdit;
begin
  if not IsEditing or (Edit = nil) then
    Exit;

  if EditPreparing then
  begin
    AssignEditStyle;
    FEditPlaceBounds := GetEditBounds;
    Controller.Options.DoInitEdit(FocusedCellViewInfo.Column, Edit);
  end;
end;

function TdxGanttControlSheetEditingController.CanInitEditing: Boolean;
begin
  Result := (FocusedCellViewInfo <> nil) and FocusedCellViewInfo.Column.IsEditable;
  if Result then
  begin
    Result := Controller.Options.DoBeforeEdit(FocusedCellViewInfo.Column);
    Exit;
  end;
end;

procedure TdxGanttControlSheetEditingController.ClearEditingItem;
begin
// do nothing
end;

procedure TdxGanttControlSheetEditingController.DoHideEdit(Accept: Boolean);
var
  AEditValue, APreviousValue: Variant;
begin
  if Edit = nil then
    Exit;

  if Accept then
    Edit.Deactivate;

  if Accept and Edit.EditModified then
  begin
    AEditValue := Edit.EditValue;
    APreviousValue := GetValue;
    if not VarEquals(APreviousValue, AEditValue) then
      SetValue(AEditValue);
  end;
  UninitEdit;
  Edit.EditModified := False;
  if Controller.Control.CanFocusEx and (Edit <> nil) and Edit.IsFocused then
    Controller.Control.SetFocus;
  Edit.Visible := False;
  HideInplaceEditor;
end;

procedure TdxGanttControlSheetEditingController.DoShowEdit(AProc: TActivateEditProc);
begin
  try
    if Controller.Control.DragAndDropState = ddsNone then
      Controller.MakeFocusedCellVisible;
    if PrepareEdit(False) then
    begin
      Controller.ScrollBars.HideTouchScrollUI(True);
      AProc;
    end;
  except
    HideEdit(False);
    raise;
  end;
end;

function TdxGanttControlSheetEditingController.GetCancelEditingOnExit: Boolean;
begin
  Result := False;
end;

function TdxGanttControlSheetEditingController.GetEditParent: TWinControl;
begin
  Result := Controller.Control;
end;

function TdxGanttControlSheetEditingController.GetHideEditOnExit: Boolean;
begin
  Result := True;
end;

function TdxGanttControlSheetEditingController.GetHideEditOnFocusedRecordChange: Boolean;
begin
  Result := True;
end;

function TdxGanttControlSheetEditingController.GetFocusedCellBounds: TRect;
begin
  Result := FocusedCellViewInfo.GetEditBounds;
end;

function TdxGanttControlSheetEditingController.GetIsEditing: Boolean;
begin
  Result := (FocusedCellViewInfo <> nil) and (FocusedCellViewInfo.Column <> nil) and FocusedCellViewInfo.Column.IsEditable and
    (Edit <> nil);
end;

function TdxGanttControlSheetEditingController.GetValue: Variant;
begin
  Result := FocusedCellViewInfo.EditValue;
end;

procedure TdxGanttControlSheetEditingController.SetValue(const AValue: Variant);
var
  AIsEnabled: Boolean;
begin
  with Controller.CreateChangeCellValueCommand(AValue) do
  try
    AIsEnabled := Enabled;
    Execute;
  finally
    Free;
  end;
  Controller.Control.Update;
  if AIsEnabled then
    Controller.Options.DoEditValueChanged(FocusedCellViewInfo.Column);
end;

procedure TdxGanttControlSheetEditingController.StartEditingByTimer;
begin
// do nothing
end;

procedure TdxGanttControlSheetEditingController.UpdateInplaceParamsPosition;
begin
// do nothing
end;

procedure TdxGanttControlSheetEditingController.EditAfterKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
var
  AIsReplacementMode: Boolean;
  ATextEdit: TcxCustomTextEdit;
begin
  inherited EditAfterKeyDown(Sender, Key, Shift);
  AIsReplacementMode := VarIsSoftNull(Edit.EditValue) or VarIsSoftEmpty(Edit.EditValue) or VarIsSoftNull(GetValue)
    or VarIsSoftEmpty(GetValue);
  if Key in [VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT, VK_NEXT, VK_PRIOR, VK_HOME, VK_END] then
  begin
    if Edit is TcxCustomTextEdit then
      ATextEdit := TcxCustomTextEdit(Edit)
    else
      ATextEdit := nil;
    if AIsReplacementMode or (ATextEdit = nil) or
      (Controller.Options.RealAlwaysShowEditor and
        ((Key in [VK_UP, VK_DOWN, VK_NEXT, VK_PRIOR]) or
        ((ATextEdit.SelLength = 0) and
          ((Key in [VK_HOME, VK_LEFT]) and (ATextEdit.SelStart = 0)) or
          ((Key in [VK_END, VK_RIGHT]) and (ATextEdit.SelStart = Length(ATextEdit.Text)))))) then
    begin
      Controller.KeyDown(Key, Shift);
    end;
  end;
end;

procedure TdxGanttControlSheetEditingController.EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited EditKeyDown(Sender, Key, Shift);
  case Key of
    VK_ESCAPE:
      HideEdit(False);
    VK_TAB, VK_RETURN:
      begin
        HideEdit(True);
        Controller.KeyDown(Key, Shift);
      end;
  end;
  if not IsEditing then
    Key := 0;
end;

procedure TdxGanttControlSheetEditingController.EditKeyPress(Sender: TObject; var Key: Char);
begin
  Controller.MakeFocusedCellVisible;
  inherited EditKeyPress(Sender, Key);
end;

procedure TdxGanttControlSheetEditingController.EditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited EditKeyUp(Sender, Key, Shift);
end;

function TdxGanttControlSheetEditingController.PrepareEdit(AIsMouseEvent: Boolean): Boolean;
var
  AFocusedColumn: TdxGanttControlSheetColumn;
begin
  Result := IsEditing;
  if EditPreparing or EditHiding or not CanInitEditing then
    Exit;
  AFocusedColumn := nil;
  FEditPreparing := True;
  try
    Result := FocusedCellViewInfo <> nil;
    if Result then
    begin
      FreeAndNil(FEditData);
      FEdit := EditList.GetEdit(FocusedCellViewInfo.Column.Properties);
      Edit.Visible := False;
      Edit.Parent := nil;
      Edit.ActiveProperties.ReadOnly := Controller.Options.IsReadOnly;
      AFocusedColumn := FocusedCellViewInfo.Column;
      FocusedCellViewInfo.Invalidate;
    end;
    Result := Edit <> nil;

    if Result then
    begin
      PrepareCanvas;
      InitEdit;
      if AFocusedColumn <> nil then      
        AFocusedColumn.PrepareEditProperties(TcxCustomEditAccess(FEdit).Properties, FocusedCellViewInfo.Owner.Data);
    end;
  finally
    FEditPreparing := False;
  end;
end;

procedure TdxGanttControlSheetEditingController.UpdateEditPosition;
var
  R: TRect;
begin
  if Edit <> nil then
  begin
    R := GetEditBounds;
    FEditPlaceBounds := R;
    Edit.BoundsRect := R;
  end;
end;

procedure TdxGanttControlSheetEditingController.ShowEdit;
begin
  DoShowEdit(procedure
    begin
      FEdit.Activate(FEditData, Controller.Control.Focused);
    end);
end;

procedure TdxGanttControlSheetEditingController.ShowEditByKey(const AChar: Char);
begin
  DoShowEdit(procedure
    begin
      Edit.ActivateByKey(AChar, FEditData);
    end);
end;

procedure TdxGanttControlSheetEditingController.ShowEditByMouse;
begin
  DoShowEdit(procedure
    begin
      Edit.ActivateByMouse(KeyboardStateToShiftState, Controller.HitTest.HitPoint.X, Controller.HitTest.HitPoint.Y, FEditData);
    end);
end;

procedure TdxGanttControlSheetEditingController.AssignEditStyle;
var
  AStyle: TcxCustomEditStyleAccess;
begin
  AStyle := TcxCustomEditStyleAccess(Edit.Style);
  AStyle.LookAndFeel.MasterLookAndFeel := Controller.Control.LookAndFeel;
  AStyle.Font := FocusedCellViewInfo.GetFont;
  AStyle.Color := FocusedCellViewInfo.LookAndFeelPainter.DefaultContentColor;
  AStyle.TextColor := FocusedCellViewInfo.LookAndFeelPainter.DefaultContentTextColor;
  AStyle.ButtonTransparency := ebtHideInactive;
  AStyle.TransparentBorder := False;
  AStyle.Changed;
end;

function TdxGanttControlSheetEditingController.GetFocusedCellViewInfo: TdxGanttControlSheetCellViewInfo;
begin
  if Controller.FocusedCellViewInfo is TdxGanttControlSheetCellViewInfo then
    Result := TdxGanttControlSheetCellViewInfo(Controller.FocusedCellViewInfo)
  else
    Result := nil;
end;

function TdxGanttControlSheetEditingController.GetEditBounds: TRect;
begin
  Result := GetFocusedCellBounds;
  Result.Intersect(Controller.ViewInfo.Bounds);
  if Controller.ViewInfo.UseRightToLeftAlignment then
    Inc(Result.Left);
end;

procedure TdxGanttControlSheetEditingController.PrepareCanvas;
begin
  cxCopyDirectCanvasContentToGdiCanvas(TdxGanttControlBaseAccess(Controller.Control).ActualCanvas, Controller.Control.Canvas);
end;

{ TdxGanttControlSheetResizingObject }

constructor TdxGanttControlSheetResizingObject.Create(
  AController: TdxGanttControlCustomController;
  AViewInfo: TdxGanttControlSheetHeaderViewInfo);
begin
  inherited Create(AController);
  FViewInfo := AViewInfo;
end;

procedure TdxGanttControlSheetResizingObject.ApplyChanges(const P: TPoint);
var
  AWidth: Integer;
begin
  AWidth := Helper.CalculateResizePoint(FViewInfo, P).X;
  if FViewInfo.UseRightToLeftAlignment then
    AWidth := FViewInfo.Bounds.Right - AWidth
  else
    AWidth := AWidth - FViewInfo.Bounds.Left;
  SetWidth(AWidth);
end;

function TdxGanttControlSheetResizingObject.CanDrop(const P: TPoint): Boolean;
begin
  DragAndDrop(P, Result);
end;

procedure TdxGanttControlSheetResizingObject.DragAndDrop(const P: TPoint;
  var Accepted: Boolean);
var
  APos: TPoint;
begin
  Accepted := True;
  APos := Helper.CalculateResizePoint(FViewInfo, P);
  ShowDragImage(APos);
end;

function TdxGanttControlSheetResizingObject.GetController: TdxGanttControlSheetController;
begin
  Result := TdxGanttControlSheetController(inherited Controller);
end;

function TdxGanttControlSheetResizingObject.GetDragImageHeight: Integer;
begin
  Result := Controller.ViewInfo.ClientRect.Height;
end;

function TdxGanttControlSheetResizingObject.GetDragImageWidth: Integer;
begin
  Result := Controller.ViewInfo.ScaleFactor.Apply(Width);
end;

function TdxGanttControlSheetResizingObject.GetHelper: TdxGanttControlSheetDragHelper;
begin
  Result := TdxGanttControlSheetDragHelper(Controller.DragHelper);
end;

{ TdxGanttControlSheetColumnResizingObject }

function TdxGanttControlSheetColumnResizingObject.GetViewInfo: TdxGanttControlSheetColumnHeaderViewInfo;
begin
  Result := TdxGanttControlSheetColumnHeaderViewInfo(inherited ViewInfo);
end;

procedure TdxGanttControlSheetColumnResizingObject.SetWidth(
  const Value: Integer);
begin
  with TdxGanttControlSheetResizeColumnCommand.Create(Controller, ViewInfo.Column, Controller.ScaleFactor.Revert(Max(1, Value))) do
  try
    Execute;
  finally
    Free;
  end;
end;

{ TdxGanttControlSheetRowHeaderWidthResizingObject }

procedure TdxGanttControlSheetRowHeaderWidthResizingObject.SetWidth(
  const Value: Integer);
begin
  with TdxGanttControlSheetChangeRowHeaderWidthCommand.Create(Controller, Controller.ScaleFactor.Revert(Max(1, Value))) do
  try
    Execute;
  finally
    Free;
  end;
end;

{ TdxGanttControlSheetMovingObject }

constructor TdxGanttControlSheetMovingObject.Create(AController: TdxGanttControlCustomController);
begin
  inherited Create(AController);
end;

procedure TdxGanttControlSheetMovingObject.AfterDragAndDrop(Accepted: Boolean);
begin
  inherited AfterDragAndDrop(Accepted);
  Controller.ViewInfo.Invalidate;
end;

function TdxGanttControlSheetMovingObject.GetController: TdxGanttControlSheetController;
begin
  Result := TdxGanttControlSheetController(inherited Controller);
end;

{ TdxGanttControlSheetColumnMovingObject }

constructor TdxGanttControlSheetColumnMovingObject.Create(
  AController: TdxGanttControlCustomController;
  AColumn: TdxGanttControlSheetColumn);
begin
  inherited Create(AController);
  FColumn := AColumn;
  FFirstVisibleColumnIndex := Controller.FirstVisibleColumnIndex;
end;

function TdxGanttControlSheetColumnMovingObject.CanDrop(const P: TPoint): Boolean;
var
  AIndex: Integer;
  AViewInfo: TdxGanttControlSheetHeaderViewInfo;
begin
  Result := False;
  AViewInfo := GetHitViewInfo(P);
  if AViewInfo <> nil then
  begin
    AIndex := GetNewIndex(AViewInfo, P);
    Result := AIndex <> Column.Index;
  end
  else if Column.RealAllowHide and Controller.ViewInfo.Bounds.Contains(P) then
    Result := True;
end;

procedure TdxGanttControlSheetColumnMovingObject.ApplyChanges(const P: TPoint);
var
  AViewInfo: TdxGanttControlSheetHeaderViewInfo;
  AIndex: Integer;
begin
  AViewInfo := GetHitViewInfo(P);
  if AViewInfo = nil then
  begin
    with TdxGanttControlSheetHideColumnCommand.Create(Controller, Column.Index, FFirstVisibleColumnIndex) do
    try
      Execute;
    finally
      Free;
    end;
  end
  else
  begin
    AIndex := GetNewIndex(AViewInfo, P);
    with TdxGanttControlSheetMoveColumnCommand.Create(Controller, Column.Index, AIndex, FFirstVisibleColumnIndex) do
    try
      Execute;
    finally
      Free;
    end;
  end;
end;

function TdxGanttControlSheetColumnMovingObject.CreateDragImage: TcxDragImage;
var
  AViewInfo: TdxGanttControlSheetCustomViewInfo;
  ATopArrow, ABottomArrow: TRect;
  R: TRect;
begin
  AViewInfo := Controller.ViewInfo;
  Result := TcxDragImage.Create;
  ATopArrow := TcxDragAndDropArrow.CalculateBounds(AViewInfo.Headers[0].Bounds, AViewInfo.Headers[0].Bounds, apTop, AViewInfo.ScaleFactor, False);
  ABottomArrow := TcxDragAndDropArrow.CalculateBounds(AViewInfo.Headers[0].Bounds, AViewInfo.Headers[0].Bounds, apBottom, AViewInfo.ScaleFactor, False);
  Result.SetBounds(0, 0, Max(ATopArrow.Width, ABottomArrow.Width),
    ABottomArrow.Bottom - ATopArrow.Top);
  FTopArrowLocation := cxPointOffset(ATopArrow.Location, AViewInfo.Headers[0].Bounds.Location, False);
  Result.Canvas.Lock;
  try
    TcxCustomDragImageAccess(Result).TransparentColor := True;
    TcxCustomDragImageAccess(Result).TransparentColorValue := clWhite;
    Result.Canvas.FillRect(Result.ClientRect, clWhite);
    R := cxRectCenter(Result.BoundsRect, ATopArrow.Size);
    R.MoveToTop(Result.BoundsRect.Top);
    TcxDragAndDropArrow.Draw(Result.Canvas, R, apTop, AViewInfo.ScaleFactor);
    R := cxRectCenter(Result.BoundsRect, ABottomArrow.Size);
    R.MoveToBottom(Result.BoundsRect.Bottom);
    TcxDragAndDropArrow.Draw(Result.Canvas, R, apBottom, AViewInfo.ScaleFactor);
  finally
    Result.Canvas.Unlock;
  end;
end;

procedure TdxGanttControlSheetColumnMovingObject.DragAndDrop(const P: TPoint;
  var Accepted: Boolean);
var
  APos: TPoint;
  AViewInfo: TdxGanttControlSheetHeaderViewInfo;
begin
  CheckScrolling(P);
  Accepted := CanDrop(P);
  AViewInfo := GetHitViewInfo(P);
  if Accepted and (AViewInfo <> nil) then
  begin
    APos.Y := AViewInfo.Bounds.Top;
    if AViewInfo is TdxGanttControlSheetColumnEmptyHeaderViewInfo then
    begin
      if AViewInfo.UseRightToLeftAlignment then
        APos.X := AViewInfo.Bounds.Right
      else
        APos.X := AViewInfo.Bounds.Left;
    end
    else if HitTest.HitObject is TdxGanttControlSheetHeaderGripViewInfo then
    begin
      if AViewInfo.UseRightToLeftAlignment then
        APos.X := AViewInfo.Bounds.Left
      else
        APos.X := AViewInfo.Bounds.Right;
    end
    else
    begin
      if P.X < (AViewInfo.Bounds.Left + AViewInfo.Bounds.Right) div 2 then
        APos.X := AViewInfo.Bounds.Left
      else
        APos.X := AViewInfo.Bounds.Right;
    end;
    if Controller.ViewInfo.Bounds.Contains(APos) then
      ShowDragImage(cxPointOffset(APos, FTopArrowLocation))
    else
      HideDragImage;
  end
  else
    HideDragImage;
  if Accepted and (AViewInfo = nil) and Column.RealAllowHide then
    Screen.Cursor := TdxGanttControlCursors.HideColumn
  else
    inherited DragAndDrop(P, Accepted)
end;

function TdxGanttControlSheetColumnMovingObject.GetDragAndDropCursor(
  Accepted: Boolean): TCursor;
begin
  Result := inherited GetDragAndDropCursor(Accepted);
end;

function TdxGanttControlSheetColumnMovingObject.GetHitViewInfo(const P: TPoint): TdxGanttControlSheetHeaderViewInfo;
var
  I: Integer;
begin
  Result := nil;
  if HitTest.HitObject is TdxGanttControlSheetColumnHeaderViewInfo then
    Result := TdxGanttControlSheetColumnHeaderViewInfo(HitTest.HitObject)
  else if HitTest.HitObject is TdxGanttControlSheetColumnHeaderFilterButtonViewInfo then
    Result := TdxGanttControlSheetColumnHeaderFilterButtonViewInfo(HitTest.HitObject).Owner
  else if HitTest.HitObject is TdxGanttControlSheetColumnEmptyHeaderViewInfo then
    Result := TdxGanttControlSheetColumnEmptyHeaderViewInfo(HitTest.HitObject)
  else if HitTest.HitObject is TdxGanttControlSheetHeaderGripViewInfo then
    Result := TdxGanttControlSheetHeaderGripViewInfo(HitTest.HitObject)
  else
  begin
    if not Column.RealAllowHide and Controller.ViewInfo.Bounds.Contains(P) then
    begin
      for I := 0 to Controller.ViewInfo.Headers.Count - 1 do
      begin
        if (Controller.ViewInfo.Headers[I] is TdxGanttControlSheetColumnHeaderViewInfo) or
          (Controller.ViewInfo.Headers[I] is TdxGanttControlSheetColumnEmptyHeaderViewInfo) or
          (Controller.ViewInfo.Headers[I] is TdxGanttControlSheetHeaderGripViewInfo) then
        begin
          if (P.X >= Controller.ViewInfo.Headers[I].Bounds.Left) and (P.X < Controller.ViewInfo.Headers[I].Bounds.Right) then
            Exit(TdxGanttControlSheetHeaderViewInfo(Controller.ViewInfo.Headers[I]));
        end;
      end;
    end;
  end;
end;

function TdxGanttControlSheetColumnMovingObject.GetNewIndex(AHitViewInfo: TdxGanttControlSheetHeaderViewInfo; const P: TPoint): Integer;
var
  AColumnViewInfo: TdxGanttControlSheetColumnHeaderViewInfo;
begin
  if AHitViewInfo is TdxGanttControlSheetColumnEmptyHeaderViewInfo then
  begin
    if Controller.Options.Columns.Count > 0 then
      Result := Controller.Options.Columns.VisibleItems[Controller.Options.Columns.VisibleCount - 1].Index
    else
      Result := 0;
  end
  else if AHitViewInfo is TdxGanttControlSheetHeaderGripViewInfo then
    Result := 0
  else
  begin
    AColumnViewInfo := TdxGanttControlSheetColumnHeaderViewInfo(AHitViewInfo);
    Result := AColumnViewInfo.Column.Index;
    if AHitViewInfo.UseRightToLeftAlignment xor (P.X >= (AHitViewInfo.Bounds.Left + AHitViewInfo.Bounds.Right) div 2) then
    begin
      if Result < Column.Index then
        Inc(Result)
    end
    else
      if Result > Column.Index then
        Dec(Result);
  end;
end;

function TdxGanttControlSheetColumnMovingObject.VerticalScrollingSupports: Boolean;
begin
  Result := False;
end;

{ TdxGanttControlSheetRowMovingObject }

constructor TdxGanttControlSheetRowMovingObject.Create(AController: TdxGanttControlCustomController; ARowIndex: Integer);
begin
  inherited Create(AController);
  FRowIndex := ARowIndex;
  FDataItem := Controller.DataProvider[ARowIndex];
  FIndex := Controller.DataProvider.GetDataItemIndex(FDataItem);
end;

procedure TdxGanttControlSheetRowMovingObject.ApplyChanges(const P: TPoint);
var
  ANewIndex: Integer;
  ANewFocusedRowIndex: Integer;
begin
  ANewIndex := GetNewIndex(HitTest.HitObject as TdxGanttControlSheetRowHeaderViewInfo, P);
  ANewFocusedRowIndex := GetFocusedNewIndex(HitTest.HitObject as TdxGanttControlSheetRowHeaderViewInfo, P);
  with TdxGanttControlSheetMoveFocusedItemCommand.Create(Controller, ANewIndex, ANewFocusedRowIndex) do
  try
    Execute;
  finally
    Free;
  end;
  Controller.Options.DoRowEndDrag(FDataItem);
end;

function TdxGanttControlSheetRowMovingObject.CanDrop(const P: TPoint): Boolean;
var
  AViewInfo: TdxGanttControlSheetRowHeaderViewInfo;
  ANewIndex: Integer;
begin
  Result := False;
  if HitTest.HitObject is TdxGanttControlSheetRowHeaderViewInfo then
    AViewInfo := TdxGanttControlSheetRowHeaderViewInfo(HitTest.HitObject)
  else
    Exit;
  ANewIndex := GetNewIndex(AViewInfo, P);
  Result := (ANewIndex <> Index) and Controller.DataProvider.CanMove(Index, ANewIndex) and
    Controller.Options.DoRowDragAndDrop(FDataItem, ANewIndex);
end;

function TdxGanttControlSheetRowMovingObject.CreateDragImage: TcxDragImage;
var
  AViewInfo: TdxGanttControlSheetCustomViewInfo;
  AHeaderViewInfo: TdxGanttControlSheetHeaderViewInfo;
  ALeftArrow, ARightArrow: TRect;
  R: TRect;
begin
  AViewInfo := Controller.ViewInfo;
  Result := TcxDragImage.Create;
  AHeaderViewInfo := AViewInfo.Headers[0];
  ALeftArrow := TcxDragAndDropArrow.CalculateBounds(AHeaderViewInfo.Bounds, AHeaderViewInfo.Bounds, apLeft, AViewInfo.ScaleFactor, False);
  ARightArrow := TcxDragAndDropArrow.CalculateBounds(AHeaderViewInfo.Bounds, AHeaderViewInfo.Bounds, apRight, AViewInfo.ScaleFactor, False);
  Result.SetBounds(0, 0, ARightArrow.Right - ALeftArrow.Left,
    Max(ARightArrow.Height, ALeftArrow.Height));
  FLeftArrowLocation := cxPointOffset(ALeftArrow.Location, AViewInfo.Bounds.Location, False);
  Result.Canvas.Lock;
  try
    TcxCustomDragImageAccess(Result).TransparentColor := True;
    TcxCustomDragImageAccess(Result).TransparentColorValue := clWhite;
    Result.Canvas.FillRect(Result.ClientRect, clWhite);
    R := cxRectCenter(Result.BoundsRect, ALeftArrow.Size);
    R.MoveToLeft(Result.BoundsRect.Left);
    TcxDragAndDropArrow.Draw(Result.Canvas, R, apLeft, AViewInfo.ScaleFactor);
    R := cxRectCenter(Result.BoundsRect, ARightArrow.Size);
    R.MoveToRight(Result.BoundsRect.Right);
    TcxDragAndDropArrow.Draw(Result.Canvas, R, apRight, AViewInfo.ScaleFactor);
  finally
    Result.Canvas.Unlock;
  end;
end;

procedure TdxGanttControlSheetRowMovingObject.DragAndDrop(const P: TPoint;
  var Accepted: Boolean);
var
  APos: TPoint;
  AViewInfo: TdxGanttControlSheetRowHeaderViewInfo;
begin
  CheckScrolling(P);
  Accepted := CanDrop(P);
  if HitTest.HitObject is TdxGanttControlSheetRowHeaderViewInfo then
    AViewInfo := TdxGanttControlSheetRowHeaderViewInfo(HitTest.HitObject)
  else
    AViewInfo := nil;
  if Accepted and (AViewInfo <> nil) then
  begin
    APos.X := AViewInfo.Bounds.Left;
    if P.Y < (AViewInfo.Bounds.Top + AViewInfo.Bounds.Bottom) div 2 then
      APos.Y := AViewInfo.Bounds.Top
    else
      APos.Y := AViewInfo.Bounds.Bottom;
    ShowDragImage(cxPointOffset(APos, FLeftArrowLocation))
  end
  else
    HideDragImage;
  inherited DragAndDrop(P, Accepted)
end;

function TdxGanttControlSheetRowMovingObject.GetNewIndex(
  AHitViewInfo: TdxGanttControlSheetRowHeaderViewInfo;
  const P: TPoint): Integer;
var
  AHitDataItem: TObject;
begin
  AHitDataItem := AHitViewInfo.DataRow.Data;
  if AHitDataItem = FDataItem then
    Exit(Index);
  if AHitDataItem <> nil then
    Result := Controller.DataProvider.GetDataItemIndex(AHitViewInfo.DataRow.Data)
  else
    Result := AHitViewInfo.DataRow.Index + Controller.FirstVisibleRowIndex - Controller.DataProvider.Count + Controller.DataProvider.GetDataItemCount;
  if P.Y >= (AHitViewInfo.Bounds.Top + AHitViewInfo.Bounds.Bottom) div 2 then
  begin
    if (AHitDataItem <> nil) and not Controller.DataProvider.IsExpanded(AHitDataItem) then
    begin
      Result := Controller.DataProvider.IndexOf(AHitDataItem) + 1;
      if Result >= Controller.DataProvider.Count then
        Result := Controller.DataProvider.GetDataItemCount - 1
      else
      begin
        Result := Controller.DataProvider.GetDataItemIndex(Controller.DataProvider[Result]);
        if Result > Index then
          Dec(Result);
      end;
    end
    else
      if Result < Index then
        Inc(Result)
  end
  else
  begin
    if Result > Index then
      Dec(Result);
  end;
end;

function TdxGanttControlSheetRowMovingObject.GetFocusedNewIndex(AHitViewInfo: TdxGanttControlSheetRowHeaderViewInfo; const P: TPoint): Integer;
begin
  Result := AHitViewInfo.DataRow.Index + Controller.FirstVisibleRowIndex;
  if P.Y >= (AHitViewInfo.Bounds.Top + AHitViewInfo.Bounds.Bottom) div 2 then
  begin
    if Result < Index then
      Inc(Result)
  end
  else
    if Result > Index then
      Dec(Result);
end;

function TdxGanttControlSheetRowMovingObject.HorizontalScrollingSupports: Boolean;
begin
  Result := False;
end;

{ TdxGanttControlSheetDragHelper }

function TdxGanttControlSheetDragHelper.CalculateResizePoint(
  AViewInfo: TdxGanttControlSheetHeaderViewInfo; const P: TPoint): TPoint;
begin
  Result := P;
  Result.Y := Controller.ViewInfo.Bounds.Top;
  if AViewInfo.UseRightToLeftAlignment then
  begin
    Result.X := Min(Result.X, AViewInfo.Bounds.Right - AViewInfo.GetMinWidth);
    Result.X := Max(Result.X, Controller.ViewInfo.Bounds.Left);
  end
  else
  begin
    Result.X := Max(Result.X, AViewInfo.Bounds.Left + AViewInfo.GetMinWidth);
    Result.X := Min(Result.X, Controller.ViewInfo.Bounds.Right);
  end;
end;

function TdxGanttControlSheetDragHelper.CreateDragAndDropObject: TdxGanttControlDragAndDropObject;
begin
  Result := CreateDragAndDropObjectByPoint(FHitPoint);
end;

procedure TdxGanttControlSheetDragHelper.EndDragAndDrop(Accepted: Boolean);
begin
  FHitPoint := cxInvisiblePoint;
end;

function TdxGanttControlSheetDragHelper.StartDragAndDrop(
  const P: TPoint): Boolean;
var
  ADragDropObject: TdxGanttControlDragAndDropObject;
begin
  ADragDropObject := CreateDragAndDropObjectByPoint(P);
  try
    Result := ADragDropObject <> nil;
  finally
    ADragDropObject.Free;
  end;
  if Result then
    FHitPoint := P;
end;

function TdxGanttControlSheetDragHelper.CreateDragAndDropObjectByPoint(const P: TPoint): TdxGanttControlDragAndDropObject;
var
  I: Integer;
  AViewInfo: TdxGanttControlSheetHeaderViewInfo;
  ARowHeaderViewInfo: TdxGanttControlSheetRowHeaderViewInfo;
begin
  for I := 0 to Controller.ViewInfo.Headers.Count - 1 do
  begin
    AViewInfo := Controller.ViewInfo.Headers[I];
    if AViewInfo.IsSizingZone(P) then
    begin
      if Controller.ViewInfo.Headers[I] is TdxGanttControlSheetColumnHeaderViewInfo then
        Exit(CreateColumnResizingObject(TdxGanttControlSheetColumnHeaderViewInfo(AViewInfo)))
      else
        Exit(CreateRowHeaderWidthResizingObject(AViewInfo));
    end
    else
      if AViewInfo.IsMovingZone(P) then
      begin
        if Controller.ViewInfo.Headers[I] is TdxGanttControlSheetColumnHeaderViewInfo then
          Exit(CreateColumnMovingObject(TdxGanttControlSheetColumnHeaderViewInfo(AViewInfo)));
      end;
  end;
  AViewInfo := Controller.ViewInfo.Headers[0];
  if (P.X >= AViewInfo.Bounds.Left) and (P.X <= AViewInfo.Bounds.Right) then
    for I := 0 to Controller.ViewInfo.DataRows.Count - 1 do
    begin
      ARowHeaderViewInfo := Controller.ViewInfo.DataRows[I].HeaderViewInfo;
      if ARowHeaderViewInfo.IsMovingZone(P) and Controller.Options.CanRowDrag(ARowHeaderViewInfo.Data) then
        Exit(CreateRowMovingObject(ARowHeaderViewInfo));
    end;
  Result := nil;
end;

procedure TdxGanttControlSheetDragHelper.DoScroll;
var
  AIndex: Integer;
begin
  if ScrollDirection in [dirLeft, dirRight] then
  begin
    AIndex := Controller.FirstVisibleColumnIndex;
    if ScrollDirection = dirLeft then
      Dec(AIndex)
    else
      Inc(AIndex);
    Controller.FirstVisibleColumnIndex := AIndex;
  end
  else
  begin
    AIndex := Controller.FirstVisibleRowIndex;
    if ScrollDirection = dirUp then
      Dec(AIndex)
    else
      Inc(AIndex);
    Controller.FirstVisibleRowIndex := AIndex;
  end;
end;

function TdxGanttControlSheetDragHelper.GetController: TdxGanttControlSheetController;
begin
  Result := TdxGanttControlSheetController(inherited Controller);
end;

function TdxGanttControlSheetDragHelper.GetScrollableArea: TRect;
var
  AHeaderViewInfo: TdxGanttControlSheetHeaderViewInfo;
begin
  Result := Controller.ViewInfo.ClientRect;
  AHeaderViewInfo := Controller.ViewInfo.Headers[0];
  if DragAndDropObject is TdxGanttControlSheetColumnMovingObject then
  begin
    if Controller.ViewInfo.UseRightToLeftAlignment then
      Result.Right := AHeaderViewInfo.Bounds.Left
    else
      Result.Left := AHeaderViewInfo.Bounds.Right;
    Result.Top := AHeaderViewInfo.Bounds.Top;
    Result.Bottom := AHeaderViewInfo.Bounds.Bottom;
  end
  else if DragAndDropObject is TdxGanttControlSheetRowMovingObject then
  begin
    Result.Top := AHeaderViewInfo.Bounds.Bottom;
    Result.Left := AHeaderViewInfo.Bounds.Left;
    Result.Right := AHeaderViewInfo.Bounds.Right;
  end;
end;

function TdxGanttControlSheetDragHelper.CreateColumnMovingObject(AViewInfo: TdxGanttControlSheetColumnHeaderViewInfo): TdxGanttControlSheetColumnMovingObject;
begin
  Result := TdxGanttControlSheetColumnMovingObject.Create(Controller, AViewInfo.Column);
  AViewInfo.Invalidate;
end;

function TdxGanttControlSheetDragHelper.CreateColumnResizingObject(AViewInfo: TdxGanttControlSheetColumnHeaderViewInfo): TdxGanttControlSheetColumnResizingObject;
begin
  Result := TdxGanttControlSheetColumnResizingObject.Create(Controller, AViewInfo);
end;

function TdxGanttControlSheetDragHelper.CreateRowHeaderWidthResizingObject(AViewInfo: TdxGanttControlSheetHeaderViewInfo): TdxGanttControlSheetRowHeaderWidthResizingObject;
begin
  Result := TdxGanttControlSheetRowHeaderWidthResizingObject.Create(Controller, AViewInfo);
end;

function TdxGanttControlSheetDragHelper.CreateRowMovingObject(AViewInfo: TdxGanttControlSheetRowHeaderViewInfo): TdxGanttControlSheetRowMovingObject;
begin
  Result := TdxGanttControlSheetRowMovingObject.Create(Controller, Controller.FirstVisibleRowIndex + AViewInfo.DataRow.Index);
  AViewInfo.Invalidate;
end;

{ TdxGanttSheetScrollBars }

procedure TdxGanttSheetScrollBars.DoHScroll(ScrollCode: TScrollCode;
  var ScrollPos: Integer);
var
  APosition: Integer;
begin
  if ScrollCode = TScrollCode.scEndScroll then
    Exit;
  APosition := Controller.FirstVisibleColumnIndex;
  case ScrollCode of
    TScrollCode.scTrack:
      APosition := ScrollPos;
    TScrollCode.scLineUp:
      Dec(APosition);
    TScrollCode.scLineDown:
      Inc(APosition);
    TScrollCode.scPageUp:
      Dec(APosition, HScrollBar.PageSize);
    TScrollCode.scPageDown:
      Inc(APosition, HScrollBar.PageSize);
  end;
  APosition := Max(0, APosition);
  APosition := Min(HScrollBar.Max - HScrollBar.PageSize + 1, APosition);
  Controller.FirstVisibleColumnIndex := APosition;
  ScrollPos := Controller.FirstVisibleColumnIndex;
end;

function TdxGanttSheetScrollBars.GetController: TdxGanttControlSheetController;
begin
  Result := TdxGanttControlSheetController(inherited Controller);
end;

procedure TdxGanttSheetScrollBars.DoInitHScrollBarParameters;
var
  AMin, AMax, APageSize, APosition: Integer;
  AVisible: Boolean;
begin
  AVisible := (Controller.ViewInfo <> nil) and
    (Controller.ViewInfo.VisibleColumnCount < Controller.RealVisibleColumnCount);

  if AVisible then
  begin
    AMin := 0;
    AMax := Controller.RealVisibleColumnCount - 1;
    APageSize := Max(1, Controller.ViewInfo.VisibleColumnCount);
    APosition := Min(AMax - APageSize + 1, Controller.FirstVisibleColumnIndex);
    SetScrollInfo(sbHorizontal, AMin, AMax, 1, APageSize, APosition, True, True);
  end
  else
    Controller.ResetFirstVisibleColumnIndex;
  HScrollBar.Data.Visible := AVisible;
  HScrollBar.UnlimitedTracking := True;
end;

procedure TdxGanttSheetScrollBars.DoInitVScrollBarParameters;
var
  AMin, AMax, APageSize, APosition: Integer;
  AVisible: Boolean;
begin
  AVisible := (Controller.ViewInfo <> nil) and (Controller.ViewInfo.VisibleRowCount > 0);
  if AVisible then
  begin
    AMin := 0;
    AMax := Controller.ViewInfo.DataRows.Count + Controller.FirstVisibleRowIndex;
    AMax := Max(AMax, Controller.DataProvider.Count);
    APageSize := Max(1, Controller.ViewInfo.VisibleRowCount);
    APosition := Controller.FirstVisibleRowIndex;
    SetScrollInfo(sbVertical, AMin, AMax, 1, APageSize, APosition, True, True);
  end;
  VScrollBar.Data.Visible := AVisible;
  VScrollBar.UnlimitedTracking := True;
end;

procedure TdxGanttSheetScrollBars.DoVScroll(ScrollCode: TScrollCode;
  var ScrollPos: Integer);
var
  APosition: Integer;
begin
  APosition := Controller.FirstVisibleRowIndex;
  case ScrollCode of
    scTrack:
      APosition := ScrollPos;
    scPageUp:
      Dec(APosition, Controller.GetVisibleRowCount);
    scPageDown:
      Inc(APosition, Controller.GetVisibleRowCount);
    scLineUp, scLineDown:
      begin
        if ScrollCode = scLineUp then
          Dec(APosition)
        else
          Inc(APosition, 1);
      end;
  end;
  Controller.FirstVisibleRowIndex := Max(APosition, 0);
  ScrollPos := APosition;
end;

function TdxGanttSheetScrollBars.IsUnlimitedScrolling(AScrollKind: TScrollBarKind; ADeltaX, ADeltaY: Integer): Boolean;
begin
  Result := (AScrollKind = sbVertical) and (ADeltaY < 0);
end;

{ TdxGanttSheetQuickCustomizationControl }

procedure TdxGanttSheetQuickCustomizationControl.ShowAllClickHandler(Sender: TObject);
var
  ACursor: TCursor;
  I: Integer;
  AChecked: Boolean;
begin
  AChecked := CommandListBox.States[0] = cbsChecked;
  ACursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    Popup.Controller.Control.BeginUpdate;
    CheckListBox.BeginUpdate;
    try
      for I := 0 to CheckListBox.Count - 1 do
      begin
        CheckListBox.Checked[I] := AChecked;
        Popup.ChangeColumnVisible(I);
      end;
    finally
      CheckListBox.EndUpdate;
      Popup.Controller.Control.EndUpdate;
    end;
  finally
    Screen.Cursor := ACursor;
  end;
end;

procedure TdxGanttSheetQuickCustomizationControl.CheckShowAll;
begin
  if HasCommands then
    CommandListBox.States[0] := GetCheckingAllState;
end;

procedure TdxGanttSheetQuickCustomizationControl.CheckSortItems;
const
  AState: array[Boolean] of TcxCheckBoxState = (cbsUnchecked, cbsChecked);
begin
  if HasCommands then
    CommandListBox.States[1] := AState[Popup.Controller.Options.ColumnQuickCustomizationSorted];
end;

function TdxGanttSheetQuickCustomizationControl.GetCheckingAllState: TcxCheckBoxState;
const
  AState: array[Boolean] of TcxCheckBoxState = (cbsUnchecked, cbsChecked);
var
  I, ACount: Integer;
begin
  Result := cbsUnchecked;
  ACount := 0;
  for I := 0 to CheckListBox.Count - 1 do
  begin
    if CheckListBox.Checked[I] then
      Inc(ACount);
    if (ACount > 0) and (ACount < I + 1) then
    begin
      Result := cbsGrayed;
      Break;
    end;
  end;
  if Result <> cbsGrayed then
    Result := AState[ACount = CheckListBox.Count];
end;

function TdxGanttSheetQuickCustomizationControl.GetPopup: TdxGanttSheetColumnQuickCustomizationPopup;
begin
  Result := TdxGanttSheetColumnQuickCustomizationPopup(Owner);
end;

procedure TdxGanttSheetQuickCustomizationControl.KeyDown(var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Popup.CloseUp;
  end;
end;

procedure TdxGanttSheetQuickCustomizationControl.PopulateCheckListBox;
var
  I: Integer;
  AColumn: TdxGanttControlSheetColumn;
begin
  CheckListBox.Items.BeginUpdate;
  try
    CheckListBox.Items.Clear;
    CheckListBox.Sorted := False;
    for I := 0 to Popup.Controller.Options.Columns.Count - 1 do
    begin
      AColumn := Popup.Controller.Options.Columns[I];
      if AColumn.Visible or AColumn.RealAllowInsert then
        CheckListBox.Items.AddObject(AColumn.Caption, AColumn).Checked := AColumn.Visible;
    end;
    CheckListBox.Sorted := Popup.Controller.Options.ColumnQuickCustomizationSorted;
    CheckListBox.ItemMoving := not CheckListBox.Sorted;
  finally
    CheckListBox.Items.EndUpdate;
  end;
end;

procedure TdxGanttSheetQuickCustomizationControl.PopulateCommandListBox;
begin
  AddCommand(cxGetResourceString(@scxQuickCustomizationAllCommandCaption), True, ShowAllClickHandler);
  AddCommand(cxGetResourceString(@scxQuickCustomizationSortedCommandCaption), True, SortItemsClickHandler);
  CheckSortItems;
  CheckShowAll;
end;

procedure TdxGanttSheetQuickCustomizationControl.SortItemsClickHandler(Sender: TObject);
begin
  Popup.Controller.Options.ColumnQuickCustomizationSorted := not Popup.Controller.Options.ColumnQuickCustomizationSorted;
  PopulateCheckListBox;
end;

{ TdxGanttSheetColumnQuickCustomizationPopup }

constructor TdxGanttSheetColumnQuickCustomizationPopup.Create(
  AController: TdxGanttControlSheetController);
begin
  inherited Create(AController.Control);
  FController := AController;
  Owner := AController;
  OwnerParent := AController.Control;
  FCustomizationControl := TdxGanttSheetQuickCustomizationControl.Create(Self);
  CustomizationControl.Style.BorderStyle := cbsNone;
  CustomizationControl.Style.Edges := [];
  CustomizationControl.Style.HotTrack := False;
  CustomizationControl.Style.TransparentBorder := False;
  CustomizationControl.Style.LookAndFeel.MasterLookAndFeel := Controller.Control.LookAndFeel;
  CustomizationControl.CheckListBox.OnAction := CheckListBoxActionHandler;
  CustomizationControl.CheckListBox.OnDragDrop := CheckListBoxDragDropHandler;
  CustomizationControl.CheckListBox.OnItemDragOver := CheckListBoxItemDragOverHandler;
  CustomizationControl.CheckListBox.OnSelectedItemCheckedStateChanged := CheckListSelectedItemCheckedStateChangedHandler;
end;

destructor TdxGanttSheetColumnQuickCustomizationPopup.Destroy;
begin
  FreeAndNil(FCustomizationControl);
  inherited;
end;

procedure TdxGanttSheetColumnQuickCustomizationPopup.ChangeColumnVisible(
  AItemIndex: Integer);
var
  ACommand: TdxGanttControlSheetCommand;
  AColumn: TdxGanttControlSheetColumn;
  AValue: Boolean;
  AItem: TdxCustomCheckListBoxItem;
begin
  AItem := CustomizationControl.CheckListBox.Items[AItemIndex];
  AColumn := TdxGanttControlSheetColumn(AItem.Data);
  AValue := AItem.Checked;
  if AValue then
    ACommand := TdxGanttControlSheetShowColumnCommand.Create(Controller, AColumn.Index)
  else
    ACommand := TdxGanttControlSheetHideColumnCommand.Create(Controller, AColumn.Index);
  try
    ACommand.Execute;
  finally
    ACommand.Free;
  end;
  AItem.Checked := AColumn.Visible;
  CustomizationControl.CheckShowAll;
end;

procedure TdxGanttSheetColumnQuickCustomizationPopup.CheckListBoxActionHandler(
  Sender: TdxCustomListBox; AItemIndex: Integer);
begin
  ChangeColumnVisible(AItemIndex);
end;

procedure TdxGanttSheetColumnQuickCustomizationPopup.CheckListBoxDragDropHandler(
  Sender, Source: TObject; X, Y: Integer);

  procedure MoveItems(AItems: TList; AIndex: Integer);
  var
    I: Integer;
  begin
    Controller.Control.BeginUpdate;
    try
      for I := 0 to AItems.Count - 1 do
      begin
        if TdxGanttControlSheetColumn(AItems[I]).Index < AIndex then
          Dec(AIndex);
        with TdxGanttControlSheetMoveColumnCommand.Create(Controller, TdxGanttControlSheetColumn(AItems[I]).Index, AIndex) do
        try
          Execute;
        finally
          Free;
        end;
        CustomizationControl.CheckListBox.Items.Move(CustomizationControl.CheckListBox.Items.IndexOfObject(AItems[I]), AIndex);
        CustomizationControl.CheckListBox.Selected[AIndex] := True;
        CustomizationControl.CheckListBox.ItemIndex := AIndex;
        Inc(AIndex);
      end;
    finally
      Controller.Control.EndUpdate;
    end;
  end;

var
  AIndex: Integer;
  AItems: TList;
begin
  AIndex := TdxCustomCheckListBoxAccess(CustomizationControl.CheckListBox).GetDragItemInsertionIndex(X, Y);
  if AIndex = -1 then Exit;
  if AIndex = CustomizationControl.CheckListBox.Count then
    AIndex := AIndex - 1;

  AItems := TdxCustomCheckListBoxAccess(CustomizationControl.CheckListBox).GetSelectedItems(True);
  CustomizationControl.CheckListBox.BeginUpdate;
  try
    TdxCustomCheckListBoxAccess(CustomizationControl.CheckListBox).Selection.Clear;
    MoveItems(AItems, AIndex);
  finally
    CustomizationControl.CheckListBox.EndUpdate;
    AItems.Free;
  end;
end;

procedure TdxGanttSheetColumnQuickCustomizationPopup.CheckListBoxItemDragOverHandler(
  AItem: Pointer; var AAccept: Boolean);
begin
  AAccept := not Controller.Options.ColumnQuickCustomizationSorted;
  if AAccept and (AItem <> nil) then
    AAccept := TdxGanttControlSheetColumn(AItem).RealAllowMove;
end;

procedure TdxGanttSheetColumnQuickCustomizationPopup.CheckListSelectedItemCheckedStateChangedHandler(
  Sender: TObject);
var
  I: Integer;
begin
  CustomizationControl.CheckListBox.BeginUpdate;
  try
    for I := 0 to CustomizationControl.CheckListBox.Items.Count - 1 do
      if CustomizationControl.CheckListBox.Selected[I] then
        ChangeColumnVisible(I);
  finally
    CustomizationControl.CheckListBox.EndUpdate;
  end;
  CustomizationControl.CheckShowAll;
end;

procedure TdxGanttSheetColumnQuickCustomizationPopup.CloseUp;
begin
  inherited CloseUp;
  CustomizationControl.Clear;
end;

procedure TdxGanttSheetColumnQuickCustomizationPopup.CorrectBoundsWithDesktopWorkArea(
  var APosition: TPoint; var ASize: TSize);
var
  ADesktopSpace, AMaxRowCount, AColumnCount: Integer;
  R: TRect;
begin
  R := Controller.Control.ClientRect;
  R.Location := Controller.Control.ClientToScreen(TPoint.Null);
  R.Top := GetOwnerScreenBounds.Bottom;
  R.Intersect(GetDesktopWorkArea(OwnerScreenBounds));

  ADesktopSpace := 0;
  if (APosition.Y < R.Top) or
    ((APosition.Y < R.Bottom) and (APosition.Y + ASize.cy > R.Top)) or
     (APosition.Y + ASize.cy > R.Bottom) then
    ADesktopSpace := Abs(R.Bottom - APosition.Y);

  if ADesktopSpace <> 0 then
  begin
    AMaxRowCount := (ADesktopSpace - CustomizationControl.CheckListBox.Top) div CustomizationControl.CheckListBox.ItemHeight - 1;
    AColumnCount := CustomizationControl.CheckListBox.Count div AMaxRowCount +
      Integer(CustomizationControl.CheckListBox.Count mod AMaxRowCount <> 0);
    CustomizationControl.CheckListBoxVisibleRowCount := Min(AMaxRowCount, CustomizationControl.CheckListBox.Count div AColumnCount + 1);
    repeat
      RestoreControlsBounds;
      CustomizationControl.CheckListBox.Columns := AColumnCount;
      CustomizationControl.AdjustBounds(True);
      ASize := CalculateSize;
      AlignVert := pavBottom;
      APosition := CalculatePosition(ASize);
      Dec(AColumnCount);
    until (APosition.X + ASize.cx <= R.Right) or (APosition.X - ASize.cx >= R.Left);
  end;
end;

procedure TdxGanttSheetColumnQuickCustomizationPopup.InitPopup;
begin
  inherited InitPopup;
  CustomizationControl.Canvas.Font := Font;
  CustomizationControl.CheckListBox.Columns := 0;
  AlignHorz := GetDefaultAlignHorz;
  AlignVert := pavBottom;
  Direction := pdVertical;
  CustomizationControl.Initialize(Self);
end;

procedure TdxGanttSheetColumnQuickCustomizationPopup.Paint;
begin
  DrawFrame;
  Canvas.Brush.Color := Color;
  Canvas.FillRect(ClientBounds);
end;

{ TdxGanttControlSheetController }

constructor TdxGanttControlSheetController.Create(
  AControl: TdxGanttControlBase; AOptions: TdxGanttControlSheetOptions);
begin
  inherited Create(AControl);
  FOptions := AOptions;
  FEditingController := CreateEditingController;
  FScrollBars := CreateScrollBars;
  FColumnRenameEdit := CreateColumnRenameEdit;
  FColumnInsertEditIndex := -1;
  FColumnInsertEdit := CreateColumnInsertEdit;
end;

destructor TdxGanttControlSheetController.Destroy;
begin
  FreeAndNil(FColumnInsertEdit);
  FreeAndNil(FColumnRenameEdit);
  FreeAndNil(FColumnQuickCustomizationPopup);
  FreeAndNil(FEditingController);
  FreeAndNil(FScrollBars);
  inherited Destroy;
end;

function TdxGanttControlSheetController.CreateChangeCellValueCommand(
  const AValue: Variant): TdxGanttControlSheetChangeCellValueCommand;
begin
  Result := TdxGanttControlSheetChangeCellValueCommand.Create(Self, AValue);
end;

procedure TdxGanttControlSheetController.CalculateBestFit(
  AColumn: TdxGanttControlSheetColumn);
var
  AResult: Integer;
  I: Integer;
  ARow: TdxGanttControlSheetDataRowViewInfo;
  ACell: TdxGanttControlSheetCellCustomViewInfo;
  AColumnHeaderViewInfo: TdxGanttControlSheetColumnHeaderViewInfo;
begin
  AColumnHeaderViewInfo := AColumn.CreateViewInfo(ViewInfo);
  try
    AColumnHeaderViewInfo.CalculateLayout;
    AColumnHeaderViewInfo.Calculate(TRect.Create(0, 0, MaxInt, MaxInt));
    AResult := AColumnHeaderViewInfo.CalculateBestFit;
    for I := 0 to DataProvider.Count - 1 do
    begin
      ARow := TdxGanttControlSheetDataRowViewInfo.Create(ViewInfo, I, DataProvider[I]);
      try
        ACell := AColumn.GetDataCellViewInfoClass.Create(ARow, AColumnHeaderViewInfo, AColumn);
        try
          ACell.CalculateLayout;
          ACell.Calculate(TRect.Create(0, 0, MaxInt, MaxInt));
          AResult := Max(AResult, ACell.CalculateBestFit);
        finally
          ACell.Free;
        end;
      finally
        ARow.Free;
      end;
    end;
    AResult := ScaleFactor.Revert(AResult);
    AResult := Max(TdxGanttControlSheetColumn.MinWidth + ViewInfo.TextPadding.Width, AResult);
    with TdxGanttControlSheetResizeColumnCommand.Create(Self, AColumn, AResult) do
    try
      Execute;
    finally
      Free;
    end;
  finally
    AColumnHeaderViewInfo.Free;
  end;
end;

function TdxGanttControlSheetController.CanAutoScroll(ADirection: TcxDirection): Boolean;
begin
  case ADirection of
    dirLeft: Result := FirstVisibleColumnIndex > 0;
    dirRight: Result := FirstVisibleColumnIndex + ViewInfo.VisibleColumnCount < RealVisibleColumnCount;
    dirUp: Result := FirstVisibleRowIndex > 0;
    dirDown: Result := True;
  else
    Result := False;
  end;
end;

function TdxGanttControlSheetController.CreateDragHelper: TdxGanttControlDragHelper;
begin
  Result := TdxGanttControlSheetDragHelper.Create(Self);
end;

function TdxGanttControlSheetController.GetGestureClient(const APoint: TPoint): IdxGestureClient;
begin
  Result := FScrollBars;
end;

function TdxGanttControlSheetController.HasItemExpandState(
  AItem: TObject): Boolean;
begin
  Result := False;
end;

procedure TdxGanttControlSheetController.HideEditing;
begin
  inherited HideEditing;
  EditingController.HideEdit(False);
end;

procedure TdxGanttControlSheetController.ColumnRenameEditExitHandler(Sender: TObject);
begin
  HideColumnRenameEdit(True, False);
end;

procedure TdxGanttControlSheetController.ColumnRenameEditKeyDownHandler(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    HideColumnRenameEdit(True, True);
  if (Key = VK_ESCAPE) and not FColumnRenameEdit.ModifiedAfterEnter then
    HideColumnRenameEdit(False, True);
end;

procedure TdxGanttControlSheetController.HideColumnRenameEdit(Accept, ASetControlFocus: Boolean);
var
  AColumn: TdxGanttControlSheetColumn;
begin
  if FColumnRenameEdit.Tag = -1 then
    Exit;
  if Accept then
  begin
    AColumn := Options.Columns[FColumnRenameEdit.Tag];
    with TdxGanttControlSheetRenameColumnCommand.Create(Self, AColumn, VarToStr(FColumnRenameEdit.EditingValue)) do
    try
      Execute;
    finally
      Free;
    end;
  end;
  FColumnRenameEdit.Tag := -1;
  FColumnRenameEdit.Visible := False;
  FColumnRenameEdit.Parent := nil;
  if ASetControlFocus then
    Control.SetFocus;
end;

procedure TdxGanttControlSheetController.ColumnInsertEditExitHandler(Sender: TObject);
begin
  HideColumnInsertEdit(True, False);
end;

procedure TdxGanttControlSheetController.ColumnInsertEditKeyDownHandler(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    HideColumnInsertEdit(True, True);
  if (Key = VK_ESCAPE) and not FColumnInsertEdit.ModifiedAfterEnter then
    HideColumnInsertEdit(False, True);
end;

procedure TdxGanttControlSheetController.ColumnInsertEditValueChanged(Sender: TObject);
begin
  HideColumnInsertEdit(True, True);
end;

procedure TdxGanttControlSheetController.HideColumnInsertEdit(Accept, ASetControlFocus: Boolean);
var
  AColumn: TdxGanttControlSheetColumn;
  AIndex: Integer;
begin
  if FColumnInsertEditIndex = -1 then
    Exit;
  if (FColumnInsertEditIndex > 0) and (Options.Columns.VisibleCount >= FColumnInsertEditIndex) then
    AIndex := Options.Columns.VisibleItems[FColumnInsertEditIndex - 1].Index
  else
    AIndex := 0;
  FColumnInsertEditIndex := -1;
  if Accept and (FColumnInsertEdit.ItemIndex <> -1) then
  begin
    Control.BeginUpdate;
    try
      AColumn := TdxGanttControlSheetColumn(FColumnInsertEdit.Properties.Items.Objects[FColumnInsertEdit.ItemIndex]);
      with TdxGanttControlSheetShowColumnCommand.Create(Self, AColumn.Index) do
      try
        Execute;
      finally
        Free;
      end;
      if AIndex < AColumn.Index then
        Inc(AIndex);
      with TdxGanttControlSheetMoveColumnCommand.Create(Self, AColumn.Index, AIndex) do
      try
        Execute;
      finally
        Free;
      end;
    finally
      Control.EndUpdate;
    end;
  end
  else
    Changed;
  FColumnInsertEdit.Visible := False;
  FColumnInsertEdit.Parent := nil;
  if ASetControlFocus then
    Control.SetFocus;
end;

function TdxGanttControlSheetController.CreateColumnRenameEdit: TcxCustomTextEdit;
var
  AEdit: TcxCustomTextEdit;
begin
  AEdit := TcxCustomTextEdit.Create(nil, True);
  AEdit.Style.LookAndFeel.MasterLookAndFeel := Control.LookAndFeel;
  AEdit.OnExit := ColumnRenameEditExitHandler;
  AEdit.OnKeyDown := ColumnRenameEditKeyDownHandler;
  Result := AEdit;
end;

function TdxGanttControlSheetController.CanShowColumnHint(AColumn: TdxGanttControlSheetColumn): Boolean;
begin
  Result := FColumnRenameEdit.Tag <> AColumn.Index;
end;

procedure TdxGanttControlSheetController.MakeColumnVisible(AColumn: TdxGanttControlSheetColumn);
var
  AVisibleIndex: Integer;
begin
  AVisibleIndex := Options.Columns.GetVisibleIndex(AColumn);
  MakeColumnVisible(AVisibleIndex);
end;

procedure TdxGanttControlSheetController.MakeColumnVisible(AColumnIndex: Integer);
begin
  MakeCellVisible(TPoint.Create(AColumnIndex, FirstVisibleRowIndex));
end;

procedure TdxGanttControlSheetController.ShowColumnRenameEdit(
  AColumn: TdxGanttControlSheetColumn);

  function GetColumnViewInfo: TdxGanttControlSheetColumnHeaderViewInfo;
  var
    AResult: TdxGanttControlSheetColumnHeaderViewInfo;
    I: Integer;
  begin
    Result := nil;
    if ViewInfo = nil then
      Exit;
    for I := 0 to ViewInfo.Headers.Count - 1 do
    begin
      if ViewInfo.Headers[I] is TdxGanttControlSheetColumnHeaderViewInfo then
      begin
        AResult := TdxGanttControlSheetColumnHeaderViewInfo(ViewInfo.Headers[I]);
        if AResult.Column = AColumn then
          Exit(AResult);
      end;
    end;
  end;

var
  AColumnViewInfo: TdxGanttControlSheetColumnHeaderViewInfo;
begin
  EditingController.HideEdit(True);
  if not AColumn.Visible then
    Exit;
  MakeColumnVisible(AColumn);
  AColumnViewInfo := GetColumnViewInfo;
  if AColumnViewInfo = nil then
    Exit;
  FColumnRenameEdit.EditValue := AColumn.Caption;
  FColumnRenameEdit.Tag := AColumn.Index;
  ShowColumnEdit(FColumnRenameEdit, AColumnViewInfo);
  FColumnRenameEdit.SelectAll;
end;

function TdxGanttControlSheetController.CreateColumnInsertEdit: TcxCustomComboBox;
begin
  Result := TcxCustomComboBox.Create(nil, True);
  Result.Properties.ImmediateDropDownWhenActivated := True;
  Result.Properties.ImmediateDropDown := True;
  Result.Properties.ImmediatePost := True;
  Result.Style.LookAndFeel.MasterLookAndFeel := Control.LookAndFeel;
  Result.OnExit := ColumnInsertEditExitHandler;
  Result.OnKeyDown := ColumnInsertEditKeyDownHandler;
  Result.Properties.OnEditValueChanged := ColumnInsertEditValueChanged;
end;

procedure TdxGanttControlSheetController.ShowChooseColumnDetailsDialog;
begin
  ShowGanttControlSheetChooseDetailsDialog(Options);
end;

procedure TdxGanttControlSheetController.ShowColumnEdit(AEdit: TcxCustomEdit;
  AColumnViewInfo: TdxGanttControlSheetColumnHeaderViewInfo);
var
  R: TRect;
begin
  R := GetColumnEditBounds(AColumnViewInfo);
  AEdit.BiDiMode := Control.BiDiMode;
  AEdit.Parent := Control;
  AEdit.BoundsRect := R;
  AEdit.Visible := True;
  AEdit.SetFocus;
end;

procedure TdxGanttControlSheetController.ShowColumnInsertEdit(AColumn: TdxGanttControlSheetColumn);

  procedure PopulateItems;
  var
    I: Integer;
  begin
    FColumnInsertEdit.Properties.Items.BeginUpdate;
    try
      FColumnInsertEdit.Properties.Items.Clear;
      for I := 0 to Options.Columns.Count - 1 do
      begin
        if not Options.Columns[I].Visible and Options.Columns[I].RealAllowInsert then
          FColumnInsertEdit.Properties.Items.AddObject(Options.Columns[I].Caption, Options.Columns[I]);
      end;
    finally
      FColumnInsertEdit.Properties.Items.EndUpdate();
    end;
  end;

  function GetColumnViewInfo: TdxGanttControlSheetColumnHeaderViewInfo;
  var
    I: Integer;
  begin
    Result := nil;
    if ViewInfo = nil then
      Exit;
    for I := 0 to ViewInfo.Headers.Count - 1 do
    begin
      if ViewInfo.Headers[I] is TdxGanttControlSheetColumnInsertHeaderViewInfo then
        Exit(TdxGanttControlSheetColumnInsertHeaderViewInfo(ViewInfo.Headers[I]));
    end;
  end;

  function CalculateDropDownRows: Integer;
  var
    AHeight: Integer;
  begin
    AHeight := ViewInfo.ClientRect.Height - ViewInfo.Headers[0].Bounds.Height;
    Result := AHeight div (cxTextHeight(FColumnInsertEdit.Style.Font));
  end;

var
  AColumnViewInfo: TdxGanttControlSheetColumnHeaderViewInfo;
  AFirstVisibleColumnIndex: Integer;
begin
  EditingController.HideEdit(True);
  if ViewInfo = nil then
    Exit;
  if (AColumn = nil) and (Options.Columns.VisibleCount > 0) then
    AColumn := Options.Columns.VisibleItems[Options.Columns.VisibleCount - 1];
  FColumnInsertEdit.ItemIndex := -1;
  FColumnInsertEditIndex := Options.Columns.GetVisibleIndex(AColumn) + 1;
  ViewInfo.Recalculate;
  AFirstVisibleColumnIndex := FirstVisibleColumnIndex;
  MakeColumnVisible(FColumnInsertEditIndex);
  if AFirstVisibleColumnIndex <> FirstVisibleColumnIndex then
    ViewInfo.Recalculate;
  AColumnViewInfo := GetColumnViewInfo;
  if AColumnViewInfo = nil then
    FColumnInsertEditIndex := -1
  else
  begin
    FColumnInsertEdit.ItemIndex := -1;
    PopulateItems;
    FColumnInsertEdit.Properties.DropDownRows := CalculateDropDownRows;
    ShowColumnEdit(FColumnInsertEdit, AColumnViewInfo);
    FColumnInsertEdit.DroppedDown := True;
  end;
  Changed;
end;

procedure TdxGanttControlSheetController.ResetFirstVisibleColumnIndex;
begin
  FFirstVisibleColumnIndex := 0;
end;

function TdxGanttControlSheetController.CreateEditingController: TdxGanttControlSheetEditingController;
begin
  Result := TdxGanttControlSheetEditingController.Create(Self);
end;

function TdxGanttControlSheetController.CreateScrollBars: TdxGanttSheetScrollBars;
begin
  Result := TdxGanttSheetScrollBars.Create(Self);
end;

function TdxGanttControlSheetController.IsActive: Boolean;
begin
  Result := ViewInfo <> nil;
end;

function TdxGanttControlSheetController.IsEditing: Boolean;
begin
  Result := EditingController.IsEditing;
end;

procedure TdxGanttControlSheetController.DoClick;
begin
  inherited DoClick;
end;

procedure TdxGanttControlSheetController.DoMouseDown(
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

  function IsColumnSizingZone: Boolean;
  var
    I: Integer;
    P: TPoint;
  begin
    P := TPoint.Create(X, Y);
    for I := 0 to ViewInfo.Headers.Count - 1 do
    begin
      if (ViewInfo.Headers[I] is TdxGanttControlSheetColumnHeaderViewInfo) and (TdxGanttControlSheetColumnHeaderViewInfo(ViewInfo.Headers[I]).IsSizingZone(P)) then
        Exit(True);
    end;
    Result := False;
  end;

var
  ARowHeaderViewInfo: TdxGanttControlSheetRowHeaderViewInfo;
  AColumnHeaderViewInfo: TdxGanttControlSheetColumnHeaderViewInfo;
  AIsCellFocused: Boolean;
begin
  inherited DoMouseDown(Button, Shift, X, Y);
  if Button = mbMiddle then
    ScrollBars.ProcessControlScrollingOnMiddleButton;
  if HitTest.HitObject is TdxGanttControlSheetCellViewInfo then
  begin
    if not EditingController.IsErrorOnPost then
    begin
      AIsCellFocused := TdxGanttControlSheetCellViewInfo(HitTest.HitObject).IsFocused;
      SetFocusedCell(TdxGanttControlSheetCellViewInfo(HitTest.HitObject));
      if (AIsCellFocused or Options.RealAlwaysShowEditor or Options.Columns.VisibleItems[FocusedColumnIndex].ShowEditorImmediately) and
         (Button = mbLeft) and not (ssDouble in Shift) and not DragHelper.IsDragging then
        EditingController.ShowEditByMouse;
    end;
  end;
  if (HitTest.HitObject is TdxGanttControlSheetColumnHeaderViewInfo) and not (ssDouble in Shift) then
  begin
    AColumnHeaderViewInfo := TdxGanttControlSheetColumnHeaderViewInfo(HitTest.HitObject);
    if not IsColumnSizingZone then
    begin
      FCaptureColumn := AColumnHeaderViewInfo.Column;
      FocusedCell := TPoint.Create(AColumnHeaderViewInfo.Column.VisibleIndex, FocusedRowIndex);
    end;
  end;
  if HitTest.HitObject is TdxGanttControlSheetRowHeaderViewInfo then
  begin
    ARowHeaderViewInfo := TdxGanttControlSheetRowHeaderViewInfo(HitTest.HitObject);
    FocusedCell := TPoint.Create(-1, ARowHeaderViewInfo.DataRow.Index + FirstVisibleRowIndex);
  end;
  if HitTest.HitObject is TdxGanttControlSheetColumnQuickCustomizationButtonViewInfo then
    ShowColumnQuickCustomizationPopup;
end;

procedure TdxGanttControlSheetController.DoMouseUp(
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited DoMouseUp(Button, Shift, X, Y);
  if (HitTest.HitObject is TdxGanttControlCustomItemViewInfo) and
      TdxGanttControlCustomItemViewInfoAccess(HitTest.HitObject).HasPressedState then
    TdxGanttControlCustomItemViewInfoAccess(HitTest.HitObject).MouseEnter;
  FCaptureColumn := nil;
end;

function TdxGanttControlSheetController.DoMouseWheel(Shift: TShiftState; AIsIncrement: Boolean; const AMousePos: TPoint): Boolean;
begin
  HideColumnRenameEdit(False, False);
  HideColumnInsertEdit(False, False);
  Result := ScrollBars.DoMouseWheel(Shift, AIsIncrement);
end;

procedure TdxGanttControlSheetController.DoKeyDown(var Key: Word; Shift: TShiftState);
var
  AFocusedCell: TPoint;
begin
  inherited DoKeyDown(Key, Shift);
  if Key = 0 then
    Exit;
  AFocusedCell := FocusedCell;
  case Key of
    VK_LEFT, VK_RIGHT:
      begin
        if Shift = [] then
          FocusedColumnIndex := Max(0, FocusedCell.X + IfThen((Key = VK_RIGHT) xor ViewInfo.UseRightToLeftAlignment, 1, -1))
        else if Shift = [ssCtrl] then
          FocusedColumnIndex := IfThen((Key = VK_RIGHT) xor ViewInfo.UseRightToLeftAlignment, MaxInt, 0);
      end;
    VK_HOME:
      begin
        if [ssCtrl] * Shift = [ssCtrl] then
          FocusedRowIndex := 0;
        FocusedColumnIndex := 0;
      end;
    VK_END:
      begin
        if [ssCtrl] * Shift = [ssCtrl] then
          FocusedRowIndex := Max(0, DataProvider.Count - 1);
        FocusedColumnIndex := MaxInt;
      end;
    VK_UP, VK_DOWN:
      begin
        if Shift = [] then
          FocusedRowIndex := Max(0, FocusedCell.Y + IfThen(Key = VK_DOWN, 1, -1))
        else if Shift = [ssCtrl] then
          FocusedRowIndex := IfThen(Key = VK_DOWN, DataProvider.Count  - 1, 0);
      end;
    VK_RETURN:
      FocusedRowIndex := Max(0, FocusedCell.Y + IfThen(not (ssShift in Shift), 1, -1));
    VK_PRIOR, VK_NEXT:
      FocusedRowIndex := Max(0, FocusedCell.Y + IfThen(Key = VK_NEXT, 1, -1) * (GetVisibleRowCount - 1));
    VK_F2:
      if not EditingController.IsEditing then
        EditingController.ShowEdit;
    VK_F4:
      if not EditingController.IsEditing and (FocusedCellViewInfo <> nil) and (FocusedCellViewInfo is TdxGanttControlSheetCellViewInfo) and
          (TdxGanttControlSheetCellViewInfo(FocusedCellViewInfo).Column.Properties is TcxCustomDropDownEditProperties) then
        EditingController.ShowEdit;
    VK_ADD, VK_OEM_PLUS:
      if [ssAlt, ssShift] * Shift = [ssAlt, ssShift] then
        ExpandItem;
    VK_SUBTRACT, VK_OEM_MINUS:
      if [ssAlt, ssShift] * Shift = [ssAlt, ssShift] then
        CollapseItem;
    VK_DELETE:
      if not IsEditing then
      begin
        MakeFocusedCellVisible;
        if (Shift = []) and (FocusedColumnIndex >= 0) then
          EditingController.SetValue(Null)
        else
          if (Shift = [ssCtrl]) or (FocusedColumnIndex = -1) then
            DeleteFocusedItem;
      end;
    VK_INSERT:
      InsertNewDataItem;
  end;
  if Options.RealAlwaysShowEditor and not AFocusedCell.IsEqual(FocusedCell) then
    EditingController.ShowEdit;
end;

procedure TdxGanttControlSheetController.DoKeyPress(var Key: Char);
begin
  inherited DoKeyPress(Key);
  if not EditingController.IsEditing and (Ord(Key) >= 32) then
    EditingController.ShowEditByKey(Key);
end;

function TdxGanttControlSheetController.CalculateFirstVisibleColumnIndex(AVisibleColumnIndex: Integer): Integer;

  function GetWidth(AVisibleIndex: Integer): Integer;
  begin
    if FColumnInsertEditIndex >= 0 then
    begin
      if FColumnInsertEditIndex = AVisibleIndex then
        Result := ViewInfo.ScaleFactor.Apply(TdxGanttControlSheetColumn.DefaultWidth)
      else if FColumnInsertEditIndex < AVisibleIndex then
        Result := ViewInfo.ScaleFactor.Apply(FOptions.Columns.VisibleItems[AVisibleIndex - 1].Width)
      else
        Result := ViewInfo.ScaleFactor.Apply(FOptions.Columns.VisibleItems[AVisibleIndex].Width);
    end
    else
      Result := ViewInfo.ScaleFactor.Apply(FOptions.Columns.VisibleItems[AVisibleIndex].Width);
  end;

var
  ACount: Integer;
  AWidth: Integer;
  AMaxWidth: Integer;
begin
  Result := FirstVisibleColumnIndex;
  if ViewInfo = nil then
    Exit;
  ACount := ViewInfo.VisibleColumnCount;
  if AVisibleColumnIndex < Result then
    Result := Max(0, AVisibleColumnIndex)
  else if AVisibleColumnIndex >= Result + ACount  then
  begin
    Result := Min(RealVisibleColumnCount - 1, AVisibleColumnIndex);
    AMaxWidth := ViewInfo.ClientRect.Width - ViewInfo.Headers[0].Bounds.Width;
    AWidth := GetWidth(Result);
    while Result > 0 do
    begin
      AWidth := AWidth + GetWidth(Result - 1);
      if AWidth < AMaxWidth then
        Dec(Result)
      else
        Break;
    end;
  end;
end;

function TdxGanttControlSheetController.CalculateFirstVisibleRowIndex(
  AVisibleRowIndex: Integer): Integer;

  function GetRowHeight(AIndex: Integer): Integer;
  var
    AViewInfo: TdxGanttControlSheetDataRowViewInfo;
    ADataItem: TObject;
  begin
    if AIndex >= DataProvider.Count - 1 then
      ADataItem := nil
    else
      ADataItem := DataProvider.Items[AIndex];
    AViewInfo := TdxGanttControlSheetDataRowViewInfo.Create(ViewInfo, -1, ADataItem);
    try
      Result := AViewInfo.MeasureHeight;
    finally
      AViewInfo.Free;
    end;
  end;

var
  ACount: Integer;
  AMaxHeight, AHeight: Integer;
begin
  Result := FirstVisibleRowIndex;
  if ViewInfo = nil then
    Exit;
  ACount := ViewInfo.DataRows.Count;
  if not ViewInfo.DataRows.Last.IsFullyVisible then
    Dec(ACount);
  if AVisibleRowIndex < Result then
    Result := Max(0, AVisibleRowIndex)
  else if AVisibleRowIndex >= Result + ACount then
  begin
    Result := AVisibleRowIndex;
    if Result = 0 then
      Exit;
    AMaxHeight := ViewInfo.ClientRect.Height - ViewInfo.Headers[0].Bounds.Height;
    AHeight := GetRowHeight(Result);
    repeat
      AHeight := AHeight + GetRowHeight(Result - 1);
      if AHeight < AMaxHeight then
        Dec(Result)
      else
        Break;
    until Result <= 0;
  end;
end;

procedure TdxGanttControlSheetController.MakeCellVisible(const P: TPoint);
var
  AFirstVisibleColumnIndex, AFirstVisibleRowIndex: Integer;
begin
  AFirstVisibleColumnIndex := CalculateFirstVisibleColumnIndex(P.X);
  AFirstVisibleRowIndex := CalculateFirstVisibleRowIndex(P.Y);
  if (AFirstVisibleRowIndex <> FirstVisibleRowIndex) or (AFirstVisibleColumnIndex <> FirstVisibleColumnIndex) then
  begin
    Control.BeginUpdate;
    try
      FirstVisibleColumnIndex := Min(P.X, AFirstVisibleColumnIndex);
      FirstVisibleRowIndex := AFirstVisibleRowIndex;
    finally
      Control.EndUpdate;
    end;
    if EditingController.IsEditing then
      EditingController.UpdateEditPosition;
  end;
end;

procedure TdxGanttControlSheetController.MakeFocusedCellVisible;
begin
  MakeCellVisible(FocusedCell);
end;

procedure TdxGanttControlSheetController.SetFocusedCell(ACell: TdxGanttControlSheetCellViewInfo);
var
  P: TPoint;
begin
  P.X := ACell.Owner.Cells.IndexOf(ACell) + FirstVisibleColumnIndex;
  P.Y := ACell.Owner.Owner.DataRows.IndexOf(ACell.Owner) + FirstVisibleRowIndex;
  FocusedCell := P;
end;

procedure TdxGanttControlSheetController.ValidateFocusedCell;
begin
  FFirstVisibleColumnIndex := Min(FirstVisibleColumnIndex, Max(0, RealVisibleColumnCount - 1));
  FFocusedCell.X := Min(FocusedColumnIndex, RealVisibleColumnCount - 1);
end;

procedure TdxGanttControlSheetController.SetFocusedColumnIndex(const Value: Integer);
var
  P: TPoint;
begin
  P := FocusedCell;
  P.X := Value;
  FocusedCell := P;
end;

procedure TdxGanttControlSheetController.SetFocusedRowIndex(const Value: Integer);
var
  P: TPoint;
begin
  P := FocusedCell;
  P.Y := Value;
  FocusedCell := P;
end;

procedure TdxGanttControlSheetController.CollapseItem;
begin
  with TdxGanttControlSheetCollapseItemCommand.Create(Self) do
  try
    Execute;
  finally
    Free;
  end;
end;

procedure TdxGanttControlSheetController.ExpandItem;
begin
  with TdxGanttControlSheetExpandItemCommand.Create(Self) do
  try
    Execute;
  finally
    Free;
  end;
end;

procedure TdxGanttControlSheetController.ToggleExpandState(AItem: TObject);
begin
  with TdxGanttControlSheetToggleItemExpandStateCommand.Create(Self) do
  try
    Execute;
  finally
    Free;
  end;
end;

procedure TdxGanttControlSheetController.ShowColumnQuickCustomizationPopup;
begin
  EditingController.HideEdit(False);
  if ColumnQuickCustomizationPopup.Visible or FIsColumnQuickCustomizationPopupVisible then
    Exit;
  ColumnQuickCustomizationPopup.BiDiMode := Control.BiDiMode;
  if ViewInfo.UseRightToLeftAlignment then
    ColumnQuickCustomizationPopup.AlignHorz := TdxRightToLeftLayoutConverter.ConvertPopupAlignHorz(pahRight)
  else
    ColumnQuickCustomizationPopup.AlignHorz := pahRight;
  FIsColumnQuickCustomizationPopupVisible := True;
  try
    ColumnQuickCustomizationPopup.Popup;
  finally
    FIsColumnQuickCustomizationPopupVisible := False;
  end;
end;

function TdxGanttControlSheetController.GetVisibleRowCount: Integer;
begin
  Result := ViewInfo.VisibleRowCount;
end;

function TdxGanttControlSheetController.ClosePopupWhenSetNil: Boolean;
begin
  Result := True;
end;

procedure TdxGanttControlSheetController.InitPopup(APopup: TdxUIElementPopupWindow);
begin
  APopup.BiDiMode := Control.BiDiMode;
  APopup.OwnerParent := Control;
  APopup.Font := Control.Font;
  APopup.LookAndFeel := Control.LookAndFeel;
  APopup.BorderStyle := ViewInfo.LookAndFeelPainter.PopupBorderStyle;
  APopup.OwnerBounds := ViewInfo.GetQuickCustomizationPopupOwnerBounds;
end;

procedure TdxGanttControlSheetController.PopupClosed;
begin
// do nothing
end;

function TdxGanttControlSheetController.ProcessNCSizeChanged: Boolean;
begin
  Result := ScrollBars.NCSizeChanged;
end;

function TdxGanttControlSheetController.GetColumnEditBounds(
  AColumnViewInfo: TdxGanttControlSheetColumnHeaderViewInfo): TRect;
var
  ABorders: TcxBorders;
begin
  Result := AColumnViewInfo.Bounds;
  ABorders := AColumnViewInfo.GetBorders;
  if bLeft in ABorders then
    Inc(Result.Left, ViewInfo.LookAndFeelPainter.HeaderBorderSize);
  if bRight in ABorders then
    Dec(Result.Right, ViewInfo.LookAndFeelPainter.HeaderBorderSize);
  if bTop in ABorders then
    Inc(Result.Top, ViewInfo.LookAndFeelPainter.HeaderBorderSize);
  if bBottom in ABorders then
    Dec(Result.Bottom, ViewInfo.LookAndFeelPainter.HeaderBorderSize);
  Result.Intersect(ViewInfo.ClientRect);
end;

function TdxGanttControlSheetController.GetColumnQuickCustomizationPopup: TdxGanttSheetColumnQuickCustomizationPopup;
begin
  if FColumnQuickCustomizationPopup = nil then
    FColumnQuickCustomizationPopup := TdxGanttSheetColumnQuickCustomizationPopup.Create(Self);
  Result := FColumnQuickCustomizationPopup;
end;

function TdxGanttControlSheetController.GetDataProvider: TdxGanttControlSheetCustomDataProvider;
begin
  Result := FOptions.DataProvider;
end;

function TdxGanttControlSheetController.GetDesignHitTest(X, Y: Integer;
  Shift: TShiftState): Boolean;
begin
  Result := CanDrag(X, Y);
end;

function TdxGanttControlSheetController.GetFocusedCellViewInfo: TdxGanttControlSheetCellCustomViewInfo;
begin
  if ViewInfo = nil then
    Result := nil
  else
    Result := ViewInfo.FocusedCellViewInfo;
end;

function TdxGanttControlSheetController.GetFocusedColumnIndex: Integer;
begin
  Result := FocusedCell.X;
end;

function TdxGanttControlSheetController.GetFocusedDataItem: TObject;
begin
  if (FocusedRowIndex < 0) or (FocusedRowIndex >= DataProvider.Count) then
    Result := nil
  else
    Result := DataProvider.Items[FocusedRowIndex];
end;

function TdxGanttControlSheetController.GetFocusedRowIndex: Integer;
begin
  Result := FocusedCell.Y;
end;

function TdxGanttControlSheetController.GetRealVisibleColumnCount: Integer;
begin
  Result := Options.Columns.VisibleCount;
  if FColumnInsertEditIndex >= 0 then
    Inc(Result);
end;

procedure TdxGanttControlSheetController.DoCreateScrollBars;
begin
  inherited DoCreateScrollBars;
  ScrollBars.DoCreateScrollBars;
end;

procedure TdxGanttControlSheetController.DoDblClick;
var
  I: Integer;
begin
  inherited DoDblClick;
  if (HitTest.HitObject is TdxGanttControlSheetColumnHeaderViewInfo) or (HitTest.HitObject is TdxGanttControlSheetColumnEmptyHeaderViewInfo) then
  begin
    for I := 0 to ViewInfo.Headers.Count - 1 do
      if ViewInfo.Headers[I] is TdxGanttControlSheetColumnHeaderViewInfo then
      begin
        if TdxGanttControlSheetColumnHeaderViewInfo(ViewInfo.Headers[I]).IsSizingZone(HitTest.HitPoint) then
        begin
          CalculateBestFit(TdxGanttControlSheetColumnHeaderViewInfo(ViewInfo.Headers[I]).Column);
          Exit;
        end;
      end;
  end;
end;

procedure TdxGanttControlSheetController.DoDestroyScrollBars;
begin
  ScrollBars.DoDestroyScrollBars;
  inherited DoDestroyScrollBars;
end;

function TdxGanttControlSheetController.GetTouchScrollUIOwner(const APoint: TPoint): IdxTouchScrollUIOwner;
begin
  Result := ScrollBars;
end;

procedure TdxGanttControlSheetController.InitScrollbars;
begin
  inherited InitScrollbars;
  ScrollBars.InitScrollBars;
end;

procedure TdxGanttControlSheetController.InsertNewDataItem;
begin
  with TdxGanttControlSheetInsertNewItemCommand.Create(Self) do
  try
    Execute;
  finally
    Free;
  end;
end;

function TdxGanttControlSheetController.IsPanArea(const APoint: TPoint): Boolean;
var
  R: TRect;
begin
  R := ViewInfo.ClientRect;
  R.Top := ViewInfo.Headers[0].Bounds.Bottom;
  Result := PtInRect(R, APoint);
end;

procedure TdxGanttControlSheetController.UnInitScrollbars;
begin
  inherited UnInitScrollbars;
  ScrollBars.UnInitScrollbars;
end;

function TdxGanttControlSheetController.InternalGetViewInfo: TdxGanttControlSheetCustomViewInfo;
begin
  Result := TdxGanttControlSheetCustomViewInfo(inherited ViewInfo);
end;

procedure TdxGanttControlSheetController.SetFirstVisibleColumnIndex(
  const Value: Integer);
begin
  if (FirstVisibleColumnIndex <> Value) and (Value >= 0) then
  begin
    ScrollBars.ShowTouchScrollUI;
    FFirstVisibleColumnIndex := Value;
    FOptions.Changed([TdxGanttControlOptionsChangedType.View]);
    if EditingController.IsEditing then
      EditingController.UpdateEditPosition;
    Options.DoFirstVisibleColumnIndexChanged;
  end;
end;

procedure TdxGanttControlSheetController.SetFirstVisibleRowIndex(const Value: Integer);
begin
  if (FirstVisibleRowIndex <> Value) and (Value >= 0) then
  begin
    FFirstVisibleRowIndex := Value;
    FOptions.Changed([TdxGanttControlOptionsChangedType.View]);
    if EditingController.IsEditing then
      EditingController.UpdateEditPosition;
    Options.DoFirstVisibleRowIndexChanged;
  end;
end;

procedure TdxGanttControlSheetController.InternalSetFocusedCell(const Value: TPoint);
var
  P, AOldValue: TPoint;
  AMakeFocusedCellViewInfoVisible: Boolean;
begin
  P := Value;
  P.X := Max(-1, Min(P.X, RealVisibleColumnCount - 1));
  P.Y := Max(-1, P.Y);
  if not FocusedCell.IsEqual(P) then
  begin
    if EditingController.IsEditing then
      EditingController.HideEdit(True);
    AOldValue := FFocusedCell;
    FFocusedCell := P;
    AMakeFocusedCellViewInfoVisible := (ViewInfo <> nil) and (FocusedCellViewInfo = nil);
    if ViewInfo <> nil then
      ViewInfo.ResetFocusedCellViewInfo;
    if AMakeFocusedCellViewInfoVisible then
      ViewInfo.Recalculate;
    if ViewInfo <> nil then
    begin
      MakeFocusedCellVisible;
      HitTest.Recalculate;
    end;
    Control.Invalidate;
    if AOldValue.X <> FFocusedCell.X then
      Options.DoFocusedColumnIndexChanged;
    if AOldValue.Y <> FFocusedCell.Y then
      Options.DoFocusedRowIndexChanged;
  end;
end;

{ TdxGanttControlSheetOptions }

constructor TdxGanttControlSheetOptions.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FColumns := CreateColumns;
end;

destructor TdxGanttControlSheetOptions.Destroy;
begin
  FreeAndNil(FColumns);
  inherited Destroy;
end;

procedure TdxGanttControlSheetOptions.DoChanged(
  AChanges: TdxGanttControlOptionsChangedTypes);
begin
  if Controller <> nil then
    Controller.ValidateFocusedCell;
  inherited DoChanged(AChanges);
end;

procedure TdxGanttControlSheetOptions.DoReset;
begin
  FCellAutoHeight := True;
  FRowHeight := 0;
  FRowHeaderWidth := ScaleFactor.Apply(DefaultRowHeaderWidth);
  FColumnQuickCustomization := False;
  FAllowColumnHide := True;
  FAllowColumnMove := True;
  FAllowColumnSize := True;
  FAlwaysShowEditor := bDefault;
  FAllowColumnRename := True;
  FAllowRowMove := True;
  FAllowColumnInsert := True;
  Columns.Reset;
  FAllowColumnDetailCustomization := True;
  FColumnQuickCustomizationSorted := False;
end;

procedure TdxGanttControlSheetOptions.DoAssign(Source: TPersistent);
var
  ASource: TdxGanttControlSheetOptions;
begin
  if Safe.Cast(Source, TdxGanttControlSheetOptions, ASource) then
  begin
    AlwaysShowEditor := ASource.AlwaysShowEditor;
    RowHeight := ASource.RowHeight;
    RowHeaderWidth := ASource.RowHeaderWidth;
    Columns := ASource.Columns;
    CellAutoHeight := ASource.CellAutoHeight;
    AllowColumnHide := ASource.AllowColumnHide;
    AllowColumnMove := ASource.AllowColumnMove;
    AllowColumnSize := ASource.AllowColumnSize;
    AllowColumnRename := ASource.AllowColumnRename;
    AllowRowMove := ASource.AllowRowMove;
    AllowColumnInsert := ASource.AllowColumnInsert;
    AllowColumnDetailCustomization := ASource.AllowColumnDetailCustomization;
    ColumnQuickCustomization := ASource.ColumnQuickCustomization;
  end;
  inherited DoAssign(Source);
end;

function TdxGanttControlSheetOptions.CreateColumns: TdxGanttControlSheetColumns;
begin
  Result := TdxGanttControlSheetColumns.Create(Self);
end;

function TdxGanttControlSheetOptions.GetControl: TdxGanttControlBase;
begin
  Result := Controller.Control;
end;

function TdxGanttControlSheetOptions.GetRealAlwaysShowEditor: Boolean;
begin
  if FAlwaysShowEditor = bDefault then
    Result := Control.OptionsBehavior.AlwaysShowEditor
  else
    Result := FAlwaysShowEditor = bTrue;
end;

function TdxGanttControlSheetOptions.DoBeforeEdit(AColumn: TdxGanttControlSheetColumn): Boolean;
begin
  Result := True;
  if Assigned(OnBeforeEdit) then
    OnBeforeEdit(Self, AColumn, Result);
end;

procedure TdxGanttControlSheetOptions.DoEditValueChanged(AColumn: TdxGanttControlSheetColumn);
begin
  if Assigned(OnEditValueChanged) then
    OnEditValueChanged(Self, AColumn)
end;

procedure TdxGanttControlSheetOptions.DoInitEdit(AColumn: TdxGanttControlSheetColumn; AEdit: TcxCustomEdit);
begin
  if Assigned(OnInitEdit) then
    OnInitEdit(Self, AColumn, AEdit)
end;

function TdxGanttControlSheetOptions.DoRowDragAndDrop(ADataItem: TObject;
  ANewIndex: Integer): Boolean;
begin
  Result := True;
end;

procedure TdxGanttControlSheetOptions.DoRowEndDrag(ADataItem: TObject);
begin
// do nothing
end;

procedure TdxGanttControlSheetOptions.DoFirstVisibleColumnIndexChanged;
begin
  if Assigned(OnFirstVisibleColumnIndexChanged) then
    OnFirstVisibleColumnIndexChanged(Self);
end;

procedure TdxGanttControlSheetOptions.DoFirstVisibleRowIndexChanged;
begin
  if Assigned(OnFirstVisibleRowIndexChanged) then
    OnFirstVisibleRowIndexChanged(Self);
end;

procedure TdxGanttControlSheetOptions.DoFocusedColumnIndexChanged;
begin
  if Assigned(OnFocusedColumnIndexChanged) then
    OnFocusedColumnIndexChanged(Self);
end;

procedure TdxGanttControlSheetOptions.DoFocusedRowIndexChanged;
begin
  if Assigned(OnFocusedRowIndexChanged) then
    OnFocusedRowIndexChanged(Self);
end;

function TdxGanttControlSheetOptions.CanRowDrag(ADataItem: TObject): Boolean;
begin
  if (ADataItem = nil) or IsReadOnly then
    Result := False
  else
    Result := DoRowStartDrag(ADataItem);
end;

function TdxGanttControlSheetOptions.DoRowStartDrag(ADataItem: TObject): Boolean;
begin
  Result := AllowRowMove;
end;

procedure TdxGanttControlSheetOptions.ClearCachedDataRowHeight;
begin
  if Controller.ViewInfo <> nil then
    Controller.ViewInfo.CachedDataRowHeight.Clear;
end;

procedure TdxGanttControlSheetOptions.DoColumnVisibilityChanged(AColumn: TdxGanttControlSheetColumn);
begin
  ClearCachedDataRowHeight;
  if Assigned(OnColumnVisibilityChanged) then
    OnColumnVisibilityChanged(Self, AColumn);
end;

procedure TdxGanttControlSheetOptions.DoColumnCaptionChanged(
  AColumn: TdxGanttControlSheetColumn);
begin
  if Assigned(OnColumnCaptionChanged) then
    OnColumnCaptionChanged(Self, AColumn);
end;

procedure TdxGanttControlSheetOptions.DoColumnPositionChanged(AColumn: TdxGanttControlSheetColumn);
begin
  if Assigned(OnColumnPositionChanged) then
    OnColumnPositionChanged(Self, AColumn);
end;

procedure TdxGanttControlSheetOptions.DoColumnSizeChanged(AColumn: TdxGanttControlSheetColumn);
begin
  ClearCachedDataRowHeight;
  if Assigned(OnColumnSizeChanged) then
    OnColumnSizeChanged(Self, AColumn);
end;

procedure TdxGanttControlSheetOptions.DoColumnWordWrapChanged(AColumn: TdxGanttControlSheetColumn);
begin
  ClearCachedDataRowHeight;
  if Assigned(OnColumnWordWrapChanged) then
    OnColumnWordWrapChanged(Self, AColumn);
end;

function TdxGanttControlSheetOptions.IsReadOnly: Boolean;
begin
  Result := Control.OptionsBehavior.ReadOnly;
end;

procedure TdxGanttControlSheetOptions.SetCellAutoHeight(const Value: Boolean);
begin
  if CellAutoHeight <> Value then
  begin
    FCellAutoHeight := Value;
    Changed([TdxGanttControlOptionsChangedType.Size]);
  end;
end;

procedure TdxGanttControlSheetOptions.SetColumnQuickCustomization(const Value: Boolean);
begin
  if ColumnQuickCustomization <> Value then
  begin
    FColumnQuickCustomization := Value;
    Changed([TdxGanttControlOptionsChangedType.Size]);
  end;
end;

procedure TdxGanttControlSheetOptions.SetColumns(
  const Value: TdxGanttControlSheetColumns);
begin
  FColumns.Assign(Value);
end;

procedure TdxGanttControlSheetOptions.SetRowHeaderWidth(const Value: Integer);
begin
  if (FRowHeaderWidth <> Value) and (Value >= RowHeaderMinWidth) then
  begin
    FRowHeaderWidth := Value;
    Changed([TdxGanttControlOptionsChangedType.Size]);
  end;
end;

procedure TdxGanttControlSheetOptions.SetRowHeight(const Value: Integer);
begin
  if (FRowHeight <> Value) and (Value >= 0) then
  begin
    FRowHeight := Value;
    Changed([TdxGanttControlOptionsChangedType.Size]);
  end;
end;

// IcxStoredObject }

function TdxGanttControlSheetOptions.GetObjectName: string;
begin
  Result := 'OptionsSheet';
end;

function TdxGanttControlSheetOptions.GetProperties(AProperties: TStrings): Boolean;
begin
  AProperties.Add('Width');
  if Assigned(OnGetStoredProperties) then
    OnGetStoredProperties(Self, AProperties);
  Result := True;
end;

procedure TdxGanttControlSheetOptions.GetPropertyValue(const AName: string; var AValue: Variant);
begin
  if Assigned(OnGetStoredPropertyValue) then
    OnGetStoredPropertyValue(Self, AName, AValue);
end;

procedure TdxGanttControlSheetOptions.SetPropertyValue
  (const AName: string; const AValue: Variant);
begin
  if Assigned(OnSetStoredPropertyValue) then
    OnSetStoredPropertyValue(Self, AName, AValue);
end;

// IcxStoredParent
procedure TdxGanttControlSheetOptions.StoredChildren(AChildren: TStringList);
begin
  AChildren.AddObject('', Columns);
end;

function TdxGanttControlSheetOptions.StoredCreateChild(const AObjectName, AClassName: string): TObject;
begin
  Result := nil;
end;

procedure TdxGanttControlSheetOptions.StoredDeleteChild(const AObjectName: string; AObject: TObject);
begin
//
end;

end.
