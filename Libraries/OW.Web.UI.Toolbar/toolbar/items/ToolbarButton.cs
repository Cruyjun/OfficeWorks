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
using System.Web.UI;

namespace OW.Web.UI.Toolbar
{
	/// <summary>
	/// Renders an image button which posts back to its parent form.
	/// </summary>
	public class ToolbarButton : ToolbarImage, IPostBackDataHandler
	{


		#region Initialization

		/// <summary>
		/// Empty default constructor.
		/// </summary>
		public ToolbarButton()
		{
		}

		#endregion


		#region prerender

		/// <summary>
		/// Registers a postback handler.
		/// </summary>
		/// <param name="e"></param>
		/// <remarks>
		/// PostBack is being submitted with coordinates so the
		/// submitted key doesn't match the control's ID
		/// -> explicit postback notification needed.
		/// </remarks>
		protected override void OnPreRender(EventArgs e)
		{
			if(this.Page != null)
			{
				this.Page.RegisterRequiresPostBack(this);
			}

			base.OnPreRender(e);
		}

		#endregion


		#region rendering

		/// <summary>
		/// Renders the begin tag of an image button, if the item
		/// is enabled.
		/// </summary>
		/// <param name="writer"></param>
		public override void RenderBeginTag(HtmlTextWriter writer)
		{
			if (this.RenderDisabled)
			{
				//render a standard image
				base.RenderBeginTag(writer);
			}
			else
			{
				//render an <input> tag
				//writer.RenderBeginTag(HtmlTextWriterTag.Input);
				writer.RenderBeginTag(HtmlTextWriterTag.Img);
			}
		}



		/// <summary>
		/// Adds image button specific attributes to the output.
		/// </summary>
		/// <param name="writer"></param>
		protected override void AddAttributesToRender(HtmlTextWriter writer)
		{
			if(!this.RenderDisabled)
			{
				//-------------------------------------------------------
				//O evento click passou para a celula da toolbar
				//-------------------------------------------------------
				/*
				string onclick = string.Empty;

				//------------------------------------------------------------------------
				// Caso esteja definido Client Script para o botão, vamos coloca-lo no evento onclick
				//------------------------------------------------------------------------
				if (this.ClientScript.Trim() != string.Empty) onclick += this.ClientScript;

				//------------------------------------------------------------------------
				// Caso esteja definido CauseValidation para o botão, vamos coloca-lo no evento onclick
				//------------------------------------------------------------------------
				if (this.CauseValidation) onclick += "if (typeof(Page_ClientValidate) == 'function') Page_ClientValidate();";
		 
				//ricardo -----
				if(onclick.Trim().Length!=0)
				 writer.AddAttribute(HtmlTextWriterAttribute.Onclick, onclick);
				//-------
				*/

				//-------------------------------------------------------
				//A imagem deixou de ser do tipo input type=image e passou para <img>
				//-------------------------------------------------------
				//writer.AddAttribute(HtmlTextWriterAttribute.Type, "image");
				writer.AddAttribute(HtmlTextWriterAttribute.Id, this.UniqueID);
				writer.AddAttribute(HtmlTextWriterAttribute.Name, this.UniqueID);
				uid =  this.UniqueID;
			}

			base.AddAttributesToRender(writer);
		}

		#endregion
	}
}
