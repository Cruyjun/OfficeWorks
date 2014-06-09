using System;
using System.ComponentModel;
using System.Diagnostics;
using System.Web.Services;
using System.Web.Services.Description;
using System.Web.Services.Protocols;
using Microsoft.Web.Services2;

namespace OWScan {
	/// <summary>
	/// File upload webservice proxy class
	/// </summary>
	[DebuggerStepThrough(), DesignerCategory("code"), WebServiceBinding(Name="UploadFileAttachmentSoap")]

	
	public class UploadFileAttachment : WebServicesClientProtocol {
		/// <remarks/>
		public UploadFileAttachment(string strWebServiceURL) {
			this.Url = strWebServiceURL;
		}

		/// <remarks/>
		[SoapDocumentMethod("http://tempuri.org/UploadFile", RequestNamespace="http://tempuri.org/", ResponseNamespace="http://tempuri.org/", Use=SoapBindingUse.Literal, ParameterStyle=SoapParameterStyle.Wrapped)]
		public string UploadFile() {
			object[] results = this.Invoke("UploadFile", new object[0]);
			return ((string)(results[0]));
		}

		/// <remarks/>
		public IAsyncResult BeginUploadFile(AsyncCallback callback, object asyncState) {
			return this.BeginInvoke("UploadFile", new object[0], callback, asyncState);
		}

		/// <remarks/>
		public string EndUploadFile(IAsyncResult asyncResult) {
			object[] results = this.EndInvoke(asyncResult);
			return ((string)(results[0]));
		}
	}
}