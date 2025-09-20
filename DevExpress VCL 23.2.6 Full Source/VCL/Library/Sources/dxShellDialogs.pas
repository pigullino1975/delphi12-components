{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressEditors                                           }
{                                                                    }
{           Copyright (c) 1998-2024 Developer Express Inc.           }
{           ALL RIGHTS RESERVED                                      }
{                                                                    }
{   The entire contents of this file is protected by U.S. and        }
{   International Copyright Laws. Unauthorized reproduction,         }
{   reverse-engineering, and distribution of all or any portion of   }
{   the code contained in this file is strictly prohibited and may   }
{   result in severe civil and criminal penalties and will be        }
{   prosecuted to the maximum extent possible under the law.         }
{                                                                    }
{   RESTRICTIONS                                                     }
{                                                                    }
{   THIS SOURCE CODE AND ALL RESULTING INTERMEDIATE FILES            }
{   (DCU, OBJ, DLL, ETC.) ARE CONFIDENTIAL AND PROPRIETARY TRADE     }
{   SECRETS OF DEVELOPER EXPRESS INC. THE REGISTERED DEVELOPER IS    }
{   LICENSED TO DISTRIBUTE THE EXPRESSEDITORS AND ALL                }
{   ACCOMPANYING VCL CONTROLS AS PART OF AN EXECUTABLE PROGRAM ONLY. }
{                                                                    }
{   THE SOURCE CODE CONTAINED WITHIN THIS FILE AND ALL RELATED       }
{   FILES OR ANY PORTION OF ITS CONTENTS SHALL AT NO TIME BE         }
{   COPIED, TRANSFERRED, SOLD, DISTRIBUTED, OR OTHERWISE MADE        }
{   AVAILABLE TO OTHER INDIVIDUALS WITHOUT EXPRESS WRITTEN CONSENT   }
{   AND PERMISSION FROM DEVELOPER EXPRESS INC.                       }
{                                                                    }
{   CONSULT THE END USER LICENSE AGREEMENT FOR INFORMATION ON        }
{   ADDITIONAL RESTRICTIONS.                                         }
{                                                                    }
{********************************************************************}

unit dxShellDialogs;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Windows, Classes, SysUtils, Forms, Dialogs, Controls, dxCore, cxClasses, cxLookAndFeels,
  dxShellCustomDialog, dxShellFilePreview;

const
  dxUseStandardShellDialogs: Boolean = False; 

