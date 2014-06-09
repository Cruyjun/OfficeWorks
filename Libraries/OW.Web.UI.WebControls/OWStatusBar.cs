using System.Web.UI;
using System.Web.UI.WebControls;

namespace OW.Web.UI.WebControls
{
	/// <summary>
	/// Summary description for OWStatusBar.
	/// </summary>
	public class OWStatusBar: Label
	{
		private StatusBarType _OWStatusBarType;

		/// <summary>
		/// Diferentes mensagens que poderá assumir a Status Bar
		/// </summary>
		public enum StatusBarType
		{
			StatusInformation = 0,
			StatusConfirm = 1,
			StatusHidden = 2		
		}
		
		public StatusBarType OWStatusBarType
		{
			get
			{
				return this._OWStatusBarType;
			}
			set
			{
				this._OWStatusBarType = value;
			}
		}

		//override do método render	
		protected override void Render(HtmlTextWriter output)
		{
			string bSTRmessage;
			switch(_OWStatusBarType)
			{
				case StatusBarType.StatusConfirm: 
				{
					bSTRmessage = ResX.GetString("ConfirmDelRecord");
					break;
				}
				case StatusBarType.StatusInformation: 
				{
					bSTRmessage = ResX.GetString("SuccessMsg");
					break;
				}
				case StatusBarType.StatusHidden: 
				{
					bSTRmessage = "&nbsp;";
					break;
				}
				default:
				{
					bSTRmessage = "&nbsp;";
					break;
				}			
			}

			base.Width		= new Unit(100,UnitType.Percentage);
			base.CssClass	= "WARNINGS";
			base.Text		= bSTRmessage;
			base.Render(output);
		}
	}
}
