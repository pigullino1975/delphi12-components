{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressSkins Library                                     }
{                                                                    }
{           Copyright (c) 2006-2024 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSSKINS AND ALL ACCOMPANYING     }
{   VCL CONTROLS AS PART OF AN EXECUTABLE PROGRAM ONLY.              }
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

unit dxSkinsReg;

{$I cxVer.inc}

interface

uses
  Windows, Classes, cxClasses, Forms, Types, DesignIntf, DesignEditors,  VCLEditors, SysUtils, TypInfo,
  Generics.Collections, Generics.Defaults, dxCoreReg, cxLibraryReg, cxLookAndFeels, cxLookAndFeelPainters,
  dxSkinsCore, dxSkinsLookAndFeelPainter, dxSkinsDefaultPainters, dxSkinsForm, ToolsApi, CommonOptionStrs;

const
  dxSkinsProductName = 'ExpressSkins';

type
  TdxSkinModifyProjectOptionsProc = procedure;

  { TdxSkinNameProperty }

  TdxSkinNameProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  { TdxSkinPaletteNameProperty }

  TdxSkinPaletteNameProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  { TdxSkinControllerEditor }

  TdxSkinControllerEditor = class(TdxComponentEditor)
  protected
    function GetProductName: string; override;
    function InternalGetVerb(AIndex: Integer): string; override;
    function InternalGetVerbCount: Integer; override;
    procedure InternalExecuteVerb(AIndex: Integer); override;
  public
    procedure Edit; override;
    procedure ResetControllerState;
  end;

  { TdxSkinControllerSelectionEditor }

  TdxSkinControllerSelectionEditor = class(TSelectionEditor)
  public
    procedure RequiresUnits(Proc: TGetStrProc); override;
  end;

  { TdxSkinsPackageManager }

  TdxSkinsPackageManager = class
  strict private const
    sdxSkinUnitPrefix = 'dxSkin';
  strict private type
  {$REGION 'Private Types'}
    TPackageInfo = class
      PackageFileName: string;
      PackageHandle: THandle;
      PackageUnits: TStringList;
      SkinNames: TStringList;
      SkinUnits: TStringList;

      constructor Create;
      destructor Destroy; override;
      function CheckLoaded: Boolean;
    end;
  {$ENDREGION}
  strict private
    class var FIsPackageLoading: Boolean;
    class var FPackages: TObjectList<TPackageInfo>;

    class function EnumResNameProc(hModule: HMODULE;
      lpszType: LPCTSTR; lpszName: LPTSTR; AInfo: TPackageInfo): Boolean; stdcall; static;
    class procedure EnumPackageUnitsProc(const Name: string; NameType: TNameType; Flags: Byte; Info: TPackageInfo); static;
    class procedure PackagesNeeded;
    class procedure PopulatePackagesList;
    class function TryGetPackageInfo(const AFileName: string; out AInfo: TPackageInfo): Boolean;
    class function TryLoadPackageForSkin(const ASkinName: string): Boolean;
  protected
    class procedure DoEnumSkins(AEnumProc: TdxSkinEnumProc); static;
    class procedure DoGetSkinNames(AList: TStrings); static;
    class function DoGetPainter(const ASkinName: string): TcxCustomLookAndFeelPainter; static;
  public
    class procedure UpdateRunTimePackages(const AProject: IOTAProject);
    class procedure EnumSkinNames(AProc: TdxSkinEnumProc);
    class procedure Finalize;
    class procedure Initialize;
    class function IsPackageLoading: Boolean;
  end;

var
  FdxSkinModifyProjectOptionsProc: TdxSkinModifyProjectOptionsProc;

procedure Register;

implementation

uses
  StrUtils, cxControls, dxSkinsStrs, dxSkinInfo, dxCore;

const
  dxThisUnitName = 'dxSkinsReg';

procedure Register;
begin
  ForceDemandLoadState(dlDisable);
  RegisterComponents(dxCoreLibraryProductPage, [TdxSkinController]);
  RegisterClasses([TdxSkinController]);
  RegisterSelectionEditor(TdxSkinController, TdxSkinControllerSelectionEditor);
  RegisterPropertyEditor(TypeInfo(TdxSkinName), nil, 'SkinName', TdxSkinNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TdxSkinController, 'SkinPaletteName', TdxSkinPaletteNameProperty);
  RegisterComponentEditor(TdxSkinController, TdxSkinControllerEditor);
