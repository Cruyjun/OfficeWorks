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
using System.ComponentModel;
using System.Drawing.Design;
using System.Web.UI;
using System.Web.UI.Design;
using System.Web.UI.WebControls;

namespace OW.Web.UI.Toolbar
{
	/// <summary>
	/// Renders a plain image with optional rollovers and
	/// disabling state but no further functionality.
	/// </summary>
	public class ToolbarImage : LabeledToolbarItem, IImageItem
	{

		#region properties


		/// <summary>
		/// Whether the item shall render HTML tags that have been marked
		/// as deprecated in XHTML strict. This applies to <c>align</c> or
		/// <c>border</c> attributes that should be set via CSS.
		/// </summary>
		[NotifyParentProperty(true)]
		[Category("Toolbar")]
		[DefaultValue(false)]
		[Description("Whether to render XHTML deprecated tags (border, align, ...).")]
		public virtual bool RenderDeprecatedTags
		{
			get
			{ 
				if (ViewState["RenderDeprecatedTags"] == null)
					return false;
				else
					return (bool)ViewState["RenderDeprecatedTags"]; 
			}
			set { ViewState["RenderDeprecatedTags"] = value; }
		}


		/// <summary>
		/// The image to be rendered by the item.
		/// </summary>
		[NotifyParentProperty(true)]
		[Category("Toolbar")]
		[DefaultValue("")]
		[Editor(typeof(ImageUrlEditor), typeof(UITypeEditor))]
		[Localizable(true)]
		public string ImageUrl
		{
			get
			{ 
				string url = (string)this.ViewState["ImageUrl"];
				return url == null ? String.Empty : url;
			}
			set { ViewState["ImageUrl"] = value; }
		}


		/// <summary>
		/// An optional image which is displayed if
		/// the item's state is set to
		/// <see cref="ToolbarItemState.Disabled"/>.
		/// If not set, the standard image is being used.
		/// </summary>
		[NotifyParentProperty(true)]
		[Category("Toolbar")]
		[DefaultValue("")]
		[Editor(typeof(ImageUrlEditor), typeof(UITypeEditor))]
		[Localizable(true)]
		public string DisabledImageUrl
		{
			get
			{ 
				string url = (string)this.ViewState["DisImageUrl"];
				return url == null ? String.Empty : url;
			}
			set { ViewState["DisImageUrl"] = value; }
		}


		/// <summary>
		/// An optional image which is displayed if
		/// the user moves the mouse over the item.
		/// If not set, the standard image is being used.
		/// </summary>
		[NotifyParentProperty(true)]
		[Category("Toolbar")]
		[DefaultValue("")]
		[Editor(typeof(ImageUrlEditor), typeof(UITypeEditor))]
		[Localizable(true)]
		public string RollOverImageUrl
		{
			get
			{ 
				string url = (string)this.ViewState["rollOverUrl"];
				return url == null ? String.Empty : url;
			}
			set { ViewState["rollOverUrl"] = value; }
		}


		/// <summary>
		/// Determines whether rollover support scripts
		/// are needed or not.
		/// </summary>
		protected virtual bool RenderRollOverScripts
		{
			get { return !this.RenderDisabled && this.RollOverImageUrl != String.Empty; }
		}

		#endregion


		#region initialization

		/// <summary>
		/// Inits the control.
		/// </summary>
		public ToolbarImage()
		{
		}

		#endregion


		#region prerender and javascript

		/// <summary>
		/// Handles JavaScript registration.
		/// </summary>
		/// <param name="e"></param>
		protected override void OnPreRender(EventArgs e)
		{
			//register rollover client script
			if (this.RenderRollOverScripts) 
			{
				RollOverHandler.RegisterRollOverScript(this);
			}

			base.OnPreRender (e);
		}

		#endregion


		#region rendering

		/// <summary>
		/// Renders the item.
		/// </summary>
		/// <param name="writer"></param>
		protected override void Render(HtmlTextWriter writer)
		{
			//if now image was set, return (don't care whether it's disabled)
			if (this.ImageUrl == String.Empty) return;

			//if we use rollovers, the item's content is enclosed
			//in html that calls the javascript functinos
			//render rollover scripts
			if (this.RenderRollOverScripts)
				RollOverHandler.RenderRollOverBeginTag(writer, this, ResolveUrl(RollOverImageUrl));


			//if we have a label and an image, this kills the layout if they're
			//in the same cell -> render them in an inner table and separate cells...
			if (this.LabelText != String.Empty && this.LabelTextAlign == TextAlign.Left)
			{
				this.RenderLabel(writer);
			}

			//render content
			this.AddAttributesToRender(writer);

			this.RenderBeginTag(writer);

			//Teste
			//this.RenderLabel(writer);

			this.RenderContents(writer);
	  
			this.RenderEndTag(writer);

			//render label text after the image
			if (this.LabelText != String.Empty && this.LabelTextAlign == TextAlign.Right)
			{
				this.RenderLabel(writer);
			}

			//render rollover end tag
			if (this.RenderRollOverScripts)
				RollOverHandler.RenderRollOverEndTag(writer);

		}


		/// <summary>
		/// Renders the begin tag of the image and (optionally) the
		/// surrounding rollover function calls.
		/// </summary>
		/// <param name="writer"></param>
		public override void RenderBeginTag(HtmlTextWriter writer)
		{
			writer.RenderBeginTag(HtmlTextWriterTag.Img);
		}



		/// <summary>
		/// Renders the attribute of the image.
		/// </summary>
		/// <param name="writer"></param>
		protected override void AddAttributesToRender(HtmlTextWriter writer)
		{
			//render either disabled or standard image
			if (this.RenderDisabled && this.DisabledImageUrl != String.Empty)
				writer.AddAttribute(HtmlTextWriterAttribute.Src, this.ResolveUrl(this.DisabledImageUrl));
			else
				writer.AddAttribute(HtmlTextWriterAttribute.Src, this.ResolveUrl(this.ImageUrl));

			//render border and align as XHTML compliant inline styles
			writer.AddStyleAttribute("vertical-align", "middle");
			writer.AddStyleAttribute("border", "none");

			//delegate to base class
			base.AddAttributesToRender (writer);
		}

		#endregion

	}
}
