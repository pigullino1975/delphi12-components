unit cxTreeListConditionalFormattingUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, cxTreeListCarsFormUnit, Menus,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxCustomData, cxStyles, cxTL, cxMaskEdit, StdCtrls,
  cxCurrencyEdit, cxDropDownEdit, cxCheckBox, cxSpinEdit, cxBlobEdit, dxLayoutContainer, ActnList, cxClasses,
  dxLayoutLookAndFeels, cxInplaceContainer, cxDBTL, cxTLData, dxLayoutControl, dxLayoutControlAdapters, cxButtons,
  cxDataControllerConditionalFormattingRulesManagerDialog, cxTLdxBarBuiltInMenu,
  dxScrollbarAnnotations, System.Actions, cxFilter;

type
  TfrmConditionalFormatting = class(TfrmCars)
    btnManageRules: TcxButton;
    dxLayoutItem2: TdxLayoutItem;
    procedure btnManageRulesClick(Sender: TObject);
  public
    function HasOptions: Boolean; override;
    procedure FrameActivated; override;
    class function GetID: Integer; override;
  end;

implementation

{$R *.dfm}

{ TfrmConditionalFormatting }

procedure TfrmConditionalFormatting.FrameActivated;
begin
  inherited;
  TreeList.FullExpand;
end;

function TfrmConditionalFormatting.HasOptions: Boolean;
begin
  Result := True;
end;

class function TfrmConditionalFormatting.GetID: Integer;
begin
  Result := 55;
end;

procedure TfrmConditionalFormatting.btnManageRulesClick(Sender: TObject);
begin
  TreeList.ConditionalFormatting.ShowRulesManagerDialog;
end;

initialization
  TfrmConditionalFormatting.Register;
end.