type
  { TdxOpenFileDialog }

  TdxOpenFileDialog = class(TOpenDialog, IdxSkinSupport)
  strict private
    FForceFileSystem: Boolean;
    FHelper: TObject;
    //
    function GetLookAndFeel: TcxLookAndFeel;
    function GetOptionsPreview: TdxFileDialogPreviewOptions;
    procedure SetLookAndFeel(const AValue: TcxLookAndFeel);
    procedure SetOptionsPreview(const AValue: TdxFileDialogPreviewOptions);
  protected
    function CreateHelper: TObject; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    //
    function Execute(ParentWnd: HWND): Boolean; override;
    procedure AssignTo(ADest: TPersistent); override;
  published
    property ForceFileSystem: Boolean read FForceFileSystem write FForceFileSystem default False;
    property DefaultExt;
    property FileName;
    property Filter;
    property FilterIndex;
    property HelpContext;
    property InitialDir;
    property LookAndFeel: TcxLookAndFeel read GetLookAndFeel write SetLookAndFeel;
    property Options;
    property OptionsPreview: TdxFileDialogPreviewOptions read GetOptionsPreview write SetOptionsPreview;
    property Title;
    property OnCanClose;
    property OnClose;
    property OnFolderChange;
    property OnSelectionChange;
    property OnShow;
    property OnTypeChange;
    property OnIncludeItem;
  end;

  { TdxSaveFileDialog }

  TdxSaveFileDialog  = class(TSaveDialog, IdxSkinSupport)
  strict private
    FForceFileSystem: Boolean;
    FHelper: TObject;
    //
    function GetLookAndFeel: TcxLookAndFeel;
    function GetOptionsPreview: TdxFileDialogPreviewOptions;
    procedure SetLookAndFeel(const AValue: TcxLookAndFeel);
    procedure SetOptionsPreview(const AValue: TdxFileDialogPreviewOptions);
  protected
    function CreateHelper: TObject; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    //
    function Execute(ParentWnd: HWND): Boolean; override;
    procedure AssignTo(ADest: TPersistent); override;
  published
    property ForceFileSystem: Boolean read FForceFileSystem write FForceFileSystem default False;
    property DefaultExt;
    property FileName;
    property Filter;
    property FilterIndex;
    property HelpContext;
    property InitialDir;
    property LookAndFeel: TcxLookAndFeel read GetLookAndFeel write SetLookAndFeel;
    property Options;
    property OptionsPreview: TdxFileDialogPreviewOptions read GetOptionsPreview write SetOptionsPreview;
    property Title;
    property OnCanClose;
    property OnClose;
    property OnFolderChange;
    property OnSelectionChange;
    property OnShow;
    property OnTypeChange;
    property OnIncludeItem;
  end;

  { TdxOpenPictureDialog }

  TdxOpenPictureDialog = class(TdxOpenFileDialog)
  strict private
    function GetDefaultGraphicFilter: string;
    function IsFilterStored: Boolean;
  protected
    function CreateHelper: TObject; override;
  public
    constructor Create(AOwner: TComponent); override;
    function Execute(ParentWnd: HWND): Boolean; override;
  published
    property Filter stored IsFilterStored;
  end;

  { TdxSavePictureDialog }

  TdxSavePictureDialog = class(TdxSaveFileDialog)
  strict private
    function GetDefaultGraphicFilter: string;
    function IsFilterStored: Boolean;
  protected
    function CreateHelper: TObject; override;
  public
    constructor Create(AOwner: TComponent); override;
    function Execute(ParentWnd: HWND): Boolean; override;
  published
    property Filter stored IsFilterStored;
  end;

var
  OpenFileDialogFormClass: TdxfrmCommonFileCustomDialogClass = TdxfrmOpenFileDialog;
  SaveFileDialogFormClass: TdxfrmCommonFileCustomDialogClass = TdxfrmSaveFileDialog;

implementation

uses
  Math, Graphics, cxControls, cxGraphics, dxSmartImage, dxSVGImage;

const
  dxThisUnitName = 'dxShellDialogs';

const
  dxSVGImageExt = '.svg';

