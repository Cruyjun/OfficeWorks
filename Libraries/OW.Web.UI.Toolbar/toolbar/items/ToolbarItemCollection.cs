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
using System.Collections;
using System.ComponentModel;
using System.Drawing.Design;
using OW.Web.UI.Toolbar.Design;

namespace OW.Web.UI.Toolbar
{
	/// <summary>
	/// Maintains a collection of <see cref="ToolbarItem"/>
	/// objects.
	/// </summary>
  [Editor(typeof(ItemCollectionEditor), typeof(UITypeEditor))]
	public class ToolbarItemCollection : CollectionBase
	{

    /// <summary>
    /// Raised if an item is was added.
    /// </summary>
    public event ItemEventHandler ItemAdded;

    /// <summary>
    /// Raised if an item was removed.
    /// </summary>
    public event ItemEventHandler ItemRemoved;

    /// <summary>
    /// Raised if the controls were removed.
    /// </summary>
    public event EventHandler ItemsCleared;


		public ToolbarItemCollection()
		{
		}

    protected override void OnRemoveComplete(int index, object value)
    {
      if (ItemRemoved != null) ItemRemoved(value as ToolbarItem);

      base.OnRemoveComplete (index, value);
    }


    protected override void OnInsertComplete(int index, object value)
    {
      if (ItemAdded != null) ItemAdded(value as ToolbarItem);

      base.OnInsertComplete (index, value);
    }

    protected override void OnClear()
    {
      if (ItemsCleared != null) ItemsCleared(this, null);
      base.OnClear ();
    }




    /// <summary>
    /// Gets a toolbar item by its unique
    /// item ID.
    /// </summary>
    public ToolbarItem this[string itemId]
    {
      get 
      {
        foreach (ToolbarItem item in this.List)
        {
          if (item.ItemId == itemId) return item;
        }

        return null;   
      }
    }


    /// <summary>
    /// Adds an item to the list.
    /// </summary>
    /// <param name="item"></param>
    public void Add(ToolbarItem item)
    {
      if (item.ItemId == String.Empty) item.ItemId = item.ID;
      this.List.Add(item);
    }



    /// <summary>
    /// Adds an item at a given position.
    /// </summary>
    /// <param name="index">Zero-based index of the item.</param>
    /// <param name="item">Item to be added.</param>
    public void Insert(int index, ToolbarItem item)
    {
      this.List.Insert(index, item);
    }


    /// <summary>
    /// Gets the index of a toolbar item.
    /// </summary>
    /// <param name="item"></param>
    /// <returns></returns>
    public int IndexOf(ToolbarItem item)
    {
      return this.List.IndexOf(item);
    }


    public int IndexOf(string itemId)
    {
      ToolbarItem item = this[itemId];
      if (item == null)
      {
        return -1;
      }
      else
      {
        return this.IndexOf(item);
      }
    }



    /// <summary>
    /// Removes an item from the toolbar.
    /// </summary>
    /// <param name="itemId">The unique
    /// <see cref="ToolbarItem.ItemId"/> of the
    /// item.</param>
    public void RemoveItem(string itemId)
    {
      ToolbarItem item = this[itemId];
      if (item != null) this.List.Remove(item);
    }


  }
}
