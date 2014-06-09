<%@ Page language="c#" Codebehind="WebForm2.aspx.cs" AutoEventWireup="false" Inherits="ToolbarSample.WebForm2" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>WebForm2</title>
		<meta name="GENERATOR" Content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" Content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
	</HEAD>
	<body>
		<form id="Form1" method="post" runat="server">
			<asp:ValidationSummary id="ValidationSummary1" runat="server"></asp:ValidationSummary>
			<P>
				<asp:TextBox id="TextBox1" runat="server"></asp:TextBox>
				<asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ErrorMessage="Tá mal" ControlToValidate="TextBox1">*</asp:RequiredFieldValidator>
				<asp:Button id="Button1" runat="server" Text="Button"></asp:Button></P>
			<P>&nbsp;</P>
		</form>
	</body>
</HTML>