type
  TOpenDialogAccess = class(TOpenDialog);
  TdxFileDialogPreviewOptionsClass = class of TdxFileDialogPreviewOptions;

  { TdxCustomFileDialogHelper }

  TdxCustomFileDialogHelper = class
  strict private
    FDialogForm: TdxfrmCommonFileCustomDialog;
    FLookAndFeel: TcxLookAndFeel;
    FDialog: TOpenDialog;
    FOptionsPreview: TdxFileDialogPreviewOptions;
    //
    procedure SetLookAndFeel(const AValue: TcxLookAndFeel);
    //
    procedure CanClose(ASender: TObject; var ACanClose: Boolean);
    function ExecuteStandardDialog: Boolean;
    procedure FolderChange(ASender: TObject);
    procedure IncludeItem(const AOFN: TOFNotifyEx; var AInclude: Boolean);
    procedure SetOptionsPreview(const AValue: TdxFileDialogPreviewOptions);
    procedure SelectionChange(ASender: TObject);
    procedure TypeChange(ASender: TObject);
  strict protected
    procedure InitializeForm(AForm: TdxfrmCommonFileCustomDialog; ADialog: TOpenDialog); virtual;
  protected
    function CreateForm(AParentWnd: HWND): TdxfrmCommonFileCustomDialog; virtual; abstract;
    function CreateStandardDialog(AOwner: TComponent): TOpenDialog; virtual; abstract;
    procedure AssignPropertiesTo(ADialog: TOpenDialog); virtual;
    function GetPreviewOptionsClass: TdxFileDialogPreviewOptionsClass; virtual;
    //
    property Dialog: TOpenDialog read FDialog;
  public
    constructor Create(ADialog: TOpenDialog);
    destructor Destroy; override;
    //
    function Execute(AParentWnd: HWND): Boolean;
    procedure AssignTo(ADest: TPersistent);
    //
    property LookAndFeel: TcxLookAndFeel read FLookAndFeel write SetLookAndFeel;
    property OptionsPreview: TdxFileDialogPreviewOptions read FOptionsPreview write SetOptionsPreview;
  end;

  { TdxOpenFileDialogHelper }

  TdxOpenFileDialogHelper = class(TdxCustomFileDialogHelper)
  strict protected
    function CreateForm(AParentWnd: HWND): TdxfrmCommonFileCustomDialog; override;
    function CreateStandardDialog(AOwner: TComponent): TOpenDialog; override;
    procedure AssignPropertiesTo(ADialog: TOpenDialog); override;
    procedure InitializeForm(AForm: TdxfrmCommonFileCustomDialog; ADialog: TOpenDialog); override;

  end;

  { TdxSaveFileDialogHelper }

  TdxSaveFileDialogHelper = class(TdxCustomFileDialogHelper)
  strict protected
    function CreateForm(AParentWnd: HWND): TdxfrmCommonFileCustomDialog; override;
    function CreateStandardDialog(AOwner: TComponent): TOpenDialog; override;
    procedure AssignPropertiesTo(ADialog: TOpenDialog); override;
    procedure InitializeForm(AForm: TdxfrmCommonFileCustomDialog; ADialog: TOpenDialog); override;
  end;

  { TdxSVGFilePreview }

  TdxSVGFilePreview = class(TdxFilePreviewImageBasedHandler) 
  strict private
    FImage: TdxSVGImageHandle;
  protected
    function GetHeight: Integer; override;
    function GetWidth: Integer; override;
  public
    destructor Destroy; override;
    function Initialize: Boolean; override;
    procedure DrawPreview(ACanvas: TcxCanvas; const ABounds: TRect); override;
    function RunInThread: Boolean; override;
  end;

  { TdxPictureDialogPreviewOptions }

  TdxPictureDialogPreviewOptions = class(TdxFileDialogPreviewOptions)
  public
    constructor Create; override;
  published
    property Visible default bTrue;
  end;

  { TdxOpenPictureDialogHelper }

  TdxOpenPictureDialogHelper = class(TdxOpenFileDialogHelper)
  protected
    function GetPreviewOptionsClass: TdxFileDialogPreviewOptionsClass; override;
  end;

  { TdxSavePictureDialogHelper }

  TdxSavePictureDialogHelper = class(TdxSaveFileDialogHelper)
  protected
    function GetPreviewOptionsClass: TdxFileDialogPreviewOptionsClass; override;
  end;

function ApplicationMainHandle: HWND;
begin
  if Application.MainFormOnTaskBar and (Application.MainForm <> nil) then
    Result := Application.MainFormHandle
  else
    Result := Application.Handle;
end;

{ TdxCustomFileDialogHelper }

constructor TdxCustomFileDialogHelper.Create(ADialog: TOpenDialog);
begin
  inherited Create;
  FDialog := ADialog;
  FLookAndFeel := TcxLookAndFeel.Create(FDialog);
  FOptionsPreview := GetPreviewOptionsClass.Create;
end;

destructor TdxCustomFileDialogHelper.Destroy;
begin
  FreeAndNil(FOptionsPreview);
  FreeAndNil(FLookAndFeel);
  inherited Destroy;
end;

