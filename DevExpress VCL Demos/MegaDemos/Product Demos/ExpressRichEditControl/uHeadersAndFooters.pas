unit uHeadersAndFooters;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxRichEditFrame, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxCore, dxCoreClasses,
  dxGDIPlusAPI, dxGDIPlusClasses, dxRichEdit.Types, dxRichEdit.Options,
  dxRichEdit.Control, dxHttpIndyRequest, dxBarBuiltInMenu,
  dxRichEdit.Platform.Win.Control, cxLabel, ExtCtrls;

type
  TfrmRichEditHeadersAndFooters = class(TfrmRichEditFrame)
  protected
    function GetDescription: string; override;
    function GetStartDocumentName: string; override;
  end;

var
  frmRichEditHeadersAndFooters: TfrmRichEditHeadersAndFooters;

implementation

{$R *.dfm}

uses
  dxFrames, FrameIDs, uStrsConst;

{ TfrmRichEditHeadersAndFooters }

function TfrmRichEditHeadersAndFooters.GetDescription: string;
begin
  Result := sdxFrameHeadersAndFooters;
end;

function TfrmRichEditHeadersAndFooters.GetStartDocumentName: string;
begin
  Result := sdxHeadersAndFootersStartDocumentName;
end;

initialization
  dxFrameManager.RegisterFrame(RichEditHeadersAndFootersID, TfrmRichEditHeadersAndFooters,
    RichEditHeadersAndFootersFrameName, EditingFeaturesGroupIndex, -1, -1);

finalization

end.
