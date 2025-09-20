{***************************************************************************}
{ TAdvAvatar component                                                   }
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

unit AdvAvatar;

{$I TMSDEFS.INC}

interface

uses
  Windows, Classes, AdvGDIP, Graphics, Controls, Messages;

type
  TCaptionLayout = (clTopLeft, clTopCenter, clTopRight, clBottomLeft, clBottomCenter, clBottomRight);


  TAdvAvatar = class(TGraphicControl)
  private
    FPicture: TAdvGDIPPicture;
    FCaption: TCaption;
    FCaptionLayout: TCaptionLayout;
    FCaptionBackground: TColor;
    FBorderColor: TColor;
    FBorderWidth: integer;
    procedure SetPicture(const Value: TAdvGDIPPicture);
    procedure SetCaptionLayout(const Value: TCaptionLayout);
    procedure PictureChanged(Sender: TObject);
    procedure SetCaptionBackground(const Value: TColor);
    procedure SetCaption(const Value: TCaption);
    procedure SetBorderColor(const Value: TColor);
    procedure SetBorderWidth(const Value: integer);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property AlignWithMargins;
    property Anchors;
    property BorderColor: TColor read FBorderColor write SetBorderColor default clNone;
    property BorderWidth: integer read FBorderWidth write SetBorderWidth default 1;
    property Caption: TCaption read FCaption write SetCaption;
    property CaptionLayout: TCaptionLayout read FCaptionLayout write SetCaptionLayout default clBottomCenter;
    property CaptionBackground: TColor read FCaptionBackground write SetCaptionBackground default clNone;
    property Color;
    property Font;
    property Picture: TAdvGDIPPicture read FPicture write SetPicture;
    property PopupMenu;
    property Visible;
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

  TAdvAvatarList = class;

  TAvatar = class(TCollectionItem)
  private
    FPicture: TAdvGDIPPicture;
    FHint: TStrings;
    FTag: integer;
    procedure SetPicture(const Value: TAdvGDIPPicture);
    procedure SetHint(const Value: TStrings);
  protected
    procedure PictureChanged(Sender: TObject);
  public
    constructor Create(ACollection: TCollection); override;
    destructor Destroy; override;
  published
    property Hint: TStrings read FHint write SetHint;
    property Picture: TAdvGDIPPicture read FPicture write SetPicture;
    property Tag: integer read FTag write FTag;
  end;

  TAvatarCollection = class(TOwnedCollection)
  private
    function GetItem(AIndex: integer): TAvatar;
    procedure SetItem(AIndex: integer; const Value: TAvatar);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    function Add: TAvatar;
    function Insert(AIndex: integer): TAvatar;
    property Items[AIndex: integer]: TAvatar read GetItem write SetItem; default;
  end;

  TAvatarEvent = procedure(Sender: TObject; AIndex: integer) of object;
  TCaptionHintEvent = procedure(Sender: TObject; var AHint: string) of object;

  TAdvAvatarList = class(TGraphicControl)
  private
    FAvatars: TAvatarCollection;
    FOverlap: integer;
    FCaption: TCaption;
    FSize: integer;
    FHoverItem: integer;
    FClickItem: integer;
    FOnAvatarClick: TAvatarEvent;
    FAvatarCount: integer;
    FInCaption: boolean;
    FClickCaption: boolean;
    FOnCaptionClick: TNotifyEvent;
    FOnCaptionHint: TCaptionHintEvent;
    FBorderColor: TColor;
    FBorderWidth: integer;
    procedure SetAvatars(const Value: TAvatarCollection);
    procedure SetCaption(const Value: TCaption);
    procedure SetOverlap(const Value: integer);
    procedure SetSize(const Value: integer);
    procedure CMHintShow(var Message: TMessage); message CM_HINTSHOW;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure SetAvatarCount(const Value: integer);
    procedure SetBorderColor(const Value: TColor);
    procedure SetBorderWidth(const Value: integer);
  protected
    procedure Paint; override;
    function XYToAvatar(X,Y: integer): integer;
    function NumAvatars: integer;
    function InCaption(X,Y: integer): boolean;
    procedure DoAvatarClick(const AIndex: integer); virtual;
    procedure DoCaptionClick; virtual;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property AlignWithMargins;
    property Anchors;
    property Avatars: TAvatarCollection read FAvatars write SetAvatars;
    property AvatarCount: integer read FAvatarCount write SetAvatarCount default -1;
    property BorderColor: TColor read FBorderColor write SetBorderColor default clNone;
    property BorderWidth: integer read FBorderWidth write SetBorderWidth default 1;
    property Caption: TCaption read FCaption write SetCaption;
    property Color;
    property Font;
    property Overlap: integer read FOverlap write SetOverlap default 50;
    property PopupMenu;
    property ShowHint;
    property Size: integer read FSize write SetSize default 32;
    property Visible;

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

    property OnAvatarClick: TAvatarEvent read FOnAvatarClick write FOnAvatarClick;
    property OnCaptionClick: TNotifyEvent read FOnCaptionClick write FOnCaptionClick;
    property OnCaptionHint: TCaptionHintEvent read FOnCaptionHint write FOnCaptionHint;
  end;



