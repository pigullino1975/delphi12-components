{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressPDFViewer                                         }
{                                                                    }
{           Copyright (c) 2015-2024 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSPDFVIEWER AND ALL              }
{   ACCOMPANYING VCL CONTROLS AS PART OF AN EXECUTABLE PROGRAM       }
{   ONLY.                                                            }
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

unit dxPDFDestination;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Types, SysUtils, Classes, cxGeometry, dxPDFBase, dxPDFTypes, dxPDFCore;

type
  { TdxPDFFitDestination }

  TdxPDFFitDestination = class(TdxPDFCustomDestination)
  protected
    function GetTarget: TdxPDFTarget; override;
    procedure ReadParameters(AArray: TdxPDFArray); override;
  public
    class function GetTypeName: string; override;
  end;

  { TdxPDFFitRectangleDestination }

  TdxPDFFitRectangleDestination = class(TdxPDFCustomDestination)
  strict private
    FRectangle: TdxRectF;
  protected
    function GetTarget: TdxPDFTarget; override;
    procedure ReadParameters(AArray: TdxPDFArray); override;
    procedure WriteParameters(AHelper: TdxPDFWriterHelper; AArray: TdxPDFWriterArray); override;
    //
    property Rectangle: TdxRectF read FRectangle;
  public
    class function GetTypeName: string; override;
  end;

  { TdxPDFFitHorizontallyDestination }

  TdxPDFFitHorizontallyDestination = class(TdxPDFCustomDestination)
  strict private
    FTop: Single;
  protected
    function GetTarget: TdxPDFTarget; override;
    procedure ReadParameters(AArray: TdxPDFArray); override;
    procedure WriteParameters(AHelper: TdxPDFWriterHelper; AArray: TdxPDFWriterArray); override;
    //
    property Top: Single read FTop;
  public
    class function GetTypeName: string; override;
  end;

  { TdxPDFFitVerticallyDestination }

  TdxPDFFitVerticallyDestination = class(TdxPDFCustomDestination)
  strict private
    FLeft: Single;
  protected
    function GetTarget: TdxPDFTarget; override;
    procedure ReadParameters(AArray: TdxPDFArray); override;
    procedure WriteParameters(AHelper: TdxPDFWriterHelper; AArray: TdxPDFWriterArray); override;
    //
    property Left: Single read FLeft;
  public
    class function GetTypeName: string; override;
  end;

  { TdxPDFXYZDestination }

  TdxPDFXYZDestination = class(TdxPDFCustomDestination)
  strict private
    FLeft: Single;
    FTop: Single;
    FZoom: Single;
  protected
    function GetTarget: TdxPDFTarget; override;
    procedure ReadParameters(AArray: TdxPDFArray); override;
    procedure WriteParameters(AHelper: TdxPDFWriterHelper; AArray: TdxPDFWriterArray); override;
    //
    property Left: Single read FLeft;
    property Top: Single read FTop;
    property Zoom: Single read FZoom;
  public
    class function GetTypeName: string; override;
  end;

  { TdxPDFFitBBoxDestination }

  TdxPDFFitBBoxDestination = class(TdxPDFCustomDestination)
  protected
    function GetTarget: TdxPDFTarget; override;
    procedure ReadParameters(AArray: TdxPDFArray); override;
  public
    class function GetTypeName: string; override;
  end;

  { TdxPDFFitBBoxHorizontallyDestination }

  TdxPDFFitBBoxHorizontallyDestination = class(TdxPDFCustomDestination)
  strict private
    FTop: Single;
  protected
    function GetTarget: TdxPDFTarget; override;
    procedure ReadParameters(AArray: TdxPDFArray); override;
    procedure WriteParameters(AHelper: TdxPDFWriterHelper; AArray: TdxPDFWriterArray); override;
    //
    property Top: Single read FTop;
  public
    class function GetTypeName: string; override;
  end;

  { TdxPDFFitBBoxVerticallyDestination }

  TdxPDFFitBBoxVerticallyDestination = class(TdxPDFCustomDestination)
  strict private
    FLeft: Single;
  protected
    function GetTarget: TdxPDFTarget; override;
    procedure ReadParameters(AArray: TdxPDFArray); override;
    procedure WriteParameters(AHelper: TdxPDFWriterHelper; AArray: TdxPDFWriterArray); override;
    //
    property Left: Single read FLeft;
  public
    class function GetTypeName: string; override;
  end;

implementation

uses
  Math, dxPDFUtils, dxCore;

const
  dxThisUnitName = 'dxPDFDestination';

{ TdxPDFFitDestination }

class function TdxPDFFitDestination.GetTypeName: string;
begin
  Result := 'Fit';
end;

function TdxPDFFitDestination.GetTarget: TdxPDFTarget;
begin
  Result := TdxPDFTarget.Create(tmFit, CalculatePageIndex(Pages));
end;

