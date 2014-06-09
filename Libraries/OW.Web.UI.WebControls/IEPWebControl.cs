namespace OW.Web.UI.WebControls
{
	/// <summary>
	/// Summary description for IEPWebControl.
	/// </summary>
	public interface IEPWebControl
	{

		/// <summary>
		/// Indica se o controlo está no estado de visualização
		/// </summary>
		bool ReadOnly
		{
			get;
			set;
		}
	
		/// <summary>
		/// Limpa o conteúdo do campo
		/// </summary>
		void ClearData();
	}
}
