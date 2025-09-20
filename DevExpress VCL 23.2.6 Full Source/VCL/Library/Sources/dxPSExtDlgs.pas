{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressPrinting System                                   }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSPRINTING SYSTEM AND            }
{   ALL ACCOMPANYING VCL CONTROLS AS PART OF AN                      }
{   EXECUTABLE PROGRAM ONLY.                                         }
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

unit dxPSExtDlgs;

interface

{$I cxVer.inc}

uses 
  Messages, Windows, SysUtils, Classes, Controls, Forms, StdCtrls, Graphics,
  ExtCtrls, Buttons, Dialogs, dxCore, cxClasses, dxPSCore, dxExtCtrls, cxButtons, dxShellDialogs;

type
  { TdxPSOpenReportDialog }

  TdxPSOpenReportDialog = class(TOpenDialog)
  private
    btnPreview: TcxButton;
    FPrevFileName: string;
    FPreviewRect: TRect;
    FReportDocument: TdxPSReportDocument;
    lblPreview: TLabel;
    pnlPicture: TPanel;
    pnlToolBar: TPanel;
    sbxPreview: TdxPSImageScrollBox;
    function GetGraphic: TGraphic;
    function GetHasDocument: Boolean;
    function GetIsDocumentValid: Boolean;
    procedure PreviewClick(Sender: TObject);
  protected
    class procedure Initialize(ADialog: TOpenDialog); overload; virtual;
    function IsSelectedFileValid: Boolean; virtual;
    function TaskModalDialog(DialogFunc: Pointer; var DialogData): Bool; override;
    procedure CreateControls; virtual;
    procedure DoClose; override;
    procedure DoSelectionChange; override;
    procedure DoShow; override;
    procedure Initialize; overload; virtual;
    procedure LoadReportDocument;
    procedure LoadStrings; virtual;
    procedure PlacePreviewPanelInitial;
    procedure PrepareToExecute;
    procedure UpdateControls; virtual;

    property Graphic: TGraphic read GetGraphic;
    property HasDocument: Boolean read GetHasDocument;
    property IsDocumentValid: Boolean read GetIsDocumentValid;
    property PreviewRect: TRect read FPreviewRect;
    property ReportDocument: TdxPSReportDocument read FReportDocument;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean; override;
  end;

  { TdxPSSaveReportDialog }

  TdxPSSaveReportDialog = class(TdxPSOpenReportDialog)
  protected
    class procedure Initialize(ADialog: TOpenDialog); override;
  public
    function Execute: Boolean; override;
  end;

function dxPSCreateOpenReportDialog(AOwner: TComponent): TOpenDialog; // for internal use
function dxPSCreateSaveReportDialog(AOwner: TComponent): TOpenDialog; // for internal use

const
  sdxPicturePanel = 'pnlPicture';       // Don't localize
  sdxPreviewButton = 'btnPreview';      // Don't localize
  sdxPreviewLabel = 'lblPreview';       // Don't localize
  sdxPreviewScrollBox = 'sbxPreview';   // Don't localize
  sdxPreviewToolBar = 'pnlToolBar';     // Don't localize

implementation

uses
  CommDlg, dxPSRes, dxPSImgs, dxPSUtl, dxPCPrVw, dxShellFilePreview;

const
  dxThisUnitName = 'dxPSExtDlgs';

{$R dxPSExtDlgs.res}

type
  TOpenDialogClass = class of TOpenDialog;

  TdxPSOpenFileDialog = class(TdxOpenFileDialog)
  public
    constructor Create(AOwner: TComponent); override;
    function Execute(ParentWnd: HWND): Boolean; override;
  end;

  TdxPSSaveFileDialog = class(TdxSaveFileDialog)
  public
    constructor Create(AOwner: TComponent); override;
    function Execute(ParentWnd: HWND): Boolean; override;
  end;

  TdxRPSFilePreview = class (TdxFilePreviewControlBasedHandler)
  strict private
    FReportDocument: TdxPSReportDocument;
    FControl: TdxPSImageScrollBox;
  protected
    function CreateControl(const AFileName: string): TWinControl; override;
    procedure PreviewClick(Sender: TObject); virtual;
  public
    destructor Destroy; override;
  end;

function dxPSCreateReportDialog(AOwner: TComponent; AStandardDialogClass, AAlternateDialogClass: TOpenDialogClass): TOpenDialog;
begin
  if dxUseStandardShellDialogs then
    Result := AStandardDialogClass.Create(AOwner)
  else
    Result := AAlternateDialogClass.Create(AOwner);
end;

function dxPSCreateOpenReportDialog(AOwner: TComponent): TOpenDialog;
begin
  Result := dxPSCreateReportDialog(AOwner, TdxPSOpenReportDialog, TdxPSOpenFileDialog);
  TdxPSOpenReportDialog.Initialize(Result);
end;

function dxPSCreateSaveReportDialog(AOwner: TComponent): TOpenDialog;
begin
  Result := dxPSCreateReportDialog(AOwner, TdxPSSaveReportDialog, TdxPSSaveFileDialog);
  TdxPSSaveReportDialog.Initialize(Result);