procedure TdxPDFFitDestination.ReadParameters(AArray: TdxPDFArray);
begin
  if AArray.Count >= 2 then
    inherited ReadParameters(AArray);
end;

{ TdxPDFFitRectangleDestination }


class function TdxPDFFitRectangleDestination.GetTypeName: string;
begin
  Result := 'FitR';
end;

function TdxPDFFitRectangleDestination.GetTarget: TdxPDFTarget;
begin
  Result := TdxPDFTarget.Create(tmFitRectangle, CalculatePageIndex(Pages), FRectangle);
end;

procedure TdxPDFFitRectangleDestination.ReadParameters(AArray: TdxPDFArray);
var
  ATemp: Single;
begin
  inherited ReadParameters(AArray);
  if AArray.Count >= 6 then
  begin
    FRectangle.Left := TdxPDFUtils.ConvertToDouble(AArray[2]);
    FRectangle.Bottom := TdxPDFUtils.ConvertToDouble(AArray[3]);
    FRectangle.Right := TdxPDFUtils.ConvertToDouble(AArray[4]);
    FRectangle.Top := TdxPDFUtils.ConvertToDouble(AArray[5]);
    if FRectangle.Right < FRectangle.Left then
    begin
      ATemp := FRectangle.Right;
      FRectangle.Right := FRectangle.Left;
      FRectangle.Left := ATemp;
    end;
    if FRectangle.Top < FRectangle.Bottom then
    begin
      ATemp := FRectangle.Bottom;
      FRectangle.Bottom := FRectangle.Top;
      FRectangle.Top := ATemp;
    end;
  end;
end;

procedure TdxPDFFitRectangleDestination.WriteParameters(AHelper: TdxPDFWriterHelper; AArray: TdxPDFWriterArray);
begin
  inherited WriteParameters(AHelper, AArray);
  AArray.Add(FRectangle.Left);
  AArray.Add(FRectangle.Bottom);
  AArray.Add(FRectangle.Right);
  AArray.Add(FRectangle.Top);
end;

{ TdxPDFFitHorizontallyDestination }

class function TdxPDFFitHorizontallyDestination.GetTypeName: string;
begin
  Result := 'FitH';
end;

function TdxPDFFitHorizontallyDestination.GetTarget: TdxPDFTarget;
begin
  Result := TdxPDFTarget.Create(tmFitHorizontally, CalculatePageIndex(Pages), dxPDFInvalidValue, ValidateVerticalCoordinate(FTop));
end;

procedure TdxPDFFitHorizontallyDestination.ReadParameters(AArray: TdxPDFArray);
begin
  inherited ReadParameters(AArray);
  FTop := GetSingleValue(AArray);
end;

procedure TdxPDFFitHorizontallyDestination.WriteParameters(AHelper: TdxPDFWriterHelper; AArray: TdxPDFWriterArray);
begin
  inherited WriteParameters(AHelper, AArray);
  WriteSingleValue(AArray, FTop);
end;

{ TdxPDFFitVerticallyDestination }

class function TdxPDFFitVerticallyDestination.GetTypeName: string;
begin
  Result := 'FitV';
end;

function TdxPDFFitVerticallyDestination.GetTarget: TdxPDFTarget;
begin
  Result := TdxPDFTarget.Create(tmFitVertically, CalculatePageIndex(Pages), FLeft, dxPDFInvalidValue);
end;

procedure TdxPDFFitVerticallyDestination.ReadParameters(AArray: TdxPDFArray);
begin
  inherited ReadParameters(AArray);
  FLeft := GetSingleValue(AArray);
end;

procedure TdxPDFFitVerticallyDestination.WriteParameters(AHelper: TdxPDFWriterHelper; AArray: TdxPDFWriterArray);
begin
  inherited WriteParameters(AHelper, AArray);
  WriteSingleValue(AArray, FLeft);
end;

{ TdxPDFXYZDestination }

class function TdxPDFXYZDestination.GetTypeName: string;
begin
  Result := TdxPDFKeywords.XYZDestination;
end;

function TdxPDFXYZDestination.GetTarget: TdxPDFTarget;
var
  AActualZoom: Single;
  AValue: Single;
begin
  AActualZoom := dxPDFInvalidValue;
  if TdxPDFUtils.IsDoubleValid(Zoom) then
  begin
    AValue := Zoom;
    if not SameValue(AValue, 0) then
      AActualZoom := AValue;
  end;
  Result := TdxPDFTarget.Create(CalculatePageIndex(Pages), Left, ValidateVerticalCoordinate(Top), AActualZoom);
end;

procedure TdxPDFXYZDestination.ReadParameters(AArray: TdxPDFArray);
begin
  inherited ReadParameters(AArray);

  FTop := dxPDFInvalidValue;
  FLeft := dxPDFInvalidValue;

  if AArray.Count > 2 then
    FTop := TdxPDFUtils.ConvertToSingle(AArray[2]);

  if AArray.Count > 3 then
  begin
    FLeft := TdxPDFUtils.ConvertToSingle(AArray[2]);
    FTop := TdxPDFUtils.ConvertToSingle(AArray[3]);
  end;

  if AArray.Count > 4 then
    FZoom := TdxPDFUtils.ConvertToSingle(AArray[4])
  else
    FZoom := dxPDFInvalidValue;
