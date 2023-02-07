xquery version "3.0";
declare namespace marc="http://www.loc.gov/MARC21/slim";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace local="http://cicognara.org";

let $corresp-values := doc('/db/cicognara-data/catalogo.tei.xml')//tei:item/@corresp

let $dcl-in-tei := for $value in $corresp-values return tokenize($value, ' ')

let $recs := collection('/db/cicognara-data')//marc:record

let $not-in-tei :=
for $rec in $recs
    let $dclib-field := $rec/marc:datafield[@tag='024' and ./marc:subfield[@code='2'] = 'dclib']
    let $dclibnum := $dclib-field/marc:subfield[@code = 'a']
    where not($dclibnum = $dcl-in-tei)
    return $rec
    
return count($not-in-tei)