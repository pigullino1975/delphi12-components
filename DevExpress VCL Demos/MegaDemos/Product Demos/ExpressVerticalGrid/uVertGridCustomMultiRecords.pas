unit uVertGridCustomMultiRecords;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxVertGridFrame, cxStyles, cxGraphics, cxEdit, cxSpinEdit,
  cxBlobEdit, cxHyperLinkEdit, cxCurrencyEdit, cxImage, cxVGrid, cxDBVGrid,
  cxControls, cxInplaceContainer, StdCtrls, ExtCtrls, cxDropDownEdit,
  ImgList, cxImageComboBox, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxLabel, dxLayoutContainer, cxClasses, dxLayoutControl, cxImageList, dxScrollbarAnnotations, dxLayoutLookAndFeels,
  cxFilter;

type
  TfrmCustomVertGridMultiRecords = class(TVerticalGridFrame)
    dxLayoutItem1: TdxLayoutItem;
    cxDBVerticalGrid: TcxDBVerticalGrid;
    cxDBVerticalGridID: TcxDBMultiEditorRow;
    fldTrademark: TcxDBEditorRow;
    fldModel: TcxDBEditorRow;
    fldCategory: TcxDBEditorRow;
    rowPerformance_Attributes: TcxCategoryRow;
    fldHP: TcxDBEditorRow;
    fldLiter: TcxDBEditorRow;
    fldCyl: TcxDBEditorRow;
    fldTransmissSpeedCount: TcxDBEditorRow;
    fldTransmissAutomatic: TcxDBEditorRow;
    cxDBVerticalGrid1DBMultiEditorRow1: TcxDBMultiEditorRow;
    rowNotes: TcxCategoryRow;
    fldDescription: TcxDBEditorRow;
    fldHyperlink: TcxDBEditorRow;
    rowOthers: TcxCategoryRow;
    fldPrice: TcxDBEditorRow;
    fldIcon: TcxDBEditorRow;
    fldPicture: TcxDBEditorRow;
  public
    function HasOptions: Boolean; override;
  end;

implementation

uses
  maindata;

{$R *.dfm}


{ TfrmCustomVertGridMultiRecords }

function TfrmCustomVertGridMultiRecords.HasOptions: Boolean;
begin
  Result := False;
end;

end.
