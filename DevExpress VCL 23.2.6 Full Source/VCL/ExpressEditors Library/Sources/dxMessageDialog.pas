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

unit dxMessageDialog;

{$I cxVer.inc}

interface

uses
  Types, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, Consts, Math, Clipbrd,
  StrUtils, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxClasses, dxForms, dxCore, cxGeometry,
  dxCoreGraphics, dxDPIAwareUtils, dxLayoutContainer, dxLayoutControl, dxLayoutLookAndFeels, cxButtons, dxMessages,
  dxTypeHelpers;

type
  TdxMessageDialogStyle = (mdsMessageDlg, mdsMessageBox);

  { TdxMessageDialogForm }

  TdxMessageDialogFormClass = class of TdxMessageDialogForm;
  TdxMessageDialogForm = class(TdxForm)
    LayoutCxLookAndFeel: TdxLayoutCxLookAndFeel;
    LayoutLookAndFeelList: TdxLayoutLookAndFeelList;
    lcButtonHost: TdxLayoutGroup;
    lcContentHost: TdxLayoutGroup;
    lcIcon: TdxLayoutImageItem;
    lcMain: TdxLayoutControl;
    lcMainGroup_Root: TdxLayoutGroup;
    lcMessage: TdxLayoutLabeledItem;
    lcMessageHost: TdxLayoutGroup;

    procedure ButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  strict private const
    DefaultButtonWidth = 75;
    MessageBoxPadding = 16;
    MinimalMessageBoxWidth = 120;
    MinimalTaskDialogWidth = 360;
  strict private
    FDialogType: TMsgDlgType;
    FOwnerWndHandle: THandle;
    FStyle: TdxMessageDialogStyle;

    function GetButton(Index: Integer): TcxButton;
    function GetButtonCount: Integer;
    function getMessage: string;
    procedure SetMessage(const Value: string);
    procedure SetStyle(AStyle: TdxMessageDialogStyle);
    // Messages
    procedure DXMScaleChanged(var AMessage: TMessage); message DXM_SCALECHANGED;
    procedure FixMessageHeight;
  protected
    procedure CreateButton(AButton: TMsgDlgBtn); virtual;
    procedure CreateButtons(AButtons: TMsgDlgButtons);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DoShow; override;
    function GetButtonCaption(AButton: TMsgDlgBtn): string; virtual;
    function GetDialogCaption(AType: TMsgDlgType): string; virtual;
    procedure InitializeFont; virtual;
    procedure InitializeIcon(AType: TMsgDlgType); virtual;
    procedure PlaySound; virtual;
    procedure UpdateMessageConstraints; virtual;
  public
    constructor Create(AOwner: TComponent; AType: TMsgDlgType;
      AButtons: TMsgDlgButtons; AOwnerWndHandle: THandle = 0); reintroduce; virtual;
    procedure AlignButtons; virtual;
    function FindButton(AButton: TMsgDlgBtn): TcxButton;
    procedure SetDefaultButton(AButton: TMsgDlgBtn); virtual;
    procedure SetPosition(X, Y: Integer); virtual;
    function ToString: string; override;
    //
    property ButtonCount: Integer read GetButtonCount;
    property Buttons[Index: Integer]: TcxButton read GetButton;
    property DialogType: TMsgDlgType read FDialogType;
    property Message: string read getMessage write SetMessage;
    property Style: TdxMessageDialogStyle read FStyle write SetStyle;
  end;

var
  dxMessageDialogFormClass: TdxMessageDialogFormClass = TdxMessageDialogForm; 
  dxUseStandardMessageDialogs: Boolean = False; 

function dxCreateMessageDialog(const AMessage: string; ADialogType: TMsgDlgType;
  AButtons: TMsgDlgButtons): TdxMessageDialogForm; overload; 
function dxCreateMessageDialog(const AMessage: string; ADialogType: TMsgDlgType;
  AButtons: TMsgDlgButtons; ADefaultButton: TMsgDlgBtn): TdxMessageDialogForm; overload; 

