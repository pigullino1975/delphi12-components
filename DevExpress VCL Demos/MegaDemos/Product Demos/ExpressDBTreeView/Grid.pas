unit Grid;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, dxSkinsCore,
  cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, cxImageComboBox, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridLevel, cxClasses,
  cxGridCustomView, cxGrid;

type
  TGridForm = class(TForm)
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1Pr_id: TcxGridDBColumn;
    cxGrid1DBTableView1Pr_parent: TcxGridDBColumn;
    cxGrid1DBTableView1Pr_name: TcxGridDBColumn;
    cxGrid1DBTableView1Image: TcxGridDBColumn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GridForm: TGridForm;

implementation
uses Main;
{$R *.DFM}

procedure TGridForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   MainForm.btnGrid.Down := False;
end;

end.
