object GridForm: TGridForm
  Left = 427
  Top = 215
  Caption = 'ExpressGrid by Developer Express'
  ClientHeight = 269
  ClientWidth = 328
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid1: TcxGrid
    Left = 0
    Top = 0
    Width = 328
    Height = 269
    Align = alClient
    TabOrder = 0
    object cxGrid1DBTableView1: TcxGridDBTableView
      NavigatorButtons.ConfirmDelete = False
      DataController.DataSource = MainForm.DS1
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsView.ColumnAutoWidth = True
      object cxGrid1DBTableView1Pr_id: TcxGridDBColumn
        DataBinding.FieldName = 'Pr_id'
        Width = 40
      end
      object cxGrid1DBTableView1Pr_parent: TcxGridDBColumn
        DataBinding.FieldName = 'Pr_parent'
        Width = 37
      end
      object cxGrid1DBTableView1Pr_name: TcxGridDBColumn
        DataBinding.FieldName = 'Pr_name'
        Width = 91
      end
      object cxGrid1DBTableView1Image: TcxGridDBColumn
        DataBinding.FieldName = 'Image'
        PropertiesClassName = 'TcxImageComboBoxProperties'
        Properties.Images = MainForm.ImageList
        Properties.Items = <
          item
            Description = '1'
            ImageIndex = 0
            Value = '0'
          end
          item
            Description = '2'
            ImageIndex = 1
            Value = '1'
          end
          item
            Description = '3'
            ImageIndex = 2
            Value = '2'
          end>
      end
    end
    object cxGrid1Level1: TcxGridLevel
      GridView = cxGrid1DBTableView1
    end
  end
end
