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
using System.Web.UI.WebControls;
using System.Web.UI;
using System.ComponentModel;


namespace OW.Web.UI.Toolbar
{
	/// <summary>
	/// Abstract base class for all items of the toolbar.
	/// A toolbar item can be provided with different images
	/// to reflect its <see cref="ToolbarItemState"/> and
	/// supports hover images.
	/// </summary>
	public abstract class ToolbarItem : WebControl, INamingContainer
	{

    #region members

    /// <summary>
    /// The unique ID of the item. Can be used
    /// to determine the selected item on postback
    /// events.
    /// </summary>
    protected string m_itemId = String.Empty;

	//paulo
	/// <summary>
	/// Used for add mouseover event to item cell
	/// </summary>	
	protected string m_itemCellMouseOver = "this.className='cellover';";

	//paulo
	/// <summary>
	/// Used for add mouseout event to item cell
	/// </summary>
	protected string m_itemCellMouseOut = "this.className=null;";
    

    #endregion

    #region properties

    /// <summary>
    /// The unique ID of the item. Can be used
    /// to determine the selected item on postback
    /// events.
    /// </summary>
    [Category("Toolbar")]
    [Description("A user-defined unique ID of the item.")]
    public string ItemId
    {
      get { return m_itemId; }
      set {
        this.m_itemId = value; 
      }
    }

	//paulo
	/// <summary>
	/// The default mouseover event of all toolbar item cells.
	/// </summary>
	[Category("Toolbar")]
	[Description("Default mouseover event of the Toolbar's item cells.")]
	public string ItemCellMouseOver
	{
		get { return m_itemCellMouseOver; }
		set { this.m_itemCellMouseOver = value; }
	}

	//paulo
	/// <summary>
	/// The default mouseout event of all toolbar item cells.
	/// </summary>
	[Category("Toolbar")]
	[Description("Default mouseout event of the Toolbar's item cells.")]
	public string ItemCellMouseOut
	{
		get { return m_itemCellMouseOut; }
		set { this.m_itemCellMouseOut = value; }
	}

    /// <summary>
    /// Whether the item shall be rendered disabled or not. If this
    /// property is <c>true</c>, the disabled image is rendered
    /// rather than the standard one and no further functionality
    /// is available (tooltips, rollovers etc.).
    /// </summary>
    [NotifyParentProperty(true)]
    [Category("Toolbar")]
    [DefaultValue(false)]
    [Description("Whether the item should be rendered disabled or not.")]
    public virtual bool RenderDisabled
    {
      get
      { 
        if (ViewState["Disabled"] == null)
          return false;
        else
          return (bool)ViewState["Disabled"]; 
      }
      set { ViewState["Disabled"] = value; }
    }


    /// <summary>
    /// The width (horizontal toolbar) or height (vertical toolbar)
    /// of a cell that contains a <see cref="ToolbarItem"/>.
    /// </summary>
    [Category("Toolbar")]
    [Description("Width or height of the item cell (depending on Toolbar orientation).")]
    [Localizable(true)]
    public Unit ItemCellDistance
    {
      get
      { 
        object obj = this.ViewState["ItemCellWidth"];
        return obj == null ? Unit.Empty : (Unit)obj;
      }
      set { ViewState["ItemCellWidth"] = value; }
    }


	/// <summary>
	/// Horizontal alignment of the item within its cell
	/// </summary>
    [NotifyParentProperty(true)]
    [Category("Toolbar")]
    [DefaultValue(HorizontalAlign.Center)]
    [Description("Horizontal alignment of the item within its cell.")]
    public HorizontalAlign HorizontalAlign
    {
      get
      { 
        object obj = this.ViewState["HorizontalAlign"];
        return obj == null ? HorizontalAlign.Center : (HorizontalAlign)obj;
      }
      set { ViewState["HorizontalAlign"] = value; }
    }

	/// <summary>
	/// Vertical alignment of the item within its cell
	/// </summary>
    [NotifyParentProperty(true)]
    [Category("Toolbar")]
    [DefaultValue(VerticalAlign.Middle)]
    [Description("Vertical alignment of the item within its cell.")]
    public VerticalAlign VerticalAlign
    {
      get
      { 
        object obj = this.ViewState["VerticalAlign"];
        return obj == null ? VerticalAlign.Middle : (VerticalAlign)obj;
      }
      set { ViewState["VerticalAlign"] = value; }
    }


    /// <summary>
    /// Determines whether the control is in design mode or not.
    /// </summary>
    protected bool IsDesignMode
    {
      get { return System.Web.HttpContext.Current == null; }
    }

    #endregion

    #region initialization

    /// <summary>
    /// Empty default constructor.
    /// </summary>
    public ToolbarItem()
    {
    }

    /// <summary>
    /// Constructs an item which is renderd as a specific
    /// HTML tag.
    /// </summary>
    /// <param name="tag">Html tag of the item control.</param>
    public ToolbarItem(HtmlTextWriterTag tag) : base(tag)
    {
    }

    #endregion

	}
}
