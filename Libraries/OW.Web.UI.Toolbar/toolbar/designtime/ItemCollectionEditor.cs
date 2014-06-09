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
using System.ComponentModel.Design;

namespace OW.Web.UI.Toolbar.Design
{
	/// <summary>
	/// Provides designer support for the toolbar's items.
	/// </summary>
	public class ItemCollectionEditor : CollectionEditor
	{


    /// <summary>
    /// Empty default constructor.
    /// </summary>
    /// <param name="type"></param>
    public ItemCollectionEditor(Type type) : base(type)
    { }



    /// <summary>
    /// Provides a list of available item types.
    /// </summary>
    /// <returns>List of <see cref="ToolbarItem"/> objects.</returns>
    protected override Type[] CreateNewItemTypes()
    {
      return new Type[]
      {
        typeof(ToolbarLink),
        typeof(ToolbarButton),
        typeof(ToolbarImage),
        typeof(ToolbarTextBox),
        typeof(ToolbarLabel),
        typeof(ToolbarSeparator),
        typeof(ControlContainerItem),
      };
    }


	}
}
