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

unit dxColorDialog;

{$I cxVer.inc}

interface

uses
  Windows, Classes, Graphics, Dialogs, Controls, cxClasses, dxCoreGraphics, dxColorPicker, cxLookAndFeels, dxCoreClasses;

type
  TdxColorDialogBasicColors = array[0..47] of TdxAlphaColor;
  TdxColorDialogCustomColors = array[0..15] of TdxAlphaColor;

const
  dxColorDialogDefaultBasicColors: TdxColorDialogBasicColors = (
    $FFFF8080, $FFFFFF80, $FF80FF80, $FF00FF80, $FF80FFFF, $FF0080FF, $FFFF80C0, $FFFF80FF,
    $FFFF0000, $FFFFFF00, $FF80FF00, $FF00FF40, $FF00FFFF, $FF0080C0, $FF8080C0, $FFFF00FF,
    $FF804040, $FFFF8040, $FF00FF00, $FF008080, $FF004080, $FF8080FF, $FF800040, $FFFF0080,
    $FF800000, $FFFF8000, $FF008000, $FF008040, $FF0000FF, $FF0000A0, $FF800080, $FF8000FF,
    $FF400000, $FF804000, $FF004000, $FF004040, $FF000080, $FF000040, $FF400040, $FF400080,
    $FF000000, $FF808000, $FF808040, $FF808080, $FF408080, $FFC0C0C0, $FF400040, $FFFFFFFF
  );

type

  { TdxColorDialogColorPickerOptions }

  TdxColorDialogColorPickerOptions = class(TdxColorPickerOptionsView)
  strict private
    FDefaultVisible: Boolean;
  protected
    procedure DoAssign(Source: TPersistent); override;
  published
    property DefaultVisible: Boolean read FDefaultVisible write FDefaultVisible default False;
  end;

  { TdxColorDialogOptions }

  TdxColorDialogOptions = class(TcxOwnedPersistent)
  strict private
    FAllowEditColor: Boolean;
    FColorPicker: TdxColorDialogColorPickerOptions;

    procedure SetColorPicker(AValue: TdxColorDialogColorPickerOptions);
  protected
    function CreateColorPicker: TdxColorDialogColorPickerOptions; virtual;
    procedure DoAssign(Source: TPersistent); override;
  public
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;
  published
    property AllowEditColor: Boolean read FAllowEditColor write FAllowEditColor default True;
    property ColorPicker: TdxColorDialogColorPickerOptions read FColorPicker write SetColorPicker;
  end;

  { TdxColorDialogHelper }

  TdxColorDialogHelper = class
  public
    class procedure AddToCustomColors(AList: TStrings; AColor: TdxAlphaColor; AAllowAlpha: Boolean);
    class procedure LoadCustomColors(AList: TStrings; out ACustomColors: TdxColorDialogCustomColors);
    class procedure SaveCustomColors(AList: TStrings; const ACustomColors: TdxColorDialogCustomColors; AAllowAlpha: Boolean);
  end;

  { TdxCustomColorDialog }

  TdxColorDialogGetBasicColorsEvent = procedure (Sender: TObject; var BasicColors: TdxColorDialogBasicColors) of object;

  TdxCustomColorDialog = class(TcxCustomComponent, IcxLookAndFeelContainer, IdxSkinSupport)
  strict private
    FColor: TdxAlphaColor;
    FCustomColors: TStrings;
    FHandle: HWND;
    FLookAndFeel: TcxLookAndFeel;
    FOptions: TdxColorDialogOptions;

    FOnClose: TNotifyEvent;
    FOnGetBasicColors: TdxColorDialogGetBasicColorsEvent;
    FOnShow: TNotifyEvent;

    procedure SetCustomColors(AValue: TStrings);
    procedure SetLookAndFeel(AValue: TcxLookAndFeel);
    procedure SetOptions(AValue: TdxColorDialogOptions);
  protected
    function CreateOptions: TdxColorDialogOptions; virtual;
    procedure DoClose; virtual;
    procedure DoGetBasicColors(var ABasicColors: TdxColorDialogBasicColors); virtual;
    procedure DoShow; virtual;

    // IcxLookAndFeelContainer
    function GetLookAndFeel: TcxLookAndFeel;
    //
    property Color: TdxAlphaColor read FColor write FColor default 0;
    property CustomColors: TStrings read FCustomColors write SetCustomColors;
    property LookAndFeel: TcxLookAndFeel read GetLookAndFeel write SetLookAndFeel;
    property Options: TdxColorDialogOptions read FOptions write SetOptions;
    //
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
    property OnGetBasicColors: TdxColorDialogGetBasicColorsEvent read FOnGetBasicColors write FOnGetBasicColors;
    property OnShow: TNotifyEvent read FOnShow write FOnShow;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean; overload; virtual;
    function Execute(AParentWnd: HWND): Boolean; overload; virtual;
    //
    property Handle: HWND read FHandle;
  end;

  { TdxColorDialog }

  TdxColorDialog = class(TdxCustomColorDialog)
  published
    property Color;
    property CustomColors;
    property LookAndFeel;
    property Options;

    property OnClose;
    property OnGetBasicColors;
    property OnShow;
  end;

  { TdxGlobalColorDialog }

  TdxGlobalColorDialog = class
  private
    class var FCustomColors: TStrings;
  protected
    class function ExecuteCore(var AColor: TdxAlphaColor; AAllowEditAlpha: Boolean; AParentWnd: HWND = 0): Boolean;
    class procedure Finalize; static;
    class procedure Initialize; static;
  public
    class function Execute(var AColor: TColor; AParentWnd: HWND = 0): Boolean; overload;
    class function Execute(var AColor: TdxAlphaColor; AParentWnd: HWND = 0): Boolean; overload;
    class property CustomColors: TStrings read FCustomColors;
  end;

