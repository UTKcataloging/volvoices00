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
        <xsl:result-document method="xml" href="tifs-missing-modsxml/{$filename}.xml" encoding="UTF-8" indent="yes">
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
        <identifier type="filename">
            <xsl:value-of select="concat(identifier, '.jpeg')" />
        </identifier>
    <!-- Name -->
        <xsl:apply-templates select="name_1"/>
        <xsl:apply-templates select="name_2"/>
    <!-- titleInfo -->
        <titleInfo>
            <xsl:if test="title_initial_article">
                <nonSort>
                    <xsl:value-of select="title_initial_article"/>
                </nonSort>
            </xsl:if>
            <title>
                <xsl:value-of select="title"/>
            </title> 
        </titleInfo>
    <!-- Item Type of Resource -->
        <typeOfResource>still image</typeOfResource>
    <!-- originInfo -->
        <originInfo>
    <!-- Place of Origin -->
            <!-- See notes in subtemplates for explanation of repeated element -->
            <xsl:apply-templates select="place_of_origin"/>
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
        <xsl:if test="extent | form">
            <physicalDescription>
                <xsl:apply-templates select="extent"/>
                <xsl:apply-templates select="form"/>
                <internetMediaType>image/jpeg</internetMediaType>
                <digitalOrigin>reformatted digital</digitalOrigin>
            </physicalDescription>
        </xsl:if>
    <!-- Abstract -->
        <xsl:apply-templates select="abstract"/>
    <!-- Language -->  
        <language>
            <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
        </language>
    <!-- Notes -->
        <xsl:apply-templates select="public_note"/>
        <xsl:apply-templates select="note_provenance"/>
    <!-- Location -->  
        <location>
            <physicalLocation>
                <xsl:value-of select="repository"/>
            </physicalLocation>
        </location>
    <!-- Subject -->  
        <xsl:apply-templates select="subject_topical_1"/>
        <xsl:apply-templates select="subject_topical_2"/>
        <xsl:apply-templates select="subject_topical_3"/>
        <!-- Local Subjects -->
        
        <xsl:for-each select="subject_curriculum">
            <subject displayLabel="Volunteer Voices Curriculum Topics">
                <topic>
                    <xsl:value-of select="."/>
                </topic>
            </subject>
        </xsl:for-each>
        <xsl:for-each select="subject_broad_terms_1|subject_broad_terms_2">
            <subject displayLabel="Broad Topics">
                <topic>
                    <xsl:value-of select="."/>
                </topic>
            </subject>
        </xsl:for-each>
        <xsl:apply-templates select="subject_name_1"/>  
        <xsl:apply-templates select="subject_name_2"/>  
        <xsl:apply-templates select="subject_geographic_1"/>
        <xsl:apply-templates select="subject_geographic_2"/>
        <xsl:apply-templates select="subject_geographic_3"/>
        <xsl:apply-templates select="subject_geographic_4"/>
        <xsl:for-each select="subject_temporal">
            <subject displayLabel="Tennessee Social Studies K-12 Eras in American History">
                <temporal>
                    <xsl:value-of select="."/>
                </temporal>
            </subject>
        </xsl:for-each>
    <!-- relatedItems -->
        <relatedItem type="host" displayLabel="Project">
            <titleInfo>
                <title>
                    <xsl:value-of select="project_title"/>
                </title>
            </titleInfo>
        </relatedItem>
        <xsl:for-each select="collection">
            <relatedItem type="host" displayLabel="Collection">
                <titleInfo>
                    <title>
                        <xsl:value-of select="."/>
                    </title>
                </titleInfo>
                <xsl:if test="collection_identifier">
                    <identifier type="local">
                        <xsl:value-of select="../collection_identifier"/>
                    </identifier>
                </xsl:if>
                <xsl:if test="collection_identifier">
                    <identifier type="local" displayLabel="Accession Number">
                        <xsl:value-of select="../physicalLocation_type_accessionNumber"/>
                    </identifier>
                </xsl:if>
            </relatedItem>
        </xsl:for-each>
        <xsl:for-each select="relatedItem_type_host_title">
            <relatedItem type="host" displayLabel="Is Part Of">
                <titleInfo>
                    <title>
                        <xsl:value-of select="."/>
                    </title>
                </titleInfo>
                <xsl:if test="../relatedItem_type_host_detail_type_issue">
                    <part>
                        <detail type="issue">
                            <number><xsl:value-of select="../relatedItem_type_host_detail_type_issue"/></number>
                        </detail>
                    </part>
                </xsl:if>
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
            <recordContentSource>University of Tennessee, Knoxville. Libraries</recordContentSource>
            <languageOfCataloging>
                <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
            </languageOfCataloging>
            <recordOrigin>Created and edited in general conformance to MODS Guidelines (Version 3.5).</recordOrigin>
            <recordChangeDate encoding="edtf">2015-03-28</recordChangeDate>
        </recordInfo>
    </xsl:template>    
<!-- End Item Record Template -->
    
