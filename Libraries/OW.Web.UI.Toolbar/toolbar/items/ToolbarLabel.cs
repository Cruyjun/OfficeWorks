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
using System.Web.UI;

namespace OW.Web.UI.Toolbar
{
	/// <summary>
	/// Renders a simple label.
	/// </summary>
	public class ToolbarLabel : ToolbarItem
	{

    [Description("Rendered text")]
    [Category("Toolbar")]
    [DefaultValue("")]
    [Localizable(true)]
    public string Text
    {
      get
      { 
        string text = (string)this.ViewState["ItemText"];
        return text == null ? String.Empty : text;
      }
      set { ViewState["ItemText"] = value; }
    }


    /// <summary>
    /// Empty default constructor.
    /// </summary>
    public ToolbarLabel() : base(HtmlTextWriterTag.Span)
    {
    }


    /// <summary>
    /// Renders the item's <see cref="Text"/> to the client.
    /// </summary>
    /// <param name="writer"></param>
    protected override void RenderContents(HtmlTextWriter writer)
    {
      writer.Write(this.Text);
      base.RenderContents (writer);
    }

	}
}
