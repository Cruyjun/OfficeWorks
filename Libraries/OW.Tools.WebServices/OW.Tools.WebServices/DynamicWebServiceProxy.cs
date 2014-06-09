using System;
using System.CodeDom;
using System.CodeDom.Compiler;
using System.Collections;
using System.Globalization;
using System.IO;
using System.Net;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using System.Web.Services.Description;
using System.Web.Services.Discovery;
using System.Web.Services.Protocols;
using System.Xml;
using System.Xml.Schema;
using Microsoft.CSharp;

// DynamicWebServiceProxy - This sample is provided as is!
// Please notice that this code is only a technology demo
// and should not be included unedited und untested into any serious project.
// -------------------------------------------------------------------------------------
// The usage of the library is shown in the WSLibTester project in the same download file.
//
// (C) Christian Weyer, 2002-2003. All rights reserved.

namespace OW.Tools.WebServices
{
	public enum ProtocolEnum
	{
		HttpGet,
		HttpPost,
		HttpSoap
	}

	public class DynamicWebServiceProxy
	{
		#region Fields
		
		private Assembly ass = null;
		private object proxyInstance = null;
		private string wsdl;
		private string wsdlSource;
		private string typeName;
		private string methodName;
		private string protocolName = "Soap";
		private ArrayList methodParams = new ArrayList();
		private string proxySource;
		private ServiceDescriptionImporter sdi;
		
		#endregion

		#region Constructors

		public DynamicWebServiceProxy()
		{
		}

		public DynamicWebServiceProxy(string wsdlLocation)
		{
			wsdl = wsdlLocation;
			BuildProxy();
		}
		
		public DynamicWebServiceProxy(string wsdlLocation, string inTypeName)
		{
			wsdl = wsdlLocation;
			typeName = inTypeName;
			BuildProxy();
		}

		public DynamicWebServiceProxy(string wsdlLocation, string inTypeName, string inMethodName)
		{
			wsdl = wsdlLocation;
			typeName = inTypeName;
			methodName = inMethodName;
			BuildProxy();
		}

		public DynamicWebServiceProxy(string wsdlLocation, string inTypeName, string inMethodName, params object[] inMethodParams)
		{
			wsdl = wsdlLocation;
			typeName = inTypeName;
			methodName = inMethodName;
			methodParams = null;
			methodParams = new ArrayList(inMethodParams);
			BuildProxy();
		}

		#endregion

		#region Properties
	
		public string Url
		{
			get
			{
				PropertyInfo propInfo = proxyInstance.GetType().GetProperty("Url");
				object result = propInfo.GetValue(proxyInstance, null);
				
				return (string)result;
			}
			set
			{
				PropertyInfo propInfo = proxyInstance.GetType().GetProperty("Url");
				propInfo.SetValue(proxyInstance, value,
					BindingFlags.NonPublic | BindingFlags.Static |
					BindingFlags.Instance | BindingFlags.Public | BindingFlags.SetField,
					null, null, null
					);
			}
		}


		// TODO: move the init process to an explicit method Init() ...
		public string WSDL
		{
			get
			{
				return wsdl;
			}
			set
			{
				if (!value.ToLower().EndsWith(".asmx?wsdl"))
					value += "?wsdl";
				wsdl = value;
				ResetInternalState();
				BuildProxy();
			}
		}

		public string TypeName
		{
			get
			{
				return typeName;
			}
			set
			{
				typeName = value;
			}
		}

		public string MethodName
		{
			get
			{
				return methodName;
			}
			set
			{
				methodName = value;
			}
		}

		public ProtocolEnum ProtocolName
		{
			get
			{
				switch(protocolName)
				{
					case "HttpGet":
						return ProtocolEnum.HttpGet;
					case "HttpPost":
						return ProtocolEnum.HttpPost;
					case "Soap":
						return ProtocolEnum.HttpSoap;
					default:
						return ProtocolEnum.HttpSoap;
				}
			}
			set
			{
				switch(value)
				{
					case ProtocolEnum.HttpGet:
						protocolName = "HttpGet";
						break;
					case ProtocolEnum.HttpPost:
						protocolName = "HttpPost";
						break;
					case ProtocolEnum.HttpSoap:
						protocolName = "Soap";
						break;
				}
			}
		}

