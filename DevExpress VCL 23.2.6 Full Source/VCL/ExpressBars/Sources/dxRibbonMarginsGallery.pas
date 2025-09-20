{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressBars components                                   }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSBARS AND ALL ACCOMPANYING VCL  }
{   CONTROLS AS PART OF AN EXECUTABLE PROGRAM ONLY.                  }
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

unit dxRibbonMarginsGallery;

{$I cxVer.inc}

interface

uses Windows, SysUtils, Classes, Graphics, Math, Generics.Defaults, Generics.Collections, Types, ActnList,
  cxGeometry, cxGraphics, dxCoreGraphics, cxControls, dxBar, dxRibbonGallery, dxActions, dxUIGenerator;

type
  TdxRibbonMarginsGalleryControl = class(TdxRibbonGalleryControl)
    function GetViewInfoClass: TdxBarItemControlViewInfoClass; override;
  end;

  TdxRibbonMarginsGalleryItem = class(TdxRibbonGalleryItem)
  protected
    function GetGalleryGroupsClass: TdxRibbonGalleryGroupsClass; override;
  end;

  TdxRibbonMarginsGalleryGroups = class(TdxRibbonGalleryGroups)
  protected
    function GetGroupViewInfoClass: TdxRibbonGalleryGroupViewInfoClass; override;
  end;

  TdxRibbonMarginsGalleryGroupViewInfo = class(TdxRibbonGalleryGroupViewInfo)
  protected
    function GetItemViewInfoClass: TdxRibbonGalleryGroupItemViewInfoClass; override;
  end;

  TColumnsWidths = TArray<Integer>;

  TdxRibbonMarginsGalleryGroupItemViewInfo = class(TdxRibbonGalleryGroupItemViewInfo)
  private
    type
      TDescriptionCells = array of TArray<string>;
    function GetDescriptionCells: TDescriptionCells;
  protected
    function GetDescriptionRectInner(ACanvas: TCanvas): TRect; override;
    procedure DrawDescriptionText(ACanvas: TcxCanvas; ADescriptionRect: TRect; ATextAlignmentFlags: DWORD); override;
  end;

  TdxRibbonMarginsOnMenuGalleryControlViewInfo = class(TdxRibbonOnMenuGalleryControlViewInfo)
  strict private
    type
      TItemElement = TPair<Integer, Integer>;
      TColumnsWidthDictionary = TDictionary<TItemElement, TColumnsWidths>;
    var
      FColumnsWidthCache: TColumnsWidthDictionary;
  protected
    procedure SetCachedMarginsColumnsWidth(AGroupIndex, AnItemIndex: Integer; AColumnsWidths :TColumnsWidths);
    function GetCachedMarginsColumnsWidth(AGroupIndex, AnItemIndex: Integer): TColumnsWidths;
  public
    constructor Create(AControl: TdxBarItemControl); override;
    destructor Destroy; override;
  end;

implementation

uses
  dxTypeHelpers, dxStringHelper, dxCore;

const
  dxThisUnitName = 'dxRibbonMarginsGallery';

{ TdxRibbonMarginsGalleryItem }

function TdxRibbonMarginsGalleryItem.GetGalleryGroupsClass: TdxRibbonGalleryGroupsClass;
begin
  Result := TdxRibbonMarginsGalleryGroups;
end;

{ TdxRibbonMarginsGalleryGroups }

function TdxRibbonMarginsGalleryGroups.GetGroupViewInfoClass: TdxRibbonGalleryGroupViewInfoClass;
begin
  Result := TdxRibbonMarginsGalleryGroupViewInfo;
end;

{ TdxRibbonMarginsGalleryGroupViewInfo }

function TdxRibbonMarginsGalleryGroupViewInfo.GetItemViewInfoClass: TdxRibbonGalleryGroupItemViewInfoClass;
begin
  Result := TdxRibbonMarginsGalleryGroupItemViewInfo;
end;

{ TdxRibbonMarginsGalleryGroupItemViewInfo }

procedure TdxRibbonMarginsGalleryGroupItemViewInfo.DrawDescriptionText(ACanvas: TcxCanvas; ADescriptionRect: TRect; ATextAlignmentFlags: DWORD);
var
  ARect, WordRect: TRect;
  ALineHeight, I, ICol, ILeftBorder: Integer;
  ACells: TDescriptionCells;
  AColumnsWidth: TColumnsWidths;
begin
  ALineHeight := TdxTextMeasurer.TextLineHeight(ACanvas.Handle);
  ATextAlignmentFlags := ATextAlignmentFlags and not DT_EXPANDTABS;
  ACells := GetDescriptionCells;
  AColumnsWidth := TdxRibbonMarginsOnMenuGalleryControlViewInfo(Owner.Owner).
    GetCachedMarginsColumnsWidth(GroupItem.Group.Index, GroupItem.Index);
  ARect := ADescriptionRect;
  for I := Low(ACells) to High(ACells) do
  begin
    ILeftBorder := ARect.Left;
    for iCol := Low(ACells[I]) to High(ACells[I]) do
      begin
        WordRect := ARect;
        WordRect.Left := ILeftBorder;
        WordRect.Width := AColumnsWidth[iCol];

        if Owner.Owner.Control.UseRightToLeftAlignment then
        begin
          WordRect := TdxRightToLeftLayoutConverter.ConvertRect(WordRect, ARect);
          if TdxStringHelper.EndsWith(':', ACells[I, iCol]) then
            ACells[I, iCol] := ':' + Copy(ACells[I, iCol], 1, Length(ACells[I, iCol]) - 1);
          DrawInnerText(ACanvas, ACells[I, iCol], WordRect, ATextAlignmentFlags);
        end
        else
          DrawInnerText(ACanvas, ACells[I, iCol] + ' ', WordRect, ATextAlignmentFlags);
        ILeftBorder := ILeftBorder + AColumnsWidth[iCol];
      end;
    OffsetRect(ARect, 0, ALineHeight);
  end;