implementation

uses
  dxColorDialogForm, SysUtils, Forms, dxCore, cxGraphics, cxControls;

const
  dxThisUnitName = 'dxColorDialog';

const
  sdxCustomColorPrefix = 'Color';

{ TdxColorDialogColorPickerOptions }

procedure TdxColorDialogColorPickerOptions.DoAssign(Source: TPersistent);
begin
  inherited DoAssign(Source);
  if Source is TdxColorDialogColorPickerOptions then
    DefaultVisible := TdxColorDialogColorPickerOptions(Source).DefaultVisible;
end;

{ TdxColorDialogOptions }

constructor TdxColorDialogOptions.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FColorPicker := CreateColorPicker;
  FAllowEditColor := True;
end;

destructor TdxColorDialogOptions.Destroy;
begin
  FreeAndNil(FColorPicker);
  inherited Destroy;
end;

function TdxColorDialogOptions.CreateColorPicker: TdxColorDialogColorPickerOptions;
begin
  Result := TdxColorDialogColorPickerOptions.Create(Self);
end;

procedure TdxColorDialogOptions.DoAssign(Source: TPersistent);
begin
  inherited DoAssign(Source);
  if Source is TdxColorDialogOptions then
  begin
    ColorPicker := TdxColorDialogOptions(Source).ColorPicker;
    AllowEditColor := TdxColorDialogOptions(Source).AllowEditColor;
  end;
end;

procedure TdxColorDialogOptions.SetColorPicker(AValue: TdxColorDialogColorPickerOptions);
begin
  FColorPicker.Assign(AValue);
end;

{ TdxColorDialogHelper }

class procedure TdxColorDialogHelper.AddToCustomColors(AList: TStrings; AColor: TdxAlphaColor; AAllowAlpha: Boolean);
var
  AColors: TdxColorDialogCustomColors;
  AIndex: Integer;
  AIndexToInsert: Integer;
