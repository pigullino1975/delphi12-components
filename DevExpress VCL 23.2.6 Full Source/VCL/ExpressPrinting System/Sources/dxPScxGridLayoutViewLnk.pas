{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressPrinting System                                   }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSPRINTING SYSTEM AND            }
{   ALL ACCOMPANYING VCL CONTROLS AS PART OF AN                      }
{   EXECUTABLE PROGRAM ONLY                                          }
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

unit dxPScxGridLayoutViewLnk;

{$I cxVer.Inc}

interface

uses
  Types, SysUtils, cxDBData, dxLayoutContainer, dxLayoutLookAndFeels, cxGridCustomView, cxGridCustomLayoutView,
  cxGridLayoutView, cxStyles, cxGridCustomTableView, cxGraphics, dxPScxCommon, cxGridViewLayoutContainer,
  cxGridDBDataDefinitions, cxGridDBLayoutView, dxPSCore, dxPScxGridLnk;

type
  TdxGridLayoutViewFormatter = class;
  TdxGridLayoutViewAdapter = class;
  TdxGridLayoutViewBuilder = class;

  TdxGridLayoutViewContainerProducer = class(TdxGridCustomLayoutContainerProducer)
  strict private
    function GetAdapter: TdxGridLayoutViewAdapter;
    function GetFormatter: TdxGridLayoutViewFormatter;
  protected
    function GetGroupViewParams(ARecord: TcxCustomGridRecord): TdxReportItemViewParams; override;
    function GetItemCaptionViewParams(ARecord: TcxCustomGridRecord): TdxReportItemViewParams; override;

    property Adapter: TdxGridLayoutViewAdapter read GetAdapter;
    property Formatter: TdxGridLayoutViewFormatter read GetFormatter;
  end;

  TdxGridLayoutViewFormatter = class(TdxGridCustomLayoutViewFormatter, IcxGridLayoutViewStylesHelper)
  private
    function GetLayoutLookAndFeel: TcxGridLayoutLookAndFeel;
  protected
    function GetFirstRecordOffset: Integer; override;
    function GetInterRecordsSpaceHorz: Integer; override;
    function GetInterRecordsSpaceVert: Integer; override;

    procedure CreateCaptionCell(ARecord: TdxReportLayout; AViewInfo: TcxGridLayoutViewRecordCaptionViewInfo);

    function GetContainerProducerClass: TdxGridCustomLayoutContainerProducerClass;
    procedure InitializeRecordLayout(ARecord: TdxReportLayout);
    procedure ProduceContainer(AContainerViewInfo: TcxGridLayoutContainerViewInfo; AParent: TdxReportLayout);

    function GetGroupViewParams(ARecord: TcxCustomGridRecord): TdxReportItemViewParams;
    function GetItemCaptionViewParams(ARecord: TcxCustomGridRecord): TdxReportItemViewParams;
    function GetRecordCaptionViewParams(ARecord: TcxCustomGridRecord): TdxReportItemViewParams;
    function GetRecordViewParams(ARecord: TcxCustomGridRecord): TdxReportItemViewParams;

    // IcxGridLayoutViewStylesHelper
    procedure GetContentParams(ARecord: TcxCustomGridRecord; AItem: TcxCustomGridTableItem; out AParams: TcxViewParams);
    procedure GetGroupParams(ARecord: TcxCustomGridRecord; AItem: TcxCustomGridTableItem; out AParams: TcxViewParams);
    procedure GetItemParams(ARecord: TcxCustomGridRecord; AItem: TcxCustomGridTableItem; out AParams: TcxViewParams);
    procedure GetRecordCaptionParams(ARecord: TcxCustomGridRecord; out AParams: TcxViewParams);

    property LayoutLookAndFeel: TcxGridLayoutLookAndFeel read GetLayoutLookAndFeel;
  public
    function Adapter: TdxGridLayoutViewAdapter; reintroduce; overload;
    function Builder: TdxGridLayoutViewBuilder; reintroduce; overload;
    procedure DoInitializeRecord(ARecord: TdxReportCustomLayout; AGridRecord: TcxGridCustomLayoutRecord); override;

    function GetItemViewParams(ATableItem: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord; AnIsPreview: Boolean = False; AIsDataCell: Boolean = False): TdxReportItemViewParams; override;

    function GetRecordClass(AGridRecord: TcxGridCustomLayoutRecord): TdxReportCustomLayoutClass; override;
  end;

  { TdxGridLayoutViewAdapter }

  TdxGridLayoutViewAdapter = class(TdxGridCustomLayoutViewAdapter)
  protected
    function Styles: TcxGridLayoutViewStyles; reintroduce; overload;
  end;

  { TdxGridLayoutViewBuilder }

  TdxGridLayoutViewBuilder = class(TdxGridCustomLayoutViewBuilder)
  private
    function GetRecord(Index: Integer): TdxReportLayout;
  protected
    function GridView: TcxGridLayoutView; reintroduce; overload;
    class function GridViewClass: TcxCustomGridViewClass; override;
    procedure DoBuildViewBody; override;
    procedure DoResizeRecords; override;

    property Records[Index: Integer]: TdxReportLayout read GetRecord;
  public
    constructor Create(AReportLink: TdxGridReportLink; AMasterBuilder: TdxCustomGridViewBuilder; AGridView: TcxCustomGridView); override;
    destructor Destroy; override;

    class function AdapterClass: TdxGridViewAdapterClass; override;
    function Formatter: TdxGridLayoutViewFormatter; reintroduce; overload;
    class function FormatterClass: TdxGridViewFormatterClass; override;
  end;

  TdxGridDBLayoutViewAdapter = class(TdxGridLayoutViewAdapter)
  protected
    function DataController: TcxGridDBDataController; reintroduce; overload;
    function DBDataModeController: TcxDBDataModeController; override;
  end;

  TdxGridDBLayoutViewBuilder = class(TdxGridLayoutViewBuilder)
  protected
    class function GridViewClass: TcxCustomGridViewClass; override;
  public
    class function AdapterClass: TdxGridViewAdapterClass; override;
  end;

