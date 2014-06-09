using System.Drawing;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace OW.Web.UI.WebControls
{
	/// <summary>
	/// Summary description for OWCalendar.
	/// </summary>
	public class OWCalendar : Calendar 
	{
		public OWCalendar(){}

		/// <summary>
		/// Implementação do método render
		/// </summary>
		/// <param name="writer"></param>
		protected override void Render(HtmlTextWriter writer)
		{
			//Title
			this.TitleStyle.Font.Bold = true;
			this.TitleStyle.ForeColor = Color.White;
			this.TitleStyle.BackColor = Color.DarkBlue;
			//Next and Previous selector
			this.NextPrevStyle.Font.Bold = true;
			this.NextPrevStyle.ForeColor = Color.White;
			this.NextPrevStyle.BackColor = Color.DarkBlue;
			//Day Header
			this.DayHeaderStyle.ForeColor = Color.DarkBlue;
			//Day
			this.DayStyle.ForeColor = Color.Black;
			this.DayStyle.BackColor = Color.White;
			//Today
			this.TodayDayStyle.Font.Bold = true;
			this.TodayDayStyle.ForeColor = Color.Red;
			this.TodayDayStyle.BackColor = Color.White;
			//Seleted day
			this.SelectedDayStyle.Font.Bold = true;
			this.SelectedDayStyle.ForeColor = Color.White;
			this.SelectedDayStyle.BackColor = Color.DarkBlue;
			//Other months
			this.OtherMonthDayStyle.ForeColor = Color.Silver;			
			//Grid Lines
			this.ShowGridLines = true;
			//Borders
			this.BorderColor = Color.WhiteSmoke;
			this.BorderWidth = new Unit(1, UnitType.Pixel);

			base.Render (writer);
		}

	}
}