implementation

uses
  SysUtils, Forms, Types, UITypes, AdvStyleIF;

{ TAdvAvatar }

constructor TAdvAvatar.Create(AOwner: TComponent);
begin
  inherited;
  FPicture := TAdvGDIPPicture.Create;
  FPicture.OnChange := PictureChanged;
  FCaptionBackground := clNone;
  FCaptionLayout := clBottomCenter;
  FBorderColor := clNone;
  FBorderWidth := 1;
  Width := 64;
  Height := 64;
end;

destructor TAdvAvatar.Destroy;
begin
  FPicture.Free;
  inherited;
end;

procedure TAdvAvatar.Paint;
var
  gp: TGPGraphics;
  r: TGPRegion;
  pth: TGPGraphicsPath;
  cr: TRect;
  scale: single;
  f: TGPFont;
  p: TGPPen;
  dr,sdr: TGPRectF;
  sf: TGPStringFormat;
  b: TGPSolidBrush;
begin
  inherited;

  gp := TGPGraphics.Create(Canvas.Handle);
  gp.SetSmoothingMode(SmoothingModeAntiAlias);

  if (csDesigning in ComponentState) and FPicture.Empty then
  begin
    b := TGPSolidBrush.Create(ColorToARGB(clWhite));

    if Width > Height then
    begin
      gp.FillEllipse(b, (Width - Height) div 2,0, Height, Height);
    end
    else
    begin
      gp.FillEllipse(b, 0, (Height - Width) div 2, Width, Width);
    end;

    b.Free;
  end;

  FPicture.GetImageSizes;
  if not FPicture.Empty and (FPicture.Width > 0) and (FPicture.Height > 0) then
  begin

    pth := TGPGraphicsPath.Create;

    pth.AddEllipse(0,0,Width,Height);

    r := TGPRegion.Create(pth);

    gp.SetClip(r);

    cr := ClientRect;

    if (FPicture.Height > FPicture.Width) then
    begin
      scale := cr.Width/FPicture.Width;
      cr.Top := 0;
      cr.Bottom := Round(FPicture.Height * scale);
    end
    else
    begin
      scale := cr.Height/FPicture.Height;
      cr.Left := 0;
      cr.Right := Round(FPicture.Width * scale);
    end;

    FPicture.GDIPDraw(gp, cr);
    gp.ResetClip;

    if (BorderColor <> clNone) then
    begin
      p := TGPPen.Create(ColorToARGB(BorderColor), BorderWidth);
      gp.DrawPath(p, pth);
    end;

    pth.Free;
    r.Free;
  end;

  if (Caption <> '') then
  begin
    cr := ClientRect;
    f := gp.MakeFontEx(Font);

    dr.X := 0;
    dr.Y := 0;
    dr.Width := Width;
    dr.Height := Height;

    sf := TGPStringFormat.Create();

    gp.MeasureString(Caption, Length(Caption), f, dr, sf, sdr);

    if CaptionBackground <> clNone then
    begin
      b := TGPSolidBrush.Create(ColorToARGB(CaptionBackground));

      case CaptionLayout of
      clTopLeft:
        begin
        end;
      clBottomLeft:
        begin
          sdr.Y := ClientRect.Height - Round(sdr.Height);
        end;
      clTopCenter:
        begin
          sdr.X := Round(ClientRect.Width - sdr.Width) div 2;
          sdr.Y := 2;
        end;
      clBottomCenter:
        begin
          sdr.X := Round(ClientRect.Width - sdr.Width) div 2;
          sdr.Y := ClientRect.Height - Round(sdr.Height);
        end;
      clTopRight:
        begin
          sdr.X := ClientRect.Width - Round(sdr.Width);
        end;
      clBottomRight:
        begin
          sdr.X := ClientRect.Width - Round(sdr.Width);
          sdr.Y := ClientRect.Height - Round(sdr.Height);
        end;
      end;

      gp.FillRectangle(b, sdr);
      b.Free;
    end;

    case CaptionLayout of
    clTopLeft,clBottomLeft: sf.SetAlignment(StringAlignmentNear);
    clTopCenter,clBottomCenter: sf.SetAlignment(StringAlignmentCenter);
    clTopRight,clBottomRight: sf.SetAlignment(StringAlignmentFar);
    end;

    if not (CaptionLayout in [clTopLeft,clTopCenter,clTopRight]) then
    begin
      sf.SetLineAlignment(StringAlignmentFar);
    end;

    b := TGPSolidBrush.Create(ColorToARGB(Font.Color));

    gp.DrawString(Caption, Length(Caption), f, dr, sf, b);

    b.Free;
    sf.Free;
  end;

  gp.Free;
