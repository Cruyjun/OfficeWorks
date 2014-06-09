﻿using System;
using System.ComponentModel;
using System.Diagnostics;
using System.Web.Services;
using System.Web.Services.Description;
using System.Web.Services.Protocols;
using System.Xml.Serialization;
//------------------------------------------------------------------------------
// <autogenerated>
//     This code was generated by a tool.
//     Runtime Version: 1.1.4322.573
//
//     Changes to this file may cause incorrect behavior and will be lost if 
//     the code is regenerated.
// </autogenerated>
//------------------------------------------------------------------------------

// 
// This source code was auto-generated by Microsoft.VSDesigner, Version 1.1.4322.573.
// 
namespace OWMailConfigurator.OWApiWebService {
	/// <remarks/>
    [DebuggerStepThrough()]
    [DesignerCategory("code")]
    [WebServiceBinding(Name="OWApiSoap", Namespace="http://tempuri.org/")]
    public class OWApi : SoapHttpClientProtocol {
        
        /// <remarks/>
        public OWApi() {
            this.Url = "http://localhost/OWApi/OWApi.asmx";
        }
        
        /// <remarks/>
        [SoapDocumentMethod("http://tempuri.org/GetList", RequestNamespace="http://tempuri.org/", ResponseNamespace="http://tempuri.org/", Use=SoapBindingUse.Literal, ParameterStyle=SoapParameterStyle.Wrapped)]
        [return: XmlArrayItem(IsNullable=false)]
        public stList[] GetList(string login, long role) {
            object[] results = this.Invoke("GetList", new object[] {
                        login,
                        role});
            return ((stList[])(results[0]));
        }
        
        /// <remarks/>
        public IAsyncResult BeginGetList(string login, long role, AsyncCallback callback, object asyncState) {
            return this.BeginInvoke("GetList", new object[] {
                        login,
                        role}, callback, asyncState);
        }
        
        /// <remarks/>
        public stList[] EndGetList(IAsyncResult asyncResult) {
            object[] results = this.EndInvoke(asyncResult);
            return ((stList[])(results[0]));
        }
        
        /// <remarks/>
        [SoapDocumentMethod("http://tempuri.org/GetContact", RequestNamespace="http://tempuri.org/", ResponseNamespace="http://tempuri.org/", Use=SoapBindingUse.Literal, ParameterStyle=SoapParameterStyle.Wrapped)]
        public stContact[] GetContact([XmlArrayItem(IsNullable=false)] stFieldsStruct[] FieldsColl, bool Full, string Login, enumAddressesRoles Role, long PageNumber, long PageSize, ref long NumReg) {
            object[] results = this.Invoke("GetContact", new object[] {
                        FieldsColl,
                        Full,
                        Login,
                        Role,
                        PageNumber,
                        PageSize,
                        NumReg});
            NumReg = ((long)(results[1]));
            return ((stContact[])(results[0]));
        }
        
        /// <remarks/>
        public IAsyncResult BeginGetContact(stFieldsStruct[] FieldsColl, bool Full, string Login, enumAddressesRoles Role, long PageNumber, long PageSize, long NumReg, AsyncCallback callback, object asyncState) {
            return this.BeginInvoke("GetContact", new object[] {
                        FieldsColl,
                        Full,
                        Login,
                        Role,
                        PageNumber,
                        PageSize,
                        NumReg}, callback, asyncState);
        }
        
        /// <remarks/>
        public stContact[] EndGetContact(IAsyncResult asyncResult, out long NumReg) {
            object[] results = this.EndInvoke(asyncResult);
            NumReg = ((long)(results[1]));
            return ((stContact[])(results[0]));
        }
        
        /// <remarks/>
        [SoapDocumentMethod("http://tempuri.org/GetEntitiesGroups", RequestNamespace="http://tempuri.org/", ResponseNamespace="http://tempuri.org/", Use=SoapBindingUse.Literal, ParameterStyle=SoapParameterStyle.Wrapped)]
        [return: XmlArrayItem(IsNullable=false)]
        public stGroup[] GetEntitiesGroups() {
            object[] results = this.Invoke("GetEntitiesGroups", new object[0]);
            return ((stGroup[])(results[0]));
        }
        