begin
  LoadCustomColors(AList, AColors);
  for AIndex := Low(TdxColorDialogCustomColors) to High(TdxColorDialogCustomColors) do
  begin
    if AColors[AIndex] = AColor then
      Exit;
  end;

  AIndexToInsert := High(TdxColorDialogCustomColors);
  for AIndex := Low(TdxColorDialogCustomColors) to High(TdxColorDialogCustomColors) do
    if AColors[AIndex] = 0 then
    begin
      AIndexToInsert := AIndex;
      Break;
    end;

  AColors[AIndexToInsert] := AColor;
  SaveCustomColors(AList, AColors, AAllowAlpha);
end;

class procedure TdxColorDialogHelper.LoadCustomColors(AList: TStrings; out ACustomColors: TdxColorDialogCustomColors);
var
  AValue: string;
  I: Integer;
begin
  for I := 0 to Length(ACustomColors) - 1 do
  begin
    AValue := AList.Values[sdxCustomColorPrefix + Char(Ord('A') + I)];
    if AValue <> '' then
      ACustomColors[I] := TdxAlphaColors.FromHexCode(AValue, True)
    else
      ACustomColors[I] := 0;
  end;
end;

class procedure TdxColorDialogHelper.SaveCustomColors(AList: TStrings;
  const ACustomColors: TdxColorDialogCustomColors; AAllowAlpha: Boolean);
var
  AColor: TdxAlphaColor;
  I: Integer;
begin
  AList.BeginUpdate;
  try
    AList.Clear;
    for I := 0 to Length(ACustomColors) - 1 do
    begin
      AColor := ACustomColors[I];
      if dxAlphaColorIsValid(AColor) then
        AList.Values[sdxCustomColorPrefix + Char(Ord('A') + I)] := TdxAlphaColors.ToHexCode(AColor, AAllowAlpha, True);
    end;
  finally
    AList.EndUpdate;
  end;
end;

{ TdxCustomColorDialog }

constructor TdxCustomColorDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCustomColors := TStringList.Create;
  FLookAndFeel := TcxLookAndFeel.Create(Self);
  FOptions := CreateOptions;
end;

destructor TdxCustomColorDialog.Destroy;
begin
  FreeAndNil(FCustomColors);
  FreeAndNil(FLookAndFeel);
  FreeAndNil(FOptions);
  inherited Destroy;
end;

function TdxCustomColorDialog.Execute: Boolean;
begin
  Result := Execute(dxGetActualParentWindowForModalDialog);
end;

function TdxCustomColorDialog.Execute(AParentWnd: HWND): Boolean;
var
  ABasicColors: TdxColorDialogBasicColors;
  ACustomColors: TdxColorDialogCustomColors;
  ADialog: TdxColorDialogForm;
begin
  ADialog := dxColorDialogFormClass.Create(Self, AParentWnd);
  try
    ADialog.LookAndFeel.MasterLookAndFeel := LookAndFeel;
    ADialog.cpColorPicker.OptionsView := Options.ColorPicker;
    ADialog.ShowFull := Options.ColorPicker.DefaultVisible;
    ADialog.PreventShowFull := not Options.AllowEditColor;

    ABasicColors := dxColorDialogDefaultBasicColors;
    DoGetBasicColors(ABasicColors);
    ADialog.LoadBasicColors(ABasicColors);

    TdxColorDialogHelper.LoadCustomColors(CustomColors, ACustomColors);
    ADialog.LoadCustomColors(ACustomColors);
    ADialog.Color := Color;

    FHandle := ADialog.Handle;
    try
      DoShow;
      try
        Result := ADialog.ShowModal = mrOk;
        if Result then
        begin
          Color := ADialog.Color;
          ADialog.SaveCustomColors(ACustomColors);
          TdxColorDialogHelper.SaveCustomColors(CustomColors, ACustomColors, Options.ColorPicker.AllowEditAlpha);
        end;
      finally
        DoClose;
      end;
    finally
      FHandle := 0;
    end;
  finally
    ADialog.Free;
  end;
