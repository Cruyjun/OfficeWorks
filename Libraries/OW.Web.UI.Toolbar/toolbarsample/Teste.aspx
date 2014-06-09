<%@ Page language="c#" Codebehind="Teste.aspx.cs" AutoEventWireup="false" Inherits="ToolbarSample.Teste" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Teste</title>
		<meta name="GENERATOR" Content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" Content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
	</HEAD>
	<body>
		<form id="Form1" method="post" runat="server">
			<P>
				<asp:Button id="Button1" runat="server" Text="CauseValidation=True"></asp:Button>&nbsp;
				<asp:Button id="Button2" runat="server" Text="CauseValidation=False" CausesValidation="False"></asp:Button></P>
			<P>
				<asp:TextBox id="TextBox1" runat="server"></asp:TextBox>
				<asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ErrorMessage="RequiredFieldValidator"
					ControlToValidate="TextBox1">*</asp:RequiredFieldValidator></P>
			<P>
				<asp:ImageButton id="ImageButton1" runat="server" CausesValidation="False"></asp:ImageButton></P>
			<P>
				<asp:ValidationSummary id="ValidationSummary1" runat="server"></asp:ValidationSummary></P>
		</form>
	</body>
</HTML>
