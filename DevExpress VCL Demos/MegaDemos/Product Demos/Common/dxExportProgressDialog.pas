unit dxExportProgressDialog;

{$I cxVer.inc}

interface

uses
{$IFDEF DELPHI16}
  System.UITypes,
{$ENDIF}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, cxExport, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxProgressBar, cxLabel, Menus, cxButtons,
  dxForms, dxLayoutcxEditAdapters, dxLayoutControlAdapters, dxLayoutContainer, cxClasses, dxLayoutControl, dxLayoutLookAndFeels;

type

  { TfrmExportProgress }

  TfrmExportProgress = class(TdxForm, IcxExportProgress)
    btnCancel: TcxButton;
    pbProgress: TcxProgressBar;
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    dxLayoutItem1: TdxLayoutItem;
    dxLayoutItem2: TdxLayoutItem;
    dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList;
    dxLayoutCxLookAndFeel1: TdxLayoutCxLookAndFeel;

    procedure btnCancelClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    // IcxExportProgress
    procedure OnProgress(Sender: TObject; Percent: Integer);
  end;

implementation

{$R *.dfm}

const
  sConfirmMessage = 'This will abort the export operation. Do you want to proceed?';

{ TfrmExportProgress }

procedure TfrmExportProgress.btnCancelClick(Sender: TObject);
begin
  if MessageDlg(sConfirmMessage, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    btnCancel.Enabled := False;
end;

procedure TfrmExportProgress.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  btnCancel.Click;
  CanClose := not btnCancel.Enabled;
end;

procedure TfrmExportProgress.OnProgress(Sender: TObject; Percent: Integer);
begin
  pbProgress.Position := Percent;
  Application.ProcessMessages;
  if not btnCancel.Enabled then
    Abort;
end;

end.
