# cicognara-catalogo
TEI encoding of Cicognara's catalogo ragionato

This is a TEI-encoded edition of Count Leopoldo Cicognara (1767–1834) (http://viaf.org/viaf/32089985)'s inventory of his library, the _Catalogo ragionato dei libri d’arte e d’antichità_, published in 1821.  It was digitized from the edition produced by http://www.memofonte.it .


## Assigning New DCL Numbers
1. Remove a previously-unused DCL number from [unused_dclnums.txt](unused_dclnums.txt).
2. Edit [catalogo.tei.xml](catalogo.tei.xml) and add the DCL number to the `corresp` attribute of
   the corresponding item, e.g.:
```xml
  <item xml:id="c2d1e11651" n="4035" corresp="dcl:rc8 dcl:634">
```
3. Add the DCL number to the Local Identifier field in Figgy.
