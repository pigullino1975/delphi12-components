unit Find;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Db;

type
  TFindForm = class(TForm)
    SerachEdit: TEdit;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure SerachEditChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FindForm: TFindForm;

implementation
uses Main;
{$R *.DFM}

procedure TFindForm.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TFindForm.SerachEditChange(Sender: TObject);
begin
  MainForm.T1.Locate('Pr_Name',TEdit(Sender).Text,[loCaseInsensitive, loPartialKey]);
end;

procedure TFindForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   MainForm.btnFind.Down := False;
end;

end.
