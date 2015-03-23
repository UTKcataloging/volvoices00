# Notes on Repo and of Metadata Remediation
#### last updated February 26, 2015

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
8. Reviewed typeOfResource. Appropriate terms taken from LoC MODS guidelines used. All records have field entered. Uncertain if there are possible situations where using collection attribute is necessary (collection of one type, but particular part digitized is a different type) or manuscripts (handwritten notes). This deeper review of data to be performed later if time allows.
9. Titles: pulled non-sort characters into mods:titleInfo>mods:nonSort. Removed trailing white spaces from mods:title. Abbreviation left as found. Apostrophes removed from full title where used to incidicate suppled title - it was too limited in use, thus messing up sorting and not consistently marking supplied titles. Use of attribute supplied to be reviewed for future practice in place of brackets or apostrophes. Review Cataloging Cultural Objects guidelines for supporting this move.
10. Language: good to see use of zxx for items with no linguistic content. Suspicion that 1721 items marked English are not all English, but there are other instances of items with no linguistic content (photographs) that were simply marked eng. Too timely to review this now as would require item by item viewing. Marked for future guidance and documentation however.
11. Publishers: too much information included in these datapoints; should be just the publishers' names without publisher location information (this gets stored in mods:place). Transcribing the publishers' names as found on the item is assumed and so the values are left as-is. Publisher location information moved from mods:publisher to mods:placeTerm.
12. Publishers cont: geographic content moved to place. Publishers left as is, since should be transcribed directly from source. Publishers that are not publishers but rather hosts - i.e., newspapers and magazines - are being moved to mods:relatedItem@type='host' with any relevant issue/part information put there.
13. Place: mods:place being reconciled with LCNAF. Question of reconciling against GeoNames instead is worth further discussion - boils down to text label versus better URI, dataset API/records. To be discussed as part of digital projects group. 
14.      
