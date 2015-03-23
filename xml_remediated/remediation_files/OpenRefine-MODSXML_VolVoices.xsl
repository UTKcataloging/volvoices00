<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.loc.gov/mods/v3"
        xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd"
        xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        version="2.0">
    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    <xsl:strip-space elements="*"/>

<!-- Create Item Record for each Row, Name Record Filename after Identifier -->
    <xsl:template match="root/row">
    <xsl:variable name="filename" select="identifier"/>
    <xsl:result-document method="xml" href="modsxml/{$filename}.xml" encoding="UTF-8" indent="yes">
        <mods xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd" version="3.5">
            <xsl:call-template name="record"/>
        </mods>
    </xsl:result-document>
    </xsl:template>

<!-- ITEM RECORD -->
    <xsl:template name="record">
    <!-- Item/Record Identifiers -->
        <identifier type="local">
            <xsl:value-of select="identifier" />
        </identifier>
        <xsl:if test="filename">
            <identifier type="filename">
                <xsl:value-of select="identifier_filename"/>
            </identifier>
        </xsl:if>
    <!-- Name -->
        <xsl:apply-templates select="name_personal_1"/>
        <xsl:apply-templates select="name_corporate_1"/>
        <xsl:apply-templates select="name_personal_2"/>
        <xsl:apply-templates select="name_corporate_2"/>
        <xsl:apply-templates select="name_personal_3"/>
        <xsl:apply-templates select="name_corporate_3"/>
    <!-- titleInfo -->
        <titleInfo>
            <xsl:if test="title_initial_article">
                <nonSort>
                    <xsl:value-of select="title_initial_article"/>
                </nonSort>
            </xsl:if>
            <title>
                <xsl:value-of select="title_work"/>
            </title> 
        </titleInfo>
    <!-- Item Type of Resource -->
        <xsl:apply-templates select="item_type"/>
    <!-- originInfo -->
        <originInfo>
    <!-- Place of Origin -->
            <!-- See notes in subtemplates for explanation of repeated element -->
            <xsl:apply-templates select="place_of_origin_1"/>
            <xsl:apply-templates select="place_of_origin_2"/>
    <!-- Publisher -->
            <xsl:for-each select="publisher">
                <publisher>
                    <xsl:value-of select='.'/>
                </publisher>
            </xsl:for-each>
    <!-- Date -->
            <dateCreated>
                <xsl:value-of select="date_text"/>
            </dateCreated>
            <xsl:choose>
                <xsl:when test="date_range_end">
                    <dateCreated encoding="edtf" keyDate="yes" point="start">
                        <xsl:if test="date_qualifier">
                            <xsl:attribute name="qualifier">
                                <xsl:value-of select="date_qualifier"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="date_single"/>
                    </dateCreated>
                    <dateCreated encoding="edtf" keyDate="yes" point="end">
                        <xsl:value-of select="date_range_end"/>
                    </dateCreated>
                </xsl:when>
                <xsl:otherwise>
                    <dateCreated encoding="edtf" keyDate="yes">
                        <xsl:if test="date_qualifier">
                            <xsl:attribute name="qualifier">
                                <xsl:value-of select="date_qualifier"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="date_single"/>
                    </dateCreated>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="date_publication">
                <dateIssued  encoding="edtf" keyDate="yes">
                    <xsl:if test="date_publication_qualifier">
                        <xsl:attribute name="qualifier">
                            <xsl:value-of select="date_publication_qualifier"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="date_publication"/>
                </dateIssued>
            </xsl:if>
        </originInfo>
    <!-- physicalDescription -->
        <xsl:if test="extent | form_1 | form_2 | internet_media_type | digital_origin">
            <physicalDescription>
                <xsl:apply-templates select="extent"/>
                <xsl:apply-templates select="form_1"/>
                <xsl:apply-templates select="form_2"/>
                <xsl:apply-templates select="internet_media_type" />
                <xsl:apply-templates select="digital_origin" />
            </physicalDescription>
        </xsl:if>
    <!-- Abstract -->
        <xsl:apply-templates select="abstract"/>
    <!-- Genre -->
        <xsl:if test="genre">
            <genre>
                <xsl:if test="genre_URI">
                    <xsl:attribute name="authority">lcgft</xsl:attribute>
                    <xsl:attribute name="valueURI"><xsl:value-of select="genre_URI"/></xsl:attribute>
                </xsl:if>
            </genre>
        </xsl:if>
    <!-- Language -->  
        <xsl:apply-templates select="language"/>
    <!-- Notes -->
        <xsl:apply-templates select="public_note"/>
        <xsl:apply-templates select="note_provenance"/>
    <!-- Location -->  
        <location>
            <physicalLocation>
                <xsl:value-of select="repository"/>
            </physicalLocation>
            <xsl:for-each select="location_url_digitalItem">
                <url access="object in context" usage="primary display">
                    <xsl:value-of select="."/>
                </url>
            </xsl:for-each>
            <xsl:if test="location_url_physicalItem">
                <url>
                    <xsl:value-of select="location_url_physicalItem" />
                </url>
            </xsl:if>
            <xsl:if test="subrepository|shelf_locator">
                <holdingSimple>
                    <copyInformation>
                        <xsl:apply-templates select="subrepository"/>
                        <xsl:apply-templates select="shelf_locator"/>
                    </copyInformation>
                </holdingSimple>
            </xsl:if>
        </location>
    <!-- Subject -->  
        <xsl:apply-templates select="subject_topical_1"/>
        <xsl:apply-templates select="subject_topical_2"/>
        <xsl:apply-templates select="subject_name_1"/>  
        <xsl:apply-templates select="subject_name_2"/>  
        <xsl:apply-templates select="subject_name_3"/>  
        <xsl:apply-templates select="subject_geographic"/>
        <xsl:for-each select="subject_temporal">
            <subject>
                <temporal>
                    <xsl:value-of select="."/>
                </temporal>
            </subject>
        </xsl:for-each>
    <!-- relatedItems -->
        <relatedItem type="host" displayLabel="Project">
            <titleInfo>
                <xsl:if test="project_title_initial_article">
                    <nonSort><xsl:value-of select="project_title_initial_article"/></nonSort>
                </xsl:if>
                <title>
                    <xsl:value-of select="project_title"/>
                </title>
            </titleInfo>
            <xsl:if test="project_url">
                <location>
                    <url>
                        <xsl:value-of select="project_url"/>
                    </url>
                </location>
            </xsl:if>
        </relatedItem>
        <xsl:for-each select="collection">
            <relatedItem type="host" displayLabel="Collection">
                <titleInfo>
                    <title>
                        <xsl:value-of select="."/>
                    </title>
                </titleInfo>
            </relatedItem>
        </xsl:for-each>
        <xsl:for-each select="relatedItem_type_host_titlePart">
            <relatedItem type="host">
                <titleInfo>
                    <title>
                        <xsl:value-of select="."/>
                    </title>
                </titleInfo>
            </relatedItem>
        </xsl:for-each>
    <!-- accessCondition -->
        <accessCondition type="use and reproduction">
            <xsl:value-of select="rights"/>
        </accessCondition>
    <!-- recordInfo --> 
        <recordInfo>
            <recordIdentifier>
                <xsl:value-of select="concat('record_', identifier)"/>
            </recordIdentifier>
            <recordContentSource>
                <xsl:value-of select="record_source"/>
            </recordContentSource>
            <languageOfCataloging>
                <languageTerm type="code" authority="iso639-2b">
                    <xsl:value-of select="language_of_cataloging"/>
                </languageTerm>
            </languageOfCataloging>
            <recordOrigin>
                <xsl:value-of select="record_origin"/>
            </recordOrigin>
        </recordInfo>
    </xsl:template>    
