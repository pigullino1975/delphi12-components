unit dxFrames;

interface

uses
  Controls, Classes, dxCustomFrame, dxRibbon;

type
  TdxFrameInfo = class
  private
    FCaption: string;
    FCustomFrameClass: TdxFrameClass;
    FFrame: TfrmCustomFrame;
    FID: Integer;
    FSideBarFirstAdditionalGroupIndex: Integer;
    FSideBarGroupIndex: Integer;
    FSideBarSecondAdditionalGroupIndex: Integer;
    function GetActive: Boolean;
  protected
    property Frame: TfrmCustomFrame read FFrame;
  public
    constructor Create(ID: Integer; ClassType: TdxFrameClass; Caption: string;
      SideBarGroupIndex1, SideBarGroupIndex2, SideBarGroupIndex3: Integer);
    procedure CreateFrame(AOwner: TComponent; ARibbon: TdxRibbon);
    procedure DestroyFrame;
    procedure HideFrame;
    procedure ShowFrame(AParent: TWinControl; ARibbon: TdxRibbon);

    property Active: Boolean read GetActive;
    property Caption: string read FCaption;
    property ID: Integer read FID write FID;
    property SideBarGroupIndex: Integer read FSideBarGroupIndex;
    property SideBarFirstAdditionalGroupIndex: Integer read FSideBarFirstAdditionalGroupIndex;
    property SideBarSecondAdditionalGroupIndex: Integer read FSideBarSecondAdditionalGroupIndex;
  end;

  TdxFrameManager = class
  private
    FActiveFrameInfo: TdxFrameInfo;
    FFrameInfoList: TList;
    function GetActiveFrame: TfrmCustomFrame;
    function GetActiveFrameId: Integer;
    function GetCount: Integer;
    function GetItem(Index: Integer): TdxFrameInfo;
    procedure AddNewItem(ANewItem: TdxFrameInfo);
  protected
    constructor CreateInstance(ADummy: Integer = 0); //# fix W1029
    class function AccessInstance(Request: Integer): TdxFrameManager;

    function GetFrameInfoByID(FrameID: Integer): TdxFrameInfo;
  public
    constructor Create;
    destructor Destroy; override;
    class function Instance: TdxFrameManager;
    class procedure ReleaseInstance;

    procedure RegisterFrame(FrameID: Integer; ClassType: TdxFrameClass;
      Caption: string; SideBarGroupIndex1,
      SideBarGroupIndex2, SideBarGroupIndex3: Integer);
    procedure ShowFrame(FrameID: Integer; Parent: TWinControl; ARibbon: TdxRibbon);

    property ActiveFrame: TfrmCustomFrame read GetActiveFrame;
    property ActiveFrameID: Integer read GetActiveFrameId;
    property ActiveFrameInfo: TdxFrameInfo read FActiveFrameInfo;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TdxFrameInfo read GetItem; default;
  end;

function dxFrameManager: TdxFrameManager;

implementation

uses
  SysUtils, uStrsConst;

function dxFrameManager: TdxFrameManager;
begin
  Result := TdxFrameManager.Instance;
end;

{ TdxFrameInfo }

constructor TdxFrameInfo.Create(ID: Integer; ClassType: TdxFrameClass;
  Caption: string; SideBarGroupIndex1,
  SideBarGroupIndex2, SideBarGroupIndex3: Integer);
begin
  inherited Create;
  FID := ID;
  FCustomFrameClass := ClassType;
  FCaption := Caption;
  FSideBarFirstAdditionalGroupIndex := SideBarGroupIndex1;
  FSideBarGroupIndex := SideBarGroupIndex2;
  FSideBarSecondAdditionalGroupIndex := SideBarGroupIndex3;
end;

function TdxFrameInfo.GetActive: Boolean;
begin
  Result := Self = dxFrameManager.ActiveFrameInfo;
end;

procedure TdxFrameInfo.CreateFrame(AOwner: TComponent; ARibbon: TdxRibbon);
begin
  FFrame := FCustomFrameClass.Create(AOwner, ARibbon);
  FFrame.Caption := FCaption;
end;

procedure TdxFrameInfo.DestroyFrame;
begin
  FFrame.Free;
  FFrame := nil;
