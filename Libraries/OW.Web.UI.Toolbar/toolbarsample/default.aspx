<%@ Register TagPrefix="etc" Namespace="OW.Web.UI.Toolbar" Assembly="OW.Web.UI.Toolbar" %>
<%@ Page language="c#" Codebehind="default.aspx.cs" AutoEventWireup="false" Inherits="ToolbarSample._default" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>default</title>
		<meta name="GENERATOR" Content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" Content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
	</HEAD>
	<script>
	function xpto(){
		alert('aa');
		return true;
	}
	function xpto2(){
		confirm('shure');
	}	
	</script>
	<body>
		<form id="Form1" method="post" runat="server">
			<P>
				<etc:Toolbar id="Toolbar1" runat="server">
					<etc:ToolbarButton uid="Toolbar1:toolbarButton1" ClientScript="return xpto();" ImageUrl="Design/Image/ActionBar/Back.gif"
						LabelText="sem val" CauseValidation="true" ID="toolbarButton1" ItemCellMouseOver="this.className='cellover';"
						ItemId="toolbarButton1" ItemCellMouseOut="this.className=null;" ItemCellDistance=""></etc:ToolbarButton>
					<etc:ToolbarButton uid="Toolbar1:toolbarButton2" ClientScript="xpto2();return xpto();" ImageUrl="Design/Image/ActionBar/Continue.gif"
						LabelText="com val" CauseValidation="True" ID="toolbarButton2" ItemCellMouseOver="this.className='cellover';"
						ItemId="toolbarButton2" ItemCellMouseOut="this.className=null;" ItemCellDistance=""></etc:ToolbarButton>
					<etc:ToolbarButton uid="Toolbar1:toolbarButton3" ClientScript="return xpto2();" ImageUrl="Design/Image/ActionBar/Continue.gif"
						LabelText="com val" CauseValidation="True" ID="toolbarButton3" ItemCellMouseOver="this.className='cellover';"
						ItemId="toolbarButton2" ItemCellMouseOut="this.className=null;" ItemCellDistance=""></etc:ToolbarButton>
				</etc:Toolbar></P>
			<P>
				<asp:ValidationSummary id="ValidationSummary1" runat="server"></asp:ValidationSummary>
				<asp:Button id="Button1" runat="server" Text="Button"></asp:Button></P>
			<P>
				<asp:TextBox id="TextBox1" runat="server"></asp:TextBox>
				<asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ErrorMessage="RequiredFieldValidator"
					ControlToValidate="TextBox1">*</asp:RequiredFieldValidator></P>
			<P><INPUT id="Toolbar1_toolbarButton1" style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; VERTICAL-ALIGN: middle; BORDER-LEFT: medium none; BORDER-BOTTOM: medium none"
					onclick="" type="image" src="/toolbarsample/Design/Image/ActionBar/Back.gif" name="Toolbar1:toolbarButton1"></P>
		</form>
	</body>
</HTML>
