xquery version "3.0" encoding "UTF-8";

declare namespace local="http://library.princeton.edu";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace dc = "http://purl.org/dc/elements/1.1/";
declare namespace dcterms="http://purl.org/dc/terms/";
declare namespace gettyterms="http://portal.getty.edu/terms/gri/";

declare function local:docs-from-dclnum($dclnum) {
    let $hits := collection('/db/apps/cicognara/data/getty_tei')//tei:idno[@type= 'dcl'][.=$dclnum]
    for $hit in $hits return $hit/ancestor::tei:TEI
};

let $target_directory := "/tmp/corpora/"

let $items := doc('/db/apps/cicognara/data/catalogo.tei.xml')//tei:list[@type='catalog']/tei:item

let $getty_docs := collection("/db/apps/cicognara/data/getty_tei")/tei:TEI

let $ciconums := distinct-values($getty_docs//tei:idno[@type = 'cico'])
let $dclnums := distinct-values($getty_docs//tei:idno[@type = 'dcl'])


for $item in $items
let $ciconum := xs:string($item/@n)
let $dclnums := 
    if ($item/@corresp) then
        let $toks := tokenize(xs:string($item/@corresp), ' ')
        for $tok in $toks return tokenize($tok, ':')[last()]
    else ()

let $docs :=
    for $dclnum in $dclnums
    return local:docs-from-dclnum($dclnum)

let $corpus :=
<teiCorpus xmlns="http://www.tei-c.org/ns/1.0">
<teiHeader>
    <fileDesc>
        <titleStmt>
            <title>Catalogo Cicognara Number {$ciconum}</title>
        </titleStmt>
        <publicationStmt>
            <publisher>
               <orgName>Digital Cicognara Library</orgName>
               <ref>https://cicognara.org</ref>
            </publisher>
            <idno type="cico">{$ciconum}</idno>
        </publicationStmt>
        <sourceDesc>
            {$item/tei:bibl}
        </sourceDesc>
    </fileDesc>
</teiHeader>
{ $docs }
</teiCorpus>


let $path := concat($target_directory, $ciconum, ".tei.xml")
return file:serialize($corpus, $path,("omit-xml-declaraion=yes", "indent=yes"))

