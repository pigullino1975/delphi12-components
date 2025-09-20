unit MailCloseDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, Menus, StdCtrls, cxButtons, cxLabel, ExtCtrls,
  dxLayoutControlAdapters, dxLayoutcxEditAdapters, dxLayoutLookAndFeels,
  dxLayoutContainer, dxLayoutControl, dxCore, dxForms, cxClasses;

type
  TfmMailCloseDialog = class(TdxForm)
    dxLayoutControl1: TdxLayoutControl;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    cxButton3: TcxButton;
    cxLabel1: TcxLabel;
    dxLayoutGroup1: TdxLayoutGroup;
    dxLayoutItem1: TdxLayoutItem;
    dxLayoutControl1Item2: TdxLayoutItem;
    dxLayoutControl1Item3: TdxLayoutItem;
    dxLayoutControl1Item4: TdxLayoutItem;
    dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList;
    dxLayoutSkinLookAndFeel1: TdxLayoutSkinLookAndFeel;
    procedure FormShow(Sender: TObject);
  private
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    { Private declarations }
  public
    { Public declarations }
  end;

function ShowCloseDialog(AOwner: TForm): Integer;

implementation

{$R *.dfm}

function ShowCloseDialog(AOwner: TForm): Integer;
var
  AfmMailCloseDialog: TfmMailCloseDialog;
begin
  AfmMailCloseDialog := TfmMailCloseDialog.Create(AOwner);
  try
    Result := AfmMailCloseDialog.ShowModal;
  finally
    AfmMailCloseDialog.Release;
  end;
end;

procedure TfmMailCloseDialog.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.WndParent := TForm(Owner).Handle;
end;

procedure TfmMailCloseDialog.FormShow(Sender: TObject);
begin
  cxButton1.LookAndFeel.NativeStyle := IsWinVistaOrLater;
  cxButton2.LookAndFeel.NativeStyle := IsWinVistaOrLater;
  cxButton3.LookAndFeel.NativeStyle := IsWinVistaOrLater;
end;

end.
