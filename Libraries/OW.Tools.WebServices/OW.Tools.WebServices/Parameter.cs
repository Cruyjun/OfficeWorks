using System;
using System.Reflection;

namespace OW.Tools.WebServices
{
	/// <summary>
	/// Colecção de Parameters
	/// </summary>
	[Serializable]public class Parameter 
	{
		#region Fields
		/// <summary>
		/// Parameter Info
		/// </summary>
		private ParameterInfo parameterInfo;

		/// <summary>
		/// Valor do parâmetro
		/// </summary>
		private object parameterValue;

		#endregion

		#region Properties
		
		/// <summary>
		/// Get or Set Parameter Info
		/// </summary>
		public ParameterInfo ParameterInfo
		{
			get{return parameterInfo;}
			set{parameterInfo = value;}
		}

		/// <summary>
		/// Get or Set ParameterValue
		/// </summary>
		public object ParameterValue
		{
			get{return parameterValue;}
			set{parameterValue = value;}
		}

		#endregion

		#region Constructors

		/// <summary>
		/// Parameter  Constructor
		/// </summary>
		public Parameter(ParameterInfo pinfo, object pvalue)
		{
			// set parameterInfo
			this.parameterInfo = pinfo;

			// set parameterValue
			this.parameterValue = pvalue;
		}


		#endregion
	}
}