end;

procedure TAdvAvatar.PictureChanged(Sender: TObject);
begin
  Invalidate;
end;

procedure TAdvAvatar.SetBorderColor(const Value: TColor);
begin
  if (FBorderColor <> Value) then
  begin
    FBorderColor := Value;
    Invalidate;
  end;
end;

procedure TAdvAvatar.SetBorderWidth(const Value: integer);
begin
  if (FBorderWidth <> Value) then
  begin
    FBorderWidth := Value;
    Invalidate;
  end;
end;

procedure TAdvAvatar.SetCaption(const Value: TCaption);
begin
  if (FCaption <> Value) then
  begin
    FCaption := Value;
    Invalidate;
  end;
end;

procedure TAdvAvatar.SetCaptionBackground(const Value: TColor);
begin
  if (FCaptionBackground <> Value) then
  begin
    FCaptionBackground := Value;
    Invalidate;
  end;
end;

procedure TAdvAvatar.SetCaptionLayout(const Value: TCaptionLayout);
begin
  if (FCaptionLayout <> Value) then
  begin
    FCaptionLayout := Value;
    Invalidate;
  end;
end;

procedure TAdvAvatar.SetPicture(const Value: TAdvGDIPPicture);
begin
  FPicture.Assign(Value);
end;

{ TAdvAvatarList }

procedure TAdvAvatarList.CMHintShow(var Message: TMessage);
var
  pt: TPoint;
  i: integer;
  s: string;
