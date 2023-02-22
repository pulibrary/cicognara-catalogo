xquery version "3.0" encoding "UTF-8";

declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace dc = "http://purl.org/dc/elements/1.1/";
declare namespace dcterms="http://purl.org/dc/terms/";
declare namespace gettyterms="http://portal.getty.edu/terms/gri/";

let $items := doc("/db/apps/cicognara/data/catalogo.tei.xml")//tei:list[@type='catalog']/tei:item

let $ciconums := for $i in $items return xs:string($i/@n)

let $getty_cicos := for $idno in collection("/db/apps/cicognara/data/getty_tei")//tei:idno[@type='cico']
return xs:string($idno)

(:
for $item in $items
let $cico := xs:string($item/@n)
for $d in $getty_cicos[.= $cico]
return $d
:)

(:let $items := subsequence($items, 1, 50) :)


let $bads :=
for $item in $items 
where not(xs:string($item/@n) = $getty_cicos)
return $item

return 
<tei:list xmlns="http://www.tei-c.org/ns/1.0">
{ for $i in $bads return $i }
</tei:list>

