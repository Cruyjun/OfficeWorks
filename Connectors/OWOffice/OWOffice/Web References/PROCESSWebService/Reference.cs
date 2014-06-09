﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.34003
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

// 
// This source code was auto-generated by Microsoft.VSDesigner, Version 4.0.30319.34003.
// 
#pragma warning disable 1591

namespace OfficeWorks.OWOffice.PROCESSWebService {
    using System;
    using System.Web.Services;
    using System.Diagnostics;
    using System.Web.Services.Protocols;
    using System.Xml.Serialization;
    using System.ComponentModel;
    
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.0.30319.33440")]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Web.Services.WebServiceBindingAttribute(Name="ProcessSoap", Namespace="http://tempuri.org/")]
    public partial class Process : System.Web.Services.Protocols.SoapHttpClientProtocol {
        
        private System.Threading.SendOrPostCallback GetVersionOperationCompleted;
        
        private System.Threading.SendOrPostCallback StartProcessAndSaveOperationCompleted;
        
        private System.Threading.SendOrPostCallback AddProcessFilesOperationCompleted;
        
        private System.Threading.SendOrPostCallback GetProcessStageCodeOperationCompleted;
        
        private System.Threading.SendOrPostCallback GetUserSignaturesAccessesOperationCompleted;
        
        private System.Threading.SendOrPostCallback GetUserSignatureOperationCompleted;
        
        private bool useDefaultCredentialsSetExplicitly;
        
        /// <remarks/>
        public Process() {
            this.Url = "http://localhost/OfficeWorks/WebServices/OWProcess/Process.asmx";
            if ((this.IsLocalFileSystemWebService(this.Url) == true)) {
                this.UseDefaultCredentials = true;
                this.useDefaultCredentialsSetExplicitly = false;
            }
            else {
                this.useDefaultCredentialsSetExplicitly = true;
            }
        }
        
        public new string Url {
            get {
                return base.Url;
            }
            set {
                if ((((this.IsLocalFileSystemWebService(base.Url) == true) 
                            && (this.useDefaultCredentialsSetExplicitly == false)) 
                            && (this.IsLocalFileSystemWebService(value) == false))) {
                    base.UseDefaultCredentials = false;
                }
                base.Url = value;
            }
        }
        
        public new bool UseDefaultCredentials {
            get {
                return base.UseDefaultCredentials;
            }
            set {
                base.UseDefaultCredentials = value;
                this.useDefaultCredentialsSetExplicitly = true;
            }
        }
        
        /// <remarks/>
        public event GetVersionCompletedEventHandler GetVersionCompleted;
        
        /// <remarks/>
        public event StartProcessAndSaveCompletedEventHandler StartProcessAndSaveCompleted;
        
        /// <remarks/>
        public event AddProcessFilesCompletedEventHandler AddProcessFilesCompleted;
        
        /// <remarks/>
        public event GetProcessStageCodeCompletedEventHandler GetProcessStageCodeCompleted;
        
        /// <remarks/>
        public event GetUserSignaturesAccessesCompletedEventHandler GetUserSignaturesAccessesCompleted;
        
        /// <remarks/>
        public event GetUserSignatureCompletedEventHandler GetUserSignatureCompleted;
        
        /// <remarks/>
        [System.Web.Services.Protocols.SoapDocumentMethodAttribute("http://tempuri.org/GetVersion", RequestNamespace="http://tempuri.org/", ResponseNamespace="http://tempuri.org/", Use=System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle=System.Web.Services.Protocols.SoapParameterStyle.Wrapped)]
        public string GetVersion() {
            object[] results = this.Invoke("GetVersion", new object[0]);
            return ((string)(results[0]));
        }
        
        /// <remarks/>
        public System.IAsyncResult BeginGetVersion(System.AsyncCallback callback, object asyncState) {
            return this.BeginInvoke("GetVersion", new object[0], callback, asyncState);
        }
        