begin
  inherited;

  pt := TCMHintShow(Message).HintInfo.CursorPos;

  i := XYToAvatar(pt.X,pt.Y);

  if (i <> -1) then
  begin
    {$IFDEF DELPHIXE11_LVL}
    TCMHintShow(Message).HintInfo.HintStr := Avatars[i].Hint.Text;
    {$ENDIF}
    {$IFNDEF DELPHIXE11_LVL}
    s := Avatars[i].Hint.Text;
    if Length(s) > 1 then
    begin
      if pos(#13,s) = Length(s) then
        Delete(s,Length(s), 1);
    end;

    TCMHintShow(Message).HintInfo.HintStr := s;
    {$ENDIF}
  end
  else
    if InCaption(pt.X, pt.Y) then
    begin
      s := '';
      if Assigned(OnCaptionHint) then
        OnCaptionHint(self, s);
      if s <> '' then
        TCMHintShow(Message).HintInfo.HintStr := s;
    end;
end;

procedure TAdvAvatarList.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if FInCaption then
    Invalidate;
  FInCaption := false;

  FHoverItem := -1;
end;

constructor TAdvAvatarList.Create(AOwner: TComponent);
begin
  inherited;
  FAvatars := TAvatarCollection.Create(Self,TAvatar);
  FSize := 32;
  FOverlap := 50;
  FAvatarCount := -1;
  FInCaption := false;
end;

destructor TAdvAvatarList.Destroy;
begin
  FAvatars.Free;
  inherited;
end;

procedure TAdvAvatarList.DoAvatarClick(const AIndex: integer);
begin
  if Assigned(OnAvatarClick) then
    OnAvatarClick(Self, AIndex);
end;

procedure TAdvAvatarList.DoCaptionClick;
begin
  if Assigned(OnCaptionClick) then
    OnCaptionClick(Self);
end;

function TAdvAvatarList.InCaption(X,Y: integer): boolean;
var
  cr: TRect;
  sz,scale: single;
  gp: TGPGraphics;
  f: TGPFont;
  dr,res: TGPRectF;
  h, LSize: integer;

begin
  Result := false;
  scale := GetDPIScale(Self, Canvas);
  LSize := Round(Size * scale);

  sz := (LSize * (100 - Overlap))/100;

  if (Caption <> '') then
  begin
    cr.Left  := Round (sz * (NumAvatars - 1)) + LSize;

    dr.X := 0;
    dr.Y := 0;
    dr.Width := Width;
    dr.Height := Height;

    gp := TGPGraphics.Create(Canvas.Handle);
    f := gp.MakeFontEx(Font);
    gp.MeasureString(Caption, Length(Caption), f, dr, nil, res);
    gp.Free;

    h := Round(res.Height);

    cr.Top := (Height - h) div 2;
    cr.Bottom := cr.Top + h;
    cr.Right := cr.Left + Round(res.Width);

    Result := PtInrect(cr, Point(X,Y));
  end;
end;

procedure TAdvAvatarList.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  FClickItem := XYToAvatar(X,Y);
  FClickCaption := InCaption(X,Y);
end;

procedure TAdvAvatarList.MouseMove(Shift: TShiftState; X, Y: integer);
var
  LNewItem: integer;
  LInCaption: boolean;
begin
  inherited;

  LInCaption := InCaption(X,Y);
  if LInCaption <> FInCaption then
  begin
    FInCaption := LInCaption;
    outputdebugstring(pchar('in caption:'+X.ToString+':'+Y.ToString));
    Invalidate;
  end;

  LNewItem := XYToAvatar(X,Y);

  if LNewItem <> FHoverItem then
  begin
    Application.CancelHint;
    FHoverItem := LNewItem;
  end;
end;

procedure TAdvAvatarList.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  LNewItem: integer;
begin
  inherited;

  LNewItem := XYToAvatar(X,Y);

  if FClickCaption and InCaption(X,Y) then
    DoCaptionClick;

  if (LNewItem = FClickItem) and (LNewItem <> -1) then
    DoAvatarClick(LNewItem);
end;

function TAdvAvatarList.NumAvatars: integer;
begin
  if (AvatarCount > 0) and (AvatarCount < Avatars.Count) then
    Result := AvatarCount
  else
    Result := Avatars.Count;
end;

procedure TAdvAvatarList.Paint;
var
  i,cnt,LSize: integer;
  cr,ir: TRect;
  gp: TGPGraphics;
  r: TGPRegion;
  pth: TGPGraphicsPath;
  pic: TAdvGDIPPicture;
  scale: single;
  f: TGPFont;
  sf: TGPStringFormat;
  b: TGPSolidBrush;
  tr: TGPRectF;
  fnt: TFont;
  p: TGPPen;

begin
  inherited;

  scale := GetDPIScale(Self, Canvas);
  LSize := Round(Size * scale);

  gp := TGPGraphics.Create(Canvas.Handle);
  gp.SetSmoothingMode(SmoothingModeAntiAlias);

  cr.Left := 0;
  cr.Top := 0;
  cr.Right := LSize;
  cr.Bottom := LSize;

  cr.Top := (Height - LSize) div 2;
  cr.Bottom := cr.Top + LSize;

  if (csDesigning in ComponentState) and (Avatars.Count = 0) then
  begin
    if (BorderColor <> clNone) then
      p := TGPPen.Create(ColorToARGB(BorderColor), BorderWidth)
    else
      p := TGPPen.Create(ColorToARGB(clGray));

    b := TGPSolidBrush.Create(ColorToARGB(clBtnFace));

    cnt := AvatarCount;
    if cnt < 0 then
      cnt := 5;

    for i := 0 to cnt - 1 do
    begin
      gp.FillEllipse(b, cr.Left, cr.Top, cr.Right - cr.Left, cr.Bottom - cr.Top);
      gp.DrawEllipse(p, cr.Left, cr.Top, cr.Right - cr.Left, cr.Bottom - cr.Top);

      if i = cnt - 1 then
        cr.Left := cr.Left + LSize
      else
        cr.Left := cr.Left + Round(LSize * (100 - Overlap) /100);

      cr.Right := cr.Left + LSize;
    end;

    b.Free;
    p.Free;
  end;

  p := nil;

  if (BorderColor <> clNone) then
    p := TGPPen.Create(ColorToARGB(BorderColor), BorderWidth);

  for i := 0 to NumAvatars - 1 do
  begin
    pic := Avatars[i].Picture;
    pic.GetImageSizes;

    if not pic.Empty and (pic.Width > 0) and (pic.Height > 0) then
    begin
      pth := TGPGraphicsPath.Create;

      pth.AddEllipse(cr.Left,cr.Top,cr.Right - cr.Left,cr.Bottom - cr.Top);

      r := TGPRegion.Create(pth);

      gp.SetClip(r);

      ir := cr;

      if (pic.Height > pic.Width) then
      begin
        scale := Height/pic.Width;
        ir.Bottom := Round(pic.Height * scale);
      end
      else
      begin
        scale := Height/pic.Height;
        ir.Right := cr.Left + Round(pic.Width * scale);
      end;

      pic.GDIPDraw(gp, ir);
      gp.ResetClip;

      if (BorderColor <> clNone) then
        gp.DrawPath(p, pth);

      pth.Free;
      r.Free;

      if i = NumAvatars - 1 then
        cr.Left := cr.Left + LSize
      else
        cr.Left := cr.Left + Round(LSize * (100 - Overlap) /100);

      cr.Right := cr.Left + LSize;
    end;
  end;

  if Assigned(p) then
    p.Free;

  if (Caption <> '') then
  begin
    b := TGPSolidBrush.Create(ColorToARGB(Font.Color));

    fnt := TFont.Create;
    fnt.Assign(Font);
    if FInCaption and Assigned(OnCaptionClick) then
      fnt.Style := fnt.Style + [fsUnderline];
    f := gp.MakeFontEx(fnt);
    fnt.Free;

    sf := TGPStringFormat.Create;
    sf.SetLineAlignment(StringAlignmentCenter);

    tr.X := cr.Left;

    if (BorderColor <> clNone) then
      tr.X := tr.X + BorderWidth;

    tr.Y := cr.Top;
    tr.Width := cr.Right - cr.Left;
    tr.Height := cr.Bottom - cr.Top;

    gp.DrawString(Caption, Length(Caption), f, tr, sf, b);

    sf.Free;
    b.Free;
  end;

  gp.Free;
end;

procedure TAdvAvatarList.SetAvatarCount(const Value: integer);
begin
  if FAvatarCount <> Value then
  begin
    FAvatarCount := Value;
    Invalidate;
  end;
end;

procedure TAdvAvatarList.SetAvatars(const Value: TAvatarCollection);
begin
  FAvatars.Assign(Value);
end;

procedure TAdvAvatarList.SetBorderColor(const Value: TColor);
begin
  if (FBorderColor <> Value) then
  begin
    FBorderColor := Value;
    Invalidate;
  end;
end;

procedure TAdvAvatarList.SetBorderWidth(const Value: integer);
begin
  if (FBorderWidth <> Value) then
  begin
    FBorderWidth := Value;
    Invalidate;
  end;
end;

procedure TAdvAvatarList.SetCaption(const Value: TCaption);
begin
  if (FCaption <> Value) then
  begin
    FCaption := Value;
    Invalidate;
  end;
end;

procedure TAdvAvatarList.SetOverlap(const Value: integer);
begin
  if (FOverlap <> Value) then
  begin
    FOverlap := Value;
    Invalidate;
  end;
end;

procedure TAdvAvatarList.SetSize(const Value: integer);
begin
  if (FSize <> Value) then
  begin
    FSize := Value;
    Invalidate;
  end;
end;

function TAdvAvatarList.XYToAvatar(X, Y: integer): integer;
var
  sz,scale: single;
  res,top: integer;
  LSize: integer;
begin
  Result := -1;

  scale := GetDPIScale(Self, Canvas);
  LSize := Round(Size * scale);

  sz := (LSize * (100 - Overlap))/100;

  top := (Height - LSize) div 2;

  res := -1;

  if (Y > top) and (Y < Height - Top) then
  begin
    if (sz > 0) then
    begin
      res := Round(Int(X / sz));
    end;

    if res < NumAvatars then
      Result := res
    else
    begin
      if X < (NumAvatars - 1) * sz + LSize then
        Result := NumAvatars - 1;
    end;
  end;

end;

{ TAvatar }

constructor TAvatar.Create(ACollection: TCollection);
begin
  inherited;
  FPicture := TAdvGDIPPicture.Create;
  FPicture.OnChange := PictureChanged;
  FHint := TStringList.Create;
  {$IFDEF DELPHIXE11_LVL}
  FHint.TrailingLineBreak := false;
  {$ENDIF}
end;

destructor TAvatar.Destroy;
begin
  FPicture.Free;
  FHint.Free;
  inherited;
end;

procedure TAvatar.PictureChanged(Sender: TObject);
begin
  ((Collection as TAvatarCollection).Owner as TAdvAvatarList).Invalidate;
end;

procedure TAvatar.SetHint(const Value: TStrings);
begin
  FHint.Assign(Value);
end;

procedure TAvatar.SetPicture(const Value: TAdvGDIPPicture);
begin
  FPicture.Assign(Value);
end;

{ TAvatarCollection }

function TAvatarCollection.Add: TAvatar;
begin
  Result := TAvatar(inherited Add);
end;

function TAvatarCollection.GetItem(AIndex: integer): TAvatar;
begin
  Result := TAvatar(inherited Items[AIndex]);
end;

function TAvatarCollection.Insert(AIndex: integer): TAvatar;
begin
  Result := TAvatar(inherited Insert(AIndex));
end;

procedure TAvatarCollection.SetItem(AIndex: integer; const Value: TAvatar);
begin
  inherited Items[AIndex] := Value;
end;

procedure TAvatarCollection.Update(Item: TCollectionItem);
begin
  inherited;
  (Owner as TAdvAvatarList).Invalidate;
end;

end.