function TdxCustomFileDialogHelper.Execute(AParentWnd: HWND): Boolean;
begin
  if dxUseStandardShellDialogs or IsWinVista then
    Exit(ExecuteStandardDialog);

  FDialogForm := CreateForm(AParentWnd);
  try
    InitializeForm(FDialogForm, FDialog);
    TOpenDialogAccess(FDialog).DoShow;
    try
      Result := FDialogForm.ShowModal = mrOk;
      if Result then
      begin
        FDialog.FileName := FDialogForm.FileName;
        FDialog.Files.Assign(FDialogForm.Files);
        FDialog.HistoryList.AddStrings(FDialogForm.Files);
        FDialog.FilterIndex := FDialogForm.FilterIndex;
      end;
    finally
      TOpenDialogAccess(FDialog).DoClose;
    end;
  finally
    FreeAndNil(FDialogForm);
  end;
end;

procedure TdxCustomFileDialogHelper.AssignTo(ADest: TPersistent);
begin
  if ADest is TOpenDialog then
    AssignPropertiesTo(TOpenDialog(ADest));
end;

procedure TdxCustomFileDialogHelper.AssignPropertiesTo(ADialog: TOpenDialog);
begin
  ADialog.DefaultExt := FDialog.DefaultExt;
  ADialog.FileName := FDialog.FileName;
  ADialog.Filter := FDialog.Filter;
  ADialog.FilterIndex := FDialog.FilterIndex;
  ADialog.InitialDir := FDialog.InitialDir;
  ADialog.Options := FDialog.Options;
  ADialog.OptionsEx := FDialog.OptionsEx;
  ADialog.Title := FDialog.Title;
  ADialog.FileEditStyle := FDialog.FileEditStyle;
  ADialog.Files.Assign(FDialog.Files);
  ADialog.HistoryList.Assign(FDialog.HistoryList);
end;

function TdxCustomFileDialogHelper.GetPreviewOptionsClass: TdxFileDialogPreviewOptionsClass;
begin
  Result := TdxFileDialogPreviewOptions;
end;

procedure TdxCustomFileDialogHelper.InitializeForm(AForm: TdxfrmCommonFileCustomDialog; ADialog: TOpenDialog);
begin
  if not (ofEnableSizing in FDialog.Options) then
    FDialogForm.BorderStyle := bsSingle;
  FDialogForm.LookAndFeel.MasterLookAndFeel := LookAndFeel;
  if Assigned(FDialog.OnTypeChange) then
    FDialogForm.OnTypeChange := TypeChange;
  FDialogForm.InitializeFilter(FDialog.Filter, FDialog.FilterIndex);
  FDialogForm.DefaultExt := FDialog.DefaultExt;
  FDialogForm.SetHistoryList(FDialog.HistoryList);
  FDialogForm.ApplyLocalization;
  if FDialog.Title <> '' then
    FDialogForm.Title := FDialog.Title;
  if Assigned(FDialog.OnCanClose) then
    FDialogForm.OnFileOkClick := CanClose;
  if Assigned(FDialog.OnFolderChange) then
    FDialogForm.OnFolderChange := FolderChange;
  if Assigned(FDialog.OnIncludeItem) then
    FDialogForm.OnIncludeItem := IncludeItem;
  if Assigned(FDialog.OnSelectionChange) then
    FDialogForm.OnSelectionChange := SelectionChange;
  FDialogForm.Options := FDialog.Options;
  FDialogForm.FileName := FDialog.FileName;
  FDialogForm.InitializeFolder(FDialog.InitialDir);
  FDialogForm.SetPreviewOptions(OptionsPreview);
end;


procedure TdxCustomFileDialogHelper.SetLookAndFeel(const AValue: TcxLookAndFeel);
begin
  FLookAndFeel.Assign(AValue);
end;

procedure TdxCustomFileDialogHelper.SetOptionsPreview(const AValue: TdxFileDialogPreviewOptions);
begin
  FOptionsPreview.Assign(AValue);
end;

