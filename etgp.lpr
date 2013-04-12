program etgp;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, lazreportpdfexport, zcomponent, 
UMainForm, UCiselnikyForm, UCiselnikyAddForm, UPartCodingForm,
  UOptimalTPForm, UCAbstract, 
UCiselnikDefaultForm, UCFixture,
UCOperationName, UOperationNameForm, USettings, UTools, UTemplatesForm, UTemplateEditForm, UTPOperationEditForm, UOperationEditForm,
UOperationToolEditForm, UOperationFixtureEditForm, UCompaniesForm, 
UCompanyEditForm, UCompany, UTemplateChooseForm, UProgressForm, UAboutForm;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmCiselniky, frmCiselniky);
  Application.CreateForm(TfrmPartCoding, frmPartCoding);
  Application.CreateForm(TfrmOptimalTP, frmOptimalTP);
  Application.CreateForm(TfrmSettings, frmSettings);
  Application.CreateForm(TfrmTemplates, frmTemplates);
  Application.CreateForm(TfrmTemplateEdit, frmTemplateEdit);
  Application.CreateForm(TfrmTPOperationEdit, frmTPOperationEdit);
  Application.CreateForm(TfrmOperationEdit, frmOperationEdit);
  Application.CreateForm(TfrmOperationTool, frmOperationTool);
  Application.CreateForm(TfrmOperationFixtureEdit, frmOperationFixtureEdit);
  Application.CreateForm(TfrmCompanies, frmCompanies);
  Application.CreateForm(TfrmCompanyEdit, frmCompanyEdit);
  Application.CreateForm(TfrmTemplateChoose, frmTemplateChoose);
  Application.CreateForm(TfrmProgress, frmProgress);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.Run;
end.

