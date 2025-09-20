unit MailClientDemoBaseGrid;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Types,
  Dialogs, ExtCtrls, dxCore, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore, Menus, cxStyles,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxNavigator, DB, cxDBData, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  StdCtrls, cxButtons, cxMaskEdit, cxDropDownEdit, cxGroupBox, cxSplitter,
  cxTextEdit, cxMemo, cxRichEdit, cxGridDBDataDefinitions, cxLabel, dxBar,
  dxLayoutcxEditAdapters, dxLayoutContainer, dxLayoutControl, dxBevel,
  MailClientDemoBase, dxLayoutControlAdapters, cxMRUEdit,
  dxSkinsdxBarPainter, ActnList, dxPSGlbl, dxPSUtl, dxPSEngn, dxPrnPg, dxBkgnd,
  dxWrap, dxPrnDev, dxPSCompsProvider, dxPSFillPatterns, dxPSEdgePatterns,
  dxPSPDFExportCore, dxPSPDFExport, cxDrawTextUtils, dxPSPrVwStd, dxPSPrVwAdv,
  dxPSPrVwRibbon, dxPScxPageControlProducer, dxPScxEditorProducers,
  dxPScxExtEditorProducers, dxSkinsdxRibbonPainter, dxPSCore,
  MailClientDemoData, dxPScxExtComCtrlsLnk, dxPScxGridLnk, dxPScxGridLayoutViewLnk,
  dxPScxSchedulerLnk, dxLayoutLookAndFeels, dxDateRanges,
  dxScrollbarAnnotations, System.Actions, cxGeometry, dxFramedControl,
  dxPanel;