end;

{ TdxPSOpenFileDialog }

constructor TdxPSOpenFileDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  OptionsPreview.Visible := bTrue;
  OptionsPreview.Sources := [TdxFilePreviewSource.CustomHandler];
end;

function TdxPSOpenFileDialog.Execute(ParentWnd: HWND): Boolean;
begin
  TdxRPSFilePreview.Register('.rps');
  try
    Result := inherited Execute(ParentWnd);
  finally
    TdxRPSFilePreview.Unregister('.rps');
  end;
end;

{ TdxPSSaveFileDialog }

constructor TdxPSSaveFileDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  OptionsPreview.Visible := bTrue;
  OptionsPreview.Sources := [TdxFilePreviewSource.CustomHandler];
end;

function TdxPSSaveFileDialog.Execute(ParentWnd: HWND): Boolean;
begin
  TdxRPSFilePreview.Register('.rps');
  try
    Result := inherited Execute(ParentWnd);
  finally
    TdxRPSFilePreview.Unregister('.rps');
  end;
end;

{ TdxRPSFilePreview }

destructor TdxRPSFilePreview.Destroy;
begin
  FreeAndNil(FReportDocument);
  inherited Destroy;
end;

procedure TdxRPSFilePreview.PreviewClick(Sender: TObject);
begin
  if FControl.HasGraphic then
    dxShowPicturePreview(FControl.Picture.Graphic);
end;

function TdxRPSFilePreview.CreateControl(const AFileName: string): TWinControl;
var
  AStream: TFileStream;
begin
  FControl := TdxPSImageScrollBox.Create(nil);
  FControl.BoundsRect := Pane.ClientRect; 
  FControl.Align := alClient;
  FControl.Parent := Pane; 
//  FControl.OnDblClick := PreviewClick;
  AStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    try
      FReportDocument := TBasedxReportLink.ExtractReportDocument(AStream, True);
      FControl.Picture.Graphic := FReportDocument.Preview;
    except
      FReportDocument := nil;
    end;
  finally
    AStream.Free;
  end;
  Result := FControl;
end;

{ TdxPSOpenReportDialog }

constructor TdxPSOpenReportDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CreateControls;
  Initialize(Self);
end;

destructor TdxPSOpenReportDialog.Destroy;
begin
  FreeAndNil(FReportDocument);
  inherited Destroy;
end;

function TdxPSOpenReportDialog.Execute: Boolean;
begin
  PrepareToExecute;
  Result := inherited Execute;
end;

procedure TdxPSOpenReportDialog.DoClose;
begin
  inherited DoClose;
  Application.HideHint;
end;

procedure TdxPSOpenReportDialog.DoSelectionChange;
begin
  if FileName <> FPrevFileName then
  begin
    FPrevFileName := FileName;
    if IsSelectedFileValid then 
      LoadReportDocument;
    UpdateControls;
  end;
  inherited DoSelectionChange;
end;
                              
procedure TdxPSOpenReportDialog.DoShow;
begin
  Initialize;
  inherited DoShow;
end;

function TdxPSOpenReportDialog.TaskModalDialog(DialogFunc: Pointer; var DialogData): Bool;
var
  Wnd: HWND;
begin
  Wnd := SetParent(Handle, GetForegroundWindow);
  TOpenFileName(DialogData).hInstance := hInstance;
  Result := inherited TaskModalDialog(DialogFunc,  DialogData);
  SetParent(Handle, Wnd);
end;

procedure TdxPSOpenReportDialog.CreateControls;

  function CreatePanel(const AName: TComponentName): TPanel;
  begin
    Result := TPanel.Create(Self);
    Result.BevelInner := bvNone;
    Result.BevelOuter := bvNone;
    Result.BorderStyle := bsNone;
    Result.Name := AName;
    Result.Caption := '';
  end;

  procedure CreatePicturePanel;
  begin
    pnlPicture := CreatePanel(sdxPicturePanel);
    pnlPicture.TabOrder := 1;
    pnlPicture.SetBounds(204, 5, 169, 200);
  end;

  procedure CreatePreviewToolBar;
  begin
    pnlToolBar := CreatePanel(sdxPreviewToolBar);
    pnlToolBar.Parent := pnlPicture;
    pnlToolBar.Align := alTop;
    pnlToolBar.Height := 31; //29
    pnlToolBar.TabOrder := 0;
  end;
             
  procedure CreatePreviewLabel;
  begin
    lblPreview := TLabel.Create(Self);
    lblPreview.Parent := pnlToolBar;
    lblPreview.AutoSize := False;
    lblPreview.Name := sdxPreviewLabel;
    lblPreview.Transparent := True;
    lblPreview.SetBounds(2, 6, 157, 23);
  end;

  procedure CreatePreviewButton;
  begin
    btnPreview := TcxButton.Create(Self);
    btnPreview.Parent := pnlToolBar;
    btnPreview.Enabled := False;
    btnPreview.Name := sdxPreviewButton;
    btnPreview.ParentShowHint := False;
    btnPreview.ShowHint := True;
    btnPreview.SetBounds(77, 1, 23, 22);
    btnPreview.OnClick := PreviewClick;
    dxLoadBitmapFromResource(btnPreview.Glyph, IDB_DXPSPREVIEW);
    btnPreview.Caption := '';
  end;

  procedure CreatePreviewScrollBox;
  begin
    sbxPreview := TdxPSImageScrollBox.Create(Self);
    sbxPreview.Parent := pnlPicture;
    sbxPreview.Align := alClient;
    sbxPreview.Name := sdxPreviewScrollBox;
    sbxPreview.TabOrder := 1;
    sbxPreview.OnDblClick := PreviewClick;
  end;

