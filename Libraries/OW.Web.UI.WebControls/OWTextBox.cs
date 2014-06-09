using System.Web.UI;
using System.Web.UI.WebControls;
using OW.Web.UI.WebControls.Common;

namespace OW.Web.UI.WebControls
{
	/// <summary>
	/// Tipo de alinhamento
	/// </summary>
	public enum AlignmentTypeEnum
	{
		NotSet = 0,
		Left = 1,
		Centered = 2,
		Right = 3,
		Justified = 4
	}

	/// <summary>
	/// TextBox extended
	/// </summary>
	public class OWTextBox : TextBox, IEPWebControl
	{

		#region Properties

		/// <summary>
		/// Tipo de alinhamento
		/// </summary>
		public AlignmentTypeEnum AlignmentType
		{
			get
			{ 
				object obj = this.ViewState["AlignmentType"];
				return obj == null ? AlignmentTypeEnum.NotSet : (AlignmentTypeEnum)obj;
			}
			set { ViewState["AlignmentType"] = value; }
		}

		/// <summary>
		/// Indica se o controlo se espande autom�ticamente
		/// </summary>
		public bool AutoExpand
		{
			get
			{ 
				object obj = this.ViewState["AutoExpand"];
				return obj == null ? false : (bool)obj;
			}
			set { ViewState["AutoExpand"] = value; }
		}

		/// <summary>
		/// Indica se a propriedade Value devolve Null no caso do Texto serem espa�os
		/// </summary>
		public bool TrimToNull
		{
			get
			{
				object obj = this.ViewState["TrimToNull"];				
				return obj == null ? true : (bool)obj;
			}
			set
			{
				this.ViewState["TrimToNull"] = value;
			}
		}

		/// <summary>
		/// Valor do campo
		/// </summary>
		public string Value
		{
			get
			{
				if (this.TrimToNull)
				{
					if (base.Text.ToString().Trim() == string.Empty)
					{
						return Configuration.NullValueString;
					}
				}

				return base.Text;
			}
			set
			{
				base.Text = value;
			}
		}

		#endregion

		#region Constructors

		/// <summary>
		/// Construtor da classe
		/// </summary>
		public OWTextBox(){}
		
		#endregion

		#region Overrides

		/// <summary>
		/// Implementa��o do evento Render
		/// </summary>
		/// <param name="output"></param>
		protected override void Render(HtmlTextWriter output)
		{
			//------------------------------------------------------------
			// Defini��o da classe a aplicar
			//------------------------------------------------------------
			base.CssClass = this.ReadOnly ? "OWTextBoxReadOnly" : "OWTextBox";

			//------------------------------------------------------------
			// Defini��o do alignment do control
			//------------------------------------------------------------
			if (this.AlignmentType != AlignmentTypeEnum.NotSet)
			{
				base.Style.Add("TEXT-ALIGN", this.AlignmentType.ToString().ToLower());
			}

			//------------------------------------------------------------
			// Defini��o do comportamente AutoExpand do controlo
			//------------------------------------------------------------
			if (this.AutoExpand)
			{
				base.Style.Add("OVERFLOW","Auto");
				base.TextMode = TextBoxMode.MultiLine ;
				base.Height = new Unit(0, UnitType.Pixel);
			}

			//------------------------------------------------------------
			// Caso o modo seja multiline, e esteja definido um tamanho
			// m�ximo, vai ser implementado o c�digo para fazer essa gest�o
			//------------------------------------------------------------
			if (base.TextMode == TextBoxMode.MultiLine && base.MaxLength > 0)			{
				base.Attributes.Add("onkeypress", "if (this.value.length + 1 > " + base.MaxLength.ToString() + ") return false;");
				base.Attributes.Add("onchange", "if (this.value.length > " + base.MaxLength.ToString() + ") { this.value = this.value.substring(0, " + base.MaxLength.ToString() + "); alert('" + ResX.GetString("ExceededSizeMsg", base.MaxLength.ToString()) + "')}");
			}

			//------------------------------------------------------------
			// Caso seja multi-line, vai ser for�ado o border
			//------------------------------------------------------------
			if (base.TextMode == TextBoxMode.MultiLine && base.ReadOnly)			
			{
				base.BorderStyle = BorderStyle.Inset;
			}

			//------------------------------------------------------------
			// Render do comportamento base
			//------------------------------------------------------------
			base.Render(output);
		}
		
		#endregion

		#region IEPWebControl Implementation

		/// <summary>
		/// Limpa o conte�do do campo
		/// </summary>
		public void ClearData()
		{
			this.Text = null;
		}

		#endregion
	}
}