        /// <remarks/>
        public IAsyncResult BeginGetEntitiesGroups(AsyncCallback callback, object asyncState) {
            return this.BeginInvoke("GetEntitiesGroups", new object[0], callback, asyncState);
        }
        
        /// <remarks/>
        public stGroup[] EndGetEntitiesGroups(IAsyncResult asyncResult) {
            object[] results = this.EndInvoke(asyncResult);
            return ((stGroup[])(results[0]));
        }
        
        /// <remarks/>
        [SoapDocumentMethod("http://tempuri.org/GetGroupsEntities", RequestNamespace="http://tempuri.org/", ResponseNamespace="http://tempuri.org/", Use=SoapBindingUse.Literal, ParameterStyle=SoapParameterStyle.Wrapped)]
        [return: XmlArrayItem(IsNullable=false)]
        public stGroup[] GetGroupsEntities(long Identifier, string Description) {
            object[] results = this.Invoke("GetGroupsEntities", new object[] {
                        Identifier,
                        Description});
            return ((stGroup[])(results[0]));
        }
        
        /// <remarks/>
        public IAsyncResult BeginGetGroupsEntities(long Identifier, string Description, AsyncCallback callback, object asyncState) {
            return this.BeginInvoke("GetGroupsEntities", new object[] {
                        Identifier,
                        Description}, callback, asyncState);
        }
        
        /// <remarks/>
        public stGroup[] EndGetGroupsEntities(IAsyncResult asyncResult) {
            object[] results = this.EndInvoke(asyncResult);
            return ((stGroup[])(results[0]));
        }
        
        /// <remarks/>
        [SoapDocumentMethod("http://tempuri.org/GetBook", RequestNamespace="http://tempuri.org/", ResponseNamespace="http://tempuri.org/", Use=SoapBindingUse.Literal, ParameterStyle=SoapParameterStyle.Wrapped)]
        [return: XmlArrayItem(IsNullable=false)]
        public stBook[] GetBook(string login, long role) {
            object[] results = this.Invoke("GetBook", new object[] {
                        login,
                        role});
            return ((stBook[])(results[0]));
        }
        
        /// <remarks/>
        public IAsyncResult BeginGetBook(string login, long role, AsyncCallback callback, object asyncState) {
            return this.BeginInvoke("GetBook", new object[] {
                        login,
                        role}, callback, asyncState);
        }
        
        /// <remarks/>
        public stBook[] EndGetBook(IAsyncResult asyncResult) {
            object[] results = this.EndInvoke(asyncResult);
            return ((stBook[])(results[0]));
        }
        
        /// <remarks/>
        [SoapDocumentMethod("http://tempuri.org/GetAllBooks", RequestNamespace="http://tempuri.org/", ResponseNamespace="http://tempuri.org/", Use=SoapBindingUse.Literal, ParameterStyle=SoapParameterStyle.Wrapped)]
        [return: XmlArrayItem(IsNullable=false)]
        public stBook[] GetAllBooks() {
            object[] results = this.Invoke("GetAllBooks", new object[0]);
            return ((stBook[])(results[0]));
        }
        
        /// <remarks/>
        public IAsyncResult BeginGetAllBooks(AsyncCallback callback, object asyncState) {
            return this.BeginInvoke("GetAllBooks", new object[0], callback, asyncState);
        }
        