implementation

uses
  Classes, Graphics, Contnrs, cxGeometry, cxEdit, dxCore;

const
  dxThisUnitName = 'dxPScxGridLayoutViewLnk';

const
  FirstRecordOffset = 2;

type
  TcxGridLayoutViewAccess = class(TcxGridLayoutView);
  TdxLayoutLookAndFeelGroupOptionsAccess = class(TdxLayoutLookAndFeelGroupOptions);
  TcxStylesAccess = class(TcxStyles);

{ TdxGridLayoutViewContainerProducer }

function TdxGridLayoutViewContainerProducer.GetGroupViewParams(ARecord: TcxCustomGridRecord): TdxReportItemViewParams;
begin
  Result := Formatter.GetGroupViewParams(ARecord);
end;

function TdxGridLayoutViewContainerProducer.GetItemCaptionViewParams(ARecord: TcxCustomGridRecord): TdxReportItemViewParams;
begin
  Result := Formatter.GetItemCaptionViewParams(ARecord);
end;

function TdxGridLayoutViewContainerProducer.GetAdapter: TdxGridLayoutViewAdapter;
begin
  Result := TdxGridLayoutViewAdapter(inherited Adapter);
end;

function TdxGridLayoutViewContainerProducer.GetFormatter: TdxGridLayoutViewFormatter;
begin
  Result := TdxGridLayoutViewFormatter(inherited Formatter);
end;

{ TdxGridLayoutViewFormatter }

function TdxGridLayoutViewFormatter.Builder: TdxGridLayoutViewBuilder;
begin
  Result := inherited Builder as TdxGridLayoutViewBuilder;
end;

function TdxGridLayoutViewFormatter.Adapter: TdxGridLayoutViewAdapter;
begin
  Result := TdxGridLayoutViewAdapter(inherited Adapter);
end;

