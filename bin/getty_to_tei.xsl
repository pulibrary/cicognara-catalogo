<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:local="http://library.princeton.edu"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" 
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/" 
    xmlns:gettyterms="http://portal.getty.edu/terms/gri/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs math xd tei" version="3.0">
    <xsl:output indent="yes"/>
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jan 26, 2023</xd:p>
            <xd:p><xd:b>Author:</xd:b> cwulfman</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    
    <xsl:function name="local:clean-cico-num">
        <xsl:param name="cicostring" as="xs:string" />
        <xsl:analyze-string select="$cicostring"
            regex="^(\d+).*">
            <xsl:matching-substring>
                <xsl:value-of select="regex-group(1)"/>
            </xsl:matching-substring>
        </xsl:analyze-string>
        
    </xsl:function>
    
    <xsl:template match="/">
        <xsl:apply-templates select="dc:record" mode="standalone" />
    </xsl:template>
    
    <xsl:template match="dc:record" mode="standalone">
        <TEI xmlns="http://www.tei-c.org/ns/1.0">
            <teiHeader>
                <fileDesc>
                    <xsl:call-template name="titleStmt" />
                    <xsl:call-template name="publicationStmt" />
                    <xsl:call-template name="sourceStmt" />
                </fileDesc>
            </teiHeader>
            <xsl:apply-templates select="dcterms:hasFormat" mode="facsimile" />
        </TEI>
    </xsl:template>

    <xsl:template match="dc:record">
        <biblFull xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:call-template name="titleStmt"/>
            <xsl:call-template name="publicationStmt"/>
            <xsl:call-template name="sourceStmt" />
        </biblFull>
    </xsl:template>

    <xsl:template name="titleStmt">
        <titleStmt xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates select="dc:title"/>
            <xsl:apply-templates select="gettyterms:grpContributor" />
        </titleStmt>
    </xsl:template>

    <xsl:template name="publicationStmt_srce">
        <publicationStmt xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates select="dc:publisher"/>
            <xsl:apply-templates select="dcterms:issued"/>
            <xsl:apply-templates select="dc:identifier" />
        </publicationStmt>
    </xsl:template>
    
    <xsl:template name="publicationStmt">
        <publicationStmt xmlns="http://www.tei-c.org/ns/1.0">
            <publisher>
                <orgName>Digital Cicognara Library</orgName>
                <ref>https://cicognara.org/</ref>
            </publisher>
            <xsl:apply-templates select="dc:contributor" />
            <xsl:apply-templates select="dc:identifier" />
        </publicationStmt>
    </xsl:template>
    
    <xsl:template name="sourceStmt">
        <sourceDesc xmlns="http://www.tei-c.org/ns/1.0">
            <biblStruct>
                <monogr>
                    <xsl:apply-templates select="dc:title"/>
                    <xsl:apply-templates select="dc:creator"/>
                    <xsl:apply-templates select="dc:language" />
                    <imprint>
                        <xsl:apply-templates select="dc:publisher"/>
                        <xsl:apply-templates select="dcterms:spatial" />
                        <xsl:apply-templates select="dcterms:issued" />
                    </imprint>
                    <xsl:apply-templates select="dcterms:extent" />
                </monogr>
                <relatedItem type="manifest">
                    <xsl:attribute name="target">
                        <xsl:apply-templates select="dcterms:hasFormat" />
                    </xsl:attribute>
                </relatedItem>
            </biblStruct>
        </sourceDesc>
    </xsl:template>

    <xsl:template match="dc:creator">
        <respStmt xmlns="http://www.tei-c.org/ns/1.0">
            <persName>
                <xsl:apply-templates/>
            </persName>
            <resp>creator</resp>
        </respStmt>
    </xsl:template>
    
    <xsl:template match="dc:contributor">
        <authority xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates />
        </authority>
    </xsl:template>
    
    <xsl:template match="dc:language">
        <textLang  xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates />
        </textLang>
    </xsl:template>

    <xsl:template match="dc:source">
        <authority xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates />
        </authority>
    </xsl:template>

    <xsl:template match="dcterms:extent">
        <extent xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates/>
        </extent>
    </xsl:template>

    <xsl:template match="gettyterms:grpContributor">
        <respStmt xmlns="http://www.tei-c.org/ns/1.0">
            <orgName>
                <xsl:apply-templates/>
            </orgName>
            <resp>contributor</resp>
        </respStmt>
    </xsl:template>
    
    <xsl:template match="dcterms:hasFormat" mode="facsimile">
        <facsimile  xmlns="http://www.tei-c.org/ns/1.0">
            <media mimeType="application/json">
                <xsl:attribute name="url">
                    <xsl:apply-templates />
                </xsl:attribute>
                <desc>IIIF Manifest</desc>
            </media>
        </facsimile>
    </xsl:template>
    
    <xsl:template match="dc:identifier[@xsi:type='URI']">
        <idno  xmlns="http://www.tei-c.org/ns/1.0" type="URI">
            <xsl:apply-templates />
        </idno>
    </xsl:template>
    
    <xsl:template match="dc:identifier">
        <xsl:variable name="elvalue" select="."/>
        
        <xsl:analyze-string select="$elvalue" 
            regex="^(.*?):(.*)$">
            <xsl:matching-substring>
                <xsl:variable name="type" select="regex-group(1)"/>
                <idno  xmlns="http://www.tei-c.org/ns/1.0" type="{$type}">
                    <xsl:choose>
                        <xsl:when test="$type = 'cico'">
                            <xsl:value-of select="local:clean-cico-num(regex-group(2))"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="regex-group(2)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </idno>               
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <idno  xmlns="http://www.tei-c.org/ns/1.0">
                    <xsl:value-of select="$elvalue"/>
                </idno>
            </xsl:non-matching-substring>
            
        </xsl:analyze-string>

    </xsl:template>
    
    <xsl:template match="dcterms:issued">
        <date xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates/>
        </date>
    </xsl:template>

    <xsl:template match="dc:publisher">
        <publisher xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates/>
        </publisher>
    </xsl:template>
    
    <xsl:template match="dcterms:spatial">
        <pubPlace xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates />
        </pubPlace>
    </xsl:template>

    <xsl:template match="dc:title">
        <title xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates/>
        </title>
    </xsl:template>

</xsl:stylesheet>