        /// <remarks/>
        public stBook[] EndGetAllBooks(IAsyncResult asyncResult) {
            object[] results = this.EndInvoke(asyncResult);
            return ((stBook[])(results[0]));
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
        
        /// <remarks/>
        [SoapDocumentMethod("http://tempuri.org/GetUsersByProduct", RequestNamespace="http://tempuri.org/", ResponseNamespace="http://tempuri.org/", Use=SoapBindingUse.Literal, ParameterStyle=SoapParameterStyle.Wrapped)]
        [return: XmlArrayItem(IsNullable=false)]
        public stUser[] GetUsersByProduct(enumObjectType Product, bool Active) {
            object[] results = this.Invoke("GetUsersByProduct", new object[] {
                        Product,
                        Active});
            return ((stUser[])(results[0]));
        }
        
        /// <remarks/>
        public IAsyncResult BeginGetUsersByProduct(enumObjectType Product, bool Active, AsyncCallback callback, object asyncState) {
            return this.BeginInvoke("GetUsersByProduct", new object[] {
                        Product,
                        Active}, callback, asyncState);
        }
        
        /// <remarks/>
        public stUser[] EndGetUsersByProduct(IAsyncResult asyncResult) {
            object[] results = this.EndInvoke(asyncResult);
            return ((stUser[])(results[0]));
        }
        
        /// <remarks/>
        [SoapDocumentMethod("http://tempuri.org/GetDocumentTypesByBook", RequestNamespace="http://tempuri.org/", ResponseNamespace="http://tempuri.org/", Use=SoapBindingUse.Literal, ParameterStyle=SoapParameterStyle.Wrapped)]
        [return: XmlArrayItem(IsNullable=false)]
        public stDocumentType[] GetDocumentTypesByBook(long BookIdentifier) {
            object[] results = this.Invoke("GetDocumentTypesByBook", new object[] {
                        BookIdentifier});
            return ((stDocumentType[])(results[0]));
        }
        
        /// <remarks/>
        public IAsyncResult BeginGetDocumentTypesByBook(long BookIdentifier, AsyncCallback callback, object asyncState) {
            return this.BeginInvoke("GetDocumentTypesByBook", new object[] {
                        BookIdentifier}, callback, asyncState);
        }
        
        /// <remarks/>
        public stDocumentType[] EndGetDocumentTypesByBook(IAsyncResult asyncResult) {
            object[] results = this.EndInvoke(asyncResult);
            return ((stDocumentType[])(results[0]));
        }
        
        /// <remarks/>
        [SoapDocumentMethod("http://tempuri.org/InsertRegistry", RequestNamespace="http://tempuri.org/", ResponseNamespace="http://tempuri.org/", Use=SoapBindingUse.Literal, ParameterStyle=SoapParameterStyle.Wrapped)]
        public long InsertRegistry(string strDomainAndUsername, string strPassword, ref stRegistry Registry) {
            object[] results = this.Invoke("InsertRegistry", new object[] {
                        strDomainAndUsername,
                        strPassword,
                        Registry});
            Registry = ((stRegistry)(results[1]));
            return ((long)(results[0]));
        }
        
        /// <remarks/>
        public IAsyncResult BeginInsertRegistry(string strDomainAndUsername, string strPassword, stRegistry Registry, AsyncCallback callback, object asyncState) {
            return this.BeginInvoke("InsertRegistry", new object[] {
                        strDomainAndUsername,
                        strPassword,
                        Registry}, callback, asyncState);
        }
        
        /// <remarks/>
        public long EndInsertRegistry(IAsyncResult asyncResult, out stRegistry Registry) {
            object[] results = this.EndInvoke(asyncResult);
            Registry = ((stRegistry)(results[1]));
            return ((long)(results[0]));
        }
        
        /// <remarks/>
        [SoapDocumentMethod("http://tempuri.org/ModifyRegistry", RequestNamespace="http://tempuri.org/", ResponseNamespace="http://tempuri.org/", Use=SoapBindingUse.Literal, ParameterStyle=SoapParameterStyle.Wrapped)]
        public long ModifyRegistry(string strDomainAndUsername, string strPassword, ref stRegistry Registry) {
            object[] results = this.Invoke("ModifyRegistry", new object[] {
                        strDomainAndUsername,
                        strPassword,
                        Registry});
            Registry = ((stRegistry)(results[1]));
            return ((long)(results[0]));
        }
        
        /// <remarks/>
        public IAsyncResult BeginModifyRegistry(string strDomainAndUsername, string strPassword, stRegistry Registry, AsyncCallback callback, object asyncState) {
            return this.BeginInvoke("ModifyRegistry", new object[] {
                        strDomainAndUsername,
                        strPassword,
                        Registry}, callback, asyncState);
        }
        
        /// <remarks/>
        public long EndModifyRegistry(IAsyncResult asyncResult, out stRegistry Registry) {
            object[] results = this.EndInvoke(asyncResult);
            Registry = ((stRegistry)(results[1]));
            return ((long)(results[0]));
        }
    }
    
