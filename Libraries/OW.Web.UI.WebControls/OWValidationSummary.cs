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
		/// Método: Permite a inserção de mensagens de erro directamente no objecto
		/// </summary>
		/// <param>
		/// Mensagem de erro
		/// </param>
		public void AddErrorMessage(string msg) 
		{
			this.Page.Validators.Add(new DummyValidator(msg));
		}

		/// <summary>
		/// Implementação do método Render
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
	/// O controlo validation Summary faz a iteração sobre a colecção de 
	/// objectos Page.Validators e mostra a mensagem configurada na propriedade 
	/// ErrorMessage de cada validator que tenha a propriedade IsValid = False.
	/// Esta classe vai actuar como se fosse um validator, sendo que terá sempre
	/// a propriedade IsValid = False. Assim será sempre mostrada a mensagem de erro.
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
		
		//Apesar de nao ter qq implementação temos de defenir o 
		//método Validate() para respeitarmos as regras do interface.
		public void Validate(){}
	}

}
