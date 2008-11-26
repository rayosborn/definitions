<?xml version="1.0" encoding="UTF-8"?>

<!--
########### SVN repository information ###################
# $Date$
# $Author$
# $Revision$
# $HeadURL$
# $Id$
########### SVN repository information ###################

Purpose:
	This stylesheet is used to translate the NeXus Definition Language
	specifications into XML Schema (.xsd) files for use in
	validating candidate NeXus data files and also in preparing
	additional application definitions and XML schemas for use by NeXus.

Usage:
	xsltproc nxdl2xsd.xsl $(NX_CLASS).nxdl > $(NX_CLASS).xsd
-->

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:nx="http://definition.nexusformat.org/schema/3.0" 
	xmlns:nxdl="http://www.nexusformat.org" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema">

    <xsl:output method="xml" indent="yes" version="1.0" encoding="UTF-8"/>

    <xsl:template match="/">

<xsl:comment>#########################################################
######	 This xsd file was auto-generated from an NXDL file by an XSLT transformation.  ######
######	 Do NOT edit this XML Schema file.						######
#########################################################</xsl:comment>

		<xsl:element name="xs:schema">
            <xsl:attribute name="nx:xslt_name">nxdl2xsd.xsl</xsl:attribute>
            <xsl:attribute name="nx:xslt_id">$Id$</xsl:attribute>
            <!-- XSLT v2.0 feature: <xsl:attribute name="nx:xsd_created"><xsl:value-of select="fn:current-dateTime()" /></xsl:attribute>-->
            <xsl:attribute name="targetNamespace">http://definition.nexusformat.org/schema/3.0</xsl:attribute>
            <!--<xsl:attribute name="elementFormDefault">qualified</xsl:attribute>-->
		    <!--<xsl:attribute name="attributeFormDefault">qualified</xsl:attribute>-->
			<!-- special case for nxdl:attribute elements 
			     because they have to come before documentation -->
            <xsl:for-each select="nxdl:attribute">
				<xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
                <xsl:apply-templates select="*"/>
			</xsl:for-each>
            <xsl:element name="xs:annotation">
                <xsl:element name="xs:documentation"><!-- NeXus license comes next -->