		public Assembly ProxyAssembly
		{
			get
			{
				return ass;
			}
		}

		/// <summary>
		/// Gets or sets the credentials.
		/// </summary>
		/// <value></value>
		public ICredentials Credentials
		{
			set
			{
				PropertyInfo propInfo = proxyInstance.GetType().GetProperty("Credentials");
				propInfo.SetValue(proxyInstance, value, null);
			}

			get
			{
				PropertyInfo propInfo = proxyInstance.GetType().GetProperty("Credentials");
				ICredentials result = (ICredentials)propInfo.GetValue(proxyInstance, null);

				return result;
			}
		}

		#endregion

		#region Methods

		public void AddParameter(object param)
		{
			methodParams.Add(param);
		}

		public object InvokeCall()
		{
			try
			{
				MethodInfo mi = proxyInstance.GetType().GetMethod(methodName);
				object result = mi.Invoke(proxyInstance, (object[])methodParams.ToArray(typeof(object)));

				// clean up the original params array
				methodParams.Clear();
			
				return result;
			}
			catch(Exception e)
			{
				Console.WriteLine(e.Message);
				return null;
			}
		}

		public void ClearCache(string WSDL)
		{
			// clear the cached assembly file for this WSDL
			try
			{
				string path = Path.GetTempPath();
				string newFilename = path + GetMd5Sum(WSDL) + "_EP_tmp.dll";

				File.Delete(newFilename);
			}
			catch(Exception e)
			{
				e = e;
			}
		}

		private void GetWsdl(string source) 
		{
			// this could be a valid WSDL representation
			if(source.StartsWith("<?xml version") == true)
			{
				wsdlSource = source;
				return;	
			}
			// this is a URL to the WSDL
			else if(source.StartsWith("http://") == true)
			{
				wsdlSource = GetWsdlFromUri(source);
				return;
			}
							
			// try to get from local file system
			wsdlSource = GetWsdlFromFile(source);
			return;
		}
		
		private string GetWsdlFromUri(string uri)
		{
			WebRequest req = WebRequest.Create(uri);
			WebResponse result = req.GetResponse();
					
			Stream ReceiveStream = result.GetResponseStream();
			Encoding encode = Encoding.GetEncoding("utf-8");
			StreamReader sr = new StreamReader(ReceiveStream, encode);
					
			string wsdlSource = sr.ReadToEnd();
			sr.Close();
					
			return wsdlSource;
		}

		private string GetWsdlFromFile(string fileFullPathName)
		{
			FileInfo fi = new FileInfo(fileFullPathName);
					
			if(fi.Extension == "wsdl")
			{
				FileStream fs = new FileStream(fileFullPathName, FileMode.Open, FileAccess.Read);
				StreamReader sr = new StreamReader(fs);
							
				char[] buffer = new char[(int)fs.Length];
				sr.ReadBlock(buffer, 0, (int)fs.Length);
				sr.Close();
							
				return new string(buffer);
			}
				
			throw new Exception("This is not a WSDL file");
		}

