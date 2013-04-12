unit UCTool;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, UCAbstract, db, Forms, Controls, Dialogs,
  ZDataset, ExtCtrls, StdCtrls, ComCtrls, ZConnection, ZSqlUpdate;

const
  SQL_SELECT_ALL = 'SELECT tool_id, tool_name, tool_description FROM tool';
  SQL_ATTR_SELECT_ALL = 'SELECT tool_attribute_id, attribute_name, attribute_value, attribute_desc FROM tool_attribute WHERE tool_id = :tool_id';
  SQL_DELETE_ALL = 'DELETE FROM tool WHERE tool_id = :tool_id';
  SQL_ATTR_DELETE_ALL = 'DELETE FROM tool_attribute WHERE tool_id = :tool_id';
  SQL_INSERT = 'INSERT INTO tool (tool_name, tool_description) VALUES(:tool_name, :tool_description)';
  SQL_UPDATE = 'UPDATE tool SET tool_name = :tool_name, tool_description = :tool_description WHERE tool_id = :tool_id';

type
  TCTool = class(TCAbstract)
    private
      FForm: TForm;
      FQuery: TZQuery;
      FQueryAttr: TZquery;
      FDatasource: TDatasource;
      FDatasourceAttr: TDatasource;

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
  UCiselnikyAddForm, UCiselnikDefaultForm, UTools;

constructor TCTool.Create(TheOwner: TComponent; MainConnection: TZConnection);
var
  vQuery, vQueryAttr: TZQuery;
  vDataSource, vDSAttr: TDataSource;
  vUpdateQuery: TZUpdateSQL;
begin
  SetForm(TfrmCiselnikAdd.Create(TheOwner));

  vUpdateQuery := TZUpdateSQL.Create(TheOwner);
  with vUpdateQuery do
  begin
    DeleteSQL.Add(SQL_ATTR_DELETE_ALL + ';');
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

    {Fields.FieldByName('tool_id').Visible:=false;
    Fields.FieldByName('tool_description').Visible:=false;
    with Fields.FieldByName('tool_name') do
    begin
      DisplayLabel:='Názov nástroja';
      DisplayWidth := 20;
    end;}

    SortedFields:='tool_name';

    AfterScroll:=@OnAfterScroll;
  end;

  // priradim TZQuery
  SetQuery(vQuery);

  // vytvorim TDataSource
  vDataSource := TDataSource.Create(TheOwner);
  vDataSource.DataSet := MainQuery;

  // priradim TDataSource
  SetDatasource(vDataSource);


  vQueryAttr := TZQuery.Create(TheOwner);
  with vQueryAttr do
  begin
    Connection := MainConnection;
    SQL.Text:=SQL_ATTR_SELECT_ALL;

    Params.ParamByName('tool_id').Value:=MainQuery.FieldByName('tool_id').AsInteger;

    Active := true;

    Fields.FieldByName('tool_attribute_id').Visible:=false;
    Fields.FieldByName('attribute_desc').Visible:=false;
  end;

  FQueryAttr := vQueryAttr;

  vDSAttr := TDataSource.Create(TheOwner);
  vDSAttr.DataSet := vQueryAttr;

  FDatasourceAttr := vDSAttr;
end;

function TCTool.GetForm:TForm;
begin
  result:=FForm;
end;

procedure TCTool.SetForm(Form: TForm);
begin
  if(FForm = nil) then
    FForm := Form;
end;

function TCTool.GetQuery:TZQuery;
begin
  result:=FQuery;
end;

procedure TCTool.SetQuery(Query: TZQuery);
begin
  if(FQuery = nil) then
    FQuery := Query;
end;

function TCTool.GetDatasource:TDatasource;
begin
  result:=FDatasource;
end;

procedure TCTool.SetDatasource(Datasource: TDatasource);
begin
  if(FDatasource = nil) then
    FDatasource := Datasource;
end;

