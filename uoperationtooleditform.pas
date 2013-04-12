unit UOperationToolEditForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs, DbCtrls,
  StdCtrls, Buttons, ZDataset;

type

  { TfrmOperationTool }

  TfrmOperationTool = class(TForm)
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    cbToolName: TDBLookupComboBox;
    DBMemo1: TDBMemo;
    dsTool: TDatasource;
    gbOperationTool: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    qryTool: TZQuery;
    qryTooltool_description: TMemoField;
    qryTooltool_id: TLongintField;
    qryTooltool_name: TStringField;
    procedure cbToolNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure qryToolAfterScroll(DataSet: TDataSet);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmOperationTool: TfrmOperationTool;

implementation

{$R *.lfm}

{ TfrmOperationTool }

procedure TfrmOperationTool.cbToolNameChange(Sender: TObject);
begin

end;

procedure TfrmOperationTool.FormCreate(Sender: TObject);
begin

end;

procedure TfrmOperationTool.FormShow(Sender: TObject);
begin

end;

procedure TfrmOperationTool.qryToolAfterScroll(DataSet: TDataSet);
begin

end;

end.