<!-- End Item Record Template -->
    
<!-- SUBTEMPLATES -->
    <xsl:template match="name_corporate_1">
            <name type="corporate">
                <xsl:if test="../name_corporate_authority_1">
                    <xsl:attribute name="authority"><xsl:value-of select="../name_corporate_authority_1"/></xsl:attribute>
                    <xsl:attribute name="valueURI"><xsl:value-of select="../name_corporate_URI_1"/></xsl:attribute>
                </xsl:if>
                <namePart>
                    <xsl:value-of select="."/>
                </namePart>
                <xsl:if test="../name_role_1_1">
                    <role>
                        <roleTerm type="text" authority="marcrelator">
                            <xsl:if test="../name_role_1_1"><xsl:attribute name="valueURI"><xsl:value-of select="../name_role_URI_1_1"/></xsl:attribute></xsl:if>
                            <xsl:value-of select="../name_role_1_1"/>                        
                        </roleTerm>
                    </role>
                </xsl:if>
                <xsl:if test="../name_role_1_2">
                    <role>
                        <roleTerm type="text" authority="marcrelator">
                            <xsl:if test="../name_role_1_2"><xsl:attribute name="valueURI"><xsl:value-of select="../name_role_URI_1_2"/></xsl:attribute></xsl:if>
                            <xsl:value-of select="../name_role_1_2"/>                        
                        </roleTerm>
                    </role>
                </xsl:if>
            </name>
    </xsl:template>
    <xsl:template match="name_corporate_2">
        <name type="corporate">
            <xsl:if test="../name_corporate_authority_2">
                <xsl:attribute name="authority"><xsl:value-of select="../name_corporate_authority_2"/></xsl:attribute>
                <xsl:attribute name="valueURI"><xsl:value-of select="../name_corporate_authority_URI_2"/></xsl:attribute>
            </xsl:if>
            <namePart>
                <xsl:value-of select="."/>
            </namePart>
            <xsl:if test="../name_role_2">
                <role>
                    <roleTerm type="text" authority="marcrelator">
                        <xsl:if test="../name_role_2"><xsl:attribute name="valueURI"><xsl:value-of select="../name_role_URI_2"/></xsl:attribute></xsl:if>
                        <xsl:value-of select="../name_role_2"/>                        
                    </roleTerm>
                </role>
            </xsl:if>
        </name>
    </xsl:template>
    <xsl:template match="name_corporate_3">
        <name type="corporate">
            <xsl:if test="../name_corporate_authority_3">
                <xsl:attribute name="authority"><xsl:value-of select="../name_corporate_authority_3"/></xsl:attribute>
                <xsl:attribute name="valueURI"><xsl:value-of select="../name_corporate_authority_URI_3"/></xsl:attribute>
            </xsl:if>
            <namePart>
                <xsl:value-of select="."/>
            </namePart>
            <xsl:if test="../name_role_3">
                <role>
                    <roleTerm type="text" authority="marcrelator">
                        <xsl:if test="../name_role_3"><xsl:attribute name="valueURI"><xsl:value-of select="../name_role_URI_3"/></xsl:attribute></xsl:if>
                        <xsl:value-of select="../name_role_3"/>                        
                    </roleTerm>
                </role>
            </xsl:if>
        </name>
    </xsl:template>
    <xsl:template match="name_personal_1">
        <name type="personal">
            <xsl:if test="../name_personal_authority_1">
                <xsl:attribute name="authority"><xsl:value-of select="../name_personal_authority_1"/></xsl:attribute>
                <xsl:attribute name="valueURI"><xsl:value-of select="../name_personal_URI_1"/></xsl:attribute>
            </xsl:if>
            <namePart>
                <xsl:value-of select="."/>
            </namePart>
            <xsl:if test="../name_role_1_1">
                <role>
                    <roleTerm type="text" authority="marcrelator">
                        <xsl:if test="../name_role_1_1"><xsl:attribute name="valueURI"><xsl:value-of select="../name_role_URI_1_1"/></xsl:attribute></xsl:if>
                        <xsl:value-of select="../name_role_1_1"/>                        
                    </roleTerm>
                </role>
            </xsl:if>
            <xsl:if test="../name_role_1_2">
                <role>
                    <roleTerm type="text" authority="marcrelator">
                        <xsl:if test="../name_role_1_2"><xsl:attribute name="valueURI"><xsl:value-of select="../name_role_URI_1_2"/></xsl:attribute></xsl:if>
                        <xsl:value-of select="../name_role_1_2"/>                        
                    </roleTerm>
                </role>
            </xsl:if>
        </name>
    </xsl:template>
    <xsl:template match="name_personal_2">
        <name type="personal">
            <xsl:if test="../name_personal_authority_2">
                <xsl:attribute name="authority"><xsl:value-of select="../name_personal_authority_2"/></xsl:attribute>
                <xsl:attribute name="valueURI"><xsl:value-of select="../name_personal_authority_URI_2"/></xsl:attribute>
            </xsl:if>
            <namePart>
                <xsl:value-of select="."/>
            </namePart>
            <xsl:if test="../name_role_2">
                <role>
                    <roleTerm type="text" authority="marcrelator">
                        <xsl:if test="../name_role_2"><xsl:attribute name="valueURI"><xsl:value-of select="../name_role_URI_2"/></xsl:attribute></xsl:if>
                        <xsl:value-of select="../name_role_2"/>                        
                    </roleTerm>
                </role>
            </xsl:if>
        </name>
    </xsl:template>
    <xsl:template match="name_personal_3">
        <name type="personal">
            <xsl:if test="../name_personal_authority_3">
                <xsl:attribute name="authority"><xsl:value-of select="../name_personal_authority_3"/></xsl:attribute>
                <xsl:attribute name="valueURI"><xsl:value-of select="../name_personal_authority_URI_3"/></xsl:attribute>
            </xsl:if>
            <namePart>
                <xsl:value-of select="."/>
            </namePart>
            <xsl:if test="../name_role_3">
                <role>
                    <roleTerm type="text" authority="marcrelator">
                        <xsl:if test="../name_role_3"><xsl:attribute name="valueURI"><xsl:value-of select="../name_role_URI_3"/></xsl:attribute></xsl:if>
                        <xsl:value-of select="../name_role_3"/>                        
                    </roleTerm>
                </role>
            </xsl:if>
        </name>
    </xsl:template>
    <xsl:template match="place_of_origin_1">
        <place supplied="yes">
            <placeTerm type="text">
            <!-- No authority attribute - currently not available in MODS 3.5 for anything other than country codes - CMH, 3/2015 -->
                <xsl:if test="../place_of_origin_URI_1">
                    <xsl:attribute name="valueURI">
                        <xsl:value-of select="../place_of_origin_URI_1"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
            </placeTerm>
        </place>
    </xsl:template>
    <xsl:template match="place_of_origin_2">
        <place supplied="yes">
            <placeTerm type="text">
                <!-- No authority attribute - currently not available in MODS 3.5 for anything other than country codes - CMH, 3/2015 -->
                <!-- Place of Origin repeated used to record locations without URIs but the next biggest immediate geographical area does contain a URI and is recorded in first Place of Origin -CMH 3/2015 --> 
                <xsl:if test="../place_of_origin_URI_2">
                    <xsl:attribute name="valueURI">
                        <xsl:value-of select="../place_of_origin_URI_2"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
            </placeTerm>
        </place>
    </xsl:template>
    <xsl:template match="item_type">
        <typeOfResource>
            <xsl:value-of select="."/>
        </typeOfResource>
    </xsl:template>
    <xsl:template match="digitalOrigin">
        <digitalOrigin>
            <xsl:value-of select="."/>
        </digitalOrigin>
    </xsl:template>
    <xsl:template match="form_1">
        <form authority="aat">
            <xsl:attribute name="authority"><xsl:value-of select="../form_URI_1"/></xsl:attribute>
            <xsl:value-of select="."/>
        </form>
    </xsl:template>
    <xsl:template match="form_2">
        <form authority="aat">
            <xsl:attribute name="authority"><xsl:value-of select="../form_URI_2"/></xsl:attribute>
            <xsl:value-of select="."/>
        </form>
    </xsl:template>
    <xsl:template match="internet_media_type">
        <internetMediaType>
            <xsl:value-of select="."/>
        </internetMediaType>
    </xsl:template>
    <xsl:template match="digital_origin">
        <digitalOrigin>
            <xsl:value-of select="."/>
        </digitalOrigin>
    </xsl:template>
    <xsl:template match="extent">
        <extent>
            <xsl:value-of select="."/>
        </extent>
    </xsl:template>
    <xsl:template match="abstract">
        <abstract>
            <xsl:value-of select="."/>
        </abstract>
    </xsl:template>
    <xsl:template match="language">
        <language>
            <languageTerm type="code" authority="iso639-2b">
                <xsl:value-of select="."/>
            </languageTerm>
        </language>
    </xsl:template>
    <xsl:template match="public_note">
        <note>
            <xsl:value-of select="."/>
        </note>
    </xsl:template>
    <xsl:template match="note_provenance">
        <note type="ownership">
            <xsl:value-of select="."/>
        </note>
    </xsl:template>
    <xsl:template match="note_filename">
        <note>
            <xsl:value-of select="."/>
        </note>
    </xsl:template>
    <xsl:template match="subrepository">
            <subLocation>
                <xsl:value-of select="."/>
            </subLocation>
    </xsl:template>
    <xsl:template match="shelf_locator">
        <shelfLocator>
            <xsl:value-of select='.'/>
        </shelfLocator>
    </xsl:template>
    <xsl:template match="subject_topical_1">
        <subject>
            <xsl:if test="../subject_topical_authority_1">
                <xsl:attribute name="authority">
                    <xsl:value-of select="../subject_topical_authority_1"/>
                </xsl:attribute>
            </xsl:if> <xsl:if test="../subject_topical_URI_1">
                <xsl:attribute name="valueURI">
                    <xsl:value-of select="../subject_topical_URI_1"/>
                </xsl:attribute>
            </xsl:if>
            <topic>
                <xsl:value-of select="."/>
            </topic>
        </subject>
    </xsl:template>
    <xsl:template match="subject_topical_2">
        <subject>
            <xsl:if test="../subject_topical_authority_2">
                <xsl:attribute name="authority">
                    <xsl:value-of select="../subject_topical_authority_2"/>
                </xsl:attribute>
            </xsl:if> <xsl:if test="../subject_topical_URI_2">
                <xsl:attribute name="valueURI">
                    <xsl:value-of select="../subject_topical_URI_2"/>
                </xsl:attribute>
            </xsl:if>
            <topic>
                <xsl:value-of select="."/>
            </topic>
        </subject>
    </xsl:template>
    <xsl:template match="subject_name_1">
        <subject>
            <name>
                <xsl:if test="../subject_name_authority_1">
                    <xsl:attribute name="authority">
                        <xsl:value-of select="../subject_name_authority_1"/>
                    </xsl:attribute> <xsl:attribute name="valueURI">
                        <xsl:value-of select="../subject_name_URI_1"/>
                    </xsl:attribute>
                </xsl:if>
                <namePart>
                    <xsl:value-of select="."/>
                </namePart>
            </name>
        </subject>
    </xsl:template>
    <xsl:template match="subject_name_2">
        <subject>
            <name>
                <xsl:if test="../subject_name_authority_2">
                    <xsl:attribute name="authority">
                        <xsl:value-of select="../subject_name_authority_2"/>
                    </xsl:attribute> <xsl:attribute name="valueURI">
                        <xsl:value-of select="../subject_name_URI_2"/>
                    </xsl:attribute>
                </xsl:if>
                <namePart>
                    <xsl:value-of select="."/>
                </namePart>
            </name>
        </subject>
    </xsl:template>
    <xsl:template match="subject_name_3">
        <subject>
            <name>
                <xsl:if test="../subject_name_authority_3">
                    <xsl:attribute name="authority">
                        <xsl:value-of select="../subject_name_authority_3"/>
                    </xsl:attribute> <xsl:attribute name="valueURI">
                        <xsl:value-of select="../subject_name_URI_3"/>
                    </xsl:attribute>
                </xsl:if>
                <namePart>
                    <xsl:value-of select="."/>
                </namePart>
            </name>
        </subject>
    </xsl:template>
    <xsl:template match="subject_geographic">
        <subject>
            <geographic>
                <xsl:if test="contains(../subject_geographic_authority, 'names')">
                    <xsl:attribute name="authority">"naf"</xsl:attribute>
                    <xsl:attribute name="valueURI"><xsl:value-of select="../subject_geographic_authority"/></xsl:attribute>
                </xsl:if>
                <xsl:if test="contains(../subject_geographic_authority, 'subjects')">
                    <xsl:attribute name="authority">"lcsh"</xsl:attribute>
                    <xsl:attribute name="valueURI"><xsl:value-of select="../subject_geographic_authority"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
            </geographic>
            <xsl:if test="../subject_geographic_coordinates">
                <cartographics>
                    <coordinates>
                        <xsl:value-of select="../subject_geographic_coordinates"/>
                    </coordinates>
                </cartographics>
            </xsl:if>
        </subject>        
    </xsl:template>
    <xsl:template name="StreetAddresses">
        <xsl:if test="subject_geographic_hierarchical_street">
            <subject>
                <hierarchicalGeographic>
                    <xsl:apply-templates select="subject_geographic_hierarchical_country"/>
                    <xsl:apply-templates select="subject_geographic_hierarchical_province"/>
                    <xsl:apply-templates select="subject_geographic_hierarchical_state"/>
                    <xsl:apply-templates select="subject_geographic_hierarchical_city"/>
                    <xsl:apply-templates select="subject_geographic_hierarchical_borough"/>
                    <xsl:apply-templates select="subject_geographic_hierarchical_street"/>
                </hierarchicalGeographic>
            </subject>
        </xsl:if>
    </xsl:template>
    <xsl:template match="subject_geographic_hierarchical_country">
        <country>
            <xsl:value-of select="."/>
        </country>
    </xsl:template>
    <xsl:template match="subject_geographic_hierarchical_province">
        <province>
            <xsl:value-of select="."/>
        </province>
    </xsl:template>
    <xsl:template match="subject_geographic_hierarchical_state">
        <state>
            <xsl:value-of select="."/>
        </state>
    </xsl:template>
    <xsl:template match="subject_geographic_hierarchical_city">
        <city>
            <xsl:value-of select="."/>
        </city>
    </xsl:template>
    <xsl:template match="subject_geographic_hierarchical_borough">
        <city>
            <xsl:value-of select='concat("Borough: ", .)'/>
        </city>
    </xsl:template>
    <xsl:template match="subject_geographic_hierarchical_street">
        <citySection>
            <xsl:value-of select='concat("Street: ", .)'/>
        </citySection>
    </xsl:template>
</xsl:stylesheet>