		private Assembly BuildAssemblyFromWsdl(string strWsdl)
		{
			// Use an XmlTextReader to get the Web Service description
			StringReader  wsdlStringReader = new StringReader(strWsdl);
			XmlTextReader tr = new XmlTextReader(wsdlStringReader);
			ServiceDescription sd = ServiceDescription.Read(tr);
			tr.Close();

			// WSDL service description importer 
			CodeNamespace cns = new CodeNamespace("OW.Tools.WebServices.DynamicProxy");
			sdi = new ServiceDescriptionImporter();
			//sdi.AddServiceDescription(sd, null, null);
			
			// check for optional imports in the root WSDL
			CheckForImports(wsdl);

			sdi.ProtocolName = protocolName;
			sdi.Import(cns, null);

			// change the base class
			CodeTypeDeclaration ctDecl = cns.Types[0];
			cns.Types.Remove(ctDecl);
			ctDecl.BaseTypes[0] = new CodeTypeReference("OW.Tools.WebServices.SoapHttpClientProtocolEx");
			cns.Types.Add(ctDecl);

			// source code generation
			CSharpCodeProvider cscp = new CSharpCodeProvider();
			ICodeGenerator icg = cscp.CreateGenerator();
			StringBuilder srcStringBuilder = new StringBuilder();
			StringWriter sw = new StringWriter(srcStringBuilder);
			icg.GenerateCodeFromNamespace(cns, sw, null);
			proxySource = srcStringBuilder.ToString();
			sw.Close();

			// assembly compilation
			CompilerParameters cp = new CompilerParameters();
			cp.ReferencedAssemblies.Add("System.dll");
			cp.ReferencedAssemblies.Add("System.Xml.dll");
			cp.ReferencedAssemblies.Add("System.Web.Services.dll");
			cp.ReferencedAssemblies.Add("System.Data.dll");
			cp.ReferencedAssemblies.Add(Assembly.
				GetExecutingAssembly().Location);
	
			cp.GenerateExecutable = false;
			cp.GenerateInMemory = false;
			cp.IncludeDebugInformation = false; 

			ICodeCompiler icc = cscp.CreateCompiler();
			CompilerResults cr = icc.CompileAssemblyFromSource(cp, proxySource);
			
			if(cr.Errors.Count > 0)
				throw new Exception(string.Format(@"Build failed: {0} errors", cr.Errors.Count));

			ass = cr.CompiledAssembly;
			
			//rename temporary assembly in order to cache it for later use
			RenameTempAssembly(cr.PathToAssembly);
			 
			// create proxy instance
			proxyInstance = CreateInstance(typeName);
			
			return ass;
		}
		
		private object CreateInstance(string objTypeName) 
		{
			// check whether the type is already created or not
			if (objTypeName == "" || objTypeName == null)
			{
				foreach (Type ty in ProxyAssembly.GetTypes())
				{
					if(ty.BaseType == typeof(SoapHttpClientProtocolEx))
					{
						objTypeName = ty.Name;
						break;
					}
				}
			}
			Type t = ass.GetType("OW.Tools.WebServices.DynamicProxy." + objTypeName);
			
			return Activator.CreateInstance(t);
		}
		
		private void RenameTempAssembly(string pathToAssembly)
		{			
			string path = Path.GetDirectoryName(pathToAssembly);
			string newFilename = path + @"\" + GetMd5Sum(wsdl) + "_EP_tmp.dll";
			
			File.Copy(pathToAssembly, newFilename);
		}

		private void ResetInternalState()
		{
			typeName = "";
			methodName = "";
			protocolName = "Soap";
			methodParams.Clear();
			sdi = null;
		}

		private void BuildProxy()
		{
			// inject SOAP extensions in (client side) ASMX pipeline
			InjectExtension(typeof(SoapMessageAccessClientExtension));
			
			//check cache first
			if (!CheckCache())
			{
				GetWsdl(wsdl);
				BuildAssemblyFromWsdl(wsdlSource);
			}
		}

		private bool CheckCache()
		{
			string path = Path.GetTempPath() + GetMd5Sum(wsdl) + "_EP_tmp.dll";

			if(File.Exists(path))
			{
				ass = Assembly.LoadFrom(path);
				// create proxy instance
				proxyInstance = CreateInstance(typeName);

				return true;
			}
			
			return false;
		}
		
		private void CheckForImports(string baseWSDLUrl)
		{
			DiscoveryClientProtocol dcp = new DiscoveryClientProtocol();
			dcp.DiscoverAny(baseWSDLUrl);
			dcp.ResolveAll();

			foreach (object osd in dcp.Documents.Values)
			{
				if (osd is ServiceDescription) sdi.AddServiceDescription((ServiceDescription)osd, null, null);;
				if (osd is XmlSchema) sdi.Schemas.Add((XmlSchema)osd);
			}
		}

