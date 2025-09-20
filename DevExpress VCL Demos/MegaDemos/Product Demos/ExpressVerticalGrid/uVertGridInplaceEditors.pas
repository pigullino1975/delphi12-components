unit uVertGridInplaceEditors;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxVertGridFrame, StdCtrls, ExtCtrls, cxStyles, cxGraphics,
  cxEdit, cxControls, cxInplaceContainer, cxVGrid,
  cxExtEditRepositoryItems, cxShellEditRepositoryItems,
  cxEditRepositoryItems, cxDBEditRepository, PropertiesPopup,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxLabel,
  cxClasses, dxLayoutContainer, dxLayoutControl, dxScrollbarAnnotations, dxLayoutLookAndFeels,
  cxFilter, dxSkinsCore;

type
  TfrmVertGridInplaceEditors = class(TVerticalGridFrame)
    EditRepository: TcxEditRepository;
    EditRepositoryBlobItem: TcxEditRepositoryBlobItem;
    EditRepositoryButtonItem: TcxEditRepositoryButtonItem;
    EditRepositoryCalcItem: TcxEditRepositoryCalcItem;
    EditRepositoryCheckBoxItem: TcxEditRepositoryCheckBoxItem;
    EditRepositoryComboBoxItem: TcxEditRepositoryComboBoxItem;
    EditRepositoryCurrencyItem: TcxEditRepositoryCurrencyItem;
    EditRepositoryDateItem: TcxEditRepositoryDateItem;
    EditRepositoryHyperLinkItem: TcxEditRepositoryHyperLinkItem;
    EditRepositoryImageItem: TcxEditRepositoryImageItem;
    EditRepositoryImageComboBoxItem: TcxEditRepositoryImageComboBoxItem;
    EditRepositoryLookupComboBoxItem: TcxEditRepositoryLookupComboBoxItem;
    EditRepositoryMaskItem: TcxEditRepositoryMaskItem;
    EditRepositoryMemoItem: TcxEditRepositoryMemoItem;
    EditRepositoryMRUItem: TcxEditRepositoryMRUItem;
    EditRepositoryPopupItem: TcxEditRepositoryPopupItem;
    EditRepositoryRadioGroupItem: TcxEditRepositoryRadioGroupItem;
    EditRepositorySpinItem: TcxEditRepositorySpinItem;
    EditRepositoryTextItem: TcxEditRepositoryTextItem;
    EditRepositoryTimeItem: TcxEditRepositoryTimeItem;
    EditRepositoryProgressBar: TcxEditRepositoryProgressBar;
    EditRepositoryShellComboBoxItem: TcxEditRepositoryShellComboBoxItem;
    EditRepositoryTrackBar: TcxEditRepositoryTrackBar;
    EditRepositoryColorComboBox: TcxEditRepositoryColorComboBox;
    EditRepositoryFontNameComboBox: TcxEditRepositoryFontNameComboBox;
    EditRepositoryLabel: TcxEditRepositoryLabel;
    cxStyleRepository1: TcxStyleRepository;
    cxStyle1: TcxStyle;
    dxLayoutItem1: TdxLayoutItem;
    VerticalGrid: TcxVerticalGrid;
    VerticalGridCategoryRow1: TcxCategoryRow;
    vgButtonEditor: TcxEditorRow;
    vgCheckBoxEditor: TcxEditorRow;
    vgCurrencyEditor: TcxEditorRow;
    vgMaskEditor: TcxEditorRow;
    vgRadioGroupEditor: TcxEditorRow;
    vgSpintEditor: TcxEditorRow;
    vgTextEditor: TcxEditorRow;
    vgTimeEditor: TcxEditorRow;
    VerticalGridCategoryRow2: TcxCategoryRow;
    vgComboBoxEditor: TcxEditorRow;
    vgHyperLinkEditor: TcxEditorRow;
    vgImageComboBoxEditor: TcxEditorRow;
    vgLookupComboBoxEditor: TcxEditorRow;
    vgMRUEditor: TcxEditorRow;
    VerticalGridCategoryRow3: TcxCategoryRow;
    vgBlobEditor: TcxEditorRow;
    vgImageEditor: TcxEditorRow;
    vgMemoEditor: TcxEditorRow;
    VerticalGridCategoryRow4: TcxCategoryRow;
    vgCalcEditor: TcxEditorRow;
    vgDateEditor: TcxEditorRow;
    vgPopupEditor: TcxEditorRow;
    VerticalGridCategoryRow5: TcxCategoryRow;
    vgProgressBarEditor: TcxEditorRow;
    vgShellComboBoxEditor: TcxEditorRow;
    vgTrackBarEditor: TcxEditorRow;
    vgColorComboBoxEditor: TcxEditorRow;
    vgFontComboBoxEditor: TcxEditorRow;
    vgLabel: TcxEditorRow;
    procedure EditRepositoryButtonItemPropertiesButtonClick(
      Sender: TObject; AButtonIndex: Integer);
    procedure EditRepositoryPopupItemPropertiesInitPopup(Sender: TObject);
    procedure vgProgressBarEditorPropertiesGetEditingProperties(
      Sender: TcxCustomEditorRowProperties; ARecordIndex: Integer;
      var AProperties: TcxCustomEditProperties);
  private
    fmPopupTree: TfmPopupTree;
  protected
    function GetDescription: string; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function HasOptions: Boolean; override;
  end;

