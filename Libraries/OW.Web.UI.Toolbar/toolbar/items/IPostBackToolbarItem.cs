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

namespace OW.Web.UI.Toolbar
{
	/// <summary>
	/// Common interface of all toolbar items that
	/// provide postback capabilities.
	/// </summary>
	public interface IPostBackToolbarItem
	{

    /// <summary>
    /// Event which fires if the item is being
    /// submitted.
    /// </summary>
    event ItemEventHandler ItemSubmitted;

	}
}