function dxMessageDlg(const AMessage: string; ADialogType: TMsgDlgType;
  AButtons: TMsgDlgButtons; AHelpContext: Longint): Integer; overload; 
function dxMessageDlg(const AMessage: string; ADialogType: TMsgDlgType;
  AButtons: TMsgDlgButtons; AHelpContext: Longint; ADefaultButton: TMsgDlgBtn): Integer; overload; 

function dxMessageDlgPos(const AMessage: string; ADialogType: TMsgDlgType;
  AButtons: TMsgDlgButtons; AHelpContext: Longint; X, Y: Integer): Integer; overload; 
function dxMessageDlgPos(const AMessage: string; ADialogType: TMsgDlgType;
  AButtons: TMsgDlgButtons; AHelpContext: Longint; X, Y: Integer;
  ADefaultButton: TMsgDlgBtn): Integer; overload; 

function dxMessageDlgPosHelp(const AMessage: string; ADialogType: TMsgDlgType; AButtons: TMsgDlgButtons;
  AHelpContext: Longint; X, Y: Integer; const AHelpFileName: string): Integer; overload; 
function dxMessageDlgPosHelp(const AMessage: string; ADialogType: TMsgDlgType; AButtons: TMsgDlgButtons;
  AHelpContext: Longint; X, Y: Integer; const AHelpFileName: string; ADefaultButton: TMsgDlgBtn): Integer; overload; 

function dxMessageBox(const AMessage, ATitle: string; AFlags: Integer): Integer; overload; 
function dxMessageBox(AOwnerWndHandle: THandle; const AMessage, ATitle: string; AFlags: Integer): Integer; overload; 

procedure dxShowMessage(const AMessage: string); 
procedure dxShowMessageFmt(const AMessage: string; AArguments: array of const); 
procedure dxShowMessagePos(const AMessage: string; X, Y: Integer); 

implementation

uses
  ComCtrls;

const
  dxThisUnitName = 'dxMessageDialog';

{$R *.dfm}

type
  TdxLayoutLabeledItemCustomCaptionOptionsAccess = class(TdxLayoutLabeledItemCustomCaptionOptions);

function LoadIconWithScaleDown(Inst: HINST; Name: PWideChar; Cx, Cy: Integer; out AIcon: HICON): HRESULT; stdcall; external 'Comctl32.dll' delayed;

function GetDefaultButton(AButtons: TMsgDlgButtons): TMsgDlgBtn;
begin
  if mbOk in AButtons then
    Result := mbOk
  else
    if mbYes in AButtons then
      Result := mbYes
    else
      Result := mbRetry;
end;

function dxCreateMessageDialog(const AMessage: string; ADialogType: TMsgDlgType;
  AButtons: TMsgDlgButtons): TdxMessageDialogForm;
begin
  Result := dxCreateMessageDialog(AMessage, ADialogType, AButtons, GetDefaultButton(AButtons));
end;

function dxCreateMessageDialog(const AMessage: string; ADialogType: TMsgDlgType;
  AButtons: TMsgDlgButtons; ADefaultButton: TMsgDlgBtn): TdxMessageDialogForm;
begin
  if not (ADefaultButton in AButtons) then
    ADefaultButton := GetDefaultButton(AButtons);

  Result := dxMessageDialogFormClass.Create(nil, ADialogType, AButtons);
  Result.SetDefaultButton(ADefaultButton);
  Result.Message := AMessage;
end;

function dxMessageDlg(const AMessage: string; ADialogType: TMsgDlgType;
  AButtons: TMsgDlgButtons; AHelpContext: Longint): Integer;
begin
  Result := dxMessageDlg(AMessage, ADialogType, AButtons, AHelpContext, GetDefaultButton(AButtons));
end;

function dxMessageDlg(const AMessage: string; ADialogType: TMsgDlgType;
  AButtons: TMsgDlgButtons; AHelpContext: Longint; ADefaultButton: TMsgDlgBtn): Integer;
begin
  Result := dxMessageDlgPosHelp(AMessage, ADialogType, AButtons, AHelpContext, -1, -1, '', ADefaultButton);
