---
title: "Invoking Ocamlyacc"
pre: "9. "
weight: 90
---


The usual way to invoke Bison is as follows:


	ocamlyacc filename.mly

Here filename.mly is the grammar file name. The parser file's name is made by replacing the .mly with .ml. Thus, the "ocamlyacc foo.mly" yields foo.ml.


{{%children style="h4" description="true" %}}
