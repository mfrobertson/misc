# Xivcite

Auto-citation product for use in LaTeX using just arXiv ID. References are taken using the 
[iNSPIREHEP](https://inspirehep.net/) REST API.

### Set up
Setup is simple
- Place ```xivcite.sh``` in same directory as the ```.tex``` file
- Add the following line to the ```.tex``` file anywhere before ```\begin{document}```
  ```
  \input{|./xivcite.sh \jobname.tex <bibfile>}
  ```
- Ensure ```--enable-write18``` flag is passed at compile time (sometimes ```--shell-escape```
depending on TeX distribution).
### Usage
Now any desired citations can be automatically added to the chosen ```<bibfile>``` through the familiar command 
```
\cite{?<arXiv_ID>}
```
The ```?``` preceeding ```<arXiv_ID>``` is important. LaTeX may need to be compiled twice for references to be updated.

### Example
A very simple ```example.tex``` file is provided along with the resulting ```.pdf``` and ```.bib``` files 
generated automatically by ```xivcite```.