unit FixedColumnsDemoMain;

{$I cxVer.inc}

interface

uses
  BaseForm, Classes, Controls, StdCtrls, Menus, ComCtrls, SysUtils, Forms, DB, DBClient,
  cxClasses, cxControls, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, dxDateRanges,
  dxScrollbarAnnotations, cxDBData, cxGridLevel, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, cxGridCardView, dxBar, cxGridPopupMenu,
  ExtCtrls, cxGroupBox, cxButtons, cxLabel, cxSpinEdit, cxImageComboBox, cxCheckBox, 
  dxColorDialog, ActnList;

type
  TfrmMain = class(TfmBaseForm)
    Grid: TcxGrid;
    tvTableView: TcxGridDBTableView;
    lvlLevel: TcxGridLevel;
    dsCustomers: TDataSource;
    cdsCustomers: TClientDataSet;
    cdsCustomersCompanyName: TStringField;
    cdsCustomersContactName: TStringField;
    cdsCustomersContactTitle: TStringField;
    cdsCustomersAddress: TStringField;
    cdsCustomersCity: TStringField;
    cdsCustomersPostalCode: TStringField;
    cdsCustomersCountry: TStringField;
    cdsCustomersPhone: TStringField;
    cdsCustomersFax: TStringField;
    cdsCustomersRegion: TStringField;
    tvTableViewCompanyName: TcxGridDBColumn;
    tvTableViewContactName: TcxGridDBColumn;
    tvTableViewContactTitle: TcxGridDBColumn;
    tvTableViewAddress: TcxGridDBColumn;
    tvTableViewCity: TcxGridDBColumn;
    tvTableViewPostalCode: TcxGridDBColumn;
    tvTableViewCountry: TcxGridDBColumn;
    tvTableViewPhone: TcxGridDBColumn;
    tvTableViewFax: TcxGridDBColumn;
    tvTableViewRegion: TcxGridDBColumn;
    ilImages: TcxImageList;
    gpmPopupMenu: TcxGridPopupMenu;
    gbOptions: TcxGroupBox;
    btnResetFixedColumnHightlightColor: TcxButton;
    pbFixedColumnOverlayColor: TPaintBox;
    seFixedSeparatorWidth: TcxSpinEdit;
    cbFixStyle: TcxImageComboBox;
    cbColumn: TcxImageComboBox;
    lblColumns: TcxLabel;
    lblFixStyle: TcxLabel;
    lblFixedSeparatorWidth: TcxLabel;
    cbHighlightFixedColumns: TcxCheckBox;
    lblFixedColumnHighlightColor: TcxLabel;
    cdFixedColumnOverlayColor: TdxColorDialog;
    pmHeaderPopup: TPopupMenu;
    pmiNotFixed: TMenuItem;
    pmiFixedLeft: TMenuItem;
    pmiFixedRight: TMenuItem;
    FixedLeftDynamic1: TMenuItem;
    acHeaderPopup: TActionList;
    acNotFixed: TAction;
    acFixedLeft: TAction;
    acFixedRight: TAction;
    acFixedDynamic: TAction;
    procedure FormCreate(Sender: TObject);
    procedure cbColumnPropertiesEditValueChanged(Sender: TObject);
    procedure cbFixStylePropertiesEditValueChanged(Sender: TObject);
    procedure seFixedSeparatorWidthPropertiesEditValueChanged(Sender: TObject);
    procedure cbHighlightFixedColumnsPropertiesEditValueChanged(Sender: TObject);
    procedure pbFixedColumnOverlayColorPaint(Sender: TObject);
    procedure pbFixedColumnOverlayColorClick(Sender: TObject);
    procedure btnResetFixedColumnHightlightColorClick(Sender: TObject);
    procedure acFixedClick(Sender: TObject);
    procedure gpmPopupMenuPopup(ASenderMenu: TComponent; AHitTest: TcxCustomGridHitTest; X, Y: Integer; var AllowPopup: Boolean);
  strict private
    FPopupColumn: TcxCustomGridColumn;

    function GetComboBoxColumn: TcxCustomGridColumn;
  protected
    procedure ChangeFixedKind(AColumn: TcxCustomGridColumn; AKind: TcxGridColumnFixedKind);
    procedure PopulateColumnComboBox;
    procedure PopulateSortedColumns(AList: TStringList);

    property ComboBoxColumn: TcxCustomGridColumn read GetComboBoxColumn;
    property PopupColumn: TcxCustomGridColumn read FPopupColumn;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  Types, Graphics, dxCoreGraphics, dxGDIPlusClasses, cxGeometry;

