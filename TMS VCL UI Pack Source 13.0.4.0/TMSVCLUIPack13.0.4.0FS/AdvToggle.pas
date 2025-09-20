{**************************************************************************}
{ TAdvToggleSwitch                                                         }
{ for Delphi & C++Builder                                                  }
{                                                                          }
{ written                                                                  }
{   TMS Software                                                           }
{   copyright © 2023                                                       }
{   Email : info@tmssoftware.com                                           }
{   Web : http://www.tmssoftware.com                                       }
{                                                                          }
{ The source code is given as is. The author is not responsible            }
{ for any possible damage done due to the use of this code.                }
{ The component can be freely used in any application. The complete        }
{ source code remains property of the author and may not be distributed,   }
{ published, given or sold in any form as such. No parts of the source     }
{ code can be included in any other component or application without       }
{ written authorization of the author.                                     }
{**************************************************************************}

unit AdvToggle;

interface

uses
  Classes, Graphics, AdvGDIP, Types, Windows, Controls, ExtCtrls, SysUtils;

const
  MAJ_VER = 1; // Major version nr.
  MIN_VER = 0; // Minor version nr.
  REL_VER = 0; // Release nr.
  BLD_VER = 1; // Build nr.

  // version history
  // v1.0.0.0 : First release
  // v1.0.0.1 : Fixed : Issue with Shadow property persisting


type
  TToggleSwitchSettings = class(TPersistent)
  private
    FCaptionFont: TFont;
    FButtonOff: TColor;
    FButtonBorderOn: TColor;
    FButtonBorderWidth: single;
    FRounded: boolean;
    FDelta: integer;
    FBackgroundOff: TColor;
    FBackgroundBorderOn: TColor;
    FCaptionOff: string;
    FBackgroundBorderWidth: single;
    FButtonOn: TColor;
    FButtonBorderOff: TColor;
    FBackgroundOn: TColor;
    FCaptionOn: string;
    FBackgroundBorderOff: TColor;
    FBackgroundHeightPerc: integer;
    FShadow: boolean;
    procedure SetCaptionFont(const Value: TFont);
  protected
    property Delta: integer read FDelta write FDelta;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property BackgroundOn: TColor read FBackgroundOn write FBackgroundOn default clLime;
    property BackgroundBorderOn: TColor read FBackgroundBorderOn write FBackgroundBorderOn default clNone;
    property BackgroundBorderWidth: single read FBackgroundBorderWidth write FBackgroundBorderWidth;
    property BackgroundOff: TColor read FBackgroundOff write FBackgroundOff default clSilver;
    property BackgroundBorderOff: TColor read FBackgroundBorderOff write FBackgroundBorderOff default clNone;
    property BackgroundHeightPerc: integer read FBackgroundHeightPerc write FBackgroundHeightPerc default 100;
    property ButtonOn: TColor read FButtonOn write FButtonOn default clWhite;
    property ButtonOff: TColor read FButtonOff write FButtonOff default clWhite;
    property ButtonBorderOn: TColor read FButtonBorderOn write FButtonBorderOn default clNone;
    property ButtonBorderOff: TColor read FButtonBorderOff write FButtonBorderOff default clNone;
    property ButtonBorderWidth: single read FButtonBorderWidth write FButtonBorderWidth;
    property CaptionOn: string read FCaptionOn write FCaptionOn;
    property CaptionOff: string read FCaptionOff write FCaptionOff;
    property CaptionFont: TFont read FCaptionFont write SetCaptionFont;
    property Rounded: boolean read FRounded write FRounded default true;
    property Shadow: boolean read FShadow write FShadow default true;
  end;

  TAdvToggleSwitch = class(TCustomControl)
  private
    FOn: boolean;
    FTimer: TTimer;
    FTransition: integer;
    FAnimated: boolean;
    FButtonOff: TColor;
    FBackgroundOff: TColor;
    FButtonOn: TColor;
    FBackgroundOn: TColor;
    FCaptionOff: string;
    FCaptionOn: string;
    FRounded: boolean;
    FShowFocus: boolean;
    FOnToggle: TNotifyEvent;
    FBackgroundOffBorder: TColor;
    FBackgroundBorderWidth: single;
    FBackgroundOnBorder: TColor;
    FButtonOnBorder: TColor;
    FButtonOffBorder: TColor;
    FButtonBorderWidth: single;
    FBackgroundHeightPerc: integer;
    FShadow: boolean;
    procedure SetBackgroundOff(const Value: TColor);
    procedure SetBackgroundOn(const Value: TColor);
    procedure SetButtonOff(const Value: TColor);
    procedure SetButtonOn(const Value: TColor);
    procedure SetCaptionOff(const Value: string);
    procedure SetCaptionOn(const Value: string);
    procedure SetOn(const Value: boolean);
    procedure SetRounded(const Value: boolean);
    procedure SetBackgroundBorderWidth(const Value: single);
    procedure SetBackgroundOffBorder(const Value: TColor);
    procedure SetBackgroundOnBorder(const Value: TColor);
    procedure SetButtonOffBorder(const Value: TColor);
    procedure SetButtonOnBorder(const Value: TColor);
    procedure SetButtonBorderWidth(const Value: single);
    procedure SetBackgroundHeightPerc(const Value: integer);
    procedure SetShadow(const Value: boolean);
    function GetVersion: string;
    procedure SetVersion(const Value: string);
  protected
    procedure Paint; override;
    procedure Click; override;
    procedure HandleTimer(Sender: TObject);
    procedure StartToggle; virtual;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure DoToggle; virtual;
    procedure KeyPress(var Key: Char); override;
    function GetVersionNr: Integer; virtual;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align;
    property AlignWithMargins;
    property Anchors;
    property Animated: boolean read FAnimated write FAnimated default false;
    property BackgroundOn: TColor read FBackgroundOn write SetBackgroundOn default clLime;
    property BackgroundOff: TColor read FBackgroundOff write SetBackgroundOff default clSilver;
    property BackgroundOnBorder: TColor read FBackgroundOnBorder write SetBackgroundOnBorder default clNone;
    property BackgroundOffBorder: TColor read FBackgroundOffBorder write SetBackgroundOffBorder default clNone;
    property BackgroundBorderWidth: single read FBackgroundBorderWidth write SetBackgroundBorderWidth;
    property BackgroundHeightPerc: integer read FBackgroundHeightPerc write SetBackgroundHeightPerc default 100;
    property ButtonOn: TColor read FButtonOn write SetButtonOn default clWhite;
    property ButtonOff: TColor read FButtonOff write SetButtonOff default clWhite;
    property ButtonOnBorder: TColor read FButtonOnBorder write SetButtonOnBorder default clNone;
    property ButtonOffBorder: TColor read FButtonOffBorder write SetButtonOffBorder default clNone;
    property ButtonBorderWidth: single read FButtonBorderWidth write SetButtonBorderWidth;
    property CaptionOn: string read FCaptionOn write SetCaptionOn;
    property CaptionOff: string read FCaptionOff write SetCaptionOff;
    property DoubleBuffered default true;
    property Font;
    property Margins;
    property &On: boolean read FOn write SetOn;
    property Padding;
    property Rounded: boolean read FRounded write SetRounded default true;
    property Shadow: boolean read FShadow write SetShadow default true;
    property ShowFocus: boolean read FShowFocus write FShowFocus default true;
    property ShowHint;
    property TabStop default true;
    property TabOrder;
    property Version: string read GetVersion write SetVersion;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDragOver;
    property OnDragDrop;
    property OnEndDrag;
    property OnEndDock;
    property OnEnter;
    property OnExit;
    property OnStartDock;
    property OnStartDrag;
    property OnToggle: TNotifyEvent read FOnToggle write FOnToggle;
  end;


procedure DrawToggle(ACanvas: TCanvas; ARect: TRect; AState: boolean; ASettings: TToggleSwitchSettings);

implementation

procedure DrawButton(gp: TGPGraphics; ARect: TRect; AState: boolean; var radius, d: integer; ASettings: TToggleSwitchSettings; Shadow: boolean = false);
const
  ShadowColor: TColor = $A0A0A0;
var
  b: TGPBrush;
  s: TGPPen;
  r: TRect;
  p: TGPGraphicsPath;

begin
  if AState then
  begin
    if Shadow then
      b := TGPSolidBrush.Create(ColorToARGB(ShadowColor))
    else
      b := TGPSolidBrush.Create(ColorToARGB(ASettings.ButtonOn));

    if ASettings.Rounded then
    begin
      gp.FillEllipse(b, ARect.Right - 2 * radius - d, ARect.Top, 2 * radius, 2 * radius);

      if (ASettings.ButtonBorderWidth > 0) and (ASettings.ButtonBorderOn <> clNone) and not Shadow then
      begin
        s := TGPPen.Create(ColorToARGB(ASettings.ButtonBorderOn), ASettings.ButtonBorderWidth);
        gp.DrawEllipse(s, ARect.Right - 2 * radius - d, ARect.Top, 2 * radius, 2 * radius);
        s.Free;
      end;
    end
    else
    begin
      r := Rect(ARect.Right - 2 - (ARect.Bottom - ARect.Top - 4) - d, ARect.Top + 2, ARect.Right - 2 - d, ARect.Bottom - 2);
      p := CreateRoundRectangle(r, 2);
      gp.FillPath(b, p);

      if (ASettings.ButtonBorderWidth > 0) and (ASettings.ButtonBorderOn <> clNone) and not Shadow then
      begin
        s := TGPPen.Create(ColorToARGB(ASettings.ButtonBorderOn), ASettings.ButtonBorderWidth);
        gp.DrawPath(s, p);
        s.Free;
      end;

      p.Free;
      radius := (ARect.Bottom - ARect.Top - 4) div 2;
    end;
  end
  else
  begin
    if Shadow then
      b := TGPSolidBrush.Create(ColorToARGB(ShadowColor))
    else
      b := TGPSolidBrush.Create(ColorToARGB(ASettings.ButtonOff));

    if ASettings.Rounded then
    begin
      gp.FillEllipse(b, ARect.Left + d, ARect.Top, 2 * radius, 2 * radius);

      if (ASettings.ButtonBorderWidth > 0) and (ASettings.ButtonBorderOff <> clNone) and not Shadow then
      begin
        s := TGPPen.Create(ColorToARGB(ASettings.ButtonBorderOff), ASettings.ButtonBorderWidth);
        gp.DrawEllipse(s, ARect.Left + d, ARect.Top, 2 * radius, 2 * radius);
        s.Free;
      end;

    end
    else
    begin
      r := Rect(ARect.Left + 2 + d, ARect.Top + 2, ARect.Left + 2 + ARect.Bottom - ARect.Top - 4 + d, ARect.Bottom - 2);
      p := CreateRoundRectangle(r, 2);
      gp.FillPath(b, p);
      if (ASettings.ButtonBorderWidth > 0) and (ASettings.ButtonBorderOff <> clNone) and not Shadow then
      begin
        s := TGPPen.Create(ColorToARGB(ASettings.ButtonBorderOff), ASettings.ButtonBorderWidth);
        gp.DrawPath(s, p);
        s.Free;
      end;
      p.Free;
      radius := (ARect.Bottom - ARect.Top - 4) div 2;
    end;
  end;

  b.Free;
end;


procedure DrawToggle(ACanvas: TCanvas; ARect: TRect; AState: boolean; ASettings: TToggleSwitchSettings);
var
  gp: TGPGraphics;
  p: TGPGraphicsPath;
  b: TGPBrush;
  s: TGPPen;
  radius: integer;
  r,bg: TRect;
  h,w,d,bgh: integer;

begin
  gp := TGPGraphics.Create(ACanvas.Handle);

  try
    bg := ARect;

    if ASettings.BackgroundHeightPerc <> 100 then
    begin
      bgh := Round( (ARect.Bottom - ARect.Top) * ASettings.BackgroundHeightPerc/100);

      bgh := ((ARect.Bottom - ARect.Top) - bgh) div 2;

      bg.Top := ARect.Top + bgh;
      bg.Bottom := ARect.Bottom - bgh;
    end;

    if ASettings.Rounded then
      radius := (bg.Bottom - bg.Top) div 2
    else
      radius := 2;

    p := CreateRoundRectangle(bg, radius);

    if AState then
      b := TGPSolidBrush.Create(ColorToARGB(ASettings.BackgroundOn))
    else
      b := TGPSolidBrush.Create(ColorToARGB(ASettings.BackgroundOff));

    gp.SetSmoothingMode(SmoothingModeAntiAlias);
    gp.FillPath(b, p);

    if AState then
    begin
      if (ASettings.BackgroundBorderWidth > 0) and (ASettings.BackgroundBorderOn <> clNone) then
      begin
        s := TGPPen.Create(ColorToARGB(ASettings.BackgroundBorderOn), ASettings.BackgroundBorderWidth);
        gp.DrawPath(s, p);
        s.Free;
      end;
    end
    else
    begin
      if (ASettings.BackgroundBorderWidth > 0) and (ASettings.BackgroundBorderOff <> clNone) then
      begin
        s := TGPPen.Create(ColorToARGB(ASettings.BackgroundBorderOff), ASettings.BackgroundBorderWidth);
        gp.DrawPath(s, p);
        s.Free;
      end;
    end;

    p.Free;
    b.Free;

    if ASettings.Rounded then
      radius := (ARect.Bottom - ARect.Top) div 2
    else
      radius := 2;

    d := Round(ASettings.Delta / 100 * ((ARect.Right - ARect.Left) - (ARect.Bottom - ARect.Top)) );

    if ASettings.Shadow then
    begin
      DrawButton(gp, ARect, AState, radius, d, ASettings, true);

      radius := radius - 1;
      ARect.Bottom := ARect.Bottom - 1;
      ARect.Left := ARect.Left + 1;
    end;

    DrawButton(gp, ARect, AState, radius, d, ASettings);

    h := gp.TextHeight('gh', ASettings.CaptionFont);
    h := ((ARect.Bottom - ARect.Top) - h) div 2;

    if (ASettings.CaptionOn <> '') and AState then
    begin
      w := gp.TextWidth(ASettings.CaptionOn, ASettings.CaptionFont);
      if (w < ARect.Right - ARect.Left - 2 * radius) then
        w := (ARect.Right - ARect.Left - 2 * radius - w) div 2
      else
        w := 0;

      r := Rect(ARect.Left + w, ARect.Top + h, ARect.Right - 2 * radius, ARect.Bottom);
      gp.DrawText(ASettings.CaptionOn, Length(ASettings.CaptionOn), r, ASettings.CaptionFont, DT_VCENTER or DT_SINGLELINE );
    end;

    if (ASettings.CaptionOff <> '') and not AState then
    begin
      w := gp.TextWidth(ASettings.CaptionOn, ASettings.CaptionFont);
      if (w < ARect.Right - ARect.Left - 2 * radius) then
        w := (ARect.Right - ARect.Left - 2 * radius - w) div 2
      else
        w := 0;

      r := Rect(ARect.Left + 2 * radius + w, ARect.Top + h, ARect.Right, ARect.Bottom);
      gp.DrawText(ASettings.CaptionOff, Length(ASettings.CaptionOff), r, ASettings.CaptionFont, DT_VCENTER or DT_SINGLELINE );
    end;


  finally
    gp.Free;
  end;

end;


{ TAdvToggleSwitch }

procedure TAdvToggleSwitch.Click;
begin
  inherited;

  SetFocus;
  StartToggle;
end;

constructor TAdvToggleSwitch.Create(AOwner: TComponent);
begin
  inherited;
  FBackgroundOn := clLime;
  FBackgroundOff := clSilver;

  FBackgroundOnBorder := clNone;
  FBackgroundOffBorder := clNone;

  FBackgroundBorderWidth := 1;
  FBackgroundHeightPerc := 100;

  FButtonOn := clWhite;
  FButtonOff  := clWhite;
  FRounded := true;
  FAnimated := true;
  FShowFocus := true;
  DoubleBuffered := true;
  TabStop := true;
  Shadow := true;

  Width := 60;
  Height := 32;
end;

procedure TAdvToggleSwitch.DoEnter;
begin
  inherited;
  if ShowFocus then
    Invalidate;
end;

procedure TAdvToggleSwitch.DoExit;
begin
  inherited;
  if ShowFocus then
    Invalidate;
end;

procedure TAdvToggleSwitch.DoToggle;
begin
  FOn := not FOn;
  if Assigned(OnToggle) then
    OnToggle(Self);
end;

function TAdvToggleSwitch.GetVersion: string;
var
  vn: Integer;
begin
  vn := GetVersionNr;
  Result := IntToStr(Hi(Hiword(vn)))+'.'+IntToStr(Lo(Hiword(vn)))+'.'+IntToStr(Hi(Loword(vn)))+'.'+IntToStr(Lo(Loword(vn)));
end;

function TAdvToggleSwitch.GetVersionNr: Integer;
begin
  Result := MakeLong(MakeWord(BLD_VER,REL_VER),MakeWord(MIN_VER,MAJ_VER));
end;

procedure TAdvToggleSwitch.HandleTimer(Sender: TObject);
begin
  case FTransition of
  1: FTransition := 2;
  2: begin
       DoToggle;
       FTransition := 3;
     end;
  3: FTransition := 4;
  4: begin
       FreeAndNil(FTimer);
     end;
  end;
  Invalidate;
end;

procedure TAdvToggleSwitch.KeyPress(var Key: Char);
begin
  inherited;

  if Key = #32 then
  begin
    StartToggle;
  end;

end;

procedure TAdvToggleSwitch.Paint;
var
  settings: TToggleSwitchSettings;
  dr: TRect;
begin
  inherited;

  settings := TToggleSwitchSettings.Create;

  settings.BackgroundOn := FBackgroundOn;
  settings.BackgroundOff := FBackgroundOff;
  settings.BackgroundBorderOn := FBackgroundOnBorder;
  settings.BackgroundBorderOff := FBackgroundOffBorder;
  settings.BackgroundBorderWidth := FBackgroundBorderWidth;
  settings.ButtonOn := FButtonOn;
  settings.ButtonOff := FButtonOff;
  settings.ButtonBorderOn := FButtonOnBorder;
  settings.ButtonBorderOff := FButtonOffBorder;
  settings.ButtonBorderWidth := FButtonBorderWidth;
  settings.CaptionFont.Assign(Font);
  settings.CaptionOn := FCaptionOn;
  settings.CaptionOff := FCaptionOff;
  settings.Rounded := FRounded;
  settings.Delta := 0;
  settings.BackgroundHeightPerc := FBackgroundHeightPerc;
  settings.Shadow := FShadow;

  case FTransition of
  1: settings.Delta := 25;
  2: settings.Delta := 50;
  3: settings.Delta := 25;
  4: settings.Delta := 0;
  end;

  dr := ClientRect;
  if ShowFocus then
    InflateRect(dr,-2,-2)
  else
    InflateRect(dr,-1,-1);

  DrawToggle(Canvas, dr, FOn, settings);

  if Focused and ShowFocus then
  begin
    DrawFocusRect(Canvas.Handle, ClientRect);
  end;

  settings.Free;
end;

procedure TAdvToggleSwitch.SetBackgroundBorderWidth(const Value: single);
begin
  if (FBackgroundBorderWidth <> Value) then
  begin
    FBackgroundBorderWidth := Value;
    Invalidate;
  end;
end;

procedure TAdvToggleSwitch.SetBackgroundHeightPerc(const Value: integer);
begin
  if (FBackgroundHeightPerc <> Value) then
  begin
    FBackgroundHeightPerc := Value;
    Invalidate;
  end;
end;

procedure TAdvToggleSwitch.SetBackgroundOff(const Value: TColor);
begin
  if (FBackgroundOff <> Value) then
  begin
    FBackgroundOff := Value;
    Invalidate;
  end;
end;

procedure TAdvToggleSwitch.SetBackgroundOffBorder(const Value: TColor);
begin
  if (FBackgroundOffBorder <> Value) then
  begin
    FBackgroundOffBorder := Value;
    Invalidate;
  end;
end;

procedure TAdvToggleSwitch.SetBackgroundOn(const Value: TColor);
begin
  if (FBackgroundOn <> Value) then
  begin
    FBackgroundOn := Value;
    Invalidate;
  end;
end;

procedure TAdvToggleSwitch.SetBackgroundOnBorder(const Value: TColor);
begin
  if (FBackgroundOnBorder <> Value) then
  begin
    FBackgroundOnBorder := Value;
    Invalidate;
  end;
end;

procedure TAdvToggleSwitch.SetButtonBorderWidth(const Value: single);
begin
  if (FButtonBorderWidth <> Value) then
  begin
    FButtonBorderWidth := Value;
    Invalidate;
  end;
end;

procedure TAdvToggleSwitch.SetButtonOff(const Value: TColor);
begin
  if (FButtonOff <> Value) then
  begin
    FButtonOff := Value;
    Invalidate;
  end;
end;

procedure TAdvToggleSwitch.SetButtonOffBorder(const Value: TColor);
begin
  if (FButtonOffBorder <> Value) then
  begin
    FButtonOffBorder := Value;
    Invalidate;
  end;
end;

procedure TAdvToggleSwitch.SetButtonOn(const Value: TColor);
begin
  if (FButtonOn <> Value) then
  begin
    FButtonOn := Value;
    Invalidate;
  end;
end;

procedure TAdvToggleSwitch.SetButtonOnBorder(const Value: TColor);
begin
  if (FButtonOnBorder <> Value) then
  begin
    FButtonOnBorder := Value;
    Invalidate;
  end;
end;

procedure TAdvToggleSwitch.SetCaptionOff(const Value: string);
begin
  if (FCaptionOff <> Value) then
  begin
    FCaptionOff := Value;
    Invalidate;
  end;
end;

procedure TAdvToggleSwitch.SetCaptionOn(const Value: string);
begin
  if (FCaptionOn <> Value) then
  begin
    FCaptionOn := Value;
    Invalidate;
  end;
end;

procedure TAdvToggleSwitch.SetOn(const Value: boolean);
begin
  if (FOn <> Value) then
  begin
    FOn := Value;
    Invalidate;
  end;
end;

procedure TAdvToggleSwitch.SetRounded(const Value: boolean);
begin
  if (FRounded <> Value) then
  begin
    FRounded := Value;
    Invalidate;
  end;

end;

procedure TAdvToggleSwitch.SetShadow(const Value: boolean);
begin
  if (FShadow <> Value) then
  begin
    FShadow := Value;
    Invalidate;
  end;
end;

procedure TAdvToggleSwitch.SetVersion(const Value: string);
begin

end;

procedure TAdvToggleSwitch.StartToggle;
begin
  if not FAnimated then
    DoToggle
  else
    if not Assigned(FTimer) then
    begin
      FTransition := 1;
      FTimer := TTimer.Create(Self);
      FTimer.Interval := 20;
      FTimer.OnTimer := HandleTimer;
    end;

  Invalidate;
end;

{ TToggleSwitchSettings }

procedure TToggleSwitchSettings.Assign(Source: TPersistent);
begin
  if (Source is TToggleSwitchSettings) then
  begin
    FBackgroundOn := (Source as TToggleSwitchSettings).FBackgroundOn;
    FBackgroundBorderOn := (Source as TToggleSwitchSettings).FBackgroundBorderOn;
    FBackgroundBorderWidth := (Source as TToggleSwitchSettings).FBackgroundBorderWidth;
    FBackgroundOff := (Source as TToggleSwitchSettings).FBackgroundOff;
    FBackgroundBorderOff := (Source as TToggleSwitchSettings).FBackgroundBorderOff;
    FBackgroundHeightPerc := (Source as TToggleSwitchSettings).FBackgroundHeightPerc;
    FButtonOn := (Source as TToggleSwitchSettings).FButtonOn;
    FButtonOff := (Source as TToggleSwitchSettings).FButtonOff;
    FButtonBorderOn := (Source as TToggleSwitchSettings).FButtonBorderOn;
    FButtonBorderOff := (Source as TToggleSwitchSettings).FButtonBorderOff;
    FButtonBorderWidth := (Source as TToggleSwitchSettings).FButtonBorderWidth;
    FCaptionOn := (Source as TToggleSwitchSettings).CaptionOn;
    FCaptionOff := (Source as TToggleSwitchSettings).FCaptionOff;
    FCaptionFont.Assign( (Source as TToggleSwitchSettings).CaptionFont);
    FRounded := (Source as TToggleSwitchSettings).FRounded;
    FShadow := (Source as TToggleSwitchSettings).FShadow;
  end;
end;

constructor TToggleSwitchSettings.Create;
begin
  inherited;
  FCaptionFont := TFont.Create;
  FBackgroundOn := clLime;
  FBackgroundOff := clSilver;
  FButtonOff := clWhite;
  FButtonOn := clWhite;
  FButtonBorderOn := clNone;
  FButtonBorderOff := clNone;
  FBackgroundBorderOn := clNone;
  FBackgroundBorderOff := clNone;
  FButtonBorderWidth := 1;
  FBackgroundBorderWidth := 1;
  FBackgroundHeightPerc := 100;
  FShadow := false;
  FCaptionOn := '';
  FCaptionOff := '';
  FRounded := true;
end;

destructor TToggleSwitchSettings.Destroy;
begin
  FCaptionFont.Free;
  inherited;
end;

procedure TToggleSwitchSettings.SetCaptionFont(const Value: TFont);
begin
  FCaptionFont.Assign(Value);
end;

end.
