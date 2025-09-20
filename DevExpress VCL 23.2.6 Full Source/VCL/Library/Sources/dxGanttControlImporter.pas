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

unit dxGanttControlImporter;

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
  { TdxGanttControlImporter }

  TdxGanttControlImporter = class abstract
  protected
    class function GetDisplayName: string; virtual;
    class function GetExtensions: TArray<string>; virtual;
    class function IsValidExtension(const AExt: string): Boolean;

    class procedure Register;
    class procedure Unregister;
    class procedure ThrowInvalidFormatException; static;
    class procedure ThrowUnsupportedFormatException; static;
  public
    procedure Import(const AStream: TStream; AControl: TdxGanttControlBase); overload; virtual;
    procedure Import(const AStream: TStream; ADataModel: TdxGanttControlCustomDataModel); overload; virtual;
  end;
  TdxGanttControlImporterClass = class of TdxGanttControlImporter;

  { TdxGanttControlImporters }

  TdxGanttControlImporters = class // for internal use
  strict private
    class var FClasses: TList<TdxGanttControlImporterClass>;
  private
    class procedure Initialize; static;
    class procedure Finalize; static;
  protected
    class procedure ThrowUnsupportedFormatException; static;

    class procedure RegisterClass(AClass: TdxGanttControlImporterClass); static;
    class procedure UnregisterClass(AClass: TdxGanttControlImporterClass); static;
  public
    class function GetImporter(const AFileName: string): TdxGanttControlImporterClass; static;

    class procedure Import(const AFileName: string; AControl: TdxGanttControlBase); overload; static;
    class procedure Import(const AFileName: string; ADataModel: TdxGanttControlCustomDataModel); overload; static;
    class procedure Import(const AStream: TStream; AImporterClass: TdxGanttControlImporterClass; AControl: TdxGanttControlBase); overload; static;
    class procedure Import(const AStream: TStream; AImporterClass: TdxGanttControlImporterClass; ADataModel: TdxGanttControlCustomDataModel); overload; static;
  end;

implementation

uses
  IOUtils,
  dxGanttControlUtils,
  dxGanttControlXMLImporter;

const
  dxThisUnitName = 'dxGanttControlImporter';

{ TdxGanttControlImporter }

procedure TdxGanttControlImporter.Import(const AStream: TStream; AControl: TdxGanttControlBase);
begin
  TdxGanttControlImporters.ThrowUnsupportedFormatException;
end;

procedure TdxGanttControlImporter.Import(const AStream: TStream; ADataModel: TdxGanttControlCustomDataModel);
begin
  TdxGanttControlImporters.ThrowUnsupportedFormatException;
end;

class function TdxGanttControlImporter.GetDisplayName: string;
begin
  Result := '';
end;

class function TdxGanttControlImporter.GetExtensions: TArray<string>;
begin
  Result := nil;
end;

class function TdxGanttControlImporter.IsValidExtension(
  const AExt: string): Boolean;
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

class procedure TdxGanttControlImporter.Register;
begin
  TdxGanttControlImporters.RegisterClass(Self);
end;

class procedure TdxGanttControlImporter.ThrowInvalidFormatException;
begin
  TdxGanttControlExceptions.ThrowInvalidFileFormatException;
end;

class procedure TdxGanttControlImporter.ThrowUnsupportedFormatException;
begin
  TdxGanttControlImporters.ThrowUnsupportedFormatException;
end;

class procedure TdxGanttControlImporter.Unregister;
begin
  TdxGanttControlImporters.UnregisterClass(Self);
end;

{ TdxGanttControlImporters }

class procedure TdxGanttControlImporters.Import(const AFileName: string; AControl: TdxGanttControlBase);
var
  AImporterClass: TdxGanttControlImporterClass;
  AStream: TStream;
begin
  AImporterClass := TdxGanttControlImporters.GetImporter(AFileName);
  if AImporterClass = nil then
    ThrowUnsupportedFormatException;
  AStream := TFileStream.Create(AFileName, fmShareDenyWrite);
  try
    Import(AStream, AImporterClass, AControl);
  finally
    AStream.Free;
  end;
end;

class procedure TdxGanttControlImporters.Import(const AFileName: string; ADataModel: TdxGanttControlCustomDataModel);
var
  AImporterClass: TdxGanttControlImporterClass;
  AStream: TStream;
begin
  AImporterClass := TdxGanttControlImporters.GetImporter(AFileName);
  if AImporterClass = nil then
    ThrowUnsupportedFormatException;
  AStream := TFileStream.Create(AFileName, fmShareDenyWrite);
  try
    Import(AStream, AImporterClass, ADataModel);
  finally
    AStream.Free;
  end;
end;

class procedure TdxGanttControlImporters.Import(const AStream: TStream; AImporterClass: TdxGanttControlImporterClass; AControl: TdxGanttControlBase);
var
  AImporter: TdxGanttControlImporter;
begin
  AImporter := AImporterClass.Create;
  try
    AImporter.Import(AStream, AControl);
  finally
    AImporter.Free;
  end;
end;

class procedure TdxGanttControlImporters.Import(const AStream: TStream; AImporterClass: TdxGanttControlImporterClass; ADataModel: TdxGanttControlCustomDataModel);
var
  AImporter: TdxGanttControlImporter;
begin
  AImporter := AImporterClass.Create;
  try
    AImporter.Import(AStream, ADataModel);
  finally
    AImporter.Free;
  end;
end;

class function TdxGanttControlImporters.GetImporter(
  const AFileName: string): TdxGanttControlImporterClass;
var
  I: Integer;
  AExt: string;
begin
  AExt := LowerCase(TPath.GetExtension(AFileName));
  for I := 0 to FClasses.Count - 1 do
    if FClasses[I].IsValidExtension(AExt) then
      Exit(FClasses[I]);
  Result := nil;
end;

class procedure TdxGanttControlImporters.Initialize;
begin
  FClasses := TList<TdxGanttControlImporterClass>.Create;
end;

class procedure TdxGanttControlImporters.Finalize;
begin
  FreeAndNil(FClasses);
end;

class procedure TdxGanttControlImporters.RegisterClass(
  AClass: TdxGanttControlImporterClass);
begin
  if FClasses = nil then
    Initialize;
  FClasses.Add(AClass);
end;

class procedure TdxGanttControlImporters.ThrowUnsupportedFormatException;
begin
  TdxGanttControlExceptions.ThrowUnsupportedFileFormatException;
end;

class procedure TdxGanttControlImporters.UnregisterClass(
  AClass: TdxGanttControlImporterClass);
begin
  if FClasses <> nil then
    FClasses.Remove(AClass);
end;


initialization
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxGanttControlImporters.Finalize;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