procedure TCTool.OnAddClick(Sender: TObject);
begin
  {Pridavanie}
  if MainForm = nil then
    exit;

  if MainDatasource = nil then
    exit;

  if(MainForm is TfrmCiselnikAdd) then
  begin
    TfrmCiselnikAdd(MainForm).Caption := 'Pridať nástroj do číselníka';
    TfrmCiselnikAdd(MainForm).edtName.DataField := 'tool_name';
    TfrmCiselnikAdd(MainForm).edtName.DataSource := MainDatasource;

    TfrmCiselnikAdd(MainForm).mDescription.DataField := 'tool_description';
    TfrmCiselnikAdd(MainForm).mDescription.DataSource := MainDatasource;

    MainQuery.Append;

    case MainForm.ShowModal of
      mrOK: OnSaveClick;
      mrCancel: OnCancelClick;
    end;
  end;
end;

procedure TCTool.OnEditClick(Sender: TObject);
begin
  {Uprava}
  if MainForm = nil then
    exit;

  if(FForm is TfrmCiselnikAdd) then
  begin
    TfrmCiselnikAdd(MainForm).Caption := 'Upraviť údaje o nástroji';
    TfrmCiselnikAdd(MainForm).edtName.DataSource := MainDatasource;
    TfrmCiselnikAdd(MainForm).edtName.DataField := 'tool_name';

    TfrmCiselnikAdd(MainForm).mDescription.DataSource := MainDatasource;
    TfrmCiselnikAdd(MainForm).mDescription.DataField := 'tool_description';

    MainQuery.Edit;

    case TfrmCiselnikAdd(MainForm).ShowModal of
      mrOK: OnSaveClick;
      mrCancel: OnCancelClick;
    end;
  end;
end;

procedure TCTool.OnDeleteClick(Sender: TObject);
var vCount: Integer;
begin
  vCount := GetRecordCount(TZConnection(MainQuery.Connection), 'operation_tool', ['tool_id'], [MainQuery.FieldByName('tool_id').AsInteger]);

  // overime, ci existuje TP, ktory ma zvoleny tento nastroj
  //ak existuje
  if vCount > 0 then
    //zobraz hlasku ze zaznam nieje mozne vymazat
    MessageDlg('Chyba', 'Zvolený nástroj nieje možné vymazať pretože sa používa v niektorm z technologických postupov' , mtError, [mbOk], mrOk)
  else
    {Mazanie}
    if(MessageDlg('Upozornenie', 'Naozaj chcete zvolenú položku z číselníka vymazať?', mtWarning, [mbYes, mbNo], mrNo)) = mrYes then
      MainQuery.Delete;
end;

procedure TCTool.OnSaveClick;
begin
  MainQuery.ApplyUpdates;

  DoRefresh(MainQuery, 'tool_id');
end;

procedure TCTool.OnCancelClick;
begin
  MainQuery.CancelUpdates;
end;

procedure TCTool.OnAfterScroll(DataSet: TDataSet);
begin
  FQueryAttr.Close;
  FQueryAttr.Params.ParamByName('tool_id').Value := DataSet.FieldByName('tool_id').AsInteger;
  FQueryAttr.Open;
end;

procedure TCTool.SetTab(PageControl: TPageControl);
var
  vTabSheet: TTabSheet;
  vForm: TForm;
begin
  vTabSheet := TTabSheet.Create(PageControl);
  vTabSheet.Parent := PageControl;
  vTabSheet.Caption:='Nástroje';

  vForm := TfrmCiselnikFormDefault.Create(vTabSheet);
  vForm.Parent := vTabSheet;
  with TfrmCiselnikFormDefault(vForm) do
  begin
    grdList.DataSource := self.MainDatasource;
    grdAttrs.DataSource := FDatasourceAttr;

    with grdList.Columns.Add do
    begin
      FieldName := 'tool_name';
      Width := 260;
      Title.Caption := 'Názov nástroja';
    end;

    mDesc.DataField:='tool_description';
    mDesc.DataSource := self.MainDatasource;
  end;
  vForm.Show;
end;

end.

