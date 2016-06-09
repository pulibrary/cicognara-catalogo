<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
<<<<<<< HEAD
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
=======
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" 
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="3.0" exclude-result-prefixes="xs math xd tei">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>
                <xd:b>Created on:</xd:b> Oct 18, 2015</xd:p>
            <xd:p>
                <xd:b>Author:</xd:b> cwulfman</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    
    <xsl:output method="xml" indent="yes"  encoding="UTF-8"/>
    
    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
                <style type="text/css">
                    
                    @import url(https://fonts.googleapis.com/css?family=Gentium+Basic:400,400italic);
                    @import url(https://fonts.googleapis.com/css?family=Tangerine);
                    
                    
                    /* For debugging and proofing*/
                    span.bibl {
                    border: 1px dotted gray;
                    }
                    
                    span.title {
                    background: rgb(255,255,235);
                    }
                    
                    span.author {
                    background: rgb(235,255,255);    
                    }
                    
                    body {
                    font-family: 'Gentium Basic', serif;
                    
                    }

                    
                    #toc {
                    font-size: small;
                    }
                    
                    div.note {
                    font-size: smaller;
                    }
                    
                    span.title {
                    font-style: italic;
                    }
                    
                    ol.catalog {
                    list-style-type:none;
                    }
                    
                    ol.catalog li { margin: 0 0 6px 0; }
                    
                    span.ciconum {
                    font-weight: bold;
                    padding-right: 5px; 
                    }
                    
                    
                    h1,h2 {
                    font-family: 'Gentium Basic', serif;
                    }
                    
                    .pageBreak{
                    margin: 10px 0 0 0;
                    padding: 10px 0;
                    border-top: 1px dotted #c5c5c5;
                    text-align: right;
                    }
                    
                </style>
            </head>
            <body>
                <xsl:apply-templates select="TEI/text/body" />
            </body>
        </html>
    </xsl:template>
    
    
    
    
    <xsl:template match="tei:div[@type='section']">
        <section>
            <xsl:apply-templates/>
        </section>
    </xsl:template>
    <xsl:template match="tei:pb[@type='cico']">
        <div class="pageBreak">
            <span>
                <xsl:value-of select="@n"/>
            </span>
        </div>
    </xsl:template>
    <xsl:template match="tei:head">
        <head>
            <h2>
                <xsl:apply-templates/>
            </h2>
        </head>
    </xsl:template>
    <xsl:template match="tei:list[@type='catalog']">
        <ol class="catalog">
            <xsl:apply-templates/>
        </ol>
    </xsl:template>
    <xsl:template match="tei:item">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    <xsl:template match="tei:label">
        <xsl:variable name="ciconum">
            <xsl:value-of select="parent::tei:item/@n"/>
        </xsl:variable>
        <a href="entry.html?ciconum={$ciconum}">
            <span class="ciconum">
                <xsl:apply-templates/>
            </span>
        </a>
    </xsl:template>
    <xsl:template match="tei:bibl">
        <span class="bibl">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:author">
        <span class="author">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:note">
        <div class="note">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:title">
        <span class="title">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:pubPlace">
        <span class="pubPlace">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:date">
        <span class="date">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:extent">
        <span class="extent">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
>>>>>>> origin/master
</xsl:stylesheet>