end;

procedure TdxPDFXYZDestination.WriteParameters(AHelper: TdxPDFWriterHelper; AArray: TdxPDFWriterArray);

  procedure AddValue(const AValue: Single);
  begin
    if SameValue(AValue, dxPDFInvalidValue) then
      AArray.AddNull
    else
      AArray.Add(AValue);
  end;

begin
  inherited WriteParameters(AHelper, AArray);
  AddValue(FLeft);
  AddValue(FTop);
  AddValue(FZoom);
end;

{ TdxPDFFitBBoxDestination }

class function TdxPDFFitBBoxDestination.GetTypeName: string;
begin
  Result := 'FitB';
end;

function TdxPDFFitBBoxDestination.GetTarget: TdxPDFTarget;
begin
  Result := TdxPDFTarget.Create(tmFitBBox, CalculatePageIndex(Pages));
end;

procedure TdxPDFFitBBoxDestination.ReadParameters(AArray: TdxPDFArray);
begin
  if AArray.Count >= 2 then
    inherited ReadParameters(AArray);
end;

{ TdxPDFFitBBoxHorizontallyDestination }

class function TdxPDFFitBBoxHorizontallyDestination.GetTypeName: string;
begin
  Result := 'FitBH';
end;

function TdxPDFFitBBoxHorizontallyDestination.GetTarget: TdxPDFTarget;
begin
  Result := TdxPDFTarget.Create(tmFitBBoxHorizontally, CalculatePageIndex(Pages),
    dxPDFInvalidValue, ValidateVerticalCoordinate(FTop));
end;

procedure TdxPDFFitBBoxHorizontallyDestination.ReadParameters(AArray: TdxPDFArray);
begin
  inherited ReadParameters(AArray);
  FTop := GetSingleValue(AArray);
end;

procedure TdxPDFFitBBoxHorizontallyDestination.WriteParameters(AHelper: TdxPDFWriterHelper; AArray: TdxPDFWriterArray);
begin
  inherited WriteParameters(AHelper, AArray);
  WriteSingleValue(AArray, FTop);
end;

{ TdxPDFFitBBoxVerticallyDestination }

class function TdxPDFFitBBoxVerticallyDestination.GetTypeName: string;
begin
  Result := 'FitBV';
end;

function TdxPDFFitBBoxVerticallyDestination.GetTarget: TdxPDFTarget;
begin
  Result := TdxPDFTarget.Create(tmFitBBoxVertically, CalculatePageIndex(Pages), FLeft, dxPDFInvalidValue);
end;

procedure TdxPDFFitBBoxVerticallyDestination.ReadParameters(AArray: TdxPDFArray);
begin
  inherited ReadParameters(AArray);
  FLeft := GetSingleValue(AArray);
end;

procedure TdxPDFFitBBoxVerticallyDestination.WriteParameters(AHelper: TdxPDFWriterHelper; AArray: TdxPDFWriterArray);
begin
  inherited WriteParameters(AHelper, AArray);
  WriteSingleValue(AArray, FLeft);
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxPDFRegisterDocumentObjectClass(TdxPDFFitDestination);
  dxPDFRegisterDocumentObjectClass(TdxPDFFitRectangleDestination);
  dxPDFRegisterDocumentObjectClass(TdxPDFFitHorizontallyDestination);
  dxPDFRegisterDocumentObjectClass(TdxPDFFitVerticallyDestination);
  dxPDFRegisterDocumentObjectClass(TdxPDFXYZDestination);
  dxPDFRegisterDocumentObjectClass(TdxPDFFitBBoxDestination);
  dxPDFRegisterDocumentObjectClass(TdxPDFFitBBoxHorizontallyDestination);
  dxPDFRegisterDocumentObjectClass(TdxPDFFitBBoxVerticallyDestination);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxPDFUnregisterDocumentObjectClass(TdxPDFFitBBoxVerticallyDestination);
  dxPDFUnregisterDocumentObjectClass(TdxPDFFitBBoxHorizontallyDestination);
  dxPDFUnregisterDocumentObjectClass(TdxPDFFitBBoxDestination);
  dxPDFUnregisterDocumentObjectClass(TdxPDFXYZDestination);
  dxPDFUnregisterDocumentObjectClass(TdxPDFFitVerticallyDestination);
  dxPDFUnregisterDocumentObjectClass(TdxPDFFitHorizontallyDestination);
  dxPDFUnregisterDocumentObjectClass(TdxPDFFitRectangleDestination);
  dxPDFUnregisterDocumentObjectClass(TdxPDFFitDestination);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