begin
  CreatePicturePanel;
  CreatePreviewToolBar;
  CreatePreviewLabel;
  CreatePreviewButton;
  CreatePreviewScrollBox;
end;

class procedure TdxPSOpenReportDialog.Initialize(ADialog: TOpenDialog);
begin
  ADialog.DefaultExt := dxPSCore.dxPSReportFileShortExtension;
  ADialog.Filter := Format('%s (*.%1:s)|*.%1:s', [cxGetResourceString(@sdxPSReportFiles), dxPSCore.dxPSReportFileShortExtension]);
  ADialog.Options := ADialog.Options + [ofPathMustExist, ofFileMustExist];
  ADialog.Title := cxGetResourceString(@sdxLoadReportDataToFileTitle);
end;

function TdxPSOpenReportDialog.IsSelectedFileValid: Boolean;
begin
  Result := FileExists(FileName) and (GetFileAttributes(PChar(FileName)) <> $FFFFFFFF);
end;

procedure TdxPSOpenReportDialog.LoadReportDocument;
var
  Stream: TFileStream;
begin
  FreeAndNil(FReportDocument);
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    try
      FReportDocument := TBasedxReportLink.ExtractReportDocument(Stream, True);
    except
      FReportDocument := nil;
    end;  
  finally
    Stream.Free;
  end;
end;

procedure TdxPSOpenReportDialog.Initialize;
begin
  LoadStrings;
  PlacePreviewPanelInitial;
  UpdateControls;
end;
                            
procedure TdxPSOpenReportDialog.LoadStrings;
begin
  lblPreview.Caption := DropAmpersand(cxGetResourceString(@sdxPreview)) + ':';
  btnPreview.Hint := DropAmpersand(cxGetResourceString(@sdxPreview));
end;

procedure TdxPSOpenReportDialog.PlacePreviewPanelInitial;
var
  R: TRect;
begin      
  R := GetStaticRect;

  Windows.GetClientRect(Handle, FPreviewRect);
  FPreviewRect.Left := R.Left + (R.Right - R.Left);
  Inc(FPreviewRect.Top, 4);
  
  pnlPicture.ParentWindow := Handle;
  pnlPicture.Realign;
  pnlPicture.BoundsRect := PreviewRect;

  btnPreview.Left := pnlToolBar.BoundsRect.Right - btnPreview.Width - 2;
end;

procedure TdxPSOpenReportDialog.PrepareToExecute;
begin
  Options := Options - [ofEnableSizing];
  if NewStyleControls and not (ofOldStyleDialog in Options) then
    Template := 'DXPSDLGTEMPLATE'
  else
    Template := nil;
end;

procedure TdxPSOpenReportDialog.UpdateControls;
begin
  btnPreview.Enabled := IsDocumentValid;
  
  sbxPreview.Enabled := IsDocumentValid;
  sbxPreview.Picture.Assign(Graphic);
  if IsDocumentValid then
    sbxPreview.HintText := ''
  else
    if FileExists(FileName) then 
      sbxPreview.HintText := cxGetResourceString(@sdxReportDocumentIsCorrupted)
    else
      sbxPreview.HintText := cxGetResourceString(@sdxNone);
end;

function TdxPSOpenReportDialog.GetGraphic: TGraphic;
begin
  if ReportDocument <> nil then
    Result := ReportDocument.Preview
  else  
    Result := nil;
end;

function TdxPSOpenReportDialog.GetHasDocument: Boolean;
begin
  Result := ReportDocument <> nil; 
end;

function TdxPSOpenReportDialog.GetIsDocumentValid: Boolean;
begin
  Result := Graphic <> nil;
end;

procedure TdxPSOpenReportDialog.PreviewClick(Sender: TObject);
begin
  dxPCPrVw.dxShowPicturePreview(Graphic);
end;

{ TdxPSSaveReportDialog }
                                 
function TdxPSSaveReportDialog.Execute: Boolean;
begin
  PrepareToExecute;
  Result := DoExecute(@GetSaveFileName);
end;

class procedure TdxPSSaveReportDialog.Initialize(ADialog: TOpenDialog);
begin
  inherited Initialize(ADialog);
  ADialog.Options := ADialog.Options + [ofOverwritePrompt] - [ofFileMustExist];
  ADialog.Title := cxGetResourceString(@sdxSaveReportDataToFileTitle);
end;

end.