end;

{ TdxSkinNameProperty }

function TdxSkinNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes - [paReadOnly] + [paValueList];
end;

procedure TdxSkinNameProperty.GetValues(Proc: TGetStrProc);
begin
  dxSkinsEnumSkins(
    procedure (const ASkinName, AUnitName: string)
    begin
      if dxSkinListCanUseSkin(ASkinName) then
        Proc(ASkinName);
    end);
end;

{ TdxSkinPaletteNameProperty }

function TdxSkinPaletteNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes - [paReadOnly] + [paValueList];
end;

procedure TdxSkinPaletteNameProperty.GetValues(Proc: TGetStrProc);
var
  AData: TdxSkinInfo;
  APalettes: TStringList;
  I: Integer;
begin
  if TdxSkinController.GetPainterData(AData) and (AData.Skin.ColorPalettes.Count > 0) then
  begin
    APalettes := TStringList.Create;
    try
      TdxSkinController.PopulateSkinColorPalettes(APalettes);
      for I := 0 to APalettes.Count - 1 do
        Proc(APalettes[I]);
    finally
      APalettes.Free;
    end;
  end
  else
    Proc(sdxDefaultColorPaletteName);
end;

{ TdxSkinControllerEditor }

procedure TdxSkinControllerEditor.Edit;
begin
  if Assigned(FdxSkinModifyProjectOptionsProc) then
    FdxSkinModifyProjectOptionsProc;
end;

function TdxSkinControllerEditor.InternalGetVerb(AIndex: Integer): string;
begin
  if Assigned(FdxSkinModifyProjectOptionsProc) and (AIndex = 0) then
    Result := 'Modify Project Skin Options'
  else
    Result := 'Reset';
end;

function TdxSkinControllerEditor.InternalGetVerbCount: Integer;
const
  VerbsCountMap: array[Boolean] of Integer = (1, 2);
begin
  Result := VerbsCountMap[Assigned(FdxSkinModifyProjectOptionsProc)];
end;

procedure TdxSkinControllerEditor.InternalExecuteVerb(AIndex: Integer);
begin
  if Assigned(FdxSkinModifyProjectOptionsProc) and (AIndex = 0) then
    FdxSkinModifyProjectOptionsProc
  else
    ResetControllerState;
end;

procedure TdxSkinControllerEditor.ResetControllerState;
begin
  TdxSkinController(Component).Reset;
  Designer.Modified;
end;

function TdxSkinControllerEditor.GetProductName: string;
begin
  Result := dxSkinsProductName;
end;

{ TdxSkinControllerSelectionEditor }

procedure TdxSkinControllerSelectionEditor.RequiresUnits(Proc: TGetStrProc);
begin
  Proc('dxCore');
end;

{ TdxSkinsPackageManager }

class procedure TdxSkinsPackageManager.UpdateRunTimePackages(const AProject: IOTAProject);

  procedure AddPackages(const APropertyName: string; const  AConfig: IOTABuildConfiguration; const AExtName: string = '');
  var
    APropertyValue: string;
    APackageName, APackages: string;
    I: Integer;
  begin
    if AConfig.PropertyExists(APropertyName) then
    begin
      APackages := '';
      APropertyValue := AConfig.Value[APropertyName];
      for I := 0 to FPackages.Count - 1 do
      begin
        APackageName := ChangeFileExt(ExtractFileName(FPackages[I].PackageFileName), '');
        if (APackageName <> '') and not ContainsText(APropertyValue, APackageName) then
          APackages := APackages + IfThen(APackages <> '', ';') + APackageName;
      end;
      AConfig.Value[APropertyName] := APropertyValue + IfThen((APropertyValue <> '') and (APackages <> ''), ';') + APackages;
    end;
  end;

  procedure ProcessConfig(const  AConfig: IOTABuildConfiguration);
  const
    ConfigKey = 'Base_Win';
  var
    I: Integer;
    APlatformName: string;
  begin
    if ContainsText(AProject.Personality, 'CPlusPlusBuilder') and ContainsText(AConfig.Key, 'Base') then
      AddPackages('AllPackageLibs', AConfig, '.lib');
    if ContainsText(AConfig.Key, ConfigKey) then
    begin
      if ContainsText(AProject.Personality, 'Delphi') then
        AddPackages('DCC_UsePackage', AConfig)
      else
        AddPackages('PackageImports', AConfig);
    end
    else
    begin
      for I := 0 to AConfig.ChildCount - 1 do
        ProcessConfig(AConfig.Children[I]);
      for APlatformName in AConfig.GetPlatforms do
        ProcessConfig(AConfig.GetPlatformConfiguration(APlatformName));
    end;
  end;

