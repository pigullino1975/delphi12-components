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

unit dxPSdxChartControlLnk;

interface

{$I cxVer.inc}

uses
  Types, Classes, Graphics, Controls, StdCtrls, SysUtils,
  dxPSCore, dxPSGraphicLnk, dxChartControl;

type
  TdxCustomChartControlReportLink = class(TCustomdxPictureReportLink)
  private
    FPicture: TPicture;
    function GetdxCustomChartControl: TdxCustomChartControl;
  protected
    procedure DoDestroyReport; override;
    procedure FreePicture;
    function GetPicture: TPicture; override;
    procedure InternalRestoreDefaults; override;
    procedure Unprepare; override;

    property dxCustomChartControl: TdxCustomChartControl read GetdxCustomChartControl;
  public
    constructor Create(AOwner: TComponent); override;

    function DataProviderPresent: Boolean; override;
  end;

  TdxChartControlReportLink = class(TdxCustomChartControlReportLink)
  private
    function GetdxChartControl: TdxChartControl;
  public
    property dxChartControl: TdxChartControl read GetdxChartControl;
  end;

implementation

uses
  dxPSReportRenderCanvas;

const
  dxThisUnitName = 'dxPSdxChartControlLnk';

{ TdxCustomChartControlReportLink }

constructor TdxCustomChartControlReportLink.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  InternalRestoreDefaults;
  LinkModified(False);
end;

function TdxCustomChartControlReportLink.DataProviderPresent: Boolean;
begin
  Result := (DataSource = rldsComponent) and not (csLoading in ComponentState) and
    (dxCustomChartControl <> nil);
end;

procedure TdxCustomChartControlReportLink.DoDestroyReport;
begin
  FreePicture;
  inherited DoDestroyReport;
end;

procedure TdxCustomChartControlReportLink.FreePicture;
begin
  if FPicture <> nil then
    FreeAndNil(FPicture);
end;

function TdxCustomChartControlReportLink.GetdxCustomChartControl: TdxCustomChartControl;
begin
  Result := inherited Component as TdxCustomChartControl;
end;

function TdxCustomChartControlReportLink.GetPicture: TPicture;
var
  AImage: TdxSVGReportImage;
  AStream: TMemoryStream;
begin
  if FPicture = nil then
  begin
    FPicture := TPicture.Create;
    AStream := TMemoryStream.Create;
    try
      dxCustomChartControl.ExportToSVG(AStream);
      AStream.Position := 0;
      AImage := TdxSVGReportImage.CreateFromStream(AStream);
      try
        Picture.Assign(AImage);
      finally
        AImage.Free;
      end;
    finally
      AStream.Free;
    end;
  end;
  Result := FPicture;
end;

procedure TdxCustomChartControlReportLink.InternalRestoreDefaults;
begin
  inherited InternalRestoreDefaults;
  Proportional := True;
end;

procedure TdxCustomChartControlReportLink.Unprepare;
begin
  FreePicture;
  inherited Unprepare;
end;

{ TdxChartControlReportLink }

function TdxChartControlReportLink.GetdxChartControl: TdxChartControl;
begin
  Result := inherited Component as TdxChartControl;
end;

initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxPSRegisterReportLink(TdxChartControlReportLink, TdxChartControl, nil);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxPSUnregisterReportLink(TdxChartControlReportLink, TdxChartControl, nil);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.

