<cfsilent>	
	<!---
		Title:CF XML Meta System
		Build: 0.0.1
		Website: http://www.jonathonjoyce.co.uk
	--->
	
	<!--- Set default page title, description and keywords. --->
	<cfparam name="variables.metaTitle" default="" />
	<cfparam name="variables.metaDescription" default="" />
	<cfparam name="variables.metaKeywords" default="" />
	<!--- Set Webroot (either set here, or use an application variable?) --->
	<cfset variables.webRoot = "D:\www\website\">
	
	<!--- Working out what page your on, and therefore what meta values to use. --->
	<!--- Create an array from the current page --->
	<cfset arrPagePath = ListToArray(cgi.script_name, '/')>
	
	<!--- If the first part of an array is '.cfm', meaning its not a folder, 
		then rewrite the array with the 'root' as the folder. --->
	<cfif Right(arrPagePath[1], "4") EQ ".cfm">
		<cfset arrPagePath[1] = "root">
		<cfset arrPagePath[2] = REReplace(cgi.script_name, "/", "")>
	</cfif>
	
	<cfif arrayLen(arrPagePath) gt 1>
		<!--- Set the current page / folder variables from the array --->
		<cfset variables.currentPage = arrPagePath[2] />
		<cfset variables.currentSection = arrPagePath[1] />
		<!--- Set the meta.xml file path. --->
		<cfset variables.metaFilePath = variables.webRoot & 'meta.xml'>
		<!--- If the file exists. --->
		<cfif fileExists(variables.metaFilePath)>
			<!--- Read the xml file --->
			<cffile action="read" file="#variables.metaFilePath#" variable="metaFile" />
			<!--- Parse the xml --->
			<cfset metaXML = XMLParse(metaFile)>
			<!--- If the page is in the meta xml file --->
			<cfif IsDefined(metaXML.Meta.#variables.szSection#.#variables.szPageName#)>
				<!--- Set the meta variables from the xml --->
				<cfset variables.metaTitle = metaXML.Meta[variables.currentSection][variables.currentPage].title.xmlText>
				<cfset variables.metaDescription = metaXML.Meta[variables.currentSection][variables.currentPage].description.xmlText>
				<cfset variables.metaKeywords = metaXML.Meta[variables.currentSection][variables.currentPage].keywords.xmlText>
			</cfif>
		</cfif>
	</cfif>
</cfsilent>

<!--- Output Data --->
<cfoutput>
	<title>#variables.metaTitle#</title>
	<meta name="author" content="Company Name - Website URL" />
	<meta name="copyright" content="Copyright (c) #Year(Now())# - Company Name" />
	<meta name="description" content="#variables.szContent#" />
	<meta name="keywords" content="#LCase(variables.szKeywords)#" />
</cfoutput>