    /// <remarks/>
    [XmlType(Namespace="http://tempuri.org/")]
    public class stList {
        
        /// <remarks/>
        public long ListId;
        
        /// <remarks/>
        public string ListDescription;
    }
    
    /// <remarks/>
    [XmlType(Namespace="http://tempuri.org/")]
    public class stFile {
        
        /// <remarks/>
        public long FileID;
        
        /// <remarks/>
        public string FileName;
        
        /// <remarks/>
        public string FilePath;
        
        /// <remarks/>
        [XmlElement(DataType="base64Binary")]
        public Byte[] FileArray;
        
        /// <remarks/>
        public bool UseDimeAccess;
    }
    
    /// <remarks/>
    [XmlType(Namespace="http://tempuri.org/")]
    public class stUltimus {
        
        /// <remarks/>
        public long UltimusID;
        
        /// <remarks/>
        public string UltimusAbreviation;
        
        /// <remarks/>
        public string UltimusDescription;
    }
    
    /// <remarks/>
    [XmlType(Namespace="http://tempuri.org/")]
    public class stSAP {
        
        /// <remarks/>
        public long SAPID;
        
        /// <remarks/>
        public string SAPAbreviation;
        
        /// <remarks/>
        public string SAPDescription;
    }
    
    /// <remarks/>
    [XmlType(Namespace="http://tempuri.org/")]
    public class stWay {
        
        /// <remarks/>
        public long WayID;
        
        /// <remarks/>
        public string WayAbreviation;
        
        /// <remarks/>
        public string WayDescription;
    }
    
    /// <remarks/>
    [XmlType(Namespace="http://tempuri.org/")]
    public class stOtherWays {
        
        /// <remarks/>
        public stWay OtherWay;
        
        /// <remarks/>
        [XmlArrayItem(IsNullable=false)]
        public stEntity[] Entities;
    }
    
    /// <remarks/>
    [XmlType(Namespace="http://tempuri.org/")]
    public class stEntity {
        
        /// <remarks/>
        public long EntityID;
        
        /// <remarks/>
        public string EntityName;
        
        /// <remarks/>
        public string EntityExchangeID;
        
        /// <remarks/>
        public enumEntityType EntityType;
    }
    
    /// <remarks/>
    [XmlType(Namespace="http://tempuri.org/")]
    public enum enumEntityType {
        
        /// <remarks/>
        EntityTypeDestiny,
        
        /// <remarks/>
        EntityTypeOrigin,
    }
    
    /// <remarks/>
    [XmlType(Namespace="http://tempuri.org/")]
    public class stDistribution {
        
        /// <remarks/>
        public long DistributionID;
        
        /// <remarks/>
        public enumDistributionType DistributionType;
        
        /// <remarks/>
        public enumDistributionState DistributionState;
        
        /// <remarks/>
        public DateTime DistributionDate;
        
        /// <remarks/>
        public stOtherWays OtherWays;
        
        /// <remarks/>
        public stSAP SAP;
        
        /// <remarks/>
        public stUltimus Ultimus;
        
        /// <remarks/>
        public string Observations;
    }
    
    /// <remarks/>
    [XmlType(Namespace="http://tempuri.org/")]
    public enum enumDistributionType {
        
        /// <remarks/>
        DistributionTypeMail,
        
        /// <remarks/>
        DistributionTypeOtherWays,
        