procedure TfrmMain.ChangeFixedKind(AColumn: TcxCustomGridColumn; AKind: TcxGridColumnFixedKind);
begin
  if AColumn.FixedKind <> AKind then
  begin
    case AKind of
      fkLeft:
        if tvTableView.VisibleColumnCountByFixedKind[fkLeft] > 0 then
          AColumn.Index := tvTableView.VisibleColumns[tvTableView.VisibleColumnCountByFixedKind[fkLeft] - 1].Index + 1
        else
          AColumn.Index := tvTableView.VisibleColumns[0].Index;
      fkRight:
        if tvTableView.VisibleColumnCountByFixedKind[fkRight] > 0 then
          AColumn.Index := tvTableView.VisibleColumns[tvTableView.VisibleColumnCount -
            tvTableView.VisibleColumnCountByFixedKind[fkRight]].Index - 1
        else
          AColumn.Index := tvTableView.VisibleColumns[tvTableView.VisibleColumnCount - 1].Index;
    end;
    AColumn.FixedKind := AKind;
  end;
end;

procedure TfrmMain.PopulateColumnComboBox;
var
  I: Integer;
  AList: TStringList;
  AItem: TcxImageComboBoxItem;
  AColumn: TcxCustomGridColumn;
begin
  AList := TStringList.Create;
  try
    PopulateSortedColumns(AList);
    for I := 0 to AList.Count - 1 do
    begin
      AItem := cbColumn.Properties.Items.Add;
      AItem.Value := I;
      AItem.Description := AList[I];
      AItem.Tag := NativeInt(AList.Objects[I]);
      AColumn := TcxCustomGridColumn(AItem.Tag);
      AItem.ImageIndex := AColumn.HeaderImageIndex;
      if AColumn.VisibleIndex = 0 then
        cbColumn.ItemIndex := I;
    end;
  finally
    AList.Free;
  end;
end;

procedure TfrmMain.PopulateSortedColumns(AList: TStringList);
var
  I: Integer;
begin
  for I := 0 to tvTableView.ColumnCount - 1 do
    AList.AddObject(tvTableView.Columns[I].Caption, tvTableView.Columns[I]);
  AList.Sort;
end;

function TfrmMain.GetComboBoxColumn: TcxCustomGridColumn;
var
  AItem: TcxImageComboBoxItem;
begin
  AItem := cbColumn.Properties.Items[cbColumn.ItemIndex];
  Result := TcxCustomGridColumn(AItem.Tag);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  APath: string;
begin
  APath := ExtractFilePath(Application.ExeName) + '..\..\Data\';
  cdsCustomers.LoadFromFile(APath + 'Customers2.xml');
  tvTableView.DataController.Groups.FullExpand;
  tvTableView.Controller.GoToFirst;
  PopulateColumnComboBox;
end;

procedure TfrmMain.cbColumnPropertiesEditValueChanged(Sender: TObject);
begin
  cbFixStyle.ItemIndex := Integer(ComboBoxColumn.FixedKind);
end;

procedure TfrmMain.cbFixStylePropertiesEditValueChanged(Sender: TObject);
begin
  ChangeFixedKind(ComboBoxColumn, TcxGridColumnFixedKind(cbFixStyle.ItemIndex));
end;

procedure TfrmMain.seFixedSeparatorWidthPropertiesEditValueChanged(Sender: TObject);
begin
  tvTableView.OptionsView.FixedColumnSeparatorWidth := seFixedSeparatorWidth.Value;