var
  AProjectConfig: IOTAProjectOptionsConfigurations;
begin
  if Supports(AProject.ProjectOptions, IOTAProjectOptionsConfigurations, AProjectConfig) then
  begin
    if not AProjectConfig.ActiveConfiguration.GetBoolean(sUsePackages) then
      Exit;
    ProcessConfig(AProjectConfig.BaseConfiguration);
  end;
end;

class procedure TdxSkinsPackageManager.EnumSkinNames(AProc: TdxSkinEnumProc);
var
  ANames: TStringList;
  AUnits: TStringList;
  I, J: Integer;
begin
  PackagesNeeded;
  for I := 0 to FPackages.Count - 1 do
  begin
    ANames := FPackages[I].SkinNames;
    AUnits := FPackages[I].SkinUnits;
    for J := 0 to ANames.Count - 1 do
      AProc(ANames[J], AUnits[J]);
  end;
end;

class procedure TdxSkinsPackageManager.Finalize;
begin
  FdxSkinsEnumSkinsProc := nil;
  GetSkinPainterProc := nil;
  GetSkinNamesProc := nil;
  FreeAndNil(FPackages);
end;

class procedure TdxSkinsPackageManager.Initialize;
begin
  GetSkinNamesProc := DoGetSkinNames;
  GetSkinPainterProc := DoGetPainter;
  FdxSkinsEnumSkinsProc := DoEnumSkins;
end;

class function TdxSkinsPackageManager.IsPackageLoading: Boolean;
begin
  Result := FIsPackageLoading;
end;

class procedure TdxSkinsPackageManager.DoEnumSkins(AEnumProc: TdxSkinEnumProc);
var
  APainter: TcxCustomLookAndFeelPainter;
  AValues: TStringList;
  I: Integer;
begin
  AValues := TStringList.Create;
  try
    for I := 0 to cxLookAndFeelPaintersManager.Count - 1 do
    begin
      APainter := cxLookAndFeelPaintersManager[I];
      if APainter.LookAndFeelStyle = lfsSkin then
        AValues.Add(APainter.LookAndFeelName + AValues.NameValueSeparator + cxGetUnitName(APainter.ClassType));
    end;

    TdxSkinsPackageManager.EnumSkinNames(
      procedure (const ASkinName, AUnitName: string)
      begin
        if AValues.IndexOfName(ASkinName) < 0 then
          AValues.Add(ASkinName + AValues.NameValueSeparator + AUnitName);
      end);

    AValues.Sort;
    for I := 0 to AValues.Count - 1 do
      AEnumProc(AValues.Names[I], AValues.ValueFromIndex[I]);
  finally
    AValues.Free;
  end;
end;

class procedure TdxSkinsPackageManager.DoGetSkinNames(AList: TStrings);
begin
  DoEnumSkins(
    procedure (const ASkinName, AUnitName: string)
    begin
      AList.Add(ASkinName);
    end);
end;

class function TdxSkinsPackageManager.DoGetPainter(const ASkinName: string): TcxCustomLookAndFeelPainter;
begin
  if TryLoadPackageForSkin(ASkinName) then
    Result := cxLookAndFeelPaintersManager.GetPainter(ASkinName)
  else
    Result := nil;
end;

class function TdxSkinsPackageManager.EnumResNameProc(
  hModule: HMODULE; lpszType: LPCTSTR; lpszName: LPTSTR; AInfo: TPackageInfo): Boolean; stdcall;
var
  AReader: TdxSkinBinaryReader;
  ASkinName: string;
  ASkinUnitName: string;
  AStream: TStream;
  I: Integer;
begin
  AStream := TResourceStream.Create(hModule, lpszName, lpszType);
  try
    AReader := TdxSkinBinaryReader.Create(AStream);
    try
      for I := 0 to AReader.Count - 1 do
      begin
        ASkinName := AReader.SkinName[I];
        ASkinUnitName := sdxSkinUnitPrefix + ASkinName;
        if AInfo.PackageUnits.IndexOf(ASkinUnitName) >= 0 then
        begin
          AInfo.SkinNames.Add(ASkinName);
          AInfo.SkinUnits.Add(ASkinUnitName);
        end;
      end;
    finally
      AReader.Free;
    end;
  finally
    AStream.Free;
  end;
  Result := True;
