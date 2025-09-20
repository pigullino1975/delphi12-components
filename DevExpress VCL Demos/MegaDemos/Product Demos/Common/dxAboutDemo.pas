unit dxAboutDemo;

{$I cxVer.inc}

interface

uses
{$IFDEF DELPHI16}
  System.UITypes,
{$ENDIF}
  Types, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ShellAPI, 
  dxCore, dxGDIPlusClasses, cxGraphics, cxClasses, dxForms, cxControls, cxLookAndFeels, dxBevel,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxImage, cxLabel, cxGeometry, dxDemoUtils, dxFramedControl, dxPanel;

type
  TdxAboutDemoForm = class(TdxForm)
    lbVersion: TcxLabel;
    pnBackground: TdxPanel;
    pnTopCaptions: TdxPanel;
    lbDemo: TcxLabel;
    pnCopyright: TdxPanel;
    lbCopyright: TcxLabel;
    lbUseFollowingLinks: TcxLabel;
    lbQuestions: TcxLabel;
    lbForDelphiAndCBuilder: TcxLabel;
    lbVCLSubscription: TcxLabel;
    pnButtons: TdxPanel;
    lbBtnSubscribe: TcxLabel;
    lbBtnDownloadTrial: TcxLabel;
    lbBtnLearnMore: TcxLabel;
    imgClose: TcxImage;
    pnlLinks: TdxPanel;
    lbSupportCenter: TcxLabel;
    lbOnlineDocumentation: TcxLabel;
    bvlCenter: TdxBevel;
    imgLogoDevExpress: TcxImage;

    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lbSupportCenterClick(Sender: TObject);
    procedure lbOnlineDocumentationClick(Sender: TObject);
    procedure lbBtnLearnMoreClick(Sender: TObject);
    procedure lbBtnDownloadTrialClick(Sender: TObject);
    procedure lbBtnSubscribeClick(Sender: TObject);
    procedure imgCloseMouseLeave(Sender: TObject);
    procedure imgCloseMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  private
    procedure CloseClickHandler(Sender: TObject);
    procedure SetImageClose(const ImageHover: Boolean);
    procedure Browse(const URL: string);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    // Messages
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
  public
    constructor Create(AOwner: TComponent); override;
  end;

procedure dxShowAboutForm;

implementation

{$R *.dfm}

const
  dxURLCommon = 'http://go.devexpress.com/DevExpress_AboutWin_%s.aspx';
  dxURLDownloadTrial = 'https://www.devexpress.com/Products/VCL/download-trial.xml';
  dxURLLearnMore = 'http://www.devexpress.com/Products/VCL/';
  dxURLOnlineDocumentation = 'http://docs.devexpress.com/VCL/';
  dxURLSubscribe = 'http://www.devexpress.com/Subscriptions/VCL/info.xml';

  SimgCloseSVG: string =
    '<?xml version="1.0" encoding="utf-8"?>'+
    '<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" '+
    'x="0px" y="0px" viewBox="0 0 32 32" enable-background="new 0 0 32 32" xml:space="preserve">'+
    '<style type="text/css"> .BackgroundColor{fill:#%COLOR%;}</style>'+
    '<path class="BackgroundColor" d="M19.1,16l6.6-6.6c0.4-0.4,0.4-1,0-1.4L24,6.3c-0.4-0.4-1-0.4-1.4,0L16,12.9L9.4,'+
    '6.3C9,5.9,8.4,5.9,8,6.3L6.3,8 c-0.4,0.4-0.4,1,0,1.4l6.6,6.6l-6.6,6.6c-0.4,0.4-0.4,1,0,1.4L8,25.7c0.4,0.4,1,0.4,'+
    '1.4,0l6.6-6.6l6.6,6.6c0.4,0.4,1,0.4,1.4,0 l1.7-1.7c0.4-0.4,0.4-1,0-1.4L19.1,16z"/>'+
    '</svg>';

  HHoverColors: array[Boolean]of Integer = ($727272, $3C3C3C);

procedure dxShowAboutForm;
begin
  with TdxAboutDemoForm.Create(nil) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

{ TdxAboutDemoForm }

constructor TdxAboutDemoForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetImageClose(False);
  imgClose.OnClick := CloseClickHandler;
  lbVersion.Caption := dxGetBuildNumberAsString;
  lbCopyright.Caption := Format('Copyright '#169' 2000-%d Developer Express Inc.', [DemoYear]) + #13#10 +
    'All Rights Reserved';
end;

procedure TdxAboutDemoForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  if IsWinXPOrLater then
    Params.WindowClass.Style := Params.WindowClass.Style or CS_DROPSHADOW;
end;

procedure TdxAboutDemoForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

procedure TdxAboutDemoForm.SetImageClose(const ImageHover: Boolean);
var
  ASVG: string;
begin
  ASVG := StringReplace(SimgCloseSVG, '%COLOR%', IntToHex(HHoverColors[ImageHover], -2), [rfReplaceAll, rfIgnoreCase]);
  TdxSmartImage(imgClose.Picture.Graphic).LoadFromFieldValue(ASVG);
end;

procedure TdxAboutDemoForm.imgCloseMouseLeave(Sender: TObject);
begin
  SetImageClose(False);
end;

procedure TdxAboutDemoForm.imgCloseMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  SetImageClose(True);
end;

procedure TdxAboutDemoForm.WMNCHitTest(var Message: TWMNCHitTest);
begin
  inherited;
  if ControlAtPos(ScreenToClient(SmallPointToPoint(Message.Pos)), False) = pnBackground then
    Message.Result := HTCAPTION;
end;

procedure TdxAboutDemoForm.Browse(const URL: string);
begin
  ShellExecute(Handle, 'open', PChar(URL), nil, nil, SW_SHOW);
end;

procedure TdxAboutDemoForm.lbBtnDownloadTrialClick(Sender: TObject);
begin
  Browse(dxURLDownloadTrial);
end;

procedure TdxAboutDemoForm.lbBtnLearnMoreClick(Sender: TObject);
begin
  Browse(dxURLLearnMore);
end;

procedure TdxAboutDemoForm.lbBtnSubscribeClick(Sender: TObject);
begin
  Browse(dxURLSubscribe);
end;

procedure TdxAboutDemoForm.lbOnlineDocumentationClick(Sender: TObject);
begin
  Browse(dxURLOnlineDocumentation);
end;

procedure TdxAboutDemoForm.lbSupportCenterClick(Sender: TObject);
begin
  Browse(Format(dxURLCommon, ['SC']));
end;

procedure TdxAboutDemoForm.CloseClickHandler(Sender: TObject);
begin
  Close;
end;

end.
