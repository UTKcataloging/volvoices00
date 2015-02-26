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
5. Reviewing note types now - all are local creations. Seeing where best to put this data.  
