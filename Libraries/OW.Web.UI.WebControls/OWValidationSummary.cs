using System.Web.UI;
using System.Web.UI.WebControls;

namespace OW.Web.UI.WebControls
{
	/// <summary>
	/// Controlo Validation Summary (Inherited)
	/// </summary>
	public class OWValidationSummary : ValidationSummary
	{
		/// <summary>
		/// M�todo: Permite a inser��o de mensagens de erro directamente no objecto
		/// </summary>
		/// <param>
		/// Mensagem de erro
		/// </param>
		public void AddErrorMessage(string msg) 
		{
			this.Page.Validators.Add(new DummyValidator(msg));
		}

		/// <summary>
		/// Implementa��o do m�todo Render
		/// </summary>
		/// <param name="writer"></param>
		protected override void Render(HtmlTextWriter writer)
		{
			this.CssClass = "OWValidationSummary";

			//--------------------------------------------------------------------
			// Quando o Rato sai do controlo
			//--------------------------------------------------------------------
			this.Attributes.Add("onmousedown", "this.className='OWValidationSummaryMouseOver';");
			this.Attributes.Add("onmouseup", "this.className='OWValidationSummary';");
			this.Attributes.Add("ondblclick", "this.className='OWValidationSummaryMouseOver';");

			base.Render (writer);
		}

	}

	/// <summary>
	/// Classe: DummyValidator
	/// </summary>
	/// <remarks>
	/// O controlo validation Summary faz a itera��o sobre a colec��o de 
	/// objectos Page.Validators e mostra a mensagem configurada na propriedade 
	/// ErrorMessage de cada validator que tenha a propriedade IsValid = False.
	/// Esta classe vai actuar como se fosse um validator, sendo que ter� sempre
	/// a propriedade IsValid = False. Assim ser� sempre mostrada a mensagem de erro.
	/// </remarks>
	internal class DummyValidator : IValidator 
	{
		private string errorMsg;

		public DummyValidator(string msg) 
		{
			errorMsg = msg;
		}

		public string ErrorMessage
		{
			get
			{ 
				return errorMsg;
			}
			set
			{ 
				errorMsg = value;
			}
		}

		public bool IsValid
		{
			get
			{
				return false;
			}
			set
			{
			}
		}
		
		//Apesar de nao ter qq implementa��o temos de defenir o 
		//m�todo Validate() para respeitarmos as regras do interface.
		public void Validate(){}
	}

}
