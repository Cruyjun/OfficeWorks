using System.Web.UI.WebControls;

namespace OW.Web.UI.WebControls
{
	/// <summary>
	/// Summary description for EPDateChooser.
	/// </summary>
	public class OWWebDateChooser : Infragistics.WebUI.WebSchedule.WebDateChooser, IEPWebControl
	{
		/// <summary>
		/// Construtor da classe
		/// </summary>
		public OWWebDateChooser(){}

		/// <summary>
		/// Limpa o conteúdo do campo
		/// </summary>
		public void ClearData()
		{
			this.Value = null;
		}
		
		/// <summary>
		/// Implementação do método render
		/// </summary>
		/// <param name="output"></param>
		protected override void Render(System.Web.UI.HtmlTextWriter output)
		{
			if (base.ReadOnly)
			{
				base.CssClass = "OWWebDateChooserReadOnly";
			}			
			else
			{
				base.CssClass = "OWWebDateChooser";
			}

			this.NullDateLabel = string.Empty;
			
			//Calendar Layout
			this.CalendarLayout.CellPadding = 4;
			this.CalendarLayout.ShowYearDropDown = false;
			this.CalendarLayout.ShowMonthDropDown = false;
			//Title
			this.CalendarLayout.TitleStyle.Font.Bold = true;
			this.CalendarLayout.TitleStyle.ForeColor = System.Drawing.Color.White;
			this.CalendarLayout.TitleStyle.BackColor = System.Drawing.Color.DarkBlue;
			//Next and Previous selector
			this.CalendarLayout.NextPrevStyle.Font.Bold = true;
			this.CalendarLayout.NextPrevStyle.ForeColor = System.Drawing.Color.White;
			this.CalendarLayout.NextPrevStyle.BackColor = System.Drawing.Color.DarkBlue;
			//Day Header
			this.CalendarLayout.DayHeaderStyle.ForeColor = System.Drawing.Color.DarkBlue;
			this.CalendarLayout.DayHeaderStyle.BorderDetails.ColorBottom = System.Drawing.Color.Black;
			this.CalendarLayout.DayHeaderStyle.BorderDetails.WidthBottom = new Unit(1, UnitType.Pixel);
			//Day
			this.CalendarLayout.DayStyle.ForeColor = System.Drawing.Color.Black;
			this.CalendarLayout.DayStyle.BackColor = System.Drawing.Color.White;
			//Today
			this.CalendarLayout.TodayDayStyle.Font.Bold = true;
			this.CalendarLayout.TodayDayStyle.ForeColor = System.Drawing.Color.Red;
			this.CalendarLayout.TodayDayStyle.BackColor = System.Drawing.Color.White;
			//Seleted day
			this.CalendarLayout.SelectedDayStyle.Font.Bold = true;
			this.CalendarLayout.SelectedDayStyle.ForeColor = System.Drawing.Color.White;
			this.CalendarLayout.SelectedDayStyle.BackColor = System.Drawing.Color.DarkBlue;
			//Other months
			this.CalendarLayout.OtherMonthDayStyle.ForeColor = System.Drawing.Color.Silver;
			//Footer
			this.CalendarLayout.FooterStyle.Font.Bold = true;
			this.CalendarLayout.FooterStyle.ForeColor = System.Drawing.Color.Red;
			this.CalendarLayout.FooterStyle.BorderColor = System.Drawing.Color.Silver;
			this.CalendarLayout.FooterStyle.BackColor = System.Drawing.Color.White;
			//Grid Lines
			this.CalendarLayout.ShowGridLines = Infragistics.WebUI.WebSchedule.GridLinesType.Both;
			this.CalendarLayout.GridLineColor = System.Drawing.Color.WhiteSmoke;
			//Effects
			this.ExpandEffects.Type = Infragistics.WebUI.WebDropDown.ExpandEffectType.GradientWipe;

			base.Render(output);
		}

	}
}
