unit uEntityEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, dxLayoutControlAdapters, dxLayoutContainer,
  Vcl.StdCtrls, cxButtons, cxClasses, dxLayoutControl, dxForms,
  dxLayoutLookAndFeels, dxLayoutcxEditAdapters, cxContainer, cxEdit,
  Vcl.ComCtrls, dxCore, cxDateUtils, cxMaskEdit, cxDropDownEdit, cxCalendar,
  cxTextEdit,
  dxEMF.Types, dxEMF.Attributes;

type
  TPhotoViewerEntity = class;
  TPhotoViewerEntityClass = class of TPhotoViewerEntity;

  { TEntityEditor }

  TEntityEditorClass = class of TEntityEditor;
  TEntityEditor = class(TdxForm)
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    btnOk: TcxButton;
    dxLayoutItem1: TdxLayoutItem;
    btnCancel: TcxButton;
    dxLayoutItem2: TdxLayoutItem;
    dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup;
    dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList;
    dxLayoutCxLookAndFeel1: TdxLayoutCxLookAndFeel;
    teCaption: TcxTextEdit;
    deDate: TcxDateEdit;
    dxLayoutItem3: TdxLayoutItem;
    dxLayoutItem4: TdxLayoutItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure teCaptionPropertiesChange(Sender: TObject);
  private
    FEntity: TPhotoViewerEntity;
    FLockCount: Integer;
    class function DoShowEditor(ALookAndFeel: TcxLookAndFeel; AEntity: TPhotoViewerEntity; AEditing: Boolean): TModalResult;
  protected
    function CanApplyChanges: Boolean; virtual;
    procedure Initialize(AEditing: Boolean); virtual;
    procedure SaveEntity; virtual;

    function Locked: Boolean;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure UpdateControls;

    property Entity: TPhotoViewerEntity read FEntity;
  public
    constructor Create(AOwner: TComponent; AEntity: TPhotoViewerEntity; AEditing: Boolean); reintroduce;

    class function Add(ALookAndFeel: TcxLookAndFeel; AEntityClass: TPhotoViewerEntityClass): TPhotoViewerEntity;
    class procedure Edit(ALookAndFeel: TcxLookAndFeel; AEntity: TPhotoViewerEntity);
  end;

  { TPhotoViewerEntity }

  [Entity]
  [DiscriminatorColumn('DISCRIMINATOR', TdxDiscriminatorType.Integer)]
  [Discriminator(0)]
  [Table('PhotoViewerEntity')]
  TPhotoViewerEntity = class
  private
    [Column('ID'), Generator(TdxGeneratorType.Identity), Key, Unique]
    FID: Int64;
    FCaption: string;
    FDate: TDate;
    procedure SetCaption(const AValue: string);
  public
    constructor Create; virtual;
    class function GetEntityCaption: string; virtual;
    class function GetEditorClass: TEntityEditorClass; virtual;

    property ID: Int64 read FID write FID;
    [Column('Caption')]
    property Caption: string read FCaption write SetCaption;
    [Column('Date')]
    property Date: TDate read FDate write FDate;
  end;

implementation

{$R *.dfm}

uses
  PhotoViewerClasses;

{ TEntityEditor }

constructor TEntityEditor.Create(AOwner: TComponent; AEntity: TPhotoViewerEntity; AEditing: Boolean);
begin
  inherited Create(AOwner);
  FEntity := AEntity;
  Initialize(AEditing);
  UpdateControls;
end;

function TEntityEditor.CanApplyChanges: Boolean;
begin
  Result := teCaption.Text <> '';
end;

procedure TEntityEditor.Initialize(AEditing: Boolean);
begin
  FLockCount := 0;
  if AEditing then
  begin
    btnOk.Caption := 'Apply';
    Caption := 'Edit ' + FEntity.GetEntityCaption;
  end
  else
  begin
    btnOk.Caption := 'OK';
    Caption := 'Add ' + FEntity.GetEntityCaption;
  end;
  teCaption.Text := FEntity.Caption;
  deDate.EditValue := FEntity.Date;
end;

procedure TEntityEditor.SaveEntity;
begin
  FEntity.Caption := teCaption.Text;
  FEntity.Date := deDate.Date;
end;

function TEntityEditor.Locked: Boolean;
begin
  Result := FLockCount <> 0;
end;

procedure TEntityEditor.BeginUpdate;
begin
  Inc(FLockCount);
end;

procedure TEntityEditor.EndUpdate;
begin
  Dec(FLockCount);
end;

procedure TEntityEditor.teCaptionPropertiesChange(Sender: TObject);
begin
  UpdateControls;
end;

procedure TEntityEditor.UpdateControls;
begin
  btnOk.Enabled := CanApplyChanges;
end;

class function TEntityEditor.Add(ALookAndFeel: TcxLookAndFeel; AEntityClass: TPhotoViewerEntityClass): TPhotoViewerEntity;
begin
  Result := AEntityClass.Create;
  if DoShowEditor(ALookAndFeel, Result, False) = mrCancel then
    FreeAndNil(Result);
end;

class procedure TEntityEditor.Edit(ALookAndFeel: TcxLookAndFeel; AEntity: TPhotoViewerEntity);
begin
  DoShowEditor(ALookAndFeel, AEntity, True);
end;

procedure TEntityEditor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrOk then
    SaveEntity;
end;

procedure TEntityEditor.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

class function TEntityEditor.DoShowEditor(ALookAndFeel: TcxLookAndFeel; AEntity: TPhotoViewerEntity;
  AEditing: Boolean): TModalResult;
var
  AForm: TEntityEditor;
begin
  AForm := AEntity.GetEditorClass.Create(nil, AEntity, AEditing);
  try
    SetControlLookAndFeel(AForm, ALookAndFeel);
    Result := AForm.ShowModal;
  finally
    AForm.Free;
  end;
end;

{ TPhotoViewerEntity }

constructor TPhotoViewerEntity.Create;
begin
  inherited Create;
  FDate := SysUtils.Date;
end;

class function TPhotoViewerEntity.GetEntityCaption: string;
begin
  Result := '';
end;

class function TPhotoViewerEntity.GetEditorClass: TEntityEditorClass;
begin
  Result := TEntityEditor;
end;

procedure TPhotoViewerEntity.SetCaption(const AValue: string);
begin
  FCaption := Copy(AValue, 1, 100);
end;

end.
