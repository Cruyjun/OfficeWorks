using System.Web.UI;
using System.Web.UI.WebControls;

// Esta classe não está a ser compilada.
// Pode vir a ser usada no futuro.

namespace OW.Web.UI.WebControls
{
	public class OWRequiredFieldValidatorForCheckBoxLists : RequiredFieldValidator
	{
		private ListControl _listctrl;
 
		public OWRequiredFieldValidatorForCheckBoxLists()
		{
			base.EnableClientScript = true;
		}
 
		protected override bool ControlPropertiesValid()
		{
			Control ctrl = FindControl(ControlToValidate);
       
			if (ctrl != null) 
			{
				_listctrl = (ListControl) ctrl;
				return (_listctrl != null);   
			}
			else 
				return false;  // raise exception
		}
 
		protected override bool EvaluateIsValid()
		{     
			return _listctrl.SelectedIndex != -1;
		}
	}
}

 

