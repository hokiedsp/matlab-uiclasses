matlab-uiclasses
==============

A set of MATLAB Classes for rapid UI development. 

The framework for matlab-uiclasses environment is established by its HGWRAPPER base class. This class features:

* Ability to attach or detach a MATLAB handle graphics (HG) object
* Extends the set/get interface of the HGSETGET built-in class so that the HG object properties can be manipulated directly from the attached HGWRAPPER object unless explicitly blocked by the derived class.

It consists of two sub-categories of classes:

* Panel classes (/uipanels)
  These classes implement auto-layout features for panel-type HG objects (e.g., figure, uipanel, axes & uicontainer)
  - uipanelex            Base panel class (implements group Enable)
  - uipanelautoresize    Sets the layout engine to panel's ResizeFcn
  - uiflowgridcontainer  Combinines the features from undocumented built-in uiflowcontainer and uigridcontainer
  - uiaxesarray          A grid of axes (derived from uiflowgridcontainer)
  - uipanelgroup         A set of panels within a panel
  - uibuttongroupex      Extends built-in uibuttongroup (auto-layout radio/toggle buttons)
  - uiscrollpanel        A larger panel inside of a smaller panel with vertical and horizontal scrollbars
  - dialogex             Extends built-in dialog to add OK, Cancel, and Apply buttons

* UI Axes Object classes (uiaxobjs)
  (To be released) 