		static void InjectExtension(Type extension)
		{
			Assembly assBase;
			Type webServiceConfig;
			object currentProp;
			PropertyInfo propInfo;
			object[] value;
			Type myType;
			object[] objArray;
			object myObj;
			FieldInfo myField;

			try
			{
				assBase = typeof(SoapExtensionAttribute).Assembly;
				webServiceConfig =
					assBase.GetType("System.Web.Services.Configuration.WebServicesConfiguration");

				if (webServiceConfig == null)
					throw new Exception("Error ...");

				currentProp = webServiceConfig.GetProperty("Current",
					BindingFlags.NonPublic | BindingFlags.Static |
					BindingFlags.Instance | BindingFlags.Public
					).GetValue(null, null);
				propInfo = webServiceConfig.GetProperty("SoapExtensionTypes",
					BindingFlags.NonPublic | BindingFlags.Static |
					BindingFlags.Instance | BindingFlags.Public
					);
				value = (object[])propInfo.GetValue(currentProp, null);
				myType = value.GetType().GetElementType();
				objArray = (object[])Array.CreateInstance(myType, (int)value.Length + 1);
				Array.Copy(value, objArray, (int)value.Length);

				myObj = Activator.CreateInstance(myType);
				myField = myType.GetField("Type",
					BindingFlags.NonPublic | BindingFlags.Static |
					BindingFlags.Instance | BindingFlags.Public
					);
				myField.SetValue(myObj, extension,
					BindingFlags.NonPublic | BindingFlags.Static |
					BindingFlags.Instance | BindingFlags.Public | BindingFlags.SetField,
					null, null
					);
				objArray[(int)objArray.Length - 1] = myObj;
				propInfo.SetValue(currentProp, objArray,
					BindingFlags.NonPublic | BindingFlags.Static |
					BindingFlags.Instance | BindingFlags.Public | BindingFlags.SetProperty,
					null, null, null
					);
			}
			catch (Exception e)
			{
				e = e;
			}
		}

		private string GetMd5Sum(string str)
		{
			// First we need to convert the string into bytes, which
			// means using a text encoder
			Encoder enc = Encoding.Unicode.GetEncoder();

			// Create a buffer large enough to hold the string
			byte[] unicodeText = new byte[str.Length * 2];
			enc.GetBytes(str.ToCharArray(), 0, str.Length, unicodeText, 0, true);

			// Now that we have a byte array we can ask the CSP to hash it
			MD5 md5 = new MD5CryptoServiceProvider();
			byte[] result = md5.ComputeHash(unicodeText);

			// Build the final string by converting each byte
			// into hex and appending it to a StringBuilder
			StringBuilder sb = new StringBuilder();
			for (int i=0;i<result.Length;i++)
			{
				sb.Append(result[i].ToString("X2"));
			}

			return sb.ToString();
		}

		public string SoapRequest
		{
			get
			{
				PropertyInfo propInfo = proxyInstance.GetType().GetProperty("SoapRequest");
				object result = propInfo.GetValue(proxyInstance, null);
				UTF8Encoding enc = new UTF8Encoding();
				
				return enc.GetString((byte[])result);
			}
		}

		public string SoapResponse
		{
			get
			{
				PropertyInfo propInfo = proxyInstance.GetType().GetProperty("SoapResponse");
				object result = propInfo.GetValue(proxyInstance, null);
				UTF8Encoding enc = new UTF8Encoding();
				
				return enc.GetString((byte[])result);
			}
		}

		#endregion

		#region OWProcess

		/// <summary>
		/// Devolve um Arraylist com o nome dos métodos encontrados para o WebService
		/// </summary>
		/// <returns></returns>
		public ArrayList GetMethodNames()
		{
			//--------------------------------------------------------
			// Declaração de variáveis
			//--------------------------------------------------------
			ArrayList methodNames = new ArrayList();

			//--------------------------------------------------------
			// Carregamento dos tipos definidos na assembly
			//--------------------------------------------------------
			Type[] types = this.ProxyAssembly.GetTypes();

			Type theType = null;

			foreach (Type t in types)
			{
				if(t.BaseType == typeof(SoapHttpClientProtocolEx))
				{
					theType = t;
					break;
				}
			}
			
			//--------------------------------------------------------
			// Leitura dos métodos para o tipo pretendido			
			//--------------------------------------------------------
			MethodInfo[] mi = theType.GetMethods(BindingFlags.Public | BindingFlags.Instance | BindingFlags.DeclaredOnly);
			
			foreach (MethodInfo m in mi)
			{
				if (!(m.Name.StartsWith("Begin") || m.Name.StartsWith("End"))) methodNames.Add(m.Name);
			}

			//--------------------------------------------------------
			// Devolve os métodos encontrados
			//--------------------------------------------------------
			return methodNames;
		}