procedure TdxGridLayoutViewFormatter.DoInitializeRecord(ARecord: TdxReportCustomLayout; AGridRecord: TcxGridCustomLayoutRecord);
begin
  inherited;
  InitializeRecordLayout(TdxReportLayout(ARecord));
end;

function TdxGridLayoutViewFormatter.GetItemViewParams(ATableItem: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord; AnIsPreview: Boolean = False; AIsDataCell: Boolean = False): TdxReportItemViewParams;
begin
  Result := inherited GetItemViewParams(ATableItem, ARecord, AnIsPreview, AIsDataCell);
  Result.Transparent := not AIsDataCell;
end;

function TdxGridLayoutViewFormatter.GetRecordClass(AGridRecord: TcxGridCustomLayoutRecord): TdxReportCustomLayoutClass;
begin
  Result := TdxReportLayout;
end;

function TdxGridLayoutViewFormatter.GetFirstRecordOffset: Integer;
begin
  Result := FirstRecordOffset;
end;

function TdxGridLayoutViewFormatter.GetInterRecordsSpaceHorz: Integer;
begin
  Result := ReportLink.OptionsCards.InterCardsSpaceHorz;
end;

function TdxGridLayoutViewFormatter.GetInterRecordsSpaceVert: Integer;
begin
  Result := ReportLink.OptionsCards.InterCardsSpaceVert;
end;

procedure TdxGridLayoutViewFormatter.CreateCaptionCell(ARecord: TdxReportLayout;
  AViewInfo: TcxGridLayoutViewRecordCaptionViewInfo);
var
  R: TRect;
  ACaption: TdxReportCellString;
begin
  ACaption := TdxReportCellString.Create(ARecord);
  SetViewParams(ACaption, GetRecordCaptionViewParams(ARecord.GridRecord));
  with ACaption do
  begin
    R := cxRectOffset(AViewInfo.Bounds, AViewInfo.Bounds.TopLeft, False);
    Text := AViewInfo.Text;
    BoundsRect := R;
  end;
end;

function TdxGridLayoutViewFormatter.GetContainerProducerClass: TdxGridCustomLayoutContainerProducerClass;
begin
  Result := TdxGridLayoutViewContainerProducer;
end;

procedure TdxGridLayoutViewFormatter.InitializeRecordLayout(ARecord: TdxReportLayout);
var
  AViewInfo: TcxGridLayoutViewRecordViewInfo;
begin
  AViewInfo := TcxGridLayoutViewRecordViewInfo.Create(ARecord.GridRecord.GridView.ViewInfo.RecordsViewInfo, ARecord.GridRecord);
  try
    AViewInfo.Calculate(10000, 10000);
    ARecord.Width := AViewInfo.Width;
    ARecord.Height := AViewInfo.Height;
    if AViewInfo.CaptionViewInfo <> nil then
      CreateCaptionCell(ARecord, AViewInfo.CaptionViewInfo);
    SetViewParams(ARecord, GetRecordViewParams(ARecord.GridRecord));
    if ARecord.GridRecord.Expanded then
      ProduceContainer(AViewInfo.LayoutViewInfo, ARecord);
  finally
    FreeAndNil(AViewInfo);
  end;
end;

procedure TdxGridLayoutViewFormatter.ProduceContainer(AContainerViewInfo: TcxGridLayoutContainerViewInfo; AParent: TdxReportLayout);
var
  AProducer: TdxGridCustomLayoutContainerProducer;
begin
  AProducer := GetContainerProducerClass.Create(AContainerViewInfo, AParent, Self);
  try
    AProducer.Produce;
  finally
    AProducer.Free;
  end;
end;

function TdxGridLayoutViewFormatter.GetGroupViewParams(ARecord: TcxCustomGridRecord): TdxReportItemViewParams;
var
  AParams: TcxViewParams;