        /// <remarks/>
        DistributionTypeSAP,
        
        /// <remarks/>
        DistributionTypeUltimus,
        
        /// <remarks/>
        DistributionTypeWorkflow,
        
        /// <remarks/>
        DistributionTypeOWFLow,
    }
    
    /// <remarks/>
    [XmlType(Namespace="http://tempuri.org/")]
    public enum enumDistributionState {
        
        /// <remarks/>
        DistributionStateStarted,
        
        /// <remarks/>
        DistributionStateEnded,
        
        /// <remarks/>
        DistributionStateError,
    }
    
    /// <remarks/>
    [XmlType(Namespace="http://tempuri.org/")]
    public class stDynamicField {
        
        /// <remarks/>
        public long DynamicFieldID;
        
        /// <remarks/>
        public enumFieldType DynamicFieldType;
        
        /// <remarks/>
        public string DynamicFieldName;
        
        /// <remarks/>
        public string DynamicFieldValue;
    }
    
    /// <remarks/>
    [XmlType(Namespace="http://tempuri.org/")]
    public enum enumFieldType {
        
        /// <remarks/>
        FieldTypeText,
        
        /// <remarks/>
        FieldTypeNumeric,
        
        /// <remarks/>
        FieldTypeFloat,
        
        /// <remarks/>
        FieldTypeDate,
        
        /// <remarks/>
        FieldTypeDateTime,
        
        /// <remarks/>
        FieldTypeStatic,
        
        /// <remarks/>
        FieldTypeList,
    }
    
    /// <remarks/>
    [XmlType(Namespace="http://tempuri.org/")]
    public class stKeyword {
        
        /// <remarks/>
        public long KeywordID;
        
        /// <remarks/>
        public string KeywordDescription;
        
        /// <remarks/>
        public bool Global;
    }
    
    /// <remarks/>
    [XmlType(Namespace="http://tempuri.org/")]
    public class stClassification {
        
        /// <remarks/>
        public long ClassificationID;
        
        /// <remarks/>
        public string Level1Abreviation;
        
        /// <remarks/>
        public string Level1Description;
        
        /// <remarks/>
        public string Level2Abreviation;
        
        /// <remarks/>
        public string Level2Description;
        
        /// <remarks/>
        public string Level3Abreviation;
        
        /// <remarks/>
        public string Level3Description;
        
        /// <remarks/>
        public string Level4Abreviation;
        
        /// <remarks/>
        public string Level4Description;
        
        /// <remarks/>
        public string Level5Abreviation;
        
        /// <remarks/>
        public string Level5Description;
    }
    
    /// <remarks/>
    [XmlType(Namespace="http://tempuri.org/")]
    public class stRegistry {
        
        /// <remarks/>
        public long RegistryID;
        
        /// <remarks/>
        public stBook Book;
        
        /// <remarks/>
        public long Year;
        
        /// <remarks/>
        public long Number;
        
        /// <remarks/>
        public DateTime RegistryDate;
        
        /// <remarks/>
        public string Subject;
        
        /// <remarks/>
        public string Observations;
        
        /// <remarks/>
        public string Reference;
        
        /// <remarks/>
        public stDocumentType DocumentType;
        
        /// <remarks/>
        public DateTime DocumentDate;
        
        /// <remarks/>
        public stClassification Classification;
        
        /// <remarks/>
        public stEntity Entity;
        
        /// <remarks/>
        [XmlArrayItem(IsNullable=false)]
        public stEntity[] MoreEntities;
        
        /// <remarks/>
        [XmlArrayItem(IsNullable=false)]
        public stKeyword[] Keywords;
        
        /// <remarks/>
        [XmlArrayItem(IsNullable=false)]
        public stDynamicField[] DynamicFields;
        
        /// <remarks/>
        [XmlArrayItem(IsNullable=false)]
        public stDistribution[] Distributions;
        
        /// <remarks/>
        [XmlArrayItem(IsNullable=false)]
        public stFile[] Files;
        
