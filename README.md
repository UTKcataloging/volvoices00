# About this Silly Repo
#### February 6, 2015

---

This repo contains the o.g. MODS for images from Volvoices.

### Detailed metadata remediation/change history/questions:

---

1. Edited original XML records to be valid XML - they contained characters outside of elements (namely \n in about 12 records). The updated files were put into new subdirectory, xml_remediated. 
2. All of these files were combined into 1 xml with exterior wrapper modsCollection. This was used for generated OpenRefine project. Combined records and the OR project were put into the xml_remediated/remediation_files subdirectory.
3. In OpenRefine, external wrappers (modsCollection, mods) were removed for working with flat(er) data. 
4. All mods:genre terms reconciled with AAT alone, URIs added for terms. MARCGT terms mapped to AAT for sake of consistency.
5. Removing mods:note@type=museumCredit - very limited use, in 1 instance was for a publisher not a museum, in another instance was for a Special Collections repostiory. Reproduces data already parsed and available in mods:locaion and mods:originInfo>mods:publisher (among other relevant datapoints). Does not appear to be indexed or even displayed in current public interface regardless.
6. Abstracts - minor remediation (removing of trailing white space, skimmed for errors). No real repairs done currently; will use for filling out missing datapoints in other elements (location, date, etc) where possible.
7. Rights statement: type should be type='use and reproduction' not type='useAndReproduction', although if this is needed for mapping the preliminary phrase 'For current rights information, please visit: ' to that datapoint, can be left as is. Will need to be decided on larger scale for interoperability with other collections. According LoC recommendation, phrase include spaces/is all lower-cased.
8.     