procedure TdxCustomFileDialogHelper.CanClose(ASender: TObject; var ACanClose: Boolean);
begin
  FDialog.FileName := FDialogForm.FileName;
  FDialog.Files.Assign(FDialogForm.Files);
  ACanClose := TOpenDialogAccess(FDialog).DoCanClose;
end;

function TdxCustomFileDialogHelper.ExecuteStandardDialog: Boolean;

  procedure AssignEventsTo(ADialog: TOpenDialog);
  begin
    ADialog.OnCanClose := FDialog.OnCanClose;
    ADialog.OnClose := FDialog.OnClose;
    ADialog.OnFolderChange := FDialog.OnFolderChange;
    ADialog.OnIncludeItem := FDialog.OnIncludeItem;
    ADialog.OnSelectionChange := FDialog.OnSelectionChange;
    ADialog.OnShow := FDialog.OnShow;
    ADialog.OnTypeChange := FDialog.OnTypeChange;
  end;

var
  ADialog: TOpenDialog;
begin
  ADialog := CreateStandardDialog(FDialog.Owner);
  try
    ADialog.Assign(FDialog);
    AssignEventsTo(ADialog);
    Result := ADialog.Execute();
    if Result then
    begin
      FDialog.FileName := ADialog.FileName;
      FDialog.Files.Assign(ADialog.Files);
      FDialog.HistoryList.AddStrings(ADialog.Files);
      FDialog.FilterIndex := ADialog.FilterIndex;
    end;
  finally
    ADialog.Free;
  end;
end;

procedure TdxCustomFileDialogHelper.FolderChange(ASender: TObject);
begin
  FDialog.FileName := FDialogForm.FileName;
  FDialog.Files.Assign(FDialogForm.Files);
  TOpenDialogAccess(FDialog).DoFolderChange;
end;

procedure TdxCustomFileDialogHelper.IncludeItem(const AOFN: TOFNotifyEx; var AInclude: Boolean);
begin
  TOpenDialogAccess(FDialog).DoIncludeItem(AOFN, AInclude);
end;

procedure TdxCustomFileDialogHelper.SelectionChange(ASender: TObject);
begin
  FDialog.FileName := FDialogForm.FileName;
  FDialog.Files.Assign(FDialogForm.Files);
  TOpenDialogAccess(FDialog).DoSelectionChange;
end;

procedure TdxCustomFileDialogHelper.TypeChange(ASender: TObject);
begin
  FDialog.FilterIndex := FDialogForm.FilterIndex;
  TOpenDialogAccess(FDialog).DoTypeChange;
end;

{ TdxOpenFileDialogHelper }

function TdxOpenFileDialogHelper.CreateForm(AParentWnd: HWND): TdxfrmCommonFileCustomDialog;
begin
  Result := OpenFileDialogFormClass.Create(Dialog);
end;

function TdxOpenFileDialogHelper.CreateStandardDialog(AOwner: TComponent): TOpenDialog;
begin
  Result := TOpenDialog.Create(AOwner);
end;

procedure TdxOpenFileDialogHelper.InitializeForm(AForm: TdxfrmCommonFileCustomDialog; ADialog: TOpenDialog);
begin
  inherited InitializeForm(AForm, ADialog);
  AForm.ForceFileSystem := TdxOpenFileDialog(ADialog).ForceFileSystem;
end;

procedure TdxOpenFileDialogHelper.AssignPropertiesTo(ADialog: TOpenDialog);
begin
  inherited AssignPropertiesTo(ADialog);
  if ADialog is TdxOpenFileDialog then
  begin
    TdxOpenFileDialog(ADialog).LookAndFeel.Assign(TdxOpenFileDialog(Dialog).LookAndFeel);
    TdxOpenFileDialog(ADialog).ForceFileSystem := TdxOpenFileDialog(Dialog).ForceFileSystem;
  end;
end;

{ TdxSaveFileDialogHelper }

function TdxSaveFileDialogHelper.CreateForm(AParentWnd: HWND): TdxfrmCommonFileCustomDialog;
begin
  Result := SaveFileDialogFormClass.Create(Dialog);
