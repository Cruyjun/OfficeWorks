using System.Web.UI;
using OW.Web.UI.WebControls.Common;
using Infragistics.WebUI.WebDataInput;

namespace OW.Web.UI.WebControls
{
	/// <summary>
	/// Summary description for OWWebTextEdit.
	/// </summary>
	public class OWWebTextEdit : WebTextEdit, IEPWebControl
	{		

		/// <summary>
		/// Construtor da classe
		/// </summary>
		public OWWebTextEdit(){}

		/// <summary>
		/// Limpa o conteúdo do campo
		/// </summary>
		public void ClearData()
		{
			this.Value = null;
		}


		/// <summary>
		/// Carater invisivel para o utilizador ex.'%'
		/// </summary>
		public char WildCardHidden
		{
			get
			{
				object obj = this.ViewState["WildCardHidden"];				
				return obj == null ? '%' : (char)obj;
			}
			set
			{
				this.ViewState["WildCardHidden"] = value;
			}
		}


		/// <summary>
		/// Carater visivel para o utilizador ex.'*'
		/// </summary>
		public char WildCardVisible
		{
			get
			{
				object obj = this.ViewState["WildCardVisible"];				
				return obj == null ? '*' : (char)obj;
			}
			set
			{
				this.ViewState["WildCardVisible"] = value;
			}
		}


		/// <summary>
		/// Indica se aplica a transformação de * por % e viceversa
		/// </summary>
		public bool ApplyWildCard
		{
			get
			{
				object obj = this.ViewState["ApplyWildCard"];				
				return obj == null ? false : (bool)obj;
			}
			set
			{
				this.ViewState["ApplyWildCard"] = value;
			}
		}

		/// <summary>
		/// Indica se a propriedade Value devolve Null no caso do Texto serem espaços
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
		/// Implementação da propriedade Value
		/// </summary>
		new public string Value
		{
			get
			{
				if (this.TrimToNull)
				{
					if (base.Value.ToString().Trim() == string.Empty)
					{
						return Configuration.NullValueString;
					}
				}
				
				if (base.Value != null && this.ApplyWildCard)	
				{
					//ex. replace  '%' by '<forcexhar>'
					string aux = base.Value.ToString().Replace(this.WildCardHidden.ToString(), "<forcechar>");				
					//ex. replace  '*' by '%'
					aux = aux.Replace(this.WildCardVisible,this.WildCardHidden);
					//ex. replace  '<forcechar>' by '[%]'
					aux = aux.Replace("<forcechar>","[" + this.WildCardHidden.ToString() + "]");

					//Result: ex. replace '*todas as taxas de juro assima de 5% e mais qualquer coisa *' by
					//			  '%todas as taxas de juro assima de 5[%] e mais qualquer coisa %'
					return aux;				
				}
				else
					return base.Value.ToString();
			}
			set
			{
				if (value!= null && this.ApplyWildCard)		
				{
					//ex. replace  '[%]' by '<forcexhar>'
					string aux = value.Replace("[" + this.WildCardHidden.ToString() + "]", "<forcechar>");
					//ex. replace  '%' by '*'
					aux = aux.Replace(this.WildCardHidden,this.WildCardVisible);
					//ex. replace '<forcechar>' by '%'
					aux = aux.Replace("<forcechar>",this.WildCardHidden.ToString());

					//Result: ex. replace '%todas as taxas de juro assima de 5[%] e mais qualquer coisa %' by
					//					  '*todas as taxas de juro assima de 5% e mais qualquer coisa *'					
					base.Value = aux;
				}
				else
					base.Value = value;
				
			}
		}

		/// <summary>
		/// Implementação da propriedade Text
		/// </summary>
		new public string Text
		{
			get
			{
			
				if (base.Text !=null && this.ApplyWildCard)			
				{
					//ex. replace  '%' by '<forcexhar>'
					string aux = base.Text.Replace(this.WildCardHidden.ToString(), "<forcechar>");				
					//ex. replace  '*' by '%'
					aux = aux.Replace(this.WildCardVisible,this.WildCardHidden);
					//ex. replace  '<forcechar>' by '[%]'
					aux = aux.Replace("<forcechar>","[" + this.WildCardHidden.ToString() + "]");

					//Result: ex. replace '*todas as taxas de juro assima de 5% e mais qualquer coisa *' by
					//			  '%todas as taxas de juro assima de 5[%] e mais qualquer coisa %'
					return aux;
				}
				else
					return base.Text;
			}
			set
			{
				if (value !=null && this.ApplyWildCard)	
				{

					//ex. replace  '[%]' by '<forcexhar>'
					string aux = value.Replace("[" + this.WildCardHidden.ToString() + "]", "<forcechar>");
					//ex. replace  '%' by '*'
					aux = aux.Replace(this.WildCardHidden,this.WildCardVisible);
					//ex. replace '<forcechar>' by '%'
					aux = aux.Replace("<forcechar>",this.WildCardHidden.ToString());

					//Result: ex. replace '%todas as taxas de juro assima de 5[%] e mais qualquer coisa %' by
					//					  '*todas as taxas de juro assima de 5% e mais qualquer coisa *'					
					base.Text = aux;
				}
				else
					base.Text = value;
			}
		
		}
		/// <summary>
		/// Implementação do método render
		/// </summary>
		/// <param name="output"></param>
		protected override void  Render(HtmlTextWriter output)
		{
			if (base.ReadOnly)
			{
				base.CssClass = "OWTextBoxReadOnly";
			}			
			else
			{
				base.CssClass = "OWTextBox";
			}

			base.Render(output);
		}
	}
}
