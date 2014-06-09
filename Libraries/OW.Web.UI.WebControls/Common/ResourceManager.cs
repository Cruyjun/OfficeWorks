using System;
using System.Configuration;
using System.Globalization;
using System.IO;
using System.Resources;
using System.Web;

namespace OW.Web.UI.WebControls
{
	/// <summary>
	/// Classe estática para suporte multilingue.
	/// </summary>
	internal class ResX
	{
		#region Fields

		/// <summary>
		/// Safe lock singleton class.
		/// </summary>
		private static ResourceManager _instance;

		#endregion

		#region Public Methods

		/// <summary>
		/// Get Resource String
		/// </summary>
		/// <param name="name"></param>
		/// <returns></returns>
		public static string GetResourceString(string name) 
		{
			try 
			{
				// Current Culture
				_instance = new ResourceManager(String.Format("OW.Web.UI.WebControls.Resources.{0}", CultureInfo.CurrentCulture), typeof(ResX).Assembly);
				return (_instance.GetString(name) == null ? name : _instance.GetString(name));
			}
			catch (Exception) 
			{
				try 
				{
					// Neutral Culture
					_instance = new ResourceManager("OW.Web.UI.WebControls.Resources.Resource", typeof(ResX).Assembly);
					return (_instance.GetString(name) == null ? name : _instance.GetString(name));
				}
				catch (Exception) 
				{
					return "Upss..., resource not found!";
				}
			}
		}

		/// <summary>
		/// Returns the value of the specified <see cref="T:System.String"></see> resource.
		/// </summary>
		/// <param name="name">The name of the resource to get.</param>
		/// <param name="args">An <see cref="T:System.Object"></see> array containing zero or more objects to format. </param>
		/// <returns></returns>
		public static string GetResourceString(string name, params object[] args) 
		{
			try 
			{
				_instance = new ResourceManager(String.Format("OW.Web.UI.WebControls.Resources.{0}", CultureInfo.CurrentCulture), typeof(ResX).Assembly);				
				return (String.Format(_instance.GetString(name), args) == null ? name : String.Format(_instance.GetString(name), args));
			}
			catch (Exception) 
			{
				try 
				{
					// Neutral Culture
					_instance = new ResourceManager("OW.Web.UI.WebControls.Resources.Resource", typeof(ResX).Assembly);
					return (String.Format(_instance.GetString(name), args) == null ? name : String.Format(_instance.GetString(name), args));
				}
				catch (Exception) 
				{
					return "Upss..., resource not found!";
				}
			}
		}

		/// <summary>
		/// Get a resource string from its key
		/// </summary>
		/// <param name="Key">Key in resource file</param>
		/// <returns>String associated to the key</returns>
		public static string GetString(string Key)
		{			
			ResourceManager RM = OpenResources();
			string 	ResourceString = (RM.GetString (Key) == null ? Key : RM.GetString (Key));
			CloseResources(RM);
			return ResourceString;
		}

		/// <summary>
		/// Get a resource string from its key
		/// </summary>
		/// <param name="Key">Key in resource file</param>
		/// <param name="args">An <see cref="T:System.Object"></see> array containing zero or more objects to format. </param>
		/// <returns>String associated to the key</returns>
		public static string GetString(string Key, params object[] args)
		{			
			ResourceManager RM = OpenResources();
			string ResourceString = (RM.GetString (Key) == null ? Key : RM.GetString (Key));
			CloseResources(RM);

			return (String.Format(ResourceString, args) == null ? Key : String.Format(ResourceString, args));
		}