# NeXus - Neutron, X-ray, and Muon Science Common Data Format
# 
# Copyright (C) 2008 NeXus International Advisory Committee (NIAC)
# 
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
# For further information, see http://www.nexusformat.org
				</xsl:element>
            </xsl:element>
            <xsl:apply-templates select="nxdl:definition"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="nxdl:definition">
        <!-- extends from this NeXus object -->
        <xsl:element name="xs:include">
            <xsl:attribute name="schemaLocation"><xsl:value-of select="@extends"/>.xsd</xsl:attribute>
            <xsl:call-template name="comment">
                <xsl:with-param name="msg"><xsl:value-of select="name()"/> declaration: <xsl:value-of select="@name"/></xsl:with-param>
            </xsl:call-template>
            <xsl:element name="xs:annotation">
                <xsl:element name="xs:documentation">NXDL "<xsl:value-of select="@name"/>" extends the <xsl:value-of select="@extends"/> class</xsl:element>
            </xsl:element>
        </xsl:element>
        <!-- calls these NeXus or application objects -->
        <xsl:call-template name="comment">
            <xsl:with-param name="msg">
                ***** other objects used by this NXDL</xsl:with-param>
        </xsl:call-template>
        <xsl:for-each select="//nxdl:group">
            <xsl:element name="xs:include">
                <xsl:attribute name="schemaLocation"><xsl:value-of select="@type"/>.xsd</xsl:attribute>
                <xsl:element name="xs:annotation">
                    <xsl:element name="xs:documentation">type="<xsl:value-of select="@type"/>" from a group element in the NXDL</xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:for-each>
        <!-- elements that define this object -->
        <xsl:call-template name="comment">
            <xsl:with-param name="msg">
                ***** declarations (attributes, docs, groups, and fields)</xsl:with-param>
        </xsl:call-template>
        <xsl:element name="xs:complexType">
            <xsl:attribute name="name">
                <xsl:value-of select="@name"/>
            </xsl:attribute>
            <xsl:comment>extends: <xsl:value-of select="@extends"/></xsl:comment>
            <xsl:element name="xs:sequence">
                <xsl:apply-templates select="*"/>
            </xsl:element>
            <xsl:if test="count(nxdl:attribute)>0">
                <!-- special case: need to handle nxdl:attribute _after_ the sequence! -->
                <xsl:for-each select="nxdl:attribute">
                    <xsl:element name="xs:attribute">
                        <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
                        <xsl:apply-templates select="@*"/>
                        <xsl:apply-templates select="*"/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:if>
        </xsl:element>
    </xsl:template>

    <!-- nxdl:doc is complete -->
    <xsl:template match="nxdl:docXX" />
    <xsl:template match="nxdl:doc">
        <!-- documentation -->
        <xsl:element name="xs:annotation">
            <xsl:element name="xs:documentation"><xsl:value-of select="."/></xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="nxdl:field">
        <!-- named element declaration -->
        <xsl:element name="xs:element">
            <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
            <xsl:choose>
                <!-- default minOccurs="0" -->
                <xsl:when test="@minOccurs!=''">
                    <xsl:attribute name="minOccurs"><xsl:value-of select="@minOccurs"/></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="minOccurs">0</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <!-- default maxOccurs="unbounded" -->
                <xsl:when test="@maxOccurs!=''">
                    <xsl:attribute name="maxOccurs"><xsl:value-of select="@maxOccurs"/></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="maxOccurs">unbounded</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:call-template name="comment">
                <xsl:with-param name="msg"><xsl:value-of select="name()"/> declaration: <xsl:value-of select="@name"/></xsl:with-param>
            </xsl:call-template>
            <!-- documentation comes before the sequence -->
            <xsl:apply-templates select="nxdl:doc"/>
            <xsl:element name="xs:complexType">
                <xsl:element name="xs:simpleContent">
                    <xsl:element name="xs:extension">
                        <!-- @name is handled already -->
                        <xsl:call-template name="typeAttributeDefaultHandler" >
                            <!-- handle @type attribute -->
							<xsl:with-param name="item">base</xsl:with-param>
                        </xsl:call-template>
                        <!-- dimensions declaration -->
                        <xsl:if test="nxdl:dimensions!=''">
                            <xsl:element name="xs:attribute">
                                <xsl:attribute name="name">dimensions</xsl:attribute>
                                <xsl:call-template name="typeAttributeDefaultHandler" >
                                    <xsl:with-param name="item">type</xsl:with-param>
                                </xsl:call-template>
                                <xsl:apply-templates select="nxdl:dimensions/nxdl:doc"/>
                            </xsl:element>
                        </xsl:if>
                        <!-- special case for nxdl:attribute elements 
                            because they have to come before documentation -->
                        <xsl:for-each select="nxdl:attribute">
                            <xsl:element name="xs:attribute">
                                <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
                                <xsl:call-template name="typeAttributeDefaultHandler" >
                                    <xsl:with-param name="item">type</xsl:with-param>
                                </xsl:call-template>
                               <xsl:apply-templates select="*"/>
                            </xsl:element>
                        </xsl:for-each>
                        <!-- process any sub-elements -->
                        <xsl:for-each select="*">
                            <xsl:if test="name()!='doc'">
                                <xsl:apply-templates select="."/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:element><!-- xs:extension -->
                </xsl:element><!-- xs:simpleContent -->
            </xsl:element><!-- xs:complexType -->
        </xsl:element>
    </xsl:template>
   
    <xsl:template match="nxdl:group">
        <!-- reference to another NX object (requires that object's XSD) -->
        <xsl:call-template name="comment">
            <xsl:with-param name="msg">group declaration</xsl:with-param>
        </xsl:call-template>
        <xsl:element name="xs:element">
            <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
            <!-- 
                2008-11-26: name="{@type}" but now need to allow for multiple instances
                where the name attribute in the XML file is varied.
                How do we report the declaration then?
            -->
            <!-- every xs:element needs a name, make a choice -->
            <xsl:attribute name="name">
                <xsl:choose>
                    <xsl:when test="count(@name)!=0"><xsl:value-of select="@name"/></xsl:when>
                    <xsl:otherwise><xsl:value-of select="@type"/></xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="count(nxdl:field)+count(nxdl:group)>0">
                    <xsl:apply-templates select="nxdl:doc"/>
                    <!-- fields or groups within this group element  -->
                    <xsl:comment> this is part of an <xsl:value-of select="@type"/> object </xsl:comment>
                    <xsl:element name="xs:complexType">
                        <xsl:element name="xs:sequence">
                            <xsl:apply-templates select="nxdl:field|nxdl:group"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <!-- no fields or groups within this group element -->
                    <xsl:call-template name="typeAttributeDefaultHandler" >
                        <xsl:with-param name="item">type</xsl:with-param>
                    </xsl:call-template>
                    <xsl:apply-templates select="nxdl:doc"/>
                    <xsl:comment> - - - no fields or groups below this point - - - </xsl:comment>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>

    <xsl:template match="@units">
        <xsl:attribute name="{name()}">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
    
    <xsl:template match="nxdl:enumeration">
        <!-- enumeration: list of possibilities -->
        <!-- item:        part of an nxdl:enumeration -->
        <xsl:call-template name="comment">
            <xsl:with-param name="msg"><xsl:value-of select="name()"/> declaration</xsl:with-param>
        </xsl:call-template>
        <!-- 
            <xs:simpleType>
            <xs:restriction base="xs:string">
        -->
        <xsl:element name="xs:simpleType">
            <xsl:element name="xs:restriction">
                <xsl:attribute name="base">xs:string</xsl:attribute>
                <xsl:apply-templates select="nxdl:item"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="nxdl:item">
        <xsl:element name="xs:enumeration">
            <xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
        </xsl:element>
	</xsl:template>
    
    <xsl:template name="commentxx" />
    <xsl:template name="comment">
        <xsl:param name="msg"/>
        <!-- put a comment into the XSD (usually before every declaration) -->
        <xsl:comment>+++++ <xsl:value-of select="$msg"/> +++++</xsl:comment>
    </xsl:template>

    <xsl:template name="typeAttributeDefaultHandler">
        <xsl:param name="item"/>
        <xsl:attribute name="{$item}">
            <xsl:choose>
                <!-- default --><xsl:when test="count(@type)=0">nx:NX_CHAR</xsl:when>
                <!-- present --><xsl:otherwise>nx:<xsl:value-of select="@type"/></xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>
    
    <!--leave these templates empty, they are handled by special case code as needed	-->
	<xsl:template match="nxdl:attribute"/>
    <xsl:template match="nxdl:dimensions"/>
    <xsl:template match="@name"/>
    <xsl:template match="@type"/>
    
</xsl:stylesheet>

<!--
http://www.w3schools.com/xsl/xsl_transformation.asp

help about xs:include in XML Schema
http://www.google.com/search?q=xs%3Ainclude+schemaLocation&ie=utf-8&oe=utf-8&aq=t&rls=org.mozilla:en-US:official&client=firefox-a
http://www.amazon.com/Definitive-XML-Schema-Charles-Goldfarb/dp/0130655678
http://www.datypic.com/books/defxmlschema/chapter04.html
http://www.datypic.com/books/defxmlschema/chapter13.html
 -->