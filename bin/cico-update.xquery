declare namespace tei="http://www.tei-c.org/ns/1.0";

let $mappings := doc('/Users/cwulfman/repos/github/pulibrary/cicognara-catalogo/bin/mappings.xml')/mappings
let $cat1 := doc('/Users/cwulfman/repos/github/pulibrary/cicognara-catalogo/Catalogo_Cicognara-2.xml')

for $item in $cat1//tei:list[@type='catalog']/tei:item
let $codes := $mappings/map[@ciconum = $item/@n]/@ids
return 
    if ($codes) then
    insert node attribute corresp { for $code in $codes return xs:string($code) } into $item
    else ()
