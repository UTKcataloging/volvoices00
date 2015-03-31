<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.loc.gov/mods/v3"
  xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  exclude-result-prefixes="#all"
  xpath-default-namespace="http://www.loc.gov/mods/v3" 
  version="2.0">

  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>
  
  <!-- initial template -->
  <xsl:template name="main">
    <!-- proc. MODS in their current directories -->
    <xsl:for-each select="collection('modsxml/?select=*.xml;on-error=warning')
                          | collection('tifs-missing-modsxml/?select=*.xml;on-error=warning')">
      
      <xsl:variable name="vName0" 
        select="if (ends-with(/mods/identifier[@type='local'],'_0001')) 
                then (string(/mods/identifier[@type='local']))
                else (replace(string(/mods/identifier[@type='local']),'_0000','_0001'))"/>
      <!-- call template for MODS in modsxml/ -->
      <xsl:if test="matches(base-uri(.),'/modsxml/')">
        <xsl:call-template name="update-modsxml"/>
      </xsl:if>
      
      <!-- call template for MODS in tifs-missing-modsxml/ -->
      <xsl:if test="matches(base-uri(.),'/tifs-missing-modsxml/')">
        <xsl:call-template name="update-tifs-missing"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  
  <!-- process the MODS in modsxml/ -->
  <xsl:template name="update-modsxml">
    <xsl:variable name="vName-um" select="concat(mods/identifier[@type='local'],'.xml')"/>
    <xsl:result-document href="updated-all/{$vName-um}" method="xml" encoding="UTF-8" 
      xpath-default-namespace="http://www.loc.gov/mods/v3">
      <xsl:apply-templates/>
    </xsl:result-document>
  </xsl:template>
  
  <!-- get most everything for modsxml/ -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- update identifier[@type='filename'] for modsxml/ -->
  <xsl:template match="mods/identifier[@type='filename']">
    <identifier type="filename">
      <xsl:value-of select="replace(.,'jpeg','jp2')"/>
    </identifier>
  </xsl:template>
  
  <!-- 
    update recordInfo/recordChangeDate to indicate this processing run.
    this will affect both sets of files.
  -->
  <xsl:template match="recordInfo">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <recordChangeDate encoding="edtf">
        <xsl:value-of select="format-date(current-date(),'[Y]-[M,2]-[D,2]')"/>
      </recordChangeDate>
    </xsl:copy>
  </xsl:template>
  
  <!-- process the MODS in tifs-missing-modsxml/ -->
  <xsl:template name="update-tifs-missing">
    <xsl:variable name="vName-tmm" select="concat(replace(mods/identifier[@type='local'],'_0000$','_0001'),'.xml')"/>
    <xsl:result-document href="updated-all/{$vName-tmm}" method="xml" encoding="UTF-8"
      xpath-default-namespace="http://www.loc.gov/mods/v3">
      <xsl:apply-templates/>
    </xsl:result-document>
  </xsl:template>
  
  <!-- 
    1. update the value in identifier[@type='local] from _0000 to _0001.
    2. add an identifier[@type='filename']
    these changes only impact the files in tifs-missing-modsxml/ 
  -->
  <xsl:template match="identifier[@type='local'][ends-with(.,'_0000')]">
    <xsl:variable name="vNewID" select="replace(.,'_0000$','_0001')"/>
    <identifier type="local">
      <xsl:value-of select="$vNewID"/>
    </identifier>
    <identifier type="filename">
      <xsl:value-of select="concat($vNewID,'.jp2')"/>
    </identifier>
  </xsl:template>
  
  <!-- correct the value of recordInfo/recordIdentifier for the files in tif-missing-modsxml/ -->
  <xsl:template match="recordIdentifier[ends-with(.,'_0000')]">
    <recordIdentifier>
      <xsl:value-of select="replace(.,'_0000$','_0001')"/>
    </recordIdentifier>
  </xsl:template>
</xsl:stylesheet>
