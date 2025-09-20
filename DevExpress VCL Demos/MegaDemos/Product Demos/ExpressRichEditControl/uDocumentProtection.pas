unit uDocumentProtection;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, dxRichEditFrame, cxGraphics, cxControls, cxLookAndFeels, dxRibbon,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxCore, dxCoreClasses,
  dxGDIPlusAPI, dxGDIPlusClasses, dxRichEdit.NativeApi, dxRichEdit.Types,
  dxRichEdit.Options, dxRichEdit.Control, dxRichEdit.Control.SpellChecker,
  dxRichEdit.Dialogs.EventArgs, dxHttpIndyRequest, dxBarBuiltInMenu,
  dxRichEdit.Platform.Win.Control, cxLabel, ExtCtrls, dxRichEdit.Control.Core, dxLayoutContainer, cxClasses,
  dxLayoutControl;

type
  TfrmRichEditDocumentProtection = class(TfrmRichEditFrame)
    pnlInfo: TPanel;
    lbAccess: TcxLabel;
    lbPermission: TcxLabel;
    procedure RichEditControlDocumentProtectionChanged(Sender: TObject);
  protected
    function GetDescription: string; override;
    function GetStartDocumentName: string; override;
  end;

var
  frmRichEditDocumentProtection: TfrmRichEditDocumentProtection;

implementation

{$R *.dfm}

uses
  dxFrames, FrameIDs, uStrsConst;

{ TfrmRichEditDocumentProtection }

function TfrmRichEditDocumentProtection.GetDescription: string;
begin
  Result := sdxFrameDocumentProtection;
end;

function TfrmRichEditDocumentProtection.GetStartDocumentName: string;
begin
  Result := sdxDocumentProtectionDocumentName;
end;

procedure TfrmRichEditDocumentProtection.RichEditControlDocumentProtectionChanged(
  Sender: TObject);
begin
  pnlInfo.Visible := RichEditControl.Document.IsDocumentProtected;
  RichEditControl.ClearUndo;
end;

initialization
  dxFrameManager.RegisterFrame(RichEditDocumentProtectionID, TfrmRichEditDocumentProtection,
    RichEditDocumentProtectionFrameName, HighlightFeaturesGroupIndex, DocumentManagementGroupIndex, -1);

end.