end;

function TdxCustomColorDialog.CreateOptions: TdxColorDialogOptions;
begin
  Result := TdxColorDialogOptions.Create(Self);
end;

procedure TdxCustomColorDialog.DoClose;
begin
  dxCallNotify(OnClose, Self);
end;

procedure TdxCustomColorDialog.DoGetBasicColors(var ABasicColors: TdxColorDialogBasicColors);
begin
  if Assigned(OnGetBasicColors) then
    OnGetBasicColors(Self, ABasicColors);
end;

procedure TdxCustomColorDialog.DoShow;
begin
  dxCallNotify(OnShow, Self);
end;

function TdxCustomColorDialog.GetLookAndFeel: TcxLookAndFeel;
begin
  Result := FLookAndFeel;
end;

procedure TdxCustomColorDialog.SetCustomColors(AValue: TStrings);
begin
  FCustomColors.Assign(AValue);
end;

procedure TdxCustomColorDialog.SetLookAndFeel(AValue: TcxLookAndFeel);
begin
  FLookAndFeel.Assign(AValue);
end;

procedure TdxCustomColorDialog.SetOptions(AValue: TdxColorDialogOptions);
begin
  FOptions.Assign(AValue);
end;

{ TdxGlobalColorDialog }

class function TdxGlobalColorDialog.Execute(var AColor: TColor; AParentWnd: HWND): Boolean;
var
  AAlphaColor: TdxAlphaColor;
begin
  AAlphaColor := dxColorToAlphaColor(AColor);
  Result := ExecuteCore(AAlphaColor, False, AParentWnd);
  if Result then
    AColor := dxAlphaColorToColor(AAlphaColor);
end;

class function TdxGlobalColorDialog.Execute(var AColor: TdxAlphaColor; AParentWnd: HWND): Boolean;
begin
  Result := ExecuteCore(AColor, True, AParentWnd);
end;

class function TdxGlobalColorDialog.ExecuteCore(var AColor: TdxAlphaColor; AAllowEditAlpha: Boolean; AParentWnd: HWND): Boolean;
var
  ACustomColors: TdxColorDialogCustomColors;
  ADialog: TdxColorDialogForm;
begin
  if AParentWnd = 0 then
    AParentWnd := dxGetActualParentWindowForModalDialog;

  ADialog := dxColorDialogFormClass.Create(Application, AParentWnd);
  try
    ADialog.ShowFull := True;
    ADialog.cpColorPicker.OptionsView.AllowEditAlpha := AAllowEditAlpha;
    ADialog.cpColorPicker.OptionsView.RGBHexNotation := cphnHTML;

    TdxColorDialogHelper.LoadCustomColors(CustomColors, ACustomColors);
    ADialog.LoadBasicColors(dxColorDialogDefaultBasicColors);
    ADialog.LoadCustomColors(ACustomColors);
    ADialog.Color := AColor;

    Result := ADialog.ShowModal = mrOk;
    if Result then
    begin
      AColor := ADialog.Color;
      ADialog.SaveCustomColors(ACustomColors);
      TdxColorDialogHelper.SaveCustomColors(CustomColors, ACustomColors, True);
    end;
  finally
    ADialog.Free;
  end;
end;

class procedure TdxGlobalColorDialog.Finalize;
begin
  FreeAndNil(FCustomColors);
end;

class procedure TdxGlobalColorDialog.Initialize;
begin
  FCustomColors := TStringList.Create;
end;

initialization

  dxUnitsLoader.AddUnit(SysInit.HInstance, dxThisUnitName, TdxGlobalColorDialog.Initialize, TdxGlobalColorDialog.Finalize);

finalization

  dxUnitsLoader.RemoveUnit(SysInit.HInstance, dxThisUnitName, TdxGlobalColorDialog.Finalize);

end.
