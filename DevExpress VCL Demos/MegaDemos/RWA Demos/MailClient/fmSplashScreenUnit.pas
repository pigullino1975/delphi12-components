unit fmSplashScreenUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls,
  dxGDIPlusClasses, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxProgressBar,
  cxLabel, dxForms, cxImage, dxSkinsCore, dxCore, cxGeometry, dxFramedControl, dxPanel, dxDemoUtils;

type
  TfmSplashScreen = class(TdxForm)
    imLogoCompany: TcxImage;
    cxlbInitializeMessage: TcxLabel;
    cxlbCopyRightYears: TcxLabel;
    pnClient: TdxPanel;
    cxlbAppName: TcxLabel;
    pnLogoArea: TdxPanel;
    imLogoApplication: TcxImage;
    cxlbAppComent: TcxLabel;
  protected
    procedure CreateWindowHandle(const Params: TCreateParams); override;
  public
    class procedure BeginLoading;
    class procedure EndLoading;
  end;

implementation

{$R *.dfm}

uses DateUtils, LocalizationStrs;

var
  FSplashScreen: TfmSplashScreen;

{ TfmSplashScreen }

class procedure TfmSplashScreen.BeginLoading;
begin
  if FSplashScreen = nil then
  begin
    FSplashScreen := TfmSplashScreen.Create(nil);
    FSplashScreen.cxlbInitializeMessage.Caption := cxGetResourceString(@sSplashScreenInitializeMessage);
    FSplashScreen.cxlbInitializeMessage.Style.Font.Color := RGB(59, 59, 59);
    FSplashScreen.cxlbCopyRightYears.Style.Font.Color := RGB(59, 59, 59);
    FSplashScreen.cxlbCopyRightYears.Caption := Format('Copyright © 1998-%d', [DemoYear]);
    FSplashScreen.Show;
    FSplashScreen.Update;
  end;
end;

procedure TfmSplashScreen.CreateWindowHandle(const Params: TCreateParams);
begin
  inherited;
  SetWindowLong(Handle, GWL_STYLE, 0);
end;

class procedure TfmSplashScreen.EndLoading;
begin
  FreeAndNil(FSplashScreen);
end;

end.
