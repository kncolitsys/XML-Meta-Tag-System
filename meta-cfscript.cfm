<cfsilent>	
	<!---
		Name:CF XML Meta System
		Author: Jonathon Joyce
		Website: http://www.jonathonjoyce.co.uk
		Email: info@jonathonjoyce.co.uk
		Created: September 3, 2009
		Last Updated: September 3, 2009
		Purpose: A simple, easy to use, way of updating your sites meta tags without a database.
	--->
	
	<!--- Set default page title, description and keywords. --->
	<cfparam name="variables.metaTitle" default="" />
	<cfparam name="variables.metaDescription" default="" />
	<cfparam name="variables.metaKeywords" default="" />
	<!--- Set Webroot (either set here, or use an application variable?) --->
	<cfset variables.webRoot = "D:\www\website\">
	
	<!--- Working out what page your on, and therefore what meta values to use. --->
	<cfscript>
		// Create an array from the current page
		arrPathPath = ListToArray(cgi.script_name, '/');
		// If the first part of an array is '.cfm', meaning its not a folder.
		// Then rewrite the array with the 'root' as the folder.
		if(Right(arrPagePath[1], "4") EQ ".cfm"){
			arrPagePath[1] = "root";
			arrPagePath[2] = REReplace(cgi.script_name, "/", "");
		}
		
		if(arrayLen(arrPagePath) gt 1){
			// Set the current page / folder variables from the array
			variables.currentPage = arrPagePath[2];
			variables.currentSection = arrPagePath[1];
			// Set the meta.xml file path.
			variables.metaFilePath = variables.webRoot & 'meta.xml';
		}	
	</cfscript>
	<!--- If the file exists. --->
	<cfif fileExists(variables.metaFilePath)>
		<!--- Read the xml file --->
		<cffile action="read" file="#variables.metaFilePath#" variable="metaFile" />
		<cfscript>
		  // Parse the xml
		  metaXML = XMLParse(metaFile);
		  // If the page is in the meta xml file
		  if(IsDefined(metaXML.Meta.#variables.szSection#.#variables.szPageName#)){
		  	variables.metaTitle = metaXML.Meta[variables.currentSection][variables.currentPage].title.xmlText;
		  	variables.metaDescription = metaXML.Meta[variables.currentSection][variables.currentPage].description.xmlText;
		  	variables.metaKeywords = metaXML.Meta[variables.currentSection][variables.currentPage].keywords.xmlText;
		  }
		  
		  
		</cfscript>
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