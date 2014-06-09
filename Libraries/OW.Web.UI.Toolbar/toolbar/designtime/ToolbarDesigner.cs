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
using System.Web.UI.Design;

namespace OW.Web.UI.Toolbar.Design
{
	/// <summary>
	/// Zusammenfassung für ToolbarDesigner.
	/// </summary>
	public class ToolbarDesigner : ControlDesigner
	{

		public ToolbarDesigner()
		{
		}


    public override string GetDesignTimeHtml()
    {
      Toolbar toolbar = this.Component as Toolbar;
      if (toolbar.Items.Count == 0)
      {
        return CreatePlaceHolderDesignTimeHtml("Add Toolbar Items...");
      }
      else
      {
        return base.GetDesignTimeHtml();
      }
    }


    protected override string GetErrorDesignTimeHtml(Exception e)
    {
      string pattern = "Error while creating design time HTML:<br/>{0}";
      return String.Format(pattern, e.Message);
    }




	}
}
