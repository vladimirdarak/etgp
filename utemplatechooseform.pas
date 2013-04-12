unit UTemplateChooseForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs, DbCtrls,
  DBGrids, ExtCtrls, Grids, Buttons, ZDataset;

type

  { TfrmTemplateChoose }

  TfrmTemplateChoose = class(TForm)
    btnClose: TBitBtn;
    btnOK: TBitBtn;
    dsTemplates: TDatasource;
    grdTemplates: TDBGrid;
    gbTemplates: TDBGroupBox;
    pnlActions: TPanel;
    qryTemplates: TZQuery;
    procedure grdTemplatesPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmTemplateChoose: TfrmTemplateChoose;

implementation

uses
  UTools;

{$R *.lfm}

{ TfrmTemplateChoose }

procedure TfrmTemplateChoose.grdTemplatesPrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
  UTools.DBGridPrepareCanvas(Sender, DataCol, Column, 1);
end;

end.

