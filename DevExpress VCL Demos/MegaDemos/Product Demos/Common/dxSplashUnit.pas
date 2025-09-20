unit dxSplashUnit;

{$I cxVer.inc}

interface

uses
{$IFDEF DELPHI16}
  System.UITypes,
{$ENDIF}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxControls, cxContainer, cxEdit, cxLabel, ExtCtrls, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  cxGroupBox, dxActivityIndicator, dxForms, cxImage, dxLayoutcxEditAdapters, cxClasses, dxLayoutLookAndFeels,
  dxLayoutContainer, dxLayoutControl;

type
  TfrmSplash = class(TdxForm)
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    llCaption: TdxLayoutLabeledItem;
    llProgress: TdxLayoutLabeledItem;
    dxLayoutImageItem1: TdxLayoutImageItem;
    dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup;
    dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList;
    dxLayoutSkinLookAndFeel1: TdxLayoutSkinLookAndFeel;
  end;

  procedure dxSetSplashVisibility(AVisible: Boolean; const AProgressCaption: string = ''); overload;
  procedure dxSetSplashVisibility(AVisible: Boolean; const ACaption, AProgressCaption: string); overload;
  procedure dxExecuteLongOperation(AProc: TProc; const ASplashCaption, ASplashProressCaption: string);

implementation

{$R *.dfm}

var
  dxSplash: TfrmSplash;

procedure dxSetSplashVisibility(AVisible: Boolean; const AProgressCaption: string = '');
begin
  dxSetSplashVisibility(AVisible, 'Loading Data. Please Wait.', AProgressCaption);
end;

procedure dxSetSplashVisibility(AVisible: Boolean; const ACaption, AProgressCaption: string);
var
  I: Integer;
begin
  if AVisible then
  begin
    if dxSplash = nil then
      dxSplash := TfrmSplash.Create(Application);
    dxSplash.llCaption.Caption := ACaption;
    dxSplash.llProgress.Caption := AProgressCaption;
    if Application.MainForm <> nil then
      for I := 0 to 1 do // because of per-monitor dpi support
      begin
        dxSplash.Left := Application.MainForm.Left + (Application.MainForm.Width - dxSplash.Width) div 2;
        dxSplash.Top := Application.MainForm.Top + (Application.MainForm.Height - dxSplash.Height) div 2;
      end;
    dxSplash.Show;
    dxSplash.Update;
  end
  else
    FreeAndNil(dxSplash);
end;

procedure dxExecuteLongOperation(AProc: TProc; const ASplashCaption, ASplashProressCaption: string);
begin
  dxSetSplashVisibility(True, ASplashCaption, ASplashProressCaption);
  try
    AProc;
  finally
    dxSetSplashVisibility(False);
  end;
end;

initialization
  dxSplash := nil;

end.
