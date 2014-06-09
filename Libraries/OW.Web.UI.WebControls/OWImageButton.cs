using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace OW.Web.UI.WebControls
{
	/// <summary>
	/// Summary description for EPButton.
	/// </summary>
	public class OWImageButton : ImageButton
	{
		/// <summary>
		/// Propriedade: ID dos validators a ignorar quando é premido este botão
		/// </summary>
		/// <remarks>
		/// IMPORTANTE: No caso de haver mais do que um validator a ser ignorado é REGRA que o separador
		/// usado para separar os ID´s dos mesmos seja uma virgula
		/// EXEMPLO: reqvalidator1, comparevalidator1, regexpressionvalidator3
		/// </remarks>
		public string EPValidatorsToIgnore
		{
			get
			{
				return _ValidatorsToIgnore;
			}
			set
			{
				_ValidatorsToIgnore = value;
			}
		}

		//Propriedades privadas
		protected string _ValidatorsToIgnore = String.Empty;
		protected string[] validators;

		//Evento do click
		protected override void OnClick(ImageClickEventArgs e)
		{
			DisableServerSideValidation(validators);
			base.OnClick (e);
		}

		protected override void CreateChildControls()
		{
			//Vamos enviar para o cliente o script necessário
			if (!base.Page.IsStartupScriptRegistered ("OWWebControlsJs"))
			{
				//base.Page.RegisterStartupScript ("OWWebControlsJs","<script language=\"JavaScript\" src=\"\\aspnet_client\\OWWebControls\\BaseScript.js\"></script>");

				string sclientScript = string.Empty;
				sclientScript += "<script language='javascript' type='text/javascript'>";
				sclientScript += "function TurnOnValidators()";
				sclientScript += "{";
				sclientScript += "if (Page_Validators != undefined)";
				sclientScript += "{";
				sclientScript += "for (i = 0; i < Page_Validators.length; i++)";
				sclientScript += "{";
				sclientScript += "ValidatorEnable(Page_Validators[i], true);";
				sclientScript += "}";
				sclientScript += "}";
				sclientScript += "}";
				sclientScript += "</script>";
				base.Page.RegisterStartupScript("OWWebControlsJs", sclientScript);
			}
			base.CreateChildControls ();
		}

		protected override void Render(HtmlTextWriter output)
		{	
			try
			{
				//No caso de haver validation...
				//E havendo informação dos validators a evitar
				if ((base.CausesValidation)&&(_ValidatorsToIgnore!=String.Empty))
				{					
					//No caso de haver controls passados vamos dizer que esses
					//não sao validados.
					validators = _ValidatorsToIgnore.Split(new char[]{','});
					if (!(validators[0].Trim() == String.Empty))
					{
						this.Attributes.Add("onclick","javascript:TurnOffValidators" + this.UniqueID + "(); if (typeof(Page_ClientValidate) == 'function') Page_ClientValidate();");
						//Render da função para desligar os respectivos validators
						output.WriteLine("<script language=\"javascript\">");
						output.WriteLine("function TurnOffValidators" + this.UniqueID + "()");
						output.WriteLine("{");
						output.WriteLine("TurnOnValidators();");
						for(int i = 0; i < validators.Length; i++)
						{
							output.WriteLine("ValidatorEnable(" + validators[i].ToString().Trim() + ", false);");
						}
						//Os restantes são ligados!
						output.WriteLine("for (i = 0; i < Page_Validators.length; i++)");
						output.WriteLine("{");
						output.WriteLine("if(Page_Validators[i].enabled!=false)");
						output.WriteLine("{");
						output.WriteLine("ValidatorEnable(Page_Validators[i], true);");
						output.WriteLine("}");
						output.WriteLine("}");
						output.WriteLine("}");
						output.WriteLine("</script>");
					}
				}
				else if (base.CausesValidation)
				{
					//E não havendo informação dos validators a evitar...

					//Caso seja previsto haver validação dos controls e não seja passado 
					//nenhum control na propriedade EPValidatorsToIgnore, ligamos todos
					//os validators da página.
					if (!Page.IsPostBack)
					{
						this.Attributes.Add("onclick","javascript:TurnOnValidators(); if (typeof(Page_ClientValidate) == 'function') Page_ClientValidate();");
					}
				}
			}
			catch //(System.Exception ex)
			{
				//output.WriteLine(ex.Message);
			}
			finally
			{
				base.CssClass = "OWImageButton";
				base.Render(output);
			}
		}

		protected void DisableServerSideValidation(string[] astrList)
		{
			try
			{
				Control ctrlValidator = new Control();
				for (int i = 0; i<astrList.Length;i++)
				{
					ctrlValidator = FindControl(astrList[i].ToString());
					if (ctrlValidator!=null)
					{
						switch(ctrlValidator.GetType().ToString().ToUpper())
						{
							case "SYSTEM.WEB.UI.WEBCONTROLS.REGULAREXPRESSIONVALIDATOR":
								((RegularExpressionValidator)ctrlValidator).IsValid = true;
								break;
							case "SYSTEM.WEB.UI.WEBCONTROLS.REQUIREDFIELDVALIDATOR":
								((RequiredFieldValidator)ctrlValidator).IsValid = true;
								break;
							case "SYSTEM.WEB.UI.WEBCONTROLS.RANGEVALIDATOR":
								((RangeValidator)ctrlValidator).IsValid = true;
								break;
							case "SYSTEM.WEB.UI.WEBCONTROLS.COMPAREVALIDATOR":
								((CompareValidator)ctrlValidator).IsValid = true;
								break;
							case "SYSTEM.WEB.UI.WEBCONTROLS.CUSTOMVALIDATOR":
								((CustomValidator)ctrlValidator).IsValid = true;
								break;
							default:
								break;
						}
					}
				}
			}
			catch{}
		}
	}
}
