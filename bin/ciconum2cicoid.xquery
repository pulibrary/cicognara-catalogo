xquery version "3.0";
(:
 : Module Name: ciconum2cicoid
 : Module Version: 1.0
 : Date: April 22, 2016
 : Module Overview: Apply to cicognara.mrx.xml to get 
 :  a mapping of Cicognara numbers to Digital Cicognara
 :  Library identifiers.
 : Author: Cliff Wulfman <cwulfman@princeton.edu>
 :)


declare namespace marc="http://www.loc.gov/MARC21/slim";
declare namespace local="http://cicognara.org";

declare function local:normalized-ciconum($cnum as xs:string)
as xs:string
{
    let $normalized := replace($cnum, '^(\d+).*$', '$1')
    return $normalized
};

declare function local:num-id-map($record as element())
as element()+
{
    let $df024s := $record/marc:datafield[@tag = '024']
    let $f001 := $record/marc:controlfield[@tag = '001']/text()
    let $ciconumfields :=
        $df024s[marc:subfield[@code='2'] = 'cico']/marc:subfield[@code='a']

    let $dclibfields :=
        $df024s[marc:subfield[@code='2'] = 'dclib']/marc:subfield[@code='a']


    for $ciconum in $ciconumfields
    for $dclid in $dclibfields
    return
        <cmap num="{local:normalized-ciconum($ciconum)}" id="{$dclid}"/>
};

let $maps := <cmaps>{ 
    for $record in /marc:collection/marc:record
    return local:num-id-map($record)
    }</cmaps>
    
return <mappings>{
for $num in distinct-values($maps/cmap/@num)
    order by $num
    let $matches := $maps/cmap[@num = $num]
    return <map ciconum="{$num}" ids="{distinct-values($matches/@id)}"/>
   }</mappings>