		/// <summary>
		/// Devolve uma collecção com o nome e o tipo dos parâmetros encontrados num método de um WebService
		/// </summary>
		/// <param name="methodName"></param>
		/// <returns></returns>
		public ParameterCollection GetParameters(string methodName)
		{
			//--------------------------------------------------------
			// Declaração de variáveis
			//--------------------------------------------------------
			ParameterCollection parameters = new ParameterCollection();

			//--------------------------------------------------------
			// Carregamento dos tipos definidos na assembly
			//--------------------------------------------------------
			Type[] types = this.ProxyAssembly.GetTypes();

			Type theType = null;

			foreach (Type t in types)
			{
				if(t.BaseType == typeof(SoapHttpClientProtocolEx))
				{
					theType = t;
					break;
				}
			}
			
			//---------------------------------------------------------------
			// Carregamento do método especificado no parâmetro			
			//---------------------------------------------------------------
			MethodInfo theMethod = theType.GetMethod(methodName,BindingFlags.Public | BindingFlags.Instance | BindingFlags.DeclaredOnly);

			//---------------------------------------------------------------
			// Devolve os parâmetros encontrados para o método especificado
			//---------------------------------------------------------------
			ParameterInfo[] pi = theMethod.GetParameters();

			foreach (ParameterInfo parameterInfo in pi)
			{
				parameters.Add(parameterInfo,null);
			}
		
			return parameters;
		}

		/// <summary>
		/// Devolve um Arraylist com o nome dos parâmetros encontrados num método de um WebService
		/// </summary>
		/// <param name="methodName"></param>
		/// <returns></returns>
		public ArrayList GetParametersName(string methodName)
		{
			ArrayList parameterNames = new ArrayList();

			ParameterCollection parameters = GetParameters(methodName);

			foreach(Parameter parameter in parameters)
			{
				parameterNames.Add(parameter.ParameterInfo.Name);
			}

			return parameterNames;
		}

		/// <summary>
		/// Devolve um Arraylist com o tipo dos parâmetros encontrados num método de um WebService
		/// </summary>
		/// <param name="methodName"></param>
		/// <returns></returns>
		public ArrayList GetParametersType(string methodName)
		{
			ArrayList parameterTypes = new ArrayList();

			ParameterCollection parameters = GetParameters(methodName);

			foreach(Parameter parameter in parameters)
			{
				parameterTypes.Add(parameter.ParameterInfo.ParameterType);
			}
			
			return parameterTypes;
		}
		