<!-- SUBTEMPLATES -->
    <xsl:template match="name_1">
            <name type="personal">
                <xsl:if test="../name_authority_1">
                    <xsl:attribute name="authority"><xsl:value-of select="../name_authority_1"/></xsl:attribute>
                    <xsl:attribute name="valueURI"><xsl:value-of select="../name_URI_1"/></xsl:attribute>
                </xsl:if>
                <namePart>
                    <xsl:value-of select="."/>
                </namePart>
                <xsl:if test="../name_role_1">
                    <role>
                        <roleTerm type="text" authority="marcrelator">
                            <xsl:if test="../name_role_1"><xsl:attribute name="valueURI"><xsl:value-of select="../name_role_URI_1"/></xsl:attribute></xsl:if>
                            <xsl:value-of select="../name_role_1"/>                        
                        </roleTerm>
                    </role>
                </xsl:if>
            </name>
    </xsl:template>
    <xsl:template match="name_2">
        <name type="personal">
            <xsl:if test="../name_authority_2">
                <xsl:attribute name="authority"><xsl:value-of select="../name_authority_2"/></xsl:attribute>
                <xsl:attribute name="valueURI"><xsl:value-of select="../name_authority_URI_2"/></xsl:attribute>
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
    <xsl:template match="place_of_origin">
        <place supplied="yes">
            <placeTerm type="text">
            <!-- No authority attribute - currently not available in MODS 3.5 for anything other than country codes - CMH, 3/2015 -->
                <xsl:if test="../place_of_origin_URI">
                    <xsl:attribute name="valueURI">
                        <xsl:value-of select="../place_of_origin_URI"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
            </placeTerm>
        </place>
    </xsl:template>
    <xsl:template match="form">
        <form authority="aat">
            <xsl:attribute name="valueURI"><xsl:value-of select="../form_authority"/></xsl:attribute>
            <xsl:value-of select="."/>
        </form>
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
    <xsl:template match="subject_topical_3">
        <subject>
            <xsl:if test="../subject_topical_authority_3">
                <xsl:attribute name="authority">
                    <xsl:value-of select="../subject_topical_authority_3"/>
                </xsl:attribute>
            </xsl:if> <xsl:if test="../subject_topical_URI_3">
                <xsl:attribute name="valueURI">
                    <xsl:value-of select="../subject_topical_URI_3"/>
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
    <xsl:template match="subject_geographic_1">
        <subject>
            <geographic>
                <xsl:if test="contains(../subject_geographic_URI_1, 'names')">
                    <xsl:attribute name="authority">naf</xsl:attribute>
                    <xsl:attribute name="valueURI"><xsl:value-of select="../subject_geographic_URI_1"/></xsl:attribute>
                </xsl:if>
                <xsl:if test="contains(../subject_geographic_URI_1, 'subjects')">
                    <xsl:attribute name="authority">lcsh</xsl:attribute>
                    <xsl:attribute name="valueURI"><xsl:value-of select="../subject_geographic_URI_1"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
            </geographic>
            <xsl:if test="../subject_geographic_coordinates_1">
                <cartographics>
                    <coordinates>
                        <xsl:value-of select="../subject_geographic_coordinates_1"/>
                    </coordinates>
                </cartographics>
            </xsl:if>
        </subject>        
    </xsl:template>
    <xsl:template match="subject_geographic_2">
        <subject>
            <geographic>
                <xsl:if test="contains(../subject_geographic_URI_2, 'names')">
                    <xsl:attribute name="authority">naf</xsl:attribute>
                    <xsl:attribute name="valueURI"><xsl:value-of select="../subject_geographic_URI_2"/></xsl:attribute>
                </xsl:if>
                <xsl:if test="contains(../subject_geographic_URI_2, 'subjects')">
                    <xsl:attribute name="authority">lcsh</xsl:attribute>
                    <xsl:attribute name="valueURI"><xsl:value-of select="../subject_geographic_URI_2"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
            </geographic>
            <xsl:if test="../subject_geographic_coordinates_2">
                <cartographics>
                    <coordinates>
                        <xsl:value-of select="../subject_geographic_coordinates_2"/>
                    </coordinates>
                </cartographics>
            </xsl:if>
        </subject>        
    </xsl:template>
    <xsl:template match="subject_geographic_3">
        <subject>
            <geographic>
                <xsl:if test="contains(../subject_geographic_URI_3, 'names')">
                    <xsl:attribute name="authority">naf</xsl:attribute>
                    <xsl:attribute name="valueURI"><xsl:value-of select="../subject_geographic_URI_3"/></xsl:attribute>
                </xsl:if>
                <xsl:if test="contains(../subject_geographic_URI_3, 'subjects')">
                    <xsl:attribute name="authority">lcsh</xsl:attribute>
                    <xsl:attribute name="valueURI"><xsl:value-of select="../subject_geographic_URI_3"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
            </geographic>
            <xsl:if test="../subject_geographic_coordinates_3">
                <cartographics>
                    <coordinates>
                        <xsl:value-of select="../subject_geographic_coordinates_3"/>
                    </coordinates>
                </cartographics>
            </xsl:if>
        </subject>        
    </xsl:template>
    <xsl:template match="subject_geographic_4">
        <subject>
            <geographic>
                <xsl:if test="contains(../subject_geographic_URI_4, 'names')">
                    <xsl:attribute name="authority">naf</xsl:attribute>
                    <xsl:attribute name="valueURI"><xsl:value-of select="../subject_geographic_URI_4"/></xsl:attribute>
                </xsl:if>
                <xsl:if test="contains(../subject_geographic_authority_4, 'subjects')">
                    <xsl:attribute name="authority">lcsh</xsl:attribute>
                    <xsl:attribute name="valueURI"><xsl:value-of select="../subject_geographic_URI_4"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
            </geographic>
            <xsl:if test="../subject_geographic_coordinates_4">
                <cartographics>
                    <coordinates>
                        <xsl:value-of select="../subject_geographic_coordinates_4"/>
                    </coordinates>
                </cartographics>
            </xsl:if>
        </subject>        
    </xsl:template>
</xsl:stylesheet>