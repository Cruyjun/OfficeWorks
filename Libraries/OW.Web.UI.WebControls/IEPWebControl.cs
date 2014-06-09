namespace OW.Web.UI.WebControls
{
	/// <summary>
	/// Summary description for IEPWebControl.
	/// </summary>
	public interface IEPWebControl
	{

		/// <summary>
		/// Indica se o controlo est� no estado de visualiza��o
		/// </summary>
		bool ReadOnly
		{
			get;
			set;
		}
	
		/// <summary>
		/// Limpa o conte�do do campo
		/// </summary>
		void ClearData();
	}
}
