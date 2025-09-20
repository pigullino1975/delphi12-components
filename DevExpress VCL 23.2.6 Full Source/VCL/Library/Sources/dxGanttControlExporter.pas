{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressGanttControl                                      }
{                                                                    }
{           Copyright (c) 2020-2024 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSGANTTCONTROL AND ALL           }
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

unit dxGanttControlExporter;

{$I cxVer.inc}
{$I dxGanttControl.inc}

interface

uses
  System.UITypes, System.Contnrs,
  SysUtils, Generics.Defaults, Generics.Collections, Classes,
  dxCore, dxCoreClasses,
  dxGanttControlCustomClasses,
  dxGanttControlCustomDataModel;

type
  { TdxGanttControlExporter }

  TdxGanttControlExporter = class abstract
  protected
    class function GetExtensions: TArray<string>; virtual;
    class function IsValidExtension(const AExt: string): Boolean;

    class procedure Register;
    class procedure Unregister;

    class function IsUpdateStoringInformationSupported: Boolean; virtual;
  public
    procedure Export(const AStream: TStream; AControl: TdxGanttControlBase); overload; virtual;
    procedure Export(const AStream: TStream; ADataModel: TdxGanttControlCustomDataModel); overload; virtual;
  end;
  TdxGanttControlExporterClass = class of TdxGanttControlExporter;

  { TdxGanttControlExporters }

  TdxGanttControlExporters = class // for internal use
  strict private
    class var FClasses: TList<TdxGanttControlExporterClass>;
  private
    class procedure Initialize; static;
    class procedure Finalize; static;
  protected
    class procedure ThrowUnsupportedFormatException; static;
    class procedure UpdateStoringInformation(const AFileName: string; AExporterClass: TdxGanttControlExporterClass;
      ADataModel: TdxGanttControlCustomDataModel); static;

    class procedure RegisterClass(AClass: TdxGanttControlExporterClass); static;
    class procedure UnregisterClass(AClass: TdxGanttControlExporterClass); static;
  public
    class function GetExporter(const AFileName: string): TdxGanttControlExporterClass; static;

    class procedure Export(const AFileName: string; AControl: TdxGanttControlBase); overload; static;
    class procedure Export(const AFileName: string; ADataModel: TdxGanttControlCustomDataModel); overload; static;
    class procedure Export(const AStream: TStream; AExporterClass: TdxGanttControlExporterClass; AControl: TdxGanttControlBase); overload; static;
    class procedure Export(const AStream: TStream; AExporterClass: TdxGanttControlExporterClass; ADataModel: TdxGanttControlCustomDataModel); overload; static;
  end;

implementation

uses
  IOUtils,
  dxGanttControl,
  dxGanttControlDataModel,
  dxGanttControlUtils,
  dxGanttControlXMLExporter;

const
  dxThisUnitName = 'dxGanttControlExporter';

{ TdxGanttControlExporter }

procedure TdxGanttControlExporter.Export(const AStream: TStream; AControl: TdxGanttControlBase);
begin
  TdxGanttControlExporters.ThrowUnsupportedFormatException;
end;

procedure TdxGanttControlExporter.Export(const AStream: TStream;
  ADataModel: TdxGanttControlCustomDataModel);
begin
  TdxGanttControlExporters.ThrowUnsupportedFormatException;
end;

class function TdxGanttControlExporter.GetExtensions: TArray<string>;
begin
  Result := nil;
end;

class function TdxGanttControlExporter.IsUpdateStoringInformationSupported: Boolean;
begin
  Result := False;
end;

class function TdxGanttControlExporter.IsValidExtension(const AExt: string): Boolean;
var
  I: Integer;
  AExtensions: TArray<string>;
begin
  AExtensions := GetExtensions;
  for I := Low(AExtensions) to High(AExtensions) do
    if LowerCase(AExtensions[I]) = LowerCase(AExt) then
      Exit(True);
  Result := False;
end;

class procedure TdxGanttControlExporter.Register;
begin
  TdxGanttControlExporters.RegisterClass(Self);
