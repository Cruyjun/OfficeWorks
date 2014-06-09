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

using System.Web.UI;

namespace OW.Web.UI.Toolbar
{
	/// <summary>
	/// Provides a container item for arbitrary controls
	/// which can be added programmatically.
	/// </summary>
	public class ControlContainerItem : ToolbarItem
	{

    /// <summary>
    /// Empty default constructor.
    /// </summary>
		public ControlContainerItem()
		{
		}


    #region rendering

    /// <summary>
    /// Prevents rendering of the control itself.
    /// </summary>
    /// <param name="writer"></param>
    public override void RenderBeginTag(HtmlTextWriter writer)
    {
      //don't render anything
    }

    /// <summary>
    /// Prevents rendering of the control itself.
    /// </summary>
    /// <param name="writer"></param>
    public override void RenderEndTag(HtmlTextWriter writer)
    {
      //don't render anything
    }

    /// <summary>
    /// Renders a simple placeholder in design mode.
    /// </summary>
    /// <param name="writer"></param>
    protected override void Render(HtmlTextWriter writer)
    {
      if (this.IsDesignMode)
      {
        writer.Write("<span style=font-size:10px;color:blue;font-family:arial>[ .. ]</span>");
      }
      else
      {
        base.Render (writer);
      }
    }

    #endregion

	}
}
