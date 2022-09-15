# RoboArch Tool

| Repository                                                                        |        |
| :---                                                                              | :---:  |
| [roboarch-metamodel](https://github.com/UoY-RoboStar/roboarch-metamodel)          |        |
| [roboarch-textual](https://github.com/UoY-RoboStar/roboarch-textual)              |  <--   |
| [roboarch2chart-epsilon](https://github.com/UoY-RoboStar/roboarch2chart-epsilon)  |        |
| [roboarch-examples](https://github.com/UoY-RoboStar/roboarch-examples)            |        |
| [robochart2text-epsilon](https://github.com/UoY-RoboStar/robochart2text-epsilon)  |        |

This is repository contains the RoboArch  textual support for parsing and validating textual descriptions.

## Environment Setup

1. Download eclipse modelling tools (version 2020-09) https://www.eclipse.org/downloads/packages/release/2021-09/r/eclipse-modeling-tools

1. Extract the downloaded archive to a convenient location to work from.

1. Open eclipse from *./eclipse/eclipse* executable file. You will need to have a suitable Java runtime installed. Open JDK 11 was used during development.

1. Install eclipse plugins via: *Help > Install New Software*;  make sure to uncheck the “*Show only the latest versions of available software*” checkbox.

> During installation of the following plugins, restart eclipse whenever prompted and accept any prompts to proceed with unsigned plugins.

### Eclipse Plugin Installation

1. From the default update site that should be available in the drop-down list https://download.eclipse.org/releases/2021-09 install:
    - Eclipse PDE Plug-in Developer Resources (version 3.14)

1. From update site https://download.eclipse.org/technology/m2e/releases/1.20.1 install:
    - m2e - Maven Integration for Eclipse (includes Incubating components)

1. From update site  http://download.eclipse.org/modeling/tmf/xtext/updates/composite/releases/ install:
    - Xtext complete SDK (version 2.25)

1. From update site  http://download.eclipse.org/epsilon/updates/2.3/
    - Epsilon Core (version 2.3)
    - "" Core Development Tools “”
    - "" Development Tools for EMF “”
    - "" Model Comparison for EUnit “”
    - "" EMF Integration “”
    - "" Validation Language EMF Integration “”
    - "" Wizard Language EMF Integration “”

1. From update site https://robostar.cs.york.ac.uk/robotool/metamodel/update_2.0.0.202006041647 install:
    - RoboChart Metamodel
    - RoboChart Metamodel Developer Resources

1. From update site https://robostar.cs.york.ac.uk/robotool/textual/update_2.0.0.202006041651/ install:
    - RoboChart Textual Editor Developer Resources

1. From update site https://robostar.cs.york.ac.uk/robotool/graphical/update_2.0.0.202007071415/ install:
    - RoboChart Graphical Editor
    - RoboChart Graphical Editor Developer Resources

1. From update site https://robostar.cs.york.ac.uk/robotool/robosim-metamodel/update_2.0.0.202101141043/ install:
    - RoboSim Metamodel
    - RoboSim Metamodel Developer Resources

1. From update site https://robostar.cs.york.ac.uk/robotool/robosim-textual/update_2.0.0.202101181241/ install:
    - RoboSim Textual Editor
    - RoboSim Textual Editor Developer Resources

1. From update site https://robostar.cs.york.ac.uk/robotool/robochart2sim/update_1.0.0.202102151356/ install:
    - RoboChart2Sim Metamodel
    - RoboChart2Sim Metamodel Developer Resources


### Repository setup
1. Clone the RoboArch repositories, roboarch-metamodel and roboarch-textual, to a convenient working location.

1. Open eclipse that was configured in the previous [section](#eclipse-plugin-installation).

1. Import the RoboArch projects from the repositories into the eclipse workspace by repeating the following for each repository.
    1.  *File > Import*.  In the dialog under the General folder select *Existing Projects into Workspace* and then click next.
    2.  Click browse and navigate to the directory of the repository. Check the Search for nested project checkbox.
    3.  Click Finish.

### Build
1. Open the eclipse java perspective

1. In the package explorer in the *circus.robocalc.roboarch* project locate the *roboarch.genmodel* file in the model subdirectory and right click it and select *Open With > EMF Generator* from the menu that appears.

1. In the generator pane that opens right click the RoboArch entry  and click Generate All. This will create a emf-gen folder and there should be no errors indicated by the *circus.robocalc.roboach* project icon in the package explorer.

1. In the package explorer in the *circus.robocalc.roboarch* project locate the *roboarch.mwe2* file in the *src* subdirectory.

1. Right click on the  *roboarch.mwe2* and select Run As and click on the *MWE2 Workflow* from the pop-out menu. If there is a prompt regarding project errors click proceed to continue. The console pane will output progress and it should complete after about 2 minutes. There should be no errors listed in the console window on *Done* being reported.

1. Under the *circus.robocalc.roboarch.textual project* folder in the package explorer in the *src* subdirectory, locate the *GenerateRoboArch.mwe2* file.

1. Right click on the *GenerateRoboArch.mwe2* and select *Run As* and click on the *MWE2 Workflow* from the pop-out menu. If there is a prompt regarding project errors click proceed to continue. The console pane will output progress and it should complete after about 2 minutes. There should be no errors listed in the console window on Done being reported.

1. Under the *circus.robocalc.roboarch.textual.ui* project locate and delete the file *RoboArchProposalProvider.java* which can be found in *src* > *circus.robocalc.roboarch.textual.ui.contentassist* subdirectories.

1. Under *Run > Run Configurations…* in the the *Run Configurations* dialog box.

    1. Select the *Launch Runtime Eclipse* under *Eclipse Application* from tge left-hand pane.

    1. In The *Plug-ins* tab, from the drop down menu select *plug-ins selected below only*.

    1. Click the *Select All* button along the right hand side of the dialog box. All of the plugins in the list of plugins should be selected.

    1. Under *Target Platform* from the list on plugins un-check the following so that they are  not enabled in the runtime eclipse instance.
        - circus.robocalc.robosim
        - ccircus.robocalc.robosim.editor
        - ccircus.robocalc.robosim.textual
        - ccircus.robocalc.robosim.ide
        - ccircus.robocalc.robosim.ui

### Launch
1. Once there are no errors displayed for the projects in the package explorer, the RoboArch tool can be launched by right clicking on circus.robocalc.roboarch.textual and selecting Run As  and from the pop-out menu click Eclipse Application.

1. In the dialog that appears select *Launch Runtime Eclipse* and click Ok.


### Using
Any new project created with files ending in *.rac within the runtime eclipse will be opened in a RoboArch editor and will parsed and validated.

However, to generate RoboChart models for verification the epsilon projects need to be configured as detailed in the remaining sections of this document.






## RoboChart Model Generation
This section covers the set up of the environment for generating RoboChart models from RoboArch descriptions.

### RoboChart2Text
Model to text generation for RoboChart models.

> Prerequisites: [Environment Setup](#environment-setup)

#### Setup
1. Clone the robochart2text-epsilon git repository to a convenient working location.

1. Launch a runtime eclipse instance of the tool as indicated in the [launch](#launch) section of this document.

1. Switch to the eclipse Epsilon perspective.

1. Import the eclipse projects  including nested projects from the directory of the robochart2text-epsilon repository using *File > Import*, which results in two added projects in the eclipse *Project Explorer*: *circus.robocalc.robochart2text.gen* and *RoboChart_Test_Input*

The model to text generator is the *robochart2text.egx*, file this is invoked through ant scripts to pass in the input models and manage the output locations. The unit tests in the next section are an example of ant scripts that make use of the generator.

#### Unit Tests

The robochart2text unit test file eunit.xml in the scripts directory is an example of an ant script. It can be executed by:

1. Right clicking *robochart2text-eunit.launch* selecting Run As and clicking *robochart2text-eunit* from the pop-out menu.

The unit test will run with debug trace printed to the console, on completion results will be visible in the EUnit pane.




### RoboArch2Chart
The implementation of the RoboArch transformation rules to RoboChart.

> Prerequisites: [Environment Setup](#environment-setup) and [RoboChart2Text](robochart2text)

#### Setup
1. Clone the RoboArch2Chart-epsilon git repository to a convenient working location.

1. Launch a runtime eclipse instance of the tool as indicated in the [launch](#launch) section of this document.

1. Switch to the eclipse Epsilon perspective.

1. Import the eclipse projects including nested projects from the parent directory of the robochart2text-epsilon repository via *File > Import*, which results in 14 projects being added.

1. Check the Project Explorer’s Projects Presentation is set to Flat if they are not all visible.


The roboarch2chart transformation primary rule is the *RA2RC.etl* file located in the *circus.robocalc.roboarch2chart.erules* project in the erules directory.

The transformation of model is coordinated using ant scripts the primary one being *run-ra2rc.xml* located in the *circus.robocalc.roboarch2chart.erules* project in the scripts directory.

#### Unit tests
The unit tests and models are found in the separate project *circus.robocalc.roboarch2chart.test*.

The tests can be executed by:
1. Locating *roboarch2chart.tests-runall.launch*.

1. Right-click *roboarch2chart.tests-runall.launch* file, select Run As and click *roboarch2chart.tests-runall* from the pop-out  menu.

The unit tests will run and the debug trace will be printed to the Console pane, on completion results will be visible in the EUnit pane.

The generated models and RoboChart text will appear in the *circus.robocalc.roboarch2chart.tests* project in directories *generated-robochart-models* and *generated-robochart-text*, respectively.


The source input RoboArch descriptions used for the unit tests can be found in the projects *roboarch-test-text* and *RoboChart_Test_Models*