end;

function TdxSaveFileDialogHelper.CreateStandardDialog(AOwner: TComponent): TOpenDialog;
begin
  Result := TSaveDialog.Create(AOwner);
end;

procedure TdxSaveFileDialogHelper.InitializeForm(AForm: TdxfrmCommonFileCustomDialog; ADialog: TOpenDialog);
begin
  inherited InitializeForm(AForm, ADialog);
  AForm.ForceFileSystem := TdxSaveFileDialog(ADialog).ForceFileSystem;
end;

procedure TdxSaveFileDialogHelper.AssignPropertiesTo(ADialog: TOpenDialog);
begin
  inherited AssignPropertiesTo(ADialog);
  if ADialog is TdxSaveFileDialog then
  begin
    TdxSaveFileDialog(ADialog).LookAndFeel.Assign(TdxSaveFileDialog(Dialog).LookAndFeel);
    TdxSaveFileDialog(ADialog).ForceFileSystem := TdxSaveFileDialog(Dialog).ForceFileSystem;
  end;
end;

{ TdxSVGFilePreview }

destructor TdxSVGFilePreview.Destroy;
begin
  FreeAndNil(FImage);
  inherited Destroy;
end;

function TdxSVGFilePreview.Initialize: Boolean;
begin
  try
    Result := TdxSVGImageCodec.Load(FileName, TdxSmartImageCustomHandle(FImage));
  except
    FImage := nil;
    Result := False;
  end;
end;

procedure TdxSVGFilePreview.DrawPreview(ACanvas: TcxCanvas; const ABounds: TRect);
begin
  if FImage <> nil then
    FImage.Draw(ACanvas.Handle, ABounds, Rect(0, 0, Width, Height));
end;

function TdxSVGFilePreview.RunInThread: Boolean;
begin
  Result := True;
end;

function TdxSVGFilePreview.GetHeight: Integer;
begin
  Result := IfThen(FImage <> nil, FImage.Height, -1);
end;

function TdxSVGFilePreview.GetWidth: Integer;
begin
  Result := IfThen(FImage <> nil, FImage.Width, -1);
end;

{ TdxPictureDialogPreviewOptions }

constructor TdxPictureDialogPreviewOptions.Create;
begin
  inherited Create;
  Visible := bTrue;
end;

{ TdxOpenPictureDialogHelper }

function TdxOpenPictureDialogHelper.GetPreviewOptionsClass: TdxFileDialogPreviewOptionsClass;
begin
  Result := TdxPictureDialogPreviewOptions;
end;

{ TdxSavePictureDialogHelper }

function TdxSavePictureDialogHelper.GetPreviewOptionsClass: TdxFileDialogPreviewOptionsClass;
begin
  Result := TdxPictureDialogPreviewOptions;
end;

{ TdxOpenFileDialog }

constructor TdxOpenFileDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHelper := CreateHelper;
end;

destructor TdxOpenFileDialog.Destroy;
begin
  FreeAndNil(FHelper);
  inherited Destroy;
end;

procedure TdxOpenFileDialog.AssignTo(ADest: TPersistent);
begin
  TdxOpenFileDialogHelper(FHelper).AssignTo(ADest);
end;

function TdxOpenFileDialog.CreateHelper: TObject;
begin
  Result := TdxOpenFileDialogHelper.Create(Self);
end;

function TdxOpenFileDialog.Execute(ParentWnd: HWND): Boolean;
begin
  Result := TdxOpenFileDialogHelper(FHelper).Execute(ParentWnd);
end;

function TdxOpenFileDialog.GetOptionsPreview: TdxFileDialogPreviewOptions;
begin
  Result := TdxOpenFileDialogHelper(FHelper).OptionsPreview;
end;

procedure TdxOpenFileDialog.SetLookAndFeel(const AValue: TcxLookAndFeel);
begin
  TdxOpenFileDialogHelper(FHelper).LookAndFeel.Assign(AValue);
