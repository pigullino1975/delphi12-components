{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressCharts                                            }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSCHARTS AND ALL ACCOMPANYING    }
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

unit dxChartXYDiagramScrollBar;

{$I cxVer.inc}

interface

uses
  Controls, Forms, Types,
  cxLookAndFeelPainters, cxControls, cxScrollBar, cxGraphics, cxCustomCanvas;

type
  TdxChartXYDiagramScrollBarViewInfo = class(TcxScrollBarViewInfo)
  protected
    function GetArrowButtonLength: Integer; override;
  end;

  TdxChartXYDiagramScrollBarPainter = class(TcxScrollBarPainter)
  protected
    procedure DoDrawScrollBarPart(ACanvas: TcxCustomCanvas; const R: TRect; APart: TcxScrollBarPart; AState: TcxButtonState); override;
    procedure DrawScrollBarBackground(ACanvas: TcxCustomCanvas; const R: TRect); override;
  end;

  TdxChartXYDiagramScrollBarHelper = class(TcxControlScrollBarHelper)
  protected
    function GetPainterClass: TcxScrollBarPainterClass; override;
    function GetViewInfoClass: TcxScrollBarViewInfoClass; override;
  end;

  TdxChartXYDiagramScrollBars = class(TcxControlScrollBars)
  protected
    function CheckSize(AKind: TScrollBarKind): Boolean; override;
    procedure CreateScrollBars; override;
    function GetScrollBarClass(AKind: TScrollBarKind): TcxControlScrollBarHelperClass; override;
  end;

  TdxChartControlScrollBar = class(TcxControlScrollBar)

  end;

implementation

const
  dxThisUnitName = 'dxChartXYDiagramScrollBar';

{ TdxChartXYDiagramScrollBarHelper }

function TdxChartXYDiagramScrollBarHelper.GetPainterClass: TcxScrollBarPainterClass;
begin
  Result := TdxChartXYDiagramScrollBarPainter;
end;

function TdxChartXYDiagramScrollBarHelper.GetViewInfoClass: TcxScrollBarViewInfoClass;
begin
  Result := TdxChartXYDiagramScrollBarViewInfo;
end;

{ TdxChartXYDiagramScrollBars }

function TdxChartXYDiagramScrollBars.CheckSize(AKind: TScrollBarKind): Boolean;
begin
  Result := False;
end;

procedure TdxChartXYDiagramScrollBars.CreateScrollBars;
begin
  inherited CreateScrollBars;
  HScrollBar.Height := ScaleFactor.Apply(6);
  VScrollBar.Width := ScaleFactor.Apply(6);
end;

function TdxChartXYDiagramScrollBars.GetScrollBarClass(AKind: TScrollBarKind): TcxControlScrollBarHelperClass;
begin
  Result := TdxChartXYDiagramScrollBarHelper;
end;

{ TdxChartXYDiagramScrollBarViewInfo }

function TdxChartXYDiagramScrollBarViewInfo.GetArrowButtonLength: Integer;
begin
  Result := 0;
end;

{ TdxChartXYDiagramScrollBarPainter }

procedure TdxChartXYDiagramScrollBarPainter.DoDrawScrollBarPart(ACanvas: TcxCustomCanvas; const R: TRect; APart: TcxScrollBarPart; AState: TcxButtonState);
begin
  if APart = sbpThumbnail then
    if AState = cxbsNormal then
      ACanvas.FillRect(R, $BDBDBD)
    else
      ACanvas.FillRect(R, $1E94F7);
end;

procedure TdxChartXYDiagramScrollBarPainter.DrawScrollBarBackground(ACanvas: TcxCustomCanvas; const R: TRect);
begin
  ACanvas.FillRect(R, $E5E5E5);
end;

end.
