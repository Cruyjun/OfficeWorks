// Evolve Toolbar
// Copyright (c) 2005 Evolve Software Technologies
// http://www.evolvesoftware.ch
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.
// 
// This software is provided "AS IS" with no warranties of any kind.
// The entire risk arising out of the use or performance of the software
// and source code is with you.
//
// THIS NOTICE MAY NOT BE REMOVED FROM THIS FILE.

using System;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace OW.Web.UI.Toolbar
{
	/// <summary>
	/// Extends the default item by an additional label.
	/// </summary>
	public abstract class LabeledToolbarItem : ToolbarItem, IPostBackToolbarItem,IPostBackDataHandler
	{


    
		#region Event declaration

		/// <summary>
		/// Raised if the item is being clicked.
		/// </summary>
		public event ItemEventHandler ItemSubmitted;

		#endregion


		private string _uid;

		/// <summary>
		/// Script cliente associado ao botão
		/// </summary>
		public string uid 
		{
			get 
			{
				if (this._uid == null) this._uid = string.Empty;

				return this._uid;
			}
			set 
			{
				this._uid = value;
			}
		}
    
		#region Propriedades

		/// <summary>
		/// Script cliente associado ao botão
		/// </summary>
		private string clientScript;

		/// <summary>
		/// Script cliente associado ao botão
		/// </summary>
		public string ClientScript 
		{
			get 
			{
				if (this.clientScript == null) this.clientScript = string.Empty;

				return this.clientScript;
			}
			set 
			{
				this.clientScript = value;
			}
		}

		/// <summary>
		/// Indica se o botão provoca a validação da página
		/// </summary>
		private bool causeValidation;

		/// <summary>
		/// Indica se o botão provoca a validação da página
		/// </summary>
		public bool CauseValidation 
		{
			get 
			{
				return this.causeValidation;
			}
			set 
			{
				this.causeValidation = value;
			}
		}


		/// <summary>
		/// Text of an additional label.
		/// </summary>
		[NotifyParentProperty(true)]
		[Category("ToolbarItem Label")]
		[DefaultValue("")]
		[Description("Optional text for an additional label")]
		[Localizable(true)]
		public string LabelText
		{
			get
			{ 
				string text = (string)this.ViewState["LabelText"];
				return text == null ? String.Empty : text;
			}
			set { ViewState["LabelText"] = value; }
		}


		/// <summary>
		/// Whether the label shall be aligned on the right or left
		/// hand side of the item's main object (e.g. an image).
		/// </summary>
		[NotifyParentProperty(true)]
		[Category("ToolbarItem Label")]
		[DefaultValue(TextAlign.Right)]
		[Description("Alignment of the label text")]
		public TextAlign LabelTextAlign
		{
			get
			{ 
				object obj = this.ViewState["ItemTextAlign"];
				return obj == null ? TextAlign.Right : (TextAlign)obj;
			}
			set { ViewState["ItemTextAlign"] = value; }
		}


		/// <summary>
		/// Whether the label shall be aligned on the right or left
		/// hand side of the item's main object (e.g. an image).
		/// </summary>
		[NotifyParentProperty(true)]
		[Category("ToolbarItem Label")]
		[DefaultValue(VerticalAlign.Middle)]
		[Description("Vertical alignment of the label to the main item.")]
		public VerticalAlign LabelTextVerticalAlign
		{
			get
			{ 
				object obj = this.ViewState["LabelTextVerticalAlign"];
				return obj == null ? VerticalAlign.Middle : (VerticalAlign)obj;
			}
			set { ViewState["LabelTextVerticalAlign"] = value; }
		}



		/// <summary>
		/// A CSS style to assign to the label.
		/// </summary>
		[NotifyParentProperty(true)]
		[Category("ToolbarItem Label")]
		[DefaultValue("")]
		[Description("CSS class of the item label.")]
		public string LabelCssClass
		{
			get
			{ 
				string text = (string)this.ViewState["LabelCssClass"];
				return text == null ? String.Empty : text;
			}
			set { ViewState["LabelCssClass"] = value; }
		}

		#endregion


		#region rendering

		/// <summary>
		/// Renders the label within HTML <c>span</c> tags and optional
		/// CSS class settings.
		/// </summary>
		/// <param name="writer"></param>
		protected virtual void RenderLabel(HtmlTextWriter writer)
		{
			//don't render anything if there is no label text...
			if (this.LabelText == String.Empty) return;

			//enter vertical alignment - default is middle
			string valign = "middle";
			if (this.LabelTextVerticalAlign == VerticalAlign.Top)
				valign = "top";
			else if (this.LabelTextVerticalAlign == VerticalAlign.Bottom)
				valign = "bottom";

			//render style
			writer.AddStyleAttribute("vertical-align", valign);

			if (this.LabelCssClass != String.Empty)
			{
				writer.AddAttribute(HtmlTextWriterAttribute.Class, this.LabelCssClass);
			}

			//-------------------------------------------------------
			//O evento click passou para a celula da toolbar
			//-------------------------------------------------------
			/*
			// Marcelo Taveira
			string onclick = string.Empty;
			string postback = Page.GetPostBackEventReference(this);
			if (this.ClientScript.Trim() != string.Empty) onclick += this.ClientScript;

			//trocar "return xpto();" por "if(!xpto())return;"
			if(onclick.ToLower().IndexOf("return") >= 0)
			{
				int indexRet = onclick.ToLower().IndexOf("return");
				onclick = onclick.Remove(indexRet,6);
				onclick = onclick.Insert(indexRet,"if(!");
				indexRet = onclick.LastIndexOf(";");
				if(indexRet >=0)
				{
					onclick = onclick.Remove(indexRet,1);
				}
				onclick += ")return;";
			}
      
			if (this.CauseValidation) onclick += "if (typeof(Page_ClientValidate) == 'function'){ if(Page_ClientValidate()){"
										  + postback +"}} else {"+postback+"}";
      
			else onclick += postback;

			if(onclick.Trim().Length!=0)
				writer.AddAttribute(HtmlTextWriterAttribute.Onclick, onclick);
        
			writer.AddStyleAttribute("CURSOR", "hand");

			writer.AddAttribute(HtmlTextWriterAttribute.Name, this.UniqueID);
			writer.AddAttribute(HtmlTextWriterAttribute.Id, this.UniqueID.Replace(":","_"));

			writer.AddAttribute("value",this.LabelText);
			// BT - End
			*/
			//-------------------------------------------------------

			writer.RenderBeginTag(HtmlTextWriterTag.Span);
			writer.Write(this.LabelText);
			writer.RenderEndTag();

		}

		#endregion

    

		#region postback data handling
		/// <summary>
		/// Raises the control's event.
		/// </summary>
		public void RaisePostDataChangedEvent() 
		{
			//trigger page validation
			if(this.causeValidation)
				Page.Validate();

			//bubble event
			if (this.ItemSubmitted != null) ItemSubmitted(this);
		}

		/// <summary>
		/// Checks whether the button was clicked or not.
		/// </summary>
		/// <param name="postDataKey"></param>
		/// <param name="postCollection"></param>
		/// <returns></returns>
		public bool LoadPostData(string postDataKey, NameValueCollection postCollection) 
		{
			//image buttons are being submitted with their coordinates
			string x = postCollection[this.UniqueID + ".x"];
			string y = postCollection[this.UniqueID + ".y"];
      
			return ((x != null && y != null && x.Length > 0 && y.Length > 0) || 
				this.UniqueID == postCollection["__EVENTTARGET"].ToString()) ;
			//&& Page.IsValid;
		}

		#endregion

	}
}
