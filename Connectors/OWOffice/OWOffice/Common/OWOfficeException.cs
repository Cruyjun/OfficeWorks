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
					this._Message = "Template '" + AuxString + "' n�o definido no ficheiro de configura��o.";
					break;
				}
				case enumExceptionsID.BookNotFOUND:
				{
					this.HResult = (int)enumExceptionsID.BookNotFOUND;
					this._Message = "O Template '" + AuxString + "' n�o tem o livro configurado.";
					break;
				}
				case enumExceptionsID.ServiceNotFOUND:
				{
					this.HResult = (int)enumExceptionsID.ServiceNotFOUND;
					this._Message = "Servi�o Web OfficeWorks inexistente ou mal configurado no seguinte endere�o:\n\r ('" + AuxString + "')";
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
					this._Message = "Ficheiro de configura��o '" + AuxString + "' inv�lido.";
					break;
				}
				case enumExceptionsID.MissingConfigurationFilePath:
				{
					this.HResult = (int)enumExceptionsID.MissingConfigurationFilePath;
					this._Message = "Propriedade 'ConfigurationFilePath' inv�lida. � necess�rio atribuir um caminho v�lido para o ficheiro de configura��o antes de executar esta opera��o.";
					break;
				}
				case enumExceptionsID.RequiredFields:
				{
					this.HResult = (int)enumExceptionsID.RequiredFields;
					this._Message = "Os seguintes campos OfficeWorks s�o obrigat�rios :" + AuxString;
					break;
				}
				case enumExceptionsID.FileNotFOUND:
				{
					this.HResult = (int)enumExceptionsID.FileNotFOUND;
					this._Message = "O seguinte ficheiro n�o existe: '" + AuxString + "'";
					break;
				}
				case enumExceptionsID.TypeERROR:
				{
					this.HResult = (int)enumExceptionsID.TypeERROR;
					this._Message = "Tipo de valor n�o suportado pela seguinte bookmark: '" + AuxString + "'";
					break;
				}
				case enumExceptionsID.MissingInsertMethod:
				{
					this.HResult = (int)enumExceptionsID.MissingInsertMethod;
					this._Message = "Tem de inserir primeiro o registo. N�o existe nada para modificar.";
					break;
				}

			}

		}
		#endregion
	}
	#endregion
}