type
  TMailClientDemoBaseGridFrame = class(TMailClientDemoBaseFrame)
    AutoSearchTimer: TTimer;
    lgRoot: TdxLayoutGroup;
    lcMain: TdxLayoutControl;
    lgRich: TdxLayoutGroup;
    lblSubject: TcxLabel;
    liSubject: TdxLayoutItem;
    lgContentCaption: TdxLayoutGroup;
    liSpace: TdxLayoutEmptySpaceItem;
    tvMain: TcxGridDBTableView;
    grMainLevel1: TcxGridLevel;
    grMain: TcxGrid;
    liRich: TdxLayoutItem;
    cxreMain: TcxRichEdit;
    liFrom: TdxLayoutLabeledItem;
    liDate: TdxLayoutLabeledItem;
    actLayoutFlip: TAction;
    actLayoutRotate: TAction;
    dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList;
    lslfGroup: TdxLayoutSkinLookAndFeel;
    lslfMain: TdxLayoutSkinLookAndFeel;
    PanelGrid: TdxPanel;
    PanelFilter: TdxPanel;
    PanelMain: TdxPanel;
    PanelButtons: TdxPanel;
    cxbSearch: TcxButton;
    cxbSearchClear: TcxButton;
    PanelSearch: TdxPanel;
    mrueSearch: TcxMRUEdit;
    procedure cxbSearchClick(Sender: TObject);
    procedure cxbSearchClearClick(Sender: TObject);
    procedure AutoSearchTimerTimer(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure mrueSearchPropertiesChange(Sender: TObject);
    procedure tvMainDataControllerDataChanged(Sender: TObject);
    procedure actLayoutFlipExecute(Sender: TObject);
    procedure actLayoutRotateExecute(Sender: TObject);
    procedure cxreMainPropertiesURLClick(Sender: TcxCustomRichEdit;
      const URLText: string; Button: TMouseButton);
  private
    FLockFilter: Boolean;
    procedure ClearLikeFilter;
    procedure SetClearButtonEnabled;
    procedure SearchEditOnResize(Sender: TObject);
  protected
    procedure AddLikeCondition(AItemList: TcxFilterCriteriaItemList;
      AColumn: TcxCustomGridTableItem; const ALike: string);
    procedure AddLikeFilter; virtual;
    procedure AfterActivate; override;
    procedure CalculateItemsCount; virtual;
    function CustomDrawImageOnCell(ACellViewInfo: TcxGridTableDataCellViewInfo;
      ACanvas: TcxCanvas; AImageList: TcxImageList;
      ANeedImages: array of Integer; const ANeedIndex: Integer): Boolean;
    procedure DoFrameResize; virtual;
    procedure ExportToHTML(const AFileName: string); override;
    procedure ExportToXLS(const AFileName: string); override;
    procedure ExportToXLSX(const AFileName: string); override;
    procedure ExportToXML(const AFileName: string); override;
    procedure ExportToTXT(const AFileName: string); override;
    function GetController: TcxGridTableController;
    function GetContentZoomPosition: Integer; override;
    function GetCurrentRecordItemValue(const AItemIndex: Integer): Variant;
    function GetDataController: TcxGridDBDataController; virtual;
    function GetDataSet: TDataSet; override;
    procedure RepairLostOwingInheritanceSettings; virtual;
    procedure SetContentZoomPosition(Value: Integer); override;
    procedure SetCurrentRecordItemValue(const AItemIndex: Integer; const AValue: Variant; APostRecord: Boolean = True);
    procedure StopAutoSeekTimer;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ApplyGeneralFilter;
    procedure ExchangeMainGroupsLayout;
    procedure FlipLayout;
    function GetItemCountInfo: string; override;
    procedure RotateLayout;
    procedure Translate; override;

    property Controller: TcxGridTableController read GetController;
    property DataController: TcxGridDBDataController read GetDataController;
  published
    procedure CustomDrawHighligtingCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
  end;

var
  MailClientDemoBaseGridFrame: TMailClientDemoBaseGridFrame;

implementation

uses
  Math, cxDataUtils, MailClientDemoMain, cxGridExportLink, LocalizationStrs;

{$R *.dfm}

constructor TMailClientDemoBaseGridFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  RepairLostOwingInheritanceSettings;
  mrueSearch.OnResize := SearchEditOnResize;
end;

procedure TMailClientDemoBaseGridFrame.SearchEditOnResize(Sender: TObject);
begin
  cxbSearch.Height := mrueSearch.Height;
  cxbSearchClear.Height := mrueSearch.Height;
end;

procedure TMailClientDemoBaseGridFrame.CustomDrawHighligtingCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  AFoundText, ACellText: string;
  P: Integer;
begin
  ADone := False;
  if (Trim(mrueSearch.Text) = '') or not (AViewInfo.EditViewInfo is TcxCustomTextEditViewInfo) then Exit;
  AFoundText := AnsiUpperCase(mrueSearch.Text);
  ACellText := AViewInfo.Text;
  P := Pos(AFoundText, AnsiUpperCase(ACellText));
  if P > 0 then
  with TcxCustomTextEditViewInfo(AViewInfo.EditViewInfo) do
  begin
    SelStart := P - 1;
    SelLength := Length(AFoundText);
    SelBackgroundColor := RGB(255, 210, 0);
  end;
end;

function TMailClientDemoBaseGridFrame.GetController: TcxGridTableController;
begin
  Result := tvMain.Controller;
end;

function TMailClientDemoBaseGridFrame.GetContentZoomPosition: Integer;
begin
  Result := Trunc(cxreMain.ActiveProperties.ZoomFactor * 100);
end;

function TMailClientDemoBaseGridFrame.GetCurrentRecordItemValue(
  const AItemIndex: Integer): Variant;
begin
  Result := DataController.GetEditValue(AItemIndex, evsValue);
end;

function TMailClientDemoBaseGridFrame.GetDataController: TcxGridDBDataController;
begin
  Result := TcxGridDBDataController(grMain.ActiveView.DataController);
end;

function TMailClientDemoBaseGridFrame.GetDataSet: TDataSet;
begin
  Result := DataController.DataSource.DataSet;                                  
end;

function TMailClientDemoBaseGridFrame.CustomDrawImageOnCell(ACellViewInfo: TcxGridTableDataCellViewInfo;
  ACanvas: TcxCanvas; AImageList: TcxImageList;
  ANeedImages: array of Integer; const ANeedIndex: Integer): Boolean;
begin
  ACanvas.FillRect(ACellViewInfo.Bounds, ACellViewInfo.EditViewInfo.BackgroundColor);
  Result := (ANeedIndex >= Low(ANeedImages)) and (ANeedIndex <= High(ANeedImages));
  if Result then
    TdxImageDrawer.DrawImage(ACanvas, cxRectCenter(ACellViewInfo.Bounds, AImageList.Width, AImageList.Height), nil, AImageList,
      ANeedImages[ANeedIndex], Enabled, nil, fmMailClientDemoMain.ScaleFactor);
end;

procedure TMailClientDemoBaseGridFrame.ApplyGeneralFilter;
var
  AFilter: TcxDataFilterCriteria;
begin
  if FLockFilter then Exit;

  ShowHourglassCursor;
  try
    FLockFilter := True;
    AFilter := DataController.Filter;
    AFilter.BeginUpdate;
    try
      ClearLikeFilter;
      AddLikeFilter;
      AFilter.Active := True;
    finally
      AFilter.EndUpdate;
      FLockFilter := False;
    end;
  finally
    HideHourglassCursor;
  end;

  StopAutoSeekTimer;
  if grMain.ActiveView = tvMain then
    DataController.Groups.FullExpand;
end;

procedure TMailClientDemoBaseGridFrame.mrueSearchPropertiesChange(Sender: TObject);
begin
  StopAutoSeekTimer;
  AutoSearchTimer.Enabled := True;
  SetClearButtonEnabled;
end;

procedure TMailClientDemoBaseGridFrame.cxbSearchClick(Sender: TObject);
begin
  ApplyGeneralFilter;
end;

procedure TMailClientDemoBaseGridFrame.cxreMainPropertiesURLClick(
  Sender: TcxCustomRichEdit; const URLText: string; Button: TMouseButton);
begin
  dxShellExecute(URLText);
end;

procedure TMailClientDemoBaseGridFrame.cxbSearchClearClick(Sender: TObject);
begin
  mrueSearch.Text := '';
  ApplyGeneralFilter;
end;

procedure TMailClientDemoBaseGridFrame.AutoSearchTimerTimer(Sender: TObject);
begin
  if Trim(mrueSearch.Text) = '' then
    cxbSearchClearClick(Sender)
  else
    cxbSearchClick(Sender);
end;

procedure TMailClientDemoBaseGridFrame.ClearLikeFilter;
var
  I: Integer;
  ARoot: TcxFilterCriteriaItemList;
begin
  ARoot := DataController.Filter.Root;
  for I := ARoot.Count - 1 downto 0 do
  begin
    if ARoot.Items[I] is TcxFilterCriteriaItemList then
      ARoot.Items[I].Free;
  end;
end;

procedure TMailClientDemoBaseGridFrame.actLayoutFlipExecute(Sender: TObject);
begin
  FlipLayout;
end;

procedure TMailClientDemoBaseGridFrame.actLayoutRotateExecute(Sender: TObject);
begin
  RotateLayout;
end;

procedure TMailClientDemoBaseGridFrame.AddLikeCondition(
  AItemList: TcxFilterCriteriaItemList; AColumn: TcxCustomGridTableItem; const ALike: string);
begin
  if AColumn.Visible then
    AItemList.AddItem(AColumn, foLike, '%' + ALike + '%', '"' + ALike + '"');
end;

procedure TMailClientDemoBaseGridFrame.AddLikeFilter;
begin
end;

procedure TMailClientDemoBaseGridFrame.AfterActivate;
begin
  inherited AfterActivate;
  CalculateItemsCount;
  SetClearButtonEnabled;
end;

procedure TMailClientDemoBaseGridFrame.CalculateItemsCount;
begin
  tvMainDataControllerDataChanged(Self);
end;

procedure TMailClientDemoBaseGridFrame.ExchangeMainGroupsLayout;
begin
  if PanelMain.Visible then
  begin
    case PanelMain.Align of
      alRight:
        begin
          PanelMain.Align := alLeft;
          PanelMain.Frame.Borders := [bRight];
        end;
      alLeft:
        begin
          PanelMain.Align := alRight;
          PanelMain.Frame.Borders := [bLeft];
        end;
    end;
  end;
end;

procedure TMailClientDemoBaseGridFrame.ExportToHTML(const AFileName: string);
begin
  ExportGridToHTML(AFileName, grMain);
end;

procedure TMailClientDemoBaseGridFrame.ExportToXLS(const AFileName: string);
begin
  ExportGridToExcel(AFileName, grMain);
end;

procedure TMailClientDemoBaseGridFrame.ExportToXLSX(const AFileName: string);
begin
  ExportGridToXLSX(AFileName, grMain);
end;

procedure TMailClientDemoBaseGridFrame.ExportToXML(const AFileName: string);
begin
  ExportGridToXML(AFileName, grMain);
end;

procedure TMailClientDemoBaseGridFrame.ExportToTXT(const AFileName: string);
begin
  ExportGridToText(AFileName, grMain);
end;

procedure TMailClientDemoBaseGridFrame.FlipLayout;
begin
  if lgRoot.LayoutDirection = ldHorizontal then
    ExchangeMainGroupsLayout;
end;

function TMailClientDemoBaseGridFrame.GetItemCountInfo: string;
begin
  Result := Format(cxGetResourceString(@sItemCountInfo), [DataController.FilteredRecordCount]);
end;

procedure TMailClientDemoBaseGridFrame.RepairLostOwingInheritanceSettings;
begin
  lcMain.LookAndFeel := lslfMain;
//#  lgGrid.LookAndFeel := lslfGroup;
  lgRich.LookAndFeel := lslfGroup;
end;

procedure TMailClientDemoBaseGridFrame.RotateLayout;
begin
  if PanelMain.Visible then
  begin
    case PanelMain.Align of
      alLeft:
        begin
          PanelMain.Align := alTop;
          PanelMain.Frame.Borders := [bBottom];
        end;
      alTop:
        begin
          PanelMain.Align := alRight;
          PanelMain.Height := PanelMain.Parent.Height div 2;
          PanelMain.Frame.Borders := [bLeft];
        end;
      alRight:
        begin
          PanelMain.Align := alBottom;
          PanelMain.Frame.Borders := [bTop];
        end;
      alBottom:
        begin
          PanelMain.Align := alLeft;
          PanelMain.Height := PanelMain.Parent.Height div 2;
          PanelMain.Frame.Borders := [bRight];
        end;
    end;
  end;
  actLayoutFlip.Enabled := PanelMain.Align in [alLeft, alRight];
end;

procedure TMailClientDemoBaseGridFrame.SetClearButtonEnabled;
begin
  cxbSearchClear.Enabled := mrueSearch.Text <> '';
end;

procedure TMailClientDemoBaseGridFrame.SetCurrentRecordItemValue(
  const AItemIndex: Integer; const AValue: Variant; APostRecord: Boolean = True);
begin
  DataController.SetEditValue(AItemIndex, AValue, evsValue);
  if APostRecord then
    DataController.Post
  else
    DataController.PostEditingData;
end;

procedure TMailClientDemoBaseGridFrame.SetContentZoomPosition(Value: Integer);
begin
  cxreMain.ActiveProperties.ZoomFactor := Value / 100;
end;

procedure TMailClientDemoBaseGridFrame.StopAutoSeekTimer;
begin
  if AutoSearchTimer.Enabled then
    AutoSearchTimer.Enabled := False;
end;

procedure TMailClientDemoBaseGridFrame.FrameResize(Sender: TObject);
begin
  if not lgRich.Visible or not IsActive then Exit;
  DoFrameResize;
end;

procedure LimitWidthByParent(AItem: TdxCustomLayoutLabeledItem);
var
  APrevAlignHorz: TdxLayoutAlignHorz;
  APrevCaption: string;
  ACaptionOptions: TdxLayoutLabeledItemCustomCaptionOptions;
begin
  if not AItem.ActuallyVisible then
    Exit;
  APrevAlignHorz := AItem.AlignHorz;
  APrevCaption := AItem.Caption;
  try
    AItem.Container.BeginUpdate;
    try
      AItem.AlignHorz := ahLeft;
      AItem.Caption := '';
      AItem.Width := 0;
    finally
      AItem.Container.EndUpdate(False);
    end;
    ACaptionOptions := TdxLayoutLabeledItemCustomCaptionOptions(AItem.CaptionOptions);
    ACaptionOptions.Width :=
      Min(ACaptionOptions.Width, cxRectWidth(AItem.Parent.ViewInfo.ItemsAreaBounds));
  finally
    AItem.AlignHorz := APrevAlignHorz;
    AItem.Caption := APrevCaption;
  end;
end;

procedure TMailClientDemoBaseGridFrame.DoFrameResize;
begin
  lcMain.BeginUpdate;
  try
    LimitWidthByParent(liFrom);
    LimitWidthByParent(liDate);
  finally
    lcMain.EndUpdate;
  end;
end;

procedure TMailClientDemoBaseGridFrame.Translate;
begin
  cxbSearch.Caption := cxGetResourceString(@sSearch);
  cxbSearchClear.Caption := cxGetResourceString(@sClear);
end;

procedure TMailClientDemoBaseGridFrame.tvMainDataControllerDataChanged(Sender: TObject);
begin
  if IsActive then
    fmMailClientDemoMain.ItemsCountInfo.Caption := GetItemCountInfo;
end;

end.