begin
  if ReportLink.OptionsFormatting.UseNativeStyles then
  begin
    TcxStylesAccess(ReportLink.Styles).GetDefaultViewParams(vspsGridGroup, nil, AParams);
    ReportLink.Styles.GetGroupParams(ARecord, 0, Result.NativeParams);
    Result.Transparent := Result.NativeParams.Color = AParams.Color;
  end
  else
  begin
    Adapter.Styles.GetGroupParams(ARecord, nil, Result.NativeParams);
    if Result.NativeParams.Color = clDefault then
      Result.NativeParams.Color := TdxLayoutLookAndFeelGroupOptionsAccess(LayoutLookAndFeel.GroupOptions).GetDefaultColor;
    Result.Transparent := False;
  end;
  Result.FontStyle := [];
end;

function TdxGridLayoutViewFormatter.GetItemCaptionViewParams(ARecord: TcxCustomGridRecord): TdxReportItemViewParams;
begin
  if ReportLink.OptionsFormatting.UseNativeStyles then
    ReportLink.Styles.GetCardRowCaptionParams(ARecord, nil, Result.NativeParams)
  else
    Adapter.Styles.GetItemParams(ARecord, nil, Result.NativeParams);
  Result.FontStyle := [];
  Result.CellSides := [];
  Result.Transparent := True;
end;

function TdxGridLayoutViewFormatter.GetRecordCaptionViewParams(ARecord: TcxCustomGridRecord): TdxReportItemViewParams;
begin
  if ReportLink.OptionsFormatting.UseNativeStyles then
    ReportLink.Styles.GetCardCaptionRowParams(ARecord, nil, Result.NativeParams)
  else
    Adapter.Styles.GetRecordCaptionParams(ARecord, Result.NativeParams);
  if ReportLink.OptionsCards.Borders then
    Result.CellSides := csAll
  else
    Result.CellSides := [];
  Result.Transparent := IsColorTransparent(Result.NativeParams.Color);
  Result.FontStyle := [];
end;

function TdxGridLayoutViewFormatter.GetRecordViewParams(ARecord: TcxCustomGridRecord): TdxReportItemViewParams;
begin
  Result := GetGroupViewParams(ARecord);
  if ReportLink.OptionsCards.Borders then
    Result.CellSides := csAll
  else
    Result.CellSides := [];
  Result.FontStyle := [];
end;

procedure TdxGridLayoutViewFormatter.GetContentParams(ARecord: TcxCustomGridRecord; AItem: TcxCustomGridTableItem; out AParams: TcxViewParams);
begin
  if ReportLink.OptionsFormatting.UseNativeStyles then
    AParams := GetItemViewParams(AItem, ARecord, True).NativeParams
  else
    Adapter.Styles.GetContentParams(ARecord, AItem, AParams);
end;

procedure TdxGridLayoutViewFormatter.GetGroupParams(ARecord: TcxCustomGridRecord; AItem: TcxCustomGridTableItem; out AParams: TcxViewParams);
begin
  AParams := GetGroupViewParams(ARecord).NativeParams;
end;

procedure TdxGridLayoutViewFormatter.GetItemParams(ARecord: TcxCustomGridRecord; AItem: TcxCustomGridTableItem; out AParams: TcxViewParams);
begin
  AParams := GetItemCaptionViewParams(ARecord).NativeParams;
end;

procedure TdxGridLayoutViewFormatter.GetRecordCaptionParams(ARecord: TcxCustomGridRecord; out AParams: TcxViewParams);
begin
  AParams := GetRecordCaptionViewParams(ARecord).NativeParams;
end;

function TdxGridLayoutViewFormatter.GetLayoutLookAndFeel: TcxGridLayoutLookAndFeel;
begin
  Result := TcxGridLayoutViewAccess(Builder.GridView).LayoutLookAndFeel;
end;

{ TdxGridLayoutViewAdapter }

function TdxGridLayoutViewAdapter.Styles: TcxGridLayoutViewStyles;
begin
  Result := inherited Styles as TcxGridLayoutViewStyles;
end;

{ TdxGridLayoutViewBuilder }