end;

function dxMessageDlgPos(const AMessage: string; ADialogType: TMsgDlgType;
  AButtons: TMsgDlgButtons; AHelpContext: Longint; X, Y: Integer): Integer;
begin
  Result := dxMessageDlgPos(AMessage, ADialogType, AButtons, AHelpContext, X, Y, GetDefaultButton(AButtons));
end;

function dxMessageDlgPos(const AMessage: string; ADialogType: TMsgDlgType;
  AButtons: TMsgDlgButtons; AHelpContext: Longint; X, Y: Integer;
  ADefaultButton: TMsgDlgBtn): Integer;
begin
  Result := dxMessageDlgPosHelp(AMessage, ADialogType, AButtons, AHelpContext, X, Y, '', ADefaultButton);
end;

function dxMessageDlgPosHelp(const AMessage: string; ADialogType: TMsgDlgType; AButtons: TMsgDlgButtons;
  AHelpContext: Longint; X, Y: Integer; const AHelpFileName: string): Integer;
begin
  Result := dxMessageDlgPosHelp(AMessage, ADialogType, AButtons,
    AHelpContext, X, Y, AHelpFileName, GetDefaultButton(AButtons));
end;

function dxMessageDlgPosHelp(const AMessage: string; ADialogType: TMsgDlgType; AButtons: TMsgDlgButtons;
  AHelpContext: Longint; X, Y: Integer; const AHelpFileName: string; ADefaultButton: TMsgDlgBtn): Integer;
var
  ADialog: TdxMessageDialogForm;
begin
  if dxUseStandardMessageDialogs then
    Result := MessageDlgPosHelp(AMessage, ADialogType, AButtons, AHelpContext, X, Y, AHelpFileName, ADefaultButton)
  else
  begin
    ADialog := dxCreateMessageDialog(AMessage, ADialogType, AButtons, ADefaultButton);
    try
      ADialog.HelpFile := AHelpFileName;
      ADialog.HelpContext := AHelpContext;
      ADialog.SetPosition(X, Y);
      Result := ADialog.ShowModal;
    finally
      ADialog.Free;
    end;
  end;
end;

function dxMessageBox(const AMessage, ATitle: string; AFlags: Integer): Integer;
var
  AWndHandle: THandle;
begin
  if dxUseStandardMessageDialogs then
    Exit(Application.MessageBox(PChar(AMessage), PChar(ATitle), AFlags));

  AWndHandle := Application.ActiveFormHandle;
  if AWndHandle = 0 then
  begin
    if Application.MainFormOnTaskBar then
      AWndHandle := Application.MainFormHandle
    else
      AWndHandle := Application.Handle;
  end;

  Result := dxMessageBox(AWndHandle, AMessage, ATitle, AFlags);
end;

function dxMessageBox(AOwnerWndHandle: THandle; const AMessage, ATitle: string; AFlags: Integer): Integer;

  function FlagsToButtons(AFlags: Integer): TMsgDlgButtons;
  begin
    if AFlags and MB_RETRYCANCEL = MB_RETRYCANCEL then
      Result := [mbRetry, mbCancel]
    else if AFlags and MB_YESNO = MB_YESNO then
      Result := [mbYes, mbNo]
    else if AFlags and MB_YESNOCANCEL = MB_YESNOCANCEL then
      Result := [mbYes, mbNo, mbCancel]
    else if AFlags and MB_ABORTRETRYIGNORE = MB_ABORTRETRYIGNORE then
      Result := [mbAbort, mbRetry, mbIgnore]
    else if AFlags and MB_OKCANCEL = MB_OKCANCEL then
      Result := [mbOK, mbCancel]
    else
      Result := [mbOK];
  end;

  function FlagsToDefaultButton(AFlags: Integer; out AIndex: Integer): Boolean;
  const
    Masks: array[0..3] of Integer = (MB_DEFBUTTON1, MB_DEFBUTTON2, MB_DEFBUTTON3, MB_DEFBUTTON4);
  var
    I: Integer;
  begin
    for I := High(Masks) downto Low(Masks) do
      if AFlags and Masks[I] = Masks[I] then
      begin
        AIndex := I;
        Exit(True);
      end;

    Result := False;
  end;

  function FlagsToDialogType(AFlags: Integer): TMsgDlgType;
  const
    Map: array[TMsgDlgType] of Integer = (MB_ICONWARNING, MB_ICONERROR, MB_ICONINFORMATION, MB_ICONQUESTION, 0);
  var
    AIndex: TMsgDlgType;
  begin
    for AIndex := Low(AIndex) to High(AIndex) do
    begin
      if AFlags and Map[AIndex] = Map[AIndex] then
        Exit(AIndex);
    end;
    Result := mtCustom;
  end;

