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

unit dxGanttControlImages;

{$I cxVer.inc}
{$I dxGanttControl.inc}

interface

uses
  Types, SysUtils,
  Generics.Defaults, Generics.Collections,
  dxSVGImage, dxGDIPlusClasses;

type
  { TdxGanttControlImages }

  TdxGanttControlImages = class
  strict private const
  {$REGION 'strict private const'}
    TaskAutoScheduleIndex = 0;
    TaskManualScheduleIndex = 1;
    TaskManualScheduleMoreInformationNeededIndex = 2;
    TaskCompletedIndex = 3;
    TaskConstraintByStartIndex = 4;
    TaskConstraintByFinishIndex = 5;
    InfoIndex = 6;
    MenuScrollToTaskIndex = 7;
    MenuTaskInformationIndex = 8;
    TaskRecurringIndex = 9;
    MenuInsertColumnIndex = 10;
    MenuHideColumnIndex = 11;
    MenuRenameColumnIndex = 12;
    MenuWordWrapIndex = 13;
  {$ENDREGION 'strict private const'}
  strict private
    class var FImages: TObjectDictionary<Integer, TdxSmartImage>;
    class constructor Initialize;
  {$HINTS OFF}
    class destructor Finalize;
  {$HINTS ON}

    class function CreateImage(Index: Integer): TdxSmartImage; static;
    class function GetImage(Index: Integer): TdxSmartImage; static;
  public
    class property Info: TdxSmartImage index InfoIndex read GetImage;
    class property MenuScrollToTask: TdxSmartImage index MenuScrollToTaskIndex read GetImage;
    class property MenuTaskInformation: TdxSmartImage index MenuTaskInformationIndex read GetImage;
    class property MenuInsertColumn: TdxSmartImage index MenuInsertColumnIndex read GetImage;
    class property MenuHideColumn: TdxSmartImage index MenuHideColumnIndex read GetImage;
    class property MenuRenameColumn: TdxSmartImage index MenuRenameColumnIndex read GetImage;
    class property MenuWordWrap: TdxSmartImage index MenuWordWrapIndex read GetImage;

    class property TaskAutoSchedule: TdxSmartImage index TaskAutoScheduleIndex read GetImage;
    class property TaskCompleted: TdxSmartImage index TaskCompletedIndex read GetImage;
    class property TaskRecurring: TdxSmartImage index TaskRecurringIndex read GetImage;
    class property TaskConstraintByFinish: TdxSmartImage index TaskConstraintByFinishIndex read GetImage;
    class property TaskConstraintByStart: TdxSmartImage index TaskConstraintByStartIndex read GetImage;
    class property TaskManualSchedule: TdxSmartImage index TaskManualScheduleIndex read GetImage;
    class property TaskManualScheduleMoreInformationNeeded: TdxSmartImage index TaskManualScheduleMoreInformationNeededIndex read GetImage;
  end;

implementation

uses
  dxGanttControlUtils, dxCore;

const
  dxThisUnitName = 'dxGanttControlImages';

{$R 'dxGanttControlImages.res'}

{ TdxGanttControlImages }

class constructor TdxGanttControlImages.Initialize;
begin
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.ConstructorStarted(UnitName, 'TdxGanttControlImages.Initialize', SysInit.HInstance);{$ENDIF}
  FImages := TObjectDictionary<Integer, TdxSmartImage>.Create([doOwnsValues]);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.ConstructorFinished(UnitName, 'TdxGanttControlImages.Initialize', SysInit.HInstance);{$ENDIF}
end;

class destructor TdxGanttControlImages.Finalize;
begin
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.DestructorStarted(UnitName, 'TdxGanttControlImages.Finalize', SysInit.HInstance);{$ENDIF}
  FreeAndNil(FImages);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.DestructorFinished(UnitName, 'TdxGanttControlImages.Finalize', SysInit.HInstance);{$ENDIF}
end;

class function TdxGanttControlImages.CreateImage(Index: Integer): TdxSmartImage;

  function GetName: string;
  begin
    case Index of
      TaskAutoScheduleIndex: Result := 'TASKAUTOSCHEDULE';
      TaskManualScheduleIndex: Result := 'TASKMANUALSCHEDULE';
      TaskManualScheduleMoreInformationNeededIndex: Result := 'TASKMANUALSCHEDULEMOREINFORMATIONNEEDED';
      TaskCompletedIndex: Result := 'TASKCOMPLETED';
      TaskConstraintByStartIndex: Result := 'TASKCONSTRAINTBYSTART';
      TaskConstraintByFinishIndex: Result := 'TASKCONSTRAINTBYFINISH';
      InfoIndex: Result := 'INFO';
      MenuScrollToTaskIndex: Result := 'MENUSCROLLTOTASK';
      MenuTaskInformationIndex: Result := 'MENUTASKINFORMATION';
      TaskRecurringIndex: Result := 'TASKRECURRING';
      MenuInsertColumnIndex: Result := 'MENUINSERTCOLUMN';
      MenuHideColumnIndex: Result := 'MENUHIDECOLUMN';
      MenuRenameColumnIndex: Result := 'MENURENAMECOLUMN';
      MenuWordWrapIndex: Result := 'MENUWORDWRAP';
    else
      Result := '';
      TdxGanttControlExceptions.ThrowImageNotFoundException;
    end;
  end;

var
  AName: string;
begin
  AName := GetName;
  Result := TdxSmartImage.Create;
  Result.LoadFromResource(HInstance, AName, 'SVG');
end;

class function TdxGanttControlImages.GetImage(Index: Integer): TdxSmartImage;
begin
  if not FImages.TryGetValue(Index, Result) then
  begin
    Result := CreateImage(Index);
    FImages.Add(Index, Result);
  end;
end;

end.
