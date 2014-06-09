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
using System.Resources;
using System.Reflection;


namespace OW.Web.UI.Toolbar
{
	/// <summary>
	/// Handles JavaScripts for items that provide rollover images.
	/// </summary>
	public class RollOverHandler
	{

    /// <summary>
    /// Renders the beginning tag of an element that encloses an image
    /// that support JavaScript rollovers.
    /// </summary>
    /// <param name="writer">Streams output to the client.</param>
    /// <param name="imageControl">The control that hosts an image which
    /// will be replaced on rollover.</param>
    /// <param name="rollOverImageUrl">URL of the rollover image.</param>
    public static void RenderRollOverBeginTag(HtmlTextWriter writer, Control imageControl, string rollOverImageUrl)
    {
      //create rollover function call
      string js = "swapImage('{0}','','{1}',1);";
      js = String.Format(js, GetImageId(imageControl), rollOverImageUrl);

      //add function calls as attributes
      writer.AddAttribute("onMouseOver", js);
      writer.AddAttribute("onMouseOut", "restoreImage();");

      //render the begin tag
      writer.RenderBeginTag(HtmlTextWriterTag.Span);
    }


    /// <summary>
    /// Renders the end tag of the surrounding Rollover handler. Assumes
    /// <see cref="RenderRollOverBeginTag"/> has been called before.
    /// </summary>
    /// <param name="writer"></param>
    public static void RenderRollOverEndTag(HtmlTextWriter writer)
    {
      writer.RenderEndTag();
    }



    /// <summary>
    /// Registers the rollover JavaScript with the currently rendered page.
    /// </summary>
    public static void RegisterRollOverScript(Control renderedControl)
    {
      Page page = renderedControl.Page;

      //register rollover scripts
      if ( !page.IsClientScriptBlockRegistered("Toolbar_RollOvers")) 
      {
        ResourceManager manager = new ResourceManager("OW.Web.UI.Toolbar.JavaScript", Assembly.GetExecutingAssembly());
        String script = manager.GetResourceSet(System.Globalization.CultureInfo.CurrentCulture, true, true).GetString("LibraryScript");
        page.RegisterClientScriptBlock("Toolbar_Rollovers", script );
      }
		

      //register initialization script that registers the rollover images
      if ( !page.IsStartupScriptRegistered("Toolbar_RollOver_Init"))
      {
        ResourceManager manager = new ResourceManager("OW.Web.UI.Toolbar.JavaScript", Assembly.GetExecutingAssembly());
        String script = manager.GetResourceSet(System.Globalization.CultureInfo.CurrentCulture, true, true).GetString("InitScript");
        page.RegisterStartupScript("Toolbar_RollOver_Init", script );
      }
		  
      page.RegisterArrayDeclaration("Toolbar_RollOverImages", String.Format("'{0}'", GetImageId(renderedControl)));
    }


    #region image ID

    /// <summary>
    /// Gets the ID of a rendered image control.
    /// </summary>
    /// <returns>Returns the <c>ClientID</c> of the current
    /// control.</returns>
    /// <remarks>Can be overridden to return a composite control's
    /// client ID instead.</remarks>
    protected static string GetImageId(Control control)
    {
      return control.ClientID;
    }

    #endregion
	}
}