var
  ADefaultButtonIndex: Integer;
  ADialog: TdxMessageDialogForm;
begin
  if dxUseStandardMessageDialogs then
    Exit(MessageBox(AOwnerWndHandle, PChar(AMessage), PChar(ATitle), AFlags));

  ADialog := dxMessageDialogFormClass.Create(FindControl(AOwnerWndHandle),
    FlagsToDialogType(AFlags), FlagsToButtons(AFlags), AOwnerWndHandle);
  try
    ADialog.Style := mdsMessageBox;
    ADialog.Message := AMessage;
    if AFlags and MB_TOPMOST = MB_TOPMOST then
      ADialog.FormStyle := fsStayOnTop;
    if AFlags and MB_RTLREADING = MB_RTLREADING then
      ADialog.BiDiMode := bdRightToLeft;
    if FlagsToDefaultButton(AFlags, ADefaultButtonIndex) and (ADefaultButtonIndex < ADialog.ButtonCount) then
      ADialog.SetDefaultButton(TMsgDlgBtn(ADialog.Buttons[ADefaultButtonIndex].Tag));
    if ATitle <> '' then
      ADialog.Caption := ATitle
    else
      ADialog.Caption := cxGetResourceString(@SMsgDlgError); 

    Result := ADialog.ShowModal;
  finally
    ADialog.Free;
  end;
end;

procedure dxShowMessage(const AMessage: string);
begin
  dxShowMessagePos(AMessage, -1, -1);
end;

procedure dxShowMessageFmt(const AMessage: string; AArguments: array of const);
begin
  dxShowMessage(Format(AMessage, AArguments));
end;

procedure dxShowMessagePos(const AMessage: string; X, Y: Integer);
begin
  dxMessageDlgPos(AMessage, mtCustom, [mbOK], 0, X, Y);
end;

{ TdxMessageDialogForm }

constructor TdxMessageDialogForm.Create(AOwner: TComponent;
  AType: TMsgDlgType; AButtons: TMsgDlgButtons; AOwnerWndHandle: THandle = 0);
begin
  FDialogType := AType;
  FOwnerWndHandle := AOwnerWndHandle;
  inherited Create(AOwner);
  Caption := GetDialogCaption(DialogType);
  InitializeIcon(DialogType);
  InitializeFont;
  CreateButtons(AButtons);
  TdxLayoutLabeledItemCustomCaptionOptionsAccess(lcMessage.CaptionOptions).ExpandTabs := True;
  SetPosition(-1, -1);
end;

procedure TdxMessageDialogForm.AlignButtons;
var
  AButtonWidth: Integer;
  I: Integer;
begin
  AButtonWidth := ScaleFactor.Apply(DefaultButtonWidth);
  for I := 0 to ButtonCount - 1 do
    AButtonWidth := Max(AButtonWidth, Buttons[I].GetOptimalSize.cx);
  for I := 0 to ButtonCount - 1 do
    Buttons[I].Width := AButtonWidth;
  if not (UseLatestCommonDialogs and IsWinVistaOrLater) then
    lcButtonHost.AlignHorz := ahCenter;
end;

function TdxMessageDialogForm.FindButton(AButton: TMsgDlgBtn): TcxButton;
var
  I: Integer;
