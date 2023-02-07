<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    exclude-result-prefixes="xs xd marc"
    version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> May 4, 2016</xd:p>
            <xd:p><xd:b>Author:</xd:b> cwulfman</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:template match="marc:collection">
        <collection>
            <xsl:apply-templates />
        </collection>
    </xsl:template>
    
    <xsl:template match="marc:record">
        <record id="{marc:controlfield[@tag='001']}">
            <xsl:apply-templates select="marc:datafield[@tag='024']" />
        </record>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag='024']">
        <xsl:variable name="fname">
            <xsl:choose>
                <xsl:when test="marc:subfield[@code='2']">
                    <xsl:value-of select="marc:subfield[@code='2']"/>
                </xsl:when>
                <xsl:otherwise>ERROR</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="{$fname}">
            <xsl:value-of select="marc:subfield[@code='a']"/>
        </xsl:element>
        
    </xsl:template>
    
</xsl:stylesheet>