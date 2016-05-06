xquery version "3.0";
declare namespace tei="http://www.tei-c.org/ns/1.0";

let $updates := doc('/Users/cwulfman/repos/github/pulibrary/cicognara-catalogo/tei-updates.xml')//update
let $cat := doc('/Users/cwulfman/repos/github/pulibrary/cicognara-catalogo/Catalogo_Cicognara-2.xml')

for $update in $updates
let $item := $cat//tei:list[@type='catalog']/tei:item[@n=$update/@teinum]
return
    if ($item) then
    insert node attribute corresp { xs:string($update/@dclib) } into $item
    else ()
