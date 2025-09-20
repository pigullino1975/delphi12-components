unit UnboundModeDemoCustomField;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, cxButtons, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, Menus, cxLabel;

type
  TUnboundModeDemoCustomFieldForm = class(TForm)
    lbHeight: TcxLabel;
    lbWidth: TcxLabel;
    lbMineCount: TcxLabel;
    edtHeight: TEdit;
    edtWidth: TEdit;
    edtMineCount: TEdit;
    btnOK: TcxButton;
    bntCancel: TcxButton;
    procedure edtKeyPress(Sender: TObject; var Key: Char);
    procedure bntCancelClick(Sender: TObject);
  public
    function ShowModal: Integer; override;
  end;

implementation

uses UnboundModeDemoTypes;

{$R *.DFM}

function TUnboundModeDemoCustomFieldForm.ShowModal: Integer;
begin
  SetFormPosition(Self, 25, 25);
  Result := inherited ShowModal;
end;

procedure TUnboundModeDemoCustomFieldForm.edtKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Key < '0') or ('9' < Key) then
    Key := Char(7);
end;

procedure TUnboundModeDemoCustomFieldForm.bntCancelClick(Sender: TObject);
begin
  Close;
end;

end.