begin
  for I := 0 to ButtonCount - 1 do
  begin
    if Buttons[I].Tag = Ord(AButton) then
      Exit(Buttons[I]);
  end;
  Result := nil;
end;

procedure TdxMessageDialogForm.FixMessageHeight;
var
  AHeightDifference: Integer;
begin
  if (lcMessage <> nil) and (lcMessage.ViewInfo <> nil) and (Height > Monitor.WorkareaRect.Height) then
  begin
    AHeightDifference := Height - lcMessage.ViewInfo.Bounds.Height;
    lcMessageHost.AlignVert := avTop;
    lcMessageHost.SizeOptions.Height := Monitor.WorkareaRect.Height - AHeightDifference;
  end
  else
    lcMessageHost.AlignVert := avClient;
end;

procedure TdxMessageDialogForm.SetDefaultButton(AButton: TMsgDlgBtn);
var
  AButtonControl: TcxButton;
begin
  AButtonControl := FindButton(AButton);
  if AButtonControl <> nil then
  begin
    AButtonControl.Default := True;
    ActiveControl := AButtonControl;
  end;
end;

procedure TdxMessageDialogForm.SetPosition(X, Y: Integer);
begin
  if (X = -1) and (Y = -1) then
  begin
    if Owner is TCustomForm then
      Position := poOwnerFormCenter
    else
      Position := poScreenCenter;
  end
  else
  begin
    Position := poDesigned;
    if X <> -1 then
      Left := X;
    if Y <> -1 then
      Top := Y;
  end;
end;

function TdxMessageDialogForm.ToString: string;
var
  AButtonCaptions: TStringBuilder;
  ADivider: string;
  I: integer;
begin
  ADivider := DupeString('-', 27) + dxCRLF;

  AButtonCaptions := TStringBuilder.Create;
  try
    for I := 0 to ButtonCount - 1 do
    begin
      AButtonCaptions.Append(StringReplace(Buttons[I].Caption, '&', '', [rfReplaceAll]));
      AButtonCaptions.Append('   ');
    end;

    Result := Format('%s%s%s%s%s%s%s%s%s%s', [
      ADivider, Caption, dxCRLF,
      ADivider, Message, dxCRLF,
      ADivider, AButtonCaptions.ToString, dxCRLF,
      ADivider]);
  finally
    AButtonCaptions.Free;
  end;
end;

procedure TdxMessageDialogForm.CreateButton(AButton: TMsgDlgBtn);
const
  ButtonNames: array[TMsgDlgBtn] of string = (
    'Yes', 'No', 'OK', 'Cancel', 'Abort', 'Retry', 'Ignore', 'All', 'NoToAll', 'YesToAll', 'Help', 'Close'
  );
var
  AButtonControl: TcxButton;
  ALayoutItem: TdxLayoutItem;
begin
  AButtonControl := TcxButton.Create(Self);
  AButtonControl.Caption := GetButtonCaption(AButton);
  AButtonControl.Name := ButtonNames[AButton];
  AButtonControl.OnClick := ButtonClick;
  AButtonControl.Tag := Ord(AButton);

  ALayoutItem := TdxLayoutItem.Create(Self);
  ALayoutItem.AlignHorz := ahRight;
  ALayoutItem.Parent := lcButtonHost;
  ALayoutItem.Control := AButtonControl;
end;

procedure TdxMessageDialogForm.CreateButtons(AButtons: TMsgDlgButtons);
var
  AButton: TMsgDlgBtn;
  AButtonControl: TcxButton;
  ACancelButton: TMsgDlgBtn;
begin
  lcMain.BeginUpdate;
  try
    for AButton := Low(TMsgDlgBtn) to High(TMsgDlgBtn) do
    begin
      if AButton in AButtons then
        CreateButton(AButton);
    end;

    if mbCancel in AButtons then
      ACancelButton := mbCancel
    else if mbNo in AButtons then
      ACancelButton := mbNo
    else
      ACancelButton := mbOK;

    AButtonControl := FindButton(ACancelButton);
    if AButtonControl <> nil then
      AButtonControl.Cancel := True;

    AlignButtons;
  finally
    lcMain.EndUpdate(False);
  end;