end;

function TdxRibbonMarginsGalleryGroupItemViewInfo.GetDescriptionCells: TDescriptionCells;
var
  ARows, ARowData: TArray<string>;
  I: Integer;
begin
  ARows := TdxStringHelper.Split(Description, [#13#10, #13, #10]);
  SetLength(Result, Length(ARows));
  for I := Low(ARows) to High(ARows) do
  begin
    ARowData := TdxStringHelper.Split(ARows[I], [#9]);
    Result[I] := ARowData;
  end;
end;

function TdxRibbonMarginsGalleryGroupItemViewInfo.GetDescriptionRectInner(ACanvas: TCanvas): TRect;
const
  TabsEquivalent = '        '; 
var
  ACells: TDescriptionCells;
  AColumnsWidth: TColumnsWidths;
  iRow, iCol,
  ARowLen, AColumnWidth,
  StrOriginalWidth, TabsWidth, SpaceWidth: Integer;
begin
  ACells := GetDescriptionCells;
  Result := cxGetTextRect(ACanvas.Handle, Description, Length(ACells), False);
  TabsWidth := cxGetTextRect(ACanvas.Handle, TabsEquivalent, 1).Width;
  SpaceWidth := cxGetTextRect(ACanvas.Handle, ' ', 1).Width;
  SetLength(AColumnsWidth, Length(ACells));
  for iRow := Low(ACells) to High(ACells) do
  begin
    if Length(ACells[iRow]) > Length(AColumnsWidth) then
      SetLength(AColumnsWidth, Length(ACells[iRow]));
    for iCol := Low(ACells[iRow]) to High(ACells[iRow]) do
      begin
        StrOriginalWidth := cxGetTextRect(ACanvas.Handle, ACells[iRow][iCol], 1).Width;
        AColumnWidth := StrOriginalWidth;
        if iCol <> High(ACells[iRow]) then 
        begin
          if (AColumnWidth mod TabsWidth) <> 0 then
          begin
            AColumnWidth := ((AColumnWidth div TabsWidth) + 1) * TabsWidth;
          end;
          if (AColumnWidth - StrOriginalWidth) < (2 * SpaceWidth) then
            AColumnWidth := AColumnWidth + TabsWidth;
        end;
        AColumnsWidth[iCol] := Max(AColumnWidth, AColumnsWidth[iCol]);
      end;
  end;
  ARowLen := 0;
  for iCol := Low(AColumnsWidth) to High(AColumnsWidth) do
    ARowLen := ARowLen + AColumnsWidth[iCol];
  if Result.Width < ARowLen then
    Result.Width := ARowLen;

  TdxRibbonMarginsOnMenuGalleryControlViewInfo(Owner.Owner).SetCachedMarginsColumnsWidth(
      GroupItem.Group.Index, GroupItem.Index, AColumnsWidth);
end;

{ TdxRibbonOnMenuGalleryControlViewInfo }

constructor TdxRibbonMarginsOnMenuGalleryControlViewInfo.Create(AControl: TdxBarItemControl);
begin
  inherited;
  FColumnsWidthCache := TColumnsWidthDictionary.Create;
end;

destructor TdxRibbonMarginsOnMenuGalleryControlViewInfo.Destroy;
begin
  FreeAndNil(FColumnsWidthCache);
  inherited;
end;

function TdxRibbonMarginsOnMenuGalleryControlViewInfo.GetCachedMarginsColumnsWidth(AGroupIndex,
  AnItemIndex: Integer): TColumnsWidths;
begin
  if not FColumnsWidthCache.TryGetValue(TItemElement.Create(AGroupIndex, AnItemIndex), Result) then
    SetLength(Result, 0);
end;

procedure TdxRibbonMarginsOnMenuGalleryControlViewInfo.SetCachedMarginsColumnsWidth(AGroupIndex, AnItemIndex: Integer;
  AColumnsWidths: TColumnsWidths);
begin
  FColumnsWidthCache.AddOrSetValue(TItemElement.Create(AGroupIndex, AnItemIndex), AColumnsWidths);
end;

{ TdxRibbonMarginsGalleryControl }

function TdxRibbonMarginsGalleryControl.GetViewInfoClass: TdxBarItemControlViewInfoClass;
begin
  if (Parent.Kind = bkSubMenu) then
    Result := TdxRibbonMarginsOnMenuGalleryControlViewInfo
  else
    Result := inherited;
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxBarRegisterItem(TdxRibbonMarginsGalleryItem, TdxRibbonMarginsGalleryControl, True);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxBarUnregisterItem(TdxRibbonMarginsGalleryItem);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
