{***************************************************************************}
{ TAdvFrameView component                                                   }
{ for Delphi & C++Builder                                                   }
{                                                                           }
{ written by TMS Software                                                   }
{            copyright © 2023                                               }
{            Email : info@tmssoftware.com                                   }
{            Web : http://www.tmssoftware.com                               }
{                                                                           }
{ The source code is given as is. The author is not responsible             }
{ for any possible damage done due to the use of this code.                 }
{ The component can be freely used in any application. The complete         }
{ source code remains property of the author and may not be distributed,    }
{ published, given or sold in any form as such. No parts of the source      }
{ code can be included in any other component or application without        }
{ written authorization of the author.                                      }
{***************************************************************************}

unit AdvFrameView;

interface

uses
  Classes, AdvScrollBox, Windows, SysUtils, Graphics, Controls, ExtCtrls,
  StdCtrls, Forms, Generics.Collections, Messages, AppEvnts, UITypes;

{$I TMSDEFS.INC}

type
  TFrameClass = class of TFrame;

  TAdvFrameViewBackground = class(TPaintBox)
  protected
    procedure Paint; override;
  end;

  IAdvListFrame = interface['{2F4C16A9-4FD8-428C-90FF-F8595C65FA94}']
    procedure Select;
    procedure Unselect;
  end;

  TAdvFrameEvent = procedure(Sender: TObject; AIndex: integer; AFrame: TFrame) of object;

  TAdvFrameKeyEvent = procedure(Sender: TObject; var Key: Word; Shift: TShiftState; FrameIndex: integer; ActiveControl: TControl) of object;

  TAdvFrameCreation = (fcInView, fcDynamic, fcAll);

  TNavigateKeyState = (nkShift, nkAlt, nkCtrl);

  TNavigateKeyStates = set of TNavigateKeyState;

  TAdvFrameView = class(TAdvScrollBox)
  private
    FBackground: TAdvFrameViewBackground;
    FFrameClass: TFrameClass;
    FFrames: TArray<TFrame>;
    FRows: integer;
    FColumns: integer;
    FItemHeight: integer;
    FItemWidth: integer;
    FFrameHeight: integer;
    FFrameWidth: integer;
    FItemCount: integer;
    FOnFrameCreate: TAdvFrameEvent;
    FOnFrameDestroy: TAdvFrameEvent;
    FFrameCreation: TAdvFrameCreation;
    FAppEvents: TApplicationEvents;
    FItemIndex: integer;
    FOnFrameKeyDown: TAdvFrameKeyEvent;
    FOnFrameSelect: TAdvFrameEvent;
    FOnFrameUnSelect: TAdvFrameEvent;
    FNavigateKeyStates: TNavigateKeyStates;
    FItemMinWidth: integer;
    FDesignTime: boolean;
    procedure SetColumns(const Value: integer);
    procedure SetRows(const Value: integer);
    procedure SetItemHeight(const Value: integer);
    procedure SetItemWidth(const Value: integer);
    procedure SetItemCount(const Value: integer);
    procedure SetFrameClass(const Value: TFrameClass);
    procedure FocusChanged(var Msg : TCMFocusChanged); message CM_FOCUSCHANGED;
    procedure AppMessage(var Msg: TMsg; var Handled: boolean);
    procedure SetItemIndex(const Value: integer);
    procedure SetItemMinWidth(const Value: integer);
    procedure CMControlChange(var Message: TCMControlChange); message CM_CONTROLCHANGE;
    function GetFrame(Index: integer): TFrame;
  protected
    {$IFNDEF DELPHIXE10_LVL}
    procedure ChangeScale(M, D: Integer); override;
    {$ENDIF}
    {$IFDEF DELPHIXE10_LVL}
    procedure ChangeScale(M, D: Integer; isDpiChange: Boolean); override;
    {$ENDIF}
    procedure AlignControls(AControl: TControl; var Rect: TRect); override;
    procedure ScrollChange; override;
    procedure BuildFrames(AParam: boolean = false); virtual;
    procedure ScrollInView; virtual;
    procedure ScrollDown; virtual;
    procedure ScrollUp; virtual;
    procedure ScrollLeft; virtual;
    procedure ScrollRight; virtual;
    procedure PaintBackground(Sender: TObject);
    procedure CreateWnd; override;
    procedure DoCreateFrame(AIndex: integer; AFrame: TFrame); virtual;
    procedure DoDestroyFrame(AIndex: integer; AFrame: TFrame); virtual;
    procedure DoFrameKeyDown(AFrameIndex: integer; var AKey: word; AShiftState: TShiftState); virtual;
    procedure DoSelectFrame(AIndex: integer; AFrame: TFrame); virtual;
    procedure DoUnSelectFrame(AIndex: integer; AFrame: TFrame); virtual;
    procedure GetFrameRange(var FromIndex, ToIndex: integer);
    function GetFrameHeight: integer;
    function GetFrameWidth: integer;
    function GetFrameCount: integer;
    function VisibleColumns: integer;
    procedure Resize; override;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function IndexOf(AFrame: TFrame): integer;
    property FrameClass: TFrameClass read FFrameClass write SetFrameClass;
    function FrameCount: integer; inline;
    property Frames[Index: integer]: TFrame read GetFrame; default;
  published
    property Columns: integer read FColumns write SetColumns default 1;
    property DoubleBuffered default true;
    property FrameCreation: TAdvFrameCreation read FFrameCreation write FFrameCreation default fcInView;
    property NavigateKeyStates: TNavigateKeyStates read FNavigateKeyStates write FNavigateKeyStates default [];
    property Rows: integer read FRows write SetRows default 10;
    property ItemIndex: integer read FItemIndex write SetItemIndex default -1;
    property ItemWidth: integer read FItemWidth write SetItemWidth default 0;
    property ItemHeight: integer read FItemHeight write SetItemHeight default 0;
    property ItemCount: integer read FItemCount write SetItemCount default 0;
    property ItemMinWidth: integer read FItemMinWidth write SetItemMinWidth default 0;
    property WheelEnable default true;
    property OnFrameKeyDown: TAdvFrameKeyEvent read FOnFrameKeyDown write FOnFrameKeyDown;
    property OnFrameCreate: TAdvFrameEvent read FOnFrameCreate write FOnFrameCreate;
    property OnFrameDestroy: TAdvFrameEvent read FOnFrameDestroy write FOnFrameDestroy;
    property OnFrameSelect: TAdvFrameEvent read FOnFrameSelect write FOnFrameSelect;
    property OnFrameUnSelect: TAdvFrameEvent read FOnFrameUnSelect write FOnFrameUnSelect;
  end;


implementation

uses
  Math;

{ TAdvFrameView }

procedure TAdvFrameView.AlignControls(AControl: TControl; var Rect: TRect);
begin
  inherited;
  if (csDesigning in ComponentState) then
    Invalidate;
end;

procedure TAdvFrameView.AppMessage(var Msg: TMsg; var Handled: boolean);
var
  i: integer;
  Key: word;
  ss: TShiftState;
  KeyState: TKeyboardState;
begin
  inherited;

  if (csDesigning in ComponentState) then
    Exit;

  if Msg.message = WM_LBUTTONUP then
  begin
    for i := 0 to FrameCount - 1 do
    begin
      if (Length(FFrames) > i) and Assigned(FFrames[i]) and (FFrames[i].Handle = Msg.hwnd) then
      begin
        ItemIndex := i;
        break;
      end;
    end;
  end;

  if Msg.message = WM_KEYDOWN then
  begin
     if (Msg.wParam in [VK_DOWN, VK_UP, VK_LEFT, VK_RIGHT, VK_HOME, VK_END]) then
     begin
       GetKeyboardState(KeyState);
       ss := KeyboardStateToShiftState(KeyState);

       if (nkShift in NavigateKeyStates) and not (ssShift in ss) then
         Exit;

       if (nkCtrl in NavigateKeyStates) and not (ssCtrl in ss) then
         Exit;

       if (nkAlt in NavigateKeyStates) and not (ssAlt in ss) then
         Exit;

       Key := Msg.wParam;
       DoFrameKeyDown(ItemIndex, Key, ss);

       if Key = 0 then
         Exit;
     end;

     if (Msg.wParam = VK_DOWN) then
     begin
       Msg.wParam := 0;
       Handled := true;

       if Columns = 1 then
       begin
         if (ItemIndex < FrameCount - 1) then
         begin
           ItemIndex := ItemIndex + 1;
           ScrollDown;
         end;
       end
       else
       begin
         if ItemIndex + VisibleColumns < FrameCount then
         begin
           ItemIndex := ItemIndex + VisibleColumns;
           ScrollDown;
         end;
       end;
     end;

     if (Msg.wParam = VK_UP) then
     begin
       Msg.wParam := 0;
       Handled := true;

       if VisibleColumns = 1 then
       begin
         if ItemIndex > 0  then
         begin
           ItemIndex := ItemIndex - 1;
           ScrollUp;
         end;
       end
       else
       begin
         if ItemIndex >= VisibleColumns then
         begin
           ItemIndex := ItemIndex - VisibleColumns;
           ScrollUp;
         end;
       end;
     end;

     if (Msg.wParam = VK_LEFT) then
     begin
       Msg.wParam := 0;
       Handled := true;

       if Rows = 1 then
       begin
         if ItemIndex > 0 then
         begin
           ItemIndex := ItemIndex - 1;
           ScrollLeft;
         end;
       end
       else
       begin
         if (ItemIndex mod VisibleColumns <> 0) and (ItemIndex > 0) then
         begin
           ItemIndex := ItemIndex - 1;
           ScrollLeft;
         end;
       end;
     end;

     if (Msg.wParam = VK_RIGHT) then
     begin
       Msg.wParam := 0;
       Handled := true;

       if Rows = 1 then
       begin
         if ItemIndex < FrameCount - 1 then
         begin
           ItemIndex := ItemIndex + 1;
           ScrollRight;
         end;
       end
       else
       begin
         if ((ItemIndex + 1) mod VisibleColumns <> 0) and (ItemIndex + 1 < FrameCount) then
         begin
           ItemIndex := ItemIndex + 1;
           ScrollRight;
         end;
       end;
     end;

     if (Msg.wParam = VK_HOME) then
     begin
       Msg.wParam := 0;
       Handled := true;
       ItemIndex := 0;
       ScrollInView;
     end;

     if (Msg.wParam = VK_END) then
     begin
       Msg.wParam := 0;
       Handled := true;
       ItemIndex := FrameCount - 1;
       ScrollInView;
     end;

  end;
end;


{$IFNDEF DELPHIXE10_LVL}
procedure TAdvFrameView.ChangeScale(M, D: Integer);
{$ENDIF}
{$IFDEF DELPHIXE10_LVL}
procedure TAdvFrameView.ChangeScale(M, D: Integer; isDpiChange: Boolean);
{$ENDIF}
begin
  inherited;

  ItemMinWidth := MulDiv(ItemMinWidth, M, D);
  ItemHeight := MulDiv(ItemHeight, M, D);
  ItemWidth := MulDiv(ItemWidth, M, D);
  Padding.Left := MulDiv(Padding.Left, M, D);
  Padding.Right := MulDiv(Padding.Right, M, D);
  Padding.Top := MulDiv(Padding.Top, M, D);
  Padding.Bottom := MulDiv(Padding.Bottom, M, D);

  FFrameHeight := 0;
end;

procedure TAdvFrameView.CMControlChange(var Message: TCMControlChange);
begin
  if (csDesigning in ComponentState) and not (csLoading in ComponentState) then
  begin
    if Assigned(Message.Control) and (Message.Inserting) then
    begin
      if (Message.Control is TFrame) and (FrameClass = nil) then // only one frame was inserted
      begin
        FFrameClass := TFrameClass((Message.Control as TFrame).ClassType);
        FFrameHeight := (Message.Control as TFrame).Height;
        FFrameWidth := (Message.Control as TFrame).Width;
        Invalidate;
      end;
    end;
  end;
end;

constructor TAdvFrameView.Create(AOwner: TComponent);
begin
  inherited;

  FDesignTime := (csDesigning in ComponentState) and not
    ((csReading in Owner.ComponentState) or (csLoading in Owner.ComponentState));

  FItemHeight := 0;
  FItemWidth := 0;
  FItemIndex := -1;
  FItemCount := 0;
  FRows := 10;
  FColumns := 1;
  Width := 300;
  Height := 300;
  FFrameClass := nil;
  VertScrollBar.Tracking := true;
  HorzScrollBar.Tracking := true;
  WheelEnable := true;
//  Ctl3D := false;
  FFrameCreation := fcInView;
  FAppEvents := nil;

  FBackground := TAdvFrameViewBackground.Create(Self);
  FBackground.Parent := Self;
  FBackground.OnPaint := PaintBackground;

  if not (csDesigning in ComponentState) then
  begin
    FAppEvents := TApplicationEvents.Create(Self);
    FAppEvents.OnMessage := AppMessage;
  end;
end;

procedure TAdvFrameView.CreateWnd;
begin
  inherited;
  BuildFrames;
//  Ctl3D := false;
end;

destructor TAdvFrameView.Destroy;
begin
  if Assigned(FBackground) then
    FBackground.Free;
  if Assigned(FAppEvents) then
    FAppEvents.Free;
  inherited;
end;

procedure TAdvFrameView.DoCreateFrame(AIndex: integer; AFrame: TFrame);
begin
  if Assigned(OnFrameCreate) then
    OnFrameCreate(Self, AIndex, AFrame);
end;

procedure TAdvFrameView.DoDestroyFrame(AIndex: integer; AFrame: TFrame);
begin
  if Assigned(OnFrameDestroy) then
    OnFrameDestroy(Self, AIndex, AFrame);

  FreeAndNil(AFrame);
  FFrames[AIndex] := nil;
end;

procedure TAdvFrameView.DoFrameKeyDown(AFrameIndex: integer; var AKey: word; AShiftState: TShiftState);
var
  ctrl: TControl;
begin
  ctrl := nil;
  if Assigned(Screen) then
    ctrl := Screen.ActiveControl;

  if Assigned(OnFrameKeyDown) then
    OnFrameKeyDown(Self, AKey, AShiftState, AFrameIndex, ctrl);
end;

procedure TAdvFrameView.DoSelectFrame(AIndex: integer; AFrame: TFrame);
begin
  if Assigned(OnFrameSelect) then
    OnFrameSelect(Self, AIndex, AFrame);
end;

procedure TAdvFrameView.DoUnSelectFrame(AIndex: integer; AFrame: TFrame);
begin
  if Assigned(OnFrameUnSelect) then
    OnFrameUnSelect(Self, AIndex, AFrame);
end;

procedure TAdvFrameView.FocusChanged(var MSG: TCMFocusChanged);
var
  p: TWinControl;
  i: integer;
  fc: TFrameClass;
begin
  inherited;

  if (csDesigning in ComponentState) then
    Exit;

  p := Msg.Sender;

  if Assigned(FrameClass) then
    fc := FrameClass
  else
    fc := TFrame;

  while Assigned(p) do
  begin
    if (p is fc) then
    begin
      i := IndexOf(p as TFrame);
      if i >= 0 then
        ItemIndex := i;
      break;
    end;

    p := p.Parent;
  end;
end;

function TAdvFrameView.FrameCount: integer;
begin
  Result := GetFrameCount
end;

function TAdvFrameView.GetFrameCount: integer;
begin
  if Columns = 1 then
    Result := Rows
  else
  if Rows = 1 then
    Result := Columns
  else
    Result := ItemCount;
end;

function TAdvFrameView.IndexOf(AFrame: TFrame): integer;
var
  i: integer;
begin
  Result := -1;

  if Assigned(AFrame) then
    for i := 0 to FrameCount - 1 do
    begin
      if (Length(FFrames) > i) and (FFrames[i] = AFrame) then
      begin
        Result := i;
        Break;
      end;
    end;
end;

function TAdvFrameView.GetFrame(Index: integer): TFrame;
begin
  if (Index >= 0) and (Index < Length(FFrames)) then
  begin
    Result := FFrames[Index];
  end
  else
    raise Exception.Create('Frame index out of bounds');
end;


function TAdvFrameView.GetFrameHeight: integer;
begin
  if ItemHeight <> 0 then
    Result := ItemHeight
  else
    Result := FFrameHeight;

  if Result = 0 then
    Result := 1;
end;

procedure TAdvFrameView.GetFrameRange(var FromIndex, ToIndex: integer);
var
  f: TFrame;
begin
  if Columns = 1 then
  begin
    if (FFrameHeight = 0) and Assigned(FrameClass) then
    begin
      f := FrameClass.Create(Self);
      FFrameHeight := f.Height;
      f.Free;
    end;

    FromIndex := VertScrollBar.Position div (GetFrameHeight + Padding.Top);
    ToIndex := Min(Rows - 1, FromIndex + (1 + (ClientHeight div (GetFrameHeight + Padding.Top))));
  end
  else
  if Rows = 1 then
  begin
    if (FFrameWidth = 0) and Assigned(FrameClass) then
    begin
      f := FrameClass.Create(Self);
      FFrameWidth := f.Width;
      f.Free;
    end;

    FromIndex := HorzScrollBar.Position div (GetFrameWidth + Padding.Left);
    ToIndex := Min(Columns - 1, FromIndex + (1 + (ClientWidth div (GetFrameWidth + Padding.Left))));
  end
  else
  begin
    if Assigned(FrameClass) and ((FFrameWidth = 0) or (FFrameheight = 0)) then
    begin
      f := FrameClass.Create(Self);
      try
        if FFrameWidth = 0 then FFrameWidth := f.Width;
        if FFrameHeight = 0 then FFrameHeight := f.Height;
      finally
        f.Free;
      end;
    end;

    if (Columns = 0) and (Rows = 0) then
    begin
      FromIndex := 0;
      ToIndex := ItemCount - 1;
    end;

  end;
end;

function TAdvFrameView.GetFrameWidth: integer;
begin
  if ItemWidth <> 0 then
    Result := ItemWidth
  else
    Result := FFrameWidth;

  if Result = 0 then
    Result := 1;
end;

procedure TAdvFrameView.Loaded;
var
  i: integer;
begin
  inherited;

  if (FrameClass = nil) then
  begin
    for  i := 0 to ControlCount - 1 do
    begin
      if (Controls[i] is TFrame) then
      begin
        FrameClass := TFrameClass(Controls[i].ClassType);
        FFrameHeight := (Controls[i] as TFrame).Height;
        FFrameWidth := (Controls[i] as TFrame).Width;

        BuildFrames;

        if not (csDesigning in ComponentState) then
          Controls[i].Free;
        break;
      end;
    end;
  end;
end;

procedure TAdvFrameView.BuildFrames(AParam: boolean = false);
var
  i,j,c,idx: integer;
  ff,ft,bkgh,bkgw: integer;
  LVisibleColumns, LVisibleRows: integer;
  LRealWidth: integer;
  LCreated: boolean;
  R,IR,CR: TRect;

begin
  if not HandleAllocated then
    Exit;

  if (csDesigning in ComponentState) then
  begin
    FBackground.Width := ClientWidth;
    FBackground.Height := ClientHeight;
    Invalidate;
    Exit;
  end;

  if (FrameCreation <> fcAll) then
    GetFrameRange(ff,ft)
  else
  begin
    ff := 0;
    ft := FrameCount;
  end;

  if (ff > ItemIndex) and (ItemIndex >= 0) then
    ff := ItemIndex;
  if (ft < ItemIndex) and (ItemIndex >= 0) then
    ft := ItemIndex;

  if (Columns = 1) and (ItemMinWidth = 0) then
  begin
    if Assigned(FBackground) then
    begin
      FBackground.Width := ClientWidth;
      FBackground.Height := Max(ClientHeight, Padding.Top + (GetFrameHeight + Padding.Bottom) * Rows);
    end;

    HorzScrollBar.Visible := false;
    VertScrollBar.Visible := true;

    if Assigned(FrameClass) then
    begin
      SetLength(FFrames, Rows);

      if FrameCreation = fcInView then
      begin
        i := 0;
        while i < FrameCount do
        begin
          if i = ff then
            i := ft
          else if Assigned(FFrames[i]) then
            DoDestroyFrame(i, FFrames[i]);
          inc(i);
        end;
      end;

      for i := ff to ft do
      begin
        if not Assigned(FFrames[i]) then
        begin
          FFrames[i] := FrameClass.Create(Self);
          FFrames[i].Left := Padding.Left;
          FFrames[i].Top := Padding.Top + (i * (GetFrameHeight + Padding.Bottom) ) - VertScrollBar.Position;
          FFrames[i].Name := '';
          FFrames[i].Parent := Self;
          DoCreateFrame(i, FFrames[i]);
        end;
        FFrames[i].Width := ClientWidth - Padding.Left - Padding.Right;
        FFrames[i].Height := GetFrameHeight;
      end;
    end;
  end
  else
  if Rows = 1 then
  begin
    if Assigned(FBackground) then
    begin
      FBackground.Height := ClientHeight;
      FBackground.Width := Max(ClientWidth, Padding.Left + (GetFrameWidth + Padding.Right) * Columns);
    end;
    VertScrollBar.Visible := false;
    HorzScrollBar.Visible := true;
    if Assigned(FrameClass) then
    begin
      SetLength(FFrames, Columns);

      if FrameCreation = fcInView then
      begin
        i := 0;
        while i < FrameCount do
        begin
          if i = ff then
            i := ft
          else if Assigned(FFrames[i]) then
            DoDestroyFrame(i, FFrames[i]);
          inc(i);
        end;
      end;

      for i := ff to ft do
      begin
        if not Assigned(FFrames[i]) then
        begin
          FFrames[i] := FrameClass.Create(Self);
          FFrames[i].Top := Padding.Top;
          FFrames[i].Left := Padding.Left + (i * (GetFrameWidth + Padding.Right)) - HorzScrollBar.Position;
          FFrames[i].Name := '';
          FFrames[i].Parent := Self;
          DoCreateFrame(i, FFrames[i]);
        end;
        FFrames[i].Height := ClientHeight - Padding.Top - Padding.Bottom;
        FFrames[i].Width := GetFrameWidth;
      end;
    end;
  end
  else
  begin
    if Assigned(FBackground) and not Assigned(FrameClass) then
    begin
      FBackground.Height := Max(ClientHeight, GetFrameHeight * Rows);
      FBackground.Width := Max(ClientWidth, GetFrameWidth * Columns);
    end;

    VertScrollBar.Visible := true;
    HorzScrollBar.Visible := true;

    if Assigned(FrameClass) then
    begin
      c := 0;

      LVisibleColumns := Columns;
      LVisibleRows := Rows;
      LRealWidth := GetFrameWidth;

      if ItemMinWidth <> 0 then
      begin
        LVisibleColumns := (ClientWidth - Padding.Left) div (ItemMinWidth + Padding.Right);
        if LVisibleColumns <= 1 then
          LVisibleColumns := 1;
        LVisibleRows := ItemCount div LVisibleColumns;
        if ItemCount mod LVisibleColumns <> 0 then
         inc(LVisibleRows);
        LRealWidth := ItemMinWidth;
      end;

      SetLength(FFrames, LVisibleColumns * LVisibleRows);

      if Assigned(FBackground) then
      begin
        bkgh := Padding.Top + (GetFrameHeight + Padding.Bottom) * LVisibleRows;
        bkgw := Padding.Left + (LRealWidth + Padding.Right) * LVisibleColumns;

        if (FBackground.Height <> bkgh) or (FBackground.Width <> bkgw) then
        begin
          FBackground.Height := bkgh;
          FBackground.Width := bkgw;
          VertScrollBar.Visible := false;
          HorzScrollBar.Visible := false;
          VertScrollBar.Visible := true;
          HorzScrollBar.Visible := true;
        end;
      end;

      for j := 0 to LVisibleRows - 1 do
      begin
        for i := 0 to LVisibleColumns - 1 do
        begin
          idx := i + j * LVisibleColumns;

          if c >= ItemCount then
            Continue;

          R.Top := Padding.Top + (j * (GetFrameHeight + Padding.Bottom));
          R.Left := Padding.Left + (i * (LRealWidth + Padding.Right));
          R.Bottom := R.Top + GetFrameHeight;
          R.Right := R.Left + LRealWidth;

          CR := ClientRect;
          OffsetRect(CR, +HorzScrollBar.Position, +VertScrollBar.Position);

          IntersectRect(IR, R, CR);

          if (IR.Left = 0) and (IR.Right = 0) and (IR.Bottom = 0) and (IR.Top = 0) and (FrameCreation = fcDynamic) then
            Continue;

          LCreated := false;
          if not Assigned(FFrames[idx]) then
          begin
            FFrames[idx] := FrameClass.Create(Self);
            FFrames[idx].Name := '';
            LCreated := true;
          end;

          if LCreated or (ItemMinWidth <> 0) then
          begin
            FFrames[idx].Top := r.Top - VertScrollBar.Position;
            FFrames[idx].Left := r.Left - HorzScrollBar.Position;
            FFrames[idx].Height := GetFrameHeight;
            FFrames[idx].Width := LRealWidth;
            FFrames[idx].Parent := Self;
            if LCreated then
              DoCreateFrame(idx, FFrames[idx]);
          end;

          inc(c);
        end;
      end;
    end;
  end;
end;

procedure TAdvFrameView.PaintBackground(Sender: TObject);
var
  i,j: integer;
begin
  {
  FBackground.Canvas.Pen.Color := clRed;
  FBackground.Canvas.Pen.Style := psSolid;
  FBackground.Canvas.Pen.Width := 1;
  FBackground.Canvas.MoveTo(0,0);
  FBackground.Canvas.LineTo(Width,FBackground.Height);
  FBackground.Canvas.TextOut(0,0, FBackground.Width.ToString+':'+FBackground.Height.ToString);
  outputdebugstring(pchar(FBackground.Width.ToString+':'+FBackground.Height.ToString));
  if Assigned(FFrameClass) then
    FBackground.Canvas.TextOut(0,20, FFrameClass.ClassName);
  }

  if not Assigned(FBackground) then
    Exit;

  if FFrameClass = nil then
    Exit;

  if not (csDesigning in ComponentState) then
    Exit;

 // if (ItemHeight = 0) or (ItemWidth = 0) then
 //   Exit;

  FBackground.Canvas.Pen.Color := clGray;
  FBackground.Canvas.Pen.Style := psSolid;
  FBackground.Canvas.Pen.Width := 1;

  if Columns = 1 then
  begin
    for i := 0 to Rows - 1 do
    begin
      FBackground.Canvas.MoveTo(0, i * GetFrameHeight);
      FBackground.Canvas.LineTo(Width, i * GetFrameHeight);
    end;
  end
  else
  if Rows = 1 then
  begin
    for i := 0 to Columns - 1 do
    begin
      FBackground.Canvas.MoveTo(i * GetFrameWidth, 0);
      FBackground.Canvas.LineTo(i * GetFrameWidth, Height);
    end;
  end
  else
  begin
    for i := 0 to Rows - 1 do
    begin
      for j := 0 to Columns - 1 do
      begin
        FBackground.Canvas.Rectangle(Padding.Left + j * (GetFrameWidth + Padding.Right), Padding.Top + (i * (GetFrameHeight + Padding.Bottom)),
                                     Padding.Left + j * (GetFrameWidth + Padding.Right) + GetFrameWidth, Padding.Top + i  * (GetFrameHeight + Padding.Bottom) + GetFrameHeight);
      end;
    end;
  end;
end;

procedure TAdvFrameView.Resize;
begin
  inherited;

  if not Assigned(FFrameClass) then
  begin
    FBackground.Width := ClientWidth;
    FBackground.Height := ClientHeight;
  end;

  BuildFrames;
end;

procedure TAdvFrameView.ScrollChange;
begin
  inherited;
  BuildFrames(true);
end;

procedure TAdvFrameView.ScrollDown;
begin
  if ((Columns = 1) or ((Columns <> 1) and (Rows <> 1))) and (ItemIndex < FrameCount) and Assigned(FFrames[ItemIndex]) then
  begin
    if FFrames[ItemIndex].Top + GetFrameHeight > Height then
    begin
      VertScrollBar.Position := VertScrollBar.Position + GetFrameHeight;
      ScrollChange;
    end;
  end;
end;

procedure TAdvFrameView.ScrollInView;
begin
  if (Columns = 1) and (ItemIndex >= 0) then
  begin
    VertScrollBar.Position  := ItemIndex * GetFrameHeight;
    ScrollChange;
    SetItemIndex(FItemIndex);
  end;
end;

procedure TAdvFrameView.ScrollLeft;
begin
  if ((Rows = 1) or ((Rows <> 1) and (Columns <> 1))) and (ItemIndex >= 0) and Assigned(FFrames[ItemIndex]) then
  begin
     if FFrames[ItemIndex].Left < 0 then
     begin
       HorzScrollBar.Position := HorzScrollBar.Position - GetFrameWidth;
       ScrollChange;
     end;
  end;
end;

procedure TAdvFrameView.ScrollRight;
begin
  if ((Rows = 1) or ((Rows <> 1) and (Columns <> 1))) and (ItemIndex < FrameCount) and Assigned(FFrames[ItemIndex]) then
  begin
    if FFrames[ItemIndex].Left + GetFrameWidth > Width then
    begin
      HorzScrollBar.Position := HorzScrollBar.Position + GetFrameWidth;
      ScrollChange;
    end;
  end;
end;

procedure TAdvFrameView.ScrollUp;
begin
  if ((Columns = 1) or ((Columns <> 1) and (Rows <> 1)))  and (ItemIndex >= 0) and Assigned(FFrames[ItemIndex]) then
  begin
     if FFrames[ItemIndex].Top < 0 then
     begin
       VertScrollBar.Position := VertScrollBar.Position - GetFrameHeight;
       ScrollChange;
     end;
  end;
end;

procedure TAdvFrameView.SetColumns(const Value: integer);
begin
  if FColumns <= 0 then
    Exit;

  FColumns := Value;
  BuildFrames;
end;

procedure TAdvFrameView.SetFrameClass(const Value: TFrameClass);
begin
  FFrameClass := Value;
  FFrameHeight := 0;
  FFrameWidth := 0;
  BuildFrames;
end;

procedure TAdvFrameView.SetItemCount(const Value: integer);
begin
  if (FItemCount <> Value) then
  begin
    FItemCount := Value;
  end;
end;

procedure TAdvFrameView.SetItemHeight(const Value: integer);
begin
  FItemHeight := Value;
  BuildFrames;
end;

procedure TAdvFrameView.SetItemIndex(const Value: integer);
begin
  // unselect old
  if(FItemIndex >= 0) and Assigned(FFrames[FItemIndex]) then
  begin
    if Supports(FFrames[FItemIndex],IAdvListFrame) then
       (FFrames[FItemIndex] as IAdvListFrame).UnSelect;

    DoUnSelectFrame(FItemIndex, FFrames[FItemIndex]);
  end;

  FItemIndex := Value;

  // select new
  if(FItemIndex >= 0) and not Assigned(FFrames[FItemIndex]) then
  begin
    BuildFrames;
  end;

  if(FItemIndex >= 0) and Assigned(FFrames[FItemIndex]) then
  begin
    if Supports(FFrames[FItemIndex],IAdvListFrame) then
       (FFrames[FItemIndex] as IAdvListFrame).Select;

    DoSelectFrame(FItemIndex, FFrames[FItemIndex]);
  end;
end;

procedure TAdvFrameView.SetItemMinWidth(const Value: integer);
begin
  if (Value >= 0) then
  begin
    FItemMinWidth := Value;
    BuildFrames;
  end;
end;

procedure TAdvFrameView.SetItemWidth(const Value: integer);
begin
  if (Value >= 0) then
  begin
    FItemWidth := Value;
    BuildFrames;
  end;
end;

procedure TAdvFrameView.SetRows(const Value: integer);
begin
  if FRows <= 0 then
    Exit;
  FRows := Value;
  BuildFrames;
end;

function TAdvFrameView.VisibleColumns: integer;
begin
  Result := Columns;
  if (Columns <> 1) and (Rows <> 1) and (ItemMinWidth <> 0) then
  begin
    Result := ClientWidth div ItemMinWidth;
  end;
end;

{ TAdvFrameViewBackground }

procedure TAdvFrameViewBackground.Paint;
var
  r: TRect;
begin
  r := ClientRect;
  Canvas.Brush.Color := (Parent as TAdvFrameView).Color;
  Canvas.Pen.Color := Canvas.Brush.Color;
  Canvas.Brush.Style := bsSolid;
  Canvas.Rectangle(r);

  inherited;
end;


end.