end;

procedure TfrmMain.cbHighlightFixedColumnsPropertiesEditValueChanged(Sender: TObject);
begin
  tvTableView.OptionsView.HighlightFixedColumns := cbHighlightFixedColumns.Checked;
end;

procedure TfrmMain.pbFixedColumnOverlayColorPaint(Sender: TObject);
const
  CellSize = 6;
var
  ARect: TRect;
  AColor: TColor;
  APaintBox: TPaintBox absolute Sender;
begin
  ARect := APaintBox.ClientRect;
  FrameRectByColor(APaintBox.Canvas.Handle, ARect, clWindowFrame);
  ARect := cxRectInflate(ARect, -1);
  cxDrawTransparencyCheckerboard(APaintBox.Canvas.Handle, ARect, CellSize);

  if (tvTableView.OptionsView.FixedColumnHighlightColor <> TdxAlphaColors.Default) and
    (tvTableView.OptionsView.FixedColumnHighlightColor <> TdxAlphaColors.Empty) then
  begin
    dxGPPaintCanvas.BeginPaint(APaintBox.Canvas.Handle, ARect);
    try
      AColor := dxAlphaColorToColor(tvTableView.OptionsView.FixedColumnHighlightColor);
      dxGPPaintCanvas.FillRectangle(ARect, dxColorToAlphaColor(AColor));
    finally
      dxGPPaintCanvas.EndPaint;
    end;
  end;
end;

procedure TfrmMain.pbFixedColumnOverlayColorClick(Sender: TObject);
const
  AAlpha = 40;
  ResetButtonIndent = 4;
var
  AColor: TColor;
  AWasButtonVisible: Boolean;
  APaintBox: TPaintBox absolute Sender;
begin
  cdFixedColumnOverlayColor.Color := tvTableView.OptionsView.FixedColumnHighlightColor;
  if cdFixedColumnOverlayColor.Execute then
  begin
    AColor := dxAlphaColorToColor(cdFixedColumnOverlayColor.Color);
    tvTableView.OptionsView.FixedColumnHighlightColor := dxColorToAlphaColor(AColor, AAlpha);
    AWasButtonVisible := btnResetFixedColumnHightlightColor.Visible;
    btnResetFixedColumnHightlightColor.Visible := (tvTableView.OptionsView.FixedColumnHighlightColor <> TdxAlphaColors.Default) and
      (tvTableView.OptionsView.FixedColumnHighlightColor <> TdxAlphaColors.Empty);
    if not AWasButtonVisible and btnResetFixedColumnHightlightColor.Visible then
      APaintBox.Width := APaintBox.Width - btnResetFixedColumnHightlightColor.Width - ResetButtonIndent;
    APaintBox.Invalidate;
  end;
end;

procedure TfrmMain.btnResetFixedColumnHightlightColorClick(Sender: TObject);
var
  AButton: TcxButton absolute Sender;
begin
  tvTableView.OptionsView.FixedColumnHighlightColor := TdxAlphaColors.Default;
  btnResetFixedColumnHightlightColor.Visible := False;
  pbFixedColumnOverlayColor.Width := cbColumn.Width;
  pbFixedColumnOverlayColor.Invalidate;
end;

procedure TfrmMain.acFixedClick(Sender: TObject);
var
  AButton: TAction absolute Sender;
begin
  ChangeFixedKind(PopupColumn, TcxGridColumnFixedKind(AButton.Tag));
end;

procedure TfrmMain.gpmPopupMenuPopup(ASenderMenu: TComponent; AHitTest: TcxCustomGridHitTest;
  X, Y: Integer; var AllowPopup: Boolean);
var
  AIndex: Integer;
begin
  if AHitTest.HitTestCode = htColumnHeader then
  begin
    FPopupColumn := TcxGridColumnHeaderHitTest(AHitTest).Column;
    AIndex := Integer(PopupColumn.FixedKind);
    TAction(acHeaderPopup.Actions[AIndex]).Checked := True;
  end;
end;

end.

