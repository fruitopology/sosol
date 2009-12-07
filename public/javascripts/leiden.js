function init() 
  {
//stuff below is for the menu bar
    var menuModel = new DHTMLSuite.menuModel();
  	menuModel.addItemsFromMarkup('menuModel');
    	menuModel.setMainMenuGroupWidth(00);	
  	menuModel.init();
	
  	var menuBar = new DHTMLSuite.menuBar();
  	menuBar.addMenuItems(menuModel);
  	menuBar.setMenuItemCssPrefix('Custom_');
  	menuBar.setCssPrefix('Custom_');
  	menuBar.setTarget('menuDiv');
	
  	menuBar.init();
  }
  
window.onload = init;

function helpDialogOpen(view)
{ // grab focus of main window textarea before open new window for IE browser only
  // as non-IE gets focus again in helper.js in the insertText function
  getFocusMain()
  
  switch (view)
  {
  case "ancientdia":
  case "abbrev":
  case "gapellipNT":
  case "gapilleg":
  case "gaplost":
  case "vestig":
  case "division":
    {
      openconfig = config='height=185, width=675, left=150, top=50, toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, directories=no, status=no';
      break;
    }
  case "gapelliplang":
    {
      openconfig = config='height=210, width=675, left=150, top=50, toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, directories=no, status=no';
      break;
    }
  case "appalt":
  case "appsubst":
    {
      openconfig = config='height=225, width=875, left=150, top=50, toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, directories=no, status=no';
      break;
    }
  case "apporth":
    {
      openconfig = config='height=350, width=875, left=150, top=50, toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, directories=no, status=no';
      break;
    }
  case "tryit":
  case "appBL":
  case "appedit":
    {
      openconfig = config='height=275, width=1225, left=150, top=50, toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, directories=no, status=no';
      break;
    }
    
  case "number":
    {
      openconfig = config='height=300, width=775, left=150, top=50, toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, directories=no, status=no';
      break;
    }
  default: /* nopts is default and need to clear optional xml values and leave diachar filled in */
    {
      alert("Oops, error, this is not a valid helper dialog page " + view);
    }
  }
  //helpView is global variable defined with Ruby url_for in inline javascript in edit.haml 
  newWindowURL = helpView.replace("wheretogo", view);
  window.open (newWindowURL, '', openconfig); 
}

/*###########################################################################################*/
/* getFocusMain - get location for inserting later on before lose it - IE has biggest issue      */
/*###########################################################################################*/

function getFocusMain()
{
  element = document.getElementById('ddb_identifier_leiden_plus');
  element.focus();
}

/*###########################################################################################*/
/* insertDiacriticalMain                                                                      */
/*###########################################################################################*/

function insertDiacriticalMain(diacritical_type)
{
  getFocusMain()
  
  /* type is parm passed from view javascript call - 'A' is the default character to pass in the 
     XML to pass the xsugar grammar - stripped back out when returns */
  
  startxml = "<hi rend=\"" + diacritical_type + "\">A</hi>";
  
// sets the 'success' variable used as the onSuccess function from ajax call to convert the XML
  success = function(resp) {
    leidenh = resp.responseText;
//  strips the leading space and default character 'A' to only insert the ancient dicritical
    textToInsert = leidenh.substr(2);
    insertTextMain(textToInsert);
     }
  
  convertXMLMain();
  
//  textToInsert = leidenh.replace(/A/,"");

} /*########################     end insertDiacriticalMain     ########################*/

/*###########################################################################################*/
/* insertDeletionMain                                                                          */
/*###########################################################################################*/

function insertDeletionMain(deletion_type)
{
  getFocusMain()
  
  startxml = "<del rend=\"" + deletion_type + "\">replace this with actual deletion content</del>";
  
// sets the 'success' variable used as the onSuccess function from ajax call to convert the XML
  success = function(resp) {
    leidenh = resp.responseText;
    insertTextMain(leidenh);
     }
  
  convertXMLMain(); 
} /*########################     end insertDeletionMain     ########################*/

/*###########################################################################################*/
/* insertMilestoneMain                                                                          */
/*###########################################################################################*/

function insertMilestoneMain(milestone_type)
{
  getFocusMain()
  
  startxml = "<milestone rend=\"" + milestone_type + "\" unit=\"undefined\"/>";
  
// sets the 'success' variable used as the onSuccess function from ajax call to convert the XML
  success = function(resp) {
    leidenh = resp.responseText;
    insertTextMain(leidenh);
     }
  
  convertXMLMain();
} /*########################     end insertMilestoneMain     ########################*/

/*###########################################################################################*/
/* insertDivisionMain                                                                          */
/*###########################################################################################*/

function insertDivisionMain(division_type)
{
  getFocusMain()
  
  startxml = "<div n=\"" + division_type + "\" type=\"textpart\"><ab>replace this with actual ab tag content</ab></div>";
  
  new Ajax.Request(ajaxConvert, 
  {
  method: 'get',
  parameters : {xml:startxml},
  onSuccess : function(resp) {
    leidenh = resp.responseText;
    insertTextMain(leidenh);
     },
  onFailure : function(resp) {
   alert("Oops, there's been an error." + resp.responseText);   
     }
  });

} /*########################     end insertDivisionMain     ########################*/

/*###########################################################################################*/
/* insert underdot - make character unclear                                                  */
/*###########################################################################################*/

function insertUnderdot()
{
  getFocusMain()
  
  var underdot = "\u0323"; /* unicode value for combining underdot */
  
  insertTextMain(underdot);
}


/*###########################################################################################*/
/* wrapxmlMain function                                                                          */
/*###########################################################################################*/

function wrapxmlMain(xml)
{
  temptopass = "<ab>" + xml + "</ab>";
  return temptopass;
}

/*###########################################################################################*/
/* ajax call to server to convert xml to leiden+                                             */
/*###########################################################################################*/

function convertXMLMain()
{
  xmltopass = wrapxmlMain(startxml);
  
  new Ajax.Request(ajaxConvert, 
  {
  method: 'get',
  parameters : {xml:xmltopass},
  onSuccess : success,
  onFailure : function(resp) {
   alert("Oops, there's been an error." + resp.responseText);   
     }
  });
}

/*###########################################################################################*/
/* insert value into textbox - vti = value to insert                                         */
/*###########################################################################################*/

function insertTextMain(vti)
{
  if(typeof document.selection != 'undefined') /* means IE browser */
    {
      var range = document.selection.createRange();
      range.text = vti;
      range.select();
      range.collapse(false);
    }
  else 
    if(typeof element.selectionStart != 'undefined') /* means Mozilla browser */
      {
        var start = element.selectionStart;
        var end = element.selectionEnd;
        element.value = element.value.substr(0, start) + vti + element.value.substr(end);
        var pos = start + vti.length;
        element.selectionStart = pos;
        element.selectionEnd = pos;
      }
    else /* not sure what browser */
      {
        element.value = element.value+c;
      };
} /*########################     end insertTextMain     ########################*/