constructor TdxGridLayoutViewBuilder.Create(AReportLink: TdxGridReportLink;
  AMasterBuilder: TdxCustomGridViewBuilder; AGridView: TcxCustomGridView);
begin
  // todo:
  inherited;
end;

destructor TdxGridLayoutViewBuilder.Destroy;
begin
  // todo:
  inherited;
end;

class function TdxGridLayoutViewBuilder.AdapterClass: TdxGridViewAdapterClass;
begin
  Result := TdxGridLayoutViewAdapter;
end;

function TdxGridLayoutViewBuilder.Formatter: TdxGridLayoutViewFormatter;
begin
  Result := inherited Formatter as TdxGridLayoutViewFormatter;
end;

class function TdxGridLayoutViewBuilder.FormatterClass: TdxGridViewFormatterClass;
begin
  Result := TdxGridLayoutViewFormatter;
end;

function TdxGridLayoutViewBuilder.GridView: TcxGridLayoutView;
begin
  Result := inherited GridView as TcxGridLayoutView;
end;

class function TdxGridLayoutViewBuilder.GridViewClass: TcxCustomGridViewClass;
begin
  Result := TcxGridLayoutView;
end;

procedure TdxGridLayoutViewBuilder.DoBuildViewBody;

  procedure UpdateGridViewSize;
  begin
    TcxGridLayoutViewAccess(GridView).IsDefaultViewInfoCalculated := False;
    GridView.Changed(vcSize);
  end;

var
  AList: TObjectList;
begin
  AList := TObjectList.Create;
  dxLayoutStoreItemStates(AList, GridView.Container);
  try
    GridView.StylesAdapter.Helper := Formatter;
    dxLayoutSetItemStates(GridView.Container, True, False, False, False);
    UpdateGridViewSize;
    inherited;
    GridView.StylesAdapter.Helper := nil;
  finally
    dxLayoutRestoreItemStates(AList, GridView.Container);
    AList.Free;
  end;
  UpdateGridViewSize;
end;

procedure TdxGridLayoutViewBuilder.DoResizeRecords;

  function GetRootWidth(ARecord: TdxReportCustomLayout): Integer;
  begin
    Result := ARecord.Width - 2 * GridView.OptionsView.RecordBorderWidth;
  end;

var
  I: Integer;
begin
  inherited;
  if Formatter.AutoWidth then
  begin
    for I := 0 to RecordCount - 1 do
    begin
      GridView.Container.Root.Width := GetRootWidth(Records[I]);
      try
        Records[I].ClearAll;
        Formatter.InitializeRecordLayout(Records[I]);
      finally
        GridView.Container.Root.Width := 0;
      end;
    end;
  end;
end;

function TdxGridLayoutViewBuilder.GetRecord(Index: Integer): TdxReportLayout;
begin
  Result := inherited Records[Index] as TdxReportLayout;
end;

{ TdxGridDBLayoutViewAdapter }

function TdxGridDBLayoutViewAdapter.DataController: TcxGridDBDataController;
begin
  Result := inherited DataController as TcxGridDBDataController;
end;

function TdxGridDBLayoutViewAdapter.DBDataModeController: TcxDBDataModeController;
begin
  Result := DataController.DataModeController;
end;                                            

{ TdxGridDBLayoutViewBuilder }

class function TdxGridDBLayoutViewBuilder.AdapterClass: TdxGridViewAdapterClass;
begin
  Result := TdxGridDBLayoutViewAdapter;
end;

class function TdxGridDBLayoutViewBuilder.GridViewClass: TcxCustomGridViewClass;
begin
  Result := TcxGridDBLayoutView;
end;

procedure RegisterAssistants;
begin
  TdxGridLayoutViewBuilder.Register;
  TdxGridDBLayoutViewBuilder.Register;
end;

procedure UnegisterAssistants;
begin
  TdxGridDBLayoutViewBuilder.Unregister;
  TdxGridLayoutViewBuilder.Unregister;
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  RegisterAssistants;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  UnegisterAssistants;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