end;

procedure TdxFrameInfo.HideFrame;
begin
  FFrame.BeforeHide;
  FFrame.ChangeVisibility(False);
end;

procedure TdxFrameInfo.ShowFrame(AParent: TWinControl; ARibbon: TdxRibbon);
begin
  if not Assigned(FFrame) then
    CreateFrame(AParent, ARibbon);
  FFrame.Parent := AParent;
  FFrame.ChangeVisibility(True);
end;

{ TdxFrameManager }

constructor TdxFrameManager.Create;
begin
  inherited Create;
  raise Exception.CreateFmt(sdxCannotCreateSecondInstance, [ClassName]);
end;

destructor TdxFrameManager.Destroy;
var
  I: Integer;
begin
  if AccessInstance(0) = Self then AccessInstance(2);
  for I := 0 to Count - 1 do Items[I].Free;
  FFrameInfoList.Free;
  inherited Destroy;
end;

function TdxFrameManager.GetActiveFrame: TfrmCustomFrame;
begin
  if ActiveFrameInfo <> nil then
    Result := ActiveFrameInfo.Frame
  else
    Result := nil;
end;

function TdxFrameManager.GetActiveFrameId: Integer;
begin
  if ActiveFrameInfo <> nil then
    Result := ActiveFrameInfo.ID
  else
    Result := -1;
end;

function TdxFrameManager.GetCount: Integer;
begin
  Result := FFrameInfoList.Count;
end;

function TdxFrameManager.GetItem(Index: Integer): TdxFrameInfo;
begin
  Result := TdxFrameInfo(FFrameInfoList.Items[Index]);
end;

procedure TdxFrameManager.AddNewItem(ANewItem: TdxFrameInfo);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if Items[I].ID > ANewItem.ID then
    begin
      FFrameInfoList.Insert(I, Pointer(ANewItem));
      Exit;
    end;
  FFrameInfoList.Add(Pointer(ANewItem));
end;

constructor TdxFrameManager.CreateInstance(ADummy: Integer = 0);
begin
  inherited Create;
  FFrameInfoList := TList.Create;
end;

var
  FInstance: TdxFrameManager = nil;

class function TdxFrameManager.AccessInstance(Request: Integer): TdxFrameManager;
begin
  case Request of
    0: ;
    1: if not Assigned(FInstance) then FInstance := CreateInstance;
    2: FInstance := nil;
  else
    raise Exception.CreateFmt(sdxAccessCodeIsIllegal, [Request]);
  end;
  Result := FInstance;
end;

function TdxFrameManager.GetFrameInfoByID(FrameID: Integer): TdxFrameInfo;
var
  I: Integer;
begin
  for I := 0  to Count - 1 do
  begin
    Result := Items[I];
    if Items[I].ID = FrameID then Exit;
  end;
  Result := nil;
end;

class function TdxFrameManager.Instance: TdxFrameManager;
begin
  Result := AccessInstance(1);
end;

class procedure TdxFrameManager.ReleaseInstance;
begin
  AccessInstance(0).Free;
end;

procedure TdxFrameManager.RegisterFrame(FrameID: Integer;
  ClassType: TdxFrameClass; Caption: string; SideBarGroupIndex1, SideBarGroupIndex2, SideBarGroupIndex3: Integer);
var
  FI: TdxFrameInfo;
begin
  FI := TdxFrameInfo.Create(FrameID, ClassType, Caption,
    SideBarGroupIndex1, SideBarGroupIndex2, SideBarGroupIndex3);
  AddNewItem(FI);
end;

procedure TdxFrameManager.ShowFrame(FrameID: Integer; Parent: TWinControl; ARibbon: TdxRibbon);
var
  FrameInfo: TdxFrameInfo;
begin
  if ActiveFrameInfo <> nil then
    if ActiveFrameInfo.ID = FrameID then
      Exit
    else
      ActiveFrameInfo.HideFrame;
  FrameInfo := GetFrameInfoByID(FrameID);
  if FrameInfo <> nil then
  begin
    FrameInfo.ShowFrame(Parent, ARibbon);
    FActiveFrameInfo := FrameInfo;
  end;
end;

initialization

finalization
  TdxFrameManager.ReleaseInstance;

end.
