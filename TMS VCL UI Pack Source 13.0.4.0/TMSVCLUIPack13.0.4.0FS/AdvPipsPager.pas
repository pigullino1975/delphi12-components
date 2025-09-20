{***************************************************************************}
{ TAdvPipsPager component                                                   }
{ for Delphi & C++Builder                                                   }
{                                                                           }
{ written by TMS Software                                                   }
{            copyright © 2023                                               }
{            Email : info@tmssoftware.com                                   }
{            Web : https://www.tmssoftware.com                              }
{                                                                           }
{ The source code is given as is. The author is not responsible             }
{ for any possible damage done due to the use of this code.                 }
{ The component can be freely used in any application. The complete         }
{ source code remains property of the author and may not be distributed,    }
{ published, given or sold in any form as such. No parts of the source      }
{ code can be included in any other component or application without        }
{ written authorization of the author.                                      }
{***************************************************************************}

///  https://learn.microsoft.com/en-us/windows/apps/design/controls/pipspager

unit AdvPipsPager;

interface

uses
  Windows, Classes, AdvGDIP, Graphics, Controls, Messages;


type
  TPipsOrientation = (poHorizontal, poVertical);
  TPipsShape = (psFullCircle, psCircle, psFullSquare, psSquare);

  TPipsRenderer = record
    Orientation: TPipsOrientation;
    X,Y,Size,HoverSize,ActiveSize: integer;
    Offset,Number,Total: integer;
    Color, ActiveColor, HoverColor: TColor;
    ActiveIndex,HoverIndex: integer;
    ShowNext,ShowPrev: boolean;
    Shape: TPipsShape;
    HoverShowNext,HoverShowPrev: boolean;
    Width,Height: integer;
    ShowNumber: boolean;
    ActiveTextColor: TColor;
    Font: TFont;
  end;

  TAdvPipsPager = class(TGraphicControl)
  private
    FOrientation: TPipsOrientation;
    FPipsSize: integer;
    FPipsHoverSize: integer;
    FShowNumber: boolean;
    FShowPrev: boolean;
    FPipsShape: TPipsShape;
    FNumberOfPages: integer;
    FShowNext: boolean;
    FPipsColor: TColor;
    FPipsHoverColor: TColor;
    FHoverPip: integer;
    FPipsActiveColor: TColor;
    FPipsActiveSize: integer;
    FPipsIndex: integer;
    FPipsOffset: integer;
    FShowNextHover: boolean;
    FShowPrevHover: boolean;
    FPipsNumber: boolean;
    FPipsActiveTextColor: TColor;
    FOnChange: TNotifyEvent;
    procedure SetOrientation(const Value: TPipsOrientation);
    procedure SetNumberOfPages(const Value: integer);
    procedure SetPipsColor(const Value: TColor);
    procedure SetPipsShape(const Value: TPipsShape);
    procedure SetPipsSize(const Value: integer);
    procedure SetShowNext(const Value: boolean);
    procedure SetShowNumber(const Value: boolean);
    procedure SetShowPrev(const Value: boolean);
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure SetPipsActiveColor(const Value: TColor);
    procedure SetPipsActiveSize(const Value: integer);
    procedure SetPipsIndex(const Value: integer);
    procedure SetPipsNumber(const Value: boolean);
    procedure SetPipsActiveTextColor(const Value: TColor);
  protected
    procedure Paint; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    function XYToPip(X,Y: integer): integer;
    function VisiblePips: integer;
    procedure DoChange; virtual;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align;
    property AlignWithMargins;
    property Anchors;
    property Color;
    property Font;
    property NumberOfPages: integer read FNumberOfPages write SetNumberOfPages default 5;
    property Orientation: TPipsOrientation read FOrientation write SetOrientation default poHorizontal;
    property PipsColor: TColor read FPipsColor write SetPipsColor default clSilver;
    property PipsHoverColor: TColor read FPipsHoverColor write FPipsHoverColor default clGray;
    property PipsActiveColor: TColor read FPipsActiveColor write SetPipsActiveColor default clBlack;
    property PipsIndex: integer read FPipsIndex write SetPipsIndex default 0;
    property PipsShape: TPipsShape read FPipsShape write SetPipsShape default psFullCircle;
    property PipsSize: integer read FPipsSize write SetPipsSize default 8;
    property PipsHoverSize: integer read FPipsHoverSize write FPipsHoverSize default 10;
    property PipsActiveSize: integer read FPipsActiveSize write SetPipsActiveSize default 10;
    property PipsNumber: boolean read FPipsNumber write SetPipsNumber default false;
    property PipsActiveTextColor: TColor read FPipsActiveTextColor write SetPipsActiveTextColor default clWhite;
    property PopupMenu;
    property ShowHint;
    property ShowNext: boolean read FShowNext write SetShowNext default true;
    property ShowNumber: boolean read FShowNumber write SetShowNumber default false;
    property ShowPrev: boolean read FShowPrev write SetShowPrev default true;
    property Visible;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseLeave;
    property OnMouseEnter;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseDown;
    property OnStartDock;
    property OnStartDrag;

  end;

procedure DrawPips(gp: TGPGraphics; Renderer: TPipsRenderer);

implementation

uses
  SysUtils, Math, AdvStyleIF;

procedure DrawPips(gp: TGPGraphics; Renderer: TPipsRenderer);
var
  i,dps: integer;
  b,bn,bh,ba,fb: TGPSolidBrush;
  p,pn,ph,pa: TGPPen;
  f: TGPFont;
  pth: TGPGraphicsPath;
  sz,x,y: single;
  s: string;
  dr: TGPRectF;
  sf: TGPStringFormat;
begin
  bn := TGPSolidBrush.Create(ColorToARGB(Renderer.Color));
  bh := TGPSolidBrush.Create(ColorToARGB(Renderer.HoverColor));
  ba := TGPSolidBrush.Create(ColorToARGB(Renderer.ActiveColor));

  pn := TGPPen.Create(ColorToARGB(Renderer.Color),1);
  ph := TGPPen.Create(ColorToARGB(Renderer.HoverColor),1);
  pa := TGPPen.Create(ColorToARGB(Renderer.ActiveColor),1);

  b := bn;

  dps := Renderer.Size + (Renderer.Size div 2);

  f := gp.MakeFontEx(Renderer.Font);
  sf := TGPStringFormat.Create;
  sf.SetAlignment(StringAlignmentCenter);
  sf.SetLineAlignment(StringAlignmentCenter);


  if Renderer.ShowPrev then
  begin
    if Renderer.HoverShowPrev then
      b := bh;

    if (Renderer.ActiveIndex + Renderer.Offset > 0) then
    begin
      pth := TGPGraphicsPath.Create;
      pth.AddLine(Renderer.X + Renderer.Size, Renderer.Y, Renderer.X + Renderer.Size div 2, Renderer.Y + Renderer.Size div 2);
      pth.AddLine(Renderer.X + Renderer.Size div 2, Renderer.Y + Renderer.Size div 2, Renderer.X + Renderer.Size, Renderer.Y + Renderer.Size);
      pth.AddLine(Renderer.X + Renderer.Size, Renderer.Y + Renderer.Size, Renderer.X + Renderer.Size, Renderer.Y);
      gp.FillPath(b, pth);
      pth.Free;
    end;

    Renderer.X := Renderer.X + dps;
  end;

  for i := 0 to Renderer.Number - 1 do
  begin
    sz := Renderer.Size;
    x := Renderer.X;
    y := Renderer.Y;

    p := pn;
    b := bn;

    if i = Renderer.HoverIndex then
    begin
      x := x - (Renderer.HoverSize - Renderer.Size)/2;
      y := y - (Renderer.HoverSize - Renderer.Size)/2;
      sz := Renderer.HoverSize;
      p := ph;
      b := bh;
    end
    else
    if i = Renderer.ActiveIndex then
    begin
      x := x - (Renderer.ActiveSize - Renderer.Size)/2;
      y := y - (Renderer.ActiveSize - Renderer.Size)/2;
      sz := Renderer.ActiveSize;

      p := pa;
      b := ba;
    end;

    case Renderer.Shape of
      psFullCircle:
        begin
          gp.FillEllipse(b, x, y, sz, sz);
        end;
      psCircle:
        begin
          gp.DrawEllipse(p, x, y, sz, sz);
        end ;
      psFullSquare:
        begin
          gp.FillRectangle(b, x, y, sz, sz);
        end;
      psSquare:
        begin
          gp.DrawRectangle(p, x, y, sz, sz);
        end;
    end;

    if Renderer.ShowNumber then
    begin
      s := (i + Renderer.Offset).ToString;

      dr := MakeRect(x, y, sz, sz);

      if (i = Renderer.ActiveIndex) then
        fb := TGPSolidBrush.Create(ColorToARGB(Renderer.ActiveTextColor))
      else
        fb := TGPSolidBrush.Create(ColorToARGB(Renderer.Font.Color));

      gp.DrawString(s, Length(s), f, dr, sf, fb);

      fb.Free;
    end;

    Renderer.X := Renderer.X + dps;

    if Renderer.X > Renderer.Width then
      break;

    if Renderer.ShowNext and (Renderer.X + dps > Renderer.Width) then
      break;
  end;

  b := bn;

  if Renderer.ShowNext then
  begin
    if Renderer.HoverShowNext then
      b := bh;

//    outputdebugstring(pchar((Renderer.ActiveIndex + Renderer.Offset).ToString));

    if (Renderer.Total > Renderer.ActiveIndex + Renderer.Offset) then
    begin
      pth := TGPGraphicsPath.Create;
      pth.AddLine(Renderer.X, Renderer.Y, Renderer.X + Renderer.Size div 2, Renderer.Y + Renderer.Size div 2);
      pth.AddLine(Renderer.X + Renderer.Size div 2, Renderer.Y + Renderer.Size div 2, Renderer.X, Renderer.Y + Renderer.Size);
      pth.AddLine(Renderer.X, Renderer.Y + Renderer.Size, Renderer.X, Renderer.Y);
      gp.FillPath(b, pth);
      pth.Free;
    end;

    Renderer.X := Renderer.X + Renderer.Size + (Renderer.Size div 2);
  end;

//  f.Free;
  sf.Free;
  pa.Free;
  ph.Free;
  pn.Free;
  bh.Free;
  bn.Free;
  ba.Free;
end;

{ TAdvPipsPager }

procedure TAdvPipsPager.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  FHoverPip := -1;
  FShowNextHover := false;
  FShowPrevHover := false;
  Invalidate;
end;

constructor TAdvPipsPager.Create(AOwner: TComponent);
begin
  inherited;
  Width := 100;
  Height := 24;
  Color := clNone;
  FPipsShape := psFullCircle;
  FPipsColor := clSilver;
  FPipsSize := 8;
  FNumberOfPages := 5;
  FPipsHoverSize := 10;
  FPipsActiveSize := 10;
  FPipsOffset := 0;
  FPipsIndex := 0;
  FPipsActiveColor := clBlack;
  FPipsActiveTextColor := clWhite;
  FShowNext := true;
  FShowPrev := true;
  FHoverPip := -1;
end;

procedure TAdvPipsPager.DoChange;
begin
  if Assigned(OnChange) then
    OnChange(Self);
end;

procedure TAdvPipsPager.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  idx: integer;
begin
  inherited;

  idx := XYToPip(X,Y);

  if (idx = -2) and (FPipsIndex > 0) then
  begin
    if FPipsIndex = FPipsOffset then
      dec(FPipsOffset);

    FPipsIndex := FPipsIndex - 1;
    DoChange;
  end;

  if (idx = -3) and (FPipsIndex < FNumberOfPages - 1) then
  begin
    if FPipsIndex - FPipsOffset = VisiblePips - 1 then
      inc(FPipsOffset);

    FPipsIndex := FPipsIndex + 1;
    DoChange;
  end;

  if (idx >= 0) and (FPipsIndex <> idx + FPipsOffset) then
  begin
    FPipsIndex := idx + FPipsOffset;
    DoChange;
  end;
end;

procedure TAdvPipsPager.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  idx: integer;
begin
  inherited;

  idx := XYToPip(X,Y);

  if ShowPrev then
  begin
    FShowPrevHover := idx = -2;
  end;

  if ShowNext then
  begin
    FShowNextHover := idx = -3;
  end;

  FHoverPip := idx;
  Invalidate;
end;

procedure TAdvPipsPager.Paint;
var
  gp: TGPGraphics;
  r: TPipsRenderer;
  scale: single;
begin
  inherited;

  scale := GetDPIScale(Self, Canvas);

  if (Color <> clNone) then
  begin
    Canvas.Brush.Color := Color;
    Canvas.Brush.Style := bsSolid;
    Canvas.Pen.Color := Color;
    Canvas.Rectangle(ClientRect);
  end;


//  outputdebugstring(pchar('index:'+FPipsIndex.ToString+' visiblepips:'+VIsiblePips.ToString+' offset:'+FPipsOffset.ToString));

  gp := TGPGraphics.Create(Canvas.Handle);
  gp.SetSmoothingMode(SmoothingModeAntiAlias);

  r.X := Round(PipsSize * scale);
  r.Y := Round(PipsSize * scale);
  r.Size := Round(PipsSize * scale);
  r.HoverSize := Round(PipsHoverSize * scale);
  r.Color := PipsColor;
  r.HoverColor := PipsHoverColor;
  r.ShowNext := ShowNext and (FPipsIndex < NumberOfPages - 1);
  r.ShowPrev := ShowPrev;
  r.HoverShowNext := FShowNextHover;
  r.HoverShowPrev := FShowPrevHover;
  r.Number := VisiblePips;
  r.Total := NumberOfPages;
  r.HoverIndex := FHoverPip;
  r.Shape := PipsShape;
  r.Offset := FPipsOffset;
  r.ActiveSize := Round(PipsActiveSize * scale);
  r.ActiveIndex := PipsIndex - FPipsOffset;
  r.ActiveColor := PipsActiveColor;
  r.Width := ClientWidth;
  r.Height := ClientHeight;
  r.ShowNumber := PipsNumber;
  r.Font := Font;
  r.ActiveTextColor := PipsActiveTextColor;

  DrawPips(gp, r);
  gp.Free;
end;

procedure TAdvPipsPager.SetNumberOfPages(const Value: integer);
begin
  if (FNumberOfPages <> Value) then
  begin
    FNumberOfPages := Value;
    Invalidate;
  end;
end;

procedure TAdvPipsPager.SetOrientation(const Value: TPipsOrientation);
begin
  if (FOrientation <> Value) then
  begin
    FOrientation := Value;
    Invalidate;
  end;
end;

procedure TAdvPipsPager.SetPipsActiveColor(const Value: TColor);
begin
  if (FPipsActiveColor <> Value) then
  begin
    FPipsActiveColor := Value;
    Invalidate;
  end;
end;

procedure TAdvPipsPager.SetPipsActiveSize(const Value: integer);
begin
  if (FPipsActiveSize <> Value) then
  begin
    FPipsActiveSize := Value;
    Invalidate;
  end;
end;

procedure TAdvPipsPager.SetPipsActiveTextColor(const Value: TColor);
begin
  if (FPipsActiveTextColor <> Value) then
  begin
    FPipsActiveTextColor := Value;
    Invalidate;
  end;
end;

procedure TAdvPipsPager.SetPipsColor(const Value: TColor);
begin
  if (FPipsColor <> Value) then
  begin
    FPipsColor := Value;
    Invalidate;
  end;
end;

procedure TAdvPipsPager.SetPipsIndex(const Value: integer);
begin
  if (FPipsIndex <> Value) then
  begin
    FPipsIndex := Value;
    Invalidate;
  end;
end;

procedure TAdvPipsPager.SetPipsNumber(const Value: boolean);
begin
  if (FPipsNumber <> Value) then
  begin
    FPipsNumber := Value;
    Invalidate;
  end;
end;

procedure TAdvPipsPager.SetPipsShape(const Value: TPipsShape);
begin
  if (FPipsShape <> Value) then
  begin
    FPipsShape := Value;
    Invalidate;
  end;
end;

procedure TAdvPipsPager.SetPipsSize(const Value: integer);
begin
  if (FPipsSize <> Value) then
  begin
    FPipsSize := Value;
    Invalidate;
  end;
end;

procedure TAdvPipsPager.SetShowNext(const Value: boolean);
begin
  if (FShowNext <> Value) then
  begin
    FShowNext := Value;
    Invalidate;
  end;
end;

procedure TAdvPipsPager.SetShowNumber(const Value: boolean);
begin
  if (FShowNumber <> Value) then
  begin
    FShowNumber := Value;
    Invalidate;
  end;
end;

procedure TAdvPipsPager.SetShowPrev(const Value: boolean);
begin
  if (FShowPrev <> Value) then
  begin
    FShowPrev := Value;
    Invalidate;
  end;
end;

function TAdvPipsPager.VisiblePips: integer;
var
  pds: integer;
  w: integer;
  scale: single;
  LPipsSize: integer;
begin
  scale := GetDPIScale(Self, Canvas);
  LPipsSize := Round(FPipsSize * scale);

  pds := LPipsSize + (LPipsSize div 2);

  w := ClientWidth - 2 * LPipsSize;

  if ShowNext then
    w := w - pds;

  if ShowPrev then
    w := w - pds;

  Result := Min(NumberOfPages,1 + (w div pds));
end;

function TAdvPipsPager.XYToPip(X, Y: integer): integer;
var
  dx,pds: integer;
  //dy: integer;
  drawnr: integer;
  scale: single;
  LPipsSize: integer;
begin
  scale := GetDPIScale(Self, Canvas);
  LPipsSize := Round(PipsSize * scale);

  dx := X - LPipsSize;
  //dy := Y - PipsSize;

  pds := LPipsSize + (LPipsSize div 2);

  drawnr := VisiblePips;

  if ShowPrev then
  begin
    if dx <= LPipsSize then
    begin
      Result := -2;
      Exit;
    end;
    dx := dx - pds;
  end;

  if ShowNext then
  begin
    if (dx >= (drawnr * pds)) and (dx < (drawnr + 1) * pds)  then
    begin
      Result := -3;
      Exit;
    end;
  end;

  dx := dx + (LPipsSize div 2);

  Result := (dx div pds);
end;

end.