		/// <summary>
		/// Invoca um método de um WebService mediante a colecção parâmetros
		/// Nota: Não tem em conta os NULLs
		/// </summary>
		/// <param name="methodName"></param>
		/// <param name="Parameters"></param>
		/// <returns></returns>
		public object InvokeWebService(string methodName, ParameterCollection Parameters)
		{
			object result;
			try
			{ 
				this.MethodName = methodName;

				foreach(Parameter parameter in Parameters)
				{
					try
					{
						if (parameter.ParameterValue!=null)
						{
							object paramValue = Convert.ChangeType(parameter.ParameterValue, parameter.ParameterInfo.ParameterType);
							this.AddParameter(paramValue);
						}
						else
							this.AddParameter(null);
					}
					catch (Exception ex)
					{
						string message = "Parameter Type: " + parameter.ParameterInfo.ParameterType + "ParameterValue: " + (parameter.ParameterValue!=null?parameter.ParameterValue:string.Empty);
						throw new Exception(message, ex);
					}
				}

				result = this.InvokeCall();
			}
			catch (Exception ex)
			{
				throw ex;
			}
			return result;
		}
	
		
		/// <summary>
		/// Invoca um método com pârametros de um WebService a partir de XML construído
		/// Os valores vazios são considerados NULLs
		/// </summary>
		/// <param name="methodName"></param>
		/// <param name="Parameters"></param>
		/// <returns></returns>
		public object InvokeXMLWebService(string methodName, ParameterCollection Parameters)
		{
			try
			{
				this.MethodName = methodName;

				XmlDocument document = new XmlDocument();

				XmlDeclaration declaration = document.CreateXmlDeclaration("1.0", "utf-8", null);

				XmlElement soapEnvelope = document.CreateElement("soap","Envelope","http://schemas.xmlsoap.org/soap/envelope/");

				soapEnvelope.SetAttribute("xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance");
				soapEnvelope.SetAttribute("xmlns:xsd","http://www.w3.org/2001/XMLSchema");
				soapEnvelope.SetAttribute("xmlns:soap", "http://schemas.xmlsoap.org/soap/envelope/");
			
				XmlElement soapBody = document.CreateElement("soap","Body", "http://schemas.xmlsoap.org/soap/envelope/");
	
				XmlElement method = document.CreateElement(methodName);

				method.SetAttribute("xmlns", "http://tempuri.org/");

				document.InsertBefore(declaration, document.DocumentElement);

				document.AppendChild(soapEnvelope);

				soapEnvelope.AppendChild(soapBody);

				soapBody.AppendChild(method);


				foreach (Parameter parameter in  Parameters)
				{
					try
					{
						XmlElement xmlparameter = document.CreateElement(parameter.ParameterInfo.Name);
					
						if (parameter.ParameterValue!=null)
						{
							if (parameter.ParameterInfo.ParameterType != typeof(DateTime))
							{
								if (parameter.ParameterInfo.ParameterType != typeof(decimal))
									xmlparameter.InnerText = Convert.ToString(Convert.ChangeType(parameter.ParameterValue, parameter.ParameterInfo.ParameterType));
								else
									xmlparameter.InnerText = Convert.ToString(Convert.ChangeType(parameter.ParameterValue, parameter.ParameterInfo.ParameterType)).Replace(",",".");
							}
							else
								xmlparameter.InnerText = (Convert.ToDateTime(parameter.ParameterValue)).ToString("s");
						}

						method.AppendChild(xmlparameter);
					}
					catch (Exception ex)
					{
						string message = "Parameter Type: " + parameter.ParameterInfo.ParameterType + "ParameterValue: " + (parameter.ParameterValue!=null?parameter.ParameterValue:string.Empty);
						throw new Exception(message, ex);
					}
				}

				string content = document.InnerXml;


				this.InvokeXMLWebService(this.Url, content, "SOAPAction: \"http://tempuri.org/"+ methodName +"\"");
			}
			catch (Exception ex)
			{
				throw ex;
			}
	
			return true;
		}


		/// <summary>
		/// Invoca um método de um WebService a partir da Soap Message
		/// </summary>
		/// <param name="url"></param>
		/// <param name="content"></param>
		/// <param name="headers"></param>
		private void InvokeXMLWebService(string url, string content, params string[] headers)
		{
			//----------------------------------------------------------------
			// Declaração de variáveis
			//----------------------------------------------------------------
			HttpWebRequest request = null;

			Stream s ;
			
			try
			{
				request = (HttpWebRequest)WebRequest.Create(url);

				request.Credentials = CredentialCache.DefaultCredentials;

				char[] data = content.ToCharArray();
				
				foreach(string header in headers)
				{
					request.Headers.Add(header);
				}

				request.Method = "POST";

				request.ContentType = "text/xml; charset=utf-8";

				if (content.Length > 0)
				{
					Encoding encodeUTF = System.Text.Encoding.GetEncoding("utf-8");
					request.ContentLength = encodeUTF.GetByteCount(data, 0, data.Length);
					s = request.GetRequestStream();
					StreamWriter sw = new StreamWriter(s);
					sw.AutoFlush = true;
					sw.Write(data, 0, data.Length);
					sw.Close();
				}

				HttpWebResponse result = (HttpWebResponse)request.GetResponse();

				Stream receiveStream = result.GetResponseStream();

				Encoding encode = System.Text.Encoding.GetEncoding("utf-8");
				
				StreamReader readStream = new StreamReader(receiveStream, encode);
				
				int size = 256;

				Char[] read = new Char[size];

				int count = readStream.Read(read, 0, size);

				string resultStr = string.Empty;

				while (count > 0) 
				{
					resultStr += new String(read, 0, count);
					
					count = readStream.Read(read, 0, size);
				}

				request.Abort();
				
				result.Close();

				readStream.Close();

			}
			catch(Exception ex)
			{
				throw ex;
			}
			finally 
			{				
				request.Abort();
			}
		}
	
		#endregion
	}
}