end;

class procedure TdxGanttControlExporter.Unregister;
begin
  TdxGanttControlExporters.UnregisterClass(Self);
end;

{ TdxGanttControlExporters }

class procedure TdxGanttControlExporters.Initialize;
begin
  FClasses := TList<TdxGanttControlExporterClass>.Create;
end;

class procedure TdxGanttControlExporters.Finalize;
begin
  FreeAndNil(FClasses);
end;

class function TdxGanttControlExporters.GetExporter(
  const AFileName: string): TdxGanttControlExporterClass;
var
  I: Integer;
  AExt: string;
begin
  AExt := LowerCase(TPath.GetExtension(AFileName));
  for I := 0 to FClasses.Count - 1 do
  begin
    if FClasses[I].IsValidExtension(AExt) then
      Exit(FClasses[I]);
  end;
  Result := nil;
end;

class procedure TdxGanttControlExporters.Export(const AFileName: string; AControl: TdxGanttControlBase);
var
  AExporterClass: TdxGanttControlExporterClass;
  AStream: TStream;
begin
  AExporterClass := TdxGanttControlExporters.GetExporter(AFileName);
  if AExporterClass = nil then
    ThrowUnsupportedFormatException;
  UpdateStoringInformation(AFileName, AExporterClass, (AControl as TdxCustomGanttControl).DataModel);
  AStream := TFileStream.Create(AFileName, fmCreate);
  try
    Export(AStream, AExporterClass, AControl);
  finally
    AStream.Free;
  end;
end;

class procedure TdxGanttControlExporters.Export(const AFileName: string; ADataModel: TdxGanttControlCustomDataModel);
var
  AExporterClass: TdxGanttControlExporterClass;
  AStream: TStream;
begin
  AExporterClass := TdxGanttControlExporters.GetExporter(AFileName);
  if AExporterClass = nil then
    ThrowUnsupportedFormatException;
  UpdateStoringInformation(AFileName, AExporterClass, ADataModel);
  AStream := TFileStream.Create(AFileName, fmCreate);
  try
    Export(AStream, AExporterClass, ADataModel);
  finally
    AStream.Free;
  end;
end;

class procedure TdxGanttControlExporters.Export(const AStream: TStream; AExporterClass: TdxGanttControlExporterClass; AControl: TdxGanttControlBase);
var
  AExporter: TdxGanttControlExporter;
begin
  AExporter := AExporterClass.Create;
  try
    AExporter.Export(AStream, AControl);
  finally
    AExporter.Free;
  end;
end;

class procedure TdxGanttControlExporters.Export(const AStream: TStream; AExporterClass: TdxGanttControlExporterClass; ADataModel: TdxGanttControlCustomDataModel);
var
  AExporter: TdxGanttControlExporter;
begin
  AExporter := AExporterClass.Create;
  try
    AExporter.Export(AStream, ADataModel);
  finally
    AExporter.Free;
  end;
end;

class procedure TdxGanttControlExporters.RegisterClass(AClass: TdxGanttControlExporterClass);
begin
  if FClasses = nil then
    Initialize;
  FClasses.Add(AClass);
end;

class procedure TdxGanttControlExporters.ThrowUnsupportedFormatException;
begin
  TdxGanttControlExceptions.ThrowUnsupportedFileFormatException;
end;

class procedure TdxGanttControlExporters.UnregisterClass(AClass: TdxGanttControlExporterClass);
begin
  if FClasses <> nil then
    FClasses.Remove(AClass);
end;

class procedure TdxGanttControlExporters.UpdateStoringInformation(
  const AFileName: string; AExporterClass: TdxGanttControlExporterClass; ADataModel: TdxGanttControlCustomDataModel);
begin
  if AExporterClass.IsUpdateStoringInformationSupported then
  begin
    (ADataModel as TdxGanttControlDataModel).Properties.Name := ExtractFileName(AFileName);
    (ADataModel as TdxGanttControlDataModel).Properties.LastSaved := Now;
  end;
end;


initialization
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxGanttControlExporters.Finalize;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
