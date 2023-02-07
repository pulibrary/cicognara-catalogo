<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs xd tei" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> May 2, 2016</xd:p>
            <xd:p><xd:b>Author:</xd:b> cwulfman</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>

    <xsl:template match="tei:list[@type='catalog']/tei:item">
        <xsl:element name="item" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="xml:id">
                <xsl:value-of select="concat('c1',generate-id(.))"/>
            </xsl:attribute>
            <xsl:copy-of select="@*[not(name() = 'xml:id')]" />
            <xsl:apply-templates select="node()" />
        </xsl:element>
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
