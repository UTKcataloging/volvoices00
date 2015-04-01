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
  
  <!-- output settings -->  
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>

  <!-- identity transform -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <!--
    add relatedItem[@displayLabel='Project'][@type='host']/location/url
    to all records
  -->
  <xsl:template match="relatedItem[@type='host'][@displayLabel='Project']">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
        <location>
          <url>http://digital.lib.utk.edu/collections/volvoices</url>
        </location>
      </xsl:copy>
  </xsl:template>
  
  <!-- 
    update recordInfo/recordChangeDate to indicate this processing run.
  -->
  <xsl:template match="recordInfo">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <recordChangeDate encoding="edtf">
        <xsl:value-of select="format-date(current-date(),'[Y]-[M,2]-[D,2]')"/>
      </recordChangeDate>
    </xsl:copy>
  </xsl:template>
  
  
</xsl:stylesheet>