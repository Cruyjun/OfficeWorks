<%@ Register TagPrefix="igtxt" Namespace="Infragistics.WebUI.WebDataInput" Assembly="Infragistics.WebUI.WebDataInput.v5.2, Version=5.2.20052.1028, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Page language="c#" Codebehind="WebForm1.aspx.cs" AutoEventWireup="false" Inherits="ToolbarSample.WebForm1" %>
<%@ Register TagPrefix="cc2" Namespace="ToolbarSample" Assembly="OW.Web.UI.Toolbar" %>
<%@ Register TagPrefix="igtbar" Namespace="Infragistics.WebUI.UltraWebToolbar" Assembly="Infragistics.WebUI.UltraWebToolbar.v5.2, Version=5.2.20052.1028, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="etc" Namespace="OW.Web.UI.Toolbar" Assembly="OW.Web.UI.Toolbar" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>WebForm1</title>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
	</HEAD>
	<body style="FONT-SIZE: 8pt; FONT-FAMILY: Tahoma">
		<form id="Form1" method="post" runat="server">
			<P>
				<cc2:ListAction id="ListAction2" runat="server"></cc2:ListAction></P>
			<P>&nbsp;</P>
			<P>&nbsp;</P>
			<P>&nbsp;</P>
			<P>&nbsp;</P>
			<P>&nbsp;</P>
			<P>
				<igtbar:UltraWebToolbar id="UltraWebToolbar1" runat="server">
					<Items>
						<igtbar:TBarButton Text="Ac&#231;&#227;o #1" Image="./Design/Image/ActionBar/Activate.gif"></igtbar:TBarButton>
						<igtbar:TBarButton Text="Ac&#231;&#227;o 2#" Image="./Design/Image/ActionBar/Result.gif"></igtbar:TBarButton>
					</Items>
				</igtbar:UltraWebToolbar></P>
			<P>
				<igtbar:UltraWebToolbar id="UltraWebToolbar2" runat="server" BorderStyle="None" ImageDirectory="/ig_common/images/"
					MovableImage="ig_tb_move03.gif" BackColor="White" BackgroundImage="blueexplorer.gif" ItemWidthDefault="80px"
					Movable="True" ItemSpacing="0" Height="22px" ForeColor="Black" Font-Size="8pt" Font-Names="Arial">
					<HoverStyle Cursor="Default" BorderWidth="1px" Font-Size="8pt" Font-Names="Arial" BorderColor="Navy"
						BorderStyle="Solid" ForeColor="Black" BackgroundImage="None" BackColor="Bisque"></HoverStyle>
					<SelectedStyle Cursor="Default" BorderWidth="1px" Font-Size="8pt" Font-Names="Arial" BorderColor="Navy"
						BorderStyle="Solid" ForeColor="Black" BackgroundImage="OrangeExplorer.gif" BackColor="Orange"></SelectedStyle>
					<Items>
						<igtbar:TBarButton Text="Ac&#231;&#227;o #1" TargetURL="javascript:alert('hello');" Image="./Design/Image/ActionBar/Activate.gif"></igtbar:TBarButton>
						<igtbar:TBarButton Text="Ac&#231;&#227;o 2#" Image="./Design/Image/ActionBar/Result.gif"></igtbar:TBarButton>
					</Items>
					<DefaultStyle BorderWidth="0px" Font-Size="8pt" Font-Names="Arial" BorderColor="Menu" BorderStyle="Solid"
						ForeColor="Black" BackgroundImage="blueexplorer.gif"></DefaultStyle>
				</igtbar:UltraWebToolbar></P>
			<P>
				<asp:Button id="Button1" runat="server" Text="Button"></asp:Button></P>
			<P>
				<etc:WebToolbarBack id="WebToolbarBack1" runat="server">
					<HoverStyle BackColor="Bisque"></HoverStyle>
					<Items>
						<igtbar:TBarButton Key="Back" Text="Voltar" TargetURL="javascript:if (typeof(Page_ClientValidate) == 'function') Page_ClientValidate();"
							Image="./design/image/actionbar/Back.gif"></igtbar:TBarButton>
					</Items>
				</etc:WebToolbarBack>
				<asp:ValidationSummary id="ValidationSummary1" runat="server"></asp:ValidationSummary></P>
			<P>
				<asp:TextBox id="TextBox1" runat="server"></asp:TextBox>
				<asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ErrorMessage="RequiredFieldValidator"
					ControlToValidate="TextBox1">*</asp:RequiredFieldValidator></P>
			<P>
				<asp:Button id="Button2" runat="server" Text="Button" CausesValidation="False"></asp:Button>
				<SELECT style="WIDTH: 304px">
					<OPTION>ricardo</OPTION>
					<OPTION selected>marco</OPTION>
				</SELECT></P>
			<P>&nbsp;</P>
			<P>
				<igtxt:WebTextEdit id="WebTextEdit1" runat="server" Text="jhgjgjhghj" ReadOnly="True"></igtxt:WebTextEdit></P>
			<P>
				<asp:TextBox id="TextBox2" runat="server" Height="96px" TextMode="MultiLine" Width="328px"></asp:TextBox></P>
			<P>
				<igtxt:WebTextEdit id="WebTextEdit2" runat="server"></igtxt:WebTextEdit></P>
		</form>
	</body>
</HTML>
