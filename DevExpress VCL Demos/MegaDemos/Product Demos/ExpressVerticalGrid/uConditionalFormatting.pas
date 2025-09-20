unit uConditionalFormatting;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uVertGridCustomMultiRecords, cxStyles, cxGraphics, cxEdit,
  cxImageComboBox, cxSpinEdit, cxBlobEdit, cxHyperLinkEdit, cxCurrencyEdit,
  cxImage, ImgList, cxVGrid, cxDBVGrid, cxControls, cxInplaceContainer,
  StdCtrls, ExtCtrls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxLabel, dxLayoutContainer, cxClasses, dxLayoutControl,
  dxLayoutControlAdapters, Menus, cxButtons, cxCheckBox, cxDataControllerConditionalFormattingRulesManagerDialog,
  dxScrollbarAnnotations, dxLayoutLookAndFeels, cxFilter;

type
  TfrmConditionalFormatting = class(TfrmCustomVertGridMultiRecords)
    btnManageRules: TcxButton;
    dxLayoutItem2: TdxLayoutItem;
    procedure btnManageRulesClick(Sender: TObject);
  protected
    function GetDescription: string; override;
  end;

implementation

uses
  cxDataControllerConditionalFormatting,
  maindata, dxFrames, FrameIDs, uStrsConst;

{$R *.dfm}

{ TfrmConditionalFormatting }

procedure TfrmConditionalFormatting.btnManageRulesClick(Sender: TObject);
begin
  inherited;
  cxDBVerticalGrid.ConditionalFormatting.ShowRulesManagerDialog;
end;

function TfrmConditionalFormatting.GetDescription: string;
begin
  Result := sdxFrameVeritcalGridConditionalFormatting;
end;

initialization
  dxFrameManager.RegisterFrame(VerticalGridConditionalFormattingFrameID, TfrmConditionalFormatting,
    VerticalGridConditionalFormattingName, VerticalGridConditionalFormattingImageIndex, NewAndHighlightedGroupIndex, -1);

end.