        /// <remarks/>
        public string EndGetVersion(System.IAsyncResult asyncResult) {
            object[] results = this.EndInvoke(asyncResult);
            return ((string)(results[0]));
        }
        
        /// <remarks/>
        public void GetVersionAsync() {
            this.GetVersionAsync(null);
        }
        
        /// <remarks/>
        public void GetVersionAsync(object userState) {
            if ((this.GetVersionOperationCompleted == null)) {
                this.GetVersionOperationCompleted = new System.Threading.SendOrPostCallback(this.OnGetVersionOperationCompleted);
            }
            this.InvokeAsync("GetVersion", new object[0], this.GetVersionOperationCompleted, userState);
        }
        
        private void OnGetVersionOperationCompleted(object arg) {
            if ((this.GetVersionCompleted != null)) {
                System.Web.Services.Protocols.InvokeCompletedEventArgs invokeArgs = ((System.Web.Services.Protocols.InvokeCompletedEventArgs)(arg));
                this.GetVersionCompleted(this, new GetVersionCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState));
            }
        }
        
        /// <remarks/>
        [System.Web.Services.Protocols.SoapDocumentMethodAttribute("http://tempuri.org/StartProcessAndSave", RequestNamespace="http://tempuri.org/", ResponseNamespace="http://tempuri.org/", Use=System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle=System.Web.Services.Protocols.SoapParameterStyle.Wrapped)]
        public ProcessSummary StartProcessAndSave(string Code, string ProcessSubject, [System.Xml.Serialization.XmlArrayItemAttribute(IsNullable=false)] stFile[] Files) {
            object[] results = this.Invoke("StartProcessAndSave", new object[] {
                        Code,
                        ProcessSubject,
                        Files});
            return ((ProcessSummary)(results[0]));
        }
        
        /// <remarks/>
        public System.IAsyncResult BeginStartProcessAndSave(string Code, string ProcessSubject, stFile[] Files, System.AsyncCallback callback, object asyncState) {
            return this.BeginInvoke("StartProcessAndSave", new object[] {
                        Code,
                        ProcessSubject,
                        Files}, callback, asyncState);
        }
        
        /// <remarks/>
        public ProcessSummary EndStartProcessAndSave(System.IAsyncResult asyncResult) {
            object[] results = this.EndInvoke(asyncResult);
            return ((ProcessSummary)(results[0]));
        }
        
        /// <remarks/>
        public void StartProcessAndSaveAsync(string Code, string ProcessSubject, stFile[] Files) {
            this.StartProcessAndSaveAsync(Code, ProcessSubject, Files, null);
        }
        
        /// <remarks/>
        public void StartProcessAndSaveAsync(string Code, string ProcessSubject, stFile[] Files, object userState) {
            if ((this.StartProcessAndSaveOperationCompleted == null)) {
                this.StartProcessAndSaveOperationCompleted = new System.Threading.SendOrPostCallback(this.OnStartProcessAndSaveOperationCompleted);
            }
            this.InvokeAsync("StartProcessAndSave", new object[] {
                        Code,
                        ProcessSubject,
                        Files}, this.StartProcessAndSaveOperationCompleted, userState);
        }
        
