inherited ExtendedAttributesDemoMainForm: TExtendedAttributesDemoMainForm
  Caption = 'ExpressGanttControl Extended Attributes Demo'
  PixelsPerInch = 96
  TextHeight = 13
  inherited cxGroupBox1: TcxGroupBox
    inherited lbDescription: TLabel
      Height = 48
      Caption = 
        'Extended attributes are custom fields that allow a user to add a' +
        'dditional data related to tasks or resources (for instance, the ' +
        'costs related to each task or other supplemental text). This dem' +
        'o shows how to use custom fields in the task and resource sheets' +
        '. To add a custom field to the sheet, right-click a column heade' +
        'r, click "Insert Column" in the context menu, and select any fie' +
        'ld from the popup list.'
    end
    inherited lcMain: TdxLayoutControl
      Top = 51
      Height = 709
      inherited GanttControl: TdxGanttControl
        ViewChart.OptionsSheet.Columns.Items = <
          item
            ItemClass = 'TdxGanttControlViewChartSheetColumnIndicator'
            UID = 1
          end
          item
            ItemClass = 'TdxGanttControlViewChartSheetColumnTaskMode'
            UID = 1
          end
          item
            ItemClass = 'TdxGanttControlViewChartSheetColumnTaskName'
            UID = 1
          end
          item
            ItemClass = 'TdxGanttControlViewChartSheetColumnTaskDuration'
            UID = 1
          end
          item
            ItemClass = 'TdxGanttControlViewChartSheetColumnTaskStart'
            UID = 1
          end
          item
            ItemClass = 'TdxGanttControlViewChartSheetColumnTaskFinish'
            UID = 1
          end
          item
            ItemClass = 'TdxGanttControlViewChartSheetColumnPredecessors'
            UID = 1
          end
          item
            ItemClass = 'TdxGanttControlViewChartSheetColumnResourceName'
            UID = 1
          end
          item
            ItemClass = 'TdxGanttControlViewChartSheetColumnPercentComplete'
            UID = 1
          end>
        ViewResourceSheet.OptionsSheet.Columns.Items = <
          item
            ItemClass = 'TdxGanttControlResourceSheetColumnName'
            UID = 1
          end
          item
            ItemClass = 'TdxGanttControlResourceSheetColumnType'
            UID = 1
          end
          item
            ItemClass = 'TdxGanttControlResourceSheetColumnGroup'
            UID = 1
          end
          item
            ItemClass = 'TdxGanttControlResourceSheetColumnBaseCalendar'
            UID = 1
          end>
      end
      inherited dxLayoutItem6: TdxLayoutItem
        ControlOptions.OriginalHeight = 22
        ControlOptions.OriginalWidth = 22
      end
      inherited dxLayoutItem7: TdxLayoutItem
        ControlOptions.OriginalHeight = 22
        ControlOptions.OriginalWidth = 22
      end
      object lcbAlwaysShowEditor: TdxLayoutCheckBoxItem
        Parent = dxLayoutGroup7
        CaptionOptions.Text = 'Always Show Editor'
        OnClick = lcbAlwaysShowEditorClick
        Index = 1
      end
    end
  end
  inherited dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList
    inherited dxLayoutCxLookAndFeel1: TdxLayoutCxLookAndFeel
      PixelsPerInch = 96
    end
  end
  inherited ilActions: TcxImageList
    FormatVersion = 1
  end
end