implementation

uses
  maindata, dxFrames, FrameIDs, cxDropDownEdit, uStrsConst;

{$R *.dfm}

{ TfrmVertGridInplaceEditors }

constructor TfrmVertGridInplaceEditors.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fmPopupTree := TfmPopupTree.Create(nil);
  EditRepositoryPopupItem.Properties.PopupControl := fmPopupTree.pnPopupControl;

  vgLookupComboBoxEditor.Properties.Value := dmmain.atDXProducts.FindField('ID').AsInteger;
  vgImageEditor.Properties.Value :=  dmMain.mdModels.FindField('Photo').Value;
  vgMemoEditor.Properties.Value := dmMain.mdModels.FindField('Description').Value;
  vgTimeEditor.Properties.Value := Now;
  vgDateEditor.Properties.Value := Date;
  vgColorComboBoxEditor.Properties.Value := clBlue;
  vgFontComboBoxEditor.Properties.Value := 'Arial';
  vgShellComboBoxEditor.Properties.Value := 'My Computer';
  VerticalGrid.LayoutStyle := ulsBandsView;
end;

destructor TfrmVertGridInplaceEditors.Destroy;
begin
  fmPopupTree.Free;
  inherited Destroy;
end;

function TfrmVertGridInplaceEditors.HasOptions: Boolean;
begin
  Result := False;
end;

procedure TfrmVertGridInplaceEditors.EditRepositoryButtonItemPropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  ShowMessage('This button can call your own code.');
end;

procedure TfrmVertGridInplaceEditors.EditRepositoryPopupItemPropertiesInitPopup(
  Sender: TObject);
begin
  fmPopupTree.PopupEdit := TcxPopupEdit(Sender);
end;

function TfrmVertGridInplaceEditors.GetDescription: string;
begin
  Result := sdxFrameVerticalGridInplaceEditors;
end;

procedure TfrmVertGridInplaceEditors.vgProgressBarEditorPropertiesGetEditingProperties(
  Sender: TcxCustomEditorRowProperties; ARecordIndex: Integer;
  var AProperties: TcxCustomEditProperties);
begin
  AProperties := EditRepositorySpinItem.Properties;

end;

initialization
  dxFrameManager.RegisterFrame(VerticalGridInplaceEditorsFrameID, TfrmVertGridInplaceEditors,
    VerticalGridInplaceEditorsName, VerticalGridInplaceEditorsImageIndex, -1, VerticalGridSideBarGroupIndex);


end.
