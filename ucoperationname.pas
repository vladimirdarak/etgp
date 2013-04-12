unit UCOperationName;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, UCAbstract, db, Forms, Controls, Dialogs,
  ZDataset, ExtCtrls, StdCtrls, ComCtrls, ZConnection, ZSqlUpdate;

const
  SQL_SELECT_ALL = 'SELECT operation_name_id, operation_name FROM operation_name';
  SQL_DELETE_ALL = 'DELETE FROM operation_name WHERE operation_name_id = :operation_name_id';
  SQL_INSERT = 'INSERT INTO operation_name (operation_name) VALUES(:operation_name)';
  SQL_UPDATE = 'UPDATE operation_name SET operation_name = :operation_name WHERE operation_name_id = :operation_name_id';

type
  TCOperationName = class(TCAbstract)
    private
      FForm: TForm;
      FConnection: TZConnection;
      FQuery: TZQuery;
      FDatasource: TDatasource;

      procedure OnSaveClick;
      procedure OnCancelClick;

      function GetQuery:TZQuery;
      procedure SetQuery(Query: TZQuery);
      function GetDataSource:TDatasource;
      procedure SetDataSource(Datasource: TDatasource);
      function GetForm:TForm;
      procedure SetForm(Form: TForm);
    public
      property MainQuery: TZQuery read GetQuery write SetQuery;
      property MainDatasource: TDatasource read GetDatasource write SetDatasource;
      property MainForm: TForm read GetForm write SetForm;

      constructor Create(TheOwner: TComponent; MainConnection: TZConnection);
      procedure OnAddClick(Sender: TObject); override;
      procedure OnEditClick(Sender: TObject); override;
      procedure OnDeleteClick(Sender: TObject); override;
      procedure OnAfterScroll(DataSet: TDataSet); override;
      procedure SetTab(PageControl: TPageControl); override;
  end;

implementation

uses
  UCiselnikyAddForm, UCiselnikyForm, UOperationNameForm, UTools;

constructor TCOperationName.Create(TheOwner: TComponent; MainConnection: TZConnection);
var
  vQuery: TZQuery;
  vDataSource: TDataSource;
  vUpdateQuery: TZUpdateSQL;
begin
  //FForm := TfrmCiselnikAdd.Create(TheOwner);
  SetForm(TfrmCiselnikAdd.Create(TheOwner));

  vUpdateQuery := TZUpdateSQL.Create(TheOwner);
  with vUpdateQuery do
  begin
    DeleteSQL.Add(SQL_DELETE_ALL + ';');
    InsertSQL.Add(SQL_INSERT + ';');
    ModifySQL.Add(SQL_UPDATE + ';');
  end;

  // vytvorim TZQuery
  vQuery := TZQuery.Create(TheOwner);
  with vQuery do
  begin
    Connection := MainConnection;
    SQL.Text:=SQL_SELECT_ALL;
    UpdateObject := vUpdateQuery;

    Active := true;

    {Fields.FieldByName('operation_name_id').Visible:=false;
    with Fields.FieldByName('operation_name') do
    begin
      DisplayLabel:='Názov operácie';
      DisplayWidth := 20;
    end;}

    SortedFields:='operation_name';

    //AfterScroll:=@OnAfterScroll;
  end;

  // priradim TZQuery
  SetQuery(vQuery);

  // vytvorim TDataSource
  vDataSource := TDataSource.Create(TheOwner);
  vDataSource.DataSet := MainQuery;

  // priradim TDataSource
  SetDatasource(vDataSource);
end;

function TCOperationName.GetForm:TForm;
begin
  result:=FForm;
end;

procedure TCOperationName.SetForm(Form: TForm);
begin
  if(FForm = nil) then
    FForm := Form;
end;

function TCOperationName.GetQuery:TZQuery;
begin
  result:=FQuery;
end;

procedure TCOperationName.SetQuery(Query: TZQuery);
begin
  if(FQuery = nil) then
    FQuery := Query;
end;

function TCOperationName.GetDatasource:TDatasource;
begin
  result:=FDatasource;
end;

procedure TCOperationName.SetDatasource(Datasource: TDatasource);
begin
  if(FDatasource = nil) then
    FDatasource := Datasource;
end;

procedure TCOperationName.OnAddClick(Sender: TObject);
begin
  {Pridavanie}
  if MainForm = nil then
    exit;

  if MainDatasource = nil then
    exit;

  if(MainForm is TfrmCiselnikAdd) then
  begin
    TfrmCiselnikAdd(MainForm).Caption := 'Pridať operáciu do číselníka';
    TfrmCiselnikAdd(MainForm).edtName.DataSource := MainDatasource;
    TfrmCiselnikAdd(MainForm).edtName.DataField := 'operation_name';

    TfrmCiselnikAdd(MainForm).mDescription.Enabled := false;

    MainQuery.Append;

    case MainForm.ShowModal of
      mrOK: OnSaveClick;
      mrCancel: OnCancelClick;
    end;
  end;
end;

procedure TCOperationName.OnEditClick(Sender: TObject);
begin
  {Uprava}
  if MainForm = nil then
    exit;

  if(FForm is TfrmCiselnikAdd) then
  begin
    TfrmCiselnikAdd(MainForm).Caption := 'Upraviť údaje o operácii';
    TfrmCiselnikAdd(MainForm).edtName.DataSource := MainDatasource;
    TfrmCiselnikAdd(MainForm).edtName.DataField := 'operation_name';

    TfrmCiselnikAdd(MainForm).mDescription.Enabled:=false;

    MainQuery.Edit;

    case TfrmCiselnikAdd(MainForm).ShowModal of
      mrOK: OnSaveClick;
      mrCancel: OnCancelClick;
    end;
  end;
end;

procedure TCOperationName.OnDeleteClick(Sender: TObject);
begin
  {Mazanie}
  if(MessageDlg('Upozornenie', 'Naozaj chcete zvolenú položku z číselníka vymazať?', mtWarning, [mbYes, mbNo], mrNo)) = mrYes then
    MainQuery.Delete;
end;

procedure TCOperationName.OnSaveClick;
begin
  MainQuery.ApplyUpdates;
  TfrmCiselnikAdd(MainForm).mDescription.Enabled:=true;

  DoRefresh(MainQuery, 'operation_name_id');
end;

procedure TCOperationName.OnCancelClick;
begin
  MainQuery.CancelUpdates;
  TfrmCiselnikAdd(MainForm).mDescription.Enabled:=true;
end;

procedure TCOperationName.OnAfterScroll(DataSet: TDataSet);
begin

end;

procedure TCOperationName.SetTab(PageControl: TPageControl);
var
  vTabSheet: TTabSheet;
  vForm: TForm;
begin
  vTabSheet := TTabSheet.Create(PageControl);
  vTabSheet.Parent := PageControl;
  vTabSheet.Caption:='Operácie';

  vForm := TfrmCiselnikFormOperationName.Create(vTabSheet);
  vForm.Parent := vTabSheet;

  with TfrmCiselnikFormOperationName(vForm) do
  begin
    grdList.DataSource := self.MainDatasource;
    with grdList.Columns.Add do
    begin
      FieldName := 'operation_name';
      Width := 260;
      Title.Caption := 'Názov operácie';
    end;
  end;

  vForm.Show;
end;

end.