end;

procedure TdxMessageDialogForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  if FOwnerWndHandle <> 0 then
    Params.WndParent := FOwnerWndHandle;
end;

procedure TdxMessageDialogForm.DoShow;
begin
  inherited;
  PlaySound;
end;

procedure TdxMessageDialogForm.DXMScaleChanged(var AMessage: TMessage);
begin
  inherited;
  InitializeIcon(DialogType);
  InitializeFont;
  FixMessageHeight;
end;

procedure TdxMessageDialogForm.FormCreate(Sender: TObject);
begin
  UpdateMessageConstraints;
end;

procedure TdxMessageDialogForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) and (Key = Word('C')) then
  begin
    MessageBeep(0);
    Clipboard.AsText := ToString;
  end;
end;

procedure TdxMessageDialogForm.FormShow(Sender: TObject);
begin
  FixMessageHeight;
end;

function TdxMessageDialogForm.GetButton(Index: Integer): TcxButton;
begin
  Result := (lcButtonHost.Items[Index] as TdxLayoutItem).Control as TcxButton;
end;

function TdxMessageDialogForm.GetButtonCaption(AButton: TMsgDlgBtn): string;
var
  AResString: Pointer;
begin
  case AButton of
    mbAbort:
      AResString := @SMsgDlgAbort;
    mbAll:
      AResString := @SMsgDlgAll;
    mbCancel:
      AResString := @SMsgDlgCancel;
    mbClose:
      AResString := @SMsgDlgClose;
    mbHelp:
      AResString := @SMsgDlgHelp;
    mbIgnore:
      AResString := @SMsgDlgIgnore;
    mbNo:
      AResString := @SMsgDlgNo;
    mbNoToAll:
      AResString := @SMsgDlgNoToAll;
    mbOK:
      AResString := @SMsgDlgOK;
    mbRetry:
      AResString := @SMsgDlgRetry;
    mbYes:
      AResString := @SMsgDlgYes;
    mbYesToAll:
      AResString := @SMsgDlgYesToAll;
  else
    AResString := nil;
  end;
  Result := cxGetResourceString(AResString);
end;

function TdxMessageDialogForm.GetButtonCount: Integer;
begin
  Result := lcButtonHost.Count;
end;

function TdxMessageDialogForm.GetDialogCaption(AType: TMsgDlgType): string;
begin
  case AType of
    mtWarning:
      Result := cxGetResourceString(@SMsgDlgWarning);
    mtError:
      Result := cxGetResourceString(@SMsgDlgError);
    mtInformation:
      Result := cxGetResourceString(@SMsgDlgInformation);
    mtConfirmation:
      Result := cxGetResourceString(@SMsgDlgConfirm);
  else
    Result := Application.Title;
  end;
end;

procedure TdxMessageDialogForm.InitializeIcon(AType: TMsgDlgType);
const
  IconIDs: array[TMsgDlgType] of PChar = (IDI_EXCLAMATION, IDI_HAND, IDI_ASTERISK, IDI_QUESTION, nil);
var
  AIcon: TIcon;
  AIconHandle: HICON;
  AIconSize: TSize;
begin
  if IconIDs[AType] = nil then
  begin
    lcIcon.Visible := False;
    Exit;
  end;

  if UseLatestCommonDialogs and IsWin10OrLater and (GetComCtlVersion >= ComCtlVersionIE6) then
  begin
    AIconSize.cx := dxGetSystemMetrics(SM_CXICON, ScaleFactor);
    AIconSize.cy := dxGetSystemMetrics(SM_CYICON, ScaleFactor);
    if Succeeded(LoadIconWithScaleDown(0, IconIDs[AType], AIconSize.cx, AIconSize.cy, AIconHandle)) then
    begin
      AIcon := TIcon.Create;
      try
        AIcon.Handle := AIconHandle;
        lcIcon.Image.Assign(AIcon);
        lcIcon.Image.SourceDPI := ScaleFactor.TargetDPI;
      finally
        AIcon.Free;
      end;
      Exit;
    end;
  end;

  AIcon := TIcon.Create;
  try
    AIcon.Handle := LoadIcon(0, IconIDs[AType]);
    lcIcon.Image.Assign(AIcon);
    lcIcon.Image.SourceDPI := dxGetSystemDPI;
  finally
    AIcon.Free;
  end;