end;

class procedure TdxSkinsPackageManager.EnumPackageUnitsProc(
  const Name: string; NameType: TNameType; Flags: Byte; Info: TPackageInfo);
begin
  if NameType = ntContainsUnit then
    Info.PackageUnits.Add(Name);
end;

class procedure TdxSkinsPackageManager.PackagesNeeded;
begin
  if FPackages = nil then
  begin
    FPackages := TObjectList<TPackageInfo>.Create;
    PopulatePackagesList;
  end;
end;

class procedure TdxSkinsPackageManager.PopulatePackagesList;
var
  AInfo: TPackageInfo;
  APackageFileName: string;
  APath: string;
  ASearchRec: TSearchRec;
  ASuffix: string;
begin
  APackageFileName := GetModuleName(HInstance);
  ASuffix := ChangeFileExt(APackageFileName, '');
  ASuffix := Copy(ASuffix, Length(ASuffix) - 3, 4);
  APath := ExtractFilePath(APackageFileName);
  if FindFirst(APath + sdxSkinUnitPrefix + '*' + ASuffix + '.bpl', faAnyFile, ASearchRec) = 0 then
  try
    repeat
      if TryGetPackageInfo(APath + ASearchRec.Name, AInfo) then
        FPackages.Add(AInfo);
    until FindNext(ASearchRec) <> 0;
  finally
    FindClose(ASearchRec);
  end;
end;

class function TdxSkinsPackageManager.TryGetPackageInfo(const AFileName: string; out AInfo: TPackageInfo): Boolean;
var
  AFlags: Integer;
  ALibHandle: THandle;
begin
  Result := False;
  if GetModuleHandle(PChar(AFileName)) = 0 then
  begin
    ALibHandle := LoadLibraryEx(PChar(AFileName), 0, LOAD_LIBRARY_AS_DATAFILE);
    try
      AInfo := TPackageInfo.Create;
      AInfo.PackageFileName := AFileName;
      GetPackageInfo(ALibHandle, AInfo, AFlags, @EnumPackageUnitsProc);
      Windows.EnumResourceNames(ALibHandle, PChar(sdxResourceType), @EnumResNameProc, LPARAM(AInfo));
      Result := AInfo.SkinNames.Count > 0;
      if not Result then
        FreeAndNil(AInfo);
    finally
      FreeLibrary(ALibHandle);
    end;
  end;
end;

class function TdxSkinsPackageManager.TryLoadPackageForSkin(const ASkinName: string): Boolean;
var
  APackageInfo: TPackageInfo;
  I: Integer;
begin
  PackagesNeeded;
  for I := 0 to FPackages.Count - 1 do
  begin
    APackageInfo := FPackages[I];
    if APackageInfo.SkinNames.IndexOf(ASkinName) >= 0 then
      Exit(APackageInfo.CheckLoaded);
  end;
  Result := False;
end;

{ TdxSkinsPackageManager.TPackageInfo }

constructor TdxSkinsPackageManager.TPackageInfo.Create;
begin
  SkinNames := TStringList.Create;
  PackageUnits := TStringList.Create;
  SkinUnits := TStringList.Create;
end;

destructor TdxSkinsPackageManager.TPackageInfo.Destroy;
begin
  if (PackageHandle <> 0) and (PackageHandle <> INVALID_HANDLE_VALUE) then
    UnloadPackage(PackageHandle);
  FreeAndNil(PackageUnits);
  FreeAndNil(SkinNames);
  FreeAndNil(SkinUnits);
  inherited;
end;

function TdxSkinsPackageManager.TPackageInfo.CheckLoaded: Boolean;
begin
  if PackageHandle = 0 then
  begin
    FIsPackageLoading := True;
    try
      cxLookAndFeelPaintersManager.BeginUpdate;
      try
        PackageHandle := LoadPackage(PackageFileName);
        if PackageHandle < 32 then
          PackageHandle := INVALID_HANDLE_VALUE;
      finally
        cxLookAndFeelPaintersManager.CancelUpdate;
      end;
    finally
      FIsPackageLoading := False;
    end;
  end;
  Result := PackageHandle <> INVALID_HANDLE_VALUE;
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxSkinsPackageManager.Initialize;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxSkinsPackageManager.Finalize;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
