unit UCiselnikyForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  DBGrids, ExtCtrls, Buttons, StdCtrls, DbCtrls, ZDataset, ZSqlUpdate,
  UCMachine, UCTool, UCFixture, UCOperationName, contnrs;


type

  { TfrmCiselniky }

  TfrmCiselniky = class(TForm)
    btnClose: TBitBtn;
    btnAdd: TBitBtn;
    btnEdit: TBitBtn;
    btnDelete: TBitBtn;
    pnlActions: TPanel;
    pcCiselniky: TPageControl;
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure DBComboBox1Change(Sender: TObject);
    procedure qMachineAfterScroll(DataSet: TDataSet);
    procedure qMachineEditError(DataSet: TDataSet; E: EDatabaseError;
      var DataAction: TDataAction);
    procedure dsToolsDataChange(Sender: TObject; Field: TField);
    procedure FormCreate(Sender: TObject);
    procedure pcCiselnikyChange(Sender: TObject);
    procedure setOnClickButtons(ActiveType: integer);
  private
    { private declarations }
    FCiselniky: TObjectList;
  public
    { public declarations }
  end;

var
  frmCiselniky: TfrmCiselniky;

implementation

uses
  UMainForm, UCiselnikyAddForm;

{ TfrmCiselniky }

procedure TfrmCiselniky.btnAddClick(Sender: TObject);
begin
end;

procedure TfrmCiselniky.btnDeleteClick(Sender: TObject);
begin
end;

procedure TfrmCiselniky.btnEditClick(Sender: TObject);
begin
end;

procedure TfrmCiselniky.DBComboBox1Change(Sender: TObject);
begin

end;

procedure TfrmCiselniky.qMachineAfterScroll(DataSet: TDataSet);
begin

end;

procedure TfrmCiselniky.qMachineEditError(DataSet: TDataSet;
  E: EDatabaseError; var DataAction: TDataAction);
begin
end;

procedure TfrmCiselniky.dsToolsDataChange(Sender: TObject;
  Field: TField);
begin

end;

procedure TfrmCiselniky.FormCreate(Sender: TObject);
begin
  FCiselniky := TObjectList.create(true);
  FCiselniky.Add(TCMachine.Create(self, frmMain.dbConnection));
  TCMachine(FCiselniky.Last).SetTab(pcCiselniky);

  FCiselniky.Add(TCTool.Create(self, frmMain.dbConnection));
  TCTool(FCiselniky.Last).SetTab(pcCiselniky);

  FCiselniky.Add(TCFixture.Create(self, frmMain.dbConnection));
  TCFixture(FCiselniky.Last).SetTab(pcCiselniky);

  FCiselniky.Add(TCOperationName.Create(self, frmMain.dbConnection));
  TCFixture(FCiselniky.Last).SetTab(pcCiselniky);

  setOnClickButtons(pcCiselniky.ActivePageIndex);
end;

procedure TfrmCiselniky.pcCiselnikyChange(Sender: TObject);
begin
  setOnClickButtons(pcCiselniky.ActivePageIndex);
end;

procedure TfrmCiselniky.setOnClickButtons(ActiveType: integer);
begin
  if FCiselniky.Items[ActiveType] is TCMachine then
  begin
    btnAdd.OnClick := @TCMachine(FCiselniky.Items[ActiveType]).OnAddClick;
    btnEdit.OnClick := @TCMachine(FCiselniky.Items[ActiveType]).OnEditClick;
    btnDelete.OnClick := @TCMachine(FCiselniky.Items[ActiveType]).OnDeleteClick;
  end;

  if FCiselniky.Items[ActiveType] is TCTool then
  begin
    btnAdd.OnClick := @TCTool(FCiselniky.Items[ActiveType]).OnAddClick;
    btnEdit.OnClick := @TCTool(FCiselniky.Items[ActiveType]).OnEditClick;
    btnDelete.OnClick := @TCTool(FCiselniky.Items[ActiveType]).OnDeleteClick;
  end;

  if FCiselniky.Items[ActiveType] is TCFixture then
  begin
    btnAdd.OnClick := @TCFixture(FCiselniky.Items[ActiveType]).OnAddClick;
    btnEdit.OnClick := @TCFixture(FCiselniky.Items[ActiveType]).OnEditClick;
    btnDelete.OnClick := @TCFixture(FCiselniky.Items[ActiveType]).OnDeleteClick;
  end;

  if FCiselniky.Items[ActiveType] is TCOperationName then
  begin
    btnAdd.OnClick := @TCOperationName(FCiselniky.Items[ActiveType]).OnAddClick;
    btnEdit.OnClick := @TCOperationName(FCiselniky.Items[ActiveType]).OnEditClick;
    btnDelete.OnClick := @TCOperationName(FCiselniky.Items[ActiveType]).OnDeleteClick;
  end;
end;

{$R *.lfm}

end.

