xquery version "3.0";
declare namespace marc="http://www.loc.gov/MARC21/slim";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace local="cew";

declare function local:secondary-matching-tei()
{
    let $secondary-numbers := doc('/db/cicognara-data/doublenums.xml')//rec/b/text()
    let $empty-tei-items   := for $item in collection('/db/cicognara-data/catalogo')//tei:list[@type='catalog']/tei:item[empty(@corresp)]
                              return xs:string($item/@n)
    let $tei-to-update     := distinct-values($empty-tei-items[.=$secondary-numbers])
    for $item in $tei-to-update
        
        let $primary-candidates := doc('/db/cicognara-data/doublenums.xml')//rec[b=$item]/a/text()
        let $matching-records :=  
            for $candidate in $primary-candidates
            let $rec := doc('/db/cicognara-data/slim-marc.xml')//record[cico = $candidate]
            return $rec/dclib/text()
        for $rec in $matching-records
        order by xs:int($item)
            return
                <update teinum="{$item}" dclib="{$rec}"/>

};

declare function local:primary-wo-marc()
{
    for $rec in doc('/db/cicognara-data/doublenums.xml')//rec
    let $a-records := doc('/db/cicognara-data/slim-marc.xml')//record[cico = $rec/a]
    where empty($a-records)
    return $rec
};

declare function local:primary-with-marc()
{
    for $rec in doc('/db/cicognara-data/doublenums.xml')//rec
    let $a-records := doc('/db/cicognara-data/slim-marc.xml')//record[cico = $rec/a]
    where not(empty($a-records))
    return $rec
};

declare function local:everything()
{
for $double in doc('/db/cicognara-data/doublenums.xml')//rec
    let $a := xs:string($double/a)
    let $b := xs:string($double/b)
    let $a-records := doc('/db/cicognara-data/slim-marc.xml')//record[cico = $a]
    let $b-records := doc('/db/cicognara-data/slim-marc.xml')//record[cico = $b]
    order by $a
    return
        <doubleentry>
            <primary ciconum="{$a}">
                { for $r in $a-records 
                  return 
                    <marc bibid="{$r/@id}" cico="{$r/cico}" dclib="{$r/dclib}"/>
                 }
            </primary>
            <secondary ciconum="{$b}">
                { for $r in $b-records 
                  return 
                    <marc bibid="{$r/@id}" cico="{$r/cico}" dclib="{$r/dclib}"/>
                 }
            </secondary>
        </doubleentry>
 };
 
 let $hits := local:primary-wo-marc()
 for $hit in $hits return string-join(($hit/a,$hit/b),',')