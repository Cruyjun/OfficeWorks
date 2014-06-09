using System;

namespace OfficeWorks.OWOffice.Common
{
	#region OWOfficeException internal Class
	internal class OWOfficeException : Exception 
	{
		#region DECLARATIONS
		public enum enumExceptionsID :int 
		{
			GenericMenssage = -1,

			TemplateNotFOUND = -2,

			BookNotFOUND = -3,

			ServiceNotFOUND = -4,

			LoginERROR = -5,

			ConfigurationFileERROR = -6,

			MissingConfigurationFilePath = -7,

			RequiredFields = -8,

			FileNotFOUND = -9,

			TypeERROR = -10,

			MissingInsertMethod = -11
		}
		#endregion

		#region CONSTRUCTORS
		public OWOfficeException(enumExceptionsID ExceptionID) 
		{
			SwitchMsg(ExceptionID, null);
		}

		public OWOfficeException(enumExceptionsID ExceptionID, string AuxString) 
		{
			SwitchMsg(ExceptionID, AuxString);
		}
		#endregion

		#region PROPERTIES
		private string _Message = "";
		public override string Message 
		{
			get { return _Message; }
		}
		#endregion

		#region METHODS
		private void SwitchMsg(enumExceptionsID ExceptionID, string AuxString) 
		{
			switch(ExceptionID) 
			{
				case enumExceptionsID.GenericMenssage:
				{
					this.HResult = (int)enumExceptionsID.GenericMenssage;
					this._Message = AuxString;
					break;
				}
				case enumExceptionsID.TemplateNotFOUND:
				{
					this.HResult = (int)enumExceptionsID.TemplateNotFOUND;
					this._Message = "Template '" + AuxString + "' não definido no ficheiro de configuração.";
					break;
				}
				case enumExceptionsID.BookNotFOUND:
				{
					this.HResult = (int)enumExceptionsID.BookNotFOUND;
					this._Message = "O Template '" + AuxString + "' não tem o livro configurado.";
					break;
				}
				case enumExceptionsID.ServiceNotFOUND:
				{
					this.HResult = (int)enumExceptionsID.ServiceNotFOUND;
					this._Message = "Serviço Web OfficeWorks inexistente ou mal configurado no seguinte endereço:\n\r ('" + AuxString + "')";
					break;
				}
				case enumExceptionsID.LoginERROR:
				{
					this.HResult = (int)enumExceptionsID.LoginERROR;
					this._Message = "Erro a obter o Login do utilizador";
					break;
				}
				case enumExceptionsID.ConfigurationFileERROR:
				{
					this.HResult = (int)enumExceptionsID.ConfigurationFileERROR;
					this._Message = "Ficheiro de configuração '" + AuxString + "' inválido.";
					break;
				}
				case enumExceptionsID.MissingConfigurationFilePath:
				{
					this.HResult = (int)enumExceptionsID.MissingConfigurationFilePath;
					this._Message = "Propriedade 'ConfigurationFilePath' inválida. É necessário atribuir um caminho válido para o ficheiro de configuração antes de executar esta operação.";
					break;
				}
				case enumExceptionsID.RequiredFields:
				{
					this.HResult = (int)enumExceptionsID.RequiredFields;
					this._Message = "Os seguintes campos OfficeWorks são obrigatórios :" + AuxString;
					break;
				}
				case enumExceptionsID.FileNotFOUND:
				{
					this.HResult = (int)enumExceptionsID.FileNotFOUND;
					this._Message = "O seguinte ficheiro não existe: '" + AuxString + "'";
					break;
				}
				case enumExceptionsID.TypeERROR:
				{
					this.HResult = (int)enumExceptionsID.TypeERROR;
					this._Message = "Tipo de valor não suportado pela seguinte bookmark: '" + AuxString + "'";
					break;
				}
				case enumExceptionsID.MissingInsertMethod:
				{
					this.HResult = (int)enumExceptionsID.MissingInsertMethod;
					this._Message = "Tem de inserir primeiro o registo. Não existe nada para modificar.";
					break;
				}

			}

		}
		#endregion
	}
	#endregion
}
