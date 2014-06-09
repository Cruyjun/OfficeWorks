//--------------------------------------------------------------------
// Advanced drop-down selection
//--------------------------------------------------------------------
function findString(objDropDownList, millisecondsExpires)
{
	var str = '';
	var myDateF = new Date();
	var fDate = myDateF.getTime().toString();
	if ((fDate - iDate) > millisecondsExpires) {
		sString = '';
	}
	iDate = fDate;
	sString += String.fromCharCode(event.keyCode).toUpperCase();
	for(var i = 0; i < objDropDownList.length; i++) {
		str = objDropDownList[i].text;
		str = str.substring(0, sString.length).toUpperCase();
		if (str == sString) {
			objDropDownList.selectedIndex = i;
			return;
		}
	}
}

//--------------------------------------------------------------------
// Validators activation
//--------------------------------------------------------------------
function TurnOnValidators()
{
	if (Page_Validators != undefined)
	{
		for (i = 0; i < Page_Validators.length; i++)
		{
			ValidatorEnable(Page_Validators[i], true);
		}
	}
}