        private void OnStartProcessAndSaveOperationCompleted(object arg) {
            if ((this.StartProcessAndSaveCompleted != null)) {
                System.Web.Services.Protocols.InvokeCompletedEventArgs invokeArgs = ((System.Web.Services.Protocols.InvokeCompletedEventArgs)(arg));
                this.StartProcessAndSaveCompleted(this, new StartProcessAndSaveCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState));
            }
        }
        
        /// <remarks/>
        [System.Web.Services.Protocols.SoapDocumentMethodAttribute("http://tempuri.org/AddProcessFiles", RequestNamespace="http://tempuri.org/", ResponseNamespace="http://tempuri.org/", Use=System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle=System.Web.Services.Protocols.SoapParameterStyle.Wrapped)]
        public ProcessSummary AddProcessFiles(int ProcessID, [System.Xml.Serialization.XmlArrayItemAttribute(IsNullable=false)] stFile[] Files, bool newProcessEvent) {
            object[] results = this.Invoke("AddProcessFiles", new object[] {
                        ProcessID,
                        Files,
                        newProcessEvent});
            return ((ProcessSummary)(results[0]));
        }
        
        /// <remarks/>
        public System.IAsyncResult BeginAddProcessFiles(int ProcessID, stFile[] Files, bool newProcessEvent, System.AsyncCallback callback, object asyncState) {
            return this.BeginInvoke("AddProcessFiles", new object[] {
                        ProcessID,
                        Files,
                        newProcessEvent}, callback, asyncState);
        }
        
        /// <remarks/>
        public ProcessSummary EndAddProcessFiles(System.IAsyncResult asyncResult) {
            object[] results = this.EndInvoke(asyncResult);
            return ((ProcessSummary)(results[0]));
        }
        
        /// <remarks/>
        public void AddProcessFilesAsync(int ProcessID, stFile[] Files, bool newProcessEvent) {
            this.AddProcessFilesAsync(ProcessID, Files, newProcessEvent, null);
        }
        
        /// <remarks/>
        public void AddProcessFilesAsync(int ProcessID, stFile[] Files, bool newProcessEvent, object userState) {
            if ((this.AddProcessFilesOperationCompleted == null)) {
                this.AddProcessFilesOperationCompleted = new System.Threading.SendOrPostCallback(this.OnAddProcessFilesOperationCompleted);
            }
            this.InvokeAsync("AddProcessFiles", new object[] {
                        ProcessID,
                        Files,
                        newProcessEvent}, this.AddProcessFilesOperationCompleted, userState);
        }
        
        private void OnAddProcessFilesOperationCompleted(object arg) {
            if ((this.AddProcessFilesCompleted != null)) {
                System.Web.Services.Protocols.InvokeCompletedEventArgs invokeArgs = ((System.Web.Services.Protocols.InvokeCompletedEventArgs)(arg));
                this.AddProcessFilesCompleted(this, new AddProcessFilesCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState));
            }
        }
        
        /// <remarks/>
        [System.Web.Services.Protocols.SoapDocumentMethodAttribute("http://tempuri.org/GetProcessStageCode", RequestNamespace="http://tempuri.org/", ResponseNamespace="http://tempuri.org/", Use=System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle=System.Web.Services.Protocols.SoapParameterStyle.Wrapped)]
        public string GetProcessStageCode(int UserID, int ProcessID) {
            object[] results = this.Invoke("GetProcessStageCode", new object[] {
                        UserID,
                        ProcessID});
            return ((string)(results[0]));
        }
        
        /// <remarks/>
        public System.IAsyncResult BeginGetProcessStageCode(int UserID, int ProcessID, System.AsyncCallback callback, object asyncState) {
            return this.BeginInvoke("GetProcessStageCode", new object[] {
                        UserID,
                        ProcessID}, callback, asyncState);
        }
        
        /// <remarks/>
        public string EndGetProcessStageCode(System.IAsyncResult asyncResult) {
            object[] results = this.EndInvoke(asyncResult);
            return ((string)(results[0]));
        }
        
        /// <remarks/>
        public void GetProcessStageCodeAsync(int UserID, int ProcessID) {
            this.GetProcessStageCodeAsync(UserID, ProcessID, null);
        }
        
        /// <remarks/>
        public void GetProcessStageCodeAsync(int UserID, int ProcessID, object userState) {
            if ((this.GetProcessStageCodeOperationCompleted == null)) {
                this.GetProcessStageCodeOperationCompleted = new System.Threading.SendOrPostCallback(this.OnGetProcessStageCodeOperationCompleted);
            }
            this.InvokeAsync("GetProcessStageCode", new object[] {
                        UserID,
                        ProcessID}, this.GetProcessStageCodeOperationCompleted, userState);
        }
        
        private void OnGetProcessStageCodeOperationCompleted(object arg) {
            if ((this.GetProcessStageCodeCompleted != null)) {
                System.Web.Services.Protocols.InvokeCompletedEventArgs invokeArgs = ((System.Web.Services.Protocols.InvokeCompletedEventArgs)(arg));
                this.GetProcessStageCodeCompleted(this, new GetProcessStageCodeCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState));
            }
        }
        
        /// <remarks/>
        [System.Web.Services.Protocols.SoapDocumentMethodAttribute("http://tempuri.org/GetUserSignaturesAccesses", RequestNamespace="http://tempuri.org/", ResponseNamespace="http://tempuri.org/", Use=System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle=System.Web.Services.Protocols.SoapParameterStyle.Wrapped)]
        [return: System.Xml.Serialization.XmlArrayItemAttribute(IsNullable=false)]
        public stUser[] GetUserSignaturesAccesses() {
            object[] results = this.Invoke("GetUserSignaturesAccesses", new object[0]);
            return ((stUser[])(results[0]));
        }
        
        /// <remarks/>
        public System.IAsyncResult BeginGetUserSignaturesAccesses(System.AsyncCallback callback, object asyncState) {
            return this.BeginInvoke("GetUserSignaturesAccesses", new object[0], callback, asyncState);
        }
        
        /// <remarks/>
        public stUser[] EndGetUserSignaturesAccesses(System.IAsyncResult asyncResult) {
            object[] results = this.EndInvoke(asyncResult);
            return ((stUser[])(results[0]));
        }
        
        /// <remarks/>
        public void GetUserSignaturesAccessesAsync() {
            this.GetUserSignaturesAccessesAsync(null);
        }
        
        /// <remarks/>
        public void GetUserSignaturesAccessesAsync(object userState) {
            if ((this.GetUserSignaturesAccessesOperationCompleted == null)) {
                this.GetUserSignaturesAccessesOperationCompleted = new System.Threading.SendOrPostCallback(this.OnGetUserSignaturesAccessesOperationCompleted);
            }
            this.InvokeAsync("GetUserSignaturesAccesses", new object[0], this.GetUserSignaturesAccessesOperationCompleted, userState);
        }
        
        private void OnGetUserSignaturesAccessesOperationCompleted(object arg) {
            if ((this.GetUserSignaturesAccessesCompleted != null)) {
                System.Web.Services.Protocols.InvokeCompletedEventArgs invokeArgs = ((System.Web.Services.Protocols.InvokeCompletedEventArgs)(arg));
                this.GetUserSignaturesAccessesCompleted(this, new GetUserSignaturesAccessesCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState));
            }
        }
        
        /// <remarks/>
        [System.Web.Services.Protocols.SoapDocumentMethodAttribute("http://tempuri.org/GetUserSignature", RequestNamespace="http://tempuri.org/", ResponseNamespace="http://tempuri.org/", Use=System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle=System.Web.Services.Protocols.SoapParameterStyle.Wrapped)]
        [return: System.Xml.Serialization.XmlElementAttribute(DataType="base64Binary")]
        public byte[] GetUserSignature(int UserID) {
            object[] results = this.Invoke("GetUserSignature", new object[] {
                        UserID});
            return ((byte[])(results[0]));
        }
        
        /// <remarks/>
        public System.IAsyncResult BeginGetUserSignature(int UserID, System.AsyncCallback callback, object asyncState) {
            return this.BeginInvoke("GetUserSignature", new object[] {
                        UserID}, callback, asyncState);
        }
        
        /// <remarks/>
        public byte[] EndGetUserSignature(System.IAsyncResult asyncResult) {
            object[] results = this.EndInvoke(asyncResult);
            return ((byte[])(results[0]));
        }
        
        /// <remarks/>
        public void GetUserSignatureAsync(int UserID) {
            this.GetUserSignatureAsync(UserID, null);
        }
        
        /// <remarks/>
        public void GetUserSignatureAsync(int UserID, object userState) {
            if ((this.GetUserSignatureOperationCompleted == null)) {
                this.GetUserSignatureOperationCompleted = new System.Threading.SendOrPostCallback(this.OnGetUserSignatureOperationCompleted);
            }
            this.InvokeAsync("GetUserSignature", new object[] {
                        UserID}, this.GetUserSignatureOperationCompleted, userState);
        }
        
        private void OnGetUserSignatureOperationCompleted(object arg) {
            if ((this.GetUserSignatureCompleted != null)) {
                System.Web.Services.Protocols.InvokeCompletedEventArgs invokeArgs = ((System.Web.Services.Protocols.InvokeCompletedEventArgs)(arg));
                this.GetUserSignatureCompleted(this, new GetUserSignatureCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState));
            }
        }
        
        /// <remarks/>
        public new void CancelAsync(object userState) {
            base.CancelAsync(userState);
        }
        
        private bool IsLocalFileSystemWebService(string url) {
            if (((url == null) 
                        || (url == string.Empty))) {
                return false;
            }
            System.Uri wsUri = new System.Uri(url);
            if (((wsUri.Port >= 1024) 
                        && (string.Compare(wsUri.Host, "localHost", System.StringComparison.OrdinalIgnoreCase) == 0))) {
                return true;
            }
            return false;
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "4.0.30319.33440")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace="http://tempuri.org/")]
    public partial class stFile {
        
        private long fileIDField;
        
        private string fileNameField;
        
        private string filePathField;
        
        private byte[] fileArrayField;
        
        private bool useDimeAccessField;
        
        /// <remarks/>
        public long FileID {
            get {
                return this.fileIDField;
            }
            set {
                this.fileIDField = value;
            }
        }
        
        /// <remarks/>
        public string FileName {
            get {
                return this.fileNameField;
            }
            set {
                this.fileNameField = value;
            }
        }
        
        /// <remarks/>
        public string FilePath {
            get {
                return this.filePathField;
            }
            set {
                this.filePathField = value;
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType="base64Binary")]
        public byte[] FileArray {
            get {
                return this.fileArrayField;
            }
            set {
                this.fileArrayField = value;
            }
        }
        
        /// <remarks/>
        public bool UseDimeAccess {
            get {
                return this.useDimeAccessField;
            }
            set {
                this.useDimeAccessField = value;
            }
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "4.0.30319.33440")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace="http://tempuri.org/")]
    public partial class stUser {
        
        private long userIDField;
        
        private string userLoginField;
        
        private string userDescriptionField;
        
        private string userMailField;
        
        private long primaryGroupIDField;
        
        private byte[] userRolesField;
        
        /// <remarks/>
        public long UserID {
            get {
                return this.userIDField;
            }
            set {
                this.userIDField = value;
            }
        }
        
        /// <remarks/>
        public string UserLogin {
            get {
                return this.userLoginField;
            }
            set {
                this.userLoginField = value;
            }
        }
        
        /// <remarks/>
        public string UserDescription {
            get {
                return this.userDescriptionField;
            }
            set {
                this.userDescriptionField = value;
            }
        }
        
        /// <remarks/>
        public string UserMail {
            get {
                return this.userMailField;
            }
            set {
                this.userMailField = value;
            }
        }
        
        /// <remarks/>
        public long PrimaryGroupID {
            get {
                return this.primaryGroupIDField;
            }
            set {
                this.primaryGroupIDField = value;
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(DataType="base64Binary")]
        public byte[] UserRoles {
            get {
                return this.userRolesField;
            }
            set {
                this.userRolesField = value;
            }
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "4.0.30319.33440")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace="http://tempuri.org/")]
    public partial class ProcessSummary {
        
        private int idField;
        
        private string processNumberField;
        
        /// <remarks/>
        public int ID {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        
        /// <remarks/>
        public string ProcessNumber {
            get {
                return this.processNumberField;
            }
            set {
                this.processNumberField = value;
            }
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.0.30319.33440")]
    public delegate void GetVersionCompletedEventHandler(object sender, GetVersionCompletedEventArgs e);
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.0.30319.33440")]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    public partial class GetVersionCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs {
        
        private object[] results;
        
        internal GetVersionCompletedEventArgs(object[] results, System.Exception exception, bool cancelled, object userState) : 
                base(exception, cancelled, userState) {
            this.results = results;
        }
        
        /// <remarks/>
        public string Result {
            get {
                this.RaiseExceptionIfNecessary();
                return ((string)(this.results[0]));
            }
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.0.30319.33440")]
    public delegate void StartProcessAndSaveCompletedEventHandler(object sender, StartProcessAndSaveCompletedEventArgs e);
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.0.30319.33440")]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    public partial class StartProcessAndSaveCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs {
        
        private object[] results;
        
        internal StartProcessAndSaveCompletedEventArgs(object[] results, System.Exception exception, bool cancelled, object userState) : 
                base(exception, cancelled, userState) {
            this.results = results;
        }
        
        /// <remarks/>
        public ProcessSummary Result {
            get {
                this.RaiseExceptionIfNecessary();
                return ((ProcessSummary)(this.results[0]));
            }
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.0.30319.33440")]
    public delegate void AddProcessFilesCompletedEventHandler(object sender, AddProcessFilesCompletedEventArgs e);
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.0.30319.33440")]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    public partial class AddProcessFilesCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs {
        
        private object[] results;
        
        internal AddProcessFilesCompletedEventArgs(object[] results, System.Exception exception, bool cancelled, object userState) : 
                base(exception, cancelled, userState) {
            this.results = results;
        }
        
        /// <remarks/>
        public ProcessSummary Result {
            get {
                this.RaiseExceptionIfNecessary();
                return ((ProcessSummary)(this.results[0]));
            }
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.0.30319.33440")]
    public delegate void GetProcessStageCodeCompletedEventHandler(object sender, GetProcessStageCodeCompletedEventArgs e);
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.0.30319.33440")]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    public partial class GetProcessStageCodeCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs {
        
        private object[] results;
        
        internal GetProcessStageCodeCompletedEventArgs(object[] results, System.Exception exception, bool cancelled, object userState) : 
                base(exception, cancelled, userState) {
            this.results = results;
        }
        
        /// <remarks/>
        public string Result {
            get {
                this.RaiseExceptionIfNecessary();
                return ((string)(this.results[0]));
            }
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.0.30319.33440")]
    public delegate void GetUserSignaturesAccessesCompletedEventHandler(object sender, GetUserSignaturesAccessesCompletedEventArgs e);
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.0.30319.33440")]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    public partial class GetUserSignaturesAccessesCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs {
        
        private object[] results;
        
        internal GetUserSignaturesAccessesCompletedEventArgs(object[] results, System.Exception exception, bool cancelled, object userState) : 
                base(exception, cancelled, userState) {
            this.results = results;
        }
        
        /// <remarks/>
        public stUser[] Result {
            get {
                this.RaiseExceptionIfNecessary();
                return ((stUser[])(this.results[0]));
            }
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.0.30319.33440")]
    public delegate void GetUserSignatureCompletedEventHandler(object sender, GetUserSignatureCompletedEventArgs e);
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.0.30319.33440")]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    public partial class GetUserSignatureCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs {
        
        private object[] results;
        
        internal GetUserSignatureCompletedEventArgs(object[] results, System.Exception exception, bool cancelled, object userState) : 
                base(exception, cancelled, userState) {
            this.results = results;
        }
        
        /// <remarks/>
        public byte[] Result {
            get {
                this.RaiseExceptionIfNecessary();
                return ((byte[])(this.results[0]));
            }
        }
    }
}

#pragma warning restore 1591