end;

procedure TdxOpenFileDialog.SetOptionsPreview(const AValue: TdxFileDialogPreviewOptions);
begin
  TdxOpenFileDialogHelper(FHelper).OptionsPreview.Assign(AValue);
end;

function TdxOpenFileDialog.GetLookAndFeel: TcxLookAndFeel;
begin
  Result := TdxOpenFileDialogHelper(FHelper).LookAndFeel;
end;

{ TdxSaveFileDialog }

constructor TdxSaveFileDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHelper := CreateHelper;
end;

destructor TdxSaveFileDialog.Destroy;
begin
  FreeAndNil(FHelper);
  inherited Destroy;
end;

procedure TdxSaveFileDialog.AssignTo(ADest: TPersistent);
begin
  TdxSaveFileDialogHelper(FHelper).AssignTo(ADest);
end;

function TdxSaveFileDialog.CreateHelper: TObject;
begin
  Result := TdxSaveFileDialogHelper.Create(Self);
end;

function TdxSaveFileDialog.Execute(ParentWnd: HWND): Boolean;
begin
  Result := TdxSaveFileDialogHelper(FHelper).Execute(ParentWnd);
end;

function TdxSaveFileDialog.GetLookAndFeel: TcxLookAndFeel;
begin
  Result := TdxSaveFileDialogHelper(FHelper).LookAndFeel;
end;

function TdxSaveFileDialog.GetOptionsPreview: TdxFileDialogPreviewOptions;
begin
  Result := TdxSaveFileDialogHelper(FHelper).OptionsPreview;
end;

procedure TdxSaveFileDialog.SetLookAndFeel(const AValue: TcxLookAndFeel);
begin
  TdxSaveFileDialogHelper(FHelper).LookAndFeel := AValue;
end;

procedure TdxSaveFileDialog.SetOptionsPreview(const AValue: TdxFileDialogPreviewOptions);
begin
  TdxSaveFileDialogHelper(FHelper).OptionsPreview.Assign(AValue);
end;

{ TdxOpenPictureDialog }

constructor TdxOpenPictureDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Filter := GetDefaultGraphicFilter;
  OptionsPreview.Visible := bTrue;
end;

function TdxOpenPictureDialog.Execute(ParentWnd: HWND): Boolean;
begin
  TdxSVGFilePreview.Register(dxSVGImageExt);
  try
    Result := inherited Execute(ParentWnd);
  finally
    TdxSVGFilePreview.Unregister(dxSVGImageExt);
  end;
end;

function TdxOpenPictureDialog.CreateHelper: TObject;
begin
  Result := TdxOpenPictureDialogHelper.Create(Self);
end;

function TdxOpenPictureDialog.GetDefaultGraphicFilter: string;
begin
  Result := cxGraphicFilter(TGraphic);
end;

function TdxOpenPictureDialog.IsFilterStored: Boolean;
begin
  Result := Filter <> GetDefaultGraphicFilter;
end;

{ TdxSavePictureDialog }

constructor TdxSavePictureDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Filter := GetDefaultGraphicFilter;
  OptionsPreview.Visible := bTrue;
end;

function TdxSavePictureDialog.Execute(ParentWnd: HWND): Boolean;
begin
  TdxSVGFilePreview.Register(dxSVGImageExt);
  try
    Result := inherited Execute(ParentWnd);
  finally
    TdxSVGFilePreview.Unregister(dxSVGImageExt);
  end;
end;

function TdxSavePictureDialog.CreateHelper: TObject;
begin
  Result := TdxSavePictureDialogHelper.Create(Self);
end;

function TdxSavePictureDialog.GetDefaultGraphicFilter: string;
begin
  Result := cxGraphicFilter(TGraphic);
end;

function TdxSavePictureDialog.IsFilterStored: Boolean;
begin
  Result := Filter <> GetDefaultGraphicFilter;
end;

end.
