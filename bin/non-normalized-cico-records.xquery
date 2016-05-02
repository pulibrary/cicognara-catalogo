xquery version "3.0";
declare namespace marc="http://www.loc.gov/MARC21/slim";
declare namespace local="http://cicognara.org";

declare function local:normalized-ciconum($cnum as xs:string)
as xs:string
{
    let $normalized := replace($cnum, '^(\d+).*$', '$1')
    return $normalized
};

let $records := /marc:collection/marc:record
let $myrecords :=
for $record in $records
    let $df024s := $record/marc:datafield[@tag = '024']
    let $f001 := $record/marc:controlfield[@tag = '001']/text()
    let $ciconumfields :=
        $df024s[marc:subfield[@code='2'] = 'cico']/marc:subfield[@code='a']

    let $dclibfields :=
        $df024s[marc:subfield[@code='2'] = 'dclib']/marc:subfield[@code='a']

    return <record f001="{$f001}"> {
    for $ciconum in $ciconumfields
    for $dclibid in $dclibfields
    return
        <join cico="{$ciconum}" normalized="{local:normalized-ciconum($ciconum)}" dclib="{$dclibid}"/>
   } </record>
    
let $badrecords :=
    for $r in $myrecords
    where some $cico in $r/join/@cico satisfies not(matches($cico, '^\d+$'))
    return $r

let $goodrecords := $myrecords except $badrecords
let $bad-dclibs := distinct-values(
    for $f in $badrecords/join/@dclib return $f
)
let $bad-dclibs := for $x in $bad-dclibs return <id>{ $x }</id>

let $good-dclibs := distinct-values(
    for $f in $goodrecords/join/@dclib return $f
)

let $good-dclibs := for $x in $good-dclibs return <id>{ $x }</id>

 (: return  <badids>{ $bad-dclibs except $good-dclibs }</badids> :)
 return <records>{ $badrecords }</records>
    