        /// <remarks/>
        public long PreviousRegistry;
        
        /// <remarks/>
        public Double Value;
        
        /// <remarks/>
        public string Coin;
        
        /// <remarks/>
        public string Quote;
        
        /// <remarks/>
        public string Process;
        
        /// <remarks/>
        public string Block;
        
        /// <remarks/>
        public stUser User;
        
        /// <remarks/>
        public stUser ModifyingUser;
        
        /// <remarks/>
        public DateTime ModifyingDate;
    }
    
    /// <remarks/>
    [XmlType(Namespace="http://tempuri.org/")]
    public class stBook {
        
        /// <remarks/>
        public long BookID;
        
        /// <remarks/>
        public string BookAbreviation;
        
        /// <remarks/>
        public string BookDescription;
    }
    
    /// <remarks/>
    [XmlType(Namespace="http://tempuri.org/")]
    public class stDocumentType {
        
        /// <remarks/>
        public long DocumentTypeID;
        
        /// <remarks/>
        public string DocumentTypeAbreviation;
        
        /// <remarks/>
        public string DocumentTypeDescription;
    }
    
    /// <remarks/>
    [XmlType(Namespace="http://tempuri.org/")]
    public class stUser {
        
        /// <remarks/>
        public long UserID;
        
        /// <remarks/>
        public string UserLogin;
        
        /// <remarks/>
        public string UserDescription;
        
        /// <remarks/>
        public string UserMail;
        
        /// <remarks/>
        public long PrimaryGroupID;
        
        /// <remarks/>
        [XmlElement(DataType="base64Binary")]
        public Byte[] UserRoles;
    }
    
    /// <remarks/>
    [XmlType(Namespace="http://tempuri.org/")]
    public class stGroup {
        
        /// <remarks/>
        public long GroupID;
        
        /// <remarks/>
        public string Description;
    }
    
    /// <remarks/>
    [XmlType(Namespace="http://tempuri.org/")]
    public class stContact {
        
        /// <remarks/>
        public long ContactID;
        
        /// <remarks/>
        public long FieldID;
        
        /// <remarks/>
        public string FieldValue;
    }
    
    /// <remarks/>
    [XmlType(Namespace="http://tempuri.org/")]
    public class stFieldsStruct {
        
        /// <remarks/>
        public long FieldID;
        
        /// <remarks/>
        public enumAddressesFieldType FieldType;
        
        /// <remarks/>
        public string FieldValue;
    }
    
    /// <remarks/>
    [XmlType(Namespace="http://tempuri.org/")]
    public enum enumAddressesFieldType {
        
        /// <remarks/>
        FieldTypeString,
        
        /// <remarks/>
        FieldTypeNumeric,
        
        /// <remarks/>
        FieldTypeFloat,
        
        /// <remarks/>
        FieldTypeDate,
        
        /// <remarks/>
        FieldTypeDateTime,
        
        /// <remarks/>
        FieldTypeText,
        
        /// <remarks/>
        FieldTypeSet,
        
        /// <remarks/>
        FieldTypeBoolean,
    }
    
    /// <remarks/>
    [XmlType(Namespace="http://tempuri.org/")]
    public enum enumAddressesRoles {
        
        /// <remarks/>
        Search,
        
        /// <remarks/>
        Modify,
        
        /// <remarks/>
        Manage,
        
        /// <remarks/>
        Count,
    }
    
    /// <remarks/>
    [XmlType(Namespace="http://tempuri.org/")]
    public enum enumObjectType {
        
        /// <remarks/>
        OBJ_TABLE_BOOKS,
        
        /// <remarks/>
        OBJ_TABLE_REGISTRY,
        
        /// <remarks/>
        OBJ_PRODUCT_REGISTRY,
        
        /// <remarks/>
        OBJ_PRODUCT_WKF_DISTRIB,
        
        /// <remarks/>
        OBJ_APPLICATION,
        
        /// <remarks/>
        OBJ_PRODUCT_OWFLOW,
    }
}