end;

procedure TdxMessageDialogForm.InitializeFont;
begin
  dxAssignFont(Font, Screen.MessageFont, ScaleFactor, dxSystemScaleFactor);
end;

procedure TdxMessageDialogForm.PlaySound;
const
  MessageMap: array[TMsgDlgType] of Integer = (MB_ICONWARNING, MB_ICONERROR, MB_ICONINFORMATION, MB_ICONINFORMATION, 0);
begin
  if MessageMap[DialogType] <> 0 then
    MessageBeep(MessageMap[DialogType]);
end;

procedure TdxMessageDialogForm.UpdateMessageConstraints;
var
  AIndents: Integer;
begin
  AIndents := lcContentHost.Offsets.Right + lcContentHost.Offsets.Left;
  if lcIcon.Visible then
    Inc(AIndents, dxGetSystemMetrics(SM_CXICON, ScaleFactor));

  lcMain.BeginUpdate;
  try
    lcMainGroup_Root.SizeOptions.Width := 0;
    lcMessage.SizeOptions.MaxWidth := 0;
    lcMessage.CaptionOptions.Width := 0;

    if UseLatestCommonDialogs and IsWinVistaOrLater then
    begin
      if Style = mdsMessageBox then
      begin
        lcMainGroup_Root.SizeOptions.Width := ScaleFactor.Apply(MinimalMessageBoxWidth);
        lcMessage.SizeOptions.MaxWidth := ScaleFactor.Apply(MinimalTaskDialogWidth) - AIndents;
      end
      else
        lcMessage.CaptionOptions.Width := ScaleFactor.Apply(MinimalTaskDialogWidth) - AIndents;
    end
    else
      lcMessage.SizeOptions.MaxWidth := ScaleFactor.Apply(Screen.Width div 2, dxSystemScaleFactor) - AIndents;
  finally
    lcMain.EndUpdate;
  end;
end;

function TdxMessageDialogForm.GetMessage: string;
begin
  Result := lcMessage.Caption;
end;

procedure TdxMessageDialogForm.SetMessage(const Value: string);
begin
  if Message <> Value then
  begin
    lcMain.BeginUpdate;
    try
      lcMessage.Caption := Value;
      UpdateMessageConstraints;
    finally
      lcMain.EndUpdate(False);
    end;
  end;
end;

procedure TdxMessageDialogForm.SetStyle(AStyle: TdxMessageDialogStyle);
var
  APadding: Integer;
begin
  if AStyle <> FStyle then
  begin
    FStyle := AStyle;

    lcMain.BeginUpdate;
    try
      APadding := ScaleFactor.Apply(IfThen(Style = mdsMessageBox, MessageBoxPadding, 0));
      lcContentHost.Offsets.Bottom := APadding;
      lcContentHost.Offsets.Left := APadding;
      lcContentHost.Offsets.Right := APadding;
      lcContentHost.Offsets.Top := APadding;
      UpdateMessageConstraints;
    finally
      lcMain.EndUpdate(False);
    end;
  end;
end;

procedure TdxMessageDialogForm.ButtonClick(Sender: TObject);
const
  ModalResultMap: array[TMsgDlgBtn] of Integer = (
    mrYes, mrNo, mrOk, mrCancel, mrAbort, mrRetry, mrIgnore, mrAll, mrNoToAll, mrYesToAll, 0, mrClose
  );
var
  AButtonKind: TMsgDlgBtn;
begin
  AButtonKind := TMsgDlgBtn((Sender as TcxButton).Tag);
  if AButtonKind = mbHelp then
    Application.HelpContext(HelpContext)
  else
    ModalResult := ModalResultMap[AButtonKind];
end;

end.