		/// <summary>
		/// Get Selected Culture
		/// </summary>
		/// <returns>Returns Selected Culture</returns>
		public static string GetSelectedCulture()
		{
			string globalizationMode = ConfigurationSettings.AppSettings["globalizationMode"].ToUpper();
			string[] userLanguages = HttpContext.Current.Request.UserLanguages;
			string defaultCulture = ConfigurationSettings.AppSettings["defaultCulture"];
			string selectedCulture = "";
			
			switch (globalizationMode)
			{
				case "CLIENT":
				{
					for (int i = 0; i < userLanguages.Length; i++)
					{
						if (userLanguages[i].IndexOf(";") == -1)
						{
							selectedCulture = userLanguages[i].Substring(0, 2);
							switch (selectedCulture.Trim().ToLower())
							{
								case "pt":
									selectedCulture = "pt-PT";
									break;
								case "en":
									selectedCulture = "en";
									break;
								case "es":
									selectedCulture = "es-ES";
									break;
								default:
									selectedCulture = userLanguages[i];
									break;

							}
						}
						else
						{
							selectedCulture = userLanguages[i].Substring(0, userLanguages[i].IndexOf(";"));
							switch (selectedCulture.Trim().ToLower())
							{
								case "pt":
									selectedCulture = "pt-PT";
									break;
								case "en":
									selectedCulture = "en";
									break;
								case "es":
									selectedCulture = "es-ES";
									break;
								default:
									selectedCulture = userLanguages[i];
									break;

							}
						}
						
						if (selectedCulture != "")
							break;
					}
					break;
				}
				case "SERVER":
				{
					selectedCulture = defaultCulture;
					break;
				}
				default:
				{
					break;
				}
			}

			return selectedCulture;
		}

		#endregion 

		#region Private Methods

		/// <summary>
		/// Open the resource file for the default culture
		/// </summary>
		/// <returns>Returns a ResourceManager instance</returns>
		private static ResourceManager OpenResources()
		{
			string globalizationMode = ConfigurationSettings.AppSettings["globalizationMode"].ToUpper();
			string[] userLanguages = HttpContext.Current.Request.UserLanguages;
			string currentPath = HttpContext.Current.Request.PhysicalApplicationPath;
			string defaultPath = ConfigurationSettings.AppSettings["defaultPath"];
			string defaultCulture = ConfigurationSettings.AppSettings["defaultCulture"];
			
			string selectedCulture;
			
			switch (globalizationMode)
			{
				case "CLIENT":
				{
					for (int i = 0; i < userLanguages.Length; i++)
					{
						if (userLanguages[i].IndexOf(";") == -1)
						{
							selectedCulture = userLanguages[i].Substring(0, 2);
							switch (selectedCulture.ToLower())
							{
								case "pt":
									selectedCulture = "pt-PT";
									break;
								case "en":
									selectedCulture = "en";
									break;
								case "es":
									selectedCulture = "es-ES";
									break;
								default:
									selectedCulture = userLanguages[i];
									break;

							}
						}
						else
						{
							selectedCulture = userLanguages[i].Substring(0, userLanguages[i].IndexOf(";"));
							switch (selectedCulture.ToLower())
							{
								case "pt":
									selectedCulture = "pt-PT";
									break;
								case "en":
									selectedCulture = "en";
									break;
								case "es":
									selectedCulture = "es-ES";
									break;
								default:
									selectedCulture = userLanguages[i];
									break;

							}
						}
						
						if (new DirectoryInfo(currentPath  + defaultPath + "\\" + selectedCulture).Exists)
						{
							_instance = OpenResources(selectedCulture);
						}

						if (_instance != null)
						{
							break;
						}
					}

					if (_instance == null)
					{
						_instance = OpenResources(defaultCulture);
					}
					
					break;
				}
				case "SERVER":
				{
					_instance = OpenResources(defaultCulture);
					
					break;
				}
				default:
				{
					break;
				}
			}

			return _instance;
		}

		/// <summary>
		/// Open the resource file for the specified culture
		/// </summary>
		/// <param name="selectedCulture"> The language to select</param>
		/// <returns>Returns a ResourceManager instance</returns>
		private static ResourceManager OpenResources(string selectedCulture)
		{
			return openResources(selectedCulture);
		}

		/// <summary>
		/// Open the resource file for the specified culture
		/// </summary>
		/// <param name="selectedCulture"></param>
		/// <returns></returns>
		private static ResourceManager openResources(string selectedCulture)
		{
			return new ResourceManager(String.Format("OW.Web.UI.WebControls.Resources.{0}", CultureInfo.CreateSpecificCulture(selectedCulture)), typeof(ResX).Assembly);
		}
		
		/// <summary>
		/// Close the resource file
		/// </summary>
		/// <param name="resourceManager"></param>
		private static void CloseResources(ResourceManager resourceManager)
		{
			resourceManager.ReleaseAllResources();
		}

		#endregion
	}
}