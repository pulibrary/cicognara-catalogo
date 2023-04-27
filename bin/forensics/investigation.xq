xquery version "3.0" encoding "UTF-8";

(:~
 : This query compares the TEI-encoded edition of Cicognara's
 : Catalogo with the TEI encoding of the Getty records and returns
 : a list of all the Catalogo items that do not have a corresponding
 : record in the Getty.  It compares the cico number
 :)

declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace dc = "http://purl.org/dc/elements/1.1/";
declare namespace dcterms="http://purl.org/dc/terms/";
declare namespace gettyterms="http://portal.getty.edu/terms/gri/";


(:
 : Get the cico numbers from the Catalogo
 :)
let $items := doc("/db/apps/cicognara/data/catalogo.tei.xml")//tei:list[@type='catalog']/tei:item

let $ciconums := for $i in $items return xs:string($i/@n)

(:
 : Get the cico numbers from the Getty records
 :)
let $getty_cicos := for $idno in collection("/db/apps/cicognara/data/getty_tei")//tei:idno[@type='cico']
return xs:string($idno)


(:
 : Select the Catalogo items whose cico number is not
 : in the list of Getty cico numbers.
 :)
let $bads :=
    for $item in $items 
    where not(xs:string($item/@n) = $getty_cicos)
    return $item

return 
    <tei:list xmlns="http://www.tei-c.org/ns/1.0">
        { for $i in $bads return $i }
    </tei:list>

