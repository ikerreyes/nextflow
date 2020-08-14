
HowTos
======

Use multiple paths for input
----------------------------

Call nextflow run with ``--input "path1/*.in path2/*.in``

::

    INPUT = Channel.fromPath(params.input.tokenize())

Change Nextflow version
-----------------------

With the :envvar:`NXF_VER` environment variable a different Nextflow version
can be set::

    export NXF_VER=0.20
    nextflow flow script.nf

