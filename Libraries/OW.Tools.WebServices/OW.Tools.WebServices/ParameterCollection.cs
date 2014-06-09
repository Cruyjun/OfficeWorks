using System;
using System.Collections;
using System.Reflection;

namespace OW.Tools.WebServices
{
	/// <summary>
	/// Colec��o de Par�metros
	/// </summary>
	[Serializable]public class ParameterCollection: CollectionBase
	{
		#region Constructor

		/// <summary>
		/// Class Constructor
		/// </summary>
		public ParameterCollection(){}

		#endregion

		#region Methods
		/// <summary>
		/// Implementa��o do metodo Add
		/// </summary>
		/// <param name="newItem">
		/// Objecto do tipo Parameter
		/// </param>
		public void Add(Parameter newItem)
		{
			this.List.Add(newItem);
		}

		/// <summary>
		/// Create and Add a parameter to collection
		/// </summary>
		/// <param name="parameterInfo">Parameter Name</param>
		/// <param name="parameterVaue">Parameter Value</param>
		public void Add(ParameterInfo parameterInfo, object parameterVaue)
		{
			this.List.Add(new Parameter(parameterInfo, parameterVaue));
		}

		/// <summary>
		/// Implementa��o do metodo Insert
		/// </summary>
		/// <param name="index">
		/// ind�ce onde se quer inserir o item
		/// </param>
		/// <param name="newItem">
		/// Objecto do tipo Parameter
		/// </param>
		public void Insert(int index, Parameter newItem)
		{
			this.List.Insert(index, newItem);
		}

		/// <summary>
		/// Implementa��o do m�todo Remove
		/// </summary>
		/// <param name="index">
		/// Inteiro que referencia o indice do objecto a remover na colec��o.
		/// </param>
		public void Remove(int index)
		{
			this.List.RemoveAt(index);
		}

		#endregion

		#region Properties
		
		/// <summary>
		/// Collection Indexer
		/// </summary>
		public Parameter this[int Index]
		{
			get
			{
				return (Parameter) this.List[Index];
			}
			set
			{	
				this.List[Index] = value;
			}
		}

		#endregion
	}
}

